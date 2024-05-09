1 /*
2 
3     /     |  __    / ____|
4    /      | |__) | | |
5   / /    |  _  /  | |
6  / ____   | |    | |____
7 /_/    _ |_|  _  _____|
8 
9 * ARC: ArcProxy.sol
10 *
11 * Latest source (may be newer): https://github.com/arcxgame/contracts/blob/master/contracts/ArcProxy.sol
12 *
13 * Contract Dependencies: 
14 *	- BaseAdminUpgradeabilityProxy
15 *	- BaseUpgradeabilityProxy
16 *	- Proxy
17 *	- UpgradeabilityProxy
18 * Libraries: 
19 *	- OpenZeppelinUpgradesAddress
20 *
21 * MIT License
22 * ===========
23 *
24 * Copyright (c) 2020 ARC
25 *
26 * Permission is hereby granted, free of charge, to any person obtaining a copy
27 * of this software and associated documentation files (the "Software"), to deal
28 * in the Software without restriction, including without limitation the rights
29 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
30 * copies of the Software, and to permit persons to whom the Software is
31 * furnished to do so, subject to the following conditions:
32 *
33 * The above copyright notice and this permission notice shall be included in all
34 * copies or substantial portions of the Software.
35 *
36 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
37 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
38 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
39 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
40 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
41 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
42 */
43 
44 pragma experimental ABIEncoderV2;
45 
46 /* ===============================================
47 * Flattened with Solidifier by Coinage
48 * 
49 * https://solidifier.coina.ge
50 * ===============================================
51 */
52 
53 
54 pragma solidity ^0.5.0;
55 
56 /**
57  * @title Proxy
58  * @dev Implements delegation of calls to other contracts, with proper
59  * forwarding of return values and bubbling of failures.
60  * It defines a fallback function that delegates all calls to the address
61  * returned by the abstract _implementation() internal function.
62  */
63 contract Proxy {
64   /**
65    * @dev Fallback function.
66    * Implemented entirely in `_fallback`.
67    */
68   function () payable external {
69     _fallback();
70   }
71 
72   /**
73    * @return The Address of the implementation.
74    */
75   function _implementation() internal view returns (address);
76 
77   /**
78    * @dev Delegates execution to an implementation contract.
79    * This is a low level function that doesn't return to its internal call site.
80    * It will return to the external caller whatever the implementation returns.
81    * @param implementation Address to delegate.
82    */
83   function _delegate(address implementation) internal {
84     assembly {
85       // Copy msg.data. We take full control of memory in this inline assembly
86       // block because it will not return to Solidity code. We overwrite the
87       // Solidity scratch pad at memory position 0.
88       calldatacopy(0, 0, calldatasize)
89 
90       // Call the implementation.
91       // out and outsize are 0 because we don't know the size yet.
92       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
93 
94       // Copy the returned data.
95       returndatacopy(0, 0, returndatasize)
96 
97       switch result
98       // delegatecall returns 0 on error.
99       case 0 { revert(0, returndatasize) }
100       default { return(0, returndatasize) }
101     }
102   }
103 
104   /**
105    * @dev Function that is run as the first thing in the fallback function.
106    * Can be redefined in derived contracts to add functionality.
107    * Redefinitions must call super._willFallback().
108    */
109   function _willFallback() internal {
110   }
111 
112   /**
113    * @dev fallback implementation.
114    * Extracted to enable manual triggering.
115    */
116   function _fallback() internal {
117     _willFallback();
118     _delegate(_implementation());
119   }
120 }
121 
122 
123 /**
124  * Utility library of inline functions on addresses
125  *
126  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
127  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
128  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
129  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
130  */
131 library OpenZeppelinUpgradesAddress {
132     /**
133      * Returns whether the target address is a contract
134      * @dev This function will return false if invoked during the constructor of a contract,
135      * as the code is not actually created until after the constructor finishes.
136      * @param account address of the account to check
137      * @return whether the target address is a contract
138      */
139     function isContract(address account) internal view returns (bool) {
140         uint256 size;
141         // XXX Currently there is no better way to check if there is a contract in an address
142         // than to check the size of the code at that address.
143         // See https://ethereum.stackexchange.com/a/14016/36603
144         // for more details about how this works.
145         // TODO Check this again before the Serenity release, because all addresses will be
146         // contracts then.
147         // solhint-disable-next-line no-inline-assembly
148         assembly { size := extcodesize(account) }
149         return size > 0;
150     }
151 }
152 
153 
154 /**
155  * @title BaseUpgradeabilityProxy
156  * @dev This contract implements a proxy that allows to change the
157  * implementation address to which it will delegate.
158  * Such a change is called an implementation upgrade.
159  */
160 contract BaseUpgradeabilityProxy is Proxy {
161   /**
162    * @dev Emitted when the implementation is upgraded.
163    * @param implementation Address of the new implementation.
164    */
165   event Upgraded(address indexed implementation);
166 
167   /**
168    * @dev Storage slot with the address of the current implementation.
169    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
170    * validated in the constructor.
171    */
172   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
173 
174   /**
175    * @dev Returns the current implementation.
176    * @return Address of the current implementation
177    */
178   function _implementation() internal view returns (address impl) {
179     bytes32 slot = IMPLEMENTATION_SLOT;
180     assembly {
181       impl := sload(slot)
182     }
183   }
184 
185   /**
186    * @dev Upgrades the proxy to a new implementation.
187    * @param newImplementation Address of the new implementation.
188    */
189   function _upgradeTo(address newImplementation) internal {
190     _setImplementation(newImplementation);
191     emit Upgraded(newImplementation);
192   }
193 
194   /**
195    * @dev Sets the implementation address of the proxy.
196    * @param newImplementation Address of the new implementation.
197    */
198   function _setImplementation(address newImplementation) internal {
199     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
200 
201     bytes32 slot = IMPLEMENTATION_SLOT;
202 
203     assembly {
204       sstore(slot, newImplementation)
205     }
206   }
207 }
208 
209 
210 /**
211  * @title UpgradeabilityProxy
212  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
213  * implementation and init data.
214  */
215 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
216   /**
217    * @dev Contract constructor.
218    * @param _logic Address of the initial implementation.
219    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
220    * It should include the signature and the parameters of the function to be called, as described in
221    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
222    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
223    */
224   constructor(address _logic, bytes memory _data) public payable {
225     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
226     _setImplementation(_logic);
227     if(_data.length > 0) {
228       (bool success,) = _logic.delegatecall(_data);
229       require(success);
230     }
231   }  
232 }
233 
234 
235 /**
236  * @title BaseAdminUpgradeabilityProxy
237  * @dev This contract combines an upgradeability proxy with an authorization
238  * mechanism for administrative tasks.
239  * All external functions in this contract must be guarded by the
240  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
241  * feature proposal that would enable this to be done automatically.
242  */
243 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
244   /**
245    * @dev Emitted when the administration has been transferred.
246    * @param previousAdmin Address of the previous admin.
247    * @param newAdmin Address of the new admin.
248    */
249   event AdminChanged(address previousAdmin, address newAdmin);
250 
251   /**
252    * @dev Storage slot with the admin of the contract.
253    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
254    * validated in the constructor.
255    */
256 
257   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
258 
259   /**
260    * @dev Modifier to check whether the `msg.sender` is the admin.
261    * If it is, it will run the function. Otherwise, it will delegate the call
262    * to the implementation.
263    */
264   modifier ifAdmin() {
265     if (msg.sender == _admin()) {
266       _;
267     } else {
268       _fallback();
269     }
270   }
271 
272   /**
273    * @return The address of the proxy admin.
274    */
275   function admin() external ifAdmin returns (address) {
276     return _admin();
277   }
278 
279   /**
280    * @return The address of the implementation.
281    */
282   function implementation() external ifAdmin returns (address) {
283     return _implementation();
284   }
285 
286   /**
287    * @dev Changes the admin of the proxy.
288    * Only the current admin can call this function.
289    * @param newAdmin Address to transfer proxy administration to.
290    */
291   function changeAdmin(address newAdmin) external ifAdmin {
292     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
293     emit AdminChanged(_admin(), newAdmin);
294     _setAdmin(newAdmin);
295   }
296 
297   /**
298    * @dev Upgrade the backing implementation of the proxy.
299    * Only the admin can call this function.
300    * @param newImplementation Address of the new implementation.
301    */
302   function upgradeTo(address newImplementation) external ifAdmin {
303     _upgradeTo(newImplementation);
304   }
305 
306   /**
307    * @dev Upgrade the backing implementation of the proxy and call a function
308    * on the new implementation.
309    * This is useful to initialize the proxied contract.
310    * @param newImplementation Address of the new implementation.
311    * @param data Data to send as msg.data in the low level call.
312    * It should include the signature and the parameters of the function to be called, as described in
313    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
314    */
315   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
316     _upgradeTo(newImplementation);
317     (bool success,) = newImplementation.delegatecall(data);
318     require(success);
319   }
320 
321   /**
322    * @return The admin slot.
323    */
324   function _admin() internal view returns (address adm) {
325     bytes32 slot = ADMIN_SLOT;
326     assembly {
327       adm := sload(slot)
328     }
329   }
330 
331   /**
332    * @dev Sets the address of the proxy admin.
333    * @param newAdmin Address of the new proxy admin.
334    */
335   function _setAdmin(address newAdmin) internal {
336     bytes32 slot = ADMIN_SLOT;
337 
338     assembly {
339       sstore(slot, newAdmin)
340     }
341   }
342 
343   /**
344    * @dev Only fall back when the sender is not the admin.
345    */
346   function _willFallback() internal {
347     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
348     super._willFallback();
349   }
350 }
351 
352 
353 /**
354  * @title AdminUpgradeabilityProxy
355  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
356  * initializing the implementation, admin, and init data.
357  */
358 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
359   /**
360    * Contract constructor.
361    * @param _logic address of the initial implementation.
362    * @param _admin Address of the proxy administrator.
363    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
364    * It should include the signature and the parameters of the function to be called, as described in
365    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
366    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
367    */
368   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
369     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
370     _setAdmin(_admin);
371   }
372 }
373 
374 
375 // SPDX-License-Identifier: MIT
376 
377 
378 /* solium-disable-next-line */
379 
380 
381 contract ArcProxy is
382     AdminUpgradeabilityProxy
383 {
384     /**
385      * @dev The constructor of the proxy that sets the admin and logic.
386      *
387      * @param  logic  The address of the contract that implements the underlying logic.
388      * @param  admin  The address of the admin of the proxy.
389      * @param  data   Any data to send immediately to the implementation contract.
390      */
391     constructor(
392         address logic,
393         address admin,
394         bytes memory data
395     )
396         public
397         AdminUpgradeabilityProxy(
398             logic,
399             admin,
400             data
401         )
402     {}
403 
404     /**
405      * @dev Overrides the default functionality that prevents the admin from reaching the
406      *  implementation contract.
407      */
408     function _willFallback()
409         internal
410     { /* solium-disable-line no-empty-blocks */ }
411 }