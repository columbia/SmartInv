1 // File: Summonpals.sol
2 
3 // File: @openzeppelin\contracts\security\ReentrancyGuard.sol
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
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
72 }
73 
74 // File: @openzeppelin\contracts\utils\Context.sol
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin\contracts\access\Ownable.sol
101 
102 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Throws if called by any account other than the owner.
132      */
133     modifier onlyOwner() {
134         _checkOwner();
135         _;
136     }
137 
138     /**
139      * @dev Returns the address of the current owner.
140      */
141     function owner() public view virtual returns (address) {
142         return _owner;
143     }
144 
145     /**
146      * @dev Throws if the sender is not the owner.
147      */
148     function _checkOwner() internal view virtual {
149         require(owner() == _msgSender(), "Ownable: caller is not the owner");
150     }
151 
152     /**
153      * @dev Leaves the contract without owner. It will not be possible to call
154      * `onlyOwner` functions anymore. Can only be called by the current owner.
155      *
156      * NOTE: Renouncing ownership will leave the contract without an owner,
157      * thereby removing any functionality that is only available to the owner.
158      */
159     function renounceOwnership() public virtual onlyOwner {
160         _transferOwnership(address(0));
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Can only be called by the current owner.
166      */
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         _transferOwnership(newOwner);
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Internal function without access restriction.
175      */
176     function _transferOwnership(address newOwner) internal virtual {
177         address oldOwner = _owner;
178         _owner = newOwner;
179         emit OwnershipTransferred(oldOwner, newOwner);
180     }
181 }
182 
183 // File: @openzeppelin\contracts\utils\math\Math.sol
184 
185 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev Standard math utilities missing in the Solidity language.
191  */
192 library Math {
193     enum Rounding {
194         Down, // Toward negative infinity
195         Up, // Toward infinity
196         Zero // Toward zero
197     }
198 
199     /**
200      * @dev Returns the largest of two numbers.
201      */
202     function max(uint256 a, uint256 b) internal pure returns (uint256) {
203         return a > b ? a : b;
204     }
205 
206     /**
207      * @dev Returns the smallest of two numbers.
208      */
209     function min(uint256 a, uint256 b) internal pure returns (uint256) {
210         return a < b ? a : b;
211     }
212 
213     /**
214      * @dev Returns the average of two numbers. The result is rounded towards
215      * zero.
216      */
217     function average(uint256 a, uint256 b) internal pure returns (uint256) {
218         // (a + b) / 2 can overflow.
219         return (a & b) + (a ^ b) / 2;
220     }
221 
222     /**
223      * @dev Returns the ceiling of the division of two numbers.
224      *
225      * This differs from standard division with `/` in that it rounds up instead
226      * of rounding down.
227      */
228     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
229         // (a + b - 1) / b can overflow on addition, so we distribute.
230         return a == 0 ? 0 : (a - 1) / b + 1;
231     }
232 
233     /**
234      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
235      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
236      * with further edits by Uniswap Labs also under MIT license.
237      */
238     function mulDiv(
239         uint256 x,
240         uint256 y,
241         uint256 denominator
242     ) internal pure returns (uint256 result) {
243         unchecked {
244             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
245             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
246             // variables such that product = prod1 * 2^256 + prod0.
247             uint256 prod0; // Least significant 256 bits of the product
248             uint256 prod1; // Most significant 256 bits of the product
249             assembly {
250                 let mm := mulmod(x, y, not(0))
251                 prod0 := mul(x, y)
252                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
253             }
254 
255             // Handle non-overflow cases, 256 by 256 division.
256             if (prod1 == 0) {
257                 return prod0 / denominator;
258             }
259 
260             // Make sure the result is less than 2^256. Also prevents denominator == 0.
261             require(denominator > prod1);
262 
263             ///////////////////////////////////////////////
264             // 512 by 256 division.
265             ///////////////////////////////////////////////
266 
267             // Make division exact by subtracting the remainder from [prod1 prod0].
268             uint256 remainder;
269             assembly {
270                 // Compute remainder using mulmod.
271                 remainder := mulmod(x, y, denominator)
272 
273                 // Subtract 256 bit number from 512 bit number.
274                 prod1 := sub(prod1, gt(remainder, prod0))
275                 prod0 := sub(prod0, remainder)
276             }
277 
278             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
279             // See https://cs.stackexchange.com/q/138556/92363.
280 
281             // Does not overflow because the denominator cannot be zero at this stage in the function.
282             uint256 twos = denominator & (~denominator + 1);
283             assembly {
284                 // Divide denominator by twos.
285                 denominator := div(denominator, twos)
286 
287                 // Divide [prod1 prod0] by twos.
288                 prod0 := div(prod0, twos)
289 
290                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
291                 twos := add(div(sub(0, twos), twos), 1)
292             }
293 
294             // Shift in bits from prod1 into prod0.
295             prod0 |= prod1 * twos;
296 
297             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
298             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
299             // four bits. That is, denominator * inv = 1 mod 2^4.
300             uint256 inverse = (3 * denominator) ^ 2;
301 
302             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
303             // in modular arithmetic, doubling the correct bits in each step.
304             inverse *= 2 - denominator * inverse; // inverse mod 2^8
305             inverse *= 2 - denominator * inverse; // inverse mod 2^16
306             inverse *= 2 - denominator * inverse; // inverse mod 2^32
307             inverse *= 2 - denominator * inverse; // inverse mod 2^64
308             inverse *= 2 - denominator * inverse; // inverse mod 2^128
309             inverse *= 2 - denominator * inverse; // inverse mod 2^256
310 
311             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
312             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
313             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
314             // is no longer required.
315             result = prod0 * inverse;
316             return result;
317         }
318     }
319 
320     /**
321      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
322      */
323     function mulDiv(
324         uint256 x,
325         uint256 y,
326         uint256 denominator,
327         Rounding rounding
328     ) internal pure returns (uint256) {
329         uint256 result = mulDiv(x, y, denominator);
330         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
331             result += 1;
332         }
333         return result;
334     }
335 
336     /**
337      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
338      *
339      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
340      */
341     function sqrt(uint256 a) internal pure returns (uint256) {
342         if (a == 0) {
343             return 0;
344         }
345 
346         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
347         //
348         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
349         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
350         //
351         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
352         // ÔåÆ `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
353         // ÔåÆ `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
354         //
355         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
356         uint256 result = 1 << (log2(a) >> 1);
357 
358         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
359         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
360         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
361         // into the expected uint128 result.
362         unchecked {
363             result = (result + a / result) >> 1;
364             result = (result + a / result) >> 1;
365             result = (result + a / result) >> 1;
366             result = (result + a / result) >> 1;
367             result = (result + a / result) >> 1;
368             result = (result + a / result) >> 1;
369             result = (result + a / result) >> 1;
370             return min(result, a / result);
371         }
372     }
373 
374     /**
375      * @notice Calculates sqrt(a), following the selected rounding direction.
376      */
377     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
378         unchecked {
379             uint256 result = sqrt(a);
380             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
381         }
382     }
383 
384     /**
385      * @dev Return the log in base 2, rounded down, of a positive value.
386      * Returns 0 if given 0.
387      */
388     function log2(uint256 value) internal pure returns (uint256) {
389         uint256 result = 0;
390         unchecked {
391             if (value >> 128 > 0) {
392                 value >>= 128;
393                 result += 128;
394             }
395             if (value >> 64 > 0) {
396                 value >>= 64;
397                 result += 64;
398             }
399             if (value >> 32 > 0) {
400                 value >>= 32;
401                 result += 32;
402             }
403             if (value >> 16 > 0) {
404                 value >>= 16;
405                 result += 16;
406             }
407             if (value >> 8 > 0) {
408                 value >>= 8;
409                 result += 8;
410             }
411             if (value >> 4 > 0) {
412                 value >>= 4;
413                 result += 4;
414             }
415             if (value >> 2 > 0) {
416                 value >>= 2;
417                 result += 2;
418             }
419             if (value >> 1 > 0) {
420                 result += 1;
421             }
422         }
423         return result;
424     }
425 
426     /**
427      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
428      * Returns 0 if given 0.
429      */
430     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
431         unchecked {
432             uint256 result = log2(value);
433             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
434         }
435     }
436 
437     /**
438      * @dev Return the log in base 10, rounded down, of a positive value.
439      * Returns 0 if given 0.
440      */
441     function log10(uint256 value) internal pure returns (uint256) {
442         uint256 result = 0;
443         unchecked {
444             if (value >= 10**64) {
445                 value /= 10**64;
446                 result += 64;
447             }
448             if (value >= 10**32) {
449                 value /= 10**32;
450                 result += 32;
451             }
452             if (value >= 10**16) {
453                 value /= 10**16;
454                 result += 16;
455             }
456             if (value >= 10**8) {
457                 value /= 10**8;
458                 result += 8;
459             }
460             if (value >= 10**4) {
461                 value /= 10**4;
462                 result += 4;
463             }
464             if (value >= 10**2) {
465                 value /= 10**2;
466                 result += 2;
467             }
468             if (value >= 10**1) {
469                 result += 1;
470             }
471         }
472         return result;
473     }
474 
475     /**
476      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
477      * Returns 0 if given 0.
478      */
479     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
480         unchecked {
481             uint256 result = log10(value);
482             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
483         }
484     }
485 
486     /**
487      * @dev Return the log in base 256, rounded down, of a positive value.
488      * Returns 0 if given 0.
489      *
490      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
491      */
492     function log256(uint256 value) internal pure returns (uint256) {
493         uint256 result = 0;
494         unchecked {
495             if (value >> 128 > 0) {
496                 value >>= 128;
497                 result += 16;
498             }
499             if (value >> 64 > 0) {
500                 value >>= 64;
501                 result += 8;
502             }
503             if (value >> 32 > 0) {
504                 value >>= 32;
505                 result += 4;
506             }
507             if (value >> 16 > 0) {
508                 value >>= 16;
509                 result += 2;
510             }
511             if (value >> 8 > 0) {
512                 result += 1;
513             }
514         }
515         return result;
516     }
517 
518     /**
519      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
520      * Returns 0 if given 0.
521      */
522     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
523         unchecked {
524             uint256 result = log256(value);
525             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
526         }
527     }
528 }
529 
530 // File: @openzeppelin\contracts\utils\Strings.sol
531 
532 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @dev String operations.
538  */
539 library Strings {
540     bytes16 private constant _SYMBOLS = "0123456789abcdef";
541     uint8 private constant _ADDRESS_LENGTH = 20;
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
545      */
546     function toString(uint256 value) internal pure returns (string memory) {
547         unchecked {
548             uint256 length = Math.log10(value) + 1;
549             string memory buffer = new string(length);
550             uint256 ptr;
551             /// @solidity memory-safe-assembly
552             assembly {
553                 ptr := add(buffer, add(32, length))
554             }
555             while (true) {
556                 ptr--;
557                 /// @solidity memory-safe-assembly
558                 assembly {
559                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
560                 }
561                 value /= 10;
562                 if (value == 0) break;
563             }
564             return buffer;
565         }
566     }
567 
568     /**
569      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
570      */
571     function toHexString(uint256 value) internal pure returns (string memory) {
572         unchecked {
573             return toHexString(value, Math.log256(value) + 1);
574         }
575     }
576 
577     /**
578      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
579      */
580     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
581         bytes memory buffer = new bytes(2 * length + 2);
582         buffer[0] = "0";
583         buffer[1] = "x";
584         for (uint256 i = 2 * length + 1; i > 1; --i) {
585             buffer[i] = _SYMBOLS[value & 0xf];
586             value >>= 4;
587         }
588         require(value == 0, "Strings: hex length insufficient");
589         return string(buffer);
590     }
591 
592     /**
593      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
594      */
595     function toHexString(address addr) internal pure returns (string memory) {
596         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
597     }
598 }
599 
600 // File: node_modules\erc721a\contracts\IERC721A.sol
601 
602 // ERC721A Contracts v4.2.3
603 // Creator: Chiru Labs
604 
605 pragma solidity ^0.8.4;
606 
607 /**
608  * @dev Interface of ERC721A.
609  */
610 interface IERC721A {
611     /**
612      * The caller must own the token or be an approved operator.
613      */
614     error ApprovalCallerNotOwnerNorApproved();
615 
616     /**
617      * The token does not exist.
618      */
619     error ApprovalQueryForNonexistentToken();
620 
621     /**
622      * Cannot query the balance for the zero address.
623      */
624     error BalanceQueryForZeroAddress();
625 
626     /**
627      * Cannot mint to the zero address.
628      */
629     error MintToZeroAddress();
630 
631     /**
632      * The quantity of tokens minted must be more than zero.
633      */
634     error MintZeroQuantity();
635 
636     /**
637      * The token does not exist.
638      */
639     error OwnerQueryForNonexistentToken();
640 
641     /**
642      * The caller must own the token or be an approved operator.
643      */
644     error TransferCallerNotOwnerNorApproved();
645 
646     /**
647      * The token must be owned by `from`.
648      */
649     error TransferFromIncorrectOwner();
650 
651     /**
652      * Cannot safely transfer to a contract that does not implement the
653      * ERC721Receiver interface.
654      */
655     error TransferToNonERC721ReceiverImplementer();
656 
657     /**
658      * Cannot transfer to the zero address.
659      */
660     error TransferToZeroAddress();
661 
662     /**
663      * The token does not exist.
664      */
665     error URIQueryForNonexistentToken();
666 
667     /**
668      * The `quantity` minted with ERC2309 exceeds the safety limit.
669      */
670     error MintERC2309QuantityExceedsLimit();
671 
672     /**
673      * The `extraData` cannot be set on an unintialized ownership slot.
674      */
675     error OwnershipNotInitializedForExtraData();
676 
677     // =============================================================
678     //                            STRUCTS
679     // =============================================================
680 
681     struct TokenOwnership {
682         // The address of the owner.
683         address addr;
684         // Stores the start time of ownership with minimal overhead for tokenomics.
685         uint64 startTimestamp;
686         // Whether the token has been burned.
687         bool burned;
688         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
689         uint24 extraData;
690     }
691 
692     // =============================================================
693     //                         TOKEN COUNTERS
694     // =============================================================
695 
696     /**
697      * @dev Returns the total number of tokens in existence.
698      * Burned tokens will reduce the count.
699      * To get the total number of tokens minted, please see {_totalMinted}.
700      */
701     function totalSupply() external view returns (uint256);
702 
703     // =============================================================
704     //                            IERC165
705     // =============================================================
706 
707     /**
708      * @dev Returns true if this contract implements the interface defined by
709      * `interfaceId`. See the corresponding
710      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
711      * to learn more about how these ids are created.
712      *
713      * This function call must use less than 30000 gas.
714      */
715     function supportsInterface(bytes4 interfaceId) external view returns (bool);
716 
717     // =============================================================
718     //                            IERC721
719     // =============================================================
720 
721     /**
722      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
723      */
724     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
725 
726     /**
727      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
728      */
729     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
730 
731     /**
732      * @dev Emitted when `owner` enables or disables
733      * (`approved`) `operator` to manage all of its assets.
734      */
735     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
736 
737     /**
738      * @dev Returns the number of tokens in `owner`'s account.
739      */
740     function balanceOf(address owner) external view returns (uint256 balance);
741 
742     /**
743      * @dev Returns the owner of the `tokenId` token.
744      *
745      * Requirements:
746      *
747      * - `tokenId` must exist.
748      */
749     function ownerOf(uint256 tokenId) external view returns (address owner);
750 
751     /**
752      * @dev Safely transfers `tokenId` token from `from` to `to`,
753      * checking first that contract recipients are aware of the ERC721 protocol
754      * to prevent tokens from being forever locked.
755      *
756      * Requirements:
757      *
758      * - `from` cannot be the zero address.
759      * - `to` cannot be the zero address.
760      * - `tokenId` token must exist and be owned by `from`.
761      * - If the caller is not `from`, it must be have been allowed to move
762      * this token by either {approve} or {setApprovalForAll}.
763      * - If `to` refers to a smart contract, it must implement
764      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765      *
766      * Emits a {Transfer} event.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes calldata data
773     ) external payable;
774 
775     /**
776      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId
782     ) external payable;
783 
784     /**
785      * @dev Transfers `tokenId` from `from` to `to`.
786      *
787      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
788      * whenever possible.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must be owned by `from`.
795      * - If the caller is not `from`, it must be approved to move this token
796      * by either {approve} or {setApprovalForAll}.
797      *
798      * Emits a {Transfer} event.
799      */
800     function transferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external payable;
805 
806     /**
807      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
808      * The approval is cleared when the token is transferred.
809      *
810      * Only a single account can be approved at a time, so approving the
811      * zero address clears previous approvals.
812      *
813      * Requirements:
814      *
815      * - The caller must own the token or be an approved operator.
816      * - `tokenId` must exist.
817      *
818      * Emits an {Approval} event.
819      */
820     function approve(address to, uint256 tokenId) external payable;
821 
822     /**
823      * @dev Approve or remove `operator` as an operator for the caller.
824      * Operators can call {transferFrom} or {safeTransferFrom}
825      * for any token owned by the caller.
826      *
827      * Requirements:
828      *
829      * - The `operator` cannot be the caller.
830      *
831      * Emits an {ApprovalForAll} event.
832      */
833     function setApprovalForAll(address operator, bool _approved) external;
834 
835     /**
836      * @dev Returns the account approved for `tokenId` token.
837      *
838      * Requirements:
839      *
840      * - `tokenId` must exist.
841      */
842     function getApproved(uint256 tokenId) external view returns (address operator);
843 
844     /**
845      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
846      *
847      * See {setApprovalForAll}.
848      */
849     function isApprovedForAll(address owner, address operator) external view returns (bool);
850 
851     // =============================================================
852     //                        IERC721Metadata
853     // =============================================================
854 
855     /**
856      * @dev Returns the token collection name.
857      */
858     function name() external view returns (string memory);
859 
860     /**
861      * @dev Returns the token collection symbol.
862      */
863     function symbol() external view returns (string memory);
864 
865     /**
866      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
867      */
868     function tokenURI(uint256 tokenId) external view returns (string memory);
869 
870     // =============================================================
871     //                           IERC2309
872     // =============================================================
873 
874     /**
875      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
876      * (inclusive) is transferred from `from` to `to`, as defined in the
877      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
878      *
879      * See {_mintERC2309} for more details.
880      */
881     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
882 }
883 
884 // File: erc721a\contracts\ERC721A.sol
885 
886 // ERC721A Contracts v4.2.3
887 // Creator: Chiru Labs
888 
889 pragma solidity ^0.8.4;
890 
891 /**
892  * @dev Interface of ERC721 token receiver.
893  */
894 interface ERC721A__IERC721Receiver {
895     function onERC721Received(
896         address operator,
897         address from,
898         uint256 tokenId,
899         bytes calldata data
900     ) external returns (bytes4);
901 }
902 
903 /**
904  * @title ERC721A
905  *
906  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
907  * Non-Fungible Token Standard, including the Metadata extension.
908  * Optimized for lower gas during batch mints.
909  *
910  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
911  * starting from `_startTokenId()`.
912  *
913  * Assumptions:
914  *
915  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
916  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
917  */
918 contract ERC721A is IERC721A {
919     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
920     struct TokenApprovalRef {
921         address value;
922     }
923 
924     // =============================================================
925     //                           CONSTANTS
926     // =============================================================
927 
928     // Mask of an entry in packed address data.
929     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
930 
931     // The bit position of `numberMinted` in packed address data.
932     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
933 
934     // The bit position of `numberBurned` in packed address data.
935     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
936 
937     // The bit position of `aux` in packed address data.
938     uint256 private constant _BITPOS_AUX = 192;
939 
940     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
941     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
942 
943     // The bit position of `startTimestamp` in packed ownership.
944     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
945 
946     // The bit mask of the `burned` bit in packed ownership.
947     uint256 private constant _BITMASK_BURNED = 1 << 224;
948 
949     // The bit position of the `nextInitialized` bit in packed ownership.
950     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
951 
952     // The bit mask of the `nextInitialized` bit in packed ownership.
953     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
954 
955     // The bit position of `extraData` in packed ownership.
956     uint256 private constant _BITPOS_EXTRA_DATA = 232;
957 
958     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
959     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
960 
961     // The mask of the lower 160 bits for addresses.
962     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
963 
964     // The maximum `quantity` that can be minted with {_mintERC2309}.
965     // This limit is to prevent overflows on the address data entries.
966     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
967     // is required to cause an overflow, which is unrealistic.
968     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
969 
970     // The `Transfer` event signature is given by:
971     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
972     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
973         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
974 
975     // =============================================================
976     //                            STORAGE
977     // =============================================================
978 
979     // The next token ID to be minted.
980     uint256 private _currentIndex;
981 
982     // The number of tokens burned.
983     uint256 private _burnCounter;
984 
985     // Token name
986     string private _name;
987 
988     // Token symbol
989     string private _symbol;
990 
991     // Mapping from token ID to ownership details
992     // An empty struct value does not necessarily mean the token is unowned.
993     // See {_packedOwnershipOf} implementation for details.
994     //
995     // Bits Layout:
996     // - [0..159]   `addr`
997     // - [160..223] `startTimestamp`
998     // - [224]      `burned`
999     // - [225]      `nextInitialized`
1000     // - [232..255] `extraData`
1001     mapping(uint256 => uint256) private _packedOwnerships;
1002 
1003     // Mapping owner address to address data.
1004     //
1005     // Bits Layout:
1006     // - [0..63]    `balance`
1007     // - [64..127]  `numberMinted`
1008     // - [128..191] `numberBurned`
1009     // - [192..255] `aux`
1010     mapping(address => uint256) private _packedAddressData;
1011 
1012     // Mapping from token ID to approved address.
1013     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1014 
1015     // Mapping from owner to operator approvals
1016     mapping(address => mapping(address => bool)) private _operatorApprovals;
1017 
1018     // =============================================================
1019     //                          CONSTRUCTOR
1020     // =============================================================
1021 
1022     constructor(string memory name_, string memory symbol_) {
1023         _name = name_;
1024         _symbol = symbol_;
1025         _currentIndex = _startTokenId();
1026     }
1027 
1028     // =============================================================
1029     //                   TOKEN COUNTING OPERATIONS
1030     // =============================================================
1031 
1032     /**
1033      * @dev Returns the starting token ID.
1034      * To change the starting token ID, please override this function.
1035      */
1036     function _startTokenId() internal view virtual returns (uint256) {
1037         return 0;
1038     }
1039 
1040     /**
1041      * @dev Returns the next token ID to be minted.
1042      */
1043     function _nextTokenId() internal view virtual returns (uint256) {
1044         return _currentIndex;
1045     }
1046 
1047     /**
1048      * @dev Returns the total number of tokens in existence.
1049      * Burned tokens will reduce the count.
1050      * To get the total number of tokens minted, please see {_totalMinted}.
1051      */
1052     function totalSupply() public view virtual override returns (uint256) {
1053         // Counter underflow is impossible as _burnCounter cannot be incremented
1054         // more than `_currentIndex - _startTokenId()` times.
1055         unchecked {
1056             return _currentIndex - _burnCounter - _startTokenId();
1057         }
1058     }
1059 
1060     /**
1061      * @dev Returns the total amount of tokens minted in the contract.
1062      */
1063     function _totalMinted() internal view virtual returns (uint256) {
1064         // Counter underflow is impossible as `_currentIndex` does not decrement,
1065         // and it is initialized to `_startTokenId()`.
1066         unchecked {
1067             return _currentIndex - _startTokenId();
1068         }
1069     }
1070 
1071     /**
1072      * @dev Returns the total number of tokens burned.
1073      */
1074     function _totalBurned() internal view virtual returns (uint256) {
1075         return _burnCounter;
1076     }
1077 
1078     // =============================================================
1079     //                    ADDRESS DATA OPERATIONS
1080     // =============================================================
1081 
1082     /**
1083      * @dev Returns the number of tokens in `owner`'s account.
1084      */
1085     function balanceOf(address owner) public view virtual override returns (uint256) {
1086         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1087         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1088     }
1089 
1090     /**
1091      * Returns the number of tokens minted by `owner`.
1092      */
1093     function _numberMinted(address owner) internal view returns (uint256) {
1094         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1095     }
1096 
1097     /**
1098      * Returns the number of tokens burned by or on behalf of `owner`.
1099      */
1100     function _numberBurned(address owner) internal view returns (uint256) {
1101         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1102     }
1103 
1104     /**
1105      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1106      */
1107     function _getAux(address owner) internal view returns (uint64) {
1108         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1109     }
1110 
1111     /**
1112      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1113      * If there are multiple variables, please pack them into a uint64.
1114      */
1115     function _setAux(address owner, uint64 aux) internal virtual {
1116         uint256 packed = _packedAddressData[owner];
1117         uint256 auxCasted;
1118         // Cast `aux` with assembly to avoid redundant masking.
1119         assembly {
1120             auxCasted := aux
1121         }
1122         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1123         _packedAddressData[owner] = packed;
1124     }
1125 
1126     // =============================================================
1127     //                            IERC165
1128     // =============================================================
1129 
1130     /**
1131      * @dev Returns true if this contract implements the interface defined by
1132      * `interfaceId`. See the corresponding
1133      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1134      * to learn more about how these ids are created.
1135      *
1136      * This function call must use less than 30000 gas.
1137      */
1138     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1139         // The interface IDs are constants representing the first 4 bytes
1140         // of the XOR of all function selectors in the interface.
1141         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1142         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1143         return
1144             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1145             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1146             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1147     }
1148 
1149     // =============================================================
1150     //                        IERC721Metadata
1151     // =============================================================
1152 
1153     /**
1154      * @dev Returns the token collection name.
1155      */
1156     function name() public view virtual override returns (string memory) {
1157         return _name;
1158     }
1159 
1160     /**
1161      * @dev Returns the token collection symbol.
1162      */
1163     function symbol() public view virtual override returns (string memory) {
1164         return _symbol;
1165     }
1166 
1167     /**
1168      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1169      */
1170     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1171         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1172 
1173         string memory baseURI = _baseURI();
1174         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1175     }
1176 
1177     /**
1178      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1179      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1180      * by default, it can be overridden in child contracts.
1181      */
1182     function _baseURI() internal view virtual returns (string memory) {
1183         return '';
1184     }
1185 
1186     // =============================================================
1187     //                     OWNERSHIPS OPERATIONS
1188     // =============================================================
1189 
1190     /**
1191      * @dev Returns the owner of the `tokenId` token.
1192      *
1193      * Requirements:
1194      *
1195      * - `tokenId` must exist.
1196      */
1197     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1198         return address(uint160(_packedOwnershipOf(tokenId)));
1199     }
1200 
1201     /**
1202      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1203      * It gradually moves to O(1) as tokens get transferred around over time.
1204      */
1205     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1206         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1207     }
1208 
1209     /**
1210      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1211      */
1212     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1213         return _unpackedOwnership(_packedOwnerships[index]);
1214     }
1215 
1216     /**
1217      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1218      */
1219     function _initializeOwnershipAt(uint256 index) internal virtual {
1220         if (_packedOwnerships[index] == 0) {
1221             _packedOwnerships[index] = _packedOwnershipOf(index);
1222         }
1223     }
1224 
1225     /**
1226      * Returns the packed ownership data of `tokenId`.
1227      */
1228     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1229         uint256 curr = tokenId;
1230 
1231         unchecked {
1232             if (_startTokenId() <= curr)
1233                 if (curr < _currentIndex) {
1234                     uint256 packed = _packedOwnerships[curr];
1235                     // If not burned.
1236                     if (packed & _BITMASK_BURNED == 0) {
1237                         // Invariant:
1238                         // There will always be an initialized ownership slot
1239                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1240                         // before an unintialized ownership slot
1241                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1242                         // Hence, `curr` will not underflow.
1243                         //
1244                         // We can directly compare the packed value.
1245                         // If the address is zero, packed will be zero.
1246                         while (packed == 0) {
1247                             packed = _packedOwnerships[--curr];
1248                         }
1249                         return packed;
1250                     }
1251                 }
1252         }
1253         revert OwnerQueryForNonexistentToken();
1254     }
1255 
1256     /**
1257      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1258      */
1259     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1260         ownership.addr = address(uint160(packed));
1261         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1262         ownership.burned = packed & _BITMASK_BURNED != 0;
1263         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1264     }
1265 
1266     /**
1267      * @dev Packs ownership data into a single uint256.
1268      */
1269     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1270         assembly {
1271             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1272             owner := and(owner, _BITMASK_ADDRESS)
1273             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1274             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1275         }
1276     }
1277 
1278     /**
1279      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1280      */
1281     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1282         // For branchless setting of the `nextInitialized` flag.
1283         assembly {
1284             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1285             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1286         }
1287     }
1288 
1289     // =============================================================
1290     //                      APPROVAL OPERATIONS
1291     // =============================================================
1292 
1293     /**
1294      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1295      * The approval is cleared when the token is transferred.
1296      *
1297      * Only a single account can be approved at a time, so approving the
1298      * zero address clears previous approvals.
1299      *
1300      * Requirements:
1301      *
1302      * - The caller must own the token or be an approved operator.
1303      * - `tokenId` must exist.
1304      *
1305      * Emits an {Approval} event.
1306      */
1307     function approve(address to, uint256 tokenId) public payable virtual override {
1308         address owner = ownerOf(tokenId);
1309 
1310         if (_msgSenderERC721A() != owner)
1311             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1312                 revert ApprovalCallerNotOwnerNorApproved();
1313             }
1314 
1315         _tokenApprovals[tokenId].value = to;
1316         emit Approval(owner, to, tokenId);
1317     }
1318 
1319     /**
1320      * @dev Returns the account approved for `tokenId` token.
1321      *
1322      * Requirements:
1323      *
1324      * - `tokenId` must exist.
1325      */
1326     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1327         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1328 
1329         return _tokenApprovals[tokenId].value;
1330     }
1331 
1332     /**
1333      * @dev Approve or remove `operator` as an operator for the caller.
1334      * Operators can call {transferFrom} or {safeTransferFrom}
1335      * for any token owned by the caller.
1336      *
1337      * Requirements:
1338      *
1339      * - The `operator` cannot be the caller.
1340      *
1341      * Emits an {ApprovalForAll} event.
1342      */
1343     function setApprovalForAll(address operator, bool approved) public virtual override {
1344         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1345         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1346     }
1347 
1348     /**
1349      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1350      *
1351      * See {setApprovalForAll}.
1352      */
1353     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1354         return _operatorApprovals[owner][operator];
1355     }
1356 
1357     /**
1358      * @dev Returns whether `tokenId` exists.
1359      *
1360      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1361      *
1362      * Tokens start existing when they are minted. See {_mint}.
1363      */
1364     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1365         return
1366             _startTokenId() <= tokenId &&
1367             tokenId < _currentIndex && // If within bounds,
1368             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1369     }
1370 
1371     /**
1372      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1373      */
1374     function _isSenderApprovedOrOwner(
1375         address approvedAddress,
1376         address owner,
1377         address msgSender
1378     ) private pure returns (bool result) {
1379         assembly {
1380             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1381             owner := and(owner, _BITMASK_ADDRESS)
1382             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1383             msgSender := and(msgSender, _BITMASK_ADDRESS)
1384             // `msgSender == owner || msgSender == approvedAddress`.
1385             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1386         }
1387     }
1388 
1389     /**
1390      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1391      */
1392     function _getApprovedSlotAndAddress(uint256 tokenId)
1393         private
1394         view
1395         returns (uint256 approvedAddressSlot, address approvedAddress)
1396     {
1397         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1398         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1399         assembly {
1400             approvedAddressSlot := tokenApproval.slot
1401             approvedAddress := sload(approvedAddressSlot)
1402         }
1403     }
1404 
1405     // =============================================================
1406     //                      TRANSFER OPERATIONS
1407     // =============================================================
1408 
1409     /**
1410      * @dev Transfers `tokenId` from `from` to `to`.
1411      *
1412      * Requirements:
1413      *
1414      * - `from` cannot be the zero address.
1415      * - `to` cannot be the zero address.
1416      * - `tokenId` token must be owned by `from`.
1417      * - If the caller is not `from`, it must be approved to move this token
1418      * by either {approve} or {setApprovalForAll}.
1419      *
1420      * Emits a {Transfer} event.
1421      */
1422     function transferFrom(
1423         address from,
1424         address to,
1425         uint256 tokenId
1426     ) public payable virtual override {
1427         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1428 
1429         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1430 
1431         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1432 
1433         // The nested ifs save around 20+ gas over a compound boolean condition.
1434         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1435             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1436 
1437         if (to == address(0)) revert TransferToZeroAddress();
1438 
1439         _beforeTokenTransfers(from, to, tokenId, 1);
1440 
1441         // Clear approvals from the previous owner.
1442         assembly {
1443             if approvedAddress {
1444                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1445                 sstore(approvedAddressSlot, 0)
1446             }
1447         }
1448 
1449         // Underflow of the sender's balance is impossible because we check for
1450         // ownership above and the recipient's balance can't realistically overflow.
1451         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1452         unchecked {
1453             // We can directly increment and decrement the balances.
1454             --_packedAddressData[from]; // Updates: `balance -= 1`.
1455             ++_packedAddressData[to]; // Updates: `balance += 1`.
1456 
1457             // Updates:
1458             // - `address` to the next owner.
1459             // - `startTimestamp` to the timestamp of transfering.
1460             // - `burned` to `false`.
1461             // - `nextInitialized` to `true`.
1462             _packedOwnerships[tokenId] = _packOwnershipData(
1463                 to,
1464                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1465             );
1466 
1467             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1468             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1469                 uint256 nextTokenId = tokenId + 1;
1470                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1471                 if (_packedOwnerships[nextTokenId] == 0) {
1472                     // If the next slot is within bounds.
1473                     if (nextTokenId != _currentIndex) {
1474                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1475                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1476                     }
1477                 }
1478             }
1479         }
1480 
1481         emit Transfer(from, to, tokenId);
1482         _afterTokenTransfers(from, to, tokenId, 1);
1483     }
1484 
1485     /**
1486      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1487      */
1488     function safeTransferFrom(
1489         address from,
1490         address to,
1491         uint256 tokenId
1492     ) public payable virtual override {
1493         safeTransferFrom(from, to, tokenId, '');
1494     }
1495 
1496     /**
1497      * @dev Safely transfers `tokenId` token from `from` to `to`.
1498      *
1499      * Requirements:
1500      *
1501      * - `from` cannot be the zero address.
1502      * - `to` cannot be the zero address.
1503      * - `tokenId` token must exist and be owned by `from`.
1504      * - If the caller is not `from`, it must be approved to move this token
1505      * by either {approve} or {setApprovalForAll}.
1506      * - If `to` refers to a smart contract, it must implement
1507      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function safeTransferFrom(
1512         address from,
1513         address to,
1514         uint256 tokenId,
1515         bytes memory _data
1516     ) public payable virtual override {
1517         transferFrom(from, to, tokenId);
1518         if (to.code.length != 0)
1519             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1520                 revert TransferToNonERC721ReceiverImplementer();
1521             }
1522     }
1523 
1524     /**
1525      * @dev Hook that is called before a set of serially-ordered token IDs
1526      * are about to be transferred. This includes minting.
1527      * And also called before burning one token.
1528      *
1529      * `startTokenId` - the first token ID to be transferred.
1530      * `quantity` - the amount to be transferred.
1531      *
1532      * Calling conditions:
1533      *
1534      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1535      * transferred to `to`.
1536      * - When `from` is zero, `tokenId` will be minted for `to`.
1537      * - When `to` is zero, `tokenId` will be burned by `from`.
1538      * - `from` and `to` are never both zero.
1539      */
1540     function _beforeTokenTransfers(
1541         address from,
1542         address to,
1543         uint256 startTokenId,
1544         uint256 quantity
1545     ) internal virtual {}
1546 
1547     /**
1548      * @dev Hook that is called after a set of serially-ordered token IDs
1549      * have been transferred. This includes minting.
1550      * And also called after one token has been burned.
1551      *
1552      * `startTokenId` - the first token ID to be transferred.
1553      * `quantity` - the amount to be transferred.
1554      *
1555      * Calling conditions:
1556      *
1557      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1558      * transferred to `to`.
1559      * - When `from` is zero, `tokenId` has been minted for `to`.
1560      * - When `to` is zero, `tokenId` has been burned by `from`.
1561      * - `from` and `to` are never both zero.
1562      */
1563     function _afterTokenTransfers(
1564         address from,
1565         address to,
1566         uint256 startTokenId,
1567         uint256 quantity
1568     ) internal virtual {}
1569 
1570     /**
1571      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1572      *
1573      * `from` - Previous owner of the given token ID.
1574      * `to` - Target address that will receive the token.
1575      * `tokenId` - Token ID to be transferred.
1576      * `_data` - Optional data to send along with the call.
1577      *
1578      * Returns whether the call correctly returned the expected magic value.
1579      */
1580     function _checkContractOnERC721Received(
1581         address from,
1582         address to,
1583         uint256 tokenId,
1584         bytes memory _data
1585     ) private returns (bool) {
1586         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1587             bytes4 retval
1588         ) {
1589             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1590         } catch (bytes memory reason) {
1591             if (reason.length == 0) {
1592                 revert TransferToNonERC721ReceiverImplementer();
1593             } else {
1594                 assembly {
1595                     revert(add(32, reason), mload(reason))
1596                 }
1597             }
1598         }
1599     }
1600 
1601     // =============================================================
1602     //                        MINT OPERATIONS
1603     // =============================================================
1604 
1605     /**
1606      * @dev Mints `quantity` tokens and transfers them to `to`.
1607      *
1608      * Requirements:
1609      *
1610      * - `to` cannot be the zero address.
1611      * - `quantity` must be greater than 0.
1612      *
1613      * Emits a {Transfer} event for each mint.
1614      */
1615     function _mint(address to, uint256 quantity) internal virtual {
1616         uint256 startTokenId = _currentIndex;
1617         if (quantity == 0) revert MintZeroQuantity();
1618 
1619         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1620 
1621         // Overflows are incredibly unrealistic.
1622         // `balance` and `numberMinted` have a maximum limit of 2**64.
1623         // `tokenId` has a maximum limit of 2**256.
1624         unchecked {
1625             // Updates:
1626             // - `balance += quantity`.
1627             // - `numberMinted += quantity`.
1628             //
1629             // We can directly add to the `balance` and `numberMinted`.
1630             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1631 
1632             // Updates:
1633             // - `address` to the owner.
1634             // - `startTimestamp` to the timestamp of minting.
1635             // - `burned` to `false`.
1636             // - `nextInitialized` to `quantity == 1`.
1637             _packedOwnerships[startTokenId] = _packOwnershipData(
1638                 to,
1639                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1640             );
1641 
1642             uint256 toMasked;
1643             uint256 end = startTokenId + quantity;
1644 
1645             // Use assembly to loop and emit the `Transfer` event for gas savings.
1646             // The duplicated `log4` removes an extra check and reduces stack juggling.
1647             // The assembly, together with the surrounding Solidity code, have been
1648             // delicately arranged to nudge the compiler into producing optimized opcodes.
1649             assembly {
1650                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1651                 toMasked := and(to, _BITMASK_ADDRESS)
1652                 // Emit the `Transfer` event.
1653                 log4(
1654                     0, // Start of data (0, since no data).
1655                     0, // End of data (0, since no data).
1656                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1657                     0, // `address(0)`.
1658                     toMasked, // `to`.
1659                     startTokenId // `tokenId`.
1660                 )
1661 
1662                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1663                 // that overflows uint256 will make the loop run out of gas.
1664                 // The compiler will optimize the `iszero` away for performance.
1665                 for {
1666                     let tokenId := add(startTokenId, 1)
1667                 } iszero(eq(tokenId, end)) {
1668                     tokenId := add(tokenId, 1)
1669                 } {
1670                     // Emit the `Transfer` event. Similar to above.
1671                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1672                 }
1673             }
1674             if (toMasked == 0) revert MintToZeroAddress();
1675 
1676             _currentIndex = end;
1677         }
1678         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1679     }
1680 
1681     /**
1682      * @dev Mints `quantity` tokens and transfers them to `to`.
1683      *
1684      * This function is intended for efficient minting only during contract creation.
1685      *
1686      * It emits only one {ConsecutiveTransfer} as defined in
1687      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1688      * instead of a sequence of {Transfer} event(s).
1689      *
1690      * Calling this function outside of contract creation WILL make your contract
1691      * non-compliant with the ERC721 standard.
1692      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1693      * {ConsecutiveTransfer} event is only permissible during contract creation.
1694      *
1695      * Requirements:
1696      *
1697      * - `to` cannot be the zero address.
1698      * - `quantity` must be greater than 0.
1699      *
1700      * Emits a {ConsecutiveTransfer} event.
1701      */
1702     function _mintERC2309(address to, uint256 quantity) internal virtual {
1703         uint256 startTokenId = _currentIndex;
1704         if (to == address(0)) revert MintToZeroAddress();
1705         if (quantity == 0) revert MintZeroQuantity();
1706         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1707 
1708         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1709 
1710         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1711         unchecked {
1712             // Updates:
1713             // - `balance += quantity`.
1714             // - `numberMinted += quantity`.
1715             //
1716             // We can directly add to the `balance` and `numberMinted`.
1717             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1718 
1719             // Updates:
1720             // - `address` to the owner.
1721             // - `startTimestamp` to the timestamp of minting.
1722             // - `burned` to `false`.
1723             // - `nextInitialized` to `quantity == 1`.
1724             _packedOwnerships[startTokenId] = _packOwnershipData(
1725                 to,
1726                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1727             );
1728 
1729             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1730 
1731             _currentIndex = startTokenId + quantity;
1732         }
1733         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1734     }
1735 
1736     /**
1737      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1738      *
1739      * Requirements:
1740      *
1741      * - If `to` refers to a smart contract, it must implement
1742      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1743      * - `quantity` must be greater than 0.
1744      *
1745      * See {_mint}.
1746      *
1747      * Emits a {Transfer} event for each mint.
1748      */
1749     function _safeMint(
1750         address to,
1751         uint256 quantity,
1752         bytes memory _data
1753     ) internal virtual {
1754         _mint(to, quantity);
1755 
1756         unchecked {
1757             if (to.code.length != 0) {
1758                 uint256 end = _currentIndex;
1759                 uint256 index = end - quantity;
1760                 do {
1761                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1762                         revert TransferToNonERC721ReceiverImplementer();
1763                     }
1764                 } while (index < end);
1765                 // Reentrancy protection.
1766                 if (_currentIndex != end) revert();
1767             }
1768         }
1769     }
1770 
1771     /**
1772      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1773      */
1774     function _safeMint(address to, uint256 quantity) internal virtual {
1775         _safeMint(to, quantity, '');
1776     }
1777 
1778     // =============================================================
1779     //                        BURN OPERATIONS
1780     // =============================================================
1781 
1782     /**
1783      * @dev Equivalent to `_burn(tokenId, false)`.
1784      */
1785     function _burn(uint256 tokenId) internal virtual {
1786         _burn(tokenId, false);
1787     }
1788 
1789     /**
1790      * @dev Destroys `tokenId`.
1791      * The approval is cleared when the token is burned.
1792      *
1793      * Requirements:
1794      *
1795      * - `tokenId` must exist.
1796      *
1797      * Emits a {Transfer} event.
1798      */
1799     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1800         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1801 
1802         address from = address(uint160(prevOwnershipPacked));
1803 
1804         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1805 
1806         if (approvalCheck) {
1807             // The nested ifs save around 20+ gas over a compound boolean condition.
1808             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1809                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1810         }
1811 
1812         _beforeTokenTransfers(from, address(0), tokenId, 1);
1813 
1814         // Clear approvals from the previous owner.
1815         assembly {
1816             if approvedAddress {
1817                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1818                 sstore(approvedAddressSlot, 0)
1819             }
1820         }
1821 
1822         // Underflow of the sender's balance is impossible because we check for
1823         // ownership above and the recipient's balance can't realistically overflow.
1824         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1825         unchecked {
1826             // Updates:
1827             // - `balance -= 1`.
1828             // - `numberBurned += 1`.
1829             //
1830             // We can directly decrement the balance, and increment the number burned.
1831             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1832             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1833 
1834             // Updates:
1835             // - `address` to the last owner.
1836             // - `startTimestamp` to the timestamp of burning.
1837             // - `burned` to `true`.
1838             // - `nextInitialized` to `true`.
1839             _packedOwnerships[tokenId] = _packOwnershipData(
1840                 from,
1841                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1842             );
1843 
1844             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1845             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1846                 uint256 nextTokenId = tokenId + 1;
1847                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1848                 if (_packedOwnerships[nextTokenId] == 0) {
1849                     // If the next slot is within bounds.
1850                     if (nextTokenId != _currentIndex) {
1851                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1852                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1853                     }
1854                 }
1855             }
1856         }
1857 
1858         emit Transfer(from, address(0), tokenId);
1859         _afterTokenTransfers(from, address(0), tokenId, 1);
1860 
1861         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1862         unchecked {
1863             _burnCounter++;
1864         }
1865     }
1866 
1867     // =============================================================
1868     //                     EXTRA DATA OPERATIONS
1869     // =============================================================
1870 
1871     /**
1872      * @dev Directly sets the extra data for the ownership data `index`.
1873      */
1874     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1875         uint256 packed = _packedOwnerships[index];
1876         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1877         uint256 extraDataCasted;
1878         // Cast `extraData` with assembly to avoid redundant masking.
1879         assembly {
1880             extraDataCasted := extraData
1881         }
1882         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1883         _packedOwnerships[index] = packed;
1884     }
1885 
1886     /**
1887      * @dev Called during each token transfer to set the 24bit `extraData` field.
1888      * Intended to be overridden by the cosumer contract.
1889      *
1890      * `previousExtraData` - the value of `extraData` before transfer.
1891      *
1892      * Calling conditions:
1893      *
1894      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1895      * transferred to `to`.
1896      * - When `from` is zero, `tokenId` will be minted for `to`.
1897      * - When `to` is zero, `tokenId` will be burned by `from`.
1898      * - `from` and `to` are never both zero.
1899      */
1900     function _extraData(
1901         address from,
1902         address to,
1903         uint24 previousExtraData
1904     ) internal view virtual returns (uint24) {}
1905 
1906     /**
1907      * @dev Returns the next extra data for the packed ownership data.
1908      * The returned result is shifted into position.
1909      */
1910     function _nextExtraData(
1911         address from,
1912         address to,
1913         uint256 prevOwnershipPacked
1914     ) private view returns (uint256) {
1915         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1916         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1917     }
1918 
1919     // =============================================================
1920     //                       OTHER OPERATIONS
1921     // =============================================================
1922 
1923     /**
1924      * @dev Returns the message sender (defaults to `msg.sender`).
1925      *
1926      * If you are writing GSN compatible contracts, you need to override this function.
1927      */
1928     function _msgSenderERC721A() internal view virtual returns (address) {
1929         return msg.sender;
1930     }
1931 
1932     /**
1933      * @dev Converts a uint256 to its ASCII string decimal representation.
1934      */
1935     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1936         assembly {
1937             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1938             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1939             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1940             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1941             let m := add(mload(0x40), 0xa0)
1942             // Update the free memory pointer to allocate.
1943             mstore(0x40, m)
1944             // Assign the `str` to the end.
1945             str := sub(m, 0x20)
1946             // Zeroize the slot after the string.
1947             mstore(str, 0)
1948 
1949             // Cache the end of the memory to calculate the length later.
1950             let end := str
1951 
1952             // We write the string from rightmost digit to leftmost digit.
1953             // The following is essentially a do-while loop that also handles the zero case.
1954             // prettier-ignore
1955             for { let temp := value } 1 {} {
1956                 str := sub(str, 1)
1957                 // Write the character to the pointer.
1958                 // The ASCII index of the '0' character is 48.
1959                 mstore8(str, add(48, mod(temp, 10)))
1960                 // Keep dividing `temp` until zero.
1961                 temp := div(temp, 10)
1962                 // prettier-ignore
1963                 if iszero(temp) { break }
1964             }
1965 
1966             let length := sub(end, str)
1967             // Move the pointer 32 bytes leftwards to make room for the length.
1968             str := sub(str, 0x20)
1969             // Store the length.
1970             mstore(str, length)
1971         }
1972     }
1973 }
1974 
1975 // File: contracts\contract.sol
1976 
1977 //SPDX-License-Identifier: MIT
1978 
1979 pragma solidity ^0.8.19;
1980 contract SummonPals  is ERC721A, Ownable, ReentrancyGuard {
1981 	using Strings for uint256;
1982 
1983 	uint256 public maxSupply = 4444;
1984     uint256 public cost = 0.0025 ether;
1985     uint256 public freeAmount = 2;
1986     uint256 public maxPerWallet = 20;
1987 
1988     bool public isRevealed = false;
1989 	bool public pause = false;
1990 
1991     string private baseURL = "";
1992     string public hiddenMetadataUrl = "";
1993 
1994     mapping(address => uint256) public userBalance;
1995 
1996 	constructor(
1997         string memory _baseMetadataUrl
1998 	)
1999 	ERC721A("SummonPals", "SPS") {
2000         setBaseUri(_baseMetadataUrl);
2001     }
2002 
2003 	function _baseURI() internal view override returns (string memory) {
2004 		return baseURL;
2005 	}
2006 
2007     function setBaseUri(string memory _baseURL) public onlyOwner {
2008 	    baseURL = _baseURL;
2009 	}
2010 
2011     function mint(uint256 mintAmount) external payable {
2012 		require(!pause, "The sale is paused");
2013         if(userBalance[msg.sender] >= freeAmount) require(msg.value >= cost * mintAmount, "Insufficient funds");
2014         else require(msg.value >= cost * (mintAmount - (freeAmount - userBalance[msg.sender])), "Insufficient funds");
2015         require(_totalMinted() + mintAmount <= maxSupply,"Exceeds max supply");
2016         require(userBalance[msg.sender] + mintAmount <= maxPerWallet, "Exceeds max per wallet");
2017         _safeMint(msg.sender, mintAmount);
2018         userBalance[msg.sender] = userBalance[msg.sender] + mintAmount;
2019 	}
2020 
2021     function airdrop(address to, uint256 mintAmount) external onlyOwner {
2022 		require(
2023 			_totalMinted() + mintAmount <= maxSupply,
2024 			"Exceeds max supply"
2025 		);
2026 		_safeMint(to, mintAmount);
2027         
2028 	}
2029 
2030     function sethiddenMetadataUrl(string memory _hiddenMetadataUrl) public onlyOwner {
2031 	    hiddenMetadataUrl = _hiddenMetadataUrl;
2032 	}
2033 
2034     function reveal(bool _state) external onlyOwner {
2035 	    isRevealed = _state;
2036 	}
2037 
2038 	function _startTokenId() internal view virtual override returns (uint256) {
2039     	return 1;
2040   	}
2041 
2042 	function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
2043 		maxSupply = newMaxSupply;
2044 	}
2045 
2046 	function tokenURI(uint256 tokenId)
2047 		public
2048 		view
2049 		override
2050 		returns (string memory)
2051 	{
2052         require(_exists(tokenId), "That token doesn't exist");
2053         if(isRevealed == false) {
2054             return hiddenMetadataUrl;
2055         }
2056         else return bytes(_baseURI()).length > 0 
2057             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
2058             : "";
2059 	}
2060 
2061 	function setCost(uint256 _newCost) public onlyOwner{
2062 		cost = _newCost;
2063 	}
2064 
2065 	function setPause(bool _state) public onlyOwner{
2066 		pause = _state;
2067 	}
2068 
2069     function setFreeAmount(uint256 _newAmt) public onlyOwner{
2070         require(_newAmt < maxPerWallet, "Not possible");
2071         freeAmount = _newAmt;
2072     }
2073 
2074     function setMaxPerWallet(uint256 _newAmt) public  onlyOwner{
2075         require(_newAmt > freeAmount, "Not possible");
2076         maxPerWallet = _newAmt;
2077     }
2078 
2079 	function withdraw() external onlyOwner {
2080 		(bool success, ) = payable(owner()).call{
2081             value: address(this).balance
2082         }("");
2083         require(success);
2084 	}
2085 }