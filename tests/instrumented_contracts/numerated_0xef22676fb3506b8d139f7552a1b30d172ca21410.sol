1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
3 
4 pragma solidity ^0.8.0;
5 pragma experimental ABIEncoderV2;
6 
7 
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 /**
31  * @title Counters
32  * @author Matt Condon (@shrugs)
33  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
34  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
35  *
36  * Include with `using Counters for Counters.Counter;`
37  */
38 library Counters {
39     struct Counter {
40         // This variable should never be directly accessed by users of the library: interactions must be restricted to
41         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
42         // this feature: see https://github.com/ethereum/solidity/issues/4637
43         uint256 _value; // default: 0
44     }
45 
46     function current(Counter storage counter) internal view returns (uint256) {
47         return counter._value;
48     }
49 
50     function increment(Counter storage counter) internal {
51         unchecked {
52             counter._value += 1;
53         }
54     }
55 
56     function decrement(Counter storage counter) internal {
57         uint256 value = counter._value;
58         require(value > 0, "Counter: decrement overflow");
59         unchecked {
60             counter._value = value - 1;
61         }
62     }
63 
64     function reset(Counter storage counter) internal {
65         counter._value = 0;
66     }
67 }
68 
69 
70 /**
71  * @dev Standard math utilities missing in the Solidity language.
72  */
73 library Math {
74     enum Rounding {
75         Down, // Toward negative infinity
76         Up, // Toward infinity
77         Zero // Toward zero
78     }
79 
80     /**
81      * @dev Returns the largest of two numbers.
82      */
83     function max(uint256 a, uint256 b) internal pure returns (uint256) {
84         return a > b ? a : b;
85     }
86 
87     /**
88      * @dev Returns the smallest of two numbers.
89      */
90     function min(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a < b ? a : b;
92     }
93 
94     /**
95      * @dev Returns the average of two numbers. The result is rounded towards
96      * zero.
97      */
98     function average(uint256 a, uint256 b) internal pure returns (uint256) {
99         // (a + b) / 2 can overflow.
100         return (a & b) + (a ^ b) / 2;
101     }
102 
103     /**
104      * @dev Returns the ceiling of the division of two numbers.
105      *
106      * This differs from standard division with `/` in that it rounds up instead
107      * of rounding down.
108      */
109     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
110         // (a + b - 1) / b can overflow on addition, so we distribute.
111         return a == 0 ? 0 : (a - 1) / b + 1;
112     }
113 
114     /**
115      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
116      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
117      * with further edits by Uniswap Labs also under MIT license.
118      */
119     function mulDiv(
120         uint256 x,
121         uint256 y,
122         uint256 denominator
123     ) internal pure returns (uint256 result) {
124         unchecked {
125             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
126             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
127             // variables such that product = prod1 * 2^256 + prod0.
128             uint256 prod0; // Least significant 256 bits of the product
129             uint256 prod1; // Most significant 256 bits of the product
130             assembly {
131                 let mm := mulmod(x, y, not(0))
132                 prod0 := mul(x, y)
133                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
134             }
135 
136             // Handle non-overflow cases, 256 by 256 division.
137             if (prod1 == 0) {
138                 return prod0 / denominator;
139             }
140 
141             // Make sure the result is less than 2^256. Also prevents denominator == 0.
142             require(denominator > prod1);
143 
144             ///////////////////////////////////////////////
145             // 512 by 256 division.
146             ///////////////////////////////////////////////
147 
148             // Make division exact by subtracting the remainder from [prod1 prod0].
149             uint256 remainder;
150             assembly {
151                 // Compute remainder using mulmod.
152                 remainder := mulmod(x, y, denominator)
153 
154                 // Subtract 256 bit number from 512 bit number.
155                 prod1 := sub(prod1, gt(remainder, prod0))
156                 prod0 := sub(prod0, remainder)
157             }
158 
159             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
160             // See https://cs.stackexchange.com/q/138556/92363.
161 
162             // Does not overflow because the denominator cannot be zero at this stage in the function.
163             uint256 twos = denominator & (~denominator + 1);
164             assembly {
165                 // Divide denominator by twos.
166                 denominator := div(denominator, twos)
167 
168                 // Divide [prod1 prod0] by twos.
169                 prod0 := div(prod0, twos)
170 
171                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
172                 twos := add(div(sub(0, twos), twos), 1)
173             }
174 
175             // Shift in bits from prod1 into prod0.
176             prod0 |= prod1 * twos;
177 
178             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
179             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
180             // four bits. That is, denominator * inv = 1 mod 2^4.
181             uint256 inverse = (3 * denominator) ^ 2;
182 
183             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
184             // in modular arithmetic, doubling the correct bits in each step.
185             inverse *= 2 - denominator * inverse; // inverse mod 2^8
186             inverse *= 2 - denominator * inverse; // inverse mod 2^16
187             inverse *= 2 - denominator * inverse; // inverse mod 2^32
188             inverse *= 2 - denominator * inverse; // inverse mod 2^64
189             inverse *= 2 - denominator * inverse; // inverse mod 2^128
190             inverse *= 2 - denominator * inverse; // inverse mod 2^256
191 
192             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
193             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
194             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
195             // is no longer required.
196             result = prod0 * inverse;
197             return result;
198         }
199     }
200 
201     /**
202      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
203      */
204     function mulDiv(
205         uint256 x,
206         uint256 y,
207         uint256 denominator,
208         Rounding rounding
209     ) internal pure returns (uint256) {
210         uint256 result = mulDiv(x, y, denominator);
211         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
212             result += 1;
213         }
214         return result;
215     }
216 
217     /**
218      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
219      *
220      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
221      */
222     function sqrt(uint256 a) internal pure returns (uint256) {
223         if (a == 0) {
224             return 0;
225         }
226 
227         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
228         //
229         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
230         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
231         //
232         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
233         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
234         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
235         //
236         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
237         uint256 result = 1 << (log2(a) >> 1);
238 
239         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
240         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
241         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
242         // into the expected uint128 result.
243         unchecked {
244             result = (result + a / result) >> 1;
245             result = (result + a / result) >> 1;
246             result = (result + a / result) >> 1;
247             result = (result + a / result) >> 1;
248             result = (result + a / result) >> 1;
249             result = (result + a / result) >> 1;
250             result = (result + a / result) >> 1;
251             return min(result, a / result);
252         }
253     }
254 
255     /**
256      * @notice Calculates sqrt(a), following the selected rounding direction.
257      */
258     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
259         unchecked {
260             uint256 result = sqrt(a);
261             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
262         }
263     }
264 
265     /**
266      * @dev Return the log in base 2, rounded down, of a positive value.
267      * Returns 0 if given 0.
268      */
269     function log2(uint256 value) internal pure returns (uint256) {
270         uint256 result = 0;
271         unchecked {
272             if (value >> 128 > 0) {
273                 value >>= 128;
274                 result += 128;
275             }
276             if (value >> 64 > 0) {
277                 value >>= 64;
278                 result += 64;
279             }
280             if (value >> 32 > 0) {
281                 value >>= 32;
282                 result += 32;
283             }
284             if (value >> 16 > 0) {
285                 value >>= 16;
286                 result += 16;
287             }
288             if (value >> 8 > 0) {
289                 value >>= 8;
290                 result += 8;
291             }
292             if (value >> 4 > 0) {
293                 value >>= 4;
294                 result += 4;
295             }
296             if (value >> 2 > 0) {
297                 value >>= 2;
298                 result += 2;
299             }
300             if (value >> 1 > 0) {
301                 result += 1;
302             }
303         }
304         return result;
305     }
306 
307     /**
308      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
309      * Returns 0 if given 0.
310      */
311     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
312         unchecked {
313             uint256 result = log2(value);
314             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
315         }
316     }
317 
318     /**
319      * @dev Return the log in base 10, rounded down, of a positive value.
320      * Returns 0 if given 0.
321      */
322     function log10(uint256 value) internal pure returns (uint256) {
323         uint256 result = 0;
324         unchecked {
325             if (value >= 10**64) {
326                 value /= 10**64;
327                 result += 64;
328             }
329             if (value >= 10**32) {
330                 value /= 10**32;
331                 result += 32;
332             }
333             if (value >= 10**16) {
334                 value /= 10**16;
335                 result += 16;
336             }
337             if (value >= 10**8) {
338                 value /= 10**8;
339                 result += 8;
340             }
341             if (value >= 10**4) {
342                 value /= 10**4;
343                 result += 4;
344             }
345             if (value >= 10**2) {
346                 value /= 10**2;
347                 result += 2;
348             }
349             if (value >= 10**1) {
350                 result += 1;
351             }
352         }
353         return result;
354     }
355 
356     /**
357      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
358      * Returns 0 if given 0.
359      */
360     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
361         unchecked {
362             uint256 result = log10(value);
363             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
364         }
365     }
366 
367     /**
368      * @dev Return the log in base 256, rounded down, of a positive value.
369      * Returns 0 if given 0.
370      *
371      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
372      */
373     function log256(uint256 value) internal pure returns (uint256) {
374         uint256 result = 0;
375         unchecked {
376             if (value >> 128 > 0) {
377                 value >>= 128;
378                 result += 16;
379             }
380             if (value >> 64 > 0) {
381                 value >>= 64;
382                 result += 8;
383             }
384             if (value >> 32 > 0) {
385                 value >>= 32;
386                 result += 4;
387             }
388             if (value >> 16 > 0) {
389                 value >>= 16;
390                 result += 2;
391             }
392             if (value >> 8 > 0) {
393                 result += 1;
394             }
395         }
396         return result;
397     }
398 
399     /**
400      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
401      * Returns 0 if given 0.
402      */
403     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
404         unchecked {
405             uint256 result = log256(value);
406             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
407         }
408     }
409 }
410 
411 
412 
413 /**
414  * @dev String operations.
415  */
416 library Strings {
417     bytes16 private constant _SYMBOLS = "0123456789abcdef";
418     uint8 private constant _ADDRESS_LENGTH = 20;
419 
420     /**
421      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
422      */
423     function toString(uint256 value) internal pure returns (string memory) {
424         unchecked {
425             uint256 length = Math.log10(value) + 1;
426             string memory buffer = new string(length);
427             uint256 ptr;
428             /// @solidity memory-safe-assembly
429             assembly {
430                 ptr := add(buffer, add(32, length))
431             }
432             while (true) {
433                 ptr--;
434                 /// @solidity memory-safe-assembly
435                 assembly {
436                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
437                 }
438                 value /= 10;
439                 if (value == 0) break;
440             }
441             return buffer;
442         }
443     }
444 
445     /**
446      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
447      */
448     function toHexString(uint256 value) internal pure returns (string memory) {
449         unchecked {
450             return toHexString(value, Math.log256(value) + 1);
451         }
452     }
453 
454     /**
455      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
456      */
457     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
458         bytes memory buffer = new bytes(2 * length + 2);
459         buffer[0] = "0";
460         buffer[1] = "x";
461         for (uint256 i = 2 * length + 1; i > 1; --i) {
462             buffer[i] = _SYMBOLS[value & 0xf];
463             value >>= 4;
464         }
465         require(value == 0, "Strings: hex length insufficient");
466         return string(buffer);
467     }
468 
469     /**
470      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
471      */
472     function toHexString(address addr) internal pure returns (string memory) {
473         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
474     }
475 }
476 
477 
478 library SafeMath {
479     /**
480      * @dev Returns the addition of two unsigned integers, with an overflow flag.
481      *
482      * _Available since v3.4._
483      */
484     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
485         unchecked {
486             uint256 c = a + b;
487             if (c < a) return (false, 0);
488             return (true, c);
489         }
490     }
491 
492     /**
493      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
494      *
495      * _Available since v3.4._
496      */
497     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
498         unchecked {
499             if (b > a) return (false, 0);
500             return (true, a - b);
501         }
502     }
503 
504     /**
505      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
506      *
507      * _Available since v3.4._
508      */
509     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
510         unchecked {
511             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
512             // benefit is lost if 'b' is also tested.
513             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
514             if (a == 0) return (true, 0);
515             uint256 c = a * b;
516             if (c / a != b) return (false, 0);
517             return (true, c);
518         }
519     }
520 
521     /**
522      * @dev Returns the division of two unsigned integers, with a division by zero flag.
523      *
524      * _Available since v3.4._
525      */
526     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
527         unchecked {
528             if (b == 0) return (false, 0);
529             return (true, a / b);
530         }
531     }
532 
533     /**
534      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
535      *
536      * _Available since v3.4._
537      */
538     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
539         unchecked {
540             if (b == 0) return (false, 0);
541             return (true, a % b);
542         }
543     }
544 
545     /**
546      * @dev Returns the addition of two unsigned integers, reverting on
547      * overflow.
548      *
549      * Counterpart to Solidity's `+` operator.
550      *
551      * Requirements:
552      *
553      * - Addition cannot overflow.
554      */
555     function add(uint256 a, uint256 b) internal pure returns (uint256) {
556         return a + b;
557     }
558 
559     /**
560      * @dev Returns the subtraction of two unsigned integers, reverting on
561      * overflow (when the result is negative).
562      *
563      * Counterpart to Solidity's `-` operator.
564      *
565      * Requirements:
566      *
567      * - Subtraction cannot overflow.
568      */
569     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
570         return a - b;
571     }
572 
573     /**
574      * @dev Returns the multiplication of two unsigned integers, reverting on
575      * overflow.
576      *
577      * Counterpart to Solidity's `*` operator.
578      *
579      * Requirements:
580      *
581      * - Multiplication cannot overflow.
582      */
583     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
584         return a * b;
585     }
586 
587     /**
588      * @dev Returns the integer division of two unsigned integers, reverting on
589      * division by zero. The result is rounded towards zero.
590      *
591      * Counterpart to Solidity's `/` operator.
592      *
593      * Requirements:
594      *
595      * - The divisor cannot be zero.
596      */
597     function div(uint256 a, uint256 b) internal pure returns (uint256) {
598         return a / b;
599     }
600 
601     /**
602      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
603      * reverting when dividing by zero.
604      *
605      * Counterpart to Solidity's `%` operator. This function uses a `revert`
606      * opcode (which leaves remaining gas untouched) while Solidity uses an
607      * invalid opcode to revert (consuming all remaining gas).
608      *
609      * Requirements:
610      *
611      * - The divisor cannot be zero.
612      */
613     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
614         return a % b;
615     }
616 
617     /**
618      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
619      * overflow (when the result is negative).
620      *
621      * CAUTION: This function is deprecated because it requires allocating memory for the error
622      * message unnecessarily. For custom revert reasons use {trySub}.
623      *
624      * Counterpart to Solidity's `-` operator.
625      *
626      * Requirements:
627      *
628      * - Subtraction cannot overflow.
629      */
630     function sub(
631         uint256 a,
632         uint256 b,
633         string memory errorMessage
634     ) internal pure returns (uint256) {
635         unchecked {
636             require(b <= a, errorMessage);
637             return a - b;
638         }
639     }
640 
641     /**
642      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
643      * division by zero. The result is rounded towards zero.
644      *
645      * Counterpart to Solidity's `/` operator. Note: this function uses a
646      * `revert` opcode (which leaves remaining gas untouched) while Solidity
647      * uses an invalid opcode to revert (consuming all remaining gas).
648      *
649      * Requirements:
650      *
651      * - The divisor cannot be zero.
652      */
653     function div(
654         uint256 a,
655         uint256 b,
656         string memory errorMessage
657     ) internal pure returns (uint256) {
658         unchecked {
659             require(b > 0, errorMessage);
660             return a / b;
661         }
662     }
663 
664     /**
665      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
666      * reverting with custom message when dividing by zero.
667      *
668      * CAUTION: This function is deprecated because it requires allocating memory for the error
669      * message unnecessarily. For custom revert reasons use {tryMod}.
670      *
671      * Counterpart to Solidity's `%` operator. This function uses a `revert`
672      * opcode (which leaves remaining gas untouched) while Solidity uses an
673      * invalid opcode to revert (consuming all remaining gas).
674      *
675      * Requirements:
676      *
677      * - The divisor cannot be zero.
678      */
679     function mod(
680         uint256 a,
681         uint256 b,
682         string memory errorMessage
683     ) internal pure returns (uint256) {
684         unchecked {
685             require(b > 0, errorMessage);
686             return a % b;
687         }
688     }
689 }
690 
691 
692 abstract contract Ownable is Context {
693     address private _owner;
694 
695     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
696 
697     /**
698      * @dev Initializes the contract setting the deployer as the initial owner.
699      */
700     constructor() {
701         _transferOwnership(_msgSender());
702     }
703 
704     /**
705      * @dev Returns the address of the current owner.
706      */
707     function owner() public view virtual returns (address) {
708         return _owner;
709     }
710 
711     /**
712      * @dev Throws if called by any account other than the owner.
713      */
714     modifier onlyOwner() {
715         require(owner() == _msgSender(), "Ownable: caller is not the owner");
716         _;
717     }
718 
719     /**
720      * @dev Leaves the contract without owner. It will not be possible to call
721      * `onlyOwner` functions anymore. Can only be called by the current owner.
722      *
723      * NOTE: Renouncing ownership will leave the contract without an owner,
724      * thereby removing any functionality that is only available to the owner.
725      */
726     function renounceOwnership() public virtual onlyOwner {
727         _transferOwnership(address(0));
728     }
729 
730     /**
731      * @dev Transfers ownership of the contract to a new account (`newOwner`).
732      * Can only be called by the current owner.
733      */
734     function transferOwnership(address newOwner) public virtual onlyOwner {
735         require(newOwner != address(0), "Ownable: new owner is the zero address");
736         _transferOwnership(newOwner);
737     }
738 
739     /**
740      * @dev Transfers ownership of the contract to a new account (`newOwner`).
741      * Internal function without access restriction.
742      */
743     function _transferOwnership(address newOwner) internal virtual {
744         address oldOwner = _owner;
745         _owner = newOwner;
746         emit OwnershipTransferred(oldOwner, newOwner);
747     }
748 }
749 
750 
751 
752 /**
753  * @dev Interface of the ERC165 standard, as defined in the
754  * https://eips.ethereum.org/EIPS/eip-165[EIP].
755  *
756  * Implementers can declare support of contract interfaces, which can then be
757  * queried by others ({ERC165Checker}).
758  *
759  * For an implementation, see {ERC165}.
760  */
761 interface IERC165 {
762     /**
763      * @dev Returns true if this contract implements the interface defined by
764      * `interfaceId`. See the corresponding
765      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
766      * to learn more about how these ids are created.
767      *
768      * This function call must use less than 30 000 gas.
769      */
770     function supportsInterface(bytes4 interfaceId) external view returns (bool);
771 }
772 
773 
774 
775 interface IERC721 is IERC165 {
776     /**
777      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
778      */
779     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
780 
781     /**
782      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
783      */
784     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
785 
786     /**
787      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
788      */
789     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
790 
791     /**
792      * @dev Returns the number of tokens in ``owner``'s account.
793      */
794     function balanceOf(address owner) external view returns (uint256 balance);
795 
796     /**
797      * @dev Returns the owner of the `tokenId` token.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      */
803     function ownerOf(uint256 tokenId) external view returns (address owner);
804 
805     /**
806      * @dev Safely transfers `tokenId` token from `from` to `to`.
807      *
808      * Requirements:
809      *
810      * - `from` cannot be the zero address.
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must exist and be owned by `from`.
813      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId,
822         bytes calldata data
823     ) external;
824 
825     /**
826      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
827      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
828      *
829      * Requirements:
830      *
831      * - `from` cannot be the zero address.
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must exist and be owned by `from`.
834      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
835      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
836      *
837      * Emits a {Transfer} event.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) external;
844 
845     /**
846      * @dev Transfers `tokenId` token from `from` to `to`.
847      *
848      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must be owned by `from`.
855      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
856      *
857      * Emits a {Transfer} event.
858      */
859     function transferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) external;
864 
865     /**
866      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
867      * The approval is cleared when the token is transferred.
868      *
869      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
870      *
871      * Requirements:
872      *
873      * - The caller must own the token or be an approved operator.
874      * - `tokenId` must exist.
875      *
876      * Emits an {Approval} event.
877      */
878     function approve(address to, uint256 tokenId) external;
879 
880     /**
881      * @dev Approve or remove `operator` as an operator for the caller.
882      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
883      *
884      * Requirements:
885      *
886      * - The `operator` cannot be the caller.
887      *
888      * Emits an {ApprovalForAll} event.
889      */
890     function setApprovalForAll(address operator, bool _approved) external;
891 
892     /**
893      * @dev Returns the account approved for `tokenId` token.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      */
899     function getApproved(uint256 tokenId) external view returns (address operator);
900 
901     /**
902      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
903      *
904      * See {setApprovalForAll}
905      */
906     function isApprovedForAll(address owner, address operator) external view returns (bool);
907 }
908 
909 
910 interface IERC721Receiver {
911     /**
912      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
913      * by `operator` from `from`, this function is called.
914      *
915      * It must return its Solidity selector to confirm the token transfer.
916      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
917      *
918      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
919      */
920     function onERC721Received(
921         address operator,
922         address from,
923         uint256 tokenId,
924         bytes calldata data
925     ) external returns (bytes4);
926 }
927 
928 
929 interface IERC721Metadata is IERC721 {
930     /**
931      * @dev Returns the token collection name.
932      */
933     function name() external view returns (string memory);
934 
935     /**
936      * @dev Returns the token collection symbol.
937      */
938     function symbol() external view returns (string memory);
939 
940     /**
941      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
942      */
943     function tokenURI(uint256 tokenId) external view returns (string memory);
944 }
945 
946 
947 library Address {
948     /**
949      * @dev Returns true if `account` is a contract.
950      *
951      * [IMPORTANT]
952      * ====
953      * It is unsafe to assume that an address for which this function returns
954      * false is an externally-owned account (EOA) and not a contract.
955      *
956      * Among others, `isContract` will return false for the following
957      * types of addresses:
958      *
959      *  - an externally-owned account
960      *  - a contract in construction
961      *  - an address where a contract will be created
962      *  - an address where a contract lived, but was destroyed
963      * ====
964      *
965      * [IMPORTANT]
966      * ====
967      * You shouldn't rely on `isContract` to protect against flash loan attacks!
968      *
969      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
970      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
971      * constructor.
972      * ====
973      */
974     function isContract(address account) internal view returns (bool) {
975         // This method relies on extcodesize/address.code.length, which returns 0
976         // for contracts in construction, since the code is only stored at the end
977         // of the constructor execution.
978 
979         return account.code.length > 0;
980     }
981 
982     /**
983      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
984      * `recipient`, forwarding all available gas and reverting on errors.
985      *
986      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
987      * of certain opcodes, possibly making contracts go over the 2300 gas limit
988      * imposed by `transfer`, making them unable to receive funds via
989      * `transfer`. {sendValue} removes this limitation.
990      *
991      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
992      *
993      * IMPORTANT: because control is transferred to `recipient`, care must be
994      * taken to not create reentrancy vulnerabilities. Consider using
995      * {ReentrancyGuard} or the
996      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
997      */
998     function sendValue(address payable recipient, uint256 amount) internal {
999         require(address(this).balance >= amount, "Address: insufficient balance");
1000 
1001         (bool success, ) = recipient.call{value: amount}("");
1002         require(success, "Address: unable to send value, recipient may have reverted");
1003     }
1004 
1005     /**
1006      * @dev Performs a Solidity function call using a low level `call`. A
1007      * plain `call` is an unsafe replacement for a function call: use this
1008      * function instead.
1009      *
1010      * If `target` reverts with a revert reason, it is bubbled up by this
1011      * function (like regular Solidity function calls).
1012      *
1013      * Returns the raw returned data. To convert to the expected return value,
1014      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1015      *
1016      * Requirements:
1017      *
1018      * - `target` must be a contract.
1019      * - calling `target` with `data` must not revert.
1020      *
1021      * _Available since v3.1._
1022      */
1023     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1024         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1025     }
1026 
1027     /**
1028      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1029      * `errorMessage` as a fallback revert reason when `target` reverts.
1030      *
1031      * _Available since v3.1._
1032      */
1033     function functionCall(
1034         address target,
1035         bytes memory data,
1036         string memory errorMessage
1037     ) internal returns (bytes memory) {
1038         return functionCallWithValue(target, data, 0, errorMessage);
1039     }
1040 
1041     /**
1042      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1043      * but also transferring `value` wei to `target`.
1044      *
1045      * Requirements:
1046      *
1047      * - the calling contract must have an ETH balance of at least `value`.
1048      * - the called Solidity function must be `payable`.
1049      *
1050      * _Available since v3.1._
1051      */
1052     function functionCallWithValue(
1053         address target,
1054         bytes memory data,
1055         uint256 value
1056     ) internal returns (bytes memory) {
1057         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1058     }
1059 
1060     /**
1061      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1062      * with `errorMessage` as a fallback revert reason when `target` reverts.
1063      *
1064      * _Available since v3.1._
1065      */
1066     function functionCallWithValue(
1067         address target,
1068         bytes memory data,
1069         uint256 value,
1070         string memory errorMessage
1071     ) internal returns (bytes memory) {
1072         require(address(this).balance >= value, "Address: insufficient balance for call");
1073         (bool success, bytes memory returndata) = target.call{value: value}(data);
1074         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1075     }
1076 
1077     /**
1078      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1079      * but performing a static call.
1080      *
1081      * _Available since v3.3._
1082      */
1083     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1084         return functionStaticCall(target, data, "Address: low-level static call failed");
1085     }
1086 
1087     /**
1088      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1089      * but performing a static call.
1090      *
1091      * _Available since v3.3._
1092      */
1093     function functionStaticCall(
1094         address target,
1095         bytes memory data,
1096         string memory errorMessage
1097     ) internal view returns (bytes memory) {
1098         (bool success, bytes memory returndata) = target.staticcall(data);
1099         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1100     }
1101 
1102     /**
1103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1104      * but performing a delegate call.
1105      *
1106      * _Available since v3.4._
1107      */
1108     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1109         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1110     }
1111 
1112     /**
1113      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1114      * but performing a delegate call.
1115      *
1116      * _Available since v3.4._
1117      */
1118     function functionDelegateCall(
1119         address target,
1120         bytes memory data,
1121         string memory errorMessage
1122     ) internal returns (bytes memory) {
1123         (bool success, bytes memory returndata) = target.delegatecall(data);
1124         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1125     }
1126 
1127     /**
1128      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1129      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1130      *
1131      * _Available since v4.8._
1132      */
1133     function verifyCallResultFromTarget(
1134         address target,
1135         bool success,
1136         bytes memory returndata,
1137         string memory errorMessage
1138     ) internal view returns (bytes memory) {
1139         if (success) {
1140             if (returndata.length == 0) {
1141                 // only check isContract if the call was successful and the return data is empty
1142                 // otherwise we already know that it was a contract
1143                 require(isContract(target), "Address: call to non-contract");
1144             }
1145             return returndata;
1146         } else {
1147             _revert(returndata, errorMessage);
1148         }
1149     }
1150 
1151     /**
1152      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1153      * revert reason or using the provided one.
1154      *
1155      * _Available since v4.3._
1156      */
1157     function verifyCallResult(
1158         bool success,
1159         bytes memory returndata,
1160         string memory errorMessage
1161     ) internal pure returns (bytes memory) {
1162         if (success) {
1163             return returndata;
1164         } else {
1165             _revert(returndata, errorMessage);
1166         }
1167     }
1168 
1169     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1170         // Look for revert reason and bubble it up if present
1171         if (returndata.length > 0) {
1172             // The easiest way to bubble the revert reason is using memory via assembly
1173             /// @solidity memory-safe-assembly
1174             assembly {
1175                 let returndata_size := mload(returndata)
1176                 revert(add(32, returndata), returndata_size)
1177             }
1178         } else {
1179             revert(errorMessage);
1180         }
1181     }
1182 }
1183 
1184 abstract contract ERC165 is IERC165 {
1185     /**
1186      * @dev See {IERC165-supportsInterface}.
1187      */
1188     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1189         return interfaceId == type(IERC165).interfaceId;
1190     }
1191 }
1192 
1193 
1194 /**
1195  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1196  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1197  * {ERC721Enumerable}.
1198  */
1199 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1200     using Address for address;
1201     using Strings for uint256;
1202 
1203     // Token name
1204     string private _name;
1205 
1206     // Token symbol
1207     string private _symbol;
1208 
1209     // Mapping from token ID to owner address
1210     mapping(uint256 => address) private _owners;
1211 
1212     // Mapping owner address to token count
1213     mapping(address => uint256) private _balances;
1214 
1215     // Mapping from token ID to approved address
1216     mapping(uint256 => address) private _tokenApprovals;
1217 
1218     // Mapping from owner to operator approvals
1219     mapping(address => mapping(address => bool)) private _operatorApprovals;
1220 
1221     /**
1222      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1223      */
1224     constructor(string memory name_, string memory symbol_) {
1225         _name = name_;
1226         _symbol = symbol_;
1227     }
1228 
1229     /**
1230      * @dev See {IERC165-supportsInterface}.
1231      */
1232     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1233         return
1234             interfaceId == type(IERC721).interfaceId ||
1235             interfaceId == type(IERC721Metadata).interfaceId ||
1236             super.supportsInterface(interfaceId);
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-balanceOf}.
1241      */
1242     function balanceOf(address owner) public view virtual override returns (uint256) {
1243         require(owner != address(0), "ERC721: balance query for the zero address");
1244         return _balances[owner];
1245     }
1246 
1247     /**
1248      * @dev See {IERC721-ownerOf}.
1249      */
1250     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1251         address owner = _owners[tokenId];
1252         require(owner != address(0), "ERC721: owner query for nonexistent token");
1253         return owner;
1254     }
1255 
1256     /**
1257      * @dev See {IERC721Metadata-name}.
1258      */
1259     function name() public view virtual override returns (string memory) {
1260         return _name;
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Metadata-symbol}.
1265      */
1266     function symbol() public view virtual override returns (string memory) {
1267         return _symbol;
1268     }
1269 
1270     /**
1271      * @dev See {IERC721Metadata-tokenURI}.
1272      */
1273     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1274         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1275 
1276         string memory baseURI = _baseURI();
1277         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1278     }
1279 
1280     /**
1281      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1282      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1283      * by default, can be overridden in child contracts.
1284      */
1285     function _baseURI() internal view virtual returns (string memory) {
1286         return "";
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-approve}.
1291      */
1292     function approve(address to, uint256 tokenId) public virtual override {
1293         address owner = ERC721.ownerOf(tokenId);
1294         require(to != owner, "ERC721: approval to current owner");
1295 
1296         require(
1297             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1298             "ERC721: approve caller is not owner nor approved for all"
1299         );
1300 
1301         _approve(to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev See {IERC721-getApproved}.
1306      */
1307     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1308         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1309 
1310         return _tokenApprovals[tokenId];
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-setApprovalForAll}.
1315      */
1316     function setApprovalForAll(address operator, bool approved) public virtual override {
1317         _setApprovalForAll(_msgSender(), operator, approved);
1318     }
1319 
1320     /**
1321      * @dev See {IERC721-isApprovedForAll}.
1322      */
1323     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1324         return _operatorApprovals[owner][operator];
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-transferFrom}.
1329      */
1330     function transferFrom(
1331         address from,
1332         address to,
1333         uint256 tokenId
1334     ) public virtual override {
1335         //solhint-disable-next-line max-line-length
1336         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1337 
1338         _transfer(from, to, tokenId);
1339     }
1340 
1341     /**
1342      * @dev See {IERC721-safeTransferFrom}.
1343      */
1344     function safeTransferFrom(
1345         address from,
1346         address to,
1347         uint256 tokenId
1348     ) public virtual override {
1349         safeTransferFrom(from, to, tokenId, "");
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-safeTransferFrom}.
1354      */
1355     function safeTransferFrom(
1356         address from,
1357         address to,
1358         uint256 tokenId,
1359         bytes memory _data
1360     ) public virtual override {
1361         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1362         _safeTransfer(from, to, tokenId, _data);
1363     }
1364 
1365     /**
1366      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1367      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1368      *
1369      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1370      *
1371      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1372      * implement alternative mechanisms to perform token transfer, such as signature-based.
1373      *
1374      * Requirements:
1375      *
1376      * - `from` cannot be the zero address.
1377      * - `to` cannot be the zero address.
1378      * - `tokenId` token must exist and be owned by `from`.
1379      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1380      *
1381      * Emits a {Transfer} event.
1382      */
1383     function _safeTransfer(
1384         address from,
1385         address to,
1386         uint256 tokenId,
1387         bytes memory _data
1388     ) internal virtual {
1389         _transfer(from, to, tokenId);
1390         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1391     }
1392 
1393     /**
1394      * @dev Returns whether `tokenId` exists.
1395      *
1396      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1397      *
1398      * Tokens start existing when they are minted (`_mint`),
1399      * and stop existing when they are burned (`_burn`).
1400      */
1401     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1402         return _owners[tokenId] != address(0);
1403     }
1404 
1405     /**
1406      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1407      *
1408      * Requirements:
1409      *
1410      * - `tokenId` must exist.
1411      */
1412     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1413         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1414         address owner = ERC721.ownerOf(tokenId);
1415         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1416     }
1417 
1418     /**
1419      * @dev Safely mints `tokenId` and transfers it to `to`.
1420      *
1421      * Requirements:
1422      *
1423      * - `tokenId` must not exist.
1424      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1425      *
1426      * Emits a {Transfer} event.
1427      */
1428     function _safeMint(address to, uint256 tokenId) internal virtual {
1429         _safeMint(to, tokenId, "");
1430     }
1431 
1432     /**
1433      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1434      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1435      */
1436     function _safeMint(
1437         address to,
1438         uint256 tokenId,
1439         bytes memory _data
1440     ) internal virtual {
1441         _mint(to, tokenId);
1442         require(
1443             _checkOnERC721Received(address(0), to, tokenId, _data),
1444             "ERC721: transfer to non ERC721Receiver implementer"
1445         );
1446     }
1447 
1448     /**
1449      * @dev Mints `tokenId` and transfers it to `to`.
1450      *
1451      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1452      *
1453      * Requirements:
1454      *
1455      * - `tokenId` must not exist.
1456      * - `to` cannot be the zero address.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _mint(address to, uint256 tokenId) internal virtual {
1461         require(to != address(0), "ERC721: mint to the zero address");
1462         require(!_exists(tokenId), "ERC721: token already minted");
1463 
1464         _beforeTokenTransfer(address(0), to, tokenId);
1465 
1466         _balances[to] += 1;
1467         _owners[tokenId] = to;
1468 
1469         emit Transfer(address(0), to, tokenId);
1470 
1471         _afterTokenTransfer(address(0), to, tokenId);
1472     }
1473 
1474     /**
1475      * @dev Destroys `tokenId`.
1476      * The approval is cleared when the token is burned.
1477      *
1478      * Requirements:
1479      *
1480      * - `tokenId` must exist.
1481      *
1482      * Emits a {Transfer} event.
1483      */
1484     function _burn(uint256 tokenId) internal virtual {
1485         address owner = ERC721.ownerOf(tokenId);
1486 
1487         _beforeTokenTransfer(owner, address(0), tokenId);
1488 
1489         // Clear approvals
1490         _approve(address(0), tokenId);
1491 
1492         _balances[owner] -= 1;
1493         delete _owners[tokenId];
1494 
1495         emit Transfer(owner, address(0), tokenId);
1496 
1497         _afterTokenTransfer(owner, address(0), tokenId);
1498     }
1499 
1500     /**
1501      * @dev Transfers `tokenId` from `from` to `to`.
1502      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1503      *
1504      * Requirements:
1505      *
1506      * - `to` cannot be the zero address.
1507      * - `tokenId` token must be owned by `from`.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function _transfer(
1512         address from,
1513         address to,
1514         uint256 tokenId
1515     ) internal virtual {
1516         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1517         require(to != address(0), "ERC721: transfer to the zero address");
1518 
1519         _beforeTokenTransfer(from, to, tokenId);
1520 
1521         // Clear approvals from the previous owner
1522         _approve(address(0), tokenId);
1523 
1524         _balances[from] -= 1;
1525         _balances[to] += 1;
1526         _owners[tokenId] = to;
1527 
1528         emit Transfer(from, to, tokenId);
1529 
1530         _afterTokenTransfer(from, to, tokenId);
1531     }
1532 
1533     /**
1534      * @dev Approve `to` to operate on `tokenId`
1535      *
1536      * Emits a {Approval} event.
1537      */
1538     function _approve(address to, uint256 tokenId) internal virtual {
1539         _tokenApprovals[tokenId] = to;
1540         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1541     }
1542 
1543     /**
1544      * @dev Approve `operator` to operate on all of `owner` tokens
1545      *
1546      * Emits a {ApprovalForAll} event.
1547      */
1548     function _setApprovalForAll(
1549         address owner,
1550         address operator,
1551         bool approved
1552     ) internal virtual {
1553         require(owner != operator, "ERC721: approve to caller");
1554         _operatorApprovals[owner][operator] = approved;
1555         emit ApprovalForAll(owner, operator, approved);
1556     }
1557 
1558     /**
1559      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1560      * The call is not executed if the target address is not a contract.
1561      *
1562      * @param from address representing the previous owner of the given token ID
1563      * @param to target address that will receive the tokens
1564      * @param tokenId uint256 ID of the token to be transferred
1565      * @param _data bytes optional data to send along with the call
1566      * @return bool whether the call correctly returned the expected magic value
1567      */
1568     function _checkOnERC721Received(
1569         address from,
1570         address to,
1571         uint256 tokenId,
1572         bytes memory _data
1573     ) private returns (bool) {
1574         if (to.isContract()) {
1575             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1576                 return retval == IERC721Receiver.onERC721Received.selector;
1577             } catch (bytes memory reason) {
1578                 if (reason.length == 0) {
1579                     revert("ERC721: transfer to non ERC721Receiver implementer");
1580                 } else {
1581                     assembly {
1582                         revert(add(32, reason), mload(reason))
1583                     }
1584                 }
1585             }
1586         } else {
1587             return true;
1588         }
1589     }
1590 
1591     /**
1592      * @dev Hook that is called before any token transfer. This includes minting
1593      * and burning.
1594      *
1595      * Calling conditions:
1596      *
1597      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1598      * transferred to `to`.
1599      * - When `from` is zero, `tokenId` will be minted for `to`.
1600      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1601      * - `from` and `to` are never both zero.
1602      *
1603      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1604      */
1605     function _beforeTokenTransfer(
1606         address from,
1607         address to,
1608         uint256 tokenId
1609     ) internal virtual {}
1610 
1611     /**
1612      * @dev Hook that is called after any transfer of tokens. This includes
1613      * minting and burning.
1614      *
1615      * Calling conditions:
1616      *
1617      * - when `from` and `to` are both non-zero.
1618      * - `from` and `to` are never both zero.
1619      *
1620      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1621      */
1622     function _afterTokenTransfer(
1623         address from,
1624         address to,
1625         uint256 tokenId
1626     ) internal virtual {}
1627 }
1628 
1629 
1630 
1631 /**
1632  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1633  * @dev See https://eips.ethereum.org/EIPS/eip-721
1634  */
1635 interface IERC721Enumerable is IERC721 {
1636     /**
1637      * @dev Returns the total amount of tokens stored by the contract.
1638      */
1639     function totalSupply() external view returns (uint256);
1640 
1641     /**
1642      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1643      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1644      */
1645     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1646 
1647     /**
1648      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1649      * Use along with {totalSupply} to enumerate all tokens.
1650      */
1651     function tokenByIndex(uint256 index) external view returns (uint256);
1652 }
1653 
1654 
1655 
1656 /**
1657  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1658  * enumerability of all the token ids in the contract as well as all token ids owned by each
1659  * account.
1660  */
1661 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1662     // Mapping from owner to list of owned token IDs
1663     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1664 
1665     // Mapping from token ID to index of the owner tokens list
1666     mapping(uint256 => uint256) private _ownedTokensIndex;
1667 
1668     // Array with all token ids, used for enumeration
1669     uint256[] private _allTokens;
1670 
1671     // Mapping from token id to position in the allTokens array
1672     mapping(uint256 => uint256) private _allTokensIndex;
1673 
1674     /**
1675      * @dev See {IERC165-supportsInterface}.
1676      */
1677     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1678         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1679     }
1680 
1681     /**
1682      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1683      */
1684     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1685         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1686         return _ownedTokens[owner][index];
1687     }
1688 
1689     /**
1690      * @dev See {IERC721Enumerable-totalSupply}.
1691      */
1692     function totalSupply() public view virtual override returns (uint256) {
1693         return _allTokens.length;
1694     }
1695 
1696     /**
1697      * @dev See {IERC721Enumerable-tokenByIndex}.
1698      */
1699     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1700         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1701         return _allTokens[index];
1702     }
1703 
1704     /**
1705      * @dev Hook that is called before any token transfer. This includes minting
1706      * and burning.
1707      *
1708      * Calling conditions:
1709      *
1710      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1711      * transferred to `to`.
1712      * - When `from` is zero, `tokenId` will be minted for `to`.
1713      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1714      * - `from` cannot be the zero address.
1715      * - `to` cannot be the zero address.
1716      *
1717      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1718      */
1719     function _beforeTokenTransfer(
1720         address from,
1721         address to,
1722         uint256 tokenId
1723     ) internal virtual override {
1724         super._beforeTokenTransfer(from, to, tokenId);
1725 
1726         if (from == address(0)) {
1727             _addTokenToAllTokensEnumeration(tokenId);
1728         } else if (from != to) {
1729             _removeTokenFromOwnerEnumeration(from, tokenId);
1730         }
1731         if (to == address(0)) {
1732             _removeTokenFromAllTokensEnumeration(tokenId);
1733         } else if (to != from) {
1734             _addTokenToOwnerEnumeration(to, tokenId);
1735         }
1736     }
1737 
1738     /**
1739      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1740      * @param to address representing the new owner of the given token ID
1741      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1742      */
1743     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1744         uint256 length = ERC721.balanceOf(to);
1745         _ownedTokens[to][length] = tokenId;
1746         _ownedTokensIndex[tokenId] = length;
1747     }
1748 
1749     /**
1750      * @dev Private function to add a token to this extension's token tracking data structures.
1751      * @param tokenId uint256 ID of the token to be added to the tokens list
1752      */
1753     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1754         _allTokensIndex[tokenId] = _allTokens.length;
1755         _allTokens.push(tokenId);
1756     }
1757 
1758     /**
1759      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1760      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1761      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1762      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1763      * @param from address representing the previous owner of the given token ID
1764      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1765      */
1766     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1767         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1768         // then delete the last slot (swap and pop).
1769 
1770         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1771         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1772 
1773         // When the token to delete is the last token, the swap operation is unnecessary
1774         if (tokenIndex != lastTokenIndex) {
1775             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1776 
1777             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1778             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1779         }
1780 
1781         // This also deletes the contents at the last position of the array
1782         delete _ownedTokensIndex[tokenId];
1783         delete _ownedTokens[from][lastTokenIndex];
1784     }
1785 
1786     /**
1787      * @dev Private function to remove a token from this extension's token tracking data structures.
1788      * This has O(1) time complexity, but alters the order of the _allTokens array.
1789      * @param tokenId uint256 ID of the token to be removed from the tokens list
1790      */
1791     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1792         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1793         // then delete the last slot (swap and pop).
1794 
1795         uint256 lastTokenIndex = _allTokens.length - 1;
1796         uint256 tokenIndex = _allTokensIndex[tokenId];
1797 
1798         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1799         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1800         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1801         uint256 lastTokenId = _allTokens[lastTokenIndex];
1802 
1803         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1804         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1805 
1806         // This also deletes the contents at the last position of the array
1807         delete _allTokensIndex[tokenId];
1808         _allTokens.pop();
1809     }
1810 }
1811 
1812 
1813 /**
1814  * @title ERC721 Burnable Token
1815  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1816  */
1817 abstract contract ERC721Burnable is Context, ERC721 {
1818     /**
1819      * @dev Burns `tokenId`. See {ERC721-_burn}.
1820      *
1821      * Requirements:
1822      *
1823      * - The caller must own `tokenId` or be an approved operator.
1824      */
1825     function burn(uint256 tokenId) public virtual {
1826         //solhint-disable-next-line max-line-length
1827         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1828         _burn(tokenId);
1829     }
1830 }
1831 
1832 
1833 /**
1834  * @dev ERC721 token with storage based token URI management.
1835  */
1836 abstract contract ERC721URIStorage is ERC721 {
1837     using Strings for uint256;
1838 
1839     // Optional mapping for token URIs
1840     mapping(uint256 => string) private _tokenURIs;
1841 
1842     /**
1843      * @dev See {IERC721Metadata-tokenURI}.
1844      */
1845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1846         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1847 
1848         string memory _tokenURI = _tokenURIs[tokenId];
1849         string memory base = _baseURI();
1850 
1851         // If there is no base URI, return the token URI.
1852         if (bytes(base).length == 0) {
1853             return _tokenURI;
1854         }
1855         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1856         if (bytes(_tokenURI).length > 0) {
1857             return string(abi.encodePacked(base, _tokenURI));
1858         }
1859 
1860         return super.tokenURI(tokenId);
1861     }
1862 
1863     /**
1864      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1865      *
1866      * Requirements:
1867      *
1868      * - `tokenId` must exist.
1869      */
1870     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1871         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1872         _tokenURIs[tokenId] = _tokenURI;
1873     }
1874 
1875     /**
1876      * @dev Destroys `tokenId`.
1877      * The approval is cleared when the token is burned.
1878      *
1879      * Requirements:
1880      *
1881      * - `tokenId` must exist.
1882      *
1883      * Emits a {Transfer} event.
1884      */
1885     function _burn(uint256 tokenId) internal virtual override {
1886         super._burn(tokenId);
1887 
1888         if (bytes(_tokenURIs[tokenId]).length != 0) {
1889             delete _tokenURIs[tokenId];
1890         }
1891     }
1892 }
1893 
1894 
1895 
1896 interface IERC20 {
1897     function totalSupply() external view returns (uint256);
1898     function decimals() external view returns (uint8);
1899     function getOwner() external view returns (address);
1900     function balanceOf(address account) external view returns (uint256);
1901     function transfer(address recipient, uint256 amount) external returns (bool);
1902     function allowance(address _owner, address spender) external view returns (uint256);
1903     function approve(address spender, uint256 amount) external returns (bool);
1904     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1905     event Transfer(address indexed from, address indexed to, uint256 value);
1906     event Approval(address indexed owner, address indexed spender, uint256 value);
1907 }
1908 
1909 
1910 interface IDEXRouter {
1911     function factory() external pure returns (address);
1912     function WETH() external pure returns (address);
1913     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1914         uint amountOutMin,
1915         address[] calldata path,
1916         address to,
1917         uint deadline
1918     ) external payable;
1919 
1920     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1921         uint amountIn,
1922         uint amountOutMin,
1923         address[] calldata path,
1924         address to,
1925         uint deadline
1926     ) external;
1927 
1928     function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts);
1929 }
1930 
1931 
1932 interface IBITV {
1933 
1934    struct NftMetadataAttributes { 
1935                     uint nftIndex;
1936                     string imageURI;
1937                     uint256 mintPrice;
1938                     uint256 maxItemSupply;
1939                     uint256 counter;
1940                     uint256 royalties;
1941     } 
1942     
1943     function getNftAttributes(uint256 _id) external view returns (NftMetadataAttributes memory);
1944 
1945     function nftOwner(uint256 _id) external view returns (address);
1946 
1947     function referalWallet(address _contractAddress) external view returns(address);
1948     
1949     function _royaltyFees(address _contractAddress) external view returns(uint256);
1950 
1951     function tokenURI(uint256 tokenId) external view returns (string memory);
1952 
1953 }
1954 
1955 /**
1956  * @dev Midleware creator interface
1957  */
1958 interface IBTIVMidleware {
1959 
1960    function isAllowedETH20(address _tokenAddress) external view returns(bool);
1961 
1962    function isAllowedMarket(address _sender) external view returns(bool);
1963 
1964    function getETH20MinPrice(address _tokenAddress) external view returns(uint256);
1965 
1966    function getValleyPayoutAddress() external view returns(address);
1967 
1968    function _swapBackAndDistribute(address _contractAddress, uint256 payout_share) payable external;
1969    
1970 }
1971 
1972 
1973 
1974 contract Psyop is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
1975     
1976         using Counters for Counters.Counter;
1977         using Strings for uint256;
1978         using SafeMath for uint256;
1979     
1980         event Withdraw(address _owner, uint256 amount, uint256 timestamp);
1981         event NFTMinted(address sender, uint256 tokenId, uint256 nftIndex);
1982      
1983         Counters.Counter private _tokenIds;
1984 
1985         // Base
1986         string private    _baseURIextended;
1987         string private    _prevealURI = "https://ivory-key-pike-394.mypinata.cloud/ipfs/QmPzNYi8ZRbvgVW4n7VbvVmqc7LX4d8n8KTPUhvGR4VEfW";
1988         string private    _name;                                                          
1989         string private    _symbol; 
1990         uint256 private   _max_supply;
1991         uint256 public    _mint_price;
1992         bool public       _saleIsActive = false;
1993         bool public       _preveal = true;
1994 
1995 
1996         // mapping for token URIs
1997         mapping(uint256 => string) private _tokenURIs;
1998 
1999         // For tracking which extension a token was minted by
2000         mapping (uint256 => address) internal _tokensExtension;
2001 
2002         // mapping for whitelist MINT
2003         mapping(address => bool) public _isWhiteListed;
2004 
2005         // Middleware
2006         address private _provider;
2007 
2008 
2009         constructor(string memory base, address provider) ERC721("PP Jet Club", "PPJC")  {
2010             _name = "PP Jet Club";
2011             _symbol = "PPJC";
2012             _baseURIextended = base;
2013             _provider = provider;
2014             _max_supply = 6969;
2015             _tokenIds.increment();            
2016             transferOwnership(msg.sender);
2017         }
2018         
2019         modifier allowedMarketProvider() {
2020             require(IBTIVMidleware(_provider).isAllowedMarket(msg.sender) == true, "Callback: Not Allowed!");
2021             _;
2022         }
2023 
2024         function name() public view virtual override returns (string memory) {
2025             return _name;
2026         }
2027        
2028         function symbol() public view virtual override returns (string memory) {
2029             return _symbol;
2030         }
2031 
2032         function maxSupply() public view virtual returns (uint256) {
2033             return _max_supply;
2034         }
2035 
2036         /**
2037             * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2038             * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2039             * by default, can be overridden in child contracts.
2040         */
2041         function _baseURI() internal view virtual override returns (string memory) {
2042             return _baseURIextended;
2043         }
2044 
2045         /**
2046             * @dev Returns the uint256 amount of natvice currency as price.
2047         */
2048         function getMintPrice() public view returns(uint256) {
2049             return _mint_price;
2050         }
2051 
2052         /**
2053             * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2054         */
2055         function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
2056             require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2057             string memory baseURI = _baseURI();
2058             if(!_preveal) {return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json")) : "";} else { return _prevealURI;}
2059 
2060         }
2061 
2062         /**
2063             * @dev Returns {_saleIsActive} as boolean.
2064             * by default it is set too false.
2065         */
2066         function getSaleStatus() public view virtual returns(bool) {
2067             return _saleIsActive;
2068         }
2069 
2070 
2071         /**
2072             * @dev Sets `_flag` as the _saleIsActive of `collection`.
2073             *
2074             * Requirements:
2075             *
2076             * - `_flag` must exist.
2077         */
2078         function updateStauts(bool _flag) external onlyOwner {
2079             require(!_saleIsActive, "$Psyop: Cannot disable MINT!");
2080             _saleIsActive = _flag;
2081         }
2082 
2083         /**
2084             * @dev Sets `_flag` as the _preveal of `collection`.
2085             *
2086             * Requirements:
2087             *
2088             * - `_flag` must exist.
2089         */
2090         function updatePreveal(bool _flag) external onlyOwner {
2091             _preveal = _flag;
2092         }
2093 
2094 
2095         /**
2096             * @dev Sets default `price` as the mintPrice of `collection`.
2097             *
2098             * Requirements:
2099             *
2100             * - `price` must exist.
2101         */
2102         function changeMintPrice(uint256 price) external onlyOwner {
2103             _mint_price = price;
2104         }
2105 
2106 
2107         /**
2108             * @dev Sets default `provider` as the _provider of `collection`.
2109             * Providers are set permissions midlware protocols.
2110             * New provider should be changed at BITV protocol if v2 or v3 changes needed.
2111             * Requirements:
2112             *
2113             * - `provider` must exist.
2114         */
2115         function changeProvider(address provider) external onlyOwner {
2116              require(IBTIVMidleware(_provider).isAllowedMarket(provider) == true, "$Psyop: Not Allowed Provider!");
2117             _provider = provider;
2118         }
2119 
2120 
2121         /**
2122             * @dev Sets `baseURI_` as the _baseURIextended of `collection`.
2123             *
2124             * Requirements:
2125             *
2126             * - `tokenId` must exist.
2127         */
2128         function setBaseURI(string memory baseURI_) external onlyOwner() {
2129             _baseURIextended = baseURI_;
2130         }
2131 
2132 
2133         /**
2134             * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2135             *
2136             * Requirements:
2137             *
2138             * - `tokenId` must exist.
2139         */
2140         
2141         function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal override(ERC721URIStorage) virtual {
2142             require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
2143             _tokenURIs[tokenId] = _tokenURI;
2144         }
2145 
2146 
2147         /**
2148             * Mints a specified quantity of tokens for the specified owner address, after checking that the sale is active, the quantity is valid, 
2149                 and the total supply does not exceed the maximum supply. 
2150                 The required payment amount is calculated based on the mint price and quantity, and must be greater than or equal to the amount sent with the transaction. 
2151                 The function then distributes the payment among the specified wallets based on their percentages, 
2152                 generates unique token IDs using the getId function, mints the tokens, sets their URIs, and buys back a percentage of the payment using the buyBack function.
2153                 
2154             * @dev Safely mints `tokenId` and transfers it to `to`.
2155             *
2156             * Requirements:
2157             *
2158             * - `tokenId` must not exist.
2159             * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2160             *
2161             * Emits a {Transfer} event.
2162         */
2163 
2164         function mintFor(address owner, uint256[] memory ids) external allowedMarketProvider() {
2165             require(_saleIsActive == true, "MINT: Sale must be active to mint");            
2166             require(totalSupply() <= _max_supply, "MINT: would exceed max supply");
2167 
2168             uint256 newItemId = _tokenIds.current();
2169             require(newItemId <= _max_supply, "MINT: would exceed max supply");
2170             require(totalSupply().add(ids.length) <= _max_supply, "MINT: would exceed max supply");
2171         
2172 
2173             for(uint256 i = 0; i < ids.length; i++) {
2174                     _safeMint(owner, ids[i]);
2175                     _setTokenURI(ids[i], string(abi.encodePacked(_baseURI(), Strings.toString(ids[i]), ".json")));             
2176                     _tokenIds.increment();    
2177             }
2178         }
2179 
2180 
2181         
2182         /**
2183             * @dev Returns a token IDs owned by `owner` of its token list.
2184             * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2185         */
2186         function tokensOfOwner(address _owner)
2187             public
2188             view
2189             returns (uint256[] memory)
2190         {
2191             uint256 tokenCount = balanceOf(_owner);
2192             if (tokenCount == 0) {
2193                 return new uint256[](0);
2194             } else {
2195                 uint256[] memory result = new uint256[](tokenCount);
2196                 for (uint256 index; index < tokenCount; index++) {
2197                     result[index] = tokenOfOwnerByIndex(_owner, index);
2198                 }
2199                 return result;
2200             }
2201         }
2202 
2203         
2204         /**
2205             * @dev Hook that is called before any token transfer. This includes minting
2206             * and burning.
2207             *
2208             * Calling conditions:
2209             *
2210             * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2211             * transferred to `to`.
2212             * - When `from` is zero, `tokenId` will be minted for `to`.
2213             * - When `to` is zero, ``from``'s `tokenId` will be burned.
2214             * - `from` and `to` are never both zero.
2215             *
2216             * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2217         */
2218         function _beforeTokenTransfer(address from, address to, uint256 tokenId)
2219             internal
2220             override(ERC721, ERC721Enumerable) {
2221             super._beforeTokenTransfer(from, to, tokenId);
2222         }
2223 
2224 
2225         /**
2226             * @dev Destroys `tokenId`.
2227             * The approval is cleared when the token is burned.
2228             *
2229             * Requirements:
2230             *
2231             * - `tokenId` must exist.
2232             * - disable burns.
2233             * Emits a {Transfer} event.
2234         */
2235         function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) 
2236         {   
2237             super._burn(tokenId);
2238         }
2239 
2240          /**
2241             * @dev Returns true if this contract implements the interface defined by
2242             * `interfaceId`. See the corresponding
2243             * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2244             * to learn more about how these ids are created.
2245             *
2246             * This function call must use less than 30 000 gas.
2247         */
2248         function supportsInterface(bytes4 interfaceId)
2249             public
2250             view
2251             override(ERC721, ERC721Enumerable)
2252             returns (bool)
2253         {
2254             return super.supportsInterface(interfaceId);
2255         }
2256 
2257 
2258         function withdraw() payable external onlyOwner {
2259             uint256 balance = address(this).balance;
2260             payable(address(owner())).transfer(balance);
2261         }
2262 
2263         function withdrawErc20StuckBalance(address _caAddress) payable external onlyOwner {
2264             IERC20(_caAddress).transfer(owner(),  IERC20(_caAddress).balanceOf(address(this)));
2265         }
2266 
2267         receive () external payable {
2268         }
2269 }