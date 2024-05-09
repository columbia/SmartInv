1 // File @openzeppelin/contracts/utils/Context.sol@v4.8.1
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 
29 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.1
30 
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 
114 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.1
115 
116 
117 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Interface of the ERC165 standard, as defined in the
123  * https://eips.ethereum.org/EIPS/eip-165[EIP].
124  *
125  * Implementers can declare support of contract interfaces, which can then be
126  * queried by others ({ERC165Checker}).
127  *
128  * For an implementation, see {ERC165}.
129  */
130 interface IERC165 {
131     /**
132      * @dev Returns true if this contract implements the interface defined by
133      * `interfaceId`. See the corresponding
134      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
135      * to learn more about how these ids are created.
136      *
137      * This function call must use less than 30 000 gas.
138      */
139     function supportsInterface(bytes4 interfaceId) external view returns (bool);
140 }
141 
142 
143 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.8.1
144 
145 
146 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Interface for the NFT Royalty Standard.
152  *
153  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
154  * support for royalty payments across all NFT marketplaces and ecosystem participants.
155  *
156  * _Available since v4.5._
157  */
158 interface IERC2981 is IERC165 {
159     /**
160      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
161      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
162      */
163     function royaltyInfo(uint256 tokenId, uint256 salePrice)
164         external
165         view
166         returns (address receiver, uint256 royaltyAmount);
167 }
168 
169 
170 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.1
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @dev Implementation of the {IERC165} interface.
179  *
180  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
181  * for the additional interface id that will be supported. For example:
182  *
183  * ```solidity
184  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
185  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
186  * }
187  * ```
188  *
189  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
190  */
191 abstract contract ERC165 is IERC165 {
192     /**
193      * @dev See {IERC165-supportsInterface}.
194      */
195     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
196         return interfaceId == type(IERC165).interfaceId;
197     }
198 }
199 
200 
201 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.8.1
202 
203 
204 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
211  *
212  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
213  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
214  *
215  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
216  * fee is specified in basis points by default.
217  *
218  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
219  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
220  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
221  *
222  * _Available since v4.5._
223  */
224 abstract contract ERC2981 is IERC2981, ERC165 {
225     struct RoyaltyInfo {
226         address receiver;
227         uint96 royaltyFraction;
228     }
229 
230     RoyaltyInfo private _defaultRoyaltyInfo;
231     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
232 
233     /**
234      * @dev See {IERC165-supportsInterface}.
235      */
236     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
237         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
238     }
239 
240     /**
241      * @inheritdoc IERC2981
242      */
243     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
244         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
245 
246         if (royalty.receiver == address(0)) {
247             royalty = _defaultRoyaltyInfo;
248         }
249 
250         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
251 
252         return (royalty.receiver, royaltyAmount);
253     }
254 
255     /**
256      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
257      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
258      * override.
259      */
260     function _feeDenominator() internal pure virtual returns (uint96) {
261         return 10000;
262     }
263 
264     /**
265      * @dev Sets the royalty information that all ids in this contract will default to.
266      *
267      * Requirements:
268      *
269      * - `receiver` cannot be the zero address.
270      * - `feeNumerator` cannot be greater than the fee denominator.
271      */
272     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
273         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
274         require(receiver != address(0), "ERC2981: invalid receiver");
275 
276         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
277     }
278 
279     /**
280      * @dev Removes default royalty information.
281      */
282     function _deleteDefaultRoyalty() internal virtual {
283         delete _defaultRoyaltyInfo;
284     }
285 
286     /**
287      * @dev Sets the royalty information for a specific token id, overriding the global default.
288      *
289      * Requirements:
290      *
291      * - `receiver` cannot be the zero address.
292      * - `feeNumerator` cannot be greater than the fee denominator.
293      */
294     function _setTokenRoyalty(
295         uint256 tokenId,
296         address receiver,
297         uint96 feeNumerator
298     ) internal virtual {
299         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
300         require(receiver != address(0), "ERC2981: Invalid parameters");
301 
302         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
303     }
304 
305     /**
306      * @dev Resets royalty information for the token id back to the global default.
307      */
308     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
309         delete _tokenRoyaltyInfo[tokenId];
310     }
311 }
312 
313 
314 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.1
315 
316 
317 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Standard math utilities missing in the Solidity language.
323  */
324 library Math {
325     enum Rounding {
326         Down, // Toward negative infinity
327         Up, // Toward infinity
328         Zero // Toward zero
329     }
330 
331     /**
332      * @dev Returns the largest of two numbers.
333      */
334     function max(uint256 a, uint256 b) internal pure returns (uint256) {
335         return a > b ? a : b;
336     }
337 
338     /**
339      * @dev Returns the smallest of two numbers.
340      */
341     function min(uint256 a, uint256 b) internal pure returns (uint256) {
342         return a < b ? a : b;
343     }
344 
345     /**
346      * @dev Returns the average of two numbers. The result is rounded towards
347      * zero.
348      */
349     function average(uint256 a, uint256 b) internal pure returns (uint256) {
350         // (a + b) / 2 can overflow.
351         return (a & b) + (a ^ b) / 2;
352     }
353 
354     /**
355      * @dev Returns the ceiling of the division of two numbers.
356      *
357      * This differs from standard division with `/` in that it rounds up instead
358      * of rounding down.
359      */
360     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
361         // (a + b - 1) / b can overflow on addition, so we distribute.
362         return a == 0 ? 0 : (a - 1) / b + 1;
363     }
364 
365     /**
366      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
367      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
368      * with further edits by Uniswap Labs also under MIT license.
369      */
370     function mulDiv(
371         uint256 x,
372         uint256 y,
373         uint256 denominator
374     ) internal pure returns (uint256 result) {
375         unchecked {
376             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
377             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
378             // variables such that product = prod1 * 2^256 + prod0.
379             uint256 prod0; // Least significant 256 bits of the product
380             uint256 prod1; // Most significant 256 bits of the product
381             assembly {
382                 let mm := mulmod(x, y, not(0))
383                 prod0 := mul(x, y)
384                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
385             }
386 
387             // Handle non-overflow cases, 256 by 256 division.
388             if (prod1 == 0) {
389                 return prod0 / denominator;
390             }
391 
392             // Make sure the result is less than 2^256. Also prevents denominator == 0.
393             require(denominator > prod1);
394 
395             ///////////////////////////////////////////////
396             // 512 by 256 division.
397             ///////////////////////////////////////////////
398 
399             // Make division exact by subtracting the remainder from [prod1 prod0].
400             uint256 remainder;
401             assembly {
402                 // Compute remainder using mulmod.
403                 remainder := mulmod(x, y, denominator)
404 
405                 // Subtract 256 bit number from 512 bit number.
406                 prod1 := sub(prod1, gt(remainder, prod0))
407                 prod0 := sub(prod0, remainder)
408             }
409 
410             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
411             // See https://cs.stackexchange.com/q/138556/92363.
412 
413             // Does not overflow because the denominator cannot be zero at this stage in the function.
414             uint256 twos = denominator & (~denominator + 1);
415             assembly {
416                 // Divide denominator by twos.
417                 denominator := div(denominator, twos)
418 
419                 // Divide [prod1 prod0] by twos.
420                 prod0 := div(prod0, twos)
421 
422                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
423                 twos := add(div(sub(0, twos), twos), 1)
424             }
425 
426             // Shift in bits from prod1 into prod0.
427             prod0 |= prod1 * twos;
428 
429             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
430             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
431             // four bits. That is, denominator * inv = 1 mod 2^4.
432             uint256 inverse = (3 * denominator) ^ 2;
433 
434             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
435             // in modular arithmetic, doubling the correct bits in each step.
436             inverse *= 2 - denominator * inverse; // inverse mod 2^8
437             inverse *= 2 - denominator * inverse; // inverse mod 2^16
438             inverse *= 2 - denominator * inverse; // inverse mod 2^32
439             inverse *= 2 - denominator * inverse; // inverse mod 2^64
440             inverse *= 2 - denominator * inverse; // inverse mod 2^128
441             inverse *= 2 - denominator * inverse; // inverse mod 2^256
442 
443             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
444             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
445             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
446             // is no longer required.
447             result = prod0 * inverse;
448             return result;
449         }
450     }
451 
452     /**
453      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
454      */
455     function mulDiv(
456         uint256 x,
457         uint256 y,
458         uint256 denominator,
459         Rounding rounding
460     ) internal pure returns (uint256) {
461         uint256 result = mulDiv(x, y, denominator);
462         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
463             result += 1;
464         }
465         return result;
466     }
467 
468     /**
469      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
470      *
471      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
472      */
473     function sqrt(uint256 a) internal pure returns (uint256) {
474         if (a == 0) {
475             return 0;
476         }
477 
478         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
479         //
480         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
481         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
482         //
483         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
484         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
485         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
486         //
487         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
488         uint256 result = 1 << (log2(a) >> 1);
489 
490         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
491         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
492         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
493         // into the expected uint128 result.
494         unchecked {
495             result = (result + a / result) >> 1;
496             result = (result + a / result) >> 1;
497             result = (result + a / result) >> 1;
498             result = (result + a / result) >> 1;
499             result = (result + a / result) >> 1;
500             result = (result + a / result) >> 1;
501             result = (result + a / result) >> 1;
502             return min(result, a / result);
503         }
504     }
505 
506     /**
507      * @notice Calculates sqrt(a), following the selected rounding direction.
508      */
509     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
510         unchecked {
511             uint256 result = sqrt(a);
512             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
513         }
514     }
515 
516     /**
517      * @dev Return the log in base 2, rounded down, of a positive value.
518      * Returns 0 if given 0.
519      */
520     function log2(uint256 value) internal pure returns (uint256) {
521         uint256 result = 0;
522         unchecked {
523             if (value >> 128 > 0) {
524                 value >>= 128;
525                 result += 128;
526             }
527             if (value >> 64 > 0) {
528                 value >>= 64;
529                 result += 64;
530             }
531             if (value >> 32 > 0) {
532                 value >>= 32;
533                 result += 32;
534             }
535             if (value >> 16 > 0) {
536                 value >>= 16;
537                 result += 16;
538             }
539             if (value >> 8 > 0) {
540                 value >>= 8;
541                 result += 8;
542             }
543             if (value >> 4 > 0) {
544                 value >>= 4;
545                 result += 4;
546             }
547             if (value >> 2 > 0) {
548                 value >>= 2;
549                 result += 2;
550             }
551             if (value >> 1 > 0) {
552                 result += 1;
553             }
554         }
555         return result;
556     }
557 
558     /**
559      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
560      * Returns 0 if given 0.
561      */
562     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
563         unchecked {
564             uint256 result = log2(value);
565             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
566         }
567     }
568 
569     /**
570      * @dev Return the log in base 10, rounded down, of a positive value.
571      * Returns 0 if given 0.
572      */
573     function log10(uint256 value) internal pure returns (uint256) {
574         uint256 result = 0;
575         unchecked {
576             if (value >= 10**64) {
577                 value /= 10**64;
578                 result += 64;
579             }
580             if (value >= 10**32) {
581                 value /= 10**32;
582                 result += 32;
583             }
584             if (value >= 10**16) {
585                 value /= 10**16;
586                 result += 16;
587             }
588             if (value >= 10**8) {
589                 value /= 10**8;
590                 result += 8;
591             }
592             if (value >= 10**4) {
593                 value /= 10**4;
594                 result += 4;
595             }
596             if (value >= 10**2) {
597                 value /= 10**2;
598                 result += 2;
599             }
600             if (value >= 10**1) {
601                 result += 1;
602             }
603         }
604         return result;
605     }
606 
607     /**
608      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
609      * Returns 0 if given 0.
610      */
611     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
612         unchecked {
613             uint256 result = log10(value);
614             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
615         }
616     }
617 
618     /**
619      * @dev Return the log in base 256, rounded down, of a positive value.
620      * Returns 0 if given 0.
621      *
622      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
623      */
624     function log256(uint256 value) internal pure returns (uint256) {
625         uint256 result = 0;
626         unchecked {
627             if (value >> 128 > 0) {
628                 value >>= 128;
629                 result += 16;
630             }
631             if (value >> 64 > 0) {
632                 value >>= 64;
633                 result += 8;
634             }
635             if (value >> 32 > 0) {
636                 value >>= 32;
637                 result += 4;
638             }
639             if (value >> 16 > 0) {
640                 value >>= 16;
641                 result += 2;
642             }
643             if (value >> 8 > 0) {
644                 result += 1;
645             }
646         }
647         return result;
648     }
649 
650     /**
651      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
652      * Returns 0 if given 0.
653      */
654     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
655         unchecked {
656             uint256 result = log256(value);
657             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
658         }
659     }
660 }
661 
662 
663 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.1
664 
665 
666 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @dev String operations.
672  */
673 library Strings {
674     bytes16 private constant _SYMBOLS = "0123456789abcdef";
675     uint8 private constant _ADDRESS_LENGTH = 20;
676 
677     /**
678      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
679      */
680     function toString(uint256 value) internal pure returns (string memory) {
681         unchecked {
682             uint256 length = Math.log10(value) + 1;
683             string memory buffer = new string(length);
684             uint256 ptr;
685             /// @solidity memory-safe-assembly
686             assembly {
687                 ptr := add(buffer, add(32, length))
688             }
689             while (true) {
690                 ptr--;
691                 /// @solidity memory-safe-assembly
692                 assembly {
693                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
694                 }
695                 value /= 10;
696                 if (value == 0) break;
697             }
698             return buffer;
699         }
700     }
701 
702     /**
703      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
704      */
705     function toHexString(uint256 value) internal pure returns (string memory) {
706         unchecked {
707             return toHexString(value, Math.log256(value) + 1);
708         }
709     }
710 
711     /**
712      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
713      */
714     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
715         bytes memory buffer = new bytes(2 * length + 2);
716         buffer[0] = "0";
717         buffer[1] = "x";
718         for (uint256 i = 2 * length + 1; i > 1; --i) {
719             buffer[i] = _SYMBOLS[value & 0xf];
720             value >>= 4;
721         }
722         require(value == 0, "Strings: hex length insufficient");
723         return string(buffer);
724     }
725 
726     /**
727      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
728      */
729     function toHexString(address addr) internal pure returns (string memory) {
730         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
731     }
732 }
733 
734 
735 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.1
736 
737 
738 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 /**
743  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
744  *
745  * These functions can be used to verify that a message was signed by the holder
746  * of the private keys of a given address.
747  */
748 library ECDSA {
749     enum RecoverError {
750         NoError,
751         InvalidSignature,
752         InvalidSignatureLength,
753         InvalidSignatureS,
754         InvalidSignatureV // Deprecated in v4.8
755     }
756 
757     function _throwError(RecoverError error) private pure {
758         if (error == RecoverError.NoError) {
759             return; // no error: do nothing
760         } else if (error == RecoverError.InvalidSignature) {
761             revert("ECDSA: invalid signature");
762         } else if (error == RecoverError.InvalidSignatureLength) {
763             revert("ECDSA: invalid signature length");
764         } else if (error == RecoverError.InvalidSignatureS) {
765             revert("ECDSA: invalid signature 's' value");
766         }
767     }
768 
769     /**
770      * @dev Returns the address that signed a hashed message (`hash`) with
771      * `signature` or error string. This address can then be used for verification purposes.
772      *
773      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
774      * this function rejects them by requiring the `s` value to be in the lower
775      * half order, and the `v` value to be either 27 or 28.
776      *
777      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
778      * verification to be secure: it is possible to craft signatures that
779      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
780      * this is by receiving a hash of the original message (which may otherwise
781      * be too long), and then calling {toEthSignedMessageHash} on it.
782      *
783      * Documentation for signature generation:
784      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
785      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
786      *
787      * _Available since v4.3._
788      */
789     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
790         if (signature.length == 65) {
791             bytes32 r;
792             bytes32 s;
793             uint8 v;
794             // ecrecover takes the signature parameters, and the only way to get them
795             // currently is to use assembly.
796             /// @solidity memory-safe-assembly
797             assembly {
798                 r := mload(add(signature, 0x20))
799                 s := mload(add(signature, 0x40))
800                 v := byte(0, mload(add(signature, 0x60)))
801             }
802             return tryRecover(hash, v, r, s);
803         } else {
804             return (address(0), RecoverError.InvalidSignatureLength);
805         }
806     }
807 
808     /**
809      * @dev Returns the address that signed a hashed message (`hash`) with
810      * `signature`. This address can then be used for verification purposes.
811      *
812      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
813      * this function rejects them by requiring the `s` value to be in the lower
814      * half order, and the `v` value to be either 27 or 28.
815      *
816      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
817      * verification to be secure: it is possible to craft signatures that
818      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
819      * this is by receiving a hash of the original message (which may otherwise
820      * be too long), and then calling {toEthSignedMessageHash} on it.
821      */
822     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
823         (address recovered, RecoverError error) = tryRecover(hash, signature);
824         _throwError(error);
825         return recovered;
826     }
827 
828     /**
829      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
830      *
831      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
832      *
833      * _Available since v4.3._
834      */
835     function tryRecover(
836         bytes32 hash,
837         bytes32 r,
838         bytes32 vs
839     ) internal pure returns (address, RecoverError) {
840         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
841         uint8 v = uint8((uint256(vs) >> 255) + 27);
842         return tryRecover(hash, v, r, s);
843     }
844 
845     /**
846      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
847      *
848      * _Available since v4.2._
849      */
850     function recover(
851         bytes32 hash,
852         bytes32 r,
853         bytes32 vs
854     ) internal pure returns (address) {
855         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
856         _throwError(error);
857         return recovered;
858     }
859 
860     /**
861      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
862      * `r` and `s` signature fields separately.
863      *
864      * _Available since v4.3._
865      */
866     function tryRecover(
867         bytes32 hash,
868         uint8 v,
869         bytes32 r,
870         bytes32 s
871     ) internal pure returns (address, RecoverError) {
872         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
873         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
874         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
875         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
876         //
877         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
878         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
879         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
880         // these malleable signatures as well.
881         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
882             return (address(0), RecoverError.InvalidSignatureS);
883         }
884 
885         // If the signature is valid (and not malleable), return the signer address
886         address signer = ecrecover(hash, v, r, s);
887         if (signer == address(0)) {
888             return (address(0), RecoverError.InvalidSignature);
889         }
890 
891         return (signer, RecoverError.NoError);
892     }
893 
894     /**
895      * @dev Overload of {ECDSA-recover} that receives the `v`,
896      * `r` and `s` signature fields separately.
897      */
898     function recover(
899         bytes32 hash,
900         uint8 v,
901         bytes32 r,
902         bytes32 s
903     ) internal pure returns (address) {
904         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
905         _throwError(error);
906         return recovered;
907     }
908 
909     /**
910      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
911      * produces hash corresponding to the one signed with the
912      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
913      * JSON-RPC method as part of EIP-191.
914      *
915      * See {recover}.
916      */
917     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
918         // 32 is the length in bytes of hash,
919         // enforced by the type signature above
920         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
921     }
922 
923     /**
924      * @dev Returns an Ethereum Signed Message, created from `s`. This
925      * produces hash corresponding to the one signed with the
926      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
927      * JSON-RPC method as part of EIP-191.
928      *
929      * See {recover}.
930      */
931     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
932         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
933     }
934 
935     /**
936      * @dev Returns an Ethereum Signed Typed Data, created from a
937      * `domainSeparator` and a `structHash`. This produces hash corresponding
938      * to the one signed with the
939      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
940      * JSON-RPC method as part of EIP-712.
941      *
942      * See {recover}.
943      */
944     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
945         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
946     }
947 }
948 
949 
950 // File contracts/IERC721A.sol
951 
952 
953 // ERC721A Contracts v4.2.2
954 // Creator: Chiru Labs
955 
956 pragma solidity ^0.8.4;
957 
958 /**
959  * @dev Interface of ERC721A.
960  */
961 interface IERC721A {
962     /**
963      * The caller must own the token or be an approved operator.
964      */
965     error ApprovalCallerNotOwnerNorApproved();
966 
967     /**
968      * The token does not exist.
969      */
970     error ApprovalQueryForNonexistentToken();
971 
972     /**
973      * The caller cannot approve to their own address.
974      */
975     error ApproveToCaller();
976 
977     /**
978      * Cannot query the balance for the zero address.
979      */
980     error BalanceQueryForZeroAddress();
981 
982     /**
983      * Cannot mint to the zero address.
984      */
985     error MintToZeroAddress();
986 
987     /**
988      * The quantity of tokens minted must be more than zero.
989      */
990     error MintZeroQuantity();
991 
992     /**
993      * The token does not exist.
994      */
995     error OwnerQueryForNonexistentToken();
996 
997     /**
998      * The caller must own the token or be an approved operator.
999      */
1000     error TransferCallerNotOwnerNorApproved();
1001 
1002     /**
1003      * The token must be owned by `from`.
1004      */
1005     error TransferFromIncorrectOwner();
1006 
1007     /**
1008      * Cannot safely transfer to a contract that does not implement the
1009      * ERC721Receiver interface.
1010      */
1011     error TransferToNonERC721ReceiverImplementer();
1012 
1013     /**
1014      * Cannot transfer to the zero address.
1015      */
1016     error TransferToZeroAddress();
1017 
1018     /**
1019      * The token does not exist.
1020      */
1021     error URIQueryForNonexistentToken();
1022 
1023     /**
1024      * The `quantity` minted with ERC2309 exceeds the safety limit.
1025      */
1026     error MintERC2309QuantityExceedsLimit();
1027 
1028     /**
1029      * The `extraData` cannot be set on an unintialized ownership slot.
1030      */
1031     error OwnershipNotInitializedForExtraData();
1032 
1033     // =============================================================
1034     //                            STRUCTS
1035     // =============================================================
1036 
1037     struct TokenOwnership {
1038         // The address of the owner.
1039         address addr;
1040         // Stores the start time of ownership with minimal overhead for tokenomics.
1041         uint64 startTimestamp;
1042         // Whether the token has been burned.
1043         bool burned;
1044         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1045         uint24 extraData;
1046     }
1047 
1048     // =============================================================
1049     //                         TOKEN COUNTERS
1050     // =============================================================
1051 
1052     /**
1053      * @dev Returns the total number of tokens in existence.
1054      * Burned tokens will reduce the count.
1055      * To get the total number of tokens minted, please see {_totalMinted}.
1056      */
1057     function totalSupply() external view returns (uint256);
1058 
1059     // =============================================================
1060     //                            IERC165
1061     // =============================================================
1062 
1063     /**
1064      * @dev Returns true if this contract implements the interface defined by
1065      * `interfaceId`. See the corresponding
1066      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1067      * to learn more about how these ids are created.
1068      *
1069      * This function call must use less than 30000 gas.
1070      */
1071     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1072 
1073     // =============================================================
1074     //                            IERC721
1075     // =============================================================
1076 
1077     /**
1078      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1079      */
1080     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1081 
1082     /**
1083      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1084      */
1085     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1086 
1087     /**
1088      * @dev Emitted when `owner` enables or disables
1089      * (`approved`) `operator` to manage all of its assets.
1090      */
1091     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1092 
1093     /**
1094      * @dev Returns the number of tokens in `owner`'s account.
1095      */
1096     function balanceOf(address owner) external view returns (uint256 balance);
1097 
1098     /**
1099      * @dev Returns the owner of the `tokenId` token.
1100      *
1101      * Requirements:
1102      *
1103      * - `tokenId` must exist.
1104      */
1105     function ownerOf(uint256 tokenId) external view returns (address owner);
1106 
1107     /**
1108      * @dev Safely transfers `tokenId` token from `from` to `to`,
1109      * checking first that contract recipients are aware of the ERC721 protocol
1110      * to prevent tokens from being forever locked.
1111      *
1112      * Requirements:
1113      *
1114      * - `from` cannot be the zero address.
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must exist and be owned by `from`.
1117      * - If the caller is not `from`, it must be have been allowed to move
1118      * this token by either {approve} or {setApprovalForAll}.
1119      * - If `to` refers to a smart contract, it must implement
1120      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function safeTransferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId,
1128         bytes calldata data
1129     ) external;
1130 
1131     /**
1132      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1133      */
1134     function safeTransferFrom(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) external;
1139 
1140     /**
1141      * @dev Transfers `tokenId` from `from` to `to`.
1142      *
1143      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1144      * whenever possible.
1145      *
1146      * Requirements:
1147      *
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must be owned by `from`.
1151      * - If the caller is not `from`, it must be approved to move this token
1152      * by either {approve} or {setApprovalForAll}.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function transferFrom(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) external;
1161 
1162     /**
1163      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1164      * The approval is cleared when the token is transferred.
1165      *
1166      * Only a single account can be approved at a time, so approving the
1167      * zero address clears previous approvals.
1168      *
1169      * Requirements:
1170      *
1171      * - The caller must own the token or be an approved operator.
1172      * - `tokenId` must exist.
1173      *
1174      * Emits an {Approval} event.
1175      */
1176     function approve(address to, uint256 tokenId) external;
1177 
1178     /**
1179      * @dev Approve or remove `operator` as an operator for the caller.
1180      * Operators can call {transferFrom} or {safeTransferFrom}
1181      * for any token owned by the caller.
1182      *
1183      * Requirements:
1184      *
1185      * - The `operator` cannot be the caller.
1186      *
1187      * Emits an {ApprovalForAll} event.
1188      */
1189     function setApprovalForAll(address operator, bool _approved) external;
1190 
1191     /**
1192      * @dev Returns the account approved for `tokenId` token.
1193      *
1194      * Requirements:
1195      *
1196      * - `tokenId` must exist.
1197      */
1198     function getApproved(uint256 tokenId) external view returns (address operator);
1199 
1200     /**
1201      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1202      *
1203      * See {setApprovalForAll}.
1204      */
1205     function isApprovedForAll(address owner, address operator) external view returns (bool);
1206 
1207     // =============================================================
1208     //                        IERC721Metadata
1209     // =============================================================
1210 
1211     /**
1212      * @dev Returns the token collection name.
1213      */
1214     function name() external view returns (string memory);
1215 
1216     /**
1217      * @dev Returns the token collection symbol.
1218      */
1219     function symbol() external view returns (string memory);
1220 
1221     /**
1222      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1223      */
1224     function tokenURI(uint256 tokenId) external view returns (string memory);
1225 
1226     // =============================================================
1227     //                           IERC2309
1228     // =============================================================
1229 
1230     /**
1231      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1232      * (inclusive) is transferred from `from` to `to`, as defined in the
1233      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1234      *
1235      * See {_mintERC2309} for more details.
1236      */
1237     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1238 }
1239 
1240 
1241 // File contracts/ERC721A.sol
1242 
1243 
1244 // ERC721A Contracts v4.2.2
1245 // Creator: Chiru Labs
1246 
1247 pragma solidity ^0.8.4;
1248 
1249 /**
1250  * @dev Interface of ERC721 token receiver.
1251  */
1252 interface ERC721A__IERC721Receiver {
1253     function onERC721Received(
1254         address operator,
1255         address from,
1256         uint256 tokenId,
1257         bytes calldata data
1258     ) external returns (bytes4);
1259 }
1260 
1261 /**
1262  * @title ERC721A
1263  *
1264  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1265  * Non-Fungible Token Standard, including the Metadata extension.
1266  * Optimized for lower gas during batch mints.
1267  *
1268  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1269  * starting from `_startTokenId()`.
1270  *
1271  * Assumptions:
1272  *
1273  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1274  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1275  */
1276 contract ERC721A is IERC721A {
1277     // Reference type for token approval.
1278     struct TokenApprovalRef {
1279         address value;
1280     }
1281 
1282     // =============================================================
1283     //                           CONSTANTS
1284     // =============================================================
1285 
1286     // Mask of an entry in packed address data.
1287     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1288 
1289     // The bit position of `numberMinted` in packed address data.
1290     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1291 
1292     // The bit position of `numberBurned` in packed address data.
1293     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1294 
1295     // The bit position of `aux` in packed address data.
1296     uint256 private constant _BITPOS_AUX = 192;
1297 
1298     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1299     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1300 
1301     // The bit position of `startTimestamp` in packed ownership.
1302     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1303 
1304     // The bit mask of the `burned` bit in packed ownership.
1305     uint256 private constant _BITMASK_BURNED = 1 << 224;
1306 
1307     // The bit position of the `nextInitialized` bit in packed ownership.
1308     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1309 
1310     // The bit mask of the `nextInitialized` bit in packed ownership.
1311     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1312 
1313     // The bit position of `extraData` in packed ownership.
1314     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1315 
1316     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1317     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1318 
1319     // The mask of the lower 160 bits for addresses.
1320     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1321 
1322     // The maximum `quantity` that can be minted with {_mintERC2309}.
1323     // This limit is to prevent overflows on the address data entries.
1324     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1325     // is required to cause an overflow, which is unrealistic.
1326     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1327 
1328     // The `Transfer` event signature is given by:
1329     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1330     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1331         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1332 
1333     // =============================================================
1334     //                            STORAGE
1335     // =============================================================
1336 
1337     // The next token ID to be minted.
1338     uint256 private _currentIndex;
1339 
1340     // The number of tokens burned.
1341     uint256 private _burnCounter;
1342 
1343     // Token name
1344     string private _name;
1345 
1346     // Token symbol
1347     string private _symbol;
1348 
1349     // Mapping from token ID to ownership details
1350     // An empty struct value does not necessarily mean the token is unowned.
1351     // See {_packedOwnershipOf} implementation for details.
1352     //
1353     // Bits Layout:
1354     // - [0..159]   `addr`
1355     // - [160..223] `startTimestamp`
1356     // - [224]      `burned`
1357     // - [225]      `nextInitialized`
1358     // - [232..255] `extraData`
1359     mapping(uint256 => uint256) private _packedOwnerships;
1360 
1361     // Mapping owner address to address data.
1362     //
1363     // Bits Layout:
1364     // - [0..63]    `balance`
1365     // - [64..127]  `numberMinted`
1366     // - [128..191] `numberBurned`
1367     // - [192..255] `aux`
1368     mapping(address => uint256) private _packedAddressData;
1369 
1370     // Mapping from token ID to approved address.
1371     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1372 
1373     // Mapping from owner to operator approvals
1374     mapping(address => mapping(address => bool)) private _operatorApprovals;
1375 
1376     // =============================================================
1377     //                          CONSTRUCTOR
1378     // =============================================================
1379 
1380     constructor(string memory name_, string memory symbol_) {
1381         _name = name_;
1382         _symbol = symbol_;
1383         _currentIndex = _startTokenId();
1384     }
1385 
1386     // =============================================================
1387     //                   TOKEN COUNTING OPERATIONS
1388     // =============================================================
1389 
1390     /**
1391      * @dev Returns the starting token ID.
1392      * To change the starting token ID, please override this function.
1393      */
1394     function _startTokenId() internal view virtual returns (uint256) {
1395         return 0;
1396     }
1397 
1398     /**
1399      * @dev Returns the next token ID to be minted.
1400      */
1401     function _nextTokenId() internal view virtual returns (uint256) {
1402         return _currentIndex;
1403     }
1404 
1405     /**
1406      * @dev Returns the total number of tokens in existence.
1407      * Burned tokens will reduce the count.
1408      * To get the total number of tokens minted, please see {_totalMinted}.
1409      */
1410     function totalSupply() public view virtual override returns (uint256) {
1411         // Counter underflow is impossible as _burnCounter cannot be incremented
1412         // more than `_currentIndex - _startTokenId()` times.
1413         unchecked {
1414             return _currentIndex - _burnCounter - _startTokenId();
1415         }
1416     }
1417 
1418     /**
1419      * @dev Returns the total amount of tokens minted in the contract.
1420      */
1421     function _totalMinted() internal view virtual returns (uint256) {
1422         // Counter underflow is impossible as `_currentIndex` does not decrement,
1423         // and it is initialized to `_startTokenId()`.
1424         unchecked {
1425             return _currentIndex - _startTokenId();
1426         }
1427     }
1428 
1429     /**
1430      * @dev Returns the total number of tokens burned.
1431      */
1432     function _totalBurned() internal view virtual returns (uint256) {
1433         return _burnCounter;
1434     }
1435 
1436     // =============================================================
1437     //                    ADDRESS DATA OPERATIONS
1438     // =============================================================
1439 
1440     /**
1441      * @dev Returns the number of tokens in `owner`'s account.
1442      */
1443     function balanceOf(address owner) public view virtual override returns (uint256) {
1444         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1445         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1446     }
1447 
1448     /**
1449      * Returns the number of tokens minted by `owner`.
1450      */
1451     function _numberMinted(address owner) internal view returns (uint256) {
1452         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1453     }
1454 
1455     /**
1456      * Returns the number of tokens burned by or on behalf of `owner`.
1457      */
1458     function _numberBurned(address owner) internal view returns (uint256) {
1459         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1460     }
1461 
1462     /**
1463      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1464      */
1465     function _getAux(address owner) internal view returns (uint64) {
1466         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1467     }
1468 
1469     /**
1470      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1471      * If there are multiple variables, please pack them into a uint64.
1472      */
1473     function _setAux(address owner, uint64 aux) internal virtual {
1474         uint256 packed = _packedAddressData[owner];
1475         uint256 auxCasted;
1476         // Cast `aux` with assembly to avoid redundant masking.
1477         assembly {
1478             auxCasted := aux
1479         }
1480         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1481         _packedAddressData[owner] = packed;
1482     }
1483 
1484     // =============================================================
1485     //                            IERC165
1486     // =============================================================
1487 
1488     /**
1489      * @dev Returns true if this contract implements the interface defined by
1490      * `interfaceId`. See the corresponding
1491      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1492      * to learn more about how these ids are created.
1493      *
1494      * This function call must use less than 30000 gas.
1495      */
1496     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1497         // The interface IDs are constants representing the first 4 bytes
1498         // of the XOR of all function selectors in the interface.
1499         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1500         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1501         return
1502             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1503             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1504             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1505     }
1506 
1507     // =============================================================
1508     //                        IERC721Metadata
1509     // =============================================================
1510 
1511     /**
1512      * @dev Returns the token collection name.
1513      */
1514     function name() public view virtual override returns (string memory) {
1515         return _name;
1516     }
1517 
1518     /**
1519      * @dev Returns the token collection symbol.
1520      */
1521     function symbol() public view virtual override returns (string memory) {
1522         return _symbol;
1523     }
1524 
1525     /**
1526      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1527      */
1528     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1529         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1530 
1531         string memory baseURI = _baseURI();
1532         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1533     }
1534 
1535     /**
1536      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1537      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1538      * by default, it can be overridden in child contracts.
1539      */
1540     function _baseURI() internal view virtual returns (string memory) {
1541         return '';
1542     }
1543 
1544     // =============================================================
1545     //                     OWNERSHIPS OPERATIONS
1546     // =============================================================
1547 
1548     /**
1549      * @dev Returns the owner of the `tokenId` token.
1550      *
1551      * Requirements:
1552      *
1553      * - `tokenId` must exist.
1554      */
1555     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1556         return address(uint160(_packedOwnershipOf(tokenId)));
1557     }
1558 
1559     /**
1560      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1561      * It gradually moves to O(1) as tokens get transferred around over time.
1562      */
1563     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1564         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1565     }
1566 
1567     /**
1568      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1569      */
1570     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1571         return _unpackedOwnership(_packedOwnerships[index]);
1572     }
1573 
1574     /**
1575      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1576      */
1577     function _initializeOwnershipAt(uint256 index) internal virtual {
1578         if (_packedOwnerships[index] == 0) {
1579             _packedOwnerships[index] = _packedOwnershipOf(index);
1580         }
1581     }
1582 
1583     /**
1584      * Returns the packed ownership data of `tokenId`.
1585      */
1586     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1587         uint256 curr = tokenId;
1588 
1589         unchecked {
1590             if (_startTokenId() <= curr)
1591                 if (curr < _currentIndex) {
1592                     uint256 packed = _packedOwnerships[curr];
1593                     // If not burned.
1594                     if (packed & _BITMASK_BURNED == 0) {
1595                         // Invariant:
1596                         // There will always be an initialized ownership slot
1597                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1598                         // before an unintialized ownership slot
1599                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1600                         // Hence, `curr` will not underflow.
1601                         //
1602                         // We can directly compare the packed value.
1603                         // If the address is zero, packed will be zero.
1604                         while (packed == 0) {
1605                             packed = _packedOwnerships[--curr];
1606                         }
1607                         return packed;
1608                     }
1609                 }
1610         }
1611         revert OwnerQueryForNonexistentToken();
1612     }
1613 
1614     /**
1615      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1616      */
1617     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1618         ownership.addr = address(uint160(packed));
1619         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1620         ownership.burned = packed & _BITMASK_BURNED != 0;
1621         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1622     }
1623 
1624     /**
1625      * @dev Packs ownership data into a single uint256.
1626      */
1627     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1628         assembly {
1629             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1630             owner := and(owner, _BITMASK_ADDRESS)
1631             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1632             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1633         }
1634     }
1635 
1636     /**
1637      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1638      */
1639     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1640         // For branchless setting of the `nextInitialized` flag.
1641         assembly {
1642             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1643             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1644         }
1645     }
1646 
1647     // =============================================================
1648     //                      APPROVAL OPERATIONS
1649     // =============================================================
1650 
1651     /**
1652      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1653      * The approval is cleared when the token is transferred.
1654      *
1655      * Only a single account can be approved at a time, so approving the
1656      * zero address clears previous approvals.
1657      *
1658      * Requirements:
1659      *
1660      * - The caller must own the token or be an approved operator.
1661      * - `tokenId` must exist.
1662      *
1663      * Emits an {Approval} event.
1664      */
1665     function approve(address to, uint256 tokenId) public virtual override {
1666         address owner = ownerOf(tokenId);
1667 
1668         if (_msgSenderERC721A() != owner)
1669             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1670                 revert ApprovalCallerNotOwnerNorApproved();
1671             }
1672 
1673         _tokenApprovals[tokenId].value = to;
1674         emit Approval(owner, to, tokenId);
1675     }
1676 
1677     /**
1678      * @dev Returns the account approved for `tokenId` token.
1679      *
1680      * Requirements:
1681      *
1682      * - `tokenId` must exist.
1683      */
1684     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1685         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1686 
1687         return _tokenApprovals[tokenId].value;
1688     }
1689 
1690     /**
1691      * @dev Approve or remove `operator` as an operator for the caller.
1692      * Operators can call {transferFrom} or {safeTransferFrom}
1693      * for any token owned by the caller.
1694      *
1695      * Requirements:
1696      *
1697      * - The `operator` cannot be the caller.
1698      *
1699      * Emits an {ApprovalForAll} event.
1700      */
1701     function setApprovalForAll(address operator, bool approved) public virtual override {
1702         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1703 
1704         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1705         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1706     }
1707 
1708     /**
1709      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1710      *
1711      * See {setApprovalForAll}.
1712      */
1713     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1714         return _operatorApprovals[owner][operator];
1715     }
1716 
1717     /**
1718      * @dev Returns whether `tokenId` exists.
1719      *
1720      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1721      *
1722      * Tokens start existing when they are minted. See {_mint}.
1723      */
1724     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1725         return
1726             _startTokenId() <= tokenId &&
1727             tokenId < _currentIndex && // If within bounds,
1728             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1729     }
1730 
1731     /**
1732      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1733      */
1734     function _isSenderApprovedOrOwner(
1735         address approvedAddress,
1736         address owner,
1737         address msgSender
1738     ) private pure returns (bool result) {
1739         assembly {
1740             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1741             owner := and(owner, _BITMASK_ADDRESS)
1742             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1743             msgSender := and(msgSender, _BITMASK_ADDRESS)
1744             // `msgSender == owner || msgSender == approvedAddress`.
1745             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1746         }
1747     }
1748 
1749     /**
1750      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1751      */
1752     function _getApprovedSlotAndAddress(uint256 tokenId)
1753         private
1754         view
1755         returns (uint256 approvedAddressSlot, address approvedAddress)
1756     {
1757         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1758         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1759         assembly {
1760             approvedAddressSlot := tokenApproval.slot
1761             approvedAddress := sload(approvedAddressSlot)
1762         }
1763     }
1764 
1765     // =============================================================
1766     //                      TRANSFER OPERATIONS
1767     // =============================================================
1768 
1769     /**
1770      * @dev Transfers `tokenId` from `from` to `to`.
1771      *
1772      * Requirements:
1773      *
1774      * - `from` cannot be the zero address.
1775      * - `to` cannot be the zero address.
1776      * - `tokenId` token must be owned by `from`.
1777      * - If the caller is not `from`, it must be approved to move this token
1778      * by either {approve} or {setApprovalForAll}.
1779      *
1780      * Emits a {Transfer} event.
1781      */
1782     function transferFrom(
1783         address from,
1784         address to,
1785         uint256 tokenId
1786     ) public virtual override {
1787         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1788 
1789         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1790 
1791         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1792 
1793         // The nested ifs save around 20+ gas over a compound boolean condition.
1794         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1795             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1796 
1797         if (to == address(0)) revert TransferToZeroAddress();
1798 
1799         _beforeTokenTransfers(from, to, tokenId, 1);
1800 
1801         // Clear approvals from the previous owner.
1802         assembly {
1803             if approvedAddress {
1804                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1805                 sstore(approvedAddressSlot, 0)
1806             }
1807         }
1808 
1809         // Underflow of the sender's balance is impossible because we check for
1810         // ownership above and the recipient's balance can't realistically overflow.
1811         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1812         unchecked {
1813             // We can directly increment and decrement the balances.
1814             --_packedAddressData[from]; // Updates: `balance -= 1`.
1815             ++_packedAddressData[to]; // Updates: `balance += 1`.
1816 
1817             // Updates:
1818             // - `address` to the next owner.
1819             // - `startTimestamp` to the timestamp of transfering.
1820             // - `burned` to `false`.
1821             // - `nextInitialized` to `true`.
1822             _packedOwnerships[tokenId] = _packOwnershipData(
1823                 to,
1824                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1825             );
1826 
1827             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1828             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1829                 uint256 nextTokenId = tokenId + 1;
1830                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1831                 if (_packedOwnerships[nextTokenId] == 0) {
1832                     // If the next slot is within bounds.
1833                     if (nextTokenId != _currentIndex) {
1834                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1835                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1836                     }
1837                 }
1838             }
1839         }
1840 
1841         emit Transfer(from, to, tokenId);
1842         _afterTokenTransfers(from, to, tokenId, 1);
1843     }
1844 
1845     /**
1846      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1847      */
1848     function safeTransferFrom(
1849         address from,
1850         address to,
1851         uint256 tokenId
1852     ) public virtual override {
1853         safeTransferFrom(from, to, tokenId, '');
1854     }
1855 
1856     /**
1857      * @dev Safely transfers `tokenId` token from `from` to `to`.
1858      *
1859      * Requirements:
1860      *
1861      * - `from` cannot be the zero address.
1862      * - `to` cannot be the zero address.
1863      * - `tokenId` token must exist and be owned by `from`.
1864      * - If the caller is not `from`, it must be approved to move this token
1865      * by either {approve} or {setApprovalForAll}.
1866      * - If `to` refers to a smart contract, it must implement
1867      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1868      *
1869      * Emits a {Transfer} event.
1870      */
1871     function safeTransferFrom(
1872         address from,
1873         address to,
1874         uint256 tokenId,
1875         bytes memory _data
1876     ) public virtual override {
1877         transferFrom(from, to, tokenId);
1878         if (to.code.length != 0)
1879             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1880                 revert TransferToNonERC721ReceiverImplementer();
1881             }
1882     }
1883 
1884     /**
1885      * @dev Hook that is called before a set of serially-ordered token IDs
1886      * are about to be transferred. This includes minting.
1887      * And also called before burning one token.
1888      *
1889      * `startTokenId` - the first token ID to be transferred.
1890      * `quantity` - the amount to be transferred.
1891      *
1892      * Calling conditions:
1893      *
1894      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1895      * transferred to `to`.
1896      * - When `from` is zero, `tokenId` will be minted for `to`.
1897      * - When `to` is zero, `tokenId` will be burned by `from`.
1898      * - `from` and `to` are never both zero.
1899      */
1900     function _beforeTokenTransfers(
1901         address from,
1902         address to,
1903         uint256 startTokenId,
1904         uint256 quantity
1905     ) internal virtual {}
1906 
1907     /**
1908      * @dev Hook that is called after a set of serially-ordered token IDs
1909      * have been transferred. This includes minting.
1910      * And also called after one token has been burned.
1911      *
1912      * `startTokenId` - the first token ID to be transferred.
1913      * `quantity` - the amount to be transferred.
1914      *
1915      * Calling conditions:
1916      *
1917      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1918      * transferred to `to`.
1919      * - When `from` is zero, `tokenId` has been minted for `to`.
1920      * - When `to` is zero, `tokenId` has been burned by `from`.
1921      * - `from` and `to` are never both zero.
1922      */
1923     function _afterTokenTransfers(
1924         address from,
1925         address to,
1926         uint256 startTokenId,
1927         uint256 quantity
1928     ) internal virtual {}
1929 
1930     /**
1931      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1932      *
1933      * `from` - Previous owner of the given token ID.
1934      * `to` - Target address that will receive the token.
1935      * `tokenId` - Token ID to be transferred.
1936      * `_data` - Optional data to send along with the call.
1937      *
1938      * Returns whether the call correctly returned the expected magic value.
1939      */
1940     function _checkContractOnERC721Received(
1941         address from,
1942         address to,
1943         uint256 tokenId,
1944         bytes memory _data
1945     ) private returns (bool) {
1946         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1947             bytes4 retval
1948         ) {
1949             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1950         } catch (bytes memory reason) {
1951             if (reason.length == 0) {
1952                 revert TransferToNonERC721ReceiverImplementer();
1953             } else {
1954                 assembly {
1955                     revert(add(32, reason), mload(reason))
1956                 }
1957             }
1958         }
1959     }
1960 
1961     // =============================================================
1962     //                        MINT OPERATIONS
1963     // =============================================================
1964 
1965     /**
1966      * @dev Mints `quantity` tokens and transfers them to `to`.
1967      *
1968      * Requirements:
1969      *
1970      * - `to` cannot be the zero address.
1971      * - `quantity` must be greater than 0.
1972      *
1973      * Emits a {Transfer} event for each mint.
1974      */
1975     function _mint(address to, uint256 quantity) internal virtual {
1976         uint256 startTokenId = _currentIndex;
1977         if (quantity == 0) revert MintZeroQuantity();
1978 
1979         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1980 
1981         // Overflows are incredibly unrealistic.
1982         // `balance` and `numberMinted` have a maximum limit of 2**64.
1983         // `tokenId` has a maximum limit of 2**256.
1984         unchecked {
1985             // Updates:
1986             // - `balance += quantity`.
1987             // - `numberMinted += quantity`.
1988             //
1989             // We can directly add to the `balance` and `numberMinted`.
1990             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1991 
1992             // Updates:
1993             // - `address` to the owner.
1994             // - `startTimestamp` to the timestamp of minting.
1995             // - `burned` to `false`.
1996             // - `nextInitialized` to `quantity == 1`.
1997             _packedOwnerships[startTokenId] = _packOwnershipData(
1998                 to,
1999                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2000             );
2001 
2002             uint256 toMasked;
2003             uint256 end = startTokenId + quantity;
2004 
2005             // Use assembly to loop and emit the `Transfer` event for gas savings.
2006             // The duplicated `log4` removes an extra check and reduces stack juggling.
2007             // The assembly, together with the surrounding Solidity code, have been
2008             // delicately arranged to nudge the compiler into producing optimized opcodes.
2009             assembly {
2010                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2011                 toMasked := and(to, _BITMASK_ADDRESS)
2012                 // Emit the `Transfer` event.
2013                 log4(
2014                     0, // Start of data (0, since no data).
2015                     0, // End of data (0, since no data).
2016                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2017                     0, // `address(0)`.
2018                     toMasked, // `to`.
2019                     startTokenId // `tokenId`.
2020                 )
2021 
2022                 for {
2023                     let tokenId := add(startTokenId, 1)
2024                 } iszero(eq(tokenId, end)) {
2025                     tokenId := add(tokenId, 1)
2026                 } {
2027                     // Emit the `Transfer` event. Similar to above.
2028                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2029                 }
2030             }
2031             if (toMasked == 0) revert MintToZeroAddress();
2032 
2033             _currentIndex = end;
2034         }
2035         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2036     }
2037 
2038     /**
2039      * @dev Mints `quantity` tokens and transfers them to `to`.
2040      *
2041      * This function is intended for efficient minting only during contract creation.
2042      *
2043      * It emits only one {ConsecutiveTransfer} as defined in
2044      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2045      * instead of a sequence of {Transfer} event(s).
2046      *
2047      * Calling this function outside of contract creation WILL make your contract
2048      * non-compliant with the ERC721 standard.
2049      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2050      * {ConsecutiveTransfer} event is only permissible during contract creation.
2051      *
2052      * Requirements:
2053      *
2054      * - `to` cannot be the zero address.
2055      * - `quantity` must be greater than 0.
2056      *
2057      * Emits a {ConsecutiveTransfer} event.
2058      */
2059     function _mintERC2309(address to, uint256 quantity) internal virtual {
2060         uint256 startTokenId = _currentIndex;
2061         if (to == address(0)) revert MintToZeroAddress();
2062         if (quantity == 0) revert MintZeroQuantity();
2063         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2064 
2065         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2066 
2067         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2068         unchecked {
2069             // Updates:
2070             // - `balance += quantity`.
2071             // - `numberMinted += quantity`.
2072             //
2073             // We can directly add to the `balance` and `numberMinted`.
2074             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2075 
2076             // Updates:
2077             // - `address` to the owner.
2078             // - `startTimestamp` to the timestamp of minting.
2079             // - `burned` to `false`.
2080             // - `nextInitialized` to `quantity == 1`.
2081             _packedOwnerships[startTokenId] = _packOwnershipData(
2082                 to,
2083                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2084             );
2085 
2086             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2087 
2088             _currentIndex = startTokenId + quantity;
2089         }
2090         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2091     }
2092 
2093     /**
2094      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2095      *
2096      * Requirements:
2097      *
2098      * - If `to` refers to a smart contract, it must implement
2099      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2100      * - `quantity` must be greater than 0.
2101      *
2102      * See {_mint}.
2103      *
2104      * Emits a {Transfer} event for each mint.
2105      */
2106     function _safeMint(
2107         address to,
2108         uint256 quantity,
2109         bytes memory _data
2110     ) internal virtual {
2111         _mint(to, quantity);
2112 
2113         unchecked {
2114             if (to.code.length != 0) {
2115                 uint256 end = _currentIndex;
2116                 uint256 index = end - quantity;
2117                 do {
2118                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2119                         revert TransferToNonERC721ReceiverImplementer();
2120                     }
2121                 } while (index < end);
2122                 // Reentrancy protection.
2123                 if (_currentIndex != end) revert();
2124             }
2125         }
2126     }
2127 
2128     /**
2129      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2130      */
2131     function _safeMint(address to, uint256 quantity) internal virtual {
2132         _safeMint(to, quantity, '');
2133     }
2134 
2135     // =============================================================
2136     //                        BURN OPERATIONS
2137     // =============================================================
2138 
2139     /**
2140      * @dev Equivalent to `_burn(tokenId, false)`.
2141      */
2142     function _burn(uint256 tokenId) internal virtual {
2143         _burn(tokenId, false);
2144     }
2145 
2146     /**
2147      * @dev Destroys `tokenId`.
2148      * The approval is cleared when the token is burned.
2149      *
2150      * Requirements:
2151      *
2152      * - `tokenId` must exist.
2153      *
2154      * Emits a {Transfer} event.
2155      */
2156     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2157         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2158 
2159         address from = address(uint160(prevOwnershipPacked));
2160 
2161         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2162 
2163         if (approvalCheck) {
2164             // The nested ifs save around 20+ gas over a compound boolean condition.
2165             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2166                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2167         }
2168 
2169         _beforeTokenTransfers(from, address(0), tokenId, 1);
2170 
2171         // Clear approvals from the previous owner.
2172         assembly {
2173             if approvedAddress {
2174                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2175                 sstore(approvedAddressSlot, 0)
2176             }
2177         }
2178 
2179         // Underflow of the sender's balance is impossible because we check for
2180         // ownership above and the recipient's balance can't realistically overflow.
2181         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2182         unchecked {
2183             // Updates:
2184             // - `balance -= 1`.
2185             // - `numberBurned += 1`.
2186             //
2187             // We can directly decrement the balance, and increment the number burned.
2188             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2189             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2190 
2191             // Updates:
2192             // - `address` to the last owner.
2193             // - `startTimestamp` to the timestamp of burning.
2194             // - `burned` to `true`.
2195             // - `nextInitialized` to `true`.
2196             _packedOwnerships[tokenId] = _packOwnershipData(
2197                 from,
2198                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2199             );
2200 
2201             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2202             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2203                 uint256 nextTokenId = tokenId + 1;
2204                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2205                 if (_packedOwnerships[nextTokenId] == 0) {
2206                     // If the next slot is within bounds.
2207                     if (nextTokenId != _currentIndex) {
2208                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2209                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2210                     }
2211                 }
2212             }
2213         }
2214 
2215         emit Transfer(from, address(0), tokenId);
2216         _afterTokenTransfers(from, address(0), tokenId, 1);
2217 
2218         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2219         unchecked {
2220             _burnCounter++;
2221         }
2222     }
2223 
2224     // =============================================================
2225     //                     EXTRA DATA OPERATIONS
2226     // =============================================================
2227 
2228     /**
2229      * @dev Directly sets the extra data for the ownership data `index`.
2230      */
2231     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2232         uint256 packed = _packedOwnerships[index];
2233         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2234         uint256 extraDataCasted;
2235         // Cast `extraData` with assembly to avoid redundant masking.
2236         assembly {
2237             extraDataCasted := extraData
2238         }
2239         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2240         _packedOwnerships[index] = packed;
2241     }
2242 
2243     /**
2244      * @dev Called during each token transfer to set the 24bit `extraData` field.
2245      * Intended to be overridden by the cosumer contract.
2246      *
2247      * `previousExtraData` - the value of `extraData` before transfer.
2248      *
2249      * Calling conditions:
2250      *
2251      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2252      * transferred to `to`.
2253      * - When `from` is zero, `tokenId` will be minted for `to`.
2254      * - When `to` is zero, `tokenId` will be burned by `from`.
2255      * - `from` and `to` are never both zero.
2256      */
2257     function _extraData(
2258         address from,
2259         address to,
2260         uint24 previousExtraData
2261     ) internal view virtual returns (uint24) {}
2262 
2263     /**
2264      * @dev Returns the next extra data for the packed ownership data.
2265      * The returned result is shifted into position.
2266      */
2267     function _nextExtraData(
2268         address from,
2269         address to,
2270         uint256 prevOwnershipPacked
2271     ) private view returns (uint256) {
2272         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2273         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2274     }
2275 
2276     // =============================================================
2277     //                       OTHER OPERATIONS
2278     // =============================================================
2279 
2280     /**
2281      * @dev Returns the message sender (defaults to `msg.sender`).
2282      *
2283      * If you are writing GSN compatible contracts, you need to override this function.
2284      */
2285     function _msgSenderERC721A() internal view virtual returns (address) {
2286         return msg.sender;
2287     }
2288 
2289     /**
2290      * @dev Converts a uint256 to its ASCII string decimal representation.
2291      */
2292     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2293         assembly {
2294             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2295             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
2296             // We will need 1 32-byte word to store the length,
2297             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
2298             str := add(mload(0x40), 0x80)
2299             // Update the free memory pointer to allocate.
2300             mstore(0x40, str)
2301 
2302             // Cache the end of the memory to calculate the length later.
2303             let end := str
2304 
2305             // We write the string from rightmost digit to leftmost digit.
2306             // The following is essentially a do-while loop that also handles the zero case.
2307             // prettier-ignore
2308             for { let temp := value } 1 {} {
2309                 str := sub(str, 1)
2310                 // Write the character to the pointer.
2311                 // The ASCII index of the '0' character is 48.
2312                 mstore8(str, add(48, mod(temp, 10)))
2313                 // Keep dividing `temp` until zero.
2314                 temp := div(temp, 10)
2315                 // prettier-ignore
2316                 if iszero(temp) { break }
2317             }
2318 
2319             let length := sub(end, str)
2320             // Move the pointer 32 bytes leftwards to make room for the length.
2321             str := sub(str, 0x20)
2322             // Store the length.
2323             mstore(str, length)
2324         }
2325     }
2326 }
2327 
2328 
2329 // File contracts/extensions/IERC4907A.sol
2330 
2331 
2332 // ERC721A Contracts v4.2.2
2333 // Creator: Chiru Labs
2334 
2335 pragma solidity ^0.8.4;
2336 
2337 /**
2338  * @dev Interface of ERC4907A.
2339  */
2340 interface IERC4907A is IERC721A {
2341     /**
2342      * The caller must own the token or be an approved operator.
2343      */
2344     error SetUserCallerNotOwnerNorApproved();
2345 
2346     /**
2347      * @dev Emitted when the `user` of an NFT or the `expires` of the `user` is changed.
2348      * The zero address for user indicates that there is no user address.
2349      */
2350     event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);
2351 
2352     /**
2353      * @dev Sets the `user` and `expires` for `tokenId`.
2354      * The zero address indicates there is no user.
2355      *
2356      * Requirements:
2357      *
2358      * - The caller must own `tokenId` or be an approved operator.
2359      */
2360     function setUser(
2361         uint256 tokenId,
2362         address user,
2363         uint64 expires
2364     ) external;
2365 
2366     /**
2367      * @dev Returns the user address for `tokenId`.
2368      * The zero address indicates that there is no user or if the user is expired.
2369      */
2370     function userOf(uint256 tokenId) external view returns (address);
2371 
2372     /**
2373      * @dev Returns the user's expires of `tokenId`.
2374      */
2375     function userExpires(uint256 tokenId) external view returns (uint256);
2376 }
2377 
2378 
2379 // File contracts/extensions/ERC4907A.sol
2380 
2381 
2382 // ERC721A Contracts v4.2.2
2383 // Creator: Chiru Labs
2384 
2385 pragma solidity ^0.8.4;
2386 
2387 
2388 /**
2389  * @title ERC4907A
2390  *
2391  * @dev [ERC4907](https://eips.ethereum.org/EIPS/eip-4907) compliant
2392  * extension of ERC721A, which allows owners and authorized addresses
2393  * to add a time-limited role with restricted permissions to ERC721 tokens.
2394  */
2395 abstract contract ERC4907A is ERC721A, IERC4907A {
2396     // The bit position of `expires` in packed user info.
2397     uint256 private constant _BITPOS_EXPIRES = 160;
2398 
2399     // Mapping from token ID to user info.
2400     //
2401     // Bits Layout:
2402     // - [0..159]   `user`
2403     // - [160..223] `expires`
2404     mapping(uint256 => uint256) private _packedUserInfo;
2405 
2406     /**
2407      * @dev Sets the `user` and `expires` for `tokenId`.
2408      * The zero address indicates there is no user.
2409      *
2410      * Requirements:
2411      *
2412      * - The caller must own `tokenId` or be an approved operator.
2413      */
2414     function setUser(
2415         uint256 tokenId,
2416         address user,
2417         uint64 expires
2418     ) public virtual override {
2419         // Require the caller to be either the token owner or an approved operator.
2420         address owner = ownerOf(tokenId);
2421         if (_msgSenderERC721A() != owner)
2422             if (!isApprovedForAll(owner, _msgSenderERC721A()))
2423                 if (getApproved(tokenId) != _msgSenderERC721A()) revert SetUserCallerNotOwnerNorApproved();
2424 
2425         _packedUserInfo[tokenId] = (uint256(expires) << _BITPOS_EXPIRES) | uint256(uint160(user));
2426 
2427         emit UpdateUser(tokenId, user, expires);
2428     }
2429 
2430     /**
2431      * @dev Returns the user address for `tokenId`.
2432      * The zero address indicates that there is no user or if the user is expired.
2433      */
2434     function userOf(uint256 tokenId) public view virtual override returns (address) {
2435         uint256 packed = _packedUserInfo[tokenId];
2436         assembly {
2437             // Branchless `packed *= (block.timestamp <= expires ? 1 : 0)`.
2438             // If the `block.timestamp == expires`, the `lt` clause will be true
2439             // if there is a non-zero user address in the lower 160 bits of `packed`.
2440             packed := mul(
2441                 packed,
2442                 // `block.timestamp <= expires ? 1 : 0`.
2443                 lt(shl(_BITPOS_EXPIRES, timestamp()), packed)
2444             )
2445         }
2446         return address(uint160(packed));
2447     }
2448 
2449     /**
2450      * @dev Returns the user's expires of `tokenId`.
2451      */
2452     function userExpires(uint256 tokenId) public view virtual override returns (uint256) {
2453         return _packedUserInfo[tokenId] >> _BITPOS_EXPIRES;
2454     }
2455 
2456     /**
2457      * @dev Override of {IERC165-supportsInterface}.
2458      */
2459     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC721A) returns (bool) {
2460         // The interface ID for ERC4907 is `0xad092b5c`,
2461         // as defined in [ERC4907](https://eips.ethereum.org/EIPS/eip-4907).
2462         return super.supportsInterface(interfaceId) || interfaceId == 0xad092b5c;
2463     }
2464 
2465     /**
2466      * @dev Returns the user address for `tokenId`, ignoring the expiry status.
2467      */
2468     function _explicitUserOf(uint256 tokenId) internal view virtual returns (address) {
2469         return address(uint160(_packedUserInfo[tokenId]));
2470     }
2471 }
2472 
2473 
2474 // File contracts/extensions/IERC721ABurnable.sol
2475 
2476 
2477 // ERC721A Contracts v4.2.2
2478 // Creator: Chiru Labs
2479 
2480 pragma solidity ^0.8.4;
2481 
2482 /**
2483  * @dev Interface of ERC721ABurnable.
2484  */
2485 interface IERC721ABurnable is IERC721A {
2486     /**
2487      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2488      *
2489      * Requirements:
2490      *
2491      * - The caller must own `tokenId` or be an approved operator.
2492      */
2493     function burn(uint256 tokenId) external;
2494 }
2495 
2496 
2497 // File contracts/extensions/ERC721ABurnable.sol
2498 
2499 
2500 // ERC721A Contracts v4.2.2
2501 // Creator: Chiru Labs
2502 
2503 pragma solidity ^0.8.4;
2504 
2505 
2506 /**
2507  * @title ERC721ABurnable.
2508  *
2509  * @dev ERC721A token that can be irreversibly burned (destroyed).
2510  */
2511 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
2512     /**
2513      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2514      *
2515      * Requirements:
2516      *
2517      * - The caller must own `tokenId` or be an approved operator.
2518      */
2519     function burn(uint256 tokenId) public virtual override {
2520         _burn(tokenId, true);
2521     }
2522 }
2523 
2524 
2525 // File contracts/extensions/IERC721AQueryable.sol
2526 
2527 
2528 // ERC721A Contracts v4.2.2
2529 // Creator: Chiru Labs
2530 
2531 pragma solidity ^0.8.4;
2532 
2533 /**
2534  * @dev Interface of ERC721AQueryable.
2535  */
2536 interface IERC721AQueryable is IERC721A {
2537     /**
2538      * Invalid query range (`start` >= `stop`).
2539      */
2540     error InvalidQueryRange();
2541 
2542     /**
2543      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2544      *
2545      * If the `tokenId` is out of bounds:
2546      *
2547      * - `addr = address(0)`
2548      * - `startTimestamp = 0`
2549      * - `burned = false`
2550      * - `extraData = 0`
2551      *
2552      * If the `tokenId` is burned:
2553      *
2554      * - `addr = <Address of owner before token was burned>`
2555      * - `startTimestamp = <Timestamp when token was burned>`
2556      * - `burned = true`
2557      * - `extraData = <Extra data when token was burned>`
2558      *
2559      * Otherwise:
2560      *
2561      * - `addr = <Address of owner>`
2562      * - `startTimestamp = <Timestamp of start of ownership>`
2563      * - `burned = false`
2564      * - `extraData = <Extra data at start of ownership>`
2565      */
2566     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2567 
2568     /**
2569      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2570      * See {ERC721AQueryable-explicitOwnershipOf}
2571      */
2572     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2573 
2574     /**
2575      * @dev Returns an array of token IDs owned by `owner`,
2576      * in the range [`start`, `stop`)
2577      * (i.e. `start <= tokenId < stop`).
2578      *
2579      * This function allows for tokens to be queried if the collection
2580      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2581      *
2582      * Requirements:
2583      *
2584      * - `start < stop`
2585      */
2586     function tokensOfOwnerIn(
2587         address owner,
2588         uint256 start,
2589         uint256 stop
2590     ) external view returns (uint256[] memory);
2591 
2592     /**
2593      * @dev Returns an array of token IDs owned by `owner`.
2594      *
2595      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2596      * It is meant to be called off-chain.
2597      *
2598      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2599      * multiple smaller scans if the collection is large enough to cause
2600      * an out-of-gas error (10K collections should be fine).
2601      */
2602     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2603 }
2604 
2605 
2606 // File contracts/extensions/ERC721AQueryable.sol
2607 
2608 
2609 // ERC721A Contracts v4.2.2
2610 // Creator: Chiru Labs
2611 
2612 pragma solidity ^0.8.4;
2613 
2614 
2615 /**
2616  * @title ERC721AQueryable.
2617  *
2618  * @dev ERC721A subclass with convenience query functions.
2619  */
2620 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2621     /**
2622      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2623      *
2624      * If the `tokenId` is out of bounds:
2625      *
2626      * - `addr = address(0)`
2627      * - `startTimestamp = 0`
2628      * - `burned = false`
2629      * - `extraData = 0`
2630      *
2631      * If the `tokenId` is burned:
2632      *
2633      * - `addr = <Address of owner before token was burned>`
2634      * - `startTimestamp = <Timestamp when token was burned>`
2635      * - `burned = true`
2636      * - `extraData = <Extra data when token was burned>`
2637      *
2638      * Otherwise:
2639      *
2640      * - `addr = <Address of owner>`
2641      * - `startTimestamp = <Timestamp of start of ownership>`
2642      * - `burned = false`
2643      * - `extraData = <Extra data at start of ownership>`
2644      */
2645     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2646         TokenOwnership memory ownership;
2647         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2648             return ownership;
2649         }
2650         ownership = _ownershipAt(tokenId);
2651         if (ownership.burned) {
2652             return ownership;
2653         }
2654         return _ownershipOf(tokenId);
2655     }
2656 
2657     /**
2658      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2659      * See {ERC721AQueryable-explicitOwnershipOf}
2660      */
2661     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2662         external
2663         view
2664         virtual
2665         override
2666         returns (TokenOwnership[] memory)
2667     {
2668         unchecked {
2669             uint256 tokenIdsLength = tokenIds.length;
2670             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2671             for (uint256 i; i != tokenIdsLength; ++i) {
2672                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2673             }
2674             return ownerships;
2675         }
2676     }
2677 
2678     /**
2679      * @dev Returns an array of token IDs owned by `owner`,
2680      * in the range [`start`, `stop`)
2681      * (i.e. `start <= tokenId < stop`).
2682      *
2683      * This function allows for tokens to be queried if the collection
2684      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2685      *
2686      * Requirements:
2687      *
2688      * - `start < stop`
2689      */
2690     function tokensOfOwnerIn(
2691         address owner,
2692         uint256 start,
2693         uint256 stop
2694     ) external view virtual override returns (uint256[] memory) {
2695         unchecked {
2696             if (start >= stop) revert InvalidQueryRange();
2697             uint256 tokenIdsIdx;
2698             uint256 stopLimit = _nextTokenId();
2699             // Set `start = max(start, _startTokenId())`.
2700             if (start < _startTokenId()) {
2701                 start = _startTokenId();
2702             }
2703             // Set `stop = min(stop, stopLimit)`.
2704             if (stop > stopLimit) {
2705                 stop = stopLimit;
2706             }
2707             uint256 tokenIdsMaxLength = balanceOf(owner);
2708             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2709             // to cater for cases where `balanceOf(owner)` is too big.
2710             if (start < stop) {
2711                 uint256 rangeLength = stop - start;
2712                 if (rangeLength < tokenIdsMaxLength) {
2713                     tokenIdsMaxLength = rangeLength;
2714                 }
2715             } else {
2716                 tokenIdsMaxLength = 0;
2717             }
2718             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2719             if (tokenIdsMaxLength == 0) {
2720                 return tokenIds;
2721             }
2722             // We need to call `explicitOwnershipOf(start)`,
2723             // because the slot at `start` may not be initialized.
2724             TokenOwnership memory ownership = explicitOwnershipOf(start);
2725             address currOwnershipAddr;
2726             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2727             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2728             if (!ownership.burned) {
2729                 currOwnershipAddr = ownership.addr;
2730             }
2731             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2732                 ownership = _ownershipAt(i);
2733                 if (ownership.burned) {
2734                     continue;
2735                 }
2736                 if (ownership.addr != address(0)) {
2737                     currOwnershipAddr = ownership.addr;
2738                 }
2739                 if (currOwnershipAddr == owner) {
2740                     tokenIds[tokenIdsIdx++] = i;
2741                 }
2742             }
2743             // Downsize the array to fit.
2744             assembly {
2745                 mstore(tokenIds, tokenIdsIdx)
2746             }
2747             return tokenIds;
2748         }
2749     }
2750 
2751     /**
2752      * @dev Returns an array of token IDs owned by `owner`.
2753      *
2754      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2755      * It is meant to be called off-chain.
2756      *
2757      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2758      * multiple smaller scans if the collection is large enough to cause
2759      * an out-of-gas error (10K collections should be fine).
2760      */
2761     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2762         unchecked {
2763             uint256 tokenIdsIdx;
2764             address currOwnershipAddr;
2765             uint256 tokenIdsLength = balanceOf(owner);
2766             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2767             TokenOwnership memory ownership;
2768             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2769                 ownership = _ownershipAt(i);
2770                 if (ownership.burned) {
2771                     continue;
2772                 }
2773                 if (ownership.addr != address(0)) {
2774                     currOwnershipAddr = ownership.addr;
2775                 }
2776                 if (currOwnershipAddr == owner) {
2777                     tokenIds[tokenIdsIdx++] = i;
2778                 }
2779             }
2780             return tokenIds;
2781         }
2782     }
2783 }
2784 
2785 
2786 // File contracts/interfaces/IERC4907A.sol
2787 
2788 
2789 // ERC721A Contracts v4.2.2
2790 // Creator: Chiru Labs
2791 
2792 pragma solidity ^0.8.4;
2793 
2794 
2795 // File contracts/interfaces/IERC721A.sol
2796 
2797 
2798 // ERC721A Contracts v4.2.2
2799 // Creator: Chiru Labs
2800 
2801 pragma solidity ^0.8.4;
2802 
2803 
2804 // File contracts/interfaces/IERC721ABurnable.sol
2805 
2806 
2807 // ERC721A Contracts v4.2.2
2808 // Creator: Chiru Labs
2809 
2810 pragma solidity ^0.8.4;
2811 
2812 
2813 // File contracts/interfaces/IERC721AQueryable.sol
2814 
2815 
2816 // ERC721A Contracts v4.2.2
2817 // Creator: Chiru Labs
2818 
2819 pragma solidity ^0.8.4;
2820 
2821 
2822 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.1
2823 
2824 
2825 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
2826 
2827 pragma solidity ^0.8.0;
2828 
2829 /**
2830  * @dev Contract module that helps prevent reentrant calls to a function.
2831  *
2832  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2833  * available, which can be applied to functions to make sure there are no nested
2834  * (reentrant) calls to them.
2835  *
2836  * Note that because there is a single `nonReentrant` guard, functions marked as
2837  * `nonReentrant` may not call one another. This can be worked around by making
2838  * those functions `private`, and then adding `external` `nonReentrant` entry
2839  * points to them.
2840  *
2841  * TIP: If you would like to learn more about reentrancy and alternative ways
2842  * to protect against it, check out our blog post
2843  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2844  */
2845 abstract contract ReentrancyGuard {
2846     // Booleans are more expensive than uint256 or any type that takes up a full
2847     // word because each write operation emits an extra SLOAD to first read the
2848     // slot's contents, replace the bits taken up by the boolean, and then write
2849     // back. This is the compiler's defense against contract upgrades and
2850     // pointer aliasing, and it cannot be disabled.
2851 
2852     // The values being non-zero value makes deployment a bit more expensive,
2853     // but in exchange the refund on every call to nonReentrant will be lower in
2854     // amount. Since refunds are capped to a percentage of the total
2855     // transaction's gas, it is best to keep them low in cases like this one, to
2856     // increase the likelihood of the full refund coming into effect.
2857     uint256 private constant _NOT_ENTERED = 1;
2858     uint256 private constant _ENTERED = 2;
2859 
2860     uint256 private _status;
2861 
2862     constructor() {
2863         _status = _NOT_ENTERED;
2864     }
2865 
2866     /**
2867      * @dev Prevents a contract from calling itself, directly or indirectly.
2868      * Calling a `nonReentrant` function from another `nonReentrant`
2869      * function is not supported. It is possible to prevent this from happening
2870      * by making the `nonReentrant` function external, and making it call a
2871      * `private` function that does the actual work.
2872      */
2873     modifier nonReentrant() {
2874         _nonReentrantBefore();
2875         _;
2876         _nonReentrantAfter();
2877     }
2878 
2879     function _nonReentrantBefore() private {
2880         // On the first call to nonReentrant, _status will be _NOT_ENTERED
2881         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2882 
2883         // Any calls to nonReentrant after this point will fail
2884         _status = _ENTERED;
2885     }
2886 
2887     function _nonReentrantAfter() private {
2888         // By storing the original value once again, a refund is triggered (see
2889         // https://eips.ethereum.org/EIPS/eip-2200)
2890         _status = _NOT_ENTERED;
2891     }
2892 }
2893 
2894 
2895 
2896 
2897 
2898 pragma solidity ^0.8.13;
2899 
2900 
2901 
2902 
2903 
2904 error AccessDenied();
2905 error IncorrectPayment();
2906 error InsufficientPayment();
2907 error InvalidMintQuantity();
2908 error MintingDisabled();
2909 error MaxPerTXReached();
2910 error MaxSupplyReached();
2911 error WithdrawalFailed();
2912 error WalletLimitReached();
2913 
2914 contract YootGods is ERC721AQueryable, ReentrancyGuard, ERC2981, Ownable {
2915     string private _baseTokenURI;
2916     uint public maxSupply = 10000;   
2917 
2918     uint public price = 0.0069 ether;
2919     uint public freePerWallet = 1;
2920     uint public maxPerWallet = 50;
2921     
2922     uint public maxPerTX = 25;
2923     
2924     bool public mintEnabled = false;
2925 
2926     constructor() ERC721A("YootGods", "YG") {}
2927 
2928     modifier callerIsUser() {
2929         require(tx.origin == msg.sender, "not original sender");
2930         _;
2931     }
2932 
2933     function mint(uint qty)
2934       external
2935       payable
2936       callerIsUser
2937       nonReentrant {
2938         uint price_ = calculatePrice(qty);
2939 
2940         if (_numberMinted(msg.sender) + qty > maxPerWallet + 1) revert WalletLimitReached();
2941         if (_totalMinted() + qty > maxSupply + 1) revert MaxSupplyReached();
2942         if (!mintEnabled) revert MintingDisabled();        
2943         
2944         if (qty > maxPerTX + 1) revert MaxPerTXReached();
2945 
2946         _mint(msg.sender, qty);
2947         _refundOverPayment(price_);
2948     }
2949 
2950     function calculatePrice(uint qty) public view returns (uint) {
2951       uint numMinted = _numberMinted(msg.sender);
2952       uint free = numMinted < freePerWallet ? freePerWallet - numMinted : 0;
2953       if (qty >= free) {
2954         return (price) * (qty - free);
2955       }
2956       return 0;
2957     }
2958 
2959     function _refundOverPayment(uint256 amount) internal {
2960         if (msg.value < amount) revert InsufficientPayment();
2961         if (msg.value > amount) {
2962             payable(msg.sender).transfer(msg.value - amount);
2963         }
2964     }
2965 
2966     function teamMintTo(uint256 quantity, address to) external onlyOwner {
2967         require(totalSupply() + quantity <= maxSupply,"not enough!");
2968         _mint(to, quantity);
2969     }
2970 
2971     function _baseURI() internal view virtual override returns (string memory) {
2972         return _baseTokenURI;
2973     }
2974 
2975     function deleteDefaultRoyalty() external onlyOwner {
2976         _deleteDefaultRoyalty();
2977     }
2978 
2979     function setMaxPerTx(uint256 maxPerTX_) external onlyOwner {
2980         maxPerTX = maxPerTX_;
2981     }
2982 
2983     function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
2984         maxPerWallet = maxPerWallet_;
2985     }
2986 
2987     function setMaxSupply(uint256 maxSupply_) public onlyOwner {
2988         maxSupply = maxSupply_;
2989     }
2990 
2991     function toggleMint() external onlyOwner {
2992         mintEnabled = !mintEnabled;
2993     }
2994 
2995     function numberMinted(address owner) public view returns (uint256) {
2996         return _numberMinted(owner);
2997     }
2998 
2999     function setBaseURI(string calldata baseURI_) external onlyOwner {
3000         _baseTokenURI = baseURI_;
3001     }
3002 
3003     function withdraw() external onlyOwner {
3004         (bool success, ) = msg.sender.call{value: address(this).balance}("");
3005         if (!success) revert WithdrawalFailed();
3006     }
3007 
3008     function setRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
3009         _setDefaultRoyalty(receiver, feeNumerator);
3010     }
3011     
3012     function _startTokenId() internal view virtual override returns (uint256) {
3013         return 1;
3014     }
3015 
3016     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981, IERC721A) returns (bool) {
3017         // Supports the following `interfaceId`s:
3018         
3019         // - IERC721: 0x80ac58cd
3020         // - IERC721Metadata: 0x5b5e139f
3021         // - IERC2981: 0x2a55205a
3022         return
3023             ERC721A.supportsInterface(interfaceId) ||
3024             ERC2981.supportsInterface(interfaceId);
3025     }
3026 
3027 }