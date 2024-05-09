1 // File: @openzeppelin/contracts/utils/math/Math.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     enum Rounding {
13         Down, // Toward negative infinity
14         Up, // Toward infinity
15         Zero // Toward zero
16     }
17 
18     /**
19      * @dev Returns the largest of two numbers.
20      */
21     function max(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a > b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the smallest of two numbers.
27      */
28     function min(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a < b ? a : b;
30     }
31 
32     /**
33      * @dev Returns the average of two numbers. The result is rounded towards
34      * zero.
35      */
36     function average(uint256 a, uint256 b) internal pure returns (uint256) {
37         // (a + b) / 2 can overflow.
38         return (a & b) + (a ^ b) / 2;
39     }
40 
41     /**
42      * @dev Returns the ceiling of the division of two numbers.
43      *
44      * This differs from standard division with `/` in that it rounds up instead
45      * of rounding down.
46      */
47     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
48         // (a + b - 1) / b can overflow on addition, so we distribute.
49         return a == 0 ? 0 : (a - 1) / b + 1;
50     }
51 
52     /**
53      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
54      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
55      * with further edits by Uniswap Labs also under MIT license.
56      */
57     function mulDiv(
58         uint256 x,
59         uint256 y,
60         uint256 denominator
61     ) internal pure returns (uint256 result) {
62         unchecked {
63             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
64             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
65             // variables such that product = prod1 * 2^256 + prod0.
66             uint256 prod0; // Least significant 256 bits of the product
67             uint256 prod1; // Most significant 256 bits of the product
68             assembly {
69                 let mm := mulmod(x, y, not(0))
70                 prod0 := mul(x, y)
71                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
72             }
73 
74             // Handle non-overflow cases, 256 by 256 division.
75             if (prod1 == 0) {
76                 return prod0 / denominator;
77             }
78 
79             // Make sure the result is less than 2^256. Also prevents denominator == 0.
80             require(denominator > prod1);
81 
82             ///////////////////////////////////////////////
83             // 512 by 256 division.
84             ///////////////////////////////////////////////
85 
86             // Make division exact by subtracting the remainder from [prod1 prod0].
87             uint256 remainder;
88             assembly {
89                 // Compute remainder using mulmod.
90                 remainder := mulmod(x, y, denominator)
91 
92                 // Subtract 256 bit number from 512 bit number.
93                 prod1 := sub(prod1, gt(remainder, prod0))
94                 prod0 := sub(prod0, remainder)
95             }
96 
97             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
98             // See https://cs.stackexchange.com/q/138556/92363.
99 
100             // Does not overflow because the denominator cannot be zero at this stage in the function.
101             uint256 twos = denominator & (~denominator + 1);
102             assembly {
103                 // Divide denominator by twos.
104                 denominator := div(denominator, twos)
105 
106                 // Divide [prod1 prod0] by twos.
107                 prod0 := div(prod0, twos)
108 
109                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
110                 twos := add(div(sub(0, twos), twos), 1)
111             }
112 
113             // Shift in bits from prod1 into prod0.
114             prod0 |= prod1 * twos;
115 
116             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
117             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
118             // four bits. That is, denominator * inv = 1 mod 2^4.
119             uint256 inverse = (3 * denominator) ^ 2;
120 
121             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
122             // in modular arithmetic, doubling the correct bits in each step.
123             inverse *= 2 - denominator * inverse; // inverse mod 2^8
124             inverse *= 2 - denominator * inverse; // inverse mod 2^16
125             inverse *= 2 - denominator * inverse; // inverse mod 2^32
126             inverse *= 2 - denominator * inverse; // inverse mod 2^64
127             inverse *= 2 - denominator * inverse; // inverse mod 2^128
128             inverse *= 2 - denominator * inverse; // inverse mod 2^256
129 
130             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
131             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
132             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
133             // is no longer required.
134             result = prod0 * inverse;
135             return result;
136         }
137     }
138 
139     /**
140      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
141      */
142     function mulDiv(
143         uint256 x,
144         uint256 y,
145         uint256 denominator,
146         Rounding rounding
147     ) internal pure returns (uint256) {
148         uint256 result = mulDiv(x, y, denominator);
149         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
150             result += 1;
151         }
152         return result;
153     }
154 
155     /**
156      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
157      *
158      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
159      */
160     function sqrt(uint256 a) internal pure returns (uint256) {
161         if (a == 0) {
162             return 0;
163         }
164 
165         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
166         //
167         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
168         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
169         //
170         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
171         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
172         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
173         //
174         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
175         uint256 result = 1 << (log2(a) >> 1);
176 
177         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
178         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
179         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
180         // into the expected uint128 result.
181         unchecked {
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             return min(result, a / result);
190         }
191     }
192 
193     /**
194      * @notice Calculates sqrt(a), following the selected rounding direction.
195      */
196     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
197         unchecked {
198             uint256 result = sqrt(a);
199             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
200         }
201     }
202 
203     /**
204      * @dev Return the log in base 2, rounded down, of a positive value.
205      * Returns 0 if given 0.
206      */
207     function log2(uint256 value) internal pure returns (uint256) {
208         uint256 result = 0;
209         unchecked {
210             if (value >> 128 > 0) {
211                 value >>= 128;
212                 result += 128;
213             }
214             if (value >> 64 > 0) {
215                 value >>= 64;
216                 result += 64;
217             }
218             if (value >> 32 > 0) {
219                 value >>= 32;
220                 result += 32;
221             }
222             if (value >> 16 > 0) {
223                 value >>= 16;
224                 result += 16;
225             }
226             if (value >> 8 > 0) {
227                 value >>= 8;
228                 result += 8;
229             }
230             if (value >> 4 > 0) {
231                 value >>= 4;
232                 result += 4;
233             }
234             if (value >> 2 > 0) {
235                 value >>= 2;
236                 result += 2;
237             }
238             if (value >> 1 > 0) {
239                 result += 1;
240             }
241         }
242         return result;
243     }
244 
245     /**
246      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
247      * Returns 0 if given 0.
248      */
249     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
250         unchecked {
251             uint256 result = log2(value);
252             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
253         }
254     }
255 
256     /**
257      * @dev Return the log in base 10, rounded down, of a positive value.
258      * Returns 0 if given 0.
259      */
260     function log10(uint256 value) internal pure returns (uint256) {
261         uint256 result = 0;
262         unchecked {
263             if (value >= 10**64) {
264                 value /= 10**64;
265                 result += 64;
266             }
267             if (value >= 10**32) {
268                 value /= 10**32;
269                 result += 32;
270             }
271             if (value >= 10**16) {
272                 value /= 10**16;
273                 result += 16;
274             }
275             if (value >= 10**8) {
276                 value /= 10**8;
277                 result += 8;
278             }
279             if (value >= 10**4) {
280                 value /= 10**4;
281                 result += 4;
282             }
283             if (value >= 10**2) {
284                 value /= 10**2;
285                 result += 2;
286             }
287             if (value >= 10**1) {
288                 result += 1;
289             }
290         }
291         return result;
292     }
293 
294     /**
295      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
296      * Returns 0 if given 0.
297      */
298     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
299         unchecked {
300             uint256 result = log10(value);
301             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
302         }
303     }
304 
305     /**
306      * @dev Return the log in base 256, rounded down, of a positive value.
307      * Returns 0 if given 0.
308      *
309      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
310      */
311     function log256(uint256 value) internal pure returns (uint256) {
312         uint256 result = 0;
313         unchecked {
314             if (value >> 128 > 0) {
315                 value >>= 128;
316                 result += 16;
317             }
318             if (value >> 64 > 0) {
319                 value >>= 64;
320                 result += 8;
321             }
322             if (value >> 32 > 0) {
323                 value >>= 32;
324                 result += 4;
325             }
326             if (value >> 16 > 0) {
327                 value >>= 16;
328                 result += 2;
329             }
330             if (value >> 8 > 0) {
331                 result += 1;
332             }
333         }
334         return result;
335     }
336 
337     /**
338      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
339      * Returns 0 if given 0.
340      */
341     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
342         unchecked {
343             uint256 result = log256(value);
344             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
345         }
346     }
347 }
348 
349 // File: @openzeppelin/contracts/utils/Strings.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev String operations.
359  */
360 library Strings {
361     bytes16 private constant _SYMBOLS = "0123456789abcdef";
362     uint8 private constant _ADDRESS_LENGTH = 20;
363 
364     /**
365      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
366      */
367     function toString(uint256 value) internal pure returns (string memory) {
368         unchecked {
369             uint256 length = Math.log10(value) + 1;
370             string memory buffer = new string(length);
371             uint256 ptr;
372             /// @solidity memory-safe-assembly
373             assembly {
374                 ptr := add(buffer, add(32, length))
375             }
376             while (true) {
377                 ptr--;
378                 /// @solidity memory-safe-assembly
379                 assembly {
380                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
381                 }
382                 value /= 10;
383                 if (value == 0) break;
384             }
385             return buffer;
386         }
387     }
388 
389     /**
390      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
391      */
392     function toHexString(uint256 value) internal pure returns (string memory) {
393         unchecked {
394             return toHexString(value, Math.log256(value) + 1);
395         }
396     }
397 
398     /**
399      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
400      */
401     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
402         bytes memory buffer = new bytes(2 * length + 2);
403         buffer[0] = "0";
404         buffer[1] = "x";
405         for (uint256 i = 2 * length + 1; i > 1; --i) {
406             buffer[i] = _SYMBOLS[value & 0xf];
407             value >>= 4;
408         }
409         require(value == 0, "Strings: hex length insufficient");
410         return string(buffer);
411     }
412 
413     /**
414      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
415      */
416     function toHexString(address addr) internal pure returns (string memory) {
417         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
418     }
419 }
420 
421 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
422 
423 
424 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @dev Provides information about the current execution context, including the
430  * sender of the transaction and its data. While these are generally available
431  * via msg.sender and msg.data, they should not be accessed in such a direct
432  * manner, since when dealing with meta-transactions the account sending and
433  * paying for execution may not be the actual sender (as far as an application
434  * is concerned).
435  *
436  * This contract is only required for intermediate, library-like contracts.
437  */
438 abstract contract Context {
439     function _msgSender() internal view virtual returns (address) {
440         return msg.sender;
441     }
442 
443     function _msgData() internal view virtual returns (bytes calldata) {
444         return msg.data;
445     }
446 }
447 
448 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
449 
450 
451 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 
456 /**
457  * @dev Contract module which provides a basic access control mechanism, where
458  * there is an account (an owner) that can be granted exclusive access to
459  * specific functions.
460  *
461  * By default, the owner account will be the one that deploys the contract. This
462  * can later be changed with {transferOwnership}.
463  *
464  * This module is used through inheritance. It will make available the modifier
465  * `onlyOwner`, which can be applied to your functions to restrict their use to
466  * the owner.
467  */
468 abstract contract Ownable is Context {
469     address private _owner;
470 
471     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
472 
473     /**
474      * @dev Initializes the contract setting the deployer as the initial owner.
475      */
476     constructor() {
477         _transferOwnership(_msgSender());
478     }
479 
480     /**
481      * @dev Throws if called by any account other than the owner.
482      */
483     modifier onlyOwner() {
484         _checkOwner();
485         _;
486     }
487 
488     /**
489      * @dev Returns the address of the current owner.
490      */
491     function owner() public view virtual returns (address) {
492         return _owner;
493     }
494 
495     /**
496      * @dev Throws if the sender is not the owner.
497      */
498     function _checkOwner() internal view virtual {
499         require(owner() == _msgSender(), "Ownable: caller is not the owner");
500     }
501 
502     /**
503      * @dev Leaves the contract without owner. It will not be possible to call
504      * `onlyOwner` functions. Can only be called by the current owner.
505      *
506      * NOTE: Renouncing ownership will leave the contract without an owner,
507      * thereby disabling any functionality that is only available to the owner.
508      */
509     function renounceOwnership() public virtual onlyOwner {
510         _transferOwnership(address(0));
511     }
512 
513     /**
514      * @dev Transfers ownership of the contract to a new account (`newOwner`).
515      * Can only be called by the current owner.
516      */
517     function transferOwnership(address newOwner) public virtual onlyOwner {
518         require(newOwner != address(0), "Ownable: new owner is the zero address");
519         _transferOwnership(newOwner);
520     }
521 
522     /**
523      * @dev Transfers ownership of the contract to a new account (`newOwner`).
524      * Internal function without access restriction.
525      */
526     function _transferOwnership(address newOwner) internal virtual {
527         address oldOwner = _owner;
528         _owner = newOwner;
529         emit OwnershipTransferred(oldOwner, newOwner);
530     }
531 }
532 
533 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
534 
535 
536 // ERC721A Contracts v4.2.3
537 // Creator: Chiru Labs
538 
539 pragma solidity ^0.8.4;
540 
541 /**
542  * @dev Interface of ERC721A.
543  */
544 interface IERC721A {
545     /**
546      * The caller must own the token or be an approved operator.
547      */
548     error ApprovalCallerNotOwnerNorApproved();
549 
550     /**
551      * The token does not exist.
552      */
553     error ApprovalQueryForNonexistentToken();
554 
555     /**
556      * Cannot query the balance for the zero address.
557      */
558     error BalanceQueryForZeroAddress();
559 
560     /**
561      * Cannot mint to the zero address.
562      */
563     error MintToZeroAddress();
564 
565     /**
566      * The quantity of tokens minted must be more than zero.
567      */
568     error MintZeroQuantity();
569 
570     /**
571      * The token does not exist.
572      */
573     error OwnerQueryForNonexistentToken();
574 
575     /**
576      * The caller must own the token or be an approved operator.
577      */
578     error TransferCallerNotOwnerNorApproved();
579 
580     /**
581      * The token must be owned by `from`.
582      */
583     error TransferFromIncorrectOwner();
584 
585     /**
586      * Cannot safely transfer to a contract that does not implement the
587      * ERC721Receiver interface.
588      */
589     error TransferToNonERC721ReceiverImplementer();
590 
591     /**
592      * Cannot transfer to the zero address.
593      */
594     error TransferToZeroAddress();
595 
596     /**
597      * The token does not exist.
598      */
599     error URIQueryForNonexistentToken();
600 
601     /**
602      * The `quantity` minted with ERC2309 exceeds the safety limit.
603      */
604     error MintERC2309QuantityExceedsLimit();
605 
606     /**
607      * The `extraData` cannot be set on an unintialized ownership slot.
608      */
609     error OwnershipNotInitializedForExtraData();
610 
611     // =============================================================
612     //                            STRUCTS
613     // =============================================================
614 
615     struct TokenOwnership {
616         // The address of the owner.
617         address addr;
618         // Stores the start time of ownership with minimal overhead for tokenomics.
619         uint64 startTimestamp;
620         // Whether the token has been burned.
621         bool burned;
622         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
623         uint24 extraData;
624     }
625 
626     // =============================================================
627     //                         TOKEN COUNTERS
628     // =============================================================
629 
630     /**
631      * @dev Returns the total number of tokens in existence.
632      * Burned tokens will reduce the count.
633      * To get the total number of tokens minted, please see {_totalMinted}.
634      */
635     function totalSupply() external view returns (uint256);
636 
637     // =============================================================
638     //                            IERC165
639     // =============================================================
640 
641     /**
642      * @dev Returns true if this contract implements the interface defined by
643      * `interfaceId`. See the corresponding
644      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
645      * to learn more about how these ids are created.
646      *
647      * This function call must use less than 30000 gas.
648      */
649     function supportsInterface(bytes4 interfaceId) external view returns (bool);
650 
651     // =============================================================
652     //                            IERC721
653     // =============================================================
654 
655     /**
656      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
657      */
658     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
659 
660     /**
661      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
662      */
663     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
664 
665     /**
666      * @dev Emitted when `owner` enables or disables
667      * (`approved`) `operator` to manage all of its assets.
668      */
669     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
670 
671     /**
672      * @dev Returns the number of tokens in `owner`'s account.
673      */
674     function balanceOf(address owner) external view returns (uint256 balance);
675 
676     /**
677      * @dev Returns the owner of the `tokenId` token.
678      *
679      * Requirements:
680      *
681      * - `tokenId` must exist.
682      */
683     function ownerOf(uint256 tokenId) external view returns (address owner);
684 
685     /**
686      * @dev Safely transfers `tokenId` token from `from` to `to`,
687      * checking first that contract recipients are aware of the ERC721 protocol
688      * to prevent tokens from being forever locked.
689      *
690      * Requirements:
691      *
692      * - `from` cannot be the zero address.
693      * - `to` cannot be the zero address.
694      * - `tokenId` token must exist and be owned by `from`.
695      * - If the caller is not `from`, it must be have been allowed to move
696      * this token by either {approve} or {setApprovalForAll}.
697      * - If `to` refers to a smart contract, it must implement
698      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
699      *
700      * Emits a {Transfer} event.
701      */
702     function safeTransferFrom(
703         address from,
704         address to,
705         uint256 tokenId,
706         bytes calldata data
707     ) external payable;
708 
709     /**
710      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
711      */
712     function safeTransferFrom(
713         address from,
714         address to,
715         uint256 tokenId
716     ) external payable;
717 
718     /**
719      * @dev Transfers `tokenId` from `from` to `to`.
720      *
721      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
722      * whenever possible.
723      *
724      * Requirements:
725      *
726      * - `from` cannot be the zero address.
727      * - `to` cannot be the zero address.
728      * - `tokenId` token must be owned by `from`.
729      * - If the caller is not `from`, it must be approved to move this token
730      * by either {approve} or {setApprovalForAll}.
731      *
732      * Emits a {Transfer} event.
733      */
734     function transferFrom(
735         address from,
736         address to,
737         uint256 tokenId
738     ) external payable;
739 
740     /**
741      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
742      * The approval is cleared when the token is transferred.
743      *
744      * Only a single account can be approved at a time, so approving the
745      * zero address clears previous approvals.
746      *
747      * Requirements:
748      *
749      * - The caller must own the token or be an approved operator.
750      * - `tokenId` must exist.
751      *
752      * Emits an {Approval} event.
753      */
754     function approve(address to, uint256 tokenId) external payable;
755 
756     /**
757      * @dev Approve or remove `operator` as an operator for the caller.
758      * Operators can call {transferFrom} or {safeTransferFrom}
759      * for any token owned by the caller.
760      *
761      * Requirements:
762      *
763      * - The `operator` cannot be the caller.
764      *
765      * Emits an {ApprovalForAll} event.
766      */
767     function setApprovalForAll(address operator, bool _approved) external;
768 
769     /**
770      * @dev Returns the account approved for `tokenId` token.
771      *
772      * Requirements:
773      *
774      * - `tokenId` must exist.
775      */
776     function getApproved(uint256 tokenId) external view returns (address operator);
777 
778     /**
779      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
780      *
781      * See {setApprovalForAll}.
782      */
783     function isApprovedForAll(address owner, address operator) external view returns (bool);
784 
785     // =============================================================
786     //                        IERC721Metadata
787     // =============================================================
788 
789     /**
790      * @dev Returns the token collection name.
791      */
792     function name() external view returns (string memory);
793 
794     /**
795      * @dev Returns the token collection symbol.
796      */
797     function symbol() external view returns (string memory);
798 
799     /**
800      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
801      */
802     function tokenURI(uint256 tokenId) external view returns (string memory);
803 
804     // =============================================================
805     //                           IERC2309
806     // =============================================================
807 
808     /**
809      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
810      * (inclusive) is transferred from `from` to `to`, as defined in the
811      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
812      *
813      * See {_mintERC2309} for more details.
814      */
815     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
816 }
817 
818 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
819 
820 
821 // ERC721A Contracts v4.2.3
822 // Creator: Chiru Labs
823 
824 pragma solidity ^0.8.4;
825 
826 
827 /**
828  * @dev Interface of ERC721 token receiver.
829  */
830 interface ERC721A__IERC721Receiver {
831     function onERC721Received(
832         address operator,
833         address from,
834         uint256 tokenId,
835         bytes calldata data
836     ) external returns (bytes4);
837 }
838 
839 /**
840  * @title ERC721A
841  *
842  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
843  * Non-Fungible Token Standard, including the Metadata extension.
844  * Optimized for lower gas during batch mints.
845  *
846  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
847  * starting from `_startTokenId()`.
848  *
849  * Assumptions:
850  *
851  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
852  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
853  */
854 contract ERC721A is IERC721A {
855     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
856     struct TokenApprovalRef {
857         address value;
858     }
859 
860     // =============================================================
861     //                           CONSTANTS
862     // =============================================================
863 
864     // Mask of an entry in packed address data.
865     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
866 
867     // The bit position of `numberMinted` in packed address data.
868     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
869 
870     // The bit position of `numberBurned` in packed address data.
871     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
872 
873     // The bit position of `aux` in packed address data.
874     uint256 private constant _BITPOS_AUX = 192;
875 
876     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
877     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
878 
879     // The bit position of `startTimestamp` in packed ownership.
880     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
881 
882     // The bit mask of the `burned` bit in packed ownership.
883     uint256 private constant _BITMASK_BURNED = 1 << 224;
884 
885     // The bit position of the `nextInitialized` bit in packed ownership.
886     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
887 
888     // The bit mask of the `nextInitialized` bit in packed ownership.
889     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
890 
891     // The bit position of `extraData` in packed ownership.
892     uint256 private constant _BITPOS_EXTRA_DATA = 232;
893 
894     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
895     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
896 
897     // The mask of the lower 160 bits for addresses.
898     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
899 
900     // The maximum `quantity` that can be minted with {_mintERC2309}.
901     // This limit is to prevent overflows on the address data entries.
902     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
903     // is required to cause an overflow, which is unrealistic.
904     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
905 
906     // The `Transfer` event signature is given by:
907     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
908     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
909         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
910 
911     // =============================================================
912     //                            STORAGE
913     // =============================================================
914 
915     // The next token ID to be minted.
916     uint256 private _currentIndex;
917 
918     // The number of tokens burned.
919     uint256 private _burnCounter;
920 
921     // Token name
922     string private _name;
923 
924     // Token symbol
925     string private _symbol;
926 
927     // Mapping from token ID to ownership details
928     // An empty struct value does not necessarily mean the token is unowned.
929     // See {_packedOwnershipOf} implementation for details.
930     //
931     // Bits Layout:
932     // - [0..159]   `addr`
933     // - [160..223] `startTimestamp`
934     // - [224]      `burned`
935     // - [225]      `nextInitialized`
936     // - [232..255] `extraData`
937     mapping(uint256 => uint256) private _packedOwnerships;
938 
939     // Mapping owner address to address data.
940     //
941     // Bits Layout:
942     // - [0..63]    `balance`
943     // - [64..127]  `numberMinted`
944     // - [128..191] `numberBurned`
945     // - [192..255] `aux`
946     mapping(address => uint256) private _packedAddressData;
947 
948     // Mapping from token ID to approved address.
949     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
950 
951     // Mapping from owner to operator approvals
952     mapping(address => mapping(address => bool)) private _operatorApprovals;
953 
954     // =============================================================
955     //                          CONSTRUCTOR
956     // =============================================================
957 
958     constructor(string memory name_, string memory symbol_) {
959         _name = name_;
960         _symbol = symbol_;
961         _currentIndex = _startTokenId();
962     }
963 
964     // =============================================================
965     //                   TOKEN COUNTING OPERATIONS
966     // =============================================================
967 
968     /**
969      * @dev Returns the starting token ID.
970      * To change the starting token ID, please override this function.
971      */
972     function _startTokenId() internal view virtual returns (uint256) {
973         return 0;
974     }
975 
976     /**
977      * @dev Returns the next token ID to be minted.
978      */
979     function _nextTokenId() internal view virtual returns (uint256) {
980         return _currentIndex;
981     }
982 
983     /**
984      * @dev Returns the total number of tokens in existence.
985      * Burned tokens will reduce the count.
986      * To get the total number of tokens minted, please see {_totalMinted}.
987      */
988     function totalSupply() public view virtual override returns (uint256) {
989         // Counter underflow is impossible as _burnCounter cannot be incremented
990         // more than `_currentIndex - _startTokenId()` times.
991         unchecked {
992             return _currentIndex - _burnCounter - _startTokenId();
993         }
994     }
995 
996     /**
997      * @dev Returns the total amount of tokens minted in the contract.
998      */
999     function _totalMinted() internal view virtual returns (uint256) {
1000         // Counter underflow is impossible as `_currentIndex` does not decrement,
1001         // and it is initialized to `_startTokenId()`.
1002         unchecked {
1003             return _currentIndex - _startTokenId();
1004         }
1005     }
1006 
1007     /**
1008      * @dev Returns the total number of tokens burned.
1009      */
1010     function _totalBurned() internal view virtual returns (uint256) {
1011         return _burnCounter;
1012     }
1013 
1014     // =============================================================
1015     //                    ADDRESS DATA OPERATIONS
1016     // =============================================================
1017 
1018     /**
1019      * @dev Returns the number of tokens in `owner`'s account.
1020      */
1021     function balanceOf(address owner) public view virtual override returns (uint256) {
1022         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
1023         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1024     }
1025 
1026     /**
1027      * Returns the number of tokens minted by `owner`.
1028      */
1029     function _numberMinted(address owner) internal view returns (uint256) {
1030         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1031     }
1032 
1033     /**
1034      * Returns the number of tokens burned by or on behalf of `owner`.
1035      */
1036     function _numberBurned(address owner) internal view returns (uint256) {
1037         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1038     }
1039 
1040     /**
1041      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1042      */
1043     function _getAux(address owner) internal view returns (uint64) {
1044         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1045     }
1046 
1047     /**
1048      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1049      * If there are multiple variables, please pack them into a uint64.
1050      */
1051     function _setAux(address owner, uint64 aux) internal virtual {
1052         uint256 packed = _packedAddressData[owner];
1053         uint256 auxCasted;
1054         // Cast `aux` with assembly to avoid redundant masking.
1055         assembly {
1056             auxCasted := aux
1057         }
1058         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1059         _packedAddressData[owner] = packed;
1060     }
1061 
1062     // =============================================================
1063     //                            IERC165
1064     // =============================================================
1065 
1066     /**
1067      * @dev Returns true if this contract implements the interface defined by
1068      * `interfaceId`. See the corresponding
1069      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1070      * to learn more about how these ids are created.
1071      *
1072      * This function call must use less than 30000 gas.
1073      */
1074     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1075         // The interface IDs are constants representing the first 4 bytes
1076         // of the XOR of all function selectors in the interface.
1077         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1078         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1079         return
1080             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1081             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1082             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1083     }
1084 
1085     // =============================================================
1086     //                        IERC721Metadata
1087     // =============================================================
1088 
1089     /**
1090      * @dev Returns the token collection name.
1091      */
1092     function name() public view virtual override returns (string memory) {
1093         return _name;
1094     }
1095 
1096     /**
1097      * @dev Returns the token collection symbol.
1098      */
1099     function symbol() public view virtual override returns (string memory) {
1100         return _symbol;
1101     }
1102 
1103     /**
1104      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1105      */
1106     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1107         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
1108 
1109         string memory baseURI = _baseURI();
1110         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1111     }
1112 
1113     /**
1114      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1115      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1116      * by default, it can be overridden in child contracts.
1117      */
1118     function _baseURI() internal view virtual returns (string memory) {
1119         return '';
1120     }
1121 
1122     // =============================================================
1123     //                     OWNERSHIPS OPERATIONS
1124     // =============================================================
1125 
1126     /**
1127      * @dev Returns the owner of the `tokenId` token.
1128      *
1129      * Requirements:
1130      *
1131      * - `tokenId` must exist.
1132      */
1133     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1134         return address(uint160(_packedOwnershipOf(tokenId)));
1135     }
1136 
1137     /**
1138      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1139      * It gradually moves to O(1) as tokens get transferred around over time.
1140      */
1141     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1142         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1143     }
1144 
1145     /**
1146      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1147      */
1148     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1149         return _unpackedOwnership(_packedOwnerships[index]);
1150     }
1151 
1152     /**
1153      * @dev Returns whether the ownership slot at `index` is initialized.
1154      * An uninitialized slot does not necessarily mean that the slot has no owner.
1155      */
1156     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
1157         return _packedOwnerships[index] != 0;
1158     }
1159 
1160     /**
1161      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1162      */
1163     function _initializeOwnershipAt(uint256 index) internal virtual {
1164         if (_packedOwnerships[index] == 0) {
1165             _packedOwnerships[index] = _packedOwnershipOf(index);
1166         }
1167     }
1168 
1169     /**
1170      * Returns the packed ownership data of `tokenId`.
1171      */
1172     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1173         if (_startTokenId() <= tokenId) {
1174             packed = _packedOwnerships[tokenId];
1175             // If the data at the starting slot does not exist, start the scan.
1176             if (packed == 0) {
1177                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
1178                 // Invariant:
1179                 // There will always be an initialized ownership slot
1180                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1181                 // before an unintialized ownership slot
1182                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1183                 // Hence, `tokenId` will not underflow.
1184                 //
1185                 // We can directly compare the packed value.
1186                 // If the address is zero, packed will be zero.
1187                 for (;;) {
1188                     unchecked {
1189                         packed = _packedOwnerships[--tokenId];
1190                     }
1191                     if (packed == 0) continue;
1192                     if (packed & _BITMASK_BURNED == 0) return packed;
1193                     // Otherwise, the token is burned, and we must revert.
1194                     // This handles the case of batch burned tokens, where only the burned bit
1195                     // of the starting slot is set, and remaining slots are left uninitialized.
1196                     _revert(OwnerQueryForNonexistentToken.selector);
1197                 }
1198             }
1199             // Otherwise, the data exists and we can skip the scan.
1200             // This is possible because we have already achieved the target condition.
1201             // This saves 2143 gas on transfers of initialized tokens.
1202             // If the token is not burned, return `packed`. Otherwise, revert.
1203             if (packed & _BITMASK_BURNED == 0) return packed;
1204         }
1205         _revert(OwnerQueryForNonexistentToken.selector);
1206     }
1207 
1208     /**
1209      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1210      */
1211     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1212         ownership.addr = address(uint160(packed));
1213         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1214         ownership.burned = packed & _BITMASK_BURNED != 0;
1215         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1216     }
1217 
1218     /**
1219      * @dev Packs ownership data into a single uint256.
1220      */
1221     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1222         assembly {
1223             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1224             owner := and(owner, _BITMASK_ADDRESS)
1225             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1226             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1227         }
1228     }
1229 
1230     /**
1231      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1232      */
1233     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1234         // For branchless setting of the `nextInitialized` flag.
1235         assembly {
1236             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1237             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1238         }
1239     }
1240 
1241     // =============================================================
1242     //                      APPROVAL OPERATIONS
1243     // =============================================================
1244 
1245     /**
1246      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1247      *
1248      * Requirements:
1249      *
1250      * - The caller must own the token or be an approved operator.
1251      */
1252     function approve(address to, uint256 tokenId) public payable virtual override {
1253         _approve(to, tokenId, true);
1254     }
1255 
1256     /**
1257      * @dev Returns the account approved for `tokenId` token.
1258      *
1259      * Requirements:
1260      *
1261      * - `tokenId` must exist.
1262      */
1263     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1264         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
1265 
1266         return _tokenApprovals[tokenId].value;
1267     }
1268 
1269     /**
1270      * @dev Approve or remove `operator` as an operator for the caller.
1271      * Operators can call {transferFrom} or {safeTransferFrom}
1272      * for any token owned by the caller.
1273      *
1274      * Requirements:
1275      *
1276      * - The `operator` cannot be the caller.
1277      *
1278      * Emits an {ApprovalForAll} event.
1279      */
1280     function setApprovalForAll(address operator, bool approved) public virtual override {
1281         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1282         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1283     }
1284 
1285     /**
1286      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1287      *
1288      * See {setApprovalForAll}.
1289      */
1290     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1291         return _operatorApprovals[owner][operator];
1292     }
1293 
1294     /**
1295      * @dev Returns whether `tokenId` exists.
1296      *
1297      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1298      *
1299      * Tokens start existing when they are minted. See {_mint}.
1300      */
1301     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
1302         if (_startTokenId() <= tokenId) {
1303             if (tokenId < _currentIndex) {
1304                 uint256 packed;
1305                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
1306                 result = packed & _BITMASK_BURNED == 0;
1307             }
1308         }
1309     }
1310 
1311     /**
1312      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1313      */
1314     function _isSenderApprovedOrOwner(
1315         address approvedAddress,
1316         address owner,
1317         address msgSender
1318     ) private pure returns (bool result) {
1319         assembly {
1320             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1321             owner := and(owner, _BITMASK_ADDRESS)
1322             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1323             msgSender := and(msgSender, _BITMASK_ADDRESS)
1324             // `msgSender == owner || msgSender == approvedAddress`.
1325             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1326         }
1327     }
1328 
1329     /**
1330      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1331      */
1332     function _getApprovedSlotAndAddress(uint256 tokenId)
1333         private
1334         view
1335         returns (uint256 approvedAddressSlot, address approvedAddress)
1336     {
1337         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1338         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1339         assembly {
1340             approvedAddressSlot := tokenApproval.slot
1341             approvedAddress := sload(approvedAddressSlot)
1342         }
1343     }
1344 
1345     // =============================================================
1346     //                      TRANSFER OPERATIONS
1347     // =============================================================
1348 
1349     /**
1350      * @dev Transfers `tokenId` from `from` to `to`.
1351      *
1352      * Requirements:
1353      *
1354      * - `from` cannot be the zero address.
1355      * - `to` cannot be the zero address.
1356      * - `tokenId` token must be owned by `from`.
1357      * - If the caller is not `from`, it must be approved to move this token
1358      * by either {approve} or {setApprovalForAll}.
1359      *
1360      * Emits a {Transfer} event.
1361      */
1362     function transferFrom(
1363         address from,
1364         address to,
1365         uint256 tokenId
1366     ) public payable virtual override {
1367         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1368 
1369         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1370         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
1371 
1372         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
1373 
1374         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1375 
1376         // The nested ifs save around 20+ gas over a compound boolean condition.
1377         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1378             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1379 
1380         _beforeTokenTransfers(from, to, tokenId, 1);
1381 
1382         // Clear approvals from the previous owner.
1383         assembly {
1384             if approvedAddress {
1385                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1386                 sstore(approvedAddressSlot, 0)
1387             }
1388         }
1389 
1390         // Underflow of the sender's balance is impossible because we check for
1391         // ownership above and the recipient's balance can't realistically overflow.
1392         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1393         unchecked {
1394             // We can directly increment and decrement the balances.
1395             --_packedAddressData[from]; // Updates: `balance -= 1`.
1396             ++_packedAddressData[to]; // Updates: `balance += 1`.
1397 
1398             // Updates:
1399             // - `address` to the next owner.
1400             // - `startTimestamp` to the timestamp of transfering.
1401             // - `burned` to `false`.
1402             // - `nextInitialized` to `true`.
1403             _packedOwnerships[tokenId] = _packOwnershipData(
1404                 to,
1405                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1406             );
1407 
1408             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1409             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1410                 uint256 nextTokenId = tokenId + 1;
1411                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1412                 if (_packedOwnerships[nextTokenId] == 0) {
1413                     // If the next slot is within bounds.
1414                     if (nextTokenId != _currentIndex) {
1415                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1416                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1417                     }
1418                 }
1419             }
1420         }
1421 
1422         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1423         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1424         assembly {
1425             // Emit the `Transfer` event.
1426             log4(
1427                 0, // Start of data (0, since no data).
1428                 0, // End of data (0, since no data).
1429                 _TRANSFER_EVENT_SIGNATURE, // Signature.
1430                 from, // `from`.
1431                 toMasked, // `to`.
1432                 tokenId // `tokenId`.
1433             )
1434         }
1435         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
1436 
1437         _afterTokenTransfers(from, to, tokenId, 1);
1438     }
1439 
1440     /**
1441      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1442      */
1443     function safeTransferFrom(
1444         address from,
1445         address to,
1446         uint256 tokenId
1447     ) public payable virtual override {
1448         safeTransferFrom(from, to, tokenId, '');
1449     }
1450 
1451     /**
1452      * @dev Safely transfers `tokenId` token from `from` to `to`.
1453      *
1454      * Requirements:
1455      *
1456      * - `from` cannot be the zero address.
1457      * - `to` cannot be the zero address.
1458      * - `tokenId` token must exist and be owned by `from`.
1459      * - If the caller is not `from`, it must be approved to move this token
1460      * by either {approve} or {setApprovalForAll}.
1461      * - If `to` refers to a smart contract, it must implement
1462      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1463      *
1464      * Emits a {Transfer} event.
1465      */
1466     function safeTransferFrom(
1467         address from,
1468         address to,
1469         uint256 tokenId,
1470         bytes memory _data
1471     ) public payable virtual override {
1472         transferFrom(from, to, tokenId);
1473         if (to.code.length != 0)
1474             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1475                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1476             }
1477     }
1478 
1479     /**
1480      * @dev Hook that is called before a set of serially-ordered token IDs
1481      * are about to be transferred. This includes minting.
1482      * And also called before burning one token.
1483      *
1484      * `startTokenId` - the first token ID to be transferred.
1485      * `quantity` - the amount to be transferred.
1486      *
1487      * Calling conditions:
1488      *
1489      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1490      * transferred to `to`.
1491      * - When `from` is zero, `tokenId` will be minted for `to`.
1492      * - When `to` is zero, `tokenId` will be burned by `from`.
1493      * - `from` and `to` are never both zero.
1494      */
1495     function _beforeTokenTransfers(
1496         address from,
1497         address to,
1498         uint256 startTokenId,
1499         uint256 quantity
1500     ) internal virtual {}
1501 
1502     /**
1503      * @dev Hook that is called after a set of serially-ordered token IDs
1504      * have been transferred. This includes minting.
1505      * And also called after one token has been burned.
1506      *
1507      * `startTokenId` - the first token ID to be transferred.
1508      * `quantity` - the amount to be transferred.
1509      *
1510      * Calling conditions:
1511      *
1512      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1513      * transferred to `to`.
1514      * - When `from` is zero, `tokenId` has been minted for `to`.
1515      * - When `to` is zero, `tokenId` has been burned by `from`.
1516      * - `from` and `to` are never both zero.
1517      */
1518     function _afterTokenTransfers(
1519         address from,
1520         address to,
1521         uint256 startTokenId,
1522         uint256 quantity
1523     ) internal virtual {}
1524 
1525     /**
1526      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1527      *
1528      * `from` - Previous owner of the given token ID.
1529      * `to` - Target address that will receive the token.
1530      * `tokenId` - Token ID to be transferred.
1531      * `_data` - Optional data to send along with the call.
1532      *
1533      * Returns whether the call correctly returned the expected magic value.
1534      */
1535     function _checkContractOnERC721Received(
1536         address from,
1537         address to,
1538         uint256 tokenId,
1539         bytes memory _data
1540     ) private returns (bool) {
1541         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1542             bytes4 retval
1543         ) {
1544             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1545         } catch (bytes memory reason) {
1546             if (reason.length == 0) {
1547                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1548             }
1549             assembly {
1550                 revert(add(32, reason), mload(reason))
1551             }
1552         }
1553     }
1554 
1555     // =============================================================
1556     //                        MINT OPERATIONS
1557     // =============================================================
1558 
1559     /**
1560      * @dev Mints `quantity` tokens and transfers them to `to`.
1561      *
1562      * Requirements:
1563      *
1564      * - `to` cannot be the zero address.
1565      * - `quantity` must be greater than 0.
1566      *
1567      * Emits a {Transfer} event for each mint.
1568      */
1569     function _mint(address to, uint256 quantity) internal virtual {
1570         uint256 startTokenId = _currentIndex;
1571         if (quantity == 0) _revert(MintZeroQuantity.selector);
1572 
1573         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1574 
1575         // Overflows are incredibly unrealistic.
1576         // `balance` and `numberMinted` have a maximum limit of 2**64.
1577         // `tokenId` has a maximum limit of 2**256.
1578         unchecked {
1579             // Updates:
1580             // - `address` to the owner.
1581             // - `startTimestamp` to the timestamp of minting.
1582             // - `burned` to `false`.
1583             // - `nextInitialized` to `quantity == 1`.
1584             _packedOwnerships[startTokenId] = _packOwnershipData(
1585                 to,
1586                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1587             );
1588 
1589             // Updates:
1590             // - `balance += quantity`.
1591             // - `numberMinted += quantity`.
1592             //
1593             // We can directly add to the `balance` and `numberMinted`.
1594             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1595 
1596             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1597             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1598 
1599             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1600 
1601             uint256 end = startTokenId + quantity;
1602             uint256 tokenId = startTokenId;
1603 
1604             do {
1605                 assembly {
1606                     // Emit the `Transfer` event.
1607                     log4(
1608                         0, // Start of data (0, since no data).
1609                         0, // End of data (0, since no data).
1610                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1611                         0, // `address(0)`.
1612                         toMasked, // `to`.
1613                         tokenId // `tokenId`.
1614                     )
1615                 }
1616                 // The `!=` check ensures that large values of `quantity`
1617                 // that overflows uint256 will make the loop run out of gas.
1618             } while (++tokenId != end);
1619 
1620             _currentIndex = end;
1621         }
1622         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1623     }
1624 
1625     /**
1626      * @dev Mints `quantity` tokens and transfers them to `to`.
1627      *
1628      * This function is intended for efficient minting only during contract creation.
1629      *
1630      * It emits only one {ConsecutiveTransfer} as defined in
1631      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1632      * instead of a sequence of {Transfer} event(s).
1633      *
1634      * Calling this function outside of contract creation WILL make your contract
1635      * non-compliant with the ERC721 standard.
1636      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1637      * {ConsecutiveTransfer} event is only permissible during contract creation.
1638      *
1639      * Requirements:
1640      *
1641      * - `to` cannot be the zero address.
1642      * - `quantity` must be greater than 0.
1643      *
1644      * Emits a {ConsecutiveTransfer} event.
1645      */
1646     function _mintERC2309(address to, uint256 quantity) internal virtual {
1647         uint256 startTokenId = _currentIndex;
1648         if (to == address(0)) _revert(MintToZeroAddress.selector);
1649         if (quantity == 0) _revert(MintZeroQuantity.selector);
1650         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
1651 
1652         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1653 
1654         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1655         unchecked {
1656             // Updates:
1657             // - `balance += quantity`.
1658             // - `numberMinted += quantity`.
1659             //
1660             // We can directly add to the `balance` and `numberMinted`.
1661             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1662 
1663             // Updates:
1664             // - `address` to the owner.
1665             // - `startTimestamp` to the timestamp of minting.
1666             // - `burned` to `false`.
1667             // - `nextInitialized` to `quantity == 1`.
1668             _packedOwnerships[startTokenId] = _packOwnershipData(
1669                 to,
1670                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1671             );
1672 
1673             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1674 
1675             _currentIndex = startTokenId + quantity;
1676         }
1677         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1678     }
1679 
1680     /**
1681      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1682      *
1683      * Requirements:
1684      *
1685      * - If `to` refers to a smart contract, it must implement
1686      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1687      * - `quantity` must be greater than 0.
1688      *
1689      * See {_mint}.
1690      *
1691      * Emits a {Transfer} event for each mint.
1692      */
1693     function _safeMint(
1694         address to,
1695         uint256 quantity,
1696         bytes memory _data
1697     ) internal virtual {
1698         _mint(to, quantity);
1699 
1700         unchecked {
1701             if (to.code.length != 0) {
1702                 uint256 end = _currentIndex;
1703                 uint256 index = end - quantity;
1704                 do {
1705                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1706                         _revert(TransferToNonERC721ReceiverImplementer.selector);
1707                     }
1708                 } while (index < end);
1709                 // Reentrancy protection.
1710                 if (_currentIndex != end) _revert(bytes4(0));
1711             }
1712         }
1713     }
1714 
1715     /**
1716      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1717      */
1718     function _safeMint(address to, uint256 quantity) internal virtual {
1719         _safeMint(to, quantity, '');
1720     }
1721 
1722     // =============================================================
1723     //                       APPROVAL OPERATIONS
1724     // =============================================================
1725 
1726     /**
1727      * @dev Equivalent to `_approve(to, tokenId, false)`.
1728      */
1729     function _approve(address to, uint256 tokenId) internal virtual {
1730         _approve(to, tokenId, false);
1731     }
1732 
1733     /**
1734      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1735      * The approval is cleared when the token is transferred.
1736      *
1737      * Only a single account can be approved at a time, so approving the
1738      * zero address clears previous approvals.
1739      *
1740      * Requirements:
1741      *
1742      * - `tokenId` must exist.
1743      *
1744      * Emits an {Approval} event.
1745      */
1746     function _approve(
1747         address to,
1748         uint256 tokenId,
1749         bool approvalCheck
1750     ) internal virtual {
1751         address owner = ownerOf(tokenId);
1752 
1753         if (approvalCheck && _msgSenderERC721A() != owner)
1754             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1755                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
1756             }
1757 
1758         _tokenApprovals[tokenId].value = to;
1759         emit Approval(owner, to, tokenId);
1760     }
1761 
1762     // =============================================================
1763     //                        BURN OPERATIONS
1764     // =============================================================
1765 
1766     /**
1767      * @dev Equivalent to `_burn(tokenId, false)`.
1768      */
1769     function _burn(uint256 tokenId) internal virtual {
1770         _burn(tokenId, false);
1771     }
1772 
1773     /**
1774      * @dev Destroys `tokenId`.
1775      * The approval is cleared when the token is burned.
1776      *
1777      * Requirements:
1778      *
1779      * - `tokenId` must exist.
1780      *
1781      * Emits a {Transfer} event.
1782      */
1783     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1784         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1785 
1786         address from = address(uint160(prevOwnershipPacked));
1787 
1788         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1789 
1790         if (approvalCheck) {
1791             // The nested ifs save around 20+ gas over a compound boolean condition.
1792             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1793                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1794         }
1795 
1796         _beforeTokenTransfers(from, address(0), tokenId, 1);
1797 
1798         // Clear approvals from the previous owner.
1799         assembly {
1800             if approvedAddress {
1801                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1802                 sstore(approvedAddressSlot, 0)
1803             }
1804         }
1805 
1806         // Underflow of the sender's balance is impossible because we check for
1807         // ownership above and the recipient's balance can't realistically overflow.
1808         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1809         unchecked {
1810             // Updates:
1811             // - `balance -= 1`.
1812             // - `numberBurned += 1`.
1813             //
1814             // We can directly decrement the balance, and increment the number burned.
1815             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1816             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1817 
1818             // Updates:
1819             // - `address` to the last owner.
1820             // - `startTimestamp` to the timestamp of burning.
1821             // - `burned` to `true`.
1822             // - `nextInitialized` to `true`.
1823             _packedOwnerships[tokenId] = _packOwnershipData(
1824                 from,
1825                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1826             );
1827 
1828             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1829             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1830                 uint256 nextTokenId = tokenId + 1;
1831                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1832                 if (_packedOwnerships[nextTokenId] == 0) {
1833                     // If the next slot is within bounds.
1834                     if (nextTokenId != _currentIndex) {
1835                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1836                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1837                     }
1838                 }
1839             }
1840         }
1841 
1842         emit Transfer(from, address(0), tokenId);
1843         _afterTokenTransfers(from, address(0), tokenId, 1);
1844 
1845         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1846         unchecked {
1847             _burnCounter++;
1848         }
1849     }
1850 
1851     // =============================================================
1852     //                     EXTRA DATA OPERATIONS
1853     // =============================================================
1854 
1855     /**
1856      * @dev Directly sets the extra data for the ownership data `index`.
1857      */
1858     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1859         uint256 packed = _packedOwnerships[index];
1860         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
1861         uint256 extraDataCasted;
1862         // Cast `extraData` with assembly to avoid redundant masking.
1863         assembly {
1864             extraDataCasted := extraData
1865         }
1866         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1867         _packedOwnerships[index] = packed;
1868     }
1869 
1870     /**
1871      * @dev Called during each token transfer to set the 24bit `extraData` field.
1872      * Intended to be overridden by the cosumer contract.
1873      *
1874      * `previousExtraData` - the value of `extraData` before transfer.
1875      *
1876      * Calling conditions:
1877      *
1878      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1879      * transferred to `to`.
1880      * - When `from` is zero, `tokenId` will be minted for `to`.
1881      * - When `to` is zero, `tokenId` will be burned by `from`.
1882      * - `from` and `to` are never both zero.
1883      */
1884     function _extraData(
1885         address from,
1886         address to,
1887         uint24 previousExtraData
1888     ) internal view virtual returns (uint24) {}
1889 
1890     /**
1891      * @dev Returns the next extra data for the packed ownership data.
1892      * The returned result is shifted into position.
1893      */
1894     function _nextExtraData(
1895         address from,
1896         address to,
1897         uint256 prevOwnershipPacked
1898     ) private view returns (uint256) {
1899         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1900         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1901     }
1902 
1903     // =============================================================
1904     //                       OTHER OPERATIONS
1905     // =============================================================
1906 
1907     /**
1908      * @dev Returns the message sender (defaults to `msg.sender`).
1909      *
1910      * If you are writing GSN compatible contracts, you need to override this function.
1911      */
1912     function _msgSenderERC721A() internal view virtual returns (address) {
1913         return msg.sender;
1914     }
1915 
1916     /**
1917      * @dev Converts a uint256 to its ASCII string decimal representation.
1918      */
1919     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1920         assembly {
1921             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1922             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1923             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1924             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1925             let m := add(mload(0x40), 0xa0)
1926             // Update the free memory pointer to allocate.
1927             mstore(0x40, m)
1928             // Assign the `str` to the end.
1929             str := sub(m, 0x20)
1930             // Zeroize the slot after the string.
1931             mstore(str, 0)
1932 
1933             // Cache the end of the memory to calculate the length later.
1934             let end := str
1935 
1936             // We write the string from rightmost digit to leftmost digit.
1937             // The following is essentially a do-while loop that also handles the zero case.
1938             // prettier-ignore
1939             for { let temp := value } 1 {} {
1940                 str := sub(str, 1)
1941                 // Write the character to the pointer.
1942                 // The ASCII index of the '0' character is 48.
1943                 mstore8(str, add(48, mod(temp, 10)))
1944                 // Keep dividing `temp` until zero.
1945                 temp := div(temp, 10)
1946                 // prettier-ignore
1947                 if iszero(temp) { break }
1948             }
1949 
1950             let length := sub(end, str)
1951             // Move the pointer 32 bytes leftwards to make room for the length.
1952             str := sub(str, 0x20)
1953             // Store the length.
1954             mstore(str, length)
1955         }
1956     }
1957 
1958     /**
1959      * @dev For more efficient reverts.
1960      */
1961     function _revert(bytes4 errorSelector) internal pure {
1962         assembly {
1963             mstore(0x00, errorSelector)
1964             revert(0x00, 0x04)
1965         }
1966     }
1967 }
1968 
1969 // File: contracts/Downpour.sol
1970 
1971 
1972 pragma solidity ^0.8.17;
1973 
1974 
1975 
1976 
1977 contract DownpourByDDV is ERC721A, Ownable {
1978     using Strings for uint256;
1979     uint256 public maxSupply = 888;
1980     uint256 public maxFreeAmount = 888;
1981     uint256 public maxFreePerWallet = 1;
1982     uint256 public price = 0.0025 ether;
1983     uint256 public maxPerTx = 50;
1984     uint256 public maxPerWallet = 50;
1985     bool public mintEnabled = false;
1986     string public baseURI;
1987 
1988  constructor(
1989     string memory _name,
1990     string memory _symbol,
1991     string memory _initBaseURI
1992   ) ERC721A(_name,_symbol) {
1993         setBaseURI(_initBaseURI);
1994      
1995     }
1996   function  CommunityMint(uint256 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1997      uint256 totalSupply = uint256(totalSupply());
1998      uint totalAmount =   _amountPerAddress * addresses.length;
1999     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
2000      for (uint256 i = 0; i < addresses.length; i++) {
2001             _safeMint(addresses[i], _amountPerAddress);
2002         }
2003 
2004      delete _amountPerAddress;
2005      delete totalSupply;
2006   }
2007 
2008     function  publicMint(uint256 quantity) external payable  {
2009         require(mintEnabled, "Minting is not live yet.");
2010         require(totalSupply() + quantity < maxSupply + 1, "No more");
2011         uint256 cost = price;
2012         uint256 _maxPerWallet = maxPerWallet;
2013         
2014 
2015         if (
2016             totalSupply() < maxFreeAmount &&
2017             _numberMinted(msg.sender) == 0 &&
2018             quantity <= maxFreePerWallet
2019         ) {
2020             cost = 0;
2021             _maxPerWallet = maxFreePerWallet;
2022         }
2023 
2024         require(
2025             _numberMinted(msg.sender) + quantity <= _maxPerWallet,
2026             "Max per wallet"
2027         );
2028 
2029         uint256 needPayCount = quantity;
2030         if (_numberMinted(msg.sender) == 0) {
2031             needPayCount = quantity;
2032         }
2033         require(
2034             msg.value >= needPayCount * cost,
2035             "Please send the exact amount."
2036         );
2037         _safeMint(msg.sender, quantity);
2038     }
2039 
2040     function _baseURI() internal view virtual override returns (string memory) {
2041         return baseURI;
2042     }
2043 
2044     function tokenURI(
2045         uint256 tokenId
2046     ) public view virtual override returns (string memory) {
2047         require(
2048             _exists(tokenId),
2049             "ERC721Metadata: URI query for nonexistent token"
2050         );
2051         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2052     }
2053 
2054     function flipSale() external onlyOwner {
2055         mintEnabled = !mintEnabled;
2056     }
2057 
2058     function setBaseURI(string memory uri) public onlyOwner {
2059         baseURI = uri;
2060     }
2061 
2062     function setPrice(uint256 _newPrice) external onlyOwner {
2063         price = _newPrice;
2064     }
2065 
2066     function setMaxFreeAmount(uint256 _amount) external onlyOwner {
2067         maxFreeAmount = _amount;
2068     }
2069 
2070     function setMaxFreePerWallet(uint256 _amount) external onlyOwner {
2071         maxFreePerWallet = _amount;
2072     }
2073 
2074     function withdraw() external onlyOwner {
2075         (bool success, ) = payable(msg.sender).call{
2076             value: address(this).balance
2077         }("");
2078         require(success, "Transfer failed.");
2079     }
2080 }