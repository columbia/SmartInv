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
53     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
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
119      * @dev See {IERC165-supportsInterface}.
120      */
121     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
122         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
123     }
124 
125     /**
126      * @inheritdoc IERC2981
127      */
128     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
129         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
130 
131         if (royalty.receiver == address(0)) {
132             royalty = _defaultRoyaltyInfo;
133         }
134 
135         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
136 
137         return (royalty.receiver, royaltyAmount);
138     }
139 
140     /**
141      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
142      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
143      * override.
144      */
145     function _feeDenominator() internal pure virtual returns (uint96) {
146         return 10000;
147     }
148 
149     /**
150      * @dev Sets the royalty information that all ids in this contract will default to.
151      *
152      * Requirements:
153      *
154      * - `receiver` cannot be the zero address.
155      * - `feeNumerator` cannot be greater than the fee denominator.
156      */
157     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
158         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
159         require(receiver != address(0), "ERC2981: invalid receiver");
160 
161         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
162     }
163 
164     /**
165      * @dev Removes default royalty information.
166      */
167     function _deleteDefaultRoyalty() internal virtual {
168         delete _defaultRoyaltyInfo;
169     }
170 
171     /**
172      * @dev Sets the royalty information for a specific token id, overriding the global default.
173      *
174      * Requirements:
175      *
176      * - `receiver` cannot be the zero address.
177      * - `feeNumerator` cannot be greater than the fee denominator.
178      */
179     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
180         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
181         require(receiver != address(0), "ERC2981: Invalid parameters");
182 
183         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
184     }
185 
186     /**
187      * @dev Resets royalty information for the token id back to the global default.
188      */
189     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
190         delete _tokenRoyaltyInfo[tokenId];
191     }
192 }
193 
194 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SignedMath.sol
195 
196 
197 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
198 
199 pragma solidity ^0.8.19;
200 
201 /**
202  * @dev Standard signed math utilities missing in the Solidity language.
203  */
204 library SignedMath {
205     /**
206      * @dev Returns the largest of two signed numbers.
207      */
208     function max(int256 a, int256 b) internal pure returns (int256) {
209         return a > b ? a : b;
210     }
211 
212     /**
213      * @dev Returns the smallest of two signed numbers.
214      */
215     function min(int256 a, int256 b) internal pure returns (int256) {
216         return a < b ? a : b;
217     }
218 
219     /**
220      * @dev Returns the average of two signed numbers without overflow.
221      * The result is rounded towards zero.
222      */
223     function average(int256 a, int256 b) internal pure returns (int256) {
224         // Formula from the book "Hacker's Delight"
225         int256 x = (a & b) + ((a ^ b) >> 1);
226         return x + (int256(uint256(x) >> 255) & (a ^ b));
227     }
228 
229     /**
230      * @dev Returns the absolute unsigned value of a signed value.
231      */
232     function abs(int256 n) internal pure returns (uint256) {
233         unchecked {
234             // must be unchecked in order to support `n = type(int256).min`
235             return uint256(n >= 0 ? n : -n);
236         }
237     }
238 }
239 
240 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
244 
245 pragma solidity ^0.8.19;
246 
247 /**
248  * @dev Standard math utilities missing in the Solidity language.
249  */
250 library Math {
251     enum Rounding {
252         Down, // Toward negative infinity
253         Up, // Toward infinity
254         Zero // Toward zero
255     }
256 
257     /**
258      * @dev Returns the addition of two unsigned integers, with an overflow flag.
259      *
260      * _Available since v5.0._
261      */
262     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             uint256 c = a + b;
265             if (c < a) return (false, 0);
266             return (true, c);
267         }
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
272      *
273      * _Available since v5.0._
274      */
275     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             if (b > a) return (false, 0);
278             return (true, a - b);
279         }
280     }
281 
282     /**
283      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
284      *
285      * _Available since v5.0._
286      */
287     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
288         unchecked {
289             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
290             // benefit is lost if 'b' is also tested.
291             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
292             if (a == 0) return (true, 0);
293             uint256 c = a * b;
294             if (c / a != b) return (false, 0);
295             return (true, c);
296         }
297     }
298 
299     /**
300      * @dev Returns the division of two unsigned integers, with a division by zero flag.
301      *
302      * _Available since v5.0._
303      */
304     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
305         unchecked {
306             if (b == 0) return (false, 0);
307             return (true, a / b);
308         }
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
313      *
314      * _Available since v5.0._
315      */
316     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
317         unchecked {
318             if (b == 0) return (false, 0);
319             return (true, a % b);
320         }
321     }
322 
323     /**
324      * @dev Returns the largest of two numbers.
325      */
326     function max(uint256 a, uint256 b) internal pure returns (uint256) {
327         return a > b ? a : b;
328     }
329 
330     /**
331      * @dev Returns the smallest of two numbers.
332      */
333     function min(uint256 a, uint256 b) internal pure returns (uint256) {
334         return a < b ? a : b;
335     }
336 
337     /**
338      * @dev Returns the average of two numbers. The result is rounded towards
339      * zero.
340      */
341     function average(uint256 a, uint256 b) internal pure returns (uint256) {
342         // (a + b) / 2 can overflow.
343         return (a & b) + (a ^ b) / 2;
344     }
345 
346     /**
347      * @dev Returns the ceiling of the division of two numbers.
348      *
349      * This differs from standard division with `/` in that it rounds up instead
350      * of rounding down.
351      */
352     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
353         // (a + b - 1) / b can overflow on addition, so we distribute.
354         return a == 0 ? 0 : (a - 1) / b + 1;
355     }
356 
357     /**
358      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
359      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
360      * with further edits by Uniswap Labs also under MIT license.
361      */
362     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
363         unchecked {
364             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
365             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
366             // variables such that product = prod1 * 2^256 + prod0.
367             uint256 prod0; // Least significant 256 bits of the product
368             uint256 prod1; // Most significant 256 bits of the product
369             assembly {
370                 let mm := mulmod(x, y, not(0))
371                 prod0 := mul(x, y)
372                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
373             }
374 
375             // Handle non-overflow cases, 256 by 256 division.
376             if (prod1 == 0) {
377                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
378                 // The surrounding unchecked block does not change this fact.
379                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
380                 return prod0 / denominator;
381             }
382 
383             // Make sure the result is less than 2^256. Also prevents denominator == 0.
384             require(denominator > prod1, "Math: mulDiv overflow");
385 
386             ///////////////////////////////////////////////
387             // 512 by 256 division.
388             ///////////////////////////////////////////////
389 
390             // Make division exact by subtracting the remainder from [prod1 prod0].
391             uint256 remainder;
392             assembly {
393                 // Compute remainder using mulmod.
394                 remainder := mulmod(x, y, denominator)
395 
396                 // Subtract 256 bit number from 512 bit number.
397                 prod1 := sub(prod1, gt(remainder, prod0))
398                 prod0 := sub(prod0, remainder)
399             }
400 
401             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
402             // See https://cs.stackexchange.com/q/138556/92363.
403 
404             // Does not overflow because the denominator cannot be zero at this stage in the function.
405             uint256 twos = denominator & (~denominator + 1);
406             assembly {
407                 // Divide denominator by twos.
408                 denominator := div(denominator, twos)
409 
410                 // Divide [prod1 prod0] by twos.
411                 prod0 := div(prod0, twos)
412 
413                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
414                 twos := add(div(sub(0, twos), twos), 1)
415             }
416 
417             // Shift in bits from prod1 into prod0.
418             prod0 |= prod1 * twos;
419 
420             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
421             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
422             // four bits. That is, denominator * inv = 1 mod 2^4.
423             uint256 inverse = (3 * denominator) ^ 2;
424 
425             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
426             // in modular arithmetic, doubling the correct bits in each step.
427             inverse *= 2 - denominator * inverse; // inverse mod 2^8
428             inverse *= 2 - denominator * inverse; // inverse mod 2^16
429             inverse *= 2 - denominator * inverse; // inverse mod 2^32
430             inverse *= 2 - denominator * inverse; // inverse mod 2^64
431             inverse *= 2 - denominator * inverse; // inverse mod 2^128
432             inverse *= 2 - denominator * inverse; // inverse mod 2^256
433 
434             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
435             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
436             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
437             // is no longer required.
438             result = prod0 * inverse;
439             return result;
440         }
441     }
442 
443     /**
444      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
445      */
446     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
447         uint256 result = mulDiv(x, y, denominator);
448         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
449             result += 1;
450         }
451         return result;
452     }
453 
454     /**
455      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
456      *
457      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
458      */
459     function sqrt(uint256 a) internal pure returns (uint256) {
460         if (a == 0) {
461             return 0;
462         }
463 
464         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
465         //
466         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
467         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
468         //
469         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
470         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
471         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
472         //
473         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
474         uint256 result = 1 << (log2(a) >> 1);
475 
476         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
477         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
478         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
479         // into the expected uint128 result.
480         unchecked {
481             result = (result + a / result) >> 1;
482             result = (result + a / result) >> 1;
483             result = (result + a / result) >> 1;
484             result = (result + a / result) >> 1;
485             result = (result + a / result) >> 1;
486             result = (result + a / result) >> 1;
487             result = (result + a / result) >> 1;
488             return min(result, a / result);
489         }
490     }
491 
492     /**
493      * @notice Calculates sqrt(a), following the selected rounding direction.
494      */
495     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
496         unchecked {
497             uint256 result = sqrt(a);
498             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
499         }
500     }
501 
502     /**
503      * @dev Return the log in base 2, rounded down, of a positive value.
504      * Returns 0 if given 0.
505      */
506     function log2(uint256 value) internal pure returns (uint256) {
507         uint256 result = 0;
508         unchecked {
509             if (value >> 128 > 0) {
510                 value >>= 128;
511                 result += 128;
512             }
513             if (value >> 64 > 0) {
514                 value >>= 64;
515                 result += 64;
516             }
517             if (value >> 32 > 0) {
518                 value >>= 32;
519                 result += 32;
520             }
521             if (value >> 16 > 0) {
522                 value >>= 16;
523                 result += 16;
524             }
525             if (value >> 8 > 0) {
526                 value >>= 8;
527                 result += 8;
528             }
529             if (value >> 4 > 0) {
530                 value >>= 4;
531                 result += 4;
532             }
533             if (value >> 2 > 0) {
534                 value >>= 2;
535                 result += 2;
536             }
537             if (value >> 1 > 0) {
538                 result += 1;
539             }
540         }
541         return result;
542     }
543 
544     /**
545      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
546      * Returns 0 if given 0.
547      */
548     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
549         unchecked {
550             uint256 result = log2(value);
551             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
552         }
553     }
554 
555     /**
556      * @dev Return the log in base 10, rounded down, of a positive value.
557      * Returns 0 if given 0.
558      */
559     function log10(uint256 value) internal pure returns (uint256) {
560         uint256 result = 0;
561         unchecked {
562             if (value >= 10 ** 64) {
563                 value /= 10 ** 64;
564                 result += 64;
565             }
566             if (value >= 10 ** 32) {
567                 value /= 10 ** 32;
568                 result += 32;
569             }
570             if (value >= 10 ** 16) {
571                 value /= 10 ** 16;
572                 result += 16;
573             }
574             if (value >= 10 ** 8) {
575                 value /= 10 ** 8;
576                 result += 8;
577             }
578             if (value >= 10 ** 4) {
579                 value /= 10 ** 4;
580                 result += 4;
581             }
582             if (value >= 10 ** 2) {
583                 value /= 10 ** 2;
584                 result += 2;
585             }
586             if (value >= 10 ** 1) {
587                 result += 1;
588             }
589         }
590         return result;
591     }
592 
593     /**
594      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
595      * Returns 0 if given 0.
596      */
597     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
598         unchecked {
599             uint256 result = log10(value);
600             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
601         }
602     }
603 
604     /**
605      * @dev Return the log in base 256, rounded down, of a positive value.
606      * Returns 0 if given 0.
607      *
608      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
609      */
610     function log256(uint256 value) internal pure returns (uint256) {
611         uint256 result = 0;
612         unchecked {
613             if (value >> 128 > 0) {
614                 value >>= 128;
615                 result += 16;
616             }
617             if (value >> 64 > 0) {
618                 value >>= 64;
619                 result += 8;
620             }
621             if (value >> 32 > 0) {
622                 value >>= 32;
623                 result += 4;
624             }
625             if (value >> 16 > 0) {
626                 value >>= 16;
627                 result += 2;
628             }
629             if (value >> 8 > 0) {
630                 result += 1;
631             }
632         }
633         return result;
634     }
635 
636     /**
637      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
638      * Returns 0 if given 0.
639      */
640     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
641         unchecked {
642             uint256 result = log256(value);
643             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
644         }
645     }
646 }
647 
648 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
649 
650 
651 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
652 
653 pragma solidity ^0.8.19;
654 
655 
656 
657 /**
658  * @dev String operations.
659  */
660 library Strings {
661     bytes16 private constant _SYMBOLS = "0123456789abcdef";
662     uint8 private constant _ADDRESS_LENGTH = 20;
663 
664     /**
665      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
666      */
667     function toString(uint256 value) internal pure returns (string memory) {
668         unchecked {
669             uint256 length = Math.log10(value) + 1;
670             string memory buffer = new string(length);
671             uint256 ptr;
672             /// @solidity memory-safe-assembly
673             assembly {
674                 ptr := add(buffer, add(32, length))
675             }
676             while (true) {
677                 ptr--;
678                 /// @solidity memory-safe-assembly
679                 assembly {
680                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
681                 }
682                 value /= 10;
683                 if (value == 0) break;
684             }
685             return buffer;
686         }
687     }
688 
689     /**
690      * @dev Converts a `int256` to its ASCII `string` decimal representation.
691      */
692     function toString(int256 value) internal pure returns (string memory) {
693         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
694     }
695 
696     /**
697      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
698      */
699     function toHexString(uint256 value) internal pure returns (string memory) {
700         unchecked {
701             return toHexString(value, Math.log256(value) + 1);
702         }
703     }
704 
705     /**
706      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
707      */
708     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
709         bytes memory buffer = new bytes(2 * length + 2);
710         buffer[0] = "0";
711         buffer[1] = "x";
712         for (uint256 i = 2 * length + 1; i > 1; --i) {
713             buffer[i] = _SYMBOLS[value & 0xf];
714             value >>= 4;
715         }
716         require(value == 0, "Strings: hex length insufficient");
717         return string(buffer);
718     }
719 
720     /**
721      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
722      */
723     function toHexString(address addr) internal pure returns (string memory) {
724         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
725     }
726 
727     /**
728      * @dev Returns true if the two strings are equal.
729      */
730     function equal(string memory a, string memory b) internal pure returns (bool) {
731         return bytes(a).length == bytes(b).length && keccak256(bytes(a)) == keccak256(bytes(b));
732     }
733 }
734 
735 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
739 
740 pragma solidity ^0.8.19;
741 
742 /**
743  * @dev Provides information about the current execution context, including the
744  * sender of the transaction and its data. While these are generally available
745  * via msg.sender and msg.data, they should not be accessed in such a direct
746  * manner, since when dealing with meta-transactions the account sending and
747  * paying for execution may not be the actual sender (as far as an application
748  * is concerned).
749  *
750  * This contract is only required for intermediate, library-like contracts.
751  */
752 abstract contract Context {
753     function _msgSender() internal view virtual returns (address) {
754         return msg.sender;
755     }
756 
757     function _msgData() internal view virtual returns (bytes calldata) {
758         return msg.data;
759     }
760 }
761 
762 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
763 
764 
765 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
766 
767 pragma solidity ^0.8.19;
768 
769 
770 /**
771  * @dev Contract module which provides a basic access control mechanism, where
772  * there is an account (an owner) that can be granted exclusive access to
773  * specific functions.
774  *
775  * By default, the owner account will be the one that deploys the contract. This
776  * can later be changed with {transferOwnership}.
777  *
778  * This module is used through inheritance. It will make available the modifier
779  * `onlyOwner`, which can be applied to your functions to restrict their use to
780  * the owner.
781  */
782 abstract contract Ownable is Context {
783     address private _owner;
784 
785     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
786 
787     /**
788      * @dev Initializes the contract setting the deployer as the initial owner.
789      */
790     constructor(address initialOwner) {
791         _transferOwnership(initialOwner);
792     }
793 
794     /**
795      * @dev Throws if called by any account other than the owner.
796      */
797     modifier onlyOwner() {
798         _checkOwner();
799         _;
800     }
801 
802     /**
803      * @dev Returns the address of the current owner.
804      */
805     function owner() public view virtual returns (address) {
806         return _owner;
807     }
808 
809     /**
810      * @dev Throws if the sender is not the owner.
811      */
812     function _checkOwner() internal view virtual {
813         require(owner() == _msgSender(), "Ownable: caller is not the owner");
814     }
815 
816     /**
817      * @dev Leaves the contract without owner. It will not be possible to call
818      * `onlyOwner` functions. Can only be called by the current owner.
819      *
820      * NOTE: Renouncing ownership will leave the contract without an owner,
821      * thereby disabling any functionality that is only available to the owner.
822      */
823     function renounceOwnership() public virtual onlyOwner {
824         _transferOwnership(address(0));
825     }
826 
827     /**
828      * @dev Transfers ownership of the contract to a new account (`newOwner`).
829      * Can only be called by the current owner.
830      */
831     function transferOwnership(address newOwner) public virtual onlyOwner {
832         require(newOwner != address(0), "Ownable: new owner is the zero address");
833         _transferOwnership(newOwner);
834     }
835 
836     /**
837      * @dev Transfers ownership of the contract to a new account (`newOwner`).
838      * Internal function without access restriction.
839      */
840     function _transferOwnership(address newOwner) internal virtual {
841         address oldOwner = _owner;
842         _owner = newOwner;
843         emit OwnershipTransferred(oldOwner, newOwner);
844     }
845 }
846 
847 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
848 
849 
850 // ERC721A Contracts v4.2.3
851 // Creator: Chiru Labs
852 
853 pragma solidity ^0.8.4;
854 
855 /**
856  * @dev Interface of ERC721A.
857  */
858 interface IERC721A {
859     /**
860      * The caller must own the token or be an approved operator.
861      */
862     error ApprovalCallerNotOwnerNorApproved();
863 
864     /**
865      * The token does not exist.
866      */
867     error ApprovalQueryForNonexistentToken();
868 
869     /**
870      * Cannot query the balance for the zero address.
871      */
872     error BalanceQueryForZeroAddress();
873 
874     /**
875      * Cannot mint to the zero address.
876      */
877     error MintToZeroAddress();
878 
879     /**
880      * The quantity of tokens minted must be more than zero.
881      */
882     error MintZeroQuantity();
883 
884     /**
885      * The token does not exist.
886      */
887     error OwnerQueryForNonexistentToken();
888 
889     /**
890      * The caller must own the token or be an approved operator.
891      */
892     error TransferCallerNotOwnerNorApproved();
893 
894     /**
895      * The token must be owned by `from`.
896      */
897     error TransferFromIncorrectOwner();
898 
899     /**
900      * Cannot safely transfer to a contract that does not implement the
901      * ERC721Receiver interface.
902      */
903     error TransferToNonERC721ReceiverImplementer();
904 
905     /**
906      * Cannot transfer to the zero address.
907      */
908     error TransferToZeroAddress();
909 
910     /**
911      * The token does not exist.
912      */
913     error URIQueryForNonexistentToken();
914 
915     /**
916      * The `quantity` minted with ERC2309 exceeds the safety limit.
917      */
918     error MintERC2309QuantityExceedsLimit();
919 
920     /**
921      * The `extraData` cannot be set on an unintialized ownership slot.
922      */
923     error OwnershipNotInitializedForExtraData();
924 
925     // =============================================================
926     //                            STRUCTS
927     // =============================================================
928 
929     struct TokenOwnership {
930         // The address of the owner.
931         address addr;
932         // Stores the start time of ownership with minimal overhead for tokenomics.
933         uint64 startTimestamp;
934         // Whether the token has been burned.
935         bool burned;
936         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
937         uint24 extraData;
938     }
939 
940     // =============================================================
941     //                         TOKEN COUNTERS
942     // =============================================================
943 
944     /**
945      * @dev Returns the total number of tokens in existence.
946      * Burned tokens will reduce the count.
947      * To get the total number of tokens minted, please see {_totalMinted}.
948      */
949     function totalSupply() external view returns (uint256);
950 
951     // =============================================================
952     //                            IERC165
953     // =============================================================
954 
955     /**
956      * @dev Returns true if this contract implements the interface defined by
957      * `interfaceId`. See the corresponding
958      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
959      * to learn more about how these ids are created.
960      *
961      * This function call must use less than 30000 gas.
962      */
963     function supportsInterface(bytes4 interfaceId) external view returns (bool);
964 
965     // =============================================================
966     //                            IERC721
967     // =============================================================
968 
969     /**
970      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
971      */
972     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
973 
974     /**
975      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
976      */
977     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
978 
979     /**
980      * @dev Emitted when `owner` enables or disables
981      * (`approved`) `operator` to manage all of its assets.
982      */
983     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
984 
985     /**
986      * @dev Returns the number of tokens in `owner`'s account.
987      */
988     function balanceOf(address owner) external view returns (uint256 balance);
989 
990     /**
991      * @dev Returns the owner of the `tokenId` token.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must exist.
996      */
997     function ownerOf(uint256 tokenId) external view returns (address owner);
998 
999     /**
1000      * @dev Safely transfers `tokenId` token from `from` to `to`,
1001      * checking first that contract recipients are aware of the ERC721 protocol
1002      * to prevent tokens from being forever locked.
1003      *
1004      * Requirements:
1005      *
1006      * - `from` cannot be the zero address.
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must exist and be owned by `from`.
1009      * - If the caller is not `from`, it must be have been allowed to move
1010      * this token by either {approve} or {setApprovalForAll}.
1011      * - If `to` refers to a smart contract, it must implement
1012      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes calldata data
1021     ) external payable;
1022 
1023     /**
1024      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) external payable;
1031 
1032     /**
1033      * @dev Transfers `tokenId` from `from` to `to`.
1034      *
1035      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1036      * whenever possible.
1037      *
1038      * Requirements:
1039      *
1040      * - `from` cannot be the zero address.
1041      * - `to` cannot be the zero address.
1042      * - `tokenId` token must be owned by `from`.
1043      * - If the caller is not `from`, it must be approved to move this token
1044      * by either {approve} or {setApprovalForAll}.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function transferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) external payable;
1053 
1054     /**
1055      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1056      * The approval is cleared when the token is transferred.
1057      *
1058      * Only a single account can be approved at a time, so approving the
1059      * zero address clears previous approvals.
1060      *
1061      * Requirements:
1062      *
1063      * - The caller must own the token or be an approved operator.
1064      * - `tokenId` must exist.
1065      *
1066      * Emits an {Approval} event.
1067      */
1068     function approve(address to, uint256 tokenId) external payable;
1069 
1070     /**
1071      * @dev Approve or remove `operator` as an operator for the caller.
1072      * Operators can call {transferFrom} or {safeTransferFrom}
1073      * for any token owned by the caller.
1074      *
1075      * Requirements:
1076      *
1077      * - The `operator` cannot be the caller.
1078      *
1079      * Emits an {ApprovalForAll} event.
1080      */
1081     function setApprovalForAll(address operator, bool _approved) external;
1082 
1083     /**
1084      * @dev Returns the account approved for `tokenId` token.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      */
1090     function getApproved(uint256 tokenId) external view returns (address operator);
1091 
1092     /**
1093      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1094      *
1095      * See {setApprovalForAll}.
1096      */
1097     function isApprovedForAll(address owner, address operator) external view returns (bool);
1098 
1099     // =============================================================
1100     //                        IERC721Metadata
1101     // =============================================================
1102 
1103     /**
1104      * @dev Returns the token collection name.
1105      */
1106     function name() external view returns (string memory);
1107 
1108     /**
1109      * @dev Returns the token collection symbol.
1110      */
1111     function symbol() external view returns (string memory);
1112 
1113     /**
1114      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1115      */
1116     function tokenURI(uint256 tokenId) external view returns (string memory);
1117 
1118     // =============================================================
1119     //                           IERC2309
1120     // =============================================================
1121 
1122     /**
1123      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1124      * (inclusive) is transferred from `from` to `to`, as defined in the
1125      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1126      *
1127      * See {_mintERC2309} for more details.
1128      */
1129     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1130 }
1131 
1132 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
1133 
1134 
1135 // ERC721A Contracts v4.2.3
1136 // Creator: Chiru Labs
1137 
1138 pragma solidity ^0.8.4;
1139 
1140 
1141 /**
1142  * @dev Interface of ERC721 token receiver.
1143  */
1144 interface ERC721A__IERC721Receiver {
1145     function onERC721Received(
1146         address operator,
1147         address from,
1148         uint256 tokenId,
1149         bytes calldata data
1150     ) external returns (bytes4);
1151 }
1152 
1153 /**
1154  * @title ERC721A
1155  *
1156  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1157  * Non-Fungible Token Standard, including the Metadata extension.
1158  * Optimized for lower gas during batch mints.
1159  *
1160  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1161  * starting from `_startTokenId()`.
1162  *
1163  * Assumptions:
1164  *
1165  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1166  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1167  */
1168 contract ERC721A is IERC721A {
1169     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1170     struct TokenApprovalRef {
1171         address value;
1172     }
1173 
1174     // =============================================================
1175     //                           CONSTANTS
1176     // =============================================================
1177 
1178     // Mask of an entry in packed address data.
1179     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1180 
1181     // The bit position of `numberMinted` in packed address data.
1182     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1183 
1184     // The bit position of `numberBurned` in packed address data.
1185     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1186 
1187     // The bit position of `aux` in packed address data.
1188     uint256 private constant _BITPOS_AUX = 192;
1189 
1190     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1191     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1192 
1193     // The bit position of `startTimestamp` in packed ownership.
1194     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1195 
1196     // The bit mask of the `burned` bit in packed ownership.
1197     uint256 private constant _BITMASK_BURNED = 1 << 224;
1198 
1199     // The bit position of the `nextInitialized` bit in packed ownership.
1200     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1201 
1202     // The bit mask of the `nextInitialized` bit in packed ownership.
1203     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1204 
1205     // The bit position of `extraData` in packed ownership.
1206     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1207 
1208     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1209     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1210 
1211     // The mask of the lower 160 bits for addresses.
1212     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1213 
1214     // The maximum `quantity` that can be minted with {_mintERC2309}.
1215     // This limit is to prevent overflows on the address data entries.
1216     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1217     // is required to cause an overflow, which is unrealistic.
1218     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1219 
1220     // The `Transfer` event signature is given by:
1221     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1222     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1223         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1224 
1225     // =============================================================
1226     //                            STORAGE
1227     // =============================================================
1228 
1229     // The next token ID to be minted.
1230     uint256 private _currentIndex;
1231 
1232     // The number of tokens burned.
1233     uint256 private _burnCounter;
1234 
1235     // Token name
1236     string private _name;
1237 
1238     // Token symbol
1239     string private _symbol;
1240 
1241     // Mapping from token ID to ownership details
1242     // An empty struct value does not necessarily mean the token is unowned.
1243     // See {_packedOwnershipOf} implementation for details.
1244     //
1245     // Bits Layout:
1246     // - [0..159]   `addr`
1247     // - [160..223] `startTimestamp`
1248     // - [224]      `burned`
1249     // - [225]      `nextInitialized`
1250     // - [232..255] `extraData`
1251     mapping(uint256 => uint256) private _packedOwnerships;
1252 
1253     // Mapping owner address to address data.
1254     //
1255     // Bits Layout:
1256     // - [0..63]    `balance`
1257     // - [64..127]  `numberMinted`
1258     // - [128..191] `numberBurned`
1259     // - [192..255] `aux`
1260     mapping(address => uint256) private _packedAddressData;
1261 
1262     // Mapping from token ID to approved address.
1263     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1264 
1265     // Mapping from owner to operator approvals
1266     mapping(address => mapping(address => bool)) private _operatorApprovals;
1267 
1268     // =============================================================
1269     //                          CONSTRUCTOR
1270     // =============================================================
1271 
1272     constructor(string memory name_, string memory symbol_) {
1273         _name = name_;
1274         _symbol = symbol_;
1275         _currentIndex = _startTokenId();
1276     }
1277 
1278     // =============================================================
1279     //                   TOKEN COUNTING OPERATIONS
1280     // =============================================================
1281 
1282     /**
1283      * @dev Returns the starting token ID.
1284      * To change the starting token ID, please override this function.
1285      */
1286     function _startTokenId() internal view virtual returns (uint256) {
1287         return 0;
1288     }
1289 
1290     /**
1291      * @dev Returns the next token ID to be minted.
1292      */
1293     function _nextTokenId() internal view virtual returns (uint256) {
1294         return _currentIndex;
1295     }
1296 
1297     /**
1298      * @dev Returns the total number of tokens in existence.
1299      * Burned tokens will reduce the count.
1300      * To get the total number of tokens minted, please see {_totalMinted}.
1301      */
1302     function totalSupply() public view virtual override returns (uint256) {
1303         // Counter underflow is impossible as _burnCounter cannot be incremented
1304         // more than `_currentIndex - _startTokenId()` times.
1305         unchecked {
1306             return _currentIndex - _burnCounter - _startTokenId();
1307         }
1308     }
1309 
1310     /**
1311      * @dev Returns the total amount of tokens minted in the contract.
1312      */
1313     function _totalMinted() internal view virtual returns (uint256) {
1314         // Counter underflow is impossible as `_currentIndex` does not decrement,
1315         // and it is initialized to `_startTokenId()`.
1316         unchecked {
1317             return _currentIndex - _startTokenId();
1318         }
1319     }
1320 
1321     /**
1322      * @dev Returns the total number of tokens burned.
1323      */
1324     function _totalBurned() internal view virtual returns (uint256) {
1325         return _burnCounter;
1326     }
1327 
1328     // =============================================================
1329     //                    ADDRESS DATA OPERATIONS
1330     // =============================================================
1331 
1332     /**
1333      * @dev Returns the number of tokens in `owner`'s account.
1334      */
1335     function balanceOf(address owner) public view virtual override returns (uint256) {
1336         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
1337         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1338     }
1339 
1340     /**
1341      * Returns the number of tokens minted by `owner`.
1342      */
1343     function _numberMinted(address owner) internal view returns (uint256) {
1344         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1345     }
1346 
1347     /**
1348      * Returns the number of tokens burned by or on behalf of `owner`.
1349      */
1350     function _numberBurned(address owner) internal view returns (uint256) {
1351         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1352     }
1353 
1354     /**
1355      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1356      */
1357     function _getAux(address owner) internal view returns (uint64) {
1358         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1359     }
1360 
1361     /**
1362      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1363      * If there are multiple variables, please pack them into a uint64.
1364      */
1365     function _setAux(address owner, uint64 aux) internal virtual {
1366         uint256 packed = _packedAddressData[owner];
1367         uint256 auxCasted;
1368         // Cast `aux` with assembly to avoid redundant masking.
1369         assembly {
1370             auxCasted := aux
1371         }
1372         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1373         _packedAddressData[owner] = packed;
1374     }
1375 
1376     // =============================================================
1377     //                            IERC165
1378     // =============================================================
1379 
1380     /**
1381      * @dev Returns true if this contract implements the interface defined by
1382      * `interfaceId`. See the corresponding
1383      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1384      * to learn more about how these ids are created.
1385      *
1386      * This function call must use less than 30000 gas.
1387      */
1388     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1389         // The interface IDs are constants representing the first 4 bytes
1390         // of the XOR of all function selectors in the interface.
1391         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1392         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1393         return
1394             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1395             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1396             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1397     }
1398 
1399     // =============================================================
1400     //                        IERC721Metadata
1401     // =============================================================
1402 
1403     /**
1404      * @dev Returns the token collection name.
1405      */
1406     function name() public view virtual override returns (string memory) {
1407         return _name;
1408     }
1409 
1410     /**
1411      * @dev Returns the token collection symbol.
1412      */
1413     function symbol() public view virtual override returns (string memory) {
1414         return _symbol;
1415     }
1416 
1417     /**
1418      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1419      */
1420     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1421         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
1422 
1423         string memory baseURI = _baseURI();
1424         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1425     }
1426 
1427     /**
1428      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1429      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1430      * by default, it can be overridden in child contracts.
1431      */
1432     function _baseURI() internal view virtual returns (string memory) {
1433         return '';
1434     }
1435 
1436     // =============================================================
1437     //                     OWNERSHIPS OPERATIONS
1438     // =============================================================
1439 
1440     /**
1441      * @dev Returns the owner of the `tokenId` token.
1442      *
1443      * Requirements:
1444      *
1445      * - `tokenId` must exist.
1446      */
1447     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1448         return address(uint160(_packedOwnershipOf(tokenId)));
1449     }
1450 
1451     /**
1452      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1453      * It gradually moves to O(1) as tokens get transferred around over time.
1454      */
1455     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1456         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1457     }
1458 
1459     /**
1460      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1461      */
1462     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1463         return _unpackedOwnership(_packedOwnerships[index]);
1464     }
1465 
1466     /**
1467      * @dev Returns whether the ownership slot at `index` is initialized.
1468      * An uninitialized slot does not necessarily mean that the slot has no owner.
1469      */
1470     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
1471         return _packedOwnerships[index] != 0;
1472     }
1473 
1474     /**
1475      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1476      */
1477     function _initializeOwnershipAt(uint256 index) internal virtual {
1478         if (_packedOwnerships[index] == 0) {
1479             _packedOwnerships[index] = _packedOwnershipOf(index);
1480         }
1481     }
1482 
1483     /**
1484      * Returns the packed ownership data of `tokenId`.
1485      */
1486     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1487         if (_startTokenId() <= tokenId) {
1488             packed = _packedOwnerships[tokenId];
1489             // If the data at the starting slot does not exist, start the scan.
1490             if (packed == 0) {
1491                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
1492                 // Invariant:
1493                 // There will always be an initialized ownership slot
1494                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1495                 // before an unintialized ownership slot
1496                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1497                 // Hence, `tokenId` will not underflow.
1498                 //
1499                 // We can directly compare the packed value.
1500                 // If the address is zero, packed will be zero.
1501                 for (;;) {
1502                     unchecked {
1503                         packed = _packedOwnerships[--tokenId];
1504                     }
1505                     if (packed == 0) continue;
1506                     if (packed & _BITMASK_BURNED == 0) return packed;
1507                     // Otherwise, the token is burned, and we must revert.
1508                     // This handles the case of batch burned tokens, where only the burned bit
1509                     // of the starting slot is set, and remaining slots are left uninitialized.
1510                     _revert(OwnerQueryForNonexistentToken.selector);
1511                 }
1512             }
1513             // Otherwise, the data exists and we can skip the scan.
1514             // This is possible because we have already achieved the target condition.
1515             // This saves 2143 gas on transfers of initialized tokens.
1516             // If the token is not burned, return `packed`. Otherwise, revert.
1517             if (packed & _BITMASK_BURNED == 0) return packed;
1518         }
1519         _revert(OwnerQueryForNonexistentToken.selector);
1520     }
1521 
1522     /**
1523      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1524      */
1525     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1526         ownership.addr = address(uint160(packed));
1527         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1528         ownership.burned = packed & _BITMASK_BURNED != 0;
1529         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1530     }
1531 
1532     /**
1533      * @dev Packs ownership data into a single uint256.
1534      */
1535     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1536         assembly {
1537             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1538             owner := and(owner, _BITMASK_ADDRESS)
1539             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1540             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1541         }
1542     }
1543 
1544     /**
1545      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1546      */
1547     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1548         // For branchless setting of the `nextInitialized` flag.
1549         assembly {
1550             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1551             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1552         }
1553     }
1554 
1555     // =============================================================
1556     //                      APPROVAL OPERATIONS
1557     // =============================================================
1558 
1559     /**
1560      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1561      *
1562      * Requirements:
1563      *
1564      * - The caller must own the token or be an approved operator.
1565      */
1566     function approve(address to, uint256 tokenId) public payable virtual override {
1567         _approve(to, tokenId, true);
1568     }
1569 
1570     /**
1571      * @dev Returns the account approved for `tokenId` token.
1572      *
1573      * Requirements:
1574      *
1575      * - `tokenId` must exist.
1576      */
1577     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1578         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
1579 
1580         return _tokenApprovals[tokenId].value;
1581     }
1582 
1583     /**
1584      * @dev Approve or remove `operator` as an operator for the caller.
1585      * Operators can call {transferFrom} or {safeTransferFrom}
1586      * for any token owned by the caller.
1587      *
1588      * Requirements:
1589      *
1590      * - The `operator` cannot be the caller.
1591      *
1592      * Emits an {ApprovalForAll} event.
1593      */
1594     function setApprovalForAll(address operator, bool approved) public virtual override {
1595         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1596         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1597     }
1598 
1599     /**
1600      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1601      *
1602      * See {setApprovalForAll}.
1603      */
1604     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1605         return _operatorApprovals[owner][operator];
1606     }
1607 
1608     /**
1609      * @dev Returns whether `tokenId` exists.
1610      *
1611      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1612      *
1613      * Tokens start existing when they are minted. See {_mint}.
1614      */
1615     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
1616         if (_startTokenId() <= tokenId) {
1617             if (tokenId < _currentIndex) {
1618                 uint256 packed;
1619                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
1620                 result = packed & _BITMASK_BURNED == 0;
1621             }
1622         }
1623     }
1624 
1625     /**
1626      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1627      */
1628     function _isSenderApprovedOrOwner(
1629         address approvedAddress,
1630         address owner,
1631         address msgSender
1632     ) private pure returns (bool result) {
1633         assembly {
1634             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1635             owner := and(owner, _BITMASK_ADDRESS)
1636             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1637             msgSender := and(msgSender, _BITMASK_ADDRESS)
1638             // `msgSender == owner || msgSender == approvedAddress`.
1639             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1640         }
1641     }
1642 
1643     /**
1644      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1645      */
1646     function _getApprovedSlotAndAddress(uint256 tokenId)
1647         private
1648         view
1649         returns (uint256 approvedAddressSlot, address approvedAddress)
1650     {
1651         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1652         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1653         assembly {
1654             approvedAddressSlot := tokenApproval.slot
1655             approvedAddress := sload(approvedAddressSlot)
1656         }
1657     }
1658 
1659     // =============================================================
1660     //                      TRANSFER OPERATIONS
1661     // =============================================================
1662 
1663     /**
1664      * @dev Transfers `tokenId` from `from` to `to`.
1665      *
1666      * Requirements:
1667      *
1668      * - `from` cannot be the zero address.
1669      * - `to` cannot be the zero address.
1670      * - `tokenId` token must be owned by `from`.
1671      * - If the caller is not `from`, it must be approved to move this token
1672      * by either {approve} or {setApprovalForAll}.
1673      *
1674      * Emits a {Transfer} event.
1675      */
1676     function transferFrom(
1677         address from,
1678         address to,
1679         uint256 tokenId
1680     ) public payable virtual override {
1681         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1682 
1683         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1684         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
1685 
1686         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
1687 
1688         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1689 
1690         // The nested ifs save around 20+ gas over a compound boolean condition.
1691         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1692             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1693 
1694         _beforeTokenTransfers(from, to, tokenId, 1);
1695 
1696         // Clear approvals from the previous owner.
1697         assembly {
1698             if approvedAddress {
1699                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1700                 sstore(approvedAddressSlot, 0)
1701             }
1702         }
1703 
1704         // Underflow of the sender's balance is impossible because we check for
1705         // ownership above and the recipient's balance can't realistically overflow.
1706         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1707         unchecked {
1708             // We can directly increment and decrement the balances.
1709             --_packedAddressData[from]; // Updates: `balance -= 1`.
1710             ++_packedAddressData[to]; // Updates: `balance += 1`.
1711 
1712             // Updates:
1713             // - `address` to the next owner.
1714             // - `startTimestamp` to the timestamp of transfering.
1715             // - `burned` to `false`.
1716             // - `nextInitialized` to `true`.
1717             _packedOwnerships[tokenId] = _packOwnershipData(
1718                 to,
1719                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1720             );
1721 
1722             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1723             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1724                 uint256 nextTokenId = tokenId + 1;
1725                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1726                 if (_packedOwnerships[nextTokenId] == 0) {
1727                     // If the next slot is within bounds.
1728                     if (nextTokenId != _currentIndex) {
1729                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1730                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1731                     }
1732                 }
1733             }
1734         }
1735 
1736         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1737         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1738         assembly {
1739             // Emit the `Transfer` event.
1740             log4(
1741                 0, // Start of data (0, since no data).
1742                 0, // End of data (0, since no data).
1743                 _TRANSFER_EVENT_SIGNATURE, // Signature.
1744                 from, // `from`.
1745                 toMasked, // `to`.
1746                 tokenId // `tokenId`.
1747             )
1748         }
1749         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
1750 
1751         _afterTokenTransfers(from, to, tokenId, 1);
1752     }
1753 
1754     /**
1755      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1756      */
1757     function safeTransferFrom(
1758         address from,
1759         address to,
1760         uint256 tokenId
1761     ) public payable virtual override {
1762         safeTransferFrom(from, to, tokenId, '');
1763     }
1764 
1765     /**
1766      * @dev Safely transfers `tokenId` token from `from` to `to`.
1767      *
1768      * Requirements:
1769      *
1770      * - `from` cannot be the zero address.
1771      * - `to` cannot be the zero address.
1772      * - `tokenId` token must exist and be owned by `from`.
1773      * - If the caller is not `from`, it must be approved to move this token
1774      * by either {approve} or {setApprovalForAll}.
1775      * - If `to` refers to a smart contract, it must implement
1776      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1777      *
1778      * Emits a {Transfer} event.
1779      */
1780     function safeTransferFrom(
1781         address from,
1782         address to,
1783         uint256 tokenId,
1784         bytes memory _data
1785     ) public payable virtual override {
1786         transferFrom(from, to, tokenId);
1787         if (to.code.length != 0)
1788             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1789                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1790             }
1791     }
1792 
1793     /**
1794      * @dev Hook that is called before a set of serially-ordered token IDs
1795      * are about to be transferred. This includes minting.
1796      * And also called before burning one token.
1797      *
1798      * `startTokenId` - the first token ID to be transferred.
1799      * `quantity` - the amount to be transferred.
1800      *
1801      * Calling conditions:
1802      *
1803      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1804      * transferred to `to`.
1805      * - When `from` is zero, `tokenId` will be minted for `to`.
1806      * - When `to` is zero, `tokenId` will be burned by `from`.
1807      * - `from` and `to` are never both zero.
1808      */
1809     function _beforeTokenTransfers(
1810         address from,
1811         address to,
1812         uint256 startTokenId,
1813         uint256 quantity
1814     ) internal virtual {}
1815 
1816     /**
1817      * @dev Hook that is called after a set of serially-ordered token IDs
1818      * have been transferred. This includes minting.
1819      * And also called after one token has been burned.
1820      *
1821      * `startTokenId` - the first token ID to be transferred.
1822      * `quantity` - the amount to be transferred.
1823      *
1824      * Calling conditions:
1825      *
1826      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1827      * transferred to `to`.
1828      * - When `from` is zero, `tokenId` has been minted for `to`.
1829      * - When `to` is zero, `tokenId` has been burned by `from`.
1830      * - `from` and `to` are never both zero.
1831      */
1832     function _afterTokenTransfers(
1833         address from,
1834         address to,
1835         uint256 startTokenId,
1836         uint256 quantity
1837     ) internal virtual {}
1838 
1839     /**
1840      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1841      *
1842      * `from` - Previous owner of the given token ID.
1843      * `to` - Target address that will receive the token.
1844      * `tokenId` - Token ID to be transferred.
1845      * `_data` - Optional data to send along with the call.
1846      *
1847      * Returns whether the call correctly returned the expected magic value.
1848      */
1849     function _checkContractOnERC721Received(
1850         address from,
1851         address to,
1852         uint256 tokenId,
1853         bytes memory _data
1854     ) private returns (bool) {
1855         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1856             bytes4 retval
1857         ) {
1858             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1859         } catch (bytes memory reason) {
1860             if (reason.length == 0) {
1861                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1862             }
1863             assembly {
1864                 revert(add(32, reason), mload(reason))
1865             }
1866         }
1867     }
1868 
1869     // =============================================================
1870     //                        MINT OPERATIONS
1871     // =============================================================
1872 
1873     /**
1874      * @dev Mints `quantity` tokens and transfers them to `to`.
1875      *
1876      * Requirements:
1877      *
1878      * - `to` cannot be the zero address.
1879      * - `quantity` must be greater than 0.
1880      *
1881      * Emits a {Transfer} event for each mint.
1882      */
1883     function _mint(address to, uint256 quantity) internal virtual {
1884         uint256 startTokenId = _currentIndex;
1885         if (quantity == 0) _revert(MintZeroQuantity.selector);
1886 
1887         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1888 
1889         // Overflows are incredibly unrealistic.
1890         // `balance` and `numberMinted` have a maximum limit of 2**64.
1891         // `tokenId` has a maximum limit of 2**256.
1892         unchecked {
1893             // Updates:
1894             // - `address` to the owner.
1895             // - `startTimestamp` to the timestamp of minting.
1896             // - `burned` to `false`.
1897             // - `nextInitialized` to `quantity == 1`.
1898             _packedOwnerships[startTokenId] = _packOwnershipData(
1899                 to,
1900                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1901             );
1902 
1903             // Updates:
1904             // - `balance += quantity`.
1905             // - `numberMinted += quantity`.
1906             //
1907             // We can directly add to the `balance` and `numberMinted`.
1908             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1909 
1910             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1911             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1912 
1913             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1914 
1915             uint256 end = startTokenId + quantity;
1916             uint256 tokenId = startTokenId;
1917 
1918             do {
1919                 assembly {
1920                     // Emit the `Transfer` event.
1921                     log4(
1922                         0, // Start of data (0, since no data).
1923                         0, // End of data (0, since no data).
1924                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1925                         0, // `address(0)`.
1926                         toMasked, // `to`.
1927                         tokenId // `tokenId`.
1928                     )
1929                 }
1930                 // The `!=` check ensures that large values of `quantity`
1931                 // that overflows uint256 will make the loop run out of gas.
1932             } while (++tokenId != end);
1933 
1934             _currentIndex = end;
1935         }
1936         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1937     }
1938 
1939     /**
1940      * @dev Mints `quantity` tokens and transfers them to `to`.
1941      *
1942      * This function is intended for efficient minting only during contract creation.
1943      *
1944      * It emits only one {ConsecutiveTransfer} as defined in
1945      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1946      * instead of a sequence of {Transfer} event(s).
1947      *
1948      * Calling this function outside of contract creation WILL make your contract
1949      * non-compliant with the ERC721 standard.
1950      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1951      * {ConsecutiveTransfer} event is only permissible during contract creation.
1952      *
1953      * Requirements:
1954      *
1955      * - `to` cannot be the zero address.
1956      * - `quantity` must be greater than 0.
1957      *
1958      * Emits a {ConsecutiveTransfer} event.
1959      */
1960     function _mintERC2309(address to, uint256 quantity) internal virtual {
1961         uint256 startTokenId = _currentIndex;
1962         if (to == address(0)) _revert(MintToZeroAddress.selector);
1963         if (quantity == 0) _revert(MintZeroQuantity.selector);
1964         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
1965 
1966         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1967 
1968         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1969         unchecked {
1970             // Updates:
1971             // - `balance += quantity`.
1972             // - `numberMinted += quantity`.
1973             //
1974             // We can directly add to the `balance` and `numberMinted`.
1975             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1976 
1977             // Updates:
1978             // - `address` to the owner.
1979             // - `startTimestamp` to the timestamp of minting.
1980             // - `burned` to `false`.
1981             // - `nextInitialized` to `quantity == 1`.
1982             _packedOwnerships[startTokenId] = _packOwnershipData(
1983                 to,
1984                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1985             );
1986 
1987             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1988 
1989             _currentIndex = startTokenId + quantity;
1990         }
1991         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1992     }
1993 
1994     /**
1995      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1996      *
1997      * Requirements:
1998      *
1999      * - If `to` refers to a smart contract, it must implement
2000      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2001      * - `quantity` must be greater than 0.
2002      *
2003      * See {_mint}.
2004      *
2005      * Emits a {Transfer} event for each mint.
2006      */
2007     function _safeMint(
2008         address to,
2009         uint256 quantity,
2010         bytes memory _data
2011     ) internal virtual {
2012         _mint(to, quantity);
2013 
2014         unchecked {
2015             if (to.code.length != 0) {
2016                 uint256 end = _currentIndex;
2017                 uint256 index = end - quantity;
2018                 do {
2019                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2020                         _revert(TransferToNonERC721ReceiverImplementer.selector);
2021                     }
2022                 } while (index < end);
2023                 // Reentrancy protection.
2024                 if (_currentIndex != end) _revert(bytes4(0));
2025             }
2026         }
2027     }
2028 
2029     /**
2030      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2031      */
2032     function _safeMint(address to, uint256 quantity) internal virtual {
2033         _safeMint(to, quantity, '');
2034     }
2035 
2036     // =============================================================
2037     //                       APPROVAL OPERATIONS
2038     // =============================================================
2039 
2040     /**
2041      * @dev Equivalent to `_approve(to, tokenId, false)`.
2042      */
2043     function _approve(address to, uint256 tokenId) internal virtual {
2044         _approve(to, tokenId, false);
2045     }
2046 
2047     /**
2048      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2049      * The approval is cleared when the token is transferred.
2050      *
2051      * Only a single account can be approved at a time, so approving the
2052      * zero address clears previous approvals.
2053      *
2054      * Requirements:
2055      *
2056      * - `tokenId` must exist.
2057      *
2058      * Emits an {Approval} event.
2059      */
2060     function _approve(
2061         address to,
2062         uint256 tokenId,
2063         bool approvalCheck
2064     ) internal virtual {
2065         address owner = ownerOf(tokenId);
2066 
2067         if (approvalCheck && _msgSenderERC721A() != owner)
2068             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2069                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
2070             }
2071 
2072         _tokenApprovals[tokenId].value = to;
2073         emit Approval(owner, to, tokenId);
2074     }
2075 
2076     // =============================================================
2077     //                        BURN OPERATIONS
2078     // =============================================================
2079 
2080     /**
2081      * @dev Equivalent to `_burn(tokenId, false)`.
2082      */
2083     function _burn(uint256 tokenId) internal virtual {
2084         _burn(tokenId, false);
2085     }
2086 
2087     /**
2088      * @dev Destroys `tokenId`.
2089      * The approval is cleared when the token is burned.
2090      *
2091      * Requirements:
2092      *
2093      * - `tokenId` must exist.
2094      *
2095      * Emits a {Transfer} event.
2096      */
2097     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2098         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2099 
2100         address from = address(uint160(prevOwnershipPacked));
2101 
2102         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2103 
2104         if (approvalCheck) {
2105             // The nested ifs save around 20+ gas over a compound boolean condition.
2106             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2107                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2108         }
2109 
2110         _beforeTokenTransfers(from, address(0), tokenId, 1);
2111 
2112         // Clear approvals from the previous owner.
2113         assembly {
2114             if approvedAddress {
2115                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2116                 sstore(approvedAddressSlot, 0)
2117             }
2118         }
2119 
2120         // Underflow of the sender's balance is impossible because we check for
2121         // ownership above and the recipient's balance can't realistically overflow.
2122         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2123         unchecked {
2124             // Updates:
2125             // - `balance -= 1`.
2126             // - `numberBurned += 1`.
2127             //
2128             // We can directly decrement the balance, and increment the number burned.
2129             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2130             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2131 
2132             // Updates:
2133             // - `address` to the last owner.
2134             // - `startTimestamp` to the timestamp of burning.
2135             // - `burned` to `true`.
2136             // - `nextInitialized` to `true`.
2137             _packedOwnerships[tokenId] = _packOwnershipData(
2138                 from,
2139                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2140             );
2141 
2142             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2143             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2144                 uint256 nextTokenId = tokenId + 1;
2145                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2146                 if (_packedOwnerships[nextTokenId] == 0) {
2147                     // If the next slot is within bounds.
2148                     if (nextTokenId != _currentIndex) {
2149                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2150                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2151                     }
2152                 }
2153             }
2154         }
2155 
2156         emit Transfer(from, address(0), tokenId);
2157         _afterTokenTransfers(from, address(0), tokenId, 1);
2158 
2159         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2160         unchecked {
2161             _burnCounter++;
2162         }
2163     }
2164 
2165     // =============================================================
2166     //                     EXTRA DATA OPERATIONS
2167     // =============================================================
2168 
2169     /**
2170      * @dev Directly sets the extra data for the ownership data `index`.
2171      */
2172     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2173         uint256 packed = _packedOwnerships[index];
2174         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
2175         uint256 extraDataCasted;
2176         // Cast `extraData` with assembly to avoid redundant masking.
2177         assembly {
2178             extraDataCasted := extraData
2179         }
2180         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2181         _packedOwnerships[index] = packed;
2182     }
2183 
2184     /**
2185      * @dev Called during each token transfer to set the 24bit `extraData` field.
2186      * Intended to be overridden by the cosumer contract.
2187      *
2188      * `previousExtraData` - the value of `extraData` before transfer.
2189      *
2190      * Calling conditions:
2191      *
2192      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2193      * transferred to `to`.
2194      * - When `from` is zero, `tokenId` will be minted for `to`.
2195      * - When `to` is zero, `tokenId` will be burned by `from`.
2196      * - `from` and `to` are never both zero.
2197      */
2198     function _extraData(
2199         address from,
2200         address to,
2201         uint24 previousExtraData
2202     ) internal view virtual returns (uint24) {}
2203 
2204     /**
2205      * @dev Returns the next extra data for the packed ownership data.
2206      * The returned result is shifted into position.
2207      */
2208     function _nextExtraData(
2209         address from,
2210         address to,
2211         uint256 prevOwnershipPacked
2212     ) private view returns (uint256) {
2213         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2214         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2215     }
2216 
2217     // =============================================================
2218     //                       OTHER OPERATIONS
2219     // =============================================================
2220 
2221     /**
2222      * @dev Returns the message sender (defaults to `msg.sender`).
2223      *
2224      * If you are writing GSN compatible contracts, you need to override this function.
2225      */
2226     function _msgSenderERC721A() internal view virtual returns (address) {
2227         return msg.sender;
2228     }
2229 
2230     /**
2231      * @dev Converts a uint256 to its ASCII string decimal representation.
2232      */
2233     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2234         assembly {
2235             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2236             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2237             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2238             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2239             let m := add(mload(0x40), 0xa0)
2240             // Update the free memory pointer to allocate.
2241             mstore(0x40, m)
2242             // Assign the `str` to the end.
2243             str := sub(m, 0x20)
2244             // Zeroize the slot after the string.
2245             mstore(str, 0)
2246 
2247             // Cache the end of the memory to calculate the length later.
2248             let end := str
2249 
2250             // We write the string from rightmost digit to leftmost digit.
2251             // The following is essentially a do-while loop that also handles the zero case.
2252             // prettier-ignore
2253             for { let temp := value } 1 {} {
2254                 str := sub(str, 1)
2255                 // Write the character to the pointer.
2256                 // The ASCII index of the '0' character is 48.
2257                 mstore8(str, add(48, mod(temp, 10)))
2258                 // Keep dividing `temp` until zero.
2259                 temp := div(temp, 10)
2260                 // prettier-ignore
2261                 if iszero(temp) { break }
2262             }
2263 
2264             let length := sub(end, str)
2265             // Move the pointer 32 bytes leftwards to make room for the length.
2266             str := sub(str, 0x20)
2267             // Store the length.
2268             mstore(str, length)
2269         }
2270     }
2271 
2272     /**
2273      * @dev For more efficient reverts.
2274      */
2275     function _revert(bytes4 errorSelector) internal pure {
2276         assembly {
2277             mstore(0x00, errorSelector)
2278             revert(0x00, 0x04)
2279         }
2280     }
2281 }
2282 
2283 // File: contracts/Downtown.sol
2284 
2285 
2286 
2287 /**
2288   ___   _____      ___  _ _____ _____      ___  _ 
2289  |   \ / _ \ \    / / \| |_   _/ _ \ \    / / \| |
2290  | |) | (_) \ \/\/ /| .` | | || (_) \ \/\/ /| .` |
2291  |___/ \___/ \_/\_/ |_|\_| |_| \___/ \_/\_/ |_|\_|
2292   _                    _     _      _         
2293  | |__  _   _    /\  /(_) __| | ___| | _____  
2294  | '_ \| | | |  / /_/ / |/ _` |/ _ \ |/ / _ \ 
2295  | |_) | |_| | / __  /| | (_| |  __/   < (_) |
2296  |_.__/ \__, | \/ /_/ |_|\__,_|\___|_|\_\___/ 
2297         |___/                                    
2298 
2299 **/
2300 
2301 pragma solidity ^0.8.20;
2302 
2303 
2304 
2305 
2306 
2307 
2308 contract Downtown is ERC721A, ERC2981, Ownable {
2309    
2310     
2311 
2312     using Strings for uint256;
2313     uint256 public maxSupply = 2222;
2314     uint256 public maxFreeAmount = 888;
2315     uint256 public maxFreePerWallet = 2;
2316     uint256 public price = 0.0025 ether;
2317     uint256 public maxPerTx = 10;
2318     uint256 public maxPerWallet = 10;
2319     bool public mintEnabled = false;
2320     string public baseURI;
2321 
2322  constructor(
2323     uint96 _royaltyFeesInBips, 
2324     string memory _name,
2325     string memory _symbol,
2326     string memory _initBaseURI
2327   ) ERC721A(_name,_symbol) Ownable(msg.sender) {
2328         setBaseURI(_initBaseURI);
2329         setRoyaltyInfo(msg.sender, _royaltyFeesInBips);
2330     }
2331 
2332 function supportsInterface(
2333     bytes4 interfaceId
2334 ) public view virtual override(ERC721A, ERC2981) returns (bool) {
2335     // Supports the following `interfaceId`s:
2336     // - IERC165: 0x01ffc9a7
2337     // - IERC721: 0x80ac58cd
2338     // - IERC721Metadata: 0x5b5e139f
2339     // - IERC2981: 0x2a55205a
2340     return 
2341         ERC721A.supportsInterface(interfaceId) || 
2342         ERC2981.supportsInterface(interfaceId);
2343 }
2344     function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner
2345     {
2346         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
2347     }
2348 
2349 
2350   function  adminMint(uint256 _amountPerAddress, address[] calldata addresses) external onlyOwner {
2351      uint256 totalSupply = uint256(totalSupply());
2352      uint totalAmount =   _amountPerAddress * addresses.length;
2353     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
2354      for (uint256 i = 0; i < addresses.length; i++) {
2355             _safeMint(addresses[i], _amountPerAddress);
2356         }
2357 
2358      delete _amountPerAddress;
2359      delete totalSupply;
2360   }
2361         function _startTokenId() internal pure override returns (uint256) {
2362          return 1;
2363         }
2364     function  publicMint(uint256 quantity) external payable  {
2365         require(mintEnabled, "Minting is not live yet.");
2366         require(totalSupply() + quantity < maxSupply + 1, "No more");
2367         uint256 cost = price;
2368         uint256 _maxPerWallet = maxPerWallet;
2369         
2370 
2371         if (
2372             totalSupply() < maxFreeAmount &&
2373             _numberMinted(msg.sender) == 0 &&
2374             quantity <= maxFreePerWallet
2375         ) {
2376             cost = 0;
2377             _maxPerWallet = maxFreePerWallet;
2378         }
2379 
2380         require(
2381             _numberMinted(msg.sender) + quantity <= _maxPerWallet,
2382             "Max per wallet"
2383         );
2384 
2385         uint256 needPayCount = quantity;
2386         if (_numberMinted(msg.sender) == 0) {
2387             needPayCount = quantity - 1;
2388         }
2389         require(
2390             msg.value >= needPayCount * cost,
2391             "Please send the exact amount."
2392         );
2393         _safeMint(msg.sender, quantity);
2394     }
2395 
2396     function _baseURI() internal view virtual override returns (string memory) {
2397         return baseURI;
2398     }
2399 
2400     function tokenURI(
2401         uint256 tokenId
2402     ) public view virtual override returns (string memory) {
2403         require(
2404             _exists(tokenId),
2405             "ERC721Metadata: URI query for nonexistent token"
2406         );
2407         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2408     }
2409 
2410     function flipSale() external onlyOwner {
2411         mintEnabled = !mintEnabled;
2412     }
2413 
2414     function setBaseURI(string memory uri) public onlyOwner {
2415         baseURI = uri;
2416     }
2417 
2418     function setPrice(uint256 _newPrice) external onlyOwner {
2419         price = _newPrice;
2420     }
2421 
2422     function setMaxFreeAmount(uint256 _amount) external onlyOwner {
2423         maxFreeAmount = _amount;
2424     }
2425 
2426     function setMaxFreePerWallet(uint256 _amount) external onlyOwner {
2427         maxFreePerWallet = _amount;
2428     }
2429 
2430     function withdraw() external onlyOwner {
2431         (bool success, ) = payable(msg.sender).call{
2432             value: address(this).balance
2433         }("");
2434         require(success, "Transfer failed.");
2435     }
2436 }