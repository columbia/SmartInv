1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Contract module that helps prevent reentrant calls to a function.
5  *
6  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
7  * available, which can be applied to functions to make sure there are no nested
8  * (reentrant) calls to them.
9  *
10  * Note that because there is a single `nonReentrant` guard, functions marked as
11  * `nonReentrant` may not call one another. This can be worked around by making
12  * those functions `private`, and then adding `external` `nonReentrant` entry
13  * points to them.
14  *
15  * TIP: If you would like to learn more about reentrancy and alternative ways
16  * to protect against it, check out our blog post
17  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
18  */
19 abstract contract ReentrancyGuard {
20     // Booleans are more expensive than uint256 or any type that takes up a full
21     // word because each write operation emits an extra SLOAD to first read the
22     // slot's contents, replace the bits taken up by the boolean, and then write
23     // back. This is the compiler's defense against contract upgrades and
24     // pointer aliasing, and it cannot be disabled.
25 
26     // The values being non-zero value makes deployment a bit more expensive,
27     // but in exchange the refund on every call to nonReentrant will be lower in
28     // amount. Since refunds are capped to a percentage of the total
29     // transaction's gas, it is best to keep them low in cases like this one, to
30     // increase the likelihood of the full refund coming into effect.
31     uint256 private constant _NOT_ENTERED = 1;
32     uint256 private constant _ENTERED = 2;
33 
34     uint256 private _status;
35 
36     constructor() {
37         _status = _NOT_ENTERED;
38     }
39 
40     /**
41      * @dev Prevents a contract from calling itself, directly or indirectly.
42      * Calling a `nonReentrant` function from another `nonReentrant`
43      * function is not supported. It is possible to prevent this from happening
44      * by making the `nonReentrant` function external, and making it call a
45      * `private` function that does the actual work.
46      */
47     modifier nonReentrant() {
48         _nonReentrantBefore();
49         _;
50         _nonReentrantAfter();
51     }
52 
53     function _nonReentrantBefore() private {
54         // On the first call to nonReentrant, _status will be _NOT_ENTERED
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59     }
60 
61     function _nonReentrantAfter() private {
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Address.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
72 
73 pragma solidity ^0.8.1;
74 
75 /**
76  * @dev Collection of functions related to the address type
77  */
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      *
96      * [IMPORTANT]
97      * ====
98      * You shouldn't rely on `isContract` to protect against flash loan attacks!
99      *
100      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
101      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
102      * constructor.
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies on extcodesize/address.code.length, which returns 0
107         // for contracts in construction, since the code is only stored at the end
108         // of the constructor execution.
109 
110         return account.code.length > 0;
111     }
112 
113     /**
114      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
115      * `recipient`, forwarding all available gas and reverting on errors.
116      *
117      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
118      * of certain opcodes, possibly making contracts go over the 2300 gas limit
119      * imposed by `transfer`, making them unable to receive funds via
120      * `transfer`. {sendValue} removes this limitation.
121      *
122      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
123      *
124      * IMPORTANT: because control is transferred to `recipient`, care must be
125      * taken to not create reentrancy vulnerabilities. Consider using
126      * {ReentrancyGuard} or the
127      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
128      */
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(address(this).balance >= amount, "Address: insufficient balance");
131 
132         (bool success, ) = recipient.call{value: amount}("");
133         require(success, "Address: unable to send value, recipient may have reverted");
134     }
135 
136     /**
137      * @dev Performs a Solidity function call using a low level `call`. A
138      * plain `call` is an unsafe replacement for a function call: use this
139      * function instead.
140      *
141      * If `target` reverts with a revert reason, it is bubbled up by this
142      * function (like regular Solidity function calls).
143      *
144      * Returns the raw returned data. To convert to the expected return value,
145      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
146      *
147      * Requirements:
148      *
149      * - `target` must be a contract.
150      * - calling `target` with `data` must not revert.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
155         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
160      * `errorMessage` as a fallback revert reason when `target` reverts.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         return functionCallWithValue(target, data, 0, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but also transferring `value` wei to `target`.
175      *
176      * Requirements:
177      *
178      * - the calling contract must have an ETH balance of at least `value`.
179      * - the called Solidity function must be `payable`.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         require(address(this).balance >= value, "Address: insufficient balance for call");
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         (bool success, bytes memory returndata) = target.staticcall(data);
230         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a delegate call.
236      *
237      * _Available since v3.4._
238      */
239     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
240         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         (bool success, bytes memory returndata) = target.delegatecall(data);
255         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
260      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
261      *
262      * _Available since v4.8._
263      */
264     function verifyCallResultFromTarget(
265         address target,
266         bool success,
267         bytes memory returndata,
268         string memory errorMessage
269     ) internal view returns (bytes memory) {
270         if (success) {
271             if (returndata.length == 0) {
272                 // only check isContract if the call was successful and the return data is empty
273                 // otherwise we already know that it was a contract
274                 require(isContract(target), "Address: call to non-contract");
275             }
276             return returndata;
277         } else {
278             _revert(returndata, errorMessage);
279         }
280     }
281 
282     /**
283      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
284      * revert reason or using the provided one.
285      *
286      * _Available since v4.3._
287      */
288     function verifyCallResult(
289         bool success,
290         bytes memory returndata,
291         string memory errorMessage
292     ) internal pure returns (bytes memory) {
293         if (success) {
294             return returndata;
295         } else {
296             _revert(returndata, errorMessage);
297         }
298     }
299 
300     function _revert(bytes memory returndata, string memory errorMessage) private pure {
301         // Look for revert reason and bubble it up if present
302         if (returndata.length > 0) {
303             // The easiest way to bubble the revert reason is using memory via assembly
304             /// @solidity memory-safe-assembly
305             assembly {
306                 let returndata_size := mload(returndata)
307                 revert(add(32, returndata), returndata_size)
308             }
309         } else {
310             revert(errorMessage);
311         }
312     }
313 }
314 
315 // File: @openzeppelin/contracts/utils/math/Math.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 /**
323  * @dev Standard math utilities missing in the Solidity language.
324  */
325 library Math {
326     enum Rounding {
327         Down, // Toward negative infinity
328         Up, // Toward infinity
329         Zero // Toward zero
330     }
331 
332     /**
333      * @dev Returns the largest of two numbers.
334      */
335     function max(uint256 a, uint256 b) internal pure returns (uint256) {
336         return a > b ? a : b;
337     }
338 
339     /**
340      * @dev Returns the smallest of two numbers.
341      */
342     function min(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a < b ? a : b;
344     }
345 
346     /**
347      * @dev Returns the average of two numbers. The result is rounded towards
348      * zero.
349      */
350     function average(uint256 a, uint256 b) internal pure returns (uint256) {
351         // (a + b) / 2 can overflow.
352         return (a & b) + (a ^ b) / 2;
353     }
354 
355     /**
356      * @dev Returns the ceiling of the division of two numbers.
357      *
358      * This differs from standard division with `/` in that it rounds up instead
359      * of rounding down.
360      */
361     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
362         // (a + b - 1) / b can overflow on addition, so we distribute.
363         return a == 0 ? 0 : (a - 1) / b + 1;
364     }
365 
366     /**
367      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
368      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
369      * with further edits by Uniswap Labs also under MIT license.
370      */
371     function mulDiv(
372         uint256 x,
373         uint256 y,
374         uint256 denominator
375     ) internal pure returns (uint256 result) {
376         unchecked {
377             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
378             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
379             // variables such that product = prod1 * 2^256 + prod0.
380             uint256 prod0; // Least significant 256 bits of the product
381             uint256 prod1; // Most significant 256 bits of the product
382             assembly {
383                 let mm := mulmod(x, y, not(0))
384                 prod0 := mul(x, y)
385                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
386             }
387 
388             // Handle non-overflow cases, 256 by 256 division.
389             if (prod1 == 0) {
390                 return prod0 / denominator;
391             }
392 
393             // Make sure the result is less than 2^256. Also prevents denominator == 0.
394             require(denominator > prod1);
395 
396             ///////////////////////////////////////////////
397             // 512 by 256 division.
398             ///////////////////////////////////////////////
399 
400             // Make division exact by subtracting the remainder from [prod1 prod0].
401             uint256 remainder;
402             assembly {
403                 // Compute remainder using mulmod.
404                 remainder := mulmod(x, y, denominator)
405 
406                 // Subtract 256 bit number from 512 bit number.
407                 prod1 := sub(prod1, gt(remainder, prod0))
408                 prod0 := sub(prod0, remainder)
409             }
410 
411             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
412             // See https://cs.stackexchange.com/q/138556/92363.
413 
414             // Does not overflow because the denominator cannot be zero at this stage in the function.
415             uint256 twos = denominator & (~denominator + 1);
416             assembly {
417                 // Divide denominator by twos.
418                 denominator := div(denominator, twos)
419 
420                 // Divide [prod1 prod0] by twos.
421                 prod0 := div(prod0, twos)
422 
423                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
424                 twos := add(div(sub(0, twos), twos), 1)
425             }
426 
427             // Shift in bits from prod1 into prod0.
428             prod0 |= prod1 * twos;
429 
430             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
431             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
432             // four bits. That is, denominator * inv = 1 mod 2^4.
433             uint256 inverse = (3 * denominator) ^ 2;
434 
435             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
436             // in modular arithmetic, doubling the correct bits in each step.
437             inverse *= 2 - denominator * inverse; // inverse mod 2^8
438             inverse *= 2 - denominator * inverse; // inverse mod 2^16
439             inverse *= 2 - denominator * inverse; // inverse mod 2^32
440             inverse *= 2 - denominator * inverse; // inverse mod 2^64
441             inverse *= 2 - denominator * inverse; // inverse mod 2^128
442             inverse *= 2 - denominator * inverse; // inverse mod 2^256
443 
444             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
445             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
446             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
447             // is no longer required.
448             result = prod0 * inverse;
449             return result;
450         }
451     }
452 
453     /**
454      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
455      */
456     function mulDiv(
457         uint256 x,
458         uint256 y,
459         uint256 denominator,
460         Rounding rounding
461     ) internal pure returns (uint256) {
462         uint256 result = mulDiv(x, y, denominator);
463         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
464             result += 1;
465         }
466         return result;
467     }
468 
469     /**
470      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
471      *
472      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
473      */
474     function sqrt(uint256 a) internal pure returns (uint256) {
475         if (a == 0) {
476             return 0;
477         }
478 
479         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
480         //
481         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
482         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
483         //
484         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
485         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
486         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
487         //
488         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
489         uint256 result = 1 << (log2(a) >> 1);
490 
491         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
492         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
493         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
494         // into the expected uint128 result.
495         unchecked {
496             result = (result + a / result) >> 1;
497             result = (result + a / result) >> 1;
498             result = (result + a / result) >> 1;
499             result = (result + a / result) >> 1;
500             result = (result + a / result) >> 1;
501             result = (result + a / result) >> 1;
502             result = (result + a / result) >> 1;
503             return min(result, a / result);
504         }
505     }
506 
507     /**
508      * @notice Calculates sqrt(a), following the selected rounding direction.
509      */
510     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
511         unchecked {
512             uint256 result = sqrt(a);
513             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
514         }
515     }
516 
517     /**
518      * @dev Return the log in base 2, rounded down, of a positive value.
519      * Returns 0 if given 0.
520      */
521     function log2(uint256 value) internal pure returns (uint256) {
522         uint256 result = 0;
523         unchecked {
524             if (value >> 128 > 0) {
525                 value >>= 128;
526                 result += 128;
527             }
528             if (value >> 64 > 0) {
529                 value >>= 64;
530                 result += 64;
531             }
532             if (value >> 32 > 0) {
533                 value >>= 32;
534                 result += 32;
535             }
536             if (value >> 16 > 0) {
537                 value >>= 16;
538                 result += 16;
539             }
540             if (value >> 8 > 0) {
541                 value >>= 8;
542                 result += 8;
543             }
544             if (value >> 4 > 0) {
545                 value >>= 4;
546                 result += 4;
547             }
548             if (value >> 2 > 0) {
549                 value >>= 2;
550                 result += 2;
551             }
552             if (value >> 1 > 0) {
553                 result += 1;
554             }
555         }
556         return result;
557     }
558 
559     /**
560      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
561      * Returns 0 if given 0.
562      */
563     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
564         unchecked {
565             uint256 result = log2(value);
566             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
567         }
568     }
569 
570     /**
571      * @dev Return the log in base 10, rounded down, of a positive value.
572      * Returns 0 if given 0.
573      */
574     function log10(uint256 value) internal pure returns (uint256) {
575         uint256 result = 0;
576         unchecked {
577             if (value >= 10**64) {
578                 value /= 10**64;
579                 result += 64;
580             }
581             if (value >= 10**32) {
582                 value /= 10**32;
583                 result += 32;
584             }
585             if (value >= 10**16) {
586                 value /= 10**16;
587                 result += 16;
588             }
589             if (value >= 10**8) {
590                 value /= 10**8;
591                 result += 8;
592             }
593             if (value >= 10**4) {
594                 value /= 10**4;
595                 result += 4;
596             }
597             if (value >= 10**2) {
598                 value /= 10**2;
599                 result += 2;
600             }
601             if (value >= 10**1) {
602                 result += 1;
603             }
604         }
605         return result;
606     }
607 
608     /**
609      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
610      * Returns 0 if given 0.
611      */
612     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
613         unchecked {
614             uint256 result = log10(value);
615             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
616         }
617     }
618 
619     /**
620      * @dev Return the log in base 256, rounded down, of a positive value.
621      * Returns 0 if given 0.
622      *
623      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
624      */
625     function log256(uint256 value) internal pure returns (uint256) {
626         uint256 result = 0;
627         unchecked {
628             if (value >> 128 > 0) {
629                 value >>= 128;
630                 result += 16;
631             }
632             if (value >> 64 > 0) {
633                 value >>= 64;
634                 result += 8;
635             }
636             if (value >> 32 > 0) {
637                 value >>= 32;
638                 result += 4;
639             }
640             if (value >> 16 > 0) {
641                 value >>= 16;
642                 result += 2;
643             }
644             if (value >> 8 > 0) {
645                 result += 1;
646             }
647         }
648         return result;
649     }
650 
651     /**
652      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
653      * Returns 0 if given 0.
654      */
655     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
656         unchecked {
657             uint256 result = log256(value);
658             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
659         }
660     }
661 }
662 
663 // File: @openzeppelin/contracts/utils/Strings.sol
664 
665 
666 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @dev String operations.
673  */
674 library Strings {
675     bytes16 private constant _SYMBOLS = "0123456789abcdef";
676     uint8 private constant _ADDRESS_LENGTH = 20;
677 
678     /**
679      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
680      */
681     function toString(uint256 value) internal pure returns (string memory) {
682         unchecked {
683             uint256 length = Math.log10(value) + 1;
684             string memory buffer = new string(length);
685             uint256 ptr;
686             /// @solidity memory-safe-assembly
687             assembly {
688                 ptr := add(buffer, add(32, length))
689             }
690             while (true) {
691                 ptr--;
692                 /// @solidity memory-safe-assembly
693                 assembly {
694                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
695                 }
696                 value /= 10;
697                 if (value == 0) break;
698             }
699             return buffer;
700         }
701     }
702 
703     /**
704      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
705      */
706     function toHexString(uint256 value) internal pure returns (string memory) {
707         unchecked {
708             return toHexString(value, Math.log256(value) + 1);
709         }
710     }
711 
712     /**
713      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
714      */
715     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
716         bytes memory buffer = new bytes(2 * length + 2);
717         buffer[0] = "0";
718         buffer[1] = "x";
719         for (uint256 i = 2 * length + 1; i > 1; --i) {
720             buffer[i] = _SYMBOLS[value & 0xf];
721             value >>= 4;
722         }
723         require(value == 0, "Strings: hex length insufficient");
724         return string(buffer);
725     }
726 
727     /**
728      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
729      */
730     function toHexString(address addr) internal pure returns (string memory) {
731         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
732     }
733 }
734 
735 // File: @openzeppelin/contracts/utils/Context.sol
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 /**
743  * @dev Provides information about the current execution context, including the
744  * sender of the transaction and its data. While these are generally available
745  * via msg.sender and msg.data, they should not be accessed in such a direct
746  * manner, since when dealing with meta-transactions the account sending and
747  * paying for execution may not be the actual sender (as far as an application
748  * is concerned).
749  *
750  * This contract is only required for intermediate, library-like contracts.
751  */
752 abstract contract Context {
753     function _msgSender() internal view virtual returns (address) {
754         return msg.sender;
755     }
756 
757     function _msgData() internal view virtual returns (bytes calldata) {
758         return msg.data;
759     }
760 }
761 
762 // File: @openzeppelin/contracts/access/Ownable.sol
763 
764 
765 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
766 
767 pragma solidity ^0.8.0;
768 
769 
770 /**
771  * @dev Contract module which provides a basic access control mechanism, where
772  * there is an account (an owner) that can be granted exclusive access to
773  * specific functions.
774  *
775  * By default, the owner account will be the one that deploys the contract. This
776  * can later be changed with {transferOwnership}.
777  *
778  * This module is used through inheritance. It will make available the modifier
779  * `onlyOwner`, which can be applied to your functions to restrict their use to
780  * the owner.
781  */
782 abstract contract Ownable is Context {
783     address private _owner;
784 
785     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
786 
787     /**
788      * @dev Initializes the contract setting the deployer as the initial owner.
789      */
790     constructor() {
791         _transferOwnership(_msgSender());
792     }
793 
794     /**
795      * @dev Throws if called by any account other than the owner.
796      */
797     modifier onlyOwner() {
798         _checkOwner();
799         _;
800     }
801 
802     /**
803      * @dev Returns the address of the current owner.
804      */
805     function owner() public view virtual returns (address) {
806         return _owner;
807     }
808 
809     /**
810      * @dev Throws if the sender is not the owner.
811      */
812     function _checkOwner() internal view virtual {
813         require(owner() == _msgSender(), "Ownable: caller is not the owner");
814     }
815 
816     /**
817      * @dev Leaves the contract without owner. It will not be possible to call
818      * `onlyOwner` functions anymore. Can only be called by the current owner.
819      *
820      * NOTE: Renouncing ownership will leave the contract without an owner,
821      * thereby removing any functionality that is only available to the owner.
822      */
823     function renounceOwnership() public virtual onlyOwner {
824         _transferOwnership(address(0));
825     }
826 
827     /**
828      * @dev Transfers ownership of the contract to a new account (`newOwner`).
829      * Can only be called by the current owner.
830      */
831     function transferOwnership(address newOwner) public virtual onlyOwner {
832         require(newOwner != address(0), "Ownable: new owner is the zero address");
833         _transferOwnership(newOwner);
834     }
835 
836     /**
837      * @dev Transfers ownership of the contract to a new account (`newOwner`).
838      * Internal function without access restriction.
839      */
840     function _transferOwnership(address newOwner) internal virtual {
841         address oldOwner = _owner;
842         _owner = newOwner;
843         emit OwnershipTransferred(oldOwner, newOwner);
844     }
845 }
846 
847 // File: erc721a/contracts/IERC721A.sol
848 
849 
850 // ERC721A Contracts v4.2.3
851 // Creator: Chiru Labs
852 
853 pragma solidity ^0.8.4;
854 
855 /**
856  * @dev Interface of ERC721A.
857  */
858 interface IERC721A {
859     /**
860      * The caller must own the token or be an approved operator.
861      */
862     error ApprovalCallerNotOwnerNorApproved();
863 
864     /**
865      * The token does not exist.
866      */
867     error ApprovalQueryForNonexistentToken();
868 
869     /**
870      * Cannot query the balance for the zero address.
871      */
872     error BalanceQueryForZeroAddress();
873 
874     /**
875      * Cannot mint to the zero address.
876      */
877     error MintToZeroAddress();
878 
879     /**
880      * The quantity of tokens minted must be more than zero.
881      */
882     error MintZeroQuantity();
883 
884     /**
885      * The token does not exist.
886      */
887     error OwnerQueryForNonexistentToken();
888 
889     /**
890      * The caller must own the token or be an approved operator.
891      */
892     error TransferCallerNotOwnerNorApproved();
893 
894     /**
895      * The token must be owned by `from`.
896      */
897     error TransferFromIncorrectOwner();
898 
899     /**
900      * Cannot safely transfer to a contract that does not implement the
901      * ERC721Receiver interface.
902      */
903     error TransferToNonERC721ReceiverImplementer();
904 
905     /**
906      * Cannot transfer to the zero address.
907      */
908     error TransferToZeroAddress();
909 
910     /**
911      * The token does not exist.
912      */
913     error URIQueryForNonexistentToken();
914 
915     /**
916      * The `quantity` minted with ERC2309 exceeds the safety limit.
917      */
918     error MintERC2309QuantityExceedsLimit();
919 
920     /**
921      * The `extraData` cannot be set on an unintialized ownership slot.
922      */
923     error OwnershipNotInitializedForExtraData();
924 
925     // =============================================================
926     //                            STRUCTS
927     // =============================================================
928 
929     struct TokenOwnership {
930         // The address of the owner.
931         address addr;
932         // Stores the start time of ownership with minimal overhead for tokenomics.
933         uint64 startTimestamp;
934         // Whether the token has been burned.
935         bool burned;
936         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
937         uint24 extraData;
938     }
939 
940     // =============================================================
941     //                         TOKEN COUNTERS
942     // =============================================================
943 
944     /**
945      * @dev Returns the total number of tokens in existence.
946      * Burned tokens will reduce the count.
947      * To get the total number of tokens minted, please see {_totalMinted}.
948      */
949     function totalSupply() external view returns (uint256);
950 
951     // =============================================================
952     //                            IERC165
953     // =============================================================
954 
955     /**
956      * @dev Returns true if this contract implements the interface defined by
957      * `interfaceId`. See the corresponding
958      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
959      * to learn more about how these ids are created.
960      *
961      * This function call must use less than 30000 gas.
962      */
963     function supportsInterface(bytes4 interfaceId) external view returns (bool);
964 
965     // =============================================================
966     //                            IERC721
967     // =============================================================
968 
969     /**
970      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
971      */
972     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
973 
974     /**
975      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
976      */
977     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
978 
979     /**
980      * @dev Emitted when `owner` enables or disables
981      * (`approved`) `operator` to manage all of its assets.
982      */
983     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
984 
985     /**
986      * @dev Returns the number of tokens in `owner`'s account.
987      */
988     function balanceOf(address owner) external view returns (uint256 balance);
989 
990     /**
991      * @dev Returns the owner of the `tokenId` token.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must exist.
996      */
997     function ownerOf(uint256 tokenId) external view returns (address owner);
998 
999     /**
1000      * @dev Safely transfers `tokenId` token from `from` to `to`,
1001      * checking first that contract recipients are aware of the ERC721 protocol
1002      * to prevent tokens from being forever locked.
1003      *
1004      * Requirements:
1005      *
1006      * - `from` cannot be the zero address.
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must exist and be owned by `from`.
1009      * - If the caller is not `from`, it must be have been allowed to move
1010      * this token by either {approve} or {setApprovalForAll}.
1011      * - If `to` refers to a smart contract, it must implement
1012      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes calldata data
1021     ) external payable;
1022 
1023     /**
1024      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) external payable;
1031 
1032     /**
1033      * @dev Transfers `tokenId` from `from` to `to`.
1034      *
1035      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1036      * whenever possible.
1037      *
1038      * Requirements:
1039      *
1040      * - `from` cannot be the zero address.
1041      * - `to` cannot be the zero address.
1042      * - `tokenId` token must be owned by `from`.
1043      * - If the caller is not `from`, it must be approved to move this token
1044      * by either {approve} or {setApprovalForAll}.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function transferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) external payable;
1053 
1054     /**
1055      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1056      * The approval is cleared when the token is transferred.
1057      *
1058      * Only a single account can be approved at a time, so approving the
1059      * zero address clears previous approvals.
1060      *
1061      * Requirements:
1062      *
1063      * - The caller must own the token or be an approved operator.
1064      * - `tokenId` must exist.
1065      *
1066      * Emits an {Approval} event.
1067      */
1068     function approve(address to, uint256 tokenId) external payable;
1069 
1070     /**
1071      * @dev Approve or remove `operator` as an operator for the caller.
1072      * Operators can call {transferFrom} or {safeTransferFrom}
1073      * for any token owned by the caller.
1074      *
1075      * Requirements:
1076      *
1077      * - The `operator` cannot be the caller.
1078      *
1079      * Emits an {ApprovalForAll} event.
1080      */
1081     function setApprovalForAll(address operator, bool _approved) external;
1082 
1083     /**
1084      * @dev Returns the account approved for `tokenId` token.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      */
1090     function getApproved(uint256 tokenId) external view returns (address operator);
1091 
1092     /**
1093      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1094      *
1095      * See {setApprovalForAll}.
1096      */
1097     function isApprovedForAll(address owner, address operator) external view returns (bool);
1098 
1099     // =============================================================
1100     //                        IERC721Metadata
1101     // =============================================================
1102 
1103     /**
1104      * @dev Returns the token collection name.
1105      */
1106     function name() external view returns (string memory);
1107 
1108     /**
1109      * @dev Returns the token collection symbol.
1110      */
1111     function symbol() external view returns (string memory);
1112 
1113     /**
1114      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1115      */
1116     function tokenURI(uint256 tokenId) external view returns (string memory);
1117 
1118     // =============================================================
1119     //                           IERC2309
1120     // =============================================================
1121 
1122     /**
1123      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1124      * (inclusive) is transferred from `from` to `to`, as defined in the
1125      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1126      *
1127      * See {_mintERC2309} for more details.
1128      */
1129     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1130 }
1131 
1132 // File: erc721a/contracts/ERC721A.sol
1133 
1134 
1135 // ERC721A Contracts v4.2.3
1136 // Creator: Chiru Labs
1137 
1138 pragma solidity ^0.8.4;
1139 
1140 
1141 /**
1142  * @dev Interface of ERC721 token receiver.
1143  */
1144 interface ERC721A__IERC721Receiver {
1145     function onERC721Received(
1146         address operator,
1147         address from,
1148         uint256 tokenId,
1149         bytes calldata data
1150     ) external returns (bytes4);
1151 }
1152 
1153 /**
1154  * @title ERC721A
1155  *
1156  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1157  * Non-Fungible Token Standard, including the Metadata extension.
1158  * Optimized for lower gas during batch mints.
1159  *
1160  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1161  * starting from `_startTokenId()`.
1162  *
1163  * Assumptions:
1164  *
1165  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1166  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1167  */
1168 contract ERC721A is IERC721A {
1169     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1170     struct TokenApprovalRef {
1171         address value;
1172     }
1173 
1174     // =============================================================
1175     //                           CONSTANTS
1176     // =============================================================
1177 
1178     // Mask of an entry in packed address data.
1179     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1180 
1181     // The bit position of `numberMinted` in packed address data.
1182     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1183 
1184     // The bit position of `numberBurned` in packed address data.
1185     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1186 
1187     // The bit position of `aux` in packed address data.
1188     uint256 private constant _BITPOS_AUX = 192;
1189 
1190     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1191     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1192 
1193     // The bit position of `startTimestamp` in packed ownership.
1194     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1195 
1196     // The bit mask of the `burned` bit in packed ownership.
1197     uint256 private constant _BITMASK_BURNED = 1 << 224;
1198 
1199     // The bit position of the `nextInitialized` bit in packed ownership.
1200     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1201 
1202     // The bit mask of the `nextInitialized` bit in packed ownership.
1203     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1204 
1205     // The bit position of `extraData` in packed ownership.
1206     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1207 
1208     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1209     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1210 
1211     // The mask of the lower 160 bits for addresses.
1212     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1213 
1214     // The maximum `quantity` that can be minted with {_mintERC2309}.
1215     // This limit is to prevent overflows on the address data entries.
1216     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1217     // is required to cause an overflow, which is unrealistic.
1218     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1219 
1220     // The `Transfer` event signature is given by:
1221     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1222     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1223         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1224 
1225     // =============================================================
1226     //                            STORAGE
1227     // =============================================================
1228 
1229     // The next token ID to be minted.
1230     uint256 private _currentIndex;
1231 
1232     // The number of tokens burned.
1233     uint256 private _burnCounter;
1234 
1235     // Token name
1236     string private _name;
1237 
1238     // Token symbol
1239     string private _symbol;
1240 
1241     // Mapping from token ID to ownership details
1242     // An empty struct value does not necessarily mean the token is unowned.
1243     // See {_packedOwnershipOf} implementation for details.
1244     //
1245     // Bits Layout:
1246     // - [0..159]   `addr`
1247     // - [160..223] `startTimestamp`
1248     // - [224]      `burned`
1249     // - [225]      `nextInitialized`
1250     // - [232..255] `extraData`
1251     mapping(uint256 => uint256) private _packedOwnerships;
1252 
1253     // Mapping owner address to address data.
1254     //
1255     // Bits Layout:
1256     // - [0..63]    `balance`
1257     // - [64..127]  `numberMinted`
1258     // - [128..191] `numberBurned`
1259     // - [192..255] `aux`
1260     mapping(address => uint256) private _packedAddressData;
1261 
1262     // Mapping from token ID to approved address.
1263     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1264 
1265     // Mapping from owner to operator approvals
1266     mapping(address => mapping(address => bool)) private _operatorApprovals;
1267 
1268     // =============================================================
1269     //                          CONSTRUCTOR
1270     // =============================================================
1271 
1272     constructor(string memory name_, string memory symbol_) {
1273         _name = name_;
1274         _symbol = symbol_;
1275         _currentIndex = _startTokenId();
1276     }
1277 
1278     // =============================================================
1279     //                   TOKEN COUNTING OPERATIONS
1280     // =============================================================
1281 
1282     /**
1283      * @dev Returns the starting token ID.
1284      * To change the starting token ID, please override this function.
1285      */
1286     function _startTokenId() internal view virtual returns (uint256) {
1287         return 0;
1288     }
1289 
1290     /**
1291      * @dev Returns the next token ID to be minted.
1292      */
1293     function _nextTokenId() internal view virtual returns (uint256) {
1294         return _currentIndex;
1295     }
1296 
1297     /**
1298      * @dev Returns the total number of tokens in existence.
1299      * Burned tokens will reduce the count.
1300      * To get the total number of tokens minted, please see {_totalMinted}.
1301      */
1302     function totalSupply() public view virtual override returns (uint256) {
1303         // Counter underflow is impossible as _burnCounter cannot be incremented
1304         // more than `_currentIndex - _startTokenId()` times.
1305         unchecked {
1306             return _currentIndex - _burnCounter - _startTokenId();
1307         }
1308     }
1309 
1310     /**
1311      * @dev Returns the total amount of tokens minted in the contract.
1312      */
1313     function _totalMinted() internal view virtual returns (uint256) {
1314         // Counter underflow is impossible as `_currentIndex` does not decrement,
1315         // and it is initialized to `_startTokenId()`.
1316         unchecked {
1317             return _currentIndex - _startTokenId();
1318         }
1319     }
1320 
1321     /**
1322      * @dev Returns the total number of tokens burned.
1323      */
1324     function _totalBurned() internal view virtual returns (uint256) {
1325         return _burnCounter;
1326     }
1327 
1328     // =============================================================
1329     //                    ADDRESS DATA OPERATIONS
1330     // =============================================================
1331 
1332     /**
1333      * @dev Returns the number of tokens in `owner`'s account.
1334      */
1335     function balanceOf(address owner) public view virtual override returns (uint256) {
1336         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1337         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1338     }
1339 
1340     /**
1341      * Returns the number of tokens minted by `owner`.
1342      */
1343     function _numberMinted(address owner) internal view returns (uint256) {
1344         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1345     }
1346 
1347     /**
1348      * Returns the number of tokens burned by or on behalf of `owner`.
1349      */
1350     function _numberBurned(address owner) internal view returns (uint256) {
1351         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1352     }
1353 
1354     /**
1355      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1356      */
1357     function _getAux(address owner) internal view returns (uint64) {
1358         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1359     }
1360 
1361     /**
1362      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1363      * If there are multiple variables, please pack them into a uint64.
1364      */
1365     function _setAux(address owner, uint64 aux) internal virtual {
1366         uint256 packed = _packedAddressData[owner];
1367         uint256 auxCasted;
1368         // Cast `aux` with assembly to avoid redundant masking.
1369         assembly {
1370             auxCasted := aux
1371         }
1372         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1373         _packedAddressData[owner] = packed;
1374     }
1375 
1376     // =============================================================
1377     //                            IERC165
1378     // =============================================================
1379 
1380     /**
1381      * @dev Returns true if this contract implements the interface defined by
1382      * `interfaceId`. See the corresponding
1383      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1384      * to learn more about how these ids are created.
1385      *
1386      * This function call must use less than 30000 gas.
1387      */
1388     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1389         // The interface IDs are constants representing the first 4 bytes
1390         // of the XOR of all function selectors in the interface.
1391         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1392         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1393         return
1394             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1395             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1396             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1397     }
1398 
1399     // =============================================================
1400     //                        IERC721Metadata
1401     // =============================================================
1402 
1403     /**
1404      * @dev Returns the token collection name.
1405      */
1406     function name() public view virtual override returns (string memory) {
1407         return _name;
1408     }
1409 
1410     /**
1411      * @dev Returns the token collection symbol.
1412      */
1413     function symbol() public view virtual override returns (string memory) {
1414         return _symbol;
1415     }
1416 
1417     /**
1418      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1419      */
1420     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1421         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1422 
1423         string memory baseURI = _baseURI();
1424         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1425     }
1426 
1427     /**
1428      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1429      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1430      * by default, it can be overridden in child contracts.
1431      */
1432     function _baseURI() internal view virtual returns (string memory) {
1433         return '';
1434     }
1435 
1436     // =============================================================
1437     //                     OWNERSHIPS OPERATIONS
1438     // =============================================================
1439 
1440     /**
1441      * @dev Returns the owner of the `tokenId` token.
1442      *
1443      * Requirements:
1444      *
1445      * - `tokenId` must exist.
1446      */
1447     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1448         return address(uint160(_packedOwnershipOf(tokenId)));
1449     }
1450 
1451     /**
1452      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1453      * It gradually moves to O(1) as tokens get transferred around over time.
1454      */
1455     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1456         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1457     }
1458 
1459     /**
1460      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1461      */
1462     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1463         return _unpackedOwnership(_packedOwnerships[index]);
1464     }
1465 
1466     /**
1467      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1468      */
1469     function _initializeOwnershipAt(uint256 index) internal virtual {
1470         if (_packedOwnerships[index] == 0) {
1471             _packedOwnerships[index] = _packedOwnershipOf(index);
1472         }
1473     }
1474 
1475     /**
1476      * Returns the packed ownership data of `tokenId`.
1477      */
1478     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1479         uint256 curr = tokenId;
1480 
1481         unchecked {
1482             if (_startTokenId() <= curr)
1483                 if (curr < _currentIndex) {
1484                     uint256 packed = _packedOwnerships[curr];
1485                     // If not burned.
1486                     if (packed & _BITMASK_BURNED == 0) {
1487                         // Invariant:
1488                         // There will always be an initialized ownership slot
1489                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1490                         // before an unintialized ownership slot
1491                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1492                         // Hence, `curr` will not underflow.
1493                         //
1494                         // We can directly compare the packed value.
1495                         // If the address is zero, packed will be zero.
1496                         while (packed == 0) {
1497                             packed = _packedOwnerships[--curr];
1498                         }
1499                         return packed;
1500                     }
1501                 }
1502         }
1503         revert OwnerQueryForNonexistentToken();
1504     }
1505 
1506     /**
1507      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1508      */
1509     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1510         ownership.addr = address(uint160(packed));
1511         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1512         ownership.burned = packed & _BITMASK_BURNED != 0;
1513         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1514     }
1515 
1516     /**
1517      * @dev Packs ownership data into a single uint256.
1518      */
1519     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1520         assembly {
1521             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1522             owner := and(owner, _BITMASK_ADDRESS)
1523             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1524             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1525         }
1526     }
1527 
1528     /**
1529      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1530      */
1531     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1532         // For branchless setting of the `nextInitialized` flag.
1533         assembly {
1534             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1535             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1536         }
1537     }
1538 
1539     // =============================================================
1540     //                      APPROVAL OPERATIONS
1541     // =============================================================
1542 
1543     /**
1544      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1545      * The approval is cleared when the token is transferred.
1546      *
1547      * Only a single account can be approved at a time, so approving the
1548      * zero address clears previous approvals.
1549      *
1550      * Requirements:
1551      *
1552      * - The caller must own the token or be an approved operator.
1553      * - `tokenId` must exist.
1554      *
1555      * Emits an {Approval} event.
1556      */
1557     function approve(address to, uint256 tokenId) public payable virtual override {
1558         address owner = ownerOf(tokenId);
1559 
1560         if (_msgSenderERC721A() != owner)
1561             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1562                 revert ApprovalCallerNotOwnerNorApproved();
1563             }
1564 
1565         _tokenApprovals[tokenId].value = to;
1566         emit Approval(owner, to, tokenId);
1567     }
1568 
1569     /**
1570      * @dev Returns the account approved for `tokenId` token.
1571      *
1572      * Requirements:
1573      *
1574      * - `tokenId` must exist.
1575      */
1576     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1577         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1578 
1579         return _tokenApprovals[tokenId].value;
1580     }
1581 
1582     /**
1583      * @dev Approve or remove `operator` as an operator for the caller.
1584      * Operators can call {transferFrom} or {safeTransferFrom}
1585      * for any token owned by the caller.
1586      *
1587      * Requirements:
1588      *
1589      * - The `operator` cannot be the caller.
1590      *
1591      * Emits an {ApprovalForAll} event.
1592      */
1593     function setApprovalForAll(address operator, bool approved) public virtual override {
1594         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1595         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1596     }
1597 
1598     /**
1599      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1600      *
1601      * See {setApprovalForAll}.
1602      */
1603     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1604         return _operatorApprovals[owner][operator];
1605     }
1606 
1607     /**
1608      * @dev Returns whether `tokenId` exists.
1609      *
1610      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1611      *
1612      * Tokens start existing when they are minted. See {_mint}.
1613      */
1614     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1615         return
1616             _startTokenId() <= tokenId &&
1617             tokenId < _currentIndex && // If within bounds,
1618             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1619     }
1620 
1621     /**
1622      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1623      */
1624     function _isSenderApprovedOrOwner(
1625         address approvedAddress,
1626         address owner,
1627         address msgSender
1628     ) private pure returns (bool result) {
1629         assembly {
1630             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1631             owner := and(owner, _BITMASK_ADDRESS)
1632             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1633             msgSender := and(msgSender, _BITMASK_ADDRESS)
1634             // `msgSender == owner || msgSender == approvedAddress`.
1635             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1636         }
1637     }
1638 
1639     /**
1640      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1641      */
1642     function _getApprovedSlotAndAddress(uint256 tokenId)
1643         private
1644         view
1645         returns (uint256 approvedAddressSlot, address approvedAddress)
1646     {
1647         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1648         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1649         assembly {
1650             approvedAddressSlot := tokenApproval.slot
1651             approvedAddress := sload(approvedAddressSlot)
1652         }
1653     }
1654 
1655     // =============================================================
1656     //                      TRANSFER OPERATIONS
1657     // =============================================================
1658 
1659     /**
1660      * @dev Transfers `tokenId` from `from` to `to`.
1661      *
1662      * Requirements:
1663      *
1664      * - `from` cannot be the zero address.
1665      * - `to` cannot be the zero address.
1666      * - `tokenId` token must be owned by `from`.
1667      * - If the caller is not `from`, it must be approved to move this token
1668      * by either {approve} or {setApprovalForAll}.
1669      *
1670      * Emits a {Transfer} event.
1671      */
1672     function transferFrom(
1673         address from,
1674         address to,
1675         uint256 tokenId
1676     ) public payable virtual override {
1677         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1678 
1679         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1680 
1681         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1682 
1683         // The nested ifs save around 20+ gas over a compound boolean condition.
1684         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1685             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1686 
1687         if (to == address(0)) revert TransferToZeroAddress();
1688 
1689         _beforeTokenTransfers(from, to, tokenId, 1);
1690 
1691         // Clear approvals from the previous owner.
1692         assembly {
1693             if approvedAddress {
1694                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1695                 sstore(approvedAddressSlot, 0)
1696             }
1697         }
1698 
1699         // Underflow of the sender's balance is impossible because we check for
1700         // ownership above and the recipient's balance can't realistically overflow.
1701         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1702         unchecked {
1703             // We can directly increment and decrement the balances.
1704             --_packedAddressData[from]; // Updates: `balance -= 1`.
1705             ++_packedAddressData[to]; // Updates: `balance += 1`.
1706 
1707             // Updates:
1708             // - `address` to the next owner.
1709             // - `startTimestamp` to the timestamp of transfering.
1710             // - `burned` to `false`.
1711             // - `nextInitialized` to `true`.
1712             _packedOwnerships[tokenId] = _packOwnershipData(
1713                 to,
1714                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1715             );
1716 
1717             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1718             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1719                 uint256 nextTokenId = tokenId + 1;
1720                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1721                 if (_packedOwnerships[nextTokenId] == 0) {
1722                     // If the next slot is within bounds.
1723                     if (nextTokenId != _currentIndex) {
1724                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1725                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1726                     }
1727                 }
1728             }
1729         }
1730 
1731         emit Transfer(from, to, tokenId);
1732         _afterTokenTransfers(from, to, tokenId, 1);
1733     }
1734 
1735     /**
1736      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1737      */
1738     function safeTransferFrom(
1739         address from,
1740         address to,
1741         uint256 tokenId
1742     ) public payable virtual override {
1743         safeTransferFrom(from, to, tokenId, '');
1744     }
1745 
1746     /**
1747      * @dev Safely transfers `tokenId` token from `from` to `to`.
1748      *
1749      * Requirements:
1750      *
1751      * - `from` cannot be the zero address.
1752      * - `to` cannot be the zero address.
1753      * - `tokenId` token must exist and be owned by `from`.
1754      * - If the caller is not `from`, it must be approved to move this token
1755      * by either {approve} or {setApprovalForAll}.
1756      * - If `to` refers to a smart contract, it must implement
1757      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1758      *
1759      * Emits a {Transfer} event.
1760      */
1761     function safeTransferFrom(
1762         address from,
1763         address to,
1764         uint256 tokenId,
1765         bytes memory _data
1766     ) public payable virtual override {
1767         transferFrom(from, to, tokenId);
1768         if (to.code.length != 0)
1769             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1770                 revert TransferToNonERC721ReceiverImplementer();
1771             }
1772     }
1773 
1774     /**
1775      * @dev Hook that is called before a set of serially-ordered token IDs
1776      * are about to be transferred. This includes minting.
1777      * And also called before burning one token.
1778      *
1779      * `startTokenId` - the first token ID to be transferred.
1780      * `quantity` - the amount to be transferred.
1781      *
1782      * Calling conditions:
1783      *
1784      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1785      * transferred to `to`.
1786      * - When `from` is zero, `tokenId` will be minted for `to`.
1787      * - When `to` is zero, `tokenId` will be burned by `from`.
1788      * - `from` and `to` are never both zero.
1789      */
1790     function _beforeTokenTransfers(
1791         address from,
1792         address to,
1793         uint256 startTokenId,
1794         uint256 quantity
1795     ) internal virtual {}
1796 
1797     /**
1798      * @dev Hook that is called after a set of serially-ordered token IDs
1799      * have been transferred. This includes minting.
1800      * And also called after one token has been burned.
1801      *
1802      * `startTokenId` - the first token ID to be transferred.
1803      * `quantity` - the amount to be transferred.
1804      *
1805      * Calling conditions:
1806      *
1807      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1808      * transferred to `to`.
1809      * - When `from` is zero, `tokenId` has been minted for `to`.
1810      * - When `to` is zero, `tokenId` has been burned by `from`.
1811      * - `from` and `to` are never both zero.
1812      */
1813     function _afterTokenTransfers(
1814         address from,
1815         address to,
1816         uint256 startTokenId,
1817         uint256 quantity
1818     ) internal virtual {}
1819 
1820     /**
1821      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1822      *
1823      * `from` - Previous owner of the given token ID.
1824      * `to` - Target address that will receive the token.
1825      * `tokenId` - Token ID to be transferred.
1826      * `_data` - Optional data to send along with the call.
1827      *
1828      * Returns whether the call correctly returned the expected magic value.
1829      */
1830     function _checkContractOnERC721Received(
1831         address from,
1832         address to,
1833         uint256 tokenId,
1834         bytes memory _data
1835     ) private returns (bool) {
1836         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1837             bytes4 retval
1838         ) {
1839             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1840         } catch (bytes memory reason) {
1841             if (reason.length == 0) {
1842                 revert TransferToNonERC721ReceiverImplementer();
1843             } else {
1844                 assembly {
1845                     revert(add(32, reason), mload(reason))
1846                 }
1847             }
1848         }
1849     }
1850 
1851     // =============================================================
1852     //                        MINT OPERATIONS
1853     // =============================================================
1854 
1855     /**
1856      * @dev Mints `quantity` tokens and transfers them to `to`.
1857      *
1858      * Requirements:
1859      *
1860      * - `to` cannot be the zero address.
1861      * - `quantity` must be greater than 0.
1862      *
1863      * Emits a {Transfer} event for each mint.
1864      */
1865     function _mint(address to, uint256 quantity) internal virtual {
1866         uint256 startTokenId = _currentIndex;
1867         if (quantity == 0) revert MintZeroQuantity();
1868 
1869         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1870 
1871         // Overflows are incredibly unrealistic.
1872         // `balance` and `numberMinted` have a maximum limit of 2**64.
1873         // `tokenId` has a maximum limit of 2**256.
1874         unchecked {
1875             // Updates:
1876             // - `balance += quantity`.
1877             // - `numberMinted += quantity`.
1878             //
1879             // We can directly add to the `balance` and `numberMinted`.
1880             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1881 
1882             // Updates:
1883             // - `address` to the owner.
1884             // - `startTimestamp` to the timestamp of minting.
1885             // - `burned` to `false`.
1886             // - `nextInitialized` to `quantity == 1`.
1887             _packedOwnerships[startTokenId] = _packOwnershipData(
1888                 to,
1889                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1890             );
1891 
1892             uint256 toMasked;
1893             uint256 end = startTokenId + quantity;
1894 
1895             // Use assembly to loop and emit the `Transfer` event for gas savings.
1896             // The duplicated `log4` removes an extra check and reduces stack juggling.
1897             // The assembly, together with the surrounding Solidity code, have been
1898             // delicately arranged to nudge the compiler into producing optimized opcodes.
1899             assembly {
1900                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1901                 toMasked := and(to, _BITMASK_ADDRESS)
1902                 // Emit the `Transfer` event.
1903                 log4(
1904                     0, // Start of data (0, since no data).
1905                     0, // End of data (0, since no data).
1906                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1907                     0, // `address(0)`.
1908                     toMasked, // `to`.
1909                     startTokenId // `tokenId`.
1910                 )
1911 
1912                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1913                 // that overflows uint256 will make the loop run out of gas.
1914                 // The compiler will optimize the `iszero` away for performance.
1915                 for {
1916                     let tokenId := add(startTokenId, 1)
1917                 } iszero(eq(tokenId, end)) {
1918                     tokenId := add(tokenId, 1)
1919                 } {
1920                     // Emit the `Transfer` event. Similar to above.
1921                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1922                 }
1923             }
1924             if (toMasked == 0) revert MintToZeroAddress();
1925 
1926             _currentIndex = end;
1927         }
1928         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1929     }
1930 
1931     /**
1932      * @dev Mints `quantity` tokens and transfers them to `to`.
1933      *
1934      * This function is intended for efficient minting only during contract creation.
1935      *
1936      * It emits only one {ConsecutiveTransfer} as defined in
1937      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1938      * instead of a sequence of {Transfer} event(s).
1939      *
1940      * Calling this function outside of contract creation WILL make your contract
1941      * non-compliant with the ERC721 standard.
1942      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1943      * {ConsecutiveTransfer} event is only permissible during contract creation.
1944      *
1945      * Requirements:
1946      *
1947      * - `to` cannot be the zero address.
1948      * - `quantity` must be greater than 0.
1949      *
1950      * Emits a {ConsecutiveTransfer} event.
1951      */
1952     function _mintERC2309(address to, uint256 quantity) internal virtual {
1953         uint256 startTokenId = _currentIndex;
1954         if (to == address(0)) revert MintToZeroAddress();
1955         if (quantity == 0) revert MintZeroQuantity();
1956         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1957 
1958         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1959 
1960         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1961         unchecked {
1962             // Updates:
1963             // - `balance += quantity`.
1964             // - `numberMinted += quantity`.
1965             //
1966             // We can directly add to the `balance` and `numberMinted`.
1967             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1968 
1969             // Updates:
1970             // - `address` to the owner.
1971             // - `startTimestamp` to the timestamp of minting.
1972             // - `burned` to `false`.
1973             // - `nextInitialized` to `quantity == 1`.
1974             _packedOwnerships[startTokenId] = _packOwnershipData(
1975                 to,
1976                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1977             );
1978 
1979             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1980 
1981             _currentIndex = startTokenId + quantity;
1982         }
1983         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1984     }
1985 
1986     /**
1987      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1988      *
1989      * Requirements:
1990      *
1991      * - If `to` refers to a smart contract, it must implement
1992      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1993      * - `quantity` must be greater than 0.
1994      *
1995      * See {_mint}.
1996      *
1997      * Emits a {Transfer} event for each mint.
1998      */
1999     function _safeMint(
2000         address to,
2001         uint256 quantity,
2002         bytes memory _data
2003     ) internal virtual {
2004         _mint(to, quantity);
2005 
2006         unchecked {
2007             if (to.code.length != 0) {
2008                 uint256 end = _currentIndex;
2009                 uint256 index = end - quantity;
2010                 do {
2011                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2012                         revert TransferToNonERC721ReceiverImplementer();
2013                     }
2014                 } while (index < end);
2015                 // Reentrancy protection.
2016                 if (_currentIndex != end) revert();
2017             }
2018         }
2019     }
2020 
2021     /**
2022      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2023      */
2024     function _safeMint(address to, uint256 quantity) internal virtual {
2025         _safeMint(to, quantity, '');
2026     }
2027 
2028     // =============================================================
2029     //                        BURN OPERATIONS
2030     // =============================================================
2031 
2032     /**
2033      * @dev Equivalent to `_burn(tokenId, false)`.
2034      */
2035     function _burn(uint256 tokenId) internal virtual {
2036         _burn(tokenId, false);
2037     }
2038 
2039     /**
2040      * @dev Destroys `tokenId`.
2041      * The approval is cleared when the token is burned.
2042      *
2043      * Requirements:
2044      *
2045      * - `tokenId` must exist.
2046      *
2047      * Emits a {Transfer} event.
2048      */
2049     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2050         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2051 
2052         address from = address(uint160(prevOwnershipPacked));
2053 
2054         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2055 
2056         if (approvalCheck) {
2057             // The nested ifs save around 20+ gas over a compound boolean condition.
2058             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2059                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2060         }
2061 
2062         _beforeTokenTransfers(from, address(0), tokenId, 1);
2063 
2064         // Clear approvals from the previous owner.
2065         assembly {
2066             if approvedAddress {
2067                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2068                 sstore(approvedAddressSlot, 0)
2069             }
2070         }
2071 
2072         // Underflow of the sender's balance is impossible because we check for
2073         // ownership above and the recipient's balance can't realistically overflow.
2074         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2075         unchecked {
2076             // Updates:
2077             // - `balance -= 1`.
2078             // - `numberBurned += 1`.
2079             //
2080             // We can directly decrement the balance, and increment the number burned.
2081             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2082             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2083 
2084             // Updates:
2085             // - `address` to the last owner.
2086             // - `startTimestamp` to the timestamp of burning.
2087             // - `burned` to `true`.
2088             // - `nextInitialized` to `true`.
2089             _packedOwnerships[tokenId] = _packOwnershipData(
2090                 from,
2091                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2092             );
2093 
2094             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2095             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2096                 uint256 nextTokenId = tokenId + 1;
2097                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2098                 if (_packedOwnerships[nextTokenId] == 0) {
2099                     // If the next slot is within bounds.
2100                     if (nextTokenId != _currentIndex) {
2101                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2102                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2103                     }
2104                 }
2105             }
2106         }
2107 
2108         emit Transfer(from, address(0), tokenId);
2109         _afterTokenTransfers(from, address(0), tokenId, 1);
2110 
2111         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2112         unchecked {
2113             _burnCounter++;
2114         }
2115     }
2116 
2117     // =============================================================
2118     //                     EXTRA DATA OPERATIONS
2119     // =============================================================
2120 
2121     /**
2122      * @dev Directly sets the extra data for the ownership data `index`.
2123      */
2124     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2125         uint256 packed = _packedOwnerships[index];
2126         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2127         uint256 extraDataCasted;
2128         // Cast `extraData` with assembly to avoid redundant masking.
2129         assembly {
2130             extraDataCasted := extraData
2131         }
2132         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2133         _packedOwnerships[index] = packed;
2134     }
2135 
2136     /**
2137      * @dev Called during each token transfer to set the 24bit `extraData` field.
2138      * Intended to be overridden by the cosumer contract.
2139      *
2140      * `previousExtraData` - the value of `extraData` before transfer.
2141      *
2142      * Calling conditions:
2143      *
2144      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2145      * transferred to `to`.
2146      * - When `from` is zero, `tokenId` will be minted for `to`.
2147      * - When `to` is zero, `tokenId` will be burned by `from`.
2148      * - `from` and `to` are never both zero.
2149      */
2150     function _extraData(
2151         address from,
2152         address to,
2153         uint24 previousExtraData
2154     ) internal view virtual returns (uint24) {}
2155 
2156     /**
2157      * @dev Returns the next extra data for the packed ownership data.
2158      * The returned result is shifted into position.
2159      */
2160     function _nextExtraData(
2161         address from,
2162         address to,
2163         uint256 prevOwnershipPacked
2164     ) private view returns (uint256) {
2165         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2166         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2167     }
2168 
2169     // =============================================================
2170     //                       OTHER OPERATIONS
2171     // =============================================================
2172 
2173     /**
2174      * @dev Returns the message sender (defaults to `msg.sender`).
2175      *
2176      * If you are writing GSN compatible contracts, you need to override this function.
2177      */
2178     function _msgSenderERC721A() internal view virtual returns (address) {
2179         return msg.sender;
2180     }
2181 
2182     /**
2183      * @dev Converts a uint256 to its ASCII string decimal representation.
2184      */
2185     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2186         assembly {
2187             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2188             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2189             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2190             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2191             let m := add(mload(0x40), 0xa0)
2192             // Update the free memory pointer to allocate.
2193             mstore(0x40, m)
2194             // Assign the `str` to the end.
2195             str := sub(m, 0x20)
2196             // Zeroize the slot after the string.
2197             mstore(str, 0)
2198 
2199             // Cache the end of the memory to calculate the length later.
2200             let end := str
2201 
2202             // We write the string from rightmost digit to leftmost digit.
2203             // The following is essentially a do-while loop that also handles the zero case.
2204             // prettier-ignore
2205             for { let temp := value } 1 {} {
2206                 str := sub(str, 1)
2207                 // Write the character to the pointer.
2208                 // The ASCII index of the '0' character is 48.
2209                 mstore8(str, add(48, mod(temp, 10)))
2210                 // Keep dividing `temp` until zero.
2211                 temp := div(temp, 10)
2212                 // prettier-ignore
2213                 if iszero(temp) { break }
2214             }
2215 
2216             let length := sub(end, str)
2217             // Move the pointer 32 bytes leftwards to make room for the length.
2218             str := sub(str, 0x20)
2219             // Store the length.
2220             mstore(str, length)
2221         }
2222     }
2223 }
2224 
2225 // SPDX-License-Identifier: MIT
2226 //A SOVRN-OPEN Drop
2227 
2228 pragma solidity >=0.8.9 <0.9.0;
2229 
2230 
2231 contract caonimabiu is ERC721A, Ownable, ReentrancyGuard {
2232     using Strings for uint256;
2233     
2234     bool public MintStart = false;
2235     bool public Metadata;
2236 
2237     uint256 public maxPerWallet = 6;
2238     uint256 public maxFree = 1;
2239     uint256 public maxSupply = 3333;
2240     uint256 public publicPrice = 0.0033 ether;
2241     
2242     string public _baseURL = "ipfs://bafybeictt4oqrt5nf4iyaum2slw26ldcl33agfvt3etna4qihqxndadene/";
2243     string public prerevealURL = "";
2244 
2245     mapping(address => uint256) private _walletMintedCount;
2246 
2247     constructor() ERC721A("NakaDocks", "NDR") {}
2248 
2249     function mintedCount(address owner) external view returns (uint256) {
2250         return _walletMintedCount[owner];
2251     }
2252 
2253     function _baseURI() internal view override returns (string memory) {
2254         return _baseURL;
2255     }
2256 
2257     function _startTokenId() internal pure override returns (uint256) {
2258         return 1;
2259     }
2260 
2261     function contractURI() public pure returns (string memory) {
2262         return "";
2263     }
2264 
2265     function finalizeMetadata() external onlyOwner {
2266         Metadata = true;
2267     }
2268 
2269     function reveal(string memory url) external onlyOwner {
2270         require(!Metadata, "Metadata is finalized");
2271         _baseURL = url;
2272     }
2273 
2274     function withdraw() public onlyOwner {
2275         uint256 balance = address(this).balance;
2276         payable(msg.sender).transfer(balance);
2277 
2278 }
2279 
2280     function tokenURI(uint256 tokenId)
2281         public
2282         view
2283         override
2284         returns (string memory)
2285     {
2286         require(
2287             _exists(tokenId),
2288             "ERC721Metadata: URI query for nonexistent token"
2289         );
2290 
2291         return
2292             bytes(_baseURI()).length > 0
2293                 ? string(
2294                     abi.encodePacked(_baseURI(), tokenId.toString())
2295                 )
2296                 : prerevealURL;
2297     }
2298 
2299     function setPublicPrice(uint256 _price) external onlyOwner {
2300         publicPrice = _price;
2301     }
2302 
2303     function MintStartStatus() external onlyOwner {
2304         MintStart = !MintStart;
2305     }
2306 
2307     function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
2308         maxSupply = newMaxSupply;
2309     }
2310     function setFree(uint256 newFree) external onlyOwner {
2311         maxFree = newFree;
2312     }
2313     function mint(uint256 count) external payable {
2314         uint256 minted = _walletMintedCount[msg.sender];
2315         require(count > 0, "Must use at least one mint");
2316         require(minted < maxPerWallet, "Max Per wallet");
2317         uint256 payForCount = count;
2318         if (minted < maxFree) {if (maxFree - minted > count) {payForCount = 0;} 
2319         else {payForCount = count - (maxFree - minted);}}
2320         require(MintStart, "Mint has not started");
2321         require(_totalMinted() + count <= maxSupply, "Sold out");
2322         require(msg.value >= payForCount * publicPrice,"Ether value sent is not sufficient");
2323         _walletMintedCount[msg.sender] += count;
2324         _safeMint(msg.sender, count);
2325     }
2326     function devMint(address to, uint256 count) external onlyOwner {
2327         require(_totalMinted() + count <= maxSupply, "Sold out");
2328         _safeMint(to, count);
2329     }
2330 }