1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/math/Math.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
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
103     function mulDiv(
104         uint256 x,
105         uint256 y,
106         uint256 denominator
107     ) internal pure returns (uint256 result) {
108         unchecked {
109             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
110             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
111             // variables such that product = prod1 * 2^256 + prod0.
112             uint256 prod0; // Least significant 256 bits of the product
113             uint256 prod1; // Most significant 256 bits of the product
114             assembly {
115                 let mm := mulmod(x, y, not(0))
116                 prod0 := mul(x, y)
117                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
118             }
119 
120             // Handle non-overflow cases, 256 by 256 division.
121             if (prod1 == 0) {
122                 return prod0 / denominator;
123             }
124 
125             // Make sure the result is less than 2^256. Also prevents denominator == 0.
126             require(denominator > prod1);
127 
128             ///////////////////////////////////////////////
129             // 512 by 256 division.
130             ///////////////////////////////////////////////
131 
132             // Make division exact by subtracting the remainder from [prod1 prod0].
133             uint256 remainder;
134             assembly {
135                 // Compute remainder using mulmod.
136                 remainder := mulmod(x, y, denominator)
137 
138                 // Subtract 256 bit number from 512 bit number.
139                 prod1 := sub(prod1, gt(remainder, prod0))
140                 prod0 := sub(prod0, remainder)
141             }
142 
143             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
144             // See https://cs.stackexchange.com/q/138556/92363.
145 
146             // Does not overflow because the denominator cannot be zero at this stage in the function.
147             uint256 twos = denominator & (~denominator + 1);
148             assembly {
149                 // Divide denominator by twos.
150                 denominator := div(denominator, twos)
151 
152                 // Divide [prod1 prod0] by twos.
153                 prod0 := div(prod0, twos)
154 
155                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
156                 twos := add(div(sub(0, twos), twos), 1)
157             }
158 
159             // Shift in bits from prod1 into prod0.
160             prod0 |= prod1 * twos;
161 
162             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
163             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
164             // four bits. That is, denominator * inv = 1 mod 2^4.
165             uint256 inverse = (3 * denominator) ^ 2;
166 
167             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
168             // in modular arithmetic, doubling the correct bits in each step.
169             inverse *= 2 - denominator * inverse; // inverse mod 2^8
170             inverse *= 2 - denominator * inverse; // inverse mod 2^16
171             inverse *= 2 - denominator * inverse; // inverse mod 2^32
172             inverse *= 2 - denominator * inverse; // inverse mod 2^64
173             inverse *= 2 - denominator * inverse; // inverse mod 2^128
174             inverse *= 2 - denominator * inverse; // inverse mod 2^256
175 
176             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
177             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
178             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
179             // is no longer required.
180             result = prod0 * inverse;
181             return result;
182         }
183     }
184 
185     /**
186      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
187      */
188     function mulDiv(
189         uint256 x,
190         uint256 y,
191         uint256 denominator,
192         Rounding rounding
193     ) internal pure returns (uint256) {
194         uint256 result = mulDiv(x, y, denominator);
195         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
196             result += 1;
197         }
198         return result;
199     }
200 
201     /**
202      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
203      *
204      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
205      */
206     function sqrt(uint256 a) internal pure returns (uint256) {
207         if (a == 0) {
208             return 0;
209         }
210 
211         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
212         //
213         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
214         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
215         //
216         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
217         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
218         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
219         //
220         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
221         uint256 result = 1 << (log2(a) >> 1);
222 
223         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
224         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
225         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
226         // into the expected uint128 result.
227         unchecked {
228             result = (result + a / result) >> 1;
229             result = (result + a / result) >> 1;
230             result = (result + a / result) >> 1;
231             result = (result + a / result) >> 1;
232             result = (result + a / result) >> 1;
233             result = (result + a / result) >> 1;
234             result = (result + a / result) >> 1;
235             return min(result, a / result);
236         }
237     }
238 
239     /**
240      * @notice Calculates sqrt(a), following the selected rounding direction.
241      */
242     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
243         unchecked {
244             uint256 result = sqrt(a);
245             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
246         }
247     }
248 
249     /**
250      * @dev Return the log in base 2, rounded down, of a positive value.
251      * Returns 0 if given 0.
252      */
253     function log2(uint256 value) internal pure returns (uint256) {
254         uint256 result = 0;
255         unchecked {
256             if (value >> 128 > 0) {
257                 value >>= 128;
258                 result += 128;
259             }
260             if (value >> 64 > 0) {
261                 value >>= 64;
262                 result += 64;
263             }
264             if (value >> 32 > 0) {
265                 value >>= 32;
266                 result += 32;
267             }
268             if (value >> 16 > 0) {
269                 value >>= 16;
270                 result += 16;
271             }
272             if (value >> 8 > 0) {
273                 value >>= 8;
274                 result += 8;
275             }
276             if (value >> 4 > 0) {
277                 value >>= 4;
278                 result += 4;
279             }
280             if (value >> 2 > 0) {
281                 value >>= 2;
282                 result += 2;
283             }
284             if (value >> 1 > 0) {
285                 result += 1;
286             }
287         }
288         return result;
289     }
290 
291     /**
292      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
293      * Returns 0 if given 0.
294      */
295     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
296         unchecked {
297             uint256 result = log2(value);
298             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
299         }
300     }
301 
302     /**
303      * @dev Return the log in base 10, rounded down, of a positive value.
304      * Returns 0 if given 0.
305      */
306     function log10(uint256 value) internal pure returns (uint256) {
307         uint256 result = 0;
308         unchecked {
309             if (value >= 10**64) {
310                 value /= 10**64;
311                 result += 64;
312             }
313             if (value >= 10**32) {
314                 value /= 10**32;
315                 result += 32;
316             }
317             if (value >= 10**16) {
318                 value /= 10**16;
319                 result += 16;
320             }
321             if (value >= 10**8) {
322                 value /= 10**8;
323                 result += 8;
324             }
325             if (value >= 10**4) {
326                 value /= 10**4;
327                 result += 4;
328             }
329             if (value >= 10**2) {
330                 value /= 10**2;
331                 result += 2;
332             }
333             if (value >= 10**1) {
334                 result += 1;
335             }
336         }
337         return result;
338     }
339 
340     /**
341      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
342      * Returns 0 if given 0.
343      */
344     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
345         unchecked {
346             uint256 result = log10(value);
347             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
348         }
349     }
350 
351     /**
352      * @dev Return the log in base 256, rounded down, of a positive value.
353      * Returns 0 if given 0.
354      *
355      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
356      */
357     function log256(uint256 value) internal pure returns (uint256) {
358         uint256 result = 0;
359         unchecked {
360             if (value >> 128 > 0) {
361                 value >>= 128;
362                 result += 16;
363             }
364             if (value >> 64 > 0) {
365                 value >>= 64;
366                 result += 8;
367             }
368             if (value >> 32 > 0) {
369                 value >>= 32;
370                 result += 4;
371             }
372             if (value >> 16 > 0) {
373                 value >>= 16;
374                 result += 2;
375             }
376             if (value >> 8 > 0) {
377                 result += 1;
378             }
379         }
380         return result;
381     }
382 
383     /**
384      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
385      * Returns 0 if given 0.
386      */
387     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
388         unchecked {
389             uint256 result = log256(value);
390             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
391         }
392     }
393 }
394 
395 // File: @openzeppelin/contracts/utils/StorageSlot.sol
396 
397 
398 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @dev Library for reading and writing primitive types to specific storage slots.
404  *
405  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
406  * This library helps with reading and writing to such slots without the need for inline assembly.
407  *
408  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
409  *
410  * Example usage to set ERC1967 implementation slot:
411  * ```
412  * contract ERC1967 {
413  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
414  *
415  *     function _getImplementation() internal view returns (address) {
416  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
417  *     }
418  *
419  *     function _setImplementation(address newImplementation) internal {
420  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
421  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
422  *     }
423  * }
424  * ```
425  *
426  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
427  */
428 library StorageSlot {
429     struct AddressSlot {
430         address value;
431     }
432 
433     struct BooleanSlot {
434         bool value;
435     }
436 
437     struct Bytes32Slot {
438         bytes32 value;
439     }
440 
441     struct Uint256Slot {
442         uint256 value;
443     }
444 
445     /**
446      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
447      */
448     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
449         /// @solidity memory-safe-assembly
450         assembly {
451             r.slot := slot
452         }
453     }
454 
455     /**
456      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
457      */
458     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
459         /// @solidity memory-safe-assembly
460         assembly {
461             r.slot := slot
462         }
463     }
464 
465     /**
466      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
467      */
468     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
469         /// @solidity memory-safe-assembly
470         assembly {
471             r.slot := slot
472         }
473     }
474 
475     /**
476      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
477      */
478     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
479         /// @solidity memory-safe-assembly
480         assembly {
481             r.slot := slot
482         }
483     }
484 }
485 
486 // File: @openzeppelin/contracts/utils/Arrays.sol
487 
488 
489 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Arrays.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 
495 /**
496  * @dev Collection of functions related to array types.
497  */
498 library Arrays {
499     using StorageSlot for bytes32;
500 
501     /**
502      * @dev Searches a sorted `array` and returns the first index that contains
503      * a value greater or equal to `element`. If no such index exists (i.e. all
504      * values in the array are strictly less than `element`), the array length is
505      * returned. Time complexity O(log n).
506      *
507      * `array` is expected to be sorted in ascending order, and to contain no
508      * repeated elements.
509      */
510     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
511         if (array.length == 0) {
512             return 0;
513         }
514 
515         uint256 low = 0;
516         uint256 high = array.length;
517 
518         while (low < high) {
519             uint256 mid = Math.average(low, high);
520 
521             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
522             // because Math.average rounds down (it does integer division with truncation).
523             if (unsafeAccess(array, mid).value > element) {
524                 high = mid;
525             } else {
526                 low = mid + 1;
527             }
528         }
529 
530         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
531         if (low > 0 && unsafeAccess(array, low - 1).value == element) {
532             return low - 1;
533         } else {
534             return low;
535         }
536     }
537 
538     /**
539      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
540      *
541      * WARNING: Only use if you are certain `pos` is lower than the array length.
542      */
543     function unsafeAccess(address[] storage arr, uint256 pos) internal pure returns (StorageSlot.AddressSlot storage) {
544         bytes32 slot;
545         /// @solidity memory-safe-assembly
546         assembly {
547             mstore(0, arr.slot)
548             slot := add(keccak256(0, 0x20), pos)
549         }
550         return slot.getAddressSlot();
551     }
552 
553     /**
554      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
555      *
556      * WARNING: Only use if you are certain `pos` is lower than the array length.
557      */
558     function unsafeAccess(bytes32[] storage arr, uint256 pos) internal pure returns (StorageSlot.Bytes32Slot storage) {
559         bytes32 slot;
560         /// @solidity memory-safe-assembly
561         assembly {
562             mstore(0, arr.slot)
563             slot := add(keccak256(0, 0x20), pos)
564         }
565         return slot.getBytes32Slot();
566     }
567 
568     /**
569      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
570      *
571      * WARNING: Only use if you are certain `pos` is lower than the array length.
572      */
573     function unsafeAccess(uint256[] storage arr, uint256 pos) internal pure returns (StorageSlot.Uint256Slot storage) {
574         bytes32 slot;
575         /// @solidity memory-safe-assembly
576         assembly {
577             mstore(0, arr.slot)
578             slot := add(keccak256(0, 0x20), pos)
579         }
580         return slot.getUint256Slot();
581     }
582 }
583 
584 // File: @openzeppelin/contracts/utils/Context.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 /**
592  * @dev Provides information about the current execution context, including the
593  * sender of the transaction and its data. While these are generally available
594  * via msg.sender and msg.data, they should not be accessed in such a direct
595  * manner, since when dealing with meta-transactions the account sending and
596  * paying for execution may not be the actual sender (as far as an application
597  * is concerned).
598  *
599  * This contract is only required for intermediate, library-like contracts.
600  */
601 abstract contract Context {
602     function _msgSender() internal view virtual returns (address) {
603         return msg.sender;
604     }
605 
606     function _msgData() internal view virtual returns (bytes calldata) {
607         return msg.data;
608     }
609 }
610 
611 // File: @openzeppelin/contracts/access/Ownable.sol
612 
613 
614 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 
619 /**
620  * @dev Contract module which provides a basic access control mechanism, where
621  * there is an account (an owner) that can be granted exclusive access to
622  * specific functions.
623  *
624  * By default, the owner account will be the one that deploys the contract. This
625  * can later be changed with {transferOwnership}.
626  *
627  * This module is used through inheritance. It will make available the modifier
628  * `onlyOwner`, which can be applied to your functions to restrict their use to
629  * the owner.
630  */
631 abstract contract Ownable is Context {
632     address private _owner;
633 
634     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
635 
636     /**
637      * @dev Initializes the contract setting the deployer as the initial owner.
638      */
639     constructor() {
640         _transferOwnership(_msgSender());
641     }
642 
643     /**
644      * @dev Throws if called by any account other than the owner.
645      */
646     modifier onlyOwner() {
647         _checkOwner();
648         _;
649     }
650 
651     /**
652      * @dev Returns the address of the current owner.
653      */
654     function owner() public view virtual returns (address) {
655         return _owner;
656     }
657 
658     /**
659      * @dev Throws if the sender is not the owner.
660      */
661     function _checkOwner() internal view virtual {
662         require(owner() == _msgSender(), "Ownable: caller is not the owner");
663     }
664 
665     /**
666      * @dev Leaves the contract without owner. It will not be possible to call
667      * `onlyOwner` functions anymore. Can only be called by the current owner.
668      *
669      * NOTE: Renouncing ownership will leave the contract without an owner,
670      * thereby removing any functionality that is only available to the owner.
671      */
672     function renounceOwnership() public virtual onlyOwner {
673         _transferOwnership(address(0));
674     }
675 
676     /**
677      * @dev Transfers ownership of the contract to a new account (`newOwner`).
678      * Can only be called by the current owner.
679      */
680     function transferOwnership(address newOwner) public virtual onlyOwner {
681         require(newOwner != address(0), "Ownable: new owner is the zero address");
682         _transferOwnership(newOwner);
683     }
684 
685     /**
686      * @dev Transfers ownership of the contract to a new account (`newOwner`).
687      * Internal function without access restriction.
688      */
689     function _transferOwnership(address newOwner) internal virtual {
690         address oldOwner = _owner;
691         _owner = newOwner;
692         emit OwnershipTransferred(oldOwner, newOwner);
693     }
694 }
695 
696 // File: @openzeppelin/contracts/security/Pausable.sol
697 
698 
699 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @dev Contract module which allows children to implement an emergency stop
706  * mechanism that can be triggered by an authorized account.
707  *
708  * This module is used through inheritance. It will make available the
709  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
710  * the functions of your contract. Note that they will not be pausable by
711  * simply including this module, only once the modifiers are put in place.
712  */
713 abstract contract Pausable is Context {
714     /**
715      * @dev Emitted when the pause is triggered by `account`.
716      */
717     event Paused(address account);
718 
719     /**
720      * @dev Emitted when the pause is lifted by `account`.
721      */
722     event Unpaused(address account);
723 
724     bool private _paused;
725 
726     /**
727      * @dev Initializes the contract in unpaused state.
728      */
729     constructor() {
730         _paused = false;
731     }
732 
733     /**
734      * @dev Modifier to make a function callable only when the contract is not paused.
735      *
736      * Requirements:
737      *
738      * - The contract must not be paused.
739      */
740     modifier whenNotPaused() {
741         _requireNotPaused();
742         _;
743     }
744 
745     /**
746      * @dev Modifier to make a function callable only when the contract is paused.
747      *
748      * Requirements:
749      *
750      * - The contract must be paused.
751      */
752     modifier whenPaused() {
753         _requirePaused();
754         _;
755     }
756 
757     /**
758      * @dev Returns true if the contract is paused, and false otherwise.
759      */
760     function paused() public view virtual returns (bool) {
761         return _paused;
762     }
763 
764     /**
765      * @dev Throws if the contract is paused.
766      */
767     function _requireNotPaused() internal view virtual {
768         require(!paused(), "Pausable: paused");
769     }
770 
771     /**
772      * @dev Throws if the contract is not paused.
773      */
774     function _requirePaused() internal view virtual {
775         require(paused(), "Pausable: not paused");
776     }
777 
778     /**
779      * @dev Triggers stopped state.
780      *
781      * Requirements:
782      *
783      * - The contract must not be paused.
784      */
785     function _pause() internal virtual whenNotPaused {
786         _paused = true;
787         emit Paused(_msgSender());
788     }
789 
790     /**
791      * @dev Returns to normal state.
792      *
793      * Requirements:
794      *
795      * - The contract must be paused.
796      */
797     function _unpause() internal virtual whenPaused {
798         _paused = false;
799         emit Unpaused(_msgSender());
800     }
801 }
802 
803 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
804 
805 
806 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
807 
808 pragma solidity ^0.8.0;
809 
810 /**
811  * @dev Interface of the ERC20 standard as defined in the EIP.
812  */
813 interface IERC20 {
814     /**
815      * @dev Emitted when `value` tokens are moved from one account (`from`) to
816      * another (`to`).
817      *
818      * Note that `value` may be zero.
819      */
820     event Transfer(address indexed from, address indexed to, uint256 value);
821 
822     /**
823      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
824      * a call to {approve}. `value` is the new allowance.
825      */
826     event Approval(address indexed owner, address indexed spender, uint256 value);
827 
828     /**
829      * @dev Returns the amount of tokens in existence.
830      */
831     function totalSupply() external view returns (uint256);
832 
833     /**
834      * @dev Returns the amount of tokens owned by `account`.
835      */
836     function balanceOf(address account) external view returns (uint256);
837 
838     /**
839      * @dev Moves `amount` tokens from the caller's account to `to`.
840      *
841      * Returns a boolean value indicating whether the operation succeeded.
842      *
843      * Emits a {Transfer} event.
844      */
845     function transfer(address to, uint256 amount) external returns (bool);
846 
847     /**
848      * @dev Returns the remaining number of tokens that `spender` will be
849      * allowed to spend on behalf of `owner` through {transferFrom}. This is
850      * zero by default.
851      *
852      * This value changes when {approve} or {transferFrom} are called.
853      */
854     function allowance(address owner, address spender) external view returns (uint256);
855 
856     /**
857      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
858      *
859      * Returns a boolean value indicating whether the operation succeeded.
860      *
861      * IMPORTANT: Beware that changing an allowance with this method brings the risk
862      * that someone may use both the old and the new allowance by unfortunate
863      * transaction ordering. One possible solution to mitigate this race
864      * condition is to first reduce the spender's allowance to 0 and set the
865      * desired value afterwards:
866      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
867      *
868      * Emits an {Approval} event.
869      */
870     function approve(address spender, uint256 amount) external returns (bool);
871 
872     /**
873      * @dev Moves `amount` tokens from `from` to `to` using the
874      * allowance mechanism. `amount` is then deducted from the caller's
875      * allowance.
876      *
877      * Returns a boolean value indicating whether the operation succeeded.
878      *
879      * Emits a {Transfer} event.
880      */
881     function transferFrom(
882         address from,
883         address to,
884         uint256 amount
885     ) external returns (bool);
886 }
887 
888 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
889 
890 
891 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 
896 /**
897  * @dev Interface for the optional metadata functions from the ERC20 standard.
898  *
899  * _Available since v4.1._
900  */
901 interface IERC20Metadata is IERC20 {
902     /**
903      * @dev Returns the name of the token.
904      */
905     function name() external view returns (string memory);
906 
907     /**
908      * @dev Returns the symbol of the token.
909      */
910     function symbol() external view returns (string memory);
911 
912     /**
913      * @dev Returns the decimals places of the token.
914      */
915     function decimals() external view returns (uint8);
916 }
917 
918 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
919 
920 
921 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 
926 
927 
928 /**
929  * @dev Implementation of the {IERC20} interface.
930  *
931  * This implementation is agnostic to the way tokens are created. This means
932  * that a supply mechanism has to be added in a derived contract using {_mint}.
933  * For a generic mechanism see {ERC20PresetMinterPauser}.
934  *
935  * TIP: For a detailed writeup see our guide
936  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
937  * to implement supply mechanisms].
938  *
939  * We have followed general OpenZeppelin Contracts guidelines: functions revert
940  * instead returning `false` on failure. This behavior is nonetheless
941  * conventional and does not conflict with the expectations of ERC20
942  * applications.
943  *
944  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
945  * This allows applications to reconstruct the allowance for all accounts just
946  * by listening to said events. Other implementations of the EIP may not emit
947  * these events, as it isn't required by the specification.
948  *
949  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
950  * functions have been added to mitigate the well-known issues around setting
951  * allowances. See {IERC20-approve}.
952  */
953 contract ERC20 is Context, IERC20, IERC20Metadata {
954     mapping(address => uint256) private _balances;
955 
956     mapping(address => mapping(address => uint256)) private _allowances;
957 
958     uint256 private _totalSupply;
959 
960     string private _name;
961     string private _symbol;
962 
963     /**
964      * @dev Sets the values for {name} and {symbol}.
965      *
966      * The default value of {decimals} is 18. To select a different value for
967      * {decimals} you should overload it.
968      *
969      * All two of these values are immutable: they can only be set once during
970      * construction.
971      */
972     constructor(string memory name_, string memory symbol_) {
973         _name = name_;
974         _symbol = symbol_;
975     }
976 
977     /**
978      * @dev Returns the name of the token.
979      */
980     function name() public view virtual override returns (string memory) {
981         return _name;
982     }
983 
984     /**
985      * @dev Returns the symbol of the token, usually a shorter version of the
986      * name.
987      */
988     function symbol() public view virtual override returns (string memory) {
989         return _symbol;
990     }
991 
992     /**
993      * @dev Returns the number of decimals used to get its user representation.
994      * For example, if `decimals` equals `2`, a balance of `505` tokens should
995      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
996      *
997      * Tokens usually opt for a value of 18, imitating the relationship between
998      * Ether and Wei. This is the value {ERC20} uses, unless this function is
999      * overridden;
1000      *
1001      * NOTE: This information is only used for _display_ purposes: it in
1002      * no way affects any of the arithmetic of the contract, including
1003      * {IERC20-balanceOf} and {IERC20-transfer}.
1004      */
1005     function decimals() public view virtual override returns (uint8) {
1006         return 18;
1007     }
1008 
1009     /**
1010      * @dev See {IERC20-totalSupply}.
1011      */
1012     function totalSupply() public view virtual override returns (uint256) {
1013         return _totalSupply;
1014     }
1015 
1016     /**
1017      * @dev See {IERC20-balanceOf}.
1018      */
1019     function balanceOf(address account) public view virtual override returns (uint256) {
1020         return _balances[account];
1021     }
1022 
1023     /**
1024      * @dev See {IERC20-transfer}.
1025      *
1026      * Requirements:
1027      *
1028      * - `to` cannot be the zero address.
1029      * - the caller must have a balance of at least `amount`.
1030      */
1031     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1032         address owner = _msgSender();
1033         _transfer(owner, to, amount);
1034         return true;
1035     }
1036 
1037     /**
1038      * @dev See {IERC20-allowance}.
1039      */
1040     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1041         return _allowances[owner][spender];
1042     }
1043 
1044     /**
1045      * @dev See {IERC20-approve}.
1046      *
1047      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1048      * `transferFrom`. This is semantically equivalent to an infinite approval.
1049      *
1050      * Requirements:
1051      *
1052      * - `spender` cannot be the zero address.
1053      */
1054     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1055         address owner = _msgSender();
1056         _approve(owner, spender, amount);
1057         return true;
1058     }
1059 
1060     /**
1061      * @dev See {IERC20-transferFrom}.
1062      *
1063      * Emits an {Approval} event indicating the updated allowance. This is not
1064      * required by the EIP. See the note at the beginning of {ERC20}.
1065      *
1066      * NOTE: Does not update the allowance if the current allowance
1067      * is the maximum `uint256`.
1068      *
1069      * Requirements:
1070      *
1071      * - `from` and `to` cannot be the zero address.
1072      * - `from` must have a balance of at least `amount`.
1073      * - the caller must have allowance for ``from``'s tokens of at least
1074      * `amount`.
1075      */
1076     function transferFrom(
1077         address from,
1078         address to,
1079         uint256 amount
1080     ) public virtual override returns (bool) {
1081         address spender = _msgSender();
1082         _spendAllowance(from, spender, amount);
1083         _transfer(from, to, amount);
1084         return true;
1085     }
1086 
1087     /**
1088      * @dev Atomically increases the allowance granted to `spender` by the caller.
1089      *
1090      * This is an alternative to {approve} that can be used as a mitigation for
1091      * problems described in {IERC20-approve}.
1092      *
1093      * Emits an {Approval} event indicating the updated allowance.
1094      *
1095      * Requirements:
1096      *
1097      * - `spender` cannot be the zero address.
1098      */
1099     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1100         address owner = _msgSender();
1101         _approve(owner, spender, allowance(owner, spender) + addedValue);
1102         return true;
1103     }
1104 
1105     /**
1106      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1107      *
1108      * This is an alternative to {approve} that can be used as a mitigation for
1109      * problems described in {IERC20-approve}.
1110      *
1111      * Emits an {Approval} event indicating the updated allowance.
1112      *
1113      * Requirements:
1114      *
1115      * - `spender` cannot be the zero address.
1116      * - `spender` must have allowance for the caller of at least
1117      * `subtractedValue`.
1118      */
1119     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1120         address owner = _msgSender();
1121         uint256 currentAllowance = allowance(owner, spender);
1122         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1123         unchecked {
1124             _approve(owner, spender, currentAllowance - subtractedValue);
1125         }
1126 
1127         return true;
1128     }
1129 
1130     /**
1131      * @dev Moves `amount` of tokens from `from` to `to`.
1132      *
1133      * This internal function is equivalent to {transfer}, and can be used to
1134      * e.g. implement automatic token fees, slashing mechanisms, etc.
1135      *
1136      * Emits a {Transfer} event.
1137      *
1138      * Requirements:
1139      *
1140      * - `from` cannot be the zero address.
1141      * - `to` cannot be the zero address.
1142      * - `from` must have a balance of at least `amount`.
1143      */
1144     function _transfer(
1145         address from,
1146         address to,
1147         uint256 amount
1148     ) internal virtual {
1149         require(from != address(0), "ERC20: transfer from the zero address");
1150         require(to != address(0), "ERC20: transfer to the zero address");
1151 
1152         _beforeTokenTransfer(from, to, amount);
1153 
1154         uint256 fromBalance = _balances[from];
1155         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1156         unchecked {
1157             _balances[from] = fromBalance - amount;
1158             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1159             // decrementing then incrementing.
1160             _balances[to] += amount;
1161         }
1162 
1163         emit Transfer(from, to, amount);
1164 
1165         _afterTokenTransfer(from, to, amount);
1166     }
1167 
1168     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1169      * the total supply.
1170      *
1171      * Emits a {Transfer} event with `from` set to the zero address.
1172      *
1173      * Requirements:
1174      *
1175      * - `account` cannot be the zero address.
1176      */
1177     function _mint(address account, uint256 amount) internal virtual {
1178         require(account != address(0), "ERC20: mint to the zero address");
1179 
1180         _beforeTokenTransfer(address(0), account, amount);
1181 
1182         _totalSupply += amount;
1183         unchecked {
1184             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1185             _balances[account] += amount;
1186         }
1187         emit Transfer(address(0), account, amount);
1188 
1189         _afterTokenTransfer(address(0), account, amount);
1190     }
1191 
1192     /**
1193      * @dev Destroys `amount` tokens from `account`, reducing the
1194      * total supply.
1195      *
1196      * Emits a {Transfer} event with `to` set to the zero address.
1197      *
1198      * Requirements:
1199      *
1200      * - `account` cannot be the zero address.
1201      * - `account` must have at least `amount` tokens.
1202      */
1203     function _burn(address account, uint256 amount) internal virtual {
1204         require(account != address(0), "ERC20: burn from the zero address");
1205 
1206         _beforeTokenTransfer(account, address(0), amount);
1207 
1208         uint256 accountBalance = _balances[account];
1209         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1210         unchecked {
1211             _balances[account] = accountBalance - amount;
1212             // Overflow not possible: amount <= accountBalance <= totalSupply.
1213             _totalSupply -= amount;
1214         }
1215 
1216         emit Transfer(account, address(0), amount);
1217 
1218         _afterTokenTransfer(account, address(0), amount);
1219     }
1220 
1221     /**
1222      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1223      *
1224      * This internal function is equivalent to `approve`, and can be used to
1225      * e.g. set automatic allowances for certain subsystems, etc.
1226      *
1227      * Emits an {Approval} event.
1228      *
1229      * Requirements:
1230      *
1231      * - `owner` cannot be the zero address.
1232      * - `spender` cannot be the zero address.
1233      */
1234     function _approve(
1235         address owner,
1236         address spender,
1237         uint256 amount
1238     ) internal virtual {
1239         require(owner != address(0), "ERC20: approve from the zero address");
1240         require(spender != address(0), "ERC20: approve to the zero address");
1241 
1242         _allowances[owner][spender] = amount;
1243         emit Approval(owner, spender, amount);
1244     }
1245 
1246     /**
1247      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1248      *
1249      * Does not update the allowance amount in case of infinite allowance.
1250      * Revert if not enough allowance is available.
1251      *
1252      * Might emit an {Approval} event.
1253      */
1254     function _spendAllowance(
1255         address owner,
1256         address spender,
1257         uint256 amount
1258     ) internal virtual {
1259         uint256 currentAllowance = allowance(owner, spender);
1260         if (currentAllowance != type(uint256).max) {
1261             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1262             unchecked {
1263                 _approve(owner, spender, currentAllowance - amount);
1264             }
1265         }
1266     }
1267 
1268     /**
1269      * @dev Hook that is called before any transfer of tokens. This includes
1270      * minting and burning.
1271      *
1272      * Calling conditions:
1273      *
1274      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1275      * will be transferred to `to`.
1276      * - when `from` is zero, `amount` tokens will be minted for `to`.
1277      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1278      * - `from` and `to` are never both zero.
1279      *
1280      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1281      */
1282     function _beforeTokenTransfer(
1283         address from,
1284         address to,
1285         uint256 amount
1286     ) internal virtual {}
1287 
1288     /**
1289      * @dev Hook that is called after any transfer of tokens. This includes
1290      * minting and burning.
1291      *
1292      * Calling conditions:
1293      *
1294      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1295      * has been transferred to `to`.
1296      * - when `from` is zero, `amount` tokens have been minted for `to`.
1297      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1298      * - `from` and `to` are never both zero.
1299      *
1300      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1301      */
1302     function _afterTokenTransfer(
1303         address from,
1304         address to,
1305         uint256 amount
1306     ) internal virtual {}
1307 }
1308 
1309 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol
1310 
1311 
1312 // OpenZeppelin Contracts (last updated v4.8.2) (token/ERC20/extensions/ERC20Pausable.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 
1317 
1318 /**
1319  * @dev ERC20 token with pausable token transfers, minting and burning.
1320  *
1321  * Useful for scenarios such as preventing trades until the end of an evaluation
1322  * period, or having an emergency switch for freezing all token transfers in the
1323  * event of a large bug.
1324  *
1325  * IMPORTANT: This contract does not include public pause and unpause functions. In
1326  * addition to inheriting this contract, you must define both functions, invoking the
1327  * {Pausable-_pause} and {Pausable-_unpause} internal functions, with appropriate
1328  * access control, e.g. using {AccessControl} or {Ownable}. Not doing so will
1329  * make the contract unpausable.
1330  */
1331 abstract contract ERC20Pausable is ERC20, Pausable {
1332     /**
1333      * @dev See {ERC20-_beforeTokenTransfer}.
1334      *
1335      * Requirements:
1336      *
1337      * - the contract must not be paused.
1338      */
1339     function _beforeTokenTransfer(
1340         address from,
1341         address to,
1342         uint256 amount
1343     ) internal virtual override {
1344         super._beforeTokenTransfer(from, to, amount);
1345 
1346         require(!paused(), "ERC20Pausable: token transfer while paused");
1347     }
1348 }
1349 
1350 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol
1351 
1352 
1353 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/extensions/ERC20Snapshot.sol)
1354 
1355 pragma solidity ^0.8.0;
1356 
1357 
1358 
1359 
1360 /**
1361  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1362  * total supply at the time are recorded for later access.
1363  *
1364  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1365  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1366  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1367  * used to create an efficient ERC20 forking mechanism.
1368  *
1369  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1370  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1371  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1372  * and the account address.
1373  *
1374  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
1375  * return `block.number` will trigger the creation of snapshot at the beginning of each new block. When overriding this
1376  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
1377  *
1378  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
1379  * alternative consider {ERC20Votes}.
1380  *
1381  * ==== Gas Costs
1382  *
1383  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1384  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1385  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1386  *
1387  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1388  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1389  * transfers will have normal cost until the next snapshot, and so on.
1390  */
1391 
1392 abstract contract ERC20Snapshot is ERC20 {
1393     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1394     // https://github.com/Giveth/minime/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1395 
1396     using Arrays for uint256[];
1397     using Counters for Counters.Counter;
1398 
1399     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1400     // Snapshot struct, but that would impede usage of functions that work on an array.
1401     struct Snapshots {
1402         uint256[] ids;
1403         uint256[] values;
1404     }
1405 
1406     mapping(address => Snapshots) private _accountBalanceSnapshots;
1407     Snapshots private _totalSupplySnapshots;
1408 
1409     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1410     Counters.Counter private _currentSnapshotId;
1411 
1412     /**
1413      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1414      */
1415     event Snapshot(uint256 id);
1416 
1417     /**
1418      * @dev Creates a new snapshot and returns its snapshot id.
1419      *
1420      * Emits a {Snapshot} event that contains the same id.
1421      *
1422      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1423      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1424      *
1425      * [WARNING]
1426      * ====
1427      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1428      * you must consider that it can potentially be used by attackers in two ways.
1429      *
1430      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1431      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1432      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1433      * section above.
1434      *
1435      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1436      * ====
1437      */
1438     function _snapshot() internal virtual returns (uint256) {
1439         _currentSnapshotId.increment();
1440 
1441         uint256 currentId = _getCurrentSnapshotId();
1442         emit Snapshot(currentId);
1443         return currentId;
1444     }
1445 
1446     /**
1447      * @dev Get the current snapshotId
1448      */
1449     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
1450         return _currentSnapshotId.current();
1451     }
1452 
1453     /**
1454      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1455      */
1456     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
1457         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1458 
1459         return snapshotted ? value : balanceOf(account);
1460     }
1461 
1462     /**
1463      * @dev Retrieves the total supply at the time `snapshotId` was created.
1464      */
1465     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
1466         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1467 
1468         return snapshotted ? value : totalSupply();
1469     }
1470 
1471     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1472     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1473     function _beforeTokenTransfer(
1474         address from,
1475         address to,
1476         uint256 amount
1477     ) internal virtual override {
1478         super._beforeTokenTransfer(from, to, amount);
1479 
1480         if (from == address(0)) {
1481             // mint
1482             _updateAccountSnapshot(to);
1483             _updateTotalSupplySnapshot();
1484         } else if (to == address(0)) {
1485             // burn
1486             _updateAccountSnapshot(from);
1487             _updateTotalSupplySnapshot();
1488         } else {
1489             // transfer
1490             _updateAccountSnapshot(from);
1491             _updateAccountSnapshot(to);
1492         }
1493     }
1494 
1495     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
1496         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1497         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
1498 
1499         // When a valid snapshot is queried, there are three possibilities:
1500         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1501         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1502         //  to this id is the current one.
1503         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1504         //  requested id, and its value is the one to return.
1505         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1506         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1507         //  larger than the requested one.
1508         //
1509         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1510         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1511         // exactly this.
1512 
1513         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1514 
1515         if (index == snapshots.ids.length) {
1516             return (false, 0);
1517         } else {
1518             return (true, snapshots.values[index]);
1519         }
1520     }
1521 
1522     function _updateAccountSnapshot(address account) private {
1523         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1524     }
1525 
1526     function _updateTotalSupplySnapshot() private {
1527         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1528     }
1529 
1530     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1531         uint256 currentId = _getCurrentSnapshotId();
1532         if (_lastSnapshotId(snapshots.ids) < currentId) {
1533             snapshots.ids.push(currentId);
1534             snapshots.values.push(currentValue);
1535         }
1536     }
1537 
1538     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1539         if (ids.length == 0) {
1540             return 0;
1541         } else {
1542             return ids[ids.length - 1];
1543         }
1544     }
1545 }
1546 
1547 // File: contract-bbc0dcf24a.sol
1548 
1549 
1550 pragma solidity 0.8.9;
1551 
1552 
1553 
1554 
1555 /// @custom:security-contact support@finbloxapp.com
1556 contract FBXToken is ERC20Snapshot, Ownable, ERC20Pausable {
1557     constructor() ERC20("FBX Token", "FBX") {
1558         // Initial supply is 10.000.000.000 tokens with 18 decimals precision
1559         _mint(msg.sender, 10000000000 * 10 ** decimals());
1560     }
1561 
1562     function snapshot() public onlyOwner {
1563         _snapshot();
1564     }
1565 
1566     function pause() public onlyOwner {
1567         _pause();
1568     }
1569 
1570     function unpause() public onlyOwner {
1571         _unpause();
1572     }
1573 
1574     function _beforeTokenTransfer(
1575         address from,
1576         address to,
1577         uint256 amount
1578     ) internal override(ERC20Snapshot, ERC20Pausable) whenNotPaused {
1579         super._beforeTokenTransfer(from, to, amount);
1580     }
1581 }