1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `to`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address to, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `from` to `to` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(
192         address from,
193         address to,
194         uint256 amount
195     ) external returns (bool);
196 }
197 
198 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
199 
200 
201 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 // CAUTION
206 // This version of SafeMath should only be used with Solidity 0.8 or later,
207 // because it relies on the compiler's built in overflow checks.
208 
209 /**
210  * @dev Wrappers over Solidity's arithmetic operations.
211  *
212  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
213  * now has built in overflow checking.
214  */
215 library SafeMath {
216     /**
217      * @dev Returns the addition of two unsigned integers, with an overflow flag.
218      *
219      * _Available since v3.4._
220      */
221     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
222         unchecked {
223             uint256 c = a + b;
224             if (c < a) return (false, 0);
225             return (true, c);
226         }
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
231      *
232      * _Available since v3.4._
233      */
234     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
235         unchecked {
236             if (b > a) return (false, 0);
237             return (true, a - b);
238         }
239     }
240 
241     /**
242      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
243      *
244      * _Available since v3.4._
245      */
246     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
247         unchecked {
248             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
249             // benefit is lost if 'b' is also tested.
250             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
251             if (a == 0) return (true, 0);
252             uint256 c = a * b;
253             if (c / a != b) return (false, 0);
254             return (true, c);
255         }
256     }
257 
258     /**
259      * @dev Returns the division of two unsigned integers, with a division by zero flag.
260      *
261      * _Available since v3.4._
262      */
263     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
264         unchecked {
265             if (b == 0) return (false, 0);
266             return (true, a / b);
267         }
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
272      *
273      * _Available since v3.4._
274      */
275     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             if (b == 0) return (false, 0);
278             return (true, a % b);
279         }
280     }
281 
282     /**
283      * @dev Returns the addition of two unsigned integers, reverting on
284      * overflow.
285      *
286      * Counterpart to Solidity's `+` operator.
287      *
288      * Requirements:
289      *
290      * - Addition cannot overflow.
291      */
292     function add(uint256 a, uint256 b) internal pure returns (uint256) {
293         return a + b;
294     }
295 
296     /**
297      * @dev Returns the subtraction of two unsigned integers, reverting on
298      * overflow (when the result is negative).
299      *
300      * Counterpart to Solidity's `-` operator.
301      *
302      * Requirements:
303      *
304      * - Subtraction cannot overflow.
305      */
306     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a - b;
308     }
309 
310     /**
311      * @dev Returns the multiplication of two unsigned integers, reverting on
312      * overflow.
313      *
314      * Counterpart to Solidity's `*` operator.
315      *
316      * Requirements:
317      *
318      * - Multiplication cannot overflow.
319      */
320     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
321         return a * b;
322     }
323 
324     /**
325      * @dev Returns the integer division of two unsigned integers, reverting on
326      * division by zero. The result is rounded towards zero.
327      *
328      * Counterpart to Solidity's `/` operator.
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function div(uint256 a, uint256 b) internal pure returns (uint256) {
335         return a / b;
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * reverting when dividing by zero.
341      *
342      * Counterpart to Solidity's `%` operator. This function uses a `revert`
343      * opcode (which leaves remaining gas untouched) while Solidity uses an
344      * invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      *
348      * - The divisor cannot be zero.
349      */
350     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
351         return a % b;
352     }
353 
354     /**
355      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
356      * overflow (when the result is negative).
357      *
358      * CAUTION: This function is deprecated because it requires allocating memory for the error
359      * message unnecessarily. For custom revert reasons use {trySub}.
360      *
361      * Counterpart to Solidity's `-` operator.
362      *
363      * Requirements:
364      *
365      * - Subtraction cannot overflow.
366      */
367     function sub(
368         uint256 a,
369         uint256 b,
370         string memory errorMessage
371     ) internal pure returns (uint256) {
372         unchecked {
373             require(b <= a, errorMessage);
374             return a - b;
375         }
376     }
377 
378     /**
379      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
380      * division by zero. The result is rounded towards zero.
381      *
382      * Counterpart to Solidity's `/` operator. Note: this function uses a
383      * `revert` opcode (which leaves remaining gas untouched) while Solidity
384      * uses an invalid opcode to revert (consuming all remaining gas).
385      *
386      * Requirements:
387      *
388      * - The divisor cannot be zero.
389      */
390     function div(
391         uint256 a,
392         uint256 b,
393         string memory errorMessage
394     ) internal pure returns (uint256) {
395         unchecked {
396             require(b > 0, errorMessage);
397             return a / b;
398         }
399     }
400 
401     /**
402      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
403      * reverting with custom message when dividing by zero.
404      *
405      * CAUTION: This function is deprecated because it requires allocating memory for the error
406      * message unnecessarily. For custom revert reasons use {tryMod}.
407      *
408      * Counterpart to Solidity's `%` operator. This function uses a `revert`
409      * opcode (which leaves remaining gas untouched) while Solidity uses an
410      * invalid opcode to revert (consuming all remaining gas).
411      *
412      * Requirements:
413      *
414      * - The divisor cannot be zero.
415      */
416     function mod(
417         uint256 a,
418         uint256 b,
419         string memory errorMessage
420     ) internal pure returns (uint256) {
421         unchecked {
422             require(b > 0, errorMessage);
423             return a % b;
424         }
425     }
426 }
427 
428 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
429 
430 
431 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Standard math utilities missing in the Solidity language.
437  */
438 library Math {
439     enum Rounding {
440         Down, // Toward negative infinity
441         Up, // Toward infinity
442         Zero // Toward zero
443     }
444 
445     /**
446      * @dev Returns the largest of two numbers.
447      */
448     function max(uint256 a, uint256 b) internal pure returns (uint256) {
449         return a > b ? a : b;
450     }
451 
452     /**
453      * @dev Returns the smallest of two numbers.
454      */
455     function min(uint256 a, uint256 b) internal pure returns (uint256) {
456         return a < b ? a : b;
457     }
458 
459     /**
460      * @dev Returns the average of two numbers. The result is rounded towards
461      * zero.
462      */
463     function average(uint256 a, uint256 b) internal pure returns (uint256) {
464         // (a + b) / 2 can overflow.
465         return (a & b) + (a ^ b) / 2;
466     }
467 
468     /**
469      * @dev Returns the ceiling of the division of two numbers.
470      *
471      * This differs from standard division with `/` in that it rounds up instead
472      * of rounding down.
473      */
474     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
475         // (a + b - 1) / b can overflow on addition, so we distribute.
476         return a == 0 ? 0 : (a - 1) / b + 1;
477     }
478 
479     /**
480      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
481      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
482      * with further edits by Uniswap Labs also under MIT license.
483      */
484     function mulDiv(
485         uint256 x,
486         uint256 y,
487         uint256 denominator
488     ) internal pure returns (uint256 result) {
489         unchecked {
490             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
491             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
492             // variables such that product = prod1 * 2^256 + prod0.
493             uint256 prod0; // Least significant 256 bits of the product
494             uint256 prod1; // Most significant 256 bits of the product
495             assembly {
496                 let mm := mulmod(x, y, not(0))
497                 prod0 := mul(x, y)
498                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
499             }
500 
501             // Handle non-overflow cases, 256 by 256 division.
502             if (prod1 == 0) {
503                 return prod0 / denominator;
504             }
505 
506             // Make sure the result is less than 2^256. Also prevents denominator == 0.
507             require(denominator > prod1);
508 
509             ///////////////////////////////////////////////
510             // 512 by 256 division.
511             ///////////////////////////////////////////////
512 
513             // Make division exact by subtracting the remainder from [prod1 prod0].
514             uint256 remainder;
515             assembly {
516                 // Compute remainder using mulmod.
517                 remainder := mulmod(x, y, denominator)
518 
519                 // Subtract 256 bit number from 512 bit number.
520                 prod1 := sub(prod1, gt(remainder, prod0))
521                 prod0 := sub(prod0, remainder)
522             }
523 
524             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
525             // See https://cs.stackexchange.com/q/138556/92363.
526 
527             // Does not overflow because the denominator cannot be zero at this stage in the function.
528             uint256 twos = denominator & (~denominator + 1);
529             assembly {
530                 // Divide denominator by twos.
531                 denominator := div(denominator, twos)
532 
533                 // Divide [prod1 prod0] by twos.
534                 prod0 := div(prod0, twos)
535 
536                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
537                 twos := add(div(sub(0, twos), twos), 1)
538             }
539 
540             // Shift in bits from prod1 into prod0.
541             prod0 |= prod1 * twos;
542 
543             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
544             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
545             // four bits. That is, denominator * inv = 1 mod 2^4.
546             uint256 inverse = (3 * denominator) ^ 2;
547 
548             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
549             // in modular arithmetic, doubling the correct bits in each step.
550             inverse *= 2 - denominator * inverse; // inverse mod 2^8
551             inverse *= 2 - denominator * inverse; // inverse mod 2^16
552             inverse *= 2 - denominator * inverse; // inverse mod 2^32
553             inverse *= 2 - denominator * inverse; // inverse mod 2^64
554             inverse *= 2 - denominator * inverse; // inverse mod 2^128
555             inverse *= 2 - denominator * inverse; // inverse mod 2^256
556 
557             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
558             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
559             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
560             // is no longer required.
561             result = prod0 * inverse;
562             return result;
563         }
564     }
565 
566     /**
567      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
568      */
569     function mulDiv(
570         uint256 x,
571         uint256 y,
572         uint256 denominator,
573         Rounding rounding
574     ) internal pure returns (uint256) {
575         uint256 result = mulDiv(x, y, denominator);
576         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
577             result += 1;
578         }
579         return result;
580     }
581 
582     /**
583      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
584      *
585      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
586      */
587     function sqrt(uint256 a) internal pure returns (uint256) {
588         if (a == 0) {
589             return 0;
590         }
591 
592         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
593         //
594         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
595         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
596         //
597         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
598         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
599         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
600         //
601         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
602         uint256 result = 1 << (log2(a) >> 1);
603 
604         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
605         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
606         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
607         // into the expected uint128 result.
608         unchecked {
609             result = (result + a / result) >> 1;
610             result = (result + a / result) >> 1;
611             result = (result + a / result) >> 1;
612             result = (result + a / result) >> 1;
613             result = (result + a / result) >> 1;
614             result = (result + a / result) >> 1;
615             result = (result + a / result) >> 1;
616             return min(result, a / result);
617         }
618     }
619 
620     /**
621      * @notice Calculates sqrt(a), following the selected rounding direction.
622      */
623     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
624         unchecked {
625             uint256 result = sqrt(a);
626             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
627         }
628     }
629 
630     /**
631      * @dev Return the log in base 2, rounded down, of a positive value.
632      * Returns 0 if given 0.
633      */
634     function log2(uint256 value) internal pure returns (uint256) {
635         uint256 result = 0;
636         unchecked {
637             if (value >> 128 > 0) {
638                 value >>= 128;
639                 result += 128;
640             }
641             if (value >> 64 > 0) {
642                 value >>= 64;
643                 result += 64;
644             }
645             if (value >> 32 > 0) {
646                 value >>= 32;
647                 result += 32;
648             }
649             if (value >> 16 > 0) {
650                 value >>= 16;
651                 result += 16;
652             }
653             if (value >> 8 > 0) {
654                 value >>= 8;
655                 result += 8;
656             }
657             if (value >> 4 > 0) {
658                 value >>= 4;
659                 result += 4;
660             }
661             if (value >> 2 > 0) {
662                 value >>= 2;
663                 result += 2;
664             }
665             if (value >> 1 > 0) {
666                 result += 1;
667             }
668         }
669         return result;
670     }
671 
672     /**
673      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
674      * Returns 0 if given 0.
675      */
676     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
677         unchecked {
678             uint256 result = log2(value);
679             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
680         }
681     }
682 
683     /**
684      * @dev Return the log in base 10, rounded down, of a positive value.
685      * Returns 0 if given 0.
686      */
687     function log10(uint256 value) internal pure returns (uint256) {
688         uint256 result = 0;
689         unchecked {
690             if (value >= 10**64) {
691                 value /= 10**64;
692                 result += 64;
693             }
694             if (value >= 10**32) {
695                 value /= 10**32;
696                 result += 32;
697             }
698             if (value >= 10**16) {
699                 value /= 10**16;
700                 result += 16;
701             }
702             if (value >= 10**8) {
703                 value /= 10**8;
704                 result += 8;
705             }
706             if (value >= 10**4) {
707                 value /= 10**4;
708                 result += 4;
709             }
710             if (value >= 10**2) {
711                 value /= 10**2;
712                 result += 2;
713             }
714             if (value >= 10**1) {
715                 result += 1;
716             }
717         }
718         return result;
719     }
720 
721     /**
722      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
723      * Returns 0 if given 0.
724      */
725     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
726         unchecked {
727             uint256 result = log10(value);
728             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
729         }
730     }
731 
732     /**
733      * @dev Return the log in base 256, rounded down, of a positive value.
734      * Returns 0 if given 0.
735      *
736      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
737      */
738     function log256(uint256 value) internal pure returns (uint256) {
739         uint256 result = 0;
740         unchecked {
741             if (value >> 128 > 0) {
742                 value >>= 128;
743                 result += 16;
744             }
745             if (value >> 64 > 0) {
746                 value >>= 64;
747                 result += 8;
748             }
749             if (value >> 32 > 0) {
750                 value >>= 32;
751                 result += 4;
752             }
753             if (value >> 16 > 0) {
754                 value >>= 16;
755                 result += 2;
756             }
757             if (value >> 8 > 0) {
758                 result += 1;
759             }
760         }
761         return result;
762     }
763 
764     /**
765      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
766      * Returns 0 if given 0.
767      */
768     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
769         unchecked {
770             uint256 result = log256(value);
771             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
772         }
773     }
774 }
775 
776 // File: Staking.sol
777 
778 
779 
780 
781 
782 
783 
784 pragma solidity ^0.8.0;
785 
786 contract Staking is Ownable {
787     using SafeMath for uint256;
788 
789     uint256 public totalStake;
790     uint256 public totalRewards;
791 
792     enum StakingPeriod{ ONE_MONTH, THREE_MONTH, SIX_MONTH, NINE_MONTH, ONE_YEAR }
793 
794     struct stake {
795         uint256 amount;
796         StakingPeriod stakePeriod;
797         uint timestamp;
798     }
799 
800     address[] internal stakeholders;
801 
802     mapping(address => mapping(StakingPeriod => stake)) public stakes;
803     mapping(StakingPeriod => uint) public apr;
804 
805     IERC20 public myToken;
806 
807     event TokenStaked(address indexed _from, uint amount, StakingPeriod plan, uint timestamp);
808     event TokenUnstaked(address indexed _from, uint amount, StakingPeriod plan, uint timestamp);
809     event RewardsTransferred(address indexed _to, uint amount, StakingPeriod plan, uint timestamp);
810 
811     constructor(address _myToken)
812     { 
813         myToken = IERC20(_myToken);
814         apr[StakingPeriod.ONE_MONTH] = 100;
815         apr[StakingPeriod.THREE_MONTH] = 330;
816         apr[StakingPeriod.SIX_MONTH] = 750;
817         apr[StakingPeriod.NINE_MONTH] = 1260;
818         apr[StakingPeriod.ONE_YEAR] = 1860;
819     }
820 
821     // ---------- STAKES ----------
822 
823     function createStake(uint256 _stake, StakingPeriod _stakePeriod) public {
824         require(_stake > 0, "stake value should not be zero");
825         require(myToken.transferFrom(msg.sender, address(this), _stake), "Token Transfer Failed");
826         if(stakes[msg.sender][_stakePeriod].amount == 0) {
827             addStakeholder(msg.sender);
828             stakes[msg.sender][_stakePeriod] = stake(_stake, _stakePeriod, block.timestamp);
829             totalStake = totalStake.add(_stake);
830         } else {
831             stake memory tempStake = stakes[msg.sender][_stakePeriod];
832             tempStake.amount = tempStake.amount.add(_stake);
833             tempStake.timestamp = block.timestamp;
834             stakes[msg.sender][_stakePeriod] = tempStake;
835             totalStake = totalStake.add(_stake);
836         }
837         emit TokenStaked(msg.sender, _stake, _stakePeriod, block.timestamp);
838     }
839 
840     function unStake(uint256 _stake, StakingPeriod _stakePeriod) public {
841         require(_stake > 0, "stake value should not be zero");
842         stake memory tempStake = stakes[msg.sender][_stakePeriod];
843         require(validateStakingPeriod(tempStake), "Staking period is not expired");
844         require(_stake <= tempStake.amount, "Invalid Stake Amount");
845         uint256 _investorReward = getDailyRewards(_stakePeriod);
846         tempStake.amount = tempStake.amount.sub(_stake);
847         stakes[msg.sender][_stakePeriod] = tempStake;
848         totalStake = totalStake.sub(_stake);
849         totalRewards = totalRewards.add(_investorReward);
850         //uint256 tokensToBeTransfer = _stake.add(_investorReward);
851         if(stakes[msg.sender][_stakePeriod].amount == 0) removeStakeholder(msg.sender);
852         myToken.transfer(msg.sender, _stake);
853         myToken.transferFrom(owner(), msg.sender, _investorReward);
854         emit TokenUnstaked(msg.sender, _stake, _stakePeriod, block.timestamp);
855         emit RewardsTransferred(msg.sender, _investorReward, _stakePeriod, block.timestamp);
856     }
857 
858     function getInvestorRewards(uint256 _unstakeAmount, stake memory _investor) internal view returns (uint256) {
859         // uint256 investorStakingPeriod = getStakingPeriodInNumbers(_investor);
860         // uint APY = investorStakingPeriod == 26 weeks ? sixMonthAPR : investorStakingPeriod == 52 weeks ? oneYearAPR : investorStakingPeriod == 156 weeks ? threeYearAPR : 0;
861         return _unstakeAmount.mul(apr[_investor.stakePeriod]).div(100).div(100);
862     } 
863 
864     function validateStakingPeriod(stake memory _investor) internal view returns(bool) {
865         uint256 stakingTimeStamp = _investor.timestamp + getStakingPeriodInNumbers(_investor);
866         return block.timestamp >= stakingTimeStamp; // change it to block.timestamp >= stakingTimeStamp; while deploying
867     } 
868 
869     function getStakingPeriodInNumbers(stake memory _investor) internal pure returns (uint256){
870         return _investor.stakePeriod == StakingPeriod.ONE_MONTH ? 4 weeks : _investor.stakePeriod == StakingPeriod.THREE_MONTH ? 12 weeks : _investor.stakePeriod == StakingPeriod.SIX_MONTH ? 24 weeks : _investor.stakePeriod == StakingPeriod.NINE_MONTH ? 36 weeks : _investor.stakePeriod == StakingPeriod.ONE_YEAR ? 48 weeks : 0; 
871     }
872 
873     function stakeOf(address _stakeholder, StakingPeriod _stakePeriod)
874         public
875         view
876         returns(uint256)
877     {
878         return stakes[_stakeholder][_stakePeriod].amount;
879     }
880 
881     function stakingPeriodOf(address _stakeholder, StakingPeriod _stakePeriod) public view returns (StakingPeriod) {
882         return stakes[_stakeholder][_stakePeriod].stakePeriod;
883     }
884 
885     function getDailyRewards(StakingPeriod _stakePeriod) public view returns (uint256) {
886         stake memory tempStake = stakes[msg.sender][_stakePeriod];
887         uint256 total_rewards = getInvestorRewards(tempStake.amount, tempStake);
888         uint256 noOfDays = (block.timestamp - tempStake.timestamp).div(60).div(60).div(24);
889         noOfDays = (noOfDays < 1) ? 1 : noOfDays;
890        // uint256 stakingPeriodInDays =  getStakingPeriodInNumbers(tempStake).div(60).div(60).div(24);
891         return total_rewards.div(364).mul(noOfDays);
892     }
893 
894     // ---------- STAKEHOLDERS ----------
895 
896     function isStakeholder(address _address)
897         internal
898         view
899         returns(bool, uint256)
900     {
901         for (uint256 s = 0; s < stakeholders.length; s += 1){
902             if (_address == stakeholders[s]) return (true, s);
903         }
904         return (false, 0);
905     }
906 
907    
908     function addStakeholder(address _stakeholder)
909         internal
910     {
911         (bool _isStakeholder, ) = isStakeholder(_stakeholder);
912         if(!_isStakeholder) stakeholders.push(_stakeholder);
913     }
914 
915     
916     function removeStakeholder(address _stakeholder)
917         internal
918     {
919         (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
920         if(_isStakeholder){
921             stakeholders[s] = stakeholders[stakeholders.length - 1];
922             stakeholders.pop();
923         } 
924     }
925     // ---------- REWARDS ----------
926 
927     
928     function getTotalRewards()
929         public
930         view
931         returns(uint256)
932     {
933         return totalRewards;
934     }
935 
936     // ---- Staking APY  setters ---- 
937 
938     function setApyPercentage(uint8 _percentage, StakingPeriod _stakePeriod) public onlyOwner {
939         uint percentage = _percentage * 100;
940         apr[_stakePeriod] = percentage;
941     }
942 
943     function remainingTokens() public view returns (uint256) {
944         return Math.min(myToken.balanceOf(owner()), myToken.allowance(owner(), address(this)));
945     }
946 
947 }