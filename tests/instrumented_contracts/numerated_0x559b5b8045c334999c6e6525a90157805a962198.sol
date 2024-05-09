1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
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
71 
72     /**
73      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
74      * `nonReentrant` function in the call stack.
75      */
76     function _reentrancyGuardEntered() internal view returns (bool) {
77         return _status == _ENTERED;
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Standard signed math utilities missing in the Solidity language.
90  */
91 library SignedMath {
92     /**
93      * @dev Returns the largest of two signed numbers.
94      */
95     function max(int256 a, int256 b) internal pure returns (int256) {
96         return a > b ? a : b;
97     }
98 
99     /**
100      * @dev Returns the smallest of two signed numbers.
101      */
102     function min(int256 a, int256 b) internal pure returns (int256) {
103         return a < b ? a : b;
104     }
105 
106     /**
107      * @dev Returns the average of two signed numbers without overflow.
108      * The result is rounded towards zero.
109      */
110     function average(int256 a, int256 b) internal pure returns (int256) {
111         // Formula from the book "Hacker's Delight"
112         int256 x = (a & b) + ((a ^ b) >> 1);
113         return x + (int256(uint256(x) >> 255) & (a ^ b));
114     }
115 
116     /**
117      * @dev Returns the absolute unsigned value of a signed value.
118      */
119     function abs(int256 n) internal pure returns (uint256) {
120         unchecked {
121             // must be unchecked in order to support `n = type(int256).min`
122             return uint256(n >= 0 ? n : -n);
123         }
124     }
125 }
126 
127 // File: @openzeppelin/contracts/utils/math/Math.sol
128 
129 
130 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Standard math utilities missing in the Solidity language.
136  */
137 library Math {
138     enum Rounding {
139         Down, // Toward negative infinity
140         Up, // Toward infinity
141         Zero // Toward zero
142     }
143 
144     /**
145      * @dev Returns the largest of two numbers.
146      */
147     function max(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a > b ? a : b;
149     }
150 
151     /**
152      * @dev Returns the smallest of two numbers.
153      */
154     function min(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a < b ? a : b;
156     }
157 
158     /**
159      * @dev Returns the average of two numbers. The result is rounded towards
160      * zero.
161      */
162     function average(uint256 a, uint256 b) internal pure returns (uint256) {
163         // (a + b) / 2 can overflow.
164         return (a & b) + (a ^ b) / 2;
165     }
166 
167     /**
168      * @dev Returns the ceiling of the division of two numbers.
169      *
170      * This differs from standard division with `/` in that it rounds up instead
171      * of rounding down.
172      */
173     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
174         // (a + b - 1) / b can overflow on addition, so we distribute.
175         return a == 0 ? 0 : (a - 1) / b + 1;
176     }
177 
178     /**
179      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
180      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
181      * with further edits by Uniswap Labs also under MIT license.
182      */
183     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
184         unchecked {
185             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
186             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
187             // variables such that product = prod1 * 2^256 + prod0.
188             uint256 prod0; // Least significant 256 bits of the product
189             uint256 prod1; // Most significant 256 bits of the product
190             assembly {
191                 let mm := mulmod(x, y, not(0))
192                 prod0 := mul(x, y)
193                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
194             }
195 
196             // Handle non-overflow cases, 256 by 256 division.
197             if (prod1 == 0) {
198                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
199                 // The surrounding unchecked block does not change this fact.
200                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
201                 return prod0 / denominator;
202             }
203 
204             // Make sure the result is less than 2^256. Also prevents denominator == 0.
205             require(denominator > prod1, "Math: mulDiv overflow");
206 
207             ///////////////////////////////////////////////
208             // 512 by 256 division.
209             ///////////////////////////////////////////////
210 
211             // Make division exact by subtracting the remainder from [prod1 prod0].
212             uint256 remainder;
213             assembly {
214                 // Compute remainder using mulmod.
215                 remainder := mulmod(x, y, denominator)
216 
217                 // Subtract 256 bit number from 512 bit number.
218                 prod1 := sub(prod1, gt(remainder, prod0))
219                 prod0 := sub(prod0, remainder)
220             }
221 
222             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
223             // See https://cs.stackexchange.com/q/138556/92363.
224 
225             // Does not overflow because the denominator cannot be zero at this stage in the function.
226             uint256 twos = denominator & (~denominator + 1);
227             assembly {
228                 // Divide denominator by twos.
229                 denominator := div(denominator, twos)
230 
231                 // Divide [prod1 prod0] by twos.
232                 prod0 := div(prod0, twos)
233 
234                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
235                 twos := add(div(sub(0, twos), twos), 1)
236             }
237 
238             // Shift in bits from prod1 into prod0.
239             prod0 |= prod1 * twos;
240 
241             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
242             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
243             // four bits. That is, denominator * inv = 1 mod 2^4.
244             uint256 inverse = (3 * denominator) ^ 2;
245 
246             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
247             // in modular arithmetic, doubling the correct bits in each step.
248             inverse *= 2 - denominator * inverse; // inverse mod 2^8
249             inverse *= 2 - denominator * inverse; // inverse mod 2^16
250             inverse *= 2 - denominator * inverse; // inverse mod 2^32
251             inverse *= 2 - denominator * inverse; // inverse mod 2^64
252             inverse *= 2 - denominator * inverse; // inverse mod 2^128
253             inverse *= 2 - denominator * inverse; // inverse mod 2^256
254 
255             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
256             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
257             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
258             // is no longer required.
259             result = prod0 * inverse;
260             return result;
261         }
262     }
263 
264     /**
265      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
266      */
267     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
268         uint256 result = mulDiv(x, y, denominator);
269         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
270             result += 1;
271         }
272         return result;
273     }
274 
275     /**
276      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
277      *
278      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
279      */
280     function sqrt(uint256 a) internal pure returns (uint256) {
281         if (a == 0) {
282             return 0;
283         }
284 
285         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
286         //
287         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
288         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
289         //
290         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
291         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
292         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
293         //
294         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
295         uint256 result = 1 << (log2(a) >> 1);
296 
297         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
298         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
299         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
300         // into the expected uint128 result.
301         unchecked {
302             result = (result + a / result) >> 1;
303             result = (result + a / result) >> 1;
304             result = (result + a / result) >> 1;
305             result = (result + a / result) >> 1;
306             result = (result + a / result) >> 1;
307             result = (result + a / result) >> 1;
308             result = (result + a / result) >> 1;
309             return min(result, a / result);
310         }
311     }
312 
313     /**
314      * @notice Calculates sqrt(a), following the selected rounding direction.
315      */
316     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
317         unchecked {
318             uint256 result = sqrt(a);
319             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
320         }
321     }
322 
323     /**
324      * @dev Return the log in base 2, rounded down, of a positive value.
325      * Returns 0 if given 0.
326      */
327     function log2(uint256 value) internal pure returns (uint256) {
328         uint256 result = 0;
329         unchecked {
330             if (value >> 128 > 0) {
331                 value >>= 128;
332                 result += 128;
333             }
334             if (value >> 64 > 0) {
335                 value >>= 64;
336                 result += 64;
337             }
338             if (value >> 32 > 0) {
339                 value >>= 32;
340                 result += 32;
341             }
342             if (value >> 16 > 0) {
343                 value >>= 16;
344                 result += 16;
345             }
346             if (value >> 8 > 0) {
347                 value >>= 8;
348                 result += 8;
349             }
350             if (value >> 4 > 0) {
351                 value >>= 4;
352                 result += 4;
353             }
354             if (value >> 2 > 0) {
355                 value >>= 2;
356                 result += 2;
357             }
358             if (value >> 1 > 0) {
359                 result += 1;
360             }
361         }
362         return result;
363     }
364 
365     /**
366      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
367      * Returns 0 if given 0.
368      */
369     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
370         unchecked {
371             uint256 result = log2(value);
372             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
373         }
374     }
375 
376     /**
377      * @dev Return the log in base 10, rounded down, of a positive value.
378      * Returns 0 if given 0.
379      */
380     function log10(uint256 value) internal pure returns (uint256) {
381         uint256 result = 0;
382         unchecked {
383             if (value >= 10 ** 64) {
384                 value /= 10 ** 64;
385                 result += 64;
386             }
387             if (value >= 10 ** 32) {
388                 value /= 10 ** 32;
389                 result += 32;
390             }
391             if (value >= 10 ** 16) {
392                 value /= 10 ** 16;
393                 result += 16;
394             }
395             if (value >= 10 ** 8) {
396                 value /= 10 ** 8;
397                 result += 8;
398             }
399             if (value >= 10 ** 4) {
400                 value /= 10 ** 4;
401                 result += 4;
402             }
403             if (value >= 10 ** 2) {
404                 value /= 10 ** 2;
405                 result += 2;
406             }
407             if (value >= 10 ** 1) {
408                 result += 1;
409             }
410         }
411         return result;
412     }
413 
414     /**
415      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
416      * Returns 0 if given 0.
417      */
418     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
419         unchecked {
420             uint256 result = log10(value);
421             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
422         }
423     }
424 
425     /**
426      * @dev Return the log in base 256, rounded down, of a positive value.
427      * Returns 0 if given 0.
428      *
429      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
430      */
431     function log256(uint256 value) internal pure returns (uint256) {
432         uint256 result = 0;
433         unchecked {
434             if (value >> 128 > 0) {
435                 value >>= 128;
436                 result += 16;
437             }
438             if (value >> 64 > 0) {
439                 value >>= 64;
440                 result += 8;
441             }
442             if (value >> 32 > 0) {
443                 value >>= 32;
444                 result += 4;
445             }
446             if (value >> 16 > 0) {
447                 value >>= 16;
448                 result += 2;
449             }
450             if (value >> 8 > 0) {
451                 result += 1;
452             }
453         }
454         return result;
455     }
456 
457     /**
458      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
459      * Returns 0 if given 0.
460      */
461     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
462         unchecked {
463             uint256 result = log256(value);
464             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
465         }
466     }
467 }
468 
469 // File: @openzeppelin/contracts/utils/Strings.sol
470 
471 
472 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 
477 
478 /**
479  * @dev String operations.
480  */
481 library Strings {
482     bytes16 private constant _SYMBOLS = "0123456789abcdef";
483     uint8 private constant _ADDRESS_LENGTH = 20;
484 
485     /**
486      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
487      */
488     function toString(uint256 value) internal pure returns (string memory) {
489         unchecked {
490             uint256 length = Math.log10(value) + 1;
491             string memory buffer = new string(length);
492             uint256 ptr;
493             /// @solidity memory-safe-assembly
494             assembly {
495                 ptr := add(buffer, add(32, length))
496             }
497             while (true) {
498                 ptr--;
499                 /// @solidity memory-safe-assembly
500                 assembly {
501                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
502                 }
503                 value /= 10;
504                 if (value == 0) break;
505             }
506             return buffer;
507         }
508     }
509 
510     /**
511      * @dev Converts a `int256` to its ASCII `string` decimal representation.
512      */
513     function toString(int256 value) internal pure returns (string memory) {
514         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
515     }
516 
517     /**
518      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
519      */
520     function toHexString(uint256 value) internal pure returns (string memory) {
521         unchecked {
522             return toHexString(value, Math.log256(value) + 1);
523         }
524     }
525 
526     /**
527      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
528      */
529     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
530         bytes memory buffer = new bytes(2 * length + 2);
531         buffer[0] = "0";
532         buffer[1] = "x";
533         for (uint256 i = 2 * length + 1; i > 1; --i) {
534             buffer[i] = _SYMBOLS[value & 0xf];
535             value >>= 4;
536         }
537         require(value == 0, "Strings: hex length insufficient");
538         return string(buffer);
539     }
540 
541     /**
542      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
543      */
544     function toHexString(address addr) internal pure returns (string memory) {
545         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
546     }
547 
548     /**
549      * @dev Returns true if the two strings are equal.
550      */
551     function equal(string memory a, string memory b) internal pure returns (bool) {
552         return keccak256(bytes(a)) == keccak256(bytes(b));
553     }
554 }
555 
556 // File: @openzeppelin/contracts/utils/Context.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev Provides information about the current execution context, including the
565  * sender of the transaction and its data. While these are generally available
566  * via msg.sender and msg.data, they should not be accessed in such a direct
567  * manner, since when dealing with meta-transactions the account sending and
568  * paying for execution may not be the actual sender (as far as an application
569  * is concerned).
570  *
571  * This contract is only required for intermediate, library-like contracts.
572  */
573 abstract contract Context {
574     function _msgSender() internal view virtual returns (address) {
575         return msg.sender;
576     }
577 
578     function _msgData() internal view virtual returns (bytes calldata) {
579         return msg.data;
580     }
581 }
582 
583 // File: @openzeppelin/contracts/access/Ownable.sol
584 
585 
586 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @dev Contract module which provides a basic access control mechanism, where
593  * there is an account (an owner) that can be granted exclusive access to
594  * specific functions.
595  *
596  * By default, the owner account will be the one that deploys the contract. This
597  * can later be changed with {transferOwnership}.
598  *
599  * This module is used through inheritance. It will make available the modifier
600  * `onlyOwner`, which can be applied to your functions to restrict their use to
601  * the owner.
602  */
603 abstract contract Ownable is Context {
604     address private _owner;
605 
606     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
607 
608     /**
609      * @dev Initializes the contract setting the deployer as the initial owner.
610      */
611     constructor() {
612         _transferOwnership(_msgSender());
613     }
614 
615     /**
616      * @dev Throws if called by any account other than the owner.
617      */
618     modifier onlyOwner() {
619         _checkOwner();
620         _;
621     }
622 
623     /**
624      * @dev Returns the address of the current owner.
625      */
626     function owner() public view virtual returns (address) {
627         return _owner;
628     }
629 
630     /**
631      * @dev Throws if the sender is not the owner.
632      */
633     function _checkOwner() internal view virtual {
634         require(owner() == _msgSender(), "Ownable: caller is not the owner");
635     }
636 
637     /**
638      * @dev Leaves the contract without owner. It will not be possible to call
639      * `onlyOwner` functions. Can only be called by the current owner.
640      *
641      * NOTE: Renouncing ownership will leave the contract without an owner,
642      * thereby disabling any functionality that is only available to the owner.
643      */
644     function renounceOwnership() public virtual onlyOwner {
645         _transferOwnership(address(0));
646     }
647 
648     /**
649      * @dev Transfers ownership of the contract to a new account (`newOwner`).
650      * Can only be called by the current owner.
651      */
652     function transferOwnership(address newOwner) public virtual onlyOwner {
653         require(newOwner != address(0), "Ownable: new owner is the zero address");
654         _transferOwnership(newOwner);
655     }
656 
657     /**
658      * @dev Transfers ownership of the contract to a new account (`newOwner`).
659      * Internal function without access restriction.
660      */
661     function _transferOwnership(address newOwner) internal virtual {
662         address oldOwner = _owner;
663         _owner = newOwner;
664         emit OwnershipTransferred(oldOwner, newOwner);
665     }
666 }
667 
668 // File: erc721a/contracts/IERC721A.sol
669 
670 
671 // ERC721A Contracts v4.2.3
672 // Creator: Chiru Labs
673 
674 pragma solidity ^0.8.4;
675 
676 /**
677  * @dev Interface of ERC721A.
678  */
679 interface IERC721A {
680     /**
681      * The caller must own the token or be an approved operator.
682      */
683     error ApprovalCallerNotOwnerNorApproved();
684 
685     /**
686      * The token does not exist.
687      */
688     error ApprovalQueryForNonexistentToken();
689 
690     /**
691      * Cannot query the balance for the zero address.
692      */
693     error BalanceQueryForZeroAddress();
694 
695     /**
696      * Cannot mint to the zero address.
697      */
698     error MintToZeroAddress();
699 
700     /**
701      * The quantity of tokens minted must be more than zero.
702      */
703     error MintZeroQuantity();
704 
705     /**
706      * The token does not exist.
707      */
708     error OwnerQueryForNonexistentToken();
709 
710     /**
711      * The caller must own the token or be an approved operator.
712      */
713     error TransferCallerNotOwnerNorApproved();
714 
715     /**
716      * The token must be owned by `from`.
717      */
718     error TransferFromIncorrectOwner();
719 
720     /**
721      * Cannot safely transfer to a contract that does not implement the
722      * ERC721Receiver interface.
723      */
724     error TransferToNonERC721ReceiverImplementer();
725 
726     /**
727      * Cannot transfer to the zero address.
728      */
729     error TransferToZeroAddress();
730 
731     /**
732      * The token does not exist.
733      */
734     error URIQueryForNonexistentToken();
735 
736     /**
737      * The `quantity` minted with ERC2309 exceeds the safety limit.
738      */
739     error MintERC2309QuantityExceedsLimit();
740 
741     /**
742      * The `extraData` cannot be set on an unintialized ownership slot.
743      */
744     error OwnershipNotInitializedForExtraData();
745 
746     // =============================================================
747     //                            STRUCTS
748     // =============================================================
749 
750     struct TokenOwnership {
751         // The address of the owner.
752         address addr;
753         // Stores the start time of ownership with minimal overhead for tokenomics.
754         uint64 startTimestamp;
755         // Whether the token has been burned.
756         bool burned;
757         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
758         uint24 extraData;
759     }
760 
761     // =============================================================
762     //                         TOKEN COUNTERS
763     // =============================================================
764 
765     /**
766      * @dev Returns the total number of tokens in existence.
767      * Burned tokens will reduce the count.
768      * To get the total number of tokens minted, please see {_totalMinted}.
769      */
770     function totalSupply() external view returns (uint256);
771 
772     // =============================================================
773     //                            IERC165
774     // =============================================================
775 
776     /**
777      * @dev Returns true if this contract implements the interface defined by
778      * `interfaceId`. See the corresponding
779      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
780      * to learn more about how these ids are created.
781      *
782      * This function call must use less than 30000 gas.
783      */
784     function supportsInterface(bytes4 interfaceId) external view returns (bool);
785 
786     // =============================================================
787     //                            IERC721
788     // =============================================================
789 
790     /**
791      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
792      */
793     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
794 
795     /**
796      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
797      */
798     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
799 
800     /**
801      * @dev Emitted when `owner` enables or disables
802      * (`approved`) `operator` to manage all of its assets.
803      */
804     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
805 
806     /**
807      * @dev Returns the number of tokens in `owner`'s account.
808      */
809     function balanceOf(address owner) external view returns (uint256 balance);
810 
811     /**
812      * @dev Returns the owner of the `tokenId` token.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must exist.
817      */
818     function ownerOf(uint256 tokenId) external view returns (address owner);
819 
820     /**
821      * @dev Safely transfers `tokenId` token from `from` to `to`,
822      * checking first that contract recipients are aware of the ERC721 protocol
823      * to prevent tokens from being forever locked.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must exist and be owned by `from`.
830      * - If the caller is not `from`, it must be have been allowed to move
831      * this token by either {approve} or {setApprovalForAll}.
832      * - If `to` refers to a smart contract, it must implement
833      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function safeTransferFrom(
838         address from,
839         address to,
840         uint256 tokenId,
841         bytes calldata data
842     ) external payable;
843 
844     /**
845      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
846      */
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) external payable;
852 
853     /**
854      * @dev Transfers `tokenId` from `from` to `to`.
855      *
856      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
857      * whenever possible.
858      *
859      * Requirements:
860      *
861      * - `from` cannot be the zero address.
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must be owned by `from`.
864      * - If the caller is not `from`, it must be approved to move this token
865      * by either {approve} or {setApprovalForAll}.
866      *
867      * Emits a {Transfer} event.
868      */
869     function transferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) external payable;
874 
875     /**
876      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
877      * The approval is cleared when the token is transferred.
878      *
879      * Only a single account can be approved at a time, so approving the
880      * zero address clears previous approvals.
881      *
882      * Requirements:
883      *
884      * - The caller must own the token or be an approved operator.
885      * - `tokenId` must exist.
886      *
887      * Emits an {Approval} event.
888      */
889     function approve(address to, uint256 tokenId) external payable;
890 
891     /**
892      * @dev Approve or remove `operator` as an operator for the caller.
893      * Operators can call {transferFrom} or {safeTransferFrom}
894      * for any token owned by the caller.
895      *
896      * Requirements:
897      *
898      * - The `operator` cannot be the caller.
899      *
900      * Emits an {ApprovalForAll} event.
901      */
902     function setApprovalForAll(address operator, bool _approved) external;
903 
904     /**
905      * @dev Returns the account approved for `tokenId` token.
906      *
907      * Requirements:
908      *
909      * - `tokenId` must exist.
910      */
911     function getApproved(uint256 tokenId) external view returns (address operator);
912 
913     /**
914      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
915      *
916      * See {setApprovalForAll}.
917      */
918     function isApprovedForAll(address owner, address operator) external view returns (bool);
919 
920     // =============================================================
921     //                        IERC721Metadata
922     // =============================================================
923 
924     /**
925      * @dev Returns the token collection name.
926      */
927     function name() external view returns (string memory);
928 
929     /**
930      * @dev Returns the token collection symbol.
931      */
932     function symbol() external view returns (string memory);
933 
934     /**
935      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
936      */
937     function tokenURI(uint256 tokenId) external view returns (string memory);
938 
939     // =============================================================
940     //                           IERC2309
941     // =============================================================
942 
943     /**
944      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
945      * (inclusive) is transferred from `from` to `to`, as defined in the
946      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
947      *
948      * See {_mintERC2309} for more details.
949      */
950     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
951 }
952 
953 // File: erc721a/contracts/ERC721A.sol
954 
955 
956 // ERC721A Contracts v4.2.3
957 // Creator: Chiru Labs
958 
959 pragma solidity ^0.8.4;
960 
961 
962 /**
963  * @dev Interface of ERC721 token receiver.
964  */
965 interface ERC721A__IERC721Receiver {
966     function onERC721Received(
967         address operator,
968         address from,
969         uint256 tokenId,
970         bytes calldata data
971     ) external returns (bytes4);
972 }
973 
974 /**
975  * @title ERC721A
976  *
977  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
978  * Non-Fungible Token Standard, including the Metadata extension.
979  * Optimized for lower gas during batch mints.
980  *
981  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
982  * starting from `_startTokenId()`.
983  *
984  * Assumptions:
985  *
986  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
987  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
988  */
989 contract ERC721A is IERC721A {
990     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
991     struct TokenApprovalRef {
992         address value;
993     }
994 
995     // =============================================================
996     //                           CONSTANTS
997     // =============================================================
998 
999     // Mask of an entry in packed address data.
1000     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1001 
1002     // The bit position of `numberMinted` in packed address data.
1003     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1004 
1005     // The bit position of `numberBurned` in packed address data.
1006     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1007 
1008     // The bit position of `aux` in packed address data.
1009     uint256 private constant _BITPOS_AUX = 192;
1010 
1011     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1012     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1013 
1014     // The bit position of `startTimestamp` in packed ownership.
1015     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1016 
1017     // The bit mask of the `burned` bit in packed ownership.
1018     uint256 private constant _BITMASK_BURNED = 1 << 224;
1019 
1020     // The bit position of the `nextInitialized` bit in packed ownership.
1021     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1022 
1023     // The bit mask of the `nextInitialized` bit in packed ownership.
1024     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1025 
1026     // The bit position of `extraData` in packed ownership.
1027     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1028 
1029     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1030     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1031 
1032     // The mask of the lower 160 bits for addresses.
1033     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1034 
1035     // The maximum `quantity` that can be minted with {_mintERC2309}.
1036     // This limit is to prevent overflows on the address data entries.
1037     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1038     // is required to cause an overflow, which is unrealistic.
1039     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1040 
1041     // The `Transfer` event signature is given by:
1042     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1043     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1044         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1045 
1046     // =============================================================
1047     //                            STORAGE
1048     // =============================================================
1049 
1050     // The next token ID to be minted.
1051     uint256 private _currentIndex;
1052 
1053     // The number of tokens burned.
1054     uint256 private _burnCounter;
1055 
1056     // Token name
1057     string private _name;
1058 
1059     // Token symbol
1060     string private _symbol;
1061 
1062     // Mapping from token ID to ownership details
1063     // An empty struct value does not necessarily mean the token is unowned.
1064     // See {_packedOwnershipOf} implementation for details.
1065     //
1066     // Bits Layout:
1067     // - [0..159]   `addr`
1068     // - [160..223] `startTimestamp`
1069     // - [224]      `burned`
1070     // - [225]      `nextInitialized`
1071     // - [232..255] `extraData`
1072     mapping(uint256 => uint256) private _packedOwnerships;
1073 
1074     // Mapping owner address to address data.
1075     //
1076     // Bits Layout:
1077     // - [0..63]    `balance`
1078     // - [64..127]  `numberMinted`
1079     // - [128..191] `numberBurned`
1080     // - [192..255] `aux`
1081     mapping(address => uint256) private _packedAddressData;
1082 
1083     // Mapping from token ID to approved address.
1084     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1085 
1086     // Mapping from owner to operator approvals
1087     mapping(address => mapping(address => bool)) private _operatorApprovals;
1088 
1089     // =============================================================
1090     //                          CONSTRUCTOR
1091     // =============================================================
1092 
1093     constructor(string memory name_, string memory symbol_) {
1094         _name = name_;
1095         _symbol = symbol_;
1096         _currentIndex = _startTokenId();
1097     }
1098 
1099     // =============================================================
1100     //                   TOKEN COUNTING OPERATIONS
1101     // =============================================================
1102 
1103     /**
1104      * @dev Returns the starting token ID.
1105      * To change the starting token ID, please override this function.
1106      */
1107     function _startTokenId() internal view virtual returns (uint256) {
1108         return 0;
1109     }
1110 
1111     /**
1112      * @dev Returns the next token ID to be minted.
1113      */
1114     function _nextTokenId() internal view virtual returns (uint256) {
1115         return _currentIndex;
1116     }
1117 
1118     /**
1119      * @dev Returns the total number of tokens in existence.
1120      * Burned tokens will reduce the count.
1121      * To get the total number of tokens minted, please see {_totalMinted}.
1122      */
1123     function totalSupply() public view virtual override returns (uint256) {
1124         // Counter underflow is impossible as _burnCounter cannot be incremented
1125         // more than `_currentIndex - _startTokenId()` times.
1126         unchecked {
1127             return _currentIndex - _burnCounter - _startTokenId();
1128         }
1129     }
1130 
1131     /**
1132      * @dev Returns the total amount of tokens minted in the contract.
1133      */
1134     function _totalMinted() internal view virtual returns (uint256) {
1135         // Counter underflow is impossible as `_currentIndex` does not decrement,
1136         // and it is initialized to `_startTokenId()`.
1137         unchecked {
1138             return _currentIndex - _startTokenId();
1139         }
1140     }
1141 
1142     /**
1143      * @dev Returns the total number of tokens burned.
1144      */
1145     function _totalBurned() internal view virtual returns (uint256) {
1146         return _burnCounter;
1147     }
1148 
1149     // =============================================================
1150     //                    ADDRESS DATA OPERATIONS
1151     // =============================================================
1152 
1153     /**
1154      * @dev Returns the number of tokens in `owner`'s account.
1155      */
1156     function balanceOf(address owner) public view virtual override returns (uint256) {
1157         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1158         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1159     }
1160 
1161     /**
1162      * Returns the number of tokens minted by `owner`.
1163      */
1164     function _numberMinted(address owner) internal view returns (uint256) {
1165         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1166     }
1167 
1168     /**
1169      * Returns the number of tokens burned by or on behalf of `owner`.
1170      */
1171     function _numberBurned(address owner) internal view returns (uint256) {
1172         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1173     }
1174 
1175     /**
1176      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1177      */
1178     function _getAux(address owner) internal view returns (uint64) {
1179         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1180     }
1181 
1182     /**
1183      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1184      * If there are multiple variables, please pack them into a uint64.
1185      */
1186     function _setAux(address owner, uint64 aux) internal virtual {
1187         uint256 packed = _packedAddressData[owner];
1188         uint256 auxCasted;
1189         // Cast `aux` with assembly to avoid redundant masking.
1190         assembly {
1191             auxCasted := aux
1192         }
1193         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1194         _packedAddressData[owner] = packed;
1195     }
1196 
1197     // =============================================================
1198     //                            IERC165
1199     // =============================================================
1200 
1201     /**
1202      * @dev Returns true if this contract implements the interface defined by
1203      * `interfaceId`. See the corresponding
1204      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1205      * to learn more about how these ids are created.
1206      *
1207      * This function call must use less than 30000 gas.
1208      */
1209     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1210         // The interface IDs are constants representing the first 4 bytes
1211         // of the XOR of all function selectors in the interface.
1212         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1213         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1214         return
1215             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1216             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1217             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1218     }
1219 
1220     // =============================================================
1221     //                        IERC721Metadata
1222     // =============================================================
1223 
1224     /**
1225      * @dev Returns the token collection name.
1226      */
1227     function name() public view virtual override returns (string memory) {
1228         return _name;
1229     }
1230 
1231     /**
1232      * @dev Returns the token collection symbol.
1233      */
1234     function symbol() public view virtual override returns (string memory) {
1235         return _symbol;
1236     }
1237 
1238     /**
1239      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1240      */
1241     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1242         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1243 
1244         string memory baseURI = _baseURI();
1245         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1246     }
1247 
1248     /**
1249      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1250      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1251      * by default, it can be overridden in child contracts.
1252      */
1253     function _baseURI() internal view virtual returns (string memory) {
1254         return '';
1255     }
1256 
1257     // =============================================================
1258     //                     OWNERSHIPS OPERATIONS
1259     // =============================================================
1260 
1261     /**
1262      * @dev Returns the owner of the `tokenId` token.
1263      *
1264      * Requirements:
1265      *
1266      * - `tokenId` must exist.
1267      */
1268     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1269         return address(uint160(_packedOwnershipOf(tokenId)));
1270     }
1271 
1272     /**
1273      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1274      * It gradually moves to O(1) as tokens get transferred around over time.
1275      */
1276     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1277         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1278     }
1279 
1280     /**
1281      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1282      */
1283     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1284         return _unpackedOwnership(_packedOwnerships[index]);
1285     }
1286 
1287     /**
1288      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1289      */
1290     function _initializeOwnershipAt(uint256 index) internal virtual {
1291         if (_packedOwnerships[index] == 0) {
1292             _packedOwnerships[index] = _packedOwnershipOf(index);
1293         }
1294     }
1295 
1296     /**
1297      * Returns the packed ownership data of `tokenId`.
1298      */
1299     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1300         uint256 curr = tokenId;
1301 
1302         unchecked {
1303             if (_startTokenId() <= curr)
1304                 if (curr < _currentIndex) {
1305                     uint256 packed = _packedOwnerships[curr];
1306                     // If not burned.
1307                     if (packed & _BITMASK_BURNED == 0) {
1308                         // Invariant:
1309                         // There will always be an initialized ownership slot
1310                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1311                         // before an unintialized ownership slot
1312                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1313                         // Hence, `curr` will not underflow.
1314                         //
1315                         // We can directly compare the packed value.
1316                         // If the address is zero, packed will be zero.
1317                         while (packed == 0) {
1318                             packed = _packedOwnerships[--curr];
1319                         }
1320                         return packed;
1321                     }
1322                 }
1323         }
1324         revert OwnerQueryForNonexistentToken();
1325     }
1326 
1327     /**
1328      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1329      */
1330     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1331         ownership.addr = address(uint160(packed));
1332         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1333         ownership.burned = packed & _BITMASK_BURNED != 0;
1334         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1335     }
1336 
1337     /**
1338      * @dev Packs ownership data into a single uint256.
1339      */
1340     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1341         assembly {
1342             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1343             owner := and(owner, _BITMASK_ADDRESS)
1344             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1345             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1346         }
1347     }
1348 
1349     /**
1350      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1351      */
1352     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1353         // For branchless setting of the `nextInitialized` flag.
1354         assembly {
1355             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1356             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1357         }
1358     }
1359 
1360     // =============================================================
1361     //                      APPROVAL OPERATIONS
1362     // =============================================================
1363 
1364     /**
1365      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1366      * The approval is cleared when the token is transferred.
1367      *
1368      * Only a single account can be approved at a time, so approving the
1369      * zero address clears previous approvals.
1370      *
1371      * Requirements:
1372      *
1373      * - The caller must own the token or be an approved operator.
1374      * - `tokenId` must exist.
1375      *
1376      * Emits an {Approval} event.
1377      */
1378     function approve(address to, uint256 tokenId) public payable virtual override {
1379         address owner = ownerOf(tokenId);
1380 
1381         if (_msgSenderERC721A() != owner)
1382             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1383                 revert ApprovalCallerNotOwnerNorApproved();
1384             }
1385 
1386         _tokenApprovals[tokenId].value = to;
1387         emit Approval(owner, to, tokenId);
1388     }
1389 
1390     /**
1391      * @dev Returns the account approved for `tokenId` token.
1392      *
1393      * Requirements:
1394      *
1395      * - `tokenId` must exist.
1396      */
1397     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1398         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1399 
1400         return _tokenApprovals[tokenId].value;
1401     }
1402 
1403     /**
1404      * @dev Approve or remove `operator` as an operator for the caller.
1405      * Operators can call {transferFrom} or {safeTransferFrom}
1406      * for any token owned by the caller.
1407      *
1408      * Requirements:
1409      *
1410      * - The `operator` cannot be the caller.
1411      *
1412      * Emits an {ApprovalForAll} event.
1413      */
1414     function setApprovalForAll(address operator, bool approved) public virtual override {
1415         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1416         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1417     }
1418 
1419     /**
1420      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1421      *
1422      * See {setApprovalForAll}.
1423      */
1424     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1425         return _operatorApprovals[owner][operator];
1426     }
1427 
1428     /**
1429      * @dev Returns whether `tokenId` exists.
1430      *
1431      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1432      *
1433      * Tokens start existing when they are minted. See {_mint}.
1434      */
1435     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1436         return
1437             _startTokenId() <= tokenId &&
1438             tokenId < _currentIndex && // If within bounds,
1439             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1440     }
1441 
1442     /**
1443      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1444      */
1445     function _isSenderApprovedOrOwner(
1446         address approvedAddress,
1447         address owner,
1448         address msgSender
1449     ) private pure returns (bool result) {
1450         assembly {
1451             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1452             owner := and(owner, _BITMASK_ADDRESS)
1453             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1454             msgSender := and(msgSender, _BITMASK_ADDRESS)
1455             // `msgSender == owner || msgSender == approvedAddress`.
1456             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1457         }
1458     }
1459 
1460     /**
1461      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1462      */
1463     function _getApprovedSlotAndAddress(uint256 tokenId)
1464         private
1465         view
1466         returns (uint256 approvedAddressSlot, address approvedAddress)
1467     {
1468         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1469         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1470         assembly {
1471             approvedAddressSlot := tokenApproval.slot
1472             approvedAddress := sload(approvedAddressSlot)
1473         }
1474     }
1475 
1476     // =============================================================
1477     //                      TRANSFER OPERATIONS
1478     // =============================================================
1479 
1480     /**
1481      * @dev Transfers `tokenId` from `from` to `to`.
1482      *
1483      * Requirements:
1484      *
1485      * - `from` cannot be the zero address.
1486      * - `to` cannot be the zero address.
1487      * - `tokenId` token must be owned by `from`.
1488      * - If the caller is not `from`, it must be approved to move this token
1489      * by either {approve} or {setApprovalForAll}.
1490      *
1491      * Emits a {Transfer} event.
1492      */
1493     function transferFrom(
1494         address from,
1495         address to,
1496         uint256 tokenId
1497     ) public payable virtual override {
1498         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1499 
1500         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1501 
1502         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1503 
1504         // The nested ifs save around 20+ gas over a compound boolean condition.
1505         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1506             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1507 
1508         if (to == address(0)) revert TransferToZeroAddress();
1509 
1510         _beforeTokenTransfers(from, to, tokenId, 1);
1511 
1512         // Clear approvals from the previous owner.
1513         assembly {
1514             if approvedAddress {
1515                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1516                 sstore(approvedAddressSlot, 0)
1517             }
1518         }
1519 
1520         // Underflow of the sender's balance is impossible because we check for
1521         // ownership above and the recipient's balance can't realistically overflow.
1522         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1523         unchecked {
1524             // We can directly increment and decrement the balances.
1525             --_packedAddressData[from]; // Updates: `balance -= 1`.
1526             ++_packedAddressData[to]; // Updates: `balance += 1`.
1527 
1528             // Updates:
1529             // - `address` to the next owner.
1530             // - `startTimestamp` to the timestamp of transfering.
1531             // - `burned` to `false`.
1532             // - `nextInitialized` to `true`.
1533             _packedOwnerships[tokenId] = _packOwnershipData(
1534                 to,
1535                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1536             );
1537 
1538             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1539             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1540                 uint256 nextTokenId = tokenId + 1;
1541                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1542                 if (_packedOwnerships[nextTokenId] == 0) {
1543                     // If the next slot is within bounds.
1544                     if (nextTokenId != _currentIndex) {
1545                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1546                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1547                     }
1548                 }
1549             }
1550         }
1551 
1552         emit Transfer(from, to, tokenId);
1553         _afterTokenTransfers(from, to, tokenId, 1);
1554     }
1555 
1556     /**
1557      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1558      */
1559     function safeTransferFrom(
1560         address from,
1561         address to,
1562         uint256 tokenId
1563     ) public payable virtual override {
1564         safeTransferFrom(from, to, tokenId, '');
1565     }
1566 
1567     /**
1568      * @dev Safely transfers `tokenId` token from `from` to `to`.
1569      *
1570      * Requirements:
1571      *
1572      * - `from` cannot be the zero address.
1573      * - `to` cannot be the zero address.
1574      * - `tokenId` token must exist and be owned by `from`.
1575      * - If the caller is not `from`, it must be approved to move this token
1576      * by either {approve} or {setApprovalForAll}.
1577      * - If `to` refers to a smart contract, it must implement
1578      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1579      *
1580      * Emits a {Transfer} event.
1581      */
1582     function safeTransferFrom(
1583         address from,
1584         address to,
1585         uint256 tokenId,
1586         bytes memory _data
1587     ) public payable virtual override {
1588         transferFrom(from, to, tokenId);
1589         if (to.code.length != 0)
1590             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1591                 revert TransferToNonERC721ReceiverImplementer();
1592             }
1593     }
1594 
1595     /**
1596      * @dev Hook that is called before a set of serially-ordered token IDs
1597      * are about to be transferred. This includes minting.
1598      * And also called before burning one token.
1599      *
1600      * `startTokenId` - the first token ID to be transferred.
1601      * `quantity` - the amount to be transferred.
1602      *
1603      * Calling conditions:
1604      *
1605      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1606      * transferred to `to`.
1607      * - When `from` is zero, `tokenId` will be minted for `to`.
1608      * - When `to` is zero, `tokenId` will be burned by `from`.
1609      * - `from` and `to` are never both zero.
1610      */
1611     function _beforeTokenTransfers(
1612         address from,
1613         address to,
1614         uint256 startTokenId,
1615         uint256 quantity
1616     ) internal virtual {}
1617 
1618     /**
1619      * @dev Hook that is called after a set of serially-ordered token IDs
1620      * have been transferred. This includes minting.
1621      * And also called after one token has been burned.
1622      *
1623      * `startTokenId` - the first token ID to be transferred.
1624      * `quantity` - the amount to be transferred.
1625      *
1626      * Calling conditions:
1627      *
1628      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1629      * transferred to `to`.
1630      * - When `from` is zero, `tokenId` has been minted for `to`.
1631      * - When `to` is zero, `tokenId` has been burned by `from`.
1632      * - `from` and `to` are never both zero.
1633      */
1634     function _afterTokenTransfers(
1635         address from,
1636         address to,
1637         uint256 startTokenId,
1638         uint256 quantity
1639     ) internal virtual {}
1640 
1641     /**
1642      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1643      *
1644      * `from` - Previous owner of the given token ID.
1645      * `to` - Target address that will receive the token.
1646      * `tokenId` - Token ID to be transferred.
1647      * `_data` - Optional data to send along with the call.
1648      *
1649      * Returns whether the call correctly returned the expected magic value.
1650      */
1651     function _checkContractOnERC721Received(
1652         address from,
1653         address to,
1654         uint256 tokenId,
1655         bytes memory _data
1656     ) private returns (bool) {
1657         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1658             bytes4 retval
1659         ) {
1660             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1661         } catch (bytes memory reason) {
1662             if (reason.length == 0) {
1663                 revert TransferToNonERC721ReceiverImplementer();
1664             } else {
1665                 assembly {
1666                     revert(add(32, reason), mload(reason))
1667                 }
1668             }
1669         }
1670     }
1671 
1672     // =============================================================
1673     //                        MINT OPERATIONS
1674     // =============================================================
1675 
1676     /**
1677      * @dev Mints `quantity` tokens and transfers them to `to`.
1678      *
1679      * Requirements:
1680      *
1681      * - `to` cannot be the zero address.
1682      * - `quantity` must be greater than 0.
1683      *
1684      * Emits a {Transfer} event for each mint.
1685      */
1686     function _mint(address to, uint256 quantity) internal virtual {
1687         uint256 startTokenId = _currentIndex;
1688         if (quantity == 0) revert MintZeroQuantity();
1689 
1690         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1691 
1692         // Overflows are incredibly unrealistic.
1693         // `balance` and `numberMinted` have a maximum limit of 2**64.
1694         // `tokenId` has a maximum limit of 2**256.
1695         unchecked {
1696             // Updates:
1697             // - `balance += quantity`.
1698             // - `numberMinted += quantity`.
1699             //
1700             // We can directly add to the `balance` and `numberMinted`.
1701             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1702 
1703             // Updates:
1704             // - `address` to the owner.
1705             // - `startTimestamp` to the timestamp of minting.
1706             // - `burned` to `false`.
1707             // - `nextInitialized` to `quantity == 1`.
1708             _packedOwnerships[startTokenId] = _packOwnershipData(
1709                 to,
1710                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1711             );
1712 
1713             uint256 toMasked;
1714             uint256 end = startTokenId + quantity;
1715 
1716             // Use assembly to loop and emit the `Transfer` event for gas savings.
1717             // The duplicated `log4` removes an extra check and reduces stack juggling.
1718             // The assembly, together with the surrounding Solidity code, have been
1719             // delicately arranged to nudge the compiler into producing optimized opcodes.
1720             assembly {
1721                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1722                 toMasked := and(to, _BITMASK_ADDRESS)
1723                 // Emit the `Transfer` event.
1724                 log4(
1725                     0, // Start of data (0, since no data).
1726                     0, // End of data (0, since no data).
1727                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1728                     0, // `address(0)`.
1729                     toMasked, // `to`.
1730                     startTokenId // `tokenId`.
1731                 )
1732 
1733                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1734                 // that overflows uint256 will make the loop run out of gas.
1735                 // The compiler will optimize the `iszero` away for performance.
1736                 for {
1737                     let tokenId := add(startTokenId, 1)
1738                 } iszero(eq(tokenId, end)) {
1739                     tokenId := add(tokenId, 1)
1740                 } {
1741                     // Emit the `Transfer` event. Similar to above.
1742                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1743                 }
1744             }
1745             if (toMasked == 0) revert MintToZeroAddress();
1746 
1747             _currentIndex = end;
1748         }
1749         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1750     }
1751 
1752     /**
1753      * @dev Mints `quantity` tokens and transfers them to `to`.
1754      *
1755      * This function is intended for efficient minting only during contract creation.
1756      *
1757      * It emits only one {ConsecutiveTransfer} as defined in
1758      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1759      * instead of a sequence of {Transfer} event(s).
1760      *
1761      * Calling this function outside of contract creation WILL make your contract
1762      * non-compliant with the ERC721 standard.
1763      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1764      * {ConsecutiveTransfer} event is only permissible during contract creation.
1765      *
1766      * Requirements:
1767      *
1768      * - `to` cannot be the zero address.
1769      * - `quantity` must be greater than 0.
1770      *
1771      * Emits a {ConsecutiveTransfer} event.
1772      */
1773     function _mintERC2309(address to, uint256 quantity) internal virtual {
1774         uint256 startTokenId = _currentIndex;
1775         if (to == address(0)) revert MintToZeroAddress();
1776         if (quantity == 0) revert MintZeroQuantity();
1777         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1778 
1779         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1780 
1781         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1782         unchecked {
1783             // Updates:
1784             // - `balance += quantity`.
1785             // - `numberMinted += quantity`.
1786             //
1787             // We can directly add to the `balance` and `numberMinted`.
1788             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1789 
1790             // Updates:
1791             // - `address` to the owner.
1792             // - `startTimestamp` to the timestamp of minting.
1793             // - `burned` to `false`.
1794             // - `nextInitialized` to `quantity == 1`.
1795             _packedOwnerships[startTokenId] = _packOwnershipData(
1796                 to,
1797                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1798             );
1799 
1800             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1801 
1802             _currentIndex = startTokenId + quantity;
1803         }
1804         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1805     }
1806 
1807     /**
1808      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1809      *
1810      * Requirements:
1811      *
1812      * - If `to` refers to a smart contract, it must implement
1813      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1814      * - `quantity` must be greater than 0.
1815      *
1816      * See {_mint}.
1817      *
1818      * Emits a {Transfer} event for each mint.
1819      */
1820     function _safeMint(
1821         address to,
1822         uint256 quantity,
1823         bytes memory _data
1824     ) internal virtual {
1825         _mint(to, quantity);
1826 
1827         unchecked {
1828             if (to.code.length != 0) {
1829                 uint256 end = _currentIndex;
1830                 uint256 index = end - quantity;
1831                 do {
1832                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1833                         revert TransferToNonERC721ReceiverImplementer();
1834                     }
1835                 } while (index < end);
1836                 // Reentrancy protection.
1837                 if (_currentIndex != end) revert();
1838             }
1839         }
1840     }
1841 
1842     /**
1843      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1844      */
1845     function _safeMint(address to, uint256 quantity) internal virtual {
1846         _safeMint(to, quantity, '');
1847     }
1848 
1849     // =============================================================
1850     //                        BURN OPERATIONS
1851     // =============================================================
1852 
1853     /**
1854      * @dev Equivalent to `_burn(tokenId, false)`.
1855      */
1856     function _burn(uint256 tokenId) internal virtual {
1857         _burn(tokenId, false);
1858     }
1859 
1860     /**
1861      * @dev Destroys `tokenId`.
1862      * The approval is cleared when the token is burned.
1863      *
1864      * Requirements:
1865      *
1866      * - `tokenId` must exist.
1867      *
1868      * Emits a {Transfer} event.
1869      */
1870     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1871         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1872 
1873         address from = address(uint160(prevOwnershipPacked));
1874 
1875         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1876 
1877         if (approvalCheck) {
1878             // The nested ifs save around 20+ gas over a compound boolean condition.
1879             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1880                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1881         }
1882 
1883         _beforeTokenTransfers(from, address(0), tokenId, 1);
1884 
1885         // Clear approvals from the previous owner.
1886         assembly {
1887             if approvedAddress {
1888                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1889                 sstore(approvedAddressSlot, 0)
1890             }
1891         }
1892 
1893         // Underflow of the sender's balance is impossible because we check for
1894         // ownership above and the recipient's balance can't realistically overflow.
1895         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1896         unchecked {
1897             // Updates:
1898             // - `balance -= 1`.
1899             // - `numberBurned += 1`.
1900             //
1901             // We can directly decrement the balance, and increment the number burned.
1902             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1903             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1904 
1905             // Updates:
1906             // - `address` to the last owner.
1907             // - `startTimestamp` to the timestamp of burning.
1908             // - `burned` to `true`.
1909             // - `nextInitialized` to `true`.
1910             _packedOwnerships[tokenId] = _packOwnershipData(
1911                 from,
1912                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1913             );
1914 
1915             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1916             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1917                 uint256 nextTokenId = tokenId + 1;
1918                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1919                 if (_packedOwnerships[nextTokenId] == 0) {
1920                     // If the next slot is within bounds.
1921                     if (nextTokenId != _currentIndex) {
1922                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1923                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1924                     }
1925                 }
1926             }
1927         }
1928 
1929         emit Transfer(from, address(0), tokenId);
1930         _afterTokenTransfers(from, address(0), tokenId, 1);
1931 
1932         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1933         unchecked {
1934             _burnCounter++;
1935         }
1936     }
1937 
1938     // =============================================================
1939     //                     EXTRA DATA OPERATIONS
1940     // =============================================================
1941 
1942     /**
1943      * @dev Directly sets the extra data for the ownership data `index`.
1944      */
1945     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1946         uint256 packed = _packedOwnerships[index];
1947         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1948         uint256 extraDataCasted;
1949         // Cast `extraData` with assembly to avoid redundant masking.
1950         assembly {
1951             extraDataCasted := extraData
1952         }
1953         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1954         _packedOwnerships[index] = packed;
1955     }
1956 
1957     /**
1958      * @dev Called during each token transfer to set the 24bit `extraData` field.
1959      * Intended to be overridden by the cosumer contract.
1960      *
1961      * `previousExtraData` - the value of `extraData` before transfer.
1962      *
1963      * Calling conditions:
1964      *
1965      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1966      * transferred to `to`.
1967      * - When `from` is zero, `tokenId` will be minted for `to`.
1968      * - When `to` is zero, `tokenId` will be burned by `from`.
1969      * - `from` and `to` are never both zero.
1970      */
1971     function _extraData(
1972         address from,
1973         address to,
1974         uint24 previousExtraData
1975     ) internal view virtual returns (uint24) {}
1976 
1977     /**
1978      * @dev Returns the next extra data for the packed ownership data.
1979      * The returned result is shifted into position.
1980      */
1981     function _nextExtraData(
1982         address from,
1983         address to,
1984         uint256 prevOwnershipPacked
1985     ) private view returns (uint256) {
1986         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1987         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1988     }
1989 
1990     // =============================================================
1991     //                       OTHER OPERATIONS
1992     // =============================================================
1993 
1994     /**
1995      * @dev Returns the message sender (defaults to `msg.sender`).
1996      *
1997      * If you are writing GSN compatible contracts, you need to override this function.
1998      */
1999     function _msgSenderERC721A() internal view virtual returns (address) {
2000         return msg.sender;
2001     }
2002 
2003     /**
2004      * @dev Converts a uint256 to its ASCII string decimal representation.
2005      */
2006     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2007         assembly {
2008             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2009             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2010             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2011             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2012             let m := add(mload(0x40), 0xa0)
2013             // Update the free memory pointer to allocate.
2014             mstore(0x40, m)
2015             // Assign the `str` to the end.
2016             str := sub(m, 0x20)
2017             // Zeroize the slot after the string.
2018             mstore(str, 0)
2019 
2020             // Cache the end of the memory to calculate the length later.
2021             let end := str
2022 
2023             // We write the string from rightmost digit to leftmost digit.
2024             // The following is essentially a do-while loop that also handles the zero case.
2025             // prettier-ignore
2026             for { let temp := value } 1 {} {
2027                 str := sub(str, 1)
2028                 // Write the character to the pointer.
2029                 // The ASCII index of the '0' character is 48.
2030                 mstore8(str, add(48, mod(temp, 10)))
2031                 // Keep dividing `temp` until zero.
2032                 temp := div(temp, 10)
2033                 // prettier-ignore
2034                 if iszero(temp) { break }
2035             }
2036 
2037             let length := sub(end, str)
2038             // Move the pointer 32 bytes leftwards to make room for the length.
2039             str := sub(str, 0x20)
2040             // Store the length.
2041             mstore(str, length)
2042         }
2043     }
2044 }
2045 
2046 // File: madpig.sol
2047 
2048 
2049 
2050 
2051 pragma solidity >=0.7.0 <0.9.0;
2052 
2053 
2054 
2055 
2056 
2057 contract MadPig is ERC721A, Ownable, ReentrancyGuard {
2058   using Strings for uint256;
2059 
2060   string public baseURI;
2061   string public baseExtension = "";
2062   string public notRevealedUri;
2063   uint256 public cost = 0.001 ether;
2064   uint256 public maxSupply = 8888;
2065   uint256 public FreeSupply = 8888;
2066   uint256 public MaxperWallet = 100;
2067   uint256 public MaxperWalletFree = 1;
2068   bool public paused = false;
2069   bool public revealed = true;
2070 
2071   constructor(
2072     string memory _initBaseURI,
2073     string memory _notRevealedUri
2074   ) ERC721A("MadPig", "MP") {  
2075     setBaseURI(_initBaseURI);
2076     setNotRevealedURI(_notRevealedUri);
2077   }
2078 
2079   // internal
2080   function _baseURI() internal view virtual override returns (string memory) {
2081     return baseURI;
2082   }
2083       function _startTokenId() internal view virtual override returns (uint256) {
2084         return 1;
2085     }
2086 
2087   // public
2088   /// @dev Public mint 
2089   function mint(uint256 tokens) public payable nonReentrant {
2090     require(!paused, "oops contract is paused");
2091     require(tokens <= MaxperWallet, "max mint amount per tx exceeded");
2092     require(totalSupply() + tokens <= maxSupply, "We Soldout");
2093     require(_numberMinted(_msgSenderERC721A()) + tokens <= MaxperWallet, "Max NFT Per Wallet exceeded");
2094     require(msg.value >= cost * tokens, "insufficient funds");
2095 
2096       _safeMint(_msgSenderERC721A(), tokens);
2097   }
2098   
2099 /// @dev free mint
2100     function freemint(uint256 tokens) public nonReentrant {
2101     require(!paused, "oops contract is paused");
2102     require(_numberMinted(_msgSenderERC721A()) + tokens <= MaxperWalletFree, "Max NFT Per Wallet exceeded");
2103     require(tokens <= MaxperWalletFree, "max free mint per Tx exceeded");
2104     require(totalSupply() + tokens <= FreeSupply, "Whitelist MaxSupply exceeded");
2105 
2106       _safeMint(_msgSenderERC721A(), tokens);
2107     
2108   }
2109 
2110   /// @dev use it for giveaway and team mint
2111      function airdrop(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
2112     require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
2113 
2114       _safeMint(destination, _mintAmount);
2115   }
2116 
2117 /// @notice returns metadata link of tokenid
2118   function tokenURI(uint256 tokenId)
2119     public
2120     view
2121     virtual
2122     override
2123     returns (string memory)
2124   {
2125     require(
2126       _exists(tokenId),
2127       "ERC721AMetadata: URI query for nonexistent token"
2128     );
2129     
2130     if(revealed == false) {
2131         return notRevealedUri;
2132     }
2133 
2134     string memory currentBaseURI = _baseURI();
2135     return bytes(currentBaseURI).length > 0
2136         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
2137         : "";
2138   }
2139 
2140      /// @notice return the number minted by an address
2141     function numberMinted(address owner) public view returns (uint256) {
2142     return _numberMinted(owner);
2143   }
2144 
2145     /// @notice return the tokens owned by an address
2146       function tokensOfOwner(address owner) public view returns (uint256[] memory) {
2147         unchecked {
2148             uint256 tokenIdsIdx;
2149             address currOwnershipAddr;
2150             uint256 tokenIdsLength = balanceOf(owner);
2151             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2152             TokenOwnership memory ownership;
2153             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2154                 ownership = _ownershipAt(i);
2155                 if (ownership.burned) {
2156                     continue;
2157                 }
2158                 if (ownership.addr != address(0)) {
2159                     currOwnershipAddr = ownership.addr;
2160                 }
2161                 if (currOwnershipAddr == owner) {
2162                     tokenIds[tokenIdsIdx++] = i;
2163                 }
2164             }
2165             return tokenIds;
2166         }
2167     }
2168 
2169   //only owner
2170   function reveal(bool _state) public onlyOwner {
2171       revealed = _state;
2172   }
2173 
2174   /// @dev change the public max per wallet
2175   function setMaxPerWallet(uint256 _limit) public onlyOwner {
2176     MaxperWallet = _limit;
2177   }
2178 
2179   /// @dev change the free max per wallet
2180     function setFreeMaxPerWallet(uint256 _limit) public onlyOwner {
2181     MaxperWalletFree = _limit;
2182   }
2183 
2184    /// @dev change the public price(amount need to be in wei)
2185   function setCost(uint256 _newCost) public onlyOwner {
2186     cost = _newCost;
2187   }
2188 
2189   /// @dev cut the supply if we dont sold out
2190     function setMaxsupply(uint256 _newsupply) public onlyOwner {
2191     maxSupply = _newsupply;
2192   }
2193 
2194  /// @dev cut the free supply
2195     function setFreesupply(uint256 _newsupply) public onlyOwner {
2196     FreeSupply = _newsupply;
2197   }
2198 
2199  /// @dev set your baseuri
2200   function setBaseURI(string memory _newBaseURI) public onlyOwner {
2201     baseURI = _newBaseURI;
2202   }
2203 
2204   /// @dev set base extension(default is .json)
2205   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
2206     baseExtension = _newBaseExtension;
2207   }
2208 
2209    /// @dev set hidden uri
2210   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2211     notRevealedUri = _notRevealedURI;
2212   }
2213 
2214  /// @dev to pause and unpause your contract(use booleans true or false)
2215   function pause(bool _state) public onlyOwner {
2216     paused = _state;
2217   }
2218   
2219   /// @dev withdraw funds from contract
2220   function withdraw() public payable onlyOwner nonReentrant {
2221       uint256 balance = address(this).balance;
2222       payable(_msgSenderERC721A()).transfer(balance);
2223   }
2224 }