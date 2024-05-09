1 /*
2 
3     Copyright 2020 dYdX Trading Inc.
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.16;
20 pragma experimental ABIEncoderV2;
21 
22 // File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
23 
24 /**
25  * @title Proxy
26  * @dev Implements delegation of calls to other contracts, with proper
27  * forwarding of return values and bubbling of failures.
28  * It defines a fallback function that delegates all calls to the address
29  * returned by the abstract _implementation() internal function.
30  */
31 contract Proxy {
32   /**
33    * @dev Fallback function.
34    * Implemented entirely in `_fallback`.
35    */
36   function () payable external {
37     _fallback();
38   }
39 
40   /**
41    * @return The Address of the implementation.
42    */
43   function _implementation() internal view returns (address);
44 
45   /**
46    * @dev Delegates execution to an implementation contract.
47    * This is a low level function that doesn't return to its internal call site.
48    * It will return to the external caller whatever the implementation returns.
49    * @param implementation Address to delegate.
50    */
51   function _delegate(address implementation) internal {
52     assembly {
53       // Copy msg.data. We take full control of memory in this inline assembly
54       // block because it will not return to Solidity code. We overwrite the
55       // Solidity scratch pad at memory position 0.
56       calldatacopy(0, 0, calldatasize)
57 
58       // Call the implementation.
59       // out and outsize are 0 because we don't know the size yet.
60       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
61 
62       // Copy the returned data.
63       returndatacopy(0, 0, returndatasize)
64 
65       switch result
66       // delegatecall returns 0 on error.
67       case 0 { revert(0, returndatasize) }
68       default { return(0, returndatasize) }
69     }
70   }
71 
72   /**
73    * @dev Function that is run as the first thing in the fallback function.
74    * Can be redefined in derived contracts to add functionality.
75    * Redefinitions must call super._willFallback().
76    */
77   function _willFallback() internal {
78   }
79 
80   /**
81    * @dev fallback implementation.
82    * Extracted to enable manual triggering.
83    */
84   function _fallback() internal {
85     _willFallback();
86     _delegate(_implementation());
87   }
88 }
89 
90 // File: @openzeppelin/upgrades/contracts/utils/Address.sol
91 
92 /**
93  * Utility library of inline functions on addresses
94  *
95  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
96  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
97  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
98  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
99  */
100 library OpenZeppelinUpgradesAddress {
101     /**
102      * Returns whether the target address is a contract
103      * @dev This function will return false if invoked during the constructor of a contract,
104      * as the code is not actually created until after the constructor finishes.
105      * @param account address of the account to check
106      * @return whether the target address is a contract
107      */
108     function isContract(address account) internal view returns (bool) {
109         uint256 size;
110         // XXX Currently there is no better way to check if there is a contract in an address
111         // than to check the size of the code at that address.
112         // See https://ethereum.stackexchange.com/a/14016/36603
113         // for more details about how this works.
114         // TODO Check this again before the Serenity release, because all addresses will be
115         // contracts then.
116         // solhint-disable-next-line no-inline-assembly
117         assembly { size := extcodesize(account) }
118         return size > 0;
119     }
120 }
121 
122 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseUpgradeabilityProxy.sol
123 
124 /**
125  * @title BaseUpgradeabilityProxy
126  * @dev This contract implements a proxy that allows to change the
127  * implementation address to which it will delegate.
128  * Such a change is called an implementation upgrade.
129  */
130 contract BaseUpgradeabilityProxy is Proxy {
131   /**
132    * @dev Emitted when the implementation is upgraded.
133    * @param implementation Address of the new implementation.
134    */
135   event Upgraded(address indexed implementation);
136 
137   /**
138    * @dev Storage slot with the address of the current implementation.
139    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
140    * validated in the constructor.
141    */
142   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
143 
144   /**
145    * @dev Returns the current implementation.
146    * @return Address of the current implementation
147    */
148   function _implementation() internal view returns (address impl) {
149     bytes32 slot = IMPLEMENTATION_SLOT;
150     assembly {
151       impl := sload(slot)
152     }
153   }
154 
155   /**
156    * @dev Upgrades the proxy to a new implementation.
157    * @param newImplementation Address of the new implementation.
158    */
159   function _upgradeTo(address newImplementation) internal {
160     _setImplementation(newImplementation);
161     emit Upgraded(newImplementation);
162   }
163 
164   /**
165    * @dev Sets the implementation address of the proxy.
166    * @param newImplementation Address of the new implementation.
167    */
168   function _setImplementation(address newImplementation) internal {
169     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
170 
171     bytes32 slot = IMPLEMENTATION_SLOT;
172 
173     assembly {
174       sstore(slot, newImplementation)
175     }
176   }
177 }
178 
179 // File: @openzeppelin/upgrades/contracts/upgradeability/UpgradeabilityProxy.sol
180 
181 /**
182  * @title UpgradeabilityProxy
183  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
184  * implementation and init data.
185  */
186 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
187   /**
188    * @dev Contract constructor.
189    * @param _logic Address of the initial implementation.
190    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
191    * It should include the signature and the parameters of the function to be called, as described in
192    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
193    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
194    */
195   constructor(address _logic, bytes memory _data) public payable {
196     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
197     _setImplementation(_logic);
198     if(_data.length > 0) {
199       (bool success,) = _logic.delegatecall(_data);
200       require(success);
201     }
202   }
203 }
204 
205 // File: @openzeppelin/upgrades/contracts/upgradeability/BaseAdminUpgradeabilityProxy.sol
206 
207 /**
208  * @title BaseAdminUpgradeabilityProxy
209  * @dev This contract combines an upgradeability proxy with an authorization
210  * mechanism for administrative tasks.
211  * All external functions in this contract must be guarded by the
212  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
213  * feature proposal that would enable this to be done automatically.
214  */
215 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
216   /**
217    * @dev Emitted when the administration has been transferred.
218    * @param previousAdmin Address of the previous admin.
219    * @param newAdmin Address of the new admin.
220    */
221   event AdminChanged(address previousAdmin, address newAdmin);
222 
223   /**
224    * @dev Storage slot with the admin of the contract.
225    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
226    * validated in the constructor.
227    */
228 
229   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
230 
231   /**
232    * @dev Modifier to check whether the `msg.sender` is the admin.
233    * If it is, it will run the function. Otherwise, it will delegate the call
234    * to the implementation.
235    */
236   modifier ifAdmin() {
237     if (msg.sender == _admin()) {
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
248     return _admin();
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
259    * @dev Changes the admin of the proxy.
260    * Only the current admin can call this function.
261    * @param newAdmin Address to transfer proxy administration to.
262    */
263   function changeAdmin(address newAdmin) external ifAdmin {
264     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
265     emit AdminChanged(_admin(), newAdmin);
266     _setAdmin(newAdmin);
267   }
268 
269   /**
270    * @dev Upgrade the backing implementation of the proxy.
271    * Only the admin can call this function.
272    * @param newImplementation Address of the new implementation.
273    */
274   function upgradeTo(address newImplementation) external ifAdmin {
275     _upgradeTo(newImplementation);
276   }
277 
278   /**
279    * @dev Upgrade the backing implementation of the proxy and call a function
280    * on the new implementation.
281    * This is useful to initialize the proxied contract.
282    * @param newImplementation Address of the new implementation.
283    * @param data Data to send as msg.data in the low level call.
284    * It should include the signature and the parameters of the function to be called, as described in
285    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
286    */
287   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
288     _upgradeTo(newImplementation);
289     (bool success,) = newImplementation.delegatecall(data);
290     require(success);
291   }
292 
293   /**
294    * @return The admin slot.
295    */
296   function _admin() internal view returns (address adm) {
297     bytes32 slot = ADMIN_SLOT;
298     assembly {
299       adm := sload(slot)
300     }
301   }
302 
303   /**
304    * @dev Sets the address of the proxy admin.
305    * @param newAdmin Address of the new proxy admin.
306    */
307   function _setAdmin(address newAdmin) internal {
308     bytes32 slot = ADMIN_SLOT;
309 
310     assembly {
311       sstore(slot, newAdmin)
312     }
313   }
314 
315   /**
316    * @dev Only fall back when the sender is not the admin.
317    */
318   function _willFallback() internal {
319     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
320     super._willFallback();
321   }
322 }
323 
324 // File: @openzeppelin/upgrades/contracts/upgradeability/AdminUpgradeabilityProxy.sol
325 
326 /**
327  * @title AdminUpgradeabilityProxy
328  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for
329  * initializing the implementation, admin, and init data.
330  */
331 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
332   /**
333    * Contract constructor.
334    * @param _logic address of the initial implementation.
335    * @param _admin Address of the proxy administrator.
336    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
337    * It should include the signature and the parameters of the function to be called, as described in
338    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
339    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
340    */
341   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
342     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
343     _setAdmin(_admin);
344   }
345 }
346 
347 // File: contracts/protocol/PerpetualProxy.sol
348 
349 /* solium-disable-next-line */
350 
351 /**
352  * @title PerpetualProxy
353  * @author dYdX
354  *
355  * @notice Proxy contract that forwards calls to the main Perpetual contract.
356  */
357 contract PerpetualProxy is
358     AdminUpgradeabilityProxy
359 {
360     /**
361      * @dev The constructor of the proxy that sets the admin and logic.
362      *
363      * @param  logic  The address of the contract that implements the underlying logic.
364      * @param  admin  The address of the admin of the proxy.
365      * @param  data   Any data to send immediately to the implementation contract.
366      */
367     constructor(
368         address logic,
369         address admin,
370         bytes memory data
371     )
372         public
373         AdminUpgradeabilityProxy(
374             logic,
375             admin,
376             data
377         )
378     {}
379 
380     /**
381      * @dev Overrides the default functionality that prevents the admin from reaching the
382      *  implementation contract.
383      */
384     function _willFallback()
385         internal
386     { /* solium-disable-line no-empty-blocks */ }
387 }