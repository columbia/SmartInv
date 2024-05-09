1 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard signed math utilities missing in the Solidity language.
10  */
11 library SignedMath {
12     /**
13      * @dev Returns the largest of two signed numbers.
14      */
15     function max(int256 a, int256 b) internal pure returns (int256) {
16         return a > b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two signed numbers.
21      */
22     function min(int256 a, int256 b) internal pure returns (int256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two signed numbers without overflow.
28      * The result is rounded towards zero.
29      */
30     function average(int256 a, int256 b) internal pure returns (int256) {
31         // Formula from the book "Hacker's Delight"
32         int256 x = (a & b) + ((a ^ b) >> 1);
33         return x + (int256(uint256(x) >> 255) & (a ^ b));
34     }
35 
36     /**
37      * @dev Returns the absolute unsigned value of a signed value.
38      */
39     function abs(int256 n) internal pure returns (uint256) {
40         unchecked {
41             // must be unchecked in order to support `n = type(int256).min`
42             return uint256(n >= 0 ? n : -n);
43         }
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/math/Math.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Standard math utilities missing in the Solidity language.
56  */
57 library Math {
58     enum Rounding {
59         Down, // Toward negative infinity
60         Up, // Toward infinity
61         Zero // Toward zero
62     }
63 
64     /**
65      * @dev Returns the largest of two numbers.
66      */
67     function max(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a > b ? a : b;
69     }
70 
71     /**
72      * @dev Returns the smallest of two numbers.
73      */
74     function min(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a < b ? a : b;
76     }
77 
78     /**
79      * @dev Returns the average of two numbers. The result is rounded towards
80      * zero.
81      */
82     function average(uint256 a, uint256 b) internal pure returns (uint256) {
83         // (a + b) / 2 can overflow.
84         return (a & b) + (a ^ b) / 2;
85     }
86 
87     /**
88      * @dev Returns the ceiling of the division of two numbers.
89      *
90      * This differs from standard division with `/` in that it rounds up instead
91      * of rounding down.
92      */
93     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
94         // (a + b - 1) / b can overflow on addition, so we distribute.
95         return a == 0 ? 0 : (a - 1) / b + 1;
96     }
97 
98     /**
99      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
100      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
101      * with further edits by Uniswap Labs also under MIT license.
102      */
103     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
104         unchecked {
105             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
106             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
107             // variables such that product = prod1 * 2^256 + prod0.
108             uint256 prod0; // Least significant 256 bits of the product
109             uint256 prod1; // Most significant 256 bits of the product
110             assembly {
111                 let mm := mulmod(x, y, not(0))
112                 prod0 := mul(x, y)
113                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
114             }
115 
116             // Handle non-overflow cases, 256 by 256 division.
117             if (prod1 == 0) {
118                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
119                 // The surrounding unchecked block does not change this fact.
120                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
121                 return prod0 / denominator;
122             }
123 
124             // Make sure the result is less than 2^256. Also prevents denominator == 0.
125             require(denominator > prod1, "Math: mulDiv overflow");
126 
127             ///////////////////////////////////////////////
128             // 512 by 256 division.
129             ///////////////////////////////////////////////
130 
131             // Make division exact by subtracting the remainder from [prod1 prod0].
132             uint256 remainder;
133             assembly {
134                 // Compute remainder using mulmod.
135                 remainder := mulmod(x, y, denominator)
136 
137                 // Subtract 256 bit number from 512 bit number.
138                 prod1 := sub(prod1, gt(remainder, prod0))
139                 prod0 := sub(prod0, remainder)
140             }
141 
142             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
143             // See https://cs.stackexchange.com/q/138556/92363.
144 
145             // Does not overflow because the denominator cannot be zero at this stage in the function.
146             uint256 twos = denominator & (~denominator + 1);
147             assembly {
148                 // Divide denominator by twos.
149                 denominator := div(denominator, twos)
150 
151                 // Divide [prod1 prod0] by twos.
152                 prod0 := div(prod0, twos)
153 
154                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
155                 twos := add(div(sub(0, twos), twos), 1)
156             }
157 
158             // Shift in bits from prod1 into prod0.
159             prod0 |= prod1 * twos;
160 
161             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
162             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
163             // four bits. That is, denominator * inv = 1 mod 2^4.
164             uint256 inverse = (3 * denominator) ^ 2;
165 
166             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
167             // in modular arithmetic, doubling the correct bits in each step.
168             inverse *= 2 - denominator * inverse; // inverse mod 2^8
169             inverse *= 2 - denominator * inverse; // inverse mod 2^16
170             inverse *= 2 - denominator * inverse; // inverse mod 2^32
171             inverse *= 2 - denominator * inverse; // inverse mod 2^64
172             inverse *= 2 - denominator * inverse; // inverse mod 2^128
173             inverse *= 2 - denominator * inverse; // inverse mod 2^256
174 
175             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
176             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
177             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
178             // is no longer required.
179             result = prod0 * inverse;
180             return result;
181         }
182     }
183 
184     /**
185      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
186      */
187     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
188         uint256 result = mulDiv(x, y, denominator);
189         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
190             result += 1;
191         }
192         return result;
193     }
194 
195     /**
196      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
197      *
198      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
199      */
200     function sqrt(uint256 a) internal pure returns (uint256) {
201         if (a == 0) {
202             return 0;
203         }
204 
205         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
206         //
207         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
208         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
209         //
210         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
211         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
212         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
213         //
214         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
215         uint256 result = 1 << (log2(a) >> 1);
216 
217         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
218         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
219         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
220         // into the expected uint128 result.
221         unchecked {
222             result = (result + a / result) >> 1;
223             result = (result + a / result) >> 1;
224             result = (result + a / result) >> 1;
225             result = (result + a / result) >> 1;
226             result = (result + a / result) >> 1;
227             result = (result + a / result) >> 1;
228             result = (result + a / result) >> 1;
229             return min(result, a / result);
230         }
231     }
232 
233     /**
234      * @notice Calculates sqrt(a), following the selected rounding direction.
235      */
236     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
237         unchecked {
238             uint256 result = sqrt(a);
239             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
240         }
241     }
242 
243     /**
244      * @dev Return the log in base 2, rounded down, of a positive value.
245      * Returns 0 if given 0.
246      */
247     function log2(uint256 value) internal pure returns (uint256) {
248         uint256 result = 0;
249         unchecked {
250             if (value >> 128 > 0) {
251                 value >>= 128;
252                 result += 128;
253             }
254             if (value >> 64 > 0) {
255                 value >>= 64;
256                 result += 64;
257             }
258             if (value >> 32 > 0) {
259                 value >>= 32;
260                 result += 32;
261             }
262             if (value >> 16 > 0) {
263                 value >>= 16;
264                 result += 16;
265             }
266             if (value >> 8 > 0) {
267                 value >>= 8;
268                 result += 8;
269             }
270             if (value >> 4 > 0) {
271                 value >>= 4;
272                 result += 4;
273             }
274             if (value >> 2 > 0) {
275                 value >>= 2;
276                 result += 2;
277             }
278             if (value >> 1 > 0) {
279                 result += 1;
280             }
281         }
282         return result;
283     }
284 
285     /**
286      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
287      * Returns 0 if given 0.
288      */
289     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
290         unchecked {
291             uint256 result = log2(value);
292             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
293         }
294     }
295 
296     /**
297      * @dev Return the log in base 10, rounded down, of a positive value.
298      * Returns 0 if given 0.
299      */
300     function log10(uint256 value) internal pure returns (uint256) {
301         uint256 result = 0;
302         unchecked {
303             if (value >= 10 ** 64) {
304                 value /= 10 ** 64;
305                 result += 64;
306             }
307             if (value >= 10 ** 32) {
308                 value /= 10 ** 32;
309                 result += 32;
310             }
311             if (value >= 10 ** 16) {
312                 value /= 10 ** 16;
313                 result += 16;
314             }
315             if (value >= 10 ** 8) {
316                 value /= 10 ** 8;
317                 result += 8;
318             }
319             if (value >= 10 ** 4) {
320                 value /= 10 ** 4;
321                 result += 4;
322             }
323             if (value >= 10 ** 2) {
324                 value /= 10 ** 2;
325                 result += 2;
326             }
327             if (value >= 10 ** 1) {
328                 result += 1;
329             }
330         }
331         return result;
332     }
333 
334     /**
335      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
336      * Returns 0 if given 0.
337      */
338     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
339         unchecked {
340             uint256 result = log10(value);
341             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
342         }
343     }
344 
345     /**
346      * @dev Return the log in base 256, rounded down, of a positive value.
347      * Returns 0 if given 0.
348      *
349      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
350      */
351     function log256(uint256 value) internal pure returns (uint256) {
352         uint256 result = 0;
353         unchecked {
354             if (value >> 128 > 0) {
355                 value >>= 128;
356                 result += 16;
357             }
358             if (value >> 64 > 0) {
359                 value >>= 64;
360                 result += 8;
361             }
362             if (value >> 32 > 0) {
363                 value >>= 32;
364                 result += 4;
365             }
366             if (value >> 16 > 0) {
367                 value >>= 16;
368                 result += 2;
369             }
370             if (value >> 8 > 0) {
371                 result += 1;
372             }
373         }
374         return result;
375     }
376 
377     /**
378      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
379      * Returns 0 if given 0.
380      */
381     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
382         unchecked {
383             uint256 result = log256(value);
384             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
385         }
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/Strings.sol
390 
391 
392 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 
398 /**
399  * @dev String operations.
400  */
401 library Strings {
402     bytes16 private constant _SYMBOLS = "0123456789abcdef";
403     uint8 private constant _ADDRESS_LENGTH = 20;
404 
405     /**
406      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
407      */
408     function toString(uint256 value) internal pure returns (string memory) {
409         unchecked {
410             uint256 length = Math.log10(value) + 1;
411             string memory buffer = new string(length);
412             uint256 ptr;
413             /// @solidity memory-safe-assembly
414             assembly {
415                 ptr := add(buffer, add(32, length))
416             }
417             while (true) {
418                 ptr--;
419                 /// @solidity memory-safe-assembly
420                 assembly {
421                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
422                 }
423                 value /= 10;
424                 if (value == 0) break;
425             }
426             return buffer;
427         }
428     }
429 
430     /**
431      * @dev Converts a `int256` to its ASCII `string` decimal representation.
432      */
433     function toString(int256 value) internal pure returns (string memory) {
434         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
435     }
436 
437     /**
438      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
439      */
440     function toHexString(uint256 value) internal pure returns (string memory) {
441         unchecked {
442             return toHexString(value, Math.log256(value) + 1);
443         }
444     }
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
448      */
449     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
450         bytes memory buffer = new bytes(2 * length + 2);
451         buffer[0] = "0";
452         buffer[1] = "x";
453         for (uint256 i = 2 * length + 1; i > 1; --i) {
454             buffer[i] = _SYMBOLS[value & 0xf];
455             value >>= 4;
456         }
457         require(value == 0, "Strings: hex length insufficient");
458         return string(buffer);
459     }
460 
461     /**
462      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
463      */
464     function toHexString(address addr) internal pure returns (string memory) {
465         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
466     }
467 
468     /**
469      * @dev Returns true if the two strings are equal.
470      */
471     function equal(string memory a, string memory b) internal pure returns (bool) {
472         return keccak256(bytes(a)) == keccak256(bytes(b));
473     }
474 }
475 
476 // File: @openzeppelin/contracts/utils/Context.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @dev Provides information about the current execution context, including the
485  * sender of the transaction and its data. While these are generally available
486  * via msg.sender and msg.data, they should not be accessed in such a direct
487  * manner, since when dealing with meta-transactions the account sending and
488  * paying for execution may not be the actual sender (as far as an application
489  * is concerned).
490  *
491  * This contract is only required for intermediate, library-like contracts.
492  */
493 abstract contract Context {
494     function _msgSender() internal view virtual returns (address) {
495         return msg.sender;
496     }
497 
498     function _msgData() internal view virtual returns (bytes calldata) {
499         return msg.data;
500     }
501 }
502 
503 // File: @openzeppelin/contracts/access/Ownable.sol
504 
505 
506 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @dev Contract module which provides a basic access control mechanism, where
513  * there is an account (an owner) that can be granted exclusive access to
514  * specific functions.
515  *
516  * By default, the owner account will be the one that deploys the contract. This
517  * can later be changed with {transferOwnership}.
518  *
519  * This module is used through inheritance. It will make available the modifier
520  * `onlyOwner`, which can be applied to your functions to restrict their use to
521  * the owner.
522  */
523 abstract contract Ownable is Context {
524     address private _owner;
525 
526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
527 
528     /**
529      * @dev Initializes the contract setting the deployer as the initial owner.
530      */
531     constructor() {
532         _transferOwnership(_msgSender());
533     }
534 
535     /**
536      * @dev Throws if called by any account other than the owner.
537      */
538     modifier onlyOwner() {
539         _checkOwner();
540         _;
541     }
542 
543     /**
544      * @dev Returns the address of the current owner.
545      */
546     function owner() public view virtual returns (address) {
547         return _owner;
548     }
549 
550     /**
551      * @dev Throws if the sender is not the owner.
552      */
553     function _checkOwner() internal view virtual {
554         require(owner() == _msgSender(), "Ownable: caller is not the owner");
555     }
556 
557     /**
558      * @dev Leaves the contract without owner. It will not be possible to call
559      * `onlyOwner` functions. Can only be called by the current owner.
560      *
561      * NOTE: Renouncing ownership will leave the contract without an owner,
562      * thereby disabling any functionality that is only available to the owner.
563      */
564     function renounceOwnership() public virtual onlyOwner {
565         _transferOwnership(address(0));
566     }
567 
568     /**
569      * @dev Transfers ownership of the contract to a new account (`newOwner`).
570      * Can only be called by the current owner.
571      */
572     function transferOwnership(address newOwner) public virtual onlyOwner {
573         require(newOwner != address(0), "Ownable: new owner is the zero address");
574         _transferOwnership(newOwner);
575     }
576 
577     /**
578      * @dev Transfers ownership of the contract to a new account (`newOwner`).
579      * Internal function without access restriction.
580      */
581     function _transferOwnership(address newOwner) internal virtual {
582         address oldOwner = _owner;
583         _owner = newOwner;
584         emit OwnershipTransferred(oldOwner, newOwner);
585     }
586 }
587 
588 // File: erc721a/contracts/IERC721A.sol
589 
590 
591 // ERC721A Contracts v4.2.3
592 // Creator: Chiru Labs
593 
594 pragma solidity ^0.8.4;
595 
596 /**
597  * @dev Interface of ERC721A.
598  */
599 interface IERC721A {
600     /**
601      * The caller must own the token or be an approved operator.
602      */
603     error ApprovalCallerNotOwnerNorApproved();
604 
605     /**
606      * The token does not exist.
607      */
608     error ApprovalQueryForNonexistentToken();
609 
610     /**
611      * Cannot query the balance for the zero address.
612      */
613     error BalanceQueryForZeroAddress();
614 
615     /**
616      * Cannot mint to the zero address.
617      */
618     error MintToZeroAddress();
619 
620     /**
621      * The quantity of tokens minted must be more than zero.
622      */
623     error MintZeroQuantity();
624 
625     /**
626      * The token does not exist.
627      */
628     error OwnerQueryForNonexistentToken();
629 
630     /**
631      * The caller must own the token or be an approved operator.
632      */
633     error TransferCallerNotOwnerNorApproved();
634 
635     /**
636      * The token must be owned by `from`.
637      */
638     error TransferFromIncorrectOwner();
639 
640     /**
641      * Cannot safely transfer to a contract that does not implement the
642      * ERC721Receiver interface.
643      */
644     error TransferToNonERC721ReceiverImplementer();
645 
646     /**
647      * Cannot transfer to the zero address.
648      */
649     error TransferToZeroAddress();
650 
651     /**
652      * The token does not exist.
653      */
654     error URIQueryForNonexistentToken();
655 
656     /**
657      * The `quantity` minted with ERC2309 exceeds the safety limit.
658      */
659     error MintERC2309QuantityExceedsLimit();
660 
661     /**
662      * The `extraData` cannot be set on an unintialized ownership slot.
663      */
664     error OwnershipNotInitializedForExtraData();
665 
666     // =============================================================
667     //                            STRUCTS
668     // =============================================================
669 
670     struct TokenOwnership {
671         // The address of the owner.
672         address addr;
673         // Stores the start time of ownership with minimal overhead for tokenomics.
674         uint64 startTimestamp;
675         // Whether the token has been burned.
676         bool burned;
677         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
678         uint24 extraData;
679     }
680 
681     // =============================================================
682     //                         TOKEN COUNTERS
683     // =============================================================
684 
685     /**
686      * @dev Returns the total number of tokens in existence.
687      * Burned tokens will reduce the count.
688      * To get the total number of tokens minted, please see {_totalMinted}.
689      */
690     function totalSupply() external view returns (uint256);
691 
692     // =============================================================
693     //                            IERC165
694     // =============================================================
695 
696     /**
697      * @dev Returns true if this contract implements the interface defined by
698      * `interfaceId`. See the corresponding
699      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
700      * to learn more about how these ids are created.
701      *
702      * This function call must use less than 30000 gas.
703      */
704     function supportsInterface(bytes4 interfaceId) external view returns (bool);
705 
706     // =============================================================
707     //                            IERC721
708     // =============================================================
709 
710     /**
711      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
712      */
713     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
714 
715     /**
716      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
717      */
718     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
719 
720     /**
721      * @dev Emitted when `owner` enables or disables
722      * (`approved`) `operator` to manage all of its assets.
723      */
724     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
725 
726     /**
727      * @dev Returns the number of tokens in `owner`'s account.
728      */
729     function balanceOf(address owner) external view returns (uint256 balance);
730 
731     /**
732      * @dev Returns the owner of the `tokenId` token.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must exist.
737      */
738     function ownerOf(uint256 tokenId) external view returns (address owner);
739 
740     /**
741      * @dev Safely transfers `tokenId` token from `from` to `to`,
742      * checking first that contract recipients are aware of the ERC721 protocol
743      * to prevent tokens from being forever locked.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must exist and be owned by `from`.
750      * - If the caller is not `from`, it must be have been allowed to move
751      * this token by either {approve} or {setApprovalForAll}.
752      * - If `to` refers to a smart contract, it must implement
753      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
754      *
755      * Emits a {Transfer} event.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes calldata data
762     ) external payable;
763 
764     /**
765      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId
771     ) external payable;
772 
773     /**
774      * @dev Transfers `tokenId` from `from` to `to`.
775      *
776      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
777      * whenever possible.
778      *
779      * Requirements:
780      *
781      * - `from` cannot be the zero address.
782      * - `to` cannot be the zero address.
783      * - `tokenId` token must be owned by `from`.
784      * - If the caller is not `from`, it must be approved to move this token
785      * by either {approve} or {setApprovalForAll}.
786      *
787      * Emits a {Transfer} event.
788      */
789     function transferFrom(
790         address from,
791         address to,
792         uint256 tokenId
793     ) external payable;
794 
795     /**
796      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
797      * The approval is cleared when the token is transferred.
798      *
799      * Only a single account can be approved at a time, so approving the
800      * zero address clears previous approvals.
801      *
802      * Requirements:
803      *
804      * - The caller must own the token or be an approved operator.
805      * - `tokenId` must exist.
806      *
807      * Emits an {Approval} event.
808      */
809     function approve(address to, uint256 tokenId) external payable;
810 
811     /**
812      * @dev Approve or remove `operator` as an operator for the caller.
813      * Operators can call {transferFrom} or {safeTransferFrom}
814      * for any token owned by the caller.
815      *
816      * Requirements:
817      *
818      * - The `operator` cannot be the caller.
819      *
820      * Emits an {ApprovalForAll} event.
821      */
822     function setApprovalForAll(address operator, bool _approved) external;
823 
824     /**
825      * @dev Returns the account approved for `tokenId` token.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must exist.
830      */
831     function getApproved(uint256 tokenId) external view returns (address operator);
832 
833     /**
834      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
835      *
836      * See {setApprovalForAll}.
837      */
838     function isApprovedForAll(address owner, address operator) external view returns (bool);
839 
840     // =============================================================
841     //                        IERC721Metadata
842     // =============================================================
843 
844     /**
845      * @dev Returns the token collection name.
846      */
847     function name() external view returns (string memory);
848 
849     /**
850      * @dev Returns the token collection symbol.
851      */
852     function symbol() external view returns (string memory);
853 
854     /**
855      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
856      */
857     function tokenURI(uint256 tokenId) external view returns (string memory);
858 
859     // =============================================================
860     //                           IERC2309
861     // =============================================================
862 
863     /**
864      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
865      * (inclusive) is transferred from `from` to `to`, as defined in the
866      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
867      *
868      * See {_mintERC2309} for more details.
869      */
870     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
871 }
872 
873 // File: erc721a/contracts/ERC721A.sol
874 
875 
876 // ERC721A Contracts v4.2.3
877 // Creator: Chiru Labs
878 
879 pragma solidity ^0.8.4;
880 
881 
882 /**
883  * @dev Interface of ERC721 token receiver.
884  */
885 interface ERC721A__IERC721Receiver {
886     function onERC721Received(
887         address operator,
888         address from,
889         uint256 tokenId,
890         bytes calldata data
891     ) external returns (bytes4);
892 }
893 
894 /**
895  * @title ERC721A
896  *
897  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
898  * Non-Fungible Token Standard, including the Metadata extension.
899  * Optimized for lower gas during batch mints.
900  *
901  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
902  * starting from `_startTokenId()`.
903  *
904  * Assumptions:
905  *
906  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
907  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
908  */
909 contract ERC721A is IERC721A {
910     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
911     struct TokenApprovalRef {
912         address value;
913     }
914 
915     // =============================================================
916     //                           CONSTANTS
917     // =============================================================
918 
919     // Mask of an entry in packed address data.
920     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
921 
922     // The bit position of `numberMinted` in packed address data.
923     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
924 
925     // The bit position of `numberBurned` in packed address data.
926     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
927 
928     // The bit position of `aux` in packed address data.
929     uint256 private constant _BITPOS_AUX = 192;
930 
931     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
932     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
933 
934     // The bit position of `startTimestamp` in packed ownership.
935     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
936 
937     // The bit mask of the `burned` bit in packed ownership.
938     uint256 private constant _BITMASK_BURNED = 1 << 224;
939 
940     // The bit position of the `nextInitialized` bit in packed ownership.
941     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
942 
943     // The bit mask of the `nextInitialized` bit in packed ownership.
944     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
945 
946     // The bit position of `extraData` in packed ownership.
947     uint256 private constant _BITPOS_EXTRA_DATA = 232;
948 
949     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
950     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
951 
952     // The mask of the lower 160 bits for addresses.
953     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
954 
955     // The maximum `quantity` that can be minted with {_mintERC2309}.
956     // This limit is to prevent overflows on the address data entries.
957     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
958     // is required to cause an overflow, which is unrealistic.
959     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
960 
961     // The `Transfer` event signature is given by:
962     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
963     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
964         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
965 
966     // =============================================================
967     //                            STORAGE
968     // =============================================================
969 
970     // The next token ID to be minted.
971     uint256 private _currentIndex;
972 
973     // The number of tokens burned.
974     uint256 private _burnCounter;
975 
976     // Token name
977     string private _name;
978 
979     // Token symbol
980     string private _symbol;
981 
982     // Mapping from token ID to ownership details
983     // An empty struct value does not necessarily mean the token is unowned.
984     // See {_packedOwnershipOf} implementation for details.
985     //
986     // Bits Layout:
987     // - [0..159]   `addr`
988     // - [160..223] `startTimestamp`
989     // - [224]      `burned`
990     // - [225]      `nextInitialized`
991     // - [232..255] `extraData`
992     mapping(uint256 => uint256) private _packedOwnerships;
993 
994     // Mapping owner address to address data.
995     //
996     // Bits Layout:
997     // - [0..63]    `balance`
998     // - [64..127]  `numberMinted`
999     // - [128..191] `numberBurned`
1000     // - [192..255] `aux`
1001     mapping(address => uint256) private _packedAddressData;
1002 
1003     // Mapping from token ID to approved address.
1004     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1005 
1006     // Mapping from owner to operator approvals
1007     mapping(address => mapping(address => bool)) private _operatorApprovals;
1008 
1009     // =============================================================
1010     //                          CONSTRUCTOR
1011     // =============================================================
1012 
1013     constructor(string memory name_, string memory symbol_) {
1014         _name = name_;
1015         _symbol = symbol_;
1016         _currentIndex = _startTokenId();
1017     }
1018 
1019     // =============================================================
1020     //                   TOKEN COUNTING OPERATIONS
1021     // =============================================================
1022 
1023     /**
1024      * @dev Returns the starting token ID.
1025      * To change the starting token ID, please override this function.
1026      */
1027     function _startTokenId() internal view virtual returns (uint256) {
1028         return 0;
1029     }
1030 
1031     /**
1032      * @dev Returns the next token ID to be minted.
1033      */
1034     function _nextTokenId() internal view virtual returns (uint256) {
1035         return _currentIndex;
1036     }
1037 
1038     /**
1039      * @dev Returns the total number of tokens in existence.
1040      * Burned tokens will reduce the count.
1041      * To get the total number of tokens minted, please see {_totalMinted}.
1042      */
1043     function totalSupply() public view virtual override returns (uint256) {
1044         // Counter underflow is impossible as _burnCounter cannot be incremented
1045         // more than `_currentIndex - _startTokenId()` times.
1046         unchecked {
1047             return _currentIndex - _burnCounter - _startTokenId();
1048         }
1049     }
1050 
1051     /**
1052      * @dev Returns the total amount of tokens minted in the contract.
1053      */
1054     function _totalMinted() internal view virtual returns (uint256) {
1055         // Counter underflow is impossible as `_currentIndex` does not decrement,
1056         // and it is initialized to `_startTokenId()`.
1057         unchecked {
1058             return _currentIndex - _startTokenId();
1059         }
1060     }
1061 
1062     /**
1063      * @dev Returns the total number of tokens burned.
1064      */
1065     function _totalBurned() internal view virtual returns (uint256) {
1066         return _burnCounter;
1067     }
1068 
1069     // =============================================================
1070     //                    ADDRESS DATA OPERATIONS
1071     // =============================================================
1072 
1073     /**
1074      * @dev Returns the number of tokens in `owner`'s account.
1075      */
1076     function balanceOf(address owner) public view virtual override returns (uint256) {
1077         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1078         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1079     }
1080 
1081     /**
1082      * Returns the number of tokens minted by `owner`.
1083      */
1084     function _numberMinted(address owner) internal view returns (uint256) {
1085         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1086     }
1087 
1088     /**
1089      * Returns the number of tokens burned by or on behalf of `owner`.
1090      */
1091     function _numberBurned(address owner) internal view returns (uint256) {
1092         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1093     }
1094 
1095     /**
1096      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1097      */
1098     function _getAux(address owner) internal view returns (uint64) {
1099         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1100     }
1101 
1102     /**
1103      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1104      * If there are multiple variables, please pack them into a uint64.
1105      */
1106     function _setAux(address owner, uint64 aux) internal virtual {
1107         uint256 packed = _packedAddressData[owner];
1108         uint256 auxCasted;
1109         // Cast `aux` with assembly to avoid redundant masking.
1110         assembly {
1111             auxCasted := aux
1112         }
1113         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1114         _packedAddressData[owner] = packed;
1115     }
1116 
1117     // =============================================================
1118     //                            IERC165
1119     // =============================================================
1120 
1121     /**
1122      * @dev Returns true if this contract implements the interface defined by
1123      * `interfaceId`. See the corresponding
1124      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1125      * to learn more about how these ids are created.
1126      *
1127      * This function call must use less than 30000 gas.
1128      */
1129     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1130         // The interface IDs are constants representing the first 4 bytes
1131         // of the XOR of all function selectors in the interface.
1132         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1133         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1134         return
1135             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1136             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1137             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1138     }
1139 
1140     // =============================================================
1141     //                        IERC721Metadata
1142     // =============================================================
1143 
1144     /**
1145      * @dev Returns the token collection name.
1146      */
1147     function name() public view virtual override returns (string memory) {
1148         return _name;
1149     }
1150 
1151     /**
1152      * @dev Returns the token collection symbol.
1153      */
1154     function symbol() public view virtual override returns (string memory) {
1155         return _symbol;
1156     }
1157 
1158     /**
1159      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1160      */
1161     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1162         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1163 
1164         string memory baseURI = _baseURI();
1165         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1166     }
1167 
1168     /**
1169      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1170      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1171      * by default, it can be overridden in child contracts.
1172      */
1173     function _baseURI() internal view virtual returns (string memory) {
1174         return '';
1175     }
1176 
1177     // =============================================================
1178     //                     OWNERSHIPS OPERATIONS
1179     // =============================================================
1180 
1181     /**
1182      * @dev Returns the owner of the `tokenId` token.
1183      *
1184      * Requirements:
1185      *
1186      * - `tokenId` must exist.
1187      */
1188     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1189         return address(uint160(_packedOwnershipOf(tokenId)));
1190     }
1191 
1192     /**
1193      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1194      * It gradually moves to O(1) as tokens get transferred around over time.
1195      */
1196     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1197         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1198     }
1199 
1200     /**
1201      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1202      */
1203     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1204         return _unpackedOwnership(_packedOwnerships[index]);
1205     }
1206 
1207     /**
1208      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1209      */
1210     function _initializeOwnershipAt(uint256 index) internal virtual {
1211         if (_packedOwnerships[index] == 0) {
1212             _packedOwnerships[index] = _packedOwnershipOf(index);
1213         }
1214     }
1215 
1216     /**
1217      * Returns the packed ownership data of `tokenId`.
1218      */
1219     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1220         uint256 curr = tokenId;
1221 
1222         unchecked {
1223             if (_startTokenId() <= curr)
1224                 if (curr < _currentIndex) {
1225                     uint256 packed = _packedOwnerships[curr];
1226                     // If not burned.
1227                     if (packed & _BITMASK_BURNED == 0) {
1228                         // Invariant:
1229                         // There will always be an initialized ownership slot
1230                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1231                         // before an unintialized ownership slot
1232                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1233                         // Hence, `curr` will not underflow.
1234                         //
1235                         // We can directly compare the packed value.
1236                         // If the address is zero, packed will be zero.
1237                         while (packed == 0) {
1238                             packed = _packedOwnerships[--curr];
1239                         }
1240                         return packed;
1241                     }
1242                 }
1243         }
1244         revert OwnerQueryForNonexistentToken();
1245     }
1246 
1247     /**
1248      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1249      */
1250     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1251         ownership.addr = address(uint160(packed));
1252         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1253         ownership.burned = packed & _BITMASK_BURNED != 0;
1254         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1255     }
1256 
1257     /**
1258      * @dev Packs ownership data into a single uint256.
1259      */
1260     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1261         assembly {
1262             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1263             owner := and(owner, _BITMASK_ADDRESS)
1264             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1265             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1266         }
1267     }
1268 
1269     /**
1270      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1271      */
1272     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1273         // For branchless setting of the `nextInitialized` flag.
1274         assembly {
1275             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1276             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1277         }
1278     }
1279 
1280     // =============================================================
1281     //                      APPROVAL OPERATIONS
1282     // =============================================================
1283 
1284     /**
1285      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1286      * The approval is cleared when the token is transferred.
1287      *
1288      * Only a single account can be approved at a time, so approving the
1289      * zero address clears previous approvals.
1290      *
1291      * Requirements:
1292      *
1293      * - The caller must own the token or be an approved operator.
1294      * - `tokenId` must exist.
1295      *
1296      * Emits an {Approval} event.
1297      */
1298     function approve(address to, uint256 tokenId) public payable virtual override {
1299         address owner = ownerOf(tokenId);
1300 
1301         if (_msgSenderERC721A() != owner)
1302             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1303                 revert ApprovalCallerNotOwnerNorApproved();
1304             }
1305 
1306         _tokenApprovals[tokenId].value = to;
1307         emit Approval(owner, to, tokenId);
1308     }
1309 
1310     /**
1311      * @dev Returns the account approved for `tokenId` token.
1312      *
1313      * Requirements:
1314      *
1315      * - `tokenId` must exist.
1316      */
1317     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1318         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1319 
1320         return _tokenApprovals[tokenId].value;
1321     }
1322 
1323     /**
1324      * @dev Approve or remove `operator` as an operator for the caller.
1325      * Operators can call {transferFrom} or {safeTransferFrom}
1326      * for any token owned by the caller.
1327      *
1328      * Requirements:
1329      *
1330      * - The `operator` cannot be the caller.
1331      *
1332      * Emits an {ApprovalForAll} event.
1333      */
1334     function setApprovalForAll(address operator, bool approved) public virtual override {
1335         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1336         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1337     }
1338 
1339     /**
1340      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1341      *
1342      * See {setApprovalForAll}.
1343      */
1344     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1345         return _operatorApprovals[owner][operator];
1346     }
1347 
1348     /**
1349      * @dev Returns whether `tokenId` exists.
1350      *
1351      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1352      *
1353      * Tokens start existing when they are minted. See {_mint}.
1354      */
1355     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1356         return
1357             _startTokenId() <= tokenId &&
1358             tokenId < _currentIndex && // If within bounds,
1359             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1360     }
1361 
1362     /**
1363      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1364      */
1365     function _isSenderApprovedOrOwner(
1366         address approvedAddress,
1367         address owner,
1368         address msgSender
1369     ) private pure returns (bool result) {
1370         assembly {
1371             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1372             owner := and(owner, _BITMASK_ADDRESS)
1373             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1374             msgSender := and(msgSender, _BITMASK_ADDRESS)
1375             // `msgSender == owner || msgSender == approvedAddress`.
1376             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1377         }
1378     }
1379 
1380     /**
1381      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1382      */
1383     function _getApprovedSlotAndAddress(uint256 tokenId)
1384         private
1385         view
1386         returns (uint256 approvedAddressSlot, address approvedAddress)
1387     {
1388         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1389         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1390         assembly {
1391             approvedAddressSlot := tokenApproval.slot
1392             approvedAddress := sload(approvedAddressSlot)
1393         }
1394     }
1395 
1396     // =============================================================
1397     //                      TRANSFER OPERATIONS
1398     // =============================================================
1399 
1400     /**
1401      * @dev Transfers `tokenId` from `from` to `to`.
1402      *
1403      * Requirements:
1404      *
1405      * - `from` cannot be the zero address.
1406      * - `to` cannot be the zero address.
1407      * - `tokenId` token must be owned by `from`.
1408      * - If the caller is not `from`, it must be approved to move this token
1409      * by either {approve} or {setApprovalForAll}.
1410      *
1411      * Emits a {Transfer} event.
1412      */
1413     function transferFrom(
1414         address from,
1415         address to,
1416         uint256 tokenId
1417     ) public payable virtual override {
1418         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1419 
1420         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1421 
1422         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1423 
1424         // The nested ifs save around 20+ gas over a compound boolean condition.
1425         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1426             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1427 
1428         if (to == address(0)) revert TransferToZeroAddress();
1429 
1430         _beforeTokenTransfers(from, to, tokenId, 1);
1431 
1432         // Clear approvals from the previous owner.
1433         assembly {
1434             if approvedAddress {
1435                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1436                 sstore(approvedAddressSlot, 0)
1437             }
1438         }
1439 
1440         // Underflow of the sender's balance is impossible because we check for
1441         // ownership above and the recipient's balance can't realistically overflow.
1442         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1443         unchecked {
1444             // We can directly increment and decrement the balances.
1445             --_packedAddressData[from]; // Updates: `balance -= 1`.
1446             ++_packedAddressData[to]; // Updates: `balance += 1`.
1447 
1448             // Updates:
1449             // - `address` to the next owner.
1450             // - `startTimestamp` to the timestamp of transfering.
1451             // - `burned` to `false`.
1452             // - `nextInitialized` to `true`.
1453             _packedOwnerships[tokenId] = _packOwnershipData(
1454                 to,
1455                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1456             );
1457 
1458             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1459             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1460                 uint256 nextTokenId = tokenId + 1;
1461                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1462                 if (_packedOwnerships[nextTokenId] == 0) {
1463                     // If the next slot is within bounds.
1464                     if (nextTokenId != _currentIndex) {
1465                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1466                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1467                     }
1468                 }
1469             }
1470         }
1471 
1472         emit Transfer(from, to, tokenId);
1473         _afterTokenTransfers(from, to, tokenId, 1);
1474     }
1475 
1476     /**
1477      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1478      */
1479     function safeTransferFrom(
1480         address from,
1481         address to,
1482         uint256 tokenId
1483     ) public payable virtual override {
1484         safeTransferFrom(from, to, tokenId, '');
1485     }
1486 
1487     /**
1488      * @dev Safely transfers `tokenId` token from `from` to `to`.
1489      *
1490      * Requirements:
1491      *
1492      * - `from` cannot be the zero address.
1493      * - `to` cannot be the zero address.
1494      * - `tokenId` token must exist and be owned by `from`.
1495      * - If the caller is not `from`, it must be approved to move this token
1496      * by either {approve} or {setApprovalForAll}.
1497      * - If `to` refers to a smart contract, it must implement
1498      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1499      *
1500      * Emits a {Transfer} event.
1501      */
1502     function safeTransferFrom(
1503         address from,
1504         address to,
1505         uint256 tokenId,
1506         bytes memory _data
1507     ) public payable virtual override {
1508         transferFrom(from, to, tokenId);
1509         if (to.code.length != 0)
1510             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1511                 revert TransferToNonERC721ReceiverImplementer();
1512             }
1513     }
1514 
1515     /**
1516      * @dev Hook that is called before a set of serially-ordered token IDs
1517      * are about to be transferred. This includes minting.
1518      * And also called before burning one token.
1519      *
1520      * `startTokenId` - the first token ID to be transferred.
1521      * `quantity` - the amount to be transferred.
1522      *
1523      * Calling conditions:
1524      *
1525      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1526      * transferred to `to`.
1527      * - When `from` is zero, `tokenId` will be minted for `to`.
1528      * - When `to` is zero, `tokenId` will be burned by `from`.
1529      * - `from` and `to` are never both zero.
1530      */
1531     function _beforeTokenTransfers(
1532         address from,
1533         address to,
1534         uint256 startTokenId,
1535         uint256 quantity
1536     ) internal virtual {}
1537 
1538     /**
1539      * @dev Hook that is called after a set of serially-ordered token IDs
1540      * have been transferred. This includes minting.
1541      * And also called after one token has been burned.
1542      *
1543      * `startTokenId` - the first token ID to be transferred.
1544      * `quantity` - the amount to be transferred.
1545      *
1546      * Calling conditions:
1547      *
1548      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1549      * transferred to `to`.
1550      * - When `from` is zero, `tokenId` has been minted for `to`.
1551      * - When `to` is zero, `tokenId` has been burned by `from`.
1552      * - `from` and `to` are never both zero.
1553      */
1554     function _afterTokenTransfers(
1555         address from,
1556         address to,
1557         uint256 startTokenId,
1558         uint256 quantity
1559     ) internal virtual {}
1560 
1561     /**
1562      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1563      *
1564      * `from` - Previous owner of the given token ID.
1565      * `to` - Target address that will receive the token.
1566      * `tokenId` - Token ID to be transferred.
1567      * `_data` - Optional data to send along with the call.
1568      *
1569      * Returns whether the call correctly returned the expected magic value.
1570      */
1571     function _checkContractOnERC721Received(
1572         address from,
1573         address to,
1574         uint256 tokenId,
1575         bytes memory _data
1576     ) private returns (bool) {
1577         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1578             bytes4 retval
1579         ) {
1580             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1581         } catch (bytes memory reason) {
1582             if (reason.length == 0) {
1583                 revert TransferToNonERC721ReceiverImplementer();
1584             } else {
1585                 assembly {
1586                     revert(add(32, reason), mload(reason))
1587                 }
1588             }
1589         }
1590     }
1591 
1592     // =============================================================
1593     //                        MINT OPERATIONS
1594     // =============================================================
1595 
1596     /**
1597      * @dev Mints `quantity` tokens and transfers them to `to`.
1598      *
1599      * Requirements:
1600      *
1601      * - `to` cannot be the zero address.
1602      * - `quantity` must be greater than 0.
1603      *
1604      * Emits a {Transfer} event for each mint.
1605      */
1606     function _mint(address to, uint256 quantity) internal virtual {
1607         uint256 startTokenId = _currentIndex;
1608         if (quantity == 0) revert MintZeroQuantity();
1609 
1610         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1611 
1612         // Overflows are incredibly unrealistic.
1613         // `balance` and `numberMinted` have a maximum limit of 2**64.
1614         // `tokenId` has a maximum limit of 2**256.
1615         unchecked {
1616             // Updates:
1617             // - `balance += quantity`.
1618             // - `numberMinted += quantity`.
1619             //
1620             // We can directly add to the `balance` and `numberMinted`.
1621             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1622 
1623             // Updates:
1624             // - `address` to the owner.
1625             // - `startTimestamp` to the timestamp of minting.
1626             // - `burned` to `false`.
1627             // - `nextInitialized` to `quantity == 1`.
1628             _packedOwnerships[startTokenId] = _packOwnershipData(
1629                 to,
1630                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1631             );
1632 
1633             uint256 toMasked;
1634             uint256 end = startTokenId + quantity;
1635 
1636             // Use assembly to loop and emit the `Transfer` event for gas savings.
1637             // The duplicated `log4` removes an extra check and reduces stack juggling.
1638             // The assembly, together with the surrounding Solidity code, have been
1639             // delicately arranged to nudge the compiler into producing optimized opcodes.
1640             assembly {
1641                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1642                 toMasked := and(to, _BITMASK_ADDRESS)
1643                 // Emit the `Transfer` event.
1644                 log4(
1645                     0, // Start of data (0, since no data).
1646                     0, // End of data (0, since no data).
1647                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1648                     0, // `address(0)`.
1649                     toMasked, // `to`.
1650                     startTokenId // `tokenId`.
1651                 )
1652 
1653                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1654                 // that overflows uint256 will make the loop run out of gas.
1655                 // The compiler will optimize the `iszero` away for performance.
1656                 for {
1657                     let tokenId := add(startTokenId, 1)
1658                 } iszero(eq(tokenId, end)) {
1659                     tokenId := add(tokenId, 1)
1660                 } {
1661                     // Emit the `Transfer` event. Similar to above.
1662                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1663                 }
1664             }
1665             if (toMasked == 0) revert MintToZeroAddress();
1666 
1667             _currentIndex = end;
1668         }
1669         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1670     }
1671 
1672     /**
1673      * @dev Mints `quantity` tokens and transfers them to `to`.
1674      *
1675      * This function is intended for efficient minting only during contract creation.
1676      *
1677      * It emits only one {ConsecutiveTransfer} as defined in
1678      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1679      * instead of a sequence of {Transfer} event(s).
1680      *
1681      * Calling this function outside of contract creation WILL make your contract
1682      * non-compliant with the ERC721 standard.
1683      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1684      * {ConsecutiveTransfer} event is only permissible during contract creation.
1685      *
1686      * Requirements:
1687      *
1688      * - `to` cannot be the zero address.
1689      * - `quantity` must be greater than 0.
1690      *
1691      * Emits a {ConsecutiveTransfer} event.
1692      */
1693     function _mintERC2309(address to, uint256 quantity) internal virtual {
1694         uint256 startTokenId = _currentIndex;
1695         if (to == address(0)) revert MintToZeroAddress();
1696         if (quantity == 0) revert MintZeroQuantity();
1697         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1698 
1699         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1700 
1701         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1702         unchecked {
1703             // Updates:
1704             // - `balance += quantity`.
1705             // - `numberMinted += quantity`.
1706             //
1707             // We can directly add to the `balance` and `numberMinted`.
1708             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1709 
1710             // Updates:
1711             // - `address` to the owner.
1712             // - `startTimestamp` to the timestamp of minting.
1713             // - `burned` to `false`.
1714             // - `nextInitialized` to `quantity == 1`.
1715             _packedOwnerships[startTokenId] = _packOwnershipData(
1716                 to,
1717                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1718             );
1719 
1720             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1721 
1722             _currentIndex = startTokenId + quantity;
1723         }
1724         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1725     }
1726 
1727     /**
1728      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1729      *
1730      * Requirements:
1731      *
1732      * - If `to` refers to a smart contract, it must implement
1733      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1734      * - `quantity` must be greater than 0.
1735      *
1736      * See {_mint}.
1737      *
1738      * Emits a {Transfer} event for each mint.
1739      */
1740     function _safeMint(
1741         address to,
1742         uint256 quantity,
1743         bytes memory _data
1744     ) internal virtual {
1745         _mint(to, quantity);
1746 
1747         unchecked {
1748             if (to.code.length != 0) {
1749                 uint256 end = _currentIndex;
1750                 uint256 index = end - quantity;
1751                 do {
1752                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1753                         revert TransferToNonERC721ReceiverImplementer();
1754                     }
1755                 } while (index < end);
1756                 // Reentrancy protection.
1757                 if (_currentIndex != end) revert();
1758             }
1759         }
1760     }
1761 
1762     /**
1763      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1764      */
1765     function _safeMint(address to, uint256 quantity) internal virtual {
1766         _safeMint(to, quantity, '');
1767     }
1768 
1769     // =============================================================
1770     //                        BURN OPERATIONS
1771     // =============================================================
1772 
1773     /**
1774      * @dev Equivalent to `_burn(tokenId, false)`.
1775      */
1776     function _burn(uint256 tokenId) internal virtual {
1777         _burn(tokenId, false);
1778     }
1779 
1780     /**
1781      * @dev Destroys `tokenId`.
1782      * The approval is cleared when the token is burned.
1783      *
1784      * Requirements:
1785      *
1786      * - `tokenId` must exist.
1787      *
1788      * Emits a {Transfer} event.
1789      */
1790     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1791         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1792 
1793         address from = address(uint160(prevOwnershipPacked));
1794 
1795         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1796 
1797         if (approvalCheck) {
1798             // The nested ifs save around 20+ gas over a compound boolean condition.
1799             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1800                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1801         }
1802 
1803         _beforeTokenTransfers(from, address(0), tokenId, 1);
1804 
1805         // Clear approvals from the previous owner.
1806         assembly {
1807             if approvedAddress {
1808                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1809                 sstore(approvedAddressSlot, 0)
1810             }
1811         }
1812 
1813         // Underflow of the sender's balance is impossible because we check for
1814         // ownership above and the recipient's balance can't realistically overflow.
1815         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1816         unchecked {
1817             // Updates:
1818             // - `balance -= 1`.
1819             // - `numberBurned += 1`.
1820             //
1821             // We can directly decrement the balance, and increment the number burned.
1822             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1823             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1824 
1825             // Updates:
1826             // - `address` to the last owner.
1827             // - `startTimestamp` to the timestamp of burning.
1828             // - `burned` to `true`.
1829             // - `nextInitialized` to `true`.
1830             _packedOwnerships[tokenId] = _packOwnershipData(
1831                 from,
1832                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1833             );
1834 
1835             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1836             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1837                 uint256 nextTokenId = tokenId + 1;
1838                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1839                 if (_packedOwnerships[nextTokenId] == 0) {
1840                     // If the next slot is within bounds.
1841                     if (nextTokenId != _currentIndex) {
1842                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1843                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1844                     }
1845                 }
1846             }
1847         }
1848 
1849         emit Transfer(from, address(0), tokenId);
1850         _afterTokenTransfers(from, address(0), tokenId, 1);
1851 
1852         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1853         unchecked {
1854             _burnCounter++;
1855         }
1856     }
1857 
1858     // =============================================================
1859     //                     EXTRA DATA OPERATIONS
1860     // =============================================================
1861 
1862     /**
1863      * @dev Directly sets the extra data for the ownership data `index`.
1864      */
1865     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1866         uint256 packed = _packedOwnerships[index];
1867         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1868         uint256 extraDataCasted;
1869         // Cast `extraData` with assembly to avoid redundant masking.
1870         assembly {
1871             extraDataCasted := extraData
1872         }
1873         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1874         _packedOwnerships[index] = packed;
1875     }
1876 
1877     /**
1878      * @dev Called during each token transfer to set the 24bit `extraData` field.
1879      * Intended to be overridden by the cosumer contract.
1880      *
1881      * `previousExtraData` - the value of `extraData` before transfer.
1882      *
1883      * Calling conditions:
1884      *
1885      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1886      * transferred to `to`.
1887      * - When `from` is zero, `tokenId` will be minted for `to`.
1888      * - When `to` is zero, `tokenId` will be burned by `from`.
1889      * - `from` and `to` are never both zero.
1890      */
1891     function _extraData(
1892         address from,
1893         address to,
1894         uint24 previousExtraData
1895     ) internal view virtual returns (uint24) {}
1896 
1897     /**
1898      * @dev Returns the next extra data for the packed ownership data.
1899      * The returned result is shifted into position.
1900      */
1901     function _nextExtraData(
1902         address from,
1903         address to,
1904         uint256 prevOwnershipPacked
1905     ) private view returns (uint256) {
1906         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1907         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1908     }
1909 
1910     // =============================================================
1911     //                       OTHER OPERATIONS
1912     // =============================================================
1913 
1914     /**
1915      * @dev Returns the message sender (defaults to `msg.sender`).
1916      *
1917      * If you are writing GSN compatible contracts, you need to override this function.
1918      */
1919     function _msgSenderERC721A() internal view virtual returns (address) {
1920         return msg.sender;
1921     }
1922 
1923     /**
1924      * @dev Converts a uint256 to its ASCII string decimal representation.
1925      */
1926     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1927         assembly {
1928             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1929             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1930             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1931             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1932             let m := add(mload(0x40), 0xa0)
1933             // Update the free memory pointer to allocate.
1934             mstore(0x40, m)
1935             // Assign the `str` to the end.
1936             str := sub(m, 0x20)
1937             // Zeroize the slot after the string.
1938             mstore(str, 0)
1939 
1940             // Cache the end of the memory to calculate the length later.
1941             let end := str
1942 
1943             // We write the string from rightmost digit to leftmost digit.
1944             // The following is essentially a do-while loop that also handles the zero case.
1945             // prettier-ignore
1946             for { let temp := value } 1 {} {
1947                 str := sub(str, 1)
1948                 // Write the character to the pointer.
1949                 // The ASCII index of the '0' character is 48.
1950                 mstore8(str, add(48, mod(temp, 10)))
1951                 // Keep dividing `temp` until zero.
1952                 temp := div(temp, 10)
1953                 // prettier-ignore
1954                 if iszero(temp) { break }
1955             }
1956 
1957             let length := sub(end, str)
1958             // Move the pointer 32 bytes leftwards to make room for the length.
1959             str := sub(str, 0x20)
1960             // Store the length.
1961             mstore(str, length)
1962         }
1963     }
1964 }
1965 
1966 // File: epep.sol
1967 
1968 
1969 
1970 pragma solidity ^0.8.7;
1971 
1972 
1973 
1974 
1975 contract EPEP is ERC721A, Ownable {
1976     uint public maxFree = 2;
1977     uint public supply = 10000;
1978     uint public price = 0.005 ether;
1979     string public baseURI = "https://epep.4everland.store/json/";
1980     string public constant baseExtension = ".json";
1981 
1982     constructor() ERC721A("EPEP", "EPEP") {
1983         _safeMint(msg.sender,1);
1984     }
1985 
1986     function Mint(uint256 _amount) external payable {
1987         address _caller = _msgSender();
1988         require(supply >= totalSupply() + _amount, "Exceeds max supply");
1989         require(_amount > 0, "No 0 mints");
1990         require(tx.origin == _caller, "No contracts");
1991 
1992         if(_numberMinted(msg.sender) >= maxFree) {
1993             require(msg.value >= _amount * price, "Invalid funds provided");
1994         } else{
1995             uint count = _numberMinted(msg.sender) + _amount;
1996             if(count > maxFree){
1997                 require(msg.value >= (count - maxFree) * price , "Insufficient funds");
1998             }
1999         }
2000         _safeMint(_caller, _amount);
2001     }
2002 
2003     function airdrop(address[] memory recipients, uint256 _amount) external onlyOwner  {
2004         for (uint256 i = 0; i < recipients.length; i++) {
2005             _safeMint(recipients[i], _amount);
2006         }
2007     }
2008 
2009     function withdraw() external onlyOwner {
2010         uint256 balance = address(this).balance;
2011         (bool success, ) = _msgSender().call{value: balance}("");
2012         require(success, "Failed to send");
2013     }
2014 
2015     function _startTokenId() internal view virtual override returns (uint256) {
2016         return 1;
2017     }
2018 
2019     function TeamMint(uint256 _amount) external onlyOwner {
2020         _safeMint(_msgSender(), _amount);
2021     }
2022 
2023     function reduceSupply(uint newSupply) external onlyOwner {
2024         supply = newSupply;
2025     }
2026 
2027     function reduceFree(uint newFree) external onlyOwner {
2028         maxFree = newFree;
2029     }
2030 
2031     function setBaseURI(string memory baseURI_) external onlyOwner {
2032         baseURI = baseURI_;
2033     }
2034 
2035     function setCost(uint256 newPrice) external onlyOwner {
2036         price = newPrice;
2037     }
2038     function numberMinted(address owner) public view returns (uint256) {
2039         return _numberMinted(owner);
2040     }
2041 
2042     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
2043         require(_exists(_tokenId), "Token does not exist.");
2044         return bytes(baseURI).length > 0 ? string(
2045             abi.encodePacked(
2046               baseURI,
2047               Strings.toString(_tokenId),
2048             //   _tokenId.toString(),
2049               baseExtension
2050             )
2051         ) : "";
2052     }
2053 }