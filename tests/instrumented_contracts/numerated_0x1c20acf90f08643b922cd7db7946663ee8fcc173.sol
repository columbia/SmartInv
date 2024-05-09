1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Counters.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @title Counters
240  * @author Matt Condon (@shrugs)
241  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
242  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
243  *
244  * Include with `using Counters for Counters.Counter;`
245  */
246 library Counters {
247     struct Counter {
248         // This variable should never be directly accessed by users of the library: interactions must be restricted to
249         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
250         // this feature: see https://github.com/ethereum/solidity/issues/4637
251         uint256 _value; // default: 0
252     }
253 
254     function current(Counter storage counter) internal view returns (uint256) {
255         return counter._value;
256     }
257 
258     function increment(Counter storage counter) internal {
259         unchecked {
260             counter._value += 1;
261         }
262     }
263 
264     function decrement(Counter storage counter) internal {
265         uint256 value = counter._value;
266         require(value > 0, "Counter: decrement overflow");
267         unchecked {
268             counter._value = value - 1;
269         }
270     }
271 
272     function reset(Counter storage counter) internal {
273         counter._value = 0;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
278 
279 
280 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev Library for managing
286  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
287  * types.
288  *
289  * Sets have the following properties:
290  *
291  * - Elements are added, removed, and checked for existence in constant time
292  * (O(1)).
293  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
294  *
295  * ```
296  * contract Example {
297  *     // Add the library methods
298  *     using EnumerableSet for EnumerableSet.AddressSet;
299  *
300  *     // Declare a set state variable
301  *     EnumerableSet.AddressSet private mySet;
302  * }
303  * ```
304  *
305  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
306  * and `uint256` (`UintSet`) are supported.
307  *
308  * [WARNING]
309  * ====
310  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
311  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
312  *
313  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
314  * ====
315  */
316 library EnumerableSet {
317     // To implement this library for multiple types with as little code
318     // repetition as possible, we write it in terms of a generic Set type with
319     // bytes32 values.
320     // The Set implementation uses private functions, and user-facing
321     // implementations (such as AddressSet) are just wrappers around the
322     // underlying Set.
323     // This means that we can only create new EnumerableSets for types that fit
324     // in bytes32.
325 
326     struct Set {
327         // Storage of set values
328         bytes32[] _values;
329         // Position of the value in the `values` array, plus 1 because index 0
330         // means a value is not in the set.
331         mapping(bytes32 => uint256) _indexes;
332     }
333 
334     /**
335      * @dev Add a value to a set. O(1).
336      *
337      * Returns true if the value was added to the set, that is if it was not
338      * already present.
339      */
340     function _add(Set storage set, bytes32 value) private returns (bool) {
341         if (!_contains(set, value)) {
342             set._values.push(value);
343             // The value is stored at length-1, but we add 1 to all indexes
344             // and use 0 as a sentinel value
345             set._indexes[value] = set._values.length;
346             return true;
347         } else {
348             return false;
349         }
350     }
351 
352     /**
353      * @dev Removes a value from a set. O(1).
354      *
355      * Returns true if the value was removed from the set, that is if it was
356      * present.
357      */
358     function _remove(Set storage set, bytes32 value) private returns (bool) {
359         // We read and store the value's index to prevent multiple reads from the same storage slot
360         uint256 valueIndex = set._indexes[value];
361 
362         if (valueIndex != 0) {
363             // Equivalent to contains(set, value)
364             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
365             // the array, and then remove the last element (sometimes called as 'swap and pop').
366             // This modifies the order of the array, as noted in {at}.
367 
368             uint256 toDeleteIndex = valueIndex - 1;
369             uint256 lastIndex = set._values.length - 1;
370 
371             if (lastIndex != toDeleteIndex) {
372                 bytes32 lastValue = set._values[lastIndex];
373 
374                 // Move the last value to the index where the value to delete is
375                 set._values[toDeleteIndex] = lastValue;
376                 // Update the index for the moved value
377                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
378             }
379 
380             // Delete the slot where the moved value was stored
381             set._values.pop();
382 
383             // Delete the index for the deleted slot
384             delete set._indexes[value];
385 
386             return true;
387         } else {
388             return false;
389         }
390     }
391 
392     /**
393      * @dev Returns true if the value is in the set. O(1).
394      */
395     function _contains(Set storage set, bytes32 value) private view returns (bool) {
396         return set._indexes[value] != 0;
397     }
398 
399     /**
400      * @dev Returns the number of values on the set. O(1).
401      */
402     function _length(Set storage set) private view returns (uint256) {
403         return set._values.length;
404     }
405 
406     /**
407      * @dev Returns the value stored at position `index` in the set. O(1).
408      *
409      * Note that there are no guarantees on the ordering of values inside the
410      * array, and it may change when more values are added or removed.
411      *
412      * Requirements:
413      *
414      * - `index` must be strictly less than {length}.
415      */
416     function _at(Set storage set, uint256 index) private view returns (bytes32) {
417         return set._values[index];
418     }
419 
420     /**
421      * @dev Return the entire set in an array
422      *
423      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
424      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
425      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
426      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
427      */
428     function _values(Set storage set) private view returns (bytes32[] memory) {
429         return set._values;
430     }
431 
432     // Bytes32Set
433 
434     struct Bytes32Set {
435         Set _inner;
436     }
437 
438     /**
439      * @dev Add a value to a set. O(1).
440      *
441      * Returns true if the value was added to the set, that is if it was not
442      * already present.
443      */
444     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
445         return _add(set._inner, value);
446     }
447 
448     /**
449      * @dev Removes a value from a set. O(1).
450      *
451      * Returns true if the value was removed from the set, that is if it was
452      * present.
453      */
454     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
455         return _remove(set._inner, value);
456     }
457 
458     /**
459      * @dev Returns true if the value is in the set. O(1).
460      */
461     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
462         return _contains(set._inner, value);
463     }
464 
465     /**
466      * @dev Returns the number of values in the set. O(1).
467      */
468     function length(Bytes32Set storage set) internal view returns (uint256) {
469         return _length(set._inner);
470     }
471 
472     /**
473      * @dev Returns the value stored at position `index` in the set. O(1).
474      *
475      * Note that there are no guarantees on the ordering of values inside the
476      * array, and it may change when more values are added or removed.
477      *
478      * Requirements:
479      *
480      * - `index` must be strictly less than {length}.
481      */
482     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
483         return _at(set._inner, index);
484     }
485 
486     /**
487      * @dev Return the entire set in an array
488      *
489      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
490      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
491      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
492      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
493      */
494     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
495         return _values(set._inner);
496     }
497 
498     // AddressSet
499 
500     struct AddressSet {
501         Set _inner;
502     }
503 
504     /**
505      * @dev Add a value to a set. O(1).
506      *
507      * Returns true if the value was added to the set, that is if it was not
508      * already present.
509      */
510     function add(AddressSet storage set, address value) internal returns (bool) {
511         return _add(set._inner, bytes32(uint256(uint160(value))));
512     }
513 
514     /**
515      * @dev Removes a value from a set. O(1).
516      *
517      * Returns true if the value was removed from the set, that is if it was
518      * present.
519      */
520     function remove(AddressSet storage set, address value) internal returns (bool) {
521         return _remove(set._inner, bytes32(uint256(uint160(value))));
522     }
523 
524     /**
525      * @dev Returns true if the value is in the set. O(1).
526      */
527     function contains(AddressSet storage set, address value) internal view returns (bool) {
528         return _contains(set._inner, bytes32(uint256(uint160(value))));
529     }
530 
531     /**
532      * @dev Returns the number of values in the set. O(1).
533      */
534     function length(AddressSet storage set) internal view returns (uint256) {
535         return _length(set._inner);
536     }
537 
538     /**
539      * @dev Returns the value stored at position `index` in the set. O(1).
540      *
541      * Note that there are no guarantees on the ordering of values inside the
542      * array, and it may change when more values are added or removed.
543      *
544      * Requirements:
545      *
546      * - `index` must be strictly less than {length}.
547      */
548     function at(AddressSet storage set, uint256 index) internal view returns (address) {
549         return address(uint160(uint256(_at(set._inner, index))));
550     }
551 
552     /**
553      * @dev Return the entire set in an array
554      *
555      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
556      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
557      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
558      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
559      */
560     function values(AddressSet storage set) internal view returns (address[] memory) {
561         bytes32[] memory store = _values(set._inner);
562         address[] memory result;
563 
564         /// @solidity memory-safe-assembly
565         assembly {
566             result := store
567         }
568 
569         return result;
570     }
571 
572     // UintSet
573 
574     struct UintSet {
575         Set _inner;
576     }
577 
578     /**
579      * @dev Add a value to a set. O(1).
580      *
581      * Returns true if the value was added to the set, that is if it was not
582      * already present.
583      */
584     function add(UintSet storage set, uint256 value) internal returns (bool) {
585         return _add(set._inner, bytes32(value));
586     }
587 
588     /**
589      * @dev Removes a value from a set. O(1).
590      *
591      * Returns true if the value was removed from the set, that is if it was
592      * present.
593      */
594     function remove(UintSet storage set, uint256 value) internal returns (bool) {
595         return _remove(set._inner, bytes32(value));
596     }
597 
598     /**
599      * @dev Returns true if the value is in the set. O(1).
600      */
601     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
602         return _contains(set._inner, bytes32(value));
603     }
604 
605     /**
606      * @dev Returns the number of values on the set. O(1).
607      */
608     function length(UintSet storage set) internal view returns (uint256) {
609         return _length(set._inner);
610     }
611 
612     /**
613      * @dev Returns the value stored at position `index` in the set. O(1).
614      *
615      * Note that there are no guarantees on the ordering of values inside the
616      * array, and it may change when more values are added or removed.
617      *
618      * Requirements:
619      *
620      * - `index` must be strictly less than {length}.
621      */
622     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
623         return uint256(_at(set._inner, index));
624     }
625 
626     /**
627      * @dev Return the entire set in an array
628      *
629      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
630      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
631      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
632      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
633      */
634     function values(UintSet storage set) internal view returns (uint256[] memory) {
635         bytes32[] memory store = _values(set._inner);
636         uint256[] memory result;
637 
638         /// @solidity memory-safe-assembly
639         assembly {
640             result := store
641         }
642 
643         return result;
644     }
645 }
646 
647 // File: @openzeppelin/contracts/access/IAccessControl.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 /**
655  * @dev External interface of AccessControl declared to support ERC165 detection.
656  */
657 interface IAccessControl {
658     /**
659      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
660      *
661      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
662      * {RoleAdminChanged} not being emitted signaling this.
663      *
664      * _Available since v3.1._
665      */
666     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
667 
668     /**
669      * @dev Emitted when `account` is granted `role`.
670      *
671      * `sender` is the account that originated the contract call, an admin role
672      * bearer except when using {AccessControl-_setupRole}.
673      */
674     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
675 
676     /**
677      * @dev Emitted when `account` is revoked `role`.
678      *
679      * `sender` is the account that originated the contract call:
680      *   - if using `revokeRole`, it is the admin role bearer
681      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
682      */
683     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
684 
685     /**
686      * @dev Returns `true` if `account` has been granted `role`.
687      */
688     function hasRole(bytes32 role, address account) external view returns (bool);
689 
690     /**
691      * @dev Returns the admin role that controls `role`. See {grantRole} and
692      * {revokeRole}.
693      *
694      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
695      */
696     function getRoleAdmin(bytes32 role) external view returns (bytes32);
697 
698     /**
699      * @dev Grants `role` to `account`.
700      *
701      * If `account` had not been already granted `role`, emits a {RoleGranted}
702      * event.
703      *
704      * Requirements:
705      *
706      * - the caller must have ``role``'s admin role.
707      */
708     function grantRole(bytes32 role, address account) external;
709 
710     /**
711      * @dev Revokes `role` from `account`.
712      *
713      * If `account` had been granted `role`, emits a {RoleRevoked} event.
714      *
715      * Requirements:
716      *
717      * - the caller must have ``role``'s admin role.
718      */
719     function revokeRole(bytes32 role, address account) external;
720 
721     /**
722      * @dev Revokes `role` from the calling account.
723      *
724      * Roles are often managed via {grantRole} and {revokeRole}: this function's
725      * purpose is to provide a mechanism for accounts to lose their privileges
726      * if they are compromised (such as when a trusted device is misplaced).
727      *
728      * If the calling account had been granted `role`, emits a {RoleRevoked}
729      * event.
730      *
731      * Requirements:
732      *
733      * - the caller must be `account`.
734      */
735     function renounceRole(bytes32 role, address account) external;
736 }
737 
738 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
739 
740 
741 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 
746 /**
747  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
748  */
749 interface IAccessControlEnumerable is IAccessControl {
750     /**
751      * @dev Returns one of the accounts that have `role`. `index` must be a
752      * value between 0 and {getRoleMemberCount}, non-inclusive.
753      *
754      * Role bearers are not sorted in any particular way, and their ordering may
755      * change at any point.
756      *
757      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
758      * you perform all queries on the same block. See the following
759      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
760      * for more information.
761      */
762     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
763 
764     /**
765      * @dev Returns the number of accounts that have `role`. Can be used
766      * together with {getRoleMember} to enumerate all bearers of a role.
767      */
768     function getRoleMemberCount(bytes32 role) external view returns (uint256);
769 }
770 
771 // File: @openzeppelin/contracts/utils/Strings.sol
772 
773 
774 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
775 
776 pragma solidity ^0.8.0;
777 
778 /**
779  * @dev String operations.
780  */
781 library Strings {
782     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
783     uint8 private constant _ADDRESS_LENGTH = 20;
784 
785     /**
786      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
787      */
788     function toString(uint256 value) internal pure returns (string memory) {
789         // Inspired by OraclizeAPI's implementation - MIT licence
790         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
791 
792         if (value == 0) {
793             return "0";
794         }
795         uint256 temp = value;
796         uint256 digits;
797         while (temp != 0) {
798             digits++;
799             temp /= 10;
800         }
801         bytes memory buffer = new bytes(digits);
802         while (value != 0) {
803             digits -= 1;
804             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
805             value /= 10;
806         }
807         return string(buffer);
808     }
809 
810     /**
811      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
812      */
813     function toHexString(uint256 value) internal pure returns (string memory) {
814         if (value == 0) {
815             return "0x00";
816         }
817         uint256 temp = value;
818         uint256 length = 0;
819         while (temp != 0) {
820             length++;
821             temp >>= 8;
822         }
823         return toHexString(value, length);
824     }
825 
826     /**
827      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
828      */
829     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
830         bytes memory buffer = new bytes(2 * length + 2);
831         buffer[0] = "0";
832         buffer[1] = "x";
833         for (uint256 i = 2 * length + 1; i > 1; --i) {
834             buffer[i] = _HEX_SYMBOLS[value & 0xf];
835             value >>= 4;
836         }
837         require(value == 0, "Strings: hex length insufficient");
838         return string(buffer);
839     }
840 
841     /**
842      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
843      */
844     function toHexString(address addr) internal pure returns (string memory) {
845         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
846     }
847 }
848 
849 // File: @openzeppelin/contracts/utils/Context.sol
850 
851 
852 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
853 
854 pragma solidity ^0.8.0;
855 
856 /**
857  * @dev Provides information about the current execution context, including the
858  * sender of the transaction and its data. While these are generally available
859  * via msg.sender and msg.data, they should not be accessed in such a direct
860  * manner, since when dealing with meta-transactions the account sending and
861  * paying for execution may not be the actual sender (as far as an application
862  * is concerned).
863  *
864  * This contract is only required for intermediate, library-like contracts.
865  */
866 abstract contract Context {
867     function _msgSender() internal view virtual returns (address) {
868         return msg.sender;
869     }
870 
871     function _msgData() internal view virtual returns (bytes calldata) {
872         return msg.data;
873     }
874 }
875 
876 // File: @openzeppelin/contracts/access/Ownable.sol
877 
878 
879 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 
884 /**
885  * @dev Contract module which provides a basic access control mechanism, where
886  * there is an account (an owner) that can be granted exclusive access to
887  * specific functions.
888  *
889  * By default, the owner account will be the one that deploys the contract. This
890  * can later be changed with {transferOwnership}.
891  *
892  * This module is used through inheritance. It will make available the modifier
893  * `onlyOwner`, which can be applied to your functions to restrict their use to
894  * the owner.
895  */
896 abstract contract Ownable is Context {
897     address private _owner;
898 
899     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
900 
901     /**
902      * @dev Initializes the contract setting the deployer as the initial owner.
903      */
904     constructor() {
905         _transferOwnership(_msgSender());
906     }
907 
908     /**
909      * @dev Throws if called by any account other than the owner.
910      */
911     modifier onlyOwner() {
912         _checkOwner();
913         _;
914     }
915 
916     /**
917      * @dev Returns the address of the current owner.
918      */
919     function owner() public view virtual returns (address) {
920         return _owner;
921     }
922 
923     /**
924      * @dev Throws if the sender is not the owner.
925      */
926     function _checkOwner() internal view virtual {
927         require(owner() == _msgSender(), "Ownable: caller is not the owner");
928     }
929 
930     /**
931      * @dev Leaves the contract without owner. It will not be possible to call
932      * `onlyOwner` functions anymore. Can only be called by the current owner.
933      *
934      * NOTE: Renouncing ownership will leave the contract without an owner,
935      * thereby removing any functionality that is only available to the owner.
936      */
937     function renounceOwnership() public virtual onlyOwner {
938         _transferOwnership(address(0));
939     }
940 
941     /**
942      * @dev Transfers ownership of the contract to a new account (`newOwner`).
943      * Can only be called by the current owner.
944      */
945     function transferOwnership(address newOwner) public virtual onlyOwner {
946         require(newOwner != address(0), "Ownable: new owner is the zero address");
947         _transferOwnership(newOwner);
948     }
949 
950     /**
951      * @dev Transfers ownership of the contract to a new account (`newOwner`).
952      * Internal function without access restriction.
953      */
954     function _transferOwnership(address newOwner) internal virtual {
955         address oldOwner = _owner;
956         _owner = newOwner;
957         emit OwnershipTransferred(oldOwner, newOwner);
958     }
959 }
960 
961 // File: @openzeppelin/contracts/security/Pausable.sol
962 
963 
964 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
965 
966 pragma solidity ^0.8.0;
967 
968 
969 /**
970  * @dev Contract module which allows children to implement an emergency stop
971  * mechanism that can be triggered by an authorized account.
972  *
973  * This module is used through inheritance. It will make available the
974  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
975  * the functions of your contract. Note that they will not be pausable by
976  * simply including this module, only once the modifiers are put in place.
977  */
978 abstract contract Pausable is Context {
979     /**
980      * @dev Emitted when the pause is triggered by `account`.
981      */
982     event Paused(address account);
983 
984     /**
985      * @dev Emitted when the pause is lifted by `account`.
986      */
987     event Unpaused(address account);
988 
989     bool private _paused;
990 
991     /**
992      * @dev Initializes the contract in unpaused state.
993      */
994     constructor() {
995         _paused = false;
996     }
997 
998     /**
999      * @dev Modifier to make a function callable only when the contract is not paused.
1000      *
1001      * Requirements:
1002      *
1003      * - The contract must not be paused.
1004      */
1005     modifier whenNotPaused() {
1006         _requireNotPaused();
1007         _;
1008     }
1009 
1010     /**
1011      * @dev Modifier to make a function callable only when the contract is paused.
1012      *
1013      * Requirements:
1014      *
1015      * - The contract must be paused.
1016      */
1017     modifier whenPaused() {
1018         _requirePaused();
1019         _;
1020     }
1021 
1022     /**
1023      * @dev Returns true if the contract is paused, and false otherwise.
1024      */
1025     function paused() public view virtual returns (bool) {
1026         return _paused;
1027     }
1028 
1029     /**
1030      * @dev Throws if the contract is paused.
1031      */
1032     function _requireNotPaused() internal view virtual {
1033         require(!paused(), "Pausable: paused");
1034     }
1035 
1036     /**
1037      * @dev Throws if the contract is not paused.
1038      */
1039     function _requirePaused() internal view virtual {
1040         require(paused(), "Pausable: not paused");
1041     }
1042 
1043     /**
1044      * @dev Triggers stopped state.
1045      *
1046      * Requirements:
1047      *
1048      * - The contract must not be paused.
1049      */
1050     function _pause() internal virtual whenNotPaused {
1051         _paused = true;
1052         emit Paused(_msgSender());
1053     }
1054 
1055     /**
1056      * @dev Returns to normal state.
1057      *
1058      * Requirements:
1059      *
1060      * - The contract must be paused.
1061      */
1062     function _unpause() internal virtual whenPaused {
1063         _paused = false;
1064         emit Unpaused(_msgSender());
1065     }
1066 }
1067 
1068 // File: @openzeppelin/contracts/utils/Address.sol
1069 
1070 
1071 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1072 
1073 pragma solidity ^0.8.1;
1074 
1075 /**
1076  * @dev Collection of functions related to the address type
1077  */
1078 library Address {
1079     /**
1080      * @dev Returns true if `account` is a contract.
1081      *
1082      * [IMPORTANT]
1083      * ====
1084      * It is unsafe to assume that an address for which this function returns
1085      * false is an externally-owned account (EOA) and not a contract.
1086      *
1087      * Among others, `isContract` will return false for the following
1088      * types of addresses:
1089      *
1090      *  - an externally-owned account
1091      *  - a contract in construction
1092      *  - an address where a contract will be created
1093      *  - an address where a contract lived, but was destroyed
1094      * ====
1095      *
1096      * [IMPORTANT]
1097      * ====
1098      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1099      *
1100      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1101      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1102      * constructor.
1103      * ====
1104      */
1105     function isContract(address account) internal view returns (bool) {
1106         // This method relies on extcodesize/address.code.length, which returns 0
1107         // for contracts in construction, since the code is only stored at the end
1108         // of the constructor execution.
1109 
1110         return account.code.length > 0;
1111     }
1112 
1113     /**
1114      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1115      * `recipient`, forwarding all available gas and reverting on errors.
1116      *
1117      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1118      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1119      * imposed by `transfer`, making them unable to receive funds via
1120      * `transfer`. {sendValue} removes this limitation.
1121      *
1122      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1123      *
1124      * IMPORTANT: because control is transferred to `recipient`, care must be
1125      * taken to not create reentrancy vulnerabilities. Consider using
1126      * {ReentrancyGuard} or the
1127      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1128      */
1129     function sendValue(address payable recipient, uint256 amount) internal {
1130         require(address(this).balance >= amount, "Address: insufficient balance");
1131 
1132         (bool success, ) = recipient.call{value: amount}("");
1133         require(success, "Address: unable to send value, recipient may have reverted");
1134     }
1135 
1136     /**
1137      * @dev Performs a Solidity function call using a low level `call`. A
1138      * plain `call` is an unsafe replacement for a function call: use this
1139      * function instead.
1140      *
1141      * If `target` reverts with a revert reason, it is bubbled up by this
1142      * function (like regular Solidity function calls).
1143      *
1144      * Returns the raw returned data. To convert to the expected return value,
1145      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1146      *
1147      * Requirements:
1148      *
1149      * - `target` must be a contract.
1150      * - calling `target` with `data` must not revert.
1151      *
1152      * _Available since v3.1._
1153      */
1154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1155         return functionCall(target, data, "Address: low-level call failed");
1156     }
1157 
1158     /**
1159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1160      * `errorMessage` as a fallback revert reason when `target` reverts.
1161      *
1162      * _Available since v3.1._
1163      */
1164     function functionCall(
1165         address target,
1166         bytes memory data,
1167         string memory errorMessage
1168     ) internal returns (bytes memory) {
1169         return functionCallWithValue(target, data, 0, errorMessage);
1170     }
1171 
1172     /**
1173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1174      * but also transferring `value` wei to `target`.
1175      *
1176      * Requirements:
1177      *
1178      * - the calling contract must have an ETH balance of at least `value`.
1179      * - the called Solidity function must be `payable`.
1180      *
1181      * _Available since v3.1._
1182      */
1183     function functionCallWithValue(
1184         address target,
1185         bytes memory data,
1186         uint256 value
1187     ) internal returns (bytes memory) {
1188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1189     }
1190 
1191     /**
1192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1193      * with `errorMessage` as a fallback revert reason when `target` reverts.
1194      *
1195      * _Available since v3.1._
1196      */
1197     function functionCallWithValue(
1198         address target,
1199         bytes memory data,
1200         uint256 value,
1201         string memory errorMessage
1202     ) internal returns (bytes memory) {
1203         require(address(this).balance >= value, "Address: insufficient balance for call");
1204         require(isContract(target), "Address: call to non-contract");
1205 
1206         (bool success, bytes memory returndata) = target.call{value: value}(data);
1207         return verifyCallResult(success, returndata, errorMessage);
1208     }
1209 
1210     /**
1211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1212      * but performing a static call.
1213      *
1214      * _Available since v3.3._
1215      */
1216     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1217         return functionStaticCall(target, data, "Address: low-level static call failed");
1218     }
1219 
1220     /**
1221      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1222      * but performing a static call.
1223      *
1224      * _Available since v3.3._
1225      */
1226     function functionStaticCall(
1227         address target,
1228         bytes memory data,
1229         string memory errorMessage
1230     ) internal view returns (bytes memory) {
1231         require(isContract(target), "Address: static call to non-contract");
1232 
1233         (bool success, bytes memory returndata) = target.staticcall(data);
1234         return verifyCallResult(success, returndata, errorMessage);
1235     }
1236 
1237     /**
1238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1239      * but performing a delegate call.
1240      *
1241      * _Available since v3.4._
1242      */
1243     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1244         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1245     }
1246 
1247     /**
1248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1249      * but performing a delegate call.
1250      *
1251      * _Available since v3.4._
1252      */
1253     function functionDelegateCall(
1254         address target,
1255         bytes memory data,
1256         string memory errorMessage
1257     ) internal returns (bytes memory) {
1258         require(isContract(target), "Address: delegate call to non-contract");
1259 
1260         (bool success, bytes memory returndata) = target.delegatecall(data);
1261         return verifyCallResult(success, returndata, errorMessage);
1262     }
1263 
1264     /**
1265      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1266      * revert reason using the provided one.
1267      *
1268      * _Available since v4.3._
1269      */
1270     function verifyCallResult(
1271         bool success,
1272         bytes memory returndata,
1273         string memory errorMessage
1274     ) internal pure returns (bytes memory) {
1275         if (success) {
1276             return returndata;
1277         } else {
1278             // Look for revert reason and bubble it up if present
1279             if (returndata.length > 0) {
1280                 // The easiest way to bubble the revert reason is using memory via assembly
1281                 /// @solidity memory-safe-assembly
1282                 assembly {
1283                     let returndata_size := mload(returndata)
1284                     revert(add(32, returndata), returndata_size)
1285                 }
1286             } else {
1287                 revert(errorMessage);
1288             }
1289         }
1290     }
1291 }
1292 
1293 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1294 
1295 
1296 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1297 
1298 pragma solidity ^0.8.0;
1299 
1300 /**
1301  * @title ERC721 token receiver interface
1302  * @dev Interface for any contract that wants to support safeTransfers
1303  * from ERC721 asset contracts.
1304  */
1305 interface IERC721Receiver {
1306     /**
1307      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1308      * by `operator` from `from`, this function is called.
1309      *
1310      * It must return its Solidity selector to confirm the token transfer.
1311      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1312      *
1313      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1314      */
1315     function onERC721Received(
1316         address operator,
1317         address from,
1318         uint256 tokenId,
1319         bytes calldata data
1320     ) external returns (bytes4);
1321 }
1322 
1323 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1324 
1325 
1326 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1327 
1328 pragma solidity ^0.8.0;
1329 
1330 /**
1331  * @dev Interface of the ERC165 standard, as defined in the
1332  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1333  *
1334  * Implementers can declare support of contract interfaces, which can then be
1335  * queried by others ({ERC165Checker}).
1336  *
1337  * For an implementation, see {ERC165}.
1338  */
1339 interface IERC165 {
1340     /**
1341      * @dev Returns true if this contract implements the interface defined by
1342      * `interfaceId`. See the corresponding
1343      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1344      * to learn more about how these ids are created.
1345      *
1346      * This function call must use less than 30 000 gas.
1347      */
1348     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1349 }
1350 
1351 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1352 
1353 
1354 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1355 
1356 pragma solidity ^0.8.0;
1357 
1358 
1359 /**
1360  * @dev Implementation of the {IERC165} interface.
1361  *
1362  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1363  * for the additional interface id that will be supported. For example:
1364  *
1365  * ```solidity
1366  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1367  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1368  * }
1369  * ```
1370  *
1371  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1372  */
1373 abstract contract ERC165 is IERC165 {
1374     /**
1375      * @dev See {IERC165-supportsInterface}.
1376      */
1377     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1378         return interfaceId == type(IERC165).interfaceId;
1379     }
1380 }
1381 
1382 // File: @openzeppelin/contracts/access/AccessControl.sol
1383 
1384 
1385 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1386 
1387 pragma solidity ^0.8.0;
1388 
1389 
1390 
1391 
1392 
1393 /**
1394  * @dev Contract module that allows children to implement role-based access
1395  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1396  * members except through off-chain means by accessing the contract event logs. Some
1397  * applications may benefit from on-chain enumerability, for those cases see
1398  * {AccessControlEnumerable}.
1399  *
1400  * Roles are referred to by their `bytes32` identifier. These should be exposed
1401  * in the external API and be unique. The best way to achieve this is by
1402  * using `public constant` hash digests:
1403  *
1404  * ```
1405  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1406  * ```
1407  *
1408  * Roles can be used to represent a set of permissions. To restrict access to a
1409  * function call, use {hasRole}:
1410  *
1411  * ```
1412  * function foo() public {
1413  *     require(hasRole(MY_ROLE, msg.sender));
1414  *     ...
1415  * }
1416  * ```
1417  *
1418  * Roles can be granted and revoked dynamically via the {grantRole} and
1419  * {revokeRole} functions. Each role has an associated admin role, and only
1420  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1421  *
1422  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1423  * that only accounts with this role will be able to grant or revoke other
1424  * roles. More complex role relationships can be created by using
1425  * {_setRoleAdmin}.
1426  *
1427  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1428  * grant and revoke this role. Extra precautions should be taken to secure
1429  * accounts that have been granted it.
1430  */
1431 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1432     struct RoleData {
1433         mapping(address => bool) members;
1434         bytes32 adminRole;
1435     }
1436 
1437     mapping(bytes32 => RoleData) private _roles;
1438 
1439     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1440 
1441     /**
1442      * @dev Modifier that checks that an account has a specific role. Reverts
1443      * with a standardized message including the required role.
1444      *
1445      * The format of the revert reason is given by the following regular expression:
1446      *
1447      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1448      *
1449      * _Available since v4.1._
1450      */
1451     modifier onlyRole(bytes32 role) {
1452         _checkRole(role);
1453         _;
1454     }
1455 
1456     /**
1457      * @dev See {IERC165-supportsInterface}.
1458      */
1459     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1460         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1461     }
1462 
1463     /**
1464      * @dev Returns `true` if `account` has been granted `role`.
1465      */
1466     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1467         return _roles[role].members[account];
1468     }
1469 
1470     /**
1471      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1472      * Overriding this function changes the behavior of the {onlyRole} modifier.
1473      *
1474      * Format of the revert message is described in {_checkRole}.
1475      *
1476      * _Available since v4.6._
1477      */
1478     function _checkRole(bytes32 role) internal view virtual {
1479         _checkRole(role, _msgSender());
1480     }
1481 
1482     /**
1483      * @dev Revert with a standard message if `account` is missing `role`.
1484      *
1485      * The format of the revert reason is given by the following regular expression:
1486      *
1487      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1488      */
1489     function _checkRole(bytes32 role, address account) internal view virtual {
1490         if (!hasRole(role, account)) {
1491             revert(
1492                 string(
1493                     abi.encodePacked(
1494                         "AccessControl: account ",
1495                         Strings.toHexString(uint160(account), 20),
1496                         " is missing role ",
1497                         Strings.toHexString(uint256(role), 32)
1498                     )
1499                 )
1500             );
1501         }
1502     }
1503 
1504     /**
1505      * @dev Returns the admin role that controls `role`. See {grantRole} and
1506      * {revokeRole}.
1507      *
1508      * To change a role's admin, use {_setRoleAdmin}.
1509      */
1510     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1511         return _roles[role].adminRole;
1512     }
1513 
1514     /**
1515      * @dev Grants `role` to `account`.
1516      *
1517      * If `account` had not been already granted `role`, emits a {RoleGranted}
1518      * event.
1519      *
1520      * Requirements:
1521      *
1522      * - the caller must have ``role``'s admin role.
1523      *
1524      * May emit a {RoleGranted} event.
1525      */
1526     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1527         _grantRole(role, account);
1528     }
1529 
1530     /**
1531      * @dev Revokes `role` from `account`.
1532      *
1533      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1534      *
1535      * Requirements:
1536      *
1537      * - the caller must have ``role``'s admin role.
1538      *
1539      * May emit a {RoleRevoked} event.
1540      */
1541     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1542         _revokeRole(role, account);
1543     }
1544 
1545     /**
1546      * @dev Revokes `role` from the calling account.
1547      *
1548      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1549      * purpose is to provide a mechanism for accounts to lose their privileges
1550      * if they are compromised (such as when a trusted device is misplaced).
1551      *
1552      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1553      * event.
1554      *
1555      * Requirements:
1556      *
1557      * - the caller must be `account`.
1558      *
1559      * May emit a {RoleRevoked} event.
1560      */
1561     function renounceRole(bytes32 role, address account) public virtual override {
1562         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1563 
1564         _revokeRole(role, account);
1565     }
1566 
1567     /**
1568      * @dev Grants `role` to `account`.
1569      *
1570      * If `account` had not been already granted `role`, emits a {RoleGranted}
1571      * event. Note that unlike {grantRole}, this function doesn't perform any
1572      * checks on the calling account.
1573      *
1574      * May emit a {RoleGranted} event.
1575      *
1576      * [WARNING]
1577      * ====
1578      * This function should only be called from the constructor when setting
1579      * up the initial roles for the system.
1580      *
1581      * Using this function in any other way is effectively circumventing the admin
1582      * system imposed by {AccessControl}.
1583      * ====
1584      *
1585      * NOTE: This function is deprecated in favor of {_grantRole}.
1586      */
1587     function _setupRole(bytes32 role, address account) internal virtual {
1588         _grantRole(role, account);
1589     }
1590 
1591     /**
1592      * @dev Sets `adminRole` as ``role``'s admin role.
1593      *
1594      * Emits a {RoleAdminChanged} event.
1595      */
1596     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1597         bytes32 previousAdminRole = getRoleAdmin(role);
1598         _roles[role].adminRole = adminRole;
1599         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1600     }
1601 
1602     /**
1603      * @dev Grants `role` to `account`.
1604      *
1605      * Internal function without access restriction.
1606      *
1607      * May emit a {RoleGranted} event.
1608      */
1609     function _grantRole(bytes32 role, address account) internal virtual {
1610         if (!hasRole(role, account)) {
1611             _roles[role].members[account] = true;
1612             emit RoleGranted(role, account, _msgSender());
1613         }
1614     }
1615 
1616     /**
1617      * @dev Revokes `role` from `account`.
1618      *
1619      * Internal function without access restriction.
1620      *
1621      * May emit a {RoleRevoked} event.
1622      */
1623     function _revokeRole(bytes32 role, address account) internal virtual {
1624         if (hasRole(role, account)) {
1625             _roles[role].members[account] = false;
1626             emit RoleRevoked(role, account, _msgSender());
1627         }
1628     }
1629 }
1630 
1631 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1632 
1633 
1634 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1635 
1636 pragma solidity ^0.8.0;
1637 
1638 
1639 
1640 
1641 /**
1642  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1643  */
1644 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1645     using EnumerableSet for EnumerableSet.AddressSet;
1646 
1647     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1648 
1649     /**
1650      * @dev See {IERC165-supportsInterface}.
1651      */
1652     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1653         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1654     }
1655 
1656     /**
1657      * @dev Returns one of the accounts that have `role`. `index` must be a
1658      * value between 0 and {getRoleMemberCount}, non-inclusive.
1659      *
1660      * Role bearers are not sorted in any particular way, and their ordering may
1661      * change at any point.
1662      *
1663      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1664      * you perform all queries on the same block. See the following
1665      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1666      * for more information.
1667      */
1668     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1669         return _roleMembers[role].at(index);
1670     }
1671 
1672     /**
1673      * @dev Returns the number of accounts that have `role`. Can be used
1674      * together with {getRoleMember} to enumerate all bearers of a role.
1675      */
1676     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1677         return _roleMembers[role].length();
1678     }
1679 
1680     /**
1681      * @dev Overload {_grantRole} to track enumerable memberships
1682      */
1683     function _grantRole(bytes32 role, address account) internal virtual override {
1684         super._grantRole(role, account);
1685         _roleMembers[role].add(account);
1686     }
1687 
1688     /**
1689      * @dev Overload {_revokeRole} to track enumerable memberships
1690      */
1691     function _revokeRole(bytes32 role, address account) internal virtual override {
1692         super._revokeRole(role, account);
1693         _roleMembers[role].remove(account);
1694     }
1695 }
1696 
1697 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1698 
1699 
1700 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1701 
1702 pragma solidity ^0.8.0;
1703 
1704 
1705 /**
1706  * @dev Required interface of an ERC721 compliant contract.
1707  */
1708 interface IERC721 is IERC165 {
1709     /**
1710      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1711      */
1712     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1713 
1714     /**
1715      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1716      */
1717     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1718 
1719     /**
1720      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1721      */
1722     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1723 
1724     /**
1725      * @dev Returns the number of tokens in ``owner``'s account.
1726      */
1727     function balanceOf(address owner) external view returns (uint256 balance);
1728 
1729     /**
1730      * @dev Returns the owner of the `tokenId` token.
1731      *
1732      * Requirements:
1733      *
1734      * - `tokenId` must exist.
1735      */
1736     function ownerOf(uint256 tokenId) external view returns (address owner);
1737 
1738     /**
1739      * @dev Safely transfers `tokenId` token from `from` to `to`.
1740      *
1741      * Requirements:
1742      *
1743      * - `from` cannot be the zero address.
1744      * - `to` cannot be the zero address.
1745      * - `tokenId` token must exist and be owned by `from`.
1746      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1747      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1748      *
1749      * Emits a {Transfer} event.
1750      */
1751     function safeTransferFrom(
1752         address from,
1753         address to,
1754         uint256 tokenId,
1755         bytes calldata data
1756     ) external;
1757 
1758     /**
1759      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1760      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1761      *
1762      * Requirements:
1763      *
1764      * - `from` cannot be the zero address.
1765      * - `to` cannot be the zero address.
1766      * - `tokenId` token must exist and be owned by `from`.
1767      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1769      *
1770      * Emits a {Transfer} event.
1771      */
1772     function safeTransferFrom(
1773         address from,
1774         address to,
1775         uint256 tokenId
1776     ) external;
1777 
1778     /**
1779      * @dev Transfers `tokenId` token from `from` to `to`.
1780      *
1781      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1782      *
1783      * Requirements:
1784      *
1785      * - `from` cannot be the zero address.
1786      * - `to` cannot be the zero address.
1787      * - `tokenId` token must be owned by `from`.
1788      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1789      *
1790      * Emits a {Transfer} event.
1791      */
1792     function transferFrom(
1793         address from,
1794         address to,
1795         uint256 tokenId
1796     ) external;
1797 
1798     /**
1799      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1800      * The approval is cleared when the token is transferred.
1801      *
1802      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1803      *
1804      * Requirements:
1805      *
1806      * - The caller must own the token or be an approved operator.
1807      * - `tokenId` must exist.
1808      *
1809      * Emits an {Approval} event.
1810      */
1811     function approve(address to, uint256 tokenId) external;
1812 
1813     /**
1814      * @dev Approve or remove `operator` as an operator for the caller.
1815      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1816      *
1817      * Requirements:
1818      *
1819      * - The `operator` cannot be the caller.
1820      *
1821      * Emits an {ApprovalForAll} event.
1822      */
1823     function setApprovalForAll(address operator, bool _approved) external;
1824 
1825     /**
1826      * @dev Returns the account approved for `tokenId` token.
1827      *
1828      * Requirements:
1829      *
1830      * - `tokenId` must exist.
1831      */
1832     function getApproved(uint256 tokenId) external view returns (address operator);
1833 
1834     /**
1835      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1836      *
1837      * See {setApprovalForAll}
1838      */
1839     function isApprovedForAll(address owner, address operator) external view returns (bool);
1840 }
1841 
1842 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1843 
1844 
1845 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1846 
1847 pragma solidity ^0.8.0;
1848 
1849 
1850 /**
1851  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1852  * @dev See https://eips.ethereum.org/EIPS/eip-721
1853  */
1854 interface IERC721Enumerable is IERC721 {
1855     /**
1856      * @dev Returns the total amount of tokens stored by the contract.
1857      */
1858     function totalSupply() external view returns (uint256);
1859 
1860     /**
1861      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1862      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1863      */
1864     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1865 
1866     /**
1867      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1868      * Use along with {totalSupply} to enumerate all tokens.
1869      */
1870     function tokenByIndex(uint256 index) external view returns (uint256);
1871 }
1872 
1873 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1874 
1875 
1876 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1877 
1878 pragma solidity ^0.8.0;
1879 
1880 
1881 /**
1882  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1883  * @dev See https://eips.ethereum.org/EIPS/eip-721
1884  */
1885 interface IERC721Metadata is IERC721 {
1886     /**
1887      * @dev Returns the token collection name.
1888      */
1889     function name() external view returns (string memory);
1890 
1891     /**
1892      * @dev Returns the token collection symbol.
1893      */
1894     function symbol() external view returns (string memory);
1895 
1896     /**
1897      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1898      */
1899     function tokenURI(uint256 tokenId) external view returns (string memory);
1900 }
1901 
1902 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1903 
1904 
1905 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1906 
1907 pragma solidity ^0.8.0;
1908 
1909 
1910 
1911 
1912 
1913 
1914 
1915 
1916 /**
1917  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1918  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1919  * {ERC721Enumerable}.
1920  */
1921 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1922     using Address for address;
1923     using Strings for uint256;
1924 
1925     // Token name
1926     string private _name;
1927 
1928     // Token symbol
1929     string private _symbol;
1930 
1931     // Mapping from token ID to owner address
1932     mapping(uint256 => address) private _owners;
1933 
1934     // Mapping owner address to token count
1935     mapping(address => uint256) private _balances;
1936 
1937     // Mapping from token ID to approved address
1938     mapping(uint256 => address) private _tokenApprovals;
1939 
1940     // Mapping from owner to operator approvals
1941     mapping(address => mapping(address => bool)) private _operatorApprovals;
1942 
1943     /**
1944      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1945      */
1946     constructor(string memory name_, string memory symbol_) {
1947         _name = name_;
1948         _symbol = symbol_;
1949     }
1950 
1951     /**
1952      * @dev See {IERC165-supportsInterface}.
1953      */
1954     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1955         return
1956             interfaceId == type(IERC721).interfaceId ||
1957             interfaceId == type(IERC721Metadata).interfaceId ||
1958             super.supportsInterface(interfaceId);
1959     }
1960 
1961     /**
1962      * @dev See {IERC721-balanceOf}.
1963      */
1964     function balanceOf(address owner) public view virtual override returns (uint256) {
1965         require(owner != address(0), "ERC721: address zero is not a valid owner");
1966         return _balances[owner];
1967     }
1968 
1969     /**
1970      * @dev See {IERC721-ownerOf}.
1971      */
1972     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1973         address owner = _owners[tokenId];
1974         require(owner != address(0), "ERC721: invalid token ID");
1975         return owner;
1976     }
1977 
1978     /**
1979      * @dev See {IERC721Metadata-name}.
1980      */
1981     function name() public view virtual override returns (string memory) {
1982         return _name;
1983     }
1984 
1985     /**
1986      * @dev See {IERC721Metadata-symbol}.
1987      */
1988     function symbol() public view virtual override returns (string memory) {
1989         return _symbol;
1990     }
1991 
1992     /**
1993      * @dev See {IERC721Metadata-tokenURI}.
1994      */
1995     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1996         _requireMinted(tokenId);
1997 
1998         string memory baseURI = _baseURI();
1999         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2000     }
2001 
2002     /**
2003      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2004      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2005      * by default, can be overridden in child contracts.
2006      */
2007     function _baseURI() internal view virtual returns (string memory) {
2008         return "";
2009     }
2010 
2011     /**
2012      * @dev See {IERC721-approve}.
2013      */
2014     function approve(address to, uint256 tokenId) public virtual override {
2015         address owner = ERC721.ownerOf(tokenId);
2016         require(to != owner, "ERC721: approval to current owner");
2017 
2018         require(
2019             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2020             "ERC721: approve caller is not token owner nor approved for all"
2021         );
2022 
2023         _approve(to, tokenId);
2024     }
2025 
2026     /**
2027      * @dev See {IERC721-getApproved}.
2028      */
2029     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2030         _requireMinted(tokenId);
2031 
2032         return _tokenApprovals[tokenId];
2033     }
2034 
2035     /**
2036      * @dev See {IERC721-setApprovalForAll}.
2037      */
2038     function setApprovalForAll(address operator, bool approved) public virtual override {
2039         _setApprovalForAll(_msgSender(), operator, approved);
2040     }
2041 
2042     /**
2043      * @dev See {IERC721-isApprovedForAll}.
2044      */
2045     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2046         return _operatorApprovals[owner][operator];
2047     }
2048 
2049     /**
2050      * @dev See {IERC721-transferFrom}.
2051      */
2052     function transferFrom(
2053         address from,
2054         address to,
2055         uint256 tokenId
2056     ) public virtual override {
2057         //solhint-disable-next-line max-line-length
2058         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2059 
2060         _transfer(from, to, tokenId);
2061     }
2062 
2063     /**
2064      * @dev See {IERC721-safeTransferFrom}.
2065      */
2066     function safeTransferFrom(
2067         address from,
2068         address to,
2069         uint256 tokenId
2070     ) public virtual override {
2071         safeTransferFrom(from, to, tokenId, "");
2072     }
2073 
2074     /**
2075      * @dev See {IERC721-safeTransferFrom}.
2076      */
2077     function safeTransferFrom(
2078         address from,
2079         address to,
2080         uint256 tokenId,
2081         bytes memory data
2082     ) public virtual override {
2083         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2084         _safeTransfer(from, to, tokenId, data);
2085     }
2086 
2087     /**
2088      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2089      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2090      *
2091      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2092      *
2093      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2094      * implement alternative mechanisms to perform token transfer, such as signature-based.
2095      *
2096      * Requirements:
2097      *
2098      * - `from` cannot be the zero address.
2099      * - `to` cannot be the zero address.
2100      * - `tokenId` token must exist and be owned by `from`.
2101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2102      *
2103      * Emits a {Transfer} event.
2104      */
2105     function _safeTransfer(
2106         address from,
2107         address to,
2108         uint256 tokenId,
2109         bytes memory data
2110     ) internal virtual {
2111         _transfer(from, to, tokenId);
2112         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2113     }
2114 
2115     /**
2116      * @dev Returns whether `tokenId` exists.
2117      *
2118      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2119      *
2120      * Tokens start existing when they are minted (`_mint`),
2121      * and stop existing when they are burned (`_burn`).
2122      */
2123     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2124         return _owners[tokenId] != address(0);
2125     }
2126 
2127     /**
2128      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2129      *
2130      * Requirements:
2131      *
2132      * - `tokenId` must exist.
2133      */
2134     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2135         address owner = ERC721.ownerOf(tokenId);
2136         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2137     }
2138 
2139     /**
2140      * @dev Safely mints `tokenId` and transfers it to `to`.
2141      *
2142      * Requirements:
2143      *
2144      * - `tokenId` must not exist.
2145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2146      *
2147      * Emits a {Transfer} event.
2148      */
2149     function _safeMint(address to, uint256 tokenId) internal virtual {
2150         _safeMint(to, tokenId, "");
2151     }
2152 
2153     /**
2154      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2155      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2156      */
2157     function _safeMint(
2158         address to,
2159         uint256 tokenId,
2160         bytes memory data
2161     ) internal virtual {
2162         _mint(to, tokenId);
2163         require(
2164             _checkOnERC721Received(address(0), to, tokenId, data),
2165             "ERC721: transfer to non ERC721Receiver implementer"
2166         );
2167     }
2168 
2169     /**
2170      * @dev Mints `tokenId` and transfers it to `to`.
2171      *
2172      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2173      *
2174      * Requirements:
2175      *
2176      * - `tokenId` must not exist.
2177      * - `to` cannot be the zero address.
2178      *
2179      * Emits a {Transfer} event.
2180      */
2181     function _mint(address to, uint256 tokenId) internal virtual {
2182         require(to != address(0), "ERC721: mint to the zero address");
2183         require(!_exists(tokenId), "ERC721: token already minted");
2184 
2185         _beforeTokenTransfer(address(0), to, tokenId);
2186 
2187         _balances[to] += 1;
2188         _owners[tokenId] = to;
2189 
2190         emit Transfer(address(0), to, tokenId);
2191 
2192         _afterTokenTransfer(address(0), to, tokenId);
2193     }
2194 
2195     /**
2196      * @dev Destroys `tokenId`.
2197      * The approval is cleared when the token is burned.
2198      *
2199      * Requirements:
2200      *
2201      * - `tokenId` must exist.
2202      *
2203      * Emits a {Transfer} event.
2204      */
2205     function _burn(uint256 tokenId) internal virtual {
2206         address owner = ERC721.ownerOf(tokenId);
2207 
2208         _beforeTokenTransfer(owner, address(0), tokenId);
2209 
2210         // Clear approvals
2211         _approve(address(0), tokenId);
2212 
2213         _balances[owner] -= 1;
2214         delete _owners[tokenId];
2215 
2216         emit Transfer(owner, address(0), tokenId);
2217 
2218         _afterTokenTransfer(owner, address(0), tokenId);
2219     }
2220 
2221     /**
2222      * @dev Transfers `tokenId` from `from` to `to`.
2223      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2224      *
2225      * Requirements:
2226      *
2227      * - `to` cannot be the zero address.
2228      * - `tokenId` token must be owned by `from`.
2229      *
2230      * Emits a {Transfer} event.
2231      */
2232     function _transfer(
2233         address from,
2234         address to,
2235         uint256 tokenId
2236     ) internal virtual {
2237         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2238         require(to != address(0), "ERC721: transfer to the zero address");
2239 
2240         _beforeTokenTransfer(from, to, tokenId);
2241 
2242         // Clear approvals from the previous owner
2243         _approve(address(0), tokenId);
2244 
2245         _balances[from] -= 1;
2246         _balances[to] += 1;
2247         _owners[tokenId] = to;
2248 
2249         emit Transfer(from, to, tokenId);
2250 
2251         _afterTokenTransfer(from, to, tokenId);
2252     }
2253 
2254     /**
2255      * @dev Approve `to` to operate on `tokenId`
2256      *
2257      * Emits an {Approval} event.
2258      */
2259     function _approve(address to, uint256 tokenId) internal virtual {
2260         _tokenApprovals[tokenId] = to;
2261         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2262     }
2263 
2264     /**
2265      * @dev Approve `operator` to operate on all of `owner` tokens
2266      *
2267      * Emits an {ApprovalForAll} event.
2268      */
2269     function _setApprovalForAll(
2270         address owner,
2271         address operator,
2272         bool approved
2273     ) internal virtual {
2274         require(owner != operator, "ERC721: approve to caller");
2275         _operatorApprovals[owner][operator] = approved;
2276         emit ApprovalForAll(owner, operator, approved);
2277     }
2278 
2279     /**
2280      * @dev Reverts if the `tokenId` has not been minted yet.
2281      */
2282     function _requireMinted(uint256 tokenId) internal view virtual {
2283         require(_exists(tokenId), "ERC721: invalid token ID");
2284     }
2285 
2286     /**
2287      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2288      * The call is not executed if the target address is not a contract.
2289      *
2290      * @param from address representing the previous owner of the given token ID
2291      * @param to target address that will receive the tokens
2292      * @param tokenId uint256 ID of the token to be transferred
2293      * @param data bytes optional data to send along with the call
2294      * @return bool whether the call correctly returned the expected magic value
2295      */
2296     function _checkOnERC721Received(
2297         address from,
2298         address to,
2299         uint256 tokenId,
2300         bytes memory data
2301     ) private returns (bool) {
2302         if (to.isContract()) {
2303             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2304                 return retval == IERC721Receiver.onERC721Received.selector;
2305             } catch (bytes memory reason) {
2306                 if (reason.length == 0) {
2307                     revert("ERC721: transfer to non ERC721Receiver implementer");
2308                 } else {
2309                     /// @solidity memory-safe-assembly
2310                     assembly {
2311                         revert(add(32, reason), mload(reason))
2312                     }
2313                 }
2314             }
2315         } else {
2316             return true;
2317         }
2318     }
2319 
2320     /**
2321      * @dev Hook that is called before any token transfer. This includes minting
2322      * and burning.
2323      *
2324      * Calling conditions:
2325      *
2326      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2327      * transferred to `to`.
2328      * - When `from` is zero, `tokenId` will be minted for `to`.
2329      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2330      * - `from` and `to` are never both zero.
2331      *
2332      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2333      */
2334     function _beforeTokenTransfer(
2335         address from,
2336         address to,
2337         uint256 tokenId
2338     ) internal virtual {}
2339 
2340     /**
2341      * @dev Hook that is called after any transfer of tokens. This includes
2342      * minting and burning.
2343      *
2344      * Calling conditions:
2345      *
2346      * - when `from` and `to` are both non-zero.
2347      * - `from` and `to` are never both zero.
2348      *
2349      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2350      */
2351     function _afterTokenTransfer(
2352         address from,
2353         address to,
2354         uint256 tokenId
2355     ) internal virtual {}
2356 }
2357 
2358 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
2359 
2360 
2361 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
2362 
2363 pragma solidity ^0.8.0;
2364 
2365 
2366 
2367 /**
2368  * @dev ERC721 token with pausable token transfers, minting and burning.
2369  *
2370  * Useful for scenarios such as preventing trades until the end of an evaluation
2371  * period, or having an emergency switch for freezing all token transfers in the
2372  * event of a large bug.
2373  */
2374 abstract contract ERC721Pausable is ERC721, Pausable {
2375     /**
2376      * @dev See {ERC721-_beforeTokenTransfer}.
2377      *
2378      * Requirements:
2379      *
2380      * - the contract must not be paused.
2381      */
2382     function _beforeTokenTransfer(
2383         address from,
2384         address to,
2385         uint256 tokenId
2386     ) internal virtual override {
2387         super._beforeTokenTransfer(from, to, tokenId);
2388 
2389         require(!paused(), "ERC721Pausable: token transfer while paused");
2390     }
2391 }
2392 
2393 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
2394 
2395 
2396 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
2397 
2398 pragma solidity ^0.8.0;
2399 
2400 
2401 
2402 /**
2403  * @title ERC721 Burnable Token
2404  * @dev ERC721 Token that can be burned (destroyed).
2405  */
2406 abstract contract ERC721Burnable is Context, ERC721 {
2407     /**
2408      * @dev Burns `tokenId`. See {ERC721-_burn}.
2409      *
2410      * Requirements:
2411      *
2412      * - The caller must own `tokenId` or be an approved operator.
2413      */
2414     function burn(uint256 tokenId) public virtual {
2415         //solhint-disable-next-line max-line-length
2416         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2417         _burn(tokenId);
2418     }
2419 }
2420 
2421 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2422 
2423 
2424 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
2425 
2426 pragma solidity ^0.8.0;
2427 
2428 
2429 
2430 /**
2431  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2432  * enumerability of all the token ids in the contract as well as all token ids owned by each
2433  * account.
2434  */
2435 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2436     // Mapping from owner to list of owned token IDs
2437     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2438 
2439     // Mapping from token ID to index of the owner tokens list
2440     mapping(uint256 => uint256) private _ownedTokensIndex;
2441 
2442     // Array with all token ids, used for enumeration
2443     uint256[] private _allTokens;
2444 
2445     // Mapping from token id to position in the allTokens array
2446     mapping(uint256 => uint256) private _allTokensIndex;
2447 
2448     /**
2449      * @dev See {IERC165-supportsInterface}.
2450      */
2451     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2452         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2453     }
2454 
2455     /**
2456      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2457      */
2458     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2459         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2460         return _ownedTokens[owner][index];
2461     }
2462 
2463     /**
2464      * @dev See {IERC721Enumerable-totalSupply}.
2465      */
2466     function totalSupply() public view virtual override returns (uint256) {
2467         return _allTokens.length;
2468     }
2469 
2470     /**
2471      * @dev See {IERC721Enumerable-tokenByIndex}.
2472      */
2473     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2474         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2475         return _allTokens[index];
2476     }
2477 
2478     /**
2479      * @dev Hook that is called before any token transfer. This includes minting
2480      * and burning.
2481      *
2482      * Calling conditions:
2483      *
2484      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2485      * transferred to `to`.
2486      * - When `from` is zero, `tokenId` will be minted for `to`.
2487      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2488      * - `from` cannot be the zero address.
2489      * - `to` cannot be the zero address.
2490      *
2491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2492      */
2493     function _beforeTokenTransfer(
2494         address from,
2495         address to,
2496         uint256 tokenId
2497     ) internal virtual override {
2498         super._beforeTokenTransfer(from, to, tokenId);
2499 
2500         if (from == address(0)) {
2501             _addTokenToAllTokensEnumeration(tokenId);
2502         } else if (from != to) {
2503             _removeTokenFromOwnerEnumeration(from, tokenId);
2504         }
2505         if (to == address(0)) {
2506             _removeTokenFromAllTokensEnumeration(tokenId);
2507         } else if (to != from) {
2508             _addTokenToOwnerEnumeration(to, tokenId);
2509         }
2510     }
2511 
2512     /**
2513      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2514      * @param to address representing the new owner of the given token ID
2515      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2516      */
2517     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2518         uint256 length = ERC721.balanceOf(to);
2519         _ownedTokens[to][length] = tokenId;
2520         _ownedTokensIndex[tokenId] = length;
2521     }
2522 
2523     /**
2524      * @dev Private function to add a token to this extension's token tracking data structures.
2525      * @param tokenId uint256 ID of the token to be added to the tokens list
2526      */
2527     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2528         _allTokensIndex[tokenId] = _allTokens.length;
2529         _allTokens.push(tokenId);
2530     }
2531 
2532     /**
2533      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2534      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2535      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2536      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2537      * @param from address representing the previous owner of the given token ID
2538      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2539      */
2540     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2541         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2542         // then delete the last slot (swap and pop).
2543 
2544         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2545         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2546 
2547         // When the token to delete is the last token, the swap operation is unnecessary
2548         if (tokenIndex != lastTokenIndex) {
2549             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2550 
2551             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2552             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2553         }
2554 
2555         // This also deletes the contents at the last position of the array
2556         delete _ownedTokensIndex[tokenId];
2557         delete _ownedTokens[from][lastTokenIndex];
2558     }
2559 
2560     /**
2561      * @dev Private function to remove a token from this extension's token tracking data structures.
2562      * This has O(1) time complexity, but alters the order of the _allTokens array.
2563      * @param tokenId uint256 ID of the token to be removed from the tokens list
2564      */
2565     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2566         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2567         // then delete the last slot (swap and pop).
2568 
2569         uint256 lastTokenIndex = _allTokens.length - 1;
2570         uint256 tokenIndex = _allTokensIndex[tokenId];
2571 
2572         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2573         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2574         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2575         uint256 lastTokenId = _allTokens[lastTokenIndex];
2576 
2577         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2578         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2579 
2580         // This also deletes the contents at the last position of the array
2581         delete _allTokensIndex[tokenId];
2582         _allTokens.pop();
2583     }
2584 }
2585 
2586 // File: @openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol
2587 
2588 
2589 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol)
2590 
2591 pragma solidity ^0.8.0;
2592 
2593 
2594 
2595 
2596 
2597 
2598 
2599 
2600 /**
2601  * @dev {ERC721} token, including:
2602  *
2603  *  - ability for holders to burn (destroy) their tokens
2604  *  - a minter role that allows for token minting (creation)
2605  *  - a pauser role that allows to stop all token transfers
2606  *  - token ID and URI autogeneration
2607  *
2608  * This contract uses {AccessControl} to lock permissioned functions using the
2609  * different roles - head to its documentation for details.
2610  *
2611  * The account that deploys the contract will be granted the minter and pauser
2612  * roles, as well as the default admin role, which will let it grant both minter
2613  * and pauser roles to other accounts.
2614  *
2615  * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
2616  */
2617 contract ERC721PresetMinterPauserAutoId is
2618     Context,
2619     AccessControlEnumerable,
2620     ERC721Enumerable,
2621     ERC721Burnable,
2622     ERC721Pausable
2623 {
2624     using Counters for Counters.Counter;
2625 
2626     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2627     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2628 
2629     Counters.Counter private _tokenIdTracker;
2630 
2631     string private _baseTokenURI;
2632 
2633     /**
2634      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2635      * account that deploys the contract.
2636      *
2637      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
2638      * See {ERC721-tokenURI}.
2639      */
2640     constructor(
2641         string memory name,
2642         string memory symbol,
2643         string memory baseTokenURI
2644     ) ERC721(name, symbol) {
2645         _baseTokenURI = baseTokenURI;
2646 
2647         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2648 
2649         _setupRole(MINTER_ROLE, _msgSender());
2650         _setupRole(PAUSER_ROLE, _msgSender());
2651     }
2652 
2653     function _baseURI() internal view virtual override returns (string memory) {
2654         return _baseTokenURI;
2655     }
2656 
2657     /**
2658      * @dev Creates a new token for `to`. Its token ID will be automatically
2659      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
2660      * URI autogenerated based on the base URI passed at construction.
2661      *
2662      * See {ERC721-_mint}.
2663      *
2664      * Requirements:
2665      *
2666      * - the caller must have the `MINTER_ROLE`.
2667      */
2668     function mint(address to) public virtual {
2669         require(hasRole(MINTER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have minter role to mint");
2670 
2671         // We cannot just use balanceOf to create the new tokenId because tokens
2672         // can be burned (destroyed), so we need a separate counter.
2673         _mint(to, _tokenIdTracker.current());
2674         _tokenIdTracker.increment();
2675     }
2676 
2677     /**
2678      * @dev Pauses all token transfers.
2679      *
2680      * See {ERC721Pausable} and {Pausable-_pause}.
2681      *
2682      * Requirements:
2683      *
2684      * - the caller must have the `PAUSER_ROLE`.
2685      */
2686     function pause() public virtual {
2687         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to pause");
2688         _pause();
2689     }
2690 
2691     /**
2692      * @dev Unpauses all token transfers.
2693      *
2694      * See {ERC721Pausable} and {Pausable-_unpause}.
2695      *
2696      * Requirements:
2697      *
2698      * - the caller must have the `PAUSER_ROLE`.
2699      */
2700     function unpause() public virtual {
2701         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to unpause");
2702         _unpause();
2703     }
2704 
2705     function _beforeTokenTransfer(
2706         address from,
2707         address to,
2708         uint256 tokenId
2709     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
2710         super._beforeTokenTransfer(from, to, tokenId);
2711     }
2712 
2713     /**
2714      * @dev See {IERC165-supportsInterface}.
2715      */
2716     function supportsInterface(bytes4 interfaceId)
2717         public
2718         view
2719         virtual
2720         override(AccessControlEnumerable, ERC721, ERC721Enumerable)
2721         returns (bool)
2722     {
2723         return super.supportsInterface(interfaceId);
2724     }
2725 }
2726 
2727 // File: contracts/Waldos.sol
2728 
2729 pragma solidity 0.8.7;
2730 
2731 
2732 
2733 
2734  contract Waldos is  ERC721PresetMinterPauserAutoId, Ownable  {
2735     using SafeMath for uint256;
2736     string public baseURI;
2737     string public baseURIHidden;
2738     uint256 public MaxSupply = 4200;
2739     uint256 public MaxSupplyPresale = 1200;
2740     uint256 public MaxPurchase = 1;
2741     uint256 public mintPrice = 0.18 ether;
2742     bool public SaleisActive = false;
2743     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
2744     bool public revealed = false;
2745     bool public presale = false;
2746 
2747     event LogWithdrawal(address sender, uint amount);
2748 
2749     constructor() ERC721PresetMinterPauserAutoId("The Waldos Legend", "TWL","ipfs"){
2750         _setupRole(ADMIN_ROLE, msg.sender);
2751     }
2752     function WaldosMint(uint256 _count, address to) payable public {
2753        require(totalSupply().add(_count) <= MaxSupply, "NT");
2754        require(SaleisActive, "SNA");
2755        require(_count <= MaxPurchase, "1 tx");
2756        require(mintPrice * _count <= msg.value, "EV");
2757        if(presale){
2758             require(totalSupply().add(_count) <= MaxSupplyPresale, "Presale ended");
2759        }
2760         _setupRole(MINTER_ROLE, msg.sender);
2761         for (uint i = 1; i <= _count; i++) {
2762             super.mint(to);
2763         }
2764         _revokeRole(MINTER_ROLE, msg.sender);
2765     }
2766     function _baseURI() internal view virtual override returns (string memory) {
2767         return baseURI;
2768     }
2769     function withdraw(address payable receiver) payable external  returns(bool success) {
2770         require(hasRole(ADMIN_ROLE, _msgSender()), "WT");
2771         receiver.transfer(address(this).balance);
2772         return true;
2773     }
2774     function adminMinting(address to) public {
2775         require(hasRole(ADMIN_ROLE, _msgSender()), "MT1");
2776         require(totalSupply().add(1) <= MaxSupply, "NT");
2777         super.mint(to);
2778     }
2779     function setNewbaseURI(string memory newBaseURI) public  returns (string memory) {
2780         require(hasRole(ADMIN_ROLE, _msgSender()), "NB1");
2781         baseURI = newBaseURI;
2782         return baseURI;
2783     }
2784       function setNewbaseHiddenURI(string memory newBaseURI) public  returns (string memory) {
2785         require(hasRole(ADMIN_ROLE, _msgSender()), "NBH");
2786         baseURIHidden = newBaseURI;
2787         return baseURIHidden;
2788     }
2789     function setNewMintPrice(uint256 newPrice) public {
2790         require(hasRole(ADMIN_ROLE, _msgSender()), "NMP");
2791         mintPrice = newPrice;
2792     }
2793        function setNewMaxPurchase(uint256 newMaxPurchase) public {
2794         require(hasRole(ADMIN_ROLE, _msgSender()), "NMP");
2795         MaxPurchase = newMaxPurchase;
2796     }
2797        function setMaxSupplyPresale(uint256 newMaxSupplyPresale) public {
2798         require(hasRole(ADMIN_ROLE, _msgSender()), "MSP");
2799         MaxSupplyPresale = newMaxSupplyPresale;
2800     }
2801 
2802     function flipSaleStatus() external {
2803         require(hasRole(ADMIN_ROLE, _msgSender()), "FS");
2804         SaleisActive = !SaleisActive;
2805     }
2806       function flipReveal() external {
2807         require(hasRole(ADMIN_ROLE, _msgSender()), "FR");
2808         revealed = !revealed;
2809     }
2810      function flipPresale() external {
2811         require(hasRole(ADMIN_ROLE, _msgSender()), "FR");
2812         presale = !presale;
2813     }
2814     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2815         {
2816             require(_exists(tokenId),"NET");
2817             if (!revealed) {return baseURIHidden;}
2818             return super.tokenURI(tokenId);
2819         }
2820 }