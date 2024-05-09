1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
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
34 pragma solidity ^0.8.0;
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
48  *
49  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
50  */
51 abstract contract ERC165 is IERC165 {
52     /**
53      * @dev See {IERC165-supportsInterface}.
54      */
55     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
56         return interfaceId == type(IERC165).interfaceId;
57     }
58 }
59 
60 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC2981.sol
61 
62 
63 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 
68 /**
69  * @dev Interface for the NFT Royalty Standard.
70  *
71  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
72  * support for royalty payments across all NFT marketplaces and ecosystem participants.
73  *
74  * _Available since v4.5._
75  */
76 interface IERC2981 is IERC165 {
77     /**
78      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
79      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
80      */
81     function royaltyInfo(
82         uint256 tokenId,
83         uint256 salePrice
84     ) external view returns (address receiver, uint256 royaltyAmount);
85 }
86 
87 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/common/ERC2981.sol
88 
89 
90 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 
95 
96 /**
97  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
98  *
99  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
100  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
101  *
102  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
103  * fee is specified in basis points by default.
104  *
105  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
106  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
107  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
108  *
109  * _Available since v4.5._
110  */
111 abstract contract ERC2981 is IERC2981, ERC165 {
112     struct RoyaltyInfo {
113         address receiver;
114         uint96 royaltyFraction;
115     }
116 
117     RoyaltyInfo private _defaultRoyaltyInfo;
118     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
119 
120     /**
121      * @dev See {IERC165-supportsInterface}.
122      */
123     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
124         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
125     }
126 
127     /**
128      * @inheritdoc IERC2981
129      */
130     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
131         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
132 
133         if (royalty.receiver == address(0)) {
134             royalty = _defaultRoyaltyInfo;
135         }
136 
137         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
138 
139         return (royalty.receiver, royaltyAmount);
140     }
141 
142     /**
143      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
144      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
145      * override.
146      */
147     function _feeDenominator() internal pure virtual returns (uint96) {
148         return 10000;
149     }
150 
151     /**
152      * @dev Sets the royalty information that all ids in this contract will default to.
153      *
154      * Requirements:
155      *
156      * - `receiver` cannot be the zero address.
157      * - `feeNumerator` cannot be greater than the fee denominator.
158      */
159     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
160         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
161         require(receiver != address(0), "ERC2981: invalid receiver");
162 
163         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
164     }
165 
166     /**
167      * @dev Removes default royalty information.
168      */
169     function _deleteDefaultRoyalty() internal virtual {
170         delete _defaultRoyaltyInfo;
171     }
172 
173     /**
174      * @dev Sets the royalty information for a specific token id, overriding the global default.
175      *
176      * Requirements:
177      *
178      * - `receiver` cannot be the zero address.
179      * - `feeNumerator` cannot be greater than the fee denominator.
180      */
181     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
182         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
183         require(receiver != address(0), "ERC2981: Invalid parameters");
184 
185         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
186     }
187 
188     /**
189      * @dev Resets royalty information for the token id back to the global default.
190      */
191     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
192         delete _tokenRoyaltyInfo[tokenId];
193     }
194 }
195 
196 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SignedMath.sol
197 
198 
199 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
200 
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @dev Standard signed math utilities missing in the Solidity language.
205  */
206 library SignedMath {
207     /**
208      * @dev Returns the largest of two signed numbers.
209      */
210     function max(int256 a, int256 b) internal pure returns (int256) {
211         return a > b ? a : b;
212     }
213 
214     /**
215      * @dev Returns the smallest of two signed numbers.
216      */
217     function min(int256 a, int256 b) internal pure returns (int256) {
218         return a < b ? a : b;
219     }
220 
221     /**
222      * @dev Returns the average of two signed numbers without overflow.
223      * The result is rounded towards zero.
224      */
225     function average(int256 a, int256 b) internal pure returns (int256) {
226         // Formula from the book "Hacker's Delight"
227         int256 x = (a & b) + ((a ^ b) >> 1);
228         return x + (int256(uint256(x) >> 255) & (a ^ b));
229     }
230 
231     /**
232      * @dev Returns the absolute unsigned value of a signed value.
233      */
234     function abs(int256 n) internal pure returns (uint256) {
235         unchecked {
236             // must be unchecked in order to support `n = type(int256).min`
237             return uint256(n >= 0 ? n : -n);
238         }
239     }
240 }
241 
242 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
243 
244 
245 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Standard math utilities missing in the Solidity language.
251  */
252 library Math {
253     enum Rounding {
254         Down, // Toward negative infinity
255         Up, // Toward infinity
256         Zero // Toward zero
257     }
258 
259     /**
260      * @dev Returns the largest of two numbers.
261      */
262     function max(uint256 a, uint256 b) internal pure returns (uint256) {
263         return a > b ? a : b;
264     }
265 
266     /**
267      * @dev Returns the smallest of two numbers.
268      */
269     function min(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a < b ? a : b;
271     }
272 
273     /**
274      * @dev Returns the average of two numbers. The result is rounded towards
275      * zero.
276      */
277     function average(uint256 a, uint256 b) internal pure returns (uint256) {
278         // (a + b) / 2 can overflow.
279         return (a & b) + (a ^ b) / 2;
280     }
281 
282     /**
283      * @dev Returns the ceiling of the division of two numbers.
284      *
285      * This differs from standard division with `/` in that it rounds up instead
286      * of rounding down.
287      */
288     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
289         // (a + b - 1) / b can overflow on addition, so we distribute.
290         return a == 0 ? 0 : (a - 1) / b + 1;
291     }
292 
293     /**
294      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
295      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
296      * with further edits by Uniswap Labs also under MIT license.
297      */
298     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
299         unchecked {
300             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
301             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
302             // variables such that product = prod1 * 2^256 + prod0.
303             uint256 prod0; // Least significant 256 bits of the product
304             uint256 prod1; // Most significant 256 bits of the product
305             assembly {
306                 let mm := mulmod(x, y, not(0))
307                 prod0 := mul(x, y)
308                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
309             }
310 
311             // Handle non-overflow cases, 256 by 256 division.
312             if (prod1 == 0) {
313                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
314                 // The surrounding unchecked block does not change this fact.
315                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
316                 return prod0 / denominator;
317             }
318 
319             // Make sure the result is less than 2^256. Also prevents denominator == 0.
320             require(denominator > prod1, "Math: mulDiv overflow");
321 
322             ///////////////////////////////////////////////
323             // 512 by 256 division.
324             ///////////////////////////////////////////////
325 
326             // Make division exact by subtracting the remainder from [prod1 prod0].
327             uint256 remainder;
328             assembly {
329                 // Compute remainder using mulmod.
330                 remainder := mulmod(x, y, denominator)
331 
332                 // Subtract 256 bit number from 512 bit number.
333                 prod1 := sub(prod1, gt(remainder, prod0))
334                 prod0 := sub(prod0, remainder)
335             }
336 
337             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
338             // See https://cs.stackexchange.com/q/138556/92363.
339 
340             // Does not overflow because the denominator cannot be zero at this stage in the function.
341             uint256 twos = denominator & (~denominator + 1);
342             assembly {
343                 // Divide denominator by twos.
344                 denominator := div(denominator, twos)
345 
346                 // Divide [prod1 prod0] by twos.
347                 prod0 := div(prod0, twos)
348 
349                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
350                 twos := add(div(sub(0, twos), twos), 1)
351             }
352 
353             // Shift in bits from prod1 into prod0.
354             prod0 |= prod1 * twos;
355 
356             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
357             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
358             // four bits. That is, denominator * inv = 1 mod 2^4.
359             uint256 inverse = (3 * denominator) ^ 2;
360 
361             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
362             // in modular arithmetic, doubling the correct bits in each step.
363             inverse *= 2 - denominator * inverse; // inverse mod 2^8
364             inverse *= 2 - denominator * inverse; // inverse mod 2^16
365             inverse *= 2 - denominator * inverse; // inverse mod 2^32
366             inverse *= 2 - denominator * inverse; // inverse mod 2^64
367             inverse *= 2 - denominator * inverse; // inverse mod 2^128
368             inverse *= 2 - denominator * inverse; // inverse mod 2^256
369 
370             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
371             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
372             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
373             // is no longer required.
374             result = prod0 * inverse;
375             return result;
376         }
377     }
378 
379     /**
380      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
381      */
382     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
383         uint256 result = mulDiv(x, y, denominator);
384         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
385             result += 1;
386         }
387         return result;
388     }
389 
390     /**
391      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
392      *
393      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
394      */
395     function sqrt(uint256 a) internal pure returns (uint256) {
396         if (a == 0) {
397             return 0;
398         }
399 
400         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
401         //
402         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
403         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
404         //
405         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
406         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
407         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
408         //
409         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
410         uint256 result = 1 << (log2(a) >> 1);
411 
412         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
413         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
414         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
415         // into the expected uint128 result.
416         unchecked {
417             result = (result + a / result) >> 1;
418             result = (result + a / result) >> 1;
419             result = (result + a / result) >> 1;
420             result = (result + a / result) >> 1;
421             result = (result + a / result) >> 1;
422             result = (result + a / result) >> 1;
423             result = (result + a / result) >> 1;
424             return min(result, a / result);
425         }
426     }
427 
428     /**
429      * @notice Calculates sqrt(a), following the selected rounding direction.
430      */
431     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
432         unchecked {
433             uint256 result = sqrt(a);
434             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
435         }
436     }
437 
438     /**
439      * @dev Return the log in base 2, rounded down, of a positive value.
440      * Returns 0 if given 0.
441      */
442     function log2(uint256 value) internal pure returns (uint256) {
443         uint256 result = 0;
444         unchecked {
445             if (value >> 128 > 0) {
446                 value >>= 128;
447                 result += 128;
448             }
449             if (value >> 64 > 0) {
450                 value >>= 64;
451                 result += 64;
452             }
453             if (value >> 32 > 0) {
454                 value >>= 32;
455                 result += 32;
456             }
457             if (value >> 16 > 0) {
458                 value >>= 16;
459                 result += 16;
460             }
461             if (value >> 8 > 0) {
462                 value >>= 8;
463                 result += 8;
464             }
465             if (value >> 4 > 0) {
466                 value >>= 4;
467                 result += 4;
468             }
469             if (value >> 2 > 0) {
470                 value >>= 2;
471                 result += 2;
472             }
473             if (value >> 1 > 0) {
474                 result += 1;
475             }
476         }
477         return result;
478     }
479 
480     /**
481      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
482      * Returns 0 if given 0.
483      */
484     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
485         unchecked {
486             uint256 result = log2(value);
487             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
488         }
489     }
490 
491     /**
492      * @dev Return the log in base 10, rounded down, of a positive value.
493      * Returns 0 if given 0.
494      */
495     function log10(uint256 value) internal pure returns (uint256) {
496         uint256 result = 0;
497         unchecked {
498             if (value >= 10 ** 64) {
499                 value /= 10 ** 64;
500                 result += 64;
501             }
502             if (value >= 10 ** 32) {
503                 value /= 10 ** 32;
504                 result += 32;
505             }
506             if (value >= 10 ** 16) {
507                 value /= 10 ** 16;
508                 result += 16;
509             }
510             if (value >= 10 ** 8) {
511                 value /= 10 ** 8;
512                 result += 8;
513             }
514             if (value >= 10 ** 4) {
515                 value /= 10 ** 4;
516                 result += 4;
517             }
518             if (value >= 10 ** 2) {
519                 value /= 10 ** 2;
520                 result += 2;
521             }
522             if (value >= 10 ** 1) {
523                 result += 1;
524             }
525         }
526         return result;
527     }
528 
529     /**
530      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
531      * Returns 0 if given 0.
532      */
533     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
534         unchecked {
535             uint256 result = log10(value);
536             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
537         }
538     }
539 
540     /**
541      * @dev Return the log in base 256, rounded down, of a positive value.
542      * Returns 0 if given 0.
543      *
544      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
545      */
546     function log256(uint256 value) internal pure returns (uint256) {
547         uint256 result = 0;
548         unchecked {
549             if (value >> 128 > 0) {
550                 value >>= 128;
551                 result += 16;
552             }
553             if (value >> 64 > 0) {
554                 value >>= 64;
555                 result += 8;
556             }
557             if (value >> 32 > 0) {
558                 value >>= 32;
559                 result += 4;
560             }
561             if (value >> 16 > 0) {
562                 value >>= 16;
563                 result += 2;
564             }
565             if (value >> 8 > 0) {
566                 result += 1;
567             }
568         }
569         return result;
570     }
571 
572     /**
573      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
574      * Returns 0 if given 0.
575      */
576     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
577         unchecked {
578             uint256 result = log256(value);
579             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
580         }
581     }
582 }
583 
584 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
585 
586 
587 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 
593 /**
594  * @dev String operations.
595  */
596 library Strings {
597     bytes16 private constant _SYMBOLS = "0123456789abcdef";
598     uint8 private constant _ADDRESS_LENGTH = 20;
599 
600     /**
601      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
602      */
603     function toString(uint256 value) internal pure returns (string memory) {
604         unchecked {
605             uint256 length = Math.log10(value) + 1;
606             string memory buffer = new string(length);
607             uint256 ptr;
608             /// @solidity memory-safe-assembly
609             assembly {
610                 ptr := add(buffer, add(32, length))
611             }
612             while (true) {
613                 ptr--;
614                 /// @solidity memory-safe-assembly
615                 assembly {
616                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
617                 }
618                 value /= 10;
619                 if (value == 0) break;
620             }
621             return buffer;
622         }
623     }
624 
625     /**
626      * @dev Converts a `int256` to its ASCII `string` decimal representation.
627      */
628     function toString(int256 value) internal pure returns (string memory) {
629         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
630     }
631 
632     /**
633      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
634      */
635     function toHexString(uint256 value) internal pure returns (string memory) {
636         unchecked {
637             return toHexString(value, Math.log256(value) + 1);
638         }
639     }
640 
641     /**
642      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
643      */
644     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
645         bytes memory buffer = new bytes(2 * length + 2);
646         buffer[0] = "0";
647         buffer[1] = "x";
648         for (uint256 i = 2 * length + 1; i > 1; --i) {
649             buffer[i] = _SYMBOLS[value & 0xf];
650             value >>= 4;
651         }
652         require(value == 0, "Strings: hex length insufficient");
653         return string(buffer);
654     }
655 
656     /**
657      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
658      */
659     function toHexString(address addr) internal pure returns (string memory) {
660         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
661     }
662 
663     /**
664      * @dev Returns true if the two strings are equal.
665      */
666     function equal(string memory a, string memory b) internal pure returns (bool) {
667         return keccak256(bytes(a)) == keccak256(bytes(b));
668     }
669 }
670 
671 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @dev Provides information about the current execution context, including the
680  * sender of the transaction and its data. While these are generally available
681  * via msg.sender and msg.data, they should not be accessed in such a direct
682  * manner, since when dealing with meta-transactions the account sending and
683  * paying for execution may not be the actual sender (as far as an application
684  * is concerned).
685  *
686  * This contract is only required for intermediate, library-like contracts.
687  */
688 abstract contract Context {
689     function _msgSender() internal view virtual returns (address) {
690         return msg.sender;
691     }
692 
693     function _msgData() internal view virtual returns (bytes calldata) {
694         return msg.data;
695     }
696 }
697 
698 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
699 
700 
701 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @dev Contract module which provides a basic access control mechanism, where
708  * there is an account (an owner) that can be granted exclusive access to
709  * specific functions.
710  *
711  * By default, the owner account will be the one that deploys the contract. This
712  * can later be changed with {transferOwnership}.
713  *
714  * This module is used through inheritance. It will make available the modifier
715  * `onlyOwner`, which can be applied to your functions to restrict their use to
716  * the owner.
717  */
718 abstract contract Ownable is Context {
719     address private _owner;
720 
721     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
722 
723     /**
724      * @dev Initializes the contract setting the deployer as the initial owner.
725      */
726     constructor() {
727         _transferOwnership(_msgSender());
728     }
729 
730     /**
731      * @dev Throws if called by any account other than the owner.
732      */
733     modifier onlyOwner() {
734         _checkOwner();
735         _;
736     }
737 
738     /**
739      * @dev Returns the address of the current owner.
740      */
741     function owner() public view virtual returns (address) {
742         return _owner;
743     }
744 
745     /**
746      * @dev Throws if the sender is not the owner.
747      */
748     function _checkOwner() internal view virtual {
749         require(owner() == _msgSender(), "Ownable: caller is not the owner");
750     }
751 
752     /**
753      * @dev Leaves the contract without owner. It will not be possible to call
754      * `onlyOwner` functions. Can only be called by the current owner.
755      *
756      * NOTE: Renouncing ownership will leave the contract without an owner,
757      * thereby disabling any functionality that is only available to the owner.
758      */
759     function renounceOwnership() public virtual onlyOwner {
760         _transferOwnership(address(0));
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Can only be called by the current owner.
766      */
767     function transferOwnership(address newOwner) public virtual onlyOwner {
768         require(newOwner != address(0), "Ownable: new owner is the zero address");
769         _transferOwnership(newOwner);
770     }
771 
772     /**
773      * @dev Transfers ownership of the contract to a new account (`newOwner`).
774      * Internal function without access restriction.
775      */
776     function _transferOwnership(address newOwner) internal virtual {
777         address oldOwner = _owner;
778         _owner = newOwner;
779         emit OwnershipTransferred(oldOwner, newOwner);
780     }
781 }
782 
783 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
784 
785 
786 // ERC721A Contracts v4.2.3
787 // Creator: Chiru Labs
788 
789 pragma solidity ^0.8.4;
790 
791 /**
792  * @dev Interface of ERC721A.
793  */
794 interface IERC721A {
795     /**
796      * The caller must own the token or be an approved operator.
797      */
798     error ApprovalCallerNotOwnerNorApproved();
799 
800     /**
801      * The token does not exist.
802      */
803     error ApprovalQueryForNonexistentToken();
804 
805     /**
806      * Cannot query the balance for the zero address.
807      */
808     error BalanceQueryForZeroAddress();
809 
810     /**
811      * Cannot mint to the zero address.
812      */
813     error MintToZeroAddress();
814 
815     /**
816      * The quantity of tokens minted must be more than zero.
817      */
818     error MintZeroQuantity();
819 
820     /**
821      * The token does not exist.
822      */
823     error OwnerQueryForNonexistentToken();
824 
825     /**
826      * The caller must own the token or be an approved operator.
827      */
828     error TransferCallerNotOwnerNorApproved();
829 
830     /**
831      * The token must be owned by `from`.
832      */
833     error TransferFromIncorrectOwner();
834 
835     /**
836      * Cannot safely transfer to a contract that does not implement the
837      * ERC721Receiver interface.
838      */
839     error TransferToNonERC721ReceiverImplementer();
840 
841     /**
842      * Cannot transfer to the zero address.
843      */
844     error TransferToZeroAddress();
845 
846     /**
847      * The token does not exist.
848      */
849     error URIQueryForNonexistentToken();
850 
851     /**
852      * The `quantity` minted with ERC2309 exceeds the safety limit.
853      */
854     error MintERC2309QuantityExceedsLimit();
855 
856     /**
857      * The `extraData` cannot be set on an unintialized ownership slot.
858      */
859     error OwnershipNotInitializedForExtraData();
860 
861     // =============================================================
862     //                            STRUCTS
863     // =============================================================
864 
865     struct TokenOwnership {
866         // The address of the owner.
867         address addr;
868         // Stores the start time of ownership with minimal overhead for tokenomics.
869         uint64 startTimestamp;
870         // Whether the token has been burned.
871         bool burned;
872         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
873         uint24 extraData;
874     }
875 
876     // =============================================================
877     //                         TOKEN COUNTERS
878     // =============================================================
879 
880     /**
881      * @dev Returns the total number of tokens in existence.
882      * Burned tokens will reduce the count.
883      * To get the total number of tokens minted, please see {_totalMinted}.
884      */
885     function totalSupply() external view returns (uint256);
886 
887     // =============================================================
888     //                            IERC165
889     // =============================================================
890 
891     /**
892      * @dev Returns true if this contract implements the interface defined by
893      * `interfaceId`. See the corresponding
894      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
895      * to learn more about how these ids are created.
896      *
897      * This function call must use less than 30000 gas.
898      */
899     function supportsInterface(bytes4 interfaceId) external view returns (bool);
900 
901     // =============================================================
902     //                            IERC721
903     // =============================================================
904 
905     /**
906      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
907      */
908     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
909 
910     /**
911      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
912      */
913     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
914 
915     /**
916      * @dev Emitted when `owner` enables or disables
917      * (`approved`) `operator` to manage all of its assets.
918      */
919     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
920 
921     /**
922      * @dev Returns the number of tokens in `owner`'s account.
923      */
924     function balanceOf(address owner) external view returns (uint256 balance);
925 
926     /**
927      * @dev Returns the owner of the `tokenId` token.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must exist.
932      */
933     function ownerOf(uint256 tokenId) external view returns (address owner);
934 
935     /**
936      * @dev Safely transfers `tokenId` token from `from` to `to`,
937      * checking first that contract recipients are aware of the ERC721 protocol
938      * to prevent tokens from being forever locked.
939      *
940      * Requirements:
941      *
942      * - `from` cannot be the zero address.
943      * - `to` cannot be the zero address.
944      * - `tokenId` token must exist and be owned by `from`.
945      * - If the caller is not `from`, it must be have been allowed to move
946      * this token by either {approve} or {setApprovalForAll}.
947      * - If `to` refers to a smart contract, it must implement
948      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
949      *
950      * Emits a {Transfer} event.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes calldata data
957     ) external payable;
958 
959     /**
960      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
961      */
962     function safeTransferFrom(
963         address from,
964         address to,
965         uint256 tokenId
966     ) external payable;
967 
968     /**
969      * @dev Transfers `tokenId` from `from` to `to`.
970      *
971      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
972      * whenever possible.
973      *
974      * Requirements:
975      *
976      * - `from` cannot be the zero address.
977      * - `to` cannot be the zero address.
978      * - `tokenId` token must be owned by `from`.
979      * - If the caller is not `from`, it must be approved to move this token
980      * by either {approve} or {setApprovalForAll}.
981      *
982      * Emits a {Transfer} event.
983      */
984     function transferFrom(
985         address from,
986         address to,
987         uint256 tokenId
988     ) external payable;
989 
990     /**
991      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
992      * The approval is cleared when the token is transferred.
993      *
994      * Only a single account can be approved at a time, so approving the
995      * zero address clears previous approvals.
996      *
997      * Requirements:
998      *
999      * - The caller must own the token or be an approved operator.
1000      * - `tokenId` must exist.
1001      *
1002      * Emits an {Approval} event.
1003      */
1004     function approve(address to, uint256 tokenId) external payable;
1005 
1006     /**
1007      * @dev Approve or remove `operator` as an operator for the caller.
1008      * Operators can call {transferFrom} or {safeTransferFrom}
1009      * for any token owned by the caller.
1010      *
1011      * Requirements:
1012      *
1013      * - The `operator` cannot be the caller.
1014      *
1015      * Emits an {ApprovalForAll} event.
1016      */
1017     function setApprovalForAll(address operator, bool _approved) external;
1018 
1019     /**
1020      * @dev Returns the account approved for `tokenId` token.
1021      *
1022      * Requirements:
1023      *
1024      * - `tokenId` must exist.
1025      */
1026     function getApproved(uint256 tokenId) external view returns (address operator);
1027 
1028     /**
1029      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1030      *
1031      * See {setApprovalForAll}.
1032      */
1033     function isApprovedForAll(address owner, address operator) external view returns (bool);
1034 
1035     // =============================================================
1036     //                        IERC721Metadata
1037     // =============================================================
1038 
1039     /**
1040      * @dev Returns the token collection name.
1041      */
1042     function name() external view returns (string memory);
1043 
1044     /**
1045      * @dev Returns the token collection symbol.
1046      */
1047     function symbol() external view returns (string memory);
1048 
1049     /**
1050      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1051      */
1052     function tokenURI(uint256 tokenId) external view returns (string memory);
1053 
1054     // =============================================================
1055     //                           IERC2309
1056     // =============================================================
1057 
1058     /**
1059      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1060      * (inclusive) is transferred from `from` to `to`, as defined in the
1061      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1062      *
1063      * See {_mintERC2309} for more details.
1064      */
1065     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1066 }
1067 
1068 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
1069 
1070 
1071 // ERC721A Contracts v4.2.3
1072 // Creator: Chiru Labs
1073 
1074 pragma solidity ^0.8.4;
1075 
1076 
1077 /**
1078  * @dev Interface of ERC721 token receiver.
1079  */
1080 interface ERC721A__IERC721Receiver {
1081     function onERC721Received(
1082         address operator,
1083         address from,
1084         uint256 tokenId,
1085         bytes calldata data
1086     ) external returns (bytes4);
1087 }
1088 
1089 /**
1090  * @title ERC721A
1091  *
1092  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1093  * Non-Fungible Token Standard, including the Metadata extension.
1094  * Optimized for lower gas during batch mints.
1095  *
1096  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1097  * starting from `_startTokenId()`.
1098  *
1099  * Assumptions:
1100  *
1101  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1102  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1103  */
1104 contract ERC721A is IERC721A {
1105     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1106     struct TokenApprovalRef {
1107         address value;
1108     }
1109 
1110     // =============================================================
1111     //                           CONSTANTS
1112     // =============================================================
1113 
1114     // Mask of an entry in packed address data.
1115     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1116 
1117     // The bit position of `numberMinted` in packed address data.
1118     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1119 
1120     // The bit position of `numberBurned` in packed address data.
1121     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1122 
1123     // The bit position of `aux` in packed address data.
1124     uint256 private constant _BITPOS_AUX = 192;
1125 
1126     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1127     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1128 
1129     // The bit position of `startTimestamp` in packed ownership.
1130     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1131 
1132     // The bit mask of the `burned` bit in packed ownership.
1133     uint256 private constant _BITMASK_BURNED = 1 << 224;
1134 
1135     // The bit position of the `nextInitialized` bit in packed ownership.
1136     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1137 
1138     // The bit mask of the `nextInitialized` bit in packed ownership.
1139     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1140 
1141     // The bit position of `extraData` in packed ownership.
1142     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1143 
1144     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1145     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1146 
1147     // The mask of the lower 160 bits for addresses.
1148     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1149 
1150     // The maximum `quantity` that can be minted with {_mintERC2309}.
1151     // This limit is to prevent overflows on the address data entries.
1152     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1153     // is required to cause an overflow, which is unrealistic.
1154     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1155 
1156     // The `Transfer` event signature is given by:
1157     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1158     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1159         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1160 
1161     // =============================================================
1162     //                            STORAGE
1163     // =============================================================
1164 
1165     // The next token ID to be minted.
1166     uint256 private _currentIndex;
1167 
1168     // The number of tokens burned.
1169     uint256 private _burnCounter;
1170 
1171     // Token name
1172     string private _name;
1173 
1174     // Token symbol
1175     string private _symbol;
1176 
1177     // Mapping from token ID to ownership details
1178     // An empty struct value does not necessarily mean the token is unowned.
1179     // See {_packedOwnershipOf} implementation for details.
1180     //
1181     // Bits Layout:
1182     // - [0..159]   `addr`
1183     // - [160..223] `startTimestamp`
1184     // - [224]      `burned`
1185     // - [225]      `nextInitialized`
1186     // - [232..255] `extraData`
1187     mapping(uint256 => uint256) private _packedOwnerships;
1188 
1189     // Mapping owner address to address data.
1190     //
1191     // Bits Layout:
1192     // - [0..63]    `balance`
1193     // - [64..127]  `numberMinted`
1194     // - [128..191] `numberBurned`
1195     // - [192..255] `aux`
1196     mapping(address => uint256) private _packedAddressData;
1197 
1198     // Mapping from token ID to approved address.
1199     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1200 
1201     // Mapping from owner to operator approvals
1202     mapping(address => mapping(address => bool)) private _operatorApprovals;
1203 
1204     // =============================================================
1205     //                          CONSTRUCTOR
1206     // =============================================================
1207 
1208     constructor(string memory name_, string memory symbol_) {
1209         _name = name_;
1210         _symbol = symbol_;
1211         _currentIndex = _startTokenId();
1212     }
1213 
1214     // =============================================================
1215     //                   TOKEN COUNTING OPERATIONS
1216     // =============================================================
1217 
1218     /**
1219      * @dev Returns the starting token ID.
1220      * To change the starting token ID, please override this function.
1221      */
1222     function _startTokenId() internal view virtual returns (uint256) {
1223         return 0;
1224     }
1225 
1226     /**
1227      * @dev Returns the next token ID to be minted.
1228      */
1229     function _nextTokenId() internal view virtual returns (uint256) {
1230         return _currentIndex;
1231     }
1232 
1233     /**
1234      * @dev Returns the total number of tokens in existence.
1235      * Burned tokens will reduce the count.
1236      * To get the total number of tokens minted, please see {_totalMinted}.
1237      */
1238     function totalSupply() public view virtual override returns (uint256) {
1239         // Counter underflow is impossible as _burnCounter cannot be incremented
1240         // more than `_currentIndex - _startTokenId()` times.
1241         unchecked {
1242             return _currentIndex - _burnCounter - _startTokenId();
1243         }
1244     }
1245 
1246     /**
1247      * @dev Returns the total amount of tokens minted in the contract.
1248      */
1249     function _totalMinted() internal view virtual returns (uint256) {
1250         // Counter underflow is impossible as `_currentIndex` does not decrement,
1251         // and it is initialized to `_startTokenId()`.
1252         unchecked {
1253             return _currentIndex - _startTokenId();
1254         }
1255     }
1256 
1257     /**
1258      * @dev Returns the total number of tokens burned.
1259      */
1260     function _totalBurned() internal view virtual returns (uint256) {
1261         return _burnCounter;
1262     }
1263 
1264     // =============================================================
1265     //                    ADDRESS DATA OPERATIONS
1266     // =============================================================
1267 
1268     /**
1269      * @dev Returns the number of tokens in `owner`'s account.
1270      */
1271     function balanceOf(address owner) public view virtual override returns (uint256) {
1272         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
1273         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1274     }
1275 
1276     /**
1277      * Returns the number of tokens minted by `owner`.
1278      */
1279     function _numberMinted(address owner) internal view returns (uint256) {
1280         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1281     }
1282 
1283     /**
1284      * Returns the number of tokens burned by or on behalf of `owner`.
1285      */
1286     function _numberBurned(address owner) internal view returns (uint256) {
1287         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1288     }
1289 
1290     /**
1291      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1292      */
1293     function _getAux(address owner) internal view returns (uint64) {
1294         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1295     }
1296 
1297     /**
1298      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1299      * If there are multiple variables, please pack them into a uint64.
1300      */
1301     function _setAux(address owner, uint64 aux) internal virtual {
1302         uint256 packed = _packedAddressData[owner];
1303         uint256 auxCasted;
1304         // Cast `aux` with assembly to avoid redundant masking.
1305         assembly {
1306             auxCasted := aux
1307         }
1308         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1309         _packedAddressData[owner] = packed;
1310     }
1311 
1312     // =============================================================
1313     //                            IERC165
1314     // =============================================================
1315 
1316     /**
1317      * @dev Returns true if this contract implements the interface defined by
1318      * `interfaceId`. See the corresponding
1319      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1320      * to learn more about how these ids are created.
1321      *
1322      * This function call must use less than 30000 gas.
1323      */
1324     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1325         // The interface IDs are constants representing the first 4 bytes
1326         // of the XOR of all function selectors in the interface.
1327         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1328         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1329         return
1330             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1331             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1332             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1333     }
1334 
1335     // =============================================================
1336     //                        IERC721Metadata
1337     // =============================================================
1338 
1339     /**
1340      * @dev Returns the token collection name.
1341      */
1342     function name() public view virtual override returns (string memory) {
1343         return _name;
1344     }
1345 
1346     /**
1347      * @dev Returns the token collection symbol.
1348      */
1349     function symbol() public view virtual override returns (string memory) {
1350         return _symbol;
1351     }
1352 
1353     /**
1354      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1355      */
1356     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1357         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
1358 
1359         string memory baseURI = _baseURI();
1360         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1361     }
1362 
1363     /**
1364      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1365      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1366      * by default, it can be overridden in child contracts.
1367      */
1368     function _baseURI() internal view virtual returns (string memory) {
1369         return '';
1370     }
1371 
1372     // =============================================================
1373     //                     OWNERSHIPS OPERATIONS
1374     // =============================================================
1375 
1376     /**
1377      * @dev Returns the owner of the `tokenId` token.
1378      *
1379      * Requirements:
1380      *
1381      * - `tokenId` must exist.
1382      */
1383     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1384         return address(uint160(_packedOwnershipOf(tokenId)));
1385     }
1386 
1387     /**
1388      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1389      * It gradually moves to O(1) as tokens get transferred around over time.
1390      */
1391     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1392         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1393     }
1394 
1395     /**
1396      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1397      */
1398     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1399         return _unpackedOwnership(_packedOwnerships[index]);
1400     }
1401 
1402     /**
1403      * @dev Returns whether the ownership slot at `index` is initialized.
1404      * An uninitialized slot does not necessarily mean that the slot has no owner.
1405      */
1406     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
1407         return _packedOwnerships[index] != 0;
1408     }
1409 
1410     /**
1411      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1412      */
1413     function _initializeOwnershipAt(uint256 index) internal virtual {
1414         if (_packedOwnerships[index] == 0) {
1415             _packedOwnerships[index] = _packedOwnershipOf(index);
1416         }
1417     }
1418 
1419     /**
1420      * Returns the packed ownership data of `tokenId`.
1421      */
1422     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1423         if (_startTokenId() <= tokenId) {
1424             packed = _packedOwnerships[tokenId];
1425             // If the data at the starting slot does not exist, start the scan.
1426             if (packed == 0) {
1427                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
1428                 // Invariant:
1429                 // There will always be an initialized ownership slot
1430                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1431                 // before an unintialized ownership slot
1432                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1433                 // Hence, `tokenId` will not underflow.
1434                 //
1435                 // We can directly compare the packed value.
1436                 // If the address is zero, packed will be zero.
1437                 for (;;) {
1438                     unchecked {
1439                         packed = _packedOwnerships[--tokenId];
1440                     }
1441                     if (packed == 0) continue;
1442                     if (packed & _BITMASK_BURNED == 0) return packed;
1443                     // Otherwise, the token is burned, and we must revert.
1444                     // This handles the case of batch burned tokens, where only the burned bit
1445                     // of the starting slot is set, and remaining slots are left uninitialized.
1446                     _revert(OwnerQueryForNonexistentToken.selector);
1447                 }
1448             }
1449             // Otherwise, the data exists and we can skip the scan.
1450             // This is possible because we have already achieved the target condition.
1451             // This saves 2143 gas on transfers of initialized tokens.
1452             // If the token is not burned, return `packed`. Otherwise, revert.
1453             if (packed & _BITMASK_BURNED == 0) return packed;
1454         }
1455         _revert(OwnerQueryForNonexistentToken.selector);
1456     }
1457 
1458     /**
1459      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1460      */
1461     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1462         ownership.addr = address(uint160(packed));
1463         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1464         ownership.burned = packed & _BITMASK_BURNED != 0;
1465         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1466     }
1467 
1468     /**
1469      * @dev Packs ownership data into a single uint256.
1470      */
1471     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1472         assembly {
1473             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1474             owner := and(owner, _BITMASK_ADDRESS)
1475             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1476             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1477         }
1478     }
1479 
1480     /**
1481      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1482      */
1483     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1484         // For branchless setting of the `nextInitialized` flag.
1485         assembly {
1486             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1487             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1488         }
1489     }
1490 
1491     // =============================================================
1492     //                      APPROVAL OPERATIONS
1493     // =============================================================
1494 
1495     /**
1496      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1497      *
1498      * Requirements:
1499      *
1500      * - The caller must own the token or be an approved operator.
1501      */
1502     function approve(address to, uint256 tokenId) public payable virtual override {
1503         _approve(to, tokenId, true);
1504     }
1505 
1506     /**
1507      * @dev Returns the account approved for `tokenId` token.
1508      *
1509      * Requirements:
1510      *
1511      * - `tokenId` must exist.
1512      */
1513     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1514         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
1515 
1516         return _tokenApprovals[tokenId].value;
1517     }
1518 
1519     /**
1520      * @dev Approve or remove `operator` as an operator for the caller.
1521      * Operators can call {transferFrom} or {safeTransferFrom}
1522      * for any token owned by the caller.
1523      *
1524      * Requirements:
1525      *
1526      * - The `operator` cannot be the caller.
1527      *
1528      * Emits an {ApprovalForAll} event.
1529      */
1530     function setApprovalForAll(address operator, bool approved) public virtual override {
1531         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1532         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1533     }
1534 
1535     /**
1536      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1537      *
1538      * See {setApprovalForAll}.
1539      */
1540     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1541         return _operatorApprovals[owner][operator];
1542     }
1543 
1544     /**
1545      * @dev Returns whether `tokenId` exists.
1546      *
1547      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1548      *
1549      * Tokens start existing when they are minted. See {_mint}.
1550      */
1551     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
1552         if (_startTokenId() <= tokenId) {
1553             if (tokenId < _currentIndex) {
1554                 uint256 packed;
1555                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
1556                 result = packed & _BITMASK_BURNED == 0;
1557             }
1558         }
1559     }
1560 
1561     /**
1562      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1563      */
1564     function _isSenderApprovedOrOwner(
1565         address approvedAddress,
1566         address owner,
1567         address msgSender
1568     ) private pure returns (bool result) {
1569         assembly {
1570             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1571             owner := and(owner, _BITMASK_ADDRESS)
1572             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1573             msgSender := and(msgSender, _BITMASK_ADDRESS)
1574             // `msgSender == owner || msgSender == approvedAddress`.
1575             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1576         }
1577     }
1578 
1579     /**
1580      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1581      */
1582     function _getApprovedSlotAndAddress(uint256 tokenId)
1583         private
1584         view
1585         returns (uint256 approvedAddressSlot, address approvedAddress)
1586     {
1587         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1588         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1589         assembly {
1590             approvedAddressSlot := tokenApproval.slot
1591             approvedAddress := sload(approvedAddressSlot)
1592         }
1593     }
1594 
1595     // =============================================================
1596     //                      TRANSFER OPERATIONS
1597     // =============================================================
1598 
1599     /**
1600      * @dev Transfers `tokenId` from `from` to `to`.
1601      *
1602      * Requirements:
1603      *
1604      * - `from` cannot be the zero address.
1605      * - `to` cannot be the zero address.
1606      * - `tokenId` token must be owned by `from`.
1607      * - If the caller is not `from`, it must be approved to move this token
1608      * by either {approve} or {setApprovalForAll}.
1609      *
1610      * Emits a {Transfer} event.
1611      */
1612     function transferFrom(
1613         address from,
1614         address to,
1615         uint256 tokenId
1616     ) public payable virtual override {
1617         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1618 
1619         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1620         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
1621 
1622         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
1623 
1624         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1625 
1626         // The nested ifs save around 20+ gas over a compound boolean condition.
1627         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1628             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1629 
1630         _beforeTokenTransfers(from, to, tokenId, 1);
1631 
1632         // Clear approvals from the previous owner.
1633         assembly {
1634             if approvedAddress {
1635                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1636                 sstore(approvedAddressSlot, 0)
1637             }
1638         }
1639 
1640         // Underflow of the sender's balance is impossible because we check for
1641         // ownership above and the recipient's balance can't realistically overflow.
1642         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1643         unchecked {
1644             // We can directly increment and decrement the balances.
1645             --_packedAddressData[from]; // Updates: `balance -= 1`.
1646             ++_packedAddressData[to]; // Updates: `balance += 1`.
1647 
1648             // Updates:
1649             // - `address` to the next owner.
1650             // - `startTimestamp` to the timestamp of transfering.
1651             // - `burned` to `false`.
1652             // - `nextInitialized` to `true`.
1653             _packedOwnerships[tokenId] = _packOwnershipData(
1654                 to,
1655                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1656             );
1657 
1658             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1659             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1660                 uint256 nextTokenId = tokenId + 1;
1661                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1662                 if (_packedOwnerships[nextTokenId] == 0) {
1663                     // If the next slot is within bounds.
1664                     if (nextTokenId != _currentIndex) {
1665                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1666                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1667                     }
1668                 }
1669             }
1670         }
1671 
1672         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1673         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1674         assembly {
1675             // Emit the `Transfer` event.
1676             log4(
1677                 0, // Start of data (0, since no data).
1678                 0, // End of data (0, since no data).
1679                 _TRANSFER_EVENT_SIGNATURE, // Signature.
1680                 from, // `from`.
1681                 toMasked, // `to`.
1682                 tokenId // `tokenId`.
1683             )
1684         }
1685         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
1686 
1687         _afterTokenTransfers(from, to, tokenId, 1);
1688     }
1689 
1690     /**
1691      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1692      */
1693     function safeTransferFrom(
1694         address from,
1695         address to,
1696         uint256 tokenId
1697     ) public payable virtual override {
1698         safeTransferFrom(from, to, tokenId, '');
1699     }
1700 
1701     /**
1702      * @dev Safely transfers `tokenId` token from `from` to `to`.
1703      *
1704      * Requirements:
1705      *
1706      * - `from` cannot be the zero address.
1707      * - `to` cannot be the zero address.
1708      * - `tokenId` token must exist and be owned by `from`.
1709      * - If the caller is not `from`, it must be approved to move this token
1710      * by either {approve} or {setApprovalForAll}.
1711      * - If `to` refers to a smart contract, it must implement
1712      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1713      *
1714      * Emits a {Transfer} event.
1715      */
1716     function safeTransferFrom(
1717         address from,
1718         address to,
1719         uint256 tokenId,
1720         bytes memory _data
1721     ) public payable virtual override {
1722         transferFrom(from, to, tokenId);
1723         if (to.code.length != 0)
1724             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1725                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1726             }
1727     }
1728 
1729     /**
1730      * @dev Hook that is called before a set of serially-ordered token IDs
1731      * are about to be transferred. This includes minting.
1732      * And also called before burning one token.
1733      *
1734      * `startTokenId` - the first token ID to be transferred.
1735      * `quantity` - the amount to be transferred.
1736      *
1737      * Calling conditions:
1738      *
1739      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1740      * transferred to `to`.
1741      * - When `from` is zero, `tokenId` will be minted for `to`.
1742      * - When `to` is zero, `tokenId` will be burned by `from`.
1743      * - `from` and `to` are never both zero.
1744      */
1745     function _beforeTokenTransfers(
1746         address from,
1747         address to,
1748         uint256 startTokenId,
1749         uint256 quantity
1750     ) internal virtual {}
1751 
1752     /**
1753      * @dev Hook that is called after a set of serially-ordered token IDs
1754      * have been transferred. This includes minting.
1755      * And also called after one token has been burned.
1756      *
1757      * `startTokenId` - the first token ID to be transferred.
1758      * `quantity` - the amount to be transferred.
1759      *
1760      * Calling conditions:
1761      *
1762      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1763      * transferred to `to`.
1764      * - When `from` is zero, `tokenId` has been minted for `to`.
1765      * - When `to` is zero, `tokenId` has been burned by `from`.
1766      * - `from` and `to` are never both zero.
1767      */
1768     function _afterTokenTransfers(
1769         address from,
1770         address to,
1771         uint256 startTokenId,
1772         uint256 quantity
1773     ) internal virtual {}
1774 
1775     /**
1776      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1777      *
1778      * `from` - Previous owner of the given token ID.
1779      * `to` - Target address that will receive the token.
1780      * `tokenId` - Token ID to be transferred.
1781      * `_data` - Optional data to send along with the call.
1782      *
1783      * Returns whether the call correctly returned the expected magic value.
1784      */
1785     function _checkContractOnERC721Received(
1786         address from,
1787         address to,
1788         uint256 tokenId,
1789         bytes memory _data
1790     ) private returns (bool) {
1791         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1792             bytes4 retval
1793         ) {
1794             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1795         } catch (bytes memory reason) {
1796             if (reason.length == 0) {
1797                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1798             }
1799             assembly {
1800                 revert(add(32, reason), mload(reason))
1801             }
1802         }
1803     }
1804 
1805     // =============================================================
1806     //                        MINT OPERATIONS
1807     // =============================================================
1808 
1809     /**
1810      * @dev Mints `quantity` tokens and transfers them to `to`.
1811      *
1812      * Requirements:
1813      *
1814      * - `to` cannot be the zero address.
1815      * - `quantity` must be greater than 0.
1816      *
1817      * Emits a {Transfer} event for each mint.
1818      */
1819     function _mint(address to, uint256 quantity) internal virtual {
1820         uint256 startTokenId = _currentIndex;
1821         if (quantity == 0) _revert(MintZeroQuantity.selector);
1822 
1823         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1824 
1825         // Overflows are incredibly unrealistic.
1826         // `balance` and `numberMinted` have a maximum limit of 2**64.
1827         // `tokenId` has a maximum limit of 2**256.
1828         unchecked {
1829             // Updates:
1830             // - `address` to the owner.
1831             // - `startTimestamp` to the timestamp of minting.
1832             // - `burned` to `false`.
1833             // - `nextInitialized` to `quantity == 1`.
1834             _packedOwnerships[startTokenId] = _packOwnershipData(
1835                 to,
1836                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1837             );
1838 
1839             // Updates:
1840             // - `balance += quantity`.
1841             // - `numberMinted += quantity`.
1842             //
1843             // We can directly add to the `balance` and `numberMinted`.
1844             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1845 
1846             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1847             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1848 
1849             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1850 
1851             uint256 end = startTokenId + quantity;
1852             uint256 tokenId = startTokenId;
1853 
1854             do {
1855                 assembly {
1856                     // Emit the `Transfer` event.
1857                     log4(
1858                         0, // Start of data (0, since no data).
1859                         0, // End of data (0, since no data).
1860                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1861                         0, // `address(0)`.
1862                         toMasked, // `to`.
1863                         tokenId // `tokenId`.
1864                     )
1865                 }
1866                 // The `!=` check ensures that large values of `quantity`
1867                 // that overflows uint256 will make the loop run out of gas.
1868             } while (++tokenId != end);
1869 
1870             _currentIndex = end;
1871         }
1872         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1873     }
1874 
1875     /**
1876      * @dev Mints `quantity` tokens and transfers them to `to`.
1877      *
1878      * This function is intended for efficient minting only during contract creation.
1879      *
1880      * It emits only one {ConsecutiveTransfer} as defined in
1881      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1882      * instead of a sequence of {Transfer} event(s).
1883      *
1884      * Calling this function outside of contract creation WILL make your contract
1885      * non-compliant with the ERC721 standard.
1886      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1887      * {ConsecutiveTransfer} event is only permissible during contract creation.
1888      *
1889      * Requirements:
1890      *
1891      * - `to` cannot be the zero address.
1892      * - `quantity` must be greater than 0.
1893      *
1894      * Emits a {ConsecutiveTransfer} event.
1895      */
1896     function _mintERC2309(address to, uint256 quantity) internal virtual {
1897         uint256 startTokenId = _currentIndex;
1898         if (to == address(0)) _revert(MintToZeroAddress.selector);
1899         if (quantity == 0) _revert(MintZeroQuantity.selector);
1900         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
1901 
1902         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1903 
1904         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1905         unchecked {
1906             // Updates:
1907             // - `balance += quantity`.
1908             // - `numberMinted += quantity`.
1909             //
1910             // We can directly add to the `balance` and `numberMinted`.
1911             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1912 
1913             // Updates:
1914             // - `address` to the owner.
1915             // - `startTimestamp` to the timestamp of minting.
1916             // - `burned` to `false`.
1917             // - `nextInitialized` to `quantity == 1`.
1918             _packedOwnerships[startTokenId] = _packOwnershipData(
1919                 to,
1920                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1921             );
1922 
1923             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1924 
1925             _currentIndex = startTokenId + quantity;
1926         }
1927         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1928     }
1929 
1930     /**
1931      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1932      *
1933      * Requirements:
1934      *
1935      * - If `to` refers to a smart contract, it must implement
1936      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1937      * - `quantity` must be greater than 0.
1938      *
1939      * See {_mint}.
1940      *
1941      * Emits a {Transfer} event for each mint.
1942      */
1943     function _safeMint(
1944         address to,
1945         uint256 quantity,
1946         bytes memory _data
1947     ) internal virtual {
1948         _mint(to, quantity);
1949 
1950         unchecked {
1951             if (to.code.length != 0) {
1952                 uint256 end = _currentIndex;
1953                 uint256 index = end - quantity;
1954                 do {
1955                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1956                         _revert(TransferToNonERC721ReceiverImplementer.selector);
1957                     }
1958                 } while (index < end);
1959                 // Reentrancy protection.
1960                 if (_currentIndex != end) _revert(bytes4(0));
1961             }
1962         }
1963     }
1964 
1965     /**
1966      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1967      */
1968     function _safeMint(address to, uint256 quantity) internal virtual {
1969         _safeMint(to, quantity, '');
1970     }
1971 
1972     // =============================================================
1973     //                       APPROVAL OPERATIONS
1974     // =============================================================
1975 
1976     /**
1977      * @dev Equivalent to `_approve(to, tokenId, false)`.
1978      */
1979     function _approve(address to, uint256 tokenId) internal virtual {
1980         _approve(to, tokenId, false);
1981     }
1982 
1983     /**
1984      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1985      * The approval is cleared when the token is transferred.
1986      *
1987      * Only a single account can be approved at a time, so approving the
1988      * zero address clears previous approvals.
1989      *
1990      * Requirements:
1991      *
1992      * - `tokenId` must exist.
1993      *
1994      * Emits an {Approval} event.
1995      */
1996     function _approve(
1997         address to,
1998         uint256 tokenId,
1999         bool approvalCheck
2000     ) internal virtual {
2001         address owner = ownerOf(tokenId);
2002 
2003         if (approvalCheck && _msgSenderERC721A() != owner)
2004             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2005                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
2006             }
2007 
2008         _tokenApprovals[tokenId].value = to;
2009         emit Approval(owner, to, tokenId);
2010     }
2011 
2012     // =============================================================
2013     //                        BURN OPERATIONS
2014     // =============================================================
2015 
2016     /**
2017      * @dev Equivalent to `_burn(tokenId, false)`.
2018      */
2019     function _burn(uint256 tokenId) internal virtual {
2020         _burn(tokenId, false);
2021     }
2022 
2023     /**
2024      * @dev Destroys `tokenId`.
2025      * The approval is cleared when the token is burned.
2026      *
2027      * Requirements:
2028      *
2029      * - `tokenId` must exist.
2030      *
2031      * Emits a {Transfer} event.
2032      */
2033     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2034         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2035 
2036         address from = address(uint160(prevOwnershipPacked));
2037 
2038         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2039 
2040         if (approvalCheck) {
2041             // The nested ifs save around 20+ gas over a compound boolean condition.
2042             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2043                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2044         }
2045 
2046         _beforeTokenTransfers(from, address(0), tokenId, 1);
2047 
2048         // Clear approvals from the previous owner.
2049         assembly {
2050             if approvedAddress {
2051                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2052                 sstore(approvedAddressSlot, 0)
2053             }
2054         }
2055 
2056         // Underflow of the sender's balance is impossible because we check for
2057         // ownership above and the recipient's balance can't realistically overflow.
2058         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2059         unchecked {
2060             // Updates:
2061             // - `balance -= 1`.
2062             // - `numberBurned += 1`.
2063             //
2064             // We can directly decrement the balance, and increment the number burned.
2065             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2066             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2067 
2068             // Updates:
2069             // - `address` to the last owner.
2070             // - `startTimestamp` to the timestamp of burning.
2071             // - `burned` to `true`.
2072             // - `nextInitialized` to `true`.
2073             _packedOwnerships[tokenId] = _packOwnershipData(
2074                 from,
2075                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2076             );
2077 
2078             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2079             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2080                 uint256 nextTokenId = tokenId + 1;
2081                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2082                 if (_packedOwnerships[nextTokenId] == 0) {
2083                     // If the next slot is within bounds.
2084                     if (nextTokenId != _currentIndex) {
2085                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2086                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2087                     }
2088                 }
2089             }
2090         }
2091 
2092         emit Transfer(from, address(0), tokenId);
2093         _afterTokenTransfers(from, address(0), tokenId, 1);
2094 
2095         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2096         unchecked {
2097             _burnCounter++;
2098         }
2099     }
2100 
2101     // =============================================================
2102     //                     EXTRA DATA OPERATIONS
2103     // =============================================================
2104 
2105     /**
2106      * @dev Directly sets the extra data for the ownership data `index`.
2107      */
2108     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2109         uint256 packed = _packedOwnerships[index];
2110         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
2111         uint256 extraDataCasted;
2112         // Cast `extraData` with assembly to avoid redundant masking.
2113         assembly {
2114             extraDataCasted := extraData
2115         }
2116         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2117         _packedOwnerships[index] = packed;
2118     }
2119 
2120     /**
2121      * @dev Called during each token transfer to set the 24bit `extraData` field.
2122      * Intended to be overridden by the cosumer contract.
2123      *
2124      * `previousExtraData` - the value of `extraData` before transfer.
2125      *
2126      * Calling conditions:
2127      *
2128      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2129      * transferred to `to`.
2130      * - When `from` is zero, `tokenId` will be minted for `to`.
2131      * - When `to` is zero, `tokenId` will be burned by `from`.
2132      * - `from` and `to` are never both zero.
2133      */
2134     function _extraData(
2135         address from,
2136         address to,
2137         uint24 previousExtraData
2138     ) internal view virtual returns (uint24) {}
2139 
2140     /**
2141      * @dev Returns the next extra data for the packed ownership data.
2142      * The returned result is shifted into position.
2143      */
2144     function _nextExtraData(
2145         address from,
2146         address to,
2147         uint256 prevOwnershipPacked
2148     ) private view returns (uint256) {
2149         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2150         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2151     }
2152 
2153     // =============================================================
2154     //                       OTHER OPERATIONS
2155     // =============================================================
2156 
2157     /**
2158      * @dev Returns the message sender (defaults to `msg.sender`).
2159      *
2160      * If you are writing GSN compatible contracts, you need to override this function.
2161      */
2162     function _msgSenderERC721A() internal view virtual returns (address) {
2163         return msg.sender;
2164     }
2165 
2166     /**
2167      * @dev Converts a uint256 to its ASCII string decimal representation.
2168      */
2169     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2170         assembly {
2171             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2172             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2173             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2174             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2175             let m := add(mload(0x40), 0xa0)
2176             // Update the free memory pointer to allocate.
2177             mstore(0x40, m)
2178             // Assign the `str` to the end.
2179             str := sub(m, 0x20)
2180             // Zeroize the slot after the string.
2181             mstore(str, 0)
2182 
2183             // Cache the end of the memory to calculate the length later.
2184             let end := str
2185 
2186             // We write the string from rightmost digit to leftmost digit.
2187             // The following is essentially a do-while loop that also handles the zero case.
2188             // prettier-ignore
2189             for { let temp := value } 1 {} {
2190                 str := sub(str, 1)
2191                 // Write the character to the pointer.
2192                 // The ASCII index of the '0' character is 48.
2193                 mstore8(str, add(48, mod(temp, 10)))
2194                 // Keep dividing `temp` until zero.
2195                 temp := div(temp, 10)
2196                 // prettier-ignore
2197                 if iszero(temp) { break }
2198             }
2199 
2200             let length := sub(end, str)
2201             // Move the pointer 32 bytes leftwards to make room for the length.
2202             str := sub(str, 0x20)
2203             // Store the length.
2204             mstore(str, length)
2205         }
2206     }
2207 
2208     /**
2209      * @dev For more efficient reverts.
2210      */
2211     function _revert(bytes4 errorSelector) internal pure {
2212         assembly {
2213             mstore(0x00, errorSelector)
2214             revert(0x00, 0x04)
2215         }
2216     }
2217 }
2218 
2219 // File: Gemewiz.sol
2220 
2221 
2222 pragma solidity ^0.8.17;
2223 
2224 
2225 
2226 
2227 
2228 
2229 contract Gemewiz is ERC721A, ERC2981, Ownable {
2230    
2231     
2232 
2233     using Strings for uint256;
2234     uint256 public maxSupply = 1888;
2235     uint256 public maxFreeAmount = 1888;
2236     uint256 public maxFreePerWallet = 2;
2237     uint256 public price = 0.002 ether;
2238     uint256 public maxPerTx = 20;
2239     uint256 public maxPerWallet = 40;
2240     bool public mintEnabled = false;
2241     string public baseURI;
2242 
2243  constructor(uint96 _royaltyFeesInBips, 
2244     string memory _name,
2245     string memory _symbol,
2246     string memory _initBaseURI
2247   ) ERC721A(_name,_symbol) {
2248         setBaseURI(_initBaseURI);
2249         setRoyaltyInfo(msg.sender, _royaltyFeesInBips);
2250      
2251     }
2252 
2253 function supportsInterface(
2254     bytes4 interfaceId
2255 ) public view virtual override(ERC721A, ERC2981) returns (bool) {
2256     // Supports the following `interfaceId`s:
2257     // - IERC165: 0x01ffc9a7
2258     // - IERC721: 0x80ac58cd
2259     // - IERC721Metadata: 0x5b5e139f
2260     // - IERC2981: 0x2a55205a
2261     return 
2262         ERC721A.supportsInterface(interfaceId) || 
2263         ERC2981.supportsInterface(interfaceId);
2264 }
2265     function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner
2266     {
2267         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
2268     }
2269 
2270 
2271   function  Airdrop(uint256 _amountPerAddress, address[] calldata addresses) external onlyOwner {
2272      uint256 totalSupply = uint256(totalSupply());
2273      uint totalAmount =   _amountPerAddress * addresses.length;
2274     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
2275      for (uint256 i = 0; i < addresses.length; i++) {
2276             _safeMint(addresses[i], _amountPerAddress);
2277         }
2278 
2279      delete _amountPerAddress;
2280      delete totalSupply;
2281   }
2282         function _startTokenId() internal pure override returns (uint256) {
2283          return 1;
2284         }
2285     function  publicMint(uint256 quantity) external payable  {
2286         require(mintEnabled, "Minting is not live yet.");
2287         require(totalSupply() + quantity < maxSupply + 1, "No more");
2288         uint256 cost = price;
2289         uint256 _maxPerWallet = maxPerWallet;
2290         
2291 
2292         if (
2293             totalSupply() < maxFreeAmount &&
2294             _numberMinted(msg.sender) == 0 &&
2295             quantity <= maxFreePerWallet
2296         ) {
2297             cost = 0;
2298             _maxPerWallet = maxFreePerWallet;
2299         }
2300 
2301         require(
2302             _numberMinted(msg.sender) + quantity <= _maxPerWallet,
2303             "Max per wallet"
2304         );
2305 
2306         uint256 needPayCount = quantity;
2307         if (_numberMinted(msg.sender) == 0) {
2308             needPayCount = quantity;
2309         }
2310         require(
2311             msg.value >= needPayCount * cost,
2312             "Please send the exact amount."
2313         );
2314         _safeMint(msg.sender, quantity);
2315     }
2316 
2317     function _baseURI() internal view virtual override returns (string memory) {
2318         return baseURI;
2319     }
2320 
2321     function tokenURI(
2322         uint256 tokenId
2323     ) public view virtual override returns (string memory) {
2324         require(
2325             _exists(tokenId),
2326             "ERC721Metadata: URI query for nonexistent token"
2327         );
2328         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2329     }
2330 
2331     function flipSale() external onlyOwner {
2332         mintEnabled = !mintEnabled;
2333     }
2334 
2335     function setBaseURI(string memory uri) public onlyOwner {
2336         baseURI = uri;
2337     }
2338 
2339     function setPrice(uint256 _newPrice) external onlyOwner {
2340         price = _newPrice;
2341     }
2342 
2343     function setMaxFreeAmount(uint256 _amount) external onlyOwner {
2344         maxFreeAmount = _amount;
2345     }
2346 
2347     function setMaxFreePerWallet(uint256 _amount) external onlyOwner {
2348         maxFreePerWallet = _amount;
2349     }
2350 
2351     function withdraw() external onlyOwner {
2352         (bool success, ) = payable(msg.sender).call{
2353             value: address(this).balance
2354         }("");
2355         require(success, "Transfer failed.");
2356     }
2357 }