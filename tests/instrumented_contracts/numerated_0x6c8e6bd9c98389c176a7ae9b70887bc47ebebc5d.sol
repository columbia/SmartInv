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
421 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @dev Contract module that helps prevent reentrant calls to a function.
430  *
431  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
432  * available, which can be applied to functions to make sure there are no nested
433  * (reentrant) calls to them.
434  *
435  * Note that because there is a single `nonReentrant` guard, functions marked as
436  * `nonReentrant` may not call one another. This can be worked around by making
437  * those functions `private`, and then adding `external` `nonReentrant` entry
438  * points to them.
439  *
440  * TIP: If you would like to learn more about reentrancy and alternative ways
441  * to protect against it, check out our blog post
442  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
443  */
444 abstract contract ReentrancyGuard {
445     // Booleans are more expensive than uint256 or any type that takes up a full
446     // word because each write operation emits an extra SLOAD to first read the
447     // slot's contents, replace the bits taken up by the boolean, and then write
448     // back. This is the compiler's defense against contract upgrades and
449     // pointer aliasing, and it cannot be disabled.
450 
451     // The values being non-zero value makes deployment a bit more expensive,
452     // but in exchange the refund on every call to nonReentrant will be lower in
453     // amount. Since refunds are capped to a percentage of the total
454     // transaction's gas, it is best to keep them low in cases like this one, to
455     // increase the likelihood of the full refund coming into effect.
456     uint256 private constant _NOT_ENTERED = 1;
457     uint256 private constant _ENTERED = 2;
458 
459     uint256 private _status;
460 
461     constructor() {
462         _status = _NOT_ENTERED;
463     }
464 
465     /**
466      * @dev Prevents a contract from calling itself, directly or indirectly.
467      * Calling a `nonReentrant` function from another `nonReentrant`
468      * function is not supported. It is possible to prevent this from happening
469      * by making the `nonReentrant` function external, and making it call a
470      * `private` function that does the actual work.
471      */
472     modifier nonReentrant() {
473         _nonReentrantBefore();
474         _;
475         _nonReentrantAfter();
476     }
477 
478     function _nonReentrantBefore() private {
479         // On the first call to nonReentrant, _status will be _NOT_ENTERED
480         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
481 
482         // Any calls to nonReentrant after this point will fail
483         _status = _ENTERED;
484     }
485 
486     function _nonReentrantAfter() private {
487         // By storing the original value once again, a refund is triggered (see
488         // https://eips.ethereum.org/EIPS/eip-2200)
489         _status = _NOT_ENTERED;
490     }
491 }
492 
493 // File: erc721a/contracts/IERC721A.sol
494 
495 
496 // ERC721A Contracts v4.2.3
497 // Creator: Chiru Labs
498 
499 pragma solidity ^0.8.4;
500 
501 /**
502  * @dev Interface of ERC721A.
503  */
504 interface IERC721A {
505     /**
506      * The caller must own the token or be an approved operator.
507      */
508     error ApprovalCallerNotOwnerNorApproved();
509 
510     /**
511      * The token does not exist.
512      */
513     error ApprovalQueryForNonexistentToken();
514 
515     /**
516      * Cannot query the balance for the zero address.
517      */
518     error BalanceQueryForZeroAddress();
519 
520     /**
521      * Cannot mint to the zero address.
522      */
523     error MintToZeroAddress();
524 
525     /**
526      * The quantity of tokens minted must be more than zero.
527      */
528     error MintZeroQuantity();
529 
530     /**
531      * The token does not exist.
532      */
533     error OwnerQueryForNonexistentToken();
534 
535     /**
536      * The caller must own the token or be an approved operator.
537      */
538     error TransferCallerNotOwnerNorApproved();
539 
540     /**
541      * The token must be owned by `from`.
542      */
543     error TransferFromIncorrectOwner();
544 
545     /**
546      * Cannot safely transfer to a contract that does not implement the
547      * ERC721Receiver interface.
548      */
549     error TransferToNonERC721ReceiverImplementer();
550 
551     /**
552      * Cannot transfer to the zero address.
553      */
554     error TransferToZeroAddress();
555 
556     /**
557      * The token does not exist.
558      */
559     error URIQueryForNonexistentToken();
560 
561     /**
562      * The `quantity` minted with ERC2309 exceeds the safety limit.
563      */
564     error MintERC2309QuantityExceedsLimit();
565 
566     /**
567      * The `extraData` cannot be set on an unintialized ownership slot.
568      */
569     error OwnershipNotInitializedForExtraData();
570 
571     // =============================================================
572     //                            STRUCTS
573     // =============================================================
574 
575     struct TokenOwnership {
576         // The address of the owner.
577         address addr;
578         // Stores the start time of ownership with minimal overhead for tokenomics.
579         uint64 startTimestamp;
580         // Whether the token has been burned.
581         bool burned;
582         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
583         uint24 extraData;
584     }
585 
586     // =============================================================
587     //                         TOKEN COUNTERS
588     // =============================================================
589 
590     /**
591      * @dev Returns the total number of tokens in existence.
592      * Burned tokens will reduce the count.
593      * To get the total number of tokens minted, please see {_totalMinted}.
594      */
595     function totalSupply() external view returns (uint256);
596 
597     // =============================================================
598     //                            IERC165
599     // =============================================================
600 
601     /**
602      * @dev Returns true if this contract implements the interface defined by
603      * `interfaceId`. See the corresponding
604      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
605      * to learn more about how these ids are created.
606      *
607      * This function call must use less than 30000 gas.
608      */
609     function supportsInterface(bytes4 interfaceId) external view returns (bool);
610 
611     // =============================================================
612     //                            IERC721
613     // =============================================================
614 
615     /**
616      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
617      */
618     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
619 
620     /**
621      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
622      */
623     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
624 
625     /**
626      * @dev Emitted when `owner` enables or disables
627      * (`approved`) `operator` to manage all of its assets.
628      */
629     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
630 
631     /**
632      * @dev Returns the number of tokens in `owner`'s account.
633      */
634     function balanceOf(address owner) external view returns (uint256 balance);
635 
636     /**
637      * @dev Returns the owner of the `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function ownerOf(uint256 tokenId) external view returns (address owner);
644 
645     /**
646      * @dev Safely transfers `tokenId` token from `from` to `to`,
647      * checking first that contract recipients are aware of the ERC721 protocol
648      * to prevent tokens from being forever locked.
649      *
650      * Requirements:
651      *
652      * - `from` cannot be the zero address.
653      * - `to` cannot be the zero address.
654      * - `tokenId` token must exist and be owned by `from`.
655      * - If the caller is not `from`, it must be have been allowed to move
656      * this token by either {approve} or {setApprovalForAll}.
657      * - If `to` refers to a smart contract, it must implement
658      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
659      *
660      * Emits a {Transfer} event.
661      */
662     function safeTransferFrom(
663         address from,
664         address to,
665         uint256 tokenId,
666         bytes calldata data
667     ) external payable;
668 
669     /**
670      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) external payable;
677 
678     /**
679      * @dev Transfers `tokenId` from `from` to `to`.
680      *
681      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
682      * whenever possible.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must be owned by `from`.
689      * - If the caller is not `from`, it must be approved to move this token
690      * by either {approve} or {setApprovalForAll}.
691      *
692      * Emits a {Transfer} event.
693      */
694     function transferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) external payable;
699 
700     /**
701      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
702      * The approval is cleared when the token is transferred.
703      *
704      * Only a single account can be approved at a time, so approving the
705      * zero address clears previous approvals.
706      *
707      * Requirements:
708      *
709      * - The caller must own the token or be an approved operator.
710      * - `tokenId` must exist.
711      *
712      * Emits an {Approval} event.
713      */
714     function approve(address to, uint256 tokenId) external payable;
715 
716     /**
717      * @dev Approve or remove `operator` as an operator for the caller.
718      * Operators can call {transferFrom} or {safeTransferFrom}
719      * for any token owned by the caller.
720      *
721      * Requirements:
722      *
723      * - The `operator` cannot be the caller.
724      *
725      * Emits an {ApprovalForAll} event.
726      */
727     function setApprovalForAll(address operator, bool _approved) external;
728 
729     /**
730      * @dev Returns the account approved for `tokenId` token.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function getApproved(uint256 tokenId) external view returns (address operator);
737 
738     /**
739      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
740      *
741      * See {setApprovalForAll}.
742      */
743     function isApprovedForAll(address owner, address operator) external view returns (bool);
744 
745     // =============================================================
746     //                        IERC721Metadata
747     // =============================================================
748 
749     /**
750      * @dev Returns the token collection name.
751      */
752     function name() external view returns (string memory);
753 
754     /**
755      * @dev Returns the token collection symbol.
756      */
757     function symbol() external view returns (string memory);
758 
759     /**
760      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
761      */
762     function tokenURI(uint256 tokenId) external view returns (string memory);
763 
764     // =============================================================
765     //                           IERC2309
766     // =============================================================
767 
768     /**
769      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
770      * (inclusive) is transferred from `from` to `to`, as defined in the
771      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
772      *
773      * See {_mintERC2309} for more details.
774      */
775     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
776 }
777 
778 // File: erc721a/contracts/ERC721A.sol
779 
780 
781 // ERC721A Contracts v4.2.3
782 // Creator: Chiru Labs
783 
784 pragma solidity ^0.8.4;
785 
786 
787 /**
788  * @dev Interface of ERC721 token receiver.
789  */
790 interface ERC721A__IERC721Receiver {
791     function onERC721Received(
792         address operator,
793         address from,
794         uint256 tokenId,
795         bytes calldata data
796     ) external returns (bytes4);
797 }
798 
799 /**
800  * @title ERC721A
801  *
802  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
803  * Non-Fungible Token Standard, including the Metadata extension.
804  * Optimized for lower gas during batch mints.
805  *
806  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
807  * starting from `_startTokenId()`.
808  *
809  * Assumptions:
810  *
811  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
812  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
813  */
814 contract ERC721A is IERC721A {
815     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
816     struct TokenApprovalRef {
817         address value;
818     }
819 
820     // =============================================================
821     //                           CONSTANTS
822     // =============================================================
823 
824     // Mask of an entry in packed address data.
825     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
826 
827     // The bit position of `numberMinted` in packed address data.
828     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
829 
830     // The bit position of `numberBurned` in packed address data.
831     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
832 
833     // The bit position of `aux` in packed address data.
834     uint256 private constant _BITPOS_AUX = 192;
835 
836     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
837     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
838 
839     // The bit position of `startTimestamp` in packed ownership.
840     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
841 
842     // The bit mask of the `burned` bit in packed ownership.
843     uint256 private constant _BITMASK_BURNED = 1 << 224;
844 
845     // The bit position of the `nextInitialized` bit in packed ownership.
846     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
847 
848     // The bit mask of the `nextInitialized` bit in packed ownership.
849     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
850 
851     // The bit position of `extraData` in packed ownership.
852     uint256 private constant _BITPOS_EXTRA_DATA = 232;
853 
854     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
855     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
856 
857     // The mask of the lower 160 bits for addresses.
858     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
859 
860     // The maximum `quantity` that can be minted with {_mintERC2309}.
861     // This limit is to prevent overflows on the address data entries.
862     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
863     // is required to cause an overflow, which is unrealistic.
864     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
865 
866     // The `Transfer` event signature is given by:
867     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
868     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
869         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
870 
871     // =============================================================
872     //                            STORAGE
873     // =============================================================
874 
875     // The next token ID to be minted.
876     uint256 private _currentIndex;
877 
878     // The number of tokens burned.
879     uint256 private _burnCounter;
880 
881     // Token name
882     string private _name;
883 
884     // Token symbol
885     string private _symbol;
886 
887     // Mapping from token ID to ownership details
888     // An empty struct value does not necessarily mean the token is unowned.
889     // See {_packedOwnershipOf} implementation for details.
890     //
891     // Bits Layout:
892     // - [0..159]   `addr`
893     // - [160..223] `startTimestamp`
894     // - [224]      `burned`
895     // - [225]      `nextInitialized`
896     // - [232..255] `extraData`
897     mapping(uint256 => uint256) private _packedOwnerships;
898 
899     // Mapping owner address to address data.
900     //
901     // Bits Layout:
902     // - [0..63]    `balance`
903     // - [64..127]  `numberMinted`
904     // - [128..191] `numberBurned`
905     // - [192..255] `aux`
906     mapping(address => uint256) private _packedAddressData;
907 
908     // Mapping from token ID to approved address.
909     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
910 
911     // Mapping from owner to operator approvals
912     mapping(address => mapping(address => bool)) private _operatorApprovals;
913 
914     // =============================================================
915     //                          CONSTRUCTOR
916     // =============================================================
917 
918     constructor(string memory name_, string memory symbol_) {
919         _name = name_;
920         _symbol = symbol_;
921         _currentIndex = _startTokenId();
922     }
923 
924     // =============================================================
925     //                   TOKEN COUNTING OPERATIONS
926     // =============================================================
927 
928     /**
929      * @dev Returns the starting token ID.
930      * To change the starting token ID, please override this function.
931      */
932     function _startTokenId() internal view virtual returns (uint256) {
933         return 0;
934     }
935 
936     /**
937      * @dev Returns the next token ID to be minted.
938      */
939     function _nextTokenId() internal view virtual returns (uint256) {
940         return _currentIndex;
941     }
942 
943     /**
944      * @dev Returns the total number of tokens in existence.
945      * Burned tokens will reduce the count.
946      * To get the total number of tokens minted, please see {_totalMinted}.
947      */
948     function totalSupply() public view virtual override returns (uint256) {
949         // Counter underflow is impossible as _burnCounter cannot be incremented
950         // more than `_currentIndex - _startTokenId()` times.
951         unchecked {
952             return _currentIndex - _burnCounter - _startTokenId();
953         }
954     }
955 
956     /**
957      * @dev Returns the total amount of tokens minted in the contract.
958      */
959     function _totalMinted() internal view virtual returns (uint256) {
960         // Counter underflow is impossible as `_currentIndex` does not decrement,
961         // and it is initialized to `_startTokenId()`.
962         unchecked {
963             return _currentIndex - _startTokenId();
964         }
965     }
966 
967     /**
968      * @dev Returns the total number of tokens burned.
969      */
970     function _totalBurned() internal view virtual returns (uint256) {
971         return _burnCounter;
972     }
973 
974     // =============================================================
975     //                    ADDRESS DATA OPERATIONS
976     // =============================================================
977 
978     /**
979      * @dev Returns the number of tokens in `owner`'s account.
980      */
981     function balanceOf(address owner) public view virtual override returns (uint256) {
982         if (owner == address(0)) revert BalanceQueryForZeroAddress();
983         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
984     }
985 
986     /**
987      * Returns the number of tokens minted by `owner`.
988      */
989     function _numberMinted(address owner) internal view returns (uint256) {
990         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
991     }
992 
993     /**
994      * Returns the number of tokens burned by or on behalf of `owner`.
995      */
996     function _numberBurned(address owner) internal view returns (uint256) {
997         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
998     }
999 
1000     /**
1001      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1002      */
1003     function _getAux(address owner) internal view returns (uint64) {
1004         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1005     }
1006 
1007     /**
1008      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1009      * If there are multiple variables, please pack them into a uint64.
1010      */
1011     function _setAux(address owner, uint64 aux) internal virtual {
1012         uint256 packed = _packedAddressData[owner];
1013         uint256 auxCasted;
1014         // Cast `aux` with assembly to avoid redundant masking.
1015         assembly {
1016             auxCasted := aux
1017         }
1018         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1019         _packedAddressData[owner] = packed;
1020     }
1021 
1022     // =============================================================
1023     //                            IERC165
1024     // =============================================================
1025 
1026     /**
1027      * @dev Returns true if this contract implements the interface defined by
1028      * `interfaceId`. See the corresponding
1029      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1030      * to learn more about how these ids are created.
1031      *
1032      * This function call must use less than 30000 gas.
1033      */
1034     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1035         // The interface IDs are constants representing the first 4 bytes
1036         // of the XOR of all function selectors in the interface.
1037         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1038         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1039         return
1040             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1041             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1042             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1043     }
1044 
1045     // =============================================================
1046     //                        IERC721Metadata
1047     // =============================================================
1048 
1049     /**
1050      * @dev Returns the token collection name.
1051      */
1052     function name() public view virtual override returns (string memory) {
1053         return _name;
1054     }
1055 
1056     /**
1057      * @dev Returns the token collection symbol.
1058      */
1059     function symbol() public view virtual override returns (string memory) {
1060         return _symbol;
1061     }
1062 
1063     /**
1064      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1065      */
1066     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1067         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1068 
1069         string memory baseURI = _baseURI();
1070         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1071     }
1072 
1073     /**
1074      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1075      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1076      * by default, it can be overridden in child contracts.
1077      */
1078     function _baseURI() internal view virtual returns (string memory) {
1079         return '';
1080     }
1081 
1082     // =============================================================
1083     //                     OWNERSHIPS OPERATIONS
1084     // =============================================================
1085 
1086     /**
1087      * @dev Returns the owner of the `tokenId` token.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must exist.
1092      */
1093     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1094         return address(uint160(_packedOwnershipOf(tokenId)));
1095     }
1096 
1097     /**
1098      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1099      * It gradually moves to O(1) as tokens get transferred around over time.
1100      */
1101     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1102         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1103     }
1104 
1105     /**
1106      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1107      */
1108     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1109         return _unpackedOwnership(_packedOwnerships[index]);
1110     }
1111 
1112     /**
1113      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1114      */
1115     function _initializeOwnershipAt(uint256 index) internal virtual {
1116         if (_packedOwnerships[index] == 0) {
1117             _packedOwnerships[index] = _packedOwnershipOf(index);
1118         }
1119     }
1120 
1121     /**
1122      * Returns the packed ownership data of `tokenId`.
1123      */
1124     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1125         uint256 curr = tokenId;
1126 
1127         unchecked {
1128             if (_startTokenId() <= curr)
1129                 if (curr < _currentIndex) {
1130                     uint256 packed = _packedOwnerships[curr];
1131                     // If not burned.
1132                     if (packed & _BITMASK_BURNED == 0) {
1133                         // Invariant:
1134                         // There will always be an initialized ownership slot
1135                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1136                         // before an unintialized ownership slot
1137                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1138                         // Hence, `curr` will not underflow.
1139                         //
1140                         // We can directly compare the packed value.
1141                         // If the address is zero, packed will be zero.
1142                         while (packed == 0) {
1143                             packed = _packedOwnerships[--curr];
1144                         }
1145                         return packed;
1146                     }
1147                 }
1148         }
1149         revert OwnerQueryForNonexistentToken();
1150     }
1151 
1152     /**
1153      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1154      */
1155     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1156         ownership.addr = address(uint160(packed));
1157         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1158         ownership.burned = packed & _BITMASK_BURNED != 0;
1159         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1160     }
1161 
1162     /**
1163      * @dev Packs ownership data into a single uint256.
1164      */
1165     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1166         assembly {
1167             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1168             owner := and(owner, _BITMASK_ADDRESS)
1169             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1170             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1171         }
1172     }
1173 
1174     /**
1175      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1176      */
1177     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1178         // For branchless setting of the `nextInitialized` flag.
1179         assembly {
1180             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1181             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1182         }
1183     }
1184 
1185     // =============================================================
1186     //                      APPROVAL OPERATIONS
1187     // =============================================================
1188 
1189     /**
1190      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1191      * The approval is cleared when the token is transferred.
1192      *
1193      * Only a single account can be approved at a time, so approving the
1194      * zero address clears previous approvals.
1195      *
1196      * Requirements:
1197      *
1198      * - The caller must own the token or be an approved operator.
1199      * - `tokenId` must exist.
1200      *
1201      * Emits an {Approval} event.
1202      */
1203     function approve(address to, uint256 tokenId) public payable virtual override {
1204         address owner = ownerOf(tokenId);
1205 
1206         if (_msgSenderERC721A() != owner)
1207             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1208                 revert ApprovalCallerNotOwnerNorApproved();
1209             }
1210 
1211         _tokenApprovals[tokenId].value = to;
1212         emit Approval(owner, to, tokenId);
1213     }
1214 
1215     /**
1216      * @dev Returns the account approved for `tokenId` token.
1217      *
1218      * Requirements:
1219      *
1220      * - `tokenId` must exist.
1221      */
1222     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1223         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1224 
1225         return _tokenApprovals[tokenId].value;
1226     }
1227 
1228     /**
1229      * @dev Approve or remove `operator` as an operator for the caller.
1230      * Operators can call {transferFrom} or {safeTransferFrom}
1231      * for any token owned by the caller.
1232      *
1233      * Requirements:
1234      *
1235      * - The `operator` cannot be the caller.
1236      *
1237      * Emits an {ApprovalForAll} event.
1238      */
1239     function setApprovalForAll(address operator, bool approved) public virtual override {
1240         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1241         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1242     }
1243 
1244     /**
1245      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1246      *
1247      * See {setApprovalForAll}.
1248      */
1249     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1250         return _operatorApprovals[owner][operator];
1251     }
1252 
1253     /**
1254      * @dev Returns whether `tokenId` exists.
1255      *
1256      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1257      *
1258      * Tokens start existing when they are minted. See {_mint}.
1259      */
1260     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1261         return
1262             _startTokenId() <= tokenId &&
1263             tokenId < _currentIndex && // If within bounds,
1264             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1265     }
1266 
1267     /**
1268      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1269      */
1270     function _isSenderApprovedOrOwner(
1271         address approvedAddress,
1272         address owner,
1273         address msgSender
1274     ) private pure returns (bool result) {
1275         assembly {
1276             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1277             owner := and(owner, _BITMASK_ADDRESS)
1278             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1279             msgSender := and(msgSender, _BITMASK_ADDRESS)
1280             // `msgSender == owner || msgSender == approvedAddress`.
1281             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1282         }
1283     }
1284 
1285     /**
1286      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1287      */
1288     function _getApprovedSlotAndAddress(uint256 tokenId)
1289         private
1290         view
1291         returns (uint256 approvedAddressSlot, address approvedAddress)
1292     {
1293         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1294         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1295         assembly {
1296             approvedAddressSlot := tokenApproval.slot
1297             approvedAddress := sload(approvedAddressSlot)
1298         }
1299     }
1300 
1301     // =============================================================
1302     //                      TRANSFER OPERATIONS
1303     // =============================================================
1304 
1305     /**
1306      * @dev Transfers `tokenId` from `from` to `to`.
1307      *
1308      * Requirements:
1309      *
1310      * - `from` cannot be the zero address.
1311      * - `to` cannot be the zero address.
1312      * - `tokenId` token must be owned by `from`.
1313      * - If the caller is not `from`, it must be approved to move this token
1314      * by either {approve} or {setApprovalForAll}.
1315      *
1316      * Emits a {Transfer} event.
1317      */
1318     function transferFrom(
1319         address from,
1320         address to,
1321         uint256 tokenId
1322     ) public payable virtual override {
1323         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1324 
1325         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1326 
1327         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1328 
1329         // The nested ifs save around 20+ gas over a compound boolean condition.
1330         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1331             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1332 
1333         if (to == address(0)) revert TransferToZeroAddress();
1334 
1335         _beforeTokenTransfers(from, to, tokenId, 1);
1336 
1337         // Clear approvals from the previous owner.
1338         assembly {
1339             if approvedAddress {
1340                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1341                 sstore(approvedAddressSlot, 0)
1342             }
1343         }
1344 
1345         // Underflow of the sender's balance is impossible because we check for
1346         // ownership above and the recipient's balance can't realistically overflow.
1347         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1348         unchecked {
1349             // We can directly increment and decrement the balances.
1350             --_packedAddressData[from]; // Updates: `balance -= 1`.
1351             ++_packedAddressData[to]; // Updates: `balance += 1`.
1352 
1353             // Updates:
1354             // - `address` to the next owner.
1355             // - `startTimestamp` to the timestamp of transfering.
1356             // - `burned` to `false`.
1357             // - `nextInitialized` to `true`.
1358             _packedOwnerships[tokenId] = _packOwnershipData(
1359                 to,
1360                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1361             );
1362 
1363             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1364             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1365                 uint256 nextTokenId = tokenId + 1;
1366                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1367                 if (_packedOwnerships[nextTokenId] == 0) {
1368                     // If the next slot is within bounds.
1369                     if (nextTokenId != _currentIndex) {
1370                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1371                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1372                     }
1373                 }
1374             }
1375         }
1376 
1377         emit Transfer(from, to, tokenId);
1378         _afterTokenTransfers(from, to, tokenId, 1);
1379     }
1380 
1381     /**
1382      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1383      */
1384     function safeTransferFrom(
1385         address from,
1386         address to,
1387         uint256 tokenId
1388     ) public payable virtual override {
1389         safeTransferFrom(from, to, tokenId, '');
1390     }
1391 
1392     /**
1393      * @dev Safely transfers `tokenId` token from `from` to `to`.
1394      *
1395      * Requirements:
1396      *
1397      * - `from` cannot be the zero address.
1398      * - `to` cannot be the zero address.
1399      * - `tokenId` token must exist and be owned by `from`.
1400      * - If the caller is not `from`, it must be approved to move this token
1401      * by either {approve} or {setApprovalForAll}.
1402      * - If `to` refers to a smart contract, it must implement
1403      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function safeTransferFrom(
1408         address from,
1409         address to,
1410         uint256 tokenId,
1411         bytes memory _data
1412     ) public payable virtual override {
1413         transferFrom(from, to, tokenId);
1414         if (to.code.length != 0)
1415             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1416                 revert TransferToNonERC721ReceiverImplementer();
1417             }
1418     }
1419 
1420     /**
1421      * @dev Hook that is called before a set of serially-ordered token IDs
1422      * are about to be transferred. This includes minting.
1423      * And also called before burning one token.
1424      *
1425      * `startTokenId` - the first token ID to be transferred.
1426      * `quantity` - the amount to be transferred.
1427      *
1428      * Calling conditions:
1429      *
1430      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1431      * transferred to `to`.
1432      * - When `from` is zero, `tokenId` will be minted for `to`.
1433      * - When `to` is zero, `tokenId` will be burned by `from`.
1434      * - `from` and `to` are never both zero.
1435      */
1436     function _beforeTokenTransfers(
1437         address from,
1438         address to,
1439         uint256 startTokenId,
1440         uint256 quantity
1441     ) internal virtual {}
1442 
1443     /**
1444      * @dev Hook that is called after a set of serially-ordered token IDs
1445      * have been transferred. This includes minting.
1446      * And also called after one token has been burned.
1447      *
1448      * `startTokenId` - the first token ID to be transferred.
1449      * `quantity` - the amount to be transferred.
1450      *
1451      * Calling conditions:
1452      *
1453      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1454      * transferred to `to`.
1455      * - When `from` is zero, `tokenId` has been minted for `to`.
1456      * - When `to` is zero, `tokenId` has been burned by `from`.
1457      * - `from` and `to` are never both zero.
1458      */
1459     function _afterTokenTransfers(
1460         address from,
1461         address to,
1462         uint256 startTokenId,
1463         uint256 quantity
1464     ) internal virtual {}
1465 
1466     /**
1467      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1468      *
1469      * `from` - Previous owner of the given token ID.
1470      * `to` - Target address that will receive the token.
1471      * `tokenId` - Token ID to be transferred.
1472      * `_data` - Optional data to send along with the call.
1473      *
1474      * Returns whether the call correctly returned the expected magic value.
1475      */
1476     function _checkContractOnERC721Received(
1477         address from,
1478         address to,
1479         uint256 tokenId,
1480         bytes memory _data
1481     ) private returns (bool) {
1482         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1483             bytes4 retval
1484         ) {
1485             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1486         } catch (bytes memory reason) {
1487             if (reason.length == 0) {
1488                 revert TransferToNonERC721ReceiverImplementer();
1489             } else {
1490                 assembly {
1491                     revert(add(32, reason), mload(reason))
1492                 }
1493             }
1494         }
1495     }
1496 
1497     // =============================================================
1498     //                        MINT OPERATIONS
1499     // =============================================================
1500 
1501     /**
1502      * @dev Mints `quantity` tokens and transfers them to `to`.
1503      *
1504      * Requirements:
1505      *
1506      * - `to` cannot be the zero address.
1507      * - `quantity` must be greater than 0.
1508      *
1509      * Emits a {Transfer} event for each mint.
1510      */
1511     function _mint(address to, uint256 quantity) internal virtual {
1512         uint256 startTokenId = _currentIndex;
1513         if (quantity == 0) revert MintZeroQuantity();
1514 
1515         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1516 
1517         // Overflows are incredibly unrealistic.
1518         // `balance` and `numberMinted` have a maximum limit of 2**64.
1519         // `tokenId` has a maximum limit of 2**256.
1520         unchecked {
1521             // Updates:
1522             // - `balance += quantity`.
1523             // - `numberMinted += quantity`.
1524             //
1525             // We can directly add to the `balance` and `numberMinted`.
1526             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1527 
1528             // Updates:
1529             // - `address` to the owner.
1530             // - `startTimestamp` to the timestamp of minting.
1531             // - `burned` to `false`.
1532             // - `nextInitialized` to `quantity == 1`.
1533             _packedOwnerships[startTokenId] = _packOwnershipData(
1534                 to,
1535                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1536             );
1537 
1538             uint256 toMasked;
1539             uint256 end = startTokenId + quantity;
1540 
1541             // Use assembly to loop and emit the `Transfer` event for gas savings.
1542             // The duplicated `log4` removes an extra check and reduces stack juggling.
1543             // The assembly, together with the surrounding Solidity code, have been
1544             // delicately arranged to nudge the compiler into producing optimized opcodes.
1545             assembly {
1546                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1547                 toMasked := and(to, _BITMASK_ADDRESS)
1548                 // Emit the `Transfer` event.
1549                 log4(
1550                     0, // Start of data (0, since no data).
1551                     0, // End of data (0, since no data).
1552                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1553                     0, // `address(0)`.
1554                     toMasked, // `to`.
1555                     startTokenId // `tokenId`.
1556                 )
1557 
1558                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1559                 // that overflows uint256 will make the loop run out of gas.
1560                 // The compiler will optimize the `iszero` away for performance.
1561                 for {
1562                     let tokenId := add(startTokenId, 1)
1563                 } iszero(eq(tokenId, end)) {
1564                     tokenId := add(tokenId, 1)
1565                 } {
1566                     // Emit the `Transfer` event. Similar to above.
1567                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1568                 }
1569             }
1570             if (toMasked == 0) revert MintToZeroAddress();
1571 
1572             _currentIndex = end;
1573         }
1574         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1575     }
1576 
1577     /**
1578      * @dev Mints `quantity` tokens and transfers them to `to`.
1579      *
1580      * This function is intended for efficient minting only during contract creation.
1581      *
1582      * It emits only one {ConsecutiveTransfer} as defined in
1583      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1584      * instead of a sequence of {Transfer} event(s).
1585      *
1586      * Calling this function outside of contract creation WILL make your contract
1587      * non-compliant with the ERC721 standard.
1588      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1589      * {ConsecutiveTransfer} event is only permissible during contract creation.
1590      *
1591      * Requirements:
1592      *
1593      * - `to` cannot be the zero address.
1594      * - `quantity` must be greater than 0.
1595      *
1596      * Emits a {ConsecutiveTransfer} event.
1597      */
1598     function _mintERC2309(address to, uint256 quantity) internal virtual {
1599         uint256 startTokenId = _currentIndex;
1600         if (to == address(0)) revert MintToZeroAddress();
1601         if (quantity == 0) revert MintZeroQuantity();
1602         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1603 
1604         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1605 
1606         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1607         unchecked {
1608             // Updates:
1609             // - `balance += quantity`.
1610             // - `numberMinted += quantity`.
1611             //
1612             // We can directly add to the `balance` and `numberMinted`.
1613             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1614 
1615             // Updates:
1616             // - `address` to the owner.
1617             // - `startTimestamp` to the timestamp of minting.
1618             // - `burned` to `false`.
1619             // - `nextInitialized` to `quantity == 1`.
1620             _packedOwnerships[startTokenId] = _packOwnershipData(
1621                 to,
1622                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1623             );
1624 
1625             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1626 
1627             _currentIndex = startTokenId + quantity;
1628         }
1629         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1630     }
1631 
1632     /**
1633      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1634      *
1635      * Requirements:
1636      *
1637      * - If `to` refers to a smart contract, it must implement
1638      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1639      * - `quantity` must be greater than 0.
1640      *
1641      * See {_mint}.
1642      *
1643      * Emits a {Transfer} event for each mint.
1644      */
1645     function _safeMint(
1646         address to,
1647         uint256 quantity,
1648         bytes memory _data
1649     ) internal virtual {
1650         _mint(to, quantity);
1651 
1652         unchecked {
1653             if (to.code.length != 0) {
1654                 uint256 end = _currentIndex;
1655                 uint256 index = end - quantity;
1656                 do {
1657                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1658                         revert TransferToNonERC721ReceiverImplementer();
1659                     }
1660                 } while (index < end);
1661                 // Reentrancy protection.
1662                 if (_currentIndex != end) revert();
1663             }
1664         }
1665     }
1666 
1667     /**
1668      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1669      */
1670     function _safeMint(address to, uint256 quantity) internal virtual {
1671         _safeMint(to, quantity, '');
1672     }
1673 
1674     // =============================================================
1675     //                        BURN OPERATIONS
1676     // =============================================================
1677 
1678     /**
1679      * @dev Equivalent to `_burn(tokenId, false)`.
1680      */
1681     function _burn(uint256 tokenId) internal virtual {
1682         _burn(tokenId, false);
1683     }
1684 
1685     /**
1686      * @dev Destroys `tokenId`.
1687      * The approval is cleared when the token is burned.
1688      *
1689      * Requirements:
1690      *
1691      * - `tokenId` must exist.
1692      *
1693      * Emits a {Transfer} event.
1694      */
1695     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1696         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1697 
1698         address from = address(uint160(prevOwnershipPacked));
1699 
1700         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1701 
1702         if (approvalCheck) {
1703             // The nested ifs save around 20+ gas over a compound boolean condition.
1704             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1705                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1706         }
1707 
1708         _beforeTokenTransfers(from, address(0), tokenId, 1);
1709 
1710         // Clear approvals from the previous owner.
1711         assembly {
1712             if approvedAddress {
1713                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1714                 sstore(approvedAddressSlot, 0)
1715             }
1716         }
1717 
1718         // Underflow of the sender's balance is impossible because we check for
1719         // ownership above and the recipient's balance can't realistically overflow.
1720         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1721         unchecked {
1722             // Updates:
1723             // - `balance -= 1`.
1724             // - `numberBurned += 1`.
1725             //
1726             // We can directly decrement the balance, and increment the number burned.
1727             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1728             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1729 
1730             // Updates:
1731             // - `address` to the last owner.
1732             // - `startTimestamp` to the timestamp of burning.
1733             // - `burned` to `true`.
1734             // - `nextInitialized` to `true`.
1735             _packedOwnerships[tokenId] = _packOwnershipData(
1736                 from,
1737                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1738             );
1739 
1740             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1741             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1742                 uint256 nextTokenId = tokenId + 1;
1743                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1744                 if (_packedOwnerships[nextTokenId] == 0) {
1745                     // If the next slot is within bounds.
1746                     if (nextTokenId != _currentIndex) {
1747                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1748                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1749                     }
1750                 }
1751             }
1752         }
1753 
1754         emit Transfer(from, address(0), tokenId);
1755         _afterTokenTransfers(from, address(0), tokenId, 1);
1756 
1757         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1758         unchecked {
1759             _burnCounter++;
1760         }
1761     }
1762 
1763     // =============================================================
1764     //                     EXTRA DATA OPERATIONS
1765     // =============================================================
1766 
1767     /**
1768      * @dev Directly sets the extra data for the ownership data `index`.
1769      */
1770     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1771         uint256 packed = _packedOwnerships[index];
1772         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1773         uint256 extraDataCasted;
1774         // Cast `extraData` with assembly to avoid redundant masking.
1775         assembly {
1776             extraDataCasted := extraData
1777         }
1778         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1779         _packedOwnerships[index] = packed;
1780     }
1781 
1782     /**
1783      * @dev Called during each token transfer to set the 24bit `extraData` field.
1784      * Intended to be overridden by the cosumer contract.
1785      *
1786      * `previousExtraData` - the value of `extraData` before transfer.
1787      *
1788      * Calling conditions:
1789      *
1790      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1791      * transferred to `to`.
1792      * - When `from` is zero, `tokenId` will be minted for `to`.
1793      * - When `to` is zero, `tokenId` will be burned by `from`.
1794      * - `from` and `to` are never both zero.
1795      */
1796     function _extraData(
1797         address from,
1798         address to,
1799         uint24 previousExtraData
1800     ) internal view virtual returns (uint24) {}
1801 
1802     /**
1803      * @dev Returns the next extra data for the packed ownership data.
1804      * The returned result is shifted into position.
1805      */
1806     function _nextExtraData(
1807         address from,
1808         address to,
1809         uint256 prevOwnershipPacked
1810     ) private view returns (uint256) {
1811         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1812         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1813     }
1814 
1815     // =============================================================
1816     //                       OTHER OPERATIONS
1817     // =============================================================
1818 
1819     /**
1820      * @dev Returns the message sender (defaults to `msg.sender`).
1821      *
1822      * If you are writing GSN compatible contracts, you need to override this function.
1823      */
1824     function _msgSenderERC721A() internal view virtual returns (address) {
1825         return msg.sender;
1826     }
1827 
1828     /**
1829      * @dev Converts a uint256 to its ASCII string decimal representation.
1830      */
1831     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1832         assembly {
1833             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1834             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1835             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1836             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1837             let m := add(mload(0x40), 0xa0)
1838             // Update the free memory pointer to allocate.
1839             mstore(0x40, m)
1840             // Assign the `str` to the end.
1841             str := sub(m, 0x20)
1842             // Zeroize the slot after the string.
1843             mstore(str, 0)
1844 
1845             // Cache the end of the memory to calculate the length later.
1846             let end := str
1847 
1848             // We write the string from rightmost digit to leftmost digit.
1849             // The following is essentially a do-while loop that also handles the zero case.
1850             // prettier-ignore
1851             for { let temp := value } 1 {} {
1852                 str := sub(str, 1)
1853                 // Write the character to the pointer.
1854                 // The ASCII index of the '0' character is 48.
1855                 mstore8(str, add(48, mod(temp, 10)))
1856                 // Keep dividing `temp` until zero.
1857                 temp := div(temp, 10)
1858                 // prettier-ignore
1859                 if iszero(temp) { break }
1860             }
1861 
1862             let length := sub(end, str)
1863             // Move the pointer 32 bytes leftwards to make room for the length.
1864             str := sub(str, 0x20)
1865             // Store the length.
1866             mstore(str, length)
1867         }
1868     }
1869 }
1870 
1871 // File: @openzeppelin/contracts/utils/Context.sol
1872 
1873 
1874 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1875 
1876 pragma solidity ^0.8.0;
1877 
1878 /**
1879  * @dev Provides information about the current execution context, including the
1880  * sender of the transaction and its data. While these are generally available
1881  * via msg.sender and msg.data, they should not be accessed in such a direct
1882  * manner, since when dealing with meta-transactions the account sending and
1883  * paying for execution may not be the actual sender (as far as an application
1884  * is concerned).
1885  *
1886  * This contract is only required for intermediate, library-like contracts.
1887  */
1888 abstract contract Context {
1889     function _msgSender() internal view virtual returns (address) {
1890         return msg.sender;
1891     }
1892 
1893     function _msgData() internal view virtual returns (bytes calldata) {
1894         return msg.data;
1895     }
1896 }
1897 
1898 // File: @openzeppelin/contracts/access/Ownable.sol
1899 
1900 
1901 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1902 
1903 pragma solidity ^0.8.0;
1904 
1905 
1906 /**
1907  * @dev Contract module which provides a basic access control mechanism, where
1908  * there is an account (an owner) that can be granted exclusive access to
1909  * specific functions.
1910  *
1911  * By default, the owner account will be the one that deploys the contract. This
1912  * can later be changed with {transferOwnership}.
1913  *
1914  * This module is used through inheritance. It will make available the modifier
1915  * `onlyOwner`, which can be applied to your functions to restrict their use to
1916  * the owner.
1917  */
1918 abstract contract Ownable is Context {
1919     address private _owner;
1920 
1921     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1922 
1923     /**
1924      * @dev Initializes the contract setting the deployer as the initial owner.
1925      */
1926     constructor() {
1927         _transferOwnership(_msgSender());
1928     }
1929 
1930     /**
1931      * @dev Throws if called by any account other than the owner.
1932      */
1933     modifier onlyOwner() {
1934         _checkOwner();
1935         _;
1936     }
1937 
1938     /**
1939      * @dev Returns the address of the current owner.
1940      */
1941     function owner() public view virtual returns (address) {
1942         return _owner;
1943     }
1944 
1945     /**
1946      * @dev Throws if the sender is not the owner.
1947      */
1948     function _checkOwner() internal view virtual {
1949         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1950     }
1951 
1952     /**
1953      * @dev Leaves the contract without owner. It will not be possible to call
1954      * `onlyOwner` functions anymore. Can only be called by the current owner.
1955      *
1956      * NOTE: Renouncing ownership will leave the contract without an owner,
1957      * thereby removing any functionality that is only available to the owner.
1958      */
1959     function renounceOwnership() public virtual onlyOwner {
1960         _transferOwnership(address(0));
1961     }
1962 
1963     /**
1964      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1965      * Can only be called by the current owner.
1966      */
1967     function transferOwnership(address newOwner) public virtual onlyOwner {
1968         require(newOwner != address(0), "Ownable: new owner is the zero address");
1969         _transferOwnership(newOwner);
1970     }
1971 
1972     /**
1973      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1974      * Internal function without access restriction.
1975      */
1976     function _transferOwnership(address newOwner) internal virtual {
1977         address oldOwner = _owner;
1978         _owner = newOwner;
1979         emit OwnershipTransferred(oldOwner, newOwner);
1980     }
1981 }
1982 
1983 // File: 888ELE.sol
1984 
1985 
1986 
1987 pragma solidity ^0.8.9;
1988 
1989 
1990 
1991 
1992 
1993 contract Elephants is ERC721A, Ownable, ReentrancyGuard {
1994 
1995     using Strings for uint256;
1996 
1997     mapping(address => uint) public mintedPerAddress;
1998     uint256 public mintCost = 0.0 ether;
1999     uint256 public maxSupply = 888;
2000     uint256 public maxPerTXN = 2;
2001     string internal baseUri = "";
2002     string internal notRevealedURI = "";
2003     bool private isRevealed = true;
2004     bool private saleStarted = true;
2005 
2006     constructor(string memory _baseUri) ERC721A("888ephants", "8PHT") {
2007         baseUri = _baseUri;
2008     }
2009     
2010     function mint(uint256 _amount) external payable nonReentrant {
2011         require(saleStarted, "Sale not started yet.");
2012         mintModifier(_amount);
2013     }
2014 
2015     function mintModifier(uint256 _amount) internal {
2016         require(_amount <= maxPerTXN && _amount > 0, "Max 2 per Transaction.");
2017         uint256 free = mintedPerAddress[msg.sender] == 0 ? 2 : 0;
2018         require(msg.value >= mintCost * (_amount - free), "Two Free, rest 0.0 ETH.");
2019         mintedPerAddress[msg.sender] += _amount;
2020         sendMint(_msgSender(), _amount);
2021     }
2022 
2023     function sendMint(address _wallet, uint256 _amount) internal {
2024         require(_amount + totalSupply() <= maxSupply, "0 Supply Left.");
2025         _mint(_wallet, _amount);
2026     }
2027     
2028     function devMint(address _wallet, uint256 _amount) public onlyOwner {
2029   	    uint256 totalMinted = totalSupply();
2030 	    require(totalMinted + _amount <= maxSupply);
2031         _mint(_wallet, _amount);
2032     }
2033     
2034     function setMaxPerTXN(uint256 _max) external onlyOwner {
2035         maxPerTXN = _max;
2036     }
2037 
2038     function toggleSale() external onlyOwner {
2039         saleStarted = !saleStarted;
2040     }
2041 
2042     function toggleRevealed() external onlyOwner {
2043         isRevealed = !isRevealed;
2044     }
2045     
2046     function setCost(uint256 newCost) external onlyOwner {
2047         mintCost = newCost;
2048     }
2049 
2050     function setMetadata(string calldata newUri) external onlyOwner {
2051         baseUri = newUri;
2052     }
2053 
2054     function setNotRevealedURI(string calldata newUri) external onlyOwner {
2055         notRevealedURI = newUri;   
2056     }
2057 
2058     function _baseURI() internal override view returns (string memory) {
2059         return baseUri;
2060     }
2061 
2062    
2063     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2064         require(_exists(_tokenId), 'URI query for nonexistent token');
2065         if(isRevealed == true) {
2066             string memory currentBaseURI = _baseURI();
2067             return bytes(currentBaseURI).length > 0
2068             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
2069             : '';
2070         }
2071         else {
2072             return string(abi.encodePacked(notRevealedURI));
2073         }
2074     }
2075 
2076     function _startTokenId() internal view virtual override returns (uint256) {
2077         return 1;
2078     }
2079 
2080     function transferFunds() external onlyOwner {
2081         payable(_msgSender()).transfer(address(this).balance);
2082     }
2083 
2084 
2085     
2086 }