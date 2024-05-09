1 pragma solidity 0.6.4;
2 pragma experimental ABIEncoderV2;
3 
4 
5 
6 
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
29  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
30  * (`UintSet`) are supported.
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
45 
46         // Position of the value in the `values` array, plus 1 because index 0
47         // means a value is not in the set.
48         mapping (bytes32 => uint256) _indexes;
49     }
50 
51     /**
52      * @dev Add a value to a set. O(1).
53      *
54      * Returns true if the value was added to the set, that is if it was not
55      * already present.
56      */
57     function _add(Set storage set, bytes32 value) private returns (bool) {
58         if (!_contains(set, value)) {
59             set._values.push(value);
60             // The value is stored at length-1, but we add 1 to all indexes
61             // and use 0 as a sentinel value
62             set._indexes[value] = set._values.length;
63             return true;
64         } else {
65             return false;
66         }
67     }
68 
69     /**
70      * @dev Removes a value from a set. O(1).
71      *
72      * Returns true if the value was removed from the set, that is if it was
73      * present.
74      */
75     function _remove(Set storage set, bytes32 value) private returns (bool) {
76         // We read and store the value's index to prevent multiple reads from the same storage slot
77         uint256 valueIndex = set._indexes[value];
78 
79         if (valueIndex != 0) { // Equivalent to contains(set, value)
80             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
81             // the array, and then remove the last element (sometimes called as 'swap and pop').
82             // This modifies the order of the array, as noted in {at}.
83 
84             uint256 toDeleteIndex = valueIndex - 1;
85             uint256 lastIndex = set._values.length - 1;
86 
87             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
88             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
89 
90             bytes32 lastvalue = set._values[lastIndex];
91 
92             // Move the last value to the index where the value to delete is
93             set._values[toDeleteIndex] = lastvalue;
94             // Update the index for the moved value
95             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
96 
97             // Delete the slot where the moved value was stored
98             set._values.pop();
99 
100             // Delete the index for the deleted slot
101             delete set._indexes[value];
102 
103             return true;
104         } else {
105             return false;
106         }
107     }
108 
109     /**
110      * @dev Returns true if the value is in the set. O(1).
111      */
112     function _contains(Set storage set, bytes32 value) private view returns (bool) {
113         return set._indexes[value] != 0;
114     }
115 
116     /**
117      * @dev Returns the number of values on the set. O(1).
118      */
119     function _length(Set storage set) private view returns (uint256) {
120         return set._values.length;
121     }
122 
123    /**
124     * @dev Returns the value stored at position `index` in the set. O(1).
125     *
126     * Note that there are no guarantees on the ordering of values inside the
127     * array, and it may change when more values are added or removed.
128     *
129     * Requirements:
130     *
131     * - `index` must be strictly less than {length}.
132     */
133     function _at(Set storage set, uint256 index) private view returns (bytes32) {
134         require(set._values.length > index, "EnumerableSet: index out of bounds");
135         return set._values[index];
136     }
137 
138     // AddressSet
139 
140     struct AddressSet {
141         Set _inner;
142     }
143 
144     /**
145      * @dev Add a value to a set. O(1).
146      *
147      * Returns true if the value was added to the set, that is if it was not
148      * already present.
149      */
150     function add(AddressSet storage set, address value) internal returns (bool) {
151         return _add(set._inner, bytes32(uint256(value)));
152     }
153 
154     /**
155      * @dev Removes a value from a set. O(1).
156      *
157      * Returns true if the value was removed from the set, that is if it was
158      * present.
159      */
160     function remove(AddressSet storage set, address value) internal returns (bool) {
161         return _remove(set._inner, bytes32(uint256(value)));
162     }
163 
164     /**
165      * @dev Returns true if the value is in the set. O(1).
166      */
167     function contains(AddressSet storage set, address value) internal view returns (bool) {
168         return _contains(set._inner, bytes32(uint256(value)));
169     }
170 
171     /**
172      * @dev Returns the number of values in the set. O(1).
173      */
174     function length(AddressSet storage set) internal view returns (uint256) {
175         return _length(set._inner);
176     }
177 
178    /**
179     * @dev Returns the value stored at position `index` in the set. O(1).
180     *
181     * Note that there are no guarantees on the ordering of values inside the
182     * array, and it may change when more values are added or removed.
183     *
184     * Requirements:
185     *
186     * - `index` must be strictly less than {length}.
187     */
188     function at(AddressSet storage set, uint256 index) internal view returns (address) {
189         return address(uint256(_at(set._inner, index)));
190     }
191 
192 
193     // UintSet
194 
195     struct UintSet {
196         Set _inner;
197     }
198 
199     /**
200      * @dev Add a value to a set. O(1).
201      *
202      * Returns true if the value was added to the set, that is if it was not
203      * already present.
204      */
205     function add(UintSet storage set, uint256 value) internal returns (bool) {
206         return _add(set._inner, bytes32(value));
207     }
208 
209     /**
210      * @dev Removes a value from a set. O(1).
211      *
212      * Returns true if the value was removed from the set, that is if it was
213      * present.
214      */
215     function remove(UintSet storage set, uint256 value) internal returns (bool) {
216         return _remove(set._inner, bytes32(value));
217     }
218 
219     /**
220      * @dev Returns true if the value is in the set. O(1).
221      */
222     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
223         return _contains(set._inner, bytes32(value));
224     }
225 
226     /**
227      * @dev Returns the number of values on the set. O(1).
228      */
229     function length(UintSet storage set) internal view returns (uint256) {
230         return _length(set._inner);
231     }
232 
233    /**
234     * @dev Returns the value stored at position `index` in the set. O(1).
235     *
236     * Note that there are no guarantees on the ordering of values inside the
237     * array, and it may change when more values are added or removed.
238     *
239     * Requirements:
240     *
241     * - `index` must be strictly less than {length}.
242     */
243     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
244         return uint256(_at(set._inner, index));
245     }
246 }
247 
248 
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
273         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
274         // for accounts without code, i.e. `keccak256('')`
275         bytes32 codehash;
276         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
277         // solhint-disable-next-line no-inline-assembly
278         assembly { codehash := extcodehash(account) }
279         return (codehash != accountHash && codehash != 0x0);
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
302         (bool success, ) = recipient.call{ value: amount }("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 }
306 
307 
308 
309 /*
310  * @dev Provides information about the current execution context, including the
311  * sender of the transaction and its data. While these are generally available
312  * via msg.sender and msg.data, they should not be accessed in such a direct
313  * manner, since when dealing with GSN meta-transactions the account sending and
314  * paying for execution may not be the actual sender (as far as an application
315  * is concerned).
316  *
317  * This contract is only required for intermediate, library-like contracts.
318  */
319 contract Context {
320     // Empty internal constructor, to prevent people from mistakenly deploying
321     // an instance of this contract, which should be used via inheritance.
322     constructor () internal { }
323 
324     function _msgSender() internal view virtual returns (address payable) {
325         return msg.sender;
326     }
327 
328     function _msgData() internal view virtual returns (bytes memory) {
329         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
330         return msg.data;
331     }
332 }
333 
334 
335 /**
336  * @dev Contract module that allows children to implement role-based access
337  * control mechanisms.
338  *
339  * Roles are referred to by their `bytes32` identifier. These should be exposed
340  * in the external API and be unique. The best way to achieve this is by
341  * using `public constant` hash digests:
342  *
343  * ```
344  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
345  * ```
346  *
347  * Roles can be used to represent a set of permissions. To restrict access to a
348  * function call, use {hasRole}:
349  *
350  * ```
351  * function foo() public {
352  *     require(hasRole(MY_ROLE, msg.sender));
353  *     ...
354  * }
355  * ```
356  *
357  * Roles can be granted and revoked dynamically via the {grantRole} and
358  * {revokeRole} functions. Each role has an associated admin role, and only
359  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
360  *
361  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
362  * that only accounts with this role will be able to grant or revoke other
363  * roles. More complex role relationships can be created by using
364  * {_setRoleAdmin}.
365  *
366  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
367  * grant and revoke this role. Extra precautions should be taken to secure
368  * accounts that have been granted it.
369  */
370 abstract contract AccessControl is Context {
371     using EnumerableSet for EnumerableSet.AddressSet;
372     using Address for address;
373 
374     struct RoleData {
375         EnumerableSet.AddressSet members;
376         bytes32 adminRole;
377     }
378 
379     mapping (bytes32 => RoleData) private _roles;
380 
381     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
382 
383     /**
384      * @dev Emitted when `account` is granted `role`.
385      *
386      * `sender` is the account that originated the contract call, an admin role
387      * bearer except when using {_setupRole}.
388      */
389     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
390 
391     /**
392      * @dev Emitted when `account` is revoked `role`.
393      *
394      * `sender` is the account that originated the contract call:
395      *   - if using `revokeRole`, it is the admin role bearer
396      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
397      */
398     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
399 
400     /**
401      * @dev Returns `true` if `account` has been granted `role`.
402      */
403     function hasRole(bytes32 role, address account) public view returns (bool) {
404         return _roles[role].members.contains(account);
405     }
406 
407     /**
408      * @dev Returns the number of accounts that have `role`. Can be used
409      * together with {getRoleMember} to enumerate all bearers of a role.
410      */
411     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
412         return _roles[role].members.length();
413     }
414 
415     /**
416      * @dev Returns one of the accounts that have `role`. `index` must be a
417      * value between 0 and {getRoleMemberCount}, non-inclusive.
418      *
419      * Role bearers are not sorted in any particular way, and their ordering may
420      * change at any point.
421      *
422      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
423      * you perform all queries on the same block. See the following
424      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
425      * for more information.
426      */
427     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
428         return _roles[role].members.at(index);
429     }
430 
431     /**
432      * @dev Returns the admin role that controls `role`. See {grantRole} and
433      * {revokeRole}.
434      *
435      * To change a role's admin, use {_setRoleAdmin}.
436      */
437     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
438         return _roles[role].adminRole;
439     }
440 
441     /**
442      * @dev Grants `role` to `account`.
443      *
444      * If `account` had not been already granted `role`, emits a {RoleGranted}
445      * event.
446      *
447      * Requirements:
448      *
449      * - the caller must have ``role``'s admin role.
450      */
451     function grantRole(bytes32 role, address account) public virtual {
452         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
453 
454         _grantRole(role, account);
455     }
456 
457     /**
458      * @dev Revokes `role` from `account`.
459      *
460      * If `account` had been granted `role`, emits a {RoleRevoked} event.
461      *
462      * Requirements:
463      *
464      * - the caller must have ``role``'s admin role.
465      */
466     function revokeRole(bytes32 role, address account) public virtual {
467         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
468 
469         _revokeRole(role, account);
470     }
471 
472     /**
473      * @dev Revokes `role` from the calling account.
474      *
475      * Roles are often managed via {grantRole} and {revokeRole}: this function's
476      * purpose is to provide a mechanism for accounts to lose their privileges
477      * if they are compromised (such as when a trusted device is misplaced).
478      *
479      * If the calling account had been granted `role`, emits a {RoleRevoked}
480      * event.
481      *
482      * Requirements:
483      *
484      * - the caller must be `account`.
485      */
486     function renounceRole(bytes32 role, address account) public virtual {
487         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
488 
489         _revokeRole(role, account);
490     }
491 
492     /**
493      * @dev Grants `role` to `account`.
494      *
495      * If `account` had not been already granted `role`, emits a {RoleGranted}
496      * event. Note that unlike {grantRole}, this function doesn't perform any
497      * checks on the calling account.
498      *
499      * [WARNING]
500      * ====
501      * This function should only be called from the constructor when setting
502      * up the initial roles for the system.
503      *
504      * Using this function in any other way is effectively circumventing the admin
505      * system imposed by {AccessControl}.
506      * ====
507      */
508     function _setupRole(bytes32 role, address account) internal virtual {
509         _grantRole(role, account);
510     }
511 
512     /**
513      * @dev Sets `adminRole` as ``role``'s admin role.
514      */
515     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
516         _roles[role].adminRole = adminRole;
517     }
518 
519     function _grantRole(bytes32 role, address account) private {
520         if (_roles[role].members.add(account)) {
521             emit RoleGranted(role, account, _msgSender());
522         }
523     }
524 
525     function _revokeRole(bytes32 role, address account) private {
526         if (_roles[role].members.remove(account)) {
527             emit RoleRevoked(role, account, _msgSender());
528         }
529     }
530 }
531 
532 // SPDX-License-Identifier: MIT
533 
534 
535 
536 
537 /**
538  * @dev Contract module which allows children to implement an emergency stop
539  * mechanism that can be triggered by an authorized account.
540  *
541  * This is a stripped down version of Open zeppelin's Pausable contract.
542  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/EnumerableSet.sol
543  *
544  */
545 contract Pausable {
546     /**
547      * @dev Emitted when the pause is triggered by `account`.
548      */
549     event Paused(address account);
550 
551     /**
552      * @dev Emitted when the pause is lifted by `account`.
553      */
554     event Unpaused(address account);
555 
556     bool private _paused;
557 
558     /**
559      * @dev Initializes the contract in unpaused state.
560      */
561     constructor () internal {
562         _paused = false;
563     }
564 
565     /**
566      * @dev Returns true if the contract is paused, and false otherwise.
567      */
568     function paused() public view returns (bool) {
569         return _paused;
570     }
571 
572     /**
573      * @dev Modifier to make a function callable only when the contract is not paused.
574      *
575      * Requirements:
576      *
577      * - The contract must not be paused.
578      */
579     modifier whenNotPaused() {
580         _whenNotPaused();
581         _;
582     }
583 
584     function _whenNotPaused() private view {
585         require(!_paused, "Pausable: paused");
586     }
587 
588     /**
589      * @dev Modifier to make a function callable only when the contract is not paused.
590      *
591      * Requirements:
592      *
593      * - The contract must not be paused.
594      */
595     modifier whenPaused() {
596         _whenPaused();
597         _;
598     }
599 
600     function _whenPaused() private view {
601         require(_paused, "Pausable: not paused");
602     }
603 
604     /**
605      * @dev Triggers stopped state.
606      *
607      * Requirements:
608      *
609      * - The contract must not be paused.
610      */
611     function _pause() internal virtual whenNotPaused {
612         _paused = true;
613         emit Paused(msg.sender);
614     }
615 
616     /**
617      * @dev Returns to normal state.
618      *
619      * Requirements:
620      *
621      * - The contract must be paused.
622      */
623     function _unpause() internal virtual whenPaused {
624         _paused = false;
625         emit Unpaused(msg.sender);
626     }
627 }
628 
629 
630 
631 
632 /**
633  * @dev Wrappers over Solidity's arithmetic operations with added overflow
634  * checks.
635  *
636  * note that this is a stripped down version of open zeppelin's safemath
637  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
638  */
639 
640 contract SafeMath {
641 
642     /**
643      * @dev Returns the subtraction of two unsigned integers, reverting on
644      * overflow (when the result is negative).
645      *
646      * Counterpart to Solidity's `-` operator.
647      *
648      * Requirements:
649      * - Subtraction cannot overflow.
650      */
651     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
652         return _sub(a, b, "SafeMath: subtraction overflow");
653     }
654 
655     /**
656      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
657      * overflow (when the result is negative).
658      *
659      * Counterpart to Solidity's `-` operator.
660      *
661      * Requirements:
662      * - Subtraction cannot overflow.
663      */
664     function _sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
665         require(b <= a, errorMessage);
666         uint256 c = a - b;
667 
668         return c;
669     }
670 
671 }
672 
673 
674 /**
675     @title Interface for handler contracts that support deposits and deposit executions.
676     @author ChainSafe Systems.
677  */
678 interface IDepositExecute {
679     /**
680         @notice It is intended that deposit are made using the Bridge contract.
681         @param destinationChainID Chain ID deposit is expected to be bridged to.
682         @param depositNonce This value is generated as an ID by the Bridge contract.
683         @param depositer Address of account making the deposit in the Bridge contract.
684         @param data Consists of additional data needed for a specific deposit.
685      */
686     function deposit(bytes32 resourceID, uint8 destinationChainID, uint64 depositNonce, address depositer, bytes calldata data) external;
687 
688     /**
689         @notice It is intended that proposals are executed by the Bridge contract.
690         @param data Consists of additional data needed for a specific deposit execution.
691      */
692     function executeProposal(bytes32 resourceID, bytes calldata data) external;
693 }
694 
695 
696 
697 /**
698     @title Interface for Bridge contract.
699     @author ChainSafe Systems.
700  */
701 interface IBridge {
702     /**
703         @notice Exposing getter for {_chainID} instead of forcing the use of call.
704         @return uint8 The {_chainID} that is currently set for the Bridge contract.
705      */
706     function _chainID() external returns (uint8);
707 }
708 
709 
710 /**
711     @title Interface to be used with handlers that support ERC20s and ERC721s.
712     @author ChainSafe Systems.
713  */
714 interface IERCHandler {
715     /**
716         @notice Correlates {resourceID} with {contractAddress}.
717         @param resourceID ResourceID to be used when making deposits.
718         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
719      */
720     function setResource(bytes32 resourceID, address contractAddress) external;
721     /**
722         @notice Marks {contractAddress} as mintable/burnable.
723         @param contractAddress Address of contract to be used when making or executing deposits.
724      */
725     function setBurnable(address contractAddress) external;
726     /**
727         @notice Used to manually release funds from ERC safes.
728         @param tokenAddress Address of token contract to release.
729         @param recipient Address to release tokens to.
730         @param amountOrTokenID Either the amount of ERC20 tokens or the ERC721 token ID to release.
731      */
732     function withdraw(address tokenAddress, address recipient, uint256 amountOrTokenID) external;
733 }
734 
735 
736 
737 /**
738     @title Interface for handler that handles generic deposits and deposit executions.
739     @author ChainSafe Systems.
740  */
741 interface IGenericHandler {
742     /**
743         @notice Correlates {resourceID} with {contractAddress}, {depositFunctionSig}, and {executeFunctionSig}.
744         @param resourceID ResourceID to be used when making deposits.
745         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
746         @param depositFunctionSig Function signature of method to be called in {contractAddress} when a deposit is made.
747         @param executeFunctionSig Function signature of method to be called in {contractAddress} when a deposit is executed.
748      */
749     function setResource(bytes32 resourceID, address contractAddress, bytes4 depositFunctionSig, bytes4 executeFunctionSig) external;
750 }
751 
752 /**
753     @title Facilitates deposits, creation and votiing of deposit proposals, and deposit executions.
754     @author ChainSafe Systems.
755  */
756 contract Bridge is Pausable, AccessControl, SafeMath {
757 
758     uint8   public _chainID;
759     uint256 public _relayerThreshold;
760     uint256 public _totalRelayers;
761     uint256 public _totalProposals;
762     uint256 public _fee;
763     uint256 public _expiry;
764 
765     enum Vote {No, Yes}
766 
767     enum ProposalStatus {Inactive, Active, Passed, Executed, Cancelled}
768 
769     struct Proposal {
770         bytes32 _resourceID;
771         bytes32 _dataHash;
772         address[] _yesVotes;
773         address[] _noVotes;
774         ProposalStatus _status;
775         uint256 _proposedBlock;
776     }
777 
778     // destinationChainID => number of deposits
779     mapping(uint8 => uint64) public _depositCounts;
780     // resourceID => handler address
781     mapping(bytes32 => address) public _resourceIDToHandlerAddress;
782     // depositNonce => destinationChainID => bytes
783     mapping(uint64 => mapping(uint8 => bytes)) public _depositRecords;
784     // destinationChainID + depositNonce => dataHash => Proposal
785     mapping(uint72 => mapping(bytes32 => Proposal)) public _proposals;
786     // destinationChainID + depositNonce => dataHash => relayerAddress => bool
787     mapping(uint72 => mapping(bytes32 => mapping(address => bool))) public _hasVotedOnProposal;
788 
789     event RelayerThresholdChanged(uint indexed newThreshold);
790     event RelayerAdded(address indexed relayer);
791     event RelayerRemoved(address indexed relayer);
792     event Deposit(
793         uint8   indexed destinationChainID,
794         bytes32 indexed resourceID,
795         uint64  indexed depositNonce
796     );
797     event ProposalEvent(
798         uint8           indexed originChainID,
799         uint64          indexed depositNonce,
800         ProposalStatus  indexed status,
801         bytes32 resourceID,
802         bytes32 dataHash
803     );
804 
805     event ProposalVote(
806         uint8   indexed originChainID,
807         uint64  indexed depositNonce,
808         ProposalStatus indexed status,
809         bytes32 resourceID
810     );
811 
812     bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");
813 
814     modifier onlyAdmin() {
815         _onlyAdmin();
816         _;
817     }
818 
819     modifier onlyAdminOrRelayer() {
820         _onlyAdminOrRelayer();
821         _;
822     }
823 
824     modifier onlyRelayers() {
825         _onlyRelayers();
826         _;
827     }
828 
829     function _onlyAdminOrRelayer() private {
830         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(RELAYER_ROLE, msg.sender),
831             "sender is not relayer or admin");
832     }
833 
834     function _onlyAdmin() private {
835         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "sender doesn't have admin role");
836     }
837 
838     function _onlyRelayers() private {
839         require(hasRole(RELAYER_ROLE, msg.sender), "sender doesn't have relayer role");
840     }
841 
842     /**
843         @notice Initializes Bridge, creates and grants {msg.sender} the admin role,
844         creates and grants {initialRelayers} the relayer role.
845         @param chainID ID of chain the Bridge contract exists on.
846         @param initialRelayers Addresses that should be initially granted the relayer role.
847         @param initialRelayerThreshold Number of votes needed for a deposit proposal to be considered passed.
848      */
849     constructor (uint8 chainID, address[] memory initialRelayers, uint initialRelayerThreshold, uint256 fee, uint256 expiry) public {
850         _chainID = chainID;
851         _relayerThreshold = initialRelayerThreshold;
852         _fee = fee;
853         _expiry = expiry;
854 
855         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
856         _setRoleAdmin(RELAYER_ROLE, DEFAULT_ADMIN_ROLE);
857 
858         for (uint i; i < initialRelayers.length; i++) {
859             grantRole(RELAYER_ROLE, initialRelayers[i]);
860             _totalRelayers++;
861         }
862 
863     }
864 
865     /**
866         @notice Returns true if {relayer} has the relayer role.
867         @param relayer Address to check.
868      */
869     function isRelayer(address relayer) external view returns (bool) {
870         return hasRole(RELAYER_ROLE, relayer);
871     }
872 
873     /**
874         @notice Removes admin role from {msg.sender} and grants it to {newAdmin}.
875         @notice Only callable by an address that currently has the admin role.
876         @param newAdmin Address that admin role will be granted to.
877      */
878     function renounceAdmin(address newAdmin) external onlyAdmin {
879         grantRole(DEFAULT_ADMIN_ROLE, newAdmin);
880         renounceRole(DEFAULT_ADMIN_ROLE, msg.sender);
881     }
882 
883     /**
884         @notice Pauses deposits, proposal creation and voting, and deposit executions.
885         @notice Only callable by an address that currently has the admin role.
886      */
887     function adminPauseTransfers() external onlyAdmin {
888         _pause();
889     }
890 
891     /**
892         @notice Unpauses deposits, proposal creation and voting, and deposit executions.
893         @notice Only callable by an address that currently has the admin role.
894      */
895     function adminUnpauseTransfers() external onlyAdmin {
896         _unpause();
897     }
898 
899     /**
900         @notice Modifies the number of votes required for a proposal to be considered passed.
901         @notice Only callable by an address that currently has the admin role.
902         @param newThreshold Value {_relayerThreshold} will be changed to.
903         @notice Emits {RelayerThresholdChanged} event.
904      */
905     function adminChangeRelayerThreshold(uint newThreshold) external onlyAdmin {
906         _relayerThreshold = newThreshold;
907         emit RelayerThresholdChanged(newThreshold);
908     }
909 
910     /**
911         @notice Grants {relayerAddress} the relayer role and increases {_totalRelayer} count.
912         @notice Only callable by an address that currently has the admin role.
913         @param relayerAddress Address of relayer to be added.
914         @notice Emits {RelayerAdded} event.
915      */
916     function adminAddRelayer(address relayerAddress) external onlyAdmin {
917         require(!hasRole(RELAYER_ROLE, relayerAddress), "addr already has relayer role!");
918         grantRole(RELAYER_ROLE, relayerAddress);
919         emit RelayerAdded(relayerAddress);
920         _totalRelayers++;
921     }
922 
923     /**
924         @notice Removes relayer role for {relayerAddress} and decreases {_totalRelayer} count.
925         @notice Only callable by an address that currently has the admin role.
926         @param relayerAddress Address of relayer to be removed.
927         @notice Emits {RelayerRemoved} event.
928      */
929     function adminRemoveRelayer(address relayerAddress) external onlyAdmin {
930         require(hasRole(RELAYER_ROLE, relayerAddress), "addr doesn't have relayer role!");
931         revokeRole(RELAYER_ROLE, relayerAddress);
932         emit RelayerRemoved(relayerAddress);
933         _totalRelayers--;
934     }
935 
936     /**
937         @notice Sets a new resource for handler contracts that use the IERCHandler interface,
938         and maps the {handlerAddress} to {resourceID} in {_resourceIDToHandlerAddress}.
939         @notice Only callable by an address that currently has the admin role.
940         @param handlerAddress Address of handler resource will be set for.
941         @param resourceID ResourceID to be used when making deposits.
942         @param tokenAddress Address of contract to be called when a deposit is made and a deposited is executed.
943      */
944     function adminSetResource(address handlerAddress, bytes32 resourceID, address tokenAddress) external onlyAdmin {
945         _resourceIDToHandlerAddress[resourceID] = handlerAddress;
946         IERCHandler handler = IERCHandler(handlerAddress);
947         handler.setResource(resourceID, tokenAddress);
948     }
949 
950     /**
951         @notice Sets a new resource for handler contracts that use the IGenericHandler interface,
952         and maps the {handlerAddress} to {resourceID} in {_resourceIDToHandlerAddress}.
953         @notice Only callable by an address that currently has the admin role.
954         @param handlerAddress Address of handler resource will be set for.
955         @param resourceID ResourceID to be used when making deposits.
956         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
957      */
958     function adminSetGenericResource(
959         address handlerAddress,
960         bytes32 resourceID,
961         address contractAddress,
962         bytes4 depositFunctionSig,
963         bytes4 executeFunctionSig
964     ) external onlyAdmin {
965         _resourceIDToHandlerAddress[resourceID] = handlerAddress;
966         IGenericHandler handler = IGenericHandler(handlerAddress);
967         handler.setResource(resourceID, contractAddress, depositFunctionSig, executeFunctionSig);
968     }
969 
970     /**
971         @notice Sets a resource as burnable for handler contracts that use the IERCHandler interface.
972         @notice Only callable by an address that currently has the admin role.
973         @param handlerAddress Address of handler resource will be set for.
974         @param tokenAddress Address of contract to be called when a deposit is made and a deposited is executed.
975      */
976     function adminSetBurnable(address handlerAddress, address tokenAddress) external onlyAdmin {
977         IERCHandler handler = IERCHandler(handlerAddress);
978         handler.setBurnable(tokenAddress);
979     }
980 
981     /**
982         @notice Returns a proposal.
983         @param originChainID Chain ID deposit originated from.
984         @param depositNonce ID of proposal generated by proposal's origin Bridge contract.
985         @param dataHash Hash of data to be provided when deposit proposal is executed.
986         @return Proposal which consists of:
987         - _dataHash Hash of data to be provided when deposit proposal is executed.
988         - _yesVotes Number of votes in favor of proposal.
989         - _noVotes Number of votes against proposal.
990         - _status Current status of proposal.
991      */
992     function getProposal(uint8 originChainID, uint64 depositNonce, bytes32 dataHash) external view returns (Proposal memory) {
993         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(originChainID);
994         return _proposals[nonceAndID][dataHash];
995     }
996 
997     /**
998         @notice Changes deposit fee.
999         @notice Only callable by admin.
1000         @param newFee Value {_fee} will be updated to.
1001      */
1002     function adminChangeFee(uint newFee) external onlyAdmin {
1003         require(_fee != newFee, "Current fee is equal to new fee");
1004         _fee = newFee;
1005     }
1006 
1007     /**
1008         @notice Used to manually withdraw funds from ERC safes.
1009         @param handlerAddress Address of handler to withdraw from.
1010         @param tokenAddress Address of token to withdraw.
1011         @param recipient Address to withdraw tokens to.
1012         @param amountOrTokenID Either the amount of ERC20 tokens or the ERC721 token ID to withdraw.
1013      */
1014     function adminWithdraw(
1015         address handlerAddress,
1016         address tokenAddress,
1017         address recipient,
1018         uint256 amountOrTokenID
1019     ) external onlyAdmin {
1020         IERCHandler handler = IERCHandler(handlerAddress);
1021         handler.withdraw(tokenAddress, recipient, amountOrTokenID);
1022     }
1023 
1024     /**
1025         @notice Initiates a transfer using a specified handler contract.
1026         @notice Only callable when Bridge is not paused.
1027         @param destinationChainID ID of chain deposit will be bridged to.
1028         @param resourceID ResourceID used to find address of handler to be used for deposit.
1029         @param data Additional data to be passed to specified handler.
1030         @notice Emits {Deposit} event.
1031      */
1032     function deposit(uint8 destinationChainID, bytes32 resourceID, bytes calldata data) external payable whenNotPaused {
1033         require(msg.value == _fee, "Incorrect fee supplied");
1034 
1035         address handler = _resourceIDToHandlerAddress[resourceID];
1036         require(handler != address(0), "resourceID not mapped to handler");
1037 
1038         uint64 depositNonce = ++_depositCounts[destinationChainID];
1039         _depositRecords[depositNonce][destinationChainID] = data;
1040 
1041         IDepositExecute depositHandler = IDepositExecute(handler);
1042         depositHandler.deposit(resourceID, destinationChainID, depositNonce, msg.sender, data);
1043 
1044         emit Deposit(destinationChainID, resourceID, depositNonce);
1045     }
1046 
1047     /**
1048         @notice When called, {msg.sender} will be marked as voting in favor of proposal.
1049         @notice Only callable by relayers when Bridge is not paused.
1050         @param chainID ID of chain deposit originated from.
1051         @param depositNonce ID of deposited generated by origin Bridge contract.
1052         @param dataHash Hash of data provided when deposit was made.
1053         @notice Proposal must not have already been passed or executed.
1054         @notice {msg.sender} must not have already voted on proposal.
1055         @notice Emits {ProposalEvent} event with status indicating the proposal status.
1056         @notice Emits {ProposalVote} event.
1057      */
1058     function voteProposal(uint8 chainID, uint64 depositNonce, bytes32 resourceID, bytes32 dataHash) external onlyRelayers whenNotPaused {
1059 
1060         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1061         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1062 
1063         require(_resourceIDToHandlerAddress[resourceID] != address(0), "no handler for resourceID");
1064         require(uint(proposal._status) <= 1, "proposal already passed/executed/cancelled");
1065         require(!_hasVotedOnProposal[nonceAndID][dataHash][msg.sender], "relayer already voted");
1066 
1067         if (uint(proposal._status) == 0) {
1068             ++_totalProposals;
1069             _proposals[nonceAndID][dataHash] = Proposal({
1070                 _resourceID : resourceID,
1071                 _dataHash : dataHash,
1072                 _yesVotes : new address[](1),
1073                 _noVotes : new address[](0),
1074                 _status : ProposalStatus.Active,
1075                 _proposedBlock : block.number
1076                 });
1077 
1078             proposal._yesVotes[0] = msg.sender;
1079             emit ProposalEvent(chainID, depositNonce, ProposalStatus.Active, resourceID, dataHash);
1080         } else {
1081             if (sub(block.number, proposal._proposedBlock) > _expiry) {
1082                 // if the number of blocks that has passed since this proposal was
1083                 // submitted exceeds the expiry threshold set, cancel the proposal
1084                 proposal._status = ProposalStatus.Cancelled;
1085                 emit ProposalEvent(chainID, depositNonce, ProposalStatus.Cancelled, resourceID, dataHash);
1086             } else {
1087                 require(dataHash == proposal._dataHash, "datahash mismatch");
1088                 proposal._yesVotes.push(msg.sender);
1089 
1090 
1091             }
1092 
1093         }
1094         if (proposal._status != ProposalStatus.Cancelled) {
1095             _hasVotedOnProposal[nonceAndID][dataHash][msg.sender] = true;
1096             emit ProposalVote(chainID, depositNonce, proposal._status, resourceID);
1097 
1098             // If _depositThreshold is set to 1, then auto finalize
1099             // or if _relayerThreshold has been exceeded
1100             if (_relayerThreshold <= 1 || proposal._yesVotes.length >= _relayerThreshold) {
1101                 proposal._status = ProposalStatus.Passed;
1102 
1103                 emit ProposalEvent(chainID, depositNonce, ProposalStatus.Passed, resourceID, dataHash);
1104             }
1105         }
1106 
1107     }
1108 
1109     /**
1110         @notice Executes a deposit proposal that is considered passed using a specified handler contract.
1111         @notice Only callable by relayers when Bridge is not paused.
1112         @param chainID ID of chain deposit originated from.
1113         @param depositNonce ID of deposited generated by origin Bridge contract.
1114         @param dataHash Hash of data originally provided when deposit was made.
1115         @notice Proposal must be past expiry threshold.
1116         @notice Emits {ProposalEvent} event with status {Cancelled}.
1117      */
1118     function cancelProposal(uint8 chainID, uint64 depositNonce, bytes32 dataHash) public onlyAdminOrRelayer {
1119         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1120         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1121 
1122         require(proposal._status != ProposalStatus.Cancelled, "Proposal already cancelled");
1123         require(sub(block.number, proposal._proposedBlock) > _expiry, "Proposal not at expiry threshold");
1124 
1125         proposal._status = ProposalStatus.Cancelled;
1126         emit ProposalEvent(chainID, depositNonce, ProposalStatus.Cancelled, proposal._resourceID, proposal._dataHash);
1127 
1128     }
1129 
1130     /**
1131         @notice Executes a deposit proposal that is considered passed using a specified handler contract.
1132         @notice Only callable by relayers when Bridge is not paused.
1133         @param chainID ID of chain deposit originated from.
1134         @param resourceID ResourceID to be used when making deposits.
1135         @param depositNonce ID of deposited generated by origin Bridge contract.
1136         @param data Data originally provided when deposit was made.
1137         @notice Proposal must have Passed status.
1138         @notice Hash of {data} must equal proposal's {dataHash}.
1139         @notice Emits {ProposalEvent} event with status {Executed}.
1140      */
1141     function executeProposal(uint8 chainID, uint64 depositNonce, bytes calldata data, bytes32 resourceID) external onlyRelayers whenNotPaused {
1142         address handler = _resourceIDToHandlerAddress[resourceID];
1143         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1144         bytes32 dataHash = keccak256(abi.encodePacked(handler, data));
1145         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1146 
1147         require(proposal._status != ProposalStatus.Inactive, "proposal is not active");
1148         require(proposal._status == ProposalStatus.Passed, "proposal already transferred");
1149         require(dataHash == proposal._dataHash, "data doesn't match datahash");
1150 
1151         proposal._status = ProposalStatus.Executed;
1152 
1153         IDepositExecute depositHandler = IDepositExecute(_resourceIDToHandlerAddress[proposal._resourceID]);
1154         depositHandler.executeProposal(proposal._resourceID, data);
1155 
1156         emit ProposalEvent(chainID, depositNonce, proposal._status, proposal._resourceID, proposal._dataHash);
1157     }
1158 
1159     /**
1160         @notice Transfers eth in the contract to the specified addresses. The parameters addrs and amounts are mapped 1-1.
1161         This means that the address at index 0 for addrs will receive the amount (in WEI) from amounts at index 0.
1162         @param addrs Array of addresses to transfer {amounts} to.
1163         @param amounts Array of amonuts to transfer to {addrs}.
1164      */
1165     function transferFunds(address payable[] calldata addrs, uint[] calldata amounts) external onlyAdmin {
1166         for (uint i = 0; i < addrs.length; i++) {
1167             addrs[i].transfer(amounts[i]);
1168         }
1169     }
1170 
1171 }