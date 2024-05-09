1 // SPDX-License-Identifier: agpl-3.0
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @title Proxy
6  * @dev Implements delegation of calls to other contracts, with proper
7  * forwarding of return values and bubbling of failures.
8  * It defines a fallback function that delegates all calls to the address
9  * returned by the abstract _implementation() internal function.
10  */
11 abstract contract Proxy {
12   /**
13    * @dev Fallback function.
14    * Implemented entirely in `_fallback`.
15    */
16   fallback() external payable {
17     _fallback();
18   }
19 
20   /**
21    * @return The Address of the implementation.
22    */
23   function _implementation() internal view virtual returns (address);
24 
25   /**
26    * @dev Delegates execution to an implementation contract.
27    * This is a low level function that doesn't return to its internal call site.
28    * It will return to the external caller whatever the implementation returns.
29    * @param implementation Address to delegate.
30    */
31   function _delegate(address implementation) internal {
32     //solium-disable-next-line
33     assembly {
34       // Copy msg.data. We take full control of memory in this inline assembly
35       // block because it will not return to Solidity code. We overwrite the
36       // Solidity scratch pad at memory position 0.
37       calldatacopy(0, 0, calldatasize())
38 
39       // Call the implementation.
40       // out and outsize are 0 because we don't know the size yet.
41       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
42 
43       // Copy the returned data.
44       returndatacopy(0, 0, returndatasize())
45 
46       switch result
47       // delegatecall returns 0 on error.
48       case 0 {
49         revert(0, returndatasize())
50       }
51       default {
52         return(0, returndatasize())
53       }
54     }
55   }
56 
57   /**
58    * @dev Function that is run as the first thing in the fallback function.
59    * Can be redefined in derived contracts to add functionality.
60    * Redefinitions must call super._willFallback().
61    */
62   function _willFallback() internal virtual {}
63 
64   /**
65    * @dev fallback implementation.
66    * Extracted to enable manual triggering.
67    */
68   function _fallback() internal {
69     _willFallback();
70     _delegate(_implementation());
71   }
72 }
73 
74 /**
75  * @dev Collection of functions related to the address type
76  */
77 library Address {
78   /**
79    * @dev Returns true if `account` is a contract.
80    *
81    * [IMPORTANT]
82    * ====
83    * It is unsafe to assume that an address for which this function returns
84    * false is an externally-owned account (EOA) and not a contract.
85    *
86    * Among others, `isContract` will return false for the following
87    * types of addresses:
88    *
89    *  - an externally-owned account
90    *  - a contract in construction
91    *  - an address where a contract will be created
92    *  - an address where a contract lived, but was destroyed
93    * ====
94    */
95   function isContract(address account) internal view returns (bool) {
96     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
97     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
98     // for accounts without code, i.e. `keccak256('')`
99     bytes32 codehash;
100     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
101     // solhint-disable-next-line no-inline-assembly
102     assembly {
103       codehash := extcodehash(account)
104     }
105     return (codehash != accountHash && codehash != 0x0);
106   }
107 
108   /**
109    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
110    * `recipient`, forwarding all available gas and reverting on errors.
111    *
112    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
113    * of certain opcodes, possibly making contracts go over the 2300 gas limit
114    * imposed by `transfer`, making them unable to receive funds via
115    * `transfer`. {sendValue} removes this limitation.
116    *
117    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
118    *
119    * IMPORTANT: because control is transferred to `recipient`, care must be
120    * taken to not create reentrancy vulnerabilities. Consider using
121    * {ReentrancyGuard} or the
122    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
123    */
124   function sendValue(address payable recipient, uint256 amount) internal {
125     require(address(this).balance >= amount, 'Address: insufficient balance');
126 
127     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
128     (bool success, ) = recipient.call{value: amount}('');
129     require(success, 'Address: unable to send value, recipient may have reverted');
130   }
131 }
132 
133 /**
134  * @title BaseUpgradeabilityProxy
135  * @dev This contract implements a proxy that allows to change the
136  * implementation address to which it will delegate.
137  * Such a change is called an implementation upgrade.
138  */
139 contract BaseUpgradeabilityProxy is Proxy {
140   /**
141    * @dev Emitted when the implementation is upgraded.
142    * @param implementation Address of the new implementation.
143    */
144   event Upgraded(address indexed implementation);
145 
146   /**
147    * @dev Storage slot with the address of the current implementation.
148    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
149    * validated in the constructor.
150    */
151   bytes32 internal constant IMPLEMENTATION_SLOT =
152     0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
153 
154   /**
155    * @dev Returns the current implementation.
156    * @return impl Address of the current implementation
157    */
158   function _implementation() internal view override returns (address impl) {
159     bytes32 slot = IMPLEMENTATION_SLOT;
160     //solium-disable-next-line
161     assembly {
162       impl := sload(slot)
163     }
164   }
165 
166   /**
167    * @dev Upgrades the proxy to a new implementation.
168    * @param newImplementation Address of the new implementation.
169    */
170   function _upgradeTo(address newImplementation) internal {
171     _setImplementation(newImplementation);
172     emit Upgraded(newImplementation);
173   }
174 
175   /**
176    * @dev Sets the implementation address of the proxy.
177    * @param newImplementation Address of the new implementation.
178    */
179   function _setImplementation(address newImplementation) internal {
180     require(
181       Address.isContract(newImplementation),
182       'Cannot set a proxy implementation to a non-contract address'
183     );
184 
185     bytes32 slot = IMPLEMENTATION_SLOT;
186 
187     //solium-disable-next-line
188     assembly {
189       sstore(slot, newImplementation)
190     }
191   }
192 }
193 
194 /**
195  * @title BaseImmutableAdminUpgradeabilityProxy
196  * @author Sturdy, inspiration from Aave
197  * @dev This contract combines an upgradeability proxy with an authorization
198  * mechanism for administrative tasks. The admin role is stored in an immutable, which
199  * helps saving transactions costs
200  * All external functions in this contract must be guarded by the
201  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
202  * feature proposal that would enable this to be done automatically.
203  */
204 contract BaseImmutableAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
205   address immutable ADMIN;
206 
207   constructor(address admin) {
208     ADMIN = admin;
209   }
210 
211   modifier ifAdmin() {
212     if (msg.sender == ADMIN) {
213       _;
214     } else {
215       _fallback();
216     }
217   }
218 
219   /**
220    * @return The address of the proxy admin.
221    */
222   function admin() external ifAdmin returns (address) {
223     return ADMIN;
224   }
225 
226   /**
227    * @return The address of the implementation.
228    */
229   function implementation() external ifAdmin returns (address) {
230     return _implementation();
231   }
232 
233   /**
234    * @dev Upgrade the backing implementation of the proxy.
235    * Only the admin can call this function.
236    * @param newImplementation Address of the new implementation.
237    */
238   function upgradeTo(address newImplementation) external ifAdmin {
239     _upgradeTo(newImplementation);
240   }
241 
242   /**
243    * @dev Upgrade the backing implementation of the proxy and call a function
244    * on the new implementation.
245    * This is useful to initialize the proxied contract.
246    * @param newImplementation Address of the new implementation.
247    * @param data Data to send as msg.data in the low level call.
248    * It should include the signature and the parameters of the function to be called, as described in
249    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
250    */
251   function upgradeToAndCall(address newImplementation, bytes calldata data)
252     external
253     payable
254     ifAdmin
255   {
256     _upgradeTo(newImplementation);
257     (bool success, ) = newImplementation.delegatecall(data);
258     require(success);
259   }
260 
261   /**
262    * @dev Only fall back when the sender is not the admin.
263    */
264   function _willFallback() internal virtual override {
265     require(msg.sender != ADMIN, 'Cannot call fallback function from the proxy admin');
266     super._willFallback();
267   }
268 }
269 
270 /**
271  * @title InitializableUpgradeabilityProxy
272  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
273  * implementation and init data.
274  */
275 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
276   /**
277    * @dev Contract initializer.
278    * @param _logic Address of the initial implementation.
279    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
280    * It should include the signature and the parameters of the function to be called, as described in
281    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
282    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
283    */
284   function initialize(address _logic, bytes memory _data) public payable {
285     require(_implementation() == address(0));
286     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
287     _setImplementation(_logic);
288     if (_data.length > 0) {
289       (bool success, ) = _logic.delegatecall(_data);
290       require(success);
291     }
292   }
293 }
294 
295 /**
296  * @title InitializableAdminUpgradeabilityProxy
297  * @dev Extends BaseAdminUpgradeabilityProxy with an initializer function
298  */
299 contract InitializableImmutableAdminUpgradeabilityProxy is
300   BaseImmutableAdminUpgradeabilityProxy,
301   InitializableUpgradeabilityProxy
302 {
303   constructor(address admin) BaseImmutableAdminUpgradeabilityProxy(admin) {}
304 
305   /**
306    * @dev Only fall back when the sender is not the admin.
307    */
308   function _willFallback() internal override(BaseImmutableAdminUpgradeabilityProxy, Proxy) {
309     BaseImmutableAdminUpgradeabilityProxy._willFallback();
310   }
311 }