1 pragma solidity ^0.8.9;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
26 
27 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
100 /**
101  * @dev External interface of AccessControl declared to support ERC165 detection.
102  */
103 interface IAccessControl {
104     /**
105      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
106      *
107      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
108      * {RoleAdminChanged} not being emitted signaling this.
109      *
110      * _Available since v3.1._
111      */
112     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
113 
114     /**
115      * @dev Emitted when `account` is granted `role`.
116      *
117      * `sender` is the account that originated the contract call, an admin role
118      * bearer except when using {AccessControl-_setupRole}.
119      */
120     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
121 
122     /**
123      * @dev Emitted when `account` is revoked `role`.
124      *
125      * `sender` is the account that originated the contract call:
126      *   - if using `revokeRole`, it is the admin role bearer
127      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
128      */
129     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
130 
131     /**
132      * @dev Returns `true` if `account` has been granted `role`.
133      */
134     function hasRole(bytes32 role, address account) external view returns (bool);
135 
136     /**
137      * @dev Returns the admin role that controls `role`. See {grantRole} and
138      * {revokeRole}.
139      *
140      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
141      */
142     function getRoleAdmin(bytes32 role) external view returns (bytes32);
143 
144     /**
145      * @dev Grants `role` to `account`.
146      *
147      * If `account` had not been already granted `role`, emits a {RoleGranted}
148      * event.
149      *
150      * Requirements:
151      *
152      * - the caller must have ``role``'s admin role.
153      */
154     function grantRole(bytes32 role, address account) external;
155 
156     /**
157      * @dev Revokes `role` from `account`.
158      *
159      * If `account` had been granted `role`, emits a {RoleRevoked} event.
160      *
161      * Requirements:
162      *
163      * - the caller must have ``role``'s admin role.
164      */
165     function revokeRole(bytes32 role, address account) external;
166 
167     /**
168      * @dev Revokes `role` from the calling account.
169      *
170      * Roles are often managed via {grantRole} and {revokeRole}: this function's
171      * purpose is to provide a mechanism for accounts to lose their privileges
172      * if they are compromised (such as when a trusted device is misplaced).
173      *
174      * If the calling account had been granted `role`, emits a {RoleRevoked}
175      * event.
176      *
177      * Requirements:
178      *
179      * - the caller must be `account`.
180      */
181     function renounceRole(bytes32 role, address account) external;
182 }
183 
184 
185 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
186 /**
187  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
188  */
189 interface IAccessControlEnumerable is IAccessControl {
190     /**
191      * @dev Returns one of the accounts that have `role`. `index` must be a
192      * value between 0 and {getRoleMemberCount}, non-inclusive.
193      *
194      * Role bearers are not sorted in any particular way, and their ordering may
195      * change at any point.
196      *
197      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
198      * you perform all queries on the same block. See the following
199      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
200      * for more information.
201      */
202     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
203 
204     /**
205      * @dev Returns the number of accounts that have `role`. Can be used
206      * together with {getRoleMember} to enumerate all bearers of a role.
207      */
208     function getRoleMemberCount(bytes32 role) external view returns (uint256);
209 }
210 
211 
212 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
213 /**
214  * @dev String operations.
215  */
216 library Strings {
217     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
218 
219     /**
220      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
221      */
222     function toString(uint256 value) internal pure returns (string memory) {
223         // Inspired by OraclizeAPI's implementation - MIT licence
224         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
225 
226         if (value == 0) {
227             return "0";
228         }
229         uint256 temp = value;
230         uint256 digits;
231         while (temp != 0) {
232             digits++;
233             temp /= 10;
234         }
235         bytes memory buffer = new bytes(digits);
236         while (value != 0) {
237             digits -= 1;
238             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
239             value /= 10;
240         }
241         return string(buffer);
242     }
243 
244     /**
245      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
246      */
247     function toHexString(uint256 value) internal pure returns (string memory) {
248         if (value == 0) {
249             return "0x00";
250         }
251         uint256 temp = value;
252         uint256 length = 0;
253         while (temp != 0) {
254             length++;
255             temp >>= 8;
256         }
257         return toHexString(value, length);
258     }
259 
260     /**
261      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
262      */
263     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
264         bytes memory buffer = new bytes(2 * length + 2);
265         buffer[0] = "0";
266         buffer[1] = "x";
267         for (uint256 i = 2 * length + 1; i > 1; --i) {
268             buffer[i] = _HEX_SYMBOLS[value & 0xf];
269             value >>= 4;
270         }
271         require(value == 0, "Strings: hex length insufficient");
272         return string(buffer);
273     }
274 }
275 
276 
277 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
278 /**
279  * @dev Interface of the ERC165 standard, as defined in the
280  * https://eips.ethereum.org/EIPS/eip-165[EIP].
281  *
282  * Implementers can declare support of contract interfaces, which can then be
283  * queried by others ({ERC165Checker}).
284  *
285  * For an implementation, see {ERC165}.
286  */
287 interface IERC165 {
288     /**
289      * @dev Returns true if this contract implements the interface defined by
290      * `interfaceId`. See the corresponding
291      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
292      * to learn more about how these ids are created.
293      *
294      * This function call must use less than 30 000 gas.
295      */
296     function supportsInterface(bytes4 interfaceId) external view returns (bool);
297 }
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
301 /**
302  * @dev Implementation of the {IERC165} interface.
303  *
304  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
305  * for the additional interface id that will be supported. For example:
306  *
307  * ```solidity
308  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
309  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
310  * }
311  * ```
312  *
313  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
314  */
315 abstract contract ERC165 is IERC165 {
316     /**
317      * @dev See {IERC165-supportsInterface}.
318      */
319     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
320         return interfaceId == type(IERC165).interfaceId;
321     }
322 }
323 
324 
325 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
326 /**
327  * @dev Contract module that allows children to implement role-based access
328  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
329  * members except through off-chain means by accessing the contract event logs. Some
330  * applications may benefit from on-chain enumerability, for those cases see
331  * {AccessControlEnumerable}.
332  *
333  * Roles are referred to by their `bytes32` identifier. These should be exposed
334  * in the external API and be unique. The best way to achieve this is by
335  * using `public constant` hash digests:
336  *
337  * ```
338  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
339  * ```
340  *
341  * Roles can be used to represent a set of permissions. To restrict access to a
342  * function call, use {hasRole}:
343  *
344  * ```
345  * function foo() public {
346  *     require(hasRole(MY_ROLE, msg.sender));
347  *     ...
348  * }
349  * ```
350  *
351  * Roles can be granted and revoked dynamically via the {grantRole} and
352  * {revokeRole} functions. Each role has an associated admin role, and only
353  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
354  *
355  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
356  * that only accounts with this role will be able to grant or revoke other
357  * roles. More complex role relationships can be created by using
358  * {_setRoleAdmin}.
359  *
360  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
361  * grant and revoke this role. Extra precautions should be taken to secure
362  * accounts that have been granted it.
363  */
364 abstract contract AccessControl is Context, IAccessControl, ERC165 {
365     struct RoleData {
366         mapping(address => bool) members;
367         bytes32 adminRole;
368     }
369 
370     mapping(bytes32 => RoleData) private _roles;
371 
372     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
373 
374     /**
375      * @dev Modifier that checks that an account has a specific role. Reverts
376      * with a standardized message including the required role.
377      *
378      * The format of the revert reason is given by the following regular expression:
379      *
380      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
381      *
382      * _Available since v4.1._
383      */
384     modifier onlyRole(bytes32 role) {
385         _checkRole(role, _msgSender());
386         _;
387     }
388 
389     /**
390      * @dev See {IERC165-supportsInterface}.
391      */
392     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
393         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
394     }
395 
396     /**
397      * @dev Returns `true` if `account` has been granted `role`.
398      */
399     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
400         return _roles[role].members[account];
401     }
402 
403     /**
404      * @dev Revert with a standard message if `account` is missing `role`.
405      *
406      * The format of the revert reason is given by the following regular expression:
407      *
408      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
409      */
410     function _checkRole(bytes32 role, address account) internal view virtual {
411         if (!hasRole(role, account)) {
412             revert(
413                 string(
414                     abi.encodePacked(
415                         "AccessControl: account ",
416                         Strings.toHexString(uint160(account), 20),
417                         " is missing role ",
418                         Strings.toHexString(uint256(role), 32)
419                     )
420                 )
421             );
422         }
423     }
424 
425     /**
426      * @dev Returns the admin role that controls `role`. See {grantRole} and
427      * {revokeRole}.
428      *
429      * To change a role's admin, use {_setRoleAdmin}.
430      */
431     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
432         return _roles[role].adminRole;
433     }
434 
435     /**
436      * @dev Grants `role` to `account`.
437      *
438      * If `account` had not been already granted `role`, emits a {RoleGranted}
439      * event.
440      *
441      * Requirements:
442      *
443      * - the caller must have ``role``'s admin role.
444      */
445     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
446         _grantRole(role, account);
447     }
448 
449     /**
450      * @dev Revokes `role` from `account`.
451      *
452      * If `account` had been granted `role`, emits a {RoleRevoked} event.
453      *
454      * Requirements:
455      *
456      * - the caller must have ``role``'s admin role.
457      */
458     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
459         _revokeRole(role, account);
460     }
461 
462     /**
463      * @dev Revokes `role` from the calling account.
464      *
465      * Roles are often managed via {grantRole} and {revokeRole}: this function's
466      * purpose is to provide a mechanism for accounts to lose their privileges
467      * if they are compromised (such as when a trusted device is misplaced).
468      *
469      * If the calling account had been revoked `role`, emits a {RoleRevoked}
470      * event.
471      *
472      * Requirements:
473      *
474      * - the caller must be `account`.
475      */
476     function renounceRole(bytes32 role, address account) public virtual override {
477         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
478 
479         _revokeRole(role, account);
480     }
481 
482     /**
483      * @dev Grants `role` to `account`.
484      *
485      * If `account` had not been already granted `role`, emits a {RoleGranted}
486      * event. Note that unlike {grantRole}, this function doesn't perform any
487      * checks on the calling account.
488      *
489      * [WARNING]
490      * ====
491      * This function should only be called from the constructor when setting
492      * up the initial roles for the system.
493      *
494      * Using this function in any other way is effectively circumventing the admin
495      * system imposed by {AccessControl}.
496      * ====
497      *
498      * NOTE: This function is deprecated in favor of {_grantRole}.
499      */
500     function _setupRole(bytes32 role, address account) internal virtual {
501         _grantRole(role, account);
502     }
503 
504     /**
505      * @dev Sets `adminRole` as ``role``'s admin role.
506      *
507      * Emits a {RoleAdminChanged} event.
508      */
509     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
510         bytes32 previousAdminRole = getRoleAdmin(role);
511         _roles[role].adminRole = adminRole;
512         emit RoleAdminChanged(role, previousAdminRole, adminRole);
513     }
514 
515     /**
516      * @dev Grants `role` to `account`.
517      *
518      * Internal function without access restriction.
519      */
520     function _grantRole(bytes32 role, address account) internal virtual {
521         if (!hasRole(role, account)) {
522             _roles[role].members[account] = true;
523             emit RoleGranted(role, account, _msgSender());
524         }
525     }
526 
527     /**
528      * @dev Revokes `role` from `account`.
529      *
530      * Internal function without access restriction.
531      */
532     function _revokeRole(bytes32 role, address account) internal virtual {
533         if (hasRole(role, account)) {
534             _roles[role].members[account] = false;
535             emit RoleRevoked(role, account, _msgSender());
536         }
537     }
538 }
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
542 /**
543  * @dev Library for managing
544  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
545  * types.
546  *
547  * Sets have the following properties:
548  *
549  * - Elements are added, removed, and checked for existence in constant time
550  * (O(1)).
551  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
552  *
553  * ```
554  * contract Example {
555  *     // Add the library methods
556  *     using EnumerableSet for EnumerableSet.AddressSet;
557  *
558  *     // Declare a set state variable
559  *     EnumerableSet.AddressSet private mySet;
560  * }
561  * ```
562  *
563  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
564  * and `uint256` (`UintSet`) are supported.
565  */
566 library EnumerableSet {
567     // To implement this library for multiple types with as little code
568     // repetition as possible, we write it in terms of a generic Set type with
569     // bytes32 values.
570     // The Set implementation uses private functions, and user-facing
571     // implementations (such as AddressSet) are just wrappers around the
572     // underlying Set.
573     // This means that we can only create new EnumerableSets for types that fit
574     // in bytes32.
575 
576     struct Set {
577         // Storage of set values
578         bytes32[] _values;
579         // Position of the value in the `values` array, plus 1 because index 0
580         // means a value is not in the set.
581         mapping(bytes32 => uint256) _indexes;
582     }
583 
584     /**
585      * @dev Add a value to a set. O(1).
586      *
587      * Returns true if the value was added to the set, that is if it was not
588      * already present.
589      */
590     function _add(Set storage set, bytes32 value) private returns (bool) {
591         if (!_contains(set, value)) {
592             set._values.push(value);
593             // The value is stored at length-1, but we add 1 to all indexes
594             // and use 0 as a sentinel value
595             set._indexes[value] = set._values.length;
596             return true;
597         } else {
598             return false;
599         }
600     }
601 
602     /**
603      * @dev Removes a value from a set. O(1).
604      *
605      * Returns true if the value was removed from the set, that is if it was
606      * present.
607      */
608     function _remove(Set storage set, bytes32 value) private returns (bool) {
609         // We read and store the value's index to prevent multiple reads from the same storage slot
610         uint256 valueIndex = set._indexes[value];
611 
612         if (valueIndex != 0) {
613             // Equivalent to contains(set, value)
614             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
615             // the array, and then remove the last element (sometimes called as 'swap and pop').
616             // This modifies the order of the array, as noted in {at}.
617 
618             uint256 toDeleteIndex = valueIndex - 1;
619             uint256 lastIndex = set._values.length - 1;
620 
621             if (lastIndex != toDeleteIndex) {
622                 bytes32 lastvalue = set._values[lastIndex];
623 
624                 // Move the last value to the index where the value to delete is
625                 set._values[toDeleteIndex] = lastvalue;
626                 // Update the index for the moved value
627                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
628             }
629 
630             // Delete the slot where the moved value was stored
631             set._values.pop();
632 
633             // Delete the index for the deleted slot
634             delete set._indexes[value];
635 
636             return true;
637         } else {
638             return false;
639         }
640     }
641 
642     /**
643      * @dev Returns true if the value is in the set. O(1).
644      */
645     function _contains(Set storage set, bytes32 value) private view returns (bool) {
646         return set._indexes[value] != 0;
647     }
648 
649     /**
650      * @dev Returns the number of values on the set. O(1).
651      */
652     function _length(Set storage set) private view returns (uint256) {
653         return set._values.length;
654     }
655 
656     /**
657      * @dev Returns the value stored at position `index` in the set. O(1).
658      *
659      * Note that there are no guarantees on the ordering of values inside the
660      * array, and it may change when more values are added or removed.
661      *
662      * Requirements:
663      *
664      * - `index` must be strictly less than {length}.
665      */
666     function _at(Set storage set, uint256 index) private view returns (bytes32) {
667         return set._values[index];
668     }
669 
670     /**
671      * @dev Return the entire set in an array
672      *
673      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
674      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
675      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
676      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
677      */
678     function _values(Set storage set) private view returns (bytes32[] memory) {
679         return set._values;
680     }
681 
682     // Bytes32Set
683 
684     struct Bytes32Set {
685         Set _inner;
686     }
687 
688     /**
689      * @dev Add a value to a set. O(1).
690      *
691      * Returns true if the value was added to the set, that is if it was not
692      * already present.
693      */
694     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
695         return _add(set._inner, value);
696     }
697 
698     /**
699      * @dev Removes a value from a set. O(1).
700      *
701      * Returns true if the value was removed from the set, that is if it was
702      * present.
703      */
704     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
705         return _remove(set._inner, value);
706     }
707 
708     /**
709      * @dev Returns true if the value is in the set. O(1).
710      */
711     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
712         return _contains(set._inner, value);
713     }
714 
715     /**
716      * @dev Returns the number of values in the set. O(1).
717      */
718     function length(Bytes32Set storage set) internal view returns (uint256) {
719         return _length(set._inner);
720     }
721 
722     /**
723      * @dev Returns the value stored at position `index` in the set. O(1).
724      *
725      * Note that there are no guarantees on the ordering of values inside the
726      * array, and it may change when more values are added or removed.
727      *
728      * Requirements:
729      *
730      * - `index` must be strictly less than {length}.
731      */
732     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
733         return _at(set._inner, index);
734     }
735 
736     /**
737      * @dev Return the entire set in an array
738      *
739      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
740      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
741      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
742      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
743      */
744     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
745         return _values(set._inner);
746     }
747 
748     // AddressSet
749 
750     struct AddressSet {
751         Set _inner;
752     }
753 
754     /**
755      * @dev Add a value to a set. O(1).
756      *
757      * Returns true if the value was added to the set, that is if it was not
758      * already present.
759      */
760     function add(AddressSet storage set, address value) internal returns (bool) {
761         return _add(set._inner, bytes32(uint256(uint160(value))));
762     }
763 
764     /**
765      * @dev Removes a value from a set. O(1).
766      *
767      * Returns true if the value was removed from the set, that is if it was
768      * present.
769      */
770     function remove(AddressSet storage set, address value) internal returns (bool) {
771         return _remove(set._inner, bytes32(uint256(uint160(value))));
772     }
773 
774     /**
775      * @dev Returns true if the value is in the set. O(1).
776      */
777     function contains(AddressSet storage set, address value) internal view returns (bool) {
778         return _contains(set._inner, bytes32(uint256(uint160(value))));
779     }
780 
781     /**
782      * @dev Returns the number of values in the set. O(1).
783      */
784     function length(AddressSet storage set) internal view returns (uint256) {
785         return _length(set._inner);
786     }
787 
788     /**
789      * @dev Returns the value stored at position `index` in the set. O(1).
790      *
791      * Note that there are no guarantees on the ordering of values inside the
792      * array, and it may change when more values are added or removed.
793      *
794      * Requirements:
795      *
796      * - `index` must be strictly less than {length}.
797      */
798     function at(AddressSet storage set, uint256 index) internal view returns (address) {
799         return address(uint160(uint256(_at(set._inner, index))));
800     }
801 
802     /**
803      * @dev Return the entire set in an array
804      *
805      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
806      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
807      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
808      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
809      */
810     function values(AddressSet storage set) internal view returns (address[] memory) {
811         bytes32[] memory store = _values(set._inner);
812         address[] memory result;
813 
814         assembly {
815             result := store
816         }
817 
818         return result;
819     }
820 
821     // UintSet
822 
823     struct UintSet {
824         Set _inner;
825     }
826 
827     /**
828      * @dev Add a value to a set. O(1).
829      *
830      * Returns true if the value was added to the set, that is if it was not
831      * already present.
832      */
833     function add(UintSet storage set, uint256 value) internal returns (bool) {
834         return _add(set._inner, bytes32(value));
835     }
836 
837     /**
838      * @dev Removes a value from a set. O(1).
839      *
840      * Returns true if the value was removed from the set, that is if it was
841      * present.
842      */
843     function remove(UintSet storage set, uint256 value) internal returns (bool) {
844         return _remove(set._inner, bytes32(value));
845     }
846 
847     /**
848      * @dev Returns true if the value is in the set. O(1).
849      */
850     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
851         return _contains(set._inner, bytes32(value));
852     }
853 
854     /**
855      * @dev Returns the number of values on the set. O(1).
856      */
857     function length(UintSet storage set) internal view returns (uint256) {
858         return _length(set._inner);
859     }
860 
861     /**
862      * @dev Returns the value stored at position `index` in the set. O(1).
863      *
864      * Note that there are no guarantees on the ordering of values inside the
865      * array, and it may change when more values are added or removed.
866      *
867      * Requirements:
868      *
869      * - `index` must be strictly less than {length}.
870      */
871     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
872         return uint256(_at(set._inner, index));
873     }
874 
875     /**
876      * @dev Return the entire set in an array
877      *
878      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
879      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
880      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
881      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
882      */
883     function values(UintSet storage set) internal view returns (uint256[] memory) {
884         bytes32[] memory store = _values(set._inner);
885         uint256[] memory result;
886 
887         assembly {
888             result := store
889         }
890 
891         return result;
892     }
893 }
894 
895 
896 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
897 /**
898  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
899  */
900 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
901     using EnumerableSet for EnumerableSet.AddressSet;
902 
903     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
904 
905     /**
906      * @dev See {IERC165-supportsInterface}.
907      */
908     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
909         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
910     }
911 
912     /**
913      * @dev Returns one of the accounts that have `role`. `index` must be a
914      * value between 0 and {getRoleMemberCount}, non-inclusive.
915      *
916      * Role bearers are not sorted in any particular way, and their ordering may
917      * change at any point.
918      *
919      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
920      * you perform all queries on the same block. See the following
921      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
922      * for more information.
923      */
924     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
925         return _roleMembers[role].at(index);
926     }
927 
928     /**
929      * @dev Returns the number of accounts that have `role`. Can be used
930      * together with {getRoleMember} to enumerate all bearers of a role.
931      */
932     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
933         return _roleMembers[role].length();
934     }
935 
936     /**
937      * @dev Overload {_grantRole} to track enumerable memberships
938      */
939     function _grantRole(bytes32 role, address account) internal virtual override {
940         super._grantRole(role, account);
941         _roleMembers[role].add(account);
942     }
943 
944     /**
945      * @dev Overload {_revokeRole} to track enumerable memberships
946      */
947     function _revokeRole(bytes32 role, address account) internal virtual override {
948         super._revokeRole(role, account);
949         _roleMembers[role].remove(account);
950     }
951 }
952 
953 
954 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
955 /**
956  * @dev These functions deal with verification of Merkle Trees proofs.
957  *
958  * The proofs can be generated using the JavaScript library
959  * https://github.com/miguelmota/merkletreejs[merkletreejs].
960  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
961  *
962  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
963  */
964 library MerkleProof {
965     /**
966      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
967      * defined by `root`. For this, a `proof` must be provided, containing
968      * sibling hashes on the branch from the leaf to the root of the tree. Each
969      * pair of leaves and each pair of pre-images are assumed to be sorted.
970      */
971     function verify(
972         bytes32[] memory proof,
973         bytes32 root,
974         bytes32 leaf
975     ) internal pure returns (bool) {
976         return processProof(proof, leaf) == root;
977     }
978 
979     /**
980      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
981      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
982      * hash matches the root of the tree. When processing the proof, the pairs
983      * of leafs & pre-images are assumed to be sorted.
984      *
985      * _Available since v4.4._
986      */
987     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
988         bytes32 computedHash = leaf;
989         for (uint256 i = 0; i < proof.length; i++) {
990             bytes32 proofElement = proof[i];
991             if (computedHash <= proofElement) {
992                 // Hash(current computed hash + current element of the proof)
993                 computedHash = _efficientHash(computedHash, proofElement);
994             } else {
995                 // Hash(current element of the proof + current computed hash)
996                 computedHash = _efficientHash(proofElement, computedHash);
997             }
998         }
999         return computedHash;
1000     }
1001 
1002     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1003         assembly {
1004             mstore(0x00, a)
1005             mstore(0x20, b)
1006             value := keccak256(0x00, 0x40)
1007         }
1008     }
1009 }
1010 
1011 
1012 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1013 /**
1014  * @dev Required interface of an ERC721 compliant contract.
1015  */
1016 interface IERC721 is IERC165 {
1017     /**
1018      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1019      */
1020     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1021 
1022     /**
1023      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1024      */
1025     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1026 
1027     /**
1028      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1029      */
1030     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1031 
1032     /**
1033      * @dev Returns the number of tokens in ``owner``'s account.
1034      */
1035     function balanceOf(address owner) external view returns (uint256 balance);
1036 
1037     /**
1038      * @dev Returns the owner of the `tokenId` token.
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must exist.
1043      */
1044     function ownerOf(uint256 tokenId) external view returns (address owner);
1045 
1046     /**
1047      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1048      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1049      *
1050      * Requirements:
1051      *
1052      * - `from` cannot be the zero address.
1053      * - `to` cannot be the zero address.
1054      * - `tokenId` token must exist and be owned by `from`.
1055      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1056      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function safeTransferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) external;
1065 
1066     /**
1067      * @dev Transfers `tokenId` token from `from` to `to`.
1068      *
1069      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1070      *
1071      * Requirements:
1072      *
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      * - `tokenId` token must be owned by `from`.
1076      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function transferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) external;
1085 
1086     /**
1087      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1088      * The approval is cleared when the token is transferred.
1089      *
1090      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1091      *
1092      * Requirements:
1093      *
1094      * - The caller must own the token or be an approved operator.
1095      * - `tokenId` must exist.
1096      *
1097      * Emits an {Approval} event.
1098      */
1099     function approve(address to, uint256 tokenId) external;
1100 
1101     /**
1102      * @dev Returns the account approved for `tokenId` token.
1103      *
1104      * Requirements:
1105      *
1106      * - `tokenId` must exist.
1107      */
1108     function getApproved(uint256 tokenId) external view returns (address operator);
1109 
1110     /**
1111      * @dev Approve or remove `operator` as an operator for the caller.
1112      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1113      *
1114      * Requirements:
1115      *
1116      * - The `operator` cannot be the caller.
1117      *
1118      * Emits an {ApprovalForAll} event.
1119      */
1120     function setApprovalForAll(address operator, bool _approved) external;
1121 
1122     /**
1123      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1124      *
1125      * See {setApprovalForAll}
1126      */
1127     function isApprovedForAll(address owner, address operator) external view returns (bool);
1128 
1129     /**
1130      * @dev Safely transfers `tokenId` token from `from` to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `from` cannot be the zero address.
1135      * - `to` cannot be the zero address.
1136      * - `tokenId` token must exist and be owned by `from`.
1137      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1138      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function safeTransferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId,
1146         bytes calldata data
1147     ) external;
1148 }
1149 
1150 
1151 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1152 /**
1153  * @title ERC721 token receiver interface
1154  * @dev Interface for any contract that wants to support safeTransfers
1155  * from ERC721 asset contracts.
1156  */
1157 interface IERC721Receiver {
1158     /**
1159      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1160      * by `operator` from `from`, this function is called.
1161      *
1162      * It must return its Solidity selector to confirm the token transfer.
1163      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1164      *
1165      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1166      */
1167     function onERC721Received(
1168         address operator,
1169         address from,
1170         uint256 tokenId,
1171         bytes calldata data
1172     ) external returns (bytes4);
1173 }
1174 
1175 
1176 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1177 /**
1178  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1179  * @dev See https://eips.ethereum.org/EIPS/eip-721
1180  */
1181 interface IERC721Metadata is IERC721 {
1182     /**
1183      * @dev Returns the token collection name.
1184      */
1185     function name() external view returns (string memory);
1186 
1187     /**
1188      * @dev Returns the token collection symbol.
1189      */
1190     function symbol() external view returns (string memory);
1191 
1192     /**
1193      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1194      */
1195     function tokenURI(uint256 tokenId) external view returns (string memory);
1196 }
1197 
1198 
1199 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1200 /**
1201  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1202  * @dev See https://eips.ethereum.org/EIPS/eip-721
1203  */
1204 interface IERC721Enumerable is IERC721 {
1205     /**
1206      * @dev Returns the total amount of tokens stored by the contract.
1207      */
1208     function totalSupply() external view returns (uint256);
1209 
1210     /**
1211      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1212      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1213      */
1214     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1215 
1216     /**
1217      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1218      * Use along with {totalSupply} to enumerate all tokens.
1219      */
1220     function tokenByIndex(uint256 index) external view returns (uint256);
1221 }
1222 
1223 
1224 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1225 /**
1226  * @dev Collection of functions related to the address type
1227  */
1228 library Address {
1229     /**
1230      * @dev Returns true if `account` is a contract.
1231      *
1232      * [IMPORTANT]
1233      * ====
1234      * It is unsafe to assume that an address for which this function returns
1235      * false is an externally-owned account (EOA) and not a contract.
1236      *
1237      * Among others, `isContract` will return false for the following
1238      * types of addresses:
1239      *
1240      *  - an externally-owned account
1241      *  - a contract in construction
1242      *  - an address where a contract will be created
1243      *  - an address where a contract lived, but was destroyed
1244      * ====
1245      *
1246      * [IMPORTANT]
1247      * ====
1248      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1249      *
1250      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1251      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1252      * constructor.
1253      * ====
1254      */
1255     function isContract(address account) internal view returns (bool) {
1256         // This method relies on extcodesize/address.code.length, which returns 0
1257         // for contracts in construction, since the code is only stored at the end
1258         // of the constructor execution.
1259 
1260         return account.code.length > 0;
1261     }
1262 
1263     /**
1264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1265      * `recipient`, forwarding all available gas and reverting on errors.
1266      *
1267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1269      * imposed by `transfer`, making them unable to receive funds via
1270      * `transfer`. {sendValue} removes this limitation.
1271      *
1272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1273      *
1274      * IMPORTANT: because control is transferred to `recipient`, care must be
1275      * taken to not create reentrancy vulnerabilities. Consider using
1276      * {ReentrancyGuard} or the
1277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1278      */
1279     function sendValue(address payable recipient, uint256 amount) internal {
1280         require(address(this).balance >= amount, "Address: insufficient balance");
1281 
1282         (bool success, ) = recipient.call{value: amount}("");
1283         require(success, "Address: unable to send value, recipient may have reverted");
1284     }
1285 
1286     /**
1287      * @dev Performs a Solidity function call using a low level `call`. A
1288      * plain `call` is an unsafe replacement for a function call: use this
1289      * function instead.
1290      *
1291      * If `target` reverts with a revert reason, it is bubbled up by this
1292      * function (like regular Solidity function calls).
1293      *
1294      * Returns the raw returned data. To convert to the expected return value,
1295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1296      *
1297      * Requirements:
1298      *
1299      * - `target` must be a contract.
1300      * - calling `target` with `data` must not revert.
1301      *
1302      * _Available since v3.1._
1303      */
1304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1305         return functionCall(target, data, "Address: low-level call failed");
1306     }
1307 
1308     /**
1309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1310      * `errorMessage` as a fallback revert reason when `target` reverts.
1311      *
1312      * _Available since v3.1._
1313      */
1314     function functionCall(
1315         address target,
1316         bytes memory data,
1317         string memory errorMessage
1318     ) internal returns (bytes memory) {
1319         return functionCallWithValue(target, data, 0, errorMessage);
1320     }
1321 
1322     /**
1323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1324      * but also transferring `value` wei to `target`.
1325      *
1326      * Requirements:
1327      *
1328      * - the calling contract must have an ETH balance of at least `value`.
1329      * - the called Solidity function must be `payable`.
1330      *
1331      * _Available since v3.1._
1332      */
1333     function functionCallWithValue(
1334         address target,
1335         bytes memory data,
1336         uint256 value
1337     ) internal returns (bytes memory) {
1338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1339     }
1340 
1341     /**
1342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1343      * with `errorMessage` as a fallback revert reason when `target` reverts.
1344      *
1345      * _Available since v3.1._
1346      */
1347     function functionCallWithValue(
1348         address target,
1349         bytes memory data,
1350         uint256 value,
1351         string memory errorMessage
1352     ) internal returns (bytes memory) {
1353         require(address(this).balance >= value, "Address: insufficient balance for call");
1354         require(isContract(target), "Address: call to non-contract");
1355 
1356         (bool success, bytes memory returndata) = target.call{value: value}(data);
1357         return verifyCallResult(success, returndata, errorMessage);
1358     }
1359 
1360     /**
1361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1362      * but performing a static call.
1363      *
1364      * _Available since v3.3._
1365      */
1366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1367         return functionStaticCall(target, data, "Address: low-level static call failed");
1368     }
1369 
1370     /**
1371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1372      * but performing a static call.
1373      *
1374      * _Available since v3.3._
1375      */
1376     function functionStaticCall(
1377         address target,
1378         bytes memory data,
1379         string memory errorMessage
1380     ) internal view returns (bytes memory) {
1381         require(isContract(target), "Address: static call to non-contract");
1382 
1383         (bool success, bytes memory returndata) = target.staticcall(data);
1384         return verifyCallResult(success, returndata, errorMessage);
1385     }
1386 
1387     /**
1388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1389      * but performing a delegate call.
1390      *
1391      * _Available since v3.4._
1392      */
1393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1395     }
1396 
1397     /**
1398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1399      * but performing a delegate call.
1400      *
1401      * _Available since v3.4._
1402      */
1403     function functionDelegateCall(
1404         address target,
1405         bytes memory data,
1406         string memory errorMessage
1407     ) internal returns (bytes memory) {
1408         require(isContract(target), "Address: delegate call to non-contract");
1409 
1410         (bool success, bytes memory returndata) = target.delegatecall(data);
1411         return verifyCallResult(success, returndata, errorMessage);
1412     }
1413 
1414     /**
1415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1416      * revert reason using the provided one.
1417      *
1418      * _Available since v4.3._
1419      */
1420     function verifyCallResult(
1421         bool success,
1422         bytes memory returndata,
1423         string memory errorMessage
1424     ) internal pure returns (bytes memory) {
1425         if (success) {
1426             return returndata;
1427         } else {
1428             // Look for revert reason and bubble it up if present
1429             if (returndata.length > 0) {
1430                 // The easiest way to bubble the revert reason is using memory via assembly
1431 
1432                 assembly {
1433                     let returndata_size := mload(returndata)
1434                     revert(add(32, returndata), returndata_size)
1435                 }
1436             } else {
1437                 revert(errorMessage);
1438             }
1439         }
1440     }
1441 }
1442 
1443 
1444 // Creator: Chiru Labs
1445 /**
1446  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1447  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1448  *
1449  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1450  *
1451  * Assumes that an owner cannot have more than the 2**64 - 1 (max value of uint64) of supply
1452  */
1453 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1454     using Address for address;
1455     using Strings for uint256;
1456 
1457     // Compiler will pack this into a single 256bit word.
1458     struct TokenOwnership {
1459         // The address of the owner.
1460         address addr;
1461         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1462         uint64 startTimestamp;
1463         // Whether the token has been burned.
1464         bool burned;
1465     }
1466 
1467     // Compiler will pack this into a single 256bit word.
1468     struct AddressData {
1469         // Realistically, 2**64-1 is more than enough.
1470         uint64 balance;
1471         // Keeps track of mint count with minimal overhead for tokenomics.
1472         uint64 numberMinted;
1473         // Keeps track of burn count with minimal overhead for tokenomics.
1474         uint64 numberBurned;
1475         // For miscellaneous variables (e.g. number preSale minted). 
1476         // Please pack into 64 bits.
1477         uint64 aux;
1478     }
1479 
1480     uint256 internal currentIndex = 0;
1481 
1482     uint256 internal totalBurned = 0;
1483 
1484     // Token name
1485     string private _name;
1486 
1487     // Token symbol
1488     string private _symbol;
1489 
1490     // Mapping from token ID to ownership details
1491     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1492     mapping(uint256 => TokenOwnership) internal _ownerships;
1493 
1494     // Mapping owner address to address data
1495     mapping(address => AddressData) private _addressData;
1496 
1497     // Mapping from token ID to approved address
1498     mapping(uint256 => address) private _tokenApprovals;
1499 
1500     // Mapping from owner to operator approvals
1501     mapping(address => mapping(address => bool)) private _operatorApprovals;
1502 
1503     constructor(string memory name_, string memory symbol_) {
1504         _name = name_;
1505         _symbol = symbol_;
1506     }
1507 
1508     /**
1509      * @dev Skips the zero index.
1510      * This method must be called before any mints (e.g. in the consturctor).
1511      */
1512     function _initOneIndexed() internal {
1513         require(!_exists(0), "ERC721A: 0 index already occupied.");
1514         currentIndex = 1;
1515         totalBurned = 1;
1516         _ownerships[0].burned = true;
1517     }
1518 
1519     /**
1520      * @dev See {IERC721Enumerable-totalSupply}.
1521      */
1522     function totalSupply() public view override returns (uint256) {
1523         return currentIndex - totalBurned;
1524     }
1525 
1526     /**
1527      * @dev See {IERC721Enumerable-tokenByIndex}.
1528      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1529      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1530      */
1531     function tokenByIndex(uint256 index) public view override returns (uint256) {
1532         uint256 numMintedSoFar = currentIndex;
1533         uint256 tokenIdsIdx = 0;
1534         for (uint256 i = 0; i < numMintedSoFar; i++) {
1535             TokenOwnership memory ownership = _ownerships[i];
1536             if (!ownership.burned) {
1537                 if (tokenIdsIdx == index) {
1538                     return i;
1539                 }
1540                 tokenIdsIdx++;
1541             }
1542         }
1543         require(false, 'ERC721A: global index out of bounds');
1544         return 0;
1545     }
1546 
1547     /**
1548      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1549      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1550      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1551      */
1552     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1553         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1554         uint256 numMintedSoFar = currentIndex;
1555         uint256 tokenIdsIdx = 0;
1556         address currOwnershipAddr = address(0);
1557         for (uint256 i = 0; i < numMintedSoFar; i++) {
1558             TokenOwnership memory ownership = _ownerships[i];
1559             if (ownership.addr != address(0)) {
1560                 currOwnershipAddr = ownership.addr;
1561             }
1562             if (ownership.burned) {
1563                 currOwnershipAddr = address(0);
1564             }
1565             if (currOwnershipAddr == owner) {
1566                 if (tokenIdsIdx == index) {
1567                     return i;
1568                 }
1569                 tokenIdsIdx++;
1570             }
1571         }
1572         revert('ERC721A: unable to get token of owner by index');
1573     }
1574 
1575     /**
1576      * @dev See {IERC165-supportsInterface}.
1577      */
1578     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1579         return
1580             interfaceId == type(IERC721).interfaceId ||
1581             interfaceId == type(IERC721Metadata).interfaceId ||
1582             interfaceId == type(IERC721Enumerable).interfaceId ||
1583             super.supportsInterface(interfaceId);
1584     }
1585 
1586     /**
1587      * @dev See {IERC721-balanceOf}.
1588      */
1589     function balanceOf(address owner) public view override returns (uint256) {
1590         require(owner != address(0), 'ERC721A: balance query for the zero address');
1591         return uint256(_addressData[owner].balance);
1592     }
1593 
1594     function _numberMinted(address owner) internal view returns (uint256) {
1595         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1596         return uint256(_addressData[owner].numberMinted);
1597     }
1598 
1599     function _numberBurned(address owner) internal view returns (uint256) {
1600         require(owner != address(0), 'ERC721A: number burned query for the zero address');
1601         return uint256(_addressData[owner].numberBurned);
1602     }
1603 
1604     function _getAux(address owner) internal view returns (uint64) {
1605         require(owner != address(0), 'ERC721A: aux query for the zero address');
1606         return _addressData[owner].aux;
1607     }
1608 
1609     function _setAux(address owner, uint64 aux) internal {
1610         require(owner != address(0), 'ERC721A: aux query for the zero address');
1611         _addressData[owner].aux = aux;
1612     }
1613 
1614     /**
1615      * Gas spent here starts off proportional to the maximum mint batch size.
1616      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1617      */
1618     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1619         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1620 
1621         for (uint256 curr = tokenId; ; curr--) {
1622             TokenOwnership memory ownership = _ownerships[curr];
1623             if (ownership.addr != address(0) && !ownership.burned) {
1624                 return ownership;
1625             }
1626         }
1627 
1628         revert('ERC721A: unable to determine the owner of token');
1629     }
1630 
1631     /**
1632      * @dev See {IERC721-ownerOf}.
1633      */
1634     function ownerOf(uint256 tokenId) public view override returns (address) {
1635         return ownershipOf(tokenId).addr;
1636     }
1637 
1638     /**
1639      * @dev See {IERC721Metadata-name}.
1640      */
1641     function name() public view virtual override returns (string memory) {
1642         return _name;
1643     }
1644 
1645     /**
1646      * @dev See {IERC721Metadata-symbol}.
1647      */
1648     function symbol() public view virtual override returns (string memory) {
1649         return _symbol;
1650     }
1651 
1652     /**
1653      * @dev See {IERC721Metadata-tokenURI}.
1654      */
1655     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1656         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1657 
1658         string memory baseURI = _baseURI();
1659         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1660     }
1661 
1662     /**
1663      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1664      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1665      * by default, can be overriden in child contracts.
1666      */
1667     function _baseURI() internal view virtual returns (string memory) {
1668         return '';
1669     }
1670 
1671     /**
1672      * @dev See {IERC721-approve}.
1673      */
1674     function approve(address to, uint256 tokenId) public override {
1675         address owner = ERC721A.ownerOf(tokenId);
1676         require(to != owner, 'ERC721A: approval to current owner');
1677 
1678         require(
1679             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1680             'ERC721A: approve caller is not owner nor approved for all'
1681         );
1682 
1683         _approve(to, tokenId, owner);
1684     }
1685 
1686     /**
1687      * @dev See {IERC721-getApproved}.
1688      */
1689     function getApproved(uint256 tokenId) public view override returns (address) {
1690         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1691 
1692         return _tokenApprovals[tokenId];
1693     }
1694 
1695     /**
1696      * @dev See {IERC721-setApprovalForAll}.
1697      */
1698     function setApprovalForAll(address operator, bool approved) public override {
1699         require(operator != _msgSender(), 'ERC721A: approve to caller');
1700 
1701         _operatorApprovals[_msgSender()][operator] = approved;
1702         emit ApprovalForAll(_msgSender(), operator, approved);
1703     }
1704 
1705     /**
1706      * @dev See {IERC721-isApprovedForAll}.
1707      */
1708     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1709         return _operatorApprovals[owner][operator];
1710     }
1711 
1712     /**
1713      * @dev See {IERC721-transferFrom}.
1714      */
1715     function transferFrom(
1716         address from,
1717         address to,
1718         uint256 tokenId
1719     ) public virtual override {
1720         _transfer(from, to, tokenId);
1721     }
1722 
1723     /**
1724      * @dev See {IERC721-safeTransferFrom}.
1725      */
1726     function safeTransferFrom(
1727         address from,
1728         address to,
1729         uint256 tokenId
1730     ) public virtual override {
1731         safeTransferFrom(from, to, tokenId, '');
1732     }
1733 
1734     /**
1735      * @dev See {IERC721-safeTransferFrom}.
1736      */
1737     function safeTransferFrom(
1738         address from,
1739         address to,
1740         uint256 tokenId,
1741         bytes memory _data
1742     ) public virtual override {
1743         _transfer(from, to, tokenId);
1744         require(
1745             _checkOnERC721Received(from, to, tokenId, _data),
1746             'ERC721A: transfer to non ERC721Receiver implementer'
1747         );
1748     }
1749 
1750     /**
1751      * @dev Returns whether `tokenId` exists.
1752      *
1753      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1754      *
1755      * Tokens start existing when they are minted (`_mint`),
1756      */
1757     function _exists(uint256 tokenId) internal view returns (bool) {
1758         return tokenId < currentIndex && !_ownerships[tokenId].burned;
1759     }
1760 
1761     function _safeMint(address to, uint256 quantity) internal {
1762         _safeMint(to, quantity, '');
1763     }
1764 
1765     /**
1766      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1767      *
1768      * Requirements:
1769      *
1770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1771      * - `quantity` must be greater than 0.
1772      *
1773      * Emits a {Transfer} event.
1774      */
1775     function _safeMint(
1776         address to,
1777         uint256 quantity,
1778         bytes memory _data
1779     ) internal {
1780         _mint(to, quantity, _data, true);
1781     }
1782 
1783     /**
1784      * @dev Mints `quantity` tokens and transfers them to `to`.
1785      *
1786      * Requirements:
1787      *
1788      * - `to` cannot be the zero address.
1789      * - `quantity` must be greater than 0.
1790      *
1791      * Emits a {Transfer} event.
1792      */
1793     function _mint(
1794         address to,
1795         uint256 quantity,
1796         bytes memory _data,
1797         bool safe
1798     ) internal {
1799         uint256 startTokenId = currentIndex;
1800         require(to != address(0), 'ERC721A: mint to the zero address');
1801         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1802         require(!_exists(startTokenId), 'ERC721A: token already minted');
1803         require(quantity > 0, 'ERC721A: quantity must be greater than 0');
1804 
1805         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1806 
1807         _addressData[to].balance += uint64(quantity);
1808         _addressData[to].numberMinted += uint64(quantity);
1809 
1810         _ownerships[startTokenId].addr = to;
1811         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1812 
1813         uint256 updatedIndex = startTokenId;
1814 
1815         for (uint256 i = 0; i < quantity; i++) {
1816             emit Transfer(address(0), to, updatedIndex);
1817             if (safe) {
1818                 require(
1819                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1820                     'ERC721A: transfer to non ERC721Receiver implementer'
1821                 );
1822             }
1823             updatedIndex++;
1824         }
1825 
1826         currentIndex = updatedIndex;
1827         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1828     }
1829 
1830     /**
1831      * @dev Transfers `tokenId` from `from` to `to`.
1832      *
1833      * Requirements:
1834      *
1835      * - `to` cannot be the zero address.
1836      * - `tokenId` token must be owned by `from`.
1837      *
1838      * Emits a {Transfer} event.
1839      */
1840     function _transfer(
1841         address from,
1842         address to,
1843         uint256 tokenId
1844     ) private {
1845         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1846 
1847         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1848             getApproved(tokenId) == _msgSender() ||
1849             isApprovedForAll(prevOwnership.addr, _msgSender()));
1850 
1851         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1852 
1853         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1854         require(to != address(0), 'ERC721A: transfer to the zero address');
1855 
1856         _beforeTokenTransfers(from, to, tokenId, 1);
1857 
1858         // Clear approvals from the previous owner
1859         _approve(address(0), tokenId, prevOwnership.addr);
1860 
1861         // Underflow of the sender's balance is impossible because we check for
1862         // ownership above and the recipient's balance can't realistically overflow.
1863         unchecked {
1864             _addressData[from].balance -= 1;
1865             _addressData[to].balance += 1;
1866         }
1867 
1868         _ownerships[tokenId].addr = to;
1869         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1870 
1871         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1872         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1873         uint256 nextTokenId = tokenId + 1;
1874         if (_ownerships[nextTokenId].addr == address(0)) {
1875             if (_exists(nextTokenId)) {
1876                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1877                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1878             }
1879         }
1880 
1881         emit Transfer(from, to, tokenId);
1882         _afterTokenTransfers(from, to, tokenId, 1);
1883     }
1884 
1885     /**
1886      * @dev Destroys `tokenId`.
1887      * The approval is cleared when the token is burned.
1888      *
1889      * Requirements:
1890      *
1891      * - `tokenId` must exist.
1892      *
1893      * Emits a {Transfer} event.
1894      */
1895     function _burn(uint256 tokenId) internal virtual {
1896         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1897 
1898         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1899 
1900         // Clear approvals from the previous owner
1901         _approve(address(0), tokenId, prevOwnership.addr);
1902 
1903         // Underflow of the sender's balance is impossible because we check for
1904         // ownership above and the recipient's balance can't realistically overflow.
1905         unchecked {
1906             _addressData[prevOwnership.addr].balance -= 1;
1907             _addressData[prevOwnership.addr].numberBurned += 1;
1908         }
1909 
1910         // Keep track of who burnt the token, and when is it burned.
1911         _ownerships[tokenId].addr = prevOwnership.addr;
1912         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1913         _ownerships[tokenId].burned = true; 
1914 
1915         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1916         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1917         uint256 nextTokenId = tokenId + 1;
1918         if (_ownerships[nextTokenId].addr == address(0)) {
1919             if (_exists(nextTokenId)) {
1920                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1921                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1922             }
1923         }
1924 
1925         emit Transfer(prevOwnership.addr, address(0), tokenId);
1926         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1927 
1928         totalBurned++;
1929     }
1930 
1931     /**
1932      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1933      *
1934      * Requirements:
1935      *
1936      * - The caller must own `tokenId` or be an approved operator.
1937      */
1938     function burn(uint256 tokenId) public virtual {
1939         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1940 
1941         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1942             getApproved(tokenId) == _msgSender() ||
1943             isApprovedForAll(prevOwnership.addr, _msgSender()));
1944 
1945         require(isApprovedOrOwner, 'ERC721A: caller is not owner nor approved');
1946 
1947         _burn(tokenId);
1948     }
1949 
1950     /**
1951      * @dev Approve `to` to operate on `tokenId`
1952      *
1953      * Emits a {Approval} event.
1954      */
1955     function _approve(
1956         address to,
1957         uint256 tokenId,
1958         address owner
1959     ) private {
1960         _tokenApprovals[tokenId] = to;
1961         emit Approval(owner, to, tokenId);
1962     }
1963 
1964     /**
1965      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1966      * The call is not executed if the target address is not a contract.
1967      *
1968      * @param from address representing the previous owner of the given token ID
1969      * @param to target address that will receive the tokens
1970      * @param tokenId uint256 ID of the token to be transferred
1971      * @param _data bytes optional data to send along with the call
1972      * @return bool whether the call correctly returned the expected magic value
1973      */
1974     function _checkOnERC721Received(
1975         address from,
1976         address to,
1977         uint256 tokenId,
1978         bytes memory _data
1979     ) private returns (bool) {
1980         if (to.isContract()) {
1981             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1982                 return retval == IERC721Receiver(to).onERC721Received.selector;
1983             } catch (bytes memory reason) {
1984                 if (reason.length == 0) {
1985                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1986                 } else {
1987                     assembly {
1988                         revert(add(32, reason), mload(reason))
1989                     }
1990                 }
1991             }
1992         } else {
1993             return true;
1994         }
1995     }
1996 
1997     /**
1998      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1999      *
2000      * startTokenId - the first token id to be transferred
2001      * quantity - the amount to be transferred
2002      *
2003      * Calling conditions:
2004      *
2005      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2006      * transferred to `to`.
2007      * - When `from` is zero, `tokenId` will be minted for `to`.
2008      */
2009     function _beforeTokenTransfers(
2010         address from,
2011         address to,
2012         uint256 startTokenId,
2013         uint256 quantity
2014     ) internal virtual {}
2015 
2016     /**
2017      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2018      * minting.
2019      *
2020      * startTokenId - the first token id to be transferred
2021      * quantity - the amount to be transferred
2022      *
2023      * Calling conditions:
2024      *
2025      * - when `from` and `to` are both non-zero.
2026      * - `from` and `to` are never both zero.
2027      */
2028     function _afterTokenTransfers(
2029         address from,
2030         address to,
2031         uint256 startTokenId,
2032         uint256 quantity
2033     ) internal virtual {}
2034 }
2035 
2036 
2037 contract KaijuKongz is ERC721A, Ownable, AccessControlEnumerable {
2038     uint256 constant public legendarySupply = 9;
2039     uint256 constant public teamSupply = 30;
2040 
2041     uint256 public maxTotalSupply = 3333;
2042     uint256 public pricePerToken = 0.065 ether;
2043     uint256 public tokensBurned = 0;
2044     bool public promoTokensMinted = false;
2045     bool public tradeActive = false;
2046     
2047     enum SaleState{ CLOSED, PRIVATE, PUBLIC }
2048     SaleState public saleState = SaleState.CLOSED;
2049 
2050     bytes32 private merkleRootGroup1;
2051     bytes32 private merkleRootGroup2;
2052 
2053     uint8 private maxTokenWlGroup1 = 1;
2054     uint8 private maxTokenWlGroup2 = 2;
2055     uint8 private maxTokenPublic = 5;
2056 
2057     uint256 private disableBurnTime = 518400;
2058 
2059     mapping(address => uint256) presaleMinted;
2060     mapping(address => uint256) publicMinted;
2061 
2062     string _baseTokenURI;
2063     address _burnerAddress;
2064     uint256 deployedTime;
2065 
2066     constructor() ERC721A("KaijuKongz", "Kai") {
2067       _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2068       deployedTime = block.timestamp;
2069     }
2070 
2071     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) public override {
2072       require(tradeActive, "Trade is not active");
2073       super.safeTransferFrom(_from, _to, _tokenId, data);
2074     }
2075 
2076     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public override {
2077       require(tradeActive, "Trade is not active");
2078       super.safeTransferFrom(_from, _to, _tokenId);
2079     }
2080 
2081     function transferFrom(address _from, address _to, uint256 _tokenId) public override {
2082       require(tradeActive, "Trade is not active");
2083       super.transferFrom(_from, _to, _tokenId);
2084     }
2085 
2086     function setTradeState(bool tradeState) public {
2087       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set trade state");
2088       tradeActive = tradeState;
2089     }
2090 
2091     function setPrice(uint256 newPrice) public {
2092       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set price");
2093       pricePerToken = newPrice;
2094     }
2095 
2096     function withdraw() public onlyOwner {
2097       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot withdraw");
2098         payable(owner()).transfer(address(this).balance);
2099     }
2100 
2101     function setSaleState(SaleState newState) public {
2102       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot alter sale state");
2103       saleState = newState;
2104     }
2105 
2106     function setMerkleRoot(bytes32 newRootGroup1, bytes32 newRootGroup2) public {
2107       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot set merkle root");
2108       merkleRootGroup1 = newRootGroup1;
2109       merkleRootGroup2 = newRootGroup2;
2110     }
2111 
2112     function promoMint() public onlyOwner {
2113       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Cannot mint team tokens");
2114       require(!promoTokensMinted, "Promo tokens have already been minted");
2115       _safeMint(owner(), legendarySupply + teamSupply);
2116       promoTokensMinted = true;
2117     }
2118 
2119     function presale(uint256 amount, bytes32[] calldata proof) public payable {
2120       require (saleState == SaleState.PRIVATE, "Sale state should be private");
2121       require(totalSupply() < maxTotalSupply, "Max supply reached");
2122       require(promoTokensMinted, "Promo tokens should be minted in advance");
2123       bool isValidGroup1 = MerkleProof.verify(proof, merkleRootGroup1, keccak256(abi.encodePacked(msg.sender)));
2124       bool isValidGroup2 = MerkleProof.verify(proof, merkleRootGroup2, keccak256(abi.encodePacked(msg.sender)));
2125       require(isValidGroup1 || isValidGroup2, "You are not in the valid whitelist");
2126 
2127       uint256 amountAllowed = isValidGroup1 ? maxTokenWlGroup1 : maxTokenWlGroup2;
2128       require(amount + presaleMinted[msg.sender] <= amountAllowed, "Your token amount reached out max");
2129       require(presaleMinted[msg.sender] < amountAllowed, "You've already minted all");
2130       uint256 amountToPay = amount * pricePerToken;
2131       require(amountToPay <= msg.value, "Provided not enough Ether for purchase");
2132       presaleMinted[msg.sender] += amount;
2133       _safeMint(_msgSender(), amount);
2134     }
2135 
2136     function publicsale(uint256 amount) public payable {
2137       require (saleState == SaleState.PUBLIC, "Sale state should be public");
2138       require(promoTokensMinted, "Promo tokens should be minted in advance");
2139       require(totalSupply() < maxTotalSupply, "Max supply reached");
2140       require(amount + publicMinted[msg.sender] <= maxTokenPublic, "Your token amount reached out max");
2141       uint256 amountToPay = amount * pricePerToken;
2142       require(amountToPay <= msg.value, "Provided not enough Ether for purchase");
2143       publicMinted[msg.sender] += amount;
2144       _safeMint(_msgSender(), amount);
2145     }
2146 
2147     function burnMany(uint256[] calldata tokenIds) public {
2148       require(_msgSender() == _burnerAddress, "Only burner can burn tokens");
2149       uint256 nowTime = block.timestamp;
2150       require(nowTime - deployedTime <= disableBurnTime, "Burn is available only for 6 days");
2151       for (uint256 i; i < tokenIds.length; i++) {
2152         _burn(tokenIds[i]);
2153       }
2154       maxTotalSupply -= tokenIds.length;
2155       tokensBurned += tokenIds.length;
2156     }
2157 
2158     function setBurnerAddress(address burnerAddress) public {
2159       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller cannot set burn address");
2160       _burnerAddress = burnerAddress;
2161     }
2162 
2163     function _baseURI() internal view virtual override returns (string memory) {
2164       return _baseTokenURI;
2165     }
2166 
2167     function setBaseURI(string memory baseURI) public onlyOwner {
2168         _baseTokenURI = baseURI;
2169     }
2170 
2171     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, AccessControlEnumerable) returns (bool) {
2172       return super.supportsInterface(interfaceId);
2173     }
2174 }