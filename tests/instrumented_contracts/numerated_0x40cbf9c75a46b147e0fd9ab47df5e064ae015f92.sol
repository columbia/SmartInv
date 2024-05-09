1 pragma solidity ^0.8.0;
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
5 /**
6  * @dev External interface of AccessControl declared to support ERC165 detection.
7  */
8 interface IAccessControl {
9     /**
10      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
11      *
12      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
13      * {RoleAdminChanged} not being emitted signaling this.
14      *
15      * _Available since v3.1._
16      */
17     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
18 
19     /**
20      * @dev Emitted when `account` is granted `role`.
21      *
22      * `sender` is the account that originated the contract call, an admin role
23      * bearer except when using {AccessControl-_setupRole}.
24      */
25     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
26 
27     /**
28      * @dev Emitted when `account` is revoked `role`.
29      *
30      * `sender` is the account that originated the contract call:
31      *   - if using `revokeRole`, it is the admin role bearer
32      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
33      */
34     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
35 
36     /**
37      * @dev Returns `true` if `account` has been granted `role`.
38      */
39     function hasRole(bytes32 role, address account) external view returns (bool);
40 
41     /**
42      * @dev Returns the admin role that controls `role`. See {grantRole} and
43      * {revokeRole}.
44      *
45      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
46      */
47     function getRoleAdmin(bytes32 role) external view returns (bytes32);
48 
49     /**
50      * @dev Grants `role` to `account`.
51      *
52      * If `account` had not been already granted `role`, emits a {RoleGranted}
53      * event.
54      *
55      * Requirements:
56      *
57      * - the caller must have ``role``'s admin role.
58      */
59     function grantRole(bytes32 role, address account) external;
60 
61     /**
62      * @dev Revokes `role` from `account`.
63      *
64      * If `account` had been granted `role`, emits a {RoleRevoked} event.
65      *
66      * Requirements:
67      *
68      * - the caller must have ``role``'s admin role.
69      */
70     function revokeRole(bytes32 role, address account) external;
71 
72     /**
73      * @dev Revokes `role` from the calling account.
74      *
75      * Roles are often managed via {grantRole} and {revokeRole}: this function's
76      * purpose is to provide a mechanism for accounts to lose their privileges
77      * if they are compromised (such as when a trusted device is misplaced).
78      *
79      * If the calling account had been granted `role`, emits a {RoleRevoked}
80      * event.
81      *
82      * Requirements:
83      *
84      * - the caller must be `account`.
85      */
86     function renounceRole(bytes32 role, address account) external;
87 }
88 
89 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
90 /**
91  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
92  */
93 interface IAccessControlEnumerable is IAccessControl {
94     /**
95      * @dev Returns one of the accounts that have `role`. `index` must be a
96      * value between 0 and {getRoleMemberCount}, non-inclusive.
97      *
98      * Role bearers are not sorted in any particular way, and their ordering may
99      * change at any point.
100      *
101      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
102      * you perform all queries on the same block. See the following
103      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
104      * for more information.
105      */
106     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
107 
108     /**
109      * @dev Returns the number of accounts that have `role`. Can be used
110      * together with {getRoleMember} to enumerate all bearers of a role.
111      */
112     function getRoleMemberCount(bytes32 role) external view returns (uint256);
113 }
114 
115 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
116 /**
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         return msg.data;
133     }
134 }
135 
136 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
137 /**
138  * @dev String operations.
139  */
140 library Strings {
141     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
142 
143     /**
144      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
145      */
146     function toString(uint256 value) internal pure returns (string memory) {
147         // Inspired by OraclizeAPI's implementation - MIT licence
148         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
149 
150         if (value == 0) {
151             return "0";
152         }
153         uint256 temp = value;
154         uint256 digits;
155         while (temp != 0) {
156             digits++;
157             temp /= 10;
158         }
159         bytes memory buffer = new bytes(digits);
160         while (value != 0) {
161             digits -= 1;
162             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
163             value /= 10;
164         }
165         return string(buffer);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
170      */
171     function toHexString(uint256 value) internal pure returns (string memory) {
172         if (value == 0) {
173             return "0x00";
174         }
175         uint256 temp = value;
176         uint256 length = 0;
177         while (temp != 0) {
178             length++;
179             temp >>= 8;
180         }
181         return toHexString(value, length);
182     }
183 
184     /**
185      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
186      */
187     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
188         bytes memory buffer = new bytes(2 * length + 2);
189         buffer[0] = "0";
190         buffer[1] = "x";
191         for (uint256 i = 2 * length + 1; i > 1; --i) {
192             buffer[i] = _HEX_SYMBOLS[value & 0xf];
193             value >>= 4;
194         }
195         require(value == 0, "Strings: hex length insufficient");
196         return string(buffer);
197     }
198 }
199 
200 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
201 /**
202  * @dev Interface of the ERC165 standard, as defined in the
203  * https://eips.ethereum.org/EIPS/eip-165[EIP].
204  *
205  * Implementers can declare support of contract interfaces, which can then be
206  * queried by others ({ERC165Checker}).
207  *
208  * For an implementation, see {ERC165}.
209  */
210 interface IERC165 {
211     /**
212      * @dev Returns true if this contract implements the interface defined by
213      * `interfaceId`. See the corresponding
214      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
215      * to learn more about how these ids are created.
216      *
217      * This function call must use less than 30 000 gas.
218      */
219     function supportsInterface(bytes4 interfaceId) external view returns (bool);
220 }
221 
222 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
223 /**
224  * @dev Implementation of the {IERC165} interface.
225  *
226  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
227  * for the additional interface id that will be supported. For example:
228  *
229  * ```solidity
230  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
231  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
232  * }
233  * ```
234  *
235  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
236  */
237 abstract contract ERC165 is IERC165 {
238     /**
239      * @dev See {IERC165-supportsInterface}.
240      */
241     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
242         return interfaceId == type(IERC165).interfaceId;
243     }
244 }
245 
246 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
247 /**
248  * @dev Contract module that allows children to implement role-based access
249  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
250  * members except through off-chain means by accessing the contract event logs. Some
251  * applications may benefit from on-chain enumerability, for those cases see
252  * {AccessControlEnumerable}.
253  *
254  * Roles are referred to by their `bytes32` identifier. These should be exposed
255  * in the external API and be unique. The best way to achieve this is by
256  * using `public constant` hash digests:
257  *
258  * ```
259  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
260  * ```
261  *
262  * Roles can be used to represent a set of permissions. To restrict access to a
263  * function call, use {hasRole}:
264  *
265  * ```
266  * function foo() public {
267  *     require(hasRole(MY_ROLE, msg.sender));
268  *     ...
269  * }
270  * ```
271  *
272  * Roles can be granted and revoked dynamically via the {grantRole} and
273  * {revokeRole} functions. Each role has an associated admin role, and only
274  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
275  *
276  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
277  * that only accounts with this role will be able to grant or revoke other
278  * roles. More complex role relationships can be created by using
279  * {_setRoleAdmin}.
280  *
281  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
282  * grant and revoke this role. Extra precautions should be taken to secure
283  * accounts that have been granted it.
284  */
285 abstract contract AccessControl is Context, IAccessControl, ERC165 {
286     struct RoleData {
287         mapping(address => bool) members;
288         bytes32 adminRole;
289     }
290 
291     mapping(bytes32 => RoleData) private _roles;
292 
293     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
294 
295     /**
296      * @dev Modifier that checks that an account has a specific role. Reverts
297      * with a standardized message including the required role.
298      *
299      * The format of the revert reason is given by the following regular expression:
300      *
301      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
302      *
303      * _Available since v4.1._
304      */
305     modifier onlyRole(bytes32 role) {
306         _checkRole(role, _msgSender());
307         _;
308     }
309 
310     /**
311      * @dev See {IERC165-supportsInterface}.
312      */
313     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
315     }
316 
317     /**
318      * @dev Returns `true` if `account` has been granted `role`.
319      */
320     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
321         return _roles[role].members[account];
322     }
323 
324     /**
325      * @dev Revert with a standard message if `account` is missing `role`.
326      *
327      * The format of the revert reason is given by the following regular expression:
328      *
329      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
330      */
331     function _checkRole(bytes32 role, address account) internal view virtual {
332         if (!hasRole(role, account)) {
333             revert(
334                 string(
335                     abi.encodePacked(
336                         "AccessControl: account ",
337                         Strings.toHexString(uint160(account), 20),
338                         " is missing role ",
339                         Strings.toHexString(uint256(role), 32)
340                     )
341                 )
342             );
343         }
344     }
345 
346     /**
347      * @dev Returns the admin role that controls `role`. See {grantRole} and
348      * {revokeRole}.
349      *
350      * To change a role's admin, use {_setRoleAdmin}.
351      */
352     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
353         return _roles[role].adminRole;
354     }
355 
356     /**
357      * @dev Grants `role` to `account`.
358      *
359      * If `account` had not been already granted `role`, emits a {RoleGranted}
360      * event.
361      *
362      * Requirements:
363      *
364      * - the caller must have ``role``'s admin role.
365      */
366     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
367         _grantRole(role, account);
368     }
369 
370     /**
371      * @dev Revokes `role` from `account`.
372      *
373      * If `account` had been granted `role`, emits a {RoleRevoked} event.
374      *
375      * Requirements:
376      *
377      * - the caller must have ``role``'s admin role.
378      */
379     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
380         _revokeRole(role, account);
381     }
382 
383     /**
384      * @dev Revokes `role` from the calling account.
385      *
386      * Roles are often managed via {grantRole} and {revokeRole}: this function's
387      * purpose is to provide a mechanism for accounts to lose their privileges
388      * if they are compromised (such as when a trusted device is misplaced).
389      *
390      * If the calling account had been revoked `role`, emits a {RoleRevoked}
391      * event.
392      *
393      * Requirements:
394      *
395      * - the caller must be `account`.
396      */
397     function renounceRole(bytes32 role, address account) public virtual override {
398         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
399 
400         _revokeRole(role, account);
401     }
402 
403     /**
404      * @dev Grants `role` to `account`.
405      *
406      * If `account` had not been already granted `role`, emits a {RoleGranted}
407      * event. Note that unlike {grantRole}, this function doesn't perform any
408      * checks on the calling account.
409      *
410      * [WARNING]
411      * ====
412      * This function should only be called from the constructor when setting
413      * up the initial roles for the system.
414      *
415      * Using this function in any other way is effectively circumventing the admin
416      * system imposed by {AccessControl}.
417      * ====
418      *
419      * NOTE: This function is deprecated in favor of {_grantRole}.
420      */
421     function _setupRole(bytes32 role, address account) internal virtual {
422         _grantRole(role, account);
423     }
424 
425     /**
426      * @dev Sets `adminRole` as ``role``'s admin role.
427      *
428      * Emits a {RoleAdminChanged} event.
429      */
430     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
431         bytes32 previousAdminRole = getRoleAdmin(role);
432         _roles[role].adminRole = adminRole;
433         emit RoleAdminChanged(role, previousAdminRole, adminRole);
434     }
435 
436     /**
437      * @dev Grants `role` to `account`.
438      *
439      * Internal function without access restriction.
440      */
441     function _grantRole(bytes32 role, address account) internal virtual {
442         if (!hasRole(role, account)) {
443             _roles[role].members[account] = true;
444             emit RoleGranted(role, account, _msgSender());
445         }
446     }
447 
448     /**
449      * @dev Revokes `role` from `account`.
450      *
451      * Internal function without access restriction.
452      */
453     function _revokeRole(bytes32 role, address account) internal virtual {
454         if (hasRole(role, account)) {
455             _roles[role].members[account] = false;
456             emit RoleRevoked(role, account, _msgSender());
457         }
458     }
459 }
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
462 /**
463  * @dev Library for managing
464  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
465  * types.
466  *
467  * Sets have the following properties:
468  *
469  * - Elements are added, removed, and checked for existence in constant time
470  * (O(1)).
471  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
472  *
473  * ```
474  * contract Example {
475  *     // Add the library methods
476  *     using EnumerableSet for EnumerableSet.AddressSet;
477  *
478  *     // Declare a set state variable
479  *     EnumerableSet.AddressSet private mySet;
480  * }
481  * ```
482  *
483  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
484  * and `uint256` (`UintSet`) are supported.
485  */
486 library EnumerableSet {
487     // To implement this library for multiple types with as little code
488     // repetition as possible, we write it in terms of a generic Set type with
489     // bytes32 values.
490     // The Set implementation uses private functions, and user-facing
491     // implementations (such as AddressSet) are just wrappers around the
492     // underlying Set.
493     // This means that we can only create new EnumerableSets for types that fit
494     // in bytes32.
495 
496     struct Set {
497         // Storage of set values
498         bytes32[] _values;
499         // Position of the value in the `values` array, plus 1 because index 0
500         // means a value is not in the set.
501         mapping(bytes32 => uint256) _indexes;
502     }
503 
504     /**
505      * @dev Add a value to a set. O(1).
506      *
507      * Returns true if the value was added to the set, that is if it was not
508      * already present.
509      */
510     function _add(Set storage set, bytes32 value) private returns (bool) {
511         if (!_contains(set, value)) {
512             set._values.push(value);
513             // The value is stored at length-1, but we add 1 to all indexes
514             // and use 0 as a sentinel value
515             set._indexes[value] = set._values.length;
516             return true;
517         } else {
518             return false;
519         }
520     }
521 
522     /**
523      * @dev Removes a value from a set. O(1).
524      *
525      * Returns true if the value was removed from the set, that is if it was
526      * present.
527      */
528     function _remove(Set storage set, bytes32 value) private returns (bool) {
529         // We read and store the value's index to prevent multiple reads from the same storage slot
530         uint256 valueIndex = set._indexes[value];
531 
532         if (valueIndex != 0) {
533             // Equivalent to contains(set, value)
534             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
535             // the array, and then remove the last element (sometimes called as 'swap and pop').
536             // This modifies the order of the array, as noted in {at}.
537 
538             uint256 toDeleteIndex = valueIndex - 1;
539             uint256 lastIndex = set._values.length - 1;
540 
541             if (lastIndex != toDeleteIndex) {
542                 bytes32 lastvalue = set._values[lastIndex];
543 
544                 // Move the last value to the index where the value to delete is
545                 set._values[toDeleteIndex] = lastvalue;
546                 // Update the index for the moved value
547                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
548             }
549 
550             // Delete the slot where the moved value was stored
551             set._values.pop();
552 
553             // Delete the index for the deleted slot
554             delete set._indexes[value];
555 
556             return true;
557         } else {
558             return false;
559         }
560     }
561 
562     /**
563      * @dev Returns true if the value is in the set. O(1).
564      */
565     function _contains(Set storage set, bytes32 value) private view returns (bool) {
566         return set._indexes[value] != 0;
567     }
568 
569     /**
570      * @dev Returns the number of values on the set. O(1).
571      */
572     function _length(Set storage set) private view returns (uint256) {
573         return set._values.length;
574     }
575 
576     /**
577      * @dev Returns the value stored at position `index` in the set. O(1).
578      *
579      * Note that there are no guarantees on the ordering of values inside the
580      * array, and it may change when more values are added or removed.
581      *
582      * Requirements:
583      *
584      * - `index` must be strictly less than {length}.
585      */
586     function _at(Set storage set, uint256 index) private view returns (bytes32) {
587         return set._values[index];
588     }
589 
590     /**
591      * @dev Return the entire set in an array
592      *
593      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
594      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
595      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
596      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
597      */
598     function _values(Set storage set) private view returns (bytes32[] memory) {
599         return set._values;
600     }
601 
602     // Bytes32Set
603 
604     struct Bytes32Set {
605         Set _inner;
606     }
607 
608     /**
609      * @dev Add a value to a set. O(1).
610      *
611      * Returns true if the value was added to the set, that is if it was not
612      * already present.
613      */
614     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
615         return _add(set._inner, value);
616     }
617 
618     /**
619      * @dev Removes a value from a set. O(1).
620      *
621      * Returns true if the value was removed from the set, that is if it was
622      * present.
623      */
624     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
625         return _remove(set._inner, value);
626     }
627 
628     /**
629      * @dev Returns true if the value is in the set. O(1).
630      */
631     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
632         return _contains(set._inner, value);
633     }
634 
635     /**
636      * @dev Returns the number of values in the set. O(1).
637      */
638     function length(Bytes32Set storage set) internal view returns (uint256) {
639         return _length(set._inner);
640     }
641 
642     /**
643      * @dev Returns the value stored at position `index` in the set. O(1).
644      *
645      * Note that there are no guarantees on the ordering of values inside the
646      * array, and it may change when more values are added or removed.
647      *
648      * Requirements:
649      *
650      * - `index` must be strictly less than {length}.
651      */
652     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
653         return _at(set._inner, index);
654     }
655 
656     /**
657      * @dev Return the entire set in an array
658      *
659      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
660      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
661      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
662      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
663      */
664     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
665         return _values(set._inner);
666     }
667 
668     // AddressSet
669 
670     struct AddressSet {
671         Set _inner;
672     }
673 
674     /**
675      * @dev Add a value to a set. O(1).
676      *
677      * Returns true if the value was added to the set, that is if it was not
678      * already present.
679      */
680     function add(AddressSet storage set, address value) internal returns (bool) {
681         return _add(set._inner, bytes32(uint256(uint160(value))));
682     }
683 
684     /**
685      * @dev Removes a value from a set. O(1).
686      *
687      * Returns true if the value was removed from the set, that is if it was
688      * present.
689      */
690     function remove(AddressSet storage set, address value) internal returns (bool) {
691         return _remove(set._inner, bytes32(uint256(uint160(value))));
692     }
693 
694     /**
695      * @dev Returns true if the value is in the set. O(1).
696      */
697     function contains(AddressSet storage set, address value) internal view returns (bool) {
698         return _contains(set._inner, bytes32(uint256(uint160(value))));
699     }
700 
701     /**
702      * @dev Returns the number of values in the set. O(1).
703      */
704     function length(AddressSet storage set) internal view returns (uint256) {
705         return _length(set._inner);
706     }
707 
708     /**
709      * @dev Returns the value stored at position `index` in the set. O(1).
710      *
711      * Note that there are no guarantees on the ordering of values inside the
712      * array, and it may change when more values are added or removed.
713      *
714      * Requirements:
715      *
716      * - `index` must be strictly less than {length}.
717      */
718     function at(AddressSet storage set, uint256 index) internal view returns (address) {
719         return address(uint160(uint256(_at(set._inner, index))));
720     }
721 
722     /**
723      * @dev Return the entire set in an array
724      *
725      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
726      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
727      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
728      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
729      */
730     function values(AddressSet storage set) internal view returns (address[] memory) {
731         bytes32[] memory store = _values(set._inner);
732         address[] memory result;
733 
734         assembly {
735             result := store
736         }
737 
738         return result;
739     }
740 
741     // UintSet
742 
743     struct UintSet {
744         Set _inner;
745     }
746 
747     /**
748      * @dev Add a value to a set. O(1).
749      *
750      * Returns true if the value was added to the set, that is if it was not
751      * already present.
752      */
753     function add(UintSet storage set, uint256 value) internal returns (bool) {
754         return _add(set._inner, bytes32(value));
755     }
756 
757     /**
758      * @dev Removes a value from a set. O(1).
759      *
760      * Returns true if the value was removed from the set, that is if it was
761      * present.
762      */
763     function remove(UintSet storage set, uint256 value) internal returns (bool) {
764         return _remove(set._inner, bytes32(value));
765     }
766 
767     /**
768      * @dev Returns true if the value is in the set. O(1).
769      */
770     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
771         return _contains(set._inner, bytes32(value));
772     }
773 
774     /**
775      * @dev Returns the number of values on the set. O(1).
776      */
777     function length(UintSet storage set) internal view returns (uint256) {
778         return _length(set._inner);
779     }
780 
781     /**
782      * @dev Returns the value stored at position `index` in the set. O(1).
783      *
784      * Note that there are no guarantees on the ordering of values inside the
785      * array, and it may change when more values are added or removed.
786      *
787      * Requirements:
788      *
789      * - `index` must be strictly less than {length}.
790      */
791     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
792         return uint256(_at(set._inner, index));
793     }
794 
795     /**
796      * @dev Return the entire set in an array
797      *
798      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
799      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
800      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
801      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
802      */
803     function values(UintSet storage set) internal view returns (uint256[] memory) {
804         bytes32[] memory store = _values(set._inner);
805         uint256[] memory result;
806 
807         assembly {
808             result := store
809         }
810 
811         return result;
812     }
813 }
814 
815 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
816     using EnumerableSet for EnumerableSet.AddressSet;
817 
818     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
819 
820     /**
821      * @dev See {IERC165-supportsInterface}.
822      */
823     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
824         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
825     }
826 
827     /**
828      * @dev Returns one of the accounts that have `role`. `index` must be a
829      * value between 0 and {getRoleMemberCount}, non-inclusive.
830      *
831      * Role bearers are not sorted in any particular way, and their ordering may
832      * change at any point.
833      *
834      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
835      * you perform all queries on the same block. See the following
836      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
837      * for more information.
838      */
839     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
840         return _roleMembers[role].at(index);
841     }
842 
843     /**
844      * @dev Returns the number of accounts that have `role`. Can be used
845      * together with {getRoleMember} to enumerate all bearers of a role.
846      */
847     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
848         return _roleMembers[role].length();
849     }
850 
851     /**
852      * @dev Overload {_grantRole} to track enumerable memberships
853      */
854     function _grantRole(bytes32 role, address account) internal virtual override {
855         super._grantRole(role, account);
856         _roleMembers[role].add(account);
857     }
858 
859     /**
860      * @dev Overload {_revokeRole} to track enumerable memberships
861      */
862     function _revokeRole(bytes32 role, address account) internal virtual override {
863         super._revokeRole(role, account);
864         _roleMembers[role].remove(account);
865     }
866 }
867 
868 abstract contract ReentrancyGuard {
869     // Booleans are more expensive than uint256 or any type that takes up a full
870     // word because each write operation emits an extra SLOAD to first read the
871     // slot's contents, replace the bits taken up by the boolean, and then write
872     // back. This is the compiler's defense against contract upgrades and
873     // pointer aliasing, and it cannot be disabled.
874 
875     // The values being non-zero value makes deployment a bit more expensive,
876     // but in exchange the refund on every call to nonReentrant will be lower in
877     // amount. Since refunds are capped to a percentage of the total
878     // transaction's gas, it is best to keep them low in cases like this one, to
879     // increase the likelihood of the full refund coming into effect.
880     uint256 private constant _NOT_ENTERED = 1;
881     uint256 private constant _ENTERED = 2;
882 
883     uint256 private _status;
884 
885     constructor() {
886         _status = _NOT_ENTERED;
887     }
888 
889     /**
890      * @dev Prevents a contract from calling itself, directly or indirectly.
891      * Calling a `nonReentrant` function from another `nonReentrant`
892      * function is not supported. It is possible to prevent this from happening
893      * by making the `nonReentrant` function external, and making it call a
894      * `private` function that does the actual work.
895      */
896     modifier nonReentrant() {
897         // On the first call to nonReentrant, _notEntered will be true
898         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
899 
900         // Any calls to nonReentrant after this point will fail
901         _status = _ENTERED;
902 
903         _;
904 
905         // By storing the original value once again, a refund is triggered (see
906         // https://eips.ethereum.org/EIPS/eip-2200)
907         _status = _NOT_ENTERED;
908     }
909 }
910 
911 abstract contract Pausable is Context {
912     /**
913      * @dev Emitted when the pause is triggered by `account`.
914      */
915     event Paused(address account);
916 
917     /**
918      * @dev Emitted when the pause is lifted by `account`.
919      */
920     event Unpaused(address account);
921 
922     bool private _paused;
923 
924     /**
925      * @dev Initializes the contract in unpaused state.
926      */
927     constructor() {
928         _paused = false;
929     }
930 
931     /**
932      * @dev Returns true if the contract is paused, and false otherwise.
933      */
934     function paused() public view virtual returns (bool) {
935         return _paused;
936     }
937 
938     /**
939      * @dev Modifier to make a function callable only when the contract is not paused.
940      *
941      * Requirements:
942      *
943      * - The contract must not be paused.
944      */
945     modifier whenNotPaused() {
946         require(!paused(), "Pausable: paused");
947         _;
948     }
949 
950     /**
951      * @dev Modifier to make a function callable only when the contract is paused.
952      *
953      * Requirements:
954      *
955      * - The contract must be paused.
956      */
957     modifier whenPaused() {
958         require(paused(), "Pausable: not paused");
959         _;
960     }
961 
962     /**
963      * @dev Triggers stopped state.
964      *
965      * Requirements:
966      *
967      * - The contract must not be paused.
968      */
969     function _pause() internal virtual whenNotPaused {
970         _paused = true;
971         emit Paused(_msgSender());
972     }
973 
974     /**
975      * @dev Returns to normal state.
976      *
977      * Requirements:
978      *
979      * - The contract must be paused.
980      */
981     function _unpause() internal virtual whenPaused {
982         _paused = false;
983         emit Unpaused(_msgSender());
984     }
985 }
986 
987 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
988 /**
989  * @dev Interface of the ERC20 standard as defined in the EIP.
990  */
991 interface IERC20 {
992     /**
993      * @dev Returns the amount of tokens in existence.
994      */
995     function totalSupply() external view returns (uint256);
996 
997     /**
998      * @dev Returns the amount of tokens owned by `account`.
999      */
1000     function balanceOf(address account) external view returns (uint256);
1001 
1002     /**
1003      * @dev Moves `amount` tokens from the caller's account to `to`.
1004      *
1005      * Returns a boolean value indicating whether the operation succeeded.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function transfer(address to, uint256 amount) external returns (bool);
1010 
1011     /**
1012      * @dev Returns the remaining number of tokens that `spender` will be
1013      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1014      * zero by default.
1015      *
1016      * This value changes when {approve} or {transferFrom} are called.
1017      */
1018     function allowance(address owner, address spender) external view returns (uint256);
1019 
1020     /**
1021      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1022      *
1023      * Returns a boolean value indicating whether the operation succeeded.
1024      *
1025      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1026      * that someone may use both the old and the new allowance by unfortunate
1027      * transaction ordering. One possible solution to mitigate this race
1028      * condition is to first reduce the spender's allowance to 0 and set the
1029      * desired value afterwards:
1030      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1031      *
1032      * Emits an {Approval} event.
1033      */
1034     function approve(address spender, uint256 amount) external returns (bool);
1035 
1036     /**
1037      * @dev Moves `amount` tokens from `from` to `to` using the
1038      * allowance mechanism. `amount` is then deducted from the caller's
1039      * allowance.
1040      *
1041      * Returns a boolean value indicating whether the operation succeeded.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function transferFrom(
1046         address from,
1047         address to,
1048         uint256 amount
1049     ) external returns (bool);
1050 
1051     /**
1052      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1053      * another (`to`).
1054      *
1055      * Note that `value` may be zero.
1056      */
1057     event Transfer(address indexed from, address indexed to, uint256 value);
1058 
1059     /**
1060      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1061      * a call to {approve}. `value` is the new allowance.
1062      */
1063     event Approval(address indexed owner, address indexed spender, uint256 value);
1064 }
1065 
1066 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1067 /**
1068  * @dev Collection of functions related to the address type
1069  */
1070 library Address {
1071     /**
1072      * @dev Returns true if `account` is a contract.
1073      *
1074      * [IMPORTANT]
1075      * ====
1076      * It is unsafe to assume that an address for which this function returns
1077      * false is an externally-owned account (EOA) and not a contract.
1078      *
1079      * Among others, `isContract` will return false for the following
1080      * types of addresses:
1081      *
1082      *  - an externally-owned account
1083      *  - a contract in construction
1084      *  - an address where a contract will be created
1085      *  - an address where a contract lived, but was destroyed
1086      * ====
1087      *
1088      * [IMPORTANT]
1089      * ====
1090      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1091      *
1092      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1093      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1094      * constructor.
1095      * ====
1096      */
1097     function isContract(address account) internal view returns (bool) {
1098         // This method relies on extcodesize/address.code.length, which returns 0
1099         // for contracts in construction, since the code is only stored at the end
1100         // of the constructor execution.
1101 
1102         return account.code.length > 0;
1103     }
1104 
1105     /**
1106      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1107      * `recipient`, forwarding all available gas and reverting on errors.
1108      *
1109      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1110      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1111      * imposed by `transfer`, making them unable to receive funds via
1112      * `transfer`. {sendValue} removes this limitation.
1113      *
1114      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1115      *
1116      * IMPORTANT: because control is transferred to `recipient`, care must be
1117      * taken to not create reentrancy vulnerabilities. Consider using
1118      * {ReentrancyGuard} or the
1119      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1120      */
1121     function sendValue(address payable recipient, uint256 amount) internal {
1122         require(address(this).balance >= amount, "Address: insufficient balance");
1123 
1124         (bool success, ) = recipient.call{value: amount}("");
1125         require(success, "Address: unable to send value, recipient may have reverted");
1126     }
1127 
1128     /**
1129      * @dev Performs a Solidity function call using a low level `call`. A
1130      * plain `call` is an unsafe replacement for a function call: use this
1131      * function instead.
1132      *
1133      * If `target` reverts with a revert reason, it is bubbled up by this
1134      * function (like regular Solidity function calls).
1135      *
1136      * Returns the raw returned data. To convert to the expected return value,
1137      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1138      *
1139      * Requirements:
1140      *
1141      * - `target` must be a contract.
1142      * - calling `target` with `data` must not revert.
1143      *
1144      * _Available since v3.1._
1145      */
1146     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1147         return functionCall(target, data, "Address: low-level call failed");
1148     }
1149 
1150     /**
1151      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1152      * `errorMessage` as a fallback revert reason when `target` reverts.
1153      *
1154      * _Available since v3.1._
1155      */
1156     function functionCall(
1157         address target,
1158         bytes memory data,
1159         string memory errorMessage
1160     ) internal returns (bytes memory) {
1161         return functionCallWithValue(target, data, 0, errorMessage);
1162     }
1163 
1164     /**
1165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1166      * but also transferring `value` wei to `target`.
1167      *
1168      * Requirements:
1169      *
1170      * - the calling contract must have an ETH balance of at least `value`.
1171      * - the called Solidity function must be `payable`.
1172      *
1173      * _Available since v3.1._
1174      */
1175     function functionCallWithValue(
1176         address target,
1177         bytes memory data,
1178         uint256 value
1179     ) internal returns (bytes memory) {
1180         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1181     }
1182 
1183     /**
1184      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1185      * with `errorMessage` as a fallback revert reason when `target` reverts.
1186      *
1187      * _Available since v3.1._
1188      */
1189     function functionCallWithValue(
1190         address target,
1191         bytes memory data,
1192         uint256 value,
1193         string memory errorMessage
1194     ) internal returns (bytes memory) {
1195         require(address(this).balance >= value, "Address: insufficient balance for call");
1196         require(isContract(target), "Address: call to non-contract");
1197 
1198         (bool success, bytes memory returndata) = target.call{value: value}(data);
1199         return verifyCallResult(success, returndata, errorMessage);
1200     }
1201 
1202     /**
1203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1204      * but performing a static call.
1205      *
1206      * _Available since v3.3._
1207      */
1208     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1209         return functionStaticCall(target, data, "Address: low-level static call failed");
1210     }
1211 
1212     /**
1213      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1214      * but performing a static call.
1215      *
1216      * _Available since v3.3._
1217      */
1218     function functionStaticCall(
1219         address target,
1220         bytes memory data,
1221         string memory errorMessage
1222     ) internal view returns (bytes memory) {
1223         require(isContract(target), "Address: static call to non-contract");
1224 
1225         (bool success, bytes memory returndata) = target.staticcall(data);
1226         return verifyCallResult(success, returndata, errorMessage);
1227     }
1228 
1229     /**
1230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1231      * but performing a delegate call.
1232      *
1233      * _Available since v3.4._
1234      */
1235     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1236         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1237     }
1238 
1239     /**
1240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1241      * but performing a delegate call.
1242      *
1243      * _Available since v3.4._
1244      */
1245     function functionDelegateCall(
1246         address target,
1247         bytes memory data,
1248         string memory errorMessage
1249     ) internal returns (bytes memory) {
1250         require(isContract(target), "Address: delegate call to non-contract");
1251 
1252         (bool success, bytes memory returndata) = target.delegatecall(data);
1253         return verifyCallResult(success, returndata, errorMessage);
1254     }
1255 
1256     /**
1257      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1258      * revert reason using the provided one.
1259      *
1260      * _Available since v4.3._
1261      */
1262     function verifyCallResult(
1263         bool success,
1264         bytes memory returndata,
1265         string memory errorMessage
1266     ) internal pure returns (bytes memory) {
1267         if (success) {
1268             return returndata;
1269         } else {
1270             // Look for revert reason and bubble it up if present
1271             if (returndata.length > 0) {
1272                 // The easiest way to bubble the revert reason is using memory via assembly
1273 
1274                 assembly {
1275                     let returndata_size := mload(returndata)
1276                     revert(add(32, returndata), returndata_size)
1277                 }
1278             } else {
1279                 revert(errorMessage);
1280             }
1281         }
1282     }
1283 }
1284 
1285 library SafeERC20 {
1286     using Address for address;
1287 
1288     function safeTransfer(
1289         IERC20 token,
1290         address to,
1291         uint256 value
1292     ) internal {
1293         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1294     }
1295 
1296     function safeTransferFrom(
1297         IERC20 token,
1298         address from,
1299         address to,
1300         uint256 value
1301     ) internal {
1302         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1303     }
1304 
1305     /**
1306      * @dev Deprecated. This function has issues similar to the ones found in
1307      * {IERC20-approve}, and its usage is discouraged.
1308      *
1309      * Whenever possible, use {safeIncreaseAllowance} and
1310      * {safeDecreaseAllowance} instead.
1311      */
1312     function safeApprove(
1313         IERC20 token,
1314         address spender,
1315         uint256 value
1316     ) internal {
1317         // safeApprove should only be called when setting an initial allowance,
1318         // or when resetting it to zero. To increase and decrease it, use
1319         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1320         require(
1321             (value == 0) || (token.allowance(address(this), spender) == 0),
1322             "SafeERC20: approve from non-zero to non-zero allowance"
1323         );
1324         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1325     }
1326 
1327     function safeIncreaseAllowance(
1328         IERC20 token,
1329         address spender,
1330         uint256 value
1331     ) internal {
1332         uint256 newAllowance = token.allowance(address(this), spender) + value;
1333         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1334     }
1335 
1336     function safeDecreaseAllowance(
1337         IERC20 token,
1338         address spender,
1339         uint256 value
1340     ) internal {
1341         unchecked {
1342             uint256 oldAllowance = token.allowance(address(this), spender);
1343             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1344             uint256 newAllowance = oldAllowance - value;
1345             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1346         }
1347     }
1348 
1349     /**
1350      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1351      * on the return value: the return value is optional (but if data is returned, it must not be false).
1352      * @param token The token targeted by the call.
1353      * @param data The call data (encoded using abi.encode or one of its variants).
1354      */
1355     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1356         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1357         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1358         // the target address contains contract code and also asserts for success in the low-level call.
1359 
1360         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1361         if (returndata.length > 0) {
1362             // Return data is optional
1363             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1364         }
1365     }
1366 }
1367 
1368 interface ICurrencyManager {
1369     function addCurrency(address currency) external;
1370 
1371     function removeCurrency(address currency) external;
1372 
1373     function isCurrencyWhitelisted(address currency) external view returns (bool);
1374 
1375     function viewWhitelistedCurrencies(uint256 cursor, uint256 size)
1376         external
1377         view
1378         returns (address[] memory, uint256);
1379 
1380     function viewCountWhitelistedCurrencies() external view returns (uint256);
1381 }
1382 
1383 interface IExecutionManager {
1384     function addStrategy(address strategy) external;
1385 
1386     function removeStrategy(address strategy) external;
1387 
1388     function isStrategyWhitelisted(address strategy) external view returns (bool);
1389 
1390     function viewWhitelistedStrategies(uint256 cursor, uint256 size)
1391         external
1392         view
1393         returns (address[] memory, uint256);
1394 
1395     function viewCountWhitelistedStrategies() external view returns (uint256);
1396 }
1397 
1398 library OrderTypes {
1399     // keccak256("MakerOrder(bool isOrderAsk,address signer,address collection,uint256 price,uint256 tokenId,uint256 amount,address strategy,address currency,uint256 nonce,uint256 startTime,uint256 endTime,uint256 minPercentageToAsk,bytes params)")
1400     bytes32 internal constant MAKER_ORDER_HASH =
1401         0x40261ade532fa1d2c7293df30aaadb9b3c616fae525a0b56d3d411c841a85028;
1402 
1403     struct MakerOrder {
1404         bool isOrderAsk; // true --> ask / false --> bid
1405         address signer; // signer of the maker order
1406         address collection; // collection address
1407         uint256 price; // price (used as )
1408         uint256 tokenId; // id of the token
1409         uint256 amount; // amount of tokens to sell/purchase (must be 1 for ERC721, 1+ for ERC1155)
1410         address strategy; // strategy for trade execution (e.g., DutchAuction, StandardSaleForFixedPrice)
1411         address currency; // currency (e.g., WETH)
1412         uint256 nonce; // order nonce (must be unique unless new maker order is meant to override existing one e.g., lower ask price)
1413         uint256 startTime; // startTime in timestamp
1414         uint256 endTime; // endTime in timestamp
1415         uint256 minPercentageToAsk; // slippage protection (9000 --> 90% of the final price must return to ask)
1416         bytes params; // additional parameters
1417         uint8 v; // v: parameter (27 or 28)
1418         bytes32 r; // r: parameter
1419         bytes32 s; // s: parameter
1420     }
1421 
1422     struct TakerOrder {
1423         bool isOrderAsk; // true --> ask / false --> bid
1424         address taker; // msg.sender
1425         uint256 price; // final price for the purchase
1426         uint256 tokenId;
1427         uint256 minPercentageToAsk; // // slippage protection (9000 --> 90% of the final price must return to ask)
1428         bytes params; // other params (e.g., tokenId)
1429     }
1430 
1431     function hash(MakerOrder memory makerOrder) internal pure returns (bytes32) {
1432         return
1433             keccak256(
1434                 abi.encode(
1435                     MAKER_ORDER_HASH,
1436                     makerOrder.isOrderAsk,
1437                     makerOrder.signer,
1438                     makerOrder.collection,
1439                     makerOrder.price,
1440                     makerOrder.tokenId,
1441                     makerOrder.amount,
1442                     makerOrder.strategy,
1443                     makerOrder.currency,
1444                     makerOrder.nonce,
1445                     makerOrder.startTime,
1446                     makerOrder.endTime,
1447                     makerOrder.minPercentageToAsk,
1448                     keccak256(makerOrder.params)
1449                 )
1450             );
1451     }
1452 }
1453 
1454 interface IExecutionStrategy {
1455     function canExecuteTakerAsk(
1456         OrderTypes.TakerOrder calldata takerAsk,
1457         OrderTypes.MakerOrder calldata makerBid
1458     )
1459         external
1460         view
1461         returns (
1462             bool,
1463             uint256,
1464             uint256
1465         );
1466 
1467     function canExecuteTakerBid(
1468         OrderTypes.TakerOrder calldata takerBid,
1469         OrderTypes.MakerOrder calldata makerAsk
1470     )
1471         external
1472         view
1473         returns (
1474             bool,
1475             uint256,
1476             uint256
1477         );
1478 
1479     function canExecuteMakerOrder(
1480         OrderTypes.MakerOrder calldata makerBid,
1481         OrderTypes.MakerOrder calldata makerAsk
1482     )
1483         external
1484         view
1485         returns (
1486             bool,
1487             uint256,
1488             uint256
1489         );
1490 
1491     function viewProtocolFee() external view returns (uint256);
1492 }
1493 
1494 interface IRoyaltyFeeManager {
1495     function calculateRoyaltyFeeAndGetRecipient(
1496         address collection,
1497         uint256 tokenId,
1498         uint256 amount
1499     ) external view returns (address, uint256);
1500 }
1501 
1502 interface IMintedExchange {
1503     function matchAskWithTakerBidUsingETHAndWETH(
1504         OrderTypes.TakerOrder calldata takerBid,
1505         OrderTypes.MakerOrder calldata makerAsk
1506     ) external payable;
1507 
1508     function matchAskWithTakerBid(
1509         OrderTypes.TakerOrder calldata takerBid,
1510         OrderTypes.MakerOrder calldata makerAsk
1511     ) external;
1512 
1513     function matchBidWithTakerAsk(
1514         OrderTypes.TakerOrder calldata takerAsk,
1515         OrderTypes.MakerOrder calldata makerBid
1516     ) external;
1517 
1518     function matchMakerOrders(
1519         OrderTypes.MakerOrder calldata makerBid,
1520         OrderTypes.MakerOrder calldata makerAsk
1521     ) external;
1522 }
1523 
1524 interface ITransferManagerNFT {
1525     function transferNonFungibleToken(
1526         address collection,
1527         address from,
1528         address to,
1529         uint256 tokenId,
1530         uint256 amount
1531     ) external;
1532 }
1533 
1534 interface ITransferSelectorNFT {
1535     function checkTransferManagerForToken(address collection) external view returns (address);
1536 }
1537 
1538 interface IWETH {
1539     function deposit() external payable;
1540 
1541     function transfer(address to, uint256 value) external returns (bool);
1542 
1543     function withdraw(uint256) external;
1544 }
1545 
1546 interface IERC1271 {
1547     /**
1548      * @dev Should return whether the signature provided is valid for the provided data
1549      * @param hash      Hash of the data to be signed
1550      * @param signature Signature byte array associated with _data
1551      */
1552     function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
1553 }
1554 
1555 library SignatureChecker {
1556     /**
1557      * @notice Recovers the signer of a signature (for EOA)
1558      * @param hash the hash containing the signed mesage
1559      * @param v parameter (27 or 28). This prevents maleability since the public key recovery equation has two possible solutions.
1560      * @param r parameter
1561      * @param s parameter
1562      */
1563     function recover(
1564         bytes32 hash,
1565         uint8 v,
1566         bytes32 r,
1567         bytes32 s
1568     ) internal pure returns (address) {
1569         // https://ethereum.stackexchange.com/questions/83174/is-it-best-practice-to-check-signature-malleability-in-ecrecover
1570         // https://crypto.iacr.org/2019/affevents/wac/medias/Heninger-BiasedNonceSense.pdf
1571         require(
1572             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
1573             "Signature: Invalid s parameter"
1574         );
1575 
1576         require(v == 27 || v == 28, "Signature: Invalid v parameter");
1577 
1578         // If the signature is valid (and not malleable), return the signer address
1579         address signer = ecrecover(hash, v, r, s);
1580         require(signer != address(0), "Signature: Invalid signer");
1581 
1582         return signer;
1583     }
1584 
1585     /**
1586      * @notice Returns whether the signer matches the signed message
1587      * @param hash the hash containing the signed mesage
1588      * @param signer the signer address to confirm message validity
1589      * @param v parameter (27 or 28)
1590      * @param r parameter
1591      * @param s parameter
1592      * @param domainSeparator paramer to prevent signature being executed in other chains and environments
1593      * @return true --> if valid // false --> if invalid
1594      */
1595     function verify(
1596         bytes32 hash,
1597         address signer,
1598         uint8 v,
1599         bytes32 r,
1600         bytes32 s,
1601         bytes32 domainSeparator
1602     ) internal view returns (bool) {
1603         // \x19\x01 is the standardized encoding prefix
1604         // https://eips.ethereum.org/EIPS/eip-712#specification
1605         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, hash));
1606         if (Address.isContract(signer)) {
1607             // 0x1626ba7e is the interfaceId for signature contracts (see IERC1271)
1608             return IERC1271(signer).isValidSignature(digest, abi.encodePacked(r, s, v)) == 0x1626ba7e;
1609         } else {
1610             return recover(digest, v, r, s) == signer;
1611         }
1612     }
1613 }
1614 
1615 /**
1616                                                 ....                      ....                              ....       
1617                                                  #@@@?                    ^@@@@                             :@@@@       
1618                                                  P&&&!                    :@@@@                             :@@@@       
1619      ....  ....  ....     .....................  ....   ............   ...!@@@@:...   ............  ........!@@@@       
1620     !@@@&  @@@@: G@@@Y   .@@@@@@@@@@@@@@@@@@@@@. #@@@? !@@@@@@@@@@@@~ J@@@@@@@@@@@@^ P@@@@@@@@@@@@. B@@@@@@@@@@@@       
1621     !@@@&  @@@@: G@@@5   .@@@@&&&&@@@@@&&&&@@@@. #@@@? !@@@@&&&&@@@@~ 7&&&&@@@@&&&&: P@@@@#&&&@@@@. B@@@@&&&&@@@@       
1622     ~&&&G  #&&&. G@@@5   .@@@@.   G@@@5   .@@@@. #@@@? !@@@&    &@@@~     ^@@@@      P@@@G...~@@@@. B@@@Y   ^@@@@       
1623                  G@@@5   .@@@@.   G@@@5   .@@@@. #@@@? !@@@&    &@@@~     ^@@@@      P@@@@@@@@@@@@. B@@@J   :@@@@       
1624                  G@@@5   .@@@@.   G@@@5   .@@@@. #@@@? !@@@&    &@@@~     ^@@@@      P@@@@#&&&##&#. B@@@J   :@@@@       
1625      ............B@@@5   .@@@@.   G@@@5   .@@@@. #@@@? !@@@&    &@@@~     ^@@@@      P@@@G........  B@@@5...!@@@@       
1626     !@@@@@@@@@@@@@@@@5   .@@@@.   G@@@5   .@@@@. #@@@? 7@@@&    &@@@~     ^@@@@      P@@@@@@@@@@@@. B@@@@@@@@@@@@       
1627     ~&&&&&&&&&&&&&&&&?   .&&&#    Y&&&?   .&&&#. P&&&! ~&&&G    B&&&^     :&&&#      J&&&&&&&&&&&&. 5&&&&&&&&&&&#   
1628                                                                                                                                                                                             
1629 */
1630 // SPDX-License-Identifier: MIT
1631 /**
1632  * @title Minted
1633  * @notice It is the core contract of the Minted exchange.
1634  */
1635 contract MintedExchange is IMintedExchange, ReentrancyGuard, Pausable, AccessControlEnumerable {
1636     using SafeERC20 for IERC20;
1637 
1638     using OrderTypes for OrderTypes.MakerOrder;
1639     using OrderTypes for OrderTypes.TakerOrder;
1640 
1641     bytes32 public constant MATCH_MAKER_ORDERS_ROLE = keccak256("MATCH_MAKER_ORDERS_ROLE");
1642     bool public isMatchMakerOrderBeta = true;
1643 
1644     address public immutable WETH;
1645     bytes32 public immutable DOMAIN_SEPARATOR;
1646 
1647     address public protocolFeeRecipient;
1648 
1649     ICurrencyManager public currencyManager;
1650     IExecutionManager public executionManager;
1651     IRoyaltyFeeManager public royaltyFeeManager;
1652     ITransferSelectorNFT public transferSelectorNFT;
1653 
1654     mapping(address => uint256) public userMinOrderNonce;
1655     mapping(address => mapping(uint256 => bool)) private _isUserOrderNonceExecutedOrCancelled;
1656 
1657     event CancelAllOrders(address indexed user, uint256 newMinNonce);
1658     event CancelMultipleOrders(address indexed user, uint256[] orderNonces);
1659     event NewCurrencyManager(address indexed currencyManager);
1660     event NewExecutionManager(address indexed executionManager);
1661     event NewProtocolFeeRecipient(address indexed protocolFeeRecipient);
1662     event NewRoyaltyFeeManager(address indexed royaltyFeeManager);
1663     event NewTransferSelectorNFT(address indexed transferSelectorNFT);
1664 
1665     event RoyaltyPayment(
1666         address indexed collection,
1667         uint256 indexed tokenId,
1668         address indexed royaltyRecipient,
1669         address currency,
1670         uint256 amount
1671     );
1672 
1673     event TakerAsk(
1674         bytes32 orderHash, // bid hash of the maker order
1675         uint256 orderNonce, // user order nonce
1676         address indexed taker, // sender address for the taker ask order
1677         address indexed maker, // maker address of the initial bid order
1678         address indexed strategy, // strategy that defines the execution
1679         address currency, // currency address
1680         address collection, // collection address
1681         uint256 tokenId, // tokenId transferred
1682         uint256 amount, // amount of tokens transferred
1683         uint256 price // final transacted price
1684     );
1685 
1686     event TakerBid(
1687         bytes32 orderHash, // ask hash of the maker order
1688         uint256 orderNonce, // user order nonce
1689         address indexed taker, // sender address for the taker bid order
1690         address indexed maker, // maker address of the initial ask order
1691         address indexed strategy, // strategy that defines the execution
1692         address currency, // currency address
1693         address collection, // collection address
1694         uint256 tokenId, // tokenId transferred
1695         uint256 amount, // amount of tokens transferred
1696         uint256 price // final transacted price
1697     );
1698 
1699     event MakerMatch(
1700         bytes32 orderHash, //ask hash of the maker order
1701         uint256 bidOrderNonce, // user bid order nonce
1702         uint256 askOrderNonce, // user ask order nonce
1703         address indexed taker, // address for the bid order
1704         address indexed maker, // address of the ask order
1705         address indexed strategy, // strategy that defines the execution
1706         address currency, // currency address
1707         address collection, // collection address
1708         uint256 tokenId, // tokenId transferred
1709         uint256 amount, // amount of tokens transferred
1710         uint256 price // final transacted price
1711     );
1712 
1713     modifier onlyMatchMakerRoleOrNotBeta() {
1714         require(
1715             !isMatchMakerOrderBeta || hasRole(MATCH_MAKER_ORDERS_ROLE, msg.sender),
1716             "MintedExchange: no permission to call match maker order"
1717         );
1718         _;
1719     }
1720 
1721     /**
1722      * @notice Constructor
1723      * @param _currencyManager currency manager address
1724      * @param _executionManager execution manager address
1725      * @param _royaltyFeeManager royalty fee manager address
1726      * @param _WETH wrapped ether address (for other chains, use wrapped native asset)
1727      * @param _protocolFeeRecipient protocol fee recipient
1728      */
1729     constructor(
1730         address _currencyManager,
1731         address _executionManager,
1732         address _royaltyFeeManager,
1733         address _WETH,
1734         address _protocolFeeRecipient
1735     ) {
1736         require(_currencyManager != address(0), "_currencyManager is address(0)");
1737         require(_executionManager != address(0), "_executionManager is address(0)");
1738         require(_royaltyFeeManager != address(0), "_royaltyFeeManager is address(0)");
1739         require(_WETH != address(0), "_WETH is address(0)");
1740 
1741         // Calculate the domain separator
1742         DOMAIN_SEPARATOR = keccak256(
1743             abi.encode(
1744                 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f, // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
1745                 0xbc11948365c354ad12f7242cbad9cd271ba4e4834d635121cd5c915109927d7b, // keccak256("MintedExchange")
1746                 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6, // keccak256(bytes("1")) for versionId = 1
1747                 block.chainid,
1748                 address(this)
1749             )
1750         );
1751 
1752         currencyManager = ICurrencyManager(_currencyManager);
1753         executionManager = IExecutionManager(_executionManager);
1754         royaltyFeeManager = IRoyaltyFeeManager(_royaltyFeeManager);
1755         WETH = _WETH;
1756         protocolFeeRecipient = _protocolFeeRecipient;
1757 
1758         // contract owner will be able to grant role to other
1759         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1760     }
1761 
1762     /**
1763      * @notice Cancel all pending orders for a sender
1764      * @param minNonce minimum user nonce
1765      */
1766     function cancelAllOrdersForSender(uint256 minNonce) external {
1767         require(minNonce > userMinOrderNonce[msg.sender], "Cancel: Order nonce lower than current");
1768         require(minNonce < userMinOrderNonce[msg.sender] + 500000, "Cancel: Cannot cancel more orders");
1769         userMinOrderNonce[msg.sender] = minNonce;
1770 
1771         emit CancelAllOrders(msg.sender, minNonce);
1772     }
1773 
1774     /**
1775      * @notice Cancel maker orders
1776      * @param orderNonces array of order nonces
1777      */
1778     function cancelMultipleMakerOrders(uint256[] calldata orderNonces) external {
1779         require(orderNonces.length > 0, "Cancel: Cannot be empty");
1780 
1781         for (uint256 i = 0; i < orderNonces.length; i++) {
1782             require(
1783                 orderNonces[i] >= userMinOrderNonce[msg.sender],
1784                 "Cancel: Order nonce lower than current"
1785             );
1786             _isUserOrderNonceExecutedOrCancelled[msg.sender][orderNonces[i]] = true;
1787         }
1788 
1789         emit CancelMultipleOrders(msg.sender, orderNonces);
1790     }
1791 
1792     /**
1793      * @notice Match ask with a taker bid order using ETH
1794      * @param takerBid taker bid order
1795      * @param makerAsk maker ask order
1796      */
1797     function matchAskWithTakerBidUsingETHAndWETH(
1798         OrderTypes.TakerOrder calldata takerBid,
1799         OrderTypes.MakerOrder calldata makerAsk
1800     ) external payable override nonReentrant {
1801         require((makerAsk.isOrderAsk) && (!takerBid.isOrderAsk), "Order: Wrong sides");
1802         require(makerAsk.currency == WETH, "Order: Currency must be WETH");
1803         require(msg.sender == takerBid.taker, "Order: Taker must be the sender");
1804 
1805         // If not enough ETH to cover the price, use WETH
1806         if (takerBid.price > msg.value) {
1807             IERC20(WETH).safeTransferFrom(msg.sender, address(this), (takerBid.price - msg.value));
1808         } else {
1809             require(takerBid.price == msg.value, "Order: Msg.value too high");
1810         }
1811 
1812         // Wrap ETH sent to this contract
1813         IWETH(WETH).deposit{value: msg.value}();
1814 
1815         // Check the maker ask order
1816         bytes32 askHash = makerAsk.hash();
1817         _validateOrder(makerAsk, askHash);
1818 
1819         // Retrieve execution parameters
1820         (bool isExecutionValid, uint256 tokenId, uint256 amount) = IExecutionStrategy(makerAsk.strategy)
1821             .canExecuteTakerBid(takerBid, makerAsk);
1822 
1823         require(isExecutionValid, "Strategy: Execution invalid");
1824 
1825         // Update maker ask order status to true (prevents replay)
1826         _isUserOrderNonceExecutedOrCancelled[makerAsk.signer][makerAsk.nonce] = true;
1827 
1828         // Execution part 1/2
1829         _transferFeesAndFundsWithWETH(
1830             makerAsk.strategy,
1831             makerAsk.collection,
1832             tokenId,
1833             makerAsk.signer,
1834             takerBid.price,
1835             makerAsk.minPercentageToAsk
1836         );
1837 
1838         // Execution part 2/2
1839         _transferNonFungibleToken(makerAsk.collection, makerAsk.signer, takerBid.taker, tokenId, amount);
1840 
1841         emit TakerBid(
1842             askHash,
1843             makerAsk.nonce,
1844             takerBid.taker,
1845             makerAsk.signer,
1846             makerAsk.strategy,
1847             makerAsk.currency,
1848             makerAsk.collection,
1849             tokenId,
1850             amount,
1851             takerBid.price
1852         );
1853     }
1854 
1855     /**
1856      * @notice Match a takerBid with a matchAsk
1857      * @param takerBid taker bid order
1858      * @param makerAsk maker ask order
1859      */
1860     function matchAskWithTakerBid(
1861         OrderTypes.TakerOrder calldata takerBid,
1862         OrderTypes.MakerOrder calldata makerAsk
1863     ) external override nonReentrant {
1864         require((makerAsk.isOrderAsk) && (!takerBid.isOrderAsk), "Order: Wrong sides");
1865         require(msg.sender == takerBid.taker, "Order: Taker must be the sender");
1866 
1867         // Check the maker ask order
1868         bytes32 askHash = makerAsk.hash();
1869         _validateOrder(makerAsk, askHash);
1870 
1871         (bool isExecutionValid, uint256 tokenId, uint256 amount) = IExecutionStrategy(makerAsk.strategy)
1872             .canExecuteTakerBid(takerBid, makerAsk);
1873 
1874         require(isExecutionValid, "Strategy: Execution invalid");
1875 
1876         // Update maker ask order status to true (prevents replay)
1877         _isUserOrderNonceExecutedOrCancelled[makerAsk.signer][makerAsk.nonce] = true;
1878 
1879         // Execution part 1/2
1880         _transferFeesAndFunds(
1881             makerAsk.strategy,
1882             makerAsk.collection,
1883             tokenId,
1884             makerAsk.currency,
1885             msg.sender,
1886             makerAsk.signer,
1887             takerBid.price,
1888             makerAsk.minPercentageToAsk
1889         );
1890 
1891         // Execution part 2/2
1892         _transferNonFungibleToken(makerAsk.collection, makerAsk.signer, takerBid.taker, tokenId, amount);
1893 
1894         emit TakerBid(
1895             askHash,
1896             makerAsk.nonce,
1897             takerBid.taker,
1898             makerAsk.signer,
1899             makerAsk.strategy,
1900             makerAsk.currency,
1901             makerAsk.collection,
1902             tokenId,
1903             amount,
1904             takerBid.price
1905         );
1906     }
1907 
1908     /**
1909      * @notice Match a takerAsk with a makerBid
1910      * @param takerAsk taker ask order
1911      * @param makerBid maker bid order
1912      */
1913     function matchBidWithTakerAsk(
1914         OrderTypes.TakerOrder calldata takerAsk,
1915         OrderTypes.MakerOrder calldata makerBid
1916     ) external override nonReentrant {
1917         require((!makerBid.isOrderAsk) && (takerAsk.isOrderAsk), "Order: Wrong sides");
1918         require(msg.sender == takerAsk.taker, "Order: Taker must be the sender");
1919 
1920         // Check the maker bid order
1921         bytes32 bidHash = makerBid.hash();
1922         _validateOrder(makerBid, bidHash);
1923 
1924         (bool isExecutionValid, uint256 tokenId, uint256 amount) = IExecutionStrategy(makerBid.strategy)
1925             .canExecuteTakerAsk(takerAsk, makerBid);
1926 
1927         require(isExecutionValid, "Strategy: Execution invalid");
1928 
1929         // Update maker bid order status to true (prevents replay)
1930         _isUserOrderNonceExecutedOrCancelled[makerBid.signer][makerBid.nonce] = true;
1931 
1932         // Execution part 1/2
1933         _transferNonFungibleToken(makerBid.collection, msg.sender, makerBid.signer, tokenId, amount);
1934 
1935         // Execution part 2/2
1936         _transferFeesAndFunds(
1937             makerBid.strategy,
1938             makerBid.collection,
1939             tokenId,
1940             makerBid.currency,
1941             makerBid.signer,
1942             takerAsk.taker,
1943             takerAsk.price,
1944             takerAsk.minPercentageToAsk
1945         );
1946 
1947         emit TakerAsk(
1948             bidHash,
1949             makerBid.nonce,
1950             takerAsk.taker,
1951             makerBid.signer,
1952             makerBid.strategy,
1953             makerBid.currency,
1954             makerBid.collection,
1955             tokenId,
1956             amount,
1957             takerAsk.price
1958         );
1959     }
1960 
1961     /**
1962      * @notice match a MakerBid with MakerAsk order
1963      * @dev only callable by whitelisted address
1964      * @param makerBid maker bid order
1965      * @param makerAsk maker ask order
1966      */
1967     function matchMakerOrders(
1968         OrderTypes.MakerOrder calldata makerBid,
1969         OrderTypes.MakerOrder calldata makerAsk
1970     ) external override nonReentrant whenNotPaused onlyMatchMakerRoleOrNotBeta {
1971         require((!makerBid.isOrderAsk) && (makerAsk.isOrderAsk), "Order: Wrong sides");
1972 
1973         // Check the maker bid and ask order
1974         _validateOrder(makerBid, makerBid.hash());
1975         _validateOrder(makerAsk, makerAsk.hash());
1976 
1977         // For this case both order must point to the same strategy
1978         require(makerBid.strategy == makerAsk.strategy, "Order: Both strategy must be same");
1979         (bool isExecutionValid, uint256 tokenId, uint256 amount) = IExecutionStrategy(makerAsk.strategy)
1980             .canExecuteMakerOrder(makerBid, makerAsk);
1981 
1982         require(isExecutionValid, "Strategy: Execution invalid");
1983 
1984         // Update maker order status to true (prevents replay)
1985         _isUserOrderNonceExecutedOrCancelled[makerAsk.signer][makerAsk.nonce] = true;
1986         _isUserOrderNonceExecutedOrCancelled[makerBid.signer][makerBid.nonce] = true;
1987 
1988         // Execution part 1/2
1989         _transferFeesAndFunds(
1990             makerAsk.strategy,
1991             makerAsk.collection,
1992             tokenId,
1993             makerAsk.currency,
1994             makerBid.signer,
1995             makerAsk.signer,
1996             makerBid.price,
1997             makerAsk.minPercentageToAsk
1998         );
1999 
2000         // Execution part 2/2
2001         _transferNonFungibleToken(makerAsk.collection, makerAsk.signer, makerBid.signer, tokenId, amount);
2002 
2003         emit MakerMatch(
2004             makerAsk.hash(),
2005             makerBid.nonce,
2006             makerAsk.nonce,
2007             makerBid.signer,
2008             makerAsk.signer,
2009             makerAsk.strategy,
2010             makerAsk.currency,
2011             makerAsk.collection,
2012             tokenId,
2013             amount,
2014             makerBid.price
2015         );
2016     }
2017 
2018     /**
2019      * @notice Update currency manager
2020      * @param _currencyManager new currency manager address
2021      */
2022     function updateCurrencyManager(address _currencyManager) external onlyRole(DEFAULT_ADMIN_ROLE) {
2023         require(_currencyManager != address(0), "Owner: Cannot be null address");
2024         currencyManager = ICurrencyManager(_currencyManager);
2025         emit NewCurrencyManager(_currencyManager);
2026     }
2027 
2028     /**
2029      * @notice Update execution manager
2030      * @param _executionManager new execution manager address
2031      */
2032     function updateExecutionManager(address _executionManager) external onlyRole(DEFAULT_ADMIN_ROLE) {
2033         require(_executionManager != address(0), "Owner: Cannot be null address");
2034         executionManager = IExecutionManager(_executionManager);
2035         emit NewExecutionManager(_executionManager);
2036     }
2037 
2038     /**
2039      * @notice Update protocol fee and recipient
2040      * @param _protocolFeeRecipient new recipient for protocol fees
2041      */
2042     function updateProtocolFeeRecipient(address _protocolFeeRecipient) external onlyRole(DEFAULT_ADMIN_ROLE) {
2043         protocolFeeRecipient = _protocolFeeRecipient;
2044         emit NewProtocolFeeRecipient(_protocolFeeRecipient);
2045     }
2046 
2047     /**
2048      * @notice Update royalty fee manager
2049      * @param _royaltyFeeManager new fee manager address
2050      */
2051     function updateRoyaltyFeeManager(address _royaltyFeeManager) external onlyRole(DEFAULT_ADMIN_ROLE) {
2052         require(_royaltyFeeManager != address(0), "Owner: Cannot be null address");
2053         royaltyFeeManager = IRoyaltyFeeManager(_royaltyFeeManager);
2054         emit NewRoyaltyFeeManager(_royaltyFeeManager);
2055     }
2056 
2057     /**
2058      * @notice Update transfer selector NFT
2059      * @param _transferSelectorNFT new transfer selector address
2060      */
2061     function updateTransferSelectorNFT(address _transferSelectorNFT) external onlyRole(DEFAULT_ADMIN_ROLE) {
2062         require(_transferSelectorNFT != address(0), "Owner: Cannot be null address");
2063         transferSelectorNFT = ITransferSelectorNFT(_transferSelectorNFT);
2064 
2065         emit NewTransferSelectorNFT(_transferSelectorNFT);
2066     }
2067 
2068     /**
2069      * @notice Pause the contract. Revert if already paused.
2070      */
2071     function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
2072         _pause();
2073     }
2074 
2075     /**
2076      * @notice Unpause the contract. Revert if already unpaused.
2077      */
2078     function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
2079         _unpause();
2080     }
2081 
2082     /**
2083      * @notice toggle beta mode. If beta is false, it will allow all address to call matchMakerOrders
2084      */
2085     function toggleMatchMakerOrderBeta() external onlyRole(DEFAULT_ADMIN_ROLE) {
2086         isMatchMakerOrderBeta = !isMatchMakerOrderBeta;
2087     }
2088 
2089     /**
2090      * @notice Check whether user order nonce is executed or cancelled
2091      * @param user address of user
2092      * @param orderNonce nonce of the order
2093      */
2094     function isUserOrderNonceExecutedOrCancelled(address user, uint256 orderNonce)
2095         external
2096         view
2097         returns (bool)
2098     {
2099         return _isUserOrderNonceExecutedOrCancelled[user][orderNonce];
2100     }
2101 
2102     /**
2103      * @notice Transfer fees and funds to royalty recipient, protocol, and seller
2104      * @param strategy address of the execution strategy
2105      * @param collection non fungible token address for the transfer
2106      * @param tokenId tokenId
2107      * @param currency currency being used for the purchase (e.g., WETH/USDC)
2108      * @param from sender of the funds
2109      * @param to seller's recipient
2110      * @param amount amount being transferred (in currency)
2111      * @param minPercentageToAsk minimum percentage of the gross amount that goes to ask
2112      */
2113     function _transferFeesAndFunds(
2114         address strategy,
2115         address collection,
2116         uint256 tokenId,
2117         address currency,
2118         address from,
2119         address to,
2120         uint256 amount,
2121         uint256 minPercentageToAsk
2122     ) internal {
2123         // Initialize the final amount that is transferred to seller
2124         uint256 finalSellerAmount = amount;
2125 
2126         // 1. Protocol fee
2127         {
2128             uint256 protocolFeeAmount = _calculateProtocolFee(strategy, amount);
2129 
2130             // Check if the protocol fee is different than 0 for this strategy
2131             if ((protocolFeeRecipient != address(0)) && (protocolFeeAmount != 0)) {
2132                 IERC20(currency).safeTransferFrom(from, protocolFeeRecipient, protocolFeeAmount);
2133                 finalSellerAmount -= protocolFeeAmount;
2134             }
2135         }
2136 
2137         // 2. Royalty fee
2138         {
2139             (address royaltyFeeRecipient, uint256 royaltyFeeAmount) = royaltyFeeManager
2140                 .calculateRoyaltyFeeAndGetRecipient(collection, tokenId, amount);
2141 
2142             // Check if there is a royalty fee and that it is different to 0
2143             if ((royaltyFeeRecipient != address(0)) && (royaltyFeeAmount != 0)) {
2144                 IERC20(currency).safeTransferFrom(from, royaltyFeeRecipient, royaltyFeeAmount);
2145                 finalSellerAmount -= royaltyFeeAmount;
2146 
2147                 emit RoyaltyPayment(collection, tokenId, royaltyFeeRecipient, currency, royaltyFeeAmount);
2148             }
2149         }
2150 
2151         require((finalSellerAmount * 10000) >= (minPercentageToAsk * amount), "Fees: Higher than expected");
2152 
2153         // 3. Transfer final amount (post-fees) to seller
2154         {
2155             IERC20(currency).safeTransferFrom(from, to, finalSellerAmount);
2156         }
2157     }
2158 
2159     /**
2160      * @notice Transfer fees and funds to royalty recipient, protocol, and seller
2161      * @param strategy address of the execution strategy
2162      * @param collection non fungible token address for the transfer
2163      * @param tokenId tokenId
2164      * @param to seller's recipient
2165      * @param amount amount being transferred (in currency)
2166      * @param minPercentageToAsk minimum percentage of the gross amount that goes to ask
2167      */
2168     function _transferFeesAndFundsWithWETH(
2169         address strategy,
2170         address collection,
2171         uint256 tokenId,
2172         address to,
2173         uint256 amount,
2174         uint256 minPercentageToAsk
2175     ) internal {
2176         // Initialize the final amount that is transferred to seller
2177         uint256 finalSellerAmount = amount;
2178 
2179         // 1. Protocol fee
2180         {
2181             uint256 protocolFeeAmount = _calculateProtocolFee(strategy, amount);
2182 
2183             // Check if the protocol fee is different than 0 for this strategy
2184             if ((protocolFeeRecipient != address(0)) && (protocolFeeAmount != 0)) {
2185                 IERC20(WETH).safeTransfer(protocolFeeRecipient, protocolFeeAmount);
2186                 finalSellerAmount -= protocolFeeAmount;
2187             }
2188         }
2189 
2190         // 2. Royalty fee
2191         {
2192             (address royaltyFeeRecipient, uint256 royaltyFeeAmount) = royaltyFeeManager
2193                 .calculateRoyaltyFeeAndGetRecipient(collection, tokenId, amount);
2194 
2195             // Check if there is a royalty fee and that it is different to 0
2196             if ((royaltyFeeRecipient != address(0)) && (royaltyFeeAmount != 0)) {
2197                 IERC20(WETH).safeTransfer(royaltyFeeRecipient, royaltyFeeAmount);
2198                 finalSellerAmount -= royaltyFeeAmount;
2199 
2200                 emit RoyaltyPayment(
2201                     collection,
2202                     tokenId,
2203                     royaltyFeeRecipient,
2204                     address(WETH),
2205                     royaltyFeeAmount
2206                 );
2207             }
2208         }
2209 
2210         require((finalSellerAmount * 10000) >= (minPercentageToAsk * amount), "Fees: Higher than expected");
2211 
2212         // 3. Transfer final amount (post-fees) to seller
2213         {
2214             IERC20(WETH).safeTransfer(to, finalSellerAmount);
2215         }
2216     }
2217 
2218     /**
2219      * @notice Transfer NFT
2220      * @param collection address of the token collection
2221      * @param from address of the sender
2222      * @param to address of the recipient
2223      * @param tokenId tokenId
2224      * @param amount amount of tokens (1 for ERC721, 1+ for ERC1155)
2225      * @dev For ERC721, amount is not used
2226      */
2227     function _transferNonFungibleToken(
2228         address collection,
2229         address from,
2230         address to,
2231         uint256 tokenId,
2232         uint256 amount
2233     ) internal {
2234         // Retrieve the transfer manager address
2235         address transferManager = transferSelectorNFT.checkTransferManagerForToken(collection);
2236 
2237         // If no transfer manager found, it returns address(0)
2238         require(transferManager != address(0), "Transfer: No NFT transfer manager available");
2239 
2240         // If one is found, transfer the token
2241         ITransferManagerNFT(transferManager).transferNonFungibleToken(collection, from, to, tokenId, amount);
2242     }
2243 
2244     /**
2245      * @notice Calculate protocol fee for an execution strategy
2246      * @param executionStrategy strategy
2247      * @param amount amount to transfer
2248      */
2249     function _calculateProtocolFee(address executionStrategy, uint256 amount)
2250         internal
2251         view
2252         returns (uint256)
2253     {
2254         uint256 protocolFee = IExecutionStrategy(executionStrategy).viewProtocolFee();
2255         return (protocolFee * amount) / 10000;
2256     }
2257 
2258     /**
2259      * @notice Verify the validity of the maker order
2260      * @param makerOrder maker order
2261      * @param orderHash computed hash for the order
2262      */
2263     function _validateOrder(OrderTypes.MakerOrder calldata makerOrder, bytes32 orderHash) internal view {
2264         // Verify whether order nonce has expired
2265         require(
2266             (!_isUserOrderNonceExecutedOrCancelled[makerOrder.signer][makerOrder.nonce]) &&
2267                 (makerOrder.nonce >= userMinOrderNonce[makerOrder.signer]),
2268             "Order: Matching order expired"
2269         );
2270 
2271         // Verify the signer is not address(0)
2272         require(makerOrder.signer != address(0), "Order: Invalid signer");
2273 
2274         // Verify the amount is not 0
2275         require(makerOrder.amount > 0, "Order: Amount cannot be 0");
2276 
2277         // Verify the validity of the signature
2278         require(
2279             SignatureChecker.verify(
2280                 orderHash,
2281                 makerOrder.signer,
2282                 makerOrder.v,
2283                 makerOrder.r,
2284                 makerOrder.s,
2285                 DOMAIN_SEPARATOR
2286             ),
2287             "Signature: Invalid"
2288         );
2289 
2290         // Verify whether the currency is whitelisted
2291         require(currencyManager.isCurrencyWhitelisted(makerOrder.currency), "Currency: Not whitelisted");
2292 
2293         // Verify whether strategy can be executed
2294         require(executionManager.isStrategyWhitelisted(makerOrder.strategy), "Strategy: Not whitelisted");
2295     }
2296 }