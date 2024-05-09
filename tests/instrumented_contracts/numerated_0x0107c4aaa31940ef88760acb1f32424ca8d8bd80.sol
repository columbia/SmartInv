1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Library for managing
32  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
33  * types.
34  *
35  * Sets have the following properties:
36  *
37  * - Elements are added, removed, and checked for existence in constant time
38  * (O(1)).
39  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
40  *
41  * ```
42  * contract Example {
43  *     // Add the library methods
44  *     using EnumerableSet for EnumerableSet.AddressSet;
45  *
46  *     // Declare a set state variable
47  *     EnumerableSet.AddressSet private mySet;
48  * }
49  * ```
50  *
51  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
52  * and `uint256` (`UintSet`) are supported.
53  *
54  * [WARNING]
55  * ====
56  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
57  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
58  *
59  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
60  * ====
61  */
62 library EnumerableSet {
63     // To implement this library for multiple types with as little code
64     // repetition as possible, we write it in terms of a generic Set type with
65     // bytes32 values.
66     // The Set implementation uses private functions, and user-facing
67     // implementations (such as AddressSet) are just wrappers around the
68     // underlying Set.
69     // This means that we can only create new EnumerableSets for types that fit
70     // in bytes32.
71 
72     struct Set {
73         // Storage of set values
74         bytes32[] _values;
75         // Position of the value in the `values` array, plus 1 because index 0
76         // means a value is not in the set.
77         mapping(bytes32 => uint256) _indexes;
78     }
79 
80     /**
81      * @dev Add a value to a set. O(1).
82      *
83      * Returns true if the value was added to the set, that is if it was not
84      * already present.
85      */
86     function _add(Set storage set, bytes32 value) private returns (bool) {
87         if (!_contains(set, value)) {
88             set._values.push(value);
89             // The value is stored at length-1, but we add 1 to all indexes
90             // and use 0 as a sentinel value
91             set._indexes[value] = set._values.length;
92             return true;
93         } else {
94             return false;
95         }
96     }
97 
98     /**
99      * @dev Removes a value from a set. O(1).
100      *
101      * Returns true if the value was removed from the set, that is if it was
102      * present.
103      */
104     function _remove(Set storage set, bytes32 value) private returns (bool) {
105         // We read and store the value's index to prevent multiple reads from the same storage slot
106         uint256 valueIndex = set._indexes[value];
107 
108         if (valueIndex != 0) {
109             // Equivalent to contains(set, value)
110             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
111             // the array, and then remove the last element (sometimes called as 'swap and pop').
112             // This modifies the order of the array, as noted in {at}.
113 
114             uint256 toDeleteIndex = valueIndex - 1;
115             uint256 lastIndex = set._values.length - 1;
116 
117             if (lastIndex != toDeleteIndex) {
118                 bytes32 lastValue = set._values[lastIndex];
119 
120                 // Move the last value to the index where the value to delete is
121                 set._values[toDeleteIndex] = lastValue;
122                 // Update the index for the moved value
123                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
124             }
125 
126             // Delete the slot where the moved value was stored
127             set._values.pop();
128 
129             // Delete the index for the deleted slot
130             delete set._indexes[value];
131 
132             return true;
133         } else {
134             return false;
135         }
136     }
137 
138     /**
139      * @dev Returns true if the value is in the set. O(1).
140      */
141     function _contains(Set storage set, bytes32 value) private view returns (bool) {
142         return set._indexes[value] != 0;
143     }
144 
145     /**
146      * @dev Returns the number of values on the set. O(1).
147      */
148     function _length(Set storage set) private view returns (uint256) {
149         return set._values.length;
150     }
151 
152     /**
153      * @dev Returns the value stored at position `index` in the set. O(1).
154      *
155      * Note that there are no guarantees on the ordering of values inside the
156      * array, and it may change when more values are added or removed.
157      *
158      * Requirements:
159      *
160      * - `index` must be strictly less than {length}.
161      */
162     function _at(Set storage set, uint256 index) private view returns (bytes32) {
163         return set._values[index];
164     }
165 
166     /**
167      * @dev Return the entire set in an array
168      *
169      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
170      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
171      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
172      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
173      */
174     function _values(Set storage set) private view returns (bytes32[] memory) {
175         return set._values;
176     }
177 
178     // Bytes32Set
179 
180     struct Bytes32Set {
181         Set _inner;
182     }
183 
184     /**
185      * @dev Add a value to a set. O(1).
186      *
187      * Returns true if the value was added to the set, that is if it was not
188      * already present.
189      */
190     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
191         return _add(set._inner, value);
192     }
193 
194     /**
195      * @dev Removes a value from a set. O(1).
196      *
197      * Returns true if the value was removed from the set, that is if it was
198      * present.
199      */
200     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
201         return _remove(set._inner, value);
202     }
203 
204     /**
205      * @dev Returns true if the value is in the set. O(1).
206      */
207     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
208         return _contains(set._inner, value);
209     }
210 
211     /**
212      * @dev Returns the number of values in the set. O(1).
213      */
214     function length(Bytes32Set storage set) internal view returns (uint256) {
215         return _length(set._inner);
216     }
217 
218     /**
219      * @dev Returns the value stored at position `index` in the set. O(1).
220      *
221      * Note that there are no guarantees on the ordering of values inside the
222      * array, and it may change when more values are added or removed.
223      *
224      * Requirements:
225      *
226      * - `index` must be strictly less than {length}.
227      */
228     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
229         return _at(set._inner, index);
230     }
231 
232     /**
233      * @dev Return the entire set in an array
234      *
235      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
236      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
237      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
238      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
239      */
240     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
241         return _values(set._inner);
242     }
243 
244     // AddressSet
245 
246     struct AddressSet {
247         Set _inner;
248     }
249 
250     /**
251      * @dev Add a value to a set. O(1).
252      *
253      * Returns true if the value was added to the set, that is if it was not
254      * already present.
255      */
256     function add(AddressSet storage set, address value) internal returns (bool) {
257         return _add(set._inner, bytes32(uint256(uint160(value))));
258     }
259 
260     /**
261      * @dev Removes a value from a set. O(1).
262      *
263      * Returns true if the value was removed from the set, that is if it was
264      * present.
265      */
266     function remove(AddressSet storage set, address value) internal returns (bool) {
267         return _remove(set._inner, bytes32(uint256(uint160(value))));
268     }
269 
270     /**
271      * @dev Returns true if the value is in the set. O(1).
272      */
273     function contains(AddressSet storage set, address value) internal view returns (bool) {
274         return _contains(set._inner, bytes32(uint256(uint160(value))));
275     }
276 
277     /**
278      * @dev Returns the number of values in the set. O(1).
279      */
280     function length(AddressSet storage set) internal view returns (uint256) {
281         return _length(set._inner);
282     }
283 
284     /**
285      * @dev Returns the value stored at position `index` in the set. O(1).
286      *
287      * Note that there are no guarantees on the ordering of values inside the
288      * array, and it may change when more values are added or removed.
289      *
290      * Requirements:
291      *
292      * - `index` must be strictly less than {length}.
293      */
294     function at(AddressSet storage set, uint256 index) internal view returns (address) {
295         return address(uint160(uint256(_at(set._inner, index))));
296     }
297 
298     /**
299      * @dev Return the entire set in an array
300      *
301      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
302      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
303      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
304      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
305      */
306     function values(AddressSet storage set) internal view returns (address[] memory) {
307         bytes32[] memory store = _values(set._inner);
308         address[] memory result;
309 
310         /// @solidity memory-safe-assembly
311         assembly {
312             result := store
313         }
314 
315         return result;
316     }
317 
318     // UintSet
319 
320     struct UintSet {
321         Set _inner;
322     }
323 
324     /**
325      * @dev Add a value to a set. O(1).
326      *
327      * Returns true if the value was added to the set, that is if it was not
328      * already present.
329      */
330     function add(UintSet storage set, uint256 value) internal returns (bool) {
331         return _add(set._inner, bytes32(value));
332     }
333 
334     /**
335      * @dev Removes a value from a set. O(1).
336      *
337      * Returns true if the value was removed from the set, that is if it was
338      * present.
339      */
340     function remove(UintSet storage set, uint256 value) internal returns (bool) {
341         return _remove(set._inner, bytes32(value));
342     }
343 
344     /**
345      * @dev Returns true if the value is in the set. O(1).
346      */
347     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
348         return _contains(set._inner, bytes32(value));
349     }
350 
351     /**
352      * @dev Returns the number of values on the set. O(1).
353      */
354     function length(UintSet storage set) internal view returns (uint256) {
355         return _length(set._inner);
356     }
357 
358     /**
359      * @dev Returns the value stored at position `index` in the set. O(1).
360      *
361      * Note that there are no guarantees on the ordering of values inside the
362      * array, and it may change when more values are added or removed.
363      *
364      * Requirements:
365      *
366      * - `index` must be strictly less than {length}.
367      */
368     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
369         return uint256(_at(set._inner, index));
370     }
371 
372     /**
373      * @dev Return the entire set in an array
374      *
375      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
376      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
377      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
378      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
379      */
380     function values(UintSet storage set) internal view returns (uint256[] memory) {
381         bytes32[] memory store = _values(set._inner);
382         uint256[] memory result;
383 
384         /// @solidity memory-safe-assembly
385         assembly {
386             result := store
387         }
388 
389         return result;
390     }
391 }
392 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Interface of the ERC165 standard, as defined in the
398  * https://eips.ethereum.org/EIPS/eip-165[EIP].
399  *
400  * Implementers can declare support of contract interfaces, which can then be
401  * queried by others ({ERC165Checker}).
402  *
403  * For an implementation, see {ERC165}.
404  */
405 interface IERC165 {
406     /**
407      * @dev Returns true if this contract implements the interface defined by
408      * `interfaceId`. See the corresponding
409      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
410      * to learn more about how these ids are created.
411      *
412      * This function call must use less than 30 000 gas.
413      */
414     function supportsInterface(bytes4 interfaceId) external view returns (bool);
415 }
416 
417 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Implementation of the {IERC165} interface.
424  *
425  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
426  * for the additional interface id that will be supported. For example:
427  *
428  * ```solidity
429  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
430  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
431  * }
432  * ```
433  *
434  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
435  */
436 abstract contract ERC165 is IERC165 {
437     /**
438      * @dev See {IERC165-supportsInterface}.
439      */
440     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
441         return interfaceId == type(IERC165).interfaceId;
442     }
443 }
444 
445 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev String operations.
451  */
452 library Strings {
453     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
454     uint8 private constant _ADDRESS_LENGTH = 20;
455 
456     /**
457      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
458      */
459     function toString(uint256 value) internal pure returns (string memory) {
460         // Inspired by OraclizeAPI's implementation - MIT licence
461         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
462 
463         if (value == 0) {
464             return "0";
465         }
466         uint256 temp = value;
467         uint256 digits;
468         while (temp != 0) {
469             digits++;
470             temp /= 10;
471         }
472         bytes memory buffer = new bytes(digits);
473         while (value != 0) {
474             digits -= 1;
475             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
476             value /= 10;
477         }
478         return string(buffer);
479     }
480 
481     /**
482      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
483      */
484     function toHexString(uint256 value) internal pure returns (string memory) {
485         if (value == 0) {
486             return "0x00";
487         }
488         uint256 temp = value;
489         uint256 length = 0;
490         while (temp != 0) {
491             length++;
492             temp >>= 8;
493         }
494         return toHexString(value, length);
495     }
496 
497     /**
498      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
499      */
500     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
501         bytes memory buffer = new bytes(2 * length + 2);
502         buffer[0] = "0";
503         buffer[1] = "x";
504         for (uint256 i = 2 * length + 1; i > 1; --i) {
505             buffer[i] = _HEX_SYMBOLS[value & 0xf];
506             value >>= 4;
507         }
508         require(value == 0, "Strings: hex length insufficient");
509         return string(buffer);
510     }
511 
512     /**
513      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
514      */
515     function toHexString(address addr) internal pure returns (string memory) {
516         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
517     }
518 }
519 
520 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @dev External interface of AccessControl declared to support ERC165 detection.
526  */
527 interface IAccessControl {
528     /**
529      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
530      *
531      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
532      * {RoleAdminChanged} not being emitted signaling this.
533      *
534      * _Available since v3.1._
535      */
536     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
537 
538     /**
539      * @dev Emitted when `account` is granted `role`.
540      *
541      * `sender` is the account that originated the contract call, an admin role
542      * bearer except when using {AccessControl-_setupRole}.
543      */
544     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
545 
546     /**
547      * @dev Emitted when `account` is revoked `role`.
548      *
549      * `sender` is the account that originated the contract call:
550      *   - if using `revokeRole`, it is the admin role bearer
551      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
552      */
553     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
554 
555     /**
556      * @dev Returns `true` if `account` has been granted `role`.
557      */
558     function hasRole(bytes32 role, address account) external view returns (bool);
559 
560     /**
561      * @dev Returns the admin role that controls `role`. See {grantRole} and
562      * {revokeRole}.
563      *
564      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
565      */
566     function getRoleAdmin(bytes32 role) external view returns (bytes32);
567 
568     /**
569      * @dev Grants `role` to `account`.
570      *
571      * If `account` had not been already granted `role`, emits a {RoleGranted}
572      * event.
573      *
574      * Requirements:
575      *
576      * - the caller must have ``role``'s admin role.
577      */
578     function grantRole(bytes32 role, address account) external;
579 
580     /**
581      * @dev Revokes `role` from `account`.
582      *
583      * If `account` had been granted `role`, emits a {RoleRevoked} event.
584      *
585      * Requirements:
586      *
587      * - the caller must have ``role``'s admin role.
588      */
589     function revokeRole(bytes32 role, address account) external;
590 
591     /**
592      * @dev Revokes `role` from the calling account.
593      *
594      * Roles are often managed via {grantRole} and {revokeRole}: this function's
595      * purpose is to provide a mechanism for accounts to lose their privileges
596      * if they are compromised (such as when a trusted device is misplaced).
597      *
598      * If the calling account had been granted `role`, emits a {RoleRevoked}
599      * event.
600      *
601      * Requirements:
602      *
603      * - the caller must be `account`.
604      */
605     function renounceRole(bytes32 role, address account) external;
606 }
607 
608 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Contract module that allows children to implement role-based access
614  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
615  * members except through off-chain means by accessing the contract event logs. Some
616  * applications may benefit from on-chain enumerability, for those cases see
617  * {AccessControlEnumerable}.
618  *
619  * Roles are referred to by their `bytes32` identifier. These should be exposed
620  * in the external API and be unique. The best way to achieve this is by
621  * using `public constant` hash digests:
622  *
623  * ```
624  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
625  * ```
626  *
627  * Roles can be used to represent a set of permissions. To restrict access to a
628  * function call, use {hasRole}:
629  *
630  * ```
631  * function foo() public {
632  *     require(hasRole(MY_ROLE, msg.sender));
633  *     ...
634  * }
635  * ```
636  *
637  * Roles can be granted and revoked dynamically via the {grantRole} and
638  * {revokeRole} functions. Each role has an associated admin role, and only
639  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
640  *
641  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
642  * that only accounts with this role will be able to grant or revoke other
643  * roles. More complex role relationships can be created by using
644  * {_setRoleAdmin}.
645  *
646  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
647  * grant and revoke this role. Extra precautions should be taken to secure
648  * accounts that have been granted it.
649  */
650 abstract contract AccessControl is Context, IAccessControl, ERC165 {
651     struct RoleData {
652         mapping(address => bool) members;
653         bytes32 adminRole;
654     }
655 
656     mapping(bytes32 => RoleData) private _roles;
657 
658     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
659 
660     /**
661      * @dev Modifier that checks that an account has a specific role. Reverts
662      * with a standardized message including the required role.
663      *
664      * The format of the revert reason is given by the following regular expression:
665      *
666      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
667      *
668      * _Available since v4.1._
669      */
670     modifier onlyRole(bytes32 role) {
671         _checkRole(role);
672         _;
673     }
674 
675     /**
676      * @dev See {IERC165-supportsInterface}.
677      */
678     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
679         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
680     }
681 
682     /**
683      * @dev Returns `true` if `account` has been granted `role`.
684      */
685     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
686         return _roles[role].members[account];
687     }
688 
689     /**
690      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
691      * Overriding this function changes the behavior of the {onlyRole} modifier.
692      *
693      * Format of the revert message is described in {_checkRole}.
694      *
695      * _Available since v4.6._
696      */
697     function _checkRole(bytes32 role) internal view virtual {
698         _checkRole(role, _msgSender());
699     }
700 
701     /**
702      * @dev Revert with a standard message if `account` is missing `role`.
703      *
704      * The format of the revert reason is given by the following regular expression:
705      *
706      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
707      */
708     function _checkRole(bytes32 role, address account) internal view virtual {
709         if (!hasRole(role, account)) {
710             revert(
711                 string(
712                     abi.encodePacked(
713                         "AccessControl: account ",
714                         Strings.toHexString(account),
715                         " is missing role ",
716                         Strings.toHexString(uint256(role), 32)
717                     )
718                 )
719             );
720         }
721     }
722 
723     /**
724      * @dev Returns the admin role that controls `role`. See {grantRole} and
725      * {revokeRole}.
726      *
727      * To change a role's admin, use {_setRoleAdmin}.
728      */
729     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
730         return _roles[role].adminRole;
731     }
732 
733     /**
734      * @dev Grants `role` to `account`.
735      *
736      * If `account` had not been already granted `role`, emits a {RoleGranted}
737      * event.
738      *
739      * Requirements:
740      *
741      * - the caller must have ``role``'s admin role.
742      *
743      * May emit a {RoleGranted} event.
744      */
745     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
746         _grantRole(role, account);
747     }
748 
749     /**
750      * @dev Revokes `role` from `account`.
751      *
752      * If `account` had been granted `role`, emits a {RoleRevoked} event.
753      *
754      * Requirements:
755      *
756      * - the caller must have ``role``'s admin role.
757      *
758      * May emit a {RoleRevoked} event.
759      */
760     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
761         _revokeRole(role, account);
762     }
763 
764     /**
765      * @dev Revokes `role` from the calling account.
766      *
767      * Roles are often managed via {grantRole} and {revokeRole}: this function's
768      * purpose is to provide a mechanism for accounts to lose their privileges
769      * if they are compromised (such as when a trusted device is misplaced).
770      *
771      * If the calling account had been revoked `role`, emits a {RoleRevoked}
772      * event.
773      *
774      * Requirements:
775      *
776      * - the caller must be `account`.
777      *
778      * May emit a {RoleRevoked} event.
779      */
780     function renounceRole(bytes32 role, address account) public virtual override {
781         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
782 
783         _revokeRole(role, account);
784     }
785 
786     /**
787      * @dev Grants `role` to `account`.
788      *
789      * If `account` had not been already granted `role`, emits a {RoleGranted}
790      * event. Note that unlike {grantRole}, this function doesn't perform any
791      * checks on the calling account.
792      *
793      * May emit a {RoleGranted} event.
794      *
795      * [WARNING]
796      * ====
797      * This function should only be called from the constructor when setting
798      * up the initial roles for the system.
799      *
800      * Using this function in any other way is effectively circumventing the admin
801      * system imposed by {AccessControl}.
802      * ====
803      *
804      * NOTE: This function is deprecated in favor of {_grantRole}.
805      */
806     function _setupRole(bytes32 role, address account) internal virtual {
807         _grantRole(role, account);
808     }
809 
810     /**
811      * @dev Sets `adminRole` as ``role``'s admin role.
812      *
813      * Emits a {RoleAdminChanged} event.
814      */
815     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
816         bytes32 previousAdminRole = getRoleAdmin(role);
817         _roles[role].adminRole = adminRole;
818         emit RoleAdminChanged(role, previousAdminRole, adminRole);
819     }
820 
821     /**
822      * @dev Grants `role` to `account`.
823      *
824      * Internal function without access restriction.
825      *
826      * May emit a {RoleGranted} event.
827      */
828     function _grantRole(bytes32 role, address account) internal virtual {
829         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "AccessControl: must have ADMIN_ROLE");
830         if (!hasRole(role, account)) {
831             _roles[role].members[account] = true;
832             emit RoleGranted(role, account, _msgSender());
833         }
834     }
835 
836     /**
837      * @dev Grants `role` to `account`.
838      *
839      * Internal function without access restriction.
840      *
841      * May emit a {RoleGranted} event.
842      */
843     function _grantAdminRole(address account) internal virtual {
844         if (!hasRole(DEFAULT_ADMIN_ROLE, account)) {
845             _roles[DEFAULT_ADMIN_ROLE].members[account] = true;
846             emit RoleGranted(DEFAULT_ADMIN_ROLE, account, _msgSender());
847         }
848     }
849 
850     /**
851      * @dev Revokes `role` from `account`.
852      *
853      * Internal function without access restriction.
854      *
855      * May emit a {RoleRevoked} event.
856      */
857     function _revokeRole(bytes32 role, address account) internal virtual {
858         if (hasRole(role, account)) {
859             _roles[role].members[account] = false;
860             emit RoleRevoked(role, account, _msgSender());
861         }
862     }
863 }
864 
865 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 /**
870  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
871  */
872 interface IAccessControlEnumerable is IAccessControl {
873     /**
874      * @dev Returns one of the accounts that have `role`. `index` must be a
875      * value between 0 and {getRoleMemberCount}, non-inclusive.
876      *
877      * Role bearers are not sorted in any particular way, and their ordering may
878      * change at any point.
879      *
880      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
881      * you perform all queries on the same block. See the following
882      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
883      * for more information.
884      */
885     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
886 
887     /**
888      * @dev Returns the number of accounts that have `role`. Can be used
889      * together with {getRoleMember} to enumerate all bearers of a role.
890      */
891     function getRoleMemberCount(bytes32 role) external view returns (uint256);
892 }
893 
894 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
895 
896 pragma solidity ^0.8.0;
897 
898 /**
899  * @dev Contract module which allows children to implement an emergency stop
900  * mechanism that can be triggered by an authorized account.
901  *
902  * This module is used through inheritance. It will make available the
903  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
904  * the functions of your contract. Note that they will not be pausable by
905  * simply including this module, only once the modifiers are put in place.
906  */
907 abstract contract Pausable is Context {
908     /**
909      * @dev Emitted when the pause is triggered by `account`.
910      */
911     event Paused(address account);
912 
913     /**
914      * @dev Emitted when the pause is lifted by `account`.
915      */
916     event Unpaused(address account);
917 
918     bool private _paused;
919 
920     /**
921      * @dev Initializes the contract in unpaused state.
922      */
923     constructor() {
924         _paused = false;
925     }
926 
927     /**
928      * @dev Modifier to make a function callable only when the contract is not paused.
929      *
930      * Requirements:
931      *
932      * - The contract must not be paused.
933      */
934     modifier whenNotPaused() {
935         _requireNotPaused();
936         _;
937     }
938 
939     /**
940      * @dev Modifier to make a function callable only when the contract is paused.
941      *
942      * Requirements:
943      *
944      * - The contract must be paused.
945      */
946     modifier whenPaused() {
947         _requirePaused();
948         _;
949     }
950 
951     /**
952      * @dev Returns true if the contract is paused, and false otherwise.
953      */
954     function paused() public view virtual returns (bool) {
955         return _paused;
956     }
957 
958     /**
959      * @dev Throws if the contract is paused.
960      */
961     function _requireNotPaused() internal view virtual {
962         require(!paused(), "Pausable: paused");
963     }
964 
965     /**
966      * @dev Throws if the contract is not paused.
967      */
968     function _requirePaused() internal view virtual {
969         require(paused(), "Pausable: not paused");
970     }
971 
972     /**
973      * @dev Triggers stopped state.
974      *
975      * Requirements:
976      *
977      * - The contract must not be paused.
978      */
979     function _pause() internal virtual whenNotPaused {
980         _paused = true;
981         emit Paused(_msgSender());
982     }
983 
984     /**
985      * @dev Returns to normal state.
986      *
987      * Requirements:
988      *
989      * - The contract must be paused.
990      */
991     function _unpause() internal virtual whenPaused {
992         _paused = false;
993         emit Unpaused(_msgSender());
994     }
995 }
996 
997 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
998 
999 pragma solidity ^0.8.0;
1000 
1001 /**
1002  * @dev Interface of the ERC20 standard as defined in the EIP.
1003  */
1004 interface IERC20 {
1005     /**
1006      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1007      * another (`to`).
1008      *
1009      * Note that `value` may be zero.
1010      */
1011     event Transfer(address indexed from, address indexed to, uint256 value);
1012 
1013     /**
1014      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1015      * a call to {approve}. `value` is the new allowance.
1016      */
1017     event Approval(address indexed owner, address indexed spender, uint256 value);
1018 
1019     /**
1020      * @dev Returns the amount of tokens in existence.
1021      */
1022     function totalSupply() external view returns (uint256);
1023 
1024     /**
1025      * @dev Returns minted amount of tokens.
1026      */
1027     function mintedSupply() external view returns (uint256);
1028 
1029     /**
1030      * @dev Returns the limit amount for a single coin transaction of tokens
1031      */
1032     function mintLimitAmount() external view returns (uint256);
1033 
1034     /**
1035      * @dev Returns the amount of tokens owned by `account`.
1036      */
1037     function balanceOf(address account) external view returns (uint256);
1038 
1039     /**
1040      * @dev Moves `amount` tokens from the caller's account to `to`.
1041      *
1042      * Returns a boolean value indicating whether the operation succeeded.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function transfer(address to, uint256 amount) external returns (bool);
1047 
1048     /**
1049      * @dev Returns the remaining number of tokens that `spender` will be
1050      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1051      * zero by default.
1052      *
1053      * This value changes when {approve} or {transferFrom} are called.
1054      */
1055     function allowance(address owner, address spender) external view returns (uint256);
1056 
1057     /**
1058      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1059      *
1060      * Returns a boolean value indicating whether the operation succeeded.
1061      *
1062      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1063      * that someone may use both the old and the new allowance by unfortunate
1064      * transaction ordering. One possible solution to mitigate this race
1065      * condition is to first reduce the spender's allowance to 0 and set the
1066      * desired value afterwards:
1067      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1068      *
1069      * Emits an {Approval} event.
1070      */
1071     function approve(address spender, uint256 amount) external returns (bool);
1072 
1073     /**
1074      * @dev Moves `amount` tokens from `from` to `to` using the
1075      * allowance mechanism. `amount` is then deducted from the caller's
1076      * allowance.
1077      *
1078      * Returns a boolean value indicating whether the operation succeeded.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function transferFrom(
1083         address from,
1084         address to,
1085         uint256 amount
1086     ) external returns (bool);
1087 }
1088 
1089 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1090 
1091 pragma solidity ^0.8.0;
1092 
1093 /**
1094  * @dev Interface for the optional metadata functions from the ERC20 standard.
1095  *
1096  * _Available since v4.1._
1097  */
1098 interface IERC20Metadata is IERC20 {
1099     /**
1100      * @dev Returns the name of the token.
1101      */
1102     function name() external view returns (string memory);
1103 
1104     /**
1105      * @dev Returns the symbol of the token.
1106      */
1107     function symbol() external view returns (string memory);
1108 
1109     /**
1110      * @dev Returns the decimals places of the token.
1111      */
1112     function decimals() external view returns (uint8);
1113 }
1114 
1115 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 /**
1120  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1121  */
1122 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1123     using EnumerableSet for EnumerableSet.AddressSet;
1124 
1125     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1126 
1127     /**
1128      * @dev See {IERC165-supportsInterface}.
1129      */
1130     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1131         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev Returns one of the accounts that have `role`. `index` must be a
1136      * value between 0 and {getRoleMemberCount}, non-inclusive.
1137      *
1138      * Role bearers are not sorted in any particular way, and their ordering may
1139      * change at any point.
1140      *
1141      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1142      * you perform all queries on the same block. See the following
1143      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1144      * for more information.
1145      */
1146     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1147         return _roleMembers[role].at(index);
1148     }
1149 
1150     /**
1151      * @dev Returns the number of accounts that have `role`. Can be used
1152      * together with {getRoleMember} to enumerate all bearers of a role.
1153      */
1154     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1155         return _roleMembers[role].length();
1156     }
1157 
1158     /**
1159      * @dev Overload {_grantRole} to track enumerable memberships
1160      */
1161     function _grantRole(bytes32 role, address account) internal virtual override {
1162         super._grantRole(role, account);
1163         _roleMembers[role].add(account);
1164     }
1165 
1166     /**
1167      * @dev Overload {_revokeRole} to track enumerable memberships
1168      */
1169     function _revokeRole(bytes32 role, address account) internal virtual override {
1170         super._revokeRole(role, account);
1171         _roleMembers[role].remove(account);
1172     }
1173 }
1174 
1175 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 /**
1180  * @dev Implementation of the {IERC20} interface.
1181  *
1182  * This implementation is agnostic to the way tokens are created. This means
1183  * that a supply mechanism has to be added in a derived contract using {_mint}.
1184  * For a generic mechanism see {ERC20PresetMinterPauser}.
1185  *
1186  * TIP: For a detailed writeup see our guide
1187  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1188  * to implement supply mechanisms].
1189  *
1190  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1191  * instead returning `false` on failure. This behavior is nonetheless
1192  * conventional and does not conflict with the expectations of ERC20
1193  * applications.
1194  *
1195  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1196  * This allows applications to reconstruct the allowance for all accounts just
1197  * by listening to said events. Other implementations of the EIP may not emit
1198  * these events, as it isn't required by the specification.
1199  *
1200  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1201  * functions have been added to mitigate the well-known issues around setting
1202  * allowances. See {IERC20-approve}.
1203  */
1204 contract ERC20 is Context, IERC20, IERC20Metadata {
1205     mapping(address => uint256) private _balances;
1206 
1207     mapping(address => mapping(address => uint256)) private _allowances;
1208 
1209     uint256 private _totalSupply;
1210     uint256 private _mintedSupply;
1211     uint256 private _mintLimitAmount;
1212 
1213     string private _name;
1214     string private _symbol;
1215 
1216     /**
1217      * @dev Sets the values for {name} and {symbol}.
1218      *
1219      * The default value of {decimals} is 18. To select a different value for
1220      * {decimals} you should overload it.
1221      *
1222      * All two of these values are immutable: they can only be set once during
1223      * construction.
1224      */
1225     constructor(string memory name_, string memory symbol_, uint256 totalSupply_) {
1226         _name = name_;
1227         _symbol = symbol_;
1228         _totalSupply = totalSupply_;
1229     }
1230 
1231     /**
1232      * @dev Returns the name of the token.
1233      */
1234     function name() public view virtual override returns (string memory) {
1235         return _name;
1236     }
1237 
1238     /**
1239      * @dev Returns the symbol of the token, usually a shorter version of the
1240      * name.
1241      */
1242     function symbol() public view virtual override returns (string memory) {
1243         return _symbol;
1244     }
1245 
1246     /**
1247      * @dev Returns the number of decimals used to get its user representation.
1248      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1249      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1250      *
1251      * Tokens usually opt for a value of 18, imitating the relationship between
1252      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1253      * overridden;
1254      *
1255      * NOTE: This information is only used for _display_ purposes: it in
1256      * no way affects any of the arithmetic of the contract, including
1257      * {IERC20-balanceOf} and {IERC20-transfer}.
1258      */
1259     function decimals() public view virtual override returns (uint8) {
1260         return 8;
1261     }
1262 
1263     /**
1264      * @dev See {IERC20-totalSupply}.
1265      */
1266     function totalSupply() public view virtual override returns (uint256) {
1267         return _totalSupply;
1268     }
1269 
1270     /**
1271      * @dev See {IERC20-mintedSupply}.
1272      */
1273     function mintedSupply() public view virtual override returns (uint256) {
1274         return _mintedSupply;
1275     }   
1276 
1277     /**
1278      * @dev See {IERC20-mintedSupply}.
1279      */
1280     function mintLimitAmount() public view virtual override returns (uint256) {
1281         return _mintLimitAmount;
1282     }
1283 
1284     /**
1285      * @dev See {IERC20-balanceOf}.
1286      */
1287     function balanceOf(address account) public view virtual override returns (uint256) {
1288         return _balances[account];
1289     }
1290 
1291     /**
1292      * @dev See {IERC20-transfer}.
1293      *
1294      * Requirements:
1295      *
1296      * - `to` cannot be the zero address.
1297      * - the caller must have a balance of at least `amount`.
1298      */
1299     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1300         address owner = _msgSender();
1301         _transfer(owner, to, amount);
1302         return true;
1303     }
1304 
1305     /**
1306      * @dev See {IERC20-allowance}.
1307      */
1308     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1309         return _allowances[owner][spender];
1310     }
1311 
1312     /**
1313      * @dev See {IERC20-approve}.
1314      *
1315      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1316      * `transferFrom`. This is semantically equivalent to an infinite approval.
1317      *
1318      * Requirements:
1319      *
1320      * - `spender` cannot be the zero address.
1321      */
1322     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1323         address owner = _msgSender();
1324         _approve(owner, spender, amount);
1325         return true;
1326     }
1327 
1328     /**
1329      * @dev See {IERC20-transferFrom}.
1330      *
1331      * Emits an {Approval} event indicating the updated allowance. This is not
1332      * required by the EIP. See the note at the beginning of {ERC20}.
1333      *
1334      * NOTE: Does not update the allowance if the current allowance
1335      * is the maximum `uint256`.
1336      *
1337      * Requirements:
1338      *
1339      * - `from` and `to` cannot be the zero address.
1340      * - `from` must have a balance of at least `amount`.
1341      * - the caller must have allowance for ``from``'s tokens of at least
1342      * `amount`.
1343      */
1344     function transferFrom(
1345         address from,
1346         address to,
1347         uint256 amount
1348     ) public virtual override returns (bool) {
1349         address spender = _msgSender();
1350         _spendAllowance(from, spender, amount);
1351         _transfer(from, to, amount);
1352         return true;
1353     }
1354 
1355     /**
1356      * @dev Atomically increases the allowance granted to `spender` by the caller.
1357      *
1358      * This is an alternative to {approve} that can be used as a mitigation for
1359      * problems described in {IERC20-approve}.
1360      *
1361      * Emits an {Approval} event indicating the updated allowance.
1362      *
1363      * Requirements:
1364      *
1365      * - `spender` cannot be the zero address.
1366      */
1367     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1368         address owner = _msgSender();
1369         _approve(owner, spender, allowance(owner, spender) + addedValue);
1370         return true;
1371     }
1372 
1373     /**
1374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1375      *
1376      * This is an alternative to {approve} that can be used as a mitigation for
1377      * problems described in {IERC20-approve}.
1378      *
1379      * Emits an {Approval} event indicating the updated allowance.
1380      *
1381      * Requirements:
1382      *
1383      * - `spender` cannot be the zero address.
1384      * - `spender` must have allowance for the caller of at least
1385      * `subtractedValue`.
1386      */
1387     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1388         address owner = _msgSender();
1389         uint256 currentAllowance = allowance(owner, spender);
1390         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1391         unchecked {
1392             _approve(owner, spender, currentAllowance - subtractedValue);
1393         }
1394 
1395         return true;
1396     }
1397 
1398     /**
1399      * @dev Moves `amount` of tokens from `from` to `to`.
1400      *
1401      * This internal function is equivalent to {transfer}, and can be used to
1402      * e.g. implement automatic token fees, slashing mechanisms, etc.
1403      *
1404      * Emits a {Transfer} event.
1405      *
1406      * Requirements:
1407      *
1408      * - `from` cannot be the zero address.
1409      * - `to` cannot be the zero address.
1410      * - `from` must have a balance of at least `amount`.
1411      */
1412     function _transfer(
1413         address from,
1414         address to,
1415         uint256 amount
1416     ) internal virtual {
1417         require(from != address(0), "ERC20: transfer from the zero address");
1418         require(to != address(0), "ERC20: transfer to the zero address");
1419 
1420         _beforeTokenTransfer(from, to, amount);
1421 
1422         uint256 fromBalance = _balances[from];
1423         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1424         unchecked {
1425             _balances[from] = fromBalance - amount;
1426             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1427             // decrementing then incrementing.
1428             _balances[to] += amount;
1429         }
1430 
1431         emit Transfer(from, to, amount);
1432 
1433         _afterTokenTransfer(from, to, amount);
1434     }
1435 
1436     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1437      * the total supply.
1438      *
1439      * Emits a {Transfer} event with `from` set to the zero address.
1440      *
1441      * Requirements:
1442      *
1443      * - `account` cannot be the zero address.
1444      */
1445     function _mint(address account, uint256 amount) internal virtual {
1446         require(account != address(0), "ERC20: mint to the zero address");
1447         
1448         require(amount <= _mintLimitAmount, "ERC20: error mint limit");
1449 
1450         _beforeTokenTransfer(address(0), account, amount);
1451 
1452         require(_mintedSupply + amount <= _totalSupply, "ERC20: Exceeding the TotalSupply.");
1453 
1454         _mintedSupply += amount;
1455         unchecked {
1456             // Overflow not possible: balance + amount is at most TotalSupply + amount, which is checked above.
1457             _balances[account] += amount;
1458         }
1459         emit Transfer(address(0), account, amount);
1460 
1461         _afterTokenTransfer(address(0), account, amount);
1462     }
1463 
1464     /**
1465      * @dev SetMintLimitAmount
1466      */
1467     function _setMintLimitAmount(uint256 limitAmount) internal virtual returns (bool) {
1468         _mintLimitAmount = limitAmount;
1469         return true;
1470     }
1471 
1472     /**
1473      * @dev Destroys `amount` tokens from `account`, reducing the
1474      * total supply.
1475      *
1476      * Emits a {Transfer} event with `to` set to the zero address.
1477      *
1478      * Requirements:
1479      *
1480      * - `account` cannot be the zero address.
1481      * - `account` must have at least `amount` tokens.
1482      */
1483     function _burn(address account, uint256 amount) internal virtual {
1484         require(account != address(0), "ERC20: burn from the zero address");
1485 
1486         _beforeTokenTransfer(account, address(0), amount);
1487 
1488         uint256 accountBalance = _balances[account];
1489         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1490         unchecked {
1491             _balances[account] = accountBalance - amount;
1492             // Overflow not possible: amount <= accountBalance <= mintedSupply.
1493             _mintedSupply -= amount;
1494         }
1495 
1496         emit Transfer(account, address(0), amount);
1497 
1498         _afterTokenTransfer(account, address(0), amount);
1499     }
1500 
1501     /**
1502      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1503      *
1504      * This internal function is equivalent to `approve`, and can be used to
1505      * e.g. set automatic allowances for certain subsystems, etc.
1506      *
1507      * Emits an {Approval} event.
1508      *
1509      * Requirements:
1510      *
1511      * - `owner` cannot be the zero address.
1512      * - `spender` cannot be the zero address.
1513      */
1514     function _approve(
1515         address owner,
1516         address spender,
1517         uint256 amount
1518     ) internal virtual {
1519         require(owner != address(0), "ERC20: approve from the zero address");
1520         require(spender != address(0), "ERC20: approve to the zero address");
1521 
1522         _allowances[owner][spender] = amount;
1523         emit Approval(owner, spender, amount);
1524     }
1525 
1526     /**
1527      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1528      *
1529      * Does not update the allowance amount in case of infinite allowance.
1530      * Revert if not enough allowance is available.
1531      *
1532      * Might emit an {Approval} event.
1533      */
1534     function _spendAllowance(
1535         address owner,
1536         address spender,
1537         uint256 amount
1538     ) internal virtual {
1539         uint256 currentAllowance = allowance(owner, spender);
1540         if (currentAllowance != type(uint256).max) {
1541             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1542             unchecked {
1543                 _approve(owner, spender, currentAllowance - amount);
1544             }
1545         }
1546     }
1547 
1548     /**
1549      * @dev Hook that is called before any transfer of tokens. This includes
1550      * minting and burning.
1551      *
1552      * Calling conditions:
1553      *
1554      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1555      * will be transferred to `to`.
1556      * - when `from` is zero, `amount` tokens will be minted for `to`.
1557      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1558      * - `from` and `to` are never both zero.
1559      *
1560      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1561      */
1562     function _beforeTokenTransfer(
1563         address from,
1564         address to,
1565         uint256 amount
1566     ) internal virtual {}
1567 
1568     /**
1569      * @dev Hook that is called after any transfer of tokens. This includes
1570      * minting and burning.
1571      *
1572      * Calling conditions:
1573      *
1574      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1575      * has been transferred to `to`.
1576      * - when `from` is zero, `amount` tokens have been minted for `to`.
1577      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1578      * - `from` and `to` are never both zero.
1579      *
1580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1581      */
1582     function _afterTokenTransfer(
1583         address from,
1584         address to,
1585         uint256 amount
1586     ) internal virtual {}
1587 }
1588 
1589 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1590 
1591 pragma solidity ^0.8.0;
1592 
1593 /**
1594  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1595  * tokens and those that they have an allowance for, in a way that can be
1596  * recognized off-chain (via event analysis).
1597  */
1598 abstract contract ERC20Burnable is Context, ERC20 {
1599     /**
1600      * @dev Destroys `amount` tokens from the caller.
1601      *
1602      * See {ERC20-_burn}.
1603      */
1604     function burn(uint256 amount) public virtual {
1605         _burn(_msgSender(), amount);
1606     }
1607 
1608     /**
1609      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1610      * allowance.
1611      *
1612      * See {ERC20-_burn} and {ERC20-allowance}.
1613      *
1614      * Requirements:
1615      *
1616      * - the caller must have allowance for ``accounts``'s tokens of at least
1617      * `amount`.
1618      */
1619     function burnFrom(address account, uint256 amount) public virtual {
1620         _spendAllowance(account, _msgSender(), amount);
1621         _burn(account, amount);
1622     }
1623 }
1624 
1625 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Pausable.sol)
1626 
1627 pragma solidity ^0.8.0;
1628 
1629 /**
1630  * @dev ERC20 token with pausable token transfers, minting and burning.
1631  *
1632  * Useful for scenarios such as preventing trades until the end of an evaluation
1633  * period, or having an emergency switch for freezing all token transfers in the
1634  * event of a large bug.
1635  */
1636 abstract contract ERC20Pausable is ERC20, Pausable {
1637     /**
1638      * @dev See {ERC20-_beforeTokenTransfer}.
1639      *
1640      * Requirements:
1641      *
1642      * - the contract must not be paused.
1643      */
1644     function _beforeTokenTransfer(
1645         address from,
1646         address to,
1647         uint256 amount
1648     ) internal virtual override {
1649         super._beforeTokenTransfer(from, to, amount);
1650 
1651         require(!paused(), "ERC20Pausable: token transfer while paused");
1652     }
1653 }
1654 
1655 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/presets/ERC20PresetMinterPauser.sol)
1656 
1657 pragma solidity ^0.8.0;
1658 
1659 /**
1660  * @dev {ERC20} token, including:
1661  *
1662  *  - ability for holders to burn (destroy) their tokens
1663  *  - a minter role that allows for token minting (creation)
1664  *  - a pauser role that allows to stop all token transfers
1665  *
1666  * This contract uses {AccessControl} to lock permissioned functions using the
1667  * different roles - head to its documentation for details.
1668  *
1669  * The account that deploys the contract will be granted the minter and pauser
1670  * roles, as well as the default admin role, which will let it grant both minter
1671  * and pauser roles to other accounts.
1672  *
1673  * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
1674  */
1675 contract ERC20PresetMinterPauser is Context, AccessControlEnumerable, ERC20Burnable, ERC20Pausable {
1676     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1677     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1678 
1679     /**
1680      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1681      * account that deploys the contract.
1682      *
1683      * See {ERC20-constructor}.
1684      */
1685     constructor(string memory name, string memory symbol, uint256 totalSupply) ERC20(name, symbol, totalSupply) {
1686         _grantAdminRole(_msgSender());
1687 
1688         _setupRole(MINTER_ROLE, _msgSender());
1689         _setupRole(PAUSER_ROLE, _msgSender());
1690     }
1691 
1692     /**
1693      * @dev Creates `amount` new tokens for `to`.
1694      *
1695      * See {ERC20-_mint}.
1696      *
1697      * Requirements:
1698      *
1699      * - the caller must have the `MINTER_ROLE`.
1700      */
1701     function setMintLimitAmount(uint256 amount) public virtual {
1702         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have ADMIN_ROLE");
1703         _setMintLimitAmount(amount);
1704     }
1705 
1706     /**
1707      * @dev Set limitForMint
1708      *
1709      * See {ERC20- _setMintLimit}.
1710      *
1711      * Requirements:
1712      *
1713      * - the caller must have the `MINTER_ROLE`.
1714      */
1715     function mint(address to, uint256 amount) public virtual {
1716         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1717         _mint(to, amount);
1718     }
1719 
1720     /**
1721      * @dev Pauses all token transfers.
1722      *
1723      * See {ERC20Pausable} and {Pausable-_pause}.
1724      *
1725      * Requirements:
1726      *
1727      * - the caller must have the `PAUSER_ROLE`.
1728      */
1729     function pause() public virtual {
1730         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1731         _pause();
1732     }
1733 
1734     /**
1735      * @dev Unpauses all token transfers.
1736      *
1737      * See {ERC20Pausable} and {Pausable-_unpause}.
1738      *
1739      * Requirements:
1740      *
1741      * - the caller must have the `PAUSER_ROLE`.
1742      */
1743     function unpause() public virtual {
1744         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1745         _unpause();
1746     }
1747 
1748     function _beforeTokenTransfer(
1749         address from,
1750         address to,
1751         uint256 amount
1752     ) internal virtual override(ERC20, ERC20Pausable) {
1753         super._beforeTokenTransfer(from, to, amount);
1754     }
1755 }