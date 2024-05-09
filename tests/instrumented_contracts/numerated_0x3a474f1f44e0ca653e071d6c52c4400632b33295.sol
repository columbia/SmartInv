1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Library for managing
11  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
12  * types.
13  *
14  * Sets have the following properties:
15  *
16  * - Elements are added, removed, and checked for existence in constant time
17  * (O(1)).
18  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
19  *
20  * ```
21  * contract Example {
22  *     // Add the library methods
23  *     using EnumerableSet for EnumerableSet.AddressSet;
24  *
25  *     // Declare a set state variable
26  *     EnumerableSet.AddressSet private mySet;
27  * }
28  * ```
29  *
30  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
31  * and `uint256` (`UintSet`) are supported.
32  */
33 library EnumerableSet {
34     // To implement this library for multiple types with as little code
35     // repetition as possible, we write it in terms of a generic Set type with
36     // bytes32 values.
37     // The Set implementation uses private functions, and user-facing
38     // implementations (such as AddressSet) are just wrappers around the
39     // underlying Set.
40     // This means that we can only create new EnumerableSets for types that fit
41     // in bytes32.
42 
43     struct Set {
44         // Storage of set values
45         bytes32[] _values;
46         // Position of the value in the `values` array, plus 1 because index 0
47         // means a value is not in the set.
48         mapping(bytes32 => uint256) _indexes;
49     }
50 
51     /**
52      * @dev Add a value to a set. O(1).
53      *
54      * Returns true if the value was added to the set, that is if it was not
55      * already present.
56      */
57     function _add(Set storage set, bytes32 value) private returns (bool) {
58         if (!_contains(set, value)) {
59             set._values.push(value);
60             // The value is stored at length-1, but we add 1 to all indexes
61             // and use 0 as a sentinel value
62             set._indexes[value] = set._values.length;
63             return true;
64         } else {
65             return false;
66         }
67     }
68 
69     /**
70      * @dev Removes a value from a set. O(1).
71      *
72      * Returns true if the value was removed from the set, that is if it was
73      * present.
74      */
75     function _remove(Set storage set, bytes32 value) private returns (bool) {
76         // We read and store the value's index to prevent multiple reads from the same storage slot
77         uint256 valueIndex = set._indexes[value];
78 
79         if (valueIndex != 0) {
80             // Equivalent to contains(set, value)
81             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
82             // the array, and then remove the last element (sometimes called as 'swap and pop').
83             // This modifies the order of the array, as noted in {at}.
84 
85             uint256 toDeleteIndex = valueIndex - 1;
86             uint256 lastIndex = set._values.length - 1;
87 
88             if (lastIndex != toDeleteIndex) {
89                 bytes32 lastvalue = set._values[lastIndex];
90 
91                 // Move the last value to the index where the value to delete is
92                 set._values[toDeleteIndex] = lastvalue;
93                 // Update the index for the moved value
94                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
95             }
96 
97             // Delete the slot where the moved value was stored
98             set._values.pop();
99 
100             // Delete the index for the deleted slot
101             delete set._indexes[value];
102 
103             return true;
104         } else {
105             return false;
106         }
107     }
108 
109     /**
110      * @dev Returns true if the value is in the set. O(1).
111      */
112     function _contains(Set storage set, bytes32 value) private view returns (bool) {
113         return set._indexes[value] != 0;
114     }
115 
116     /**
117      * @dev Returns the number of values on the set. O(1).
118      */
119     function _length(Set storage set) private view returns (uint256) {
120         return set._values.length;
121     }
122 
123     /**
124      * @dev Returns the value stored at position `index` in the set. O(1).
125      *
126      * Note that there are no guarantees on the ordering of values inside the
127      * array, and it may change when more values are added or removed.
128      *
129      * Requirements:
130      *
131      * - `index` must be strictly less than {length}.
132      */
133     function _at(Set storage set, uint256 index) private view returns (bytes32) {
134         return set._values[index];
135     }
136 
137     /**
138      * @dev Return the entire set in an array
139      *
140      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
141      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
142      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
143      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
144      */
145     function _values(Set storage set) private view returns (bytes32[] memory) {
146         return set._values;
147     }
148 
149     // Bytes32Set
150 
151     struct Bytes32Set {
152         Set _inner;
153     }
154 
155     /**
156      * @dev Add a value to a set. O(1).
157      *
158      * Returns true if the value was added to the set, that is if it was not
159      * already present.
160      */
161     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
162         return _add(set._inner, value);
163     }
164 
165     /**
166      * @dev Removes a value from a set. O(1).
167      *
168      * Returns true if the value was removed from the set, that is if it was
169      * present.
170      */
171     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
172         return _remove(set._inner, value);
173     }
174 
175     /**
176      * @dev Returns true if the value is in the set. O(1).
177      */
178     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
179         return _contains(set._inner, value);
180     }
181 
182     /**
183      * @dev Returns the number of values in the set. O(1).
184      */
185     function length(Bytes32Set storage set) internal view returns (uint256) {
186         return _length(set._inner);
187     }
188 
189     /**
190      * @dev Returns the value stored at position `index` in the set. O(1).
191      *
192      * Note that there are no guarantees on the ordering of values inside the
193      * array, and it may change when more values are added or removed.
194      *
195      * Requirements:
196      *
197      * - `index` must be strictly less than {length}.
198      */
199     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
200         return _at(set._inner, index);
201     }
202 
203     /**
204      * @dev Return the entire set in an array
205      *
206      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
207      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
208      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
209      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
210      */
211     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
212         return _values(set._inner);
213     }
214 
215     // AddressSet
216 
217     struct AddressSet {
218         Set _inner;
219     }
220 
221     /**
222      * @dev Add a value to a set. O(1).
223      *
224      * Returns true if the value was added to the set, that is if it was not
225      * already present.
226      */
227     function add(AddressSet storage set, address value) internal returns (bool) {
228         return _add(set._inner, bytes32(uint256(uint160(value))));
229     }
230 
231     /**
232      * @dev Removes a value from a set. O(1).
233      *
234      * Returns true if the value was removed from the set, that is if it was
235      * present.
236      */
237     function remove(AddressSet storage set, address value) internal returns (bool) {
238         return _remove(set._inner, bytes32(uint256(uint160(value))));
239     }
240 
241     /**
242      * @dev Returns true if the value is in the set. O(1).
243      */
244     function contains(AddressSet storage set, address value) internal view returns (bool) {
245         return _contains(set._inner, bytes32(uint256(uint160(value))));
246     }
247 
248     /**
249      * @dev Returns the number of values in the set. O(1).
250      */
251     function length(AddressSet storage set) internal view returns (uint256) {
252         return _length(set._inner);
253     }
254 
255     /**
256      * @dev Returns the value stored at position `index` in the set. O(1).
257      *
258      * Note that there are no guarantees on the ordering of values inside the
259      * array, and it may change when more values are added or removed.
260      *
261      * Requirements:
262      *
263      * - `index` must be strictly less than {length}.
264      */
265     function at(AddressSet storage set, uint256 index) internal view returns (address) {
266         return address(uint160(uint256(_at(set._inner, index))));
267     }
268 
269     /**
270      * @dev Return the entire set in an array
271      *
272      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
273      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
274      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
275      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
276      */
277     function values(AddressSet storage set) internal view returns (address[] memory) {
278         bytes32[] memory store = _values(set._inner);
279         address[] memory result;
280 
281         assembly {
282             result := store
283         }
284 
285         return result;
286     }
287 
288     // UintSet
289 
290     struct UintSet {
291         Set _inner;
292     }
293 
294     /**
295      * @dev Add a value to a set. O(1).
296      *
297      * Returns true if the value was added to the set, that is if it was not
298      * already present.
299      */
300     function add(UintSet storage set, uint256 value) internal returns (bool) {
301         return _add(set._inner, bytes32(value));
302     }
303 
304     /**
305      * @dev Removes a value from a set. O(1).
306      *
307      * Returns true if the value was removed from the set, that is if it was
308      * present.
309      */
310     function remove(UintSet storage set, uint256 value) internal returns (bool) {
311         return _remove(set._inner, bytes32(value));
312     }
313 
314     /**
315      * @dev Returns true if the value is in the set. O(1).
316      */
317     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
318         return _contains(set._inner, bytes32(value));
319     }
320 
321     /**
322      * @dev Returns the number of values on the set. O(1).
323      */
324     function length(UintSet storage set) internal view returns (uint256) {
325         return _length(set._inner);
326     }
327 
328     /**
329      * @dev Returns the value stored at position `index` in the set. O(1).
330      *
331      * Note that there are no guarantees on the ordering of values inside the
332      * array, and it may change when more values are added or removed.
333      *
334      * Requirements:
335      *
336      * - `index` must be strictly less than {length}.
337      */
338     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
339         return uint256(_at(set._inner, index));
340     }
341 
342     /**
343      * @dev Return the entire set in an array
344      *
345      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
346      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
347      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
348      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
349      */
350     function values(UintSet storage set) internal view returns (uint256[] memory) {
351         bytes32[] memory store = _values(set._inner);
352         uint256[] memory result;
353 
354         assembly {
355             result := store
356         }
357 
358         return result;
359     }
360 }
361 
362 // File: @openzeppelin/contracts/utils/Counters.sol
363 
364 
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @title Counters
370  * @author Matt Condon (@shrugs)
371  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
372  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
373  *
374  * Include with `using Counters for Counters.Counter;`
375  */
376 library Counters {
377     struct Counter {
378         // This variable should never be directly accessed by users of the library: interactions must be restricted to
379         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
380         // this feature: see https://github.com/ethereum/solidity/issues/4637
381         uint256 _value; // default: 0
382     }
383 
384     function current(Counter storage counter) internal view returns (uint256) {
385         return counter._value;
386     }
387 
388     function increment(Counter storage counter) internal {
389         unchecked {
390             counter._value += 1;
391         }
392     }
393 
394     function decrement(Counter storage counter) internal {
395         uint256 value = counter._value;
396         require(value > 0, "Counter: decrement overflow");
397         unchecked {
398             counter._value = value - 1;
399         }
400     }
401 
402     function reset(Counter storage counter) internal {
403         counter._value = 0;
404     }
405 }
406 
407 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
408 
409 
410 
411 pragma solidity ^0.8.0;
412 
413 // CAUTION
414 // This version of SafeMath should only be used with Solidity 0.8 or later,
415 // because it relies on the compiler's built in overflow checks.
416 
417 /**
418  * @dev Wrappers over Solidity's arithmetic operations.
419  *
420  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
421  * now has built in overflow checking.
422  */
423 library SafeMath {
424     /**
425      * @dev Returns the addition of two unsigned integers, with an overflow flag.
426      *
427      * _Available since v3.4._
428      */
429     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
430         unchecked {
431             uint256 c = a + b;
432             if (c < a) return (false, 0);
433             return (true, c);
434         }
435     }
436 
437     /**
438      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
439      *
440      * _Available since v3.4._
441      */
442     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
443         unchecked {
444             if (b > a) return (false, 0);
445             return (true, a - b);
446         }
447     }
448 
449     /**
450      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
451      *
452      * _Available since v3.4._
453      */
454     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
455         unchecked {
456             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
457             // benefit is lost if 'b' is also tested.
458             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
459             if (a == 0) return (true, 0);
460             uint256 c = a * b;
461             if (c / a != b) return (false, 0);
462             return (true, c);
463         }
464     }
465 
466     /**
467      * @dev Returns the division of two unsigned integers, with a division by zero flag.
468      *
469      * _Available since v3.4._
470      */
471     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
472         unchecked {
473             if (b == 0) return (false, 0);
474             return (true, a / b);
475         }
476     }
477 
478     /**
479      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
480      *
481      * _Available since v3.4._
482      */
483     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
484         unchecked {
485             if (b == 0) return (false, 0);
486             return (true, a % b);
487         }
488     }
489 
490     /**
491      * @dev Returns the addition of two unsigned integers, reverting on
492      * overflow.
493      *
494      * Counterpart to Solidity's `+` operator.
495      *
496      * Requirements:
497      *
498      * - Addition cannot overflow.
499      */
500     function add(uint256 a, uint256 b) internal pure returns (uint256) {
501         return a + b;
502     }
503 
504     /**
505      * @dev Returns the subtraction of two unsigned integers, reverting on
506      * overflow (when the result is negative).
507      *
508      * Counterpart to Solidity's `-` operator.
509      *
510      * Requirements:
511      *
512      * - Subtraction cannot overflow.
513      */
514     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
515         return a - b;
516     }
517 
518     /**
519      * @dev Returns the multiplication of two unsigned integers, reverting on
520      * overflow.
521      *
522      * Counterpart to Solidity's `*` operator.
523      *
524      * Requirements:
525      *
526      * - Multiplication cannot overflow.
527      */
528     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
529         return a * b;
530     }
531 
532     /**
533      * @dev Returns the integer division of two unsigned integers, reverting on
534      * division by zero. The result is rounded towards zero.
535      *
536      * Counterpart to Solidity's `/` operator.
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function div(uint256 a, uint256 b) internal pure returns (uint256) {
543         return a / b;
544     }
545 
546     /**
547      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
548      * reverting when dividing by zero.
549      *
550      * Counterpart to Solidity's `%` operator. This function uses a `revert`
551      * opcode (which leaves remaining gas untouched) while Solidity uses an
552      * invalid opcode to revert (consuming all remaining gas).
553      *
554      * Requirements:
555      *
556      * - The divisor cannot be zero.
557      */
558     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
559         return a % b;
560     }
561 
562     /**
563      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
564      * overflow (when the result is negative).
565      *
566      * CAUTION: This function is deprecated because it requires allocating memory for the error
567      * message unnecessarily. For custom revert reasons use {trySub}.
568      *
569      * Counterpart to Solidity's `-` operator.
570      *
571      * Requirements:
572      *
573      * - Subtraction cannot overflow.
574      */
575     function sub(
576         uint256 a,
577         uint256 b,
578         string memory errorMessage
579     ) internal pure returns (uint256) {
580         unchecked {
581             require(b <= a, errorMessage);
582             return a - b;
583         }
584     }
585 
586     /**
587      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
588      * division by zero. The result is rounded towards zero.
589      *
590      * Counterpart to Solidity's `/` operator. Note: this function uses a
591      * `revert` opcode (which leaves remaining gas untouched) while Solidity
592      * uses an invalid opcode to revert (consuming all remaining gas).
593      *
594      * Requirements:
595      *
596      * - The divisor cannot be zero.
597      */
598     function div(
599         uint256 a,
600         uint256 b,
601         string memory errorMessage
602     ) internal pure returns (uint256) {
603         unchecked {
604             require(b > 0, errorMessage);
605             return a / b;
606         }
607     }
608 
609     /**
610      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
611      * reverting with custom message when dividing by zero.
612      *
613      * CAUTION: This function is deprecated because it requires allocating memory for the error
614      * message unnecessarily. For custom revert reasons use {tryMod}.
615      *
616      * Counterpart to Solidity's `%` operator. This function uses a `revert`
617      * opcode (which leaves remaining gas untouched) while Solidity uses an
618      * invalid opcode to revert (consuming all remaining gas).
619      *
620      * Requirements:
621      *
622      * - The divisor cannot be zero.
623      */
624     function mod(
625         uint256 a,
626         uint256 b,
627         string memory errorMessage
628     ) internal pure returns (uint256) {
629         unchecked {
630             require(b > 0, errorMessage);
631             return a % b;
632         }
633     }
634 }
635 
636 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
637 
638 
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @dev Contract module that helps prevent reentrant calls to a function.
644  *
645  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
646  * available, which can be applied to functions to make sure there are no nested
647  * (reentrant) calls to them.
648  *
649  * Note that because there is a single `nonReentrant` guard, functions marked as
650  * `nonReentrant` may not call one another. This can be worked around by making
651  * those functions `private`, and then adding `external` `nonReentrant` entry
652  * points to them.
653  *
654  * TIP: If you would like to learn more about reentrancy and alternative ways
655  * to protect against it, check out our blog post
656  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
657  */
658 abstract contract ReentrancyGuard {
659     // Booleans are more expensive than uint256 or any type that takes up a full
660     // word because each write operation emits an extra SLOAD to first read the
661     // slot's contents, replace the bits taken up by the boolean, and then write
662     // back. This is the compiler's defense against contract upgrades and
663     // pointer aliasing, and it cannot be disabled.
664 
665     // The values being non-zero value makes deployment a bit more expensive,
666     // but in exchange the refund on every call to nonReentrant will be lower in
667     // amount. Since refunds are capped to a percentage of the total
668     // transaction's gas, it is best to keep them low in cases like this one, to
669     // increase the likelihood of the full refund coming into effect.
670     uint256 private constant _NOT_ENTERED = 1;
671     uint256 private constant _ENTERED = 2;
672 
673     uint256 private _status;
674 
675     constructor() {
676         _status = _NOT_ENTERED;
677     }
678 
679     /**
680      * @dev Prevents a contract from calling itself, directly or indirectly.
681      * Calling a `nonReentrant` function from another `nonReentrant`
682      * function is not supported. It is possible to prevent this from happening
683      * by making the `nonReentrant` function external, and make it call a
684      * `private` function that does the actual work.
685      */
686     modifier nonReentrant() {
687         // On the first call to nonReentrant, _notEntered will be true
688         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
689 
690         // Any calls to nonReentrant after this point will fail
691         _status = _ENTERED;
692 
693         _;
694 
695         // By storing the original value once again, a refund is triggered (see
696         // https://eips.ethereum.org/EIPS/eip-2200)
697         _status = _NOT_ENTERED;
698     }
699 }
700 
701 // File: @openzeppelin/contracts/utils/Strings.sol
702 
703 
704 
705 pragma solidity ^0.8.0;
706 
707 /**
708  * @dev String operations.
709  */
710 library Strings {
711     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
712 
713     /**
714      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
715      */
716     function toString(uint256 value) internal pure returns (string memory) {
717         // Inspired by OraclizeAPI's implementation - MIT licence
718         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
719 
720         if (value == 0) {
721             return "0";
722         }
723         uint256 temp = value;
724         uint256 digits;
725         while (temp != 0) {
726             digits++;
727             temp /= 10;
728         }
729         bytes memory buffer = new bytes(digits);
730         while (value != 0) {
731             digits -= 1;
732             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
733             value /= 10;
734         }
735         return string(buffer);
736     }
737 
738     /**
739      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
740      */
741     function toHexString(uint256 value) internal pure returns (string memory) {
742         if (value == 0) {
743             return "0x00";
744         }
745         uint256 temp = value;
746         uint256 length = 0;
747         while (temp != 0) {
748             length++;
749             temp >>= 8;
750         }
751         return toHexString(value, length);
752     }
753 
754     /**
755      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
756      */
757     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
758         bytes memory buffer = new bytes(2 * length + 2);
759         buffer[0] = "0";
760         buffer[1] = "x";
761         for (uint256 i = 2 * length + 1; i > 1; --i) {
762             buffer[i] = _HEX_SYMBOLS[value & 0xf];
763             value >>= 4;
764         }
765         require(value == 0, "Strings: hex length insufficient");
766         return string(buffer);
767     }
768 }
769 
770 // File: @openzeppelin/contracts/utils/Context.sol
771 
772 
773 
774 pragma solidity ^0.8.0;
775 
776 /**
777  * @dev Provides information about the current execution context, including the
778  * sender of the transaction and its data. While these are generally available
779  * via msg.sender and msg.data, they should not be accessed in such a direct
780  * manner, since when dealing with meta-transactions the account sending and
781  * paying for execution may not be the actual sender (as far as an application
782  * is concerned).
783  *
784  * This contract is only required for intermediate, library-like contracts.
785  */
786 abstract contract Context {
787     function _msgSender() internal view virtual returns (address) {
788         return msg.sender;
789     }
790 
791     function _msgData() internal view virtual returns (bytes calldata) {
792         return msg.data;
793     }
794 }
795 
796 // File: @openzeppelin/contracts/access/Ownable.sol
797 
798 
799 
800 pragma solidity ^0.8.0;
801 
802 
803 /**
804  * @dev Contract module which provides a basic access control mechanism, where
805  * there is an account (an owner) that can be granted exclusive access to
806  * specific functions.
807  *
808  * By default, the owner account will be the one that deploys the contract. This
809  * can later be changed with {transferOwnership}.
810  *
811  * This module is used through inheritance. It will make available the modifier
812  * `onlyOwner`, which can be applied to your functions to restrict their use to
813  * the owner.
814  */
815 abstract contract Ownable is Context {
816     address private _owner;
817 
818     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
819 
820     /**
821      * @dev Initializes the contract setting the deployer as the initial owner.
822      */
823     constructor() {
824         _setOwner(_msgSender());
825     }
826 
827     /**
828      * @dev Returns the address of the current owner.
829      */
830     function owner() public view virtual returns (address) {
831         return _owner;
832     }
833 
834     /**
835      * @dev Throws if called by any account other than the owner.
836      */
837     modifier onlyOwner() {
838         require(owner() == _msgSender(), "Ownable: caller is not the owner");
839         _;
840     }
841 
842     /**
843      * @dev Leaves the contract without owner. It will not be possible to call
844      * `onlyOwner` functions anymore. Can only be called by the current owner.
845      *
846      * NOTE: Renouncing ownership will leave the contract without an owner,
847      * thereby removing any functionality that is only available to the owner.
848      */
849     function renounceOwnership() public virtual onlyOwner {
850         _setOwner(address(0));
851     }
852 
853     /**
854      * @dev Transfers ownership of the contract to a new account (`newOwner`).
855      * Can only be called by the current owner.
856      */
857     function transferOwnership(address newOwner) public virtual onlyOwner {
858         require(newOwner != address(0), "Ownable: new owner is the zero address");
859         _setOwner(newOwner);
860     }
861 
862     function _setOwner(address newOwner) private {
863         address oldOwner = _owner;
864         _owner = newOwner;
865         emit OwnershipTransferred(oldOwner, newOwner);
866     }
867 }
868 
869 // File: @openzeppelin/contracts/utils/Address.sol
870 
871 
872 
873 pragma solidity ^0.8.0;
874 
875 /**
876  * @dev Collection of functions related to the address type
877  */
878 library Address {
879     /**
880      * @dev Returns true if `account` is a contract.
881      *
882      * [IMPORTANT]
883      * ====
884      * It is unsafe to assume that an address for which this function returns
885      * false is an externally-owned account (EOA) and not a contract.
886      *
887      * Among others, `isContract` will return false for the following
888      * types of addresses:
889      *
890      *  - an externally-owned account
891      *  - a contract in construction
892      *  - an address where a contract will be created
893      *  - an address where a contract lived, but was destroyed
894      * ====
895      */
896     function isContract(address account) internal view returns (bool) {
897         // This method relies on extcodesize, which returns 0 for contracts in
898         // construction, since the code is only stored at the end of the
899         // constructor execution.
900 
901         uint256 size;
902         assembly {
903             size := extcodesize(account)
904         }
905         return size > 0;
906     }
907 
908     /**
909      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
910      * `recipient`, forwarding all available gas and reverting on errors.
911      *
912      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
913      * of certain opcodes, possibly making contracts go over the 2300 gas limit
914      * imposed by `transfer`, making them unable to receive funds via
915      * `transfer`. {sendValue} removes this limitation.
916      *
917      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
918      *
919      * IMPORTANT: because control is transferred to `recipient`, care must be
920      * taken to not create reentrancy vulnerabilities. Consider using
921      * {ReentrancyGuard} or the
922      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
923      */
924     function sendValue(address payable recipient, uint256 amount) internal {
925         require(address(this).balance >= amount, "Address: insufficient balance");
926 
927         (bool success, ) = recipient.call{value: amount}("");
928         require(success, "Address: unable to send value, recipient may have reverted");
929     }
930 
931     /**
932      * @dev Performs a Solidity function call using a low level `call`. A
933      * plain `call` is an unsafe replacement for a function call: use this
934      * function instead.
935      *
936      * If `target` reverts with a revert reason, it is bubbled up by this
937      * function (like regular Solidity function calls).
938      *
939      * Returns the raw returned data. To convert to the expected return value,
940      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
941      *
942      * Requirements:
943      *
944      * - `target` must be a contract.
945      * - calling `target` with `data` must not revert.
946      *
947      * _Available since v3.1._
948      */
949     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
950         return functionCall(target, data, "Address: low-level call failed");
951     }
952 
953     /**
954      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
955      * `errorMessage` as a fallback revert reason when `target` reverts.
956      *
957      * _Available since v3.1._
958      */
959     function functionCall(
960         address target,
961         bytes memory data,
962         string memory errorMessage
963     ) internal returns (bytes memory) {
964         return functionCallWithValue(target, data, 0, errorMessage);
965     }
966 
967     /**
968      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
969      * but also transferring `value` wei to `target`.
970      *
971      * Requirements:
972      *
973      * - the calling contract must have an ETH balance of at least `value`.
974      * - the called Solidity function must be `payable`.
975      *
976      * _Available since v3.1._
977      */
978     function functionCallWithValue(
979         address target,
980         bytes memory data,
981         uint256 value
982     ) internal returns (bytes memory) {
983         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
984     }
985 
986     /**
987      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
988      * with `errorMessage` as a fallback revert reason when `target` reverts.
989      *
990      * _Available since v3.1._
991      */
992     function functionCallWithValue(
993         address target,
994         bytes memory data,
995         uint256 value,
996         string memory errorMessage
997     ) internal returns (bytes memory) {
998         require(address(this).balance >= value, "Address: insufficient balance for call");
999         require(isContract(target), "Address: call to non-contract");
1000 
1001         (bool success, bytes memory returndata) = target.call{value: value}(data);
1002         return verifyCallResult(success, returndata, errorMessage);
1003     }
1004 
1005     /**
1006      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1007      * but performing a static call.
1008      *
1009      * _Available since v3.3._
1010      */
1011     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1012         return functionStaticCall(target, data, "Address: low-level static call failed");
1013     }
1014 
1015     /**
1016      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1017      * but performing a static call.
1018      *
1019      * _Available since v3.3._
1020      */
1021     function functionStaticCall(
1022         address target,
1023         bytes memory data,
1024         string memory errorMessage
1025     ) internal view returns (bytes memory) {
1026         require(isContract(target), "Address: static call to non-contract");
1027 
1028         (bool success, bytes memory returndata) = target.staticcall(data);
1029         return verifyCallResult(success, returndata, errorMessage);
1030     }
1031 
1032     /**
1033      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1034      * but performing a delegate call.
1035      *
1036      * _Available since v3.4._
1037      */
1038     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1039         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1040     }
1041 
1042     /**
1043      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1044      * but performing a delegate call.
1045      *
1046      * _Available since v3.4._
1047      */
1048     function functionDelegateCall(
1049         address target,
1050         bytes memory data,
1051         string memory errorMessage
1052     ) internal returns (bytes memory) {
1053         require(isContract(target), "Address: delegate call to non-contract");
1054 
1055         (bool success, bytes memory returndata) = target.delegatecall(data);
1056         return verifyCallResult(success, returndata, errorMessage);
1057     }
1058 
1059     /**
1060      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1061      * revert reason using the provided one.
1062      *
1063      * _Available since v4.3._
1064      */
1065     function verifyCallResult(
1066         bool success,
1067         bytes memory returndata,
1068         string memory errorMessage
1069     ) internal pure returns (bytes memory) {
1070         if (success) {
1071             return returndata;
1072         } else {
1073             // Look for revert reason and bubble it up if present
1074             if (returndata.length > 0) {
1075                 // The easiest way to bubble the revert reason is using memory via assembly
1076 
1077                 assembly {
1078                     let returndata_size := mload(returndata)
1079                     revert(add(32, returndata), returndata_size)
1080                 }
1081             } else {
1082                 revert(errorMessage);
1083             }
1084         }
1085     }
1086 }
1087 
1088 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1089 
1090 
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 /**
1095  * @title ERC721 token receiver interface
1096  * @dev Interface for any contract that wants to support safeTransfers
1097  * from ERC721 asset contracts.
1098  */
1099 interface IERC721Receiver {
1100     /**
1101      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1102      * by `operator` from `from`, this function is called.
1103      *
1104      * It must return its Solidity selector to confirm the token transfer.
1105      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1106      *
1107      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1108      */
1109     function onERC721Received(
1110         address operator,
1111         address from,
1112         uint256 tokenId,
1113         bytes calldata data
1114     ) external returns (bytes4);
1115 }
1116 
1117 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1118 
1119 
1120 
1121 pragma solidity ^0.8.0;
1122 
1123 /**
1124  * @dev Interface of the ERC165 standard, as defined in the
1125  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1126  *
1127  * Implementers can declare support of contract interfaces, which can then be
1128  * queried by others ({ERC165Checker}).
1129  *
1130  * For an implementation, see {ERC165}.
1131  */
1132 interface IERC165 {
1133     /**
1134      * @dev Returns true if this contract implements the interface defined by
1135      * `interfaceId`. See the corresponding
1136      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1137      * to learn more about how these ids are created.
1138      *
1139      * This function call must use less than 30 000 gas.
1140      */
1141     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1142 }
1143 
1144 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1145 
1146 
1147 
1148 pragma solidity ^0.8.0;
1149 
1150 
1151 /**
1152  * @dev Implementation of the {IERC165} interface.
1153  *
1154  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1155  * for the additional interface id that will be supported. For example:
1156  *
1157  * ```solidity
1158  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1159  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1160  * }
1161  * ```
1162  *
1163  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1164  */
1165 abstract contract ERC165 is IERC165 {
1166     /**
1167      * @dev See {IERC165-supportsInterface}.
1168      */
1169     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1170         return interfaceId == type(IERC165).interfaceId;
1171     }
1172 }
1173 
1174 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1175 
1176 
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 
1181 /**
1182  * @dev Required interface of an ERC721 compliant contract.
1183  */
1184 interface IERC721 is IERC165 {
1185     /**
1186      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1187      */
1188     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1189 
1190     /**
1191      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1192      */
1193     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1194 
1195     /**
1196      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1197      */
1198     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1199 
1200     /**
1201      * @dev Returns the number of tokens in ``owner``'s account.
1202      */
1203     function balanceOf(address owner) external view returns (uint256 balance);
1204 
1205     /**
1206      * @dev Returns the owner of the `tokenId` token.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must exist.
1211      */
1212     function ownerOf(uint256 tokenId) external view returns (address owner);
1213 
1214     /**
1215      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1216      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1217      *
1218      * Requirements:
1219      *
1220      * - `from` cannot be the zero address.
1221      * - `to` cannot be the zero address.
1222      * - `tokenId` token must exist and be owned by `from`.
1223      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1224      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function safeTransferFrom(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) external;
1233 
1234     /**
1235      * @dev Transfers `tokenId` token from `from` to `to`.
1236      *
1237      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1238      *
1239      * Requirements:
1240      *
1241      * - `from` cannot be the zero address.
1242      * - `to` cannot be the zero address.
1243      * - `tokenId` token must be owned by `from`.
1244      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function transferFrom(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) external;
1253 
1254     /**
1255      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1256      * The approval is cleared when the token is transferred.
1257      *
1258      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1259      *
1260      * Requirements:
1261      *
1262      * - The caller must own the token or be an approved operator.
1263      * - `tokenId` must exist.
1264      *
1265      * Emits an {Approval} event.
1266      */
1267     function approve(address to, uint256 tokenId) external;
1268 
1269     /**
1270      * @dev Returns the account approved for `tokenId` token.
1271      *
1272      * Requirements:
1273      *
1274      * - `tokenId` must exist.
1275      */
1276     function getApproved(uint256 tokenId) external view returns (address operator);
1277 
1278     /**
1279      * @dev Approve or remove `operator` as an operator for the caller.
1280      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1281      *
1282      * Requirements:
1283      *
1284      * - The `operator` cannot be the caller.
1285      *
1286      * Emits an {ApprovalForAll} event.
1287      */
1288     function setApprovalForAll(address operator, bool _approved) external;
1289 
1290     /**
1291      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1292      *
1293      * See {setApprovalForAll}
1294      */
1295     function isApprovedForAll(address owner, address operator) external view returns (bool);
1296 
1297     /**
1298      * @dev Safely transfers `tokenId` token from `from` to `to`.
1299      *
1300      * Requirements:
1301      *
1302      * - `from` cannot be the zero address.
1303      * - `to` cannot be the zero address.
1304      * - `tokenId` token must exist and be owned by `from`.
1305      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1306      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function safeTransferFrom(
1311         address from,
1312         address to,
1313         uint256 tokenId,
1314         bytes calldata data
1315     ) external;
1316 }
1317 
1318 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1319 
1320 
1321 
1322 pragma solidity ^0.8.0;
1323 
1324 
1325 /**
1326  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1327  * @dev See https://eips.ethereum.org/EIPS/eip-721
1328  */
1329 interface IERC721Metadata is IERC721 {
1330     /**
1331      * @dev Returns the token collection name.
1332      */
1333     function name() external view returns (string memory);
1334 
1335     /**
1336      * @dev Returns the token collection symbol.
1337      */
1338     function symbol() external view returns (string memory);
1339 
1340     /**
1341      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1342      */
1343     function tokenURI(uint256 tokenId) external view returns (string memory);
1344 }
1345 
1346 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1347 
1348 
1349 
1350 pragma solidity ^0.8.0;
1351 
1352 
1353 
1354 
1355 
1356 
1357 
1358 
1359 /**
1360  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1361  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1362  * {ERC721Enumerable}.
1363  */
1364 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1365     using Address for address;
1366     using Strings for uint256;
1367 
1368     // Token name
1369     string private _name;
1370 
1371     // Token symbol
1372     string private _symbol;
1373 
1374     // Mapping from token ID to owner address
1375     mapping(uint256 => address) private _owners;
1376 
1377     // Mapping owner address to token count
1378     mapping(address => uint256) private _balances;
1379 
1380     // Mapping from token ID to approved address
1381     mapping(uint256 => address) private _tokenApprovals;
1382 
1383     // Mapping from owner to operator approvals
1384     mapping(address => mapping(address => bool)) private _operatorApprovals;
1385 
1386     /**
1387      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1388      */
1389     constructor(string memory name_, string memory symbol_) {
1390         _name = name_;
1391         _symbol = symbol_;
1392     }
1393 
1394     /**
1395      * @dev See {IERC165-supportsInterface}.
1396      */
1397     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1398         return
1399             interfaceId == type(IERC721).interfaceId ||
1400             interfaceId == type(IERC721Metadata).interfaceId ||
1401             super.supportsInterface(interfaceId);
1402     }
1403 
1404     /**
1405      * @dev See {IERC721-balanceOf}.
1406      */
1407     function balanceOf(address owner) public view virtual override returns (uint256) {
1408         require(owner != address(0), "ERC721: balance query for the zero address");
1409         return _balances[owner];
1410     }
1411 
1412     /**
1413      * @dev See {IERC721-ownerOf}.
1414      */
1415     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1416         address owner = _owners[tokenId];
1417         require(owner != address(0), "ERC721: owner query for nonexistent token");
1418         return owner;
1419     }
1420 
1421     /**
1422      * @dev See {IERC721Metadata-name}.
1423      */
1424     function name() public view virtual override returns (string memory) {
1425         return _name;
1426     }
1427 
1428     /**
1429      * @dev See {IERC721Metadata-symbol}.
1430      */
1431     function symbol() public view virtual override returns (string memory) {
1432         return _symbol;
1433     }
1434 
1435     /**
1436      * @dev See {IERC721Metadata-tokenURI}.
1437      */
1438     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1439         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1440 
1441         string memory baseURI = _baseURI();
1442         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1443     }
1444 
1445     /**
1446      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1447      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1448      * by default, can be overriden in child contracts.
1449      */
1450     function _baseURI() internal view virtual returns (string memory) {
1451         return "";
1452     }
1453 
1454     /**
1455      * @dev See {IERC721-approve}.
1456      */
1457     function approve(address to, uint256 tokenId) public virtual override {
1458         address owner = ERC721.ownerOf(tokenId);
1459         require(to != owner, "ERC721: approval to current owner");
1460 
1461         require(
1462             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1463             "ERC721: approve caller is not owner nor approved for all"
1464         );
1465 
1466         _approve(to, tokenId);
1467     }
1468 
1469     /**
1470      * @dev See {IERC721-getApproved}.
1471      */
1472     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1473         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1474 
1475         return _tokenApprovals[tokenId];
1476     }
1477 
1478     /**
1479      * @dev See {IERC721-setApprovalForAll}.
1480      */
1481     function setApprovalForAll(address operator, bool approved) public virtual override {
1482         require(operator != _msgSender(), "ERC721: approve to caller");
1483 
1484         _operatorApprovals[_msgSender()][operator] = approved;
1485         emit ApprovalForAll(_msgSender(), operator, approved);
1486     }
1487 
1488     /**
1489      * @dev See {IERC721-isApprovedForAll}.
1490      */
1491     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1492         return _operatorApprovals[owner][operator];
1493     }
1494 
1495     /**
1496      * @dev See {IERC721-transferFrom}.
1497      */
1498     function transferFrom(
1499         address from,
1500         address to,
1501         uint256 tokenId
1502     ) public virtual override {
1503         //solhint-disable-next-line max-line-length
1504         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1505 
1506         _transfer(from, to, tokenId);
1507     }
1508 
1509     /**
1510      * @dev See {IERC721-safeTransferFrom}.
1511      */
1512     function safeTransferFrom(
1513         address from,
1514         address to,
1515         uint256 tokenId
1516     ) public virtual override {
1517         safeTransferFrom(from, to, tokenId, "");
1518     }
1519 
1520     /**
1521      * @dev See {IERC721-safeTransferFrom}.
1522      */
1523     function safeTransferFrom(
1524         address from,
1525         address to,
1526         uint256 tokenId,
1527         bytes memory _data
1528     ) public virtual override {
1529         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1530         _safeTransfer(from, to, tokenId, _data);
1531     }
1532 
1533     /**
1534      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1535      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1536      *
1537      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1538      *
1539      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1540      * implement alternative mechanisms to perform token transfer, such as signature-based.
1541      *
1542      * Requirements:
1543      *
1544      * - `from` cannot be the zero address.
1545      * - `to` cannot be the zero address.
1546      * - `tokenId` token must exist and be owned by `from`.
1547      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1548      *
1549      * Emits a {Transfer} event.
1550      */
1551     function _safeTransfer(
1552         address from,
1553         address to,
1554         uint256 tokenId,
1555         bytes memory _data
1556     ) internal virtual {
1557         _transfer(from, to, tokenId);
1558         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1559     }
1560 
1561     /**
1562      * @dev Returns whether `tokenId` exists.
1563      *
1564      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1565      *
1566      * Tokens start existing when they are minted (`_mint`),
1567      * and stop existing when they are burned (`_burn`).
1568      */
1569     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1570         return _owners[tokenId] != address(0);
1571     }
1572 
1573     /**
1574      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1575      *
1576      * Requirements:
1577      *
1578      * - `tokenId` must exist.
1579      */
1580     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1581         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1582         address owner = ERC721.ownerOf(tokenId);
1583         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1584     }
1585 
1586     /**
1587      * @dev Safely mints `tokenId` and transfers it to `to`.
1588      *
1589      * Requirements:
1590      *
1591      * - `tokenId` must not exist.
1592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1593      *
1594      * Emits a {Transfer} event.
1595      */
1596     function _safeMint(address to, uint256 tokenId) internal virtual {
1597         _safeMint(to, tokenId, "");
1598     }
1599 
1600     /**
1601      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1602      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1603      */
1604     function _safeMint(
1605         address to,
1606         uint256 tokenId,
1607         bytes memory _data
1608     ) internal virtual {
1609         _mint(to, tokenId);
1610         require(
1611             _checkOnERC721Received(address(0), to, tokenId, _data),
1612             "ERC721: transfer to non ERC721Receiver implementer"
1613         );
1614     }
1615 
1616     /**
1617      * @dev Mints `tokenId` and transfers it to `to`.
1618      *
1619      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1620      *
1621      * Requirements:
1622      *
1623      * - `tokenId` must not exist.
1624      * - `to` cannot be the zero address.
1625      *
1626      * Emits a {Transfer} event.
1627      */
1628     function _mint(address to, uint256 tokenId) internal virtual {
1629         require(to != address(0), "ERC721: mint to the zero address");
1630         require(!_exists(tokenId), "ERC721: token already minted");
1631 
1632         _beforeTokenTransfer(address(0), to, tokenId);
1633 
1634         _balances[to] += 1;
1635         _owners[tokenId] = to;
1636 
1637         emit Transfer(address(0), to, tokenId);
1638     }
1639 
1640     /**
1641      * @dev Destroys `tokenId`.
1642      * The approval is cleared when the token is burned.
1643      *
1644      * Requirements:
1645      *
1646      * - `tokenId` must exist.
1647      *
1648      * Emits a {Transfer} event.
1649      */
1650     function _burn(uint256 tokenId) internal virtual {
1651         address owner = ERC721.ownerOf(tokenId);
1652 
1653         _beforeTokenTransfer(owner, address(0), tokenId);
1654 
1655         // Clear approvals
1656         _approve(address(0), tokenId);
1657 
1658         _balances[owner] -= 1;
1659         delete _owners[tokenId];
1660 
1661         emit Transfer(owner, address(0), tokenId);
1662     }
1663 
1664     /**
1665      * @dev Transfers `tokenId` from `from` to `to`.
1666      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1667      *
1668      * Requirements:
1669      *
1670      * - `to` cannot be the zero address.
1671      * - `tokenId` token must be owned by `from`.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function _transfer(
1676         address from,
1677         address to,
1678         uint256 tokenId
1679     ) internal virtual {
1680         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1681         require(to != address(0), "ERC721: transfer to the zero address");
1682 
1683         _beforeTokenTransfer(from, to, tokenId);
1684 
1685         // Clear approvals from the previous owner
1686         _approve(address(0), tokenId);
1687 
1688         _balances[from] -= 1;
1689         _balances[to] += 1;
1690         _owners[tokenId] = to;
1691 
1692         emit Transfer(from, to, tokenId);
1693     }
1694 
1695     /**
1696      * @dev Approve `to` to operate on `tokenId`
1697      *
1698      * Emits a {Approval} event.
1699      */
1700     function _approve(address to, uint256 tokenId) internal virtual {
1701         _tokenApprovals[tokenId] = to;
1702         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1703     }
1704 
1705     /**
1706      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1707      * The call is not executed if the target address is not a contract.
1708      *
1709      * @param from address representing the previous owner of the given token ID
1710      * @param to target address that will receive the tokens
1711      * @param tokenId uint256 ID of the token to be transferred
1712      * @param _data bytes optional data to send along with the call
1713      * @return bool whether the call correctly returned the expected magic value
1714      */
1715     function _checkOnERC721Received(
1716         address from,
1717         address to,
1718         uint256 tokenId,
1719         bytes memory _data
1720     ) private returns (bool) {
1721         if (to.isContract()) {
1722             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1723                 return retval == IERC721Receiver.onERC721Received.selector;
1724             } catch (bytes memory reason) {
1725                 if (reason.length == 0) {
1726                     revert("ERC721: transfer to non ERC721Receiver implementer");
1727                 } else {
1728                     assembly {
1729                         revert(add(32, reason), mload(reason))
1730                     }
1731                 }
1732             }
1733         } else {
1734             return true;
1735         }
1736     }
1737 
1738     /**
1739      * @dev Hook that is called before any token transfer. This includes minting
1740      * and burning.
1741      *
1742      * Calling conditions:
1743      *
1744      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1745      * transferred to `to`.
1746      * - When `from` is zero, `tokenId` will be minted for `to`.
1747      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1748      * - `from` and `to` are never both zero.
1749      *
1750      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1751      */
1752     function _beforeTokenTransfer(
1753         address from,
1754         address to,
1755         uint256 tokenId
1756     ) internal virtual {}
1757 }
1758 
1759 // File: contracts/TheSecondBurn.sol
1760 
1761 
1762 pragma solidity ^0.8.0;
1763 
1764 
1765 
1766 
1767 
1768 
1769 
1770 
1771 interface BurnablesInterface {
1772     function ownerOf(uint256 tokenId) external view returns (address owner);
1773 }
1774 
1775 contract TheSecondBurn is ERC721, ReentrancyGuard, Ownable {
1776     using Strings for uint256;
1777     using SafeMath for uint256;
1778     using Counters for Counters.Counter;
1779     using EnumerableSet for EnumerableSet.UintSet;
1780 
1781     Counters.Counter private _tokenIdTracker;
1782     Counters.Counter private _burnedTracker;
1783     
1784     // Enumerable set of burnable ids that have minted
1785     EnumerableSet.UintSet private _burnableMinters;
1786     
1787     // burnables Contract
1788     // mainnet
1789 	address public burnablesAddress = 0xF9b8E02A97780381ea1FbDd41D7706ACD163dd9A;
1790 	// rinkeby
1791 	// address public burnablesAddress = 0x54490f800df2E2A654CfdE8C9eB966C6A55771B1;
1792     BurnablesInterface burnablesContract = BurnablesInterface(burnablesAddress);
1793     
1794     string public baseTokenURI;
1795 
1796     uint256 public constant MAX_ELEMENTS = 4999;    
1797     uint256 public constant MAX_PUBLIC_ELEMENTS = 4000;    
1798     uint256 public constant MINT_PRICE = 8 * 10**16;
1799     
1800 
1801     event CreateBurnable(uint256 indexed id);
1802 
1803     constructor() public ERC721("TheSecondBurn", "BURN2") {}
1804 
1805     modifier saleIsOpen {
1806         require(_totalSupply() <= MAX_PUBLIC_ELEMENTS, "Sale end");
1807         _;
1808     }
1809 
1810     function totalSupply() public view returns (uint256) {
1811         return  _totalSupply() - _totalBurned();
1812     }
1813 
1814     function _totalSupply() internal view returns (uint256) {
1815         return _tokenIdTracker.current();
1816     }
1817     
1818     function _totalBurned() internal view returns (uint256) {
1819         return _burnedTracker.current();
1820     }
1821     
1822     function totalBurned() public view returns (uint256) {
1823         return _totalBurned();
1824     }
1825 
1826     function totalMint() public view returns (uint256) {
1827         return _totalSupply();
1828     }
1829     
1830     function getBurnablesOwner(uint256 burnablesId) public view returns (address) {
1831         return burnablesContract.ownerOf(burnablesId);
1832     }
1833     
1834     // Minting reserved for burnables owners
1835     function mintWithBurnable(uint256 burnablesId) public nonReentrant {
1836         require(burnablesContract.ownerOf(burnablesId) == msg.sender, "Not the owner of this burnable");
1837         require(!_burnableMinters.contains(burnablesId), "This burnable already has minted a second burn.");
1838         
1839          _burnableMinters.add(burnablesId);
1840 
1841         _mintAnElement(msg.sender);
1842     }
1843     
1844     function mintPublic(uint256 _count) public payable saleIsOpen {
1845         uint256 total = _totalSupply();
1846         require(total + _count <= MAX_PUBLIC_ELEMENTS, "Max limit");
1847         require(total <= MAX_PUBLIC_ELEMENTS, "Sale end");
1848         require(msg.value >= price(_count), "Value below price");
1849 
1850         for (uint256 i = 0; i < _count; i++) {
1851             _mintAnElement(msg.sender);
1852         }
1853     }
1854     
1855     function price(uint256 _count) public pure returns (uint256) {
1856         return MINT_PRICE.mul(_count);
1857     }
1858 
1859     function _mintAnElement(address _to) private {
1860         uint256 id = _totalSupply();
1861         _tokenIdTracker.increment();
1862         _safeMint(_to, id);
1863         emit CreateBurnable(id);
1864     }
1865     
1866     // Send ETH to make the burn value higher
1867     function sendEther() public payable {
1868         uint256 supply = totalSupply();
1869         require(supply > 0);
1870     }
1871 
1872     function setBaseURI(string memory baseURI) public onlyOwner {
1873         baseTokenURI = baseURI;
1874     }
1875 
1876     /**
1877      * @dev Returns an URI for a given token ID
1878      */
1879     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1880         return string(abi.encodePacked(baseTokenURI, _tokenId.toString()));
1881     }
1882     
1883     /**
1884      * @dev Burns and pays the mint price to the token owner.
1885      * @param _tokenId The token to burn.
1886      */
1887     function burn(uint256 _tokenId) public {
1888         require(ownerOf(_tokenId) == msg.sender);
1889         uint256 balance = address(this).balance;
1890         require(balance > 0);
1891 
1892         //Burn token
1893         _transfer(
1894             msg.sender,
1895             0x000000000000000000000000000000000000dEaD,
1896             _tokenId
1897         );
1898 
1899         // pay token owner 
1900         uint256 supply = totalSupply();
1901         _widthdraw(msg.sender, balance.div(supply));
1902         
1903         // increment burn
1904         _burnedTracker.increment();
1905     }
1906 
1907     function _widthdraw(address _address, uint256 _amount) private {
1908         (bool success, ) = _address.call{value: _amount}("");
1909         require(success, "Transfer failed.");
1910     }
1911 }