1 // Sources flattened with hardhat v2.14.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.3
4 
5 
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
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.3
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
116 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.3
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
145 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.8.3
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
172 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.3
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
203 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.8.3
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
316 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.3
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
486         // ΓåÆ `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
487         // ΓåÆ `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
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
665 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.3
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
737 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.8.3
738 
739 
740 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 /**
745  * @dev These functions deal with verification of Merkle Tree proofs.
746  *
747  * The tree and the proofs can be generated using our
748  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
749  * You will find a quickstart guide in the readme.
750  *
751  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
752  * hashing, or use a hash function other than keccak256 for hashing leaves.
753  * This is because the concatenation of a sorted pair of internal nodes in
754  * the merkle tree could be reinterpreted as a leaf value.
755  * OpenZeppelin's JavaScript library generates merkle trees that are safe
756  * against this attack out of the box.
757  */
758 library MerkleProof {
759     /**
760      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
761      * defined by `root`. For this, a `proof` must be provided, containing
762      * sibling hashes on the branch from the leaf to the root of the tree. Each
763      * pair of leaves and each pair of pre-images are assumed to be sorted.
764      */
765     function verify(
766         bytes32[] memory proof,
767         bytes32 root,
768         bytes32 leaf
769     ) internal pure returns (bool) {
770         return processProof(proof, leaf) == root;
771     }
772 
773     /**
774      * @dev Calldata version of {verify}
775      *
776      * _Available since v4.7._
777      */
778     function verifyCalldata(
779         bytes32[] calldata proof,
780         bytes32 root,
781         bytes32 leaf
782     ) internal pure returns (bool) {
783         return processProofCalldata(proof, leaf) == root;
784     }
785 
786     /**
787      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
788      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
789      * hash matches the root of the tree. When processing the proof, the pairs
790      * of leafs & pre-images are assumed to be sorted.
791      *
792      * _Available since v4.4._
793      */
794     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
795         bytes32 computedHash = leaf;
796         for (uint256 i = 0; i < proof.length; i++) {
797             computedHash = _hashPair(computedHash, proof[i]);
798         }
799         return computedHash;
800     }
801 
802     /**
803      * @dev Calldata version of {processProof}
804      *
805      * _Available since v4.7._
806      */
807     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
808         bytes32 computedHash = leaf;
809         for (uint256 i = 0; i < proof.length; i++) {
810             computedHash = _hashPair(computedHash, proof[i]);
811         }
812         return computedHash;
813     }
814 
815     /**
816      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
817      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
818      *
819      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
820      *
821      * _Available since v4.7._
822      */
823     function multiProofVerify(
824         bytes32[] memory proof,
825         bool[] memory proofFlags,
826         bytes32 root,
827         bytes32[] memory leaves
828     ) internal pure returns (bool) {
829         return processMultiProof(proof, proofFlags, leaves) == root;
830     }
831 
832     /**
833      * @dev Calldata version of {multiProofVerify}
834      *
835      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
836      *
837      * _Available since v4.7._
838      */
839     function multiProofVerifyCalldata(
840         bytes32[] calldata proof,
841         bool[] calldata proofFlags,
842         bytes32 root,
843         bytes32[] memory leaves
844     ) internal pure returns (bool) {
845         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
846     }
847 
848     /**
849      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
850      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
851      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
852      * respectively.
853      *
854      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
855      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
856      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
857      *
858      * _Available since v4.7._
859      */
860     function processMultiProof(
861         bytes32[] memory proof,
862         bool[] memory proofFlags,
863         bytes32[] memory leaves
864     ) internal pure returns (bytes32 merkleRoot) {
865         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
866         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
867         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
868         // the merkle tree.
869         uint256 leavesLen = leaves.length;
870         uint256 totalHashes = proofFlags.length;
871 
872         // Check proof validity.
873         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
874 
875         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
876         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
877         bytes32[] memory hashes = new bytes32[](totalHashes);
878         uint256 leafPos = 0;
879         uint256 hashPos = 0;
880         uint256 proofPos = 0;
881         // At each step, we compute the next hash using two values:
882         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
883         //   get the next hash.
884         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
885         //   `proof` array.
886         for (uint256 i = 0; i < totalHashes; i++) {
887             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
888             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
889             hashes[i] = _hashPair(a, b);
890         }
891 
892         if (totalHashes > 0) {
893             return hashes[totalHashes - 1];
894         } else if (leavesLen > 0) {
895             return leaves[0];
896         } else {
897             return proof[0];
898         }
899     }
900 
901     /**
902      * @dev Calldata version of {processMultiProof}.
903      *
904      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
905      *
906      * _Available since v4.7._
907      */
908     function processMultiProofCalldata(
909         bytes32[] calldata proof,
910         bool[] calldata proofFlags,
911         bytes32[] memory leaves
912     ) internal pure returns (bytes32 merkleRoot) {
913         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
914         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
915         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
916         // the merkle tree.
917         uint256 leavesLen = leaves.length;
918         uint256 totalHashes = proofFlags.length;
919 
920         // Check proof validity.
921         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
922 
923         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
924         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
925         bytes32[] memory hashes = new bytes32[](totalHashes);
926         uint256 leafPos = 0;
927         uint256 hashPos = 0;
928         uint256 proofPos = 0;
929         // At each step, we compute the next hash using two values:
930         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
931         //   get the next hash.
932         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
933         //   `proof` array.
934         for (uint256 i = 0; i < totalHashes; i++) {
935             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
936             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
937             hashes[i] = _hashPair(a, b);
938         }
939 
940         if (totalHashes > 0) {
941             return hashes[totalHashes - 1];
942         } else if (leavesLen > 0) {
943             return leaves[0];
944         } else {
945             return proof[0];
946         }
947     }
948 
949     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
950         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
951     }
952 
953     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
954         /// @solidity memory-safe-assembly
955         assembly {
956             mstore(0x00, a)
957             mstore(0x20, b)
958             value := keccak256(0x00, 0x40)
959         }
960     }
961 }
962 
963 
964 // File erc721a/contracts/IERC721A.sol@v4.2.3
965 
966 
967 // ERC721A Contracts v4.2.3
968 // Creator: Chiru Labs
969 
970 pragma solidity ^0.8.4;
971 
972 /**
973  * @dev Interface of ERC721A.
974  */
975 interface IERC721A {
976     /**
977      * The caller must own the token or be an approved operator.
978      */
979     error ApprovalCallerNotOwnerNorApproved();
980 
981     /**
982      * The token does not exist.
983      */
984     error ApprovalQueryForNonexistentToken();
985 
986     /**
987      * Cannot query the balance for the zero address.
988      */
989     error BalanceQueryForZeroAddress();
990 
991     /**
992      * Cannot mint to the zero address.
993      */
994     error MintToZeroAddress();
995 
996     /**
997      * The quantity of tokens minted must be more than zero.
998      */
999     error MintZeroQuantity();
1000 
1001     /**
1002      * The token does not exist.
1003      */
1004     error OwnerQueryForNonexistentToken();
1005 
1006     /**
1007      * The caller must own the token or be an approved operator.
1008      */
1009     error TransferCallerNotOwnerNorApproved();
1010 
1011     /**
1012      * The token must be owned by `from`.
1013      */
1014     error TransferFromIncorrectOwner();
1015 
1016     /**
1017      * Cannot safely transfer to a contract that does not implement the
1018      * ERC721Receiver interface.
1019      */
1020     error TransferToNonERC721ReceiverImplementer();
1021 
1022     /**
1023      * Cannot transfer to the zero address.
1024      */
1025     error TransferToZeroAddress();
1026 
1027     /**
1028      * The token does not exist.
1029      */
1030     error URIQueryForNonexistentToken();
1031 
1032     /**
1033      * The `quantity` minted with ERC2309 exceeds the safety limit.
1034      */
1035     error MintERC2309QuantityExceedsLimit();
1036 
1037     /**
1038      * The `extraData` cannot be set on an unintialized ownership slot.
1039      */
1040     error OwnershipNotInitializedForExtraData();
1041 
1042     // =============================================================
1043     //                            STRUCTS
1044     // =============================================================
1045 
1046     struct TokenOwnership {
1047         // The address of the owner.
1048         address addr;
1049         // Stores the start time of ownership with minimal overhead for tokenomics.
1050         uint64 startTimestamp;
1051         // Whether the token has been burned.
1052         bool burned;
1053         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1054         uint24 extraData;
1055     }
1056 
1057     // =============================================================
1058     //                         TOKEN COUNTERS
1059     // =============================================================
1060 
1061     /**
1062      * @dev Returns the total number of tokens in existence.
1063      * Burned tokens will reduce the count.
1064      * To get the total number of tokens minted, please see {_totalMinted}.
1065      */
1066     function totalSupply() external view returns (uint256);
1067 
1068     // =============================================================
1069     //                            IERC165
1070     // =============================================================
1071 
1072     /**
1073      * @dev Returns true if this contract implements the interface defined by
1074      * `interfaceId`. See the corresponding
1075      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1076      * to learn more about how these ids are created.
1077      *
1078      * This function call must use less than 30000 gas.
1079      */
1080     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1081 
1082     // =============================================================
1083     //                            IERC721
1084     // =============================================================
1085 
1086     /**
1087      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1088      */
1089     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1090 
1091     /**
1092      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1093      */
1094     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1095 
1096     /**
1097      * @dev Emitted when `owner` enables or disables
1098      * (`approved`) `operator` to manage all of its assets.
1099      */
1100     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1101 
1102     /**
1103      * @dev Returns the number of tokens in `owner`'s account.
1104      */
1105     function balanceOf(address owner) external view returns (uint256 balance);
1106 
1107     /**
1108      * @dev Returns the owner of the `tokenId` token.
1109      *
1110      * Requirements:
1111      *
1112      * - `tokenId` must exist.
1113      */
1114     function ownerOf(uint256 tokenId) external view returns (address owner);
1115 
1116     /**
1117      * @dev Safely transfers `tokenId` token from `from` to `to`,
1118      * checking first that contract recipients are aware of the ERC721 protocol
1119      * to prevent tokens from being forever locked.
1120      *
1121      * Requirements:
1122      *
1123      * - `from` cannot be the zero address.
1124      * - `to` cannot be the zero address.
1125      * - `tokenId` token must exist and be owned by `from`.
1126      * - If the caller is not `from`, it must be have been allowed to move
1127      * this token by either {approve} or {setApprovalForAll}.
1128      * - If `to` refers to a smart contract, it must implement
1129      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function safeTransferFrom(
1134         address from,
1135         address to,
1136         uint256 tokenId,
1137         bytes calldata data
1138     ) external payable;
1139 
1140     /**
1141      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1142      */
1143     function safeTransferFrom(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) external payable;
1148 
1149     /**
1150      * @dev Transfers `tokenId` from `from` to `to`.
1151      *
1152      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1153      * whenever possible.
1154      *
1155      * Requirements:
1156      *
1157      * - `from` cannot be the zero address.
1158      * - `to` cannot be the zero address.
1159      * - `tokenId` token must be owned by `from`.
1160      * - If the caller is not `from`, it must be approved to move this token
1161      * by either {approve} or {setApprovalForAll}.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function transferFrom(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) external payable;
1170 
1171     /**
1172      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1173      * The approval is cleared when the token is transferred.
1174      *
1175      * Only a single account can be approved at a time, so approving the
1176      * zero address clears previous approvals.
1177      *
1178      * Requirements:
1179      *
1180      * - The caller must own the token or be an approved operator.
1181      * - `tokenId` must exist.
1182      *
1183      * Emits an {Approval} event.
1184      */
1185     function approve(address to, uint256 tokenId) external payable;
1186 
1187     /**
1188      * @dev Approve or remove `operator` as an operator for the caller.
1189      * Operators can call {transferFrom} or {safeTransferFrom}
1190      * for any token owned by the caller.
1191      *
1192      * Requirements:
1193      *
1194      * - The `operator` cannot be the caller.
1195      *
1196      * Emits an {ApprovalForAll} event.
1197      */
1198     function setApprovalForAll(address operator, bool _approved) external;
1199 
1200     /**
1201      * @dev Returns the account approved for `tokenId` token.
1202      *
1203      * Requirements:
1204      *
1205      * - `tokenId` must exist.
1206      */
1207     function getApproved(uint256 tokenId) external view returns (address operator);
1208 
1209     /**
1210      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1211      *
1212      * See {setApprovalForAll}.
1213      */
1214     function isApprovedForAll(address owner, address operator) external view returns (bool);
1215 
1216     // =============================================================
1217     //                        IERC721Metadata
1218     // =============================================================
1219 
1220     /**
1221      * @dev Returns the token collection name.
1222      */
1223     function name() external view returns (string memory);
1224 
1225     /**
1226      * @dev Returns the token collection symbol.
1227      */
1228     function symbol() external view returns (string memory);
1229 
1230     /**
1231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1232      */
1233     function tokenURI(uint256 tokenId) external view returns (string memory);
1234 
1235     // =============================================================
1236     //                           IERC2309
1237     // =============================================================
1238 
1239     /**
1240      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1241      * (inclusive) is transferred from `from` to `to`, as defined in the
1242      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1243      *
1244      * See {_mintERC2309} for more details.
1245      */
1246     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1247 }
1248 
1249 
1250 // File erc721a/contracts/ERC721A.sol@v4.2.3
1251 
1252 
1253 // ERC721A Contracts v4.2.3
1254 // Creator: Chiru Labs
1255 
1256 pragma solidity ^0.8.4;
1257 
1258 /**
1259  * @dev Interface of ERC721 token receiver.
1260  */
1261 interface ERC721A__IERC721Receiver {
1262     function onERC721Received(
1263         address operator,
1264         address from,
1265         uint256 tokenId,
1266         bytes calldata data
1267     ) external returns (bytes4);
1268 }
1269 
1270 /**
1271  * @title ERC721A
1272  *
1273  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1274  * Non-Fungible Token Standard, including the Metadata extension.
1275  * Optimized for lower gas during batch mints.
1276  *
1277  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1278  * starting from `_startTokenId()`.
1279  *
1280  * Assumptions:
1281  *
1282  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1283  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1284  */
1285 contract ERC721A is IERC721A {
1286     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1287     struct TokenApprovalRef {
1288         address value;
1289     }
1290 
1291     // =============================================================
1292     //                           CONSTANTS
1293     // =============================================================
1294 
1295     // Mask of an entry in packed address data.
1296     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1297 
1298     // The bit position of `numberMinted` in packed address data.
1299     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1300 
1301     // The bit position of `numberBurned` in packed address data.
1302     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1303 
1304     // The bit position of `aux` in packed address data.
1305     uint256 private constant _BITPOS_AUX = 192;
1306 
1307     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1308     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1309 
1310     // The bit position of `startTimestamp` in packed ownership.
1311     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1312 
1313     // The bit mask of the `burned` bit in packed ownership.
1314     uint256 private constant _BITMASK_BURNED = 1 << 224;
1315 
1316     // The bit position of the `nextInitialized` bit in packed ownership.
1317     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1318 
1319     // The bit mask of the `nextInitialized` bit in packed ownership.
1320     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1321 
1322     // The bit position of `extraData` in packed ownership.
1323     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1324 
1325     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1326     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1327 
1328     // The mask of the lower 160 bits for addresses.
1329     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1330 
1331     // The maximum `quantity` that can be minted with {_mintERC2309}.
1332     // This limit is to prevent overflows on the address data entries.
1333     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1334     // is required to cause an overflow, which is unrealistic.
1335     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1336 
1337     // The `Transfer` event signature is given by:
1338     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1339     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1340         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1341 
1342     // =============================================================
1343     //                            STORAGE
1344     // =============================================================
1345 
1346     // The next token ID to be minted.
1347     uint256 private _currentIndex;
1348 
1349     // The number of tokens burned.
1350     uint256 private _burnCounter;
1351 
1352     // Token name
1353     string private _name;
1354 
1355     // Token symbol
1356     string private _symbol;
1357 
1358     // Mapping from token ID to ownership details
1359     // An empty struct value does not necessarily mean the token is unowned.
1360     // See {_packedOwnershipOf} implementation for details.
1361     //
1362     // Bits Layout:
1363     // - [0..159]   `addr`
1364     // - [160..223] `startTimestamp`
1365     // - [224]      `burned`
1366     // - [225]      `nextInitialized`
1367     // - [232..255] `extraData`
1368     mapping(uint256 => uint256) private _packedOwnerships;
1369 
1370     // Mapping owner address to address data.
1371     //
1372     // Bits Layout:
1373     // - [0..63]    `balance`
1374     // - [64..127]  `numberMinted`
1375     // - [128..191] `numberBurned`
1376     // - [192..255] `aux`
1377     mapping(address => uint256) private _packedAddressData;
1378 
1379     // Mapping from token ID to approved address.
1380     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1381 
1382     // Mapping from owner to operator approvals
1383     mapping(address => mapping(address => bool)) private _operatorApprovals;
1384 
1385     // =============================================================
1386     //                          CONSTRUCTOR
1387     // =============================================================
1388 
1389     constructor(string memory name_, string memory symbol_) {
1390         _name = name_;
1391         _symbol = symbol_;
1392         _currentIndex = _startTokenId();
1393     }
1394 
1395     // =============================================================
1396     //                   TOKEN COUNTING OPERATIONS
1397     // =============================================================
1398 
1399     /**
1400      * @dev Returns the starting token ID.
1401      * To change the starting token ID, please override this function.
1402      */
1403     function _startTokenId() internal view virtual returns (uint256) {
1404         return 0;
1405     }
1406 
1407     /**
1408      * @dev Returns the next token ID to be minted.
1409      */
1410     function _nextTokenId() internal view virtual returns (uint256) {
1411         return _currentIndex;
1412     }
1413 
1414     /**
1415      * @dev Returns the total number of tokens in existence.
1416      * Burned tokens will reduce the count.
1417      * To get the total number of tokens minted, please see {_totalMinted}.
1418      */
1419     function totalSupply() public view virtual override returns (uint256) {
1420         // Counter underflow is impossible as _burnCounter cannot be incremented
1421         // more than `_currentIndex - _startTokenId()` times.
1422         unchecked {
1423             return _currentIndex - _burnCounter - _startTokenId();
1424         }
1425     }
1426 
1427     /**
1428      * @dev Returns the total amount of tokens minted in the contract.
1429      */
1430     function _totalMinted() internal view virtual returns (uint256) {
1431         // Counter underflow is impossible as `_currentIndex` does not decrement,
1432         // and it is initialized to `_startTokenId()`.
1433         unchecked {
1434             return _currentIndex - _startTokenId();
1435         }
1436     }
1437 
1438     /**
1439      * @dev Returns the total number of tokens burned.
1440      */
1441     function _totalBurned() internal view virtual returns (uint256) {
1442         return _burnCounter;
1443     }
1444 
1445     // =============================================================
1446     //                    ADDRESS DATA OPERATIONS
1447     // =============================================================
1448 
1449     /**
1450      * @dev Returns the number of tokens in `owner`'s account.
1451      */
1452     function balanceOf(address owner) public view virtual override returns (uint256) {
1453         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1454         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1455     }
1456 
1457     /**
1458      * Returns the number of tokens minted by `owner`.
1459      */
1460     function _numberMinted(address owner) internal view returns (uint256) {
1461         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1462     }
1463 
1464     /**
1465      * Returns the number of tokens burned by or on behalf of `owner`.
1466      */
1467     function _numberBurned(address owner) internal view returns (uint256) {
1468         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1469     }
1470 
1471     /**
1472      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1473      */
1474     function _getAux(address owner) internal view returns (uint64) {
1475         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1476     }
1477 
1478     /**
1479      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1480      * If there are multiple variables, please pack them into a uint64.
1481      */
1482     function _setAux(address owner, uint64 aux) internal virtual {
1483         uint256 packed = _packedAddressData[owner];
1484         uint256 auxCasted;
1485         // Cast `aux` with assembly to avoid redundant masking.
1486         assembly {
1487             auxCasted := aux
1488         }
1489         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1490         _packedAddressData[owner] = packed;
1491     }
1492 
1493     // =============================================================
1494     //                            IERC165
1495     // =============================================================
1496 
1497     /**
1498      * @dev Returns true if this contract implements the interface defined by
1499      * `interfaceId`. See the corresponding
1500      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1501      * to learn more about how these ids are created.
1502      *
1503      * This function call must use less than 30000 gas.
1504      */
1505     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1506         // The interface IDs are constants representing the first 4 bytes
1507         // of the XOR of all function selectors in the interface.
1508         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1509         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1510         return
1511             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1512             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1513             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1514     }
1515 
1516     // =============================================================
1517     //                        IERC721Metadata
1518     // =============================================================
1519 
1520     /**
1521      * @dev Returns the token collection name.
1522      */
1523     function name() public view virtual override returns (string memory) {
1524         return _name;
1525     }
1526 
1527     /**
1528      * @dev Returns the token collection symbol.
1529      */
1530     function symbol() public view virtual override returns (string memory) {
1531         return _symbol;
1532     }
1533 
1534     /**
1535      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1536      */
1537     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1538         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1539 
1540         string memory baseURI = _baseURI();
1541         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1542     }
1543 
1544     /**
1545      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1546      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1547      * by default, it can be overridden in child contracts.
1548      */
1549     function _baseURI() internal view virtual returns (string memory) {
1550         return '';
1551     }
1552 
1553     // =============================================================
1554     //                     OWNERSHIPS OPERATIONS
1555     // =============================================================
1556 
1557     /**
1558      * @dev Returns the owner of the `tokenId` token.
1559      *
1560      * Requirements:
1561      *
1562      * - `tokenId` must exist.
1563      */
1564     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1565         return address(uint160(_packedOwnershipOf(tokenId)));
1566     }
1567 
1568     /**
1569      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1570      * It gradually moves to O(1) as tokens get transferred around over time.
1571      */
1572     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1573         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1574     }
1575 
1576     /**
1577      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1578      */
1579     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1580         return _unpackedOwnership(_packedOwnerships[index]);
1581     }
1582 
1583     /**
1584      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1585      */
1586     function _initializeOwnershipAt(uint256 index) internal virtual {
1587         if (_packedOwnerships[index] == 0) {
1588             _packedOwnerships[index] = _packedOwnershipOf(index);
1589         }
1590     }
1591 
1592     /**
1593      * Returns the packed ownership data of `tokenId`.
1594      */
1595     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1596         uint256 curr = tokenId;
1597 
1598         unchecked {
1599             if (_startTokenId() <= curr)
1600                 if (curr < _currentIndex) {
1601                     uint256 packed = _packedOwnerships[curr];
1602                     // If not burned.
1603                     if (packed & _BITMASK_BURNED == 0) {
1604                         // Invariant:
1605                         // There will always be an initialized ownership slot
1606                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1607                         // before an unintialized ownership slot
1608                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1609                         // Hence, `curr` will not underflow.
1610                         //
1611                         // We can directly compare the packed value.
1612                         // If the address is zero, packed will be zero.
1613                         while (packed == 0) {
1614                             packed = _packedOwnerships[--curr];
1615                         }
1616                         return packed;
1617                     }
1618                 }
1619         }
1620         revert OwnerQueryForNonexistentToken();
1621     }
1622 
1623     /**
1624      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1625      */
1626     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1627         ownership.addr = address(uint160(packed));
1628         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1629         ownership.burned = packed & _BITMASK_BURNED != 0;
1630         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1631     }
1632 
1633     /**
1634      * @dev Packs ownership data into a single uint256.
1635      */
1636     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1637         assembly {
1638             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1639             owner := and(owner, _BITMASK_ADDRESS)
1640             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1641             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1642         }
1643     }
1644 
1645     /**
1646      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1647      */
1648     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1649         // For branchless setting of the `nextInitialized` flag.
1650         assembly {
1651             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1652             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1653         }
1654     }
1655 
1656     // =============================================================
1657     //                      APPROVAL OPERATIONS
1658     // =============================================================
1659 
1660     /**
1661      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1662      * The approval is cleared when the token is transferred.
1663      *
1664      * Only a single account can be approved at a time, so approving the
1665      * zero address clears previous approvals.
1666      *
1667      * Requirements:
1668      *
1669      * - The caller must own the token or be an approved operator.
1670      * - `tokenId` must exist.
1671      *
1672      * Emits an {Approval} event.
1673      */
1674     function approve(address to, uint256 tokenId) public payable virtual override {
1675         address owner = ownerOf(tokenId);
1676 
1677         if (_msgSenderERC721A() != owner)
1678             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1679                 revert ApprovalCallerNotOwnerNorApproved();
1680             }
1681 
1682         _tokenApprovals[tokenId].value = to;
1683         emit Approval(owner, to, tokenId);
1684     }
1685 
1686     /**
1687      * @dev Returns the account approved for `tokenId` token.
1688      *
1689      * Requirements:
1690      *
1691      * - `tokenId` must exist.
1692      */
1693     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1694         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1695 
1696         return _tokenApprovals[tokenId].value;
1697     }
1698 
1699     /**
1700      * @dev Approve or remove `operator` as an operator for the caller.
1701      * Operators can call {transferFrom} or {safeTransferFrom}
1702      * for any token owned by the caller.
1703      *
1704      * Requirements:
1705      *
1706      * - The `operator` cannot be the caller.
1707      *
1708      * Emits an {ApprovalForAll} event.
1709      */
1710     function setApprovalForAll(address operator, bool approved) public virtual override {
1711         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1712         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1713     }
1714 
1715     /**
1716      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1717      *
1718      * See {setApprovalForAll}.
1719      */
1720     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1721         return _operatorApprovals[owner][operator];
1722     }
1723 
1724     /**
1725      * @dev Returns whether `tokenId` exists.
1726      *
1727      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1728      *
1729      * Tokens start existing when they are minted. See {_mint}.
1730      */
1731     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1732         return
1733             _startTokenId() <= tokenId &&
1734             tokenId < _currentIndex && // If within bounds,
1735             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1736     }
1737 
1738     /**
1739      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1740      */
1741     function _isSenderApprovedOrOwner(
1742         address approvedAddress,
1743         address owner,
1744         address msgSender
1745     ) private pure returns (bool result) {
1746         assembly {
1747             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1748             owner := and(owner, _BITMASK_ADDRESS)
1749             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1750             msgSender := and(msgSender, _BITMASK_ADDRESS)
1751             // `msgSender == owner || msgSender == approvedAddress`.
1752             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1753         }
1754     }
1755 
1756     /**
1757      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1758      */
1759     function _getApprovedSlotAndAddress(uint256 tokenId)
1760         private
1761         view
1762         returns (uint256 approvedAddressSlot, address approvedAddress)
1763     {
1764         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1765         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1766         assembly {
1767             approvedAddressSlot := tokenApproval.slot
1768             approvedAddress := sload(approvedAddressSlot)
1769         }
1770     }
1771 
1772     // =============================================================
1773     //                      TRANSFER OPERATIONS
1774     // =============================================================
1775 
1776     /**
1777      * @dev Transfers `tokenId` from `from` to `to`.
1778      *
1779      * Requirements:
1780      *
1781      * - `from` cannot be the zero address.
1782      * - `to` cannot be the zero address.
1783      * - `tokenId` token must be owned by `from`.
1784      * - If the caller is not `from`, it must be approved to move this token
1785      * by either {approve} or {setApprovalForAll}.
1786      *
1787      * Emits a {Transfer} event.
1788      */
1789     function transferFrom(
1790         address from,
1791         address to,
1792         uint256 tokenId
1793     ) public payable virtual override {
1794         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1795 
1796         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1797 
1798         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1799 
1800         // The nested ifs save around 20+ gas over a compound boolean condition.
1801         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1802             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1803 
1804         if (to == address(0)) revert TransferToZeroAddress();
1805 
1806         _beforeTokenTransfers(from, to, tokenId, 1);
1807 
1808         // Clear approvals from the previous owner.
1809         assembly {
1810             if approvedAddress {
1811                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1812                 sstore(approvedAddressSlot, 0)
1813             }
1814         }
1815 
1816         // Underflow of the sender's balance is impossible because we check for
1817         // ownership above and the recipient's balance can't realistically overflow.
1818         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1819         unchecked {
1820             // We can directly increment and decrement the balances.
1821             --_packedAddressData[from]; // Updates: `balance -= 1`.
1822             ++_packedAddressData[to]; // Updates: `balance += 1`.
1823 
1824             // Updates:
1825             // - `address` to the next owner.
1826             // - `startTimestamp` to the timestamp of transfering.
1827             // - `burned` to `false`.
1828             // - `nextInitialized` to `true`.
1829             _packedOwnerships[tokenId] = _packOwnershipData(
1830                 to,
1831                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1832             );
1833 
1834             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1835             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1836                 uint256 nextTokenId = tokenId + 1;
1837                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1838                 if (_packedOwnerships[nextTokenId] == 0) {
1839                     // If the next slot is within bounds.
1840                     if (nextTokenId != _currentIndex) {
1841                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1842                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1843                     }
1844                 }
1845             }
1846         }
1847 
1848         emit Transfer(from, to, tokenId);
1849         _afterTokenTransfers(from, to, tokenId, 1);
1850     }
1851 
1852     /**
1853      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1854      */
1855     function safeTransferFrom(
1856         address from,
1857         address to,
1858         uint256 tokenId
1859     ) public payable virtual override {
1860         safeTransferFrom(from, to, tokenId, '');
1861     }
1862 
1863     /**
1864      * @dev Safely transfers `tokenId` token from `from` to `to`.
1865      *
1866      * Requirements:
1867      *
1868      * - `from` cannot be the zero address.
1869      * - `to` cannot be the zero address.
1870      * - `tokenId` token must exist and be owned by `from`.
1871      * - If the caller is not `from`, it must be approved to move this token
1872      * by either {approve} or {setApprovalForAll}.
1873      * - If `to` refers to a smart contract, it must implement
1874      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1875      *
1876      * Emits a {Transfer} event.
1877      */
1878     function safeTransferFrom(
1879         address from,
1880         address to,
1881         uint256 tokenId,
1882         bytes memory _data
1883     ) public payable virtual override {
1884         transferFrom(from, to, tokenId);
1885         if (to.code.length != 0)
1886             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1887                 revert TransferToNonERC721ReceiverImplementer();
1888             }
1889     }
1890 
1891     /**
1892      * @dev Hook that is called before a set of serially-ordered token IDs
1893      * are about to be transferred. This includes minting.
1894      * And also called before burning one token.
1895      *
1896      * `startTokenId` - the first token ID to be transferred.
1897      * `quantity` - the amount to be transferred.
1898      *
1899      * Calling conditions:
1900      *
1901      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1902      * transferred to `to`.
1903      * - When `from` is zero, `tokenId` will be minted for `to`.
1904      * - When `to` is zero, `tokenId` will be burned by `from`.
1905      * - `from` and `to` are never both zero.
1906      */
1907     function _beforeTokenTransfers(
1908         address from,
1909         address to,
1910         uint256 startTokenId,
1911         uint256 quantity
1912     ) internal virtual {}
1913 
1914     /**
1915      * @dev Hook that is called after a set of serially-ordered token IDs
1916      * have been transferred. This includes minting.
1917      * And also called after one token has been burned.
1918      *
1919      * `startTokenId` - the first token ID to be transferred.
1920      * `quantity` - the amount to be transferred.
1921      *
1922      * Calling conditions:
1923      *
1924      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1925      * transferred to `to`.
1926      * - When `from` is zero, `tokenId` has been minted for `to`.
1927      * - When `to` is zero, `tokenId` has been burned by `from`.
1928      * - `from` and `to` are never both zero.
1929      */
1930     function _afterTokenTransfers(
1931         address from,
1932         address to,
1933         uint256 startTokenId,
1934         uint256 quantity
1935     ) internal virtual {}
1936 
1937     /**
1938      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1939      *
1940      * `from` - Previous owner of the given token ID.
1941      * `to` - Target address that will receive the token.
1942      * `tokenId` - Token ID to be transferred.
1943      * `_data` - Optional data to send along with the call.
1944      *
1945      * Returns whether the call correctly returned the expected magic value.
1946      */
1947     function _checkContractOnERC721Received(
1948         address from,
1949         address to,
1950         uint256 tokenId,
1951         bytes memory _data
1952     ) private returns (bool) {
1953         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1954             bytes4 retval
1955         ) {
1956             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1957         } catch (bytes memory reason) {
1958             if (reason.length == 0) {
1959                 revert TransferToNonERC721ReceiverImplementer();
1960             } else {
1961                 assembly {
1962                     revert(add(32, reason), mload(reason))
1963                 }
1964             }
1965         }
1966     }
1967 
1968     // =============================================================
1969     //                        MINT OPERATIONS
1970     // =============================================================
1971 
1972     /**
1973      * @dev Mints `quantity` tokens and transfers them to `to`.
1974      *
1975      * Requirements:
1976      *
1977      * - `to` cannot be the zero address.
1978      * - `quantity` must be greater than 0.
1979      *
1980      * Emits a {Transfer} event for each mint.
1981      */
1982     function _mint(address to, uint256 quantity) internal virtual {
1983         uint256 startTokenId = _currentIndex;
1984         if (quantity == 0) revert MintZeroQuantity();
1985 
1986         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1987 
1988         // Overflows are incredibly unrealistic.
1989         // `balance` and `numberMinted` have a maximum limit of 2**64.
1990         // `tokenId` has a maximum limit of 2**256.
1991         unchecked {
1992             // Updates:
1993             // - `balance += quantity`.
1994             // - `numberMinted += quantity`.
1995             //
1996             // We can directly add to the `balance` and `numberMinted`.
1997             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1998 
1999             // Updates:
2000             // - `address` to the owner.
2001             // - `startTimestamp` to the timestamp of minting.
2002             // - `burned` to `false`.
2003             // - `nextInitialized` to `quantity == 1`.
2004             _packedOwnerships[startTokenId] = _packOwnershipData(
2005                 to,
2006                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2007             );
2008 
2009             uint256 toMasked;
2010             uint256 end = startTokenId + quantity;
2011 
2012             // Use assembly to loop and emit the `Transfer` event for gas savings.
2013             // The duplicated `log4` removes an extra check and reduces stack juggling.
2014             // The assembly, together with the surrounding Solidity code, have been
2015             // delicately arranged to nudge the compiler into producing optimized opcodes.
2016             assembly {
2017                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2018                 toMasked := and(to, _BITMASK_ADDRESS)
2019                 // Emit the `Transfer` event.
2020                 log4(
2021                     0, // Start of data (0, since no data).
2022                     0, // End of data (0, since no data).
2023                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2024                     0, // `address(0)`.
2025                     toMasked, // `to`.
2026                     startTokenId // `tokenId`.
2027                 )
2028 
2029                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2030                 // that overflows uint256 will make the loop run out of gas.
2031                 // The compiler will optimize the `iszero` away for performance.
2032                 for {
2033                     let tokenId := add(startTokenId, 1)
2034                 } iszero(eq(tokenId, end)) {
2035                     tokenId := add(tokenId, 1)
2036                 } {
2037                     // Emit the `Transfer` event. Similar to above.
2038                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2039                 }
2040             }
2041             if (toMasked == 0) revert MintToZeroAddress();
2042 
2043             _currentIndex = end;
2044         }
2045         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2046     }
2047 
2048     /**
2049      * @dev Mints `quantity` tokens and transfers them to `to`.
2050      *
2051      * This function is intended for efficient minting only during contract creation.
2052      *
2053      * It emits only one {ConsecutiveTransfer} as defined in
2054      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2055      * instead of a sequence of {Transfer} event(s).
2056      *
2057      * Calling this function outside of contract creation WILL make your contract
2058      * non-compliant with the ERC721 standard.
2059      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2060      * {ConsecutiveTransfer} event is only permissible during contract creation.
2061      *
2062      * Requirements:
2063      *
2064      * - `to` cannot be the zero address.
2065      * - `quantity` must be greater than 0.
2066      *
2067      * Emits a {ConsecutiveTransfer} event.
2068      */
2069     function _mintERC2309(address to, uint256 quantity) internal virtual {
2070         uint256 startTokenId = _currentIndex;
2071         if (to == address(0)) revert MintToZeroAddress();
2072         if (quantity == 0) revert MintZeroQuantity();
2073         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2074 
2075         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2076 
2077         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2078         unchecked {
2079             // Updates:
2080             // - `balance += quantity`.
2081             // - `numberMinted += quantity`.
2082             //
2083             // We can directly add to the `balance` and `numberMinted`.
2084             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2085 
2086             // Updates:
2087             // - `address` to the owner.
2088             // - `startTimestamp` to the timestamp of minting.
2089             // - `burned` to `false`.
2090             // - `nextInitialized` to `quantity == 1`.
2091             _packedOwnerships[startTokenId] = _packOwnershipData(
2092                 to,
2093                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2094             );
2095 
2096             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2097 
2098             _currentIndex = startTokenId + quantity;
2099         }
2100         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2101     }
2102 
2103     /**
2104      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2105      *
2106      * Requirements:
2107      *
2108      * - If `to` refers to a smart contract, it must implement
2109      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2110      * - `quantity` must be greater than 0.
2111      *
2112      * See {_mint}.
2113      *
2114      * Emits a {Transfer} event for each mint.
2115      */
2116     function _safeMint(
2117         address to,
2118         uint256 quantity,
2119         bytes memory _data
2120     ) internal virtual {
2121         _mint(to, quantity);
2122 
2123         unchecked {
2124             if (to.code.length != 0) {
2125                 uint256 end = _currentIndex;
2126                 uint256 index = end - quantity;
2127                 do {
2128                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2129                         revert TransferToNonERC721ReceiverImplementer();
2130                     }
2131                 } while (index < end);
2132                 // Reentrancy protection.
2133                 if (_currentIndex != end) revert();
2134             }
2135         }
2136     }
2137 
2138     /**
2139      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2140      */
2141     function _safeMint(address to, uint256 quantity) internal virtual {
2142         _safeMint(to, quantity, '');
2143     }
2144 
2145     // =============================================================
2146     //                        BURN OPERATIONS
2147     // =============================================================
2148 
2149     /**
2150      * @dev Equivalent to `_burn(tokenId, false)`.
2151      */
2152     function _burn(uint256 tokenId) internal virtual {
2153         _burn(tokenId, false);
2154     }
2155 
2156     /**
2157      * @dev Destroys `tokenId`.
2158      * The approval is cleared when the token is burned.
2159      *
2160      * Requirements:
2161      *
2162      * - `tokenId` must exist.
2163      *
2164      * Emits a {Transfer} event.
2165      */
2166     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2167         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2168 
2169         address from = address(uint160(prevOwnershipPacked));
2170 
2171         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2172 
2173         if (approvalCheck) {
2174             // The nested ifs save around 20+ gas over a compound boolean condition.
2175             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2176                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2177         }
2178 
2179         _beforeTokenTransfers(from, address(0), tokenId, 1);
2180 
2181         // Clear approvals from the previous owner.
2182         assembly {
2183             if approvedAddress {
2184                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2185                 sstore(approvedAddressSlot, 0)
2186             }
2187         }
2188 
2189         // Underflow of the sender's balance is impossible because we check for
2190         // ownership above and the recipient's balance can't realistically overflow.
2191         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2192         unchecked {
2193             // Updates:
2194             // - `balance -= 1`.
2195             // - `numberBurned += 1`.
2196             //
2197             // We can directly decrement the balance, and increment the number burned.
2198             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2199             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2200 
2201             // Updates:
2202             // - `address` to the last owner.
2203             // - `startTimestamp` to the timestamp of burning.
2204             // - `burned` to `true`.
2205             // - `nextInitialized` to `true`.
2206             _packedOwnerships[tokenId] = _packOwnershipData(
2207                 from,
2208                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2209             );
2210 
2211             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2212             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2213                 uint256 nextTokenId = tokenId + 1;
2214                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2215                 if (_packedOwnerships[nextTokenId] == 0) {
2216                     // If the next slot is within bounds.
2217                     if (nextTokenId != _currentIndex) {
2218                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2219                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2220                     }
2221                 }
2222             }
2223         }
2224 
2225         emit Transfer(from, address(0), tokenId);
2226         _afterTokenTransfers(from, address(0), tokenId, 1);
2227 
2228         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2229         unchecked {
2230             _burnCounter++;
2231         }
2232     }
2233 
2234     // =============================================================
2235     //                     EXTRA DATA OPERATIONS
2236     // =============================================================
2237 
2238     /**
2239      * @dev Directly sets the extra data for the ownership data `index`.
2240      */
2241     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2242         uint256 packed = _packedOwnerships[index];
2243         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2244         uint256 extraDataCasted;
2245         // Cast `extraData` with assembly to avoid redundant masking.
2246         assembly {
2247             extraDataCasted := extraData
2248         }
2249         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2250         _packedOwnerships[index] = packed;
2251     }
2252 
2253     /**
2254      * @dev Called during each token transfer to set the 24bit `extraData` field.
2255      * Intended to be overridden by the cosumer contract.
2256      *
2257      * `previousExtraData` - the value of `extraData` before transfer.
2258      *
2259      * Calling conditions:
2260      *
2261      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2262      * transferred to `to`.
2263      * - When `from` is zero, `tokenId` will be minted for `to`.
2264      * - When `to` is zero, `tokenId` will be burned by `from`.
2265      * - `from` and `to` are never both zero.
2266      */
2267     function _extraData(
2268         address from,
2269         address to,
2270         uint24 previousExtraData
2271     ) internal view virtual returns (uint24) {}
2272 
2273     /**
2274      * @dev Returns the next extra data for the packed ownership data.
2275      * The returned result is shifted into position.
2276      */
2277     function _nextExtraData(
2278         address from,
2279         address to,
2280         uint256 prevOwnershipPacked
2281     ) private view returns (uint256) {
2282         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2283         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2284     }
2285 
2286     // =============================================================
2287     //                       OTHER OPERATIONS
2288     // =============================================================
2289 
2290     /**
2291      * @dev Returns the message sender (defaults to `msg.sender`).
2292      *
2293      * If you are writing GSN compatible contracts, you need to override this function.
2294      */
2295     function _msgSenderERC721A() internal view virtual returns (address) {
2296         return msg.sender;
2297     }
2298 
2299     /**
2300      * @dev Converts a uint256 to its ASCII string decimal representation.
2301      */
2302     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2303         assembly {
2304             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2305             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2306             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2307             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2308             let m := add(mload(0x40), 0xa0)
2309             // Update the free memory pointer to allocate.
2310             mstore(0x40, m)
2311             // Assign the `str` to the end.
2312             str := sub(m, 0x20)
2313             // Zeroize the slot after the string.
2314             mstore(str, 0)
2315 
2316             // Cache the end of the memory to calculate the length later.
2317             let end := str
2318 
2319             // We write the string from rightmost digit to leftmost digit.
2320             // The following is essentially a do-while loop that also handles the zero case.
2321             // prettier-ignore
2322             for { let temp := value } 1 {} {
2323                 str := sub(str, 1)
2324                 // Write the character to the pointer.
2325                 // The ASCII index of the '0' character is 48.
2326                 mstore8(str, add(48, mod(temp, 10)))
2327                 // Keep dividing `temp` until zero.
2328                 temp := div(temp, 10)
2329                 // prettier-ignore
2330                 if iszero(temp) { break }
2331             }
2332 
2333             let length := sub(end, str)
2334             // Move the pointer 32 bytes leftwards to make room for the length.
2335             str := sub(str, 0x20)
2336             // Store the length.
2337             mstore(str, length)
2338         }
2339     }
2340 }
2341 
2342 
2343 // File contracts/OP3NMINDS.sol
2344 
2345 //SPDX-License-Identifier: MIT
2346 pragma solidity ^0.8.19;
2347 error noContract();
2348 error Paused();
2349 error NotActiveYet();
2350 error AllowNotActive();
2351 error MaxSupplyReached();
2352 error NotAllowListed();
2353 error NotEnoughEther();
2354 error MaximumMintsReached();
2355 error TeamAlreadyMinted();
2356 
2357 contract OP3NMINDS is ERC721A, Ownable, ERC2981 {
2358     using Strings for uint256;
2359 
2360     uint256 public constant MAX_SUPPLY = 1100;
2361     uint256 public constant MAX_PUBLIC_MINT = 10;
2362     uint256 public constant MAX_MINDLIST_MINT = 10;
2363     uint256 public constant MAX_RILLALIST_MINT = 10;
2364     uint256 public constant PUBLIC_SALE_PRICE = 0.045 ether;
2365     uint256 public constant MINDLIST_SALE_PRICE = 0.035 ether;
2366     uint256 public constant RILLALIST_SALE_PRICE = 0.015 ether; 
2367 
2368     string private baseTokenUri;
2369     string public hiddenURI;
2370 
2371     //deploy smart contract, toggle WL, toggle WL when done, toggle publicSale
2372     bool public isRevealed;
2373     bool public publicSale;
2374     bool public allowListSale;
2375     bool public teamMinted;
2376     bool public paused;
2377 
2378     bytes32 private merkleRootRilla;
2379     bytes32 private merkleRootMind;
2380 
2381     mapping(address => uint256) public totalPublicMint;
2382     mapping(address => uint256) public totalMindListMint;
2383     mapping(address => uint256) public totalRillaListMint;
2384 
2385     constructor(
2386         uint96 _royaltyFeesInBips,
2387         address _royaltyAddress,
2388         string memory _hiddenURI,
2389         bytes32 _merkleRootRilla,
2390         bytes32 _merkleRootMind
2391     ) ERC721A("OP3NMINDS", "OP3N") {
2392         _setDefaultRoyalty(_royaltyAddress, _royaltyFeesInBips);
2393         hiddenURI = _hiddenURI;
2394         merkleRootRilla = _merkleRootRilla;
2395         merkleRootMind = _merkleRootMind;
2396     }
2397 
2398     function mint(uint256 _quantity) external payable {
2399         if (paused) revert Paused();
2400         if (!publicSale) revert NotActiveYet();
2401         if (totalSupply() + _quantity > MAX_SUPPLY) revert MaxSupplyReached();
2402         if (totalPublicMint[msg.sender] + _quantity > MAX_PUBLIC_MINT)
2403             revert MaximumMintsReached();
2404         if (msg.value < (PUBLIC_SALE_PRICE * _quantity))
2405             revert NotEnoughEther();
2406 
2407         totalPublicMint[msg.sender] += _quantity;
2408         _mint(msg.sender, _quantity);
2409     }
2410 
2411     function rillalistMint(
2412         bytes32[] memory _merkleProof,
2413         uint256 _quantity
2414     ) external payable {
2415         if (paused) revert Paused();
2416         if (!allowListSale) revert AllowNotActive();
2417         if (totalSupply() + _quantity > MAX_SUPPLY) revert MaxSupplyReached();
2418         if (totalRillaListMint[msg.sender] + _quantity > MAX_RILLALIST_MINT)
2419             revert MaximumMintsReached();
2420         if (msg.value < (RILLALIST_SALE_PRICE * _quantity))
2421             revert NotEnoughEther();
2422         bytes32 sender = keccak256(abi.encodePacked(msg.sender));
2423         if (MerkleProof.verify(_merkleProof, merkleRootRilla, sender) == false)
2424             revert NotAllowListed();
2425 
2426         totalRillaListMint[msg.sender] += _quantity;
2427         _mint(msg.sender, _quantity);
2428     }
2429 
2430     function mindlistMint(
2431         bytes32[] memory _merkleProof,
2432         uint256 _quantity
2433     ) external payable {
2434         if (paused) revert Paused();
2435         if (!allowListSale) revert AllowNotActive();
2436         if (totalSupply() + _quantity > MAX_SUPPLY) revert MaxSupplyReached();
2437         if (totalMindListMint[msg.sender] + _quantity > MAX_MINDLIST_MINT)
2438             revert MaximumMintsReached();
2439         if (msg.value < (MINDLIST_SALE_PRICE * _quantity))
2440             revert NotEnoughEther();
2441         bytes32 sender = keccak256(abi.encodePacked(msg.sender));
2442         if (MerkleProof.verify(_merkleProof, merkleRootMind, sender) == false)
2443             revert NotAllowListed();
2444 
2445         totalMindListMint[msg.sender] += _quantity;
2446         _mint(msg.sender, _quantity);
2447     }
2448 
2449     function teamMint() external onlyOwner {
2450         if (teamMinted) revert TeamAlreadyMinted();
2451         teamMinted = true;
2452         _mint(msg.sender, 10);
2453     }
2454 
2455     function adminMint(address _address, uint256 _amount) external onlyOwner {
2456         _mint(_address, _amount);
2457     }
2458 
2459     function _baseURI() internal view virtual override returns (string memory) {
2460         return baseTokenUri;
2461     }
2462 
2463     function tokenURI(
2464         uint256 tokenId
2465     ) public view virtual override returns (string memory) {
2466         require(
2467             _exists(tokenId),
2468             "ERC721Metadata: URI query for nonexistent token"
2469         );
2470 
2471         if (!isRevealed) {
2472             return hiddenURI;
2473         }
2474 
2475         return
2476             bytes(baseTokenUri).length > 0
2477                 ? string(
2478                     abi.encodePacked(baseTokenUri, tokenId.toString(), ".json")
2479                 )
2480                 : "";
2481     }
2482 
2483     function _startTokenId() internal pure virtual override returns (uint256) {
2484         return 1;
2485     }
2486 
2487     function supportsInterface(
2488         bytes4 interfaceId
2489     ) public view virtual override(ERC721A, ERC2981) returns (bool) {
2490         return super.supportsInterface(interfaceId);
2491     }
2492 
2493     //Only Owner Functions
2494     function setRoyaltyInfo(
2495         address _receiver,
2496         uint96 _royaltyFeesInBips
2497     ) external onlyOwner {
2498         _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
2499     }
2500 
2501     function setTokenUri(string memory _baseTokenUri) external onlyOwner {
2502         baseTokenUri = _baseTokenUri;
2503     }
2504 
2505     function setHiddenUri(string memory _hiddenURI) external onlyOwner {
2506         hiddenURI = _hiddenURI;
2507     }
2508 
2509     function setRillaMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2510         merkleRootRilla = _merkleRoot;
2511     }
2512 
2513     function setMindMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2514         merkleRootMind = _merkleRoot;
2515     }
2516 
2517     function getMerkleRoot() external view returns (bytes32) {
2518         return merkleRootRilla;
2519     }
2520 
2521     function getMerkleAllowRoot() external view returns (bytes32) {
2522         return merkleRootMind;
2523     }
2524 
2525     function toggleAllowListSale() external onlyOwner {
2526         allowListSale = !allowListSale;
2527     }
2528 
2529     function togglePublicSale() external onlyOwner {
2530         publicSale = !publicSale;
2531     }
2532 
2533     function toggleReveal() external onlyOwner {
2534         isRevealed = !isRevealed;
2535     }
2536 
2537     function togglePause() external onlyOwner {
2538         paused = !paused;
2539     }
2540 
2541     function withdraw() external onlyOwner {
2542         uint256 withdrawAmount_20 = ((address(this).balance) * 20) / 100;
2543         (bool sent, ) = payable(0x0E1a590c79aB1f77E6BB70dAF0B4BcF77243bBc7).call{value: withdrawAmount_20}("");
2544         require(sent, "Artist cut not sent");
2545         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2546         require(success, "Payment not sent");
2547     }
2548 }