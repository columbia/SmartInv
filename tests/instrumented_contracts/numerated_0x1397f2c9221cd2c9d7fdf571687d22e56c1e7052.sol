1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
2 
3 
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
28 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
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
84      * `onlyOwner` functions. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby disabling any functionality that is only available to the owner.
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
113 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SignedMath.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Standard signed math utilities missing in the Solidity language.
122  */
123 library SignedMath {
124     /**
125      * @dev Returns the largest of two signed numbers.
126      */
127     function max(int256 a, int256 b) internal pure returns (int256) {
128         return a > b ? a : b;
129     }
130 
131     /**
132      * @dev Returns the smallest of two signed numbers.
133      */
134     function min(int256 a, int256 b) internal pure returns (int256) {
135         return a < b ? a : b;
136     }
137 
138     /**
139      * @dev Returns the average of two signed numbers without overflow.
140      * The result is rounded towards zero.
141      */
142     function average(int256 a, int256 b) internal pure returns (int256) {
143         // Formula from the book "Hacker's Delight"
144         int256 x = (a & b) + ((a ^ b) >> 1);
145         return x + (int256(uint256(x) >> 255) & (a ^ b));
146     }
147 
148     /**
149      * @dev Returns the absolute unsigned value of a signed value.
150      */
151     function abs(int256 n) internal pure returns (uint256) {
152         unchecked {
153             // must be unchecked in order to support `n = type(int256).min`
154             return uint256(n >= 0 ? n : -n);
155         }
156     }
157 }
158 
159 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
160 
161 
162 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 /**
167  * @dev Standard math utilities missing in the Solidity language.
168  */
169 library Math {
170     enum Rounding {
171         Down, // Toward negative infinity
172         Up, // Toward infinity
173         Zero // Toward zero
174     }
175 
176     /**
177      * @dev Returns the largest of two numbers.
178      */
179     function max(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a > b ? a : b;
181     }
182 
183     /**
184      * @dev Returns the smallest of two numbers.
185      */
186     function min(uint256 a, uint256 b) internal pure returns (uint256) {
187         return a < b ? a : b;
188     }
189 
190     /**
191      * @dev Returns the average of two numbers. The result is rounded towards
192      * zero.
193      */
194     function average(uint256 a, uint256 b) internal pure returns (uint256) {
195         // (a + b) / 2 can overflow.
196         return (a & b) + (a ^ b) / 2;
197     }
198 
199     /**
200      * @dev Returns the ceiling of the division of two numbers.
201      *
202      * This differs from standard division with `/` in that it rounds up instead
203      * of rounding down.
204      */
205     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
206         // (a + b - 1) / b can overflow on addition, so we distribute.
207         return a == 0 ? 0 : (a - 1) / b + 1;
208     }
209 
210     /**
211      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
212      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
213      * with further edits by Uniswap Labs also under MIT license.
214      */
215     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
216         unchecked {
217             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
218             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
219             // variables such that product = prod1 * 2^256 + prod0.
220             uint256 prod0; // Least significant 256 bits of the product
221             uint256 prod1; // Most significant 256 bits of the product
222             assembly {
223                 let mm := mulmod(x, y, not(0))
224                 prod0 := mul(x, y)
225                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
226             }
227 
228             // Handle non-overflow cases, 256 by 256 division.
229             if (prod1 == 0) {
230                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
231                 // The surrounding unchecked block does not change this fact.
232                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
233                 return prod0 / denominator;
234             }
235 
236             // Make sure the result is less than 2^256. Also prevents denominator == 0.
237             require(denominator > prod1, "Math: mulDiv overflow");
238 
239             ///////////////////////////////////////////////
240             // 512 by 256 division.
241             ///////////////////////////////////////////////
242 
243             // Make division exact by subtracting the remainder from [prod1 prod0].
244             uint256 remainder;
245             assembly {
246                 // Compute remainder using mulmod.
247                 remainder := mulmod(x, y, denominator)
248 
249                 // Subtract 256 bit number from 512 bit number.
250                 prod1 := sub(prod1, gt(remainder, prod0))
251                 prod0 := sub(prod0, remainder)
252             }
253 
254             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
255             // See https://cs.stackexchange.com/q/138556/92363.
256 
257             // Does not overflow because the denominator cannot be zero at this stage in the function.
258             uint256 twos = denominator & (~denominator + 1);
259             assembly {
260                 // Divide denominator by twos.
261                 denominator := div(denominator, twos)
262 
263                 // Divide [prod1 prod0] by twos.
264                 prod0 := div(prod0, twos)
265 
266                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
267                 twos := add(div(sub(0, twos), twos), 1)
268             }
269 
270             // Shift in bits from prod1 into prod0.
271             prod0 |= prod1 * twos;
272 
273             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
274             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
275             // four bits. That is, denominator * inv = 1 mod 2^4.
276             uint256 inverse = (3 * denominator) ^ 2;
277 
278             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
279             // in modular arithmetic, doubling the correct bits in each step.
280             inverse *= 2 - denominator * inverse; // inverse mod 2^8
281             inverse *= 2 - denominator * inverse; // inverse mod 2^16
282             inverse *= 2 - denominator * inverse; // inverse mod 2^32
283             inverse *= 2 - denominator * inverse; // inverse mod 2^64
284             inverse *= 2 - denominator * inverse; // inverse mod 2^128
285             inverse *= 2 - denominator * inverse; // inverse mod 2^256
286 
287             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
288             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
289             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
290             // is no longer required.
291             result = prod0 * inverse;
292             return result;
293         }
294     }
295 
296     /**
297      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
298      */
299     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
300         uint256 result = mulDiv(x, y, denominator);
301         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
302             result += 1;
303         }
304         return result;
305     }
306 
307     /**
308      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
309      *
310      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
311      */
312     function sqrt(uint256 a) internal pure returns (uint256) {
313         if (a == 0) {
314             return 0;
315         }
316 
317         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
318         //
319         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
320         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
321         //
322         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
323         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
324         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
325         //
326         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
327         uint256 result = 1 << (log2(a) >> 1);
328 
329         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
330         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
331         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
332         // into the expected uint128 result.
333         unchecked {
334             result = (result + a / result) >> 1;
335             result = (result + a / result) >> 1;
336             result = (result + a / result) >> 1;
337             result = (result + a / result) >> 1;
338             result = (result + a / result) >> 1;
339             result = (result + a / result) >> 1;
340             result = (result + a / result) >> 1;
341             return min(result, a / result);
342         }
343     }
344 
345     /**
346      * @notice Calculates sqrt(a), following the selected rounding direction.
347      */
348     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
349         unchecked {
350             uint256 result = sqrt(a);
351             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
352         }
353     }
354 
355     /**
356      * @dev Return the log in base 2, rounded down, of a positive value.
357      * Returns 0 if given 0.
358      */
359     function log2(uint256 value) internal pure returns (uint256) {
360         uint256 result = 0;
361         unchecked {
362             if (value >> 128 > 0) {
363                 value >>= 128;
364                 result += 128;
365             }
366             if (value >> 64 > 0) {
367                 value >>= 64;
368                 result += 64;
369             }
370             if (value >> 32 > 0) {
371                 value >>= 32;
372                 result += 32;
373             }
374             if (value >> 16 > 0) {
375                 value >>= 16;
376                 result += 16;
377             }
378             if (value >> 8 > 0) {
379                 value >>= 8;
380                 result += 8;
381             }
382             if (value >> 4 > 0) {
383                 value >>= 4;
384                 result += 4;
385             }
386             if (value >> 2 > 0) {
387                 value >>= 2;
388                 result += 2;
389             }
390             if (value >> 1 > 0) {
391                 result += 1;
392             }
393         }
394         return result;
395     }
396 
397     /**
398      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
399      * Returns 0 if given 0.
400      */
401     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
402         unchecked {
403             uint256 result = log2(value);
404             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
405         }
406     }
407 
408     /**
409      * @dev Return the log in base 10, rounded down, of a positive value.
410      * Returns 0 if given 0.
411      */
412     function log10(uint256 value) internal pure returns (uint256) {
413         uint256 result = 0;
414         unchecked {
415             if (value >= 10 ** 64) {
416                 value /= 10 ** 64;
417                 result += 64;
418             }
419             if (value >= 10 ** 32) {
420                 value /= 10 ** 32;
421                 result += 32;
422             }
423             if (value >= 10 ** 16) {
424                 value /= 10 ** 16;
425                 result += 16;
426             }
427             if (value >= 10 ** 8) {
428                 value /= 10 ** 8;
429                 result += 8;
430             }
431             if (value >= 10 ** 4) {
432                 value /= 10 ** 4;
433                 result += 4;
434             }
435             if (value >= 10 ** 2) {
436                 value /= 10 ** 2;
437                 result += 2;
438             }
439             if (value >= 10 ** 1) {
440                 result += 1;
441             }
442         }
443         return result;
444     }
445 
446     /**
447      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
448      * Returns 0 if given 0.
449      */
450     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
451         unchecked {
452             uint256 result = log10(value);
453             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
454         }
455     }
456 
457     /**
458      * @dev Return the log in base 256, rounded down, of a positive value.
459      * Returns 0 if given 0.
460      *
461      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
462      */
463     function log256(uint256 value) internal pure returns (uint256) {
464         uint256 result = 0;
465         unchecked {
466             if (value >> 128 > 0) {
467                 value >>= 128;
468                 result += 16;
469             }
470             if (value >> 64 > 0) {
471                 value >>= 64;
472                 result += 8;
473             }
474             if (value >> 32 > 0) {
475                 value >>= 32;
476                 result += 4;
477             }
478             if (value >> 16 > 0) {
479                 value >>= 16;
480                 result += 2;
481             }
482             if (value >> 8 > 0) {
483                 result += 1;
484             }
485         }
486         return result;
487     }
488 
489     /**
490      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
491      * Returns 0 if given 0.
492      */
493     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
494         unchecked {
495             uint256 result = log256(value);
496             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
497         }
498     }
499 }
500 
501 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
502 
503 
504 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 
510 /**
511  * @dev String operations.
512  */
513 library Strings {
514     bytes16 private constant _SYMBOLS = "0123456789abcdef";
515     uint8 private constant _ADDRESS_LENGTH = 20;
516 
517     /**
518      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
519      */
520     function toString(uint256 value) internal pure returns (string memory) {
521         unchecked {
522             uint256 length = Math.log10(value) + 1;
523             string memory buffer = new string(length);
524             uint256 ptr;
525             /// @solidity memory-safe-assembly
526             assembly {
527                 ptr := add(buffer, add(32, length))
528             }
529             while (true) {
530                 ptr--;
531                 /// @solidity memory-safe-assembly
532                 assembly {
533                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
534                 }
535                 value /= 10;
536                 if (value == 0) break;
537             }
538             return buffer;
539         }
540     }
541 
542     /**
543      * @dev Converts a `int256` to its ASCII `string` decimal representation.
544      */
545     function toString(int256 value) internal pure returns (string memory) {
546         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
547     }
548 
549     /**
550      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
551      */
552     function toHexString(uint256 value) internal pure returns (string memory) {
553         unchecked {
554             return toHexString(value, Math.log256(value) + 1);
555         }
556     }
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
560      */
561     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
562         bytes memory buffer = new bytes(2 * length + 2);
563         buffer[0] = "0";
564         buffer[1] = "x";
565         for (uint256 i = 2 * length + 1; i > 1; --i) {
566             buffer[i] = _SYMBOLS[value & 0xf];
567             value >>= 4;
568         }
569         require(value == 0, "Strings: hex length insufficient");
570         return string(buffer);
571     }
572 
573     /**
574      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
575      */
576     function toHexString(address addr) internal pure returns (string memory) {
577         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
578     }
579 
580     /**
581      * @dev Returns true if the two strings are equal.
582      */
583     function equal(string memory a, string memory b) internal pure returns (bool) {
584         return keccak256(bytes(a)) == keccak256(bytes(b));
585     }
586 }
587 
588 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
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
873 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
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
1077         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
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
1162         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
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
1208      * @dev Returns whether the ownership slot at `index` is initialized.
1209      * An uninitialized slot does not necessarily mean that the slot has no owner.
1210      */
1211     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
1212         return _packedOwnerships[index] != 0;
1213     }
1214 
1215     /**
1216      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1217      */
1218     function _initializeOwnershipAt(uint256 index) internal virtual {
1219         if (_packedOwnerships[index] == 0) {
1220             _packedOwnerships[index] = _packedOwnershipOf(index);
1221         }
1222     }
1223 
1224     /**
1225      * Returns the packed ownership data of `tokenId`.
1226      */
1227     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1228         if (_startTokenId() <= tokenId) {
1229             packed = _packedOwnerships[tokenId];
1230             // If the data at the starting slot does not exist, start the scan.
1231             if (packed == 0) {
1232                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
1233                 // Invariant:
1234                 // There will always be an initialized ownership slot
1235                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1236                 // before an unintialized ownership slot
1237                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1238                 // Hence, `tokenId` will not underflow.
1239                 //
1240                 // We can directly compare the packed value.
1241                 // If the address is zero, packed will be zero.
1242                 for (;;) {
1243                     unchecked {
1244                         packed = _packedOwnerships[--tokenId];
1245                     }
1246                     if (packed == 0) continue;
1247                     if (packed & _BITMASK_BURNED == 0) return packed;
1248                     // Otherwise, the token is burned, and we must revert.
1249                     // This handles the case of batch burned tokens, where only the burned bit
1250                     // of the starting slot is set, and remaining slots are left uninitialized.
1251                     _revert(OwnerQueryForNonexistentToken.selector);
1252                 }
1253             }
1254             // Otherwise, the data exists and we can skip the scan.
1255             // This is possible because we have already achieved the target condition.
1256             // This saves 2143 gas on transfers of initialized tokens.
1257             // If the token is not burned, return `packed`. Otherwise, revert.
1258             if (packed & _BITMASK_BURNED == 0) return packed;
1259         }
1260         _revert(OwnerQueryForNonexistentToken.selector);
1261     }
1262 
1263     /**
1264      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1265      */
1266     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1267         ownership.addr = address(uint160(packed));
1268         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1269         ownership.burned = packed & _BITMASK_BURNED != 0;
1270         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1271     }
1272 
1273     /**
1274      * @dev Packs ownership data into a single uint256.
1275      */
1276     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1277         assembly {
1278             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1279             owner := and(owner, _BITMASK_ADDRESS)
1280             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1281             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1282         }
1283     }
1284 
1285     /**
1286      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1287      */
1288     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1289         // For branchless setting of the `nextInitialized` flag.
1290         assembly {
1291             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1292             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1293         }
1294     }
1295 
1296     // =============================================================
1297     //                      APPROVAL OPERATIONS
1298     // =============================================================
1299 
1300     /**
1301      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1302      *
1303      * Requirements:
1304      *
1305      * - The caller must own the token or be an approved operator.
1306      */
1307     function approve(address to, uint256 tokenId) public payable virtual override {
1308         _approve(to, tokenId, true);
1309     }
1310 
1311     /**
1312      * @dev Returns the account approved for `tokenId` token.
1313      *
1314      * Requirements:
1315      *
1316      * - `tokenId` must exist.
1317      */
1318     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1319         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
1320 
1321         return _tokenApprovals[tokenId].value;
1322     }
1323 
1324     /**
1325      * @dev Approve or remove `operator` as an operator for the caller.
1326      * Operators can call {transferFrom} or {safeTransferFrom}
1327      * for any token owned by the caller.
1328      *
1329      * Requirements:
1330      *
1331      * - The `operator` cannot be the caller.
1332      *
1333      * Emits an {ApprovalForAll} event.
1334      */
1335     function setApprovalForAll(address operator, bool approved) public virtual override {
1336         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1337         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1338     }
1339 
1340     /**
1341      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1342      *
1343      * See {setApprovalForAll}.
1344      */
1345     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1346         return _operatorApprovals[owner][operator];
1347     }
1348 
1349     /**
1350      * @dev Returns whether `tokenId` exists.
1351      *
1352      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1353      *
1354      * Tokens start existing when they are minted. See {_mint}.
1355      */
1356     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
1357         if (_startTokenId() <= tokenId) {
1358             if (tokenId < _currentIndex) {
1359                 uint256 packed;
1360                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
1361                 result = packed & _BITMASK_BURNED == 0;
1362             }
1363         }
1364     }
1365 
1366     /**
1367      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1368      */
1369     function _isSenderApprovedOrOwner(
1370         address approvedAddress,
1371         address owner,
1372         address msgSender
1373     ) private pure returns (bool result) {
1374         assembly {
1375             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1376             owner := and(owner, _BITMASK_ADDRESS)
1377             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1378             msgSender := and(msgSender, _BITMASK_ADDRESS)
1379             // `msgSender == owner || msgSender == approvedAddress`.
1380             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1381         }
1382     }
1383 
1384     /**
1385      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1386      */
1387     function _getApprovedSlotAndAddress(uint256 tokenId)
1388         private
1389         view
1390         returns (uint256 approvedAddressSlot, address approvedAddress)
1391     {
1392         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1393         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1394         assembly {
1395             approvedAddressSlot := tokenApproval.slot
1396             approvedAddress := sload(approvedAddressSlot)
1397         }
1398     }
1399 
1400     // =============================================================
1401     //                      TRANSFER OPERATIONS
1402     // =============================================================
1403 
1404     /**
1405      * @dev Transfers `tokenId` from `from` to `to`.
1406      *
1407      * Requirements:
1408      *
1409      * - `from` cannot be the zero address.
1410      * - `to` cannot be the zero address.
1411      * - `tokenId` token must be owned by `from`.
1412      * - If the caller is not `from`, it must be approved to move this token
1413      * by either {approve} or {setApprovalForAll}.
1414      *
1415      * Emits a {Transfer} event.
1416      */
1417     function transferFrom(
1418         address from,
1419         address to,
1420         uint256 tokenId
1421     ) public payable virtual override {
1422         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1423 
1424         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1425         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
1426 
1427         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
1428 
1429         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1430 
1431         // The nested ifs save around 20+ gas over a compound boolean condition.
1432         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1433             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1434 
1435         _beforeTokenTransfers(from, to, tokenId, 1);
1436 
1437         // Clear approvals from the previous owner.
1438         assembly {
1439             if approvedAddress {
1440                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1441                 sstore(approvedAddressSlot, 0)
1442             }
1443         }
1444 
1445         // Underflow of the sender's balance is impossible because we check for
1446         // ownership above and the recipient's balance can't realistically overflow.
1447         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1448         unchecked {
1449             // We can directly increment and decrement the balances.
1450             --_packedAddressData[from]; // Updates: `balance -= 1`.
1451             ++_packedAddressData[to]; // Updates: `balance += 1`.
1452 
1453             // Updates:
1454             // - `address` to the next owner.
1455             // - `startTimestamp` to the timestamp of transfering.
1456             // - `burned` to `false`.
1457             // - `nextInitialized` to `true`.
1458             _packedOwnerships[tokenId] = _packOwnershipData(
1459                 to,
1460                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1461             );
1462 
1463             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1464             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1465                 uint256 nextTokenId = tokenId + 1;
1466                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1467                 if (_packedOwnerships[nextTokenId] == 0) {
1468                     // If the next slot is within bounds.
1469                     if (nextTokenId != _currentIndex) {
1470                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1471                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1472                     }
1473                 }
1474             }
1475         }
1476 
1477         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1478         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1479         assembly {
1480             // Emit the `Transfer` event.
1481             log4(
1482                 0, // Start of data (0, since no data).
1483                 0, // End of data (0, since no data).
1484                 _TRANSFER_EVENT_SIGNATURE, // Signature.
1485                 from, // `from`.
1486                 toMasked, // `to`.
1487                 tokenId // `tokenId`.
1488             )
1489         }
1490         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
1491 
1492         _afterTokenTransfers(from, to, tokenId, 1);
1493     }
1494 
1495     /**
1496      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1497      */
1498     function safeTransferFrom(
1499         address from,
1500         address to,
1501         uint256 tokenId
1502     ) public payable virtual override {
1503         safeTransferFrom(from, to, tokenId, '');
1504     }
1505 
1506     /**
1507      * @dev Safely transfers `tokenId` token from `from` to `to`.
1508      *
1509      * Requirements:
1510      *
1511      * - `from` cannot be the zero address.
1512      * - `to` cannot be the zero address.
1513      * - `tokenId` token must exist and be owned by `from`.
1514      * - If the caller is not `from`, it must be approved to move this token
1515      * by either {approve} or {setApprovalForAll}.
1516      * - If `to` refers to a smart contract, it must implement
1517      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1518      *
1519      * Emits a {Transfer} event.
1520      */
1521     function safeTransferFrom(
1522         address from,
1523         address to,
1524         uint256 tokenId,
1525         bytes memory _data
1526     ) public payable virtual override {
1527         transferFrom(from, to, tokenId);
1528         if (to.code.length != 0)
1529             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1530                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1531             }
1532     }
1533 
1534     /**
1535      * @dev Hook that is called before a set of serially-ordered token IDs
1536      * are about to be transferred. This includes minting.
1537      * And also called before burning one token.
1538      *
1539      * `startTokenId` - the first token ID to be transferred.
1540      * `quantity` - the amount to be transferred.
1541      *
1542      * Calling conditions:
1543      *
1544      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1545      * transferred to `to`.
1546      * - When `from` is zero, `tokenId` will be minted for `to`.
1547      * - When `to` is zero, `tokenId` will be burned by `from`.
1548      * - `from` and `to` are never both zero.
1549      */
1550     function _beforeTokenTransfers(
1551         address from,
1552         address to,
1553         uint256 startTokenId,
1554         uint256 quantity
1555     ) internal virtual {}
1556 
1557     /**
1558      * @dev Hook that is called after a set of serially-ordered token IDs
1559      * have been transferred. This includes minting.
1560      * And also called after one token has been burned.
1561      *
1562      * `startTokenId` - the first token ID to be transferred.
1563      * `quantity` - the amount to be transferred.
1564      *
1565      * Calling conditions:
1566      *
1567      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1568      * transferred to `to`.
1569      * - When `from` is zero, `tokenId` has been minted for `to`.
1570      * - When `to` is zero, `tokenId` has been burned by `from`.
1571      * - `from` and `to` are never both zero.
1572      */
1573     function _afterTokenTransfers(
1574         address from,
1575         address to,
1576         uint256 startTokenId,
1577         uint256 quantity
1578     ) internal virtual {}
1579 
1580     /**
1581      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1582      *
1583      * `from` - Previous owner of the given token ID.
1584      * `to` - Target address that will receive the token.
1585      * `tokenId` - Token ID to be transferred.
1586      * `_data` - Optional data to send along with the call.
1587      *
1588      * Returns whether the call correctly returned the expected magic value.
1589      */
1590     function _checkContractOnERC721Received(
1591         address from,
1592         address to,
1593         uint256 tokenId,
1594         bytes memory _data
1595     ) private returns (bool) {
1596         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1597             bytes4 retval
1598         ) {
1599             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1600         } catch (bytes memory reason) {
1601             if (reason.length == 0) {
1602                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1603             }
1604             assembly {
1605                 revert(add(32, reason), mload(reason))
1606             }
1607         }
1608     }
1609 
1610     // =============================================================
1611     //                        MINT OPERATIONS
1612     // =============================================================
1613 
1614     /**
1615      * @dev Mints `quantity` tokens and transfers them to `to`.
1616      *
1617      * Requirements:
1618      *
1619      * - `to` cannot be the zero address.
1620      * - `quantity` must be greater than 0.
1621      *
1622      * Emits a {Transfer} event for each mint.
1623      */
1624     function _mint(address to, uint256 quantity) internal virtual {
1625         uint256 startTokenId = _currentIndex;
1626         if (quantity == 0) _revert(MintZeroQuantity.selector);
1627 
1628         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1629 
1630         // Overflows are incredibly unrealistic.
1631         // `balance` and `numberMinted` have a maximum limit of 2**64.
1632         // `tokenId` has a maximum limit of 2**256.
1633         unchecked {
1634             // Updates:
1635             // - `address` to the owner.
1636             // - `startTimestamp` to the timestamp of minting.
1637             // - `burned` to `false`.
1638             // - `nextInitialized` to `quantity == 1`.
1639             _packedOwnerships[startTokenId] = _packOwnershipData(
1640                 to,
1641                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1642             );
1643 
1644             // Updates:
1645             // - `balance += quantity`.
1646             // - `numberMinted += quantity`.
1647             //
1648             // We can directly add to the `balance` and `numberMinted`.
1649             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1650 
1651             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1652             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1653 
1654             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1655 
1656             uint256 end = startTokenId + quantity;
1657             uint256 tokenId = startTokenId;
1658 
1659             do {
1660                 assembly {
1661                     // Emit the `Transfer` event.
1662                     log4(
1663                         0, // Start of data (0, since no data).
1664                         0, // End of data (0, since no data).
1665                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1666                         0, // `address(0)`.
1667                         toMasked, // `to`.
1668                         tokenId // `tokenId`.
1669                     )
1670                 }
1671                 // The `!=` check ensures that large values of `quantity`
1672                 // that overflows uint256 will make the loop run out of gas.
1673             } while (++tokenId != end);
1674 
1675             _currentIndex = end;
1676         }
1677         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1678     }
1679 
1680     /**
1681      * @dev Mints `quantity` tokens and transfers them to `to`.
1682      *
1683      * This function is intended for efficient minting only during contract creation.
1684      *
1685      * It emits only one {ConsecutiveTransfer} as defined in
1686      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1687      * instead of a sequence of {Transfer} event(s).
1688      *
1689      * Calling this function outside of contract creation WILL make your contract
1690      * non-compliant with the ERC721 standard.
1691      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1692      * {ConsecutiveTransfer} event is only permissible during contract creation.
1693      *
1694      * Requirements:
1695      *
1696      * - `to` cannot be the zero address.
1697      * - `quantity` must be greater than 0.
1698      *
1699      * Emits a {ConsecutiveTransfer} event.
1700      */
1701     function _mintERC2309(address to, uint256 quantity) internal virtual {
1702         uint256 startTokenId = _currentIndex;
1703         if (to == address(0)) _revert(MintToZeroAddress.selector);
1704         if (quantity == 0) _revert(MintZeroQuantity.selector);
1705         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
1706 
1707         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1708 
1709         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1710         unchecked {
1711             // Updates:
1712             // - `balance += quantity`.
1713             // - `numberMinted += quantity`.
1714             //
1715             // We can directly add to the `balance` and `numberMinted`.
1716             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1717 
1718             // Updates:
1719             // - `address` to the owner.
1720             // - `startTimestamp` to the timestamp of minting.
1721             // - `burned` to `false`.
1722             // - `nextInitialized` to `quantity == 1`.
1723             _packedOwnerships[startTokenId] = _packOwnershipData(
1724                 to,
1725                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1726             );
1727 
1728             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1729 
1730             _currentIndex = startTokenId + quantity;
1731         }
1732         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1733     }
1734 
1735     /**
1736      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1737      *
1738      * Requirements:
1739      *
1740      * - If `to` refers to a smart contract, it must implement
1741      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1742      * - `quantity` must be greater than 0.
1743      *
1744      * See {_mint}.
1745      *
1746      * Emits a {Transfer} event for each mint.
1747      */
1748     function _safeMint(
1749         address to,
1750         uint256 quantity,
1751         bytes memory _data
1752     ) internal virtual {
1753         _mint(to, quantity);
1754 
1755         unchecked {
1756             if (to.code.length != 0) {
1757                 uint256 end = _currentIndex;
1758                 uint256 index = end - quantity;
1759                 do {
1760                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1761                         _revert(TransferToNonERC721ReceiverImplementer.selector);
1762                     }
1763                 } while (index < end);
1764                 // Reentrancy protection.
1765                 if (_currentIndex != end) _revert(bytes4(0));
1766             }
1767         }
1768     }
1769 
1770     /**
1771      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1772      */
1773     function _safeMint(address to, uint256 quantity) internal virtual {
1774         _safeMint(to, quantity, '');
1775     }
1776 
1777     // =============================================================
1778     //                       APPROVAL OPERATIONS
1779     // =============================================================
1780 
1781     /**
1782      * @dev Equivalent to `_approve(to, tokenId, false)`.
1783      */
1784     function _approve(address to, uint256 tokenId) internal virtual {
1785         _approve(to, tokenId, false);
1786     }
1787 
1788     /**
1789      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1790      * The approval is cleared when the token is transferred.
1791      *
1792      * Only a single account can be approved at a time, so approving the
1793      * zero address clears previous approvals.
1794      *
1795      * Requirements:
1796      *
1797      * - `tokenId` must exist.
1798      *
1799      * Emits an {Approval} event.
1800      */
1801     function _approve(
1802         address to,
1803         uint256 tokenId,
1804         bool approvalCheck
1805     ) internal virtual {
1806         address owner = ownerOf(tokenId);
1807 
1808         if (approvalCheck && _msgSenderERC721A() != owner)
1809             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1810                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
1811             }
1812 
1813         _tokenApprovals[tokenId].value = to;
1814         emit Approval(owner, to, tokenId);
1815     }
1816 
1817     // =============================================================
1818     //                        BURN OPERATIONS
1819     // =============================================================
1820 
1821     /**
1822      * @dev Equivalent to `_burn(tokenId, false)`.
1823      */
1824     function _burn(uint256 tokenId) internal virtual {
1825         _burn(tokenId, false);
1826     }
1827 
1828     /**
1829      * @dev Destroys `tokenId`.
1830      * The approval is cleared when the token is burned.
1831      *
1832      * Requirements:
1833      *
1834      * - `tokenId` must exist.
1835      *
1836      * Emits a {Transfer} event.
1837      */
1838     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1839         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1840 
1841         address from = address(uint160(prevOwnershipPacked));
1842 
1843         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1844 
1845         if (approvalCheck) {
1846             // The nested ifs save around 20+ gas over a compound boolean condition.
1847             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1848                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1849         }
1850 
1851         _beforeTokenTransfers(from, address(0), tokenId, 1);
1852 
1853         // Clear approvals from the previous owner.
1854         assembly {
1855             if approvedAddress {
1856                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1857                 sstore(approvedAddressSlot, 0)
1858             }
1859         }
1860 
1861         // Underflow of the sender's balance is impossible because we check for
1862         // ownership above and the recipient's balance can't realistically overflow.
1863         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1864         unchecked {
1865             // Updates:
1866             // - `balance -= 1`.
1867             // - `numberBurned += 1`.
1868             //
1869             // We can directly decrement the balance, and increment the number burned.
1870             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1871             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1872 
1873             // Updates:
1874             // - `address` to the last owner.
1875             // - `startTimestamp` to the timestamp of burning.
1876             // - `burned` to `true`.
1877             // - `nextInitialized` to `true`.
1878             _packedOwnerships[tokenId] = _packOwnershipData(
1879                 from,
1880                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1881             );
1882 
1883             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1884             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1885                 uint256 nextTokenId = tokenId + 1;
1886                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1887                 if (_packedOwnerships[nextTokenId] == 0) {
1888                     // If the next slot is within bounds.
1889                     if (nextTokenId != _currentIndex) {
1890                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1891                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1892                     }
1893                 }
1894             }
1895         }
1896 
1897         emit Transfer(from, address(0), tokenId);
1898         _afterTokenTransfers(from, address(0), tokenId, 1);
1899 
1900         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1901         unchecked {
1902             _burnCounter++;
1903         }
1904     }
1905 
1906     // =============================================================
1907     //                     EXTRA DATA OPERATIONS
1908     // =============================================================
1909 
1910     /**
1911      * @dev Directly sets the extra data for the ownership data `index`.
1912      */
1913     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1914         uint256 packed = _packedOwnerships[index];
1915         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
1916         uint256 extraDataCasted;
1917         // Cast `extraData` with assembly to avoid redundant masking.
1918         assembly {
1919             extraDataCasted := extraData
1920         }
1921         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1922         _packedOwnerships[index] = packed;
1923     }
1924 
1925     /**
1926      * @dev Called during each token transfer to set the 24bit `extraData` field.
1927      * Intended to be overridden by the cosumer contract.
1928      *
1929      * `previousExtraData` - the value of `extraData` before transfer.
1930      *
1931      * Calling conditions:
1932      *
1933      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1934      * transferred to `to`.
1935      * - When `from` is zero, `tokenId` will be minted for `to`.
1936      * - When `to` is zero, `tokenId` will be burned by `from`.
1937      * - `from` and `to` are never both zero.
1938      */
1939     function _extraData(
1940         address from,
1941         address to,
1942         uint24 previousExtraData
1943     ) internal view virtual returns (uint24) {}
1944 
1945     /**
1946      * @dev Returns the next extra data for the packed ownership data.
1947      * The returned result is shifted into position.
1948      */
1949     function _nextExtraData(
1950         address from,
1951         address to,
1952         uint256 prevOwnershipPacked
1953     ) private view returns (uint256) {
1954         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1955         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1956     }
1957 
1958     // =============================================================
1959     //                       OTHER OPERATIONS
1960     // =============================================================
1961 
1962     /**
1963      * @dev Returns the message sender (defaults to `msg.sender`).
1964      *
1965      * If you are writing GSN compatible contracts, you need to override this function.
1966      */
1967     function _msgSenderERC721A() internal view virtual returns (address) {
1968         return msg.sender;
1969     }
1970 
1971     /**
1972      * @dev Converts a uint256 to its ASCII string decimal representation.
1973      */
1974     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1975         assembly {
1976             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1977             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1978             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1979             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1980             let m := add(mload(0x40), 0xa0)
1981             // Update the free memory pointer to allocate.
1982             mstore(0x40, m)
1983             // Assign the `str` to the end.
1984             str := sub(m, 0x20)
1985             // Zeroize the slot after the string.
1986             mstore(str, 0)
1987 
1988             // Cache the end of the memory to calculate the length later.
1989             let end := str
1990 
1991             // We write the string from rightmost digit to leftmost digit.
1992             // The following is essentially a do-while loop that also handles the zero case.
1993             // prettier-ignore
1994             for { let temp := value } 1 {} {
1995                 str := sub(str, 1)
1996                 // Write the character to the pointer.
1997                 // The ASCII index of the '0' character is 48.
1998                 mstore8(str, add(48, mod(temp, 10)))
1999                 // Keep dividing `temp` until zero.
2000                 temp := div(temp, 10)
2001                 // prettier-ignore
2002                 if iszero(temp) { break }
2003             }
2004 
2005             let length := sub(end, str)
2006             // Move the pointer 32 bytes leftwards to make room for the length.
2007             str := sub(str, 0x20)
2008             // Store the length.
2009             mstore(str, length)
2010         }
2011     }
2012 
2013     /**
2014      * @dev For more efficient reverts.
2015      */
2016     function _revert(bytes4 errorSelector) internal pure {
2017         assembly {
2018             mstore(0x00, errorSelector)
2019             revert(0x00, 0x04)
2020         }
2021     }
2022 }
2023 
2024 // File: contracts/wonderlands.sol
2025 
2026 
2027 pragma solidity ^0.8.17;
2028 
2029 
2030 
2031 
2032 
2033 
2034 contract Wonderlands is ERC721A, Ownable {
2035     using Strings for uint256;
2036     uint256 public maxSupply = 1001;
2037     uint256 public maxFreeAmount = 202;
2038     uint256 public maxFreePerWallet = 2;
2039     uint256 public price = 0.002 ether;
2040     uint256 public maxPerTx = 20;
2041     uint256 public maxPerWallet = 20;
2042     bool public mintEnabled = false;
2043     string public baseURI;
2044 
2045  constructor(
2046     string memory _name,
2047     string memory _symbol,
2048     string memory _initBaseURI
2049   ) ERC721A(_name,_symbol) {
2050         setBaseURI(_initBaseURI);
2051      
2052     }
2053   function  communityMint(uint256 _amountPerAddress, address[] calldata addresses) external onlyOwner {
2054      uint256 totalSupply = uint256(totalSupply());
2055      uint totalAmount =   _amountPerAddress * addresses.length;
2056     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
2057      for (uint256 i = 0; i < addresses.length; i++) {
2058             _safeMint(addresses[i], _amountPerAddress);
2059         }
2060 
2061      delete _amountPerAddress;
2062      delete totalSupply;
2063   }
2064 
2065     function  publicMint(uint256 quantity) external payable  {
2066         require(mintEnabled, "Minting is not live yet.");
2067         require(totalSupply() + quantity < maxSupply + 1, "No more");
2068         uint256 cost = price;
2069         uint256 _maxPerWallet = maxPerWallet;
2070         
2071 
2072         if (
2073             totalSupply() < maxFreeAmount &&
2074             _numberMinted(msg.sender) == 0 &&
2075             quantity <= maxFreePerWallet
2076         ) {
2077             cost = 0;
2078             _maxPerWallet = maxFreePerWallet;
2079         }
2080 
2081         require(
2082             _numberMinted(msg.sender) + quantity <= _maxPerWallet,
2083             "Max per wallet"
2084         );
2085 
2086         uint256 needPayCount = quantity;
2087         if (_numberMinted(msg.sender) == 0) {
2088             needPayCount = quantity - 1;
2089         }
2090         require(
2091             msg.value >= needPayCount * cost,
2092             "Please send the exact amount."
2093         );
2094         _safeMint(msg.sender, quantity);
2095     }
2096 
2097     function _baseURI() internal view virtual override returns (string memory) {
2098         return baseURI;
2099     }
2100 
2101     function tokenURI(
2102         uint256 tokenId
2103     ) public view virtual override returns (string memory) {
2104         require(
2105             _exists(tokenId),
2106             "ERC721Metadata: URI query for nonexistent token"
2107         );
2108         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2109     }
2110 
2111     function flipSale() external onlyOwner {
2112         mintEnabled = !mintEnabled;
2113     }
2114 
2115     function setBaseURI(string memory uri) public onlyOwner {
2116         baseURI = uri;
2117     }
2118 
2119     function setPrice(uint256 _newPrice) external onlyOwner {
2120         price = _newPrice;
2121     }
2122 
2123     function setMaxFreeAmount(uint256 _amount) external onlyOwner {
2124         maxFreeAmount = _amount;
2125     }
2126 
2127     function setMaxFreePerWallet(uint256 _amount) external onlyOwner {
2128         maxFreePerWallet = _amount;
2129     }
2130 
2131     function withdraw() external onlyOwner {
2132         (bool success, ) = payable(msg.sender).call{
2133             value: address(this).balance
2134         }("");
2135         require(success, "Transfer failed.");
2136     }
2137 }