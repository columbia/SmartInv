1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Standard math utilities missing in the Solidity language.
8  */
9 library Math {
10     enum Rounding {
11         Down, // Toward negative infinity
12         Up, // Toward infinity
13         Zero // Toward zero
14     }
15 
16     /**
17      * @dev Returns the largest of two numbers.
18      */
19     function max(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a > b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the smallest of two numbers.
25      */
26     function min(uint256 a, uint256 b) internal pure returns (uint256) {
27         return a < b ? a : b;
28     }
29 
30     /**
31      * @dev Returns the average of two numbers. The result is rounded towards
32      * zero.
33      */
34     function average(uint256 a, uint256 b) internal pure returns (uint256) {
35         // (a + b) / 2 can overflow.
36         return (a & b) + (a ^ b) / 2;
37     }
38 
39     /**
40      * @dev Returns the ceiling of the division of two numbers.
41      *
42      * This differs from standard division with `/` in that it rounds up instead
43      * of rounding down.
44      */
45     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
46         // (a + b - 1) / b can overflow on addition, so we distribute.
47         return a == 0 ? 0 : (a - 1) / b + 1;
48     }
49 
50     /**
51      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
52      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
53      * with further edits by Uniswap Labs also under MIT license.
54      */
55     function mulDiv(
56         uint256 x,
57         uint256 y,
58         uint256 denominator
59     ) internal pure returns (uint256 result) {
60         unchecked {
61             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
62             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
63             // variables such that product = prod1 * 2^256 + prod0.
64             uint256 prod0; // Least significant 256 bits of the product
65             uint256 prod1; // Most significant 256 bits of the product
66             assembly {
67                 let mm := mulmod(x, y, not(0))
68                 prod0 := mul(x, y)
69                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
70             }
71 
72             // Handle non-overflow cases, 256 by 256 division.
73             if (prod1 == 0) {
74                 return prod0 / denominator;
75             }
76 
77             // Make sure the result is less than 2^256. Also prevents denominator == 0.
78             require(denominator > prod1);
79 
80             ///////////////////////////////////////////////
81             // 512 by 256 division.
82             ///////////////////////////////////////////////
83 
84             // Make division exact by subtracting the remainder from [prod1 prod0].
85             uint256 remainder;
86             assembly {
87                 // Compute remainder using mulmod.
88                 remainder := mulmod(x, y, denominator)
89 
90                 // Subtract 256 bit number from 512 bit number.
91                 prod1 := sub(prod1, gt(remainder, prod0))
92                 prod0 := sub(prod0, remainder)
93             }
94 
95             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
96             // See https://cs.stackexchange.com/q/138556/92363.
97 
98             // Does not overflow because the denominator cannot be zero at this stage in the function.
99             uint256 twos = denominator & (~denominator + 1);
100             assembly {
101                 // Divide denominator by twos.
102                 denominator := div(denominator, twos)
103 
104                 // Divide [prod1 prod0] by twos.
105                 prod0 := div(prod0, twos)
106 
107                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
108                 twos := add(div(sub(0, twos), twos), 1)
109             }
110 
111             // Shift in bits from prod1 into prod0.
112             prod0 |= prod1 * twos;
113 
114             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
115             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
116             // four bits. That is, denominator * inv = 1 mod 2^4.
117             uint256 inverse = (3 * denominator) ^ 2;
118 
119             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
120             // in modular arithmetic, doubling the correct bits in each step.
121             inverse *= 2 - denominator * inverse; // inverse mod 2^8
122             inverse *= 2 - denominator * inverse; // inverse mod 2^16
123             inverse *= 2 - denominator * inverse; // inverse mod 2^32
124             inverse *= 2 - denominator * inverse; // inverse mod 2^64
125             inverse *= 2 - denominator * inverse; // inverse mod 2^128
126             inverse *= 2 - denominator * inverse; // inverse mod 2^256
127 
128             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
129             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
130             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
131             // is no longer required.
132             result = prod0 * inverse;
133             return result;
134         }
135     }
136 
137     /**
138      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
139      */
140     function mulDiv(
141         uint256 x,
142         uint256 y,
143         uint256 denominator,
144         Rounding rounding
145     ) internal pure returns (uint256) {
146         uint256 result = mulDiv(x, y, denominator);
147         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
148             result += 1;
149         }
150         return result;
151     }
152 
153     /**
154      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
155      *
156      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
157      */
158     function sqrt(uint256 a) internal pure returns (uint256) {
159         if (a == 0) {
160             return 0;
161         }
162 
163         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
164         //
165         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
166         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
167         //
168         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
169         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
170         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
171         //
172         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
173         uint256 result = 1 << (log2(a) >> 1);
174 
175         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
176         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
177         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
178         // into the expected uint128 result.
179         unchecked {
180             result = (result + a / result) >> 1;
181             result = (result + a / result) >> 1;
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             return min(result, a / result);
188         }
189     }
190 
191     /**
192      * @notice Calculates sqrt(a), following the selected rounding direction.
193      */
194     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
195         unchecked {
196             uint256 result = sqrt(a);
197             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
198         }
199     }
200 
201     /**
202      * @dev Return the log in base 2, rounded down, of a positive value.
203      * Returns 0 if given 0.
204      */
205     function log2(uint256 value) internal pure returns (uint256) {
206         uint256 result = 0;
207         unchecked {
208             if (value >> 128 > 0) {
209                 value >>= 128;
210                 result += 128;
211             }
212             if (value >> 64 > 0) {
213                 value >>= 64;
214                 result += 64;
215             }
216             if (value >> 32 > 0) {
217                 value >>= 32;
218                 result += 32;
219             }
220             if (value >> 16 > 0) {
221                 value >>= 16;
222                 result += 16;
223             }
224             if (value >> 8 > 0) {
225                 value >>= 8;
226                 result += 8;
227             }
228             if (value >> 4 > 0) {
229                 value >>= 4;
230                 result += 4;
231             }
232             if (value >> 2 > 0) {
233                 value >>= 2;
234                 result += 2;
235             }
236             if (value >> 1 > 0) {
237                 result += 1;
238             }
239         }
240         return result;
241     }
242 
243     /**
244      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
245      * Returns 0 if given 0.
246      */
247     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
248         unchecked {
249             uint256 result = log2(value);
250             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
251         }
252     }
253 
254     /**
255      * @dev Return the log in base 10, rounded down, of a positive value.
256      * Returns 0 if given 0.
257      */
258     function log10(uint256 value) internal pure returns (uint256) {
259         uint256 result = 0;
260         unchecked {
261             if (value >= 10**64) {
262                 value /= 10**64;
263                 result += 64;
264             }
265             if (value >= 10**32) {
266                 value /= 10**32;
267                 result += 32;
268             }
269             if (value >= 10**16) {
270                 value /= 10**16;
271                 result += 16;
272             }
273             if (value >= 10**8) {
274                 value /= 10**8;
275                 result += 8;
276             }
277             if (value >= 10**4) {
278                 value /= 10**4;
279                 result += 4;
280             }
281             if (value >= 10**2) {
282                 value /= 10**2;
283                 result += 2;
284             }
285             if (value >= 10**1) {
286                 result += 1;
287             }
288         }
289         return result;
290     }
291 
292     /**
293      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
294      * Returns 0 if given 0.
295      */
296     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
297         unchecked {
298             uint256 result = log10(value);
299             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
300         }
301     }
302 
303     /**
304      * @dev Return the log in base 256, rounded down, of a positive value.
305      * Returns 0 if given 0.
306      *
307      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
308      */
309     function log256(uint256 value) internal pure returns (uint256) {
310         uint256 result = 0;
311         unchecked {
312             if (value >> 128 > 0) {
313                 value >>= 128;
314                 result += 16;
315             }
316             if (value >> 64 > 0) {
317                 value >>= 64;
318                 result += 8;
319             }
320             if (value >> 32 > 0) {
321                 value >>= 32;
322                 result += 4;
323             }
324             if (value >> 16 > 0) {
325                 value >>= 16;
326                 result += 2;
327             }
328             if (value >> 8 > 0) {
329                 result += 1;
330             }
331         }
332         return result;
333     }
334 
335     /**
336      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
337      * Returns 0 if given 0.
338      */
339     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
340         unchecked {
341             uint256 result = log256(value);
342             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
343         }
344     }
345 }
346 
347 pragma solidity ^0.8.4;
348 
349 /**
350  * @dev Interface of ERC721A.
351  */
352 interface IERC721A {
353     /**
354      * The caller must own the token or be an approved operator.
355      */
356     error ApprovalCallerNotOwnerNorApproved();
357 
358     /**
359      * The token does not exist.
360      */
361     error ApprovalQueryForNonexistentToken();
362 
363     /**
364      * Cannot query the balance for the zero address.
365      */
366     error BalanceQueryForZeroAddress();
367 
368     /**
369      * Cannot mint to the zero address.
370      */
371     error MintToZeroAddress();
372 
373     /**
374      * The quantity of tokens minted must be more than zero.
375      */
376     error MintZeroQuantity();
377 
378     /**
379      * The token does not exist.
380      */
381     error OwnerQueryForNonexistentToken();
382 
383     /**
384      * The caller must own the token or be an approved operator.
385      */
386     error TransferCallerNotOwnerNorApproved();
387 
388     /**
389      * The token must be owned by `from`.
390      */
391     error TransferFromIncorrectOwner();
392 
393     /**
394      * Cannot safely transfer to a contract that does not implement the
395      * ERC721Receiver interface.
396      */
397     error TransferToNonERC721ReceiverImplementer();
398 
399     /**
400      * Cannot transfer to the zero address.
401      */
402     error TransferToZeroAddress();
403 
404     /**
405      * The token does not exist.
406      */
407     error URIQueryForNonexistentToken();
408 
409     /**
410      * The `quantity` minted with ERC2309 exceeds the safety limit.
411      */
412     error MintERC2309QuantityExceedsLimit();
413 
414     /**
415      * The `extraData` cannot be set on an unintialized ownership slot.
416      */
417     error OwnershipNotInitializedForExtraData();
418 
419     // =============================================================
420     //                            STRUCTS
421     // =============================================================
422 
423     struct TokenOwnership {
424         // The address of the owner.
425         address addr;
426         // Stores the start time of ownership with minimal overhead for tokenomics.
427         uint64 startTimestamp;
428         // Whether the token has been burned.
429         bool burned;
430         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
431         uint24 extraData;
432     }
433 
434     // =============================================================
435     //                         TOKEN COUNTERS
436     // =============================================================
437 
438     /**
439      * @dev Returns the total number of tokens in existence.
440      * Burned tokens will reduce the count.
441      * To get the total number of tokens minted, please see {_totalMinted}.
442      */
443     function totalSupply() external view returns (uint256);
444 
445     // =============================================================
446     //                            IERC165
447     // =============================================================
448 
449     /**
450      * @dev Returns true if this contract implements the interface defined by
451      * `interfaceId`. See the corresponding
452      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
453      * to learn more about how these ids are created.
454      *
455      * This function call must use less than 30000 gas.
456      */
457     function supportsInterface(bytes4 interfaceId) external view returns (bool);
458 
459     // =============================================================
460     //                            IERC721
461     // =============================================================
462 
463     /**
464      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
465      */
466     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
467 
468     /**
469      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
470      */
471     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
472 
473     /**
474      * @dev Emitted when `owner` enables or disables
475      * (`approved`) `operator` to manage all of its assets.
476      */
477     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
478 
479     /**
480      * @dev Returns the number of tokens in `owner`'s account.
481      */
482     function balanceOf(address owner) external view returns (uint256 balance);
483 
484     /**
485      * @dev Returns the owner of the `tokenId` token.
486      *
487      * Requirements:
488      *
489      * - `tokenId` must exist.
490      */
491     function ownerOf(uint256 tokenId) external view returns (address owner);
492 
493     /**
494      * @dev Safely transfers `tokenId` token from `from` to `to`,
495      * checking first that contract recipients are aware of the ERC721 protocol
496      * to prevent tokens from being forever locked.
497      *
498      * Requirements:
499      *
500      * - `from` cannot be the zero address.
501      * - `to` cannot be the zero address.
502      * - `tokenId` token must exist and be owned by `from`.
503      * - If the caller is not `from`, it must be have been allowed to move
504      * this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement
506      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
507      *
508      * Emits a {Transfer} event.
509      */
510     function safeTransferFrom(
511         address from,
512         address to,
513         uint256 tokenId,
514         bytes calldata data
515     ) external payable;
516 
517     /**
518      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
519      */
520     function safeTransferFrom(
521         address from,
522         address to,
523         uint256 tokenId
524     ) external payable;
525 
526     /**
527      * @dev Transfers `tokenId` from `from` to `to`.
528      *
529      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
530      * whenever possible.
531      *
532      * Requirements:
533      *
534      * - `from` cannot be the zero address.
535      * - `to` cannot be the zero address.
536      * - `tokenId` token must be owned by `from`.
537      * - If the caller is not `from`, it must be approved to move this token
538      * by either {approve} or {setApprovalForAll}.
539      *
540      * Emits a {Transfer} event.
541      */
542     function transferFrom(
543         address from,
544         address to,
545         uint256 tokenId
546     ) external payable;
547 
548     /**
549      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
550      * The approval is cleared when the token is transferred.
551      *
552      * Only a single account can be approved at a time, so approving the
553      * zero address clears previous approvals.
554      *
555      * Requirements:
556      *
557      * - The caller must own the token or be an approved operator.
558      * - `tokenId` must exist.
559      *
560      * Emits an {Approval} event.
561      */
562     function approve(address to, uint256 tokenId) external payable;
563 
564     /**
565      * @dev Approve or remove `operator` as an operator for the caller.
566      * Operators can call {transferFrom} or {safeTransferFrom}
567      * for any token owned by the caller.
568      *
569      * Requirements:
570      *
571      * - The `operator` cannot be the caller.
572      *
573      * Emits an {ApprovalForAll} event.
574      */
575     function setApprovalForAll(address operator, bool _approved) external;
576 
577     /**
578      * @dev Returns the account approved for `tokenId` token.
579      *
580      * Requirements:
581      *
582      * - `tokenId` must exist.
583      */
584     function getApproved(uint256 tokenId) external view returns (address operator);
585 
586     /**
587      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
588      *
589      * See {setApprovalForAll}.
590      */
591     function isApprovedForAll(address owner, address operator) external view returns (bool);
592 
593     // =============================================================
594     //                        IERC721Metadata
595     // =============================================================
596 
597     /**
598      * @dev Returns the token collection name.
599      */
600     function name() external view returns (string memory);
601 
602     /**
603      * @dev Returns the token collection symbol.
604      */
605     function symbol() external view returns (string memory);
606 
607     /**
608      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
609      */
610     function tokenURI(uint256 tokenId) external view returns (string memory);
611 
612     // =============================================================
613     //                           IERC2309
614     // =============================================================
615 
616     /**
617      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
618      * (inclusive) is transferred from `from` to `to`, as defined in the
619      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
620      *
621      * See {_mintERC2309} for more details.
622      */
623     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
624 }
625 
626 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 // CAUTION
631 // This version of SafeMath should only be used with Solidity 0.8 or later,
632 // because it relies on the compiler's built in overflow checks.
633 
634 /**
635  * @dev Wrappers over Solidity's arithmetic operations.
636  *
637  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
638  * now has built in overflow checking.
639  */
640 library SafeMath {
641     /**
642      * @dev Returns the addition of two unsigned integers, with an overflow flag.
643      *
644      * _Available since v3.4._
645      */
646     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
647         unchecked {
648             uint256 c = a + b;
649             if (c < a) return (false, 0);
650             return (true, c);
651         }
652     }
653 
654     /**
655      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
656      *
657      * _Available since v3.4._
658      */
659     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
660         unchecked {
661             if (b > a) return (false, 0);
662             return (true, a - b);
663         }
664     }
665 
666     /**
667      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
668      *
669      * _Available since v3.4._
670      */
671     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
672         unchecked {
673             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
674             // benefit is lost if 'b' is also tested.
675             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
676             if (a == 0) return (true, 0);
677             uint256 c = a * b;
678             if (c / a != b) return (false, 0);
679             return (true, c);
680         }
681     }
682 
683     /**
684      * @dev Returns the division of two unsigned integers, with a division by zero flag.
685      *
686      * _Available since v3.4._
687      */
688     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
689         unchecked {
690             if (b == 0) return (false, 0);
691             return (true, a / b);
692         }
693     }
694 
695     /**
696      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
697      *
698      * _Available since v3.4._
699      */
700     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
701         unchecked {
702             if (b == 0) return (false, 0);
703             return (true, a % b);
704         }
705     }
706 
707     /**
708      * @dev Returns the addition of two unsigned integers, reverting on
709      * overflow.
710      *
711      * Counterpart to Solidity's `+` operator.
712      *
713      * Requirements:
714      *
715      * - Addition cannot overflow.
716      */
717     function add(uint256 a, uint256 b) internal pure returns (uint256) {
718         return a + b;
719     }
720 
721     /**
722      * @dev Returns the subtraction of two unsigned integers, reverting on
723      * overflow (when the result is negative).
724      *
725      * Counterpart to Solidity's `-` operator.
726      *
727      * Requirements:
728      *
729      * - Subtraction cannot overflow.
730      */
731     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a - b;
733     }
734 
735     /**
736      * @dev Returns the multiplication of two unsigned integers, reverting on
737      * overflow.
738      *
739      * Counterpart to Solidity's `*` operator.
740      *
741      * Requirements:
742      *
743      * - Multiplication cannot overflow.
744      */
745     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
746         return a * b;
747     }
748 
749     /**
750      * @dev Returns the integer division of two unsigned integers, reverting on
751      * division by zero. The result is rounded towards zero.
752      *
753      * Counterpart to Solidity's `/` operator.
754      *
755      * Requirements:
756      *
757      * - The divisor cannot be zero.
758      */
759     function div(uint256 a, uint256 b) internal pure returns (uint256) {
760         return a / b;
761     }
762 
763     /**
764      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
765      * reverting when dividing by zero.
766      *
767      * Counterpart to Solidity's `%` operator. This function uses a `revert`
768      * opcode (which leaves remaining gas untouched) while Solidity uses an
769      * invalid opcode to revert (consuming all remaining gas).
770      *
771      * Requirements:
772      *
773      * - The divisor cannot be zero.
774      */
775     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
776         return a % b;
777     }
778 
779     /**
780      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
781      * overflow (when the result is negative).
782      *
783      * CAUTION: This function is deprecated because it requires allocating memory for the error
784      * message unnecessarily. For custom revert reasons use {trySub}.
785      *
786      * Counterpart to Solidity's `-` operator.
787      *
788      * Requirements:
789      *
790      * - Subtraction cannot overflow.
791      */
792     function sub(
793         uint256 a,
794         uint256 b,
795         string memory errorMessage
796     ) internal pure returns (uint256) {
797         unchecked {
798             require(b <= a, errorMessage);
799             return a - b;
800         }
801     }
802 
803     /**
804      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
805      * division by zero. The result is rounded towards zero.
806      *
807      * Counterpart to Solidity's `/` operator. Note: this function uses a
808      * `revert` opcode (which leaves remaining gas untouched) while Solidity
809      * uses an invalid opcode to revert (consuming all remaining gas).
810      *
811      * Requirements:
812      *
813      * - The divisor cannot be zero.
814      */
815     function div(
816         uint256 a,
817         uint256 b,
818         string memory errorMessage
819     ) internal pure returns (uint256) {
820         unchecked {
821             require(b > 0, errorMessage);
822             return a / b;
823         }
824     }
825 
826     /**
827      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
828      * reverting with custom message when dividing by zero.
829      *
830      * CAUTION: This function is deprecated because it requires allocating memory for the error
831      * message unnecessarily. For custom revert reasons use {tryMod}.
832      *
833      * Counterpart to Solidity's `%` operator. This function uses a `revert`
834      * opcode (which leaves remaining gas untouched) while Solidity uses an
835      * invalid opcode to revert (consuming all remaining gas).
836      *
837      * Requirements:
838      *
839      * - The divisor cannot be zero.
840      */
841     function mod(
842         uint256 a,
843         uint256 b,
844         string memory errorMessage
845     ) internal pure returns (uint256) {
846         unchecked {
847             require(b > 0, errorMessage);
848             return a % b;
849         }
850     }
851 }
852 
853 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
854 
855 pragma solidity ^0.8.0;
856 
857 /**
858  * @dev String operations.
859  */
860 library Strings {
861     bytes16 private constant _SYMBOLS = "0123456789abcdef";
862     uint8 private constant _ADDRESS_LENGTH = 20;
863 
864     /**
865      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
866      */
867     function toString(uint256 value) internal pure returns (string memory) {
868         unchecked {
869             uint256 length = Math.log10(value) + 1;
870             string memory buffer = new string(length);
871             uint256 ptr;
872             /// @solidity memory-safe-assembly
873             assembly {
874                 ptr := add(buffer, add(32, length))
875             }
876             while (true) {
877                 ptr--;
878                 /// @solidity memory-safe-assembly
879                 assembly {
880                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
881                 }
882                 value /= 10;
883                 if (value == 0) break;
884             }
885             return buffer;
886         }
887     }
888 
889     /**
890      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
891      */
892     function toHexString(uint256 value) internal pure returns (string memory) {
893         unchecked {
894             return toHexString(value, Math.log256(value) + 1);
895         }
896     }
897 
898     /**
899      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
900      */
901     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
902         bytes memory buffer = new bytes(2 * length + 2);
903         buffer[0] = "0";
904         buffer[1] = "x";
905         for (uint256 i = 2 * length + 1; i > 1; --i) {
906             buffer[i] = _SYMBOLS[value & 0xf];
907             value >>= 4;
908         }
909         require(value == 0, "Strings: hex length insufficient");
910         return string(buffer);
911     }
912 
913     /**
914      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
915      */
916     function toHexString(address addr) internal pure returns (string memory) {
917         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
918     }
919 }
920 
921 
922 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
923 
924 pragma solidity ^0.8.0;
925 
926 /**
927  * @dev Provides information about the current execution context, including the
928  * sender of the transaction and its data. While these are generally available
929  * via msg.sender and msg.data, they should not be accessed in such a direct
930  * manner, since when dealing with meta-transactions the account sending and
931  * paying for execution may not be the actual sender (as far as an application
932  * is concerned).
933  *
934  * This contract is only required for intermediate, library-like contracts.
935  */
936 abstract contract Context {
937     function _msgSender() internal view virtual returns (address) {
938         return msg.sender;
939     }
940 
941     function _msgData() internal view virtual returns (bytes calldata) {
942         return msg.data;
943     }
944 }
945 
946 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
947 
948 pragma solidity ^0.8.1;
949 
950 /**
951  * @dev Collection of functions related to the address type
952  */
953 library Address {
954     /**
955      * @dev Returns true if `account` is a contract.
956      *
957      * [IMPORTANT]
958      * ====
959      * It is unsafe to assume that an address for which this function returns
960      * false is an externally-owned account (EOA) and not a contract.
961      *
962      * Among others, `isContract` will return false for the following
963      * types of addresses:
964      *
965      *  - an externally-owned account
966      *  - a contract in construction
967      *  - an address where a contract will be created
968      *  - an address where a contract lived, but was destroyed
969      * ====
970      *
971      * [IMPORTANT]
972      * ====
973      * You shouldn't rely on `isContract` to protect against flash loan attacks!
974      *
975      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
976      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
977      * constructor.
978      * ====
979      */
980     function isContract(address account) internal view returns (bool) {
981         // This method relies on extcodesize/address.code.length, which returns 0
982         // for contracts in construction, since the code is only stored at the end
983         // of the constructor execution.
984 
985         return account.code.length > 0;
986     }
987 
988     /**
989      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
990      * `recipient`, forwarding all available gas and reverting on errors.
991      *
992      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
993      * of certain opcodes, possibly making contracts go over the 2300 gas limit
994      * imposed by `transfer`, making them unable to receive funds via
995      * `transfer`. {sendValue} removes this limitation.
996      *
997      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
998      *
999      * IMPORTANT: because control is transferred to `recipient`, care must be
1000      * taken to not create reentrancy vulnerabilities. Consider using
1001      * {ReentrancyGuard} or the
1002      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1003      */
1004     function sendValue(address payable recipient, uint256 amount) internal {
1005         require(address(this).balance >= amount, "Address: insufficient balance");
1006 
1007         (bool success, ) = recipient.call{value: amount}("");
1008         require(success, "Address: unable to send value, recipient may have reverted");
1009     }
1010 
1011     /**
1012      * @dev Performs a Solidity function call using a low level `call`. A
1013      * plain `call` is an unsafe replacement for a function call: use this
1014      * function instead.
1015      *
1016      * If `target` reverts with a revert reason, it is bubbled up by this
1017      * function (like regular Solidity function calls).
1018      *
1019      * Returns the raw returned data. To convert to the expected return value,
1020      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1021      *
1022      * Requirements:
1023      *
1024      * - `target` must be a contract.
1025      * - calling `target` with `data` must not revert.
1026      *
1027      * _Available since v3.1._
1028      */
1029     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1030         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1031     }
1032 
1033     /**
1034      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1035      * `errorMessage` as a fallback revert reason when `target` reverts.
1036      *
1037      * _Available since v3.1._
1038      */
1039     function functionCall(
1040         address target,
1041         bytes memory data,
1042         string memory errorMessage
1043     ) internal returns (bytes memory) {
1044         return functionCallWithValue(target, data, 0, errorMessage);
1045     }
1046 
1047     /**
1048      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1049      * but also transferring `value` wei to `target`.
1050      *
1051      * Requirements:
1052      *
1053      * - the calling contract must have an ETH balance of at least `value`.
1054      * - the called Solidity function must be `payable`.
1055      *
1056      * _Available since v3.1._
1057      */
1058     function functionCallWithValue(
1059         address target,
1060         bytes memory data,
1061         uint256 value
1062     ) internal returns (bytes memory) {
1063         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1064     }
1065 
1066     /**
1067      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1068      * with `errorMessage` as a fallback revert reason when `target` reverts.
1069      *
1070      * _Available since v3.1._
1071      */
1072     function functionCallWithValue(
1073         address target,
1074         bytes memory data,
1075         uint256 value,
1076         string memory errorMessage
1077     ) internal returns (bytes memory) {
1078         require(address(this).balance >= value, "Address: insufficient balance for call");
1079         (bool success, bytes memory returndata) = target.call{value: value}(data);
1080         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1081     }
1082 
1083     /**
1084      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1085      * but performing a static call.
1086      *
1087      * _Available since v3.3._
1088      */
1089     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1090         return functionStaticCall(target, data, "Address: low-level static call failed");
1091     }
1092 
1093     /**
1094      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1095      * but performing a static call.
1096      *
1097      * _Available since v3.3._
1098      */
1099     function functionStaticCall(
1100         address target,
1101         bytes memory data,
1102         string memory errorMessage
1103     ) internal view returns (bytes memory) {
1104         (bool success, bytes memory returndata) = target.staticcall(data);
1105         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1106     }
1107 
1108     /**
1109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1110      * but performing a delegate call.
1111      *
1112      * _Available since v3.4._
1113      */
1114     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1115         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1116     }
1117 
1118     /**
1119      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1120      * but performing a delegate call.
1121      *
1122      * _Available since v3.4._
1123      */
1124     function functionDelegateCall(
1125         address target,
1126         bytes memory data,
1127         string memory errorMessage
1128     ) internal returns (bytes memory) {
1129         (bool success, bytes memory returndata) = target.delegatecall(data);
1130         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1131     }
1132 
1133     /**
1134      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1135      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1136      *
1137      * _Available since v4.8._
1138      */
1139     function verifyCallResultFromTarget(
1140         address target,
1141         bool success,
1142         bytes memory returndata,
1143         string memory errorMessage
1144     ) internal view returns (bytes memory) {
1145         if (success) {
1146             if (returndata.length == 0) {
1147                 // only check isContract if the call was successful and the return data is empty
1148                 // otherwise we already know that it was a contract
1149                 require(isContract(target), "Address: call to non-contract");
1150             }
1151             return returndata;
1152         } else {
1153             _revert(returndata, errorMessage);
1154         }
1155     }
1156 
1157     /**
1158      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1159      * revert reason or using the provided one.
1160      *
1161      * _Available since v4.3._
1162      */
1163     function verifyCallResult(
1164         bool success,
1165         bytes memory returndata,
1166         string memory errorMessage
1167     ) internal pure returns (bytes memory) {
1168         if (success) {
1169             return returndata;
1170         } else {
1171             _revert(returndata, errorMessage);
1172         }
1173     }
1174 
1175     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1176         // Look for revert reason and bubble it up if present
1177         if (returndata.length > 0) {
1178             // The easiest way to bubble the revert reason is using memory via assembly
1179             /// @solidity memory-safe-assembly
1180             assembly {
1181                 let returndata_size := mload(returndata)
1182                 revert(add(32, returndata), returndata_size)
1183             }
1184         } else {
1185             revert(errorMessage);
1186         }
1187     }
1188 }
1189 
1190 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 /**
1195  * @dev Contract module which provides a basic access control mechanism, where
1196  * there is an account (an owner) that can be granted exclusive access to
1197  * specific functions.
1198  *
1199  * By default, the owner account will be the one that deploys the contract. This
1200  * can later be changed with {transferOwnership}.
1201  *
1202  * This module is used through inheritance. It will make available the modifier
1203  * `onlyOwner`, which can be applied to your functions to restrict their use to
1204  * the owner.
1205  */
1206 abstract contract Ownable is Context {
1207     address private _owner;
1208 
1209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1210 
1211     /**
1212      * @dev Initializes the contract setting the deployer as the initial owner.
1213      */
1214     constructor() {
1215         _transferOwnership(_msgSender());
1216     }
1217 
1218     /**
1219      * @dev Throws if called by any account other than the owner.
1220      */
1221     modifier onlyOwner() {
1222         _checkOwner();
1223         _;
1224     }
1225 
1226     /**
1227      * @dev Returns the address of the current owner.
1228      */
1229     function owner() public view virtual returns (address) {
1230         return _owner;
1231     }
1232 
1233     /**
1234      * @dev Throws if the sender is not the owner.
1235      */
1236     function _checkOwner() internal view virtual {
1237         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1238     }
1239 
1240     /**
1241      * @dev Leaves the contract without owner. It will not be possible to call
1242      * `onlyOwner` functions anymore. Can only be called by the current owner.
1243      *
1244      * NOTE: Renouncing ownership will leave the contract without an owner,
1245      * thereby removing any functionality that is only available to the owner.
1246      */
1247     function renounceOwnership() public virtual onlyOwner {
1248         _transferOwnership(address(0));
1249     }
1250 
1251     /**
1252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1253      * Can only be called by the current owner.
1254      */
1255     function transferOwnership(address newOwner) public virtual onlyOwner {
1256         require(newOwner != address(0), "Ownable: new owner is the zero address");
1257         _transferOwnership(newOwner);
1258     }
1259 
1260     /**
1261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1262      * Internal function without access restriction.
1263      */
1264     function _transferOwnership(address newOwner) internal virtual {
1265         address oldOwner = _owner;
1266         _owner = newOwner;
1267         emit OwnershipTransferred(oldOwner, newOwner);
1268     }
1269 }
1270 
1271 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 /**
1276  * @dev Contract module that helps prevent reentrant calls to a function.
1277  *
1278  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1279  * available, which can be applied to functions to make sure there are no nested
1280  * (reentrant) calls to them.
1281  *
1282  * Note that because there is a single `nonReentrant` guard, functions marked as
1283  * `nonReentrant` may not call one another. This can be worked around by making
1284  * those functions `private`, and then adding `external` `nonReentrant` entry
1285  * points to them.
1286  *
1287  * TIP: If you would like to learn more about reentrancy and alternative ways
1288  * to protect against it, check out our blog post
1289  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1290  */
1291 abstract contract ReentrancyGuard {
1292     // Booleans are more expensive than uint256 or any type that takes up a full
1293     // word because each write operation emits an extra SLOAD to first read the
1294     // slot's contents, replace the bits taken up by the boolean, and then write
1295     // back. This is the compiler's defense against contract upgrades and
1296     // pointer aliasing, and it cannot be disabled.
1297 
1298     // The values being non-zero value makes deployment a bit more expensive,
1299     // but in exchange the refund on every call to nonReentrant will be lower in
1300     // amount. Since refunds are capped to a percentage of the total
1301     // transaction's gas, it is best to keep them low in cases like this one, to
1302     // increase the likelihood of the full refund coming into effect.
1303     uint256 private constant _NOT_ENTERED = 1;
1304     uint256 private constant _ENTERED = 2;
1305 
1306     uint256 private _status;
1307 
1308     constructor() {
1309         _status = _NOT_ENTERED;
1310     }
1311 
1312     /**
1313      * @dev Prevents a contract from calling itself, directly or indirectly.
1314      * Calling a `nonReentrant` function from another `nonReentrant`
1315      * function is not supported. It is possible to prevent this from happening
1316      * by making the `nonReentrant` function external, and making it call a
1317      * `private` function that does the actual work.
1318      */
1319     modifier nonReentrant() {
1320         _nonReentrantBefore();
1321         _;
1322         _nonReentrantAfter();
1323     }
1324 
1325     function _nonReentrantBefore() private {
1326         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1327         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1328 
1329         // Any calls to nonReentrant after this point will fail
1330         _status = _ENTERED;
1331     }
1332 
1333     function _nonReentrantAfter() private {
1334         // By storing the original value once again, a refund is triggered (see
1335         // https://eips.ethereum.org/EIPS/eip-2200)
1336         _status = _NOT_ENTERED;
1337     }
1338 }
1339 
1340 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1341 
1342 pragma solidity ^0.8.0;
1343 
1344 /**
1345  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1346  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1347  *
1348  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1349  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1350  * need to send a transaction, and thus is not required to hold Ether at all.
1351  */
1352 interface IERC20Permit {
1353     /**
1354      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1355      * given ``owner``'s signed approval.
1356      *
1357      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1358      * ordering also apply here.
1359      *
1360      * Emits an {Approval} event.
1361      *
1362      * Requirements:
1363      *
1364      * - `spender` cannot be the zero address.
1365      * - `deadline` must be a timestamp in the future.
1366      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1367      * over the EIP712-formatted function arguments.
1368      * - the signature must use ``owner``'s current nonce (see {nonces}).
1369      *
1370      * For more information on the signature format, see the
1371      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1372      * section].
1373      */
1374     function permit(
1375         address owner,
1376         address spender,
1377         uint256 value,
1378         uint256 deadline,
1379         uint8 v,
1380         bytes32 r,
1381         bytes32 s
1382     ) external;
1383 
1384     /**
1385      * @dev Returns the current nonce for `owner`. This value must be
1386      * included whenever a signature is generated for {permit}.
1387      *
1388      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1389      * prevents a signature from being used multiple times.
1390      */
1391     function nonces(address owner) external view returns (uint256);
1392 
1393     /**
1394      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1395      */
1396     // solhint-disable-next-line func-name-mixedcase
1397     function DOMAIN_SEPARATOR() external view returns (bytes32);
1398 }
1399 
1400 
1401 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
1402 
1403 pragma solidity ^0.8.0;
1404 
1405 /**
1406  * @title SafeERC20
1407  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1408  * contract returns false). Tokens that return no value (and instead revert or
1409  * throw on failure) are also supported, non-reverting calls are assumed to be
1410  * successful.
1411  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1412  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1413  */
1414 library SafeERC20 {
1415     using Address for address;
1416 
1417     function safeTransfer(
1418         IERC20 token,
1419         address to,
1420         uint256 value
1421     ) internal {
1422         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1423     }
1424 
1425     function safeTransferFrom(
1426         IERC20 token,
1427         address from,
1428         address to,
1429         uint256 value
1430     ) internal {
1431         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1432     }
1433 
1434     /**
1435      * @dev Deprecated. This function has issues similar to the ones found in
1436      * {IERC20-approve}, and its usage is discouraged.
1437      *
1438      * Whenever possible, use {safeIncreaseAllowance} and
1439      * {safeDecreaseAllowance} instead.
1440      */
1441     function safeApprove(
1442         IERC20 token,
1443         address spender,
1444         uint256 value
1445     ) internal {
1446         // safeApprove should only be called when setting an initial allowance,
1447         // or when resetting it to zero. To increase and decrease it, use
1448         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1449         require(
1450             (value == 0) || (token.allowance(address(this), spender) == 0),
1451             "SafeERC20: approve from non-zero to non-zero allowance"
1452         );
1453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1454     }
1455 
1456     function safeIncreaseAllowance(
1457         IERC20 token,
1458         address spender,
1459         uint256 value
1460     ) internal {
1461         uint256 newAllowance = token.allowance(address(this), spender) + value;
1462         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1463     }
1464 
1465     function safeDecreaseAllowance(
1466         IERC20 token,
1467         address spender,
1468         uint256 value
1469     ) internal {
1470         unchecked {
1471             uint256 oldAllowance = token.allowance(address(this), spender);
1472             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1473             uint256 newAllowance = oldAllowance - value;
1474             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1475         }
1476     }
1477 
1478     function safePermit(
1479         IERC20Permit token,
1480         address owner,
1481         address spender,
1482         uint256 value,
1483         uint256 deadline,
1484         uint8 v,
1485         bytes32 r,
1486         bytes32 s
1487     ) internal {
1488         uint256 nonceBefore = token.nonces(owner);
1489         token.permit(owner, spender, value, deadline, v, r, s);
1490         uint256 nonceAfter = token.nonces(owner);
1491         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1492     }
1493 
1494     /**
1495      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1496      * on the return value: the return value is optional (but if data is returned, it must not be false).
1497      * @param token The token targeted by the call.
1498      * @param data The call data (encoded using abi.encode or one of its variants).
1499      */
1500     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1501         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1502         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1503         // the target address contains contract code and also asserts for success in the low-level call.
1504 
1505         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1506         if (returndata.length > 0) {
1507             // Return data is optional
1508             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1509         }
1510     }
1511 }
1512 
1513 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1514 
1515 pragma solidity ^0.8.0;
1516 
1517 /**
1518  * @dev Interface of the ERC20 standard as defined in the EIP.
1519  */
1520 interface IERC20 {
1521     /**
1522      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1523      * another (`to`).
1524      *
1525      * Note that `value` may be zero.
1526      */
1527     event Transfer(address indexed from, address indexed to, uint256 value);
1528 
1529     /**
1530      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1531      * a call to {approve}. `value` is the new allowance.
1532      */
1533     event Approval(address indexed owner, address indexed spender, uint256 value);
1534 
1535     /**
1536      * @dev Returns the amount of tokens in existence.
1537      */
1538     function totalSupply() external view returns (uint256);
1539 
1540     /**
1541      * @dev Returns the amount of tokens owned by `account`.
1542      */
1543     function balanceOf(address account) external view returns (uint256);
1544 
1545     /**
1546      * @dev Moves `amount` tokens from the caller's account to `to`.
1547      *
1548      * Returns a boolean value indicating whether the operation succeeded.
1549      *
1550      * Emits a {Transfer} event.
1551      */
1552     function transfer(address to, uint256 amount) external returns (bool);
1553 
1554     /**
1555      * @dev Returns the remaining number of tokens that `spender` will be
1556      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1557      * zero by default.
1558      *
1559      * This value changes when {approve} or {transferFrom} are called.
1560      */
1561     function allowance(address owner, address spender) external view returns (uint256);
1562 
1563     /**
1564      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1565      *
1566      * Returns a boolean value indicating whether the operation succeeded.
1567      *
1568      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1569      * that someone may use both the old and the new allowance by unfortunate
1570      * transaction ordering. One possible solution to mitigate this race
1571      * condition is to first reduce the spender's allowance to 0 and set the
1572      * desired value afterwards:
1573      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1574      *
1575      * Emits an {Approval} event.
1576      */
1577     function approve(address spender, uint256 amount) external returns (bool);
1578 
1579     /**
1580      * @dev Moves `amount` tokens from `from` to `to` using the
1581      * allowance mechanism. `amount` is then deducted from the caller's
1582      * allowance.
1583      *
1584      * Returns a boolean value indicating whether the operation succeeded.
1585      *
1586      * Emits a {Transfer} event.
1587      */
1588     function transferFrom(
1589         address from,
1590         address to,
1591         uint256 amount
1592     ) external returns (bool);
1593 }
1594 
1595 // ERC721A Contracts v4.2.3
1596 // Creator: Chiru Labs
1597 
1598 pragma solidity ^0.8.4;
1599 
1600 /**
1601  * @dev Interface of ERC721 token receiver.
1602  */
1603 interface ERC721A__IERC721Receiver {
1604     function onERC721Received(
1605         address operator,
1606         address from,
1607         uint256 tokenId,
1608         bytes calldata data
1609     ) external returns (bytes4);
1610 }
1611 
1612 /**
1613  * @title ERC721A
1614  *
1615  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1616  * Non-Fungible Token Standard, including the Metadata extension.
1617  * Optimized for lower gas during batch mints.
1618  *
1619  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1620  * starting from `_startTokenId()`.
1621  *
1622  * Assumptions:
1623  *
1624  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1625  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1626  */
1627 contract ERC721A is IERC721A {
1628     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1629     struct TokenApprovalRef {
1630         address value;
1631     }
1632 
1633     // =============================================================
1634     //                           CONSTANTS
1635     // =============================================================
1636 
1637     // Mask of an entry in packed address data.
1638     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1639 
1640     // The bit position of `numberMinted` in packed address data.
1641     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1642 
1643     // The bit position of `numberBurned` in packed address data.
1644     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1645 
1646     // The bit position of `aux` in packed address data.
1647     uint256 private constant _BITPOS_AUX = 192;
1648 
1649     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1650     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1651 
1652     // The bit position of `startTimestamp` in packed ownership.
1653     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1654 
1655     // The bit mask of the `burned` bit in packed ownership.
1656     uint256 private constant _BITMASK_BURNED = 1 << 224;
1657 
1658     // The bit position of the `nextInitialized` bit in packed ownership.
1659     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1660 
1661     // The bit mask of the `nextInitialized` bit in packed ownership.
1662     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1663 
1664     // The bit position of `extraData` in packed ownership.
1665     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1666 
1667     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1668     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1669 
1670     // The mask of the lower 160 bits for addresses.
1671     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1672 
1673     // The maximum `quantity` that can be minted with {_mintERC2309}.
1674     // This limit is to prevent overflows on the address data entries.
1675     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1676     // is required to cause an overflow, which is unrealistic.
1677     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1678 
1679     // The `Transfer` event signature is given by:
1680     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1681     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1682         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1683 
1684     // =============================================================
1685     //                            STORAGE
1686     // =============================================================
1687 
1688     // The next token ID to be minted.
1689     uint256 private _currentIndex;
1690 
1691     // The number of tokens burned.
1692     uint256 private _burnCounter;
1693 
1694     // Token name
1695     string private _name;
1696 
1697     // Token symbol
1698     string private _symbol;
1699 
1700     // Mapping from token ID to ownership details
1701     // An empty struct value does not necessarily mean the token is unowned.
1702     // See {_packedOwnershipOf} implementation for details.
1703     //
1704     // Bits Layout:
1705     // - [0..159]   `addr`
1706     // - [160..223] `startTimestamp`
1707     // - [224]      `burned`
1708     // - [225]      `nextInitialized`
1709     // - [232..255] `extraData`
1710     mapping(uint256 => uint256) private _packedOwnerships;
1711 
1712     // Mapping owner address to address data.
1713     //
1714     // Bits Layout:
1715     // - [0..63]    `balance`
1716     // - [64..127]  `numberMinted`
1717     // - [128..191] `numberBurned`
1718     // - [192..255] `aux`
1719     mapping(address => uint256) private _packedAddressData;
1720 
1721     // Mapping from token ID to approved address.
1722     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1723 
1724     // Mapping from owner to operator approvals
1725     mapping(address => mapping(address => bool)) private _operatorApprovals;
1726 
1727     // =============================================================
1728     //                          CONSTRUCTOR
1729     // =============================================================
1730 
1731     constructor(string memory name_, string memory symbol_) {
1732         _name = name_;
1733         _symbol = symbol_;
1734         _currentIndex = _startTokenId();
1735     }
1736 
1737     // =============================================================
1738     //                   TOKEN COUNTING OPERATIONS
1739     // =============================================================
1740 
1741     /**
1742      * @dev Returns the starting token ID.
1743      * To change the starting token ID, please override this function.
1744      */
1745     function _startTokenId() internal view virtual returns (uint256) {
1746         return 0;
1747     }
1748 
1749     /**
1750      * @dev Returns the next token ID to be minted.
1751      */
1752     function _nextTokenId() internal view virtual returns (uint256) {
1753         return _currentIndex;
1754     }
1755 
1756     /**
1757      * @dev Returns the total number of tokens in existence.
1758      * Burned tokens will reduce the count.
1759      * To get the total number of tokens minted, please see {_totalMinted}.
1760      */
1761     function totalSupply() public view virtual override returns (uint256) {
1762         // Counter underflow is impossible as _burnCounter cannot be incremented
1763         // more than `_currentIndex - _startTokenId()` times.
1764         unchecked {
1765             return _currentIndex - _burnCounter - _startTokenId();
1766         }
1767     }
1768 
1769     /**
1770      * @dev Returns the total amount of tokens minted in the contract.
1771      */
1772     function _totalMinted() internal view virtual returns (uint256) {
1773         // Counter underflow is impossible as `_currentIndex` does not decrement,
1774         // and it is initialized to `_startTokenId()`.
1775         unchecked {
1776             return _currentIndex - _startTokenId();
1777         }
1778     }
1779 
1780     /**
1781      * @dev Returns the total number of tokens burned.
1782      */
1783     function _totalBurned() internal view virtual returns (uint256) {
1784         return _burnCounter;
1785     }
1786 
1787     // =============================================================
1788     //                    ADDRESS DATA OPERATIONS
1789     // =============================================================
1790 
1791     /**
1792      * @dev Returns the number of tokens in `owner`'s account.
1793      */
1794     function balanceOf(address owner) public view virtual override returns (uint256) {
1795         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1796         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1797     }
1798 
1799     /**
1800      * Returns the number of tokens minted by `owner`.
1801      */
1802     function _numberMinted(address owner) internal view returns (uint256) {
1803         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1804     }
1805 
1806     /**
1807      * Returns the number of tokens burned by or on behalf of `owner`.
1808      */
1809     function _numberBurned(address owner) internal view returns (uint256) {
1810         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1811     }
1812 
1813     /**
1814      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1815      */
1816     function _getAux(address owner) internal view returns (uint64) {
1817         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1818     }
1819 
1820     /**
1821      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1822      * If there are multiple variables, please pack them into a uint64.
1823      */
1824     function _setAux(address owner, uint64 aux) internal virtual {
1825         uint256 packed = _packedAddressData[owner];
1826         uint256 auxCasted;
1827         // Cast `aux` with assembly to avoid redundant masking.
1828         assembly {
1829             auxCasted := aux
1830         }
1831         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1832         _packedAddressData[owner] = packed;
1833     }
1834 
1835     // =============================================================
1836     //                            IERC165
1837     // =============================================================
1838 
1839     /**
1840      * @dev Returns true if this contract implements the interface defined by
1841      * `interfaceId`. See the corresponding
1842      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1843      * to learn more about how these ids are created.
1844      *
1845      * This function call must use less than 30000 gas.
1846      */
1847     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1848         // The interface IDs are constants representing the first 4 bytes
1849         // of the XOR of all function selectors in the interface.
1850         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1851         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1852         return
1853             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1854             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1855             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1856     }
1857 
1858     // =============================================================
1859     //                        IERC721Metadata
1860     // =============================================================
1861 
1862     /**
1863      * @dev Returns the token collection name.
1864      */
1865     function name() public view virtual override returns (string memory) {
1866         return _name;
1867     }
1868 
1869     /**
1870      * @dev Returns the token collection symbol.
1871      */
1872     function symbol() public view virtual override returns (string memory) {
1873         return _symbol;
1874     }
1875 
1876     /**
1877      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1878      */
1879     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1880         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1881 
1882         string memory baseURI = _baseURI();
1883         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1884     }
1885 
1886     /**
1887      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1888      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1889      * by default, it can be overridden in child contracts.
1890      */
1891     function _baseURI() internal view virtual returns (string memory) {
1892         return '';
1893     }
1894 
1895     // =============================================================
1896     //                     OWNERSHIPS OPERATIONS
1897     // =============================================================
1898 
1899     /**
1900      * @dev Returns the owner of the `tokenId` token.
1901      *
1902      * Requirements:
1903      *
1904      * - `tokenId` must exist.
1905      */
1906     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1907         return address(uint160(_packedOwnershipOf(tokenId)));
1908     }
1909 
1910     /**
1911      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1912      * It gradually moves to O(1) as tokens get transferred around over time.
1913      */
1914     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1915         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1916     }
1917 
1918     /**
1919      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1920      */
1921     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1922         return _unpackedOwnership(_packedOwnerships[index]);
1923     }
1924 
1925     /**
1926      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1927      */
1928     function _initializeOwnershipAt(uint256 index) internal virtual {
1929         if (_packedOwnerships[index] == 0) {
1930             _packedOwnerships[index] = _packedOwnershipOf(index);
1931         }
1932     }
1933 
1934     /**
1935      * Returns the packed ownership data of `tokenId`.
1936      */
1937     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1938         uint256 curr = tokenId;
1939 
1940         unchecked {
1941             if (_startTokenId() <= curr)
1942                 if (curr < _currentIndex) {
1943                     uint256 packed = _packedOwnerships[curr];
1944                     // If not burned.
1945                     if (packed & _BITMASK_BURNED == 0) {
1946                         // Invariant:
1947                         // There will always be an initialized ownership slot
1948                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1949                         // before an unintialized ownership slot
1950                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1951                         // Hence, `curr` will not underflow.
1952                         //
1953                         // We can directly compare the packed value.
1954                         // If the address is zero, packed will be zero.
1955                         while (packed == 0) {
1956                             packed = _packedOwnerships[--curr];
1957                         }
1958                         return packed;
1959                     }
1960                 }
1961         }
1962         revert OwnerQueryForNonexistentToken();
1963     }
1964 
1965     /**
1966      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1967      */
1968     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1969         ownership.addr = address(uint160(packed));
1970         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1971         ownership.burned = packed & _BITMASK_BURNED != 0;
1972         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1973     }
1974 
1975     /**
1976      * @dev Packs ownership data into a single uint256.
1977      */
1978     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1979         assembly {
1980             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1981             owner := and(owner, _BITMASK_ADDRESS)
1982             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1983             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1984         }
1985     }
1986 
1987     /**
1988      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1989      */
1990     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1991         // For branchless setting of the `nextInitialized` flag.
1992         assembly {
1993             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1994             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1995         }
1996     }
1997 
1998     // =============================================================
1999     //                      APPROVAL OPERATIONS
2000     // =============================================================
2001 
2002     /**
2003      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2004      * The approval is cleared when the token is transferred.
2005      *
2006      * Only a single account can be approved at a time, so approving the
2007      * zero address clears previous approvals.
2008      *
2009      * Requirements:
2010      *
2011      * - The caller must own the token or be an approved operator.
2012      * - `tokenId` must exist.
2013      *
2014      * Emits an {Approval} event.
2015      */
2016     function approve(address to, uint256 tokenId) public payable virtual override {
2017         address owner = ownerOf(tokenId);
2018 
2019         if (_msgSenderERC721A() != owner)
2020             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2021                 revert ApprovalCallerNotOwnerNorApproved();
2022             }
2023 
2024         _tokenApprovals[tokenId].value = to;
2025         emit Approval(owner, to, tokenId);
2026     }
2027 
2028     /**
2029      * @dev Returns the account approved for `tokenId` token.
2030      *
2031      * Requirements:
2032      *
2033      * - `tokenId` must exist.
2034      */
2035     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2036         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2037 
2038         return _tokenApprovals[tokenId].value;
2039     }
2040 
2041     /**
2042      * @dev Approve or remove `operator` as an operator for the caller.
2043      * Operators can call {transferFrom} or {safeTransferFrom}
2044      * for any token owned by the caller.
2045      *
2046      * Requirements:
2047      *
2048      * - The `operator` cannot be the caller.
2049      *
2050      * Emits an {ApprovalForAll} event.
2051      */
2052     function setApprovalForAll(address operator, bool approved) public virtual override {
2053         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2054         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2055     }
2056 
2057     /**
2058      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2059      *
2060      * See {setApprovalForAll}.
2061      */
2062     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2063         return _operatorApprovals[owner][operator];
2064     }
2065 
2066     /**
2067      * @dev Returns whether `tokenId` exists.
2068      *
2069      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2070      *
2071      * Tokens start existing when they are minted. See {_mint}.
2072      */
2073     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2074         return
2075             _startTokenId() <= tokenId &&
2076             tokenId < _currentIndex && // If within bounds,
2077             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2078     }
2079 
2080     /**
2081      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2082      */
2083     function _isSenderApprovedOrOwner(
2084         address approvedAddress,
2085         address owner,
2086         address msgSender
2087     ) private pure returns (bool result) {
2088         assembly {
2089             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2090             owner := and(owner, _BITMASK_ADDRESS)
2091             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2092             msgSender := and(msgSender, _BITMASK_ADDRESS)
2093             // `msgSender == owner || msgSender == approvedAddress`.
2094             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2095         }
2096     }
2097 
2098     /**
2099      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2100      */
2101     function _getApprovedSlotAndAddress(uint256 tokenId)
2102         private
2103         view
2104         returns (uint256 approvedAddressSlot, address approvedAddress)
2105     {
2106         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2107         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2108         assembly {
2109             approvedAddressSlot := tokenApproval.slot
2110             approvedAddress := sload(approvedAddressSlot)
2111         }
2112     }
2113 
2114     // =============================================================
2115     //                      TRANSFER OPERATIONS
2116     // =============================================================
2117 
2118     /**
2119      * @dev Transfers `tokenId` from `from` to `to`.
2120      *
2121      * Requirements:
2122      *
2123      * - `from` cannot be the zero address.
2124      * - `to` cannot be the zero address.
2125      * - `tokenId` token must be owned by `from`.
2126      * - If the caller is not `from`, it must be approved to move this token
2127      * by either {approve} or {setApprovalForAll}.
2128      *
2129      * Emits a {Transfer} event.
2130      */
2131     function transferFrom(
2132         address from,
2133         address to,
2134         uint256 tokenId
2135     ) public payable virtual override {
2136         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2137 
2138         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2139 
2140         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2141 
2142         // The nested ifs save around 20+ gas over a compound boolean condition.
2143         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2144             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2145 
2146         if (to == address(0)) revert TransferToZeroAddress();
2147 
2148         _beforeTokenTransfers(from, to, tokenId, 1);
2149 
2150         // Clear approvals from the previous owner.
2151         assembly {
2152             if approvedAddress {
2153                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2154                 sstore(approvedAddressSlot, 0)
2155             }
2156         }
2157 
2158         // Underflow of the sender's balance is impossible because we check for
2159         // ownership above and the recipient's balance can't realistically overflow.
2160         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2161         unchecked {
2162             // We can directly increment and decrement the balances.
2163             --_packedAddressData[from]; // Updates: `balance -= 1`.
2164             ++_packedAddressData[to]; // Updates: `balance += 1`.
2165 
2166             // Updates:
2167             // - `address` to the next owner.
2168             // - `startTimestamp` to the timestamp of transfering.
2169             // - `burned` to `false`.
2170             // - `nextInitialized` to `true`.
2171             _packedOwnerships[tokenId] = _packOwnershipData(
2172                 to,
2173                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2174             );
2175 
2176             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2177             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2178                 uint256 nextTokenId = tokenId + 1;
2179                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2180                 if (_packedOwnerships[nextTokenId] == 0) {
2181                     // If the next slot is within bounds.
2182                     if (nextTokenId != _currentIndex) {
2183                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2184                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2185                     }
2186                 }
2187             }
2188         }
2189 
2190         emit Transfer(from, to, tokenId);
2191         _afterTokenTransfers(from, to, tokenId, 1);
2192     }
2193 
2194     /**
2195      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2196      */
2197     function safeTransferFrom(
2198         address from,
2199         address to,
2200         uint256 tokenId
2201     ) public payable virtual override {
2202         safeTransferFrom(from, to, tokenId, '');
2203     }
2204 
2205     /**
2206      * @dev Safely transfers `tokenId` token from `from` to `to`.
2207      *
2208      * Requirements:
2209      *
2210      * - `from` cannot be the zero address.
2211      * - `to` cannot be the zero address.
2212      * - `tokenId` token must exist and be owned by `from`.
2213      * - If the caller is not `from`, it must be approved to move this token
2214      * by either {approve} or {setApprovalForAll}.
2215      * - If `to` refers to a smart contract, it must implement
2216      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2217      *
2218      * Emits a {Transfer} event.
2219      */
2220     function safeTransferFrom(
2221         address from,
2222         address to,
2223         uint256 tokenId,
2224         bytes memory _data
2225     ) public payable virtual override {
2226         transferFrom(from, to, tokenId);
2227         if (to.code.length != 0)
2228             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2229                 revert TransferToNonERC721ReceiverImplementer();
2230             }
2231     }
2232 
2233     /**
2234      * @dev Hook that is called before a set of serially-ordered token IDs
2235      * are about to be transferred. This includes minting.
2236      * And also called before burning one token.
2237      *
2238      * `startTokenId` - the first token ID to be transferred.
2239      * `quantity` - the amount to be transferred.
2240      *
2241      * Calling conditions:
2242      *
2243      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2244      * transferred to `to`.
2245      * - When `from` is zero, `tokenId` will be minted for `to`.
2246      * - When `to` is zero, `tokenId` will be burned by `from`.
2247      * - `from` and `to` are never both zero.
2248      */
2249     function _beforeTokenTransfers(
2250         address from,
2251         address to,
2252         uint256 startTokenId,
2253         uint256 quantity
2254     ) internal virtual {}
2255 
2256     /**
2257      * @dev Hook that is called after a set of serially-ordered token IDs
2258      * have been transferred. This includes minting.
2259      * And also called after one token has been burned.
2260      *
2261      * `startTokenId` - the first token ID to be transferred.
2262      * `quantity` - the amount to be transferred.
2263      *
2264      * Calling conditions:
2265      *
2266      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2267      * transferred to `to`.
2268      * - When `from` is zero, `tokenId` has been minted for `to`.
2269      * - When `to` is zero, `tokenId` has been burned by `from`.
2270      * - `from` and `to` are never both zero.
2271      */
2272     function _afterTokenTransfers(
2273         address from,
2274         address to,
2275         uint256 startTokenId,
2276         uint256 quantity
2277     ) internal virtual {}
2278 
2279     /**
2280      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2281      *
2282      * `from` - Previous owner of the given token ID.
2283      * `to` - Target address that will receive the token.
2284      * `tokenId` - Token ID to be transferred.
2285      * `_data` - Optional data to send along with the call.
2286      *
2287      * Returns whether the call correctly returned the expected magic value.
2288      */
2289     function _checkContractOnERC721Received(
2290         address from,
2291         address to,
2292         uint256 tokenId,
2293         bytes memory _data
2294     ) private returns (bool) {
2295         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2296             bytes4 retval
2297         ) {
2298             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2299         } catch (bytes memory reason) {
2300             if (reason.length == 0) {
2301                 revert TransferToNonERC721ReceiverImplementer();
2302             } else {
2303                 assembly {
2304                     revert(add(32, reason), mload(reason))
2305                 }
2306             }
2307         }
2308     }
2309 
2310     // =============================================================
2311     //                        MINT OPERATIONS
2312     // =============================================================
2313 
2314     /**
2315      * @dev Mints `quantity` tokens and transfers them to `to`.
2316      *
2317      * Requirements:
2318      *
2319      * - `to` cannot be the zero address.
2320      * - `quantity` must be greater than 0.
2321      *
2322      * Emits a {Transfer} event for each mint.
2323      */
2324     function _mint(address to, uint256 quantity) internal virtual {
2325         uint256 startTokenId = _currentIndex;
2326         if (quantity == 0) revert MintZeroQuantity();
2327 
2328         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2329 
2330         // Overflows are incredibly unrealistic.
2331         // `balance` and `numberMinted` have a maximum limit of 2**64.
2332         // `tokenId` has a maximum limit of 2**256.
2333         unchecked {
2334             // Updates:
2335             // - `balance += quantity`.
2336             // - `numberMinted += quantity`.
2337             //
2338             // We can directly add to the `balance` and `numberMinted`.
2339             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2340 
2341             // Updates:
2342             // - `address` to the owner.
2343             // - `startTimestamp` to the timestamp of minting.
2344             // - `burned` to `false`.
2345             // - `nextInitialized` to `quantity == 1`.
2346             _packedOwnerships[startTokenId] = _packOwnershipData(
2347                 to,
2348                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2349             );
2350 
2351             uint256 toMasked;
2352             uint256 end = startTokenId + quantity;
2353 
2354             // Use assembly to loop and emit the `Transfer` event for gas savings.
2355             // The duplicated `log4` removes an extra check and reduces stack juggling.
2356             // The assembly, together with the surrounding Solidity code, have been
2357             // delicately arranged to nudge the compiler into producing optimized opcodes.
2358             assembly {
2359                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2360                 toMasked := and(to, _BITMASK_ADDRESS)
2361                 // Emit the `Transfer` event.
2362                 log4(
2363                     0, // Start of data (0, since no data).
2364                     0, // End of data (0, since no data).
2365                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2366                     0, // `address(0)`.
2367                     toMasked, // `to`.
2368                     startTokenId // `tokenId`.
2369                 )
2370 
2371                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2372                 // that overflows uint256 will make the loop run out of gas.
2373                 // The compiler will optimize the `iszero` away for performance.
2374                 for {
2375                     let tokenId := add(startTokenId, 1)
2376                 } iszero(eq(tokenId, end)) {
2377                     tokenId := add(tokenId, 1)
2378                 } {
2379                     // Emit the `Transfer` event. Similar to above.
2380                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2381                 }
2382             }
2383             if (toMasked == 0) revert MintToZeroAddress();
2384 
2385             _currentIndex = end;
2386         }
2387         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2388     }
2389 
2390     /**
2391      * @dev Mints `quantity` tokens and transfers them to `to`.
2392      *
2393      * This function is intended for efficient minting only during contract creation.
2394      *
2395      * It emits only one {ConsecutiveTransfer} as defined in
2396      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2397      * instead of a sequence of {Transfer} event(s).
2398      *
2399      * Calling this function outside of contract creation WILL make your contract
2400      * non-compliant with the ERC721 standard.
2401      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2402      * {ConsecutiveTransfer} event is only permissible during contract creation.
2403      *
2404      * Requirements:
2405      *
2406      * - `to` cannot be the zero address.
2407      * - `quantity` must be greater than 0.
2408      *
2409      * Emits a {ConsecutiveTransfer} event.
2410      */
2411     function _mintERC2309(address to, uint256 quantity) internal virtual {
2412         uint256 startTokenId = _currentIndex;
2413         if (to == address(0)) revert MintToZeroAddress();
2414         if (quantity == 0) revert MintZeroQuantity();
2415         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2416 
2417         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2418 
2419         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2420         unchecked {
2421             // Updates:
2422             // - `balance += quantity`.
2423             // - `numberMinted += quantity`.
2424             //
2425             // We can directly add to the `balance` and `numberMinted`.
2426             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2427 
2428             // Updates:
2429             // - `address` to the owner.
2430             // - `startTimestamp` to the timestamp of minting.
2431             // - `burned` to `false`.
2432             // - `nextInitialized` to `quantity == 1`.
2433             _packedOwnerships[startTokenId] = _packOwnershipData(
2434                 to,
2435                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2436             );
2437 
2438             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2439 
2440             _currentIndex = startTokenId + quantity;
2441         }
2442         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2443     }
2444 
2445     /**
2446      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2447      *
2448      * Requirements:
2449      *
2450      * - If `to` refers to a smart contract, it must implement
2451      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2452      * - `quantity` must be greater than 0.
2453      *
2454      * See {_mint}.
2455      *
2456      * Emits a {Transfer} event for each mint.
2457      */
2458     function _safeMint(
2459         address to,
2460         uint256 quantity,
2461         bytes memory _data
2462     ) internal virtual {
2463         _mint(to, quantity);
2464 
2465         unchecked {
2466             if (to.code.length != 0) {
2467                 uint256 end = _currentIndex;
2468                 uint256 index = end - quantity;
2469                 do {
2470                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2471                         revert TransferToNonERC721ReceiverImplementer();
2472                     }
2473                 } while (index < end);
2474                 // Reentrancy protection.
2475                 if (_currentIndex != end) revert();
2476             }
2477         }
2478     }
2479 
2480     /**
2481      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2482      */
2483     function _safeMint(address to, uint256 quantity) internal virtual {
2484         _safeMint(to, quantity, '');
2485     }
2486 
2487     // =============================================================
2488     //                        BURN OPERATIONS
2489     // =============================================================
2490 
2491     /**
2492      * @dev Equivalent to `_burn(tokenId, false)`.
2493      */
2494     function _burn(uint256 tokenId) internal virtual {
2495         _burn(tokenId, false);
2496     }
2497 
2498     /**
2499      * @dev Destroys `tokenId`.
2500      * The approval is cleared when the token is burned.
2501      *
2502      * Requirements:
2503      *
2504      * - `tokenId` must exist.
2505      *
2506      * Emits a {Transfer} event.
2507      */
2508     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2509         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2510 
2511         address from = address(uint160(prevOwnershipPacked));
2512 
2513         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2514 
2515         if (approvalCheck) {
2516             // The nested ifs save around 20+ gas over a compound boolean condition.
2517             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2518                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2519         }
2520 
2521         _beforeTokenTransfers(from, address(0), tokenId, 1);
2522 
2523         // Clear approvals from the previous owner.
2524         assembly {
2525             if approvedAddress {
2526                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2527                 sstore(approvedAddressSlot, 0)
2528             }
2529         }
2530 
2531         // Underflow of the sender's balance is impossible because we check for
2532         // ownership above and the recipient's balance can't realistically overflow.
2533         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2534         unchecked {
2535             // Updates:
2536             // - `balance -= 1`.
2537             // - `numberBurned += 1`.
2538             //
2539             // We can directly decrement the balance, and increment the number burned.
2540             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2541             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2542 
2543             // Updates:
2544             // - `address` to the last owner.
2545             // - `startTimestamp` to the timestamp of burning.
2546             // - `burned` to `true`.
2547             // - `nextInitialized` to `true`.
2548             _packedOwnerships[tokenId] = _packOwnershipData(
2549                 from,
2550                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2551             );
2552 
2553             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2554             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2555                 uint256 nextTokenId = tokenId + 1;
2556                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2557                 if (_packedOwnerships[nextTokenId] == 0) {
2558                     // If the next slot is within bounds.
2559                     if (nextTokenId != _currentIndex) {
2560                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2561                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2562                     }
2563                 }
2564             }
2565         }
2566 
2567         emit Transfer(from, address(0), tokenId);
2568         _afterTokenTransfers(from, address(0), tokenId, 1);
2569 
2570         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2571         unchecked {
2572             _burnCounter++;
2573         }
2574     }
2575 
2576     // =============================================================
2577     //                     EXTRA DATA OPERATIONS
2578     // =============================================================
2579 
2580     /**
2581      * @dev Directly sets the extra data for the ownership data `index`.
2582      */
2583     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2584         uint256 packed = _packedOwnerships[index];
2585         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2586         uint256 extraDataCasted;
2587         // Cast `extraData` with assembly to avoid redundant masking.
2588         assembly {
2589             extraDataCasted := extraData
2590         }
2591         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2592         _packedOwnerships[index] = packed;
2593     }
2594 
2595     /**
2596      * @dev Called during each token transfer to set the 24bit `extraData` field.
2597      * Intended to be overridden by the cosumer contract.
2598      *
2599      * `previousExtraData` - the value of `extraData` before transfer.
2600      *
2601      * Calling conditions:
2602      *
2603      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2604      * transferred to `to`.
2605      * - When `from` is zero, `tokenId` will be minted for `to`.
2606      * - When `to` is zero, `tokenId` will be burned by `from`.
2607      * - `from` and `to` are never both zero.
2608      */
2609     function _extraData(
2610         address from,
2611         address to,
2612         uint24 previousExtraData
2613     ) internal view virtual returns (uint24) {}
2614 
2615     /**
2616      * @dev Returns the next extra data for the packed ownership data.
2617      * The returned result is shifted into position.
2618      */
2619     function _nextExtraData(
2620         address from,
2621         address to,
2622         uint256 prevOwnershipPacked
2623     ) private view returns (uint256) {
2624         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2625         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2626     }
2627 
2628     // =============================================================
2629     //                       OTHER OPERATIONS
2630     // =============================================================
2631 
2632     /**
2633      * @dev Returns the message sender (defaults to `msg.sender`).
2634      *
2635      * If you are writing GSN compatible contracts, you need to override this function.
2636      */
2637     function _msgSenderERC721A() internal view virtual returns (address) {
2638         return msg.sender;
2639     }
2640 
2641     /**
2642      * @dev Converts a uint256 to its ASCII string decimal representation.
2643      */
2644     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2645         assembly {
2646             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2647             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2648             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2649             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2650             let m := add(mload(0x40), 0xa0)
2651             // Update the free memory pointer to allocate.
2652             mstore(0x40, m)
2653             // Assign the `str` to the end.
2654             str := sub(m, 0x20)
2655             // Zeroize the slot after the string.
2656             mstore(str, 0)
2657 
2658             // Cache the end of the memory to calculate the length later.
2659             let end := str
2660 
2661             // We write the string from rightmost digit to leftmost digit.
2662             // The following is essentially a do-while loop that also handles the zero case.
2663             // prettier-ignore
2664             for { let temp := value } 1 {} {
2665                 str := sub(str, 1)
2666                 // Write the character to the pointer.
2667                 // The ASCII index of the '0' character is 48.
2668                 mstore8(str, add(48, mod(temp, 10)))
2669                 // Keep dividing `temp` until zero.
2670                 temp := div(temp, 10)
2671                 // prettier-ignore
2672                 if iszero(temp) { break }
2673             }
2674 
2675             let length := sub(end, str)
2676             // Move the pointer 32 bytes leftwards to make room for the length.
2677             str := sub(str, 0x20)
2678             // Store the length.
2679             mstore(str, length)
2680         }
2681     }
2682 }
2683 
2684 // ERC721A Contracts v4.2.3
2685 // Creator: Chiru Labs
2686 
2687 
2688 
2689 pragma solidity ^0.8.9;
2690 
2691 contract GrumpusByRex is ERC721A, Ownable {
2692     using Strings for uint256;
2693 
2694     uint256 public maxSupply = 400;
2695     uint256 public mintPrice = 0.004 ether;
2696     uint256 public maxPerTx = 3;
2697     bool public paused = true;
2698     string public baseURI = "ipfs://QmVFdu4KqLwaz57RSYg8UGWegv4iHe8tQjP9HgEuZi6Lix/";
2699     mapping(address => uint256) public mintCount;
2700 
2701     constructor() ERC721A("400 Grumpus by Rex", "GRUMP") {}
2702 
2703     function mint(uint256 _quantity) external payable {
2704         require(!paused, "Mint paused");
2705         require((totalSupply() + _quantity) <= maxSupply, "Max supply reached");
2706         require(
2707             (mintCount[msg.sender] + _quantity) <= maxPerTx,
2708             "Max mint per wallet reached"
2709         );
2710         require(msg.value >= (mintPrice * _quantity), "Send the exact amount");
2711 
2712         mintCount[msg.sender] += _quantity;
2713         _safeMint(msg.sender, _quantity);
2714     }
2715 
2716     function teamMint(address receiver, uint256 mintAmount) external onlyOwner {
2717         _safeMint(receiver, mintAmount);
2718     }
2719 
2720     function tokenURI(uint256 tokenId)
2721         public
2722         view
2723         virtual
2724         override
2725         returns (string memory)
2726     {
2727         require(
2728             _exists(tokenId),
2729             "ERC721Metadata: URI query for nonexistent token"
2730         );
2731         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2732     }
2733 
2734     function _baseURI() internal view virtual override returns (string memory) {
2735         return baseURI;
2736     }
2737 
2738     function _startTokenId() internal view virtual override returns (uint256) {
2739         return 1;
2740     }
2741 
2742     function setBaseURI(string memory uri) public onlyOwner {
2743         baseURI = uri;
2744     }
2745 
2746     function setPrice(uint256 _newPrice) external onlyOwner {
2747         mintPrice = _newPrice;
2748     }
2749 
2750     function startSale() external onlyOwner {
2751         paused = !paused;
2752     }
2753 
2754     function withdraw() external onlyOwner {
2755         (bool success, ) = payable(msg.sender).call{
2756             value: address(this).balance
2757         }("");
2758         require(success, "Transfer failed.");
2759     }
2760 }