1 // SPDX-License-Identifier: MIT
2 
3 //www.FreeYolk.com
4 //Love Eggs? Now you can have the Yolk with a Fork!
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Library for managing
10  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
11  * types.
12  *
13  * Sets have the following properties:
14  *
15  * - Elements are added, removed, and checked for existence in constant time
16  * (O(1)).
17  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
18  *
19  * ```
20  * contract Example {
21  *     // Add the library methods
22  *     using EnumerableSet for EnumerableSet.AddressSet;
23  *
24  *     // Declare a set state variable
25  *     EnumerableSet.AddressSet private mySet;
26  * }
27  * ```
28  *
29  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
30  * and `uint256` (`UintSet`) are supported.
31  *
32  * [WARNING]
33  * ====
34  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
35  * unusable.
36  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
37  *
38  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
39  * array of EnumerableSet.
40  * ====
41  */
42 library EnumerableSet {
43     // To implement this library for multiple types with as little code
44     // repetition as possible, we write it in terms of a generic Set type with
45     // bytes32 values.
46     // The Set implementation uses private functions, and user-facing
47     // implementations (such as AddressSet) are just wrappers around the
48     // underlying Set.
49     // This means that we can only create new EnumerableSets for types that fit
50     // in bytes32.
51 
52     struct Set {
53         // Storage of set values
54         bytes32[] _values;
55         // Position of the value in the `values` array, plus 1 because index 0
56         // means a value is not in the set.
57         mapping(bytes32 => uint256) _indexes;
58     }
59 
60     /**
61      * @dev Add a value to a set. O(1).
62      *
63      * Returns true if the value was added to the set, that is if it was not
64      * already present.
65      */
66     function _add(Set storage set, bytes32 value) private returns (bool) {
67         if (!_contains(set, value)) {
68             set._values.push(value);
69             // The value is stored at length-1, but we add 1 to all indexes
70             // and use 0 as a sentinel value
71             set._indexes[value] = set._values.length;
72             return true;
73         } else {
74             return false;
75         }
76     }
77 
78     /**
79      * @dev Removes a value from a set. O(1).
80      *
81      * Returns true if the value was removed from the set, that is if it was
82      * present.
83      */
84     function _remove(Set storage set, bytes32 value) private returns (bool) {
85         // We read and store the value's index to prevent multiple reads from the same storage slot
86         uint256 valueIndex = set._indexes[value];
87 
88         if (valueIndex != 0) {
89             // Equivalent to contains(set, value)
90             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
91             // the array, and then remove the last element (sometimes called as 'swap and pop').
92             // This modifies the order of the array, as noted in {at}.
93 
94             uint256 toDeleteIndex = valueIndex - 1;
95             uint256 lastIndex = set._values.length - 1;
96 
97             if (lastIndex != toDeleteIndex) {
98                 bytes32 lastValue = set._values[lastIndex];
99 
100                 // Move the last value to the index where the value to delete is
101                 set._values[toDeleteIndex] = lastValue;
102                 // Update the index for the moved value
103                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
104             }
105 
106             // Delete the slot where the moved value was stored
107             set._values.pop();
108 
109             // Delete the index for the deleted slot
110             delete set._indexes[value];
111 
112             return true;
113         } else {
114             return false;
115         }
116     }
117 
118     /**
119      * @dev Returns true if the value is in the set. O(1).
120      */
121     function _contains(Set storage set, bytes32 value)
122         private
123         view
124         returns (bool)
125     {
126         return set._indexes[value] != 0;
127     }
128 
129     /**
130      * @dev Returns the number of values on the set. O(1).
131      */
132     function _length(Set storage set) private view returns (uint256) {
133         return set._values.length;
134     }
135 
136     /**
137      * @dev Returns the value stored at position `index` in the set. O(1).
138      *
139      * Note that there are no guarantees on the ordering of values inside the
140      * array, and it may change when more values are added or removed.
141      *
142      * Requirements:
143      *
144      * - `index` must be strictly less than {length}.
145      */
146     function _at(Set storage set, uint256 index)
147         private
148         view
149         returns (bytes32)
150     {
151         return set._values[index];
152     }
153 
154     /**
155      * @dev Return the entire set in an array
156      *
157      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
158      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
159      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
160      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
161      */
162     function _values(Set storage set) private view returns (bytes32[] memory) {
163         return set._values;
164     }
165 
166     // Bytes32Set
167 
168     struct Bytes32Set {
169         Set _inner;
170     }
171 
172     /**
173      * @dev Add a value to a set. O(1).
174      *
175      * Returns true if the value was added to the set, that is if it was not
176      * already present.
177      */
178     function add(Bytes32Set storage set, bytes32 value)
179         internal
180         returns (bool)
181     {
182         return _add(set._inner, value);
183     }
184 
185     /**
186      * @dev Removes a value from a set. O(1).
187      *
188      * Returns true if the value was removed from the set, that is if it was
189      * present.
190      */
191     function remove(Bytes32Set storage set, bytes32 value)
192         internal
193         returns (bool)
194     {
195         return _remove(set._inner, value);
196     }
197 
198     /**
199      * @dev Returns true if the value is in the set. O(1).
200      */
201     function contains(Bytes32Set storage set, bytes32 value)
202         internal
203         view
204         returns (bool)
205     {
206         return _contains(set._inner, value);
207     }
208 
209     /**
210      * @dev Returns the number of values in the set. O(1).
211      */
212     function length(Bytes32Set storage set) internal view returns (uint256) {
213         return _length(set._inner);
214     }
215 
216     /**
217      * @dev Returns the value stored at position `index` in the set. O(1).
218      *
219      * Note that there are no guarantees on the ordering of values inside the
220      * array, and it may change when more values are added or removed.
221      *
222      * Requirements:
223      *
224      * - `index` must be strictly less than {length}.
225      */
226     function at(Bytes32Set storage set, uint256 index)
227         internal
228         view
229         returns (bytes32)
230     {
231         return _at(set._inner, index);
232     }
233 
234     /**
235      * @dev Return the entire set in an array
236      *
237      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
238      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
239      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
240      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
241      */
242     function values(Bytes32Set storage set)
243         internal
244         view
245         returns (bytes32[] memory)
246     {
247         bytes32[] memory store = _values(set._inner);
248         bytes32[] memory result;
249 
250         /// @solidity memory-safe-assembly
251         assembly {
252             result := store
253         }
254 
255         return result;
256     }
257 
258     // AddressSet
259 
260     struct AddressSet {
261         Set _inner;
262     }
263 
264     /**
265      * @dev Add a value to a set. O(1).
266      *
267      * Returns true if the value was added to the set, that is if it was not
268      * already present.
269      */
270     function add(AddressSet storage set, address value)
271         internal
272         returns (bool)
273     {
274         return _add(set._inner, bytes32(uint256(uint160(value))));
275     }
276 
277     /**
278      * @dev Removes a value from a set. O(1).
279      *
280      * Returns true if the value was removed from the set, that is if it was
281      * present.
282      */
283     function remove(AddressSet storage set, address value)
284         internal
285         returns (bool)
286     {
287         return _remove(set._inner, bytes32(uint256(uint160(value))));
288     }
289 
290     /**
291      * @dev Returns true if the value is in the set. O(1).
292      */
293     function contains(AddressSet storage set, address value)
294         internal
295         view
296         returns (bool)
297     {
298         return _contains(set._inner, bytes32(uint256(uint160(value))));
299     }
300 
301     /**
302      * @dev Returns the number of values in the set. O(1).
303      */
304     function length(AddressSet storage set) internal view returns (uint256) {
305         return _length(set._inner);
306     }
307 
308     /**
309      * @dev Returns the value stored at position `index` in the set. O(1).
310      *
311      * Note that there are no guarantees on the ordering of values inside the
312      * array, and it may change when more values are added or removed.
313      *
314      * Requirements:
315      *
316      * - `index` must be strictly less than {length}.
317      */
318     function at(AddressSet storage set, uint256 index)
319         internal
320         view
321         returns (address)
322     {
323         return address(uint160(uint256(_at(set._inner, index))));
324     }
325 
326     /**
327      * @dev Return the entire set in an array
328      *
329      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
330      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
331      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
332      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
333      */
334     function values(AddressSet storage set)
335         internal
336         view
337         returns (address[] memory)
338     {
339         bytes32[] memory store = _values(set._inner);
340         address[] memory result;
341 
342         /// @solidity memory-safe-assembly
343         assembly {
344             result := store
345         }
346 
347         return result;
348     }
349 
350     // UintSet
351 
352     struct UintSet {
353         Set _inner;
354     }
355 
356     /**
357      * @dev Add a value to a set. O(1).
358      *
359      * Returns true if the value was added to the set, that is if it was not
360      * already present.
361      */
362     function add(UintSet storage set, uint256 value) internal returns (bool) {
363         return _add(set._inner, bytes32(value));
364     }
365 
366     /**
367      * @dev Removes a value from a set. O(1).
368      *
369      * Returns true if the value was removed from the set, that is if it was
370      * present.
371      */
372     function remove(UintSet storage set, uint256 value)
373         internal
374         returns (bool)
375     {
376         return _remove(set._inner, bytes32(value));
377     }
378 
379     /**
380      * @dev Returns true if the value is in the set. O(1).
381      */
382     function contains(UintSet storage set, uint256 value)
383         internal
384         view
385         returns (bool)
386     {
387         return _contains(set._inner, bytes32(value));
388     }
389 
390     /**
391      * @dev Returns the number of values in the set. O(1).
392      */
393     function length(UintSet storage set) internal view returns (uint256) {
394         return _length(set._inner);
395     }
396 
397     /**
398      * @dev Returns the value stored at position `index` in the set. O(1).
399      *
400      * Note that there are no guarantees on the ordering of values inside the
401      * array, and it may change when more values are added or removed.
402      *
403      * Requirements:
404      *
405      * - `index` must be strictly less than {length}.
406      */
407     function at(UintSet storage set, uint256 index)
408         internal
409         view
410         returns (uint256)
411     {
412         return uint256(_at(set._inner, index));
413     }
414 
415     /**
416      * @dev Return the entire set in an array
417      *
418      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
419      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
420      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
421      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
422      */
423     function values(UintSet storage set)
424         internal
425         view
426         returns (uint256[] memory)
427     {
428         bytes32[] memory store = _values(set._inner);
429         uint256[] memory result;
430 
431         /// @solidity memory-safe-assembly
432         assembly {
433             result := store
434         }
435 
436         return result;
437     }
438 }
439 
440 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
441 
442 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev Interface of the ERC165 standard, as defined in the
448  * https://eips.ethereum.org/EIPS/eip-165[EIP].
449  *
450  * Implementers can declare support of contract interfaces, which can then be
451  * queried by others ({ERC165Checker}).
452  *
453  * For an implementation, see {ERC165}.
454  */
455 interface IERC165 {
456     /**
457      * @dev Returns true if this contract implements the interface defined by
458      * `interfaceId`. See the corresponding
459      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
460      * to learn more about how these ids are created.
461      *
462      * This function call must use less than 30 000 gas.
463      */
464     function supportsInterface(bytes4 interfaceId) external view returns (bool);
465 }
466 
467 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
468 
469 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @dev Implementation of the {IERC165} interface.
475  *
476  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
477  * for the additional interface id that will be supported. For example:
478  *
479  * ```solidity
480  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
482  * }
483  * ```
484  *
485  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
486  */
487 abstract contract ERC165 is IERC165 {
488     /**
489      * @dev See {IERC165-supportsInterface}.
490      */
491     function supportsInterface(bytes4 interfaceId)
492         public
493         view
494         virtual
495         override
496         returns (bool)
497     {
498         return interfaceId == type(IERC165).interfaceId;
499     }
500 }
501 
502 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
503 
504 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Standard math utilities missing in the Solidity language.
510  */
511 library Math {
512     enum Rounding {
513         Down, // Toward negative infinity
514         Up, // Toward infinity
515         Zero // Toward zero
516     }
517 
518     /**
519      * @dev Returns the largest of two numbers.
520      */
521     function max(uint256 a, uint256 b) internal pure returns (uint256) {
522         return a > b ? a : b;
523     }
524 
525     /**
526      * @dev Returns the smallest of two numbers.
527      */
528     function min(uint256 a, uint256 b) internal pure returns (uint256) {
529         return a < b ? a : b;
530     }
531 
532     /**
533      * @dev Returns the average of two numbers. The result is rounded towards
534      * zero.
535      */
536     function average(uint256 a, uint256 b) internal pure returns (uint256) {
537         // (a + b) / 2 can overflow.
538         return (a & b) + (a ^ b) / 2;
539     }
540 
541     /**
542      * @dev Returns the ceiling of the division of two numbers.
543      *
544      * This differs from standard division with `/` in that it rounds up instead
545      * of rounding down.
546      */
547     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
548         // (a + b - 1) / b can overflow on addition, so we distribute.
549         return a == 0 ? 0 : (a - 1) / b + 1;
550     }
551 
552     /**
553      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
554      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
555      * with further edits by Uniswap Labs also under MIT license.
556      */
557     function mulDiv(
558         uint256 x,
559         uint256 y,
560         uint256 denominator
561     ) internal pure returns (uint256 result) {
562         unchecked {
563             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
564             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
565             // variables such that product = prod1 * 2^256 + prod0.
566             uint256 prod0; // Least significant 256 bits of the product
567             uint256 prod1; // Most significant 256 bits of the product
568             assembly {
569                 let mm := mulmod(x, y, not(0))
570                 prod0 := mul(x, y)
571                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
572             }
573 
574             // Handle non-overflow cases, 256 by 256 division.
575             if (prod1 == 0) {
576                 return prod0 / denominator;
577             }
578 
579             // Make sure the result is less than 2^256. Also prevents denominator == 0.
580             require(denominator > prod1);
581 
582             ///////////////////////////////////////////////
583             // 512 by 256 division.
584             ///////////////////////////////////////////////
585 
586             // Make division exact by subtracting the remainder from [prod1 prod0].
587             uint256 remainder;
588             assembly {
589                 // Compute remainder using mulmod.
590                 remainder := mulmod(x, y, denominator)
591 
592                 // Subtract 256 bit number from 512 bit number.
593                 prod1 := sub(prod1, gt(remainder, prod0))
594                 prod0 := sub(prod0, remainder)
595             }
596 
597             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
598             // See https://cs.stackexchange.com/q/138556/92363.
599 
600             // Does not overflow because the denominator cannot be zero at this stage in the function.
601             uint256 twos = denominator & (~denominator + 1);
602             assembly {
603                 // Divide denominator by twos.
604                 denominator := div(denominator, twos)
605 
606                 // Divide [prod1 prod0] by twos.
607                 prod0 := div(prod0, twos)
608 
609                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
610                 twos := add(div(sub(0, twos), twos), 1)
611             }
612 
613             // Shift in bits from prod1 into prod0.
614             prod0 |= prod1 * twos;
615 
616             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
617             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
618             // four bits. That is, denominator * inv = 1 mod 2^4.
619             uint256 inverse = (3 * denominator) ^ 2;
620 
621             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
622             // in modular arithmetic, doubling the correct bits in each step.
623             inverse *= 2 - denominator * inverse; // inverse mod 2^8
624             inverse *= 2 - denominator * inverse; // inverse mod 2^16
625             inverse *= 2 - denominator * inverse; // inverse mod 2^32
626             inverse *= 2 - denominator * inverse; // inverse mod 2^64
627             inverse *= 2 - denominator * inverse; // inverse mod 2^128
628             inverse *= 2 - denominator * inverse; // inverse mod 2^256
629 
630             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
631             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
632             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
633             // is no longer required.
634             result = prod0 * inverse;
635             return result;
636         }
637     }
638 
639     /**
640      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
641      */
642     function mulDiv(
643         uint256 x,
644         uint256 y,
645         uint256 denominator,
646         Rounding rounding
647     ) internal pure returns (uint256) {
648         uint256 result = mulDiv(x, y, denominator);
649         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
650             result += 1;
651         }
652         return result;
653     }
654 
655     /**
656      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
657      *
658      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
659      */
660     function sqrt(uint256 a) internal pure returns (uint256) {
661         if (a == 0) {
662             return 0;
663         }
664 
665         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
666         //
667         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
668         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
669         //
670         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
671         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
672         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
673         //
674         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
675         uint256 result = 1 << (log2(a) >> 1);
676 
677         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
678         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
679         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
680         // into the expected uint128 result.
681         unchecked {
682             result = (result + a / result) >> 1;
683             result = (result + a / result) >> 1;
684             result = (result + a / result) >> 1;
685             result = (result + a / result) >> 1;
686             result = (result + a / result) >> 1;
687             result = (result + a / result) >> 1;
688             result = (result + a / result) >> 1;
689             return min(result, a / result);
690         }
691     }
692 
693     /**
694      * @notice Calculates sqrt(a), following the selected rounding direction.
695      */
696     function sqrt(uint256 a, Rounding rounding)
697         internal
698         pure
699         returns (uint256)
700     {
701         unchecked {
702             uint256 result = sqrt(a);
703             return
704                 result +
705                 (rounding == Rounding.Up && result * result < a ? 1 : 0);
706         }
707     }
708 
709     /**
710      * @dev Return the log in base 2, rounded down, of a positive value.
711      * Returns 0 if given 0.
712      */
713     function log2(uint256 value) internal pure returns (uint256) {
714         uint256 result = 0;
715         unchecked {
716             if (value >> 128 > 0) {
717                 value >>= 128;
718                 result += 128;
719             }
720             if (value >> 64 > 0) {
721                 value >>= 64;
722                 result += 64;
723             }
724             if (value >> 32 > 0) {
725                 value >>= 32;
726                 result += 32;
727             }
728             if (value >> 16 > 0) {
729                 value >>= 16;
730                 result += 16;
731             }
732             if (value >> 8 > 0) {
733                 value >>= 8;
734                 result += 8;
735             }
736             if (value >> 4 > 0) {
737                 value >>= 4;
738                 result += 4;
739             }
740             if (value >> 2 > 0) {
741                 value >>= 2;
742                 result += 2;
743             }
744             if (value >> 1 > 0) {
745                 result += 1;
746             }
747         }
748         return result;
749     }
750 
751     /**
752      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
753      * Returns 0 if given 0.
754      */
755     function log2(uint256 value, Rounding rounding)
756         internal
757         pure
758         returns (uint256)
759     {
760         unchecked {
761             uint256 result = log2(value);
762             return
763                 result +
764                 (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
765         }
766     }
767 
768     /**
769      * @dev Return the log in base 10, rounded down, of a positive value.
770      * Returns 0 if given 0.
771      */
772     function log10(uint256 value) internal pure returns (uint256) {
773         uint256 result = 0;
774         unchecked {
775             if (value >= 10**64) {
776                 value /= 10**64;
777                 result += 64;
778             }
779             if (value >= 10**32) {
780                 value /= 10**32;
781                 result += 32;
782             }
783             if (value >= 10**16) {
784                 value /= 10**16;
785                 result += 16;
786             }
787             if (value >= 10**8) {
788                 value /= 10**8;
789                 result += 8;
790             }
791             if (value >= 10**4) {
792                 value /= 10**4;
793                 result += 4;
794             }
795             if (value >= 10**2) {
796                 value /= 10**2;
797                 result += 2;
798             }
799             if (value >= 10**1) {
800                 result += 1;
801             }
802         }
803         return result;
804     }
805 
806     /**
807      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
808      * Returns 0 if given 0.
809      */
810     function log10(uint256 value, Rounding rounding)
811         internal
812         pure
813         returns (uint256)
814     {
815         unchecked {
816             uint256 result = log10(value);
817             return
818                 result +
819                 (rounding == Rounding.Up && 10**result < value ? 1 : 0);
820         }
821     }
822 
823     /**
824      * @dev Return the log in base 256, rounded down, of a positive value.
825      * Returns 0 if given 0.
826      *
827      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
828      */
829     function log256(uint256 value) internal pure returns (uint256) {
830         uint256 result = 0;
831         unchecked {
832             if (value >> 128 > 0) {
833                 value >>= 128;
834                 result += 16;
835             }
836             if (value >> 64 > 0) {
837                 value >>= 64;
838                 result += 8;
839             }
840             if (value >> 32 > 0) {
841                 value >>= 32;
842                 result += 4;
843             }
844             if (value >> 16 > 0) {
845                 value >>= 16;
846                 result += 2;
847             }
848             if (value >> 8 > 0) {
849                 result += 1;
850             }
851         }
852         return result;
853     }
854 
855     /**
856      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
857      * Returns 0 if given 0.
858      */
859     function log256(uint256 value, Rounding rounding)
860         internal
861         pure
862         returns (uint256)
863     {
864         unchecked {
865             uint256 result = log256(value);
866             return
867                 result +
868                 (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
869         }
870     }
871 }
872 
873 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
874 
875 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
876 
877 pragma solidity ^0.8.0;
878 
879 /**
880  * @dev String operations.
881  */
882 library Strings {
883     bytes16 private constant _SYMBOLS = "0123456789abcdef";
884     uint8 private constant _ADDRESS_LENGTH = 20;
885 
886     /**
887      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
888      */
889     function toString(uint256 value) internal pure returns (string memory) {
890         unchecked {
891             uint256 length = Math.log10(value) + 1;
892             string memory buffer = new string(length);
893             uint256 ptr;
894             /// @solidity memory-safe-assembly
895             assembly {
896                 ptr := add(buffer, add(32, length))
897             }
898             while (true) {
899                 ptr--;
900                 /// @solidity memory-safe-assembly
901                 assembly {
902                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
903                 }
904                 value /= 10;
905                 if (value == 0) break;
906             }
907             return buffer;
908         }
909     }
910 
911     /**
912      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
913      */
914     function toHexString(uint256 value) internal pure returns (string memory) {
915         unchecked {
916             return toHexString(value, Math.log256(value) + 1);
917         }
918     }
919 
920     /**
921      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
922      */
923     function toHexString(uint256 value, uint256 length)
924         internal
925         pure
926         returns (string memory)
927     {
928         bytes memory buffer = new bytes(2 * length + 2);
929         buffer[0] = "0";
930         buffer[1] = "x";
931         for (uint256 i = 2 * length + 1; i > 1; --i) {
932             buffer[i] = _SYMBOLS[value & 0xf];
933             value >>= 4;
934         }
935         require(value == 0, "Strings: hex length insufficient");
936         return string(buffer);
937     }
938 
939     /**
940      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
941      */
942     function toHexString(address addr) internal pure returns (string memory) {
943         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
944     }
945 }
946 
947 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/IAccessControl.sol
948 
949 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
950 
951 pragma solidity ^0.8.0;
952 
953 /**
954  * @dev External interface of AccessControl declared to support ERC165 detection.
955  */
956 interface IAccessControl {
957     /**
958      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
959      *
960      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
961      * {RoleAdminChanged} not being emitted signaling this.
962      *
963      * _Available since v3.1._
964      */
965     event RoleAdminChanged(
966         bytes32 indexed role,
967         bytes32 indexed previousAdminRole,
968         bytes32 indexed newAdminRole
969     );
970 
971     /**
972      * @dev Emitted when `account` is granted `role`.
973      *
974      * `sender` is the account that originated the contract call, an admin role
975      * bearer except when using {AccessControl-_setupRole}.
976      */
977     event RoleGranted(
978         bytes32 indexed role,
979         address indexed account,
980         address indexed sender
981     );
982 
983     /**
984      * @dev Emitted when `account` is revoked `role`.
985      *
986      * `sender` is the account that originated the contract call:
987      *   - if using `revokeRole`, it is the admin role bearer
988      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
989      */
990     event RoleRevoked(
991         bytes32 indexed role,
992         address indexed account,
993         address indexed sender
994     );
995 
996     /**
997      * @dev Returns `true` if `account` has been granted `role`.
998      */
999     function hasRole(bytes32 role, address account)
1000         external
1001         view
1002         returns (bool);
1003 
1004     /**
1005      * @dev Returns the admin role that controls `role`. See {grantRole} and
1006      * {revokeRole}.
1007      *
1008      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1009      */
1010     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1011 
1012     /**
1013      * @dev Grants `role` to `account`.
1014      *
1015      * If `account` had not been already granted `role`, emits a {RoleGranted}
1016      * event.
1017      *
1018      * Requirements:
1019      *
1020      * - the caller must have ``role``'s admin role.
1021      */
1022     function grantRole(bytes32 role, address account) external;
1023 
1024     /**
1025      * @dev Revokes `role` from `account`.
1026      *
1027      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1028      *
1029      * Requirements:
1030      *
1031      * - the caller must have ``role``'s admin role.
1032      */
1033     function revokeRole(bytes32 role, address account) external;
1034 
1035     /**
1036      * @dev Revokes `role` from the calling account.
1037      *
1038      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1039      * purpose is to provide a mechanism for accounts to lose their privileges
1040      * if they are compromised (such as when a trusted device is misplaced).
1041      *
1042      * If the calling account had been granted `role`, emits a {RoleRevoked}
1043      * event.
1044      *
1045      * Requirements:
1046      *
1047      * - the caller must be `account`.
1048      */
1049     function renounceRole(bytes32 role, address account) external;
1050 }
1051 
1052 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/IAccessControlEnumerable.sol
1053 
1054 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
1055 
1056 pragma solidity ^0.8.0;
1057 
1058 /**
1059  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1060  */
1061 interface IAccessControlEnumerable is IAccessControl {
1062     /**
1063      * @dev Returns one of the accounts that have `role`. `index` must be a
1064      * value between 0 and {getRoleMemberCount}, non-inclusive.
1065      *
1066      * Role bearers are not sorted in any particular way, and their ordering may
1067      * change at any point.
1068      *
1069      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1070      * you perform all queries on the same block. See the following
1071      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1072      * for more information.
1073      */
1074     function getRoleMember(bytes32 role, uint256 index)
1075         external
1076         view
1077         returns (address);
1078 
1079     /**
1080      * @dev Returns the number of accounts that have `role`. Can be used
1081      * together with {getRoleMember} to enumerate all bearers of a role.
1082      */
1083     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1084 }
1085 
1086 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1087 
1088 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1089 
1090 pragma solidity ^0.8.0;
1091 
1092 /**
1093  * @dev Provides information about the current execution context, including the
1094  * sender of the transaction and its data. While these are generally available
1095  * via msg.sender and msg.data, they should not be accessed in such a direct
1096  * manner, since when dealing with meta-transactions the account sending and
1097  * paying for execution may not be the actual sender (as far as an application
1098  * is concerned).
1099  *
1100  * This contract is only required for intermediate, library-like contracts.
1101  */
1102 abstract contract Context {
1103     function _msgSender() internal view virtual returns (address) {
1104         return msg.sender;
1105     }
1106 
1107     function _msgData() internal view virtual returns (bytes calldata) {
1108         return msg.data;
1109     }
1110 }
1111 
1112 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol
1113 
1114 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1115 
1116 pragma solidity ^0.8.0;
1117 
1118 /**
1119  * @dev Contract module that allows children to implement role-based access
1120  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1121  * members except through off-chain means by accessing the contract event logs. Some
1122  * applications may benefit from on-chain enumerability, for those cases see
1123  * {AccessControlEnumerable}.
1124  *
1125  * Roles are referred to by their `bytes32` identifier. These should be exposed
1126  * in the external API and be unique. The best way to achieve this is by
1127  * using `public constant` hash digests:
1128  *
1129  * ```
1130  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1131  * ```
1132  *
1133  * Roles can be used to represent a set of permissions. To restrict access to a
1134  * function call, use {hasRole}:
1135  *
1136  * ```
1137  * function foo() public {
1138  *     require(hasRole(MY_ROLE, msg.sender));
1139  *     ...
1140  * }
1141  * ```
1142  *
1143  * Roles can be granted and revoked dynamically via the {grantRole} and
1144  * {revokeRole} functions. Each role has an associated admin role, and only
1145  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1146  *
1147  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1148  * that only accounts with this role will be able to grant or revoke other
1149  * roles. More complex role relationships can be created by using
1150  * {_setRoleAdmin}.
1151  *
1152  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1153  * grant and revoke this role. Extra precautions should be taken to secure
1154  * accounts that have been granted it.
1155  */
1156 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1157     struct RoleData {
1158         mapping(address => bool) members;
1159         bytes32 adminRole;
1160     }
1161 
1162     mapping(bytes32 => RoleData) private _roles;
1163 
1164     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1165 
1166     /**
1167      * @dev Modifier that checks that an account has a specific role. Reverts
1168      * with a standardized message including the required role.
1169      *
1170      * The format of the revert reason is given by the following regular expression:
1171      *
1172      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1173      *
1174      * _Available since v4.1._
1175      */
1176     modifier onlyRole(bytes32 role) {
1177         _checkRole(role);
1178         _;
1179     }
1180 
1181     /**
1182      * @dev See {IERC165-supportsInterface}.
1183      */
1184     function supportsInterface(bytes4 interfaceId)
1185         public
1186         view
1187         virtual
1188         override
1189         returns (bool)
1190     {
1191         return
1192             interfaceId == type(IAccessControl).interfaceId ||
1193             super.supportsInterface(interfaceId);
1194     }
1195 
1196     /**
1197      * @dev Returns `true` if `account` has been granted `role`.
1198      */
1199     function hasRole(bytes32 role, address account)
1200         public
1201         view
1202         virtual
1203         override
1204         returns (bool)
1205     {
1206         return _roles[role].members[account];
1207     }
1208 
1209     /**
1210      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1211      * Overriding this function changes the behavior of the {onlyRole} modifier.
1212      *
1213      * Format of the revert message is described in {_checkRole}.
1214      *
1215      * _Available since v4.6._
1216      */
1217     function _checkRole(bytes32 role) internal view virtual {
1218         _checkRole(role, _msgSender());
1219     }
1220 
1221     /**
1222      * @dev Revert with a standard message if `account` is missing `role`.
1223      *
1224      * The format of the revert reason is given by the following regular expression:
1225      *
1226      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1227      */
1228     function _checkRole(bytes32 role, address account) internal view virtual {
1229         if (!hasRole(role, account)) {
1230             revert(
1231                 string(
1232                     abi.encodePacked(
1233                         "AccessControl: account ",
1234                         Strings.toHexString(account),
1235                         " is missing role ",
1236                         Strings.toHexString(uint256(role), 32)
1237                     )
1238                 )
1239             );
1240         }
1241     }
1242 
1243     /**
1244      * @dev Returns the admin role that controls `role`. See {grantRole} and
1245      * {revokeRole}.
1246      *
1247      * To change a role's admin, use {_setRoleAdmin}.
1248      */
1249     function getRoleAdmin(bytes32 role)
1250         public
1251         view
1252         virtual
1253         override
1254         returns (bytes32)
1255     {
1256         return _roles[role].adminRole;
1257     }
1258 
1259     /**
1260      * @dev Grants `role` to `account`.
1261      *
1262      * If `account` had not been already granted `role`, emits a {RoleGranted}
1263      * event.
1264      *
1265      * Requirements:
1266      *
1267      * - the caller must have ``role``'s admin role.
1268      *
1269      * May emit a {RoleGranted} event.
1270      */
1271     function grantRole(bytes32 role, address account)
1272         public
1273         virtual
1274         override
1275         onlyRole(getRoleAdmin(role))
1276     {
1277         _grantRole(role, account);
1278     }
1279 
1280     /**
1281      * @dev Revokes `role` from `account`.
1282      *
1283      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1284      *
1285      * Requirements:
1286      *
1287      * - the caller must have ``role``'s admin role.
1288      *
1289      * May emit a {RoleRevoked} event.
1290      */
1291     function revokeRole(bytes32 role, address account)
1292         public
1293         virtual
1294         override
1295         onlyRole(getRoleAdmin(role))
1296     {
1297         _revokeRole(role, account);
1298     }
1299 
1300     /**
1301      * @dev Revokes `role` from the calling account.
1302      *
1303      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1304      * purpose is to provide a mechanism for accounts to lose their privileges
1305      * if they are compromised (such as when a trusted device is misplaced).
1306      *
1307      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1308      * event.
1309      *
1310      * Requirements:
1311      *
1312      * - the caller must be `account`.
1313      *
1314      * May emit a {RoleRevoked} event.
1315      */
1316     function renounceRole(bytes32 role, address account)
1317         public
1318         virtual
1319         override
1320     {
1321         require(
1322             account == _msgSender(),
1323             "AccessControl: can only renounce roles for self"
1324         );
1325 
1326         _revokeRole(role, account);
1327     }
1328 
1329     /**
1330      * @dev Grants `role` to `account`.
1331      *
1332      * If `account` had not been already granted `role`, emits a {RoleGranted}
1333      * event. Note that unlike {grantRole}, this function doesn't perform any
1334      * checks on the calling account.
1335      *
1336      * May emit a {RoleGranted} event.
1337      *
1338      * [WARNING]
1339      * ====
1340      * This function should only be called from the constructor when setting
1341      * up the initial roles for the system.
1342      *
1343      * Using this function in any other way is effectively circumventing the admin
1344      * system imposed by {AccessControl}.
1345      * ====
1346      *
1347      * NOTE: This function is deprecated in favor of {_grantRole}.
1348      */
1349     function _setupRole(bytes32 role, address account) internal virtual {
1350         _grantRole(role, account);
1351     }
1352 
1353     /**
1354      * @dev Sets `adminRole` as ``role``'s admin role.
1355      *
1356      * Emits a {RoleAdminChanged} event.
1357      */
1358     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1359         bytes32 previousAdminRole = getRoleAdmin(role);
1360         _roles[role].adminRole = adminRole;
1361         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1362     }
1363 
1364     /**
1365      * @dev Grants `role` to `account`.
1366      *
1367      * Internal function without access restriction.
1368      *
1369      * May emit a {RoleGranted} event.
1370      */
1371     function _grantRole(bytes32 role, address account) internal virtual {
1372         if (!hasRole(role, account)) {
1373             _roles[role].members[account] = true;
1374             emit RoleGranted(role, account, _msgSender());
1375         }
1376     }
1377 
1378     /**
1379      * @dev Revokes `role` from `account`.
1380      *
1381      * Internal function without access restriction.
1382      *
1383      * May emit a {RoleRevoked} event.
1384      */
1385     function _revokeRole(bytes32 role, address account) internal virtual {
1386         if (hasRole(role, account)) {
1387             _roles[role].members[account] = false;
1388             emit RoleRevoked(role, account, _msgSender());
1389         }
1390     }
1391 }
1392 
1393 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControlEnumerable.sol
1394 
1395 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1396 
1397 pragma solidity ^0.8.0;
1398 
1399 /**
1400  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1401  */
1402 abstract contract AccessControlEnumerable is
1403     IAccessControlEnumerable,
1404     AccessControl
1405 {
1406     using EnumerableSet for EnumerableSet.AddressSet;
1407 
1408     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1409 
1410     /**
1411      * @dev See {IERC165-supportsInterface}.
1412      */
1413     function supportsInterface(bytes4 interfaceId)
1414         public
1415         view
1416         virtual
1417         override
1418         returns (bool)
1419     {
1420         return
1421             interfaceId == type(IAccessControlEnumerable).interfaceId ||
1422             super.supportsInterface(interfaceId);
1423     }
1424 
1425     /**
1426      * @dev Returns one of the accounts that have `role`. `index` must be a
1427      * value between 0 and {getRoleMemberCount}, non-inclusive.
1428      *
1429      * Role bearers are not sorted in any particular way, and their ordering may
1430      * change at any point.
1431      *
1432      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1433      * you perform all queries on the same block. See the following
1434      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1435      * for more information.
1436      */
1437     function getRoleMember(bytes32 role, uint256 index)
1438         public
1439         view
1440         virtual
1441         override
1442         returns (address)
1443     {
1444         return _roleMembers[role].at(index);
1445     }
1446 
1447     /**
1448      * @dev Returns the number of accounts that have `role`. Can be used
1449      * together with {getRoleMember} to enumerate all bearers of a role.
1450      */
1451     function getRoleMemberCount(bytes32 role)
1452         public
1453         view
1454         virtual
1455         override
1456         returns (uint256)
1457     {
1458         return _roleMembers[role].length();
1459     }
1460 
1461     /**
1462      * @dev Overload {_grantRole} to track enumerable memberships
1463      */
1464     function _grantRole(bytes32 role, address account)
1465         internal
1466         virtual
1467         override
1468     {
1469         super._grantRole(role, account);
1470         _roleMembers[role].add(account);
1471     }
1472 
1473     /**
1474      * @dev Overload {_revokeRole} to track enumerable memberships
1475      */
1476     function _revokeRole(bytes32 role, address account)
1477         internal
1478         virtual
1479         override
1480     {
1481         super._revokeRole(role, account);
1482         _roleMembers[role].remove(account);
1483     }
1484 }
1485 
1486 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1487 
1488 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1489 
1490 pragma solidity ^0.8.0;
1491 
1492 /**
1493  * @dev Contract module which provides a basic access control mechanism, where
1494  * there is an account (an owner) that can be granted exclusive access to
1495  * specific functions.
1496  *
1497  * By default, the owner account will be the one that deploys the contract. This
1498  * can later be changed with {transferOwnership}.
1499  *
1500  * This module is used through inheritance. It will make available the modifier
1501  * `onlyOwner`, which can be applied to your functions to restrict their use to
1502  * the owner.
1503  */
1504 abstract contract Ownable is Context {
1505     address private _owner;
1506 
1507     event OwnershipTransferred(
1508         address indexed previousOwner,
1509         address indexed newOwner
1510     );
1511 
1512     /**
1513      * @dev Initializes the contract setting the deployer as the initial owner.
1514      */
1515     constructor() {
1516         _transferOwnership(_msgSender());
1517     }
1518 
1519     /**
1520      * @dev Throws if called by any account other than the owner.
1521      */
1522     modifier onlyOwner() {
1523         _checkOwner();
1524         _;
1525     }
1526 
1527     /**
1528      * @dev Returns the address of the current owner.
1529      */
1530     function owner() public view virtual returns (address) {
1531         return _owner;
1532     }
1533 
1534     /**
1535      * @dev Throws if the sender is not the owner.
1536      */
1537     function _checkOwner() internal view virtual {
1538         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1539     }
1540 
1541     /**
1542      * @dev Leaves the contract without owner. It will not be possible to call
1543      * `onlyOwner` functions anymore. Can only be called by the current owner.
1544      *
1545      * NOTE: Renouncing ownership will leave the contract without an owner,
1546      * thereby removing any functionality that is only available to the owner.
1547      */
1548     function renounceOwnership() public virtual onlyOwner {
1549         _transferOwnership(address(0));
1550     }
1551 
1552     /**
1553      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1554      * Can only be called by the current owner.
1555      */
1556     function transferOwnership(address newOwner) public virtual onlyOwner {
1557         require(
1558             newOwner != address(0),
1559             "Ownable: new owner is the zero address"
1560         );
1561         _transferOwnership(newOwner);
1562     }
1563 
1564     /**
1565      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1566      * Internal function without access restriction.
1567      */
1568     function _transferOwnership(address newOwner) internal virtual {
1569         address oldOwner = _owner;
1570         _owner = newOwner;
1571         emit OwnershipTransferred(oldOwner, newOwner);
1572     }
1573 }
1574 
1575 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1576 
1577 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1578 
1579 pragma solidity ^0.8.1;
1580 
1581 /**
1582  * @dev Collection of functions related to the address type
1583  */
1584 library Address {
1585     /**
1586      * @dev Returns true if `account` is a contract.
1587      *
1588      * [IMPORTANT]
1589      * ====
1590      * It is unsafe to assume that an address for which this function returns
1591      * false is an externally-owned account (EOA) and not a contract.
1592      *
1593      * Among others, `isContract` will return false for the following
1594      * types of addresses:
1595      *
1596      *  - an externally-owned account
1597      *  - a contract in construction
1598      *  - an address where a contract will be created
1599      *  - an address where a contract lived, but was destroyed
1600      * ====
1601      *
1602      * [IMPORTANT]
1603      * ====
1604      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1605      *
1606      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1607      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1608      * constructor.
1609      * ====
1610      */
1611     function isContract(address account) internal view returns (bool) {
1612         // This method relies on extcodesize/address.code.length, which returns 0
1613         // for contracts in construction, since the code is only stored at the end
1614         // of the constructor execution.
1615 
1616         return account.code.length > 0;
1617     }
1618 
1619     /**
1620      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1621      * `recipient`, forwarding all available gas and reverting on errors.
1622      *
1623      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1624      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1625      * imposed by `transfer`, making them unable to receive funds via
1626      * `transfer`. {sendValue} removes this limitation.
1627      *
1628      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1629      *
1630      * IMPORTANT: because control is transferred to `recipient`, care must be
1631      * taken to not create reentrancy vulnerabilities. Consider using
1632      * {ReentrancyGuard} or the
1633      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1634      */
1635     function sendValue(address payable recipient, uint256 amount) internal {
1636         require(
1637             address(this).balance >= amount,
1638             "Address: insufficient balance"
1639         );
1640 
1641         (bool success, ) = recipient.call{value: amount}("");
1642         require(
1643             success,
1644             "Address: unable to send value, recipient may have reverted"
1645         );
1646     }
1647 
1648     /**
1649      * @dev Performs a Solidity function call using a low level `call`. A
1650      * plain `call` is an unsafe replacement for a function call: use this
1651      * function instead.
1652      *
1653      * If `target` reverts with a revert reason, it is bubbled up by this
1654      * function (like regular Solidity function calls).
1655      *
1656      * Returns the raw returned data. To convert to the expected return value,
1657      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1658      *
1659      * Requirements:
1660      *
1661      * - `target` must be a contract.
1662      * - calling `target` with `data` must not revert.
1663      *
1664      * _Available since v3.1._
1665      */
1666     function functionCall(address target, bytes memory data)
1667         internal
1668         returns (bytes memory)
1669     {
1670         return
1671             functionCallWithValue(
1672                 target,
1673                 data,
1674                 0,
1675                 "Address: low-level call failed"
1676             );
1677     }
1678 
1679     /**
1680      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1681      * `errorMessage` as a fallback revert reason when `target` reverts.
1682      *
1683      * _Available since v3.1._
1684      */
1685     function functionCall(
1686         address target,
1687         bytes memory data,
1688         string memory errorMessage
1689     ) internal returns (bytes memory) {
1690         return functionCallWithValue(target, data, 0, errorMessage);
1691     }
1692 
1693     /**
1694      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1695      * but also transferring `value` wei to `target`.
1696      *
1697      * Requirements:
1698      *
1699      * - the calling contract must have an ETH balance of at least `value`.
1700      * - the called Solidity function must be `payable`.
1701      *
1702      * _Available since v3.1._
1703      */
1704     function functionCallWithValue(
1705         address target,
1706         bytes memory data,
1707         uint256 value
1708     ) internal returns (bytes memory) {
1709         return
1710             functionCallWithValue(
1711                 target,
1712                 data,
1713                 value,
1714                 "Address: low-level call with value failed"
1715             );
1716     }
1717 
1718     /**
1719      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1720      * with `errorMessage` as a fallback revert reason when `target` reverts.
1721      *
1722      * _Available since v3.1._
1723      */
1724     function functionCallWithValue(
1725         address target,
1726         bytes memory data,
1727         uint256 value,
1728         string memory errorMessage
1729     ) internal returns (bytes memory) {
1730         require(
1731             address(this).balance >= value,
1732             "Address: insufficient balance for call"
1733         );
1734         (bool success, bytes memory returndata) = target.call{value: value}(
1735             data
1736         );
1737         return
1738             verifyCallResultFromTarget(
1739                 target,
1740                 success,
1741                 returndata,
1742                 errorMessage
1743             );
1744     }
1745 
1746     /**
1747      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1748      * but performing a static call.
1749      *
1750      * _Available since v3.3._
1751      */
1752     function functionStaticCall(address target, bytes memory data)
1753         internal
1754         view
1755         returns (bytes memory)
1756     {
1757         return
1758             functionStaticCall(
1759                 target,
1760                 data,
1761                 "Address: low-level static call failed"
1762             );
1763     }
1764 
1765     /**
1766      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1767      * but performing a static call.
1768      *
1769      * _Available since v3.3._
1770      */
1771     function functionStaticCall(
1772         address target,
1773         bytes memory data,
1774         string memory errorMessage
1775     ) internal view returns (bytes memory) {
1776         (bool success, bytes memory returndata) = target.staticcall(data);
1777         return
1778             verifyCallResultFromTarget(
1779                 target,
1780                 success,
1781                 returndata,
1782                 errorMessage
1783             );
1784     }
1785 
1786     /**
1787      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1788      * but performing a delegate call.
1789      *
1790      * _Available since v3.4._
1791      */
1792     function functionDelegateCall(address target, bytes memory data)
1793         internal
1794         returns (bytes memory)
1795     {
1796         return
1797             functionDelegateCall(
1798                 target,
1799                 data,
1800                 "Address: low-level delegate call failed"
1801             );
1802     }
1803 
1804     /**
1805      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1806      * but performing a delegate call.
1807      *
1808      * _Available since v3.4._
1809      */
1810     function functionDelegateCall(
1811         address target,
1812         bytes memory data,
1813         string memory errorMessage
1814     ) internal returns (bytes memory) {
1815         (bool success, bytes memory returndata) = target.delegatecall(data);
1816         return
1817             verifyCallResultFromTarget(
1818                 target,
1819                 success,
1820                 returndata,
1821                 errorMessage
1822             );
1823     }
1824 
1825     /**
1826      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1827      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1828      *
1829      * _Available since v4.8._
1830      */
1831     function verifyCallResultFromTarget(
1832         address target,
1833         bool success,
1834         bytes memory returndata,
1835         string memory errorMessage
1836     ) internal view returns (bytes memory) {
1837         if (success) {
1838             if (returndata.length == 0) {
1839                 // only check isContract if the call was successful and the return data is empty
1840                 // otherwise we already know that it was a contract
1841                 require(isContract(target), "Address: call to non-contract");
1842             }
1843             return returndata;
1844         } else {
1845             _revert(returndata, errorMessage);
1846         }
1847     }
1848 
1849     /**
1850      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1851      * revert reason or using the provided one.
1852      *
1853      * _Available since v4.3._
1854      */
1855     function verifyCallResult(
1856         bool success,
1857         bytes memory returndata,
1858         string memory errorMessage
1859     ) internal pure returns (bytes memory) {
1860         if (success) {
1861             return returndata;
1862         } else {
1863             _revert(returndata, errorMessage);
1864         }
1865     }
1866 
1867     function _revert(bytes memory returndata, string memory errorMessage)
1868         private
1869         pure
1870     {
1871         // Look for revert reason and bubble it up if present
1872         if (returndata.length > 0) {
1873             // The easiest way to bubble the revert reason is using memory via assembly
1874             /// @solidity memory-safe-assembly
1875             assembly {
1876                 let returndata_size := mload(returndata)
1877                 revert(add(32, returndata), returndata_size)
1878             }
1879         } else {
1880             revert(errorMessage);
1881         }
1882     }
1883 }
1884 
1885 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
1886 
1887 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1888 
1889 pragma solidity ^0.8.0;
1890 
1891 /**
1892  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1893  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1894  *
1895  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1896  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1897  * need to send a transaction, and thus is not required to hold Ether at all.
1898  */
1899 interface IERC20Permit {
1900     /**
1901      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1902      * given ``owner``'s signed approval.
1903      *
1904      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1905      * ordering also apply here.
1906      *
1907      * Emits an {Approval} event.
1908      *
1909      * Requirements:
1910      *
1911      * - `spender` cannot be the zero address.
1912      * - `deadline` must be a timestamp in the future.
1913      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1914      * over the EIP712-formatted function arguments.
1915      * - the signature must use ``owner``'s current nonce (see {nonces}).
1916      *
1917      * For more information on the signature format, see the
1918      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1919      * section].
1920      */
1921     function permit(
1922         address owner,
1923         address spender,
1924         uint256 value,
1925         uint256 deadline,
1926         uint8 v,
1927         bytes32 r,
1928         bytes32 s
1929     ) external;
1930 
1931     /**
1932      * @dev Returns the current nonce for `owner`. This value must be
1933      * included whenever a signature is generated for {permit}.
1934      *
1935      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1936      * prevents a signature from being used multiple times.
1937      */
1938     function nonces(address owner) external view returns (uint256);
1939 
1940     /**
1941      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1942      */
1943     // solhint-disable-next-line func-name-mixedcase
1944     function DOMAIN_SEPARATOR() external view returns (bytes32);
1945 }
1946 
1947 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
1948 
1949 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1950 
1951 pragma solidity ^0.8.0;
1952 
1953 /**
1954  * @dev Interface of the ERC20 standard as defined in the EIP.
1955  */
1956 interface IERC20 {
1957     /**
1958      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1959      * another (`to`).
1960      *
1961      * Note that `value` may be zero.
1962      */
1963     event Transfer(address indexed from, address indexed to, uint256 value);
1964 
1965     /**
1966      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1967      * a call to {approve}. `value` is the new allowance.
1968      */
1969     event Approval(
1970         address indexed owner,
1971         address indexed spender,
1972         uint256 value
1973     );
1974 
1975     /**
1976      * @dev Returns the amount of tokens in existence.
1977      */
1978     function totalSupply() external view returns (uint256);
1979 
1980     /**
1981      * @dev Returns the amount of tokens owned by `account`.
1982      */
1983     function balanceOf(address account) external view returns (uint256);
1984 
1985     /**
1986      * @dev Moves `amount` tokens from the caller's account to `to`.
1987      *
1988      * Returns a boolean value indicating whether the operation succeeded.
1989      *
1990      * Emits a {Transfer} event.
1991      */
1992     function transfer(address to, uint256 amount) external returns (bool);
1993 
1994     /**
1995      * @dev Returns the remaining number of tokens that `spender` will be
1996      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1997      * zero by default.
1998      *
1999      * This value changes when {approve} or {transferFrom} are called.
2000      */
2001     function allowance(address owner, address spender)
2002         external
2003         view
2004         returns (uint256);
2005 
2006     /**
2007      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2008      *
2009      * Returns a boolean value indicating whether the operation succeeded.
2010      *
2011      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2012      * that someone may use both the old and the new allowance by unfortunate
2013      * transaction ordering. One possible solution to mitigate this race
2014      * condition is to first reduce the spender's allowance to 0 and set the
2015      * desired value afterwards:
2016      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2017      *
2018      * Emits an {Approval} event.
2019      */
2020     function approve(address spender, uint256 amount) external returns (bool);
2021 
2022     /**
2023      * @dev Moves `amount` tokens from `from` to `to` using the
2024      * allowance mechanism. `amount` is then deducted from the caller's
2025      * allowance.
2026      *
2027      * Returns a boolean value indicating whether the operation succeeded.
2028      *
2029      * Emits a {Transfer} event.
2030      */
2031     function transferFrom(
2032         address from,
2033         address to,
2034         uint256 amount
2035     ) external returns (bool);
2036 }
2037 
2038 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
2039 
2040 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
2041 
2042 pragma solidity ^0.8.0;
2043 
2044 /**
2045  * @dev Interface for the optional metadata functions from the ERC20 standard.
2046  *
2047  * _Available since v4.1._
2048  */
2049 interface IERC20Metadata is IERC20 {
2050     /**
2051      * @dev Returns the name of the token.
2052      */
2053     function name() external view returns (string memory);
2054 
2055     /**
2056      * @dev Returns the symbol of the token.
2057      */
2058     function symbol() external view returns (string memory);
2059 
2060     /**
2061      * @dev Returns the decimals places of the token.
2062      */
2063     function decimals() external view returns (uint8);
2064 }
2065 
2066 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
2067 
2068 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
2069 
2070 pragma solidity ^0.8.0;
2071 
2072 /**
2073  * @dev Implementation of the {IERC20} interface.
2074  *
2075  * This implementation is agnostic to the way tokens are created. This means
2076  * that a supply mechanism has to be added in a derived contract using {_mint}.
2077  * For a generic mechanism see {ERC20PresetMinterPauser}.
2078  *
2079  * TIP: For a detailed writeup see our guide
2080  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
2081  * to implement supply mechanisms].
2082  *
2083  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2084  * instead returning `false` on failure. This behavior is nonetheless
2085  * conventional and does not conflict with the expectations of ERC20
2086  * applications.
2087  *
2088  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2089  * This allows applications to reconstruct the allowance for all accounts just
2090  * by listening to said events. Other implementations of the EIP may not emit
2091  * these events, as it isn't required by the specification.
2092  *
2093  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2094  * functions have been added to mitigate the well-known issues around setting
2095  * allowances. See {IERC20-approve}.
2096  */
2097 contract ERC20 is Context, IERC20, IERC20Metadata {
2098     mapping(address => uint256) private _balances;
2099 
2100     mapping(address => mapping(address => uint256)) private _allowances;
2101 
2102     uint256 private _totalSupply;
2103 
2104     string private _name;
2105     string private _symbol;
2106 
2107     /**
2108      * @dev Sets the values for {name} and {symbol}.
2109      *
2110      * The default value of {decimals} is 18. To select a different value for
2111      * {decimals} you should overload it.
2112      *
2113      * All two of these values are immutable: they can only be set once during
2114      * construction.
2115      */
2116     constructor(string memory name_, string memory symbol_) {
2117         _name = name_;
2118         _symbol = symbol_;
2119     }
2120 
2121     /**
2122      * @dev Returns the name of the token.
2123      */
2124     function name() public view virtual override returns (string memory) {
2125         return _name;
2126     }
2127 
2128     /**
2129      * @dev Returns the symbol of the token, usually a shorter version of the
2130      * name.
2131      */
2132     function symbol() public view virtual override returns (string memory) {
2133         return _symbol;
2134     }
2135 
2136     /**
2137      * @dev Returns the number of decimals used to get its user representation.
2138      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2139      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2140      *
2141      * Tokens usually opt for a value of 18, imitating the relationship between
2142      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2143      * overridden;
2144      *
2145      * NOTE: This information is only used for _display_ purposes: it in
2146      * no way affects any of the arithmetic of the contract, including
2147      * {IERC20-balanceOf} and {IERC20-transfer}.
2148      */
2149     function decimals() public view virtual override returns (uint8) {
2150         return 18;
2151     }
2152 
2153     /**
2154      * @dev See {IERC20-totalSupply}.
2155      */
2156     function totalSupply() public view virtual override returns (uint256) {
2157         return _totalSupply;
2158     }
2159 
2160     /**
2161      * @dev See {IERC20-balanceOf}.
2162      */
2163     function balanceOf(address account)
2164         public
2165         view
2166         virtual
2167         override
2168         returns (uint256)
2169     {
2170         return _balances[account];
2171     }
2172 
2173     /**
2174      * @dev See {IERC20-transfer}.
2175      *
2176      * Requirements:
2177      *
2178      * - `to` cannot be the zero address.
2179      * - the caller must have a balance of at least `amount`.
2180      */
2181     function transfer(address to, uint256 amount)
2182         public
2183         virtual
2184         override
2185         returns (bool)
2186     {
2187         address owner = _msgSender();
2188         _transfer(owner, to, amount);
2189         return true;
2190     }
2191 
2192     /**
2193      * @dev See {IERC20-allowance}.
2194      */
2195     function allowance(address owner, address spender)
2196         public
2197         view
2198         virtual
2199         override
2200         returns (uint256)
2201     {
2202         return _allowances[owner][spender];
2203     }
2204 
2205     /**
2206      * @dev See {IERC20-approve}.
2207      *
2208      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2209      * `transferFrom`. This is semantically equivalent to an infinite approval.
2210      *
2211      * Requirements:
2212      *
2213      * - `spender` cannot be the zero address.
2214      */
2215     function approve(address spender, uint256 amount)
2216         public
2217         virtual
2218         override
2219         returns (bool)
2220     {
2221         address owner = _msgSender();
2222         _approve(owner, spender, amount);
2223         return true;
2224     }
2225 
2226     /**
2227      * @dev See {IERC20-transferFrom}.
2228      *
2229      * Emits an {Approval} event indicating the updated allowance. This is not
2230      * required by the EIP. See the note at the beginning of {ERC20}.
2231      *
2232      * NOTE: Does not update the allowance if the current allowance
2233      * is the maximum `uint256`.
2234      *
2235      * Requirements:
2236      *
2237      * - `from` and `to` cannot be the zero address.
2238      * - `from` must have a balance of at least `amount`.
2239      * - the caller must have allowance for ``from``'s tokens of at least
2240      * `amount`.
2241      */
2242     function transferFrom(
2243         address from,
2244         address to,
2245         uint256 amount
2246     ) public virtual override returns (bool) {
2247         address spender = _msgSender();
2248         _spendAllowance(from, spender, amount);
2249         _transfer(from, to, amount);
2250         return true;
2251     }
2252 
2253     /**
2254      * @dev Atomically increases the allowance granted to `spender` by the caller.
2255      *
2256      * This is an alternative to {approve} that can be used as a mitigation for
2257      * problems described in {IERC20-approve}.
2258      *
2259      * Emits an {Approval} event indicating the updated allowance.
2260      *
2261      * Requirements:
2262      *
2263      * - `spender` cannot be the zero address.
2264      */
2265     function increaseAllowance(address spender, uint256 addedValue)
2266         public
2267         virtual
2268         returns (bool)
2269     {
2270         address owner = _msgSender();
2271         _approve(owner, spender, allowance(owner, spender) + addedValue);
2272         return true;
2273     }
2274 
2275     /**
2276      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2277      *
2278      * This is an alternative to {approve} that can be used as a mitigation for
2279      * problems described in {IERC20-approve}.
2280      *
2281      * Emits an {Approval} event indicating the updated allowance.
2282      *
2283      * Requirements:
2284      *
2285      * - `spender` cannot be the zero address.
2286      * - `spender` must have allowance for the caller of at least
2287      * `subtractedValue`.
2288      */
2289     function decreaseAllowance(address spender, uint256 subtractedValue)
2290         public
2291         virtual
2292         returns (bool)
2293     {
2294         address owner = _msgSender();
2295         uint256 currentAllowance = allowance(owner, spender);
2296         require(
2297             currentAllowance >= subtractedValue,
2298             "ERC20: decreased allowance below zero"
2299         );
2300         unchecked {
2301             _approve(owner, spender, currentAllowance - subtractedValue);
2302         }
2303 
2304         return true;
2305     }
2306 
2307     /**
2308      * @dev Moves `amount` of tokens from `from` to `to`.
2309      *
2310      * This internal function is equivalent to {transfer}, and can be used to
2311      * e.g. implement automatic token fees, slashing mechanisms, etc.
2312      *
2313      * Emits a {Transfer} event.
2314      *
2315      * Requirements:
2316      *
2317      * - `from` cannot be the zero address.
2318      * - `to` cannot be the zero address.
2319      * - `from` must have a balance of at least `amount`.
2320      */
2321     function _transfer(
2322         address from,
2323         address to,
2324         uint256 amount
2325     ) internal virtual {
2326         require(from != address(0), "ERC20: transfer from the zero address");
2327         require(to != address(0), "ERC20: transfer to the zero address");
2328 
2329         _beforeTokenTransfer(from, to, amount);
2330 
2331         uint256 fromBalance = _balances[from];
2332         require(
2333             fromBalance >= amount,
2334             "ERC20: transfer amount exceeds balance"
2335         );
2336         unchecked {
2337             _balances[from] = fromBalance - amount;
2338             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
2339             // decrementing then incrementing.
2340             _balances[to] += amount;
2341         }
2342 
2343         emit Transfer(from, to, amount);
2344 
2345         _afterTokenTransfer(from, to, amount);
2346     }
2347 
2348     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2349      * the total supply.
2350      *
2351      * Emits a {Transfer} event with `from` set to the zero address.
2352      *
2353      * Requirements:
2354      *
2355      * - `account` cannot be the zero address.
2356      */
2357     function _mint(address account, uint256 amount) internal virtual {
2358         require(account != address(0), "ERC20: mint to the zero address");
2359 
2360         _beforeTokenTransfer(address(0), account, amount);
2361 
2362         _totalSupply += amount;
2363         unchecked {
2364             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
2365             _balances[account] += amount;
2366         }
2367         emit Transfer(address(0), account, amount);
2368 
2369         _afterTokenTransfer(address(0), account, amount);
2370     }
2371 
2372     /**
2373      * @dev Destroys `amount` tokens from `account`, reducing the
2374      * total supply.
2375      *
2376      * Emits a {Transfer} event with `to` set to the zero address.
2377      *
2378      * Requirements:
2379      *
2380      * - `account` cannot be the zero address.
2381      * - `account` must have at least `amount` tokens.
2382      */
2383     function _burn(address account, uint256 amount) internal virtual {
2384         require(account != address(0), "ERC20: burn from the zero address");
2385 
2386         _beforeTokenTransfer(account, address(0), amount);
2387 
2388         uint256 accountBalance = _balances[account];
2389         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2390         unchecked {
2391             _balances[account] = accountBalance - amount;
2392             // Overflow not possible: amount <= accountBalance <= totalSupply.
2393             _totalSupply -= amount;
2394         }
2395 
2396         emit Transfer(account, address(0), amount);
2397 
2398         _afterTokenTransfer(account, address(0), amount);
2399     }
2400 
2401     /**
2402      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2403      *
2404      * This internal function is equivalent to `approve`, and can be used to
2405      * e.g. set automatic allowances for certain subsystems, etc.
2406      *
2407      * Emits an {Approval} event.
2408      *
2409      * Requirements:
2410      *
2411      * - `owner` cannot be the zero address.
2412      * - `spender` cannot be the zero address.
2413      */
2414     function _approve(
2415         address owner,
2416         address spender,
2417         uint256 amount
2418     ) internal virtual {
2419         require(owner != address(0), "ERC20: approve from the zero address");
2420         require(spender != address(0), "ERC20: approve to the zero address");
2421 
2422         _allowances[owner][spender] = amount;
2423         emit Approval(owner, spender, amount);
2424     }
2425 
2426     /**
2427      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
2428      *
2429      * Does not update the allowance amount in case of infinite allowance.
2430      * Revert if not enough allowance is available.
2431      *
2432      * Might emit an {Approval} event.
2433      */
2434     function _spendAllowance(
2435         address owner,
2436         address spender,
2437         uint256 amount
2438     ) internal virtual {
2439         uint256 currentAllowance = allowance(owner, spender);
2440         if (currentAllowance != type(uint256).max) {
2441             require(
2442                 currentAllowance >= amount,
2443                 "ERC20: insufficient allowance"
2444             );
2445             unchecked {
2446                 _approve(owner, spender, currentAllowance - amount);
2447             }
2448         }
2449     }
2450 
2451     /**
2452      * @dev Hook that is called before any transfer of tokens. This includes
2453      * minting and burning.
2454      *
2455      * Calling conditions:
2456      *
2457      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2458      * will be transferred to `to`.
2459      * - when `from` is zero, `amount` tokens will be minted for `to`.
2460      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2461      * - `from` and `to` are never both zero.
2462      *
2463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2464      */
2465     function _beforeTokenTransfer(
2466         address from,
2467         address to,
2468         uint256 amount
2469     ) internal virtual {}
2470 
2471     /**
2472      * @dev Hook that is called after any transfer of tokens. This includes
2473      * minting and burning.
2474      *
2475      * Calling conditions:
2476      *
2477      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2478      * has been transferred to `to`.
2479      * - when `from` is zero, `amount` tokens have been minted for `to`.
2480      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2481      * - `from` and `to` are never both zero.
2482      *
2483      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2484      */
2485     function _afterTokenTransfer(
2486         address from,
2487         address to,
2488         uint256 amount
2489     ) internal virtual {}
2490 }
2491 
2492 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol
2493 
2494 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
2495 
2496 pragma solidity ^0.8.0;
2497 
2498 /**
2499  * @dev Extension of {ERC20} that allows token holders to destroy both their own
2500  * tokens and those that they have an allowance for, in a way that can be
2501  * recognized off-chain (via event analysis).
2502  */
2503 abstract contract ERC20Burnable is Context, ERC20 {
2504     /**
2505      * @dev Destroys `amount` tokens from the caller.
2506      *
2507      * See {ERC20-_burn}.
2508      */
2509     function burn(uint256 amount) public virtual {
2510         _burn(_msgSender(), amount);
2511     }
2512 
2513     /**
2514      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
2515      * allowance.
2516      *
2517      * See {ERC20-_burn} and {ERC20-allowance}.
2518      *
2519      * Requirements:
2520      *
2521      * - the caller must have allowance for ``accounts``'s tokens of at least
2522      * `amount`.
2523      */
2524     function burnFrom(address account, uint256 amount) public virtual {
2525         _spendAllowance(account, _msgSender(), amount);
2526         _burn(account, amount);
2527     }
2528 }
2529 
2530 // File: contracts/ERC20PresetMinterRebaser.sol
2531 
2532 pragma solidity ^0.8.0;
2533 
2534 contract ERC20PresetMinterRebaser is
2535     Context,
2536     AccessControlEnumerable,
2537     ERC20Burnable
2538 {
2539     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2540     bytes32 public constant REBASER_ROLE = keccak256("REBASER_ROLE");
2541 
2542     constructor(string memory name, string memory symbol) ERC20(name, symbol) {
2543         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2544 
2545         _setupRole(MINTER_ROLE, _msgSender());
2546         _setupRole(REBASER_ROLE, _msgSender());
2547     }
2548 }
2549 
2550 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol
2551 
2552 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
2553 
2554 pragma solidity ^0.8.0;
2555 
2556 /**
2557  * @title SafeERC20
2558  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2559  * contract returns false). Tokens that return no value (and instead revert or
2560  * throw on failure) are also supported, non-reverting calls are assumed to be
2561  * successful.
2562  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2563  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2564  */
2565 library SafeERC20 {
2566     using Address for address;
2567 
2568     function safeTransfer(
2569         IERC20 token,
2570         address to,
2571         uint256 value
2572     ) internal {
2573         _callOptionalReturn(
2574             token,
2575             abi.encodeWithSelector(token.transfer.selector, to, value)
2576         );
2577     }
2578 
2579     function safeTransferFrom(
2580         IERC20 token,
2581         address from,
2582         address to,
2583         uint256 value
2584     ) internal {
2585         _callOptionalReturn(
2586             token,
2587             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
2588         );
2589     }
2590 
2591     /**
2592      * @dev Deprecated. This function has issues similar to the ones found in
2593      * {IERC20-approve}, and its usage is discouraged.
2594      *
2595      * Whenever possible, use {safeIncreaseAllowance} and
2596      * {safeDecreaseAllowance} instead.
2597      */
2598     function safeApprove(
2599         IERC20 token,
2600         address spender,
2601         uint256 value
2602     ) internal {
2603         // safeApprove should only be called when setting an initial allowance,
2604         // or when resetting it to zero. To increase and decrease it, use
2605         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2606         require(
2607             (value == 0) || (token.allowance(address(this), spender) == 0),
2608             "SafeERC20: approve from non-zero to non-zero allowance"
2609         );
2610         _callOptionalReturn(
2611             token,
2612             abi.encodeWithSelector(token.approve.selector, spender, value)
2613         );
2614     }
2615 
2616     function safeIncreaseAllowance(
2617         IERC20 token,
2618         address spender,
2619         uint256 value
2620     ) internal {
2621         uint256 newAllowance = token.allowance(address(this), spender) + value;
2622         _callOptionalReturn(
2623             token,
2624             abi.encodeWithSelector(
2625                 token.approve.selector,
2626                 spender,
2627                 newAllowance
2628             )
2629         );
2630     }
2631 
2632     function safeDecreaseAllowance(
2633         IERC20 token,
2634         address spender,
2635         uint256 value
2636     ) internal {
2637         unchecked {
2638             uint256 oldAllowance = token.allowance(address(this), spender);
2639             require(
2640                 oldAllowance >= value,
2641                 "SafeERC20: decreased allowance below zero"
2642             );
2643             uint256 newAllowance = oldAllowance - value;
2644             _callOptionalReturn(
2645                 token,
2646                 abi.encodeWithSelector(
2647                     token.approve.selector,
2648                     spender,
2649                     newAllowance
2650                 )
2651             );
2652         }
2653     }
2654 
2655     function safePermit(
2656         IERC20Permit token,
2657         address owner,
2658         address spender,
2659         uint256 value,
2660         uint256 deadline,
2661         uint8 v,
2662         bytes32 r,
2663         bytes32 s
2664     ) internal {
2665         uint256 nonceBefore = token.nonces(owner);
2666         token.permit(owner, spender, value, deadline, v, r, s);
2667         uint256 nonceAfter = token.nonces(owner);
2668         require(
2669             nonceAfter == nonceBefore + 1,
2670             "SafeERC20: permit did not succeed"
2671         );
2672     }
2673 
2674     /**
2675      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2676      * on the return value: the return value is optional (but if data is returned, it must not be false).
2677      * @param token The token targeted by the call.
2678      * @param data The call data (encoded using abi.encode or one of its variants).
2679      */
2680     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2681         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2682         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2683         // the target address contains contract code and also asserts for success in the low-level call.
2684 
2685         bytes memory returndata = address(token).functionCall(
2686             data,
2687             "SafeERC20: low-level call failed"
2688         );
2689         if (returndata.length > 0) {
2690             // Return data is optional
2691             require(
2692                 abi.decode(returndata, (bool)),
2693                 "SafeERC20: ERC20 operation did not succeed"
2694             );
2695         }
2696     }
2697 }
2698 
2699 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
2700 
2701 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
2702 
2703 pragma solidity ^0.8.0;
2704 
2705 // CAUTION
2706 // This version of SafeMath should only be used with Solidity 0.8 or later,
2707 // because it relies on the compiler's built in overflow checks.
2708 
2709 /**
2710  * @dev Wrappers over Solidity's arithmetic operations.
2711  *
2712  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
2713  * now has built in overflow checking.
2714  */
2715 library SafeMath {
2716     /**
2717      * @dev Returns the addition of two unsigned integers, with an overflow flag.
2718      *
2719      * _Available since v3.4._
2720      */
2721     function tryAdd(uint256 a, uint256 b)
2722         internal
2723         pure
2724         returns (bool, uint256)
2725     {
2726         unchecked {
2727             uint256 c = a + b;
2728             if (c < a) return (false, 0);
2729             return (true, c);
2730         }
2731     }
2732 
2733     /**
2734      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
2735      *
2736      * _Available since v3.4._
2737      */
2738     function trySub(uint256 a, uint256 b)
2739         internal
2740         pure
2741         returns (bool, uint256)
2742     {
2743         unchecked {
2744             if (b > a) return (false, 0);
2745             return (true, a - b);
2746         }
2747     }
2748 
2749     /**
2750      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2751      *
2752      * _Available since v3.4._
2753      */
2754     function tryMul(uint256 a, uint256 b)
2755         internal
2756         pure
2757         returns (bool, uint256)
2758     {
2759         unchecked {
2760             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2761             // benefit is lost if 'b' is also tested.
2762             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2763             if (a == 0) return (true, 0);
2764             uint256 c = a * b;
2765             if (c / a != b) return (false, 0);
2766             return (true, c);
2767         }
2768     }
2769 
2770     /**
2771      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2772      *
2773      * _Available since v3.4._
2774      */
2775     function tryDiv(uint256 a, uint256 b)
2776         internal
2777         pure
2778         returns (bool, uint256)
2779     {
2780         unchecked {
2781             if (b == 0) return (false, 0);
2782             return (true, a / b);
2783         }
2784     }
2785 
2786     /**
2787      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2788      *
2789      * _Available since v3.4._
2790      */
2791     function tryMod(uint256 a, uint256 b)
2792         internal
2793         pure
2794         returns (bool, uint256)
2795     {
2796         unchecked {
2797             if (b == 0) return (false, 0);
2798             return (true, a % b);
2799         }
2800     }
2801 
2802     /**
2803      * @dev Returns the addition of two unsigned integers, reverting on
2804      * overflow.
2805      *
2806      * Counterpart to Solidity's `+` operator.
2807      *
2808      * Requirements:
2809      *
2810      * - Addition cannot overflow.
2811      */
2812     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2813         return a + b;
2814     }
2815 
2816     /**
2817      * @dev Returns the subtraction of two unsigned integers, reverting on
2818      * overflow (when the result is negative).
2819      *
2820      * Counterpart to Solidity's `-` operator.
2821      *
2822      * Requirements:
2823      *
2824      * - Subtraction cannot overflow.
2825      */
2826     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2827         return a - b;
2828     }
2829 
2830     /**
2831      * @dev Returns the multiplication of two unsigned integers, reverting on
2832      * overflow.
2833      *
2834      * Counterpart to Solidity's `*` operator.
2835      *
2836      * Requirements:
2837      *
2838      * - Multiplication cannot overflow.
2839      */
2840     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2841         return a * b;
2842     }
2843 
2844     /**
2845      * @dev Returns the integer division of two unsigned integers, reverting on
2846      * division by zero. The result is rounded towards zero.
2847      *
2848      * Counterpart to Solidity's `/` operator.
2849      *
2850      * Requirements:
2851      *
2852      * - The divisor cannot be zero.
2853      */
2854     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2855         return a / b;
2856     }
2857 
2858     /**
2859      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2860      * reverting when dividing by zero.
2861      *
2862      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2863      * opcode (which leaves remaining gas untouched) while Solidity uses an
2864      * invalid opcode to revert (consuming all remaining gas).
2865      *
2866      * Requirements:
2867      *
2868      * - The divisor cannot be zero.
2869      */
2870     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2871         return a % b;
2872     }
2873 
2874     /**
2875      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2876      * overflow (when the result is negative).
2877      *
2878      * CAUTION: This function is deprecated because it requires allocating memory for the error
2879      * message unnecessarily. For custom revert reasons use {trySub}.
2880      *
2881      * Counterpart to Solidity's `-` operator.
2882      *
2883      * Requirements:
2884      *
2885      * - Subtraction cannot overflow.
2886      */
2887     function sub(
2888         uint256 a,
2889         uint256 b,
2890         string memory errorMessage
2891     ) internal pure returns (uint256) {
2892         unchecked {
2893             require(b <= a, errorMessage);
2894             return a - b;
2895         }
2896     }
2897 
2898     /**
2899      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2900      * division by zero. The result is rounded towards zero.
2901      *
2902      * Counterpart to Solidity's `/` operator. Note: this function uses a
2903      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2904      * uses an invalid opcode to revert (consuming all remaining gas).
2905      *
2906      * Requirements:
2907      *
2908      * - The divisor cannot be zero.
2909      */
2910     function div(
2911         uint256 a,
2912         uint256 b,
2913         string memory errorMessage
2914     ) internal pure returns (uint256) {
2915         unchecked {
2916             require(b > 0, errorMessage);
2917             return a / b;
2918         }
2919     }
2920 
2921     /**
2922      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2923      * reverting with custom message when dividing by zero.
2924      *
2925      * CAUTION: This function is deprecated because it requires allocating memory for the error
2926      * message unnecessarily. For custom revert reasons use {tryMod}.
2927      *
2928      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2929      * opcode (which leaves remaining gas untouched) while Solidity uses an
2930      * invalid opcode to revert (consuming all remaining gas).
2931      *
2932      * Requirements:
2933      *
2934      * - The divisor cannot be zero.
2935      */
2936     function mod(
2937         uint256 a,
2938         uint256 b,
2939         string memory errorMessage
2940     ) internal pure returns (uint256) {
2941         unchecked {
2942             require(b > 0, errorMessage);
2943             return a % b;
2944         }
2945     }
2946 }
2947 
2948 // File: contracts/Yolk.sol
2949 
2950 pragma solidity ^0.8.0;
2951 
2952 // Storage for a YOLK token
2953 contract YOLK {
2954     using SafeMath for uint256;
2955 
2956     /**
2957      * @dev Guard variable for re-entrancy checks. Not currently used
2958      */
2959     bool internal _notEntered;
2960 
2961     /**
2962      * @notice Governor for this contract
2963      */
2964     address public gov;
2965 
2966     /**
2967      * @notice Pending governance for this contract
2968      */
2969     address public pendingGov;
2970 
2971     /**
2972      * @notice Approved rebaser for this contract
2973      */
2974     address public rebaser;
2975 
2976     /**
2977      * @notice Approved migrator for this contract
2978      */
2979     address public migrator;
2980 
2981     /**
2982      * @notice Incentivizer address of YAM protocol
2983      */
2984     address public incentivizer;
2985 
2986     /**
2987      * @notice Total supply of YAMs
2988      */
2989     uint256 public totalSupply;
2990 
2991     /**
2992      * @notice Internal decimals used to handle scaling factor
2993      */
2994     uint256 public constant internalDecimals = 10**24;
2995 
2996     /**
2997      * @notice Used for percentage maths
2998      */
2999     uint256 public constant BASE = 10**18;
3000 
3001     /**
3002      * @notice Scaling factor that adjusts everyone's balances
3003      */
3004     uint256 public yamsScalingFactor;
3005 
3006     mapping(address => uint256) internal _yamBalances;
3007 
3008     mapping(address => mapping(address => uint256)) internal _allowedFragments;
3009 
3010     uint256 public initSupply;
3011 
3012     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
3013     bytes32 public constant PERMIT_TYPEHASH =
3014         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
3015     bytes32 public DOMAIN_SEPARATOR;
3016 
3017     mapping(address => uint256) public nonces;
3018 
3019     /// @notice The EIP-712 typehash for the contract's domain
3020     bytes32 public constant DOMAIN_TYPEHASH =
3021         keccak256(
3022             "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
3023         );
3024 }
3025 
3026 // File: contracts/IYOLK.sol
3027 
3028 pragma solidity ^0.8.0;
3029 
3030 abstract contract IYOLK {
3031     /**
3032      * @notice Event emitted when tokens are rebased
3033      */
3034     event Rebase(
3035         uint256 epoch,
3036         uint256 prevYolksScalingFactor,
3037         uint256 newYolksScalingFactor
3038     );
3039 
3040     /* - Extra Events - */
3041     /**
3042      * @notice Tokens minted event
3043      */
3044     event Mint(address to, uint256 amount);
3045 
3046     /**
3047      * @notice Tokens burned event
3048      */
3049     event Burn(address from, uint256 amount);
3050 }
3051 
3052 // File: contracts/Yolk.sol
3053 
3054 pragma solidity ^0.8.0;
3055 
3056 contract Yolk is ERC20PresetMinterRebaser, Ownable, IYOLK {
3057     using SafeMath for uint256;
3058 
3059     /**
3060      * @dev Guard variable for re-entrancy checks. Not currently used
3061      */
3062     bool internal _notEntered;
3063 
3064     /**
3065      * @notice Internal decimals used to handle scaling factor
3066      */
3067     uint256 public constant internalDecimals = 10**24;
3068 
3069     /**
3070      * @notice Used for percentage maths
3071      */
3072     uint256 public constant BASE = 10**18;
3073 
3074     /**
3075      * @notice Scaling factor that adjusts everyone's balances
3076      */
3077     uint256 public yolksScalingFactor;
3078 
3079     mapping(address => uint256) internal _yolkBalances;
3080 
3081     mapping(address => mapping(address => uint256)) internal _allowedFragments;
3082 
3083     uint256 public initSupply;
3084 
3085     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
3086     bytes32 public constant PERMIT_TYPEHASH =
3087         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
3088     bytes32 public DOMAIN_SEPARATOR;
3089 
3090     mapping(address => uint256) public nonces;
3091 
3092     /// @notice The EIP-712 typehash for the contract's domain
3093     bytes32 public constant DOMAIN_TYPEHASH =
3094         keccak256(
3095             "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
3096         );
3097 
3098     uint256 private INIT_SUPPLY = 3324324324357 * 10**18;
3099     uint256 private _totalSupply;
3100 
3101     modifier validRecipient(address to) {
3102         require(to != address(0x0));
3103         require(to != address(this));
3104         _;
3105     }
3106 
3107     constructor() ERC20PresetMinterRebaser("Yolk", "YOLK") {
3108         yolksScalingFactor = BASE;
3109         initSupply = _fragmentToYolk(INIT_SUPPLY);
3110         _totalSupply = INIT_SUPPLY;
3111         _yolkBalances[owner()] = initSupply;
3112 
3113         emit Transfer(address(0), msg.sender, INIT_SUPPLY);
3114     }
3115 
3116     /**
3117      * @return The total number of fragments.
3118      */
3119     function totalSupply() public view override returns (uint256) {
3120         return _totalSupply;
3121     }
3122 
3123     /**
3124      * @notice Computes the current max scaling factor
3125      */
3126     function maxScalingFactor() external view returns (uint256) {
3127         return _maxScalingFactor();
3128     }
3129 
3130     function _maxScalingFactor() internal view returns (uint256) {
3131         // scaling factor can only go up to 2**256-1 = initSupply * yolksScalingFactor
3132         // this is used to check if yolksScalingFactor will be too high to compute balances when rebasing.
3133         return uint256(int256(-1)) / initSupply;
3134     }
3135 
3136     /**
3137      * @notice Mints new tokens, increasing totalSupply, initSupply, and a users balance.
3138      */
3139     function mint(address to, uint256 amount) external returns (bool) {
3140         require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role");
3141 
3142         _mint(to, amount);
3143         return true;
3144     }
3145 
3146     function _mint(address to, uint256 amount) internal override {
3147         // increase totalSupply
3148         _totalSupply = _totalSupply.add(amount);
3149 
3150         // get underlying value
3151         uint256 yolkValue = _fragmentToYolk(amount);
3152 
3153         // increase initSupply
3154         initSupply = initSupply.add(yolkValue);
3155 
3156         // make sure the mint didnt push maxScalingFactor too low
3157         require(
3158             yolksScalingFactor <= _maxScalingFactor(),
3159             "max scaling factor too low"
3160         );
3161 
3162         // add balance
3163         _yolkBalances[to] = _yolkBalances[to].add(yolkValue);
3164 
3165         emit Mint(to, amount);
3166         emit Transfer(address(0), to, amount);
3167     }
3168 
3169     /**
3170      * @notice Burns tokens from msg.sender, decreases totalSupply, initSupply, and a users balance.
3171      */
3172 
3173     function burn(uint256 amount) public override {
3174         _burn(amount);
3175     }
3176 
3177     function _burn(uint256 amount) internal {
3178         // decrease totalSupply
3179         _totalSupply = _totalSupply.sub(amount);
3180 
3181         // get underlying value
3182         uint256 yolkValue = _fragmentToYolk(amount);
3183 
3184         // decrease initSupply
3185         initSupply = initSupply.sub(yolkValue);
3186 
3187         // decrease balance
3188         _yolkBalances[msg.sender] = _yolkBalances[msg.sender].sub(yolkValue);
3189         emit Burn(msg.sender, amount);
3190         emit Transfer(msg.sender, address(0), amount);
3191     }
3192 
3193     /**
3194      * @notice Mints new tokens using underlying amount, increasing totalSupply, initSupply, and a users balance.
3195      */
3196     function mintUnderlying(address to, uint256 amount) public returns (bool) {
3197         require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role");
3198 
3199         _mintUnderlying(to, amount);
3200         return true;
3201     }
3202 
3203     function _mintUnderlying(address to, uint256 amount) internal {
3204         // increase initSupply
3205         initSupply = initSupply.add(amount);
3206 
3207         // get external value
3208         uint256 scaledAmount = _yolkToFragment(amount);
3209 
3210         // increase totalSupply
3211         _totalSupply = _totalSupply.add(scaledAmount);
3212 
3213         // make sure the mint didnt push maxScalingFactor too low
3214         require(
3215             yolksScalingFactor <= _maxScalingFactor(),
3216             "max scaling factor too low"
3217         );
3218 
3219         // add balance
3220         _yolkBalances[to] = _yolkBalances[to].add(amount);
3221 
3222         emit Mint(to, scaledAmount);
3223         emit Transfer(address(0), to, scaledAmount);
3224     }
3225 
3226     /**
3227      * @dev Transfer underlying balance to a specified address.
3228      * @param to The address to transfer to.
3229      * @param value The amount to be transferred.
3230      * @return True on success, false otherwise.
3231      */
3232     function transferUnderlying(address to, uint256 value)
3233         public
3234         validRecipient(to)
3235         returns (bool)
3236     {
3237         // sub from balance of sender
3238         _yolkBalances[msg.sender] = _yolkBalances[msg.sender].sub(value);
3239 
3240         // add to balance of receiver
3241         _yolkBalances[to] = _yolkBalances[to].add(value);
3242         emit Transfer(msg.sender, to, _yolkToFragment(value));
3243         return true;
3244     }
3245 
3246     /* - ERC20 functionality - */
3247 
3248     /**
3249      * @dev Transfer tokens to a specified address.
3250      * @param to The address to transfer to.
3251      * @param value The amount to be transferred.
3252      * @return True on success, false otherwise.
3253      */
3254     function transfer(address to, uint256 value)
3255         public
3256         override
3257         validRecipient(to)
3258         returns (bool)
3259     {
3260         // underlying balance is stored in yolks, so divide by current scaling factor
3261 
3262         // note, this means as scaling factor grows, dust will be untransferrable.
3263         // minimum transfer value == yolksScalingFactor / 1e24;
3264 
3265         // get amount in underlying
3266         uint256 yolkValue = _fragmentToYolk(value);
3267 
3268         // sub from balance of sender
3269         _yolkBalances[msg.sender] = _yolkBalances[msg.sender].sub(yolkValue);
3270 
3271         // add to balance of receiver
3272         _yolkBalances[to] = _yolkBalances[to].add(yolkValue);
3273         emit Transfer(msg.sender, to, value);
3274 
3275         return true;
3276     }
3277 
3278     /**
3279      * @dev Transfer tokens from one address to another.
3280      * @param from The address you want to send tokens from.
3281      * @param to The address you want to transfer to.
3282      * @param value The amount of tokens to be transferred.
3283      */
3284     function transferFrom(
3285         address from,
3286         address to,
3287         uint256 value
3288     ) public override validRecipient(to) returns (bool) {
3289         // decrease allowance
3290         _allowedFragments[from][msg.sender] = _allowedFragments[from][
3291             msg.sender
3292         ].sub(value);
3293 
3294         // get value in yolks
3295         uint256 yolkValue = _fragmentToYolk(value);
3296 
3297         // sub from from
3298         _yolkBalances[from] = _yolkBalances[from].sub(yolkValue);
3299         _yolkBalances[to] = _yolkBalances[to].add(yolkValue);
3300         emit Transfer(from, to, value);
3301 
3302         return true;
3303     }
3304 
3305     /**
3306      * @param who The address to query.
3307      * @return The balance of the specified address.
3308      */
3309     function balanceOf(address who) public view override returns (uint256) {
3310         return _yolkToFragment(_yolkBalances[who]);
3311     }
3312 
3313     /** @notice Currently returns the internal storage amount
3314      * @param who The address to query.
3315      * @return The underlying balance of the specified address.
3316      */
3317     function balanceOfUnderlying(address who) public view returns (uint256) {
3318         return _yolkBalances[who];
3319     }
3320 
3321     /**
3322      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
3323      * @param owner_ The address which owns the funds.
3324      * @param spender The address which will spend the funds.
3325      * @return The number of tokens still available for the spender.
3326      */
3327     function allowance(address owner_, address spender)
3328         public
3329         view
3330         override
3331         returns (uint256)
3332     {
3333         return _allowedFragments[owner_][spender];
3334     }
3335 
3336     /**
3337      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
3338      * msg.sender. This method is included for ERC20 compatibility.
3339      * increaseAllowance and decreaseAllowance should be used instead.
3340      * Changing an allowance with this method brings the risk that someone may transfer both
3341      * the old and the new allowance - if they are both greater than zero - if a transfer
3342      * transaction is mined before the later approve() call is mined.
3343      *
3344      * @param spender The address which will spend the funds.
3345      * @param value The amount of tokens to be spent.
3346      */
3347     function approve(address spender, uint256 value)
3348         public
3349         override
3350         returns (bool)
3351     {
3352         _allowedFragments[msg.sender][spender] = value;
3353         emit Approval(msg.sender, spender, value);
3354         return true;
3355     }
3356 
3357     /**
3358      * @dev Increase the amount of tokens that an owner has allowed to a spender.
3359      * This method should be used instead of approve() to avoid the double approval vulnerability
3360      * described above.
3361      * @param spender The address which will spend the funds.
3362      * @param addedValue The amount of tokens to increase the allowance by.
3363      */
3364     function increaseAllowance(address spender, uint256 addedValue)
3365         public
3366         override
3367         returns (bool)
3368     {
3369         _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][
3370             spender
3371         ].add(addedValue);
3372         emit Approval(
3373             msg.sender,
3374             spender,
3375             _allowedFragments[msg.sender][spender]
3376         );
3377         return true;
3378     }
3379 
3380     /**
3381      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
3382      *
3383      * @param spender The address which will spend the funds.
3384      * @param subtractedValue The amount of tokens to decrease the allowance by.
3385      */
3386     function decreaseAllowance(address spender, uint256 subtractedValue)
3387         public
3388         override
3389         returns (bool)
3390     {
3391         uint256 oldValue = _allowedFragments[msg.sender][spender];
3392         if (subtractedValue >= oldValue) {
3393             _allowedFragments[msg.sender][spender] = 0;
3394         } else {
3395             _allowedFragments[msg.sender][spender] = oldValue.sub(
3396                 subtractedValue
3397             );
3398         }
3399         emit Approval(
3400             msg.sender,
3401             spender,
3402             _allowedFragments[msg.sender][spender]
3403         );
3404         return true;
3405     }
3406 
3407     // --- Approve by signature ---
3408     function permit(
3409         address owner,
3410         address spender,
3411         uint256 value,
3412         uint256 deadline,
3413         uint8 v,
3414         bytes32 r,
3415         bytes32 s
3416     ) public {
3417         require(block.timestamp <= deadline, "YOLK/permit-expired");
3418 
3419         bytes32 digest = keccak256(
3420             abi.encodePacked(
3421                 "\x19\x01",
3422                 DOMAIN_SEPARATOR,
3423                 keccak256(
3424                     abi.encode(
3425                         PERMIT_TYPEHASH,
3426                         owner,
3427                         spender,
3428                         value,
3429                         nonces[owner]++,
3430                         deadline
3431                     )
3432                 )
3433             )
3434         );
3435 
3436         require(owner != address(0), "YOLK/invalid-address-0");
3437         require(owner == ecrecover(digest, v, r, s), "YOLK/invalid-permit");
3438         _allowedFragments[owner][spender] = value;
3439         emit Approval(owner, spender, value);
3440     }
3441 
3442     function rebase(
3443         uint256 epoch,
3444         uint256 indexDelta,
3445         bool positive
3446     ) public returns (uint256) {
3447         require(hasRole(REBASER_ROLE, _msgSender()), "Must have rebaser role");
3448 
3449         // no change
3450         if (indexDelta == 0) {
3451             emit Rebase(epoch, yolksScalingFactor, yolksScalingFactor);
3452             return _totalSupply;
3453         }
3454 
3455         // for events
3456         uint256 prevYolksScalingFactor = yolksScalingFactor;
3457 
3458         if (!positive) {
3459             // negative rebase, decrease scaling factor
3460             yolksScalingFactor = yolksScalingFactor
3461                 .mul(BASE.sub(indexDelta))
3462                 .div(BASE);
3463         } else {
3464             // positive rebase, increase scaling factor
3465             uint256 newScalingFactor = yolksScalingFactor
3466                 .mul(BASE.add(indexDelta))
3467                 .div(BASE);
3468             if (newScalingFactor < _maxScalingFactor()) {
3469                 yolksScalingFactor = newScalingFactor;
3470             } else {
3471                 yolksScalingFactor = _maxScalingFactor();
3472             }
3473         }
3474 
3475         // update total supply, correctly
3476         _totalSupply = _yolkToFragment(initSupply);
3477 
3478         emit Rebase(epoch, prevYolksScalingFactor, yolksScalingFactor);
3479         return _totalSupply;
3480     }
3481 
3482     function yolkToFragment(uint256 yolk) public view returns (uint256) {
3483         return _yolkToFragment(yolk);
3484     }
3485 
3486     function fragmentToYolk(uint256 value) public view returns (uint256) {
3487         return _fragmentToYolk(value);
3488     }
3489 
3490     function _yolkToFragment(uint256 yolk) internal view returns (uint256) {
3491         return yolk.mul(yolksScalingFactor).div(internalDecimals);
3492     }
3493 
3494     function _fragmentToYolk(uint256 value) internal view returns (uint256) {
3495         return value.mul(internalDecimals).div(yolksScalingFactor);
3496     }
3497 
3498     // Rescue tokens
3499     function rescueTokens(
3500         address token,
3501         address to,
3502         uint256 amount
3503     ) public onlyOwner returns (bool) {
3504         // transfer to
3505         SafeERC20.safeTransfer(IERC20(token), to, amount);
3506         return true;
3507     }
3508 }