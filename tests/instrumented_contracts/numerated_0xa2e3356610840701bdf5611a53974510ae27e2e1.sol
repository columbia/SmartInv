1 // Sources flattened with hardhat v2.14.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Address.sol@v3.1.0
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
31         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
32         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
33         // for accounts without code, i.e. `keccak256('')`
34         bytes32 codehash;
35         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { codehash := extcodehash(account) }
38         return (codehash != accountHash && codehash != 0x0);
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 
148 // File centre-tokens/contracts/upgradeability/Proxy.sol@v1.0.0
149 
150 /**
151  * 
152  *
153  * Copyright (c) 2018 zOS Global Limited.
154  *
155  * Permission is hereby granted, free of charge, to any person obtaining a copy
156  * of this software and associated documentation files (the "Software"), to deal
157  * in the Software without restriction, including without limitation the rights
158  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
159  * copies of the Software, and to permit persons to whom the Software is
160  * furnished to do so, subject to the following conditions:
161  *
162  * The above copyright notice and this permission notice shall be included in
163  * copies or substantial portions of the Software.
164  *
165  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
166  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
167  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
168  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
169  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
170  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
171  * SOFTWARE.
172  */
173 
174 pragma solidity 0.6.12;
175 
176 /**
177  * @notice Implements delegation of calls to other contracts, with proper
178  * forwarding of return values and bubbling of failures.
179  * It defines a fallback function that delegates all calls to the address
180  * returned by the abstract _implementation() internal function.
181  * @dev Forked from https://github.com/zeppelinos/zos-lib/blob/8a16ef3ad17ec7430e3a9d2b5e3f39b8204f8c8d/contracts/upgradeability/Proxy.sol
182  * Modifications:
183  * 1. Reformat and conform to Solidity 0.6 syntax (5/13/20)
184  */
185 abstract contract Proxy {
186     /**
187      * @dev Fallback function.
188      * Implemented entirely in `_fallback`.
189      */
190     fallback() external payable {
191         _fallback();
192     }
193 
194     /**
195      * @return The Address of the implementation.
196      */
197     function _implementation() internal virtual view returns (address);
198 
199     /**
200      * @dev Delegates execution to an implementation contract.
201      * This is a low level function that doesn't return to its internal call site.
202      * It will return to the external caller whatever the implementation returns.
203      * @param implementation Address to delegate.
204      */
205     function _delegate(address implementation) internal {
206         assembly {
207             // Copy msg.data. We take full control of memory in this inline assembly
208             // block because it will not return to Solidity code. We overwrite the
209             // Solidity scratch pad at memory position 0.
210             calldatacopy(0, 0, calldatasize())
211 
212             // Call the implementation.
213             // out and outsize are 0 because we don't know the size yet.
214             let result := delegatecall(
215                 gas(),
216                 implementation,
217                 0,
218                 calldatasize(),
219                 0,
220                 0
221             )
222 
223             // Copy the returned data.
224             returndatacopy(0, 0, returndatasize())
225 
226             switch result
227                 // delegatecall returns 0 on error.
228                 case 0 {
229                     revert(0, returndatasize())
230                 }
231                 default {
232                     return(0, returndatasize())
233                 }
234         }
235     }
236 
237     /**
238      * @dev Function that is run as the first thing in the fallback function.
239      * Can be redefined in derived contracts to add functionality.
240      * Redefinitions must call super._willFallback().
241      */
242     function _willFallback() internal virtual {}
243 
244     /**
245      * @dev fallback implementation.
246      * Extracted to enable manual triggering.
247      */
248     function _fallback() internal {
249         _willFallback();
250         _delegate(_implementation());
251     }
252 }
253 
254 
255 // File centre-tokens/contracts/upgradeability/UpgradeabilityProxy.sol@v1.0.0
256 
257 /**
258  * 
259  *
260  * Copyright (c) 2018 zOS Global Limited.
261  *
262  * Permission is hereby granted, free of charge, to any person obtaining a copy
263  * of this software and associated documentation files (the "Software"), to deal
264  * in the Software without restriction, including without limitation the rights
265  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
266  * copies of the Software, and to permit persons to whom the Software is
267  * furnished to do so, subject to the following conditions:
268  *
269  * The above copyright notice and this permission notice shall be included in
270  * copies or substantial portions of the Software.
271  *
272  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
273  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
274  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
275  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
276  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
277  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
278  * SOFTWARE.
279  */
280 
281 pragma solidity 0.6.12;
282 
283 
284 /**
285  * @notice This contract implements a proxy that allows to change the
286  * implementation address to which it will delegate.
287  * Such a change is called an implementation upgrade.
288  * @dev Forked from https://github.com/zeppelinos/zos-lib/blob/8a16ef3ad17ec7430e3a9d2b5e3f39b8204f8c8d/contracts/upgradeability/UpgradeabilityProxy.sol
289  * Modifications:
290  * 1. Reformat, conform to Solidity 0.6 syntax, and add error messages (5/13/20)
291  * 2. Use Address utility library from the latest OpenZeppelin (5/13/20)
292  */
293 contract UpgradeabilityProxy is Proxy {
294     /**
295      * @dev Emitted when the implementation is upgraded.
296      * @param implementation Address of the new implementation.
297      */
298     event Upgraded(address implementation);
299 
300     /**
301      * @dev Storage slot with the address of the current implementation.
302      * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
303      * validated in the constructor.
304      */
305     bytes32
306         private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
307 
308     /**
309      * @dev Contract constructor.
310      * @param implementationContract Address of the initial implementation.
311      */
312     constructor(address implementationContract) public {
313         assert(
314             IMPLEMENTATION_SLOT ==
315                 keccak256("org.zeppelinos.proxy.implementation")
316         );
317 
318         _setImplementation(implementationContract);
319     }
320 
321     /**
322      * @dev Returns the current implementation.
323      * @return impl Address of the current implementation
324      */
325     function _implementation() internal override view returns (address impl) {
326         bytes32 slot = IMPLEMENTATION_SLOT;
327         assembly {
328             impl := sload(slot)
329         }
330     }
331 
332     /**
333      * @dev Upgrades the proxy to a new implementation.
334      * @param newImplementation Address of the new implementation.
335      */
336     function _upgradeTo(address newImplementation) internal {
337         _setImplementation(newImplementation);
338         emit Upgraded(newImplementation);
339     }
340 
341     /**
342      * @dev Sets the implementation address of the proxy.
343      * @param newImplementation Address of the new implementation.
344      */
345     function _setImplementation(address newImplementation) private {
346         require(
347             Address.isContract(newImplementation),
348             "Cannot set a proxy implementation to a non-contract address"
349         );
350 
351         bytes32 slot = IMPLEMENTATION_SLOT;
352 
353         assembly {
354             sstore(slot, newImplementation)
355         }
356     }
357 }
358 
359 
360 // File centre-tokens/contracts/upgradeability/AdminUpgradeabilityProxy.sol@v1.0.0
361 
362 /**
363  * 
364  *
365  * Copyright (c) 2018 zOS Global Limited.
366  *
367  * Permission is hereby granted, free of charge, to any person obtaining a copy
368  * of this software and associated documentation files (the "Software"), to deal
369  * in the Software without restriction, including without limitation the rights
370  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
371  * copies of the Software, and to permit persons to whom the Software is
372  * furnished to do so, subject to the following conditions:
373  *
374  * The above copyright notice and this permission notice shall be included in
375  * copies or substantial portions of the Software.
376  *
377  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
378  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
379  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
380  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
381  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
382  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
383  * SOFTWARE.
384  */
385 
386 pragma solidity 0.6.12;
387 
388 /**
389  * @notice This contract combines an upgradeability proxy with an authorization
390  * mechanism for administrative tasks.
391  * @dev Forked from https://github.com/zeppelinos/zos-lib/blob/8a16ef3ad17ec7430e3a9d2b5e3f39b8204f8c8d/contracts/upgradeability/AdminUpgradeabilityProxy.sol
392  * Modifications:
393  * 1. Reformat, conform to Solidity 0.6 syntax, and add error messages (5/13/20)
394  * 2. Remove ifAdmin modifier from admin() and implementation() (5/13/20)
395  */
396 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
397     /**
398      * @dev Emitted when the administration has been transferred.
399      * @param previousAdmin Address of the previous admin.
400      * @param newAdmin Address of the new admin.
401      */
402     event AdminChanged(address previousAdmin, address newAdmin);
403 
404     /**
405      * @dev Storage slot with the admin of the contract.
406      * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
407      * validated in the constructor.
408      */
409     bytes32
410         private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
411 
412     /**
413      * @dev Modifier to check whether the `msg.sender` is the admin.
414      * If it is, it will run the function. Otherwise, it will delegate the call
415      * to the implementation.
416      */
417     modifier ifAdmin() {
418         if (msg.sender == _admin()) {
419             _;
420         } else {
421             _fallback();
422         }
423     }
424 
425     /**
426      * @dev Contract constructor.
427      * It sets the `msg.sender` as the proxy administrator.
428      * @param implementationContract address of the initial implementation.
429      */
430     constructor(address implementationContract)
431         public
432         UpgradeabilityProxy(implementationContract)
433     {
434         assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
435 
436         _setAdmin(msg.sender);
437     }
438 
439     /**
440      * @return The address of the proxy admin.
441      */
442     function admin() external view returns (address) {
443         return _admin();
444     }
445 
446     /**
447      * @return The address of the implementation.
448      */
449     function implementation() external view returns (address) {
450         return _implementation();
451     }
452 
453     /**
454      * @dev Changes the admin of the proxy.
455      * Only the current admin can call this function.
456      * @param newAdmin Address to transfer proxy administration to.
457      */
458     function changeAdmin(address newAdmin) external ifAdmin {
459         require(
460             newAdmin != address(0),
461             "Cannot change the admin of a proxy to the zero address"
462         );
463         emit AdminChanged(_admin(), newAdmin);
464         _setAdmin(newAdmin);
465     }
466 
467     /**
468      * @dev Upgrade the backing implementation of the proxy.
469      * Only the admin can call this function.
470      * @param newImplementation Address of the new implementation.
471      */
472     function upgradeTo(address newImplementation) external ifAdmin {
473         _upgradeTo(newImplementation);
474     }
475 
476     /**
477      * @dev Upgrade the backing implementation of the proxy and call a function
478      * on the new implementation.
479      * This is useful to initialize the proxied contract.
480      * @param newImplementation Address of the new implementation.
481      * @param data Data to send as msg.data in the low level call.
482      * It should include the signature and the parameters of the function to be
483      * called, as described in
484      * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
485      */
486     function upgradeToAndCall(address newImplementation, bytes calldata data)
487         external
488         payable
489         ifAdmin
490     {
491         _upgradeTo(newImplementation);
492         // prettier-ignore
493         // solhint-disable-next-line avoid-low-level-calls
494         (bool success,) = address(this).call{value: msg.value}(data);
495         // solhint-disable-next-line reason-string
496         require(success);
497     }
498 
499     /**
500      * @return adm The admin slot.
501      */
502     function _admin() internal view returns (address adm) {
503         bytes32 slot = ADMIN_SLOT;
504 
505         assembly {
506             adm := sload(slot)
507         }
508     }
509 
510     /**
511      * @dev Sets the address of the proxy admin.
512      * @param newAdmin Address of the new proxy admin.
513      */
514     function _setAdmin(address newAdmin) internal {
515         bytes32 slot = ADMIN_SLOT;
516 
517         assembly {
518             sstore(slot, newAdmin)
519         }
520     }
521 
522     /**
523      * @dev Only fall back when the sender is not the admin.
524      */
525     function _willFallback() internal override {
526         require(
527             msg.sender != _admin(),
528             "Cannot call fallback function from the proxy admin"
529         );
530         super._willFallback();
531     }
532 }
533 
534 
535 // File centre-tokens/contracts/v1/FiatTokenProxy.sol@v1.0.0
536 
537 /**
538  * 
539  *
540  * Copyright (c) 2018-2020 CENTRE SECZ
541  *
542  * Permission is hereby granted, free of charge, to any person obtaining a copy
543  * of this software and associated documentation files (the "Software"), to deal
544  * in the Software without restriction, including without limitation the rights
545  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
546  * copies of the Software, and to permit persons to whom the Software is
547  * furnished to do so, subject to the following conditions:
548  *
549  * The above copyright notice and this permission notice shall be included in
550  * copies or substantial portions of the Software.
551  *
552  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
553  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
554  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
555  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
556  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
557  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
558  * SOFTWARE.
559  */
560 
561 pragma solidity 0.6.12;
562 
563 /**
564  * @title FiatTokenProxy
565  * @dev This contract proxies FiatToken calls and enables FiatToken upgrades
566  */
567 contract FiatTokenProxy is AdminUpgradeabilityProxy {
568     constructor(address implementationContract)
569         public
570         AdminUpgradeabilityProxy(implementationContract)
571     {}
572 }
573 
574 
575 // File contracts/wrapped-tokens/FiatTokenProxy.sol
576 
577 /**
578  * 
579  *
580  * Copyright (c) 2022 Coinbase, Inc.
581  *
582  * Permission is hereby granted, free of charge, to any person obtaining a copy
583  * of this software and associated documentation files (the "Software"), to deal
584  * in the Software without restriction, including without limitation the rights
585  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
586  * copies of the Software, and to permit persons to whom the Software is
587  * furnished to do so, subject to the following conditions:
588  *
589  * The above copyright notice and this permission notice shall be included in
590  * copies or substantial portions of the Software.
591  *
592  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
593  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
594  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
595  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
596  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
597  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
598  * SOFTWARE.
599  */
600 
601 pragma solidity 0.6.12;