1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/math/Math.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Standard math utilities missing in the Solidity language.
12  */
13 library Math {
14     enum Rounding {
15         Down, // Toward negative infinity
16         Up, // Toward infinity
17         Zero // Toward zero
18     }
19 
20     /**
21      * @dev Returns the largest of two numbers.
22      */
23     function max(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a > b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the smallest of two numbers.
29      */
30     function min(uint256 a, uint256 b) internal pure returns (uint256) {
31         return a < b ? a : b;
32     }
33 
34     /**
35      * @dev Returns the average of two numbers. The result is rounded towards
36      * zero.
37      */
38     function average(uint256 a, uint256 b) internal pure returns (uint256) {
39         // (a + b) / 2 can overflow.
40         return (a & b) + (a ^ b) / 2;
41     }
42 
43     /**
44      * @dev Returns the ceiling of the division of two numbers.
45      *
46      * This differs from standard division with `/` in that it rounds up instead
47      * of rounding down.
48      */
49     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
50         // (a + b - 1) / b can overflow on addition, so we distribute.
51         return a == 0 ? 0 : (a - 1) / b + 1;
52     }
53 
54     /**
55      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
56      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
57      * with further edits by Uniswap Labs also under MIT license.
58      */
59     function mulDiv(
60         uint256 x,
61         uint256 y,
62         uint256 denominator
63     ) internal pure returns (uint256 result) {
64         unchecked {
65             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
66             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
67             // variables such that product = prod1 * 2^256 + prod0.
68             uint256 prod0; // Least significant 256 bits of the product
69             uint256 prod1; // Most significant 256 bits of the product
70             assembly {
71                 let mm := mulmod(x, y, not(0))
72                 prod0 := mul(x, y)
73                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
74             }
75 
76             // Handle non-overflow cases, 256 by 256 division.
77             if (prod1 == 0) {
78                 return prod0 / denominator;
79             }
80 
81             // Make sure the result is less than 2^256. Also prevents denominator == 0.
82             require(denominator > prod1);
83 
84             ///////////////////////////////////////////////
85             // 512 by 256 division.
86             ///////////////////////////////////////////////
87 
88             // Make division exact by subtracting the remainder from [prod1 prod0].
89             uint256 remainder;
90             assembly {
91                 // Compute remainder using mulmod.
92                 remainder := mulmod(x, y, denominator)
93 
94                 // Subtract 256 bit number from 512 bit number.
95                 prod1 := sub(prod1, gt(remainder, prod0))
96                 prod0 := sub(prod0, remainder)
97             }
98 
99             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
100             // See https://cs.stackexchange.com/q/138556/92363.
101 
102             // Does not overflow because the denominator cannot be zero at this stage in the function.
103             uint256 twos = denominator & (~denominator + 1);
104             assembly {
105                 // Divide denominator by twos.
106                 denominator := div(denominator, twos)
107 
108                 // Divide [prod1 prod0] by twos.
109                 prod0 := div(prod0, twos)
110 
111                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
112                 twos := add(div(sub(0, twos), twos), 1)
113             }
114 
115             // Shift in bits from prod1 into prod0.
116             prod0 |= prod1 * twos;
117 
118             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
119             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
120             // four bits. That is, denominator * inv = 1 mod 2^4.
121             uint256 inverse = (3 * denominator) ^ 2;
122 
123             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
124             // in modular arithmetic, doubling the correct bits in each step.
125             inverse *= 2 - denominator * inverse; // inverse mod 2^8
126             inverse *= 2 - denominator * inverse; // inverse mod 2^16
127             inverse *= 2 - denominator * inverse; // inverse mod 2^32
128             inverse *= 2 - denominator * inverse; // inverse mod 2^64
129             inverse *= 2 - denominator * inverse; // inverse mod 2^128
130             inverse *= 2 - denominator * inverse; // inverse mod 2^256
131 
132             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
133             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
134             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
135             // is no longer required.
136             result = prod0 * inverse;
137             return result;
138         }
139     }
140 
141     /**
142      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
143      */
144     function mulDiv(
145         uint256 x,
146         uint256 y,
147         uint256 denominator,
148         Rounding rounding
149     ) internal pure returns (uint256) {
150         uint256 result = mulDiv(x, y, denominator);
151         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
152             result += 1;
153         }
154         return result;
155     }
156 
157     /**
158      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
159      *
160      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
161      */
162     function sqrt(uint256 a) internal pure returns (uint256) {
163         if (a == 0) {
164             return 0;
165         }
166 
167         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
168         //
169         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
170         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
171         //
172         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
173         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
174         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
175         //
176         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
177         uint256 result = 1 << (log2(a) >> 1);
178 
179         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
180         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
181         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
182         // into the expected uint128 result.
183         unchecked {
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             result = (result + a / result) >> 1;
190             result = (result + a / result) >> 1;
191             return min(result, a / result);
192         }
193     }
194 
195     /**
196      * @notice Calculates sqrt(a), following the selected rounding direction.
197      */
198     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
199         unchecked {
200             uint256 result = sqrt(a);
201             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
202         }
203     }
204 
205     /**
206      * @dev Return the log in base 2, rounded down, of a positive value.
207      * Returns 0 if given 0.
208      */
209     function log2(uint256 value) internal pure returns (uint256) {
210         uint256 result = 0;
211         unchecked {
212             if (value >> 128 > 0) {
213                 value >>= 128;
214                 result += 128;
215             }
216             if (value >> 64 > 0) {
217                 value >>= 64;
218                 result += 64;
219             }
220             if (value >> 32 > 0) {
221                 value >>= 32;
222                 result += 32;
223             }
224             if (value >> 16 > 0) {
225                 value >>= 16;
226                 result += 16;
227             }
228             if (value >> 8 > 0) {
229                 value >>= 8;
230                 result += 8;
231             }
232             if (value >> 4 > 0) {
233                 value >>= 4;
234                 result += 4;
235             }
236             if (value >> 2 > 0) {
237                 value >>= 2;
238                 result += 2;
239             }
240             if (value >> 1 > 0) {
241                 result += 1;
242             }
243         }
244         return result;
245     }
246 
247     /**
248      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
249      * Returns 0 if given 0.
250      */
251     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
252         unchecked {
253             uint256 result = log2(value);
254             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
255         }
256     }
257 
258     /**
259      * @dev Return the log in base 10, rounded down, of a positive value.
260      * Returns 0 if given 0.
261      */
262     function log10(uint256 value) internal pure returns (uint256) {
263         uint256 result = 0;
264         unchecked {
265             if (value >= 10**64) {
266                 value /= 10**64;
267                 result += 64;
268             }
269             if (value >= 10**32) {
270                 value /= 10**32;
271                 result += 32;
272             }
273             if (value >= 10**16) {
274                 value /= 10**16;
275                 result += 16;
276             }
277             if (value >= 10**8) {
278                 value /= 10**8;
279                 result += 8;
280             }
281             if (value >= 10**4) {
282                 value /= 10**4;
283                 result += 4;
284             }
285             if (value >= 10**2) {
286                 value /= 10**2;
287                 result += 2;
288             }
289             if (value >= 10**1) {
290                 result += 1;
291             }
292         }
293         return result;
294     }
295 
296     /**
297      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
298      * Returns 0 if given 0.
299      */
300     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
301         unchecked {
302             uint256 result = log10(value);
303             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
304         }
305     }
306 
307     /**
308      * @dev Return the log in base 256, rounded down, of a positive value.
309      * Returns 0 if given 0.
310      *
311      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
312      */
313     function log256(uint256 value) internal pure returns (uint256) {
314         uint256 result = 0;
315         unchecked {
316             if (value >> 128 > 0) {
317                 value >>= 128;
318                 result += 16;
319             }
320             if (value >> 64 > 0) {
321                 value >>= 64;
322                 result += 8;
323             }
324             if (value >> 32 > 0) {
325                 value >>= 32;
326                 result += 4;
327             }
328             if (value >> 16 > 0) {
329                 value >>= 16;
330                 result += 2;
331             }
332             if (value >> 8 > 0) {
333                 result += 1;
334             }
335         }
336         return result;
337     }
338 
339     /**
340      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
341      * Returns 0 if given 0.
342      */
343     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
344         unchecked {
345             uint256 result = log256(value);
346             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
347         }
348     }
349 }
350 
351 // File: @openzeppelin/contracts/utils/Strings.sol
352 
353 
354 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 
359 /**
360  * @dev String operations.
361  */
362 library Strings {
363     bytes16 private constant _SYMBOLS = "0123456789abcdef";
364     uint8 private constant _ADDRESS_LENGTH = 20;
365 
366     /**
367      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
368      */
369     function toString(uint256 value) internal pure returns (string memory) {
370         unchecked {
371             uint256 length = Math.log10(value) + 1;
372             string memory buffer = new string(length);
373             uint256 ptr;
374             /// @solidity memory-safe-assembly
375             assembly {
376                 ptr := add(buffer, add(32, length))
377             }
378             while (true) {
379                 ptr--;
380                 /// @solidity memory-safe-assembly
381                 assembly {
382                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
383                 }
384                 value /= 10;
385                 if (value == 0) break;
386             }
387             return buffer;
388         }
389     }
390 
391     /**
392      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
393      */
394     function toHexString(uint256 value) internal pure returns (string memory) {
395         unchecked {
396             return toHexString(value, Math.log256(value) + 1);
397         }
398     }
399 
400     /**
401      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
402      */
403     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
404         bytes memory buffer = new bytes(2 * length + 2);
405         buffer[0] = "0";
406         buffer[1] = "x";
407         for (uint256 i = 2 * length + 1; i > 1; --i) {
408             buffer[i] = _SYMBOLS[value & 0xf];
409             value >>= 4;
410         }
411         require(value == 0, "Strings: hex length insufficient");
412         return string(buffer);
413     }
414 
415     /**
416      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
417      */
418     function toHexString(address addr) internal pure returns (string memory) {
419         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
420     }
421 }
422 
423 // File: @openzeppelin/contracts/utils/Context.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Provides information about the current execution context, including the
432  * sender of the transaction and its data. While these are generally available
433  * via msg.sender and msg.data, they should not be accessed in such a direct
434  * manner, since when dealing with meta-transactions the account sending and
435  * paying for execution may not be the actual sender (as far as an application
436  * is concerned).
437  *
438  * This contract is only required for intermediate, library-like contracts.
439  */
440 abstract contract Context {
441     function _msgSender() internal view virtual returns (address) {
442         return msg.sender;
443     }
444 
445     function _msgData() internal view virtual returns (bytes calldata) {
446         return msg.data;
447     }
448 }
449 
450 // File: @openzeppelin/contracts/access/Ownable.sol
451 
452 
453 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 
458 /**
459  * @dev Contract module which provides a basic access control mechanism, where
460  * there is an account (an owner) that can be granted exclusive access to
461  * specific functions.
462  *
463  * By default, the owner account will be the one that deploys the contract. This
464  * can later be changed with {transferOwnership}.
465  *
466  * This module is used through inheritance. It will make available the modifier
467  * `onlyOwner`, which can be applied to your functions to restrict their use to
468  * the owner.
469  */
470 abstract contract Ownable is Context {
471     address private _owner;
472 
473     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
474 
475     /**
476      * @dev Initializes the contract setting the deployer as the initial owner.
477      */
478     constructor() {
479         _transferOwnership(_msgSender());
480     }
481 
482     /**
483      * @dev Throws if called by any account other than the owner.
484      */
485     modifier onlyOwner() {
486         _checkOwner();
487         _;
488     }
489 
490     /**
491      * @dev Returns the address of the current owner.
492      */
493     function owner() public view virtual returns (address) {
494         return _owner;
495     }
496 
497     /**
498      * @dev Throws if the sender is not the owner.
499      */
500     function _checkOwner() internal view virtual {
501         require(owner() == _msgSender(), "Ownable: caller is not the owner");
502     }
503 
504     /**
505      * @dev Leaves the contract without owner. It will not be possible to call
506      * `onlyOwner` functions anymore. Can only be called by the current owner.
507      *
508      * NOTE: Renouncing ownership will leave the contract without an owner,
509      * thereby removing any functionality that is only available to the owner.
510      */
511     function renounceOwnership() public virtual onlyOwner {
512         _transferOwnership(address(0));
513     }
514 
515     /**
516      * @dev Transfers ownership of the contract to a new account (`newOwner`).
517      * Can only be called by the current owner.
518      */
519     function transferOwnership(address newOwner) public virtual onlyOwner {
520         require(newOwner != address(0), "Ownable: new owner is the zero address");
521         _transferOwnership(newOwner);
522     }
523 
524     /**
525      * @dev Transfers ownership of the contract to a new account (`newOwner`).
526      * Internal function without access restriction.
527      */
528     function _transferOwnership(address newOwner) internal virtual {
529         address oldOwner = _owner;
530         _owner = newOwner;
531         emit OwnershipTransferred(oldOwner, newOwner);
532     }
533 }
534 
535 // File: erc721a/contracts/IERC721A.sol
536 
537 
538 // ERC721A Contracts v4.2.3
539 // Creator: Chiru Labs
540 
541 pragma solidity ^0.8.4;
542 
543 /**
544  * @dev Interface of ERC721A.
545  */
546 interface IERC721A {
547     /**
548      * The caller must own the token or be an approved operator.
549      */
550     error ApprovalCallerNotOwnerNorApproved();
551 
552     /**
553      * The token does not exist.
554      */
555     error ApprovalQueryForNonexistentToken();
556 
557     /**
558      * Cannot query the balance for the zero address.
559      */
560     error BalanceQueryForZeroAddress();
561 
562     /**
563      * Cannot mint to the zero address.
564      */
565     error MintToZeroAddress();
566 
567     /**
568      * The quantity of tokens minted must be more than zero.
569      */
570     error MintZeroQuantity();
571 
572     /**
573      * The token does not exist.
574      */
575     error OwnerQueryForNonexistentToken();
576 
577     /**
578      * The caller must own the token or be an approved operator.
579      */
580     error TransferCallerNotOwnerNorApproved();
581 
582     /**
583      * The token must be owned by `from`.
584      */
585     error TransferFromIncorrectOwner();
586 
587     /**
588      * Cannot safely transfer to a contract that does not implement the
589      * ERC721Receiver interface.
590      */
591     error TransferToNonERC721ReceiverImplementer();
592 
593     /**
594      * Cannot transfer to the zero address.
595      */
596     error TransferToZeroAddress();
597 
598     /**
599      * The token does not exist.
600      */
601     error URIQueryForNonexistentToken();
602 
603     /**
604      * The `quantity` minted with ERC2309 exceeds the safety limit.
605      */
606     error MintERC2309QuantityExceedsLimit();
607 
608     /**
609      * The `extraData` cannot be set on an unintialized ownership slot.
610      */
611     error OwnershipNotInitializedForExtraData();
612 
613     // =============================================================
614     //                            STRUCTS
615     // =============================================================
616 
617     struct TokenOwnership {
618         // The address of the owner.
619         address addr;
620         // Stores the start time of ownership with minimal overhead for tokenomics.
621         uint64 startTimestamp;
622         // Whether the token has been burned.
623         bool burned;
624         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
625         uint24 extraData;
626     }
627 
628     // =============================================================
629     //                         TOKEN COUNTERS
630     // =============================================================
631 
632     /**
633      * @dev Returns the total number of tokens in existence.
634      * Burned tokens will reduce the count.
635      * To get the total number of tokens minted, please see {_totalMinted}.
636      */
637     function totalSupply() external view returns (uint256);
638 
639     // =============================================================
640     //                            IERC165
641     // =============================================================
642 
643     /**
644      * @dev Returns true if this contract implements the interface defined by
645      * `interfaceId`. See the corresponding
646      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
647      * to learn more about how these ids are created.
648      *
649      * This function call must use less than 30000 gas.
650      */
651     function supportsInterface(bytes4 interfaceId) external view returns (bool);
652 
653     // =============================================================
654     //                            IERC721
655     // =============================================================
656 
657     /**
658      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
659      */
660     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
661 
662     /**
663      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
664      */
665     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
666 
667     /**
668      * @dev Emitted when `owner` enables or disables
669      * (`approved`) `operator` to manage all of its assets.
670      */
671     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
672 
673     /**
674      * @dev Returns the number of tokens in `owner`'s account.
675      */
676     function balanceOf(address owner) external view returns (uint256 balance);
677 
678     /**
679      * @dev Returns the owner of the `tokenId` token.
680      *
681      * Requirements:
682      *
683      * - `tokenId` must exist.
684      */
685     function ownerOf(uint256 tokenId) external view returns (address owner);
686 
687     /**
688      * @dev Safely transfers `tokenId` token from `from` to `to`,
689      * checking first that contract recipients are aware of the ERC721 protocol
690      * to prevent tokens from being forever locked.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must exist and be owned by `from`.
697      * - If the caller is not `from`, it must be have been allowed to move
698      * this token by either {approve} or {setApprovalForAll}.
699      * - If `to` refers to a smart contract, it must implement
700      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
701      *
702      * Emits a {Transfer} event.
703      */
704     function safeTransferFrom(
705         address from,
706         address to,
707         uint256 tokenId,
708         bytes calldata data
709     ) external payable;
710 
711     /**
712      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
713      */
714     function safeTransferFrom(
715         address from,
716         address to,
717         uint256 tokenId
718     ) external payable;
719 
720     /**
721      * @dev Transfers `tokenId` from `from` to `to`.
722      *
723      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
724      * whenever possible.
725      *
726      * Requirements:
727      *
728      * - `from` cannot be the zero address.
729      * - `to` cannot be the zero address.
730      * - `tokenId` token must be owned by `from`.
731      * - If the caller is not `from`, it must be approved to move this token
732      * by either {approve} or {setApprovalForAll}.
733      *
734      * Emits a {Transfer} event.
735      */
736     function transferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) external payable;
741 
742     /**
743      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
744      * The approval is cleared when the token is transferred.
745      *
746      * Only a single account can be approved at a time, so approving the
747      * zero address clears previous approvals.
748      *
749      * Requirements:
750      *
751      * - The caller must own the token or be an approved operator.
752      * - `tokenId` must exist.
753      *
754      * Emits an {Approval} event.
755      */
756     function approve(address to, uint256 tokenId) external payable;
757 
758     /**
759      * @dev Approve or remove `operator` as an operator for the caller.
760      * Operators can call {transferFrom} or {safeTransferFrom}
761      * for any token owned by the caller.
762      *
763      * Requirements:
764      *
765      * - The `operator` cannot be the caller.
766      *
767      * Emits an {ApprovalForAll} event.
768      */
769     function setApprovalForAll(address operator, bool _approved) external;
770 
771     /**
772      * @dev Returns the account approved for `tokenId` token.
773      *
774      * Requirements:
775      *
776      * - `tokenId` must exist.
777      */
778     function getApproved(uint256 tokenId) external view returns (address operator);
779 
780     /**
781      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
782      *
783      * See {setApprovalForAll}.
784      */
785     function isApprovedForAll(address owner, address operator) external view returns (bool);
786 
787     // =============================================================
788     //                        IERC721Metadata
789     // =============================================================
790 
791     /**
792      * @dev Returns the token collection name.
793      */
794     function name() external view returns (string memory);
795 
796     /**
797      * @dev Returns the token collection symbol.
798      */
799     function symbol() external view returns (string memory);
800 
801     /**
802      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
803      */
804     function tokenURI(uint256 tokenId) external view returns (string memory);
805 
806     // =============================================================
807     //                           IERC2309
808     // =============================================================
809 
810     /**
811      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
812      * (inclusive) is transferred from `from` to `to`, as defined in the
813      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
814      *
815      * See {_mintERC2309} for more details.
816      */
817     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
818 }
819 
820 // File: erc721a/contracts/ERC721A.sol
821 
822 
823 // ERC721A Contracts v4.2.3
824 // Creator: Chiru Labs
825 
826 pragma solidity ^0.8.4;
827 
828 
829 /**
830  * @dev Interface of ERC721 token receiver.
831  */
832 interface ERC721A__IERC721Receiver {
833     function onERC721Received(
834         address operator,
835         address from,
836         uint256 tokenId,
837         bytes calldata data
838     ) external returns (bytes4);
839 }
840 
841 /**
842  * @title ERC721A
843  *
844  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
845  * Non-Fungible Token Standard, including the Metadata extension.
846  * Optimized for lower gas during batch mints.
847  *
848  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
849  * starting from `_startTokenId()`.
850  *
851  * Assumptions:
852  *
853  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
854  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
855  */
856 contract ERC721A is IERC721A {
857     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
858     struct TokenApprovalRef {
859         address value;
860     }
861 
862     // =============================================================
863     //                           CONSTANTS
864     // =============================================================
865 
866     // Mask of an entry in packed address data.
867     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
868 
869     // The bit position of `numberMinted` in packed address data.
870     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
871 
872     // The bit position of `numberBurned` in packed address data.
873     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
874 
875     // The bit position of `aux` in packed address data.
876     uint256 private constant _BITPOS_AUX = 192;
877 
878     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
879     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
880 
881     // The bit position of `startTimestamp` in packed ownership.
882     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
883 
884     // The bit mask of the `burned` bit in packed ownership.
885     uint256 private constant _BITMASK_BURNED = 1 << 224;
886 
887     // The bit position of the `nextInitialized` bit in packed ownership.
888     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
889 
890     // The bit mask of the `nextInitialized` bit in packed ownership.
891     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
892 
893     // The bit position of `extraData` in packed ownership.
894     uint256 private constant _BITPOS_EXTRA_DATA = 232;
895 
896     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
897     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
898 
899     // The mask of the lower 160 bits for addresses.
900     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
901 
902     // The maximum `quantity` that can be minted with {_mintERC2309}.
903     // This limit is to prevent overflows on the address data entries.
904     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
905     // is required to cause an overflow, which is unrealistic.
906     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
907 
908     // The `Transfer` event signature is given by:
909     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
910     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
911         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
912 
913     // =============================================================
914     //                            STORAGE
915     // =============================================================
916 
917     // The next token ID to be minted.
918     uint256 private _currentIndex;
919 
920     // The number of tokens burned.
921     uint256 private _burnCounter;
922 
923     // Token name
924     string private _name;
925 
926     // Token symbol
927     string private _symbol;
928 
929     // Mapping from token ID to ownership details
930     // An empty struct value does not necessarily mean the token is unowned.
931     // See {_packedOwnershipOf} implementation for details.
932     //
933     // Bits Layout:
934     // - [0..159]   `addr`
935     // - [160..223] `startTimestamp`
936     // - [224]      `burned`
937     // - [225]      `nextInitialized`
938     // - [232..255] `extraData`
939     mapping(uint256 => uint256) private _packedOwnerships;
940 
941     // Mapping owner address to address data.
942     //
943     // Bits Layout:
944     // - [0..63]    `balance`
945     // - [64..127]  `numberMinted`
946     // - [128..191] `numberBurned`
947     // - [192..255] `aux`
948     mapping(address => uint256) private _packedAddressData;
949 
950     // Mapping from token ID to approved address.
951     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
952 
953     // Mapping from owner to operator approvals
954     mapping(address => mapping(address => bool)) private _operatorApprovals;
955 
956     // =============================================================
957     //                          CONSTRUCTOR
958     // =============================================================
959 
960     constructor(string memory name_, string memory symbol_) {
961         _name = name_;
962         _symbol = symbol_;
963         _currentIndex = _startTokenId();
964     }
965 
966     // =============================================================
967     //                   TOKEN COUNTING OPERATIONS
968     // =============================================================
969 
970     /**
971      * @dev Returns the starting token ID.
972      * To change the starting token ID, please override this function.
973      */
974     function _startTokenId() internal view virtual returns (uint256) {
975         return 1;
976     }
977 
978     /**
979      * @dev Returns the next token ID to be minted.
980      */
981     function _nextTokenId() internal view virtual returns (uint256) {
982         return _currentIndex;
983     }
984 
985     /**
986      * @dev Returns the total number of tokens in existence.
987      * Burned tokens will reduce the count.
988      * To get the total number of tokens minted, please see {_totalMinted}.
989      */
990     function totalSupply() public view virtual override returns (uint256) {
991         // Counter underflow is impossible as _burnCounter cannot be incremented
992         // more than `_currentIndex - _startTokenId()` times.
993         unchecked {
994             return _currentIndex - _burnCounter - _startTokenId();
995         }
996     }
997 
998     /**
999      * @dev Returns the total amount of tokens minted in the contract.
1000      */
1001     function _totalMinted() internal view virtual returns (uint256) {
1002         // Counter underflow is impossible as `_currentIndex` does not decrement,
1003         // and it is initialized to `_startTokenId()`.
1004         unchecked {
1005             return _currentIndex - _startTokenId();
1006         }
1007     }
1008 
1009     /**
1010      * @dev Returns the total number of tokens burned.
1011      */
1012     function _totalBurned() internal view virtual returns (uint256) {
1013         return _burnCounter;
1014     }
1015 
1016     // =============================================================
1017     //                    ADDRESS DATA OPERATIONS
1018     // =============================================================
1019 
1020     /**
1021      * @dev Returns the number of tokens in `owner`'s account.
1022      */
1023     function balanceOf(address owner) public view virtual override returns (uint256) {
1024         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1025         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1026     }
1027 
1028     /**
1029      * Returns the number of tokens minted by `owner`.
1030      */
1031     function _numberMinted(address owner) internal view returns (uint256) {
1032         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1033     }
1034 
1035     /**
1036      * Returns the number of tokens burned by or on behalf of `owner`.
1037      */
1038     function _numberBurned(address owner) internal view returns (uint256) {
1039         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1040     }
1041 
1042     /**
1043      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1044      */
1045     function _getAux(address owner) internal view returns (uint64) {
1046         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1047     }
1048 
1049     /**
1050      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1051      * If there are multiple variables, please pack them into a uint64.
1052      */
1053     function _setAux(address owner, uint64 aux) internal virtual {
1054         uint256 packed = _packedAddressData[owner];
1055         uint256 auxCasted;
1056         // Cast `aux` with assembly to avoid redundant masking.
1057         assembly {
1058             auxCasted := aux
1059         }
1060         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1061         _packedAddressData[owner] = packed;
1062     }
1063 
1064     // =============================================================
1065     //                            IERC165
1066     // =============================================================
1067 
1068     /**
1069      * @dev Returns true if this contract implements the interface defined by
1070      * `interfaceId`. See the corresponding
1071      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1072      * to learn more about how these ids are created.
1073      *
1074      * This function call must use less than 30000 gas.
1075      */
1076     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1077         // The interface IDs are constants representing the first 4 bytes
1078         // of the XOR of all function selectors in the interface.
1079         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1080         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1081         return
1082             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1083             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1084             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1085     }
1086 
1087     // =============================================================
1088     //                        IERC721Metadata
1089     // =============================================================
1090 
1091     /**
1092      * @dev Returns the token collection name.
1093      */
1094     function name() public view virtual override returns (string memory) {
1095         return _name;
1096     }
1097 
1098     /**
1099      * @dev Returns the token collection symbol.
1100      */
1101     function symbol() public view virtual override returns (string memory) {
1102         return _symbol;
1103     }
1104 
1105     /**
1106      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1107      */
1108     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1109         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1110 
1111         string memory baseURI = _baseURI();
1112         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1113     }
1114 
1115     /**
1116      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1117      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1118      * by default, it can be overridden in child contracts.
1119      */
1120     function _baseURI() internal view virtual returns (string memory) {
1121         return '';
1122     }
1123 
1124     // =============================================================
1125     //                     OWNERSHIPS OPERATIONS
1126     // =============================================================
1127 
1128     /**
1129      * @dev Returns the owner of the `tokenId` token.
1130      *
1131      * Requirements:
1132      *
1133      * - `tokenId` must exist.
1134      */
1135     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1136         return address(uint160(_packedOwnershipOf(tokenId)));
1137     }
1138 
1139     /**
1140      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1141      * It gradually moves to O(1) as tokens get transferred around over time.
1142      */
1143     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1144         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1145     }
1146 
1147     /**
1148      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1149      */
1150     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1151         return _unpackedOwnership(_packedOwnerships[index]);
1152     }
1153 
1154     /**
1155      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1156      */
1157     function _initializeOwnershipAt(uint256 index) internal virtual {
1158         if (_packedOwnerships[index] == 0) {
1159             _packedOwnerships[index] = _packedOwnershipOf(index);
1160         }
1161     }
1162 
1163     /**
1164      * Returns the packed ownership data of `tokenId`.
1165      */
1166     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1167         uint256 curr = tokenId;
1168 
1169         unchecked {
1170             if (_startTokenId() <= curr)
1171                 if (curr < _currentIndex) {
1172                     uint256 packed = _packedOwnerships[curr];
1173                     // If not burned.
1174                     if (packed & _BITMASK_BURNED == 0) {
1175                         // Invariant:
1176                         // There will always be an initialized ownership slot
1177                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1178                         // before an unintialized ownership slot
1179                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1180                         // Hence, `curr` will not underflow.
1181                         //
1182                         // We can directly compare the packed value.
1183                         // If the address is zero, packed will be zero.
1184                         while (packed == 0) {
1185                             packed = _packedOwnerships[--curr];
1186                         }
1187                         return packed;
1188                     }
1189                 }
1190         }
1191         revert OwnerQueryForNonexistentToken();
1192     }
1193 
1194     /**
1195      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1196      */
1197     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1198         ownership.addr = address(uint160(packed));
1199         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1200         ownership.burned = packed & _BITMASK_BURNED != 0;
1201         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1202     }
1203 
1204     /**
1205      * @dev Packs ownership data into a single uint256.
1206      */
1207     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1208         assembly {
1209             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1210             owner := and(owner, _BITMASK_ADDRESS)
1211             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1212             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1213         }
1214     }
1215 
1216     /**
1217      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1218      */
1219     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1220         // For branchless setting of the `nextInitialized` flag.
1221         assembly {
1222             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1223             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1224         }
1225     }
1226 
1227     // =============================================================
1228     //                      APPROVAL OPERATIONS
1229     // =============================================================
1230 
1231     /**
1232      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1233      * The approval is cleared when the token is transferred.
1234      *
1235      * Only a single account can be approved at a time, so approving the
1236      * zero address clears previous approvals.
1237      *
1238      * Requirements:
1239      *
1240      * - The caller must own the token or be an approved operator.
1241      * - `tokenId` must exist.
1242      *
1243      * Emits an {Approval} event.
1244      */
1245     function approve(address to, uint256 tokenId) public payable virtual override {
1246         address owner = ownerOf(tokenId);
1247 
1248         if (_msgSenderERC721A() != owner)
1249             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1250                 revert ApprovalCallerNotOwnerNorApproved();
1251             }
1252 
1253         _tokenApprovals[tokenId].value = to;
1254         emit Approval(owner, to, tokenId);
1255     }
1256 
1257     /**
1258      * @dev Returns the account approved for `tokenId` token.
1259      *
1260      * Requirements:
1261      *
1262      * - `tokenId` must exist.
1263      */
1264     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1265         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1266 
1267         return _tokenApprovals[tokenId].value;
1268     }
1269 
1270     /**
1271      * @dev Approve or remove `operator` as an operator for the caller.
1272      * Operators can call {transferFrom} or {safeTransferFrom}
1273      * for any token owned by the caller.
1274      *
1275      * Requirements:
1276      *
1277      * - The `operator` cannot be the caller.
1278      *
1279      * Emits an {ApprovalForAll} event.
1280      */
1281     function setApprovalForAll(address operator, bool approved) public virtual override {
1282         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1283         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1284     }
1285 
1286     /**
1287      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1288      *
1289      * See {setApprovalForAll}.
1290      */
1291     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1292         return _operatorApprovals[owner][operator];
1293     }
1294 
1295     /**
1296      * @dev Returns whether `tokenId` exists.
1297      *
1298      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1299      *
1300      * Tokens start existing when they are minted. See {_mint}.
1301      */
1302     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1303         return
1304             _startTokenId() <= tokenId &&
1305             tokenId < _currentIndex && // If within bounds,
1306             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1307     }
1308 
1309     /**
1310      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1311      */
1312     function _isSenderApprovedOrOwner(
1313         address approvedAddress,
1314         address owner,
1315         address msgSender
1316     ) private pure returns (bool result) {
1317         assembly {
1318             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1319             owner := and(owner, _BITMASK_ADDRESS)
1320             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1321             msgSender := and(msgSender, _BITMASK_ADDRESS)
1322             // `msgSender == owner || msgSender == approvedAddress`.
1323             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1324         }
1325     }
1326 
1327     /**
1328      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1329      */
1330     function _getApprovedSlotAndAddress(uint256 tokenId)
1331         private
1332         view
1333         returns (uint256 approvedAddressSlot, address approvedAddress)
1334     {
1335         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1336         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1337         assembly {
1338             approvedAddressSlot := tokenApproval.slot
1339             approvedAddress := sload(approvedAddressSlot)
1340         }
1341     }
1342 
1343     // =============================================================
1344     //                      TRANSFER OPERATIONS
1345     // =============================================================
1346 
1347     /**
1348      * @dev Transfers `tokenId` from `from` to `to`.
1349      *
1350      * Requirements:
1351      *
1352      * - `from` cannot be the zero address.
1353      * - `to` cannot be the zero address.
1354      * - `tokenId` token must be owned by `from`.
1355      * - If the caller is not `from`, it must be approved to move this token
1356      * by either {approve} or {setApprovalForAll}.
1357      *
1358      * Emits a {Transfer} event.
1359      */
1360     function transferFrom(
1361         address from,
1362         address to,
1363         uint256 tokenId
1364     ) public payable virtual override {
1365         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1366 
1367         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1368 
1369         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1370 
1371         // The nested ifs save around 20+ gas over a compound boolean condition.
1372         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1373             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1374 
1375         if (to == address(0)) revert TransferToZeroAddress();
1376 
1377         _beforeTokenTransfers(from, to, tokenId, 1);
1378 
1379         // Clear approvals from the previous owner.
1380         assembly {
1381             if approvedAddress {
1382                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1383                 sstore(approvedAddressSlot, 0)
1384             }
1385         }
1386 
1387         // Underflow of the sender's balance is impossible because we check for
1388         // ownership above and the recipient's balance can't realistically overflow.
1389         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1390         unchecked {
1391             // We can directly increment and decrement the balances.
1392             --_packedAddressData[from]; // Updates: `balance -= 1`.
1393             ++_packedAddressData[to]; // Updates: `balance += 1`.
1394 
1395             // Updates:
1396             // - `address` to the next owner.
1397             // - `startTimestamp` to the timestamp of transfering.
1398             // - `burned` to `false`.
1399             // - `nextInitialized` to `true`.
1400             _packedOwnerships[tokenId] = _packOwnershipData(
1401                 to,
1402                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1403             );
1404 
1405             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1406             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1407                 uint256 nextTokenId = tokenId + 1;
1408                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1409                 if (_packedOwnerships[nextTokenId] == 0) {
1410                     // If the next slot is within bounds.
1411                     if (nextTokenId != _currentIndex) {
1412                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1413                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1414                     }
1415                 }
1416             }
1417         }
1418 
1419         emit Transfer(from, to, tokenId);
1420         _afterTokenTransfers(from, to, tokenId, 1);
1421     }
1422 
1423     /**
1424      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1425      */
1426     function safeTransferFrom(
1427         address from,
1428         address to,
1429         uint256 tokenId
1430     ) public payable virtual override {
1431         safeTransferFrom(from, to, tokenId, '');
1432     }
1433 
1434     /**
1435      * @dev Safely transfers `tokenId` token from `from` to `to`.
1436      *
1437      * Requirements:
1438      *
1439      * - `from` cannot be the zero address.
1440      * - `to` cannot be the zero address.
1441      * - `tokenId` token must exist and be owned by `from`.
1442      * - If the caller is not `from`, it must be approved to move this token
1443      * by either {approve} or {setApprovalForAll}.
1444      * - If `to` refers to a smart contract, it must implement
1445      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1446      *
1447      * Emits a {Transfer} event.
1448      */
1449     function safeTransferFrom(
1450         address from,
1451         address to,
1452         uint256 tokenId,
1453         bytes memory _data
1454     ) public payable virtual override {
1455         transferFrom(from, to, tokenId);
1456         if (to.code.length != 0)
1457             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1458                 revert TransferToNonERC721ReceiverImplementer();
1459             }
1460     }
1461 
1462     /**
1463      * @dev Hook that is called before a set of serially-ordered token IDs
1464      * are about to be transferred. This includes minting.
1465      * And also called before burning one token.
1466      *
1467      * `startTokenId` - the first token ID to be transferred.
1468      * `quantity` - the amount to be transferred.
1469      *
1470      * Calling conditions:
1471      *
1472      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1473      * transferred to `to`.
1474      * - When `from` is zero, `tokenId` will be minted for `to`.
1475      * - When `to` is zero, `tokenId` will be burned by `from`.
1476      * - `from` and `to` are never both zero.
1477      */
1478     function _beforeTokenTransfers(
1479         address from,
1480         address to,
1481         uint256 startTokenId,
1482         uint256 quantity
1483     ) internal virtual {}
1484 
1485     /**
1486      * @dev Hook that is called after a set of serially-ordered token IDs
1487      * have been transferred. This includes minting.
1488      * And also called after one token has been burned.
1489      *
1490      * `startTokenId` - the first token ID to be transferred.
1491      * `quantity` - the amount to be transferred.
1492      *
1493      * Calling conditions:
1494      *
1495      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1496      * transferred to `to`.
1497      * - When `from` is zero, `tokenId` has been minted for `to`.
1498      * - When `to` is zero, `tokenId` has been burned by `from`.
1499      * - `from` and `to` are never both zero.
1500      */
1501     function _afterTokenTransfers(
1502         address from,
1503         address to,
1504         uint256 startTokenId,
1505         uint256 quantity
1506     ) internal virtual {}
1507 
1508     /**
1509      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1510      *
1511      * `from` - Previous owner of the given token ID.
1512      * `to` - Target address that will receive the token.
1513      * `tokenId` - Token ID to be transferred.
1514      * `_data` - Optional data to send along with the call.
1515      *
1516      * Returns whether the call correctly returned the expected magic value.
1517      */
1518     function _checkContractOnERC721Received(
1519         address from,
1520         address to,
1521         uint256 tokenId,
1522         bytes memory _data
1523     ) private returns (bool) {
1524         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1525             bytes4 retval
1526         ) {
1527             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1528         } catch (bytes memory reason) {
1529             if (reason.length == 0) {
1530                 revert TransferToNonERC721ReceiverImplementer();
1531             } else {
1532                 assembly {
1533                     revert(add(32, reason), mload(reason))
1534                 }
1535             }
1536         }
1537     }
1538 
1539     // =============================================================
1540     //                        MINT OPERATIONS
1541     // =============================================================
1542 
1543     /**
1544      * @dev Mints `quantity` tokens and transfers them to `to`.
1545      *
1546      * Requirements:
1547      *
1548      * - `to` cannot be the zero address.
1549      * - `quantity` must be greater than 0.
1550      *
1551      * Emits a {Transfer} event for each mint.
1552      */
1553     function _mint(address to, uint256 quantity) internal virtual {
1554         uint256 startTokenId = _currentIndex;
1555         if (quantity == 0) revert MintZeroQuantity();
1556 
1557         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1558 
1559         // Overflows are incredibly unrealistic.
1560         // `balance` and `numberMinted` have a maximum limit of 2**64.
1561         // `tokenId` has a maximum limit of 2**256.
1562         unchecked {
1563             // Updates:
1564             // - `balance += quantity`.
1565             // - `numberMinted += quantity`.
1566             //
1567             // We can directly add to the `balance` and `numberMinted`.
1568             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1569 
1570             // Updates:
1571             // - `address` to the owner.
1572             // - `startTimestamp` to the timestamp of minting.
1573             // - `burned` to `false`.
1574             // - `nextInitialized` to `quantity == 1`.
1575             _packedOwnerships[startTokenId] = _packOwnershipData(
1576                 to,
1577                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1578             );
1579 
1580             uint256 toMasked;
1581             uint256 end = startTokenId + quantity;
1582 
1583             // Use assembly to loop and emit the `Transfer` event for gas savings.
1584             // The duplicated `log4` removes an extra check and reduces stack juggling.
1585             // The assembly, together with the surrounding Solidity code, have been
1586             // delicately arranged to nudge the compiler into producing optimized opcodes.
1587             assembly {
1588                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1589                 toMasked := and(to, _BITMASK_ADDRESS)
1590                 // Emit the `Transfer` event.
1591                 log4(
1592                     0, // Start of data (0, since no data).
1593                     0, // End of data (0, since no data).
1594                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1595                     0, // `address(0)`.
1596                     toMasked, // `to`.
1597                     startTokenId // `tokenId`.
1598                 )
1599 
1600                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1601                 // that overflows uint256 will make the loop run out of gas.
1602                 // The compiler will optimize the `iszero` away for performance.
1603                 for {
1604                     let tokenId := add(startTokenId, 1)
1605                 } iszero(eq(tokenId, end)) {
1606                     tokenId := add(tokenId, 1)
1607                 } {
1608                     // Emit the `Transfer` event. Similar to above.
1609                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1610                 }
1611             }
1612             if (toMasked == 0) revert MintToZeroAddress();
1613 
1614             _currentIndex = end;
1615         }
1616         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1617     }
1618 
1619     /**
1620      * @dev Mints `quantity` tokens and transfers them to `to`.
1621      *
1622      * This function is intended for efficient minting only during contract creation.
1623      *
1624      * It emits only one {ConsecutiveTransfer} as defined in
1625      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1626      * instead of a sequence of {Transfer} event(s).
1627      *
1628      * Calling this function outside of contract creation WILL make your contract
1629      * non-compliant with the ERC721 standard.
1630      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1631      * {ConsecutiveTransfer} event is only permissible during contract creation.
1632      *
1633      * Requirements:
1634      *
1635      * - `to` cannot be the zero address.
1636      * - `quantity` must be greater than 0.
1637      *
1638      * Emits a {ConsecutiveTransfer} event.
1639      */
1640     function _mintERC2309(address to, uint256 quantity) internal virtual {
1641         uint256 startTokenId = _currentIndex;
1642         if (to == address(0)) revert MintToZeroAddress();
1643         if (quantity == 0) revert MintZeroQuantity();
1644         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1645 
1646         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1647 
1648         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1649         unchecked {
1650             // Updates:
1651             // - `balance += quantity`.
1652             // - `numberMinted += quantity`.
1653             //
1654             // We can directly add to the `balance` and `numberMinted`.
1655             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1656 
1657             // Updates:
1658             // - `address` to the owner.
1659             // - `startTimestamp` to the timestamp of minting.
1660             // - `burned` to `false`.
1661             // - `nextInitialized` to `quantity == 1`.
1662             _packedOwnerships[startTokenId] = _packOwnershipData(
1663                 to,
1664                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1665             );
1666 
1667             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1668 
1669             _currentIndex = startTokenId + quantity;
1670         }
1671         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1672     }
1673 
1674     /**
1675      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1676      *
1677      * Requirements:
1678      *
1679      * - If `to` refers to a smart contract, it must implement
1680      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1681      * - `quantity` must be greater than 0.
1682      *
1683      * See {_mint}.
1684      *
1685      * Emits a {Transfer} event for each mint.
1686      */
1687     function _safeMint(
1688         address to,
1689         uint256 quantity,
1690         bytes memory _data
1691     ) internal virtual {
1692         _mint(to, quantity);
1693 
1694         unchecked {
1695             if (to.code.length != 0) {
1696                 uint256 end = _currentIndex;
1697                 uint256 index = end - quantity;
1698                 do {
1699                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1700                         revert TransferToNonERC721ReceiverImplementer();
1701                     }
1702                 } while (index < end);
1703                 // Reentrancy protection.
1704                 if (_currentIndex != end) revert();
1705             }
1706         }
1707     }
1708 
1709     /**
1710      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1711      */
1712     function _safeMint(address to, uint256 quantity) internal virtual {
1713         _safeMint(to, quantity, '');
1714     }
1715 
1716     // =============================================================
1717     //                        BURN OPERATIONS
1718     // =============================================================
1719 
1720     /**
1721      * @dev Equivalent to `_burn(tokenId, false)`.
1722      */
1723     function _burn(uint256 tokenId) internal virtual {
1724         _burn(tokenId, false);
1725     }
1726 
1727     /**
1728      * @dev Destroys `tokenId`.
1729      * The approval is cleared when the token is burned.
1730      *
1731      * Requirements:
1732      *
1733      * - `tokenId` must exist.
1734      *
1735      * Emits a {Transfer} event.
1736      */
1737     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1738         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1739 
1740         address from = address(uint160(prevOwnershipPacked));
1741 
1742         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1743 
1744         if (approvalCheck) {
1745             // The nested ifs save around 20+ gas over a compound boolean condition.
1746             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1747                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1748         }
1749 
1750         _beforeTokenTransfers(from, address(0), tokenId, 1);
1751 
1752         // Clear approvals from the previous owner.
1753         assembly {
1754             if approvedAddress {
1755                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1756                 sstore(approvedAddressSlot, 0)
1757             }
1758         }
1759 
1760         // Underflow of the sender's balance is impossible because we check for
1761         // ownership above and the recipient's balance can't realistically overflow.
1762         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1763         unchecked {
1764             // Updates:
1765             // - `balance -= 1`.
1766             // - `numberBurned += 1`.
1767             //
1768             // We can directly decrement the balance, and increment the number burned.
1769             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1770             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1771 
1772             // Updates:
1773             // - `address` to the last owner.
1774             // - `startTimestamp` to the timestamp of burning.
1775             // - `burned` to `true`.
1776             // - `nextInitialized` to `true`.
1777             _packedOwnerships[tokenId] = _packOwnershipData(
1778                 from,
1779                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1780             );
1781 
1782             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1783             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1784                 uint256 nextTokenId = tokenId + 1;
1785                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1786                 if (_packedOwnerships[nextTokenId] == 0) {
1787                     // If the next slot is within bounds.
1788                     if (nextTokenId != _currentIndex) {
1789                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1790                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1791                     }
1792                 }
1793             }
1794         }
1795 
1796         emit Transfer(from, address(0), tokenId);
1797         _afterTokenTransfers(from, address(0), tokenId, 1);
1798 
1799         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1800         unchecked {
1801             _burnCounter++;
1802         }
1803     }
1804 
1805     // =============================================================
1806     //                     EXTRA DATA OPERATIONS
1807     // =============================================================
1808 
1809     /**
1810      * @dev Directly sets the extra data for the ownership data `index`.
1811      */
1812     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1813         uint256 packed = _packedOwnerships[index];
1814         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1815         uint256 extraDataCasted;
1816         // Cast `extraData` with assembly to avoid redundant masking.
1817         assembly {
1818             extraDataCasted := extraData
1819         }
1820         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1821         _packedOwnerships[index] = packed;
1822     }
1823 
1824     /**
1825      * @dev Called during each token transfer to set the 24bit `extraData` field.
1826      * Intended to be overridden by the cosumer contract.
1827      *
1828      * `previousExtraData` - the value of `extraData` before transfer.
1829      *
1830      * Calling conditions:
1831      *
1832      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1833      * transferred to `to`.
1834      * - When `from` is zero, `tokenId` will be minted for `to`.
1835      * - When `to` is zero, `tokenId` will be burned by `from`.
1836      * - `from` and `to` are never both zero.
1837      */
1838     function _extraData(
1839         address from,
1840         address to,
1841         uint24 previousExtraData
1842     ) internal view virtual returns (uint24) {}
1843 
1844     /**
1845      * @dev Returns the next extra data for the packed ownership data.
1846      * The returned result is shifted into position.
1847      */
1848     function _nextExtraData(
1849         address from,
1850         address to,
1851         uint256 prevOwnershipPacked
1852     ) private view returns (uint256) {
1853         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1854         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1855     }
1856 
1857     // =============================================================
1858     //                       OTHER OPERATIONS
1859     // =============================================================
1860 
1861     /**
1862      * @dev Returns the message sender (defaults to `msg.sender`).
1863      *
1864      * If you are writing GSN compatible contracts, you need to override this function.
1865      */
1866     function _msgSenderERC721A() internal view virtual returns (address) {
1867         return msg.sender;
1868     }
1869 
1870     /**
1871      * @dev Converts a uint256 to its ASCII string decimal representation.
1872      */
1873     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1874         assembly {
1875             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1876             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1877             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1878             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1879             let m := add(mload(0x40), 0xa0)
1880             // Update the free memory pointer to allocate.
1881             mstore(0x40, m)
1882             // Assign the `str` to the end.
1883             str := sub(m, 0x20)
1884             // Zeroize the slot after the string.
1885             mstore(str, 0)
1886 
1887             // Cache the end of the memory to calculate the length later.
1888             let end := str
1889 
1890             // We write the string from rightmost digit to leftmost digit.
1891             // The following is essentially a do-while loop that also handles the zero case.
1892             // prettier-ignore
1893             for { let temp := value } 1 {} {
1894                 str := sub(str, 1)
1895                 // Write the character to the pointer.
1896                 // The ASCII index of the '0' character is 48.
1897                 mstore8(str, add(48, mod(temp, 10)))
1898                 // Keep dividing `temp` until zero.
1899                 temp := div(temp, 10)
1900                 // prettier-ignore
1901                 if iszero(temp) { break }
1902             }
1903 
1904             let length := sub(end, str)
1905             // Move the pointer 32 bytes leftwards to make room for the length.
1906             str := sub(str, 0x20)
1907             // Store the length.
1908             mstore(str, length)
1909         }
1910     }
1911 }
1912 
1913 // File: ElchaiCarClubCardNFT.sol
1914 
1915 
1916 pragma solidity ^0.8.7;
1917 
1918 
1919 contract ElchaiCarClubCardNFT is ERC721A, Ownable {
1920     using Strings for uint256;
1921 
1922     //declares the maximum amount of tokens that can be minted
1923     uint256 private max_nft_supply = 10000;
1924 
1925     //maximum amount of mints allowed per person
1926     uint256 public max_nft_per_wallet = 5;
1927 
1928     //amount of mints that each address has executed
1929     mapping(address => uint256) public mintsPerAddress;
1930 
1931     //dictates if sale is paused or not
1932     bool public saleIsActive = false;
1933 
1934     //initial part of the URI for the metadata
1935     string public baseTokenURI;
1936 
1937     //the amount of reserved mints that have currently been executed by creator and giveaways
1938     uint private _reservedMints = 0;
1939     
1940     //the maximum amount of reserved mints allowed for creator and giveaways
1941     uint private maxReservedMints = 6400;
1942 
1943     // extention
1944     string public baseURLExtention = ".json";
1945 
1946     // terms and conditions URL
1947     string public termsAndConditionURL = "https://elchaicarclub.com/nft/card-nft";
1948 
1949 
1950     constructor(string memory _uri) ERC721A("Elchai Card NFT", "ECN") {
1951         baseTokenURI =_uri;
1952     }
1953 
1954     //reserved NFTs for creator
1955     function reservedMint(uint256 numberOfNFT, address recipient) public onlyOwner { 
1956         require( totalSupply()+ numberOfNFT <= max_nft_supply, "Reserve nft would exceed max supply of NFTs");
1957         _safeMint(recipient, numberOfNFT);
1958         mintsPerAddress[recipient] += numberOfNFT;
1959         _reservedMints +=_reservedMints;
1960     }
1961 
1962     // public minting
1963     function mint(uint256 numberOfNFT) public {
1964         require(saleIsActive, "Public Sale in not open yet!");
1965         require(totalSupply() + numberOfNFT <= max_nft_supply - maxReservedMints, "Not enough NFTs left to mint..");
1966         require(balanceOf(msg.sender) + numberOfNFT <= max_nft_per_wallet, "Purchase exceeds max allowed per wallet");
1967         _safeMint(msg.sender, numberOfNFT);
1968         mintsPerAddress[msg.sender] += numberOfNFT;
1969     }
1970 
1971     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1972         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1973         string memory baseURI = _baseURI();
1974         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId_.toString(), baseURLExtention)) : "";
1975     }
1976 
1977 
1978     function setMaxReservedMints(uint256 _newReserveNFT) public onlyOwner {
1979         maxReservedMints = _newReserveNFT;
1980     }
1981 
1982     function freezeMinting() public onlyOwner {
1983         max_nft_supply = totalSupply();
1984     }
1985     
1986     //se the current account balance
1987     function accountBalance() public onlyOwner view returns(uint) {
1988         return address(this).balance;
1989     }
1990 
1991     //retrieve all funds recieved from minting
1992     function withdraw() public onlyOwner {
1993         uint256 balance = accountBalance();
1994         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1995         _withdraw(payable(address(this)), balance); 
1996     }
1997     
1998     //send the percentage of funds to a shareholder´s wallet
1999     function _withdraw(address payable account, uint256 amount) internal {
2000         (bool sent, ) = account.call{value: amount}("");
2001         require(sent, "Failed to send Ether");
2002     }
2003 
2004 
2005     //update terms and conditions URL
2006     function setTermsAndConditionURL(string memory _termsAndConditionURL) public onlyOwner {
2007         termsAndConditionURL = _termsAndConditionURL;
2008     }
2009 
2010     //change baseURI in case needed for IPFS
2011     function setBaseURI(string memory baseURI) public onlyOwner {
2012         baseTokenURI = baseURI;
2013     }
2014 
2015     // change sale state
2016     function pause() public onlyOwner {
2017         saleIsActive = !saleIsActive;
2018     }
2019 
2020      function isPaused() public view returns(bool) {
2021         return saleIsActive;
2022     }
2023 
2024     //visualize baseURI
2025     function _baseURI() internal view virtual override returns (string memory) {
2026         return baseTokenURI;
2027     }
2028 
2029     // change sale state
2030     function nftsAvailabelForFreeMint() external view returns(uint256) {
2031         return (max_nft_supply - maxReservedMints - totalSupply());
2032     }
2033 
2034     //in case somebody accidentaly sends funds or transaction to contract
2035     receive() payable external {}
2036     fallback() payable external {
2037         revert();
2038     }
2039 
2040     function getMintsPerAddress(address _userAddr) external view returns(uint) {
2041         return mintsPerAddress[_userAddr];
2042     }
2043 }