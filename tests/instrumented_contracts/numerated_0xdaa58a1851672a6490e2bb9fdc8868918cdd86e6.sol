1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b)
26         internal
27         pure
28         returns (bool, uint256)
29     {
30         unchecked {
31             uint256 c = a + b;
32             if (c < a) return (false, 0);
33             return (true, c);
34         }
35     }
36 
37     /**
38      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
39      *
40      * _Available since v3.4._
41      */
42     function trySub(uint256 a, uint256 b)
43         internal
44         pure
45         returns (bool, uint256)
46     {
47         unchecked {
48             if (b > a) return (false, 0);
49             return (true, a - b);
50         }
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
55      *
56      * _Available since v3.4._
57      */
58     function tryMul(uint256 a, uint256 b)
59         internal
60         pure
61         returns (bool, uint256)
62     {
63         unchecked {
64             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65             // benefit is lost if 'b' is also tested.
66             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67             if (a == 0) return (true, 0);
68             uint256 c = a * b;
69             if (c / a != b) return (false, 0);
70             return (true, c);
71         }
72     }
73 
74     /**
75      * @dev Returns the division of two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryDiv(uint256 a, uint256 b)
80         internal
81         pure
82         returns (bool, uint256)
83     {
84         unchecked {
85             if (b == 0) return (false, 0);
86             return (true, a / b);
87         }
88     }
89 
90     /**
91      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
92      *
93      * _Available since v3.4._
94      */
95     function tryMod(uint256 a, uint256 b)
96         internal
97         pure
98         returns (bool, uint256)
99     {
100         unchecked {
101             if (b == 0) return (false, 0);
102             return (true, a % b);
103         }
104     }
105 
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         return a + b;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a - b;
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `*` operator.
139      *
140      * Requirements:
141      *
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         return a * b;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers, reverting on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator.
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a / b;
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * reverting when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         return a % b;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
180      * overflow (when the result is negative).
181      *
182      * CAUTION: This function is deprecated because it requires allocating memory for the error
183      * message unnecessarily. For custom revert reasons use {trySub}.
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         unchecked {
197             require(b <= a, errorMessage);
198             return a - b;
199         }
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         unchecked {
220             require(b > 0, errorMessage);
221             return a / b;
222         }
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * reverting with custom message when dividing by zero.
228      *
229      * CAUTION: This function is deprecated because it requires allocating memory for the error
230      * message unnecessarily. For custom revert reasons use {tryMod}.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(
241         uint256 a,
242         uint256 b,
243         string memory errorMessage
244     ) internal pure returns (uint256) {
245         unchecked {
246             require(b > 0, errorMessage);
247             return a % b;
248         }
249     }
250 }
251 
252 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
253 
254 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Library for managing
260  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
261  * types.
262  *
263  * Sets have the following properties:
264  *
265  * - Elements are added, removed, and checked for existence in constant time
266  * (O(1)).
267  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
268  *
269  * ```
270  * contract Example {
271  *     // Add the library methods
272  *     using EnumerableSet for EnumerableSet.AddressSet;
273  *
274  *     // Declare a set state variable
275  *     EnumerableSet.AddressSet private mySet;
276  * }
277  * ```
278  *
279  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
280  * and `uint256` (`UintSet`) are supported.
281  */
282 library EnumerableSet {
283     // To implement this library for multiple types with as little code
284     // repetition as possible, we write it in terms of a generic Set type with
285     // bytes32 values.
286     // The Set implementation uses private functions, and user-facing
287     // implementations (such as AddressSet) are just wrappers around the
288     // underlying Set.
289     // This means that we can only create new EnumerableSets for types that fit
290     // in bytes32.
291 
292     struct Set {
293         // Storage of set values
294         bytes32[] _values;
295         // Position of the value in the `values` array, plus 1 because index 0
296         // means a value is not in the set.
297         mapping(bytes32 => uint256) _indexes;
298     }
299 
300     /**
301      * @dev Add a value to a set. O(1).
302      *
303      * Returns true if the value was added to the set, that is if it was not
304      * already present.
305      */
306     function _add(Set storage set, bytes32 value) private returns (bool) {
307         if (!_contains(set, value)) {
308             set._values.push(value);
309             // The value is stored at length-1, but we add 1 to all indexes
310             // and use 0 as a sentinel value
311             set._indexes[value] = set._values.length;
312             return true;
313         } else {
314             return false;
315         }
316     }
317 
318     /**
319      * @dev Removes a value from a set. O(1).
320      *
321      * Returns true if the value was removed from the set, that is if it was
322      * present.
323      */
324     function _remove(Set storage set, bytes32 value) private returns (bool) {
325         // We read and store the value's index to prevent multiple reads from the same storage slot
326         uint256 valueIndex = set._indexes[value];
327 
328         if (valueIndex != 0) {
329             // Equivalent to contains(set, value)
330             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
331             // the array, and then remove the last element (sometimes called as 'swap and pop').
332             // This modifies the order of the array, as noted in {at}.
333 
334             uint256 toDeleteIndex = valueIndex - 1;
335             uint256 lastIndex = set._values.length - 1;
336 
337             if (lastIndex != toDeleteIndex) {
338                 bytes32 lastvalue = set._values[lastIndex];
339 
340                 // Move the last value to the index where the value to delete is
341                 set._values[toDeleteIndex] = lastvalue;
342                 // Update the index for the moved value
343                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
344             }
345 
346             // Delete the slot where the moved value was stored
347             set._values.pop();
348 
349             // Delete the index for the deleted slot
350             delete set._indexes[value];
351 
352             return true;
353         } else {
354             return false;
355         }
356     }
357 
358     /**
359      * @dev Returns true if the value is in the set. O(1).
360      */
361     function _contains(Set storage set, bytes32 value)
362         private
363         view
364         returns (bool)
365     {
366         return set._indexes[value] != 0;
367     }
368 
369     /**
370      * @dev Returns the number of values on the set. O(1).
371      */
372     function _length(Set storage set) private view returns (uint256) {
373         return set._values.length;
374     }
375 
376     /**
377      * @dev Returns the value stored at position `index` in the set. O(1).
378      *
379      * Note that there are no guarantees on the ordering of values inside the
380      * array, and it may change when more values are added or removed.
381      *
382      * Requirements:
383      *
384      * - `index` must be strictly less than {length}.
385      */
386     function _at(Set storage set, uint256 index)
387         private
388         view
389         returns (bytes32)
390     {
391         return set._values[index];
392     }
393 
394     /**
395      * @dev Return the entire set in an array
396      *
397      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
398      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
399      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
400      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
401      */
402     function _values(Set storage set) private view returns (bytes32[] memory) {
403         return set._values;
404     }
405 
406     // Bytes32Set
407 
408     struct Bytes32Set {
409         Set _inner;
410     }
411 
412     /**
413      * @dev Add a value to a set. O(1).
414      *
415      * Returns true if the value was added to the set, that is if it was not
416      * already present.
417      */
418     function add(Bytes32Set storage set, bytes32 value)
419         internal
420         returns (bool)
421     {
422         return _add(set._inner, value);
423     }
424 
425     /**
426      * @dev Removes a value from a set. O(1).
427      *
428      * Returns true if the value was removed from the set, that is if it was
429      * present.
430      */
431     function remove(Bytes32Set storage set, bytes32 value)
432         internal
433         returns (bool)
434     {
435         return _remove(set._inner, value);
436     }
437 
438     /**
439      * @dev Returns true if the value is in the set. O(1).
440      */
441     function contains(Bytes32Set storage set, bytes32 value)
442         internal
443         view
444         returns (bool)
445     {
446         return _contains(set._inner, value);
447     }
448 
449     /**
450      * @dev Returns the number of values in the set. O(1).
451      */
452     function length(Bytes32Set storage set) internal view returns (uint256) {
453         return _length(set._inner);
454     }
455 
456     /**
457      * @dev Returns the value stored at position `index` in the set. O(1).
458      *
459      * Note that there are no guarantees on the ordering of values inside the
460      * array, and it may change when more values are added or removed.
461      *
462      * Requirements:
463      *
464      * - `index` must be strictly less than {length}.
465      */
466     function at(Bytes32Set storage set, uint256 index)
467         internal
468         view
469         returns (bytes32)
470     {
471         return _at(set._inner, index);
472     }
473 
474     /**
475      * @dev Return the entire set in an array
476      *
477      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
478      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
479      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
480      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
481      */
482     function values(Bytes32Set storage set)
483         internal
484         view
485         returns (bytes32[] memory)
486     {
487         return _values(set._inner);
488     }
489 
490     // AddressSet
491 
492     struct AddressSet {
493         Set _inner;
494     }
495 
496     /**
497      * @dev Add a value to a set. O(1).
498      *
499      * Returns true if the value was added to the set, that is if it was not
500      * already present.
501      */
502     function add(AddressSet storage set, address value)
503         internal
504         returns (bool)
505     {
506         return _add(set._inner, bytes32(uint256(uint160(value))));
507     }
508 
509     /**
510      * @dev Removes a value from a set. O(1).
511      *
512      * Returns true if the value was removed from the set, that is if it was
513      * present.
514      */
515     function remove(AddressSet storage set, address value)
516         internal
517         returns (bool)
518     {
519         return _remove(set._inner, bytes32(uint256(uint160(value))));
520     }
521 
522     /**
523      * @dev Returns true if the value is in the set. O(1).
524      */
525     function contains(AddressSet storage set, address value)
526         internal
527         view
528         returns (bool)
529     {
530         return _contains(set._inner, bytes32(uint256(uint160(value))));
531     }
532 
533     /**
534      * @dev Returns the number of values in the set. O(1).
535      */
536     function length(AddressSet storage set) internal view returns (uint256) {
537         return _length(set._inner);
538     }
539 
540     /**
541      * @dev Returns the value stored at position `index` in the set. O(1).
542      *
543      * Note that there are no guarantees on the ordering of values inside the
544      * array, and it may change when more values are added or removed.
545      *
546      * Requirements:
547      *
548      * - `index` must be strictly less than {length}.
549      */
550     function at(AddressSet storage set, uint256 index)
551         internal
552         view
553         returns (address)
554     {
555         return address(uint160(uint256(_at(set._inner, index))));
556     }
557 
558     /**
559      * @dev Return the entire set in an array
560      *
561      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
562      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
563      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
564      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
565      */
566     function values(AddressSet storage set)
567         internal
568         view
569         returns (address[] memory)
570     {
571         bytes32[] memory store = _values(set._inner);
572         address[] memory result;
573 
574         assembly {
575             result := store
576         }
577 
578         return result;
579     }
580 
581     // UintSet
582 
583     struct UintSet {
584         Set _inner;
585     }
586 
587     /**
588      * @dev Add a value to a set. O(1).
589      *
590      * Returns true if the value was added to the set, that is if it was not
591      * already present.
592      */
593     function add(UintSet storage set, uint256 value) internal returns (bool) {
594         return _add(set._inner, bytes32(value));
595     }
596 
597     /**
598      * @dev Removes a value from a set. O(1).
599      *
600      * Returns true if the value was removed from the set, that is if it was
601      * present.
602      */
603     function remove(UintSet storage set, uint256 value)
604         internal
605         returns (bool)
606     {
607         return _remove(set._inner, bytes32(value));
608     }
609 
610     /**
611      * @dev Returns true if the value is in the set. O(1).
612      */
613     function contains(UintSet storage set, uint256 value)
614         internal
615         view
616         returns (bool)
617     {
618         return _contains(set._inner, bytes32(value));
619     }
620 
621     /**
622      * @dev Returns the number of values on the set. O(1).
623      */
624     function length(UintSet storage set) internal view returns (uint256) {
625         return _length(set._inner);
626     }
627 
628     /**
629      * @dev Returns the value stored at position `index` in the set. O(1).
630      *
631      * Note that there are no guarantees on the ordering of values inside the
632      * array, and it may change when more values are added or removed.
633      *
634      * Requirements:
635      *
636      * - `index` must be strictly less than {length}.
637      */
638     function at(UintSet storage set, uint256 index)
639         internal
640         view
641         returns (uint256)
642     {
643         return uint256(_at(set._inner, index));
644     }
645 
646     /**
647      * @dev Return the entire set in an array
648      *
649      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
650      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
651      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
652      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
653      */
654     function values(UintSet storage set)
655         internal
656         view
657         returns (uint256[] memory)
658     {
659         bytes32[] memory store = _values(set._inner);
660         uint256[] memory result;
661 
662         assembly {
663             result := store
664         }
665 
666         return result;
667     }
668 }
669 
670 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
671 
672 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev Interface of the ERC165 standard, as defined in the
678  * https://eips.ethereum.org/EIPS/eip-165[EIP].
679  *
680  * Implementers can declare support of contract interfaces, which can then be
681  * queried by others ({ERC165Checker}).
682  *
683  * For an implementation, see {ERC165}.
684  */
685 interface IERC165 {
686     /**
687      * @dev Returns true if this contract implements the interface defined by
688      * `interfaceId`. See the corresponding
689      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
690      * to learn more about how these ids are created.
691      *
692      * This function call must use less than 30 000 gas.
693      */
694     function supportsInterface(bytes4 interfaceId) external view returns (bool);
695 }
696 
697 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
698 
699 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @dev Implementation of the {IERC165} interface.
705  *
706  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
707  * for the additional interface id that will be supported. For example:
708  *
709  * ```solidity
710  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
711  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
712  * }
713  * ```
714  *
715  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
716  */
717 abstract contract ERC165 is IERC165 {
718     /**
719      * @dev See {IERC165-supportsInterface}.
720      */
721     function supportsInterface(bytes4 interfaceId)
722         public
723         view
724         virtual
725         override
726         returns (bool)
727     {
728         return interfaceId == type(IERC165).interfaceId;
729     }
730 }
731 
732 // File: @openzeppelin/contracts/utils/Strings.sol
733 
734 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @dev String operations.
740  */
741 library Strings {
742     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
743 
744     /**
745      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
746      */
747     function toString(uint256 value) internal pure returns (string memory) {
748         // Inspired by OraclizeAPI's implementation - MIT licence
749         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
750 
751         if (value == 0) {
752             return "0";
753         }
754         uint256 temp = value;
755         uint256 digits;
756         while (temp != 0) {
757             digits++;
758             temp /= 10;
759         }
760         bytes memory buffer = new bytes(digits);
761         while (value != 0) {
762             digits -= 1;
763             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
764             value /= 10;
765         }
766         return string(buffer);
767     }
768 
769     /**
770      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
771      */
772     function toHexString(uint256 value) internal pure returns (string memory) {
773         if (value == 0) {
774             return "0x00";
775         }
776         uint256 temp = value;
777         uint256 length = 0;
778         while (temp != 0) {
779             length++;
780             temp >>= 8;
781         }
782         return toHexString(value, length);
783     }
784 
785     /**
786      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
787      */
788     function toHexString(uint256 value, uint256 length)
789         internal
790         pure
791         returns (string memory)
792     {
793         bytes memory buffer = new bytes(2 * length + 2);
794         buffer[0] = "0";
795         buffer[1] = "x";
796         for (uint256 i = 2 * length + 1; i > 1; --i) {
797             buffer[i] = _HEX_SYMBOLS[value & 0xf];
798             value >>= 4;
799         }
800         require(value == 0, "Strings: hex length insufficient");
801         return string(buffer);
802     }
803 }
804 
805 // File: @openzeppelin/contracts/access/IAccessControl.sol
806 
807 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
808 
809 pragma solidity ^0.8.0;
810 
811 /**
812  * @dev External interface of AccessControl declared to support ERC165 detection.
813  */
814 interface IAccessControl {
815     /**
816      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
817      *
818      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
819      * {RoleAdminChanged} not being emitted signaling this.
820      *
821      * _Available since v3.1._
822      */
823     event RoleAdminChanged(
824         bytes32 indexed role,
825         bytes32 indexed previousAdminRole,
826         bytes32 indexed newAdminRole
827     );
828 
829     /**
830      * @dev Emitted when `account` is granted `role`.
831      *
832      * `sender` is the account that originated the contract call, an admin role
833      * bearer except when using {AccessControl-_setupRole}.
834      */
835     event RoleGranted(
836         bytes32 indexed role,
837         address indexed account,
838         address indexed sender
839     );
840 
841     /**
842      * @dev Emitted when `account` is revoked `role`.
843      *
844      * `sender` is the account that originated the contract call:
845      *   - if using `revokeRole`, it is the admin role bearer
846      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
847      */
848     event RoleRevoked(
849         bytes32 indexed role,
850         address indexed account,
851         address indexed sender
852     );
853 
854     /**
855      * @dev Returns `true` if `account` has been granted `role`.
856      */
857     function hasRole(bytes32 role, address account)
858         external
859         view
860         returns (bool);
861 
862     /**
863      * @dev Returns the admin role that controls `role`. See {grantRole} and
864      * {revokeRole}.
865      *
866      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
867      */
868     function getRoleAdmin(bytes32 role) external view returns (bytes32);
869 
870     /**
871      * @dev Grants `role` to `account`.
872      *
873      * If `account` had not been already granted `role`, emits a {RoleGranted}
874      * event.
875      *
876      * Requirements:
877      *
878      * - the caller must have ``role``'s admin role.
879      */
880     function grantRole(bytes32 role, address account) external;
881 
882     /**
883      * @dev Revokes `role` from `account`.
884      *
885      * If `account` had been granted `role`, emits a {RoleRevoked} event.
886      *
887      * Requirements:
888      *
889      * - the caller must have ``role``'s admin role.
890      */
891     function revokeRole(bytes32 role, address account) external;
892 
893     /**
894      * @dev Revokes `role` from the calling account.
895      *
896      * Roles are often managed via {grantRole} and {revokeRole}: this function's
897      * purpose is to provide a mechanism for accounts to lose their privileges
898      * if they are compromised (such as when a trusted device is misplaced).
899      *
900      * If the calling account had been granted `role`, emits a {RoleRevoked}
901      * event.
902      *
903      * Requirements:
904      *
905      * - the caller must be `account`.
906      */
907     function renounceRole(bytes32 role, address account) external;
908 }
909 
910 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
911 
912 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
913 
914 pragma solidity ^0.8.0;
915 
916 /**
917  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
918  */
919 interface IAccessControlEnumerable is IAccessControl {
920     /**
921      * @dev Returns one of the accounts that have `role`. `index` must be a
922      * value between 0 and {getRoleMemberCount}, non-inclusive.
923      *
924      * Role bearers are not sorted in any particular way, and their ordering may
925      * change at any point.
926      *
927      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
928      * you perform all queries on the same block. See the following
929      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
930      * for more information.
931      */
932     function getRoleMember(bytes32 role, uint256 index)
933         external
934         view
935         returns (address);
936 
937     /**
938      * @dev Returns the number of accounts that have `role`. Can be used
939      * together with {getRoleMember} to enumerate all bearers of a role.
940      */
941     function getRoleMemberCount(bytes32 role) external view returns (uint256);
942 }
943 
944 // File: @openzeppelin/contracts/utils/Context.sol
945 
946 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
947 
948 pragma solidity ^0.8.0;
949 
950 /**
951  * @dev Provides information about the current execution context, including the
952  * sender of the transaction and its data. While these are generally available
953  * via msg.sender and msg.data, they should not be accessed in such a direct
954  * manner, since when dealing with meta-transactions the account sending and
955  * paying for execution may not be the actual sender (as far as an application
956  * is concerned).
957  *
958  * This contract is only required for intermediate, library-like contracts.
959  */
960 abstract contract Context {
961     function _msgSender() internal view virtual returns (address) {
962         return msg.sender;
963     }
964 
965     function _msgData() internal view virtual returns (bytes calldata) {
966         return msg.data;
967     }
968 }
969 
970 // File: @openzeppelin/contracts/access/AccessControl.sol
971 
972 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
973 
974 pragma solidity ^0.8.0;
975 
976 /**
977  * @dev Contract module that allows children to implement role-based access
978  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
979  * members except through off-chain means by accessing the contract event logs. Some
980  * applications may benefit from on-chain enumerability, for those cases see
981  * {AccessControlEnumerable}.
982  *
983  * Roles are referred to by their `bytes32` identifier. These should be exposed
984  * in the external API and be unique. The best way to achieve this is by
985  * using `public constant` hash digests:
986  *
987  * ```
988  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
989  * ```
990  *
991  * Roles can be used to represent a set of permissions. To restrict access to a
992  * function call, use {hasRole}:
993  *
994  * ```
995  * function foo() public {
996  *     require(hasRole(MY_ROLE, msg.sender));
997  *     ...
998  * }
999  * ```
1000  *
1001  * Roles can be granted and revoked dynamically via the {grantRole} and
1002  * {revokeRole} functions. Each role has an associated admin role, and only
1003  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1004  *
1005  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1006  * that only accounts with this role will be able to grant or revoke other
1007  * roles. More complex role relationships can be created by using
1008  * {_setRoleAdmin}.
1009  *
1010  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1011  * grant and revoke this role. Extra precautions should be taken to secure
1012  * accounts that have been granted it.
1013  */
1014 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1015     struct RoleData {
1016         mapping(address => bool) members;
1017         bytes32 adminRole;
1018     }
1019 
1020     mapping(bytes32 => RoleData) private _roles;
1021 
1022     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1023 
1024     /**
1025      * @dev Modifier that checks that an account has a specific role. Reverts
1026      * with a standardized message including the required role.
1027      *
1028      * The format of the revert reason is given by the following regular expression:
1029      *
1030      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1031      *
1032      * _Available since v4.1._
1033      */
1034     modifier onlyRole(bytes32 role) {
1035         _checkRole(role, _msgSender());
1036         _;
1037     }
1038 
1039     /**
1040      * @dev See {IERC165-supportsInterface}.
1041      */
1042     function supportsInterface(bytes4 interfaceId)
1043         public
1044         view
1045         virtual
1046         override
1047         returns (bool)
1048     {
1049         return
1050             interfaceId == type(IAccessControl).interfaceId ||
1051             super.supportsInterface(interfaceId);
1052     }
1053 
1054     /**
1055      * @dev Returns `true` if `account` has been granted `role`.
1056      */
1057     function hasRole(bytes32 role, address account)
1058         public
1059         view
1060         virtual
1061         override
1062         returns (bool)
1063     {
1064         return _roles[role].members[account];
1065     }
1066 
1067     /**
1068      * @dev Revert with a standard message if `account` is missing `role`.
1069      *
1070      * The format of the revert reason is given by the following regular expression:
1071      *
1072      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1073      */
1074     function _checkRole(bytes32 role, address account) internal view virtual {
1075         if (!hasRole(role, account)) {
1076             revert(
1077                 string(
1078                     abi.encodePacked(
1079                         "AccessControl: account ",
1080                         Strings.toHexString(uint160(account), 20),
1081                         " is missing role ",
1082                         Strings.toHexString(uint256(role), 32)
1083                     )
1084                 )
1085             );
1086         }
1087     }
1088 
1089     /**
1090      * @dev Returns the admin role that controls `role`. See {grantRole} and
1091      * {revokeRole}.
1092      *
1093      * To change a role's admin, use {_setRoleAdmin}.
1094      */
1095     function getRoleAdmin(bytes32 role)
1096         public
1097         view
1098         virtual
1099         override
1100         returns (bytes32)
1101     {
1102         return _roles[role].adminRole;
1103     }
1104 
1105     /**
1106      * @dev Grants `role` to `account`.
1107      *
1108      * If `account` had not been already granted `role`, emits a {RoleGranted}
1109      * event.
1110      *
1111      * Requirements:
1112      *
1113      * - the caller must have ``role``'s admin role.
1114      */
1115     function grantRole(bytes32 role, address account)
1116         public
1117         virtual
1118         override
1119         onlyRole(getRoleAdmin(role))
1120     {
1121         _grantRole(role, account);
1122     }
1123 
1124     /**
1125      * @dev Revokes `role` from `account`.
1126      *
1127      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1128      *
1129      * Requirements:
1130      *
1131      * - the caller must have ``role``'s admin role.
1132      */
1133     function revokeRole(bytes32 role, address account)
1134         public
1135         virtual
1136         override
1137         onlyRole(getRoleAdmin(role))
1138     {
1139         _revokeRole(role, account);
1140     }
1141 
1142     /**
1143      * @dev Revokes `role` from the calling account.
1144      *
1145      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1146      * purpose is to provide a mechanism for accounts to lose their privileges
1147      * if they are compromised (such as when a trusted device is misplaced).
1148      *
1149      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1150      * event.
1151      *
1152      * Requirements:
1153      *
1154      * - the caller must be `account`.
1155      */
1156     function renounceRole(bytes32 role, address account)
1157         public
1158         virtual
1159         override
1160     {
1161         require(
1162             account == _msgSender(),
1163             "AccessControl: can only renounce roles for self"
1164         );
1165 
1166         _revokeRole(role, account);
1167     }
1168 
1169     /**
1170      * @dev Grants `role` to `account`.
1171      *
1172      * If `account` had not been already granted `role`, emits a {RoleGranted}
1173      * event. Note that unlike {grantRole}, this function doesn't perform any
1174      * checks on the calling account.
1175      *
1176      * [WARNING]
1177      * ====
1178      * This function should only be called from the constructor when setting
1179      * up the initial roles for the system.
1180      *
1181      * Using this function in any other way is effectively circumventing the admin
1182      * system imposed by {AccessControl}.
1183      * ====
1184      *
1185      * NOTE: This function is deprecated in favor of {_grantRole}.
1186      */
1187     function _setupRole(bytes32 role, address account) internal virtual {
1188         _grantRole(role, account);
1189     }
1190 
1191     /**
1192      * @dev Sets `adminRole` as ``role``'s admin role.
1193      *
1194      * Emits a {RoleAdminChanged} event.
1195      */
1196     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1197         bytes32 previousAdminRole = getRoleAdmin(role);
1198         _roles[role].adminRole = adminRole;
1199         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1200     }
1201 
1202     /**
1203      * @dev Grants `role` to `account`.
1204      *
1205      * Internal function without access restriction.
1206      */
1207     function _grantRole(bytes32 role, address account) internal virtual {
1208         if (!hasRole(role, account)) {
1209             _roles[role].members[account] = true;
1210             emit RoleGranted(role, account, _msgSender());
1211         }
1212     }
1213 
1214     /**
1215      * @dev Revokes `role` from `account`.
1216      *
1217      * Internal function without access restriction.
1218      */
1219     function _revokeRole(bytes32 role, address account) internal virtual {
1220         if (hasRole(role, account)) {
1221             _roles[role].members[account] = false;
1222             emit RoleRevoked(role, account, _msgSender());
1223         }
1224     }
1225 }
1226 
1227 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1228 
1229 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1230 
1231 pragma solidity ^0.8.0;
1232 
1233 /**
1234  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1235  */
1236 abstract contract AccessControlEnumerable is
1237     IAccessControlEnumerable,
1238     AccessControl
1239 {
1240     using EnumerableSet for EnumerableSet.AddressSet;
1241 
1242     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1243 
1244     /**
1245      * @dev See {IERC165-supportsInterface}.
1246      */
1247     function supportsInterface(bytes4 interfaceId)
1248         public
1249         view
1250         virtual
1251         override
1252         returns (bool)
1253     {
1254         return
1255             interfaceId == type(IAccessControlEnumerable).interfaceId ||
1256             super.supportsInterface(interfaceId);
1257     }
1258 
1259     /**
1260      * @dev Returns one of the accounts that have `role`. `index` must be a
1261      * value between 0 and {getRoleMemberCount}, non-inclusive.
1262      *
1263      * Role bearers are not sorted in any particular way, and their ordering may
1264      * change at any point.
1265      *
1266      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1267      * you perform all queries on the same block. See the following
1268      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1269      * for more information.
1270      */
1271     function getRoleMember(bytes32 role, uint256 index)
1272         public
1273         view
1274         virtual
1275         override
1276         returns (address)
1277     {
1278         return _roleMembers[role].at(index);
1279     }
1280 
1281     /**
1282      * @dev Returns the number of accounts that have `role`. Can be used
1283      * together with {getRoleMember} to enumerate all bearers of a role.
1284      */
1285     function getRoleMemberCount(bytes32 role)
1286         public
1287         view
1288         virtual
1289         override
1290         returns (uint256)
1291     {
1292         return _roleMembers[role].length();
1293     }
1294 
1295     /**
1296      * @dev Overload {_grantRole} to track enumerable memberships
1297      */
1298     function _grantRole(bytes32 role, address account)
1299         internal
1300         virtual
1301         override
1302     {
1303         super._grantRole(role, account);
1304         _roleMembers[role].add(account);
1305     }
1306 
1307     /**
1308      * @dev Overload {_revokeRole} to track enumerable memberships
1309      */
1310     function _revokeRole(bytes32 role, address account)
1311         internal
1312         virtual
1313         override
1314     {
1315         super._revokeRole(role, account);
1316         _roleMembers[role].remove(account);
1317     }
1318 }
1319 
1320 // File: @openzeppelin/contracts/security/Pausable.sol
1321 
1322 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1323 
1324 pragma solidity ^0.8.0;
1325 
1326 /**
1327  * @dev Contract module which allows children to implement an emergency stop
1328  * mechanism that can be triggered by an authorized account.
1329  *
1330  * This module is used through inheritance. It will make available the
1331  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1332  * the functions of your contract. Note that they will not be pausable by
1333  * simply including this module, only once the modifiers are put in place.
1334  */
1335 abstract contract Pausable is Context {
1336     /**
1337      * @dev Emitted when the pause is triggered by `account`.
1338      */
1339     event Paused(address account);
1340 
1341     /**
1342      * @dev Emitted when the pause is lifted by `account`.
1343      */
1344     event Unpaused(address account);
1345 
1346     bool private _paused;
1347 
1348     /**
1349      * @dev Initializes the contract in unpaused state.
1350      */
1351     constructor() {
1352         _paused = false;
1353     }
1354 
1355     /**
1356      * @dev Returns true if the contract is paused, and false otherwise.
1357      */
1358     function paused() public view virtual returns (bool) {
1359         return _paused;
1360     }
1361 
1362     /**
1363      * @dev Modifier to make a function callable only when the contract is not paused.
1364      *
1365      * Requirements:
1366      *
1367      * - The contract must not be paused.
1368      */
1369     modifier whenNotPaused() {
1370         require(!paused(), "Pausable: paused");
1371         _;
1372     }
1373 
1374     /**
1375      * @dev Modifier to make a function callable only when the contract is paused.
1376      *
1377      * Requirements:
1378      *
1379      * - The contract must be paused.
1380      */
1381     modifier whenPaused() {
1382         require(paused(), "Pausable: not paused");
1383         _;
1384     }
1385 
1386     /**
1387      * @dev Triggers stopped state.
1388      *
1389      * Requirements:
1390      *
1391      * - The contract must not be paused.
1392      */
1393     function _pause() internal virtual whenNotPaused {
1394         _paused = true;
1395         emit Paused(_msgSender());
1396     }
1397 
1398     /**
1399      * @dev Returns to normal state.
1400      *
1401      * Requirements:
1402      *
1403      * - The contract must be paused.
1404      */
1405     function _unpause() internal virtual whenPaused {
1406         _paused = false;
1407         emit Unpaused(_msgSender());
1408     }
1409 }
1410 
1411 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1412 
1413 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1414 
1415 pragma solidity ^0.8.0;
1416 
1417 /**
1418  * @dev Interface of the ERC20 standard as defined in the EIP.
1419  */
1420 interface IERC20 {
1421     /**
1422      * @dev Returns the amount of tokens in existence.
1423      */
1424     function totalSupply() external view returns (uint256);
1425 
1426     /**
1427      * @dev Returns the amount of tokens owned by `account`.
1428      */
1429     function balanceOf(address account) external view returns (uint256);
1430 
1431     /**
1432      * @dev Moves `amount` tokens from the caller's account to `to`.
1433      *
1434      * Returns a boolean value indicating whether the operation succeeded.
1435      *
1436      * Emits a {Transfer} event.
1437      */
1438     function transfer(address to, uint256 amount) external returns (bool);
1439 
1440     /**
1441      * @dev Returns the remaining number of tokens that `spender` will be
1442      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1443      * zero by default.
1444      *
1445      * This value changes when {approve} or {transferFrom} are called.
1446      */
1447     function allowance(address owner, address spender)
1448         external
1449         view
1450         returns (uint256);
1451 
1452     /**
1453      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1454      *
1455      * Returns a boolean value indicating whether the operation succeeded.
1456      *
1457      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1458      * that someone may use both the old and the new allowance by unfortunate
1459      * transaction ordering. One possible solution to mitigate this race
1460      * condition is to first reduce the spender's allowance to 0 and set the
1461      * desired value afterwards:
1462      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1463      *
1464      * Emits an {Approval} event.
1465      */
1466     function approve(address spender, uint256 amount) external returns (bool);
1467 
1468     /**
1469      * @dev Moves `amount` tokens from `from` to `to` using the
1470      * allowance mechanism. `amount` is then deducted from the caller's
1471      * allowance.
1472      *
1473      * Returns a boolean value indicating whether the operation succeeded.
1474      *
1475      * Emits a {Transfer} event.
1476      */
1477     function transferFrom(
1478         address from,
1479         address to,
1480         uint256 amount
1481     ) external returns (bool);
1482 
1483     /**
1484      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1485      * another (`to`).
1486      *
1487      * Note that `value` may be zero.
1488      */
1489     event Transfer(address indexed from, address indexed to, uint256 value);
1490 
1491     /**
1492      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1493      * a call to {approve}. `value` is the new allowance.
1494      */
1495     event Approval(
1496         address indexed owner,
1497         address indexed spender,
1498         uint256 value
1499     );
1500 }
1501 
1502 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1503 
1504 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1505 
1506 pragma solidity ^0.8.0;
1507 
1508 /**
1509  * @dev Interface for the optional metadata functions from the ERC20 standard.
1510  *
1511  * _Available since v4.1._
1512  */
1513 interface IERC20Metadata is IERC20 {
1514     /**
1515      * @dev Returns the name of the token.
1516      */
1517     function name() external view returns (string memory);
1518 
1519     /**
1520      * @dev Returns the symbol of the token.
1521      */
1522     function symbol() external view returns (string memory);
1523 
1524     /**
1525      * @dev Returns the decimals places of the token.
1526      */
1527     function decimals() external view returns (uint8);
1528 }
1529 
1530 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1531 
1532 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
1533 
1534 pragma solidity ^0.8.0;
1535 
1536 /**
1537  * @dev Implementation of the {IERC20} interface.
1538  *
1539  * This implementation is agnostic to the way tokens are created. This means
1540  * that a supply mechanism has to be added in a derived contract using {_mint}.
1541  * For a generic mechanism see {ERC20PresetMinterPauser}.
1542  *
1543  * TIP: For a detailed writeup see our guide
1544  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1545  * to implement supply mechanisms].
1546  *
1547  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1548  * instead returning `false` on failure. This behavior is nonetheless
1549  * conventional and does not conflict with the expectations of ERC20
1550  * applications.
1551  *
1552  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1553  * This allows applications to reconstruct the allowance for all accounts just
1554  * by listening to said events. Other implementations of the EIP may not emit
1555  * these events, as it isn't required by the specification.
1556  *
1557  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1558  * functions have been added to mitigate the well-known issues around setting
1559  * allowances. See {IERC20-approve}.
1560  */
1561 contract ERC20 is Context, IERC20, IERC20Metadata {
1562     mapping(address => uint256) private _balances;
1563 
1564     mapping(address => mapping(address => uint256)) private _allowances;
1565 
1566     uint256 private _totalSupply;
1567 
1568     string private _name;
1569     string private _symbol;
1570 
1571     /**
1572      * @dev Sets the values for {name} and {symbol}.
1573      *
1574      * The default value of {decimals} is 18. To select a different value for
1575      * {decimals} you should overload it.
1576      *
1577      * All two of these values are immutable: they can only be set once during
1578      * construction.
1579      */
1580     constructor(string memory name_, string memory symbol_) {
1581         _name = name_;
1582         _symbol = symbol_;
1583     }
1584 
1585     /**
1586      * @dev Returns the name of the token.
1587      */
1588     function name() public view virtual override returns (string memory) {
1589         return _name;
1590     }
1591 
1592     /**
1593      * @dev Returns the symbol of the token, usually a shorter version of the
1594      * name.
1595      */
1596     function symbol() public view virtual override returns (string memory) {
1597         return _symbol;
1598     }
1599 
1600     /**
1601      * @dev Returns the number of decimals used to get its user representation.
1602      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1603      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1604      *
1605      * Tokens usually opt for a value of 18, imitating the relationship between
1606      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1607      * overridden;
1608      *
1609      * NOTE: This information is only used for _display_ purposes: it in
1610      * no way affects any of the arithmetic of the contract, including
1611      * {IERC20-balanceOf} and {IERC20-transfer}.
1612      */
1613     function decimals() public view virtual override returns (uint8) {
1614         return 18;
1615     }
1616 
1617     /**
1618      * @dev See {IERC20-totalSupply}.
1619      */
1620     function totalSupply() public view virtual override returns (uint256) {
1621         return _totalSupply;
1622     }
1623 
1624     /**
1625      * @dev See {IERC20-balanceOf}.
1626      */
1627     function balanceOf(address account)
1628         public
1629         view
1630         virtual
1631         override
1632         returns (uint256)
1633     {
1634         return _balances[account];
1635     }
1636 
1637     /**
1638      * @dev See {IERC20-transfer}.
1639      *
1640      * Requirements:
1641      *
1642      * - `to` cannot be the zero address.
1643      * - the caller must have a balance of at least `amount`.
1644      */
1645     function transfer(address to, uint256 amount)
1646         public
1647         virtual
1648         override
1649         returns (bool)
1650     {
1651         address owner = _msgSender();
1652         _transfer(owner, to, amount);
1653         return true;
1654     }
1655 
1656     /**
1657      * @dev See {IERC20-allowance}.
1658      */
1659     function allowance(address owner, address spender)
1660         public
1661         view
1662         virtual
1663         override
1664         returns (uint256)
1665     {
1666         return _allowances[owner][spender];
1667     }
1668 
1669     /**
1670      * @dev See {IERC20-approve}.
1671      *
1672      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1673      * `transferFrom`. This is semantically equivalent to an infinite approval.
1674      *
1675      * Requirements:
1676      *
1677      * - `spender` cannot be the zero address.
1678      */
1679     function approve(address spender, uint256 amount)
1680         public
1681         virtual
1682         override
1683         returns (bool)
1684     {
1685         address owner = _msgSender();
1686         _approve(owner, spender, amount);
1687         return true;
1688     }
1689 
1690     /**
1691      * @dev See {IERC20-transferFrom}.
1692      *
1693      * Emits an {Approval} event indicating the updated allowance. This is not
1694      * required by the EIP. See the note at the beginning of {ERC20}.
1695      *
1696      * NOTE: Does not update the allowance if the current allowance
1697      * is the maximum `uint256`.
1698      *
1699      * Requirements:
1700      *
1701      * - `from` and `to` cannot be the zero address.
1702      * - `from` must have a balance of at least `amount`.
1703      * - the caller must have allowance for ``from``'s tokens of at least
1704      * `amount`.
1705      */
1706     function transferFrom(
1707         address from,
1708         address to,
1709         uint256 amount
1710     ) public virtual override returns (bool) {
1711         address spender = _msgSender();
1712         _spendAllowance(from, spender, amount);
1713         _transfer(from, to, amount);
1714         return true;
1715     }
1716 
1717     /**
1718      * @dev Atomically increases the allowance granted to `spender` by the caller.
1719      *
1720      * This is an alternative to {approve} that can be used as a mitigation for
1721      * problems described in {IERC20-approve}.
1722      *
1723      * Emits an {Approval} event indicating the updated allowance.
1724      *
1725      * Requirements:
1726      *
1727      * - `spender` cannot be the zero address.
1728      */
1729     function increaseAllowance(address spender, uint256 addedValue)
1730         public
1731         virtual
1732         returns (bool)
1733     {
1734         address owner = _msgSender();
1735         _approve(owner, spender, _allowances[owner][spender] + addedValue);
1736         return true;
1737     }
1738 
1739     /**
1740      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1741      *
1742      * This is an alternative to {approve} that can be used as a mitigation for
1743      * problems described in {IERC20-approve}.
1744      *
1745      * Emits an {Approval} event indicating the updated allowance.
1746      *
1747      * Requirements:
1748      *
1749      * - `spender` cannot be the zero address.
1750      * - `spender` must have allowance for the caller of at least
1751      * `subtractedValue`.
1752      */
1753     function decreaseAllowance(address spender, uint256 subtractedValue)
1754         public
1755         virtual
1756         returns (bool)
1757     {
1758         address owner = _msgSender();
1759         uint256 currentAllowance = _allowances[owner][spender];
1760         require(
1761             currentAllowance >= subtractedValue,
1762             "ERC20: decreased allowance below zero"
1763         );
1764         unchecked {
1765             _approve(owner, spender, currentAllowance - subtractedValue);
1766         }
1767 
1768         return true;
1769     }
1770 
1771     /**
1772      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1773      *
1774      * This internal function is equivalent to {transfer}, and can be used to
1775      * e.g. implement automatic token fees, slashing mechanisms, etc.
1776      *
1777      * Emits a {Transfer} event.
1778      *
1779      * Requirements:
1780      *
1781      * - `from` cannot be the zero address.
1782      * - `to` cannot be the zero address.
1783      * - `from` must have a balance of at least `amount`.
1784      */
1785     function _transfer(
1786         address from,
1787         address to,
1788         uint256 amount
1789     ) internal virtual {
1790         require(from != address(0), "ERC20: transfer from the zero address");
1791         require(to != address(0), "ERC20: transfer to the zero address");
1792 
1793         _beforeTokenTransfer(from, to, amount);
1794 
1795         uint256 fromBalance = _balances[from];
1796         require(
1797             fromBalance >= amount,
1798             "ERC20: transfer amount exceeds balance"
1799         );
1800         unchecked {
1801             _balances[from] = fromBalance - amount;
1802         }
1803         _balances[to] += amount;
1804 
1805         emit Transfer(from, to, amount);
1806 
1807         _afterTokenTransfer(from, to, amount);
1808     }
1809 
1810     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1811      * the total supply.
1812      *
1813      * Emits a {Transfer} event with `from` set to the zero address.
1814      *
1815      * Requirements:
1816      *
1817      * - `account` cannot be the zero address.
1818      */
1819     function _mint(address account, uint256 amount) internal virtual {
1820         require(account != address(0), "ERC20: mint to the zero address");
1821 
1822         _beforeTokenTransfer(address(0), account, amount);
1823 
1824         _totalSupply += amount;
1825         _balances[account] += amount;
1826         emit Transfer(address(0), account, amount);
1827 
1828         _afterTokenTransfer(address(0), account, amount);
1829     }
1830 
1831     /**
1832      * @dev Destroys `amount` tokens from `account`, reducing the
1833      * total supply.
1834      *
1835      * Emits a {Transfer} event with `to` set to the zero address.
1836      *
1837      * Requirements:
1838      *
1839      * - `account` cannot be the zero address.
1840      * - `account` must have at least `amount` tokens.
1841      */
1842     function _burn(address account, uint256 amount) internal virtual {
1843         require(account != address(0), "ERC20: burn from the zero address");
1844 
1845         _beforeTokenTransfer(account, address(0), amount);
1846 
1847         uint256 accountBalance = _balances[account];
1848         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1849         unchecked {
1850             _balances[account] = accountBalance - amount;
1851         }
1852         _totalSupply -= amount;
1853 
1854         emit Transfer(account, address(0), amount);
1855 
1856         _afterTokenTransfer(account, address(0), amount);
1857     }
1858 
1859     /**
1860      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1861      *
1862      * This internal function is equivalent to `approve`, and can be used to
1863      * e.g. set automatic allowances for certain subsystems, etc.
1864      *
1865      * Emits an {Approval} event.
1866      *
1867      * Requirements:
1868      *
1869      * - `owner` cannot be the zero address.
1870      * - `spender` cannot be the zero address.
1871      */
1872     function _approve(
1873         address owner,
1874         address spender,
1875         uint256 amount
1876     ) internal virtual {
1877         require(owner != address(0), "ERC20: approve from the zero address");
1878         require(spender != address(0), "ERC20: approve to the zero address");
1879 
1880         _allowances[owner][spender] = amount;
1881         emit Approval(owner, spender, amount);
1882     }
1883 
1884     /**
1885      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1886      *
1887      * Does not update the allowance amount in case of infinite allowance.
1888      * Revert if not enough allowance is available.
1889      *
1890      * Might emit an {Approval} event.
1891      */
1892     function _spendAllowance(
1893         address owner,
1894         address spender,
1895         uint256 amount
1896     ) internal virtual {
1897         uint256 currentAllowance = allowance(owner, spender);
1898         if (currentAllowance != type(uint256).max) {
1899             require(
1900                 currentAllowance >= amount,
1901                 "ERC20: insufficient allowance"
1902             );
1903             unchecked {
1904                 _approve(owner, spender, currentAllowance - amount);
1905             }
1906         }
1907     }
1908 
1909     /**
1910      * @dev Hook that is called before any transfer of tokens. This includes
1911      * minting and burning.
1912      *
1913      * Calling conditions:
1914      *
1915      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1916      * will be transferred to `to`.
1917      * - when `from` is zero, `amount` tokens will be minted for `to`.
1918      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1919      * - `from` and `to` are never both zero.
1920      *
1921      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1922      */
1923     function _beforeTokenTransfer(
1924         address from,
1925         address to,
1926         uint256 amount
1927     ) internal virtual {}
1928 
1929     /**
1930      * @dev Hook that is called after any transfer of tokens. This includes
1931      * minting and burning.
1932      *
1933      * Calling conditions:
1934      *
1935      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1936      * has been transferred to `to`.
1937      * - when `from` is zero, `amount` tokens have been minted for `to`.
1938      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1939      * - `from` and `to` are never both zero.
1940      *
1941      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1942      */
1943     function _afterTokenTransfer(
1944         address from,
1945         address to,
1946         uint256 amount
1947     ) internal virtual {}
1948 }
1949 
1950 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol
1951 
1952 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Pausable.sol)
1953 
1954 pragma solidity ^0.8.0;
1955 
1956 /**
1957  * @dev ERC20 token with pausable token transfers, minting and burning.
1958  *
1959  * Useful for scenarios such as preventing trades until the end of an evaluation
1960  * period, or having an emergency switch for freezing all token transfers in the
1961  * event of a large bug.
1962  */
1963 abstract contract ERC20Pausable is ERC20, Pausable {
1964     /**
1965      * @dev See {ERC20-_beforeTokenTransfer}.
1966      *
1967      * Requirements:
1968      *
1969      * - the contract must not be paused.
1970      */
1971     function _beforeTokenTransfer(
1972         address from,
1973         address to,
1974         uint256 amount
1975     ) internal virtual override {
1976         super._beforeTokenTransfer(from, to, amount);
1977 
1978         require(!paused(), "ERC20Pausable: token transfer while paused");
1979     }
1980 }
1981 
1982 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1983 
1984 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1985 
1986 pragma solidity ^0.8.0;
1987 
1988 /**
1989  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1990  * tokens and those that they have an allowance for, in a way that can be
1991  * recognized off-chain (via event analysis).
1992  */
1993 abstract contract ERC20Burnable is Context, ERC20 {
1994     /**
1995      * @dev Destroys `amount` tokens from the caller.
1996      *
1997      * See {ERC20-_burn}.
1998      */
1999     function burn(uint256 amount) public virtual {
2000         _burn(_msgSender(), amount);
2001     }
2002 
2003     /**
2004      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
2005      * allowance.
2006      *
2007      * See {ERC20-_burn} and {ERC20-allowance}.
2008      *
2009      * Requirements:
2010      *
2011      * - the caller must have allowance for ``accounts``'s tokens of at least
2012      * `amount`.
2013      */
2014     function burnFrom(address account, uint256 amount) public virtual {
2015         _spendAllowance(account, _msgSender(), amount);
2016         _burn(account, amount);
2017     }
2018 }
2019 
2020 // File: @openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol
2021 
2022 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/presets/ERC20PresetMinterPauser.sol)
2023 
2024 pragma solidity ^0.8.0;
2025 
2026 /**
2027  * @dev {ERC20} token, including:
2028  *
2029  *  - ability for holders to burn (destroy) their tokens
2030  *  - a minter role that allows for token minting (creation)
2031  *  - a pauser role that allows to stop all token transfers
2032  *
2033  * This contract uses {AccessControl} to lock permissioned functions using the
2034  * different roles - head to its documentation for details.
2035  *
2036  * The account that deploys the contract will be granted the minter and pauser
2037  * roles, as well as the default admin role, which will let it grant both minter
2038  * and pauser roles to other accounts.
2039  *
2040  * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
2041  */
2042 contract ERC20PresetMinterPauser is
2043     Context,
2044     AccessControlEnumerable,
2045     ERC20Burnable,
2046     ERC20Pausable
2047 {
2048     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2049     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2050 
2051     /**
2052      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2053      * account that deploys the contract.
2054      *
2055      * See {ERC20-constructor}.
2056      */
2057     constructor(string memory name, string memory symbol) ERC20(name, symbol) {
2058         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2059 
2060         _setupRole(MINTER_ROLE, _msgSender());
2061         _setupRole(PAUSER_ROLE, _msgSender());
2062     }
2063 
2064     /**
2065      * @dev Creates `amount` new tokens for `to`.
2066      *
2067      * See {ERC20-_mint}.
2068      *
2069      * Requirements:
2070      *
2071      * - the caller must have the `MINTER_ROLE`.
2072      */
2073     function mint(address to, uint256 amount) public virtual {
2074         require(
2075             hasRole(MINTER_ROLE, _msgSender()),
2076             "ERC20PresetMinterPauser: must have minter role to mint"
2077         );
2078         _mint(to, amount);
2079     }
2080 
2081     /**
2082      * @dev Pauses all token transfers.
2083      *
2084      * See {ERC20Pausable} and {Pausable-_pause}.
2085      *
2086      * Requirements:
2087      *
2088      * - the caller must have the `PAUSER_ROLE`.
2089      */
2090     function pause() public virtual {
2091         require(
2092             hasRole(PAUSER_ROLE, _msgSender()),
2093             "ERC20PresetMinterPauser: must have pauser role to pause"
2094         );
2095         _pause();
2096     }
2097 
2098     /**
2099      * @dev Unpauses all token transfers.
2100      *
2101      * See {ERC20Pausable} and {Pausable-_unpause}.
2102      *
2103      * Requirements:
2104      *
2105      * - the caller must have the `PAUSER_ROLE`.
2106      */
2107     function unpause() public virtual {
2108         require(
2109             hasRole(PAUSER_ROLE, _msgSender()),
2110             "ERC20PresetMinterPauser: must have pauser role to unpause"
2111         );
2112         _unpause();
2113     }
2114 
2115     function _beforeTokenTransfer(
2116         address from,
2117         address to,
2118         uint256 amount
2119     ) internal virtual override(ERC20, ERC20Pausable) {
2120         super._beforeTokenTransfer(from, to, amount);
2121     }
2122 }
2123 
2124 // File: contracts/StarToken.sol
2125 
2126 pragma solidity >=0.8.0 <0.9.0;
2127 
2128 interface INFTContract {
2129     function balanceOf(address _user) external view returns (uint256);
2130 }
2131 
2132 contract StarToken is ERC20PresetMinterPauser {
2133     using SafeMath for uint256;
2134 
2135     INFTContract public nftContract;
2136 
2137     uint256 public constant INITIAL_REWARD = 100 ether;
2138     uint256 public constant REWARD_RATE = 10 ether;
2139     uint256 public constant SECONDARY_REWARD_RATE = 5 ether;
2140     // Monday, April 1, 2032 0:00:00
2141     uint256 public constant REWARD_END = 1964390400;
2142 
2143     mapping(address => uint256) public rewards;
2144     mapping(address => uint256) public lastUpdate;
2145     mapping(address => INFTContract) public secondaryContracts;
2146     address[] public secondaryContractsAddresses;
2147 
2148     event StarClaimed(address indexed account, uint256 reward);
2149     event StarSpent(address indexed account, uint256 amount);
2150 
2151     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
2152 
2153     constructor(address _nftContract)
2154         ERC20PresetMinterPauser("Star Token", "STAR")
2155     {
2156         grantRole(BURNER_ROLE, msg.sender);
2157         setContract(_nftContract);
2158     }
2159 
2160     function setContract(address _contract) public {
2161         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Admin only");
2162         nftContract = INFTContract(_contract);
2163         grantRole(BURNER_ROLE, _contract);
2164     }
2165 
2166     function addSecondaryContract(address _contract) public {
2167         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Admin only");
2168         secondaryContracts[_contract] = INFTContract(_contract);
2169         secondaryContractsAddresses.push(_contract);
2170         grantRole(BURNER_ROLE, _contract);
2171     }
2172 
2173     function removeSecondaryContract(address _contract) public {
2174         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Admin only");
2175         delete secondaryContracts[_contract];
2176         uint256 index = 0;
2177         while (secondaryContractsAddresses[index] != _contract) {
2178             index++;
2179         }
2180         secondaryContractsAddresses[index] = secondaryContractsAddresses[
2181             secondaryContractsAddresses.length - 1
2182         ];
2183         secondaryContractsAddresses.pop();
2184         revokeRole(BURNER_ROLE, _contract);
2185     }
2186 
2187     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2188         return a < b ? a : b;
2189     }
2190 
2191     function updateRewardOnMint(address _to, uint256 _amount) external {
2192         require(msg.sender == address(nftContract), "Not allowed");
2193         uint256 time = min(block.timestamp, REWARD_END);
2194         uint256 timerUser = lastUpdate[_to];
2195         if (timerUser > 0)
2196             rewards[_to] = rewards[_to].add(
2197                 nftContract
2198                     .balanceOf(_to)
2199                     .mul(REWARD_RATE.mul((time.sub(timerUser))))
2200                     .div(86400)
2201                     .add(_amount.mul(INITIAL_REWARD))
2202             );
2203         else rewards[_to] = rewards[_to].add(_amount.mul(INITIAL_REWARD));
2204         lastUpdate[_to] = time;
2205     }
2206 
2207     function updateReward(address _from, address _to) external {
2208         require(
2209             msg.sender == address(nftContract) ||
2210                 abi.encodePacked(secondaryContracts[msg.sender]).length > 0,
2211             "Invalid Contract"
2212         );
2213         uint256 time = min(block.timestamp, REWARD_END);
2214         if (_from != address(0)) {
2215             uint256 timerFrom = lastUpdate[_from];
2216             if (timerFrom > 0) {
2217                 rewards[_from] += getPendingReward(_from);
2218             }
2219             lastUpdate[_from] = lastUpdate[_from] < REWARD_END
2220                 ? time
2221                 : REWARD_END;
2222         }
2223 
2224         if (_to != address(0)) {
2225             uint256 timerTo = lastUpdate[_to];
2226             if (timerTo > 0) {
2227                 rewards[_to] += getPendingReward(_to);
2228             }
2229             lastUpdate[_to] = lastUpdate[_to] < REWARD_END ? time : REWARD_END;
2230         }
2231     }
2232 
2233     function getReward(address _to) external {
2234         require(msg.sender == address(nftContract), "Not allowed");
2235         uint256 reward = rewards[_to];
2236         if (reward > 0) {
2237             rewards[_to] = 0;
2238             _mint(_to, reward);
2239             emit StarClaimed(_to, reward);
2240         }
2241     }
2242 
2243     function getTotalClaimable(address _account)
2244         external
2245         view
2246         returns (uint256)
2247     {
2248         return rewards[_account] + getPendingReward(_account);
2249     }
2250 
2251     function getPendingReward(address _account)
2252         internal
2253         view
2254         returns (uint256)
2255     {
2256         uint256 time = min(block.timestamp, REWARD_END);
2257         uint256 secondary = 0;
2258         if (secondaryContractsAddresses.length > 0) {
2259             for (uint256 i = 0; i < secondaryContractsAddresses.length; i++) {
2260                 secondary = secondaryContracts[secondaryContractsAddresses[i]]
2261                     .balanceOf(_account)
2262                     .mul(
2263                         SECONDARY_REWARD_RATE.mul(
2264                             (time.sub(lastUpdate[_account]))
2265                         )
2266                     )
2267                     .div(86400)
2268                     .add(secondary);
2269             }
2270         }
2271 
2272         return
2273             nftContract
2274                 .balanceOf(_account)
2275                 .mul(REWARD_RATE.mul((time.sub(lastUpdate[_account]))))
2276                 .div(86400)
2277                 .add(secondary);
2278     }
2279 
2280     function burn(uint256 value) public override {
2281         require(
2282             hasRole(BURNER_ROLE, msg.sender),
2283             "Must have burner role to burn"
2284         );
2285         super._burn(msg.sender, value);
2286     }
2287 
2288     function spend(address _from, uint256 _amount) external {
2289         require(
2290             hasRole(BURNER_ROLE, msg.sender),
2291             "Must have burner role to spend"
2292         );
2293         super._burn(_from, _amount);
2294         emit StarSpent(_from, _amount);
2295     }
2296 }