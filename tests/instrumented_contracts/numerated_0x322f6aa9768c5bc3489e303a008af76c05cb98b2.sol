1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.9;
4 
5 
6 // 
7 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
8 /**
9  * @dev External interface of AccessControl declared to support ERC165 detection.
10  */
11 interface IAccessControl {
12     /**
13      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
14      *
15      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
16      * {RoleAdminChanged} not being emitted signaling this.
17      *
18      * _Available since v3.1._
19      */
20     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
21 
22     /**
23      * @dev Emitted when `account` is granted `role`.
24      *
25      * `sender` is the account that originated the contract call, an admin role
26      * bearer except when using {AccessControl-_setupRole}.
27      */
28     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
29 
30     /**
31      * @dev Emitted when `account` is revoked `role`.
32      *
33      * `sender` is the account that originated the contract call:
34      *   - if using `revokeRole`, it is the admin role bearer
35      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
36      */
37     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
38 
39     /**
40      * @dev Returns `true` if `account` has been granted `role`.
41      */
42     function hasRole(bytes32 role, address account) external view returns (bool);
43 
44     /**
45      * @dev Returns the admin role that controls `role`. See {grantRole} and
46      * {revokeRole}.
47      *
48      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
49      */
50     function getRoleAdmin(bytes32 role) external view returns (bytes32);
51 
52     /**
53      * @dev Grants `role` to `account`.
54      *
55      * If `account` had not been already granted `role`, emits a {RoleGranted}
56      * event.
57      *
58      * Requirements:
59      *
60      * - the caller must have ``role``'s admin role.
61      */
62     function grantRole(bytes32 role, address account) external;
63 
64     /**
65      * @dev Revokes `role` from `account`.
66      *
67      * If `account` had been granted `role`, emits a {RoleRevoked} event.
68      *
69      * Requirements:
70      *
71      * - the caller must have ``role``'s admin role.
72      */
73     function revokeRole(bytes32 role, address account) external;
74 
75     /**
76      * @dev Revokes `role` from the calling account.
77      *
78      * Roles are often managed via {grantRole} and {revokeRole}: this function's
79      * purpose is to provide a mechanism for accounts to lose their privileges
80      * if they are compromised (such as when a trusted device is misplaced).
81      *
82      * If the calling account had been granted `role`, emits a {RoleRevoked}
83      * event.
84      *
85      * Requirements:
86      *
87      * - the caller must be `account`.
88      */
89     function renounceRole(bytes32 role, address account) external;
90 }
91 
92 // 
93 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
94 /**
95  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
96  */
97 interface IAccessControlEnumerable is IAccessControl {
98     /**
99      * @dev Returns one of the accounts that have `role`. `index` must be a
100      * value between 0 and {getRoleMemberCount}, non-inclusive.
101      *
102      * Role bearers are not sorted in any particular way, and their ordering may
103      * change at any point.
104      *
105      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
106      * you perform all queries on the same block. See the following
107      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
108      * for more information.
109      */
110     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
111 
112     /**
113      * @dev Returns the number of accounts that have `role`. Can be used
114      * together with {getRoleMember} to enumerate all bearers of a role.
115      */
116     function getRoleMemberCount(bytes32 role) external view returns (uint256);
117 }
118 
119 // 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 /**
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 // 
142 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
143 /**
144  * @dev String operations.
145  */
146 library Strings {
147     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
151      */
152     function toString(uint256 value) internal pure returns (string memory) {
153         // Inspired by OraclizeAPI's implementation - MIT licence
154         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
155 
156         if (value == 0) {
157             return "0";
158         }
159         uint256 temp = value;
160         uint256 digits;
161         while (temp != 0) {
162             digits++;
163             temp /= 10;
164         }
165         bytes memory buffer = new bytes(digits);
166         while (value != 0) {
167             digits -= 1;
168             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
169             value /= 10;
170         }
171         return string(buffer);
172     }
173 
174     /**
175      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
176      */
177     function toHexString(uint256 value) internal pure returns (string memory) {
178         if (value == 0) {
179             return "0x00";
180         }
181         uint256 temp = value;
182         uint256 length = 0;
183         while (temp != 0) {
184             length++;
185             temp >>= 8;
186         }
187         return toHexString(value, length);
188     }
189 
190     /**
191      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
192      */
193     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
194         bytes memory buffer = new bytes(2 * length + 2);
195         buffer[0] = "0";
196         buffer[1] = "x";
197         for (uint256 i = 2 * length + 1; i > 1; --i) {
198             buffer[i] = _HEX_SYMBOLS[value & 0xf];
199             value >>= 4;
200         }
201         require(value == 0, "Strings: hex length insufficient");
202         return string(buffer);
203     }
204 }
205 
206 // 
207 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
208 /**
209  * @dev Interface of the ERC165 standard, as defined in the
210  * https://eips.ethereum.org/EIPS/eip-165[EIP].
211  *
212  * Implementers can declare support of contract interfaces, which can then be
213  * queried by others ({ERC165Checker}).
214  *
215  * For an implementation, see {ERC165}.
216  */
217 interface IERC165 {
218     /**
219      * @dev Returns true if this contract implements the interface defined by
220      * `interfaceId`. See the corresponding
221      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
222      * to learn more about how these ids are created.
223      *
224      * This function call must use less than 30 000 gas.
225      */
226     function supportsInterface(bytes4 interfaceId) external view returns (bool);
227 }
228 
229 // 
230 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
231 /**
232  * @dev Implementation of the {IERC165} interface.
233  *
234  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
235  * for the additional interface id that will be supported. For example:
236  *
237  * ```solidity
238  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
239  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
240  * }
241  * ```
242  *
243  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
244  */
245 abstract contract ERC165 is IERC165 {
246     /**
247      * @dev See {IERC165-supportsInterface}.
248      */
249     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
250         return interfaceId == type(IERC165).interfaceId;
251     }
252 }
253 
254 // 
255 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
256 /**
257  * @dev Contract module that allows children to implement role-based access
258  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
259  * members except through off-chain means by accessing the contract event logs. Some
260  * applications may benefit from on-chain enumerability, for those cases see
261  * {AccessControlEnumerable}.
262  *
263  * Roles are referred to by their `bytes32` identifier. These should be exposed
264  * in the external API and be unique. The best way to achieve this is by
265  * using `public constant` hash digests:
266  *
267  * ```
268  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
269  * ```
270  *
271  * Roles can be used to represent a set of permissions. To restrict access to a
272  * function call, use {hasRole}:
273  *
274  * ```
275  * function foo() public {
276  *     require(hasRole(MY_ROLE, msg.sender));
277  *     ...
278  * }
279  * ```
280  *
281  * Roles can be granted and revoked dynamically via the {grantRole} and
282  * {revokeRole} functions. Each role has an associated admin role, and only
283  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
284  *
285  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
286  * that only accounts with this role will be able to grant or revoke other
287  * roles. More complex role relationships can be created by using
288  * {_setRoleAdmin}.
289  *
290  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
291  * grant and revoke this role. Extra precautions should be taken to secure
292  * accounts that have been granted it.
293  */
294 abstract contract AccessControl is Context, IAccessControl, ERC165 {
295     struct RoleData {
296         mapping(address => bool) members;
297         bytes32 adminRole;
298     }
299 
300     mapping(bytes32 => RoleData) private _roles;
301 
302     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
303 
304     /**
305      * @dev Modifier that checks that an account has a specific role. Reverts
306      * with a standardized message including the required role.
307      *
308      * The format of the revert reason is given by the following regular expression:
309      *
310      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
311      *
312      * _Available since v4.1._
313      */
314     modifier onlyRole(bytes32 role) {
315         _checkRole(role, _msgSender());
316         _;
317     }
318 
319     /**
320      * @dev See {IERC165-supportsInterface}.
321      */
322     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
323         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
324     }
325 
326     /**
327      * @dev Returns `true` if `account` has been granted `role`.
328      */
329     function hasRole(bytes32 role, address account) public view override returns (bool) {
330         return _roles[role].members[account];
331     }
332 
333     /**
334      * @dev Revert with a standard message if `account` is missing `role`.
335      *
336      * The format of the revert reason is given by the following regular expression:
337      *
338      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
339      */
340     function _checkRole(bytes32 role, address account) internal view {
341         if (!hasRole(role, account)) {
342             revert(
343                 string(
344                     abi.encodePacked(
345                         "AccessControl: account ",
346                         Strings.toHexString(uint160(account), 20),
347                         " is missing role ",
348                         Strings.toHexString(uint256(role), 32)
349                     )
350                 )
351             );
352         }
353     }
354 
355     /**
356      * @dev Returns the admin role that controls `role`. See {grantRole} and
357      * {revokeRole}.
358      *
359      * To change a role's admin, use {_setRoleAdmin}.
360      */
361     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
362         return _roles[role].adminRole;
363     }
364 
365     /**
366      * @dev Grants `role` to `account`.
367      *
368      * If `account` had not been already granted `role`, emits a {RoleGranted}
369      * event.
370      *
371      * Requirements:
372      *
373      * - the caller must have ``role``'s admin role.
374      */
375     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
376         _grantRole(role, account);
377     }
378 
379     /**
380      * @dev Revokes `role` from `account`.
381      *
382      * If `account` had been granted `role`, emits a {RoleRevoked} event.
383      *
384      * Requirements:
385      *
386      * - the caller must have ``role``'s admin role.
387      */
388     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
389         _revokeRole(role, account);
390     }
391 
392     /**
393      * @dev Revokes `role` from the calling account.
394      *
395      * Roles are often managed via {grantRole} and {revokeRole}: this function's
396      * purpose is to provide a mechanism for accounts to lose their privileges
397      * if they are compromised (such as when a trusted device is misplaced).
398      *
399      * If the calling account had been revoked `role`, emits a {RoleRevoked}
400      * event.
401      *
402      * Requirements:
403      *
404      * - the caller must be `account`.
405      */
406     function renounceRole(bytes32 role, address account) public virtual override {
407         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
408 
409         _revokeRole(role, account);
410     }
411 
412     /**
413      * @dev Grants `role` to `account`.
414      *
415      * If `account` had not been already granted `role`, emits a {RoleGranted}
416      * event. Note that unlike {grantRole}, this function doesn't perform any
417      * checks on the calling account.
418      *
419      * [WARNING]
420      * ====
421      * This function should only be called from the constructor when setting
422      * up the initial roles for the system.
423      *
424      * Using this function in any other way is effectively circumventing the admin
425      * system imposed by {AccessControl}.
426      * ====
427      *
428      * NOTE: This function is deprecated in favor of {_grantRole}.
429      */
430     function _setupRole(bytes32 role, address account) internal virtual {
431         _grantRole(role, account);
432     }
433 
434     /**
435      * @dev Sets `adminRole` as ``role``'s admin role.
436      *
437      * Emits a {RoleAdminChanged} event.
438      */
439     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
440         bytes32 previousAdminRole = getRoleAdmin(role);
441         _roles[role].adminRole = adminRole;
442         emit RoleAdminChanged(role, previousAdminRole, adminRole);
443     }
444 
445     /**
446      * @dev Grants `role` to `account`.
447      *
448      * Internal function without access restriction.
449      */
450     function _grantRole(bytes32 role, address account) internal virtual {
451         if (!hasRole(role, account)) {
452             _roles[role].members[account] = true;
453             emit RoleGranted(role, account, _msgSender());
454         }
455     }
456 
457     /**
458      * @dev Revokes `role` from `account`.
459      *
460      * Internal function without access restriction.
461      */
462     function _revokeRole(bytes32 role, address account) internal virtual {
463         if (hasRole(role, account)) {
464             _roles[role].members[account] = false;
465             emit RoleRevoked(role, account, _msgSender());
466         }
467     }
468 }
469 
470 // 
471 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
472 /**
473  * @dev Library for managing
474  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
475  * types.
476  *
477  * Sets have the following properties:
478  *
479  * - Elements are added, removed, and checked for existence in constant time
480  * (O(1)).
481  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
482  *
483  * ```
484  * contract Example {
485  *     // Add the library methods
486  *     using EnumerableSet for EnumerableSet.AddressSet;
487  *
488  *     // Declare a set state variable
489  *     EnumerableSet.AddressSet private mySet;
490  * }
491  * ```
492  *
493  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
494  * and `uint256` (`UintSet`) are supported.
495  */
496 library EnumerableSet {
497     // To implement this library for multiple types with as little code
498     // repetition as possible, we write it in terms of a generic Set type with
499     // bytes32 values.
500     // The Set implementation uses private functions, and user-facing
501     // implementations (such as AddressSet) are just wrappers around the
502     // underlying Set.
503     // This means that we can only create new EnumerableSets for types that fit
504     // in bytes32.
505 
506     struct Set {
507         // Storage of set values
508         bytes32[] _values;
509         // Position of the value in the `values` array, plus 1 because index 0
510         // means a value is not in the set.
511         mapping(bytes32 => uint256) _indexes;
512     }
513 
514     /**
515      * @dev Add a value to a set. O(1).
516      *
517      * Returns true if the value was added to the set, that is if it was not
518      * already present.
519      */
520     function _add(Set storage set, bytes32 value) private returns (bool) {
521         if (!_contains(set, value)) {
522             set._values.push(value);
523             // The value is stored at length-1, but we add 1 to all indexes
524             // and use 0 as a sentinel value
525             set._indexes[value] = set._values.length;
526             return true;
527         } else {
528             return false;
529         }
530     }
531 
532     /**
533      * @dev Removes a value from a set. O(1).
534      *
535      * Returns true if the value was removed from the set, that is if it was
536      * present.
537      */
538     function _remove(Set storage set, bytes32 value) private returns (bool) {
539         // We read and store the value's index to prevent multiple reads from the same storage slot
540         uint256 valueIndex = set._indexes[value];
541 
542         if (valueIndex != 0) {
543             // Equivalent to contains(set, value)
544             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
545             // the array, and then remove the last element (sometimes called as 'swap and pop').
546             // This modifies the order of the array, as noted in {at}.
547 
548             uint256 toDeleteIndex = valueIndex - 1;
549             uint256 lastIndex = set._values.length - 1;
550 
551             if (lastIndex != toDeleteIndex) {
552                 bytes32 lastvalue = set._values[lastIndex];
553 
554                 // Move the last value to the index where the value to delete is
555                 set._values[toDeleteIndex] = lastvalue;
556                 // Update the index for the moved value
557                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
558             }
559 
560             // Delete the slot where the moved value was stored
561             set._values.pop();
562 
563             // Delete the index for the deleted slot
564             delete set._indexes[value];
565 
566             return true;
567         } else {
568             return false;
569         }
570     }
571 
572     /**
573      * @dev Returns true if the value is in the set. O(1).
574      */
575     function _contains(Set storage set, bytes32 value) private view returns (bool) {
576         return set._indexes[value] != 0;
577     }
578 
579     /**
580      * @dev Returns the number of values on the set. O(1).
581      */
582     function _length(Set storage set) private view returns (uint256) {
583         return set._values.length;
584     }
585 
586     /**
587      * @dev Returns the value stored at position `index` in the set. O(1).
588      *
589      * Note that there are no guarantees on the ordering of values inside the
590      * array, and it may change when more values are added or removed.
591      *
592      * Requirements:
593      *
594      * - `index` must be strictly less than {length}.
595      */
596     function _at(Set storage set, uint256 index) private view returns (bytes32) {
597         return set._values[index];
598     }
599 
600     /**
601      * @dev Return the entire set in an array
602      *
603      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
604      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
605      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
606      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
607      */
608     function _values(Set storage set) private view returns (bytes32[] memory) {
609         return set._values;
610     }
611 
612     // Bytes32Set
613 
614     struct Bytes32Set {
615         Set _inner;
616     }
617 
618     /**
619      * @dev Add a value to a set. O(1).
620      *
621      * Returns true if the value was added to the set, that is if it was not
622      * already present.
623      */
624     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
625         return _add(set._inner, value);
626     }
627 
628     /**
629      * @dev Removes a value from a set. O(1).
630      *
631      * Returns true if the value was removed from the set, that is if it was
632      * present.
633      */
634     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
635         return _remove(set._inner, value);
636     }
637 
638     /**
639      * @dev Returns true if the value is in the set. O(1).
640      */
641     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
642         return _contains(set._inner, value);
643     }
644 
645     /**
646      * @dev Returns the number of values in the set. O(1).
647      */
648     function length(Bytes32Set storage set) internal view returns (uint256) {
649         return _length(set._inner);
650     }
651 
652     /**
653      * @dev Returns the value stored at position `index` in the set. O(1).
654      *
655      * Note that there are no guarantees on the ordering of values inside the
656      * array, and it may change when more values are added or removed.
657      *
658      * Requirements:
659      *
660      * - `index` must be strictly less than {length}.
661      */
662     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
663         return _at(set._inner, index);
664     }
665 
666     /**
667      * @dev Return the entire set in an array
668      *
669      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
670      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
671      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
672      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
673      */
674     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
675         return _values(set._inner);
676     }
677 
678     // AddressSet
679 
680     struct AddressSet {
681         Set _inner;
682     }
683 
684     /**
685      * @dev Add a value to a set. O(1).
686      *
687      * Returns true if the value was added to the set, that is if it was not
688      * already present.
689      */
690     function add(AddressSet storage set, address value) internal returns (bool) {
691         return _add(set._inner, bytes32(uint256(uint160(value))));
692     }
693 
694     /**
695      * @dev Removes a value from a set. O(1).
696      *
697      * Returns true if the value was removed from the set, that is if it was
698      * present.
699      */
700     function remove(AddressSet storage set, address value) internal returns (bool) {
701         return _remove(set._inner, bytes32(uint256(uint160(value))));
702     }
703 
704     /**
705      * @dev Returns true if the value is in the set. O(1).
706      */
707     function contains(AddressSet storage set, address value) internal view returns (bool) {
708         return _contains(set._inner, bytes32(uint256(uint160(value))));
709     }
710 
711     /**
712      * @dev Returns the number of values in the set. O(1).
713      */
714     function length(AddressSet storage set) internal view returns (uint256) {
715         return _length(set._inner);
716     }
717 
718     /**
719      * @dev Returns the value stored at position `index` in the set. O(1).
720      *
721      * Note that there are no guarantees on the ordering of values inside the
722      * array, and it may change when more values are added or removed.
723      *
724      * Requirements:
725      *
726      * - `index` must be strictly less than {length}.
727      */
728     function at(AddressSet storage set, uint256 index) internal view returns (address) {
729         return address(uint160(uint256(_at(set._inner, index))));
730     }
731 
732     /**
733      * @dev Return the entire set in an array
734      *
735      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
736      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
737      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
738      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
739      */
740     function values(AddressSet storage set) internal view returns (address[] memory) {
741         bytes32[] memory store = _values(set._inner);
742         address[] memory result;
743 
744         assembly {
745             result := store
746         }
747 
748         return result;
749     }
750 
751     // UintSet
752 
753     struct UintSet {
754         Set _inner;
755     }
756 
757     /**
758      * @dev Add a value to a set. O(1).
759      *
760      * Returns true if the value was added to the set, that is if it was not
761      * already present.
762      */
763     function add(UintSet storage set, uint256 value) internal returns (bool) {
764         return _add(set._inner, bytes32(value));
765     }
766 
767     /**
768      * @dev Removes a value from a set. O(1).
769      *
770      * Returns true if the value was removed from the set, that is if it was
771      * present.
772      */
773     function remove(UintSet storage set, uint256 value) internal returns (bool) {
774         return _remove(set._inner, bytes32(value));
775     }
776 
777     /**
778      * @dev Returns true if the value is in the set. O(1).
779      */
780     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
781         return _contains(set._inner, bytes32(value));
782     }
783 
784     /**
785      * @dev Returns the number of values on the set. O(1).
786      */
787     function length(UintSet storage set) internal view returns (uint256) {
788         return _length(set._inner);
789     }
790 
791     /**
792      * @dev Returns the value stored at position `index` in the set. O(1).
793      *
794      * Note that there are no guarantees on the ordering of values inside the
795      * array, and it may change when more values are added or removed.
796      *
797      * Requirements:
798      *
799      * - `index` must be strictly less than {length}.
800      */
801     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
802         return uint256(_at(set._inner, index));
803     }
804 
805     /**
806      * @dev Return the entire set in an array
807      *
808      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
809      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
810      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
811      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
812      */
813     function values(UintSet storage set) internal view returns (uint256[] memory) {
814         bytes32[] memory store = _values(set._inner);
815         uint256[] memory result;
816 
817         assembly {
818             result := store
819         }
820 
821         return result;
822     }
823 }
824 
825 // 
826 // OpenZeppelin Contracts v4.4.1 (access/AccessControlEnumerable.sol)
827 /**
828  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
829  */
830 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
831     using EnumerableSet for EnumerableSet.AddressSet;
832 
833     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
834 
835     /**
836      * @dev See {IERC165-supportsInterface}.
837      */
838     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
839         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
840     }
841 
842     /**
843      * @dev Returns one of the accounts that have `role`. `index` must be a
844      * value between 0 and {getRoleMemberCount}, non-inclusive.
845      *
846      * Role bearers are not sorted in any particular way, and their ordering may
847      * change at any point.
848      *
849      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
850      * you perform all queries on the same block. See the following
851      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
852      * for more information.
853      */
854     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
855         return _roleMembers[role].at(index);
856     }
857 
858     /**
859      * @dev Returns the number of accounts that have `role`. Can be used
860      * together with {getRoleMember} to enumerate all bearers of a role.
861      */
862     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
863         return _roleMembers[role].length();
864     }
865 
866     /**
867      * @dev Overload {_grantRole} to track enumerable memberships
868      */
869     function _grantRole(bytes32 role, address account) internal virtual override {
870         super._grantRole(role, account);
871         _roleMembers[role].add(account);
872     }
873 
874     /**
875      * @dev Overload {_revokeRole} to track enumerable memberships
876      */
877     function _revokeRole(bytes32 role, address account) internal virtual override {
878         super._revokeRole(role, account);
879         _roleMembers[role].remove(account);
880     }
881 }
882 
883 // 
884 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
885 /**
886  * @dev Contract module which provides a basic access control mechanism, where
887  * there is an account (an owner) that can be granted exclusive access to
888  * specific functions.
889  *
890  * By default, the owner account will be the one that deploys the contract. This
891  * can later be changed with {transferOwnership}.
892  *
893  * This module is used through inheritance. It will make available the modifier
894  * `onlyOwner`, which can be applied to your functions to restrict their use to
895  * the owner.
896  */
897 abstract contract Ownable is Context {
898     address private _owner;
899 
900     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
901 
902     /**
903      * @dev Initializes the contract setting the deployer as the initial owner.
904      */
905     constructor() {
906         _transferOwnership(_msgSender());
907     }
908 
909     /**
910      * @dev Returns the address of the current owner.
911      */
912     function owner() public view virtual returns (address) {
913         return _owner;
914     }
915 
916     /**
917      * @dev Throws if called by any account other than the owner.
918      */
919     modifier onlyOwner() {
920         require(owner() == _msgSender(), "Ownable: caller is not the owner");
921         _;
922     }
923 
924     /**
925      * @dev Leaves the contract without owner. It will not be possible to call
926      * `onlyOwner` functions anymore. Can only be called by the current owner.
927      *
928      * NOTE: Renouncing ownership will leave the contract without an owner,
929      * thereby removing any functionality that is only available to the owner.
930      */
931     function renounceOwnership() public virtual onlyOwner {
932         _transferOwnership(address(0));
933     }
934 
935     /**
936      * @dev Transfers ownership of the contract to a new account (`newOwner`).
937      * Can only be called by the current owner.
938      */
939     function transferOwnership(address newOwner) public virtual onlyOwner {
940         require(newOwner != address(0), "Ownable: new owner is the zero address");
941         _transferOwnership(newOwner);
942     }
943 
944     /**
945      * @dev Transfers ownership of the contract to a new account (`newOwner`).
946      * Internal function without access restriction.
947      */
948     function _transferOwnership(address newOwner) internal virtual {
949         address oldOwner = _owner;
950         _owner = newOwner;
951         emit OwnershipTransferred(oldOwner, newOwner);
952     }
953 }
954 
955 // 
956 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
957 /**
958  * @title Counters
959  * @author Matt Condon (@shrugs)
960  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
961  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
962  *
963  * Include with `using Counters for Counters.Counter;`
964  */
965 library Counters {
966     struct Counter {
967         // This variable should never be directly accessed by users of the library: interactions must be restricted to
968         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
969         // this feature: see https://github.com/ethereum/solidity/issues/4637
970         uint256 _value; // default: 0
971     }
972 
973     function current(Counter storage counter) internal view returns (uint256) {
974         return counter._value;
975     }
976 
977     function increment(Counter storage counter) internal {
978         unchecked {
979             counter._value += 1;
980         }
981     }
982 
983     function decrement(Counter storage counter) internal {
984         uint256 value = counter._value;
985         require(value > 0, "Counter: decrement overflow");
986         unchecked {
987             counter._value = value - 1;
988         }
989     }
990 
991     function reset(Counter storage counter) internal {
992         counter._value = 0;
993     }
994 }
995 
996 // 
997 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
998 /**
999  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1000  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1001  *
1002  * _Available since v3.1._
1003  */
1004 interface IERC1155 is IERC165 {
1005     /**
1006      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1007      */
1008     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1009 
1010     /**
1011      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1012      * transfers.
1013      */
1014     event TransferBatch(
1015         address indexed operator,
1016         address indexed from,
1017         address indexed to,
1018         uint256[] ids,
1019         uint256[] values
1020     );
1021 
1022     /**
1023      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1024      * `approved`.
1025      */
1026     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1027 
1028     /**
1029      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1030      *
1031      * If an {URI} event was emitted for `id`, the standard
1032      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1033      * returned by {IERC1155MetadataURI-uri}.
1034      */
1035     event URI(string value, uint256 indexed id);
1036 
1037     /**
1038      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1039      *
1040      * Requirements:
1041      *
1042      * - `account` cannot be the zero address.
1043      */
1044     function balanceOf(address account, uint256 id) external view returns (uint256);
1045 
1046     /**
1047      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1048      *
1049      * Requirements:
1050      *
1051      * - `accounts` and `ids` must have the same length.
1052      */
1053     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1054         external
1055         view
1056         returns (uint256[] memory);
1057 
1058     /**
1059      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1060      *
1061      * Emits an {ApprovalForAll} event.
1062      *
1063      * Requirements:
1064      *
1065      * - `operator` cannot be the caller.
1066      */
1067     function setApprovalForAll(address operator, bool approved) external;
1068 
1069     /**
1070      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1071      *
1072      * See {setApprovalForAll}.
1073      */
1074     function isApprovedForAll(address account, address operator) external view returns (bool);
1075 
1076     /**
1077      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1078      *
1079      * Emits a {TransferSingle} event.
1080      *
1081      * Requirements:
1082      *
1083      * - `to` cannot be the zero address.
1084      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1085      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1086      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1087      * acceptance magic value.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 id,
1093         uint256 amount,
1094         bytes calldata data
1095     ) external;
1096 
1097     /**
1098      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1099      *
1100      * Emits a {TransferBatch} event.
1101      *
1102      * Requirements:
1103      *
1104      * - `ids` and `amounts` must have the same length.
1105      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1106      * acceptance magic value.
1107      */
1108     function safeBatchTransferFrom(
1109         address from,
1110         address to,
1111         uint256[] calldata ids,
1112         uint256[] calldata amounts,
1113         bytes calldata data
1114     ) external;
1115 }
1116 
1117 // 
1118 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
1119 /**
1120  * @dev _Available since v3.1._
1121  */
1122 interface IERC1155Receiver is IERC165 {
1123     /**
1124         @dev Handles the receipt of a single ERC1155 token type. This function is
1125         called at the end of a `safeTransferFrom` after the balance has been updated.
1126         To accept the transfer, this must return
1127         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1128         (i.e. 0xf23a6e61, or its own function selector).
1129         @param operator The address which initiated the transfer (i.e. msg.sender)
1130         @param from The address which previously owned the token
1131         @param id The ID of the token being transferred
1132         @param value The amount of tokens being transferred
1133         @param data Additional data with no specified format
1134         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1135     */
1136     function onERC1155Received(
1137         address operator,
1138         address from,
1139         uint256 id,
1140         uint256 value,
1141         bytes calldata data
1142     ) external returns (bytes4);
1143 
1144     /**
1145         @dev Handles the receipt of a multiple ERC1155 token types. This function
1146         is called at the end of a `safeBatchTransferFrom` after the balances have
1147         been updated. To accept the transfer(s), this must return
1148         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1149         (i.e. 0xbc197c81, or its own function selector).
1150         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1151         @param from The address which previously owned the token
1152         @param ids An array containing ids of each token being transferred (order and length must match values array)
1153         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1154         @param data Additional data with no specified format
1155         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1156     */
1157     function onERC1155BatchReceived(
1158         address operator,
1159         address from,
1160         uint256[] calldata ids,
1161         uint256[] calldata values,
1162         bytes calldata data
1163     ) external returns (bytes4);
1164 }
1165 
1166 // 
1167 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1168 /**
1169  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1170  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1171  *
1172  * _Available since v3.1._
1173  */
1174 interface IERC1155MetadataURI is IERC1155 {
1175     /**
1176      * @dev Returns the URI for token type `id`.
1177      *
1178      * If the `\{id\}` substring is present in the URI, it must be replaced by
1179      * clients with the actual token type ID.
1180      */
1181     function uri(uint256 id) external view returns (string memory);
1182 }
1183 
1184 // 
1185 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
1186 /**
1187  * @dev Collection of functions related to the address type
1188  */
1189 library Address {
1190     /**
1191      * @dev Returns true if `account` is a contract.
1192      *
1193      * [IMPORTANT]
1194      * ====
1195      * It is unsafe to assume that an address for which this function returns
1196      * false is an externally-owned account (EOA) and not a contract.
1197      *
1198      * Among others, `isContract` will return false for the following
1199      * types of addresses:
1200      *
1201      *  - an externally-owned account
1202      *  - a contract in construction
1203      *  - an address where a contract will be created
1204      *  - an address where a contract lived, but was destroyed
1205      * ====
1206      */
1207     function isContract(address account) internal view returns (bool) {
1208         // This method relies on extcodesize, which returns 0 for contracts in
1209         // construction, since the code is only stored at the end of the
1210         // constructor execution.
1211 
1212         uint256 size;
1213         assembly {
1214             size := extcodesize(account)
1215         }
1216         return size > 0;
1217     }
1218 
1219     /**
1220      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1221      * `recipient`, forwarding all available gas and reverting on errors.
1222      *
1223      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1224      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1225      * imposed by `transfer`, making them unable to receive funds via
1226      * `transfer`. {sendValue} removes this limitation.
1227      *
1228      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1229      *
1230      * IMPORTANT: because control is transferred to `recipient`, care must be
1231      * taken to not create reentrancy vulnerabilities. Consider using
1232      * {ReentrancyGuard} or the
1233      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1234      */
1235     function sendValue(address payable recipient, uint256 amount) internal {
1236         require(address(this).balance >= amount, "Address: insufficient balance");
1237 
1238         (bool success, ) = recipient.call{value: amount}("");
1239         require(success, "Address: unable to send value, recipient may have reverted");
1240     }
1241 
1242     /**
1243      * @dev Performs a Solidity function call using a low level `call`. A
1244      * plain `call` is an unsafe replacement for a function call: use this
1245      * function instead.
1246      *
1247      * If `target` reverts with a revert reason, it is bubbled up by this
1248      * function (like regular Solidity function calls).
1249      *
1250      * Returns the raw returned data. To convert to the expected return value,
1251      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1252      *
1253      * Requirements:
1254      *
1255      * - `target` must be a contract.
1256      * - calling `target` with `data` must not revert.
1257      *
1258      * _Available since v3.1._
1259      */
1260     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1261         return functionCall(target, data, "Address: low-level call failed");
1262     }
1263 
1264     /**
1265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1266      * `errorMessage` as a fallback revert reason when `target` reverts.
1267      *
1268      * _Available since v3.1._
1269      */
1270     function functionCall(
1271         address target,
1272         bytes memory data,
1273         string memory errorMessage
1274     ) internal returns (bytes memory) {
1275         return functionCallWithValue(target, data, 0, errorMessage);
1276     }
1277 
1278     /**
1279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1280      * but also transferring `value` wei to `target`.
1281      *
1282      * Requirements:
1283      *
1284      * - the calling contract must have an ETH balance of at least `value`.
1285      * - the called Solidity function must be `payable`.
1286      *
1287      * _Available since v3.1._
1288      */
1289     function functionCallWithValue(
1290         address target,
1291         bytes memory data,
1292         uint256 value
1293     ) internal returns (bytes memory) {
1294         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1295     }
1296 
1297     /**
1298      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1299      * with `errorMessage` as a fallback revert reason when `target` reverts.
1300      *
1301      * _Available since v3.1._
1302      */
1303     function functionCallWithValue(
1304         address target,
1305         bytes memory data,
1306         uint256 value,
1307         string memory errorMessage
1308     ) internal returns (bytes memory) {
1309         require(address(this).balance >= value, "Address: insufficient balance for call");
1310         require(isContract(target), "Address: call to non-contract");
1311 
1312         (bool success, bytes memory returndata) = target.call{value: value}(data);
1313         return verifyCallResult(success, returndata, errorMessage);
1314     }
1315 
1316     /**
1317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1318      * but performing a static call.
1319      *
1320      * _Available since v3.3._
1321      */
1322     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1323         return functionStaticCall(target, data, "Address: low-level static call failed");
1324     }
1325 
1326     /**
1327      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1328      * but performing a static call.
1329      *
1330      * _Available since v3.3._
1331      */
1332     function functionStaticCall(
1333         address target,
1334         bytes memory data,
1335         string memory errorMessage
1336     ) internal view returns (bytes memory) {
1337         require(isContract(target), "Address: static call to non-contract");
1338 
1339         (bool success, bytes memory returndata) = target.staticcall(data);
1340         return verifyCallResult(success, returndata, errorMessage);
1341     }
1342 
1343     /**
1344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1345      * but performing a delegate call.
1346      *
1347      * _Available since v3.4._
1348      */
1349     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1350         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1351     }
1352 
1353     /**
1354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1355      * but performing a delegate call.
1356      *
1357      * _Available since v3.4._
1358      */
1359     function functionDelegateCall(
1360         address target,
1361         bytes memory data,
1362         string memory errorMessage
1363     ) internal returns (bytes memory) {
1364         require(isContract(target), "Address: delegate call to non-contract");
1365 
1366         (bool success, bytes memory returndata) = target.delegatecall(data);
1367         return verifyCallResult(success, returndata, errorMessage);
1368     }
1369 
1370     /**
1371      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1372      * revert reason using the provided one.
1373      *
1374      * _Available since v4.3._
1375      */
1376     function verifyCallResult(
1377         bool success,
1378         bytes memory returndata,
1379         string memory errorMessage
1380     ) internal pure returns (bytes memory) {
1381         if (success) {
1382             return returndata;
1383         } else {
1384             // Look for revert reason and bubble it up if present
1385             if (returndata.length > 0) {
1386                 // The easiest way to bubble the revert reason is using memory via assembly
1387 
1388                 assembly {
1389                     let returndata_size := mload(returndata)
1390                     revert(add(32, returndata), returndata_size)
1391                 }
1392             } else {
1393                 revert(errorMessage);
1394             }
1395         }
1396     }
1397 }
1398 
1399 // 
1400 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
1401 /**
1402  * @dev Implementation of the basic standard multi-token.
1403  * See https://eips.ethereum.org/EIPS/eip-1155
1404  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1405  *
1406  * _Available since v3.1._
1407  */
1408 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1409     using Address for address;
1410 
1411     // Mapping from token ID to account balances
1412     mapping(uint256 => mapping(address => uint256)) private _balances;
1413 
1414     // Mapping from account to operator approvals
1415     mapping(address => mapping(address => bool)) private _operatorApprovals;
1416 
1417     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1418     string private _uri;
1419 
1420     /**
1421      * @dev See {_setURI}.
1422      */
1423     constructor(string memory uri_) {
1424         _setURI(uri_);
1425     }
1426 
1427     /**
1428      * @dev See {IERC165-supportsInterface}.
1429      */
1430     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1431         return
1432             interfaceId == type(IERC1155).interfaceId ||
1433             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1434             super.supportsInterface(interfaceId);
1435     }
1436 
1437     /**
1438      * @dev See {IERC1155MetadataURI-uri}.
1439      *
1440      * This implementation returns the same URI for *all* token types. It relies
1441      * on the token type ID substitution mechanism
1442      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1443      *
1444      * Clients calling this function must replace the `\{id\}` substring with the
1445      * actual token type ID.
1446      */
1447     function uri(uint256) public view virtual override returns (string memory) {
1448         return _uri;
1449     }
1450 
1451     /**
1452      * @dev See {IERC1155-balanceOf}.
1453      *
1454      * Requirements:
1455      *
1456      * - `account` cannot be the zero address.
1457      */
1458     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1459         require(account != address(0), "ERC1155: balance query for the zero address");
1460         return _balances[id][account];
1461     }
1462 
1463     /**
1464      * @dev See {IERC1155-balanceOfBatch}.
1465      *
1466      * Requirements:
1467      *
1468      * - `accounts` and `ids` must have the same length.
1469      */
1470     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1471         public
1472         view
1473         virtual
1474         override
1475         returns (uint256[] memory)
1476     {
1477         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1478 
1479         uint256[] memory batchBalances = new uint256[](accounts.length);
1480 
1481         for (uint256 i = 0; i < accounts.length; ++i) {
1482             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1483         }
1484 
1485         return batchBalances;
1486     }
1487 
1488     /**
1489      * @dev See {IERC1155-setApprovalForAll}.
1490      */
1491     function setApprovalForAll(address operator, bool approved) public virtual override {
1492         _setApprovalForAll(_msgSender(), operator, approved);
1493     }
1494 
1495     /**
1496      * @dev See {IERC1155-isApprovedForAll}.
1497      */
1498     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1499         return _operatorApprovals[account][operator];
1500     }
1501 
1502     /**
1503      * @dev See {IERC1155-safeTransferFrom}.
1504      */
1505     function safeTransferFrom(
1506         address from,
1507         address to,
1508         uint256 id,
1509         uint256 amount,
1510         bytes memory data
1511     ) public virtual override {
1512         require(
1513             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1514             "ERC1155: caller is not owner nor approved"
1515         );
1516         _safeTransferFrom(from, to, id, amount, data);
1517     }
1518 
1519     /**
1520      * @dev See {IERC1155-safeBatchTransferFrom}.
1521      */
1522     function safeBatchTransferFrom(
1523         address from,
1524         address to,
1525         uint256[] memory ids,
1526         uint256[] memory amounts,
1527         bytes memory data
1528     ) public virtual override {
1529         require(
1530             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1531             "ERC1155: transfer caller is not owner nor approved"
1532         );
1533         _safeBatchTransferFrom(from, to, ids, amounts, data);
1534     }
1535 
1536     /**
1537      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1538      *
1539      * Emits a {TransferSingle} event.
1540      *
1541      * Requirements:
1542      *
1543      * - `to` cannot be the zero address.
1544      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1545      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1546      * acceptance magic value.
1547      */
1548     function _safeTransferFrom(
1549         address from,
1550         address to,
1551         uint256 id,
1552         uint256 amount,
1553         bytes memory data
1554     ) internal virtual {
1555         require(to != address(0), "ERC1155: transfer to the zero address");
1556 
1557         address operator = _msgSender();
1558 
1559         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1560 
1561         uint256 fromBalance = _balances[id][from];
1562         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1563         unchecked {
1564             _balances[id][from] = fromBalance - amount;
1565         }
1566         _balances[id][to] += amount;
1567 
1568         emit TransferSingle(operator, from, to, id, amount);
1569 
1570         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1571     }
1572 
1573     /**
1574      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1575      *
1576      * Emits a {TransferBatch} event.
1577      *
1578      * Requirements:
1579      *
1580      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1581      * acceptance magic value.
1582      */
1583     function _safeBatchTransferFrom(
1584         address from,
1585         address to,
1586         uint256[] memory ids,
1587         uint256[] memory amounts,
1588         bytes memory data
1589     ) internal virtual {
1590         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1591         require(to != address(0), "ERC1155: transfer to the zero address");
1592 
1593         address operator = _msgSender();
1594 
1595         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1596 
1597         for (uint256 i = 0; i < ids.length; ++i) {
1598             uint256 id = ids[i];
1599             uint256 amount = amounts[i];
1600 
1601             uint256 fromBalance = _balances[id][from];
1602             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1603             unchecked {
1604                 _balances[id][from] = fromBalance - amount;
1605             }
1606             _balances[id][to] += amount;
1607         }
1608 
1609         emit TransferBatch(operator, from, to, ids, amounts);
1610 
1611         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1612     }
1613 
1614     /**
1615      * @dev Sets a new URI for all token types, by relying on the token type ID
1616      * substitution mechanism
1617      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1618      *
1619      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1620      * URI or any of the amounts in the JSON file at said URI will be replaced by
1621      * clients with the token type ID.
1622      *
1623      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1624      * interpreted by clients as
1625      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1626      * for token type ID 0x4cce0.
1627      *
1628      * See {uri}.
1629      *
1630      * Because these URIs cannot be meaningfully represented by the {URI} event,
1631      * this function emits no events.
1632      */
1633     function _setURI(string memory newuri) internal virtual {
1634         _uri = newuri;
1635     }
1636 
1637     /**
1638      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1639      *
1640      * Emits a {TransferSingle} event.
1641      *
1642      * Requirements:
1643      *
1644      * - `to` cannot be the zero address.
1645      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1646      * acceptance magic value.
1647      */
1648     function _mint(
1649         address to,
1650         uint256 id,
1651         uint256 amount,
1652         bytes memory data
1653     ) internal virtual {
1654         require(to != address(0), "ERC1155: mint to the zero address");
1655 
1656         address operator = _msgSender();
1657 
1658         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1659 
1660         _balances[id][to] += amount;
1661         emit TransferSingle(operator, address(0), to, id, amount);
1662 
1663         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1664     }
1665 
1666     /**
1667      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1668      *
1669      * Requirements:
1670      *
1671      * - `ids` and `amounts` must have the same length.
1672      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1673      * acceptance magic value.
1674      */
1675     function _mintBatch(
1676         address to,
1677         uint256[] memory ids,
1678         uint256[] memory amounts,
1679         bytes memory data
1680     ) internal virtual {
1681         require(to != address(0), "ERC1155: mint to the zero address");
1682         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1683 
1684         address operator = _msgSender();
1685 
1686         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1687 
1688         for (uint256 i = 0; i < ids.length; i++) {
1689             _balances[ids[i]][to] += amounts[i];
1690         }
1691 
1692         emit TransferBatch(operator, address(0), to, ids, amounts);
1693 
1694         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1695     }
1696 
1697     /**
1698      * @dev Destroys `amount` tokens of token type `id` from `from`
1699      *
1700      * Requirements:
1701      *
1702      * - `from` cannot be the zero address.
1703      * - `from` must have at least `amount` tokens of token type `id`.
1704      */
1705     function _burn(
1706         address from,
1707         uint256 id,
1708         uint256 amount
1709     ) internal virtual {
1710         require(from != address(0), "ERC1155: burn from the zero address");
1711 
1712         address operator = _msgSender();
1713 
1714         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1715 
1716         uint256 fromBalance = _balances[id][from];
1717         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1718         unchecked {
1719             _balances[id][from] = fromBalance - amount;
1720         }
1721 
1722         emit TransferSingle(operator, from, address(0), id, amount);
1723     }
1724 
1725     /**
1726      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1727      *
1728      * Requirements:
1729      *
1730      * - `ids` and `amounts` must have the same length.
1731      */
1732     function _burnBatch(
1733         address from,
1734         uint256[] memory ids,
1735         uint256[] memory amounts
1736     ) internal virtual {
1737         require(from != address(0), "ERC1155: burn from the zero address");
1738         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1739 
1740         address operator = _msgSender();
1741 
1742         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1743 
1744         for (uint256 i = 0; i < ids.length; i++) {
1745             uint256 id = ids[i];
1746             uint256 amount = amounts[i];
1747 
1748             uint256 fromBalance = _balances[id][from];
1749             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1750             unchecked {
1751                 _balances[id][from] = fromBalance - amount;
1752             }
1753         }
1754 
1755         emit TransferBatch(operator, from, address(0), ids, amounts);
1756     }
1757 
1758     /**
1759      * @dev Approve `operator` to operate on all of `owner` tokens
1760      *
1761      * Emits a {ApprovalForAll} event.
1762      */
1763     function _setApprovalForAll(
1764         address owner,
1765         address operator,
1766         bool approved
1767     ) internal virtual {
1768         require(owner != operator, "ERC1155: setting approval status for self");
1769         _operatorApprovals[owner][operator] = approved;
1770         emit ApprovalForAll(owner, operator, approved);
1771     }
1772 
1773     /**
1774      * @dev Hook that is called before any token transfer. This includes minting
1775      * and burning, as well as batched variants.
1776      *
1777      * The same hook is called on both single and batched variants. For single
1778      * transfers, the length of the `id` and `amount` arrays will be 1.
1779      *
1780      * Calling conditions (for each `id` and `amount` pair):
1781      *
1782      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1783      * of token type `id` will be  transferred to `to`.
1784      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1785      * for `to`.
1786      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1787      * will be burned.
1788      * - `from` and `to` are never both zero.
1789      * - `ids` and `amounts` have the same, non-zero length.
1790      *
1791      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1792      */
1793     function _beforeTokenTransfer(
1794         address operator,
1795         address from,
1796         address to,
1797         uint256[] memory ids,
1798         uint256[] memory amounts,
1799         bytes memory data
1800     ) internal virtual {}
1801 
1802     function _doSafeTransferAcceptanceCheck(
1803         address operator,
1804         address from,
1805         address to,
1806         uint256 id,
1807         uint256 amount,
1808         bytes memory data
1809     ) private {
1810         if (to.isContract()) {
1811             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1812                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1813                     revert("ERC1155: ERC1155Receiver rejected tokens");
1814                 }
1815             } catch Error(string memory reason) {
1816                 revert(reason);
1817             } catch {
1818                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1819             }
1820         }
1821     }
1822 
1823     function _doSafeBatchTransferAcceptanceCheck(
1824         address operator,
1825         address from,
1826         address to,
1827         uint256[] memory ids,
1828         uint256[] memory amounts,
1829         bytes memory data
1830     ) private {
1831         if (to.isContract()) {
1832             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1833                 bytes4 response
1834             ) {
1835                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1836                     revert("ERC1155: ERC1155Receiver rejected tokens");
1837                 }
1838             } catch Error(string memory reason) {
1839                 revert(reason);
1840             } catch {
1841                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1842             }
1843         }
1844     }
1845 
1846     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1847         uint256[] memory array = new uint256[](1);
1848         array[0] = element;
1849 
1850         return array;
1851     }
1852 }
1853 
1854 // 
1855 /**
1856  * Storefront NFT collection that can be expanded to hold multiple supplies of 
1857  * new utility NFTs for the 6Sigma community.
1858  * New items may be minted after pushing new IPFS dumps with additional assets.
1859  * 
1860  * "Admins" can mint new tokens and update the Metadata URI.
1861  * "Owner" can update the Treasury wallet.
1862  */
1863 contract SixSigma is ERC1155, Ownable, AccessControlEnumerable {
1864     
1865     // Where the NFT's will be minted to and sold from
1866     address public treasuryAddress;
1867 
1868     string public name;
1869     string public symbol;
1870     string public baseMetadataUri;
1871 
1872     constructor(string memory _baseMetadataUri, address _treasuryAddress) 
1873         ERC1155("") 
1874     {
1875         name = "6Sigma";
1876         symbol = "SSIG";
1877         baseMetadataUri = _baseMetadataUri;
1878         treasuryAddress= _treasuryAddress;
1879 
1880         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1881         _setupRole(DEFAULT_ADMIN_ROLE, _treasuryAddress);
1882         
1883         _mint(treasuryAddress, 1, 888, ""); // AccessPass
1884     }
1885 
1886 
1887     /************ Read-only FUNCTIONS ************/
1888 
1889     // Override ERC1155 standard so it can properly be seen on OpenSea
1890     function uri(uint256 _tokenId) public view virtual override returns (string memory) {
1891         return string(
1892           abi.encodePacked(
1893             baseMetadataUri,
1894             Strings.toString(_tokenId)
1895           )
1896         );
1897     }
1898 
1899 
1900     /************ ADMIN FUNCTIONS ************/
1901 
1902     function mintToTreasury(uint256 id, uint256 amount) 
1903         external 
1904         onlyRole(DEFAULT_ADMIN_ROLE) 
1905     {
1906         _mint(treasuryAddress, id, amount, "");
1907     }
1908 
1909     // Likely will never need `data`, just use `""`
1910     function mintBatch(
1911         address to,
1912         uint256[] memory ids,
1913         uint256[] memory amounts,
1914         bytes memory data
1915     ) 
1916         external 
1917         onlyRole(DEFAULT_ADMIN_ROLE) 
1918     {
1919         _mintBatch(to, ids, amounts, data);
1920     }
1921 
1922     function setURI(string memory _newuri) 
1923         external 
1924         onlyRole(DEFAULT_ADMIN_ROLE) 
1925     {
1926         baseMetadataUri = _newuri;
1927     }
1928 
1929 
1930     /************ OWNER FUNCTIONS ************/
1931 
1932     // NOTE: you will also need to manually transfer all existing ERC1155's to the new treasury address. 
1933     function setTreasuryAddress(address _treasuryAddress) 
1934         external 
1935         onlyOwner 
1936     {
1937         treasuryAddress = _treasuryAddress;
1938     }
1939 
1940 
1941     /************ BOILERPLATE ************/
1942 
1943     /**
1944      * @dev See {IERC165-supportsInterface}.
1945      */
1946     function supportsInterface(bytes4 interfaceId)
1947         public
1948         view
1949         virtual
1950         override(AccessControlEnumerable, ERC1155)
1951         returns (bool)
1952     {
1953         return super.supportsInterface(interfaceId);
1954     }
1955 
1956 }