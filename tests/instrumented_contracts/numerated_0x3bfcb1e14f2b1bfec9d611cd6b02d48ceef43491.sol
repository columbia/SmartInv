1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 /**
6  * @dev Library for managing
7  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
8  * types.
9  *
10  * Sets have the following properties:
11  *
12  * - Elements are added, removed, and checked for existence in constant time
13  * (O(1)).
14  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
15  *
16  * ```
17  * contract Example {
18  *     // Add the library methods
19  *     using EnumerableSet for EnumerableSet.AddressSet;
20  *
21  *     // Declare a set state variable
22  *     EnumerableSet.AddressSet private mySet;
23  * }
24  * ```
25  *
26  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
27  * and `uint256` (`UintSet`) are supported.
28  *
29  * [WARNING]
30  * ====
31  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
32  * unusable.
33  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
34  *
35  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
36  * array of EnumerableSet.
37  * ====
38  */
39 library EnumerableSet {
40     // To implement this library for multiple types with as little code
41     // repetition as possible, we write it in terms of a generic Set type with
42     // bytes32 values.
43     // The Set implementation uses private functions, and user-facing
44     // implementations (such as AddressSet) are just wrappers around the
45     // underlying Set.
46     // This means that we can only create new EnumerableSets for types that fit
47     // in bytes32.
48 
49     struct Set {
50         // Storage of set values
51         bytes32[] _values;
52         // Position of the value in the `values` array, plus 1 because index 0
53         // means a value is not in the set.
54         mapping(bytes32 => uint256) _indexes;
55     }
56 
57     /**
58      * @dev Add a value to a set. O(1).
59      *
60      * Returns true if the value was added to the set, that is if it was not
61      * already present.
62      */
63     function _add(Set storage set, bytes32 value) private returns (bool) {
64         if (!_contains(set, value)) {
65             set._values.push(value);
66             // The value is stored at length-1, but we add 1 to all indexes
67             // and use 0 as a sentinel value
68             set._indexes[value] = set._values.length;
69             return true;
70         } else {
71             return false;
72         }
73     }
74 
75     /**
76      * @dev Removes a value from a set. O(1).
77      *
78      * Returns true if the value was removed from the set, that is if it was
79      * present.
80      */
81     function _remove(Set storage set, bytes32 value) private returns (bool) {
82         // We read and store the value's index to prevent multiple reads from the same storage slot
83         uint256 valueIndex = set._indexes[value];
84 
85         if (valueIndex != 0) {
86             // Equivalent to contains(set, value)
87             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
88             // the array, and then remove the last element (sometimes called as 'swap and pop').
89             // This modifies the order of the array, as noted in {at}.
90 
91             uint256 toDeleteIndex = valueIndex - 1;
92             uint256 lastIndex = set._values.length - 1;
93 
94             if (lastIndex != toDeleteIndex) {
95                 bytes32 lastValue = set._values[lastIndex];
96 
97                 // Move the last value to the index where the value to delete is
98                 set._values[toDeleteIndex] = lastValue;
99                 // Update the index for the moved value
100                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
101             }
102 
103             // Delete the slot where the moved value was stored
104             set._values.pop();
105 
106             // Delete the index for the deleted slot
107             delete set._indexes[value];
108 
109             return true;
110         } else {
111             return false;
112         }
113     }
114 
115     /**
116      * @dev Returns true if the value is in the set. O(1).
117      */
118     function _contains(Set storage set, bytes32 value) private view returns (bool) {
119         return set._indexes[value] != 0;
120     }
121 
122     /**
123      * @dev Returns the number of values on the set. O(1).
124      */
125     function _length(Set storage set) private view returns (uint256) {
126         return set._values.length;
127     }
128 
129     /**
130      * @dev Returns the value stored at position `index` in the set. O(1).
131      *
132      * Note that there are no guarantees on the ordering of values inside the
133      * array, and it may change when more values are added or removed.
134      *
135      * Requirements:
136      *
137      * - `index` must be strictly less than {length}.
138      */
139     function _at(Set storage set, uint256 index) private view returns (bytes32) {
140         return set._values[index];
141     }
142 
143     /**
144      * @dev Return the entire set in an array
145      *
146      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
147      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
148      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
149      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
150      */
151     function _values(Set storage set) private view returns (bytes32[] memory) {
152         return set._values;
153     }
154 
155     // Bytes32Set
156 
157     struct Bytes32Set {
158         Set _inner;
159     }
160 
161     /**
162      * @dev Add a value to a set. O(1).
163      *
164      * Returns true if the value was added to the set, that is if it was not
165      * already present.
166      */
167     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
168         return _add(set._inner, value);
169     }
170 
171     /**
172      * @dev Removes a value from a set. O(1).
173      *
174      * Returns true if the value was removed from the set, that is if it was
175      * present.
176      */
177     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
178         return _remove(set._inner, value);
179     }
180 
181     /**
182      * @dev Returns true if the value is in the set. O(1).
183      */
184     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
185         return _contains(set._inner, value);
186     }
187 
188     /**
189      * @dev Returns the number of values in the set. O(1).
190      */
191     function length(Bytes32Set storage set) internal view returns (uint256) {
192         return _length(set._inner);
193     }
194 
195     /**
196      * @dev Returns the value stored at position `index` in the set. O(1).
197      *
198      * Note that there are no guarantees on the ordering of values inside the
199      * array, and it may change when more values are added or removed.
200      *
201      * Requirements:
202      *
203      * - `index` must be strictly less than {length}.
204      */
205     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
206         return _at(set._inner, index);
207     }
208 
209     /**
210      * @dev Return the entire set in an array
211      *
212      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
213      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
214      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
215      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
216      */
217     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
218         bytes32[] memory store = _values(set._inner);
219         bytes32[] memory result;
220 
221         /// @solidity memory-safe-assembly
222         assembly {
223             result := store
224         }
225 
226         return result;
227     }
228 
229     // AddressSet
230 
231     struct AddressSet {
232         Set _inner;
233     }
234 
235     /**
236      * @dev Add a value to a set. O(1).
237      *
238      * Returns true if the value was added to the set, that is if it was not
239      * already present.
240      */
241     function add(AddressSet storage set, address value) internal returns (bool) {
242         return _add(set._inner, bytes32(uint256(uint160(value))));
243     }
244 
245     /**
246      * @dev Removes a value from a set. O(1).
247      *
248      * Returns true if the value was removed from the set, that is if it was
249      * present.
250      */
251     function remove(AddressSet storage set, address value) internal returns (bool) {
252         return _remove(set._inner, bytes32(uint256(uint160(value))));
253     }
254 
255     /**
256      * @dev Returns true if the value is in the set. O(1).
257      */
258     function contains(AddressSet storage set, address value) internal view returns (bool) {
259         return _contains(set._inner, bytes32(uint256(uint160(value))));
260     }
261 
262     /**
263      * @dev Returns the number of values in the set. O(1).
264      */
265     function length(AddressSet storage set) internal view returns (uint256) {
266         return _length(set._inner);
267     }
268 
269     /**
270      * @dev Returns the value stored at position `index` in the set. O(1).
271      *
272      * Note that there are no guarantees on the ordering of values inside the
273      * array, and it may change when more values are added or removed.
274      *
275      * Requirements:
276      *
277      * - `index` must be strictly less than {length}.
278      */
279     function at(AddressSet storage set, uint256 index) internal view returns (address) {
280         return address(uint160(uint256(_at(set._inner, index))));
281     }
282 
283     /**
284      * @dev Return the entire set in an array
285      *
286      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
287      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
288      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
289      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
290      */
291     function values(AddressSet storage set) internal view returns (address[] memory) {
292         bytes32[] memory store = _values(set._inner);
293         address[] memory result;
294 
295         /// @solidity memory-safe-assembly
296         assembly {
297             result := store
298         }
299 
300         return result;
301     }
302 
303     // UintSet
304 
305     struct UintSet {
306         Set _inner;
307     }
308 
309     /**
310      * @dev Add a value to a set. O(1).
311      *
312      * Returns true if the value was added to the set, that is if it was not
313      * already present.
314      */
315     function add(UintSet storage set, uint256 value) internal returns (bool) {
316         return _add(set._inner, bytes32(value));
317     }
318 
319     /**
320      * @dev Removes a value from a set. O(1).
321      *
322      * Returns true if the value was removed from the set, that is if it was
323      * present.
324      */
325     function remove(UintSet storage set, uint256 value) internal returns (bool) {
326         return _remove(set._inner, bytes32(value));
327     }
328 
329     /**
330      * @dev Returns true if the value is in the set. O(1).
331      */
332     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
333         return _contains(set._inner, bytes32(value));
334     }
335 
336     /**
337      * @dev Returns the number of values in the set. O(1).
338      */
339     function length(UintSet storage set) internal view returns (uint256) {
340         return _length(set._inner);
341     }
342 
343     /**
344      * @dev Returns the value stored at position `index` in the set. O(1).
345      *
346      * Note that there are no guarantees on the ordering of values inside the
347      * array, and it may change when more values are added or removed.
348      *
349      * Requirements:
350      *
351      * - `index` must be strictly less than {length}.
352      */
353     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
354         return uint256(_at(set._inner, index));
355     }
356 
357     /**
358      * @dev Return the entire set in an array
359      *
360      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
361      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
362      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
363      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
364      */
365     function values(UintSet storage set) internal view returns (uint256[] memory) {
366         bytes32[] memory store = _values(set._inner);
367         uint256[] memory result;
368 
369         /// @solidity memory-safe-assembly
370         assembly {
371             result := store
372         }
373 
374         return result;
375     }
376 }
377 
378 /**
379  * @dev External interface of AccessControl declared to support ERC165 detection.
380  */
381 interface IAccessControl {
382     /**
383      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
384      *
385      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
386      * {RoleAdminChanged} not being emitted signaling this.
387      *
388      * _Available since v3.1._
389      */
390     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
391 
392     /**
393      * @dev Emitted when `account` is granted `role`.
394      *
395      * `sender` is the account that originated the contract call, an admin role
396      * bearer except when using {AccessControl-_setupRole}.
397      */
398     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
399 
400     /**
401      * @dev Emitted when `account` is revoked `role`.
402      *
403      * `sender` is the account that originated the contract call:
404      *   - if using `revokeRole`, it is the admin role bearer
405      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
406      */
407     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
408 
409     /**
410      * @dev Returns `true` if `account` has been granted `role`.
411      */
412     function hasRole(bytes32 role, address account) external view returns (bool);
413 
414     /**
415      * @dev Returns the admin role that controls `role`. See {grantRole} and
416      * {revokeRole}.
417      *
418      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
419      */
420     function getRoleAdmin(bytes32 role) external view returns (bytes32);
421 
422     /**
423      * @dev Grants `role` to `account`.
424      *
425      * If `account` had not been already granted `role`, emits a {RoleGranted}
426      * event.
427      *
428      * Requirements:
429      *
430      * - the caller must have ``role``'s admin role.
431      */
432     function grantRole(bytes32 role, address account) external;
433 
434     /**
435      * @dev Revokes `role` from `account`.
436      *
437      * If `account` had been granted `role`, emits a {RoleRevoked} event.
438      *
439      * Requirements:
440      *
441      * - the caller must have ``role``'s admin role.
442      */
443     function revokeRole(bytes32 role, address account) external;
444 
445     /**
446      * @dev Revokes `role` from the calling account.
447      *
448      * Roles are often managed via {grantRole} and {revokeRole}: this function's
449      * purpose is to provide a mechanism for accounts to lose their privileges
450      * if they are compromised (such as when a trusted device is misplaced).
451      *
452      * If the calling account had been granted `role`, emits a {RoleRevoked}
453      * event.
454      *
455      * Requirements:
456      *
457      * - the caller must be `account`.
458      */
459     function renounceRole(bytes32 role, address account) external;
460 }
461 
462 /**
463  * @dev Interface of the ERC165 standard, as defined in the
464  * https://eips.ethereum.org/EIPS/eip-165[EIP].
465  *
466  * Implementers can declare support of contract interfaces, which can then be
467  * queried by others ({ERC165Checker}).
468  *
469  * For an implementation, see {ERC165}.
470  */
471 interface IERC165 {
472     /**
473      * @dev Returns true if this contract implements the interface defined by
474      * `interfaceId`. See the corresponding
475      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
476      * to learn more about how these ids are created.
477      *
478      * This function call must use less than 30 000 gas.
479      */
480     function supportsInterface(bytes4 interfaceId) external view returns (bool);
481 }
482 
483 /**
484  * @dev Implementation of the {IERC165} interface.
485  *
486  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
487  * for the additional interface id that will be supported. For example:
488  *
489  * ```solidity
490  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
492  * }
493  * ```
494  *
495  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
496  */
497 abstract contract ERC165 is IERC165 {
498     /**
499      * @dev See {IERC165-supportsInterface}.
500      */
501     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502         return interfaceId == type(IERC165).interfaceId;
503     }
504 }
505 
506 /**
507  * @dev Provides information about the current execution context, including the
508  * sender of the transaction and its data. While these are generally available
509  * via msg.sender and msg.data, they should not be accessed in such a direct
510  * manner, since when dealing with meta-transactions the account sending and
511  * paying for execution may not be the actual sender (as far as an application
512  * is concerned).
513  *
514  * This contract is only required for intermediate, library-like contracts.
515  */
516 abstract contract Context {
517     function _msgSender() internal view virtual returns (address) {
518         return msg.sender;
519     }
520 
521     function _msgData() internal view virtual returns (bytes calldata) {
522         return msg.data;
523     }
524 }
525 
526 /**
527  * @dev Standard math utilities missing in the Solidity language.
528  */
529 library Math {
530     enum Rounding {
531         Down, // Toward negative infinity
532         Up, // Toward infinity
533         Zero // Toward zero
534     }
535 
536     /**
537      * @dev Returns the largest of two numbers.
538      */
539     function max(uint256 a, uint256 b) internal pure returns (uint256) {
540         return a > b ? a : b;
541     }
542 
543     /**
544      * @dev Returns the smallest of two numbers.
545      */
546     function min(uint256 a, uint256 b) internal pure returns (uint256) {
547         return a < b ? a : b;
548     }
549 
550     /**
551      * @dev Returns the average of two numbers. The result is rounded towards
552      * zero.
553      */
554     function average(uint256 a, uint256 b) internal pure returns (uint256) {
555         // (a + b) / 2 can overflow.
556         return (a & b) + (a ^ b) / 2;
557     }
558 
559     /**
560      * @dev Returns the ceiling of the division of two numbers.
561      *
562      * This differs from standard division with `/` in that it rounds up instead
563      * of rounding down.
564      */
565     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
566         // (a + b - 1) / b can overflow on addition, so we distribute.
567         return a == 0 ? 0 : (a - 1) / b + 1;
568     }
569 
570     /**
571      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
572      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
573      * with further edits by Uniswap Labs also under MIT license.
574      */
575     function mulDiv(
576         uint256 x,
577         uint256 y,
578         uint256 denominator
579     ) internal pure returns (uint256 result) {
580         unchecked {
581             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
582             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
583             // variables such that product = prod1 * 2^256 + prod0.
584             uint256 prod0; // Least significant 256 bits of the product
585             uint256 prod1; // Most significant 256 bits of the product
586             assembly {
587                 let mm := mulmod(x, y, not(0))
588                 prod0 := mul(x, y)
589                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
590             }
591 
592             // Handle non-overflow cases, 256 by 256 division.
593             if (prod1 == 0) {
594                 return prod0 / denominator;
595             }
596 
597             // Make sure the result is less than 2^256. Also prevents denominator == 0.
598             require(denominator > prod1);
599 
600             ///////////////////////////////////////////////
601             // 512 by 256 division.
602             ///////////////////////////////////////////////
603 
604             // Make division exact by subtracting the remainder from [prod1 prod0].
605             uint256 remainder;
606             assembly {
607                 // Compute remainder using mulmod.
608                 remainder := mulmod(x, y, denominator)
609 
610                 // Subtract 256 bit number from 512 bit number.
611                 prod1 := sub(prod1, gt(remainder, prod0))
612                 prod0 := sub(prod0, remainder)
613             }
614 
615             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
616             // See https://cs.stackexchange.com/q/138556/92363.
617 
618             // Does not overflow because the denominator cannot be zero at this stage in the function.
619             uint256 twos = denominator & (~denominator + 1);
620             assembly {
621                 // Divide denominator by twos.
622                 denominator := div(denominator, twos)
623 
624                 // Divide [prod1 prod0] by twos.
625                 prod0 := div(prod0, twos)
626 
627                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
628                 twos := add(div(sub(0, twos), twos), 1)
629             }
630 
631             // Shift in bits from prod1 into prod0.
632             prod0 |= prod1 * twos;
633 
634             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
635             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
636             // four bits. That is, denominator * inv = 1 mod 2^4.
637             uint256 inverse = (3 * denominator) ^ 2;
638 
639             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
640             // in modular arithmetic, doubling the correct bits in each step.
641             inverse *= 2 - denominator * inverse; // inverse mod 2^8
642             inverse *= 2 - denominator * inverse; // inverse mod 2^16
643             inverse *= 2 - denominator * inverse; // inverse mod 2^32
644             inverse *= 2 - denominator * inverse; // inverse mod 2^64
645             inverse *= 2 - denominator * inverse; // inverse mod 2^128
646             inverse *= 2 - denominator * inverse; // inverse mod 2^256
647 
648             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
649             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
650             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
651             // is no longer required.
652             result = prod0 * inverse;
653             return result;
654         }
655     }
656 
657     /**
658      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
659      */
660     function mulDiv(
661         uint256 x,
662         uint256 y,
663         uint256 denominator,
664         Rounding rounding
665     ) internal pure returns (uint256) {
666         uint256 result = mulDiv(x, y, denominator);
667         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
668             result += 1;
669         }
670         return result;
671     }
672 
673     /**
674      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
675      *
676      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
677      */
678     function sqrt(uint256 a) internal pure returns (uint256) {
679         if (a == 0) {
680             return 0;
681         }
682 
683         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
684         //
685         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
686         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
687         //
688         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
689         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
690         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
691         //
692         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
693         uint256 result = 1 << (log2(a) >> 1);
694 
695         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
696         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
697         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
698         // into the expected uint128 result.
699         unchecked {
700             result = (result + a / result) >> 1;
701             result = (result + a / result) >> 1;
702             result = (result + a / result) >> 1;
703             result = (result + a / result) >> 1;
704             result = (result + a / result) >> 1;
705             result = (result + a / result) >> 1;
706             result = (result + a / result) >> 1;
707             return min(result, a / result);
708         }
709     }
710 
711     /**
712      * @notice Calculates sqrt(a), following the selected rounding direction.
713      */
714     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
715         unchecked {
716             uint256 result = sqrt(a);
717             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
718         }
719     }
720 
721     /**
722      * @dev Return the log in base 2, rounded down, of a positive value.
723      * Returns 0 if given 0.
724      */
725     function log2(uint256 value) internal pure returns (uint256) {
726         uint256 result = 0;
727         unchecked {
728             if (value >> 128 > 0) {
729                 value >>= 128;
730                 result += 128;
731             }
732             if (value >> 64 > 0) {
733                 value >>= 64;
734                 result += 64;
735             }
736             if (value >> 32 > 0) {
737                 value >>= 32;
738                 result += 32;
739             }
740             if (value >> 16 > 0) {
741                 value >>= 16;
742                 result += 16;
743             }
744             if (value >> 8 > 0) {
745                 value >>= 8;
746                 result += 8;
747             }
748             if (value >> 4 > 0) {
749                 value >>= 4;
750                 result += 4;
751             }
752             if (value >> 2 > 0) {
753                 value >>= 2;
754                 result += 2;
755             }
756             if (value >> 1 > 0) {
757                 result += 1;
758             }
759         }
760         return result;
761     }
762 
763     /**
764      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
765      * Returns 0 if given 0.
766      */
767     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
768         unchecked {
769             uint256 result = log2(value);
770             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
771         }
772     }
773 
774     /**
775      * @dev Return the log in base 10, rounded down, of a positive value.
776      * Returns 0 if given 0.
777      */
778     function log10(uint256 value) internal pure returns (uint256) {
779         uint256 result = 0;
780         unchecked {
781             if (value >= 10**64) {
782                 value /= 10**64;
783                 result += 64;
784             }
785             if (value >= 10**32) {
786                 value /= 10**32;
787                 result += 32;
788             }
789             if (value >= 10**16) {
790                 value /= 10**16;
791                 result += 16;
792             }
793             if (value >= 10**8) {
794                 value /= 10**8;
795                 result += 8;
796             }
797             if (value >= 10**4) {
798                 value /= 10**4;
799                 result += 4;
800             }
801             if (value >= 10**2) {
802                 value /= 10**2;
803                 result += 2;
804             }
805             if (value >= 10**1) {
806                 result += 1;
807             }
808         }
809         return result;
810     }
811 
812     /**
813      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
814      * Returns 0 if given 0.
815      */
816     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
817         unchecked {
818             uint256 result = log10(value);
819             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
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
859     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
860         unchecked {
861             uint256 result = log256(value);
862             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
863         }
864     }
865 }
866 
867 /**
868  * @dev String operations.
869  */
870 library Strings {
871     bytes16 private constant _SYMBOLS = "0123456789abcdef";
872     uint8 private constant _ADDRESS_LENGTH = 20;
873 
874     /**
875      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
876      */
877     function toString(uint256 value) internal pure returns (string memory) {
878         unchecked {
879             uint256 length = Math.log10(value) + 1;
880             string memory buffer = new string(length);
881             uint256 ptr;
882             /// @solidity memory-safe-assembly
883             assembly {
884                 ptr := add(buffer, add(32, length))
885             }
886             while (true) {
887                 ptr--;
888                 /// @solidity memory-safe-assembly
889                 assembly {
890                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
891                 }
892                 value /= 10;
893                 if (value == 0) break;
894             }
895             return buffer;
896         }
897     }
898 
899     /**
900      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
901      */
902     function toHexString(uint256 value) internal pure returns (string memory) {
903         unchecked {
904             return toHexString(value, Math.log256(value) + 1);
905         }
906     }
907 
908     /**
909      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
910      */
911     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
912         bytes memory buffer = new bytes(2 * length + 2);
913         buffer[0] = "0";
914         buffer[1] = "x";
915         for (uint256 i = 2 * length + 1; i > 1; --i) {
916             buffer[i] = _SYMBOLS[value & 0xf];
917             value >>= 4;
918         }
919         require(value == 0, "Strings: hex length insufficient");
920         return string(buffer);
921     }
922 
923     /**
924      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
925      */
926     function toHexString(address addr) internal pure returns (string memory) {
927         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
928     }
929 }
930 
931 /**
932  * @dev Contract module that allows children to implement role-based access
933  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
934  * members except through off-chain means by accessing the contract event logs. Some
935  * applications may benefit from on-chain enumerability, for those cases see
936  * {AccessControlEnumerable}.
937  *
938  * Roles are referred to by their `bytes32` identifier. These should be exposed
939  * in the external API and be unique. The best way to achieve this is by
940  * using `public constant` hash digests:
941  *
942  * ```
943  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
944  * ```
945  *
946  * Roles can be used to represent a set of permissions. To restrict access to a
947  * function call, use {hasRole}:
948  *
949  * ```
950  * function foo() public {
951  *     require(hasRole(MY_ROLE, msg.sender));
952  *     ...
953  * }
954  * ```
955  *
956  * Roles can be granted and revoked dynamically via the {grantRole} and
957  * {revokeRole} functions. Each role has an associated admin role, and only
958  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
959  *
960  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
961  * that only accounts with this role will be able to grant or revoke other
962  * roles. More complex role relationships can be created by using
963  * {_setRoleAdmin}.
964  *
965  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
966  * grant and revoke this role. Extra precautions should be taken to secure
967  * accounts that have been granted it.
968  */
969 abstract contract AccessControl is Context, IAccessControl, ERC165 {
970     struct RoleData {
971         mapping(address => bool) members;
972         bytes32 adminRole;
973     }
974 
975     mapping(bytes32 => RoleData) private _roles;
976 
977     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
978 
979     /**
980      * @dev Modifier that checks that an account has a specific role. Reverts
981      * with a standardized message including the required role.
982      *
983      * The format of the revert reason is given by the following regular expression:
984      *
985      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
986      *
987      * _Available since v4.1._
988      */
989     modifier onlyRole(bytes32 role) {
990         _checkRole(role);
991         _;
992     }
993 
994     /**
995      * @dev See {IERC165-supportsInterface}.
996      */
997     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
998         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
999     }
1000 
1001     /**
1002      * @dev Returns `true` if `account` has been granted `role`.
1003      */
1004     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1005         return _roles[role].members[account];
1006     }
1007 
1008     /**
1009      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1010      * Overriding this function changes the behavior of the {onlyRole} modifier.
1011      *
1012      * Format of the revert message is described in {_checkRole}.
1013      *
1014      * _Available since v4.6._
1015      */
1016     function _checkRole(bytes32 role) internal view virtual {
1017         _checkRole(role, _msgSender());
1018     }
1019 
1020     /**
1021      * @dev Revert with a standard message if `account` is missing `role`.
1022      *
1023      * The format of the revert reason is given by the following regular expression:
1024      *
1025      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1026      */
1027     function _checkRole(bytes32 role, address account) internal view virtual {
1028         if (!hasRole(role, account)) {
1029             revert(
1030                 string(
1031                     abi.encodePacked(
1032                         "AccessControl: account ",
1033                         Strings.toHexString(account),
1034                         " is missing role ",
1035                         Strings.toHexString(uint256(role), 32)
1036                     )
1037                 )
1038             );
1039         }
1040     }
1041 
1042     /**
1043      * @dev Returns the admin role that controls `role`. See {grantRole} and
1044      * {revokeRole}.
1045      *
1046      * To change a role's admin, use {_setRoleAdmin}.
1047      */
1048     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1049         return _roles[role].adminRole;
1050     }
1051 
1052     /**
1053      * @dev Grants `role` to `account`.
1054      *
1055      * If `account` had not been already granted `role`, emits a {RoleGranted}
1056      * event.
1057      *
1058      * Requirements:
1059      *
1060      * - the caller must have ``role``'s admin role.
1061      *
1062      * May emit a {RoleGranted} event.
1063      */
1064     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1065         _grantRole(role, account);
1066     }
1067 
1068     /**
1069      * @dev Revokes `role` from `account`.
1070      *
1071      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1072      *
1073      * Requirements:
1074      *
1075      * - the caller must have ``role``'s admin role.
1076      *
1077      * May emit a {RoleRevoked} event.
1078      */
1079     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1080         _revokeRole(role, account);
1081     }
1082 
1083     /**
1084      * @dev Revokes `role` from the calling account.
1085      *
1086      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1087      * purpose is to provide a mechanism for accounts to lose their privileges
1088      * if they are compromised (such as when a trusted device is misplaced).
1089      *
1090      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1091      * event.
1092      *
1093      * Requirements:
1094      *
1095      * - the caller must be `account`.
1096      *
1097      * May emit a {RoleRevoked} event.
1098      */
1099     function renounceRole(bytes32 role, address account) public virtual override {
1100         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1101 
1102         _revokeRole(role, account);
1103     }
1104 
1105     /**
1106      * @dev Grants `role` to `account`.
1107      *
1108      * If `account` had not been already granted `role`, emits a {RoleGranted}
1109      * event. Note that unlike {grantRole}, this function doesn't perform any
1110      * checks on the calling account.
1111      *
1112      * May emit a {RoleGranted} event.
1113      *
1114      * [WARNING]
1115      * ====
1116      * This function should only be called from the constructor when setting
1117      * up the initial roles for the system.
1118      *
1119      * Using this function in any other way is effectively circumventing the admin
1120      * system imposed by {AccessControl}.
1121      * ====
1122      *
1123      * NOTE: This function is deprecated in favor of {_grantRole}.
1124      */
1125     function _setupRole(bytes32 role, address account) internal virtual {
1126         _grantRole(role, account);
1127     }
1128 
1129     /**
1130      * @dev Sets `adminRole` as ``role``'s admin role.
1131      *
1132      * Emits a {RoleAdminChanged} event.
1133      */
1134     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1135         bytes32 previousAdminRole = getRoleAdmin(role);
1136         _roles[role].adminRole = adminRole;
1137         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1138     }
1139 
1140     /**
1141      * @dev Grants `role` to `account`.
1142      *
1143      * Internal function without access restriction.
1144      *
1145      * May emit a {RoleGranted} event.
1146      */
1147     function _grantRole(bytes32 role, address account) internal virtual {
1148         if (!hasRole(role, account)) {
1149             _roles[role].members[account] = true;
1150             emit RoleGranted(role, account, _msgSender());
1151         }
1152     }
1153 
1154     /**
1155      * @dev Revokes `role` from `account`.
1156      *
1157      * Internal function without access restriction.
1158      *
1159      * May emit a {RoleRevoked} event.
1160      */
1161     function _revokeRole(bytes32 role, address account) internal virtual {
1162         if (hasRole(role, account)) {
1163             _roles[role].members[account] = false;
1164             emit RoleRevoked(role, account, _msgSender());
1165         }
1166     }
1167 }
1168 
1169 /**
1170  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1171  */
1172 interface IAccessControlEnumerable is IAccessControl {
1173     /**
1174      * @dev Returns one of the accounts that have `role`. `index` must be a
1175      * value between 0 and {getRoleMemberCount}, non-inclusive.
1176      *
1177      * Role bearers are not sorted in any particular way, and their ordering may
1178      * change at any point.
1179      *
1180      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1181      * you perform all queries on the same block. See the following
1182      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1183      * for more information.
1184      */
1185     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1186 
1187     /**
1188      * @dev Returns the number of accounts that have `role`. Can be used
1189      * together with {getRoleMember} to enumerate all bearers of a role.
1190      */
1191     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1192 }
1193 
1194 /**
1195  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1196  */
1197 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1198     using EnumerableSet for EnumerableSet.AddressSet;
1199 
1200     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1201 
1202     /**
1203      * @dev See {IERC165-supportsInterface}.
1204      */
1205     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1206         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1207     }
1208 
1209     /**
1210      * @dev Returns one of the accounts that have `role`. `index` must be a
1211      * value between 0 and {getRoleMemberCount}, non-inclusive.
1212      *
1213      * Role bearers are not sorted in any particular way, and their ordering may
1214      * change at any point.
1215      *
1216      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1217      * you perform all queries on the same block. See the following
1218      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1219      * for more information.
1220      */
1221     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1222         return _roleMembers[role].at(index);
1223     }
1224 
1225     /**
1226      * @dev Returns the number of accounts that have `role`. Can be used
1227      * together with {getRoleMember} to enumerate all bearers of a role.
1228      */
1229     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1230         return _roleMembers[role].length();
1231     }
1232 
1233     /**
1234      * @dev Overload {_grantRole} to track enumerable memberships
1235      */
1236     function _grantRole(bytes32 role, address account) internal virtual override {
1237         super._grantRole(role, account);
1238         _roleMembers[role].add(account);
1239     }
1240 
1241     /**
1242      * @dev Overload {_revokeRole} to track enumerable memberships
1243      */
1244     function _revokeRole(bytes32 role, address account) internal virtual override {
1245         super._revokeRole(role, account);
1246         _roleMembers[role].remove(account);
1247     }
1248 }
1249 
1250 /**
1251  * @dev Interface of the ERC20 standard as defined in the EIP.
1252  */
1253 interface IERC20 {
1254     /**
1255      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1256      * another (`to`).
1257      *
1258      * Note that `value` may be zero.
1259      */
1260     event Transfer(address indexed from, address indexed to, uint256 value);
1261 
1262     /**
1263      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1264      * a call to {approve}. `value` is the new allowance.
1265      */
1266     event Approval(address indexed owner, address indexed spender, uint256 value);
1267 
1268     /**
1269      * @dev Returns the amount of tokens in existence.
1270      */
1271     function totalSupply() external view returns (uint256);
1272 
1273     /**
1274      * @dev Returns the amount of tokens owned by `account`.
1275      */
1276     function balanceOf(address account) external view returns (uint256);
1277 
1278     /**
1279      * @dev Moves `amount` tokens from the caller's account to `to`.
1280      *
1281      * Returns a boolean value indicating whether the operation succeeded.
1282      *
1283      * Emits a {Transfer} event.
1284      */
1285     function transfer(address to, uint256 amount) external returns (bool);
1286 
1287     /**
1288      * @dev Returns the remaining number of tokens that `spender` will be
1289      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1290      * zero by default.
1291      *
1292      * This value changes when {approve} or {transferFrom} are called.
1293      */
1294     function allowance(address owner, address spender) external view returns (uint256);
1295 
1296     /**
1297      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1298      *
1299      * Returns a boolean value indicating whether the operation succeeded.
1300      *
1301      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1302      * that someone may use both the old and the new allowance by unfortunate
1303      * transaction ordering. One possible solution to mitigate this race
1304      * condition is to first reduce the spender's allowance to 0 and set the
1305      * desired value afterwards:
1306      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1307      *
1308      * Emits an {Approval} event.
1309      */
1310     function approve(address spender, uint256 amount) external returns (bool);
1311 
1312     /**
1313      * @dev Moves `amount` tokens from `from` to `to` using the
1314      * allowance mechanism. `amount` is then deducted from the caller's
1315      * allowance.
1316      *
1317      * Returns a boolean value indicating whether the operation succeeded.
1318      *
1319      * Emits a {Transfer} event.
1320      */
1321     function transferFrom(
1322         address from,
1323         address to,
1324         uint256 amount
1325     ) external returns (bool);
1326 }
1327 
1328 /**
1329  * @dev Interface for the optional metadata functions from the ERC20 standard.
1330  *
1331  * _Available since v4.1._
1332  */
1333 interface IERC20Metadata is IERC20 {
1334     /**
1335      * @dev Returns the name of the token.
1336      */
1337     function name() external view returns (string memory);
1338 
1339     /**
1340      * @dev Returns the symbol of the token.
1341      */
1342     function symbol() external view returns (string memory);
1343 
1344     /**
1345      * @dev Returns the decimals places of the token.
1346      */
1347     function decimals() external view returns (uint8);
1348 }
1349 
1350 /**
1351  * @dev Implementation of the {IERC20} interface.
1352  *
1353  * This implementation is agnostic to the way tokens are created. This means
1354  * that a supply mechanism has to be added in a derived contract using {_mint}.
1355  * For a generic mechanism see {ERC20PresetMinterPauser}.
1356  *
1357  * TIP: For a detailed writeup see our guide
1358  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1359  * to implement supply mechanisms].
1360  *
1361  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1362  * instead returning `false` on failure. This behavior is nonetheless
1363  * conventional and does not conflict with the expectations of ERC20
1364  * applications.
1365  *
1366  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1367  * This allows applications to reconstruct the allowance for all accounts just
1368  * by listening to said events. Other implementations of the EIP may not emit
1369  * these events, as it isn't required by the specification.
1370  *
1371  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1372  * functions have been added to mitigate the well-known issues around setting
1373  * allowances. See {IERC20-approve}.
1374  */
1375 contract ERC20 is Context, IERC20, IERC20Metadata {
1376     mapping(address => uint256) private _balances;
1377 
1378     mapping(address => mapping(address => uint256)) private _allowances;
1379 
1380     uint256 private _totalSupply;
1381 
1382     string private _name;
1383     string private _symbol;
1384 
1385     /**
1386      * @dev Sets the values for {name} and {symbol}.
1387      *
1388      * The default value of {decimals} is 18. To select a different value for
1389      * {decimals} you should overload it.
1390      *
1391      * All two of these values are immutable: they can only be set once during
1392      * construction.
1393      */
1394     constructor(string memory name_, string memory symbol_) {
1395         _name = name_;
1396         _symbol = symbol_;
1397     }
1398 
1399     /**
1400      * @dev Returns the name of the token.
1401      */
1402     function name() public view virtual override returns (string memory) {
1403         return _name;
1404     }
1405 
1406     /**
1407      * @dev Returns the symbol of the token, usually a shorter version of the
1408      * name.
1409      */
1410     function symbol() public view virtual override returns (string memory) {
1411         return _symbol;
1412     }
1413 
1414     /**
1415      * @dev Returns the number of decimals used to get its user representation.
1416      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1417      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1418      *
1419      * Tokens usually opt for a value of 18, imitating the relationship between
1420      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1421      * overridden;
1422      *
1423      * NOTE: This information is only used for _display_ purposes: it in
1424      * no way affects any of the arithmetic of the contract, including
1425      * {IERC20-balanceOf} and {IERC20-transfer}.
1426      */
1427     function decimals() public view virtual override returns (uint8) {
1428         return 18;
1429     }
1430 
1431     /**
1432      * @dev See {IERC20-totalSupply}.
1433      */
1434     function totalSupply() public view virtual override returns (uint256) {
1435         return _totalSupply;
1436     }
1437 
1438     /**
1439      * @dev See {IERC20-balanceOf}.
1440      */
1441     function balanceOf(address account) public view virtual override returns (uint256) {
1442         return _balances[account];
1443     }
1444 
1445     /**
1446      * @dev See {IERC20-transfer}.
1447      *
1448      * Requirements:
1449      *
1450      * - `to` cannot be the zero address.
1451      * - the caller must have a balance of at least `amount`.
1452      */
1453     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1454         address owner = _msgSender();
1455         _transfer(owner, to, amount);
1456         return true;
1457     }
1458 
1459     /**
1460      * @dev See {IERC20-allowance}.
1461      */
1462     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1463         return _allowances[owner][spender];
1464     }
1465 
1466     /**
1467      * @dev See {IERC20-approve}.
1468      *
1469      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1470      * `transferFrom`. This is semantically equivalent to an infinite approval.
1471      *
1472      * Requirements:
1473      *
1474      * - `spender` cannot be the zero address.
1475      */
1476     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1477         address owner = _msgSender();
1478         _approve(owner, spender, amount);
1479         return true;
1480     }
1481 
1482     /**
1483      * @dev See {IERC20-transferFrom}.
1484      *
1485      * Emits an {Approval} event indicating the updated allowance. This is not
1486      * required by the EIP. See the note at the beginning of {ERC20}.
1487      *
1488      * NOTE: Does not update the allowance if the current allowance
1489      * is the maximum `uint256`.
1490      *
1491      * Requirements:
1492      *
1493      * - `from` and `to` cannot be the zero address.
1494      * - `from` must have a balance of at least `amount`.
1495      * - the caller must have allowance for ``from``'s tokens of at least
1496      * `amount`.
1497      */
1498     function transferFrom(
1499         address from,
1500         address to,
1501         uint256 amount
1502     ) public virtual override returns (bool) {
1503         address spender = _msgSender();
1504         _spendAllowance(from, spender, amount);
1505         _transfer(from, to, amount);
1506         return true;
1507     }
1508 
1509     /**
1510      * @dev Atomically increases the allowance granted to `spender` by the caller.
1511      *
1512      * This is an alternative to {approve} that can be used as a mitigation for
1513      * problems described in {IERC20-approve}.
1514      *
1515      * Emits an {Approval} event indicating the updated allowance.
1516      *
1517      * Requirements:
1518      *
1519      * - `spender` cannot be the zero address.
1520      */
1521     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1522         address owner = _msgSender();
1523         _approve(owner, spender, allowance(owner, spender) + addedValue);
1524         return true;
1525     }
1526 
1527     /**
1528      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1529      *
1530      * This is an alternative to {approve} that can be used as a mitigation for
1531      * problems described in {IERC20-approve}.
1532      *
1533      * Emits an {Approval} event indicating the updated allowance.
1534      *
1535      * Requirements:
1536      *
1537      * - `spender` cannot be the zero address.
1538      * - `spender` must have allowance for the caller of at least
1539      * `subtractedValue`.
1540      */
1541     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1542         address owner = _msgSender();
1543         uint256 currentAllowance = allowance(owner, spender);
1544         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1545         unchecked {
1546             _approve(owner, spender, currentAllowance - subtractedValue);
1547         }
1548 
1549         return true;
1550     }
1551 
1552     /**
1553      * @dev Moves `amount` of tokens from `from` to `to`.
1554      *
1555      * This internal function is equivalent to {transfer}, and can be used to
1556      * e.g. implement automatic token fees, slashing mechanisms, etc.
1557      *
1558      * Emits a {Transfer} event.
1559      *
1560      * Requirements:
1561      *
1562      * - `from` cannot be the zero address.
1563      * - `to` cannot be the zero address.
1564      * - `from` must have a balance of at least `amount`.
1565      */
1566     function _transfer(
1567         address from,
1568         address to,
1569         uint256 amount
1570     ) internal virtual {
1571         require(from != address(0), "ERC20: transfer from the zero address");
1572         require(to != address(0), "ERC20: transfer to the zero address");
1573 
1574         _beforeTokenTransfer(from, to, amount);
1575 
1576         uint256 fromBalance = _balances[from];
1577         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1578         unchecked {
1579             _balances[from] = fromBalance - amount;
1580             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1581             // decrementing then incrementing.
1582             _balances[to] += amount;
1583         }
1584 
1585         emit Transfer(from, to, amount);
1586 
1587         _afterTokenTransfer(from, to, amount);
1588     }
1589 
1590     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1591      * the total supply.
1592      *
1593      * Emits a {Transfer} event with `from` set to the zero address.
1594      *
1595      * Requirements:
1596      *
1597      * - `account` cannot be the zero address.
1598      */
1599     function _mint(address account, uint256 amount) internal virtual {
1600         require(account != address(0), "ERC20: mint to the zero address");
1601 
1602         _beforeTokenTransfer(address(0), account, amount);
1603 
1604         _totalSupply += amount;
1605         unchecked {
1606             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1607             _balances[account] += amount;
1608         }
1609         emit Transfer(address(0), account, amount);
1610 
1611         _afterTokenTransfer(address(0), account, amount);
1612     }
1613 
1614     /**
1615      * @dev Destroys `amount` tokens from `account`, reducing the
1616      * total supply.
1617      *
1618      * Emits a {Transfer} event with `to` set to the zero address.
1619      *
1620      * Requirements:
1621      *
1622      * - `account` cannot be the zero address.
1623      * - `account` must have at least `amount` tokens.
1624      */
1625     function _burn(address account, uint256 amount) internal virtual {
1626         require(account != address(0), "ERC20: burn from the zero address");
1627 
1628         _beforeTokenTransfer(account, address(0), amount);
1629 
1630         uint256 accountBalance = _balances[account];
1631         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1632         unchecked {
1633             _balances[account] = accountBalance - amount;
1634             // Overflow not possible: amount <= accountBalance <= totalSupply.
1635             _totalSupply -= amount;
1636         }
1637 
1638         emit Transfer(account, address(0), amount);
1639 
1640         _afterTokenTransfer(account, address(0), amount);
1641     }
1642 
1643     /**
1644      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1645      *
1646      * This internal function is equivalent to `approve`, and can be used to
1647      * e.g. set automatic allowances for certain subsystems, etc.
1648      *
1649      * Emits an {Approval} event.
1650      *
1651      * Requirements:
1652      *
1653      * - `owner` cannot be the zero address.
1654      * - `spender` cannot be the zero address.
1655      */
1656     function _approve(
1657         address owner,
1658         address spender,
1659         uint256 amount
1660     ) internal virtual {
1661         require(owner != address(0), "ERC20: approve from the zero address");
1662         require(spender != address(0), "ERC20: approve to the zero address");
1663 
1664         _allowances[owner][spender] = amount;
1665         emit Approval(owner, spender, amount);
1666     }
1667 
1668     /**
1669      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1670      *
1671      * Does not update the allowance amount in case of infinite allowance.
1672      * Revert if not enough allowance is available.
1673      *
1674      * Might emit an {Approval} event.
1675      */
1676     function _spendAllowance(
1677         address owner,
1678         address spender,
1679         uint256 amount
1680     ) internal virtual {
1681         uint256 currentAllowance = allowance(owner, spender);
1682         if (currentAllowance != type(uint256).max) {
1683             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1684             unchecked {
1685                 _approve(owner, spender, currentAllowance - amount);
1686             }
1687         }
1688     }
1689 
1690     /**
1691      * @dev Hook that is called before any transfer of tokens. This includes
1692      * minting and burning.
1693      *
1694      * Calling conditions:
1695      *
1696      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1697      * will be transferred to `to`.
1698      * - when `from` is zero, `amount` tokens will be minted for `to`.
1699      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1700      * - `from` and `to` are never both zero.
1701      *
1702      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1703      */
1704     function _beforeTokenTransfer(
1705         address from,
1706         address to,
1707         uint256 amount
1708     ) internal virtual {}
1709 
1710     /**
1711      * @dev Hook that is called after any transfer of tokens. This includes
1712      * minting and burning.
1713      *
1714      * Calling conditions:
1715      *
1716      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1717      * has been transferred to `to`.
1718      * - when `from` is zero, `amount` tokens have been minted for `to`.
1719      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1720      * - `from` and `to` are never both zero.
1721      *
1722      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1723      */
1724     function _afterTokenTransfer(
1725         address from,
1726         address to,
1727         uint256 amount
1728     ) internal virtual {}
1729 }
1730 
1731 /**
1732  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1733  * tokens and those that they have an allowance for, in a way that can be
1734  * recognized off-chain (via event analysis).
1735  */
1736 abstract contract ERC20Burnable is Context, ERC20 {
1737     /**
1738      * @dev Destroys `amount` tokens from the caller.
1739      *
1740      * See {ERC20-_burn}.
1741      */
1742     function burn(uint256 amount) public virtual {
1743         _burn(_msgSender(), amount);
1744     }
1745 
1746     /**
1747      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1748      * allowance.
1749      *
1750      * See {ERC20-_burn} and {ERC20-allowance}.
1751      *
1752      * Requirements:
1753      *
1754      * - the caller must have allowance for ``accounts``'s tokens of at least
1755      * `amount`.
1756      */
1757     function burnFrom(address account, uint256 amount) public virtual {
1758         _spendAllowance(account, _msgSender(), amount);
1759         _burn(account, amount);
1760     }
1761 }
1762 
1763 contract POM is ERC20Burnable, AccessControlEnumerable {
1764     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1765 
1766     constructor(address _admin, string memory _name, string memory _symbol) ERC20(_name, _symbol) {
1767         _setupRole(DEFAULT_ADMIN_ROLE, _admin);
1768         _setupRole(MINTER_ROLE, _admin);
1769     }
1770 
1771     function grantMinterRole(address account) public {
1772         grantRole(MINTER_ROLE, account);
1773     }
1774 
1775     function revokeMinterRole(address account) public {
1776         revokeRole(MINTER_ROLE, account);
1777     }
1778 
1779     function mint(address to, uint256 amount) public {
1780         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1781         _mint(to, amount);
1782     }
1783 }