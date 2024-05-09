1 // File: @openzeppelin/contracts/utils/math/Math.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     enum Rounding {
13         Down, // Toward negative infinity
14         Up, // Toward infinity
15         Zero // Toward zero
16     }
17 
18     /**
19      * @dev Returns the largest of two numbers.
20      */
21     function max(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a > b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the smallest of two numbers.
27      */
28     function min(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a < b ? a : b;
30     }
31 
32     /**
33      * @dev Returns the average of two numbers. The result is rounded towards
34      * zero.
35      */
36     function average(uint256 a, uint256 b) internal pure returns (uint256) {
37         // (a + b) / 2 can overflow.
38         return (a & b) + (a ^ b) / 2;
39     }
40 
41     /**
42      * @dev Returns the ceiling of the division of two numbers.
43      *
44      * This differs from standard division with `/` in that it rounds up instead
45      * of rounding down.
46      */
47     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
48         // (a + b - 1) / b can overflow on addition, so we distribute.
49         return a == 0 ? 0 : (a - 1) / b + 1;
50     }
51 
52     /**
53      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
54      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
55      * with further edits by Uniswap Labs also under MIT license.
56      */
57     function mulDiv(
58         uint256 x,
59         uint256 y,
60         uint256 denominator
61     ) internal pure returns (uint256 result) {
62         unchecked {
63             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
64             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
65             // variables such that product = prod1 * 2^256 + prod0.
66             uint256 prod0; // Least significant 256 bits of the product
67             uint256 prod1; // Most significant 256 bits of the product
68             assembly {
69                 let mm := mulmod(x, y, not(0))
70                 prod0 := mul(x, y)
71                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
72             }
73 
74             // Handle non-overflow cases, 256 by 256 division.
75             if (prod1 == 0) {
76                 return prod0 / denominator;
77             }
78 
79             // Make sure the result is less than 2^256. Also prevents denominator == 0.
80             require(denominator > prod1);
81 
82             ///////////////////////////////////////////////
83             // 512 by 256 division.
84             ///////////////////////////////////////////////
85 
86             // Make division exact by subtracting the remainder from [prod1 prod0].
87             uint256 remainder;
88             assembly {
89                 // Compute remainder using mulmod.
90                 remainder := mulmod(x, y, denominator)
91 
92                 // Subtract 256 bit number from 512 bit number.
93                 prod1 := sub(prod1, gt(remainder, prod0))
94                 prod0 := sub(prod0, remainder)
95             }
96 
97             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
98             // See https://cs.stackexchange.com/q/138556/92363.
99 
100             // Does not overflow because the denominator cannot be zero at this stage in the function.
101             uint256 twos = denominator & (~denominator + 1);
102             assembly {
103                 // Divide denominator by twos.
104                 denominator := div(denominator, twos)
105 
106                 // Divide [prod1 prod0] by twos.
107                 prod0 := div(prod0, twos)
108 
109                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
110                 twos := add(div(sub(0, twos), twos), 1)
111             }
112 
113             // Shift in bits from prod1 into prod0.
114             prod0 |= prod1 * twos;
115 
116             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
117             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
118             // four bits. That is, denominator * inv = 1 mod 2^4.
119             uint256 inverse = (3 * denominator) ^ 2;
120 
121             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
122             // in modular arithmetic, doubling the correct bits in each step.
123             inverse *= 2 - denominator * inverse; // inverse mod 2^8
124             inverse *= 2 - denominator * inverse; // inverse mod 2^16
125             inverse *= 2 - denominator * inverse; // inverse mod 2^32
126             inverse *= 2 - denominator * inverse; // inverse mod 2^64
127             inverse *= 2 - denominator * inverse; // inverse mod 2^128
128             inverse *= 2 - denominator * inverse; // inverse mod 2^256
129 
130             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
131             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
132             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
133             // is no longer required.
134             result = prod0 * inverse;
135             return result;
136         }
137     }
138 
139     /**
140      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
141      */
142     function mulDiv(
143         uint256 x,
144         uint256 y,
145         uint256 denominator,
146         Rounding rounding
147     ) internal pure returns (uint256) {
148         uint256 result = mulDiv(x, y, denominator);
149         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
150             result += 1;
151         }
152         return result;
153     }
154 
155     /**
156      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
157      *
158      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
159      */
160     function sqrt(uint256 a) internal pure returns (uint256) {
161         if (a == 0) {
162             return 0;
163         }
164 
165         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
166         //
167         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
168         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
169         //
170         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
171         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
172         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
173         //
174         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
175         uint256 result = 1 << (log2(a) >> 1);
176 
177         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
178         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
179         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
180         // into the expected uint128 result.
181         unchecked {
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             return min(result, a / result);
190         }
191     }
192 
193     /**
194      * @notice Calculates sqrt(a), following the selected rounding direction.
195      */
196     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
197         unchecked {
198             uint256 result = sqrt(a);
199             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
200         }
201     }
202 
203     /**
204      * @dev Return the log in base 2, rounded down, of a positive value.
205      * Returns 0 if given 0.
206      */
207     function log2(uint256 value) internal pure returns (uint256) {
208         uint256 result = 0;
209         unchecked {
210             if (value >> 128 > 0) {
211                 value >>= 128;
212                 result += 128;
213             }
214             if (value >> 64 > 0) {
215                 value >>= 64;
216                 result += 64;
217             }
218             if (value >> 32 > 0) {
219                 value >>= 32;
220                 result += 32;
221             }
222             if (value >> 16 > 0) {
223                 value >>= 16;
224                 result += 16;
225             }
226             if (value >> 8 > 0) {
227                 value >>= 8;
228                 result += 8;
229             }
230             if (value >> 4 > 0) {
231                 value >>= 4;
232                 result += 4;
233             }
234             if (value >> 2 > 0) {
235                 value >>= 2;
236                 result += 2;
237             }
238             if (value >> 1 > 0) {
239                 result += 1;
240             }
241         }
242         return result;
243     }
244 
245     /**
246      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
247      * Returns 0 if given 0.
248      */
249     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
250         unchecked {
251             uint256 result = log2(value);
252             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
253         }
254     }
255 
256     /**
257      * @dev Return the log in base 10, rounded down, of a positive value.
258      * Returns 0 if given 0.
259      */
260     function log10(uint256 value) internal pure returns (uint256) {
261         uint256 result = 0;
262         unchecked {
263             if (value >= 10**64) {
264                 value /= 10**64;
265                 result += 64;
266             }
267             if (value >= 10**32) {
268                 value /= 10**32;
269                 result += 32;
270             }
271             if (value >= 10**16) {
272                 value /= 10**16;
273                 result += 16;
274             }
275             if (value >= 10**8) {
276                 value /= 10**8;
277                 result += 8;
278             }
279             if (value >= 10**4) {
280                 value /= 10**4;
281                 result += 4;
282             }
283             if (value >= 10**2) {
284                 value /= 10**2;
285                 result += 2;
286             }
287             if (value >= 10**1) {
288                 result += 1;
289             }
290         }
291         return result;
292     }
293 
294     /**
295      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
296      * Returns 0 if given 0.
297      */
298     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
299         unchecked {
300             uint256 result = log10(value);
301             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
302         }
303     }
304 
305     /**
306      * @dev Return the log in base 256, rounded down, of a positive value.
307      * Returns 0 if given 0.
308      *
309      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
310      */
311     function log256(uint256 value) internal pure returns (uint256) {
312         uint256 result = 0;
313         unchecked {
314             if (value >> 128 > 0) {
315                 value >>= 128;
316                 result += 16;
317             }
318             if (value >> 64 > 0) {
319                 value >>= 64;
320                 result += 8;
321             }
322             if (value >> 32 > 0) {
323                 value >>= 32;
324                 result += 4;
325             }
326             if (value >> 16 > 0) {
327                 value >>= 16;
328                 result += 2;
329             }
330             if (value >> 8 > 0) {
331                 result += 1;
332             }
333         }
334         return result;
335     }
336 
337     /**
338      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
339      * Returns 0 if given 0.
340      */
341     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
342         unchecked {
343             uint256 result = log256(value);
344             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
345         }
346     }
347 }
348 
349 // File: @openzeppelin/contracts/utils/Strings.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev String operations.
359  */
360 library Strings {
361     bytes16 private constant _SYMBOLS = "0123456789abcdef";
362     uint8 private constant _ADDRESS_LENGTH = 20;
363 
364     /**
365      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
366      */
367     function toString(uint256 value) internal pure returns (string memory) {
368         unchecked {
369             uint256 length = Math.log10(value) + 1;
370             string memory buffer = new string(length);
371             uint256 ptr;
372             /// @solidity memory-safe-assembly
373             assembly {
374                 ptr := add(buffer, add(32, length))
375             }
376             while (true) {
377                 ptr--;
378                 /// @solidity memory-safe-assembly
379                 assembly {
380                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
381                 }
382                 value /= 10;
383                 if (value == 0) break;
384             }
385             return buffer;
386         }
387     }
388 
389     /**
390      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
391      */
392     function toHexString(uint256 value) internal pure returns (string memory) {
393         unchecked {
394             return toHexString(value, Math.log256(value) + 1);
395         }
396     }
397 
398     /**
399      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
400      */
401     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
402         bytes memory buffer = new bytes(2 * length + 2);
403         buffer[0] = "0";
404         buffer[1] = "x";
405         for (uint256 i = 2 * length + 1; i > 1; --i) {
406             buffer[i] = _SYMBOLS[value & 0xf];
407             value >>= 4;
408         }
409         require(value == 0, "Strings: hex length insufficient");
410         return string(buffer);
411     }
412 
413     /**
414      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
415      */
416     function toHexString(address addr) internal pure returns (string memory) {
417         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
418     }
419 }
420 
421 // File: @openzeppelin/contracts/utils/StorageSlot.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @dev Library for reading and writing primitive types to specific storage slots.
430  *
431  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
432  * This library helps with reading and writing to such slots without the need for inline assembly.
433  *
434  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
435  *
436  * Example usage to set ERC1967 implementation slot:
437  * ```
438  * contract ERC1967 {
439  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
440  *
441  *     function _getImplementation() internal view returns (address) {
442  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
443  *     }
444  *
445  *     function _setImplementation(address newImplementation) internal {
446  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
447  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
448  *     }
449  * }
450  * ```
451  *
452  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
453  */
454 library StorageSlot {
455     struct AddressSlot {
456         address value;
457     }
458 
459     struct BooleanSlot {
460         bool value;
461     }
462 
463     struct Bytes32Slot {
464         bytes32 value;
465     }
466 
467     struct Uint256Slot {
468         uint256 value;
469     }
470 
471     /**
472      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
473      */
474     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
475         /// @solidity memory-safe-assembly
476         assembly {
477             r.slot := slot
478         }
479     }
480 
481     /**
482      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
483      */
484     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
485         /// @solidity memory-safe-assembly
486         assembly {
487             r.slot := slot
488         }
489     }
490 
491     /**
492      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
493      */
494     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
495         /// @solidity memory-safe-assembly
496         assembly {
497             r.slot := slot
498         }
499     }
500 
501     /**
502      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
503      */
504     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
505         /// @solidity memory-safe-assembly
506         assembly {
507             r.slot := slot
508         }
509     }
510 }
511 
512 // File: @openzeppelin/contracts/utils/Arrays.sol
513 
514 
515 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Arrays.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 
520 
521 /**
522  * @dev Collection of functions related to array types.
523  */
524 library Arrays {
525     using StorageSlot for bytes32;
526 
527     /**
528      * @dev Searches a sorted `array` and returns the first index that contains
529      * a value greater or equal to `element`. If no such index exists (i.e. all
530      * values in the array are strictly less than `element`), the array length is
531      * returned. Time complexity O(log n).
532      *
533      * `array` is expected to be sorted in ascending order, and to contain no
534      * repeated elements.
535      */
536     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
537         if (array.length == 0) {
538             return 0;
539         }
540 
541         uint256 low = 0;
542         uint256 high = array.length;
543 
544         while (low < high) {
545             uint256 mid = Math.average(low, high);
546 
547             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
548             // because Math.average rounds down (it does integer division with truncation).
549             if (unsafeAccess(array, mid).value > element) {
550                 high = mid;
551             } else {
552                 low = mid + 1;
553             }
554         }
555 
556         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
557         if (low > 0 && unsafeAccess(array, low - 1).value == element) {
558             return low - 1;
559         } else {
560             return low;
561         }
562     }
563 
564     /**
565      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
566      *
567      * WARNING: Only use if you are certain `pos` is lower than the array length.
568      */
569     function unsafeAccess(address[] storage arr, uint256 pos) internal pure returns (StorageSlot.AddressSlot storage) {
570         bytes32 slot;
571         /// @solidity memory-safe-assembly
572         assembly {
573             mstore(0, arr.slot)
574             slot := add(keccak256(0, 0x20), pos)
575         }
576         return slot.getAddressSlot();
577     }
578 
579     /**
580      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
581      *
582      * WARNING: Only use if you are certain `pos` is lower than the array length.
583      */
584     function unsafeAccess(bytes32[] storage arr, uint256 pos) internal pure returns (StorageSlot.Bytes32Slot storage) {
585         bytes32 slot;
586         /// @solidity memory-safe-assembly
587         assembly {
588             mstore(0, arr.slot)
589             slot := add(keccak256(0, 0x20), pos)
590         }
591         return slot.getBytes32Slot();
592     }
593 
594     /**
595      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
596      *
597      * WARNING: Only use if you are certain `pos` is lower than the array length.
598      */
599     function unsafeAccess(uint256[] storage arr, uint256 pos) internal pure returns (StorageSlot.Uint256Slot storage) {
600         bytes32 slot;
601         /// @solidity memory-safe-assembly
602         assembly {
603             mstore(0, arr.slot)
604             slot := add(keccak256(0, 0x20), pos)
605         }
606         return slot.getUint256Slot();
607     }
608 }
609 
610 // File: @openzeppelin/contracts/utils/Context.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev Provides information about the current execution context, including the
619  * sender of the transaction and its data. While these are generally available
620  * via msg.sender and msg.data, they should not be accessed in such a direct
621  * manner, since when dealing with meta-transactions the account sending and
622  * paying for execution may not be the actual sender (as far as an application
623  * is concerned).
624  *
625  * This contract is only required for intermediate, library-like contracts.
626  */
627 abstract contract Context {
628     function _msgSender() internal view virtual returns (address) {
629         return msg.sender;
630     }
631 
632     function _msgData() internal view virtual returns (bytes calldata) {
633         return msg.data;
634     }
635 }
636 
637 // File: @openzeppelin/contracts/access/Ownable.sol
638 
639 
640 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @dev Contract module which provides a basic access control mechanism, where
647  * there is an account (an owner) that can be granted exclusive access to
648  * specific functions.
649  *
650  * By default, the owner account will be the one that deploys the contract. This
651  * can later be changed with {transferOwnership}.
652  *
653  * This module is used through inheritance. It will make available the modifier
654  * `onlyOwner`, which can be applied to your functions to restrict their use to
655  * the owner.
656  */
657 abstract contract Ownable is Context {
658     address private _owner;
659 
660     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
661 
662     /**
663      * @dev Initializes the contract setting the deployer as the initial owner.
664      */
665     constructor() {
666         _transferOwnership(_msgSender());
667     }
668 
669     /**
670      * @dev Throws if called by any account other than the owner.
671      */
672     modifier onlyOwner() {
673         _checkOwner();
674         _;
675     }
676 
677     /**
678      * @dev Returns the address of the current owner.
679      */
680     function owner() public view virtual returns (address) {
681         return _owner;
682     }
683 
684     /**
685      * @dev Throws if the sender is not the owner.
686      */
687     function _checkOwner() internal view virtual {
688         require(owner() == _msgSender(), "Ownable: caller is not the owner");
689     }
690 
691     /**
692      * @dev Leaves the contract without owner. It will not be possible to call
693      * `onlyOwner` functions anymore. Can only be called by the current owner.
694      *
695      * NOTE: Renouncing ownership will leave the contract without an owner,
696      * thereby removing any functionality that is only available to the owner.
697      */
698     function renounceOwnership() public virtual onlyOwner {
699         _transferOwnership(address(0));
700     }
701 
702     /**
703      * @dev Transfers ownership of the contract to a new account (`newOwner`).
704      * Can only be called by the current owner.
705      */
706     function transferOwnership(address newOwner) public virtual onlyOwner {
707         require(newOwner != address(0), "Ownable: new owner is the zero address");
708         _transferOwnership(newOwner);
709     }
710 
711     /**
712      * @dev Transfers ownership of the contract to a new account (`newOwner`).
713      * Internal function without access restriction.
714      */
715     function _transferOwnership(address newOwner) internal virtual {
716         address oldOwner = _owner;
717         _owner = newOwner;
718         emit OwnershipTransferred(oldOwner, newOwner);
719     }
720 }
721 
722 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
723 
724 
725 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 /**
730  * @dev Contract module that helps prevent reentrant calls to a function.
731  *
732  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
733  * available, which can be applied to functions to make sure there are no nested
734  * (reentrant) calls to them.
735  *
736  * Note that because there is a single `nonReentrant` guard, functions marked as
737  * `nonReentrant` may not call one another. This can be worked around by making
738  * those functions `private`, and then adding `external` `nonReentrant` entry
739  * points to them.
740  *
741  * TIP: If you would like to learn more about reentrancy and alternative ways
742  * to protect against it, check out our blog post
743  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
744  */
745 abstract contract ReentrancyGuard {
746     // Booleans are more expensive than uint256 or any type that takes up a full
747     // word because each write operation emits an extra SLOAD to first read the
748     // slot's contents, replace the bits taken up by the boolean, and then write
749     // back. This is the compiler's defense against contract upgrades and
750     // pointer aliasing, and it cannot be disabled.
751 
752     // The values being non-zero value makes deployment a bit more expensive,
753     // but in exchange the refund on every call to nonReentrant will be lower in
754     // amount. Since refunds are capped to a percentage of the total
755     // transaction's gas, it is best to keep them low in cases like this one, to
756     // increase the likelihood of the full refund coming into effect.
757     uint256 private constant _NOT_ENTERED = 1;
758     uint256 private constant _ENTERED = 2;
759 
760     uint256 private _status;
761 
762     constructor() {
763         _status = _NOT_ENTERED;
764     }
765 
766     /**
767      * @dev Prevents a contract from calling itself, directly or indirectly.
768      * Calling a `nonReentrant` function from another `nonReentrant`
769      * function is not supported. It is possible to prevent this from happening
770      * by making the `nonReentrant` function external, and making it call a
771      * `private` function that does the actual work.
772      */
773     modifier nonReentrant() {
774         _nonReentrantBefore();
775         _;
776         _nonReentrantAfter();
777     }
778 
779     function _nonReentrantBefore() private {
780         // On the first call to nonReentrant, _status will be _NOT_ENTERED
781         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
782 
783         // Any calls to nonReentrant after this point will fail
784         _status = _ENTERED;
785     }
786 
787     function _nonReentrantAfter() private {
788         // By storing the original value once again, a refund is triggered (see
789         // https://eips.ethereum.org/EIPS/eip-2200)
790         _status = _NOT_ENTERED;
791     }
792 }
793 
794 // File: erc721a/contracts/IERC721A.sol
795 
796 
797 // ERC721A Contracts v4.2.3
798 // Creator: Chiru Labs
799 
800 pragma solidity ^0.8.4;
801 
802 /**
803  * @dev Interface of ERC721A.
804  */
805 interface IERC721A {
806     /**
807      * The caller must own the token or be an approved operator.
808      */
809     error ApprovalCallerNotOwnerNorApproved();
810 
811     /**
812      * The token does not exist.
813      */
814     error ApprovalQueryForNonexistentToken();
815 
816     /**
817      * Cannot query the balance for the zero address.
818      */
819     error BalanceQueryForZeroAddress();
820 
821     /**
822      * Cannot mint to the zero address.
823      */
824     error MintToZeroAddress();
825 
826     /**
827      * The quantity of tokens minted must be more than zero.
828      */
829     error MintZeroQuantity();
830 
831     /**
832      * The token does not exist.
833      */
834     error OwnerQueryForNonexistentToken();
835 
836     /**
837      * The caller must own the token or be an approved operator.
838      */
839     error TransferCallerNotOwnerNorApproved();
840 
841     /**
842      * The token must be owned by `from`.
843      */
844     error TransferFromIncorrectOwner();
845 
846     /**
847      * Cannot safely transfer to a contract that does not implement the
848      * ERC721Receiver interface.
849      */
850     error TransferToNonERC721ReceiverImplementer();
851 
852     /**
853      * Cannot transfer to the zero address.
854      */
855     error TransferToZeroAddress();
856 
857     /**
858      * The token does not exist.
859      */
860     error URIQueryForNonexistentToken();
861 
862     /**
863      * The `quantity` minted with ERC2309 exceeds the safety limit.
864      */
865     error MintERC2309QuantityExceedsLimit();
866 
867     /**
868      * The `extraData` cannot be set on an unintialized ownership slot.
869      */
870     error OwnershipNotInitializedForExtraData();
871 
872     // =============================================================
873     //                            STRUCTS
874     // =============================================================
875 
876     struct TokenOwnership {
877         // The address of the owner.
878         address addr;
879         // Stores the start time of ownership with minimal overhead for tokenomics.
880         uint64 startTimestamp;
881         // Whether the token has been burned.
882         bool burned;
883         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
884         uint24 extraData;
885     }
886 
887     // =============================================================
888     //                         TOKEN COUNTERS
889     // =============================================================
890 
891     /**
892      * @dev Returns the total number of tokens in existence.
893      * Burned tokens will reduce the count.
894      * To get the total number of tokens minted, please see {_totalMinted}.
895      */
896     function totalSupply() external view returns (uint256);
897 
898     // =============================================================
899     //                            IERC165
900     // =============================================================
901 
902     /**
903      * @dev Returns true if this contract implements the interface defined by
904      * `interfaceId`. See the corresponding
905      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
906      * to learn more about how these ids are created.
907      *
908      * This function call must use less than 30000 gas.
909      */
910     function supportsInterface(bytes4 interfaceId) external view returns (bool);
911 
912     // =============================================================
913     //                            IERC721
914     // =============================================================
915 
916     /**
917      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
918      */
919     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
920 
921     /**
922      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
923      */
924     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
925 
926     /**
927      * @dev Emitted when `owner` enables or disables
928      * (`approved`) `operator` to manage all of its assets.
929      */
930     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
931 
932     /**
933      * @dev Returns the number of tokens in `owner`'s account.
934      */
935     function balanceOf(address owner) external view returns (uint256 balance);
936 
937     /**
938      * @dev Returns the owner of the `tokenId` token.
939      *
940      * Requirements:
941      *
942      * - `tokenId` must exist.
943      */
944     function ownerOf(uint256 tokenId) external view returns (address owner);
945 
946     /**
947      * @dev Safely transfers `tokenId` token from `from` to `to`,
948      * checking first that contract recipients are aware of the ERC721 protocol
949      * to prevent tokens from being forever locked.
950      *
951      * Requirements:
952      *
953      * - `from` cannot be the zero address.
954      * - `to` cannot be the zero address.
955      * - `tokenId` token must exist and be owned by `from`.
956      * - If the caller is not `from`, it must be have been allowed to move
957      * this token by either {approve} or {setApprovalForAll}.
958      * - If `to` refers to a smart contract, it must implement
959      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
960      *
961      * Emits a {Transfer} event.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes calldata data
968     ) external payable;
969 
970     /**
971      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
972      */
973     function safeTransferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) external payable;
978 
979     /**
980      * @dev Transfers `tokenId` from `from` to `to`.
981      *
982      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
983      * whenever possible.
984      *
985      * Requirements:
986      *
987      * - `from` cannot be the zero address.
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must be owned by `from`.
990      * - If the caller is not `from`, it must be approved to move this token
991      * by either {approve} or {setApprovalForAll}.
992      *
993      * Emits a {Transfer} event.
994      */
995     function transferFrom(
996         address from,
997         address to,
998         uint256 tokenId
999     ) external payable;
1000 
1001     /**
1002      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1003      * The approval is cleared when the token is transferred.
1004      *
1005      * Only a single account can be approved at a time, so approving the
1006      * zero address clears previous approvals.
1007      *
1008      * Requirements:
1009      *
1010      * - The caller must own the token or be an approved operator.
1011      * - `tokenId` must exist.
1012      *
1013      * Emits an {Approval} event.
1014      */
1015     function approve(address to, uint256 tokenId) external payable;
1016 
1017     /**
1018      * @dev Approve or remove `operator` as an operator for the caller.
1019      * Operators can call {transferFrom} or {safeTransferFrom}
1020      * for any token owned by the caller.
1021      *
1022      * Requirements:
1023      *
1024      * - The `operator` cannot be the caller.
1025      *
1026      * Emits an {ApprovalForAll} event.
1027      */
1028     function setApprovalForAll(address operator, bool _approved) external;
1029 
1030     /**
1031      * @dev Returns the account approved for `tokenId` token.
1032      *
1033      * Requirements:
1034      *
1035      * - `tokenId` must exist.
1036      */
1037     function getApproved(uint256 tokenId) external view returns (address operator);
1038 
1039     /**
1040      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1041      *
1042      * See {setApprovalForAll}.
1043      */
1044     function isApprovedForAll(address owner, address operator) external view returns (bool);
1045 
1046     // =============================================================
1047     //                        IERC721Metadata
1048     // =============================================================
1049 
1050     /**
1051      * @dev Returns the token collection name.
1052      */
1053     function name() external view returns (string memory);
1054 
1055     /**
1056      * @dev Returns the token collection symbol.
1057      */
1058     function symbol() external view returns (string memory);
1059 
1060     /**
1061      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1062      */
1063     function tokenURI(uint256 tokenId) external view returns (string memory);
1064 
1065     // =============================================================
1066     //                           IERC2309
1067     // =============================================================
1068 
1069     /**
1070      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1071      * (inclusive) is transferred from `from` to `to`, as defined in the
1072      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1073      *
1074      * See {_mintERC2309} for more details.
1075      */
1076     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1077 }
1078 
1079 // File: erc721a/contracts/ERC721A.sol
1080 
1081 
1082 // ERC721A Contracts v4.2.3
1083 // Creator: Chiru Labs
1084 
1085 pragma solidity ^0.8.4;
1086 
1087 
1088 /**
1089  * @dev Interface of ERC721 token receiver.
1090  */
1091 interface ERC721A__IERC721Receiver {
1092     function onERC721Received(
1093         address operator,
1094         address from,
1095         uint256 tokenId,
1096         bytes calldata data
1097     ) external returns (bytes4);
1098 }
1099 
1100 /**
1101  * @title ERC721A
1102  *
1103  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1104  * Non-Fungible Token Standard, including the Metadata extension.
1105  * Optimized for lower gas during batch mints.
1106  *
1107  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1108  * starting from `_startTokenId()`.
1109  *
1110  * Assumptions:
1111  *
1112  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1113  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1114  */
1115 contract ERC721A is IERC721A {
1116     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1117     struct TokenApprovalRef {
1118         address value;
1119     }
1120 
1121     // =============================================================
1122     //                           CONSTANTS
1123     // =============================================================
1124 
1125     // Mask of an entry in packed address data.
1126     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1127 
1128     // The bit position of `numberMinted` in packed address data.
1129     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1130 
1131     // The bit position of `numberBurned` in packed address data.
1132     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1133 
1134     // The bit position of `aux` in packed address data.
1135     uint256 private constant _BITPOS_AUX = 192;
1136 
1137     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1138     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1139 
1140     // The bit position of `startTimestamp` in packed ownership.
1141     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1142 
1143     // The bit mask of the `burned` bit in packed ownership.
1144     uint256 private constant _BITMASK_BURNED = 1 << 224;
1145 
1146     // The bit position of the `nextInitialized` bit in packed ownership.
1147     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1148 
1149     // The bit mask of the `nextInitialized` bit in packed ownership.
1150     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1151 
1152     // The bit position of `extraData` in packed ownership.
1153     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1154 
1155     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1156     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1157 
1158     // The mask of the lower 160 bits for addresses.
1159     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1160 
1161     // The maximum `quantity` that can be minted with {_mintERC2309}.
1162     // This limit is to prevent overflows on the address data entries.
1163     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1164     // is required to cause an overflow, which is unrealistic.
1165     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1166 
1167     // The `Transfer` event signature is given by:
1168     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1169     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1170         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1171 
1172     // =============================================================
1173     //                            STORAGE
1174     // =============================================================
1175 
1176     // The next token ID to be minted.
1177     uint256 private _currentIndex;
1178 
1179     // The number of tokens burned.
1180     uint256 private _burnCounter;
1181 
1182     // Token name
1183     string private _name;
1184 
1185     // Token symbol
1186     string private _symbol;
1187 
1188     // Mapping from token ID to ownership details
1189     // An empty struct value does not necessarily mean the token is unowned.
1190     // See {_packedOwnershipOf} implementation for details.
1191     //
1192     // Bits Layout:
1193     // - [0..159]   `addr`
1194     // - [160..223] `startTimestamp`
1195     // - [224]      `burned`
1196     // - [225]      `nextInitialized`
1197     // - [232..255] `extraData`
1198     mapping(uint256 => uint256) private _packedOwnerships;
1199 
1200     // Mapping owner address to address data.
1201     //
1202     // Bits Layout:
1203     // - [0..63]    `balance`
1204     // - [64..127]  `numberMinted`
1205     // - [128..191] `numberBurned`
1206     // - [192..255] `aux`
1207     mapping(address => uint256) private _packedAddressData;
1208 
1209     // Mapping from token ID to approved address.
1210     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1211 
1212     // Mapping from owner to operator approvals
1213     mapping(address => mapping(address => bool)) private _operatorApprovals;
1214 
1215     // =============================================================
1216     //                          CONSTRUCTOR
1217     // =============================================================
1218 
1219     constructor(string memory name_, string memory symbol_) {
1220         _name = name_;
1221         _symbol = symbol_;
1222         _currentIndex = _startTokenId();
1223     }
1224 
1225     // =============================================================
1226     //                   TOKEN COUNTING OPERATIONS
1227     // =============================================================
1228 
1229     /**
1230      * @dev Returns the starting token ID.
1231      * To change the starting token ID, please override this function.
1232      */
1233     function _startTokenId() internal view virtual returns (uint256) {
1234         return 0;
1235     }
1236 
1237     /**
1238      * @dev Returns the next token ID to be minted.
1239      */
1240     function _nextTokenId() internal view virtual returns (uint256) {
1241         return _currentIndex;
1242     }
1243 
1244     /**
1245      * @dev Returns the total number of tokens in existence.
1246      * Burned tokens will reduce the count.
1247      * To get the total number of tokens minted, please see {_totalMinted}.
1248      */
1249     function totalSupply() public view virtual override returns (uint256) {
1250         // Counter underflow is impossible as _burnCounter cannot be incremented
1251         // more than `_currentIndex - _startTokenId()` times.
1252         unchecked {
1253             return _currentIndex - _burnCounter - _startTokenId();
1254         }
1255     }
1256 
1257     /**
1258      * @dev Returns the total amount of tokens minted in the contract.
1259      */
1260     function _totalMinted() internal view virtual returns (uint256) {
1261         // Counter underflow is impossible as `_currentIndex` does not decrement,
1262         // and it is initialized to `_startTokenId()`.
1263         unchecked {
1264             return _currentIndex - _startTokenId();
1265         }
1266     }
1267 
1268     /**
1269      * @dev Returns the total number of tokens burned.
1270      */
1271     function _totalBurned() internal view virtual returns (uint256) {
1272         return _burnCounter;
1273     }
1274 
1275     // =============================================================
1276     //                    ADDRESS DATA OPERATIONS
1277     // =============================================================
1278 
1279     /**
1280      * @dev Returns the number of tokens in `owner`'s account.
1281      */
1282     function balanceOf(address owner) public view virtual override returns (uint256) {
1283         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1284         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1285     }
1286 
1287     /**
1288      * Returns the number of tokens minted by `owner`.
1289      */
1290     function _numberMinted(address owner) internal view returns (uint256) {
1291         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1292     }
1293 
1294     /**
1295      * Returns the number of tokens burned by or on behalf of `owner`.
1296      */
1297     function _numberBurned(address owner) internal view returns (uint256) {
1298         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1299     }
1300 
1301     /**
1302      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1303      */
1304     function _getAux(address owner) internal view returns (uint64) {
1305         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1306     }
1307 
1308     /**
1309      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1310      * If there are multiple variables, please pack them into a uint64.
1311      */
1312     function _setAux(address owner, uint64 aux) internal virtual {
1313         uint256 packed = _packedAddressData[owner];
1314         uint256 auxCasted;
1315         // Cast `aux` with assembly to avoid redundant masking.
1316         assembly {
1317             auxCasted := aux
1318         }
1319         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1320         _packedAddressData[owner] = packed;
1321     }
1322 
1323     // =============================================================
1324     //                            IERC165
1325     // =============================================================
1326 
1327     /**
1328      * @dev Returns true if this contract implements the interface defined by
1329      * `interfaceId`. See the corresponding
1330      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1331      * to learn more about how these ids are created.
1332      *
1333      * This function call must use less than 30000 gas.
1334      */
1335     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1336         // The interface IDs are constants representing the first 4 bytes
1337         // of the XOR of all function selectors in the interface.
1338         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1339         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1340         return
1341             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1342             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1343             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1344     }
1345 
1346     // =============================================================
1347     //                        IERC721Metadata
1348     // =============================================================
1349 
1350     /**
1351      * @dev Returns the token collection name.
1352      */
1353     function name() public view virtual override returns (string memory) {
1354         return _name;
1355     }
1356 
1357     /**
1358      * @dev Returns the token collection symbol.
1359      */
1360     function symbol() public view virtual override returns (string memory) {
1361         return _symbol;
1362     }
1363 
1364     /**
1365      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1366      */
1367     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1368         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1369 
1370         string memory baseURI = _baseURI();
1371         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1372     }
1373 
1374     /**
1375      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1376      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1377      * by default, it can be overridden in child contracts.
1378      */
1379     function _baseURI() internal view virtual returns (string memory) {
1380         return '';
1381     }
1382 
1383     // =============================================================
1384     //                     OWNERSHIPS OPERATIONS
1385     // =============================================================
1386 
1387     /**
1388      * @dev Returns the owner of the `tokenId` token.
1389      *
1390      * Requirements:
1391      *
1392      * - `tokenId` must exist.
1393      */
1394     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1395         return address(uint160(_packedOwnershipOf(tokenId)));
1396     }
1397 
1398     /**
1399      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1400      * It gradually moves to O(1) as tokens get transferred around over time.
1401      */
1402     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1403         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1404     }
1405 
1406     /**
1407      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1408      */
1409     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1410         return _unpackedOwnership(_packedOwnerships[index]);
1411     }
1412 
1413     /**
1414      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1415      */
1416     function _initializeOwnershipAt(uint256 index) internal virtual {
1417         if (_packedOwnerships[index] == 0) {
1418             _packedOwnerships[index] = _packedOwnershipOf(index);
1419         }
1420     }
1421 
1422     /**
1423      * Returns the packed ownership data of `tokenId`.
1424      */
1425     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1426         uint256 curr = tokenId;
1427 
1428         unchecked {
1429             if (_startTokenId() <= curr)
1430                 if (curr < _currentIndex) {
1431                     uint256 packed = _packedOwnerships[curr];
1432                     // If not burned.
1433                     if (packed & _BITMASK_BURNED == 0) {
1434                         // Invariant:
1435                         // There will always be an initialized ownership slot
1436                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1437                         // before an unintialized ownership slot
1438                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1439                         // Hence, `curr` will not underflow.
1440                         //
1441                         // We can directly compare the packed value.
1442                         // If the address is zero, packed will be zero.
1443                         while (packed == 0) {
1444                             packed = _packedOwnerships[--curr];
1445                         }
1446                         return packed;
1447                     }
1448                 }
1449         }
1450         revert OwnerQueryForNonexistentToken();
1451     }
1452 
1453     /**
1454      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1455      */
1456     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1457         ownership.addr = address(uint160(packed));
1458         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1459         ownership.burned = packed & _BITMASK_BURNED != 0;
1460         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1461     }
1462 
1463     /**
1464      * @dev Packs ownership data into a single uint256.
1465      */
1466     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1467         assembly {
1468             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1469             owner := and(owner, _BITMASK_ADDRESS)
1470             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1471             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1472         }
1473     }
1474 
1475     /**
1476      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1477      */
1478     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1479         // For branchless setting of the `nextInitialized` flag.
1480         assembly {
1481             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1482             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1483         }
1484     }
1485 
1486     // =============================================================
1487     //                      APPROVAL OPERATIONS
1488     // =============================================================
1489 
1490     /**
1491      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1492      * The approval is cleared when the token is transferred.
1493      *
1494      * Only a single account can be approved at a time, so approving the
1495      * zero address clears previous approvals.
1496      *
1497      * Requirements:
1498      *
1499      * - The caller must own the token or be an approved operator.
1500      * - `tokenId` must exist.
1501      *
1502      * Emits an {Approval} event.
1503      */
1504     function approve(address to, uint256 tokenId) public payable virtual override {
1505         address owner = ownerOf(tokenId);
1506 
1507         if (_msgSenderERC721A() != owner)
1508             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1509                 revert ApprovalCallerNotOwnerNorApproved();
1510             }
1511 
1512         _tokenApprovals[tokenId].value = to;
1513         emit Approval(owner, to, tokenId);
1514     }
1515 
1516     /**
1517      * @dev Returns the account approved for `tokenId` token.
1518      *
1519      * Requirements:
1520      *
1521      * - `tokenId` must exist.
1522      */
1523     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1524         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1525 
1526         return _tokenApprovals[tokenId].value;
1527     }
1528 
1529     /**
1530      * @dev Approve or remove `operator` as an operator for the caller.
1531      * Operators can call {transferFrom} or {safeTransferFrom}
1532      * for any token owned by the caller.
1533      *
1534      * Requirements:
1535      *
1536      * - The `operator` cannot be the caller.
1537      *
1538      * Emits an {ApprovalForAll} event.
1539      */
1540     function setApprovalForAll(address operator, bool approved) public virtual override {
1541         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1542         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1543     }
1544 
1545     /**
1546      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1547      *
1548      * See {setApprovalForAll}.
1549      */
1550     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1551         return _operatorApprovals[owner][operator];
1552     }
1553 
1554     /**
1555      * @dev Returns whether `tokenId` exists.
1556      *
1557      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1558      *
1559      * Tokens start existing when they are minted. See {_mint}.
1560      */
1561     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1562         return
1563             _startTokenId() <= tokenId &&
1564             tokenId < _currentIndex && // If within bounds,
1565             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1566     }
1567 
1568     /**
1569      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1570      */
1571     function _isSenderApprovedOrOwner(
1572         address approvedAddress,
1573         address owner,
1574         address msgSender
1575     ) private pure returns (bool result) {
1576         assembly {
1577             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1578             owner := and(owner, _BITMASK_ADDRESS)
1579             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1580             msgSender := and(msgSender, _BITMASK_ADDRESS)
1581             // `msgSender == owner || msgSender == approvedAddress`.
1582             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1583         }
1584     }
1585 
1586     /**
1587      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1588      */
1589     function _getApprovedSlotAndAddress(uint256 tokenId)
1590         private
1591         view
1592         returns (uint256 approvedAddressSlot, address approvedAddress)
1593     {
1594         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1595         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1596         assembly {
1597             approvedAddressSlot := tokenApproval.slot
1598             approvedAddress := sload(approvedAddressSlot)
1599         }
1600     }
1601 
1602     // =============================================================
1603     //                      TRANSFER OPERATIONS
1604     // =============================================================
1605 
1606     /**
1607      * @dev Transfers `tokenId` from `from` to `to`.
1608      *
1609      * Requirements:
1610      *
1611      * - `from` cannot be the zero address.
1612      * - `to` cannot be the zero address.
1613      * - `tokenId` token must be owned by `from`.
1614      * - If the caller is not `from`, it must be approved to move this token
1615      * by either {approve} or {setApprovalForAll}.
1616      *
1617      * Emits a {Transfer} event.
1618      */
1619     function transferFrom(
1620         address from,
1621         address to,
1622         uint256 tokenId
1623     ) public payable virtual override {
1624         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1625 
1626         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1627 
1628         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1629 
1630         // The nested ifs save around 20+ gas over a compound boolean condition.
1631         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1632             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1633 
1634         if (to == address(0)) revert TransferToZeroAddress();
1635 
1636         _beforeTokenTransfers(from, to, tokenId, 1);
1637 
1638         // Clear approvals from the previous owner.
1639         assembly {
1640             if approvedAddress {
1641                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1642                 sstore(approvedAddressSlot, 0)
1643             }
1644         }
1645 
1646         // Underflow of the sender's balance is impossible because we check for
1647         // ownership above and the recipient's balance can't realistically overflow.
1648         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1649         unchecked {
1650             // We can directly increment and decrement the balances.
1651             --_packedAddressData[from]; // Updates: `balance -= 1`.
1652             ++_packedAddressData[to]; // Updates: `balance += 1`.
1653 
1654             // Updates:
1655             // - `address` to the next owner.
1656             // - `startTimestamp` to the timestamp of transfering.
1657             // - `burned` to `false`.
1658             // - `nextInitialized` to `true`.
1659             _packedOwnerships[tokenId] = _packOwnershipData(
1660                 to,
1661                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1662             );
1663 
1664             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1665             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1666                 uint256 nextTokenId = tokenId + 1;
1667                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1668                 if (_packedOwnerships[nextTokenId] == 0) {
1669                     // If the next slot is within bounds.
1670                     if (nextTokenId != _currentIndex) {
1671                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1672                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1673                     }
1674                 }
1675             }
1676         }
1677 
1678         emit Transfer(from, to, tokenId);
1679         _afterTokenTransfers(from, to, tokenId, 1);
1680     }
1681 
1682     /**
1683      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1684      */
1685     function safeTransferFrom(
1686         address from,
1687         address to,
1688         uint256 tokenId
1689     ) public payable virtual override {
1690         safeTransferFrom(from, to, tokenId, '');
1691     }
1692 
1693     /**
1694      * @dev Safely transfers `tokenId` token from `from` to `to`.
1695      *
1696      * Requirements:
1697      *
1698      * - `from` cannot be the zero address.
1699      * - `to` cannot be the zero address.
1700      * - `tokenId` token must exist and be owned by `from`.
1701      * - If the caller is not `from`, it must be approved to move this token
1702      * by either {approve} or {setApprovalForAll}.
1703      * - If `to` refers to a smart contract, it must implement
1704      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1705      *
1706      * Emits a {Transfer} event.
1707      */
1708     function safeTransferFrom(
1709         address from,
1710         address to,
1711         uint256 tokenId,
1712         bytes memory _data
1713     ) public payable virtual override {
1714         transferFrom(from, to, tokenId);
1715         if (to.code.length != 0)
1716             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1717                 revert TransferToNonERC721ReceiverImplementer();
1718             }
1719     }
1720 
1721     /**
1722      * @dev Hook that is called before a set of serially-ordered token IDs
1723      * are about to be transferred. This includes minting.
1724      * And also called before burning one token.
1725      *
1726      * `startTokenId` - the first token ID to be transferred.
1727      * `quantity` - the amount to be transferred.
1728      *
1729      * Calling conditions:
1730      *
1731      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1732      * transferred to `to`.
1733      * - When `from` is zero, `tokenId` will be minted for `to`.
1734      * - When `to` is zero, `tokenId` will be burned by `from`.
1735      * - `from` and `to` are never both zero.
1736      */
1737     function _beforeTokenTransfers(
1738         address from,
1739         address to,
1740         uint256 startTokenId,
1741         uint256 quantity
1742     ) internal virtual {}
1743 
1744     /**
1745      * @dev Hook that is called after a set of serially-ordered token IDs
1746      * have been transferred. This includes minting.
1747      * And also called after one token has been burned.
1748      *
1749      * `startTokenId` - the first token ID to be transferred.
1750      * `quantity` - the amount to be transferred.
1751      *
1752      * Calling conditions:
1753      *
1754      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1755      * transferred to `to`.
1756      * - When `from` is zero, `tokenId` has been minted for `to`.
1757      * - When `to` is zero, `tokenId` has been burned by `from`.
1758      * - `from` and `to` are never both zero.
1759      */
1760     function _afterTokenTransfers(
1761         address from,
1762         address to,
1763         uint256 startTokenId,
1764         uint256 quantity
1765     ) internal virtual {}
1766 
1767     /**
1768      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1769      *
1770      * `from` - Previous owner of the given token ID.
1771      * `to` - Target address that will receive the token.
1772      * `tokenId` - Token ID to be transferred.
1773      * `_data` - Optional data to send along with the call.
1774      *
1775      * Returns whether the call correctly returned the expected magic value.
1776      */
1777     function _checkContractOnERC721Received(
1778         address from,
1779         address to,
1780         uint256 tokenId,
1781         bytes memory _data
1782     ) private returns (bool) {
1783         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1784             bytes4 retval
1785         ) {
1786             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1787         } catch (bytes memory reason) {
1788             if (reason.length == 0) {
1789                 revert TransferToNonERC721ReceiverImplementer();
1790             } else {
1791                 assembly {
1792                     revert(add(32, reason), mload(reason))
1793                 }
1794             }
1795         }
1796     }
1797 
1798     // =============================================================
1799     //                        MINT OPERATIONS
1800     // =============================================================
1801 
1802     /**
1803      * @dev Mints `quantity` tokens and transfers them to `to`.
1804      *
1805      * Requirements:
1806      *
1807      * - `to` cannot be the zero address.
1808      * - `quantity` must be greater than 0.
1809      *
1810      * Emits a {Transfer} event for each mint.
1811      */
1812     function _mint(address to, uint256 quantity) internal virtual {
1813         uint256 startTokenId = _currentIndex;
1814         if (quantity == 0) revert MintZeroQuantity();
1815 
1816         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1817 
1818         // Overflows are incredibly unrealistic.
1819         // `balance` and `numberMinted` have a maximum limit of 2**64.
1820         // `tokenId` has a maximum limit of 2**256.
1821         unchecked {
1822             // Updates:
1823             // - `balance += quantity`.
1824             // - `numberMinted += quantity`.
1825             //
1826             // We can directly add to the `balance` and `numberMinted`.
1827             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1828 
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
1839             uint256 toMasked;
1840             uint256 end = startTokenId + quantity;
1841 
1842             // Use assembly to loop and emit the `Transfer` event for gas savings.
1843             // The duplicated `log4` removes an extra check and reduces stack juggling.
1844             // The assembly, together with the surrounding Solidity code, have been
1845             // delicately arranged to nudge the compiler into producing optimized opcodes.
1846             assembly {
1847                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1848                 toMasked := and(to, _BITMASK_ADDRESS)
1849                 // Emit the `Transfer` event.
1850                 log4(
1851                     0, // Start of data (0, since no data).
1852                     0, // End of data (0, since no data).
1853                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1854                     0, // `address(0)`.
1855                     toMasked, // `to`.
1856                     startTokenId // `tokenId`.
1857                 )
1858 
1859                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1860                 // that overflows uint256 will make the loop run out of gas.
1861                 // The compiler will optimize the `iszero` away for performance.
1862                 for {
1863                     let tokenId := add(startTokenId, 1)
1864                 } iszero(eq(tokenId, end)) {
1865                     tokenId := add(tokenId, 1)
1866                 } {
1867                     // Emit the `Transfer` event. Similar to above.
1868                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1869                 }
1870             }
1871             if (toMasked == 0) revert MintToZeroAddress();
1872 
1873             _currentIndex = end;
1874         }
1875         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1876     }
1877 
1878     /**
1879      * @dev Mints `quantity` tokens and transfers them to `to`.
1880      *
1881      * This function is intended for efficient minting only during contract creation.
1882      *
1883      * It emits only one {ConsecutiveTransfer} as defined in
1884      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1885      * instead of a sequence of {Transfer} event(s).
1886      *
1887      * Calling this function outside of contract creation WILL make your contract
1888      * non-compliant with the ERC721 standard.
1889      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1890      * {ConsecutiveTransfer} event is only permissible during contract creation.
1891      *
1892      * Requirements:
1893      *
1894      * - `to` cannot be the zero address.
1895      * - `quantity` must be greater than 0.
1896      *
1897      * Emits a {ConsecutiveTransfer} event.
1898      */
1899     function _mintERC2309(address to, uint256 quantity) internal virtual {
1900         uint256 startTokenId = _currentIndex;
1901         if (to == address(0)) revert MintToZeroAddress();
1902         if (quantity == 0) revert MintZeroQuantity();
1903         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1904 
1905         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1906 
1907         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1908         unchecked {
1909             // Updates:
1910             // - `balance += quantity`.
1911             // - `numberMinted += quantity`.
1912             //
1913             // We can directly add to the `balance` and `numberMinted`.
1914             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1915 
1916             // Updates:
1917             // - `address` to the owner.
1918             // - `startTimestamp` to the timestamp of minting.
1919             // - `burned` to `false`.
1920             // - `nextInitialized` to `quantity == 1`.
1921             _packedOwnerships[startTokenId] = _packOwnershipData(
1922                 to,
1923                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1924             );
1925 
1926             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1927 
1928             _currentIndex = startTokenId + quantity;
1929         }
1930         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1931     }
1932 
1933     /**
1934      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1935      *
1936      * Requirements:
1937      *
1938      * - If `to` refers to a smart contract, it must implement
1939      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1940      * - `quantity` must be greater than 0.
1941      *
1942      * See {_mint}.
1943      *
1944      * Emits a {Transfer} event for each mint.
1945      */
1946     function _safeMint(
1947         address to,
1948         uint256 quantity,
1949         bytes memory _data
1950     ) internal virtual {
1951         _mint(to, quantity);
1952 
1953         unchecked {
1954             if (to.code.length != 0) {
1955                 uint256 end = _currentIndex;
1956                 uint256 index = end - quantity;
1957                 do {
1958                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1959                         revert TransferToNonERC721ReceiverImplementer();
1960                     }
1961                 } while (index < end);
1962                 // Reentrancy protection.
1963                 if (_currentIndex != end) revert();
1964             }
1965         }
1966     }
1967 
1968     /**
1969      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1970      */
1971     function _safeMint(address to, uint256 quantity) internal virtual {
1972         _safeMint(to, quantity, '');
1973     }
1974 
1975     // =============================================================
1976     //                        BURN OPERATIONS
1977     // =============================================================
1978 
1979     /**
1980      * @dev Equivalent to `_burn(tokenId, false)`.
1981      */
1982     function _burn(uint256 tokenId) internal virtual {
1983         _burn(tokenId, false);
1984     }
1985 
1986     /**
1987      * @dev Destroys `tokenId`.
1988      * The approval is cleared when the token is burned.
1989      *
1990      * Requirements:
1991      *
1992      * - `tokenId` must exist.
1993      *
1994      * Emits a {Transfer} event.
1995      */
1996     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1997         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1998 
1999         address from = address(uint160(prevOwnershipPacked));
2000 
2001         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2002 
2003         if (approvalCheck) {
2004             // The nested ifs save around 20+ gas over a compound boolean condition.
2005             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2006                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2007         }
2008 
2009         _beforeTokenTransfers(from, address(0), tokenId, 1);
2010 
2011         // Clear approvals from the previous owner.
2012         assembly {
2013             if approvedAddress {
2014                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2015                 sstore(approvedAddressSlot, 0)
2016             }
2017         }
2018 
2019         // Underflow of the sender's balance is impossible because we check for
2020         // ownership above and the recipient's balance can't realistically overflow.
2021         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2022         unchecked {
2023             // Updates:
2024             // - `balance -= 1`.
2025             // - `numberBurned += 1`.
2026             //
2027             // We can directly decrement the balance, and increment the number burned.
2028             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2029             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2030 
2031             // Updates:
2032             // - `address` to the last owner.
2033             // - `startTimestamp` to the timestamp of burning.
2034             // - `burned` to `true`.
2035             // - `nextInitialized` to `true`.
2036             _packedOwnerships[tokenId] = _packOwnershipData(
2037                 from,
2038                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2039             );
2040 
2041             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2042             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2043                 uint256 nextTokenId = tokenId + 1;
2044                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2045                 if (_packedOwnerships[nextTokenId] == 0) {
2046                     // If the next slot is within bounds.
2047                     if (nextTokenId != _currentIndex) {
2048                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2049                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2050                     }
2051                 }
2052             }
2053         }
2054 
2055         emit Transfer(from, address(0), tokenId);
2056         _afterTokenTransfers(from, address(0), tokenId, 1);
2057 
2058         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2059         unchecked {
2060             _burnCounter++;
2061         }
2062     }
2063 
2064     // =============================================================
2065     //                     EXTRA DATA OPERATIONS
2066     // =============================================================
2067 
2068     /**
2069      * @dev Directly sets the extra data for the ownership data `index`.
2070      */
2071     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2072         uint256 packed = _packedOwnerships[index];
2073         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2074         uint256 extraDataCasted;
2075         // Cast `extraData` with assembly to avoid redundant masking.
2076         assembly {
2077             extraDataCasted := extraData
2078         }
2079         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2080         _packedOwnerships[index] = packed;
2081     }
2082 
2083     /**
2084      * @dev Called during each token transfer to set the 24bit `extraData` field.
2085      * Intended to be overridden by the cosumer contract.
2086      *
2087      * `previousExtraData` - the value of `extraData` before transfer.
2088      *
2089      * Calling conditions:
2090      *
2091      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2092      * transferred to `to`.
2093      * - When `from` is zero, `tokenId` will be minted for `to`.
2094      * - When `to` is zero, `tokenId` will be burned by `from`.
2095      * - `from` and `to` are never both zero.
2096      */
2097     function _extraData(
2098         address from,
2099         address to,
2100         uint24 previousExtraData
2101     ) internal view virtual returns (uint24) {}
2102 
2103     /**
2104      * @dev Returns the next extra data for the packed ownership data.
2105      * The returned result is shifted into position.
2106      */
2107     function _nextExtraData(
2108         address from,
2109         address to,
2110         uint256 prevOwnershipPacked
2111     ) private view returns (uint256) {
2112         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2113         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2114     }
2115 
2116     // =============================================================
2117     //                       OTHER OPERATIONS
2118     // =============================================================
2119 
2120     /**
2121      * @dev Returns the message sender (defaults to `msg.sender`).
2122      *
2123      * If you are writing GSN compatible contracts, you need to override this function.
2124      */
2125     function _msgSenderERC721A() internal view virtual returns (address) {
2126         return msg.sender;
2127     }
2128 
2129     /**
2130      * @dev Converts a uint256 to its ASCII string decimal representation.
2131      */
2132     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2133         assembly {
2134             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2135             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2136             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2137             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2138             let m := add(mload(0x40), 0xa0)
2139             // Update the free memory pointer to allocate.
2140             mstore(0x40, m)
2141             // Assign the `str` to the end.
2142             str := sub(m, 0x20)
2143             // Zeroize the slot after the string.
2144             mstore(str, 0)
2145 
2146             // Cache the end of the memory to calculate the length later.
2147             let end := str
2148 
2149             // We write the string from rightmost digit to leftmost digit.
2150             // The following is essentially a do-while loop that also handles the zero case.
2151             // prettier-ignore
2152             for { let temp := value } 1 {} {
2153                 str := sub(str, 1)
2154                 // Write the character to the pointer.
2155                 // The ASCII index of the '0' character is 48.
2156                 mstore8(str, add(48, mod(temp, 10)))
2157                 // Keep dividing `temp` until zero.
2158                 temp := div(temp, 10)
2159                 // prettier-ignore
2160                 if iszero(temp) { break }
2161             }
2162 
2163             let length := sub(end, str)
2164             // Move the pointer 32 bytes leftwards to make room for the length.
2165             str := sub(str, 0x20)
2166             // Store the length.
2167             mstore(str, length)
2168         }
2169     }
2170 }
2171 
2172 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
2173 
2174 
2175 // ERC721A Contracts v4.2.3
2176 // Creator: Chiru Labs
2177 
2178 pragma solidity ^0.8.4;
2179 
2180 
2181 /**
2182  * @dev Interface of ERC721AQueryable.
2183  */
2184 interface IERC721AQueryable is IERC721A {
2185     /**
2186      * Invalid query range (`start` >= `stop`).
2187      */
2188     error InvalidQueryRange();
2189 
2190     /**
2191      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2192      *
2193      * If the `tokenId` is out of bounds:
2194      *
2195      * - `addr = address(0)`
2196      * - `startTimestamp = 0`
2197      * - `burned = false`
2198      * - `extraData = 0`
2199      *
2200      * If the `tokenId` is burned:
2201      *
2202      * - `addr = <Address of owner before token was burned>`
2203      * - `startTimestamp = <Timestamp when token was burned>`
2204      * - `burned = true`
2205      * - `extraData = <Extra data when token was burned>`
2206      *
2207      * Otherwise:
2208      *
2209      * - `addr = <Address of owner>`
2210      * - `startTimestamp = <Timestamp of start of ownership>`
2211      * - `burned = false`
2212      * - `extraData = <Extra data at start of ownership>`
2213      */
2214     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2215 
2216     /**
2217      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2218      * See {ERC721AQueryable-explicitOwnershipOf}
2219      */
2220     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2221 
2222     /**
2223      * @dev Returns an array of token IDs owned by `owner`,
2224      * in the range [`start`, `stop`)
2225      * (i.e. `start <= tokenId < stop`).
2226      *
2227      * This function allows for tokens to be queried if the collection
2228      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2229      *
2230      * Requirements:
2231      *
2232      * - `start < stop`
2233      */
2234     function tokensOfOwnerIn(
2235         address owner,
2236         uint256 start,
2237         uint256 stop
2238     ) external view returns (uint256[] memory);
2239 
2240     /**
2241      * @dev Returns an array of token IDs owned by `owner`.
2242      *
2243      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2244      * It is meant to be called off-chain.
2245      *
2246      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2247      * multiple smaller scans if the collection is large enough to cause
2248      * an out-of-gas error (10K collections should be fine).
2249      */
2250     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2251 }
2252 
2253 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2254 
2255 
2256 // ERC721A Contracts v4.2.3
2257 // Creator: Chiru Labs
2258 
2259 pragma solidity ^0.8.4;
2260 
2261 
2262 
2263 /**
2264  * @title ERC721AQueryable.
2265  *
2266  * @dev ERC721A subclass with convenience query functions.
2267  */
2268 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2269     /**
2270      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2271      *
2272      * If the `tokenId` is out of bounds:
2273      *
2274      * - `addr = address(0)`
2275      * - `startTimestamp = 0`
2276      * - `burned = false`
2277      * - `extraData = 0`
2278      *
2279      * If the `tokenId` is burned:
2280      *
2281      * - `addr = <Address of owner before token was burned>`
2282      * - `startTimestamp = <Timestamp when token was burned>`
2283      * - `burned = true`
2284      * - `extraData = <Extra data when token was burned>`
2285      *
2286      * Otherwise:
2287      *
2288      * - `addr = <Address of owner>`
2289      * - `startTimestamp = <Timestamp of start of ownership>`
2290      * - `burned = false`
2291      * - `extraData = <Extra data at start of ownership>`
2292      */
2293     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2294         TokenOwnership memory ownership;
2295         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2296             return ownership;
2297         }
2298         ownership = _ownershipAt(tokenId);
2299         if (ownership.burned) {
2300             return ownership;
2301         }
2302         return _ownershipOf(tokenId);
2303     }
2304 
2305     /**
2306      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2307      * See {ERC721AQueryable-explicitOwnershipOf}
2308      */
2309     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2310         external
2311         view
2312         virtual
2313         override
2314         returns (TokenOwnership[] memory)
2315     {
2316         unchecked {
2317             uint256 tokenIdsLength = tokenIds.length;
2318             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2319             for (uint256 i; i != tokenIdsLength; ++i) {
2320                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2321             }
2322             return ownerships;
2323         }
2324     }
2325 
2326     /**
2327      * @dev Returns an array of token IDs owned by `owner`,
2328      * in the range [`start`, `stop`)
2329      * (i.e. `start <= tokenId < stop`).
2330      *
2331      * This function allows for tokens to be queried if the collection
2332      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2333      *
2334      * Requirements:
2335      *
2336      * - `start < stop`
2337      */
2338     function tokensOfOwnerIn(
2339         address owner,
2340         uint256 start,
2341         uint256 stop
2342     ) external view virtual override returns (uint256[] memory) {
2343         unchecked {
2344             if (start >= stop) revert InvalidQueryRange();
2345             uint256 tokenIdsIdx;
2346             uint256 stopLimit = _nextTokenId();
2347             // Set `start = max(start, _startTokenId())`.
2348             if (start < _startTokenId()) {
2349                 start = _startTokenId();
2350             }
2351             // Set `stop = min(stop, stopLimit)`.
2352             if (stop > stopLimit) {
2353                 stop = stopLimit;
2354             }
2355             uint256 tokenIdsMaxLength = balanceOf(owner);
2356             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2357             // to cater for cases where `balanceOf(owner)` is too big.
2358             if (start < stop) {
2359                 uint256 rangeLength = stop - start;
2360                 if (rangeLength < tokenIdsMaxLength) {
2361                     tokenIdsMaxLength = rangeLength;
2362                 }
2363             } else {
2364                 tokenIdsMaxLength = 0;
2365             }
2366             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2367             if (tokenIdsMaxLength == 0) {
2368                 return tokenIds;
2369             }
2370             // We need to call `explicitOwnershipOf(start)`,
2371             // because the slot at `start` may not be initialized.
2372             TokenOwnership memory ownership = explicitOwnershipOf(start);
2373             address currOwnershipAddr;
2374             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2375             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2376             if (!ownership.burned) {
2377                 currOwnershipAddr = ownership.addr;
2378             }
2379             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2380                 ownership = _ownershipAt(i);
2381                 if (ownership.burned) {
2382                     continue;
2383                 }
2384                 if (ownership.addr != address(0)) {
2385                     currOwnershipAddr = ownership.addr;
2386                 }
2387                 if (currOwnershipAddr == owner) {
2388                     tokenIds[tokenIdsIdx++] = i;
2389                 }
2390             }
2391             // Downsize the array to fit.
2392             assembly {
2393                 mstore(tokenIds, tokenIdsIdx)
2394             }
2395             return tokenIds;
2396         }
2397     }
2398 
2399     /**
2400      * @dev Returns an array of token IDs owned by `owner`.
2401      *
2402      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2403      * It is meant to be called off-chain.
2404      *
2405      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2406      * multiple smaller scans if the collection is large enough to cause
2407      * an out-of-gas error (10K collections should be fine).
2408      */
2409     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2410         unchecked {
2411             uint256 tokenIdsIdx;
2412             address currOwnershipAddr;
2413             uint256 tokenIdsLength = balanceOf(owner);
2414             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2415             TokenOwnership memory ownership;
2416             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2417                 ownership = _ownershipAt(i);
2418                 if (ownership.burned) {
2419                     continue;
2420                 }
2421                 if (ownership.addr != address(0)) {
2422                     currOwnershipAddr = ownership.addr;
2423                 }
2424                 if (currOwnershipAddr == owner) {
2425                     tokenIds[tokenIdsIdx++] = i;
2426                 }
2427             }
2428             return tokenIds;
2429         }
2430     }
2431 }
2432 
2433 // File: contracts/Ragdollz.sol
2434 
2435 
2436 
2437 pragma solidity >=0.8.13 <0.9.0;
2438 
2439 
2440 
2441 
2442 
2443 
2444 
2445 
2446 
2447 contract Ragdollz is ERC721A, Ownable, ReentrancyGuard {
2448 
2449   using Strings for uint256;
2450 
2451 // ================== Variables Start =======================
2452     
2453     string public uri;
2454     string public uriSuffix = ".json";
2455     uint256 public pricePublic = 0.025 ether;
2456 
2457     uint256 public maxSupply = 6000;
2458     uint256 public maxMintAmountPerTx = 10;
2459     uint256 public maxLimitPerWallet = 1000;
2460     bool public publicMinting = false;
2461 
2462     address private mintClaimPass;
2463 
2464     mapping (address => uint256) public addressBalance;
2465     mapping (address => uint256) public premintBalance;
2466     address private A1; 
2467     address private A2; 
2468     address private A3; 
2469 
2470 
2471 // ================== Variables End =======================  
2472 
2473 // ================== Constructor Start =======================
2474 
2475     constructor(
2476         string memory _uri, address mintPass, address add1, address add2, address add3
2477     ) ERC721A("Ragdollz Reborn", "RAGZ")  {
2478         seturi(_uri);
2479         setPasswordMinting(mintPass);
2480         A1 = add1;
2481         A2 = add2;
2482         A3 = add3;
2483     }
2484 
2485 // ================== Constructor End =======================
2486 
2487 // ================== Modifiers Start =======================
2488 
2489 // ================== Modifiers End ========================
2490 
2491 // ================== Mint Functions Start =======================
2492  
2493     function CollectReserves(uint256 amount) public onlyOwner nonReentrant {
2494         require(totalSupply() + amount <= maxSupply, 'Max Supply Exceeded.');
2495         _safeMint(msg.sender, amount);
2496     }
2497 
2498     function HolderClaim(address password, uint256 _mintAmount) public nonReentrant {
2499         require(premintBalance[msg.sender] < 1, 'Already minted via PreMint please wait and use publicminting');
2500 
2501         uint256 supply = totalSupply();
2502 
2503         require(password == mintClaimPass, 'Incorrect password');
2504 
2505         uint256 amtToMint = _mintAmount; //set minting to 1 for 1
2506         // Normal requirements 
2507         require(amtToMint > 0, 'Invalid mint amount!');
2508         require(supply + amtToMint <= maxSupply, 'Max supply exceeded!');
2509 
2510         premintBalance[msg.sender] += amtToMint;
2511         // Mint
2512         _safeMint(_msgSender(), amtToMint);
2513 
2514     }
2515 
2516     function Mint(uint256 _mintAmount) public payable nonReentrant {
2517         uint256 supply = totalSupply();
2518         // Normal requirements 
2519         require(publicMinting, 'Public sale not active!');
2520         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2521         require(supply + _mintAmount <= maxSupply, 'Max supply exceeded!');
2522         require(msg.value >= pricePublic * _mintAmount, 'Insufficient funds!');
2523         require(addressBalance[msg.sender] < maxLimitPerWallet, 'Too many NFTs minted to wallet.');
2524         
2525         addressBalance[msg.sender] += _mintAmount;
2526         // Mint
2527         _safeMint(_msgSender(), _mintAmount);
2528     }  
2529 
2530     function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
2531         require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2532         _safeMint(_receiver, _mintAmount);
2533     }
2534 
2535 
2536 // ================== Mint Functions End =======================  
2537 
2538 // ================== Set Functions Start =======================
2539 
2540 // uri
2541     function seturi(string memory _uri) public onlyOwner {
2542         uri = _uri;
2543     }
2544 
2545     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2546         uriSuffix = _uriSuffix;
2547     }
2548 
2549 // max per tx
2550     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2551         maxMintAmountPerTx = _maxMintAmountPerTx;
2552     }
2553 
2554 // max per wallet
2555     function setMaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
2556         maxLimitPerWallet = _maxLimitPerWallet;
2557     }
2558 
2559 // price
2560 
2561     function setCostPublic(uint256 _cost) public onlyOwner {
2562         pricePublic = _cost;
2563     }  
2564 
2565 // supply limit
2566     function setSupplyLimit(uint256 _supplyLimit) public onlyOwner {
2567         maxSupply = _supplyLimit;
2568     }
2569 
2570 // set mintingallowed
2571     function setPublicMinting(bool setActive) public onlyOwner {
2572         publicMinting = setActive;
2573     }
2574 
2575 // set mintingallowed
2576     function setPasswordMinting(address _password) public onlyOwner {
2577         mintClaimPass = _password;
2578     }
2579 
2580 
2581 // ================== Set Functions End =======================
2582 
2583 // ================== Withdraw Function Start =======================
2584   
2585      function withdraw() public onlyOwner {
2586         uint256 _balance = address(this).balance;
2587         require(_balance > 0);
2588         _withdraw(A1, (_balance * 75) / 1000);
2589         _withdraw(A2, (_balance * 75) / 1000);
2590         _withdraw(A3, (_balance * 75) / 1000);
2591         _withdraw(owner(), address(this).balance);
2592     }
2593 
2594     function _withdraw(address _address, uint256 _amount) private {
2595         (bool success, ) = _address.call{value: _amount}("");
2596         require(success, "Transfer failed.");
2597     }
2598 
2599 
2600 // ================== Withdraw Function End=======================  
2601 
2602 // ================== Read Functions Start =======================
2603 
2604     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
2605         unchecked {
2606             uint256[] memory a = new uint256[](balanceOf(owner)); 
2607             uint256 end = _nextTokenId();
2608             uint256 tokenIdsIdx;
2609             address currOwnershipAddr;
2610             for (uint256 i; i < end; i++) {
2611                 TokenOwnership memory ownership = _ownershipAt(i);
2612                 if (ownership.burned) {
2613                     continue;
2614                 }
2615                 if (ownership.addr != address(0)) {
2616                     currOwnershipAddr = ownership.addr;
2617                 }
2618                 if (currOwnershipAddr == owner) {
2619                     a[tokenIdsIdx++] = i;
2620                 }
2621             }
2622             return a;    
2623         }
2624     }
2625 
2626     function _startTokenId() internal view virtual override returns (uint256) {
2627         return 1;
2628     }
2629 
2630     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2631         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2632 
2633         string memory currentBaseURI = _baseURI();
2634         return bytes(currentBaseURI).length > 0
2635             ? string(abi.encodePacked(currentBaseURI,"Ragdollz%20Reborn_", _tokenId.toString(), uriSuffix))
2636             : '';
2637     }
2638 
2639     function _baseURI() internal view virtual override returns (string memory) {
2640         return uri;
2641     }
2642 
2643 // ================== Read Functions End =======================  
2644 }