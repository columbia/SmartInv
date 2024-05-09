1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // SPDX-License-Identifier: UNLICENSED
4 //
5 
6 /*                                                                                
7                                      &@@@@@@@@@@@        @@@@@@@@@@@@@@         
8                                  @@@@@@@@@@@@@@@@@@%  @@@@@@@@@@@@@@@@@@@@      
9            @@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     
10         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@    
11      /@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&   #@@@@@@@@@@@@@@@@@@@    @@@@@@@@@@@    
12     @@@@@@@@@@@   (@@@@@@@@@@@@@@@@@@    %@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@   
13    @@@@@@@@@@@*    .@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@      @@@@@@@@@@@@   
14    @@@@@@@@@@@      @@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@      @@@@@@@@@@@    
15   @@@@@@@@@@@&     ,@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@       @@@@@@@@@@@    
16   @@@@@@@@@@@@    /@@@@@@@@@@@@@@@@@@/ @@@@@@@@@@@@@@@@@@@      @@@@@@@@@@@     
17   @@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      @@@@@@@@@@@      
18   (@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@       
19    @@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@@@        
20     @@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@          
21       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,@@@@@@@@@@@            
22          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              
23              (@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@                 
24                                       @@@@@@@@@@@@@@@@@@@@@                     
25                                             @@@@@@@@@@@                #@@@@@,  
26                                             @@@@@@@@@@@          @@@@@@@@@@@@@@@
27                           @@@@@@@@@@.       @@@@@@@@@@@       @@@@@@@@@@@@@@@@, 
28                         @@@@@@@@@@@@@@@@    @@@@@@@@@@@    &@@@@@@@@@@@         
29                         &@@@@@@@@@@@@@@@@@# @@@@@@@@@@@   @@@@@@@@@@@           
30                          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*@@@@@@@@@@@@            
31                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              
32                            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@               
33                             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                
34                               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                 
35                                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&                 
36                                  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  
37                                    @@@@@@@@@@@@@@@@@@@@@@@@@@                   
38                                      @@@@@@@@@@@@@@@@@@@@@@@                    
39                                        @@@@@@@@@@@@@@@@@@@@(                    
40                                          @@@@@@@@@@@@@@@@@&                     
41                                            @@@@@@@@@@@@@@(                      
42                                              @@@@@@@@@@@                        
43                                               .@@@@@#                           
44 */
45 
46 // File @openzeppelin/contracts/utils/Address.sol@v4.3.3
47 
48 // License: MIT
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev Collection of functions related to the address type
54  */
55 library Address {
56     /**
57      * @dev Returns true if `account` is a contract.
58      *
59      * [IMPORTANT]
60      * ====
61      * It is unsafe to assume that an address for which this function returns
62      * false is an externally-owned account (EOA) and not a contract.
63      *
64      * Among others, `isContract` will return false for the following
65      * types of addresses:
66      *
67      *  - an externally-owned account
68      *  - a contract in construction
69      *  - an address where a contract will be created
70      *  - an address where a contract lived, but was destroyed
71      * ====
72      */
73     function isContract(address account) internal view returns (bool) {
74         // This method relies on extcodesize, which returns 0 for contracts in
75         // construction, since the code is only stored at the end of the
76         // constructor execution.
77 
78         uint256 size;
79         assembly {
80             size := extcodesize(account)
81         }
82         return size > 0;
83     }
84 
85     /**
86      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
87      * `recipient`, forwarding all available gas and reverting on errors.
88      *
89      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
90      * of certain opcodes, possibly making contracts go over the 2300 gas limit
91      * imposed by `transfer`, making them unable to receive funds via
92      * `transfer`. {sendValue} removes this limitation.
93      *
94      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
95      *
96      * IMPORTANT: because control is transferred to `recipient`, care must be
97      * taken to not create reentrancy vulnerabilities. Consider using
98      * {ReentrancyGuard} or the
99      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
100      */
101     function sendValue(address payable recipient, uint256 amount) internal {
102         require(address(this).balance >= amount, "Address: insufficient balance");
103 
104         (bool success, ) = recipient.call{value: amount}("");
105         require(success, "Address: unable to send value, recipient may have reverted");
106     }
107 
108     /**
109      * @dev Performs a Solidity function call using a low level `call`. A
110      * plain `call` is an unsafe replacement for a function call: use this
111      * function instead.
112      *
113      * If `target` reverts with a revert reason, it is bubbled up by this
114      * function (like regular Solidity function calls).
115      *
116      * Returns the raw returned data. To convert to the expected return value,
117      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
118      *
119      * Requirements:
120      *
121      * - `target` must be a contract.
122      * - calling `target` with `data` must not revert.
123      *
124      * _Available since v3.1._
125      */
126     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
127         return functionCall(target, data, "Address: low-level call failed");
128     }
129 
130     /**
131      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
132      * `errorMessage` as a fallback revert reason when `target` reverts.
133      *
134      * _Available since v3.1._
135      */
136     function functionCall(
137         address target,
138         bytes memory data,
139         string memory errorMessage
140     ) internal returns (bytes memory) {
141         return functionCallWithValue(target, data, 0, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but also transferring `value` wei to `target`.
147      *
148      * Requirements:
149      *
150      * - the calling contract must have an ETH balance of at least `value`.
151      * - the called Solidity function must be `payable`.
152      *
153      * _Available since v3.1._
154      */
155     function functionCallWithValue(
156         address target,
157         bytes memory data,
158         uint256 value
159     ) internal returns (bytes memory) {
160         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
165      * with `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCallWithValue(
170         address target,
171         bytes memory data,
172         uint256 value,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         require(address(this).balance >= value, "Address: insufficient balance for call");
176         require(isContract(target), "Address: call to non-contract");
177 
178         (bool success, bytes memory returndata) = target.call{value: value}(data);
179         return verifyCallResult(success, returndata, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but performing a static call.
185      *
186      * _Available since v3.3._
187      */
188     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
189         return functionStaticCall(target, data, "Address: low-level static call failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
194      * but performing a static call.
195      *
196      * _Available since v3.3._
197      */
198     function functionStaticCall(
199         address target,
200         bytes memory data,
201         string memory errorMessage
202     ) internal view returns (bytes memory) {
203         require(isContract(target), "Address: static call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.staticcall(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but performing a delegate call.
212      *
213      * _Available since v3.4._
214      */
215     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
216         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
221      * but performing a delegate call.
222      *
223      * _Available since v3.4._
224      */
225     function functionDelegateCall(
226         address target,
227         bytes memory data,
228         string memory errorMessage
229     ) internal returns (bytes memory) {
230         require(isContract(target), "Address: delegate call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.delegatecall(data);
233         return verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     /**
237      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
238      * revert reason using the provided one.
239      *
240      * _Available since v4.3._
241      */
242     function verifyCallResult(
243         bool success,
244         bytes memory returndata,
245         string memory errorMessage
246     ) internal pure returns (bytes memory) {
247         if (success) {
248             return returndata;
249         } else {
250             // Look for revert reason and bubble it up if present
251             if (returndata.length > 0) {
252                 // The easiest way to bubble the revert reason is using memory via assembly
253 
254                 assembly {
255                     let returndata_size := mload(returndata)
256                     revert(add(32, returndata), returndata_size)
257                 }
258             } else {
259                 revert(errorMessage);
260             }
261         }
262     }
263 }
264 
265 
266 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.3
267 
268 // License: MIT
269 
270 pragma solidity ^0.8.0;
271 
272 /**
273  * @dev String operations.
274  */
275 library Strings {
276     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
277 
278     /**
279      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
280      */
281     function toString(uint256 value) internal pure returns (string memory) {
282         // Inspired by OraclizeAPI's implementation - MIT licence
283         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
284 
285         if (value == 0) {
286             return "0";
287         }
288         uint256 temp = value;
289         uint256 digits;
290         while (temp != 0) {
291             digits++;
292             temp /= 10;
293         }
294         bytes memory buffer = new bytes(digits);
295         while (value != 0) {
296             digits -= 1;
297             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
298             value /= 10;
299         }
300         return string(buffer);
301     }
302 
303     /**
304      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
305      */
306     function toHexString(uint256 value) internal pure returns (string memory) {
307         if (value == 0) {
308             return "0x00";
309         }
310         uint256 temp = value;
311         uint256 length = 0;
312         while (temp != 0) {
313             length++;
314             temp >>= 8;
315         }
316         return toHexString(value, length);
317     }
318 
319     /**
320      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
321      */
322     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
323         bytes memory buffer = new bytes(2 * length + 2);
324         buffer[0] = "0";
325         buffer[1] = "x";
326         for (uint256 i = 2 * length + 1; i > 1; --i) {
327             buffer[i] = _HEX_SYMBOLS[value & 0xf];
328             value >>= 4;
329         }
330         require(value == 0, "Strings: hex length insufficient");
331         return string(buffer);
332     }
333 }
334 
335 
336 // File contracts/V1/MathV1.sol
337 
338 // License: UNLICENSED
339 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
340 
341 pragma solidity ^0.8.0;
342 
343 library MathV1 {
344     function max(int256 a, int256 b) internal pure returns (int256) {
345         return a >= b ? a : b;
346     }
347 
348     function min(int256 a, int256 b) internal pure returns (int256) {
349         return a < b ? a : b;
350     }
351 
352     function max3(
353         int256 a,
354         int256 b,
355         int256 c
356     ) internal pure returns (int256) {
357         int256 d = b >= c ? b : c;
358         return a >= d ? a : d;
359     }
360 
361     function min3(
362         int256 a,
363         int256 b,
364         int256 c
365     ) internal pure returns (int256) {
366         int256 d = b < c ? b : c;
367         return a < d ? a : d;
368     }
369 
370     function abs(int256 x) internal pure returns (int256) {
371         return x >= 0 ? x : -x;
372     }
373 
374     function sign(int256 x) internal pure returns (int8) {
375         return x == 0 ? int8(0) : x > 0 ? int8(1) : int8(-1);
376     }
377 }
378 
379 
380 // File contracts/V1/Fix64V1.sol
381 
382 // License: UNLICENSED
383 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
384 
385 pragma solidity ^0.8.0;
386 /*
387     Provides mathematical operations and representation in Q31.Q32 format.
388 
389     exp: Adapted from Petteri Aimonen's libfixmath
390     
391     See: https://github.com/PetteriAimonen/libfixmath
392          https://github.com/PetteriAimonen/libfixmath/blob/master/LICENSE
393 
394     other functions: Adapted from Andr├⌐ Slupik's FixedMath.NET
395                      https://github.com/asik/FixedMath.Net/blob/master/LICENSE.txt
396          
397     THIRD PARTY NOTICES:
398     ====================
399 
400     libfixmath is Copyright (c) 2011-2021 Flatmush <Flatmush@gmail.com>,
401     Petteri Aimonen <Petteri.Aimonen@gmail.com>, & libfixmath AUTHORS
402 
403     Permission is hereby granted, free of charge, to any person obtaining a copy
404     of this software and associated documentation files (the "Software"), to deal
405     in the Software without restriction, including without limitation the rights
406     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
407     copies of the Software, and to permit persons to whom the Software is
408     furnished to do so, subject to the following conditions:
409 
410     The above copyright notice and this permission notice shall be included in all
411     copies or substantial portions of the Software.
412 
413     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
414     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
415     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
416     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
417     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
418     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
419     SOFTWARE.
420 
421     Copyright 2012 Andr├⌐ Slupik
422 
423     Licensed under the Apache License, Version 2.0 (the "License");
424     you may not use this file except in compliance with the License.
425     You may obtain a copy of the License at
426 
427         http://www.apache.org/licenses/LICENSE-2.0
428 
429     Unless required by applicable law or agreed to in writing, software
430     distributed under the License is distributed on an "AS IS" BASIS,
431     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
432     See the License for the specific language governing permissions and
433     limitations under the License.
434 
435     This project uses code from the log2fix library, which is under the following license:           
436     The MIT License (MIT)
437 
438     Copyright (c) 2015 Dan Moulding
439     
440     Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
441     to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
442     and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
443     
444     The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
445     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
446     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
447     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
448     IN THE SOFTWARE.
449 */
450 
451 library Fix64V1 {
452     int64 public constant FRACTIONAL_PLACES = 32;
453     int64 public constant ONE = 4294967296; // 1 << FRACTIONAL_PLACES
454     int64 public constant TWO = ONE * 2;
455     int64 public constant PI = 0x3243F6A88;
456     int64 public constant TWO_PI = 0x6487ED511;
457     int64 public constant MAX_VALUE = type(int64).max;
458     int64 public constant MIN_VALUE = type(int64).min;
459     int64 public constant PI_OVER_2 = 0x1921FB544;
460 
461     function countLeadingZeros(uint64 x) internal pure returns (int64) {        
462         int64 result = 0;
463         while ((x & 0xF000000000000000) == 0) {
464             result += 4;
465             x <<= 4;
466         }
467         while ((x & 0x8000000000000000) == 0) {
468             result += 1;
469             x <<= 1;
470         }
471         return result;
472     }
473 
474     function div(int64 x, int64 y)
475         internal
476         pure
477         returns (int64)
478     {
479         if (y == 0) {
480             revert("attempted to divide by zero");
481         }
482 
483         int64 xl = x;
484         int64 yl = y;        
485 
486         uint64 remainder = uint64(xl >= 0 ? xl : -xl);
487         uint64 divider = uint64((yl >= 0 ? yl : -yl));
488         uint64 quotient = 0;
489         int64 bitPos = 64 / 2 + 1;
490 
491         while ((divider & 0xF) == 0 && bitPos >= 4) {
492             divider >>= 4;
493             bitPos -= 4;
494         }
495 
496         while (remainder != 0 && bitPos >= 0) {
497             int64 shift = countLeadingZeros(remainder);
498             if (shift > bitPos) {
499                 shift = bitPos;
500             }
501             remainder <<= uint64(shift);
502             bitPos -= shift;
503 
504             uint64 d = remainder / divider;
505             remainder = remainder % divider;
506             quotient += d << uint64(bitPos);
507 
508             if ((d & ~(uint64(0xFFFFFFFFFFFFFFFF) >> uint64(bitPos)) != 0)) {
509                 return
510                     ((xl ^ yl) & MIN_VALUE) == 0
511                         ? MAX_VALUE
512                         : MIN_VALUE;
513             }
514 
515             remainder <<= 1;
516             --bitPos;
517         }
518 
519         ++quotient;
520         int64 result = int64(quotient >> 1);
521         if (((xl ^ yl) & MIN_VALUE) != 0) {
522             result = -result;
523         }
524 
525         return int64(result);
526     }
527 
528     function mul(int64 x, int64 y)
529         internal
530         pure
531         returns (int64)
532     {
533         int64 xl = x;
534         int64 yl = y;
535 
536         uint64 xlo = (uint64)((xl & (int64)(0x00000000FFFFFFFF)));
537         int64 xhi = xl >> 32; // FRACTIONAL_PLACES
538         uint64 ylo = (uint64)(yl & (int64)(0x00000000FFFFFFFF));
539         int64 yhi = yl >> 32; // FRACTIONAL_PLACES
540 
541         uint64 lolo = xlo * ylo;
542         int64 lohi = int64(xlo) * yhi;
543         int64 hilo = xhi * int64(ylo);
544         int64 hihi = xhi * yhi;
545 
546         uint64 loResult = lolo >> 32; // FRACTIONAL_PLACES
547         int64 midResult1 = lohi;
548         int64 midResult2 = hilo;
549         int64 hiResult = hihi << 32; // FRACTIONAL_PLACES
550 
551         int64 sum = int64(loResult) + midResult1 + midResult2 + hiResult;
552 
553         return int64(sum);
554     }
555 
556     function mul_256(int x, int y)
557         internal
558         pure
559         returns (int)
560     {
561         int xl = x;
562         int yl = y;
563 
564         uint xlo = uint((xl & int(0x00000000FFFFFFFF)));
565         int xhi = xl >> 32; // FRACTIONAL_PLACES
566         uint ylo = uint(yl & int(0x00000000FFFFFFFF));
567         int yhi = yl >> 32; // FRACTIONAL_PLACES
568 
569         uint lolo = xlo * ylo;
570         int lohi = int(xlo) * yhi;
571         int hilo = xhi * int(ylo);
572         int hihi = xhi * yhi;
573 
574         uint loResult = lolo >> 32; // FRACTIONAL_PLACES
575         int midResult1 = lohi;
576         int midResult2 = hilo;
577         int hiResult = hihi << 32; // FRACTIONAL_PLACES
578 
579         int sum = int(loResult) + midResult1 + midResult2 + hiResult;
580 
581         return sum;
582     }
583 
584     function floor(int x) internal pure returns (int64) {
585         return int64(x & 0xFFFFFFFF00000000);
586     }
587 
588     function round(int x) internal pure returns (int) {
589         int fractionalPart = x & 0x00000000FFFFFFFF;
590         int integralPart = floor(x);
591         if (fractionalPart < 0x80000000) return integralPart;
592         if (fractionalPart > 0x80000000) return integralPart + ONE;
593         if ((integralPart & ONE) == 0) return integralPart;
594         return integralPart + ONE;
595     }
596 
597     function sub(int64 x, int64 y)
598         internal
599         pure
600         returns (int64)
601     {
602         int64 xl = x;
603         int64 yl = y;
604         int64 diff = xl - yl;
605         if (((xl ^ yl) & (xl ^ diff) & MIN_VALUE) != 0) diff = xl < 0 ? MIN_VALUE : MAX_VALUE;
606         return diff;
607     }
608 
609     function add(int64 x, int64 y)
610         internal
611         pure
612         returns (int64)
613     {
614         int64 xl = x;
615         int64 yl = y;
616         int64 sum = xl + yl;
617         if ((~(xl ^ yl) & (xl ^ sum) & MIN_VALUE) != 0) sum = xl > 0 ? MAX_VALUE : MIN_VALUE;
618         return sum;
619     }
620 
621     function sign(int64 x) internal pure returns (int8) {
622         return x == int8(0) ? int8(0) : x > int8(0) ? int8(1) : int8(-1);
623     }
624 
625     function abs(int64 x) internal pure returns (int64) {
626         int64 mask = x >> 63;
627         return (x + mask) ^ mask;
628     }
629 }
630 
631 
632 // File contracts/V1/SinLut256.sol
633 
634 // License: UNLICENSED
635 /* Copyright (c) 2021 Kohi Art Community Inc. All rights reserved. */
636 
637 pragma solidity ^0.8.0;
638 
639 library SinLut256 {
640     /**
641      * @notice Lookup tables for computing the sine value for a given angle.
642      * @param i The clamped and rounded angle integral to index into the table.
643      * @return The sine value in fixed-point (Q31.32) space.
644      */
645     function sinlut(int256 i) external pure returns (int64) {
646         if (i <= 127) {
647             if (i <= 63) {
648                 if (i <= 31) {
649                     if (i <= 15) {
650                         if (i <= 7) {
651                             if (i <= 3) {
652                                 if (i <= 1) {
653                                     if (i == 0) {
654                                         return 0;
655                                     } else {
656                                         return 26456769;
657                                     }
658                                 } else {
659                                     if (i == 2) {
660                                         return 52912534;
661                                     } else {
662                                         return 79366292;
663                                     }
664                                 }
665                             } else {
666                                 if (i <= 5) {
667                                     if (i == 4) {
668                                         return 105817038;
669                                     } else {
670                                         return 132263769;
671                                     }
672                                 } else {
673                                     if (i == 6) {
674                                         return 158705481;
675                                     } else {
676                                         return 185141171;
677                                     }
678                                 }
679                             }
680                         } else {
681                             if (i <= 11) {
682                                 if (i <= 9) {
683                                     if (i == 8) {
684                                         return 211569835;
685                                     } else {
686                                         return 237990472;
687                                     }
688                                 } else {
689                                     if (i == 10) {
690                                         return 264402078;
691                                     } else {
692                                         return 290803651;
693                                     }
694                                 }
695                             } else {
696                                 if (i <= 13) {
697                                     if (i == 12) {
698                                         return 317194190;
699                                     } else {
700                                         return 343572692;
701                                     }
702                                 } else {
703                                     if (i == 14) {
704                                         return 369938158;
705                                     } else {
706                                         return 396289586;
707                                     }
708                                 }
709                             }
710                         }
711                     } else {
712                         if (i <= 23) {
713                             if (i <= 19) {
714                                 if (i <= 17) {
715                                     if (i == 16) {
716                                         return 422625977;
717                                     } else {
718                                         return 448946331;
719                                     }
720                                 } else {
721                                     if (i == 18) {
722                                         return 475249649;
723                                     } else {
724                                         return 501534935;
725                                     }
726                                 }
727                             } else {
728                                 if (i <= 21) {
729                                     if (i == 20) {
730                                         return 527801189;
731                                     } else {
732                                         return 554047416;
733                                     }
734                                 } else {
735                                     if (i == 22) {
736                                         return 580272619;
737                                     } else {
738                                         return 606475804;
739                                     }
740                                 }
741                             }
742                         } else {
743                             if (i <= 27) {
744                                 if (i <= 25) {
745                                     if (i == 24) {
746                                         return 632655975;
747                                     } else {
748                                         return 658812141;
749                                     }
750                                 } else {
751                                     if (i == 26) {
752                                         return 684943307;
753                                     } else {
754                                         return 711048483;
755                                     }
756                                 }
757                             } else {
758                                 if (i <= 29) {
759                                     if (i == 28) {
760                                         return 737126679;
761                                     } else {
762                                         return 763176903;
763                                     }
764                                 } else {
765                                     if (i == 30) {
766                                         return 789198169;
767                                     } else {
768                                         return 815189489;
769                                     }
770                                 }
771                             }
772                         }
773                     }
774                 } else {
775                     if (i <= 47) {
776                         if (i <= 39) {
777                             if (i <= 35) {
778                                 if (i <= 33) {
779                                     if (i == 32) {
780                                         return 841149875;
781                                     } else {
782                                         return 867078344;
783                                     }
784                                 } else {
785                                     if (i == 34) {
786                                         return 892973912;
787                                     } else {
788                                         return 918835595;
789                                     }
790                                 }
791                             } else {
792                                 if (i <= 37) {
793                                     if (i == 36) {
794                                         return 944662413;
795                                     } else {
796                                         return 970453386;
797                                     }
798                                 } else {
799                                     if (i == 38) {
800                                         return 996207534;
801                                     } else {
802                                         return 1021923881;
803                                     }
804                                 }
805                             }
806                         } else {
807                             if (i <= 43) {
808                                 if (i <= 41) {
809                                     if (i == 40) {
810                                         return 1047601450;
811                                     } else {
812                                         return 1073239268;
813                                     }
814                                 } else {
815                                     if (i == 42) {
816                                         return 1098836362;
817                                     } else {
818                                         return 1124391760;
819                                     }
820                                 }
821                             } else {
822                                 if (i <= 45) {
823                                     if (i == 44) {
824                                         return 1149904493;
825                                     } else {
826                                         return 1175373592;
827                                     }
828                                 } else {
829                                     if (i == 46) {
830                                         return 1200798091;
831                                     } else {
832                                         return 1226177026;
833                                     }
834                                 }
835                             }
836                         }
837                     } else {
838                         if (i <= 55) {
839                             if (i <= 51) {
840                                 if (i <= 49) {
841                                     if (i == 48) {
842                                         return 1251509433;
843                                     } else {
844                                         return 1276794351;
845                                     }
846                                 } else {
847                                     if (i == 50) {
848                                         return 1302030821;
849                                     } else {
850                                         return 1327217884;
851                                     }
852                                 }
853                             } else {
854                                 if (i <= 53) {
855                                     if (i == 52) {
856                                         return 1352354586;
857                                     } else {
858                                         return 1377439973;
859                                     }
860                                 } else {
861                                     if (i == 54) {
862                                         return 1402473092;
863                                     } else {
864                                         return 1427452994;
865                                     }
866                                 }
867                             }
868                         } else {
869                             if (i <= 59) {
870                                 if (i <= 57) {
871                                     if (i == 56) {
872                                         return 1452378731;
873                                     } else {
874                                         return 1477249357;
875                                     }
876                                 } else {
877                                     if (i == 58) {
878                                         return 1502063928;
879                                     } else {
880                                         return 1526821503;
881                                     }
882                                 }
883                             } else {
884                                 if (i <= 61) {
885                                     if (i == 60) {
886                                         return 1551521142;
887                                     } else {
888                                         return 1576161908;
889                                     }
890                                 } else {
891                                     if (i == 62) {
892                                         return 1600742866;
893                                     } else {
894                                         return 1625263084;
895                                     }
896                                 }
897                             }
898                         }
899                     }
900                 }
901             } else {
902                 if (i <= 95) {
903                     if (i <= 79) {
904                         if (i <= 71) {
905                             if (i <= 67) {
906                                 if (i <= 65) {
907                                     if (i == 64) {
908                                         return 1649721630;
909                                     } else {
910                                         return 1674117578;
911                                     }
912                                 } else {
913                                     if (i == 66) {
914                                         return 1698450000;
915                                     } else {
916                                         return 1722717974;
917                                     }
918                                 }
919                             } else {
920                                 if (i <= 69) {
921                                     if (i == 68) {
922                                         return 1746920580;
923                                     } else {
924                                         return 1771056897;
925                                     }
926                                 } else {
927                                     if (i == 70) {
928                                         return 1795126012;
929                                     } else {
930                                         return 1819127010;
931                                     }
932                                 }
933                             }
934                         } else {
935                             if (i <= 75) {
936                                 if (i <= 73) {
937                                     if (i == 72) {
938                                         return 1843058980;
939                                     } else {
940                                         return 1866921015;
941                                     }
942                                 } else {
943                                     if (i == 74) {
944                                         return 1890712210;
945                                     } else {
946                                         return 1914431660;
947                                     }
948                                 }
949                             } else {
950                                 if (i <= 77) {
951                                     if (i == 76) {
952                                         return 1938078467;
953                                     } else {
954                                         return 1961651733;
955                                     }
956                                 } else {
957                                     if (i == 78) {
958                                         return 1985150563;
959                                     } else {
960                                         return 2008574067;
961                                     }
962                                 }
963                             }
964                         }
965                     } else {
966                         if (i <= 87) {
967                             if (i <= 83) {
968                                 if (i <= 81) {
969                                     if (i == 80) {
970                                         return 2031921354;
971                                     } else {
972                                         return 2055191540;
973                                     }
974                                 } else {
975                                     if (i == 82) {
976                                         return 2078383740;
977                                     } else {
978                                         return 2101497076;
979                                     }
980                                 }
981                             } else {
982                                 if (i <= 85) {
983                                     if (i == 84) {
984                                         return 2124530670;
985                                     } else {
986                                         return 2147483647;
987                                     }
988                                 } else {
989                                     if (i == 86) {
990                                         return 2170355138;
991                                     } else {
992                                         return 2193144275;
993                                     }
994                                 }
995                             }
996                         } else {
997                             if (i <= 91) {
998                                 if (i <= 89) {
999                                     if (i == 88) {
1000                                         return 2215850191;
1001                                     } else {
1002                                         return 2238472027;
1003                                     }
1004                                 } else {
1005                                     if (i == 90) {
1006                                         return 2261008923;
1007                                     } else {
1008                                         return 2283460024;
1009                                     }
1010                                 }
1011                             } else {
1012                                 if (i <= 93) {
1013                                     if (i == 92) {
1014                                         return 2305824479;
1015                                     } else {
1016                                         return 2328101438;
1017                                     }
1018                                 } else {
1019                                     if (i == 94) {
1020                                         return 2350290057;
1021                                     } else {
1022                                         return 2372389494;
1023                                     }
1024                                 }
1025                             }
1026                         }
1027                     }
1028                 } else {
1029                     if (i <= 111) {
1030                         if (i <= 103) {
1031                             if (i <= 99) {
1032                                 if (i <= 97) {
1033                                     if (i == 96) {
1034                                         return 2394398909;
1035                                     } else {
1036                                         return 2416317469;
1037                                     }
1038                                 } else {
1039                                     if (i == 98) {
1040                                         return 2438144340;
1041                                     } else {
1042                                         return 2459878695;
1043                                     }
1044                                 }
1045                             } else {
1046                                 if (i <= 101) {
1047                                     if (i == 100) {
1048                                         return 2481519710;
1049                                     } else {
1050                                         return 2503066562;
1051                                     }
1052                                 } else {
1053                                     if (i == 102) {
1054                                         return 2524518435;
1055                                     } else {
1056                                         return 2545874514;
1057                                     }
1058                                 }
1059                             }
1060                         } else {
1061                             if (i <= 107) {
1062                                 if (i <= 105) {
1063                                     if (i == 104) {
1064                                         return 2567133990;
1065                                     } else {
1066                                         return 2588296054;
1067                                     }
1068                                 } else {
1069                                     if (i == 106) {
1070                                         return 2609359905;
1071                                     } else {
1072                                         return 2630324743;
1073                                     }
1074                                 }
1075                             } else {
1076                                 if (i <= 109) {
1077                                     if (i == 108) {
1078                                         return 2651189772;
1079                                     } else {
1080                                         return 2671954202;
1081                                     }
1082                                 } else {
1083                                     if (i == 110) {
1084                                         return 2692617243;
1085                                     } else {
1086                                         return 2713178112;
1087                                     }
1088                                 }
1089                             }
1090                         }
1091                     } else {
1092                         if (i <= 119) {
1093                             if (i <= 115) {
1094                                 if (i <= 113) {
1095                                     if (i == 112) {
1096                                         return 2733636028;
1097                                     } else {
1098                                         return 2753990216;
1099                                     }
1100                                 } else {
1101                                     if (i == 114) {
1102                                         return 2774239903;
1103                                     } else {
1104                                         return 2794384321;
1105                                     }
1106                                 }
1107                             } else {
1108                                 if (i <= 117) {
1109                                     if (i == 116) {
1110                                         return 2814422705;
1111                                     } else {
1112                                         return 2834354295;
1113                                     }
1114                                 } else {
1115                                     if (i == 118) {
1116                                         return 2854178334;
1117                                     } else {
1118                                         return 2873894071;
1119                                     }
1120                                 }
1121                             }
1122                         } else {
1123                             if (i <= 123) {
1124                                 if (i <= 121) {
1125                                     if (i == 120) {
1126                                         return 2893500756;
1127                                     } else {
1128                                         return 2912997648;
1129                                     }
1130                                 } else {
1131                                     if (i == 122) {
1132                                         return 2932384004;
1133                                     } else {
1134                                         return 2951659090;
1135                                     }
1136                                 }
1137                             } else {
1138                                 if (i <= 125) {
1139                                     if (i == 124) {
1140                                         return 2970822175;
1141                                     } else {
1142                                         return 2989872531;
1143                                     }
1144                                 } else {
1145                                     if (i == 126) {
1146                                         return 3008809435;
1147                                     } else {
1148                                         return 3027632170;
1149                                     }
1150                                 }
1151                             }
1152                         }
1153                     }
1154                 }
1155             }
1156         } else {
1157             if (i <= 191) {
1158                 if (i <= 159) {
1159                     if (i <= 143) {
1160                         if (i <= 135) {
1161                             if (i <= 131) {
1162                                 if (i <= 129) {
1163                                     if (i == 128) {
1164                                         return 3046340019;
1165                                     } else {
1166                                         return 3064932275;
1167                                     }
1168                                 } else {
1169                                     if (i == 130) {
1170                                         return 3083408230;
1171                                     } else {
1172                                         return 3101767185;
1173                                     }
1174                                 }
1175                             } else {
1176                                 if (i <= 133) {
1177                                     if (i == 132) {
1178                                         return 3120008443;
1179                                     } else {
1180                                         return 3138131310;
1181                                     }
1182                                 } else {
1183                                     if (i == 134) {
1184                                         return 3156135101;
1185                                     } else {
1186                                         return 3174019130;
1187                                     }
1188                                 }
1189                             }
1190                         } else {
1191                             if (i <= 139) {
1192                                 if (i <= 137) {
1193                                     if (i == 136) {
1194                                         return 3191782721;
1195                                     } else {
1196                                         return 3209425199;
1197                                     }
1198                                 } else {
1199                                     if (i == 138) {
1200                                         return 3226945894;
1201                                     } else {
1202                                         return 3244344141;
1203                                     }
1204                                 }
1205                             } else {
1206                                 if (i <= 141) {
1207                                     if (i == 140) {
1208                                         return 3261619281;
1209                                     } else {
1210                                         return 3278770658;
1211                                     }
1212                                 } else {
1213                                     if (i == 142) {
1214                                         return 3295797620;
1215                                     } else {
1216                                         return 3312699523;
1217                                     }
1218                                 }
1219                             }
1220                         }
1221                     } else {
1222                         if (i <= 151) {
1223                             if (i <= 147) {
1224                                 if (i <= 145) {
1225                                     if (i == 144) {
1226                                         return 3329475725;
1227                                     } else {
1228                                         return 3346125588;
1229                                     }
1230                                 } else {
1231                                     if (i == 146) {
1232                                         return 3362648482;
1233                                     } else {
1234                                         return 3379043779;
1235                                     }
1236                                 }
1237                             } else {
1238                                 if (i <= 149) {
1239                                     if (i == 148) {
1240                                         return 3395310857;
1241                                     } else {
1242                                         return 3411449099;
1243                                     }
1244                                 } else {
1245                                     if (i == 150) {
1246                                         return 3427457892;
1247                                     } else {
1248                                         return 3443336630;
1249                                     }
1250                                 }
1251                             }
1252                         } else {
1253                             if (i <= 155) {
1254                                 if (i <= 153) {
1255                                     if (i == 152) {
1256                                         return 3459084709;
1257                                     } else {
1258                                         return 3474701532;
1259                                     }
1260                                 } else {
1261                                     if (i == 154) {
1262                                         return 3490186507;
1263                                     } else {
1264                                         return 3505539045;
1265                                     }
1266                                 }
1267                             } else {
1268                                 if (i <= 157) {
1269                                     if (i == 156) {
1270                                         return 3520758565;
1271                                     } else {
1272                                         return 3535844488;
1273                                     }
1274                                 } else {
1275                                     if (i == 158) {
1276                                         return 3550796243;
1277                                     } else {
1278                                         return 3565613262;
1279                                     }
1280                                 }
1281                             }
1282                         }
1283                     }
1284                 } else {
1285                     if (i <= 175) {
1286                         if (i <= 167) {
1287                             if (i <= 163) {
1288                                 if (i <= 161) {
1289                                     if (i == 160) {
1290                                         return 3580294982;
1291                                     } else {
1292                                         return 3594840847;
1293                                     }
1294                                 } else {
1295                                     if (i == 162) {
1296                                         return 3609250305;
1297                                     } else {
1298                                         return 3623522808;
1299                                     }
1300                                 }
1301                             } else {
1302                                 if (i <= 165) {
1303                                     if (i == 164) {
1304                                         return 3637657816;
1305                                     } else {
1306                                         return 3651654792;
1307                                     }
1308                                 } else {
1309                                     if (i == 166) {
1310                                         return 3665513205;
1311                                     } else {
1312                                         return 3679232528;
1313                                     }
1314                                 }
1315                             }
1316                         } else {
1317                             if (i <= 171) {
1318                                 if (i <= 169) {
1319                                     if (i == 168) {
1320                                         return 3692812243;
1321                                     } else {
1322                                         return 3706251832;
1323                                     }
1324                                 } else {
1325                                     if (i == 170) {
1326                                         return 3719550786;
1327                                     } else {
1328                                         return 3732708601;
1329                                     }
1330                                 }
1331                             } else {
1332                                 if (i <= 173) {
1333                                     if (i == 172) {
1334                                         return 3745724777;
1335                                     } else {
1336                                         return 3758598821;
1337                                     }
1338                                 } else {
1339                                     if (i == 174) {
1340                                         return 3771330243;
1341                                     } else {
1342                                         return 3783918561;
1343                                     }
1344                                 }
1345                             }
1346                         }
1347                     } else {
1348                         if (i <= 183) {
1349                             if (i <= 179) {
1350                                 if (i <= 177) {
1351                                     if (i == 176) {
1352                                         return 3796363297;
1353                                     } else {
1354                                         return 3808663979;
1355                                     }
1356                                 } else {
1357                                     if (i == 178) {
1358                                         return 3820820141;
1359                                     } else {
1360                                         return 3832831319;
1361                                     }
1362                                 }
1363                             } else {
1364                                 if (i <= 181) {
1365                                     if (i == 180) {
1366                                         return 3844697060;
1367                                     } else {
1368                                         return 3856416913;
1369                                     }
1370                                 } else {
1371                                     if (i == 182) {
1372                                         return 3867990433;
1373                                     } else {
1374                                         return 3879417181;
1375                                     }
1376                                 }
1377                             }
1378                         } else {
1379                             if (i <= 187) {
1380                                 if (i <= 185) {
1381                                     if (i == 184) {
1382                                         return 3890696723;
1383                                     } else {
1384                                         return 3901828632;
1385                                     }
1386                                 } else {
1387                                     if (i == 186) {
1388                                         return 3912812484;
1389                                     } else {
1390                                         return 3923647863;
1391                                     }
1392                                 }
1393                             } else {
1394                                 if (i <= 189) {
1395                                     if (i == 188) {
1396                                         return 3934334359;
1397                                     } else {
1398                                         return 3944871565;
1399                                     }
1400                                 } else {
1401                                     if (i == 190) {
1402                                         return 3955259082;
1403                                     } else {
1404                                         return 3965496515;
1405                                     }
1406                                 }
1407                             }
1408                         }
1409                     }
1410                 }
1411             } else {
1412                 if (i <= 223) {
1413                     if (i <= 207) {
1414                         if (i <= 199) {
1415                             if (i <= 195) {
1416                                 if (i <= 193) {
1417                                     if (i == 192) {
1418                                         return 3975583476;
1419                                     } else {
1420                                         return 3985519583;
1421                                     }
1422                                 } else {
1423                                     if (i == 194) {
1424                                         return 3995304457;
1425                                     } else {
1426                                         return 4004937729;
1427                                     }
1428                                 }
1429                             } else {
1430                                 if (i <= 197) {
1431                                     if (i == 196) {
1432                                         return 4014419032;
1433                                     } else {
1434                                         return 4023748007;
1435                                     }
1436                                 } else {
1437                                     if (i == 198) {
1438                                         return 4032924300;
1439                                     } else {
1440                                         return 4041947562;
1441                                     }
1442                                 }
1443                             }
1444                         } else {
1445                             if (i <= 203) {
1446                                 if (i <= 201) {
1447                                     if (i == 200) {
1448                                         return 4050817451;
1449                                     } else {
1450                                         return 4059533630;
1451                                     }
1452                                 } else {
1453                                     if (i == 202) {
1454                                         return 4068095769;
1455                                     } else {
1456                                         return 4076503544;
1457                                     }
1458                                 }
1459                             } else {
1460                                 if (i <= 205) {
1461                                     if (i == 204) {
1462                                         return 4084756634;
1463                                     } else {
1464                                         return 4092854726;
1465                                     }
1466                                 } else {
1467                                     if (i == 206) {
1468                                         return 4100797514;
1469                                     } else {
1470                                         return 4108584696;
1471                                     }
1472                                 }
1473                             }
1474                         }
1475                     } else {
1476                         if (i <= 215) {
1477                             if (i <= 211) {
1478                                 if (i <= 209) {
1479                                     if (i == 208) {
1480                                         return 4116215977;
1481                                     } else {
1482                                         return 4123691067;
1483                                     }
1484                                 } else {
1485                                     if (i == 210) {
1486                                         return 4131009681;
1487                                     } else {
1488                                         return 4138171544;
1489                                     }
1490                                 }
1491                             } else {
1492                                 if (i <= 213) {
1493                                     if (i == 212) {
1494                                         return 4145176382;
1495                                     } else {
1496                                         return 4152023930;
1497                                     }
1498                                 } else {
1499                                     if (i == 214) {
1500                                         return 4158713929;
1501                                     } else {
1502                                         return 4165246124;
1503                                     }
1504                                 }
1505                             }
1506                         } else {
1507                             if (i <= 219) {
1508                                 if (i <= 217) {
1509                                     if (i == 216) {
1510                                         return 4171620267;
1511                                     } else {
1512                                         return 4177836117;
1513                                     }
1514                                 } else {
1515                                     if (i == 218) {
1516                                         return 4183893437;
1517                                     } else {
1518                                         return 4189791999;
1519                                     }
1520                                 }
1521                             } else {
1522                                 if (i <= 221) {
1523                                     if (i == 220) {
1524                                         return 4195531577;
1525                                     } else {
1526                                         return 4201111955;
1527                                     }
1528                                 } else {
1529                                     if (i == 222) {
1530                                         return 4206532921;
1531                                     } else {
1532                                         return 4211794268;
1533                                     }
1534                                 }
1535                             }
1536                         }
1537                     }
1538                 } else {
1539                     if (i <= 239) {
1540                         if (i <= 231) {
1541                             if (i <= 227) {
1542                                 if (i <= 225) {
1543                                     if (i == 224) {
1544                                         return 4216895797;
1545                                     } else {
1546                                         return 4221837315;
1547                                     }
1548                                 } else {
1549                                     if (i == 226) {
1550                                         return 4226618635;
1551                                     } else {
1552                                         return 4231239573;
1553                                     }
1554                                 }
1555                             } else {
1556                                 if (i <= 229) {
1557                                     if (i == 228) {
1558                                         return 4235699957;
1559                                     } else {
1560                                         return 4239999615;
1561                                     }
1562                                 } else {
1563                                     if (i == 230) {
1564                                         return 4244138385;
1565                                     } else {
1566                                         return 4248116110;
1567                                     }
1568                                 }
1569                             }
1570                         } else {
1571                             if (i <= 235) {
1572                                 if (i <= 233) {
1573                                     if (i == 232) {
1574                                         return 4251932639;
1575                                     } else {
1576                                         return 4255587827;
1577                                     }
1578                                 } else {
1579                                     if (i == 234) {
1580                                         return 4259081536;
1581                                     } else {
1582                                         return 4262413632;
1583                                     }
1584                                 }
1585                             } else {
1586                                 if (i <= 237) {
1587                                     if (i == 236) {
1588                                         return 4265583990;
1589                                     } else {
1590                                         return 4268592489;
1591                                     }
1592                                 } else {
1593                                     if (i == 238) {
1594                                         return 4271439015;
1595                                     } else {
1596                                         return 4274123460;
1597                                     }
1598                                 }
1599                             }
1600                         }
1601                     } else {
1602                         if (i <= 247) {
1603                             if (i <= 243) {
1604                                 if (i <= 241) {
1605                                     if (i == 240) {
1606                                         return 4276645722;
1607                                     } else {
1608                                         return 4279005706;
1609                                     }
1610                                 } else {
1611                                     if (i == 242) {
1612                                         return 4281203321;
1613                                     } else {
1614                                         return 4283238485;
1615                                     }
1616                                 }
1617                             } else {
1618                                 if (i <= 245) {
1619                                     if (i == 244) {
1620                                         return 4285111119;
1621                                     } else {
1622                                         return 4286821154;
1623                                     }
1624                                 } else {
1625                                     if (i == 246) {
1626                                         return 4288368525;
1627                                     } else {
1628                                         return 4289753172;
1629                                     }
1630                                 }
1631                             }
1632                         } else {
1633                             if (i <= 251) {
1634                                 if (i <= 249) {
1635                                     if (i == 248) {
1636                                         return 4290975043;
1637                                     } else {
1638                                         return 4292034091;
1639                                     }
1640                                 } else {
1641                                     if (i == 250) {
1642                                         return 4292930277;
1643                                     } else {
1644                                         return 4293663567;
1645                                     }
1646                                 }
1647                             } else {
1648                                 if (i <= 253) {
1649                                     if (i == 252) {
1650                                         return 4294233932;
1651                                     } else {
1652                                         return 4294641351;
1653                                     }
1654                                 } else {
1655                                     if (i == 254) {
1656                                         return 4294885809;
1657                                     } else {
1658                                         return 4294967296;
1659                                     }
1660                                 }
1661                             }
1662                         }
1663                     }
1664                 }
1665             }
1666         }
1667     }
1668 }
1669 
1670 
1671 // File contracts/V1/Trig256.sol
1672 
1673 // License: UNLICENSED
1674 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
1675 
1676 pragma solidity ^0.8.0;
1677 /*
1678     Provides trigonometric functions in Q31.Q32 format.
1679 
1680     exp: Adapted from Petteri Aimonen's libfixmath
1681 
1682     See: https://github.com/PetteriAimonen/libfixmath
1683          https://github.com/PetteriAimonen/libfixmath/blob/master/LICENSE
1684 
1685     other functions: Adapted from Andr├⌐ Slupik's FixedMath.NET
1686                      https://github.com/asik/FixedMath.Net/blob/master/LICENSE.txt
1687          
1688     THIRD PARTY NOTICES:
1689     ====================
1690 
1691     libfixmath is Copyright (c) 2011-2021 Flatmush <Flatmush@gmail.com>,
1692     Petteri Aimonen <Petteri.Aimonen@gmail.com>, & libfixmath AUTHORS
1693 
1694     Permission is hereby granted, free of charge, to any person obtaining a copy
1695     of this software and associated documentation files (the "Software"), to deal
1696     in the Software without restriction, including without limitation the rights
1697     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1698     copies of the Software, and to permit persons to whom the Software is
1699     furnished to do so, subject to the following conditions:
1700 
1701     The above copyright notice and this permission notice shall be included in all
1702     copies or substantial portions of the Software.
1703 
1704     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1705     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1706     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1707     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1708     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1709     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1710     SOFTWARE.
1711 
1712     Copyright 2012 Andr├⌐ Slupik
1713 
1714     Licensed under the Apache License, Version 2.0 (the "License");
1715     you may not use this file except in compliance with the License.
1716     You may obtain a copy of the License at
1717 
1718         http://www.apache.org/licenses/LICENSE-2.0
1719 
1720     Unless required by applicable law or agreed to in writing, software
1721     distributed under the License is distributed on an "AS IS" BASIS,
1722     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1723     See the License for the specific language governing permissions and
1724     limitations under the License.
1725 
1726     This project uses code from the log2fix library, which is under the following license:           
1727     The MIT License (MIT)
1728 
1729     Copyright (c) 2015 Dan Moulding
1730     
1731     Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
1732     to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
1733     and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
1734     
1735     The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
1736     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
1737     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1738     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
1739     IN THE SOFTWARE.
1740 */
1741 
1742 library Trig256 {
1743     int64 private constant LARGE_PI = 7244019458077122842;
1744     int64 private constant LN2 = 0xB17217F7;
1745     int64 private constant LN_MAX = 0x157CD0E702;
1746     int64 private constant LN_MIN = -0x162E42FEFA;
1747     int64 private constant E = -0x2B7E15162;
1748 
1749     function sin(int64 x)
1750         internal
1751         pure
1752         returns (int64)
1753     {       
1754         (
1755             int64 clamped,
1756             bool flipHorizontal,
1757             bool flipVertical
1758         ) = clamp(x);
1759 
1760         int64 lutInterval = Fix64V1.div(((256 - 1) * Fix64V1.ONE), Fix64V1.PI_OVER_2);
1761         int rawIndex = Fix64V1.mul_256(clamped, lutInterval);
1762         int64 roundedIndex = int64(Fix64V1.round(rawIndex));
1763         int64 indexError = Fix64V1.sub(int64(rawIndex), roundedIndex);     
1764 
1765         roundedIndex = roundedIndex >> 32; /* FRACTIONAL_PLACES */
1766 
1767         int64 nearestValueIndex = flipHorizontal
1768             ? (256 - 1) - roundedIndex
1769             : roundedIndex;
1770 
1771         int64 nearestValue = SinLut256.sinlut(nearestValueIndex);
1772 
1773         int64 secondNearestValue = SinLut256.sinlut(
1774             flipHorizontal
1775                 ? (256 - 1) -
1776                     roundedIndex -
1777                     Fix64V1.sign(indexError)
1778                 : roundedIndex + Fix64V1.sign(indexError)
1779         );
1780 
1781         int64 delta = Fix64V1.mul(indexError, Fix64V1.abs(Fix64V1.sub(nearestValue, secondNearestValue)));
1782         int64 interpolatedValue = nearestValue + (flipHorizontal ? -delta : delta);
1783         int64 finalValue = flipVertical ? -interpolatedValue: interpolatedValue;
1784     
1785         return finalValue;
1786     }
1787 
1788     function cos(int64 x)
1789         internal
1790         pure
1791         returns (int64)
1792     {
1793         int64 xl = x;
1794         int64 angle;
1795         if(xl > 0) {            
1796             angle = Fix64V1.add(xl, Fix64V1.sub(0 - Fix64V1.PI, Fix64V1.PI_OVER_2));            
1797         } else {            
1798             angle = Fix64V1.add(xl, Fix64V1.PI_OVER_2);
1799         }        
1800         return sin(angle);
1801     }
1802 
1803     function sqrt(int64 x)
1804         internal
1805         pure        
1806         returns (int64)
1807     {
1808         int64 xl = x;
1809         if (xl < 0)
1810             revert("negative value passed to sqrt");
1811 
1812         uint64 num = uint64(xl);
1813         uint64 result = uint64(0);
1814         uint64 bit = uint64(1) << (64 - 2);
1815 
1816         while (bit > num) bit >>= 2;
1817         for (uint8 i = 0; i < 2; ++i)
1818         {
1819             while (bit != 0)
1820             {
1821                 if (num >= result + bit)
1822                 {
1823                     num -= result + bit;
1824                     result = (result >> 1) + bit;
1825                 }
1826                 else
1827                 {
1828                     result = result >> 1;
1829                 }
1830 
1831                 bit >>= 2;
1832             }
1833 
1834             if (i == 0)
1835             {
1836                 if (num > (uint64(1) << (64 / 2)) - 1)
1837                 {
1838                     num -= result;
1839                     num = (num << (64 / 2)) - uint64(0x80000000);
1840                     result = (result << (64 / 2)) + uint64(0x80000000);
1841                 }
1842                 else
1843                 {
1844                     num <<= 64 / 2;
1845                     result <<= 64 / 2;
1846                 }
1847 
1848                 bit = uint64(1) << (64 / 2 - 2);
1849             }
1850         }
1851 
1852         if (num > result) ++result;
1853         return int64(result);
1854     }
1855 
1856      function log2_256(int x)
1857         internal
1858         pure        
1859         returns (int)
1860     {
1861         if (x <= 0) {
1862             revert("negative value passed to log2_256");
1863         }
1864 
1865         // This implementation is based on Clay. S. Turner's fast binary logarithm
1866         // algorithm (C. S. Turner,  "A Fast Binary Logarithm Algorithm", IEEE Signal
1867         //     Processing Mag., pp. 124,140, Sep. 2010.)
1868 
1869         int b = 1 << 31; // FRACTIONAL_PLACES - 1
1870         int y = 0;
1871 
1872         int rawX = x;
1873         while (rawX < Fix64V1.ONE) {
1874             rawX <<= 1;
1875             y -= Fix64V1.ONE;
1876         }
1877 
1878         while (rawX >= Fix64V1.ONE << 1) {
1879             rawX >>= 1;
1880             y += Fix64V1.ONE;
1881         }
1882 
1883         int z = rawX;
1884 
1885         for (uint8 i = 0; i < 32 /* FRACTIONAL_PLACES */; i++) {
1886             z = Fix64V1.mul_256(z, z);
1887             if (z >= Fix64V1.ONE << 1) {
1888                 z = z >> 1;
1889                 y += b;
1890             }
1891             b >>= 1;
1892         }
1893 
1894         return y;
1895     }
1896 
1897     function log_256(int x)
1898         internal
1899         pure        
1900         returns (int)
1901     {
1902         return Fix64V1.mul_256(log2_256(x), LN2);
1903     }
1904 
1905     function log2(int64 x)
1906         internal
1907         pure        
1908         returns (int64)
1909     {
1910         if (x <= 0) revert("non-positive value passed to log2");
1911 
1912         // This implementation is based on Clay. S. Turner's fast binary logarithm
1913         // algorithm (C. S. Turner,  "A Fast Binary Logarithm Algorithm", IEEE Signal
1914         //     Processing Mag., pp. 124,140, Sep. 2010.)
1915 
1916         int64 b = 1 << 31; // FRACTIONAL_PLACES - 1
1917         int64 y = 0;
1918 
1919         int64 rawX = x;
1920         while (rawX < Fix64V1.ONE)
1921         {
1922             rawX <<= 1;
1923             y -= Fix64V1.ONE;
1924         }
1925 
1926         while (rawX >= Fix64V1.ONE << 1)
1927         {
1928             rawX >>= 1;
1929             y += Fix64V1.ONE;
1930         }
1931 
1932         int64 z = rawX;
1933 
1934         for (int32 i = 0; i < Fix64V1.FRACTIONAL_PLACES; i++)
1935         {
1936             z = Fix64V1.mul(z, z);
1937             if (z >= Fix64V1.ONE << 1)
1938             {
1939                 z = z >> 1;
1940                 y += b;
1941             }
1942 
1943             b >>= 1;
1944         }
1945 
1946         return y;
1947     }
1948 
1949     function log(int64 x)
1950         internal
1951         pure        
1952         returns (int64)
1953     {
1954         return Fix64V1.mul(log2(x), LN2);
1955     }
1956 
1957     function exp(int64 x)
1958         internal
1959         pure        
1960         returns (int64)
1961     {
1962         if (x == 0) return Fix64V1.ONE;
1963         if (x == Fix64V1.ONE) return E;
1964         if (x >= LN_MAX) return Fix64V1.MAX_VALUE;
1965         if (x <= LN_MIN) return 0;
1966 
1967         /* The algorithm is based on the power series for exp(x):
1968          * http://en.wikipedia.org/wiki/Exponential_function#Formal_definition
1969          *
1970          * From term n, we get term n+1 by multiplying with x/n.
1971          * When the sum term drops to zero, we can stop summing.
1972          */
1973 
1974         // The power-series converges much faster on positive values
1975         // and exp(-x) = 1/exp(x).
1976         
1977         bool neg = (x < 0);
1978         if (neg) x = -x;
1979 
1980         int64 result = Fix64V1.add(
1981             int64(x),
1982             Fix64V1.ONE
1983         );
1984         int64 term = x;
1985 
1986         for (uint32 i = 2; i < 40; i++) {
1987             term = Fix64V1.mul(
1988                 x,
1989                 Fix64V1.div(term, int32(i) * Fix64V1.ONE)
1990             );
1991             result = Fix64V1.add(result, int64(term));
1992             if (term == 0) break;
1993         }
1994 
1995         if (neg) {
1996             result = Fix64V1.div(Fix64V1.ONE, result);
1997         }
1998 
1999         return result;
2000     }
2001 
2002     function clamp(int64 x)
2003         internal
2004         pure
2005         returns (
2006             int64,
2007             bool,
2008             bool
2009         )
2010     {
2011         int64 clamped2Pi = x;
2012         for (uint8 i = 0; i < 29; ++i) {
2013             clamped2Pi %= LARGE_PI >> i;
2014         }
2015         if (x < 0) {
2016             clamped2Pi += Fix64V1.TWO_PI;
2017         }
2018 
2019         bool flipVertical = clamped2Pi >= Fix64V1.PI;
2020         int64 clampedPi = clamped2Pi;
2021         while (clampedPi >= Fix64V1.PI) {
2022             clampedPi -= Fix64V1.PI;
2023         }
2024 
2025         bool flipHorizontal = clampedPi >= Fix64V1.PI_OVER_2;
2026 
2027         int64 clampedPiOver2 = clampedPi;
2028         if (clampedPiOver2 >= Fix64V1.PI_OVER_2)
2029             clampedPiOver2 -= Fix64V1.PI_OVER_2;
2030 
2031         return (clampedPiOver2, flipHorizontal, flipVertical);
2032     }
2033 }
2034 
2035 
2036 // File contracts/V1/RandomV1.sol
2037 
2038 // License: UNLICENSED
2039 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
2040 
2041 pragma solidity ^0.8.0;
2042 /*
2043     A pseudo-random number generator, adapted from and matching the algorithm for .NET maximum compatibility Random implementation.
2044 
2045     See: https://github.com/dotnet/runtime/blob/f7633f498a8be34bee739b240a0aa9ae6a660cd9/src/libraries/System.Private.CoreLib/src/System/Random.Net5CompatImpl.cs#L192
2046          https://github.com/dotnet/runtime/blob/main/LICENSE.TXT
2047 
2048     THIRD PARTY NOTICES:
2049     ====================
2050 
2051     The MIT License (MIT)
2052 
2053     Copyright (c) .NET Foundation and Contributors
2054 
2055     All rights reserved.
2056 
2057     Permission is hereby granted, free of charge, to any person obtaining a copy
2058     of this software and associated documentation files (the "Software"), to deal
2059     in the Software without restriction, including without limitation the rights
2060     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2061     copies of the Software, and to permit persons to whom the Software is
2062     furnished to do so, subject to the following conditions:
2063 
2064     The above copyright notice and this permission notice shall be included in all
2065     copies or substantial portions of the Software.
2066 
2067     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2068     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2069     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2070     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2071     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2072     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2073     SOFTWARE.
2074 */
2075 
2076 library RandomV1 {
2077 
2078     int32 private constant MBIG = 0x7fffffff;
2079     int32 private constant MSEED = 161803398;
2080 
2081     struct PRNG {
2082         int32[56] _seedArray;
2083         int32 _inext;
2084         int32 _inextp;
2085     }
2086     
2087     function buildSeedTable(int32 seed) internal pure returns(PRNG memory prng) {
2088         uint8 ii = 0;
2089         int32 mj;
2090         int32 mk;
2091 
2092         int32 subtraction = (seed == type(int32).min) ? type(int32).max : int32(MathV1.abs(seed));
2093         mj = MSEED - subtraction;
2094         prng._seedArray[55] = mj;
2095         mk = 1;
2096         for (uint8 i = 1; i < 55; i++) {  
2097             if ((ii += 21) >= 55) {
2098                 ii -= 55;
2099             }
2100             prng._seedArray[uint64(ii)] = mk;
2101             mk = mj - mk;
2102             if (mk < 0) mk += MBIG;
2103             mj = prng._seedArray[uint8(ii)];
2104         }
2105 
2106         for (uint8 k = 1; k < 5; k++) {
2107 
2108             for (uint8 i = 1; i < 56; i++) {                
2109                 uint8 n = i + 30;           
2110                 if (n >= 55) {
2111                     n -= 55;                
2112                 }
2113 
2114                 int64 an = prng._seedArray[1 + n];                
2115                 int64 ai = prng._seedArray[i];
2116                 prng._seedArray[i] = int32(ai - an);
2117                 
2118                 if (prng._seedArray[i] < 0) {
2119                     int64 x = prng._seedArray[i];
2120                     x += MBIG;
2121                     prng._seedArray[i] = int32(x);
2122                 }               
2123             }
2124         }
2125 
2126         prng._inextp = 21;
2127     }   
2128 
2129     function next(PRNG memory prng, int32 maxValue) internal pure returns (int32) {
2130         require(maxValue >= 0, "maxValue < 0");
2131 
2132         int32 retval = next(prng);
2133 
2134         int64 fretval = retval * Fix64V1.ONE;
2135         int64 sample = Fix64V1.mul(fretval, Fix64V1.div(Fix64V1.ONE, MBIG * Fix64V1.ONE));
2136         int64 sr = Fix64V1.mul(sample, maxValue * Fix64V1.ONE);
2137         int32 r = int32(sr >> 32 /* FRACTIONAL_PLACES */);
2138 
2139         return r;
2140     }
2141 
2142     function next(PRNG memory prng, int32 minValue, int32 maxValue) internal pure returns(int32) {
2143         require(maxValue > minValue, "maxValue <= minValue");
2144         
2145         int64 range = maxValue - minValue;
2146         
2147         if (range <= type(int32).max) {
2148             int32 retval = next(prng);
2149 
2150             int64 fretval = retval * Fix64V1.ONE;
2151             int64 sample = Fix64V1.mul(fretval, Fix64V1.div(Fix64V1.ONE, MBIG * Fix64V1.ONE));
2152             int64 sr = Fix64V1.mul(sample, range * Fix64V1.ONE);
2153             int32 r = int32(sr >> 32  /* FRACTIONAL_PLACES */) + minValue;
2154             
2155             return r;
2156         }
2157         else {
2158             int64 fretval = nextForLargeRange(prng);
2159             int64 sr = Fix64V1.mul(fretval, range * Fix64V1.ONE);
2160             int32 r = int32(sr >> 32  /* FRACTIONAL_PLACES */) + minValue;
2161             return r;
2162         }
2163     }
2164 
2165     function next(PRNG memory prng) internal pure returns(int32) {
2166 
2167         int64 retVal;        
2168         int32 locINext = prng._inext;
2169         int32 locINextp = prng._inextp;
2170 
2171         if (++locINext >= 56) locINext = 1;
2172         if (++locINextp >= 56) locINextp = 1;
2173 
2174         int64 a = int64(prng._seedArray[uint32(locINext)]);
2175         int64 b = int64(prng._seedArray[uint32(locINextp)]);
2176         retVal = a - b;        
2177 
2178         if (retVal == MBIG) {
2179             retVal--;
2180         }
2181         if (retVal < 0) {
2182             retVal += MBIG;
2183         }
2184 
2185         prng._seedArray[uint32(locINext)] = int32(retVal);
2186         prng._inext = locINext;
2187         prng._inextp = locINextp;        
2188 
2189         int32 r = int32(retVal);
2190         return r;
2191     }
2192 
2193     function nextForLargeRange(PRNG memory prng) private pure returns(int64) {
2194 
2195         int sample1 = next(prng);
2196         int sample2 = next(prng);
2197 
2198         bool negative = sample2 % 2 == 0;
2199         if (negative) {
2200             sample1 = -sample1;
2201         }
2202 
2203         int64 d = int64(sample1) * Fix64V1.ONE;
2204         d = Fix64V1.add(int64(d), (type(int32).max - 1));
2205         d = Fix64V1.div(int64(d), int64(2) * (type(int32).max - 1));
2206 
2207         return d; 
2208     }
2209 
2210     function nextGaussian(PRNG memory prng) internal pure returns (int64 randNormal) {
2211         int64 u1 = Fix64V1.sub(Fix64V1.ONE, Fix64V1.mul(next(prng) * Fix64V1.ONE, Fix64V1.div(Fix64V1.ONE, Fix64V1.MAX_VALUE)));
2212         int64 u2 = Fix64V1.sub(Fix64V1.ONE, Fix64V1.mul(next(prng) * Fix64V1.ONE, Fix64V1.div(Fix64V1.ONE, Fix64V1.MAX_VALUE)));
2213         int64 sqrt = Trig256.sqrt(Fix64V1.mul(-2 * Fix64V1.ONE, Trig256.log(u1)));
2214         int64 randStdNormal = Fix64V1.mul(sqrt, Trig256.sin(Fix64V1.mul(Fix64V1.TWO, Fix64V1.mul(Fix64V1.PI, u2))));
2215         randNormal = Fix64V1.add(0, Fix64V1.mul(Fix64V1.ONE, randStdNormal));
2216         return randNormal;
2217     }
2218 }
2219 
2220 
2221 // File contracts/V1/IRenderer.sol
2222 
2223 // License: UNLICENSED
2224 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
2225 
2226 pragma solidity ^0.8.0;
2227 interface IRenderer {
2228 
2229     struct RenderArgs {
2230         int16 index;
2231         uint8 stage;
2232         int32 seed;        
2233         uint32[20480] buffer;
2234         RandomV1.PRNG prng;
2235     }
2236 
2237     /**
2238      * @notice Renders a chunk of the artwork, given an index.
2239      * @dev The output is an array of packed uint32s, in ARGB format.     
2240      */
2241     function render(RenderArgs memory args) external view returns (RenderArgs memory results);
2242 }
2243 
2244 
2245 // File contracts/Projects/CityLights/Errors.sol
2246 
2247 // License: UNLICENSED
2248 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
2249 
2250 pragma solidity ^0.8.0;
2251 
2252 error InvalidStage();
2253 error IndexOutOfRange();
2254 
2255 error AdminOnly();
2256 error NoOwnerAddress();
2257 error NoCreatorAddress();
2258 error AddressMustBeSet();
2259 
2260 error InvalidSeed();
2261 error InvalidRenderer();
2262 error InvalidOwnerRoyalty();
2263 
2264 error SeedNotSet();
2265 error SeedAlreadySet();
2266 
2267 error CannotPurchaseFromContract();
2268 error InsufficientFundsForPurchase();
2269 error InvalidFundsDistribution();
2270 
2271 error CollectionPaused();
2272 error CollectionLocked();
2273 error CollectionInactive();
2274 error CollectionSoldOut();
2275 
2276 error PresaleNotOpen();
2277 error PublicSaleNotOpen();
2278 error NotEligibleForPresale();
2279 error NoRemainingPresaleMints();
2280 error AccountExceedsMaxMints();
2281 
2282 error RenderDisallowed();
2283 
2284 
2285 // File contracts/Projects/CityLights/CityLightsProxy.sol
2286 
2287 // File contracts/V1/IAttributes.sol
2288 
2289 // License: UNLICENSED
2290 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
2291 
2292 pragma solidity ^0.8.0;
2293 
2294 interface IAttributes {
2295 
2296     function getAttributes(int32 seed) external view returns (string memory attributes);
2297 }
2298 
2299 
2300 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.3
2301 
2302 // License: MIT
2303 
2304 pragma solidity ^0.8.0;
2305 
2306 /**
2307  * @dev Interface of the ERC165 standard, as defined in the
2308  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2309  *
2310  * Implementers can declare support of contract interfaces, which can then be
2311  * queried by others ({ERC165Checker}).
2312  *
2313  * For an implementation, see {ERC165}.
2314  */
2315 interface IERC165 {
2316     /**
2317      * @dev Returns true if this contract implements the interface defined by
2318      * `interfaceId`. See the corresponding
2319      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2320      * to learn more about how these ids are created.
2321      *
2322      * This function call must use less than 30 000 gas.
2323      */
2324     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2325 }
2326 
2327 
2328 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.3
2329 
2330 // License: MIT
2331 
2332 pragma solidity ^0.8.0;
2333 
2334 /**
2335  * @dev Required interface of an ERC721 compliant contract.
2336  */
2337 interface IERC721 is IERC165 {
2338     /**
2339      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2340      */
2341     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2342 
2343     /**
2344      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2345      */
2346     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2347 
2348     /**
2349      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2350      */
2351     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2352 
2353     /**
2354      * @dev Returns the number of tokens in ``owner``'s account.
2355      */
2356     function balanceOf(address owner) external view returns (uint256 balance);
2357 
2358     /**
2359      * @dev Returns the owner of the `tokenId` token.
2360      *
2361      * Requirements:
2362      *
2363      * - `tokenId` must exist.
2364      */
2365     function ownerOf(uint256 tokenId) external view returns (address owner);
2366 
2367     /**
2368      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2369      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2370      *
2371      * Requirements:
2372      *
2373      * - `from` cannot be the zero address.
2374      * - `to` cannot be the zero address.
2375      * - `tokenId` token must exist and be owned by `from`.
2376      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
2377      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2378      *
2379      * Emits a {Transfer} event.
2380      */
2381     function safeTransferFrom(
2382         address from,
2383         address to,
2384         uint256 tokenId
2385     ) external;
2386 
2387     /**
2388      * @dev Transfers `tokenId` token from `from` to `to`.
2389      *
2390      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2391      *
2392      * Requirements:
2393      *
2394      * - `from` cannot be the zero address.
2395      * - `to` cannot be the zero address.
2396      * - `tokenId` token must be owned by `from`.
2397      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2398      *
2399      * Emits a {Transfer} event.
2400      */
2401     function transferFrom(
2402         address from,
2403         address to,
2404         uint256 tokenId
2405     ) external;
2406 
2407     /**
2408      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2409      * The approval is cleared when the token is transferred.
2410      *
2411      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2412      *
2413      * Requirements:
2414      *
2415      * - The caller must own the token or be an approved operator.
2416      * - `tokenId` must exist.
2417      *
2418      * Emits an {Approval} event.
2419      */
2420     function approve(address to, uint256 tokenId) external;
2421 
2422     /**
2423      * @dev Returns the account approved for `tokenId` token.
2424      *
2425      * Requirements:
2426      *
2427      * - `tokenId` must exist.
2428      */
2429     function getApproved(uint256 tokenId) external view returns (address operator);
2430 
2431     /**
2432      * @dev Approve or remove `operator` as an operator for the caller.
2433      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2434      *
2435      * Requirements:
2436      *
2437      * - The `operator` cannot be the caller.
2438      *
2439      * Emits an {ApprovalForAll} event.
2440      */
2441     function setApprovalForAll(address operator, bool _approved) external;
2442 
2443     /**
2444      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2445      *
2446      * See {setApprovalForAll}
2447      */
2448     function isApprovedForAll(address owner, address operator) external view returns (bool);
2449 
2450     /**
2451      * @dev Safely transfers `tokenId` token from `from` to `to`.
2452      *
2453      * Requirements:
2454      *
2455      * - `from` cannot be the zero address.
2456      * - `to` cannot be the zero address.
2457      * - `tokenId` token must exist and be owned by `from`.
2458      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2459      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2460      *
2461      * Emits a {Transfer} event.
2462      */
2463     function safeTransferFrom(
2464         address from,
2465         address to,
2466         uint256 tokenId,
2467         bytes calldata data
2468     ) external;
2469 }
2470 
2471 
2472 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.3
2473 
2474 // License: MIT
2475 
2476 pragma solidity ^0.8.0;
2477 
2478 /**
2479  * @title ERC721 token receiver interface
2480  * @dev Interface for any contract that wants to support safeTransfers
2481  * from ERC721 asset contracts.
2482  */
2483 interface IERC721Receiver {
2484     /**
2485      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2486      * by `operator` from `from`, this function is called.
2487      *
2488      * It must return its Solidity selector to confirm the token transfer.
2489      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2490      *
2491      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
2492      */
2493     function onERC721Received(
2494         address operator,
2495         address from,
2496         uint256 tokenId,
2497         bytes calldata data
2498     ) external returns (bytes4);
2499 }
2500 
2501 
2502 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.3
2503 
2504 // License: MIT
2505 
2506 pragma solidity ^0.8.0;
2507 
2508 /**
2509  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2510  * @dev See https://eips.ethereum.org/EIPS/eip-721
2511  */
2512 interface IERC721Metadata is IERC721 {
2513     /**
2514      * @dev Returns the token collection name.
2515      */
2516     function name() external view returns (string memory);
2517 
2518     /**
2519      * @dev Returns the token collection symbol.
2520      */
2521     function symbol() external view returns (string memory);
2522 
2523     /**
2524      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2525      */
2526     function tokenURI(uint256 tokenId) external view returns (string memory);
2527 }
2528 
2529 
2530 // File @openzeppelin/contracts/utils/Context.sol@v4.3.3
2531 
2532 // License: MIT
2533 
2534 pragma solidity ^0.8.0;
2535 
2536 /**
2537  * @dev Provides information about the current execution context, including the
2538  * sender of the transaction and its data. While these are generally available
2539  * via msg.sender and msg.data, they should not be accessed in such a direct
2540  * manner, since when dealing with meta-transactions the account sending and
2541  * paying for execution may not be the actual sender (as far as an application
2542  * is concerned).
2543  *
2544  * This contract is only required for intermediate, library-like contracts.
2545  */
2546 abstract contract Context {
2547     function _msgSender() internal view virtual returns (address) {
2548         return msg.sender;
2549     }
2550 
2551     function _msgData() internal view virtual returns (bytes calldata) {
2552         return msg.data;
2553     }
2554 }
2555 
2556 
2557 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.3
2558 
2559 // License: MIT
2560 
2561 pragma solidity ^0.8.0;
2562 
2563 /**
2564  * @dev Implementation of the {IERC165} interface.
2565  *
2566  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2567  * for the additional interface id that will be supported. For example:
2568  *
2569  * ```solidity
2570  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2571  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2572  * }
2573  * ```
2574  *
2575  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2576  */
2577 abstract contract ERC165 is IERC165 {
2578     /**
2579      * @dev See {IERC165-supportsInterface}.
2580      */
2581     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2582         return interfaceId == type(IERC165).interfaceId;
2583     }
2584 }
2585 
2586 
2587 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.3
2588 
2589 // License: MIT
2590 
2591 pragma solidity ^0.8.0;
2592 
2593 
2594 
2595 
2596 
2597 
2598 
2599 /**
2600  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2601  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2602  * {ERC721Enumerable}.
2603  */
2604 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2605     using Address for address;
2606     using Strings for uint256;
2607 
2608     // Token name
2609     string private _name;
2610 
2611     // Token symbol
2612     string private _symbol;
2613 
2614     // Mapping from token ID to owner address
2615     mapping(uint256 => address) private _owners;
2616 
2617     // Mapping owner address to token count
2618     mapping(address => uint256) private _balances;
2619 
2620     // Mapping from token ID to approved address
2621     mapping(uint256 => address) private _tokenApprovals;
2622 
2623     // Mapping from owner to operator approvals
2624     mapping(address => mapping(address => bool)) private _operatorApprovals;
2625 
2626     /**
2627      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2628      */
2629     constructor(string memory name_, string memory symbol_) {
2630         _name = name_;
2631         _symbol = symbol_;
2632     }
2633 
2634     /**
2635      * @dev See {IERC165-supportsInterface}.
2636      */
2637     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2638         return
2639             interfaceId == type(IERC721).interfaceId ||
2640             interfaceId == type(IERC721Metadata).interfaceId ||
2641             super.supportsInterface(interfaceId);
2642     }
2643 
2644     /**
2645      * @dev See {IERC721-balanceOf}.
2646      */
2647     function balanceOf(address owner) public view virtual override returns (uint256) {
2648         require(owner != address(0), "ERC721: balance query for the zero address");
2649         return _balances[owner];
2650     }
2651 
2652     /**
2653      * @dev See {IERC721-ownerOf}.
2654      */
2655     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2656         address owner = _owners[tokenId];
2657         require(owner != address(0), "ERC721: owner query for nonexistent token");
2658         return owner;
2659     }
2660 
2661     /**
2662      * @dev See {IERC721Metadata-name}.
2663      */
2664     function name() public view virtual override returns (string memory) {
2665         return _name;
2666     }
2667 
2668     /**
2669      * @dev See {IERC721Metadata-symbol}.
2670      */
2671     function symbol() public view virtual override returns (string memory) {
2672         return _symbol;
2673     }
2674 
2675     /**
2676      * @dev See {IERC721Metadata-tokenURI}.
2677      */
2678     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2679         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2680 
2681         string memory baseURI = _baseURI();
2682         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2683     }
2684 
2685     /**
2686      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2687      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2688      * by default, can be overriden in child contracts.
2689      */
2690     function _baseURI() internal view virtual returns (string memory) {
2691         return "";
2692     }
2693 
2694     /**
2695      * @dev See {IERC721-approve}.
2696      */
2697     function approve(address to, uint256 tokenId) public virtual override {
2698         address owner = ERC721.ownerOf(tokenId);
2699         require(to != owner, "ERC721: approval to current owner");
2700 
2701         require(
2702             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2703             "ERC721: approve caller is not owner nor approved for all"
2704         );
2705 
2706         _approve(to, tokenId);
2707     }
2708 
2709     /**
2710      * @dev See {IERC721-getApproved}.
2711      */
2712     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2713         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2714 
2715         return _tokenApprovals[tokenId];
2716     }
2717 
2718     /**
2719      * @dev See {IERC721-setApprovalForAll}.
2720      */
2721     function setApprovalForAll(address operator, bool approved) public virtual override {
2722         require(operator != _msgSender(), "ERC721: approve to caller");
2723 
2724         _operatorApprovals[_msgSender()][operator] = approved;
2725         emit ApprovalForAll(_msgSender(), operator, approved);
2726     }
2727 
2728     /**
2729      * @dev See {IERC721-isApprovedForAll}.
2730      */
2731     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2732         return _operatorApprovals[owner][operator];
2733     }
2734 
2735     /**
2736      * @dev See {IERC721-transferFrom}.
2737      */
2738     function transferFrom(
2739         address from,
2740         address to,
2741         uint256 tokenId
2742     ) public virtual override {
2743         //solhint-disable-next-line max-line-length
2744         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2745 
2746         _transfer(from, to, tokenId);
2747     }
2748 
2749     /**
2750      * @dev See {IERC721-safeTransferFrom}.
2751      */
2752     function safeTransferFrom(
2753         address from,
2754         address to,
2755         uint256 tokenId
2756     ) public virtual override {
2757         safeTransferFrom(from, to, tokenId, "");
2758     }
2759 
2760     /**
2761      * @dev See {IERC721-safeTransferFrom}.
2762      */
2763     function safeTransferFrom(
2764         address from,
2765         address to,
2766         uint256 tokenId,
2767         bytes memory _data
2768     ) public virtual override {
2769         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2770         _safeTransfer(from, to, tokenId, _data);
2771     }
2772 
2773     /**
2774      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2775      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2776      *
2777      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2778      *
2779      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2780      * implement alternative mechanisms to perform token transfer, such as signature-based.
2781      *
2782      * Requirements:
2783      *
2784      * - `from` cannot be the zero address.
2785      * - `to` cannot be the zero address.
2786      * - `tokenId` token must exist and be owned by `from`.
2787      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2788      *
2789      * Emits a {Transfer} event.
2790      */
2791     function _safeTransfer(
2792         address from,
2793         address to,
2794         uint256 tokenId,
2795         bytes memory _data
2796     ) internal virtual {
2797         _transfer(from, to, tokenId);
2798         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2799     }
2800 
2801     /**
2802      * @dev Returns whether `tokenId` exists.
2803      *
2804      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2805      *
2806      * Tokens start existing when they are minted (`_mint`),
2807      * and stop existing when they are burned (`_burn`).
2808      */
2809     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2810         return _owners[tokenId] != address(0);
2811     }
2812 
2813     /**
2814      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2815      *
2816      * Requirements:
2817      *
2818      * - `tokenId` must exist.
2819      */
2820     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2821         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2822         address owner = ERC721.ownerOf(tokenId);
2823         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2824     }
2825 
2826     /**
2827      * @dev Safely mints `tokenId` and transfers it to `to`.
2828      *
2829      * Requirements:
2830      *
2831      * - `tokenId` must not exist.
2832      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2833      *
2834      * Emits a {Transfer} event.
2835      */
2836     function _safeMint(address to, uint256 tokenId) internal virtual {
2837         _safeMint(to, tokenId, "");
2838     }
2839 
2840     /**
2841      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2842      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2843      */
2844     function _safeMint(
2845         address to,
2846         uint256 tokenId,
2847         bytes memory _data
2848     ) internal virtual {
2849         _mint(to, tokenId);
2850         require(
2851             _checkOnERC721Received(address(0), to, tokenId, _data),
2852             "ERC721: transfer to non ERC721Receiver implementer"
2853         );
2854     }
2855 
2856     /**
2857      * @dev Mints `tokenId` and transfers it to `to`.
2858      *
2859      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2860      *
2861      * Requirements:
2862      *
2863      * - `tokenId` must not exist.
2864      * - `to` cannot be the zero address.
2865      *
2866      * Emits a {Transfer} event.
2867      */
2868     function _mint(address to, uint256 tokenId) internal virtual {
2869         require(to != address(0), "ERC721: mint to the zero address");
2870         require(!_exists(tokenId), "ERC721: token already minted");
2871 
2872         _beforeTokenTransfer(address(0), to, tokenId);
2873 
2874         _balances[to] += 1;
2875         _owners[tokenId] = to;
2876 
2877         emit Transfer(address(0), to, tokenId);
2878     }
2879 
2880     /**
2881      * @dev Destroys `tokenId`.
2882      * The approval is cleared when the token is burned.
2883      *
2884      * Requirements:
2885      *
2886      * - `tokenId` must exist.
2887      *
2888      * Emits a {Transfer} event.
2889      */
2890     function _burn(uint256 tokenId) internal virtual {
2891         address owner = ERC721.ownerOf(tokenId);
2892 
2893         _beforeTokenTransfer(owner, address(0), tokenId);
2894 
2895         // Clear approvals
2896         _approve(address(0), tokenId);
2897 
2898         _balances[owner] -= 1;
2899         delete _owners[tokenId];
2900 
2901         emit Transfer(owner, address(0), tokenId);
2902     }
2903 
2904     /**
2905      * @dev Transfers `tokenId` from `from` to `to`.
2906      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2907      *
2908      * Requirements:
2909      *
2910      * - `to` cannot be the zero address.
2911      * - `tokenId` token must be owned by `from`.
2912      *
2913      * Emits a {Transfer} event.
2914      */
2915     function _transfer(
2916         address from,
2917         address to,
2918         uint256 tokenId
2919     ) internal virtual {
2920         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2921         require(to != address(0), "ERC721: transfer to the zero address");
2922 
2923         _beforeTokenTransfer(from, to, tokenId);
2924 
2925         // Clear approvals from the previous owner
2926         _approve(address(0), tokenId);
2927 
2928         _balances[from] -= 1;
2929         _balances[to] += 1;
2930         _owners[tokenId] = to;
2931 
2932         emit Transfer(from, to, tokenId);
2933     }
2934 
2935     /**
2936      * @dev Approve `to` to operate on `tokenId`
2937      *
2938      * Emits a {Approval} event.
2939      */
2940     function _approve(address to, uint256 tokenId) internal virtual {
2941         _tokenApprovals[tokenId] = to;
2942         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2943     }
2944 
2945     /**
2946      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2947      * The call is not executed if the target address is not a contract.
2948      *
2949      * @param from address representing the previous owner of the given token ID
2950      * @param to target address that will receive the tokens
2951      * @param tokenId uint256 ID of the token to be transferred
2952      * @param _data bytes optional data to send along with the call
2953      * @return bool whether the call correctly returned the expected magic value
2954      */
2955     function _checkOnERC721Received(
2956         address from,
2957         address to,
2958         uint256 tokenId,
2959         bytes memory _data
2960     ) private returns (bool) {
2961         if (to.isContract()) {
2962             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2963                 return retval == IERC721Receiver.onERC721Received.selector;
2964             } catch (bytes memory reason) {
2965                 if (reason.length == 0) {
2966                     revert("ERC721: transfer to non ERC721Receiver implementer");
2967                 } else {
2968                     assembly {
2969                         revert(add(32, reason), mload(reason))
2970                     }
2971                 }
2972             }
2973         } else {
2974             return true;
2975         }
2976     }
2977 
2978     /**
2979      * @dev Hook that is called before any token transfer. This includes minting
2980      * and burning.
2981      *
2982      * Calling conditions:
2983      *
2984      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2985      * transferred to `to`.
2986      * - When `from` is zero, `tokenId` will be minted for `to`.
2987      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2988      * - `from` and `to` are never both zero.
2989      *
2990      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2991      */
2992     function _beforeTokenTransfer(
2993         address from,
2994         address to,
2995         uint256 tokenId
2996     ) internal virtual {}
2997 }
2998 
2999 
3000 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.3
3001 
3002 // License: MIT
3003 
3004 pragma solidity ^0.8.0;
3005 
3006 /**
3007  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
3008  * @dev See https://eips.ethereum.org/EIPS/eip-721
3009  */
3010 interface IERC721Enumerable is IERC721 {
3011     /**
3012      * @dev Returns the total amount of tokens stored by the contract.
3013      */
3014     function totalSupply() external view returns (uint256);
3015 
3016     /**
3017      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
3018      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
3019      */
3020     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
3021 
3022     /**
3023      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
3024      * Use along with {totalSupply} to enumerate all tokens.
3025      */
3026     function tokenByIndex(uint256 index) external view returns (uint256);
3027 }
3028 
3029 
3030 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.3
3031 
3032 // License: MIT
3033 
3034 pragma solidity ^0.8.0;
3035 
3036 
3037 /**
3038  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
3039  * enumerability of all the token ids in the contract as well as all token ids owned by each
3040  * account.
3041  */
3042 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
3043     // Mapping from owner to list of owned token IDs
3044     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
3045 
3046     // Mapping from token ID to index of the owner tokens list
3047     mapping(uint256 => uint256) private _ownedTokensIndex;
3048 
3049     // Array with all token ids, used for enumeration
3050     uint256[] private _allTokens;
3051 
3052     // Mapping from token id to position in the allTokens array
3053     mapping(uint256 => uint256) private _allTokensIndex;
3054 
3055     /**
3056      * @dev See {IERC165-supportsInterface}.
3057      */
3058     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
3059         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
3060     }
3061 
3062     /**
3063      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
3064      */
3065     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
3066         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
3067         return _ownedTokens[owner][index];
3068     }
3069 
3070     /**
3071      * @dev See {IERC721Enumerable-totalSupply}.
3072      */
3073     function totalSupply() public view virtual override returns (uint256) {
3074         return _allTokens.length;
3075     }
3076 
3077     /**
3078      * @dev See {IERC721Enumerable-tokenByIndex}.
3079      */
3080     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
3081         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
3082         return _allTokens[index];
3083     }
3084 
3085     /**
3086      * @dev Hook that is called before any token transfer. This includes minting
3087      * and burning.
3088      *
3089      * Calling conditions:
3090      *
3091      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3092      * transferred to `to`.
3093      * - When `from` is zero, `tokenId` will be minted for `to`.
3094      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3095      * - `from` cannot be the zero address.
3096      * - `to` cannot be the zero address.
3097      *
3098      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3099      */
3100     function _beforeTokenTransfer(
3101         address from,
3102         address to,
3103         uint256 tokenId
3104     ) internal virtual override {
3105         super._beforeTokenTransfer(from, to, tokenId);
3106 
3107         if (from == address(0)) {
3108             _addTokenToAllTokensEnumeration(tokenId);
3109         } else if (from != to) {
3110             _removeTokenFromOwnerEnumeration(from, tokenId);
3111         }
3112         if (to == address(0)) {
3113             _removeTokenFromAllTokensEnumeration(tokenId);
3114         } else if (to != from) {
3115             _addTokenToOwnerEnumeration(to, tokenId);
3116         }
3117     }
3118 
3119     /**
3120      * @dev Private function to add a token to this extension's ownership-tracking data structures.
3121      * @param to address representing the new owner of the given token ID
3122      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
3123      */
3124     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
3125         uint256 length = ERC721.balanceOf(to);
3126         _ownedTokens[to][length] = tokenId;
3127         _ownedTokensIndex[tokenId] = length;
3128     }
3129 
3130     /**
3131      * @dev Private function to add a token to this extension's token tracking data structures.
3132      * @param tokenId uint256 ID of the token to be added to the tokens list
3133      */
3134     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
3135         _allTokensIndex[tokenId] = _allTokens.length;
3136         _allTokens.push(tokenId);
3137     }
3138 
3139     /**
3140      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
3141      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
3142      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
3143      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
3144      * @param from address representing the previous owner of the given token ID
3145      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
3146      */
3147     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
3148         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
3149         // then delete the last slot (swap and pop).
3150 
3151         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
3152         uint256 tokenIndex = _ownedTokensIndex[tokenId];
3153 
3154         // When the token to delete is the last token, the swap operation is unnecessary
3155         if (tokenIndex != lastTokenIndex) {
3156             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
3157 
3158             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3159             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3160         }
3161 
3162         // This also deletes the contents at the last position of the array
3163         delete _ownedTokensIndex[tokenId];
3164         delete _ownedTokens[from][lastTokenIndex];
3165     }
3166 
3167     /**
3168      * @dev Private function to remove a token from this extension's token tracking data structures.
3169      * This has O(1) time complexity, but alters the order of the _allTokens array.
3170      * @param tokenId uint256 ID of the token to be removed from the tokens list
3171      */
3172     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
3173         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
3174         // then delete the last slot (swap and pop).
3175 
3176         uint256 lastTokenIndex = _allTokens.length - 1;
3177         uint256 tokenIndex = _allTokensIndex[tokenId];
3178 
3179         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
3180         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
3181         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
3182         uint256 lastTokenId = _allTokens[lastTokenIndex];
3183 
3184         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3185         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3186 
3187         // This also deletes the contents at the last position of the array
3188         delete _allTokensIndex[tokenId];
3189         _allTokens.pop();
3190     }
3191 }
3192 
3193 
3194 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.3
3195 
3196 // License: MIT
3197 
3198 pragma solidity ^0.8.0;
3199 
3200 /**
3201  * @dev Contract module which allows children to implement an emergency stop
3202  * mechanism that can be triggered by an authorized account.
3203  *
3204  * This module is used through inheritance. It will make available the
3205  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
3206  * the functions of your contract. Note that they will not be pausable by
3207  * simply including this module, only once the modifiers are put in place.
3208  */
3209 abstract contract Pausable is Context {
3210     /**
3211      * @dev Emitted when the pause is triggered by `account`.
3212      */
3213     event Paused(address account);
3214 
3215     /**
3216      * @dev Emitted when the pause is lifted by `account`.
3217      */
3218     event Unpaused(address account);
3219 
3220     bool private _paused;
3221 
3222     /**
3223      * @dev Initializes the contract in unpaused state.
3224      */
3225     constructor() {
3226         _paused = false;
3227     }
3228 
3229     /**
3230      * @dev Returns true if the contract is paused, and false otherwise.
3231      */
3232     function paused() public view virtual returns (bool) {
3233         return _paused;
3234     }
3235 
3236     /**
3237      * @dev Modifier to make a function callable only when the contract is not paused.
3238      *
3239      * Requirements:
3240      *
3241      * - The contract must not be paused.
3242      */
3243     modifier whenNotPaused() {
3244         require(!paused(), "Pausable: paused");
3245         _;
3246     }
3247 
3248     /**
3249      * @dev Modifier to make a function callable only when the contract is paused.
3250      *
3251      * Requirements:
3252      *
3253      * - The contract must be paused.
3254      */
3255     modifier whenPaused() {
3256         require(paused(), "Pausable: not paused");
3257         _;
3258     }
3259 
3260     /**
3261      * @dev Triggers stopped state.
3262      *
3263      * Requirements:
3264      *
3265      * - The contract must not be paused.
3266      */
3267     function _pause() internal virtual whenNotPaused {
3268         _paused = true;
3269         emit Paused(_msgSender());
3270     }
3271 
3272     /**
3273      * @dev Returns to normal state.
3274      *
3275      * Requirements:
3276      *
3277      * - The contract must be paused.
3278      */
3279     function _unpause() internal virtual whenPaused {
3280         _paused = false;
3281         emit Unpaused(_msgSender());
3282     }
3283 }
3284 
3285 
3286 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol@v4.3.3
3287 
3288 // License: MIT
3289 
3290 pragma solidity ^0.8.0;
3291 
3292 
3293 /**
3294  * @dev ERC721 token with pausable token transfers, minting and burning.
3295  *
3296  * Useful for scenarios such as preventing trades until the end of an evaluation
3297  * period, or having an emergency switch for freezing all token transfers in the
3298  * event of a large bug.
3299  */
3300 abstract contract ERC721Pausable is ERC721, Pausable {
3301     /**
3302      * @dev See {ERC721-_beforeTokenTransfer}.
3303      *
3304      * Requirements:
3305      *
3306      * - the contract must not be paused.
3307      */
3308     function _beforeTokenTransfer(
3309         address from,
3310         address to,
3311         uint256 tokenId
3312     ) internal virtual override {
3313         super._beforeTokenTransfer(from, to, tokenId);
3314 
3315         require(!paused(), "ERC721Pausable: token transfer while paused");
3316     }
3317 }
3318 
3319 
3320 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.3.3
3321 
3322 // License: MIT
3323 
3324 pragma solidity ^0.8.0;
3325 
3326 
3327 /**
3328  * @title ERC721 Burnable Token
3329  * @dev ERC721 Token that can be irreversibly burned (destroyed).
3330  */
3331 abstract contract ERC721Burnable is Context, ERC721 {
3332     /**
3333      * @dev Burns `tokenId`. See {ERC721-_burn}.
3334      *
3335      * Requirements:
3336      *
3337      * - The caller must own `tokenId` or be an approved operator.
3338      */
3339     function burn(uint256 tokenId) public virtual {
3340         //solhint-disable-next-line max-line-length
3341         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
3342         _burn(tokenId);
3343     }
3344 }
3345 
3346 
3347 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.3.3
3348 
3349 // License: MIT
3350 
3351 pragma solidity ^0.8.0;
3352 
3353 /**
3354  * @dev External interface of AccessControl declared to support ERC165 detection.
3355  */
3356 interface IAccessControl {
3357     /**
3358      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
3359      *
3360      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
3361      * {RoleAdminChanged} not being emitted signaling this.
3362      *
3363      * _Available since v3.1._
3364      */
3365     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
3366 
3367     /**
3368      * @dev Emitted when `account` is granted `role`.
3369      *
3370      * `sender` is the account that originated the contract call, an admin role
3371      * bearer except when using {AccessControl-_setupRole}.
3372      */
3373     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
3374 
3375     /**
3376      * @dev Emitted when `account` is revoked `role`.
3377      *
3378      * `sender` is the account that originated the contract call:
3379      *   - if using `revokeRole`, it is the admin role bearer
3380      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
3381      */
3382     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
3383 
3384     /**
3385      * @dev Returns `true` if `account` has been granted `role`.
3386      */
3387     function hasRole(bytes32 role, address account) external view returns (bool);
3388 
3389     /**
3390      * @dev Returns the admin role that controls `role`. See {grantRole} and
3391      * {revokeRole}.
3392      *
3393      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
3394      */
3395     function getRoleAdmin(bytes32 role) external view returns (bytes32);
3396 
3397     /**
3398      * @dev Grants `role` to `account`.
3399      *
3400      * If `account` had not been already granted `role`, emits a {RoleGranted}
3401      * event.
3402      *
3403      * Requirements:
3404      *
3405      * - the caller must have ``role``'s admin role.
3406      */
3407     function grantRole(bytes32 role, address account) external;
3408 
3409     /**
3410      * @dev Revokes `role` from `account`.
3411      *
3412      * If `account` had been granted `role`, emits a {RoleRevoked} event.
3413      *
3414      * Requirements:
3415      *
3416      * - the caller must have ``role``'s admin role.
3417      */
3418     function revokeRole(bytes32 role, address account) external;
3419 
3420     /**
3421      * @dev Revokes `role` from the calling account.
3422      *
3423      * Roles are often managed via {grantRole} and {revokeRole}: this function's
3424      * purpose is to provide a mechanism for accounts to lose their privileges
3425      * if they are compromised (such as when a trusted device is misplaced).
3426      *
3427      * If the calling account had been granted `role`, emits a {RoleRevoked}
3428      * event.
3429      *
3430      * Requirements:
3431      *
3432      * - the caller must be `account`.
3433      */
3434     function renounceRole(bytes32 role, address account) external;
3435 }
3436 
3437 
3438 // File @openzeppelin/contracts/access/IAccessControlEnumerable.sol@v4.3.3
3439 
3440 // License: MIT
3441 
3442 pragma solidity ^0.8.0;
3443 
3444 /**
3445  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
3446  */
3447 interface IAccessControlEnumerable is IAccessControl {
3448     /**
3449      * @dev Returns one of the accounts that have `role`. `index` must be a
3450      * value between 0 and {getRoleMemberCount}, non-inclusive.
3451      *
3452      * Role bearers are not sorted in any particular way, and their ordering may
3453      * change at any point.
3454      *
3455      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
3456      * you perform all queries on the same block. See the following
3457      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
3458      * for more information.
3459      */
3460     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
3461 
3462     /**
3463      * @dev Returns the number of accounts that have `role`. Can be used
3464      * together with {getRoleMember} to enumerate all bearers of a role.
3465      */
3466     function getRoleMemberCount(bytes32 role) external view returns (uint256);
3467 }
3468 
3469 
3470 // File @openzeppelin/contracts/access/AccessControl.sol@v4.3.3
3471 
3472 // License: MIT
3473 
3474 pragma solidity ^0.8.0;
3475 
3476 
3477 
3478 
3479 /**
3480  * @dev Contract module that allows children to implement role-based access
3481  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
3482  * members except through off-chain means by accessing the contract event logs. Some
3483  * applications may benefit from on-chain enumerability, for those cases see
3484  * {AccessControlEnumerable}.
3485  *
3486  * Roles are referred to by their `bytes32` identifier. These should be exposed
3487  * in the external API and be unique. The best way to achieve this is by
3488  * using `public constant` hash digests:
3489  *
3490  * ```
3491  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
3492  * ```
3493  *
3494  * Roles can be used to represent a set of permissions. To restrict access to a
3495  * function call, use {hasRole}:
3496  *
3497  * ```
3498  * function foo() public {
3499  *     require(hasRole(MY_ROLE, msg.sender));
3500  *     ...
3501  * }
3502  * ```
3503  *
3504  * Roles can be granted and revoked dynamically via the {grantRole} and
3505  * {revokeRole} functions. Each role has an associated admin role, and only
3506  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
3507  *
3508  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
3509  * that only accounts with this role will be able to grant or revoke other
3510  * roles. More complex role relationships can be created by using
3511  * {_setRoleAdmin}.
3512  *
3513  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
3514  * grant and revoke this role. Extra precautions should be taken to secure
3515  * accounts that have been granted it.
3516  */
3517 abstract contract AccessControl is Context, IAccessControl, ERC165 {
3518     struct RoleData {
3519         mapping(address => bool) members;
3520         bytes32 adminRole;
3521     }
3522 
3523     mapping(bytes32 => RoleData) private _roles;
3524 
3525     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
3526 
3527     /**
3528      * @dev Modifier that checks that an account has a specific role. Reverts
3529      * with a standardized message including the required role.
3530      *
3531      * The format of the revert reason is given by the following regular expression:
3532      *
3533      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
3534      *
3535      * _Available since v4.1._
3536      */
3537     modifier onlyRole(bytes32 role) {
3538         _checkRole(role, _msgSender());
3539         _;
3540     }
3541 
3542     /**
3543      * @dev See {IERC165-supportsInterface}.
3544      */
3545     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3546         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
3547     }
3548 
3549     /**
3550      * @dev Returns `true` if `account` has been granted `role`.
3551      */
3552     function hasRole(bytes32 role, address account) public view override returns (bool) {
3553         return _roles[role].members[account];
3554     }
3555 
3556     /**
3557      * @dev Revert with a standard message if `account` is missing `role`.
3558      *
3559      * The format of the revert reason is given by the following regular expression:
3560      *
3561      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
3562      */
3563     function _checkRole(bytes32 role, address account) internal view {
3564         if (!hasRole(role, account)) {
3565             revert(
3566                 string(
3567                     abi.encodePacked(
3568                         "AccessControl: account ",
3569                         Strings.toHexString(uint160(account), 20),
3570                         " is missing role ",
3571                         Strings.toHexString(uint256(role), 32)
3572                     )
3573                 )
3574             );
3575         }
3576     }
3577 
3578     /**
3579      * @dev Returns the admin role that controls `role`. See {grantRole} and
3580      * {revokeRole}.
3581      *
3582      * To change a role's admin, use {_setRoleAdmin}.
3583      */
3584     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
3585         return _roles[role].adminRole;
3586     }
3587 
3588     /**
3589      * @dev Grants `role` to `account`.
3590      *
3591      * If `account` had not been already granted `role`, emits a {RoleGranted}
3592      * event.
3593      *
3594      * Requirements:
3595      *
3596      * - the caller must have ``role``'s admin role.
3597      */
3598     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
3599         _grantRole(role, account);
3600     }
3601 
3602     /**
3603      * @dev Revokes `role` from `account`.
3604      *
3605      * If `account` had been granted `role`, emits a {RoleRevoked} event.
3606      *
3607      * Requirements:
3608      *
3609      * - the caller must have ``role``'s admin role.
3610      */
3611     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
3612         _revokeRole(role, account);
3613     }
3614 
3615     /**
3616      * @dev Revokes `role` from the calling account.
3617      *
3618      * Roles are often managed via {grantRole} and {revokeRole}: this function's
3619      * purpose is to provide a mechanism for accounts to lose their privileges
3620      * if they are compromised (such as when a trusted device is misplaced).
3621      *
3622      * If the calling account had been granted `role`, emits a {RoleRevoked}
3623      * event.
3624      *
3625      * Requirements:
3626      *
3627      * - the caller must be `account`.
3628      */
3629     function renounceRole(bytes32 role, address account) public virtual override {
3630         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
3631 
3632         _revokeRole(role, account);
3633     }
3634 
3635     /**
3636      * @dev Grants `role` to `account`.
3637      *
3638      * If `account` had not been already granted `role`, emits a {RoleGranted}
3639      * event. Note that unlike {grantRole}, this function doesn't perform any
3640      * checks on the calling account.
3641      *
3642      * [WARNING]
3643      * ====
3644      * This function should only be called from the constructor when setting
3645      * up the initial roles for the system.
3646      *
3647      * Using this function in any other way is effectively circumventing the admin
3648      * system imposed by {AccessControl}.
3649      * ====
3650      */
3651     function _setupRole(bytes32 role, address account) internal virtual {
3652         _grantRole(role, account);
3653     }
3654 
3655     /**
3656      * @dev Sets `adminRole` as ``role``'s admin role.
3657      *
3658      * Emits a {RoleAdminChanged} event.
3659      */
3660     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
3661         bytes32 previousAdminRole = getRoleAdmin(role);
3662         _roles[role].adminRole = adminRole;
3663         emit RoleAdminChanged(role, previousAdminRole, adminRole);
3664     }
3665 
3666     function _grantRole(bytes32 role, address account) private {
3667         if (!hasRole(role, account)) {
3668             _roles[role].members[account] = true;
3669             emit RoleGranted(role, account, _msgSender());
3670         }
3671     }
3672 
3673     function _revokeRole(bytes32 role, address account) private {
3674         if (hasRole(role, account)) {
3675             _roles[role].members[account] = false;
3676             emit RoleRevoked(role, account, _msgSender());
3677         }
3678     }
3679 }
3680 
3681 
3682 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.3.3
3683 
3684 // License: MIT
3685 
3686 pragma solidity ^0.8.0;
3687 
3688 /**
3689  * @dev Library for managing
3690  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
3691  * types.
3692  *
3693  * Sets have the following properties:
3694  *
3695  * - Elements are added, removed, and checked for existence in constant time
3696  * (O(1)).
3697  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
3698  *
3699  * ```
3700  * contract Example {
3701  *     // Add the library methods
3702  *     using EnumerableSet for EnumerableSet.AddressSet;
3703  *
3704  *     // Declare a set state variable
3705  *     EnumerableSet.AddressSet private mySet;
3706  * }
3707  * ```
3708  *
3709  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
3710  * and `uint256` (`UintSet`) are supported.
3711  */
3712 library EnumerableSet {
3713     // To implement this library for multiple types with as little code
3714     // repetition as possible, we write it in terms of a generic Set type with
3715     // bytes32 values.
3716     // The Set implementation uses private functions, and user-facing
3717     // implementations (such as AddressSet) are just wrappers around the
3718     // underlying Set.
3719     // This means that we can only create new EnumerableSets for types that fit
3720     // in bytes32.
3721 
3722     struct Set {
3723         // Storage of set values
3724         bytes32[] _values;
3725         // Position of the value in the `values` array, plus 1 because index 0
3726         // means a value is not in the set.
3727         mapping(bytes32 => uint256) _indexes;
3728     }
3729 
3730     /**
3731      * @dev Add a value to a set. O(1).
3732      *
3733      * Returns true if the value was added to the set, that is if it was not
3734      * already present.
3735      */
3736     function _add(Set storage set, bytes32 value) private returns (bool) {
3737         if (!_contains(set, value)) {
3738             set._values.push(value);
3739             // The value is stored at length-1, but we add 1 to all indexes
3740             // and use 0 as a sentinel value
3741             set._indexes[value] = set._values.length;
3742             return true;
3743         } else {
3744             return false;
3745         }
3746     }
3747 
3748     /**
3749      * @dev Removes a value from a set. O(1).
3750      *
3751      * Returns true if the value was removed from the set, that is if it was
3752      * present.
3753      */
3754     function _remove(Set storage set, bytes32 value) private returns (bool) {
3755         // We read and store the value's index to prevent multiple reads from the same storage slot
3756         uint256 valueIndex = set._indexes[value];
3757 
3758         if (valueIndex != 0) {
3759             // Equivalent to contains(set, value)
3760             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
3761             // the array, and then remove the last element (sometimes called as 'swap and pop').
3762             // This modifies the order of the array, as noted in {at}.
3763 
3764             uint256 toDeleteIndex = valueIndex - 1;
3765             uint256 lastIndex = set._values.length - 1;
3766 
3767             if (lastIndex != toDeleteIndex) {
3768                 bytes32 lastvalue = set._values[lastIndex];
3769 
3770                 // Move the last value to the index where the value to delete is
3771                 set._values[toDeleteIndex] = lastvalue;
3772                 // Update the index for the moved value
3773                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
3774             }
3775 
3776             // Delete the slot where the moved value was stored
3777             set._values.pop();
3778 
3779             // Delete the index for the deleted slot
3780             delete set._indexes[value];
3781 
3782             return true;
3783         } else {
3784             return false;
3785         }
3786     }
3787 
3788     /**
3789      * @dev Returns true if the value is in the set. O(1).
3790      */
3791     function _contains(Set storage set, bytes32 value) private view returns (bool) {
3792         return set._indexes[value] != 0;
3793     }
3794 
3795     /**
3796      * @dev Returns the number of values on the set. O(1).
3797      */
3798     function _length(Set storage set) private view returns (uint256) {
3799         return set._values.length;
3800     }
3801 
3802     /**
3803      * @dev Returns the value stored at position `index` in the set. O(1).
3804      *
3805      * Note that there are no guarantees on the ordering of values inside the
3806      * array, and it may change when more values are added or removed.
3807      *
3808      * Requirements:
3809      *
3810      * - `index` must be strictly less than {length}.
3811      */
3812     function _at(Set storage set, uint256 index) private view returns (bytes32) {
3813         return set._values[index];
3814     }
3815 
3816     /**
3817      * @dev Return the entire set in an array
3818      *
3819      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3820      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3821      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3822      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3823      */
3824     function _values(Set storage set) private view returns (bytes32[] memory) {
3825         return set._values;
3826     }
3827 
3828     // Bytes32Set
3829 
3830     struct Bytes32Set {
3831         Set _inner;
3832     }
3833 
3834     /**
3835      * @dev Add a value to a set. O(1).
3836      *
3837      * Returns true if the value was added to the set, that is if it was not
3838      * already present.
3839      */
3840     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
3841         return _add(set._inner, value);
3842     }
3843 
3844     /**
3845      * @dev Removes a value from a set. O(1).
3846      *
3847      * Returns true if the value was removed from the set, that is if it was
3848      * present.
3849      */
3850     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
3851         return _remove(set._inner, value);
3852     }
3853 
3854     /**
3855      * @dev Returns true if the value is in the set. O(1).
3856      */
3857     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
3858         return _contains(set._inner, value);
3859     }
3860 
3861     /**
3862      * @dev Returns the number of values in the set. O(1).
3863      */
3864     function length(Bytes32Set storage set) internal view returns (uint256) {
3865         return _length(set._inner);
3866     }
3867 
3868     /**
3869      * @dev Returns the value stored at position `index` in the set. O(1).
3870      *
3871      * Note that there are no guarantees on the ordering of values inside the
3872      * array, and it may change when more values are added or removed.
3873      *
3874      * Requirements:
3875      *
3876      * - `index` must be strictly less than {length}.
3877      */
3878     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
3879         return _at(set._inner, index);
3880     }
3881 
3882     /**
3883      * @dev Return the entire set in an array
3884      *
3885      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3886      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3887      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3888      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3889      */
3890     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
3891         return _values(set._inner);
3892     }
3893 
3894     // AddressSet
3895 
3896     struct AddressSet {
3897         Set _inner;
3898     }
3899 
3900     /**
3901      * @dev Add a value to a set. O(1).
3902      *
3903      * Returns true if the value was added to the set, that is if it was not
3904      * already present.
3905      */
3906     function add(AddressSet storage set, address value) internal returns (bool) {
3907         return _add(set._inner, bytes32(uint256(uint160(value))));
3908     }
3909 
3910     /**
3911      * @dev Removes a value from a set. O(1).
3912      *
3913      * Returns true if the value was removed from the set, that is if it was
3914      * present.
3915      */
3916     function remove(AddressSet storage set, address value) internal returns (bool) {
3917         return _remove(set._inner, bytes32(uint256(uint160(value))));
3918     }
3919 
3920     /**
3921      * @dev Returns true if the value is in the set. O(1).
3922      */
3923     function contains(AddressSet storage set, address value) internal view returns (bool) {
3924         return _contains(set._inner, bytes32(uint256(uint160(value))));
3925     }
3926 
3927     /**
3928      * @dev Returns the number of values in the set. O(1).
3929      */
3930     function length(AddressSet storage set) internal view returns (uint256) {
3931         return _length(set._inner);
3932     }
3933 
3934     /**
3935      * @dev Returns the value stored at position `index` in the set. O(1).
3936      *
3937      * Note that there are no guarantees on the ordering of values inside the
3938      * array, and it may change when more values are added or removed.
3939      *
3940      * Requirements:
3941      *
3942      * - `index` must be strictly less than {length}.
3943      */
3944     function at(AddressSet storage set, uint256 index) internal view returns (address) {
3945         return address(uint160(uint256(_at(set._inner, index))));
3946     }
3947 
3948     /**
3949      * @dev Return the entire set in an array
3950      *
3951      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3952      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3953      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3954      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3955      */
3956     function values(AddressSet storage set) internal view returns (address[] memory) {
3957         bytes32[] memory store = _values(set._inner);
3958         address[] memory result;
3959 
3960         assembly {
3961             result := store
3962         }
3963 
3964         return result;
3965     }
3966 
3967     // UintSet
3968 
3969     struct UintSet {
3970         Set _inner;
3971     }
3972 
3973     /**
3974      * @dev Add a value to a set. O(1).
3975      *
3976      * Returns true if the value was added to the set, that is if it was not
3977      * already present.
3978      */
3979     function add(UintSet storage set, uint256 value) internal returns (bool) {
3980         return _add(set._inner, bytes32(value));
3981     }
3982 
3983     /**
3984      * @dev Removes a value from a set. O(1).
3985      *
3986      * Returns true if the value was removed from the set, that is if it was
3987      * present.
3988      */
3989     function remove(UintSet storage set, uint256 value) internal returns (bool) {
3990         return _remove(set._inner, bytes32(value));
3991     }
3992 
3993     /**
3994      * @dev Returns true if the value is in the set. O(1).
3995      */
3996     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
3997         return _contains(set._inner, bytes32(value));
3998     }
3999 
4000     /**
4001      * @dev Returns the number of values on the set. O(1).
4002      */
4003     function length(UintSet storage set) internal view returns (uint256) {
4004         return _length(set._inner);
4005     }
4006 
4007     /**
4008      * @dev Returns the value stored at position `index` in the set. O(1).
4009      *
4010      * Note that there are no guarantees on the ordering of values inside the
4011      * array, and it may change when more values are added or removed.
4012      *
4013      * Requirements:
4014      *
4015      * - `index` must be strictly less than {length}.
4016      */
4017     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
4018         return uint256(_at(set._inner, index));
4019     }
4020 
4021     /**
4022      * @dev Return the entire set in an array
4023      *
4024      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
4025      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
4026      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
4027      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
4028      */
4029     function values(UintSet storage set) internal view returns (uint256[] memory) {
4030         bytes32[] memory store = _values(set._inner);
4031         uint256[] memory result;
4032 
4033         assembly {
4034             result := store
4035         }
4036 
4037         return result;
4038     }
4039 }
4040 
4041 
4042 // File @openzeppelin/contracts/access/AccessControlEnumerable.sol@v4.3.3
4043 
4044 // License: MIT
4045 
4046 pragma solidity ^0.8.0;
4047 
4048 
4049 
4050 /**
4051  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
4052  */
4053 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
4054     using EnumerableSet for EnumerableSet.AddressSet;
4055 
4056     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
4057 
4058     /**
4059      * @dev See {IERC165-supportsInterface}.
4060      */
4061     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
4062         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
4063     }
4064 
4065     /**
4066      * @dev Returns one of the accounts that have `role`. `index` must be a
4067      * value between 0 and {getRoleMemberCount}, non-inclusive.
4068      *
4069      * Role bearers are not sorted in any particular way, and their ordering may
4070      * change at any point.
4071      *
4072      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
4073      * you perform all queries on the same block. See the following
4074      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
4075      * for more information.
4076      */
4077     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
4078         return _roleMembers[role].at(index);
4079     }
4080 
4081     /**
4082      * @dev Returns the number of accounts that have `role`. Can be used
4083      * together with {getRoleMember} to enumerate all bearers of a role.
4084      */
4085     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
4086         return _roleMembers[role].length();
4087     }
4088 
4089     /**
4090      * @dev Overload {grantRole} to track enumerable memberships
4091      */
4092     function grantRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
4093         super.grantRole(role, account);
4094         _roleMembers[role].add(account);
4095     }
4096 
4097     /**
4098      * @dev Overload {revokeRole} to track enumerable memberships
4099      */
4100     function revokeRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
4101         super.revokeRole(role, account);
4102         _roleMembers[role].remove(account);
4103     }
4104 
4105     /**
4106      * @dev Overload {renounceRole} to track enumerable memberships
4107      */
4108     function renounceRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
4109         super.renounceRole(role, account);
4110         _roleMembers[role].remove(account);
4111     }
4112 
4113     /**
4114      * @dev Overload {_setupRole} to track enumerable memberships
4115      */
4116     function _setupRole(bytes32 role, address account) internal virtual override {
4117         super._setupRole(role, account);
4118         _roleMembers[role].add(account);
4119     }
4120 }
4121 
4122 
4123 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.3
4124 
4125 // License: MIT
4126 
4127 pragma solidity ^0.8.0;
4128 
4129 /**
4130  * @dev Contract module that helps prevent reentrant calls to a function.
4131  *
4132  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
4133  * available, which can be applied to functions to make sure there are no nested
4134  * (reentrant) calls to them.
4135  *
4136  * Note that because there is a single `nonReentrant` guard, functions marked as
4137  * `nonReentrant` may not call one another. This can be worked around by making
4138  * those functions `private`, and then adding `external` `nonReentrant` entry
4139  * points to them.
4140  *
4141  * TIP: If you would like to learn more about reentrancy and alternative ways
4142  * to protect against it, check out our blog post
4143  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
4144  */
4145 abstract contract ReentrancyGuard {
4146     // Booleans are more expensive than uint256 or any type that takes up a full
4147     // word because each write operation emits an extra SLOAD to first read the
4148     // slot's contents, replace the bits taken up by the boolean, and then write
4149     // back. This is the compiler's defense against contract upgrades and
4150     // pointer aliasing, and it cannot be disabled.
4151 
4152     // The values being non-zero value makes deployment a bit more expensive,
4153     // but in exchange the refund on every call to nonReentrant will be lower in
4154     // amount. Since refunds are capped to a percentage of the total
4155     // transaction's gas, it is best to keep them low in cases like this one, to
4156     // increase the likelihood of the full refund coming into effect.
4157     uint256 private constant _NOT_ENTERED = 1;
4158     uint256 private constant _ENTERED = 2;
4159 
4160     uint256 private _status;
4161 
4162     constructor() {
4163         _status = _NOT_ENTERED;
4164     }
4165 
4166     /**
4167      * @dev Prevents a contract from calling itself, directly or indirectly.
4168      * Calling a `nonReentrant` function from another `nonReentrant`
4169      * function is not supported. It is possible to prevent this from happening
4170      * by making the `nonReentrant` function external, and make it call a
4171      * `private` function that does the actual work.
4172      */
4173     modifier nonReentrant() {
4174         // On the first call to nonReentrant, _notEntered will be true
4175         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
4176 
4177         // Any calls to nonReentrant after this point will fail
4178         _status = _ENTERED;
4179 
4180         _;
4181 
4182         // By storing the original value once again, a refund is triggered (see
4183         // https://eips.ethereum.org/EIPS/eip-2200)
4184         _status = _NOT_ENTERED;
4185     }
4186 }
4187 
4188 
4189 // File contracts/Projects/CityLights/KohiCityLights.sol
4190 
4191 // License: UNLICENSED
4192 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
4193 
4194 pragma solidity ^0.8.0;
4195 interface IBloomList {
4196     function updateAdmin(address newAdmin) external;
4197     function isInBloomList(address _address) external view returns (bool);    
4198 }
4199 
4200 
4201 
4202 contract KohiCityLights is Context, AccessControlEnumerable, ERC721, ERC721Enumerable, ERC721Pausable, ERC721Burnable, ReentrancyGuard {
4203 
4204     using Address for address;
4205 
4206     struct Collection {
4207         string name;
4208         string baseTokenUri;        
4209         string description;
4210         string license;
4211         uint priceInWei;
4212         int32 seed;
4213         uint minted;
4214         uint mintedMax;        
4215         uint mintedMaxPerOwner;
4216         uint lockAt;
4217         bool paused;
4218         bool active;        
4219         string creatorName;
4220         address payable creatorAddress;        
4221         address _renderer;
4222     }
4223     
4224     mapping(uint8 => Collection) internal collections;   
4225     
4226     event CollectionMinted (
4227         uint256 indexed tokenId,        
4228         address indexed recipient,        
4229         uint256 mintId,
4230         uint256 priceInWei,
4231         int32 seed
4232     );
4233 
4234     uint private lastTokenId;  
4235     mapping(address => uint) private ownerMints;
4236     mapping(uint => int32) internal tokenSeed;
4237 
4238     bool private locked;
4239     bool private presale;    
4240 
4241     uint8 private ownerRoyalty;
4242     address payable private ownerAddress;
4243 
4244     address private _admin;
4245     address private _ownership;
4246 
4247     uint presalePriceInWei;
4248     mapping(address => uint) presaleMints;
4249     mapping(uint => bool) presoldTokens;
4250 
4251     constructor(address ownership) ERC721("CityLights", "EEPCL") {        
4252         lastTokenId = 0;
4253         _admin = _msgSender();
4254         _contractUri = "https://kohi.art/metadata";
4255         _ownership = ownership;
4256         presalePriceInWei = 330000000000000000;
4257         _pause();      
4258     }
4259 
4260     string private _contractUri;
4261 
4262     /*
4263     * @dev See: https://docs.opensea.io/docs/contract-level-metadata
4264     */
4265     function contractURI() public view returns (string memory) {
4266         return _contractUri;
4267     }
4268 
4269     function updateContractUri(string memory contractUri) public {
4270         if(_msgSender() != _admin) revert AdminOnly();
4271         _contractUri = contractUri;
4272     }
4273 
4274     function updateAdmin(address newAdmin) public {
4275         if(_msgSender() != _admin) revert AdminOnly();
4276         if(newAdmin == address(0x0)) revert AddressMustBeSet();
4277         _admin = newAdmin;       
4278     }
4279 
4280     function updateOwnerData(uint8 royalty, address payable newAddress) public {
4281         if(_msgSender() != _admin) revert AdminOnly();
4282         if(newAddress == address(0x0)) revert AddressMustBeSet();
4283         if(royalty == 0 || royalty > 100) revert InvalidOwnerRoyalty();        
4284         ownerRoyalty = royalty;
4285         ownerAddress = newAddress;
4286     }
4287 
4288     function getPresale() external view returns (bool) {
4289         return presale;
4290     }
4291 
4292     function togglePresale() external {
4293         if(_msgSender() != _admin) revert AdminOnly();
4294         if(presale) {
4295             presale = false;
4296         } else {
4297             presale = true;
4298         }        
4299     }
4300 
4301     function toggleLocked() external {
4302         if(_msgSender() != _admin) revert AdminOnly();
4303         if(locked) {
4304             locked = false;
4305         } else {
4306             locked = true;
4307         } 
4308     }
4309 
4310     function togglePaused() external {
4311         if(_msgSender() != _admin) revert AdminOnly();
4312         if(paused()) {
4313             _unpause();
4314         }
4315         else {
4316             _pause();
4317         }
4318     }
4319 
4320     function setPresalePrice(uint priceInWei) public {
4321         if(_msgSender() != _admin) revert AdminOnly();
4322         presalePriceInWei = priceInWei;
4323     }
4324 
4325     function setPrice(uint priceInWei) public {
4326         if(_msgSender() != _admin) revert AdminOnly();
4327         collections[0].priceInWei = priceInWei;
4328     }
4329 
4330     /**
4331      * @dev See {IERC165-supportsInterface}.
4332      */
4333     function supportsInterface(bytes4 interfaceId)
4334         public
4335         view
4336         virtual
4337         override(AccessControlEnumerable, ERC721, ERC721Enumerable)
4338         returns (bool)
4339     {
4340         return super.supportsInterface(interfaceId);
4341     }
4342 
4343     /**
4344      * @dev Hook that is called before any token transfer. This includes minting
4345      * and burning.
4346      *
4347      * Calling conditions:
4348      *
4349      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
4350      * transferred to `to`.
4351      * - When `from` is zero, `tokenId` will be minted for `to`.
4352      * - When `to` is zero, ``from``'s `tokenId` will be burned.
4353      * - `from` and `to` are never both zero.
4354      *
4355      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
4356      */
4357     function _beforeTokenTransfer(
4358         address from,
4359         address to,
4360         uint256 tokenId
4361     ) internal virtual override (ERC721, ERC721Enumerable, ERC721Pausable) {
4362         super._beforeTokenTransfer(from, to, tokenId);   
4363         if(collections[0].paused) revert CollectionPaused();                    
4364     }
4365 
4366     function getCollection() public view returns (Collection memory collection) {        
4367         return collections[0];
4368     }
4369 
4370     function updateCollection(Collection memory collection) public {
4371         if(_msgSender() != _admin) revert AdminOnly();
4372         if(collection._renderer == address(0x0) || !collection._renderer.isContract()) revert InvalidRenderer();
4373         collections[0] = collection;
4374     }
4375         
4376     /**
4377      * @notice Sets the collection's unique seed. It cannot be modified once set.
4378      * @dev This is a source of external entropy, by the contract owner, to avoid determinism on PRNG that could exploit the mint's parameters.
4379      */
4380     function setSeed(int32 seed) external {  
4381         if(_msgSender() != _admin) revert AdminOnly();
4382         if(seed == 0) revert InvalidSeed();
4383         if(collections[0].seed != 0) revert SeedAlreadySet();
4384         collections[0].seed = seed;
4385     }
4386 
4387     function getSeed() external view returns (int32) {  
4388         if(_msgSender() != _admin) revert AdminOnly();
4389         if(collections[0].seed == 0) revert SeedNotSet();
4390         return collections[0].seed;
4391     }
4392 
4393     function getOwnership() external view returns(address) {
4394         if(_msgSender() != _admin) revert AdminOnly();
4395         return _ownership;
4396     }
4397 
4398     function setOwnership(address newOwnership) external {
4399         if(_msgSender() != _admin) revert AdminOnly();
4400         _ownership = newOwnership;
4401     }
4402 
4403     function releaseControl() external {
4404         if(_msgSender() != _admin) revert AdminOnly();
4405         IBloomList(_ownership).updateAdmin(_msgSender());
4406     }       
4407 
4408     function purchasePresale(uint count) external payable {
4409         purchasePresaleFor(_msgSender(), count);
4410     }   
4411 
4412     function purchasePresaleFor(address recipient, uint count) public payable nonReentrant {
4413         if(!presale) revert PresaleNotOpen();
4414 
4415         address minter = _msgSender();
4416         uint balance = IERC721(_ownership).balanceOf(minter);        
4417         bool inBloomList = IBloomList(_ownership).isInBloomList(minter);
4418         
4419         // start with simple eligibility check
4420         if(!inBloomList && balance < 1) revert NotEligibleForPresale();
4421 
4422         // get count of all owned kintsugi tokens not already presold
4423         uint presaleBalance = 0;
4424         for(uint i = 0; i < balance; i++) {  
4425             uint tokenId = IERC721Enumerable(_ownership).tokenOfOwnerByIndex(minter, i);
4426             if(!presoldTokens[tokenId]) {
4427                 presaleBalance++;
4428                 presoldTokens[tokenId] = true;
4429                 if(presaleBalance >= count) {
4430                     break; // have enough
4431                 }
4432             }
4433         }
4434         
4435         // if in bloom list, with no entitlements, give one if they haven't minted one
4436         if(inBloomList && presaleBalance == 0 && presaleMints[minter] == 0) {
4437             presaleBalance = 1;
4438         }
4439 
4440         // if minter's count is over their balance, adjust it down
4441         count = uint(MathV1.min(int(count), int(presaleBalance)));
4442 
4443         // final balance check before minting
4444         if(count == 0) revert NoRemainingPresaleMints();
4445 
4446         // edge case: minter wants to buy multiple but we have less supply than their count,
4447         //            but don't want them to get nothing
4448         int remaining = MathV1.max(0, int(collections[0].mintedMax) - MathV1.min(int(collections[0].lockAt), int(collections[0].minted)));
4449         count = uint(MathV1.min(int(count), remaining));
4450         if(count == 0) revert CollectionSoldOut();
4451 
4452         presaleMints[minter] = presaleMints[minter] + count;
4453         mint(minter, recipient, presalePriceInWei, count);
4454     }
4455 
4456     function purchase(uint count) external payable {
4457         purchaseFor(_msgSender(), count);
4458     }
4459 
4460     function purchaseFor(address recipient, uint count) public payable nonReentrant {        
4461         if(presale) revert PublicSaleNotOpen();
4462 
4463         address minter = _msgSender();
4464 
4465         uint mintedMaxPerOwner = collections[0].mintedMaxPerOwner;
4466         if(mintedMaxPerOwner != 0) {            
4467             // reset for presale minters
4468             uint totalMintsAllowed = mintedMaxPerOwner + presaleMints[minter];
4469             if(ownerMints[minter] >= totalMintsAllowed) revert AccountExceedsMaxMints();
4470         }
4471 
4472         // edge case: minter wants to buy multiple but we have less supply than their count,
4473         //            but don't want them to get nothing
4474         int remaining = MathV1.max(0, int(collections[0].mintedMax) - MathV1.min(int(collections[0].lockAt), int(collections[0].minted)));
4475         count = uint(MathV1.min(int(count), remaining));
4476         if(count == 0) revert CollectionSoldOut();
4477 
4478         mint(_msgSender(), recipient, collections[0].priceInWei, count);        
4479     }
4480 
4481     function mint(address minter, address recipient, uint priceInWei, uint count) private {        
4482         if(ownerAddress == address(0x0)) revert NoOwnerAddress();          
4483         if(minter.isContract()) revert CannotPurchaseFromContract();
4484         
4485         if(locked && minter != _admin) revert CollectionLocked();
4486 
4487         uint totalPrice = priceInWei * count;  
4488         if(msg.value < totalPrice) revert InsufficientFundsForPurchase();      
4489 
4490         Collection memory collection = collections[0];        
4491         if(collection.creatorAddress == address(0x0)) revert NoCreatorAddress();      
4492         if(!collection.active && minter != _admin) revert CollectionInactive(); 
4493         if(collection.seed == 0) revert SeedNotSet();
4494 
4495         for(uint i = 0; i < count; i++) {
4496             uint256 nextTokenId = lastTokenId + 1;
4497             int32 seed = int32(int(uint(keccak256(abi.encodePacked(collection.seed, block.number, minter, recipient, nextTokenId)))));        
4498             lastTokenId = nextTokenId;        
4499             tokenSeed[lastTokenId] = seed;        
4500             collections[0].minted = collection.minted + 1;
4501             ownerMints[minter] = ownerMints[minter] + 1;
4502 
4503             _safeMint(recipient, nextTokenId);
4504             emit CollectionMinted(nextTokenId, recipient, collection.minted, collection.priceInWei, seed);
4505 
4506             if(collection.lockAt > 0) {
4507                 if(lastTokenId >= collection.lockAt)
4508                     locked = true;     
4509             }
4510         }
4511 
4512         distributeFunds(totalPrice, collection.creatorAddress);
4513     }
4514 
4515     function distributeFunds(uint priceInWei, address payable creatorAddress) private {
4516         if (msg.value > 0) {
4517             uint overpaid = msg.value - priceInWei;
4518             if (overpaid > 0) {
4519                 payable(_msgSender()).transfer(overpaid);
4520             }
4521 
4522             uint dueToOwner = ownerRoyalty * priceInWei / 100;
4523             uint paidToOwner;  
4524             if (dueToOwner > 0) {                
4525                 ownerAddress.transfer(dueToOwner);
4526                 paidToOwner = dueToOwner;
4527             }
4528 
4529             uint dueToCreator = priceInWei - paidToOwner;
4530             uint paidToCreator;
4531             if (dueToCreator > 0) {                
4532                 creatorAddress.transfer(dueToCreator);
4533                 paidToCreator = dueToCreator;
4534             }
4535 
4536             if(priceInWei - paidToOwner - paidToCreator != 0) {
4537                 revert InvalidFundsDistribution();           
4538             }
4539         }
4540     }   
4541     
4542     function ownsToken(address owner, uint tokenId) public view returns (bool) {
4543         for(uint i = 0; i < balanceOf(owner); i++) {
4544             if(tokenId == tokenOfOwnerByIndex(owner, i)) {
4545                 return true;
4546             }            
4547         }
4548         return false;
4549     }  
4550 
4551     /**
4552     * @dev See {IERC721Metadata-tokenURI}.
4553     */
4554     function tokenURI(uint256 tokenId) public view override returns (string memory) {
4555         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
4556         Collection memory collection = collections[0];
4557         string memory baseURI = collection.baseTokenUri;
4558         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId))) : "";
4559     }
4560 
4561     function setRenderer(address renderer) external {
4562         if(_msgSender() != _admin) revert AdminOnly();
4563         collections[0]._renderer = renderer;
4564     }
4565 
4566     /**
4567      * @notice Retrieve's an artwork's attributes, given a token ID.
4568      */
4569     function getAttributes(uint tokenId) external view returns (string memory attributes) {
4570         if(_msgSender() != _admin && !ownsToken(_msgSender(), tokenId)) revert RenderDisallowed();
4571         return IAttributes(collections[0]._renderer).getAttributes(tokenSeed[tokenId]);
4572     }
4573 
4574     /**
4575      * @notice Begins rendering an artwork given a token ID, and continuation arguments, which must be owned by the caller.
4576      */
4577     function _render(uint tokenId, IRenderer.RenderArgs memory args) private view returns (IRenderer.RenderArgs memory results) {
4578         if(_msgSender() != _admin && !ownsToken(_msgSender(), tokenId)) revert RenderDisallowed();
4579         if(args.seed != tokenSeed[tokenId]) revert InvalidSeed();  
4580         return IRenderer(collections[0]._renderer).render(args);
4581     }
4582 
4583     /**
4584      * @notice Continues rendering an artwork given a token ID and previous arguments. Token must be owned by the caller.
4585      */
4586     function render(uint tokenId, IRenderer.RenderArgs memory args) external view returns (IRenderer.RenderArgs memory results) {        
4587         return _render(tokenId, args);
4588     }
4589 
4590     /**
4591      * @notice Begins rendering an artwork given a token ID. Token must be owned by the caller.
4592      */
4593     function beginRender(uint tokenId) external view returns (IRenderer.RenderArgs memory results) {        
4594         uint32[20480] memory buffer;
4595         RandomV1.PRNG memory prng;
4596         return _render(tokenId, IRenderer.RenderArgs(0, 0, tokenSeed[tokenId], buffer, prng));
4597     }
4598 }
4599 
4600 
4601 // File contracts/V1/TypesV1.sol
4602 
4603 // License: UNLICENSED
4604 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
4605 
4606 pragma solidity ^0.8.0;
4607 
4608 library TypesV1 {
4609     /**
4610      * @dev Represents a point in two-dimensional space.
4611      */
4612     struct Point2D {
4613         int256 x;
4614         int256 y;
4615     }
4616 
4617     /**
4618      * @dev Represents a chunked rendering region.
4619      */
4620     struct Chunk2D {
4621         uint16 index;
4622         uint16 width;
4623         uint16 height;
4624         uint16 chunkWidth;
4625         uint16 chunkHeight;
4626         uint32 startX;
4627         uint32 startY;
4628     }
4629 }
4630 
4631 
4632 // File contracts/V1/GeometryV1.sol
4633 
4634 // License: UNLICENSED
4635 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
4636 
4637 pragma solidity ^0.8.0;
4638 library GeometryV1 {
4639         
4640     struct Triangle2D {
4641         TypesV1.Point2D v0;
4642         TypesV1.Point2D v1;
4643         TypesV1.Point2D v2;
4644         uint32 strokeColor;
4645         uint32 fillColor;
4646         TypesV1.Chunk2D chunk;
4647     }
4648 
4649     struct Line2D {
4650         TypesV1.Point2D v0;
4651         TypesV1.Point2D v1;
4652         uint32 color;
4653         TypesV1.Chunk2D chunk;
4654     }
4655 
4656     struct Polygon2D {
4657         TypesV1.Point2D[40960] vertices;
4658         uint32 vertexCount;
4659         uint32 strokeColor;
4660         uint32 fillColor;
4661         TypesV1.Chunk2D chunk;
4662     }
4663 
4664     function edge(
4665         TypesV1.Point2D memory a,
4666         TypesV1.Point2D memory b,
4667         TypesV1.Point2D memory c
4668     ) external pure returns (int256) {
4669         return ((b.y - a.y) * (c.x - a.x)) - ((b.x - a.x) * (c.y - a.y));
4670     }
4671 
4672     function getBoundingBox(TypesV1.Point2D[] memory vertices)
4673         external
4674         pure
4675         returns (TypesV1.Point2D memory tl, TypesV1.Point2D memory br)
4676     {
4677         int256 xMax = vertices[0].x;
4678         int256 xMin = vertices[0].x;
4679         int256 yMax = vertices[0].y;
4680         int256 yMin = vertices[0].y;
4681 
4682         for (uint256 i; i < vertices.length; i++) {
4683             TypesV1.Point2D memory p = vertices[i];
4684 
4685             if (p.x > xMax) xMax = p.x;
4686             if (p.x < xMin) xMin = p.x;
4687             if (p.y > yMax) yMax = p.y;
4688             if (p.y < yMin) yMin = p.y;
4689         }
4690 
4691         return (TypesV1.Point2D(xMin, yMin), TypesV1.Point2D(xMax, yMax));
4692     }
4693 }
4694 
4695 
4696 // File contracts/V1/LCG64.sol
4697 
4698 // License: UNLICENSED
4699 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
4700 
4701 pragma solidity ^0.8.0;
4702 /*
4703     An implementation of a Linear Congruential Generator in Q31.Q32 format.
4704     Adapted from the algorithm used by p5js, which is licensed under the LGPL v2.1.
4705 
4706     See: https://github.com/processing/p5.js/blob/374acfb44588bfd565c54d61264df197d798d121/src/math/noise.js
4707          https://github.com/processing/p5.js/blob/main/license.txt
4708          
4709     This adaptation was necessary to ensure generative art in p5js produces identical results for noise values in Solidity.
4710 
4711     THIRD PARTY NOTICES:
4712     ====================
4713 
4714                         GNU LESSER GENERAL PUBLIC LICENSE
4715                        Version 2.1, February 1999
4716 
4717  Copyright (C) 1991, 1999 Free Software Foundation, Inc.
4718  51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
4719  Everyone is permitted to copy and distribute verbatim copies
4720  of this license document, but changing it is not allowed.
4721 
4722 (This is the first released version of the Lesser GPL.  It also counts
4723  as the successor of the GNU Library Public License, version 2, hence
4724  the version number 2.1.)
4725 
4726                             Preamble
4727 
4728   The licenses for most software are designed to take away your
4729 freedom to share and change it.  By contrast, the GNU General Public
4730 Licenses are intended to guarantee your freedom to share and change
4731 free software--to make sure the software is free for all its users.
4732 
4733   This license, the Lesser General Public License, applies to some
4734 specially designated software packages--typically libraries--of the
4735 Free Software Foundation and other authors who decide to use it.  You
4736 can use it too, but we suggest you first think carefully about whether
4737 this license or the ordinary General Public License is the better
4738 strategy to use in any particular case, based on the explanations below.
4739 
4740   When we speak of free software, we are referring to freedom of use,
4741 not price.  Our General Public Licenses are designed to make sure that
4742 you have the freedom to distribute copies of free software (and charge
4743 for this service if you wish); that you receive source code or can get
4744 it if you want it; that you can change the software and use pieces of
4745 it in new free programs; and that you are informed that you can do
4746 these things.
4747 
4748   To protect your rights, we need to make restrictions that forbid
4749 distributors to deny you these rights or to ask you to surrender these
4750 rights.  These restrictions translate to certain responsibilities for
4751 you if you distribute copies of the library or if you modify it.
4752 
4753   For example, if you distribute copies of the library, whether gratis
4754 or for a fee, you must give the recipients all the rights that we gave
4755 you.  You must make sure that they, too, receive or can get the source
4756 code.  If you link other code with the library, you must provide
4757 complete object files to the recipients, so that they can relink them
4758 with the library after making changes to the library and recompiling
4759 it.  And you must show them these terms so they know their rights.
4760 
4761   We protect your rights with a two-step method: (1) we copyright the
4762 library, and (2) we offer you this license, which gives you legal
4763 permission to copy, distribute and/or modify the library.
4764 
4765   To protect each distributor, we want to make it very clear that
4766 there is no warranty for the free library.  Also, if the library is
4767 modified by someone else and passed on, the recipients should know
4768 that what they have is not the original version, so that the original
4769 author's reputation will not be affected by problems that might be
4770 introduced by others.
4771 
4772   Finally, software patents pose a constant threat to the existence of
4773 any free program.  We wish to make sure that a company cannot
4774 effectively restrict the users of a free program by obtaining a
4775 restrictive license from a patent holder.  Therefore, we insist that
4776 any patent license obtained for a version of the library must be
4777 consistent with the full freedom of use specified in this license.
4778 
4779   Most GNU software, including some libraries, is covered by the
4780 ordinary GNU General Public License.  This license, the GNU Lesser
4781 General Public License, applies to certain designated libraries, and
4782 is quite different from the ordinary General Public License.  We use
4783 this license for certain libraries in order to permit linking those
4784 libraries into non-free programs.
4785 
4786   When a program is linked with a library, whether statically or using
4787 a shared library, the combination of the two is legally speaking a
4788 combined work, a derivative of the original library.  The ordinary
4789 General Public License therefore permits such linking only if the
4790 entire combination fits its criteria of freedom.  The Lesser General
4791 Public License permits more lax criteria for linking other code with
4792 the library.
4793 
4794   We call this license the "Lesser" General Public License because it
4795 does Less to protect the user's freedom than the ordinary General
4796 Public License.  It also provides other free software developers Less
4797 of an advantage over competing non-free programs.  These disadvantages
4798 are the reason we use the ordinary General Public License for many
4799 libraries.  However, the Lesser license provides advantages in certain
4800 special circumstances.
4801 
4802   For example, on rare occasions, there may be a special need to
4803 encourage the widest possible use of a certain library, so that it becomes
4804 a de-facto standard.  To achieve this, non-free programs must be
4805 allowed to use the library.  A more frequent case is that a free
4806 library does the same job as widely used non-free libraries.  In this
4807 case, there is little to gain by limiting the free library to free
4808 software only, so we use the Lesser General Public License.
4809 
4810   In other cases, permission to use a particular library in non-free
4811 programs enables a greater number of people to use a large body of
4812 free software.  For example, permission to use the GNU C Library in
4813 non-free programs enables many more people to use the whole GNU
4814 operating system, as well as its variant, the GNU/Linux operating
4815 system.
4816 
4817   Although the Lesser General Public License is Less protective of the
4818 users' freedom, it does ensure that the user of a program that is
4819 linked with the Library has the freedom and the wherewithal to run
4820 that program using a modified version of the Library.
4821 
4822   The precise terms and conditions for copying, distribution and
4823 modification follow.  Pay close attention to the difference between a
4824 "work based on the library" and a "work that uses the library".  The
4825 former contains code derived from the library, whereas the latter must
4826 be combined with the library in order to run.
4827 
4828                   GNU LESSER GENERAL PUBLIC LICENSE
4829    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
4830 
4831   0. This License Agreement applies to any software library or other
4832 program which contains a notice placed by the copyright holder or
4833 other authorized party saying it may be distributed under the terms of
4834 this Lesser General Public License (also called "this License").
4835 Each licensee is addressed as "you".
4836 
4837   A "library" means a collection of software functions and/or data
4838 prepared so as to be conveniently linked with application programs
4839 (which use some of those functions and data) to form executables.
4840 
4841   The "Library", below, refers to any such software library or work
4842 which has been distributed under these terms.  A "work based on the
4843 Library" means either the Library or any derivative work under
4844 copyright law: that is to say, a work containing the Library or a
4845 portion of it, either verbatim or with modifications and/or translated
4846 straightforwardly into another language.  (Hereinafter, translation is
4847 included without limitation in the term "modification".)
4848 
4849   "Source code" for a work means the preferred form of the work for
4850 making modifications to it.  For a library, complete source code means
4851 all the source code for all modules it contains, plus any associated
4852 interface definition files, plus the scripts used to control compilation
4853 and installation of the library.
4854 
4855   Activities other than copying, distribution and modification are not
4856 covered by this License; they are outside its scope.  The act of
4857 running a program using the Library is not restricted, and output from
4858 such a program is covered only if its contents constitute a work based
4859 on the Library (independent of the use of the Library in a tool for
4860 writing it).  Whether that is true depends on what the Library does
4861 and what the program that uses the Library does.
4862 
4863   1. You may copy and distribute verbatim copies of the Library's
4864 complete source code as you receive it, in any medium, provided that
4865 you conspicuously and appropriately publish on each copy an
4866 appropriate copyright notice and disclaimer of warranty; keep intact
4867 all the notices that refer to this License and to the absence of any
4868 warranty; and distribute a copy of this License along with the
4869 Library.
4870 
4871   You may charge a fee for the physical act of transferring a copy,
4872 and you may at your option offer warranty protection in exchange for a
4873 fee.
4874 
4875   2. You may modify your copy or copies of the Library or any portion
4876 of it, thus forming a work based on the Library, and copy and
4877 distribute such modifications or work under the terms of Section 1
4878 above, provided that you also meet all of these conditions:
4879 
4880     a) The modified work must itself be a software library.
4881 
4882     b) You must cause the files modified to carry prominent notices
4883     stating that you changed the files and the date of any change.
4884 
4885     c) You must cause the whole of the work to be licensed at no
4886     charge to all third parties under the terms of this License.
4887 
4888     d) If a facility in the modified Library refers to a function or a
4889     table of data to be supplied by an application program that uses
4890     the facility, other than as an argument passed when the facility
4891     is invoked, then you must make a good faith effort to ensure that,
4892     in the event an application does not supply such function or
4893     table, the facility still operates, and performs whatever part of
4894     its purpose remains meaningful.
4895 
4896     (For example, a function in a library to compute square roots has
4897     a purpose that is entirely well-defined independent of the
4898     application.  Therefore, Subsection 2d requires that any
4899     application-supplied function or table used by this function must
4900     be optional: if the application does not supply it, the square
4901     root function must still compute square roots.)
4902 
4903 These requirements apply to the modified work as a whole.  If
4904 identifiable sections of that work are not derived from the Library,
4905 and can be reasonably considered independent and separate works in
4906 themselves, then this License, and its terms, do not apply to those
4907 sections when you distribute them as separate works.  But when you
4908 distribute the same sections as part of a whole which is a work based
4909 on the Library, the distribution of the whole must be on the terms of
4910 this License, whose permissions for other licensees extend to the
4911 entire whole, and thus to each and every part regardless of who wrote
4912 it.
4913 
4914 Thus, it is not the intent of this section to claim rights or contest
4915 your rights to work written entirely by you; rather, the intent is to
4916 exercise the right to control the distribution of derivative or
4917 collective works based on the Library.
4918 
4919 In addition, mere aggregation of another work not based on the Library
4920 with the Library (or with a work based on the Library) on a volume of
4921 a storage or distribution medium does not bring the other work under
4922 the scope of this License.
4923 
4924   3. You may opt to apply the terms of the ordinary GNU General Public
4925 License instead of this License to a given copy of the Library.  To do
4926 this, you must alter all the notices that refer to this License, so
4927 that they refer to the ordinary GNU General Public License, version 2,
4928 instead of to this License.  (If a newer version than version 2 of the
4929 ordinary GNU General Public License has appeared, then you can specify
4930 that version instead if you wish.)  Do not make any other change in
4931 these notices.
4932 
4933   Once this change is made in a given copy, it is irreversible for
4934 that copy, so the ordinary GNU General Public License applies to all
4935 subsequent copies and derivative works made from that copy.
4936 
4937   This option is useful when you wish to copy part of the code of
4938 the Library into a program that is not a library.
4939 
4940   4. You may copy and distribute the Library (or a portion or
4941 derivative of it, under Section 2) in object code or executable form
4942 under the terms of Sections 1 and 2 above provided that you accompany
4943 it with the complete corresponding machine-readable source code, which
4944 must be distributed under the terms of Sections 1 and 2 above on a
4945 medium customarily used for software interchange.
4946 
4947   If distribution of object code is made by offering access to copy
4948 from a designated place, then offering equivalent access to copy the
4949 source code from the same place satisfies the requirement to
4950 distribute the source code, even though third parties are not
4951 compelled to copy the source along with the object code.
4952 
4953   5. A program that contains no derivative of any portion of the
4954 Library, but is designed to work with the Library by being compiled or
4955 linked with it, is called a "work that uses the Library".  Such a
4956 work, in isolation, is not a derivative work of the Library, and
4957 therefore falls outside the scope of this License.
4958 
4959   However, linking a "work that uses the Library" with the Library
4960 creates an executable that is a derivative of the Library (because it
4961 contains portions of the Library), rather than a "work that uses the
4962 library".  The executable is therefore covered by this License.
4963 Section 6 states terms for distribution of such executables.
4964 
4965   When a "work that uses the Library" uses material from a header file
4966 that is part of the Library, the object code for the work may be a
4967 derivative work of the Library even though the source code is not.
4968 Whether this is true is especially significant if the work can be
4969 linked without the Library, or if the work is itself a library.  The
4970 threshold for this to be true is not precisely defined by law.
4971 
4972   If such an object file uses only numerical parameters, data
4973 structure layouts and accessors, and small macros and small inline
4974 functions (ten lines or less in length), then the use of the object
4975 file is unrestricted, regardless of whether it is legally a derivative
4976 work.  (Executables containing this object code plus portions of the
4977 Library will still fall under Section 6.)
4978 
4979   Otherwise, if the work is a derivative of the Library, you may
4980 distribute the object code for the work under the terms of Section 6.
4981 Any executables containing that work also fall under Section 6,
4982 whether or not they are linked directly with the Library itself.
4983 
4984   6. As an exception to the Sections above, you may also combine or
4985 link a "work that uses the Library" with the Library to produce a
4986 work containing portions of the Library, and distribute that work
4987 under terms of your choice, provided that the terms permit
4988 modification of the work for the customer's own use and reverse
4989 engineering for debugging such modifications.
4990 
4991   You must give prominent notice with each copy of the work that the
4992 Library is used in it and that the Library and its use are covered by
4993 this License.  You must supply a copy of this License.  If the work
4994 during execution displays copyright notices, you must include the
4995 copyright notice for the Library among them, as well as a reference
4996 directing the user to the copy of this License.  Also, you must do one
4997 of these things:
4998 
4999     a) Accompany the work with the complete corresponding
5000     machine-readable source code for the Library including whatever
5001     changes were used in the work (which must be distributed under
5002     Sections 1 and 2 above); and, if the work is an executable linked
5003     with the Library, with the complete machine-readable "work that
5004     uses the Library", as object code and/or source code, so that the
5005     user can modify the Library and then relink to produce a modified
5006     executable containing the modified Library.  (It is understood
5007     that the user who changes the contents of definitions files in the
5008     Library will not necessarily be able to recompile the application
5009     to use the modified definitions.)
5010 
5011     b) Use a suitable shared library mechanism for linking with the
5012     Library.  A suitable mechanism is one that (1) uses at run time a
5013     copy of the library already present on the user's computer system,
5014     rather than copying library functions into the executable, and (2)
5015     will operate properly with a modified version of the library, if
5016     the user installs one, as long as the modified version is
5017     interface-compatible with the version that the work was made with.
5018 
5019     c) Accompany the work with a written offer, valid for at
5020     least three years, to give the same user the materials
5021     specified in Subsection 6a, above, for a charge no more
5022     than the cost of performing this distribution.
5023 
5024     d) If distribution of the work is made by offering access to copy
5025     from a designated place, offer equivalent access to copy the above
5026     specified materials from the same place.
5027 
5028     e) Verify that the user has already received a copy of these
5029     materials or that you have already sent this user a copy.
5030 
5031   For an executable, the required form of the "work that uses the
5032 Library" must include any data and utility programs needed for
5033 reproducing the executable from it.  However, as a special exception,
5034 the materials to be distributed need not include anything that is
5035 normally distributed (in either source or binary form) with the major
5036 components (compiler, kernel, and so on) of the operating system on
5037 which the executable runs, unless that component itself accompanies
5038 the executable.
5039 
5040   It may happen that this requirement contradicts the license
5041 restrictions of other proprietary libraries that do not normally
5042 accompany the operating system.  Such a contradiction means you cannot
5043 use both them and the Library together in an executable that you
5044 distribute.
5045 
5046   7. You may place library facilities that are a work based on the
5047 Library side-by-side in a single library together with other library
5048 facilities not covered by this License, and distribute such a combined
5049 library, provided that the separate distribution of the work based on
5050 the Library and of the other library facilities is otherwise
5051 permitted, and provided that you do these two things:
5052 
5053     a) Accompany the combined library with a copy of the same work
5054     based on the Library, uncombined with any other library
5055     facilities.  This must be distributed under the terms of the
5056     Sections above.
5057 
5058     b) Give prominent notice with the combined library of the fact
5059     that part of it is a work based on the Library, and explaining
5060     where to find the accompanying uncombined form of the same work.
5061 
5062   8. You may not copy, modify, sublicense, link with, or distribute
5063 the Library except as expressly provided under this License.  Any
5064 attempt otherwise to copy, modify, sublicense, link with, or
5065 distribute the Library is void, and will automatically terminate your
5066 rights under this License.  However, parties who have received copies,
5067 or rights, from you under this License will not have their licenses
5068 terminated so long as such parties remain in full compliance.
5069 
5070   9. You are not required to accept this License, since you have not
5071 signed it.  However, nothing else grants you permission to modify or
5072 distribute the Library or its derivative works.  These actions are
5073 prohibited by law if you do not accept this License.  Therefore, by
5074 modifying or distributing the Library (or any work based on the
5075 Library), you indicate your acceptance of this License to do so, and
5076 all its terms and conditions for copying, distributing or modifying
5077 the Library or works based on it.
5078 
5079   10. Each time you redistribute the Library (or any work based on the
5080 Library), the recipient automatically receives a license from the
5081 original licensor to copy, distribute, link with or modify the Library
5082 subject to these terms and conditions.  You may not impose any further
5083 restrictions on the recipients' exercise of the rights granted herein.
5084 You are not responsible for enforcing compliance by third parties with
5085 this License.
5086 
5087   11. If, as a consequence of a court judgment or allegation of patent
5088 infringement or for any other reason (not limited to patent issues),
5089 conditions are imposed on you (whether by court order, agreement or
5090 otherwise) that contradict the conditions of this License, they do not
5091 excuse you from the conditions of this License.  If you cannot
5092 distribute so as to satisfy simultaneously your obligations under this
5093 License and any other pertinent obligations, then as a consequence you
5094 may not distribute the Library at all.  For example, if a patent
5095 license would not permit royalty-free redistribution of the Library by
5096 all those who receive copies directly or indirectly through you, then
5097 the only way you could satisfy both it and this License would be to
5098 refrain entirely from distribution of the Library.
5099 
5100 If any portion of this section is held invalid or unenforceable under any
5101 particular circumstance, the balance of the section is intended to apply,
5102 and the section as a whole is intended to apply in other circumstances.
5103 
5104 It is not the purpose of this section to induce you to infringe any
5105 patents or other property right claims or to contest validity of any
5106 such claims; this section has the sole purpose of protecting the
5107 integrity of the free software distribution system which is
5108 implemented by public license practices.  Many people have made
5109 generous contributions to the wide range of software distributed
5110 through that system in reliance on consistent application of that
5111 system; it is up to the author/donor to decide if he or she is willing
5112 to distribute software through any other system and a licensee cannot
5113 impose that choice.
5114 
5115 This section is intended to make thoroughly clear what is believed to
5116 be a consequence of the rest of this License.
5117 
5118   12. If the distribution and/or use of the Library is restricted in
5119 certain countries either by patents or by copyrighted interfaces, the
5120 original copyright holder who places the Library under this License may add
5121 an explicit geographical distribution limitation excluding those countries,
5122 so that distribution is permitted only in or among countries not thus
5123 excluded.  In such case, this License incorporates the limitation as if
5124 written in the body of this License.
5125 
5126   13. The Free Software Foundation may publish revised and/or new
5127 versions of the Lesser General Public License from time to time.
5128 Such new versions will be similar in spirit to the present version,
5129 but may differ in detail to address new problems or concerns.
5130 
5131 Each version is given a distinguishing version number.  If the Library
5132 specifies a version number of this License which applies to it and
5133 "any later version", you have the option of following the terms and
5134 conditions either of that version or of any later version published by
5135 the Free Software Foundation.  If the Library does not specify a
5136 license version number, you may choose any version ever published by
5137 the Free Software Foundation.
5138 
5139   14. If you wish to incorporate parts of the Library into other free
5140 programs whose distribution conditions are incompatible with these,
5141 write to the author to ask for permission.  For software which is
5142 copyrighted by the Free Software Foundation, write to the Free
5143 Software Foundation; we sometimes make exceptions for this.  Our
5144 decision will be guided by the two goals of preserving the free status
5145 of all derivatives of our free software and of promoting the sharing
5146 and reuse of software generally.
5147 
5148                             NO WARRANTY
5149 
5150   15. BECAUSE THE LIBRARY IS LICENSED FREE OF CHARGE, THERE IS NO
5151 WARRANTY FOR THE LIBRARY, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
5152 EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR
5153 OTHER PARTIES PROVIDE THE LIBRARY "AS IS" WITHOUT WARRANTY OF ANY
5154 KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE
5155 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
5156 PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
5157 LIBRARY IS WITH YOU.  SHOULD THE LIBRARY PROVE DEFECTIVE, YOU ASSUME
5158 THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
5159 
5160   16. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN
5161 WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY
5162 AND/OR REDISTRIBUTE THE LIBRARY AS PERMITTED ABOVE, BE LIABLE TO YOU
5163 FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR
5164 CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
5165 LIBRARY (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
5166 RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
5167 FAILURE OF THE LIBRARY TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
5168 SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
5169 DAMAGES.
5170 
5171                      END OF TERMS AND CONDITIONS
5172 */
5173 
5174 library LCG64 {
5175     uint64 internal constant M = 4294967296;
5176     uint32 internal constant A = 1664525;
5177     uint32 internal constant C = 1013904223;
5178 
5179     function next(uint64 z) internal pure returns(uint64, int64) {                
5180                 
5181         uint256 r = uint(A) * uint(z) + uint(C);            
5182         uint64 g = uint64(r % M);           
5183         
5184         int lz = Trig256.log_256(int64(g) * int(Fix64V1.ONE));
5185         int lm = Trig256.log_256(int64(M) * int(Fix64V1.ONE));
5186         int64 lml = Fix64V1.sub(int64(lz), int64(lm));
5187         int64 v = Trig256.exp(lml);
5188 
5189         return (g, v);
5190     }
5191 }
5192 
5193 
5194 // File contracts/V1/NoiseV1.sol
5195 
5196 // License: UNLICENSED
5197 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
5198 
5199 pragma solidity ^0.8.0;
5200 /*
5201     An implementation of fixed-point noise in Q31.Q32 format.
5202     Adapted from the algorithm used by p5js, which is licensed under the LGPL v2.1.
5203 
5204     See: https://github.com/processing/p5.js/blob/374acfb44588bfd565c54d61264df197d798d121/src/math/noise.js
5205          https://github.com/processing/p5.js/blob/main/license.txt
5206 
5207     This adaptation was necessary to ensure generative art in p5js produces identical results for noise values in Solidity.
5208 
5209     THIRD PARTY NOTICES:
5210     ====================
5211 
5212                     GNU LESSER GENERAL PUBLIC LICENSE
5213                        Version 2.1, February 1999
5214 
5215  Copyright (C) 1991, 1999 Free Software Foundation, Inc.
5216  51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
5217  Everyone is permitted to copy and distribute verbatim copies
5218  of this license document, but changing it is not allowed.
5219 
5220 (This is the first released version of the Lesser GPL.  It also counts
5221  as the successor of the GNU Library Public License, version 2, hence
5222  the version number 2.1.)
5223 
5224                             Preamble
5225 
5226   The licenses for most software are designed to take away your
5227 freedom to share and change it.  By contrast, the GNU General Public
5228 Licenses are intended to guarantee your freedom to share and change
5229 free software--to make sure the software is free for all its users.
5230 
5231   This license, the Lesser General Public License, applies to some
5232 specially designated software packages--typically libraries--of the
5233 Free Software Foundation and other authors who decide to use it.  You
5234 can use it too, but we suggest you first think carefully about whether
5235 this license or the ordinary General Public License is the better
5236 strategy to use in any particular case, based on the explanations below.
5237 
5238   When we speak of free software, we are referring to freedom of use,
5239 not price.  Our General Public Licenses are designed to make sure that
5240 you have the freedom to distribute copies of free software (and charge
5241 for this service if you wish); that you receive source code or can get
5242 it if you want it; that you can change the software and use pieces of
5243 it in new free programs; and that you are informed that you can do
5244 these things.
5245 
5246   To protect your rights, we need to make restrictions that forbid
5247 distributors to deny you these rights or to ask you to surrender these
5248 rights.  These restrictions translate to certain responsibilities for
5249 you if you distribute copies of the library or if you modify it.
5250 
5251   For example, if you distribute copies of the library, whether gratis
5252 or for a fee, you must give the recipients all the rights that we gave
5253 you.  You must make sure that they, too, receive or can get the source
5254 code.  If you link other code with the library, you must provide
5255 complete object files to the recipients, so that they can relink them
5256 with the library after making changes to the library and recompiling
5257 it.  And you must show them these terms so they know their rights.
5258 
5259   We protect your rights with a two-step method: (1) we copyright the
5260 library, and (2) we offer you this license, which gives you legal
5261 permission to copy, distribute and/or modify the library.
5262 
5263   To protect each distributor, we want to make it very clear that
5264 there is no warranty for the free library.  Also, if the library is
5265 modified by someone else and passed on, the recipients should know
5266 that what they have is not the original version, so that the original
5267 author's reputation will not be affected by problems that might be
5268 introduced by others.
5269 
5270   Finally, software patents pose a constant threat to the existence of
5271 any free program.  We wish to make sure that a company cannot
5272 effectively restrict the users of a free program by obtaining a
5273 restrictive license from a patent holder.  Therefore, we insist that
5274 any patent license obtained for a version of the library must be
5275 consistent with the full freedom of use specified in this license.
5276 
5277   Most GNU software, including some libraries, is covered by the
5278 ordinary GNU General Public License.  This license, the GNU Lesser
5279 General Public License, applies to certain designated libraries, and
5280 is quite different from the ordinary General Public License.  We use
5281 this license for certain libraries in order to permit linking those
5282 libraries into non-free programs.
5283 
5284   When a program is linked with a library, whether statically or using
5285 a shared library, the combination of the two is legally speaking a
5286 combined work, a derivative of the original library.  The ordinary
5287 General Public License therefore permits such linking only if the
5288 entire combination fits its criteria of freedom.  The Lesser General
5289 Public License permits more lax criteria for linking other code with
5290 the library.
5291 
5292   We call this license the "Lesser" General Public License because it
5293 does Less to protect the user's freedom than the ordinary General
5294 Public License.  It also provides other free software developers Less
5295 of an advantage over competing non-free programs.  These disadvantages
5296 are the reason we use the ordinary General Public License for many
5297 libraries.  However, the Lesser license provides advantages in certain
5298 special circumstances.
5299 
5300   For example, on rare occasions, there may be a special need to
5301 encourage the widest possible use of a certain library, so that it becomes
5302 a de-facto standard.  To achieve this, non-free programs must be
5303 allowed to use the library.  A more frequent case is that a free
5304 library does the same job as widely used non-free libraries.  In this
5305 case, there is little to gain by limiting the free library to free
5306 software only, so we use the Lesser General Public License.
5307 
5308   In other cases, permission to use a particular library in non-free
5309 programs enables a greater number of people to use a large body of
5310 free software.  For example, permission to use the GNU C Library in
5311 non-free programs enables many more people to use the whole GNU
5312 operating system, as well as its variant, the GNU/Linux operating
5313 system.
5314 
5315   Although the Lesser General Public License is Less protective of the
5316 users' freedom, it does ensure that the user of a program that is
5317 linked with the Library has the freedom and the wherewithal to run
5318 that program using a modified version of the Library.
5319 
5320   The precise terms and conditions for copying, distribution and
5321 modification follow.  Pay close attention to the difference between a
5322 "work based on the library" and a "work that uses the library".  The
5323 former contains code derived from the library, whereas the latter must
5324 be combined with the library in order to run.
5325 
5326                   GNU LESSER GENERAL PUBLIC LICENSE
5327    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
5328 
5329   0. This License Agreement applies to any software library or other
5330 program which contains a notice placed by the copyright holder or
5331 other authorized party saying it may be distributed under the terms of
5332 this Lesser General Public License (also called "this License").
5333 Each licensee is addressed as "you".
5334 
5335   A "library" means a collection of software functions and/or data
5336 prepared so as to be conveniently linked with application programs
5337 (which use some of those functions and data) to form executables.
5338 
5339   The "Library", below, refers to any such software library or work
5340 which has been distributed under these terms.  A "work based on the
5341 Library" means either the Library or any derivative work under
5342 copyright law: that is to say, a work containing the Library or a
5343 portion of it, either verbatim or with modifications and/or translated
5344 straightforwardly into another language.  (Hereinafter, translation is
5345 included without limitation in the term "modification".)
5346 
5347   "Source code" for a work means the preferred form of the work for
5348 making modifications to it.  For a library, complete source code means
5349 all the source code for all modules it contains, plus any associated
5350 interface definition files, plus the scripts used to control compilation
5351 and installation of the library.
5352 
5353   Activities other than copying, distribution and modification are not
5354 covered by this License; they are outside its scope.  The act of
5355 running a program using the Library is not restricted, and output from
5356 such a program is covered only if its contents constitute a work based
5357 on the Library (independent of the use of the Library in a tool for
5358 writing it).  Whether that is true depends on what the Library does
5359 and what the program that uses the Library does.
5360 
5361   1. You may copy and distribute verbatim copies of the Library's
5362 complete source code as you receive it, in any medium, provided that
5363 you conspicuously and appropriately publish on each copy an
5364 appropriate copyright notice and disclaimer of warranty; keep intact
5365 all the notices that refer to this License and to the absence of any
5366 warranty; and distribute a copy of this License along with the
5367 Library.
5368 
5369   You may charge a fee for the physical act of transferring a copy,
5370 and you may at your option offer warranty protection in exchange for a
5371 fee.
5372 
5373   2. You may modify your copy or copies of the Library or any portion
5374 of it, thus forming a work based on the Library, and copy and
5375 distribute such modifications or work under the terms of Section 1
5376 above, provided that you also meet all of these conditions:
5377 
5378     a) The modified work must itself be a software library.
5379 
5380     b) You must cause the files modified to carry prominent notices
5381     stating that you changed the files and the date of any change.
5382 
5383     c) You must cause the whole of the work to be licensed at no
5384     charge to all third parties under the terms of this License.
5385 
5386     d) If a facility in the modified Library refers to a function or a
5387     table of data to be supplied by an application program that uses
5388     the facility, other than as an argument passed when the facility
5389     is invoked, then you must make a good faith effort to ensure that,
5390     in the event an application does not supply such function or
5391     table, the facility still operates, and performs whatever part of
5392     its purpose remains meaningful.
5393 
5394     (For example, a function in a library to compute square roots has
5395     a purpose that is entirely well-defined independent of the
5396     application.  Therefore, Subsection 2d requires that any
5397     application-supplied function or table used by this function must
5398     be optional: if the application does not supply it, the square
5399     root function must still compute square roots.)
5400 
5401 These requirements apply to the modified work as a whole.  If
5402 identifiable sections of that work are not derived from the Library,
5403 and can be reasonably considered independent and separate works in
5404 themselves, then this License, and its terms, do not apply to those
5405 sections when you distribute them as separate works.  But when you
5406 distribute the same sections as part of a whole which is a work based
5407 on the Library, the distribution of the whole must be on the terms of
5408 this License, whose permissions for other licensees extend to the
5409 entire whole, and thus to each and every part regardless of who wrote
5410 it.
5411 
5412 Thus, it is not the intent of this section to claim rights or contest
5413 your rights to work written entirely by you; rather, the intent is to
5414 exercise the right to control the distribution of derivative or
5415 collective works based on the Library.
5416 
5417 In addition, mere aggregation of another work not based on the Library
5418 with the Library (or with a work based on the Library) on a volume of
5419 a storage or distribution medium does not bring the other work under
5420 the scope of this License.
5421 
5422   3. You may opt to apply the terms of the ordinary GNU General Public
5423 License instead of this License to a given copy of the Library.  To do
5424 this, you must alter all the notices that refer to this License, so
5425 that they refer to the ordinary GNU General Public License, version 2,
5426 instead of to this License.  (If a newer version than version 2 of the
5427 ordinary GNU General Public License has appeared, then you can specify
5428 that version instead if you wish.)  Do not make any other change in
5429 these notices.
5430 
5431   Once this change is made in a given copy, it is irreversible for
5432 that copy, so the ordinary GNU General Public License applies to all
5433 subsequent copies and derivative works made from that copy.
5434 
5435   This option is useful when you wish to copy part of the code of
5436 the Library into a program that is not a library.
5437 
5438   4. You may copy and distribute the Library (or a portion or
5439 derivative of it, under Section 2) in object code or executable form
5440 under the terms of Sections 1 and 2 above provided that you accompany
5441 it with the complete corresponding machine-readable source code, which
5442 must be distributed under the terms of Sections 1 and 2 above on a
5443 medium customarily used for software interchange.
5444 
5445   If distribution of object code is made by offering access to copy
5446 from a designated place, then offering equivalent access to copy the
5447 source code from the same place satisfies the requirement to
5448 distribute the source code, even though third parties are not
5449 compelled to copy the source along with the object code.
5450 
5451   5. A program that contains no derivative of any portion of the
5452 Library, but is designed to work with the Library by being compiled or
5453 linked with it, is called a "work that uses the Library".  Such a
5454 work, in isolation, is not a derivative work of the Library, and
5455 therefore falls outside the scope of this License.
5456 
5457   However, linking a "work that uses the Library" with the Library
5458 creates an executable that is a derivative of the Library (because it
5459 contains portions of the Library), rather than a "work that uses the
5460 library".  The executable is therefore covered by this License.
5461 Section 6 states terms for distribution of such executables.
5462 
5463   When a "work that uses the Library" uses material from a header file
5464 that is part of the Library, the object code for the work may be a
5465 derivative work of the Library even though the source code is not.
5466 Whether this is true is especially significant if the work can be
5467 linked without the Library, or if the work is itself a library.  The
5468 threshold for this to be true is not precisely defined by law.
5469 
5470   If such an object file uses only numerical parameters, data
5471 structure layouts and accessors, and small macros and small inline
5472 functions (ten lines or less in length), then the use of the object
5473 file is unrestricted, regardless of whether it is legally a derivative
5474 work.  (Executables containing this object code plus portions of the
5475 Library will still fall under Section 6.)
5476 
5477   Otherwise, if the work is a derivative of the Library, you may
5478 distribute the object code for the work under the terms of Section 6.
5479 Any executables containing that work also fall under Section 6,
5480 whether or not they are linked directly with the Library itself.
5481 
5482   6. As an exception to the Sections above, you may also combine or
5483 link a "work that uses the Library" with the Library to produce a
5484 work containing portions of the Library, and distribute that work
5485 under terms of your choice, provided that the terms permit
5486 modification of the work for the customer's own use and reverse
5487 engineering for debugging such modifications.
5488 
5489   You must give prominent notice with each copy of the work that the
5490 Library is used in it and that the Library and its use are covered by
5491 this License.  You must supply a copy of this License.  If the work
5492 during execution displays copyright notices, you must include the
5493 copyright notice for the Library among them, as well as a reference
5494 directing the user to the copy of this License.  Also, you must do one
5495 of these things:
5496 
5497     a) Accompany the work with the complete corresponding
5498     machine-readable source code for the Library including whatever
5499     changes were used in the work (which must be distributed under
5500     Sections 1 and 2 above); and, if the work is an executable linked
5501     with the Library, with the complete machine-readable "work that
5502     uses the Library", as object code and/or source code, so that the
5503     user can modify the Library and then relink to produce a modified
5504     executable containing the modified Library.  (It is understood
5505     that the user who changes the contents of definitions files in the
5506     Library will not necessarily be able to recompile the application
5507     to use the modified definitions.)
5508 
5509     b) Use a suitable shared library mechanism for linking with the
5510     Library.  A suitable mechanism is one that (1) uses at run time a
5511     copy of the library already present on the user's computer system,
5512     rather than copying library functions into the executable, and (2)
5513     will operate properly with a modified version of the library, if
5514     the user installs one, as long as the modified version is
5515     interface-compatible with the version that the work was made with.
5516 
5517     c) Accompany the work with a written offer, valid for at
5518     least three years, to give the same user the materials
5519     specified in Subsection 6a, above, for a charge no more
5520     than the cost of performing this distribution.
5521 
5522     d) If distribution of the work is made by offering access to copy
5523     from a designated place, offer equivalent access to copy the above
5524     specified materials from the same place.
5525 
5526     e) Verify that the user has already received a copy of these
5527     materials or that you have already sent this user a copy.
5528 
5529   For an executable, the required form of the "work that uses the
5530 Library" must include any data and utility programs needed for
5531 reproducing the executable from it.  However, as a special exception,
5532 the materials to be distributed need not include anything that is
5533 normally distributed (in either source or binary form) with the major
5534 components (compiler, kernel, and so on) of the operating system on
5535 which the executable runs, unless that component itself accompanies
5536 the executable.
5537 
5538   It may happen that this requirement contradicts the license
5539 restrictions of other proprietary libraries that do not normally
5540 accompany the operating system.  Such a contradiction means you cannot
5541 use both them and the Library together in an executable that you
5542 distribute.
5543 
5544   7. You may place library facilities that are a work based on the
5545 Library side-by-side in a single library together with other library
5546 facilities not covered by this License, and distribute such a combined
5547 library, provided that the separate distribution of the work based on
5548 the Library and of the other library facilities is otherwise
5549 permitted, and provided that you do these two things:
5550 
5551     a) Accompany the combined library with a copy of the same work
5552     based on the Library, uncombined with any other library
5553     facilities.  This must be distributed under the terms of the
5554     Sections above.
5555 
5556     b) Give prominent notice with the combined library of the fact
5557     that part of it is a work based on the Library, and explaining
5558     where to find the accompanying uncombined form of the same work.
5559 
5560   8. You may not copy, modify, sublicense, link with, or distribute
5561 the Library except as expressly provided under this License.  Any
5562 attempt otherwise to copy, modify, sublicense, link with, or
5563 distribute the Library is void, and will automatically terminate your
5564 rights under this License.  However, parties who have received copies,
5565 or rights, from you under this License will not have their licenses
5566 terminated so long as such parties remain in full compliance.
5567 
5568   9. You are not required to accept this License, since you have not
5569 signed it.  However, nothing else grants you permission to modify or
5570 distribute the Library or its derivative works.  These actions are
5571 prohibited by law if you do not accept this License.  Therefore, by
5572 modifying or distributing the Library (or any work based on the
5573 Library), you indicate your acceptance of this License to do so, and
5574 all its terms and conditions for copying, distributing or modifying
5575 the Library or works based on it.
5576 
5577   10. Each time you redistribute the Library (or any work based on the
5578 Library), the recipient automatically receives a license from the
5579 original licensor to copy, distribute, link with or modify the Library
5580 subject to these terms and conditions.  You may not impose any further
5581 restrictions on the recipients' exercise of the rights granted herein.
5582 You are not responsible for enforcing compliance by third parties with
5583 this License.
5584 
5585   11. If, as a consequence of a court judgment or allegation of patent
5586 infringement or for any other reason (not limited to patent issues),
5587 conditions are imposed on you (whether by court order, agreement or
5588 otherwise) that contradict the conditions of this License, they do not
5589 excuse you from the conditions of this License.  If you cannot
5590 distribute so as to satisfy simultaneously your obligations under this
5591 License and any other pertinent obligations, then as a consequence you
5592 may not distribute the Library at all.  For example, if a patent
5593 license would not permit royalty-free redistribution of the Library by
5594 all those who receive copies directly or indirectly through you, then
5595 the only way you could satisfy both it and this License would be to
5596 refrain entirely from distribution of the Library.
5597 
5598 If any portion of this section is held invalid or unenforceable under any
5599 particular circumstance, the balance of the section is intended to apply,
5600 and the section as a whole is intended to apply in other circumstances.
5601 
5602 It is not the purpose of this section to induce you to infringe any
5603 patents or other property right claims or to contest validity of any
5604 such claims; this section has the sole purpose of protecting the
5605 integrity of the free software distribution system which is
5606 implemented by public license practices.  Many people have made
5607 generous contributions to the wide range of software distributed
5608 through that system in reliance on consistent application of that
5609 system; it is up to the author/donor to decide if he or she is willing
5610 to distribute software through any other system and a licensee cannot
5611 impose that choice.
5612 
5613 This section is intended to make thoroughly clear what is believed to
5614 be a consequence of the rest of this License.
5615 
5616   12. If the distribution and/or use of the Library is restricted in
5617 certain countries either by patents or by copyrighted interfaces, the
5618 original copyright holder who places the Library under this License may add
5619 an explicit geographical distribution limitation excluding those countries,
5620 so that distribution is permitted only in or among countries not thus
5621 excluded.  In such case, this License incorporates the limitation as if
5622 written in the body of this License.
5623 
5624   13. The Free Software Foundation may publish revised and/or new
5625 versions of the Lesser General Public License from time to time.
5626 Such new versions will be similar in spirit to the present version,
5627 but may differ in detail to address new problems or concerns.
5628 
5629 Each version is given a distinguishing version number.  If the Library
5630 specifies a version number of this License which applies to it and
5631 "any later version", you have the option of following the terms and
5632 conditions either of that version or of any later version published by
5633 the Free Software Foundation.  If the Library does not specify a
5634 license version number, you may choose any version ever published by
5635 the Free Software Foundation.
5636 
5637   14. If you wish to incorporate parts of the Library into other free
5638 programs whose distribution conditions are incompatible with these,
5639 write to the author to ask for permission.  For software which is
5640 copyrighted by the Free Software Foundation, write to the Free
5641 Software Foundation; we sometimes make exceptions for this.  Our
5642 decision will be guided by the two goals of preserving the free status
5643 of all derivatives of our free software and of promoting the sharing
5644 and reuse of software generally.
5645 
5646                             NO WARRANTY
5647 
5648   15. BECAUSE THE LIBRARY IS LICENSED FREE OF CHARGE, THERE IS NO
5649 WARRANTY FOR THE LIBRARY, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
5650 EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR
5651 OTHER PARTIES PROVIDE THE LIBRARY "AS IS" WITHOUT WARRANTY OF ANY
5652 KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE
5653 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
5654 PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
5655 LIBRARY IS WITH YOU.  SHOULD THE LIBRARY PROVE DEFECTIVE, YOU ASSUME
5656 THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
5657 
5658   16. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN
5659 WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY
5660 AND/OR REDISTRIBUTE THE LIBRARY AS PERMITTED ABOVE, BE LIABLE TO YOU
5661 FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR
5662 CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
5663 LIBRARY (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
5664 RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
5665 FAILURE OF THE LIBRARY TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
5666 SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
5667 DAMAGES.
5668 
5669                      END OF TERMS AND CONDITIONS
5670 */
5671 
5672 library NoiseV1 {
5673 
5674     uint32 private constant NOISE_TABLE_SIZE = 4095;
5675     
5676     int32 private constant PERLIN_YWRAPB = 4;
5677     int32 private constant PERLIN_YWRAP = 16; // 1 << PERLIN_YWRAPB
5678     int32 private constant PERLIN_ZWRAPB = 8;
5679     int32 private constant PERLIN_ZWRAP = 256; // 1 << PERLIN_ZWRAPB   
5680     uint8 private constant PERLIN_OCTAVES = 4;
5681     int64 private constant PERLIN_AMP_FALLOFF = 2147483648; // 0.5
5682 
5683     struct noiseFunction {
5684         int64[NOISE_TABLE_SIZE + 1] noiseTable;
5685         
5686         int64 x;
5687         int64 y;
5688         int64 z;
5689 
5690         int32 xi;
5691         int32 yi;
5692         int32 zi;
5693 
5694         int64 xf;
5695         int64 yf;
5696         int64 zf;
5697 
5698         int64 rxf;
5699         int64 ryf;
5700 
5701         int64 n1;
5702         int64 n2;
5703         int64 n3;
5704     }
5705 
5706     function buildNoiseTable(int32 seed) external pure returns (int64[4096] memory noiseTable){
5707         for (uint16 i = 0; i < NOISE_TABLE_SIZE + 1; i++) {
5708             (uint64 s, int64 v) = LCG64.next(uint32(seed));
5709             noiseTable[i] = v;
5710             seed = int32(uint32(s));
5711         }
5712     }
5713 
5714     function noise(
5715         int64[NOISE_TABLE_SIZE + 1] memory noiseTable,
5716         int64 x,
5717         int64 y
5718     ) external pure returns (int64) {
5719         return noise_impl(noiseFunction(noiseTable, x, y, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
5720     }
5721 
5722     function noise(noiseFunction memory f) external pure returns (int64) {
5723         return noise_impl(f);
5724     }
5725 
5726     function noise_impl(noiseFunction memory f) private pure returns (int64) {
5727         if (f.x < 0) {
5728             f.x = -f.x;
5729         }
5730         if (f.y < 0) {
5731             f.y = -f.y;
5732         }
5733         if (f.z < 0) {
5734             f.z = -f.z;
5735         }
5736 
5737         f.xi = int32(Fix64V1.floor(f.x) >> 32 /* FRACTIONAL_PLACES */);
5738         f.yi = int32(Fix64V1.floor(f.y) >> 32 /* FRACTIONAL_PLACES */);
5739         f.zi = int32(Fix64V1.floor(f.z) >> 32 /* FRACTIONAL_PLACES */);        
5740 
5741         f.xf = Fix64V1.sub(f.x, (f.xi * Fix64V1.ONE));
5742         f.yf = Fix64V1.sub(f.y, (f.yi * Fix64V1.ONE));
5743         f.zf = Fix64V1.sub(f.z, (f.zi * Fix64V1.ONE)); 
5744         
5745         int64 r = 0;
5746         int64 ampl = PERLIN_AMP_FALLOFF;     
5747 
5748         for (uint8 o = 0; o < PERLIN_OCTAVES; o++) {
5749 
5750             int32 off = f.xi + (f.yi << uint32(PERLIN_YWRAPB)) + (f.zi << uint32(PERLIN_ZWRAPB));
5751             f.rxf = scaled_cosine(f.xf);
5752             f.ryf = scaled_cosine(f.yf);
5753 
5754             f.n1 = f.noiseTable[uint32(off) & NOISE_TABLE_SIZE];
5755             {
5756                 f.n1 = Fix64V1.add(f.n1, Fix64V1.mul(f.rxf, Fix64V1.sub(int64(f.noiseTable[(uint32(off) + 1) & NOISE_TABLE_SIZE]), f.n1)));                        
5757 
5758                 f.n2 = f.noiseTable[(uint32(off) + uint32(PERLIN_YWRAP)) & NOISE_TABLE_SIZE];
5759                 f.n2 = Fix64V1.add(f.n2, Fix64V1.mul(f.rxf, Fix64V1.sub(int64(f.noiseTable[(uint32(off) + uint32(PERLIN_YWRAP) + 1) & NOISE_TABLE_SIZE]), f.n2)));
5760                 f.n1 = Fix64V1.add(f.n1, Fix64V1.mul(f.ryf, Fix64V1.sub(f.n2, f.n1)));
5761 
5762                 off += PERLIN_ZWRAP;
5763 
5764                 f.n2 = f.noiseTable[uint32(off) & NOISE_TABLE_SIZE];
5765                 f.n2 = Fix64V1.add(f.n2, Fix64V1.mul(f.rxf, Fix64V1.sub(int64(f.noiseTable[((uint32(off) + 1)) & NOISE_TABLE_SIZE]), f.n2)));
5766 
5767                 f.n3 = f.noiseTable[(uint32(off) + uint32(PERLIN_YWRAP)) & NOISE_TABLE_SIZE];
5768                 f.n3 = Fix64V1.add(f.n3, Fix64V1.mul(f.rxf, Fix64V1.sub(int64(f.noiseTable[(uint32(off) + uint32(PERLIN_YWRAP) + 1) & NOISE_TABLE_SIZE]), f.n3)));
5769                 f.n2 = Fix64V1.add(f.n2, Fix64V1.mul(f.ryf, Fix64V1.sub(f.n3, f.n2)));
5770                 f.n1 = Fix64V1.add(f.n1, Fix64V1.mul(scaled_cosine(f.zf), Fix64V1.sub(f.n2, f.n1)));
5771             }           
5772 
5773             r = Fix64V1.add(r, Fix64V1.mul(f.n1, ampl));
5774             ampl = Fix64V1.mul(ampl, PERLIN_AMP_FALLOFF);
5775 
5776             f.xi <<= 1;
5777             f.xf = Fix64V1.mul(f.xf, Fix64V1.TWO);
5778             f.yi <<= 1;
5779             f.yf = Fix64V1.mul(f.yf, Fix64V1.TWO);
5780             f.zi <<= 1;
5781             f.zf = Fix64V1.mul(f.zf, Fix64V1.TWO);
5782 
5783             if (f.xf >= Fix64V1.ONE) {
5784                 f.xi++;
5785                 f.xf = f.xf - Fix64V1.ONE;
5786             }
5787             if (f.yf >= Fix64V1.ONE) {
5788                 f.yi++;
5789                 f.yf = f.yf - Fix64V1.ONE;
5790             }
5791             if (f.zf >= Fix64V1.ONE) {
5792                 f.zi++;
5793                 f.zf = f.zf - Fix64V1.ONE;
5794             }
5795         }
5796 
5797         return r;
5798     }
5799 
5800     function scaled_cosine(int64 i)
5801         private
5802         pure
5803         returns (int64)
5804     {
5805         int64 angle = Fix64V1.mul(i, Fix64V1.PI);      
5806         int64 cosine = Trig256.cos(angle);
5807         int64 scaled = Fix64V1.mul(
5808                 2147483648, /* 0.5f */
5809                 Fix64V1.sub(Fix64V1.ONE, cosine)
5810             );        
5811 
5812         return scaled;            
5813     }
5814 }
5815 
5816 
5817 // File contracts/V1/ParticleV1.sol
5818 
5819 // License: UNLICENSED
5820 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
5821 
5822 pragma solidity ^0.8.0;
5823 /*
5824     A noise-based particle simulator, built for generative art that uses flow fields.
5825 
5826     Based on techniques in Sighack's "Getting Creative with Perlin Noise Fields":
5827     See: https://github.com/sighack/perlin-noise-fields
5828     See: https://github.com/sighack/perlin-noise-fields/blob/master/LICENSE
5829 
5830     THIRD PARTY NOTICES:
5831     ====================
5832 
5833     MIT License
5834 
5835     Copyright (c) 2018 Manohar Vanga
5836 
5837     Permission is hereby granted, free of charge, to any person obtaining a copy
5838     of this software and associated documentation files (the "Software"), to deal
5839     in the Software without restriction, including without limitation the rights
5840     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
5841     copies of the Software, and to permit persons to whom the Software is
5842     furnished to do so, subject to the following conditions:
5843 
5844     The above copyright notice and this permission notice shall be included in all
5845     copies or substantial portions of the Software.
5846 
5847     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
5848     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
5849     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
5850     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
5851     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
5852     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
5853     SOFTWARE.
5854 */
5855 
5856 library ParticleV1 {
5857     uint16 internal constant NOISE_TABLE_SIZE = 4096;
5858 
5859     struct Particle2D {
5860         int64 ox;
5861         int64 oy;
5862         int64 px;
5863         int64 py;
5864         int64 x;
5865         int64 y;
5866         uint32 frames;
5867         bool dead;
5868         TypesV1.Point2D force;
5869         uint8 _lifetime;
5870         int64 _forceScale;
5871         int64 _noiseScale;
5872     }
5873 
5874     function update(
5875         int64[NOISE_TABLE_SIZE] memory noiseTable,
5876         Particle2D memory p,
5877         uint256 width,
5878         uint256 height
5879     ) internal pure {
5880         p.frames++;
5881 
5882         if (p.frames >= p._lifetime) {
5883             p.dead = true;
5884             return;
5885         }
5886 
5887         p.force = forceAt(noiseTable, p, p.x, p.y);
5888 
5889         if (
5890             p.x >= int256(width) + int256(width) / 2 ||
5891             p.x < -int256(width) / 2 ||
5892             p.y >= int256(height) + int256(height) / 2 ||
5893             p.y < -int256(height) / 2
5894         ) {
5895             p.dead = true;
5896             return;
5897         }
5898 
5899         p.px = p.x;
5900         p.py = p.y;                
5901 
5902         p.x += int64(p.force.x);
5903         p.y += int64(p.force.y);        
5904     }
5905 
5906     function forceAt(
5907         int64[NOISE_TABLE_SIZE] memory noiseTable,
5908         Particle2D memory p,
5909         int64 x,
5910         int64 y
5911     ) internal pure returns (TypesV1.Point2D memory force) {
5912 
5913         int64 nx = Fix64V1.mul(x * Fix64V1.ONE, p._noiseScale);       
5914         int64 ny = Fix64V1.mul(y * Fix64V1.ONE, p._noiseScale);
5915         
5916         int64 noise = NoiseV1.noise(noiseTable, nx, ny);
5917         int64 theta = Fix64V1.mul(noise, Fix64V1.TWO_PI);
5918 
5919         return forceFromAngle(p, theta);
5920     }
5921 
5922     function forceFromAngle(Particle2D memory p, int64 theta)
5923         internal
5924         pure
5925         returns (TypesV1.Point2D memory force)
5926     {
5927         int64 px = Trig256.cos(theta);
5928         int64 py = Trig256.sin(theta);
5929 
5930         int64 pxl = Fix64V1.mul(px, p._forceScale) >> 32 /* FRACTIONAL_PLACES */;
5931         int64 pyl = Fix64V1.mul(py, p._forceScale) >> 32 /* FRACTIONAL_PLACES */;        
5932         
5933         force = TypesV1.Point2D(int32(pxl), int32(pyl));
5934     }
5935 }
5936 
5937 
5938 // File contracts/V1/ParticleSetV1.sol
5939 
5940 // License: UNLICENSED
5941 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
5942 
5943 pragma solidity ^0.8.0;
5944 /*
5945     A noise-based particle simulator, built for generative art that uses flow fields.
5946 
5947     Based on techniques in Sighack's "Getting Creative with Perlin Noise Fields":
5948     See: https://github.com/sighack/perlin-noise-fields
5949     See: https://github.com/sighack/perlin-noise-fields/blob/master/LICENSE
5950 
5951     THIRD PARTY NOTICES:
5952     ====================
5953 
5954     MIT License
5955 
5956     Copyright (c) 2018 Manohar Vanga
5957 
5958     Permission is hereby granted, free of charge, to any person obtaining a copy
5959     of this software and associated documentation files (the "Software"), to deal
5960     in the Software without restriction, including without limitation the rights
5961     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
5962     copies of the Software, and to permit persons to whom the Software is
5963     furnished to do so, subject to the following conditions:
5964 
5965     The above copyright notice and this permission notice shall be included in all
5966     copies or substantial portions of the Software.
5967 
5968     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
5969     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
5970     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
5971     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
5972     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
5973     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
5974     SOFTWARE.
5975 */
5976 
5977 abstract contract ParticleSetV1 {
5978     uint16 internal constant NOISE_TABLE_SIZE = 4095;
5979     uint16 internal constant PARTICLE_TABLE_SIZE = 5000;
5980 
5981     struct ParticleSet2D {
5982         ParticleV1.Particle2D[5000] particles;
5983         bool dead;
5984     }
5985     
5986     function update(
5987         int64[NOISE_TABLE_SIZE + 1] memory noiseTable,
5988         ParticleSet2D memory set,
5989         uint16 particleCount,
5990         uint256 width,
5991         uint256 height
5992     ) internal pure {
5993         set.dead = true;
5994         for (uint16 i = 0; i < particleCount; i++) {
5995             ParticleV1.Particle2D memory p = set.particles[i];
5996             if (p.dead) {
5997                 continue;
5998             }
5999             set.dead = false;
6000             ParticleV1.update(noiseTable, p, width, height);
6001         }
6002     }
6003 
6004     function draw(
6005         ParticleSet2D memory set,
6006         uint16 particleCount,
6007         uint32[16384] memory result,
6008         TypesV1.Chunk2D memory chunk
6009     ) internal pure {
6010         if (set.dead) {
6011             return;
6012         }
6013 
6014         for (uint256 i = 0; i < particleCount; i++) {
6015             ParticleV1.Particle2D memory p = set.particles[i];
6016             if (p.dead) {
6017                 continue;
6018             }
6019             step(p, result, chunk);
6020         }
6021     }
6022 
6023     function step(
6024         ParticleV1.Particle2D memory p, uint32[16384] memory result,
6025         TypesV1.Chunk2D memory chunk
6026     ) internal pure virtual;
6027 }
6028 
6029 
6030 // File contracts/V1/ParticleSetFactoryV1.sol
6031 
6032 // License-Identifier: UNLICENSED
6033 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
6034 
6035 pragma solidity ^0.8.0;
6036 /*
6037     A noise-based particle simulator, built for generative art that uses flow fields.
6038 
6039     Based on techniques in Sighack's "Getting Creative with Perlin Noise Fields":
6040     See: https://github.com/sighack/perlin-noise-fields
6041     See: https://github.com/sighack/perlin-noise-fields/blob/master/LICENSE
6042 
6043     THIRD PARTY NOTICES:
6044     ====================
6045 
6046     MIT License
6047 
6048     Copyright (c) 2018 Manohar Vanga
6049 
6050     Permission is hereby granted, free of charge, to any person obtaining a copy
6051     of this software and associated documentation files (the "Software"), to deal
6052     in the Software without restriction, including without limitation the rights
6053     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
6054     copies of the Software, and to permit persons to whom the Software is
6055     furnished to do so, subject to the following conditions:
6056 
6057     The above copyright notice and this permission notice shall be included in all
6058     copies or substantial portions of the Software.
6059 
6060     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
6061     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
6062     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
6063     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
6064     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
6065     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
6066     SOFTWARE.
6067 */
6068 
6069 library ParticleSetFactoryV1 {
6070     uint16 internal constant PARTICLE_TABLE_SIZE = 5000;
6071 
6072     struct CreateParticleSet2D {
6073         int32 seed;
6074         uint32 range;
6075         uint16 width;
6076         uint16 height;
6077         uint16 n;
6078         int64 forceScale;
6079         int64 noiseScale;
6080         uint8 lifetime;
6081     }
6082 
6083     function createSet(CreateParticleSet2D memory f, RandomV1.PRNG memory prng)
6084         external
6085         pure
6086         returns (ParticleSetV1.ParticleSet2D memory set, RandomV1.PRNG memory)
6087     {
6088         ParticleV1.Particle2D[PARTICLE_TABLE_SIZE] memory particles;
6089 
6090         for (uint16 i = 0; i < f.n; i++) {  
6091 
6092             int256 px = RandomV1.next(
6093                 prng,
6094                 -int32(f.range),
6095                 int16(f.width) + int32(f.range)
6096             );
6097 
6098             int256 py = RandomV1.next(
6099                 prng,
6100                 -int32(f.range),
6101                 int16(f.height) + int32(f.range)
6102             );
6103 
6104             ParticleV1.Particle2D memory particle = ParticleV1.Particle2D(
6105                 int64(px),
6106                 int64(py),
6107                 0,
6108                 0,
6109                 int64(px),
6110                 int64(py),
6111                 0,
6112                 false,
6113                 TypesV1.Point2D(0, 0),
6114                 f.lifetime,
6115                 f.forceScale,
6116                 f.noiseScale
6117             );
6118             particles[i] = particle;
6119         }
6120 
6121         set.particles = particles;
6122         return (set, prng);
6123     }
6124 }
6125 
6126 
6127 // File contracts/V1/GraphicsV1.sol
6128 
6129 // License: UNLICENSED
6130 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
6131 
6132 pragma solidity ^0.8.0;
6133 
6134 library GraphicsV1 {
6135     
6136     function setPixel(
6137         uint32[20480 /* 128 * 160 */] memory result,
6138         uint256 width,
6139         int256 x,
6140         int256 y,
6141         uint32 color
6142     ) internal pure {
6143         uint256 p = uint256(int256(width) * y + x);
6144         result[p] = blend(result[p], color);
6145     }
6146 
6147     function blend(uint32 bg, uint32 fg) internal pure returns (uint32) {
6148         uint32 r1 = bg >> 16;
6149         uint32 g1 = bg >> 8;
6150         uint32 b1 = bg;
6151         
6152         uint32 a2 = fg >> 24;
6153         uint32 r2 = fg >> 16;
6154         uint32 g2 = fg >> 8;
6155         uint32 b2 = fg;
6156         
6157         uint32 alpha = (a2 & 0xFF) + 1;
6158         uint32 inverseAlpha = 257 - alpha;
6159 
6160         uint32 r = (alpha * (r2 & 0xFF) + inverseAlpha * (r1 & 0xFF)) >> 8;
6161         uint32 g = (alpha * (g2 & 0xFF) + inverseAlpha * (g1 & 0xFF)) >> 8;
6162         uint32 b = (alpha * (b2 & 0xFF) + inverseAlpha * (b1 & 0xFF)) >> 8;
6163 
6164         uint32 rgb = 0;
6165         rgb |= uint32(0xFF) << 24;
6166         rgb |= r << 16;
6167         rgb |= g << 8;
6168         rgb |= b;
6169 
6170         return rgb;
6171     }
6172 
6173     function setOpacity(uint32 color, uint32 opacity) internal pure returns (uint32) {
6174 
6175         require(opacity > 0 && opacity <= 255, "opacity must be between 0 and 255");
6176         
6177         uint32 r = color >> 16 & 0xFF;
6178         uint32 g = color >> 8 & 0xFF;
6179         uint32 b = color & 0xFF;
6180 
6181         uint32 rgb = 0;
6182         rgb |= opacity << 24;
6183         rgb |= r << 16;
6184         rgb |= g << 8;
6185         rgb |= b;
6186 
6187         return uint32(rgb);     
6188     }
6189 }
6190 
6191 
6192 // File contracts/V1/ProcessingV1.sol
6193 
6194 // License: UNLICENSED
6195 /* Copyright (c) 2021 Kohi Art Community, Inc. All rights reserved. */
6196 
6197 pragma solidity ^0.8.0;
6198 library ProcessingV1 {
6199     uint32 internal constant BG_COLOR = 0xFFD3D3D3;
6200     uint32 internal constant FILL_COLOR = 0xFFFFFFFF;
6201     uint32 internal constant STROKE_COLOR = 0x00000000;
6202     uint32 internal constant MAX_POLYGON_NODES = 400;
6203 
6204     /**
6205      * @notice Sets the color used for the background of the drawing surface.
6206      * @notice https://processing.org/reference/background_.html
6207      */
6208     function background(
6209         uint32[20480] /* 128 * 160 */
6210             memory result,
6211         uint32 color,
6212         TypesV1.Chunk2D memory chunk
6213     ) internal pure {
6214         for (uint256 x = 0; x < chunk.chunkWidth; x++) {
6215             for (uint256 y = 0; y < chunk.chunkHeight; y++) {
6216                 GraphicsV1.setPixel(
6217                     result,
6218                     chunk.chunkWidth,
6219                     int256(x),
6220                     int256(y),
6221                     color
6222                 );
6223             }
6224         }
6225     }
6226 
6227     /**
6228      * @notice A triangle is a plane created by connecting three points. The first two arguments specify the first point, the middle two arguments specify the second point, and the last two arguments specify the third point.
6229      * @notice https://processing.org/reference/triangle_.html
6230      * @dev Renders a filled triangle, using the Barycentric rasterization algorithm.
6231      */
6232     function triangle(
6233         uint32[20480] /* 128 * 160 */
6234             memory result,
6235         GeometryV1.Triangle2D memory f
6236     ) internal pure {
6237         TypesV1.Point2D memory p;
6238 
6239         uint256 minX = f.chunk.startX;
6240         uint256 maxX = (f.chunk.startX + f.chunk.chunkWidth) - 1;
6241         uint256 minY = f.chunk.startY;
6242         uint256 maxY = (f.chunk.startY + f.chunk.chunkHeight) - 1;
6243 
6244         while (GeometryV1.edge(f.v0, f.v1, f.v2) < 0) {
6245             TypesV1.Point2D memory temp = f.v1;
6246             f.v1 = f.v2;
6247             f.v2 = temp;
6248         }
6249 
6250         for (p.x = int256(minX); p.x <= int256(maxX); p.x++) {
6251             for (p.y = int256(minY); p.y <= int256(maxY); p.y++) {
6252                 int256 w0 = GeometryV1.edge(f.v1, f.v2, p);
6253                 int256 w1 = GeometryV1.edge(f.v2, f.v0, p);
6254                 int256 w2 = GeometryV1.edge(f.v0, f.v1, p);
6255 
6256                 if (w0 >= 0 && w1 >= 0 && w2 >= 0) {
6257                     GraphicsV1.setPixel(
6258                         result,
6259                         f.chunk.chunkWidth,
6260                         int256(p.x - int32(f.chunk.startX)),
6261                         int256(p.y - int32(f.chunk.startY)),
6262                         f.fillColor
6263                     );
6264                 }
6265             }
6266         }
6267 
6268         if (f.strokeColor == f.fillColor) return;
6269 
6270         {
6271             line(result, GeometryV1.Line2D(f.v0, f.v1, f.strokeColor, f.chunk));
6272             line(result, GeometryV1.Line2D(f.v1, f.v2, f.strokeColor, f.chunk));
6273             line(result, GeometryV1.Line2D(f.v2, f.v0, f.strokeColor, f.chunk));
6274         }
6275     }
6276 
6277     /**
6278      * @notice Draws a line (a direct path between two points) to the screen.
6279      * @notice https://processing.org/reference/line_.html
6280      * @dev Renders a line between two points, using Bresenham's rasterization algorithm.
6281      */
6282     function line(uint32[20480] memory result, GeometryV1.Line2D memory f)
6283         internal
6284         pure
6285     {
6286         int256 x0 = f.v0.x;
6287         int256 x1 = f.v1.x;
6288         int256 y0 = f.v0.y;
6289         int256 y1 = f.v1.y;
6290 
6291         int256 dx = MathV1.abs(x1 - x0);
6292         int256 dy = MathV1.abs(y1 - y0);
6293 
6294         int256 err = (dx > dy ? dx : -dy) / 2;
6295         int256 e2;
6296 
6297         for (;;) {
6298             if (
6299                 x0 <= int32(f.chunk.startX) + int16(f.chunk.chunkWidth) - 1 &&
6300                 x0 >= int32(f.chunk.startX) &&
6301                 y0 <= int32(f.chunk.startY) + int16(f.chunk.chunkHeight) - 1 &&
6302                 y0 >= int32(f.chunk.startY)
6303             ) {
6304                 GraphicsV1.setPixel(
6305                     result,
6306                     f.chunk.chunkWidth,
6307                     x0 - int32(f.chunk.startX),
6308                     y0 - int32(f.chunk.startY),
6309                     f.color
6310                 );
6311             }
6312 
6313             if (x0 == x1 && y0 == y1) break;
6314             e2 = err;
6315             if (e2 > -dx) {
6316                 err -= dy;
6317                 x0 += x0 < x1 ? int8(1) : -1;
6318             }
6319             if (e2 < dy) {
6320                 err += dx;
6321                 y0 += y0 < y1 ? int8(1) : -1;
6322             }
6323         }
6324     }
6325 
6326     /**
6327      * @notice Draw a polygon shape to the screen.
6328      * @notice https://processing.org/reference/beginShape_.html
6329      * @notice https://processing.org/reference/vertex_.html
6330      * @notice https://processing.org/reference/endShape_.html
6331      * @dev Renders a filled polygon, using Finley's algorithm.
6332      */
6333     function polygon(uint32[20480] memory result, GeometryV1.Polygon2D memory f)
6334         internal
6335         pure
6336     {
6337         uint32 polyCorners = f.vertexCount;
6338 
6339         int32[MAX_POLYGON_NODES] memory nodeX;
6340 
6341         for (
6342             uint32 pixelY = f.chunk.startY;
6343             pixelY < (f.chunk.startY + f.chunk.chunkHeight);
6344             pixelY++
6345         ) {
6346             uint32 i;
6347 
6348             uint256 nodes = 0;
6349             uint32 j = polyCorners - 1;
6350             for (i = 0; i < polyCorners; i++) {
6351                 TypesV1.Point2D memory a = TypesV1.Point2D(
6352                     f.vertices[i].x,
6353                     f.vertices[i].y
6354                 );
6355                 TypesV1.Point2D memory b = TypesV1.Point2D(
6356                     f.vertices[j].x,
6357                     f.vertices[j].y
6358                 );
6359 
6360                 if (
6361                     (a.y < int32(pixelY) && b.y >= int32(pixelY)) ||
6362                     (b.y < int32(pixelY) && a.y >= int32(pixelY))
6363                 ) {
6364                     int32 t = int32(a.x) +
6365                         ((int32(pixelY) - int32(a.y)) /
6366                             (int32(b.y) - int32(a.y))) *
6367                         (int32(b.x) - int32(a.x));
6368                     nodeX[nodes++] = t;
6369                 }
6370 
6371                 j = i;
6372             }
6373 
6374             if (nodes == 0) {
6375                 continue; // nothing to draw
6376             }
6377 
6378             i = 0;
6379             while (i < nodes - 1) {
6380                 if (nodeX[i] > nodeX[i + 1]) {
6381                     (nodeX[i], nodeX[i + 1]) = (nodeX[i + 1], nodeX[i]);
6382                     if (i != 0) i--;
6383                 } else {
6384                     i++;
6385                 }
6386             }
6387 
6388             for (i = 0; i < nodes; i += 2) {
6389                 if (
6390                     nodeX[i] >=
6391                     int32(f.chunk.startX) + int16(f.chunk.chunkHeight)
6392                 ) break;
6393                 if (nodeX[i + 1] <= int32(f.chunk.startX)) continue;
6394                 if (nodeX[i] < int32(f.chunk.startX))
6395                     nodeX[i] = int32(f.chunk.startX);
6396                 if (
6397                     nodeX[i + 1] >
6398                     int32(f.chunk.startX) + int16(f.chunk.chunkHeight)
6399                 )
6400                     nodeX[i + 1] = int32(
6401                         int32(f.chunk.startX) + int16(f.chunk.chunkHeight)
6402                     );
6403 
6404                 for (int32 pixelX = nodeX[i]; pixelX < nodeX[i + 1]; pixelX++) {
6405                     if (
6406                         pixelX >=
6407                         int32(f.chunk.startX) + int16(f.chunk.chunkHeight)
6408                     ) continue;
6409 
6410                     int32 px = int32(pixelX) - int32(f.chunk.startX);
6411                     int32 py = int32(pixelY) - int32(f.chunk.startY);
6412 
6413                     if (
6414                         px >= 0 &&
6415                         px < int16(f.chunk.chunkWidth) &&
6416                         py >= 0 &&
6417                         py < int16(f.chunk.chunkHeight)
6418                     ) {
6419                         GraphicsV1.setPixel(
6420                             result,
6421                             f.chunk.chunkWidth,
6422                             px,
6423                             py,
6424                             f.fillColor
6425                         );
6426                     }
6427                 }
6428             }
6429         }
6430 
6431         if (f.strokeColor == f.fillColor) return;
6432 
6433         {
6434             uint256 j = f.vertices.length - 1;
6435             for (uint256 i = 0; i < f.vertices.length; i++) {
6436                 TypesV1.Point2D memory a = f.vertices[i];
6437                 TypesV1.Point2D memory b = f.vertices[j];
6438                 line(result, GeometryV1.Line2D(a, b, f.strokeColor, f.chunk));
6439                 j = i;
6440             }
6441             line(
6442                 result,
6443                 GeometryV1.Line2D(
6444                     f.vertices[f.vertices.length - 1],
6445                     f.vertices[0],
6446                     f.strokeColor,
6447                     f.chunk
6448                 )
6449             );
6450         }
6451     }
6452 
6453     /**
6454      * @notice Renders a number from a random series of numbers having a mean of 0 and standard deviation of 1.git
6455      * @notice https://processing.org/reference/randomGaussian_.html
6456      */
6457     function randomGaussian(RandomV1.PRNG memory prng)
6458         internal
6459         pure
6460         returns (int64)
6461     {
6462         return RandomV1.nextGaussian(prng);
6463     }
6464 }