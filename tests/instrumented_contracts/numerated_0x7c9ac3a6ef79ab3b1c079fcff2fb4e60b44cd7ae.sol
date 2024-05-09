1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.19;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
33 
34 pragma solidity ^0.8.19;
35 
36 
37 /**
38  * @dev Implementation of the {IERC165} interface.
39  *
40  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
41  * for the additional interface id that will be supported. For example:
42  *
43  * ```solidity
44  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
46  * }
47  * ```
48  */
49 abstract contract ERC165 is IERC165 {
50     /**
51      * @dev See {IERC165-supportsInterface}.
52      */
53     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
54         return interfaceId == type(IERC165).interfaceId;
55     }
56 }
57 
58 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC2981.sol
59 
60 
61 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC2981.sol)
62 
63 pragma solidity ^0.8.19;
64 
65 
66 /**
67  * @dev Interface for the NFT Royalty Standard.
68  *
69  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
70  * support for royalty payments across all NFT marketplaces and ecosystem participants.
71  *
72  * _Available since v4.5._
73  */
74 interface IERC2981 is IERC165 {
75     /**
76      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
77      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
78      */
79     function royaltyInfo(
80         uint256 tokenId,
81         uint256 salePrice
82     ) external view returns (address receiver, uint256 royaltyAmount);
83 }
84 
85 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/common/ERC2981.sol
86 
87 
88 // OpenZeppelin Contracts (last updated v4.9.0) (token/common/ERC2981.sol)
89 
90 pragma solidity ^0.8.19;
91 
92 
93 
94 /**
95  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
96  *
97  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
98  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
99  *
100  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
101  * fee is specified in basis points by default.
102  *
103  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
104  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
105  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
106  *
107  * _Available since v4.5._
108  */
109 abstract contract ERC2981 is IERC2981, ERC165 {
110     struct RoyaltyInfo {
111         address receiver;
112         uint96 royaltyFraction;
113     }
114 
115     RoyaltyInfo private _defaultRoyaltyInfo;
116     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
117 
118     /**
119      * @dev The default royalty set is invalid (eg. (numerator / denominator) >= 1).
120      */
121     error ERC2981InvalidDefaultRoyalty(uint256 numerator, uint256 denominator);
122 
123     /**
124      * @dev The default royalty receiver is invalid.
125      */
126     error ERC2981InvalidDefaultRoyaltyReceiver(address receiver);
127 
128     /**
129      * @dev The royalty set for an specific `tokenId` is invalid (eg. (numerator / denominator) >= 1).
130      */
131     error ERC2981InvalidTokenRoyalty(uint256 tokenId, uint256 numerator, uint256 denominator);
132 
133     /**
134      * @dev The royalty receiver for `tokenId` is invalid.
135      */
136     error ERC2981InvalidTokenRoyaltyReceiver(uint256 tokenId, address receiver);
137 
138     /**
139      * @dev See {IERC165-supportsInterface}.
140      */
141     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
142         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
143     }
144 
145     /**
146      * @inheritdoc IERC2981
147      */
148     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual returns (address, uint256) {
149         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
150 
151         if (royalty.receiver == address(0)) {
152             royalty = _defaultRoyaltyInfo;
153         }
154 
155         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
156 
157         return (royalty.receiver, royaltyAmount);
158     }
159 
160     /**
161      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
162      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
163      * override.
164      */
165     function _feeDenominator() internal pure virtual returns (uint96) {
166         return 10000;
167     }
168 
169     /**
170      * @dev Sets the royalty information that all ids in this contract will default to.
171      *
172      * Requirements:
173      *
174      * - `receiver` cannot be the zero address.
175      * - `feeNumerator` cannot be greater than the fee denominator.
176      */
177     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
178         uint256 denominator = _feeDenominator();
179         if (feeNumerator > denominator) {
180             // Royalty fee will exceed the sale price
181             revert ERC2981InvalidDefaultRoyalty(feeNumerator, denominator);
182         }
183         if (receiver == address(0)) {
184             revert ERC2981InvalidDefaultRoyaltyReceiver(address(0));
185         }
186 
187         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
188     }
189 
190     /**
191      * @dev Removes default royalty information.
192      */
193     function _deleteDefaultRoyalty() internal virtual {
194         delete _defaultRoyaltyInfo;
195     }
196 
197     /**
198      * @dev Sets the royalty information for a specific token id, overriding the global default.
199      *
200      * Requirements:
201      *
202      * - `receiver` cannot be the zero address.
203      * - `feeNumerator` cannot be greater than the fee denominator.
204      */
205     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
206         uint256 denominator = _feeDenominator();
207         if (feeNumerator > denominator) {
208             // Royalty fee will exceed the sale price
209             revert ERC2981InvalidTokenRoyalty(tokenId, feeNumerator, denominator);
210         }
211         if (receiver == address(0)) {
212             revert ERC2981InvalidTokenRoyaltyReceiver(tokenId, address(0));
213         }
214 
215         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
216     }
217 
218     /**
219      * @dev Resets royalty information for the token id back to the global default.
220      */
221     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
222         delete _tokenRoyaltyInfo[tokenId];
223     }
224 }
225 
226 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SignedMath.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
230 
231 pragma solidity ^0.8.19;
232 
233 /**
234  * @dev Standard signed math utilities missing in the Solidity language.
235  */
236 library SignedMath {
237     /**
238      * @dev Returns the largest of two signed numbers.
239      */
240     function max(int256 a, int256 b) internal pure returns (int256) {
241         return a > b ? a : b;
242     }
243 
244     /**
245      * @dev Returns the smallest of two signed numbers.
246      */
247     function min(int256 a, int256 b) internal pure returns (int256) {
248         return a < b ? a : b;
249     }
250 
251     /**
252      * @dev Returns the average of two signed numbers without overflow.
253      * The result is rounded towards zero.
254      */
255     function average(int256 a, int256 b) internal pure returns (int256) {
256         // Formula from the book "Hacker's Delight"
257         int256 x = (a & b) + ((a ^ b) >> 1);
258         return x + (int256(uint256(x) >> 255) & (a ^ b));
259     }
260 
261     /**
262      * @dev Returns the absolute unsigned value of a signed value.
263      */
264     function abs(int256 n) internal pure returns (uint256) {
265         unchecked {
266             // must be unchecked in order to support `n = type(int256).min`
267             return uint256(n >= 0 ? n : -n);
268         }
269     }
270 }
271 
272 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
273 
274 
275 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
276 
277 pragma solidity ^0.8.19;
278 
279 /**
280  * @dev Standard math utilities missing in the Solidity language.
281  */
282 library Math {
283     /**
284      * @dev Muldiv operation overflow.
285      */
286     error MathOverflowedMulDiv();
287 
288     enum Rounding {
289         Down, // Toward negative infinity
290         Up, // Toward infinity
291         Zero // Toward zero
292     }
293 
294     /**
295      * @dev Returns the addition of two unsigned integers, with an overflow flag.
296      *
297      * _Available since v5.0._
298      */
299     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
300         unchecked {
301             uint256 c = a + b;
302             if (c < a) return (false, 0);
303             return (true, c);
304         }
305     }
306 
307     /**
308      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
309      *
310      * _Available since v5.0._
311      */
312     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
313         unchecked {
314             if (b > a) return (false, 0);
315             return (true, a - b);
316         }
317     }
318 
319     /**
320      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
321      *
322      * _Available since v5.0._
323      */
324     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
325         unchecked {
326             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
327             // benefit is lost if 'b' is also tested.
328             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
329             if (a == 0) return (true, 0);
330             uint256 c = a * b;
331             if (c / a != b) return (false, 0);
332             return (true, c);
333         }
334     }
335 
336     /**
337      * @dev Returns the division of two unsigned integers, with a division by zero flag.
338      *
339      * _Available since v5.0._
340      */
341     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
342         unchecked {
343             if (b == 0) return (false, 0);
344             return (true, a / b);
345         }
346     }
347 
348     /**
349      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
350      *
351      * _Available since v5.0._
352      */
353     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
354         unchecked {
355             if (b == 0) return (false, 0);
356             return (true, a % b);
357         }
358     }
359 
360     /**
361      * @dev Returns the largest of two numbers.
362      */
363     function max(uint256 a, uint256 b) internal pure returns (uint256) {
364         return a > b ? a : b;
365     }
366 
367     /**
368      * @dev Returns the smallest of two numbers.
369      */
370     function min(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a < b ? a : b;
372     }
373 
374     /**
375      * @dev Returns the average of two numbers. The result is rounded towards
376      * zero.
377      */
378     function average(uint256 a, uint256 b) internal pure returns (uint256) {
379         // (a + b) / 2 can overflow.
380         return (a & b) + (a ^ b) / 2;
381     }
382 
383     /**
384      * @dev Returns the ceiling of the division of two numbers.
385      *
386      * This differs from standard division with `/` in that it rounds up instead
387      * of rounding down.
388      */
389     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
390         // (a + b - 1) / b can overflow on addition, so we distribute.
391         return a == 0 ? 0 : (a - 1) / b + 1;
392     }
393 
394     /**
395      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
396      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
397      * with further edits by Uniswap Labs also under MIT license.
398      */
399     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
400         unchecked {
401             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
402             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
403             // variables such that product = prod1 * 2^256 + prod0.
404             uint256 prod0; // Least significant 256 bits of the product
405             uint256 prod1; // Most significant 256 bits of the product
406             assembly {
407                 let mm := mulmod(x, y, not(0))
408                 prod0 := mul(x, y)
409                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
410             }
411 
412             // Handle non-overflow cases, 256 by 256 division.
413             if (prod1 == 0) {
414                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
415                 // The surrounding unchecked block does not change this fact.
416                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
417                 return prod0 / denominator;
418             }
419 
420             // Make sure the result is less than 2^256. Also prevents denominator == 0.
421             if (denominator <= prod1) {
422                 revert MathOverflowedMulDiv();
423             }
424 
425             ///////////////////////////////////////////////
426             // 512 by 256 division.
427             ///////////////////////////////////////////////
428 
429             // Make division exact by subtracting the remainder from [prod1 prod0].
430             uint256 remainder;
431             assembly {
432                 // Compute remainder using mulmod.
433                 remainder := mulmod(x, y, denominator)
434 
435                 // Subtract 256 bit number from 512 bit number.
436                 prod1 := sub(prod1, gt(remainder, prod0))
437                 prod0 := sub(prod0, remainder)
438             }
439 
440             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
441             // See https://cs.stackexchange.com/q/138556/92363.
442 
443             // Does not overflow because the denominator cannot be zero at this stage in the function.
444             uint256 twos = denominator & (~denominator + 1);
445             assembly {
446                 // Divide denominator by twos.
447                 denominator := div(denominator, twos)
448 
449                 // Divide [prod1 prod0] by twos.
450                 prod0 := div(prod0, twos)
451 
452                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
453                 twos := add(div(sub(0, twos), twos), 1)
454             }
455 
456             // Shift in bits from prod1 into prod0.
457             prod0 |= prod1 * twos;
458 
459             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
460             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
461             // four bits. That is, denominator * inv = 1 mod 2^4.
462             uint256 inverse = (3 * denominator) ^ 2;
463 
464             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
465             // in modular arithmetic, doubling the correct bits in each step.
466             inverse *= 2 - denominator * inverse; // inverse mod 2^8
467             inverse *= 2 - denominator * inverse; // inverse mod 2^16
468             inverse *= 2 - denominator * inverse; // inverse mod 2^32
469             inverse *= 2 - denominator * inverse; // inverse mod 2^64
470             inverse *= 2 - denominator * inverse; // inverse mod 2^128
471             inverse *= 2 - denominator * inverse; // inverse mod 2^256
472 
473             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
474             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
475             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
476             // is no longer required.
477             result = prod0 * inverse;
478             return result;
479         }
480     }
481 
482     /**
483      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
484      */
485     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
486         uint256 result = mulDiv(x, y, denominator);
487         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
488             result += 1;
489         }
490         return result;
491     }
492 
493     /**
494      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
495      *
496      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
497      */
498     function sqrt(uint256 a) internal pure returns (uint256) {
499         if (a == 0) {
500             return 0;
501         }
502 
503         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
504         //
505         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
506         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
507         //
508         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
509         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
510         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
511         //
512         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
513         uint256 result = 1 << (log2(a) >> 1);
514 
515         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
516         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
517         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
518         // into the expected uint128 result.
519         unchecked {
520             result = (result + a / result) >> 1;
521             result = (result + a / result) >> 1;
522             result = (result + a / result) >> 1;
523             result = (result + a / result) >> 1;
524             result = (result + a / result) >> 1;
525             result = (result + a / result) >> 1;
526             result = (result + a / result) >> 1;
527             return min(result, a / result);
528         }
529     }
530 
531     /**
532      * @notice Calculates sqrt(a), following the selected rounding direction.
533      */
534     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
535         unchecked {
536             uint256 result = sqrt(a);
537             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
538         }
539     }
540 
541     /**
542      * @dev Return the log in base 2, rounded down, of a positive value.
543      * Returns 0 if given 0.
544      */
545     function log2(uint256 value) internal pure returns (uint256) {
546         uint256 result = 0;
547         unchecked {
548             if (value >> 128 > 0) {
549                 value >>= 128;
550                 result += 128;
551             }
552             if (value >> 64 > 0) {
553                 value >>= 64;
554                 result += 64;
555             }
556             if (value >> 32 > 0) {
557                 value >>= 32;
558                 result += 32;
559             }
560             if (value >> 16 > 0) {
561                 value >>= 16;
562                 result += 16;
563             }
564             if (value >> 8 > 0) {
565                 value >>= 8;
566                 result += 8;
567             }
568             if (value >> 4 > 0) {
569                 value >>= 4;
570                 result += 4;
571             }
572             if (value >> 2 > 0) {
573                 value >>= 2;
574                 result += 2;
575             }
576             if (value >> 1 > 0) {
577                 result += 1;
578             }
579         }
580         return result;
581     }
582 
583     /**
584      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
585      * Returns 0 if given 0.
586      */
587     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
588         unchecked {
589             uint256 result = log2(value);
590             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
591         }
592     }
593 
594     /**
595      * @dev Return the log in base 10, rounded down, of a positive value.
596      * Returns 0 if given 0.
597      */
598     function log10(uint256 value) internal pure returns (uint256) {
599         uint256 result = 0;
600         unchecked {
601             if (value >= 10 ** 64) {
602                 value /= 10 ** 64;
603                 result += 64;
604             }
605             if (value >= 10 ** 32) {
606                 value /= 10 ** 32;
607                 result += 32;
608             }
609             if (value >= 10 ** 16) {
610                 value /= 10 ** 16;
611                 result += 16;
612             }
613             if (value >= 10 ** 8) {
614                 value /= 10 ** 8;
615                 result += 8;
616             }
617             if (value >= 10 ** 4) {
618                 value /= 10 ** 4;
619                 result += 4;
620             }
621             if (value >= 10 ** 2) {
622                 value /= 10 ** 2;
623                 result += 2;
624             }
625             if (value >= 10 ** 1) {
626                 result += 1;
627             }
628         }
629         return result;
630     }
631 
632     /**
633      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
634      * Returns 0 if given 0.
635      */
636     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
637         unchecked {
638             uint256 result = log10(value);
639             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
640         }
641     }
642 
643     /**
644      * @dev Return the log in base 256, rounded down, of a positive value.
645      * Returns 0 if given 0.
646      *
647      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
648      */
649     function log256(uint256 value) internal pure returns (uint256) {
650         uint256 result = 0;
651         unchecked {
652             if (value >> 128 > 0) {
653                 value >>= 128;
654                 result += 16;
655             }
656             if (value >> 64 > 0) {
657                 value >>= 64;
658                 result += 8;
659             }
660             if (value >> 32 > 0) {
661                 value >>= 32;
662                 result += 4;
663             }
664             if (value >> 16 > 0) {
665                 value >>= 16;
666                 result += 2;
667             }
668             if (value >> 8 > 0) {
669                 result += 1;
670             }
671         }
672         return result;
673     }
674 
675     /**
676      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
677      * Returns 0 if given 0.
678      */
679     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
680         unchecked {
681             uint256 result = log256(value);
682             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
683         }
684     }
685 }
686 
687 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
688 
689 
690 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
691 
692 pragma solidity ^0.8.19;
693 
694 
695 
696 /**
697  * @dev String operations.
698  */
699 library Strings {
700     bytes16 private constant _SYMBOLS = "0123456789abcdef";
701     uint8 private constant _ADDRESS_LENGTH = 20;
702 
703     /**
704      * @dev The `value` string doesn't fit in the specified `length`.
705      */
706     error StringsInsufficientHexLength(uint256 value, uint256 length);
707 
708     /**
709      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
710      */
711     function toString(uint256 value) internal pure returns (string memory) {
712         unchecked {
713             uint256 length = Math.log10(value) + 1;
714             string memory buffer = new string(length);
715             uint256 ptr;
716             /// @solidity memory-safe-assembly
717             assembly {
718                 ptr := add(buffer, add(32, length))
719             }
720             while (true) {
721                 ptr--;
722                 /// @solidity memory-safe-assembly
723                 assembly {
724                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
725                 }
726                 value /= 10;
727                 if (value == 0) break;
728             }
729             return buffer;
730         }
731     }
732 
733     /**
734      * @dev Converts a `int256` to its ASCII `string` decimal representation.
735      */
736     function toString(int256 value) internal pure returns (string memory) {
737         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
738     }
739 
740     /**
741      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
742      */
743     function toHexString(uint256 value) internal pure returns (string memory) {
744         unchecked {
745             return toHexString(value, Math.log256(value) + 1);
746         }
747     }
748 
749     /**
750      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
751      */
752     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
753         uint256 localValue = value;
754         bytes memory buffer = new bytes(2 * length + 2);
755         buffer[0] = "0";
756         buffer[1] = "x";
757         for (uint256 i = 2 * length + 1; i > 1; --i) {
758             buffer[i] = _SYMBOLS[localValue & 0xf];
759             localValue >>= 4;
760         }
761         if (localValue != 0) {
762             revert StringsInsufficientHexLength(value, length);
763         }
764         return string(buffer);
765     }
766 
767     /**
768      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
769      */
770     function toHexString(address addr) internal pure returns (string memory) {
771         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
772     }
773 
774     /**
775      * @dev Returns true if the two strings are equal.
776      */
777     function equal(string memory a, string memory b) internal pure returns (bool) {
778         return bytes(a).length == bytes(b).length && keccak256(bytes(a)) == keccak256(bytes(b));
779     }
780 }
781 
782 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
783 
784 
785 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
786 
787 pragma solidity ^0.8.19;
788 
789 /**
790  * @dev Provides information about the current execution context, including the
791  * sender of the transaction and its data. While these are generally available
792  * via msg.sender and msg.data, they should not be accessed in such a direct
793  * manner, since when dealing with meta-transactions the account sending and
794  * paying for execution may not be the actual sender (as far as an application
795  * is concerned).
796  *
797  * This contract is only required for intermediate, library-like contracts.
798  */
799 abstract contract Context {
800     function _msgSender() internal view virtual returns (address) {
801         return msg.sender;
802     }
803 
804     function _msgData() internal view virtual returns (bytes calldata) {
805         return msg.data;
806     }
807 }
808 
809 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
810 
811 
812 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
813 
814 pragma solidity ^0.8.19;
815 
816 
817 /**
818  * @dev Contract module which provides a basic access control mechanism, where
819  * there is an account (an owner) that can be granted exclusive access to
820  * specific functions.
821  *
822  * By default, the owner account will be the one that deploys the contract. This
823  * can later be changed with {transferOwnership}.
824  *
825  * This module is used through inheritance. It will make available the modifier
826  * `onlyOwner`, which can be applied to your functions to restrict their use to
827  * the owner.
828  */
829 abstract contract Ownable is Context {
830     address private _owner;
831 
832     /**
833      * @dev The caller account is not authorized to perform an operation.
834      */
835     error OwnableUnauthorizedAccount(address account);
836 
837     /**
838      * @dev The owner is not a valid owner account. (eg. `address(0)`)
839      */
840     error OwnableInvalidOwner(address owner);
841 
842     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
843 
844     /**
845      * @dev Initializes the contract setting the deployer as the initial owner.
846      */
847     constructor(address initialOwner) {
848         _transferOwnership(initialOwner);
849     }
850 
851     /**
852      * @dev Throws if called by any account other than the owner.
853      */
854     modifier onlyOwner() {
855         _checkOwner();
856         _;
857     }
858 
859     /**
860      * @dev Returns the address of the current owner.
861      */
862     function owner() public view virtual returns (address) {
863         return _owner;
864     }
865 
866     /**
867      * @dev Throws if the sender is not the owner.
868      */
869     function _checkOwner() internal view virtual {
870         if (owner() != _msgSender()) {
871             revert OwnableUnauthorizedAccount(_msgSender());
872         }
873     }
874 
875     /**
876      * @dev Leaves the contract without owner. It will not be possible to call
877      * `onlyOwner` functions. Can only be called by the current owner.
878      *
879      * NOTE: Renouncing ownership will leave the contract without an owner,
880      * thereby disabling any functionality that is only available to the owner.
881      */
882     function renounceOwnership() public virtual onlyOwner {
883         _transferOwnership(address(0));
884     }
885 
886     /**
887      * @dev Transfers ownership of the contract to a new account (`newOwner`).
888      * Can only be called by the current owner.
889      */
890     function transferOwnership(address newOwner) public virtual onlyOwner {
891         if (newOwner == address(0)) {
892             revert OwnableInvalidOwner(address(0));
893         }
894         _transferOwnership(newOwner);
895     }
896 
897     /**
898      * @dev Transfers ownership of the contract to a new account (`newOwner`).
899      * Internal function without access restriction.
900      */
901     function _transferOwnership(address newOwner) internal virtual {
902         address oldOwner = _owner;
903         _owner = newOwner;
904         emit OwnershipTransferred(oldOwner, newOwner);
905     }
906 }
907 
908 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
909 
910 
911 // ERC721A Contracts v4.2.3
912 // Creator: Chiru Labs
913 
914 pragma solidity ^0.8.4;
915 
916 /**
917  * @dev Interface of ERC721A.
918  */
919 interface IERC721A {
920     /**
921      * The caller must own the token or be an approved operator.
922      */
923     error ApprovalCallerNotOwnerNorApproved();
924 
925     /**
926      * The token does not exist.
927      */
928     error ApprovalQueryForNonexistentToken();
929 
930     /**
931      * Cannot query the balance for the zero address.
932      */
933     error BalanceQueryForZeroAddress();
934 
935     /**
936      * Cannot mint to the zero address.
937      */
938     error MintToZeroAddress();
939 
940     /**
941      * The quantity of tokens minted must be more than zero.
942      */
943     error MintZeroQuantity();
944 
945     /**
946      * The token does not exist.
947      */
948     error OwnerQueryForNonexistentToken();
949 
950     /**
951      * The caller must own the token or be an approved operator.
952      */
953     error TransferCallerNotOwnerNorApproved();
954 
955     /**
956      * The token must be owned by `from`.
957      */
958     error TransferFromIncorrectOwner();
959 
960     /**
961      * Cannot safely transfer to a contract that does not implement the
962      * ERC721Receiver interface.
963      */
964     error TransferToNonERC721ReceiverImplementer();
965 
966     /**
967      * Cannot transfer to the zero address.
968      */
969     error TransferToZeroAddress();
970 
971     /**
972      * The token does not exist.
973      */
974     error URIQueryForNonexistentToken();
975 
976     /**
977      * The `quantity` minted with ERC2309 exceeds the safety limit.
978      */
979     error MintERC2309QuantityExceedsLimit();
980 
981     /**
982      * The `extraData` cannot be set on an unintialized ownership slot.
983      */
984     error OwnershipNotInitializedForExtraData();
985 
986     // =============================================================
987     //                            STRUCTS
988     // =============================================================
989 
990     struct TokenOwnership {
991         // The address of the owner.
992         address addr;
993         // Stores the start time of ownership with minimal overhead for tokenomics.
994         uint64 startTimestamp;
995         // Whether the token has been burned.
996         bool burned;
997         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
998         uint24 extraData;
999     }
1000 
1001     // =============================================================
1002     //                         TOKEN COUNTERS
1003     // =============================================================
1004 
1005     /**
1006      * @dev Returns the total number of tokens in existence.
1007      * Burned tokens will reduce the count.
1008      * To get the total number of tokens minted, please see {_totalMinted}.
1009      */
1010     function totalSupply() external view returns (uint256);
1011 
1012     // =============================================================
1013     //                            IERC165
1014     // =============================================================
1015 
1016     /**
1017      * @dev Returns true if this contract implements the interface defined by
1018      * `interfaceId`. See the corresponding
1019      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1020      * to learn more about how these ids are created.
1021      *
1022      * This function call must use less than 30000 gas.
1023      */
1024     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1025 
1026     // =============================================================
1027     //                            IERC721
1028     // =============================================================
1029 
1030     /**
1031      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1032      */
1033     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1034 
1035     /**
1036      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1037      */
1038     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1039 
1040     /**
1041      * @dev Emitted when `owner` enables or disables
1042      * (`approved`) `operator` to manage all of its assets.
1043      */
1044     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1045 
1046     /**
1047      * @dev Returns the number of tokens in `owner`'s account.
1048      */
1049     function balanceOf(address owner) external view returns (uint256 balance);
1050 
1051     /**
1052      * @dev Returns the owner of the `tokenId` token.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      */
1058     function ownerOf(uint256 tokenId) external view returns (address owner);
1059 
1060     /**
1061      * @dev Safely transfers `tokenId` token from `from` to `to`,
1062      * checking first that contract recipients are aware of the ERC721 protocol
1063      * to prevent tokens from being forever locked.
1064      *
1065      * Requirements:
1066      *
1067      * - `from` cannot be the zero address.
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must exist and be owned by `from`.
1070      * - If the caller is not `from`, it must be have been allowed to move
1071      * this token by either {approve} or {setApprovalForAll}.
1072      * - If `to` refers to a smart contract, it must implement
1073      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId,
1081         bytes calldata data
1082     ) external payable;
1083 
1084     /**
1085      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1086      */
1087     function safeTransferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) external payable;
1092 
1093     /**
1094      * @dev Transfers `tokenId` from `from` to `to`.
1095      *
1096      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1097      * whenever possible.
1098      *
1099      * Requirements:
1100      *
1101      * - `from` cannot be the zero address.
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      * - If the caller is not `from`, it must be approved to move this token
1105      * by either {approve} or {setApprovalForAll}.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function transferFrom(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) external payable;
1114 
1115     /**
1116      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1117      * The approval is cleared when the token is transferred.
1118      *
1119      * Only a single account can be approved at a time, so approving the
1120      * zero address clears previous approvals.
1121      *
1122      * Requirements:
1123      *
1124      * - The caller must own the token or be an approved operator.
1125      * - `tokenId` must exist.
1126      *
1127      * Emits an {Approval} event.
1128      */
1129     function approve(address to, uint256 tokenId) external payable;
1130 
1131     /**
1132      * @dev Approve or remove `operator` as an operator for the caller.
1133      * Operators can call {transferFrom} or {safeTransferFrom}
1134      * for any token owned by the caller.
1135      *
1136      * Requirements:
1137      *
1138      * - The `operator` cannot be the caller.
1139      *
1140      * Emits an {ApprovalForAll} event.
1141      */
1142     function setApprovalForAll(address operator, bool _approved) external;
1143 
1144     /**
1145      * @dev Returns the account approved for `tokenId` token.
1146      *
1147      * Requirements:
1148      *
1149      * - `tokenId` must exist.
1150      */
1151     function getApproved(uint256 tokenId) external view returns (address operator);
1152 
1153     /**
1154      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1155      *
1156      * See {setApprovalForAll}.
1157      */
1158     function isApprovedForAll(address owner, address operator) external view returns (bool);
1159 
1160     // =============================================================
1161     //                        IERC721Metadata
1162     // =============================================================
1163 
1164     /**
1165      * @dev Returns the token collection name.
1166      */
1167     function name() external view returns (string memory);
1168 
1169     /**
1170      * @dev Returns the token collection symbol.
1171      */
1172     function symbol() external view returns (string memory);
1173 
1174     /**
1175      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1176      */
1177     function tokenURI(uint256 tokenId) external view returns (string memory);
1178 
1179     // =============================================================
1180     //                           IERC2309
1181     // =============================================================
1182 
1183     /**
1184      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1185      * (inclusive) is transferred from `from` to `to`, as defined in the
1186      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1187      *
1188      * See {_mintERC2309} for more details.
1189      */
1190     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1191 }
1192 
1193 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
1194 
1195 
1196 // ERC721A Contracts v4.2.3
1197 // Creator: Chiru Labs
1198 
1199 pragma solidity ^0.8.4;
1200 
1201 
1202 /**
1203  * @dev Interface of ERC721 token receiver.
1204  */
1205 interface ERC721A__IERC721Receiver {
1206     function onERC721Received(
1207         address operator,
1208         address from,
1209         uint256 tokenId,
1210         bytes calldata data
1211     ) external returns (bytes4);
1212 }
1213 
1214 /**
1215  * @title ERC721A
1216  *
1217  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1218  * Non-Fungible Token Standard, including the Metadata extension.
1219  * Optimized for lower gas during batch mints.
1220  *
1221  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1222  * starting from `_startTokenId()`.
1223  *
1224  * Assumptions:
1225  *
1226  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1227  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1228  */
1229 contract ERC721A is IERC721A {
1230     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1231     struct TokenApprovalRef {
1232         address value;
1233     }
1234 
1235     // =============================================================
1236     //                           CONSTANTS
1237     // =============================================================
1238 
1239     // Mask of an entry in packed address data.
1240     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1241 
1242     // The bit position of `numberMinted` in packed address data.
1243     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1244 
1245     // The bit position of `numberBurned` in packed address data.
1246     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1247 
1248     // The bit position of `aux` in packed address data.
1249     uint256 private constant _BITPOS_AUX = 192;
1250 
1251     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1252     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1253 
1254     // The bit position of `startTimestamp` in packed ownership.
1255     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1256 
1257     // The bit mask of the `burned` bit in packed ownership.
1258     uint256 private constant _BITMASK_BURNED = 1 << 224;
1259 
1260     // The bit position of the `nextInitialized` bit in packed ownership.
1261     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1262 
1263     // The bit mask of the `nextInitialized` bit in packed ownership.
1264     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1265 
1266     // The bit position of `extraData` in packed ownership.
1267     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1268 
1269     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1270     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1271 
1272     // The mask of the lower 160 bits for addresses.
1273     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1274 
1275     // The maximum `quantity` that can be minted with {_mintERC2309}.
1276     // This limit is to prevent overflows on the address data entries.
1277     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1278     // is required to cause an overflow, which is unrealistic.
1279     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1280 
1281     // The `Transfer` event signature is given by:
1282     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1283     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1284         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1285 
1286     // =============================================================
1287     //                            STORAGE
1288     // =============================================================
1289 
1290     // The next token ID to be minted.
1291     uint256 private _currentIndex;
1292 
1293     // The number of tokens burned.
1294     uint256 private _burnCounter;
1295 
1296     // Token name
1297     string private _name;
1298 
1299     // Token symbol
1300     string private _symbol;
1301 
1302     // Mapping from token ID to ownership details
1303     // An empty struct value does not necessarily mean the token is unowned.
1304     // See {_packedOwnershipOf} implementation for details.
1305     //
1306     // Bits Layout:
1307     // - [0..159]   `addr`
1308     // - [160..223] `startTimestamp`
1309     // - [224]      `burned`
1310     // - [225]      `nextInitialized`
1311     // - [232..255] `extraData`
1312     mapping(uint256 => uint256) private _packedOwnerships;
1313 
1314     // Mapping owner address to address data.
1315     //
1316     // Bits Layout:
1317     // - [0..63]    `balance`
1318     // - [64..127]  `numberMinted`
1319     // - [128..191] `numberBurned`
1320     // - [192..255] `aux`
1321     mapping(address => uint256) private _packedAddressData;
1322 
1323     // Mapping from token ID to approved address.
1324     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1325 
1326     // Mapping from owner to operator approvals
1327     mapping(address => mapping(address => bool)) private _operatorApprovals;
1328 
1329     // =============================================================
1330     //                          CONSTRUCTOR
1331     // =============================================================
1332 
1333     constructor(string memory name_, string memory symbol_) {
1334         _name = name_;
1335         _symbol = symbol_;
1336         _currentIndex = _startTokenId();
1337     }
1338 
1339     // =============================================================
1340     //                   TOKEN COUNTING OPERATIONS
1341     // =============================================================
1342 
1343     /**
1344      * @dev Returns the starting token ID.
1345      * To change the starting token ID, please override this function.
1346      */
1347     function _startTokenId() internal view virtual returns (uint256) {
1348         return 0;
1349     }
1350 
1351     /**
1352      * @dev Returns the next token ID to be minted.
1353      */
1354     function _nextTokenId() internal view virtual returns (uint256) {
1355         return _currentIndex;
1356     }
1357 
1358     /**
1359      * @dev Returns the total number of tokens in existence.
1360      * Burned tokens will reduce the count.
1361      * To get the total number of tokens minted, please see {_totalMinted}.
1362      */
1363     function totalSupply() public view virtual override returns (uint256) {
1364         // Counter underflow is impossible as _burnCounter cannot be incremented
1365         // more than `_currentIndex - _startTokenId()` times.
1366         unchecked {
1367             return _currentIndex - _burnCounter - _startTokenId();
1368         }
1369     }
1370 
1371     /**
1372      * @dev Returns the total amount of tokens minted in the contract.
1373      */
1374     function _totalMinted() internal view virtual returns (uint256) {
1375         // Counter underflow is impossible as `_currentIndex` does not decrement,
1376         // and it is initialized to `_startTokenId()`.
1377         unchecked {
1378             return _currentIndex - _startTokenId();
1379         }
1380     }
1381 
1382     /**
1383      * @dev Returns the total number of tokens burned.
1384      */
1385     function _totalBurned() internal view virtual returns (uint256) {
1386         return _burnCounter;
1387     }
1388 
1389     // =============================================================
1390     //                    ADDRESS DATA OPERATIONS
1391     // =============================================================
1392 
1393     /**
1394      * @dev Returns the number of tokens in `owner`'s account.
1395      */
1396     function balanceOf(address owner) public view virtual override returns (uint256) {
1397         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
1398         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1399     }
1400 
1401     /**
1402      * Returns the number of tokens minted by `owner`.
1403      */
1404     function _numberMinted(address owner) internal view returns (uint256) {
1405         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1406     }
1407 
1408     /**
1409      * Returns the number of tokens burned by or on behalf of `owner`.
1410      */
1411     function _numberBurned(address owner) internal view returns (uint256) {
1412         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1413     }
1414 
1415     /**
1416      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1417      */
1418     function _getAux(address owner) internal view returns (uint64) {
1419         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1420     }
1421 
1422     /**
1423      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1424      * If there are multiple variables, please pack them into a uint64.
1425      */
1426     function _setAux(address owner, uint64 aux) internal virtual {
1427         uint256 packed = _packedAddressData[owner];
1428         uint256 auxCasted;
1429         // Cast `aux` with assembly to avoid redundant masking.
1430         assembly {
1431             auxCasted := aux
1432         }
1433         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1434         _packedAddressData[owner] = packed;
1435     }
1436 
1437     // =============================================================
1438     //                            IERC165
1439     // =============================================================
1440 
1441     /**
1442      * @dev Returns true if this contract implements the interface defined by
1443      * `interfaceId`. See the corresponding
1444      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1445      * to learn more about how these ids are created.
1446      *
1447      * This function call must use less than 30000 gas.
1448      */
1449     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1450         // The interface IDs are constants representing the first 4 bytes
1451         // of the XOR of all function selectors in the interface.
1452         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1453         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1454         return
1455             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1456             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1457             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1458     }
1459 
1460     // =============================================================
1461     //                        IERC721Metadata
1462     // =============================================================
1463 
1464     /**
1465      * @dev Returns the token collection name.
1466      */
1467     function name() public view virtual override returns (string memory) {
1468         return _name;
1469     }
1470 
1471     /**
1472      * @dev Returns the token collection symbol.
1473      */
1474     function symbol() public view virtual override returns (string memory) {
1475         return _symbol;
1476     }
1477 
1478     /**
1479      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1480      */
1481     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1482         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
1483 
1484         string memory baseURI = _baseURI();
1485         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1486     }
1487 
1488     /**
1489      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1490      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1491      * by default, it can be overridden in child contracts.
1492      */
1493     function _baseURI() internal view virtual returns (string memory) {
1494         return '';
1495     }
1496 
1497     // =============================================================
1498     //                     OWNERSHIPS OPERATIONS
1499     // =============================================================
1500 
1501     /**
1502      * @dev Returns the owner of the `tokenId` token.
1503      *
1504      * Requirements:
1505      *
1506      * - `tokenId` must exist.
1507      */
1508     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1509         return address(uint160(_packedOwnershipOf(tokenId)));
1510     }
1511 
1512     /**
1513      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1514      * It gradually moves to O(1) as tokens get transferred around over time.
1515      */
1516     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1517         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1518     }
1519 
1520     /**
1521      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1522      */
1523     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1524         return _unpackedOwnership(_packedOwnerships[index]);
1525     }
1526 
1527     /**
1528      * @dev Returns whether the ownership slot at `index` is initialized.
1529      * An uninitialized slot does not necessarily mean that the slot has no owner.
1530      */
1531     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
1532         return _packedOwnerships[index] != 0;
1533     }
1534 
1535     /**
1536      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1537      */
1538     function _initializeOwnershipAt(uint256 index) internal virtual {
1539         if (_packedOwnerships[index] == 0) {
1540             _packedOwnerships[index] = _packedOwnershipOf(index);
1541         }
1542     }
1543 
1544     /**
1545      * Returns the packed ownership data of `tokenId`.
1546      */
1547     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1548         if (_startTokenId() <= tokenId) {
1549             packed = _packedOwnerships[tokenId];
1550             // If the data at the starting slot does not exist, start the scan.
1551             if (packed == 0) {
1552                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
1553                 // Invariant:
1554                 // There will always be an initialized ownership slot
1555                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1556                 // before an unintialized ownership slot
1557                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1558                 // Hence, `tokenId` will not underflow.
1559                 //
1560                 // We can directly compare the packed value.
1561                 // If the address is zero, packed will be zero.
1562                 for (;;) {
1563                     unchecked {
1564                         packed = _packedOwnerships[--tokenId];
1565                     }
1566                     if (packed == 0) continue;
1567                     if (packed & _BITMASK_BURNED == 0) return packed;
1568                     // Otherwise, the token is burned, and we must revert.
1569                     // This handles the case of batch burned tokens, where only the burned bit
1570                     // of the starting slot is set, and remaining slots are left uninitialized.
1571                     _revert(OwnerQueryForNonexistentToken.selector);
1572                 }
1573             }
1574             // Otherwise, the data exists and we can skip the scan.
1575             // This is possible because we have already achieved the target condition.
1576             // This saves 2143 gas on transfers of initialized tokens.
1577             // If the token is not burned, return `packed`. Otherwise, revert.
1578             if (packed & _BITMASK_BURNED == 0) return packed;
1579         }
1580         _revert(OwnerQueryForNonexistentToken.selector);
1581     }
1582 
1583     /**
1584      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1585      */
1586     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1587         ownership.addr = address(uint160(packed));
1588         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1589         ownership.burned = packed & _BITMASK_BURNED != 0;
1590         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1591     }
1592 
1593     /**
1594      * @dev Packs ownership data into a single uint256.
1595      */
1596     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1597         assembly {
1598             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1599             owner := and(owner, _BITMASK_ADDRESS)
1600             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1601             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1602         }
1603     }
1604 
1605     /**
1606      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1607      */
1608     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1609         // For branchless setting of the `nextInitialized` flag.
1610         assembly {
1611             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1612             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1613         }
1614     }
1615 
1616     // =============================================================
1617     //                      APPROVAL OPERATIONS
1618     // =============================================================
1619 
1620     /**
1621      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1622      *
1623      * Requirements:
1624      *
1625      * - The caller must own the token or be an approved operator.
1626      */
1627     function approve(address to, uint256 tokenId) public payable virtual override {
1628         _approve(to, tokenId, true);
1629     }
1630 
1631     /**
1632      * @dev Returns the account approved for `tokenId` token.
1633      *
1634      * Requirements:
1635      *
1636      * - `tokenId` must exist.
1637      */
1638     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1639         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
1640 
1641         return _tokenApprovals[tokenId].value;
1642     }
1643 
1644     /**
1645      * @dev Approve or remove `operator` as an operator for the caller.
1646      * Operators can call {transferFrom} or {safeTransferFrom}
1647      * for any token owned by the caller.
1648      *
1649      * Requirements:
1650      *
1651      * - The `operator` cannot be the caller.
1652      *
1653      * Emits an {ApprovalForAll} event.
1654      */
1655     function setApprovalForAll(address operator, bool approved) public virtual override {
1656         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1657         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1658     }
1659 
1660     /**
1661      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1662      *
1663      * See {setApprovalForAll}.
1664      */
1665     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1666         return _operatorApprovals[owner][operator];
1667     }
1668 
1669     /**
1670      * @dev Returns whether `tokenId` exists.
1671      *
1672      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1673      *
1674      * Tokens start existing when they are minted. See {_mint}.
1675      */
1676     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
1677         if (_startTokenId() <= tokenId) {
1678             if (tokenId < _currentIndex) {
1679                 uint256 packed;
1680                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
1681                 result = packed & _BITMASK_BURNED == 0;
1682             }
1683         }
1684     }
1685 
1686     /**
1687      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1688      */
1689     function _isSenderApprovedOrOwner(
1690         address approvedAddress,
1691         address owner,
1692         address msgSender
1693     ) private pure returns (bool result) {
1694         assembly {
1695             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1696             owner := and(owner, _BITMASK_ADDRESS)
1697             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1698             msgSender := and(msgSender, _BITMASK_ADDRESS)
1699             // `msgSender == owner || msgSender == approvedAddress`.
1700             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1701         }
1702     }
1703 
1704     /**
1705      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1706      */
1707     function _getApprovedSlotAndAddress(uint256 tokenId)
1708         private
1709         view
1710         returns (uint256 approvedAddressSlot, address approvedAddress)
1711     {
1712         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1713         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1714         assembly {
1715             approvedAddressSlot := tokenApproval.slot
1716             approvedAddress := sload(approvedAddressSlot)
1717         }
1718     }
1719 
1720     // =============================================================
1721     //                      TRANSFER OPERATIONS
1722     // =============================================================
1723 
1724     /**
1725      * @dev Transfers `tokenId` from `from` to `to`.
1726      *
1727      * Requirements:
1728      *
1729      * - `from` cannot be the zero address.
1730      * - `to` cannot be the zero address.
1731      * - `tokenId` token must be owned by `from`.
1732      * - If the caller is not `from`, it must be approved to move this token
1733      * by either {approve} or {setApprovalForAll}.
1734      *
1735      * Emits a {Transfer} event.
1736      */
1737     function transferFrom(
1738         address from,
1739         address to,
1740         uint256 tokenId
1741     ) public payable virtual override {
1742         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1743 
1744         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1745         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
1746 
1747         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
1748 
1749         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1750 
1751         // The nested ifs save around 20+ gas over a compound boolean condition.
1752         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1753             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1754 
1755         _beforeTokenTransfers(from, to, tokenId, 1);
1756 
1757         // Clear approvals from the previous owner.
1758         assembly {
1759             if approvedAddress {
1760                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1761                 sstore(approvedAddressSlot, 0)
1762             }
1763         }
1764 
1765         // Underflow of the sender's balance is impossible because we check for
1766         // ownership above and the recipient's balance can't realistically overflow.
1767         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1768         unchecked {
1769             // We can directly increment and decrement the balances.
1770             --_packedAddressData[from]; // Updates: `balance -= 1`.
1771             ++_packedAddressData[to]; // Updates: `balance += 1`.
1772 
1773             // Updates:
1774             // - `address` to the next owner.
1775             // - `startTimestamp` to the timestamp of transfering.
1776             // - `burned` to `false`.
1777             // - `nextInitialized` to `true`.
1778             _packedOwnerships[tokenId] = _packOwnershipData(
1779                 to,
1780                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1781             );
1782 
1783             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1784             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1785                 uint256 nextTokenId = tokenId + 1;
1786                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1787                 if (_packedOwnerships[nextTokenId] == 0) {
1788                     // If the next slot is within bounds.
1789                     if (nextTokenId != _currentIndex) {
1790                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1791                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1792                     }
1793                 }
1794             }
1795         }
1796 
1797         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1798         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1799         assembly {
1800             // Emit the `Transfer` event.
1801             log4(
1802                 0, // Start of data (0, since no data).
1803                 0, // End of data (0, since no data).
1804                 _TRANSFER_EVENT_SIGNATURE, // Signature.
1805                 from, // `from`.
1806                 toMasked, // `to`.
1807                 tokenId // `tokenId`.
1808             )
1809         }
1810         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
1811 
1812         _afterTokenTransfers(from, to, tokenId, 1);
1813     }
1814 
1815     /**
1816      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1817      */
1818     function safeTransferFrom(
1819         address from,
1820         address to,
1821         uint256 tokenId
1822     ) public payable virtual override {
1823         safeTransferFrom(from, to, tokenId, '');
1824     }
1825 
1826     /**
1827      * @dev Safely transfers `tokenId` token from `from` to `to`.
1828      *
1829      * Requirements:
1830      *
1831      * - `from` cannot be the zero address.
1832      * - `to` cannot be the zero address.
1833      * - `tokenId` token must exist and be owned by `from`.
1834      * - If the caller is not `from`, it must be approved to move this token
1835      * by either {approve} or {setApprovalForAll}.
1836      * - If `to` refers to a smart contract, it must implement
1837      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1838      *
1839      * Emits a {Transfer} event.
1840      */
1841     function safeTransferFrom(
1842         address from,
1843         address to,
1844         uint256 tokenId,
1845         bytes memory _data
1846     ) public payable virtual override {
1847         transferFrom(from, to, tokenId);
1848         if (to.code.length != 0)
1849             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1850                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1851             }
1852     }
1853 
1854     /**
1855      * @dev Hook that is called before a set of serially-ordered token IDs
1856      * are about to be transferred. This includes minting.
1857      * And also called before burning one token.
1858      *
1859      * `startTokenId` - the first token ID to be transferred.
1860      * `quantity` - the amount to be transferred.
1861      *
1862      * Calling conditions:
1863      *
1864      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1865      * transferred to `to`.
1866      * - When `from` is zero, `tokenId` will be minted for `to`.
1867      * - When `to` is zero, `tokenId` will be burned by `from`.
1868      * - `from` and `to` are never both zero.
1869      */
1870     function _beforeTokenTransfers(
1871         address from,
1872         address to,
1873         uint256 startTokenId,
1874         uint256 quantity
1875     ) internal virtual {}
1876 
1877     /**
1878      * @dev Hook that is called after a set of serially-ordered token IDs
1879      * have been transferred. This includes minting.
1880      * And also called after one token has been burned.
1881      *
1882      * `startTokenId` - the first token ID to be transferred.
1883      * `quantity` - the amount to be transferred.
1884      *
1885      * Calling conditions:
1886      *
1887      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1888      * transferred to `to`.
1889      * - When `from` is zero, `tokenId` has been minted for `to`.
1890      * - When `to` is zero, `tokenId` has been burned by `from`.
1891      * - `from` and `to` are never both zero.
1892      */
1893     function _afterTokenTransfers(
1894         address from,
1895         address to,
1896         uint256 startTokenId,
1897         uint256 quantity
1898     ) internal virtual {}
1899 
1900     /**
1901      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1902      *
1903      * `from` - Previous owner of the given token ID.
1904      * `to` - Target address that will receive the token.
1905      * `tokenId` - Token ID to be transferred.
1906      * `_data` - Optional data to send along with the call.
1907      *
1908      * Returns whether the call correctly returned the expected magic value.
1909      */
1910     function _checkContractOnERC721Received(
1911         address from,
1912         address to,
1913         uint256 tokenId,
1914         bytes memory _data
1915     ) private returns (bool) {
1916         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1917             bytes4 retval
1918         ) {
1919             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1920         } catch (bytes memory reason) {
1921             if (reason.length == 0) {
1922                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1923             }
1924             assembly {
1925                 revert(add(32, reason), mload(reason))
1926             }
1927         }
1928     }
1929 
1930     // =============================================================
1931     //                        MINT OPERATIONS
1932     // =============================================================
1933 
1934     /**
1935      * @dev Mints `quantity` tokens and transfers them to `to`.
1936      *
1937      * Requirements:
1938      *
1939      * - `to` cannot be the zero address.
1940      * - `quantity` must be greater than 0.
1941      *
1942      * Emits a {Transfer} event for each mint.
1943      */
1944     function _mint(address to, uint256 quantity) internal virtual {
1945         uint256 startTokenId = _currentIndex;
1946         if (quantity == 0) _revert(MintZeroQuantity.selector);
1947 
1948         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1949 
1950         // Overflows are incredibly unrealistic.
1951         // `balance` and `numberMinted` have a maximum limit of 2**64.
1952         // `tokenId` has a maximum limit of 2**256.
1953         unchecked {
1954             // Updates:
1955             // - `address` to the owner.
1956             // - `startTimestamp` to the timestamp of minting.
1957             // - `burned` to `false`.
1958             // - `nextInitialized` to `quantity == 1`.
1959             _packedOwnerships[startTokenId] = _packOwnershipData(
1960                 to,
1961                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1962             );
1963 
1964             // Updates:
1965             // - `balance += quantity`.
1966             // - `numberMinted += quantity`.
1967             //
1968             // We can directly add to the `balance` and `numberMinted`.
1969             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1970 
1971             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1972             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1973 
1974             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1975 
1976             uint256 end = startTokenId + quantity;
1977             uint256 tokenId = startTokenId;
1978 
1979             do {
1980                 assembly {
1981                     // Emit the `Transfer` event.
1982                     log4(
1983                         0, // Start of data (0, since no data).
1984                         0, // End of data (0, since no data).
1985                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1986                         0, // `address(0)`.
1987                         toMasked, // `to`.
1988                         tokenId // `tokenId`.
1989                     )
1990                 }
1991                 // The `!=` check ensures that large values of `quantity`
1992                 // that overflows uint256 will make the loop run out of gas.
1993             } while (++tokenId != end);
1994 
1995             _currentIndex = end;
1996         }
1997         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1998     }
1999 
2000     /**
2001      * @dev Mints `quantity` tokens and transfers them to `to`.
2002      *
2003      * This function is intended for efficient minting only during contract creation.
2004      *
2005      * It emits only one {ConsecutiveTransfer} as defined in
2006      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2007      * instead of a sequence of {Transfer} event(s).
2008      *
2009      * Calling this function outside of contract creation WILL make your contract
2010      * non-compliant with the ERC721 standard.
2011      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2012      * {ConsecutiveTransfer} event is only permissible during contract creation.
2013      *
2014      * Requirements:
2015      *
2016      * - `to` cannot be the zero address.
2017      * - `quantity` must be greater than 0.
2018      *
2019      * Emits a {ConsecutiveTransfer} event.
2020      */
2021     function _mintERC2309(address to, uint256 quantity) internal virtual {
2022         uint256 startTokenId = _currentIndex;
2023         if (to == address(0)) _revert(MintToZeroAddress.selector);
2024         if (quantity == 0) _revert(MintZeroQuantity.selector);
2025         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
2026 
2027         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2028 
2029         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2030         unchecked {
2031             // Updates:
2032             // - `balance += quantity`.
2033             // - `numberMinted += quantity`.
2034             //
2035             // We can directly add to the `balance` and `numberMinted`.
2036             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2037 
2038             // Updates:
2039             // - `address` to the owner.
2040             // - `startTimestamp` to the timestamp of minting.
2041             // - `burned` to `false`.
2042             // - `nextInitialized` to `quantity == 1`.
2043             _packedOwnerships[startTokenId] = _packOwnershipData(
2044                 to,
2045                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2046             );
2047 
2048             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2049 
2050             _currentIndex = startTokenId + quantity;
2051         }
2052         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2053     }
2054 
2055     /**
2056      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2057      *
2058      * Requirements:
2059      *
2060      * - If `to` refers to a smart contract, it must implement
2061      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2062      * - `quantity` must be greater than 0.
2063      *
2064      * See {_mint}.
2065      *
2066      * Emits a {Transfer} event for each mint.
2067      */
2068     function _safeMint(
2069         address to,
2070         uint256 quantity,
2071         bytes memory _data
2072     ) internal virtual {
2073         _mint(to, quantity);
2074 
2075         unchecked {
2076             if (to.code.length != 0) {
2077                 uint256 end = _currentIndex;
2078                 uint256 index = end - quantity;
2079                 do {
2080                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2081                         _revert(TransferToNonERC721ReceiverImplementer.selector);
2082                     }
2083                 } while (index < end);
2084                 // Reentrancy protection.
2085                 if (_currentIndex != end) _revert(bytes4(0));
2086             }
2087         }
2088     }
2089 
2090     /**
2091      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2092      */
2093     function _safeMint(address to, uint256 quantity) internal virtual {
2094         _safeMint(to, quantity, '');
2095     }
2096 
2097     // =============================================================
2098     //                       APPROVAL OPERATIONS
2099     // =============================================================
2100 
2101     /**
2102      * @dev Equivalent to `_approve(to, tokenId, false)`.
2103      */
2104     function _approve(address to, uint256 tokenId) internal virtual {
2105         _approve(to, tokenId, false);
2106     }
2107 
2108     /**
2109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2110      * The approval is cleared when the token is transferred.
2111      *
2112      * Only a single account can be approved at a time, so approving the
2113      * zero address clears previous approvals.
2114      *
2115      * Requirements:
2116      *
2117      * - `tokenId` must exist.
2118      *
2119      * Emits an {Approval} event.
2120      */
2121     function _approve(
2122         address to,
2123         uint256 tokenId,
2124         bool approvalCheck
2125     ) internal virtual {
2126         address owner = ownerOf(tokenId);
2127 
2128         if (approvalCheck && _msgSenderERC721A() != owner)
2129             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2130                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
2131             }
2132 
2133         _tokenApprovals[tokenId].value = to;
2134         emit Approval(owner, to, tokenId);
2135     }
2136 
2137     // =============================================================
2138     //                        BURN OPERATIONS
2139     // =============================================================
2140 
2141     /**
2142      * @dev Equivalent to `_burn(tokenId, false)`.
2143      */
2144     function _burn(uint256 tokenId) internal virtual {
2145         _burn(tokenId, false);
2146     }
2147 
2148     /**
2149      * @dev Destroys `tokenId`.
2150      * The approval is cleared when the token is burned.
2151      *
2152      * Requirements:
2153      *
2154      * - `tokenId` must exist.
2155      *
2156      * Emits a {Transfer} event.
2157      */
2158     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2159         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2160 
2161         address from = address(uint160(prevOwnershipPacked));
2162 
2163         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2164 
2165         if (approvalCheck) {
2166             // The nested ifs save around 20+ gas over a compound boolean condition.
2167             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2168                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2169         }
2170 
2171         _beforeTokenTransfers(from, address(0), tokenId, 1);
2172 
2173         // Clear approvals from the previous owner.
2174         assembly {
2175             if approvedAddress {
2176                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2177                 sstore(approvedAddressSlot, 0)
2178             }
2179         }
2180 
2181         // Underflow of the sender's balance is impossible because we check for
2182         // ownership above and the recipient's balance can't realistically overflow.
2183         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2184         unchecked {
2185             // Updates:
2186             // - `balance -= 1`.
2187             // - `numberBurned += 1`.
2188             //
2189             // We can directly decrement the balance, and increment the number burned.
2190             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2191             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2192 
2193             // Updates:
2194             // - `address` to the last owner.
2195             // - `startTimestamp` to the timestamp of burning.
2196             // - `burned` to `true`.
2197             // - `nextInitialized` to `true`.
2198             _packedOwnerships[tokenId] = _packOwnershipData(
2199                 from,
2200                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2201             );
2202 
2203             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2204             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2205                 uint256 nextTokenId = tokenId + 1;
2206                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2207                 if (_packedOwnerships[nextTokenId] == 0) {
2208                     // If the next slot is within bounds.
2209                     if (nextTokenId != _currentIndex) {
2210                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2211                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2212                     }
2213                 }
2214             }
2215         }
2216 
2217         emit Transfer(from, address(0), tokenId);
2218         _afterTokenTransfers(from, address(0), tokenId, 1);
2219 
2220         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2221         unchecked {
2222             _burnCounter++;
2223         }
2224     }
2225 
2226     // =============================================================
2227     //                     EXTRA DATA OPERATIONS
2228     // =============================================================
2229 
2230     /**
2231      * @dev Directly sets the extra data for the ownership data `index`.
2232      */
2233     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2234         uint256 packed = _packedOwnerships[index];
2235         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
2236         uint256 extraDataCasted;
2237         // Cast `extraData` with assembly to avoid redundant masking.
2238         assembly {
2239             extraDataCasted := extraData
2240         }
2241         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2242         _packedOwnerships[index] = packed;
2243     }
2244 
2245     /**
2246      * @dev Called during each token transfer to set the 24bit `extraData` field.
2247      * Intended to be overridden by the cosumer contract.
2248      *
2249      * `previousExtraData` - the value of `extraData` before transfer.
2250      *
2251      * Calling conditions:
2252      *
2253      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2254      * transferred to `to`.
2255      * - When `from` is zero, `tokenId` will be minted for `to`.
2256      * - When `to` is zero, `tokenId` will be burned by `from`.
2257      * - `from` and `to` are never both zero.
2258      */
2259     function _extraData(
2260         address from,
2261         address to,
2262         uint24 previousExtraData
2263     ) internal view virtual returns (uint24) {}
2264 
2265     /**
2266      * @dev Returns the next extra data for the packed ownership data.
2267      * The returned result is shifted into position.
2268      */
2269     function _nextExtraData(
2270         address from,
2271         address to,
2272         uint256 prevOwnershipPacked
2273     ) private view returns (uint256) {
2274         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2275         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2276     }
2277 
2278     // =============================================================
2279     //                       OTHER OPERATIONS
2280     // =============================================================
2281 
2282     /**
2283      * @dev Returns the message sender (defaults to `msg.sender`).
2284      *
2285      * If you are writing GSN compatible contracts, you need to override this function.
2286      */
2287     function _msgSenderERC721A() internal view virtual returns (address) {
2288         return msg.sender;
2289     }
2290 
2291     /**
2292      * @dev Converts a uint256 to its ASCII string decimal representation.
2293      */
2294     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2295         assembly {
2296             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2297             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2298             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2299             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2300             let m := add(mload(0x40), 0xa0)
2301             // Update the free memory pointer to allocate.
2302             mstore(0x40, m)
2303             // Assign the `str` to the end.
2304             str := sub(m, 0x20)
2305             // Zeroize the slot after the string.
2306             mstore(str, 0)
2307 
2308             // Cache the end of the memory to calculate the length later.
2309             let end := str
2310 
2311             // We write the string from rightmost digit to leftmost digit.
2312             // The following is essentially a do-while loop that also handles the zero case.
2313             // prettier-ignore
2314             for { let temp := value } 1 {} {
2315                 str := sub(str, 1)
2316                 // Write the character to the pointer.
2317                 // The ASCII index of the '0' character is 48.
2318                 mstore8(str, add(48, mod(temp, 10)))
2319                 // Keep dividing `temp` until zero.
2320                 temp := div(temp, 10)
2321                 // prettier-ignore
2322                 if iszero(temp) { break }
2323             }
2324 
2325             let length := sub(end, str)
2326             // Move the pointer 32 bytes leftwards to make room for the length.
2327             str := sub(str, 0x20)
2328             // Store the length.
2329             mstore(str, length)
2330         }
2331     }
2332 
2333     /**
2334      * @dev For more efficient reverts.
2335      */
2336     function _revert(bytes4 errorSelector) internal pure {
2337         assembly {
2338             mstore(0x00, errorSelector)
2339             revert(0x00, 0x04)
2340         }
2341     }
2342 }
2343 
2344 // File: contracts/ChromaHeights.sol
2345 
2346 
2347 pragma solidity ^0.8.20;
2348 
2349 
2350 
2351 
2352 
2353 
2354 contract ChromaHeights is ERC721A, ERC2981, Ownable {
2355    
2356     
2357 
2358     using Strings for uint256;
2359     uint256 public maxSupply = 2222;
2360     uint256 public maxFreeAmount = 888;
2361     uint256 public maxFreePerWallet = 2;
2362     uint256 public price = 0.0025 ether;
2363     uint256 public maxPerTx = 50;
2364     uint256 public maxPerWallet = 50;
2365     bool public mintEnabled = false;
2366     string public baseURI;
2367 
2368  constructor(
2369     uint96 _royaltyFeesInBips, 
2370     string memory _name,
2371     string memory _symbol,
2372     string memory _initBaseURI
2373   ) ERC721A(_name,_symbol) Ownable(msg.sender) {
2374         setBaseURI(_initBaseURI);
2375         setRoyaltyInfo(msg.sender, _royaltyFeesInBips);
2376     }
2377 
2378 function supportsInterface(
2379     bytes4 interfaceId
2380 ) public view virtual override(ERC721A, ERC2981) returns (bool) {
2381     // Supports the following `interfaceId`s:
2382     // - IERC165: 0x01ffc9a7
2383     // - IERC721: 0x80ac58cd
2384     // - IERC721Metadata: 0x5b5e139f
2385     // - IERC2981: 0x2a55205a
2386     return 
2387         ERC721A.supportsInterface(interfaceId) || 
2388         ERC2981.supportsInterface(interfaceId);
2389 }
2390     function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner
2391     {
2392         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
2393     }
2394 
2395 
2396   function  adminMint(uint256 _amountPerAddress, address[] calldata addresses) external onlyOwner {
2397      uint256 totalSupply = uint256(totalSupply());
2398      uint totalAmount =   _amountPerAddress * addresses.length;
2399     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
2400      for (uint256 i = 0; i < addresses.length; i++) {
2401             _safeMint(addresses[i], _amountPerAddress);
2402         }
2403 
2404      delete _amountPerAddress;
2405      delete totalSupply;
2406   }
2407         function _startTokenId() internal pure override returns (uint256) {
2408          return 1;
2409         }
2410     function  publicMint(uint256 quantity) external payable  {
2411         require(mintEnabled, "Minting is not live yet.");
2412         require(totalSupply() + quantity < maxSupply + 1, "No more");
2413         uint256 cost = price;
2414         uint256 _maxPerWallet = maxPerWallet;
2415         
2416 
2417         if (
2418             totalSupply() < maxFreeAmount &&
2419             _numberMinted(msg.sender) == 0 &&
2420             quantity <= maxFreePerWallet
2421         ) {
2422             cost = 0;
2423             _maxPerWallet = maxFreePerWallet;
2424         }
2425 
2426         require(
2427             _numberMinted(msg.sender) + quantity <= _maxPerWallet,
2428             "Max per wallet"
2429         );
2430 
2431         uint256 needPayCount = quantity;
2432         if (_numberMinted(msg.sender) == 0) {
2433             needPayCount = quantity - 1;
2434         }
2435         require(
2436             msg.value >= needPayCount * cost,
2437             "Please send the exact amount."
2438         );
2439         _safeMint(msg.sender, quantity);
2440     }
2441 
2442     function _baseURI() internal view virtual override returns (string memory) {
2443         return baseURI;
2444     }
2445 
2446     function tokenURI(
2447         uint256 tokenId
2448     ) public view virtual override returns (string memory) {
2449         require(
2450             _exists(tokenId),
2451             "ERC721Metadata: URI query for nonexistent token"
2452         );
2453         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2454     }
2455 
2456     function flipSale() external onlyOwner {
2457         mintEnabled = !mintEnabled;
2458     }
2459 
2460     function setBaseURI(string memory uri) public onlyOwner {
2461         baseURI = uri;
2462     }
2463 
2464     function setPrice(uint256 _newPrice) external onlyOwner {
2465         price = _newPrice;
2466     }
2467 
2468     function setMaxFreeAmount(uint256 _amount) external onlyOwner {
2469         maxFreeAmount = _amount;
2470     }
2471 
2472     function setMaxFreePerWallet(uint256 _amount) external onlyOwner {
2473         maxFreePerWallet = _amount;
2474     }
2475 
2476     function withdraw() external onlyOwner {
2477         (bool success, ) = payable(msg.sender).call{
2478             value: address(this).balance
2479         }("");
2480         require(success, "Transfer failed.");
2481     }
2482 }