1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-10
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2021-03-08
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-10-09
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity ^0.6.2;
16 
17 /**
18  * @dev Collection of functions related to the address type
19  */
20 library Address {
21     /**
22      * @dev Returns true if `account` is a contract.
23      *
24      * [IMPORTANT]
25      * ====
26      * It is unsafe to assume that an address for which this function returns
27      * false is an externally-owned account (EOA) and not a contract.
28      *
29      * Among others, `isContract` will return false for the following
30      * types of addresses:
31      *
32      *  - an externally-owned account
33      *  - a contract in construction
34      *  - an address where a contract will be created
35      *  - an address where a contract lived, but was destroyed
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize, which returns 0 for contracts in
40         // construction, since the code is only stored at the end of the
41         // constructor execution.
42 
43         uint256 size;
44         // solhint-disable-next-line no-inline-assembly
45         assembly { size := extcodesize(account) }
46         return size > 0;
47     }
48 
49 }
50 /**
51  * @title Proxy
52  * @dev Implements delegation of calls to other contracts, with proper
53  * forwarding of return values and bubbling of failures.
54  * It defines a fallback function that delegates all calls to the address
55  * returned by the abstract _implementation() internal function.
56  */
57 abstract contract Proxy {
58   /**
59    * @dev Fallback function.
60    * Implemented entirely in `_fallback`.
61    */
62   fallback () payable external {
63     _fallback();
64   }
65 
66   /**
67    * @dev Receive function.
68    * Implemented entirely in `_fallback`.
69    */
70   receive () payable external {
71     _fallback();
72   }
73 
74   /**
75    * @return The Address of the implementation.
76    */
77   function _implementation() internal virtual view returns (address);
78 
79   /**
80    * @dev Delegates execution to an implementation contract.
81    * This is a low level function that doesn't return to its internal call site.
82    * It will return to the external caller whatever the implementation returns.
83    * @param implementation Address to delegate.
84    */
85   function _delegate(address implementation) internal {
86     assembly {
87       // Copy msg.data. We take full control of memory in this inline assembly
88       // block because it will not return to Solidity code. We overwrite the
89       // Solidity scratch pad at memory position 0.
90       calldatacopy(0, 0, calldatasize())
91 
92       // Call the implementation.
93       // out and outsize are 0 because we don't know the size yet.
94       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
95 
96       // Copy the returned data.
97       returndatacopy(0, 0, returndatasize())
98 
99       switch result
100       // delegatecall returns 0 on error.
101       case 0 { revert(0, returndatasize()) }
102       default { return(0, returndatasize()) }
103     }
104   }
105 
106   /**
107    * @dev Function that is run as the first thing in the fallback function.
108    * Can be redefined in derived contracts to add functionality.
109    * Redefinitions must call super._willFallback().
110    */
111   function _willFallback() internal virtual {
112   }
113 
114   /**
115    * @dev fallback implementation.
116    * Extracted to enable manual triggering.
117    */
118   function _fallback() internal {
119     _willFallback();
120     _delegate(_implementation());
121   }
122 }
123 
124 /**
125  * @title UpgradeabilityProxy
126  * @dev This contract implements a proxy that allows to change the
127  * implementation address to which it will delegate.
128  * Such a change is called an implementation upgrade.
129  */
130 contract UpgradeabilityProxy is Proxy {
131   /**
132    * @dev Contract constructor.
133    * @param _logic Address of the initial implementation.
134    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
135    * It should include the signature and the parameters of the function to be called, as described in
136    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
137    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
138    */
139   constructor(address _logic, bytes memory _data) public payable {
140     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
141     _setImplementation(_logic);
142     if(_data.length > 0) {
143       (bool success,) = _logic.delegatecall(_data);
144       require(success);
145     }
146   }  
147 
148   /**
149    * @dev Emitted when the implementation is upgraded.
150    * @param implementation Address of the new implementation.
151    */
152   event Upgraded(address indexed implementation);
153 
154   /**
155    * @dev Storage slot with the address of the current implementation.
156    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
157    * validated in the constructor.
158    */
159   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
160 
161   /**
162    * @dev Returns the current implementation.
163    * @return impl Address of the current implementation
164    */
165   function _implementation() internal override view returns (address impl) {
166     bytes32 slot = IMPLEMENTATION_SLOT;
167     assembly {
168       impl := sload(slot)
169     }
170   }
171 
172   /**
173    * @dev Upgrades the proxy to a new implementation.
174    * @param newImplementation Address of the new implementation.
175    */
176   function _upgradeTo(address newImplementation) internal {
177     _setImplementation(newImplementation);
178     emit Upgraded(newImplementation);
179   }
180 
181   /**
182    * @dev Sets the implementation address of the proxy.
183    * @param newImplementation Address of the new implementation.
184    */
185   function _setImplementation(address newImplementation) internal {
186     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
187 
188     bytes32 slot = IMPLEMENTATION_SLOT;
189 
190     assembly {
191       sstore(slot, newImplementation)
192     }
193   }
194 }
195 
196 /**
197  * @title AdminUpgradeabilityProxy
198  * @dev This contract combines an upgradeability proxy with an authorization
199  * mechanism for administrative tasks.
200  * All external functions in this contract must be guarded by the
201  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
202  * feature proposal that would enable this to be done automatically.
203  */
204 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
205   /**
206    * Contract constructor.
207    * @param _logic address of the initial implementation.
208    * @param _admin Address of the proxy administrator.
209    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
210    * It should include the signature and the parameters of the function to be called, as described in
211    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
212    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
213    */
214   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
215     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
216     _setAdmin(_admin);
217   }
218 
219   /**
220    * @dev Emitted when the administration has been transferred.
221    * @param previousAdmin Address of the previous admin.
222    * @param newAdmin Address of the new admin.
223    */
224   event AdminChanged(address previousAdmin, address newAdmin);
225 
226   /**
227    * @dev Storage slot with the admin of the contract.
228    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
229    * validated in the constructor.
230    */
231 
232   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
233 
234   /**
235    * @dev Modifier to check whether the `msg.sender` is the admin.
236    * If it is, it will run the function. Otherwise, it will delegate the call
237    * to the implementation.
238    */
239   modifier ifAdmin() {
240     if (msg.sender == _admin()) {
241       _;
242     } else {
243       _fallback();
244     }
245   }
246 
247   /**
248    * @return The address of the proxy admin.
249    */
250   function admin() external ifAdmin returns (address) {
251     return _admin();
252   }
253 
254   /**
255    * @return The address of the implementation.
256    */
257   function implementation() external ifAdmin returns (address) {
258     return _implementation();
259   }
260 
261   /**
262    * @dev Changes the admin of the proxy.
263    * Only the current admin can call this function.
264    * @param newAdmin Address to transfer proxy administration to.
265    */
266   function changeAdmin(address newAdmin) external ifAdmin {
267     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
268     emit AdminChanged(_admin(), newAdmin);
269     _setAdmin(newAdmin);
270   }
271 
272   /**
273    * @dev Upgrade the backing implementation of the proxy.
274    * Only the admin can call this function.
275    * @param newImplementation Address of the new implementation.
276    */
277   function upgradeTo(address newImplementation) external ifAdmin {
278     _upgradeTo(newImplementation);
279   }
280 
281   /**
282    * @dev Upgrade the backing implementation of the proxy and call a function
283    * on the new implementation.
284    * This is useful to initialize the proxied contract.
285    * @param newImplementation Address of the new implementation.
286    * @param data Data to send as msg.data in the low level call.
287    * It should include the signature and the parameters of the function to be called, as described in
288    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
289    */
290   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
291     _upgradeTo(newImplementation);
292     (bool success,) = newImplementation.delegatecall(data);
293     require(success);
294   }
295 
296   /**
297    * @return adm The admin slot.
298    */
299   function _admin() internal view returns (address adm) {
300     bytes32 slot = ADMIN_SLOT;
301     assembly {
302       adm := sload(slot)
303     }
304   }
305 
306   /**
307    * @dev Sets the address of the proxy admin.
308    * @param newAdmin Address of the new proxy admin.
309    */
310   function _setAdmin(address newAdmin) internal {
311     bytes32 slot = ADMIN_SLOT;
312 
313     assembly {
314       sstore(slot, newAdmin)
315     }
316   }
317 
318   /**
319    * @dev Only fall back when the sender is not the admin.
320    */
321   function _willFallback() internal override virtual {
322     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
323     super._willFallback();
324   }
325 }