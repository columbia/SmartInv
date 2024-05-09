1 // SPDX-License-Identifier: MIT
2 
3 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/structs/EnumerableSet.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
7 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Library for managing
13  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
14  * types.
15  *
16  * Sets have the following properties:
17  *
18  * - Elements are added, removed, and checked for existence in constant time
19  * (O(1)).
20  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
21  *
22  * ```
23  * contract Example {
24  *     // Add the library methods
25  *     using EnumerableSet for EnumerableSet.AddressSet;
26  *
27  *     // Declare a set state variable
28  *     EnumerableSet.AddressSet private mySet;
29  * }
30  * ```
31  *
32  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
33  * and `uint256` (`UintSet`) are supported.
34  *
35  * [WARNING]
36  * ====
37  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
38  * unusable.
39  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
40  *
41  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
42  * array of EnumerableSet.
43  * ====
44  */
45 library EnumerableSet {
46     // To implement this library for multiple types with as little code
47     // repetition as possible, we write it in terms of a generic Set type with
48     // bytes32 values.
49     // The Set implementation uses private functions, and user-facing
50     // implementations (such as AddressSet) are just wrappers around the
51     // underlying Set.
52     // This means that we can only create new EnumerableSets for types that fit
53     // in bytes32.
54 
55     struct Set {
56         // Storage of set values
57         bytes32[] _values;
58         // Position of the value in the `values` array, plus 1 because index 0
59         // means a value is not in the set.
60         mapping(bytes32 => uint256) _indexes;
61     }
62 
63     /**
64      * @dev Add a value to a set. O(1).
65      *
66      * Returns true if the value was added to the set, that is if it was not
67      * already present.
68      */
69     function _add(Set storage set, bytes32 value) private returns (bool) {
70         if (!_contains(set, value)) {
71             set._values.push(value);
72             // The value is stored at length-1, but we add 1 to all indexes
73             // and use 0 as a sentinel value
74             set._indexes[value] = set._values.length;
75             return true;
76         } else {
77             return false;
78         }
79     }
80 
81     /**
82      * @dev Removes a value from a set. O(1).
83      *
84      * Returns true if the value was removed from the set, that is if it was
85      * present.
86      */
87     function _remove(Set storage set, bytes32 value) private returns (bool) {
88         // We read and store the value's index to prevent multiple reads from the same storage slot
89         uint256 valueIndex = set._indexes[value];
90 
91         if (valueIndex != 0) {
92             // Equivalent to contains(set, value)
93             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
94             // the array, and then remove the last element (sometimes called as 'swap and pop').
95             // This modifies the order of the array, as noted in {at}.
96 
97             uint256 toDeleteIndex = valueIndex - 1;
98             uint256 lastIndex = set._values.length - 1;
99 
100             if (lastIndex != toDeleteIndex) {
101                 bytes32 lastValue = set._values[lastIndex];
102 
103                 // Move the last value to the index where the value to delete is
104                 set._values[toDeleteIndex] = lastValue;
105                 // Update the index for the moved value
106                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
107             }
108 
109             // Delete the slot where the moved value was stored
110             set._values.pop();
111 
112             // Delete the index for the deleted slot
113             delete set._indexes[value];
114 
115             return true;
116         } else {
117             return false;
118         }
119     }
120 
121     /**
122      * @dev Returns true if the value is in the set. O(1).
123      */
124     function _contains(Set storage set, bytes32 value) private view returns (bool) {
125         return set._indexes[value] != 0;
126     }
127 
128     /**
129      * @dev Returns the number of values on the set. O(1).
130      */
131     function _length(Set storage set) private view returns (uint256) {
132         return set._values.length;
133     }
134 
135     /**
136      * @dev Returns the value stored at position `index` in the set. O(1).
137      *
138      * Note that there are no guarantees on the ordering of values inside the
139      * array, and it may change when more values are added or removed.
140      *
141      * Requirements:
142      *
143      * - `index` must be strictly less than {length}.
144      */
145     function _at(Set storage set, uint256 index) private view returns (bytes32) {
146         return set._values[index];
147     }
148 
149     /**
150      * @dev Return the entire set in an array
151      *
152      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
153      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
154      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
155      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
156      */
157     function _values(Set storage set) private view returns (bytes32[] memory) {
158         return set._values;
159     }
160 
161     // Bytes32Set
162 
163     struct Bytes32Set {
164         Set _inner;
165     }
166 
167     /**
168      * @dev Add a value to a set. O(1).
169      *
170      * Returns true if the value was added to the set, that is if it was not
171      * already present.
172      */
173     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
174         return _add(set._inner, value);
175     }
176 
177     /**
178      * @dev Removes a value from a set. O(1).
179      *
180      * Returns true if the value was removed from the set, that is if it was
181      * present.
182      */
183     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
184         return _remove(set._inner, value);
185     }
186 
187     /**
188      * @dev Returns true if the value is in the set. O(1).
189      */
190     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
191         return _contains(set._inner, value);
192     }
193 
194     /**
195      * @dev Returns the number of values in the set. O(1).
196      */
197     function length(Bytes32Set storage set) internal view returns (uint256) {
198         return _length(set._inner);
199     }
200 
201     /**
202      * @dev Returns the value stored at position `index` in the set. O(1).
203      *
204      * Note that there are no guarantees on the ordering of values inside the
205      * array, and it may change when more values are added or removed.
206      *
207      * Requirements:
208      *
209      * - `index` must be strictly less than {length}.
210      */
211     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
212         return _at(set._inner, index);
213     }
214 
215     /**
216      * @dev Return the entire set in an array
217      *
218      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
219      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
220      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
221      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
222      */
223     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
224         bytes32[] memory store = _values(set._inner);
225         bytes32[] memory result;
226 
227         /// @solidity memory-safe-assembly
228         assembly {
229             result := store
230         }
231 
232         return result;
233     }
234 
235     // AddressSet
236 
237     struct AddressSet {
238         Set _inner;
239     }
240 
241     /**
242      * @dev Add a value to a set. O(1).
243      *
244      * Returns true if the value was added to the set, that is if it was not
245      * already present.
246      */
247     function add(AddressSet storage set, address value) internal returns (bool) {
248         return _add(set._inner, bytes32(uint256(uint160(value))));
249     }
250 
251     /**
252      * @dev Removes a value from a set. O(1).
253      *
254      * Returns true if the value was removed from the set, that is if it was
255      * present.
256      */
257     function remove(AddressSet storage set, address value) internal returns (bool) {
258         return _remove(set._inner, bytes32(uint256(uint160(value))));
259     }
260 
261     /**
262      * @dev Returns true if the value is in the set. O(1).
263      */
264     function contains(AddressSet storage set, address value) internal view returns (bool) {
265         return _contains(set._inner, bytes32(uint256(uint160(value))));
266     }
267 
268     /**
269      * @dev Returns the number of values in the set. O(1).
270      */
271     function length(AddressSet storage set) internal view returns (uint256) {
272         return _length(set._inner);
273     }
274 
275     /**
276      * @dev Returns the value stored at position `index` in the set. O(1).
277      *
278      * Note that there are no guarantees on the ordering of values inside the
279      * array, and it may change when more values are added or removed.
280      *
281      * Requirements:
282      *
283      * - `index` must be strictly less than {length}.
284      */
285     function at(AddressSet storage set, uint256 index) internal view returns (address) {
286         return address(uint160(uint256(_at(set._inner, index))));
287     }
288 
289     /**
290      * @dev Return the entire set in an array
291      *
292      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
293      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
294      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
295      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
296      */
297     function values(AddressSet storage set) internal view returns (address[] memory) {
298         bytes32[] memory store = _values(set._inner);
299         address[] memory result;
300 
301         /// @solidity memory-safe-assembly
302         assembly {
303             result := store
304         }
305 
306         return result;
307     }
308 
309     // UintSet
310 
311     struct UintSet {
312         Set _inner;
313     }
314 
315     /**
316      * @dev Add a value to a set. O(1).
317      *
318      * Returns true if the value was added to the set, that is if it was not
319      * already present.
320      */
321     function add(UintSet storage set, uint256 value) internal returns (bool) {
322         return _add(set._inner, bytes32(value));
323     }
324 
325     /**
326      * @dev Removes a value from a set. O(1).
327      *
328      * Returns true if the value was removed from the set, that is if it was
329      * present.
330      */
331     function remove(UintSet storage set, uint256 value) internal returns (bool) {
332         return _remove(set._inner, bytes32(value));
333     }
334 
335     /**
336      * @dev Returns true if the value is in the set. O(1).
337      */
338     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
339         return _contains(set._inner, bytes32(value));
340     }
341 
342     /**
343      * @dev Returns the number of values in the set. O(1).
344      */
345     function length(UintSet storage set) internal view returns (uint256) {
346         return _length(set._inner);
347     }
348 
349     /**
350      * @dev Returns the value stored at position `index` in the set. O(1).
351      *
352      * Note that there are no guarantees on the ordering of values inside the
353      * array, and it may change when more values are added or removed.
354      *
355      * Requirements:
356      *
357      * - `index` must be strictly less than {length}.
358      */
359     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
360         return uint256(_at(set._inner, index));
361     }
362 
363     /**
364      * @dev Return the entire set in an array
365      *
366      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
367      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
368      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
369      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
370      */
371     function values(UintSet storage set) internal view returns (uint256[] memory) {
372         bytes32[] memory store = _values(set._inner);
373         uint256[] memory result;
374 
375         /// @solidity memory-safe-assembly
376         assembly {
377             result := store
378         }
379 
380         return result;
381     }
382 }
383 
384 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/introspection/IERC165.sol
385 
386 
387 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 /**
392  * @dev Interface of the ERC165 standard, as defined in the
393  * https://eips.ethereum.org/EIPS/eip-165[EIP].
394  *
395  * Implementers can declare support of contract interfaces, which can then be
396  * queried by others ({ERC165Checker}).
397  *
398  * For an implementation, see {ERC165}.
399  */
400 interface IERC165 {
401     /**
402      * @dev Returns true if this contract implements the interface defined by
403      * `interfaceId`. See the corresponding
404      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
405      * to learn more about how these ids are created.
406      *
407      * This function call must use less than 30 000 gas.
408      */
409     function supportsInterface(bytes4 interfaceId) external view returns (bool);
410 }
411 
412 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/introspection/ERC165.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Implementation of the {IERC165} interface.
422  *
423  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
424  * for the additional interface id that will be supported. For example:
425  *
426  * ```solidity
427  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
428  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
429  * }
430  * ```
431  *
432  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
433  */
434 abstract contract ERC165 is IERC165 {
435     /**
436      * @dev See {IERC165-supportsInterface}.
437      */
438     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
439         return interfaceId == type(IERC165).interfaceId;
440     }
441 }
442 
443 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/math/Math.sol
444 
445 
446 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev Standard math utilities missing in the Solidity language.
452  */
453 library Math {
454     enum Rounding {
455         Down, // Toward negative infinity
456         Up, // Toward infinity
457         Zero // Toward zero
458     }
459 
460     /**
461      * @dev Returns the largest of two numbers.
462      */
463     function max(uint256 a, uint256 b) internal pure returns (uint256) {
464         return a > b ? a : b;
465     }
466 
467     /**
468      * @dev Returns the smallest of two numbers.
469      */
470     function min(uint256 a, uint256 b) internal pure returns (uint256) {
471         return a < b ? a : b;
472     }
473 
474     /**
475      * @dev Returns the average of two numbers. The result is rounded towards
476      * zero.
477      */
478     function average(uint256 a, uint256 b) internal pure returns (uint256) {
479         // (a + b) / 2 can overflow.
480         return (a & b) + (a ^ b) / 2;
481     }
482 
483     /**
484      * @dev Returns the ceiling of the division of two numbers.
485      *
486      * This differs from standard division with `/` in that it rounds up instead
487      * of rounding down.
488      */
489     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
490         // (a + b - 1) / b can overflow on addition, so we distribute.
491         return a == 0 ? 0 : (a - 1) / b + 1;
492     }
493 
494     /**
495      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
496      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
497      * with further edits by Uniswap Labs also under MIT license.
498      */
499     function mulDiv(
500         uint256 x,
501         uint256 y,
502         uint256 denominator
503     ) internal pure returns (uint256 result) {
504         unchecked {
505             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
506             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
507             // variables such that product = prod1 * 2^256 + prod0.
508             uint256 prod0; // Least significant 256 bits of the product
509             uint256 prod1; // Most significant 256 bits of the product
510             assembly {
511                 let mm := mulmod(x, y, not(0))
512                 prod0 := mul(x, y)
513                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
514             }
515 
516             // Handle non-overflow cases, 256 by 256 division.
517             if (prod1 == 0) {
518                 return prod0 / denominator;
519             }
520 
521             // Make sure the result is less than 2^256. Also prevents denominator == 0.
522             require(denominator > prod1);
523 
524             ///////////////////////////////////////////////
525             // 512 by 256 division.
526             ///////////////////////////////////////////////
527 
528             // Make division exact by subtracting the remainder from [prod1 prod0].
529             uint256 remainder;
530             assembly {
531                 // Compute remainder using mulmod.
532                 remainder := mulmod(x, y, denominator)
533 
534                 // Subtract 256 bit number from 512 bit number.
535                 prod1 := sub(prod1, gt(remainder, prod0))
536                 prod0 := sub(prod0, remainder)
537             }
538 
539             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
540             // See https://cs.stackexchange.com/q/138556/92363.
541 
542             // Does not overflow because the denominator cannot be zero at this stage in the function.
543             uint256 twos = denominator & (~denominator + 1);
544             assembly {
545                 // Divide denominator by twos.
546                 denominator := div(denominator, twos)
547 
548                 // Divide [prod1 prod0] by twos.
549                 prod0 := div(prod0, twos)
550 
551                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
552                 twos := add(div(sub(0, twos), twos), 1)
553             }
554 
555             // Shift in bits from prod1 into prod0.
556             prod0 |= prod1 * twos;
557 
558             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
559             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
560             // four bits. That is, denominator * inv = 1 mod 2^4.
561             uint256 inverse = (3 * denominator) ^ 2;
562 
563             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
564             // in modular arithmetic, doubling the correct bits in each step.
565             inverse *= 2 - denominator * inverse; // inverse mod 2^8
566             inverse *= 2 - denominator * inverse; // inverse mod 2^16
567             inverse *= 2 - denominator * inverse; // inverse mod 2^32
568             inverse *= 2 - denominator * inverse; // inverse mod 2^64
569             inverse *= 2 - denominator * inverse; // inverse mod 2^128
570             inverse *= 2 - denominator * inverse; // inverse mod 2^256
571 
572             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
573             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
574             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
575             // is no longer required.
576             result = prod0 * inverse;
577             return result;
578         }
579     }
580 
581     /**
582      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
583      */
584     function mulDiv(
585         uint256 x,
586         uint256 y,
587         uint256 denominator,
588         Rounding rounding
589     ) internal pure returns (uint256) {
590         uint256 result = mulDiv(x, y, denominator);
591         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
592             result += 1;
593         }
594         return result;
595     }
596 
597     /**
598      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
599      *
600      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
601      */
602     function sqrt(uint256 a) internal pure returns (uint256) {
603         if (a == 0) {
604             return 0;
605         }
606 
607         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
608         //
609         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
610         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
611         //
612         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
613         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
614         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
615         //
616         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
617         uint256 result = 1 << (log2(a) >> 1);
618 
619         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
620         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
621         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
622         // into the expected uint128 result.
623         unchecked {
624             result = (result + a / result) >> 1;
625             result = (result + a / result) >> 1;
626             result = (result + a / result) >> 1;
627             result = (result + a / result) >> 1;
628             result = (result + a / result) >> 1;
629             result = (result + a / result) >> 1;
630             result = (result + a / result) >> 1;
631             return min(result, a / result);
632         }
633     }
634 
635     /**
636      * @notice Calculates sqrt(a), following the selected rounding direction.
637      */
638     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
639         unchecked {
640             uint256 result = sqrt(a);
641             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
642         }
643     }
644 
645     /**
646      * @dev Return the log in base 2, rounded down, of a positive value.
647      * Returns 0 if given 0.
648      */
649     function log2(uint256 value) internal pure returns (uint256) {
650         uint256 result = 0;
651         unchecked {
652             if (value >> 128 > 0) {
653                 value >>= 128;
654                 result += 128;
655             }
656             if (value >> 64 > 0) {
657                 value >>= 64;
658                 result += 64;
659             }
660             if (value >> 32 > 0) {
661                 value >>= 32;
662                 result += 32;
663             }
664             if (value >> 16 > 0) {
665                 value >>= 16;
666                 result += 16;
667             }
668             if (value >> 8 > 0) {
669                 value >>= 8;
670                 result += 8;
671             }
672             if (value >> 4 > 0) {
673                 value >>= 4;
674                 result += 4;
675             }
676             if (value >> 2 > 0) {
677                 value >>= 2;
678                 result += 2;
679             }
680             if (value >> 1 > 0) {
681                 result += 1;
682             }
683         }
684         return result;
685     }
686 
687     /**
688      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
689      * Returns 0 if given 0.
690      */
691     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
692         unchecked {
693             uint256 result = log2(value);
694             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
695         }
696     }
697 
698     /**
699      * @dev Return the log in base 10, rounded down, of a positive value.
700      * Returns 0 if given 0.
701      */
702     function log10(uint256 value) internal pure returns (uint256) {
703         uint256 result = 0;
704         unchecked {
705             if (value >= 10**64) {
706                 value /= 10**64;
707                 result += 64;
708             }
709             if (value >= 10**32) {
710                 value /= 10**32;
711                 result += 32;
712             }
713             if (value >= 10**16) {
714                 value /= 10**16;
715                 result += 16;
716             }
717             if (value >= 10**8) {
718                 value /= 10**8;
719                 result += 8;
720             }
721             if (value >= 10**4) {
722                 value /= 10**4;
723                 result += 4;
724             }
725             if (value >= 10**2) {
726                 value /= 10**2;
727                 result += 2;
728             }
729             if (value >= 10**1) {
730                 result += 1;
731             }
732         }
733         return result;
734     }
735 
736     /**
737      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
738      * Returns 0 if given 0.
739      */
740     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
741         unchecked {
742             uint256 result = log10(value);
743             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
744         }
745     }
746 
747     /**
748      * @dev Return the log in base 256, rounded down, of a positive value.
749      * Returns 0 if given 0.
750      *
751      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
752      */
753     function log256(uint256 value) internal pure returns (uint256) {
754         uint256 result = 0;
755         unchecked {
756             if (value >> 128 > 0) {
757                 value >>= 128;
758                 result += 16;
759             }
760             if (value >> 64 > 0) {
761                 value >>= 64;
762                 result += 8;
763             }
764             if (value >> 32 > 0) {
765                 value >>= 32;
766                 result += 4;
767             }
768             if (value >> 16 > 0) {
769                 value >>= 16;
770                 result += 2;
771             }
772             if (value >> 8 > 0) {
773                 result += 1;
774             }
775         }
776         return result;
777     }
778 
779     /**
780      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
781      * Returns 0 if given 0.
782      */
783     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
784         unchecked {
785             uint256 result = log256(value);
786             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
787         }
788     }
789 }
790 
791 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/Strings.sol
792 
793 
794 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
795 
796 pragma solidity ^0.8.0;
797 
798 
799 /**
800  * @dev String operations.
801  */
802 library Strings {
803     bytes16 private constant _SYMBOLS = "0123456789abcdef";
804     uint8 private constant _ADDRESS_LENGTH = 20;
805 
806     /**
807      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
808      */
809     function toString(uint256 value) internal pure returns (string memory) {
810         unchecked {
811             uint256 length = Math.log10(value) + 1;
812             string memory buffer = new string(length);
813             uint256 ptr;
814             /// @solidity memory-safe-assembly
815             assembly {
816                 ptr := add(buffer, add(32, length))
817             }
818             while (true) {
819                 ptr--;
820                 /// @solidity memory-safe-assembly
821                 assembly {
822                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
823                 }
824                 value /= 10;
825                 if (value == 0) break;
826             }
827             return buffer;
828         }
829     }
830 
831     /**
832      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
833      */
834     function toHexString(uint256 value) internal pure returns (string memory) {
835         unchecked {
836             return toHexString(value, Math.log256(value) + 1);
837         }
838     }
839 
840     /**
841      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
842      */
843     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
844         bytes memory buffer = new bytes(2 * length + 2);
845         buffer[0] = "0";
846         buffer[1] = "x";
847         for (uint256 i = 2 * length + 1; i > 1; --i) {
848             buffer[i] = _SYMBOLS[value & 0xf];
849             value >>= 4;
850         }
851         require(value == 0, "Strings: hex length insufficient");
852         return string(buffer);
853     }
854 
855     /**
856      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
857      */
858     function toHexString(address addr) internal pure returns (string memory) {
859         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
860     }
861 }
862 
863 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/access/IAccessControl.sol
864 
865 
866 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
867 
868 pragma solidity ^0.8.0;
869 
870 /**
871  * @dev External interface of AccessControl declared to support ERC165 detection.
872  */
873 interface IAccessControl {
874     /**
875      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
876      *
877      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
878      * {RoleAdminChanged} not being emitted signaling this.
879      *
880      * _Available since v3.1._
881      */
882     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
883 
884     /**
885      * @dev Emitted when `account` is granted `role`.
886      *
887      * `sender` is the account that originated the contract call, an admin role
888      * bearer except when using {AccessControl-_setupRole}.
889      */
890     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
891 
892     /**
893      * @dev Emitted when `account` is revoked `role`.
894      *
895      * `sender` is the account that originated the contract call:
896      *   - if using `revokeRole`, it is the admin role bearer
897      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
898      */
899     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
900 
901     /**
902      * @dev Returns `true` if `account` has been granted `role`.
903      */
904     function hasRole(bytes32 role, address account) external view returns (bool);
905 
906     /**
907      * @dev Returns the admin role that controls `role`. See {grantRole} and
908      * {revokeRole}.
909      *
910      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
911      */
912     function getRoleAdmin(bytes32 role) external view returns (bytes32);
913 
914     /**
915      * @dev Grants `role` to `account`.
916      *
917      * If `account` had not been already granted `role`, emits a {RoleGranted}
918      * event.
919      *
920      * Requirements:
921      *
922      * - the caller must have ``role``'s admin role.
923      */
924     function grantRole(bytes32 role, address account) external;
925 
926     /**
927      * @dev Revokes `role` from `account`.
928      *
929      * If `account` had been granted `role`, emits a {RoleRevoked} event.
930      *
931      * Requirements:
932      *
933      * - the caller must have ``role``'s admin role.
934      */
935     function revokeRole(bytes32 role, address account) external;
936 
937     /**
938      * @dev Revokes `role` from the calling account.
939      *
940      * Roles are often managed via {grantRole} and {revokeRole}: this function's
941      * purpose is to provide a mechanism for accounts to lose their privileges
942      * if they are compromised (such as when a trusted device is misplaced).
943      *
944      * If the calling account had been granted `role`, emits a {RoleRevoked}
945      * event.
946      *
947      * Requirements:
948      *
949      * - the caller must be `account`.
950      */
951     function renounceRole(bytes32 role, address account) external;
952 }
953 
954 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/access/IAccessControlEnumerable.sol
955 
956 
957 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
958 
959 pragma solidity ^0.8.0;
960 
961 
962 /**
963  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
964  */
965 interface IAccessControlEnumerable is IAccessControl {
966     /**
967      * @dev Returns one of the accounts that have `role`. `index` must be a
968      * value between 0 and {getRoleMemberCount}, non-inclusive.
969      *
970      * Role bearers are not sorted in any particular way, and their ordering may
971      * change at any point.
972      *
973      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
974      * you perform all queries on the same block. See the following
975      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
976      * for more information.
977      */
978     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
979 
980     /**
981      * @dev Returns the number of accounts that have `role`. Can be used
982      * together with {getRoleMember} to enumerate all bearers of a role.
983      */
984     function getRoleMemberCount(bytes32 role) external view returns (uint256);
985 }
986 
987 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/Context.sol
988 
989 
990 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
991 
992 pragma solidity ^0.8.0;
993 
994 /**
995  * @dev Provides information about the current execution context, including the
996  * sender of the transaction and its data. While these are generally available
997  * via msg.sender and msg.data, they should not be accessed in such a direct
998  * manner, since when dealing with meta-transactions the account sending and
999  * paying for execution may not be the actual sender (as far as an application
1000  * is concerned).
1001  *
1002  * This contract is only required for intermediate, library-like contracts.
1003  */
1004 abstract contract Context {
1005     function _msgSender() internal view virtual returns (address) {
1006         return msg.sender;
1007     }
1008 
1009     function _msgData() internal view virtual returns (bytes calldata) {
1010         return msg.data;
1011     }
1012 }
1013 
1014 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/access/Ownable.sol
1015 
1016 
1017 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 
1022 /**
1023  * @dev Contract module which provides a basic access control mechanism, where
1024  * there is an account (an owner) that can be granted exclusive access to
1025  * specific functions.
1026  *
1027  * By default, the owner account will be the one that deploys the contract. This
1028  * can later be changed with {transferOwnership}.
1029  *
1030  * This module is used through inheritance. It will make available the modifier
1031  * `onlyOwner`, which can be applied to your functions to restrict their use to
1032  * the owner.
1033  */
1034 abstract contract Ownable is Context {
1035     address private _owner;
1036 
1037     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1038 
1039     /**
1040      * @dev Initializes the contract setting the deployer as the initial owner.
1041      */
1042     constructor() {
1043         _transferOwnership(_msgSender());
1044     }
1045 
1046     /**
1047      * @dev Throws if called by any account other than the owner.
1048      */
1049     modifier onlyOwner() {
1050         _checkOwner();
1051         _;
1052     }
1053 
1054     /**
1055      * @dev Returns the address of the current owner.
1056      */
1057     function owner() public view virtual returns (address) {
1058         return _owner;
1059     }
1060 
1061     /**
1062      * @dev Throws if the sender is not the owner.
1063      */
1064     function _checkOwner() internal view virtual {
1065         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1066     }
1067 
1068     /**
1069      * @dev Leaves the contract without owner. It will not be possible to call
1070      * `onlyOwner` functions anymore. Can only be called by the current owner.
1071      *
1072      * NOTE: Renouncing ownership will leave the contract without an owner,
1073      * thereby removing any functionality that is only available to the owner.
1074      */
1075     function renounceOwnership() public virtual onlyOwner {
1076         _transferOwnership(address(0));
1077     }
1078 
1079     /**
1080      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1081      * Can only be called by the current owner.
1082      */
1083     function transferOwnership(address newOwner) public virtual onlyOwner {
1084         require(newOwner != address(0), "Ownable: new owner is the zero address");
1085         _transferOwnership(newOwner);
1086     }
1087 
1088     /**
1089      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1090      * Internal function without access restriction.
1091      */
1092     function _transferOwnership(address newOwner) internal virtual {
1093         address oldOwner = _owner;
1094         _owner = newOwner;
1095         emit OwnershipTransferred(oldOwner, newOwner);
1096     }
1097 }
1098 
1099 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/access/AccessControl.sol
1100 
1101 
1102 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
1103 
1104 pragma solidity ^0.8.0;
1105 
1106 
1107 
1108 
1109 
1110 /**
1111  * @dev Contract module that allows children to implement role-based access
1112  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1113  * members except through off-chain means by accessing the contract event logs. Some
1114  * applications may benefit from on-chain enumerability, for those cases see
1115  * {AccessControlEnumerable}.
1116  *
1117  * Roles are referred to by their `bytes32` identifier. These should be exposed
1118  * in the external API and be unique. The best way to achieve this is by
1119  * using `public constant` hash digests:
1120  *
1121  * ```
1122  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1123  * ```
1124  *
1125  * Roles can be used to represent a set of permissions. To restrict access to a
1126  * function call, use {hasRole}:
1127  *
1128  * ```
1129  * function foo() public {
1130  *     require(hasRole(MY_ROLE, msg.sender));
1131  *     ...
1132  * }
1133  * ```
1134  *
1135  * Roles can be granted and revoked dynamically via the {grantRole} and
1136  * {revokeRole} functions. Each role has an associated admin role, and only
1137  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1138  *
1139  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1140  * that only accounts with this role will be able to grant or revoke other
1141  * roles. More complex role relationships can be created by using
1142  * {_setRoleAdmin}.
1143  *
1144  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1145  * grant and revoke this role. Extra precautions should be taken to secure
1146  * accounts that have been granted it.
1147  */
1148 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1149     struct RoleData {
1150         mapping(address => bool) members;
1151         bytes32 adminRole;
1152     }
1153 
1154     mapping(bytes32 => RoleData) private _roles;
1155 
1156     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1157 
1158     /**
1159      * @dev Modifier that checks that an account has a specific role. Reverts
1160      * with a standardized message including the required role.
1161      *
1162      * The format of the revert reason is given by the following regular expression:
1163      *
1164      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1165      *
1166      * _Available since v4.1._
1167      */
1168     modifier onlyRole(bytes32 role) {
1169         _checkRole(role);
1170         _;
1171     }
1172 
1173     /**
1174      * @dev See {IERC165-supportsInterface}.
1175      */
1176     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1177         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1178     }
1179 
1180     /**
1181      * @dev Returns `true` if `account` has been granted `role`.
1182      */
1183     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1184         return _roles[role].members[account];
1185     }
1186 
1187     /**
1188      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1189      * Overriding this function changes the behavior of the {onlyRole} modifier.
1190      *
1191      * Format of the revert message is described in {_checkRole}.
1192      *
1193      * _Available since v4.6._
1194      */
1195     function _checkRole(bytes32 role) internal view virtual {
1196         _checkRole(role, _msgSender());
1197     }
1198 
1199     /**
1200      * @dev Revert with a standard message if `account` is missing `role`.
1201      *
1202      * The format of the revert reason is given by the following regular expression:
1203      *
1204      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1205      */
1206     function _checkRole(bytes32 role, address account) internal view virtual {
1207         if (!hasRole(role, account)) {
1208             revert(
1209                 string(
1210                     abi.encodePacked(
1211                         "AccessControl: account ",
1212                         Strings.toHexString(account),
1213                         " is missing role ",
1214                         Strings.toHexString(uint256(role), 32)
1215                     )
1216                 )
1217             );
1218         }
1219     }
1220 
1221     /**
1222      * @dev Returns the admin role that controls `role`. See {grantRole} and
1223      * {revokeRole}.
1224      *
1225      * To change a role's admin, use {_setRoleAdmin}.
1226      */
1227     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1228         return _roles[role].adminRole;
1229     }
1230 
1231     /**
1232      * @dev Grants `role` to `account`.
1233      *
1234      * If `account` had not been already granted `role`, emits a {RoleGranted}
1235      * event.
1236      *
1237      * Requirements:
1238      *
1239      * - the caller must have ``role``'s admin role.
1240      *
1241      * May emit a {RoleGranted} event.
1242      */
1243     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1244         _grantRole(role, account);
1245     }
1246 
1247     /**
1248      * @dev Revokes `role` from `account`.
1249      *
1250      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1251      *
1252      * Requirements:
1253      *
1254      * - the caller must have ``role``'s admin role.
1255      *
1256      * May emit a {RoleRevoked} event.
1257      */
1258     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1259         _revokeRole(role, account);
1260     }
1261 
1262     /**
1263      * @dev Revokes `role` from the calling account.
1264      *
1265      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1266      * purpose is to provide a mechanism for accounts to lose their privileges
1267      * if they are compromised (such as when a trusted device is misplaced).
1268      *
1269      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1270      * event.
1271      *
1272      * Requirements:
1273      *
1274      * - the caller must be `account`.
1275      *
1276      * May emit a {RoleRevoked} event.
1277      */
1278     function renounceRole(bytes32 role, address account) public virtual override {
1279         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1280 
1281         _revokeRole(role, account);
1282     }
1283 
1284     /**
1285      * @dev Grants `role` to `account`.
1286      *
1287      * If `account` had not been already granted `role`, emits a {RoleGranted}
1288      * event. Note that unlike {grantRole}, this function doesn't perform any
1289      * checks on the calling account.
1290      *
1291      * May emit a {RoleGranted} event.
1292      *
1293      * [WARNING]
1294      * ====
1295      * This function should only be called from the constructor when setting
1296      * up the initial roles for the system.
1297      *
1298      * Using this function in any other way is effectively circumventing the admin
1299      * system imposed by {AccessControl}.
1300      * ====
1301      *
1302      * NOTE: This function is deprecated in favor of {_grantRole}.
1303      */
1304     function _setupRole(bytes32 role, address account) internal virtual {
1305         _grantRole(role, account);
1306     }
1307 
1308     /**
1309      * @dev Sets `adminRole` as ``role``'s admin role.
1310      *
1311      * Emits a {RoleAdminChanged} event.
1312      */
1313     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1314         bytes32 previousAdminRole = getRoleAdmin(role);
1315         _roles[role].adminRole = adminRole;
1316         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1317     }
1318 
1319     /**
1320      * @dev Grants `role` to `account`.
1321      *
1322      * Internal function without access restriction.
1323      *
1324      * May emit a {RoleGranted} event.
1325      */
1326     function _grantRole(bytes32 role, address account) internal virtual {
1327         if (!hasRole(role, account)) {
1328             _roles[role].members[account] = true;
1329             emit RoleGranted(role, account, _msgSender());
1330         }
1331     }
1332 
1333     /**
1334      * @dev Revokes `role` from `account`.
1335      *
1336      * Internal function without access restriction.
1337      *
1338      * May emit a {RoleRevoked} event.
1339      */
1340     function _revokeRole(bytes32 role, address account) internal virtual {
1341         if (hasRole(role, account)) {
1342             _roles[role].members[account] = false;
1343             emit RoleRevoked(role, account, _msgSender());
1344         }
1345     }
1346 }
1347 
1348 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/access/AccessControlEnumerable.sol
1349 
1350 
1351 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1352 
1353 pragma solidity ^0.8.0;
1354 
1355 
1356 
1357 
1358 /**
1359  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1360  */
1361 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1362     using EnumerableSet for EnumerableSet.AddressSet;
1363 
1364     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1365 
1366     /**
1367      * @dev See {IERC165-supportsInterface}.
1368      */
1369     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1370         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1371     }
1372 
1373     /**
1374      * @dev Returns one of the accounts that have `role`. `index` must be a
1375      * value between 0 and {getRoleMemberCount}, non-inclusive.
1376      *
1377      * Role bearers are not sorted in any particular way, and their ordering may
1378      * change at any point.
1379      *
1380      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1381      * you perform all queries on the same block. See the following
1382      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1383      * for more information.
1384      */
1385     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1386         return _roleMembers[role].at(index);
1387     }
1388 
1389     /**
1390      * @dev Returns the number of accounts that have `role`. Can be used
1391      * together with {getRoleMember} to enumerate all bearers of a role.
1392      */
1393     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1394         return _roleMembers[role].length();
1395     }
1396 
1397     /**
1398      * @dev Overload {_grantRole} to track enumerable memberships
1399      */
1400     function _grantRole(bytes32 role, address account) internal virtual override {
1401         super._grantRole(role, account);
1402         _roleMembers[role].add(account);
1403     }
1404 
1405     /**
1406      * @dev Overload {_revokeRole} to track enumerable memberships
1407      */
1408     function _revokeRole(bytes32 role, address account) internal virtual override {
1409         super._revokeRole(role, account);
1410         _roleMembers[role].remove(account);
1411     }
1412 }
1413 
1414 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/security/Pausable.sol
1415 
1416 
1417 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1418 
1419 pragma solidity ^0.8.0;
1420 
1421 
1422 /**
1423  * @dev Contract module which allows children to implement an emergency stop
1424  * mechanism that can be triggered by an authorized account.
1425  *
1426  * This module is used through inheritance. It will make available the
1427  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1428  * the functions of your contract. Note that they will not be pausable by
1429  * simply including this module, only once the modifiers are put in place.
1430  */
1431 abstract contract Pausable is Context {
1432     /**
1433      * @dev Emitted when the pause is triggered by `account`.
1434      */
1435     event Paused(address account);
1436 
1437     /**
1438      * @dev Emitted when the pause is lifted by `account`.
1439      */
1440     event Unpaused(address account);
1441 
1442     bool private _paused;
1443 
1444     /**
1445      * @dev Initializes the contract in unpaused state.
1446      */
1447     constructor() {
1448         _paused = false;
1449     }
1450 
1451     /**
1452      * @dev Modifier to make a function callable only when the contract is not paused.
1453      *
1454      * Requirements:
1455      *
1456      * - The contract must not be paused.
1457      */
1458     modifier whenNotPaused() {
1459         _requireNotPaused();
1460         _;
1461     }
1462 
1463     /**
1464      * @dev Modifier to make a function callable only when the contract is paused.
1465      *
1466      * Requirements:
1467      *
1468      * - The contract must be paused.
1469      */
1470     modifier whenPaused() {
1471         _requirePaused();
1472         _;
1473     }
1474 
1475     /**
1476      * @dev Returns true if the contract is paused, and false otherwise.
1477      */
1478     function paused() public view virtual returns (bool) {
1479         return _paused;
1480     }
1481 
1482     /**
1483      * @dev Throws if the contract is paused.
1484      */
1485     function _requireNotPaused() internal view virtual {
1486         require(!paused(), "Pausable: paused");
1487     }
1488 
1489     /**
1490      * @dev Throws if the contract is not paused.
1491      */
1492     function _requirePaused() internal view virtual {
1493         require(paused(), "Pausable: not paused");
1494     }
1495 
1496     /**
1497      * @dev Triggers stopped state.
1498      *
1499      * Requirements:
1500      *
1501      * - The contract must not be paused.
1502      */
1503     function _pause() internal virtual whenNotPaused {
1504         _paused = true;
1505         emit Paused(_msgSender());
1506     }
1507 
1508     /**
1509      * @dev Returns to normal state.
1510      *
1511      * Requirements:
1512      *
1513      * - The contract must be paused.
1514      */
1515     function _unpause() internal virtual whenPaused {
1516         _paused = false;
1517         emit Unpaused(_msgSender());
1518     }
1519 }
1520 
1521 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC20/IERC20.sol
1522 
1523 
1524 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1525 
1526 pragma solidity ^0.8.0;
1527 
1528 /**
1529  * @dev Interface of the ERC20 standard as defined in the EIP.
1530  */
1531 interface IERC20 {
1532     /**
1533      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1534      * another (`to`).
1535      *
1536      * Note that `value` may be zero.
1537      */
1538     event Transfer(address indexed from, address indexed to, uint256 value);
1539 
1540     /**
1541      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1542      * a call to {approve}. `value` is the new allowance.
1543      */
1544     event Approval(address indexed owner, address indexed spender, uint256 value);
1545 
1546     /**
1547      * @dev Returns the amount of tokens in existence.
1548      */
1549     function totalSupply() external view returns (uint256);
1550 
1551     /**
1552      * @dev Returns the amount of tokens owned by `account`.
1553      */
1554     function balanceOf(address account) external view returns (uint256);
1555 
1556     /**
1557      * @dev Moves `amount` tokens from the caller's account to `to`.
1558      *
1559      * Returns a boolean value indicating whether the operation succeeded.
1560      *
1561      * Emits a {Transfer} event.
1562      */
1563     function transfer(address to, uint256 amount) external returns (bool);
1564 
1565     /**
1566      * @dev Returns the remaining number of tokens that `spender` will be
1567      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1568      * zero by default.
1569      *
1570      * This value changes when {approve} or {transferFrom} are called.
1571      */
1572     function allowance(address owner, address spender) external view returns (uint256);
1573 
1574     /**
1575      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1576      *
1577      * Returns a boolean value indicating whether the operation succeeded.
1578      *
1579      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1580      * that someone may use both the old and the new allowance by unfortunate
1581      * transaction ordering. One possible solution to mitigate this race
1582      * condition is to first reduce the spender's allowance to 0 and set the
1583      * desired value afterwards:
1584      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1585      *
1586      * Emits an {Approval} event.
1587      */
1588     function approve(address spender, uint256 amount) external returns (bool);
1589 
1590     /**
1591      * @dev Moves `amount` tokens from `from` to `to` using the
1592      * allowance mechanism. `amount` is then deducted from the caller's
1593      * allowance.
1594      *
1595      * Returns a boolean value indicating whether the operation succeeded.
1596      *
1597      * Emits a {Transfer} event.
1598      */
1599     function transferFrom(
1600         address from,
1601         address to,
1602         uint256 amount
1603     ) external returns (bool);
1604 }
1605 
1606 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC20/extensions/IERC20Metadata.sol
1607 
1608 
1609 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1610 
1611 pragma solidity ^0.8.0;
1612 
1613 
1614 /**
1615  * @dev Interface for the optional metadata functions from the ERC20 standard.
1616  *
1617  * _Available since v4.1._
1618  */
1619 interface IERC20Metadata is IERC20 {
1620     /**
1621      * @dev Returns the name of the token.
1622      */
1623     function name() external view returns (string memory);
1624 
1625     /**
1626      * @dev Returns the symbol of the token.
1627      */
1628     function symbol() external view returns (string memory);
1629 
1630     /**
1631      * @dev Returns the decimals places of the token.
1632      */
1633     function decimals() external view returns (uint8);
1634 }
1635 
1636 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC20/ERC20.sol
1637 
1638 
1639 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
1640 
1641 pragma solidity ^0.8.0;
1642 
1643 
1644 
1645 
1646 /**
1647  * @dev Implementation of the {IERC20} interface.
1648  *
1649  * This implementation is agnostic to the way tokens are created. This means
1650  * that a supply mechanism has to be added in a derived contract using {_mint}.
1651  * For a generic mechanism see {ERC20PresetMinterPauser}.
1652  *
1653  * TIP: For a detailed writeup see our guide
1654  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1655  * to implement supply mechanisms].
1656  *
1657  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1658  * instead returning `false` on failure. This behavior is nonetheless
1659  * conventional and does not conflict with the expectations of ERC20
1660  * applications.
1661  *
1662  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1663  * This allows applications to reconstruct the allowance for all accounts just
1664  * by listening to said events. Other implementations of the EIP may not emit
1665  * these events, as it isn't required by the specification.
1666  *
1667  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1668  * functions have been added to mitigate the well-known issues around setting
1669  * allowances. See {IERC20-approve}.
1670  */
1671 contract ERC20 is Context, IERC20, IERC20Metadata {
1672     mapping(address => uint256) private _balances;
1673 
1674     mapping(address => mapping(address => uint256)) private _allowances;
1675 
1676     uint256 private _totalSupply;
1677 
1678     string private _name;
1679     string private _symbol;
1680 
1681     /**
1682      * @dev Sets the values for {name} and {symbol}.
1683      *
1684      * The default value of {decimals} is 18. To select a different value for
1685      * {decimals} you should overload it.
1686      *
1687      * All two of these values are immutable: they can only be set once during
1688      * construction.
1689      */
1690     constructor(string memory name_, string memory symbol_) {
1691         _name = name_;
1692         _symbol = symbol_;
1693     }
1694 
1695     /**
1696      * @dev Returns the name of the token.
1697      */
1698     function name() public view virtual override returns (string memory) {
1699         return _name;
1700     }
1701 
1702     /**
1703      * @dev Returns the symbol of the token, usually a shorter version of the
1704      * name.
1705      */
1706     function symbol() public view virtual override returns (string memory) {
1707         return _symbol;
1708     }
1709 
1710     /**
1711      * @dev Returns the number of decimals used to get its user representation.
1712      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1713      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1714      *
1715      * Tokens usually opt for a value of 18, imitating the relationship between
1716      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1717      * overridden;
1718      *
1719      * NOTE: This information is only used for _display_ purposes: it in
1720      * no way affects any of the arithmetic of the contract, including
1721      * {IERC20-balanceOf} and {IERC20-transfer}.
1722      */
1723     function decimals() public view virtual override returns (uint8) {
1724         return 18;
1725     }
1726 
1727     /**
1728      * @dev See {IERC20-totalSupply}.
1729      */
1730     function totalSupply() public view virtual override returns (uint256) {
1731         return _totalSupply;
1732     }
1733 
1734     /**
1735      * @dev See {IERC20-balanceOf}.
1736      */
1737     function balanceOf(address account) public view virtual override returns (uint256) {
1738         return _balances[account];
1739     }
1740 
1741     /**
1742      * @dev See {IERC20-transfer}.
1743      *
1744      * Requirements:
1745      *
1746      * - `to` cannot be the zero address.
1747      * - the caller must have a balance of at least `amount`.
1748      */
1749     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1750         address owner = _msgSender();
1751         _transfer(owner, to, amount);
1752         return true;
1753     }
1754 
1755     /**
1756      * @dev See {IERC20-allowance}.
1757      */
1758     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1759         return _allowances[owner][spender];
1760     }
1761 
1762     /**
1763      * @dev See {IERC20-approve}.
1764      *
1765      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1766      * `transferFrom`. This is semantically equivalent to an infinite approval.
1767      *
1768      * Requirements:
1769      *
1770      * - `spender` cannot be the zero address.
1771      */
1772     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1773         address owner = _msgSender();
1774         _approve(owner, spender, amount);
1775         return true;
1776     }
1777 
1778     /**
1779      * @dev See {IERC20-transferFrom}.
1780      *
1781      * Emits an {Approval} event indicating the updated allowance. This is not
1782      * required by the EIP. See the note at the beginning of {ERC20}.
1783      *
1784      * NOTE: Does not update the allowance if the current allowance
1785      * is the maximum `uint256`.
1786      *
1787      * Requirements:
1788      *
1789      * - `from` and `to` cannot be the zero address.
1790      * - `from` must have a balance of at least `amount`.
1791      * - the caller must have allowance for ``from``'s tokens of at least
1792      * `amount`.
1793      */
1794     function transferFrom(
1795         address from,
1796         address to,
1797         uint256 amount
1798     ) public virtual override returns (bool) {
1799         address spender = _msgSender();
1800         _spendAllowance(from, spender, amount);
1801         _transfer(from, to, amount);
1802         return true;
1803     }
1804 
1805     /**
1806      * @dev Atomically increases the allowance granted to `spender` by the caller.
1807      *
1808      * This is an alternative to {approve} that can be used as a mitigation for
1809      * problems described in {IERC20-approve}.
1810      *
1811      * Emits an {Approval} event indicating the updated allowance.
1812      *
1813      * Requirements:
1814      *
1815      * - `spender` cannot be the zero address.
1816      */
1817     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1818         address owner = _msgSender();
1819         _approve(owner, spender, allowance(owner, spender) + addedValue);
1820         return true;
1821     }
1822 
1823     /**
1824      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1825      *
1826      * This is an alternative to {approve} that can be used as a mitigation for
1827      * problems described in {IERC20-approve}.
1828      *
1829      * Emits an {Approval} event indicating the updated allowance.
1830      *
1831      * Requirements:
1832      *
1833      * - `spender` cannot be the zero address.
1834      * - `spender` must have allowance for the caller of at least
1835      * `subtractedValue`.
1836      */
1837     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1838         address owner = _msgSender();
1839         uint256 currentAllowance = allowance(owner, spender);
1840         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1841         unchecked {
1842             _approve(owner, spender, currentAllowance - subtractedValue);
1843         }
1844 
1845         return true;
1846     }
1847 
1848     /**
1849      * @dev Moves `amount` of tokens from `from` to `to`.
1850      *
1851      * This internal function is equivalent to {transfer}, and can be used to
1852      * e.g. implement automatic token fees, slashing mechanisms, etc.
1853      *
1854      * Emits a {Transfer} event.
1855      *
1856      * Requirements:
1857      *
1858      * - `from` cannot be the zero address.
1859      * - `to` cannot be the zero address.
1860      * - `from` must have a balance of at least `amount`.
1861      */
1862     function _transfer(
1863         address from,
1864         address to,
1865         uint256 amount
1866     ) internal virtual {
1867         require(from != address(0), "ERC20: transfer from the zero address");
1868         require(to != address(0), "ERC20: transfer to the zero address");
1869 
1870         _beforeTokenTransfer(from, to, amount);
1871 
1872         uint256 fromBalance = _balances[from];
1873         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1874         unchecked {
1875             _balances[from] = fromBalance - amount;
1876             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1877             // decrementing then incrementing.
1878             _balances[to] += amount;
1879         }
1880 
1881         emit Transfer(from, to, amount);
1882 
1883         _afterTokenTransfer(from, to, amount);
1884     }
1885 
1886     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1887      * the total supply.
1888      *
1889      * Emits a {Transfer} event with `from` set to the zero address.
1890      *
1891      * Requirements:
1892      *
1893      * - `account` cannot be the zero address.
1894      */
1895     function _mint(address account, uint256 amount) internal virtual {
1896         require(account != address(0), "ERC20: mint to the zero address");
1897 
1898         _beforeTokenTransfer(address(0), account, amount);
1899 
1900         _totalSupply += amount;
1901         unchecked {
1902             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1903             _balances[account] += amount;
1904         }
1905         emit Transfer(address(0), account, amount);
1906 
1907         _afterTokenTransfer(address(0), account, amount);
1908     }
1909 
1910     /**
1911      * @dev Destroys `amount` tokens from `account`, reducing the
1912      * total supply.
1913      *
1914      * Emits a {Transfer} event with `to` set to the zero address.
1915      *
1916      * Requirements:
1917      *
1918      * - `account` cannot be the zero address.
1919      * - `account` must have at least `amount` tokens.
1920      */
1921     function _burn(address account, uint256 amount) internal virtual {
1922         require(account != address(0), "ERC20: burn from the zero address");
1923 
1924         _beforeTokenTransfer(account, address(0), amount);
1925 
1926         uint256 accountBalance = _balances[account];
1927         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1928         unchecked {
1929             _balances[account] = accountBalance - amount;
1930             // Overflow not possible: amount <= accountBalance <= totalSupply.
1931             _totalSupply -= amount;
1932         }
1933 
1934         emit Transfer(account, address(0), amount);
1935 
1936         _afterTokenTransfer(account, address(0), amount);
1937     }
1938 
1939     /**
1940      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1941      *
1942      * This internal function is equivalent to `approve`, and can be used to
1943      * e.g. set automatic allowances for certain subsystems, etc.
1944      *
1945      * Emits an {Approval} event.
1946      *
1947      * Requirements:
1948      *
1949      * - `owner` cannot be the zero address.
1950      * - `spender` cannot be the zero address.
1951      */
1952     function _approve(
1953         address owner,
1954         address spender,
1955         uint256 amount
1956     ) internal virtual {
1957         require(owner != address(0), "ERC20: approve from the zero address");
1958         require(spender != address(0), "ERC20: approve to the zero address");
1959 
1960         _allowances[owner][spender] = amount;
1961         emit Approval(owner, spender, amount);
1962     }
1963 
1964     /**
1965      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1966      *
1967      * Does not update the allowance amount in case of infinite allowance.
1968      * Revert if not enough allowance is available.
1969      *
1970      * Might emit an {Approval} event.
1971      */
1972     function _spendAllowance(
1973         address owner,
1974         address spender,
1975         uint256 amount
1976     ) internal virtual {
1977         uint256 currentAllowance = allowance(owner, spender);
1978         if (currentAllowance != type(uint256).max) {
1979             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1980             unchecked {
1981                 _approve(owner, spender, currentAllowance - amount);
1982             }
1983         }
1984     }
1985 
1986     /**
1987      * @dev Hook that is called before any transfer of tokens. This includes
1988      * minting and burning.
1989      *
1990      * Calling conditions:
1991      *
1992      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1993      * will be transferred to `to`.
1994      * - when `from` is zero, `amount` tokens will be minted for `to`.
1995      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1996      * - `from` and `to` are never both zero.
1997      *
1998      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1999      */
2000     function _beforeTokenTransfer(
2001         address from,
2002         address to,
2003         uint256 amount
2004     ) internal virtual {}
2005 
2006     /**
2007      * @dev Hook that is called after any transfer of tokens. This includes
2008      * minting and burning.
2009      *
2010      * Calling conditions:
2011      *
2012      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2013      * has been transferred to `to`.
2014      * - when `from` is zero, `amount` tokens have been minted for `to`.
2015      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2016      * - `from` and `to` are never both zero.
2017      *
2018      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2019      */
2020     function _afterTokenTransfer(
2021         address from,
2022         address to,
2023         uint256 amount
2024     ) internal virtual {}
2025 }
2026 
2027 // File: TokenLock.sol
2028 
2029 
2030 
2031 pragma solidity ^0.8.0;
2032 
2033 
2034 
2035 abstract contract TokenLock is ERC20, Ownable {
2036     /**
2037      * @dev See {ERC20-_beforeTokenTransfer}.
2038      *
2039      */
2040 
2041     mapping (address => bool) public _tokenLock;
2042 
2043     function isTokenLock(address from, address to) public view returns (bool lock) {
2044         lock = false;
2045 
2046         if(_tokenLock[from] == true || _tokenLock[to] == true) {
2047              lock = true;
2048         }
2049     }
2050 
2051     function addTokenLock(address _who) onlyOwner public {
2052         require(_tokenLock[_who] == false);
2053         _tokenLock[_who] = true;
2054     }
2055 
2056     function removeTokenLock(address _who) onlyOwner public {
2057         require(_tokenLock[_who] == true);
2058         _tokenLock[_who] = false;
2059     }
2060 
2061     function _beforeTokenTransfer(
2062         address from,
2063         address to,
2064         uint256 amount
2065     ) internal virtual override {
2066         require(isTokenLock(from, to) == false, "TokenLock: invalid token transfer");
2067 
2068         super._beforeTokenTransfer(from, to, amount);
2069     }
2070 }
2071 
2072 
2073 
2074 // File: ERC20Burnable.sol
2075 
2076 
2077 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
2078 
2079 pragma solidity ^0.8.0;
2080 
2081 
2082 
2083 /**
2084  * @dev Extension of {ERC20} that allows token holders to destroy both their own
2085  * tokens and those that they have an allowance for, in a way that can be
2086  * recognized off-chain (via event analysis).
2087  */
2088 abstract contract ERC20Burnable is Context, ERC20 {
2089     /**
2090      * @dev Destroys `amount` tokens from the caller.
2091      *
2092      * See {ERC20-_burn}.
2093      */
2094     function burn(address account, uint256 amount) public virtual {
2095         _burn(account, amount);
2096     }
2097 }
2098 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC20/extensions/ERC20Pausable.sol
2099 
2100 
2101 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Pausable.sol)
2102 
2103 pragma solidity ^0.8.0;
2104 
2105 
2106 
2107 /**
2108  * @dev ERC20 token with pausable token transfers, minting and burning.
2109  *
2110  * Useful for scenarios such as preventing trades until the end of an evaluation
2111  * period, or having an emergency switch for freezing all token transfers in the
2112  * event of a large bug.
2113  */
2114 abstract contract ERC20Pausable is ERC20, Pausable {
2115     /**
2116      * @dev See {ERC20-_beforeTokenTransfer}.
2117      *
2118      * Requirements:
2119      *
2120      * - the contract must not be paused.
2121      */
2122     function _beforeTokenTransfer(
2123         address from,
2124         address to,
2125         uint256 amount
2126     ) internal virtual override {
2127         super._beforeTokenTransfer(from, to, amount);
2128 
2129         require(!paused(), "ERC20Pausable: token transfer while paused");
2130     }
2131 }
2132 
2133 // File: FOGNetToken.sol
2134 
2135 
2136 pragma solidity >=0.7.0 <0.9.0;
2137 
2138 
2139 
2140 
2141 
2142 
2143 contract FOGNet is Context, AccessControlEnumerable, ERC20Pausable, ERC20Burnable, TokenLock {
2144     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2145     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2146     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
2147     /**
2148      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2149      * account that deploys the contract.
2150      *
2151      * See {ERC20-constructor}.
2152      */
2153     constructor(
2154         string memory name,
2155         string memory symbol,
2156         uint256 initialSupply
2157     ) ERC20(name, symbol) {
2158         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2159 
2160         _setupRole(MINTER_ROLE, _msgSender());
2161         _setupRole(PAUSER_ROLE, _msgSender());
2162         _setupRole(ADMIN_ROLE, _msgSender());
2163 
2164         _mint(_msgSender(), initialSupply);
2165     }
2166 
2167     function burn(address account, uint256 amount)  public virtual override (ERC20Burnable) {
2168         require(hasRole(ADMIN_ROLE, _msgSender()), "FOGToken: must have admin role to burn");
2169         super.burn(account, amount);
2170     }
2171 
2172     function grantAdminRole(address account)  public virtual {
2173         require(hasRole(ADMIN_ROLE, _msgSender()), "FOGToken: must have admin role to grantAdminRole");
2174         _setupRole(ADMIN_ROLE, account);
2175     }
2176 
2177     /**
2178      * @dev Pauses all token transfers.
2179      *
2180      * See {ERC20Pausable} and {Pausable-_pause}.
2181      *
2182      * Requirements:
2183      *
2184      * - the caller must have the `PAUSER_ROLE`.
2185      */
2186     function pause() public virtual {
2187         require(hasRole(PAUSER_ROLE, _msgSender()), "FOGToken: must have pauser role to pause");
2188         _pause();
2189     }
2190 
2191     /**
2192      * @dev Unpauses all token transfers.
2193      *
2194      * See {ERC20Pausable} and {Pausable-_unpause}.
2195      *
2196      * Requirements:
2197      *
2198      * - the caller must have the `PAUSER_ROLE`.
2199      */
2200     function unpause() public virtual {
2201         require(hasRole(PAUSER_ROLE, _msgSender()), "FOGToken: must have pauser role to unpause");
2202         _unpause();
2203     }
2204 
2205 
2206     function _beforeTokenTransfer(
2207         address from,
2208         address to,
2209         uint256 amount
2210     ) internal virtual override(ERC20, ERC20Pausable, TokenLock ) {
2211 
2212         super._beforeTokenTransfer(from, to, amount);
2213     }
2214 
2215 }