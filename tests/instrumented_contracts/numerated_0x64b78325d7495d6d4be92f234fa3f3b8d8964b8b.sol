1 // File: contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
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
31  */
32 library EnumerableSet {
33     // To implement this library for multiple types with as little code
34     // repetition as possible, we write it in terms of a generic Set type with
35     // bytes32 values.
36     // The Set implementation uses private functions, and user-facing
37     // implementations (such as AddressSet) are just wrappers around the
38     // underlying Set.
39     // This means that we can only create new EnumerableSets for types that fit
40     // in bytes32.
41 
42     struct Set {
43         // Storage of set values
44         bytes32[] _values;
45         // Position of the value in the `values` array, plus 1 because index 0
46         // means a value is not in the set.
47         mapping(bytes32 => uint256) _indexes;
48     }
49 
50     /**
51      * @dev Add a value to a set. O(1).
52      *
53      * Returns true if the value was added to the set, that is if it was not
54      * already present.
55      */
56     function _add(Set storage set, bytes32 value) private returns (bool) {
57         if (!_contains(set, value)) {
58             set._values.push(value);
59             // The value is stored at length-1, but we add 1 to all indexes
60             // and use 0 as a sentinel value
61             set._indexes[value] = set._values.length;
62             return true;
63         } else {
64             return false;
65         }
66     }
67 
68     /**
69      * @dev Removes a value from a set. O(1).
70      *
71      * Returns true if the value was removed from the set, that is if it was
72      * present.
73      */
74     function _remove(Set storage set, bytes32 value) private returns (bool) {
75         // We read and store the value's index to prevent multiple reads from the same storage slot
76         uint256 valueIndex = set._indexes[value];
77 
78         if (valueIndex != 0) {
79             // Equivalent to contains(set, value)
80             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
81             // the array, and then remove the last element (sometimes called as 'swap and pop').
82             // This modifies the order of the array, as noted in {at}.
83 
84             uint256 toDeleteIndex = valueIndex - 1;
85             uint256 lastIndex = set._values.length - 1;
86 
87             if (lastIndex != toDeleteIndex) {
88                 bytes32 lastvalue = set._values[lastIndex];
89 
90                 // Move the last value to the index where the value to delete is
91                 set._values[toDeleteIndex] = lastvalue;
92                 // Update the index for the moved value
93                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
94             }
95 
96             // Delete the slot where the moved value was stored
97             set._values.pop();
98 
99             // Delete the index for the deleted slot
100             delete set._indexes[value];
101 
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     /**
109      * @dev Returns true if the value is in the set. O(1).
110      */
111     function _contains(Set storage set, bytes32 value) private view returns (bool) {
112         return set._indexes[value] != 0;
113     }
114 
115     /**
116      * @dev Returns the number of values on the set. O(1).
117      */
118     function _length(Set storage set) private view returns (uint256) {
119         return set._values.length;
120     }
121 
122     /**
123      * @dev Returns the value stored at position `index` in the set. O(1).
124      *
125      * Note that there are no guarantees on the ordering of values inside the
126      * array, and it may change when more values are added or removed.
127      *
128      * Requirements:
129      *
130      * - `index` must be strictly less than {length}.
131      */
132     function _at(Set storage set, uint256 index) private view returns (bytes32) {
133         return set._values[index];
134     }
135 
136     /**
137      * @dev Return the entire set in an array
138      *
139      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
140      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
141      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
142      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
143      */
144     function _values(Set storage set) private view returns (bytes32[] memory) {
145         return set._values;
146     }
147 
148     // Bytes32Set
149 
150     struct Bytes32Set {
151         Set _inner;
152     }
153 
154     /**
155      * @dev Add a value to a set. O(1).
156      *
157      * Returns true if the value was added to the set, that is if it was not
158      * already present.
159      */
160     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
161         return _add(set._inner, value);
162     }
163 
164     /**
165      * @dev Removes a value from a set. O(1).
166      *
167      * Returns true if the value was removed from the set, that is if it was
168      * present.
169      */
170     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
171         return _remove(set._inner, value);
172     }
173 
174     /**
175      * @dev Returns true if the value is in the set. O(1).
176      */
177     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
178         return _contains(set._inner, value);
179     }
180 
181     /**
182      * @dev Returns the number of values in the set. O(1).
183      */
184     function length(Bytes32Set storage set) internal view returns (uint256) {
185         return _length(set._inner);
186     }
187 
188     /**
189      * @dev Returns the value stored at position `index` in the set. O(1).
190      *
191      * Note that there are no guarantees on the ordering of values inside the
192      * array, and it may change when more values are added or removed.
193      *
194      * Requirements:
195      *
196      * - `index` must be strictly less than {length}.
197      */
198     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
199         return _at(set._inner, index);
200     }
201 
202     /**
203      * @dev Return the entire set in an array
204      *
205      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
206      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
207      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
208      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
209      */
210     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
211         return _values(set._inner);
212     }
213 
214     // AddressSet
215 
216     struct AddressSet {
217         Set _inner;
218     }
219 
220     /**
221      * @dev Add a value to a set. O(1).
222      *
223      * Returns true if the value was added to the set, that is if it was not
224      * already present.
225      */
226     function add(AddressSet storage set, address value) internal returns (bool) {
227         return _add(set._inner, bytes32(uint256(uint160(value))));
228     }
229 
230     /**
231      * @dev Removes a value from a set. O(1).
232      *
233      * Returns true if the value was removed from the set, that is if it was
234      * present.
235      */
236     function remove(AddressSet storage set, address value) internal returns (bool) {
237         return _remove(set._inner, bytes32(uint256(uint160(value))));
238     }
239 
240     /**
241      * @dev Returns true if the value is in the set. O(1).
242      */
243     function contains(AddressSet storage set, address value) internal view returns (bool) {
244         return _contains(set._inner, bytes32(uint256(uint160(value))));
245     }
246 
247     /**
248      * @dev Returns the number of values in the set. O(1).
249      */
250     function length(AddressSet storage set) internal view returns (uint256) {
251         return _length(set._inner);
252     }
253 
254     /**
255      * @dev Returns the value stored at position `index` in the set. O(1).
256      *
257      * Note that there are no guarantees on the ordering of values inside the
258      * array, and it may change when more values are added or removed.
259      *
260      * Requirements:
261      *
262      * - `index` must be strictly less than {length}.
263      */
264     function at(AddressSet storage set, uint256 index) internal view returns (address) {
265         return address(uint160(uint256(_at(set._inner, index))));
266     }
267 
268     /**
269      * @dev Return the entire set in an array
270      *
271      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
272      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
273      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
274      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
275      */
276     function values(AddressSet storage set) internal view returns (address[] memory) {
277         bytes32[] memory store = _values(set._inner);
278         address[] memory result;
279 
280         assembly {
281             result := store
282         }
283 
284         return result;
285     }
286 
287     // UintSet
288 
289     struct UintSet {
290         Set _inner;
291     }
292 
293     /**
294      * @dev Add a value to a set. O(1).
295      *
296      * Returns true if the value was added to the set, that is if it was not
297      * already present.
298      */
299     function add(UintSet storage set, uint256 value) internal returns (bool) {
300         return _add(set._inner, bytes32(value));
301     }
302 
303     /**
304      * @dev Removes a value from a set. O(1).
305      *
306      * Returns true if the value was removed from the set, that is if it was
307      * present.
308      */
309     function remove(UintSet storage set, uint256 value) internal returns (bool) {
310         return _remove(set._inner, bytes32(value));
311     }
312 
313     /**
314      * @dev Returns true if the value is in the set. O(1).
315      */
316     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
317         return _contains(set._inner, bytes32(value));
318     }
319 
320     /**
321      * @dev Returns the number of values on the set. O(1).
322      */
323     function length(UintSet storage set) internal view returns (uint256) {
324         return _length(set._inner);
325     }
326 
327     /**
328      * @dev Returns the value stored at position `index` in the set. O(1).
329      *
330      * Note that there are no guarantees on the ordering of values inside the
331      * array, and it may change when more values are added or removed.
332      *
333      * Requirements:
334      *
335      * - `index` must be strictly less than {length}.
336      */
337     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
338         return uint256(_at(set._inner, index));
339     }
340 
341     /**
342      * @dev Return the entire set in an array
343      *
344      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
345      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
346      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
347      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
348      */
349     function values(UintSet storage set) internal view returns (uint256[] memory) {
350         bytes32[] memory store = _values(set._inner);
351         uint256[] memory result;
352 
353         assembly {
354             result := store
355         }
356 
357         return result;
358     }
359 }
360 
361 // File: contracts/utils/Strings.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev String operations.
370  */
371 library Strings {
372     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
373 
374     /**
375      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
376      */
377     function toString(uint256 value) internal pure returns (string memory) {
378         // Inspired by OraclizeAPI's implementation - MIT licence
379         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
380 
381         if (value == 0) {
382             return "0";
383         }
384         uint256 temp = value;
385         uint256 digits;
386         while (temp != 0) {
387             digits++;
388             temp /= 10;
389         }
390         bytes memory buffer = new bytes(digits);
391         while (value != 0) {
392             digits -= 1;
393             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
394             value /= 10;
395         }
396         return string(buffer);
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
401      */
402     function toHexString(uint256 value) internal pure returns (string memory) {
403         if (value == 0) {
404             return "0x00";
405         }
406         uint256 temp = value;
407         uint256 length = 0;
408         while (temp != 0) {
409             length++;
410             temp >>= 8;
411         }
412         return toHexString(value, length);
413     }
414 
415     /**
416      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
417      */
418     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
419         bytes memory buffer = new bytes(2 * length + 2);
420         buffer[0] = "0";
421         buffer[1] = "x";
422         for (uint256 i = 2 * length + 1; i > 1; --i) {
423             buffer[i] = _HEX_SYMBOLS[value & 0xf];
424             value >>= 4;
425         }
426         require(value == 0, "Strings: hex length insufficient");
427         return string(buffer);
428     }
429 }
430 
431 // File: contracts/access/IAccessControl.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev External interface of AccessControl declared to support ERC165 detection.
440  */
441 interface IAccessControl {
442     /**
443      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
444      *
445      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
446      * {RoleAdminChanged} not being emitted signaling this.
447      *
448      * _Available since v3.1._
449      */
450     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
451 
452     /**
453      * @dev Emitted when `account` is granted `role`.
454      *
455      * `sender` is the account that originated the contract call, an admin role
456      * bearer except when using {AccessControl-_setupRole}.
457      */
458     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
459 
460     /**
461      * @dev Emitted when `account` is revoked `role`.
462      *
463      * `sender` is the account that originated the contract call:
464      *   - if using `revokeRole`, it is the admin role bearer
465      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
466      */
467     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
468 
469     /**
470      * @dev Returns `true` if `account` has been granted `role`.
471      */
472     function hasRole(bytes32 role, address account) external view returns (bool);
473 
474     /**
475      * @dev Returns the admin role that controls `role`. See {grantRole} and
476      * {revokeRole}.
477      *
478      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
479      */
480     function getRoleAdmin(bytes32 role) external view returns (bytes32);
481 
482     /**
483      * @dev Grants `role` to `account`.
484      *
485      * If `account` had not been already granted `role`, emits a {RoleGranted}
486      * event.
487      *
488      * Requirements:
489      *
490      * - the caller must have ``role``'s admin role.
491      */
492     function grantRole(bytes32 role, address account) external;
493 
494     /**
495      * @dev Revokes `role` from `account`.
496      *
497      * If `account` had been granted `role`, emits a {RoleRevoked} event.
498      *
499      * Requirements:
500      *
501      * - the caller must have ``role``'s admin role.
502      */
503     function revokeRole(bytes32 role, address account) external;
504 
505     /**
506      * @dev Revokes `role` from the calling account.
507      *
508      * Roles are often managed via {grantRole} and {revokeRole}: this function's
509      * purpose is to provide a mechanism for accounts to lose their privileges
510      * if they are compromised (such as when a trusted device is misplaced).
511      *
512      * If the calling account had been granted `role`, emits a {RoleRevoked}
513      * event.
514      *
515      * Requirements:
516      *
517      * - the caller must be `account`.
518      */
519     function renounceRole(bytes32 role, address account) external;
520 }
521 
522 // File: contracts/access/IAccessControlEnumerable.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
532  */
533 interface IAccessControlEnumerable is IAccessControl {
534     /**
535      * @dev Returns one of the accounts that have `role`. `index` must be a
536      * value between 0 and {getRoleMemberCount}, non-inclusive.
537      *
538      * Role bearers are not sorted in any particular way, and their ordering may
539      * change at any point.
540      *
541      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
542      * you perform all queries on the same block. See the following
543      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
544      * for more information.
545      */
546     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
547 
548     /**
549      * @dev Returns the number of accounts that have `role`. Can be used
550      * together with {getRoleMember} to enumerate all bearers of a role.
551      */
552     function getRoleMemberCount(bytes32 role) external view returns (uint256);
553 }
554 
555 // File: contracts/utils/Context.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Provides information about the current execution context, including the
564  * sender of the transaction and its data. While these are generally available
565  * via msg.sender and msg.data, they should not be accessed in such a direct
566  * manner, since when dealing with meta-transactions the account sending and
567  * paying for execution may not be the actual sender (as far as an application
568  * is concerned).
569  *
570  * This contract is only required for intermediate, library-like contracts.
571  */
572 abstract contract Context {
573     function _msgSender() internal view virtual returns (address) {
574         return msg.sender;
575     }
576 
577 }
578 
579 // File: contracts/access/AccessControl.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 
587 
588 
589 /**
590  * @dev Contract module that allows children to implement role-based access
591  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
592  * members except through off-chain means by accessing the contract event logs. Some
593  * applications may benefit from on-chain enumerability, for those cases see
594  * {AccessControlEnumerable}.
595  *
596  * Roles are referred to by their `bytes32` identifier. These should be exposed
597  * in the external API and be unique. The best way to achieve this is by
598  * using `public constant` hash digests:
599  *
600  * ```
601  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
602  * ```
603  *
604  * Roles can be used to represent a set of permissions. To restrict access to a
605  * function call, use {hasRole}:
606  *
607  * ```
608  * function foo() public {
609  *     require(hasRole(MY_ROLE, msg.sender));
610  *     ...
611  * }
612  * ```
613  *
614  * Roles can be granted and revoked dynamically via the {grantRole} and
615  * {revokeRole} functions. Each role has an associated admin role, and only
616  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
617  *
618  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
619  * that only accounts with this role will be able to grant or revoke other
620  * roles. More complex role relationships can be created by using
621  * {_setRoleAdmin}.
622  *
623  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
624  * grant and revoke this role. Extra precautions should be taken to secure
625  * accounts that have been granted it.
626  */
627 abstract contract AccessControl is Context, IAccessControl {
628     struct RoleData {
629         mapping(address => bool) members;
630         bytes32 adminRole;
631     }
632 
633     mapping(bytes32 => RoleData) private _roles;
634 
635     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
636 
637 
638     /**
639      * @dev Modifier that checks that an account has a specific role. Reverts
640      * with a standardized message including the required role.
641      *
642      * The format of the revert reason is given by the following regular expression:
643      *
644      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
645      *
646      * _Available since v4.1._
647      */
648     modifier onlyRole(bytes32 role) {
649         _checkRole(role);
650         _;
651     }
652 
653     /**
654      * @dev Returns `true` if `account` has been granted `role`.
655      */
656     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
657         return _roles[role].members[account];
658     }
659 
660     /**
661      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
662      * Overriding this function changes the behavior of the {onlyRole} modifier.
663      *
664      * Format of the revert message is described in {_checkRole}.
665      *
666      * _Available since v4.6._
667      */
668     function _checkRole(bytes32 role) internal view virtual {
669         _checkRole(role, _msgSender());
670     }
671 
672     /**
673      * @dev Revert with a standard message if `account` is missing `role`.
674      *
675      * The format of the revert reason is given by the following regular expression:
676      *
677      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
678      */
679     function _checkRole(bytes32 role, address account) internal view virtual {
680         if (!hasRole(role, account)) {
681             revert(
682                 string(
683                     abi.encodePacked(
684                         "AccessControl: account ",
685                         Strings.toHexString(uint160(account), 20),
686                         " is missing role ",
687                         Strings.toHexString(uint256(role), 32)
688                     )
689                 )
690             );
691         }
692     }
693 
694     /**
695      * @dev Returns the admin role that controls `role`. See {grantRole} and
696      * {revokeRole}.
697      *
698      * To change a role's admin, use {_setRoleAdmin}.
699      */
700     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
701         return _roles[role].adminRole;
702     }
703 
704     /**
705      * @dev Grants `role` to `account`.
706      *
707      * If `account` had not been already granted `role`, emits a {RoleGranted}
708      * event.
709      *
710      * Requirements:
711      *
712      * - the caller must have ``role``'s admin role.
713      */
714     function grantRole(bytes32 role, address account) external virtual override onlyRole(getRoleAdmin(role)) {
715         _grantRole(role, account);
716     }
717 
718     /**
719      * @dev Revokes `role` from `account`.
720      *
721      * If `account` had been granted `role`, emits a {RoleRevoked} event.
722      *
723      * Requirements:
724      *
725      * - the caller must have ``role``'s admin role.
726      */
727     function revokeRole(bytes32 role, address account) external virtual override onlyRole(getRoleAdmin(role)) {
728         _revokeRole(role, account);
729     }
730 
731     /**
732      * @dev Revokes `role` from the calling account.
733      *
734      * Roles are often managed via {grantRole} and {revokeRole}: this function's
735      * purpose is to provide a mechanism for accounts to lose their privileges
736      * if they are compromised (such as when a trusted device is misplaced).
737      *
738      * If the calling account had been revoked `role`, emits a {RoleRevoked}
739      * event.
740      *
741      * Requirements:
742      *
743      * - the caller must be `account`.
744      */
745     function renounceRole(bytes32 role, address account) external virtual override {
746         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
747         _revokeRole(role, account);
748     }
749 
750     /**
751      * @dev Grants `role` to `account`.
752      *
753      * If `account` had not been already granted `role`, emits a {RoleGranted}
754      * event. Note that unlike {grantRole}, this function doesn't perform any
755      * checks on the calling account.
756      *
757      * [WARNING]
758      * ====
759      * This function should only be called from the constructor when setting
760      * up the initial roles for the system.
761      *
762      * Using this function in any other way is effectively circumventing the admin
763      * system imposed by {AccessControl}.
764      * ====
765      *
766      * NOTE: This function is deprecated in favor of {_grantRole}.
767      */
768     function _setupRole(bytes32 role, address account) internal virtual {
769         _grantRole(role, account);
770     }
771 
772     /**
773      * @dev Sets `adminRole` as ``role``'s admin role.
774      *
775      * Emits a {RoleAdminChanged} event.
776      */
777     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
778         bytes32 previousAdminRole = getRoleAdmin(role);
779         _roles[role].adminRole = adminRole;
780         emit RoleAdminChanged(role, previousAdminRole, adminRole);
781     }
782 
783     /**
784      * @dev Grants `role` to `account`.
785      *
786      * Internal function without access restriction.
787      */
788     function _grantRole(bytes32 role, address account) internal virtual {
789         if (!hasRole(role, account)) {
790             _roles[role].members[account] = true;
791             emit RoleGranted(role, account, _msgSender());
792         }
793     }
794 
795     /**
796      * @dev Revokes `role` from `account`.
797      *
798      * Internal function without access restriction.
799      */
800     function _revokeRole(bytes32 role, address account) internal virtual {
801         if (hasRole(role, account)) {
802             _roles[role].members[account] = false;
803             emit RoleRevoked(role, account, _msgSender());
804         }
805     }
806 }
807 
808 // File: contracts/access/AccessControlEnumerable.sol
809 
810 
811 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
812 
813 pragma solidity ^0.8.0;
814 
815 
816 
817 
818 /**
819  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
820  */
821 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
822     using EnumerableSet for EnumerableSet.AddressSet;
823 
824     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
825 
826     bool public lastActionResult;
827 
828     event RoleIsNotExist(bytes32 role, address account);
829     event RoleIsExit(bytes32 role, address account);
830     /**
831      * @dev Returns one of the accounts that have `role`. `index` must be a
832      * value between 0 and {getRoleMemberCount}, non-inclusive.
833      *
834      * Role bearers are not sorted in any particular way, and their ordering may
835      * change at any point.
836      *
837      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
838      * you perform all queries on the same block. See the following
839      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
840      * for more information.
841      */
842     function getRoleMember(bytes32 role, uint256 index) external view virtual override returns (address) {
843         return _roleMembers[role].at(index);
844     }
845 
846     /**
847      * @dev Returns the number of accounts that have `role`. Can be used
848      * together with {getRoleMember} to enumerate all bearers of a role.
849      */
850     function getRoleMemberCount(bytes32 role) external view virtual override returns (uint256) {
851         return _roleMembers[role].length();
852     }
853 
854     /**
855      * @dev Overload {_grantRole} to track enumerable memberships
856      */
857     function _grantRole(bytes32 role, address account) internal virtual override {
858         super._grantRole(role, account);
859         lastActionResult = _roleMembers[role].add(account);
860     }
861 
862     /**
863      * @dev Overload {_revokeRole} to track enumerable memberships
864      */
865     function _revokeRole(bytes32 role, address account) internal virtual override {
866         super._revokeRole(role, account);
867         lastActionResult =  _roleMembers[role].remove(account);
868     }
869 }
870 
871 // File: contracts/security/Pausable.sol
872 
873 
874 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
875 
876 pragma solidity ^0.8.0;
877 
878 
879 /**
880  * @dev Contract module which allows children to implement an emergency stop
881  * mechanism that can be triggered by an authorized account.
882  *
883  * This module is used through inheritance. It will make available the
884  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
885  * the functions of your contract. Note that they will not be pausable by
886  * simply including this module, only once the modifiers are put in place.
887  */
888 abstract contract Pausable is Context {
889     /**
890      * @dev Emitted when the pause is triggered by `account`.
891      */
892     event Paused(address account);
893 
894     /**
895      * @dev Emitted when the pause is lifted by `account`.
896      */
897     event Unpaused(address account);
898 
899     bool private _paused;
900 
901     /**
902      * @dev Initializes the contract in unpaused state.
903      */
904     constructor() {
905         _paused = false;
906     }
907 
908     /**
909      * @dev Returns true if the contract is paused, and false otherwise.
910      */
911     function paused() public view virtual returns (bool) {
912         return _paused;
913     }
914 
915     /**
916      * @dev Modifier to make a function callable only when the contract is not paused.
917      *
918      * Requirements:
919      *
920      * - The contract must not be paused.
921      */
922     modifier whenNotPaused() {
923         require(!paused(), "Pausable: paused");
924         _;
925     }
926 
927     /**
928      * @dev Modifier to make a function callable only when the contract is paused.
929      *
930      * Requirements:
931      *
932      * - The contract must be paused.
933      */
934     modifier whenPaused() {
935         require(paused(), "Pausable: not paused");
936         _;
937     }
938 
939     /**
940      * @dev Triggers stopped state.
941      *
942      * Requirements:
943      *
944      * - The contract must not be paused.
945      */
946     function _pause() internal virtual whenNotPaused {
947         _paused = true;
948         emit Paused(_msgSender());
949     }
950 
951     /**
952      * @dev Returns to normal state.
953      *
954      * Requirements:
955      *
956      * - The contract must be paused.
957      */
958     function _unpause() internal virtual whenPaused {
959         _paused = false;
960         emit Unpaused(_msgSender());
961     }
962 }
963 
964 // File: contracts/IERC20.sol
965 
966 
967 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
968 
969 pragma solidity ^0.8.0;
970 
971 /**
972  * @dev Interface of the ERC20 standard as defined in the EIP.
973  */
974 interface IERC20 {
975     /**
976      * @dev Returns the amount of tokens in existence.
977      */
978     function totalSupply() external view returns (uint256);
979 
980     /**
981      * @dev Returns the amount of tokens owned by `account`.
982      */
983     function balanceOf(address account) external view returns (uint256);
984 
985     /**
986      * @dev Moves `amount` tokens from the caller's account to `to`.
987      *
988      * Returns a boolean value indicating whether the operation succeeded.
989      *
990      * Emits a {Transfer} event.
991      */
992     function transfer(address to, uint256 amount) external returns (bool);
993 
994     /**
995      * @dev Returns the remaining number of tokens that `spender` will be
996      * allowed to spend on behalf of `owner` through {transferFrom}. This is
997      * zero by default.
998      *
999      * This value changes when {approve} or {transferFrom} are called.
1000      */
1001     function allowance(address owner, address spender) external view returns (uint256);
1002 
1003     /**
1004      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1005      *
1006      * Returns a boolean value indicating whether the operation succeeded.
1007      *
1008      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1009      * that someone may use both the old and the new allowance by unfortunate
1010      * transaction ordering. One possible solution to mitigate this race
1011      * condition is to first reduce the spender's allowance to 0 and set the
1012      * desired value afterwards:
1013      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1014      *
1015      * Emits an {Approval} event.
1016      */
1017     function approve(address spender, uint256 amount) external returns (bool);
1018 
1019     /**
1020      * @dev Moves `amount` tokens from `from` to `to` using the
1021      * allowance mechanism. `amount` is then deducted from the caller's
1022      * allowance.
1023      *
1024      * Returns a boolean value indicating whether the operation succeeded.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function transferFrom(
1029         address from,
1030         address to,
1031         uint256 amount
1032     ) external returns (bool);
1033 
1034     /**
1035      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1036      * another (`to`).
1037      *
1038      * Note that `value` may be zero.
1039      */
1040     event Transfer(address indexed from, address indexed to, uint256 value);
1041 
1042     /**
1043      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1044      * a call to {approve}. `value` is the new allowance.
1045      */
1046     event Approval(address indexed owner, address indexed spender, uint256 value);
1047 }
1048 
1049 // File: contracts/extensions/IERC20Metadata.sol
1050 
1051 
1052 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1053 
1054 pragma solidity ^0.8.0;
1055 
1056 
1057 /**
1058  * @dev Interface for the optional metadata functions from the ERC20 standard.
1059  *
1060  * _Available since v4.1._
1061  */
1062 interface IERC20Metadata is IERC20 {
1063     /**
1064      * @dev Returns the name of the token.
1065      */
1066     function name() external view returns (string memory);
1067 
1068     /**
1069      * @dev Returns the symbol of the token.
1070      */
1071     function symbol() external view returns (string memory);
1072 
1073     /**
1074      * @dev Returns the decimals places of the token.
1075      */
1076     function decimals() external view returns (uint8);
1077 }
1078 
1079 // File: contracts/ERC20.sol
1080 
1081 
1082 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
1083 
1084 pragma solidity ^0.8.0;
1085 
1086 
1087 
1088 
1089 /**
1090  * @dev Implementation of the {IERC20} interface.
1091  *
1092  * This implementation is agnostic to the way tokens are created. This means
1093  * that a supply mechanism has to be added in a derived contract using {_mint}.
1094  * For a generic mechanism see {ERC20PresetMinterPauser}.
1095  *
1096  * TIP: For a detailed writeup see our guide
1097  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1098  * to implement supply mechanisms].
1099  *
1100  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1101  * instead returning `false` on failure. This behavior is nonetheless
1102  * conventional and does not conflict with the expectations of ERC20
1103  * applications.
1104  *
1105  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1106  * This allows applications to reconstruct the allowance for all accounts just
1107  * by listening to said events. Other implementations of the EIP may not emit
1108  * these events, as it isn't required by the specification.
1109  *
1110  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1111  * functions have been added to mitigate the well-known issues around setting
1112  * allowances. See {IERC20-approve}.
1113  */
1114 contract ERC20 is Context, IERC20, IERC20Metadata {
1115     mapping(address => uint256) private _balances;
1116 
1117     mapping(address => mapping(address => uint256)) private _allowances;
1118 
1119     mapping (address => bool) private _isExcludedFromFee;
1120 
1121     uint256 private _totalSupply;
1122 
1123     string private _name;
1124     string private _symbol;
1125 
1126     uint256 private feeRate;
1127 
1128     
1129     uint256 private _transferFeePoolBalance;
1130 
1131     bool private _transferFeePaused;
1132 
1133     
1134     /**
1135      * @dev Sets the values for {name} and {symbol}.
1136      *
1137      * The default value of {decimals} is 18. To select a different value for
1138      * {decimals} you should overload it.
1139      *
1140      * All two of these values are immutable: they can only be set once during
1141      * construction.
1142      */
1143     constructor(string memory name_, string memory symbol_) {
1144         _name = name_;
1145         _symbol = symbol_;
1146     }
1147 
1148     /**
1149      * @dev Returns the name of the token.
1150      */
1151     function name() public view virtual override returns (string memory) {
1152         return _name;
1153     }
1154 
1155     /**
1156      * @dev Returns the symbol of the token, usually a shorter version of the
1157      * name.
1158      */
1159     function symbol() public view virtual override returns (string memory) {
1160         return _symbol;
1161     }
1162 
1163     /**
1164      * @dev Returns the number of decimals used to get its user representation.
1165      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1166      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1167      *
1168      * Tokens usually opt for a value of 18, imitating the relationship between
1169      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1170      * overridden;
1171      *
1172      * NOTE: This information is only used for _display_ purposes: it in
1173      * no way affects any of the arithmetic of the contract, including
1174      * {IERC20-balanceOf} and {IERC20-transfer}.
1175      */
1176     function decimals() public view virtual override returns (uint8) {
1177         return 18;
1178     }
1179 
1180     /**
1181      * @dev See {IERC20-totalSupply}.
1182      */
1183     function totalSupply() public view virtual override returns (uint256) {
1184         return _totalSupply;
1185     }
1186 
1187     /**
1188      * @dev See {IERC20-balanceOf}.
1189      */
1190     function balanceOf(address account) public view virtual override returns (uint256) {
1191         return _balances[account];
1192     }
1193 
1194     /**
1195      * @dev See {IERC20-transfer}.
1196      *
1197      * Requirements:
1198      *
1199      * - `to` cannot be the zero address.
1200      * - the caller must have a balance of at least `amount`.
1201      */
1202     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1203         address owner = _msgSender();
1204         _transfer(owner, to, amount);
1205         return true;
1206     }
1207 
1208     /**
1209      * @dev See {IERC20-allowance}.
1210      */
1211     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1212         return _allowances[owner][spender];
1213     }
1214 
1215     /**
1216      * @dev See {IERC20-approve}.
1217      *
1218      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1219      * `transferFrom`. This is semantically equivalent to an infinite approval.
1220      *
1221      * Requirements:
1222      *
1223      * - `spender` cannot be the zero address.
1224      */
1225     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1226         address owner = _msgSender();
1227         _approve(owner, spender, amount);
1228         return true;
1229     }
1230 
1231     /**
1232      * @dev See {IERC20-transferFrom}.
1233      *
1234      * Emits an {Approval} event indicating the updated allowance. This is not
1235      * required by the EIP. See the note at the beginning of {ERC20}.
1236      *
1237      * NOTE: Does not update the allowance if the current allowance
1238      * is the maximum `uint256`.
1239      *
1240      * Requirements:
1241      *
1242      * - `from` and `to` cannot be the zero address.
1243      * - `from` must have a balance of at least `amount`.
1244      * - the caller must have allowance for ``from``'s tokens of at least
1245      * `amount`.
1246      */
1247     function transferFrom(
1248         address from,
1249         address to,
1250         uint256 amount
1251     ) public virtual override returns (bool) {
1252         address spender = _msgSender();
1253         _spendAllowance(from, spender, amount);
1254         _transfer(from, to, amount);
1255         return true;
1256     }
1257 
1258     /**
1259      * @dev Atomically increases the allowance granted to `spender` by the caller.
1260      *
1261      * This is an alternative to {approve} that can be used as a mitigation for
1262      * problems described in {IERC20-approve}.
1263      *
1264      * Emits an {Approval} event indicating the updated allowance.
1265      *
1266      * Requirements:
1267      *
1268      * - `spender` cannot be the zero address.
1269      */
1270     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1271         address owner = _msgSender();
1272         _approve(owner, spender, allowance(owner, spender) + addedValue);
1273         return true;
1274     }
1275 
1276     /**
1277      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1278      *
1279      * This is an alternative to {approve} that can be used as a mitigation for
1280      * problems described in {IERC20-approve}.
1281      *
1282      * Emits an {Approval} event indicating the updated allowance.
1283      *
1284      * Requirements:
1285      *
1286      * - `spender` cannot be the zero address.
1287      * - `spender` must have allowance for the caller of at least
1288      * `subtractedValue`.
1289      */
1290     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1291         address owner = _msgSender();
1292         uint256 currentAllowance = allowance(owner, spender);
1293         require(currentAllowance >= subtractedValue, "SpiExt: decreased allowance below zero");
1294         unchecked {
1295             _approve(owner, spender, currentAllowance - subtractedValue);
1296         }
1297 
1298         return true;
1299     }
1300 
1301     function _transfer(
1302         address from,
1303         address to,
1304         uint256 amount
1305     ) internal virtual {
1306         require(from != address(0), "SpiExt: transfer from the zero address");
1307         require(to != address(0), "SpiExt: transfer to the zero address1");
1308 
1309         uint256 amountToTransfer = amount;
1310         uint256 transferFee = 0;
1311 
1312         //indicates if fee should be deducted from transfer
1313         bool takeFee = true;
1314         
1315         //if any account belongs to _isExcludedFromFee account then remove the fee
1316         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1317             takeFee = false;
1318         }
1319 
1320         if(!_transferFeePaused && takeFee) {
1321             transferFee = amount*feeRate/100;
1322             amountToTransfer -= transferFee;
1323         }
1324 
1325         _beforeTokenTransfer(from, to, amountToTransfer);
1326 
1327         uint256 fromBalance = balanceOf(from);
1328         require(fromBalance >= amount, "SpiExt: transfer amount exceeds balance");
1329 
1330         _transferFeePoolBalance += transferFee;
1331         unchecked {
1332             _balances[from] = fromBalance - amount;
1333         }
1334         _balances[to] += amountToTransfer;
1335 
1336         emit Transfer(from, to, amountToTransfer);
1337 
1338         _afterTokenTransfer(from, to, amountToTransfer);
1339     }
1340 
1341     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1342      * the total supply.
1343      *
1344      * Emits a {Transfer} event with `from` set to the zero address.
1345      *
1346      * Requirements:
1347      *
1348      * - `account` cannot be the zero address.
1349      */
1350     function _mint(address account, uint256 amount) internal virtual {
1351         require(account != address(0), "SpiExt: mint to the zero address");
1352 
1353         _beforeTokenTransfer(address(0), account, amount);
1354 
1355         _totalSupply += amount;
1356         _balances[account] += amount;
1357         emit Transfer(address(0), account, amount);
1358 
1359         _afterTokenTransfer(address(0), account, amount);
1360     }
1361 
1362     /**
1363      * @dev Destroys `amount` tokens from `account`, reducing the
1364      * total supply.
1365      *
1366      * Emits a {Transfer} event with `to` set to the zero address.
1367      *
1368      * Requirements:
1369      *
1370      * - `account` cannot be the zero address.
1371      * - `account` must have at least `amount` tokens.
1372      */
1373     function _burn(address account, uint256 amount) internal virtual {
1374         require(account != address(0), "SpiExt: burn from the zero address");
1375 
1376         _beforeTokenTransfer(account, address(0), amount);
1377 
1378         uint256 accountBalance = _balances[account];
1379         require(accountBalance >= amount, "SpiExt: burn amount exceeds balance");
1380         unchecked {
1381             _balances[account] = accountBalance - amount;
1382         }
1383         _totalSupply -= amount;
1384 
1385         emit Transfer(account, address(0), amount);
1386 
1387         _afterTokenTransfer(account, address(0), amount);
1388     }
1389 
1390     /**ERC20r` over the `owner` s tokens.
1391      *
1392      * This internal function is equivalent to `approve`, and can be used to
1393      * e.g. set automatic allowances for certain subsystems, etc.
1394      *
1395      * Emits an {Approval} event.
1396      *
1397      * Requirements:
1398      *
1399      * - `owner` cannot be the zero address.
1400      * - `spender` cannot be the zero address.
1401      */
1402     function _approve(
1403         address owner,
1404         address spender,
1405         uint256 amount
1406     ) internal virtual {
1407         require(owner != address(0), "SpiExt: approve from the zero address");
1408         require(spender != address(0), "SpiExt: approve to the zero address");
1409 
1410         _allowances[owner][spender] = amount;
1411         emit Approval(owner, spender, amount);
1412     }
1413 
1414     /**
1415      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1416      *
1417      * Does not update the allowance amount in case of infinite allowance.
1418      * Revert if not enough allowance is available.
1419      *
1420      * Might emit an {Approval} event.
1421      */
1422     function _spendAllowance(
1423         address owner,
1424         address spender,
1425         uint256 amount
1426     ) internal virtual {
1427         uint256 currentAllowance = allowance(owner, spender);
1428         if (currentAllowance != type(uint256).max) {
1429             require(currentAllowance >= amount, "SpiExt: insufficient allowance");
1430             unchecked {
1431                 _approve(owner, spender, currentAllowance - amount);
1432             }
1433         }
1434     }
1435 
1436     /**
1437      * @dev Hook that is called before any transfer of tokens. This includes
1438      * minting and burning.
1439      *
1440      * Calling conditions:
1441      *
1442      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1443      * will be transferred to `to`.
1444      * - when `from` is zero, `amount` tokens will be minted for `to`.
1445      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1446      * - `from` and `to` are never both zero.
1447      *
1448      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1449      */
1450     function _beforeTokenTransfer(
1451         address from,
1452         address to,
1453         uint256 amount
1454     ) internal virtual {}
1455 
1456     function _afterTokenTransfer(
1457         address from,
1458         address to,
1459         uint256 amount
1460     ) internal virtual {}
1461 
1462     function _getFeeRate() internal view returns(uint256){
1463         return feeRate;
1464     }
1465 
1466     function _setFeeRate(uint256 _feeRate) internal {
1467         feeRate = _feeRate;
1468     }
1469 
1470     function _pauseTransferFee() internal {
1471         _transferFeePaused = true;
1472     }
1473 
1474     function _unpauseTransferFee() internal {
1475         _transferFeePaused = false;
1476     }
1477 
1478     function _getTransferFeePaused() internal view returns(bool) {
1479         return _transferFeePaused;
1480     }
1481 
1482     function getTransferFeePoolBalance() public view returns(uint256) {
1483         return _transferFeePoolBalance;
1484     }
1485 
1486     function _transferFromFeePool(uint256 amount, address to) internal returns(bool) {
1487         require(_transferFeePoolBalance >= amount, "SPIExt: amount should be lower than pool balance");
1488         _transferFeePoolBalance -= amount;
1489         _balances[to] += amount;
1490         return true;
1491     }
1492 
1493     function _excludeFromFee(address account) internal {
1494         _isExcludedFromFee[account] = true;
1495     }
1496     
1497     function _includeInFee(address account) internal {
1498         _isExcludedFromFee[account] = false;
1499     }
1500 
1501     function isExcludedFromFee(address account) public view returns(bool) {
1502         return _isExcludedFromFee[account];
1503     }
1504 }
1505 
1506 // File: contracts/extensions/ERC20Pausable.sol
1507 
1508 
1509 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Pausable.sol)
1510 
1511 pragma solidity ^0.8.0;
1512 
1513 
1514 
1515 /**
1516  * @dev ERC20 token with pausable token transfers, minting and burning.
1517  *
1518  * Useful for scenarios such as preventing trades until the end of an evaluation
1519  * period, or having an emergency switch for freezing all token transfers in the
1520  * event of a large bug.
1521  */
1522 abstract contract ERC20Pausable is ERC20, Pausable {
1523     /**
1524      * @dev See {ERC20-_beforeTokenTransfer}.
1525      *
1526      * Requirements:
1527      *
1528      * - the contract must not be paused.
1529      */
1530     function _beforeTokenTransfer(
1531         address from,
1532         address to,
1533         uint256 amount
1534     ) internal virtual override {
1535         super._beforeTokenTransfer(from, to, amount);
1536 
1537         require(!paused(), "ERC20Pausable: token transfer while paused");
1538     }
1539 }
1540 
1541 // File: contracts/extensions/ERC20Burnable.sol
1542 
1543 
1544 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1545 
1546 pragma solidity ^0.8.0;
1547 
1548 
1549 
1550 /**
1551  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1552  * tokens and those that they have an allowance for, in a way that can be
1553  * recognized off-chain (via event analysis).
1554  */
1555 abstract contract ERC20Burnable is Context, ERC20 {
1556     /**
1557      * @dev Destroys `amount` tokens from the caller.
1558      *
1559      * See {ERC20-_burn}.
1560      */
1561     function burn(uint256 amount) public virtual {
1562         _burn(_msgSender(), amount);
1563     }
1564 
1565     /**
1566      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1567      * allowance.
1568      *
1569      * See {ERC20-_burn} and {ERC20-allowance}.
1570      *
1571      * Requirements:
1572      *
1573      * - the caller must have allowance for ``accounts``'s tokens of at least
1574      * `amount`.
1575      */
1576     function burnFrom(address account, uint256 amount) public virtual {
1577         _spendAllowance(account, _msgSender(), amount);
1578         _burn(account, amount);
1579     }
1580 }
1581 
1582 // File: contracts/SpiExt.sol
1583 
1584 
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 
1589 
1590 
1591 
1592 
1593 
1594 
1595 contract SpiExt is Context, AccessControlEnumerable, ERC20Burnable, ERC20Pausable {
1596     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1597     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1598     bytes32 public constant MINT_APPROVER_ROLE = keccak256("MINTER_APPROVER");
1599 
1600     Approver[2] private adminApprovers;
1601 
1602     Approver[2] public mintApprovers;
1603 
1604     uint256 private adminTimelock;
1605 
1606     uint256 private mintTimelock;
1607    // address[2] public recoveryAdmin;
1608 
1609     struct Approver {  
1610         address approverAddress;  
1611         bool approved;
1612         uint256 timestamp; 
1613     }
1614 
1615     event TransferReceived(address _from, uint256 _amount);
1616     event TransferSent(address _from, address _destAddr, uint256 _amount);
1617     event CalledFallback(address, uint256);
1618     event MintingApproved(address);
1619     event MintingApprovalRevoked(address);
1620     event ActivityApproved(address);
1621     event ActivityApprovalRevoked(address);
1622 
1623     /**
1624 
1625      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1626      * account that deploys the contract.
1627      *
1628      * See {ERC20-constructor}.
1629      */
1630     constructor(string memory name, string memory symbol, address adminApprover, address adminApprover2, address mintApprover, address mintApprover2) payable ERC20(name, symbol){
1631         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1632         _setupRole(MINTER_ROLE, _msgSender());
1633         _setupRole(PAUSER_ROLE, _msgSender());
1634         //Admin users adding
1635         adminApprovers[0].approverAddress = adminApprover;
1636         adminApprovers[0].approved = false;
1637         _grantRole(DEFAULT_ADMIN_ROLE, adminApprover);
1638         adminApprovers[1].approverAddress = adminApprover2;
1639         adminApprovers[1].approved = false;
1640         _grantRole(DEFAULT_ADMIN_ROLE, adminApprover2);
1641         //Mint approvals users adding
1642         mintApprovers[0].approverAddress = mintApprover;
1643         mintApprovers[0].approved = false;
1644         _grantRole(MINT_APPROVER_ROLE, mintApprover);
1645         mintApprovers[1].approverAddress = mintApprover2;
1646         mintApprovers[1].approved = false;
1647         _grantRole(MINT_APPROVER_ROLE, mintApprover2);
1648     }
1649 
1650     receive() payable external {
1651         emit TransferReceived(msg.sender, msg.value);
1652     } 
1653         
1654     fallback() payable external{
1655         emit CalledFallback(msg.sender, msg.value);
1656     }
1657 
1658     function transferFromContract(address payable to, uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
1659         uint256 erc20balance = this.balanceOf(address(this));
1660         require(amount <= erc20balance, "SPIExt: balance is not sufficient for the transaction");
1661         this.transfer(to, amount);
1662         emit TransferSent(address(this), to, amount);
1663     }     
1664 
1665     function approveMint() external onlyRole(MINT_APPROVER_ROLE) {
1666         if( _msgSender() == mintApprovers[0].approverAddress) {
1667             mintApprovers[0].approved = true;
1668             mintApprovers[0].timestamp = block.timestamp;
1669         } else if (_msgSender() == mintApprovers[1].approverAddress) {
1670            mintApprovers[1].approved = true;
1671            mintApprovers[1].timestamp = block.timestamp;
1672         } 
1673         emit MintingApproved(_msgSender());
1674     }
1675 
1676     function revokeMintApproval() external onlyRole(MINT_APPROVER_ROLE) {
1677         if( _msgSender() == mintApprovers[0].approverAddress) {
1678             mintApprovers[0].approved = false;
1679         } else if (_msgSender() == mintApprovers[1].approverAddress) {
1680            mintApprovers[1].approved = false;
1681         } 
1682         emit MintingApprovalRevoked(_msgSender());
1683     }
1684 
1685     function getMintApprovalTimestamp() public view returns(uint256) {
1686         if(mintApprovers[0].approved && mintApprovers[1].approved) {
1687             return mintApprovers[0].timestamp > mintApprovers[1].timestamp ? mintApprovers[1].timestamp : mintApprovers[0].timestamp;
1688         } 
1689         if(mintApprovers[0].approved) {
1690             return mintApprovers[0].timestamp;
1691         }
1692         if(mintApprovers[1].approved) {
1693             return mintApprovers[1].timestamp;
1694         }
1695         return 0;
1696     }
1697 
1698     function isMintApproved() public view onlyRole(DEFAULT_ADMIN_ROLE) returns(bool) {
1699         uint256 mintApprovalTimestamp = getMintApprovalTimestamp();
1700         return mintApprovalTimestamp > 0 && block.timestamp > mintApprovalTimestamp + mintTimelock;
1701     }
1702 
1703     function resetMintApprovedInt() private {
1704         mintApprovers[0].approved = false;
1705         mintApprovers[1].approved = false;
1706     }
1707 
1708     function setMintApprover(address mintApprover, uint index) public onlyRole(DEFAULT_ADMIN_ROLE) {
1709         require(isApproved(), "SPIExt: Activity not approved");
1710         if(index >= 0 && index < mintApprovers.length) {
1711             mintApprovers[index].approverAddress = mintApprover;
1712             mintApprovers[index].approved = false;
1713             _grantRole(MINT_APPROVER_ROLE, mintApprover);
1714             resetApprovedInt();
1715         } 
1716     }
1717 
1718     /**
1719      * @dev Creates `amount` new tokens for `to`.
1720      *
1721      * See {ERC20-_mint}.
1722      *
1723      * Requirements:
1724      *
1725      * - the caller must have the `MINTER_ROLE`.
1726      */
1727     function mint(address to, uint256 amount) public virtual {
1728         require(hasRole(MINTER_ROLE, _msgSender()), "SPIExt: must have minter role to mint");
1729         require(isMintApproved(), "SpiExt: Minting not approved by approver");
1730         resetMintApprovedInt();
1731         _mint(to, amount);
1732     }
1733 
1734      /**
1735      * @dev Set flag to approve for critical activity within the token
1736      *
1737      *
1738      * Requirements:
1739      *
1740      * - the caller must have the `DEFAULT_ADMIN_ROLE`.
1741      */
1742     function approveActivity() external onlyRole(DEFAULT_ADMIN_ROLE) {
1743         require(adminApprovers[0].approverAddress == _msgSender() || adminApprovers[1].approverAddress == _msgSender(), "SPIExt: not enough permission for the operation");
1744         if(adminApprovers[0].approverAddress == _msgSender()) {
1745             adminApprovers[0].approved = true;
1746             adminApprovers[0].timestamp = block.timestamp;
1747         } else {
1748             adminApprovers[1].approved = true;
1749             adminApprovers[1].timestamp = block.timestamp;
1750         }
1751         emit ActivityApproved(_msgSender());
1752     }
1753 
1754     function revokeAdminApproval() external onlyRole(DEFAULT_ADMIN_ROLE) {
1755         require(adminApprovers[0].approverAddress == _msgSender() || adminApprovers[1].approverAddress == _msgSender(), "SPIExt: not enough permission for the operation");
1756         if( _msgSender() == adminApprovers[0].approverAddress) {
1757             adminApprovers[0].approved = false;
1758         } else if (_msgSender() == adminApprovers[1].approverAddress) {
1759             adminApprovers[1].approved = false;
1760         } 
1761         emit ActivityApprovalRevoked(_msgSender());
1762     }
1763 
1764     function getAdminApprovalTimestamp() public view onlyRole(DEFAULT_ADMIN_ROLE) returns(uint256) {
1765         if((adminApprovers[0].approved && adminApprovers[0].approverAddress != _msgSender()) 
1766             && (adminApprovers[1].approved && adminApprovers[1].approverAddress != _msgSender())) {
1767             return adminApprovers[0].timestamp > adminApprovers[1].timestamp ? adminApprovers[1].timestamp : adminApprovers[0].timestamp;
1768         } 
1769         if(adminApprovers[0].approved && adminApprovers[0].approverAddress != _msgSender()) {
1770             return adminApprovers[0].timestamp;
1771         }
1772         if(adminApprovers[1].approved && adminApprovers[1].approverAddress != _msgSender()) {
1773             return adminApprovers[1].timestamp;
1774         }
1775         return 0;
1776     }
1777 
1778     function isApproved() public view onlyRole(DEFAULT_ADMIN_ROLE) returns(bool) {
1779         if((!adminApprovers[0].approved && adminApprovers[1].approverAddress == _msgSender()) 
1780             || (!adminApprovers[1].approved && adminApprovers[0].approverAddress == _msgSender())) {
1781             return false;
1782         }
1783         uint256 adminApprovalTimestamp = getAdminApprovalTimestamp();
1784         return adminApprovalTimestamp > 0 && block.timestamp > adminApprovalTimestamp + adminTimelock;
1785     }
1786 
1787     function resetApprovedInt() private {
1788         adminApprovers[0].approved = false;
1789         adminApprovers[1].approved = false;
1790     }
1791 
1792     function setApprovalAdmin(address _recoveryAdmin, uint index) external onlyRole(DEFAULT_ADMIN_ROLE) {
1793         require(isApproved(), "SPIExt: Activity not approved"); 
1794         if(index>=0 && index< adminApprovers.length) {
1795             adminApprovers[index].approverAddress = _recoveryAdmin;
1796             _grantRole(DEFAULT_ADMIN_ROLE, _recoveryAdmin);
1797             resetApprovedInt();
1798         }
1799     }
1800 
1801     function getFeeRate() public view onlyRole(DEFAULT_ADMIN_ROLE) returns(uint256) {
1802         return _getFeeRate();
1803     }
1804 
1805     function setFeeRate(uint256 _feeRate) public onlyRole(DEFAULT_ADMIN_ROLE) {
1806         require(_feeRate != 0 && isApproved(), "SPIExt: Activity not approved"); 
1807         require(_feeRate <= 100, "SPIExt: Transfer Fee cannot exceed 100%");
1808         _setFeeRate(_feeRate);
1809     }
1810     
1811     function pauseTransferFee() public onlyRole(DEFAULT_ADMIN_ROLE) {
1812         _pauseTransferFee();    
1813     }
1814 
1815     function unpauseTransferFee() public onlyRole(DEFAULT_ADMIN_ROLE) {
1816         _unpauseTransferFee();    
1817     }
1818 
1819     function getTransactionFeePaused() public view returns(bool) {
1820         return _getTransferFeePaused();
1821     }
1822 
1823     /**
1824      * @dev Pauses all token transfers.
1825      *
1826      * See {ERC20Pausable} and {Pausable-_pause}.
1827      *
1828      * Requirements:
1829      *
1830      * - the caller must have the `PAUSER_ROLE`.
1831      */
1832     function pause() public virtual {
1833         require(hasRole(PAUSER_ROLE, _msgSender()), "SPIExt: must have pauser role to pause");
1834         _pause();
1835     }
1836 
1837     /**
1838      * @dev Unpauses all token transfers.
1839      *
1840      * See {ERC20Pausable} and {Pausable-_unpause}.
1841      *
1842      * Requirements:
1843      *
1844      * - the caller must have the `PAUSER_ROLE`.
1845      */
1846     function unpause() public virtual {
1847         require(hasRole(PAUSER_ROLE, _msgSender()), "SPIExt: must have pauser role to unpause");
1848         _unpause();
1849     }
1850 
1851     function _beforeTokenTransfer(
1852         address from,
1853         address to,
1854         uint256 amount
1855     ) internal virtual override(ERC20, ERC20Pausable) {
1856         super._beforeTokenTransfer(from, to, amount);
1857     }
1858 
1859     function excludeFromFee(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
1860         _excludeFromFee(account);
1861     }
1862     
1863     function includeInFee(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
1864         _includeInFee(account);
1865     }
1866 
1867     function revokeRole(bytes32 role, address account) external override onlyRole(DEFAULT_ADMIN_ROLE) {
1868         require(isApproved() || (adminApprovers[0].approverAddress != account && adminApprovers[1].approverAddress != account), "SPIExt: Role change for super admin not approved"); 
1869         super._revokeRole(role, account);
1870     }
1871 
1872     function transferFromFeePool(uint256 amount, address to) public onlyRole(DEFAULT_ADMIN_ROLE) returns(bool) {
1873         return _transferFromFeePool(amount, to);
1874     }
1875 
1876     function setAdminTimelock(uint256 timeLock) external onlyRole(DEFAULT_ADMIN_ROLE) {
1877         require(isApproved(), "SPIExt: Action is not approved");
1878         adminTimelock = timeLock;        
1879     }
1880  
1881     function setMintTimelock(uint256 timeLock) external onlyRole(DEFAULT_ADMIN_ROLE) {
1882         require(isApproved(), "SPIExt: Action is not approved");
1883         mintTimelock = timeLock;
1884     }
1885 
1886     function getAdminTimelock() external view onlyRole(DEFAULT_ADMIN_ROLE) returns(uint256) {
1887         return adminTimelock;
1888     }
1889  
1890     function getMintTimelock() external view onlyRole(DEFAULT_ADMIN_ROLE) returns(uint256) {
1891         return mintTimelock;
1892     }
1893 }