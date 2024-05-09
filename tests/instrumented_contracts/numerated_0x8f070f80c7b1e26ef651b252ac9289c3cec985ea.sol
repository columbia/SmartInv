1 pragma solidity ^0.6.2;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17 
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 /**
30  * @dev Collection of functions related to the address type
31  */
32 library Address {
33     /**
34      * @dev Returns true if `account` is a contract.
35      *
36      * [IMPORTANT]
37      * ====
38      * It is unsafe to assume that an address for which this function returns
39      * false is an externally-owned account (EOA) and not a contract.
40      *
41      * Among others, `isContract` will return false for the following
42      * types of addresses:
43      *
44      *  - an externally-owned account
45      *  - a contract in construction
46      *  - an address where a contract will be created
47      *  - an address where a contract lived, but was destroyed
48      * ====
49      */
50     function isContract(address account) internal view returns (bool) {
51         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
52         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
53         // for accounts without code, i.e. `keccak256('')`
54         bytes32 codehash;
55         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
56         // solhint-disable-next-line no-inline-assembly
57         assembly { codehash := extcodehash(account) }
58         return (codehash != accountHash && codehash != 0x0);
59     }
60 
61     /**
62      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
63      * `recipient`, forwarding all available gas and reverting on errors.
64      *
65      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
66      * of certain opcodes, possibly making contracts go over the 2300 gas limit
67      * imposed by `transfer`, making them unable to receive funds via
68      * `transfer`. {sendValue} removes this limitation.
69      *
70      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
71      *
72      * IMPORTANT: because control is transferred to `recipient`, care must be
73      * taken to not create reentrancy vulnerabilities. Consider using
74      * {ReentrancyGuard} or the
75      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
76      */
77     function sendValue(address payable recipient, uint256 amount) internal {
78         require(address(this).balance >= amount, "Address: insufficient balance");
79 
80         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
81         (bool success, ) = recipient.call{ value: amount }("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84 }
85 
86 
87 /**
88  * @dev Library for managing
89  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
90  * types.
91  *
92  * Sets have the following properties:
93  *
94  * - Elements are added, removed, and checked for existence in constant time
95  * (O(1)).
96  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
97  *
98  * ```
99  * contract Example {
100  *     // Add the library methods
101  *     using EnumerableSet for EnumerableSet.AddressSet;
102  *
103  *     // Declare a set state variable
104  *     EnumerableSet.AddressSet private mySet;
105  * }
106  * ```
107  *
108  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
109  * (`UintSet`) are supported.
110  */
111 library EnumerableSet {
112     // To implement this library for multiple types with as little code
113     // repetition as possible, we write it in terms of a generic Set type with
114     // bytes32 values.
115     // The Set implementation uses private functions, and user-facing
116     // implementations (such as AddressSet) are just wrappers around the
117     // underlying Set.
118     // This means that we can only create new EnumerableSets for types that fit
119     // in bytes32.
120 
121     struct Set {
122         // Storage of set values
123         bytes32[] _values;
124 
125         // Position of the value in the `values` array, plus 1 because index 0
126         // means a value is not in the set.
127         mapping (bytes32 => uint256) _indexes;
128     }
129 
130     /**
131      * @dev Add a value to a set. O(1).
132      *
133      * Returns true if the value was added to the set, that is if it was not
134      * already present.
135      */
136     function _add(Set storage set, bytes32 value) private returns (bool) {
137         if (!_contains(set, value)) {
138             set._values.push(value);
139             // The value is stored at length-1, but we add 1 to all indexes
140             // and use 0 as a sentinel value
141             set._indexes[value] = set._values.length;
142             return true;
143         } else {
144             return false;
145         }
146     }
147 
148     /**
149      * @dev Removes a value from a set. O(1).
150      *
151      * Returns true if the value was removed from the set, that is if it was
152      * present.
153      */
154     function _remove(Set storage set, bytes32 value) private returns (bool) {
155         // We read and store the value's index to prevent multiple reads from the same storage slot
156         uint256 valueIndex = set._indexes[value];
157 
158         if (valueIndex != 0) { // Equivalent to contains(set, value)
159             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
160             // the array, and then remove the last element (sometimes called as 'swap and pop').
161             // This modifies the order of the array, as noted in {at}.
162 
163             uint256 toDeleteIndex = valueIndex - 1;
164             uint256 lastIndex = set._values.length - 1;
165 
166             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
167             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
168 
169             bytes32 lastvalue = set._values[lastIndex];
170 
171             // Move the last value to the index where the value to delete is
172             set._values[toDeleteIndex] = lastvalue;
173             // Update the index for the moved value
174             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
175 
176             // Delete the slot where the moved value was stored
177             set._values.pop();
178 
179             // Delete the index for the deleted slot
180             delete set._indexes[value];
181 
182             return true;
183         } else {
184             return false;
185         }
186     }
187 
188     /**
189      * @dev Returns true if the value is in the set. O(1).
190      */
191     function _contains(Set storage set, bytes32 value) private view returns (bool) {
192         return set._indexes[value] != 0;
193     }
194 
195     /**
196      * @dev Returns the number of values on the set. O(1).
197      */
198     function _length(Set storage set) private view returns (uint256) {
199         return set._values.length;
200     }
201 
202    /**
203     * @dev Returns the value stored at position `index` in the set. O(1).
204     *
205     * Note that there are no guarantees on the ordering of values inside the
206     * array, and it may change when more values are added or removed.
207     *
208     * Requirements:
209     *
210     * - `index` must be strictly less than {length}.
211     */
212     function _at(Set storage set, uint256 index) private view returns (bytes32) {
213         require(set._values.length > index, "EnumerableSet: index out of bounds");
214         return set._values[index];
215     }
216 
217     // AddressSet
218 
219     struct AddressSet {
220         Set _inner;
221     }
222 
223     /**
224      * @dev Add a value to a set. O(1).
225      *
226      * Returns true if the value was added to the set, that is if it was not
227      * already present.
228      */
229     function add(AddressSet storage set, address value) internal returns (bool) {
230         return _add(set._inner, bytes32(uint256(value)));
231     }
232 
233     /**
234      * @dev Removes a value from a set. O(1).
235      *
236      * Returns true if the value was removed from the set, that is if it was
237      * present.
238      */
239     function remove(AddressSet storage set, address value) internal returns (bool) {
240         return _remove(set._inner, bytes32(uint256(value)));
241     }
242 
243     /**
244      * @dev Returns true if the value is in the set. O(1).
245      */
246     function contains(AddressSet storage set, address value) internal view returns (bool) {
247         return _contains(set._inner, bytes32(uint256(value)));
248     }
249 
250     /**
251      * @dev Returns the number of values in the set. O(1).
252      */
253     function length(AddressSet storage set) internal view returns (uint256) {
254         return _length(set._inner);
255     }
256 
257    /**
258     * @dev Returns the value stored at position `index` in the set. O(1).
259     *
260     * Note that there are no guarantees on the ordering of values inside the
261     * array, and it may change when more values are added or removed.
262     *
263     * Requirements:
264     *
265     * - `index` must be strictly less than {length}.
266     */
267     function at(AddressSet storage set, uint256 index) internal view returns (address) {
268         return address(uint256(_at(set._inner, index)));
269     }
270 
271 
272     // UintSet
273 
274     struct UintSet {
275         Set _inner;
276     }
277 
278     /**
279      * @dev Add a value to a set. O(1).
280      *
281      * Returns true if the value was added to the set, that is if it was not
282      * already present.
283      */
284     function add(UintSet storage set, uint256 value) internal returns (bool) {
285         return _add(set._inner, bytes32(value));
286     }
287 
288     /**
289      * @dev Removes a value from a set. O(1).
290      *
291      * Returns true if the value was removed from the set, that is if it was
292      * present.
293      */
294     function remove(UintSet storage set, uint256 value) internal returns (bool) {
295         return _remove(set._inner, bytes32(value));
296     }
297 
298     /**
299      * @dev Returns true if the value is in the set. O(1).
300      */
301     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
302         return _contains(set._inner, bytes32(value));
303     }
304 
305     /**
306      * @dev Returns the number of values on the set. O(1).
307      */
308     function length(UintSet storage set) internal view returns (uint256) {
309         return _length(set._inner);
310     }
311 
312    /**
313     * @dev Returns the value stored at position `index` in the set. O(1).
314     *
315     * Note that there are no guarantees on the ordering of values inside the
316     * array, and it may change when more values are added or removed.
317     *
318     * Requirements:
319     *
320     * - `index` must be strictly less than {length}.
321     */
322     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
323         return uint256(_at(set._inner, index));
324     }
325 }
326 
327 
328 /**
329  * @dev Contract module that allows children to implement role-based access
330  * control mechanisms.
331  *
332  * Roles are referred to by their `bytes32` identifier. These should be exposed
333  * in the external API and be unique. The best way to achieve this is by
334  * using `public constant` hash digests:
335  *
336  * ```
337  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
338  * ```
339  *
340  * Roles can be used to represent a set of permissions. To restrict access to a
341  * function call, use {hasRole}:
342  *
343  * ```
344  * function foo() public {
345  *     require(hasRole(MY_ROLE, msg.sender));
346  *     ...
347  * }
348  * ```
349  *
350  * Roles can be granted and revoked dynamically via the {grantRole} and
351  * {revokeRole} functions. Each role has an associated admin role, and only
352  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
353  *
354  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
355  * that only accounts with this role will be able to grant or revoke other
356  * roles. More complex role relationships can be created by using
357  * {_setRoleAdmin}.
358  *
359  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
360  * grant and revoke this role. Extra precautions should be taken to secure
361  * accounts that have been granted it.
362  */
363 abstract contract AccessControl is Context {
364     using EnumerableSet for EnumerableSet.AddressSet;
365     using Address for address;
366 
367     struct RoleData {
368         EnumerableSet.AddressSet members;
369         bytes32 adminRole;
370     }
371 
372     mapping (bytes32 => RoleData) private _roles;
373 
374     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
375 
376     /**
377      * @dev Emitted when `account` is granted `role`.
378      *
379      * `sender` is the account that originated the contract call, an admin role
380      * bearer except when using {_setupRole}.
381      */
382     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
383 
384     /**
385      * @dev Emitted when `account` is revoked `role`.
386      *
387      * `sender` is the account that originated the contract call:
388      *   - if using `revokeRole`, it is the admin role bearer
389      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
390      */
391     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
392 
393     /**
394      * @dev Returns `true` if `account` has been granted `role`.
395      */
396     function hasRole(bytes32 role, address account) public view returns (bool) {
397         return _roles[role].members.contains(account);
398     }
399 
400     /**
401      * @dev Returns the number of accounts that have `role`. Can be used
402      * together with {getRoleMember} to enumerate all bearers of a role.
403      */
404     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
405         return _roles[role].members.length();
406     }
407 
408     /**
409      * @dev Returns one of the accounts that have `role`. `index` must be a
410      * value between 0 and {getRoleMemberCount}, non-inclusive.
411      *
412      * Role bearers are not sorted in any particular way, and their ordering may
413      * change at any point.
414      *
415      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
416      * you perform all queries on the same block. See the following
417      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
418      * for more information.
419      */
420     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
421         return _roles[role].members.at(index);
422     }
423 
424     /**
425      * @dev Returns the admin role that controls `role`. See {grantRole} and
426      * {revokeRole}.
427      *
428      * To change a role's admin, use {_setRoleAdmin}.
429      */
430     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
431         return _roles[role].adminRole;
432     }
433 
434     /**
435      * @dev Grants `role` to `account`.
436      *
437      * If `account` had not been already granted `role`, emits a {RoleGranted}
438      * event.
439      *
440      * Requirements:
441      *
442      * - the caller must have ``role``'s admin role.
443      */
444     function grantRole(bytes32 role, address account) public virtual {
445         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
446 
447         _grantRole(role, account);
448     }
449 
450     /**
451      * @dev Revokes `role` from `account`.
452      *
453      * If `account` had been granted `role`, emits a {RoleRevoked} event.
454      *
455      * Requirements:
456      *
457      * - the caller must have ``role``'s admin role.
458      */
459     function revokeRole(bytes32 role, address account) public virtual {
460         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
461 
462         _revokeRole(role, account);
463     }
464 
465     /**
466      * @dev Revokes `role` from the calling account.
467      *
468      * Roles are often managed via {grantRole} and {revokeRole}: this function's
469      * purpose is to provide a mechanism for accounts to lose their privileges
470      * if they are compromised (such as when a trusted device is misplaced).
471      *
472      * If the calling account had been granted `role`, emits a {RoleRevoked}
473      * event.
474      *
475      * Requirements:
476      *
477      * - the caller must be `account`.
478      */
479     function renounceRole(bytes32 role, address account) public virtual {
480         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
481 
482         _revokeRole(role, account);
483     }
484 
485     /**
486      * @dev Grants `role` to `account`.
487      *
488      * If `account` had not been already granted `role`, emits a {RoleGranted}
489      * event. Note that unlike {grantRole}, this function doesn't perform any
490      * checks on the calling account.
491      *
492      * [WARNING]
493      * ====
494      * This function should only be called from the constructor when setting
495      * up the initial roles for the system.
496      *
497      * Using this function in any other way is effectively circumventing the admin
498      * system imposed by {AccessControl}.
499      * ====
500      */
501     function _setupRole(bytes32 role, address account) internal virtual {
502         _grantRole(role, account);
503     }
504 
505     /**
506      * @dev Sets `adminRole` as ``role``'s admin role.
507      */
508     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
509         _roles[role].adminRole = adminRole;
510     }
511 
512     function _grantRole(bytes32 role, address account) private {
513         if (_roles[role].members.add(account)) {
514             emit RoleGranted(role, account, _msgSender());
515         }
516     }
517 
518     function _revokeRole(bytes32 role, address account) private {
519         if (_roles[role].members.remove(account)) {
520             emit RoleRevoked(role, account, _msgSender());
521         }
522     }
523 }
524 
525 /**
526  * @dev Interface of the ERC20 standard as defined in the EIP.
527  */
528 interface IERC20 {
529     /**
530      * @dev Returns the amount of tokens in existence.
531      */
532     function totalSupply() external view returns (uint256);
533 
534     /**
535      * @dev Returns the amount of tokens owned by `account`.
536      */
537     function balanceOf(address account) external view returns (uint256);
538 
539     /**
540      * @dev Moves `amount` tokens from the caller's account to `recipient`.
541      *
542      * Returns a boolean value indicating whether the operation succeeded.
543      *
544      * Emits a {Transfer} event.
545      */
546     function transfer(address recipient, uint256 amount) external returns (bool);
547 
548     /**
549      * @dev Returns the remaining number of tokens that `spender` will be
550      * allowed to spend on behalf of `owner` through {transferFrom}. This is
551      * zero by default.
552      *
553      * This value changes when {approve} or {transferFrom} are called.
554      */
555     function allowance(address owner, address spender) external view returns (uint256);
556 
557     /**
558      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
559      *
560      * Returns a boolean value indicating whether the operation succeeded.
561      *
562      * IMPORTANT: Beware that changing an allowance with this method brings the risk
563      * that someone may use both the old and the new allowance by unfortunate
564      * transaction ordering. One possible solution to mitigate this race
565      * condition is to first reduce the spender's allowance to 0 and set the
566      * desired value afterwards:
567      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
568      *
569      * Emits an {Approval} event.
570      */
571     function approve(address spender, uint256 amount) external returns (bool);
572 
573     /**
574      * @dev Moves `amount` tokens from `sender` to `recipient` using the
575      * allowance mechanism. `amount` is then deducted from the caller's
576      * allowance.
577      *
578      * Returns a boolean value indicating whether the operation succeeded.
579      *
580      * Emits a {Transfer} event.
581      */
582     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
583 
584     /**
585      * @dev Emitted when `value` tokens are moved from one account (`from`) to
586      * another (`to`).
587      *
588      * Note that `value` may be zero.
589      */
590     event Transfer(address indexed from, address indexed to, uint256 value);
591 
592     /**
593      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
594      * a call to {approve}. `value` is the new allowance.
595      */
596     event Approval(address indexed owner, address indexed spender, uint256 value);
597 }
598 
599 /**
600  * @dev Wrappers over Solidity's arithmetic operations with added overflow
601  * checks.
602  *
603  * Arithmetic operations in Solidity wrap on overflow. This can easily result
604  * in bugs, because programmers usually assume that an overflow raises an
605  * error, which is the standard behavior in high level programming languages.
606  * `SafeMath` restores this intuition by reverting the transaction when an
607  * operation overflows.
608  *
609  * Using this library instead of the unchecked operations eliminates an entire
610  * class of bugs, so it's recommended to use it always.
611  */
612 library SafeMath {
613     /**
614      * @dev Returns the addition of two unsigned integers, reverting on
615      * overflow.
616      *
617      * Counterpart to Solidity's `+` operator.
618      *
619      * Requirements:
620      * - Addition cannot overflow.
621      */
622     function add(uint256 a, uint256 b) internal pure returns (uint256) {
623         uint256 c = a + b;
624         require(c >= a, "SafeMath: addition overflow");
625 
626         return c;
627     }
628 
629     /**
630      * @dev Returns the subtraction of two unsigned integers, reverting on
631      * overflow (when the result is negative).
632      *
633      * Counterpart to Solidity's `-` operator.
634      *
635      * Requirements:
636      * - Subtraction cannot overflow.
637      */
638     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
639         return sub(a, b, "SafeMath: subtraction overflow");
640     }
641 
642     /**
643      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
644      * overflow (when the result is negative).
645      *
646      * Counterpart to Solidity's `-` operator.
647      *
648      * Requirements:
649      * - Subtraction cannot overflow.
650      */
651     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
652         require(b <= a, errorMessage);
653         uint256 c = a - b;
654 
655         return c;
656     }
657 
658     /**
659      * @dev Returns the multiplication of two unsigned integers, reverting on
660      * overflow.
661      *
662      * Counterpart to Solidity's `*` operator.
663      *
664      * Requirements:
665      * - Multiplication cannot overflow.
666      */
667     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
668         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
669         // benefit is lost if 'b' is also tested.
670         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
671         if (a == 0) {
672             return 0;
673         }
674 
675         uint256 c = a * b;
676         require(c / a == b, "SafeMath: multiplication overflow");
677 
678         return c;
679     }
680 
681     /**
682      * @dev Returns the integer division of two unsigned integers. Reverts on
683      * division by zero. The result is rounded towards zero.
684      *
685      * Counterpart to Solidity's `/` operator. Note: this function uses a
686      * `revert` opcode (which leaves remaining gas untouched) while Solidity
687      * uses an invalid opcode to revert (consuming all remaining gas).
688      *
689      * Requirements:
690      * - The divisor cannot be zero.
691      */
692     function div(uint256 a, uint256 b) internal pure returns (uint256) {
693         return div(a, b, "SafeMath: division by zero");
694     }
695 
696     /**
697      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
698      * division by zero. The result is rounded towards zero.
699      *
700      * Counterpart to Solidity's `/` operator. Note: this function uses a
701      * `revert` opcode (which leaves remaining gas untouched) while Solidity
702      * uses an invalid opcode to revert (consuming all remaining gas).
703      *
704      * Requirements:
705      * - The divisor cannot be zero.
706      */
707     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
708         // Solidity only automatically asserts when dividing by 0
709         require(b > 0, errorMessage);
710         uint256 c = a / b;
711         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
712 
713         return c;
714     }
715 
716     /**
717      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
718      * Reverts when dividing by zero.
719      *
720      * Counterpart to Solidity's `%` operator. This function uses a `revert`
721      * opcode (which leaves remaining gas untouched) while Solidity uses an
722      * invalid opcode to revert (consuming all remaining gas).
723      *
724      * Requirements:
725      * - The divisor cannot be zero.
726      */
727     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
728         return mod(a, b, "SafeMath: modulo by zero");
729     }
730 
731     /**
732      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
733      * Reverts with custom message when dividing by zero.
734      *
735      * Counterpart to Solidity's `%` operator. This function uses a `revert`
736      * opcode (which leaves remaining gas untouched) while Solidity uses an
737      * invalid opcode to revert (consuming all remaining gas).
738      *
739      * Requirements:
740      * - The divisor cannot be zero.
741      */
742     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
743         require(b != 0, errorMessage);
744         return a % b;
745     }
746 }
747 
748 
749 /**
750  * @dev Implementation of the {IERC20} interface.
751  *
752  * This implementation is agnostic to the way tokens are created. This means
753  * that a supply mechanism has to be added in a derived contract using {_mint}.
754  * For a generic mechanism see {ERC20MinterPauser}.
755  *
756  * TIP: For a detailed writeup see our guide
757  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
758  * to implement supply mechanisms].
759  *
760  * We have followed general OpenZeppelin guidelines: functions revert instead
761  * of returning `false` on failure. This behavior is nonetheless conventional
762  * and does not conflict with the expectations of ERC20 applications.
763  *
764  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
765  * This allows applications to reconstruct the allowance for all accounts just
766  * by listening to said events. Other implementations of the EIP may not emit
767  * these events, as it isn't required by the specification.
768  *
769  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
770  * functions have been added to mitigate the well-known issues around setting
771  * allowances. See {IERC20-approve}.
772  */
773 contract ERC20 is Context, IERC20 {
774     using SafeMath for uint256;
775     using Address for address;
776 
777     mapping (address => uint256) private _balances;
778 
779     mapping (address => mapping (address => uint256)) private _allowances;
780 
781     uint256 private _totalSupply;
782 
783     string private _name;
784     string private _symbol;
785     uint8 private _decimals;
786 
787     /**
788      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
789      * a default value of 18.
790      *
791      * To select a different value for {decimals}, use {_setupDecimals}.
792      *
793      * All three of these values are immutable: they can only be set once during
794      * construction.
795      */
796     constructor (string memory name, string memory symbol) public {
797         _name = name;
798         _symbol = symbol;
799         _decimals = 18;
800     }
801 
802     /**
803      * @dev Returns the name of the token.
804      */
805     function name() public view returns (string memory) {
806         return _name;
807     }
808 
809     /**
810      * @dev Returns the symbol of the token, usually a shorter version of the
811      * name.
812      */
813     function symbol() public view returns (string memory) {
814         return _symbol;
815     }
816 
817     /**
818      * @dev Returns the number of decimals used to get its user representation.
819      * For example, if `decimals` equals `2`, a balance of `505` tokens should
820      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
821      *
822      * Tokens usually opt for a value of 18, imitating the relationship between
823      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
824      * called.
825      *
826      * NOTE: This information is only used for _display_ purposes: it in
827      * no way affects any of the arithmetic of the contract, including
828      * {IERC20-balanceOf} and {IERC20-transfer}.
829      */
830     function decimals() public view returns (uint8) {
831         return _decimals;
832     }
833 
834     /**
835      * @dev See {IERC20-totalSupply}.
836      */
837     function totalSupply() public view override returns (uint256) {
838         return _totalSupply;
839     }
840 
841     /**
842      * @dev See {IERC20-balanceOf}.
843      */
844     function balanceOf(address account) public view override returns (uint256) {
845         return _balances[account];
846     }
847 
848     /**
849      * @dev See {IERC20-transfer}.
850      *
851      * Requirements:
852      *
853      * - `recipient` cannot be the zero address.
854      * - the caller must have a balance of at least `amount`.
855      */
856     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
857         _transfer(_msgSender(), recipient, amount);
858         return true;
859     }
860 
861     /**
862      * @dev See {IERC20-allowance}.
863      */
864     function allowance(address owner, address spender) public view virtual override returns (uint256) {
865         return _allowances[owner][spender];
866     }
867 
868     /**
869      * @dev See {IERC20-approve}.
870      *
871      * Requirements:
872      *
873      * - `spender` cannot be the zero address.
874      */
875     function approve(address spender, uint256 amount) public virtual override returns (bool) {
876         _approve(_msgSender(), spender, amount);
877         return true;
878     }
879 
880     /**
881      * @dev See {IERC20-transferFrom}.
882      *
883      * Emits an {Approval} event indicating the updated allowance. This is not
884      * required by the EIP. See the note at the beginning of {ERC20};
885      *
886      * Requirements:
887      * - `sender` and `recipient` cannot be the zero address.
888      * - `sender` must have a balance of at least `amount`.
889      * - the caller must have allowance for ``sender``'s tokens of at least
890      * `amount`.
891      */
892     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
893         _transfer(sender, recipient, amount);
894         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
895         return true;
896     }
897 
898     /**
899      * @dev Atomically increases the allowance granted to `spender` by the caller.
900      *
901      * This is an alternative to {approve} that can be used as a mitigation for
902      * problems described in {IERC20-approve}.
903      *
904      * Emits an {Approval} event indicating the updated allowance.
905      *
906      * Requirements:
907      *
908      * - `spender` cannot be the zero address.
909      */
910     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
911         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
912         return true;
913     }
914 
915     /**
916      * @dev Atomically decreases the allowance granted to `spender` by the caller.
917      *
918      * This is an alternative to {approve} that can be used as a mitigation for
919      * problems described in {IERC20-approve}.
920      *
921      * Emits an {Approval} event indicating the updated allowance.
922      *
923      * Requirements:
924      *
925      * - `spender` cannot be the zero address.
926      * - `spender` must have allowance for the caller of at least
927      * `subtractedValue`.
928      */
929     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
930         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
931         return true;
932     }
933 
934     /**
935      * @dev Moves tokens `amount` from `sender` to `recipient`.
936      *
937      * This is internal function is equivalent to {transfer}, and can be used to
938      * e.g. implement automatic token fees, slashing mechanisms, etc.
939      *
940      * Emits a {Transfer} event.
941      *
942      * Requirements:
943      *
944      * - `sender` cannot be the zero address.
945      * - `recipient` cannot be the zero address.
946      * - `sender` must have a balance of at least `amount`.
947      */
948     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
949         require(sender != address(0), "ERC20: transfer from the zero address");
950         require(recipient != address(0), "ERC20: transfer to the zero address");
951 
952         _beforeTokenTransfer(sender, recipient, amount);
953 
954         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
955         _balances[recipient] = _balances[recipient].add(amount);
956         emit Transfer(sender, recipient, amount);
957     }
958 
959     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
960      * the total supply.
961      *
962      * Emits a {Transfer} event with `from` set to the zero address.
963      *
964      * Requirements
965      *
966      * - `to` cannot be the zero address.
967      */
968     function _mint(address account, uint256 amount) internal virtual {
969         require(account != address(0), "ERC20: mint to the zero address");
970 
971         _beforeTokenTransfer(address(0), account, amount);
972 
973         _totalSupply = _totalSupply.add(amount);
974         _balances[account] = _balances[account].add(amount);
975         emit Transfer(address(0), account, amount);
976     }
977 
978     /**
979      * @dev Destroys `amount` tokens from `account`, reducing the
980      * total supply.
981      *
982      * Emits a {Transfer} event with `to` set to the zero address.
983      *
984      * Requirements
985      *
986      * - `account` cannot be the zero address.
987      * - `account` must have at least `amount` tokens.
988      */
989     function _burn(address account, uint256 amount) internal virtual {
990         require(account != address(0), "ERC20: burn from the zero address");
991 
992         _beforeTokenTransfer(account, address(0), amount);
993 
994         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
995         _totalSupply = _totalSupply.sub(amount);
996         emit Transfer(account, address(0), amount);
997     }
998 
999     /**
1000      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1001      *
1002      * This is internal function is equivalent to `approve`, and can be used to
1003      * e.g. set automatic allowances for certain subsystems, etc.
1004      *
1005      * Emits an {Approval} event.
1006      *
1007      * Requirements:
1008      *
1009      * - `owner` cannot be the zero address.
1010      * - `spender` cannot be the zero address.
1011      */
1012     function _approve(address owner, address spender, uint256 amount) internal virtual {
1013         require(owner != address(0), "ERC20: approve from the zero address");
1014         require(spender != address(0), "ERC20: approve to the zero address");
1015 
1016         _allowances[owner][spender] = amount;
1017         emit Approval(owner, spender, amount);
1018     }
1019 
1020     /**
1021      * @dev Sets {decimals} to a value other than the default one of 18.
1022      *
1023      * WARNING: This function should only be called from the constructor. Most
1024      * applications that interact with token contracts will not expect
1025      * {decimals} to ever change, and may work incorrectly if it does.
1026      */
1027     function _setupDecimals(uint8 decimals_) internal {
1028         _decimals = decimals_;
1029     }
1030 
1031     /**
1032      * @dev Hook that is called before any transfer of tokens. This includes
1033      * minting and burning.
1034      *
1035      * Calling conditions:
1036      *
1037      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1038      * will be to transferred to `to`.
1039      * - when `from` is zero, `amount` tokens will be minted for `to`.
1040      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1041      * - `from` and `to` are never both zero.
1042      *
1043      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1044      */
1045     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1046 }
1047 
1048 /**
1049  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1050  * tokens and those that they have an allowance for, in a way that can be
1051  * recognized off-chain (via event analysis).
1052  */
1053 abstract contract ERC20Burnable is Context, ERC20 {
1054     /**
1055      * @dev Destroys `amount` tokens from the caller.
1056      *
1057      * See {ERC20-_burn}.
1058      */
1059     function burn(uint256 amount) public virtual {
1060         _burn(_msgSender(), amount);
1061     }
1062 
1063     /**
1064      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1065      * allowance.
1066      *
1067      * See {ERC20-_burn} and {ERC20-allowance}.
1068      *
1069      * Requirements:
1070      *
1071      * - the caller must have allowance for ``accounts``'s tokens of at least
1072      * `amount`.
1073      */
1074     function burnFrom(address account, uint256 amount) public virtual {
1075         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1076 
1077         _approve(account, _msgSender(), decreasedAllowance);
1078         _burn(account, amount);
1079     }
1080 }
1081 
1082 /**
1083  * @dev Contract module which allows children to implement an emergency stop
1084  * mechanism that can be triggered by an authorized account.
1085  *
1086  * This module is used through inheritance. It will make available the
1087  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1088  * the functions of your contract. Note that they will not be pausable by
1089  * simply including this module, only once the modifiers are put in place.
1090  */
1091 contract Pausable is Context {
1092     /**
1093      * @dev Emitted when the pause is triggered by `account`.
1094      */
1095     event Paused(address account);
1096 
1097     /**
1098      * @dev Emitted when the pause is lifted by `account`.
1099      */
1100     event Unpaused(address account);
1101 
1102     bool private _paused;
1103 
1104     /**
1105      * @dev Initializes the contract in unpaused state.
1106      */
1107     constructor () internal {
1108         _paused = false;
1109     }
1110 
1111     /**
1112      * @dev Returns true if the contract is paused, and false otherwise.
1113      */
1114     function paused() public view returns (bool) {
1115         return _paused;
1116     }
1117 
1118     /**
1119      * @dev Modifier to make a function callable only when the contract is not paused.
1120      */
1121     modifier whenNotPaused() {
1122         require(!_paused, "Pausable: paused");
1123         _;
1124     }
1125 
1126     /**
1127      * @dev Modifier to make a function callable only when the contract is paused.
1128      */
1129     modifier whenPaused() {
1130         require(_paused, "Pausable: not paused");
1131         _;
1132     }
1133 
1134     /**
1135      * @dev Triggers stopped state.
1136      */
1137     function _pause() internal virtual whenNotPaused {
1138         _paused = true;
1139         emit Paused(_msgSender());
1140     }
1141 
1142     /**
1143      * @dev Returns to normal state.
1144      */
1145     function _unpause() internal virtual whenPaused {
1146         _paused = false;
1147         emit Unpaused(_msgSender());
1148     }
1149 }
1150 
1151 
1152 /**
1153  * @dev ERC20 token with pausable token transfers, minting and burning.
1154  *
1155  * Useful for scenarios such as preventing trades until the end of an evaluation
1156  * period, or having an emergency switch for freezing all token transfers in the
1157  * event of a large bug.
1158  */
1159 abstract contract ERC20Pausable is ERC20, Pausable {
1160     /**
1161      * @dev See {ERC20-_beforeTokenTransfer}.
1162      *
1163      * Requirements:
1164      *
1165      * - the contract must not be paused.
1166      */
1167     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1168         super._beforeTokenTransfer(from, to, amount);
1169 
1170         require(!paused(), "ERC20Pausable: token transfer while paused");
1171     }
1172 }
1173 
1174 /**
1175  * @dev {ERC20} token, including:
1176  *
1177  *  - ability for holders to burn (destroy) their tokens
1178  *  - a minter role that allows for token minting (creation)
1179  *  - a pauser role that allows to stop all token transfers
1180  *
1181  * This contract uses {AccessControl} to lock permissioned functions using the
1182  * different roles - head to its documentation for details.
1183  *
1184  * The account that deploys the contract will be granted the minter and pauser
1185  * roles, as well as the default admin role, which will let it grant both minter
1186  * and pauser roles to aother accounts
1187  */
1188 contract MyToken is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1189     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1190     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1191 
1192     /**
1193      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1194      * account that deploys the contract.
1195      *
1196      * See {ERC20-constructor}.
1197      */
1198     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1199         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1200 
1201         _setupRole(MINTER_ROLE, _msgSender());
1202         _setupRole(PAUSER_ROLE, _msgSender());
1203     }
1204 
1205     /**
1206      * @dev Creates `amount` new tokens for `to`.
1207      *
1208      * See {ERC20-_mint}.
1209      *
1210      * Requirements:
1211      *
1212      * - the caller must have the `MINTER_ROLE`.
1213      */
1214     function mint(address to, uint256 amount) public {
1215         require(hasRole(MINTER_ROLE, _msgSender()), "must have minter role to mint");
1216         _mint(to, amount);
1217     }
1218 
1219     /**
1220      * @dev Pauses all token transfers.
1221      *
1222      * See {ERC20Pausable} and {Pausable-_pause}.
1223      *
1224      * Requirements:
1225      *
1226      * - the caller must have the `PAUSER_ROLE`.
1227      */
1228     function pause() public {
1229         require(hasRole(PAUSER_ROLE, _msgSender()), "must have pauser role to pause");
1230         _pause();
1231     }
1232 
1233     /**
1234      * @dev Unpauses all token transfers.
1235      *
1236      * See {ERC20Pausable} and {Pausable-_unpause}.
1237      *
1238      * Requirements:
1239      *
1240      * - the caller must have the `PAUSER_ROLE`.
1241      */
1242     function unpause() public {
1243         require(hasRole(PAUSER_ROLE, _msgSender()), "must have pauser role to unpause");
1244         _unpause();
1245     }
1246 
1247     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Pausable) {
1248         super._beforeTokenTransfer(from, to, amount);
1249     }
1250 }