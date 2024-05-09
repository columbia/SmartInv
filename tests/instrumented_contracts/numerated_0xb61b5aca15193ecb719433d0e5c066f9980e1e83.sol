1 pragma solidity 0.6.4;
2 pragma experimental ABIEncoderV2;
3 
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
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 }
301 
302 /*
303  * @dev Provides information about the current execution context, including the
304  * sender of the transaction and its data. While these are generally available
305  * via msg.sender and msg.data, they should not be accessed in such a direct
306  * manner, since when dealing with GSN meta-transactions the account sending and
307  * paying for execution may not be the actual sender (as far as an application
308  * is concerned).
309  *
310  * This contract is only required for intermediate, library-like contracts.
311  */
312 contract Context {
313     // Empty internal constructor, to prevent people from mistakenly deploying
314     // an instance of this contract, which should be used via inheritance.
315     constructor () internal { }
316 
317     function _msgSender() internal view virtual returns (address payable) {
318         return msg.sender;
319     }
320 
321     function _msgData() internal view virtual returns (bytes memory) {
322         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
323         return msg.data;
324     }
325 }
326 
327 /**
328  * @dev Contract module that allows children to implement role-based access
329  * control mechanisms.
330  *
331  * Roles are referred to by their `bytes32` identifier. These should be exposed
332  * in the external API and be unique. The best way to achieve this is by
333  * using `public constant` hash digests:
334  *
335  * ```
336  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
337  * ```
338  *
339  * Roles can be used to represent a set of permissions. To restrict access to a
340  * function call, use {hasRole}:
341  *
342  * ```
343  * function foo() public {
344  *     require(hasRole(MY_ROLE, msg.sender));
345  *     ...
346  * }
347  * ```
348  *
349  * Roles can be granted and revoked dynamically via the {grantRole} and
350  * {revokeRole} functions. Each role has an associated admin role, and only
351  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
352  *
353  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
354  * that only accounts with this role will be able to grant or revoke other
355  * roles. More complex role relationships can be created by using
356  * {_setRoleAdmin}.
357  *
358  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
359  * grant and revoke this role. Extra precautions should be taken to secure
360  * accounts that have been granted it.
361  */
362 abstract contract AccessControl is Context {
363     using EnumerableSet for EnumerableSet.AddressSet;
364     using Address for address;
365 
366     struct RoleData {
367         EnumerableSet.AddressSet members;
368         bytes32 adminRole;
369     }
370 
371     mapping (bytes32 => RoleData) private _roles;
372 
373     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
374 
375     /**
376      * @dev Emitted when `account` is granted `role`.
377      *
378      * `sender` is the account that originated the contract call, an admin role
379      * bearer except when using {_setupRole}.
380      */
381     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
382 
383     /**
384      * @dev Emitted when `account` is revoked `role`.
385      *
386      * `sender` is the account that originated the contract call:
387      *   - if using `revokeRole`, it is the admin role bearer
388      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
389      */
390     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
391 
392     /**
393      * @dev Returns `true` if `account` has been granted `role`.
394      */
395     function hasRole(bytes32 role, address account) public view returns (bool) {
396         return _roles[role].members.contains(account);
397     }
398 
399     /**
400      * @dev Returns the number of accounts that have `role`. Can be used
401      * together with {getRoleMember} to enumerate all bearers of a role.
402      */
403     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
404         return _roles[role].members.length();
405     }
406 
407     /**
408      * @dev Returns one of the accounts that have `role`. `index` must be a
409      * value between 0 and {getRoleMemberCount}, non-inclusive.
410      *
411      * Role bearers are not sorted in any particular way, and their ordering may
412      * change at any point.
413      *
414      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
415      * you perform all queries on the same block. See the following
416      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
417      * for more information.
418      */
419     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
420         return _roles[role].members.at(index);
421     }
422 
423     /**
424      * @dev Returns the admin role that controls `role`. See {grantRole} and
425      * {revokeRole}.
426      *
427      * To change a role's admin, use {_setRoleAdmin}.
428      */
429     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
430         return _roles[role].adminRole;
431     }
432 
433     /**
434      * @dev Grants `role` to `account`.
435      *
436      * If `account` had not been already granted `role`, emits a {RoleGranted}
437      * event.
438      *
439      * Requirements:
440      *
441      * - the caller must have ``role``'s admin role.
442      */
443     function grantRole(bytes32 role, address account) public virtual {
444         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
445 
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
458     function revokeRole(bytes32 role, address account) public virtual {
459         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
460 
461         _revokeRole(role, account);
462     }
463 
464     /**
465      * @dev Revokes `role` from the calling account.
466      *
467      * Roles are often managed via {grantRole} and {revokeRole}: this function's
468      * purpose is to provide a mechanism for accounts to lose their privileges
469      * if they are compromised (such as when a trusted device is misplaced).
470      *
471      * If the calling account had been granted `role`, emits a {RoleRevoked}
472      * event.
473      *
474      * Requirements:
475      *
476      * - the caller must be `account`.
477      */
478     function renounceRole(bytes32 role, address account) public virtual {
479         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
480 
481         _revokeRole(role, account);
482     }
483 
484     /**
485      * @dev Grants `role` to `account`.
486      *
487      * If `account` had not been already granted `role`, emits a {RoleGranted}
488      * event. Note that unlike {grantRole}, this function doesn't perform any
489      * checks on the calling account.
490      *
491      * [WARNING]
492      * ====
493      * This function should only be called from the constructor when setting
494      * up the initial roles for the system.
495      *
496      * Using this function in any other way is effectively circumventing the admin
497      * system imposed by {AccessControl}.
498      * ====
499      */
500     function _setupRole(bytes32 role, address account) internal virtual {
501         _grantRole(role, account);
502     }
503 
504     /**
505      * @dev Sets `adminRole` as ``role``'s admin role.
506      */
507     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
508         _roles[role].adminRole = adminRole;
509     }
510 
511     function _grantRole(bytes32 role, address account) private {
512         if (_roles[role].members.add(account)) {
513             emit RoleGranted(role, account, _msgSender());
514         }
515     }
516 
517     function _revokeRole(bytes32 role, address account) private {
518         if (_roles[role].members.remove(account)) {
519             emit RoleRevoked(role, account, _msgSender());
520         }
521     }
522 }
523 
524 // SPDX-License-Identifier: MIT
525 /**
526  * @dev Contract module which allows children to implement an emergency stop
527  * mechanism that can be triggered by an authorized account.
528  *
529  * This is a stripped down version of Open zeppelin's Pausable contract.
530  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/EnumerableSet.sol
531  *
532  */
533 contract Pausable {
534     /**
535      * @dev Emitted when the pause is triggered by `account`.
536      */
537     event Paused(address account);
538 
539     /**
540      * @dev Emitted when the pause is lifted by `account`.
541      */
542     event Unpaused(address account);
543 
544     bool private _paused;
545 
546     /**
547      * @dev Initializes the contract in unpaused state.
548      */
549     constructor () internal {
550         _paused = false;
551     }
552 
553     /**
554      * @dev Returns true if the contract is paused, and false otherwise.
555      */
556     function paused() public view returns (bool) {
557         return _paused;
558     }
559 
560     /**
561      * @dev Modifier to make a function callable only when the contract is not paused.
562      *
563      * Requirements:
564      *
565      * - The contract must not be paused.
566      */
567     modifier whenNotPaused() {
568         _whenNotPaused();
569         _;
570     }
571 
572     function _whenNotPaused() private view {
573         require(!_paused, "Pausable: paused");
574     }
575 
576     /**
577      * @dev Modifier to make a function callable only when the contract is not paused.
578      *
579      * Requirements:
580      *
581      * - The contract must not be paused.
582      */
583     modifier whenPaused() {
584         _whenPaused();
585         _;
586     }
587 
588     function _whenPaused() private view {
589         require(_paused, "Pausable: not paused");
590     }
591 
592     /**
593      * @dev Triggers stopped state.
594      *
595      * Requirements:
596      *
597      * - The contract must not be paused.
598      */
599     function _pause() internal virtual whenNotPaused {
600         _paused = true;
601         emit Paused(msg.sender);
602     }
603 
604     /**
605      * @dev Returns to normal state.
606      *
607      * Requirements:
608      *
609      * - The contract must be paused.
610      */
611     function _unpause() internal virtual whenPaused {
612         _paused = false;
613         emit Unpaused(msg.sender);
614     }
615 }
616 
617 // SPDX-License-Identifier: MIT
618 /**
619  * @dev Wrappers over Solidity's arithmetic operations with added overflow
620  * checks.
621  *
622  * note that this is a stripped down version of open zeppelin's safemath
623  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
624  */
625 contract SafeMath {
626 
627     /**
628      * @dev Returns the subtraction of two unsigned integers, reverting on
629      * overflow (when the result is negative).
630      *
631      * Counterpart to Solidity's `-` operator.
632      *
633      * Requirements:
634      * - Subtraction cannot overflow.
635      */
636     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
637         return _sub(a, b, "SafeMath: subtraction overflow");
638     }
639 
640     /**
641      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
642      * overflow (when the result is negative).
643      *
644      * Counterpart to Solidity's `-` operator.
645      *
646      * Requirements:
647      * - Subtraction cannot overflow.
648      */
649     function _sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
650         require(b <= a, errorMessage);
651         uint256 c = a - b;
652 
653         return c;
654     }
655 
656 }
657 
658 /**
659     @title Interface for handler contracts that support deposits and deposit executions.
660     @author ChainSafe Systems.
661  */
662 interface IDepositExecute {
663     /**
664         @notice It is intended that deposit are made using the Bridge contract.
665         @param destinationChainID Chain ID deposit is expected to be bridged to.
666         @param depositNonce This value is generated as an ID by the Bridge contract.
667         @param depositer Address of account making the deposit in the Bridge contract.
668         @param data Consists of additional data needed for a specific deposit.
669      */
670     function deposit(bytes32 resourceID, uint8 destinationChainID, uint64 depositNonce, address depositer, bytes calldata data) external;
671 
672     /**
673         @notice It is intended that proposals are executed by the Bridge contract.
674         @param data Consists of additional data needed for a specific deposit execution.
675      */
676     function executeProposal(bytes32 resourceID, bytes calldata data) external;
677 }
678 
679 /**
680     @title Interface for Bridge contract.
681     @author ChainSafe Systems.
682  */
683 interface IBridge {
684     /**
685         @notice Exposing getter for {_chainID} instead of forcing the use of call.
686         @return uint8 The {_chainID} that is currently set for the Bridge contract.
687      */
688     function _chainID() external returns (uint8);
689 }
690 
691 /**
692     @title Interface to be used with handlers that support ERC20s and ERC721s.
693     @author ChainSafe Systems.
694  */
695 interface IERCHandler {
696     /**
697         @notice Correlates {resourceID} with {contractAddress}.
698         @param resourceID ResourceID to be used when making deposits.
699         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
700      */
701     function setResource(bytes32 resourceID, address contractAddress) external;
702     /**
703         @notice Marks {contractAddress} as mintable/burnable.
704         @param contractAddress Address of contract to be used when making or executing deposits.
705      */
706     function setBurnable(address contractAddress) external;
707     /**
708         @notice Used to manually release funds from ERC safes.
709         @param tokenAddress Address of token contract to release.
710         @param recipient Address to release tokens to.
711         @param amountOrTokenID Either the amount of ERC20 tokens or the ERC721 token ID to release.
712      */
713     function withdraw(address tokenAddress, address recipient, uint256 amountOrTokenID) external;
714 
715     function _wtokenAddress() external returns (address);
716 
717     /**
718         @notice Used to update the _bridgeAddress
719         @param newBridgeAddress Address of the updated bridge address.
720     */
721     function updateBridgeAddress(address newBridgeAddress) external;
722 }
723 
724 interface IERC20HandlerExt {
725     function _resourceIDToTokenContractAddress(bytes32 resourceID) external returns (address);
726 }
727 
728 /**
729     @title Interface for handler that handles generic deposits and deposit executions.
730     @author ChainSafe Systems.
731  */
732 interface IGenericHandler {
733     /**
734         @notice Correlates {resourceID} with {contractAddress}, {depositFunctionSig}, and {executeFunctionSig}.
735         @param resourceID ResourceID to be used when making deposits.
736         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
737         @param depositFunctionSig Function signature of method to be called in {contractAddress} when a deposit is made.
738         @param depositFunctionDepositerOffset Depositer address position offset in the metadata, in bytes.
739         @param executeFunctionSig Function signature of method to be called in {contractAddress} when a deposit is executed.
740      */
741     function setResource(
742         bytes32 resourceID,
743         address contractAddress,
744         bytes4 depositFunctionSig,
745         uint depositFunctionDepositerOffset,
746         bytes4 executeFunctionSig) external;
747 }
748 
749 interface IWETH {
750     function deposit() external payable;
751     function transfer(address to, uint value) external returns (bool);
752     function withdraw(uint) external;
753 }
754 
755 /**
756     @title Facilitates deposits, creation and votiing of deposit proposals, and deposit executions.
757     @author ChainSafe Systems.
758  */
759 contract Bridge is Pausable, AccessControl, SafeMath {
760 
761     uint8   public _chainID;
762     uint256 public _relayerThreshold;
763     uint256 public _totalRelayers;
764     uint256 public _totalOperators;
765     uint256 public _totalProposals;
766     uint256 public _fee;
767     uint256 public _expiry;
768     address public _wtokenAddress;
769 
770     enum Vote {No, Yes}
771 
772     enum ProposalStatus {Inactive, Active, Passed, Executed, Cancelled}
773 
774     struct Proposal {
775         bytes32 _resourceID;
776         bytes32 _dataHash;
777         address[] _yesVotes;
778         address[] _noVotes;
779         ProposalStatus _status;
780         uint256 _proposedBlock;
781     }
782 
783     // destinationChainID => number of deposits
784     mapping(uint8 => uint64) public _depositCounts;
785     // destinationID ==> specailFee other than _fee
786     mapping(uint8 => uint256) public _specialFee;
787     // resourceID => handler address
788     mapping(bytes32 => address) public _resourceIDToHandlerAddress;
789     // depositNonce => destinationChainID => bytes
790     mapping(uint64 => mapping(uint8 => bytes)) public _depositRecords;
791     // destinationChainID + depositNonce => dataHash => Proposal
792     mapping(uint72 => mapping(bytes32 => Proposal)) public _proposals;
793     // destinationChainID + depositNonce => dataHash => relayerAddress => bool
794     mapping(uint72 => mapping(bytes32 => mapping(address => bool))) public _hasVotedOnProposal;
795  
796 
797     event RelayerThresholdChanged(uint256 indexed newThreshold);
798     event RelayerAdded(address indexed relayer);
799     event RelayerRemoved(address indexed relayer);
800     event OperatorAdded(address indexed operator);
801     event OperatorRemoved(address indexed operator);    
802     event Deposit(
803         uint8   indexed destinationChainID,
804         bytes32 indexed resourceID,
805         uint64  indexed depositNonce
806     );
807     event ProposalEvent(
808         uint8           indexed originChainID,
809         uint64          indexed depositNonce,
810         ProposalStatus  indexed status,
811         bytes32 resourceID,
812         bytes32 dataHash
813     );
814 
815     event ProposalVote(
816         uint8   indexed originChainID,
817         uint64  indexed depositNonce,
818         ProposalStatus indexed status,
819         bytes32 resourceID
820     );
821 
822     bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");
823     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
824 
825     modifier onlyAdmin() {
826         _onlyAdmin();
827         _;
828     }
829 
830     modifier onlyAdminOrRelayer() {
831         _onlyAdminOrRelayer();
832         _;
833     }
834 
835     modifier onlyRelayers() {
836         _onlyRelayers();
837         _;
838     }
839 
840     modifier onlyOperators() {
841         _onlyOperators();
842         _;
843     }
844 
845     modifier onlyAdminOrOperator() {
846         _onlyAdminOrOperator();
847         _;
848     }
849        
850     function _onlyAdminOrRelayer() private {
851         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(RELAYER_ROLE, msg.sender),
852             "sender is not relayer or admin");
853     }
854 
855     function _onlyAdminOrOperator() private {
856         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(OPERATOR_ROLE, msg.sender),
857             "sender is not operator or admin");
858     }
859 
860     function _onlyAdmin() private {
861         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "sender doesn't have admin role");
862     }
863 
864     function _onlyRelayers() private {
865         require(hasRole(RELAYER_ROLE, msg.sender), "sender doesn't have relayer role");
866     }
867 
868     function _onlyOperators() private {
869         require(hasRole(OPERATOR_ROLE, msg.sender), "sender doesn't have relayer role");
870     }
871 
872     /**
873         @notice Initializes Bridge, creates and grants {msg.sender} the admin role,
874         creates and grants {initialRelayers} the relayer role.
875         @param chainID ID of chain the Bridge contract exists on.
876         @param initialRelayers Addresses that should be initially granted the relayer role.
877         @param initialRelayerThreshold Number of votes needed for a deposit proposal to be considered passed.
878      */
879     constructor (uint8 chainID, address[] memory initialRelayers, uint256 initialRelayerThreshold, uint256 fee, uint256 expiry, address wtoken) public {
880         _chainID = chainID;
881         _relayerThreshold = initialRelayerThreshold;
882         _fee = fee;
883         _expiry = expiry;
884         _wtokenAddress = wtoken;
885 
886         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
887         _setRoleAdmin(RELAYER_ROLE, DEFAULT_ADMIN_ROLE);
888         _setRoleAdmin(OPERATOR_ROLE, DEFAULT_ADMIN_ROLE);
889 
890         for (uint256 i; i < initialRelayers.length; i++) {
891             grantRole(RELAYER_ROLE, initialRelayers[i]);
892             _totalRelayers++;
893         }
894 
895     }
896 
897     /**
898         @notice Returns true if {relayer} has the relayer role.
899         @param relayer Address to check.
900      */
901     function isRelayer(address relayer) external view returns (bool) {
902         return hasRole(RELAYER_ROLE, relayer);
903     }
904 
905     /**
906         @notice Returns true if {operator} has the operator role.
907         @param operator Address to check.
908      */
909     function isOperator(address operator) external view returns (bool) {
910         return hasRole(OPERATOR_ROLE, operator);
911     }
912 
913     /**
914         @notice Removes admin role from {msg.sender} and grants it to {newAdmin}.
915         @notice Only callable by an address that currently has the admin role.
916         @param newAdmin Address that admin role will be granted to.
917      */
918     function renounceAdmin(address newAdmin) external onlyAdmin {
919         grantRole(DEFAULT_ADMIN_ROLE, newAdmin);
920         renounceRole(DEFAULT_ADMIN_ROLE, msg.sender);
921     }
922 
923     /**
924         @notice Pauses deposits, proposal creation and voting, and deposit executions.
925         @notice Only callable by an address that currently has the admin role.
926      */
927     function adminPauseTransfers() external onlyAdminOrOperator {
928         _pause();
929     }
930 
931     /**
932         @notice Unpauses deposits, proposal creation and voting, and deposit executions.
933         @notice Only callable by an address that currently has the admin role.
934      */
935     function adminUnpauseTransfers() external onlyAdminOrOperator {
936         _unpause();
937     }
938 
939     /**
940         @notice Modifies the number of votes required for a proposal to be considered passed.
941         @notice Only callable by an address that currently has the admin role.
942         @param newThreshold Value {_relayerThreshold} will be changed to.
943         @notice Emits {RelayerThresholdChanged} event.
944      */
945     function adminChangeRelayerThreshold(uint256 newThreshold) external onlyAdmin {
946         _relayerThreshold = newThreshold;
947         emit RelayerThresholdChanged(newThreshold);
948     }
949 
950     /**
951         @notice Grants {relayerAddress} the relayer role and increases {_totalRelayer} count.
952         @notice Only callable by an address that currently has the admin role.
953         @param relayerAddress Address of relayer to be added.
954         @notice Emits {RelayerAdded} event.
955      */
956     function adminAddRelayer(address relayerAddress) external onlyAdmin {
957         require(!hasRole(RELAYER_ROLE, relayerAddress), "addr already has relayer role!");
958         grantRole(RELAYER_ROLE, relayerAddress);
959         emit RelayerAdded(relayerAddress);
960         _totalRelayers++;
961     }
962 
963     /**
964         @notice Removes relayer role for {relayerAddress} and decreases {_totalRelayer} count.
965         @notice Only callable by an address that currently has the admin role.
966         @param relayerAddress Address of relayer to be removed.
967         @notice Emits {RelayerRemoved} event.
968      */
969     function adminRemoveRelayer(address relayerAddress) external onlyAdmin {
970         require(hasRole(RELAYER_ROLE, relayerAddress), "addr doesn't have relayer role!");
971         revokeRole(RELAYER_ROLE, relayerAddress);
972         emit RelayerRemoved(relayerAddress);
973         _totalRelayers--;
974     }
975 
976     /**
977         @notice Grants {operatorAddress} the relayer role and increases {_totalOperator} count.
978         @notice Only callable by an address that currently has the admin role.
979         @param operatorAddress Address of operator to be added.
980         @notice Emits {OperatorAdded} event.
981      */
982     function adminAddOperator(address operatorAddress) external onlyAdmin {
983         require(!hasRole(OPERATOR_ROLE, operatorAddress), "addr already has operator role!");
984         grantRole(OPERATOR_ROLE, operatorAddress);
985         emit OperatorAdded(operatorAddress);
986         _totalOperators++;
987     }
988 
989     /**
990         @notice Removes operator role for {operatorAddress} and decreases {_totalOperator} count.
991         @notice Only callable by an address that currently has the admin role.
992         @param operatorAddress Address of relayer to be removed.
993         @notice Emits {OperatorRemoved} event.
994      */
995     function adminRemoveOperator(address operatorAddress) external onlyAdmin {
996         require(hasRole(OPERATOR_ROLE, operatorAddress), "addr doesn't have operator role!");
997         revokeRole(OPERATOR_ROLE, operatorAddress);
998         emit OperatorRemoved(operatorAddress);
999         _totalOperators--;
1000     }
1001 
1002     /**
1003         @notice Sets a new resource for handler contracts that use the IERCHandler interface,
1004         and maps the {handlerAddress} to {resourceID} in {_resourceIDToHandlerAddress}.
1005         @notice Only callable by an address that currently has the admin role.
1006         @param handlerAddress Address of handler resource will be set for.
1007         @param resourceID ResourceID to be used when making deposits.
1008         @param tokenAddress Address of contract to be called when a deposit is made and a deposited is executed.
1009      */
1010     function adminSetResource(address handlerAddress, bytes32 resourceID, address tokenAddress) external onlyAdmin {
1011         _resourceIDToHandlerAddress[resourceID] = handlerAddress;
1012         IERCHandler handler = IERCHandler(handlerAddress);
1013         handler.setResource(resourceID, tokenAddress);
1014     }
1015 
1016     /**
1017         @notice Sets a new resource for handler contracts that use the IGenericHandler interface,
1018         and maps the {handlerAddress} to {resourceID} in {_resourceIDToHandlerAddress}.
1019         @notice Only callable by an address that currently has the admin role.
1020         @param handlerAddress Address of handler resource will be set for.
1021         @param resourceID ResourceID to be used when making deposits.
1022         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
1023      */
1024     function adminSetGenericResource(
1025         address handlerAddress,
1026         bytes32 resourceID,
1027         address contractAddress,
1028         bytes4 depositFunctionSig,
1029         uint256 depositFunctionDepositerOffset,
1030         bytes4 executeFunctionSig
1031     ) external onlyAdmin {
1032         _resourceIDToHandlerAddress[resourceID] = handlerAddress;
1033         IGenericHandler handler = IGenericHandler(handlerAddress);
1034         handler.setResource(resourceID, contractAddress, depositFunctionSig, depositFunctionDepositerOffset, executeFunctionSig);
1035     }
1036 
1037     /**
1038         @notice Sets a resource as burnable for handler contracts that use the IERCHandler interface.
1039         @notice Only callable by an address that currently has the admin role.
1040         @param handlerAddress Address of handler resource will be set for.
1041         @param tokenAddress Address of contract to be called when a deposit is made and a deposited is executed.
1042      */
1043     function adminSetBurnable(address handlerAddress, address tokenAddress) external onlyAdmin {
1044         IERCHandler handler = IERCHandler(handlerAddress);
1045         handler.setBurnable(tokenAddress);
1046     }
1047 
1048     /**
1049         @notice Returns a proposal.
1050         @param originChainID Chain ID deposit originated from.
1051         @param depositNonce ID of proposal generated by proposal's origin Bridge contract.
1052         @param dataHash Hash of data to be provided when deposit proposal is executed.
1053         @return Proposal which consists of:
1054         - _dataHash Hash of data to be provided when deposit proposal is executed.
1055         - _yesVotes Number of votes in favor of proposal.
1056         - _noVotes Number of votes against proposal.
1057         - _status Current status of proposal.
1058      */
1059     function getProposal(uint8 originChainID, uint64 depositNonce, bytes32 dataHash) external view returns (Proposal memory) {
1060         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(originChainID);
1061         return _proposals[nonceAndID][dataHash];
1062     }
1063 
1064     /**
1065         @notice Changes deposit fee.
1066         @notice Only callable by admin.
1067         @param newFee Value {_fee} will be updated to.
1068      */
1069     function adminChangeFee(uint256 newFee) external onlyAdmin {
1070         require(_fee != newFee, "Current fee is equal to new fee");
1071         _fee = newFee;
1072     }
1073 
1074     /**
1075         @notice Changes deposit fee.
1076         @notice Only callable by admin.
1077         @param newFee Value {_specialFee} will be updated to.
1078         @param chainID Value {_specialFeeChainID} will be updated to
1079      */
1080     function adminChangeSpecialFee(uint256 newFee, uint8 chainID) external onlyAdminOrOperator {
1081         uint256 current = _specialFee[chainID];
1082         require((current != newFee), "Current special fee equals to the new fee");
1083         _specialFee[chainID] = newFee;
1084     }
1085 
1086     /**
1087         @notice Get bridge fee, Returns fee of destionation chainID.
1088         @param destinationChainID Value destination chainID
1089         @return _fee
1090      */
1091     function _getFee(uint8 destinationChainID) internal view returns (uint256) {
1092         uint256 special = _specialFee[destinationChainID];
1093         if (special != 0) {
1094             return special;
1095         } else {
1096             return _fee;
1097         }
1098     }
1099 
1100     function getFee(uint8 destinationChainID) external view returns (uint256) {
1101         return _getFee(destinationChainID);
1102     }
1103     /**
1104         @notice Used to manually withdraw funds from ERC safes.
1105         @param handlerAddress Address of handler to withdraw from.
1106         @param newBridgeAddress Address of the updated _bridgeAddress.
1107      */
1108     function adminUpdateBridgeAddress(
1109         address handlerAddress,
1110         address newBridgeAddress
1111     ) external onlyAdmin {
1112         IERCHandler handler = IERCHandler(handlerAddress);
1113         handler.updateBridgeAddress(newBridgeAddress);
1114     }
1115 
1116     /**
1117         @notice Used to manually withdraw funds from ERC safes.
1118         @param handlerAddress Address of handler to withdraw from.
1119         @param tokenAddress Address of token to withdraw.
1120         @param recipient Address to withdraw tokens to.
1121         @param amountOrTokenID Either the amount of ERC20 tokens or the ERC721 token ID to withdraw.
1122      */
1123     function adminWithdraw(
1124         address handlerAddress,
1125         address tokenAddress,
1126         address recipient,
1127         uint256 amountOrTokenID
1128     ) external onlyAdmin {
1129         IERCHandler handler = IERCHandler(handlerAddress);
1130         handler.withdraw(tokenAddress, recipient, amountOrTokenID);
1131     }
1132 
1133     /**
1134         @notice Initiates a transfer using a specified handler contract.
1135         @notice Only callable when Bridge is not paused.
1136         @param destinationChainID ID of chain deposit will be bridged to.
1137         @param resourceID ResourceID used to find address of handler to be used for deposit.
1138         @param data Additional data to be passed to specified handler.
1139         @notice Emits {Deposit} event.
1140      */
1141     function deposit(uint8 destinationChainID, bytes32 resourceID, bytes calldata data) external payable whenNotPaused {
1142         uint256 fee = _getFee(destinationChainID);
1143 
1144         require(msg.value == fee, "Incorrect fee supplied");
1145 
1146         address handler = _resourceIDToHandlerAddress[resourceID];
1147         require(handler != address(0), "resourceID not mapped to handler");
1148 
1149         // resourceId can not be wtoken
1150         bytes32 wTokenResourceID = bytes32((uint256(uint160(_wtokenAddress)) << 8) +1);
1151         require (wTokenResourceID != resourceID, "wToken is not allowed in ERC20 method"); 
1152 
1153         uint64 depositNonce = ++_depositCounts[destinationChainID];
1154         _depositRecords[depositNonce][destinationChainID] = data;
1155 
1156         IDepositExecute depositHandler = IDepositExecute(handler);
1157         depositHandler.deposit(resourceID, destinationChainID, depositNonce, msg.sender, data);
1158 
1159         emit Deposit(destinationChainID, resourceID, depositNonce);
1160     }
1161 
1162     /**
1163         @notice Initiates a transfer using a specified handler contract.
1164         @notice Only callable when Bridge is not paused.
1165         @param destinationChainID ID of chain deposit will be bridged to.
1166         @param resourceID ResourceID used to find address of handler to be used for deposit.
1167         @param data Additional data to be passed to specified handler.
1168         @notice Emits {Deposit} event.
1169      */
1170     function depositETH(uint8 destinationChainID, bytes32 resourceID, bytes calldata data) external payable whenNotPaused {
1171         uint256 fee = _getFee(destinationChainID);
1172 
1173         require(msg.value >= fee, "Insufficient fee supplied");
1174 
1175         address handler = _resourceIDToHandlerAddress[resourceID];
1176         require(handler != address(0), "resourceID not mapped to handler");
1177 
1178         uint256 value = msg.value - fee;
1179         uint256 amount;
1180         assembly {
1181             amount := calldataload(0x84)
1182         }
1183         require (amount == value, "msg.value and data mismatched");
1184 
1185         address wtokenAddress = IERCHandler(handler)._wtokenAddress();
1186         require(wtokenAddress != address(0), "_wtokenAddress is 0x");
1187         IWETH(wtokenAddress).deposit{value: value}();
1188         IWETH(wtokenAddress).transfer(address(handler), value);
1189 
1190         uint64 depositNonce = ++_depositCounts[destinationChainID];
1191         _depositRecords[depositNonce][destinationChainID] = data;
1192 
1193         IDepositExecute depositHandler = IDepositExecute(handler);
1194         depositHandler.deposit(resourceID, destinationChainID, depositNonce, msg.sender, data);
1195 
1196         emit Deposit(destinationChainID, resourceID, depositNonce);
1197     }
1198 
1199     /**
1200         @notice When called, {msg.sender} will be marked as voting in favor of proposal.
1201         @notice Only callable by relayers when Bridge is not paused.
1202         @param chainID ID of chain deposit originated from.
1203         @param depositNonce ID of deposited generated by origin Bridge contract.
1204         @param dataHash Hash of data provided when deposit was made.
1205         @notice Proposal must not have already been passed or executed.
1206         @notice {msg.sender} must not have already voted on proposal.
1207         @notice Emits {ProposalEvent} event with status indicating the proposal status.
1208         @notice Emits {ProposalVote} event.
1209      */
1210     function voteProposal(uint8 chainID, uint64 depositNonce, bytes32 resourceID, bytes32 dataHash) external onlyRelayers whenNotPaused {
1211 
1212         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1213         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1214 
1215         require(_resourceIDToHandlerAddress[resourceID] != address(0), "no handler for resourceID");
1216         require(uint(proposal._status) <= 1, "proposal already passed/executed/cancelled");
1217         require(!_hasVotedOnProposal[nonceAndID][dataHash][msg.sender], "relayer already voted");
1218 
1219         if (uint(proposal._status) == 0) {
1220             ++_totalProposals;
1221             _proposals[nonceAndID][dataHash] = Proposal({
1222                 _resourceID : resourceID,
1223                 _dataHash : dataHash,
1224                 _yesVotes : new address[](1),
1225                 _noVotes : new address[](0),
1226                 _status : ProposalStatus.Active,
1227                 _proposedBlock : block.number
1228                 });
1229 
1230             proposal._yesVotes[0] = msg.sender;
1231             emit ProposalEvent(chainID, depositNonce, ProposalStatus.Active, resourceID, dataHash);
1232         } else {
1233             if (sub(block.number, proposal._proposedBlock) > _expiry) {
1234                 // if the number of blocks that has passed since this proposal was
1235                 // submitted exceeds the expiry threshold set, cancel the proposal
1236                 proposal._status = ProposalStatus.Cancelled;
1237                 emit ProposalEvent(chainID, depositNonce, ProposalStatus.Cancelled, resourceID, dataHash);
1238             } else {
1239                 require(dataHash == proposal._dataHash, "datahash mismatch");
1240                 proposal._yesVotes.push(msg.sender);
1241 
1242 
1243             }
1244 
1245         }
1246         if (proposal._status != ProposalStatus.Cancelled) {
1247             _hasVotedOnProposal[nonceAndID][dataHash][msg.sender] = true;
1248             emit ProposalVote(chainID, depositNonce, proposal._status, resourceID);
1249 
1250             // If _depositThreshold is set to 1, then auto finalize
1251             // or if _relayerThreshold has been exceeded
1252             if (_relayerThreshold <= 1 || proposal._yesVotes.length >= _relayerThreshold) {
1253                 proposal._status = ProposalStatus.Passed;
1254 
1255                 emit ProposalEvent(chainID, depositNonce, ProposalStatus.Passed, resourceID, dataHash);
1256             }
1257         }
1258 
1259     }
1260 
1261     /**
1262         @notice Executes a deposit proposal that is considered passed using a specified handler contract.
1263         @notice Only callable by relayers when Bridge is not paused.
1264         @param chainID ID of chain deposit originated from.
1265         @param depositNonce ID of deposited generated by origin Bridge contract.
1266         @param dataHash Hash of data originally provided when deposit was made.
1267         @notice Proposal must be past expiry threshold.
1268         @notice Emits {ProposalEvent} event with status {Cancelled}.
1269      */
1270     function cancelProposal(uint8 chainID, uint64 depositNonce, bytes32 dataHash) public onlyAdminOrRelayer {
1271         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1272         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1273 
1274         require(proposal._status != ProposalStatus.Cancelled, "Proposal already cancelled");
1275         require(sub(block.number, proposal._proposedBlock) > _expiry, "Proposal not at expiry threshold");
1276 
1277         proposal._status = ProposalStatus.Cancelled;
1278         emit ProposalEvent(chainID, depositNonce, ProposalStatus.Cancelled, proposal._resourceID, proposal._dataHash);
1279 
1280     }
1281 
1282     /**
1283         @notice Executes a deposit proposal that is considered passed using a specified handler contract.
1284         @notice Only callable by relayers when Bridge is not paused.
1285         @param chainID ID of chain deposit originated from.
1286         @param resourceID ResourceID to be used when making deposits.
1287         @param depositNonce ID of deposited generated by origin Bridge contract.
1288         @param data Data originally provided when deposit was made.
1289         @notice Proposal must have Passed status.
1290         @notice Hash of {data} must equal proposal's {dataHash}.
1291         @notice Emits {ProposalEvent} event with status {Executed}.
1292      */
1293     function executeProposal(uint8 chainID, uint64 depositNonce, bytes calldata data, bytes32 resourceID) external onlyRelayers whenNotPaused {
1294         address handler = _resourceIDToHandlerAddress[resourceID];
1295         uint72 nonceAndID = (uint72(depositNonce) << 8) | uint72(chainID);
1296         bytes32 dataHash = keccak256(abi.encodePacked(handler, data));
1297         Proposal storage proposal = _proposals[nonceAndID][dataHash];
1298 
1299         require(proposal._status != ProposalStatus.Inactive, "proposal is not active");
1300         require(proposal._status == ProposalStatus.Passed, "proposal already transferred");
1301         require(dataHash == proposal._dataHash, "data doesn't match datahash");
1302 
1303         proposal._status = ProposalStatus.Executed;
1304 
1305         IDepositExecute depositHandler = IDepositExecute(_resourceIDToHandlerAddress[proposal._resourceID]);
1306         depositHandler.executeProposal(proposal._resourceID, data);
1307 
1308         emit ProposalEvent(chainID, depositNonce, proposal._status, proposal._resourceID, proposal._dataHash);
1309     }
1310 
1311     /**
1312         @notice Transfers eth in the contract to the specified addresses. The parameters addrs and amounts are mapped 1-1.
1313         This means that the address at index 0 for addrs will receive the amount (in WEI) from amounts at index 0.
1314         @param addrs Array of addresses to transfer {amounts} to.
1315         @param amounts Array of amonuts to transfer to {addrs}.
1316      */
1317     function transferFunds(address payable[] calldata addrs, uint[] calldata amounts) external onlyAdmin {
1318         for (uint256 i = 0; i < addrs.length; i++) {
1319             addrs[i].transfer(amounts[i]);
1320         }
1321     }
1322 
1323 }