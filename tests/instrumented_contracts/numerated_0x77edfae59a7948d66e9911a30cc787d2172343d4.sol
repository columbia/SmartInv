1 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Library for managing
7  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
8  * types.
9  *
10  * Sets have the following properties:
11  *
12  * - Elements are added, removed, and checked for existence in constant time
13  * (O(1)).
14  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
15  *
16  * ```
17  * contract Example {
18  *     // Add the library methods
19  *     using EnumerableSet for EnumerableSet.AddressSet;
20  *
21  *     // Declare a set state variable
22  *     EnumerableSet.AddressSet private mySet;
23  * }
24  * ```
25  *
26  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
27  * (`UintSet`) are supported.
28  */
29 library EnumerableSet {
30     // To implement this library for multiple types with as little code
31     // repetition as possible, we write it in terms of a generic Set type with
32     // bytes32 values.
33     // The Set implementation uses private functions, and user-facing
34     // implementations (such as AddressSet) are just wrappers around the
35     // underlying Set.
36     // This means that we can only create new EnumerableSets for types that fit
37     // in bytes32.
38 
39     struct Set {
40         // Storage of set values
41         bytes32[] _values;
42 
43         // Position of the value in the `values` array, plus 1 because index 0
44         // means a value is not in the set.
45         mapping (bytes32 => uint256) _indexes;
46     }
47 
48     /**
49      * @dev Add a value to a set. O(1).
50      *
51      * Returns true if the value was added to the set, that is if it was not
52      * already present.
53      */
54     function _add(Set storage set, bytes32 value) private returns (bool) {
55         if (!_contains(set, value)) {
56             set._values.push(value);
57             // The value is stored at length-1, but we add 1 to all indexes
58             // and use 0 as a sentinel value
59             set._indexes[value] = set._values.length;
60             return true;
61         } else {
62             return false;
63         }
64     }
65 
66     /**
67      * @dev Removes a value from a set. O(1).
68      *
69      * Returns true if the value was removed from the set, that is if it was
70      * present.
71      */
72     function _remove(Set storage set, bytes32 value) private returns (bool) {
73         // We read and store the value's index to prevent multiple reads from the same storage slot
74         uint256 valueIndex = set._indexes[value];
75 
76         if (valueIndex != 0) { // Equivalent to contains(set, value)
77             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
78             // the array, and then remove the last element (sometimes called as 'swap and pop').
79             // This modifies the order of the array, as noted in {at}.
80 
81             uint256 toDeleteIndex = valueIndex - 1;
82             uint256 lastIndex = set._values.length - 1;
83 
84             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
85             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
86 
87             bytes32 lastvalue = set._values[lastIndex];
88 
89             // Move the last value to the index where the value to delete is
90             set._values[toDeleteIndex] = lastvalue;
91             // Update the index for the moved value
92             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
93 
94             // Delete the slot where the moved value was stored
95             set._values.pop();
96 
97             // Delete the index for the deleted slot
98             delete set._indexes[value];
99 
100             return true;
101         } else {
102             return false;
103         }
104     }
105 
106     /**
107      * @dev Returns true if the value is in the set. O(1).
108      */
109     function _contains(Set storage set, bytes32 value) private view returns (bool) {
110         return set._indexes[value] != 0;
111     }
112 
113     /**
114      * @dev Returns the number of values on the set. O(1).
115      */
116     function _length(Set storage set) private view returns (uint256) {
117         return set._values.length;
118     }
119 
120    /**
121     * @dev Returns the value stored at position `index` in the set. O(1).
122     *
123     * Note that there are no guarantees on the ordering of values inside the
124     * array, and it may change when more values are added or removed.
125     *
126     * Requirements:
127     *
128     * - `index` must be strictly less than {length}.
129     */
130     function _at(Set storage set, uint256 index) private view returns (bytes32) {
131         require(set._values.length > index, "EnumerableSet: index out of bounds");
132         return set._values[index];
133     }
134 
135     // AddressSet
136 
137     struct AddressSet {
138         Set _inner;
139     }
140 
141     /**
142      * @dev Add a value to a set. O(1).
143      *
144      * Returns true if the value was added to the set, that is if it was not
145      * already present.
146      */
147     function add(AddressSet storage set, address value) internal returns (bool) {
148         return _add(set._inner, bytes32(uint256(value)));
149     }
150 
151     /**
152      * @dev Removes a value from a set. O(1).
153      *
154      * Returns true if the value was removed from the set, that is if it was
155      * present.
156      */
157     function remove(AddressSet storage set, address value) internal returns (bool) {
158         return _remove(set._inner, bytes32(uint256(value)));
159     }
160 
161     /**
162      * @dev Returns true if the value is in the set. O(1).
163      */
164     function contains(AddressSet storage set, address value) internal view returns (bool) {
165         return _contains(set._inner, bytes32(uint256(value)));
166     }
167 
168     /**
169      * @dev Returns the number of values in the set. O(1).
170      */
171     function length(AddressSet storage set) internal view returns (uint256) {
172         return _length(set._inner);
173     }
174 
175    /**
176     * @dev Returns the value stored at position `index` in the set. O(1).
177     *
178     * Note that there are no guarantees on the ordering of values inside the
179     * array, and it may change when more values are added or removed.
180     *
181     * Requirements:
182     *
183     * - `index` must be strictly less than {length}.
184     */
185     function at(AddressSet storage set, uint256 index) internal view returns (address) {
186         return address(uint256(_at(set._inner, index)));
187     }
188 
189 
190     // UintSet
191 
192     struct UintSet {
193         Set _inner;
194     }
195 
196     /**
197      * @dev Add a value to a set. O(1).
198      *
199      * Returns true if the value was added to the set, that is if it was not
200      * already present.
201      */
202     function add(UintSet storage set, uint256 value) internal returns (bool) {
203         return _add(set._inner, bytes32(value));
204     }
205 
206     /**
207      * @dev Removes a value from a set. O(1).
208      *
209      * Returns true if the value was removed from the set, that is if it was
210      * present.
211      */
212     function remove(UintSet storage set, uint256 value) internal returns (bool) {
213         return _remove(set._inner, bytes32(value));
214     }
215 
216     /**
217      * @dev Returns true if the value is in the set. O(1).
218      */
219     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
220         return _contains(set._inner, bytes32(value));
221     }
222 
223     /**
224      * @dev Returns the number of values on the set. O(1).
225      */
226     function length(UintSet storage set) internal view returns (uint256) {
227         return _length(set._inner);
228     }
229 
230    /**
231     * @dev Returns the value stored at position `index` in the set. O(1).
232     *
233     * Note that there are no guarantees on the ordering of values inside the
234     * array, and it may change when more values are added or removed.
235     *
236     * Requirements:
237     *
238     * - `index` must be strictly less than {length}.
239     */
240     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
241         return uint256(_at(set._inner, index));
242     }
243 }
244 
245 // File: @openzeppelin/contracts/utils/Address.sol
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 }
305 
306 // File: @openzeppelin/contracts/GSN/Context.sol
307 
308 pragma solidity ^0.6.0;
309 
310 /*
311  * @dev Provides information about the current execution context, including the
312  * sender of the transaction and its data. While these are generally available
313  * via msg.sender and msg.data, they should not be accessed in such a direct
314  * manner, since when dealing with GSN meta-transactions the account sending and
315  * paying for execution may not be the actual sender (as far as an application
316  * is concerned).
317  *
318  * This contract is only required for intermediate, library-like contracts.
319  */
320 contract Context {
321     // Empty internal constructor, to prevent people from mistakenly deploying
322     // an instance of this contract, which should be used via inheritance.
323     constructor () internal { }
324 
325     function _msgSender() internal view virtual returns (address payable) {
326         return msg.sender;
327     }
328 
329     function _msgData() internal view virtual returns (bytes memory) {
330         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
331         return msg.data;
332     }
333 }
334 
335 // File: @openzeppelin/contracts/access/AccessControl.sol
336 
337 pragma solidity ^0.6.0;
338 
339 
340 
341 
342 /**
343  * @dev Contract module that allows children to implement role-based access
344  * control mechanisms.
345  *
346  * Roles are referred to by their `bytes32` identifier. These should be exposed
347  * in the external API and be unique. The best way to achieve this is by
348  * using `public constant` hash digests:
349  *
350  * ```
351  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
352  * ```
353  *
354  * Roles can be used to represent a set of permissions. To restrict access to a
355  * function call, use {hasRole}:
356  *
357  * ```
358  * function foo() public {
359  *     require(hasRole(MY_ROLE, msg.sender));
360  *     ...
361  * }
362  * ```
363  *
364  * Roles can be granted and revoked dynamically via the {grantRole} and
365  * {revokeRole} functions. Each role has an associated admin role, and only
366  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
367  *
368  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
369  * that only accounts with this role will be able to grant or revoke other
370  * roles. More complex role relationships can be created by using
371  * {_setRoleAdmin}.
372  *
373  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
374  * grant and revoke this role. Extra precautions should be taken to secure
375  * accounts that have been granted it.
376  */
377 abstract contract AccessControl is Context {
378     using EnumerableSet for EnumerableSet.AddressSet;
379     using Address for address;
380 
381     struct RoleData {
382         EnumerableSet.AddressSet members;
383         bytes32 adminRole;
384     }
385 
386     mapping (bytes32 => RoleData) private _roles;
387 
388     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
389 
390     /**
391      * @dev Emitted when `account` is granted `role`.
392      *
393      * `sender` is the account that originated the contract call, an admin role
394      * bearer except when using {_setupRole}.
395      */
396     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
397 
398     /**
399      * @dev Emitted when `account` is revoked `role`.
400      *
401      * `sender` is the account that originated the contract call:
402      *   - if using `revokeRole`, it is the admin role bearer
403      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
404      */
405     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
406 
407     /**
408      * @dev Returns `true` if `account` has been granted `role`.
409      */
410     function hasRole(bytes32 role, address account) public view returns (bool) {
411         return _roles[role].members.contains(account);
412     }
413 
414     /**
415      * @dev Returns the number of accounts that have `role`. Can be used
416      * together with {getRoleMember} to enumerate all bearers of a role.
417      */
418     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
419         return _roles[role].members.length();
420     }
421 
422     /**
423      * @dev Returns one of the accounts that have `role`. `index` must be a
424      * value between 0 and {getRoleMemberCount}, non-inclusive.
425      *
426      * Role bearers are not sorted in any particular way, and their ordering may
427      * change at any point.
428      *
429      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
430      * you perform all queries on the same block. See the following
431      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
432      * for more information.
433      */
434     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
435         return _roles[role].members.at(index);
436     }
437 
438     /**
439      * @dev Returns the admin role that controls `role`. See {grantRole} and
440      * {revokeRole}.
441      *
442      * To change a role's admin, use {_setRoleAdmin}.
443      */
444     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
445         return _roles[role].adminRole;
446     }
447 
448     /**
449      * @dev Grants `role` to `account`.
450      *
451      * If `account` had not been already granted `role`, emits a {RoleGranted}
452      * event.
453      *
454      * Requirements:
455      *
456      * - the caller must have ``role``'s admin role.
457      */
458     function grantRole(bytes32 role, address account) public virtual {
459         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
460 
461         _grantRole(role, account);
462     }
463 
464     /**
465      * @dev Revokes `role` from `account`.
466      *
467      * If `account` had been granted `role`, emits a {RoleRevoked} event.
468      *
469      * Requirements:
470      *
471      * - the caller must have ``role``'s admin role.
472      */
473     function revokeRole(bytes32 role, address account) public virtual {
474         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
475 
476         _revokeRole(role, account);
477     }
478 
479     /**
480      * @dev Revokes `role` from the calling account.
481      *
482      * Roles are often managed via {grantRole} and {revokeRole}: this function's
483      * purpose is to provide a mechanism for accounts to lose their privileges
484      * if they are compromised (such as when a trusted device is misplaced).
485      *
486      * If the calling account had been granted `role`, emits a {RoleRevoked}
487      * event.
488      *
489      * Requirements:
490      *
491      * - the caller must be `account`.
492      */
493     function renounceRole(bytes32 role, address account) public virtual {
494         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
495 
496         _revokeRole(role, account);
497     }
498 
499     /**
500      * @dev Grants `role` to `account`.
501      *
502      * If `account` had not been already granted `role`, emits a {RoleGranted}
503      * event. Note that unlike {grantRole}, this function doesn't perform any
504      * checks on the calling account.
505      *
506      * [WARNING]
507      * ====
508      * This function should only be called from the constructor when setting
509      * up the initial roles for the system.
510      *
511      * Using this function in any other way is effectively circumventing the admin
512      * system imposed by {AccessControl}.
513      * ====
514      */
515     function _setupRole(bytes32 role, address account) internal virtual {
516         _grantRole(role, account);
517     }
518 
519     /**
520      * @dev Sets `adminRole` as ``role``'s admin role.
521      */
522     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
523         _roles[role].adminRole = adminRole;
524     }
525 
526     function _grantRole(bytes32 role, address account) private {
527         if (_roles[role].members.add(account)) {
528             emit RoleGranted(role, account, _msgSender());
529         }
530     }
531 
532     function _revokeRole(bytes32 role, address account) private {
533         if (_roles[role].members.remove(account)) {
534             emit RoleRevoked(role, account, _msgSender());
535         }
536     }
537 }
538 
539 // File: contracts/utils/Pausable.sol
540 
541 // SPDX-License-Identifier: MIT
542 
543 pragma solidity ^0.6.0;
544 
545 
546 /**
547  * @dev Contract module which allows children to implement an emergency stop
548  * mechanism that can be triggered by an authorized account.
549  *
550  * This is a stripped down version of Open zeppelin's Pausable contract.
551  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/EnumerableSet.sol
552  *
553  */
554 contract Pausable {
555     /**
556      * @dev Emitted when the pause is triggered by `account`.
557      */
558     event Paused(address account);
559 
560     /**
561      * @dev Emitted when the pause is lifted by `account`.
562      */
563     event Unpaused(address account);
564 
565     bool private _paused;
566 
567     /**
568      * @dev Initializes the contract in unpaused state.
569      */
570     constructor () internal {
571         _paused = false;
572     }
573 
574     /**
575      * @dev Returns true if the contract is paused, and false otherwise.
576      */
577     function paused() public view returns (bool) {
578         return _paused;
579     }
580 
581     /**
582      * @dev Modifier to make a function callable only when the contract is not paused.
583      *
584      * Requirements:
585      *
586      * - The contract must not be paused.
587      */
588     modifier whenNotPaused() {
589         _whenNotPaused();
590         _;
591     }
592 
593     function _whenNotPaused() private view {
594         require(!_paused, "Pausable: paused");
595     }
596 
597     /**
598      * @dev Modifier to make a function callable only when the contract is not paused.
599      *
600      * Requirements:
601      *
602      * - The contract must not be paused.
603      */
604     modifier whenPaused() {
605         _whenPaused();
606         _;
607     }
608 
609     function _whenPaused() private view {
610         require(_paused, "Pausable: not paused");
611     }
612 
613     /**
614      * @dev Triggers stopped state.
615      *
616      * Requirements:
617      *
618      * - The contract must not be paused.
619      */
620     function _pause() internal virtual whenNotPaused {
621         _paused = true;
622         emit Paused(msg.sender);
623     }
624 
625     /**
626      * @dev Returns to normal state.
627      *
628      * Requirements:
629      *
630      * - The contract must be paused.
631      */
632     function _unpause() internal virtual whenPaused {
633         _paused = false;
634         emit Unpaused(msg.sender);
635     }
636 }
637 
638 // File: contracts/utils/SafeMath.sol
639 
640 // SPDX-License-Identifier: MIT
641 
642 pragma solidity ^0.6.0;
643 
644 /**
645  * @dev Wrappers over Solidity's arithmetic operations with added overflow
646  * checks.
647  *
648  * note that this is a stripped down version of open zeppelin's safemath
649  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
650  */
651 
652 contract SafeMath {
653 
654     /**
655      * @dev Returns the subtraction of two unsigned integers, reverting on
656      * overflow (when the result is negative).
657      *
658      * Counterpart to Solidity's `-` operator.
659      *
660      * Requirements:
661      * - Subtraction cannot overflow.
662      */
663     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
664         return _sub(a, b, "SafeMath: subtraction overflow");
665     }
666 
667     /**
668      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
669      * overflow (when the result is negative).
670      *
671      * Counterpart to Solidity's `-` operator.
672      *
673      * Requirements:
674      * - Subtraction cannot overflow.
675      */
676     function _sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
677         require(b <= a, errorMessage);
678         uint256 c = a - b;
679 
680         return c;
681     }
682 
683 }
684 
685 // File: contracts/interfaces/IDepositExecute.sol
686 
687 pragma solidity 0.6.4;
688 
689 /**
690     @title Interface for handler contracts that support deposits and deposit executions.
691     @author ChainSafe Systems.
692  */
693 interface IDepositExecute {
694     /**
695         @notice It is intended that deposit are made using the Bridge contract.
696         @param destinationChainID Chain ID deposit is expected to be bridged to.
697         @param depositNonce This value is generated as an ID by the Bridge contract.
698         @param depositer Address of account making the deposit in the Bridge contract.
699         @param data Consists of additional data needed for a specific deposit.
700      */
701     function deposit(bytes32 resourceID, uint8 destinationChainID, uint64 depositNonce, address depositer, bytes calldata data) external;
702 
703     /**
704         @notice It is intended that proposals are executed by the Bridge contract.
705         @param data Consists of additional data needed for a specific deposit execution.
706      */
707     function executeProposal(bytes32 resourceID, bytes calldata data) external;
708 }
709 
710 // File: contracts/interfaces/IBridge.sol
711 
712 pragma solidity 0.6.4;
713 
714 /**
715     @title Interface for Bridge contract.
716     @author ChainSafe Systems.
717  */
718 interface IBridge {
719     /**
720         @notice Exposing getter for {_chainID} instead of forcing the use of call.
721         @return uint8 The {_chainID} that is currently set for the Bridge contract.
722      */
723     function _chainID() external returns (uint8);
724 }
725 
726 // File: contracts/interfaces/IERCHandler.sol
727 
728 pragma solidity 0.6.4;
729 
730 /**
731     @title Interface to be used with handlers that support ERC20s and ERC721s.
732     @author ChainSafe Systems.
733  */
734 interface IERCHandler {
735     /**
736         @notice Correlates {resourceID} with {contractAddress}.
737         @param resourceID ResourceID to be used when making deposits.
738         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
739      */
740     function setResource(bytes32 resourceID, address contractAddress) external;
741     /**
742         @notice Marks {contractAddress} as mintable/burnable.
743         @param contractAddress Address of contract to be used when making or executing deposits.
744      */
745     function setBurnable(address contractAddress) external;
746     /**
747         @notice Used to manually release funds from ERC safes.
748         @param tokenAddress Address of token contract to release.
749         @param recipient Address to release tokens to.
750         @param amountOrTokenID Either the amount of ERC20 tokens or the ERC721 token ID to release.
751      */
752     function withdraw(address tokenAddress, address recipient, uint256 amountOrTokenID) external;
753 }
754 
755 // File: contracts/interfaces/IGenericHandler.sol
756 
757 pragma solidity 0.6.4;
758 
759 /**
760     @title Interface for handler that handles generic deposits and deposit executions.
761     @author ChainSafe Systems.
762  */
763 interface IGenericHandler {
764     /**
765         @notice Correlates {resourceID} with {contractAddress}, {depositFunctionSig}, and {executeFunctionSig}.
766         @param resourceID ResourceID to be used when making deposits.
767         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
768         @param depositFunctionSig Function signature of method to be called in {contractAddress} when a deposit is made.
769         @param executeFunctionSig Function signature of method to be called in {contractAddress} when a deposit is executed.
770      */
771     function setResource(bytes32 resourceID, address contractAddress, bytes4 depositFunctionSig, bytes4 executeFunctionSig) external;
772 }
773 
774 // File: contracts/Bridge.sol
775 
776 pragma solidity 0.6.4;
777 pragma experimental ABIEncoderV2;
778 
779 
780 
781 
782 
783 
784 
785 
786 /**
787     @title Facilitates deposits, creation and votiing of deposit proposals, and deposit executions.
788     @author ChainSafe Systems.
789  */
790 contract Bridge is Pausable, AccessControl, SafeMath {
791 
792     uint8   public _chainID;
793     uint256 public _relayerThreshold;
794     uint256 public _totalRelayers;
795     uint256 public _totalProposals;
796     uint256 public _fee;
797     uint256 public _expiry;
798 
799     enum Vote {No, Yes}
800 
801     enum ProposalStatus {Inactive, Active, Passed, Executed, Cancelled}
802 
803     struct Proposal {
804         bytes32 _resourceID;
805         bytes32 _dataHash;
806         address[] _yesVotes;
807         address[] _noVotes;
808         ProposalStatus _status;
809         uint256 _proposedBlock;
810     }
811 
812     // destinationChainID => number of deposits
813     mapping(uint8 => uint64) public _depositCounts;
814     // resourceID => handler address
815     mapping(bytes32 => address) public _resourceIDToHandlerAddress;
816     // depositNonce => destinationChainID => bytes
817     mapping(uint64 => mapping(uint8 => bytes)) public _depositRecords;
818     // destinationChainID + depositNonce => dataHash => Proposal
819     mapping(uint72 => mapping(bytes32 => Proposal)) public _proposals;
820     // destinationChainID + depositNonce => dataHash => relayerAddress => bool
821     mapping(uint72 => mapping(bytes32 => mapping(address => bool))) public _hasVotedOnProposal;
822 
823     event RelayerThresholdChanged(uint indexed newThreshold);
824     event RelayerAdded(address indexed relayer);
825     event RelayerRemoved(address indexed relayer);
826     event Deposit(
827         uint8   indexed destinationChainID,
828         bytes32 indexed resourceID,
829         uint64  indexed depositNonce
830     );
831     event ProposalEvent(
832         uint8           indexed originChainID,
833         uint64          indexed depositNonce,
834         ProposalStatus  indexed status,
835         bytes32 resourceID,
836         bytes32 dataHash
837     );
838 
839     event ProposalVote(
840         uint8   indexed originChainID,
841         uint64  indexed depositNonce,
842         ProposalStatus indexed status,
843         bytes32 resourceID
844     );
845 
846     bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");
847 
848     modifier onlyAdmin() {
849         _onlyAdmin();
850         _;
851     }
852 
853     modifier onlyAdminOrRelayer() {
854         _onlyAdminOrRelayer();
855         _;
856     }
857 
858     modifier onlyRelayers() {
859         _onlyRelayers();
860         _;
861     }
862 
863     function _onlyAdminOrRelayer() private {
864         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(RELAYER_ROLE, msg.sender),
865             "sender is not relayer or admin");
866     }
867 
868     function _onlyAdmin() private {
869         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "sender doesn't have admin role");
870     }
871 
872     function _onlyRelayers() private {
873         require(hasRole(RELAYER_ROLE, msg.sender), "sender doesn't have relayer role");
874     }
875 
876     /**
877         @notice Initializes Bridge, creates and grants {msg.sender} the admin role,
878         creates and grants {initialRelayers} the relayer role.
879         @param chainID ID of chain the Bridge contract exists on.
880         @param initialRelayers Addresses that should be initially granted the relayer role.
881         @param initialRelayerThreshold Number of votes needed for a deposit proposal to be considered passed.
882      */
883     constructor (uint8 chainID, address[] memory initialRelayers, uint initialRelayerThreshold, uint256 fee, uint256 expiry) public {
884         _chainID = chainID;
885         _relayerThreshold = initialRelayerThreshold;
886         _fee = fee;
887         _expiry = expiry;
888 
889         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
890         _setRoleAdmin(RELAYER_ROLE, DEFAULT_ADMIN_ROLE);
891 
892         for (uint i; i < initialRelayers.length; i++) {
893             grantRole(RELAYER_ROLE, initialRelayers[i]);
894             _totalRelayers++;
895         }
896 
897     }
898 
899     /**
900         @notice Returns true if {relayer} has the relayer role.
901         @param relayer Address to check.
902      */
903     function isRelayer(address relayer) external view returns (bool) {
904         return hasRole(RELAYER_ROLE, relayer);
905     }
906 
907     /**
908         @notice Removes admin role from {msg.sender} and grants it to {newAdmin}.
909         @notice Only callable by an address that currently has the admin role.
910         @param newAdmin Address that admin role will be granted to.
911      */
912     function renounceAdmin(address newAdmin) external onlyAdmin {
913         grantRole(DEFAULT_ADMIN_ROLE, newAdmin);
914         renounceRole(DEFAULT_ADMIN_ROLE, msg.sender);
915     }
916 
917     /**
918         @notice Pauses deposits, proposal creation and voting, and deposit executions.
919         @notice Only callable by an address that currently has the admin role.
920      */
921     function adminPauseTransfers() external onlyAdmin {
922         _pause();
923     }
924 
925     /**
926         @notice Unpauses deposits, proposal creation and voting, and deposit executions.
927         @notice Only callable by an address that currently has the admin role.
928      */
929     function adminUnpauseTransfers() external onlyAdmin {
930         _unpause();
931     }
932 
933     /**
934         @notice Modifies the number of votes required for a proposal to be considered passed.
935         @notice Only callable by an address that currently has the admin role.
936         @param newThreshold Value {_relayerThreshold} will be changed to.
937         @notice Emits {RelayerThresholdChanged} event.
938      */
939     function adminChangeRelayerThreshold(uint newThreshold) external onlyAdmin {
940         _relayerThreshold = newThreshold;
941         emit RelayerThresholdChanged(newThreshold);
942     }
943 
944     /**
945         @notice Grants {relayerAddress} the relayer role and increases {_totalRelayer} count.
946         @notice Only callable by an address that currently has the admin role.
947         @param relayerAddress Address of relayer to be added.
948         @notice Emits {RelayerAdded} event.
949      */
950     function adminAddRelayer(address relayerAddress) external onlyAdmin {
951         require(!hasRole(RELAYER_ROLE, relayerAddress), "addr already has relayer role!");
952         grantRole(RELAYER_ROLE, relayerAddress);
953         emit RelayerAdded(relayerAddress);
954         _totalRelayers++;
955     }
956 
957     /**
958         @notice Removes relayer role for {relayerAddress} and decreases {_totalRelayer} count.
959         @notice Only callable by an address that currently has the admin role.
960         @param relayerAddress Address of relayer to be removed.
961         @notice Emits {RelayerRemoved} event.
962      */
963     function adminRemoveRelayer(address relayerAddress) external onlyAdmin {
964         require(hasRole(RELAYER_ROLE, relayerAddress), "addr doesn't have relayer role!");
965         revokeRole(RELAYER_ROLE, relayerAddress);
966         emit RelayerRemoved(relayerAddress);
967         _totalRelayers--;
968     }
969 
970     /**
971         @notice Sets a new resource for handler contracts that use the IERCHandler interface,
972         and maps the {handlerAddress} to {resourceID} in {_resourceIDToHandlerAddress}.
973         @notice Only callable by an address that currently has the admin role.
974         @param handlerAddress Address of handler resource will be set for.
975         @param resourceID ResourceID to be used when making deposits.
976         @param tokenAddress Address of contract to be called when a deposit is made and a deposited is executed.
977      */
978     function adminSetResource(address handlerAddress, bytes32 resourceID, address tokenAddress) external onlyAdmin {
979         _resourceIDToHandlerAddress[resourceID] = handlerAddress;
980         IERCHandler handler = IERCHandler(handlerAddress);
981         handler.setResource(resourceID, tokenAddress);
982     }
983 
984     /**
985         @notice Sets a new resource for handler contracts that use the IGenericHandler interface,
986         and maps the {handlerAddress} to {resourceID} in {_resourceIDToHandlerAddress}.
987         @notice Only callable by an address that currently has the admin role.
988         @param handlerAddress Address of handler resource will be set for.
989         @param resourceID ResourceID to be used when making deposits.
990         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
991      */
992     function adminSetGenericResource(
993         address handlerAddress,
994         bytes32 resourceID,
995         address contractAddress,
996         bytes4 depositFunctionSig,
997         bytes4 executeFunctionSig
998     ) external onlyAdmin {
999         _resourceIDToHandlerAddress[resourceID] = handlerAddress;
1000         IGenericHandler handler = IGenericHandler(handlerAddress);
1001         handler.setResource(resourceID, contractAddress, depositFunctionSig, executeFunctionSig);
1002     }
1003 
1004     /**
1005         @notice Sets a resource as burnable for handler contracts that use the IERCHandler interface.
1006         @notice Only callable by an address that currently has the admin role.
1007         @param handlerAddress Address of handler resource will be set for.
1008         @param tokenAddress Address of contract to be called when a deposit is made and a deposited is executed.
1009      */
1010     function adminSetBurnable(address handlerAddress, address tokenAddress) external onlyAdmin {
1011         IERCHandler handler = IERCHandler(handlerAddress);
1012         handler.setBurnable(tokenAddress);
1013     }
1014 
1015     /**
1016         @notice Returns a proposal.
1017         @param originChainID Chain ID deposit originated from.
1018         @param depositNonce ID of proposal generated by proposal's origin Bridge contract.
1019         @param dataHash Hash of data to be provided when deposit proposal is executed.
1020         @return Proposal which consists of:
1021         - _dataHash Hash of data to be provided when deposit proposal is executed.
1022         - _yesVotes Number of votes in favor of proposal.
1023         - _noVotes Number of votes against proposal.
1024         - _status Current status of proposal.
1025      */
1026     function getProposal(uint8 originChainID, uint64 depositNonce, bytes32 dataHash) external view returns (Proposal memory) {
1027         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(originChainID);
1028         return _proposals[nonceAndID][dataHash];
1029     }
1030 
1031     /**
1032         @notice Changes deposit fee.
1033         @notice Only callable by admin.
1034         @param newFee Value {_fee} will be updated to.
1035      */
1036     function adminChangeFee(uint newFee) external onlyAdmin {
1037         require(_fee != newFee, "Current fee is equal to new fee");
1038         _fee = newFee;
1039     }
1040 
1041     /**
1042         @notice Used to manually withdraw funds from ERC safes.
1043         @param handlerAddress Address of handler to withdraw from.
1044         @param tokenAddress Address of token to withdraw.
1045         @param recipient Address to withdraw tokens to.
1046         @param amountOrTokenID Either the amount of ERC20 tokens or the ERC721 token ID to withdraw.
1047      */
1048     function adminWithdraw(
1049         address handlerAddress,
1050         address tokenAddress,
1051         address recipient,
1052         uint256 amountOrTokenID
1053     ) external onlyAdmin {
1054         IERCHandler handler = IERCHandler(handlerAddress);
1055         handler.withdraw(tokenAddress, recipient, amountOrTokenID);
1056     }
1057 
1058     /**
1059         @notice Initiates a transfer using a specified handler contract.
1060         @notice Only callable when Bridge is not paused.
1061         @param destinationChainID ID of chain deposit will be bridged to.
1062         @param resourceID ResourceID used to find address of handler to be used for deposit.
1063         @param data Additional data to be passed to specified handler.
1064         @notice Emits {Deposit} event.
1065      */
1066     function deposit(uint8 destinationChainID, bytes32 resourceID, bytes calldata data) external payable whenNotPaused {
1067         require(msg.value == _fee, "Incorrect fee supplied");
1068 
1069         address handler = _resourceIDToHandlerAddress[resourceID];
1070         require(handler != address(0), "resourceID not mapped to handler");
1071 
1072         uint64 depositNonce = ++_depositCounts[destinationChainID];
1073         _depositRecords[depositNonce][destinationChainID] = data;
1074 
1075         IDepositExecute depositHandler = IDepositExecute(handler);
1076         depositHandler.deposit(resourceID, destinationChainID, depositNonce, msg.sender, data);
1077 
1078         emit Deposit(destinationChainID, resourceID, depositNonce);
1079     }
1080 
1081     /**
1082         @notice When called, {msg.sender} will be marked as voting in favor of proposal.
1083         @notice Only callable by relayers when Bridge is not paused.
1084         @param chainID ID of chain deposit originated from.
1085         @param depositNonce ID of deposited generated by origin Bridge contract.
1086         @param dataHash Hash of data provided when deposit was made.
1087         @notice Proposal must not have already been passed or executed.
1088         @notice {msg.sender} must not have already voted on proposal.
1089         @notice Emits {ProposalEvent} event with status indicating the proposal status.
1090         @notice Emits {ProposalVote} event.
1091      */
1092     function voteProposal(uint8 chainID, uint64 depositNonce, bytes32 resourceID, bytes32 dataHash) external onlyRelayers whenNotPaused {
1093 
1094         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1095         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1096 
1097         require(_resourceIDToHandlerAddress[resourceID] != address(0), "no handler for resourceID");
1098         require(uint(proposal._status) <= 1, "proposal already passed/executed/cancelled");
1099         require(!_hasVotedOnProposal[nonceAndID][dataHash][msg.sender], "relayer already voted");
1100 
1101         if (uint(proposal._status) == 0) {
1102             ++_totalProposals;
1103             _proposals[nonceAndID][dataHash] = Proposal({
1104                 _resourceID : resourceID,
1105                 _dataHash : dataHash,
1106                 _yesVotes : new address[](1),
1107                 _noVotes : new address[](0),
1108                 _status : ProposalStatus.Active,
1109                 _proposedBlock : block.number
1110                 });
1111 
1112             proposal._yesVotes[0] = msg.sender;
1113             emit ProposalEvent(chainID, depositNonce, ProposalStatus.Active, resourceID, dataHash);
1114         } else {
1115             if (sub(block.number, proposal._proposedBlock) > _expiry) {
1116                 // if the number of blocks that has passed since this proposal was
1117                 // submitted exceeds the expiry threshold set, cancel the proposal
1118                 proposal._status = ProposalStatus.Cancelled;
1119                 emit ProposalEvent(chainID, depositNonce, ProposalStatus.Cancelled, resourceID, dataHash);
1120             } else {
1121                 require(dataHash == proposal._dataHash, "datahash mismatch");
1122                 proposal._yesVotes.push(msg.sender);
1123 
1124 
1125             }
1126 
1127         }
1128         if (proposal._status != ProposalStatus.Cancelled) {
1129             _hasVotedOnProposal[nonceAndID][dataHash][msg.sender] = true;
1130             emit ProposalVote(chainID, depositNonce, proposal._status, resourceID);
1131 
1132             // If _depositThreshold is set to 1, then auto finalize
1133             // or if _relayerThreshold has been exceeded
1134             if (_relayerThreshold <= 1 || proposal._yesVotes.length >= _relayerThreshold) {
1135                 proposal._status = ProposalStatus.Passed;
1136 
1137                 emit ProposalEvent(chainID, depositNonce, ProposalStatus.Passed, resourceID, dataHash);
1138             }
1139         }
1140 
1141     }
1142 
1143     /**
1144         @notice Executes a deposit proposal that is considered passed using a specified handler contract.
1145         @notice Only callable by relayers when Bridge is not paused.
1146         @param chainID ID of chain deposit originated from.
1147         @param depositNonce ID of deposited generated by origin Bridge contract.
1148         @param dataHash Hash of data originally provided when deposit was made.
1149         @notice Proposal must be past expiry threshold.
1150         @notice Emits {ProposalEvent} event with status {Cancelled}.
1151      */
1152     function cancelProposal(uint8 chainID, uint64 depositNonce, bytes32 dataHash) public onlyAdminOrRelayer {
1153         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1154         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1155 
1156         require(proposal._status != ProposalStatus.Cancelled, "Proposal already cancelled");
1157         require(sub(block.number, proposal._proposedBlock) > _expiry, "Proposal not at expiry threshold");
1158 
1159         proposal._status = ProposalStatus.Cancelled;
1160         emit ProposalEvent(chainID, depositNonce, ProposalStatus.Cancelled, proposal._resourceID, proposal._dataHash);
1161 
1162     }
1163 
1164     /**
1165         @notice Executes a deposit proposal that is considered passed using a specified handler contract.
1166         @notice Only callable by relayers when Bridge is not paused.
1167         @param chainID ID of chain deposit originated from.
1168         @param resourceID ResourceID to be used when making deposits.
1169         @param depositNonce ID of deposited generated by origin Bridge contract.
1170         @param data Data originally provided when deposit was made.
1171         @notice Proposal must have Passed status.
1172         @notice Hash of {data} must equal proposal's {dataHash}.
1173         @notice Emits {ProposalEvent} event with status {Executed}.
1174      */
1175     function executeProposal(uint8 chainID, uint64 depositNonce, bytes calldata data, bytes32 resourceID) external onlyRelayers whenNotPaused {
1176         address handler = _resourceIDToHandlerAddress[resourceID];
1177         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1178         bytes32 dataHash = keccak256(abi.encodePacked(handler, data));
1179         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1180 
1181         require(proposal._status != ProposalStatus.Inactive, "proposal is not active");
1182         require(proposal._status == ProposalStatus.Passed, "proposal already transferred");
1183         require(dataHash == proposal._dataHash, "data doesn't match datahash");
1184 
1185         proposal._status = ProposalStatus.Executed;
1186 
1187         IDepositExecute depositHandler = IDepositExecute(_resourceIDToHandlerAddress[proposal._resourceID]);
1188         depositHandler.executeProposal(proposal._resourceID, data);
1189 
1190         emit ProposalEvent(chainID, depositNonce, proposal._status, proposal._resourceID, proposal._dataHash);
1191     }
1192 
1193     /**
1194         @notice Transfers eth in the contract to the specified addresses. The parameters addrs and amounts are mapped 1-1.
1195         This means that the address at index 0 for addrs will receive the amount (in WEI) from amounts at index 0.
1196         @param addrs Array of addresses to transfer {amounts} to.
1197         @param amounts Array of amonuts to transfer to {addrs}.
1198      */
1199     function transferFunds(address payable[] calldata addrs, uint[] calldata amounts) external onlyAdmin {
1200         for (uint i = 0; i < addrs.length; i++) {
1201             addrs[i].transfer(amounts[i]);
1202         }
1203     }
1204 
1205 }