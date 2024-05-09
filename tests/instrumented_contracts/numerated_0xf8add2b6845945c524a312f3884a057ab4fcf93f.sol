1 // File: @openzeppelin\contracts\security\ReentrancyGuard.sol
2 
3 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and making it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         _nonReentrantBefore();
53         _;
54         _nonReentrantAfter();
55     }
56 
57     function _nonReentrantBefore() private {
58         // On the first call to nonReentrant, _status will be _NOT_ENTERED
59         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
60 
61         // Any calls to nonReentrant after this point will fail
62         _status = _ENTERED;
63     }
64 
65     function _nonReentrantAfter() private {
66         // By storing the original value once again, a refund is triggered (see
67         // https://eips.ethereum.org/EIPS/eip-2200)
68         _status = _NOT_ENTERED;
69     }
70 }
71 
72 // File: @openzeppelin\contracts\utils\Context.sol
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin\contracts\access\Ownable.sol
99 
100 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor() {
125         _transferOwnership(_msgSender());
126     }
127 
128     /**
129      * @dev Throws if called by any account other than the owner.
130      */
131     modifier onlyOwner() {
132         _checkOwner();
133         _;
134     }
135 
136     /**
137      * @dev Returns the address of the current owner.
138      */
139     function owner() public view virtual returns (address) {
140         return _owner;
141     }
142 
143     /**
144      * @dev Throws if the sender is not the owner.
145      */
146     function _checkOwner() internal view virtual {
147         require(owner() == _msgSender(), "Ownable: caller is not the owner");
148     }
149 
150     /**
151      * @dev Leaves the contract without owner. It will not be possible to call
152      * `onlyOwner` functions anymore. Can only be called by the current owner.
153      *
154      * NOTE: Renouncing ownership will leave the contract without an owner,
155      * thereby removing any functionality that is only available to the owner.
156      */
157     function renounceOwnership() public virtual onlyOwner {
158         _transferOwnership(address(0));
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Can only be called by the current owner.
164      */
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         _transferOwnership(newOwner);
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Internal function without access restriction.
173      */
174     function _transferOwnership(address newOwner) internal virtual {
175         address oldOwner = _owner;
176         _owner = newOwner;
177         emit OwnershipTransferred(oldOwner, newOwner);
178     }
179 }
180 
181 // File: @openzeppelin\contracts\utils\math\Math.sol
182 
183 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @dev Standard math utilities missing in the Solidity language.
189  */
190 library Math {
191     enum Rounding {
192         Down, // Toward negative infinity
193         Up, // Toward infinity
194         Zero // Toward zero
195     }
196 
197     /**
198      * @dev Returns the largest of two numbers.
199      */
200     function max(uint256 a, uint256 b) internal pure returns (uint256) {
201         return a > b ? a : b;
202     }
203 
204     /**
205      * @dev Returns the smallest of two numbers.
206      */
207     function min(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a < b ? a : b;
209     }
210 
211     /**
212      * @dev Returns the average of two numbers. The result is rounded towards
213      * zero.
214      */
215     function average(uint256 a, uint256 b) internal pure returns (uint256) {
216         // (a + b) / 2 can overflow.
217         return (a & b) + (a ^ b) / 2;
218     }
219 
220     /**
221      * @dev Returns the ceiling of the division of two numbers.
222      *
223      * This differs from standard division with `/` in that it rounds up instead
224      * of rounding down.
225      */
226     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
227         // (a + b - 1) / b can overflow on addition, so we distribute.
228         return a == 0 ? 0 : (a - 1) / b + 1;
229     }
230 
231     /**
232      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
233      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
234      * with further edits by Uniswap Labs also under MIT license.
235      */
236     function mulDiv(
237         uint256 x,
238         uint256 y,
239         uint256 denominator
240     ) internal pure returns (uint256 result) {
241         unchecked {
242             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
243             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
244             // variables such that product = prod1 * 2^256 + prod0.
245             uint256 prod0; // Least significant 256 bits of the product
246             uint256 prod1; // Most significant 256 bits of the product
247             assembly {
248                 let mm := mulmod(x, y, not(0))
249                 prod0 := mul(x, y)
250                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
251             }
252 
253             // Handle non-overflow cases, 256 by 256 division.
254             if (prod1 == 0) {
255                 return prod0 / denominator;
256             }
257 
258             // Make sure the result is less than 2^256. Also prevents denominator == 0.
259             require(denominator > prod1);
260 
261             ///////////////////////////////////////////////
262             // 512 by 256 division.
263             ///////////////////////////////////////////////
264 
265             // Make division exact by subtracting the remainder from [prod1 prod0].
266             uint256 remainder;
267             assembly {
268                 // Compute remainder using mulmod.
269                 remainder := mulmod(x, y, denominator)
270 
271                 // Subtract 256 bit number from 512 bit number.
272                 prod1 := sub(prod1, gt(remainder, prod0))
273                 prod0 := sub(prod0, remainder)
274             }
275 
276             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
277             // See https://cs.stackexchange.com/q/138556/92363.
278 
279             // Does not overflow because the denominator cannot be zero at this stage in the function.
280             uint256 twos = denominator & (~denominator + 1);
281             assembly {
282                 // Divide denominator by twos.
283                 denominator := div(denominator, twos)
284 
285                 // Divide [prod1 prod0] by twos.
286                 prod0 := div(prod0, twos)
287 
288                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
289                 twos := add(div(sub(0, twos), twos), 1)
290             }
291 
292             // Shift in bits from prod1 into prod0.
293             prod0 |= prod1 * twos;
294 
295             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
296             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
297             // four bits. That is, denominator * inv = 1 mod 2^4.
298             uint256 inverse = (3 * denominator) ^ 2;
299 
300             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
301             // in modular arithmetic, doubling the correct bits in each step.
302             inverse *= 2 - denominator * inverse; // inverse mod 2^8
303             inverse *= 2 - denominator * inverse; // inverse mod 2^16
304             inverse *= 2 - denominator * inverse; // inverse mod 2^32
305             inverse *= 2 - denominator * inverse; // inverse mod 2^64
306             inverse *= 2 - denominator * inverse; // inverse mod 2^128
307             inverse *= 2 - denominator * inverse; // inverse mod 2^256
308 
309             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
310             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
311             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
312             // is no longer required.
313             result = prod0 * inverse;
314             return result;
315         }
316     }
317 
318     /**
319      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
320      */
321     function mulDiv(
322         uint256 x,
323         uint256 y,
324         uint256 denominator,
325         Rounding rounding
326     ) internal pure returns (uint256) {
327         uint256 result = mulDiv(x, y, denominator);
328         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
329             result += 1;
330         }
331         return result;
332     }
333 
334     /**
335      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
336      *
337      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
338      */
339     function sqrt(uint256 a) internal pure returns (uint256) {
340         if (a == 0) {
341             return 0;
342         }
343 
344         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
345         //
346         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
347         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
348         //
349         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
350         // ÔåÆ `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
351         // ÔåÆ `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
352         //
353         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
354         uint256 result = 1 << (log2(a) >> 1);
355 
356         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
357         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
358         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
359         // into the expected uint128 result.
360         unchecked {
361             result = (result + a / result) >> 1;
362             result = (result + a / result) >> 1;
363             result = (result + a / result) >> 1;
364             result = (result + a / result) >> 1;
365             result = (result + a / result) >> 1;
366             result = (result + a / result) >> 1;
367             result = (result + a / result) >> 1;
368             return min(result, a / result);
369         }
370     }
371 
372     /**
373      * @notice Calculates sqrt(a), following the selected rounding direction.
374      */
375     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
376         unchecked {
377             uint256 result = sqrt(a);
378             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
379         }
380     }
381 
382     /**
383      * @dev Return the log in base 2, rounded down, of a positive value.
384      * Returns 0 if given 0.
385      */
386     function log2(uint256 value) internal pure returns (uint256) {
387         uint256 result = 0;
388         unchecked {
389             if (value >> 128 > 0) {
390                 value >>= 128;
391                 result += 128;
392             }
393             if (value >> 64 > 0) {
394                 value >>= 64;
395                 result += 64;
396             }
397             if (value >> 32 > 0) {
398                 value >>= 32;
399                 result += 32;
400             }
401             if (value >> 16 > 0) {
402                 value >>= 16;
403                 result += 16;
404             }
405             if (value >> 8 > 0) {
406                 value >>= 8;
407                 result += 8;
408             }
409             if (value >> 4 > 0) {
410                 value >>= 4;
411                 result += 4;
412             }
413             if (value >> 2 > 0) {
414                 value >>= 2;
415                 result += 2;
416             }
417             if (value >> 1 > 0) {
418                 result += 1;
419             }
420         }
421         return result;
422     }
423 
424     /**
425      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
426      * Returns 0 if given 0.
427      */
428     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
429         unchecked {
430             uint256 result = log2(value);
431             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
432         }
433     }
434 
435     /**
436      * @dev Return the log in base 10, rounded down, of a positive value.
437      * Returns 0 if given 0.
438      */
439     function log10(uint256 value) internal pure returns (uint256) {
440         uint256 result = 0;
441         unchecked {
442             if (value >= 10**64) {
443                 value /= 10**64;
444                 result += 64;
445             }
446             if (value >= 10**32) {
447                 value /= 10**32;
448                 result += 32;
449             }
450             if (value >= 10**16) {
451                 value /= 10**16;
452                 result += 16;
453             }
454             if (value >= 10**8) {
455                 value /= 10**8;
456                 result += 8;
457             }
458             if (value >= 10**4) {
459                 value /= 10**4;
460                 result += 4;
461             }
462             if (value >= 10**2) {
463                 value /= 10**2;
464                 result += 2;
465             }
466             if (value >= 10**1) {
467                 result += 1;
468             }
469         }
470         return result;
471     }
472 
473     /**
474      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
475      * Returns 0 if given 0.
476      */
477     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
478         unchecked {
479             uint256 result = log10(value);
480             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
481         }
482     }
483 
484     /**
485      * @dev Return the log in base 256, rounded down, of a positive value.
486      * Returns 0 if given 0.
487      *
488      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
489      */
490     function log256(uint256 value) internal pure returns (uint256) {
491         uint256 result = 0;
492         unchecked {
493             if (value >> 128 > 0) {
494                 value >>= 128;
495                 result += 16;
496             }
497             if (value >> 64 > 0) {
498                 value >>= 64;
499                 result += 8;
500             }
501             if (value >> 32 > 0) {
502                 value >>= 32;
503                 result += 4;
504             }
505             if (value >> 16 > 0) {
506                 value >>= 16;
507                 result += 2;
508             }
509             if (value >> 8 > 0) {
510                 result += 1;
511             }
512         }
513         return result;
514     }
515 
516     /**
517      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
518      * Returns 0 if given 0.
519      */
520     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
521         unchecked {
522             uint256 result = log256(value);
523             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
524         }
525     }
526 }
527 
528 // File: @openzeppelin\contracts\utils\Strings.sol
529 
530 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @dev String operations.
536  */
537 library Strings {
538     bytes16 private constant _SYMBOLS = "0123456789abcdef";
539     uint8 private constant _ADDRESS_LENGTH = 20;
540 
541     /**
542      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
543      */
544     function toString(uint256 value) internal pure returns (string memory) {
545         unchecked {
546             uint256 length = Math.log10(value) + 1;
547             string memory buffer = new string(length);
548             uint256 ptr;
549             /// @solidity memory-safe-assembly
550             assembly {
551                 ptr := add(buffer, add(32, length))
552             }
553             while (true) {
554                 ptr--;
555                 /// @solidity memory-safe-assembly
556                 assembly {
557                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
558                 }
559                 value /= 10;
560                 if (value == 0) break;
561             }
562             return buffer;
563         }
564     }
565 
566     /**
567      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
568      */
569     function toHexString(uint256 value) internal pure returns (string memory) {
570         unchecked {
571             return toHexString(value, Math.log256(value) + 1);
572         }
573     }
574 
575     /**
576      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
577      */
578     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
579         bytes memory buffer = new bytes(2 * length + 2);
580         buffer[0] = "0";
581         buffer[1] = "x";
582         for (uint256 i = 2 * length + 1; i > 1; --i) {
583             buffer[i] = _SYMBOLS[value & 0xf];
584             value >>= 4;
585         }
586         require(value == 0, "Strings: hex length insufficient");
587         return string(buffer);
588     }
589 
590     /**
591      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
592      */
593     function toHexString(address addr) internal pure returns (string memory) {
594         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
595     }
596 }
597 
598 // File: node_modules\erc721a\contracts\IERC721A.sol
599 
600 // ERC721A Contracts v4.2.3
601 // Creator: Chiru Labs
602 
603 pragma solidity ^0.8.4;
604 
605 /**
606  * @dev Interface of ERC721A.
607  */
608 interface IERC721A {
609     /**
610      * The caller must own the token or be an approved operator.
611      */
612     error ApprovalCallerNotOwnerNorApproved();
613 
614     /**
615      * The token does not exist.
616      */
617     error ApprovalQueryForNonexistentToken();
618 
619     /**
620      * Cannot query the balance for the zero address.
621      */
622     error BalanceQueryForZeroAddress();
623 
624     /**
625      * Cannot mint to the zero address.
626      */
627     error MintToZeroAddress();
628 
629     /**
630      * The quantity of tokens minted must be more than zero.
631      */
632     error MintZeroQuantity();
633 
634     /**
635      * The token does not exist.
636      */
637     error OwnerQueryForNonexistentToken();
638 
639     /**
640      * The caller must own the token or be an approved operator.
641      */
642     error TransferCallerNotOwnerNorApproved();
643 
644     /**
645      * The token must be owned by `from`.
646      */
647     error TransferFromIncorrectOwner();
648 
649     /**
650      * Cannot safely transfer to a contract that does not implement the
651      * ERC721Receiver interface.
652      */
653     error TransferToNonERC721ReceiverImplementer();
654 
655     /**
656      * Cannot transfer to the zero address.
657      */
658     error TransferToZeroAddress();
659 
660     /**
661      * The token does not exist.
662      */
663     error URIQueryForNonexistentToken();
664 
665     /**
666      * The `quantity` minted with ERC2309 exceeds the safety limit.
667      */
668     error MintERC2309QuantityExceedsLimit();
669 
670     /**
671      * The `extraData` cannot be set on an unintialized ownership slot.
672      */
673     error OwnershipNotInitializedForExtraData();
674 
675     // =============================================================
676     //                            STRUCTS
677     // =============================================================
678 
679     struct TokenOwnership {
680         // The address of the owner.
681         address addr;
682         // Stores the start time of ownership with minimal overhead for tokenomics.
683         uint64 startTimestamp;
684         // Whether the token has been burned.
685         bool burned;
686         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
687         uint24 extraData;
688     }
689 
690     // =============================================================
691     //                         TOKEN COUNTERS
692     // =============================================================
693 
694     /**
695      * @dev Returns the total number of tokens in existence.
696      * Burned tokens will reduce the count.
697      * To get the total number of tokens minted, please see {_totalMinted}.
698      */
699     function totalSupply() external view returns (uint256);
700 
701     // =============================================================
702     //                            IERC165
703     // =============================================================
704 
705     /**
706      * @dev Returns true if this contract implements the interface defined by
707      * `interfaceId`. See the corresponding
708      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
709      * to learn more about how these ids are created.
710      *
711      * This function call must use less than 30000 gas.
712      */
713     function supportsInterface(bytes4 interfaceId) external view returns (bool);
714 
715     // =============================================================
716     //                            IERC721
717     // =============================================================
718 
719     /**
720      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
721      */
722     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
723 
724     /**
725      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
726      */
727     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
728 
729     /**
730      * @dev Emitted when `owner` enables or disables
731      * (`approved`) `operator` to manage all of its assets.
732      */
733     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
734 
735     /**
736      * @dev Returns the number of tokens in `owner`'s account.
737      */
738     function balanceOf(address owner) external view returns (uint256 balance);
739 
740     /**
741      * @dev Returns the owner of the `tokenId` token.
742      *
743      * Requirements:
744      *
745      * - `tokenId` must exist.
746      */
747     function ownerOf(uint256 tokenId) external view returns (address owner);
748 
749     /**
750      * @dev Safely transfers `tokenId` token from `from` to `to`,
751      * checking first that contract recipients are aware of the ERC721 protocol
752      * to prevent tokens from being forever locked.
753      *
754      * Requirements:
755      *
756      * - `from` cannot be the zero address.
757      * - `to` cannot be the zero address.
758      * - `tokenId` token must exist and be owned by `from`.
759      * - If the caller is not `from`, it must be have been allowed to move
760      * this token by either {approve} or {setApprovalForAll}.
761      * - If `to` refers to a smart contract, it must implement
762      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
763      *
764      * Emits a {Transfer} event.
765      */
766     function safeTransferFrom(
767         address from,
768         address to,
769         uint256 tokenId,
770         bytes calldata data
771     ) external payable;
772 
773     /**
774      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) external payable;
781 
782     /**
783      * @dev Transfers `tokenId` from `from` to `to`.
784      *
785      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
786      * whenever possible.
787      *
788      * Requirements:
789      *
790      * - `from` cannot be the zero address.
791      * - `to` cannot be the zero address.
792      * - `tokenId` token must be owned by `from`.
793      * - If the caller is not `from`, it must be approved to move this token
794      * by either {approve} or {setApprovalForAll}.
795      *
796      * Emits a {Transfer} event.
797      */
798     function transferFrom(
799         address from,
800         address to,
801         uint256 tokenId
802     ) external payable;
803 
804     /**
805      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
806      * The approval is cleared when the token is transferred.
807      *
808      * Only a single account can be approved at a time, so approving the
809      * zero address clears previous approvals.
810      *
811      * Requirements:
812      *
813      * - The caller must own the token or be an approved operator.
814      * - `tokenId` must exist.
815      *
816      * Emits an {Approval} event.
817      */
818     function approve(address to, uint256 tokenId) external payable;
819 
820     /**
821      * @dev Approve or remove `operator` as an operator for the caller.
822      * Operators can call {transferFrom} or {safeTransferFrom}
823      * for any token owned by the caller.
824      *
825      * Requirements:
826      *
827      * - The `operator` cannot be the caller.
828      *
829      * Emits an {ApprovalForAll} event.
830      */
831     function setApprovalForAll(address operator, bool _approved) external;
832 
833     /**
834      * @dev Returns the account approved for `tokenId` token.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      */
840     function getApproved(uint256 tokenId) external view returns (address operator);
841 
842     /**
843      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
844      *
845      * See {setApprovalForAll}.
846      */
847     function isApprovedForAll(address owner, address operator) external view returns (bool);
848 
849     // =============================================================
850     //                        IERC721Metadata
851     // =============================================================
852 
853     /**
854      * @dev Returns the token collection name.
855      */
856     function name() external view returns (string memory);
857 
858     /**
859      * @dev Returns the token collection symbol.
860      */
861     function symbol() external view returns (string memory);
862 
863     /**
864      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
865      */
866     function tokenURI(uint256 tokenId) external view returns (string memory);
867 
868     // =============================================================
869     //                           IERC2309
870     // =============================================================
871 
872     /**
873      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
874      * (inclusive) is transferred from `from` to `to`, as defined in the
875      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
876      *
877      * See {_mintERC2309} for more details.
878      */
879     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
880 }
881 
882 // File: erc721a\contracts\ERC721A.sol
883 
884 // ERC721A Contracts v4.2.3
885 // Creator: Chiru Labs
886 
887 pragma solidity ^0.8.4;
888 
889 /**
890  * @dev Interface of ERC721 token receiver.
891  */
892 interface ERC721A__IERC721Receiver {
893     function onERC721Received(
894         address operator,
895         address from,
896         uint256 tokenId,
897         bytes calldata data
898     ) external returns (bytes4);
899 }
900 
901 /**
902  * @title ERC721A
903  *
904  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
905  * Non-Fungible Token Standard, including the Metadata extension.
906  * Optimized for lower gas during batch mints.
907  *
908  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
909  * starting from `_startTokenId()`.
910  *
911  * Assumptions:
912  *
913  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
914  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
915  */
916 contract ERC721A is IERC721A {
917     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
918     struct TokenApprovalRef {
919         address value;
920     }
921 
922     // =============================================================
923     //                           CONSTANTS
924     // =============================================================
925 
926     // Mask of an entry in packed address data.
927     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
928 
929     // The bit position of `numberMinted` in packed address data.
930     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
931 
932     // The bit position of `numberBurned` in packed address data.
933     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
934 
935     // The bit position of `aux` in packed address data.
936     uint256 private constant _BITPOS_AUX = 192;
937 
938     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
939     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
940 
941     // The bit position of `startTimestamp` in packed ownership.
942     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
943 
944     // The bit mask of the `burned` bit in packed ownership.
945     uint256 private constant _BITMASK_BURNED = 1 << 224;
946 
947     // The bit position of the `nextInitialized` bit in packed ownership.
948     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
949 
950     // The bit mask of the `nextInitialized` bit in packed ownership.
951     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
952 
953     // The bit position of `extraData` in packed ownership.
954     uint256 private constant _BITPOS_EXTRA_DATA = 232;
955 
956     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
957     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
958 
959     // The mask of the lower 160 bits for addresses.
960     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
961 
962     // The maximum `quantity` that can be minted with {_mintERC2309}.
963     // This limit is to prevent overflows on the address data entries.
964     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
965     // is required to cause an overflow, which is unrealistic.
966     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
967 
968     // The `Transfer` event signature is given by:
969     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
970     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
971         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
972 
973     // =============================================================
974     //                            STORAGE
975     // =============================================================
976 
977     // The next token ID to be minted.
978     uint256 private _currentIndex;
979 
980     // The number of tokens burned.
981     uint256 private _burnCounter;
982 
983     // Token name
984     string private _name;
985 
986     // Token symbol
987     string private _symbol;
988 
989     // Mapping from token ID to ownership details
990     // An empty struct value does not necessarily mean the token is unowned.
991     // See {_packedOwnershipOf} implementation for details.
992     //
993     // Bits Layout:
994     // - [0..159]   `addr`
995     // - [160..223] `startTimestamp`
996     // - [224]      `burned`
997     // - [225]      `nextInitialized`
998     // - [232..255] `extraData`
999     mapping(uint256 => uint256) private _packedOwnerships;
1000 
1001     // Mapping owner address to address data.
1002     //
1003     // Bits Layout:
1004     // - [0..63]    `balance`
1005     // - [64..127]  `numberMinted`
1006     // - [128..191] `numberBurned`
1007     // - [192..255] `aux`
1008     mapping(address => uint256) private _packedAddressData;
1009 
1010     // Mapping from token ID to approved address.
1011     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1012 
1013     // Mapping from owner to operator approvals
1014     mapping(address => mapping(address => bool)) private _operatorApprovals;
1015 
1016     // =============================================================
1017     //                          CONSTRUCTOR
1018     // =============================================================
1019 
1020     constructor(string memory name_, string memory symbol_) {
1021         _name = name_;
1022         _symbol = symbol_;
1023         _currentIndex = _startTokenId();
1024     }
1025 
1026     // =============================================================
1027     //                   TOKEN COUNTING OPERATIONS
1028     // =============================================================
1029 
1030     /**
1031      * @dev Returns the starting token ID.
1032      * To change the starting token ID, please override this function.
1033      */
1034     function _startTokenId() internal view virtual returns (uint256) {
1035         return 0;
1036     }
1037 
1038     /**
1039      * @dev Returns the next token ID to be minted.
1040      */
1041     function _nextTokenId() internal view virtual returns (uint256) {
1042         return _currentIndex;
1043     }
1044 
1045     /**
1046      * @dev Returns the total number of tokens in existence.
1047      * Burned tokens will reduce the count.
1048      * To get the total number of tokens minted, please see {_totalMinted}.
1049      */
1050     function totalSupply() public view virtual override returns (uint256) {
1051         // Counter underflow is impossible as _burnCounter cannot be incremented
1052         // more than `_currentIndex - _startTokenId()` times.
1053         unchecked {
1054             return _currentIndex - _burnCounter - _startTokenId();
1055         }
1056     }
1057 
1058     /**
1059      * @dev Returns the total amount of tokens minted in the contract.
1060      */
1061     function _totalMinted() internal view virtual returns (uint256) {
1062         // Counter underflow is impossible as `_currentIndex` does not decrement,
1063         // and it is initialized to `_startTokenId()`.
1064         unchecked {
1065             return _currentIndex - _startTokenId();
1066         }
1067     }
1068 
1069     /**
1070      * @dev Returns the total number of tokens burned.
1071      */
1072     function _totalBurned() internal view virtual returns (uint256) {
1073         return _burnCounter;
1074     }
1075 
1076     // =============================================================
1077     //                    ADDRESS DATA OPERATIONS
1078     // =============================================================
1079 
1080     /**
1081      * @dev Returns the number of tokens in `owner`'s account.
1082      */
1083     function balanceOf(address owner) public view virtual override returns (uint256) {
1084         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1085         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1086     }
1087 
1088     /**
1089      * Returns the number of tokens minted by `owner`.
1090      */
1091     function _numberMinted(address owner) internal view returns (uint256) {
1092         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1093     }
1094 
1095     /**
1096      * Returns the number of tokens burned by or on behalf of `owner`.
1097      */
1098     function _numberBurned(address owner) internal view returns (uint256) {
1099         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1100     }
1101 
1102     /**
1103      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1104      */
1105     function _getAux(address owner) internal view returns (uint64) {
1106         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1107     }
1108 
1109     /**
1110      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1111      * If there are multiple variables, please pack them into a uint64.
1112      */
1113     function _setAux(address owner, uint64 aux) internal virtual {
1114         uint256 packed = _packedAddressData[owner];
1115         uint256 auxCasted;
1116         // Cast `aux` with assembly to avoid redundant masking.
1117         assembly {
1118             auxCasted := aux
1119         }
1120         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1121         _packedAddressData[owner] = packed;
1122     }
1123 
1124     // =============================================================
1125     //                            IERC165
1126     // =============================================================
1127 
1128     /**
1129      * @dev Returns true if this contract implements the interface defined by
1130      * `interfaceId`. See the corresponding
1131      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1132      * to learn more about how these ids are created.
1133      *
1134      * This function call must use less than 30000 gas.
1135      */
1136     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1137         // The interface IDs are constants representing the first 4 bytes
1138         // of the XOR of all function selectors in the interface.
1139         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1140         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1141         return
1142             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1143             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1144             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1145     }
1146 
1147     // =============================================================
1148     //                        IERC721Metadata
1149     // =============================================================
1150 
1151     /**
1152      * @dev Returns the token collection name.
1153      */
1154     function name() public view virtual override returns (string memory) {
1155         return _name;
1156     }
1157 
1158     /**
1159      * @dev Returns the token collection symbol.
1160      */
1161     function symbol() public view virtual override returns (string memory) {
1162         return _symbol;
1163     }
1164 
1165     /**
1166      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1167      */
1168     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1169         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1170 
1171         string memory baseURI = _baseURI();
1172         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1173     }
1174 
1175     /**
1176      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1177      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1178      * by default, it can be overridden in child contracts.
1179      */
1180     function _baseURI() internal view virtual returns (string memory) {
1181         return '';
1182     }
1183 
1184     // =============================================================
1185     //                     OWNERSHIPS OPERATIONS
1186     // =============================================================
1187 
1188     /**
1189      * @dev Returns the owner of the `tokenId` token.
1190      *
1191      * Requirements:
1192      *
1193      * - `tokenId` must exist.
1194      */
1195     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1196         return address(uint160(_packedOwnershipOf(tokenId)));
1197     }
1198 
1199     /**
1200      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1201      * It gradually moves to O(1) as tokens get transferred around over time.
1202      */
1203     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1204         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1205     }
1206 
1207     /**
1208      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1209      */
1210     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1211         return _unpackedOwnership(_packedOwnerships[index]);
1212     }
1213 
1214     /**
1215      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1216      */
1217     function _initializeOwnershipAt(uint256 index) internal virtual {
1218         if (_packedOwnerships[index] == 0) {
1219             _packedOwnerships[index] = _packedOwnershipOf(index);
1220         }
1221     }
1222 
1223     /**
1224      * Returns the packed ownership data of `tokenId`.
1225      */
1226     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1227         uint256 curr = tokenId;
1228 
1229         unchecked {
1230             if (_startTokenId() <= curr)
1231                 if (curr < _currentIndex) {
1232                     uint256 packed = _packedOwnerships[curr];
1233                     // If not burned.
1234                     if (packed & _BITMASK_BURNED == 0) {
1235                         // Invariant:
1236                         // There will always be an initialized ownership slot
1237                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1238                         // before an unintialized ownership slot
1239                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1240                         // Hence, `curr` will not underflow.
1241                         //
1242                         // We can directly compare the packed value.
1243                         // If the address is zero, packed will be zero.
1244                         while (packed == 0) {
1245                             packed = _packedOwnerships[--curr];
1246                         }
1247                         return packed;
1248                     }
1249                 }
1250         }
1251         revert OwnerQueryForNonexistentToken();
1252     }
1253 
1254     /**
1255      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1256      */
1257     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1258         ownership.addr = address(uint160(packed));
1259         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1260         ownership.burned = packed & _BITMASK_BURNED != 0;
1261         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1262     }
1263 
1264     /**
1265      * @dev Packs ownership data into a single uint256.
1266      */
1267     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1268         assembly {
1269             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1270             owner := and(owner, _BITMASK_ADDRESS)
1271             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1272             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1273         }
1274     }
1275 
1276     /**
1277      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1278      */
1279     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1280         // For branchless setting of the `nextInitialized` flag.
1281         assembly {
1282             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1283             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1284         }
1285     }
1286 
1287     // =============================================================
1288     //                      APPROVAL OPERATIONS
1289     // =============================================================
1290 
1291     /**
1292      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1293      * The approval is cleared when the token is transferred.
1294      *
1295      * Only a single account can be approved at a time, so approving the
1296      * zero address clears previous approvals.
1297      *
1298      * Requirements:
1299      *
1300      * - The caller must own the token or be an approved operator.
1301      * - `tokenId` must exist.
1302      *
1303      * Emits an {Approval} event.
1304      */
1305     function approve(address to, uint256 tokenId) public payable virtual override {
1306         address owner = ownerOf(tokenId);
1307 
1308         if (_msgSenderERC721A() != owner)
1309             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1310                 revert ApprovalCallerNotOwnerNorApproved();
1311             }
1312 
1313         _tokenApprovals[tokenId].value = to;
1314         emit Approval(owner, to, tokenId);
1315     }
1316 
1317     /**
1318      * @dev Returns the account approved for `tokenId` token.
1319      *
1320      * Requirements:
1321      *
1322      * - `tokenId` must exist.
1323      */
1324     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1325         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1326 
1327         return _tokenApprovals[tokenId].value;
1328     }
1329 
1330     /**
1331      * @dev Approve or remove `operator` as an operator for the caller.
1332      * Operators can call {transferFrom} or {safeTransferFrom}
1333      * for any token owned by the caller.
1334      *
1335      * Requirements:
1336      *
1337      * - The `operator` cannot be the caller.
1338      *
1339      * Emits an {ApprovalForAll} event.
1340      */
1341     function setApprovalForAll(address operator, bool approved) public virtual override {
1342         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1343         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1344     }
1345 
1346     /**
1347      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1348      *
1349      * See {setApprovalForAll}.
1350      */
1351     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1352         return _operatorApprovals[owner][operator];
1353     }
1354 
1355     /**
1356      * @dev Returns whether `tokenId` exists.
1357      *
1358      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1359      *
1360      * Tokens start existing when they are minted. See {_mint}.
1361      */
1362     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1363         return
1364             _startTokenId() <= tokenId &&
1365             tokenId < _currentIndex && // If within bounds,
1366             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1367     }
1368 
1369     /**
1370      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1371      */
1372     function _isSenderApprovedOrOwner(
1373         address approvedAddress,
1374         address owner,
1375         address msgSender
1376     ) private pure returns (bool result) {
1377         assembly {
1378             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1379             owner := and(owner, _BITMASK_ADDRESS)
1380             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1381             msgSender := and(msgSender, _BITMASK_ADDRESS)
1382             // `msgSender == owner || msgSender == approvedAddress`.
1383             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1384         }
1385     }
1386 
1387     /**
1388      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1389      */
1390     function _getApprovedSlotAndAddress(uint256 tokenId)
1391         private
1392         view
1393         returns (uint256 approvedAddressSlot, address approvedAddress)
1394     {
1395         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1396         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1397         assembly {
1398             approvedAddressSlot := tokenApproval.slot
1399             approvedAddress := sload(approvedAddressSlot)
1400         }
1401     }
1402 
1403     // =============================================================
1404     //                      TRANSFER OPERATIONS
1405     // =============================================================
1406 
1407     /**
1408      * @dev Transfers `tokenId` from `from` to `to`.
1409      *
1410      * Requirements:
1411      *
1412      * - `from` cannot be the zero address.
1413      * - `to` cannot be the zero address.
1414      * - `tokenId` token must be owned by `from`.
1415      * - If the caller is not `from`, it must be approved to move this token
1416      * by either {approve} or {setApprovalForAll}.
1417      *
1418      * Emits a {Transfer} event.
1419      */
1420     function transferFrom(
1421         address from,
1422         address to,
1423         uint256 tokenId
1424     ) public payable virtual override {
1425         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1426 
1427         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1428 
1429         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1430 
1431         // The nested ifs save around 20+ gas over a compound boolean condition.
1432         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1433             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1434 
1435         if (to == address(0)) revert TransferToZeroAddress();
1436 
1437         _beforeTokenTransfers(from, to, tokenId, 1);
1438 
1439         // Clear approvals from the previous owner.
1440         assembly {
1441             if approvedAddress {
1442                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1443                 sstore(approvedAddressSlot, 0)
1444             }
1445         }
1446 
1447         // Underflow of the sender's balance is impossible because we check for
1448         // ownership above and the recipient's balance can't realistically overflow.
1449         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1450         unchecked {
1451             // We can directly increment and decrement the balances.
1452             --_packedAddressData[from]; // Updates: `balance -= 1`.
1453             ++_packedAddressData[to]; // Updates: `balance += 1`.
1454 
1455             // Updates:
1456             // - `address` to the next owner.
1457             // - `startTimestamp` to the timestamp of transfering.
1458             // - `burned` to `false`.
1459             // - `nextInitialized` to `true`.
1460             _packedOwnerships[tokenId] = _packOwnershipData(
1461                 to,
1462                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1463             );
1464 
1465             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1466             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1467                 uint256 nextTokenId = tokenId + 1;
1468                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1469                 if (_packedOwnerships[nextTokenId] == 0) {
1470                     // If the next slot is within bounds.
1471                     if (nextTokenId != _currentIndex) {
1472                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1473                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1474                     }
1475                 }
1476             }
1477         }
1478 
1479         emit Transfer(from, to, tokenId);
1480         _afterTokenTransfers(from, to, tokenId, 1);
1481     }
1482 
1483     /**
1484      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1485      */
1486     function safeTransferFrom(
1487         address from,
1488         address to,
1489         uint256 tokenId
1490     ) public payable virtual override {
1491         safeTransferFrom(from, to, tokenId, '');
1492     }
1493 
1494     /**
1495      * @dev Safely transfers `tokenId` token from `from` to `to`.
1496      *
1497      * Requirements:
1498      *
1499      * - `from` cannot be the zero address.
1500      * - `to` cannot be the zero address.
1501      * - `tokenId` token must exist and be owned by `from`.
1502      * - If the caller is not `from`, it must be approved to move this token
1503      * by either {approve} or {setApprovalForAll}.
1504      * - If `to` refers to a smart contract, it must implement
1505      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1506      *
1507      * Emits a {Transfer} event.
1508      */
1509     function safeTransferFrom(
1510         address from,
1511         address to,
1512         uint256 tokenId,
1513         bytes memory _data
1514     ) public payable virtual override {
1515         transferFrom(from, to, tokenId);
1516         if (to.code.length != 0)
1517             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1518                 revert TransferToNonERC721ReceiverImplementer();
1519             }
1520     }
1521 
1522     /**
1523      * @dev Hook that is called before a set of serially-ordered token IDs
1524      * are about to be transferred. This includes minting.
1525      * And also called before burning one token.
1526      *
1527      * `startTokenId` - the first token ID to be transferred.
1528      * `quantity` - the amount to be transferred.
1529      *
1530      * Calling conditions:
1531      *
1532      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1533      * transferred to `to`.
1534      * - When `from` is zero, `tokenId` will be minted for `to`.
1535      * - When `to` is zero, `tokenId` will be burned by `from`.
1536      * - `from` and `to` are never both zero.
1537      */
1538     function _beforeTokenTransfers(
1539         address from,
1540         address to,
1541         uint256 startTokenId,
1542         uint256 quantity
1543     ) internal virtual {}
1544 
1545     /**
1546      * @dev Hook that is called after a set of serially-ordered token IDs
1547      * have been transferred. This includes minting.
1548      * And also called after one token has been burned.
1549      *
1550      * `startTokenId` - the first token ID to be transferred.
1551      * `quantity` - the amount to be transferred.
1552      *
1553      * Calling conditions:
1554      *
1555      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1556      * transferred to `to`.
1557      * - When `from` is zero, `tokenId` has been minted for `to`.
1558      * - When `to` is zero, `tokenId` has been burned by `from`.
1559      * - `from` and `to` are never both zero.
1560      */
1561     function _afterTokenTransfers(
1562         address from,
1563         address to,
1564         uint256 startTokenId,
1565         uint256 quantity
1566     ) internal virtual {}
1567 
1568     /**
1569      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1570      *
1571      * `from` - Previous owner of the given token ID.
1572      * `to` - Target address that will receive the token.
1573      * `tokenId` - Token ID to be transferred.
1574      * `_data` - Optional data to send along with the call.
1575      *
1576      * Returns whether the call correctly returned the expected magic value.
1577      */
1578     function _checkContractOnERC721Received(
1579         address from,
1580         address to,
1581         uint256 tokenId,
1582         bytes memory _data
1583     ) private returns (bool) {
1584         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1585             bytes4 retval
1586         ) {
1587             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1588         } catch (bytes memory reason) {
1589             if (reason.length == 0) {
1590                 revert TransferToNonERC721ReceiverImplementer();
1591             } else {
1592                 assembly {
1593                     revert(add(32, reason), mload(reason))
1594                 }
1595             }
1596         }
1597     }
1598 
1599     // =============================================================
1600     //                        MINT OPERATIONS
1601     // =============================================================
1602 
1603     /**
1604      * @dev Mints `quantity` tokens and transfers them to `to`.
1605      *
1606      * Requirements:
1607      *
1608      * - `to` cannot be the zero address.
1609      * - `quantity` must be greater than 0.
1610      *
1611      * Emits a {Transfer} event for each mint.
1612      */
1613     function _mint(address to, uint256 quantity) internal virtual {
1614         uint256 startTokenId = _currentIndex;
1615         if (quantity == 0) revert MintZeroQuantity();
1616 
1617         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1618 
1619         // Overflows are incredibly unrealistic.
1620         // `balance` and `numberMinted` have a maximum limit of 2**64.
1621         // `tokenId` has a maximum limit of 2**256.
1622         unchecked {
1623             // Updates:
1624             // - `balance += quantity`.
1625             // - `numberMinted += quantity`.
1626             //
1627             // We can directly add to the `balance` and `numberMinted`.
1628             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1629 
1630             // Updates:
1631             // - `address` to the owner.
1632             // - `startTimestamp` to the timestamp of minting.
1633             // - `burned` to `false`.
1634             // - `nextInitialized` to `quantity == 1`.
1635             _packedOwnerships[startTokenId] = _packOwnershipData(
1636                 to,
1637                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1638             );
1639 
1640             uint256 toMasked;
1641             uint256 end = startTokenId + quantity;
1642 
1643             // Use assembly to loop and emit the `Transfer` event for gas savings.
1644             // The duplicated `log4` removes an extra check and reduces stack juggling.
1645             // The assembly, together with the surrounding Solidity code, have been
1646             // delicately arranged to nudge the compiler into producing optimized opcodes.
1647             assembly {
1648                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1649                 toMasked := and(to, _BITMASK_ADDRESS)
1650                 // Emit the `Transfer` event.
1651                 log4(
1652                     0, // Start of data (0, since no data).
1653                     0, // End of data (0, since no data).
1654                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1655                     0, // `address(0)`.
1656                     toMasked, // `to`.
1657                     startTokenId // `tokenId`.
1658                 )
1659 
1660                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1661                 // that overflows uint256 will make the loop run out of gas.
1662                 // The compiler will optimize the `iszero` away for performance.
1663                 for {
1664                     let tokenId := add(startTokenId, 1)
1665                 } iszero(eq(tokenId, end)) {
1666                     tokenId := add(tokenId, 1)
1667                 } {
1668                     // Emit the `Transfer` event. Similar to above.
1669                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1670                 }
1671             }
1672             if (toMasked == 0) revert MintToZeroAddress();
1673 
1674             _currentIndex = end;
1675         }
1676         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1677     }
1678 
1679     /**
1680      * @dev Mints `quantity` tokens and transfers them to `to`.
1681      *
1682      * This function is intended for efficient minting only during contract creation.
1683      *
1684      * It emits only one {ConsecutiveTransfer} as defined in
1685      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1686      * instead of a sequence of {Transfer} event(s).
1687      *
1688      * Calling this function outside of contract creation WILL make your contract
1689      * non-compliant with the ERC721 standard.
1690      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1691      * {ConsecutiveTransfer} event is only permissible during contract creation.
1692      *
1693      * Requirements:
1694      *
1695      * - `to` cannot be the zero address.
1696      * - `quantity` must be greater than 0.
1697      *
1698      * Emits a {ConsecutiveTransfer} event.
1699      */
1700     function _mintERC2309(address to, uint256 quantity) internal virtual {
1701         uint256 startTokenId = _currentIndex;
1702         if (to == address(0)) revert MintToZeroAddress();
1703         if (quantity == 0) revert MintZeroQuantity();
1704         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1705 
1706         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1707 
1708         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1709         unchecked {
1710             // Updates:
1711             // - `balance += quantity`.
1712             // - `numberMinted += quantity`.
1713             //
1714             // We can directly add to the `balance` and `numberMinted`.
1715             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1716 
1717             // Updates:
1718             // - `address` to the owner.
1719             // - `startTimestamp` to the timestamp of minting.
1720             // - `burned` to `false`.
1721             // - `nextInitialized` to `quantity == 1`.
1722             _packedOwnerships[startTokenId] = _packOwnershipData(
1723                 to,
1724                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1725             );
1726 
1727             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1728 
1729             _currentIndex = startTokenId + quantity;
1730         }
1731         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1732     }
1733 
1734     /**
1735      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1736      *
1737      * Requirements:
1738      *
1739      * - If `to` refers to a smart contract, it must implement
1740      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1741      * - `quantity` must be greater than 0.
1742      *
1743      * See {_mint}.
1744      *
1745      * Emits a {Transfer} event for each mint.
1746      */
1747     function _safeMint(
1748         address to,
1749         uint256 quantity,
1750         bytes memory _data
1751     ) internal virtual {
1752         _mint(to, quantity);
1753 
1754         unchecked {
1755             if (to.code.length != 0) {
1756                 uint256 end = _currentIndex;
1757                 uint256 index = end - quantity;
1758                 do {
1759                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1760                         revert TransferToNonERC721ReceiverImplementer();
1761                     }
1762                 } while (index < end);
1763                 // Reentrancy protection.
1764                 if (_currentIndex != end) revert();
1765             }
1766         }
1767     }
1768 
1769     /**
1770      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1771      */
1772     function _safeMint(address to, uint256 quantity) internal virtual {
1773         _safeMint(to, quantity, '');
1774     }
1775 
1776     // =============================================================
1777     //                        BURN OPERATIONS
1778     // =============================================================
1779 
1780     /**
1781      * @dev Equivalent to `_burn(tokenId, false)`.
1782      */
1783     function _burn(uint256 tokenId) internal virtual {
1784         _burn(tokenId, false);
1785     }
1786 
1787     /**
1788      * @dev Destroys `tokenId`.
1789      * The approval is cleared when the token is burned.
1790      *
1791      * Requirements:
1792      *
1793      * - `tokenId` must exist.
1794      *
1795      * Emits a {Transfer} event.
1796      */
1797     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1798         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1799 
1800         address from = address(uint160(prevOwnershipPacked));
1801 
1802         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1803 
1804         if (approvalCheck) {
1805             // The nested ifs save around 20+ gas over a compound boolean condition.
1806             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1807                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1808         }
1809 
1810         _beforeTokenTransfers(from, address(0), tokenId, 1);
1811 
1812         // Clear approvals from the previous owner.
1813         assembly {
1814             if approvedAddress {
1815                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1816                 sstore(approvedAddressSlot, 0)
1817             }
1818         }
1819 
1820         // Underflow of the sender's balance is impossible because we check for
1821         // ownership above and the recipient's balance can't realistically overflow.
1822         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1823         unchecked {
1824             // Updates:
1825             // - `balance -= 1`.
1826             // - `numberBurned += 1`.
1827             //
1828             // We can directly decrement the balance, and increment the number burned.
1829             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1830             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1831 
1832             // Updates:
1833             // - `address` to the last owner.
1834             // - `startTimestamp` to the timestamp of burning.
1835             // - `burned` to `true`.
1836             // - `nextInitialized` to `true`.
1837             _packedOwnerships[tokenId] = _packOwnershipData(
1838                 from,
1839                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1840             );
1841 
1842             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1843             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1844                 uint256 nextTokenId = tokenId + 1;
1845                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1846                 if (_packedOwnerships[nextTokenId] == 0) {
1847                     // If the next slot is within bounds.
1848                     if (nextTokenId != _currentIndex) {
1849                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1850                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1851                     }
1852                 }
1853             }
1854         }
1855 
1856         emit Transfer(from, address(0), tokenId);
1857         _afterTokenTransfers(from, address(0), tokenId, 1);
1858 
1859         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1860         unchecked {
1861             _burnCounter++;
1862         }
1863     }
1864 
1865     // =============================================================
1866     //                     EXTRA DATA OPERATIONS
1867     // =============================================================
1868 
1869     /**
1870      * @dev Directly sets the extra data for the ownership data `index`.
1871      */
1872     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1873         uint256 packed = _packedOwnerships[index];
1874         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1875         uint256 extraDataCasted;
1876         // Cast `extraData` with assembly to avoid redundant masking.
1877         assembly {
1878             extraDataCasted := extraData
1879         }
1880         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1881         _packedOwnerships[index] = packed;
1882     }
1883 
1884     /**
1885      * @dev Called during each token transfer to set the 24bit `extraData` field.
1886      * Intended to be overridden by the cosumer contract.
1887      *
1888      * `previousExtraData` - the value of `extraData` before transfer.
1889      *
1890      * Calling conditions:
1891      *
1892      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1893      * transferred to `to`.
1894      * - When `from` is zero, `tokenId` will be minted for `to`.
1895      * - When `to` is zero, `tokenId` will be burned by `from`.
1896      * - `from` and `to` are never both zero.
1897      */
1898     function _extraData(
1899         address from,
1900         address to,
1901         uint24 previousExtraData
1902     ) internal view virtual returns (uint24) {}
1903 
1904     /**
1905      * @dev Returns the next extra data for the packed ownership data.
1906      * The returned result is shifted into position.
1907      */
1908     function _nextExtraData(
1909         address from,
1910         address to,
1911         uint256 prevOwnershipPacked
1912     ) private view returns (uint256) {
1913         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1914         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1915     }
1916 
1917     // =============================================================
1918     //                       OTHER OPERATIONS
1919     // =============================================================
1920 
1921     /**
1922      * @dev Returns the message sender (defaults to `msg.sender`).
1923      *
1924      * If you are writing GSN compatible contracts, you need to override this function.
1925      */
1926     function _msgSenderERC721A() internal view virtual returns (address) {
1927         return msg.sender;
1928     }
1929 
1930     /**
1931      * @dev Converts a uint256 to its ASCII string decimal representation.
1932      */
1933     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1934         assembly {
1935             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1936             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1937             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1938             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1939             let m := add(mload(0x40), 0xa0)
1940             // Update the free memory pointer to allocate.
1941             mstore(0x40, m)
1942             // Assign the `str` to the end.
1943             str := sub(m, 0x20)
1944             // Zeroize the slot after the string.
1945             mstore(str, 0)
1946 
1947             // Cache the end of the memory to calculate the length later.
1948             let end := str
1949 
1950             // We write the string from rightmost digit to leftmost digit.
1951             // The following is essentially a do-while loop that also handles the zero case.
1952             // prettier-ignore
1953             for { let temp := value } 1 {} {
1954                 str := sub(str, 1)
1955                 // Write the character to the pointer.
1956                 // The ASCII index of the '0' character is 48.
1957                 mstore8(str, add(48, mod(temp, 10)))
1958                 // Keep dividing `temp` until zero.
1959                 temp := div(temp, 10)
1960                 // prettier-ignore
1961                 if iszero(temp) { break }
1962             }
1963 
1964             let length := sub(end, str)
1965             // Move the pointer 32 bytes leftwards to make room for the length.
1966             str := sub(str, 0x20)
1967             // Store the length.
1968             mstore(str, length)
1969         }
1970     }
1971 }
1972 
1973 // File: contracts\contract.sol
1974 
1975 //SPDX-License-Identifier: MIT
1976 
1977 pragma solidity ^0.8.19;
1978 contract MagicalSquad  is ERC721A, Ownable, ReentrancyGuard {
1979 	using Strings for uint256;
1980 
1981 	uint256 public maxSupply = 420;
1982     uint256 public maxFreeSupply = 420;
1983     uint256 public cost = 0.0042 ether;
1984     uint256 public freeAmount = 1;
1985     uint256 public maxPerWallet = 5;
1986 
1987     bool public isRevealed = true;
1988 	bool public pause = false;
1989 
1990     string private baseURL = "";
1991     string public hiddenMetadataUrl = "reveal";
1992 
1993     mapping(address => uint256) public userBalance;
1994 
1995 	constructor(
1996         string memory _baseMetadataUrl
1997 	)
1998 	ERC721A("Magical Squad", "Magical Squad") {
1999         setBaseUri(_baseMetadataUrl);
2000     }
2001 
2002 	function _baseURI() internal view override returns (string memory) {
2003 		return baseURL;
2004 	}
2005 
2006     function setBaseUri(string memory _baseURL) public onlyOwner {
2007 	    baseURL = _baseURL;
2008 	}
2009 
2010     function mint(uint256 mintAmount) external payable {
2011 		require(!pause, "The sale is paused");
2012         if(userBalance[msg.sender] >= freeAmount) require(msg.value >= cost * mintAmount, "Insufficient funds");
2013         else{
2014             if(totalSupply() + mintAmount <= maxFreeSupply) require(msg.value >= cost * (mintAmount - (freeAmount - userBalance[msg.sender])), "Insufficient funds");
2015             else require(msg.value >= cost * mintAmount, "Insufficient funds");
2016         }
2017         require(_totalMinted() + mintAmount <= maxSupply,"Exceeds max supply");
2018         require(userBalance[msg.sender] + mintAmount <= maxPerWallet, "Exceeds max per wallet");
2019         _safeMint(msg.sender, mintAmount);
2020         userBalance[msg.sender] = userBalance[msg.sender] + mintAmount;
2021 	}
2022 
2023     function airdrop(address to, uint256 mintAmount) external onlyOwner {
2024 		require(
2025 			_totalMinted() + mintAmount <= maxSupply,
2026 			"Exceeds max supply"
2027 		);
2028 		_safeMint(to, mintAmount);
2029         
2030 	}
2031 
2032     function sethiddenMetadataUrl(string memory _hiddenMetadataUrl) public onlyOwner {
2033 	    hiddenMetadataUrl = _hiddenMetadataUrl;
2034 	}
2035 
2036     function reveal(bool _state) external onlyOwner {
2037 	    isRevealed = _state;
2038 	}
2039 
2040 	function _startTokenId() internal view virtual override returns (uint256) {
2041     	return 1;
2042   	}
2043 
2044 	function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
2045 		maxSupply = newMaxSupply;
2046 	}
2047 
2048     function setMaxFreeSupply(uint256 newMaxFreeSupply) external onlyOwner {
2049 		maxFreeSupply = newMaxFreeSupply;
2050 	}
2051 
2052 	function tokenURI(uint256 tokenId)
2053 		public
2054 		view
2055 		override
2056 		returns (string memory)
2057 	{
2058         require(_exists(tokenId), "That token doesn't exist");
2059         if(isRevealed == false) {
2060             return hiddenMetadataUrl;
2061         }
2062         else return bytes(_baseURI()).length > 0 
2063             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
2064             : "";
2065 	}
2066 
2067 	function setCost(uint256 _newCost) public onlyOwner{
2068 		cost = _newCost;
2069 	}
2070 
2071 	function setPause(bool _state) public onlyOwner{
2072 		pause = _state;
2073 	}
2074 
2075     function setFreeAmount(uint256 _newAmt) public onlyOwner{
2076         require(_newAmt < maxPerWallet, "Not possible");
2077         freeAmount = _newAmt;
2078     }
2079 
2080     function setMaxPerWallet(uint256 _newAmt) public  onlyOwner{
2081         require(_newAmt > freeAmount, "Not possible");
2082         maxPerWallet = _newAmt;
2083     }
2084 
2085 	function withdraw() external onlyOwner {
2086 		(bool success, ) = payable(owner()).call{
2087             value: address(this).balance
2088         }("");
2089         require(success);
2090 	}
2091 }