1 /**
2  *Submitted for verification at Etherscan.io on 2023-01-01
3 */
4 
5 // SPDX-License-Identifier: MIT
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
351 pragma solidity ^0.8.4;
352 
353 /**
354  * @dev Interface of ERC721A.
355  */
356 interface IERC721A {
357     /**
358      * The caller must own the token or be an approved operator.
359      */
360     error ApprovalCallerNotOwnerNorApproved();
361 
362     /**
363      * The token does not exist.
364      */
365     error ApprovalQueryForNonexistentToken();
366 
367     /**
368      * Cannot query the balance for the zero address.
369      */
370     error BalanceQueryForZeroAddress();
371 
372     /**
373      * Cannot mint to the zero address.
374      */
375     error MintToZeroAddress();
376 
377     /**
378      * The quantity of tokens minted must be more than zero.
379      */
380     error MintZeroQuantity();
381 
382     /**
383      * The token does not exist.
384      */
385     error OwnerQueryForNonexistentToken();
386 
387     /**
388      * The caller must own the token or be an approved operator.
389      */
390     error TransferCallerNotOwnerNorApproved();
391 
392     /**
393      * The token must be owned by `from`.
394      */
395     error TransferFromIncorrectOwner();
396 
397     /**
398      * Cannot safely transfer to a contract that does not implement the
399      * ERC721Receiver interface.
400      */
401     error TransferToNonERC721ReceiverImplementer();
402 
403     /**
404      * Cannot transfer to the zero address.
405      */
406     error TransferToZeroAddress();
407 
408     /**
409      * The token does not exist.
410      */
411     error URIQueryForNonexistentToken();
412 
413     /**
414      * The `quantity` minted with ERC2309 exceeds the safety limit.
415      */
416     error MintERC2309QuantityExceedsLimit();
417 
418     /**
419      * The `extraData` cannot be set on an unintialized ownership slot.
420      */
421     error OwnershipNotInitializedForExtraData();
422 
423     // =============================================================
424     //                            STRUCTS
425     // =============================================================
426 
427     struct TokenOwnership {
428         // The address of the owner.
429         address addr;
430         // Stores the start time of ownership with minimal overhead for tokenomics.
431         uint64 startTimestamp;
432         // Whether the token has been burned.
433         bool burned;
434         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
435         uint24 extraData;
436     }
437 
438     // =============================================================
439     //                         TOKEN COUNTERS
440     // =============================================================
441 
442     /**
443      * @dev Returns the total number of tokens in existence.
444      * Burned tokens will reduce the count.
445      * To get the total number of tokens minted, please see {_totalMinted}.
446      */
447     function totalSupply() external view returns (uint256);
448 
449     // =============================================================
450     //                            IERC165
451     // =============================================================
452 
453     /**
454      * @dev Returns true if this contract implements the interface defined by
455      * `interfaceId`. See the corresponding
456      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
457      * to learn more about how these ids are created.
458      *
459      * This function call must use less than 30000 gas.
460      */
461     function supportsInterface(bytes4 interfaceId) external view returns (bool);
462 
463     // =============================================================
464     //                            IERC721
465     // =============================================================
466 
467     /**
468      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
469      */
470     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
471 
472     /**
473      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
474      */
475     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
476 
477     /**
478      * @dev Emitted when `owner` enables or disables
479      * (`approved`) `operator` to manage all of its assets.
480      */
481     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
482 
483     /**
484      * @dev Returns the number of tokens in `owner`'s account.
485      */
486     function balanceOf(address owner) external view returns (uint256 balance);
487 
488     /**
489      * @dev Returns the owner of the `tokenId` token.
490      *
491      * Requirements:
492      *
493      * - `tokenId` must exist.
494      */
495     function ownerOf(uint256 tokenId) external view returns (address owner);
496 
497     /**
498      * @dev Safely transfers `tokenId` token from `from` to `to`,
499      * checking first that contract recipients are aware of the ERC721 protocol
500      * to prevent tokens from being forever locked.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must exist and be owned by `from`.
507      * - If the caller is not `from`, it must be have been allowed to move
508      * this token by either {approve} or {setApprovalForAll}.
509      * - If `to` refers to a smart contract, it must implement
510      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
511      *
512      * Emits a {Transfer} event.
513      */
514     function safeTransferFrom(
515         address from,
516         address to,
517         uint256 tokenId,
518         bytes calldata data
519     ) external payable;
520 
521     /**
522      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
523      */
524     function safeTransferFrom(
525         address from,
526         address to,
527         uint256 tokenId
528     ) external payable;
529 
530     /**
531      * @dev Transfers `tokenId` from `from` to `to`.
532      *
533      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
534      * whenever possible.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must be owned by `from`.
541      * - If the caller is not `from`, it must be approved to move this token
542      * by either {approve} or {setApprovalForAll}.
543      *
544      * Emits a {Transfer} event.
545      */
546     function transferFrom(
547         address from,
548         address to,
549         uint256 tokenId
550     ) external payable;
551 
552     /**
553      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
554      * The approval is cleared when the token is transferred.
555      *
556      * Only a single account can be approved at a time, so approving the
557      * zero address clears previous approvals.
558      *
559      * Requirements:
560      *
561      * - The caller must own the token or be an approved operator.
562      * - `tokenId` must exist.
563      *
564      * Emits an {Approval} event.
565      */
566     function approve(address to, uint256 tokenId) external payable;
567 
568     /**
569      * @dev Approve or remove `operator` as an operator for the caller.
570      * Operators can call {transferFrom} or {safeTransferFrom}
571      * for any token owned by the caller.
572      *
573      * Requirements:
574      *
575      * - The `operator` cannot be the caller.
576      *
577      * Emits an {ApprovalForAll} event.
578      */
579     function setApprovalForAll(address operator, bool _approved) external;
580 
581     /**
582      * @dev Returns the account approved for `tokenId` token.
583      *
584      * Requirements:
585      *
586      * - `tokenId` must exist.
587      */
588     function getApproved(uint256 tokenId) external view returns (address operator);
589 
590     /**
591      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
592      *
593      * See {setApprovalForAll}.
594      */
595     function isApprovedForAll(address owner, address operator) external view returns (bool);
596 
597     // =============================================================
598     //                        IERC721Metadata
599     // =============================================================
600 
601     /**
602      * @dev Returns the token collection name.
603      */
604     function name() external view returns (string memory);
605 
606     /**
607      * @dev Returns the token collection symbol.
608      */
609     function symbol() external view returns (string memory);
610 
611     /**
612      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
613      */
614     function tokenURI(uint256 tokenId) external view returns (string memory);
615 
616     // =============================================================
617     //                           IERC2309
618     // =============================================================
619 
620     /**
621      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
622      * (inclusive) is transferred from `from` to `to`, as defined in the
623      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
624      *
625      * See {_mintERC2309} for more details.
626      */
627     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
628 }
629 
630 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 // CAUTION
635 // This version of SafeMath should only be used with Solidity 0.8 or later,
636 // because it relies on the compiler's built in overflow checks.
637 
638 /**
639  * @dev Wrappers over Solidity's arithmetic operations.
640  *
641  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
642  * now has built in overflow checking.
643  */
644 library SafeMath {
645     /**
646      * @dev Returns the addition of two unsigned integers, with an overflow flag.
647      *
648      * _Available since v3.4._
649      */
650     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
651         unchecked {
652             uint256 c = a + b;
653             if (c < a) return (false, 0);
654             return (true, c);
655         }
656     }
657 
658     /**
659      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
660      *
661      * _Available since v3.4._
662      */
663     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
664         unchecked {
665             if (b > a) return (false, 0);
666             return (true, a - b);
667         }
668     }
669 
670     /**
671      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
672      *
673      * _Available since v3.4._
674      */
675     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
676         unchecked {
677             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
678             // benefit is lost if 'b' is also tested.
679             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
680             if (a == 0) return (true, 0);
681             uint256 c = a * b;
682             if (c / a != b) return (false, 0);
683             return (true, c);
684         }
685     }
686 
687     /**
688      * @dev Returns the division of two unsigned integers, with a division by zero flag.
689      *
690      * _Available since v3.4._
691      */
692     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
693         unchecked {
694             if (b == 0) return (false, 0);
695             return (true, a / b);
696         }
697     }
698 
699     /**
700      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
701      *
702      * _Available since v3.4._
703      */
704     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
705         unchecked {
706             if (b == 0) return (false, 0);
707             return (true, a % b);
708         }
709     }
710 
711     /**
712      * @dev Returns the addition of two unsigned integers, reverting on
713      * overflow.
714      *
715      * Counterpart to Solidity's `+` operator.
716      *
717      * Requirements:
718      *
719      * - Addition cannot overflow.
720      */
721     function add(uint256 a, uint256 b) internal pure returns (uint256) {
722         return a + b;
723     }
724 
725     /**
726      * @dev Returns the subtraction of two unsigned integers, reverting on
727      * overflow (when the result is negative).
728      *
729      * Counterpart to Solidity's `-` operator.
730      *
731      * Requirements:
732      *
733      * - Subtraction cannot overflow.
734      */
735     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
736         return a - b;
737     }
738 
739     /**
740      * @dev Returns the multiplication of two unsigned integers, reverting on
741      * overflow.
742      *
743      * Counterpart to Solidity's `*` operator.
744      *
745      * Requirements:
746      *
747      * - Multiplication cannot overflow.
748      */
749     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
750         return a * b;
751     }
752 
753     /**
754      * @dev Returns the integer division of two unsigned integers, reverting on
755      * division by zero. The result is rounded towards zero.
756      *
757      * Counterpart to Solidity's `/` operator.
758      *
759      * Requirements:
760      *
761      * - The divisor cannot be zero.
762      */
763     function div(uint256 a, uint256 b) internal pure returns (uint256) {
764         return a / b;
765     }
766 
767     /**
768      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
769      * reverting when dividing by zero.
770      *
771      * Counterpart to Solidity's `%` operator. This function uses a `revert`
772      * opcode (which leaves remaining gas untouched) while Solidity uses an
773      * invalid opcode to revert (consuming all remaining gas).
774      *
775      * Requirements:
776      *
777      * - The divisor cannot be zero.
778      */
779     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
780         return a % b;
781     }
782 
783     /**
784      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
785      * overflow (when the result is negative).
786      *
787      * CAUTION: This function is deprecated because it requires allocating memory for the error
788      * message unnecessarily. For custom revert reasons use {trySub}.
789      *
790      * Counterpart to Solidity's `-` operator.
791      *
792      * Requirements:
793      *
794      * - Subtraction cannot overflow.
795      */
796     function sub(
797         uint256 a,
798         uint256 b,
799         string memory errorMessage
800     ) internal pure returns (uint256) {
801         unchecked {
802             require(b <= a, errorMessage);
803             return a - b;
804         }
805     }
806 
807     /**
808      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
809      * division by zero. The result is rounded towards zero.
810      *
811      * Counterpart to Solidity's `/` operator. Note: this function uses a
812      * `revert` opcode (which leaves remaining gas untouched) while Solidity
813      * uses an invalid opcode to revert (consuming all remaining gas).
814      *
815      * Requirements:
816      *
817      * - The divisor cannot be zero.
818      */
819     function div(
820         uint256 a,
821         uint256 b,
822         string memory errorMessage
823     ) internal pure returns (uint256) {
824         unchecked {
825             require(b > 0, errorMessage);
826             return a / b;
827         }
828     }
829 
830     /**
831      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
832      * reverting with custom message when dividing by zero.
833      *
834      * CAUTION: This function is deprecated because it requires allocating memory for the error
835      * message unnecessarily. For custom revert reasons use {tryMod}.
836      *
837      * Counterpart to Solidity's `%` operator. This function uses a `revert`
838      * opcode (which leaves remaining gas untouched) while Solidity uses an
839      * invalid opcode to revert (consuming all remaining gas).
840      *
841      * Requirements:
842      *
843      * - The divisor cannot be zero.
844      */
845     function mod(
846         uint256 a,
847         uint256 b,
848         string memory errorMessage
849     ) internal pure returns (uint256) {
850         unchecked {
851             require(b > 0, errorMessage);
852             return a % b;
853         }
854     }
855 }
856 
857 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
858 
859 pragma solidity ^0.8.0;
860 
861 /**
862  * @dev String operations.
863  */
864 library Strings {
865     bytes16 private constant _SYMBOLS = "0123456789abcdef";
866     uint8 private constant _ADDRESS_LENGTH = 20;
867 
868     /**
869      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
870      */
871     function toString(uint256 value) internal pure returns (string memory) {
872         unchecked {
873             uint256 length = Math.log10(value) + 1;
874             string memory buffer = new string(length);
875             uint256 ptr;
876             /// @solidity memory-safe-assembly
877             assembly {
878                 ptr := add(buffer, add(32, length))
879             }
880             while (true) {
881                 ptr--;
882                 /// @solidity memory-safe-assembly
883                 assembly {
884                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
885                 }
886                 value /= 10;
887                 if (value == 0) break;
888             }
889             return buffer;
890         }
891     }
892 
893     /**
894      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
895      */
896     function toHexString(uint256 value) internal pure returns (string memory) {
897         unchecked {
898             return toHexString(value, Math.log256(value) + 1);
899         }
900     }
901 
902     /**
903      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
904      */
905     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
906         bytes memory buffer = new bytes(2 * length + 2);
907         buffer[0] = "0";
908         buffer[1] = "x";
909         for (uint256 i = 2 * length + 1; i > 1; --i) {
910             buffer[i] = _SYMBOLS[value & 0xf];
911             value >>= 4;
912         }
913         require(value == 0, "Strings: hex length insufficient");
914         return string(buffer);
915     }
916 
917     /**
918      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
919      */
920     function toHexString(address addr) internal pure returns (string memory) {
921         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
922     }
923 }
924 
925 
926 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
927 
928 pragma solidity ^0.8.0;
929 
930 /**
931  * @dev Provides information about the current execution context, including the
932  * sender of the transaction and its data. While these are generally available
933  * via msg.sender and msg.data, they should not be accessed in such a direct
934  * manner, since when dealing with meta-transactions the account sending and
935  * paying for execution may not be the actual sender (as far as an application
936  * is concerned).
937  *
938  * This contract is only required for intermediate, library-like contracts.
939  */
940 abstract contract Context {
941     function _msgSender() internal view virtual returns (address) {
942         return msg.sender;
943     }
944 
945     function _msgData() internal view virtual returns (bytes calldata) {
946         return msg.data;
947     }
948 }
949 
950 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
951 
952 pragma solidity ^0.8.1;
953 
954 /**
955  * @dev Collection of functions related to the address type
956  */
957 library Address {
958     /**
959      * @dev Returns true if `account` is a contract.
960      *
961      * [IMPORTANT]
962      * ====
963      * It is unsafe to assume that an address for which this function returns
964      * false is an externally-owned account (EOA) and not a contract.
965      *
966      * Among others, `isContract` will return false for the following
967      * types of addresses:
968      *
969      *  - an externally-owned account
970      *  - a contract in construction
971      *  - an address where a contract will be created
972      *  - an address where a contract lived, but was destroyed
973      * ====
974      *
975      * [IMPORTANT]
976      * ====
977      * You shouldn't rely on `isContract` to protect against flash loan attacks!
978      *
979      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
980      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
981      * constructor.
982      * ====
983      */
984     function isContract(address account) internal view returns (bool) {
985         // This method relies on extcodesize/address.code.length, which returns 0
986         // for contracts in construction, since the code is only stored at the end
987         // of the constructor execution.
988 
989         return account.code.length > 0;
990     }
991 
992     /**
993      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
994      * `recipient`, forwarding all available gas and reverting on errors.
995      *
996      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
997      * of certain opcodes, possibly making contracts go over the 2300 gas limit
998      * imposed by `transfer`, making them unable to receive funds via
999      * `transfer`. {sendValue} removes this limitation.
1000      *
1001      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1002      *
1003      * IMPORTANT: because control is transferred to `recipient`, care must be
1004      * taken to not create reentrancy vulnerabilities. Consider using
1005      * {ReentrancyGuard} or the
1006      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1007      */
1008     function sendValue(address payable recipient, uint256 amount) internal {
1009         require(address(this).balance >= amount, "Address: insufficient balance");
1010 
1011         (bool success, ) = recipient.call{value: amount}("");
1012         require(success, "Address: unable to send value, recipient may have reverted");
1013     }
1014 
1015     /**
1016      * @dev Performs a Solidity function call using a low level `call`. A
1017      * plain `call` is an unsafe replacement for a function call: use this
1018      * function instead.
1019      *
1020      * If `target` reverts with a revert reason, it is bubbled up by this
1021      * function (like regular Solidity function calls).
1022      *
1023      * Returns the raw returned data. To convert to the expected return value,
1024      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1025      *
1026      * Requirements:
1027      *
1028      * - `target` must be a contract.
1029      * - calling `target` with `data` must not revert.
1030      *
1031      * _Available since v3.1._
1032      */
1033     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1034         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1035     }
1036 
1037     /**
1038      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1039      * `errorMessage` as a fallback revert reason when `target` reverts.
1040      *
1041      * _Available since v3.1._
1042      */
1043     function functionCall(
1044         address target,
1045         bytes memory data,
1046         string memory errorMessage
1047     ) internal returns (bytes memory) {
1048         return functionCallWithValue(target, data, 0, errorMessage);
1049     }
1050 
1051     /**
1052      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1053      * but also transferring `value` wei to `target`.
1054      *
1055      * Requirements:
1056      *
1057      * - the calling contract must have an ETH balance of at least `value`.
1058      * - the called Solidity function must be `payable`.
1059      *
1060      * _Available since v3.1._
1061      */
1062     function functionCallWithValue(
1063         address target,
1064         bytes memory data,
1065         uint256 value
1066     ) internal returns (bytes memory) {
1067         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1068     }
1069 
1070     /**
1071      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1072      * with `errorMessage` as a fallback revert reason when `target` reverts.
1073      *
1074      * _Available since v3.1._
1075      */
1076     function functionCallWithValue(
1077         address target,
1078         bytes memory data,
1079         uint256 value,
1080         string memory errorMessage
1081     ) internal returns (bytes memory) {
1082         require(address(this).balance >= value, "Address: insufficient balance for call");
1083         (bool success, bytes memory returndata) = target.call{value: value}(data);
1084         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1085     }
1086 
1087     /**
1088      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1089      * but performing a static call.
1090      *
1091      * _Available since v3.3._
1092      */
1093     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1094         return functionStaticCall(target, data, "Address: low-level static call failed");
1095     }
1096 
1097     /**
1098      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1099      * but performing a static call.
1100      *
1101      * _Available since v3.3._
1102      */
1103     function functionStaticCall(
1104         address target,
1105         bytes memory data,
1106         string memory errorMessage
1107     ) internal view returns (bytes memory) {
1108         (bool success, bytes memory returndata) = target.staticcall(data);
1109         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1110     }
1111 
1112     /**
1113      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1114      * but performing a delegate call.
1115      *
1116      * _Available since v3.4._
1117      */
1118     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1119         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1120     }
1121 
1122     /**
1123      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1124      * but performing a delegate call.
1125      *
1126      * _Available since v3.4._
1127      */
1128     function functionDelegateCall(
1129         address target,
1130         bytes memory data,
1131         string memory errorMessage
1132     ) internal returns (bytes memory) {
1133         (bool success, bytes memory returndata) = target.delegatecall(data);
1134         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1135     }
1136 
1137     /**
1138      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1139      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1140      *
1141      * _Available since v4.8._
1142      */
1143     function verifyCallResultFromTarget(
1144         address target,
1145         bool success,
1146         bytes memory returndata,
1147         string memory errorMessage
1148     ) internal view returns (bytes memory) {
1149         if (success) {
1150             if (returndata.length == 0) {
1151                 // only check isContract if the call was successful and the return data is empty
1152                 // otherwise we already know that it was a contract
1153                 require(isContract(target), "Address: call to non-contract");
1154             }
1155             return returndata;
1156         } else {
1157             _revert(returndata, errorMessage);
1158         }
1159     }
1160 
1161     /**
1162      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1163      * revert reason or using the provided one.
1164      *
1165      * _Available since v4.3._
1166      */
1167     function verifyCallResult(
1168         bool success,
1169         bytes memory returndata,
1170         string memory errorMessage
1171     ) internal pure returns (bytes memory) {
1172         if (success) {
1173             return returndata;
1174         } else {
1175             _revert(returndata, errorMessage);
1176         }
1177     }
1178 
1179     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1180         // Look for revert reason and bubble it up if present
1181         if (returndata.length > 0) {
1182             // The easiest way to bubble the revert reason is using memory via assembly
1183             /// @solidity memory-safe-assembly
1184             assembly {
1185                 let returndata_size := mload(returndata)
1186                 revert(add(32, returndata), returndata_size)
1187             }
1188         } else {
1189             revert(errorMessage);
1190         }
1191     }
1192 }
1193 
1194 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1195 
1196 pragma solidity ^0.8.0;
1197 
1198 /**
1199  * @dev Contract module which provides a basic access control mechanism, where
1200  * there is an account (an owner) that can be granted exclusive access to
1201  * specific functions.
1202  *
1203  * By default, the owner account will be the one that deploys the contract. This
1204  * can later be changed with {transferOwnership}.
1205  *
1206  * This module is used through inheritance. It will make available the modifier
1207  * `onlyOwner`, which can be applied to your functions to restrict their use to
1208  * the owner.
1209  */
1210 abstract contract Ownable is Context {
1211     address private _owner;
1212 
1213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1214 
1215     /**
1216      * @dev Initializes the contract setting the deployer as the initial owner.
1217      */
1218     constructor() {
1219         _transferOwnership(_msgSender());
1220     }
1221 
1222     /**
1223      * @dev Throws if called by any account other than the owner.
1224      */
1225     modifier onlyOwner() {
1226         _checkOwner();
1227         _;
1228     }
1229 
1230     /**
1231      * @dev Returns the address of the current owner.
1232      */
1233     function owner() public view virtual returns (address) {
1234         return _owner;
1235     }
1236 
1237     /**
1238      * @dev Throws if the sender is not the owner.
1239      */
1240     function _checkOwner() internal view virtual {
1241         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1242     }
1243 
1244     /**
1245      * @dev Leaves the contract without owner. It will not be possible to call
1246      * `onlyOwner` functions anymore. Can only be called by the current owner.
1247      *
1248      * NOTE: Renouncing ownership will leave the contract without an owner,
1249      * thereby removing any functionality that is only available to the owner.
1250      */
1251     function renounceOwnership() public virtual onlyOwner {
1252         _transferOwnership(address(0));
1253     }
1254 
1255     /**
1256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1257      * Can only be called by the current owner.
1258      */
1259     function transferOwnership(address newOwner) public virtual onlyOwner {
1260         require(newOwner != address(0), "Ownable: new owner is the zero address");
1261         _transferOwnership(newOwner);
1262     }
1263 
1264     /**
1265      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1266      * Internal function without access restriction.
1267      */
1268     function _transferOwnership(address newOwner) internal virtual {
1269         address oldOwner = _owner;
1270         _owner = newOwner;
1271         emit OwnershipTransferred(oldOwner, newOwner);
1272     }
1273 }
1274 
1275 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1276 
1277 pragma solidity ^0.8.0;
1278 
1279 /**
1280  * @dev Contract module that helps prevent reentrant calls to a function.
1281  *
1282  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1283  * available, which can be applied to functions to make sure there are no nested
1284  * (reentrant) calls to them.
1285  *
1286  * Note that because there is a single `nonReentrant` guard, functions marked as
1287  * `nonReentrant` may not call one another. This can be worked around by making
1288  * those functions `private`, and then adding `external` `nonReentrant` entry
1289  * points to them.
1290  *
1291  * TIP: If you would like to learn more about reentrancy and alternative ways
1292  * to protect against it, check out our blog post
1293  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1294  */
1295 abstract contract ReentrancyGuard {
1296     // Booleans are more expensive than uint256 or any type that takes up a full
1297     // word because each write operation emits an extra SLOAD to first read the
1298     // slot's contents, replace the bits taken up by the boolean, and then write
1299     // back. This is the compiler's defense against contract upgrades and
1300     // pointer aliasing, and it cannot be disabled.
1301 
1302     // The values being non-zero value makes deployment a bit more expensive,
1303     // but in exchange the refund on every call to nonReentrant will be lower in
1304     // amount. Since refunds are capped to a percentage of the total
1305     // transaction's gas, it is best to keep them low in cases like this one, to
1306     // increase the likelihood of the full refund coming into effect.
1307     uint256 private constant _NOT_ENTERED = 1;
1308     uint256 private constant _ENTERED = 2;
1309 
1310     uint256 private _status;
1311 
1312     constructor() {
1313         _status = _NOT_ENTERED;
1314     }
1315 
1316     /**
1317      * @dev Prevents a contract from calling itself, directly or indirectly.
1318      * Calling a `nonReentrant` function from another `nonReentrant`
1319      * function is not supported. It is possible to prevent this from happening
1320      * by making the `nonReentrant` function external, and making it call a
1321      * `private` function that does the actual work.
1322      */
1323     modifier nonReentrant() {
1324         _nonReentrantBefore();
1325         _;
1326         _nonReentrantAfter();
1327     }
1328 
1329     function _nonReentrantBefore() private {
1330         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1331         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1332 
1333         // Any calls to nonReentrant after this point will fail
1334         _status = _ENTERED;
1335     }
1336 
1337     function _nonReentrantAfter() private {
1338         // By storing the original value once again, a refund is triggered (see
1339         // https://eips.ethereum.org/EIPS/eip-2200)
1340         _status = _NOT_ENTERED;
1341     }
1342 }
1343 
1344 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1345 
1346 pragma solidity ^0.8.0;
1347 
1348 /**
1349  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1350  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1351  *
1352  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1353  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1354  * need to send a transaction, and thus is not required to hold Ether at all.
1355  */
1356 interface IERC20Permit {
1357     /**
1358      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1359      * given ``owner``'s signed approval.
1360      *
1361      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1362      * ordering also apply here.
1363      *
1364      * Emits an {Approval} event.
1365      *
1366      * Requirements:
1367      *
1368      * - `spender` cannot be the zero address.
1369      * - `deadline` must be a timestamp in the future.
1370      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1371      * over the EIP712-formatted function arguments.
1372      * - the signature must use ``owner``'s current nonce (see {nonces}).
1373      *
1374      * For more information on the signature format, see the
1375      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1376      * section].
1377      */
1378     function permit(
1379         address owner,
1380         address spender,
1381         uint256 value,
1382         uint256 deadline,
1383         uint8 v,
1384         bytes32 r,
1385         bytes32 s
1386     ) external;
1387 
1388     /**
1389      * @dev Returns the current nonce for `owner`. This value must be
1390      * included whenever a signature is generated for {permit}.
1391      *
1392      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1393      * prevents a signature from being used multiple times.
1394      */
1395     function nonces(address owner) external view returns (uint256);
1396 
1397     /**
1398      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1399      */
1400     // solhint-disable-next-line func-name-mixedcase
1401     function DOMAIN_SEPARATOR() external view returns (bytes32);
1402 }
1403 
1404 
1405 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
1406 
1407 pragma solidity ^0.8.0;
1408 
1409 /**
1410  * @title SafeERC20
1411  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1412  * contract returns false). Tokens that return no value (and instead revert or
1413  * throw on failure) are also supported, non-reverting calls are assumed to be
1414  * successful.
1415  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1416  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1417  */
1418 library SafeERC20 {
1419     using Address for address;
1420 
1421     function safeTransfer(
1422         IERC20 token,
1423         address to,
1424         uint256 value
1425     ) internal {
1426         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1427     }
1428 
1429     function safeTransferFrom(
1430         IERC20 token,
1431         address from,
1432         address to,
1433         uint256 value
1434     ) internal {
1435         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1436     }
1437 
1438     /**
1439      * @dev Deprecated. This function has issues similar to the ones found in
1440      * {IERC20-approve}, and its usage is discouraged.
1441      *
1442      * Whenever possible, use {safeIncreaseAllowance} and
1443      * {safeDecreaseAllowance} instead.
1444      */
1445     function safeApprove(
1446         IERC20 token,
1447         address spender,
1448         uint256 value
1449     ) internal {
1450         // safeApprove should only be called when setting an initial allowance,
1451         // or when resetting it to zero. To increase and decrease it, use
1452         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1453         require(
1454             (value == 0) || (token.allowance(address(this), spender) == 0),
1455             "SafeERC20: approve from non-zero to non-zero allowance"
1456         );
1457         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1458     }
1459 
1460     function safeIncreaseAllowance(
1461         IERC20 token,
1462         address spender,
1463         uint256 value
1464     ) internal {
1465         uint256 newAllowance = token.allowance(address(this), spender) + value;
1466         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1467     }
1468 
1469     function safeDecreaseAllowance(
1470         IERC20 token,
1471         address spender,
1472         uint256 value
1473     ) internal {
1474         unchecked {
1475             uint256 oldAllowance = token.allowance(address(this), spender);
1476             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1477             uint256 newAllowance = oldAllowance - value;
1478             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1479         }
1480     }
1481 
1482     function safePermit(
1483         IERC20Permit token,
1484         address owner,
1485         address spender,
1486         uint256 value,
1487         uint256 deadline,
1488         uint8 v,
1489         bytes32 r,
1490         bytes32 s
1491     ) internal {
1492         uint256 nonceBefore = token.nonces(owner);
1493         token.permit(owner, spender, value, deadline, v, r, s);
1494         uint256 nonceAfter = token.nonces(owner);
1495         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1496     }
1497 
1498     /**
1499      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1500      * on the return value: the return value is optional (but if data is returned, it must not be false).
1501      * @param token The token targeted by the call.
1502      * @param data The call data (encoded using abi.encode or one of its variants).
1503      */
1504     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1505         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1506         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1507         // the target address contains contract code and also asserts for success in the low-level call.
1508 
1509         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1510         if (returndata.length > 0) {
1511             // Return data is optional
1512             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1513         }
1514     }
1515 }
1516 
1517 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1518 
1519 pragma solidity ^0.8.0;
1520 
1521 /**
1522  * @dev Interface of the ERC20 standard as defined in the EIP.
1523  */
1524 interface IERC20 {
1525     /**
1526      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1527      * another (`to`).
1528      *
1529      * Note that `value` may be zero.
1530      */
1531     event Transfer(address indexed from, address indexed to, uint256 value);
1532 
1533     /**
1534      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1535      * a call to {approve}. `value` is the new allowance.
1536      */
1537     event Approval(address indexed owner, address indexed spender, uint256 value);
1538 
1539     /**
1540      * @dev Returns the amount of tokens in existence.
1541      */
1542     function totalSupply() external view returns (uint256);
1543 
1544     /**
1545      * @dev Returns the amount of tokens owned by `account`.
1546      */
1547     function balanceOf(address account) external view returns (uint256);
1548 
1549     /**
1550      * @dev Moves `amount` tokens from the caller's account to `to`.
1551      *
1552      * Returns a boolean value indicating whether the operation succeeded.
1553      *
1554      * Emits a {Transfer} event.
1555      */
1556     function transfer(address to, uint256 amount) external returns (bool);
1557 
1558     /**
1559      * @dev Returns the remaining number of tokens that `spender` will be
1560      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1561      * zero by default.
1562      *
1563      * This value changes when {approve} or {transferFrom} are called.
1564      */
1565     function allowance(address owner, address spender) external view returns (uint256);
1566 
1567     /**
1568      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1569      *
1570      * Returns a boolean value indicating whether the operation succeeded.
1571      *
1572      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1573      * that someone may use both the old and the new allowance by unfortunate
1574      * transaction ordering. One possible solution to mitigate this race
1575      * condition is to first reduce the spender's allowance to 0 and set the
1576      * desired value afterwards:
1577      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1578      *
1579      * Emits an {Approval} event.
1580      */
1581     function approve(address spender, uint256 amount) external returns (bool);
1582 
1583     /**
1584      * @dev Moves `amount` tokens from `from` to `to` using the
1585      * allowance mechanism. `amount` is then deducted from the caller's
1586      * allowance.
1587      *
1588      * Returns a boolean value indicating whether the operation succeeded.
1589      *
1590      * Emits a {Transfer} event.
1591      */
1592     function transferFrom(
1593         address from,
1594         address to,
1595         uint256 amount
1596     ) external returns (bool);
1597 }
1598 
1599 // ERC721A Contracts v4.2.3
1600 // Creator: Chiru Labs
1601 
1602 pragma solidity ^0.8.4;
1603 
1604 /**
1605  * @dev Interface of ERC721 token receiver.
1606  */
1607 interface ERC721A__IERC721Receiver {
1608     function onERC721Received(
1609         address operator,
1610         address from,
1611         uint256 tokenId,
1612         bytes calldata data
1613     ) external returns (bytes4);
1614 }
1615 
1616 /**
1617  * @title ERC721A
1618  *
1619  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1620  * Non-Fungible Token Standard, including the Metadata extension.
1621  * Optimized for lower gas during batch mints.
1622  *
1623  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1624  * starting from `_startTokenId()`.
1625  *
1626  * Assumptions:
1627  *
1628  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1629  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1630  */
1631 contract ERC721A is IERC721A {
1632     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1633     struct TokenApprovalRef {
1634         address value;
1635     }
1636 
1637     // =============================================================
1638     //                           CONSTANTS
1639     // =============================================================
1640 
1641     // Mask of an entry in packed address data.
1642     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1643 
1644     // The bit position of `numberMinted` in packed address data.
1645     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1646 
1647     // The bit position of `numberBurned` in packed address data.
1648     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1649 
1650     // The bit position of `aux` in packed address data.
1651     uint256 private constant _BITPOS_AUX = 192;
1652 
1653     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1654     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1655 
1656     // The bit position of `startTimestamp` in packed ownership.
1657     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1658 
1659     // The bit mask of the `burned` bit in packed ownership.
1660     uint256 private constant _BITMASK_BURNED = 1 << 224;
1661 
1662     // The bit position of the `nextInitialized` bit in packed ownership.
1663     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1664 
1665     // The bit mask of the `nextInitialized` bit in packed ownership.
1666     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1667 
1668     // The bit position of `extraData` in packed ownership.
1669     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1670 
1671     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1672     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1673 
1674     // The mask of the lower 160 bits for addresses.
1675     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1676 
1677     // The maximum `quantity` that can be minted with {_mintERC2309}.
1678     // This limit is to prevent overflows on the address data entries.
1679     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1680     // is required to cause an overflow, which is unrealistic.
1681     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1682 
1683     // The `Transfer` event signature is given by:
1684     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1685     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1686         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1687 
1688     // =============================================================
1689     //                            STORAGE
1690     // =============================================================
1691 
1692     // The next token ID to be minted.
1693     uint256 private _currentIndex;
1694 
1695     // The number of tokens burned.
1696     uint256 private _burnCounter;
1697 
1698     // Token name
1699     string private _name;
1700 
1701     // Token symbol
1702     string private _symbol;
1703 
1704     // Mapping from token ID to ownership details
1705     // An empty struct value does not necessarily mean the token is unowned.
1706     // See {_packedOwnershipOf} implementation for details.
1707     //
1708     // Bits Layout:
1709     // - [0..159]   `addr`
1710     // - [160..223] `startTimestamp`
1711     // - [224]      `burned`
1712     // - [225]      `nextInitialized`
1713     // - [232..255] `extraData`
1714     mapping(uint256 => uint256) private _packedOwnerships;
1715 
1716     // Mapping owner address to address data.
1717     //
1718     // Bits Layout:
1719     // - [0..63]    `balance`
1720     // - [64..127]  `numberMinted`
1721     // - [128..191] `numberBurned`
1722     // - [192..255] `aux`
1723     mapping(address => uint256) private _packedAddressData;
1724 
1725     // Mapping from token ID to approved address.
1726     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1727 
1728     // Mapping from owner to operator approvals
1729     mapping(address => mapping(address => bool)) private _operatorApprovals;
1730 
1731     // =============================================================
1732     //                          CONSTRUCTOR
1733     // =============================================================
1734 
1735     constructor(string memory name_, string memory symbol_) {
1736         _name = name_;
1737         _symbol = symbol_;
1738         _currentIndex = _startTokenId();
1739     }
1740 
1741     // =============================================================
1742     //                   TOKEN COUNTING OPERATIONS
1743     // =============================================================
1744 
1745     /**
1746      * @dev Returns the starting token ID.
1747      * To change the starting token ID, please override this function.
1748      */
1749     function _startTokenId() internal view virtual returns (uint256) {
1750         return 0;
1751     }
1752 
1753     /**
1754      * @dev Returns the next token ID to be minted.
1755      */
1756     function _nextTokenId() internal view virtual returns (uint256) {
1757         return _currentIndex;
1758     }
1759 
1760     /**
1761      * @dev Returns the total number of tokens in existence.
1762      * Burned tokens will reduce the count.
1763      * To get the total number of tokens minted, please see {_totalMinted}.
1764      */
1765     function totalSupply() public view virtual override returns (uint256) {
1766         // Counter underflow is impossible as _burnCounter cannot be incremented
1767         // more than `_currentIndex - _startTokenId()` times.
1768         unchecked {
1769             return _currentIndex - _burnCounter - _startTokenId();
1770         }
1771     }
1772 
1773     /**
1774      * @dev Returns the total amount of tokens minted in the contract.
1775      */
1776     function _totalMinted() internal view virtual returns (uint256) {
1777         // Counter underflow is impossible as `_currentIndex` does not decrement,
1778         // and it is initialized to `_startTokenId()`.
1779         unchecked {
1780             return _currentIndex - _startTokenId();
1781         }
1782     }
1783 
1784     /**
1785      * @dev Returns the total number of tokens burned.
1786      */
1787     function _totalBurned() internal view virtual returns (uint256) {
1788         return _burnCounter;
1789     }
1790 
1791     // =============================================================
1792     //                    ADDRESS DATA OPERATIONS
1793     // =============================================================
1794 
1795     /**
1796      * @dev Returns the number of tokens in `owner`'s account.
1797      */
1798     function balanceOf(address owner) public view virtual override returns (uint256) {
1799         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1800         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1801     }
1802 
1803     /**
1804      * Returns the number of tokens minted by `owner`.
1805      */
1806     function _numberMinted(address owner) internal view returns (uint256) {
1807         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1808     }
1809 
1810     /**
1811      * Returns the number of tokens burned by or on behalf of `owner`.
1812      */
1813     function _numberBurned(address owner) internal view returns (uint256) {
1814         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1815     }
1816 
1817     /**
1818      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1819      */
1820     function _getAux(address owner) internal view returns (uint64) {
1821         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1822     }
1823 
1824     /**
1825      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1826      * If there are multiple variables, please pack them into a uint64.
1827      */
1828     function _setAux(address owner, uint64 aux) internal virtual {
1829         uint256 packed = _packedAddressData[owner];
1830         uint256 auxCasted;
1831         // Cast `aux` with assembly to avoid redundant masking.
1832         assembly {
1833             auxCasted := aux
1834         }
1835         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1836         _packedAddressData[owner] = packed;
1837     }
1838 
1839     // =============================================================
1840     //                            IERC165
1841     // =============================================================
1842 
1843     /**
1844      * @dev Returns true if this contract implements the interface defined by
1845      * `interfaceId`. See the corresponding
1846      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1847      * to learn more about how these ids are created.
1848      *
1849      * This function call must use less than 30000 gas.
1850      */
1851     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1852         // The interface IDs are constants representing the first 4 bytes
1853         // of the XOR of all function selectors in the interface.
1854         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1855         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1856         return
1857             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1858             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1859             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1860     }
1861 
1862     // =============================================================
1863     //                        IERC721Metadata
1864     // =============================================================
1865 
1866     /**
1867      * @dev Returns the token collection name.
1868      */
1869     function name() public view virtual override returns (string memory) {
1870         return _name;
1871     }
1872 
1873     /**
1874      * @dev Returns the token collection symbol.
1875      */
1876     function symbol() public view virtual override returns (string memory) {
1877         return _symbol;
1878     }
1879 
1880     /**
1881      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1882      */
1883     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1884         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1885 
1886         string memory baseURI = _baseURI();
1887         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1888     }
1889 
1890     /**
1891      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1892      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1893      * by default, it can be overridden in child contracts.
1894      */
1895     function _baseURI() internal view virtual returns (string memory) {
1896         return '';
1897     }
1898 
1899     // =============================================================
1900     //                     OWNERSHIPS OPERATIONS
1901     // =============================================================
1902 
1903     /**
1904      * @dev Returns the owner of the `tokenId` token.
1905      *
1906      * Requirements:
1907      *
1908      * - `tokenId` must exist.
1909      */
1910     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1911         return address(uint160(_packedOwnershipOf(tokenId)));
1912     }
1913 
1914     /**
1915      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1916      * It gradually moves to O(1) as tokens get transferred around over time.
1917      */
1918     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1919         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1920     }
1921 
1922     /**
1923      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1924      */
1925     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1926         return _unpackedOwnership(_packedOwnerships[index]);
1927     }
1928 
1929     /**
1930      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1931      */
1932     function _initializeOwnershipAt(uint256 index) internal virtual {
1933         if (_packedOwnerships[index] == 0) {
1934             _packedOwnerships[index] = _packedOwnershipOf(index);
1935         }
1936     }
1937 
1938     /**
1939      * Returns the packed ownership data of `tokenId`.
1940      */
1941     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1942         uint256 curr = tokenId;
1943 
1944         unchecked {
1945             if (_startTokenId() <= curr)
1946                 if (curr < _currentIndex) {
1947                     uint256 packed = _packedOwnerships[curr];
1948                     // If not burned.
1949                     if (packed & _BITMASK_BURNED == 0) {
1950                         // Invariant:
1951                         // There will always be an initialized ownership slot
1952                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1953                         // before an unintialized ownership slot
1954                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1955                         // Hence, `curr` will not underflow.
1956                         //
1957                         // We can directly compare the packed value.
1958                         // If the address is zero, packed will be zero.
1959                         while (packed == 0) {
1960                             packed = _packedOwnerships[--curr];
1961                         }
1962                         return packed;
1963                     }
1964                 }
1965         }
1966         revert OwnerQueryForNonexistentToken();
1967     }
1968 
1969     /**
1970      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1971      */
1972     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1973         ownership.addr = address(uint160(packed));
1974         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1975         ownership.burned = packed & _BITMASK_BURNED != 0;
1976         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1977     }
1978 
1979     /**
1980      * @dev Packs ownership data into a single uint256.
1981      */
1982     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1983         assembly {
1984             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1985             owner := and(owner, _BITMASK_ADDRESS)
1986             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1987             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1988         }
1989     }
1990 
1991     /**
1992      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1993      */
1994     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1995         // For branchless setting of the `nextInitialized` flag.
1996         assembly {
1997             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1998             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1999         }
2000     }
2001 
2002     // =============================================================
2003     //                      APPROVAL OPERATIONS
2004     // =============================================================
2005 
2006     /**
2007      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2008      * The approval is cleared when the token is transferred.
2009      *
2010      * Only a single account can be approved at a time, so approving the
2011      * zero address clears previous approvals.
2012      *
2013      * Requirements:
2014      *
2015      * - The caller must own the token or be an approved operator.
2016      * - `tokenId` must exist.
2017      *
2018      * Emits an {Approval} event.
2019      */
2020     function approve(address to, uint256 tokenId) public payable virtual override {
2021         address owner = ownerOf(tokenId);
2022 
2023         if (_msgSenderERC721A() != owner)
2024             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2025                 revert ApprovalCallerNotOwnerNorApproved();
2026             }
2027 
2028         _tokenApprovals[tokenId].value = to;
2029         emit Approval(owner, to, tokenId);
2030     }
2031 
2032     /**
2033      * @dev Returns the account approved for `tokenId` token.
2034      *
2035      * Requirements:
2036      *
2037      * - `tokenId` must exist.
2038      */
2039     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2040         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2041 
2042         return _tokenApprovals[tokenId].value;
2043     }
2044 
2045     /**
2046      * @dev Approve or remove `operator` as an operator for the caller.
2047      * Operators can call {transferFrom} or {safeTransferFrom}
2048      * for any token owned by the caller.
2049      *
2050      * Requirements:
2051      *
2052      * - The `operator` cannot be the caller.
2053      *
2054      * Emits an {ApprovalForAll} event.
2055      */
2056     function setApprovalForAll(address operator, bool approved) public virtual override {
2057         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2058         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2059     }
2060 
2061     /**
2062      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2063      *
2064      * See {setApprovalForAll}.
2065      */
2066     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2067         return _operatorApprovals[owner][operator];
2068     }
2069 
2070     /**
2071      * @dev Returns whether `tokenId` exists.
2072      *
2073      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2074      *
2075      * Tokens start existing when they are minted. See {_mint}.
2076      */
2077     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2078         return
2079             _startTokenId() <= tokenId &&
2080             tokenId < _currentIndex && // If within bounds,
2081             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2082     }
2083 
2084     /**
2085      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2086      */
2087     function _isSenderApprovedOrOwner(
2088         address approvedAddress,
2089         address owner,
2090         address msgSender
2091     ) private pure returns (bool result) {
2092         assembly {
2093             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2094             owner := and(owner, _BITMASK_ADDRESS)
2095             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2096             msgSender := and(msgSender, _BITMASK_ADDRESS)
2097             // `msgSender == owner || msgSender == approvedAddress`.
2098             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2099         }
2100     }
2101 
2102     /**
2103      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2104      */
2105     function _getApprovedSlotAndAddress(uint256 tokenId)
2106         private
2107         view
2108         returns (uint256 approvedAddressSlot, address approvedAddress)
2109     {
2110         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2111         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2112         assembly {
2113             approvedAddressSlot := tokenApproval.slot
2114             approvedAddress := sload(approvedAddressSlot)
2115         }
2116     }
2117 
2118     // =============================================================
2119     //                      TRANSFER OPERATIONS
2120     // =============================================================
2121 
2122     /**
2123      * @dev Transfers `tokenId` from `from` to `to`.
2124      *
2125      * Requirements:
2126      *
2127      * - `from` cannot be the zero address.
2128      * - `to` cannot be the zero address.
2129      * - `tokenId` token must be owned by `from`.
2130      * - If the caller is not `from`, it must be approved to move this token
2131      * by either {approve} or {setApprovalForAll}.
2132      *
2133      * Emits a {Transfer} event.
2134      */
2135     function transferFrom(
2136         address from,
2137         address to,
2138         uint256 tokenId
2139     ) public payable virtual override {
2140         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2141 
2142         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2143 
2144         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2145 
2146         // The nested ifs save around 20+ gas over a compound boolean condition.
2147         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2148             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2149 
2150         if (to == address(0)) revert TransferToZeroAddress();
2151 
2152         _beforeTokenTransfers(from, to, tokenId, 1);
2153 
2154         // Clear approvals from the previous owner.
2155         assembly {
2156             if approvedAddress {
2157                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2158                 sstore(approvedAddressSlot, 0)
2159             }
2160         }
2161 
2162         // Underflow of the sender's balance is impossible because we check for
2163         // ownership above and the recipient's balance can't realistically overflow.
2164         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2165         unchecked {
2166             // We can directly increment and decrement the balances.
2167             --_packedAddressData[from]; // Updates: `balance -= 1`.
2168             ++_packedAddressData[to]; // Updates: `balance += 1`.
2169 
2170             // Updates:
2171             // - `address` to the next owner.
2172             // - `startTimestamp` to the timestamp of transfering.
2173             // - `burned` to `false`.
2174             // - `nextInitialized` to `true`.
2175             _packedOwnerships[tokenId] = _packOwnershipData(
2176                 to,
2177                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2178             );
2179 
2180             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2181             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2182                 uint256 nextTokenId = tokenId + 1;
2183                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2184                 if (_packedOwnerships[nextTokenId] == 0) {
2185                     // If the next slot is within bounds.
2186                     if (nextTokenId != _currentIndex) {
2187                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2188                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2189                     }
2190                 }
2191             }
2192         }
2193 
2194         emit Transfer(from, to, tokenId);
2195         _afterTokenTransfers(from, to, tokenId, 1);
2196     }
2197 
2198     /**
2199      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2200      */
2201     function safeTransferFrom(
2202         address from,
2203         address to,
2204         uint256 tokenId
2205     ) public payable virtual override {
2206         safeTransferFrom(from, to, tokenId, '');
2207     }
2208 
2209     /**
2210      * @dev Safely transfers `tokenId` token from `from` to `to`.
2211      *
2212      * Requirements:
2213      *
2214      * - `from` cannot be the zero address.
2215      * - `to` cannot be the zero address.
2216      * - `tokenId` token must exist and be owned by `from`.
2217      * - If the caller is not `from`, it must be approved to move this token
2218      * by either {approve} or {setApprovalForAll}.
2219      * - If `to` refers to a smart contract, it must implement
2220      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2221      *
2222      * Emits a {Transfer} event.
2223      */
2224     function safeTransferFrom(
2225         address from,
2226         address to,
2227         uint256 tokenId,
2228         bytes memory _data
2229     ) public payable virtual override {
2230         transferFrom(from, to, tokenId);
2231         if (to.code.length != 0)
2232             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2233                 revert TransferToNonERC721ReceiverImplementer();
2234             }
2235     }
2236 
2237     /**
2238      * @dev Hook that is called before a set of serially-ordered token IDs
2239      * are about to be transferred. This includes minting.
2240      * And also called before burning one token.
2241      *
2242      * `startTokenId` - the first token ID to be transferred.
2243      * `quantity` - the amount to be transferred.
2244      *
2245      * Calling conditions:
2246      *
2247      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2248      * transferred to `to`.
2249      * - When `from` is zero, `tokenId` will be minted for `to`.
2250      * - When `to` is zero, `tokenId` will be burned by `from`.
2251      * - `from` and `to` are never both zero.
2252      */
2253     function _beforeTokenTransfers(
2254         address from,
2255         address to,
2256         uint256 startTokenId,
2257         uint256 quantity
2258     ) internal virtual {}
2259 
2260     /**
2261      * @dev Hook that is called after a set of serially-ordered token IDs
2262      * have been transferred. This includes minting.
2263      * And also called after one token has been burned.
2264      *
2265      * `startTokenId` - the first token ID to be transferred.
2266      * `quantity` - the amount to be transferred.
2267      *
2268      * Calling conditions:
2269      *
2270      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2271      * transferred to `to`.
2272      * - When `from` is zero, `tokenId` has been minted for `to`.
2273      * - When `to` is zero, `tokenId` has been burned by `from`.
2274      * - `from` and `to` are never both zero.
2275      */
2276     function _afterTokenTransfers(
2277         address from,
2278         address to,
2279         uint256 startTokenId,
2280         uint256 quantity
2281     ) internal virtual {}
2282 
2283     /**
2284      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2285      *
2286      * `from` - Previous owner of the given token ID.
2287      * `to` - Target address that will receive the token.
2288      * `tokenId` - Token ID to be transferred.
2289      * `_data` - Optional data to send along with the call.
2290      *
2291      * Returns whether the call correctly returned the expected magic value.
2292      */
2293     function _checkContractOnERC721Received(
2294         address from,
2295         address to,
2296         uint256 tokenId,
2297         bytes memory _data
2298     ) private returns (bool) {
2299         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2300             bytes4 retval
2301         ) {
2302             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2303         } catch (bytes memory reason) {
2304             if (reason.length == 0) {
2305                 revert TransferToNonERC721ReceiverImplementer();
2306             } else {
2307                 assembly {
2308                     revert(add(32, reason), mload(reason))
2309                 }
2310             }
2311         }
2312     }
2313 
2314     // =============================================================
2315     //                        MINT OPERATIONS
2316     // =============================================================
2317 
2318     /**
2319      * @dev Mints `quantity` tokens and transfers them to `to`.
2320      *
2321      * Requirements:
2322      *
2323      * - `to` cannot be the zero address.
2324      * - `quantity` must be greater than 0.
2325      *
2326      * Emits a {Transfer} event for each mint.
2327      */
2328     function _mint(address to, uint256 quantity) internal virtual {
2329         uint256 startTokenId = _currentIndex;
2330         if (quantity == 0) revert MintZeroQuantity();
2331 
2332         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2333 
2334         // Overflows are incredibly unrealistic.
2335         // `balance` and `numberMinted` have a maximum limit of 2**64.
2336         // `tokenId` has a maximum limit of 2**256.
2337         unchecked {
2338             // Updates:
2339             // - `balance += quantity`.
2340             // - `numberMinted += quantity`.
2341             //
2342             // We can directly add to the `balance` and `numberMinted`.
2343             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2344 
2345             // Updates:
2346             // - `address` to the owner.
2347             // - `startTimestamp` to the timestamp of minting.
2348             // - `burned` to `false`.
2349             // - `nextInitialized` to `quantity == 1`.
2350             _packedOwnerships[startTokenId] = _packOwnershipData(
2351                 to,
2352                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2353             );
2354 
2355             uint256 toMasked;
2356             uint256 end = startTokenId + quantity;
2357 
2358             // Use assembly to loop and emit the `Transfer` event for gas savings.
2359             // The duplicated `log4` removes an extra check and reduces stack juggling.
2360             // The assembly, together with the surrounding Solidity code, have been
2361             // delicately arranged to nudge the compiler into producing optimized opcodes.
2362             assembly {
2363                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2364                 toMasked := and(to, _BITMASK_ADDRESS)
2365                 // Emit the `Transfer` event.
2366                 log4(
2367                     0, // Start of data (0, since no data).
2368                     0, // End of data (0, since no data).
2369                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2370                     0, // `address(0)`.
2371                     toMasked, // `to`.
2372                     startTokenId // `tokenId`.
2373                 )
2374 
2375                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2376                 // that overflows uint256 will make the loop run out of gas.
2377                 // The compiler will optimize the `iszero` away for performance.
2378                 for {
2379                     let tokenId := add(startTokenId, 1)
2380                 } iszero(eq(tokenId, end)) {
2381                     tokenId := add(tokenId, 1)
2382                 } {
2383                     // Emit the `Transfer` event. Similar to above.
2384                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2385                 }
2386             }
2387             if (toMasked == 0) revert MintToZeroAddress();
2388 
2389             _currentIndex = end;
2390         }
2391         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2392     }
2393 
2394     /**
2395      * @dev Mints `quantity` tokens and transfers them to `to`.
2396      *
2397      * This function is intended for efficient minting only during contract creation.
2398      *
2399      * It emits only one {ConsecutiveTransfer} as defined in
2400      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2401      * instead of a sequence of {Transfer} event(s).
2402      *
2403      * Calling this function outside of contract creation WILL make your contract
2404      * non-compliant with the ERC721 standard.
2405      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2406      * {ConsecutiveTransfer} event is only permissible during contract creation.
2407      *
2408      * Requirements:
2409      *
2410      * - `to` cannot be the zero address.
2411      * - `quantity` must be greater than 0.
2412      *
2413      * Emits a {ConsecutiveTransfer} event.
2414      */
2415     function _mintERC2309(address to, uint256 quantity) internal virtual {
2416         uint256 startTokenId = _currentIndex;
2417         if (to == address(0)) revert MintToZeroAddress();
2418         if (quantity == 0) revert MintZeroQuantity();
2419         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2420 
2421         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2422 
2423         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2424         unchecked {
2425             // Updates:
2426             // - `balance += quantity`.
2427             // - `numberMinted += quantity`.
2428             //
2429             // We can directly add to the `balance` and `numberMinted`.
2430             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2431 
2432             // Updates:
2433             // - `address` to the owner.
2434             // - `startTimestamp` to the timestamp of minting.
2435             // - `burned` to `false`.
2436             // - `nextInitialized` to `quantity == 1`.
2437             _packedOwnerships[startTokenId] = _packOwnershipData(
2438                 to,
2439                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2440             );
2441 
2442             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2443 
2444             _currentIndex = startTokenId + quantity;
2445         }
2446         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2447     }
2448 
2449     /**
2450      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2451      *
2452      * Requirements:
2453      *
2454      * - If `to` refers to a smart contract, it must implement
2455      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2456      * - `quantity` must be greater than 0.
2457      *
2458      * See {_mint}.
2459      *
2460      * Emits a {Transfer} event for each mint.
2461      */
2462     function _safeMint(
2463         address to,
2464         uint256 quantity,
2465         bytes memory _data
2466     ) internal virtual {
2467         _mint(to, quantity);
2468 
2469         unchecked {
2470             if (to.code.length != 0) {
2471                 uint256 end = _currentIndex;
2472                 uint256 index = end - quantity;
2473                 do {
2474                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2475                         revert TransferToNonERC721ReceiverImplementer();
2476                     }
2477                 } while (index < end);
2478                 // Reentrancy protection.
2479                 if (_currentIndex != end) revert();
2480             }
2481         }
2482     }
2483 
2484     /**
2485      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2486      */
2487     function _safeMint(address to, uint256 quantity) internal virtual {
2488         _safeMint(to, quantity, '');
2489     }
2490 
2491     // =============================================================
2492     //                        BURN OPERATIONS
2493     // =============================================================
2494 
2495     /**
2496      * @dev Equivalent to `_burn(tokenId, false)`.
2497      */
2498     function _burn(uint256 tokenId) internal virtual {
2499         _burn(tokenId, false);
2500     }
2501 
2502     /**
2503      * @dev Destroys `tokenId`.
2504      * The approval is cleared when the token is burned.
2505      *
2506      * Requirements:
2507      *
2508      * - `tokenId` must exist.
2509      *
2510      * Emits a {Transfer} event.
2511      */
2512     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2513         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2514 
2515         address from = address(uint160(prevOwnershipPacked));
2516 
2517         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2518 
2519         if (approvalCheck) {
2520             // The nested ifs save around 20+ gas over a compound boolean condition.
2521             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2522                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2523         }
2524 
2525         _beforeTokenTransfers(from, address(0), tokenId, 1);
2526 
2527         // Clear approvals from the previous owner.
2528         assembly {
2529             if approvedAddress {
2530                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2531                 sstore(approvedAddressSlot, 0)
2532             }
2533         }
2534 
2535         // Underflow of the sender's balance is impossible because we check for
2536         // ownership above and the recipient's balance can't realistically overflow.
2537         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2538         unchecked {
2539             // Updates:
2540             // - `balance -= 1`.
2541             // - `numberBurned += 1`.
2542             //
2543             // We can directly decrement the balance, and increment the number burned.
2544             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2545             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2546 
2547             // Updates:
2548             // - `address` to the last owner.
2549             // - `startTimestamp` to the timestamp of burning.
2550             // - `burned` to `true`.
2551             // - `nextInitialized` to `true`.
2552             _packedOwnerships[tokenId] = _packOwnershipData(
2553                 from,
2554                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2555             );
2556 
2557             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2558             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2559                 uint256 nextTokenId = tokenId + 1;
2560                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2561                 if (_packedOwnerships[nextTokenId] == 0) {
2562                     // If the next slot is within bounds.
2563                     if (nextTokenId != _currentIndex) {
2564                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2565                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2566                     }
2567                 }
2568             }
2569         }
2570 
2571         emit Transfer(from, address(0), tokenId);
2572         _afterTokenTransfers(from, address(0), tokenId, 1);
2573 
2574         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2575         unchecked {
2576             _burnCounter++;
2577         }
2578     }
2579 
2580     // =============================================================
2581     //                     EXTRA DATA OPERATIONS
2582     // =============================================================
2583 
2584     /**
2585      * @dev Directly sets the extra data for the ownership data `index`.
2586      */
2587     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2588         uint256 packed = _packedOwnerships[index];
2589         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2590         uint256 extraDataCasted;
2591         // Cast `extraData` with assembly to avoid redundant masking.
2592         assembly {
2593             extraDataCasted := extraData
2594         }
2595         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2596         _packedOwnerships[index] = packed;
2597     }
2598 
2599     /**
2600      * @dev Called during each token transfer to set the 24bit `extraData` field.
2601      * Intended to be overridden by the cosumer contract.
2602      *
2603      * `previousExtraData` - the value of `extraData` before transfer.
2604      *
2605      * Calling conditions:
2606      *
2607      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2608      * transferred to `to`.
2609      * - When `from` is zero, `tokenId` will be minted for `to`.
2610      * - When `to` is zero, `tokenId` will be burned by `from`.
2611      * - `from` and `to` are never both zero.
2612      */
2613     function _extraData(
2614         address from,
2615         address to,
2616         uint24 previousExtraData
2617     ) internal view virtual returns (uint24) {}
2618 
2619     /**
2620      * @dev Returns the next extra data for the packed ownership data.
2621      * The returned result is shifted into position.
2622      */
2623     function _nextExtraData(
2624         address from,
2625         address to,
2626         uint256 prevOwnershipPacked
2627     ) private view returns (uint256) {
2628         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2629         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2630     }
2631 
2632     // =============================================================
2633     //                       OTHER OPERATIONS
2634     // =============================================================
2635 
2636     /**
2637      * @dev Returns the message sender (defaults to `msg.sender`).
2638      *
2639      * If you are writing GSN compatible contracts, you need to override this function.
2640      */
2641     function _msgSenderERC721A() internal view virtual returns (address) {
2642         return msg.sender;
2643     }
2644 
2645     /**
2646      * @dev Converts a uint256 to its ASCII string decimal representation.
2647      */
2648     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2649         assembly {
2650             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2651             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2652             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2653             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2654             let m := add(mload(0x40), 0xa0)
2655             // Update the free memory pointer to allocate.
2656             mstore(0x40, m)
2657             // Assign the `str` to the end.
2658             str := sub(m, 0x20)
2659             // Zeroize the slot after the string.
2660             mstore(str, 0)
2661 
2662             // Cache the end of the memory to calculate the length later.
2663             let end := str
2664 
2665             // We write the string from rightmost digit to leftmost digit.
2666             // The following is essentially a do-while loop that also handles the zero case.
2667             // prettier-ignore
2668             for { let temp := value } 1 {} {
2669                 str := sub(str, 1)
2670                 // Write the character to the pointer.
2671                 // The ASCII index of the '0' character is 48.
2672                 mstore8(str, add(48, mod(temp, 10)))
2673                 // Keep dividing `temp` until zero.
2674                 temp := div(temp, 10)
2675                 // prettier-ignore
2676                 if iszero(temp) { break }
2677             }
2678 
2679             let length := sub(end, str)
2680             // Move the pointer 32 bytes leftwards to make room for the length.
2681             str := sub(str, 0x20)
2682             // Store the length.
2683             mstore(str, length)
2684         }
2685     }
2686 }
2687 
2688 // ERC721A Contracts v4.2.3
2689 // Creator: Chiru Labs
2690 
2691 pragma solidity ^0.8.9;
2692 
2693 contract JokerByLedger is ERC721A, Ownable {
2694     using Strings for uint256;
2695 
2696     uint256 public maxSupply = 444;
2697     uint256 public mintPrice = .004 ether;
2698     uint256 public maxPerWallet = 4;
2699     bool public paused = true;
2700     string public baseURI = "ipfs://Qmb3XckVz6y2C4vN85hhjtKDpKStw6CaCyB89sKrjxAp1C/";
2701     mapping(address => uint256) public mintPerWallet;
2702 
2703     constructor() ERC721A("444 Joker by Ledger", "JbL") {}
2704 
2705     function mint(uint256 _quantity) external payable {
2706         require(!paused, "Mint is not started");
2707         require(
2708             (totalSupply() + _quantity) <= maxSupply,
2709             "Max supply reached"
2710         );
2711         require(
2712             (mintPerWallet[msg.sender] + _quantity) <= maxPerWallet,
2713             "Max mint reached"
2714         );
2715         require(msg.value >= (mintPrice * _quantity), "Send the exact amount");
2716 
2717         mintPerWallet[msg.sender] += _quantity;
2718         _safeMint(msg.sender, _quantity);
2719     }
2720 
2721     function reserveMint(address receiver, uint256 mintAmount)
2722         external
2723         onlyOwner
2724     {
2725         _safeMint(receiver, mintAmount);
2726     }
2727 
2728     function tokenURI(uint256 tokenId)
2729         public
2730         view
2731         virtual
2732         override
2733         returns (string memory)
2734     {
2735         require(
2736             _exists(tokenId),
2737             "ERC721Metadata: URI query for nonexistent token"
2738         );
2739         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2740     }
2741 
2742     function _baseURI() internal view virtual override returns (string memory) {
2743         return baseURI;
2744     }
2745 
2746     function _startTokenId() internal view virtual override returns (uint256) {
2747         return 1;
2748     }
2749 
2750     function setBaseURI(string memory uri) public onlyOwner {
2751         baseURI = uri;
2752     }
2753 
2754     function startSale() external onlyOwner {
2755         paused = !paused;
2756     }
2757 
2758     function setSupply(uint256 _newAmount) external onlyOwner {
2759         maxSupply = _newAmount;
2760     }
2761 
2762     function setPrice(uint256 _newPrice) external onlyOwner {
2763         mintPrice = _newPrice;
2764     }
2765 
2766     function withdraw() external onlyOwner {
2767         (bool success, ) = payable(msg.sender).call{
2768             value: address(this).balance
2769         }("");
2770         require(success, "Transfer failed.");
2771     }
2772 }