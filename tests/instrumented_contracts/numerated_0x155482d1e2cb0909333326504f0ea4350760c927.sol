1 /**
2  *Submitted for verification at BscScan.com on 2021-03-08
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-10-09
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.6.2;
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize, which returns 0 for contracts in
36         // construction, since the code is only stored at the end of the
37         // constructor execution.
38 
39         uint256 size;
40         // solhint-disable-next-line no-inline-assembly
41         assembly { size := extcodesize(account) }
42         return size > 0;
43     }
44 
45 }
46 /**
47  * @title Proxy
48  * @dev Implements delegation of calls to other contracts, with proper
49  * forwarding of return values and bubbling of failures.
50  * It defines a fallback function that delegates all calls to the address
51  * returned by the abstract _implementation() internal function.
52  */
53 abstract contract Proxy {
54   /**
55    * @dev Fallback function.
56    * Implemented entirely in `_fallback`.
57    */
58   fallback () payable external {
59     _fallback();
60   }
61 
62   /**
63    * @dev Receive function.
64    * Implemented entirely in `_fallback`.
65    */
66   receive () payable external {
67     _fallback();
68   }
69 
70   /**
71    * @return The Address of the implementation.
72    */
73   function _implementation() internal virtual view returns (address);
74 
75   /**
76    * @dev Delegates execution to an implementation contract.
77    * This is a low level function that doesn't return to its internal call site.
78    * It will return to the external caller whatever the implementation returns.
79    * @param implementation Address to delegate.
80    */
81   function _delegate(address implementation) internal {
82     assembly {
83       // Copy msg.data. We take full control of memory in this inline assembly
84       // block because it will not return to Solidity code. We overwrite the
85       // Solidity scratch pad at memory position 0.
86       calldatacopy(0, 0, calldatasize())
87 
88       // Call the implementation.
89       // out and outsize are 0 because we don't know the size yet.
90       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
91 
92       // Copy the returned data.
93       returndatacopy(0, 0, returndatasize())
94 
95       switch result
96       // delegatecall returns 0 on error.
97       case 0 { revert(0, returndatasize()) }
98       default { return(0, returndatasize()) }
99     }
100   }
101 
102   /**
103    * @dev Function that is run as the first thing in the fallback function.
104    * Can be redefined in derived contracts to add functionality.
105    * Redefinitions must call super._willFallback().
106    */
107   function _willFallback() internal virtual {
108   }
109 
110   /**
111    * @dev fallback implementation.
112    * Extracted to enable manual triggering.
113    */
114   function _fallback() internal {
115     _willFallback();
116     _delegate(_implementation());
117   }
118 }
119 
120 /**
121  * @title UpgradeabilityProxy
122  * @dev This contract implements a proxy that allows to change the
123  * implementation address to which it will delegate.
124  * Such a change is called an implementation upgrade.
125  */
126 contract UpgradeabilityProxy is Proxy {
127   /**
128    * @dev Contract constructor.
129    * @param _logic Address of the initial implementation.
130    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
131    * It should include the signature and the parameters of the function to be called, as described in
132    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
133    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
134    */
135   constructor(address _logic, bytes memory _data) public payable {
136     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
137     _setImplementation(_logic);
138     if(_data.length > 0) {
139       (bool success,) = _logic.delegatecall(_data);
140       require(success);
141     }
142   }  
143 
144   /**
145    * @dev Emitted when the implementation is upgraded.
146    * @param implementation Address of the new implementation.
147    */
148   event Upgraded(address indexed implementation);
149 
150   /**
151    * @dev Storage slot with the address of the current implementation.
152    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
153    * validated in the constructor.
154    */
155   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
156 
157   /**
158    * @dev Returns the current implementation.
159    * @return impl Address of the current implementation
160    */
161   function _implementation() internal override view returns (address impl) {
162     bytes32 slot = IMPLEMENTATION_SLOT;
163     assembly {
164       impl := sload(slot)
165     }
166   }
167 
168   /**
169    * @dev Upgrades the proxy to a new implementation.
170    * @param newImplementation Address of the new implementation.
171    */
172   function _upgradeTo(address newImplementation) internal {
173     _setImplementation(newImplementation);
174     emit Upgraded(newImplementation);
175   }
176 
177   /**
178    * @dev Sets the implementation address of the proxy.
179    * @param newImplementation Address of the new implementation.
180    */
181   function _setImplementation(address newImplementation) internal {
182     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
183 
184     bytes32 slot = IMPLEMENTATION_SLOT;
185 
186     assembly {
187       sstore(slot, newImplementation)
188     }
189   }
190 }
191 
192 /**
193  * @title AdminUpgradeabilityProxy
194  * @dev This contract combines an upgradeability proxy with an authorization
195  * mechanism for administrative tasks.
196  * All external functions in this contract must be guarded by the
197  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
198  * feature proposal that would enable this to be done automatically.
199  */
200 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
201   /**
202    * Contract constructor.
203    * @param _logic address of the initial implementation.
204    * @param _admin Address of the proxy administrator.
205    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
206    * It should include the signature and the parameters of the function to be called, as described in
207    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
208    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
209    */
210   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
211     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
212     _setAdmin(_admin);
213   }
214 
215   /**
216    * @dev Emitted when the administration has been transferred.
217    * @param previousAdmin Address of the previous admin.
218    * @param newAdmin Address of the new admin.
219    */
220   event AdminChanged(address previousAdmin, address newAdmin);
221 
222   /**
223    * @dev Storage slot with the admin of the contract.
224    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
225    * validated in the constructor.
226    */
227 
228   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
229 
230   /**
231    * @dev Modifier to check whether the `msg.sender` is the admin.
232    * If it is, it will run the function. Otherwise, it will delegate the call
233    * to the implementation.
234    */
235   modifier ifAdmin() {
236     if (msg.sender == _admin()) {
237       _;
238     } else {
239       _fallback();
240     }
241   }
242 
243   /**
244    * @return The address of the proxy admin.
245    */
246   function admin() external ifAdmin returns (address) {
247     return _admin();
248   }
249 
250   /**
251    * @return The address of the implementation.
252    */
253   function implementation() external ifAdmin returns (address) {
254     return _implementation();
255   }
256 
257   /**
258    * @dev Changes the admin of the proxy.
259    * Only the current admin can call this function.
260    * @param newAdmin Address to transfer proxy administration to.
261    */
262   function changeAdmin(address newAdmin) external ifAdmin {
263     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
264     emit AdminChanged(_admin(), newAdmin);
265     _setAdmin(newAdmin);
266   }
267 
268   /**
269    * @dev Upgrade the backing implementation of the proxy.
270    * Only the admin can call this function.
271    * @param newImplementation Address of the new implementation.
272    */
273   function upgradeTo(address newImplementation) external ifAdmin {
274     _upgradeTo(newImplementation);
275   }
276 
277   /**
278    * @dev Upgrade the backing implementation of the proxy and call a function
279    * on the new implementation.
280    * This is useful to initialize the proxied contract.
281    * @param newImplementation Address of the new implementation.
282    * @param data Data to send as msg.data in the low level call.
283    * It should include the signature and the parameters of the function to be called, as described in
284    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
285    */
286   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
287     _upgradeTo(newImplementation);
288     (bool success,) = newImplementation.delegatecall(data);
289     require(success);
290   }
291 
292   /**
293    * @return adm The admin slot.
294    */
295   function _admin() internal view returns (address adm) {
296     bytes32 slot = ADMIN_SLOT;
297     assembly {
298       adm := sload(slot)
299     }
300   }
301 
302   /**
303    * @dev Sets the address of the proxy admin.
304    * @param newAdmin Address of the new proxy admin.
305    */
306   function _setAdmin(address newAdmin) internal {
307     bytes32 slot = ADMIN_SLOT;
308 
309     assembly {
310       sstore(slot, newAdmin)
311     }
312   }
313 
314   /**
315    * @dev Only fall back when the sender is not the admin.
316    */
317   function _willFallback() internal override virtual {
318     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
319     super._willFallback();
320   }
321 }