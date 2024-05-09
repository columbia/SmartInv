1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
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
73 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
74 
75 
76 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 // CAUTION
81 // This version of SafeMath should only be used with Solidity 0.8 or later,
82 // because it relies on the compiler's built in overflow checks.
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations.
86  *
87  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
88  * now has built in overflow checking.
89  */
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, with an overflow flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         unchecked {
98             uint256 c = a + b;
99             if (c < a) return (false, 0);
100             return (true, c);
101         }
102     }
103 
104     /**
105      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             if (b > a) return (false, 0);
112             return (true, a - b);
113         }
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
118      *
119      * _Available since v3.4._
120      */
121     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         unchecked {
123             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
124             // benefit is lost if 'b' is also tested.
125             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
126             if (a == 0) return (true, 0);
127             uint256 c = a * b;
128             if (c / a != b) return (false, 0);
129             return (true, c);
130         }
131     }
132 
133     /**
134      * @dev Returns the division of two unsigned integers, with a division by zero flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         unchecked {
140             if (b == 0) return (false, 0);
141             return (true, a / b);
142         }
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             if (b == 0) return (false, 0);
153             return (true, a % b);
154         }
155     }
156 
157     /**
158      * @dev Returns the addition of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `+` operator.
162      *
163      * Requirements:
164      *
165      * - Addition cannot overflow.
166      */
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a + b;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      *
179      * - Subtraction cannot overflow.
180      */
181     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a - b;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `*` operator.
190      *
191      * Requirements:
192      *
193      * - Multiplication cannot overflow.
194      */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         return a * b;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers, reverting on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator.
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return a / b;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * reverting when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a % b;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
231      * overflow (when the result is negative).
232      *
233      * CAUTION: This function is deprecated because it requires allocating memory for the error
234      * message unnecessarily. For custom revert reasons use {trySub}.
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      *
240      * - Subtraction cannot overflow.
241      */
242     function sub(
243         uint256 a,
244         uint256 b,
245         string memory errorMessage
246     ) internal pure returns (uint256) {
247         unchecked {
248             require(b <= a, errorMessage);
249             return a - b;
250         }
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
255      * division by zero. The result is rounded towards zero.
256      *
257      * Counterpart to Solidity's `/` operator. Note: this function uses a
258      * `revert` opcode (which leaves remaining gas untouched) while Solidity
259      * uses an invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function div(
266         uint256 a,
267         uint256 b,
268         string memory errorMessage
269     ) internal pure returns (uint256) {
270         unchecked {
271             require(b > 0, errorMessage);
272             return a / b;
273         }
274     }
275 
276     /**
277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278      * reverting with custom message when dividing by zero.
279      *
280      * CAUTION: This function is deprecated because it requires allocating memory for the error
281      * message unnecessarily. For custom revert reasons use {tryMod}.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function mod(
292         uint256 a,
293         uint256 b,
294         string memory errorMessage
295     ) internal pure returns (uint256) {
296         unchecked {
297             require(b > 0, errorMessage);
298             return a % b;
299         }
300     }
301 }
302 
303 // File: @openzeppelin/contracts/utils/math/Math.sol
304 
305 
306 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev Standard math utilities missing in the Solidity language.
312  */
313 library Math {
314     enum Rounding {
315         Down, // Toward negative infinity
316         Up, // Toward infinity
317         Zero // Toward zero
318     }
319 
320     /**
321      * @dev Returns the largest of two numbers.
322      */
323     function max(uint256 a, uint256 b) internal pure returns (uint256) {
324         return a > b ? a : b;
325     }
326 
327     /**
328      * @dev Returns the smallest of two numbers.
329      */
330     function min(uint256 a, uint256 b) internal pure returns (uint256) {
331         return a < b ? a : b;
332     }
333 
334     /**
335      * @dev Returns the average of two numbers. The result is rounded towards
336      * zero.
337      */
338     function average(uint256 a, uint256 b) internal pure returns (uint256) {
339         // (a + b) / 2 can overflow.
340         return (a & b) + (a ^ b) / 2;
341     }
342 
343     /**
344      * @dev Returns the ceiling of the division of two numbers.
345      *
346      * This differs from standard division with `/` in that it rounds up instead
347      * of rounding down.
348      */
349     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
350         // (a + b - 1) / b can overflow on addition, so we distribute.
351         return a == 0 ? 0 : (a - 1) / b + 1;
352     }
353 
354     /**
355      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
356      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
357      * with further edits by Uniswap Labs also under MIT license.
358      */
359     function mulDiv(
360         uint256 x,
361         uint256 y,
362         uint256 denominator
363     ) internal pure returns (uint256 result) {
364         unchecked {
365             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
366             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
367             // variables such that product = prod1 * 2^256 + prod0.
368             uint256 prod0; // Least significant 256 bits of the product
369             uint256 prod1; // Most significant 256 bits of the product
370             assembly {
371                 let mm := mulmod(x, y, not(0))
372                 prod0 := mul(x, y)
373                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
374             }
375 
376             // Handle non-overflow cases, 256 by 256 division.
377             if (prod1 == 0) {
378                 return prod0 / denominator;
379             }
380 
381             // Make sure the result is less than 2^256. Also prevents denominator == 0.
382             require(denominator > prod1);
383 
384             ///////////////////////////////////////////////
385             // 512 by 256 division.
386             ///////////////////////////////////////////////
387 
388             // Make division exact by subtracting the remainder from [prod1 prod0].
389             uint256 remainder;
390             assembly {
391                 // Compute remainder using mulmod.
392                 remainder := mulmod(x, y, denominator)
393 
394                 // Subtract 256 bit number from 512 bit number.
395                 prod1 := sub(prod1, gt(remainder, prod0))
396                 prod0 := sub(prod0, remainder)
397             }
398 
399             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
400             // See https://cs.stackexchange.com/q/138556/92363.
401 
402             // Does not overflow because the denominator cannot be zero at this stage in the function.
403             uint256 twos = denominator & (~denominator + 1);
404             assembly {
405                 // Divide denominator by twos.
406                 denominator := div(denominator, twos)
407 
408                 // Divide [prod1 prod0] by twos.
409                 prod0 := div(prod0, twos)
410 
411                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
412                 twos := add(div(sub(0, twos), twos), 1)
413             }
414 
415             // Shift in bits from prod1 into prod0.
416             prod0 |= prod1 * twos;
417 
418             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
419             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
420             // four bits. That is, denominator * inv = 1 mod 2^4.
421             uint256 inverse = (3 * denominator) ^ 2;
422 
423             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
424             // in modular arithmetic, doubling the correct bits in each step.
425             inverse *= 2 - denominator * inverse; // inverse mod 2^8
426             inverse *= 2 - denominator * inverse; // inverse mod 2^16
427             inverse *= 2 - denominator * inverse; // inverse mod 2^32
428             inverse *= 2 - denominator * inverse; // inverse mod 2^64
429             inverse *= 2 - denominator * inverse; // inverse mod 2^128
430             inverse *= 2 - denominator * inverse; // inverse mod 2^256
431 
432             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
433             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
434             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
435             // is no longer required.
436             result = prod0 * inverse;
437             return result;
438         }
439     }
440 
441     /**
442      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
443      */
444     function mulDiv(
445         uint256 x,
446         uint256 y,
447         uint256 denominator,
448         Rounding rounding
449     ) internal pure returns (uint256) {
450         uint256 result = mulDiv(x, y, denominator);
451         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
452             result += 1;
453         }
454         return result;
455     }
456 
457     /**
458      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
459      *
460      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
461      */
462     function sqrt(uint256 a) internal pure returns (uint256) {
463         if (a == 0) {
464             return 0;
465         }
466 
467         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
468         //
469         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
470         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
471         //
472         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
473         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
474         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
475         //
476         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
477         uint256 result = 1 << (log2(a) >> 1);
478 
479         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
480         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
481         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
482         // into the expected uint128 result.
483         unchecked {
484             result = (result + a / result) >> 1;
485             result = (result + a / result) >> 1;
486             result = (result + a / result) >> 1;
487             result = (result + a / result) >> 1;
488             result = (result + a / result) >> 1;
489             result = (result + a / result) >> 1;
490             result = (result + a / result) >> 1;
491             return min(result, a / result);
492         }
493     }
494 
495     /**
496      * @notice Calculates sqrt(a), following the selected rounding direction.
497      */
498     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
499         unchecked {
500             uint256 result = sqrt(a);
501             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
502         }
503     }
504 
505     /**
506      * @dev Return the log in base 2, rounded down, of a positive value.
507      * Returns 0 if given 0.
508      */
509     function log2(uint256 value) internal pure returns (uint256) {
510         uint256 result = 0;
511         unchecked {
512             if (value >> 128 > 0) {
513                 value >>= 128;
514                 result += 128;
515             }
516             if (value >> 64 > 0) {
517                 value >>= 64;
518                 result += 64;
519             }
520             if (value >> 32 > 0) {
521                 value >>= 32;
522                 result += 32;
523             }
524             if (value >> 16 > 0) {
525                 value >>= 16;
526                 result += 16;
527             }
528             if (value >> 8 > 0) {
529                 value >>= 8;
530                 result += 8;
531             }
532             if (value >> 4 > 0) {
533                 value >>= 4;
534                 result += 4;
535             }
536             if (value >> 2 > 0) {
537                 value >>= 2;
538                 result += 2;
539             }
540             if (value >> 1 > 0) {
541                 result += 1;
542             }
543         }
544         return result;
545     }
546 
547     /**
548      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
549      * Returns 0 if given 0.
550      */
551     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
552         unchecked {
553             uint256 result = log2(value);
554             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
555         }
556     }
557 
558     /**
559      * @dev Return the log in base 10, rounded down, of a positive value.
560      * Returns 0 if given 0.
561      */
562     function log10(uint256 value) internal pure returns (uint256) {
563         uint256 result = 0;
564         unchecked {
565             if (value >= 10**64) {
566                 value /= 10**64;
567                 result += 64;
568             }
569             if (value >= 10**32) {
570                 value /= 10**32;
571                 result += 32;
572             }
573             if (value >= 10**16) {
574                 value /= 10**16;
575                 result += 16;
576             }
577             if (value >= 10**8) {
578                 value /= 10**8;
579                 result += 8;
580             }
581             if (value >= 10**4) {
582                 value /= 10**4;
583                 result += 4;
584             }
585             if (value >= 10**2) {
586                 value /= 10**2;
587                 result += 2;
588             }
589             if (value >= 10**1) {
590                 result += 1;
591             }
592         }
593         return result;
594     }
595 
596     /**
597      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
598      * Returns 0 if given 0.
599      */
600     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
601         unchecked {
602             uint256 result = log10(value);
603             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
604         }
605     }
606 
607     /**
608      * @dev Return the log in base 256, rounded down, of a positive value.
609      * Returns 0 if given 0.
610      *
611      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
612      */
613     function log256(uint256 value) internal pure returns (uint256) {
614         uint256 result = 0;
615         unchecked {
616             if (value >> 128 > 0) {
617                 value >>= 128;
618                 result += 16;
619             }
620             if (value >> 64 > 0) {
621                 value >>= 64;
622                 result += 8;
623             }
624             if (value >> 32 > 0) {
625                 value >>= 32;
626                 result += 4;
627             }
628             if (value >> 16 > 0) {
629                 value >>= 16;
630                 result += 2;
631             }
632             if (value >> 8 > 0) {
633                 result += 1;
634             }
635         }
636         return result;
637     }
638 
639     /**
640      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
641      * Returns 0 if given 0.
642      */
643     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
644         unchecked {
645             uint256 result = log256(value);
646             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
647         }
648     }
649 }
650 
651 // File: @openzeppelin/contracts/utils/Strings.sol
652 
653 
654 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 
659 /**
660  * @dev String operations.
661  */
662 library Strings {
663     bytes16 private constant _SYMBOLS = "0123456789abcdef";
664     uint8 private constant _ADDRESS_LENGTH = 20;
665 
666     /**
667      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
668      */
669     function toString(uint256 value) internal pure returns (string memory) {
670         unchecked {
671             uint256 length = Math.log10(value) + 1;
672             string memory buffer = new string(length);
673             uint256 ptr;
674             /// @solidity memory-safe-assembly
675             assembly {
676                 ptr := add(buffer, add(32, length))
677             }
678             while (true) {
679                 ptr--;
680                 /// @solidity memory-safe-assembly
681                 assembly {
682                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
683                 }
684                 value /= 10;
685                 if (value == 0) break;
686             }
687             return buffer;
688         }
689     }
690 
691     /**
692      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
693      */
694     function toHexString(uint256 value) internal pure returns (string memory) {
695         unchecked {
696             return toHexString(value, Math.log256(value) + 1);
697         }
698     }
699 
700     /**
701      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
702      */
703     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
704         bytes memory buffer = new bytes(2 * length + 2);
705         buffer[0] = "0";
706         buffer[1] = "x";
707         for (uint256 i = 2 * length + 1; i > 1; --i) {
708             buffer[i] = _SYMBOLS[value & 0xf];
709             value >>= 4;
710         }
711         require(value == 0, "Strings: hex length insufficient");
712         return string(buffer);
713     }
714 
715     /**
716      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
717      */
718     function toHexString(address addr) internal pure returns (string memory) {
719         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
720     }
721 }
722 
723 // File: @openzeppelin/contracts/utils/Context.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 /**
731  * @dev Provides information about the current execution context, including the
732  * sender of the transaction and its data. While these are generally available
733  * via msg.sender and msg.data, they should not be accessed in such a direct
734  * manner, since when dealing with meta-transactions the account sending and
735  * paying for execution may not be the actual sender (as far as an application
736  * is concerned).
737  *
738  * This contract is only required for intermediate, library-like contracts.
739  */
740 abstract contract Context {
741     function _msgSender() internal view virtual returns (address) {
742         return msg.sender;
743     }
744 
745     function _msgData() internal view virtual returns (bytes calldata) {
746         return msg.data;
747     }
748 }
749 
750 // File: @openzeppelin/contracts/access/Ownable.sol
751 
752 
753 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 
758 /**
759  * @dev Contract module which provides a basic access control mechanism, where
760  * there is an account (an owner) that can be granted exclusive access to
761  * specific functions.
762  *
763  * By default, the owner account will be the one that deploys the contract. This
764  * can later be changed with {transferOwnership}.
765  *
766  * This module is used through inheritance. It will make available the modifier
767  * `onlyOwner`, which can be applied to your functions to restrict their use to
768  * the owner.
769  */
770 abstract contract Ownable is Context {
771     address private _owner;
772 
773     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
774 
775     /**
776      * @dev Initializes the contract setting the deployer as the initial owner.
777      */
778     constructor() {
779         _transferOwnership(_msgSender());
780     }
781 
782     /**
783      * @dev Throws if called by any account other than the owner.
784      */
785     modifier onlyOwner() {
786         _checkOwner();
787         _;
788     }
789 
790     /**
791      * @dev Returns the address of the current owner.
792      */
793     function owner() public view virtual returns (address) {
794         return _owner;
795     }
796 
797     /**
798      * @dev Throws if the sender is not the owner.
799      */
800     function _checkOwner() internal view virtual {
801         require(owner() == _msgSender(), "Ownable: caller is not the owner");
802     }
803 
804     /**
805      * @dev Leaves the contract without owner. It will not be possible to call
806      * `onlyOwner` functions anymore. Can only be called by the current owner.
807      *
808      * NOTE: Renouncing ownership will leave the contract without an owner,
809      * thereby removing any functionality that is only available to the owner.
810      */
811     function renounceOwnership() public virtual onlyOwner {
812         _transferOwnership(address(0));
813     }
814 
815     /**
816      * @dev Transfers ownership of the contract to a new account (`newOwner`).
817      * Can only be called by the current owner.
818      */
819     function transferOwnership(address newOwner) public virtual onlyOwner {
820         require(newOwner != address(0), "Ownable: new owner is the zero address");
821         _transferOwnership(newOwner);
822     }
823 
824     /**
825      * @dev Transfers ownership of the contract to a new account (`newOwner`).
826      * Internal function without access restriction.
827      */
828     function _transferOwnership(address newOwner) internal virtual {
829         address oldOwner = _owner;
830         _owner = newOwner;
831         emit OwnershipTransferred(oldOwner, newOwner);
832     }
833 }
834 
835 // File: @openzeppelin/contracts/utils/Address.sol
836 
837 
838 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
839 
840 pragma solidity ^0.8.1;
841 
842 /**
843  * @dev Collection of functions related to the address type
844  */
845 library Address {
846     /**
847      * @dev Returns true if `account` is a contract.
848      *
849      * [IMPORTANT]
850      * ====
851      * It is unsafe to assume that an address for which this function returns
852      * false is an externally-owned account (EOA) and not a contract.
853      *
854      * Among others, `isContract` will return false for the following
855      * types of addresses:
856      *
857      *  - an externally-owned account
858      *  - a contract in construction
859      *  - an address where a contract will be created
860      *  - an address where a contract lived, but was destroyed
861      * ====
862      *
863      * [IMPORTANT]
864      * ====
865      * You shouldn't rely on `isContract` to protect against flash loan attacks!
866      *
867      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
868      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
869      * constructor.
870      * ====
871      */
872     function isContract(address account) internal view returns (bool) {
873         // This method relies on extcodesize/address.code.length, which returns 0
874         // for contracts in construction, since the code is only stored at the end
875         // of the constructor execution.
876 
877         return account.code.length > 0;
878     }
879 
880     /**
881      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
882      * `recipient`, forwarding all available gas and reverting on errors.
883      *
884      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
885      * of certain opcodes, possibly making contracts go over the 2300 gas limit
886      * imposed by `transfer`, making them unable to receive funds via
887      * `transfer`. {sendValue} removes this limitation.
888      *
889      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
890      *
891      * IMPORTANT: because control is transferred to `recipient`, care must be
892      * taken to not create reentrancy vulnerabilities. Consider using
893      * {ReentrancyGuard} or the
894      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
895      */
896     function sendValue(address payable recipient, uint256 amount) internal {
897         require(address(this).balance >= amount, "Address: insufficient balance");
898 
899         (bool success, ) = recipient.call{value: amount}("");
900         require(success, "Address: unable to send value, recipient may have reverted");
901     }
902 
903     /**
904      * @dev Performs a Solidity function call using a low level `call`. A
905      * plain `call` is an unsafe replacement for a function call: use this
906      * function instead.
907      *
908      * If `target` reverts with a revert reason, it is bubbled up by this
909      * function (like regular Solidity function calls).
910      *
911      * Returns the raw returned data. To convert to the expected return value,
912      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
913      *
914      * Requirements:
915      *
916      * - `target` must be a contract.
917      * - calling `target` with `data` must not revert.
918      *
919      * _Available since v3.1._
920      */
921     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
922         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
923     }
924 
925     /**
926      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
927      * `errorMessage` as a fallback revert reason when `target` reverts.
928      *
929      * _Available since v3.1._
930      */
931     function functionCall(
932         address target,
933         bytes memory data,
934         string memory errorMessage
935     ) internal returns (bytes memory) {
936         return functionCallWithValue(target, data, 0, errorMessage);
937     }
938 
939     /**
940      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
941      * but also transferring `value` wei to `target`.
942      *
943      * Requirements:
944      *
945      * - the calling contract must have an ETH balance of at least `value`.
946      * - the called Solidity function must be `payable`.
947      *
948      * _Available since v3.1._
949      */
950     function functionCallWithValue(
951         address target,
952         bytes memory data,
953         uint256 value
954     ) internal returns (bytes memory) {
955         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
956     }
957 
958     /**
959      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
960      * with `errorMessage` as a fallback revert reason when `target` reverts.
961      *
962      * _Available since v3.1._
963      */
964     function functionCallWithValue(
965         address target,
966         bytes memory data,
967         uint256 value,
968         string memory errorMessage
969     ) internal returns (bytes memory) {
970         require(address(this).balance >= value, "Address: insufficient balance for call");
971         (bool success, bytes memory returndata) = target.call{value: value}(data);
972         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
973     }
974 
975     /**
976      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
977      * but performing a static call.
978      *
979      * _Available since v3.3._
980      */
981     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
982         return functionStaticCall(target, data, "Address: low-level static call failed");
983     }
984 
985     /**
986      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
987      * but performing a static call.
988      *
989      * _Available since v3.3._
990      */
991     function functionStaticCall(
992         address target,
993         bytes memory data,
994         string memory errorMessage
995     ) internal view returns (bytes memory) {
996         (bool success, bytes memory returndata) = target.staticcall(data);
997         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
998     }
999 
1000     /**
1001      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1002      * but performing a delegate call.
1003      *
1004      * _Available since v3.4._
1005      */
1006     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1007         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1012      * but performing a delegate call.
1013      *
1014      * _Available since v3.4._
1015      */
1016     function functionDelegateCall(
1017         address target,
1018         bytes memory data,
1019         string memory errorMessage
1020     ) internal returns (bytes memory) {
1021         (bool success, bytes memory returndata) = target.delegatecall(data);
1022         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1023     }
1024 
1025     /**
1026      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1027      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1028      *
1029      * _Available since v4.8._
1030      */
1031     function verifyCallResultFromTarget(
1032         address target,
1033         bool success,
1034         bytes memory returndata,
1035         string memory errorMessage
1036     ) internal view returns (bytes memory) {
1037         if (success) {
1038             if (returndata.length == 0) {
1039                 // only check isContract if the call was successful and the return data is empty
1040                 // otherwise we already know that it was a contract
1041                 require(isContract(target), "Address: call to non-contract");
1042             }
1043             return returndata;
1044         } else {
1045             _revert(returndata, errorMessage);
1046         }
1047     }
1048 
1049     /**
1050      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1051      * revert reason or using the provided one.
1052      *
1053      * _Available since v4.3._
1054      */
1055     function verifyCallResult(
1056         bool success,
1057         bytes memory returndata,
1058         string memory errorMessage
1059     ) internal pure returns (bytes memory) {
1060         if (success) {
1061             return returndata;
1062         } else {
1063             _revert(returndata, errorMessage);
1064         }
1065     }
1066 
1067     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1068         // Look for revert reason and bubble it up if present
1069         if (returndata.length > 0) {
1070             // The easiest way to bubble the revert reason is using memory via assembly
1071             /// @solidity memory-safe-assembly
1072             assembly {
1073                 let returndata_size := mload(returndata)
1074                 revert(add(32, returndata), returndata_size)
1075             }
1076         } else {
1077             revert(errorMessage);
1078         }
1079     }
1080 }
1081 
1082 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1083 
1084 
1085 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1086 
1087 pragma solidity ^0.8.0;
1088 
1089 /**
1090  * @title ERC721 token receiver interface
1091  * @dev Interface for any contract that wants to support safeTransfers
1092  * from ERC721 asset contracts.
1093  */
1094 interface IERC721Receiver {
1095     /**
1096      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1097      * by `operator` from `from`, this function is called.
1098      *
1099      * It must return its Solidity selector to confirm the token transfer.
1100      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1101      *
1102      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1103      */
1104     function onERC721Received(
1105         address operator,
1106         address from,
1107         uint256 tokenId,
1108         bytes calldata data
1109     ) external returns (bytes4);
1110 }
1111 
1112 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1113 
1114 
1115 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 /**
1120  * @dev Interface of the ERC165 standard, as defined in the
1121  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1122  *
1123  * Implementers can declare support of contract interfaces, which can then be
1124  * queried by others ({ERC165Checker}).
1125  *
1126  * For an implementation, see {ERC165}.
1127  */
1128 interface IERC165 {
1129     /**
1130      * @dev Returns true if this contract implements the interface defined by
1131      * `interfaceId`. See the corresponding
1132      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1133      * to learn more about how these ids are created.
1134      *
1135      * This function call must use less than 30 000 gas.
1136      */
1137     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1138 }
1139 
1140 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1141 
1142 
1143 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1144 
1145 pragma solidity ^0.8.0;
1146 
1147 
1148 /**
1149  * @dev Implementation of the {IERC165} interface.
1150  *
1151  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1152  * for the additional interface id that will be supported. For example:
1153  *
1154  * ```solidity
1155  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1156  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1157  * }
1158  * ```
1159  *
1160  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1161  */
1162 abstract contract ERC165 is IERC165 {
1163     /**
1164      * @dev See {IERC165-supportsInterface}.
1165      */
1166     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1167         return interfaceId == type(IERC165).interfaceId;
1168     }
1169 }
1170 
1171 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1172 
1173 
1174 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1175 
1176 pragma solidity ^0.8.0;
1177 
1178 
1179 /**
1180  * @dev Required interface of an ERC721 compliant contract.
1181  */
1182 interface IERC721 is IERC165 {
1183     /**
1184      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1185      */
1186     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1187 
1188     /**
1189      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1190      */
1191     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1192 
1193     /**
1194      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1195      */
1196     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1197 
1198     /**
1199      * @dev Returns the number of tokens in ``owner``'s account.
1200      */
1201     function balanceOf(address owner) external view returns (uint256 balance);
1202 
1203     /**
1204      * @dev Returns the owner of the `tokenId` token.
1205      *
1206      * Requirements:
1207      *
1208      * - `tokenId` must exist.
1209      */
1210     function ownerOf(uint256 tokenId) external view returns (address owner);
1211 
1212     /**
1213      * @dev Safely transfers `tokenId` token from `from` to `to`.
1214      *
1215      * Requirements:
1216      *
1217      * - `from` cannot be the zero address.
1218      * - `to` cannot be the zero address.
1219      * - `tokenId` token must exist and be owned by `from`.
1220      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1221      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function safeTransferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId,
1229         bytes calldata data
1230     ) external;
1231 
1232     /**
1233      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1234      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1235      *
1236      * Requirements:
1237      *
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must exist and be owned by `from`.
1241      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1242      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function safeTransferFrom(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) external;
1251 
1252     /**
1253      * @dev Transfers `tokenId` token from `from` to `to`.
1254      *
1255      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1256      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1257      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1258      *
1259      * Requirements:
1260      *
1261      * - `from` cannot be the zero address.
1262      * - `to` cannot be the zero address.
1263      * - `tokenId` token must be owned by `from`.
1264      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function transferFrom(
1269         address from,
1270         address to,
1271         uint256 tokenId
1272     ) external;
1273 
1274     /**
1275      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1276      * The approval is cleared when the token is transferred.
1277      *
1278      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1279      *
1280      * Requirements:
1281      *
1282      * - The caller must own the token or be an approved operator.
1283      * - `tokenId` must exist.
1284      *
1285      * Emits an {Approval} event.
1286      */
1287     function approve(address to, uint256 tokenId) external;
1288 
1289     /**
1290      * @dev Approve or remove `operator` as an operator for the caller.
1291      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1292      *
1293      * Requirements:
1294      *
1295      * - The `operator` cannot be the caller.
1296      *
1297      * Emits an {ApprovalForAll} event.
1298      */
1299     function setApprovalForAll(address operator, bool _approved) external;
1300 
1301     /**
1302      * @dev Returns the account approved for `tokenId` token.
1303      *
1304      * Requirements:
1305      *
1306      * - `tokenId` must exist.
1307      */
1308     function getApproved(uint256 tokenId) external view returns (address operator);
1309 
1310     /**
1311      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1312      *
1313      * See {setApprovalForAll}
1314      */
1315     function isApprovedForAll(address owner, address operator) external view returns (bool);
1316 }
1317 
1318 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1319 
1320 
1321 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1322 
1323 pragma solidity ^0.8.0;
1324 
1325 
1326 /**
1327  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1328  * @dev See https://eips.ethereum.org/EIPS/eip-721
1329  */
1330 interface IERC721Metadata is IERC721 {
1331     /**
1332      * @dev Returns the token collection name.
1333      */
1334     function name() external view returns (string memory);
1335 
1336     /**
1337      * @dev Returns the token collection symbol.
1338      */
1339     function symbol() external view returns (string memory);
1340 
1341     /**
1342      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1343      */
1344     function tokenURI(uint256 tokenId) external view returns (string memory);
1345 }
1346 
1347 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1348 
1349 
1350 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1351 
1352 pragma solidity ^0.8.0;
1353 
1354 
1355 
1356 
1357 
1358 
1359 
1360 
1361 /**
1362  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1363  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1364  * {ERC721Enumerable}.
1365  */
1366 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1367     using Address for address;
1368     using Strings for uint256;
1369 
1370     // Token name
1371     string private _name;
1372 
1373     // Token symbol
1374     string private _symbol;
1375 
1376     // Mapping from token ID to owner address
1377     mapping(uint256 => address) private _owners;
1378 
1379     // Mapping owner address to token count
1380     mapping(address => uint256) private _balances;
1381 
1382     // Mapping from token ID to approved address
1383     mapping(uint256 => address) private _tokenApprovals;
1384 
1385     // Mapping from owner to operator approvals
1386     mapping(address => mapping(address => bool)) private _operatorApprovals;
1387 
1388     /**
1389      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1390      */
1391     constructor(string memory name_, string memory symbol_) {
1392         _name = name_;
1393         _symbol = symbol_;
1394     }
1395 
1396     /**
1397      * @dev See {IERC165-supportsInterface}.
1398      */
1399     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1400         return
1401             interfaceId == type(IERC721).interfaceId ||
1402             interfaceId == type(IERC721Metadata).interfaceId ||
1403             super.supportsInterface(interfaceId);
1404     }
1405 
1406     /**
1407      * @dev See {IERC721-balanceOf}.
1408      */
1409     function balanceOf(address owner) public view virtual override returns (uint256) {
1410         require(owner != address(0), "ERC721: address zero is not a valid owner");
1411         return _balances[owner];
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-ownerOf}.
1416      */
1417     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1418         address owner = _ownerOf(tokenId);
1419         require(owner != address(0), "ERC721: invalid token ID");
1420         return owner;
1421     }
1422 
1423     /**
1424      * @dev See {IERC721Metadata-name}.
1425      */
1426     function name() public view virtual override returns (string memory) {
1427         return _name;
1428     }
1429 
1430     /**
1431      * @dev See {IERC721Metadata-symbol}.
1432      */
1433     function symbol() public view virtual override returns (string memory) {
1434         return _symbol;
1435     }
1436 
1437     /**
1438      * @dev See {IERC721Metadata-tokenURI}.
1439      */
1440     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1441         _requireMinted(tokenId);
1442 
1443         string memory baseURI = _baseURI();
1444         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1445     }
1446 
1447     /**
1448      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1449      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1450      * by default, can be overridden in child contracts.
1451      */
1452     function _baseURI() internal view virtual returns (string memory) {
1453         return "";
1454     }
1455 
1456     /**
1457      * @dev See {IERC721-approve}.
1458      */
1459     function approve(address to, uint256 tokenId) public virtual override {
1460         address owner = ERC721.ownerOf(tokenId);
1461         require(to != owner, "ERC721: approval to current owner");
1462 
1463         require(
1464             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1465             "ERC721: approve caller is not token owner or approved for all"
1466         );
1467 
1468         _approve(to, tokenId);
1469     }
1470 
1471     /**
1472      * @dev See {IERC721-getApproved}.
1473      */
1474     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1475         _requireMinted(tokenId);
1476 
1477         return _tokenApprovals[tokenId];
1478     }
1479 
1480     /**
1481      * @dev See {IERC721-setApprovalForAll}.
1482      */
1483     function setApprovalForAll(address operator, bool approved) public virtual override {
1484         _setApprovalForAll(_msgSender(), operator, approved);
1485     }
1486 
1487     /**
1488      * @dev See {IERC721-isApprovedForAll}.
1489      */
1490     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1491         return _operatorApprovals[owner][operator];
1492     }
1493 
1494     /**
1495      * @dev See {IERC721-transferFrom}.
1496      */
1497     function transferFrom(
1498         address from,
1499         address to,
1500         uint256 tokenId
1501     ) public virtual override {
1502         //solhint-disable-next-line max-line-length
1503         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1504 
1505         _transfer(from, to, tokenId);
1506     }
1507 
1508     /**
1509      * @dev See {IERC721-safeTransferFrom}.
1510      */
1511     function safeTransferFrom(
1512         address from,
1513         address to,
1514         uint256 tokenId
1515     ) public virtual override {
1516         safeTransferFrom(from, to, tokenId, "");
1517     }
1518 
1519     /**
1520      * @dev See {IERC721-safeTransferFrom}.
1521      */
1522     function safeTransferFrom(
1523         address from,
1524         address to,
1525         uint256 tokenId,
1526         bytes memory data
1527     ) public virtual override {
1528         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1529         _safeTransfer(from, to, tokenId, data);
1530     }
1531 
1532     /**
1533      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1534      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1535      *
1536      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1537      *
1538      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1539      * implement alternative mechanisms to perform token transfer, such as signature-based.
1540      *
1541      * Requirements:
1542      *
1543      * - `from` cannot be the zero address.
1544      * - `to` cannot be the zero address.
1545      * - `tokenId` token must exist and be owned by `from`.
1546      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1547      *
1548      * Emits a {Transfer} event.
1549      */
1550     function _safeTransfer(
1551         address from,
1552         address to,
1553         uint256 tokenId,
1554         bytes memory data
1555     ) internal virtual {
1556         _transfer(from, to, tokenId);
1557         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1558     }
1559 
1560     /**
1561      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1562      */
1563     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1564         return _owners[tokenId];
1565     }
1566 
1567     /**
1568      * @dev Returns whether `tokenId` exists.
1569      *
1570      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1571      *
1572      * Tokens start existing when they are minted (`_mint`),
1573      * and stop existing when they are burned (`_burn`).
1574      */
1575     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1576         return _ownerOf(tokenId) != address(0);
1577     }
1578 
1579     /**
1580      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1581      *
1582      * Requirements:
1583      *
1584      * - `tokenId` must exist.
1585      */
1586     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1587         address owner = ERC721.ownerOf(tokenId);
1588         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1589     }
1590 
1591     /**
1592      * @dev Safely mints `tokenId` and transfers it to `to`.
1593      *
1594      * Requirements:
1595      *
1596      * - `tokenId` must not exist.
1597      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1598      *
1599      * Emits a {Transfer} event.
1600      */
1601     function _safeMint(address to, uint256 tokenId) internal virtual {
1602         _safeMint(to, tokenId, "");
1603     }
1604 
1605     /**
1606      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1607      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1608      */
1609     function _safeMint(
1610         address to,
1611         uint256 tokenId,
1612         bytes memory data
1613     ) internal virtual {
1614         _mint(to, tokenId);
1615         require(
1616             _checkOnERC721Received(address(0), to, tokenId, data),
1617             "ERC721: transfer to non ERC721Receiver implementer"
1618         );
1619     }
1620 
1621     /**
1622      * @dev Mints `tokenId` and transfers it to `to`.
1623      *
1624      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1625      *
1626      * Requirements:
1627      *
1628      * - `tokenId` must not exist.
1629      * - `to` cannot be the zero address.
1630      *
1631      * Emits a {Transfer} event.
1632      */
1633     function _mint(address to, uint256 tokenId) internal virtual {
1634         require(to != address(0), "ERC721: mint to the zero address");
1635         require(!_exists(tokenId), "ERC721: token already minted");
1636 
1637         _beforeTokenTransfer(address(0), to, tokenId, 1);
1638 
1639         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1640         require(!_exists(tokenId), "ERC721: token already minted");
1641 
1642         unchecked {
1643             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1644             // Given that tokens are minted one by one, it is impossible in practice that
1645             // this ever happens. Might change if we allow batch minting.
1646             // The ERC fails to describe this case.
1647             _balances[to] += 1;
1648         }
1649 
1650         _owners[tokenId] = to;
1651 
1652         emit Transfer(address(0), to, tokenId);
1653 
1654         _afterTokenTransfer(address(0), to, tokenId, 1);
1655     }
1656 
1657     /**
1658      * @dev Destroys `tokenId`.
1659      * The approval is cleared when the token is burned.
1660      * This is an internal function that does not check if the sender is authorized to operate on the token.
1661      *
1662      * Requirements:
1663      *
1664      * - `tokenId` must exist.
1665      *
1666      * Emits a {Transfer} event.
1667      */
1668     function _burn(uint256 tokenId) internal virtual {
1669         address owner = ERC721.ownerOf(tokenId);
1670 
1671         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1672 
1673         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1674         owner = ERC721.ownerOf(tokenId);
1675 
1676         // Clear approvals
1677         delete _tokenApprovals[tokenId];
1678 
1679         unchecked {
1680             // Cannot overflow, as that would require more tokens to be burned/transferred
1681             // out than the owner initially received through minting and transferring in.
1682             _balances[owner] -= 1;
1683         }
1684         delete _owners[tokenId];
1685 
1686         emit Transfer(owner, address(0), tokenId);
1687 
1688         _afterTokenTransfer(owner, address(0), tokenId, 1);
1689     }
1690 
1691     /**
1692      * @dev Transfers `tokenId` from `from` to `to`.
1693      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1694      *
1695      * Requirements:
1696      *
1697      * - `to` cannot be the zero address.
1698      * - `tokenId` token must be owned by `from`.
1699      *
1700      * Emits a {Transfer} event.
1701      */
1702     function _transfer(
1703         address from,
1704         address to,
1705         uint256 tokenId
1706     ) internal virtual {
1707         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1708         require(to != address(0), "ERC721: transfer to the zero address");
1709 
1710         _beforeTokenTransfer(from, to, tokenId, 1);
1711 
1712         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1713         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1714 
1715         // Clear approvals from the previous owner
1716         delete _tokenApprovals[tokenId];
1717 
1718         unchecked {
1719             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1720             // `from`'s balance is the number of token held, which is at least one before the current
1721             // transfer.
1722             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1723             // all 2**256 token ids to be minted, which in practice is impossible.
1724             _balances[from] -= 1;
1725             _balances[to] += 1;
1726         }
1727         _owners[tokenId] = to;
1728 
1729         emit Transfer(from, to, tokenId);
1730 
1731         _afterTokenTransfer(from, to, tokenId, 1);
1732     }
1733 
1734     /**
1735      * @dev Approve `to` to operate on `tokenId`
1736      *
1737      * Emits an {Approval} event.
1738      */
1739     function _approve(address to, uint256 tokenId) internal virtual {
1740         _tokenApprovals[tokenId] = to;
1741         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1742     }
1743 
1744     /**
1745      * @dev Approve `operator` to operate on all of `owner` tokens
1746      *
1747      * Emits an {ApprovalForAll} event.
1748      */
1749     function _setApprovalForAll(
1750         address owner,
1751         address operator,
1752         bool approved
1753     ) internal virtual {
1754         require(owner != operator, "ERC721: approve to caller");
1755         _operatorApprovals[owner][operator] = approved;
1756         emit ApprovalForAll(owner, operator, approved);
1757     }
1758 
1759     /**
1760      * @dev Reverts if the `tokenId` has not been minted yet.
1761      */
1762     function _requireMinted(uint256 tokenId) internal view virtual {
1763         require(_exists(tokenId), "ERC721: invalid token ID");
1764     }
1765 
1766     /**
1767      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1768      * The call is not executed if the target address is not a contract.
1769      *
1770      * @param from address representing the previous owner of the given token ID
1771      * @param to target address that will receive the tokens
1772      * @param tokenId uint256 ID of the token to be transferred
1773      * @param data bytes optional data to send along with the call
1774      * @return bool whether the call correctly returned the expected magic value
1775      */
1776     function _checkOnERC721Received(
1777         address from,
1778         address to,
1779         uint256 tokenId,
1780         bytes memory data
1781     ) private returns (bool) {
1782         if (to.isContract()) {
1783             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1784                 return retval == IERC721Receiver.onERC721Received.selector;
1785             } catch (bytes memory reason) {
1786                 if (reason.length == 0) {
1787                     revert("ERC721: transfer to non ERC721Receiver implementer");
1788                 } else {
1789                     /// @solidity memory-safe-assembly
1790                     assembly {
1791                         revert(add(32, reason), mload(reason))
1792                     }
1793                 }
1794             }
1795         } else {
1796             return true;
1797         }
1798     }
1799 
1800     /**
1801      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1802      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1803      *
1804      * Calling conditions:
1805      *
1806      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1807      * - When `from` is zero, the tokens will be minted for `to`.
1808      * - When `to` is zero, ``from``'s tokens will be burned.
1809      * - `from` and `to` are never both zero.
1810      * - `batchSize` is non-zero.
1811      *
1812      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1813      */
1814     function _beforeTokenTransfer(
1815         address from,
1816         address to,
1817         uint256, /* firstTokenId */
1818         uint256 batchSize
1819     ) internal virtual {
1820         if (batchSize > 1) {
1821             if (from != address(0)) {
1822                 _balances[from] -= batchSize;
1823             }
1824             if (to != address(0)) {
1825                 _balances[to] += batchSize;
1826             }
1827         }
1828     }
1829 
1830     /**
1831      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1832      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1833      *
1834      * Calling conditions:
1835      *
1836      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1837      * - When `from` is zero, the tokens were minted for `to`.
1838      * - When `to` is zero, ``from``'s tokens were burned.
1839      * - `from` and `to` are never both zero.
1840      * - `batchSize` is non-zero.
1841      *
1842      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1843      */
1844     function _afterTokenTransfer(
1845         address from,
1846         address to,
1847         uint256 firstTokenId,
1848         uint256 batchSize
1849     ) internal virtual {}
1850 }
1851 
1852 // File: erc721a/contracts/IERC721A.sol
1853 
1854 
1855 // ERC721A Contracts v4.2.3
1856 // Creator: Chiru Labs
1857 
1858 pragma solidity ^0.8.4;
1859 
1860 /**
1861  * @dev Interface of ERC721A.
1862  */
1863 interface IERC721A {
1864     /**
1865      * The caller must own the token or be an approved operator.
1866      */
1867     error ApprovalCallerNotOwnerNorApproved();
1868 
1869     /**
1870      * The token does not exist.
1871      */
1872     error ApprovalQueryForNonexistentToken();
1873 
1874     /**
1875      * Cannot query the balance for the zero address.
1876      */
1877     error BalanceQueryForZeroAddress();
1878 
1879     /**
1880      * Cannot mint to the zero address.
1881      */
1882     error MintToZeroAddress();
1883 
1884     /**
1885      * The quantity of tokens minted must be more than zero.
1886      */
1887     error MintZeroQuantity();
1888 
1889     /**
1890      * The token does not exist.
1891      */
1892     error OwnerQueryForNonexistentToken();
1893 
1894     /**
1895      * The caller must own the token or be an approved operator.
1896      */
1897     error TransferCallerNotOwnerNorApproved();
1898 
1899     /**
1900      * The token must be owned by `from`.
1901      */
1902     error TransferFromIncorrectOwner();
1903 
1904     /**
1905      * Cannot safely transfer to a contract that does not implement the
1906      * ERC721Receiver interface.
1907      */
1908     error TransferToNonERC721ReceiverImplementer();
1909 
1910     /**
1911      * Cannot transfer to the zero address.
1912      */
1913     error TransferToZeroAddress();
1914 
1915     /**
1916      * The token does not exist.
1917      */
1918     error URIQueryForNonexistentToken();
1919 
1920     /**
1921      * The `quantity` minted with ERC2309 exceeds the safety limit.
1922      */
1923     error MintERC2309QuantityExceedsLimit();
1924 
1925     /**
1926      * The `extraData` cannot be set on an unintialized ownership slot.
1927      */
1928     error OwnershipNotInitializedForExtraData();
1929 
1930     // =============================================================
1931     //                            STRUCTS
1932     // =============================================================
1933 
1934     struct TokenOwnership {
1935         // The address of the owner.
1936         address addr;
1937         // Stores the start time of ownership with minimal overhead for tokenomics.
1938         uint64 startTimestamp;
1939         // Whether the token has been burned.
1940         bool burned;
1941         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1942         uint24 extraData;
1943     }
1944 
1945     // =============================================================
1946     //                         TOKEN COUNTERS
1947     // =============================================================
1948 
1949     /**
1950      * @dev Returns the total number of tokens in existence.
1951      * Burned tokens will reduce the count.
1952      * To get the total number of tokens minted, please see {_totalMinted}.
1953      */
1954     function totalSupply() external view returns (uint256);
1955 
1956     // =============================================================
1957     //                            IERC165
1958     // =============================================================
1959 
1960     /**
1961      * @dev Returns true if this contract implements the interface defined by
1962      * `interfaceId`. See the corresponding
1963      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1964      * to learn more about how these ids are created.
1965      *
1966      * This function call must use less than 30000 gas.
1967      */
1968     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1969 
1970     // =============================================================
1971     //                            IERC721
1972     // =============================================================
1973 
1974     /**
1975      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1976      */
1977     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1978 
1979     /**
1980      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1981      */
1982     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1983 
1984     /**
1985      * @dev Emitted when `owner` enables or disables
1986      * (`approved`) `operator` to manage all of its assets.
1987      */
1988     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1989 
1990     /**
1991      * @dev Returns the number of tokens in `owner`'s account.
1992      */
1993     function balanceOf(address owner) external view returns (uint256 balance);
1994 
1995     /**
1996      * @dev Returns the owner of the `tokenId` token.
1997      *
1998      * Requirements:
1999      *
2000      * - `tokenId` must exist.
2001      */
2002     function ownerOf(uint256 tokenId) external view returns (address owner);
2003 
2004     /**
2005      * @dev Safely transfers `tokenId` token from `from` to `to`,
2006      * checking first that contract recipients are aware of the ERC721 protocol
2007      * to prevent tokens from being forever locked.
2008      *
2009      * Requirements:
2010      *
2011      * - `from` cannot be the zero address.
2012      * - `to` cannot be the zero address.
2013      * - `tokenId` token must exist and be owned by `from`.
2014      * - If the caller is not `from`, it must be have been allowed to move
2015      * this token by either {approve} or {setApprovalForAll}.
2016      * - If `to` refers to a smart contract, it must implement
2017      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2018      *
2019      * Emits a {Transfer} event.
2020      */
2021     function safeTransferFrom(
2022         address from,
2023         address to,
2024         uint256 tokenId,
2025         bytes calldata data
2026     ) external payable;
2027 
2028     /**
2029      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2030      */
2031     function safeTransferFrom(
2032         address from,
2033         address to,
2034         uint256 tokenId
2035     ) external payable;
2036 
2037     /**
2038      * @dev Transfers `tokenId` from `from` to `to`.
2039      *
2040      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
2041      * whenever possible.
2042      *
2043      * Requirements:
2044      *
2045      * - `from` cannot be the zero address.
2046      * - `to` cannot be the zero address.
2047      * - `tokenId` token must be owned by `from`.
2048      * - If the caller is not `from`, it must be approved to move this token
2049      * by either {approve} or {setApprovalForAll}.
2050      *
2051      * Emits a {Transfer} event.
2052      */
2053     function transferFrom(
2054         address from,
2055         address to,
2056         uint256 tokenId
2057     ) external payable;
2058 
2059     /**
2060      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2061      * The approval is cleared when the token is transferred.
2062      *
2063      * Only a single account can be approved at a time, so approving the
2064      * zero address clears previous approvals.
2065      *
2066      * Requirements:
2067      *
2068      * - The caller must own the token or be an approved operator.
2069      * - `tokenId` must exist.
2070      *
2071      * Emits an {Approval} event.
2072      */
2073     function approve(address to, uint256 tokenId) external payable;
2074 
2075     /**
2076      * @dev Approve or remove `operator` as an operator for the caller.
2077      * Operators can call {transferFrom} or {safeTransferFrom}
2078      * for any token owned by the caller.
2079      *
2080      * Requirements:
2081      *
2082      * - The `operator` cannot be the caller.
2083      *
2084      * Emits an {ApprovalForAll} event.
2085      */
2086     function setApprovalForAll(address operator, bool _approved) external;
2087 
2088     /**
2089      * @dev Returns the account approved for `tokenId` token.
2090      *
2091      * Requirements:
2092      *
2093      * - `tokenId` must exist.
2094      */
2095     function getApproved(uint256 tokenId) external view returns (address operator);
2096 
2097     /**
2098      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2099      *
2100      * See {setApprovalForAll}.
2101      */
2102     function isApprovedForAll(address owner, address operator) external view returns (bool);
2103 
2104     // =============================================================
2105     //                        IERC721Metadata
2106     // =============================================================
2107 
2108     /**
2109      * @dev Returns the token collection name.
2110      */
2111     function name() external view returns (string memory);
2112 
2113     /**
2114      * @dev Returns the token collection symbol.
2115      */
2116     function symbol() external view returns (string memory);
2117 
2118     /**
2119      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2120      */
2121     function tokenURI(uint256 tokenId) external view returns (string memory);
2122 
2123     // =============================================================
2124     //                           IERC2309
2125     // =============================================================
2126 
2127     /**
2128      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
2129      * (inclusive) is transferred from `from` to `to`, as defined in the
2130      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
2131      *
2132      * See {_mintERC2309} for more details.
2133      */
2134     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
2135 }
2136 
2137 // File: erc721a/contracts/ERC721A.sol
2138 
2139 
2140 // ERC721A Contracts v4.2.3
2141 // Creator: Chiru Labs
2142 
2143 pragma solidity ^0.8.4;
2144 
2145 
2146 /**
2147  * @dev Interface of ERC721 token receiver.
2148  */
2149 interface ERC721A__IERC721Receiver {
2150     function onERC721Received(
2151         address operator,
2152         address from,
2153         uint256 tokenId,
2154         bytes calldata data
2155     ) external returns (bytes4);
2156 }
2157 
2158 /**
2159  * @title ERC721A
2160  *
2161  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
2162  * Non-Fungible Token Standard, including the Metadata extension.
2163  * Optimized for lower gas during batch mints.
2164  *
2165  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
2166  * starting from `_startTokenId()`.
2167  *
2168  * Assumptions:
2169  *
2170  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2171  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
2172  */
2173 contract ERC721A is IERC721A {
2174     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
2175     struct TokenApprovalRef {
2176         address value;
2177     }
2178 
2179     // =============================================================
2180     //                           CONSTANTS
2181     // =============================================================
2182 
2183     // Mask of an entry in packed address data.
2184     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
2185 
2186     // The bit position of `numberMinted` in packed address data.
2187     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
2188 
2189     // The bit position of `numberBurned` in packed address data.
2190     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
2191 
2192     // The bit position of `aux` in packed address data.
2193     uint256 private constant _BITPOS_AUX = 192;
2194 
2195     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
2196     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
2197 
2198     // The bit position of `startTimestamp` in packed ownership.
2199     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
2200 
2201     // The bit mask of the `burned` bit in packed ownership.
2202     uint256 private constant _BITMASK_BURNED = 1 << 224;
2203 
2204     // The bit position of the `nextInitialized` bit in packed ownership.
2205     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
2206 
2207     // The bit mask of the `nextInitialized` bit in packed ownership.
2208     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
2209 
2210     // The bit position of `extraData` in packed ownership.
2211     uint256 private constant _BITPOS_EXTRA_DATA = 232;
2212 
2213     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
2214     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
2215 
2216     // The mask of the lower 160 bits for addresses.
2217     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
2218 
2219     // The maximum `quantity` that can be minted with {_mintERC2309}.
2220     // This limit is to prevent overflows on the address data entries.
2221     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
2222     // is required to cause an overflow, which is unrealistic.
2223     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
2224 
2225     // The `Transfer` event signature is given by:
2226     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
2227     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
2228         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
2229 
2230     // =============================================================
2231     //                            STORAGE
2232     // =============================================================
2233 
2234     // The next token ID to be minted.
2235     uint256 private _currentIndex;
2236 
2237     // The number of tokens burned.
2238     uint256 private _burnCounter;
2239 
2240     // Token name
2241     string private _name;
2242 
2243     // Token symbol
2244     string private _symbol;
2245 
2246     // Mapping from token ID to ownership details
2247     // An empty struct value does not necessarily mean the token is unowned.
2248     // See {_packedOwnershipOf} implementation for details.
2249     //
2250     // Bits Layout:
2251     // - [0..159]   `addr`
2252     // - [160..223] `startTimestamp`
2253     // - [224]      `burned`
2254     // - [225]      `nextInitialized`
2255     // - [232..255] `extraData`
2256     mapping(uint256 => uint256) private _packedOwnerships;
2257 
2258     // Mapping owner address to address data.
2259     //
2260     // Bits Layout:
2261     // - [0..63]    `balance`
2262     // - [64..127]  `numberMinted`
2263     // - [128..191] `numberBurned`
2264     // - [192..255] `aux`
2265     mapping(address => uint256) private _packedAddressData;
2266 
2267     // Mapping from token ID to approved address.
2268     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
2269 
2270     // Mapping from owner to operator approvals
2271     mapping(address => mapping(address => bool)) private _operatorApprovals;
2272 
2273     // =============================================================
2274     //                          CONSTRUCTOR
2275     // =============================================================
2276 
2277     constructor(string memory name_, string memory symbol_) {
2278         _name = name_;
2279         _symbol = symbol_;
2280         _currentIndex = _startTokenId();
2281     }
2282 
2283     // =============================================================
2284     //                   TOKEN COUNTING OPERATIONS
2285     // =============================================================
2286 
2287     /**
2288      * @dev Returns the starting token ID.
2289      * To change the starting token ID, please override this function.
2290      */
2291     function _startTokenId() internal view virtual returns (uint256) {
2292         return 0;
2293     }
2294 
2295     /**
2296      * @dev Returns the next token ID to be minted.
2297      */
2298     function _nextTokenId() internal view virtual returns (uint256) {
2299         return _currentIndex;
2300     }
2301 
2302     /**
2303      * @dev Returns the total number of tokens in existence.
2304      * Burned tokens will reduce the count.
2305      * To get the total number of tokens minted, please see {_totalMinted}.
2306      */
2307     function totalSupply() public view virtual override returns (uint256) {
2308         // Counter underflow is impossible as _burnCounter cannot be incremented
2309         // more than `_currentIndex - _startTokenId()` times.
2310         unchecked {
2311             return _currentIndex - _burnCounter - _startTokenId();
2312         }
2313     }
2314 
2315     /**
2316      * @dev Returns the total amount of tokens minted in the contract.
2317      */
2318     function _totalMinted() internal view virtual returns (uint256) {
2319         // Counter underflow is impossible as `_currentIndex` does not decrement,
2320         // and it is initialized to `_startTokenId()`.
2321         unchecked {
2322             return _currentIndex - _startTokenId();
2323         }
2324     }
2325 
2326     /**
2327      * @dev Returns the total number of tokens burned.
2328      */
2329     function _totalBurned() internal view virtual returns (uint256) {
2330         return _burnCounter;
2331     }
2332 
2333     // =============================================================
2334     //                    ADDRESS DATA OPERATIONS
2335     // =============================================================
2336 
2337     /**
2338      * @dev Returns the number of tokens in `owner`'s account.
2339      */
2340     function balanceOf(address owner) public view virtual override returns (uint256) {
2341         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2342         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
2343     }
2344 
2345     /**
2346      * Returns the number of tokens minted by `owner`.
2347      */
2348     function _numberMinted(address owner) internal view returns (uint256) {
2349         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
2350     }
2351 
2352     /**
2353      * Returns the number of tokens burned by or on behalf of `owner`.
2354      */
2355     function _numberBurned(address owner) internal view returns (uint256) {
2356         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
2357     }
2358 
2359     /**
2360      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2361      */
2362     function _getAux(address owner) internal view returns (uint64) {
2363         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
2364     }
2365 
2366     /**
2367      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2368      * If there are multiple variables, please pack them into a uint64.
2369      */
2370     function _setAux(address owner, uint64 aux) internal virtual {
2371         uint256 packed = _packedAddressData[owner];
2372         uint256 auxCasted;
2373         // Cast `aux` with assembly to avoid redundant masking.
2374         assembly {
2375             auxCasted := aux
2376         }
2377         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
2378         _packedAddressData[owner] = packed;
2379     }
2380 
2381     // =============================================================
2382     //                            IERC165
2383     // =============================================================
2384 
2385     /**
2386      * @dev Returns true if this contract implements the interface defined by
2387      * `interfaceId`. See the corresponding
2388      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2389      * to learn more about how these ids are created.
2390      *
2391      * This function call must use less than 30000 gas.
2392      */
2393     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2394         // The interface IDs are constants representing the first 4 bytes
2395         // of the XOR of all function selectors in the interface.
2396         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
2397         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
2398         return
2399             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2400             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2401             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2402     }
2403 
2404     // =============================================================
2405     //                        IERC721Metadata
2406     // =============================================================
2407 
2408     /**
2409      * @dev Returns the token collection name.
2410      */
2411     function name() public view virtual override returns (string memory) {
2412         return _name;
2413     }
2414 
2415     /**
2416      * @dev Returns the token collection symbol.
2417      */
2418     function symbol() public view virtual override returns (string memory) {
2419         return _symbol;
2420     }
2421 
2422     /**
2423      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2424      */
2425     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2426         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2427 
2428         string memory baseURI = _baseURI();
2429         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2430     }
2431 
2432     /**
2433      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2434      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2435      * by default, it can be overridden in child contracts.
2436      */
2437     function _baseURI() internal view virtual returns (string memory) {
2438         return '';
2439     }
2440 
2441     // =============================================================
2442     //                     OWNERSHIPS OPERATIONS
2443     // =============================================================
2444 
2445     /**
2446      * @dev Returns the owner of the `tokenId` token.
2447      *
2448      * Requirements:
2449      *
2450      * - `tokenId` must exist.
2451      */
2452     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2453         return address(uint160(_packedOwnershipOf(tokenId)));
2454     }
2455 
2456     /**
2457      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2458      * It gradually moves to O(1) as tokens get transferred around over time.
2459      */
2460     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2461         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2462     }
2463 
2464     /**
2465      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2466      */
2467     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2468         return _unpackedOwnership(_packedOwnerships[index]);
2469     }
2470 
2471     /**
2472      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2473      */
2474     function _initializeOwnershipAt(uint256 index) internal virtual {
2475         if (_packedOwnerships[index] == 0) {
2476             _packedOwnerships[index] = _packedOwnershipOf(index);
2477         }
2478     }
2479 
2480     /**
2481      * Returns the packed ownership data of `tokenId`.
2482      */
2483     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2484         uint256 curr = tokenId;
2485 
2486         unchecked {
2487             if (_startTokenId() <= curr)
2488                 if (curr < _currentIndex) {
2489                     uint256 packed = _packedOwnerships[curr];
2490                     // If not burned.
2491                     if (packed & _BITMASK_BURNED == 0) {
2492                         // Invariant:
2493                         // There will always be an initialized ownership slot
2494                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2495                         // before an unintialized ownership slot
2496                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2497                         // Hence, `curr` will not underflow.
2498                         //
2499                         // We can directly compare the packed value.
2500                         // If the address is zero, packed will be zero.
2501                         while (packed == 0) {
2502                             packed = _packedOwnerships[--curr];
2503                         }
2504                         return packed;
2505                     }
2506                 }
2507         }
2508         revert OwnerQueryForNonexistentToken();
2509     }
2510 
2511     /**
2512      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2513      */
2514     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2515         ownership.addr = address(uint160(packed));
2516         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2517         ownership.burned = packed & _BITMASK_BURNED != 0;
2518         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2519     }
2520 
2521     /**
2522      * @dev Packs ownership data into a single uint256.
2523      */
2524     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2525         assembly {
2526             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2527             owner := and(owner, _BITMASK_ADDRESS)
2528             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2529             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2530         }
2531     }
2532 
2533     /**
2534      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2535      */
2536     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2537         // For branchless setting of the `nextInitialized` flag.
2538         assembly {
2539             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2540             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2541         }
2542     }
2543 
2544     // =============================================================
2545     //                      APPROVAL OPERATIONS
2546     // =============================================================
2547 
2548     /**
2549      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2550      * The approval is cleared when the token is transferred.
2551      *
2552      * Only a single account can be approved at a time, so approving the
2553      * zero address clears previous approvals.
2554      *
2555      * Requirements:
2556      *
2557      * - The caller must own the token or be an approved operator.
2558      * - `tokenId` must exist.
2559      *
2560      * Emits an {Approval} event.
2561      */
2562     function approve(address to, uint256 tokenId) public payable virtual override {
2563         address owner = ownerOf(tokenId);
2564 
2565         if (_msgSenderERC721A() != owner)
2566             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2567                 revert ApprovalCallerNotOwnerNorApproved();
2568             }
2569 
2570         _tokenApprovals[tokenId].value = to;
2571         emit Approval(owner, to, tokenId);
2572     }
2573 
2574     /**
2575      * @dev Returns the account approved for `tokenId` token.
2576      *
2577      * Requirements:
2578      *
2579      * - `tokenId` must exist.
2580      */
2581     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2582         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2583 
2584         return _tokenApprovals[tokenId].value;
2585     }
2586 
2587     /**
2588      * @dev Approve or remove `operator` as an operator for the caller.
2589      * Operators can call {transferFrom} or {safeTransferFrom}
2590      * for any token owned by the caller.
2591      *
2592      * Requirements:
2593      *
2594      * - The `operator` cannot be the caller.
2595      *
2596      * Emits an {ApprovalForAll} event.
2597      */
2598     function setApprovalForAll(address operator, bool approved) public virtual override {
2599         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2600         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2601     }
2602 
2603     /**
2604      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2605      *
2606      * See {setApprovalForAll}.
2607      */
2608     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2609         return _operatorApprovals[owner][operator];
2610     }
2611 
2612     /**
2613      * @dev Returns whether `tokenId` exists.
2614      *
2615      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2616      *
2617      * Tokens start existing when they are minted. See {_mint}.
2618      */
2619     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2620         return
2621             _startTokenId() <= tokenId &&
2622             tokenId < _currentIndex && // If within bounds,
2623             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2624     }
2625 
2626     /**
2627      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2628      */
2629     function _isSenderApprovedOrOwner(
2630         address approvedAddress,
2631         address owner,
2632         address msgSender
2633     ) private pure returns (bool result) {
2634         assembly {
2635             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2636             owner := and(owner, _BITMASK_ADDRESS)
2637             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2638             msgSender := and(msgSender, _BITMASK_ADDRESS)
2639             // `msgSender == owner || msgSender == approvedAddress`.
2640             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2641         }
2642     }
2643 
2644     /**
2645      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2646      */
2647     function _getApprovedSlotAndAddress(uint256 tokenId)
2648         private
2649         view
2650         returns (uint256 approvedAddressSlot, address approvedAddress)
2651     {
2652         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2653         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2654         assembly {
2655             approvedAddressSlot := tokenApproval.slot
2656             approvedAddress := sload(approvedAddressSlot)
2657         }
2658     }
2659 
2660     // =============================================================
2661     //                      TRANSFER OPERATIONS
2662     // =============================================================
2663 
2664     /**
2665      * @dev Transfers `tokenId` from `from` to `to`.
2666      *
2667      * Requirements:
2668      *
2669      * - `from` cannot be the zero address.
2670      * - `to` cannot be the zero address.
2671      * - `tokenId` token must be owned by `from`.
2672      * - If the caller is not `from`, it must be approved to move this token
2673      * by either {approve} or {setApprovalForAll}.
2674      *
2675      * Emits a {Transfer} event.
2676      */
2677     function transferFrom(
2678         address from,
2679         address to,
2680         uint256 tokenId
2681     ) public payable virtual override {
2682         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2683 
2684         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2685 
2686         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2687 
2688         // The nested ifs save around 20+ gas over a compound boolean condition.
2689         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2690             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2691 
2692         if (to == address(0)) revert TransferToZeroAddress();
2693 
2694         _beforeTokenTransfers(from, to, tokenId, 1);
2695 
2696         // Clear approvals from the previous owner.
2697         assembly {
2698             if approvedAddress {
2699                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2700                 sstore(approvedAddressSlot, 0)
2701             }
2702         }
2703 
2704         // Underflow of the sender's balance is impossible because we check for
2705         // ownership above and the recipient's balance can't realistically overflow.
2706         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2707         unchecked {
2708             // We can directly increment and decrement the balances.
2709             --_packedAddressData[from]; // Updates: `balance -= 1`.
2710             ++_packedAddressData[to]; // Updates: `balance += 1`.
2711 
2712             // Updates:
2713             // - `address` to the next owner.
2714             // - `startTimestamp` to the timestamp of transfering.
2715             // - `burned` to `false`.
2716             // - `nextInitialized` to `true`.
2717             _packedOwnerships[tokenId] = _packOwnershipData(
2718                 to,
2719                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2720             );
2721 
2722             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2723             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2724                 uint256 nextTokenId = tokenId + 1;
2725                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2726                 if (_packedOwnerships[nextTokenId] == 0) {
2727                     // If the next slot is within bounds.
2728                     if (nextTokenId != _currentIndex) {
2729                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2730                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2731                     }
2732                 }
2733             }
2734         }
2735 
2736         emit Transfer(from, to, tokenId);
2737         _afterTokenTransfers(from, to, tokenId, 1);
2738     }
2739 
2740     /**
2741      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2742      */
2743     function safeTransferFrom(
2744         address from,
2745         address to,
2746         uint256 tokenId
2747     ) public payable virtual override {
2748         safeTransferFrom(from, to, tokenId, '');
2749     }
2750 
2751     /**
2752      * @dev Safely transfers `tokenId` token from `from` to `to`.
2753      *
2754      * Requirements:
2755      *
2756      * - `from` cannot be the zero address.
2757      * - `to` cannot be the zero address.
2758      * - `tokenId` token must exist and be owned by `from`.
2759      * - If the caller is not `from`, it must be approved to move this token
2760      * by either {approve} or {setApprovalForAll}.
2761      * - If `to` refers to a smart contract, it must implement
2762      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2763      *
2764      * Emits a {Transfer} event.
2765      */
2766     function safeTransferFrom(
2767         address from,
2768         address to,
2769         uint256 tokenId,
2770         bytes memory _data
2771     ) public payable virtual override {
2772         transferFrom(from, to, tokenId);
2773         if (to.code.length != 0)
2774             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2775                 revert TransferToNonERC721ReceiverImplementer();
2776             }
2777     }
2778 
2779     /**
2780      * @dev Hook that is called before a set of serially-ordered token IDs
2781      * are about to be transferred. This includes minting.
2782      * And also called before burning one token.
2783      *
2784      * `startTokenId` - the first token ID to be transferred.
2785      * `quantity` - the amount to be transferred.
2786      *
2787      * Calling conditions:
2788      *
2789      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2790      * transferred to `to`.
2791      * - When `from` is zero, `tokenId` will be minted for `to`.
2792      * - When `to` is zero, `tokenId` will be burned by `from`.
2793      * - `from` and `to` are never both zero.
2794      */
2795     function _beforeTokenTransfers(
2796         address from,
2797         address to,
2798         uint256 startTokenId,
2799         uint256 quantity
2800     ) internal virtual {}
2801 
2802     /**
2803      * @dev Hook that is called after a set of serially-ordered token IDs
2804      * have been transferred. This includes minting.
2805      * And also called after one token has been burned.
2806      *
2807      * `startTokenId` - the first token ID to be transferred.
2808      * `quantity` - the amount to be transferred.
2809      *
2810      * Calling conditions:
2811      *
2812      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2813      * transferred to `to`.
2814      * - When `from` is zero, `tokenId` has been minted for `to`.
2815      * - When `to` is zero, `tokenId` has been burned by `from`.
2816      * - `from` and `to` are never both zero.
2817      */
2818     function _afterTokenTransfers(
2819         address from,
2820         address to,
2821         uint256 startTokenId,
2822         uint256 quantity
2823     ) internal virtual {}
2824 
2825     /**
2826      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2827      *
2828      * `from` - Previous owner of the given token ID.
2829      * `to` - Target address that will receive the token.
2830      * `tokenId` - Token ID to be transferred.
2831      * `_data` - Optional data to send along with the call.
2832      *
2833      * Returns whether the call correctly returned the expected magic value.
2834      */
2835     function _checkContractOnERC721Received(
2836         address from,
2837         address to,
2838         uint256 tokenId,
2839         bytes memory _data
2840     ) private returns (bool) {
2841         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2842             bytes4 retval
2843         ) {
2844             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2845         } catch (bytes memory reason) {
2846             if (reason.length == 0) {
2847                 revert TransferToNonERC721ReceiverImplementer();
2848             } else {
2849                 assembly {
2850                     revert(add(32, reason), mload(reason))
2851                 }
2852             }
2853         }
2854     }
2855 
2856     // =============================================================
2857     //                        MINT OPERATIONS
2858     // =============================================================
2859 
2860     /**
2861      * @dev Mints `quantity` tokens and transfers them to `to`.
2862      *
2863      * Requirements:
2864      *
2865      * - `to` cannot be the zero address.
2866      * - `quantity` must be greater than 0.
2867      *
2868      * Emits a {Transfer} event for each mint.
2869      */
2870     function _mint(address to, uint256 quantity) internal virtual {
2871         uint256 startTokenId = _currentIndex;
2872         if (quantity == 0) revert MintZeroQuantity();
2873 
2874         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2875 
2876         // Overflows are incredibly unrealistic.
2877         // `balance` and `numberMinted` have a maximum limit of 2**64.
2878         // `tokenId` has a maximum limit of 2**256.
2879         unchecked {
2880             // Updates:
2881             // - `balance += quantity`.
2882             // - `numberMinted += quantity`.
2883             //
2884             // We can directly add to the `balance` and `numberMinted`.
2885             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2886 
2887             // Updates:
2888             // - `address` to the owner.
2889             // - `startTimestamp` to the timestamp of minting.
2890             // - `burned` to `false`.
2891             // - `nextInitialized` to `quantity == 1`.
2892             _packedOwnerships[startTokenId] = _packOwnershipData(
2893                 to,
2894                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2895             );
2896 
2897             uint256 toMasked;
2898             uint256 end = startTokenId + quantity;
2899 
2900             // Use assembly to loop and emit the `Transfer` event for gas savings.
2901             // The duplicated `log4` removes an extra check and reduces stack juggling.
2902             // The assembly, together with the surrounding Solidity code, have been
2903             // delicately arranged to nudge the compiler into producing optimized opcodes.
2904             assembly {
2905                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2906                 toMasked := and(to, _BITMASK_ADDRESS)
2907                 // Emit the `Transfer` event.
2908                 log4(
2909                     0, // Start of data (0, since no data).
2910                     0, // End of data (0, since no data).
2911                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2912                     0, // `address(0)`.
2913                     toMasked, // `to`.
2914                     startTokenId // `tokenId`.
2915                 )
2916 
2917                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2918                 // that overflows uint256 will make the loop run out of gas.
2919                 // The compiler will optimize the `iszero` away for performance.
2920                 for {
2921                     let tokenId := add(startTokenId, 1)
2922                 } iszero(eq(tokenId, end)) {
2923                     tokenId := add(tokenId, 1)
2924                 } {
2925                     // Emit the `Transfer` event. Similar to above.
2926                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2927                 }
2928             }
2929             if (toMasked == 0) revert MintToZeroAddress();
2930 
2931             _currentIndex = end;
2932         }
2933         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2934     }
2935 
2936     /**
2937      * @dev Mints `quantity` tokens and transfers them to `to`.
2938      *
2939      * This function is intended for efficient minting only during contract creation.
2940      *
2941      * It emits only one {ConsecutiveTransfer} as defined in
2942      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2943      * instead of a sequence of {Transfer} event(s).
2944      *
2945      * Calling this function outside of contract creation WILL make your contract
2946      * non-compliant with the ERC721 standard.
2947      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2948      * {ConsecutiveTransfer} event is only permissible during contract creation.
2949      *
2950      * Requirements:
2951      *
2952      * - `to` cannot be the zero address.
2953      * - `quantity` must be greater than 0.
2954      *
2955      * Emits a {ConsecutiveTransfer} event.
2956      */
2957     function _mintERC2309(address to, uint256 quantity) internal virtual {
2958         uint256 startTokenId = _currentIndex;
2959         if (to == address(0)) revert MintToZeroAddress();
2960         if (quantity == 0) revert MintZeroQuantity();
2961         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2962 
2963         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2964 
2965         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2966         unchecked {
2967             // Updates:
2968             // - `balance += quantity`.
2969             // - `numberMinted += quantity`.
2970             //
2971             // We can directly add to the `balance` and `numberMinted`.
2972             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2973 
2974             // Updates:
2975             // - `address` to the owner.
2976             // - `startTimestamp` to the timestamp of minting.
2977             // - `burned` to `false`.
2978             // - `nextInitialized` to `quantity == 1`.
2979             _packedOwnerships[startTokenId] = _packOwnershipData(
2980                 to,
2981                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2982             );
2983 
2984             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2985 
2986             _currentIndex = startTokenId + quantity;
2987         }
2988         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2989     }
2990 
2991     /**
2992      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2993      *
2994      * Requirements:
2995      *
2996      * - If `to` refers to a smart contract, it must implement
2997      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2998      * - `quantity` must be greater than 0.
2999      *
3000      * See {_mint}.
3001      *
3002      * Emits a {Transfer} event for each mint.
3003      */
3004     function _safeMint(
3005         address to,
3006         uint256 quantity,
3007         bytes memory _data
3008     ) internal virtual {
3009         _mint(to, quantity);
3010 
3011         unchecked {
3012             if (to.code.length != 0) {
3013                 uint256 end = _currentIndex;
3014                 uint256 index = end - quantity;
3015                 do {
3016                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
3017                         revert TransferToNonERC721ReceiverImplementer();
3018                     }
3019                 } while (index < end);
3020                 // Reentrancy protection.
3021                 if (_currentIndex != end) revert();
3022             }
3023         }
3024     }
3025 
3026     /**
3027      * @dev Equivalent to `_safeMint(to, quantity, '')`.
3028      */
3029     function _safeMint(address to, uint256 quantity) internal virtual {
3030         _safeMint(to, quantity, '');
3031     }
3032 
3033     // =============================================================
3034     //                        BURN OPERATIONS
3035     // =============================================================
3036 
3037     /**
3038      * @dev Equivalent to `_burn(tokenId, false)`.
3039      */
3040     function _burn(uint256 tokenId) internal virtual {
3041         _burn(tokenId, false);
3042     }
3043 
3044     /**
3045      * @dev Destroys `tokenId`.
3046      * The approval is cleared when the token is burned.
3047      *
3048      * Requirements:
3049      *
3050      * - `tokenId` must exist.
3051      *
3052      * Emits a {Transfer} event.
3053      */
3054     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
3055         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
3056 
3057         address from = address(uint160(prevOwnershipPacked));
3058 
3059         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
3060 
3061         if (approvalCheck) {
3062             // The nested ifs save around 20+ gas over a compound boolean condition.
3063             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
3064                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
3065         }
3066 
3067         _beforeTokenTransfers(from, address(0), tokenId, 1);
3068 
3069         // Clear approvals from the previous owner.
3070         assembly {
3071             if approvedAddress {
3072                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
3073                 sstore(approvedAddressSlot, 0)
3074             }
3075         }
3076 
3077         // Underflow of the sender's balance is impossible because we check for
3078         // ownership above and the recipient's balance can't realistically overflow.
3079         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
3080         unchecked {
3081             // Updates:
3082             // - `balance -= 1`.
3083             // - `numberBurned += 1`.
3084             //
3085             // We can directly decrement the balance, and increment the number burned.
3086             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
3087             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
3088 
3089             // Updates:
3090             // - `address` to the last owner.
3091             // - `startTimestamp` to the timestamp of burning.
3092             // - `burned` to `true`.
3093             // - `nextInitialized` to `true`.
3094             _packedOwnerships[tokenId] = _packOwnershipData(
3095                 from,
3096                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
3097             );
3098 
3099             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
3100             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
3101                 uint256 nextTokenId = tokenId + 1;
3102                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
3103                 if (_packedOwnerships[nextTokenId] == 0) {
3104                     // If the next slot is within bounds.
3105                     if (nextTokenId != _currentIndex) {
3106                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
3107                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
3108                     }
3109                 }
3110             }
3111         }
3112 
3113         emit Transfer(from, address(0), tokenId);
3114         _afterTokenTransfers(from, address(0), tokenId, 1);
3115 
3116         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
3117         unchecked {
3118             _burnCounter++;
3119         }
3120     }
3121 
3122     // =============================================================
3123     //                     EXTRA DATA OPERATIONS
3124     // =============================================================
3125 
3126     /**
3127      * @dev Directly sets the extra data for the ownership data `index`.
3128      */
3129     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
3130         uint256 packed = _packedOwnerships[index];
3131         if (packed == 0) revert OwnershipNotInitializedForExtraData();
3132         uint256 extraDataCasted;
3133         // Cast `extraData` with assembly to avoid redundant masking.
3134         assembly {
3135             extraDataCasted := extraData
3136         }
3137         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
3138         _packedOwnerships[index] = packed;
3139     }
3140 
3141     /**
3142      * @dev Called during each token transfer to set the 24bit `extraData` field.
3143      * Intended to be overridden by the cosumer contract.
3144      *
3145      * `previousExtraData` - the value of `extraData` before transfer.
3146      *
3147      * Calling conditions:
3148      *
3149      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3150      * transferred to `to`.
3151      * - When `from` is zero, `tokenId` will be minted for `to`.
3152      * - When `to` is zero, `tokenId` will be burned by `from`.
3153      * - `from` and `to` are never both zero.
3154      */
3155     function _extraData(
3156         address from,
3157         address to,
3158         uint24 previousExtraData
3159     ) internal view virtual returns (uint24) {}
3160 
3161     /**
3162      * @dev Returns the next extra data for the packed ownership data.
3163      * The returned result is shifted into position.
3164      */
3165     function _nextExtraData(
3166         address from,
3167         address to,
3168         uint256 prevOwnershipPacked
3169     ) private view returns (uint256) {
3170         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
3171         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
3172     }
3173 
3174     // =============================================================
3175     //                       OTHER OPERATIONS
3176     // =============================================================
3177 
3178     /**
3179      * @dev Returns the message sender (defaults to `msg.sender`).
3180      *
3181      * If you are writing GSN compatible contracts, you need to override this function.
3182      */
3183     function _msgSenderERC721A() internal view virtual returns (address) {
3184         return msg.sender;
3185     }
3186 
3187     /**
3188      * @dev Converts a uint256 to its ASCII string decimal representation.
3189      */
3190     function _toString(uint256 value) internal pure virtual returns (string memory str) {
3191         assembly {
3192             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
3193             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
3194             // We will need 1 word for the trailing zeros padding, 1 word for the length,
3195             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
3196             let m := add(mload(0x40), 0xa0)
3197             // Update the free memory pointer to allocate.
3198             mstore(0x40, m)
3199             // Assign the `str` to the end.
3200             str := sub(m, 0x20)
3201             // Zeroize the slot after the string.
3202             mstore(str, 0)
3203 
3204             // Cache the end of the memory to calculate the length later.
3205             let end := str
3206 
3207             // We write the string from rightmost digit to leftmost digit.
3208             // The following is essentially a do-while loop that also handles the zero case.
3209             // prettier-ignore
3210             for { let temp := value } 1 {} {
3211                 str := sub(str, 1)
3212                 // Write the character to the pointer.
3213                 // The ASCII index of the '0' character is 48.
3214                 mstore8(str, add(48, mod(temp, 10)))
3215                 // Keep dividing `temp` until zero.
3216                 temp := div(temp, 10)
3217                 // prettier-ignore
3218                 if iszero(temp) { break }
3219             }
3220 
3221             let length := sub(end, str)
3222             // Move the pointer 32 bytes leftwards to make room for the length.
3223             str := sub(str, 0x20)
3224             // Store the length.
3225             mstore(str, length)
3226         }
3227     }
3228 }
3229 
3230 // File: contracts/PixelatedUnknowns.sol
3231 
3232 
3233 pragma solidity 0.8.15;
3234 
3235 
3236 
3237 
3238 
3239 
3240 
3241 
3242 contract PixelatedUnknowns is ERC721A, Ownable, ReentrancyGuard {
3243 
3244   using Strings for uint256;
3245   string public baseTokenURI;
3246 
3247   uint256 public maxSupply = 5000;
3248   uint256 public publicPrice = 0.0042 ether;
3249 
3250   uint256 public MaxFreePerWallet = 1;
3251   uint256 public maxMintAmountPerWallet = 11;
3252 
3253   mapping(address => bool) freeMintClaimed; //1 Free NFT
3254 
3255   bool public paused = true;
3256 
3257   constructor(
3258     string memory _tokenName,
3259     string memory _tokenSymbol,
3260     string memory _baseTokenURI
3261   )  ERC721A(_tokenName, _tokenSymbol) { 
3262     baseTokenURI = _baseTokenURI; 
3263 
3264     }
3265 
3266   modifier callerIsUser() {
3267     require(tx.origin == msg.sender, "No smart contract minting!");
3268     _;
3269   }
3270 
3271   modifier mintCompliance(uint256 _mintAmount) {
3272     require(_mintAmount > 0  && _mintAmount <= maxMintAmountPerWallet, "Max 11 NFTs for everyone!");
3273     require(totalSupply() + _mintAmount <= maxSupply, "See you on OpenSea!");
3274     _;
3275   }
3276 
3277   function publicMint(uint256 _mintAmount) 
3278   public 
3279   payable
3280   callerIsUser 
3281   mintCompliance(_mintAmount) 
3282   nonReentrant 
3283   {
3284     require(!paused, "The portal is not open yet!");
3285     require(_numberMinted(_msgSender()) + _mintAmount <= maxMintAmountPerWallet, "Max Limit per Wallet!");
3286 
3287     if(freeMintClaimed[_msgSender()]) {
3288       require(msg.value >= _mintAmount * publicPrice, "Eth is going up, you must pay 0.0042 per NFT!");
3289     }
3290     else {
3291       require(msg.value >= (_mintAmount - 1) * publicPrice, "1 Free NFT then 0.042 for 10 NFTs!");
3292       freeMintClaimed[_msgSender()] = true;
3293     }
3294     _safeMint(_msgSender(), _mintAmount);
3295   }
3296 
3297   function mintForAddress(uint256 _mintAmount, address _to)
3298   public
3299   onlyOwner
3300   {
3301     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
3302     _safeMint(_to, _mintAmount);
3303   }
3304 
3305   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3306     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
3307     string memory currentBaseURI = _baseURI();
3308     return bytes(currentBaseURI).length > 0
3309     ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
3310     : "";
3311   }
3312 
3313   function updatePrice(uint256 _publicPrice) public onlyOwner {
3314     publicPrice = _publicPrice;
3315   }
3316 
3317   function setPaused(bool _state) public onlyOwner {
3318     paused = _state;
3319   }
3320 
3321   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
3322     maxSupply = _maxSupply;
3323   }
3324   
3325   function setBaseURI(string calldata _baseTokenURI) external onlyOwner {
3326     baseTokenURI = _baseTokenURI;
3327   }
3328 
3329   function _baseURI() internal view override returns (string memory) {
3330     return baseTokenURI;
3331   }
3332 
3333   function _startTokenId() internal pure override returns (uint256) {
3334     return 1;
3335    } 
3336 
3337   function withdraw() public onlyOwner {
3338 
3339     (bool success, ) = payable(owner()).call{value: address(this).balance}("");
3340     require(success, "ETH_TRANSFER_FAILED");
3341   }
3342 
3343 }