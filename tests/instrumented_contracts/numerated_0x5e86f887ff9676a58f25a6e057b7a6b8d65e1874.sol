1 // Bitchcoin by Sarah Meyohas
2 // www.sarahmeyohas.com/bitchcoin
3 
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 
10 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol
11 
12 /**
13  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
14  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
15  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
16  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
17  *
18  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
19  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
20  *
21  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
22  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
23  */
24 abstract contract Initializable {
25 
26     /**
27      * @dev Indicates that the contract has been initialized.
28      */
29     bool private _initialized;
30 
31     /**
32      * @dev Indicates that the contract is in the process of being initialized.
33      */
34     bool private _initializing;
35 
36     /**
37      * @dev Modifier to protect an initializer function from being invoked twice.
38      */
39     modifier initializer() {
40         require(_initializing || !_initialized, "Initializable: contract is already initialized");
41 
42         bool isTopLevelCall = !_initializing;
43         if (isTopLevelCall) {
44             _initializing = true;
45             _initialized = true;
46         }
47 
48         _;
49 
50         if (isTopLevelCall) {
51             _initializing = false;
52         }
53     }
54 }
55 
56 
57 
58 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/utils/ContextUpgradeable.sol
59 
60 /*
61  * @dev Provides information about the current execution context, including the
62  * sender of the transaction and its data. While these are generally available
63  * via msg.sender and msg.data, they should not be accessed in such a direct
64  * manner, since when dealing with meta-transactions the account sending and
65  * paying for execution may not be the actual sender (as far as an application
66  * is concerned).
67  *
68  * This contract is only required for intermediate, library-like contracts.
69  */
70 abstract contract ContextUpgradeable is Initializable {
71     function __Context_init() internal initializer {
72         __Context_init_unchained();
73     }
74 
75     function __Context_init_unchained() internal initializer {
76     }
77     function _msgSender() internal view virtual returns (address) {
78         return msg.sender;
79     }
80 
81     function _msgData() internal view virtual returns (bytes calldata) {
82         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
83         return msg.data;
84     }
85     uint256[50] private __gap;
86 }
87 
88 
89 
90 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/utils/introspection/IERC165Upgradeable.sol
91 
92 /**
93  * @dev Interface of the ERC165 standard, as defined in the
94  * https://eips.ethereum.org/EIPS/eip-165[EIP].
95  *
96  * Implementers can declare support of contract interfaces, which can then be
97  * queried by others ({ERC165Checker}).
98  *
99  * For an implementation, see {ERC165}.
100  */
101 
102 interface IERC165Upgradeable {
103     /**
104      * @dev Returns true if this contract implements the interface defined by
105      * `interfaceId`. See the corresponding
106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
107      * to learn more about how these ids are created.
108      *
109      * This function call must use less than 30 000 gas.
110      */
111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
112 }
113 
114 
115 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/utils/introspection/ERC165Upgradeable.sol
116 
117 /**
118  * @dev Implementation of the {IERC165} interface.
119  *
120  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
121  * for the additional interface id that will be supported. For example:
122  *
123  * ```solidity
124  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
125  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
126  * }
127  * ```
128  *
129  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
130  */
131 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
132     function __ERC165_init() internal initializer {
133         __ERC165_init_unchained();
134     }
135 
136     function __ERC165_init_unchained() internal initializer {
137     }
138     /**
139      * @dev See {IERC165-supportsInterface}.
140      */
141     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
142         return interfaceId == type(IERC165Upgradeable).interfaceId;
143     }
144     uint256[50] private __gap;
145 }
146 
147 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/utils/StringsUpgradeable.sol
148 
149 /**
150  * @dev String operations.
151  */
152 library StringsUpgradeable {
153     bytes16 private constant alphabet = "0123456789abcdef";
154 
155     /**
156      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
157      */
158     function toString(uint256 value) internal pure returns (string memory) {
159         // Inspired by OraclizeAPI's implementation - MIT licence
160         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
161 
162         if (value == 0) {
163             return "0";
164         }
165         uint256 temp = value;
166         uint256 digits;
167         while (temp != 0) {
168             digits++;
169             temp /= 10;
170         }
171         bytes memory buffer = new bytes(digits);
172         while (value != 0) {
173             digits -= 1;
174             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
175             value /= 10;
176         }
177         return string(buffer);
178     }
179 
180     /**
181      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
182      */
183     function toHexString(uint256 value) internal pure returns (string memory) {
184         if (value == 0) {
185             return "0x00";
186         }
187         uint256 temp = value;
188         uint256 length = 0;
189         while (temp != 0) {
190             length++;
191             temp >>= 8;
192         }
193         return toHexString(value, length);
194     }
195 
196     /**
197      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
198      */
199     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
200         bytes memory buffer = new bytes(2 * length + 2);
201         buffer[0] = "0";
202         buffer[1] = "x";
203         for (uint256 i = 2 * length + 1; i > 1; --i) {
204             buffer[i] = alphabet[value & 0xf];
205             value >>= 4;
206         }
207         require(value == 0, "Strings: hex length insufficient");
208         return string(buffer);
209     }
210 
211 }
212 
213 
214 
215 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol
216 
217 /**
218  * @dev External interface of AccessControl declared to support ERC165 detection.
219  */
220 interface IAccessControlUpgradeable {
221     function hasRole(bytes32 role, address account) external view returns (bool);
222     function getRoleAdmin(bytes32 role) external view returns (bytes32);
223     function grantRole(bytes32 role, address account) external;
224     function revokeRole(bytes32 role, address account) external;
225     function renounceRole(bytes32 role, address account) external;
226 }
227 
228 /**
229  * @dev Contract module that allows children to implement role-based access
230  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
231  * members except through off-chain means by accessing the contract event logs. Some
232  * applications may benefit from on-chain enumerability, for those cases see
233  * {AccessControlEnumerable}.
234  *
235  * Roles are referred to by their `bytes32` identifier. These should be exposed
236  * in the external API and be unique. The best way to achieve this is by
237  * using `public constant` hash digests:
238  *
239  * ```
240  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
241  * ```
242  *
243  * Roles can be used to represent a set of permissions. To restrict access to a
244  * function call, use {hasRole}:
245  *
246  * ```
247  * function foo() public {
248  *     require(hasRole(MY_ROLE, msg.sender));
249  *     ...
250  * }
251  * ```
252  *
253  * Roles can be granted and revoked dynamically via the {grantRole} and
254  * {revokeRole} functions. Each role has an associated admin role, and only
255  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
256  *
257  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
258  * that only accounts with this role will be able to grant or revoke other
259  * roles. More complex role relationships can be created by using
260  * {_setRoleAdmin}.
261  *
262  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
263  * grant and revoke this role. Extra precautions should be taken to secure
264  * accounts that have been granted it.
265  */
266 
267 abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable, IAccessControlUpgradeable, ERC165Upgradeable {
268     function __AccessControl_init() internal initializer {
269         __Context_init_unchained();
270         __ERC165_init_unchained();
271         __AccessControl_init_unchained();
272     }
273 
274     function __AccessControl_init_unchained() internal initializer {
275     }
276     struct RoleData {
277         mapping (address => bool) members;
278         bytes32 adminRole;
279     }
280 
281     mapping (bytes32 => RoleData) private _roles;
282 
283     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
284 
285     /**
286      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
287      *
288      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
289      * {RoleAdminChanged} not being emitted signaling this.
290      *
291      * _Available since v3.1._
292      */
293     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
294 
295     /**
296      * @dev Emitted when `account` is granted `role`.
297      *
298      * `sender` is the account that originated the contract call, an admin role
299      * bearer except when using {_setupRole}.
300      */
301     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
302 
303     /**
304      * @dev Emitted when `account` is revoked `role`.
305      *
306      * `sender` is the account that originated the contract call:
307      *   - if using `revokeRole`, it is the admin role bearer
308      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
309      */
310     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
311 
312     /**
313      * @dev Modifier that checks that an account has a specific role. Reverts
314      * with a standardized message including the required role.
315      *
316      * The format of the revert reason is given by the following regular expression:
317      *
318      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
319      *
320      * _Available since v4.1._
321      */
322     modifier onlyRole(bytes32 role) {
323         _checkRole(role, _msgSender());
324         _;
325     }
326 
327     /**
328      * @dev See {IERC165-supportsInterface}.
329      */
330     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
331         return interfaceId == type(IAccessControlUpgradeable).interfaceId
332             || super.supportsInterface(interfaceId);
333     }
334 
335     /**
336      * @dev Returns `true` if `account` has been granted `role`.
337      */
338     function hasRole(bytes32 role, address account) public view override returns (bool) {
339         return _roles[role].members[account];
340     }
341 
342     /**
343      * @dev Revert with a standard message if `account` is missing `role`.
344      *
345      * The format of the revert reason is given by the following regular expression:
346      *
347      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
348      */
349     function _checkRole(bytes32 role, address account) internal view {
350         if(!hasRole(role, account)) {
351             revert(string(abi.encodePacked(
352                 "AccessControl: account ",
353                 StringsUpgradeable.toHexString(uint160(account), 20),
354                 " is missing role ",
355                 StringsUpgradeable.toHexString(uint256(role), 32)
356             )));
357         }
358     }
359 
360     /**
361      * @dev Returns the admin role that controls `role`. See {grantRole} and
362      * {revokeRole}.
363      *
364      * To change a role's admin, use {_setRoleAdmin}.
365      */
366     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
367         return _roles[role].adminRole;
368     }
369 
370     /**
371      * @dev Grants `role` to `account`.
372      *
373      * If `account` had not been already granted `role`, emits a {RoleGranted}
374      * event.
375      *
376      * Requirements:
377      *
378      * - the caller must have ``role``'s admin role.
379      */
380     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
381         _grantRole(role, account);
382     }
383 
384     /**
385      * @dev Revokes `role` from `account`.
386      *
387      * If `account` had been granted `role`, emits a {RoleRevoked} event.
388      *
389      * Requirements:
390      *
391      * - the caller must have ``role``'s admin role.
392      */
393     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
394         _revokeRole(role, account);
395     }
396 
397     /**
398      * @dev Revokes `role` from the calling account.
399      *
400      * Roles are often managed via {grantRole} and {revokeRole}: this function's
401      * purpose is to provide a mechanism for accounts to lose their privileges
402      * if they are compromised (such as when a trusted device is misplaced).
403      *
404      * If the calling account had been granted `role`, emits a {RoleRevoked}
405      * event.
406      *
407      * Requirements:
408      *
409      * - the caller must be `account`.
410      */
411     function renounceRole(bytes32 role, address account) public virtual override {
412         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
413 
414         _revokeRole(role, account);
415     }
416 
417     /**
418      * @dev Grants `role` to `account`.
419      *
420      * If `account` had not been already granted `role`, emits a {RoleGranted}
421      * event. Note that unlike {grantRole}, this function doesn't perform any
422      * checks on the calling account.
423      *
424      * [WARNING]
425      * ====
426      * This function should only be called from the constructor when setting
427      * up the initial roles for the system.
428      *
429      * Using this function in any other way is effectively circumventing the admin
430      * system imposed by {AccessControl}.
431      * ====
432      */
433     function _setupRole(bytes32 role, address account) internal virtual {
434         _grantRole(role, account);
435     }
436 
437     /**
438      * @dev Sets `adminRole` as ``role``'s admin role.
439      *
440      * Emits a {RoleAdminChanged} event.
441      */
442     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
443         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
444         _roles[role].adminRole = adminRole;
445     }
446 
447     function _grantRole(bytes32 role, address account) private {
448         if (!hasRole(role, account)) {
449             _roles[role].members[account] = true;
450             emit RoleGranted(role, account, _msgSender());
451         }
452     }
453 
454     function _revokeRole(bytes32 role, address account) private {
455         if (hasRole(role, account)) {
456             _roles[role].members[account] = false;
457             emit RoleRevoked(role, account, _msgSender());
458         }
459     }
460     uint256[49] private __gap;
461 }
462 
463 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/utils/structs/EnumerableSetUpgradeable.sol
464 
465 /**
466  * @dev Library for managing
467  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
468  * types.
469  *
470  * Sets have the following properties:
471  *
472  * - Elements are added, removed, and checked for existence in constant time
473  * (O(1)).
474  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
475  *
476  * ```
477  * contract Example {
478  *     // Add the library methods
479  *     using EnumerableSet for EnumerableSet.AddressSet;
480  *
481  *     // Declare a set state variable
482  *     EnumerableSet.AddressSet private mySet;
483  * }
484  * ```
485  *
486  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
487  * and `uint256` (`UintSet`) are supported.
488  */
489 library EnumerableSetUpgradeable {
490     // To implement this library for multiple types with as little code
491     // repetition as possible, we write it in terms of a generic Set type with
492     // bytes32 values.
493     // The Set implementation uses private functions, and user-facing
494     // implementations (such as AddressSet) are just wrappers around the
495     // underlying Set.
496     // This means that we can only create new EnumerableSets for types that fit
497     // in bytes32.
498 
499     struct Set {
500         // Storage of set values
501         bytes32[] _values;
502 
503         // Position of the value in the `values` array, plus 1 because index 0
504         // means a value is not in the set.
505         mapping (bytes32 => uint256) _indexes;
506     }
507 
508     /**
509      * @dev Add a value to a set. O(1).
510      *
511      * Returns true if the value was added to the set, that is if it was not
512      * already present.
513      */
514     function _add(Set storage set, bytes32 value) private returns (bool) {
515         if (!_contains(set, value)) {
516             set._values.push(value);
517             // The value is stored at length-1, but we add 1 to all indexes
518             // and use 0 as a sentinel value
519             set._indexes[value] = set._values.length;
520             return true;
521         } else {
522             return false;
523         }
524     }
525 
526     /**
527      * @dev Removes a value from a set. O(1).
528      *
529      * Returns true if the value was removed from the set, that is if it was
530      * present.
531      */
532     function _remove(Set storage set, bytes32 value) private returns (bool) {
533         // We read and store the value's index to prevent multiple reads from the same storage slot
534         uint256 valueIndex = set._indexes[value];
535 
536         if (valueIndex != 0) { // Equivalent to contains(set, value)
537             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
538             // the array, and then remove the last element (sometimes called as 'swap and pop').
539             // This modifies the order of the array, as noted in {at}.
540 
541             uint256 toDeleteIndex = valueIndex - 1;
542             uint256 lastIndex = set._values.length - 1;
543 
544             if (lastIndex != toDeleteIndex) {
545                 bytes32 lastvalue = set._values[lastIndex];
546 
547                 // Move the last value to the index where the value to delete is
548                 set._values[toDeleteIndex] = lastvalue;
549                 // Update the index for the moved value
550                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
551             }
552 
553             // Delete the slot where the moved value was stored
554             set._values.pop();
555 
556             // Delete the index for the deleted slot
557             delete set._indexes[value];
558 
559             return true;
560         } else {
561             return false;
562         }
563     }
564 
565     /**
566      * @dev Returns true if the value is in the set. O(1).
567      */
568     function _contains(Set storage set, bytes32 value) private view returns (bool) {
569         return set._indexes[value] != 0;
570     }
571 
572     /**
573      * @dev Returns the number of values on the set. O(1).
574      */
575     function _length(Set storage set) private view returns (uint256) {
576         return set._values.length;
577     }
578 
579    /**
580     * @dev Returns the value stored at position `index` in the set. O(1).
581     *
582     * Note that there are no guarantees on the ordering of values inside the
583     * array, and it may change when more values are added or removed.
584     *
585     * Requirements:
586     *
587     * - `index` must be strictly less than {length}.
588     */
589     function _at(Set storage set, uint256 index) private view returns (bytes32) {
590         return set._values[index];
591     }
592 
593     // Bytes32Set
594 
595     struct Bytes32Set {
596         Set _inner;
597     }
598 
599     /**
600      * @dev Add a value to a set. O(1).
601      *
602      * Returns true if the value was added to the set, that is if it was not
603      * already present.
604      */
605     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
606         return _add(set._inner, value);
607     }
608 
609     /**
610      * @dev Removes a value from a set. O(1).
611      *
612      * Returns true if the value was removed from the set, that is if it was
613      * present.
614      */
615     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
616         return _remove(set._inner, value);
617     }
618 
619     /**
620      * @dev Returns true if the value is in the set. O(1).
621      */
622     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
623         return _contains(set._inner, value);
624     }
625 
626     /**
627      * @dev Returns the number of values in the set. O(1).
628      */
629     function length(Bytes32Set storage set) internal view returns (uint256) {
630         return _length(set._inner);
631     }
632 
633    /**
634     * @dev Returns the value stored at position `index` in the set. O(1).
635     *
636     * Note that there are no guarantees on the ordering of values inside the
637     * array, and it may change when more values are added or removed.
638     *
639     * Requirements:
640     *
641     * - `index` must be strictly less than {length}.
642     */
643     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
644         return _at(set._inner, index);
645     }
646 
647     // AddressSet
648 
649     struct AddressSet {
650         Set _inner;
651     }
652 
653     /**
654      * @dev Add a value to a set. O(1).
655      *
656      * Returns true if the value was added to the set, that is if it was not
657      * already present.
658      */
659     function add(AddressSet storage set, address value) internal returns (bool) {
660         return _add(set._inner, bytes32(uint256(uint160(value))));
661     }
662 
663     /**
664      * @dev Removes a value from a set. O(1).
665      *
666      * Returns true if the value was removed from the set, that is if it was
667      * present.
668      */
669     function remove(AddressSet storage set, address value) internal returns (bool) {
670         return _remove(set._inner, bytes32(uint256(uint160(value))));
671     }
672 
673     /**
674      * @dev Returns true if the value is in the set. O(1).
675      */
676     function contains(AddressSet storage set, address value) internal view returns (bool) {
677         return _contains(set._inner, bytes32(uint256(uint160(value))));
678     }
679 
680     /**
681      * @dev Returns the number of values in the set. O(1).
682      */
683     function length(AddressSet storage set) internal view returns (uint256) {
684         return _length(set._inner);
685     }
686 
687    /**
688     * @dev Returns the value stored at position `index` in the set. O(1).
689     *
690     * Note that there are no guarantees on the ordering of values inside the
691     * array, and it may change when more values are added or removed.
692     *
693     * Requirements:
694     *
695     * - `index` must be strictly less than {length}.
696     */
697     function at(AddressSet storage set, uint256 index) internal view returns (address) {
698         return address(uint160(uint256(_at(set._inner, index))));
699     }
700 
701 
702     // UintSet
703 
704     struct UintSet {
705         Set _inner;
706     }
707 
708     /**
709      * @dev Add a value to a set. O(1).
710      *
711      * Returns true if the value was added to the set, that is if it was not
712      * already present.
713      */
714     function add(UintSet storage set, uint256 value) internal returns (bool) {
715         return _add(set._inner, bytes32(value));
716     }
717 
718     /**
719      * @dev Removes a value from a set. O(1).
720      *
721      * Returns true if the value was removed from the set, that is if it was
722      * present.
723      */
724     function remove(UintSet storage set, uint256 value) internal returns (bool) {
725         return _remove(set._inner, bytes32(value));
726     }
727 
728     /**
729      * @dev Returns true if the value is in the set. O(1).
730      */
731     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
732         return _contains(set._inner, bytes32(value));
733     }
734 
735     /**
736      * @dev Returns the number of values on the set. O(1).
737      */
738     function length(UintSet storage set) internal view returns (uint256) {
739         return _length(set._inner);
740     }
741 
742    /**
743     * @dev Returns the value stored at position `index` in the set. O(1).
744     *
745     * Note that there are no guarantees on the ordering of values inside the
746     * array, and it may change when more values are added or removed.
747     *
748     * Requirements:
749     *
750     * - `index` must be strictly less than {length}.
751     */
752     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
753         return uint256(_at(set._inner, index));
754     }
755 }
756 
757 
758 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/access/AccessControlEnumerableUpgradeable.sol
759 
760 /**
761  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
762  */
763 interface IAccessControlEnumerableUpgradeable {
764     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
765     function getRoleMemberCount(bytes32 role) external view returns (uint256);
766 }
767 
768 /**
769  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
770  */
771 abstract contract AccessControlEnumerableUpgradeable is Initializable, IAccessControlEnumerableUpgradeable, AccessControlUpgradeable {
772     function __AccessControlEnumerable_init() internal initializer {
773         __Context_init_unchained();
774         __ERC165_init_unchained();
775         __AccessControl_init_unchained();
776         __AccessControlEnumerable_init_unchained();
777     }
778 
779     function __AccessControlEnumerable_init_unchained() internal initializer {
780     }
781     using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
782 
783     mapping (bytes32 => EnumerableSetUpgradeable.AddressSet) private _roleMembers;
784 
785     /**
786      * @dev See {IERC165-supportsInterface}.
787      */
788     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
789         return interfaceId == type(IAccessControlEnumerableUpgradeable).interfaceId
790             || super.supportsInterface(interfaceId);
791     }
792 
793     /**
794      * @dev Returns one of the accounts that have `role`. `index` must be a
795      * value between 0 and {getRoleMemberCount}, non-inclusive.
796      *
797      * Role bearers are not sorted in any particular way, and their ordering may
798      * change at any point.
799      *
800      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
801      * you perform all queries on the same block. See the following
802      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
803      * for more information.
804      */
805     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
806         return _roleMembers[role].at(index);
807     }
808 
809     /**
810      * @dev Returns the number of accounts that have `role`. Can be used
811      * together with {getRoleMember} to enumerate all bearers of a role.
812      */
813     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
814         return _roleMembers[role].length();
815     }
816 
817     /**
818      * @dev Overload {grantRole} to track enumerable memberships
819      */
820     function grantRole(bytes32 role, address account) public virtual override {
821         super.grantRole(role, account);
822         _roleMembers[role].add(account);
823     }
824 
825     /**
826      * @dev Overload {revokeRole} to track enumerable memberships
827      */
828     function revokeRole(bytes32 role, address account) public virtual override {
829         super.revokeRole(role, account);
830         _roleMembers[role].remove(account);
831     }
832 
833     /**
834      * @dev Overload {renounceRole} to track enumerable memberships
835      */
836     function renounceRole(bytes32 role, address account) public virtual override {
837         super.renounceRole(role, account);
838         _roleMembers[role].remove(account);
839     }
840 
841     /**
842      * @dev Overload {_setupRole} to track enumerable memberships
843      */
844     function _setupRole(bytes32 role, address account) internal virtual override {
845         super._setupRole(role, account);
846         _roleMembers[role].add(account);
847     }
848     uint256[49] private __gap;
849 }
850 
851 
852 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/IERC1155Upgradeable.sol
853 
854 /**
855  * @dev Required interface of an ERC1155 compliant contract, as defined in the
856  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
857  *
858  * _Available since v3.1._
859  */
860 
861 interface IERC1155Upgradeable is IERC165Upgradeable {
862     /**
863      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
864      */
865     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
866 
867     /**
868      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
869      * transfers.
870      */
871     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
872 
873     /**
874      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
875      * `approved`.
876      */
877     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
878 
879     /**
880      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
881      *
882      * If an {URI} event was emitted for `id`, the standard
883      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
884      * returned by {IERC1155MetadataURI-uri}.
885      */
886     event URI(string value, uint256 indexed id);
887 
888     /**
889      * @dev Returns the amount of tokens of token type `id` owned by `account`.
890      *
891      * Requirements:
892      *
893      * - `account` cannot be the zero address.
894      */
895     function balanceOf(address account, uint256 id) external view returns (uint256);
896 
897     /**
898      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
899      *
900      * Requirements:
901      *
902      * - `accounts` and `ids` must have the same length.
903      */
904     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
905 
906     /**
907      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
908      *
909      * Emits an {ApprovalForAll} event.
910      *
911      * Requirements:
912      *
913      * - `operator` cannot be the caller.
914      */
915     function setApprovalForAll(address operator, bool approved) external;
916 
917     /**
918      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
919      *
920      * See {setApprovalForAll}.
921      */
922     function isApprovedForAll(address account, address operator) external view returns (bool);
923 
924     /**
925      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
926      *
927      * Emits a {TransferSingle} event.
928      *
929      * Requirements:
930      *
931      * - `to` cannot be the zero address.
932      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
933      * - `from` must have a balance of tokens of type `id` of at least `amount`.
934      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
935      * acceptance magic value.
936      */
937     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
938 
939     /**
940      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
941      *
942      * Emits a {TransferBatch} event.
943      *
944      * Requirements:
945      *
946      * - `ids` and `amounts` must have the same length.
947      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
948      * acceptance magic value.
949      */
950     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
951 }
952 
953 
954 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/extensions/IERC1155MetadataURIUpgradeable.sol
955 
956 /**
957  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
958  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
959  *
960  * _Available since v3.1._
961  */
962 interface IERC1155MetadataURIUpgradeable is IERC1155Upgradeable {
963     /**
964      * @dev Returns the URI for token type `id`.
965      *
966      * If the `\{id\}` substring is present in the URI, it must be replaced by
967      * clients with the actual token type ID.
968      */
969     function uri(uint256 id) external view returns (string memory);
970 }
971 
972 
973 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/IERC1155ReceiverUpgradeable.sol
974 
975 /**
976  * @dev _Available since v3.1._
977  */
978 interface IERC1155ReceiverUpgradeable is IERC165Upgradeable {
979 
980     /**
981         @dev Handles the receipt of a single ERC1155 token type. This function is
982         called at the end of a `safeTransferFrom` after the balance has been updated.
983         To accept the transfer, this must return
984         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
985         (i.e. 0xf23a6e61, or its own function selector).
986         @param operator The address which initiated the transfer (i.e. msg.sender)
987         @param from The address which previously owned the token
988         @param id The ID of the token being transferred
989         @param value The amount of tokens being transferred
990         @param data Additional data with no specified format
991         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
992     */
993     function onERC1155Received(
994         address operator,
995         address from,
996         uint256 id,
997         uint256 value,
998         bytes calldata data
999     )
1000         external
1001         returns(bytes4);
1002 
1003     /**
1004         @dev Handles the receipt of a multiple ERC1155 token types. This function
1005         is called at the end of a `safeBatchTransferFrom` after the balances have
1006         been updated. To accept the transfer(s), this must return
1007         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1008         (i.e. 0xbc197c81, or its own function selector).
1009         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1010         @param from The address which previously owned the token
1011         @param ids An array containing ids of each token being transferred (order and length must match values array)
1012         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1013         @param data Additional data with no specified format
1014         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1015     */
1016     function onERC1155BatchReceived(
1017         address operator,
1018         address from,
1019         uint256[] calldata ids,
1020         uint256[] calldata values,
1021         bytes calldata data
1022     )
1023         external
1024         returns(bytes4);
1025 }
1026 
1027 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/utils/AddressUpgradeable.sol
1028 
1029 /**
1030  * @dev Collection of functions related to the address type
1031  */
1032 library AddressUpgradeable {
1033     /**
1034      * @dev Returns true if `account` is a contract.
1035      *
1036      * [IMPORTANT]
1037      * ====
1038      * It is unsafe to assume that an address for which this function returns
1039      * false is an externally-owned account (EOA) and not a contract.
1040      *
1041      * Among others, `isContract` will return false for the following
1042      * types of addresses:
1043      *
1044      *  - an externally-owned account
1045      *  - a contract in construction
1046      *  - an address where a contract will be created
1047      *  - an address where a contract lived, but was destroyed
1048      * ====
1049      */
1050     function isContract(address account) internal view returns (bool) {
1051         // This method relies on extcodesize, which returns 0 for contracts in
1052         // construction, since the code is only stored at the end of the
1053         // constructor execution.
1054 
1055         uint256 size;
1056         // solhint-disable-next-line no-inline-assembly
1057         assembly { size := extcodesize(account) }
1058         return size > 0;
1059     }
1060 
1061     /**
1062      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1063      * `recipient`, forwarding all available gas and reverting on errors.
1064      *
1065      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1066      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1067      * imposed by `transfer`, making them unable to receive funds via
1068      * `transfer`. {sendValue} removes this limitation.
1069      *
1070      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1071      *
1072      * IMPORTANT: because control is transferred to `recipient`, care must be
1073      * taken to not create reentrancy vulnerabilities. Consider using
1074      * {ReentrancyGuard} or the
1075      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1076      */
1077     function sendValue(address payable recipient, uint256 amount) internal {
1078         require(address(this).balance >= amount, "Address: insufficient balance");
1079 
1080         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1081         (bool success, ) = recipient.call{ value: amount }("");
1082         require(success, "Address: unable to send value, recipient may have reverted");
1083     }
1084 
1085     /**
1086      * @dev Performs a Solidity function call using a low level `call`. A
1087      * plain`call` is an unsafe replacement for a function call: use this
1088      * function instead.
1089      *
1090      * If `target` reverts with a revert reason, it is bubbled up by this
1091      * function (like regular Solidity function calls).
1092      *
1093      * Returns the raw returned data. To convert to the expected return value,
1094      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1095      *
1096      * Requirements:
1097      *
1098      * - `target` must be a contract.
1099      * - calling `target` with `data` must not revert.
1100      *
1101      * _Available since v3.1._
1102      */
1103     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1104       return functionCall(target, data, "Address: low-level call failed");
1105     }
1106 
1107     /**
1108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1109      * `errorMessage` as a fallback revert reason when `target` reverts.
1110      *
1111      * _Available since v3.1._
1112      */
1113     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1114         return functionCallWithValue(target, data, 0, errorMessage);
1115     }
1116 
1117     /**
1118      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1119      * but also transferring `value` wei to `target`.
1120      *
1121      * Requirements:
1122      *
1123      * - the calling contract must have an ETH balance of at least `value`.
1124      * - the called Solidity function must be `payable`.
1125      *
1126      * _Available since v3.1._
1127      */
1128     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1129         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1130     }
1131 
1132     /**
1133      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1134      * with `errorMessage` as a fallback revert reason when `target` reverts.
1135      *
1136      * _Available since v3.1._
1137      */
1138     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1139         require(address(this).balance >= value, "Address: insufficient balance for call");
1140         require(isContract(target), "Address: call to non-contract");
1141 
1142         // solhint-disable-next-line avoid-low-level-calls
1143         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1144         return _verifyCallResult(success, returndata, errorMessage);
1145     }
1146 
1147     /**
1148      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1149      * but performing a static call.
1150      *
1151      * _Available since v3.3._
1152      */
1153     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1154         return functionStaticCall(target, data, "Address: low-level static call failed");
1155     }
1156 
1157     /**
1158      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1159      * but performing a static call.
1160      *
1161      * _Available since v3.3._
1162      */
1163     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1164         require(isContract(target), "Address: static call to non-contract");
1165 
1166         // solhint-disable-next-line avoid-low-level-calls
1167         (bool success, bytes memory returndata) = target.staticcall(data);
1168         return _verifyCallResult(success, returndata, errorMessage);
1169     }
1170 
1171     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1172         if (success) {
1173             return returndata;
1174         } else {
1175             // Look for revert reason and bubble it up if present
1176             if (returndata.length > 0) {
1177                 // The easiest way to bubble the revert reason is using memory via assembly
1178 
1179                 // solhint-disable-next-line no-inline-assembly
1180                 assembly {
1181                     let returndata_size := mload(returndata)
1182                     revert(add(32, returndata), returndata_size)
1183                 }
1184             } else {
1185                 revert(errorMessage);
1186             }
1187         }
1188     }
1189 }
1190 
1191 
1192 
1193 
1194 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/ERC1155Upgradeable.sol
1195 
1196 /**
1197  * @dev Implementation of the basic standard multi-token.
1198  * See https://eips.ethereum.org/EIPS/eip-1155
1199  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1200  *
1201  * _Available since v3.1._
1202  */
1203 contract ERC1155Upgradeable is Initializable, ContextUpgradeable, ERC165Upgradeable, IERC1155Upgradeable, IERC1155MetadataURIUpgradeable {
1204     using AddressUpgradeable for address;
1205 
1206     // Mapping from token ID to account balances
1207     mapping (uint256 => mapping(address => uint256)) private _balances;
1208 
1209     // Mapping from account to operator approvals
1210     mapping (address => mapping(address => bool)) private _operatorApprovals;
1211 
1212     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1213     string private _uri;
1214 
1215     /**
1216      * @dev See {_setURI}.
1217      */
1218     function __ERC1155_init(string memory uri_) internal initializer {
1219         __Context_init_unchained();
1220         __ERC165_init_unchained();
1221         __ERC1155_init_unchained(uri_);
1222     }
1223 
1224     function __ERC1155_init_unchained(string memory uri_) internal initializer {
1225         _setURI(uri_);
1226     }
1227 
1228     /**
1229      * @dev See {IERC165-supportsInterface}.
1230      */
1231     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
1232         return interfaceId == type(IERC1155Upgradeable).interfaceId
1233             || interfaceId == type(IERC1155MetadataURIUpgradeable).interfaceId
1234             || super.supportsInterface(interfaceId);
1235     }
1236 
1237     /**
1238      * @dev See {IERC1155MetadataURI-uri}.
1239      *
1240      * This implementation returns the same URI for *all* token types. It relies
1241      * on the token type ID substitution mechanism
1242      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1243      *
1244      * Clients calling this function must replace the `\{id\}` substring with the
1245      * actual token type ID.
1246      */
1247     function uri(uint256) public view virtual override returns (string memory) {
1248         return _uri;
1249     }
1250 
1251     /**
1252      * @dev See {IERC1155-balanceOf}.
1253      *
1254      * Requirements:
1255      *
1256      * - `account` cannot be the zero address.
1257      */
1258     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1259         require(account != address(0), "ERC1155: balance query for the zero address");
1260         return _balances[id][account];
1261     }
1262 
1263     /**
1264      * @dev See {IERC1155-balanceOfBatch}.
1265      *
1266      * Requirements:
1267      *
1268      * - `accounts` and `ids` must have the same length.
1269      */
1270     function balanceOfBatch(
1271         address[] memory accounts,
1272         uint256[] memory ids
1273     )
1274         public
1275         view
1276         virtual
1277         override
1278         returns (uint256[] memory)
1279     {
1280         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1281 
1282         uint256[] memory batchBalances = new uint256[](accounts.length);
1283 
1284         for (uint256 i = 0; i < accounts.length; ++i) {
1285             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1286         }
1287 
1288         return batchBalances;
1289     }
1290 
1291     /**
1292      * @dev See {IERC1155-setApprovalForAll}.
1293      */
1294     function setApprovalForAll(address operator, bool approved) public virtual override {
1295         require(_msgSender() != operator, "ERC1155: setting approval status for self");
1296 
1297         _operatorApprovals[_msgSender()][operator] = approved;
1298         emit ApprovalForAll(_msgSender(), operator, approved);
1299     }
1300 
1301     /**
1302      * @dev See {IERC1155-isApprovedForAll}.
1303      */
1304     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1305         return _operatorApprovals[account][operator];
1306     }
1307 
1308     /**
1309      * @dev See {IERC1155-safeTransferFrom}.
1310      */
1311     function safeTransferFrom(
1312         address from,
1313         address to,
1314         uint256 id,
1315         uint256 amount,
1316         bytes memory data
1317     )
1318         public
1319         virtual
1320         override
1321     {
1322         require(
1323             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1324             "ERC1155: caller is not owner nor approved"
1325         );
1326         _safeTransferFrom(from, to, id, amount, data);
1327     }
1328 
1329     /**
1330      * @dev See {IERC1155-safeBatchTransferFrom}.
1331      */
1332     function safeBatchTransferFrom(
1333         address from,
1334         address to,
1335         uint256[] memory ids,
1336         uint256[] memory amounts,
1337         bytes memory data
1338     )
1339         public
1340         virtual
1341         override
1342     {
1343         require(
1344             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1345             "ERC1155: transfer caller is not owner nor approved"
1346         );
1347         _safeBatchTransferFrom(from, to, ids, amounts, data);
1348     }
1349 
1350     /**
1351      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1352      *
1353      * Emits a {TransferSingle} event.
1354      *
1355      * Requirements:
1356      *
1357      * - `to` cannot be the zero address.
1358      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1359      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1360      * acceptance magic value.
1361      */
1362     function _safeTransferFrom(
1363         address from,
1364         address to,
1365         uint256 id,
1366         uint256 amount,
1367         bytes memory data
1368     )
1369         internal
1370         virtual
1371     {
1372         require(to != address(0), "ERC1155: transfer to the zero address");
1373 
1374         address operator = _msgSender();
1375 
1376         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1377 
1378         uint256 fromBalance = _balances[id][from];
1379         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1380         unchecked {
1381             _balances[id][from] = fromBalance - amount;
1382         }
1383         _balances[id][to] += amount;
1384 
1385         emit TransferSingle(operator, from, to, id, amount);
1386 
1387         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1388     }
1389 
1390     /**
1391      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1392      *
1393      * Emits a {TransferBatch} event.
1394      *
1395      * Requirements:
1396      *
1397      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1398      * acceptance magic value.
1399      */
1400     function _safeBatchTransferFrom(
1401         address from,
1402         address to,
1403         uint256[] memory ids,
1404         uint256[] memory amounts,
1405         bytes memory data
1406     )
1407         internal
1408         virtual
1409     {
1410         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1411         require(to != address(0), "ERC1155: transfer to the zero address");
1412 
1413         address operator = _msgSender();
1414 
1415         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1416 
1417         for (uint256 i = 0; i < ids.length; ++i) {
1418             uint256 id = ids[i];
1419             uint256 amount = amounts[i];
1420 
1421             uint256 fromBalance = _balances[id][from];
1422             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1423             unchecked {
1424                 _balances[id][from] = fromBalance - amount;
1425             }
1426             _balances[id][to] += amount;
1427         }
1428 
1429         emit TransferBatch(operator, from, to, ids, amounts);
1430 
1431         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1432     }
1433 
1434     /**
1435      * @dev Sets a new URI for all token types, by relying on the token type ID
1436      * substitution mechanism
1437      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1438      *
1439      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1440      * URI or any of the amounts in the JSON file at said URI will be replaced by
1441      * clients with the token type ID.
1442      *
1443      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1444      * interpreted by clients as
1445      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1446      * for token type ID 0x4cce0.
1447      *
1448      * See {uri}.
1449      *
1450      * Because these URIs cannot be meaningfully represented by the {URI} event,
1451      * this function emits no events.
1452      */
1453     function _setURI(string memory newuri) internal virtual {
1454         _uri = newuri;
1455     }
1456 
1457     /**
1458      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1459      *
1460      * Emits a {TransferSingle} event.
1461      *
1462      * Requirements:
1463      *
1464      * - `account` cannot be the zero address.
1465      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1466      * acceptance magic value.
1467      */
1468     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
1469         require(account != address(0), "ERC1155: mint to the zero address");
1470 
1471         address operator = _msgSender();
1472 
1473         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1474 
1475         _balances[id][account] += amount;
1476         emit TransferSingle(operator, address(0), account, id, amount);
1477 
1478         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1479     }
1480 
1481     /**
1482      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1483      *
1484      * Requirements:
1485      *
1486      * - `ids` and `amounts` must have the same length.
1487      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1488      * acceptance magic value.
1489      */
1490     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
1491         require(to != address(0), "ERC1155: mint to the zero address");
1492         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1493 
1494         address operator = _msgSender();
1495 
1496         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1497 
1498         for (uint i = 0; i < ids.length; i++) {
1499             _balances[ids[i]][to] += amounts[i];
1500         }
1501 
1502         emit TransferBatch(operator, address(0), to, ids, amounts);
1503 
1504         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1505     }
1506 
1507     /**
1508      * @dev Destroys `amount` tokens of token type `id` from `account`
1509      *
1510      * Requirements:
1511      *
1512      * - `account` cannot be the zero address.
1513      * - `account` must have at least `amount` tokens of token type `id`.
1514      */
1515     function _burn(address account, uint256 id, uint256 amount) internal virtual {
1516         require(account != address(0), "ERC1155: burn from the zero address");
1517 
1518         address operator = _msgSender();
1519 
1520         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1521 
1522         uint256 accountBalance = _balances[id][account];
1523         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1524         unchecked {
1525             _balances[id][account] = accountBalance - amount;
1526         }
1527 
1528         emit TransferSingle(operator, account, address(0), id, amount);
1529     }
1530 
1531     /**
1532      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1533      *
1534      * Requirements:
1535      *
1536      * - `ids` and `amounts` must have the same length.
1537      */
1538     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
1539         require(account != address(0), "ERC1155: burn from the zero address");
1540         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1541 
1542         address operator = _msgSender();
1543 
1544         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1545 
1546         for (uint i = 0; i < ids.length; i++) {
1547             uint256 id = ids[i];
1548             uint256 amount = amounts[i];
1549 
1550             uint256 accountBalance = _balances[id][account];
1551             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1552             unchecked {
1553                 _balances[id][account] = accountBalance - amount;
1554             }
1555         }
1556 
1557         emit TransferBatch(operator, account, address(0), ids, amounts);
1558     }
1559 
1560     /**
1561      * @dev Hook that is called before any token transfer. This includes minting
1562      * and burning, as well as batched variants.
1563      *
1564      * The same hook is called on both single and batched variants. For single
1565      * transfers, the length of the `id` and `amount` arrays will be 1.
1566      *
1567      * Calling conditions (for each `id` and `amount` pair):
1568      *
1569      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1570      * of token type `id` will be  transferred to `to`.
1571      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1572      * for `to`.
1573      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1574      * will be burned.
1575      * - `from` and `to` are never both zero.
1576      * - `ids` and `amounts` have the same, non-zero length.
1577      *
1578      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1579      */
1580     function _beforeTokenTransfer(
1581         address operator,
1582         address from,
1583         address to,
1584         uint256[] memory ids,
1585         uint256[] memory amounts,
1586         bytes memory data
1587     )
1588         internal
1589         virtual
1590     { }
1591 
1592     function _doSafeTransferAcceptanceCheck(
1593         address operator,
1594         address from,
1595         address to,
1596         uint256 id,
1597         uint256 amount,
1598         bytes memory data
1599     )
1600         private
1601     {
1602         if (to.isContract()) {
1603             try IERC1155ReceiverUpgradeable(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1604                 if (response != IERC1155ReceiverUpgradeable(to).onERC1155Received.selector) {
1605                     revert("ERC1155: ERC1155Receiver rejected tokens");
1606                 }
1607             } catch Error(string memory reason) {
1608                 revert(reason);
1609             } catch {
1610                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1611             }
1612         }
1613     }
1614 
1615     function _doSafeBatchTransferAcceptanceCheck(
1616         address operator,
1617         address from,
1618         address to,
1619         uint256[] memory ids,
1620         uint256[] memory amounts,
1621         bytes memory data
1622     )
1623         private
1624     {
1625         if (to.isContract()) {
1626             try IERC1155ReceiverUpgradeable(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1627                 if (response != IERC1155ReceiverUpgradeable(to).onERC1155BatchReceived.selector) {
1628                     revert("ERC1155: ERC1155Receiver rejected tokens");
1629                 }
1630             } catch Error(string memory reason) {
1631                 revert(reason);
1632             } catch {
1633                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1634             }
1635         }
1636     }
1637 
1638     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1639         uint256[] memory array = new uint256[](1);
1640         array[0] = element;
1641 
1642         return array;
1643     }
1644     uint256[47] private __gap;
1645 }
1646 
1647 
1648 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol
1649 
1650 /**
1651  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1652  * own tokens and those that they have been approved to use.
1653  *
1654  * _Available since v3.1._
1655  */
1656 abstract contract ERC1155BurnableUpgradeable is Initializable, ERC1155Upgradeable {
1657     function __ERC1155Burnable_init() internal initializer {
1658         __Context_init_unchained();
1659         __ERC165_init_unchained();
1660         __ERC1155Burnable_init_unchained();
1661     }
1662 
1663     function __ERC1155Burnable_init_unchained() internal initializer {
1664     }
1665     function burn(address account, uint256 id, uint256 value) public virtual {
1666         require(
1667             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1668             "ERC1155: caller is not owner nor approved"
1669         );
1670 
1671         _burn(account, id, value);
1672     }
1673 
1674     function burnBatch(address account, uint256[] memory ids, uint256[] memory values) public virtual {
1675         require(
1676             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1677             "ERC1155: caller is not owner nor approved"
1678         );
1679 
1680         _burnBatch(account, ids, values);
1681     }
1682     uint256[50] private __gap;
1683 }
1684 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/security/PausableUpgradeable.sol
1685 
1686 /**
1687  * @dev Contract module which allows children to implement an emergency stop
1688  * mechanism that can be triggered by an authorized account.
1689  *
1690  * This module is used through inheritance. It will make available the
1691  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1692  * the functions of your contract. Note that they will not be pausable by
1693  * simply including this module, only once the modifiers are put in place.
1694  */
1695 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
1696     /**
1697      * @dev Emitted when the pause is triggered by `account`.
1698      */
1699     event Paused(address account);
1700 
1701     /**
1702      * @dev Emitted when the pause is lifted by `account`.
1703      */
1704     event Unpaused(address account);
1705 
1706     bool private _paused;
1707 
1708     /**
1709      * @dev Initializes the contract in unpaused state.
1710      */
1711     function __Pausable_init() internal initializer {
1712         __Context_init_unchained();
1713         __Pausable_init_unchained();
1714     }
1715 
1716     function __Pausable_init_unchained() internal initializer {
1717         _paused = false;
1718     }
1719 
1720     /**
1721      * @dev Returns true if the contract is paused, and false otherwise.
1722      */
1723     function paused() public view virtual returns (bool) {
1724         return _paused;
1725     }
1726 
1727     /**
1728      * @dev Modifier to make a function callable only when the contract is not paused.
1729      *
1730      * Requirements:
1731      *
1732      * - The contract must not be paused.
1733      */
1734     modifier whenNotPaused() {
1735         require(!paused(), "Pausable: paused");
1736         _;
1737     }
1738 
1739     /**
1740      * @dev Modifier to make a function callable only when the contract is paused.
1741      *
1742      * Requirements:
1743      *
1744      * - The contract must be paused.
1745      */
1746     modifier whenPaused() {
1747         require(paused(), "Pausable: not paused");
1748         _;
1749     }
1750 
1751     /**
1752      * @dev Triggers stopped state.
1753      *
1754      * Requirements:
1755      *
1756      * - The contract must not be paused.
1757      */
1758     function _pause() internal virtual whenNotPaused {
1759         _paused = true;
1760         emit Paused(_msgSender());
1761     }
1762 
1763     /**
1764      * @dev Returns to normal state.
1765      *
1766      * Requirements:
1767      *
1768      * - The contract must be paused.
1769      */
1770     function _unpause() internal virtual whenPaused {
1771         _paused = false;
1772         emit Unpaused(_msgSender());
1773     }
1774     uint256[49] private __gap;
1775 }
1776 
1777 
1778 
1779 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/extensions/ERC1155PausableUpgradeable.sol
1780 
1781 /**
1782  * @dev ERC1155 token with pausable token transfers, minting and burning.
1783  *
1784  * Useful for scenarios such as preventing trades until the end of an evaluation
1785  * period, or having an emergency switch for freezing all token transfers in the
1786  * event of a large bug.
1787  *
1788  * _Available since v3.1._
1789  */
1790 abstract contract ERC1155PausableUpgradeable is Initializable, ERC1155Upgradeable, PausableUpgradeable {
1791     function __ERC1155Pausable_init() internal initializer {
1792         __Context_init_unchained();
1793         __ERC165_init_unchained();
1794         __Pausable_init_unchained();
1795         __ERC1155Pausable_init_unchained();
1796     }
1797 
1798     function __ERC1155Pausable_init_unchained() internal initializer {
1799     }
1800     /**
1801      * @dev See {ERC1155-_beforeTokenTransfer}.
1802      *
1803      * Requirements:
1804      *
1805      * - the contract must not be paused.
1806      */
1807     function _beforeTokenTransfer(
1808         address operator,
1809         address from,
1810         address to,
1811         uint256[] memory ids,
1812         uint256[] memory amounts,
1813         bytes memory data
1814     )
1815         internal
1816         virtual
1817         override
1818     {
1819         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1820 
1821         require(!paused(), "ERC1155Pausable: token transfer while paused");
1822     }
1823     uint256[50] private __gap;
1824 }
1825 
1826 
1827 
1828 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol
1829 
1830 /**
1831  * @dev Contract module which provides a basic access control mechanism, where
1832  * there is an account (an owner) that can be granted exclusive access to
1833  * specific functions.
1834  *
1835  * By default, the owner account will be the one that deploys the contract. This
1836  * can later be changed with {transferOwnership}.
1837  *
1838  * This module is used through inheritance. It will make available the modifier
1839  * `onlyOwner`, which can be applied to your functions to restrict their use to
1840  * the owner.
1841  */
1842 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1843     address private _owner;
1844 
1845     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1846 
1847     /**
1848      * @dev Initializes the contract setting the deployer as the initial owner.
1849      */
1850     function __Ownable_init() internal initializer {
1851         __Context_init_unchained();
1852         __Ownable_init_unchained();
1853     }
1854 
1855     function __Ownable_init_unchained() internal initializer {
1856         address msgSender = _msgSender();
1857         _owner = msgSender;
1858         emit OwnershipTransferred(address(0), msgSender);
1859     }
1860 
1861     /**
1862      * @dev Returns the address of the current owner.
1863      */
1864     function owner() public view virtual returns (address) {
1865         return _owner;
1866     }
1867 
1868     /**
1869      * @dev Throws if called by any account other than the owner.
1870      */
1871     modifier onlyOwner() {
1872         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1873         _;
1874     }
1875 
1876     /**
1877      * @dev Leaves the contract without owner. It will not be possible to call
1878      * `onlyOwner` functions anymore. Can only be called by the current owner.
1879      *
1880      * NOTE: Renouncing ownership will leave the contract without an owner,
1881      * thereby removing any functionality that is only available to the owner.
1882      */
1883     function renounceOwnership() public virtual onlyOwner {
1884         emit OwnershipTransferred(_owner, address(0));
1885         _owner = address(0);
1886     }
1887 
1888     /**
1889      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1890      * Can only be called by the current owner.
1891      */
1892     function transferOwnership(address newOwner) public virtual onlyOwner {
1893         require(newOwner != address(0), "Ownable: new owner is the zero address");
1894         emit OwnershipTransferred(_owner, newOwner);
1895         _owner = newOwner;
1896     }
1897     uint256[49] private __gap;
1898 }
1899 
1900 
1901 // File: .deps/github/OpenZeppelin/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/presets/ERC1155PresetMinterPauserUpgradeable.sol
1902 
1903 /**
1904  * @dev {ERC1155} token, including:
1905  *
1906  *  - ability for holders to burn (destroy) their tokens
1907  *  - a minter role that allows for token minting (creation)
1908  *  - a pauser role that allows to stop all token transfers
1909  *
1910  * This contract uses {AccessControl} to lock permissioned functions using the
1911  * different roles - head to its documentation for details.
1912  *
1913  * The account that deploys the contract will be granted the minter and pauser
1914  * roles, as well as the default admin role, which will let it grant both minter
1915  * and pauser roles to other accounts.
1916  */
1917 
1918 contract ERC1155PresetMinterPauserUpgradeable is Initializable, ContextUpgradeable, AccessControlEnumerableUpgradeable, ERC1155BurnableUpgradeable, ERC1155PausableUpgradeable, OwnableUpgradeable {
1919     function initialize(string memory uri) public virtual initializer {
1920         __ERC1155PresetMinterPauser_init(uri);
1921     }
1922     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1923     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1924 
1925     /**
1926      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE`, and `PAUSER_ROLE` to the account that
1927      * deploys the contract.
1928      */
1929     function __ERC1155PresetMinterPauser_init(string memory uri) internal initializer {
1930         __Context_init_unchained();
1931         __ERC165_init_unchained();
1932         __AccessControl_init_unchained();
1933         __AccessControlEnumerable_init_unchained();
1934         __Ownable_init_unchained();
1935         __ERC1155_init_unchained(uri);
1936         __ERC1155Burnable_init_unchained();
1937         __Pausable_init_unchained();
1938         __ERC1155Pausable_init_unchained();
1939         __ERC1155PresetMinterPauser_init_unchained(uri);
1940     }
1941 
1942     function __ERC1155PresetMinterPauser_init_unchained(string memory /*uri*/) internal initializer {
1943         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1944         _setupRole(MINTER_ROLE, _msgSender());
1945         _setupRole(PAUSER_ROLE, _msgSender());
1946     }
1947 
1948     /**
1949      * @dev Creates `amount` new tokens for `to`, of token type `id`.
1950      *
1951      * See {ERC1155-_mint}.
1952      *
1953      * Requirements:
1954      *
1955      * - the caller must have the `MINTER_ROLE`.
1956      */
1957 
1958     function mint(address to, uint256 id, uint256 amount, bytes memory data) public virtual {
1959         require(hasRole(MINTER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have minter role to mint");
1960 
1961         _mint(to, id, amount, data);
1962     }
1963 
1964     /**
1965      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] variant of {mint}.
1966      */
1967     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public virtual {
1968         require(hasRole(MINTER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have minter role to mint");
1969 
1970         _mintBatch(to, ids, amounts, data);
1971     }
1972     function setURI(string memory _newURI) public onlyOwner {
1973         _setURI(_newURI);
1974     }
1975     /**
1976      * @dev Pauses all token transfers.
1977      *
1978      * See {ERC1155Pausable} and {Pausable-_pause}.
1979      *
1980      * Requirements:
1981      *
1982      * - the caller must have the `PAUSER_ROLE`.
1983      */
1984     function pause() public virtual {
1985         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have pauser role to pause");
1986         _pause();
1987     }
1988 
1989     /**
1990      * @dev Unpauses all token transfers.
1991      *
1992      * See {ERC1155Pausable} and {Pausable-_unpause}.
1993      *
1994      * Requirements:
1995      *
1996      * - the caller must have the `PAUSER_ROLE`.
1997      */
1998     function unpause() public virtual {
1999         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have pauser role to unpause");
2000         _unpause();
2001     }
2002 
2003     /**
2004      * @dev See {IERC165-supportsInterface}.
2005      */
2006     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerableUpgradeable, ERC1155Upgradeable) returns (bool) {
2007         return super.supportsInterface(interfaceId);
2008     }
2009 
2010     function _beforeTokenTransfer(
2011         address operator,
2012         address from,
2013         address to,
2014         uint256[] memory ids,
2015         uint256[] memory amounts,
2016         bytes memory data
2017     )
2018         internal virtual override(ERC1155Upgradeable, ERC1155PausableUpgradeable)
2019     {
2020         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
2021     }
2022     uint256[50] private __gap;
2023 }