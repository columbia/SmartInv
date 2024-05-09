1 //                                                  
2 //   _____ _____ ___          ___ _____ _   _ ______
3 //  |  ___|_____) _ \   /\   (   )  ___) \ | (___  /
4 //  | |_    ___| | | | /  \   | || |_  |  \| |  / / 
5 //  |  _)  (___) | | |/ /\ \  | ||  _) |     | / /  
6 //  | |___ ____| |_| / /  \ \ | || |___| |\  |/ /__ 
7 //  |_____|_____)___/_/    \_(___)_____)_| \_/_____)
8 //                                                  
9 //   
10 
11 
12 // File: @openzeppelin/contracts/utils/math/Math.sol
13 
14 
15 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/math/Math.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Standard math utilities missing in the Solidity language.
21  */
22 library Math {
23     enum Rounding {
24         Down, // Toward negative infinity
25         Up, // Toward infinity
26         Zero // Toward zero
27     }
28 
29     /**
30      * @dev Returns the largest of two numbers.
31      */
32     function max(uint256 a, uint256 b) internal pure returns (uint256) {
33         return a > b ? a : b;
34     }
35 
36     /**
37      * @dev Returns the smallest of two numbers.
38      */
39     function min(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a < b ? a : b;
41     }
42 
43     /**
44      * @dev Returns the average of two numbers. The result is rounded towards
45      * zero.
46      */
47     function average(uint256 a, uint256 b) internal pure returns (uint256) {
48         // (a + b) / 2 can overflow.
49         return (a & b) + (a ^ b) / 2;
50     }
51 
52     /**
53      * @dev Returns the ceiling of the division of two numbers.
54      *
55      * This differs from standard division with `/` in that it rounds up instead
56      * of rounding down.
57      */
58     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
59         // (a + b - 1) / b can overflow on addition, so we distribute.
60         return a == 0 ? 0 : (a - 1) / b + 1;
61     }
62 
63     /**
64      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
65      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
66      * with further edits by Uniswap Labs also under MIT license.
67      */
68     function mulDiv(
69         uint256 x,
70         uint256 y,
71         uint256 denominator
72     ) internal pure returns (uint256 result) {
73         unchecked {
74             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
75             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
76             // variables such that product = prod1 * 2^256 + prod0.
77             uint256 prod0; // Least significant 256 bits of the product
78             uint256 prod1; // Most significant 256 bits of the product
79             assembly {
80                 let mm := mulmod(x, y, not(0))
81                 prod0 := mul(x, y)
82                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
83             }
84 
85             // Handle non-overflow cases, 256 by 256 division.
86             if (prod1 == 0) {
87                 return prod0 / denominator;
88             }
89 
90             // Make sure the result is less than 2^256. Also prevents denominator == 0.
91             require(denominator > prod1);
92 
93             ///////////////////////////////////////////////
94             // 512 by 256 division.
95             ///////////////////////////////////////////////
96 
97             // Make division exact by subtracting the remainder from [prod1 prod0].
98             uint256 remainder;
99             assembly {
100                 // Compute remainder using mulmod.
101                 remainder := mulmod(x, y, denominator)
102 
103                 // Subtract 256 bit number from 512 bit number.
104                 prod1 := sub(prod1, gt(remainder, prod0))
105                 prod0 := sub(prod0, remainder)
106             }
107 
108             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
109             // See https://cs.stackexchange.com/q/138556/92363.
110 
111             // Does not overflow because the denominator cannot be zero at this stage in the function.
112             uint256 twos = denominator & (~denominator + 1);
113             assembly {
114                 // Divide denominator by twos.
115                 denominator := div(denominator, twos)
116 
117                 // Divide [prod1 prod0] by twos.
118                 prod0 := div(prod0, twos)
119 
120                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
121                 twos := add(div(sub(0, twos), twos), 1)
122             }
123 
124             // Shift in bits from prod1 into prod0.
125             prod0 |= prod1 * twos;
126 
127             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
128             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
129             // four bits. That is, denominator * inv = 1 mod 2^4.
130             uint256 inverse = (3 * denominator) ^ 2;
131 
132             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
133             // in modular arithmetic, doubling the correct bits in each step.
134             inverse *= 2 - denominator * inverse; // inverse mod 2^8
135             inverse *= 2 - denominator * inverse; // inverse mod 2^16
136             inverse *= 2 - denominator * inverse; // inverse mod 2^32
137             inverse *= 2 - denominator * inverse; // inverse mod 2^64
138             inverse *= 2 - denominator * inverse; // inverse mod 2^128
139             inverse *= 2 - denominator * inverse; // inverse mod 2^256
140 
141             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
142             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
143             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
144             // is no longer required.
145             result = prod0 * inverse;
146             return result;
147         }
148     }
149 
150     /**
151      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
152      */
153     function mulDiv(
154         uint256 x,
155         uint256 y,
156         uint256 denominator,
157         Rounding rounding
158     ) internal pure returns (uint256) {
159         uint256 result = mulDiv(x, y, denominator);
160         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
161             result += 1;
162         }
163         return result;
164     }
165 
166     /**
167      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
168      *
169      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
170      */
171     function sqrt(uint256 a) internal pure returns (uint256) {
172         if (a == 0) {
173             return 0;
174         }
175 
176         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
177         //
178         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
179         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
180         //
181         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
182         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
183         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
184         //
185         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
186         uint256 result = 1 << (log2(a) >> 1);
187 
188         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
189         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
190         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
191         // into the expected uint128 result.
192         unchecked {
193             result = (result + a / result) >> 1;
194             result = (result + a / result) >> 1;
195             result = (result + a / result) >> 1;
196             result = (result + a / result) >> 1;
197             result = (result + a / result) >> 1;
198             result = (result + a / result) >> 1;
199             result = (result + a / result) >> 1;
200             return min(result, a / result);
201         }
202     }
203 
204     /**
205      * @notice Calculates sqrt(a), following the selected rounding direction.
206      */
207     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
208         unchecked {
209             uint256 result = sqrt(a);
210             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
211         }
212     }
213 
214     /**
215      * @dev Return the log in base 2, rounded down, of a positive value.
216      * Returns 0 if given 0.
217      */
218     function log2(uint256 value) internal pure returns (uint256) {
219         uint256 result = 0;
220         unchecked {
221             if (value >> 128 > 0) {
222                 value >>= 128;
223                 result += 128;
224             }
225             if (value >> 64 > 0) {
226                 value >>= 64;
227                 result += 64;
228             }
229             if (value >> 32 > 0) {
230                 value >>= 32;
231                 result += 32;
232             }
233             if (value >> 16 > 0) {
234                 value >>= 16;
235                 result += 16;
236             }
237             if (value >> 8 > 0) {
238                 value >>= 8;
239                 result += 8;
240             }
241             if (value >> 4 > 0) {
242                 value >>= 4;
243                 result += 4;
244             }
245             if (value >> 2 > 0) {
246                 value >>= 2;
247                 result += 2;
248             }
249             if (value >> 1 > 0) {
250                 result += 1;
251             }
252         }
253         return result;
254     }
255 
256     /**
257      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
258      * Returns 0 if given 0.
259      */
260     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
261         unchecked {
262             uint256 result = log2(value);
263             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
264         }
265     }
266 
267     /**
268      * @dev Return the log in base 10, rounded down, of a positive value.
269      * Returns 0 if given 0.
270      */
271     function log10(uint256 value) internal pure returns (uint256) {
272         uint256 result = 0;
273         unchecked {
274             if (value >= 10**64) {
275                 value /= 10**64;
276                 result += 64;
277             }
278             if (value >= 10**32) {
279                 value /= 10**32;
280                 result += 32;
281             }
282             if (value >= 10**16) {
283                 value /= 10**16;
284                 result += 16;
285             }
286             if (value >= 10**8) {
287                 value /= 10**8;
288                 result += 8;
289             }
290             if (value >= 10**4) {
291                 value /= 10**4;
292                 result += 4;
293             }
294             if (value >= 10**2) {
295                 value /= 10**2;
296                 result += 2;
297             }
298             if (value >= 10**1) {
299                 result += 1;
300             }
301         }
302         return result;
303     }
304 
305     /**
306      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
307      * Returns 0 if given 0.
308      */
309     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
310         unchecked {
311             uint256 result = log10(value);
312             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
313         }
314     }
315 
316     /**
317      * @dev Return the log in base 256, rounded down, of a positive value.
318      * Returns 0 if given 0.
319      *
320      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
321      */
322     function log256(uint256 value) internal pure returns (uint256) {
323         uint256 result = 0;
324         unchecked {
325             if (value >> 128 > 0) {
326                 value >>= 128;
327                 result += 16;
328             }
329             if (value >> 64 > 0) {
330                 value >>= 64;
331                 result += 8;
332             }
333             if (value >> 32 > 0) {
334                 value >>= 32;
335                 result += 4;
336             }
337             if (value >> 16 > 0) {
338                 value >>= 16;
339                 result += 2;
340             }
341             if (value >> 8 > 0) {
342                 result += 1;
343             }
344         }
345         return result;
346     }
347 
348     /**
349      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
350      * Returns 0 if given 0.
351      */
352     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
353         unchecked {
354             uint256 result = log256(value);
355             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
356         }
357     }
358 }
359 
360 // File: @openzeppelin/contracts/utils/Strings.sol
361 
362 
363 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/Strings.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 
368 /**
369  * @dev String operations.
370  */
371 library Strings {
372     bytes16 private constant _SYMBOLS = "0123456789abcdef";
373     uint8 private constant _ADDRESS_LENGTH = 20;
374 
375     /**
376      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
377      */
378     function toString(uint256 value) internal pure returns (string memory) {
379         unchecked {
380             uint256 length = Math.log10(value) + 1;
381             string memory buffer = new string(length);
382             uint256 ptr;
383             /// @solidity memory-safe-assembly
384             assembly {
385                 ptr := add(buffer, add(32, length))
386             }
387             while (true) {
388                 ptr--;
389                 /// @solidity memory-safe-assembly
390                 assembly {
391                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
392                 }
393                 value /= 10;
394                 if (value == 0) break;
395             }
396             return buffer;
397         }
398     }
399 
400     /**
401      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
402      */
403     function toHexString(uint256 value) internal pure returns (string memory) {
404         unchecked {
405             return toHexString(value, Math.log256(value) + 1);
406         }
407     }
408 
409     /**
410      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
411      */
412     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
413         bytes memory buffer = new bytes(2 * length + 2);
414         buffer[0] = "0";
415         buffer[1] = "x";
416         for (uint256 i = 2 * length + 1; i > 1; --i) {
417             buffer[i] = _SYMBOLS[value & 0xf];
418             value >>= 4;
419         }
420         require(value == 0, "Strings: hex length insufficient");
421         return string(buffer);
422     }
423 
424     /**
425      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
426      */
427     function toHexString(address addr) internal pure returns (string memory) {
428         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
429     }
430 }
431 
432 // File: @openzeppelin/contracts/utils/Context.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Provides information about the current execution context, including the
441  * sender of the transaction and its data. While these are generally available
442  * via msg.sender and msg.data, they should not be accessed in such a direct
443  * manner, since when dealing with meta-transactions the account sending and
444  * paying for execution may not be the actual sender (as far as an application
445  * is concerned).
446  *
447  * This contract is only required for intermediate, library-like contracts.
448  */
449 abstract contract Context {
450     function _msgSender() internal view virtual returns (address) {
451         return msg.sender;
452     }
453 
454     function _msgData() internal view virtual returns (bytes calldata) {
455         return msg.data;
456     }
457 }
458 
459 // File: @openzeppelin/contracts/access/Ownable.sol
460 
461 
462 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Contract module which provides a basic access control mechanism, where
469  * there is an account (an owner) that can be granted exclusive access to
470  * specific functions.
471  *
472  * By default, the owner account will be the one that deploys the contract. This
473  * can later be changed with {transferOwnership}.
474  *
475  * This module is used through inheritance. It will make available the modifier
476  * `onlyOwner`, which can be applied to your functions to restrict their use to
477  * the owner.
478  */
479 abstract contract Ownable is Context {
480     address private _owner;
481 
482     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
483 
484     /**
485      * @dev Initializes the contract setting the deployer as the initial owner.
486      */
487     constructor() {
488         _transferOwnership(_msgSender());
489     }
490 
491     /**
492      * @dev Throws if called by any account other than the owner.
493      */
494     modifier onlyOwner() {
495         _checkOwner();
496         _;
497     }
498 
499     /**
500      * @dev Returns the address of the current owner.
501      */
502     function owner() public view virtual returns (address) {
503         return _owner;
504     }
505 
506     /**
507      * @dev Throws if the sender is not the owner.
508      */
509     function _checkOwner() internal view virtual {
510         require(owner() == _msgSender(), "Ownable: caller is not the owner");
511     }
512 
513     /**
514      * @dev Leaves the contract without owner. It will not be possible to call
515      * `onlyOwner` functions anymore. Can only be called by the current owner.
516      *
517      * NOTE: Renouncing ownership will leave the contract without an owner,
518      * thereby removing any functionality that is only available to the owner.
519      */
520     function renounceOwnership() public virtual onlyOwner {
521         _transferOwnership(address(0));
522     }
523 
524     /**
525      * @dev Transfers ownership of the contract to a new account (`newOwner`).
526      * Can only be called by the current owner.
527      */
528     function transferOwnership(address newOwner) public virtual onlyOwner {
529         require(newOwner != address(0), "Ownable: new owner is the zero address");
530         _transferOwnership(newOwner);
531     }
532 
533     /**
534      * @dev Transfers ownership of the contract to a new account (`newOwner`).
535      * Internal function without access restriction.
536      */
537     function _transferOwnership(address newOwner) internal virtual {
538         address oldOwner = _owner;
539         _owner = newOwner;
540         emit OwnershipTransferred(oldOwner, newOwner);
541     }
542 }
543 
544 // File: erc721a/contracts/IERC721A.sol
545 
546 
547 // ERC721A Contracts v4.2.3
548 // Creator: Chiru Labs
549 
550 pragma solidity ^0.8.4;
551 
552 /**
553  * @dev Interface of ERC721A.
554  */
555 interface IERC721A {
556     /**
557      * The caller must own the token or be an approved operator.
558      */
559     error ApprovalCallerNotOwnerNorApproved();
560 
561     /**
562      * The token does not exist.
563      */
564     error ApprovalQueryForNonexistentToken();
565 
566     /**
567      * Cannot query the balance for the zero address.
568      */
569     error BalanceQueryForZeroAddress();
570 
571     /**
572      * Cannot mint to the zero address.
573      */
574     error MintToZeroAddress();
575 
576     /**
577      * The quantity of tokens minted must be more than zero.
578      */
579     error MintZeroQuantity();
580 
581     /**
582      * The token does not exist.
583      */
584     error OwnerQueryForNonexistentToken();
585 
586     /**
587      * The caller must own the token or be an approved operator.
588      */
589     error TransferCallerNotOwnerNorApproved();
590 
591     /**
592      * The token must be owned by `from`.
593      */
594     error TransferFromIncorrectOwner();
595 
596     /**
597      * Cannot safely transfer to a contract that does not implement the
598      * ERC721Receiver interface.
599      */
600     error TransferToNonERC721ReceiverImplementer();
601 
602     /**
603      * Cannot transfer to the zero address.
604      */
605     error TransferToZeroAddress();
606 
607     /**
608      * The token does not exist.
609      */
610     error URIQueryForNonexistentToken();
611 
612     /**
613      * The `quantity` minted with ERC2309 exceeds the safety limit.
614      */
615     error MintERC2309QuantityExceedsLimit();
616 
617     /**
618      * The `extraData` cannot be set on an unintialized ownership slot.
619      */
620     error OwnershipNotInitializedForExtraData();
621 
622     // =============================================================
623     //                            STRUCTS
624     // =============================================================
625 
626     struct TokenOwnership {
627         // The address of the owner.
628         address addr;
629         // Stores the start time of ownership with minimal overhead for tokenomics.
630         uint64 startTimestamp;
631         // Whether the token has been burned.
632         bool burned;
633         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
634         uint24 extraData;
635     }
636 
637     // =============================================================
638     //                         TOKEN COUNTERS
639     // =============================================================
640 
641     /**
642      * @dev Returns the total number of tokens in existence.
643      * Burned tokens will reduce the count.
644      * To get the total number of tokens minted, please see {_totalMinted}.
645      */
646     function totalSupply() external view returns (uint256);
647 
648     // =============================================================
649     //                            IERC165
650     // =============================================================
651 
652     /**
653      * @dev Returns true if this contract implements the interface defined by
654      * `interfaceId`. See the corresponding
655      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
656      * to learn more about how these ids are created.
657      *
658      * This function call must use less than 30000 gas.
659      */
660     function supportsInterface(bytes4 interfaceId) external view returns (bool);
661 
662     // =============================================================
663     //                            IERC721
664     // =============================================================
665 
666     /**
667      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
668      */
669     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
670 
671     /**
672      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
673      */
674     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
675 
676     /**
677      * @dev Emitted when `owner` enables or disables
678      * (`approved`) `operator` to manage all of its assets.
679      */
680     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
681 
682     /**
683      * @dev Returns the number of tokens in `owner`'s account.
684      */
685     function balanceOf(address owner) external view returns (uint256 balance);
686 
687     /**
688      * @dev Returns the owner of the `tokenId` token.
689      *
690      * Requirements:
691      *
692      * - `tokenId` must exist.
693      */
694     function ownerOf(uint256 tokenId) external view returns (address owner);
695 
696     /**
697      * @dev Safely transfers `tokenId` token from `from` to `to`,
698      * checking first that contract recipients are aware of the ERC721 protocol
699      * to prevent tokens from being forever locked.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must exist and be owned by `from`.
706      * - If the caller is not `from`, it must be have been allowed to move
707      * this token by either {approve} or {setApprovalForAll}.
708      * - If `to` refers to a smart contract, it must implement
709      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
710      *
711      * Emits a {Transfer} event.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 tokenId,
717         bytes calldata data
718     ) external payable;
719 
720     /**
721      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
722      */
723     function safeTransferFrom(
724         address from,
725         address to,
726         uint256 tokenId
727     ) external payable;
728 
729     /**
730      * @dev Transfers `tokenId` from `from` to `to`.
731      *
732      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
733      * whenever possible.
734      *
735      * Requirements:
736      *
737      * - `from` cannot be the zero address.
738      * - `to` cannot be the zero address.
739      * - `tokenId` token must be owned by `from`.
740      * - If the caller is not `from`, it must be approved to move this token
741      * by either {approve} or {setApprovalForAll}.
742      *
743      * Emits a {Transfer} event.
744      */
745     function transferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) external payable;
750 
751     /**
752      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
753      * The approval is cleared when the token is transferred.
754      *
755      * Only a single account can be approved at a time, so approving the
756      * zero address clears previous approvals.
757      *
758      * Requirements:
759      *
760      * - The caller must own the token or be an approved operator.
761      * - `tokenId` must exist.
762      *
763      * Emits an {Approval} event.
764      */
765     function approve(address to, uint256 tokenId) external payable;
766 
767     /**
768      * @dev Approve or remove `operator` as an operator for the caller.
769      * Operators can call {transferFrom} or {safeTransferFrom}
770      * for any token owned by the caller.
771      *
772      * Requirements:
773      *
774      * - The `operator` cannot be the caller.
775      *
776      * Emits an {ApprovalForAll} event.
777      */
778     function setApprovalForAll(address operator, bool _approved) external;
779 
780     /**
781      * @dev Returns the account approved for `tokenId` token.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must exist.
786      */
787     function getApproved(uint256 tokenId) external view returns (address operator);
788 
789     /**
790      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
791      *
792      * See {setApprovalForAll}.
793      */
794     function isApprovedForAll(address owner, address operator) external view returns (bool);
795 
796     // =============================================================
797     //                        IERC721Metadata
798     // =============================================================
799 
800     /**
801      * @dev Returns the token collection name.
802      */
803     function name() external view returns (string memory);
804 
805     /**
806      * @dev Returns the token collection symbol.
807      */
808     function symbol() external view returns (string memory);
809 
810     /**
811      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
812      */
813     function tokenURI(uint256 tokenId) external view returns (string memory);
814 
815     // =============================================================
816     //                           IERC2309
817     // =============================================================
818 
819     /**
820      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
821      * (inclusive) is transferred from `from` to `to`, as defined in the
822      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
823      *
824      * See {_mintERC2309} for more details.
825      */
826     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
827 }
828 
829 // File: erc721a/contracts/ERC721A.sol
830 
831 
832 // ERC721A Contracts v4.2.3
833 // Creator: Chiru Labs
834 
835 pragma solidity ^0.8.4;
836 
837 
838 /**
839  * @dev Interface of ERC721 token receiver.
840  */
841 interface ERC721A__IERC721Receiver {
842     function onERC721Received(
843         address operator,
844         address from,
845         uint256 tokenId,
846         bytes calldata data
847     ) external returns (bytes4);
848 }
849 
850 /**
851  * @title ERC721A
852  *
853  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
854  * Non-Fungible Token Standard, including the Metadata extension.
855  * Optimized for lower gas during batch mints.
856  *
857  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
858  * starting from `_startTokenId()`.
859  *
860  * Assumptions:
861  *
862  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
863  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
864  */
865 contract ERC721A is IERC721A {
866     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
867     struct TokenApprovalRef {
868         address value;
869     }
870 
871     // =============================================================
872     //                           CONSTANTS
873     // =============================================================
874 
875     // Mask of an entry in packed address data.
876     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
877 
878     // The bit position of `numberMinted` in packed address data.
879     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
880 
881     // The bit position of `numberBurned` in packed address data.
882     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
883 
884     // The bit position of `aux` in packed address data.
885     uint256 private constant _BITPOS_AUX = 192;
886 
887     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
888     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
889 
890     // The bit position of `startTimestamp` in packed ownership.
891     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
892 
893     // The bit mask of the `burned` bit in packed ownership.
894     uint256 private constant _BITMASK_BURNED = 1 << 224;
895 
896     // The bit position of the `nextInitialized` bit in packed ownership.
897     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
898 
899     // The bit mask of the `nextInitialized` bit in packed ownership.
900     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
901 
902     // The bit position of `extraData` in packed ownership.
903     uint256 private constant _BITPOS_EXTRA_DATA = 232;
904 
905     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
906     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
907 
908     // The mask of the lower 160 bits for addresses.
909     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
910 
911     // The maximum `quantity` that can be minted with {_mintERC2309}.
912     // This limit is to prevent overflows on the address data entries.
913     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
914     // is required to cause an overflow, which is unrealistic.
915     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
916 
917     // The `Transfer` event signature is given by:
918     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
919     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
920         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
921 
922     // =============================================================
923     //                            STORAGE
924     // =============================================================
925 
926     // The next token ID to be minted.
927     uint256 private _currentIndex;
928 
929     // The number of tokens burned.
930     uint256 private _burnCounter;
931 
932     // Token name
933     string private _name;
934 
935     // Token symbol
936     string private _symbol;
937 
938     // Mapping from token ID to ownership details
939     // An empty struct value does not necessarily mean the token is unowned.
940     // See {_packedOwnershipOf} implementation for details.
941     //
942     // Bits Layout:
943     // - [0..159]   `addr`
944     // - [160..223] `startTimestamp`
945     // - [224]      `burned`
946     // - [225]      `nextInitialized`
947     // - [232..255] `extraData`
948     mapping(uint256 => uint256) private _packedOwnerships;
949 
950     // Mapping owner address to address data.
951     //
952     // Bits Layout:
953     // - [0..63]    `balance`
954     // - [64..127]  `numberMinted`
955     // - [128..191] `numberBurned`
956     // - [192..255] `aux`
957     mapping(address => uint256) private _packedAddressData;
958 
959     // Mapping from token ID to approved address.
960     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
961 
962     // Mapping from owner to operator approvals
963     mapping(address => mapping(address => bool)) private _operatorApprovals;
964 
965     // =============================================================
966     //                          CONSTRUCTOR
967     // =============================================================
968 
969     constructor(string memory name_, string memory symbol_) {
970         _name = name_;
971         _symbol = symbol_;
972         _currentIndex = _startTokenId();
973     }
974 
975     // =============================================================
976     //                   TOKEN COUNTING OPERATIONS
977     // =============================================================
978 
979     /**
980      * @dev Returns the starting token ID.
981      * To change the starting token ID, please override this function.
982      */
983     function _startTokenId() internal view virtual returns (uint256) {
984         return 0;
985     }
986 
987     /**
988      * @dev Returns the next token ID to be minted.
989      */
990     function _nextTokenId() internal view virtual returns (uint256) {
991         return _currentIndex;
992     }
993 
994     /**
995      * @dev Returns the total number of tokens in existence.
996      * Burned tokens will reduce the count.
997      * To get the total number of tokens minted, please see {_totalMinted}.
998      */
999     function totalSupply() public view virtual override returns (uint256) {
1000         // Counter underflow is impossible as _burnCounter cannot be incremented
1001         // more than `_currentIndex - _startTokenId()` times.
1002         unchecked {
1003             return _currentIndex - _burnCounter - _startTokenId();
1004         }
1005     }
1006 
1007     /**
1008      * @dev Returns the total amount of tokens minted in the contract.
1009      */
1010     function _totalMinted() internal view virtual returns (uint256) {
1011         // Counter underflow is impossible as `_currentIndex` does not decrement,
1012         // and it is initialized to `_startTokenId()`.
1013         unchecked {
1014             return _currentIndex - _startTokenId();
1015         }
1016     }
1017 
1018     /**
1019      * @dev Returns the total number of tokens burned.
1020      */
1021     function _totalBurned() internal view virtual returns (uint256) {
1022         return _burnCounter;
1023     }
1024 
1025     // =============================================================
1026     //                    ADDRESS DATA OPERATIONS
1027     // =============================================================
1028 
1029     /**
1030      * @dev Returns the number of tokens in `owner`'s account.
1031      */
1032     function balanceOf(address owner) public view virtual override returns (uint256) {
1033         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1034         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1035     }
1036 
1037     /**
1038      * Returns the number of tokens minted by `owner`.
1039      */
1040     function _numberMinted(address owner) internal view returns (uint256) {
1041         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1042     }
1043 
1044     /**
1045      * Returns the number of tokens burned by or on behalf of `owner`.
1046      */
1047     function _numberBurned(address owner) internal view returns (uint256) {
1048         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1049     }
1050 
1051     /**
1052      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1053      */
1054     function _getAux(address owner) internal view returns (uint64) {
1055         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1056     }
1057 
1058     /**
1059      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1060      * If there are multiple variables, please pack them into a uint64.
1061      */
1062     function _setAux(address owner, uint64 aux) internal virtual {
1063         uint256 packed = _packedAddressData[owner];
1064         uint256 auxCasted;
1065         // Cast `aux` with assembly to avoid redundant masking.
1066         assembly {
1067             auxCasted := aux
1068         }
1069         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1070         _packedAddressData[owner] = packed;
1071     }
1072 
1073     // =============================================================
1074     //                            IERC165
1075     // =============================================================
1076 
1077     /**
1078      * @dev Returns true if this contract implements the interface defined by
1079      * `interfaceId`. See the corresponding
1080      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1081      * to learn more about how these ids are created.
1082      *
1083      * This function call must use less than 30000 gas.
1084      */
1085     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1086         // The interface IDs are constants representing the first 4 bytes
1087         // of the XOR of all function selectors in the interface.
1088         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1089         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1090         return
1091             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1092             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1093             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1094     }
1095 
1096     // =============================================================
1097     //                        IERC721Metadata
1098     // =============================================================
1099 
1100     /**
1101      * @dev Returns the token collection name.
1102      */
1103     function name() public view virtual override returns (string memory) {
1104         return _name;
1105     }
1106 
1107     /**
1108      * @dev Returns the token collection symbol.
1109      */
1110     function symbol() public view virtual override returns (string memory) {
1111         return _symbol;
1112     }
1113 
1114     /**
1115      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1116      */
1117     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1118         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1119 
1120         string memory baseURI = _baseURI();
1121         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1122     }
1123 
1124     /**
1125      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1126      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1127      * by default, it can be overridden in child contracts.
1128      */
1129     function _baseURI() internal view virtual returns (string memory) {
1130         return '';
1131     }
1132 
1133     // =============================================================
1134     //                     OWNERSHIPS OPERATIONS
1135     // =============================================================
1136 
1137     /**
1138      * @dev Returns the owner of the `tokenId` token.
1139      *
1140      * Requirements:
1141      *
1142      * - `tokenId` must exist.
1143      */
1144     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1145         return address(uint160(_packedOwnershipOf(tokenId)));
1146     }
1147 
1148     /**
1149      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1150      * It gradually moves to O(1) as tokens get transferred around over time.
1151      */
1152     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1153         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1154     }
1155 
1156     /**
1157      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1158      */
1159     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1160         return _unpackedOwnership(_packedOwnerships[index]);
1161     }
1162 
1163     /**
1164      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1165      */
1166     function _initializeOwnershipAt(uint256 index) internal virtual {
1167         if (_packedOwnerships[index] == 0) {
1168             _packedOwnerships[index] = _packedOwnershipOf(index);
1169         }
1170     }
1171 
1172     /**
1173      * Returns the packed ownership data of `tokenId`.
1174      */
1175     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1176         uint256 curr = tokenId;
1177 
1178         unchecked {
1179             if (_startTokenId() <= curr)
1180                 if (curr < _currentIndex) {
1181                     uint256 packed = _packedOwnerships[curr];
1182                     // If not burned.
1183                     if (packed & _BITMASK_BURNED == 0) {
1184                         // Invariant:
1185                         // There will always be an initialized ownership slot
1186                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1187                         // before an unintialized ownership slot
1188                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1189                         // Hence, `curr` will not underflow.
1190                         //
1191                         // We can directly compare the packed value.
1192                         // If the address is zero, packed will be zero.
1193                         while (packed == 0) {
1194                             packed = _packedOwnerships[--curr];
1195                         }
1196                         return packed;
1197                     }
1198                 }
1199         }
1200         revert OwnerQueryForNonexistentToken();
1201     }
1202 
1203     /**
1204      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1205      */
1206     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1207         ownership.addr = address(uint160(packed));
1208         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1209         ownership.burned = packed & _BITMASK_BURNED != 0;
1210         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1211     }
1212 
1213     /**
1214      * @dev Packs ownership data into a single uint256.
1215      */
1216     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1217         assembly {
1218             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1219             owner := and(owner, _BITMASK_ADDRESS)
1220             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1221             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1222         }
1223     }
1224 
1225     /**
1226      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1227      */
1228     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1229         // For branchless setting of the `nextInitialized` flag.
1230         assembly {
1231             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1232             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1233         }
1234     }
1235 
1236     // =============================================================
1237     //                      APPROVAL OPERATIONS
1238     // =============================================================
1239 
1240     /**
1241      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1242      * The approval is cleared when the token is transferred.
1243      *
1244      * Only a single account can be approved at a time, so approving the
1245      * zero address clears previous approvals.
1246      *
1247      * Requirements:
1248      *
1249      * - The caller must own the token or be an approved operator.
1250      * - `tokenId` must exist.
1251      *
1252      * Emits an {Approval} event.
1253      */
1254     function approve(address to, uint256 tokenId) public payable virtual override {
1255         address owner = ownerOf(tokenId);
1256 
1257         if (_msgSenderERC721A() != owner)
1258             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1259                 revert ApprovalCallerNotOwnerNorApproved();
1260             }
1261 
1262         _tokenApprovals[tokenId].value = to;
1263         emit Approval(owner, to, tokenId);
1264     }
1265 
1266     /**
1267      * @dev Returns the account approved for `tokenId` token.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      */
1273     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1274         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1275 
1276         return _tokenApprovals[tokenId].value;
1277     }
1278 
1279     /**
1280      * @dev Approve or remove `operator` as an operator for the caller.
1281      * Operators can call {transferFrom} or {safeTransferFrom}
1282      * for any token owned by the caller.
1283      *
1284      * Requirements:
1285      *
1286      * - The `operator` cannot be the caller.
1287      *
1288      * Emits an {ApprovalForAll} event.
1289      */
1290     function setApprovalForAll(address operator, bool approved) public virtual override {
1291         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1292         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1293     }
1294 
1295     /**
1296      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1297      *
1298      * See {setApprovalForAll}.
1299      */
1300     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1301         return _operatorApprovals[owner][operator];
1302     }
1303 
1304     /**
1305      * @dev Returns whether `tokenId` exists.
1306      *
1307      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1308      *
1309      * Tokens start existing when they are minted. See {_mint}.
1310      */
1311     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1312         return
1313             _startTokenId() <= tokenId &&
1314             tokenId < _currentIndex && // If within bounds,
1315             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1316     }
1317 
1318     /**
1319      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1320      */
1321     function _isSenderApprovedOrOwner(
1322         address approvedAddress,
1323         address owner,
1324         address msgSender
1325     ) private pure returns (bool result) {
1326         assembly {
1327             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1328             owner := and(owner, _BITMASK_ADDRESS)
1329             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1330             msgSender := and(msgSender, _BITMASK_ADDRESS)
1331             // `msgSender == owner || msgSender == approvedAddress`.
1332             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1333         }
1334     }
1335 
1336     /**
1337      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1338      */
1339     function _getApprovedSlotAndAddress(uint256 tokenId)
1340         private
1341         view
1342         returns (uint256 approvedAddressSlot, address approvedAddress)
1343     {
1344         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1345         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1346         assembly {
1347             approvedAddressSlot := tokenApproval.slot
1348             approvedAddress := sload(approvedAddressSlot)
1349         }
1350     }
1351 
1352     // =============================================================
1353     //                      TRANSFER OPERATIONS
1354     // =============================================================
1355 
1356     /**
1357      * @dev Transfers `tokenId` from `from` to `to`.
1358      *
1359      * Requirements:
1360      *
1361      * - `from` cannot be the zero address.
1362      * - `to` cannot be the zero address.
1363      * - `tokenId` token must be owned by `from`.
1364      * - If the caller is not `from`, it must be approved to move this token
1365      * by either {approve} or {setApprovalForAll}.
1366      *
1367      * Emits a {Transfer} event.
1368      */
1369     function transferFrom(
1370         address from,
1371         address to,
1372         uint256 tokenId
1373     ) public payable virtual override {
1374         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1375 
1376         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1377 
1378         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1379 
1380         // The nested ifs save around 20+ gas over a compound boolean condition.
1381         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1382             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1383 
1384         if (to == address(0)) revert TransferToZeroAddress();
1385 
1386         _beforeTokenTransfers(from, to, tokenId, 1);
1387 
1388         // Clear approvals from the previous owner.
1389         assembly {
1390             if approvedAddress {
1391                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1392                 sstore(approvedAddressSlot, 0)
1393             }
1394         }
1395 
1396         // Underflow of the sender's balance is impossible because we check for
1397         // ownership above and the recipient's balance can't realistically overflow.
1398         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1399         unchecked {
1400             // We can directly increment and decrement the balances.
1401             --_packedAddressData[from]; // Updates: `balance -= 1`.
1402             ++_packedAddressData[to]; // Updates: `balance += 1`.
1403 
1404             // Updates:
1405             // - `address` to the next owner.
1406             // - `startTimestamp` to the timestamp of transfering.
1407             // - `burned` to `false`.
1408             // - `nextInitialized` to `true`.
1409             _packedOwnerships[tokenId] = _packOwnershipData(
1410                 to,
1411                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1412             );
1413 
1414             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1415             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1416                 uint256 nextTokenId = tokenId + 1;
1417                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1418                 if (_packedOwnerships[nextTokenId] == 0) {
1419                     // If the next slot is within bounds.
1420                     if (nextTokenId != _currentIndex) {
1421                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1422                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1423                     }
1424                 }
1425             }
1426         }
1427 
1428         emit Transfer(from, to, tokenId);
1429         _afterTokenTransfers(from, to, tokenId, 1);
1430     }
1431 
1432     /**
1433      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1434      */
1435     function safeTransferFrom(
1436         address from,
1437         address to,
1438         uint256 tokenId
1439     ) public payable virtual override {
1440         safeTransferFrom(from, to, tokenId, '');
1441     }
1442 
1443     /**
1444      * @dev Safely transfers `tokenId` token from `from` to `to`.
1445      *
1446      * Requirements:
1447      *
1448      * - `from` cannot be the zero address.
1449      * - `to` cannot be the zero address.
1450      * - `tokenId` token must exist and be owned by `from`.
1451      * - If the caller is not `from`, it must be approved to move this token
1452      * by either {approve} or {setApprovalForAll}.
1453      * - If `to` refers to a smart contract, it must implement
1454      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function safeTransferFrom(
1459         address from,
1460         address to,
1461         uint256 tokenId,
1462         bytes memory _data
1463     ) public payable virtual override {
1464         transferFrom(from, to, tokenId);
1465         if (to.code.length != 0)
1466             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1467                 revert TransferToNonERC721ReceiverImplementer();
1468             }
1469     }
1470 
1471     /**
1472      * @dev Hook that is called before a set of serially-ordered token IDs
1473      * are about to be transferred. This includes minting.
1474      * And also called before burning one token.
1475      *
1476      * `startTokenId` - the first token ID to be transferred.
1477      * `quantity` - the amount to be transferred.
1478      *
1479      * Calling conditions:
1480      *
1481      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1482      * transferred to `to`.
1483      * - When `from` is zero, `tokenId` will be minted for `to`.
1484      * - When `to` is zero, `tokenId` will be burned by `from`.
1485      * - `from` and `to` are never both zero.
1486      */
1487     function _beforeTokenTransfers(
1488         address from,
1489         address to,
1490         uint256 startTokenId,
1491         uint256 quantity
1492     ) internal virtual {}
1493 
1494     /**
1495      * @dev Hook that is called after a set of serially-ordered token IDs
1496      * have been transferred. This includes minting.
1497      * And also called after one token has been burned.
1498      *
1499      * `startTokenId` - the first token ID to be transferred.
1500      * `quantity` - the amount to be transferred.
1501      *
1502      * Calling conditions:
1503      *
1504      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1505      * transferred to `to`.
1506      * - When `from` is zero, `tokenId` has been minted for `to`.
1507      * - When `to` is zero, `tokenId` has been burned by `from`.
1508      * - `from` and `to` are never both zero.
1509      */
1510     function _afterTokenTransfers(
1511         address from,
1512         address to,
1513         uint256 startTokenId,
1514         uint256 quantity
1515     ) internal virtual {}
1516 
1517     /**
1518      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1519      *
1520      * `from` - Previous owner of the given token ID.
1521      * `to` - Target address that will receive the token.
1522      * `tokenId` - Token ID to be transferred.
1523      * `_data` - Optional data to send along with the call.
1524      *
1525      * Returns whether the call correctly returned the expected magic value.
1526      */
1527     function _checkContractOnERC721Received(
1528         address from,
1529         address to,
1530         uint256 tokenId,
1531         bytes memory _data
1532     ) private returns (bool) {
1533         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1534             bytes4 retval
1535         ) {
1536             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1537         } catch (bytes memory reason) {
1538             if (reason.length == 0) {
1539                 revert TransferToNonERC721ReceiverImplementer();
1540             } else {
1541                 assembly {
1542                     revert(add(32, reason), mload(reason))
1543                 }
1544             }
1545         }
1546     }
1547 
1548     // =============================================================
1549     //                        MINT OPERATIONS
1550     // =============================================================
1551 
1552     /**
1553      * @dev Mints `quantity` tokens and transfers them to `to`.
1554      *
1555      * Requirements:
1556      *
1557      * - `to` cannot be the zero address.
1558      * - `quantity` must be greater than 0.
1559      *
1560      * Emits a {Transfer} event for each mint.
1561      */
1562     function _mint(address to, uint256 quantity) internal virtual {
1563         uint256 startTokenId = _currentIndex;
1564         if (quantity == 0) revert MintZeroQuantity();
1565 
1566         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1567 
1568         // Overflows are incredibly unrealistic.
1569         // `balance` and `numberMinted` have a maximum limit of 2**64.
1570         // `tokenId` has a maximum limit of 2**256.
1571         unchecked {
1572             // Updates:
1573             // - `balance += quantity`.
1574             // - `numberMinted += quantity`.
1575             //
1576             // We can directly add to the `balance` and `numberMinted`.
1577             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1578 
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
1589             uint256 toMasked;
1590             uint256 end = startTokenId + quantity;
1591 
1592             // Use assembly to loop and emit the `Transfer` event for gas savings.
1593             // The duplicated `log4` removes an extra check and reduces stack juggling.
1594             // The assembly, together with the surrounding Solidity code, have been
1595             // delicately arranged to nudge the compiler into producing optimized opcodes.
1596             assembly {
1597                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1598                 toMasked := and(to, _BITMASK_ADDRESS)
1599                 // Emit the `Transfer` event.
1600                 log4(
1601                     0, // Start of data (0, since no data).
1602                     0, // End of data (0, since no data).
1603                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1604                     0, // `address(0)`.
1605                     toMasked, // `to`.
1606                     startTokenId // `tokenId`.
1607                 )
1608 
1609                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1610                 // that overflows uint256 will make the loop run out of gas.
1611                 // The compiler will optimize the `iszero` away for performance.
1612                 for {
1613                     let tokenId := add(startTokenId, 1)
1614                 } iszero(eq(tokenId, end)) {
1615                     tokenId := add(tokenId, 1)
1616                 } {
1617                     // Emit the `Transfer` event. Similar to above.
1618                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1619                 }
1620             }
1621             if (toMasked == 0) revert MintToZeroAddress();
1622 
1623             _currentIndex = end;
1624         }
1625         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1626     }
1627 
1628     /**
1629      * @dev Mints `quantity` tokens and transfers them to `to`.
1630      *
1631      * This function is intended for efficient minting only during contract creation.
1632      *
1633      * It emits only one {ConsecutiveTransfer} as defined in
1634      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1635      * instead of a sequence of {Transfer} event(s).
1636      *
1637      * Calling this function outside of contract creation WILL make your contract
1638      * non-compliant with the ERC721 standard.
1639      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1640      * {ConsecutiveTransfer} event is only permissible during contract creation.
1641      *
1642      * Requirements:
1643      *
1644      * - `to` cannot be the zero address.
1645      * - `quantity` must be greater than 0.
1646      *
1647      * Emits a {ConsecutiveTransfer} event.
1648      */
1649     function _mintERC2309(address to, uint256 quantity) internal virtual {
1650         uint256 startTokenId = _currentIndex;
1651         if (to == address(0)) revert MintToZeroAddress();
1652         if (quantity == 0) revert MintZeroQuantity();
1653         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1654 
1655         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1656 
1657         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1658         unchecked {
1659             // Updates:
1660             // - `balance += quantity`.
1661             // - `numberMinted += quantity`.
1662             //
1663             // We can directly add to the `balance` and `numberMinted`.
1664             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1665 
1666             // Updates:
1667             // - `address` to the owner.
1668             // - `startTimestamp` to the timestamp of minting.
1669             // - `burned` to `false`.
1670             // - `nextInitialized` to `quantity == 1`.
1671             _packedOwnerships[startTokenId] = _packOwnershipData(
1672                 to,
1673                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1674             );
1675 
1676             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1677 
1678             _currentIndex = startTokenId + quantity;
1679         }
1680         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1681     }
1682 
1683     /**
1684      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1685      *
1686      * Requirements:
1687      *
1688      * - If `to` refers to a smart contract, it must implement
1689      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1690      * - `quantity` must be greater than 0.
1691      *
1692      * See {_mint}.
1693      *
1694      * Emits a {Transfer} event for each mint.
1695      */
1696     function _safeMint(
1697         address to,
1698         uint256 quantity,
1699         bytes memory _data
1700     ) internal virtual {
1701         _mint(to, quantity);
1702 
1703         unchecked {
1704             if (to.code.length != 0) {
1705                 uint256 end = _currentIndex;
1706                 uint256 index = end - quantity;
1707                 do {
1708                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1709                         revert TransferToNonERC721ReceiverImplementer();
1710                     }
1711                 } while (index < end);
1712                 // Reentrancy protection.
1713                 if (_currentIndex != end) revert();
1714             }
1715         }
1716     }
1717 
1718     /**
1719      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1720      */
1721     function _safeMint(address to, uint256 quantity) internal virtual {
1722         _safeMint(to, quantity, '');
1723     }
1724 
1725     // =============================================================
1726     //                        BURN OPERATIONS
1727     // =============================================================
1728 
1729     /**
1730      * @dev Equivalent to `_burn(tokenId, false)`.
1731      */
1732     function _burn(uint256 tokenId) internal virtual {
1733         _burn(tokenId, false);
1734     }
1735 
1736     /**
1737      * @dev Destroys `tokenId`.
1738      * The approval is cleared when the token is burned.
1739      *
1740      * Requirements:
1741      *
1742      * - `tokenId` must exist.
1743      *
1744      * Emits a {Transfer} event.
1745      */
1746     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1747         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1748 
1749         address from = address(uint160(prevOwnershipPacked));
1750 
1751         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1752 
1753         if (approvalCheck) {
1754             // The nested ifs save around 20+ gas over a compound boolean condition.
1755             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1756                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1757         }
1758 
1759         _beforeTokenTransfers(from, address(0), tokenId, 1);
1760 
1761         // Clear approvals from the previous owner.
1762         assembly {
1763             if approvedAddress {
1764                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1765                 sstore(approvedAddressSlot, 0)
1766             }
1767         }
1768 
1769         // Underflow of the sender's balance is impossible because we check for
1770         // ownership above and the recipient's balance can't realistically overflow.
1771         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1772         unchecked {
1773             // Updates:
1774             // - `balance -= 1`.
1775             // - `numberBurned += 1`.
1776             //
1777             // We can directly decrement the balance, and increment the number burned.
1778             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1779             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1780 
1781             // Updates:
1782             // - `address` to the last owner.
1783             // - `startTimestamp` to the timestamp of burning.
1784             // - `burned` to `true`.
1785             // - `nextInitialized` to `true`.
1786             _packedOwnerships[tokenId] = _packOwnershipData(
1787                 from,
1788                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1789             );
1790 
1791             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1792             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1793                 uint256 nextTokenId = tokenId + 1;
1794                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1795                 if (_packedOwnerships[nextTokenId] == 0) {
1796                     // If the next slot is within bounds.
1797                     if (nextTokenId != _currentIndex) {
1798                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1799                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1800                     }
1801                 }
1802             }
1803         }
1804 
1805         emit Transfer(from, address(0), tokenId);
1806         _afterTokenTransfers(from, address(0), tokenId, 1);
1807 
1808         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1809         unchecked {
1810             _burnCounter++;
1811         }
1812     }
1813 
1814     // =============================================================
1815     //                     EXTRA DATA OPERATIONS
1816     // =============================================================
1817 
1818     /**
1819      * @dev Directly sets the extra data for the ownership data `index`.
1820      */
1821     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1822         uint256 packed = _packedOwnerships[index];
1823         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1824         uint256 extraDataCasted;
1825         // Cast `extraData` with assembly to avoid redundant masking.
1826         assembly {
1827             extraDataCasted := extraData
1828         }
1829         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1830         _packedOwnerships[index] = packed;
1831     }
1832 
1833     /**
1834      * @dev Called during each token transfer to set the 24bit `extraData` field.
1835      * Intended to be overridden by the cosumer contract.
1836      *
1837      * `previousExtraData` - the value of `extraData` before transfer.
1838      *
1839      * Calling conditions:
1840      *
1841      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1842      * transferred to `to`.
1843      * - When `from` is zero, `tokenId` will be minted for `to`.
1844      * - When `to` is zero, `tokenId` will be burned by `from`.
1845      * - `from` and `to` are never both zero.
1846      */
1847     function _extraData(
1848         address from,
1849         address to,
1850         uint24 previousExtraData
1851     ) internal view virtual returns (uint24) {}
1852 
1853     /**
1854      * @dev Returns the next extra data for the packed ownership data.
1855      * The returned result is shifted into position.
1856      */
1857     function _nextExtraData(
1858         address from,
1859         address to,
1860         uint256 prevOwnershipPacked
1861     ) private view returns (uint256) {
1862         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1863         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1864     }
1865 
1866     // =============================================================
1867     //                       OTHER OPERATIONS
1868     // =============================================================
1869 
1870     /**
1871      * @dev Returns the message sender (defaults to `msg.sender`).
1872      *
1873      * If you are writing GSN compatible contracts, you need to override this function.
1874      */
1875     function _msgSenderERC721A() internal view virtual returns (address) {
1876         return msg.sender;
1877     }
1878 
1879     /**
1880      * @dev Converts a uint256 to its ASCII string decimal representation.
1881      */
1882     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1883         assembly {
1884             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1885             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1886             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1887             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1888             let m := add(mload(0x40), 0xa0)
1889             // Update the free memory pointer to allocate.
1890             mstore(0x40, m)
1891             // Assign the `str` to the end.
1892             str := sub(m, 0x20)
1893             // Zeroize the slot after the string.
1894             mstore(str, 0)
1895 
1896             // Cache the end of the memory to calculate the length later.
1897             let end := str
1898 
1899             // We write the string from rightmost digit to leftmost digit.
1900             // The following is essentially a do-while loop that also handles the zero case.
1901             // prettier-ignore
1902             for { let temp := value } 1 {} {
1903                 str := sub(str, 1)
1904                 // Write the character to the pointer.
1905                 // The ASCII index of the '0' character is 48.
1906                 mstore8(str, add(48, mod(temp, 10)))
1907                 // Keep dividing `temp` until zero.
1908                 temp := div(temp, 10)
1909                 // prettier-ignore
1910                 if iszero(temp) { break }
1911             }
1912 
1913             let length := sub(end, str)
1914             // Move the pointer 32 bytes leftwards to make room for the length.
1915             str := sub(str, 0x20)
1916             // Store the length.
1917             mstore(str, length)
1918         }
1919     }
1920 }
1921 
1922 // File: contracts/Exolienz.sol
1923 
1924 
1925 //                                                  
1926 //   _____ _____ ___          ___ _____ _   _ ______
1927 //  |  ___|_____) _ \   /\   (   )  ___) \ | (___  /
1928 //  | |_    ___| | | | /  \   | || |_  |  \| |  / / 
1929 //  |  _)  (___) | | |/ /\ \  | ||  _) |     | / /  
1930 //  | |___ ____| |_| / /  \ \ | || |___| |\  |/ /__ 
1931 //  |_____|_____)___/_/    \_(___)_____)_| \_/_____)
1932 //                                                  
1933 //                                                  
1934 
1935 
1936 //SPDX-License-Identifier: MIT
1937 pragma solidity ^0.8.4;
1938 
1939 
1940 
1941 
1942 
1943 
1944 contract Exolinez is Ownable, ERC721A {
1945     uint256 constant public MAX_SUPPLY = 999;
1946     
1947 
1948     uint256 public publicPrice = 0.007 ether;
1949 
1950     uint256 constant public PUBLIC_MINT_LIMIT_TXN = 2;
1951     uint256 constant public PUBLIC_MINT_LIMIT = 2;
1952 
1953     string public revealedURI;
1954 
1955     
1956 
1957     bool public paused = false;
1958     bool public revealed = true;
1959     bool public publicSale = false;
1960 
1961     
1962     address constant internal Artist = 0x92c39077Bf09cb8149B0222a27785f724EC3D27F;
1963     
1964     
1965 
1966     
1967     mapping(address => uint256) public numUserMints;
1968 
1969     constructor(string memory _name, string memory _symbol, string memory _baseUri) ERC721A("Exolienz By BonishBil", "EXOZ") { }
1970 
1971     
1972     function _startTokenId() internal view virtual override returns (uint256) {
1973         return 1;
1974     }
1975 
1976     function refundOverpay(uint256 price) private {
1977         if (msg.value > price) {
1978             (bool succ, ) = payable(msg.sender).call{
1979                 value: (msg.value - price)
1980             }("");
1981             require(succ, "Transfer failed");
1982         }
1983         else if (msg.value < price) {
1984             revert("Not enough ETH sent");
1985         }
1986     }
1987 
1988     
1989     
1990 
1991     function publicMint(uint256 quantity) external payable mintCompliance(quantity) {
1992         require(publicSale, "Public sale inactive");
1993         require(quantity <= PUBLIC_MINT_LIMIT_TXN, "Quantity too high");
1994 
1995         uint256 price = publicPrice;
1996         uint256 currMints = numUserMints[msg.sender];
1997                 
1998         require(currMints + quantity <= PUBLIC_MINT_LIMIT, "User max mint limit");
1999         
2000         refundOverpay(price * quantity);
2001 
2002         numUserMints[msg.sender] = (currMints + quantity);
2003 
2004         _safeMint(msg.sender, quantity);
2005     }
2006 
2007     
2008     function walletOfOwner(address _owner) public view returns (uint256[] memory)
2009     {
2010         uint256 ownerTokenCount = balanceOf(_owner);
2011         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2012         uint256 currentTokenId = 1;
2013         uint256 ownedTokenIndex = 0;
2014 
2015         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
2016             address currentTokenOwner = ownerOf(currentTokenId);
2017 
2018             if (currentTokenOwner == _owner) {
2019                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
2020 
2021                 ownedTokenIndex++;
2022             }
2023 
2024         currentTokenId++;
2025         }
2026 
2027         return ownedTokenIds;
2028     }
2029 
2030     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
2031         
2032         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2033         
2034         if (revealed) {
2035             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
2036         }
2037         else {
2038             return revealedURI;
2039         }
2040     }
2041 
2042     function setPublicPrice(uint256 _publicPrice) public onlyOwner {
2043         publicPrice = _publicPrice;
2044     }
2045 
2046     function setBaseURI(string memory _baseUri) public onlyOwner {
2047         revealedURI = _baseUri;
2048     }
2049 
2050 
2051     function setPaused(bool _state) public onlyOwner {
2052         paused = _state;
2053     }
2054 
2055     function setRevealed(bool _state) public onlyOwner {
2056         revealed = _state;
2057     }
2058 
2059     function setPublicEnabled(bool _state) public onlyOwner {
2060         publicSale = _state;
2061     }
2062     
2063     function withdraw() external payable onlyOwner {
2064         
2065         uint256 currBalance = address(this).balance;
2066 
2067         (bool succ, ) = payable(Artist).call{
2068             value: (currBalance * 10000) / 10000
2069         }("0x92c39077Bf09cb8149B0222a27785f724EC3D27F");
2070         require(succ, "Dev transfer failed");
2071 
2072     }
2073 
2074     
2075     function mintToUser(uint256 quantity, address receiver) public onlyOwner mintCompliance(quantity) {
2076         _safeMint(receiver, quantity);
2077     }
2078 
2079    
2080 
2081     modifier mintCompliance(uint256 quantity) {
2082         require(!paused, "Contract is paused");
2083         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough mints left");
2084         require(tx.origin == msg.sender, "No contract minting");
2085         _;
2086     }
2087 }