1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Standard signed math utilities missing in the Solidity language.
12  */
13 library SignedMath {
14     /**
15      * @dev Returns the largest of two signed numbers.
16      */
17     function max(int256 a, int256 b) internal pure returns (int256) {
18         return a > b ? a : b;
19     }
20 
21     /**
22      * @dev Returns the smallest of two signed numbers.
23      */
24     function min(int256 a, int256 b) internal pure returns (int256) {
25         return a < b ? a : b;
26     }
27 
28     /**
29      * @dev Returns the average of two signed numbers without overflow.
30      * The result is rounded towards zero.
31      */
32     function average(int256 a, int256 b) internal pure returns (int256) {
33         // Formula from the book "Hacker's Delight"
34         int256 x = (a & b) + ((a ^ b) >> 1);
35         return x + (int256(uint256(x) >> 255) & (a ^ b));
36     }
37 
38     /**
39      * @dev Returns the absolute unsigned value of a signed value.
40      */
41     function abs(int256 n) internal pure returns (uint256) {
42         unchecked {
43             // must be unchecked in order to support `n = type(int256).min`
44             return uint256(n >= 0 ? n : -n);
45         }
46     }
47 }
48 
49 // File: @openzeppelin/contracts/utils/math/Math.sol
50 
51 
52 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev Standard math utilities missing in the Solidity language.
58  */
59 library Math {
60     enum Rounding {
61         Down, // Toward negative infinity
62         Up, // Toward infinity
63         Zero // Toward zero
64     }
65 
66     /**
67      * @dev Returns the largest of two numbers.
68      */
69     function max(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a > b ? a : b;
71     }
72 
73     /**
74      * @dev Returns the smallest of two numbers.
75      */
76     function min(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a < b ? a : b;
78     }
79 
80     /**
81      * @dev Returns the average of two numbers. The result is rounded towards
82      * zero.
83      */
84     function average(uint256 a, uint256 b) internal pure returns (uint256) {
85         // (a + b) / 2 can overflow.
86         return (a & b) + (a ^ b) / 2;
87     }
88 
89     /**
90      * @dev Returns the ceiling of the division of two numbers.
91      *
92      * This differs from standard division with `/` in that it rounds up instead
93      * of rounding down.
94      */
95     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
96         // (a + b - 1) / b can overflow on addition, so we distribute.
97         return a == 0 ? 0 : (a - 1) / b + 1;
98     }
99 
100     /**
101      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
102      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
103      * with further edits by Uniswap Labs also under MIT license.
104      */
105     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
106         unchecked {
107             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
108             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
109             // variables such that product = prod1 * 2^256 + prod0.
110             uint256 prod0; // Least significant 256 bits of the product
111             uint256 prod1; // Most significant 256 bits of the product
112             assembly {
113                 let mm := mulmod(x, y, not(0))
114                 prod0 := mul(x, y)
115                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
116             }
117 
118             // Handle non-overflow cases, 256 by 256 division.
119             if (prod1 == 0) {
120                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
121                 // The surrounding unchecked block does not change this fact.
122                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
123                 return prod0 / denominator;
124             }
125 
126             // Make sure the result is less than 2^256. Also prevents denominator == 0.
127             require(denominator > prod1, "Math: mulDiv overflow");
128 
129             ///////////////////////////////////////////////
130             // 512 by 256 division.
131             ///////////////////////////////////////////////
132 
133             // Make division exact by subtracting the remainder from [prod1 prod0].
134             uint256 remainder;
135             assembly {
136                 // Compute remainder using mulmod.
137                 remainder := mulmod(x, y, denominator)
138 
139                 // Subtract 256 bit number from 512 bit number.
140                 prod1 := sub(prod1, gt(remainder, prod0))
141                 prod0 := sub(prod0, remainder)
142             }
143 
144             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
145             // See https://cs.stackexchange.com/q/138556/92363.
146 
147             // Does not overflow because the denominator cannot be zero at this stage in the function.
148             uint256 twos = denominator & (~denominator + 1);
149             assembly {
150                 // Divide denominator by twos.
151                 denominator := div(denominator, twos)
152 
153                 // Divide [prod1 prod0] by twos.
154                 prod0 := div(prod0, twos)
155 
156                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
157                 twos := add(div(sub(0, twos), twos), 1)
158             }
159 
160             // Shift in bits from prod1 into prod0.
161             prod0 |= prod1 * twos;
162 
163             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
164             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
165             // four bits. That is, denominator * inv = 1 mod 2^4.
166             uint256 inverse = (3 * denominator) ^ 2;
167 
168             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
169             // in modular arithmetic, doubling the correct bits in each step.
170             inverse *= 2 - denominator * inverse; // inverse mod 2^8
171             inverse *= 2 - denominator * inverse; // inverse mod 2^16
172             inverse *= 2 - denominator * inverse; // inverse mod 2^32
173             inverse *= 2 - denominator * inverse; // inverse mod 2^64
174             inverse *= 2 - denominator * inverse; // inverse mod 2^128
175             inverse *= 2 - denominator * inverse; // inverse mod 2^256
176 
177             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
178             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
179             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
180             // is no longer required.
181             result = prod0 * inverse;
182             return result;
183         }
184     }
185 
186     /**
187      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
188      */
189     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
190         uint256 result = mulDiv(x, y, denominator);
191         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
192             result += 1;
193         }
194         return result;
195     }
196 
197     /**
198      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
199      *
200      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
201      */
202     function sqrt(uint256 a) internal pure returns (uint256) {
203         if (a == 0) {
204             return 0;
205         }
206 
207         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
208         //
209         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
210         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
211         //
212         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
213         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
214         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
215         //
216         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
217         uint256 result = 1 << (log2(a) >> 1);
218 
219         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
220         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
221         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
222         // into the expected uint128 result.
223         unchecked {
224             result = (result + a / result) >> 1;
225             result = (result + a / result) >> 1;
226             result = (result + a / result) >> 1;
227             result = (result + a / result) >> 1;
228             result = (result + a / result) >> 1;
229             result = (result + a / result) >> 1;
230             result = (result + a / result) >> 1;
231             return min(result, a / result);
232         }
233     }
234 
235     /**
236      * @notice Calculates sqrt(a), following the selected rounding direction.
237      */
238     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
239         unchecked {
240             uint256 result = sqrt(a);
241             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
242         }
243     }
244 
245     /**
246      * @dev Return the log in base 2, rounded down, of a positive value.
247      * Returns 0 if given 0.
248      */
249     function log2(uint256 value) internal pure returns (uint256) {
250         uint256 result = 0;
251         unchecked {
252             if (value >> 128 > 0) {
253                 value >>= 128;
254                 result += 128;
255             }
256             if (value >> 64 > 0) {
257                 value >>= 64;
258                 result += 64;
259             }
260             if (value >> 32 > 0) {
261                 value >>= 32;
262                 result += 32;
263             }
264             if (value >> 16 > 0) {
265                 value >>= 16;
266                 result += 16;
267             }
268             if (value >> 8 > 0) {
269                 value >>= 8;
270                 result += 8;
271             }
272             if (value >> 4 > 0) {
273                 value >>= 4;
274                 result += 4;
275             }
276             if (value >> 2 > 0) {
277                 value >>= 2;
278                 result += 2;
279             }
280             if (value >> 1 > 0) {
281                 result += 1;
282             }
283         }
284         return result;
285     }
286 
287     /**
288      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
289      * Returns 0 if given 0.
290      */
291     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
292         unchecked {
293             uint256 result = log2(value);
294             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
295         }
296     }
297 
298     /**
299      * @dev Return the log in base 10, rounded down, of a positive value.
300      * Returns 0 if given 0.
301      */
302     function log10(uint256 value) internal pure returns (uint256) {
303         uint256 result = 0;
304         unchecked {
305             if (value >= 10 ** 64) {
306                 value /= 10 ** 64;
307                 result += 64;
308             }
309             if (value >= 10 ** 32) {
310                 value /= 10 ** 32;
311                 result += 32;
312             }
313             if (value >= 10 ** 16) {
314                 value /= 10 ** 16;
315                 result += 16;
316             }
317             if (value >= 10 ** 8) {
318                 value /= 10 ** 8;
319                 result += 8;
320             }
321             if (value >= 10 ** 4) {
322                 value /= 10 ** 4;
323                 result += 4;
324             }
325             if (value >= 10 ** 2) {
326                 value /= 10 ** 2;
327                 result += 2;
328             }
329             if (value >= 10 ** 1) {
330                 result += 1;
331             }
332         }
333         return result;
334     }
335 
336     /**
337      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
338      * Returns 0 if given 0.
339      */
340     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
341         unchecked {
342             uint256 result = log10(value);
343             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
344         }
345     }
346 
347     /**
348      * @dev Return the log in base 256, rounded down, of a positive value.
349      * Returns 0 if given 0.
350      *
351      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
352      */
353     function log256(uint256 value) internal pure returns (uint256) {
354         uint256 result = 0;
355         unchecked {
356             if (value >> 128 > 0) {
357                 value >>= 128;
358                 result += 16;
359             }
360             if (value >> 64 > 0) {
361                 value >>= 64;
362                 result += 8;
363             }
364             if (value >> 32 > 0) {
365                 value >>= 32;
366                 result += 4;
367             }
368             if (value >> 16 > 0) {
369                 value >>= 16;
370                 result += 2;
371             }
372             if (value >> 8 > 0) {
373                 result += 1;
374             }
375         }
376         return result;
377     }
378 
379     /**
380      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
381      * Returns 0 if given 0.
382      */
383     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
384         unchecked {
385             uint256 result = log256(value);
386             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
387         }
388     }
389 }
390 
391 // File: @openzeppelin/contracts/utils/Strings.sol
392 
393 
394 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 
399 
400 /**
401  * @dev String operations.
402  */
403 library Strings {
404     bytes16 private constant _SYMBOLS = "0123456789abcdef";
405     uint8 private constant _ADDRESS_LENGTH = 20;
406 
407     /**
408      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
409      */
410     function toString(uint256 value) internal pure returns (string memory) {
411         unchecked {
412             uint256 length = Math.log10(value) + 1;
413             string memory buffer = new string(length);
414             uint256 ptr;
415             /// @solidity memory-safe-assembly
416             assembly {
417                 ptr := add(buffer, add(32, length))
418             }
419             while (true) {
420                 ptr--;
421                 /// @solidity memory-safe-assembly
422                 assembly {
423                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
424                 }
425                 value /= 10;
426                 if (value == 0) break;
427             }
428             return buffer;
429         }
430     }
431 
432     /**
433      * @dev Converts a `int256` to its ASCII `string` decimal representation.
434      */
435     function toString(int256 value) internal pure returns (string memory) {
436         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
437     }
438 
439     /**
440      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
441      */
442     function toHexString(uint256 value) internal pure returns (string memory) {
443         unchecked {
444             return toHexString(value, Math.log256(value) + 1);
445         }
446     }
447 
448     /**
449      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
450      */
451     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
452         bytes memory buffer = new bytes(2 * length + 2);
453         buffer[0] = "0";
454         buffer[1] = "x";
455         for (uint256 i = 2 * length + 1; i > 1; --i) {
456             buffer[i] = _SYMBOLS[value & 0xf];
457             value >>= 4;
458         }
459         require(value == 0, "Strings: hex length insufficient");
460         return string(buffer);
461     }
462 
463     /**
464      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
465      */
466     function toHexString(address addr) internal pure returns (string memory) {
467         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
468     }
469 
470     /**
471      * @dev Returns true if the two strings are equal.
472      */
473     function equal(string memory a, string memory b) internal pure returns (bool) {
474         return keccak256(bytes(a)) == keccak256(bytes(b));
475     }
476 }
477 
478 // File: @openzeppelin/contracts/utils/Context.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @dev Provides information about the current execution context, including the
487  * sender of the transaction and its data. While these are generally available
488  * via msg.sender and msg.data, they should not be accessed in such a direct
489  * manner, since when dealing with meta-transactions the account sending and
490  * paying for execution may not be the actual sender (as far as an application
491  * is concerned).
492  *
493  * This contract is only required for intermediate, library-like contracts.
494  */
495 abstract contract Context {
496     function _msgSender() internal view virtual returns (address) {
497         return msg.sender;
498     }
499 
500     function _msgData() internal view virtual returns (bytes calldata) {
501         return msg.data;
502     }
503 }
504 
505 // File: @openzeppelin/contracts/access/Ownable.sol
506 
507 
508 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @dev Contract module which provides a basic access control mechanism, where
515  * there is an account (an owner) that can be granted exclusive access to
516  * specific functions.
517  *
518  * By default, the owner account will be the one that deploys the contract. This
519  * can later be changed with {transferOwnership}.
520  *
521  * This module is used through inheritance. It will make available the modifier
522  * `onlyOwner`, which can be applied to your functions to restrict their use to
523  * the owner.
524  */
525 abstract contract Ownable is Context {
526     address private _owner;
527 
528     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
529 
530     /**
531      * @dev Initializes the contract setting the deployer as the initial owner.
532      */
533     constructor() {
534         _transferOwnership(_msgSender());
535     }
536 
537     /**
538      * @dev Throws if called by any account other than the owner.
539      */
540     modifier onlyOwner() {
541         _checkOwner();
542         _;
543     }
544 
545     /**
546      * @dev Returns the address of the current owner.
547      */
548     function owner() public view virtual returns (address) {
549         return _owner;
550     }
551 
552     /**
553      * @dev Throws if the sender is not the owner.
554      */
555     function _checkOwner() internal view virtual {
556         require(owner() == _msgSender(), "Ownable: caller is not the owner");
557     }
558 
559     /**
560      * @dev Leaves the contract without owner. It will not be possible to call
561      * `onlyOwner` functions. Can only be called by the current owner.
562      *
563      * NOTE: Renouncing ownership will leave the contract without an owner,
564      * thereby disabling any functionality that is only available to the owner.
565      */
566     function renounceOwnership() public virtual onlyOwner {
567         _transferOwnership(address(0));
568     }
569 
570     /**
571      * @dev Transfers ownership of the contract to a new account (`newOwner`).
572      * Can only be called by the current owner.
573      */
574     function transferOwnership(address newOwner) public virtual onlyOwner {
575         require(newOwner != address(0), "Ownable: new owner is the zero address");
576         _transferOwnership(newOwner);
577     }
578 
579     /**
580      * @dev Transfers ownership of the contract to a new account (`newOwner`).
581      * Internal function without access restriction.
582      */
583     function _transferOwnership(address newOwner) internal virtual {
584         address oldOwner = _owner;
585         _owner = newOwner;
586         emit OwnershipTransferred(oldOwner, newOwner);
587     }
588 }
589 
590 // File: erc721a/contracts/IERC721A.sol
591 
592 
593 // ERC721A Contracts v4.2.3
594 // Creator: Chiru Labs
595 
596 pragma solidity ^0.8.4;
597 
598 /**
599  * @dev Interface of ERC721A.
600  */
601 interface IERC721A {
602     /**
603      * The caller must own the token or be an approved operator.
604      */
605     error ApprovalCallerNotOwnerNorApproved();
606 
607     /**
608      * The token does not exist.
609      */
610     error ApprovalQueryForNonexistentToken();
611 
612     /**
613      * Cannot query the balance for the zero address.
614      */
615     error BalanceQueryForZeroAddress();
616 
617     /**
618      * Cannot mint to the zero address.
619      */
620     error MintToZeroAddress();
621 
622     /**
623      * The quantity of tokens minted must be more than zero.
624      */
625     error MintZeroQuantity();
626 
627     /**
628      * The token does not exist.
629      */
630     error OwnerQueryForNonexistentToken();
631 
632     /**
633      * The caller must own the token or be an approved operator.
634      */
635     error TransferCallerNotOwnerNorApproved();
636 
637     /**
638      * The token must be owned by `from`.
639      */
640     error TransferFromIncorrectOwner();
641 
642     /**
643      * Cannot safely transfer to a contract that does not implement the
644      * ERC721Receiver interface.
645      */
646     error TransferToNonERC721ReceiverImplementer();
647 
648     /**
649      * Cannot transfer to the zero address.
650      */
651     error TransferToZeroAddress();
652 
653     /**
654      * The token does not exist.
655      */
656     error URIQueryForNonexistentToken();
657 
658     /**
659      * The `quantity` minted with ERC2309 exceeds the safety limit.
660      */
661     error MintERC2309QuantityExceedsLimit();
662 
663     /**
664      * The `extraData` cannot be set on an unintialized ownership slot.
665      */
666     error OwnershipNotInitializedForExtraData();
667 
668     // =============================================================
669     //                            STRUCTS
670     // =============================================================
671 
672     struct TokenOwnership {
673         // The address of the owner.
674         address addr;
675         // Stores the start time of ownership with minimal overhead for tokenomics.
676         uint64 startTimestamp;
677         // Whether the token has been burned.
678         bool burned;
679         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
680         uint24 extraData;
681     }
682 
683     // =============================================================
684     //                         TOKEN COUNTERS
685     // =============================================================
686 
687     /**
688      * @dev Returns the total number of tokens in existence.
689      * Burned tokens will reduce the count.
690      * To get the total number of tokens minted, please see {_totalMinted}.
691      */
692     function totalSupply() external view returns (uint256);
693 
694     // =============================================================
695     //                            IERC165
696     // =============================================================
697 
698     /**
699      * @dev Returns true if this contract implements the interface defined by
700      * `interfaceId`. See the corresponding
701      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
702      * to learn more about how these ids are created.
703      *
704      * This function call must use less than 30000 gas.
705      */
706     function supportsInterface(bytes4 interfaceId) external view returns (bool);
707 
708     // =============================================================
709     //                            IERC721
710     // =============================================================
711 
712     /**
713      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
714      */
715     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
716 
717     /**
718      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
719      */
720     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
721 
722     /**
723      * @dev Emitted when `owner` enables or disables
724      * (`approved`) `operator` to manage all of its assets.
725      */
726     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
727 
728     /**
729      * @dev Returns the number of tokens in `owner`'s account.
730      */
731     function balanceOf(address owner) external view returns (uint256 balance);
732 
733     /**
734      * @dev Returns the owner of the `tokenId` token.
735      *
736      * Requirements:
737      *
738      * - `tokenId` must exist.
739      */
740     function ownerOf(uint256 tokenId) external view returns (address owner);
741 
742     /**
743      * @dev Safely transfers `tokenId` token from `from` to `to`,
744      * checking first that contract recipients are aware of the ERC721 protocol
745      * to prevent tokens from being forever locked.
746      *
747      * Requirements:
748      *
749      * - `from` cannot be the zero address.
750      * - `to` cannot be the zero address.
751      * - `tokenId` token must exist and be owned by `from`.
752      * - If the caller is not `from`, it must be have been allowed to move
753      * this token by either {approve} or {setApprovalForAll}.
754      * - If `to` refers to a smart contract, it must implement
755      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
756      *
757      * Emits a {Transfer} event.
758      */
759     function safeTransferFrom(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes calldata data
764     ) external payable;
765 
766     /**
767      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
768      */
769     function safeTransferFrom(
770         address from,
771         address to,
772         uint256 tokenId
773     ) external payable;
774 
775     /**
776      * @dev Transfers `tokenId` from `from` to `to`.
777      *
778      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
779      * whenever possible.
780      *
781      * Requirements:
782      *
783      * - `from` cannot be the zero address.
784      * - `to` cannot be the zero address.
785      * - `tokenId` token must be owned by `from`.
786      * - If the caller is not `from`, it must be approved to move this token
787      * by either {approve} or {setApprovalForAll}.
788      *
789      * Emits a {Transfer} event.
790      */
791     function transferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) external payable;
796 
797     /**
798      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
799      * The approval is cleared when the token is transferred.
800      *
801      * Only a single account can be approved at a time, so approving the
802      * zero address clears previous approvals.
803      *
804      * Requirements:
805      *
806      * - The caller must own the token or be an approved operator.
807      * - `tokenId` must exist.
808      *
809      * Emits an {Approval} event.
810      */
811     function approve(address to, uint256 tokenId) external payable;
812 
813     /**
814      * @dev Approve or remove `operator` as an operator for the caller.
815      * Operators can call {transferFrom} or {safeTransferFrom}
816      * for any token owned by the caller.
817      *
818      * Requirements:
819      *
820      * - The `operator` cannot be the caller.
821      *
822      * Emits an {ApprovalForAll} event.
823      */
824     function setApprovalForAll(address operator, bool _approved) external;
825 
826     /**
827      * @dev Returns the account approved for `tokenId` token.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must exist.
832      */
833     function getApproved(uint256 tokenId) external view returns (address operator);
834 
835     /**
836      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
837      *
838      * See {setApprovalForAll}.
839      */
840     function isApprovedForAll(address owner, address operator) external view returns (bool);
841 
842     // =============================================================
843     //                        IERC721Metadata
844     // =============================================================
845 
846     /**
847      * @dev Returns the token collection name.
848      */
849     function name() external view returns (string memory);
850 
851     /**
852      * @dev Returns the token collection symbol.
853      */
854     function symbol() external view returns (string memory);
855 
856     /**
857      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
858      */
859     function tokenURI(uint256 tokenId) external view returns (string memory);
860 
861     // =============================================================
862     //                           IERC2309
863     // =============================================================
864 
865     /**
866      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
867      * (inclusive) is transferred from `from` to `to`, as defined in the
868      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
869      *
870      * See {_mintERC2309} for more details.
871      */
872     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
873 }
874 
875 // File: erc721a/contracts/ERC721A.sol
876 
877 
878 // ERC721A Contracts v4.2.3
879 // Creator: Chiru Labs
880 
881 pragma solidity ^0.8.4;
882 
883 
884 /**
885  * @dev Interface of ERC721 token receiver.
886  */
887 interface ERC721A__IERC721Receiver {
888     function onERC721Received(
889         address operator,
890         address from,
891         uint256 tokenId,
892         bytes calldata data
893     ) external returns (bytes4);
894 }
895 
896 /**
897  * @title ERC721A
898  *
899  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
900  * Non-Fungible Token Standard, including the Metadata extension.
901  * Optimized for lower gas during batch mints.
902  *
903  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
904  * starting from `_startTokenId()`.
905  *
906  * Assumptions:
907  *
908  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
909  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
910  */
911 contract ERC721A is IERC721A {
912     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
913     struct TokenApprovalRef {
914         address value;
915     }
916 
917     // =============================================================
918     //                           CONSTANTS
919     // =============================================================
920 
921     // Mask of an entry in packed address data.
922     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
923 
924     // The bit position of `numberMinted` in packed address data.
925     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
926 
927     // The bit position of `numberBurned` in packed address data.
928     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
929 
930     // The bit position of `aux` in packed address data.
931     uint256 private constant _BITPOS_AUX = 192;
932 
933     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
934     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
935 
936     // The bit position of `startTimestamp` in packed ownership.
937     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
938 
939     // The bit mask of the `burned` bit in packed ownership.
940     uint256 private constant _BITMASK_BURNED = 1 << 224;
941 
942     // The bit position of the `nextInitialized` bit in packed ownership.
943     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
944 
945     // The bit mask of the `nextInitialized` bit in packed ownership.
946     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
947 
948     // The bit position of `extraData` in packed ownership.
949     uint256 private constant _BITPOS_EXTRA_DATA = 232;
950 
951     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
952     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
953 
954     // The mask of the lower 160 bits for addresses.
955     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
956 
957     // The maximum `quantity` that can be minted with {_mintERC2309}.
958     // This limit is to prevent overflows on the address data entries.
959     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
960     // is required to cause an overflow, which is unrealistic.
961     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
962 
963     // The `Transfer` event signature is given by:
964     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
965     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
966         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
967 
968     // =============================================================
969     //                            STORAGE
970     // =============================================================
971 
972     // The next token ID to be minted.
973     uint256 private _currentIndex;
974 
975     // The number of tokens burned.
976     uint256 private _burnCounter;
977 
978     // Token name
979     string private _name;
980 
981     // Token symbol
982     string private _symbol;
983 
984     // Mapping from token ID to ownership details
985     // An empty struct value does not necessarily mean the token is unowned.
986     // See {_packedOwnershipOf} implementation for details.
987     //
988     // Bits Layout:
989     // - [0..159]   `addr`
990     // - [160..223] `startTimestamp`
991     // - [224]      `burned`
992     // - [225]      `nextInitialized`
993     // - [232..255] `extraData`
994     mapping(uint256 => uint256) private _packedOwnerships;
995 
996     // Mapping owner address to address data.
997     //
998     // Bits Layout:
999     // - [0..63]    `balance`
1000     // - [64..127]  `numberMinted`
1001     // - [128..191] `numberBurned`
1002     // - [192..255] `aux`
1003     mapping(address => uint256) private _packedAddressData;
1004 
1005     // Mapping from token ID to approved address.
1006     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1007 
1008     // Mapping from owner to operator approvals
1009     mapping(address => mapping(address => bool)) private _operatorApprovals;
1010 
1011     // =============================================================
1012     //                          CONSTRUCTOR
1013     // =============================================================
1014 
1015     constructor(string memory name_, string memory symbol_) {
1016         _name = name_;
1017         _symbol = symbol_;
1018         _currentIndex = _startTokenId();
1019     }
1020 
1021     // =============================================================
1022     //                   TOKEN COUNTING OPERATIONS
1023     // =============================================================
1024 
1025     /**
1026      * @dev Returns the starting token ID.
1027      * To change the starting token ID, please override this function.
1028      */
1029     function _startTokenId() internal view virtual returns (uint256) {
1030         return 1;
1031     }
1032 
1033     /**
1034      * @dev Returns the next token ID to be minted.
1035      */
1036     function _nextTokenId() internal view virtual returns (uint256) {
1037         return _currentIndex;
1038     }
1039 
1040     /**
1041      * @dev Returns the total number of tokens in existence.
1042      * Burned tokens will reduce the count.
1043      * To get the total number of tokens minted, please see {_totalMinted}.
1044      */
1045     function totalSupply() public view virtual override returns (uint256) {
1046         // Counter underflow is impossible as _burnCounter cannot be incremented
1047         // more than `_currentIndex - _startTokenId()` times.
1048         unchecked {
1049             return _currentIndex - _burnCounter - _startTokenId();
1050         }
1051     }
1052 
1053     /**
1054      * @dev Returns the total amount of tokens minted in the contract.
1055      */
1056     function _totalMinted() internal view virtual returns (uint256) {
1057         // Counter underflow is impossible as `_currentIndex` does not decrement,
1058         // and it is initialized to `_startTokenId()`.
1059         unchecked {
1060             return _currentIndex - _startTokenId();
1061         }
1062     }
1063 
1064     /**
1065      * @dev Returns the total number of tokens burned.
1066      */
1067     function _totalBurned() internal view virtual returns (uint256) {
1068         return _burnCounter;
1069     }
1070 
1071     // =============================================================
1072     //                    ADDRESS DATA OPERATIONS
1073     // =============================================================
1074 
1075     /**
1076      * @dev Returns the number of tokens in `owner`'s account.
1077      */
1078     function balanceOf(address owner) public view virtual override returns (uint256) {
1079         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1080         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1081     }
1082 
1083     /**
1084      * Returns the number of tokens minted by `owner`.
1085      */
1086     function _numberMinted(address owner) internal view returns (uint256) {
1087         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1088     }
1089 
1090     /**
1091      * Returns the number of tokens burned by or on behalf of `owner`.
1092      */
1093     function _numberBurned(address owner) internal view returns (uint256) {
1094         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1095     }
1096 
1097     /**
1098      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1099      */
1100     function _getAux(address owner) internal view returns (uint64) {
1101         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1102     }
1103 
1104     /**
1105      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1106      * If there are multiple variables, please pack them into a uint64.
1107      */
1108     function _setAux(address owner, uint64 aux) internal virtual {
1109         uint256 packed = _packedAddressData[owner];
1110         uint256 auxCasted;
1111         // Cast `aux` with assembly to avoid redundant masking.
1112         assembly {
1113             auxCasted := aux
1114         }
1115         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1116         _packedAddressData[owner] = packed;
1117     }
1118 
1119     // =============================================================
1120     //                            IERC165
1121     // =============================================================
1122 
1123     /**
1124      * @dev Returns true if this contract implements the interface defined by
1125      * `interfaceId`. See the corresponding
1126      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1127      * to learn more about how these ids are created.
1128      *
1129      * This function call must use less than 30000 gas.
1130      */
1131     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1132         // The interface IDs are constants representing the first 4 bytes
1133         // of the XOR of all function selectors in the interface.
1134         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1135         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1136         return
1137             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1138             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1139             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1140     }
1141 
1142     // =============================================================
1143     //                        IERC721Metadata
1144     // =============================================================
1145 
1146     /**
1147      * @dev Returns the token collection name.
1148      */
1149     function name() public view virtual override returns (string memory) {
1150         return _name;
1151     }
1152 
1153     /**
1154      * @dev Returns the token collection symbol.
1155      */
1156     function symbol() public view virtual override returns (string memory) {
1157         return _symbol;
1158     }
1159 
1160     /**
1161      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1162      */
1163     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1164         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1165 
1166         string memory baseURI = _baseURI();
1167         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1168     }
1169 
1170     /**
1171      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1172      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1173      * by default, it can be overridden in child contracts.
1174      */
1175     function _baseURI() internal view virtual returns (string memory) {
1176         return '';
1177     }
1178 
1179     // =============================================================
1180     //                     OWNERSHIPS OPERATIONS
1181     // =============================================================
1182 
1183     /**
1184      * @dev Returns the owner of the `tokenId` token.
1185      *
1186      * Requirements:
1187      *
1188      * - `tokenId` must exist.
1189      */
1190     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1191         return address(uint160(_packedOwnershipOf(tokenId)));
1192     }
1193 
1194     /**
1195      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1196      * It gradually moves to O(1) as tokens get transferred around over time.
1197      */
1198     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1199         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1200     }
1201 
1202     /**
1203      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1204      */
1205     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1206         return _unpackedOwnership(_packedOwnerships[index]);
1207     }
1208 
1209     /**
1210      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1211      */
1212     function _initializeOwnershipAt(uint256 index) internal virtual {
1213         if (_packedOwnerships[index] == 0) {
1214             _packedOwnerships[index] = _packedOwnershipOf(index);
1215         }
1216     }
1217 
1218     /**
1219      * Returns the packed ownership data of `tokenId`.
1220      */
1221     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1222         uint256 curr = tokenId;
1223 
1224         unchecked {
1225             if (_startTokenId() <= curr)
1226                 if (curr < _currentIndex) {
1227                     uint256 packed = _packedOwnerships[curr];
1228                     // If not burned.
1229                     if (packed & _BITMASK_BURNED == 0) {
1230                         // Invariant:
1231                         // There will always be an initialized ownership slot
1232                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1233                         // before an unintialized ownership slot
1234                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1235                         // Hence, `curr` will not underflow.
1236                         //
1237                         // We can directly compare the packed value.
1238                         // If the address is zero, packed will be zero.
1239                         while (packed == 0) {
1240                             packed = _packedOwnerships[--curr];
1241                         }
1242                         return packed;
1243                     }
1244                 }
1245         }
1246         revert OwnerQueryForNonexistentToken();
1247     }
1248 
1249     /**
1250      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1251      */
1252     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1253         ownership.addr = address(uint160(packed));
1254         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1255         ownership.burned = packed & _BITMASK_BURNED != 0;
1256         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1257     }
1258 
1259     /**
1260      * @dev Packs ownership data into a single uint256.
1261      */
1262     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1263         assembly {
1264             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1265             owner := and(owner, _BITMASK_ADDRESS)
1266             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1267             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1268         }
1269     }
1270 
1271     /**
1272      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1273      */
1274     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1275         // For branchless setting of the `nextInitialized` flag.
1276         assembly {
1277             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1278             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1279         }
1280     }
1281 
1282     // =============================================================
1283     //                      APPROVAL OPERATIONS
1284     // =============================================================
1285 
1286     /**
1287      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1288      * The approval is cleared when the token is transferred.
1289      *
1290      * Only a single account can be approved at a time, so approving the
1291      * zero address clears previous approvals.
1292      *
1293      * Requirements:
1294      *
1295      * - The caller must own the token or be an approved operator.
1296      * - `tokenId` must exist.
1297      *
1298      * Emits an {Approval} event.
1299      */
1300     function approve(address to, uint256 tokenId) public payable virtual override {
1301         address owner = ownerOf(tokenId);
1302 
1303         if (_msgSenderERC721A() != owner)
1304             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1305                 revert ApprovalCallerNotOwnerNorApproved();
1306             }
1307 
1308         _tokenApprovals[tokenId].value = to;
1309         emit Approval(owner, to, tokenId);
1310     }
1311 
1312     /**
1313      * @dev Returns the account approved for `tokenId` token.
1314      *
1315      * Requirements:
1316      *
1317      * - `tokenId` must exist.
1318      */
1319     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1320         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1321 
1322         return _tokenApprovals[tokenId].value;
1323     }
1324 
1325     /**
1326      * @dev Approve or remove `operator` as an operator for the caller.
1327      * Operators can call {transferFrom} or {safeTransferFrom}
1328      * for any token owned by the caller.
1329      *
1330      * Requirements:
1331      *
1332      * - The `operator` cannot be the caller.
1333      *
1334      * Emits an {ApprovalForAll} event.
1335      */
1336     function setApprovalForAll(address operator, bool approved) public virtual override {
1337         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1338         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1339     }
1340 
1341     /**
1342      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1343      *
1344      * See {setApprovalForAll}.
1345      */
1346     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1347         return _operatorApprovals[owner][operator];
1348     }
1349 
1350     /**
1351      * @dev Returns whether `tokenId` exists.
1352      *
1353      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1354      *
1355      * Tokens start existing when they are minted. See {_mint}.
1356      */
1357     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1358         return
1359             _startTokenId() <= tokenId &&
1360             tokenId < _currentIndex && // If within bounds,
1361             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1362     }
1363 
1364     /**
1365      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1366      */
1367     function _isSenderApprovedOrOwner(
1368         address approvedAddress,
1369         address owner,
1370         address msgSender
1371     ) private pure returns (bool result) {
1372         assembly {
1373             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1374             owner := and(owner, _BITMASK_ADDRESS)
1375             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1376             msgSender := and(msgSender, _BITMASK_ADDRESS)
1377             // `msgSender == owner || msgSender == approvedAddress`.
1378             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1379         }
1380     }
1381 
1382     /**
1383      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1384      */
1385     function _getApprovedSlotAndAddress(uint256 tokenId)
1386         private
1387         view
1388         returns (uint256 approvedAddressSlot, address approvedAddress)
1389     {
1390         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1391         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1392         assembly {
1393             approvedAddressSlot := tokenApproval.slot
1394             approvedAddress := sload(approvedAddressSlot)
1395         }
1396     }
1397 
1398     // =============================================================
1399     //                      TRANSFER OPERATIONS
1400     // =============================================================
1401 
1402     /**
1403      * @dev Transfers `tokenId` from `from` to `to`.
1404      *
1405      * Requirements:
1406      *
1407      * - `from` cannot be the zero address.
1408      * - `to` cannot be the zero address.
1409      * - `tokenId` token must be owned by `from`.
1410      * - If the caller is not `from`, it must be approved to move this token
1411      * by either {approve} or {setApprovalForAll}.
1412      *
1413      * Emits a {Transfer} event.
1414      */
1415     function transferFrom(
1416         address from,
1417         address to,
1418         uint256 tokenId
1419     ) public payable virtual override {
1420         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1421 
1422         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1423 
1424         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1425 
1426         // The nested ifs save around 20+ gas over a compound boolean condition.
1427         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1428             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1429 
1430         if (to == address(0)) revert TransferToZeroAddress();
1431 
1432         _beforeTokenTransfers(from, to, tokenId, 1);
1433 
1434         // Clear approvals from the previous owner.
1435         assembly {
1436             if approvedAddress {
1437                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1438                 sstore(approvedAddressSlot, 0)
1439             }
1440         }
1441 
1442         // Underflow of the sender's balance is impossible because we check for
1443         // ownership above and the recipient's balance can't realistically overflow.
1444         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1445         unchecked {
1446             // We can directly increment and decrement the balances.
1447             --_packedAddressData[from]; // Updates: `balance -= 1`.
1448             ++_packedAddressData[to]; // Updates: `balance += 1`.
1449 
1450             // Updates:
1451             // - `address` to the next owner.
1452             // - `startTimestamp` to the timestamp of transfering.
1453             // - `burned` to `false`.
1454             // - `nextInitialized` to `true`.
1455             _packedOwnerships[tokenId] = _packOwnershipData(
1456                 to,
1457                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1458             );
1459 
1460             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1461             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1462                 uint256 nextTokenId = tokenId + 1;
1463                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1464                 if (_packedOwnerships[nextTokenId] == 0) {
1465                     // If the next slot is within bounds.
1466                     if (nextTokenId != _currentIndex) {
1467                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1468                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1469                     }
1470                 }
1471             }
1472         }
1473 
1474         emit Transfer(from, to, tokenId);
1475         _afterTokenTransfers(from, to, tokenId, 1);
1476     }
1477 
1478     /**
1479      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1480      */
1481     function safeTransferFrom(
1482         address from,
1483         address to,
1484         uint256 tokenId
1485     ) public payable virtual override {
1486         safeTransferFrom(from, to, tokenId, '');
1487     }
1488 
1489     /**
1490      * @dev Safely transfers `tokenId` token from `from` to `to`.
1491      *
1492      * Requirements:
1493      *
1494      * - `from` cannot be the zero address.
1495      * - `to` cannot be the zero address.
1496      * - `tokenId` token must exist and be owned by `from`.
1497      * - If the caller is not `from`, it must be approved to move this token
1498      * by either {approve} or {setApprovalForAll}.
1499      * - If `to` refers to a smart contract, it must implement
1500      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1501      *
1502      * Emits a {Transfer} event.
1503      */
1504     function safeTransferFrom(
1505         address from,
1506         address to,
1507         uint256 tokenId,
1508         bytes memory _data
1509     ) public payable virtual override {
1510         transferFrom(from, to, tokenId);
1511         if (to.code.length != 0)
1512             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1513                 revert TransferToNonERC721ReceiverImplementer();
1514             }
1515     }
1516 
1517     /**
1518      * @dev Hook that is called before a set of serially-ordered token IDs
1519      * are about to be transferred. This includes minting.
1520      * And also called before burning one token.
1521      *
1522      * `startTokenId` - the first token ID to be transferred.
1523      * `quantity` - the amount to be transferred.
1524      *
1525      * Calling conditions:
1526      *
1527      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1528      * transferred to `to`.
1529      * - When `from` is zero, `tokenId` will be minted for `to`.
1530      * - When `to` is zero, `tokenId` will be burned by `from`.
1531      * - `from` and `to` are never both zero.
1532      */
1533     function _beforeTokenTransfers(
1534         address from,
1535         address to,
1536         uint256 startTokenId,
1537         uint256 quantity
1538     ) internal virtual {}
1539 
1540     /**
1541      * @dev Hook that is called after a set of serially-ordered token IDs
1542      * have been transferred. This includes minting.
1543      * And also called after one token has been burned.
1544      *
1545      * `startTokenId` - the first token ID to be transferred.
1546      * `quantity` - the amount to be transferred.
1547      *
1548      * Calling conditions:
1549      *
1550      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1551      * transferred to `to`.
1552      * - When `from` is zero, `tokenId` has been minted for `to`.
1553      * - When `to` is zero, `tokenId` has been burned by `from`.
1554      * - `from` and `to` are never both zero.
1555      */
1556     function _afterTokenTransfers(
1557         address from,
1558         address to,
1559         uint256 startTokenId,
1560         uint256 quantity
1561     ) internal virtual {}
1562 
1563     /**
1564      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1565      *
1566      * `from` - Previous owner of the given token ID.
1567      * `to` - Target address that will receive the token.
1568      * `tokenId` - Token ID to be transferred.
1569      * `_data` - Optional data to send along with the call.
1570      *
1571      * Returns whether the call correctly returned the expected magic value.
1572      */
1573     function _checkContractOnERC721Received(
1574         address from,
1575         address to,
1576         uint256 tokenId,
1577         bytes memory _data
1578     ) private returns (bool) {
1579         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1580             bytes4 retval
1581         ) {
1582             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1583         } catch (bytes memory reason) {
1584             if (reason.length == 0) {
1585                 revert TransferToNonERC721ReceiverImplementer();
1586             } else {
1587                 assembly {
1588                     revert(add(32, reason), mload(reason))
1589                 }
1590             }
1591         }
1592     }
1593 
1594     // =============================================================
1595     //                        MINT OPERATIONS
1596     // =============================================================
1597 
1598     /**
1599      * @dev Mints `quantity` tokens and transfers them to `to`.
1600      *
1601      * Requirements:
1602      *
1603      * - `to` cannot be the zero address.
1604      * - `quantity` must be greater than 0.
1605      *
1606      * Emits a {Transfer} event for each mint.
1607      */
1608     function _mint(address to, uint256 quantity) internal virtual {
1609         uint256 startTokenId = _currentIndex;
1610         if (quantity == 0) revert MintZeroQuantity();
1611 
1612         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1613 
1614         // Overflows are incredibly unrealistic.
1615         // `balance` and `numberMinted` have a maximum limit of 2**64.
1616         // `tokenId` has a maximum limit of 2**256.
1617         unchecked {
1618             // Updates:
1619             // - `balance += quantity`.
1620             // - `numberMinted += quantity`.
1621             //
1622             // We can directly add to the `balance` and `numberMinted`.
1623             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1624 
1625             // Updates:
1626             // - `address` to the owner.
1627             // - `startTimestamp` to the timestamp of minting.
1628             // - `burned` to `false`.
1629             // - `nextInitialized` to `quantity == 1`.
1630             _packedOwnerships[startTokenId] = _packOwnershipData(
1631                 to,
1632                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1633             );
1634 
1635             uint256 toMasked;
1636             uint256 end = startTokenId + quantity;
1637 
1638             // Use assembly to loop and emit the `Transfer` event for gas savings.
1639             // The duplicated `log4` removes an extra check and reduces stack juggling.
1640             // The assembly, together with the surrounding Solidity code, have been
1641             // delicately arranged to nudge the compiler into producing optimized opcodes.
1642             assembly {
1643                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1644                 toMasked := and(to, _BITMASK_ADDRESS)
1645                 // Emit the `Transfer` event.
1646                 log4(
1647                     0, // Start of data (0, since no data).
1648                     0, // End of data (0, since no data).
1649                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1650                     0, // `address(0)`.
1651                     toMasked, // `to`.
1652                     startTokenId // `tokenId`.
1653                 )
1654 
1655                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1656                 // that overflows uint256 will make the loop run out of gas.
1657                 // The compiler will optimize the `iszero` away for performance.
1658                 for {
1659                     let tokenId := add(startTokenId, 1)
1660                 } iszero(eq(tokenId, end)) {
1661                     tokenId := add(tokenId, 1)
1662                 } {
1663                     // Emit the `Transfer` event. Similar to above.
1664                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1665                 }
1666             }
1667             if (toMasked == 0) revert MintToZeroAddress();
1668 
1669             _currentIndex = end;
1670         }
1671         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1672     }
1673 
1674     /**
1675      * @dev Mints `quantity` tokens and transfers them to `to`.
1676      *
1677      * This function is intended for efficient minting only during contract creation.
1678      *
1679      * It emits only one {ConsecutiveTransfer} as defined in
1680      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1681      * instead of a sequence of {Transfer} event(s).
1682      *
1683      * Calling this function outside of contract creation WILL make your contract
1684      * non-compliant with the ERC721 standard.
1685      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1686      * {ConsecutiveTransfer} event is only permissible during contract creation.
1687      *
1688      * Requirements:
1689      *
1690      * - `to` cannot be the zero address.
1691      * - `quantity` must be greater than 0.
1692      *
1693      * Emits a {ConsecutiveTransfer} event.
1694      */
1695     function _mintERC2309(address to, uint256 quantity) internal virtual {
1696         uint256 startTokenId = _currentIndex;
1697         if (to == address(0)) revert MintToZeroAddress();
1698         if (quantity == 0) revert MintZeroQuantity();
1699         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1700 
1701         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1702 
1703         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1704         unchecked {
1705             // Updates:
1706             // - `balance += quantity`.
1707             // - `numberMinted += quantity`.
1708             //
1709             // We can directly add to the `balance` and `numberMinted`.
1710             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1711 
1712             // Updates:
1713             // - `address` to the owner.
1714             // - `startTimestamp` to the timestamp of minting.
1715             // - `burned` to `false`.
1716             // - `nextInitialized` to `quantity == 1`.
1717             _packedOwnerships[startTokenId] = _packOwnershipData(
1718                 to,
1719                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1720             );
1721 
1722             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1723 
1724             _currentIndex = startTokenId + quantity;
1725         }
1726         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1727     }
1728 
1729     /**
1730      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1731      *
1732      * Requirements:
1733      *
1734      * - If `to` refers to a smart contract, it must implement
1735      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1736      * - `quantity` must be greater than 0.
1737      *
1738      * See {_mint}.
1739      *
1740      * Emits a {Transfer} event for each mint.
1741      */
1742     function _safeMint(
1743         address to,
1744         uint256 quantity,
1745         bytes memory _data
1746     ) internal virtual {
1747         _mint(to, quantity);
1748 
1749         unchecked {
1750             if (to.code.length != 0) {
1751                 uint256 end = _currentIndex;
1752                 uint256 index = end - quantity;
1753                 do {
1754                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1755                         revert TransferToNonERC721ReceiverImplementer();
1756                     }
1757                 } while (index < end);
1758                 // Reentrancy protection.
1759                 if (_currentIndex != end) revert();
1760             }
1761         }
1762     }
1763 
1764     /**
1765      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1766      */
1767     function _safeMint(address to, uint256 quantity) internal virtual {
1768         _safeMint(to, quantity, '');
1769     }
1770 
1771     // =============================================================
1772     //                        BURN OPERATIONS
1773     // =============================================================
1774 
1775     /**
1776      * @dev Equivalent to `_burn(tokenId, false)`.
1777      */
1778     function _burn(uint256 tokenId) internal virtual {
1779         _burn(tokenId, false);
1780     }
1781 
1782     /**
1783      * @dev Destroys `tokenId`.
1784      * The approval is cleared when the token is burned.
1785      *
1786      * Requirements:
1787      *
1788      * - `tokenId` must exist.
1789      *
1790      * Emits a {Transfer} event.
1791      */
1792     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1793         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1794 
1795         address from = address(uint160(prevOwnershipPacked));
1796 
1797         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1798 
1799         if (approvalCheck) {
1800             // The nested ifs save around 20+ gas over a compound boolean condition.
1801             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1802                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1803         }
1804 
1805         _beforeTokenTransfers(from, address(0), tokenId, 1);
1806 
1807         // Clear approvals from the previous owner.
1808         assembly {
1809             if approvedAddress {
1810                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1811                 sstore(approvedAddressSlot, 0)
1812             }
1813         }
1814 
1815         // Underflow of the sender's balance is impossible because we check for
1816         // ownership above and the recipient's balance can't realistically overflow.
1817         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1818         unchecked {
1819             // Updates:
1820             // - `balance -= 1`.
1821             // - `numberBurned += 1`.
1822             //
1823             // We can directly decrement the balance, and increment the number burned.
1824             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1825             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1826 
1827             // Updates:
1828             // - `address` to the last owner.
1829             // - `startTimestamp` to the timestamp of burning.
1830             // - `burned` to `true`.
1831             // - `nextInitialized` to `true`.
1832             _packedOwnerships[tokenId] = _packOwnershipData(
1833                 from,
1834                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1835             );
1836 
1837             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1838             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1839                 uint256 nextTokenId = tokenId + 1;
1840                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1841                 if (_packedOwnerships[nextTokenId] == 0) {
1842                     // If the next slot is within bounds.
1843                     if (nextTokenId != _currentIndex) {
1844                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1845                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1846                     }
1847                 }
1848             }
1849         }
1850 
1851         emit Transfer(from, address(0), tokenId);
1852         _afterTokenTransfers(from, address(0), tokenId, 1);
1853 
1854         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1855         unchecked {
1856             _burnCounter++;
1857         }
1858     }
1859 
1860     // =============================================================
1861     //                     EXTRA DATA OPERATIONS
1862     // =============================================================
1863 
1864     /**
1865      * @dev Directly sets the extra data for the ownership data `index`.
1866      */
1867     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1868         uint256 packed = _packedOwnerships[index];
1869         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1870         uint256 extraDataCasted;
1871         // Cast `extraData` with assembly to avoid redundant masking.
1872         assembly {
1873             extraDataCasted := extraData
1874         }
1875         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1876         _packedOwnerships[index] = packed;
1877     }
1878 
1879     /**
1880      * @dev Called during each token transfer to set the 24bit `extraData` field.
1881      * Intended to be overridden by the cosumer contract.
1882      *
1883      * `previousExtraData` - the value of `extraData` before transfer.
1884      *
1885      * Calling conditions:
1886      *
1887      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1888      * transferred to `to`.
1889      * - When `from` is zero, `tokenId` will be minted for `to`.
1890      * - When `to` is zero, `tokenId` will be burned by `from`.
1891      * - `from` and `to` are never both zero.
1892      */
1893     function _extraData(
1894         address from,
1895         address to,
1896         uint24 previousExtraData
1897     ) internal view virtual returns (uint24) {}
1898 
1899     /**
1900      * @dev Returns the next extra data for the packed ownership data.
1901      * The returned result is shifted into position.
1902      */
1903     function _nextExtraData(
1904         address from,
1905         address to,
1906         uint256 prevOwnershipPacked
1907     ) private view returns (uint256) {
1908         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1909         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1910     }
1911 
1912     // =============================================================
1913     //                       OTHER OPERATIONS
1914     // =============================================================
1915 
1916     /**
1917      * @dev Returns the message sender (defaults to `msg.sender`).
1918      *
1919      * If you are writing GSN compatible contracts, you need to override this function.
1920      */
1921     function _msgSenderERC721A() internal view virtual returns (address) {
1922         return msg.sender;
1923     }
1924 
1925     /**
1926      * @dev Converts a uint256 to its ASCII string decimal representation.
1927      */
1928     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1929         assembly {
1930             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1931             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1932             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1933             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1934             let m := add(mload(0x40), 0xa0)
1935             // Update the free memory pointer to allocate.
1936             mstore(0x40, m)
1937             // Assign the `str` to the end.
1938             str := sub(m, 0x20)
1939             // Zeroize the slot after the string.
1940             mstore(str, 0)
1941 
1942             // Cache the end of the memory to calculate the length later.
1943             let end := str
1944 
1945             // We write the string from rightmost digit to leftmost digit.
1946             // The following is essentially a do-while loop that also handles the zero case.
1947             // prettier-ignore
1948             for { let temp := value } 1 {} {
1949                 str := sub(str, 1)
1950                 // Write the character to the pointer.
1951                 // The ASCII index of the '0' character is 48.
1952                 mstore8(str, add(48, mod(temp, 10)))
1953                 // Keep dividing `temp` until zero.
1954                 temp := div(temp, 10)
1955                 // prettier-ignore
1956                 if iszero(temp) { break }
1957             }
1958 
1959             let length := sub(end, str)
1960             // Move the pointer 32 bytes leftwards to make room for the length.
1961             str := sub(str, 0x20)
1962             // Store the length.
1963             mstore(str, length)
1964         }
1965     }
1966 }
1967 
1968 // File: contracts/Princess.sol
1969 
1970 
1971 
1972 pragma solidity ^0.8.18;
1973 
1974 
1975 
1976 
1977 contract Princess is ERC721A, Ownable {
1978     error Paused();
1979     error NotPublic();
1980     error WhitelistEnd();
1981     error NotWhitelisted();
1982     error InsufficientFunds();
1983     error ExceedsMaxSupply();
1984     error ExceedsMaxPerUser();
1985     using Strings for uint256;
1986 
1987     uint256 public _mintPricePublic = 0.0079 ether;
1988     uint256 public _mintPriceWl = 0.0069 ether;
1989     uint256 public _maxPerWallet = 5;
1990     uint256 public _maxSupply = 2023;
1991     bool public _paused = true;
1992     bool public whitelistMint = true;
1993     bytes32 private _MerkleRoot =
1994         0xb7e57536d98568f93dab93e48c6564f48df9e878a30bac194bd174cab0d02257;
1995     string private baseURI;
1996     string private _baseExtension = ".json";
1997     mapping(address => uint256) public _walletMintedCount;
1998     mapping(address => uint256) public _walletMintedCountWl;
1999 
2000     constructor(
2001         string memory _name,
2002         string memory _symbol,
2003         string memory _initBaseURI
2004     ) ERC721A(_name, _symbol) {
2005         setBaseURI(_initBaseURI);
2006     }
2007 
2008     // internal
2009     function _baseURI() internal view virtual override returns (string memory) {
2010         return baseURI;
2011     }
2012 
2013     // public mint
2014     function mint(uint256 _mintAmount) external payable {
2015         if (_paused) revert Paused();
2016         if (totalSupply() + _mintAmount > _maxSupply) revert ExceedsMaxSupply();
2017 
2018         if (msg.sender != owner()) {
2019             if (whitelistMint) revert NotPublic();
2020 
2021             uint256 userMints = _walletMintedCount[msg.sender];
2022             if (_mintAmount + userMints > _maxPerWallet)
2023                 revert ExceedsMaxPerUser();
2024 
2025             if (msg.value < _mintAmount * _mintPricePublic)
2026                 revert InsufficientFunds();
2027         }
2028 
2029         _walletMintedCount[msg.sender] += _mintAmount;
2030         _mint(msg.sender, _mintAmount);
2031     }
2032 
2033     function WLmint(bytes32[] calldata proof, uint256 _mintAmount)
2034         external
2035         payable
2036     {
2037         if (_paused) revert Paused();
2038         if (totalSupply() + _mintAmount > _maxSupply) revert ExceedsMaxSupply();
2039 
2040         if (!whitelistMint) revert WhitelistEnd();
2041 
2042         uint256 wlMints = _walletMintedCountWl[msg.sender];
2043         if (_mintAmount + wlMints > _maxPerWallet) revert ExceedsMaxPerUser();
2044 
2045         if (msg.value < _mintAmount * _mintPriceWl) revert InsufficientFunds();
2046 
2047         if (whitelistMint == true) {
2048             if (!MerkleProofLib.verify(proof, _MerkleRoot, _leaf()))
2049                 revert NotWhitelisted();
2050         }
2051 
2052         _walletMintedCountWl[msg.sender] += _mintAmount;
2053         _mint(msg.sender, _mintAmount);
2054     }
2055 
2056         function tokenURI(uint256 tokenId)
2057         public
2058         view
2059         virtual
2060         override
2061         returns (string memory)
2062     {
2063         require(
2064             _exists(tokenId),
2065             "ERC721Metadata: URI query for nonexistent token"
2066         );
2067 
2068         string memory currentBaseURI = _baseURI();
2069         return
2070             bytes(currentBaseURI).length > 0
2071                 ? string(
2072                     abi.encodePacked(
2073                         currentBaseURI,
2074                         tokenId.toString(),
2075                         _baseExtension
2076                     )
2077                 )
2078                 : "";
2079     }
2080 
2081     //only owner
2082     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2083         baseURI = _newBaseURI;
2084     }
2085 
2086     function setBaseExtension(string memory _newBaseExtension)
2087         external
2088         onlyOwner
2089     {
2090         _baseExtension = _newBaseExtension;
2091     }
2092 
2093     function pause(bool _state) external onlyOwner {
2094         _paused = _state;
2095     }
2096 
2097     function setOnlyWhitelisted(bool _state) external onlyOwner {
2098         whitelistMint = _state;
2099     }
2100 
2101     function setMaxPerWallet(uint256 _newMaxPerWallet) external onlyOwner {
2102         _maxPerWallet = _newMaxPerWallet;
2103     }
2104 
2105     function setMintPriceWl(uint256 _newMintPriceWl) external onlyOwner {
2106         _mintPriceWl = _newMintPriceWl;
2107     }
2108 
2109     function setMintPricePublic(uint256 _newMintPricePublic)
2110         external
2111         onlyOwner
2112     {
2113         _mintPricePublic = _newMintPricePublic;
2114     }
2115 
2116     function setMaxSupply(uint256 _newMaxSupply) external onlyOwner {
2117         _maxSupply = _newMaxSupply;
2118     }
2119 
2120     function setMerkleRoot(bytes32 _NewMerkleRoot) external onlyOwner {
2121         _MerkleRoot = _NewMerkleRoot;
2122     }
2123 
2124     function _leaf() internal view returns (bytes32) {
2125         return keccak256(abi.encodePacked(msg.sender));
2126     }
2127 
2128     function withdrawAll() external onlyOwner {
2129         uint256 balance = address(this).balance;
2130 
2131         (bool os, ) = payable(owner()).call{value: balance}("");
2132         require(os, "Withdrawal failed");
2133     }
2134 }
2135 
2136 library MerkleProofLib {
2137     /// @dev Returns whether `leaf` exists in the Merkle tree with `root`, given `proof`.
2138     function verify(
2139         bytes32[] calldata proof,
2140         bytes32 root,
2141         bytes32 leaf
2142     ) internal pure returns (bool isValid) {
2143         /// @solidity memory-safe-assembly
2144         assembly {
2145             if proof.length {
2146                 // Left shift by 5 is equivalent to multiplying by 0x20.
2147                 let end := add(proof.offset, shl(5, proof.length))
2148                 // Initialize `offset` to the offset of `proof` in the calldata.
2149                 let offset := proof.offset
2150                 // Iterate over proof elements to compute root hash.
2151                 // prettier-ignore
2152                 for {} 1 {} {
2153                     // Slot of `leaf` in scratch space.
2154                     // If the condition is true: 0x20, otherwise: 0x00.
2155                     let scratch := shl(5, gt(leaf, calldataload(offset)))
2156                     // Store elements to hash contiguously in scratch space.
2157                     // Scratch space is 64 bytes (0x00 - 0x3f) and both elements are 32 bytes.
2158                     mstore(scratch, leaf)
2159                     mstore(xor(scratch, 0x20), calldataload(offset))
2160                     // Reuse `leaf` to store the hash to reduce stack operations.
2161                     leaf := keccak256(0x00, 0x40)
2162                     offset := add(offset, 0x20)
2163                     // prettier-ignore
2164                     if iszero(lt(offset, end)) { break }
2165                 }
2166             }
2167             isValid := eq(leaf, root)
2168         }
2169     }
2170 
2171     /// @dev Returns whether all `leafs` exist in the Merkle tree with `root`,
2172     /// given `proof` and `flags`.
2173     function verifyMultiProof(
2174         bytes32[] calldata proof,
2175         bytes32 root,
2176         bytes32[] calldata leafs,
2177         bool[] calldata flags
2178     ) internal pure returns (bool isValid) {
2179         // Rebuilds the root by consuming and producing values on a queue.
2180         // The queue starts with the `leafs` array, and goes into a `hashes` array.
2181         // After the process, the last element on the queue is verified
2182         // to be equal to the `root`.
2183         //
2184         // The `flags` array denotes whether the sibling
2185         // should be popped from the queue (`flag == true`), or
2186         // should be popped from the `proof` (`flag == false`).
2187         /// @solidity memory-safe-assembly
2188         assembly {
2189             // If the number of flags is correct.
2190             // prettier-ignore
2191             for {} eq(add(leafs.length, proof.length), add(flags.length, 1)) {} {
2192 
2193                 // For the case where `proof.length + leafs.length == 1`.
2194                 if iszero(flags.length) {
2195                     // `isValid = (proof.length == 1 ? proof[0] : leafs[0]) == root`.
2196                     isValid := eq(
2197                         calldataload(
2198                             xor(leafs.offset, mul(xor(proof.offset, leafs.offset), proof.length))
2199                         ),
2200                         root
2201                     )
2202                     break
2203                 }
2204 
2205                 // We can use the free memory space for the queue.
2206                 // We don't need to allocate, since the queue is temporary.
2207                 let hashesFront := mload(0x40)
2208                 // Copy the leafs into the hashes.
2209                 // Sometimes, a little memory expansion costs less than branching.
2210                 // Should cost less, even with a high free memory offset of 0x7d00.
2211                 // Left shift by 5 is equivalent to multiplying by 0x20.
2212                 calldatacopy(hashesFront, leafs.offset, shl(5, leafs.length))
2213                 // Compute the back of the hashes.
2214                 let hashesBack := add(hashesFront, shl(5, leafs.length))
2215                 // This is the end of the memory for the queue.
2216                 // We recycle `flags.length` to save on stack variables
2217                 // (this trick may not always save gas).
2218                 flags.length := add(hashesBack, shl(5, flags.length))
2219 
2220                 // We don't need to make a copy of `proof.offset` or `flags.offset`,
2221                 // as they are pass-by-value (this trick may not always save gas).
2222 
2223                 // prettier-ignore
2224                 for {} 1 {} {
2225                     // Pop from `hashes`.
2226                     let a := mload(hashesFront)
2227                     // Pop from `hashes`.
2228                     let b := mload(add(hashesFront, 0x20))
2229                     hashesFront := add(hashesFront, 0x40)
2230 
2231                     // If the flag is false, load the next proof,
2232                     // else, pops from the queue.
2233                     if iszero(calldataload(flags.offset)) {
2234                         // Loads the next proof.
2235                         b := calldataload(proof.offset)
2236                         proof.offset := add(proof.offset, 0x20)
2237                         // Unpop from `hashes`.
2238                         hashesFront := sub(hashesFront, 0x20)
2239                     }
2240                     
2241                     // Advance to the next flag offset.
2242                     flags.offset := add(flags.offset, 0x20)
2243 
2244                     // Slot of `a` in scratch space.
2245                     // If the condition is true: 0x20, otherwise: 0x00.
2246                     let scratch := shl(5, gt(a, b))
2247                     // Hash the scratch space and push the result onto the queue.
2248                     mstore(scratch, a)
2249                     mstore(xor(scratch, 0x20), b)
2250                     mstore(hashesBack, keccak256(0x00, 0x40))
2251                     hashesBack := add(hashesBack, 0x20)
2252                     // prettier-ignore
2253                     if iszero(lt(hashesBack, flags.length)) { break }
2254                 }
2255                 // Checks if the last value in the queue is same as the root.
2256                 isValid := eq(mload(sub(hashesBack, 0x20)), root)
2257                 break
2258             }
2259         }
2260     }
2261 }