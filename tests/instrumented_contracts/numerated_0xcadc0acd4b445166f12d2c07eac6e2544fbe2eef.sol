1 // File: contracts/upgradeability/Proxy.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 /**
6  *
7  *
8  * Copyright (c) 2018 zOS Global Limited.
9  *
10  * Permission is hereby granted, free of charge, to any person obtaining a copy
11  * of this software and associated documentation files (the "Software"), to deal
12  * in the Software without restriction, including without limitation the rights
13  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14  * copies of the Software, and to permit persons to whom the Software is
15  * furnished to do so, subject to the following conditions:
16  *
17  * The above copyright notice and this permission notice shall be included in
18  * copies or substantial portions of the Software.
19  *
20  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
21  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
22  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
23  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
24  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
25  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
26  * SOFTWARE.
27  */
28 
29 pragma solidity 0.6.12;
30 
31 /**
32  * @notice Implements delegation of calls to other contracts, with proper
33  * forwarding of return values and bubbling of failures.
34  * It defines a fallback function that delegates all calls to the address
35  * returned by the abstract _implementation() internal function.
36  * @dev Forked from https://github.com/zeppelinos/zos-lib/blob/8a16ef3ad17ec7430e3a9d2b5e3f39b8204f8c8d/contracts/upgradeability/Proxy.sol
37  * Modifications:
38  * 1. Reformat and conform to Solidity 0.6 syntax (5/13/20)
39  */
40 abstract contract Proxy {
41     /**
42      * @dev Fallback function.
43      * Implemented entirely in `_fallback`.
44      */
45     fallback() external payable {
46         _fallback();
47     }
48 
49     /**
50      * @return The Address of the implementation.
51      */
52     function _implementation() internal virtual view returns (address);
53 
54     /**
55      * @dev Delegates execution to an implementation contract.
56      * This is a low level function that doesn't return to its internal call site.
57      * It will return to the external caller whatever the implementation returns.
58      * @param implementation Address to delegate.
59      */
60     function _delegate(address implementation) internal {
61         assembly {
62             // Copy msg.data. We take full control of memory in this inline assembly
63             // block because it will not return to Solidity code. We overwrite the
64             // Solidity scratch pad at memory position 0.
65             calldatacopy(0, 0, calldatasize())
66 
67             // Call the implementation.
68             // out and outsize are 0 because we don't know the size yet.
69             let result := delegatecall(
70                 gas(),
71                 implementation,
72                 0,
73                 calldatasize(),
74                 0,
75                 0
76             )
77 
78             // Copy the returned data.
79             returndatacopy(0, 0, returndatasize())
80 
81             switch result
82                 // delegatecall returns 0 on error.
83                 case 0 {
84                     revert(0, returndatasize())
85                 }
86                 default {
87                     return(0, returndatasize())
88                 }
89         }
90     }
91 
92     /**
93      * @dev Function that is run as the first thing in the fallback function.
94      * Can be redefined in derived contracts to add functionality.
95      * Redefinitions must call super._willFallback().
96      */
97     function _willFallback() internal virtual {}
98 
99     /**
100      * @dev fallback implementation.
101      * Extracted to enable manual triggering.
102      */
103     function _fallback() internal {
104         _willFallback();
105         _delegate(_implementation());
106     }
107 }
108 
109 // File: @openzeppelin/contracts/utils/Address.sol
110 
111 //
112 
113 pragma solidity ^0.6.2;
114 
115 /**
116  * @dev Collection of functions related to the address type
117  */
118 library Address {
119     /**
120      * @dev Returns true if `account` is a contract.
121      *
122      * [IMPORTANT]
123      * ====
124      * It is unsafe to assume that an address for which this function returns
125      * false is an externally-owned account (EOA) and not a contract.
126      *
127      * Among others, `isContract` will return false for the following
128      * types of addresses:
129      *
130      *  - an externally-owned account
131      *  - a contract in construction
132      *  - an address where a contract will be created
133      *  - an address where a contract lived, but was destroyed
134      * ====
135      */
136     function isContract(address account) internal view returns (bool) {
137         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
138         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
139         // for accounts without code, i.e. `keccak256('')`
140         bytes32 codehash;
141         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
142         // solhint-disable-next-line no-inline-assembly
143         assembly { codehash := extcodehash(account) }
144         return (codehash != accountHash && codehash != 0x0);
145     }
146 
147     /**
148      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
149      * `recipient`, forwarding all available gas and reverting on errors.
150      *
151      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
152      * of certain opcodes, possibly making contracts go over the 2300 gas limit
153      * imposed by `transfer`, making them unable to receive funds via
154      * `transfer`. {sendValue} removes this limitation.
155      *
156      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
157      *
158      * IMPORTANT: because control is transferred to `recipient`, care must be
159      * taken to not create reentrancy vulnerabilities. Consider using
160      * {ReentrancyGuard} or the
161      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
162      */
163     function sendValue(address payable recipient, uint256 amount) internal {
164         require(address(this).balance >= amount, "Address: insufficient balance");
165 
166         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
167         (bool success, ) = recipient.call{ value: amount }("");
168         require(success, "Address: unable to send value, recipient may have reverted");
169     }
170 
171     /**
172      * @dev Performs a Solidity function call using a low level `call`. A
173      * plain`call` is an unsafe replacement for a function call: use this
174      * function instead.
175      *
176      * If `target` reverts with a revert reason, it is bubbled up by this
177      * function (like regular Solidity function calls).
178      *
179      * Returns the raw returned data. To convert to the expected return value,
180      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
181      *
182      * Requirements:
183      *
184      * - `target` must be a contract.
185      * - calling `target` with `data` must not revert.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
190       return functionCall(target, data, "Address: low-level call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
195      * `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
200         return _functionCallWithValue(target, data, 0, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but also transferring `value` wei to `target`.
206      *
207      * Requirements:
208      *
209      * - the calling contract must have an ETH balance of at least `value`.
210      * - the called Solidity function must be `payable`.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
215         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
220      * with `errorMessage` as a fallback revert reason when `target` reverts.
221      *
222      * _Available since v3.1._
223      */
224     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
225         require(address(this).balance >= value, "Address: insufficient balance for call");
226         return _functionCallWithValue(target, data, value, errorMessage);
227     }
228 
229     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
230         require(isContract(target), "Address: call to non-contract");
231 
232         // solhint-disable-next-line avoid-low-level-calls
233         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
234         if (success) {
235             return returndata;
236         } else {
237             // Look for revert reason and bubble it up if present
238             if (returndata.length > 0) {
239                 // The easiest way to bubble the revert reason is using memory via assembly
240 
241                 // solhint-disable-next-line no-inline-assembly
242                 assembly {
243                     let returndata_size := mload(returndata)
244                     revert(add(32, returndata), returndata_size)
245                 }
246             } else {
247                 revert(errorMessage);
248             }
249         }
250     }
251 }
252 
253 // File: contracts/upgradeability/UpgradeabilityProxy.sol
254 
255 /**
256  *
257  *
258  * Copyright (c) 2018 zOS Global Limited.
259  *
260  * Permission is hereby granted, free of charge, to any person obtaining a copy
261  * of this software and associated documentation files (the "Software"), to deal
262  * in the Software without restriction, including without limitation the rights
263  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
264  * copies of the Software, and to permit persons to whom the Software is
265  * furnished to do so, subject to the following conditions:
266  *
267  * The above copyright notice and this permission notice shall be included in
268  * copies or substantial portions of the Software.
269  *
270  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
271  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
272  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
273  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
274  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
275  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
276  * SOFTWARE.
277  */
278 
279 pragma solidity 0.6.12;
280 
281 
282 
283 /**
284  * @notice This contract implements a proxy that allows to change the
285  * implementation address to which it will delegate.
286  * Such a change is called an implementation upgrade.
287  * @dev Forked from https://github.com/zeppelinos/zos-lib/blob/8a16ef3ad17ec7430e3a9d2b5e3f39b8204f8c8d/contracts/upgradeability/UpgradeabilityProxy.sol
288  * Modifications:
289  * 1. Reformat, conform to Solidity 0.6 syntax, and add error messages (5/13/20)
290  * 2. Use Address utility library from the latest OpenZeppelin (5/13/20)
291  */
292 contract UpgradeabilityProxy is Proxy {
293     /**
294      * @dev Emitted when the implementation is upgraded.
295      * @param implementation Address of the new implementation.
296      */
297     event Upgraded(address implementation);
298 
299     /**
300      * @dev Storage slot with the address of the current implementation.
301      * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
302      * validated in the constructor.
303      */
304     bytes32
305         private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
306 
307     /**
308      * @dev Contract constructor.
309      * @param implementationContract Address of the initial implementation.
310      */
311     constructor(address implementationContract) public {
312         assert(
313             IMPLEMENTATION_SLOT ==
314                 keccak256("org.zeppelinos.proxy.implementation")
315         );
316 
317         _setImplementation(implementationContract);
318     }
319 
320     /**
321      * @dev Returns the current implementation.
322      * @return impl Address of the current implementation
323      */
324     function _implementation() internal override view returns (address impl) {
325         bytes32 slot = IMPLEMENTATION_SLOT;
326         assembly {
327             impl := sload(slot)
328         }
329     }
330 
331     /**
332      * @dev Upgrades the proxy to a new implementation.
333      * @param newImplementation Address of the new implementation.
334      */
335     function _upgradeTo(address newImplementation) internal {
336         _setImplementation(newImplementation);
337         emit Upgraded(newImplementation);
338     }
339 
340     /**
341      * @dev Sets the implementation address of the proxy.
342      * @param newImplementation Address of the new implementation.
343      */
344     function _setImplementation(address newImplementation) private {
345         require(
346             Address.isContract(newImplementation),
347             "Cannot set a proxy implementation to a non-contract address"
348         );
349 
350         bytes32 slot = IMPLEMENTATION_SLOT;
351 
352         assembly {
353             sstore(slot, newImplementation)
354         }
355     }
356 }
357 
358 // File: contracts/upgradeability/AdminUpgradeabilityProxy.sol
359 
360 /**
361  *
362  *
363  * Copyright (c) 2018 zOS Global Limited.
364  *
365  * Permission is hereby granted, free of charge, to any person obtaining a copy
366  * of this software and associated documentation files (the "Software"), to deal
367  * in the Software without restriction, including without limitation the rights
368  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
369  * copies of the Software, and to permit persons to whom the Software is
370  * furnished to do so, subject to the following conditions:
371  *
372  * The above copyright notice and this permission notice shall be included in
373  * copies or substantial portions of the Software.
374  *
375  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
376  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
377  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
378  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
379  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
380  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
381  * SOFTWARE.
382  */
383 
384 pragma solidity 0.6.12;
385 
386 
387 /**
388  * @notice This contract combines an upgradeability proxy with an authorization
389  * mechanism for administrative tasks.
390  * @dev Forked from https://github.com/zeppelinos/zos-lib/blob/8a16ef3ad17ec7430e3a9d2b5e3f39b8204f8c8d/contracts/upgradeability/AdminUpgradeabilityProxy.sol
391  * Modifications:
392  * 1. Reformat, conform to Solidity 0.6 syntax, and add error messages (5/13/20)
393  * 2. Remove ifAdmin modifier from admin() and implementation() (5/13/20)
394  */
395 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
396     /**
397      * @dev Emitted when the administration has been transferred.
398      * @param previousAdmin Address of the previous admin.
399      * @param newAdmin Address of the new admin.
400      */
401     event AdminChanged(address previousAdmin, address newAdmin);
402 
403     /**
404      * @dev Storage slot with the admin of the contract.
405      * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
406      * validated in the constructor.
407      */
408     bytes32
409         private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
410 
411     /**
412      * @dev Modifier to check whether the `msg.sender` is the admin.
413      * If it is, it will run the function. Otherwise, it will delegate the call
414      * to the implementation.
415      */
416     modifier ifAdmin() {
417         if (msg.sender == _admin()) {
418             _;
419         } else {
420             _fallback();
421         }
422     }
423 
424     /**
425      * @dev Contract constructor.
426      * @param adminAddr address of the admin.
427      * @param implementationContract address of the initial implementation.
428      */
429     constructor(address adminAddr, address implementationContract)
430         public
431         UpgradeabilityProxy(implementationContract)
432     {
433         assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
434 
435         _setAdmin(adminAddr);
436     }
437 
438     /**
439      * @return The address of the proxy admin.
440      */
441     function admin() external view returns (address) {
442         return _admin();
443     }
444 
445     /**
446      * @return The address of the implementation.
447      */
448     function implementation() external view returns (address) {
449         return _implementation();
450     }
451 
452     /**
453      * @dev Changes the admin of the proxy.
454      * Only the current admin can call this function.
455      * @param newAdmin Address to transfer proxy administration to.
456      */
457     function changeAdmin(address newAdmin) external ifAdmin {
458         require(
459             newAdmin != address(0),
460             "Cannot change the admin of a proxy to the zero address"
461         );
462         emit AdminChanged(_admin(), newAdmin);
463         _setAdmin(newAdmin);
464     }
465 
466     /**
467      * @dev Upgrade the backing implementation of the proxy.
468      * Only the admin can call this function.
469      * @param newImplementation Address of the new implementation.
470      */
471     function upgradeTo(address newImplementation) external ifAdmin {
472         _upgradeTo(newImplementation);
473     }
474 
475     /**
476      * @dev Upgrade the backing implementation of the proxy and call a function
477      * on the new implementation.
478      * This is useful to initialize the proxied contract.
479      * @param newImplementation Address of the new implementation.
480      * @param data Data to send as msg.data in the low level call.
481      * It should include the signature and the parameters of the function to be
482      * called, as described in
483      * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
484      */
485     function upgradeToAndCall(address newImplementation, bytes calldata data)
486         external
487         payable
488         ifAdmin
489     {
490         _upgradeTo(newImplementation);
491         // prettier-ignore
492         // solhint-disable-next-line avoid-low-level-calls
493         (bool success,) = address(this).call{value: msg.value}(data);
494         // solhint-disable-next-line reason-string
495         require(success);
496     }
497 
498     /**
499      * @return adm The admin slot.
500      */
501     function _admin() internal view returns (address adm) {
502         bytes32 slot = ADMIN_SLOT;
503 
504         assembly {
505             adm := sload(slot)
506         }
507     }
508 
509     /**
510      * @dev Sets the address of the proxy admin.
511      * @param newAdmin Address of the new proxy admin.
512      */
513     function _setAdmin(address newAdmin) internal {
514         bytes32 slot = ADMIN_SLOT;
515 
516         assembly {
517             sstore(slot, newAdmin)
518         }
519     }
520 
521     /**
522      * @dev Only fall back when the sender is not the admin.
523      */
524     function _willFallback() internal override {
525         require(
526             msg.sender != _admin(),
527             "Cannot call fallback function from the proxy admin"
528         );
529         super._willFallback();
530     }
531 }
532 
533 // File: contracts/v1/FiatTokenProxy.sol
534 
535 /**
536  *
537  *
538  * Copyright (c) 2018-2020 CENTRE SECZ
539  *
540  * Permission is hereby granted, free of charge, to any person obtaining a copy
541  * of this software and associated documentation files (the "Software"), to deal
542  * in the Software without restriction, including without limitation the rights
543  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
544  * copies of the Software, and to permit persons to whom the Software is
545  * furnished to do so, subject to the following conditions:
546  *
547  * The above copyright notice and this permission notice shall be included in
548  * copies or substantial portions of the Software.
549  *
550  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
551  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
552  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
553  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
554  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
555  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
556  * SOFTWARE.
557  */
558 
559 pragma solidity 0.6.12;
560 
561 
562 /**
563  * @title FiatTokenProxy
564  * @dev This contract proxies FiatToken calls and enables FiatToken upgrades
565  */
566 contract FiatTokenProxy is AdminUpgradeabilityProxy {
567     constructor(address adminAddr, address implementationContract)
568         public
569         AdminUpgradeabilityProxy(adminAddr, implementationContract)
570     {}
571 }