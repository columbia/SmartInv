1 // File: contracts/IERC20.sol
2 
3 
4 pragma solidity >= 0.8.13;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address account) external view returns (uint256);
13 
14     function transfer(address recipient, uint256 amount) external returns (bool);
15 
16     function allowance(address owner, address spender) external view returns (uint256);
17 
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 // File: contracts/Merkle.sol
27 
28 
29 pragma solidity >= 0.8.13;
30 
31 /**
32  * @dev These functions deal with verification of Merkle trees (hash trees),
33  */
34 library MerkleProof {
35     /**
36      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
37      * defined by `root`. For this, a `proof` must be provided, containing
38      * sibling hashes on the branch from the leaf to the root of the tree. Each
39      * pair of leaves and each pair of pre-images are assumed to be sorted.
40      */
41     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
42         bytes32 computedHash = leaf;
43 
44         for (uint256 i = 0; i < proof.length; i++) {
45             bytes32 proofElement = proof[i];
46 
47             if (computedHash <= proofElement) {
48                 // Hash(current computed hash + current element of the proof)
49                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
50             } else {
51                 // Hash(current element of the proof + current computed hash)
52                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
53             }
54         }
55 
56         // Check if the computed hash (root) is equal to the provided root
57         return computedHash == root;
58     }
59 }
60 
61 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
62 
63 
64 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 // CAUTION
69 // This version of SafeMath should only be used with Solidity 0.8 or later,
70 // because it relies on the compiler's built in overflow checks.
71 
72 /**
73  * @dev Wrappers over Solidity's arithmetic operations.
74  *
75  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
76  * now has built in overflow checking.
77  */
78 library SafeMath {
79     /**
80      * @dev Returns the addition of two unsigned integers, with an overflow flag.
81      *
82      * _Available since v3.4._
83      */
84     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
85         unchecked {
86             uint256 c = a + b;
87             if (c < a) return (false, 0);
88             return (true, c);
89         }
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
94      *
95      * _Available since v3.4._
96      */
97     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
98         unchecked {
99             if (b > a) return (false, 0);
100             return (true, a - b);
101         }
102     }
103 
104     /**
105      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
112             // benefit is lost if 'b' is also tested.
113             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
114             if (a == 0) return (true, 0);
115             uint256 c = a * b;
116             if (c / a != b) return (false, 0);
117             return (true, c);
118         }
119     }
120 
121     /**
122      * @dev Returns the division of two unsigned integers, with a division by zero flag.
123      *
124      * _Available since v3.4._
125      */
126     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         unchecked {
128             if (b == 0) return (false, 0);
129             return (true, a / b);
130         }
131     }
132 
133     /**
134      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         unchecked {
140             if (b == 0) return (false, 0);
141             return (true, a % b);
142         }
143     }
144 
145     /**
146      * @dev Returns the addition of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `+` operator.
150      *
151      * Requirements:
152      *
153      * - Addition cannot overflow.
154      */
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a + b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         return a - b;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      *
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a * b;
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers, reverting on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator.
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return a / b;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * reverting when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return a % b;
215     }
216 
217     /**
218      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
219      * overflow (when the result is negative).
220      *
221      * CAUTION: This function is deprecated because it requires allocating memory for the error
222      * message unnecessarily. For custom revert reasons use {trySub}.
223      *
224      * Counterpart to Solidity's `-` operator.
225      *
226      * Requirements:
227      *
228      * - Subtraction cannot overflow.
229      */
230     function sub(
231         uint256 a,
232         uint256 b,
233         string memory errorMessage
234     ) internal pure returns (uint256) {
235         unchecked {
236             require(b <= a, errorMessage);
237             return a - b;
238         }
239     }
240 
241     /**
242      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
243      * division by zero. The result is rounded towards zero.
244      *
245      * Counterpart to Solidity's `/` operator. Note: this function uses a
246      * `revert` opcode (which leaves remaining gas untouched) while Solidity
247      * uses an invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function div(
254         uint256 a,
255         uint256 b,
256         string memory errorMessage
257     ) internal pure returns (uint256) {
258         unchecked {
259             require(b > 0, errorMessage);
260             return a / b;
261         }
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * reverting with custom message when dividing by zero.
267      *
268      * CAUTION: This function is deprecated because it requires allocating memory for the error
269      * message unnecessarily. For custom revert reasons use {tryMod}.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(
280         uint256 a,
281         uint256 b,
282         string memory errorMessage
283     ) internal pure returns (uint256) {
284         unchecked {
285             require(b > 0, errorMessage);
286             return a % b;
287         }
288     }
289 }
290 
291 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @dev Interface of the ERC165 standard, as defined in the
300  * https://eips.ethereum.org/EIPS/eip-165[EIP].
301  *
302  * Implementers can declare support of contract interfaces, which can then be
303  * queried by others ({ERC165Checker}).
304  *
305  * For an implementation, see {ERC165}.
306  */
307 interface IERC165 {
308     /**
309      * @dev Returns true if this contract implements the interface defined by
310      * `interfaceId`. See the corresponding
311      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
312      * to learn more about how these ids are created.
313      *
314      * This function call must use less than 30 000 gas.
315      */
316     function supportsInterface(bytes4 interfaceId) external view returns (bool);
317 }
318 
319 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
320 
321 
322 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 
327 /**
328  * @dev Implementation of the {IERC165} interface.
329  *
330  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
331  * for the additional interface id that will be supported. For example:
332  *
333  * ```solidity
334  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
335  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
336  * }
337  * ```
338  *
339  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
340  */
341 abstract contract ERC165 is IERC165 {
342     /**
343      * @dev See {IERC165-supportsInterface}.
344      */
345     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
346         return interfaceId == type(IERC165).interfaceId;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/utils/math/Math.sol
351 
352 
353 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @dev Standard math utilities missing in the Solidity language.
359  */
360 library Math {
361     enum Rounding {
362         Down, // Toward negative infinity
363         Up, // Toward infinity
364         Zero // Toward zero
365     }
366 
367     /**
368      * @dev Returns the largest of two numbers.
369      */
370     function max(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a > b ? a : b;
372     }
373 
374     /**
375      * @dev Returns the smallest of two numbers.
376      */
377     function min(uint256 a, uint256 b) internal pure returns (uint256) {
378         return a < b ? a : b;
379     }
380 
381     /**
382      * @dev Returns the average of two numbers. The result is rounded towards
383      * zero.
384      */
385     function average(uint256 a, uint256 b) internal pure returns (uint256) {
386         // (a + b) / 2 can overflow.
387         return (a & b) + (a ^ b) / 2;
388     }
389 
390     /**
391      * @dev Returns the ceiling of the division of two numbers.
392      *
393      * This differs from standard division with `/` in that it rounds up instead
394      * of rounding down.
395      */
396     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
397         // (a + b - 1) / b can overflow on addition, so we distribute.
398         return a == 0 ? 0 : (a - 1) / b + 1;
399     }
400 
401     /**
402      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
403      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
404      * with further edits by Uniswap Labs also under MIT license.
405      */
406     function mulDiv(
407         uint256 x,
408         uint256 y,
409         uint256 denominator
410     ) internal pure returns (uint256 result) {
411         unchecked {
412             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
413             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
414             // variables such that product = prod1 * 2^256 + prod0.
415             uint256 prod0; // Least significant 256 bits of the product
416             uint256 prod1; // Most significant 256 bits of the product
417             assembly {
418                 let mm := mulmod(x, y, not(0))
419                 prod0 := mul(x, y)
420                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
421             }
422 
423             // Handle non-overflow cases, 256 by 256 division.
424             if (prod1 == 0) {
425                 return prod0 / denominator;
426             }
427 
428             // Make sure the result is less than 2^256. Also prevents denominator == 0.
429             require(denominator > prod1);
430 
431             ///////////////////////////////////////////////
432             // 512 by 256 division.
433             ///////////////////////////////////////////////
434 
435             // Make division exact by subtracting the remainder from [prod1 prod0].
436             uint256 remainder;
437             assembly {
438                 // Compute remainder using mulmod.
439                 remainder := mulmod(x, y, denominator)
440 
441                 // Subtract 256 bit number from 512 bit number.
442                 prod1 := sub(prod1, gt(remainder, prod0))
443                 prod0 := sub(prod0, remainder)
444             }
445 
446             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
447             // See https://cs.stackexchange.com/q/138556/92363.
448 
449             // Does not overflow because the denominator cannot be zero at this stage in the function.
450             uint256 twos = denominator & (~denominator + 1);
451             assembly {
452                 // Divide denominator by twos.
453                 denominator := div(denominator, twos)
454 
455                 // Divide [prod1 prod0] by twos.
456                 prod0 := div(prod0, twos)
457 
458                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
459                 twos := add(div(sub(0, twos), twos), 1)
460             }
461 
462             // Shift in bits from prod1 into prod0.
463             prod0 |= prod1 * twos;
464 
465             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
466             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
467             // four bits. That is, denominator * inv = 1 mod 2^4.
468             uint256 inverse = (3 * denominator) ^ 2;
469 
470             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
471             // in modular arithmetic, doubling the correct bits in each step.
472             inverse *= 2 - denominator * inverse; // inverse mod 2^8
473             inverse *= 2 - denominator * inverse; // inverse mod 2^16
474             inverse *= 2 - denominator * inverse; // inverse mod 2^32
475             inverse *= 2 - denominator * inverse; // inverse mod 2^64
476             inverse *= 2 - denominator * inverse; // inverse mod 2^128
477             inverse *= 2 - denominator * inverse; // inverse mod 2^256
478 
479             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
480             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
481             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
482             // is no longer required.
483             result = prod0 * inverse;
484             return result;
485         }
486     }
487 
488     /**
489      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
490      */
491     function mulDiv(
492         uint256 x,
493         uint256 y,
494         uint256 denominator,
495         Rounding rounding
496     ) internal pure returns (uint256) {
497         uint256 result = mulDiv(x, y, denominator);
498         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
499             result += 1;
500         }
501         return result;
502     }
503 
504     /**
505      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
506      *
507      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
508      */
509     function sqrt(uint256 a) internal pure returns (uint256) {
510         if (a == 0) {
511             return 0;
512         }
513 
514         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
515         //
516         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
517         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
518         //
519         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
520         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
521         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
522         //
523         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
524         uint256 result = 1 << (log2(a) >> 1);
525 
526         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
527         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
528         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
529         // into the expected uint128 result.
530         unchecked {
531             result = (result + a / result) >> 1;
532             result = (result + a / result) >> 1;
533             result = (result + a / result) >> 1;
534             result = (result + a / result) >> 1;
535             result = (result + a / result) >> 1;
536             result = (result + a / result) >> 1;
537             result = (result + a / result) >> 1;
538             return min(result, a / result);
539         }
540     }
541 
542     /**
543      * @notice Calculates sqrt(a), following the selected rounding direction.
544      */
545     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
546         unchecked {
547             uint256 result = sqrt(a);
548             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
549         }
550     }
551 
552     /**
553      * @dev Return the log in base 2, rounded down, of a positive value.
554      * Returns 0 if given 0.
555      */
556     function log2(uint256 value) internal pure returns (uint256) {
557         uint256 result = 0;
558         unchecked {
559             if (value >> 128 > 0) {
560                 value >>= 128;
561                 result += 128;
562             }
563             if (value >> 64 > 0) {
564                 value >>= 64;
565                 result += 64;
566             }
567             if (value >> 32 > 0) {
568                 value >>= 32;
569                 result += 32;
570             }
571             if (value >> 16 > 0) {
572                 value >>= 16;
573                 result += 16;
574             }
575             if (value >> 8 > 0) {
576                 value >>= 8;
577                 result += 8;
578             }
579             if (value >> 4 > 0) {
580                 value >>= 4;
581                 result += 4;
582             }
583             if (value >> 2 > 0) {
584                 value >>= 2;
585                 result += 2;
586             }
587             if (value >> 1 > 0) {
588                 result += 1;
589             }
590         }
591         return result;
592     }
593 
594     /**
595      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
596      * Returns 0 if given 0.
597      */
598     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
599         unchecked {
600             uint256 result = log2(value);
601             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
602         }
603     }
604 
605     /**
606      * @dev Return the log in base 10, rounded down, of a positive value.
607      * Returns 0 if given 0.
608      */
609     function log10(uint256 value) internal pure returns (uint256) {
610         uint256 result = 0;
611         unchecked {
612             if (value >= 10**64) {
613                 value /= 10**64;
614                 result += 64;
615             }
616             if (value >= 10**32) {
617                 value /= 10**32;
618                 result += 32;
619             }
620             if (value >= 10**16) {
621                 value /= 10**16;
622                 result += 16;
623             }
624             if (value >= 10**8) {
625                 value /= 10**8;
626                 result += 8;
627             }
628             if (value >= 10**4) {
629                 value /= 10**4;
630                 result += 4;
631             }
632             if (value >= 10**2) {
633                 value /= 10**2;
634                 result += 2;
635             }
636             if (value >= 10**1) {
637                 result += 1;
638             }
639         }
640         return result;
641     }
642 
643     /**
644      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
645      * Returns 0 if given 0.
646      */
647     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
648         unchecked {
649             uint256 result = log10(value);
650             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
651         }
652     }
653 
654     /**
655      * @dev Return the log in base 256, rounded down, of a positive value.
656      * Returns 0 if given 0.
657      *
658      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
659      */
660     function log256(uint256 value) internal pure returns (uint256) {
661         uint256 result = 0;
662         unchecked {
663             if (value >> 128 > 0) {
664                 value >>= 128;
665                 result += 16;
666             }
667             if (value >> 64 > 0) {
668                 value >>= 64;
669                 result += 8;
670             }
671             if (value >> 32 > 0) {
672                 value >>= 32;
673                 result += 4;
674             }
675             if (value >> 16 > 0) {
676                 value >>= 16;
677                 result += 2;
678             }
679             if (value >> 8 > 0) {
680                 result += 1;
681             }
682         }
683         return result;
684     }
685 
686     /**
687      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
688      * Returns 0 if given 0.
689      */
690     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
691         unchecked {
692             uint256 result = log256(value);
693             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
694         }
695     }
696 }
697 
698 // File: @openzeppelin/contracts/utils/Strings.sol
699 
700 
701 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @dev String operations.
708  */
709 library Strings {
710     bytes16 private constant _SYMBOLS = "0123456789abcdef";
711     uint8 private constant _ADDRESS_LENGTH = 20;
712 
713     /**
714      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
715      */
716     function toString(uint256 value) internal pure returns (string memory) {
717         unchecked {
718             uint256 length = Math.log10(value) + 1;
719             string memory buffer = new string(length);
720             uint256 ptr;
721             /// @solidity memory-safe-assembly
722             assembly {
723                 ptr := add(buffer, add(32, length))
724             }
725             while (true) {
726                 ptr--;
727                 /// @solidity memory-safe-assembly
728                 assembly {
729                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
730                 }
731                 value /= 10;
732                 if (value == 0) break;
733             }
734             return buffer;
735         }
736     }
737 
738     /**
739      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
740      */
741     function toHexString(uint256 value) internal pure returns (string memory) {
742         unchecked {
743             return toHexString(value, Math.log256(value) + 1);
744         }
745     }
746 
747     /**
748      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
749      */
750     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
751         bytes memory buffer = new bytes(2 * length + 2);
752         buffer[0] = "0";
753         buffer[1] = "x";
754         for (uint256 i = 2 * length + 1; i > 1; --i) {
755             buffer[i] = _SYMBOLS[value & 0xf];
756             value >>= 4;
757         }
758         require(value == 0, "Strings: hex length insufficient");
759         return string(buffer);
760     }
761 
762     /**
763      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
764      */
765     function toHexString(address addr) internal pure returns (string memory) {
766         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
767     }
768 }
769 
770 // File: @openzeppelin/contracts/utils/Context.sol
771 
772 
773 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
774 
775 pragma solidity ^0.8.0;
776 
777 /**
778  * @dev Provides information about the current execution context, including the
779  * sender of the transaction and its data. While these are generally available
780  * via msg.sender and msg.data, they should not be accessed in such a direct
781  * manner, since when dealing with meta-transactions the account sending and
782  * paying for execution may not be the actual sender (as far as an application
783  * is concerned).
784  *
785  * This contract is only required for intermediate, library-like contracts.
786  */
787 abstract contract Context {
788     function _msgSender() internal view virtual returns (address) {
789         return msg.sender;
790     }
791 
792     function _msgData() internal view virtual returns (bytes calldata) {
793         return msg.data;
794     }
795 }
796 
797 // File: @openzeppelin/contracts/access/IAccessControl.sol
798 
799 
800 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
801 
802 pragma solidity ^0.8.0;
803 
804 /**
805  * @dev External interface of AccessControl declared to support ERC165 detection.
806  */
807 interface IAccessControl {
808     /**
809      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
810      *
811      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
812      * {RoleAdminChanged} not being emitted signaling this.
813      *
814      * _Available since v3.1._
815      */
816     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
817 
818     /**
819      * @dev Emitted when `account` is granted `role`.
820      *
821      * `sender` is the account that originated the contract call, an admin role
822      * bearer except when using {AccessControl-_setupRole}.
823      */
824     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
825 
826     /**
827      * @dev Emitted when `account` is revoked `role`.
828      *
829      * `sender` is the account that originated the contract call:
830      *   - if using `revokeRole`, it is the admin role bearer
831      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
832      */
833     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
834 
835     /**
836      * @dev Returns `true` if `account` has been granted `role`.
837      */
838     function hasRole(bytes32 role, address account) external view returns (bool);
839 
840     /**
841      * @dev Returns the admin role that controls `role`. See {grantRole} and
842      * {revokeRole}.
843      *
844      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
845      */
846     function getRoleAdmin(bytes32 role) external view returns (bytes32);
847 
848     /**
849      * @dev Grants `role` to `account`.
850      *
851      * If `account` had not been already granted `role`, emits a {RoleGranted}
852      * event.
853      *
854      * Requirements:
855      *
856      * - the caller must have ``role``'s admin role.
857      */
858     function grantRole(bytes32 role, address account) external;
859 
860     /**
861      * @dev Revokes `role` from `account`.
862      *
863      * If `account` had been granted `role`, emits a {RoleRevoked} event.
864      *
865      * Requirements:
866      *
867      * - the caller must have ``role``'s admin role.
868      */
869     function revokeRole(bytes32 role, address account) external;
870 
871     /**
872      * @dev Revokes `role` from the calling account.
873      *
874      * Roles are often managed via {grantRole} and {revokeRole}: this function's
875      * purpose is to provide a mechanism for accounts to lose their privileges
876      * if they are compromised (such as when a trusted device is misplaced).
877      *
878      * If the calling account had been granted `role`, emits a {RoleRevoked}
879      * event.
880      *
881      * Requirements:
882      *
883      * - the caller must be `account`.
884      */
885     function renounceRole(bytes32 role, address account) external;
886 }
887 
888 // File: @openzeppelin/contracts/access/AccessControl.sol
889 
890 
891 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 
896 
897 
898 
899 /**
900  * @dev Contract module that allows children to implement role-based access
901  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
902  * members except through off-chain means by accessing the contract event logs. Some
903  * applications may benefit from on-chain enumerability, for those cases see
904  * {AccessControlEnumerable}.
905  *
906  * Roles are referred to by their `bytes32` identifier. These should be exposed
907  * in the external API and be unique. The best way to achieve this is by
908  * using `public constant` hash digests:
909  *
910  * ```
911  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
912  * ```
913  *
914  * Roles can be used to represent a set of permissions. To restrict access to a
915  * function call, use {hasRole}:
916  *
917  * ```
918  * function foo() public {
919  *     require(hasRole(MY_ROLE, msg.sender));
920  *     ...
921  * }
922  * ```
923  *
924  * Roles can be granted and revoked dynamically via the {grantRole} and
925  * {revokeRole} functions. Each role has an associated admin role, and only
926  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
927  *
928  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
929  * that only accounts with this role will be able to grant or revoke other
930  * roles. More complex role relationships can be created by using
931  * {_setRoleAdmin}.
932  *
933  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
934  * grant and revoke this role. Extra precautions should be taken to secure
935  * accounts that have been granted it.
936  */
937 abstract contract AccessControl is Context, IAccessControl, ERC165 {
938     struct RoleData {
939         mapping(address => bool) members;
940         bytes32 adminRole;
941     }
942 
943     mapping(bytes32 => RoleData) private _roles;
944 
945     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
946 
947     /**
948      * @dev Modifier that checks that an account has a specific role. Reverts
949      * with a standardized message including the required role.
950      *
951      * The format of the revert reason is given by the following regular expression:
952      *
953      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
954      *
955      * _Available since v4.1._
956      */
957     modifier onlyRole(bytes32 role) {
958         _checkRole(role);
959         _;
960     }
961 
962     /**
963      * @dev See {IERC165-supportsInterface}.
964      */
965     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
966         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
967     }
968 
969     /**
970      * @dev Returns `true` if `account` has been granted `role`.
971      */
972     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
973         return _roles[role].members[account];
974     }
975 
976     /**
977      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
978      * Overriding this function changes the behavior of the {onlyRole} modifier.
979      *
980      * Format of the revert message is described in {_checkRole}.
981      *
982      * _Available since v4.6._
983      */
984     function _checkRole(bytes32 role) internal view virtual {
985         _checkRole(role, _msgSender());
986     }
987 
988     /**
989      * @dev Revert with a standard message if `account` is missing `role`.
990      *
991      * The format of the revert reason is given by the following regular expression:
992      *
993      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
994      */
995     function _checkRole(bytes32 role, address account) internal view virtual {
996         if (!hasRole(role, account)) {
997             revert(
998                 string(
999                     abi.encodePacked(
1000                         "AccessControl: account ",
1001                         Strings.toHexString(account),
1002                         " is missing role ",
1003                         Strings.toHexString(uint256(role), 32)
1004                     )
1005                 )
1006             );
1007         }
1008     }
1009 
1010     /**
1011      * @dev Returns the admin role that controls `role`. See {grantRole} and
1012      * {revokeRole}.
1013      *
1014      * To change a role's admin, use {_setRoleAdmin}.
1015      */
1016     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1017         return _roles[role].adminRole;
1018     }
1019 
1020     /**
1021      * @dev Grants `role` to `account`.
1022      *
1023      * If `account` had not been already granted `role`, emits a {RoleGranted}
1024      * event.
1025      *
1026      * Requirements:
1027      *
1028      * - the caller must have ``role``'s admin role.
1029      *
1030      * May emit a {RoleGranted} event.
1031      */
1032     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1033         _grantRole(role, account);
1034     }
1035 
1036     /**
1037      * @dev Revokes `role` from `account`.
1038      *
1039      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1040      *
1041      * Requirements:
1042      *
1043      * - the caller must have ``role``'s admin role.
1044      *
1045      * May emit a {RoleRevoked} event.
1046      */
1047     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1048         _revokeRole(role, account);
1049     }
1050 
1051     /**
1052      * @dev Revokes `role` from the calling account.
1053      *
1054      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1055      * purpose is to provide a mechanism for accounts to lose their privileges
1056      * if they are compromised (such as when a trusted device is misplaced).
1057      *
1058      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1059      * event.
1060      *
1061      * Requirements:
1062      *
1063      * - the caller must be `account`.
1064      *
1065      * May emit a {RoleRevoked} event.
1066      */
1067     function renounceRole(bytes32 role, address account) public virtual override {
1068         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1069 
1070         _revokeRole(role, account);
1071     }
1072 
1073     /**
1074      * @dev Grants `role` to `account`.
1075      *
1076      * If `account` had not been already granted `role`, emits a {RoleGranted}
1077      * event. Note that unlike {grantRole}, this function doesn't perform any
1078      * checks on the calling account.
1079      *
1080      * May emit a {RoleGranted} event.
1081      *
1082      * [WARNING]
1083      * ====
1084      * This function should only be called from the constructor when setting
1085      * up the initial roles for the system.
1086      *
1087      * Using this function in any other way is effectively circumventing the admin
1088      * system imposed by {AccessControl}.
1089      * ====
1090      *
1091      * NOTE: This function is deprecated in favor of {_grantRole}.
1092      */
1093     function _setupRole(bytes32 role, address account) internal virtual {
1094         _grantRole(role, account);
1095     }
1096 
1097     /**
1098      * @dev Sets `adminRole` as ``role``'s admin role.
1099      *
1100      * Emits a {RoleAdminChanged} event.
1101      */
1102     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1103         bytes32 previousAdminRole = getRoleAdmin(role);
1104         _roles[role].adminRole = adminRole;
1105         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1106     }
1107 
1108     /**
1109      * @dev Grants `role` to `account`.
1110      *
1111      * Internal function without access restriction.
1112      *
1113      * May emit a {RoleGranted} event.
1114      */
1115     function _grantRole(bytes32 role, address account) internal virtual {
1116         if (!hasRole(role, account)) {
1117             _roles[role].members[account] = true;
1118             emit RoleGranted(role, account, _msgSender());
1119         }
1120     }
1121 
1122     /**
1123      * @dev Revokes `role` from `account`.
1124      *
1125      * Internal function without access restriction.
1126      *
1127      * May emit a {RoleRevoked} event.
1128      */
1129     function _revokeRole(bytes32 role, address account) internal virtual {
1130         if (hasRole(role, account)) {
1131             _roles[role].members[account] = false;
1132             emit RoleRevoked(role, account, _msgSender());
1133         }
1134     }
1135 }
1136 
1137 // File: contracts/AirdropDistributor.sol
1138 
1139 
1140 pragma solidity >= 0.8.13;
1141 
1142 
1143 
1144 
1145 
1146 contract AirdropDistributor is AccessControl {
1147     using SafeMath for uint256;
1148 
1149     address public ownerToken;
1150     bool public isAirdrop;
1151     uint8 public decimals;
1152     address public ownerWallet;
1153     address public contributeAddress;
1154     address public burnAddress;
1155     uint256 public minimumToken;
1156     bytes32 public merkleRoot = 0x185e5066001c6944cad12d792d7c057fe4971592a66690d35a5d6d5b000878b8;
1157     mapping(address => bool) claimMarker;
1158 
1159     event Claimed(address account, uint256 amount);
1160 
1161     constructor(address token, uint8 decimal, address wallet, address burn, address contribute) {
1162         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1163         isAirdrop = false;
1164         ownerToken = token;
1165         decimals = decimal;
1166         ownerWallet = wallet;
1167         contributeAddress = contribute;
1168         burnAddress = burn;
1169     }
1170 
1171     function setContributeWallet(address wallet) external onlyRole(DEFAULT_ADMIN_ROLE) {
1172         contributeAddress = wallet;
1173     }
1174 
1175     function setMinimumTokenHold(uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
1176         minimumToken = amount * 10 ** decimals;
1177     }
1178 
1179     function setOwnerWallet(address wallet) external onlyRole(DEFAULT_ADMIN_ROLE) {
1180         ownerWallet = wallet;
1181     }
1182 
1183     function changeMerkleRoot(bytes32 root) external onlyRole(DEFAULT_ADMIN_ROLE) {
1184         merkleRoot = root;
1185     }
1186 
1187     function setWalletReceived(address wallet) external onlyRole(DEFAULT_ADMIN_ROLE) {
1188         claimMarker[wallet] = false;
1189     }
1190 
1191     function getWalletStatus(address wallet) public view returns (bool) {
1192         return claimMarker[wallet];
1193     }
1194 
1195     function setAirdropStatus(bool status) external onlyRole(DEFAULT_ADMIN_ROLE) {
1196         isAirdrop = status;
1197     }
1198 
1199     function claim(uint256 claimAmount, uint256 burnAmount, uint256 contributeAmount, bytes32[] calldata merkleProof) external {
1200         uint256 amountReward = uint256(0);
1201         require(isAirdrop, 'MerkleDistributor: Airdrop event not start.');
1202         require(!claimMarker[msg.sender], 'MerkleDistributor: Drop already claimed.');
1203         require(ownerToken != address(0), 'MerkleDistributor: Owner token not config');
1204         require(claimAmount >= 0, 'MerkleDistributor: Claim Amount  not negative');
1205         require(burnAmount >= 0, 'MerkleDistributor: Burn Amount larger than zero');
1206         require(contributeAmount >= 0, 'MerkleDistributor: Contribute Amount not negative');
1207 
1208         require(IERC20(ownerToken).balanceOf(msg.sender) >= minimumToken, 'MerkleDistributor: You must behold requirement balance.');
1209 
1210         amountReward = amountReward.add(claimAmount).add(burnAmount).add(contributeAmount);
1211         bytes32 hash = keccak256(abi.encodePacked(msg.sender, amountReward));
1212         require(MerkleProof.verify(merkleProof, merkleRoot, hash), 'MerkleDistributor: Invalid proof.');
1213 
1214         claimMarker[msg.sender] = true;
1215 
1216         require(IERC20(ownerToken).transferFrom(ownerWallet, msg.sender, claimAmount * 10 ** decimals), 'MerkleDistributor: Transfer Claim failed.');
1217         require(IERC20(ownerToken).transferFrom(ownerWallet, burnAddress, burnAmount * 10 ** decimals), 'MerkleDistributor: Transfer Burn failed.');
1218         if (contributeAmount > 0) {
1219             require(IERC20(ownerToken).transferFrom(ownerWallet, contributeAddress, contributeAmount * 10 ** decimals), 'MerkleDistributor: Transfer Contribute failed.');
1220         }
1221         emit Claimed(msg.sender, amountReward);
1222     }
1223 }