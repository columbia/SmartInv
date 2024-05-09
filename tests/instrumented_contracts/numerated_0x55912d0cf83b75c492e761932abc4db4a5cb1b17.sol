1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-09
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.2;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41 }
42 /**
43  * @title Proxy
44  * @dev Implements delegation of calls to other contracts, with proper
45  * forwarding of return values and bubbling of failures.
46  * It defines a fallback function that delegates all calls to the address
47  * returned by the abstract _implementation() internal function.
48  */
49 abstract contract Proxy {
50   /**
51    * @dev Fallback function.
52    * Implemented entirely in `_fallback`.
53    */
54   fallback () payable external {
55     _fallback();
56   }
57 
58   /**
59    * @dev Receive function.
60    * Implemented entirely in `_fallback`.
61    */
62   receive () payable external {
63     _fallback();
64   }
65 
66   /**
67    * @return The Address of the implementation.
68    */
69   function _implementation() internal virtual view returns (address);
70 
71   /**
72    * @dev Delegates execution to an implementation contract.
73    * This is a low level function that doesn't return to its internal call site.
74    * It will return to the external caller whatever the implementation returns.
75    * @param implementation Address to delegate.
76    */
77   function _delegate(address implementation) internal {
78     assembly {
79       // Copy msg.data. We take full control of memory in this inline assembly
80       // block because it will not return to Solidity code. We overwrite the
81       // Solidity scratch pad at memory position 0.
82       calldatacopy(0, 0, calldatasize())
83 
84       // Call the implementation.
85       // out and outsize are 0 because we don't know the size yet.
86       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
87 
88       // Copy the returned data.
89       returndatacopy(0, 0, returndatasize())
90 
91       switch result
92       // delegatecall returns 0 on error.
93       case 0 { revert(0, returndatasize()) }
94       default { return(0, returndatasize()) }
95     }
96   }
97 
98   /**
99    * @dev Function that is run as the first thing in the fallback function.
100    * Can be redefined in derived contracts to add functionality.
101    * Redefinitions must call super._willFallback().
102    */
103   function _willFallback() internal virtual {
104   }
105 
106   /**
107    * @dev fallback implementation.
108    * Extracted to enable manual triggering.
109    */
110   function _fallback() internal {
111     _willFallback();
112     _delegate(_implementation());
113   }
114 }
115 
116 /**
117  * @title UpgradeabilityProxy
118  * @dev This contract implements a proxy that allows to change the
119  * implementation address to which it will delegate.
120  * Such a change is called an implementation upgrade.
121  */
122 contract UpgradeabilityProxy is Proxy {
123   /**
124    * @dev Contract constructor.
125    * @param _logic Address of the initial implementation.
126    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
127    * It should include the signature and the parameters of the function to be called, as described in
128    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
129    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
130    */
131   constructor(address _logic, bytes memory _data) public payable {
132     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
133     _setImplementation(_logic);
134     if(_data.length > 0) {
135       (bool success,) = _logic.delegatecall(_data);
136       require(success);
137     }
138   }  
139 
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
151   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
152 
153   /**
154    * @dev Returns the current implementation.
155    * @return impl Address of the current implementation
156    */
157   function _implementation() internal override view returns (address impl) {
158     bytes32 slot = IMPLEMENTATION_SLOT;
159     assembly {
160       impl := sload(slot)
161     }
162   }
163 
164   /**
165    * @dev Upgrades the proxy to a new implementation.
166    * @param newImplementation Address of the new implementation.
167    */
168   function _upgradeTo(address newImplementation) internal {
169     _setImplementation(newImplementation);
170     emit Upgraded(newImplementation);
171   }
172 
173   /**
174    * @dev Sets the implementation address of the proxy.
175    * @param newImplementation Address of the new implementation.
176    */
177   function _setImplementation(address newImplementation) internal {
178     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
179 
180     bytes32 slot = IMPLEMENTATION_SLOT;
181 
182     assembly {
183       sstore(slot, newImplementation)
184     }
185   }
186 }
187 
188 /**
189  * @title AdminUpgradeabilityProxy
190  * @dev This contract combines an upgradeability proxy with an authorization
191  * mechanism for administrative tasks.
192  * All external functions in this contract must be guarded by the
193  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
194  * feature proposal that would enable this to be done automatically.
195  */
196 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
197   /**
198    * Contract constructor.
199    * @param _logic address of the initial implementation.
200    * @param _admin Address of the proxy administrator.
201    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
202    * It should include the signature and the parameters of the function to be called, as described in
203    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
204    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
205    */
206   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
207     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
208     _setAdmin(_admin);
209   }
210 
211   /**
212    * @dev Emitted when the administration has been transferred.
213    * @param previousAdmin Address of the previous admin.
214    * @param newAdmin Address of the new admin.
215    */
216   event AdminChanged(address previousAdmin, address newAdmin);
217 
218   /**
219    * @dev Storage slot with the admin of the contract.
220    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
221    * validated in the constructor.
222    */
223 
224   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
225 
226   /**
227    * @dev Modifier to check whether the `msg.sender` is the admin.
228    * If it is, it will run the function. Otherwise, it will delegate the call
229    * to the implementation.
230    */
231   modifier ifAdmin() {
232     if (msg.sender == _admin()) {
233       _;
234     } else {
235       _fallback();
236     }
237   }
238 
239   /**
240    * @return The address of the proxy admin.
241    */
242   function admin() external ifAdmin returns (address) {
243     return _admin();
244   }
245 
246   /**
247    * @return The address of the implementation.
248    */
249   function implementation() external ifAdmin returns (address) {
250     return _implementation();
251   }
252 
253   /**
254    * @dev Changes the admin of the proxy.
255    * Only the current admin can call this function.
256    * @param newAdmin Address to transfer proxy administration to.
257    */
258   function changeAdmin(address newAdmin) external ifAdmin {
259     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
260     emit AdminChanged(_admin(), newAdmin);
261     _setAdmin(newAdmin);
262   }
263 
264   /**
265    * @dev Upgrade the backing implementation of the proxy.
266    * Only the admin can call this function.
267    * @param newImplementation Address of the new implementation.
268    */
269   function upgradeTo(address newImplementation) external ifAdmin {
270     _upgradeTo(newImplementation);
271   }
272 
273   /**
274    * @dev Upgrade the backing implementation of the proxy and call a function
275    * on the new implementation.
276    * This is useful to initialize the proxied contract.
277    * @param newImplementation Address of the new implementation.
278    * @param data Data to send as msg.data in the low level call.
279    * It should include the signature and the parameters of the function to be called, as described in
280    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
281    */
282   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
283     _upgradeTo(newImplementation);
284     (bool success,) = newImplementation.delegatecall(data);
285     require(success);
286   }
287 
288   /**
289    * @return adm The admin slot.
290    */
291   function _admin() internal view returns (address adm) {
292     bytes32 slot = ADMIN_SLOT;
293     assembly {
294       adm := sload(slot)
295     }
296   }
297 
298   /**
299    * @dev Sets the address of the proxy admin.
300    * @param newAdmin Address of the new proxy admin.
301    */
302   function _setAdmin(address newAdmin) internal {
303     bytes32 slot = ADMIN_SLOT;
304 
305     assembly {
306       sstore(slot, newAdmin)
307     }
308   }
309 
310   /**
311    * @dev Only fall back when the sender is not the admin.
312    */
313   function _willFallback() internal override virtual {
314     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
315     super._willFallback();
316   }
317 }