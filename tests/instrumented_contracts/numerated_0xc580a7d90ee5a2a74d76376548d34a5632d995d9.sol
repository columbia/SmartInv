1 // Sources flattened with hardhat v2.12.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.1
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.1
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.1
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Interface of the ERC165 standard, as defined in the
125  * https://eips.ethereum.org/EIPS/eip-165[EIP].
126  *
127  * Implementers can declare support of contract interfaces, which can then be
128  * queried by others ({ERC165Checker}).
129  *
130  * For an implementation, see {ERC165}.
131  */
132 interface IERC165 {
133     /**
134      * @dev Returns true if this contract implements the interface defined by
135      * `interfaceId`. See the corresponding
136      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
137      * to learn more about how these ids are created.
138      *
139      * This function call must use less than 30 000 gas.
140      */
141     function supportsInterface(bytes4 interfaceId) external view returns (bool);
142 }
143 
144 
145 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.8.1
146 
147 
148 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Interface for the NFT Royalty Standard.
154  *
155  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
156  * support for royalty payments across all NFT marketplaces and ecosystem participants.
157  *
158  * _Available since v4.5._
159  */
160 interface IERC2981 is IERC165 {
161     /**
162      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
163      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
164      */
165     function royaltyInfo(uint256 tokenId, uint256 salePrice)
166         external
167         view
168         returns (address receiver, uint256 royaltyAmount);
169 }
170 
171 
172 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.1
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Implementation of the {IERC165} interface.
181  *
182  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
183  * for the additional interface id that will be supported. For example:
184  *
185  * ```solidity
186  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
187  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
188  * }
189  * ```
190  *
191  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
192  */
193 abstract contract ERC165 is IERC165 {
194     /**
195      * @dev See {IERC165-supportsInterface}.
196      */
197     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
198         return interfaceId == type(IERC165).interfaceId;
199     }
200 }
201 
202 
203 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.8.1
204 
205 
206 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 
211 /**
212  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
213  *
214  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
215  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
216  *
217  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
218  * fee is specified in basis points by default.
219  *
220  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
221  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
222  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
223  *
224  * _Available since v4.5._
225  */
226 abstract contract ERC2981 is IERC2981, ERC165 {
227     struct RoyaltyInfo {
228         address receiver;
229         uint96 royaltyFraction;
230     }
231 
232     RoyaltyInfo private _defaultRoyaltyInfo;
233     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
234 
235     /**
236      * @dev See {IERC165-supportsInterface}.
237      */
238     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
239         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
240     }
241 
242     /**
243      * @inheritdoc IERC2981
244      */
245     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
246         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
247 
248         if (royalty.receiver == address(0)) {
249             royalty = _defaultRoyaltyInfo;
250         }
251 
252         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
253 
254         return (royalty.receiver, royaltyAmount);
255     }
256 
257     /**
258      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
259      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
260      * override.
261      */
262     function _feeDenominator() internal pure virtual returns (uint96) {
263         return 10000;
264     }
265 
266     /**
267      * @dev Sets the royalty information that all ids in this contract will default to.
268      *
269      * Requirements:
270      *
271      * - `receiver` cannot be the zero address.
272      * - `feeNumerator` cannot be greater than the fee denominator.
273      */
274     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
275         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
276         require(receiver != address(0), "ERC2981: invalid receiver");
277 
278         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
279     }
280 
281     /**
282      * @dev Removes default royalty information.
283      */
284     function _deleteDefaultRoyalty() internal virtual {
285         delete _defaultRoyaltyInfo;
286     }
287 
288     /**
289      * @dev Sets the royalty information for a specific token id, overriding the global default.
290      *
291      * Requirements:
292      *
293      * - `receiver` cannot be the zero address.
294      * - `feeNumerator` cannot be greater than the fee denominator.
295      */
296     function _setTokenRoyalty(
297         uint256 tokenId,
298         address receiver,
299         uint96 feeNumerator
300     ) internal virtual {
301         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
302         require(receiver != address(0), "ERC2981: Invalid parameters");
303 
304         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
305     }
306 
307     /**
308      * @dev Resets royalty information for the token id back to the global default.
309      */
310     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
311         delete _tokenRoyaltyInfo[tokenId];
312     }
313 }
314 
315 
316 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.1
317 
318 
319 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Standard math utilities missing in the Solidity language.
325  */
326 library Math {
327     enum Rounding {
328         Down, // Toward negative infinity
329         Up, // Toward infinity
330         Zero // Toward zero
331     }
332 
333     /**
334      * @dev Returns the largest of two numbers.
335      */
336     function max(uint256 a, uint256 b) internal pure returns (uint256) {
337         return a > b ? a : b;
338     }
339 
340     /**
341      * @dev Returns the smallest of two numbers.
342      */
343     function min(uint256 a, uint256 b) internal pure returns (uint256) {
344         return a < b ? a : b;
345     }
346 
347     /**
348      * @dev Returns the average of two numbers. The result is rounded towards
349      * zero.
350      */
351     function average(uint256 a, uint256 b) internal pure returns (uint256) {
352         // (a + b) / 2 can overflow.
353         return (a & b) + (a ^ b) / 2;
354     }
355 
356     /**
357      * @dev Returns the ceiling of the division of two numbers.
358      *
359      * This differs from standard division with `/` in that it rounds up instead
360      * of rounding down.
361      */
362     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
363         // (a + b - 1) / b can overflow on addition, so we distribute.
364         return a == 0 ? 0 : (a - 1) / b + 1;
365     }
366 
367     /**
368      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
369      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
370      * with further edits by Uniswap Labs also under MIT license.
371      */
372     function mulDiv(
373         uint256 x,
374         uint256 y,
375         uint256 denominator
376     ) internal pure returns (uint256 result) {
377         unchecked {
378             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
379             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
380             // variables such that product = prod1 * 2^256 + prod0.
381             uint256 prod0; // Least significant 256 bits of the product
382             uint256 prod1; // Most significant 256 bits of the product
383             assembly {
384                 let mm := mulmod(x, y, not(0))
385                 prod0 := mul(x, y)
386                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
387             }
388 
389             // Handle non-overflow cases, 256 by 256 division.
390             if (prod1 == 0) {
391                 return prod0 / denominator;
392             }
393 
394             // Make sure the result is less than 2^256. Also prevents denominator == 0.
395             require(denominator > prod1);
396 
397             ///////////////////////////////////////////////
398             // 512 by 256 division.
399             ///////////////////////////////////////////////
400 
401             // Make division exact by subtracting the remainder from [prod1 prod0].
402             uint256 remainder;
403             assembly {
404                 // Compute remainder using mulmod.
405                 remainder := mulmod(x, y, denominator)
406 
407                 // Subtract 256 bit number from 512 bit number.
408                 prod1 := sub(prod1, gt(remainder, prod0))
409                 prod0 := sub(prod0, remainder)
410             }
411 
412             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
413             // See https://cs.stackexchange.com/q/138556/92363.
414 
415             // Does not overflow because the denominator cannot be zero at this stage in the function.
416             uint256 twos = denominator & (~denominator + 1);
417             assembly {
418                 // Divide denominator by twos.
419                 denominator := div(denominator, twos)
420 
421                 // Divide [prod1 prod0] by twos.
422                 prod0 := div(prod0, twos)
423 
424                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
425                 twos := add(div(sub(0, twos), twos), 1)
426             }
427 
428             // Shift in bits from prod1 into prod0.
429             prod0 |= prod1 * twos;
430 
431             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
432             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
433             // four bits. That is, denominator * inv = 1 mod 2^4.
434             uint256 inverse = (3 * denominator) ^ 2;
435 
436             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
437             // in modular arithmetic, doubling the correct bits in each step.
438             inverse *= 2 - denominator * inverse; // inverse mod 2^8
439             inverse *= 2 - denominator * inverse; // inverse mod 2^16
440             inverse *= 2 - denominator * inverse; // inverse mod 2^32
441             inverse *= 2 - denominator * inverse; // inverse mod 2^64
442             inverse *= 2 - denominator * inverse; // inverse mod 2^128
443             inverse *= 2 - denominator * inverse; // inverse mod 2^256
444 
445             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
446             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
447             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
448             // is no longer required.
449             result = prod0 * inverse;
450             return result;
451         }
452     }
453 
454     /**
455      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
456      */
457     function mulDiv(
458         uint256 x,
459         uint256 y,
460         uint256 denominator,
461         Rounding rounding
462     ) internal pure returns (uint256) {
463         uint256 result = mulDiv(x, y, denominator);
464         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
465             result += 1;
466         }
467         return result;
468     }
469 
470     /**
471      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
472      *
473      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
474      */
475     function sqrt(uint256 a) internal pure returns (uint256) {
476         if (a == 0) {
477             return 0;
478         }
479 
480         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
481         //
482         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
483         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
484         //
485         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
486         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
487         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
488         //
489         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
490         uint256 result = 1 << (log2(a) >> 1);
491 
492         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
493         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
494         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
495         // into the expected uint128 result.
496         unchecked {
497             result = (result + a / result) >> 1;
498             result = (result + a / result) >> 1;
499             result = (result + a / result) >> 1;
500             result = (result + a / result) >> 1;
501             result = (result + a / result) >> 1;
502             result = (result + a / result) >> 1;
503             result = (result + a / result) >> 1;
504             return min(result, a / result);
505         }
506     }
507 
508     /**
509      * @notice Calculates sqrt(a), following the selected rounding direction.
510      */
511     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
512         unchecked {
513             uint256 result = sqrt(a);
514             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
515         }
516     }
517 
518     /**
519      * @dev Return the log in base 2, rounded down, of a positive value.
520      * Returns 0 if given 0.
521      */
522     function log2(uint256 value) internal pure returns (uint256) {
523         uint256 result = 0;
524         unchecked {
525             if (value >> 128 > 0) {
526                 value >>= 128;
527                 result += 128;
528             }
529             if (value >> 64 > 0) {
530                 value >>= 64;
531                 result += 64;
532             }
533             if (value >> 32 > 0) {
534                 value >>= 32;
535                 result += 32;
536             }
537             if (value >> 16 > 0) {
538                 value >>= 16;
539                 result += 16;
540             }
541             if (value >> 8 > 0) {
542                 value >>= 8;
543                 result += 8;
544             }
545             if (value >> 4 > 0) {
546                 value >>= 4;
547                 result += 4;
548             }
549             if (value >> 2 > 0) {
550                 value >>= 2;
551                 result += 2;
552             }
553             if (value >> 1 > 0) {
554                 result += 1;
555             }
556         }
557         return result;
558     }
559 
560     /**
561      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
562      * Returns 0 if given 0.
563      */
564     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
565         unchecked {
566             uint256 result = log2(value);
567             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
568         }
569     }
570 
571     /**
572      * @dev Return the log in base 10, rounded down, of a positive value.
573      * Returns 0 if given 0.
574      */
575     function log10(uint256 value) internal pure returns (uint256) {
576         uint256 result = 0;
577         unchecked {
578             if (value >= 10**64) {
579                 value /= 10**64;
580                 result += 64;
581             }
582             if (value >= 10**32) {
583                 value /= 10**32;
584                 result += 32;
585             }
586             if (value >= 10**16) {
587                 value /= 10**16;
588                 result += 16;
589             }
590             if (value >= 10**8) {
591                 value /= 10**8;
592                 result += 8;
593             }
594             if (value >= 10**4) {
595                 value /= 10**4;
596                 result += 4;
597             }
598             if (value >= 10**2) {
599                 value /= 10**2;
600                 result += 2;
601             }
602             if (value >= 10**1) {
603                 result += 1;
604             }
605         }
606         return result;
607     }
608 
609     /**
610      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
611      * Returns 0 if given 0.
612      */
613     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
614         unchecked {
615             uint256 result = log10(value);
616             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
617         }
618     }
619 
620     /**
621      * @dev Return the log in base 256, rounded down, of a positive value.
622      * Returns 0 if given 0.
623      *
624      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
625      */
626     function log256(uint256 value) internal pure returns (uint256) {
627         uint256 result = 0;
628         unchecked {
629             if (value >> 128 > 0) {
630                 value >>= 128;
631                 result += 16;
632             }
633             if (value >> 64 > 0) {
634                 value >>= 64;
635                 result += 8;
636             }
637             if (value >> 32 > 0) {
638                 value >>= 32;
639                 result += 4;
640             }
641             if (value >> 16 > 0) {
642                 value >>= 16;
643                 result += 2;
644             }
645             if (value >> 8 > 0) {
646                 result += 1;
647             }
648         }
649         return result;
650     }
651 
652     /**
653      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
654      * Returns 0 if given 0.
655      */
656     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
657         unchecked {
658             uint256 result = log256(value);
659             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
660         }
661     }
662 }
663 
664 
665 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.1
666 
667 
668 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @dev String operations.
674  */
675 library Strings {
676     bytes16 private constant _SYMBOLS = "0123456789abcdef";
677     uint8 private constant _ADDRESS_LENGTH = 20;
678 
679     /**
680      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
681      */
682     function toString(uint256 value) internal pure returns (string memory) {
683         unchecked {
684             uint256 length = Math.log10(value) + 1;
685             string memory buffer = new string(length);
686             uint256 ptr;
687             /// @solidity memory-safe-assembly
688             assembly {
689                 ptr := add(buffer, add(32, length))
690             }
691             while (true) {
692                 ptr--;
693                 /// @solidity memory-safe-assembly
694                 assembly {
695                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
696                 }
697                 value /= 10;
698                 if (value == 0) break;
699             }
700             return buffer;
701         }
702     }
703 
704     /**
705      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
706      */
707     function toHexString(uint256 value) internal pure returns (string memory) {
708         unchecked {
709             return toHexString(value, Math.log256(value) + 1);
710         }
711     }
712 
713     /**
714      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
715      */
716     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
717         bytes memory buffer = new bytes(2 * length + 2);
718         buffer[0] = "0";
719         buffer[1] = "x";
720         for (uint256 i = 2 * length + 1; i > 1; --i) {
721             buffer[i] = _SYMBOLS[value & 0xf];
722             value >>= 4;
723         }
724         require(value == 0, "Strings: hex length insufficient");
725         return string(buffer);
726     }
727 
728     /**
729      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
730      */
731     function toHexString(address addr) internal pure returns (string memory) {
732         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
733     }
734 }
735 
736 
737 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.1
738 
739 
740 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 /**
745  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
746  *
747  * These functions can be used to verify that a message was signed by the holder
748  * of the private keys of a given address.
749  */
750 library ECDSA {
751     enum RecoverError {
752         NoError,
753         InvalidSignature,
754         InvalidSignatureLength,
755         InvalidSignatureS,
756         InvalidSignatureV // Deprecated in v4.8
757     }
758 
759     function _throwError(RecoverError error) private pure {
760         if (error == RecoverError.NoError) {
761             return; // no error: do nothing
762         } else if (error == RecoverError.InvalidSignature) {
763             revert("ECDSA: invalid signature");
764         } else if (error == RecoverError.InvalidSignatureLength) {
765             revert("ECDSA: invalid signature length");
766         } else if (error == RecoverError.InvalidSignatureS) {
767             revert("ECDSA: invalid signature 's' value");
768         }
769     }
770 
771     /**
772      * @dev Returns the address that signed a hashed message (`hash`) with
773      * `signature` or error string. This address can then be used for verification purposes.
774      *
775      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
776      * this function rejects them by requiring the `s` value to be in the lower
777      * half order, and the `v` value to be either 27 or 28.
778      *
779      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
780      * verification to be secure: it is possible to craft signatures that
781      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
782      * this is by receiving a hash of the original message (which may otherwise
783      * be too long), and then calling {toEthSignedMessageHash} on it.
784      *
785      * Documentation for signature generation:
786      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
787      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
788      *
789      * _Available since v4.3._
790      */
791     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
792         if (signature.length == 65) {
793             bytes32 r;
794             bytes32 s;
795             uint8 v;
796             // ecrecover takes the signature parameters, and the only way to get them
797             // currently is to use assembly.
798             /// @solidity memory-safe-assembly
799             assembly {
800                 r := mload(add(signature, 0x20))
801                 s := mload(add(signature, 0x40))
802                 v := byte(0, mload(add(signature, 0x60)))
803             }
804             return tryRecover(hash, v, r, s);
805         } else {
806             return (address(0), RecoverError.InvalidSignatureLength);
807         }
808     }
809 
810     /**
811      * @dev Returns the address that signed a hashed message (`hash`) with
812      * `signature`. This address can then be used for verification purposes.
813      *
814      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
815      * this function rejects them by requiring the `s` value to be in the lower
816      * half order, and the `v` value to be either 27 or 28.
817      *
818      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
819      * verification to be secure: it is possible to craft signatures that
820      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
821      * this is by receiving a hash of the original message (which may otherwise
822      * be too long), and then calling {toEthSignedMessageHash} on it.
823      */
824     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
825         (address recovered, RecoverError error) = tryRecover(hash, signature);
826         _throwError(error);
827         return recovered;
828     }
829 
830     /**
831      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
832      *
833      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
834      *
835      * _Available since v4.3._
836      */
837     function tryRecover(
838         bytes32 hash,
839         bytes32 r,
840         bytes32 vs
841     ) internal pure returns (address, RecoverError) {
842         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
843         uint8 v = uint8((uint256(vs) >> 255) + 27);
844         return tryRecover(hash, v, r, s);
845     }
846 
847     /**
848      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
849      *
850      * _Available since v4.2._
851      */
852     function recover(
853         bytes32 hash,
854         bytes32 r,
855         bytes32 vs
856     ) internal pure returns (address) {
857         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
858         _throwError(error);
859         return recovered;
860     }
861 
862     /**
863      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
864      * `r` and `s` signature fields separately.
865      *
866      * _Available since v4.3._
867      */
868     function tryRecover(
869         bytes32 hash,
870         uint8 v,
871         bytes32 r,
872         bytes32 s
873     ) internal pure returns (address, RecoverError) {
874         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
875         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
876         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
877         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
878         //
879         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
880         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
881         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
882         // these malleable signatures as well.
883         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
884             return (address(0), RecoverError.InvalidSignatureS);
885         }
886 
887         // If the signature is valid (and not malleable), return the signer address
888         address signer = ecrecover(hash, v, r, s);
889         if (signer == address(0)) {
890             return (address(0), RecoverError.InvalidSignature);
891         }
892 
893         return (signer, RecoverError.NoError);
894     }
895 
896     /**
897      * @dev Overload of {ECDSA-recover} that receives the `v`,
898      * `r` and `s` signature fields separately.
899      */
900     function recover(
901         bytes32 hash,
902         uint8 v,
903         bytes32 r,
904         bytes32 s
905     ) internal pure returns (address) {
906         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
907         _throwError(error);
908         return recovered;
909     }
910 
911     /**
912      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
913      * produces hash corresponding to the one signed with the
914      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
915      * JSON-RPC method as part of EIP-191.
916      *
917      * See {recover}.
918      */
919     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
920         // 32 is the length in bytes of hash,
921         // enforced by the type signature above
922         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
923     }
924 
925     /**
926      * @dev Returns an Ethereum Signed Message, created from `s`. This
927      * produces hash corresponding to the one signed with the
928      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
929      * JSON-RPC method as part of EIP-191.
930      *
931      * See {recover}.
932      */
933     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
934         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
935     }
936 
937     /**
938      * @dev Returns an Ethereum Signed Typed Data, created from a
939      * `domainSeparator` and a `structHash`. This produces hash corresponding
940      * to the one signed with the
941      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
942      * JSON-RPC method as part of EIP-712.
943      *
944      * See {recover}.
945      */
946     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
947         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
948     }
949 }
950 
951 
952 // File contracts/IERC721A.sol
953 
954 
955 // ERC721A Contracts v4.2.2
956 // Creator: Chiru Labs
957 
958 pragma solidity ^0.8.4;
959 
960 /**
961  * @dev Interface of ERC721A.
962  */
963 interface IERC721A {
964     /**
965      * The caller must own the token or be an approved operator.
966      */
967     error ApprovalCallerNotOwnerNorApproved();
968 
969     /**
970      * The token does not exist.
971      */
972     error ApprovalQueryForNonexistentToken();
973 
974     /**
975      * The caller cannot approve to their own address.
976      */
977     error ApproveToCaller();
978 
979     /**
980      * Cannot query the balance for the zero address.
981      */
982     error BalanceQueryForZeroAddress();
983 
984     /**
985      * Cannot mint to the zero address.
986      */
987     error MintToZeroAddress();
988 
989     /**
990      * The quantity of tokens minted must be more than zero.
991      */
992     error MintZeroQuantity();
993 
994     /**
995      * The token does not exist.
996      */
997     error OwnerQueryForNonexistentToken();
998 
999     /**
1000      * The caller must own the token or be an approved operator.
1001      */
1002     error TransferCallerNotOwnerNorApproved();
1003 
1004     /**
1005      * The token must be owned by `from`.
1006      */
1007     error TransferFromIncorrectOwner();
1008 
1009     /**
1010      * Cannot safely transfer to a contract that does not implement the
1011      * ERC721Receiver interface.
1012      */
1013     error TransferToNonERC721ReceiverImplementer();
1014 
1015     /**
1016      * Cannot transfer to the zero address.
1017      */
1018     error TransferToZeroAddress();
1019 
1020     /**
1021      * The token does not exist.
1022      */
1023     error URIQueryForNonexistentToken();
1024 
1025     /**
1026      * The `quantity` minted with ERC2309 exceeds the safety limit.
1027      */
1028     error MintERC2309QuantityExceedsLimit();
1029 
1030     /**
1031      * The `extraData` cannot be set on an unintialized ownership slot.
1032      */
1033     error OwnershipNotInitializedForExtraData();
1034 
1035     // =============================================================
1036     //                            STRUCTS
1037     // =============================================================
1038 
1039     struct TokenOwnership {
1040         // The address of the owner.
1041         address addr;
1042         // Stores the start time of ownership with minimal overhead for tokenomics.
1043         uint64 startTimestamp;
1044         // Whether the token has been burned.
1045         bool burned;
1046         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1047         uint24 extraData;
1048     }
1049 
1050     // =============================================================
1051     //                         TOKEN COUNTERS
1052     // =============================================================
1053 
1054     /**
1055      * @dev Returns the total number of tokens in existence.
1056      * Burned tokens will reduce the count.
1057      * To get the total number of tokens minted, please see {_totalMinted}.
1058      */
1059     function totalSupply() external view returns (uint256);
1060 
1061     // =============================================================
1062     //                            IERC165
1063     // =============================================================
1064 
1065     /**
1066      * @dev Returns true if this contract implements the interface defined by
1067      * `interfaceId`. See the corresponding
1068      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1069      * to learn more about how these ids are created.
1070      *
1071      * This function call must use less than 30000 gas.
1072      */
1073     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1074 
1075     // =============================================================
1076     //                            IERC721
1077     // =============================================================
1078 
1079     /**
1080      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1081      */
1082     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1083 
1084     /**
1085      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1086      */
1087     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1088 
1089     /**
1090      * @dev Emitted when `owner` enables or disables
1091      * (`approved`) `operator` to manage all of its assets.
1092      */
1093     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1094 
1095     /**
1096      * @dev Returns the number of tokens in `owner`'s account.
1097      */
1098     function balanceOf(address owner) external view returns (uint256 balance);
1099 
1100     /**
1101      * @dev Returns the owner of the `tokenId` token.
1102      *
1103      * Requirements:
1104      *
1105      * - `tokenId` must exist.
1106      */
1107     function ownerOf(uint256 tokenId) external view returns (address owner);
1108 
1109     /**
1110      * @dev Safely transfers `tokenId` token from `from` to `to`,
1111      * checking first that contract recipients are aware of the ERC721 protocol
1112      * to prevent tokens from being forever locked.
1113      *
1114      * Requirements:
1115      *
1116      * - `from` cannot be the zero address.
1117      * - `to` cannot be the zero address.
1118      * - `tokenId` token must exist and be owned by `from`.
1119      * - If the caller is not `from`, it must be have been allowed to move
1120      * this token by either {approve} or {setApprovalForAll}.
1121      * - If `to` refers to a smart contract, it must implement
1122      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function safeTransferFrom(
1127         address from,
1128         address to,
1129         uint256 tokenId,
1130         bytes calldata data
1131     ) external;
1132 
1133     /**
1134      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1135      */
1136     function safeTransferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) external;
1141 
1142     /**
1143      * @dev Transfers `tokenId` from `from` to `to`.
1144      *
1145      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1146      * whenever possible.
1147      *
1148      * Requirements:
1149      *
1150      * - `from` cannot be the zero address.
1151      * - `to` cannot be the zero address.
1152      * - `tokenId` token must be owned by `from`.
1153      * - If the caller is not `from`, it must be approved to move this token
1154      * by either {approve} or {setApprovalForAll}.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function transferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) external;
1163 
1164     /**
1165      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1166      * The approval is cleared when the token is transferred.
1167      *
1168      * Only a single account can be approved at a time, so approving the
1169      * zero address clears previous approvals.
1170      *
1171      * Requirements:
1172      *
1173      * - The caller must own the token or be an approved operator.
1174      * - `tokenId` must exist.
1175      *
1176      * Emits an {Approval} event.
1177      */
1178     function approve(address to, uint256 tokenId) external;
1179 
1180     /**
1181      * @dev Approve or remove `operator` as an operator for the caller.
1182      * Operators can call {transferFrom} or {safeTransferFrom}
1183      * for any token owned by the caller.
1184      *
1185      * Requirements:
1186      *
1187      * - The `operator` cannot be the caller.
1188      *
1189      * Emits an {ApprovalForAll} event.
1190      */
1191     function setApprovalForAll(address operator, bool _approved) external;
1192 
1193     /**
1194      * @dev Returns the account approved for `tokenId` token.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      */
1200     function getApproved(uint256 tokenId) external view returns (address operator);
1201 
1202     /**
1203      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1204      *
1205      * See {setApprovalForAll}.
1206      */
1207     function isApprovedForAll(address owner, address operator) external view returns (bool);
1208 
1209     // =============================================================
1210     //                        IERC721Metadata
1211     // =============================================================
1212 
1213     /**
1214      * @dev Returns the token collection name.
1215      */
1216     function name() external view returns (string memory);
1217 
1218     /**
1219      * @dev Returns the token collection symbol.
1220      */
1221     function symbol() external view returns (string memory);
1222 
1223     /**
1224      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1225      */
1226     function tokenURI(uint256 tokenId) external view returns (string memory);
1227 
1228     // =============================================================
1229     //                           IERC2309
1230     // =============================================================
1231 
1232     /**
1233      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1234      * (inclusive) is transferred from `from` to `to`, as defined in the
1235      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1236      *
1237      * See {_mintERC2309} for more details.
1238      */
1239     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1240 }
1241 
1242 
1243 // File contracts/ERC721A.sol
1244 
1245 
1246 // ERC721A Contracts v4.2.2
1247 // Creator: Chiru Labs
1248 
1249 pragma solidity ^0.8.4;
1250 
1251 /**
1252  * @dev Interface of ERC721 token receiver.
1253  */
1254 interface ERC721A__IERC721Receiver {
1255     function onERC721Received(
1256         address operator,
1257         address from,
1258         uint256 tokenId,
1259         bytes calldata data
1260     ) external returns (bytes4);
1261 }
1262 
1263 /**
1264  * @title ERC721A
1265  *
1266  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1267  * Non-Fungible Token Standard, including the Metadata extension.
1268  * Optimized for lower gas during batch mints.
1269  *
1270  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1271  * starting from `_startTokenId()`.
1272  *
1273  * Assumptions:
1274  *
1275  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1276  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1277  */
1278 contract ERC721A is IERC721A {
1279     // Reference type for token approval.
1280     struct TokenApprovalRef {
1281         address value;
1282     }
1283 
1284     // =============================================================
1285     //                           CONSTANTS
1286     // =============================================================
1287 
1288     // Mask of an entry in packed address data.
1289     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1290 
1291     // The bit position of `numberMinted` in packed address data.
1292     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1293 
1294     // The bit position of `numberBurned` in packed address data.
1295     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1296 
1297     // The bit position of `aux` in packed address data.
1298     uint256 private constant _BITPOS_AUX = 192;
1299 
1300     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1301     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1302 
1303     // The bit position of `startTimestamp` in packed ownership.
1304     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1305 
1306     // The bit mask of the `burned` bit in packed ownership.
1307     uint256 private constant _BITMASK_BURNED = 1 << 224;
1308 
1309     // The bit position of the `nextInitialized` bit in packed ownership.
1310     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1311 
1312     // The bit mask of the `nextInitialized` bit in packed ownership.
1313     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1314 
1315     // The bit position of `extraData` in packed ownership.
1316     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1317 
1318     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1319     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1320 
1321     // The mask of the lower 160 bits for addresses.
1322     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1323 
1324     // The maximum `quantity` that can be minted with {_mintERC2309}.
1325     // This limit is to prevent overflows on the address data entries.
1326     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1327     // is required to cause an overflow, which is unrealistic.
1328     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1329 
1330     // The `Transfer` event signature is given by:
1331     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1332     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1333         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1334 
1335     // =============================================================
1336     //                            STORAGE
1337     // =============================================================
1338 
1339     // The next token ID to be minted.
1340     uint256 private _currentIndex;
1341 
1342     // The number of tokens burned.
1343     uint256 private _burnCounter;
1344 
1345     // Token name
1346     string private _name;
1347 
1348     // Token symbol
1349     string private _symbol;
1350 
1351     // Mapping from token ID to ownership details
1352     // An empty struct value does not necessarily mean the token is unowned.
1353     // See {_packedOwnershipOf} implementation for details.
1354     //
1355     // Bits Layout:
1356     // - [0..159]   `addr`
1357     // - [160..223] `startTimestamp`
1358     // - [224]      `burned`
1359     // - [225]      `nextInitialized`
1360     // - [232..255] `extraData`
1361     mapping(uint256 => uint256) private _packedOwnerships;
1362 
1363     // Mapping owner address to address data.
1364     //
1365     // Bits Layout:
1366     // - [0..63]    `balance`
1367     // - [64..127]  `numberMinted`
1368     // - [128..191] `numberBurned`
1369     // - [192..255] `aux`
1370     mapping(address => uint256) private _packedAddressData;
1371 
1372     // Mapping from token ID to approved address.
1373     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1374 
1375     // Mapping from owner to operator approvals
1376     mapping(address => mapping(address => bool)) private _operatorApprovals;
1377 
1378     // =============================================================
1379     //                          CONSTRUCTOR
1380     // =============================================================
1381 
1382     constructor(string memory name_, string memory symbol_) {
1383         _name = name_;
1384         _symbol = symbol_;
1385         _currentIndex = _startTokenId();
1386     }
1387 
1388     // =============================================================
1389     //                   TOKEN COUNTING OPERATIONS
1390     // =============================================================
1391 
1392     /**
1393      * @dev Returns the starting token ID.
1394      * To change the starting token ID, please override this function.
1395      */
1396     function _startTokenId() internal view virtual returns (uint256) {
1397         return 0;
1398     }
1399 
1400     /**
1401      * @dev Returns the next token ID to be minted.
1402      */
1403     function _nextTokenId() internal view virtual returns (uint256) {
1404         return _currentIndex;
1405     }
1406 
1407     /**
1408      * @dev Returns the total number of tokens in existence.
1409      * Burned tokens will reduce the count.
1410      * To get the total number of tokens minted, please see {_totalMinted}.
1411      */
1412     function totalSupply() public view virtual override returns (uint256) {
1413         // Counter underflow is impossible as _burnCounter cannot be incremented
1414         // more than `_currentIndex - _startTokenId()` times.
1415         unchecked {
1416             return _currentIndex - _burnCounter - _startTokenId();
1417         }
1418     }
1419 
1420     /**
1421      * @dev Returns the total amount of tokens minted in the contract.
1422      */
1423     function _totalMinted() internal view virtual returns (uint256) {
1424         // Counter underflow is impossible as `_currentIndex` does not decrement,
1425         // and it is initialized to `_startTokenId()`.
1426         unchecked {
1427             return _currentIndex - _startTokenId();
1428         }
1429     }
1430 
1431     /**
1432      * @dev Returns the total number of tokens burned.
1433      */
1434     function _totalBurned() internal view virtual returns (uint256) {
1435         return _burnCounter;
1436     }
1437 
1438     // =============================================================
1439     //                    ADDRESS DATA OPERATIONS
1440     // =============================================================
1441 
1442     /**
1443      * @dev Returns the number of tokens in `owner`'s account.
1444      */
1445     function balanceOf(address owner) public view virtual override returns (uint256) {
1446         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1447         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1448     }
1449 
1450     /**
1451      * Returns the number of tokens minted by `owner`.
1452      */
1453     function _numberMinted(address owner) internal view returns (uint256) {
1454         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1455     }
1456 
1457     /**
1458      * Returns the number of tokens burned by or on behalf of `owner`.
1459      */
1460     function _numberBurned(address owner) internal view returns (uint256) {
1461         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1462     }
1463 
1464     /**
1465      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1466      */
1467     function _getAux(address owner) internal view returns (uint64) {
1468         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1469     }
1470 
1471     /**
1472      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1473      * If there are multiple variables, please pack them into a uint64.
1474      */
1475     function _setAux(address owner, uint64 aux) internal virtual {
1476         uint256 packed = _packedAddressData[owner];
1477         uint256 auxCasted;
1478         // Cast `aux` with assembly to avoid redundant masking.
1479         assembly {
1480             auxCasted := aux
1481         }
1482         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1483         _packedAddressData[owner] = packed;
1484     }
1485 
1486     // =============================================================
1487     //                            IERC165
1488     // =============================================================
1489 
1490     /**
1491      * @dev Returns true if this contract implements the interface defined by
1492      * `interfaceId`. See the corresponding
1493      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1494      * to learn more about how these ids are created.
1495      *
1496      * This function call must use less than 30000 gas.
1497      */
1498     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1499         // The interface IDs are constants representing the first 4 bytes
1500         // of the XOR of all function selectors in the interface.
1501         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1502         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1503         return
1504             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1505             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1506             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1507     }
1508 
1509     // =============================================================
1510     //                        IERC721Metadata
1511     // =============================================================
1512 
1513     /**
1514      * @dev Returns the token collection name.
1515      */
1516     function name() public view virtual override returns (string memory) {
1517         return _name;
1518     }
1519 
1520     /**
1521      * @dev Returns the token collection symbol.
1522      */
1523     function symbol() public view virtual override returns (string memory) {
1524         return _symbol;
1525     }
1526 
1527     /**
1528      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1529      */
1530     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1531         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1532 
1533         string memory baseURI = _baseURI();
1534         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1535     }
1536 
1537     /**
1538      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1539      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1540      * by default, it can be overridden in child contracts.
1541      */
1542     function _baseURI() internal view virtual returns (string memory) {
1543         return '';
1544     }
1545 
1546     // =============================================================
1547     //                     OWNERSHIPS OPERATIONS
1548     // =============================================================
1549 
1550     /**
1551      * @dev Returns the owner of the `tokenId` token.
1552      *
1553      * Requirements:
1554      *
1555      * - `tokenId` must exist.
1556      */
1557     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1558         return address(uint160(_packedOwnershipOf(tokenId)));
1559     }
1560 
1561     /**
1562      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1563      * It gradually moves to O(1) as tokens get transferred around over time.
1564      */
1565     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1566         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1567     }
1568 
1569     /**
1570      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1571      */
1572     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1573         return _unpackedOwnership(_packedOwnerships[index]);
1574     }
1575 
1576     /**
1577      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1578      */
1579     function _initializeOwnershipAt(uint256 index) internal virtual {
1580         if (_packedOwnerships[index] == 0) {
1581             _packedOwnerships[index] = _packedOwnershipOf(index);
1582         }
1583     }
1584 
1585     /**
1586      * Returns the packed ownership data of `tokenId`.
1587      */
1588     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1589         uint256 curr = tokenId;
1590 
1591         unchecked {
1592             if (_startTokenId() <= curr)
1593                 if (curr < _currentIndex) {
1594                     uint256 packed = _packedOwnerships[curr];
1595                     // If not burned.
1596                     if (packed & _BITMASK_BURNED == 0) {
1597                         // Invariant:
1598                         // There will always be an initialized ownership slot
1599                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1600                         // before an unintialized ownership slot
1601                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1602                         // Hence, `curr` will not underflow.
1603                         //
1604                         // We can directly compare the packed value.
1605                         // If the address is zero, packed will be zero.
1606                         while (packed == 0) {
1607                             packed = _packedOwnerships[--curr];
1608                         }
1609                         return packed;
1610                     }
1611                 }
1612         }
1613         revert OwnerQueryForNonexistentToken();
1614     }
1615 
1616     /**
1617      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1618      */
1619     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1620         ownership.addr = address(uint160(packed));
1621         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1622         ownership.burned = packed & _BITMASK_BURNED != 0;
1623         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1624     }
1625 
1626     /**
1627      * @dev Packs ownership data into a single uint256.
1628      */
1629     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1630         assembly {
1631             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1632             owner := and(owner, _BITMASK_ADDRESS)
1633             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1634             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1635         }
1636     }
1637 
1638     /**
1639      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1640      */
1641     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1642         // For branchless setting of the `nextInitialized` flag.
1643         assembly {
1644             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1645             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1646         }
1647     }
1648 
1649     // =============================================================
1650     //                      APPROVAL OPERATIONS
1651     // =============================================================
1652 
1653     /**
1654      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1655      * The approval is cleared when the token is transferred.
1656      *
1657      * Only a single account can be approved at a time, so approving the
1658      * zero address clears previous approvals.
1659      *
1660      * Requirements:
1661      *
1662      * - The caller must own the token or be an approved operator.
1663      * - `tokenId` must exist.
1664      *
1665      * Emits an {Approval} event.
1666      */
1667     function approve(address to, uint256 tokenId) public virtual override {
1668         address owner = ownerOf(tokenId);
1669 
1670         if (_msgSenderERC721A() != owner)
1671             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1672                 revert ApprovalCallerNotOwnerNorApproved();
1673             }
1674 
1675         _tokenApprovals[tokenId].value = to;
1676         emit Approval(owner, to, tokenId);
1677     }
1678 
1679     /**
1680      * @dev Returns the account approved for `tokenId` token.
1681      *
1682      * Requirements:
1683      *
1684      * - `tokenId` must exist.
1685      */
1686     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1687         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1688 
1689         return _tokenApprovals[tokenId].value;
1690     }
1691 
1692     /**
1693      * @dev Approve or remove `operator` as an operator for the caller.
1694      * Operators can call {transferFrom} or {safeTransferFrom}
1695      * for any token owned by the caller.
1696      *
1697      * Requirements:
1698      *
1699      * - The `operator` cannot be the caller.
1700      *
1701      * Emits an {ApprovalForAll} event.
1702      */
1703     function setApprovalForAll(address operator, bool approved) public virtual override {
1704         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1705 
1706         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1707         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1708     }
1709 
1710     /**
1711      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1712      *
1713      * See {setApprovalForAll}.
1714      */
1715     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1716         return _operatorApprovals[owner][operator];
1717     }
1718 
1719     /**
1720      * @dev Returns whether `tokenId` exists.
1721      *
1722      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1723      *
1724      * Tokens start existing when they are minted. See {_mint}.
1725      */
1726     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1727         return
1728             _startTokenId() <= tokenId &&
1729             tokenId < _currentIndex && // If within bounds,
1730             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1731     }
1732 
1733     /**
1734      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1735      */
1736     function _isSenderApprovedOrOwner(
1737         address approvedAddress,
1738         address owner,
1739         address msgSender
1740     ) private pure returns (bool result) {
1741         assembly {
1742             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1743             owner := and(owner, _BITMASK_ADDRESS)
1744             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1745             msgSender := and(msgSender, _BITMASK_ADDRESS)
1746             // `msgSender == owner || msgSender == approvedAddress`.
1747             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1748         }
1749     }
1750 
1751     /**
1752      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1753      */
1754     function _getApprovedSlotAndAddress(uint256 tokenId)
1755         private
1756         view
1757         returns (uint256 approvedAddressSlot, address approvedAddress)
1758     {
1759         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1760         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1761         assembly {
1762             approvedAddressSlot := tokenApproval.slot
1763             approvedAddress := sload(approvedAddressSlot)
1764         }
1765     }
1766 
1767     // =============================================================
1768     //                      TRANSFER OPERATIONS
1769     // =============================================================
1770 
1771     /**
1772      * @dev Transfers `tokenId` from `from` to `to`.
1773      *
1774      * Requirements:
1775      *
1776      * - `from` cannot be the zero address.
1777      * - `to` cannot be the zero address.
1778      * - `tokenId` token must be owned by `from`.
1779      * - If the caller is not `from`, it must be approved to move this token
1780      * by either {approve} or {setApprovalForAll}.
1781      *
1782      * Emits a {Transfer} event.
1783      */
1784     function transferFrom(
1785         address from,
1786         address to,
1787         uint256 tokenId
1788     ) public virtual override {
1789         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1790 
1791         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1792 
1793         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1794 
1795         // The nested ifs save around 20+ gas over a compound boolean condition.
1796         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1797             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1798 
1799         if (to == address(0)) revert TransferToZeroAddress();
1800 
1801         _beforeTokenTransfers(from, to, tokenId, 1);
1802 
1803         // Clear approvals from the previous owner.
1804         assembly {
1805             if approvedAddress {
1806                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1807                 sstore(approvedAddressSlot, 0)
1808             }
1809         }
1810 
1811         // Underflow of the sender's balance is impossible because we check for
1812         // ownership above and the recipient's balance can't realistically overflow.
1813         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1814         unchecked {
1815             // We can directly increment and decrement the balances.
1816             --_packedAddressData[from]; // Updates: `balance -= 1`.
1817             ++_packedAddressData[to]; // Updates: `balance += 1`.
1818 
1819             // Updates:
1820             // - `address` to the next owner.
1821             // - `startTimestamp` to the timestamp of transfering.
1822             // - `burned` to `false`.
1823             // - `nextInitialized` to `true`.
1824             _packedOwnerships[tokenId] = _packOwnershipData(
1825                 to,
1826                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1827             );
1828 
1829             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1830             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1831                 uint256 nextTokenId = tokenId + 1;
1832                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1833                 if (_packedOwnerships[nextTokenId] == 0) {
1834                     // If the next slot is within bounds.
1835                     if (nextTokenId != _currentIndex) {
1836                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1837                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1838                     }
1839                 }
1840             }
1841         }
1842 
1843         emit Transfer(from, to, tokenId);
1844         _afterTokenTransfers(from, to, tokenId, 1);
1845     }
1846 
1847     /**
1848      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1849      */
1850     function safeTransferFrom(
1851         address from,
1852         address to,
1853         uint256 tokenId
1854     ) public virtual override {
1855         safeTransferFrom(from, to, tokenId, '');
1856     }
1857 
1858     /**
1859      * @dev Safely transfers `tokenId` token from `from` to `to`.
1860      *
1861      * Requirements:
1862      *
1863      * - `from` cannot be the zero address.
1864      * - `to` cannot be the zero address.
1865      * - `tokenId` token must exist and be owned by `from`.
1866      * - If the caller is not `from`, it must be approved to move this token
1867      * by either {approve} or {setApprovalForAll}.
1868      * - If `to` refers to a smart contract, it must implement
1869      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1870      *
1871      * Emits a {Transfer} event.
1872      */
1873     function safeTransferFrom(
1874         address from,
1875         address to,
1876         uint256 tokenId,
1877         bytes memory _data
1878     ) public virtual override {
1879         transferFrom(from, to, tokenId);
1880         if (to.code.length != 0)
1881             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1882                 revert TransferToNonERC721ReceiverImplementer();
1883             }
1884     }
1885 
1886     /**
1887      * @dev Hook that is called before a set of serially-ordered token IDs
1888      * are about to be transferred. This includes minting.
1889      * And also called before burning one token.
1890      *
1891      * `startTokenId` - the first token ID to be transferred.
1892      * `quantity` - the amount to be transferred.
1893      *
1894      * Calling conditions:
1895      *
1896      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1897      * transferred to `to`.
1898      * - When `from` is zero, `tokenId` will be minted for `to`.
1899      * - When `to` is zero, `tokenId` will be burned by `from`.
1900      * - `from` and `to` are never both zero.
1901      */
1902     function _beforeTokenTransfers(
1903         address from,
1904         address to,
1905         uint256 startTokenId,
1906         uint256 quantity
1907     ) internal virtual {}
1908 
1909     /**
1910      * @dev Hook that is called after a set of serially-ordered token IDs
1911      * have been transferred. This includes minting.
1912      * And also called after one token has been burned.
1913      *
1914      * `startTokenId` - the first token ID to be transferred.
1915      * `quantity` - the amount to be transferred.
1916      *
1917      * Calling conditions:
1918      *
1919      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1920      * transferred to `to`.
1921      * - When `from` is zero, `tokenId` has been minted for `to`.
1922      * - When `to` is zero, `tokenId` has been burned by `from`.
1923      * - `from` and `to` are never both zero.
1924      */
1925     function _afterTokenTransfers(
1926         address from,
1927         address to,
1928         uint256 startTokenId,
1929         uint256 quantity
1930     ) internal virtual {}
1931 
1932     /**
1933      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1934      *
1935      * `from` - Previous owner of the given token ID.
1936      * `to` - Target address that will receive the token.
1937      * `tokenId` - Token ID to be transferred.
1938      * `_data` - Optional data to send along with the call.
1939      *
1940      * Returns whether the call correctly returned the expected magic value.
1941      */
1942     function _checkContractOnERC721Received(
1943         address from,
1944         address to,
1945         uint256 tokenId,
1946         bytes memory _data
1947     ) private returns (bool) {
1948         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1949             bytes4 retval
1950         ) {
1951             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1952         } catch (bytes memory reason) {
1953             if (reason.length == 0) {
1954                 revert TransferToNonERC721ReceiverImplementer();
1955             } else {
1956                 assembly {
1957                     revert(add(32, reason), mload(reason))
1958                 }
1959             }
1960         }
1961     }
1962 
1963     // =============================================================
1964     //                        MINT OPERATIONS
1965     // =============================================================
1966 
1967     /**
1968      * @dev Mints `quantity` tokens and transfers them to `to`.
1969      *
1970      * Requirements:
1971      *
1972      * - `to` cannot be the zero address.
1973      * - `quantity` must be greater than 0.
1974      *
1975      * Emits a {Transfer} event for each mint.
1976      */
1977     function _mint(address to, uint256 quantity) internal virtual {
1978         uint256 startTokenId = _currentIndex;
1979         if (quantity == 0) revert MintZeroQuantity();
1980 
1981         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1982 
1983         // Overflows are incredibly unrealistic.
1984         // `balance` and `numberMinted` have a maximum limit of 2**64.
1985         // `tokenId` has a maximum limit of 2**256.
1986         unchecked {
1987             // Updates:
1988             // - `balance += quantity`.
1989             // - `numberMinted += quantity`.
1990             //
1991             // We can directly add to the `balance` and `numberMinted`.
1992             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1993 
1994             // Updates:
1995             // - `address` to the owner.
1996             // - `startTimestamp` to the timestamp of minting.
1997             // - `burned` to `false`.
1998             // - `nextInitialized` to `quantity == 1`.
1999             _packedOwnerships[startTokenId] = _packOwnershipData(
2000                 to,
2001                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2002             );
2003 
2004             uint256 toMasked;
2005             uint256 end = startTokenId + quantity;
2006 
2007             // Use assembly to loop and emit the `Transfer` event for gas savings.
2008             // The duplicated `log4` removes an extra check and reduces stack juggling.
2009             // The assembly, together with the surrounding Solidity code, have been
2010             // delicately arranged to nudge the compiler into producing optimized opcodes.
2011             assembly {
2012                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2013                 toMasked := and(to, _BITMASK_ADDRESS)
2014                 // Emit the `Transfer` event.
2015                 log4(
2016                     0, // Start of data (0, since no data).
2017                     0, // End of data (0, since no data).
2018                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2019                     0, // `address(0)`.
2020                     toMasked, // `to`.
2021                     startTokenId // `tokenId`.
2022                 )
2023 
2024                 for {
2025                     let tokenId := add(startTokenId, 1)
2026                 } iszero(eq(tokenId, end)) {
2027                     tokenId := add(tokenId, 1)
2028                 } {
2029                     // Emit the `Transfer` event. Similar to above.
2030                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2031                 }
2032             }
2033             if (toMasked == 0) revert MintToZeroAddress();
2034 
2035             _currentIndex = end;
2036         }
2037         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2038     }
2039 
2040     /**
2041      * @dev Mints `quantity` tokens and transfers them to `to`.
2042      *
2043      * This function is intended for efficient minting only during contract creation.
2044      *
2045      * It emits only one {ConsecutiveTransfer} as defined in
2046      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2047      * instead of a sequence of {Transfer} event(s).
2048      *
2049      * Calling this function outside of contract creation WILL make your contract
2050      * non-compliant with the ERC721 standard.
2051      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2052      * {ConsecutiveTransfer} event is only permissible during contract creation.
2053      *
2054      * Requirements:
2055      *
2056      * - `to` cannot be the zero address.
2057      * - `quantity` must be greater than 0.
2058      *
2059      * Emits a {ConsecutiveTransfer} event.
2060      */
2061     function _mintERC2309(address to, uint256 quantity) internal virtual {
2062         uint256 startTokenId = _currentIndex;
2063         if (to == address(0)) revert MintToZeroAddress();
2064         if (quantity == 0) revert MintZeroQuantity();
2065         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2066 
2067         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2068 
2069         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2070         unchecked {
2071             // Updates:
2072             // - `balance += quantity`.
2073             // - `numberMinted += quantity`.
2074             //
2075             // We can directly add to the `balance` and `numberMinted`.
2076             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2077 
2078             // Updates:
2079             // - `address` to the owner.
2080             // - `startTimestamp` to the timestamp of minting.
2081             // - `burned` to `false`.
2082             // - `nextInitialized` to `quantity == 1`.
2083             _packedOwnerships[startTokenId] = _packOwnershipData(
2084                 to,
2085                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2086             );
2087 
2088             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2089 
2090             _currentIndex = startTokenId + quantity;
2091         }
2092         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2093     }
2094 
2095     /**
2096      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2097      *
2098      * Requirements:
2099      *
2100      * - If `to` refers to a smart contract, it must implement
2101      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2102      * - `quantity` must be greater than 0.
2103      *
2104      * See {_mint}.
2105      *
2106      * Emits a {Transfer} event for each mint.
2107      */
2108     function _safeMint(
2109         address to,
2110         uint256 quantity,
2111         bytes memory _data
2112     ) internal virtual {
2113         _mint(to, quantity);
2114 
2115         unchecked {
2116             if (to.code.length != 0) {
2117                 uint256 end = _currentIndex;
2118                 uint256 index = end - quantity;
2119                 do {
2120                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2121                         revert TransferToNonERC721ReceiverImplementer();
2122                     }
2123                 } while (index < end);
2124                 // Reentrancy protection.
2125                 if (_currentIndex != end) revert();
2126             }
2127         }
2128     }
2129 
2130     /**
2131      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2132      */
2133     function _safeMint(address to, uint256 quantity) internal virtual {
2134         _safeMint(to, quantity, '');
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
2168                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
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
2235         if (packed == 0) revert OwnershipNotInitializedForExtraData();
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
2296             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2297             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
2298             // We will need 1 32-byte word to store the length,
2299             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
2300             str := add(mload(0x40), 0x80)
2301             // Update the free memory pointer to allocate.
2302             mstore(0x40, str)
2303 
2304             // Cache the end of the memory to calculate the length later.
2305             let end := str
2306 
2307             // We write the string from rightmost digit to leftmost digit.
2308             // The following is essentially a do-while loop that also handles the zero case.
2309             // prettier-ignore
2310             for { let temp := value } 1 {} {
2311                 str := sub(str, 1)
2312                 // Write the character to the pointer.
2313                 // The ASCII index of the '0' character is 48.
2314                 mstore8(str, add(48, mod(temp, 10)))
2315                 // Keep dividing `temp` until zero.
2316                 temp := div(temp, 10)
2317                 // prettier-ignore
2318                 if iszero(temp) { break }
2319             }
2320 
2321             let length := sub(end, str)
2322             // Move the pointer 32 bytes leftwards to make room for the length.
2323             str := sub(str, 0x20)
2324             // Store the length.
2325             mstore(str, length)
2326         }
2327     }
2328 }
2329 
2330 
2331 // File contracts/extensions/IERC4907A.sol
2332 
2333 
2334 // ERC721A Contracts v4.2.2
2335 // Creator: Chiru Labs
2336 
2337 pragma solidity ^0.8.4;
2338 
2339 /**
2340  * @dev Interface of ERC4907A.
2341  */
2342 interface IERC4907A is IERC721A {
2343     /**
2344      * The caller must own the token or be an approved operator.
2345      */
2346     error SetUserCallerNotOwnerNorApproved();
2347 
2348     /**
2349      * @dev Emitted when the `user` of an NFT or the `expires` of the `user` is changed.
2350      * The zero address for user indicates that there is no user address.
2351      */
2352     event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);
2353 
2354     /**
2355      * @dev Sets the `user` and `expires` for `tokenId`.
2356      * The zero address indicates there is no user.
2357      *
2358      * Requirements:
2359      *
2360      * - The caller must own `tokenId` or be an approved operator.
2361      */
2362     function setUser(
2363         uint256 tokenId,
2364         address user,
2365         uint64 expires
2366     ) external;
2367 
2368     /**
2369      * @dev Returns the user address for `tokenId`.
2370      * The zero address indicates that there is no user or if the user is expired.
2371      */
2372     function userOf(uint256 tokenId) external view returns (address);
2373 
2374     /**
2375      * @dev Returns the user's expires of `tokenId`.
2376      */
2377     function userExpires(uint256 tokenId) external view returns (uint256);
2378 }
2379 
2380 
2381 // File contracts/extensions/ERC4907A.sol
2382 
2383 
2384 // ERC721A Contracts v4.2.2
2385 // Creator: Chiru Labs
2386 
2387 pragma solidity ^0.8.4;
2388 
2389 
2390 /**
2391  * @title ERC4907A
2392  *
2393  * @dev [ERC4907](https://eips.ethereum.org/EIPS/eip-4907) compliant
2394  * extension of ERC721A, which allows owners and authorized addresses
2395  * to add a time-limited role with restricted permissions to ERC721 tokens.
2396  */
2397 abstract contract ERC4907A is ERC721A, IERC4907A {
2398     // The bit position of `expires` in packed user info.
2399     uint256 private constant _BITPOS_EXPIRES = 160;
2400 
2401     // Mapping from token ID to user info.
2402     //
2403     // Bits Layout:
2404     // - [0..159]   `user`
2405     // - [160..223] `expires`
2406     mapping(uint256 => uint256) private _packedUserInfo;
2407 
2408     /**
2409      * @dev Sets the `user` and `expires` for `tokenId`.
2410      * The zero address indicates there is no user.
2411      *
2412      * Requirements:
2413      *
2414      * - The caller must own `tokenId` or be an approved operator.
2415      */
2416     function setUser(
2417         uint256 tokenId,
2418         address user,
2419         uint64 expires
2420     ) public virtual override {
2421         // Require the caller to be either the token owner or an approved operator.
2422         address owner = ownerOf(tokenId);
2423         if (_msgSenderERC721A() != owner)
2424             if (!isApprovedForAll(owner, _msgSenderERC721A()))
2425                 if (getApproved(tokenId) != _msgSenderERC721A()) revert SetUserCallerNotOwnerNorApproved();
2426 
2427         _packedUserInfo[tokenId] = (uint256(expires) << _BITPOS_EXPIRES) | uint256(uint160(user));
2428 
2429         emit UpdateUser(tokenId, user, expires);
2430     }
2431 
2432     /**
2433      * @dev Returns the user address for `tokenId`.
2434      * The zero address indicates that there is no user or if the user is expired.
2435      */
2436     function userOf(uint256 tokenId) public view virtual override returns (address) {
2437         uint256 packed = _packedUserInfo[tokenId];
2438         assembly {
2439             // Branchless `packed *= (block.timestamp <= expires ? 1 : 0)`.
2440             // If the `block.timestamp == expires`, the `lt` clause will be true
2441             // if there is a non-zero user address in the lower 160 bits of `packed`.
2442             packed := mul(
2443                 packed,
2444                 // `block.timestamp <= expires ? 1 : 0`.
2445                 lt(shl(_BITPOS_EXPIRES, timestamp()), packed)
2446             )
2447         }
2448         return address(uint160(packed));
2449     }
2450 
2451     /**
2452      * @dev Returns the user's expires of `tokenId`.
2453      */
2454     function userExpires(uint256 tokenId) public view virtual override returns (uint256) {
2455         return _packedUserInfo[tokenId] >> _BITPOS_EXPIRES;
2456     }
2457 
2458     /**
2459      * @dev Override of {IERC165-supportsInterface}.
2460      */
2461     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC721A) returns (bool) {
2462         // The interface ID for ERC4907 is `0xad092b5c`,
2463         // as defined in [ERC4907](https://eips.ethereum.org/EIPS/eip-4907).
2464         return super.supportsInterface(interfaceId) || interfaceId == 0xad092b5c;
2465     }
2466 
2467     /**
2468      * @dev Returns the user address for `tokenId`, ignoring the expiry status.
2469      */
2470     function _explicitUserOf(uint256 tokenId) internal view virtual returns (address) {
2471         return address(uint160(_packedUserInfo[tokenId]));
2472     }
2473 }
2474 
2475 
2476 // File contracts/extensions/IERC721ABurnable.sol
2477 
2478 
2479 // ERC721A Contracts v4.2.2
2480 // Creator: Chiru Labs
2481 
2482 pragma solidity ^0.8.4;
2483 
2484 /**
2485  * @dev Interface of ERC721ABurnable.
2486  */
2487 interface IERC721ABurnable is IERC721A {
2488     /**
2489      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2490      *
2491      * Requirements:
2492      *
2493      * - The caller must own `tokenId` or be an approved operator.
2494      */
2495     function burn(uint256 tokenId) external;
2496 }
2497 
2498 
2499 // File contracts/extensions/ERC721ABurnable.sol
2500 
2501 
2502 // ERC721A Contracts v4.2.2
2503 // Creator: Chiru Labs
2504 
2505 pragma solidity ^0.8.4;
2506 
2507 
2508 /**
2509  * @title ERC721ABurnable.
2510  *
2511  * @dev ERC721A token that can be irreversibly burned (destroyed).
2512  */
2513 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
2514     /**
2515      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2516      *
2517      * Requirements:
2518      *
2519      * - The caller must own `tokenId` or be an approved operator.
2520      */
2521     function burn(uint256 tokenId) public virtual override {
2522         _burn(tokenId, true);
2523     }
2524 }
2525 
2526 
2527 // File contracts/extensions/IERC721AQueryable.sol
2528 
2529 
2530 // ERC721A Contracts v4.2.2
2531 // Creator: Chiru Labs
2532 
2533 pragma solidity ^0.8.4;
2534 
2535 /**
2536  * @dev Interface of ERC721AQueryable.
2537  */
2538 interface IERC721AQueryable is IERC721A {
2539     /**
2540      * Invalid query range (`start` >= `stop`).
2541      */
2542     error InvalidQueryRange();
2543 
2544     /**
2545      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2546      *
2547      * If the `tokenId` is out of bounds:
2548      *
2549      * - `addr = address(0)`
2550      * - `startTimestamp = 0`
2551      * - `burned = false`
2552      * - `extraData = 0`
2553      *
2554      * If the `tokenId` is burned:
2555      *
2556      * - `addr = <Address of owner before token was burned>`
2557      * - `startTimestamp = <Timestamp when token was burned>`
2558      * - `burned = true`
2559      * - `extraData = <Extra data when token was burned>`
2560      *
2561      * Otherwise:
2562      *
2563      * - `addr = <Address of owner>`
2564      * - `startTimestamp = <Timestamp of start of ownership>`
2565      * - `burned = false`
2566      * - `extraData = <Extra data at start of ownership>`
2567      */
2568     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2569 
2570     /**
2571      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2572      * See {ERC721AQueryable-explicitOwnershipOf}
2573      */
2574     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2575 
2576     /**
2577      * @dev Returns an array of token IDs owned by `owner`,
2578      * in the range [`start`, `stop`)
2579      * (i.e. `start <= tokenId < stop`).
2580      *
2581      * This function allows for tokens to be queried if the collection
2582      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2583      *
2584      * Requirements:
2585      *
2586      * - `start < stop`
2587      */
2588     function tokensOfOwnerIn(
2589         address owner,
2590         uint256 start,
2591         uint256 stop
2592     ) external view returns (uint256[] memory);
2593 
2594     /**
2595      * @dev Returns an array of token IDs owned by `owner`.
2596      *
2597      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2598      * It is meant to be called off-chain.
2599      *
2600      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2601      * multiple smaller scans if the collection is large enough to cause
2602      * an out-of-gas error (10K collections should be fine).
2603      */
2604     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2605 }
2606 
2607 
2608 // File contracts/extensions/ERC721AQueryable.sol
2609 
2610 
2611 // ERC721A Contracts v4.2.2
2612 // Creator: Chiru Labs
2613 
2614 pragma solidity ^0.8.4;
2615 
2616 
2617 /**
2618  * @title ERC721AQueryable.
2619  *
2620  * @dev ERC721A subclass with convenience query functions.
2621  */
2622 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2623     /**
2624      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2625      *
2626      * If the `tokenId` is out of bounds:
2627      *
2628      * - `addr = address(0)`
2629      * - `startTimestamp = 0`
2630      * - `burned = false`
2631      * - `extraData = 0`
2632      *
2633      * If the `tokenId` is burned:
2634      *
2635      * - `addr = <Address of owner before token was burned>`
2636      * - `startTimestamp = <Timestamp when token was burned>`
2637      * - `burned = true`
2638      * - `extraData = <Extra data when token was burned>`
2639      *
2640      * Otherwise:
2641      *
2642      * - `addr = <Address of owner>`
2643      * - `startTimestamp = <Timestamp of start of ownership>`
2644      * - `burned = false`
2645      * - `extraData = <Extra data at start of ownership>`
2646      */
2647     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2648         TokenOwnership memory ownership;
2649         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2650             return ownership;
2651         }
2652         ownership = _ownershipAt(tokenId);
2653         if (ownership.burned) {
2654             return ownership;
2655         }
2656         return _ownershipOf(tokenId);
2657     }
2658 
2659     /**
2660      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2661      * See {ERC721AQueryable-explicitOwnershipOf}
2662      */
2663     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2664         external
2665         view
2666         virtual
2667         override
2668         returns (TokenOwnership[] memory)
2669     {
2670         unchecked {
2671             uint256 tokenIdsLength = tokenIds.length;
2672             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2673             for (uint256 i; i != tokenIdsLength; ++i) {
2674                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2675             }
2676             return ownerships;
2677         }
2678     }
2679 
2680     /**
2681      * @dev Returns an array of token IDs owned by `owner`,
2682      * in the range [`start`, `stop`)
2683      * (i.e. `start <= tokenId < stop`).
2684      *
2685      * This function allows for tokens to be queried if the collection
2686      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2687      *
2688      * Requirements:
2689      *
2690      * - `start < stop`
2691      */
2692     function tokensOfOwnerIn(
2693         address owner,
2694         uint256 start,
2695         uint256 stop
2696     ) external view virtual override returns (uint256[] memory) {
2697         unchecked {
2698             if (start >= stop) revert InvalidQueryRange();
2699             uint256 tokenIdsIdx;
2700             uint256 stopLimit = _nextTokenId();
2701             // Set `start = max(start, _startTokenId())`.
2702             if (start < _startTokenId()) {
2703                 start = _startTokenId();
2704             }
2705             // Set `stop = min(stop, stopLimit)`.
2706             if (stop > stopLimit) {
2707                 stop = stopLimit;
2708             }
2709             uint256 tokenIdsMaxLength = balanceOf(owner);
2710             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2711             // to cater for cases where `balanceOf(owner)` is too big.
2712             if (start < stop) {
2713                 uint256 rangeLength = stop - start;
2714                 if (rangeLength < tokenIdsMaxLength) {
2715                     tokenIdsMaxLength = rangeLength;
2716                 }
2717             } else {
2718                 tokenIdsMaxLength = 0;
2719             }
2720             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2721             if (tokenIdsMaxLength == 0) {
2722                 return tokenIds;
2723             }
2724             // We need to call `explicitOwnershipOf(start)`,
2725             // because the slot at `start` may not be initialized.
2726             TokenOwnership memory ownership = explicitOwnershipOf(start);
2727             address currOwnershipAddr;
2728             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2729             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2730             if (!ownership.burned) {
2731                 currOwnershipAddr = ownership.addr;
2732             }
2733             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2734                 ownership = _ownershipAt(i);
2735                 if (ownership.burned) {
2736                     continue;
2737                 }
2738                 if (ownership.addr != address(0)) {
2739                     currOwnershipAddr = ownership.addr;
2740                 }
2741                 if (currOwnershipAddr == owner) {
2742                     tokenIds[tokenIdsIdx++] = i;
2743                 }
2744             }
2745             // Downsize the array to fit.
2746             assembly {
2747                 mstore(tokenIds, tokenIdsIdx)
2748             }
2749             return tokenIds;
2750         }
2751     }
2752 
2753     /**
2754      * @dev Returns an array of token IDs owned by `owner`.
2755      *
2756      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2757      * It is meant to be called off-chain.
2758      *
2759      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2760      * multiple smaller scans if the collection is large enough to cause
2761      * an out-of-gas error (10K collections should be fine).
2762      */
2763     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2764         unchecked {
2765             uint256 tokenIdsIdx;
2766             address currOwnershipAddr;
2767             uint256 tokenIdsLength = balanceOf(owner);
2768             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2769             TokenOwnership memory ownership;
2770             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2771                 ownership = _ownershipAt(i);
2772                 if (ownership.burned) {
2773                     continue;
2774                 }
2775                 if (ownership.addr != address(0)) {
2776                     currOwnershipAddr = ownership.addr;
2777                 }
2778                 if (currOwnershipAddr == owner) {
2779                     tokenIds[tokenIdsIdx++] = i;
2780                 }
2781             }
2782             return tokenIds;
2783         }
2784     }
2785 }
2786 
2787 
2788 // File contracts/interfaces/IERC4907A.sol
2789 
2790 
2791 // ERC721A Contracts v4.2.2
2792 // Creator: Chiru Labs
2793 
2794 pragma solidity ^0.8.4;
2795 
2796 
2797 // File contracts/interfaces/IERC721A.sol
2798 
2799 
2800 // ERC721A Contracts v4.2.2
2801 // Creator: Chiru Labs
2802 
2803 pragma solidity ^0.8.4;
2804 
2805 
2806 // File contracts/interfaces/IERC721ABurnable.sol
2807 
2808 
2809 // ERC721A Contracts v4.2.2
2810 // Creator: Chiru Labs
2811 
2812 pragma solidity ^0.8.4;
2813 
2814 
2815 // File contracts/interfaces/IERC721AQueryable.sol
2816 
2817 
2818 // ERC721A Contracts v4.2.2
2819 // Creator: Chiru Labs
2820 
2821 pragma solidity ^0.8.4;
2822 
2823 
2824 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.1
2825 
2826 
2827 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
2828 
2829 pragma solidity ^0.8.0;
2830 
2831 /**
2832  * @dev Contract module that helps prevent reentrant calls to a function.
2833  *
2834  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2835  * available, which can be applied to functions to make sure there are no nested
2836  * (reentrant) calls to them.
2837  *
2838  * Note that because there is a single `nonReentrant` guard, functions marked as
2839  * `nonReentrant` may not call one another. This can be worked around by making
2840  * those functions `private`, and then adding `external` `nonReentrant` entry
2841  * points to them.
2842  *
2843  * TIP: If you would like to learn more about reentrancy and alternative ways
2844  * to protect against it, check out our blog post
2845  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2846  */
2847 abstract contract ReentrancyGuard {
2848     // Booleans are more expensive than uint256 or any type that takes up a full
2849     // word because each write operation emits an extra SLOAD to first read the
2850     // slot's contents, replace the bits taken up by the boolean, and then write
2851     // back. This is the compiler's defense against contract upgrades and
2852     // pointer aliasing, and it cannot be disabled.
2853 
2854     // The values being non-zero value makes deployment a bit more expensive,
2855     // but in exchange the refund on every call to nonReentrant will be lower in
2856     // amount. Since refunds are capped to a percentage of the total
2857     // transaction's gas, it is best to keep them low in cases like this one, to
2858     // increase the likelihood of the full refund coming into effect.
2859     uint256 private constant _NOT_ENTERED = 1;
2860     uint256 private constant _ENTERED = 2;
2861 
2862     uint256 private _status;
2863 
2864     constructor() {
2865         _status = _NOT_ENTERED;
2866     }
2867 
2868     /**
2869      * @dev Prevents a contract from calling itself, directly or indirectly.
2870      * Calling a `nonReentrant` function from another `nonReentrant`
2871      * function is not supported. It is possible to prevent this from happening
2872      * by making the `nonReentrant` function external, and making it call a
2873      * `private` function that does the actual work.
2874      */
2875     modifier nonReentrant() {
2876         _nonReentrantBefore();
2877         _;
2878         _nonReentrantAfter();
2879     }
2880 
2881     function _nonReentrantBefore() private {
2882         // On the first call to nonReentrant, _status will be _NOT_ENTERED
2883         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2884 
2885         // Any calls to nonReentrant after this point will fail
2886         _status = _ENTERED;
2887     }
2888 
2889     function _nonReentrantAfter() private {
2890         // By storing the original value once again, a refund is triggered (see
2891         // https://eips.ethereum.org/EIPS/eip-2200)
2892         _status = _NOT_ENTERED;
2893     }
2894 }
2895 
2896 
2897 // File contracts/svbankers.sol
2898 
2899 
2900 
2901 pragma solidity ^0.8.13;
2902 
2903 
2904 
2905 
2906 
2907 error AccessDenied();
2908 error ExceedsMaxPerTransaction();
2909 error MaxPerWalletExceeded();
2910 error IncorrectPayment();
2911 error InvalidMintQuantity();
2912 error MintingDisabled();
2913 error PresaleNotAllowed();
2914 error TokenNotFound();
2915 error NoBurnsYet();
2916 error PresaleClosed();
2917 error InsufficientPayment();
2918 error CannotBurnUnmintedToken();
2919 error MaxSupplyReached();
2920 error WithdrawalFailed();
2921 
2922 abstract contract BankFactory {
2923     function burnBanker(address to, uint256 boxId) public virtual returns (uint256);
2924 }
2925 
2926 contract SiliconValleyBankers is ERC721AQueryable, ReentrancyGuard, ERC2981, Ownable {
2927     using ECDSA for bytes32;
2928     string private _baseTokenURI;
2929     bool public canMint = false;
2930     bool public canBurn = false;
2931     uint public cost = 0.0042 ether;
2932     uint public freePerWallet = 1;
2933     uint public maxPerTransaction = 10;
2934     uint public maxPerWallet = 25;
2935     uint public totalAvailable = 6900;
2936     address private burnContract;
2937 
2938     constructor() ERC721A("SiliconValleyBankers", "SVB") {}
2939 
2940     modifier callerIsUser() {
2941         require(tx.origin == msg.sender, "not original sender");
2942         _;
2943     }
2944 
2945     function mint(uint qty)
2946       external
2947       payable
2948       callerIsUser
2949       nonReentrant {
2950         uint price = getPrice(qty);
2951 
2952         if (!canMint) revert MintingDisabled();
2953         if (_totalMinted() + qty > totalAvailable + 1) revert MaxSupplyReached();
2954         if (_numberMinted(msg.sender) + qty > maxPerWallet + 1) revert MaxPerWalletExceeded();
2955         if (qty > maxPerTransaction + 1) revert ExceedsMaxPerTransaction();
2956 
2957         _mint(msg.sender, qty);
2958         _refundOverPayment(price);
2959     }
2960 
2961     function burnBanker(uint256 bankerId) public nonReentrant() returns (uint256) {
2962       if (!canBurn) {
2963           if (msg.sender != owner()) revert NoBurnsYet();
2964       }
2965 
2966       address to = ownerOf(bankerId);
2967 
2968       if (to != msg.sender) {
2969           if (msg.sender != owner()) revert CannotBurnUnmintedToken();
2970       }
2971 
2972       BankFactory factory = BankFactory(burnContract);
2973 
2974       _burn(bankerId, true);
2975 
2976       uint256 bankerTokenId = factory.burnBanker(to, bankerId);
2977       return bankerTokenId;
2978     }
2979 
2980     function numberBankersBurned(address addr) external view returns (uint256) {
2981         return _numberBurned(addr);
2982     }
2983 
2984     function totalBankersBurned() external view returns (uint256) {
2985         return _totalBurned();
2986     }
2987 
2988     function toggleCanBurn() external onlyOwner {
2989         if (burnContract == address(0)) revert NoBurnsYet();
2990         canBurn = !canBurn;
2991     }
2992 
2993     function setBurnContract(address contract_) external onlyOwner {
2994         burnContract = contract_;
2995     }
2996 
2997     function getPrice(uint qty) public view returns (uint) {
2998       uint numMinted = _numberMinted(msg.sender);
2999       uint free = numMinted < freePerWallet ? freePerWallet - numMinted : 0;
3000       if (qty >= free) {
3001         return (cost) * (qty - free);
3002       }
3003       return 0;
3004     }
3005 
3006     function _refundOverPayment(uint256 amount) internal {
3007         if (msg.value < amount) revert InsufficientPayment();
3008         if (msg.value > amount) {
3009             payable(msg.sender).transfer(msg.value - amount);
3010         }
3011     }
3012 
3013     function bankMint(uint256 quantity, address to) external onlyOwner {
3014         require(
3015             totalSupply() + quantity <= totalAvailable,
3016             "dev you should know better"
3017         );
3018         _mint(to, quantity);
3019     }
3020 
3021     function _baseURI() internal view virtual override returns (string memory) {
3022         return _baseTokenURI;
3023     }
3024 
3025     function deleteDefaultRoyalty() external onlyOwner {
3026         _deleteDefaultRoyalty();
3027     }
3028 
3029     function _startTokenId() internal view virtual override returns (uint256) {
3030         return 1;
3031     }
3032 
3033     function setMaxPerTx(uint256 maxPerTransaction_) external onlyOwner {
3034         maxPerTransaction = maxPerTransaction_;
3035     }
3036 
3037     function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
3038         maxPerWallet = maxPerWallet_;
3039     }
3040 
3041     function setMaxSupply(uint256 maxSupply_) public onlyOwner {
3042         totalAvailable = maxSupply_;
3043     }
3044 
3045     function toggleCanMint() external onlyOwner {
3046         canMint = !canMint;
3047     }
3048 
3049     function numberMinted(address owner) public view returns (uint256) {
3050         return _numberMinted(owner);
3051     }
3052 
3053     function setBaseURI(string calldata baseURI_) external onlyOwner {
3054         _baseTokenURI = baseURI_;
3055     }
3056 
3057     function withdraw() external onlyOwner {
3058         (bool success, ) = msg.sender.call{value: address(this).balance}("");
3059         if (!success) revert WithdrawalFailed();
3060     }
3061 
3062     function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
3063         _setDefaultRoyalty(receiver, feeNumerator);
3064     }
3065 
3066     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981, IERC721A) returns (bool) {
3067         // Supports the following `interfaceId`s:
3068         // - IERC165: 0x01ffc9a7
3069         // - IERC721: 0x80ac58cd
3070         // - IERC721Metadata: 0x5b5e139f
3071         // - IERC2981: 0x2a55205a
3072         return
3073             ERC721A.supportsInterface(interfaceId) ||
3074             ERC2981.supportsInterface(interfaceId);
3075     }
3076 
3077 }