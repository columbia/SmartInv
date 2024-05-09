1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/math/Math.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Standard math utilities missing in the Solidity language.
11  */
12 library Math {
13     enum Rounding {
14         Down, // Toward negative infinity
15         Up, // Toward infinity
16         Zero // Toward zero
17     }
18 
19     /**
20      * @dev Returns the largest of two numbers.
21      */
22     function max(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a > b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the smallest of two numbers.
28      */
29     function min(uint256 a, uint256 b) internal pure returns (uint256) {
30         return a < b ? a : b;
31     }
32 
33     /**
34      * @dev Returns the average of two numbers. The result is rounded towards
35      * zero.
36      */
37     function average(uint256 a, uint256 b) internal pure returns (uint256) {
38         // (a + b) / 2 can overflow.
39         return (a & b) + (a ^ b) / 2;
40     }
41 
42     /**
43      * @dev Returns the ceiling of the division of two numbers.
44      *
45      * This differs from standard division with `/` in that it rounds up instead
46      * of rounding down.
47      */
48     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
49         // (a + b - 1) / b can overflow on addition, so we distribute.
50         return a == 0 ? 0 : (a - 1) / b + 1;
51     }
52 
53     /**
54      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
55      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
56      * with further edits by Uniswap Labs also under MIT license.
57      */
58     function mulDiv(
59         uint256 x,
60         uint256 y,
61         uint256 denominator
62     ) internal pure returns (uint256 result) {
63         unchecked {
64             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
65             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
66             // variables such that product = prod1 * 2^256 + prod0.
67             uint256 prod0; // Least significant 256 bits of the product
68             uint256 prod1; // Most significant 256 bits of the product
69             assembly {
70                 let mm := mulmod(x, y, not(0))
71                 prod0 := mul(x, y)
72                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
73             }
74 
75             // Handle non-overflow cases, 256 by 256 division.
76             if (prod1 == 0) {
77                 return prod0 / denominator;
78             }
79 
80             // Make sure the result is less than 2^256. Also prevents denominator == 0.
81             require(denominator > prod1);
82 
83             ///////////////////////////////////////////////
84             // 512 by 256 division.
85             ///////////////////////////////////////////////
86 
87             // Make division exact by subtracting the remainder from [prod1 prod0].
88             uint256 remainder;
89             assembly {
90                 // Compute remainder using mulmod.
91                 remainder := mulmod(x, y, denominator)
92 
93                 // Subtract 256 bit number from 512 bit number.
94                 prod1 := sub(prod1, gt(remainder, prod0))
95                 prod0 := sub(prod0, remainder)
96             }
97 
98             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
99             // See https://cs.stackexchange.com/q/138556/92363.
100 
101             // Does not overflow because the denominator cannot be zero at this stage in the function.
102             uint256 twos = denominator & (~denominator + 1);
103             assembly {
104                 // Divide denominator by twos.
105                 denominator := div(denominator, twos)
106 
107                 // Divide [prod1 prod0] by twos.
108                 prod0 := div(prod0, twos)
109 
110                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
111                 twos := add(div(sub(0, twos), twos), 1)
112             }
113 
114             // Shift in bits from prod1 into prod0.
115             prod0 |= prod1 * twos;
116 
117             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
118             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
119             // four bits. That is, denominator * inv = 1 mod 2^4.
120             uint256 inverse = (3 * denominator) ^ 2;
121 
122             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
123             // in modular arithmetic, doubling the correct bits in each step.
124             inverse *= 2 - denominator * inverse; // inverse mod 2^8
125             inverse *= 2 - denominator * inverse; // inverse mod 2^16
126             inverse *= 2 - denominator * inverse; // inverse mod 2^32
127             inverse *= 2 - denominator * inverse; // inverse mod 2^64
128             inverse *= 2 - denominator * inverse; // inverse mod 2^128
129             inverse *= 2 - denominator * inverse; // inverse mod 2^256
130 
131             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
132             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
133             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
134             // is no longer required.
135             result = prod0 * inverse;
136             return result;
137         }
138     }
139 
140     /**
141      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
142      */
143     function mulDiv(
144         uint256 x,
145         uint256 y,
146         uint256 denominator,
147         Rounding rounding
148     ) internal pure returns (uint256) {
149         uint256 result = mulDiv(x, y, denominator);
150         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
151             result += 1;
152         }
153         return result;
154     }
155 
156     /**
157      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
158      *
159      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
160      */
161     function sqrt(uint256 a) internal pure returns (uint256) {
162         if (a == 0) {
163             return 0;
164         }
165 
166         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
167         //
168         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
169         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
170         //
171         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
172         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
173         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
174         //
175         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
176         uint256 result = 1 << (log2(a) >> 1);
177 
178         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
179         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
180         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
181         // into the expected uint128 result.
182         unchecked {
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             result = (result + a / result) >> 1;
190             return min(result, a / result);
191         }
192     }
193 
194     /**
195      * @notice Calculates sqrt(a), following the selected rounding direction.
196      */
197     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
198         unchecked {
199             uint256 result = sqrt(a);
200             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
201         }
202     }
203 
204     /**
205      * @dev Return the log in base 2, rounded down, of a positive value.
206      * Returns 0 if given 0.
207      */
208     function log2(uint256 value) internal pure returns (uint256) {
209         uint256 result = 0;
210         unchecked {
211             if (value >> 128 > 0) {
212                 value >>= 128;
213                 result += 128;
214             }
215             if (value >> 64 > 0) {
216                 value >>= 64;
217                 result += 64;
218             }
219             if (value >> 32 > 0) {
220                 value >>= 32;
221                 result += 32;
222             }
223             if (value >> 16 > 0) {
224                 value >>= 16;
225                 result += 16;
226             }
227             if (value >> 8 > 0) {
228                 value >>= 8;
229                 result += 8;
230             }
231             if (value >> 4 > 0) {
232                 value >>= 4;
233                 result += 4;
234             }
235             if (value >> 2 > 0) {
236                 value >>= 2;
237                 result += 2;
238             }
239             if (value >> 1 > 0) {
240                 result += 1;
241             }
242         }
243         return result;
244     }
245 
246     /**
247      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
248      * Returns 0 if given 0.
249      */
250     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
251         unchecked {
252             uint256 result = log2(value);
253             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
254         }
255     }
256 
257     /**
258      * @dev Return the log in base 10, rounded down, of a positive value.
259      * Returns 0 if given 0.
260      */
261     function log10(uint256 value) internal pure returns (uint256) {
262         uint256 result = 0;
263         unchecked {
264             if (value >= 10**64) {
265                 value /= 10**64;
266                 result += 64;
267             }
268             if (value >= 10**32) {
269                 value /= 10**32;
270                 result += 32;
271             }
272             if (value >= 10**16) {
273                 value /= 10**16;
274                 result += 16;
275             }
276             if (value >= 10**8) {
277                 value /= 10**8;
278                 result += 8;
279             }
280             if (value >= 10**4) {
281                 value /= 10**4;
282                 result += 4;
283             }
284             if (value >= 10**2) {
285                 value /= 10**2;
286                 result += 2;
287             }
288             if (value >= 10**1) {
289                 result += 1;
290             }
291         }
292         return result;
293     }
294 
295     /**
296      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
297      * Returns 0 if given 0.
298      */
299     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
300         unchecked {
301             uint256 result = log10(value);
302             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
303         }
304     }
305 
306     /**
307      * @dev Return the log in base 256, rounded down, of a positive value.
308      * Returns 0 if given 0.
309      *
310      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
311      */
312     function log256(uint256 value) internal pure returns (uint256) {
313         uint256 result = 0;
314         unchecked {
315             if (value >> 128 > 0) {
316                 value >>= 128;
317                 result += 16;
318             }
319             if (value >> 64 > 0) {
320                 value >>= 64;
321                 result += 8;
322             }
323             if (value >> 32 > 0) {
324                 value >>= 32;
325                 result += 4;
326             }
327             if (value >> 16 > 0) {
328                 value >>= 16;
329                 result += 2;
330             }
331             if (value >> 8 > 0) {
332                 result += 1;
333             }
334         }
335         return result;
336     }
337 
338     /**
339      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
340      * Returns 0 if given 0.
341      */
342     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
343         unchecked {
344             uint256 result = log256(value);
345             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
346         }
347     }
348 }
349 
350 // File: @openzeppelin/contracts/utils/Strings.sol
351 
352 
353 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev String operations.
360  */
361 library Strings {
362     bytes16 private constant _SYMBOLS = "0123456789abcdef";
363     uint8 private constant _ADDRESS_LENGTH = 20;
364 
365     /**
366      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
367      */
368     function toString(uint256 value) internal pure returns (string memory) {
369         unchecked {
370             uint256 length = Math.log10(value) + 1;
371             string memory buffer = new string(length);
372             uint256 ptr;
373             /// @solidity memory-safe-assembly
374             assembly {
375                 ptr := add(buffer, add(32, length))
376             }
377             while (true) {
378                 ptr--;
379                 /// @solidity memory-safe-assembly
380                 assembly {
381                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
382                 }
383                 value /= 10;
384                 if (value == 0) break;
385             }
386             return buffer;
387         }
388     }
389 
390     /**
391      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
392      */
393     function toHexString(uint256 value) internal pure returns (string memory) {
394         unchecked {
395             return toHexString(value, Math.log256(value) + 1);
396         }
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
401      */
402     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
403         bytes memory buffer = new bytes(2 * length + 2);
404         buffer[0] = "0";
405         buffer[1] = "x";
406         for (uint256 i = 2 * length + 1; i > 1; --i) {
407             buffer[i] = _SYMBOLS[value & 0xf];
408             value >>= 4;
409         }
410         require(value == 0, "Strings: hex length insufficient");
411         return string(buffer);
412     }
413 
414     /**
415      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
416      */
417     function toHexString(address addr) internal pure returns (string memory) {
418         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
419     }
420 }
421 
422 // File: @openzeppelin/contracts/utils/Context.sol
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev Provides information about the current execution context, including the
431  * sender of the transaction and its data. While these are generally available
432  * via msg.sender and msg.data, they should not be accessed in such a direct
433  * manner, since when dealing with meta-transactions the account sending and
434  * paying for execution may not be the actual sender (as far as an application
435  * is concerned).
436  *
437  * This contract is only required for intermediate, library-like contracts.
438  */
439 abstract contract Context {
440     function _msgSender() internal view virtual returns (address) {
441         return msg.sender;
442     }
443 
444     function _msgData() internal view virtual returns (bytes calldata) {
445         return msg.data;
446     }
447 }
448 
449 // File: @openzeppelin/contracts/access/Ownable.sol
450 
451 
452 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 
457 /**
458  * @dev Contract module which provides a basic access control mechanism, where
459  * there is an account (an owner) that can be granted exclusive access to
460  * specific functions.
461  *
462  * By default, the owner account will be the one that deploys the contract. This
463  * can later be changed with {transferOwnership}.
464  *
465  * This module is used through inheritance. It will make available the modifier
466  * `onlyOwner`, which can be applied to your functions to restrict their use to
467  * the owner.
468  */
469 abstract contract Ownable is Context {
470     address private _owner;
471 
472     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
473 
474     /**
475      * @dev Initializes the contract setting the deployer as the initial owner.
476      */
477     constructor() {
478         _transferOwnership(_msgSender());
479     }
480 
481     /**
482      * @dev Throws if called by any account other than the owner.
483      */
484     modifier onlyOwner() {
485         _checkOwner();
486         _;
487     }
488 
489     /**
490      * @dev Returns the address of the current owner.
491      */
492     function owner() public view virtual returns (address) {
493         return _owner;
494     }
495 
496     /**
497      * @dev Throws if the sender is not the owner.
498      */
499     function _checkOwner() internal view virtual {
500         require(owner() == _msgSender(), "Ownable: caller is not the owner");
501     }
502 
503     /**
504      * @dev Leaves the contract without owner. It will not be possible to call
505      * `onlyOwner` functions anymore. Can only be called by the current owner.
506      *
507      * NOTE: Renouncing ownership will leave the contract without an owner,
508      * thereby removing any functionality that is only available to the owner.
509      */
510     function renounceOwnership() public virtual onlyOwner {
511         _transferOwnership(address(0));
512     }
513 
514     /**
515      * @dev Transfers ownership of the contract to a new account (`newOwner`).
516      * Can only be called by the current owner.
517      */
518     function transferOwnership(address newOwner) public virtual onlyOwner {
519         require(newOwner != address(0), "Ownable: new owner is the zero address");
520         _transferOwnership(newOwner);
521     }
522 
523     /**
524      * @dev Transfers ownership of the contract to a new account (`newOwner`).
525      * Internal function without access restriction.
526      */
527     function _transferOwnership(address newOwner) internal virtual {
528         address oldOwner = _owner;
529         _owner = newOwner;
530         emit OwnershipTransferred(oldOwner, newOwner);
531     }
532 }
533 
534 // File: erc721a/contracts/IERC721A.sol
535 
536 
537 // ERC721A Contracts v4.2.3
538 // Creator: Chiru Labs
539 
540 pragma solidity ^0.8.4;
541 
542 /**
543  * @dev Interface of ERC721A.
544  */
545 interface IERC721A {
546     /**
547      * The caller must own the token or be an approved operator.
548      */
549     error ApprovalCallerNotOwnerNorApproved();
550 
551     /**
552      * The token does not exist.
553      */
554     error ApprovalQueryForNonexistentToken();
555 
556     /**
557      * Cannot query the balance for the zero address.
558      */
559     error BalanceQueryForZeroAddress();
560 
561     /**
562      * Cannot mint to the zero address.
563      */
564     error MintToZeroAddress();
565 
566     /**
567      * The quantity of tokens minted must be more than zero.
568      */
569     error MintZeroQuantity();
570 
571     /**
572      * The token does not exist.
573      */
574     error OwnerQueryForNonexistentToken();
575 
576     /**
577      * The caller must own the token or be an approved operator.
578      */
579     error TransferCallerNotOwnerNorApproved();
580 
581     /**
582      * The token must be owned by `from`.
583      */
584     error TransferFromIncorrectOwner();
585 
586     /**
587      * Cannot safely transfer to a contract that does not implement the
588      * ERC721Receiver interface.
589      */
590     error TransferToNonERC721ReceiverImplementer();
591 
592     /**
593      * Cannot transfer to the zero address.
594      */
595     error TransferToZeroAddress();
596 
597     /**
598      * The token does not exist.
599      */
600     error URIQueryForNonexistentToken();
601 
602     /**
603      * The `quantity` minted with ERC2309 exceeds the safety limit.
604      */
605     error MintERC2309QuantityExceedsLimit();
606 
607     /**
608      * The `extraData` cannot be set on an unintialized ownership slot.
609      */
610     error OwnershipNotInitializedForExtraData();
611 
612     // =============================================================
613     //                            STRUCTS
614     // =============================================================
615 
616     struct TokenOwnership {
617         // The address of the owner.
618         address addr;
619         // Stores the start time of ownership with minimal overhead for tokenomics.
620         uint64 startTimestamp;
621         // Whether the token has been burned.
622         bool burned;
623         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
624         uint24 extraData;
625     }
626 
627     // =============================================================
628     //                         TOKEN COUNTERS
629     // =============================================================
630 
631     /**
632      * @dev Returns the total number of tokens in existence.
633      * Burned tokens will reduce the count.
634      * To get the total number of tokens minted, please see {_totalMinted}.
635      */
636     function totalSupply() external view returns (uint256);
637 
638     // =============================================================
639     //                            IERC165
640     // =============================================================
641 
642     /**
643      * @dev Returns true if this contract implements the interface defined by
644      * `interfaceId`. See the corresponding
645      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
646      * to learn more about how these ids are created.
647      *
648      * This function call must use less than 30000 gas.
649      */
650     function supportsInterface(bytes4 interfaceId) external view returns (bool);
651 
652     // =============================================================
653     //                            IERC721
654     // =============================================================
655 
656     /**
657      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
658      */
659     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
660 
661     /**
662      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
663      */
664     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
665 
666     /**
667      * @dev Emitted when `owner` enables or disables
668      * (`approved`) `operator` to manage all of its assets.
669      */
670     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
671 
672     /**
673      * @dev Returns the number of tokens in `owner`'s account.
674      */
675     function balanceOf(address owner) external view returns (uint256 balance);
676 
677     /**
678      * @dev Returns the owner of the `tokenId` token.
679      *
680      * Requirements:
681      *
682      * - `tokenId` must exist.
683      */
684     function ownerOf(uint256 tokenId) external view returns (address owner);
685 
686     /**
687      * @dev Safely transfers `tokenId` token from `from` to `to`,
688      * checking first that contract recipients are aware of the ERC721 protocol
689      * to prevent tokens from being forever locked.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must exist and be owned by `from`.
696      * - If the caller is not `from`, it must be have been allowed to move
697      * this token by either {approve} or {setApprovalForAll}.
698      * - If `to` refers to a smart contract, it must implement
699      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
700      *
701      * Emits a {Transfer} event.
702      */
703     function safeTransferFrom(
704         address from,
705         address to,
706         uint256 tokenId,
707         bytes calldata data
708     ) external payable;
709 
710     /**
711      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 tokenId
717     ) external payable;
718 
719     /**
720      * @dev Transfers `tokenId` from `from` to `to`.
721      *
722      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
723      * whenever possible.
724      *
725      * Requirements:
726      *
727      * - `from` cannot be the zero address.
728      * - `to` cannot be the zero address.
729      * - `tokenId` token must be owned by `from`.
730      * - If the caller is not `from`, it must be approved to move this token
731      * by either {approve} or {setApprovalForAll}.
732      *
733      * Emits a {Transfer} event.
734      */
735     function transferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) external payable;
740 
741     /**
742      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
743      * The approval is cleared when the token is transferred.
744      *
745      * Only a single account can be approved at a time, so approving the
746      * zero address clears previous approvals.
747      *
748      * Requirements:
749      *
750      * - The caller must own the token or be an approved operator.
751      * - `tokenId` must exist.
752      *
753      * Emits an {Approval} event.
754      */
755     function approve(address to, uint256 tokenId) external payable;
756 
757     /**
758      * @dev Approve or remove `operator` as an operator for the caller.
759      * Operators can call {transferFrom} or {safeTransferFrom}
760      * for any token owned by the caller.
761      *
762      * Requirements:
763      *
764      * - The `operator` cannot be the caller.
765      *
766      * Emits an {ApprovalForAll} event.
767      */
768     function setApprovalForAll(address operator, bool _approved) external;
769 
770     /**
771      * @dev Returns the account approved for `tokenId` token.
772      *
773      * Requirements:
774      *
775      * - `tokenId` must exist.
776      */
777     function getApproved(uint256 tokenId) external view returns (address operator);
778 
779     /**
780      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
781      *
782      * See {setApprovalForAll}.
783      */
784     function isApprovedForAll(address owner, address operator) external view returns (bool);
785 
786     // =============================================================
787     //                        IERC721Metadata
788     // =============================================================
789 
790     /**
791      * @dev Returns the token collection name.
792      */
793     function name() external view returns (string memory);
794 
795     /**
796      * @dev Returns the token collection symbol.
797      */
798     function symbol() external view returns (string memory);
799 
800     /**
801      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
802      */
803     function tokenURI(uint256 tokenId) external view returns (string memory);
804 
805     // =============================================================
806     //                           IERC2309
807     // =============================================================
808 
809     /**
810      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
811      * (inclusive) is transferred from `from` to `to`, as defined in the
812      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
813      *
814      * See {_mintERC2309} for more details.
815      */
816     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
817 }
818 
819 // File: erc721a/contracts/ERC721A.sol
820 
821 
822 // ERC721A Contracts v4.2.3
823 // Creator: Chiru Labs
824 
825 pragma solidity ^0.8.4;
826 
827 
828 /**
829  * @dev Interface of ERC721 token receiver.
830  */
831 interface ERC721A__IERC721Receiver {
832     function onERC721Received(
833         address operator,
834         address from,
835         uint256 tokenId,
836         bytes calldata data
837     ) external returns (bytes4);
838 }
839 
840 /**
841  * @title ERC721A
842  *
843  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
844  * Non-Fungible Token Standard, including the Metadata extension.
845  * Optimized for lower gas during batch mints.
846  *
847  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
848  * starting from `_startTokenId()`.
849  *
850  * Assumptions:
851  *
852  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
853  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
854  */
855 contract ERC721A is IERC721A {
856     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
857     struct TokenApprovalRef {
858         address value;
859     }
860 
861     // =============================================================
862     //                           CONSTANTS
863     // =============================================================
864 
865     // Mask of an entry in packed address data.
866     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
867 
868     // The bit position of `numberMinted` in packed address data.
869     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
870 
871     // The bit position of `numberBurned` in packed address data.
872     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
873 
874     // The bit position of `aux` in packed address data.
875     uint256 private constant _BITPOS_AUX = 192;
876 
877     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
878     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
879 
880     // The bit position of `startTimestamp` in packed ownership.
881     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
882 
883     // The bit mask of the `burned` bit in packed ownership.
884     uint256 private constant _BITMASK_BURNED = 1 << 224;
885 
886     // The bit position of the `nextInitialized` bit in packed ownership.
887     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
888 
889     // The bit mask of the `nextInitialized` bit in packed ownership.
890     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
891 
892     // The bit position of `extraData` in packed ownership.
893     uint256 private constant _BITPOS_EXTRA_DATA = 232;
894 
895     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
896     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
897 
898     // The mask of the lower 160 bits for addresses.
899     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
900 
901     // The maximum `quantity` that can be minted with {_mintERC2309}.
902     // This limit is to prevent overflows on the address data entries.
903     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
904     // is required to cause an overflow, which is unrealistic.
905     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
906 
907     // The `Transfer` event signature is given by:
908     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
909     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
910         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
911 
912     // =============================================================
913     //                            STORAGE
914     // =============================================================
915 
916     // The next token ID to be minted.
917     uint256 private _currentIndex;
918 
919     // The number of tokens burned.
920     uint256 private _burnCounter;
921 
922     // Token name
923     string private _name;
924 
925     // Token symbol
926     string private _symbol;
927 
928     // Mapping from token ID to ownership details
929     // An empty struct value does not necessarily mean the token is unowned.
930     // See {_packedOwnershipOf} implementation for details.
931     //
932     // Bits Layout:
933     // - [0..159]   `addr`
934     // - [160..223] `startTimestamp`
935     // - [224]      `burned`
936     // - [225]      `nextInitialized`
937     // - [232..255] `extraData`
938     mapping(uint256 => uint256) private _packedOwnerships;
939 
940     // Mapping owner address to address data.
941     //
942     // Bits Layout:
943     // - [0..63]    `balance`
944     // - [64..127]  `numberMinted`
945     // - [128..191] `numberBurned`
946     // - [192..255] `aux`
947     mapping(address => uint256) private _packedAddressData;
948 
949     // Mapping from token ID to approved address.
950     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
951 
952     // Mapping from owner to operator approvals
953     mapping(address => mapping(address => bool)) private _operatorApprovals;
954 
955     // =============================================================
956     //                          CONSTRUCTOR
957     // =============================================================
958 
959     constructor(string memory name_, string memory symbol_) {
960         _name = name_;
961         _symbol = symbol_;
962         _currentIndex = _startTokenId();
963     }
964 
965     // =============================================================
966     //                   TOKEN COUNTING OPERATIONS
967     // =============================================================
968 
969     /**
970      * @dev Returns the starting token ID.
971      * To change the starting token ID, please override this function.
972      */
973     function _startTokenId() internal view virtual returns (uint256) {
974         return 1;
975     }
976 
977     /**
978      * @dev Returns the next token ID to be minted.
979      */
980     function _nextTokenId() internal view virtual returns (uint256) {
981         return _currentIndex;
982     }
983 
984     /**
985      * @dev Returns the total number of tokens in existence.
986      * Burned tokens will reduce the count.
987      * To get the total number of tokens minted, please see {_totalMinted}.
988      */
989     function totalSupply() public view virtual override returns (uint256) {
990         // Counter underflow is impossible as _burnCounter cannot be incremented
991         // more than `_currentIndex - _startTokenId()` times.
992         unchecked {
993             return _currentIndex - _burnCounter - _startTokenId();
994         }
995     }
996 
997     /**
998      * @dev Returns the total amount of tokens minted in the contract.
999      */
1000     function _totalMinted() internal view virtual returns (uint256) {
1001         // Counter underflow is impossible as `_currentIndex` does not decrement,
1002         // and it is initialized to `_startTokenId()`.
1003         unchecked {
1004             return _currentIndex - _startTokenId();
1005         }
1006     }
1007 
1008     /**
1009      * @dev Returns the total number of tokens burned.
1010      */
1011     function _totalBurned() internal view virtual returns (uint256) {
1012         return _burnCounter;
1013     }
1014 
1015     // =============================================================
1016     //                    ADDRESS DATA OPERATIONS
1017     // =============================================================
1018 
1019     /**
1020      * @dev Returns the number of tokens in `owner`'s account.
1021      */
1022     function balanceOf(address owner) public view virtual override returns (uint256) {
1023         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1024         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1025     }
1026 
1027     /**
1028      * Returns the number of tokens minted by `owner`.
1029      */
1030     function _numberMinted(address owner) internal view returns (uint256) {
1031         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1032     }
1033 
1034     /**
1035      * Returns the number of tokens burned by or on behalf of `owner`.
1036      */
1037     function _numberBurned(address owner) internal view returns (uint256) {
1038         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1039     }
1040 
1041     /**
1042      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1043      */
1044     function _getAux(address owner) internal view returns (uint64) {
1045         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1046     }
1047 
1048     /**
1049      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1050      * If there are multiple variables, please pack them into a uint64.
1051      */
1052     function _setAux(address owner, uint64 aux) internal virtual {
1053         uint256 packed = _packedAddressData[owner];
1054         uint256 auxCasted;
1055         // Cast `aux` with assembly to avoid redundant masking.
1056         assembly {
1057             auxCasted := aux
1058         }
1059         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1060         _packedAddressData[owner] = packed;
1061     }
1062 
1063     // =============================================================
1064     //                            IERC165
1065     // =============================================================
1066 
1067     /**
1068      * @dev Returns true if this contract implements the interface defined by
1069      * `interfaceId`. See the corresponding
1070      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1071      * to learn more about how these ids are created.
1072      *
1073      * This function call must use less than 30000 gas.
1074      */
1075     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1076         // The interface IDs are constants representing the first 4 bytes
1077         // of the XOR of all function selectors in the interface.
1078         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1079         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1080         return
1081             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1082             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1083             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1084     }
1085 
1086     // =============================================================
1087     //                        IERC721Metadata
1088     // =============================================================
1089 
1090     /**
1091      * @dev Returns the token collection name.
1092      */
1093     function name() public view virtual override returns (string memory) {
1094         return _name;
1095     }
1096 
1097     /**
1098      * @dev Returns the token collection symbol.
1099      */
1100     function symbol() public view virtual override returns (string memory) {
1101         return _symbol;
1102     }
1103 
1104     /**
1105      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1106      */
1107     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1108         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1109 
1110         string memory baseURI = _baseURI();
1111         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1112     }
1113 
1114     /**
1115      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1116      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1117      * by default, it can be overridden in child contracts.
1118      */
1119     function _baseURI() internal view virtual returns (string memory) {
1120         return '';
1121     }
1122 
1123     // =============================================================
1124     //                     OWNERSHIPS OPERATIONS
1125     // =============================================================
1126 
1127     /**
1128      * @dev Returns the owner of the `tokenId` token.
1129      *
1130      * Requirements:
1131      *
1132      * - `tokenId` must exist.
1133      */
1134     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1135         return address(uint160(_packedOwnershipOf(tokenId)));
1136     }
1137 
1138     /**
1139      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1140      * It gradually moves to O(1) as tokens get transferred around over time.
1141      */
1142     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1143         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1144     }
1145 
1146     /**
1147      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1148      */
1149     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1150         return _unpackedOwnership(_packedOwnerships[index]);
1151     }
1152 
1153     /**
1154      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1155      */
1156     function _initializeOwnershipAt(uint256 index) internal virtual {
1157         if (_packedOwnerships[index] == 0) {
1158             _packedOwnerships[index] = _packedOwnershipOf(index);
1159         }
1160     }
1161 
1162     /**
1163      * Returns the packed ownership data of `tokenId`.
1164      */
1165     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1166         uint256 curr = tokenId;
1167 
1168         unchecked {
1169             if (_startTokenId() <= curr)
1170                 if (curr < _currentIndex) {
1171                     uint256 packed = _packedOwnerships[curr];
1172                     // If not burned.
1173                     if (packed & _BITMASK_BURNED == 0) {
1174                         // Invariant:
1175                         // There will always be an initialized ownership slot
1176                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1177                         // before an unintialized ownership slot
1178                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1179                         // Hence, `curr` will not underflow.
1180                         //
1181                         // We can directly compare the packed value.
1182                         // If the address is zero, packed will be zero.
1183                         while (packed == 0) {
1184                             packed = _packedOwnerships[--curr];
1185                         }
1186                         return packed;
1187                     }
1188                 }
1189         }
1190         revert OwnerQueryForNonexistentToken();
1191     }
1192 
1193     /**
1194      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1195      */
1196     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1197         ownership.addr = address(uint160(packed));
1198         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1199         ownership.burned = packed & _BITMASK_BURNED != 0;
1200         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1201     }
1202 
1203     /**
1204      * @dev Packs ownership data into a single uint256.
1205      */
1206     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1207         assembly {
1208             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1209             owner := and(owner, _BITMASK_ADDRESS)
1210             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1211             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1212         }
1213     }
1214 
1215     /**
1216      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1217      */
1218     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1219         // For branchless setting of the `nextInitialized` flag.
1220         assembly {
1221             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1222             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1223         }
1224     }
1225 
1226     // =============================================================
1227     //                      APPROVAL OPERATIONS
1228     // =============================================================
1229 
1230     /**
1231      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1232      * The approval is cleared when the token is transferred.
1233      *
1234      * Only a single account can be approved at a time, so approving the
1235      * zero address clears previous approvals.
1236      *
1237      * Requirements:
1238      *
1239      * - The caller must own the token or be an approved operator.
1240      * - `tokenId` must exist.
1241      *
1242      * Emits an {Approval} event.
1243      */
1244     function approve(address to, uint256 tokenId) public payable virtual override {
1245         address owner = ownerOf(tokenId);
1246 
1247         if (_msgSenderERC721A() != owner)
1248             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1249                 revert ApprovalCallerNotOwnerNorApproved();
1250             }
1251 
1252         _tokenApprovals[tokenId].value = to;
1253         emit Approval(owner, to, tokenId);
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
1264         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
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
1301     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1302         return
1303             _startTokenId() <= tokenId &&
1304             tokenId < _currentIndex && // If within bounds,
1305             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1306     }
1307 
1308     /**
1309      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1310      */
1311     function _isSenderApprovedOrOwner(
1312         address approvedAddress,
1313         address owner,
1314         address msgSender
1315     ) private pure returns (bool result) {
1316         assembly {
1317             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1318             owner := and(owner, _BITMASK_ADDRESS)
1319             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1320             msgSender := and(msgSender, _BITMASK_ADDRESS)
1321             // `msgSender == owner || msgSender == approvedAddress`.
1322             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1323         }
1324     }
1325 
1326     /**
1327      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1328      */
1329     function _getApprovedSlotAndAddress(uint256 tokenId)
1330         private
1331         view
1332         returns (uint256 approvedAddressSlot, address approvedAddress)
1333     {
1334         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1335         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1336         assembly {
1337             approvedAddressSlot := tokenApproval.slot
1338             approvedAddress := sload(approvedAddressSlot)
1339         }
1340     }
1341 
1342     // =============================================================
1343     //                      TRANSFER OPERATIONS
1344     // =============================================================
1345 
1346     /**
1347      * @dev Transfers `tokenId` from `from` to `to`.
1348      *
1349      * Requirements:
1350      *
1351      * - `from` cannot be the zero address.
1352      * - `to` cannot be the zero address.
1353      * - `tokenId` token must be owned by `from`.
1354      * - If the caller is not `from`, it must be approved to move this token
1355      * by either {approve} or {setApprovalForAll}.
1356      *
1357      * Emits a {Transfer} event.
1358      */
1359     function transferFrom(
1360         address from,
1361         address to,
1362         uint256 tokenId
1363     ) public payable virtual override {
1364         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1365 
1366         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1367 
1368         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1369 
1370         // The nested ifs save around 20+ gas over a compound boolean condition.
1371         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1372             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1373 
1374         if (to == address(0)) revert TransferToZeroAddress();
1375 
1376         _beforeTokenTransfers(from, to, tokenId, 1);
1377 
1378         // Clear approvals from the previous owner.
1379         assembly {
1380             if approvedAddress {
1381                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1382                 sstore(approvedAddressSlot, 0)
1383             }
1384         }
1385 
1386         // Underflow of the sender's balance is impossible because we check for
1387         // ownership above and the recipient's balance can't realistically overflow.
1388         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1389         unchecked {
1390             // We can directly increment and decrement the balances.
1391             --_packedAddressData[from]; // Updates: `balance -= 1`.
1392             ++_packedAddressData[to]; // Updates: `balance += 1`.
1393 
1394             // Updates:
1395             // - `address` to the next owner.
1396             // - `startTimestamp` to the timestamp of transfering.
1397             // - `burned` to `false`.
1398             // - `nextInitialized` to `true`.
1399             _packedOwnerships[tokenId] = _packOwnershipData(
1400                 to,
1401                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1402             );
1403 
1404             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1405             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1406                 uint256 nextTokenId = tokenId + 1;
1407                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1408                 if (_packedOwnerships[nextTokenId] == 0) {
1409                     // If the next slot is within bounds.
1410                     if (nextTokenId != _currentIndex) {
1411                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1412                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1413                     }
1414                 }
1415             }
1416         }
1417 
1418         emit Transfer(from, to, tokenId);
1419         _afterTokenTransfers(from, to, tokenId, 1);
1420     }
1421 
1422     /**
1423      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1424      */
1425     function safeTransferFrom(
1426         address from,
1427         address to,
1428         uint256 tokenId
1429     ) public payable virtual override {
1430         safeTransferFrom(from, to, tokenId, '');
1431     }
1432 
1433     /**
1434      * @dev Safely transfers `tokenId` token from `from` to `to`.
1435      *
1436      * Requirements:
1437      *
1438      * - `from` cannot be the zero address.
1439      * - `to` cannot be the zero address.
1440      * - `tokenId` token must exist and be owned by `from`.
1441      * - If the caller is not `from`, it must be approved to move this token
1442      * by either {approve} or {setApprovalForAll}.
1443      * - If `to` refers to a smart contract, it must implement
1444      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1445      *
1446      * Emits a {Transfer} event.
1447      */
1448     function safeTransferFrom(
1449         address from,
1450         address to,
1451         uint256 tokenId,
1452         bytes memory _data
1453     ) public payable virtual override {
1454         transferFrom(from, to, tokenId);
1455         if (to.code.length != 0)
1456             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1457                 revert TransferToNonERC721ReceiverImplementer();
1458             }
1459     }
1460 
1461     /**
1462      * @dev Hook that is called before a set of serially-ordered token IDs
1463      * are about to be transferred. This includes minting.
1464      * And also called before burning one token.
1465      *
1466      * `startTokenId` - the first token ID to be transferred.
1467      * `quantity` - the amount to be transferred.
1468      *
1469      * Calling conditions:
1470      *
1471      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1472      * transferred to `to`.
1473      * - When `from` is zero, `tokenId` will be minted for `to`.
1474      * - When `to` is zero, `tokenId` will be burned by `from`.
1475      * - `from` and `to` are never both zero.
1476      */
1477     function _beforeTokenTransfers(
1478         address from,
1479         address to,
1480         uint256 startTokenId,
1481         uint256 quantity
1482     ) internal virtual {}
1483 
1484     /**
1485      * @dev Hook that is called after a set of serially-ordered token IDs
1486      * have been transferred. This includes minting.
1487      * And also called after one token has been burned.
1488      *
1489      * `startTokenId` - the first token ID to be transferred.
1490      * `quantity` - the amount to be transferred.
1491      *
1492      * Calling conditions:
1493      *
1494      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1495      * transferred to `to`.
1496      * - When `from` is zero, `tokenId` has been minted for `to`.
1497      * - When `to` is zero, `tokenId` has been burned by `from`.
1498      * - `from` and `to` are never both zero.
1499      */
1500     function _afterTokenTransfers(
1501         address from,
1502         address to,
1503         uint256 startTokenId,
1504         uint256 quantity
1505     ) internal virtual {}
1506 
1507     /**
1508      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1509      *
1510      * `from` - Previous owner of the given token ID.
1511      * `to` - Target address that will receive the token.
1512      * `tokenId` - Token ID to be transferred.
1513      * `_data` - Optional data to send along with the call.
1514      *
1515      * Returns whether the call correctly returned the expected magic value.
1516      */
1517     function _checkContractOnERC721Received(
1518         address from,
1519         address to,
1520         uint256 tokenId,
1521         bytes memory _data
1522     ) private returns (bool) {
1523         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1524             bytes4 retval
1525         ) {
1526             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1527         } catch (bytes memory reason) {
1528             if (reason.length == 0) {
1529                 revert TransferToNonERC721ReceiverImplementer();
1530             } else {
1531                 assembly {
1532                     revert(add(32, reason), mload(reason))
1533                 }
1534             }
1535         }
1536     }
1537 
1538     // =============================================================
1539     //                        MINT OPERATIONS
1540     // =============================================================
1541 
1542     /**
1543      * @dev Mints `quantity` tokens and transfers them to `to`.
1544      *
1545      * Requirements:
1546      *
1547      * - `to` cannot be the zero address.
1548      * - `quantity` must be greater than 0.
1549      *
1550      * Emits a {Transfer} event for each mint.
1551      */
1552     function _mint(address to, uint256 quantity) internal virtual {
1553         uint256 startTokenId = _currentIndex;
1554         if (quantity == 0) revert MintZeroQuantity();
1555 
1556         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1557 
1558         // Overflows are incredibly unrealistic.
1559         // `balance` and `numberMinted` have a maximum limit of 2**64.
1560         // `tokenId` has a maximum limit of 2**256.
1561         unchecked {
1562             // Updates:
1563             // - `balance += quantity`.
1564             // - `numberMinted += quantity`.
1565             //
1566             // We can directly add to the `balance` and `numberMinted`.
1567             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1568 
1569             // Updates:
1570             // - `address` to the owner.
1571             // - `startTimestamp` to the timestamp of minting.
1572             // - `burned` to `false`.
1573             // - `nextInitialized` to `quantity == 1`.
1574             _packedOwnerships[startTokenId] = _packOwnershipData(
1575                 to,
1576                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1577             );
1578 
1579             uint256 toMasked;
1580             uint256 end = startTokenId + quantity;
1581 
1582             // Use assembly to loop and emit the `Transfer` event for gas savings.
1583             // The duplicated `log4` removes an extra check and reduces stack juggling.
1584             // The assembly, together with the surrounding Solidity code, have been
1585             // delicately arranged to nudge the compiler into producing optimized opcodes.
1586             assembly {
1587                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1588                 toMasked := and(to, _BITMASK_ADDRESS)
1589                 // Emit the `Transfer` event.
1590                 log4(
1591                     0, // Start of data (0, since no data).
1592                     0, // End of data (0, since no data).
1593                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1594                     0, // `address(0)`.
1595                     toMasked, // `to`.
1596                     startTokenId // `tokenId`.
1597                 )
1598 
1599                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1600                 // that overflows uint256 will make the loop run out of gas.
1601                 // The compiler will optimize the `iszero` away for performance.
1602                 for {
1603                     let tokenId := add(startTokenId, 1)
1604                 } iszero(eq(tokenId, end)) {
1605                     tokenId := add(tokenId, 1)
1606                 } {
1607                     // Emit the `Transfer` event. Similar to above.
1608                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1609                 }
1610             }
1611             if (toMasked == 0) revert MintToZeroAddress();
1612 
1613             _currentIndex = end;
1614         }
1615         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1616     }
1617 
1618     /**
1619      * @dev Mints `quantity` tokens and transfers them to `to`.
1620      *
1621      * This function is intended for efficient minting only during contract creation.
1622      *
1623      * It emits only one {ConsecutiveTransfer} as defined in
1624      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1625      * instead of a sequence of {Transfer} event(s).
1626      *
1627      * Calling this function outside of contract creation WILL make your contract
1628      * non-compliant with the ERC721 standard.
1629      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1630      * {ConsecutiveTransfer} event is only permissible during contract creation.
1631      *
1632      * Requirements:
1633      *
1634      * - `to` cannot be the zero address.
1635      * - `quantity` must be greater than 0.
1636      *
1637      * Emits a {ConsecutiveTransfer} event.
1638      */
1639     function _mintERC2309(address to, uint256 quantity) internal virtual {
1640         uint256 startTokenId = _currentIndex;
1641         if (to == address(0)) revert MintToZeroAddress();
1642         if (quantity == 0) revert MintZeroQuantity();
1643         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1644 
1645         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1646 
1647         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1648         unchecked {
1649             // Updates:
1650             // - `balance += quantity`.
1651             // - `numberMinted += quantity`.
1652             //
1653             // We can directly add to the `balance` and `numberMinted`.
1654             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1655 
1656             // Updates:
1657             // - `address` to the owner.
1658             // - `startTimestamp` to the timestamp of minting.
1659             // - `burned` to `false`.
1660             // - `nextInitialized` to `quantity == 1`.
1661             _packedOwnerships[startTokenId] = _packOwnershipData(
1662                 to,
1663                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1664             );
1665 
1666             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1667 
1668             _currentIndex = startTokenId + quantity;
1669         }
1670         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1671     }
1672 
1673     /**
1674      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1675      *
1676      * Requirements:
1677      *
1678      * - If `to` refers to a smart contract, it must implement
1679      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1680      * - `quantity` must be greater than 0.
1681      *
1682      * See {_mint}.
1683      *
1684      * Emits a {Transfer} event for each mint.
1685      */
1686     function _safeMint(
1687         address to,
1688         uint256 quantity,
1689         bytes memory _data
1690     ) internal virtual {
1691         _mint(to, quantity);
1692 
1693         unchecked {
1694             if (to.code.length != 0) {
1695                 uint256 end = _currentIndex;
1696                 uint256 index = end - quantity;
1697                 do {
1698                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1699                         revert TransferToNonERC721ReceiverImplementer();
1700                     }
1701                 } while (index < end);
1702                 // Reentrancy protection.
1703                 if (_currentIndex != end) revert();
1704             }
1705         }
1706     }
1707 
1708     /**
1709      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1710      */
1711     function _safeMint(address to, uint256 quantity) internal virtual {
1712         _safeMint(to, quantity, '');
1713     }
1714 
1715     // =============================================================
1716     //                        BURN OPERATIONS
1717     // =============================================================
1718 
1719     /**
1720      * @dev Equivalent to `_burn(tokenId, false)`.
1721      */
1722     function _burn(uint256 tokenId) internal virtual {
1723         _burn(tokenId, false);
1724     }
1725 
1726     /**
1727      * @dev Destroys `tokenId`.
1728      * The approval is cleared when the token is burned.
1729      *
1730      * Requirements:
1731      *
1732      * - `tokenId` must exist.
1733      *
1734      * Emits a {Transfer} event.
1735      */
1736     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1737         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1738 
1739         address from = address(uint160(prevOwnershipPacked));
1740 
1741         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1742 
1743         if (approvalCheck) {
1744             // The nested ifs save around 20+ gas over a compound boolean condition.
1745             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1746                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1747         }
1748 
1749         _beforeTokenTransfers(from, address(0), tokenId, 1);
1750 
1751         // Clear approvals from the previous owner.
1752         assembly {
1753             if approvedAddress {
1754                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1755                 sstore(approvedAddressSlot, 0)
1756             }
1757         }
1758 
1759         // Underflow of the sender's balance is impossible because we check for
1760         // ownership above and the recipient's balance can't realistically overflow.
1761         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1762         unchecked {
1763             // Updates:
1764             // - `balance -= 1`.
1765             // - `numberBurned += 1`.
1766             //
1767             // We can directly decrement the balance, and increment the number burned.
1768             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1769             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1770 
1771             // Updates:
1772             // - `address` to the last owner.
1773             // - `startTimestamp` to the timestamp of burning.
1774             // - `burned` to `true`.
1775             // - `nextInitialized` to `true`.
1776             _packedOwnerships[tokenId] = _packOwnershipData(
1777                 from,
1778                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1779             );
1780 
1781             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1782             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1783                 uint256 nextTokenId = tokenId + 1;
1784                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1785                 if (_packedOwnerships[nextTokenId] == 0) {
1786                     // If the next slot is within bounds.
1787                     if (nextTokenId != _currentIndex) {
1788                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1789                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1790                     }
1791                 }
1792             }
1793         }
1794 
1795         emit Transfer(from, address(0), tokenId);
1796         _afterTokenTransfers(from, address(0), tokenId, 1);
1797 
1798         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1799         unchecked {
1800             _burnCounter++;
1801         }
1802     }
1803 
1804     // =============================================================
1805     //                     EXTRA DATA OPERATIONS
1806     // =============================================================
1807 
1808     /**
1809      * @dev Directly sets the extra data for the ownership data `index`.
1810      */
1811     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1812         uint256 packed = _packedOwnerships[index];
1813         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1814         uint256 extraDataCasted;
1815         // Cast `extraData` with assembly to avoid redundant masking.
1816         assembly {
1817             extraDataCasted := extraData
1818         }
1819         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1820         _packedOwnerships[index] = packed;
1821     }
1822 
1823     /**
1824      * @dev Called during each token transfer to set the 24bit `extraData` field.
1825      * Intended to be overridden by the cosumer contract.
1826      *
1827      * `previousExtraData` - the value of `extraData` before transfer.
1828      *
1829      * Calling conditions:
1830      *
1831      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1832      * transferred to `to`.
1833      * - When `from` is zero, `tokenId` will be minted for `to`.
1834      * - When `to` is zero, `tokenId` will be burned by `from`.
1835      * - `from` and `to` are never both zero.
1836      */
1837     function _extraData(
1838         address from,
1839         address to,
1840         uint24 previousExtraData
1841     ) internal view virtual returns (uint24) {}
1842 
1843     /**
1844      * @dev Returns the next extra data for the packed ownership data.
1845      * The returned result is shifted into position.
1846      */
1847     function _nextExtraData(
1848         address from,
1849         address to,
1850         uint256 prevOwnershipPacked
1851     ) private view returns (uint256) {
1852         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1853         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1854     }
1855 
1856     // =============================================================
1857     //                       OTHER OPERATIONS
1858     // =============================================================
1859 
1860     /**
1861      * @dev Returns the message sender (defaults to `msg.sender`).
1862      *
1863      * If you are writing GSN compatible contracts, you need to override this function.
1864      */
1865     function _msgSenderERC721A() internal view virtual returns (address) {
1866         return msg.sender;
1867     }
1868 
1869     /**
1870      * @dev Converts a uint256 to its ASCII string decimal representation.
1871      */
1872     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1873         assembly {
1874             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1875             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1876             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1877             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1878             let m := add(mload(0x40), 0xa0)
1879             // Update the free memory pointer to allocate.
1880             mstore(0x40, m)
1881             // Assign the `str` to the end.
1882             str := sub(m, 0x20)
1883             // Zeroize the slot after the string.
1884             mstore(str, 0)
1885 
1886             // Cache the end of the memory to calculate the length later.
1887             let end := str
1888 
1889             // We write the string from rightmost digit to leftmost digit.
1890             // The following is essentially a do-while loop that also handles the zero case.
1891             // prettier-ignore
1892             for { let temp := value } 1 {} {
1893                 str := sub(str, 1)
1894                 // Write the character to the pointer.
1895                 // The ASCII index of the '0' character is 48.
1896                 mstore8(str, add(48, mod(temp, 10)))
1897                 // Keep dividing `temp` until zero.
1898                 temp := div(temp, 10)
1899                 // prettier-ignore
1900                 if iszero(temp) { break }
1901             }
1902 
1903             let length := sub(end, str)
1904             // Move the pointer 32 bytes leftwards to make room for the length.
1905             str := sub(str, 0x20)
1906             // Store the length.
1907             mstore(str, length)
1908         }
1909     }
1910 }
1911 
1912 // File: contracts/TateBrothers.sol
1913 
1914 
1915 
1916 pragma solidity 0.8.18;
1917 
1918 
1919 
1920 
1921 contract TateBrothers is ERC721A, Ownable {
1922     error Paused();
1923     error InsufficientFunds();
1924     error ExceedsMaxSupply();
1925     error ExceedsMaxPerUser();
1926     using Strings for uint256;
1927 
1928     uint256 public _mintPrice = 0.0025 ether;
1929     uint256 public _maxMintPerWallet = 30;
1930     uint256 public _maxTokens = 10000;
1931     bool public _paused = true;
1932     string private baseURI;
1933     string private _baseExtension = ".json";
1934     mapping(address => uint256) public _walletMintedCount;
1935 
1936     constructor(
1937         string memory _name,
1938         string memory _symbol,
1939         string memory _initBaseURI
1940     ) ERC721A(_name, _symbol) {
1941         setBaseURI(_initBaseURI);
1942     }
1943 
1944     // internal
1945     function _baseURI() internal view virtual override returns (string memory) {
1946         return baseURI;
1947     }
1948 
1949     // public mint
1950     function mint(uint256 _quantity) external payable {
1951         if (_paused) revert Paused();
1952         if (totalSupply() + _quantity > _maxTokens) revert ExceedsMaxSupply();
1953 
1954         if (msg.sender != owner()) {
1955             uint256 userMints = _walletMintedCount[msg.sender];
1956             if (_quantity + userMints > _maxMintPerWallet)
1957                 revert ExceedsMaxPerUser();
1958 
1959             if (userMints == 0) {
1960                 if (msg.value < (_quantity - 1) * _mintPrice)
1961                     revert InsufficientFunds();
1962             } else {
1963                 if (msg.value < _quantity * _mintPrice)
1964                     revert InsufficientFunds();
1965             }
1966         }
1967 
1968         _walletMintedCount[msg.sender] += _quantity;
1969         _safeMint(msg.sender, _quantity);
1970     }
1971 
1972     function tokenURI(uint256 tokenId)
1973         public
1974         view
1975         virtual
1976         override
1977         returns (string memory)
1978     {
1979         require(
1980             _exists(tokenId),
1981             "ERC721Metadata: URI query for nonexistent token"
1982         );
1983 
1984         string memory currentBaseURI = _baseURI();
1985         return
1986             bytes(currentBaseURI).length > 0
1987                 ? string(
1988                     abi.encodePacked(
1989                         currentBaseURI,
1990                         tokenId.toString(),
1991                         _baseExtension
1992                     )
1993                 )
1994                 : "";
1995     }
1996 
1997     //only owner
1998     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1999         baseURI = _newBaseURI;
2000     }
2001 
2002     function setBaseExtension(string memory _newBaseExtension)
2003         external
2004         onlyOwner
2005     {
2006         _baseExtension = _newBaseExtension;
2007     }
2008 
2009     function setMaxTokens(uint256 _newMaxTokens) external onlyOwner {
2010         _maxTokens = _newMaxTokens;
2011     }
2012 
2013     function setMintPrice(uint256 _newMintPrice) external onlyOwner {
2014         _mintPrice = _newMintPrice;
2015     }
2016 
2017     function setMaxMintPerWallet(uint256 _newMaxMintPerWallet)
2018         external
2019         onlyOwner
2020     {
2021         _maxMintPerWallet = _newMaxMintPerWallet;
2022     }
2023 
2024     function pause(bool _state) external onlyOwner {
2025         _paused = _state;
2026     }
2027 
2028     function withdrawAll() external onlyOwner {
2029         uint256 balance = address(this).balance;
2030 
2031         (bool os, ) = payable(owner()).call{value: balance}("");
2032         require(os, "Withdrawal failed");
2033     }
2034 }