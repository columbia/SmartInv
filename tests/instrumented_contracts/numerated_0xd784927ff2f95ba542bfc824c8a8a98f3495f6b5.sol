1 // SPDX-License-Identifier: agpl-3.0
2 pragma solidity 0.6.12;
3 
4 /**
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8   /**
9    * @dev Returns true if `account` is a contract.
10    *
11    * [IMPORTANT]
12    * ====
13    * It is unsafe to assume that an address for which this function returns
14    * false is an externally-owned account (EOA) and not a contract.
15    *
16    * Among others, `isContract` will return false for the following
17    * types of addresses:
18    *
19    *  - an externally-owned account
20    *  - a contract in construction
21    *  - an address where a contract will be created
22    *  - an address where a contract lived, but was destroyed
23    * ====
24    */
25   function isContract(address account) internal view returns (bool) {
26     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
27     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
28     // for accounts without code, i.e. `keccak256('')`
29     bytes32 codehash;
30     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
31     // solhint-disable-next-line no-inline-assembly
32     assembly {
33       codehash := extcodehash(account)
34     }
35     return (codehash != accountHash && codehash != 0x0);
36   }
37 
38   /**
39    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
40    * `recipient`, forwarding all available gas and reverting on errors.
41    *
42    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
43    * of certain opcodes, possibly making contracts go over the 2300 gas limit
44    * imposed by `transfer`, making them unable to receive funds via
45    * `transfer`. {sendValue} removes this limitation.
46    *
47    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
48    *
49    * IMPORTANT: because control is transferred to `recipient`, care must be
50    * taken to not create reentrancy vulnerabilities. Consider using
51    * {ReentrancyGuard} or the
52    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
53    */
54   function sendValue(address payable recipient, uint256 amount) internal {
55     require(address(this).balance >= amount, 'Address: insufficient balance');
56 
57     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
58     (bool success, ) = recipient.call{value: amount}('');
59     require(success, 'Address: unable to send value, recipient may have reverted');
60   }
61 }
62 
63 /**
64  * @title Proxy
65  * @dev Implements delegation of calls to other contracts, with proper
66  * forwarding of return values and bubbling of failures.
67  * It defines a fallback function that delegates all calls to the address
68  * returned by the abstract _implementation() internal function.
69  */
70 abstract contract Proxy {
71   /**
72    * @dev Fallback function.
73    * Implemented entirely in `_fallback`.
74    */
75   fallback() external payable {
76     _fallback();
77   }
78 
79   /**
80    * @return The Address of the implementation.
81    */
82   function _implementation() internal view virtual returns (address);
83 
84   /**
85    * @dev Delegates execution to an implementation contract.
86    * This is a low level function that doesn't return to its internal call site.
87    * It will return to the external caller whatever the implementation returns.
88    * @param implementation Address to delegate.
89    */
90   function _delegate(address implementation) internal {
91     //solium-disable-next-line
92     assembly {
93       // Copy msg.data. We take full control of memory in this inline assembly
94       // block because it will not return to Solidity code. We overwrite the
95       // Solidity scratch pad at memory position 0.
96       calldatacopy(0, 0, calldatasize())
97 
98       // Call the implementation.
99       // out and outsize are 0 because we don't know the size yet.
100       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
101 
102       // Copy the returned data.
103       returndatacopy(0, 0, returndatasize())
104 
105       switch result
106         // delegatecall returns 0 on error.
107         case 0 {
108           revert(0, returndatasize())
109         }
110         default {
111           return(0, returndatasize())
112         }
113     }
114   }
115 
116   /**
117    * @dev Function that is run as the first thing in the fallback function.
118    * Can be redefined in derived contracts to add functionality.
119    * Redefinitions must call super._willFallback().
120    */
121   function _willFallback() internal virtual {}
122 
123   /**
124    * @dev fallback implementation.
125    * Extracted to enable manual triggering.
126    */
127   function _fallback() internal {
128     _willFallback();
129     _delegate(_implementation());
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
195  * @title InitializableUpgradeabilityProxy
196  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
197  * implementation and init data.
198  */
199 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
200   /**
201    * @dev Contract initializer.
202    * @param _logic Address of the initial implementation.
203    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
204    * It should include the signature and the parameters of the function to be called, as described in
205    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
206    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
207    */
208   function initialize(address _logic, bytes memory _data) public payable {
209     require(_implementation() == address(0));
210     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
211     _setImplementation(_logic);
212     if (_data.length > 0) {
213       (bool success, ) = _logic.delegatecall(_data);
214       require(success);
215     }
216   }
217 }
218 
219 /**
220  * @title BaseImmutableAdminUpgradeabilityProxy
221  * @author Aave, inspired by the OpenZeppelin upgradeability proxy pattern
222  * @dev This contract combines an upgradeability proxy with an authorization
223  * mechanism for administrative tasks. The admin role is stored in an immutable, which
224  * helps saving transactions costs
225  * All external functions in this contract must be guarded by the
226  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
227  * feature proposal that would enable this to be done automatically.
228  */
229 contract BaseImmutableAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
230   address immutable ADMIN;
231 
232   constructor(address admin) public {
233     ADMIN = admin;
234   }
235 
236   modifier ifAdmin() {
237     if (msg.sender == ADMIN) {
238       _;
239     } else {
240       _fallback();
241     }
242   }
243 
244   /**
245    * @return The address of the proxy admin.
246    */
247   function admin() external ifAdmin returns (address) {
248     return ADMIN;
249   }
250 
251   /**
252    * @return The address of the implementation.
253    */
254   function implementation() external ifAdmin returns (address) {
255     return _implementation();
256   }
257 
258   /**
259    * @dev Upgrade the backing implementation of the proxy.
260    * Only the admin can call this function.
261    * @param newImplementation Address of the new implementation.
262    */
263   function upgradeTo(address newImplementation) external ifAdmin {
264     _upgradeTo(newImplementation);
265   }
266 
267   /**
268    * @dev Upgrade the backing implementation of the proxy and call a function
269    * on the new implementation.
270    * This is useful to initialize the proxied contract.
271    * @param newImplementation Address of the new implementation.
272    * @param data Data to send as msg.data in the low level call.
273    * It should include the signature and the parameters of the function to be called, as described in
274    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
275    */
276   function upgradeToAndCall(address newImplementation, bytes calldata data)
277     external
278     payable
279     ifAdmin
280   {
281     _upgradeTo(newImplementation);
282     (bool success, ) = newImplementation.delegatecall(data);
283     require(success);
284   }
285 
286   /**
287    * @dev Only fall back when the sender is not the admin.
288    */
289   function _willFallback() internal virtual override {
290     require(msg.sender != ADMIN, 'Cannot call fallback function from the proxy admin');
291     super._willFallback();
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
303   constructor(address admin) public BaseImmutableAdminUpgradeabilityProxy(admin) {}
304 
305   /**
306    * @dev Only fall back when the sender is not the admin.
307    */
308   function _willFallback() internal override(BaseImmutableAdminUpgradeabilityProxy, Proxy) {
309     BaseImmutableAdminUpgradeabilityProxy._willFallback();
310   }
311 }