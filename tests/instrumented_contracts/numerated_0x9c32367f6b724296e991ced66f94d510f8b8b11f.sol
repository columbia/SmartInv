1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
29 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
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
60 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
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
81     function royaltyInfo(uint256 tokenId, uint256 salePrice)
82         external
83         view
84         returns (address receiver, uint256 royaltyAmount);
85 }
86 
87 // File: @openzeppelin/contracts/token/common/ERC2981.sol
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
130     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
131         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
132 
133         if (royalty.receiver == address(0)) {
134             royalty = _defaultRoyaltyInfo;
135         }
136 
137         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
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
181     function _setTokenRoyalty(
182         uint256 tokenId,
183         address receiver,
184         uint96 feeNumerator
185     ) internal virtual {
186         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
187         require(receiver != address(0), "ERC2981: Invalid parameters");
188 
189         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
190     }
191 
192     /**
193      * @dev Resets royalty information for the token id back to the global default.
194      */
195     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
196         delete _tokenRoyaltyInfo[tokenId];
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/math/Math.sol
201 
202 
203 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev Standard math utilities missing in the Solidity language.
209  */
210 library Math {
211     enum Rounding {
212         Down, // Toward negative infinity
213         Up, // Toward infinity
214         Zero // Toward zero
215     }
216 
217     /**
218      * @dev Returns the largest of two numbers.
219      */
220     function max(uint256 a, uint256 b) internal pure returns (uint256) {
221         return a > b ? a : b;
222     }
223 
224     /**
225      * @dev Returns the smallest of two numbers.
226      */
227     function min(uint256 a, uint256 b) internal pure returns (uint256) {
228         return a < b ? a : b;
229     }
230 
231     /**
232      * @dev Returns the average of two numbers. The result is rounded towards
233      * zero.
234      */
235     function average(uint256 a, uint256 b) internal pure returns (uint256) {
236         // (a + b) / 2 can overflow.
237         return (a & b) + (a ^ b) / 2;
238     }
239 
240     /**
241      * @dev Returns the ceiling of the division of two numbers.
242      *
243      * This differs from standard division with `/` in that it rounds up instead
244      * of rounding down.
245      */
246     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
247         // (a + b - 1) / b can overflow on addition, so we distribute.
248         return a == 0 ? 0 : (a - 1) / b + 1;
249     }
250 
251     /**
252      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
253      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
254      * with further edits by Uniswap Labs also under MIT license.
255      */
256     function mulDiv(
257         uint256 x,
258         uint256 y,
259         uint256 denominator
260     ) internal pure returns (uint256 result) {
261         unchecked {
262             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
263             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
264             // variables such that product = prod1 * 2^256 + prod0.
265             uint256 prod0; // Least significant 256 bits of the product
266             uint256 prod1; // Most significant 256 bits of the product
267             assembly {
268                 let mm := mulmod(x, y, not(0))
269                 prod0 := mul(x, y)
270                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
271             }
272 
273             // Handle non-overflow cases, 256 by 256 division.
274             if (prod1 == 0) {
275                 return prod0 / denominator;
276             }
277 
278             // Make sure the result is less than 2^256. Also prevents denominator == 0.
279             require(denominator > prod1);
280 
281             ///////////////////////////////////////////////
282             // 512 by 256 division.
283             ///////////////////////////////////////////////
284 
285             // Make division exact by subtracting the remainder from [prod1 prod0].
286             uint256 remainder;
287             assembly {
288                 // Compute remainder using mulmod.
289                 remainder := mulmod(x, y, denominator)
290 
291                 // Subtract 256 bit number from 512 bit number.
292                 prod1 := sub(prod1, gt(remainder, prod0))
293                 prod0 := sub(prod0, remainder)
294             }
295 
296             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
297             // See https://cs.stackexchange.com/q/138556/92363.
298 
299             // Does not overflow because the denominator cannot be zero at this stage in the function.
300             uint256 twos = denominator & (~denominator + 1);
301             assembly {
302                 // Divide denominator by twos.
303                 denominator := div(denominator, twos)
304 
305                 // Divide [prod1 prod0] by twos.
306                 prod0 := div(prod0, twos)
307 
308                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
309                 twos := add(div(sub(0, twos), twos), 1)
310             }
311 
312             // Shift in bits from prod1 into prod0.
313             prod0 |= prod1 * twos;
314 
315             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
316             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
317             // four bits. That is, denominator * inv = 1 mod 2^4.
318             uint256 inverse = (3 * denominator) ^ 2;
319 
320             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
321             // in modular arithmetic, doubling the correct bits in each step.
322             inverse *= 2 - denominator * inverse; // inverse mod 2^8
323             inverse *= 2 - denominator * inverse; // inverse mod 2^16
324             inverse *= 2 - denominator * inverse; // inverse mod 2^32
325             inverse *= 2 - denominator * inverse; // inverse mod 2^64
326             inverse *= 2 - denominator * inverse; // inverse mod 2^128
327             inverse *= 2 - denominator * inverse; // inverse mod 2^256
328 
329             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
330             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
331             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
332             // is no longer required.
333             result = prod0 * inverse;
334             return result;
335         }
336     }
337 
338     /**
339      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
340      */
341     function mulDiv(
342         uint256 x,
343         uint256 y,
344         uint256 denominator,
345         Rounding rounding
346     ) internal pure returns (uint256) {
347         uint256 result = mulDiv(x, y, denominator);
348         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
349             result += 1;
350         }
351         return result;
352     }
353 
354     /**
355      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
356      *
357      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
358      */
359     function sqrt(uint256 a) internal pure returns (uint256) {
360         if (a == 0) {
361             return 0;
362         }
363 
364         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
365         //
366         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
367         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
368         //
369         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
370         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
371         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
372         //
373         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
374         uint256 result = 1 << (log2(a) >> 1);
375 
376         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
377         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
378         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
379         // into the expected uint128 result.
380         unchecked {
381             result = (result + a / result) >> 1;
382             result = (result + a / result) >> 1;
383             result = (result + a / result) >> 1;
384             result = (result + a / result) >> 1;
385             result = (result + a / result) >> 1;
386             result = (result + a / result) >> 1;
387             result = (result + a / result) >> 1;
388             return min(result, a / result);
389         }
390     }
391 
392     /**
393      * @notice Calculates sqrt(a), following the selected rounding direction.
394      */
395     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
396         unchecked {
397             uint256 result = sqrt(a);
398             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
399         }
400     }
401 
402     /**
403      * @dev Return the log in base 2, rounded down, of a positive value.
404      * Returns 0 if given 0.
405      */
406     function log2(uint256 value) internal pure returns (uint256) {
407         uint256 result = 0;
408         unchecked {
409             if (value >> 128 > 0) {
410                 value >>= 128;
411                 result += 128;
412             }
413             if (value >> 64 > 0) {
414                 value >>= 64;
415                 result += 64;
416             }
417             if (value >> 32 > 0) {
418                 value >>= 32;
419                 result += 32;
420             }
421             if (value >> 16 > 0) {
422                 value >>= 16;
423                 result += 16;
424             }
425             if (value >> 8 > 0) {
426                 value >>= 8;
427                 result += 8;
428             }
429             if (value >> 4 > 0) {
430                 value >>= 4;
431                 result += 4;
432             }
433             if (value >> 2 > 0) {
434                 value >>= 2;
435                 result += 2;
436             }
437             if (value >> 1 > 0) {
438                 result += 1;
439             }
440         }
441         return result;
442     }
443 
444     /**
445      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
446      * Returns 0 if given 0.
447      */
448     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
449         unchecked {
450             uint256 result = log2(value);
451             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
452         }
453     }
454 
455     /**
456      * @dev Return the log in base 10, rounded down, of a positive value.
457      * Returns 0 if given 0.
458      */
459     function log10(uint256 value) internal pure returns (uint256) {
460         uint256 result = 0;
461         unchecked {
462             if (value >= 10**64) {
463                 value /= 10**64;
464                 result += 64;
465             }
466             if (value >= 10**32) {
467                 value /= 10**32;
468                 result += 32;
469             }
470             if (value >= 10**16) {
471                 value /= 10**16;
472                 result += 16;
473             }
474             if (value >= 10**8) {
475                 value /= 10**8;
476                 result += 8;
477             }
478             if (value >= 10**4) {
479                 value /= 10**4;
480                 result += 4;
481             }
482             if (value >= 10**2) {
483                 value /= 10**2;
484                 result += 2;
485             }
486             if (value >= 10**1) {
487                 result += 1;
488             }
489         }
490         return result;
491     }
492 
493     /**
494      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
495      * Returns 0 if given 0.
496      */
497     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
498         unchecked {
499             uint256 result = log10(value);
500             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
501         }
502     }
503 
504     /**
505      * @dev Return the log in base 256, rounded down, of a positive value.
506      * Returns 0 if given 0.
507      *
508      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
509      */
510     function log256(uint256 value) internal pure returns (uint256) {
511         uint256 result = 0;
512         unchecked {
513             if (value >> 128 > 0) {
514                 value >>= 128;
515                 result += 16;
516             }
517             if (value >> 64 > 0) {
518                 value >>= 64;
519                 result += 8;
520             }
521             if (value >> 32 > 0) {
522                 value >>= 32;
523                 result += 4;
524             }
525             if (value >> 16 > 0) {
526                 value >>= 16;
527                 result += 2;
528             }
529             if (value >> 8 > 0) {
530                 result += 1;
531             }
532         }
533         return result;
534     }
535 
536     /**
537      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
538      * Returns 0 if given 0.
539      */
540     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
541         unchecked {
542             uint256 result = log256(value);
543             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
544         }
545     }
546 }
547 
548 // File: @openzeppelin/contracts/utils/Strings.sol
549 
550 
551 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev String operations.
558  */
559 library Strings {
560     bytes16 private constant _SYMBOLS = "0123456789abcdef";
561     uint8 private constant _ADDRESS_LENGTH = 20;
562 
563     /**
564      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
565      */
566     function toString(uint256 value) internal pure returns (string memory) {
567         unchecked {
568             uint256 length = Math.log10(value) + 1;
569             string memory buffer = new string(length);
570             uint256 ptr;
571             /// @solidity memory-safe-assembly
572             assembly {
573                 ptr := add(buffer, add(32, length))
574             }
575             while (true) {
576                 ptr--;
577                 /// @solidity memory-safe-assembly
578                 assembly {
579                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
580                 }
581                 value /= 10;
582                 if (value == 0) break;
583             }
584             return buffer;
585         }
586     }
587 
588     /**
589      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
590      */
591     function toHexString(uint256 value) internal pure returns (string memory) {
592         unchecked {
593             return toHexString(value, Math.log256(value) + 1);
594         }
595     }
596 
597     /**
598      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
599      */
600     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
601         bytes memory buffer = new bytes(2 * length + 2);
602         buffer[0] = "0";
603         buffer[1] = "x";
604         for (uint256 i = 2 * length + 1; i > 1; --i) {
605             buffer[i] = _SYMBOLS[value & 0xf];
606             value >>= 4;
607         }
608         require(value == 0, "Strings: hex length insufficient");
609         return string(buffer);
610     }
611 
612     /**
613      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
614      */
615     function toHexString(address addr) internal pure returns (string memory) {
616         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
617     }
618 }
619 
620 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
621 
622 
623 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev Contract module that helps prevent reentrant calls to a function.
629  *
630  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
631  * available, which can be applied to functions to make sure there are no nested
632  * (reentrant) calls to them.
633  *
634  * Note that because there is a single `nonReentrant` guard, functions marked as
635  * `nonReentrant` may not call one another. This can be worked around by making
636  * those functions `private`, and then adding `external` `nonReentrant` entry
637  * points to them.
638  *
639  * TIP: If you would like to learn more about reentrancy and alternative ways
640  * to protect against it, check out our blog post
641  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
642  */
643 abstract contract ReentrancyGuard {
644     // Booleans are more expensive than uint256 or any type that takes up a full
645     // word because each write operation emits an extra SLOAD to first read the
646     // slot's contents, replace the bits taken up by the boolean, and then write
647     // back. This is the compiler's defense against contract upgrades and
648     // pointer aliasing, and it cannot be disabled.
649 
650     // The values being non-zero value makes deployment a bit more expensive,
651     // but in exchange the refund on every call to nonReentrant will be lower in
652     // amount. Since refunds are capped to a percentage of the total
653     // transaction's gas, it is best to keep them low in cases like this one, to
654     // increase the likelihood of the full refund coming into effect.
655     uint256 private constant _NOT_ENTERED = 1;
656     uint256 private constant _ENTERED = 2;
657 
658     uint256 private _status;
659 
660     constructor() {
661         _status = _NOT_ENTERED;
662     }
663 
664     /**
665      * @dev Prevents a contract from calling itself, directly or indirectly.
666      * Calling a `nonReentrant` function from another `nonReentrant`
667      * function is not supported. It is possible to prevent this from happening
668      * by making the `nonReentrant` function external, and making it call a
669      * `private` function that does the actual work.
670      */
671     modifier nonReentrant() {
672         _nonReentrantBefore();
673         _;
674         _nonReentrantAfter();
675     }
676 
677     function _nonReentrantBefore() private {
678         // On the first call to nonReentrant, _status will be _NOT_ENTERED
679         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
680 
681         // Any calls to nonReentrant after this point will fail
682         _status = _ENTERED;
683     }
684 
685     function _nonReentrantAfter() private {
686         // By storing the original value once again, a refund is triggered (see
687         // https://eips.ethereum.org/EIPS/eip-2200)
688         _status = _NOT_ENTERED;
689     }
690 }
691 
692 // File: @openzeppelin/contracts/utils/Context.sol
693 
694 
695 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev Provides information about the current execution context, including the
701  * sender of the transaction and its data. While these are generally available
702  * via msg.sender and msg.data, they should not be accessed in such a direct
703  * manner, since when dealing with meta-transactions the account sending and
704  * paying for execution may not be the actual sender (as far as an application
705  * is concerned).
706  *
707  * This contract is only required for intermediate, library-like contracts.
708  */
709 abstract contract Context {
710     function _msgSender() internal view virtual returns (address) {
711         return msg.sender;
712     }
713 
714     function _msgData() internal view virtual returns (bytes calldata) {
715         return msg.data;
716     }
717 }
718 
719 // File: @openzeppelin/contracts/access/Ownable.sol
720 
721 
722 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 
727 /**
728  * @dev Contract module which provides a basic access control mechanism, where
729  * there is an account (an owner) that can be granted exclusive access to
730  * specific functions.
731  *
732  * By default, the owner account will be the one that deploys the contract. This
733  * can later be changed with {transferOwnership}.
734  *
735  * This module is used through inheritance. It will make available the modifier
736  * `onlyOwner`, which can be applied to your functions to restrict their use to
737  * the owner.
738  */
739 abstract contract Ownable is Context {
740     address private _owner;
741 
742     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
743 
744     /**
745      * @dev Initializes the contract setting the deployer as the initial owner.
746      */
747     constructor() {
748         _transferOwnership(_msgSender());
749     }
750 
751     /**
752      * @dev Throws if called by any account other than the owner.
753      */
754     modifier onlyOwner() {
755         _checkOwner();
756         _;
757     }
758 
759     /**
760      * @dev Returns the address of the current owner.
761      */
762     function owner() public view virtual returns (address) {
763         return _owner;
764     }
765 
766     /**
767      * @dev Throws if the sender is not the owner.
768      */
769     function _checkOwner() internal view virtual {
770         require(owner() == _msgSender(), "Ownable: caller is not the owner");
771     }
772 
773     /**
774      * @dev Leaves the contract without owner. It will not be possible to call
775      * `onlyOwner` functions anymore. Can only be called by the current owner.
776      *
777      * NOTE: Renouncing ownership will leave the contract without an owner,
778      * thereby removing any functionality that is only available to the owner.
779      */
780     function renounceOwnership() public virtual onlyOwner {
781         _transferOwnership(address(0));
782     }
783 
784     /**
785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
786      * Can only be called by the current owner.
787      */
788     function transferOwnership(address newOwner) public virtual onlyOwner {
789         require(newOwner != address(0), "Ownable: new owner is the zero address");
790         _transferOwnership(newOwner);
791     }
792 
793     /**
794      * @dev Transfers ownership of the contract to a new account (`newOwner`).
795      * Internal function without access restriction.
796      */
797     function _transferOwnership(address newOwner) internal virtual {
798         address oldOwner = _owner;
799         _owner = newOwner;
800         emit OwnershipTransferred(oldOwner, newOwner);
801     }
802 }
803 
804 // File: erc721a/contracts/IERC721A.sol
805 
806 
807 // ERC721A Contracts v4.2.3
808 // Creator: Chiru Labs
809 
810 pragma solidity ^0.8.4;
811 
812 /**
813  * @dev Interface of ERC721A.
814  */
815 interface IERC721A {
816     /**
817      * The caller must own the token or be an approved operator.
818      */
819     error ApprovalCallerNotOwnerNorApproved();
820 
821     /**
822      * The token does not exist.
823      */
824     error ApprovalQueryForNonexistentToken();
825 
826     /**
827      * Cannot query the balance for the zero address.
828      */
829     error BalanceQueryForZeroAddress();
830 
831     /**
832      * Cannot mint to the zero address.
833      */
834     error MintToZeroAddress();
835 
836     /**
837      * The quantity of tokens minted must be more than zero.
838      */
839     error MintZeroQuantity();
840 
841     /**
842      * The token does not exist.
843      */
844     error OwnerQueryForNonexistentToken();
845 
846     /**
847      * The caller must own the token or be an approved operator.
848      */
849     error TransferCallerNotOwnerNorApproved();
850 
851     /**
852      * The token must be owned by `from`.
853      */
854     error TransferFromIncorrectOwner();
855 
856     /**
857      * Cannot safely transfer to a contract that does not implement the
858      * ERC721Receiver interface.
859      */
860     error TransferToNonERC721ReceiverImplementer();
861 
862     /**
863      * Cannot transfer to the zero address.
864      */
865     error TransferToZeroAddress();
866 
867     /**
868      * The token does not exist.
869      */
870     error URIQueryForNonexistentToken();
871 
872     /**
873      * The `quantity` minted with ERC2309 exceeds the safety limit.
874      */
875     error MintERC2309QuantityExceedsLimit();
876 
877     /**
878      * The `extraData` cannot be set on an unintialized ownership slot.
879      */
880     error OwnershipNotInitializedForExtraData();
881 
882     // =============================================================
883     //                            STRUCTS
884     // =============================================================
885 
886     struct TokenOwnership {
887         // The address of the owner.
888         address addr;
889         // Stores the start time of ownership with minimal overhead for tokenomics.
890         uint64 startTimestamp;
891         // Whether the token has been burned.
892         bool burned;
893         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
894         uint24 extraData;
895     }
896 
897     // =============================================================
898     //                         TOKEN COUNTERS
899     // =============================================================
900 
901     /**
902      * @dev Returns the total number of tokens in existence.
903      * Burned tokens will reduce the count.
904      * To get the total number of tokens minted, please see {_totalMinted}.
905      */
906     function totalSupply() external view returns (uint256);
907 
908     // =============================================================
909     //                            IERC165
910     // =============================================================
911 
912     /**
913      * @dev Returns true if this contract implements the interface defined by
914      * `interfaceId`. See the corresponding
915      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
916      * to learn more about how these ids are created.
917      *
918      * This function call must use less than 30000 gas.
919      */
920     function supportsInterface(bytes4 interfaceId) external view returns (bool);
921 
922     // =============================================================
923     //                            IERC721
924     // =============================================================
925 
926     /**
927      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
928      */
929     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
930 
931     /**
932      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
933      */
934     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
935 
936     /**
937      * @dev Emitted when `owner` enables or disables
938      * (`approved`) `operator` to manage all of its assets.
939      */
940     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
941 
942     /**
943      * @dev Returns the number of tokens in `owner`'s account.
944      */
945     function balanceOf(address owner) external view returns (uint256 balance);
946 
947     /**
948      * @dev Returns the owner of the `tokenId` token.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must exist.
953      */
954     function ownerOf(uint256 tokenId) external view returns (address owner);
955 
956     /**
957      * @dev Safely transfers `tokenId` token from `from` to `to`,
958      * checking first that contract recipients are aware of the ERC721 protocol
959      * to prevent tokens from being forever locked.
960      *
961      * Requirements:
962      *
963      * - `from` cannot be the zero address.
964      * - `to` cannot be the zero address.
965      * - `tokenId` token must exist and be owned by `from`.
966      * - If the caller is not `from`, it must be have been allowed to move
967      * this token by either {approve} or {setApprovalForAll}.
968      * - If `to` refers to a smart contract, it must implement
969      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
970      *
971      * Emits a {Transfer} event.
972      */
973     function safeTransferFrom(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes calldata data
978     ) external payable;
979 
980     /**
981      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId
987     ) external payable;
988 
989     /**
990      * @dev Transfers `tokenId` from `from` to `to`.
991      *
992      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
993      * whenever possible.
994      *
995      * Requirements:
996      *
997      * - `from` cannot be the zero address.
998      * - `to` cannot be the zero address.
999      * - `tokenId` token must be owned by `from`.
1000      * - If the caller is not `from`, it must be approved to move this token
1001      * by either {approve} or {setApprovalForAll}.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function transferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) external payable;
1010 
1011     /**
1012      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1013      * The approval is cleared when the token is transferred.
1014      *
1015      * Only a single account can be approved at a time, so approving the
1016      * zero address clears previous approvals.
1017      *
1018      * Requirements:
1019      *
1020      * - The caller must own the token or be an approved operator.
1021      * - `tokenId` must exist.
1022      *
1023      * Emits an {Approval} event.
1024      */
1025     function approve(address to, uint256 tokenId) external payable;
1026 
1027     /**
1028      * @dev Approve or remove `operator` as an operator for the caller.
1029      * Operators can call {transferFrom} or {safeTransferFrom}
1030      * for any token owned by the caller.
1031      *
1032      * Requirements:
1033      *
1034      * - The `operator` cannot be the caller.
1035      *
1036      * Emits an {ApprovalForAll} event.
1037      */
1038     function setApprovalForAll(address operator, bool _approved) external;
1039 
1040     /**
1041      * @dev Returns the account approved for `tokenId` token.
1042      *
1043      * Requirements:
1044      *
1045      * - `tokenId` must exist.
1046      */
1047     function getApproved(uint256 tokenId) external view returns (address operator);
1048 
1049     /**
1050      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1051      *
1052      * See {setApprovalForAll}.
1053      */
1054     function isApprovedForAll(address owner, address operator) external view returns (bool);
1055 
1056     // =============================================================
1057     //                        IERC721Metadata
1058     // =============================================================
1059 
1060     /**
1061      * @dev Returns the token collection name.
1062      */
1063     function name() external view returns (string memory);
1064 
1065     /**
1066      * @dev Returns the token collection symbol.
1067      */
1068     function symbol() external view returns (string memory);
1069 
1070     /**
1071      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1072      */
1073     function tokenURI(uint256 tokenId) external view returns (string memory);
1074 
1075     // =============================================================
1076     //                           IERC2309
1077     // =============================================================
1078 
1079     /**
1080      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1081      * (inclusive) is transferred from `from` to `to`, as defined in the
1082      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1083      *
1084      * See {_mintERC2309} for more details.
1085      */
1086     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1087 }
1088 
1089 // File: erc721a/contracts/ERC721A.sol
1090 
1091 
1092 // ERC721A Contracts v4.2.3
1093 // Creator: Chiru Labs
1094 
1095 pragma solidity ^0.8.4;
1096 
1097 
1098 /**
1099  * @dev Interface of ERC721 token receiver.
1100  */
1101 interface ERC721A__IERC721Receiver {
1102     function onERC721Received(
1103         address operator,
1104         address from,
1105         uint256 tokenId,
1106         bytes calldata data
1107     ) external returns (bytes4);
1108 }
1109 
1110 /**
1111  * @title ERC721A
1112  *
1113  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1114  * Non-Fungible Token Standard, including the Metadata extension.
1115  * Optimized for lower gas during batch mints.
1116  *
1117  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1118  * starting from `_startTokenId()`.
1119  *
1120  * Assumptions:
1121  *
1122  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1123  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1124  */
1125 contract ERC721A is IERC721A {
1126     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1127     struct TokenApprovalRef {
1128         address value;
1129     }
1130 
1131     // =============================================================
1132     //                           CONSTANTS
1133     // =============================================================
1134 
1135     // Mask of an entry in packed address data.
1136     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1137 
1138     // The bit position of `numberMinted` in packed address data.
1139     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1140 
1141     // The bit position of `numberBurned` in packed address data.
1142     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1143 
1144     // The bit position of `aux` in packed address data.
1145     uint256 private constant _BITPOS_AUX = 192;
1146 
1147     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1148     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1149 
1150     // The bit position of `startTimestamp` in packed ownership.
1151     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1152 
1153     // The bit mask of the `burned` bit in packed ownership.
1154     uint256 private constant _BITMASK_BURNED = 1 << 224;
1155 
1156     // The bit position of the `nextInitialized` bit in packed ownership.
1157     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1158 
1159     // The bit mask of the `nextInitialized` bit in packed ownership.
1160     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1161 
1162     // The bit position of `extraData` in packed ownership.
1163     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1164 
1165     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1166     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1167 
1168     // The mask of the lower 160 bits for addresses.
1169     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1170 
1171     // The maximum `quantity` that can be minted with {_mintERC2309}.
1172     // This limit is to prevent overflows on the address data entries.
1173     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1174     // is required to cause an overflow, which is unrealistic.
1175     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1176 
1177     // The `Transfer` event signature is given by:
1178     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1179     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1180         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1181 
1182     // =============================================================
1183     //                            STORAGE
1184     // =============================================================
1185 
1186     // The next token ID to be minted.
1187     uint256 private _currentIndex;
1188 
1189     // The number of tokens burned.
1190     uint256 private _burnCounter;
1191 
1192     // Token name
1193     string private _name;
1194 
1195     // Token symbol
1196     string private _symbol;
1197 
1198     // Mapping from token ID to ownership details
1199     // An empty struct value does not necessarily mean the token is unowned.
1200     // See {_packedOwnershipOf} implementation for details.
1201     //
1202     // Bits Layout:
1203     // - [0..159]   `addr`
1204     // - [160..223] `startTimestamp`
1205     // - [224]      `burned`
1206     // - [225]      `nextInitialized`
1207     // - [232..255] `extraData`
1208     mapping(uint256 => uint256) private _packedOwnerships;
1209 
1210     // Mapping owner address to address data.
1211     //
1212     // Bits Layout:
1213     // - [0..63]    `balance`
1214     // - [64..127]  `numberMinted`
1215     // - [128..191] `numberBurned`
1216     // - [192..255] `aux`
1217     mapping(address => uint256) private _packedAddressData;
1218 
1219     // Mapping from token ID to approved address.
1220     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1221 
1222     // Mapping from owner to operator approvals
1223     mapping(address => mapping(address => bool)) private _operatorApprovals;
1224 
1225     // =============================================================
1226     //                          CONSTRUCTOR
1227     // =============================================================
1228 
1229     constructor(string memory name_, string memory symbol_) {
1230         _name = name_;
1231         _symbol = symbol_;
1232         _currentIndex = _startTokenId();
1233     }
1234 
1235     // =============================================================
1236     //                   TOKEN COUNTING OPERATIONS
1237     // =============================================================
1238 
1239     /**
1240      * @dev Returns the starting token ID.
1241      * To change the starting token ID, please override this function.
1242      */
1243     function _startTokenId() internal view virtual returns (uint256) {
1244         return 0;
1245     }
1246 
1247     /**
1248      * @dev Returns the next token ID to be minted.
1249      */
1250     function _nextTokenId() internal view virtual returns (uint256) {
1251         return _currentIndex;
1252     }
1253 
1254     /**
1255      * @dev Returns the total number of tokens in existence.
1256      * Burned tokens will reduce the count.
1257      * To get the total number of tokens minted, please see {_totalMinted}.
1258      */
1259     function totalSupply() public view virtual override returns (uint256) {
1260         // Counter underflow is impossible as _burnCounter cannot be incremented
1261         // more than `_currentIndex - _startTokenId()` times.
1262         unchecked {
1263             return _currentIndex - _burnCounter - _startTokenId();
1264         }
1265     }
1266 
1267     /**
1268      * @dev Returns the total amount of tokens minted in the contract.
1269      */
1270     function _totalMinted() internal view virtual returns (uint256) {
1271         // Counter underflow is impossible as `_currentIndex` does not decrement,
1272         // and it is initialized to `_startTokenId()`.
1273         unchecked {
1274             return _currentIndex - _startTokenId();
1275         }
1276     }
1277 
1278     /**
1279      * @dev Returns the total number of tokens burned.
1280      */
1281     function _totalBurned() internal view virtual returns (uint256) {
1282         return _burnCounter;
1283     }
1284 
1285     // =============================================================
1286     //                    ADDRESS DATA OPERATIONS
1287     // =============================================================
1288 
1289     /**
1290      * @dev Returns the number of tokens in `owner`'s account.
1291      */
1292     function balanceOf(address owner) public view virtual override returns (uint256) {
1293         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1294         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1295     }
1296 
1297     /**
1298      * Returns the number of tokens minted by `owner`.
1299      */
1300     function _numberMinted(address owner) internal view returns (uint256) {
1301         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1302     }
1303 
1304     /**
1305      * Returns the number of tokens burned by or on behalf of `owner`.
1306      */
1307     function _numberBurned(address owner) internal view returns (uint256) {
1308         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1309     }
1310 
1311     /**
1312      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1313      */
1314     function _getAux(address owner) internal view returns (uint64) {
1315         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1316     }
1317 
1318     /**
1319      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1320      * If there are multiple variables, please pack them into a uint64.
1321      */
1322     function _setAux(address owner, uint64 aux) internal virtual {
1323         uint256 packed = _packedAddressData[owner];
1324         uint256 auxCasted;
1325         // Cast `aux` with assembly to avoid redundant masking.
1326         assembly {
1327             auxCasted := aux
1328         }
1329         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1330         _packedAddressData[owner] = packed;
1331     }
1332 
1333     // =============================================================
1334     //                            IERC165
1335     // =============================================================
1336 
1337     /**
1338      * @dev Returns true if this contract implements the interface defined by
1339      * `interfaceId`. See the corresponding
1340      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1341      * to learn more about how these ids are created.
1342      *
1343      * This function call must use less than 30000 gas.
1344      */
1345     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1346         // The interface IDs are constants representing the first 4 bytes
1347         // of the XOR of all function selectors in the interface.
1348         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1349         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1350         return
1351             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1352             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1353             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1354     }
1355 
1356     // =============================================================
1357     //                        IERC721Metadata
1358     // =============================================================
1359 
1360     /**
1361      * @dev Returns the token collection name.
1362      */
1363     function name() public view virtual override returns (string memory) {
1364         return _name;
1365     }
1366 
1367     /**
1368      * @dev Returns the token collection symbol.
1369      */
1370     function symbol() public view virtual override returns (string memory) {
1371         return _symbol;
1372     }
1373 
1374     /**
1375      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1376      */
1377     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1378         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1379 
1380         string memory baseURI = _baseURI();
1381         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1382     }
1383 
1384     /**
1385      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1386      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1387      * by default, it can be overridden in child contracts.
1388      */
1389     function _baseURI() internal view virtual returns (string memory) {
1390         return '';
1391     }
1392 
1393     // =============================================================
1394     //                     OWNERSHIPS OPERATIONS
1395     // =============================================================
1396 
1397     /**
1398      * @dev Returns the owner of the `tokenId` token.
1399      *
1400      * Requirements:
1401      *
1402      * - `tokenId` must exist.
1403      */
1404     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1405         return address(uint160(_packedOwnershipOf(tokenId)));
1406     }
1407 
1408     /**
1409      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1410      * It gradually moves to O(1) as tokens get transferred around over time.
1411      */
1412     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1413         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1414     }
1415 
1416     /**
1417      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1418      */
1419     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1420         return _unpackedOwnership(_packedOwnerships[index]);
1421     }
1422 
1423     /**
1424      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1425      */
1426     function _initializeOwnershipAt(uint256 index) internal virtual {
1427         if (_packedOwnerships[index] == 0) {
1428             _packedOwnerships[index] = _packedOwnershipOf(index);
1429         }
1430     }
1431 
1432     /**
1433      * Returns the packed ownership data of `tokenId`.
1434      */
1435     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1436         uint256 curr = tokenId;
1437 
1438         unchecked {
1439             if (_startTokenId() <= curr)
1440                 if (curr < _currentIndex) {
1441                     uint256 packed = _packedOwnerships[curr];
1442                     // If not burned.
1443                     if (packed & _BITMASK_BURNED == 0) {
1444                         // Invariant:
1445                         // There will always be an initialized ownership slot
1446                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1447                         // before an unintialized ownership slot
1448                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1449                         // Hence, `curr` will not underflow.
1450                         //
1451                         // We can directly compare the packed value.
1452                         // If the address is zero, packed will be zero.
1453                         while (packed == 0) {
1454                             packed = _packedOwnerships[--curr];
1455                         }
1456                         return packed;
1457                     }
1458                 }
1459         }
1460         revert OwnerQueryForNonexistentToken();
1461     }
1462 
1463     /**
1464      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1465      */
1466     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1467         ownership.addr = address(uint160(packed));
1468         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1469         ownership.burned = packed & _BITMASK_BURNED != 0;
1470         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1471     }
1472 
1473     /**
1474      * @dev Packs ownership data into a single uint256.
1475      */
1476     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1477         assembly {
1478             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1479             owner := and(owner, _BITMASK_ADDRESS)
1480             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1481             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1482         }
1483     }
1484 
1485     /**
1486      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1487      */
1488     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1489         // For branchless setting of the `nextInitialized` flag.
1490         assembly {
1491             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1492             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1493         }
1494     }
1495 
1496     // =============================================================
1497     //                      APPROVAL OPERATIONS
1498     // =============================================================
1499 
1500     /**
1501      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1502      * The approval is cleared when the token is transferred.
1503      *
1504      * Only a single account can be approved at a time, so approving the
1505      * zero address clears previous approvals.
1506      *
1507      * Requirements:
1508      *
1509      * - The caller must own the token or be an approved operator.
1510      * - `tokenId` must exist.
1511      *
1512      * Emits an {Approval} event.
1513      */
1514     function approve(address to, uint256 tokenId) public payable virtual override {
1515         address owner = ownerOf(tokenId);
1516 
1517         if (_msgSenderERC721A() != owner)
1518             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1519                 revert ApprovalCallerNotOwnerNorApproved();
1520             }
1521 
1522         _tokenApprovals[tokenId].value = to;
1523         emit Approval(owner, to, tokenId);
1524     }
1525 
1526     /**
1527      * @dev Returns the account approved for `tokenId` token.
1528      *
1529      * Requirements:
1530      *
1531      * - `tokenId` must exist.
1532      */
1533     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1534         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1535 
1536         return _tokenApprovals[tokenId].value;
1537     }
1538 
1539     /**
1540      * @dev Approve or remove `operator` as an operator for the caller.
1541      * Operators can call {transferFrom} or {safeTransferFrom}
1542      * for any token owned by the caller.
1543      *
1544      * Requirements:
1545      *
1546      * - The `operator` cannot be the caller.
1547      *
1548      * Emits an {ApprovalForAll} event.
1549      */
1550     function setApprovalForAll(address operator, bool approved) public virtual override {
1551         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1552         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1553     }
1554 
1555     /**
1556      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1557      *
1558      * See {setApprovalForAll}.
1559      */
1560     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1561         return _operatorApprovals[owner][operator];
1562     }
1563 
1564     /**
1565      * @dev Returns whether `tokenId` exists.
1566      *
1567      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1568      *
1569      * Tokens start existing when they are minted. See {_mint}.
1570      */
1571     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1572         return
1573             _startTokenId() <= tokenId &&
1574             tokenId < _currentIndex && // If within bounds,
1575             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1576     }
1577 
1578     /**
1579      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1580      */
1581     function _isSenderApprovedOrOwner(
1582         address approvedAddress,
1583         address owner,
1584         address msgSender
1585     ) private pure returns (bool result) {
1586         assembly {
1587             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1588             owner := and(owner, _BITMASK_ADDRESS)
1589             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1590             msgSender := and(msgSender, _BITMASK_ADDRESS)
1591             // `msgSender == owner || msgSender == approvedAddress`.
1592             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1593         }
1594     }
1595 
1596     /**
1597      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1598      */
1599     function _getApprovedSlotAndAddress(uint256 tokenId)
1600         private
1601         view
1602         returns (uint256 approvedAddressSlot, address approvedAddress)
1603     {
1604         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1605         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1606         assembly {
1607             approvedAddressSlot := tokenApproval.slot
1608             approvedAddress := sload(approvedAddressSlot)
1609         }
1610     }
1611 
1612     // =============================================================
1613     //                      TRANSFER OPERATIONS
1614     // =============================================================
1615 
1616     /**
1617      * @dev Transfers `tokenId` from `from` to `to`.
1618      *
1619      * Requirements:
1620      *
1621      * - `from` cannot be the zero address.
1622      * - `to` cannot be the zero address.
1623      * - `tokenId` token must be owned by `from`.
1624      * - If the caller is not `from`, it must be approved to move this token
1625      * by either {approve} or {setApprovalForAll}.
1626      *
1627      * Emits a {Transfer} event.
1628      */
1629     function transferFrom(
1630         address from,
1631         address to,
1632         uint256 tokenId
1633     ) public payable virtual override {
1634         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1635 
1636         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1637 
1638         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1639 
1640         // The nested ifs save around 20+ gas over a compound boolean condition.
1641         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1642             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1643 
1644         if (to == address(0)) revert TransferToZeroAddress();
1645 
1646         _beforeTokenTransfers(from, to, tokenId, 1);
1647 
1648         // Clear approvals from the previous owner.
1649         assembly {
1650             if approvedAddress {
1651                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1652                 sstore(approvedAddressSlot, 0)
1653             }
1654         }
1655 
1656         // Underflow of the sender's balance is impossible because we check for
1657         // ownership above and the recipient's balance can't realistically overflow.
1658         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1659         unchecked {
1660             // We can directly increment and decrement the balances.
1661             --_packedAddressData[from]; // Updates: `balance -= 1`.
1662             ++_packedAddressData[to]; // Updates: `balance += 1`.
1663 
1664             // Updates:
1665             // - `address` to the next owner.
1666             // - `startTimestamp` to the timestamp of transfering.
1667             // - `burned` to `false`.
1668             // - `nextInitialized` to `true`.
1669             _packedOwnerships[tokenId] = _packOwnershipData(
1670                 to,
1671                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1672             );
1673 
1674             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1675             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1676                 uint256 nextTokenId = tokenId + 1;
1677                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1678                 if (_packedOwnerships[nextTokenId] == 0) {
1679                     // If the next slot is within bounds.
1680                     if (nextTokenId != _currentIndex) {
1681                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1682                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1683                     }
1684                 }
1685             }
1686         }
1687 
1688         emit Transfer(from, to, tokenId);
1689         _afterTokenTransfers(from, to, tokenId, 1);
1690     }
1691 
1692     /**
1693      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1694      */
1695     function safeTransferFrom(
1696         address from,
1697         address to,
1698         uint256 tokenId
1699     ) public payable virtual override {
1700         safeTransferFrom(from, to, tokenId, '');
1701     }
1702 
1703     /**
1704      * @dev Safely transfers `tokenId` token from `from` to `to`.
1705      *
1706      * Requirements:
1707      *
1708      * - `from` cannot be the zero address.
1709      * - `to` cannot be the zero address.
1710      * - `tokenId` token must exist and be owned by `from`.
1711      * - If the caller is not `from`, it must be approved to move this token
1712      * by either {approve} or {setApprovalForAll}.
1713      * - If `to` refers to a smart contract, it must implement
1714      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1715      *
1716      * Emits a {Transfer} event.
1717      */
1718     function safeTransferFrom(
1719         address from,
1720         address to,
1721         uint256 tokenId,
1722         bytes memory _data
1723     ) public payable virtual override {
1724         transferFrom(from, to, tokenId);
1725         if (to.code.length != 0)
1726             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1727                 revert TransferToNonERC721ReceiverImplementer();
1728             }
1729     }
1730 
1731     /**
1732      * @dev Hook that is called before a set of serially-ordered token IDs
1733      * are about to be transferred. This includes minting.
1734      * And also called before burning one token.
1735      *
1736      * `startTokenId` - the first token ID to be transferred.
1737      * `quantity` - the amount to be transferred.
1738      *
1739      * Calling conditions:
1740      *
1741      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1742      * transferred to `to`.
1743      * - When `from` is zero, `tokenId` will be minted for `to`.
1744      * - When `to` is zero, `tokenId` will be burned by `from`.
1745      * - `from` and `to` are never both zero.
1746      */
1747     function _beforeTokenTransfers(
1748         address from,
1749         address to,
1750         uint256 startTokenId,
1751         uint256 quantity
1752     ) internal virtual {}
1753 
1754     /**
1755      * @dev Hook that is called after a set of serially-ordered token IDs
1756      * have been transferred. This includes minting.
1757      * And also called after one token has been burned.
1758      *
1759      * `startTokenId` - the first token ID to be transferred.
1760      * `quantity` - the amount to be transferred.
1761      *
1762      * Calling conditions:
1763      *
1764      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1765      * transferred to `to`.
1766      * - When `from` is zero, `tokenId` has been minted for `to`.
1767      * - When `to` is zero, `tokenId` has been burned by `from`.
1768      * - `from` and `to` are never both zero.
1769      */
1770     function _afterTokenTransfers(
1771         address from,
1772         address to,
1773         uint256 startTokenId,
1774         uint256 quantity
1775     ) internal virtual {}
1776 
1777     /**
1778      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1779      *
1780      * `from` - Previous owner of the given token ID.
1781      * `to` - Target address that will receive the token.
1782      * `tokenId` - Token ID to be transferred.
1783      * `_data` - Optional data to send along with the call.
1784      *
1785      * Returns whether the call correctly returned the expected magic value.
1786      */
1787     function _checkContractOnERC721Received(
1788         address from,
1789         address to,
1790         uint256 tokenId,
1791         bytes memory _data
1792     ) private returns (bool) {
1793         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1794             bytes4 retval
1795         ) {
1796             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1797         } catch (bytes memory reason) {
1798             if (reason.length == 0) {
1799                 revert TransferToNonERC721ReceiverImplementer();
1800             } else {
1801                 assembly {
1802                     revert(add(32, reason), mload(reason))
1803                 }
1804             }
1805         }
1806     }
1807 
1808     // =============================================================
1809     //                        MINT OPERATIONS
1810     // =============================================================
1811 
1812     /**
1813      * @dev Mints `quantity` tokens and transfers them to `to`.
1814      *
1815      * Requirements:
1816      *
1817      * - `to` cannot be the zero address.
1818      * - `quantity` must be greater than 0.
1819      *
1820      * Emits a {Transfer} event for each mint.
1821      */
1822     function _mint(address to, uint256 quantity) internal virtual {
1823         uint256 startTokenId = _currentIndex;
1824         if (quantity == 0) revert MintZeroQuantity();
1825 
1826         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1827 
1828         // Overflows are incredibly unrealistic.
1829         // `balance` and `numberMinted` have a maximum limit of 2**64.
1830         // `tokenId` has a maximum limit of 2**256.
1831         unchecked {
1832             // Updates:
1833             // - `balance += quantity`.
1834             // - `numberMinted += quantity`.
1835             //
1836             // We can directly add to the `balance` and `numberMinted`.
1837             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1838 
1839             // Updates:
1840             // - `address` to the owner.
1841             // - `startTimestamp` to the timestamp of minting.
1842             // - `burned` to `false`.
1843             // - `nextInitialized` to `quantity == 1`.
1844             _packedOwnerships[startTokenId] = _packOwnershipData(
1845                 to,
1846                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1847             );
1848 
1849             uint256 toMasked;
1850             uint256 end = startTokenId + quantity;
1851 
1852             // Use assembly to loop and emit the `Transfer` event for gas savings.
1853             // The duplicated `log4` removes an extra check and reduces stack juggling.
1854             // The assembly, together with the surrounding Solidity code, have been
1855             // delicately arranged to nudge the compiler into producing optimized opcodes.
1856             assembly {
1857                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1858                 toMasked := and(to, _BITMASK_ADDRESS)
1859                 // Emit the `Transfer` event.
1860                 log4(
1861                     0, // Start of data (0, since no data).
1862                     0, // End of data (0, since no data).
1863                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1864                     0, // `address(0)`.
1865                     toMasked, // `to`.
1866                     startTokenId // `tokenId`.
1867                 )
1868 
1869                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1870                 // that overflows uint256 will make the loop run out of gas.
1871                 // The compiler will optimize the `iszero` away for performance.
1872                 for {
1873                     let tokenId := add(startTokenId, 1)
1874                 } iszero(eq(tokenId, end)) {
1875                     tokenId := add(tokenId, 1)
1876                 } {
1877                     // Emit the `Transfer` event. Similar to above.
1878                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1879                 }
1880             }
1881             if (toMasked == 0) revert MintToZeroAddress();
1882 
1883             _currentIndex = end;
1884         }
1885         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1886     }
1887 
1888     /**
1889      * @dev Mints `quantity` tokens and transfers them to `to`.
1890      *
1891      * This function is intended for efficient minting only during contract creation.
1892      *
1893      * It emits only one {ConsecutiveTransfer} as defined in
1894      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1895      * instead of a sequence of {Transfer} event(s).
1896      *
1897      * Calling this function outside of contract creation WILL make your contract
1898      * non-compliant with the ERC721 standard.
1899      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1900      * {ConsecutiveTransfer} event is only permissible during contract creation.
1901      *
1902      * Requirements:
1903      *
1904      * - `to` cannot be the zero address.
1905      * - `quantity` must be greater than 0.
1906      *
1907      * Emits a {ConsecutiveTransfer} event.
1908      */
1909     function _mintERC2309(address to, uint256 quantity) internal virtual {
1910         uint256 startTokenId = _currentIndex;
1911         if (to == address(0)) revert MintToZeroAddress();
1912         if (quantity == 0) revert MintZeroQuantity();
1913         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1914 
1915         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1916 
1917         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1918         unchecked {
1919             // Updates:
1920             // - `balance += quantity`.
1921             // - `numberMinted += quantity`.
1922             //
1923             // We can directly add to the `balance` and `numberMinted`.
1924             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1925 
1926             // Updates:
1927             // - `address` to the owner.
1928             // - `startTimestamp` to the timestamp of minting.
1929             // - `burned` to `false`.
1930             // - `nextInitialized` to `quantity == 1`.
1931             _packedOwnerships[startTokenId] = _packOwnershipData(
1932                 to,
1933                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1934             );
1935 
1936             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1937 
1938             _currentIndex = startTokenId + quantity;
1939         }
1940         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1941     }
1942 
1943     /**
1944      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1945      *
1946      * Requirements:
1947      *
1948      * - If `to` refers to a smart contract, it must implement
1949      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1950      * - `quantity` must be greater than 0.
1951      *
1952      * See {_mint}.
1953      *
1954      * Emits a {Transfer} event for each mint.
1955      */
1956     function _safeMint(
1957         address to,
1958         uint256 quantity,
1959         bytes memory _data
1960     ) internal virtual {
1961         _mint(to, quantity);
1962 
1963         unchecked {
1964             if (to.code.length != 0) {
1965                 uint256 end = _currentIndex;
1966                 uint256 index = end - quantity;
1967                 do {
1968                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1969                         revert TransferToNonERC721ReceiverImplementer();
1970                     }
1971                 } while (index < end);
1972                 // Reentrancy protection.
1973                 if (_currentIndex != end) revert();
1974             }
1975         }
1976     }
1977 
1978     /**
1979      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1980      */
1981     function _safeMint(address to, uint256 quantity) internal virtual {
1982         _safeMint(to, quantity, '');
1983     }
1984 
1985     // =============================================================
1986     //                        BURN OPERATIONS
1987     // =============================================================
1988 
1989     /**
1990      * @dev Equivalent to `_burn(tokenId, false)`.
1991      */
1992     function _burn(uint256 tokenId) internal virtual {
1993         _burn(tokenId, false);
1994     }
1995 
1996     /**
1997      * @dev Destroys `tokenId`.
1998      * The approval is cleared when the token is burned.
1999      *
2000      * Requirements:
2001      *
2002      * - `tokenId` must exist.
2003      *
2004      * Emits a {Transfer} event.
2005      */
2006     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2007         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2008 
2009         address from = address(uint160(prevOwnershipPacked));
2010 
2011         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2012 
2013         if (approvalCheck) {
2014             // The nested ifs save around 20+ gas over a compound boolean condition.
2015             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2016                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2017         }
2018 
2019         _beforeTokenTransfers(from, address(0), tokenId, 1);
2020 
2021         // Clear approvals from the previous owner.
2022         assembly {
2023             if approvedAddress {
2024                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2025                 sstore(approvedAddressSlot, 0)
2026             }
2027         }
2028 
2029         // Underflow of the sender's balance is impossible because we check for
2030         // ownership above and the recipient's balance can't realistically overflow.
2031         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2032         unchecked {
2033             // Updates:
2034             // - `balance -= 1`.
2035             // - `numberBurned += 1`.
2036             //
2037             // We can directly decrement the balance, and increment the number burned.
2038             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2039             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2040 
2041             // Updates:
2042             // - `address` to the last owner.
2043             // - `startTimestamp` to the timestamp of burning.
2044             // - `burned` to `true`.
2045             // - `nextInitialized` to `true`.
2046             _packedOwnerships[tokenId] = _packOwnershipData(
2047                 from,
2048                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2049             );
2050 
2051             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2052             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2053                 uint256 nextTokenId = tokenId + 1;
2054                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2055                 if (_packedOwnerships[nextTokenId] == 0) {
2056                     // If the next slot is within bounds.
2057                     if (nextTokenId != _currentIndex) {
2058                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2059                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2060                     }
2061                 }
2062             }
2063         }
2064 
2065         emit Transfer(from, address(0), tokenId);
2066         _afterTokenTransfers(from, address(0), tokenId, 1);
2067 
2068         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2069         unchecked {
2070             _burnCounter++;
2071         }
2072     }
2073 
2074     // =============================================================
2075     //                     EXTRA DATA OPERATIONS
2076     // =============================================================
2077 
2078     /**
2079      * @dev Directly sets the extra data for the ownership data `index`.
2080      */
2081     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2082         uint256 packed = _packedOwnerships[index];
2083         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2084         uint256 extraDataCasted;
2085         // Cast `extraData` with assembly to avoid redundant masking.
2086         assembly {
2087             extraDataCasted := extraData
2088         }
2089         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2090         _packedOwnerships[index] = packed;
2091     }
2092 
2093     /**
2094      * @dev Called during each token transfer to set the 24bit `extraData` field.
2095      * Intended to be overridden by the cosumer contract.
2096      *
2097      * `previousExtraData` - the value of `extraData` before transfer.
2098      *
2099      * Calling conditions:
2100      *
2101      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2102      * transferred to `to`.
2103      * - When `from` is zero, `tokenId` will be minted for `to`.
2104      * - When `to` is zero, `tokenId` will be burned by `from`.
2105      * - `from` and `to` are never both zero.
2106      */
2107     function _extraData(
2108         address from,
2109         address to,
2110         uint24 previousExtraData
2111     ) internal view virtual returns (uint24) {}
2112 
2113     /**
2114      * @dev Returns the next extra data for the packed ownership data.
2115      * The returned result is shifted into position.
2116      */
2117     function _nextExtraData(
2118         address from,
2119         address to,
2120         uint256 prevOwnershipPacked
2121     ) private view returns (uint256) {
2122         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2123         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2124     }
2125 
2126     // =============================================================
2127     //                       OTHER OPERATIONS
2128     // =============================================================
2129 
2130     /**
2131      * @dev Returns the message sender (defaults to `msg.sender`).
2132      *
2133      * If you are writing GSN compatible contracts, you need to override this function.
2134      */
2135     function _msgSenderERC721A() internal view virtual returns (address) {
2136         return msg.sender;
2137     }
2138 
2139     /**
2140      * @dev Converts a uint256 to its ASCII string decimal representation.
2141      */
2142     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2143         assembly {
2144             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2145             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2146             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2147             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2148             let m := add(mload(0x40), 0xa0)
2149             // Update the free memory pointer to allocate.
2150             mstore(0x40, m)
2151             // Assign the `str` to the end.
2152             str := sub(m, 0x20)
2153             // Zeroize the slot after the string.
2154             mstore(str, 0)
2155 
2156             // Cache the end of the memory to calculate the length later.
2157             let end := str
2158 
2159             // We write the string from rightmost digit to leftmost digit.
2160             // The following is essentially a do-while loop that also handles the zero case.
2161             // prettier-ignore
2162             for { let temp := value } 1 {} {
2163                 str := sub(str, 1)
2164                 // Write the character to the pointer.
2165                 // The ASCII index of the '0' character is 48.
2166                 mstore8(str, add(48, mod(temp, 10)))
2167                 // Keep dividing `temp` until zero.
2168                 temp := div(temp, 10)
2169                 // prettier-ignore
2170                 if iszero(temp) { break }
2171             }
2172 
2173             let length := sub(end, str)
2174             // Move the pointer 32 bytes leftwards to make room for the length.
2175             str := sub(str, 0x20)
2176             // Store the length.
2177             mstore(str, length)
2178         }
2179     }
2180 }
2181 
2182 // File: 111.sol
2183 
2184 
2185 pragma solidity ^0.8.9;
2186 
2187 
2188 
2189 
2190 
2191 
2192  
2193  
2194  
2195 contract oxSHB is ERC721A, Ownable, ReentrancyGuard, ERC2981 { 
2196 event DevMintEvent(address ownerAddress, uint256 startWith, uint256 amountMinted);
2197 uint256 public devTotal;
2198     uint256 public _maxSupply = 9999;
2199     uint256 public _mintPrice = 0.002 ether;
2200     uint256 public _maxMintPerTx = 200;
2201  
2202     uint256 public _maxFreeMintPerAddr = 5;
2203     uint256 public _maxFreeMintSupply = 5000;
2204      uint256 public devSupply = 9;
2205  
2206     using Strings for uint256;
2207     string public baseURI;
2208  
2209     mapping(address => uint256) private _mintedFreeAmount;
2210  
2211  
2212     // Royalties
2213     address public royaltyAdd;
2214  
2215     constructor(string memory initBaseURI) ERC721A("0xShibs", "0xSHB") {
2216         baseURI = initBaseURI;
2217         setDefaultRoyalty(msg.sender, 1000); // 10%
2218     }
2219  
2220     // Set default royalty account & percentage
2221     function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public {
2222         royaltyAdd = _receiver;
2223         _setDefaultRoyalty(_receiver, _feeNumerator);
2224     }
2225  
2226     // Set token specific royalty
2227     function setTokenRoyalty(
2228         uint256 tokenId,
2229         uint96 feeNumerator
2230     ) external onlyOwner {
2231         _setTokenRoyalty(tokenId, royaltyAdd, feeNumerator);
2232     }
2233  
2234     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view override returns (address, uint256) {
2235         // Get royalty info from ERC2981 base implementation
2236         (, uint royaltyAmt) = super.royaltyInfo(_tokenId, _salePrice);
2237         // Royalty address is always the one specified in this contract 
2238         return (royaltyAdd, royaltyAmt);
2239     }
2240  
2241     // /**
2242     //  * @dev See {IERC165-supportsInterface}.
2243     //  */
2244     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
2245         return interfaceId == type(IERC2981).interfaceId || 
2246             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2247             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2248             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2249     }
2250  
2251  
2252     function mint(uint256 count) external payable {
2253         uint256 cost = _mintPrice;
2254         bool isFree = ((totalSupply() + count < _maxFreeMintSupply + 1) &&
2255             (_mintedFreeAmount[msg.sender] + count <= _maxFreeMintPerAddr)) ||
2256             (msg.sender == owner());
2257  
2258         if (isFree) {
2259             cost = 0;
2260         }
2261  
2262         require(msg.value >= count * cost, "Please send the exact amount.");
2263         require(totalSupply() + count < _maxSupply - devSupply + 1, "Sold out!");
2264         require(count < _maxMintPerTx + 1, "Max per TX reached.");
2265  
2266         if (isFree) {
2267             _mintedFreeAmount[msg.sender] += count;
2268         }
2269  
2270         _safeMint(msg.sender, count);
2271     }
2272  
2273      function devMint() public onlyOwner {
2274         devTotal += devSupply;
2275         emit DevMintEvent(_msgSender(), devTotal, devSupply);
2276         _safeMint(msg.sender, devSupply);
2277     }
2278  
2279     function _baseURI() internal view virtual override returns (string memory) {
2280         return baseURI;
2281     }
2282  
2283  
2284 function isApprovedForAll(address owner, address operator)
2285         override
2286         public
2287         view
2288         returns (bool)
2289     {
2290         // Block X2Y2
2291         if (operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354) {
2292             return false;
2293         }
2294  
2295  
2296         return super.isApprovedForAll(owner, operator);
2297     }
2298  
2299  
2300  
2301     function tokenURI(uint256 tokenId)
2302         public
2303         view
2304         virtual
2305         override
2306         returns (string memory)
2307     {
2308         require(
2309             _exists(tokenId),
2310             "ERC721Metadata: URI query for nonexistent token"
2311         );
2312         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2313     }
2314  
2315     function setBaseURI(string memory uri) public onlyOwner {
2316         baseURI = uri;
2317     }
2318  
2319     function setFreeAmount(uint256 amount) external onlyOwner {
2320         _maxFreeMintSupply = amount;
2321     }
2322  
2323     function setPrice(uint256 _newPrice) external onlyOwner {
2324         _mintPrice = _newPrice;
2325     }
2326  
2327     function withdraw() public payable onlyOwner nonReentrant {
2328         (bool success, ) = payable(msg.sender).call{
2329             value: address(this).balance
2330         }("");
2331         require(success);
2332     }
2333 }