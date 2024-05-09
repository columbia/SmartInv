1 /**
2  * Copyright (c) 2018-present, Leap DAO (leapdao.org)
3  *
4  * This source code is licensed under the Mozilla Public License, version 2,
5  * found in the LICENSE file in the root directory of this source tree.
6  */
7 
8 pragma solidity 0.5.2;
9 
10 
11 /**
12  * @title Proxy
13  * @dev Implements delegation of calls to other contracts, with proper
14  * forwarding of return values and bubbling of failures.
15  * It defines a fallback function that delegates all calls to the address
16  * returned by the abstract _implementation() internal function.
17  */
18 contract Proxy {
19   /**
20    * @dev Fallback function.
21    * Implemented entirely in `_fallback`.
22    */
23   function () external payable {
24     _fallback();
25   }
26 
27   /**
28    * @return The Address of the implementation.
29    */
30   function _implementation() internal view returns (address);
31 
32   /**
33    * @dev Delegates execution to an implementation contract.
34    * This is a low level function that doesn't return to its internal call site.
35    * It will return to the external caller whatever the implementation returns.
36    * @param implementation Address to delegate.
37    */
38   function _delegate(address implementation) internal {
39     assembly {
40       // Copy msg.data. We take full control of memory in this inline assembly
41       // block because it will not return to Solidity code. We overwrite the
42       // Solidity scratch pad at memory position 0.
43       calldatacopy(0, 0, calldatasize)
44 
45       // Call the implementation.
46       // out and outsize are 0 because we don't know the size yet.
47       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
48 
49       // Copy the returned data.
50       returndatacopy(0, 0, returndatasize)
51 
52       switch result
53       // delegatecall returns 0 on error.
54       case 0 { revert(0, returndatasize) }
55       default { return(0, returndatasize) }
56     }
57   }
58 
59   /**
60    * @dev Function that is run as the first thing in the fallback function.
61    * Can be redefined in derived contracts to add functionality.
62    * Redefinitions must call super._willFallback().
63    */
64   function _willFallback() internal {
65   }
66 
67   /**
68    * @dev fallback implementation.
69    * Extracted to enable manual triggering.
70    */
71   function _fallback() internal {
72     _willFallback();
73     _delegate(_implementation());
74   }
75 }
76 
77 /**
78  * Utility library of inline functions on addresses
79  */
80 library Address {
81     /**
82      * Returns whether the target address is a contract
83      * @dev This function will return false if invoked during the constructor of a contract,
84      * as the code is not actually created until after the constructor finishes.
85      * @param account address of the account to check
86      * @return whether the target address is a contract
87      */
88     function isContract(address account) internal view returns (bool) {
89         uint256 size;
90         // XXX Currently there is no better way to check if there is a contract in an address
91         // than to check the size of the code at that address.
92         // See https://ethereum.stackexchange.com/a/14016/36603
93         // for more details about how this works.
94         // TODO Check this again before the Serenity release, because all addresses will be
95         // contracts then.
96         // solhint-disable-next-line no-inline-assembly
97         assembly { size := extcodesize(account) }
98         return size > 0;
99     }
100 }
101 
102 /**
103  * @title UpgradeabilityProxy
104  * @dev This contract implements a proxy that allows to change the
105  * implementation address to which it will delegate.
106  * Such a change is called an implementation upgrade.
107  */
108 contract UpgradeabilityProxy is Proxy {
109   /**
110    * @dev Emitted when the implementation is upgraded.
111    * @param implementation Address of the new implementation.
112    */
113   event Upgraded(address indexed implementation);
114 
115   /**
116    * @dev Storage slot with the address of the current implementation.
117    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
118    * validated in the constructor.
119    */
120   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
121 
122   /**
123    * @dev Contract constructor.
124    * @param _implementation Address of the initial implementation.
125    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
126    * It should include the signature and the parameters of the function to be called, as described in
127    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
128    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
129    */
130   constructor(address _implementation, bytes memory _data) public payable {
131     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
132     _setImplementation(_implementation);
133     if (_data.length > 0) {
134       bool rv;
135       (rv,) = _implementation.delegatecall(_data);
136       require(rv);
137     }
138   }
139 
140   /**
141    * @dev Returns the current implementation.
142    * @return Address of the current implementation
143    */
144   function _implementation() internal view returns (address impl) {
145     bytes32 slot = IMPLEMENTATION_SLOT;
146     assembly {
147       impl := sload(slot)
148     }
149   }
150 
151   /**
152    * @dev Upgrades the proxy to a new implementation.
153    * @param newImplementation Address of the new implementation.
154    */
155   function _upgradeTo(address newImplementation) internal {
156     _setImplementation(newImplementation);
157     emit Upgraded(newImplementation);
158   }
159 
160   /**
161    * @dev Sets the implementation address of the proxy.
162    * @param newImplementation Address of the new implementation.
163    */
164   function _setImplementation(address newImplementation) private {
165     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
166 
167     bytes32 slot = IMPLEMENTATION_SLOT;
168 
169     assembly {
170       sstore(slot, newImplementation)
171     }
172   }
173 }
174 
175 /**
176  * @title AdminUpgradeabilityProxy
177  * @dev This contract combines an upgradeability proxy with an authorization
178  * mechanism for administrative tasks.
179  * All external functions in this contract must be guarded by the
180  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
181  * feature proposal that would enable this to be done automatically.
182  */
183 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
184   /**
185    * @dev Emitted when the administration has been transferred.
186    * @param previousAdmin Address of the previous admin.
187    * @param newAdmin Address of the new admin.
188    */
189   event AdminChanged(address previousAdmin, address newAdmin);
190 
191   /**
192    * @dev Storage slot with the admin of the contract.
193    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
194    * validated in the constructor.
195    */
196   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
197 
198   /**
199    * @dev Modifier to check whether the `msg.sender` is the admin.
200    * If it is, it will run the function. Otherwise, it will delegate the call
201    * to the implementation.
202    */
203   modifier ifAdmin() {
204     if (msg.sender == _admin()) {
205       _;
206     } else {
207       _fallback();
208     }
209   }
210 
211   /**
212    * Contract constructor.
213    * It sets the `msg.sender` as the proxy administrator.
214    * @param _implementation address of the initial implementation.
215    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
216    * It should include the signature and the parameters of the function to be called, as described in
217    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
218    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
219    */
220   constructor(address _implementation, bytes memory _data) UpgradeabilityProxy(_implementation, _data) public payable {
221     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
222 
223     _setAdmin(msg.sender);
224   }
225 
226   /**
227    * @return The address of the proxy admin.
228    */
229   function admin() external ifAdmin returns (address) {
230     return _admin();
231   }
232 
233   /**
234    * @return The address of the implementation.
235    */
236   function implementation() external ifAdmin returns (address) {
237     return _implementation();
238   }
239 
240   /**
241    * @dev Changes the admin of the proxy.
242    * Only the current admin can call this function.
243    * @param newAdmin Address to transfer proxy administration to.
244    */
245   function changeAdmin(address newAdmin) external ifAdmin {
246     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
247     emit AdminChanged(_admin(), newAdmin);
248     _setAdmin(newAdmin);
249   }
250 
251   /**
252    * @dev Upgrade the backing implementation of the proxy.
253    * Only the admin can call this function.
254    * @param newImplementation Address of the new implementation.
255    */
256   function upgradeTo(address newImplementation) external ifAdmin {
257     _upgradeTo(newImplementation);
258   }
259 
260   /**
261    * @dev Upgrade the backing implementation of the proxy and call a function
262    * on the new implementation.
263    * This is useful to initialize the proxied contract.
264    * @param newImplementation Address of the new implementation.
265    * @param data Data to send as msg.data in the low level call.
266    * It should include the signature and the parameters of the function to be called, as described in
267    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
268    */
269   function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
270     _upgradeTo(newImplementation);
271     bool rv;
272     (rv,) = newImplementation.delegatecall(data);
273     require(rv);
274   }
275 
276   /**
277    * @return The admin slot.
278    */
279   function _admin() internal view returns (address adm) {
280     bytes32 slot = ADMIN_SLOT;
281     assembly {
282       adm := sload(slot)
283     }
284   }
285 
286   /**
287    * @dev Sets the address of the proxy admin.
288    * @param newAdmin Address of the new proxy admin.
289    */
290   function _setAdmin(address newAdmin) internal {
291     bytes32 slot = ADMIN_SLOT;
292 
293     assembly {
294       sstore(slot, newAdmin)
295     }
296   }
297 
298   /**
299    * @dev Only fall back when the sender is not the admin.
300    */
301   function _willFallback() internal {
302     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
303     super._willFallback();
304   }
305 }
306 
307 /**
308  * @title AdminUpgradeabilityProxy
309  * @dev This contract combines an upgradeability proxy with an authorization
310  * mechanism for administrative tasks.
311  * All external functions in this contract must be guarded by the
312  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
313  * feature proposal that would enable this to be done automatically.
314  */
315 contract AdminableProxy is AdminUpgradeabilityProxy {
316 
317   /**
318    * Contract constructor.
319    */
320   constructor(address _implementation, bytes memory _data) 
321   AdminUpgradeabilityProxy(_implementation, _data) public payable {
322   }
323 
324   /**
325    * @dev apply proposal.
326    */
327   function applyProposal(bytes calldata data) external ifAdmin returns (bool) {
328     bool rv;
329     (rv, ) = _implementation().delegatecall(data);
330     return rv;
331   }
332 
333 }