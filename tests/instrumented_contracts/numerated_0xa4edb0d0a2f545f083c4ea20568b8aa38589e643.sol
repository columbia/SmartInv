1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/math/Math.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Standard math utilities missing in the Solidity language.
240  */
241 library Math {
242     enum Rounding {
243         Down, // Toward negative infinity
244         Up, // Toward infinity
245         Zero // Toward zero
246     }
247 
248     /**
249      * @dev Returns the largest of two numbers.
250      */
251     function max(uint256 a, uint256 b) internal pure returns (uint256) {
252         return a > b ? a : b;
253     }
254 
255     /**
256      * @dev Returns the smallest of two numbers.
257      */
258     function min(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a < b ? a : b;
260     }
261 
262     /**
263      * @dev Returns the average of two numbers. The result is rounded towards
264      * zero.
265      */
266     function average(uint256 a, uint256 b) internal pure returns (uint256) {
267         // (a + b) / 2 can overflow.
268         return (a & b) + (a ^ b) / 2;
269     }
270 
271     /**
272      * @dev Returns the ceiling of the division of two numbers.
273      *
274      * This differs from standard division with `/` in that it rounds up instead
275      * of rounding down.
276      */
277     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
278         // (a + b - 1) / b can overflow on addition, so we distribute.
279         return a == 0 ? 0 : (a - 1) / b + 1;
280     }
281 
282     /**
283      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
284      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
285      * with further edits by Uniswap Labs also under MIT license.
286      */
287     function mulDiv(
288         uint256 x,
289         uint256 y,
290         uint256 denominator
291     ) internal pure returns (uint256 result) {
292         unchecked {
293             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
294             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
295             // variables such that product = prod1 * 2^256 + prod0.
296             uint256 prod0; // Least significant 256 bits of the product
297             uint256 prod1; // Most significant 256 bits of the product
298             assembly {
299                 let mm := mulmod(x, y, not(0))
300                 prod0 := mul(x, y)
301                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
302             }
303 
304             // Handle non-overflow cases, 256 by 256 division.
305             if (prod1 == 0) {
306                 return prod0 / denominator;
307             }
308 
309             // Make sure the result is less than 2^256. Also prevents denominator == 0.
310             require(denominator > prod1);
311 
312             ///////////////////////////////////////////////
313             // 512 by 256 division.
314             ///////////////////////////////////////////////
315 
316             // Make division exact by subtracting the remainder from [prod1 prod0].
317             uint256 remainder;
318             assembly {
319                 // Compute remainder using mulmod.
320                 remainder := mulmod(x, y, denominator)
321 
322                 // Subtract 256 bit number from 512 bit number.
323                 prod1 := sub(prod1, gt(remainder, prod0))
324                 prod0 := sub(prod0, remainder)
325             }
326 
327             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
328             // See https://cs.stackexchange.com/q/138556/92363.
329 
330             // Does not overflow because the denominator cannot be zero at this stage in the function.
331             uint256 twos = denominator & (~denominator + 1);
332             assembly {
333                 // Divide denominator by twos.
334                 denominator := div(denominator, twos)
335 
336                 // Divide [prod1 prod0] by twos.
337                 prod0 := div(prod0, twos)
338 
339                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
340                 twos := add(div(sub(0, twos), twos), 1)
341             }
342 
343             // Shift in bits from prod1 into prod0.
344             prod0 |= prod1 * twos;
345 
346             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
347             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
348             // four bits. That is, denominator * inv = 1 mod 2^4.
349             uint256 inverse = (3 * denominator) ^ 2;
350 
351             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
352             // in modular arithmetic, doubling the correct bits in each step.
353             inverse *= 2 - denominator * inverse; // inverse mod 2^8
354             inverse *= 2 - denominator * inverse; // inverse mod 2^16
355             inverse *= 2 - denominator * inverse; // inverse mod 2^32
356             inverse *= 2 - denominator * inverse; // inverse mod 2^64
357             inverse *= 2 - denominator * inverse; // inverse mod 2^128
358             inverse *= 2 - denominator * inverse; // inverse mod 2^256
359 
360             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
361             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
362             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
363             // is no longer required.
364             result = prod0 * inverse;
365             return result;
366         }
367     }
368 
369     /**
370      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
371      */
372     function mulDiv(
373         uint256 x,
374         uint256 y,
375         uint256 denominator,
376         Rounding rounding
377     ) internal pure returns (uint256) {
378         uint256 result = mulDiv(x, y, denominator);
379         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
380             result += 1;
381         }
382         return result;
383     }
384 
385     /**
386      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
387      *
388      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
389      */
390     function sqrt(uint256 a) internal pure returns (uint256) {
391         if (a == 0) {
392             return 0;
393         }
394 
395         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
396         //
397         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
398         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
399         //
400         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
401         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
402         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
403         //
404         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
405         uint256 result = 1 << (log2(a) >> 1);
406 
407         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
408         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
409         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
410         // into the expected uint128 result.
411         unchecked {
412             result = (result + a / result) >> 1;
413             result = (result + a / result) >> 1;
414             result = (result + a / result) >> 1;
415             result = (result + a / result) >> 1;
416             result = (result + a / result) >> 1;
417             result = (result + a / result) >> 1;
418             result = (result + a / result) >> 1;
419             return min(result, a / result);
420         }
421     }
422 
423     /**
424      * @notice Calculates sqrt(a), following the selected rounding direction.
425      */
426     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
427         unchecked {
428             uint256 result = sqrt(a);
429             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
430         }
431     }
432 
433     /**
434      * @dev Return the log in base 2, rounded down, of a positive value.
435      * Returns 0 if given 0.
436      */
437     function log2(uint256 value) internal pure returns (uint256) {
438         uint256 result = 0;
439         unchecked {
440             if (value >> 128 > 0) {
441                 value >>= 128;
442                 result += 128;
443             }
444             if (value >> 64 > 0) {
445                 value >>= 64;
446                 result += 64;
447             }
448             if (value >> 32 > 0) {
449                 value >>= 32;
450                 result += 32;
451             }
452             if (value >> 16 > 0) {
453                 value >>= 16;
454                 result += 16;
455             }
456             if (value >> 8 > 0) {
457                 value >>= 8;
458                 result += 8;
459             }
460             if (value >> 4 > 0) {
461                 value >>= 4;
462                 result += 4;
463             }
464             if (value >> 2 > 0) {
465                 value >>= 2;
466                 result += 2;
467             }
468             if (value >> 1 > 0) {
469                 result += 1;
470             }
471         }
472         return result;
473     }
474 
475     /**
476      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
477      * Returns 0 if given 0.
478      */
479     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
480         unchecked {
481             uint256 result = log2(value);
482             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
483         }
484     }
485 
486     /**
487      * @dev Return the log in base 10, rounded down, of a positive value.
488      * Returns 0 if given 0.
489      */
490     function log10(uint256 value) internal pure returns (uint256) {
491         uint256 result = 0;
492         unchecked {
493             if (value >= 10**64) {
494                 value /= 10**64;
495                 result += 64;
496             }
497             if (value >= 10**32) {
498                 value /= 10**32;
499                 result += 32;
500             }
501             if (value >= 10**16) {
502                 value /= 10**16;
503                 result += 16;
504             }
505             if (value >= 10**8) {
506                 value /= 10**8;
507                 result += 8;
508             }
509             if (value >= 10**4) {
510                 value /= 10**4;
511                 result += 4;
512             }
513             if (value >= 10**2) {
514                 value /= 10**2;
515                 result += 2;
516             }
517             if (value >= 10**1) {
518                 result += 1;
519             }
520         }
521         return result;
522     }
523 
524     /**
525      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
526      * Returns 0 if given 0.
527      */
528     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
529         unchecked {
530             uint256 result = log10(value);
531             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
532         }
533     }
534 
535     /**
536      * @dev Return the log in base 256, rounded down, of a positive value.
537      * Returns 0 if given 0.
538      *
539      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
540      */
541     function log256(uint256 value) internal pure returns (uint256) {
542         uint256 result = 0;
543         unchecked {
544             if (value >> 128 > 0) {
545                 value >>= 128;
546                 result += 16;
547             }
548             if (value >> 64 > 0) {
549                 value >>= 64;
550                 result += 8;
551             }
552             if (value >> 32 > 0) {
553                 value >>= 32;
554                 result += 4;
555             }
556             if (value >> 16 > 0) {
557                 value >>= 16;
558                 result += 2;
559             }
560             if (value >> 8 > 0) {
561                 result += 1;
562             }
563         }
564         return result;
565     }
566 
567     /**
568      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
569      * Returns 0 if given 0.
570      */
571     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
572         unchecked {
573             uint256 result = log256(value);
574             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
575         }
576     }
577 }
578 
579 // File: @openzeppelin/contracts/utils/Strings.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @dev String operations.
589  */
590 library Strings {
591     bytes16 private constant _SYMBOLS = "0123456789abcdef";
592     uint8 private constant _ADDRESS_LENGTH = 20;
593 
594     /**
595      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
596      */
597     function toString(uint256 value) internal pure returns (string memory) {
598         unchecked {
599             uint256 length = Math.log10(value) + 1;
600             string memory buffer = new string(length);
601             uint256 ptr;
602             /// @solidity memory-safe-assembly
603             assembly {
604                 ptr := add(buffer, add(32, length))
605             }
606             while (true) {
607                 ptr--;
608                 /// @solidity memory-safe-assembly
609                 assembly {
610                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
611                 }
612                 value /= 10;
613                 if (value == 0) break;
614             }
615             return buffer;
616         }
617     }
618 
619     /**
620      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
621      */
622     function toHexString(uint256 value) internal pure returns (string memory) {
623         unchecked {
624             return toHexString(value, Math.log256(value) + 1);
625         }
626     }
627 
628     /**
629      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
630      */
631     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
632         bytes memory buffer = new bytes(2 * length + 2);
633         buffer[0] = "0";
634         buffer[1] = "x";
635         for (uint256 i = 2 * length + 1; i > 1; --i) {
636             buffer[i] = _SYMBOLS[value & 0xf];
637             value >>= 4;
638         }
639         require(value == 0, "Strings: hex length insufficient");
640         return string(buffer);
641     }
642 
643     /**
644      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
645      */
646     function toHexString(address addr) internal pure returns (string memory) {
647         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
648     }
649 }
650 
651 // File: @openzeppelin/contracts/utils/Context.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Provides information about the current execution context, including the
660  * sender of the transaction and its data. While these are generally available
661  * via msg.sender and msg.data, they should not be accessed in such a direct
662  * manner, since when dealing with meta-transactions the account sending and
663  * paying for execution may not be the actual sender (as far as an application
664  * is concerned).
665  *
666  * This contract is only required for intermediate, library-like contracts.
667  */
668 abstract contract Context {
669     function _msgSender() internal view virtual returns (address) {
670         return msg.sender;
671     }
672 
673     function _msgData() internal view virtual returns (bytes calldata) {
674         return msg.data;
675     }
676 }
677 
678 // File: @openzeppelin/contracts/access/Ownable.sol
679 
680 
681 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @dev Contract module which provides a basic access control mechanism, where
688  * there is an account (an owner) that can be granted exclusive access to
689  * specific functions.
690  *
691  * By default, the owner account will be the one that deploys the contract. This
692  * can later be changed with {transferOwnership}.
693  *
694  * This module is used through inheritance. It will make available the modifier
695  * `onlyOwner`, which can be applied to your functions to restrict their use to
696  * the owner.
697  */
698 abstract contract Ownable is Context {
699     address private _owner;
700 
701     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
702 
703     /**
704      * @dev Initializes the contract setting the deployer as the initial owner.
705      */
706     constructor() {
707         _transferOwnership(_msgSender());
708     }
709 
710     /**
711      * @dev Throws if called by any account other than the owner.
712      */
713     modifier onlyOwner() {
714         _checkOwner();
715         _;
716     }
717 
718     /**
719      * @dev Returns the address of the current owner.
720      */
721     function owner() public view virtual returns (address) {
722         return _owner;
723     }
724 
725     /**
726      * @dev Throws if the sender is not the owner.
727      */
728     function _checkOwner() internal view virtual {
729         require(owner() == _msgSender(), "Ownable: caller is not the owner");
730     }
731 
732     /**
733      * @dev Leaves the contract without owner. It will not be possible to call
734      * `onlyOwner` functions anymore. Can only be called by the current owner.
735      *
736      * NOTE: Renouncing ownership will leave the contract without an owner,
737      * thereby removing any functionality that is only available to the owner.
738      */
739     function renounceOwnership() public virtual onlyOwner {
740         _transferOwnership(address(0));
741     }
742 
743     /**
744      * @dev Transfers ownership of the contract to a new account (`newOwner`).
745      * Can only be called by the current owner.
746      */
747     function transferOwnership(address newOwner) public virtual onlyOwner {
748         require(newOwner != address(0), "Ownable: new owner is the zero address");
749         _transferOwnership(newOwner);
750     }
751 
752     /**
753      * @dev Transfers ownership of the contract to a new account (`newOwner`).
754      * Internal function without access restriction.
755      */
756     function _transferOwnership(address newOwner) internal virtual {
757         address oldOwner = _owner;
758         _owner = newOwner;
759         emit OwnershipTransferred(oldOwner, newOwner);
760     }
761 }
762 
763 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
764 
765 
766 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 /**
771  * @title ERC721 token receiver interface
772  * @dev Interface for any contract that wants to support safeTransfers
773  * from ERC721 asset contracts.
774  */
775 interface IERC721Receiver {
776     /**
777      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
778      * by `operator` from `from`, this function is called.
779      *
780      * It must return its Solidity selector to confirm the token transfer.
781      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
782      *
783      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
784      */
785     function onERC721Received(
786         address operator,
787         address from,
788         uint256 tokenId,
789         bytes calldata data
790     ) external returns (bytes4);
791 }
792 
793 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
794 
795 
796 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
797 
798 pragma solidity ^0.8.0;
799 
800 /**
801  * @dev Interface of the ERC165 standard, as defined in the
802  * https://eips.ethereum.org/EIPS/eip-165[EIP].
803  *
804  * Implementers can declare support of contract interfaces, which can then be
805  * queried by others ({ERC165Checker}).
806  *
807  * For an implementation, see {ERC165}.
808  */
809 interface IERC165 {
810     /**
811      * @dev Returns true if this contract implements the interface defined by
812      * `interfaceId`. See the corresponding
813      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
814      * to learn more about how these ids are created.
815      *
816      * This function call must use less than 30 000 gas.
817      */
818     function supportsInterface(bytes4 interfaceId) external view returns (bool);
819 }
820 
821 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
822 
823 
824 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
825 
826 pragma solidity ^0.8.0;
827 
828 
829 /**
830  * @dev Implementation of the {IERC165} interface.
831  *
832  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
833  * for the additional interface id that will be supported. For example:
834  *
835  * ```solidity
836  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
837  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
838  * }
839  * ```
840  *
841  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
842  */
843 abstract contract ERC165 is IERC165 {
844     /**
845      * @dev See {IERC165-supportsInterface}.
846      */
847     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
848         return interfaceId == type(IERC165).interfaceId;
849     }
850 }
851 
852 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
853 
854 
855 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
856 
857 pragma solidity ^0.8.0;
858 
859 
860 /**
861  * @dev Required interface of an ERC721 compliant contract.
862  */
863 interface IERC721 is IERC165 {
864     /**
865      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
866      */
867     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
868 
869     /**
870      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
871      */
872     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
873 
874     /**
875      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
876      */
877     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
878 
879     /**
880      * @dev Returns the number of tokens in ``owner``'s account.
881      */
882     function balanceOf(address owner) external view returns (uint256 balance);
883 
884     /**
885      * @dev Returns the owner of the `tokenId` token.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      */
891     function ownerOf(uint256 tokenId) external view returns (address owner);
892 
893     /**
894      * @dev Safely transfers `tokenId` token from `from` to `to`.
895      *
896      * Requirements:
897      *
898      * - `from` cannot be the zero address.
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must exist and be owned by `from`.
901      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
902      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
903      *
904      * Emits a {Transfer} event.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes calldata data
911     ) external;
912 
913     /**
914      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
915      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
916      *
917      * Requirements:
918      *
919      * - `from` cannot be the zero address.
920      * - `to` cannot be the zero address.
921      * - `tokenId` token must exist and be owned by `from`.
922      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) external;
932 
933     /**
934      * @dev Transfers `tokenId` token from `from` to `to`.
935      *
936      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
937      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
938      * understand this adds an external call which potentially creates a reentrancy vulnerability.
939      *
940      * Requirements:
941      *
942      * - `from` cannot be the zero address.
943      * - `to` cannot be the zero address.
944      * - `tokenId` token must be owned by `from`.
945      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
946      *
947      * Emits a {Transfer} event.
948      */
949     function transferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) external;
954 
955     /**
956      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
957      * The approval is cleared when the token is transferred.
958      *
959      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
960      *
961      * Requirements:
962      *
963      * - The caller must own the token or be an approved operator.
964      * - `tokenId` must exist.
965      *
966      * Emits an {Approval} event.
967      */
968     function approve(address to, uint256 tokenId) external;
969 
970     /**
971      * @dev Approve or remove `operator` as an operator for the caller.
972      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
973      *
974      * Requirements:
975      *
976      * - The `operator` cannot be the caller.
977      *
978      * Emits an {ApprovalForAll} event.
979      */
980     function setApprovalForAll(address operator, bool _approved) external;
981 
982     /**
983      * @dev Returns the account approved for `tokenId` token.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      */
989     function getApproved(uint256 tokenId) external view returns (address operator);
990 
991     /**
992      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
993      *
994      * See {setApprovalForAll}
995      */
996     function isApprovedForAll(address owner, address operator) external view returns (bool);
997 }
998 
999 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1000 
1001 
1002 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1003 
1004 pragma solidity ^0.8.0;
1005 
1006 
1007 /**
1008  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1009  * @dev See https://eips.ethereum.org/EIPS/eip-721
1010  */
1011 interface IERC721Metadata is IERC721 {
1012     /**
1013      * @dev Returns the token collection name.
1014      */
1015     function name() external view returns (string memory);
1016 
1017     /**
1018      * @dev Returns the token collection symbol.
1019      */
1020     function symbol() external view returns (string memory);
1021 
1022     /**
1023      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1024      */
1025     function tokenURI(uint256 tokenId) external view returns (string memory);
1026 }
1027 
1028 // File: @openzeppelin/contracts/utils/Counters.sol
1029 
1030 
1031 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1032 
1033 pragma solidity ^0.8.0;
1034 
1035 /**
1036  * @title Counters
1037  * @author Matt Condon (@shrugs)
1038  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1039  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1040  *
1041  * Include with `using Counters for Counters.Counter;`
1042  */
1043 library Counters {
1044     struct Counter {
1045         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1046         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1047         // this feature: see https://github.com/ethereum/solidity/issues/4637
1048         uint256 _value; // default: 0
1049     }
1050 
1051     function current(Counter storage counter) internal view returns (uint256) {
1052         return counter._value;
1053     }
1054 
1055     function increment(Counter storage counter) internal {
1056         unchecked {
1057             counter._value += 1;
1058         }
1059     }
1060 
1061     function decrement(Counter storage counter) internal {
1062         uint256 value = counter._value;
1063         require(value > 0, "Counter: decrement overflow");
1064         unchecked {
1065             counter._value = value - 1;
1066         }
1067     }
1068 
1069     function reset(Counter storage counter) internal {
1070         counter._value = 0;
1071     }
1072 }
1073 
1074 // File: @openzeppelin/contracts/utils/Address.sol
1075 
1076 
1077 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1078 
1079 pragma solidity ^0.8.1;
1080 
1081 /**
1082  * @dev Collection of functions related to the address type
1083  */
1084 library Address {
1085     /**
1086      * @dev Returns true if `account` is a contract.
1087      *
1088      * [IMPORTANT]
1089      * ====
1090      * It is unsafe to assume that an address for which this function returns
1091      * false is an externally-owned account (EOA) and not a contract.
1092      *
1093      * Among others, `isContract` will return false for the following
1094      * types of addresses:
1095      *
1096      *  - an externally-owned account
1097      *  - a contract in construction
1098      *  - an address where a contract will be created
1099      *  - an address where a contract lived, but was destroyed
1100      * ====
1101      *
1102      * [IMPORTANT]
1103      * ====
1104      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1105      *
1106      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1107      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1108      * constructor.
1109      * ====
1110      */
1111     function isContract(address account) internal view returns (bool) {
1112         // This method relies on extcodesize/address.code.length, which returns 0
1113         // for contracts in construction, since the code is only stored at the end
1114         // of the constructor execution.
1115 
1116         return account.code.length > 0;
1117     }
1118 
1119     /**
1120      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1121      * `recipient`, forwarding all available gas and reverting on errors.
1122      *
1123      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1124      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1125      * imposed by `transfer`, making them unable to receive funds via
1126      * `transfer`. {sendValue} removes this limitation.
1127      *
1128      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1129      *
1130      * IMPORTANT: because control is transferred to `recipient`, care must be
1131      * taken to not create reentrancy vulnerabilities. Consider using
1132      * {ReentrancyGuard} or the
1133      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1134      */
1135     function sendValue(address payable recipient, uint256 amount) internal {
1136         require(address(this).balance >= amount, "Address: insufficient balance");
1137 
1138         (bool success, ) = recipient.call{value: amount}("");
1139         require(success, "Address: unable to send value, recipient may have reverted");
1140     }
1141 
1142     /**
1143      * @dev Performs a Solidity function call using a low level `call`. A
1144      * plain `call` is an unsafe replacement for a function call: use this
1145      * function instead.
1146      *
1147      * If `target` reverts with a revert reason, it is bubbled up by this
1148      * function (like regular Solidity function calls).
1149      *
1150      * Returns the raw returned data. To convert to the expected return value,
1151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1152      *
1153      * Requirements:
1154      *
1155      * - `target` must be a contract.
1156      * - calling `target` with `data` must not revert.
1157      *
1158      * _Available since v3.1._
1159      */
1160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1161         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1162     }
1163 
1164     /**
1165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1166      * `errorMessage` as a fallback revert reason when `target` reverts.
1167      *
1168      * _Available since v3.1._
1169      */
1170     function functionCall(
1171         address target,
1172         bytes memory data,
1173         string memory errorMessage
1174     ) internal returns (bytes memory) {
1175         return functionCallWithValue(target, data, 0, errorMessage);
1176     }
1177 
1178     /**
1179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1180      * but also transferring `value` wei to `target`.
1181      *
1182      * Requirements:
1183      *
1184      * - the calling contract must have an ETH balance of at least `value`.
1185      * - the called Solidity function must be `payable`.
1186      *
1187      * _Available since v3.1._
1188      */
1189     function functionCallWithValue(
1190         address target,
1191         bytes memory data,
1192         uint256 value
1193     ) internal returns (bytes memory) {
1194         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1195     }
1196 
1197     /**
1198      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1199      * with `errorMessage` as a fallback revert reason when `target` reverts.
1200      *
1201      * _Available since v3.1._
1202      */
1203     function functionCallWithValue(
1204         address target,
1205         bytes memory data,
1206         uint256 value,
1207         string memory errorMessage
1208     ) internal returns (bytes memory) {
1209         require(address(this).balance >= value, "Address: insufficient balance for call");
1210         (bool success, bytes memory returndata) = target.call{value: value}(data);
1211         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1212     }
1213 
1214     /**
1215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1216      * but performing a static call.
1217      *
1218      * _Available since v3.3._
1219      */
1220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1221         return functionStaticCall(target, data, "Address: low-level static call failed");
1222     }
1223 
1224     /**
1225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1226      * but performing a static call.
1227      *
1228      * _Available since v3.3._
1229      */
1230     function functionStaticCall(
1231         address target,
1232         bytes memory data,
1233         string memory errorMessage
1234     ) internal view returns (bytes memory) {
1235         (bool success, bytes memory returndata) = target.staticcall(data);
1236         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1237     }
1238 
1239     /**
1240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1241      * but performing a delegate call.
1242      *
1243      * _Available since v3.4._
1244      */
1245     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1246         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1247     }
1248 
1249     /**
1250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1251      * but performing a delegate call.
1252      *
1253      * _Available since v3.4._
1254      */
1255     function functionDelegateCall(
1256         address target,
1257         bytes memory data,
1258         string memory errorMessage
1259     ) internal returns (bytes memory) {
1260         (bool success, bytes memory returndata) = target.delegatecall(data);
1261         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1262     }
1263 
1264     /**
1265      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1266      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1267      *
1268      * _Available since v4.8._
1269      */
1270     function verifyCallResultFromTarget(
1271         address target,
1272         bool success,
1273         bytes memory returndata,
1274         string memory errorMessage
1275     ) internal view returns (bytes memory) {
1276         if (success) {
1277             if (returndata.length == 0) {
1278                 // only check isContract if the call was successful and the return data is empty
1279                 // otherwise we already know that it was a contract
1280                 require(isContract(target), "Address: call to non-contract");
1281             }
1282             return returndata;
1283         } else {
1284             _revert(returndata, errorMessage);
1285         }
1286     }
1287 
1288     /**
1289      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1290      * revert reason or using the provided one.
1291      *
1292      * _Available since v4.3._
1293      */
1294     function verifyCallResult(
1295         bool success,
1296         bytes memory returndata,
1297         string memory errorMessage
1298     ) internal pure returns (bytes memory) {
1299         if (success) {
1300             return returndata;
1301         } else {
1302             _revert(returndata, errorMessage);
1303         }
1304     }
1305 
1306     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1307         // Look for revert reason and bubble it up if present
1308         if (returndata.length > 0) {
1309             // The easiest way to bubble the revert reason is using memory via assembly
1310             /// @solidity memory-safe-assembly
1311             assembly {
1312                 let returndata_size := mload(returndata)
1313                 revert(add(32, returndata), returndata_size)
1314             }
1315         } else {
1316             revert(errorMessage);
1317         }
1318     }
1319 }
1320 
1321 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1322 
1323 
1324 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1325 
1326 pragma solidity ^0.8.0;
1327 
1328 
1329 
1330 
1331 
1332 
1333 
1334 
1335 /**
1336  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1337  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1338  * {ERC721Enumerable}.
1339  */
1340 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1341     using Address for address;
1342     using Strings for uint256;
1343 
1344     // Token name
1345     string private _name;
1346 
1347     // Token symbol
1348     string private _symbol;
1349 
1350     // Mapping from token ID to owner address
1351     mapping(uint256 => address) private _owners;
1352 
1353     // Mapping owner address to token count
1354     mapping(address => uint256) private _balances;
1355 
1356     // Mapping from token ID to approved address
1357     mapping(uint256 => address) private _tokenApprovals;
1358 
1359     // Mapping from owner to operator approvals
1360     mapping(address => mapping(address => bool)) private _operatorApprovals;
1361 
1362     /**
1363      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1364      */
1365     constructor(string memory name_, string memory symbol_) {
1366         _name = name_;
1367         _symbol = symbol_;
1368     }
1369 
1370     /**
1371      * @dev See {IERC165-supportsInterface}.
1372      */
1373     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1374         return
1375             interfaceId == type(IERC721).interfaceId ||
1376             interfaceId == type(IERC721Metadata).interfaceId ||
1377             super.supportsInterface(interfaceId);
1378     }
1379 
1380     /**
1381      * @dev See {IERC721-balanceOf}.
1382      */
1383     function balanceOf(address owner) public view virtual override returns (uint256) {
1384         require(owner != address(0), "ERC721: address zero is not a valid owner");
1385         return _balances[owner];
1386     }
1387 
1388     /**
1389      * @dev See {IERC721-ownerOf}.
1390      */
1391     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1392         address owner = _ownerOf(tokenId);
1393         require(owner != address(0), "ERC721: invalid token ID");
1394         return owner;
1395     }
1396 
1397     /**
1398      * @dev See {IERC721Metadata-name}.
1399      */
1400     function name() public view virtual override returns (string memory) {
1401         return _name;
1402     }
1403 
1404     /**
1405      * @dev See {IERC721Metadata-symbol}.
1406      */
1407     function symbol() public view virtual override returns (string memory) {
1408         return _symbol;
1409     }
1410 
1411     /**
1412      * @dev See {IERC721Metadata-tokenURI}.
1413      */
1414     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1415         _requireMinted(tokenId);
1416 
1417         string memory baseURI = _baseURI();
1418         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1419     }
1420 
1421     /**
1422      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1423      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1424      * by default, can be overridden in child contracts.
1425      */
1426     function _baseURI() internal view virtual returns (string memory) {
1427         return "";
1428     }
1429 
1430     /**
1431      * @dev See {IERC721-approve}.
1432      */
1433     function approve(address to, uint256 tokenId) public virtual override {
1434         address owner = ERC721.ownerOf(tokenId);
1435         require(to != owner, "ERC721: approval to current owner");
1436 
1437         require(
1438             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1439             "ERC721: approve caller is not token owner or approved for all"
1440         );
1441 
1442         _approve(to, tokenId);
1443     }
1444 
1445     /**
1446      * @dev See {IERC721-getApproved}.
1447      */
1448     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1449         _requireMinted(tokenId);
1450 
1451         return _tokenApprovals[tokenId];
1452     }
1453 
1454     /**
1455      * @dev See {IERC721-setApprovalForAll}.
1456      */
1457     function setApprovalForAll(address operator, bool approved) public virtual override {
1458         _setApprovalForAll(_msgSender(), operator, approved);
1459     }
1460 
1461     /**
1462      * @dev See {IERC721-isApprovedForAll}.
1463      */
1464     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1465         return _operatorApprovals[owner][operator];
1466     }
1467 
1468     /**
1469      * @dev See {IERC721-transferFrom}.
1470      */
1471     function transferFrom(
1472         address from,
1473         address to,
1474         uint256 tokenId
1475     ) public virtual override {
1476         //solhint-disable-next-line max-line-length
1477         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1478 
1479         _transfer(from, to, tokenId);
1480     }
1481 
1482     /**
1483      * @dev See {IERC721-safeTransferFrom}.
1484      */
1485     function safeTransferFrom(
1486         address from,
1487         address to,
1488         uint256 tokenId
1489     ) public virtual override {
1490         safeTransferFrom(from, to, tokenId, "");
1491     }
1492 
1493     /**
1494      * @dev See {IERC721-safeTransferFrom}.
1495      */
1496     function safeTransferFrom(
1497         address from,
1498         address to,
1499         uint256 tokenId,
1500         bytes memory data
1501     ) public virtual override {
1502         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1503         _safeTransfer(from, to, tokenId, data);
1504     }
1505 
1506     /**
1507      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1508      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1509      *
1510      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1511      *
1512      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1513      * implement alternative mechanisms to perform token transfer, such as signature-based.
1514      *
1515      * Requirements:
1516      *
1517      * - `from` cannot be the zero address.
1518      * - `to` cannot be the zero address.
1519      * - `tokenId` token must exist and be owned by `from`.
1520      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1521      *
1522      * Emits a {Transfer} event.
1523      */
1524     function _safeTransfer(
1525         address from,
1526         address to,
1527         uint256 tokenId,
1528         bytes memory data
1529     ) internal virtual {
1530         _transfer(from, to, tokenId);
1531         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1532     }
1533 
1534     /**
1535      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1536      */
1537     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1538         return _owners[tokenId];
1539     }
1540 
1541     /**
1542      * @dev Returns whether `tokenId` exists.
1543      *
1544      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1545      *
1546      * Tokens start existing when they are minted (`_mint`),
1547      * and stop existing when they are burned (`_burn`).
1548      */
1549     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1550         return _ownerOf(tokenId) != address(0);
1551     }
1552 
1553     /**
1554      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1555      *
1556      * Requirements:
1557      *
1558      * - `tokenId` must exist.
1559      */
1560     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1561         address owner = ERC721.ownerOf(tokenId);
1562         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1563     }
1564 
1565     /**
1566      * @dev Safely mints `tokenId` and transfers it to `to`.
1567      *
1568      * Requirements:
1569      *
1570      * - `tokenId` must not exist.
1571      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1572      *
1573      * Emits a {Transfer} event.
1574      */
1575     function _safeMint(address to, uint256 tokenId) internal virtual {
1576         _safeMint(to, tokenId, "");
1577     }
1578 
1579     /**
1580      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1581      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1582      */
1583     function _safeMint(
1584         address to,
1585         uint256 tokenId,
1586         bytes memory data
1587     ) internal virtual {
1588         _mint(to, tokenId);
1589         require(
1590             _checkOnERC721Received(address(0), to, tokenId, data),
1591             "ERC721: transfer to non ERC721Receiver implementer"
1592         );
1593     }
1594 
1595     /**
1596      * @dev Mints `tokenId` and transfers it to `to`.
1597      *
1598      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1599      *
1600      * Requirements:
1601      *
1602      * - `tokenId` must not exist.
1603      * - `to` cannot be the zero address.
1604      *
1605      * Emits a {Transfer} event.
1606      */
1607     function _mint(address to, uint256 tokenId) internal virtual {
1608         require(to != address(0), "ERC721: mint to the zero address");
1609         require(!_exists(tokenId), "ERC721: token already minted");
1610 
1611         _beforeTokenTransfer(address(0), to, tokenId, 1);
1612 
1613         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1614         require(!_exists(tokenId), "ERC721: token already minted");
1615 
1616         unchecked {
1617             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1618             // Given that tokens are minted one by one, it is impossible in practice that
1619             // this ever happens. Might change if we allow batch minting.
1620             // The ERC fails to describe this case.
1621             _balances[to] += 1;
1622         }
1623 
1624         _owners[tokenId] = to;
1625 
1626         emit Transfer(address(0), to, tokenId);
1627 
1628         _afterTokenTransfer(address(0), to, tokenId, 1);
1629     }
1630 
1631     /**
1632      * @dev Destroys `tokenId`.
1633      * The approval is cleared when the token is burned.
1634      * This is an internal function that does not check if the sender is authorized to operate on the token.
1635      *
1636      * Requirements:
1637      *
1638      * - `tokenId` must exist.
1639      *
1640      * Emits a {Transfer} event.
1641      */
1642     function _burn(uint256 tokenId) internal virtual {
1643         address owner = ERC721.ownerOf(tokenId);
1644 
1645         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1646 
1647         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1648         owner = ERC721.ownerOf(tokenId);
1649 
1650         // Clear approvals
1651         delete _tokenApprovals[tokenId];
1652 
1653         unchecked {
1654             // Cannot overflow, as that would require more tokens to be burned/transferred
1655             // out than the owner initially received through minting and transferring in.
1656             _balances[owner] -= 1;
1657         }
1658         delete _owners[tokenId];
1659 
1660         emit Transfer(owner, address(0), tokenId);
1661 
1662         _afterTokenTransfer(owner, address(0), tokenId, 1);
1663     }
1664 
1665     /**
1666      * @dev Transfers `tokenId` from `from` to `to`.
1667      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1668      *
1669      * Requirements:
1670      *
1671      * - `to` cannot be the zero address.
1672      * - `tokenId` token must be owned by `from`.
1673      *
1674      * Emits a {Transfer} event.
1675      */
1676     function _transfer(
1677         address from,
1678         address to,
1679         uint256 tokenId
1680     ) internal virtual {
1681         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1682         require(to != address(0), "ERC721: transfer to the zero address");
1683 
1684         _beforeTokenTransfer(from, to, tokenId, 1);
1685 
1686         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1687         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1688 
1689         // Clear approvals from the previous owner
1690         delete _tokenApprovals[tokenId];
1691 
1692         unchecked {
1693             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1694             // `from`'s balance is the number of token held, which is at least one before the current
1695             // transfer.
1696             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1697             // all 2**256 token ids to be minted, which in practice is impossible.
1698             _balances[from] -= 1;
1699             _balances[to] += 1;
1700         }
1701         _owners[tokenId] = to;
1702 
1703         emit Transfer(from, to, tokenId);
1704 
1705         _afterTokenTransfer(from, to, tokenId, 1);
1706     }
1707 
1708     /**
1709      * @dev Approve `to` to operate on `tokenId`
1710      *
1711      * Emits an {Approval} event.
1712      */
1713     function _approve(address to, uint256 tokenId) internal virtual {
1714         _tokenApprovals[tokenId] = to;
1715         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1716     }
1717 
1718     /**
1719      * @dev Approve `operator` to operate on all of `owner` tokens
1720      *
1721      * Emits an {ApprovalForAll} event.
1722      */
1723     function _setApprovalForAll(
1724         address owner,
1725         address operator,
1726         bool approved
1727     ) internal virtual {
1728         require(owner != operator, "ERC721: approve to caller");
1729         _operatorApprovals[owner][operator] = approved;
1730         emit ApprovalForAll(owner, operator, approved);
1731     }
1732 
1733     /**
1734      * @dev Reverts if the `tokenId` has not been minted yet.
1735      */
1736     function _requireMinted(uint256 tokenId) internal view virtual {
1737         require(_exists(tokenId), "ERC721: invalid token ID");
1738     }
1739 
1740     /**
1741      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1742      * The call is not executed if the target address is not a contract.
1743      *
1744      * @param from address representing the previous owner of the given token ID
1745      * @param to target address that will receive the tokens
1746      * @param tokenId uint256 ID of the token to be transferred
1747      * @param data bytes optional data to send along with the call
1748      * @return bool whether the call correctly returned the expected magic value
1749      */
1750     function _checkOnERC721Received(
1751         address from,
1752         address to,
1753         uint256 tokenId,
1754         bytes memory data
1755     ) private returns (bool) {
1756         if (to.isContract()) {
1757             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1758                 return retval == IERC721Receiver.onERC721Received.selector;
1759             } catch (bytes memory reason) {
1760                 if (reason.length == 0) {
1761                     revert("ERC721: transfer to non ERC721Receiver implementer");
1762                 } else {
1763                     /// @solidity memory-safe-assembly
1764                     assembly {
1765                         revert(add(32, reason), mload(reason))
1766                     }
1767                 }
1768             }
1769         } else {
1770             return true;
1771         }
1772     }
1773 
1774     /**
1775      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1776      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1777      *
1778      * Calling conditions:
1779      *
1780      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1781      * - When `from` is zero, the tokens will be minted for `to`.
1782      * - When `to` is zero, ``from``'s tokens will be burned.
1783      * - `from` and `to` are never both zero.
1784      * - `batchSize` is non-zero.
1785      *
1786      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1787      */
1788     function _beforeTokenTransfer(
1789         address from,
1790         address to,
1791         uint256, /* firstTokenId */
1792         uint256 batchSize
1793     ) internal virtual {
1794         if (batchSize > 1) {
1795             if (from != address(0)) {
1796                 _balances[from] -= batchSize;
1797             }
1798             if (to != address(0)) {
1799                 _balances[to] += batchSize;
1800             }
1801         }
1802     }
1803 
1804     /**
1805      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1806      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1807      *
1808      * Calling conditions:
1809      *
1810      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1811      * - When `from` is zero, the tokens were minted for `to`.
1812      * - When `to` is zero, ``from``'s tokens were burned.
1813      * - `from` and `to` are never both zero.
1814      * - `batchSize` is non-zero.
1815      *
1816      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1817      */
1818     function _afterTokenTransfer(
1819         address from,
1820         address to,
1821         uint256 firstTokenId,
1822         uint256 batchSize
1823     ) internal virtual {}
1824 }
1825 
1826 // File: contracts/Ticketz.sol
1827 
1828 /*MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1829 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1830 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1831 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1832 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1833 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1834 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1835 MMMMMMMMMMMMMMMMMMMMMMMMMWXOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOKWMMMMMMMMMMMMMMMMMMMMMMMM
1836 MMMMMMMMMMMMMMMMMMMMMMMMMNl.                                                                                                                                                  ,0MMMMMMMMMMMMMMMMMMMMMMMM
1837 MMMMMMMMMMMMMMMMMMMMMMWXK0o'..................................................................................................................................................:kKKNMMMMMMMMMMMMMMMMMMMMM
1838 MMMMMMMMMMMMMMMMMMMMMWx'.,d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000k:..lNMMMMMMMMMMMMMMMMMMMM
1839 MMMMMMMMMMMMMMMMMMMWWNd..'xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0:..cKWWWMMMMMMMMMMMMMMMMM
1840 MMMMMMMMMMMMMMMMMMKl,:okkOKXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0kkd:,;kWMMMMMMMMMMMMMMMM
1841 MMMMMMMMMMMMMMMMMMO. .lKXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXNXXXXXXXXXXXXx.  oWMMMMMMMMMMMMMMMM
1842 MMMMMMMMMMMMMMMMMMO.  lKXXXXXXXXXXXXXx;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,l0NXXXXXXXXXXXXx.  oWMMMMMMMMMMMMMMMM
1843 MMMMMMMMMMMMMMMMMMO.  lKXXXXXXXXXXXXKc                                                                                                                             ,OXXXXXXXXXXXXXx.  oWMMMMMMMMMMMMMMMM
1844 MMMMMMMMMMMMMMMMMMO.  lKNXXXXXXXXOlccc::::::::::,   .;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.   .:::::::::::cccxKNXXXXXXXXx.  oWMMMMMMMMMMMMMMMM
1845 MMMMMMMMMMMMMMMMMMO.  lKXXXXXXXXXo.  :0KKKKKKKKKd.  ,kKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0c   c0KKKKKKKKKo.  :0NXXXXXXXXx.  oWMMMMMMMMMMMMMMMM
1846 MMMMMMMMMMMMMMMMMMO.  lKXXXXX0xdoc;,;o0XKKKKKKKKd.  ,kKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0c   c0XXKKKKKXKx:,,:oddOXXXXXXx.  oWMMMMMMMMMMMMMMMM
1847 MMMMMMMMMMMMMMMMMMO.  lKXXXNXx'  ,kKKKKKKKKKKKXKd.  ,kKKKKKKKKKKKKKKKKK0dc:::::::ccxKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0d::;;;;;;:cxKKKKKKKKKKKKKKKKK0c   c0XKKKXKKKKKKK0c. .lKNXXXXx.  oWMMMMMMMMMMMMMMMM
1848 MMMMMMMMMMMMMMMMMMO. .lKXXXXXx.  ,OXXXKXKKKKKKXKd.  ,kKKKKKKKKKKKKKKKKKk,          :0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0:          c0KKKKKKKKKKKKKKKK0c.  c0XXKXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1849 MMMMMMMMMMMMMMMMMMO' .lKXXXXXx.  ,kXKKKKKKKKKKXKd.  ,kKKKKKKKKKKKKKKKKKk,          :0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0:          :0KKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1850 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKKXKd.  ,kKKKKKKKKKKKKKKKKKk,          :0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0:          :0KKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1851 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKKKKKKKKXKd.  ,kKKKKKKKKKKKKKKKKKk,          :0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0:          :0KKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1852 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKKXKd.  ,kKKKKKKKKKKKKKKKKKk,          c0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKO:          :0KKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1853 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKK0dlllllcllllx0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0xlllllllllok0KKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1854 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1855 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1856 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0Okkkkkkkkkkkkkkkkkkkk0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1857 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKx,....................l0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1858 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKd.                    c0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1859 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKK0kxxxxxkOKKKKKKd.                    c0KKKKOkkkkkkO0KKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1860 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKx,......l0KKKKKd.                    c0KKK0c......;kKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1861 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKx.      c0KKKKKd.                    c0KKK0:      'kKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1862 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKx.      c0KKKKKx,.....        ......'o0KKK0:      'kKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1863 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKx.      c0KKKKKK0OOOOk;       :O0O0O00KKKK0:      'kKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKXXXXXx.  oWMMMMMMMMMMMMMMMM
1864 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKx.      c0KKKKKKKKKKK0:       c0KKKKKKKKKK0:      'kKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKNXXXXx.  oWMMMMMMMMMMMMMMMM
1865 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKx'     .cO00000000000k;       :O0000000000k:      ,kKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKNXXXXx.  oWMMMMMMMMMMMMMMMM
1866 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKK0xoooool;''''''''''''..       ............':oooooox0KKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKNXXXXx.  oWMMMMMMMMMMMMMMMM
1867 MMMMMMMMMMMMMMMMMM0'  lKXXXXXx.  ,kXXKKXKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKKKKKKKKk,                                  c0KKKKKKKKKKKKKKKKKKKKKKKKKKK0c   c0XKXXKKKKKKKK0c   lKNXXXXx.  oWMMMMMMMMMMMMMMMM
1868 MMMMMMMMMMMMMMMMMM0'  lKXXXXXO:'';oddOKKKKKKKXXKd.  ,kKKKKKKKKKKKKKKKKKKKKKKKKKKKKk,                                  c0KKKKKKKKKKKKKKKKKKKKKKKKKKK0c   c0XKKKXXKXKOxddc,',dXXXXXXx.  oWMMMMMMMMMMMMMMMM
1869 MMMMMMMMMMMMMMMMMM0'  lKXXXXXXKK0o. .c0XKKKKKKKKd.  ,kKKKKKKKKKKKKKKKKKKKKKKKKKKKKk,                                 .l0KKKKKKKKKKKKKKKKKKKKKKKKKKK0c   c0XKKKKKKKKd. .:OKKXXXXXXXx.  oWMMMMMMMMMMMMMMMM
1870 MMMMMMMMMMMMMMMMMM0'  lKXXXXXXXXXd'..:xOkkkkkkkkl.  'dkkkkkkkkkkkkkkkkkkkkkkkkkkkkxoc:::::::::ccccccccccccccccccccccccdkkkkkkkkkkkkkkkkkkkkkkkkkkkkx:   ;xOkkkkkOOkl...c0XXXXNXXXXx.  oWMMMMMMMMMMMMMMMM
1871 MMMMMMMMMMMMMMMMMM0'  lKXXXXXXXXXKOOkc..........     ...............................................................................................     ..........;xOO0XXXXXXXXXXx.  oWMMMMMMMMMMMMMMMM
1872 MMMMMMMMMMMMMMMMMM0'  lKXXXXXXXXXXXNKl.                                                                                                                            ;OXXXXXXXXXXXXXx.  oWMMMMMMMMMMMMMMMM
1873 MMMMMMMMMMMMMMMMMM0'  lKXXXXXXXXXXXXXOxdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddxkKXXXXXXXXXXXXXx.  oWMMMMMMMMMMMMMMMM
1874 MMMMMMMMMMMMMMMMMM0' .lKXXXNXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx' .dWMMMMMMMMMMMMMMMM
1875 MMMMMMMMMMMMMMMMMMN0kkdc:lOXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKdc:okkkXMMMMMMMMMMMMMMMMM
1876 MMMMMMMMMMMMMMMMMMMMMWd. .dXNXXXNXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXO,  cNMMMMMMMMMMMMMMMMMMMM
1877 MMMMMMMMMMMMMMMMMMMMMWKdloooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooddloOWMMMMMMMMMMMMMMMMMMMM
1878 MMMMMMMMMMMMMMMMMMMMMMMMMNl                                                                                                                                                   ,0MMMMMMMMMMMMMMMMMMMMMMMM
1879 MMMMMMMMMMMMMMMMMMMMMMMMMWk:;;;;;;;::::;;;;;;;;;;;;;;;;;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;;;;;;;;;;;;;;;;;;;;;:dXMMMMMMMMMMMMMMMMMMMMMMMM
1880 MMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMM
1881 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1882 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1883 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1884 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1885 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1886 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1887 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1888 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1889 */
1890 
1891 pragma solidity ^0.8.16;
1892 
1893 
1894 
1895 
1896 
1897 
1898 contract Ticketz is ERC721, Ownable {
1899     using Address for address;
1900     using Counters for Counters.Counter;
1901     using SafeMath for uint256;
1902 
1903     
1904     uint256 public constant MAX_PUBLIC_MINT = 5;
1905     uint256 public totalSupply;
1906     uint256 public price = 0 ether;
1907     uint256 public reserveSupply = 100;
1908     uint256 public maxPerWallet = 5;
1909     uint256 public constant MAX_SUPPLY = 1100;
1910     bool public saleActive; // public sale flag (false on deploy)
1911     
1912 
1913     constructor() ERC721("TICKETZ", "TICKETZ") {}
1914 
1915     //mint settings
1916     modifier mintParameters(uint256 numberToMint) {
1917 
1918         uint256 currentTokens = balanceOf(msg.sender);
1919 
1920         require(currentTokens + numberToMint <= maxPerWallet, "Exceeds maximum number of tokens per wallet");
1921 
1922         require(saleActive, "Sale not live");
1923         _;
1924         require(numberToMint < MAX_PUBLIC_MINT, "Save some for the rest of us!");
1925 
1926         require(msg.value == price * numberToMint, "this is Free99");
1927 
1928         require(numberToMint > 0, "Zero mint");
1929 
1930         require(totalSupply.add(numberToMint) <= MAX_SUPPLY, "Exceeds max supply");
1931 
1932         require(tx.origin == msg.sender, "1100 bonks for being greedy");
1933 
1934 
1935     
1936     }
1937 
1938      function _mintTokens(address to, uint256 numberToMint) internal {
1939         require(numberToMint > 0, "Zero mint");
1940         uint256 currentSupply_ = totalSupply; // memory variable
1941         for (uint256 i; i < numberToMint; ++i) {
1942             _safeMint(to, currentSupply_++); // mint then increment
1943         }
1944         totalSupply = currentSupply_; // update storage
1945     }
1946 
1947 
1948     //Function to set sale active
1949 
1950     function setSaleActive(bool state) external onlyOwner {
1951         saleActive = state;
1952     }
1953 
1954     // Mint for the Dog Groomer
1955 
1956     function devMint(address to, uint256 numberToMint) external onlyOwner {
1957         uint256 _reserveSupply = reserveSupply;
1958         require(numberToMint <= _reserveSupply, "Exceeds reserve limit");
1959         reserveSupply = _reserveSupply - numberToMint;
1960 
1961         _mintTokens(to, numberToMint);
1962     }
1963 
1964     //Public Mint
1965 
1966     function mint(uint256 numberToMint) external payable mintParameters(numberToMint) {
1967         _mintTokens(msg.sender, numberToMint);
1968     }
1969 
1970 
1971     // Take out ETH
1972       function withdraw() public onlyOwner {
1973         uint256 balance = address(this).balance;
1974         payable(msg.sender).transfer(balance);
1975     }
1976 
1977 
1978 
1979    // Set the Metadata
1980 
1981     string private baseURI;
1982 
1983       function _baseURI() internal view override returns (string memory) {
1984         return baseURI;
1985     }
1986 
1987     function setMetadata(string memory metadata) public onlyOwner {
1988         baseURI = metadata;
1989     }
1990 
1991     //Token Tracking
1992     Counters.Counter private tokens;
1993 
1994         function getTokensFromAddress(address wallet) public view returns(uint256[] memory) {
1995         uint256 tokensHeld = balanceOf(wallet);
1996         uint256 currentTokens = tokens.current();
1997         uint256 x = 0;
1998 
1999         uint256[] memory _tokens = new uint256[](tokensHeld);
2000         
2001         for (uint256 i;i < currentTokens;i++) {
2002             if (ownerOf(i) == wallet) {
2003                 _tokens[x] = i;
2004                 x++;
2005             }
2006         }
2007 
2008         return _tokens;
2009     }
2010 
2011     function maxSupply() external view returns(uint256) {
2012         return tokens.current();
2013     }
2014 }