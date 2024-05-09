1 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.0
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 
74 // File @openzeppelin/contracts/utils/Address.sol@v4.8.0
75 
76 
77 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
78 
79 pragma solidity ^0.8.1;
80 
81 /**
82  * @dev Collection of functions related to the address type
83  */
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      *
102      * [IMPORTANT]
103      * ====
104      * You shouldn't rely on `isContract` to protect against flash loan attacks!
105      *
106      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
107      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
108      * constructor.
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize/address.code.length, which returns 0
113         // for contracts in construction, since the code is only stored at the end
114         // of the constructor execution.
115 
116         return account.code.length > 0;
117     }
118 
119     /**
120      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
121      * `recipient`, forwarding all available gas and reverting on errors.
122      *
123      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
124      * of certain opcodes, possibly making contracts go over the 2300 gas limit
125      * imposed by `transfer`, making them unable to receive funds via
126      * `transfer`. {sendValue} removes this limitation.
127      *
128      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
129      *
130      * IMPORTANT: because control is transferred to `recipient`, care must be
131      * taken to not create reentrancy vulnerabilities. Consider using
132      * {ReentrancyGuard} or the
133      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
134      */
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         (bool success, ) = recipient.call{value: amount}("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain `call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
166      * `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(
190         address target,
191         bytes memory data,
192         uint256 value
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
199      * with `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(address(this).balance >= value, "Address: insufficient balance for call");
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         (bool success, bytes memory returndata) = target.staticcall(data);
236         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a delegate call.
242      *
243      * _Available since v3.4._
244      */
245     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
246         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         (bool success, bytes memory returndata) = target.delegatecall(data);
261         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
266      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
267      *
268      * _Available since v4.8._
269      */
270     function verifyCallResultFromTarget(
271         address target,
272         bool success,
273         bytes memory returndata,
274         string memory errorMessage
275     ) internal view returns (bytes memory) {
276         if (success) {
277             if (returndata.length == 0) {
278                 // only check isContract if the call was successful and the return data is empty
279                 // otherwise we already know that it was a contract
280                 require(isContract(target), "Address: call to non-contract");
281             }
282             return returndata;
283         } else {
284             _revert(returndata, errorMessage);
285         }
286     }
287 
288     /**
289      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
290      * revert reason or using the provided one.
291      *
292      * _Available since v4.3._
293      */
294     function verifyCallResult(
295         bool success,
296         bytes memory returndata,
297         string memory errorMessage
298     ) internal pure returns (bytes memory) {
299         if (success) {
300             return returndata;
301         } else {
302             _revert(returndata, errorMessage);
303         }
304     }
305 
306     function _revert(bytes memory returndata, string memory errorMessage) private pure {
307         // Look for revert reason and bubble it up if present
308         if (returndata.length > 0) {
309             // The easiest way to bubble the revert reason is using memory via assembly
310             /// @solidity memory-safe-assembly
311             assembly {
312                 let returndata_size := mload(returndata)
313                 revert(add(32, returndata), returndata_size)
314             }
315         } else {
316             revert(errorMessage);
317         }
318     }
319 }
320 
321 
322 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
323 
324 
325 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Standard math utilities missing in the Solidity language.
331  */
332 library Math {
333     enum Rounding {
334         Down, // Toward negative infinity
335         Up, // Toward infinity
336         Zero // Toward zero
337     }
338 
339     /**
340      * @dev Returns the largest of two numbers.
341      */
342     function max(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a > b ? a : b;
344     }
345 
346     /**
347      * @dev Returns the smallest of two numbers.
348      */
349     function min(uint256 a, uint256 b) internal pure returns (uint256) {
350         return a < b ? a : b;
351     }
352 
353     /**
354      * @dev Returns the average of two numbers. The result is rounded towards
355      * zero.
356      */
357     function average(uint256 a, uint256 b) internal pure returns (uint256) {
358         // (a + b) / 2 can overflow.
359         return (a & b) + (a ^ b) / 2;
360     }
361 
362     /**
363      * @dev Returns the ceiling of the division of two numbers.
364      *
365      * This differs from standard division with `/` in that it rounds up instead
366      * of rounding down.
367      */
368     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
369         // (a + b - 1) / b can overflow on addition, so we distribute.
370         return a == 0 ? 0 : (a - 1) / b + 1;
371     }
372 
373     /**
374      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
375      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
376      * with further edits by Uniswap Labs also under MIT license.
377      */
378     function mulDiv(
379         uint256 x,
380         uint256 y,
381         uint256 denominator
382     ) internal pure returns (uint256 result) {
383         unchecked {
384             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
385             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
386             // variables such that product = prod1 * 2^256 + prod0.
387             uint256 prod0; // Least significant 256 bits of the product
388             uint256 prod1; // Most significant 256 bits of the product
389             assembly {
390                 let mm := mulmod(x, y, not(0))
391                 prod0 := mul(x, y)
392                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
393             }
394 
395             // Handle non-overflow cases, 256 by 256 division.
396             if (prod1 == 0) {
397                 return prod0 / denominator;
398             }
399 
400             // Make sure the result is less than 2^256. Also prevents denominator == 0.
401             require(denominator > prod1);
402 
403             ///////////////////////////////////////////////
404             // 512 by 256 division.
405             ///////////////////////////////////////////////
406 
407             // Make division exact by subtracting the remainder from [prod1 prod0].
408             uint256 remainder;
409             assembly {
410                 // Compute remainder using mulmod.
411                 remainder := mulmod(x, y, denominator)
412 
413                 // Subtract 256 bit number from 512 bit number.
414                 prod1 := sub(prod1, gt(remainder, prod0))
415                 prod0 := sub(prod0, remainder)
416             }
417 
418             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
419             // See https://cs.stackexchange.com/q/138556/92363.
420 
421             // Does not overflow because the denominator cannot be zero at this stage in the function.
422             uint256 twos = denominator & (~denominator + 1);
423             assembly {
424                 // Divide denominator by twos.
425                 denominator := div(denominator, twos)
426 
427                 // Divide [prod1 prod0] by twos.
428                 prod0 := div(prod0, twos)
429 
430                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
431                 twos := add(div(sub(0, twos), twos), 1)
432             }
433 
434             // Shift in bits from prod1 into prod0.
435             prod0 |= prod1 * twos;
436 
437             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
438             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
439             // four bits. That is, denominator * inv = 1 mod 2^4.
440             uint256 inverse = (3 * denominator) ^ 2;
441 
442             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
443             // in modular arithmetic, doubling the correct bits in each step.
444             inverse *= 2 - denominator * inverse; // inverse mod 2^8
445             inverse *= 2 - denominator * inverse; // inverse mod 2^16
446             inverse *= 2 - denominator * inverse; // inverse mod 2^32
447             inverse *= 2 - denominator * inverse; // inverse mod 2^64
448             inverse *= 2 - denominator * inverse; // inverse mod 2^128
449             inverse *= 2 - denominator * inverse; // inverse mod 2^256
450 
451             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
452             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
453             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
454             // is no longer required.
455             result = prod0 * inverse;
456             return result;
457         }
458     }
459 
460     /**
461      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
462      */
463     function mulDiv(
464         uint256 x,
465         uint256 y,
466         uint256 denominator,
467         Rounding rounding
468     ) internal pure returns (uint256) {
469         uint256 result = mulDiv(x, y, denominator);
470         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
471             result += 1;
472         }
473         return result;
474     }
475 
476     /**
477      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
478      *
479      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
480      */
481     function sqrt(uint256 a) internal pure returns (uint256) {
482         if (a == 0) {
483             return 0;
484         }
485 
486         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
487         //
488         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
489         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
490         //
491         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
492         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
493         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
494         //
495         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
496         uint256 result = 1 << (log2(a) >> 1);
497 
498         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
499         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
500         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
501         // into the expected uint128 result.
502         unchecked {
503             result = (result + a / result) >> 1;
504             result = (result + a / result) >> 1;
505             result = (result + a / result) >> 1;
506             result = (result + a / result) >> 1;
507             result = (result + a / result) >> 1;
508             result = (result + a / result) >> 1;
509             result = (result + a / result) >> 1;
510             return min(result, a / result);
511         }
512     }
513 
514     /**
515      * @notice Calculates sqrt(a), following the selected rounding direction.
516      */
517     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
518         unchecked {
519             uint256 result = sqrt(a);
520             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
521         }
522     }
523 
524     /**
525      * @dev Return the log in base 2, rounded down, of a positive value.
526      * Returns 0 if given 0.
527      */
528     function log2(uint256 value) internal pure returns (uint256) {
529         uint256 result = 0;
530         unchecked {
531             if (value >> 128 > 0) {
532                 value >>= 128;
533                 result += 128;
534             }
535             if (value >> 64 > 0) {
536                 value >>= 64;
537                 result += 64;
538             }
539             if (value >> 32 > 0) {
540                 value >>= 32;
541                 result += 32;
542             }
543             if (value >> 16 > 0) {
544                 value >>= 16;
545                 result += 16;
546             }
547             if (value >> 8 > 0) {
548                 value >>= 8;
549                 result += 8;
550             }
551             if (value >> 4 > 0) {
552                 value >>= 4;
553                 result += 4;
554             }
555             if (value >> 2 > 0) {
556                 value >>= 2;
557                 result += 2;
558             }
559             if (value >> 1 > 0) {
560                 result += 1;
561             }
562         }
563         return result;
564     }
565 
566     /**
567      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
568      * Returns 0 if given 0.
569      */
570     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
571         unchecked {
572             uint256 result = log2(value);
573             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
574         }
575     }
576 
577     /**
578      * @dev Return the log in base 10, rounded down, of a positive value.
579      * Returns 0 if given 0.
580      */
581     function log10(uint256 value) internal pure returns (uint256) {
582         uint256 result = 0;
583         unchecked {
584             if (value >= 10**64) {
585                 value /= 10**64;
586                 result += 64;
587             }
588             if (value >= 10**32) {
589                 value /= 10**32;
590                 result += 32;
591             }
592             if (value >= 10**16) {
593                 value /= 10**16;
594                 result += 16;
595             }
596             if (value >= 10**8) {
597                 value /= 10**8;
598                 result += 8;
599             }
600             if (value >= 10**4) {
601                 value /= 10**4;
602                 result += 4;
603             }
604             if (value >= 10**2) {
605                 value /= 10**2;
606                 result += 2;
607             }
608             if (value >= 10**1) {
609                 result += 1;
610             }
611         }
612         return result;
613     }
614 
615     /**
616      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
617      * Returns 0 if given 0.
618      */
619     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
620         unchecked {
621             uint256 result = log10(value);
622             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
623         }
624     }
625 
626     /**
627      * @dev Return the log in base 256, rounded down, of a positive value.
628      * Returns 0 if given 0.
629      *
630      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
631      */
632     function log256(uint256 value) internal pure returns (uint256) {
633         uint256 result = 0;
634         unchecked {
635             if (value >> 128 > 0) {
636                 value >>= 128;
637                 result += 16;
638             }
639             if (value >> 64 > 0) {
640                 value >>= 64;
641                 result += 8;
642             }
643             if (value >> 32 > 0) {
644                 value >>= 32;
645                 result += 4;
646             }
647             if (value >> 16 > 0) {
648                 value >>= 16;
649                 result += 2;
650             }
651             if (value >> 8 > 0) {
652                 result += 1;
653             }
654         }
655         return result;
656     }
657 
658     /**
659      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
660      * Returns 0 if given 0.
661      */
662     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
663         unchecked {
664             uint256 result = log256(value);
665             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
666         }
667     }
668 }
669 
670 
671 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
672 
673 
674 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @dev String operations.
680  */
681 library Strings {
682     bytes16 private constant _SYMBOLS = "0123456789abcdef";
683     uint8 private constant _ADDRESS_LENGTH = 20;
684 
685     /**
686      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
687      */
688     function toString(uint256 value) internal pure returns (string memory) {
689         unchecked {
690             uint256 length = Math.log10(value) + 1;
691             string memory buffer = new string(length);
692             uint256 ptr;
693             /// @solidity memory-safe-assembly
694             assembly {
695                 ptr := add(buffer, add(32, length))
696             }
697             while (true) {
698                 ptr--;
699                 /// @solidity memory-safe-assembly
700                 assembly {
701                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
702                 }
703                 value /= 10;
704                 if (value == 0) break;
705             }
706             return buffer;
707         }
708     }
709 
710     /**
711      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
712      */
713     function toHexString(uint256 value) internal pure returns (string memory) {
714         unchecked {
715             return toHexString(value, Math.log256(value) + 1);
716         }
717     }
718 
719     /**
720      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
721      */
722     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
723         bytes memory buffer = new bytes(2 * length + 2);
724         buffer[0] = "0";
725         buffer[1] = "x";
726         for (uint256 i = 2 * length + 1; i > 1; --i) {
727             buffer[i] = _SYMBOLS[value & 0xf];
728             value >>= 4;
729         }
730         require(value == 0, "Strings: hex length insufficient");
731         return string(buffer);
732     }
733 
734     /**
735      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
736      */
737     function toHexString(address addr) internal pure returns (string memory) {
738         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
739     }
740 }
741 
742 
743 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.2.1
744 
745 
746 pragma solidity ^0.8.13;
747 
748 interface IOperatorFilterRegistry {
749     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
750     function register(address registrant) external;
751     function registerAndSubscribe(address registrant, address subscription) external;
752     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
753     function updateOperator(address registrant, address operator, bool filtered) external;
754     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
755     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
756     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
757     function subscribe(address registrant, address registrantToSubscribe) external;
758     function unsubscribe(address registrant, bool copyExistingEntries) external;
759     function subscriptionOf(address addr) external returns (address registrant);
760     function subscribers(address registrant) external returns (address[] memory);
761     function subscriberAt(address registrant, uint256 index) external returns (address);
762     function copyEntriesOf(address registrant, address registrantToCopy) external;
763     function isOperatorFiltered(address registrant, address operator) external returns (bool);
764     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
765     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
766     function filteredOperators(address addr) external returns (address[] memory);
767     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
768     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
769     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
770     function isRegistered(address addr) external returns (bool);
771     function codeHashOf(address addr) external returns (bytes32);
772 }
773 
774 
775 // File operator-filter-registry/src/OperatorFilterer.sol@v1.2.1
776 
777 
778 pragma solidity ^0.8.13;
779 
780 abstract contract OperatorFilterer {
781     error OperatorNotAllowed(address operator);
782 
783     IOperatorFilterRegistry constant operatorFilterRegistry =
784         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
785 
786     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
787         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
788         // will not revert, but the contract will need to be registered with the registry once it is deployed in
789         // order for the modifier to filter addresses.
790         if (address(operatorFilterRegistry).code.length > 0) {
791             if (subscribe) {
792                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
793             } else {
794                 if (subscriptionOrRegistrantToCopy != address(0)) {
795                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
796                 } else {
797                     operatorFilterRegistry.register(address(this));
798                 }
799             }
800         }
801     }
802 
803     modifier onlyAllowedOperator(address from) virtual {
804         // Check registry code length to facilitate testing in environments without a deployed registry.
805         if (address(operatorFilterRegistry).code.length > 0) {
806             // Allow spending tokens from addresses with balance
807             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
808             // from an EOA.
809             if (from == msg.sender) {
810                 _;
811                 return;
812             }
813             if (
814                 !(
815                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
816                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
817                 )
818             ) {
819                 revert OperatorNotAllowed(msg.sender);
820             }
821         }
822         _;
823     }
824 }
825 
826 
827 // File operator-filter-registry/src/DefaultOperatorFilterer.sol@v1.2.1
828 
829 
830 pragma solidity ^0.8.13;
831 
832 abstract contract DefaultOperatorFilterer is OperatorFilterer {
833     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
834 
835     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
836 }
837 
838 
839 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.0
840 
841 
842 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
843 
844 pragma solidity ^0.8.0;
845 
846 /**
847  * @title ERC721 token receiver interface
848  * @dev Interface for any contract that wants to support safeTransfers
849  * from ERC721 asset contracts.
850  */
851 interface IERC721Receiver {
852     /**
853      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
854      * by `operator` from `from`, this function is called.
855      *
856      * It must return its Solidity selector to confirm the token transfer.
857      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
858      *
859      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
860      */
861     function onERC721Received(
862         address operator,
863         address from,
864         uint256 tokenId,
865         bytes calldata data
866     ) external returns (bytes4);
867 }
868 
869 
870 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
871 
872 
873 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
874 
875 pragma solidity ^0.8.0;
876 
877 /**
878  * @dev Provides information about the current execution context, including the
879  * sender of the transaction and its data. While these are generally available
880  * via msg.sender and msg.data, they should not be accessed in such a direct
881  * manner, since when dealing with meta-transactions the account sending and
882  * paying for execution may not be the actual sender (as far as an application
883  * is concerned).
884  *
885  * This contract is only required for intermediate, library-like contracts.
886  */
887 abstract contract Context {
888     function _msgSender() internal view virtual returns (address) {
889         return msg.sender;
890     }
891 
892     function _msgData() internal view virtual returns (bytes calldata) {
893         return msg.data;
894     }
895 }
896 
897 
898 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
899 
900 
901 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 /**
906  * @dev Contract module which provides a basic access control mechanism, where
907  * there is an account (an owner) that can be granted exclusive access to
908  * specific functions.
909  *
910  * By default, the owner account will be the one that deploys the contract. This
911  * can later be changed with {transferOwnership}.
912  *
913  * This module is used through inheritance. It will make available the modifier
914  * `onlyOwner`, which can be applied to your functions to restrict their use to
915  * the owner.
916  */
917 abstract contract Ownable is Context {
918     address private _owner;
919 
920     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
921 
922     /**
923      * @dev Initializes the contract setting the deployer as the initial owner.
924      */
925     constructor() {
926         _transferOwnership(_msgSender());
927     }
928 
929     /**
930      * @dev Throws if called by any account other than the owner.
931      */
932     modifier onlyOwner() {
933         _checkOwner();
934         _;
935     }
936 
937     /**
938      * @dev Returns the address of the current owner.
939      */
940     function owner() public view virtual returns (address) {
941         return _owner;
942     }
943 
944     /**
945      * @dev Throws if the sender is not the owner.
946      */
947     function _checkOwner() internal view virtual {
948         require(owner() == _msgSender(), "Ownable: caller is not the owner");
949     }
950 
951     /**
952      * @dev Leaves the contract without owner. It will not be possible to call
953      * `onlyOwner` functions anymore. Can only be called by the current owner.
954      *
955      * NOTE: Renouncing ownership will leave the contract without an owner,
956      * thereby removing any functionality that is only available to the owner.
957      */
958     function renounceOwnership() public virtual onlyOwner {
959         _transferOwnership(address(0));
960     }
961 
962     /**
963      * @dev Transfers ownership of the contract to a new account (`newOwner`).
964      * Can only be called by the current owner.
965      */
966     function transferOwnership(address newOwner) public virtual onlyOwner {
967         require(newOwner != address(0), "Ownable: new owner is the zero address");
968         _transferOwnership(newOwner);
969     }
970 
971     /**
972      * @dev Transfers ownership of the contract to a new account (`newOwner`).
973      * Internal function without access restriction.
974      */
975     function _transferOwnership(address newOwner) internal virtual {
976         address oldOwner = _owner;
977         _owner = newOwner;
978         emit OwnershipTransferred(oldOwner, newOwner);
979     }
980 }
981 
982 
983 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
984 
985 
986 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @dev Interface of the ERC165 standard, as defined in the
992  * https://eips.ethereum.org/EIPS/eip-165[EIP].
993  *
994  * Implementers can declare support of contract interfaces, which can then be
995  * queried by others ({ERC165Checker}).
996  *
997  * For an implementation, see {ERC165}.
998  */
999 interface IERC165 {
1000     /**
1001      * @dev Returns true if this contract implements the interface defined by
1002      * `interfaceId`. See the corresponding
1003      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1004      * to learn more about how these ids are created.
1005      *
1006      * This function call must use less than 30 000 gas.
1007      */
1008     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1009 }
1010 
1011 
1012 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.0
1013 
1014 
1015 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1016 
1017 pragma solidity ^0.8.0;
1018 
1019 /**
1020  * @dev Required interface of an ERC721 compliant contract.
1021  */
1022 interface IERC721 is IERC165 {
1023     /**
1024      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1025      */
1026     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1027 
1028     /**
1029      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1030      */
1031     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1032 
1033     /**
1034      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1035      */
1036     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1037 
1038     /**
1039      * @dev Returns the number of tokens in ``owner``'s account.
1040      */
1041     function balanceOf(address owner) external view returns (uint256 balance);
1042 
1043     /**
1044      * @dev Returns the owner of the `tokenId` token.
1045      *
1046      * Requirements:
1047      *
1048      * - `tokenId` must exist.
1049      */
1050     function ownerOf(uint256 tokenId) external view returns (address owner);
1051 
1052     /**
1053      * @dev Safely transfers `tokenId` token from `from` to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - `from` cannot be the zero address.
1058      * - `to` cannot be the zero address.
1059      * - `tokenId` token must exist and be owned by `from`.
1060      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1061      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes calldata data
1070     ) external;
1071 
1072     /**
1073      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1074      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1075      *
1076      * Requirements:
1077      *
1078      * - `from` cannot be the zero address.
1079      * - `to` cannot be the zero address.
1080      * - `tokenId` token must exist and be owned by `from`.
1081      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1082      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) external;
1091 
1092     /**
1093      * @dev Transfers `tokenId` token from `from` to `to`.
1094      *
1095      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1096      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1097      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1098      *
1099      * Requirements:
1100      *
1101      * - `from` cannot be the zero address.
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function transferFrom(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) external;
1113 
1114     /**
1115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1116      * The approval is cleared when the token is transferred.
1117      *
1118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1119      *
1120      * Requirements:
1121      *
1122      * - The caller must own the token or be an approved operator.
1123      * - `tokenId` must exist.
1124      *
1125      * Emits an {Approval} event.
1126      */
1127     function approve(address to, uint256 tokenId) external;
1128 
1129     /**
1130      * @dev Approve or remove `operator` as an operator for the caller.
1131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1132      *
1133      * Requirements:
1134      *
1135      * - The `operator` cannot be the caller.
1136      *
1137      * Emits an {ApprovalForAll} event.
1138      */
1139     function setApprovalForAll(address operator, bool _approved) external;
1140 
1141     /**
1142      * @dev Returns the account approved for `tokenId` token.
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must exist.
1147      */
1148     function getApproved(uint256 tokenId) external view returns (address operator);
1149 
1150     /**
1151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1152      *
1153      * See {setApprovalForAll}
1154      */
1155     function isApprovedForAll(address owner, address operator) external view returns (bool);
1156 }
1157 
1158 
1159 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.0
1160 
1161 
1162 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1163 
1164 pragma solidity ^0.8.0;
1165 
1166 /**
1167  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1168  * @dev See https://eips.ethereum.org/EIPS/eip-721
1169  */
1170 interface IERC721Metadata is IERC721 {
1171     /**
1172      * @dev Returns the token collection name.
1173      */
1174     function name() external view returns (string memory);
1175 
1176     /**
1177      * @dev Returns the token collection symbol.
1178      */
1179     function symbol() external view returns (string memory);
1180 
1181     /**
1182      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1183      */
1184     function tokenURI(uint256 tokenId) external view returns (string memory);
1185 }
1186 
1187 
1188 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.0
1189 
1190 
1191 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1192 
1193 pragma solidity ^0.8.0;
1194 
1195 /**
1196  * @dev Implementation of the {IERC165} interface.
1197  *
1198  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1199  * for the additional interface id that will be supported. For example:
1200  *
1201  * ```solidity
1202  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1203  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1204  * }
1205  * ```
1206  *
1207  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1208  */
1209 abstract contract ERC165 is IERC165 {
1210     /**
1211      * @dev See {IERC165-supportsInterface}.
1212      */
1213     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1214         return interfaceId == type(IERC165).interfaceId;
1215     }
1216 }
1217 
1218 
1219 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.8.0
1220 
1221 
1222 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1223 
1224 pragma solidity ^0.8.0;
1225 
1226 
1227 
1228 
1229 
1230 
1231 
1232 /**
1233  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1234  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1235  * {ERC721Enumerable}.
1236  */
1237 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1238     using Address for address;
1239     using Strings for uint256;
1240 
1241     // Token name
1242     string private _name;
1243 
1244     // Token symbol
1245     string private _symbol;
1246 
1247     // Mapping from token ID to owner address
1248     mapping(uint256 => address) private _owners;
1249 
1250     // Mapping owner address to token count
1251     mapping(address => uint256) private _balances;
1252 
1253     // Mapping from token ID to approved address
1254     mapping(uint256 => address) private _tokenApprovals;
1255 
1256     // Mapping from owner to operator approvals
1257     mapping(address => mapping(address => bool)) private _operatorApprovals;
1258 
1259     /**
1260      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1261      */
1262     constructor(string memory name_, string memory symbol_) {
1263         _name = name_;
1264         _symbol = symbol_;
1265     }
1266 
1267     /**
1268      * @dev See {IERC165-supportsInterface}.
1269      */
1270     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1271         return
1272             interfaceId == type(IERC721).interfaceId ||
1273             interfaceId == type(IERC721Metadata).interfaceId ||
1274             super.supportsInterface(interfaceId);
1275     }
1276 
1277     /**
1278      * @dev See {IERC721-balanceOf}.
1279      */
1280     function balanceOf(address owner) public view virtual override returns (uint256) {
1281         require(owner != address(0), "ERC721: address zero is not a valid owner");
1282         return _balances[owner];
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-ownerOf}.
1287      */
1288     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1289         address owner = _ownerOf(tokenId);
1290         require(owner != address(0), "ERC721: invalid token ID");
1291         return owner;
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Metadata-name}.
1296      */
1297     function name() public view virtual override returns (string memory) {
1298         return _name;
1299     }
1300 
1301     /**
1302      * @dev See {IERC721Metadata-symbol}.
1303      */
1304     function symbol() public view virtual override returns (string memory) {
1305         return _symbol;
1306     }
1307 
1308     /**
1309      * @dev See {IERC721Metadata-tokenURI}.
1310      */
1311     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1312         _requireMinted(tokenId);
1313 
1314         string memory baseURI = _baseURI();
1315         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1316     }
1317 
1318     /**
1319      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1320      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1321      * by default, can be overridden in child contracts.
1322      */
1323     function _baseURI() internal view virtual returns (string memory) {
1324         return "";
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-approve}.
1329      */
1330     function approve(address to, uint256 tokenId) public virtual override {
1331         address owner = ERC721.ownerOf(tokenId);
1332         require(to != owner, "ERC721: approval to current owner");
1333 
1334         require(
1335             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1336             "ERC721: approve caller is not token owner or approved for all"
1337         );
1338 
1339         _approve(to, tokenId);
1340     }
1341 
1342     /**
1343      * @dev See {IERC721-getApproved}.
1344      */
1345     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1346         _requireMinted(tokenId);
1347 
1348         return _tokenApprovals[tokenId];
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-setApprovalForAll}.
1353      */
1354     function setApprovalForAll(address operator, bool approved) public virtual override {
1355         _setApprovalForAll(_msgSender(), operator, approved);
1356     }
1357 
1358     /**
1359      * @dev See {IERC721-isApprovedForAll}.
1360      */
1361     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1362         return _operatorApprovals[owner][operator];
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-transferFrom}.
1367      */
1368     function transferFrom(
1369         address from,
1370         address to,
1371         uint256 tokenId
1372     ) public virtual override {
1373         //solhint-disable-next-line max-line-length
1374         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1375 
1376         _transfer(from, to, tokenId);
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-safeTransferFrom}.
1381      */
1382     function safeTransferFrom(
1383         address from,
1384         address to,
1385         uint256 tokenId
1386     ) public virtual override {
1387         safeTransferFrom(from, to, tokenId, "");
1388     }
1389 
1390     /**
1391      * @dev See {IERC721-safeTransferFrom}.
1392      */
1393     function safeTransferFrom(
1394         address from,
1395         address to,
1396         uint256 tokenId,
1397         bytes memory data
1398     ) public virtual override {
1399         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1400         _safeTransfer(from, to, tokenId, data);
1401     }
1402 
1403     /**
1404      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1405      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1406      *
1407      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1408      *
1409      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1410      * implement alternative mechanisms to perform token transfer, such as signature-based.
1411      *
1412      * Requirements:
1413      *
1414      * - `from` cannot be the zero address.
1415      * - `to` cannot be the zero address.
1416      * - `tokenId` token must exist and be owned by `from`.
1417      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1418      *
1419      * Emits a {Transfer} event.
1420      */
1421     function _safeTransfer(
1422         address from,
1423         address to,
1424         uint256 tokenId,
1425         bytes memory data
1426     ) internal virtual {
1427         _transfer(from, to, tokenId);
1428         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1429     }
1430 
1431     /**
1432      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1433      */
1434     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1435         return _owners[tokenId];
1436     }
1437 
1438     /**
1439      * @dev Returns whether `tokenId` exists.
1440      *
1441      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1442      *
1443      * Tokens start existing when they are minted (`_mint`),
1444      * and stop existing when they are burned (`_burn`).
1445      */
1446     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1447         return _ownerOf(tokenId) != address(0);
1448     }
1449 
1450     /**
1451      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1452      *
1453      * Requirements:
1454      *
1455      * - `tokenId` must exist.
1456      */
1457     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1458         address owner = ERC721.ownerOf(tokenId);
1459         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1460     }
1461 
1462     /**
1463      * @dev Safely mints `tokenId` and transfers it to `to`.
1464      *
1465      * Requirements:
1466      *
1467      * - `tokenId` must not exist.
1468      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1469      *
1470      * Emits a {Transfer} event.
1471      */
1472     function _safeMint(address to, uint256 tokenId) internal virtual {
1473         _safeMint(to, tokenId, "");
1474     }
1475 
1476     /**
1477      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1478      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1479      */
1480     function _safeMint(
1481         address to,
1482         uint256 tokenId,
1483         bytes memory data
1484     ) internal virtual {
1485         _mint(to, tokenId);
1486         require(
1487             _checkOnERC721Received(address(0), to, tokenId, data),
1488             "ERC721: transfer to non ERC721Receiver implementer"
1489         );
1490     }
1491 
1492     /**
1493      * @dev Mints `tokenId` and transfers it to `to`.
1494      *
1495      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1496      *
1497      * Requirements:
1498      *
1499      * - `tokenId` must not exist.
1500      * - `to` cannot be the zero address.
1501      *
1502      * Emits a {Transfer} event.
1503      */
1504     function _mint(address to, uint256 tokenId) internal virtual {
1505         require(to != address(0), "ERC721: mint to the zero address");
1506         require(!_exists(tokenId), "ERC721: token already minted");
1507 
1508         _beforeTokenTransfer(address(0), to, tokenId, 1);
1509 
1510         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1511         require(!_exists(tokenId), "ERC721: token already minted");
1512 
1513         unchecked {
1514             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1515             // Given that tokens are minted one by one, it is impossible in practice that
1516             // this ever happens. Might change if we allow batch minting.
1517             // The ERC fails to describe this case.
1518             _balances[to] += 1;
1519         }
1520 
1521         _owners[tokenId] = to;
1522 
1523         emit Transfer(address(0), to, tokenId);
1524 
1525         _afterTokenTransfer(address(0), to, tokenId, 1);
1526     }
1527 
1528     /**
1529      * @dev Destroys `tokenId`.
1530      * The approval is cleared when the token is burned.
1531      * This is an internal function that does not check if the sender is authorized to operate on the token.
1532      *
1533      * Requirements:
1534      *
1535      * - `tokenId` must exist.
1536      *
1537      * Emits a {Transfer} event.
1538      */
1539     function _burn(uint256 tokenId) internal virtual {
1540         address owner = ERC721.ownerOf(tokenId);
1541 
1542         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1543 
1544         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1545         owner = ERC721.ownerOf(tokenId);
1546 
1547         // Clear approvals
1548         delete _tokenApprovals[tokenId];
1549 
1550         unchecked {
1551             // Cannot overflow, as that would require more tokens to be burned/transferred
1552             // out than the owner initially received through minting and transferring in.
1553             _balances[owner] -= 1;
1554         }
1555         delete _owners[tokenId];
1556 
1557         emit Transfer(owner, address(0), tokenId);
1558 
1559         _afterTokenTransfer(owner, address(0), tokenId, 1);
1560     }
1561 
1562     /**
1563      * @dev Transfers `tokenId` from `from` to `to`.
1564      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1565      *
1566      * Requirements:
1567      *
1568      * - `to` cannot be the zero address.
1569      * - `tokenId` token must be owned by `from`.
1570      *
1571      * Emits a {Transfer} event.
1572      */
1573     function _transfer(
1574         address from,
1575         address to,
1576         uint256 tokenId
1577     ) internal virtual {
1578         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1579         require(to != address(0), "ERC721: transfer to the zero address");
1580 
1581         _beforeTokenTransfer(from, to, tokenId, 1);
1582 
1583         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1584         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1585 
1586         // Clear approvals from the previous owner
1587         delete _tokenApprovals[tokenId];
1588 
1589         unchecked {
1590             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1591             // `from`'s balance is the number of token held, which is at least one before the current
1592             // transfer.
1593             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1594             // all 2**256 token ids to be minted, which in practice is impossible.
1595             _balances[from] -= 1;
1596             _balances[to] += 1;
1597         }
1598         _owners[tokenId] = to;
1599 
1600         emit Transfer(from, to, tokenId);
1601 
1602         _afterTokenTransfer(from, to, tokenId, 1);
1603     }
1604 
1605     /**
1606      * @dev Approve `to` to operate on `tokenId`
1607      *
1608      * Emits an {Approval} event.
1609      */
1610     function _approve(address to, uint256 tokenId) internal virtual {
1611         _tokenApprovals[tokenId] = to;
1612         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1613     }
1614 
1615     /**
1616      * @dev Approve `operator` to operate on all of `owner` tokens
1617      *
1618      * Emits an {ApprovalForAll} event.
1619      */
1620     function _setApprovalForAll(
1621         address owner,
1622         address operator,
1623         bool approved
1624     ) internal virtual {
1625         require(owner != operator, "ERC721: approve to caller");
1626         _operatorApprovals[owner][operator] = approved;
1627         emit ApprovalForAll(owner, operator, approved);
1628     }
1629 
1630     /**
1631      * @dev Reverts if the `tokenId` has not been minted yet.
1632      */
1633     function _requireMinted(uint256 tokenId) internal view virtual {
1634         require(_exists(tokenId), "ERC721: invalid token ID");
1635     }
1636 
1637     /**
1638      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1639      * The call is not executed if the target address is not a contract.
1640      *
1641      * @param from address representing the previous owner of the given token ID
1642      * @param to target address that will receive the tokens
1643      * @param tokenId uint256 ID of the token to be transferred
1644      * @param data bytes optional data to send along with the call
1645      * @return bool whether the call correctly returned the expected magic value
1646      */
1647     function _checkOnERC721Received(
1648         address from,
1649         address to,
1650         uint256 tokenId,
1651         bytes memory data
1652     ) private returns (bool) {
1653         if (to.isContract()) {
1654             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1655                 return retval == IERC721Receiver.onERC721Received.selector;
1656             } catch (bytes memory reason) {
1657                 if (reason.length == 0) {
1658                     revert("ERC721: transfer to non ERC721Receiver implementer");
1659                 } else {
1660                     /// @solidity memory-safe-assembly
1661                     assembly {
1662                         revert(add(32, reason), mload(reason))
1663                     }
1664                 }
1665             }
1666         } else {
1667             return true;
1668         }
1669     }
1670 
1671     /**
1672      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1673      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1674      *
1675      * Calling conditions:
1676      *
1677      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1678      * - When `from` is zero, the tokens will be minted for `to`.
1679      * - When `to` is zero, ``from``'s tokens will be burned.
1680      * - `from` and `to` are never both zero.
1681      * - `batchSize` is non-zero.
1682      *
1683      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1684      */
1685     function _beforeTokenTransfer(
1686         address from,
1687         address to,
1688         uint256, /* firstTokenId */
1689         uint256 batchSize
1690     ) internal virtual {
1691         if (batchSize > 1) {
1692             if (from != address(0)) {
1693                 _balances[from] -= batchSize;
1694             }
1695             if (to != address(0)) {
1696                 _balances[to] += batchSize;
1697             }
1698         }
1699     }
1700 
1701     /**
1702      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1703      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1704      *
1705      * Calling conditions:
1706      *
1707      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1708      * - When `from` is zero, the tokens were minted for `to`.
1709      * - When `to` is zero, ``from``'s tokens were burned.
1710      * - `from` and `to` are never both zero.
1711      * - `batchSize` is non-zero.
1712      *
1713      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1714      */
1715     function _afterTokenTransfer(
1716         address from,
1717         address to,
1718         uint256 firstTokenId,
1719         uint256 batchSize
1720     ) internal virtual {}
1721 }
1722 
1723 
1724 // File contracts/QuirkiesComicsVol1.sol
1725 
1726 
1727 
1728 
1729 
1730 
1731 
1732 
1733 
1734 
1735 
1736 
1737 
1738 
1739 pragma solidity ^0.8.0;
1740 
1741 contract QuirkiesComicsVol1 is DefaultOperatorFilterer, Ownable, ERC721, ReentrancyGuard {
1742     uint256 public nftPrice = 0 ether;
1743     uint256 public totalSupply = 0;
1744 
1745     uint256 public constant nftLimit = 5000;
1746     uint256 public constant claimLimit = 5000;
1747 
1748     bool public saleClaim = false;
1749 
1750     address public claimAddressOG;
1751     address public claimAddressLING;
1752     uint256 public mintCount = 0;
1753 
1754     string public baseURI = "";
1755     mapping(uint256 => uint256) public claimedTokens;
1756 
1757     constructor(
1758         string memory _initURI,
1759         address _claimAddressOG,
1760         address _claimAddressLING
1761     ) ERC721("QuirkiesComicsVol1", "QRKC") {
1762         baseURI = _initURI;
1763         claimAddressOG = _claimAddressOG;
1764         claimAddressLING = _claimAddressLING;
1765     }
1766 
1767     function mintClaim(uint256[] memory _tokenIds) public nonReentrant {
1768         require(saleClaim == true, "QuirkComic: Not Started");
1769         for (uint256 i = 0; i < _tokenIds.length; i++) {
1770             uint256 _tokenId = _tokenIds[i];
1771             require(
1772                 IERC721(claimAddressOG).ownerOf(_tokenId) == _msgSender(),
1773                 "QuirkComic: Not Quirkies Token Owner"
1774             );
1775             require(
1776                 IERC721(claimAddressLING).ownerOf(_tokenId) == _msgSender(),
1777                 "QuirkComic: Not QuirkLings Token Owner"
1778             );
1779             require(
1780                 claimedTokens[_tokenId] == 0,
1781                 "QuirkComic: Token Already Claimed"
1782             );
1783             claimedTokens[_tokenId] = 1;
1784             _safeMint(_msgSender(), _tokenId);
1785         }
1786         totalSupply += _tokenIds.length;
1787     }
1788 
1789     function tokensOfOwnerByIndex(address _owner, uint256 _index)
1790         public
1791         view
1792         returns (uint256)
1793     {
1794         return tokensOfOwner(_owner)[_index];
1795     }
1796 
1797     function tokensOfOwner(address _owner)
1798         public
1799         view
1800         returns (uint256[] memory)
1801     {
1802         uint256 _tokenCount = balanceOf(_owner);
1803         uint256[] memory _tokenIds = new uint256[](_tokenCount);
1804         uint256 _tokenIndex = 0;
1805         for (uint256 i = 0; i < nftLimit; i++) {
1806             if (_exists(i) && ownerOf(i) == _owner) {
1807                 _tokenIds[_tokenIndex] = i;
1808                 _tokenIndex++;
1809             }
1810         }
1811         return _tokenIds;
1812     }
1813 
1814     function tokenClaimStatus(uint256[] calldata _tokenIds)
1815         public
1816         view
1817         returns (uint256[] memory)
1818     {
1819         uint256[] memory claimed = new uint256[](_tokenIds.length);
1820         for (uint256 i = 0; i < _tokenIds.length; i++) {
1821             claimed[i] = claimedTokens[_tokenIds[i]];
1822         }
1823         return claimed;
1824     }
1825 
1826     function withdraw() public payable onlyOwner {
1827         uint256 _balance = address(this).balance;
1828         address TEAM3 = 0xd56f05CaB51a36e5b17a8e06f4bB286a8104aE98;
1829         address TEAM2 = 0x1c46a964f9404193AFf03769559cAe1cbDE9e82d;
1830         address TEAM1 = 0xa176cBefedb9dbF436BfEFC102e4120aa2e9FC9b;
1831 
1832         (bool team3tx, ) = payable(TEAM3).call{value: (_balance * 15) / 100}(
1833             ""
1834         );
1835         require(team3tx, "QuirkiesComicsVol1: Transfer 3 Failed");
1836 
1837         (bool team2tx, ) = payable(TEAM2).call{value: (_balance * 45) / 100}(
1838             ""
1839         );
1840         require(team2tx, "QuirkiesComicsVol1: Transfer 2 Failed");
1841 
1842         (bool team1tx, ) = payable(TEAM1).call{value: address(this).balance}(
1843             ""
1844         );
1845         require(team1tx, "QuirkiesComicsVol1: Transfer 1 Failed");
1846     }
1847 
1848     function toggleSaleClaim() public onlyOwner {
1849         saleClaim = !saleClaim;
1850     }
1851 
1852     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1853         baseURI = _newBaseURI;
1854     }
1855 
1856     function _baseURI() internal view virtual override returns (string memory) {
1857         return baseURI;
1858     }
1859 
1860     function contractURI() public view returns (string memory) {
1861         return string(abi.encodePacked(baseURI, "contract"));
1862     }
1863 
1864     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1865         super.transferFrom(from, to, tokenId);
1866     }
1867 
1868     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1869         super.safeTransferFrom(from, to, tokenId);
1870     }
1871 
1872     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1873         public
1874         override
1875         onlyAllowedOperator(from)
1876     {
1877         super.safeTransferFrom(from, to, tokenId, data);
1878     }
1879 
1880 }