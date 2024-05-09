1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         _nonReentrantBefore();
55         _;
56         _nonReentrantAfter();
57     }
58 
59     function _nonReentrantBefore() private {
60         // On the first call to nonReentrant, _status will be _NOT_ENTERED
61         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
62 
63         // Any calls to nonReentrant after this point will fail
64         _status = _ENTERED;
65     }
66 
67     function _nonReentrantAfter() private {
68         // By storing the original value once again, a refund is triggered (see
69         // https://eips.ethereum.org/EIPS/eip-2200)
70         _status = _NOT_ENTERED;
71     }
72 
73     /**
74      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
75      * `nonReentrant` function in the call stack.
76      */
77     function _reentrancyGuardEntered() internal view returns (bool) {
78         return _status == _ENTERED;
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
83 
84 
85 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev Standard signed math utilities missing in the Solidity language.
91  */
92 library SignedMath {
93     /**
94      * @dev Returns the largest of two signed numbers.
95      */
96     function max(int256 a, int256 b) internal pure returns (int256) {
97         return a > b ? a : b;
98     }
99 
100     /**
101      * @dev Returns the smallest of two signed numbers.
102      */
103     function min(int256 a, int256 b) internal pure returns (int256) {
104         return a < b ? a : b;
105     }
106 
107     /**
108      * @dev Returns the average of two signed numbers without overflow.
109      * The result is rounded towards zero.
110      */
111     function average(int256 a, int256 b) internal pure returns (int256) {
112         // Formula from the book "Hacker's Delight"
113         int256 x = (a & b) + ((a ^ b) >> 1);
114         return x + (int256(uint256(x) >> 255) & (a ^ b));
115     }
116 
117     /**
118      * @dev Returns the absolute unsigned value of a signed value.
119      */
120     function abs(int256 n) internal pure returns (uint256) {
121         unchecked {
122             // must be unchecked in order to support `n = type(int256).min`
123             return uint256(n >= 0 ? n : -n);
124         }
125     }
126 }
127 
128 // File: @openzeppelin/contracts/utils/math/Math.sol
129 
130 
131 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 /**
136  * @dev Standard math utilities missing in the Solidity language.
137  */
138 library Math {
139     enum Rounding {
140         Down, // Toward negative infinity
141         Up, // Toward infinity
142         Zero // Toward zero
143     }
144 
145     /**
146      * @dev Returns the largest of two numbers.
147      */
148     function max(uint256 a, uint256 b) internal pure returns (uint256) {
149         return a > b ? a : b;
150     }
151 
152     /**
153      * @dev Returns the smallest of two numbers.
154      */
155     function min(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a < b ? a : b;
157     }
158 
159     /**
160      * @dev Returns the average of two numbers. The result is rounded towards
161      * zero.
162      */
163     function average(uint256 a, uint256 b) internal pure returns (uint256) {
164         // (a + b) / 2 can overflow.
165         return (a & b) + (a ^ b) / 2;
166     }
167 
168     /**
169      * @dev Returns the ceiling of the division of two numbers.
170      *
171      * This differs from standard division with `/` in that it rounds up instead
172      * of rounding down.
173      */
174     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
175         // (a + b - 1) / b can overflow on addition, so we distribute.
176         return a == 0 ? 0 : (a - 1) / b + 1;
177     }
178 
179     /**
180      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
181      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
182      * with further edits by Uniswap Labs also under MIT license.
183      */
184     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
185         unchecked {
186             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
187             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
188             // variables such that product = prod1 * 2^256 + prod0.
189             uint256 prod0; // Least significant 256 bits of the product
190             uint256 prod1; // Most significant 256 bits of the product
191             assembly {
192                 let mm := mulmod(x, y, not(0))
193                 prod0 := mul(x, y)
194                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
195             }
196 
197             // Handle non-overflow cases, 256 by 256 division.
198             if (prod1 == 0) {
199                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
200                 // The surrounding unchecked block does not change this fact.
201                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
202                 return prod0 / denominator;
203             }
204 
205             // Make sure the result is less than 2^256. Also prevents denominator == 0.
206             require(denominator > prod1, "Math: mulDiv overflow");
207 
208             ///////////////////////////////////////////////
209             // 512 by 256 division.
210             ///////////////////////////////////////////////
211 
212             // Make division exact by subtracting the remainder from [prod1 prod0].
213             uint256 remainder;
214             assembly {
215                 // Compute remainder using mulmod.
216                 remainder := mulmod(x, y, denominator)
217 
218                 // Subtract 256 bit number from 512 bit number.
219                 prod1 := sub(prod1, gt(remainder, prod0))
220                 prod0 := sub(prod0, remainder)
221             }
222 
223             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
224             // See https://cs.stackexchange.com/q/138556/92363.
225 
226             // Does not overflow because the denominator cannot be zero at this stage in the function.
227             uint256 twos = denominator & (~denominator + 1);
228             assembly {
229                 // Divide denominator by twos.
230                 denominator := div(denominator, twos)
231 
232                 // Divide [prod1 prod0] by twos.
233                 prod0 := div(prod0, twos)
234 
235                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
236                 twos := add(div(sub(0, twos), twos), 1)
237             }
238 
239             // Shift in bits from prod1 into prod0.
240             prod0 |= prod1 * twos;
241 
242             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
243             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
244             // four bits. That is, denominator * inv = 1 mod 2^4.
245             uint256 inverse = (3 * denominator) ^ 2;
246 
247             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
248             // in modular arithmetic, doubling the correct bits in each step.
249             inverse *= 2 - denominator * inverse; // inverse mod 2^8
250             inverse *= 2 - denominator * inverse; // inverse mod 2^16
251             inverse *= 2 - denominator * inverse; // inverse mod 2^32
252             inverse *= 2 - denominator * inverse; // inverse mod 2^64
253             inverse *= 2 - denominator * inverse; // inverse mod 2^128
254             inverse *= 2 - denominator * inverse; // inverse mod 2^256
255 
256             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
257             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
258             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
259             // is no longer required.
260             result = prod0 * inverse;
261             return result;
262         }
263     }
264 
265     /**
266      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
267      */
268     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
269         uint256 result = mulDiv(x, y, denominator);
270         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
271             result += 1;
272         }
273         return result;
274     }
275 
276     /**
277      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
278      *
279      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
280      */
281     function sqrt(uint256 a) internal pure returns (uint256) {
282         if (a == 0) {
283             return 0;
284         }
285 
286         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
287         //
288         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
289         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
290         //
291         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
292         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
293         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
294         //
295         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
296         uint256 result = 1 << (log2(a) >> 1);
297 
298         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
299         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
300         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
301         // into the expected uint128 result.
302         unchecked {
303             result = (result + a / result) >> 1;
304             result = (result + a / result) >> 1;
305             result = (result + a / result) >> 1;
306             result = (result + a / result) >> 1;
307             result = (result + a / result) >> 1;
308             result = (result + a / result) >> 1;
309             result = (result + a / result) >> 1;
310             return min(result, a / result);
311         }
312     }
313 
314     /**
315      * @notice Calculates sqrt(a), following the selected rounding direction.
316      */
317     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
318         unchecked {
319             uint256 result = sqrt(a);
320             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
321         }
322     }
323 
324     /**
325      * @dev Return the log in base 2, rounded down, of a positive value.
326      * Returns 0 if given 0.
327      */
328     function log2(uint256 value) internal pure returns (uint256) {
329         uint256 result = 0;
330         unchecked {
331             if (value >> 128 > 0) {
332                 value >>= 128;
333                 result += 128;
334             }
335             if (value >> 64 > 0) {
336                 value >>= 64;
337                 result += 64;
338             }
339             if (value >> 32 > 0) {
340                 value >>= 32;
341                 result += 32;
342             }
343             if (value >> 16 > 0) {
344                 value >>= 16;
345                 result += 16;
346             }
347             if (value >> 8 > 0) {
348                 value >>= 8;
349                 result += 8;
350             }
351             if (value >> 4 > 0) {
352                 value >>= 4;
353                 result += 4;
354             }
355             if (value >> 2 > 0) {
356                 value >>= 2;
357                 result += 2;
358             }
359             if (value >> 1 > 0) {
360                 result += 1;
361             }
362         }
363         return result;
364     }
365 
366     /**
367      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
368      * Returns 0 if given 0.
369      */
370     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
371         unchecked {
372             uint256 result = log2(value);
373             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
374         }
375     }
376 
377     /**
378      * @dev Return the log in base 10, rounded down, of a positive value.
379      * Returns 0 if given 0.
380      */
381     function log10(uint256 value) internal pure returns (uint256) {
382         uint256 result = 0;
383         unchecked {
384             if (value >= 10 ** 64) {
385                 value /= 10 ** 64;
386                 result += 64;
387             }
388             if (value >= 10 ** 32) {
389                 value /= 10 ** 32;
390                 result += 32;
391             }
392             if (value >= 10 ** 16) {
393                 value /= 10 ** 16;
394                 result += 16;
395             }
396             if (value >= 10 ** 8) {
397                 value /= 10 ** 8;
398                 result += 8;
399             }
400             if (value >= 10 ** 4) {
401                 value /= 10 ** 4;
402                 result += 4;
403             }
404             if (value >= 10 ** 2) {
405                 value /= 10 ** 2;
406                 result += 2;
407             }
408             if (value >= 10 ** 1) {
409                 result += 1;
410             }
411         }
412         return result;
413     }
414 
415     /**
416      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
417      * Returns 0 if given 0.
418      */
419     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
420         unchecked {
421             uint256 result = log10(value);
422             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
423         }
424     }
425 
426     /**
427      * @dev Return the log in base 256, rounded down, of a positive value.
428      * Returns 0 if given 0.
429      *
430      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
431      */
432     function log256(uint256 value) internal pure returns (uint256) {
433         uint256 result = 0;
434         unchecked {
435             if (value >> 128 > 0) {
436                 value >>= 128;
437                 result += 16;
438             }
439             if (value >> 64 > 0) {
440                 value >>= 64;
441                 result += 8;
442             }
443             if (value >> 32 > 0) {
444                 value >>= 32;
445                 result += 4;
446             }
447             if (value >> 16 > 0) {
448                 value >>= 16;
449                 result += 2;
450             }
451             if (value >> 8 > 0) {
452                 result += 1;
453             }
454         }
455         return result;
456     }
457 
458     /**
459      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
460      * Returns 0 if given 0.
461      */
462     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
463         unchecked {
464             uint256 result = log256(value);
465             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
466         }
467     }
468 }
469 
470 // File: @openzeppelin/contracts/utils/Strings.sol
471 
472 
473 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 
478 
479 /**
480  * @dev String operations.
481  */
482 library Strings {
483     bytes16 private constant _SYMBOLS = "0123456789abcdef";
484     uint8 private constant _ADDRESS_LENGTH = 20;
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
488      */
489     function toString(uint256 value) internal pure returns (string memory) {
490         unchecked {
491             uint256 length = Math.log10(value) + 1;
492             string memory buffer = new string(length);
493             uint256 ptr;
494             /// @solidity memory-safe-assembly
495             assembly {
496                 ptr := add(buffer, add(32, length))
497             }
498             while (true) {
499                 ptr--;
500                 /// @solidity memory-safe-assembly
501                 assembly {
502                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
503                 }
504                 value /= 10;
505                 if (value == 0) break;
506             }
507             return buffer;
508         }
509     }
510 
511     /**
512      * @dev Converts a `int256` to its ASCII `string` decimal representation.
513      */
514     function toString(int256 value) internal pure returns (string memory) {
515         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
516     }
517 
518     /**
519      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
520      */
521     function toHexString(uint256 value) internal pure returns (string memory) {
522         unchecked {
523             return toHexString(value, Math.log256(value) + 1);
524         }
525     }
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
529      */
530     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
531         bytes memory buffer = new bytes(2 * length + 2);
532         buffer[0] = "0";
533         buffer[1] = "x";
534         for (uint256 i = 2 * length + 1; i > 1; --i) {
535             buffer[i] = _SYMBOLS[value & 0xf];
536             value >>= 4;
537         }
538         require(value == 0, "Strings: hex length insufficient");
539         return string(buffer);
540     }
541 
542     /**
543      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
544      */
545     function toHexString(address addr) internal pure returns (string memory) {
546         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
547     }
548 
549     /**
550      * @dev Returns true if the two strings are equal.
551      */
552     function equal(string memory a, string memory b) internal pure returns (bool) {
553         return keccak256(bytes(a)) == keccak256(bytes(b));
554     }
555 }
556 
557 // File: @openzeppelin/contracts/utils/Context.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @dev Provides information about the current execution context, including the
566  * sender of the transaction and its data. While these are generally available
567  * via msg.sender and msg.data, they should not be accessed in such a direct
568  * manner, since when dealing with meta-transactions the account sending and
569  * paying for execution may not be the actual sender (as far as an application
570  * is concerned).
571  *
572  * This contract is only required for intermediate, library-like contracts.
573  */
574 abstract contract Context {
575     function _msgSender() internal view virtual returns (address) {
576         return msg.sender;
577     }
578 
579     function _msgData() internal view virtual returns (bytes calldata) {
580         return msg.data;
581     }
582 }
583 
584 // File: @openzeppelin/contracts/access/Ownable.sol
585 
586 
587 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Contract module which provides a basic access control mechanism, where
594  * there is an account (an owner) that can be granted exclusive access to
595  * specific functions.
596  *
597  * By default, the owner account will be the one that deploys the contract. This
598  * can later be changed with {transferOwnership}.
599  *
600  * This module is used through inheritance. It will make available the modifier
601  * `onlyOwner`, which can be applied to your functions to restrict their use to
602  * the owner.
603  */
604 abstract contract Ownable is Context {
605     address private _owner;
606 
607     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
608 
609     /**
610      * @dev Initializes the contract setting the deployer as the initial owner.
611      */
612     constructor() {
613         _transferOwnership(_msgSender());
614     }
615 
616     /**
617      * @dev Throws if called by any account other than the owner.
618      */
619     modifier onlyOwner() {
620         _checkOwner();
621         _;
622     }
623 
624     /**
625      * @dev Returns the address of the current owner.
626      */
627     function owner() public view virtual returns (address) {
628         return _owner;
629     }
630 
631     /**
632      * @dev Throws if the sender is not the owner.
633      */
634     function _checkOwner() internal view virtual {
635         require(owner() == _msgSender(), "Ownable: caller is not the owner");
636     }
637 
638     /**
639      * @dev Leaves the contract without owner. It will not be possible to call
640      * `onlyOwner` functions. Can only be called by the current owner.
641      *
642      * NOTE: Renouncing ownership will leave the contract without an owner,
643      * thereby disabling any functionality that is only available to the owner.
644      */
645     function renounceOwnership() public virtual onlyOwner {
646         _transferOwnership(address(0));
647     }
648 
649     /**
650      * @dev Transfers ownership of the contract to a new account (`newOwner`).
651      * Can only be called by the current owner.
652      */
653     function transferOwnership(address newOwner) public virtual onlyOwner {
654         require(newOwner != address(0), "Ownable: new owner is the zero address");
655         _transferOwnership(newOwner);
656     }
657 
658     /**
659      * @dev Transfers ownership of the contract to a new account (`newOwner`).
660      * Internal function without access restriction.
661      */
662     function _transferOwnership(address newOwner) internal virtual {
663         address oldOwner = _owner;
664         _owner = newOwner;
665         emit OwnershipTransferred(oldOwner, newOwner);
666     }
667 }
668 
669 // File: erc721a/contracts/IERC721A.sol
670 
671 
672 // ERC721A Contracts v4.2.3
673 // Creator: Chiru Labs
674 
675 pragma solidity ^0.8.4;
676 
677 /**
678  * @dev Interface of ERC721A.
679  */
680 interface IERC721A {
681     /**
682      * The caller must own the token or be an approved operator.
683      */
684     error ApprovalCallerNotOwnerNorApproved();
685 
686     /**
687      * The token does not exist.
688      */
689     error ApprovalQueryForNonexistentToken();
690 
691     /**
692      * Cannot query the balance for the zero address.
693      */
694     error BalanceQueryForZeroAddress();
695 
696     /**
697      * Cannot mint to the zero address.
698      */
699     error MintToZeroAddress();
700 
701     /**
702      * The quantity of tokens minted must be more than zero.
703      */
704     error MintZeroQuantity();
705 
706     /**
707      * The token does not exist.
708      */
709     error OwnerQueryForNonexistentToken();
710 
711     /**
712      * The caller must own the token or be an approved operator.
713      */
714     error TransferCallerNotOwnerNorApproved();
715 
716     /**
717      * The token must be owned by `from`.
718      */
719     error TransferFromIncorrectOwner();
720 
721     /**
722      * Cannot safely transfer to a contract that does not implement the
723      * ERC721Receiver interface.
724      */
725     error TransferToNonERC721ReceiverImplementer();
726 
727     /**
728      * Cannot transfer to the zero address.
729      */
730     error TransferToZeroAddress();
731 
732     /**
733      * The token does not exist.
734      */
735     error URIQueryForNonexistentToken();
736 
737     /**
738      * The `quantity` minted with ERC2309 exceeds the safety limit.
739      */
740     error MintERC2309QuantityExceedsLimit();
741 
742     /**
743      * The `extraData` cannot be set on an unintialized ownership slot.
744      */
745     error OwnershipNotInitializedForExtraData();
746 
747     // =============================================================
748     //                            STRUCTS
749     // =============================================================
750 
751     struct TokenOwnership {
752         // The address of the owner.
753         address addr;
754         // Stores the start time of ownership with minimal overhead for tokenomics.
755         uint64 startTimestamp;
756         // Whether the token has been burned.
757         bool burned;
758         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
759         uint24 extraData;
760     }
761 
762     // =============================================================
763     //                         TOKEN COUNTERS
764     // =============================================================
765 
766     /**
767      * @dev Returns the total number of tokens in existence.
768      * Burned tokens will reduce the count.
769      * To get the total number of tokens minted, please see {_totalMinted}.
770      */
771     function totalSupply() external view returns (uint256);
772 
773     // =============================================================
774     //                            IERC165
775     // =============================================================
776 
777     /**
778      * @dev Returns true if this contract implements the interface defined by
779      * `interfaceId`. See the corresponding
780      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
781      * to learn more about how these ids are created.
782      *
783      * This function call must use less than 30000 gas.
784      */
785     function supportsInterface(bytes4 interfaceId) external view returns (bool);
786 
787     // =============================================================
788     //                            IERC721
789     // =============================================================
790 
791     /**
792      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
793      */
794     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
795 
796     /**
797      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
798      */
799     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
800 
801     /**
802      * @dev Emitted when `owner` enables or disables
803      * (`approved`) `operator` to manage all of its assets.
804      */
805     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
806 
807     /**
808      * @dev Returns the number of tokens in `owner`'s account.
809      */
810     function balanceOf(address owner) external view returns (uint256 balance);
811 
812     /**
813      * @dev Returns the owner of the `tokenId` token.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function ownerOf(uint256 tokenId) external view returns (address owner);
820 
821     /**
822      * @dev Safely transfers `tokenId` token from `from` to `to`,
823      * checking first that contract recipients are aware of the ERC721 protocol
824      * to prevent tokens from being forever locked.
825      *
826      * Requirements:
827      *
828      * - `from` cannot be the zero address.
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must exist and be owned by `from`.
831      * - If the caller is not `from`, it must be have been allowed to move
832      * this token by either {approve} or {setApprovalForAll}.
833      * - If `to` refers to a smart contract, it must implement
834      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
835      *
836      * Emits a {Transfer} event.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId,
842         bytes calldata data
843     ) external payable;
844 
845     /**
846      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
847      */
848     function safeTransferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) external payable;
853 
854     /**
855      * @dev Transfers `tokenId` from `from` to `to`.
856      *
857      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
858      * whenever possible.
859      *
860      * Requirements:
861      *
862      * - `from` cannot be the zero address.
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must be owned by `from`.
865      * - If the caller is not `from`, it must be approved to move this token
866      * by either {approve} or {setApprovalForAll}.
867      *
868      * Emits a {Transfer} event.
869      */
870     function transferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) external payable;
875 
876     /**
877      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
878      * The approval is cleared when the token is transferred.
879      *
880      * Only a single account can be approved at a time, so approving the
881      * zero address clears previous approvals.
882      *
883      * Requirements:
884      *
885      * - The caller must own the token or be an approved operator.
886      * - `tokenId` must exist.
887      *
888      * Emits an {Approval} event.
889      */
890     function approve(address to, uint256 tokenId) external payable;
891 
892     /**
893      * @dev Approve or remove `operator` as an operator for the caller.
894      * Operators can call {transferFrom} or {safeTransferFrom}
895      * for any token owned by the caller.
896      *
897      * Requirements:
898      *
899      * - The `operator` cannot be the caller.
900      *
901      * Emits an {ApprovalForAll} event.
902      */
903     function setApprovalForAll(address operator, bool _approved) external;
904 
905     /**
906      * @dev Returns the account approved for `tokenId` token.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      */
912     function getApproved(uint256 tokenId) external view returns (address operator);
913 
914     /**
915      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
916      *
917      * See {setApprovalForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) external view returns (bool);
920 
921     // =============================================================
922     //                        IERC721Metadata
923     // =============================================================
924 
925     /**
926      * @dev Returns the token collection name.
927      */
928     function name() external view returns (string memory);
929 
930     /**
931      * @dev Returns the token collection symbol.
932      */
933     function symbol() external view returns (string memory);
934 
935     /**
936      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
937      */
938     function tokenURI(uint256 tokenId) external view returns (string memory);
939 
940     // =============================================================
941     //                           IERC2309
942     // =============================================================
943 
944     /**
945      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
946      * (inclusive) is transferred from `from` to `to`, as defined in the
947      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
948      *
949      * See {_mintERC2309} for more details.
950      */
951     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
952 }
953 
954 // File: erc721a/contracts/ERC721A.sol
955 
956 
957 // ERC721A Contracts v4.2.3
958 // Creator: Chiru Labs
959 
960 pragma solidity ^0.8.4;
961 
962 
963 /**
964  * @dev Interface of ERC721 token receiver.
965  */
966 interface ERC721A__IERC721Receiver {
967     function onERC721Received(
968         address operator,
969         address from,
970         uint256 tokenId,
971         bytes calldata data
972     ) external returns (bytes4);
973 }
974 
975 /**
976  * @title ERC721A
977  *
978  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
979  * Non-Fungible Token Standard, including the Metadata extension.
980  * Optimized for lower gas during batch mints.
981  *
982  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
983  * starting from `_startTokenId()`.
984  *
985  * Assumptions:
986  *
987  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
988  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
989  */
990 contract ERC721A is IERC721A {
991     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
992     struct TokenApprovalRef {
993         address value;
994     }
995 
996     // =============================================================
997     //                           CONSTANTS
998     // =============================================================
999 
1000     // Mask of an entry in packed address data.
1001     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1002 
1003     // The bit position of `numberMinted` in packed address data.
1004     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1005 
1006     // The bit position of `numberBurned` in packed address data.
1007     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1008 
1009     // The bit position of `aux` in packed address data.
1010     uint256 private constant _BITPOS_AUX = 192;
1011 
1012     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1013     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1014 
1015     // The bit position of `startTimestamp` in packed ownership.
1016     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1017 
1018     // The bit mask of the `burned` bit in packed ownership.
1019     uint256 private constant _BITMASK_BURNED = 1 << 224;
1020 
1021     // The bit position of the `nextInitialized` bit in packed ownership.
1022     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1023 
1024     // The bit mask of the `nextInitialized` bit in packed ownership.
1025     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1026 
1027     // The bit position of `extraData` in packed ownership.
1028     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1029 
1030     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1031     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1032 
1033     // The mask of the lower 160 bits for addresses.
1034     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1035 
1036     // The maximum `quantity` that can be minted with {_mintERC2309}.
1037     // This limit is to prevent overflows on the address data entries.
1038     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1039     // is required to cause an overflow, which is unrealistic.
1040     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1041 
1042     // The `Transfer` event signature is given by:
1043     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1044     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1045         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1046 
1047     // =============================================================
1048     //                            STORAGE
1049     // =============================================================
1050 
1051     // The next token ID to be minted.
1052     uint256 private _currentIndex;
1053 
1054     // The number of tokens burned.
1055     uint256 private _burnCounter;
1056 
1057     // Token name
1058     string private _name;
1059 
1060     // Token symbol
1061     string private _symbol;
1062 
1063     // Mapping from token ID to ownership details
1064     // An empty struct value does not necessarily mean the token is unowned.
1065     // See {_packedOwnershipOf} implementation for details.
1066     //
1067     // Bits Layout:
1068     // - [0..159]   `addr`
1069     // - [160..223] `startTimestamp`
1070     // - [224]      `burned`
1071     // - [225]      `nextInitialized`
1072     // - [232..255] `extraData`
1073     mapping(uint256 => uint256) private _packedOwnerships;
1074 
1075     // Mapping owner address to address data.
1076     //
1077     // Bits Layout:
1078     // - [0..63]    `balance`
1079     // - [64..127]  `numberMinted`
1080     // - [128..191] `numberBurned`
1081     // - [192..255] `aux`
1082     mapping(address => uint256) private _packedAddressData;
1083 
1084     // Mapping from token ID to approved address.
1085     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1086 
1087     // Mapping from owner to operator approvals
1088     mapping(address => mapping(address => bool)) private _operatorApprovals;
1089 
1090     // =============================================================
1091     //                          CONSTRUCTOR
1092     // =============================================================
1093 
1094     constructor(string memory name_, string memory symbol_) {
1095         _name = name_;
1096         _symbol = symbol_;
1097         _currentIndex = _startTokenId();
1098     }
1099 
1100     // =============================================================
1101     //                   TOKEN COUNTING OPERATIONS
1102     // =============================================================
1103 
1104     /**
1105      * @dev Returns the starting token ID.
1106      * To change the starting token ID, please override this function.
1107      */
1108     function _startTokenId() internal view virtual returns (uint256) {
1109         return 0;
1110     }
1111 
1112     /**
1113      * @dev Returns the next token ID to be minted.
1114      */
1115     function _nextTokenId() internal view virtual returns (uint256) {
1116         return _currentIndex;
1117     }
1118 
1119     /**
1120      * @dev Returns the total number of tokens in existence.
1121      * Burned tokens will reduce the count.
1122      * To get the total number of tokens minted, please see {_totalMinted}.
1123      */
1124     function totalSupply() public view virtual override returns (uint256) {
1125         // Counter underflow is impossible as _burnCounter cannot be incremented
1126         // more than `_currentIndex - _startTokenId()` times.
1127         unchecked {
1128             return _currentIndex - _burnCounter - _startTokenId();
1129         }
1130     }
1131 
1132     /**
1133      * @dev Returns the total amount of tokens minted in the contract.
1134      */
1135     function _totalMinted() internal view virtual returns (uint256) {
1136         // Counter underflow is impossible as `_currentIndex` does not decrement,
1137         // and it is initialized to `_startTokenId()`.
1138         unchecked {
1139             return _currentIndex - _startTokenId();
1140         }
1141     }
1142 
1143     /**
1144      * @dev Returns the total number of tokens burned.
1145      */
1146     function _totalBurned() internal view virtual returns (uint256) {
1147         return _burnCounter;
1148     }
1149 
1150     // =============================================================
1151     //                    ADDRESS DATA OPERATIONS
1152     // =============================================================
1153 
1154     /**
1155      * @dev Returns the number of tokens in `owner`'s account.
1156      */
1157     function balanceOf(address owner) public view virtual override returns (uint256) {
1158         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1159         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1160     }
1161 
1162     /**
1163      * Returns the number of tokens minted by `owner`.
1164      */
1165     function _numberMinted(address owner) internal view returns (uint256) {
1166         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1167     }
1168 
1169     /**
1170      * Returns the number of tokens burned by or on behalf of `owner`.
1171      */
1172     function _numberBurned(address owner) internal view returns (uint256) {
1173         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1174     }
1175 
1176     /**
1177      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1178      */
1179     function _getAux(address owner) internal view returns (uint64) {
1180         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1181     }
1182 
1183     /**
1184      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1185      * If there are multiple variables, please pack them into a uint64.
1186      */
1187     function _setAux(address owner, uint64 aux) internal virtual {
1188         uint256 packed = _packedAddressData[owner];
1189         uint256 auxCasted;
1190         // Cast `aux` with assembly to avoid redundant masking.
1191         assembly {
1192             auxCasted := aux
1193         }
1194         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1195         _packedAddressData[owner] = packed;
1196     }
1197 
1198     // =============================================================
1199     //                            IERC165
1200     // =============================================================
1201 
1202     /**
1203      * @dev Returns true if this contract implements the interface defined by
1204      * `interfaceId`. See the corresponding
1205      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1206      * to learn more about how these ids are created.
1207      *
1208      * This function call must use less than 30000 gas.
1209      */
1210     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1211         // The interface IDs are constants representing the first 4 bytes
1212         // of the XOR of all function selectors in the interface.
1213         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1214         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1215         return
1216             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1217             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1218             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1219     }
1220 
1221     // =============================================================
1222     //                        IERC721Metadata
1223     // =============================================================
1224 
1225     /**
1226      * @dev Returns the token collection name.
1227      */
1228     function name() public view virtual override returns (string memory) {
1229         return _name;
1230     }
1231 
1232     /**
1233      * @dev Returns the token collection symbol.
1234      */
1235     function symbol() public view virtual override returns (string memory) {
1236         return _symbol;
1237     }
1238 
1239     /**
1240      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1241      */
1242     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1243         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1244 
1245         string memory baseURI = _baseURI();
1246         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1247     }
1248 
1249     /**
1250      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1251      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1252      * by default, it can be overridden in child contracts.
1253      */
1254     function _baseURI() internal view virtual returns (string memory) {
1255         return '';
1256     }
1257 
1258     // =============================================================
1259     //                     OWNERSHIPS OPERATIONS
1260     // =============================================================
1261 
1262     /**
1263      * @dev Returns the owner of the `tokenId` token.
1264      *
1265      * Requirements:
1266      *
1267      * - `tokenId` must exist.
1268      */
1269     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1270         return address(uint160(_packedOwnershipOf(tokenId)));
1271     }
1272 
1273     /**
1274      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1275      * It gradually moves to O(1) as tokens get transferred around over time.
1276      */
1277     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1278         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1279     }
1280 
1281     /**
1282      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1283      */
1284     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1285         return _unpackedOwnership(_packedOwnerships[index]);
1286     }
1287 
1288     /**
1289      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1290      */
1291     function _initializeOwnershipAt(uint256 index) internal virtual {
1292         if (_packedOwnerships[index] == 0) {
1293             _packedOwnerships[index] = _packedOwnershipOf(index);
1294         }
1295     }
1296 
1297     /**
1298      * Returns the packed ownership data of `tokenId`.
1299      */
1300     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1301         uint256 curr = tokenId;
1302 
1303         unchecked {
1304             if (_startTokenId() <= curr)
1305                 if (curr < _currentIndex) {
1306                     uint256 packed = _packedOwnerships[curr];
1307                     // If not burned.
1308                     if (packed & _BITMASK_BURNED == 0) {
1309                         // Invariant:
1310                         // There will always be an initialized ownership slot
1311                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1312                         // before an unintialized ownership slot
1313                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1314                         // Hence, `curr` will not underflow.
1315                         //
1316                         // We can directly compare the packed value.
1317                         // If the address is zero, packed will be zero.
1318                         while (packed == 0) {
1319                             packed = _packedOwnerships[--curr];
1320                         }
1321                         return packed;
1322                     }
1323                 }
1324         }
1325         revert OwnerQueryForNonexistentToken();
1326     }
1327 
1328     /**
1329      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1330      */
1331     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1332         ownership.addr = address(uint160(packed));
1333         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1334         ownership.burned = packed & _BITMASK_BURNED != 0;
1335         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1336     }
1337 
1338     /**
1339      * @dev Packs ownership data into a single uint256.
1340      */
1341     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1342         assembly {
1343             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1344             owner := and(owner, _BITMASK_ADDRESS)
1345             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1346             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1347         }
1348     }
1349 
1350     /**
1351      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1352      */
1353     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1354         // For branchless setting of the `nextInitialized` flag.
1355         assembly {
1356             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1357             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1358         }
1359     }
1360 
1361     // =============================================================
1362     //                      APPROVAL OPERATIONS
1363     // =============================================================
1364 
1365     /**
1366      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1367      * The approval is cleared when the token is transferred.
1368      *
1369      * Only a single account can be approved at a time, so approving the
1370      * zero address clears previous approvals.
1371      *
1372      * Requirements:
1373      *
1374      * - The caller must own the token or be an approved operator.
1375      * - `tokenId` must exist.
1376      *
1377      * Emits an {Approval} event.
1378      */
1379     function approve(address to, uint256 tokenId) public payable virtual override {
1380         address owner = ownerOf(tokenId);
1381 
1382         if (_msgSenderERC721A() != owner)
1383             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1384                 revert ApprovalCallerNotOwnerNorApproved();
1385             }
1386 
1387         _tokenApprovals[tokenId].value = to;
1388         emit Approval(owner, to, tokenId);
1389     }
1390 
1391     /**
1392      * @dev Returns the account approved for `tokenId` token.
1393      *
1394      * Requirements:
1395      *
1396      * - `tokenId` must exist.
1397      */
1398     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1399         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1400 
1401         return _tokenApprovals[tokenId].value;
1402     }
1403 
1404     /**
1405      * @dev Approve or remove `operator` as an operator for the caller.
1406      * Operators can call {transferFrom} or {safeTransferFrom}
1407      * for any token owned by the caller.
1408      *
1409      * Requirements:
1410      *
1411      * - The `operator` cannot be the caller.
1412      *
1413      * Emits an {ApprovalForAll} event.
1414      */
1415     function setApprovalForAll(address operator, bool approved) public virtual override {
1416         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1417         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1418     }
1419 
1420     /**
1421      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1422      *
1423      * See {setApprovalForAll}.
1424      */
1425     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1426         return _operatorApprovals[owner][operator];
1427     }
1428 
1429     /**
1430      * @dev Returns whether `tokenId` exists.
1431      *
1432      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1433      *
1434      * Tokens start existing when they are minted. See {_mint}.
1435      */
1436     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1437         return
1438             _startTokenId() <= tokenId &&
1439             tokenId < _currentIndex && // If within bounds,
1440             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1441     }
1442 
1443     /**
1444      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1445      */
1446     function _isSenderApprovedOrOwner(
1447         address approvedAddress,
1448         address owner,
1449         address msgSender
1450     ) private pure returns (bool result) {
1451         assembly {
1452             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1453             owner := and(owner, _BITMASK_ADDRESS)
1454             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1455             msgSender := and(msgSender, _BITMASK_ADDRESS)
1456             // `msgSender == owner || msgSender == approvedAddress`.
1457             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1458         }
1459     }
1460 
1461     /**
1462      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1463      */
1464     function _getApprovedSlotAndAddress(uint256 tokenId)
1465         private
1466         view
1467         returns (uint256 approvedAddressSlot, address approvedAddress)
1468     {
1469         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1470         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1471         assembly {
1472             approvedAddressSlot := tokenApproval.slot
1473             approvedAddress := sload(approvedAddressSlot)
1474         }
1475     }
1476 
1477     // =============================================================
1478     //                      TRANSFER OPERATIONS
1479     // =============================================================
1480 
1481     /**
1482      * @dev Transfers `tokenId` from `from` to `to`.
1483      *
1484      * Requirements:
1485      *
1486      * - `from` cannot be the zero address.
1487      * - `to` cannot be the zero address.
1488      * - `tokenId` token must be owned by `from`.
1489      * - If the caller is not `from`, it must be approved to move this token
1490      * by either {approve} or {setApprovalForAll}.
1491      *
1492      * Emits a {Transfer} event.
1493      */
1494     function transferFrom(
1495         address from,
1496         address to,
1497         uint256 tokenId
1498     ) public payable virtual override {
1499         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1500 
1501         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1502 
1503         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1504 
1505         // The nested ifs save around 20+ gas over a compound boolean condition.
1506         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1507             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1508 
1509         if (to == address(0)) revert TransferToZeroAddress();
1510 
1511         _beforeTokenTransfers(from, to, tokenId, 1);
1512 
1513         // Clear approvals from the previous owner.
1514         assembly {
1515             if approvedAddress {
1516                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1517                 sstore(approvedAddressSlot, 0)
1518             }
1519         }
1520 
1521         // Underflow of the sender's balance is impossible because we check for
1522         // ownership above and the recipient's balance can't realistically overflow.
1523         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1524         unchecked {
1525             // We can directly increment and decrement the balances.
1526             --_packedAddressData[from]; // Updates: `balance -= 1`.
1527             ++_packedAddressData[to]; // Updates: `balance += 1`.
1528 
1529             // Updates:
1530             // - `address` to the next owner.
1531             // - `startTimestamp` to the timestamp of transfering.
1532             // - `burned` to `false`.
1533             // - `nextInitialized` to `true`.
1534             _packedOwnerships[tokenId] = _packOwnershipData(
1535                 to,
1536                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1537             );
1538 
1539             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1540             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1541                 uint256 nextTokenId = tokenId + 1;
1542                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1543                 if (_packedOwnerships[nextTokenId] == 0) {
1544                     // If the next slot is within bounds.
1545                     if (nextTokenId != _currentIndex) {
1546                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1547                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1548                     }
1549                 }
1550             }
1551         }
1552 
1553         emit Transfer(from, to, tokenId);
1554         _afterTokenTransfers(from, to, tokenId, 1);
1555     }
1556 
1557     /**
1558      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1559      */
1560     function safeTransferFrom(
1561         address from,
1562         address to,
1563         uint256 tokenId
1564     ) public payable virtual override {
1565         safeTransferFrom(from, to, tokenId, '');
1566     }
1567 
1568     /**
1569      * @dev Safely transfers `tokenId` token from `from` to `to`.
1570      *
1571      * Requirements:
1572      *
1573      * - `from` cannot be the zero address.
1574      * - `to` cannot be the zero address.
1575      * - `tokenId` token must exist and be owned by `from`.
1576      * - If the caller is not `from`, it must be approved to move this token
1577      * by either {approve} or {setApprovalForAll}.
1578      * - If `to` refers to a smart contract, it must implement
1579      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1580      *
1581      * Emits a {Transfer} event.
1582      */
1583     function safeTransferFrom(
1584         address from,
1585         address to,
1586         uint256 tokenId,
1587         bytes memory _data
1588     ) public payable virtual override {
1589         transferFrom(from, to, tokenId);
1590         if (to.code.length != 0)
1591             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1592                 revert TransferToNonERC721ReceiverImplementer();
1593             }
1594     }
1595 
1596     /**
1597      * @dev Hook that is called before a set of serially-ordered token IDs
1598      * are about to be transferred. This includes minting.
1599      * And also called before burning one token.
1600      *
1601      * `startTokenId` - the first token ID to be transferred.
1602      * `quantity` - the amount to be transferred.
1603      *
1604      * Calling conditions:
1605      *
1606      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1607      * transferred to `to`.
1608      * - When `from` is zero, `tokenId` will be minted for `to`.
1609      * - When `to` is zero, `tokenId` will be burned by `from`.
1610      * - `from` and `to` are never both zero.
1611      */
1612     function _beforeTokenTransfers(
1613         address from,
1614         address to,
1615         uint256 startTokenId,
1616         uint256 quantity
1617     ) internal virtual {}
1618 
1619     /**
1620      * @dev Hook that is called after a set of serially-ordered token IDs
1621      * have been transferred. This includes minting.
1622      * And also called after one token has been burned.
1623      *
1624      * `startTokenId` - the first token ID to be transferred.
1625      * `quantity` - the amount to be transferred.
1626      *
1627      * Calling conditions:
1628      *
1629      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1630      * transferred to `to`.
1631      * - When `from` is zero, `tokenId` has been minted for `to`.
1632      * - When `to` is zero, `tokenId` has been burned by `from`.
1633      * - `from` and `to` are never both zero.
1634      */
1635     function _afterTokenTransfers(
1636         address from,
1637         address to,
1638         uint256 startTokenId,
1639         uint256 quantity
1640     ) internal virtual {}
1641 
1642     /**
1643      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1644      *
1645      * `from` - Previous owner of the given token ID.
1646      * `to` - Target address that will receive the token.
1647      * `tokenId` - Token ID to be transferred.
1648      * `_data` - Optional data to send along with the call.
1649      *
1650      * Returns whether the call correctly returned the expected magic value.
1651      */
1652     function _checkContractOnERC721Received(
1653         address from,
1654         address to,
1655         uint256 tokenId,
1656         bytes memory _data
1657     ) private returns (bool) {
1658         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1659             bytes4 retval
1660         ) {
1661             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1662         } catch (bytes memory reason) {
1663             if (reason.length == 0) {
1664                 revert TransferToNonERC721ReceiverImplementer();
1665             } else {
1666                 assembly {
1667                     revert(add(32, reason), mload(reason))
1668                 }
1669             }
1670         }
1671     }
1672 
1673     // =============================================================
1674     //                        MINT OPERATIONS
1675     // =============================================================
1676 
1677     /**
1678      * @dev Mints `quantity` tokens and transfers them to `to`.
1679      *
1680      * Requirements:
1681      *
1682      * - `to` cannot be the zero address.
1683      * - `quantity` must be greater than 0.
1684      *
1685      * Emits a {Transfer} event for each mint.
1686      */
1687     function _mint(address to, uint256 quantity) internal virtual {
1688         uint256 startTokenId = _currentIndex;
1689         if (quantity == 0) revert MintZeroQuantity();
1690 
1691         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1692 
1693         // Overflows are incredibly unrealistic.
1694         // `balance` and `numberMinted` have a maximum limit of 2**64.
1695         // `tokenId` has a maximum limit of 2**256.
1696         unchecked {
1697             // Updates:
1698             // - `balance += quantity`.
1699             // - `numberMinted += quantity`.
1700             //
1701             // We can directly add to the `balance` and `numberMinted`.
1702             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1703 
1704             // Updates:
1705             // - `address` to the owner.
1706             // - `startTimestamp` to the timestamp of minting.
1707             // - `burned` to `false`.
1708             // - `nextInitialized` to `quantity == 1`.
1709             _packedOwnerships[startTokenId] = _packOwnershipData(
1710                 to,
1711                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1712             );
1713 
1714             uint256 toMasked;
1715             uint256 end = startTokenId + quantity;
1716 
1717             // Use assembly to loop and emit the `Transfer` event for gas savings.
1718             // The duplicated `log4` removes an extra check and reduces stack juggling.
1719             // The assembly, together with the surrounding Solidity code, have been
1720             // delicately arranged to nudge the compiler into producing optimized opcodes.
1721             assembly {
1722                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1723                 toMasked := and(to, _BITMASK_ADDRESS)
1724                 // Emit the `Transfer` event.
1725                 log4(
1726                     0, // Start of data (0, since no data).
1727                     0, // End of data (0, since no data).
1728                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1729                     0, // `address(0)`.
1730                     toMasked, // `to`.
1731                     startTokenId // `tokenId`.
1732                 )
1733 
1734                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1735                 // that overflows uint256 will make the loop run out of gas.
1736                 // The compiler will optimize the `iszero` away for performance.
1737                 for {
1738                     let tokenId := add(startTokenId, 1)
1739                 } iszero(eq(tokenId, end)) {
1740                     tokenId := add(tokenId, 1)
1741                 } {
1742                     // Emit the `Transfer` event. Similar to above.
1743                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1744                 }
1745             }
1746             if (toMasked == 0) revert MintToZeroAddress();
1747 
1748             _currentIndex = end;
1749         }
1750         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1751     }
1752 
1753     /**
1754      * @dev Mints `quantity` tokens and transfers them to `to`.
1755      *
1756      * This function is intended for efficient minting only during contract creation.
1757      *
1758      * It emits only one {ConsecutiveTransfer} as defined in
1759      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1760      * instead of a sequence of {Transfer} event(s).
1761      *
1762      * Calling this function outside of contract creation WILL make your contract
1763      * non-compliant with the ERC721 standard.
1764      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1765      * {ConsecutiveTransfer} event is only permissible during contract creation.
1766      *
1767      * Requirements:
1768      *
1769      * - `to` cannot be the zero address.
1770      * - `quantity` must be greater than 0.
1771      *
1772      * Emits a {ConsecutiveTransfer} event.
1773      */
1774     function _mintERC2309(address to, uint256 quantity) internal virtual {
1775         uint256 startTokenId = _currentIndex;
1776         if (to == address(0)) revert MintToZeroAddress();
1777         if (quantity == 0) revert MintZeroQuantity();
1778         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1779 
1780         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1781 
1782         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1783         unchecked {
1784             // Updates:
1785             // - `balance += quantity`.
1786             // - `numberMinted += quantity`.
1787             //
1788             // We can directly add to the `balance` and `numberMinted`.
1789             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1790 
1791             // Updates:
1792             // - `address` to the owner.
1793             // - `startTimestamp` to the timestamp of minting.
1794             // - `burned` to `false`.
1795             // - `nextInitialized` to `quantity == 1`.
1796             _packedOwnerships[startTokenId] = _packOwnershipData(
1797                 to,
1798                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1799             );
1800 
1801             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1802 
1803             _currentIndex = startTokenId + quantity;
1804         }
1805         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1806     }
1807 
1808     /**
1809      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1810      *
1811      * Requirements:
1812      *
1813      * - If `to` refers to a smart contract, it must implement
1814      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1815      * - `quantity` must be greater than 0.
1816      *
1817      * See {_mint}.
1818      *
1819      * Emits a {Transfer} event for each mint.
1820      */
1821     function _safeMint(
1822         address to,
1823         uint256 quantity,
1824         bytes memory _data
1825     ) internal virtual {
1826         _mint(to, quantity);
1827 
1828         unchecked {
1829             if (to.code.length != 0) {
1830                 uint256 end = _currentIndex;
1831                 uint256 index = end - quantity;
1832                 do {
1833                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1834                         revert TransferToNonERC721ReceiverImplementer();
1835                     }
1836                 } while (index < end);
1837                 // Reentrancy protection.
1838                 if (_currentIndex != end) revert();
1839             }
1840         }
1841     }
1842 
1843     /**
1844      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1845      */
1846     function _safeMint(address to, uint256 quantity) internal virtual {
1847         _safeMint(to, quantity, '');
1848     }
1849 
1850     // =============================================================
1851     //                        BURN OPERATIONS
1852     // =============================================================
1853 
1854     /**
1855      * @dev Equivalent to `_burn(tokenId, false)`.
1856      */
1857     function _burn(uint256 tokenId) internal virtual {
1858         _burn(tokenId, false);
1859     }
1860 
1861     /**
1862      * @dev Destroys `tokenId`.
1863      * The approval is cleared when the token is burned.
1864      *
1865      * Requirements:
1866      *
1867      * - `tokenId` must exist.
1868      *
1869      * Emits a {Transfer} event.
1870      */
1871     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1872         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1873 
1874         address from = address(uint160(prevOwnershipPacked));
1875 
1876         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1877 
1878         if (approvalCheck) {
1879             // The nested ifs save around 20+ gas over a compound boolean condition.
1880             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1881                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1882         }
1883 
1884         _beforeTokenTransfers(from, address(0), tokenId, 1);
1885 
1886         // Clear approvals from the previous owner.
1887         assembly {
1888             if approvedAddress {
1889                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1890                 sstore(approvedAddressSlot, 0)
1891             }
1892         }
1893 
1894         // Underflow of the sender's balance is impossible because we check for
1895         // ownership above and the recipient's balance can't realistically overflow.
1896         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1897         unchecked {
1898             // Updates:
1899             // - `balance -= 1`.
1900             // - `numberBurned += 1`.
1901             //
1902             // We can directly decrement the balance, and increment the number burned.
1903             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1904             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1905 
1906             // Updates:
1907             // - `address` to the last owner.
1908             // - `startTimestamp` to the timestamp of burning.
1909             // - `burned` to `true`.
1910             // - `nextInitialized` to `true`.
1911             _packedOwnerships[tokenId] = _packOwnershipData(
1912                 from,
1913                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1914             );
1915 
1916             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1917             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1918                 uint256 nextTokenId = tokenId + 1;
1919                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1920                 if (_packedOwnerships[nextTokenId] == 0) {
1921                     // If the next slot is within bounds.
1922                     if (nextTokenId != _currentIndex) {
1923                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1924                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1925                     }
1926                 }
1927             }
1928         }
1929 
1930         emit Transfer(from, address(0), tokenId);
1931         _afterTokenTransfers(from, address(0), tokenId, 1);
1932 
1933         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1934         unchecked {
1935             _burnCounter++;
1936         }
1937     }
1938 
1939     // =============================================================
1940     //                     EXTRA DATA OPERATIONS
1941     // =============================================================
1942 
1943     /**
1944      * @dev Directly sets the extra data for the ownership data `index`.
1945      */
1946     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1947         uint256 packed = _packedOwnerships[index];
1948         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1949         uint256 extraDataCasted;
1950         // Cast `extraData` with assembly to avoid redundant masking.
1951         assembly {
1952             extraDataCasted := extraData
1953         }
1954         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1955         _packedOwnerships[index] = packed;
1956     }
1957 
1958     /**
1959      * @dev Called during each token transfer to set the 24bit `extraData` field.
1960      * Intended to be overridden by the cosumer contract.
1961      *
1962      * `previousExtraData` - the value of `extraData` before transfer.
1963      *
1964      * Calling conditions:
1965      *
1966      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1967      * transferred to `to`.
1968      * - When `from` is zero, `tokenId` will be minted for `to`.
1969      * - When `to` is zero, `tokenId` will be burned by `from`.
1970      * - `from` and `to` are never both zero.
1971      */
1972     function _extraData(
1973         address from,
1974         address to,
1975         uint24 previousExtraData
1976     ) internal view virtual returns (uint24) {}
1977 
1978     /**
1979      * @dev Returns the next extra data for the packed ownership data.
1980      * The returned result is shifted into position.
1981      */
1982     function _nextExtraData(
1983         address from,
1984         address to,
1985         uint256 prevOwnershipPacked
1986     ) private view returns (uint256) {
1987         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1988         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1989     }
1990 
1991     // =============================================================
1992     //                       OTHER OPERATIONS
1993     // =============================================================
1994 
1995     /**
1996      * @dev Returns the message sender (defaults to `msg.sender`).
1997      *
1998      * If you are writing GSN compatible contracts, you need to override this function.
1999      */
2000     function _msgSenderERC721A() internal view virtual returns (address) {
2001         return msg.sender;
2002     }
2003 
2004     /**
2005      * @dev Converts a uint256 to its ASCII string decimal representation.
2006      */
2007     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2008         assembly {
2009             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2010             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2011             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2012             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2013             let m := add(mload(0x40), 0xa0)
2014             // Update the free memory pointer to allocate.
2015             mstore(0x40, m)
2016             // Assign the `str` to the end.
2017             str := sub(m, 0x20)
2018             // Zeroize the slot after the string.
2019             mstore(str, 0)
2020 
2021             // Cache the end of the memory to calculate the length later.
2022             let end := str
2023 
2024             // We write the string from rightmost digit to leftmost digit.
2025             // The following is essentially a do-while loop that also handles the zero case.
2026             // prettier-ignore
2027             for { let temp := value } 1 {} {
2028                 str := sub(str, 1)
2029                 // Write the character to the pointer.
2030                 // The ASCII index of the '0' character is 48.
2031                 mstore8(str, add(48, mod(temp, 10)))
2032                 // Keep dividing `temp` until zero.
2033                 temp := div(temp, 10)
2034                 // prettier-ignore
2035                 if iszero(temp) { break }
2036             }
2037 
2038             let length := sub(end, str)
2039             // Move the pointer 32 bytes leftwards to make room for the length.
2040             str := sub(str, 0x20)
2041             // Store the length.
2042             mstore(str, length)
2043         }
2044     }
2045 }
2046 
2047 // File: contracts/Illuminati.sol
2048 
2049 
2050 
2051 pragma solidity >=0.8.9 <0.9.0;
2052 
2053 
2054 
2055 
2056 
2057 contract ShadowsofIlluminati is ERC721A, Ownable, ReentrancyGuard {
2058 
2059   using Strings for uint;
2060 
2061   string public uriPrefix = '';
2062   string public hiddenMetadataUri;
2063   string public uriSuffix = '.json';
2064   
2065   
2066   uint public maxSupply = 4444;
2067   uint public freeSupply = 4444;
2068   uint public cost = 0.003 ether;
2069   uint public maxMintAmountPerTx = 10;
2070   uint public maxPerWallet = 20;
2071 
2072   bool public paused = true;
2073   bool public revealed = false;
2074 
2075   mapping(address => bool) public freeMintClaimed;
2076 
2077 
2078   constructor(
2079     string memory _tokenName,
2080     string memory _tokenSymbol,
2081     string memory _hiddenMetadataUri
2082   ) ERC721A(_tokenName, _tokenSymbol) {
2083     setHiddenMetadataUri(_hiddenMetadataUri);
2084   }
2085 
2086   // ~~~~~~~~~~~~~~~~~~~~ Modifiers ~~~~~~~~~~~~~~~~~~~~
2087   modifier mintCompliance(uint _mintAmount) {
2088     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2089     require(_mintAmount + balanceOf(_msgSender()) <= maxPerWallet, 'Only 10 allowed per wallet!');
2090     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2091     _;
2092   }
2093 
2094   modifier mintPriceCompliance(uint _mintAmount) {
2095     if (freeMintClaimed[_msgSender()] || totalSupply() >= freeSupply) {
2096       require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
2097     }
2098     _;
2099   }
2100 
2101   // ~~~~~~~~~~~~~~~~~~~~ Mint Functions ~~~~~~~~~~~~~~~~~~~~
2102 
2103      function Mint(uint256 amount) external payable {
2104         require(!paused, "contract is paused");
2105 
2106         require(totalSupply() + amount <= maxSupply, "max supply would be exceeded");
2107         uint minted = _numberMinted(msg.sender);
2108 
2109         require(minted + amount <= maxPerWallet, "max mint per wallet would be exceeded");
2110 
2111         uint chargeableCount;
2112 
2113         if (minted == 0) {
2114             chargeableCount = amount - 1;
2115             require(amount > 0, "amount must be greater than 0");
2116             require(msg.value >= cost * chargeableCount, "value not met");
2117         } else {
2118             chargeableCount = amount;
2119             require(amount > 0, "amount must be greater than 0");
2120             require(msg.value >= cost * chargeableCount, "value not met");
2121         }
2122         _safeMint(msg.sender, amount);
2123     }
2124   
2125   // ~~~~~~~~~~~~~~~~~~~~ Various Checks ~~~~~~~~~~~~~~~~~~~~
2126     function _baseURI() internal view virtual override returns (string memory) {
2127     return uriPrefix;
2128   }
2129 
2130   function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
2131     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2132 
2133     if (revealed == false) {
2134       return hiddenMetadataUri;
2135     }
2136 
2137     string memory currentBaseURI = _baseURI();
2138     return bytes(currentBaseURI).length > 0
2139         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2140         : '';
2141   }
2142 
2143   // ~~~~~~~~~~~~~~~~~~~~ onlyOwner Functions ~~~~~~~~~~~~~~~~~~~~
2144 
2145       function mintForAddress(uint256 _mintAmount, address _receiver) external onlyOwner {
2146         require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
2147         _safeMint(_receiver, _mintAmount);
2148     }
2149 
2150   function setRevealed(bool _state) public onlyOwner {
2151     revealed = _state;
2152   }
2153 
2154   function setCost(uint _cost) public onlyOwner {
2155     cost = _cost;
2156   }
2157 
2158   function setMaxMintAmountPerTx(uint _maxMintAmountPerTx) public onlyOwner {
2159     maxMintAmountPerTx = _maxMintAmountPerTx;
2160   }
2161 
2162   function setmaxPerWallet(uint _maxPerWallet) public onlyOwner {
2163     maxPerWallet = _maxPerWallet;
2164   }
2165 
2166     function setmaxSupply(uint _maxSupply) public onlyOwner {
2167     maxSupply = _maxSupply;
2168   }
2169 
2170   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2171     hiddenMetadataUri = _hiddenMetadataUri;
2172   }
2173 
2174   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2175     uriPrefix = _uriPrefix;
2176   }
2177 
2178   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2179     uriSuffix = _uriSuffix;
2180   }
2181 
2182   function setPaused(bool _state) public onlyOwner {
2183     paused = _state;
2184   }
2185 
2186   function setFreeSupply(uint _freeQty) public onlyOwner {
2187     freeSupply = _freeQty;
2188   }
2189 
2190 
2191   // ~~~~~~~~~~~~~~~~~~~~ Withdraw Functions ~~~~~~~~~~~~~~~~~~~~
2192   function withdraw() public onlyOwner nonReentrant {
2193     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2194     require(os);
2195   }
2196 /*
2197 
2198 */
2199 }