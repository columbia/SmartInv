1 // File: @openzeppelin/contracts/utils/Base64.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides a set of functions to operate with Base64 strings.
10  *
11  * _Available since v4.5._
12  */
13 library Base64 {
14     /**
15      * @dev Base64 Encoding/Decoding Table
16      */
17     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
18 
19     /**
20      * @dev Converts a `bytes` to its Bytes64 `string` representation.
21      */
22     function encode(bytes memory data) internal pure returns (string memory) {
23         /**
24          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
25          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
26          */
27         if (data.length == 0) return "";
28 
29         // Loads the table into memory
30         string memory table = _TABLE;
31 
32         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
33         // and split into 4 numbers of 6 bits.
34         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
35         // - `data.length + 2`  -> Round up
36         // - `/ 3`              -> Number of 3-bytes chunks
37         // - `4 *`              -> 4 characters for each chunk
38         string memory result = new string(4 * ((data.length + 2) / 3));
39 
40         /// @solidity memory-safe-assembly
41         assembly {
42             // Prepare the lookup table (skip the first "length" byte)
43             let tablePtr := add(table, 1)
44 
45             // Prepare result pointer, jump over length
46             let resultPtr := add(result, 32)
47 
48             // Run over the input, 3 bytes at a time
49             for {
50                 let dataPtr := data
51                 let endPtr := add(data, mload(data))
52             } lt(dataPtr, endPtr) {
53 
54             } {
55                 // Advance 3 bytes
56                 dataPtr := add(dataPtr, 3)
57                 let input := mload(dataPtr)
58 
59                 // To write each character, shift the 3 bytes (18 bits) chunk
60                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
61                 // and apply logical AND with 0x3F which is the number of
62                 // the previous character in the ASCII table prior to the Base64 Table
63                 // The result is then added to the table to get the character to write,
64                 // and finally write it in the result pointer but with a left shift
65                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
66 
67                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
68                 resultPtr := add(resultPtr, 1) // Advance
69 
70                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
71                 resultPtr := add(resultPtr, 1) // Advance
72 
73                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
74                 resultPtr := add(resultPtr, 1) // Advance
75 
76                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
77                 resultPtr := add(resultPtr, 1) // Advance
78             }
79 
80             // When data `bytes` is not exactly 3 bytes long
81             // it is padded with `=` characters at the end
82             switch mod(mload(data), 3)
83             case 1 {
84                 mstore8(sub(resultPtr, 1), 0x3d)
85                 mstore8(sub(resultPtr, 2), 0x3d)
86             }
87             case 2 {
88                 mstore8(sub(resultPtr, 1), 0x3d)
89             }
90         }
91 
92         return result;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/utils/math/Math.sol
97 
98 
99 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Standard math utilities missing in the Solidity language.
105  */
106 library Math {
107     enum Rounding {
108         Down, // Toward negative infinity
109         Up, // Toward infinity
110         Zero // Toward zero
111     }
112 
113     /**
114      * @dev Returns the largest of two numbers.
115      */
116     function max(uint256 a, uint256 b) internal pure returns (uint256) {
117         return a > b ? a : b;
118     }
119 
120     /**
121      * @dev Returns the smallest of two numbers.
122      */
123     function min(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a < b ? a : b;
125     }
126 
127     /**
128      * @dev Returns the average of two numbers. The result is rounded towards
129      * zero.
130      */
131     function average(uint256 a, uint256 b) internal pure returns (uint256) {
132         // (a + b) / 2 can overflow.
133         return (a & b) + (a ^ b) / 2;
134     }
135 
136     /**
137      * @dev Returns the ceiling of the division of two numbers.
138      *
139      * This differs from standard division with `/` in that it rounds up instead
140      * of rounding down.
141      */
142     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
143         // (a + b - 1) / b can overflow on addition, so we distribute.
144         return a == 0 ? 0 : (a - 1) / b + 1;
145     }
146 
147     /**
148      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
149      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
150      * with further edits by Uniswap Labs also under MIT license.
151      */
152     function mulDiv(
153         uint256 x,
154         uint256 y,
155         uint256 denominator
156     ) internal pure returns (uint256 result) {
157         unchecked {
158             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
159             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
160             // variables such that product = prod1 * 2^256 + prod0.
161             uint256 prod0; // Least significant 256 bits of the product
162             uint256 prod1; // Most significant 256 bits of the product
163             assembly {
164                 let mm := mulmod(x, y, not(0))
165                 prod0 := mul(x, y)
166                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
167             }
168 
169             // Handle non-overflow cases, 256 by 256 division.
170             if (prod1 == 0) {
171                 return prod0 / denominator;
172             }
173 
174             // Make sure the result is less than 2^256. Also prevents denominator == 0.
175             require(denominator > prod1);
176 
177             ///////////////////////////////////////////////
178             // 512 by 256 division.
179             ///////////////////////////////////////////////
180 
181             // Make division exact by subtracting the remainder from [prod1 prod0].
182             uint256 remainder;
183             assembly {
184                 // Compute remainder using mulmod.
185                 remainder := mulmod(x, y, denominator)
186 
187                 // Subtract 256 bit number from 512 bit number.
188                 prod1 := sub(prod1, gt(remainder, prod0))
189                 prod0 := sub(prod0, remainder)
190             }
191 
192             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
193             // See https://cs.stackexchange.com/q/138556/92363.
194 
195             // Does not overflow because the denominator cannot be zero at this stage in the function.
196             uint256 twos = denominator & (~denominator + 1);
197             assembly {
198                 // Divide denominator by twos.
199                 denominator := div(denominator, twos)
200 
201                 // Divide [prod1 prod0] by twos.
202                 prod0 := div(prod0, twos)
203 
204                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
205                 twos := add(div(sub(0, twos), twos), 1)
206             }
207 
208             // Shift in bits from prod1 into prod0.
209             prod0 |= prod1 * twos;
210 
211             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
212             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
213             // four bits. That is, denominator * inv = 1 mod 2^4.
214             uint256 inverse = (3 * denominator) ^ 2;
215 
216             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
217             // in modular arithmetic, doubling the correct bits in each step.
218             inverse *= 2 - denominator * inverse; // inverse mod 2^8
219             inverse *= 2 - denominator * inverse; // inverse mod 2^16
220             inverse *= 2 - denominator * inverse; // inverse mod 2^32
221             inverse *= 2 - denominator * inverse; // inverse mod 2^64
222             inverse *= 2 - denominator * inverse; // inverse mod 2^128
223             inverse *= 2 - denominator * inverse; // inverse mod 2^256
224 
225             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
226             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
227             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
228             // is no longer required.
229             result = prod0 * inverse;
230             return result;
231         }
232     }
233 
234     /**
235      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
236      */
237     function mulDiv(
238         uint256 x,
239         uint256 y,
240         uint256 denominator,
241         Rounding rounding
242     ) internal pure returns (uint256) {
243         uint256 result = mulDiv(x, y, denominator);
244         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
245             result += 1;
246         }
247         return result;
248     }
249 
250     /**
251      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
252      *
253      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
254      */
255     function sqrt(uint256 a) internal pure returns (uint256) {
256         if (a == 0) {
257             return 0;
258         }
259 
260         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
261         //
262         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
263         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
264         //
265         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
266         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
267         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
268         //
269         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
270         uint256 result = 1 << (log2(a) >> 1);
271 
272         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
273         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
274         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
275         // into the expected uint128 result.
276         unchecked {
277             result = (result + a / result) >> 1;
278             result = (result + a / result) >> 1;
279             result = (result + a / result) >> 1;
280             result = (result + a / result) >> 1;
281             result = (result + a / result) >> 1;
282             result = (result + a / result) >> 1;
283             result = (result + a / result) >> 1;
284             return min(result, a / result);
285         }
286     }
287 
288     /**
289      * @notice Calculates sqrt(a), following the selected rounding direction.
290      */
291     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
292         unchecked {
293             uint256 result = sqrt(a);
294             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
295         }
296     }
297 
298     /**
299      * @dev Return the log in base 2, rounded down, of a positive value.
300      * Returns 0 if given 0.
301      */
302     function log2(uint256 value) internal pure returns (uint256) {
303         uint256 result = 0;
304         unchecked {
305             if (value >> 128 > 0) {
306                 value >>= 128;
307                 result += 128;
308             }
309             if (value >> 64 > 0) {
310                 value >>= 64;
311                 result += 64;
312             }
313             if (value >> 32 > 0) {
314                 value >>= 32;
315                 result += 32;
316             }
317             if (value >> 16 > 0) {
318                 value >>= 16;
319                 result += 16;
320             }
321             if (value >> 8 > 0) {
322                 value >>= 8;
323                 result += 8;
324             }
325             if (value >> 4 > 0) {
326                 value >>= 4;
327                 result += 4;
328             }
329             if (value >> 2 > 0) {
330                 value >>= 2;
331                 result += 2;
332             }
333             if (value >> 1 > 0) {
334                 result += 1;
335             }
336         }
337         return result;
338     }
339 
340     /**
341      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
342      * Returns 0 if given 0.
343      */
344     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
345         unchecked {
346             uint256 result = log2(value);
347             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
348         }
349     }
350 
351     /**
352      * @dev Return the log in base 10, rounded down, of a positive value.
353      * Returns 0 if given 0.
354      */
355     function log10(uint256 value) internal pure returns (uint256) {
356         uint256 result = 0;
357         unchecked {
358             if (value >= 10**64) {
359                 value /= 10**64;
360                 result += 64;
361             }
362             if (value >= 10**32) {
363                 value /= 10**32;
364                 result += 32;
365             }
366             if (value >= 10**16) {
367                 value /= 10**16;
368                 result += 16;
369             }
370             if (value >= 10**8) {
371                 value /= 10**8;
372                 result += 8;
373             }
374             if (value >= 10**4) {
375                 value /= 10**4;
376                 result += 4;
377             }
378             if (value >= 10**2) {
379                 value /= 10**2;
380                 result += 2;
381             }
382             if (value >= 10**1) {
383                 result += 1;
384             }
385         }
386         return result;
387     }
388 
389     /**
390      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
391      * Returns 0 if given 0.
392      */
393     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
394         unchecked {
395             uint256 result = log10(value);
396             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
397         }
398     }
399 
400     /**
401      * @dev Return the log in base 256, rounded down, of a positive value.
402      * Returns 0 if given 0.
403      *
404      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
405      */
406     function log256(uint256 value) internal pure returns (uint256) {
407         uint256 result = 0;
408         unchecked {
409             if (value >> 128 > 0) {
410                 value >>= 128;
411                 result += 16;
412             }
413             if (value >> 64 > 0) {
414                 value >>= 64;
415                 result += 8;
416             }
417             if (value >> 32 > 0) {
418                 value >>= 32;
419                 result += 4;
420             }
421             if (value >> 16 > 0) {
422                 value >>= 16;
423                 result += 2;
424             }
425             if (value >> 8 > 0) {
426                 result += 1;
427             }
428         }
429         return result;
430     }
431 
432     /**
433      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
434      * Returns 0 if given 0.
435      */
436     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
437         unchecked {
438             uint256 result = log256(value);
439             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
440         }
441     }
442 }
443 
444 // File: @openzeppelin/contracts/utils/Strings.sol
445 
446 
447 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
448 
449 pragma solidity ^0.8.0;
450 
451 
452 /**
453  * @dev String operations.
454  */
455 library Strings {
456     bytes16 private constant _SYMBOLS = "0123456789abcdef";
457     uint8 private constant _ADDRESS_LENGTH = 20;
458 
459     /**
460      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
461      */
462     function toString(uint256 value) internal pure returns (string memory) {
463         unchecked {
464             uint256 length = Math.log10(value) + 1;
465             string memory buffer = new string(length);
466             uint256 ptr;
467             /// @solidity memory-safe-assembly
468             assembly {
469                 ptr := add(buffer, add(32, length))
470             }
471             while (true) {
472                 ptr--;
473                 /// @solidity memory-safe-assembly
474                 assembly {
475                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
476                 }
477                 value /= 10;
478                 if (value == 0) break;
479             }
480             return buffer;
481         }
482     }
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
486      */
487     function toHexString(uint256 value) internal pure returns (string memory) {
488         unchecked {
489             return toHexString(value, Math.log256(value) + 1);
490         }
491     }
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
495      */
496     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
497         bytes memory buffer = new bytes(2 * length + 2);
498         buffer[0] = "0";
499         buffer[1] = "x";
500         for (uint256 i = 2 * length + 1; i > 1; --i) {
501             buffer[i] = _SYMBOLS[value & 0xf];
502             value >>= 4;
503         }
504         require(value == 0, "Strings: hex length insufficient");
505         return string(buffer);
506     }
507 
508     /**
509      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
510      */
511     function toHexString(address addr) internal pure returns (string memory) {
512         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
513     }
514 }
515 
516 // File: @openzeppelin/contracts/utils/Context.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev Provides information about the current execution context, including the
525  * sender of the transaction and its data. While these are generally available
526  * via msg.sender and msg.data, they should not be accessed in such a direct
527  * manner, since when dealing with meta-transactions the account sending and
528  * paying for execution may not be the actual sender (as far as an application
529  * is concerned).
530  *
531  * This contract is only required for intermediate, library-like contracts.
532  */
533 abstract contract Context {
534     function _msgSender() internal view virtual returns (address) {
535         return msg.sender;
536     }
537 
538     function _msgData() internal view virtual returns (bytes calldata) {
539         return msg.data;
540     }
541 }
542 
543 // File: @openzeppelin/contracts/access/Ownable.sol
544 
545 
546 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Contract module which provides a basic access control mechanism, where
553  * there is an account (an owner) that can be granted exclusive access to
554  * specific functions.
555  *
556  * By default, the owner account will be the one that deploys the contract. This
557  * can later be changed with {transferOwnership}.
558  *
559  * This module is used through inheritance. It will make available the modifier
560  * `onlyOwner`, which can be applied to your functions to restrict their use to
561  * the owner.
562  */
563 abstract contract Ownable is Context {
564     address private _owner;
565 
566     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
567 
568     /**
569      * @dev Initializes the contract setting the deployer as the initial owner.
570      */
571     constructor() {
572         _transferOwnership(_msgSender());
573     }
574 
575     /**
576      * @dev Throws if called by any account other than the owner.
577      */
578     modifier onlyOwner() {
579         _checkOwner();
580         _;
581     }
582 
583     /**
584      * @dev Returns the address of the current owner.
585      */
586     function owner() public view virtual returns (address) {
587         return _owner;
588     }
589 
590     /**
591      * @dev Throws if the sender is not the owner.
592      */
593     function _checkOwner() internal view virtual {
594         require(owner() == _msgSender(), "Ownable: caller is not the owner");
595     }
596 
597     /**
598      * @dev Leaves the contract without owner. It will not be possible to call
599      * `onlyOwner` functions anymore. Can only be called by the current owner.
600      *
601      * NOTE: Renouncing ownership will leave the contract without an owner,
602      * thereby removing any functionality that is only available to the owner.
603      */
604     function renounceOwnership() public virtual onlyOwner {
605         _transferOwnership(address(0));
606     }
607 
608     /**
609      * @dev Transfers ownership of the contract to a new account (`newOwner`).
610      * Can only be called by the current owner.
611      */
612     function transferOwnership(address newOwner) public virtual onlyOwner {
613         require(newOwner != address(0), "Ownable: new owner is the zero address");
614         _transferOwnership(newOwner);
615     }
616 
617     /**
618      * @dev Transfers ownership of the contract to a new account (`newOwner`).
619      * Internal function without access restriction.
620      */
621     function _transferOwnership(address newOwner) internal virtual {
622         address oldOwner = _owner;
623         _owner = newOwner;
624         emit OwnershipTransferred(oldOwner, newOwner);
625     }
626 }
627 
628 // File: erc721a/contracts/IERC721A.sol
629 
630 
631 // ERC721A Contracts v4.2.3
632 // Creator: Chiru Labs
633 
634 pragma solidity ^0.8.4;
635 
636 /**
637  * @dev Interface of ERC721A.
638  */
639 interface IERC721A {
640     /**
641      * The caller must own the token or be an approved operator.
642      */
643     error ApprovalCallerNotOwnerNorApproved();
644 
645     /**
646      * The token does not exist.
647      */
648     error ApprovalQueryForNonexistentToken();
649 
650     /**
651      * Cannot query the balance for the zero address.
652      */
653     error BalanceQueryForZeroAddress();
654 
655     /**
656      * Cannot mint to the zero address.
657      */
658     error MintToZeroAddress();
659 
660     /**
661      * The quantity of tokens minted must be more than zero.
662      */
663     error MintZeroQuantity();
664 
665     /**
666      * The token does not exist.
667      */
668     error OwnerQueryForNonexistentToken();
669 
670     /**
671      * The caller must own the token or be an approved operator.
672      */
673     error TransferCallerNotOwnerNorApproved();
674 
675     /**
676      * The token must be owned by `from`.
677      */
678     error TransferFromIncorrectOwner();
679 
680     /**
681      * Cannot safely transfer to a contract that does not implement the
682      * ERC721Receiver interface.
683      */
684     error TransferToNonERC721ReceiverImplementer();
685 
686     /**
687      * Cannot transfer to the zero address.
688      */
689     error TransferToZeroAddress();
690 
691     /**
692      * The token does not exist.
693      */
694     error URIQueryForNonexistentToken();
695 
696     /**
697      * The `quantity` minted with ERC2309 exceeds the safety limit.
698      */
699     error MintERC2309QuantityExceedsLimit();
700 
701     /**
702      * The `extraData` cannot be set on an unintialized ownership slot.
703      */
704     error OwnershipNotInitializedForExtraData();
705 
706     // =============================================================
707     //                            STRUCTS
708     // =============================================================
709 
710     struct TokenOwnership {
711         // The address of the owner.
712         address addr;
713         // Stores the start time of ownership with minimal overhead for tokenomics.
714         uint64 startTimestamp;
715         // Whether the token has been burned.
716         bool burned;
717         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
718         uint24 extraData;
719     }
720 
721     // =============================================================
722     //                         TOKEN COUNTERS
723     // =============================================================
724 
725     /**
726      * @dev Returns the total number of tokens in existence.
727      * Burned tokens will reduce the count.
728      * To get the total number of tokens minted, please see {_totalMinted}.
729      */
730     function totalSupply() external view returns (uint256);
731 
732     // =============================================================
733     //                            IERC165
734     // =============================================================
735 
736     /**
737      * @dev Returns true if this contract implements the interface defined by
738      * `interfaceId`. See the corresponding
739      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
740      * to learn more about how these ids are created.
741      *
742      * This function call must use less than 30000 gas.
743      */
744     function supportsInterface(bytes4 interfaceId) external view returns (bool);
745 
746     // =============================================================
747     //                            IERC721
748     // =============================================================
749 
750     /**
751      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
752      */
753     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
754 
755     /**
756      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
757      */
758     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
759 
760     /**
761      * @dev Emitted when `owner` enables or disables
762      * (`approved`) `operator` to manage all of its assets.
763      */
764     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
765 
766     /**
767      * @dev Returns the number of tokens in `owner`'s account.
768      */
769     function balanceOf(address owner) external view returns (uint256 balance);
770 
771     /**
772      * @dev Returns the owner of the `tokenId` token.
773      *
774      * Requirements:
775      *
776      * - `tokenId` must exist.
777      */
778     function ownerOf(uint256 tokenId) external view returns (address owner);
779 
780     /**
781      * @dev Safely transfers `tokenId` token from `from` to `to`,
782      * checking first that contract recipients are aware of the ERC721 protocol
783      * to prevent tokens from being forever locked.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If the caller is not `from`, it must be have been allowed to move
791      * this token by either {approve} or {setApprovalForAll}.
792      * - If `to` refers to a smart contract, it must implement
793      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
794      *
795      * Emits a {Transfer} event.
796      */
797     function safeTransferFrom(
798         address from,
799         address to,
800         uint256 tokenId,
801         bytes calldata data
802     ) external payable;
803 
804     /**
805      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
806      */
807     function safeTransferFrom(
808         address from,
809         address to,
810         uint256 tokenId
811     ) external payable;
812 
813     /**
814      * @dev Transfers `tokenId` from `from` to `to`.
815      *
816      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
817      * whenever possible.
818      *
819      * Requirements:
820      *
821      * - `from` cannot be the zero address.
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must be owned by `from`.
824      * - If the caller is not `from`, it must be approved to move this token
825      * by either {approve} or {setApprovalForAll}.
826      *
827      * Emits a {Transfer} event.
828      */
829     function transferFrom(
830         address from,
831         address to,
832         uint256 tokenId
833     ) external payable;
834 
835     /**
836      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
837      * The approval is cleared when the token is transferred.
838      *
839      * Only a single account can be approved at a time, so approving the
840      * zero address clears previous approvals.
841      *
842      * Requirements:
843      *
844      * - The caller must own the token or be an approved operator.
845      * - `tokenId` must exist.
846      *
847      * Emits an {Approval} event.
848      */
849     function approve(address to, uint256 tokenId) external payable;
850 
851     /**
852      * @dev Approve or remove `operator` as an operator for the caller.
853      * Operators can call {transferFrom} or {safeTransferFrom}
854      * for any token owned by the caller.
855      *
856      * Requirements:
857      *
858      * - The `operator` cannot be the caller.
859      *
860      * Emits an {ApprovalForAll} event.
861      */
862     function setApprovalForAll(address operator, bool _approved) external;
863 
864     /**
865      * @dev Returns the account approved for `tokenId` token.
866      *
867      * Requirements:
868      *
869      * - `tokenId` must exist.
870      */
871     function getApproved(uint256 tokenId) external view returns (address operator);
872 
873     /**
874      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
875      *
876      * See {setApprovalForAll}.
877      */
878     function isApprovedForAll(address owner, address operator) external view returns (bool);
879 
880     // =============================================================
881     //                        IERC721Metadata
882     // =============================================================
883 
884     /**
885      * @dev Returns the token collection name.
886      */
887     function name() external view returns (string memory);
888 
889     /**
890      * @dev Returns the token collection symbol.
891      */
892     function symbol() external view returns (string memory);
893 
894     /**
895      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
896      */
897     function tokenURI(uint256 tokenId) external view returns (string memory);
898 
899     // =============================================================
900     //                           IERC2309
901     // =============================================================
902 
903     /**
904      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
905      * (inclusive) is transferred from `from` to `to`, as defined in the
906      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
907      *
908      * See {_mintERC2309} for more details.
909      */
910     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
911 }
912 
913 // File: erc721a/contracts/ERC721A.sol
914 
915 
916 // ERC721A Contracts v4.2.3
917 // Creator: Chiru Labs
918 
919 pragma solidity ^0.8.4;
920 
921 
922 /**
923  * @dev Interface of ERC721 token receiver.
924  */
925 interface ERC721A__IERC721Receiver {
926     function onERC721Received(
927         address operator,
928         address from,
929         uint256 tokenId,
930         bytes calldata data
931     ) external returns (bytes4);
932 }
933 
934 /**
935  * @title ERC721A
936  *
937  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
938  * Non-Fungible Token Standard, including the Metadata extension.
939  * Optimized for lower gas during batch mints.
940  *
941  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
942  * starting from `_startTokenId()`.
943  *
944  * Assumptions:
945  *
946  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
947  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
948  */
949 contract ERC721A is IERC721A {
950     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
951     struct TokenApprovalRef {
952         address value;
953     }
954 
955     // =============================================================
956     //                           CONSTANTS
957     // =============================================================
958 
959     // Mask of an entry in packed address data.
960     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
961 
962     // The bit position of `numberMinted` in packed address data.
963     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
964 
965     // The bit position of `numberBurned` in packed address data.
966     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
967 
968     // The bit position of `aux` in packed address data.
969     uint256 private constant _BITPOS_AUX = 192;
970 
971     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
972     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
973 
974     // The bit position of `startTimestamp` in packed ownership.
975     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
976 
977     // The bit mask of the `burned` bit in packed ownership.
978     uint256 private constant _BITMASK_BURNED = 1 << 224;
979 
980     // The bit position of the `nextInitialized` bit in packed ownership.
981     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
982 
983     // The bit mask of the `nextInitialized` bit in packed ownership.
984     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
985 
986     // The bit position of `extraData` in packed ownership.
987     uint256 private constant _BITPOS_EXTRA_DATA = 232;
988 
989     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
990     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
991 
992     // The mask of the lower 160 bits for addresses.
993     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
994 
995     // The maximum `quantity` that can be minted with {_mintERC2309}.
996     // This limit is to prevent overflows on the address data entries.
997     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
998     // is required to cause an overflow, which is unrealistic.
999     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1000 
1001     // The `Transfer` event signature is given by:
1002     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1003     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1004         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1005 
1006     // =============================================================
1007     //                            STORAGE
1008     // =============================================================
1009 
1010     // The next token ID to be minted.
1011     uint256 private _currentIndex;
1012 
1013     // The number of tokens burned.
1014     uint256 private _burnCounter;
1015 
1016     // Token name
1017     string private _name;
1018 
1019     // Token symbol
1020     string private _symbol;
1021 
1022     // Mapping from token ID to ownership details
1023     // An empty struct value does not necessarily mean the token is unowned.
1024     // See {_packedOwnershipOf} implementation for details.
1025     //
1026     // Bits Layout:
1027     // - [0..159]   `addr`
1028     // - [160..223] `startTimestamp`
1029     // - [224]      `burned`
1030     // - [225]      `nextInitialized`
1031     // - [232..255] `extraData`
1032     mapping(uint256 => uint256) private _packedOwnerships;
1033 
1034     // Mapping owner address to address data.
1035     //
1036     // Bits Layout:
1037     // - [0..63]    `balance`
1038     // - [64..127]  `numberMinted`
1039     // - [128..191] `numberBurned`
1040     // - [192..255] `aux`
1041     mapping(address => uint256) private _packedAddressData;
1042 
1043     // Mapping from token ID to approved address.
1044     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1045 
1046     // Mapping from owner to operator approvals
1047     mapping(address => mapping(address => bool)) private _operatorApprovals;
1048 
1049     // =============================================================
1050     //                          CONSTRUCTOR
1051     // =============================================================
1052 
1053     constructor(string memory name_, string memory symbol_) {
1054         _name = name_;
1055         _symbol = symbol_;
1056         _currentIndex = _startTokenId();
1057     }
1058 
1059     // =============================================================
1060     //                   TOKEN COUNTING OPERATIONS
1061     // =============================================================
1062 
1063     /**
1064      * @dev Returns the starting token ID.
1065      * To change the starting token ID, please override this function.
1066      */
1067     function _startTokenId() internal view virtual returns (uint256) {
1068         return 0;
1069     }
1070 
1071     /**
1072      * @dev Returns the next token ID to be minted.
1073      */
1074     function _nextTokenId() internal view virtual returns (uint256) {
1075         return _currentIndex;
1076     }
1077 
1078     /**
1079      * @dev Returns the total number of tokens in existence.
1080      * Burned tokens will reduce the count.
1081      * To get the total number of tokens minted, please see {_totalMinted}.
1082      */
1083     function totalSupply() public view virtual override returns (uint256) {
1084         // Counter underflow is impossible as _burnCounter cannot be incremented
1085         // more than `_currentIndex - _startTokenId()` times.
1086         unchecked {
1087             return _currentIndex - _burnCounter - _startTokenId();
1088         }
1089     }
1090 
1091     /**
1092      * @dev Returns the total amount of tokens minted in the contract.
1093      */
1094     function _totalMinted() internal view virtual returns (uint256) {
1095         // Counter underflow is impossible as `_currentIndex` does not decrement,
1096         // and it is initialized to `_startTokenId()`.
1097         unchecked {
1098             return _currentIndex - _startTokenId();
1099         }
1100     }
1101 
1102     /**
1103      * @dev Returns the total number of tokens burned.
1104      */
1105     function _totalBurned() internal view virtual returns (uint256) {
1106         return _burnCounter;
1107     }
1108 
1109     // =============================================================
1110     //                    ADDRESS DATA OPERATIONS
1111     // =============================================================
1112 
1113     /**
1114      * @dev Returns the number of tokens in `owner`'s account.
1115      */
1116     function balanceOf(address owner) public view virtual override returns (uint256) {
1117         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1118         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1119     }
1120 
1121     /**
1122      * Returns the number of tokens minted by `owner`.
1123      */
1124     function _numberMinted(address owner) internal view returns (uint256) {
1125         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1126     }
1127 
1128     /**
1129      * Returns the number of tokens burned by or on behalf of `owner`.
1130      */
1131     function _numberBurned(address owner) internal view returns (uint256) {
1132         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1133     }
1134 
1135     /**
1136      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1137      */
1138     function _getAux(address owner) internal view returns (uint64) {
1139         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1140     }
1141 
1142     /**
1143      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1144      * If there are multiple variables, please pack them into a uint64.
1145      */
1146     function _setAux(address owner, uint64 aux) internal virtual {
1147         uint256 packed = _packedAddressData[owner];
1148         uint256 auxCasted;
1149         // Cast `aux` with assembly to avoid redundant masking.
1150         assembly {
1151             auxCasted := aux
1152         }
1153         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1154         _packedAddressData[owner] = packed;
1155     }
1156 
1157     // =============================================================
1158     //                            IERC165
1159     // =============================================================
1160 
1161     /**
1162      * @dev Returns true if this contract implements the interface defined by
1163      * `interfaceId`. See the corresponding
1164      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1165      * to learn more about how these ids are created.
1166      *
1167      * This function call must use less than 30000 gas.
1168      */
1169     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1170         // The interface IDs are constants representing the first 4 bytes
1171         // of the XOR of all function selectors in the interface.
1172         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1173         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1174         return
1175             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1176             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1177             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1178     }
1179 
1180     // =============================================================
1181     //                        IERC721Metadata
1182     // =============================================================
1183 
1184     /**
1185      * @dev Returns the token collection name.
1186      */
1187     function name() public view virtual override returns (string memory) {
1188         return _name;
1189     }
1190 
1191     /**
1192      * @dev Returns the token collection symbol.
1193      */
1194     function symbol() public view virtual override returns (string memory) {
1195         return _symbol;
1196     }
1197 
1198     /**
1199      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1200      */
1201     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1202         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1203 
1204         string memory baseURI = _baseURI();
1205         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1206     }
1207 
1208     /**
1209      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1210      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1211      * by default, it can be overridden in child contracts.
1212      */
1213     function _baseURI() internal view virtual returns (string memory) {
1214         return '';
1215     }
1216 
1217     // =============================================================
1218     //                     OWNERSHIPS OPERATIONS
1219     // =============================================================
1220 
1221     /**
1222      * @dev Returns the owner of the `tokenId` token.
1223      *
1224      * Requirements:
1225      *
1226      * - `tokenId` must exist.
1227      */
1228     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1229         return address(uint160(_packedOwnershipOf(tokenId)));
1230     }
1231 
1232     /**
1233      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1234      * It gradually moves to O(1) as tokens get transferred around over time.
1235      */
1236     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1237         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1238     }
1239 
1240     /**
1241      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1242      */
1243     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1244         return _unpackedOwnership(_packedOwnerships[index]);
1245     }
1246 
1247     /**
1248      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1249      */
1250     function _initializeOwnershipAt(uint256 index) internal virtual {
1251         if (_packedOwnerships[index] == 0) {
1252             _packedOwnerships[index] = _packedOwnershipOf(index);
1253         }
1254     }
1255 
1256     /**
1257      * Returns the packed ownership data of `tokenId`.
1258      */
1259     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1260         uint256 curr = tokenId;
1261 
1262         unchecked {
1263             if (_startTokenId() <= curr)
1264                 if (curr < _currentIndex) {
1265                     uint256 packed = _packedOwnerships[curr];
1266                     // If not burned.
1267                     if (packed & _BITMASK_BURNED == 0) {
1268                         // Invariant:
1269                         // There will always be an initialized ownership slot
1270                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1271                         // before an unintialized ownership slot
1272                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1273                         // Hence, `curr` will not underflow.
1274                         //
1275                         // We can directly compare the packed value.
1276                         // If the address is zero, packed will be zero.
1277                         while (packed == 0) {
1278                             packed = _packedOwnerships[--curr];
1279                         }
1280                         return packed;
1281                     }
1282                 }
1283         }
1284         revert OwnerQueryForNonexistentToken();
1285     }
1286 
1287     /**
1288      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1289      */
1290     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1291         ownership.addr = address(uint160(packed));
1292         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1293         ownership.burned = packed & _BITMASK_BURNED != 0;
1294         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1295     }
1296 
1297     /**
1298      * @dev Packs ownership data into a single uint256.
1299      */
1300     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1301         assembly {
1302             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1303             owner := and(owner, _BITMASK_ADDRESS)
1304             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1305             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1306         }
1307     }
1308 
1309     /**
1310      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1311      */
1312     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1313         // For branchless setting of the `nextInitialized` flag.
1314         assembly {
1315             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1316             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1317         }
1318     }
1319 
1320     // =============================================================
1321     //                      APPROVAL OPERATIONS
1322     // =============================================================
1323 
1324     /**
1325      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1326      * The approval is cleared when the token is transferred.
1327      *
1328      * Only a single account can be approved at a time, so approving the
1329      * zero address clears previous approvals.
1330      *
1331      * Requirements:
1332      *
1333      * - The caller must own the token or be an approved operator.
1334      * - `tokenId` must exist.
1335      *
1336      * Emits an {Approval} event.
1337      */
1338     function approve(address to, uint256 tokenId) public payable virtual override {
1339         address owner = ownerOf(tokenId);
1340 
1341         if (_msgSenderERC721A() != owner)
1342             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1343                 revert ApprovalCallerNotOwnerNorApproved();
1344             }
1345 
1346         _tokenApprovals[tokenId].value = to;
1347         emit Approval(owner, to, tokenId);
1348     }
1349 
1350     /**
1351      * @dev Returns the account approved for `tokenId` token.
1352      *
1353      * Requirements:
1354      *
1355      * - `tokenId` must exist.
1356      */
1357     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1358         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1359 
1360         return _tokenApprovals[tokenId].value;
1361     }
1362 
1363     /**
1364      * @dev Approve or remove `operator` as an operator for the caller.
1365      * Operators can call {transferFrom} or {safeTransferFrom}
1366      * for any token owned by the caller.
1367      *
1368      * Requirements:
1369      *
1370      * - The `operator` cannot be the caller.
1371      *
1372      * Emits an {ApprovalForAll} event.
1373      */
1374     function setApprovalForAll(address operator, bool approved) public virtual override {
1375         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1376         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1377     }
1378 
1379     /**
1380      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1381      *
1382      * See {setApprovalForAll}.
1383      */
1384     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1385         return _operatorApprovals[owner][operator];
1386     }
1387 
1388     /**
1389      * @dev Returns whether `tokenId` exists.
1390      *
1391      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1392      *
1393      * Tokens start existing when they are minted. See {_mint}.
1394      */
1395     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1396         return
1397             _startTokenId() <= tokenId &&
1398             tokenId < _currentIndex && // If within bounds,
1399             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1400     }
1401 
1402     /**
1403      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1404      */
1405     function _isSenderApprovedOrOwner(
1406         address approvedAddress,
1407         address owner,
1408         address msgSender
1409     ) private pure returns (bool result) {
1410         assembly {
1411             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1412             owner := and(owner, _BITMASK_ADDRESS)
1413             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1414             msgSender := and(msgSender, _BITMASK_ADDRESS)
1415             // `msgSender == owner || msgSender == approvedAddress`.
1416             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1417         }
1418     }
1419 
1420     /**
1421      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1422      */
1423     function _getApprovedSlotAndAddress(uint256 tokenId)
1424         private
1425         view
1426         returns (uint256 approvedAddressSlot, address approvedAddress)
1427     {
1428         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1429         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1430         assembly {
1431             approvedAddressSlot := tokenApproval.slot
1432             approvedAddress := sload(approvedAddressSlot)
1433         }
1434     }
1435 
1436     // =============================================================
1437     //                      TRANSFER OPERATIONS
1438     // =============================================================
1439 
1440     /**
1441      * @dev Transfers `tokenId` from `from` to `to`.
1442      *
1443      * Requirements:
1444      *
1445      * - `from` cannot be the zero address.
1446      * - `to` cannot be the zero address.
1447      * - `tokenId` token must be owned by `from`.
1448      * - If the caller is not `from`, it must be approved to move this token
1449      * by either {approve} or {setApprovalForAll}.
1450      *
1451      * Emits a {Transfer} event.
1452      */
1453     function transferFrom(
1454         address from,
1455         address to,
1456         uint256 tokenId
1457     ) public payable virtual override {
1458         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1459 
1460         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1461 
1462         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1463 
1464         // The nested ifs save around 20+ gas over a compound boolean condition.
1465         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1466             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1467 
1468         if (to == address(0)) revert TransferToZeroAddress();
1469 
1470         _beforeTokenTransfers(from, to, tokenId, 1);
1471 
1472         // Clear approvals from the previous owner.
1473         assembly {
1474             if approvedAddress {
1475                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1476                 sstore(approvedAddressSlot, 0)
1477             }
1478         }
1479 
1480         // Underflow of the sender's balance is impossible because we check for
1481         // ownership above and the recipient's balance can't realistically overflow.
1482         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1483         unchecked {
1484             // We can directly increment and decrement the balances.
1485             --_packedAddressData[from]; // Updates: `balance -= 1`.
1486             ++_packedAddressData[to]; // Updates: `balance += 1`.
1487 
1488             // Updates:
1489             // - `address` to the next owner.
1490             // - `startTimestamp` to the timestamp of transfering.
1491             // - `burned` to `false`.
1492             // - `nextInitialized` to `true`.
1493             _packedOwnerships[tokenId] = _packOwnershipData(
1494                 to,
1495                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1496             );
1497 
1498             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1499             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1500                 uint256 nextTokenId = tokenId + 1;
1501                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1502                 if (_packedOwnerships[nextTokenId] == 0) {
1503                     // If the next slot is within bounds.
1504                     if (nextTokenId != _currentIndex) {
1505                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1506                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1507                     }
1508                 }
1509             }
1510         }
1511 
1512         emit Transfer(from, to, tokenId);
1513         _afterTokenTransfers(from, to, tokenId, 1);
1514     }
1515 
1516     /**
1517      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1518      */
1519     function safeTransferFrom(
1520         address from,
1521         address to,
1522         uint256 tokenId
1523     ) public payable virtual override {
1524         safeTransferFrom(from, to, tokenId, '');
1525     }
1526 
1527     /**
1528      * @dev Safely transfers `tokenId` token from `from` to `to`.
1529      *
1530      * Requirements:
1531      *
1532      * - `from` cannot be the zero address.
1533      * - `to` cannot be the zero address.
1534      * - `tokenId` token must exist and be owned by `from`.
1535      * - If the caller is not `from`, it must be approved to move this token
1536      * by either {approve} or {setApprovalForAll}.
1537      * - If `to` refers to a smart contract, it must implement
1538      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function safeTransferFrom(
1543         address from,
1544         address to,
1545         uint256 tokenId,
1546         bytes memory _data
1547     ) public payable virtual override {
1548         transferFrom(from, to, tokenId);
1549         if (to.code.length != 0)
1550             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1551                 revert TransferToNonERC721ReceiverImplementer();
1552             }
1553     }
1554 
1555     /**
1556      * @dev Hook that is called before a set of serially-ordered token IDs
1557      * are about to be transferred. This includes minting.
1558      * And also called before burning one token.
1559      *
1560      * `startTokenId` - the first token ID to be transferred.
1561      * `quantity` - the amount to be transferred.
1562      *
1563      * Calling conditions:
1564      *
1565      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1566      * transferred to `to`.
1567      * - When `from` is zero, `tokenId` will be minted for `to`.
1568      * - When `to` is zero, `tokenId` will be burned by `from`.
1569      * - `from` and `to` are never both zero.
1570      */
1571     function _beforeTokenTransfers(
1572         address from,
1573         address to,
1574         uint256 startTokenId,
1575         uint256 quantity
1576     ) internal virtual {}
1577 
1578     /**
1579      * @dev Hook that is called after a set of serially-ordered token IDs
1580      * have been transferred. This includes minting.
1581      * And also called after one token has been burned.
1582      *
1583      * `startTokenId` - the first token ID to be transferred.
1584      * `quantity` - the amount to be transferred.
1585      *
1586      * Calling conditions:
1587      *
1588      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1589      * transferred to `to`.
1590      * - When `from` is zero, `tokenId` has been minted for `to`.
1591      * - When `to` is zero, `tokenId` has been burned by `from`.
1592      * - `from` and `to` are never both zero.
1593      */
1594     function _afterTokenTransfers(
1595         address from,
1596         address to,
1597         uint256 startTokenId,
1598         uint256 quantity
1599     ) internal virtual {}
1600 
1601     /**
1602      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1603      *
1604      * `from` - Previous owner of the given token ID.
1605      * `to` - Target address that will receive the token.
1606      * `tokenId` - Token ID to be transferred.
1607      * `_data` - Optional data to send along with the call.
1608      *
1609      * Returns whether the call correctly returned the expected magic value.
1610      */
1611     function _checkContractOnERC721Received(
1612         address from,
1613         address to,
1614         uint256 tokenId,
1615         bytes memory _data
1616     ) private returns (bool) {
1617         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1618             bytes4 retval
1619         ) {
1620             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1621         } catch (bytes memory reason) {
1622             if (reason.length == 0) {
1623                 revert TransferToNonERC721ReceiverImplementer();
1624             } else {
1625                 assembly {
1626                     revert(add(32, reason), mload(reason))
1627                 }
1628             }
1629         }
1630     }
1631 
1632     // =============================================================
1633     //                        MINT OPERATIONS
1634     // =============================================================
1635 
1636     /**
1637      * @dev Mints `quantity` tokens and transfers them to `to`.
1638      *
1639      * Requirements:
1640      *
1641      * - `to` cannot be the zero address.
1642      * - `quantity` must be greater than 0.
1643      *
1644      * Emits a {Transfer} event for each mint.
1645      */
1646     function _mint(address to, uint256 quantity) internal virtual {
1647         uint256 startTokenId = _currentIndex;
1648         if (quantity == 0) revert MintZeroQuantity();
1649 
1650         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1651 
1652         // Overflows are incredibly unrealistic.
1653         // `balance` and `numberMinted` have a maximum limit of 2**64.
1654         // `tokenId` has a maximum limit of 2**256.
1655         unchecked {
1656             // Updates:
1657             // - `balance += quantity`.
1658             // - `numberMinted += quantity`.
1659             //
1660             // We can directly add to the `balance` and `numberMinted`.
1661             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1662 
1663             // Updates:
1664             // - `address` to the owner.
1665             // - `startTimestamp` to the timestamp of minting.
1666             // - `burned` to `false`.
1667             // - `nextInitialized` to `quantity == 1`.
1668             _packedOwnerships[startTokenId] = _packOwnershipData(
1669                 to,
1670                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1671             );
1672 
1673             uint256 toMasked;
1674             uint256 end = startTokenId + quantity;
1675 
1676             // Use assembly to loop and emit the `Transfer` event for gas savings.
1677             // The duplicated `log4` removes an extra check and reduces stack juggling.
1678             // The assembly, together with the surrounding Solidity code, have been
1679             // delicately arranged to nudge the compiler into producing optimized opcodes.
1680             assembly {
1681                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1682                 toMasked := and(to, _BITMASK_ADDRESS)
1683                 // Emit the `Transfer` event.
1684                 log4(
1685                     0, // Start of data (0, since no data).
1686                     0, // End of data (0, since no data).
1687                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1688                     0, // `address(0)`.
1689                     toMasked, // `to`.
1690                     startTokenId // `tokenId`.
1691                 )
1692 
1693                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1694                 // that overflows uint256 will make the loop run out of gas.
1695                 // The compiler will optimize the `iszero` away for performance.
1696                 for {
1697                     let tokenId := add(startTokenId, 1)
1698                 } iszero(eq(tokenId, end)) {
1699                     tokenId := add(tokenId, 1)
1700                 } {
1701                     // Emit the `Transfer` event. Similar to above.
1702                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1703                 }
1704             }
1705             if (toMasked == 0) revert MintToZeroAddress();
1706 
1707             _currentIndex = end;
1708         }
1709         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1710     }
1711 
1712     /**
1713      * @dev Mints `quantity` tokens and transfers them to `to`.
1714      *
1715      * This function is intended for efficient minting only during contract creation.
1716      *
1717      * It emits only one {ConsecutiveTransfer} as defined in
1718      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1719      * instead of a sequence of {Transfer} event(s).
1720      *
1721      * Calling this function outside of contract creation WILL make your contract
1722      * non-compliant with the ERC721 standard.
1723      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1724      * {ConsecutiveTransfer} event is only permissible during contract creation.
1725      *
1726      * Requirements:
1727      *
1728      * - `to` cannot be the zero address.
1729      * - `quantity` must be greater than 0.
1730      *
1731      * Emits a {ConsecutiveTransfer} event.
1732      */
1733     function _mintERC2309(address to, uint256 quantity) internal virtual {
1734         uint256 startTokenId = _currentIndex;
1735         if (to == address(0)) revert MintToZeroAddress();
1736         if (quantity == 0) revert MintZeroQuantity();
1737         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1738 
1739         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1740 
1741         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1742         unchecked {
1743             // Updates:
1744             // - `balance += quantity`.
1745             // - `numberMinted += quantity`.
1746             //
1747             // We can directly add to the `balance` and `numberMinted`.
1748             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1749 
1750             // Updates:
1751             // - `address` to the owner.
1752             // - `startTimestamp` to the timestamp of minting.
1753             // - `burned` to `false`.
1754             // - `nextInitialized` to `quantity == 1`.
1755             _packedOwnerships[startTokenId] = _packOwnershipData(
1756                 to,
1757                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1758             );
1759 
1760             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1761 
1762             _currentIndex = startTokenId + quantity;
1763         }
1764         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1765     }
1766 
1767     /**
1768      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1769      *
1770      * Requirements:
1771      *
1772      * - If `to` refers to a smart contract, it must implement
1773      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1774      * - `quantity` must be greater than 0.
1775      *
1776      * See {_mint}.
1777      *
1778      * Emits a {Transfer} event for each mint.
1779      */
1780     function _safeMint(
1781         address to,
1782         uint256 quantity,
1783         bytes memory _data
1784     ) internal virtual {
1785         _mint(to, quantity);
1786 
1787         unchecked {
1788             if (to.code.length != 0) {
1789                 uint256 end = _currentIndex;
1790                 uint256 index = end - quantity;
1791                 do {
1792                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1793                         revert TransferToNonERC721ReceiverImplementer();
1794                     }
1795                 } while (index < end);
1796                 // Reentrancy protection.
1797                 if (_currentIndex != end) revert();
1798             }
1799         }
1800     }
1801 
1802     /**
1803      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1804      */
1805     function _safeMint(address to, uint256 quantity) internal virtual {
1806         _safeMint(to, quantity, '');
1807     }
1808 
1809     // =============================================================
1810     //                        BURN OPERATIONS
1811     // =============================================================
1812 
1813     /**
1814      * @dev Equivalent to `_burn(tokenId, false)`.
1815      */
1816     function _burn(uint256 tokenId) internal virtual {
1817         _burn(tokenId, false);
1818     }
1819 
1820     /**
1821      * @dev Destroys `tokenId`.
1822      * The approval is cleared when the token is burned.
1823      *
1824      * Requirements:
1825      *
1826      * - `tokenId` must exist.
1827      *
1828      * Emits a {Transfer} event.
1829      */
1830     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1831         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1832 
1833         address from = address(uint160(prevOwnershipPacked));
1834 
1835         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1836 
1837         if (approvalCheck) {
1838             // The nested ifs save around 20+ gas over a compound boolean condition.
1839             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1840                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1841         }
1842 
1843         _beforeTokenTransfers(from, address(0), tokenId, 1);
1844 
1845         // Clear approvals from the previous owner.
1846         assembly {
1847             if approvedAddress {
1848                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1849                 sstore(approvedAddressSlot, 0)
1850             }
1851         }
1852 
1853         // Underflow of the sender's balance is impossible because we check for
1854         // ownership above and the recipient's balance can't realistically overflow.
1855         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1856         unchecked {
1857             // Updates:
1858             // - `balance -= 1`.
1859             // - `numberBurned += 1`.
1860             //
1861             // We can directly decrement the balance, and increment the number burned.
1862             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1863             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1864 
1865             // Updates:
1866             // - `address` to the last owner.
1867             // - `startTimestamp` to the timestamp of burning.
1868             // - `burned` to `true`.
1869             // - `nextInitialized` to `true`.
1870             _packedOwnerships[tokenId] = _packOwnershipData(
1871                 from,
1872                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1873             );
1874 
1875             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1876             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1877                 uint256 nextTokenId = tokenId + 1;
1878                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1879                 if (_packedOwnerships[nextTokenId] == 0) {
1880                     // If the next slot is within bounds.
1881                     if (nextTokenId != _currentIndex) {
1882                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1883                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1884                     }
1885                 }
1886             }
1887         }
1888 
1889         emit Transfer(from, address(0), tokenId);
1890         _afterTokenTransfers(from, address(0), tokenId, 1);
1891 
1892         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1893         unchecked {
1894             _burnCounter++;
1895         }
1896     }
1897 
1898     // =============================================================
1899     //                     EXTRA DATA OPERATIONS
1900     // =============================================================
1901 
1902     /**
1903      * @dev Directly sets the extra data for the ownership data `index`.
1904      */
1905     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1906         uint256 packed = _packedOwnerships[index];
1907         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1908         uint256 extraDataCasted;
1909         // Cast `extraData` with assembly to avoid redundant masking.
1910         assembly {
1911             extraDataCasted := extraData
1912         }
1913         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1914         _packedOwnerships[index] = packed;
1915     }
1916 
1917     /**
1918      * @dev Called during each token transfer to set the 24bit `extraData` field.
1919      * Intended to be overridden by the cosumer contract.
1920      *
1921      * `previousExtraData` - the value of `extraData` before transfer.
1922      *
1923      * Calling conditions:
1924      *
1925      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1926      * transferred to `to`.
1927      * - When `from` is zero, `tokenId` will be minted for `to`.
1928      * - When `to` is zero, `tokenId` will be burned by `from`.
1929      * - `from` and `to` are never both zero.
1930      */
1931     function _extraData(
1932         address from,
1933         address to,
1934         uint24 previousExtraData
1935     ) internal view virtual returns (uint24) {}
1936 
1937     /**
1938      * @dev Returns the next extra data for the packed ownership data.
1939      * The returned result is shifted into position.
1940      */
1941     function _nextExtraData(
1942         address from,
1943         address to,
1944         uint256 prevOwnershipPacked
1945     ) private view returns (uint256) {
1946         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1947         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1948     }
1949 
1950     // =============================================================
1951     //                       OTHER OPERATIONS
1952     // =============================================================
1953 
1954     /**
1955      * @dev Returns the message sender (defaults to `msg.sender`).
1956      *
1957      * If you are writing GSN compatible contracts, you need to override this function.
1958      */
1959     function _msgSenderERC721A() internal view virtual returns (address) {
1960         return msg.sender;
1961     }
1962 
1963     /**
1964      * @dev Converts a uint256 to its ASCII string decimal representation.
1965      */
1966     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1967         assembly {
1968             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1969             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1970             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1971             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1972             let m := add(mload(0x40), 0xa0)
1973             // Update the free memory pointer to allocate.
1974             mstore(0x40, m)
1975             // Assign the `str` to the end.
1976             str := sub(m, 0x20)
1977             // Zeroize the slot after the string.
1978             mstore(str, 0)
1979 
1980             // Cache the end of the memory to calculate the length later.
1981             let end := str
1982 
1983             // We write the string from rightmost digit to leftmost digit.
1984             // The following is essentially a do-while loop that also handles the zero case.
1985             // prettier-ignore
1986             for { let temp := value } 1 {} {
1987                 str := sub(str, 1)
1988                 // Write the character to the pointer.
1989                 // The ASCII index of the '0' character is 48.
1990                 mstore8(str, add(48, mod(temp, 10)))
1991                 // Keep dividing `temp` until zero.
1992                 temp := div(temp, 10)
1993                 // prettier-ignore
1994                 if iszero(temp) { break }
1995             }
1996 
1997             let length := sub(end, str)
1998             // Move the pointer 32 bytes leftwards to make room for the length.
1999             str := sub(str, 0x20)
2000             // Store the length.
2001             mstore(str, length)
2002         }
2003     }
2004 }
2005 
2006 // File: contracts/SunsetOnGlitch.sol
2007 
2008 
2009 pragma solidity ^0.8.17;
2010 
2011 
2012 
2013 
2014 
2015 contract SunsetOnGlitch is ERC721A, Ownable {
2016 
2017     bool isMintLive;
2018     bool isWhiteListMintLive;
2019 
2020     uint256 maxSupply = 1000;
2021     uint256 baseDNA = 20220325;
2022 
2023     mapping(address => bool) whitelisted;
2024     mapping(address => bool) whitelistMinted;
2025 
2026     uint256 mintRate = 0.005 ether;
2027 
2028     constructor() ERC721A("Sunset on Glitch by OxAnomali", "GLTCH") {}
2029 
2030     function publicMint(uint _qty) external payable {
2031         require(isMintLive, "Mint is not live yet.");
2032         require(totalSupply() < maxSupply, "Not enough tokens left");
2033         require(_qty <= 3, "Maximum mint per transaction is 3");
2034         require(msg.value >= (mintRate * _qty), "Not enough ether sent");
2035         _mint(_qty);
2036     }
2037 
2038     function whitelistMint() external {
2039         require(isWhiteListMintLive, "Mint is not live yet.");
2040         require(totalSupply() < maxSupply, "Not enough tokens left");
2041         require(whitelisted[msg.sender], "Address not whitelisted");
2042         require(!whitelistMinted[msg.sender], "You already claimed whitelist");
2043         _mint(1);
2044         whitelistMinted[msg.sender] = true;
2045     }
2046 
2047     function teamMint(uint16 _qty) external onlyOwner {
2048         _safeMint(msg.sender, _qty);
2049     }
2050 
2051     function setWhitelistAddresses(address[] memory _whitelisted) public onlyOwner {
2052         for (uint8 i; i<_whitelisted.length; i++) {
2053             whitelisted[_whitelisted[i]] = true;
2054         }
2055     }
2056 
2057     function setMaxSupply(uint256 _rate) external onlyOwner {
2058         maxSupply = _rate;
2059     }
2060 
2061     function withdraw() external payable onlyOwner {
2062         payable(owner()).transfer(address(this).balance);
2063     }
2064 
2065 
2066     function tokenURI(uint256 _tokenId) public view override (ERC721A) returns (string memory){
2067 
2068         uint256 _dna = baseDNA * _tokenId;
2069 
2070         string memory _name = "Sunset on Glitch";
2071         string memory _image = Base64.encode(bytes(_generateFinalArt(_dna))); 
2072         string memory _description = "Sunset on Glitch is an NFT collection that is meant to give kudos to Web3 builders who, in spite of the hurdles and dissapointments, are here to stay to further the cause of decentralization. This serves as a memorabilia for builders that there's a time in their lives when they chose to build amidst the FUDs and storms.";
2073         
2074         return string(
2075             abi.encodePacked(
2076                 'data:application/json;base64,',
2077                 Base64.encode(
2078                     bytes(
2079                         abi.encodePacked(
2080                             '{"name":"', 
2081                             _name,
2082                             ' #',
2083                             Strings.toString(_tokenId+1),
2084                             '", "description":"', 
2085                             _description,
2086                             '", "image": "', 
2087                             'data:image/svg+xml;base64,', 
2088                             _image,
2089                             '"}'
2090                         )
2091                     )
2092                 )
2093             )
2094         );
2095     }
2096 
2097     function setMintRate(uint256 _mintRate) public onlyOwner {
2098         mintRate = _mintRate;
2099     }
2100 
2101     function setMintLive(bool _isLive) public onlyOwner {
2102         isMintLive = _isLive;
2103     }
2104 
2105     function setWhitelistMintLive(bool _isLive) public onlyOwner {
2106         isWhiteListMintLive = _isLive;
2107     }
2108 
2109     function checkWhitelist(address _address) public view returns (bool) {
2110         return whitelisted[_address]? whitelisted[_address] : false;
2111     }
2112 
2113     function _mint(uint _quantity) internal {
2114         _safeMint(msg.sender, _quantity);
2115     }
2116     
2117     function _rand(uint256 _tokenId) internal view returns(uint256) {
2118         return uint(keccak256(abi.encodePacked(block.timestamp * _tokenId))) % 10000;
2119     }
2120 
2121     //SVG art
2122     function _generateFinalArt(uint256 _dna) internal view returns (string memory) {
2123 
2124         return string(abi.encodePacked(
2125             '<?xml version="1.0" encoding="UTF-8"?><svg width="600pt" height="500pt" viewBox="0 0 600 500" version="1.1" xmlns="http://www.w3.org/2000/svg"><defs>',
2126             _generateLinearGradient(_dna),
2127             '</defs><filter id="noise"><feTurbulence baseFrequency="6.29" numOctaves="6" stitchTiles="stitch"/></filter><style>',
2128             _generateSkyBlend(_dna),
2129             _generateWaterBlend(_dna),
2130             '#overlay{filter:url(#noise);position:absolute;left:0;top:0;content:" ";width:100%;height:100%;z-index:-1;mix-blend-mode:multiply;}.glitch-m{fill:#FF00FF;}.glitch-c{fill:#00FFFF;}.glitch-b{fill:#000000;}.glitch{mix-blend-mode:light-scren;opacity: 1;}</style>',
2131             '<rect class="skyblend" width="650" height="400" x="0" y="0" />',
2132             _generateSun(),
2133             '<rect class="waterblend" width="650" height="200" x="0" y="300" />',
2134             _lineFactory(0, 600, 300, 'red', 'red'),
2135             _reflectionsFactory(_dna),
2136             _glitchFactory(_dna),
2137             '<rect id="overlay"/></svg>'
2138         ));
2139 
2140     }
2141 
2142     function _generateSun() internal view returns (string memory) {
2143         
2144         uint _time = block.timestamp/60/60%24;
2145         uint _interval = _time * 25;
2146         uint _y = (_time <= 12)? 430 - _interval : _interval - 130;
2147         
2148         return _circleFactory(120, 300, _y + 6, 'url(#linear-gradient)', 'sun');
2149     }
2150 
2151     function _generateSkyBlend(uint256 _dna) internal pure returns (string memory) { 
2152         
2153         string [9] memory _skyBlend = ['.skyblend { fill: #ff9b79;}', '.skyblend { fill: #5b86e5;}', '.skyblend { fill: #1d2671;}', '.skyblend { fill: #243b55;}', '.skyblend { fill: #141e30;}', '.skyblend { fill: #4e4376;}', '.skyblend { fill: #ed4264;}', '.skyblend { fill: #ddd6f3;}', '.skyblend { fill: #FF69B4;}'];
2154         
2155         return  _skyBlend[_dna % _skyBlend.length]; 
2156     }
2157 
2158     function _generateWaterBlend(uint256 _dna) internal pure returns (string memory) { 
2159         
2160         string [10] memory _waterBlend = ['.waterblend { fill: #0000b3;}', '.waterblend { fill: #000428;}', '.waterblend { fill: #ba5370;}', '.waterblend { fill: #4568dc;}', '.waterblend { fill: #b06ab3;}', '.waterblend { fill: #ffd89b;}', '.waterblend { fill: #19547b;}', '.waterblend { fill: #4ca1af;}', '.waterblend { fill: #00FFFF;}', '.waterblend { fill: #C5FAD5;}'];
2161 
2162         return  _waterBlend[_dna%_waterBlend.length];  
2163         
2164     }
2165 
2166     function _generateLinearGradient(uint256 _dna) internal pure returns (string memory) { 
2167         
2168         string [8] memory _linearGradients = ['#fd8008','#ffafbd','#cc2b5e','#42275a','#bdc3c7','#000428','#3F0D12','#56ab2f'];
2169         string [8] memory _linearGradients2 = ['#edcb0d','#ffc3a0','#753a88','#734b6d','#bdc3c7','#004e92','#A71D31','#a8e063'];
2170         
2171         uint i = _dna % 8;
2172         return _linearGradientFactory(_linearGradients[i], _linearGradients2[i]); 
2173     }
2174 
2175     function _circleFactory(uint _r, uint _cx, uint _cy, string memory _fill, string memory _id) internal pure returns (string memory) {
2176 
2177         return string(abi.encodePacked(
2178             '<circle id="',
2179             _id,
2180             '" r="',
2181             Strings.toString(_r),
2182             '"',
2183             ' cx="',
2184             Strings.toString(_cx),
2185             '"',
2186             ' cy="',
2187             Strings.toString(_cy),
2188             '"',
2189             ' fill="',
2190             _fill,
2191             '" />'
2192         ));
2193     }
2194 
2195     function _rectFactory(uint _width, uint _height, uint _x, uint _y, string memory _className) internal pure returns (string memory) {
2196 
2197         return string(abi.encodePacked(
2198             '<rect fill="#ffffff" rx="5" ry="5" height="',
2199             Strings.toString(_height),
2200             '"',
2201             ' class="',
2202             _className,
2203             '"',
2204             ' width="',
2205             Strings.toString(_width),
2206             '"',
2207             ' x="',
2208             Strings.toString(_x),
2209             '"',
2210             ' y="',
2211             Strings.toString(_y),
2212             '" />'
2213         ));
2214     } 
2215     
2216     function _linearGradientFactory(string memory _stopColor1, string memory _stopColor2) internal pure returns (string memory) {
2217         return string(abi.encodePacked(
2218             '<linearGradient id="linear-gradient" gradientUnits="objectBoundingBox" x1="0" y1="0" x2="1" y2="1" spreadMethod="pad">',
2219             '<stop stop-color="',
2220             _stopColor1,
2221             '" offset="0" stop-opacity="1"/><stop stop-color="',
2222             _stopColor2,
2223             '" offset="1" stop-opacity="1"/></linearGradient>'
2224         ));
2225     }
2226 
2227     function _cloudFactory(uint _width, uint _x, uint _y, string memory _className) internal pure returns (string memory) {
2228         return _rectFactory(_width, 10, _x, _y, _className);
2229     }
2230 
2231     //array params are w x y class
2232     function _cloudLumps( uint _width, uint _x, uint _y, string memory _blend) internal pure returns (string memory) {
2233         return string(abi.encodePacked(
2234                 _cloudFactory(_width, _x, _y, ''),
2235                 _cloudFactory(_width/2 , _x+25, _y+10, ''),
2236                 _cloudFactory(_width/4, _x+13, _y+10, _blend),
2237                 _cloudFactory(_width/4, (_x+50), _y+10, _blend),
2238                 _cloudFactory(_width/2+_width , _x-10, _y+20, '')
2239             ));
2240     }
2241 
2242     function _reflectionsFactory(uint256 _dna) internal pure returns (string memory _lines) {
2243         
2244         uint8 [6] memory _cloudsRange1 = [100,75,110,95,65,50];
2245         uint16 [5] memory _cloudsRange2 = [410,465,415,425,430];
2246 
2247         bytes memory _cloudLumpsGroup = abi.encodePacked(
2248             _cloudLumps(75, _cloudsRange1[_dna%_cloudsRange1.length], 50, 'skyblend'),
2249             _cloudLumps(80, _cloudsRange2[_dna%_cloudsRange2.length], 195, 'skyblend'),
2250             _cloudLumps(70, _cloudsRange2[_dna%_cloudsRange2.length], 80, 'skyblend'),
2251             _cloudLumps(95, _cloudsRange1[_dna%_cloudsRange1.length], 170, 'skyblend')
2252         );
2253 
2254         uint16[8] memory _cloudsRange3 = [215,250,255,275,290,295,310,330];
2255 
2256         return string(abi.encodePacked(
2257             _cloudLumpsGroup,
2258             _cloudLumps(80, _cloudsRange3[_dna%5], 330, 'waterblend'),
2259             _cloudFactory(100, _cloudsRange3[_dna%3+3], 370, ''),
2260             _cloudFactory(75, _cloudsRange3[_dna%2+2], 390, ''),
2261             _cloudFactory(50, _cloudsRange3[_dna%8], 410, ''),
2262             _cloudFactory(50, _cloudsRange3[_dna%7+1], 430, ''),
2263             _cloudFactory(75, _cloudsRange3[_dna%5], 450, ''),
2264             _generateWaterLines()
2265         ));
2266     }
2267 
2268     function _generateWaterLines() internal pure returns (string memory) {
2269         return string(abi.encodePacked(
2270             _lineFactory(220, 380, 318, 'white', 'white'),
2271             _lineFactory(180, 410, 335, 'white', 'white'),
2272             _lineFactory(90, 510, 355, 'white', 'white'),
2273             _lineFactory(180, 410, 376, 'white', 'white'),
2274             _lineFactory(220, 380, 396, 'white', 'white'),
2275             _lineFactory(90, 510, 435, 'white', 'white'),
2276             _lineFactory(180, 410, 455, 'white', 'white')
2277         ));
2278     }
2279 
2280     function _lineFactory(uint _x1, uint _x2, uint _y, string memory _stroke, string memory _className ) internal pure returns (string memory) {
2281 
2282         return string(abi.encodePacked(
2283             '<line stroke="',
2284             _stroke,
2285             '" stroke-width="1"',
2286             ' class="',
2287             _className,
2288             '"',
2289             ' x1="',
2290             Strings.toString(_x1),
2291             '"',
2292             ' x2="',
2293             Strings.toString(_x2),
2294             '"',
2295             ' y1="',
2296             Strings.toString(_y),
2297             '"',
2298             ' y2="',
2299             Strings.toString(_y),
2300             '" />'
2301         ));
2302 
2303     }
2304 
2305     function _glitchFactory(uint256 _dna) internal view returns (string memory) {
2306 
2307             uint _limit = _dna % 50;
2308 
2309             _limit = (_limit < 30)? _limit + 10 : _limit;
2310             uint _ra = _rand(_limit*20);
2311             bytes memory _glitch;
2312             
2313             string [3] memory _glitchColorOptions = [' glitch-m ', ' glitch-c ', ' glitch-b '];
2314             
2315             for (uint i=0; i<= _limit; i++) {
2316                 
2317                 _glitch = abi.encodePacked(
2318                     _glitch,
2319                     '<rect class="glitch ',
2320                     _glitchColorOptions[i%_glitchColorOptions.length],
2321                     '" width="',
2322                     Strings.toString((_ra) % 30),
2323                     '" height="5" ',
2324                     'x="',
2325                     Strings.toString((_rand(i)) % 500),
2326                     '" y="',
2327                     Strings.toString(_rand(i) % 650),
2328                     '" />'
2329                 );
2330             }
2331 
2332             return string(_glitch);
2333 
2334     }
2335     
2336     function viewImage(uint256 _tokenId) public view returns(string memory) {
2337         return _generateFinalArt(_tokenId);
2338     }
2339 
2340 }