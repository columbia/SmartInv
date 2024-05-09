1 /**
2  * The MIT License (MIT)
3  *
4  * OpenZeppelin <https://github.com/OpenZeppelin/openzeppelin-solidity/>     
5  * Copyright (c) 2016 Smart Contract Solutions, Inc.
6  * 
7  * Permission is hereby granted, free of charge, to any person obtaining a copy 
8  * of this software and associated documentation files (the "Software"), to deal 
9  * in the Software without restriction, including without limitation the rights 
10  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
11  * copies of the Software, and to permit persons to whom the Software is furnished to 
12  * do so, subject to the following conditions:
13  *
14  * The above copyright notice and this permission notice shall be included in all 
15  * copies or substantial portions of the Software.
16  *
17  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
18  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
19  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
20  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
21  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
22  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
23  */
24 pragma solidity 0.4.25;
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33 
34   event OwnershipTransferred(
35     address indexed previousOwner,
36     address indexed newOwner
37   );
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   constructor() public {
44     owner = msg.sender;
45   }
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56    * @dev Allows the current owner to relinquish control of the contract.
57    * @notice Renouncing to ownership will leave the contract without an owner.
58    * It will not be possible to call the functions with the `onlyOwner`
59    * modifier anymore.
60    */
61   function renounceOwnership() public onlyOwner {
62     owner = address(0);
63     emit OwnershipTransferred(msg.sender, owner);
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address _newOwner) public onlyOwner {
71     _transferOwnership(_newOwner);
72   }
73 
74   /**
75    * @dev Transfers control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function _transferOwnership(address _newOwner) internal {
79     require(_newOwner != address(0));
80     owner = _newOwner;
81     emit OwnershipTransferred(owner, _newOwner);
82   }
83 }
84 
85 // File: contracts/zos/upgradeability/Proxy.sol
86 
87 /**
88  * The MIT License (MIT)
89  *
90  * ZeppelinOS (zos) <https://github.com/zeppelinos/zos>
91  * Copyright (c) 2018 ZeppelinOS Global Limited.
92  * 
93  * Permission is hereby granted, free of charge, to any person obtaining a copy 
94  * of this software and associated documentation files (the "Software"), to deal 
95  * in the Software without restriction, including without limitation the rights 
96  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
97  * copies of the Software, and to permit persons to whom the Software is furnished to 
98  * do so, subject to the following conditions:
99  *
100  * The above copyright notice and this permission notice shall be included in all 
101  * copies or substantial portions of the Software.
102  *
103  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
104  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
105  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
106  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
107  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
108  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
109  */
110 pragma solidity 0.4.25;
111 
112 /**
113  * @title Proxy
114  * @dev Implements delegation of calls to other contracts, with proper
115  * forwarding of return values and bubbling of failures.
116  * It defines a fallback function that delegates all calls to the address
117  * returned by the abstract _implementation() internal function.
118  */
119 contract Proxy {
120   /**
121    * @dev Fallback function.
122    * Implemented entirely in `_fallback`.
123    */
124   function () payable external {
125     _fallback();
126   }
127 
128   /**
129    * @return The Address of the implementation.
130    */
131   function _implementation() internal view returns (address);
132 
133   /**
134    * @dev Delegates execution to an implementation contract.
135    * This is a low level function that doesn't return to its internal call site.
136    * It will return to the external caller whatever the implementation returns.
137    * @param implementation Address to delegate.
138    */
139   function _delegate(address implementation) internal {
140     assembly {
141       // Copy msg.data. We take full control of memory in this inline assembly
142       // block because it will not return to Solidity code. We overwrite the
143       // Solidity scratch pad at memory position 0.
144       calldatacopy(0, 0, calldatasize)
145 
146       // Call the implementation.
147       // out and outsize are 0 because we don't know the size yet.
148       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
149 
150       // Copy the returned data.
151       returndatacopy(0, 0, returndatasize)
152 
153       switch result
154       // delegatecall returns 0 on error.
155       case 0 { revert(0, returndatasize) }
156       default { return(0, returndatasize) }
157     }
158   }
159 
160   /**
161    * @dev Function that is run as the first thing in the fallback function.
162    * Can be redefined in derived contracts to add functionality.
163    * Redefinitions must call super._willFallback().
164    */
165   function _willFallback() internal {
166   }
167 
168   /**
169    * @dev fallback implementation.
170    * Extracted to enable manual triggering.
171    */
172   function _fallback() internal {
173     _willFallback();
174     _delegate(_implementation());
175   }
176 }
177 
178 // File: contracts/utils/Address.sol
179 
180 /**
181  * The MIT License (MIT)
182  *
183  * OpenZeppelin <https://github.com/OpenZeppelin/openzeppelin-solidity/>     
184  * Copyright (c) 2016 Smart Contract Solutions, Inc.
185  *
186  * Permission is hereby granted, free of charge, to any person obtaining a copy 
187  * of this software and associated documentation files (the "Software"), to deal 
188  * in the Software without restriction, including without limitation the rights 
189  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
190  * copies of the Software, and to permit persons to whom the Software is furnished to 
191  * do so, subject to the following conditions:
192  *
193  * The above copyright notice and this permission notice shall be included in all 
194  * copies or substantial portions of the Software.
195  *
196  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
197  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
198  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
199  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
200  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
201  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
202  */
203 pragma solidity 0.4.25;
204 
205 /**
206  * Utility library of inline functions on addresses
207  */
208 library Address {
209     /**
210      * Returns whether the target address is a contract
211      * @dev This function will return false if invoked during the constructor of a contract,
212      * as the code is not actually created until after the constructor finishes.
213      * @param account address of the account to check
214      * @return whether the target address is a contract
215      */
216     function isContract(address account) internal view returns (bool) {
217         uint256 size;
218         // XXX Currently there is no better way to check if there is a contract in an address
219         // than to check the size of the code at that address.
220         // See https://ethereum.stackexchange.com/a/14016/36603
221         // for more details about how this works.
222         // TODO Check this again before the Serenity release, because all addresses will be
223         // contracts then.
224         // solhint-disable-next-line no-inline-assembly
225         assembly { size := extcodesize(account) }
226         return size > 0;
227     }
228 }
229 
230 // File: contracts/zos/upgradeability/UpgradeabilityProxy.sol
231 
232 /**
233  * The MIT License (MIT)
234  *
235  * ZeppelinOS (zos) <https://github.com/zeppelinos/zos>
236  * Copyright (c) 2018 ZeppelinOS Global Limited.
237  * 
238  * Permission is hereby granted, free of charge, to any person obtaining a copy 
239  * of this software and associated documentation files (the "Software"), to deal 
240  * in the Software without restriction, including without limitation the rights 
241  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
242  * copies of the Software, and to permit persons to whom the Software is furnished to 
243  * do so, subject to the following conditions:
244  *
245  * The above copyright notice and this permission notice shall be included in all 
246  * copies or substantial portions of the Software.
247  *
248  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
249  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
250  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
251  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
252  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
253  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
254  */
255 pragma solidity 0.4.25;
256 
257 
258 
259 /**
260  * @title UpgradeabilityProxy
261  * @dev This contract implements a proxy that allows to change the
262  * implementation address to which it will delegate.
263  * Such a change is called an implementation upgrade.
264  */
265 contract UpgradeabilityProxy is Proxy {
266   /**
267    * @dev Emitted when the implementation is upgraded.
268    * @param implementation Address of the new implementation.
269    */
270   event Upgraded(address indexed implementation);
271 
272   /**
273    * @dev Storage slot with the address of the current implementation.
274    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
275    * validated in the constructor.
276    */
277   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
278 
279   /**
280    * @dev Contract constructor.
281    * @param _implementation Address of the initial implementation.
282    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
283    * It should include the signature and the parameters of the function to be called, as described in
284    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
285    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
286    */
287   constructor(address _implementation, bytes _data) public payable {
288     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
289     _setImplementation(_implementation);
290     if(_data.length > 0) {
291       require(_implementation.delegatecall(_data));
292     }
293   }
294 
295   /**
296    * @dev Returns the current implementation.
297    * @return Address of the current implementation
298    */
299   function _implementation() internal view returns (address impl) {
300     bytes32 slot = IMPLEMENTATION_SLOT;
301     assembly {
302       impl := sload(slot)
303     }
304   }
305 
306   /**
307    * @dev Upgrades the proxy to a new implementation.
308    * @param newImplementation Address of the new implementation.
309    */
310   function _upgradeTo(address newImplementation) internal {
311     _setImplementation(newImplementation);
312     emit Upgraded(newImplementation);
313   }
314 
315   /**
316    * @dev Sets the implementation address of the proxy.
317    * @param newImplementation Address of the new implementation.
318    */
319   function _setImplementation(address newImplementation) private {
320     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
321 
322     bytes32 slot = IMPLEMENTATION_SLOT;
323 
324     assembly {
325       sstore(slot, newImplementation)
326     }
327   }
328 }
329 
330 // File: contracts/zos/upgradeability/AdminUpgradeabilityProxy.sol
331 
332 /**
333  * The MIT License (MIT)
334  *
335  * ZeppelinOS (zos) <https://github.com/zeppelinos/zos>
336  * Copyright (c) 2018 ZeppelinOS Global Limited.
337  * 
338  * Permission is hereby granted, free of charge, to any person obtaining a copy 
339  * of this software and associated documentation files (the "Software"), to deal 
340  * in the Software without restriction, including without limitation the rights 
341  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
342  * copies of the Software, and to permit persons to whom the Software is furnished to 
343  * do so, subject to the following conditions:
344  *
345  * The above copyright notice and this permission notice shall be included in all 
346  * copies or substantial portions of the Software.
347  *
348  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
349  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
350  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
351  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
352  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
353  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
354  */
355 pragma solidity 0.4.25;
356 
357 
358 /**
359  * @title AdminUpgradeabilityProxy
360  * @dev This contract combines an upgradeability proxy with an authorization
361  * mechanism for administrative tasks.
362  * All external functions in this contract must be guarded by the
363  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
364  * feature proposal that would enable this to be done automatically.
365  */
366 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
367   /**
368    * @dev Emitted when the administration has been transferred.
369    * @param previousAdmin Address of the previous admin.
370    * @param newAdmin Address of the new admin.
371    */
372   event AdminChanged(address previousAdmin, address newAdmin);
373 
374   /**
375    * @dev Storage slot with the admin of the contract.
376    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
377    * validated in the constructor.
378    */
379   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
380 
381   /**
382    * @dev Modifier to check whether the `msg.sender` is the admin.
383    * If it is, it will run the function. Otherwise, it will delegate the call
384    * to the implementation.
385    */
386   modifier ifAdmin() {
387     if (msg.sender == _admin()) {
388       _;
389     } else {
390       _fallback();
391     }
392   }
393 
394   /**
395    * Contract constructor.
396    * @param _implementation address of the initial implementation.
397    * @param _admin Address of the proxy administrator.
398    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
399    * It should include the signature and the parameters of the function to be called, as described in
400    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
401    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
402    */
403   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
404     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
405 
406     _setAdmin(_admin);
407   }
408 
409   /**
410    * @return The address of the proxy admin.
411    */
412   function admin() external view ifAdmin returns (address) {
413     return _admin();
414   }
415 
416   /**
417    * @return The address of the implementation.
418    */
419   function implementation() external view ifAdmin returns (address) {
420     return _implementation();
421   }
422 
423   /**
424    * @dev Changes the admin of the proxy.
425    * Only the current admin can call this function.
426    * @param newAdmin Address to transfer proxy administration to.
427    */
428   function changeAdmin(address newAdmin) external ifAdmin {
429     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
430     emit AdminChanged(_admin(), newAdmin);
431     _setAdmin(newAdmin);
432   }
433 
434   /**
435    * @dev Upgrade the backing implementation of the proxy.
436    * Only the admin can call this function.
437    * @param newImplementation Address of the new implementation.
438    */
439   function upgradeTo(address newImplementation) external ifAdmin {
440     _upgradeTo(newImplementation);
441   }
442 
443   /**
444    * @dev Upgrade the backing implementation of the proxy and call a function
445    * on the new implementation.
446    * This is useful to initialize the proxied contract.
447    * @param newImplementation Address of the new implementation.
448    * @param data Data to send as msg.data in the low level call.
449    * It should include the signature and the parameters of the function to be called, as described in
450    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
451    */
452   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
453     _upgradeTo(newImplementation);
454     require(newImplementation.delegatecall(data));
455   }
456 
457   /**
458    * @return The admin slot.
459    */
460   function _admin() internal view returns (address adm) {
461     bytes32 slot = ADMIN_SLOT;
462     assembly {
463       adm := sload(slot)
464     }
465   }
466 
467   /**
468    * @dev Sets the address of the proxy admin.
469    * @param newAdmin Address of the new proxy admin.
470    */
471   function _setAdmin(address newAdmin) internal {
472     bytes32 slot = ADMIN_SLOT;
473 
474     assembly {
475       sstore(slot, newAdmin)
476     }
477   }
478 
479   /**
480    * @dev Only fall back when the sender is not the admin.
481    */
482   function _willFallback() internal {
483     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
484     super._willFallback();
485   }
486 }
487 
488 // File: contracts/zos/upgradeability/ProxyAdmin.sol
489 
490 /**
491  * The MIT License (MIT)
492  *
493  * ZeppelinOS (zos) <https://github.com/zeppelinos/zos>
494  * Copyright (c) 2018 ZeppelinOS Global Limited.
495  * 
496  * Permission is hereby granted, free of charge, to any person obtaining a copy 
497  * of this software and associated documentation files (the "Software"), to deal 
498  * in the Software without restriction, including without limitation the rights 
499  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
500  * copies of the Software, and to permit persons to whom the Software is furnished to 
501  * do so, subject to the following conditions:
502  *
503  * The above copyright notice and this permission notice shall be included in all 
504  * copies or substantial portions of the Software.
505  *
506  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
507  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
508  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
509  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
510  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
511  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
512  */
513 pragma solidity 0.4.25;
514 
515 
516 /**
517  * @title ProxyAdmin
518  * @dev This contract is the admin of a proxy, and is in charge
519  * of upgrading it as well as transferring it to another admin.
520  */
521 contract ProxyAdmin is Ownable {
522   /**
523    * @dev Returns the current implementation of a proxy.
524    * This is needed because only the proxy admin can query it.
525    * @return The address of the current implementation of the proxy.
526    */
527   function getProxyImplementation(AdminUpgradeabilityProxy proxy) public view returns (address) {
528     return proxy.implementation();
529   }
530 
531   /**
532    * @dev Returns the admin of a proxy. Only the admin can query it.
533    * @return The address of the current admin of the proxy.
534    */
535   function getProxyAdmin(AdminUpgradeabilityProxy proxy) public view returns (address) {
536     return proxy.admin();
537   }
538 
539   /**
540    * @dev Changes the admin of a proxy.
541    * @param proxy Proxy to change admin.
542    * @param newAdmin Address to transfer proxy administration to.
543    */
544   function changeProxyAdmin(AdminUpgradeabilityProxy proxy, address newAdmin) public onlyOwner {
545     proxy.changeAdmin(newAdmin);
546   }
547 
548   /**
549    * @dev Upgrades a proxy to the newest implementation of a contract.
550    * @param proxy Proxy to be upgraded.
551    * @param implementation the address of the Implementation.
552    */
553   function upgrade(AdminUpgradeabilityProxy proxy, address implementation) public onlyOwner {
554     proxy.upgradeTo(implementation);
555   }
556 
557   /**
558    * @dev Upgrades a proxy to the newest implementation of a contract and forwards a function call to it.
559    * This is useful to initialize the proxied contract.
560    * @param proxy Proxy to be upgraded.
561    * @param implementation Address of the Implementation.
562    * @param data Data to send as msg.data in the low level call.
563    * It should include the signature and the parameters of the function to be called, as described in
564    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
565    */
566   function upgradeAndCall(AdminUpgradeabilityProxy proxy, address implementation, bytes data) payable public onlyOwner {
567     proxy.upgradeToAndCall.value(msg.value)(implementation, data);
568   }
569 }