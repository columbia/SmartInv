1 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
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
34  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
35  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
36  *
37  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
38  * ====
39  */
40 library EnumerableSet {
41     // To implement this library for multiple types with as little code
42     // repetition as possible, we write it in terms of a generic Set type with
43     // bytes32 values.
44     // The Set implementation uses private functions, and user-facing
45     // implementations (such as AddressSet) are just wrappers around the
46     // underlying Set.
47     // This means that we can only create new EnumerableSets for types that fit
48     // in bytes32.
49 
50     struct Set {
51         // Storage of set values
52         bytes32[] _values;
53         // Position of the value in the `values` array, plus 1 because index 0
54         // means a value is not in the set.
55         mapping(bytes32 => uint256) _indexes;
56     }
57 
58     /**
59      * @dev Add a value to a set. O(1).
60      *
61      * Returns true if the value was added to the set, that is if it was not
62      * already present.
63      */
64     function _add(Set storage set, bytes32 value) private returns (bool) {
65         if (!_contains(set, value)) {
66             set._values.push(value);
67             // The value is stored at length-1, but we add 1 to all indexes
68             // and use 0 as a sentinel value
69             set._indexes[value] = set._values.length;
70             return true;
71         } else {
72             return false;
73         }
74     }
75 
76     /**
77      * @dev Removes a value from a set. O(1).
78      *
79      * Returns true if the value was removed from the set, that is if it was
80      * present.
81      */
82     function _remove(Set storage set, bytes32 value) private returns (bool) {
83         // We read and store the value's index to prevent multiple reads from the same storage slot
84         uint256 valueIndex = set._indexes[value];
85 
86         if (valueIndex != 0) {
87             // Equivalent to contains(set, value)
88             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
89             // the array, and then remove the last element (sometimes called as 'swap and pop').
90             // This modifies the order of the array, as noted in {at}.
91 
92             uint256 toDeleteIndex = valueIndex - 1;
93             uint256 lastIndex = set._values.length - 1;
94 
95             if (lastIndex != toDeleteIndex) {
96                 bytes32 lastValue = set._values[lastIndex];
97 
98                 // Move the last value to the index where the value to delete is
99                 set._values[toDeleteIndex] = lastValue;
100                 // Update the index for the moved value
101                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
102             }
103 
104             // Delete the slot where the moved value was stored
105             set._values.pop();
106 
107             // Delete the index for the deleted slot
108             delete set._indexes[value];
109 
110             return true;
111         } else {
112             return false;
113         }
114     }
115 
116     /**
117      * @dev Returns true if the value is in the set. O(1).
118      */
119     function _contains(Set storage set, bytes32 value) private view returns (bool) {
120         return set._indexes[value] != 0;
121     }
122 
123     /**
124      * @dev Returns the number of values on the set. O(1).
125      */
126     function _length(Set storage set) private view returns (uint256) {
127         return set._values.length;
128     }
129 
130     /**
131      * @dev Returns the value stored at position `index` in the set. O(1).
132      *
133      * Note that there are no guarantees on the ordering of values inside the
134      * array, and it may change when more values are added or removed.
135      *
136      * Requirements:
137      *
138      * - `index` must be strictly less than {length}.
139      */
140     function _at(Set storage set, uint256 index) private view returns (bytes32) {
141         return set._values[index];
142     }
143 
144     /**
145      * @dev Return the entire set in an array
146      *
147      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
148      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
149      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
150      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
151      */
152     function _values(Set storage set) private view returns (bytes32[] memory) {
153         return set._values;
154     }
155 
156     // Bytes32Set
157 
158     struct Bytes32Set {
159         Set _inner;
160     }
161 
162     /**
163      * @dev Add a value to a set. O(1).
164      *
165      * Returns true if the value was added to the set, that is if it was not
166      * already present.
167      */
168     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
169         return _add(set._inner, value);
170     }
171 
172     /**
173      * @dev Removes a value from a set. O(1).
174      *
175      * Returns true if the value was removed from the set, that is if it was
176      * present.
177      */
178     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
179         return _remove(set._inner, value);
180     }
181 
182     /**
183      * @dev Returns true if the value is in the set. O(1).
184      */
185     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
186         return _contains(set._inner, value);
187     }
188 
189     /**
190      * @dev Returns the number of values in the set. O(1).
191      */
192     function length(Bytes32Set storage set) internal view returns (uint256) {
193         return _length(set._inner);
194     }
195 
196     /**
197      * @dev Returns the value stored at position `index` in the set. O(1).
198      *
199      * Note that there are no guarantees on the ordering of values inside the
200      * array, and it may change when more values are added or removed.
201      *
202      * Requirements:
203      *
204      * - `index` must be strictly less than {length}.
205      */
206     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
207         return _at(set._inner, index);
208     }
209 
210     /**
211      * @dev Return the entire set in an array
212      *
213      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
214      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
215      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
216      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
217      */
218     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
219         return _values(set._inner);
220     }
221 
222     // AddressSet
223 
224     struct AddressSet {
225         Set _inner;
226     }
227 
228     /**
229      * @dev Add a value to a set. O(1).
230      *
231      * Returns true if the value was added to the set, that is if it was not
232      * already present.
233      */
234     function add(AddressSet storage set, address value) internal returns (bool) {
235         return _add(set._inner, bytes32(uint256(uint160(value))));
236     }
237 
238     /**
239      * @dev Removes a value from a set. O(1).
240      *
241      * Returns true if the value was removed from the set, that is if it was
242      * present.
243      */
244     function remove(AddressSet storage set, address value) internal returns (bool) {
245         return _remove(set._inner, bytes32(uint256(uint160(value))));
246     }
247 
248     /**
249      * @dev Returns true if the value is in the set. O(1).
250      */
251     function contains(AddressSet storage set, address value) internal view returns (bool) {
252         return _contains(set._inner, bytes32(uint256(uint160(value))));
253     }
254 
255     /**
256      * @dev Returns the number of values in the set. O(1).
257      */
258     function length(AddressSet storage set) internal view returns (uint256) {
259         return _length(set._inner);
260     }
261 
262     /**
263      * @dev Returns the value stored at position `index` in the set. O(1).
264      *
265      * Note that there are no guarantees on the ordering of values inside the
266      * array, and it may change when more values are added or removed.
267      *
268      * Requirements:
269      *
270      * - `index` must be strictly less than {length}.
271      */
272     function at(AddressSet storage set, uint256 index) internal view returns (address) {
273         return address(uint160(uint256(_at(set._inner, index))));
274     }
275 
276     /**
277      * @dev Return the entire set in an array
278      *
279      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
280      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
281      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
282      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
283      */
284     function values(AddressSet storage set) internal view returns (address[] memory) {
285         bytes32[] memory store = _values(set._inner);
286         address[] memory result;
287 
288         /// @solidity memory-safe-assembly
289         assembly {
290             result := store
291         }
292 
293         return result;
294     }
295 
296     // UintSet
297 
298     struct UintSet {
299         Set _inner;
300     }
301 
302     /**
303      * @dev Add a value to a set. O(1).
304      *
305      * Returns true if the value was added to the set, that is if it was not
306      * already present.
307      */
308     function add(UintSet storage set, uint256 value) internal returns (bool) {
309         return _add(set._inner, bytes32(value));
310     }
311 
312     /**
313      * @dev Removes a value from a set. O(1).
314      *
315      * Returns true if the value was removed from the set, that is if it was
316      * present.
317      */
318     function remove(UintSet storage set, uint256 value) internal returns (bool) {
319         return _remove(set._inner, bytes32(value));
320     }
321 
322     /**
323      * @dev Returns true if the value is in the set. O(1).
324      */
325     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
326         return _contains(set._inner, bytes32(value));
327     }
328 
329     /**
330      * @dev Returns the number of values on the set. O(1).
331      */
332     function length(UintSet storage set) internal view returns (uint256) {
333         return _length(set._inner);
334     }
335 
336     /**
337      * @dev Returns the value stored at position `index` in the set. O(1).
338      *
339      * Note that there are no guarantees on the ordering of values inside the
340      * array, and it may change when more values are added or removed.
341      *
342      * Requirements:
343      *
344      * - `index` must be strictly less than {length}.
345      */
346     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
347         return uint256(_at(set._inner, index));
348     }
349 
350     /**
351      * @dev Return the entire set in an array
352      *
353      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
354      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
355      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
356      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
357      */
358     function values(UintSet storage set) internal view returns (uint256[] memory) {
359         bytes32[] memory store = _values(set._inner);
360         uint256[] memory result;
361 
362         /// @solidity memory-safe-assembly
363         assembly {
364             result := store
365         }
366 
367         return result;
368     }
369 }
370 
371 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev Interface of the ERC165 standard, as defined in the
380  * https://eips.ethereum.org/EIPS/eip-165[EIP].
381  *
382  * Implementers can declare support of contract interfaces, which can then be
383  * queried by others ({ERC165Checker}).
384  *
385  * For an implementation, see {ERC165}.
386  */
387 interface IERC165 {
388     /**
389      * @dev Returns true if this contract implements the interface defined by
390      * `interfaceId`. See the corresponding
391      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
392      * to learn more about how these ids are created.
393      *
394      * This function call must use less than 30 000 gas.
395      */
396     function supportsInterface(bytes4 interfaceId) external view returns (bool);
397 }
398 
399 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 
407 /**
408  * @dev Implementation of the {IERC165} interface.
409  *
410  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
411  * for the additional interface id that will be supported. For example:
412  *
413  * ```solidity
414  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
415  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
416  * }
417  * ```
418  *
419  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
420  */
421 abstract contract ERC165 is IERC165 {
422     /**
423      * @dev See {IERC165-supportsInterface}.
424      */
425     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
426         return interfaceId == type(IERC165).interfaceId;
427     }
428 }
429 
430 // File: @openzeppelin/contracts/utils/Context.sol
431 
432 
433 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Provides information about the current execution context, including the
439  * sender of the transaction and its data. While these are generally available
440  * via msg.sender and msg.data, they should not be accessed in such a direct
441  * manner, since when dealing with meta-transactions the account sending and
442  * paying for execution may not be the actual sender (as far as an application
443  * is concerned).
444  *
445  * This contract is only required for intermediate, library-like contracts.
446  */
447 abstract contract Context {
448     function _msgSender() internal view virtual returns (address) {
449         return msg.sender;
450     }
451 
452     function _msgData() internal view virtual returns (bytes calldata) {
453         return msg.data;
454     }
455 }
456 
457 // File: @openzeppelin/contracts/security/Pausable.sol
458 
459 
460 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 
465 /**
466  * @dev Contract module which allows children to implement an emergency stop
467  * mechanism that can be triggered by an authorized account.
468  *
469  * This module is used through inheritance. It will make available the
470  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
471  * the functions of your contract. Note that they will not be pausable by
472  * simply including this module, only once the modifiers are put in place.
473  */
474 abstract contract Pausable is Context {
475     /**
476      * @dev Emitted when the pause is triggered by `account`.
477      */
478     event Paused(address account);
479 
480     /**
481      * @dev Emitted when the pause is lifted by `account`.
482      */
483     event Unpaused(address account);
484 
485     bool private _paused;
486 
487     /**
488      * @dev Initializes the contract in unpaused state.
489      */
490     constructor() {
491         _paused = false;
492     }
493 
494     /**
495      * @dev Modifier to make a function callable only when the contract is not paused.
496      *
497      * Requirements:
498      *
499      * - The contract must not be paused.
500      */
501     modifier whenNotPaused() {
502         _requireNotPaused();
503         _;
504     }
505 
506     /**
507      * @dev Modifier to make a function callable only when the contract is paused.
508      *
509      * Requirements:
510      *
511      * - The contract must be paused.
512      */
513     modifier whenPaused() {
514         _requirePaused();
515         _;
516     }
517 
518     /**
519      * @dev Returns true if the contract is paused, and false otherwise.
520      */
521     function paused() public view virtual returns (bool) {
522         return _paused;
523     }
524 
525     /**
526      * @dev Throws if the contract is paused.
527      */
528     function _requireNotPaused() internal view virtual {
529         require(!paused(), "Pausable: paused");
530     }
531 
532     /**
533      * @dev Throws if the contract is not paused.
534      */
535     function _requirePaused() internal view virtual {
536         require(paused(), "Pausable: not paused");
537     }
538 
539     /**
540      * @dev Triggers stopped state.
541      *
542      * Requirements:
543      *
544      * - The contract must not be paused.
545      */
546     function _pause() internal virtual whenNotPaused {
547         _paused = true;
548         emit Paused(_msgSender());
549     }
550 
551     /**
552      * @dev Returns to normal state.
553      *
554      * Requirements:
555      *
556      * - The contract must be paused.
557      */
558     function _unpause() internal virtual whenPaused {
559         _paused = false;
560         emit Unpaused(_msgSender());
561     }
562 }
563 
564 // File: @openzeppelin/contracts/access/IAccessControl.sol
565 
566 
567 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 /**
572  * @dev External interface of AccessControl declared to support ERC165 detection.
573  */
574 interface IAccessControl {
575     /**
576      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
577      *
578      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
579      * {RoleAdminChanged} not being emitted signaling this.
580      *
581      * _Available since v3.1._
582      */
583     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
584 
585     /**
586      * @dev Emitted when `account` is granted `role`.
587      *
588      * `sender` is the account that originated the contract call, an admin role
589      * bearer except when using {AccessControl-_setupRole}.
590      */
591     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
592 
593     /**
594      * @dev Emitted when `account` is revoked `role`.
595      *
596      * `sender` is the account that originated the contract call:
597      *   - if using `revokeRole`, it is the admin role bearer
598      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
599      */
600     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
601 
602     /**
603      * @dev Returns `true` if `account` has been granted `role`.
604      */
605     function hasRole(bytes32 role, address account) external view returns (bool);
606 
607     /**
608      * @dev Returns the admin role that controls `role`. See {grantRole} and
609      * {revokeRole}.
610      *
611      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
612      */
613     function getRoleAdmin(bytes32 role) external view returns (bytes32);
614 
615     /**
616      * @dev Grants `role` to `account`.
617      *
618      * If `account` had not been already granted `role`, emits a {RoleGranted}
619      * event.
620      *
621      * Requirements:
622      *
623      * - the caller must have ``role``'s admin role.
624      */
625     function grantRole(bytes32 role, address account) external;
626 
627     /**
628      * @dev Revokes `role` from `account`.
629      *
630      * If `account` had been granted `role`, emits a {RoleRevoked} event.
631      *
632      * Requirements:
633      *
634      * - the caller must have ``role``'s admin role.
635      */
636     function revokeRole(bytes32 role, address account) external;
637 
638     /**
639      * @dev Revokes `role` from the calling account.
640      *
641      * Roles are often managed via {grantRole} and {revokeRole}: this function's
642      * purpose is to provide a mechanism for accounts to lose their privileges
643      * if they are compromised (such as when a trusted device is misplaced).
644      *
645      * If the calling account had been granted `role`, emits a {RoleRevoked}
646      * event.
647      *
648      * Requirements:
649      *
650      * - the caller must be `account`.
651      */
652     function renounceRole(bytes32 role, address account) external;
653 }
654 
655 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
656 
657 
658 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 
663 /**
664  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
665  */
666 interface IAccessControlEnumerable is IAccessControl {
667     /**
668      * @dev Returns one of the accounts that have `role`. `index` must be a
669      * value between 0 and {getRoleMemberCount}, non-inclusive.
670      *
671      * Role bearers are not sorted in any particular way, and their ordering may
672      * change at any point.
673      *
674      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
675      * you perform all queries on the same block. See the following
676      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
677      * for more information.
678      */
679     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
680 
681     /**
682      * @dev Returns the number of accounts that have `role`. Can be used
683      * together with {getRoleMember} to enumerate all bearers of a role.
684      */
685     function getRoleMemberCount(bytes32 role) external view returns (uint256);
686 }
687 
688 // File: @openzeppelin/contracts/utils/Strings.sol
689 
690 
691 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 /**
696  * @dev String operations.
697  */
698 library Strings {
699     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
700     uint8 private constant _ADDRESS_LENGTH = 20;
701 
702     /**
703      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
704      */
705     function toString(uint256 value) internal pure returns (string memory) {
706         // Inspired by OraclizeAPI's implementation - MIT licence
707         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
708 
709         if (value == 0) {
710             return "0";
711         }
712         uint256 temp = value;
713         uint256 digits;
714         while (temp != 0) {
715             digits++;
716             temp /= 10;
717         }
718         bytes memory buffer = new bytes(digits);
719         while (value != 0) {
720             digits -= 1;
721             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
722             value /= 10;
723         }
724         return string(buffer);
725     }
726 
727     /**
728      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
729      */
730     function toHexString(uint256 value) internal pure returns (string memory) {
731         if (value == 0) {
732             return "0x00";
733         }
734         uint256 temp = value;
735         uint256 length = 0;
736         while (temp != 0) {
737             length++;
738             temp >>= 8;
739         }
740         return toHexString(value, length);
741     }
742 
743     /**
744      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
745      */
746     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
747         bytes memory buffer = new bytes(2 * length + 2);
748         buffer[0] = "0";
749         buffer[1] = "x";
750         for (uint256 i = 2 * length + 1; i > 1; --i) {
751             buffer[i] = _HEX_SYMBOLS[value & 0xf];
752             value >>= 4;
753         }
754         require(value == 0, "Strings: hex length insufficient");
755         return string(buffer);
756     }
757 
758     /**
759      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
760      */
761     function toHexString(address addr) internal pure returns (string memory) {
762         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
763     }
764 }
765 
766 // File: @openzeppelin/contracts/access/AccessControl.sol
767 
768 
769 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 
774 
775 
776 
777 /**
778  * @dev Contract module that allows children to implement role-based access
779  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
780  * members except through off-chain means by accessing the contract event logs. Some
781  * applications may benefit from on-chain enumerability, for those cases see
782  * {AccessControlEnumerable}.
783  *
784  * Roles are referred to by their `bytes32` identifier. These should be exposed
785  * in the external API and be unique. The best way to achieve this is by
786  * using `public constant` hash digests:
787  *
788  * ```
789  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
790  * ```
791  *
792  * Roles can be used to represent a set of permissions. To restrict access to a
793  * function call, use {hasRole}:
794  *
795  * ```
796  * function foo() public {
797  *     require(hasRole(MY_ROLE, msg.sender));
798  *     ...
799  * }
800  * ```
801  *
802  * Roles can be granted and revoked dynamically via the {grantRole} and
803  * {revokeRole} functions. Each role has an associated admin role, and only
804  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
805  *
806  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
807  * that only accounts with this role will be able to grant or revoke other
808  * roles. More complex role relationships can be created by using
809  * {_setRoleAdmin}.
810  *
811  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
812  * grant and revoke this role. Extra precautions should be taken to secure
813  * accounts that have been granted it.
814  */
815 abstract contract AccessControl is Context, IAccessControl, ERC165 {
816     struct RoleData {
817         mapping(address => bool) members;
818         bytes32 adminRole;
819     }
820 
821     mapping(bytes32 => RoleData) private _roles;
822 
823     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
824 
825     /**
826      * @dev Modifier that checks that an account has a specific role. Reverts
827      * with a standardized message including the required role.
828      *
829      * The format of the revert reason is given by the following regular expression:
830      *
831      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
832      *
833      * _Available since v4.1._
834      */
835     modifier onlyRole(bytes32 role) {
836         _checkRole(role);
837         _;
838     }
839 
840     /**
841      * @dev See {IERC165-supportsInterface}.
842      */
843     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
844         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
845     }
846 
847     /**
848      * @dev Returns `true` if `account` has been granted `role`.
849      */
850     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
851         return _roles[role].members[account];
852     }
853 
854     /**
855      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
856      * Overriding this function changes the behavior of the {onlyRole} modifier.
857      *
858      * Format of the revert message is described in {_checkRole}.
859      *
860      * _Available since v4.6._
861      */
862     function _checkRole(bytes32 role) internal view virtual {
863         _checkRole(role, _msgSender());
864     }
865 
866     /**
867      * @dev Revert with a standard message if `account` is missing `role`.
868      *
869      * The format of the revert reason is given by the following regular expression:
870      *
871      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
872      */
873     function _checkRole(bytes32 role, address account) internal view virtual {
874         if (!hasRole(role, account)) {
875             revert(
876                 string(
877                     abi.encodePacked(
878                         "AccessControl: account ",
879                         Strings.toHexString(uint160(account), 20),
880                         " is missing role ",
881                         Strings.toHexString(uint256(role), 32)
882                     )
883                 )
884             );
885         }
886     }
887 
888     /**
889      * @dev Returns the admin role that controls `role`. See {grantRole} and
890      * {revokeRole}.
891      *
892      * To change a role's admin, use {_setRoleAdmin}.
893      */
894     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
895         return _roles[role].adminRole;
896     }
897 
898     /**
899      * @dev Grants `role` to `account`.
900      *
901      * If `account` had not been already granted `role`, emits a {RoleGranted}
902      * event.
903      *
904      * Requirements:
905      *
906      * - the caller must have ``role``'s admin role.
907      *
908      * May emit a {RoleGranted} event.
909      */
910     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
911         _grantRole(role, account);
912     }
913 
914     /**
915      * @dev Revokes `role` from `account`.
916      *
917      * If `account` had been granted `role`, emits a {RoleRevoked} event.
918      *
919      * Requirements:
920      *
921      * - the caller must have ``role``'s admin role.
922      *
923      * May emit a {RoleRevoked} event.
924      */
925     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
926         _revokeRole(role, account);
927     }
928 
929     /**
930      * @dev Revokes `role` from the calling account.
931      *
932      * Roles are often managed via {grantRole} and {revokeRole}: this function's
933      * purpose is to provide a mechanism for accounts to lose their privileges
934      * if they are compromised (such as when a trusted device is misplaced).
935      *
936      * If the calling account had been revoked `role`, emits a {RoleRevoked}
937      * event.
938      *
939      * Requirements:
940      *
941      * - the caller must be `account`.
942      *
943      * May emit a {RoleRevoked} event.
944      */
945     function renounceRole(bytes32 role, address account) public virtual override {
946         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
947 
948         _revokeRole(role, account);
949     }
950 
951     /**
952      * @dev Grants `role` to `account`.
953      *
954      * If `account` had not been already granted `role`, emits a {RoleGranted}
955      * event. Note that unlike {grantRole}, this function doesn't perform any
956      * checks on the calling account.
957      *
958      * May emit a {RoleGranted} event.
959      *
960      * [WARNING]
961      * ====
962      * This function should only be called from the constructor when setting
963      * up the initial roles for the system.
964      *
965      * Using this function in any other way is effectively circumventing the admin
966      * system imposed by {AccessControl}.
967      * ====
968      *
969      * NOTE: This function is deprecated in favor of {_grantRole}.
970      */
971     function _setupRole(bytes32 role, address account) internal virtual {
972         _grantRole(role, account);
973     }
974 
975     /**
976      * @dev Sets `adminRole` as ``role``'s admin role.
977      *
978      * Emits a {RoleAdminChanged} event.
979      */
980     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
981         bytes32 previousAdminRole = getRoleAdmin(role);
982         _roles[role].adminRole = adminRole;
983         emit RoleAdminChanged(role, previousAdminRole, adminRole);
984     }
985 
986     /**
987      * @dev Grants `role` to `account`.
988      *
989      * Internal function without access restriction.
990      *
991      * May emit a {RoleGranted} event.
992      */
993     function _grantRole(bytes32 role, address account) internal virtual {
994         if (!hasRole(role, account)) {
995             _roles[role].members[account] = true;
996             emit RoleGranted(role, account, _msgSender());
997         }
998     }
999 
1000     /**
1001      * @dev Revokes `role` from `account`.
1002      *
1003      * Internal function without access restriction.
1004      *
1005      * May emit a {RoleRevoked} event.
1006      */
1007     function _revokeRole(bytes32 role, address account) internal virtual {
1008         if (hasRole(role, account)) {
1009             _roles[role].members[account] = false;
1010             emit RoleRevoked(role, account, _msgSender());
1011         }
1012     }
1013 }
1014 
1015 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1016 
1017 
1018 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1019 
1020 pragma solidity ^0.8.0;
1021 
1022 
1023 
1024 
1025 /**
1026  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1027  */
1028 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1029     using EnumerableSet for EnumerableSet.AddressSet;
1030 
1031     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1032 
1033     /**
1034      * @dev See {IERC165-supportsInterface}.
1035      */
1036     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1037         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1038     }
1039 
1040     /**
1041      * @dev Returns one of the accounts that have `role`. `index` must be a
1042      * value between 0 and {getRoleMemberCount}, non-inclusive.
1043      *
1044      * Role bearers are not sorted in any particular way, and their ordering may
1045      * change at any point.
1046      *
1047      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1048      * you perform all queries on the same block. See the following
1049      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1050      * for more information.
1051      */
1052     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1053         return _roleMembers[role].at(index);
1054     }
1055 
1056     /**
1057      * @dev Returns the number of accounts that have `role`. Can be used
1058      * together with {getRoleMember} to enumerate all bearers of a role.
1059      */
1060     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1061         return _roleMembers[role].length();
1062     }
1063 
1064     /**
1065      * @dev Overload {_grantRole} to track enumerable memberships
1066      */
1067     function _grantRole(bytes32 role, address account) internal virtual override {
1068         super._grantRole(role, account);
1069         _roleMembers[role].add(account);
1070     }
1071 
1072     /**
1073      * @dev Overload {_revokeRole} to track enumerable memberships
1074      */
1075     function _revokeRole(bytes32 role, address account) internal virtual override {
1076         super._revokeRole(role, account);
1077         _roleMembers[role].remove(account);
1078     }
1079 }
1080 
1081 // File: contracts/SecurityBase.sol
1082 
1083 
1084 pragma solidity ^0.8.17;
1085 
1086 
1087 
1088 contract SecurityBase is AccessControlEnumerable, Pausable {
1089     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1090 
1091     modifier onlyMinter() {
1092         _checkRole(MINTER_ROLE, _msgSender());
1093         _;
1094     }
1095 
1096     modifier onlyAdmin() {
1097         _checkRole(DEFAULT_ADMIN_ROLE, _msgSender());
1098         _;
1099     }
1100 
1101     constructor() {
1102         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1103         _setupRole(MINTER_ROLE, _msgSender());
1104     }
1105 
1106     function pause() external onlyMinter {
1107         _pause();
1108     }
1109 
1110     function unpause() external onlyMinter {
1111         _unpause();
1112     }
1113 
1114     function grantMinter(address account) 
1115         external 
1116         virtual 
1117         onlyMinter
1118     {
1119         _setupRole(MINTER_ROLE, account);
1120     }
1121 
1122     function revokeMinter(address account)
1123         external
1124         virtual
1125         onlyMinter
1126     {
1127         _revokeRole(MINTER_ROLE, account);
1128     }
1129 
1130     function supportsInterface(bytes4 interfaceId)
1131         public
1132         view
1133         virtual
1134         override(AccessControlEnumerable)
1135         returns (bool)
1136     {
1137         return super.supportsInterface(interfaceId);
1138     }
1139 }
1140 // File: contracts/Presale.sol
1141 
1142 
1143 pragma solidity ^0.8.17;
1144 
1145 
1146 
1147 contract Presale is SecurityBase   {
1148 
1149     bool        public _open;
1150     bool        public _whitelistFlag;
1151     uint        public _cursor;
1152 
1153     mapping(address => uint)    private _stats;
1154     mapping(string => bool)     private _usedNonces;
1155 
1156     uint constant   public PRICE = 0.005 ether;
1157     uint constant   public QUANTITY_LIMIT = 1;
1158     uint constant   public TOTAL_SUPPLY = 2700;
1159 
1160     event Closed(uint timestamp);
1161     event Open(uint timestamp);
1162     event Refund(address spender, string nonce , uint refundAmount);
1163     event Sent(address spender, string nonce, uint amount, uint[] lstNumbers);
1164 
1165     struct Status {
1166         string state;
1167         uint totalSupply;
1168         uint cursor;
1169     }
1170 
1171     constructor() {
1172         _cursor = 1470;
1173         _open = true;
1174         _whitelistFlag = true;
1175     }
1176 
1177     function setCurrsor(uint newValue) external onlyMinter {
1178         _cursor = newValue;
1179     }
1180 
1181     function open(bool newValue) external onlyMinter {
1182         if (_open != newValue) {
1183             _open = newValue;
1184             if (_open) {
1185                 emit Open(block.timestamp);
1186             } else {
1187                 emit Closed(block.timestamp);
1188             }
1189         }
1190     }
1191 
1192     function peek(address owner) external view returns(uint) {
1193         return _stats[owner];
1194     }
1195 
1196     function setWhitelistFlag(bool newValue) external onlyMinter {
1197         if (_whitelistFlag != newValue) {
1198             _whitelistFlag = newValue;    
1199         }
1200     }
1201 
1202     function status() external view returns(Status memory) {
1203         Status memory context;
1204         context.totalSupply = TOTAL_SUPPLY;
1205         context.cursor = _cursor;
1206         if (_cursor >= TOTAL_SUPPLY) {
1207             context.state = "SELL OUT";
1208         } else if (!_open) {
1209             context.state = "COMING SOON";
1210         } else {
1211             context.state = "OPEN";
1212         }
1213         return context;
1214     }
1215 
1216     function withdraw(address payable to) external onlyMinter {
1217         uint balance = address(this).balance;
1218         if (balance > 0) {
1219             to.transfer(balance);
1220         }
1221     }
1222 
1223     function buy(string memory nonce, bytes calldata signature) external payable {
1224         require(msg.value == PRICE, "Wrong value");
1225         require (_open, "Coming soon");
1226         require(_cursor < TOTAL_SUPPLY, "Sell out");
1227         require (_whitelistFlag, "Free time");
1228         require(!_usedNonces[nonce], "Nonce used");
1229 
1230         address spender = _msgSender();
1231         require(_stats[spender] < QUANTITY_LIMIT, "Out of minted number");
1232         
1233         bytes32 signedMessageHash = _getSignedMessageHash(spender, nonce, msg.value);
1234         address signer = _recoverSigner(signedMessageHash, signature);
1235         require(super.hasRole(MINTER_ROLE, signer), "Signature is not from minter");
1236 
1237         uint[] memory lstNumbers = new uint[](1);
1238         lstNumbers[0] = _cursor++;
1239         _stats[spender]++;
1240         _usedNonces[nonce] = true;
1241 
1242         emit Sent(spender, nonce, msg.value, lstNumbers);
1243     }
1244 
1245     function freeBuy(string memory nonce, bytes calldata signature) external payable {
1246         require(msg.value >= PRICE && msg.value % PRICE == 0, "Wrong value");
1247         require (_open, "Coming soon");
1248         require(_cursor < TOTAL_SUPPLY, "Sell out");
1249         require (!_whitelistFlag, "Whitelist time");
1250         require(!_usedNonces[nonce], "Nonce used");
1251         
1252         address spender = _msgSender();
1253         bytes32 signedMessageHash = _getSignedMessageHash(spender, nonce, msg.value);
1254         address signer = _recoverSigner(signedMessageHash, signature);
1255         require(super.hasRole(MINTER_ROLE, signer), "Signature is not from minter");
1256 
1257         uint cnt = msg.value / PRICE;
1258         if (_cursor + cnt > TOTAL_SUPPLY) {
1259             cnt = TOTAL_SUPPLY - _cursor;
1260         }
1261 
1262         uint[] memory lstNumbers = new uint[](cnt);
1263         for (uint i=0; i<cnt; i++) {
1264             lstNumbers[i] = _cursor++;
1265         }
1266 
1267         _stats[spender] += cnt;
1268         _usedNonces[nonce] = true;
1269         emit Sent(spender, nonce, msg.value, lstNumbers);
1270 
1271         uint usedAmount = cnt * PRICE;
1272         uint refundAmount = msg.value - usedAmount;
1273 
1274         // Refund of remaining
1275         if (refundAmount > 0) {
1276             payable(spender).transfer(refundAmount);
1277             emit Refund(spender, nonce, refundAmount);
1278         }
1279     }
1280 
1281     function _getSignedMessageHash(address spender, string memory nonce, uint amount) private pure returns (bytes32) {
1282         /*
1283             Signature is produced by signing a keccak256 hash with the following format:
1284             "\x19Ethereum Signed Message\n" + len(msg) + msg
1285         */
1286         return keccak256(
1287             abi.encodePacked(
1288                 "\x19Ethereum Signed Message:\n32", 
1289                 keccak256(
1290                     abi.encode(
1291                         spender, 
1292                         nonce, 
1293                         amount
1294                     )
1295                 )
1296             )
1297         );
1298     }
1299 
1300     function _recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) private pure returns (address) {
1301         (bytes32 r, bytes32 s, uint8 v) = _splitSignature(_signature);
1302         return ecrecover(_ethSignedMessageHash, v, r, s);
1303     }
1304 
1305     function _splitSignature(bytes memory sig) private pure returns (bytes32 r, bytes32 s, uint8 v) {
1306         require(sig.length == 65, "Invalid signature length");
1307 
1308         assembly {
1309             /*
1310                 First 32 bytes stores the length of the signature
1311 
1312                 add(sig, 32) = pointer of sig + 32
1313                 effectively, skips first 32 bytes of signature
1314 
1315                 mload(p) loads next 32 bytes starting at the memory address p into memory
1316             */
1317 
1318             // first 32 bytes, after the length prefix
1319             r := mload(add(sig, 32))
1320             // second 32 bytes
1321             s := mload(add(sig, 64))
1322             // final byte (first byte of the next 32 bytes)
1323             v := byte(0, mload(add(sig, 96)))
1324         }
1325     }
1326 }