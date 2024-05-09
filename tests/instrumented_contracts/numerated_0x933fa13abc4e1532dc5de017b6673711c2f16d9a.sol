1 // Sources flattened with hardhat v2.6.7 https://hardhat.org
2 
3 // File contracts/OpenZeppelin/utils/ReentrancyGuard.sol
4 
5 pragma solidity 0.6.12;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor () internal {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and make it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 
67 // File contracts/OpenZeppelin/utils/EnumerableSet.sol
68 
69 pragma solidity 0.6.12;
70 
71 /**
72  * @dev Library for managing
73  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
74  * types.
75  *
76  * Sets have the following properties:
77  *
78  * - Elements are added, removed, and checked for existence in constant time
79  * (O(1)).
80  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
81  *
82  * ```
83  * contract Example {
84  *     // Add the library methods
85  *     using EnumerableSet for EnumerableSet.AddressSet;
86  *
87  *     // Declare a set state variable
88  *     EnumerableSet.AddressSet private mySet;
89  * }
90  * ```
91  *
92  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
93  * and `uint256` (`UintSet`) are supported.
94  */
95 library EnumerableSet {
96     // To implement this library for multiple types with as little code
97     // repetition as possible, we write it in terms of a generic Set type with
98     // bytes32 values.
99     // The Set implementation uses private functions, and user-facing
100     // implementations (such as AddressSet) are just wrappers around the
101     // underlying Set.
102     // This means that we can only create new EnumerableSets for types that fit
103     // in bytes32.
104 
105     struct Set {
106         // Storage of set values
107         bytes32[] _values;
108 
109         // Position of the value in the `values` array, plus 1 because index 0
110         // means a value is not in the set.
111         mapping (bytes32 => uint256) _indexes;
112     }
113 
114     /**
115      * @dev Add a value to a set. O(1).
116      *
117      * Returns true if the value was added to the set, that is if it was not
118      * already present.
119      */
120     function _add(Set storage set, bytes32 value) private returns (bool) {
121         if (!_contains(set, value)) {
122             set._values.push(value);
123             // The value is stored at length-1, but we add 1 to all indexes
124             // and use 0 as a sentinel value
125             set._indexes[value] = set._values.length;
126             return true;
127         } else {
128             return false;
129         }
130     }
131 
132     /**
133      * @dev Removes a value from a set. O(1).
134      *
135      * Returns true if the value was removed from the set, that is if it was
136      * present.
137      */
138     function _remove(Set storage set, bytes32 value) private returns (bool) {
139         // We read and store the value's index to prevent multiple reads from the same storage slot
140         uint256 valueIndex = set._indexes[value];
141 
142         if (valueIndex != 0) { // Equivalent to contains(set, value)
143             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
144             // the array, and then remove the last element (sometimes called as 'swap and pop').
145             // This modifies the order of the array, as noted in {at}.
146 
147             uint256 toDeleteIndex = valueIndex - 1;
148             uint256 lastIndex = set._values.length - 1;
149 
150             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
151             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
152 
153             bytes32 lastvalue = set._values[lastIndex];
154 
155             // Move the last value to the index where the value to delete is
156             set._values[toDeleteIndex] = lastvalue;
157             // Update the index for the moved value
158             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
159 
160             // Delete the slot where the moved value was stored
161             set._values.pop();
162 
163             // Delete the index for the deleted slot
164             delete set._indexes[value];
165 
166             return true;
167         } else {
168             return false;
169         }
170     }
171 
172     /**
173      * @dev Returns true if the value is in the set. O(1).
174      */
175     function _contains(Set storage set, bytes32 value) private view returns (bool) {
176         return set._indexes[value] != 0;
177     }
178 
179     /**
180      * @dev Returns the number of values on the set. O(1).
181      */
182     function _length(Set storage set) private view returns (uint256) {
183         return set._values.length;
184     }
185 
186    /**
187     * @dev Returns the value stored at position `index` in the set. O(1).
188     *
189     * Note that there are no guarantees on the ordering of values inside the
190     * array, and it may change when more values are added or removed.
191     *
192     * Requirements:
193     *
194     * - `index` must be strictly less than {length}.
195     */
196     function _at(Set storage set, uint256 index) private view returns (bytes32) {
197         require(set._values.length > index, "EnumerableSet: index out of bounds");
198         return set._values[index];
199     }
200 
201     // Bytes32Set
202 
203     struct Bytes32Set {
204         Set _inner;
205     }
206 
207     /**
208      * @dev Add a value to a set. O(1).
209      *
210      * Returns true if the value was added to the set, that is if it was not
211      * already present.
212      */
213     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
214         return _add(set._inner, value);
215     }
216 
217     /**
218      * @dev Removes a value from a set. O(1).
219      *
220      * Returns true if the value was removed from the set, that is if it was
221      * present.
222      */
223     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
224         return _remove(set._inner, value);
225     }
226 
227     /**
228      * @dev Returns true if the value is in the set. O(1).
229      */
230     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
231         return _contains(set._inner, value);
232     }
233 
234     /**
235      * @dev Returns the number of values in the set. O(1).
236      */
237     function length(Bytes32Set storage set) internal view returns (uint256) {
238         return _length(set._inner);
239     }
240 
241    /**
242     * @dev Returns the value stored at position `index` in the set. O(1).
243     *
244     * Note that there are no guarantees on the ordering of values inside the
245     * array, and it may change when more values are added or removed.
246     *
247     * Requirements:
248     *
249     * - `index` must be strictly less than {length}.
250     */
251     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
252         return _at(set._inner, index);
253     }
254 
255     // AddressSet
256 
257     struct AddressSet {
258         Set _inner;
259     }
260 
261     /**
262      * @dev Add a value to a set. O(1).
263      *
264      * Returns true if the value was added to the set, that is if it was not
265      * already present.
266      */
267     function add(AddressSet storage set, address value) internal returns (bool) {
268         return _add(set._inner, bytes32(uint256(uint160(value))));
269     }
270 
271     /**
272      * @dev Removes a value from a set. O(1).
273      *
274      * Returns true if the value was removed from the set, that is if it was
275      * present.
276      */
277     function remove(AddressSet storage set, address value) internal returns (bool) {
278         return _remove(set._inner, bytes32(uint256(uint160(value))));
279     }
280 
281     /**
282      * @dev Returns true if the value is in the set. O(1).
283      */
284     function contains(AddressSet storage set, address value) internal view returns (bool) {
285         return _contains(set._inner, bytes32(uint256(uint160(value))));
286     }
287 
288     /**
289      * @dev Returns the number of values in the set. O(1).
290      */
291     function length(AddressSet storage set) internal view returns (uint256) {
292         return _length(set._inner);
293     }
294 
295    /**
296     * @dev Returns the value stored at position `index` in the set. O(1).
297     *
298     * Note that there are no guarantees on the ordering of values inside the
299     * array, and it may change when more values are added or removed.
300     *
301     * Requirements:
302     *
303     * - `index` must be strictly less than {length}.
304     */
305     function at(AddressSet storage set, uint256 index) internal view returns (address) {
306         return address(uint160(uint256(_at(set._inner, index))));
307     }
308 
309 
310     // UintSet
311 
312     struct UintSet {
313         Set _inner;
314     }
315 
316     /**
317      * @dev Add a value to a set. O(1).
318      *
319      * Returns true if the value was added to the set, that is if it was not
320      * already present.
321      */
322     function add(UintSet storage set, uint256 value) internal returns (bool) {
323         return _add(set._inner, bytes32(value));
324     }
325 
326     /**
327      * @dev Removes a value from a set. O(1).
328      *
329      * Returns true if the value was removed from the set, that is if it was
330      * present.
331      */
332     function remove(UintSet storage set, uint256 value) internal returns (bool) {
333         return _remove(set._inner, bytes32(value));
334     }
335 
336     /**
337      * @dev Returns true if the value is in the set. O(1).
338      */
339     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
340         return _contains(set._inner, bytes32(value));
341     }
342 
343     /**
344      * @dev Returns the number of values on the set. O(1).
345      */
346     function length(UintSet storage set) internal view returns (uint256) {
347         return _length(set._inner);
348     }
349 
350    /**
351     * @dev Returns the value stored at position `index` in the set. O(1).
352     *
353     * Note that there are no guarantees on the ordering of values inside the
354     * array, and it may change when more values are added or removed.
355     *
356     * Requirements:
357     *
358     * - `index` must be strictly less than {length}.
359     */
360     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
361         return uint256(_at(set._inner, index));
362     }
363 }
364 
365 
366 // File contracts/OpenZeppelin/utils/Context.sol
367 
368 pragma solidity 0.6.12;
369 
370 /*
371  * @dev Provides information about the current execution context, including the
372  * sender of the transaction and its data. While these are generally available
373  * via msg.sender and msg.data, they should not be accessed in such a direct
374  * manner, since when dealing with GSN meta-transactions the account sending and
375  * paying for execution may not be the actual sender (as far as an application
376  * is concerned).
377  *
378  * This contract is only required for intermediate, library-like contracts.
379  */
380 abstract contract Context {
381     function _msgSender() internal view virtual returns (address payable) {
382         return msg.sender;
383     }
384 
385     function _msgData() internal view virtual returns (bytes memory) {
386         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
387         return msg.data;
388     }
389 }
390 
391 
392 // File contracts/OpenZeppelin/access/AccessControl.sol
393 
394 pragma solidity 0.6.12;
395 
396 
397 /**
398  * @dev Contract module that allows children to implement role-based access
399  * control mechanisms.
400  *
401  * Roles are referred to by their `bytes32` identifier. These should be exposed
402  * in the external API and be unique. The best way to achieve this is by
403  * using `public constant` hash digests:
404  *
405  * ```
406  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
407  * ```
408  *
409  * Roles can be used to represent a set of permissions. To restrict access to a
410  * function call, use {hasRole}:
411  *
412  * ```
413  * function foo() public {
414  *     require(hasRole(MY_ROLE, msg.sender));
415  *     ...
416  * }
417  * ```
418  *
419  * Roles can be granted and revoked dynamically via the {grantRole} and
420  * {revokeRole} functions. Each role has an associated admin role, and only
421  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
422  *
423  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
424  * that only accounts with this role will be able to grant or revoke other
425  * roles. More complex role relationships can be created by using
426  * {_setRoleAdmin}.
427  *
428  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
429  * grant and revoke this role. Extra precautions should be taken to secure
430  * accounts that have been granted it.
431  */
432 abstract contract AccessControl is Context {
433     using EnumerableSet for EnumerableSet.AddressSet;
434 
435     struct RoleData {
436         EnumerableSet.AddressSet members;
437         bytes32 adminRole;
438     }
439 
440     mapping (bytes32 => RoleData) private _roles;
441 
442     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
443 
444     /**
445      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
446      *
447      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
448      * {RoleAdminChanged} not being emitted signaling this.
449      *
450      * _Available since v3.1._
451      */
452     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
453 
454     /**
455      * @dev Emitted when `account` is granted `role`.
456      *
457      * `sender` is the account that originated the contract call, an admin role
458      * bearer except when using {_setupRole}.
459      */
460     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
461 
462     /**
463      * @dev Emitted when `account` is revoked `role`.
464      *
465      * `sender` is the account that originated the contract call:
466      *   - if using `revokeRole`, it is the admin role bearer
467      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
468      */
469     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
470 
471     /**
472      * @dev Returns `true` if `account` has been granted `role`.
473      */
474     function hasRole(bytes32 role, address account) public view returns (bool) {
475         return _roles[role].members.contains(account);
476     }
477 
478     /**
479      * @dev Returns the number of accounts that have `role`. Can be used
480      * together with {getRoleMember} to enumerate all bearers of a role.
481      */
482     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
483         return _roles[role].members.length();
484     }
485 
486     /**
487      * @dev Returns one of the accounts that have `role`. `index` must be a
488      * value between 0 and {getRoleMemberCount}, non-inclusive.
489      *
490      * Role bearers are not sorted in any particular way, and their ordering may
491      * change at any point.
492      *
493      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
494      * you perform all queries on the same block. See the following
495      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
496      * for more information.
497      */
498     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
499         return _roles[role].members.at(index);
500     }
501 
502     /**
503      * @dev Returns the admin role that controls `role`. See {grantRole} and
504      * {revokeRole}.
505      *
506      * To change a role's admin, use {_setRoleAdmin}.
507      */
508     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
509         return _roles[role].adminRole;
510     }
511 
512     /**
513      * @dev Grants `role` to `account`.
514      *
515      * If `account` had not been already granted `role`, emits a {RoleGranted}
516      * event.
517      *
518      * Requirements:
519      *
520      * - the caller must have ``role``'s admin role.
521      */
522     function grantRole(bytes32 role, address account) public virtual {
523         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
524 
525         _grantRole(role, account);
526     }
527 
528     /**
529      * @dev Revokes `role` from `account`.
530      *
531      * If `account` had been granted `role`, emits a {RoleRevoked} event.
532      *
533      * Requirements:
534      *
535      * - the caller must have ``role``'s admin role.
536      */
537     function revokeRole(bytes32 role, address account) public virtual {
538         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
539 
540         _revokeRole(role, account);
541     }
542 
543     /**
544      * @dev Revokes `role` from the calling account.
545      *
546      * Roles are often managed via {grantRole} and {revokeRole}: this function's
547      * purpose is to provide a mechanism for accounts to lose their privileges
548      * if they are compromised (such as when a trusted device is misplaced).
549      *
550      * If the calling account had been granted `role`, emits a {RoleRevoked}
551      * event.
552      *
553      * Requirements:
554      *
555      * - the caller must be `account`.
556      */
557     function renounceRole(bytes32 role, address account) public virtual {
558         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
559 
560         _revokeRole(role, account);
561     }
562 
563     /**
564      * @dev Grants `role` to `account`.
565      *
566      * If `account` had not been already granted `role`, emits a {RoleGranted}
567      * event. Note that unlike {grantRole}, this function doesn't perform any
568      * checks on the calling account.
569      *
570      * [WARNING]
571      * ====
572      * This function should only be called from the constructor when setting
573      * up the initial roles for the system.
574      *
575      * Using this function in any other way is effectively circumventing the admin
576      * system imposed by {AccessControl}.
577      * ====
578      */
579     function _setupRole(bytes32 role, address account) internal virtual {
580         _grantRole(role, account);
581     }
582 
583     /**
584      * @dev Sets `adminRole` as ``role``'s admin role.
585      *
586      * Emits a {RoleAdminChanged} event.
587      */
588     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
589         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
590         _roles[role].adminRole = adminRole;
591     }
592 
593     function _grantRole(bytes32 role, address account) private {
594         if (_roles[role].members.add(account)) {
595             emit RoleGranted(role, account, _msgSender());
596         }
597     }
598 
599     function _revokeRole(bytes32 role, address account) private {
600         if (_roles[role].members.remove(account)) {
601             emit RoleRevoked(role, account, _msgSender());
602         }
603     }
604 }
605 
606 
607 // File contracts/Access/MISOAdminAccess.sol
608 
609 pragma solidity 0.6.12;
610 
611 contract MISOAdminAccess is AccessControl {
612 
613     /// @dev Whether access is initialised.
614     bool private initAccess;
615 
616     /// @notice Events for adding and removing various roles.
617     event AdminRoleGranted(
618         address indexed beneficiary,
619         address indexed caller
620     );
621 
622     event AdminRoleRemoved(
623         address indexed beneficiary,
624         address indexed caller
625     );
626 
627 
628     /// @notice The deployer is automatically given the admin role which will allow them to then grant roles to other addresses.
629     constructor() public {
630     }
631 
632     /**
633      * @notice Initializes access controls.
634      * @param _admin Admins address.
635      */
636     function initAccessControls(address _admin) public {
637         require(!initAccess, "Already initialised");
638         require(_admin != address(0), "Incorrect input");
639         _setupRole(DEFAULT_ADMIN_ROLE, _admin);
640         initAccess = true;
641     }
642 
643     /////////////
644     // Lookups //
645     /////////////
646 
647     /**
648      * @notice Used to check whether an address has the admin role.
649      * @param _address EOA or contract being checked.
650      * @return bool True if the account has the role or false if it does not.
651      */
652     function hasAdminRole(address _address) public  view returns (bool) {
653         return hasRole(DEFAULT_ADMIN_ROLE, _address);
654     }
655 
656     ///////////////
657     // Modifiers //
658     ///////////////
659 
660     /**
661      * @notice Grants the admin role to an address.
662      * @dev The sender must have the admin role.
663      * @param _address EOA or contract receiving the new role.
664      */
665     function addAdminRole(address _address) external {
666         grantRole(DEFAULT_ADMIN_ROLE, _address);
667         emit AdminRoleGranted(_address, _msgSender());
668     }
669 
670     /**
671      * @notice Removes the admin role from an address.
672      * @dev The sender must have the admin role.
673      * @param _address EOA or contract affected.
674      */
675     function removeAdminRole(address _address) external {
676         revokeRole(DEFAULT_ADMIN_ROLE, _address);
677         emit AdminRoleRemoved(_address, _msgSender());
678     }
679 }
680 
681 
682 // File contracts/Access/MISOAccessControls.sol
683 
684 pragma solidity 0.6.12;
685 
686 /**
687  * @notice Access Controls
688  * @author Attr: BlockRocket.tech
689  */
690 contract MISOAccessControls is MISOAdminAccess {
691     /// @notice Role definitions
692     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
693     bytes32 public constant SMART_CONTRACT_ROLE = keccak256("SMART_CONTRACT_ROLE");
694     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
695 
696     /// @notice Events for adding and removing various roles
697 
698     event MinterRoleGranted(
699         address indexed beneficiary,
700         address indexed caller
701     );
702 
703     event MinterRoleRemoved(
704         address indexed beneficiary,
705         address indexed caller
706     );
707 
708     event OperatorRoleGranted(
709         address indexed beneficiary,
710         address indexed caller
711     );
712 
713     event OperatorRoleRemoved(
714         address indexed beneficiary,
715         address indexed caller
716     );
717 
718     event SmartContractRoleGranted(
719         address indexed beneficiary,
720         address indexed caller
721     );
722 
723     event SmartContractRoleRemoved(
724         address indexed beneficiary,
725         address indexed caller
726     );
727 
728     /**
729      * @notice The deployer is automatically given the admin role which will allow them to then grant roles to other addresses
730      */
731     constructor() public {
732     }
733 
734 
735     /////////////
736     // Lookups //
737     /////////////
738 
739     /**
740      * @notice Used to check whether an address has the minter role
741      * @param _address EOA or contract being checked
742      * @return bool True if the account has the role or false if it does not
743      */
744     function hasMinterRole(address _address) public view returns (bool) {
745         return hasRole(MINTER_ROLE, _address);
746     }
747 
748     /**
749      * @notice Used to check whether an address has the smart contract role
750      * @param _address EOA or contract being checked
751      * @return bool True if the account has the role or false if it does not
752      */
753     function hasSmartContractRole(address _address) public view returns (bool) {
754         return hasRole(SMART_CONTRACT_ROLE, _address);
755     }
756 
757     /**
758      * @notice Used to check whether an address has the operator role
759      * @param _address EOA or contract being checked
760      * @return bool True if the account has the role or false if it does not
761      */
762     function hasOperatorRole(address _address) public view returns (bool) {
763         return hasRole(OPERATOR_ROLE, _address);
764     }
765 
766     ///////////////
767     // Modifiers //
768     ///////////////
769 
770     /**
771      * @notice Grants the minter role to an address
772      * @dev The sender must have the admin role
773      * @param _address EOA or contract receiving the new role
774      */
775     function addMinterRole(address _address) external {
776         grantRole(MINTER_ROLE, _address);
777         emit MinterRoleGranted(_address, _msgSender());
778     }
779 
780     /**
781      * @notice Removes the minter role from an address
782      * @dev The sender must have the admin role
783      * @param _address EOA or contract affected
784      */
785     function removeMinterRole(address _address) external {
786         revokeRole(MINTER_ROLE, _address);
787         emit MinterRoleRemoved(_address, _msgSender());
788     }
789 
790     /**
791      * @notice Grants the smart contract role to an address
792      * @dev The sender must have the admin role
793      * @param _address EOA or contract receiving the new role
794      */
795     function addSmartContractRole(address _address) external {
796         grantRole(SMART_CONTRACT_ROLE, _address);
797         emit SmartContractRoleGranted(_address, _msgSender());
798     }
799 
800     /**
801      * @notice Removes the smart contract role from an address
802      * @dev The sender must have the admin role
803      * @param _address EOA or contract affected
804      */
805     function removeSmartContractRole(address _address) external {
806         revokeRole(SMART_CONTRACT_ROLE, _address);
807         emit SmartContractRoleRemoved(_address, _msgSender());
808     }
809 
810     /**
811      * @notice Grants the operator role to an address
812      * @dev The sender must have the admin role
813      * @param _address EOA or contract receiving the new role
814      */
815     function addOperatorRole(address _address) external {
816         grantRole(OPERATOR_ROLE, _address);
817         emit OperatorRoleGranted(_address, _msgSender());
818     }
819 
820     /**
821      * @notice Removes the operator role from an address
822      * @dev The sender must have the admin role
823      * @param _address EOA or contract affected
824      */
825     function removeOperatorRole(address _address) external {
826         revokeRole(OPERATOR_ROLE, _address);
827         emit OperatorRoleRemoved(_address, _msgSender());
828     }
829 
830 }
831 
832 
833 // File contracts/Utils/SafeTransfer.sol
834 
835 pragma solidity 0.6.12;
836 
837 contract SafeTransfer {
838 
839     address private constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
840 
841     /// @dev Helper function to handle both ETH and ERC20 payments
842     function _safeTokenPayment(
843         address _token,
844         address payable _to,
845         uint256 _amount
846     ) internal {
847         if (address(_token) == ETH_ADDRESS) {
848             _safeTransferETH(_to,_amount );
849         } else {
850             _safeTransfer(_token, _to, _amount);
851         }
852     }
853 
854 
855     /// @dev Helper function to handle both ETH and ERC20 payments
856     function _tokenPayment(
857         address _token,
858         address payable _to,
859         uint256 _amount
860     ) internal {
861         if (address(_token) == ETH_ADDRESS) {
862             _to.transfer(_amount);
863         } else {
864             _safeTransfer(_token, _to, _amount);
865         }
866     }
867 
868 
869     /// @dev Transfer helper from UniswapV2 Router
870     function _safeApprove(address token, address to, uint value) internal {
871         // bytes4(keccak256(bytes('approve(address,uint256)')));
872         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
873         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
874     }
875 
876 
877     /**
878      * There are many non-compliant ERC20 tokens... this can handle most, adapted from UniSwap V2
879      * Im trying to make it a habit to put external calls last (reentrancy)
880      * You can put this in an internal function if you like.
881      */
882     function _safeTransfer(
883         address token,
884         address to,
885         uint256 amount
886     ) internal virtual {
887         // solium-disable-next-line security/no-low-level-calls
888         (bool success, bytes memory data) =
889             token.call(
890                 // 0xa9059cbb = bytes4(keccak256("transfer(address,uint256)"))
891                 abi.encodeWithSelector(0xa9059cbb, to, amount)
892             );
893         require(success && (data.length == 0 || abi.decode(data, (bool)))); // ERC20 Transfer failed
894     }
895 
896     function _safeTransferFrom(
897         address token,
898         address from,
899         uint256 amount
900     ) internal virtual {
901         // solium-disable-next-line security/no-low-level-calls
902         (bool success, bytes memory data) =
903             token.call(
904                 // 0x23b872dd = bytes4(keccak256("transferFrom(address,address,uint256)"))
905                 abi.encodeWithSelector(0x23b872dd, from, address(this), amount)
906             );
907         require(success && (data.length == 0 || abi.decode(data, (bool)))); // ERC20 TransferFrom failed
908     }
909 
910     function _safeTransferFrom(address token, address from, address to, uint value) internal {
911         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
912         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
913         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
914     }
915 
916     function _safeTransferETH(address to, uint value) internal {
917         (bool success,) = to.call{value:value}(new bytes(0));
918         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
919     }
920 
921 
922 }
923 
924 
925 // File contracts/interfaces/IERC20.sol
926 
927 pragma solidity 0.6.12;
928 
929 interface IERC20 {
930     function totalSupply() external view returns (uint256);
931     function balanceOf(address account) external view returns (uint256);
932     function allowance(address owner, address spender) external view returns (uint256);
933     function approve(address spender, uint256 amount) external returns (bool);
934     function name() external view returns (string memory);
935     function symbol() external view returns (string memory);
936     function decimals() external view returns (uint8);
937 
938     event Transfer(address indexed from, address indexed to, uint256 value);
939     event Approval(address indexed owner, address indexed spender, uint256 value);
940 
941     function permit(
942         address owner,
943         address spender,
944         uint256 value,
945         uint256 deadline,
946         uint8 v,
947         bytes32 r,
948         bytes32 s
949     ) external;
950 }
951 
952 
953 // File contracts/Utils/BoringERC20.sol
954 
955 pragma solidity 0.6.12;
956 
957 // solhint-disable avoid-low-level-calls
958 
959 library BoringERC20 {
960     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
961     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
962     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
963     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
964     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
965 
966     /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.
967     /// @param token The address of the ERC-20 token contract.
968     /// @return (string) Token symbol.
969     function safeSymbol(IERC20 token) internal view returns (string memory) {
970         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_SYMBOL));
971         return success && data.length > 0 ? abi.decode(data, (string)) : "???";
972     }
973 
974     /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.
975     /// @param token The address of the ERC-20 token contract.
976     /// @return (string) Token name.
977     function safeName(IERC20 token) internal view returns (string memory) {
978         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_NAME));
979         return success && data.length > 0 ? abi.decode(data, (string)) : "???";
980     }
981 
982     /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.
983     /// @param token The address of the ERC-20 token contract.
984     /// @return (uint8) Token decimals.
985     function safeDecimals(IERC20 token) internal view returns (uint8) {
986         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_DECIMALS));
987         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
988     }
989 
990     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
991     /// Reverts on a failed transfer.
992     /// @param token The address of the ERC-20 token.
993     /// @param to Transfer tokens to.
994     /// @param amount The token amount.
995     function safeTransfer(
996         IERC20 token,
997         address to,
998         uint256 amount
999     ) internal {
1000         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
1001         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
1002     }
1003 
1004     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
1005     /// Reverts on a failed transfer.
1006     /// @param token The address of the ERC-20 token.
1007     /// @param from Transfer tokens from.
1008     /// @param to Transfer tokens to.
1009     /// @param amount The token amount.
1010     function safeTransferFrom(
1011         IERC20 token,
1012         address from,
1013         address to,
1014         uint256 amount
1015     ) internal {
1016         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
1017         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
1018     }
1019 }
1020 
1021 
1022 // File contracts/Utils/BoringBatchable.sol
1023 
1024 pragma solidity 0.6.12;
1025 
1026 // solhint-disable avoid-low-level-calls
1027 // solhint-disable no-inline-assembly
1028 
1029 // Audit on 5-Jan-2021 by Keno and BoringCrypto
1030 
1031 contract BaseBoringBatchable {
1032     /// @dev Helper function to extract a useful revert message from a failed call.
1033     /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.
1034     function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
1035         // If the _res length is less than 68, then the transaction failed silently (without a revert message)
1036         if (_returnData.length < 68) return "Transaction reverted silently";
1037 
1038         assembly {
1039             // Slice the sighash.
1040             _returnData := add(_returnData, 0x04)
1041         }
1042         return abi.decode(_returnData, (string)); // All that remains is the revert string
1043     }
1044 
1045     /// @notice Allows batched call to self (this contract).
1046     /// @param calls An array of inputs for each call.
1047     /// @param revertOnFail If True then reverts after a failed call and stops doing further calls.
1048     /// @return successes An array indicating the success of a call, mapped one-to-one to `calls`.
1049     /// @return results An array with the returned data of each function call, mapped one-to-one to `calls`.
1050     // F1: External is ok here because this is the batch function, adding it to a batch makes no sense
1051     // F2: Calls in the batch may be payable, delegatecall operates in the same context, so each call in the batch has access to msg.value
1052     // C3: The length of the loop is fully under user control, so can't be exploited
1053     // C7: Delegatecall is only used on the same contract, so it's safe
1054     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results) {
1055         successes = new bool[](calls.length);
1056         results = new bytes[](calls.length);
1057         for (uint256 i = 0; i < calls.length; i++) {
1058             (bool success, bytes memory result) = address(this).delegatecall(calls[i]);
1059             require(success || !revertOnFail, _getRevertMsg(result));
1060             successes[i] = success;
1061             results[i] = result;
1062         }
1063     }
1064 }
1065 
1066 contract BoringBatchable is BaseBoringBatchable {
1067     /// @notice Call wrapper that performs `ERC20.permit` on `token`.
1068     /// Lookup `IERC20.permit`.
1069     // F6: Parameters can be used front-run the permit and the user's permit will fail (due to nonce or other revert)
1070     //     if part of a batch this could be used to grief once as the second call would not need the permit
1071     function permitToken(
1072         IERC20 token,
1073         address from,
1074         address to,
1075         uint256 amount,
1076         uint256 deadline,
1077         uint8 v,
1078         bytes32 r,
1079         bytes32 s
1080     ) public {
1081         token.permit(from, to, amount, deadline, v, r, s);
1082     }
1083 }
1084 
1085 
1086 // File contracts/Utils/BoringMath.sol
1087 
1088 pragma solidity 0.6.12;
1089 
1090 /// @notice A library for performing overflow-/underflow-safe math,
1091 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
1092 library BoringMath {
1093     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1094         require((c = a + b) >= b, "BoringMath: Add Overflow");
1095     }
1096 
1097     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
1098         require((c = a - b) <= a, "BoringMath: Underflow");
1099     }
1100 
1101     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1102         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
1103     }
1104 
1105     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
1106         require(b > 0, "BoringMath: Div zero");
1107         c = a / b;
1108     }
1109 
1110     function to128(uint256 a) internal pure returns (uint128 c) {
1111         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
1112         c = uint128(a);
1113     }
1114 
1115     function to64(uint256 a) internal pure returns (uint64 c) {
1116         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
1117         c = uint64(a);
1118     }
1119 
1120     function to32(uint256 a) internal pure returns (uint32 c) {
1121         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
1122         c = uint32(a);
1123     }
1124 
1125     function to16(uint256 a) internal pure returns (uint16 c) {
1126         require(a <= uint16(-1), "BoringMath: uint16 Overflow");
1127         c = uint16(a);
1128     }
1129 
1130 }
1131 
1132 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
1133 library BoringMath128 {
1134     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
1135         require((c = a + b) >= b, "BoringMath: Add Overflow");
1136     }
1137 
1138     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
1139         require((c = a - b) <= a, "BoringMath: Underflow");
1140     }
1141 }
1142 
1143 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
1144 library BoringMath64 {
1145     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
1146         require((c = a + b) >= b, "BoringMath: Add Overflow");
1147     }
1148 
1149     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
1150         require((c = a - b) <= a, "BoringMath: Underflow");
1151     }
1152 }
1153 
1154 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
1155 library BoringMath32 {
1156     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
1157         require((c = a + b) >= b, "BoringMath: Add Overflow");
1158     }
1159 
1160     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
1161         require((c = a - b) <= a, "BoringMath: Underflow");
1162     }
1163 }
1164 
1165 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
1166 library BoringMath16 {
1167     function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
1168         require((c = a + b) >= b, "BoringMath: Add Overflow");
1169     }
1170 
1171     function sub(uint16 a, uint16 b) internal pure returns (uint16 c) {
1172         require((c = a - b) <= a, "BoringMath: Underflow");
1173     }
1174 }
1175 
1176 
1177 // File contracts/Utils/Documents.sol
1178 
1179 pragma solidity 0.6.12;
1180 
1181 
1182 /**
1183  * @title Standard implementation of ERC1643 Document management
1184  */
1185 contract Documents {
1186 
1187     struct Document {
1188         uint32 docIndex;    // Store the document name indexes
1189         uint64 lastModified; // Timestamp at which document details was last modified
1190         string data; // data of the document that exist off-chain
1191     }
1192 
1193     // mapping to store the documents details in the document
1194     mapping(string => Document) internal _documents;
1195     // mapping to store the document name indexes
1196     mapping(string => uint32) internal _docIndexes;
1197     // Array use to store all the document name present in the contracts
1198     string[] _docNames;
1199 
1200     // Document Events
1201     event DocumentRemoved(string indexed _name, string _data);
1202     event DocumentUpdated(string indexed _name, string _data);
1203 
1204     /**
1205      * @notice Used to attach a new document to the contract, or update the data or hash of an existing attached document
1206      * @dev Can only be executed by the owner of the contract.
1207      * @param _name Name of the document. It should be unique always
1208      * @param _data Off-chain data of the document from where it is accessible to investors/advisors to read.
1209      */
1210     function _setDocument(string calldata _name, string calldata _data) internal {
1211         require(bytes(_name).length > 0, "Zero name is not allowed");
1212         require(bytes(_data).length > 0, "Should not be a empty data");
1213         // Document storage document = _documents[_name];
1214         if (_documents[_name].lastModified == uint64(0)) {
1215             _docNames.push(_name);
1216             _documents[_name].docIndex = uint32(_docNames.length);
1217         }
1218         _documents[_name] = Document(_documents[_name].docIndex, uint64(now), _data);
1219         emit DocumentUpdated(_name, _data);
1220     }
1221 
1222     /**
1223      * @notice Used to remove an existing document from the contract by giving the name of the document.
1224      * @dev Can only be executed by the owner of the contract.
1225      * @param _name Name of the document. It should be unique always
1226      */
1227 
1228     function _removeDocument(string calldata _name) internal {
1229         require(_documents[_name].lastModified != uint64(0), "Document should exist");
1230         uint32 index = _documents[_name].docIndex - 1;
1231         if (index != _docNames.length - 1) {
1232             _docNames[index] = _docNames[_docNames.length - 1];
1233             _documents[_docNames[index]].docIndex = index + 1; 
1234         }
1235         _docNames.pop();
1236         emit DocumentRemoved(_name, _documents[_name].data);
1237         delete _documents[_name];
1238     }
1239 
1240     /**
1241      * @notice Used to return the details of a document with a known name (`string`).
1242      * @param _name Name of the document
1243      * @return string The data associated with the document.
1244      * @return uint256 the timestamp at which the document was last modified.
1245      */
1246     function getDocument(string calldata _name) external view returns (string memory, uint256) {
1247         return (
1248             _documents[_name].data,
1249             uint256(_documents[_name].lastModified)
1250         );
1251     }
1252 
1253     /**
1254      * @notice Used to retrieve a full list of documents attached to the smart contract.
1255      * @return string List of all documents names present in the contract.
1256      */
1257     function getAllDocuments() external view returns (string[] memory) {
1258         return _docNames;
1259     }
1260 
1261     /**
1262      * @notice Used to retrieve the total documents in the smart contract.
1263      * @return uint256 Count of the document names present in the contract.
1264      */
1265     function getDocumentCount() external view returns (uint256) {
1266         return _docNames.length;
1267     }
1268 
1269     /**
1270      * @notice Used to retrieve the document name from index in the smart contract.
1271      * @return string Name of the document name.
1272      */
1273     function getDocumentName(uint256 _index) external view returns (string memory) {
1274         require(_index < _docNames.length, "Index out of bounds");
1275         return _docNames[_index];
1276     }
1277 
1278 }
1279 
1280 
1281 // File contracts/interfaces/IPointList.sol
1282 
1283 pragma solidity 0.6.12;
1284 
1285 // ----------------------------------------------------------------------------
1286 // White List interface
1287 // ----------------------------------------------------------------------------
1288 
1289 interface IPointList {
1290     function isInList(address account) external view returns (bool);
1291     function hasPoints(address account, uint256 amount) external view  returns (bool);
1292     function setPoints(
1293         address[] memory accounts,
1294         uint256[] memory amounts
1295     ) external; 
1296     function initPointList(address accessControl) external ;
1297 
1298 }
1299 
1300 
1301 // File contracts/interfaces/IMisoMarket.sol
1302 
1303 pragma solidity 0.6.12;
1304 
1305 interface IMisoMarket {
1306 
1307     function init(bytes calldata data) external payable;
1308     function initMarket( bytes calldata data ) external;
1309     function marketTemplate() external view returns (uint256);
1310 
1311 }
1312 
1313 
1314 // File contracts/Auctions/DutchAuction.sol
1315 
1316 pragma solidity 0.6.12;
1317 pragma experimental ABIEncoderV2;
1318 
1319 
1320 //----------------------------------------------------------------------------------
1321 //    I n s t a n t
1322 //
1323 //        .:mmm.         .:mmm:.       .ii.  .:SSSSSSSSSSSSS.     .oOOOOOOOOOOOo.  
1324 //      .mMM'':Mm.     .:MM'':Mm:.     .II:  :SSs..........     .oOO'''''''''''OOo.
1325 //    .:Mm'   ':Mm.   .:Mm'   'MM:.    .II:  'sSSSSSSSSSSSSS:.  :OO.           .OO:
1326 //  .'mMm'     ':MM:.:MMm'     ':MM:.  .II:  .:...........:SS.  'OOo:.........:oOO'
1327 //  'mMm'        ':MMmm'         'mMm:  II:  'sSSSSSSSSSSSSS'     'oOOOOOOOOOOOO'  
1328 //
1329 //----------------------------------------------------------------------------------
1330 //
1331 // Chef Gonpachi's Dutch Auction
1332 //
1333 // A declining price auction with fair price discovery. 
1334 //
1335 // Inspired by DutchSwap's Dutch Auctions
1336 // https://github.com/deepyr/DutchSwap
1337 // 
1338 // This program is free software: you can redistribute it and/or modify
1339 // it under the terms of the GNU General Public License as published by
1340 // the Free Software Foundation, either version 3 of the License
1341 //
1342 // This program is distributed in the hope that it will be useful,
1343 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1344 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1345 // GNU General Public License for more details.
1346 //
1347 // The above copyright notice and this permission notice shall be included 
1348 // in all copies or substantial portions of the Software.
1349 //
1350 // Made for Sushi.com 
1351 // 
1352 // Enjoy. (c) Chef Gonpachi, Kusatoshi, SSMikazu 2021 
1353 // <https://github.com/chefgonpachi/MISO/>
1354 //
1355 // ---------------------------------------------------------------------
1356 // SPDX-License-Identifier: GPL-3.0                        
1357 // ---------------------------------------------------------------------
1358 
1359 
1360 
1361 
1362 
1363 
1364 
1365 
1366 
1367 /// @notice Attribution to delta.financial
1368 /// @notice Attribution to dutchswap.com
1369 
1370 contract DutchAuction is IMisoMarket, MISOAccessControls, BoringBatchable, SafeTransfer, Documents , ReentrancyGuard  {
1371     using BoringMath for uint256;
1372     using BoringMath128 for uint128;
1373     using BoringMath64 for uint64;
1374     using BoringERC20 for IERC20;
1375 
1376     /// @notice MISOMarket template id for the factory contract.
1377     /// @dev For different marketplace types, this must be incremented.
1378     uint256 public constant override marketTemplate = 2;
1379     /// @dev The placeholder ETH address.
1380     address private constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1381 
1382     /// @notice Main market variables.
1383     struct MarketInfo {
1384         uint64 startTime;
1385         uint64 endTime;
1386         uint128 totalTokens;
1387     }
1388     MarketInfo public marketInfo;
1389 
1390     /// @notice Market price variables.
1391     struct MarketPrice {
1392         uint128 startPrice;
1393         uint128 minimumPrice;
1394     }
1395     MarketPrice public marketPrice;
1396 
1397     /// @notice Market dynamic variables.
1398     struct MarketStatus {
1399         uint128 commitmentsTotal;
1400         bool finalized;
1401         bool usePointList;
1402     }
1403 
1404     MarketStatus public marketStatus;
1405 
1406     /// @notice The token being sold.
1407     address public auctionToken; 
1408     /// @notice The currency the auction accepts for payment. Can be ETH or token address.
1409     address public paymentCurrency;  
1410     /// @notice Where the auction funds will get paid.
1411     address payable public wallet;  
1412     /// @notice Address that manages auction approvals.
1413     address public pointList;
1414 
1415     /// @notice The committed amount of accounts.
1416     mapping(address => uint256) public commitments; 
1417     /// @notice Amount of tokens to claim per address.
1418     mapping(address => uint256) public claimed;
1419 
1420     /// @notice Event for updating auction times.  Needs to be before auction starts.
1421     event AuctionTimeUpdated(uint256 startTime, uint256 endTime); 
1422     /// @notice Event for updating auction prices. Needs to be before auction starts.
1423     event AuctionPriceUpdated(uint256 startPrice, uint256 minimumPrice); 
1424     /// @notice Event for updating auction wallet. Needs to be before auction starts.
1425     event AuctionWalletUpdated(address wallet); 
1426 
1427     /// @notice Event for adding a commitment.
1428     event AddedCommitment(address addr, uint256 commitment);   
1429     /// @notice Event for finalization of the auction.
1430     event AuctionFinalized();
1431     /// @notice Event for cancellation of the auction.
1432     event AuctionCancelled();
1433 
1434     /**
1435      * @notice Initializes main contract variables and transfers funds for the auction.
1436      * @dev Init function.
1437      * @param _funder The address that funds the token for DutchAuction.
1438      * @param _token Address of the token being sold.
1439      * @param _totalTokens The total number of tokens to sell in auction.
1440      * @param _startTime Auction start time.
1441      * @param _endTime Auction end time.
1442      * @param _paymentCurrency The currency the DutchAuction accepts for payment. Can be ETH or token address.
1443      * @param _startPrice Starting price of the auction.
1444      * @param _minimumPrice The minimum auction price.
1445      * @param _admin Address that can finalize auction.
1446      * @param _pointList Address that will manage auction approvals.
1447      * @param _wallet Address where collected funds will be forwarded to.
1448      */
1449     function initAuction(
1450         address _funder,
1451         address _token,
1452         uint256 _totalTokens,
1453         uint256 _startTime,
1454         uint256 _endTime,
1455         address _paymentCurrency,
1456         uint256 _startPrice,
1457         uint256 _minimumPrice,
1458         address _admin,
1459         address _pointList,
1460         address payable _wallet
1461     ) public {
1462         require(hasAdminRole(msg.sender));
1463         require(_endTime < 10000000000, "DutchAuction: enter an unix timestamp in seconds, not miliseconds");
1464         require(_startTime >= block.timestamp, "DutchAuction: start time is before current time");
1465         require(_endTime > _startTime, "DutchAuction: end time must be older than start price");
1466         require(_totalTokens > 0,"DutchAuction: total tokens must be greater than zero");
1467         require(_startPrice > _minimumPrice, "DutchAuction: start price must be higher than minimum price");
1468         require(_minimumPrice > 0, "DutchAuction: minimum price must be greater than 0"); 
1469         require(_admin != address(0), "DutchAuction: admin is the zero address");
1470         require(_wallet != address(0), "DutchAuction: wallet is the zero address");
1471         require(IERC20(_token).decimals() == 9, "DutchAuction: Token does not have 9 decimals");
1472         if (_paymentCurrency != ETH_ADDRESS) {
1473             require(IERC20(_paymentCurrency).decimals() > 0, "DutchAuction: Payment currency is not ERC20");
1474         }
1475 
1476         marketInfo.startTime = BoringMath.to64(_startTime);
1477         marketInfo.endTime = BoringMath.to64(_endTime);
1478         marketInfo.totalTokens = BoringMath.to128(_totalTokens);
1479 
1480         marketPrice.startPrice = BoringMath.to128(_startPrice);
1481         marketPrice.minimumPrice = BoringMath.to128(_minimumPrice);
1482 
1483         auctionToken = _token;
1484         paymentCurrency = _paymentCurrency;
1485         wallet = _wallet;
1486 
1487         _setList(_pointList);
1488         _safeTransferFrom(_token, _funder, _totalTokens);
1489     }
1490 
1491 
1492     /**
1493      * @notice need admin rights to not waste gas of users using uneeded finctionality
1494      */
1495 
1496     constructor() public {
1497         initAccessControls(msg.sender);
1498     }
1499 
1500 
1501     /**
1502      Dutch Auction Price Function
1503      ============================
1504      
1505      Start Price -----
1506                       \
1507                        \
1508                         \
1509                          \ ------------ Clearing Price
1510                         / \            = AmountRaised/TokenSupply
1511          Token Price  --   \
1512                      /      \
1513                    --        ----------- Minimum Price
1514      Amount raised /          End Time
1515     */
1516 
1517     /**
1518      * @notice Calculates the average price of each token from all commitments.
1519      * @return Average token price.
1520      */
1521     function tokenPrice() public view returns (uint256) {
1522         return uint256(marketStatus.commitmentsTotal)
1523                .mul(1e9).div(uint256(marketInfo.totalTokens));        
1524     }
1525 
1526     /**
1527      * @notice Returns auction price in any time.
1528      * @return Fixed start price or minimum price if outside of auction time, otherwise calculated current price.
1529      */
1530     function priceFunction() public view returns (uint256) {
1531         /// @dev Return Auction Price
1532         if (block.timestamp <= uint256(marketInfo.startTime)) {
1533             return uint256(marketPrice.startPrice);
1534         }
1535         if (block.timestamp >= uint256(marketInfo.endTime)) {
1536             return uint256(marketPrice.minimumPrice);
1537         }
1538 
1539         return _currentPrice();
1540     }
1541 
1542     /**
1543      * @notice The current clearing price of the Dutch auction.
1544      * @return The bigger from tokenPrice and priceFunction.
1545      */
1546     function clearingPrice() public view returns (uint256) {
1547 
1548         /// @dev If auction successful, return tokenPrice
1549         uint256 _tokenPrice = tokenPrice();
1550         uint256 _currentPrice = priceFunction();
1551         return _tokenPrice > _currentPrice ? _tokenPrice : _currentPrice;
1552 
1553     }
1554 
1555 
1556     ///--------------------------------------------------------
1557     /// Commit to buying tokens!
1558     ///--------------------------------------------------------
1559 
1560     receive() external payable {
1561         revertBecauseUserDidNotProvideAgreement();
1562     }
1563 
1564     /** 
1565      * @dev Attribution to the awesome delta.financial contracts
1566     */  
1567     function marketParticipationAgreement() public pure returns (string memory) {
1568         return "I understand that I'm interacting with a smart contract. I understand that tokens committed are subject to the token issuer and local laws where applicable. I reviewed code of the smart contract and understand it fully. I agree to not hold developers or other people associated with the project liable for any losses or misunderstandings";
1569     }
1570     /** 
1571      * @dev Not using modifiers is a purposeful choice for code readability.
1572     */ 
1573     function revertBecauseUserDidNotProvideAgreement() internal pure {
1574         revert("No agreement provided, please review the smart contract before interacting with it");
1575     }
1576 
1577     /**
1578      * @notice Checks the amount of ETH to commit and adds the commitment. Refunds the buyer if commit is too high.
1579      * @param _beneficiary Auction participant ETH address.
1580      */
1581     function commitEth(
1582         address payable _beneficiary,
1583         bool readAndAgreedToMarketParticipationAgreement
1584     )
1585         public payable
1586     {
1587         require(paymentCurrency == ETH_ADDRESS, "DutchAuction: payment currency is not ETH address"); 
1588         if(readAndAgreedToMarketParticipationAgreement == false) {
1589             revertBecauseUserDidNotProvideAgreement();
1590         }
1591         // Get ETH able to be committed
1592         uint256 ethToTransfer = calculateCommitment(msg.value);
1593 
1594         /// @notice Accept ETH Payments.
1595         uint256 ethToRefund = msg.value.sub(ethToTransfer);
1596         if (ethToTransfer > 0) {
1597             _addCommitment(_beneficiary, ethToTransfer);
1598         }
1599         /// @notice Return any ETH to be refunded.
1600         if (ethToRefund > 0) {
1601             _beneficiary.transfer(ethToRefund);
1602         }
1603 
1604         /// @notice Revert if commitmentsTotal exceeds the balance
1605         require(marketStatus.commitmentsTotal <= address(this).balance, "DutchAuction: The committed ETH exceeds the balance");
1606     }
1607 
1608     /**
1609      * @notice Buy Tokens by commiting approved ERC20 tokens to this contract address.
1610      * @param _amount Amount of tokens to commit.
1611      */
1612     function commitTokens(uint256 _amount, bool readAndAgreedToMarketParticipationAgreement) public {
1613         commitTokensFrom(msg.sender, _amount, readAndAgreedToMarketParticipationAgreement);
1614     }
1615 
1616 
1617     /**
1618      * @notice Checks how much is user able to commit and processes that commitment.
1619      * @dev Users must approve contract prior to committing tokens to auction.
1620      * @param _from User ERC20 address.
1621      * @param _amount Amount of approved ERC20 tokens.
1622      */
1623     function commitTokensFrom(
1624         address _from,
1625         uint256 _amount,
1626         bool readAndAgreedToMarketParticipationAgreement
1627     )
1628         public   nonReentrant  
1629     {
1630         require(address(paymentCurrency) != ETH_ADDRESS, "DutchAuction: Payment currency is not a token");
1631         if(readAndAgreedToMarketParticipationAgreement == false) {
1632             revertBecauseUserDidNotProvideAgreement();
1633         }
1634         uint256 tokensToTransfer = calculateCommitment(_amount);
1635         if (tokensToTransfer > 0) {
1636             _safeTransferFrom(paymentCurrency, msg.sender, tokensToTransfer);
1637             _addCommitment(_from, tokensToTransfer);
1638         }
1639     }
1640 
1641     /**
1642      * @notice Calculates the pricedrop factor.
1643      * @return Value calculated from auction start and end price difference divided the auction duration.
1644      */
1645     function priceDrop() public view returns (uint256) {
1646         MarketInfo memory _marketInfo = marketInfo;
1647         MarketPrice memory _marketPrice = marketPrice;
1648 
1649         uint256 numerator = uint256(_marketPrice.startPrice.sub(_marketPrice.minimumPrice));
1650         uint256 denominator = uint256(_marketInfo.endTime.sub(_marketInfo.startTime));
1651         return numerator / denominator;
1652     }
1653 
1654 
1655    /**
1656      * @notice How many tokens the user is able to claim.
1657      * @param _user Auction participant address.
1658      * @return claimerCommitment User commitments reduced by already claimed tokens.
1659      */
1660     function tokensClaimable(address _user) public view returns (uint256 claimerCommitment) {
1661         if (commitments[_user] == 0) return 0;
1662         uint256 unclaimedTokens = IERC20(auctionToken).balanceOf(address(this));
1663 
1664         claimerCommitment = commitments[_user].mul(uint256(marketInfo.totalTokens)).div(uint256(marketStatus.commitmentsTotal));
1665         claimerCommitment = claimerCommitment.sub(claimed[_user]);
1666 
1667         if(claimerCommitment > unclaimedTokens){
1668             claimerCommitment = unclaimedTokens;
1669         }
1670     }
1671 
1672     /**
1673      * @notice Calculates total amount of tokens committed at current auction price.
1674      * @return Number of tokens committed.
1675      */
1676     function totalTokensCommitted() public view returns (uint256) {
1677         return uint256(marketStatus.commitmentsTotal).mul(1e9).div(clearingPrice());
1678     }
1679 
1680     /**
1681      * @notice Calculates the amount able to be committed during an auction.
1682      * @param _commitment Commitment user would like to make.
1683      * @return committed Amount allowed to commit.
1684      */
1685     function calculateCommitment(uint256 _commitment) public view returns (uint256 committed) {
1686         uint256 maxCommitment = uint256(marketInfo.totalTokens).mul(clearingPrice()).div(1e9);
1687         if (uint256(marketStatus.commitmentsTotal).add(_commitment) > maxCommitment) {
1688             return maxCommitment.sub(uint256(marketStatus.commitmentsTotal));
1689         }
1690         return _commitment;
1691     }
1692 
1693     /**
1694      * @notice Checks if the auction is open.
1695      * @return True if current time is greater than startTime and less than endTime.
1696      */
1697     function isOpen() public view returns (bool) {
1698         return block.timestamp >= uint256(marketInfo.startTime) && block.timestamp <= uint256(marketInfo.endTime);
1699     }
1700 
1701     /**
1702      * @notice Successful if tokens sold equals totalTokens.
1703      * @return True if tokenPrice is bigger or equal clearingPrice.
1704      */
1705     function auctionSuccessful() public view returns (bool) {
1706         return tokenPrice() >= clearingPrice();
1707     }
1708 
1709     /**
1710      * @notice Checks if the auction has ended.
1711      * @return True if auction is successful or time has ended.
1712      */
1713     function auctionEnded() public view returns (bool) {
1714         return auctionSuccessful() || block.timestamp > uint256(marketInfo.endTime);
1715     }
1716 
1717     /**
1718      * @return Returns true if market has been finalized
1719      */
1720     function finalized() public view returns (bool) {
1721         return marketStatus.finalized;
1722     }
1723 
1724     /**
1725      * @return Returns true if 7 days have passed since the end of the auction
1726      */
1727     function finalizeTimeExpired() public view returns (bool) {
1728         return uint256(marketInfo.endTime) + 7 days < block.timestamp;
1729     }
1730 
1731     /**
1732      * @notice Calculates price during the auction.
1733      * @return Current auction price.
1734      */
1735     function _currentPrice() private view returns (uint256) {
1736         MarketInfo memory _marketInfo = marketInfo;
1737         MarketPrice memory _marketPrice = marketPrice;
1738         uint256 priceDiff = block.timestamp.sub(uint256(_marketInfo.startTime)).mul(
1739             uint256(_marketPrice.startPrice.sub(_marketPrice.minimumPrice))
1740         ) / uint256(_marketInfo.endTime.sub(_marketInfo.startTime));        
1741         return uint256(_marketPrice.startPrice).sub(priceDiff);
1742     }
1743 
1744     /**
1745      * @notice Updates commitment for this address and total commitment of the auction.
1746      * @param _addr Bidders address.
1747      * @param _commitment The amount to commit.
1748      */
1749     function _addCommitment(address _addr, uint256 _commitment) internal {
1750         require(block.timestamp >= uint256(marketInfo.startTime) && block.timestamp <= uint256(marketInfo.endTime), "DutchAuction: outside auction hours");
1751         MarketStatus storage status = marketStatus;
1752         
1753         uint256 newCommitment = commitments[_addr].add(_commitment);
1754         if (status.usePointList) {
1755             require(IPointList(pointList).hasPoints(_addr, newCommitment));
1756         }
1757         
1758         commitments[_addr] = newCommitment;
1759         status.commitmentsTotal = BoringMath.to128(uint256(status.commitmentsTotal).add(_commitment));
1760         emit AddedCommitment(_addr, _commitment);
1761     }
1762 
1763 
1764     //--------------------------------------------------------
1765     // Finalize Auction
1766     //--------------------------------------------------------
1767 
1768 
1769     /**
1770      * @notice Cancel Auction
1771      * @dev Admin can cancel the auction before it starts
1772      */
1773     function cancelAuction() public   nonReentrant  
1774     {
1775         require(hasAdminRole(msg.sender));
1776         MarketStatus storage status = marketStatus;
1777         require(!status.finalized, "DutchAuction: auction already finalized");
1778         require( uint256(status.commitmentsTotal) == 0, "DutchAuction: auction already committed" );
1779         _safeTokenPayment(auctionToken, wallet, uint256(marketInfo.totalTokens));
1780         status.finalized = true;
1781         emit AuctionCancelled();
1782     }
1783 
1784     /**
1785      * @notice Auction finishes successfully above the reserve.
1786      * @dev Transfer contract funds to initialized wallet.
1787      */
1788     function finalize() public   nonReentrant  
1789     {
1790 
1791         require(hasAdminRole(msg.sender) 
1792                 || hasSmartContractRole(msg.sender) 
1793                 || wallet == msg.sender
1794                 || finalizeTimeExpired(), "DutchAuction: sender must be an admin");
1795         
1796         require(marketInfo.totalTokens > 0, "Not initialized");
1797 
1798         MarketStatus storage status = marketStatus;
1799 
1800         require(!status.finalized, "DutchAuction: auction already finalized");
1801         if (auctionSuccessful()) {
1802             /// @dev Successful auction
1803             /// @dev Transfer contributed tokens to wallet.
1804             _safeTokenPayment(paymentCurrency, wallet, uint256(status.commitmentsTotal));
1805         } else {
1806             /// @dev Failed auction
1807             /// @dev Return auction tokens back to wallet.
1808             require(block.timestamp > uint256(marketInfo.endTime), "DutchAuction: auction has not finished yet"); 
1809             _safeTokenPayment(auctionToken, wallet, uint256(marketInfo.totalTokens));
1810         }
1811         status.finalized = true;
1812         emit AuctionFinalized();
1813     }
1814 
1815 
1816     /// @notice Withdraws bought tokens, or returns commitment if the sale is unsuccessful.
1817     function withdrawTokens() public  {
1818         withdrawTokens(msg.sender);
1819     }
1820 
1821    /**
1822      * @notice Withdraws bought tokens, or returns commitment if the sale is unsuccessful.
1823      * @dev Withdraw tokens only after auction ends.
1824      * @param beneficiary Whose tokens will be withdrawn.
1825      */
1826     function withdrawTokens(address payable beneficiary) public   nonReentrant  {
1827         if (auctionSuccessful()) {
1828             require(marketStatus.finalized, "DutchAuction: not finalized");
1829             /// @dev Successful auction! Transfer claimed tokens.
1830             uint256 tokensToClaim = tokensClaimable(beneficiary);
1831             require(tokensToClaim > 0, "DutchAuction: No tokens to claim"); 
1832             claimed[beneficiary] = claimed[beneficiary].add(tokensToClaim);
1833             _safeTokenPayment(auctionToken, beneficiary, tokensToClaim);
1834         } else {
1835             /// @dev Auction did not meet reserve price.
1836             /// @dev Return committed funds back to user.
1837             require(block.timestamp > uint256(marketInfo.endTime), "DutchAuction: auction has not finished yet");
1838             uint256 fundsCommitted = commitments[beneficiary];
1839             commitments[beneficiary] = 0; // Stop multiple withdrawals and free some gas
1840             _safeTokenPayment(paymentCurrency, beneficiary, fundsCommitted);
1841         }
1842     }
1843 
1844 
1845     //--------------------------------------------------------
1846     // Documents
1847     //--------------------------------------------------------
1848 
1849     function setDocument(string calldata _name, string calldata _data) external {
1850         require(hasAdminRole(msg.sender) );
1851         _setDocument( _name, _data);
1852     }
1853 
1854     function setDocuments(string[] calldata _name, string[] calldata _data) external {
1855         require(hasAdminRole(msg.sender) );
1856         uint256 numDocs = _name.length;
1857         for (uint256 i = 0; i < numDocs; i++) {
1858             _setDocument( _name[i], _data[i]);
1859         }
1860     }
1861 
1862     function removeDocument(string calldata _name) external {
1863         require(hasAdminRole(msg.sender));
1864         _removeDocument(_name);
1865     }
1866 
1867 
1868     //--------------------------------------------------------
1869     // Point Lists
1870     //--------------------------------------------------------
1871 
1872 
1873     function setList(address _list) external {
1874         require(hasAdminRole(msg.sender));
1875         _setList(_list);
1876     }
1877 
1878     function enableList(bool _status) external {
1879         require(hasAdminRole(msg.sender));
1880         marketStatus.usePointList = _status;
1881     }
1882 
1883     function _setList(address _pointList) private {
1884         if (_pointList != address(0)) {
1885             pointList = _pointList;
1886             marketStatus.usePointList = true;
1887         }
1888     }
1889 
1890     //--------------------------------------------------------
1891     // Setter Functions
1892     //--------------------------------------------------------
1893 
1894     /**
1895      * @notice Admin can set start and end time through this function.
1896      * @param _startTime Auction start time.
1897      * @param _endTime Auction end time.
1898      */
1899     function setAuctionTime(uint256 _startTime, uint256 _endTime) external {
1900         require(hasAdminRole(msg.sender));
1901         require(_startTime < 10000000000, "DutchAuction: enter an unix timestamp in seconds, not miliseconds");
1902         require(_endTime < 10000000000, "DutchAuction: enter an unix timestamp in seconds, not miliseconds");
1903         require(_startTime >= block.timestamp, "DutchAuction: start time is before current time");
1904         require(_endTime > _startTime, "DutchAuction: end time must be older than start time");
1905         require(marketStatus.commitmentsTotal == 0, "DutchAuction: auction cannot have already started");
1906 
1907         marketInfo.startTime = BoringMath.to64(_startTime);
1908         marketInfo.endTime = BoringMath.to64(_endTime);
1909         
1910         emit AuctionTimeUpdated(_startTime,_endTime);
1911     }
1912 
1913     /**
1914      * @notice Admin can set start and min price through this function.
1915      * @param _startPrice Auction start price.
1916      * @param _minimumPrice Auction minimum price.
1917      */
1918     function setAuctionPrice(uint256 _startPrice, uint256 _minimumPrice) external {
1919         require(hasAdminRole(msg.sender));
1920         require(_startPrice > _minimumPrice, "DutchAuction: start price must be higher than minimum price");
1921         require(_minimumPrice > 0, "DutchAuction: minimum price must be greater than 0"); 
1922         require(marketStatus.commitmentsTotal == 0, "DutchAuction: auction cannot have already started");
1923 
1924         marketPrice.startPrice = BoringMath.to128(_startPrice);
1925         marketPrice.minimumPrice = BoringMath.to128(_minimumPrice);
1926 
1927         emit AuctionPriceUpdated(_startPrice,_minimumPrice);
1928     }
1929 
1930     /**
1931      * @notice Admin can set the auction wallet through this function.
1932      * @param _wallet Auction wallet is where funds will be sent.
1933      */
1934     function setAuctionWallet(address payable _wallet) external {
1935         require(hasAdminRole(msg.sender));
1936         require(_wallet != address(0), "DutchAuction: wallet is the zero address");
1937 
1938         wallet = _wallet;
1939 
1940         emit AuctionWalletUpdated(_wallet);
1941     }
1942 
1943 
1944    //--------------------------------------------------------
1945     // Market Launchers
1946     //--------------------------------------------------------
1947 
1948     /**
1949      * @notice Decodes and hands auction data to the initAuction function.
1950      * @param _data Encoded data for initialization.
1951      */
1952 
1953     function init(bytes calldata _data) external override payable {
1954 
1955     }
1956 
1957     function initMarket(
1958         bytes calldata _data
1959     ) public override {
1960         (
1961         address _funder,
1962         address _token,
1963         uint256 _totalTokens,
1964         uint256 _startTime,
1965         uint256 _endTime,
1966         address _paymentCurrency,
1967         uint256 _startPrice,
1968         uint256 _minimumPrice,
1969         address _admin,
1970         address _pointList,
1971         address payable _wallet
1972         ) = abi.decode(_data, (
1973             address,
1974             address,
1975             uint256,
1976             uint256,
1977             uint256,
1978             address,
1979             uint256,
1980             uint256,
1981             address,
1982             address,
1983             address
1984         ));
1985         initAuction(_funder, _token, _totalTokens, _startTime, _endTime, _paymentCurrency, _startPrice, _minimumPrice, _admin, _pointList, _wallet);
1986     }
1987 
1988     /**
1989      * @notice Collects data to initialize the auction and encodes them.
1990      * @param _funder The address that funds the token for DutchAuction.
1991      * @param _token Address of the token being sold.
1992      * @param _totalTokens The total number of tokens to sell in auction.
1993      * @param _startTime Auction start time.
1994      * @param _endTime Auction end time.
1995      * @param _paymentCurrency The currency the DutchAuction accepts for payment. Can be ETH or token address.
1996      * @param _startPrice Starting price of the auction.
1997      * @param _minimumPrice The minimum auction price.
1998      * @param _admin Address that can finalize auction.
1999      * @param _pointList Address that will manage auction approvals.
2000      * @param _wallet Address where collected funds will be forwarded to.
2001      * @return _data All the data in bytes format.
2002      */
2003     function getAuctionInitData(
2004         address _funder,
2005         address _token,
2006         uint256 _totalTokens,
2007         uint256 _startTime,
2008         uint256 _endTime,
2009         address _paymentCurrency,
2010         uint256 _startPrice,
2011         uint256 _minimumPrice,
2012         address _admin,
2013         address _pointList,
2014         address payable _wallet
2015     )
2016         external 
2017         pure
2018         returns (bytes memory _data)
2019     {
2020             return abi.encode(
2021                 _funder,
2022                 _token,
2023                 _totalTokens,
2024                 _startTime,
2025                 _endTime,
2026                 _paymentCurrency,
2027                 _startPrice,
2028                 _minimumPrice,
2029                 _admin,
2030                 _pointList,
2031                 _wallet
2032             );
2033     }
2034         
2035     function getBaseInformation() external view returns(
2036         address, 
2037         uint64,
2038         uint64,
2039         bool 
2040     ) {
2041         return (auctionToken, marketInfo.startTime, marketInfo.endTime, marketStatus.finalized);
2042     }
2043 
2044     function getTotalTokens() external view returns(uint256) {
2045         return uint256(marketInfo.totalTokens);
2046     }
2047 
2048 }