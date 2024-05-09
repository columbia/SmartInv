1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @title Counters
7  * @author Matt Condon (@shrugs)
8  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
9  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
10  *
11  * Include with `using Counters for Counters.Counter;`
12  */
13 library Counters {
14     struct Counter {
15         // This variable should never be directly accessed by users of the library: interactions must be restricted to
16         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
17         // this feature: see https://github.com/ethereum/solidity/issues/4637
18         uint256 _value ; // default: 0
19     }
20 
21     function current(Counter storage counter) internal view returns (uint256) {
22         return counter._value;
23     }
24 
25     function increment(Counter storage counter) internal {
26         unchecked {
27             counter._value += 1;
28         }
29     }
30 
31     function decrement(Counter storage counter) internal {
32         uint256 value = counter._value;
33         require(value > 0, "Counter: decrement overflow");
34         unchecked {
35             counter._value = value - 1;
36         }
37     }
38 
39     function reset(Counter storage counter) internal {
40         counter._value = 1;
41     }
42 }
43 
44 // File: @openzeppelin/contracts@4.8.1/utils/math/Math.sol
45 
46 
47 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
48 
49 
50 /**
51  * @dev Standard math utilities missing in the Solidity language.
52  */
53 library Math {
54     enum Rounding {
55         Down, // Toward negative infinity
56         Up, // Toward infinity
57         Zero // Toward zero
58     }
59 
60     /**
61      * @dev Returns the largest of two numbers.
62      */
63     function max(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a > b ? a : b;
65     }
66 
67     /**
68      * @dev Returns the smallest of two numbers.
69      */
70     function min(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a < b ? a : b;
72     }
73 
74     /**
75      * @dev Returns the average of two numbers. The result is rounded towards
76      * zero.
77      */
78     function average(uint256 a, uint256 b) internal pure returns (uint256) {
79         // (a + b) / 2 can overflow.
80         return (a & b) + (a ^ b) / 2;
81     }
82 
83     /**
84      * @dev Returns the ceiling of the division of two numbers.
85      *
86      * This differs from standard division with `/` in that it rounds up instead
87      * of rounding down.
88      */
89     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
90         // (a + b - 1) / b can overflow on addition, so we distribute.
91         return a == 0 ? 0 : (a - 1) / b + 1;
92     }
93 
94     /**
95      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
96      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
97      * with further edits by Uniswap Labs also under MIT license.
98      */
99     function mulDiv(
100         uint256 x,
101         uint256 y,
102         uint256 denominator
103     ) internal pure returns (uint256 result) {
104         unchecked {
105             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
106             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
107             // variables such that product = prod1 * 2^256 + prod0.
108             uint256 prod0; // Least significant 256 bits of the product
109             uint256 prod1; // Most significant 256 bits of the product
110             assembly {
111                 let mm := mulmod(x, y, not(0))
112                 prod0 := mul(x, y)
113                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
114             }
115 
116             // Handle non-overflow cases, 256 by 256 division.
117             if (prod1 == 0) {
118                 return prod0 / denominator;
119             }
120 
121             // Make sure the result is less than 2^256. Also prevents denominator == 0.
122             require(denominator > prod1);
123 
124             ///////////////////////////////////////////////
125             // 512 by 256 division.
126             ///////////////////////////////////////////////
127 
128             // Make division exact by subtracting the remainder from [prod1 prod0].
129             uint256 remainder;
130             assembly {
131                 // Compute remainder using mulmod.
132                 remainder := mulmod(x, y, denominator)
133 
134                 // Subtract 256 bit number from 512 bit number.
135                 prod1 := sub(prod1, gt(remainder, prod0))
136                 prod0 := sub(prod0, remainder)
137             }
138 
139             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
140             // See https://cs.stackexchange.com/q/138556/92363.
141 
142             // Does not overflow because the denominator cannot be zero at this stage in the function.
143             uint256 twos = denominator & (~denominator + 1);
144             assembly {
145                 // Divide denominator by twos.
146                 denominator := div(denominator, twos)
147 
148                 // Divide [prod1 prod0] by twos.
149                 prod0 := div(prod0, twos)
150 
151                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
152                 twos := add(div(sub(0, twos), twos), 1)
153             }
154 
155             // Shift in bits from prod1 into prod0.
156             prod0 |= prod1 * twos;
157 
158             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
159             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
160             // four bits. That is, denominator * inv = 1 mod 2^4.
161             uint256 inverse = (3 * denominator) ^ 2;
162 
163             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
164             // in modular arithmetic, doubling the correct bits in each step.
165             inverse *= 2 - denominator * inverse; // inverse mod 2^8
166             inverse *= 2 - denominator * inverse; // inverse mod 2^16
167             inverse *= 2 - denominator * inverse; // inverse mod 2^32
168             inverse *= 2 - denominator * inverse; // inverse mod 2^64
169             inverse *= 2 - denominator * inverse; // inverse mod 2^128
170             inverse *= 2 - denominator * inverse; // inverse mod 2^256
171 
172             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
173             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
174             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
175             // is no longer required.
176             result = prod0 * inverse;
177             return result;
178         }
179     }
180 
181     /**
182      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
183      */
184     function mulDiv(
185         uint256 x,
186         uint256 y,
187         uint256 denominator,
188         Rounding rounding
189     ) internal pure returns (uint256) {
190         uint256 result = mulDiv(x, y, denominator);
191         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
192             result += 1;
193         }
194         return result;
195     }
196 
197     /**
198      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
199      *
200      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
201      */
202     function sqrt(uint256 a) internal pure returns (uint256) {
203         if (a == 0) {
204             return 0;
205         }
206 
207         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
208         //
209         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
210         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
211         //
212         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
213         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
214         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
215         //
216         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
217         uint256 result = 1 << (log2(a) >> 1);
218 
219         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
220         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
221         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
222         // into the expected uint128 result.
223         unchecked {
224             result = (result + a / result) >> 1;
225             result = (result + a / result) >> 1;
226             result = (result + a / result) >> 1;
227             result = (result + a / result) >> 1;
228             result = (result + a / result) >> 1;
229             result = (result + a / result) >> 1;
230             result = (result + a / result) >> 1;
231             return min(result, a / result);
232         }
233     }
234 
235     /**
236      * @notice Calculates sqrt(a), following the selected rounding direction.
237      */
238     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
239         unchecked {
240             uint256 result = sqrt(a);
241             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
242         }
243     }
244 
245     /**
246      * @dev Return the log in base 2, rounded down, of a positive value.
247      * Returns 0 if given 0.
248      */
249     function log2(uint256 value) internal pure returns (uint256) {
250         uint256 result = 0;
251         unchecked {
252             if (value >> 128 > 0) {
253                 value >>= 128;
254                 result += 128;
255             }
256             if (value >> 64 > 0) {
257                 value >>= 64;
258                 result += 64;
259             }
260             if (value >> 32 > 0) {
261                 value >>= 32;
262                 result += 32;
263             }
264             if (value >> 16 > 0) {
265                 value >>= 16;
266                 result += 16;
267             }
268             if (value >> 8 > 0) {
269                 value >>= 8;
270                 result += 8;
271             }
272             if (value >> 4 > 0) {
273                 value >>= 4;
274                 result += 4;
275             }
276             if (value >> 2 > 0) {
277                 value >>= 2;
278                 result += 2;
279             }
280             if (value >> 1 > 0) {
281                 result += 1;
282             }
283         }
284         return result;
285     }
286 
287     /**
288      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
289      * Returns 0 if given 0.
290      */
291     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
292         unchecked {
293             uint256 result = log2(value);
294             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
295         }
296     }
297 
298     /**
299      * @dev Return the log in base 10, rounded down, of a positive value.
300      * Returns 0 if given 0.
301      */
302     function log10(uint256 value) internal pure returns (uint256) {
303         uint256 result = 0;
304         unchecked {
305             if (value >= 10**64) {
306                 value /= 10**64;
307                 result += 64;
308             }
309             if (value >= 10**32) {
310                 value /= 10**32;
311                 result += 32;
312             }
313             if (value >= 10**16) {
314                 value /= 10**16;
315                 result += 16;
316             }
317             if (value >= 10**8) {
318                 value /= 10**8;
319                 result += 8;
320             }
321             if (value >= 10**4) {
322                 value /= 10**4;
323                 result += 4;
324             }
325             if (value >= 10**2) {
326                 value /= 10**2;
327                 result += 2;
328             }
329             if (value >= 10**1) {
330                 result += 1;
331             }
332         }
333         return result;
334     }
335 
336     /**
337      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
338      * Returns 0 if given 0.
339      */
340     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
341         unchecked {
342             uint256 result = log10(value);
343             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
344         }
345     }
346 
347     /**
348      * @dev Return the log in base 256, rounded down, of a positive value.
349      * Returns 0 if given 0.
350      *
351      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
352      */
353     function log256(uint256 value) internal pure returns (uint256) {
354         uint256 result = 0;
355         unchecked {
356             if (value >> 128 > 0) {
357                 value >>= 128;
358                 result += 16;
359             }
360             if (value >> 64 > 0) {
361                 value >>= 64;
362                 result += 8;
363             }
364             if (value >> 32 > 0) {
365                 value >>= 32;
366                 result += 4;
367             }
368             if (value >> 16 > 0) {
369                 value >>= 16;
370                 result += 2;
371             }
372             if (value >> 8 > 0) {
373                 result += 1;
374             }
375         }
376         return result;
377     }
378 
379     /**
380      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
381      * Returns 0 if given 0.
382      */
383     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
384         unchecked {
385             uint256 result = log256(value);
386             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
387         }
388     }
389 }
390 
391 
392 
393 
394 library SafeMath {
395     /**
396      * @dev Returns the addition of two unsigned integers, with an overflow flag.
397      *
398      * _Available since v3.4._
399      */
400     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
401         unchecked {
402             uint256 c = a + b;
403             if (c < a) return (false, 0);
404             return (true, c);
405         }
406     }
407 
408     /**
409      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
410      *
411      * _Available since v3.4._
412      */
413     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
414         unchecked {
415             if (b > a) return (false, 0);
416             return (true, a - b);
417         }
418     }
419 
420     /**
421      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
422      *
423      * _Available since v3.4._
424      */
425     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
426         unchecked {
427             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
428             // benefit is lost if 'b' is also tested.
429             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
430             if (a == 0) return (true, 0);
431             uint256 c = a * b;
432             if (c / a != b) return (false, 0);
433             return (true, c);
434         }
435     }
436 
437     /**
438      * @dev Returns the division of two unsigned integers, with a division by zero flag.
439      *
440      * _Available since v3.4._
441      */
442     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
443         unchecked {
444             if (b == 0) return (false, 0);
445             return (true, a / b);
446         }
447     }
448 
449     /**
450      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
451      *
452      * _Available since v3.4._
453      */
454     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
455         unchecked {
456             if (b == 0) return (false, 0);
457             return (true, a % b);
458         }
459     }
460 
461     /**
462      * @dev Returns the addition of two unsigned integers, reverting on
463      * overflow.
464      *
465      * Counterpart to Solidity's `+` operator.
466      *
467      * Requirements:
468      *
469      * - Addition cannot overflow.
470      */
471     function add(uint256 a, uint256 b) internal pure returns (uint256) {
472         return a + b;
473     }
474 
475     /**
476      * @dev Returns the subtraction of two unsigned integers, reverting on
477      * overflow (when the result is negative).
478      *
479      * Counterpart to Solidity's `-` operator.
480      *
481      * Requirements:
482      *
483      * - Subtraction cannot overflow.
484      */
485     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
486         return a - b;
487     }
488 
489     /**
490      * @dev Returns the multiplication of two unsigned integers, reverting on
491      * overflow.
492      *
493      * Counterpart to Solidity's `*` operator.
494      *
495      * Requirements:
496      *
497      * - Multiplication cannot overflow.
498      */
499     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
500         return a * b;
501     }
502 
503     /**
504      * @dev Returns the integer division of two unsigned integers, reverting on
505      * division by zero. The result is rounded towards zero.
506      *
507      * Counterpart to Solidity's `/` operator.
508      *
509      * Requirements:
510      *
511      * - The divisor cannot be zero.
512      */
513     function div(uint256 a, uint256 b) internal pure returns (uint256) {
514         return a / b;
515     }
516 
517     /**
518      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
519      * reverting when dividing by zero.
520      *
521      * Counterpart to Solidity's `%` operator. This function uses a `revert`
522      * opcode (which leaves remaining gas untouched) while Solidity uses an
523      * invalid opcode to revert (consuming all remaining gas).
524      *
525      * Requirements:
526      *
527      * - The divisor cannot be zero.
528      */
529     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
530         return a % b;
531     }
532 
533     /**
534      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
535      * overflow (when the result is negative).
536      *
537      * CAUTION: This function is deprecated because it requires allocating memory for the error
538      * message unnecessarily. For custom revert reasons use {trySub}.
539      *
540      * Counterpart to Solidity's `-` operator.
541      *
542      * Requirements:
543      *
544      * - Subtraction cannot overflow.
545      */
546     function sub(
547         uint256 a,
548         uint256 b,
549         string memory errorMessage
550     ) internal pure returns (uint256) {
551         unchecked {
552             require(b <= a, errorMessage);
553             return a - b;
554         }
555     }
556 
557     /**
558      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
559      * division by zero. The result is rounded towards zero.
560      *
561      * Counterpart to Solidity's `/` operator. Note: this function uses a
562      * `revert` opcode (which leaves remaining gas untouched) while Solidity
563      * uses an invalid opcode to revert (consuming all remaining gas).
564      *
565      * Requirements:
566      *
567      * - The divisor cannot be zero.
568      */
569     function div(
570         uint256 a,
571         uint256 b,
572         string memory errorMessage
573     ) internal pure returns (uint256) {
574         unchecked {
575             require(b > 0, errorMessage);
576             return a / b;
577         }
578     }
579 
580     /**
581      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
582      * reverting with custom message when dividing by zero.
583      *
584      * CAUTION: This function is deprecated because it requires allocating memory for the error
585      * message unnecessarily. For custom revert reasons use {tryMod}.
586      *
587      * Counterpart to Solidity's `%` operator. This function uses a `revert`
588      * opcode (which leaves remaining gas untouched) while Solidity uses an
589      * invalid opcode to revert (consuming all remaining gas).
590      *
591      * Requirements:
592      *
593      * - The divisor cannot be zero.
594      */
595     function mod(
596         uint256 a,
597         uint256 b,
598         string memory errorMessage
599     ) internal pure returns (uint256) {
600         unchecked {
601             require(b > 0, errorMessage);
602             return a % b;
603         }
604     }
605 }
606 
607 
608 /**
609  * @dev String operations.
610  */
611 library Strings {
612     bytes16 private constant _SYMBOLS = "0123456789abcdef";
613     uint8 private constant _ADDRESS_LENGTH = 20;
614 
615     /**
616      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
617      */
618     function toString(uint256 value) internal pure returns (string memory) {
619         unchecked {
620             uint256 length = Math.log10(value) + 1;
621             string memory buffer = new string(length);
622             uint256 ptr;
623             /// @solidity memory-safe-assembly
624             assembly {
625                 ptr := add(buffer, add(32, length))
626             }
627             while (true) {
628                 ptr--;
629                 /// @solidity memory-safe-assembly
630                 assembly {
631                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
632                 }
633                 value /= 10;
634                 if (value == 0) break;
635             }
636             return buffer;
637         }
638     }
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
642      */
643     function toHexString(uint256 value) internal pure returns (string memory) {
644         unchecked {
645             return toHexString(value, Math.log256(value) + 1);
646         }
647     }
648 
649     /**
650      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
651      */
652     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
653         bytes memory buffer = new bytes(2 * length + 2);
654         buffer[0] = "0";
655         buffer[1] = "x";
656         for (uint256 i = 2 * length + 1; i > 1; --i) {
657             buffer[i] = _SYMBOLS[value & 0xf];
658             value >>= 4;
659         }
660         require(value == 0, "Strings: hex length insufficient");
661         return string(buffer);
662     }
663 
664     /**
665      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
666      */
667     function toHexString(address addr) internal pure returns (string memory) {
668         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
669     }
670 }
671 
672 
673 
674 /**
675  * @dev Provides information about the current execution context, including the
676  * sender of the transaction and its data. While these are generally available
677  * via msg.sender and msg.data, they should not be accessed in such a direct
678  * manner, since when dealing with meta-transactions the account sending and
679  * paying for execution may not be the actual sender (as far as an application
680  * is concerned).
681  *
682  * This contract is only required for intermediate, library-like contracts.
683  */
684 abstract contract Context {
685     function _msgSender() internal view virtual returns (address) {
686         return msg.sender;
687     }
688 
689     function _msgData() internal view virtual returns (bytes calldata) {
690         return msg.data;
691     }
692 }
693 
694 
695 
696 
697 /**
698  * @dev Contract module which provides a basic access control mechanism, where
699  * there is an account (an owner) that can be granted exclusive access to
700  * specific functions.
701  *
702  * By default, the owner account will be the one that deploys the contract. This
703  * can later be changed with {transferOwnership}.
704  *
705  * This module is used through inheritance. It will make available the modifier
706  * `onlyOwner`, which can be applied to your functions to restrict their use to
707  * the owner.
708  */
709 abstract contract Ownable is Context {
710     address private _owner;
711 
712     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
713 
714     /**
715      * @dev Initializes the contract setting the deployer as the initial owner.
716      */
717     constructor() {
718         _transferOwnership(_msgSender());
719     }
720 
721     /**
722      * @dev Throws if called by any account other than the owner.
723      */
724     modifier onlyOwner() {
725         _checkOwner();
726         _;
727     }
728 
729     /**
730      * @dev Returns the address of the current owner.
731      */
732     function owner() public view virtual returns (address) {
733         return _owner;
734     }
735 
736     /**
737      * @dev Throws if the sender is not the owner.
738      */
739     function _checkOwner() internal view virtual {
740         require(owner() == _msgSender(), "Ownable: caller is not the owner");
741     }
742 
743     /**
744      * @dev Leaves the contract without owner. It will not be possible to call
745      * `onlyOwner` functions anymore. Can only be called by the current owner.
746      *
747      * NOTE: Renouncing ownership will leave the contract without an owner,
748      * thereby removing any functionality that is only available to the owner.
749      */
750     function renounceOwnership() public virtual onlyOwner {
751         _transferOwnership(address(0));
752     }
753 
754     /**
755      * @dev Transfers ownership of the contract to a new account (`newOwner`).
756      * Can only be called by the current owner.
757      */
758     function transferOwnership(address newOwner) public virtual onlyOwner {
759         require(newOwner != address(0), "Ownable: new owner is the zero address");
760         _transferOwnership(newOwner);
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Internal function without access restriction.
766      */
767     function _transferOwnership(address newOwner) internal virtual {
768         address oldOwner = _owner;
769         _owner = newOwner;
770         emit OwnershipTransferred(oldOwner, newOwner);
771     }
772 }
773 
774 
775 
776 /**
777  * @dev Collection of functions related to the address type
778  */
779 library Address {
780     /**
781      * @dev Returns true if `account` is a contract.
782      *
783      * [IMPORTANT]
784      * ====
785      * It is unsafe to assume that an address for which this function returns
786      * false is an externally-owned account (EOA) and not a contract.
787      *
788      * Among others, `isContract` will return false for the following
789      * types of addresses:
790      *
791      *  - an externally-owned account
792      *  - a contract in construction
793      *  - an address where a contract will be created
794      *  - an address where a contract lived, but was destroyed
795      * ====
796      *
797      * [IMPORTANT]
798      * ====
799      * You shouldn't rely on `isContract` to protect against flash loan attacks!
800      *
801      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
802      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
803      * constructor.
804      * ====
805      */
806     function isContract(address account) internal view returns (bool) {
807         // This method relies on extcodesize/address.code.length, which returns 0
808         // for contracts in construction, since the code is only stored at the end
809         // of the constructor execution.
810 
811         return account.code.length > 0;
812     }
813 
814     /**
815      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
816      * `recipient`, forwarding all available gas and reverting on errors.
817      *
818      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
819      * of certain opcodes, possibly making contracts go over the 2300 gas limit
820      * imposed by `transfer`, making them unable to receive funds via
821      * `transfer`. {sendValue} removes this limitation.
822      *
823      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
824      *
825      * IMPORTANT: because control is transferred to `recipient`, care must be
826      * taken to not create reentrancy vulnerabilities. Consider using
827      * {ReentrancyGuard} or the
828      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
829      */
830     function sendValue(address payable recipient, uint256 amount) internal {
831         require(address(this).balance >= amount, "Address: insufficient balance");
832 
833         (bool success, ) = recipient.call{value: amount}("");
834         require(success, "Address: unable to send value, recipient may have reverted");
835     }
836 
837     /**
838      * @dev Performs a Solidity function call using a low level `call`. A
839      * plain `call` is an unsafe replacement for a function call: use this
840      * function instead.
841      *
842      * If `target` reverts with a revert reason, it is bubbled up by this
843      * function (like regular Solidity function calls).
844      *
845      * Returns the raw returned data. To convert to the expected return value,
846      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
847      *
848      * Requirements:
849      *
850      * - `target` must be a contract.
851      * - calling `target` with `data` must not revert.
852      *
853      * _Available since v3.1._
854      */
855     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
856         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
857     }
858 
859     /**
860      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
861      * `errorMessage` as a fallback revert reason when `target` reverts.
862      *
863      * _Available since v3.1._
864      */
865     function functionCall(
866         address target,
867         bytes memory data,
868         string memory errorMessage
869     ) internal returns (bytes memory) {
870         return functionCallWithValue(target, data, 0, errorMessage);
871     }
872 
873     /**
874      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
875      * but also transferring `value` wei to `target`.
876      *
877      * Requirements:
878      *
879      * - the calling contract must have an ETH balance of at least `value`.
880      * - the called Solidity function must be `payable`.
881      *
882      * _Available since v3.1._
883      */
884     function functionCallWithValue(
885         address target,
886         bytes memory data,
887         uint256 value
888     ) internal returns (bytes memory) {
889         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
890     }
891 
892     /**
893      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
894      * with `errorMessage` as a fallback revert reason when `target` reverts.
895      *
896      * _Available since v3.1._
897      */
898     function functionCallWithValue(
899         address target,
900         bytes memory data,
901         uint256 value,
902         string memory errorMessage
903     ) internal returns (bytes memory) {
904         require(address(this).balance >= value, "Address: insufficient balance for call");
905         (bool success, bytes memory returndata) = target.call{value: value}(data);
906         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
907     }
908 
909     /**
910      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
911      * but performing a static call.
912      *
913      * _Available since v3.3._
914      */
915     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
916         return functionStaticCall(target, data, "Address: low-level static call failed");
917     }
918 
919     /**
920      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
921      * but performing a static call.
922      *
923      * _Available since v3.3._
924      */
925     function functionStaticCall(
926         address target,
927         bytes memory data,
928         string memory errorMessage
929     ) internal view returns (bytes memory) {
930         (bool success, bytes memory returndata) = target.staticcall(data);
931         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
932     }
933 
934     /**
935      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
936      * but performing a delegate call.
937      *
938      * _Available since v3.4._
939      */
940     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
941         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
942     }
943 
944     /**
945      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
946      * but performing a delegate call.
947      *
948      * _Available since v3.4._
949      */
950     function functionDelegateCall(
951         address target,
952         bytes memory data,
953         string memory errorMessage
954     ) internal returns (bytes memory) {
955         (bool success, bytes memory returndata) = target.delegatecall(data);
956         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
957     }
958 
959     /**
960      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
961      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
962      *
963      * _Available since v4.8._
964      */
965     function verifyCallResultFromTarget(
966         address target,
967         bool success,
968         bytes memory returndata,
969         string memory errorMessage
970     ) internal view returns (bytes memory) {
971         if (success) {
972             if (returndata.length == 0) {
973                 // only check isContract if the call was successful and the return data is empty
974                 // otherwise we already know that it was a contract
975                 require(isContract(target), "Address: call to non-contract");
976             }
977             return returndata;
978         } else {
979             _revert(returndata, errorMessage);
980         }
981     }
982 
983     /**
984      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
985      * revert reason or using the provided one.
986      *
987      * _Available since v4.3._
988      */
989     function verifyCallResult(
990         bool success,
991         bytes memory returndata,
992         string memory errorMessage
993     ) internal pure returns (bytes memory) {
994         if (success) {
995             return returndata;
996         } else {
997             _revert(returndata, errorMessage);
998         }
999     }
1000 
1001     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1002         // Look for revert reason and bubble it up if present
1003         if (returndata.length > 0) {
1004             // The easiest way to bubble the revert reason is using memory via assembly
1005             /// @solidity memory-safe-assembly
1006             assembly {
1007                 let returndata_size := mload(returndata)
1008                 revert(add(32, returndata), returndata_size)
1009             }
1010         } else {
1011             revert(errorMessage);
1012         }
1013     }
1014 }
1015 
1016 
1017 
1018 /**
1019  * @title ERC721 token receiver interface
1020  * @dev Interface for any contract that wants to support safeTransfers
1021  * from ERC721 asset contracts.
1022  */
1023 interface IERC721Receiver {
1024     /**
1025      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1026      * by `operator` from `from`, this function is called.
1027      *
1028      * It must return its Solidity selector to confirm the token transfer.
1029      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1030      *
1031      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1032      */
1033     function onERC721Received(
1034         address operator,
1035         address from,
1036         uint256 tokenId,
1037         bytes calldata data
1038     ) external returns (bytes4);
1039 }
1040 
1041 
1042 
1043 /**
1044  * @dev Interface of the ERC165 standard, as defined in the
1045  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1046  *
1047  * Implementers can declare support of contract interfaces, which can then be
1048  * queried by others ({ERC165Checker}).
1049  *
1050  * For an implementation, see {ERC165}.
1051  */
1052 interface IERC165 {
1053     /**
1054      * @dev Returns true if this contract implements the interface defined by
1055      * `interfaceId`. See the corresponding
1056      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1057      * to learn more about how these ids are created.
1058      *
1059      * This function call must use less than 30 000 gas.
1060      */
1061     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1062 }
1063 
1064 
1065 
1066 
1067 /**
1068  * @dev Implementation of the {IERC165} interface.
1069  *
1070  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1071  * for the additional interface id that will be supported. For example:
1072  *
1073  * ```solidity
1074  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1075  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1076  * }
1077  * ```
1078  *
1079  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1080  */
1081 abstract contract ERC165 is IERC165 {
1082     /**
1083      * @dev See {IERC165-supportsInterface}.
1084      */
1085     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1086         return interfaceId == type(IERC165).interfaceId;
1087     }
1088 }
1089 
1090 
1091 
1092 /**
1093  * @dev Required interface of an ERC721 compliant contract.
1094  */
1095 interface IERC721 is IERC165 {
1096     /**
1097      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1098      */
1099     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1100 
1101     /**
1102      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1103      */
1104     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1105 
1106     /**
1107      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1108      */
1109     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1110 
1111     /**
1112      * @dev Returns the number of tokens in ``owner``'s account.
1113      */
1114     function balanceOf(address owner) external view returns (uint256 balance);
1115 
1116     /**
1117      * @dev Returns the owner of the `tokenId` token.
1118      *
1119      * Requirements:
1120      *
1121      * - `tokenId` must exist.
1122      */
1123     function ownerOf(uint256 tokenId) external view returns (address owner);
1124 
1125     /**
1126      * @dev Safely transfers `tokenId` token from `from` to `to`.
1127      *
1128      * Requirements:
1129      *
1130      * - `from` cannot be the zero address.
1131      * - `to` cannot be the zero address.
1132      * - `tokenId` token must exist and be owned by `from`.
1133      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1134      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function safeTransferFrom(
1139         address from,
1140         address to,
1141         uint256 tokenId,
1142         bytes calldata data
1143     ) external;
1144 
1145     /**
1146      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1147      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1148      *
1149      * Requirements:
1150      *
1151      * - `from` cannot be the zero address.
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must exist and be owned by `from`.
1154      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function safeTransferFrom(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) external;
1164 
1165     /**
1166      * @dev Transfers `tokenId` token from `from` to `to`.
1167      *
1168      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1169      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1170      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1171      *
1172      * Requirements:
1173      *
1174      * - `from` cannot be the zero address.
1175      * - `to` cannot be the zero address.
1176      * - `tokenId` token must be owned by `from`.
1177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function transferFrom(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) external;
1186 
1187     /**
1188      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1189      * The approval is cleared when the token is transferred.
1190      *
1191      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1192      *
1193      * Requirements:
1194      *
1195      * - The caller must own the token or be an approved operator.
1196      * - `tokenId` must exist.
1197      *
1198      * Emits an {Approval} event.
1199      */
1200     function approve(address to, uint256 tokenId) external;
1201 
1202     /**
1203      * @dev Approve or remove `operator` as an operator for the caller.
1204      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1205      *
1206      * Requirements:
1207      *
1208      * - The `operator` cannot be the caller.
1209      *
1210      * Emits an {ApprovalForAll} event.
1211      */
1212     function setApprovalForAll(address operator, bool _approved) external;
1213 
1214     /**
1215      * @dev Returns the account approved for `tokenId` token.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must exist.
1220      */
1221     function getApproved(uint256 tokenId) external view returns (address operator);
1222 
1223     /**
1224      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1225      *
1226      * See {setApprovalForAll}
1227      */
1228     function isApprovedForAll(address owner, address operator) external view returns (bool);
1229 }
1230 
1231 
1232 
1233 /**
1234  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1235  * @dev See https://eips.ethereum.org/EIPS/eip-721
1236  */
1237 interface IERC721Metadata is IERC721 {
1238     /**
1239      * @dev Returns the token collection name.
1240      */
1241     function name() external view returns (string memory);
1242 
1243     /**
1244      * @dev Returns the token collection symbol.
1245      */
1246     function symbol() external view returns (string memory);
1247 
1248     /**
1249      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1250      */
1251     function tokenURI(uint256 tokenId) external view returns (string memory);
1252 }
1253 
1254 
1255 
1256 
1257 
1258 
1259 
1260 
1261 
1262 
1263 /**
1264  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1265  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1266  * {ERC721Enumerable}.
1267  */
1268 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1269     using Address for address;
1270     using Strings for uint256;
1271 
1272     // Token name
1273     string private _name;
1274 
1275     // Token symbol
1276     string private _symbol;
1277 
1278     // Mapping from token ID to owner address
1279     mapping(uint256 => address) private _owners;
1280 
1281     // Mapping owner address to token count
1282     mapping(address => uint256) private _balances;
1283 
1284     // Mapping from token ID to approved address
1285     mapping(uint256 => address) private _tokenApprovals;
1286 
1287     // Mapping from owner to operator approvals
1288     mapping(address => mapping(address => bool)) private _operatorApprovals;
1289 
1290 
1291     /**
1292      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1293      */
1294     constructor(string memory name_, string memory symbol_) {
1295         _name = name_;
1296         _symbol = symbol_;
1297     }
1298 
1299     /**
1300      * @dev See {IERC165-supportsInterface}.
1301      */
1302     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1303         return
1304             interfaceId == type(IERC721).interfaceId ||
1305             interfaceId == type(IERC721Metadata).interfaceId ||
1306             super.supportsInterface(interfaceId);
1307     }
1308 
1309     /**
1310      * @dev See {IERC721-balanceOf}.
1311      */
1312     function balanceOf(address owner) public view virtual override returns (uint256) {
1313         require(owner != address(0), "ERC721: address zero is not a valid owner");
1314         return _balances[owner];
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-ownerOf}.
1319      */
1320     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1321         address owner = _ownerOf(tokenId);
1322         require(owner != address(0), "ERC721: invalid token ID");
1323         return owner;
1324     }
1325 
1326     /**
1327      * @dev See {IERC721Metadata-name}.
1328      */
1329     function name() public view virtual override returns (string memory) {
1330         return _name;
1331     }
1332 
1333     /**
1334      * @dev See {IERC721Metadata-symbol}.
1335      */
1336     function symbol() public view virtual override returns (string memory) {
1337         return _symbol;
1338     }
1339 
1340     /**
1341      * @dev See {IERC721Metadata-tokenURI}.
1342      */
1343     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1344         _requireMinted(tokenId);
1345 
1346         string memory baseURI = _baseURI();
1347         string memory orgURI = _orgURI();
1348         return bytes(orgURI).length > 0 ? string(abi.encodePacked(orgURI, tokenId.toString())) : baseURI;
1349     }
1350 
1351     /**
1352      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1353      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1354      * by default, can be overridden in child contracts.
1355      */
1356     function _baseURI() internal view virtual returns (string memory) {
1357         return "";
1358     }
1359 
1360     function _orgURI() internal view virtual returns (string memory) {
1361         return "";
1362     }
1363 
1364     /**
1365      * @dev See {IERC721-approve}.
1366      */
1367     function approve(address to, uint256 tokenId) public virtual override {
1368         address owner = ERC721.ownerOf(tokenId);
1369         require(to != owner, "ERC721: approval to current owner");
1370 
1371         require(
1372             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1373             "ERC721: approve caller is not token owner or approved for all"
1374         );
1375 
1376         _approve(to, tokenId);
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-getApproved}.
1381      */
1382     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1383         _requireMinted(tokenId);
1384 
1385         return _tokenApprovals[tokenId];
1386     }
1387 
1388     /**
1389      * @dev See {IERC721-setApprovalForAll}.
1390      */
1391     function setApprovalForAll(address operator, bool approved) public virtual override {
1392         _setApprovalForAll(_msgSender(), operator, approved);
1393     }
1394 
1395     /**
1396      * @dev See {IERC721-isApprovedForAll}.
1397      */
1398     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1399         return _operatorApprovals[owner][operator];
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-transferFrom}.
1404      */
1405     function transferFrom(
1406         address from,
1407         address to,
1408         uint256 tokenId
1409     ) public virtual override {
1410         //solhint-disable-next-line max-line-length
1411         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1412 
1413         _transfer(from, to, tokenId);
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-safeTransferFrom}.
1418      */
1419     function safeTransferFrom(
1420         address from,
1421         address to,
1422         uint256 tokenId
1423     ) public virtual override {
1424         safeTransferFrom(from, to, tokenId, "");
1425     }
1426 
1427     /**
1428      * @dev See {IERC721-safeTransferFrom}.
1429      */
1430     function safeTransferFrom(
1431         address from,
1432         address to,
1433         uint256 tokenId,
1434         bytes memory data
1435     ) public virtual override {
1436         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1437         _safeTransfer(from, to, tokenId, data);
1438     }
1439 
1440     /**
1441      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1442      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1443      *
1444      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1445      *
1446      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1447      * implement alternative mechanisms to perform token transfer, such as signature-based.
1448      *
1449      * Requirements:
1450      *
1451      * - `from` cannot be the zero address.
1452      * - `to` cannot be the zero address.
1453      * - `tokenId` token must exist and be owned by `from`.
1454      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function _safeTransfer(
1459         address from,
1460         address to,
1461         uint256 tokenId,
1462         bytes memory data
1463     ) internal virtual {
1464         _transfer(from, to, tokenId);
1465         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1466     }
1467 
1468     /**
1469      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1470      */
1471     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1472         return _owners[tokenId];
1473     }
1474 
1475     /**
1476      * @dev Returns whether `tokenId` exists.
1477      *
1478      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1479      *
1480      * Tokens start existing when they are minted (`_mint`),
1481      * and stop existing when they are burned (`_burn`).
1482      */
1483     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1484         return _ownerOf(tokenId) != address(0);
1485     }
1486 
1487     /**
1488      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1489      *
1490      * Requirements:
1491      *
1492      * - `tokenId` must exist.
1493      */
1494     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1495         address owner = ERC721.ownerOf(tokenId);
1496         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1497     }
1498 
1499     /**
1500      * @dev Safely mints `tokenId` and transfers it to `to`.
1501      *
1502      * Requirements:
1503      *
1504      * - `tokenId` must not exist.
1505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1506      *
1507      * Emits a {Transfer} event.
1508      */
1509     function _safeMint(address to, uint256 tokenId) internal virtual {
1510         _safeMint(to, tokenId, "");
1511     }
1512 
1513     /**
1514      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1515      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1516      */
1517     function _safeMint(
1518         address to,
1519         uint256 tokenId,
1520         bytes memory data
1521     ) internal virtual {
1522         _mint(to, tokenId);
1523         require(
1524             _checkOnERC721Received(address(0), to, tokenId, data),
1525             "ERC721: transfer to non ERC721Receiver implementer"
1526         );
1527     }
1528 
1529     /**
1530      * @dev Mints `tokenId` and transfers it to `to`.
1531      *
1532      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1533      *
1534      * Requirements:
1535      *
1536      * - `tokenId` must not exist.
1537      * - `to` cannot be the zero address.
1538      *
1539      * Emits a {Transfer} event.
1540      */
1541     function _mint(address to, uint256 tokenId) internal virtual {
1542         require(to != address(0), "ERC721: mint to the zero address");
1543         require(!_exists(tokenId), "ERC721: token already minted");
1544 
1545         _beforeTokenTransfer(address(0), to, tokenId, 1);
1546 
1547         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1548         require(!_exists(tokenId), "ERC721: token already minted");
1549 
1550         unchecked {
1551             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1552             // Given that tokens are minted one by one, it is impossible in practice that
1553             // this ever happens. Might change if we allow batch minting.
1554             // The ERC fails to describe this case.
1555             _balances[to] += 1;
1556         }
1557 
1558         _owners[tokenId] = to;
1559 
1560         emit Transfer(address(0), to, tokenId);
1561 
1562         _afterTokenTransfer(address(0), to, tokenId, 1);
1563     }
1564 
1565     /**
1566      * @dev Destroys `tokenId`.
1567      * The approval is cleared when the token is burned.
1568      * This is an internal function that does not check if the sender is authorized to operate on the token.
1569      *
1570      * Requirements:
1571      *
1572      * - `tokenId` must exist.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _burn(uint256 tokenId) internal virtual {
1577         address owner = ERC721.ownerOf(tokenId);
1578 
1579         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1580 
1581         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1582         owner = ERC721.ownerOf(tokenId);
1583 
1584         // Clear approvals
1585         delete _tokenApprovals[tokenId];
1586 
1587         unchecked {
1588             // Cannot overflow, as that would require more tokens to be burned/transferred
1589             // out than the owner initially received through minting and transferring in.
1590             _balances[owner] -= 1;
1591         }
1592         delete _owners[tokenId];
1593 
1594         emit Transfer(owner, address(0), tokenId);
1595 
1596         _afterTokenTransfer(owner, address(0), tokenId, 1);
1597     }
1598 
1599     /**
1600      * @dev Transfers `tokenId` from `from` to `to`.
1601      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1602      *
1603      * Requirements:
1604      *
1605      * - `to` cannot be the zero address.
1606      * - `tokenId` token must be owned by `from`.
1607      *
1608      * Emits a {Transfer} event.
1609      */
1610     function _transfer(
1611         address from,
1612         address to,
1613         uint256 tokenId
1614     ) internal virtual {
1615         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1616         require(to != address(0), "ERC721: transfer to the zero address");
1617 
1618         _beforeTokenTransfer(from, to, tokenId, 1);
1619 
1620         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1621         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1622 
1623         // Clear approvals from the previous owner
1624         delete _tokenApprovals[tokenId];
1625 
1626         unchecked {
1627             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1628             // `from`'s balance is the number of token held, which is at least one before the current
1629             // transfer.
1630             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1631             // all 2**256 token ids to be minted, which in practice is impossible.
1632             _balances[from] -= 1;
1633             _balances[to] += 1;
1634         }
1635         _owners[tokenId] = to;
1636 
1637         emit Transfer(from, to, tokenId);
1638 
1639         _afterTokenTransfer(from, to, tokenId, 1);
1640     }
1641 
1642     /**
1643      * @dev Approve `to` to operate on `tokenId`
1644      *
1645      * Emits an {Approval} event.
1646      */
1647     function _approve(address to, uint256 tokenId) internal virtual {
1648         _tokenApprovals[tokenId] = to;
1649         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1650     }
1651 
1652     /**
1653      * @dev Approve `operator` to operate on all of `owner` tokens
1654      *
1655      * Emits an {ApprovalForAll} event.
1656      */
1657     function _setApprovalForAll(
1658         address owner,
1659         address operator,
1660         bool approved
1661     ) internal virtual {
1662         require(owner != operator, "ERC721: approve to caller");
1663         _operatorApprovals[owner][operator] = approved;
1664         emit ApprovalForAll(owner, operator, approved);
1665     }
1666 
1667     /**
1668      * @dev Reverts if the `tokenId` has not been minted yet.
1669      */
1670     function _requireMinted(uint256 tokenId) internal view virtual {
1671         require(_exists(tokenId), "ERC721: invalid token ID");
1672     }
1673 
1674     /**
1675      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1676      * The call is not executed if the target address is not a contract.
1677      *
1678      * @param from address representing the previous owner of the given token ID
1679      * @param to target address that will receive the tokens
1680      * @param tokenId uint256 ID of the token to be transferred
1681      * @param data bytes optional data to send along with the call
1682      * @return bool whether the call correctly returned the expected magic value
1683      */
1684     function _checkOnERC721Received(
1685         address from,
1686         address to,
1687         uint256 tokenId,
1688         bytes memory data
1689     ) private returns (bool) {
1690         if (to.isContract()) {
1691             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1692                 return retval == IERC721Receiver.onERC721Received.selector;
1693             } catch (bytes memory reason) {
1694                 if (reason.length == 0) {
1695                     revert("ERC721: transfer to non ERC721Receiver implementer");
1696                 } else {
1697                     /// @solidity memory-safe-assembly
1698                     assembly {
1699                         revert(add(32, reason), mload(reason))
1700                     }
1701                 }
1702             }
1703         } else {
1704             return true;
1705         }
1706     }
1707 
1708     /**
1709      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1710      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1711      *
1712      * Calling conditions:
1713      *
1714      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1715      * - When `from` is zero, the tokens will be minted for `to`.
1716      * - When `to` is zero, ``from``'s tokens will be burned.
1717      * - `from` and `to` are never both zero.
1718      * - `batchSize` is non-zero.
1719      *
1720      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1721      */
1722     function _beforeTokenTransfer(
1723         address from,
1724         address to,
1725         uint256, /* firstTokenId */
1726         uint256 batchSize
1727     ) internal virtual {
1728         if (batchSize > 1) {
1729             if (from != address(0)) {
1730                 _balances[from] -= batchSize;
1731             }
1732             if (to != address(0)) {
1733                 _balances[to] += batchSize;
1734             }
1735         }
1736     }
1737 
1738     /**
1739      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1740      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1741      *
1742      * Calling conditions:
1743      *
1744      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1745      * - When `from` is zero, the tokens were minted for `to`.
1746      * - When `to` is zero, ``from``'s tokens were burned.
1747      * - `from` and `to` are never both zero.
1748      * - `batchSize` is non-zero.
1749      *
1750      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1751      */
1752     function _afterTokenTransfer(
1753         address from,
1754         address to,
1755         uint256 firstTokenId,
1756         uint256 batchSize
1757     ) internal virtual {}
1758 }
1759 
1760 
1761 
1762 interface IERC20 {
1763 
1764     function decimals() external view returns (uint8);
1765 
1766 
1767     function transfer(address to, uint256 amount) external returns (bool);
1768 
1769     function transferFrom(
1770         address from,
1771         address to,
1772         uint256 amount
1773     ) external returns (bool);
1774 }
1775 
1776 interface IERC20USDT {
1777 
1778     function transferFrom(address from, address to, uint value) external;
1779     function transfer(address to, uint value) external;
1780 }
1781 
1782 contract YGME is ERC721, Ownable {
1783     using Counters for Counters.Counter;
1784     using SafeMath for uint256;
1785 
1786     Counters.Counter  _tokenIdCounter;
1787 
1788     uint256  MAX = 30000;
1789 
1790     uint256 public PAY = 300000000;
1791 
1792     uint256 public MinMax = 20;
1793 
1794     mapping(address => bool) public isWhite;
1795 
1796     mapping(address => address) public recommender;
1797 
1798     uint256 public maxLevel = 3;
1799     mapping(uint256 => uint256) public rewardLevelAmount;
1800 
1801     address  receicve_address_first;
1802     uint256  receicve_amount_first;
1803 
1804     address  receicve_address_second;
1805     uint256  receicve_amount_second;
1806 
1807 
1808     bool public start = true;
1809 
1810 
1811     bool lock;
1812 
1813     IERC20USDT payCon;
1814 
1815     IERC20 rewardCon;
1816 
1817     string public baseUri; 
1818     string public orgUri; 
1819 
1820     constructor(address pay, address reward) ERC721("YGME", "YGME") {
1821         
1822         payCon = IERC20USDT(pay);
1823         
1824         rewardCon = IERC20(reward);
1825 
1826         _tokenIdCounter.reset();
1827     }
1828 
1829     function _baseURI() internal view override returns (string memory) {
1830         return baseUri;
1831     }
1832 
1833     function _orgURI() internal view override returns (string memory) {
1834         return orgUri;
1835     }
1836 
1837     function setBaseURI(string calldata _baseUri) external  onlyOwner  {
1838         baseUri = _baseUri;
1839     }
1840 
1841     function setOrgURI(string calldata _orgUri) external  onlyOwner  {
1842         orgUri = _orgUri;
1843     }
1844 
1845     function swap(address to, address _recommender, uint mintNum) external onlyWhiter mintMax(mintNum) isLock {
1846         
1847         if(recommender[to] == address(0)){
1848            recommender[to] = _recommender;
1849         }
1850         
1851         for(uint i = 0; i < mintNum; i++){
1852             _safeMint(to);
1853         }
1854 
1855     }
1856 
1857 
1858     function safeMint(address _recommender, uint mintNum) external checkRecommender(_recommender) mintMax(mintNum) isLock{
1859         require(start, "no start");
1860         address from = _msgSender();
1861         address self = address(this);
1862         
1863         payCon.transferFrom(from, self, PAY.mul(mintNum));
1864         distribute(mintNum);
1865 
1866         for(uint i = 0; i < mintNum; i++){
1867             _safeMint(from);
1868         }
1869       
1870         _rewardMint(from, mintNum);
1871 
1872     }
1873 
1874 
1875     function setPay(uint256 pay) external onlyOwner  {
1876         if(PAY != pay){
1877             PAY =  pay;
1878         }
1879     }
1880 
1881 
1882     function setStart() external onlyOwner  {
1883         start = !start;
1884     }
1885 
1886 
1887     function setWhite(address _white) external  onlyOwner  {
1888         isWhite[_white] = !isWhite[_white];
1889     }
1890 
1891 
1892     function setMaxMint(uint256 max) external onlyOwner  {
1893         if(MinMax != max){
1894             MinMax = max;
1895         }
1896     }
1897 
1898     function setMaxLevel(uint256 max) external onlyOwner  {
1899         if(max != maxLevel){
1900             maxLevel = max;
1901         }
1902     }
1903 
1904 
1905     function setLevelAmount(uint level, uint amount) external  onlyOwner  {
1906         require(level <= maxLevel, "level invalid");
1907         if(rewardLevelAmount[level] != amount){
1908             rewardLevelAmount[level] = amount;
1909         }
1910     }
1911 
1912 
1913     function setReceiveFirst(address first, uint amount) external  onlyOwner  {
1914         receicve_address_first = first;
1915         receicve_amount_first = amount;
1916     }
1917 
1918 
1919     function setReceiveSecond(address second, uint amount) external  onlyOwner {
1920         receicve_address_second = second;
1921         receicve_amount_second = amount;
1922     }
1923 
1924     function withdrawPay(address addr, uint256 amount) external  onlyOwner {
1925         payCon.transfer(addr, amount);
1926     }
1927 
1928     function withdrawRewar(address addr, uint256 amount) external  onlyOwner {
1929         rewardCon.transfer(addr, amount);
1930     }
1931 
1932     function getReceiveFirst() external view onlyOwner returns(address, uint256) {
1933         return (receicve_address_first, receicve_amount_first);
1934     }
1935 
1936     function getReceiveSecond() external view onlyOwner returns(address, uint256){
1937         return (receicve_address_second, receicve_amount_second);
1938     }
1939 
1940     function distribute(uint mintNum) private {
1941         address zero = address(0);
1942         if(receicve_address_first != zero && 0 != receicve_amount_first){
1943             payCon.transfer(receicve_address_first, receicve_amount_first.mul(mintNum));
1944         }
1945 
1946         if(receicve_address_second != zero && 0 != receicve_amount_second){
1947             payCon.transfer(receicve_address_second, receicve_amount_second.mul(mintNum));
1948         }
1949     }
1950 
1951 
1952 
1953     function _safeMint(address to) private {
1954         uint256 tokenId = _tokenIdCounter.current();
1955         _tokenIdCounter.increment();
1956         _safeMint(to, tokenId);
1957     }
1958 
1959 
1960 
1961     function _rewardMint(address to, uint mintNum) private {
1962        
1963        address rewward;
1964        address zero = address(0);
1965        for (uint i = 0; i <= maxLevel; i++){
1966            if(0 == i){
1967                rewward = to;
1968            }else{
1969                rewward = recommender[rewward];
1970            }
1971          
1972            if(rewward != zero && 0 != rewardLevelAmount[i]){
1973                rewardCon.transfer(rewward, rewardLevelAmount[i].mul(mintNum));
1974            }
1975            
1976        }
1977         
1978     }
1979 
1980 
1981 
1982     modifier onlyWhiter {
1983 
1984         address sender = _msgSender();
1985         
1986         require(isWhite[sender] || sender == owner(), "not whiter");
1987 
1988         _;
1989 
1990     }
1991 
1992 
1993     modifier checkRecommender(address _recommender) {
1994         require(_recommender != address(0), "recommender can not be zero");
1995         require(_recommender != msg.sender, "recommender can not be self");
1996         require(0 < balanceOf(_recommender), "invalid recommender");
1997         
1998         if(recommender[msg.sender] == address(0)){
1999             recommender[msg.sender] = _recommender;
2000         }else{
2001             require(recommender[msg.sender] == _recommender, "recommender is different");
2002         }
2003 
2004         _;
2005 
2006     }
2007 
2008 
2009 
2010     modifier isLock {
2011         
2012         require(!lock, "wait for other to mint ");
2013         lock = true;
2014         _;
2015         lock = false;
2016 
2017     }
2018 
2019 
2020     modifier mintMax(uint mintNum) {
2021         require(0 < mintNum && mintNum <= MinMax, "mintNum invalid");
2022         require(MAX >= _tokenIdCounter.current() + mintNum - 1, "already minted token of max");
2023         _;
2024 
2025     }
2026 
2027 }