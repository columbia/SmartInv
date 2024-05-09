1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity 0.6.2;
3 
4 /**
5  * @dev Library for managing
6  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
7  * types.
8  *
9  * Sets have the following properties:
10  *
11  * - Elements are added, removed, and checked for existence in constant time
12  * (O(1)).
13  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
14  *
15  * ```
16  * contract Example {
17  *     // Add the library methods
18  *     using EnumerableSet for EnumerableSet.AddressSet;
19  *
20  *     // Declare a set state variable
21  *     EnumerableSet.AddressSet private mySet;
22  * }
23  * ```
24  *
25  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
26  * (`UintSet`) are supported.
27  */
28 library EnumerableSet {
29     // To implement this library for multiple types with as little code
30     // repetition as possible, we write it in terms of a generic Set type with
31     // bytes32 values.
32     // The Set implementation uses private functions, and user-facing
33     // implementations (such as AddressSet) are just wrappers around the
34     // underlying Set.
35     // This means that we can only create new EnumerableSets for types that fit
36     // in bytes32.
37 
38     struct Set {
39         // Storage of set values
40         bytes32[] _values;
41 
42         // Position of the value in the `values` array, plus 1 because index 0
43         // means a value is not in the set.
44         mapping (bytes32 => uint256) _indexes;
45     }
46 
47     /**
48      * @dev Add a value to a set. O(1).
49      *
50      * Returns true if the value was added to the set, that is if it was not
51      * already present.
52      */
53     function _add(Set storage set, bytes32 value) private returns (bool) {
54         if (!_contains(set, value)) {
55             set._values.push(value);
56             // The value is stored at length-1, but we add 1 to all indexes
57             // and use 0 as a sentinel value
58             set._indexes[value] = set._values.length;
59             return true;
60         } else {
61             return false;
62         }
63     }
64 
65     /**
66      * @dev Removes a value from a set. O(1).
67      *
68      * Returns true if the value was removed from the set, that is if it was
69      * present.
70      */
71     function _remove(Set storage set, bytes32 value) private returns (bool) {
72         // We read and store the value's index to prevent multiple reads from the same storage slot
73         uint256 valueIndex = set._indexes[value];
74 
75         if (valueIndex != 0) { // Equivalent to contains(set, value)
76             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
77             // the array, and then remove the last element (sometimes called as 'swap and pop').
78             // This modifies the order of the array, as noted in {at}.
79 
80             uint256 toDeleteIndex = valueIndex - 1;
81             uint256 lastIndex = set._values.length - 1;
82 
83             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
84             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
85 
86             bytes32 lastvalue = set._values[lastIndex];
87 
88             // Move the last value to the index where the value to delete is
89             set._values[toDeleteIndex] = lastvalue;
90             // Update the index for the moved value
91             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
92 
93             // Delete the slot where the moved value was stored
94             set._values.pop();
95 
96             // Delete the index for the deleted slot
97             delete set._indexes[value];
98 
99             return true;
100         } else {
101             return false;
102         }
103     }
104 
105     /**
106      * @dev Returns true if the value is in the set. O(1).
107      */
108     function _contains(Set storage set, bytes32 value) private view returns (bool) {
109         return set._indexes[value] != 0;
110     }
111 
112     /**
113      * @dev Returns the number of values on the set. O(1).
114      */
115     function _length(Set storage set) private view returns (uint256) {
116         return set._values.length;
117     }
118 
119    /**
120     * @dev Returns the value stored at position `index` in the set. O(1).
121     *
122     * Note that there are no guarantees on the ordering of values inside the
123     * array, and it may change when more values are added or removed.
124     *
125     * Requirements:
126     *
127     * - `index` must be strictly less than {length}.
128     */
129     function _at(Set storage set, uint256 index) private view returns (bytes32) {
130         require(set._values.length > index, "EnumerableSet: index out of bounds");
131         return set._values[index];
132     }
133 
134     // AddressSet
135 
136     struct AddressSet {
137         Set _inner;
138     }
139 
140     /**
141      * @dev Add a value to a set. O(1).
142      *
143      * Returns true if the value was added to the set, that is if it was not
144      * already present.
145      */
146     function add(AddressSet storage set, address value) internal returns (bool) {
147         return _add(set._inner, bytes32(uint256(value)));
148     }
149 
150     /**
151      * @dev Removes a value from a set. O(1).
152      *
153      * Returns true if the value was removed from the set, that is if it was
154      * present.
155      */
156     function remove(AddressSet storage set, address value) internal returns (bool) {
157         return _remove(set._inner, bytes32(uint256(value)));
158     }
159 
160     /**
161      * @dev Returns true if the value is in the set. O(1).
162      */
163     function contains(AddressSet storage set, address value) internal view returns (bool) {
164         return _contains(set._inner, bytes32(uint256(value)));
165     }
166 
167     /**
168      * @dev Returns the number of values in the set. O(1).
169      */
170     function length(AddressSet storage set) internal view returns (uint256) {
171         return _length(set._inner);
172     }
173 
174    /**
175     * @dev Returns the value stored at position `index` in the set. O(1).
176     *
177     * Note that there are no guarantees on the ordering of values inside the
178     * array, and it may change when more values are added or removed.
179     *
180     * Requirements:
181     *
182     * - `index` must be strictly less than {length}.
183     */
184     function at(AddressSet storage set, uint256 index) internal view returns (address) {
185         return address(uint256(_at(set._inner, index)));
186     }
187 
188 
189     // UintSet
190 
191     struct UintSet {
192         Set _inner;
193     }
194 
195     /**
196      * @dev Add a value to a set. O(1).
197      *
198      * Returns true if the value was added to the set, that is if it was not
199      * already present.
200      */
201     function add(UintSet storage set, uint256 value) internal returns (bool) {
202         return _add(set._inner, bytes32(value));
203     }
204 
205     /**
206      * @dev Removes a value from a set. O(1).
207      *
208      * Returns true if the value was removed from the set, that is if it was
209      * present.
210      */
211     function remove(UintSet storage set, uint256 value) internal returns (bool) {
212         return _remove(set._inner, bytes32(value));
213     }
214 
215     /**
216      * @dev Returns true if the value is in the set. O(1).
217      */
218     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
219         return _contains(set._inner, bytes32(value));
220     }
221 
222     /**
223      * @dev Returns the number of values on the set. O(1).
224      */
225     function length(UintSet storage set) internal view returns (uint256) {
226         return _length(set._inner);
227     }
228 
229    /**
230     * @dev Returns the value stored at position `index` in the set. O(1).
231     *
232     * Note that there are no guarantees on the ordering of values inside the
233     * array, and it may change when more values are added or removed.
234     *
235     * Requirements:
236     *
237     * - `index` must be strictly less than {length}.
238     */
239     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
240         return uint256(_at(set._inner, index));
241     }
242 }
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
267         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
268         // for accounts without code, i.e. `keccak256('')`
269         bytes32 codehash;
270         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
271         // solhint-disable-next-line no-inline-assembly
272         assembly { codehash := extcodehash(account) }
273         return (codehash != accountHash && codehash != 0x0);
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
296         (bool success, ) = recipient.call{ value: amount }("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 }
300 
301 /*
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with GSN meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 contract Context {
312     // Empty internal constructor, to prevent people from mistakenly deploying
313     // an instance of this contract, which should be used via inheritance.
314     constructor () internal { }
315 
316     function _msgSender() internal view virtual returns (address payable) {
317         return msg.sender;
318     }
319 
320     function _msgData() internal view virtual returns (bytes memory) {
321         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
322         return msg.data;
323     }
324 }
325 
326 /**
327  * @dev Contract module that allows children to implement role-based access
328  * control mechanisms.
329  *
330  * Roles are referred to by their `bytes32` identifier. These should be exposed
331  * in the external API and be unique. The best way to achieve this is by
332  * using `public constant` hash digests:
333  *
334  * ```
335  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
336  * ```
337  *
338  * Roles can be used to represent a set of permissions. To restrict access to a
339  * function call, use {hasRole}:
340  *
341  * ```
342  * function foo() public {
343  *     require(hasRole(MY_ROLE, _msgSender()));
344  *     ...
345  * }
346  * ```
347  *
348  * Roles can be granted and revoked dynamically via the {grantRole} and
349  * {revokeRole} functions. Each role has an associated admin role, and only
350  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
351  *
352  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
353  * that only accounts with this role will be able to grant or revoke other
354  * roles. More complex role relationships can be created by using
355  * {_setRoleAdmin}.
356  */
357 abstract contract AccessControl is Context {
358     using EnumerableSet for EnumerableSet.AddressSet;
359     using Address for address;
360 
361     struct RoleData {
362         EnumerableSet.AddressSet members;
363         bytes32 adminRole;
364     }
365 
366     mapping (bytes32 => RoleData) private _roles;
367 
368     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
369 
370     /**
371      * @dev Emitted when `account` is granted `role`.
372      *
373      * `sender` is the account that originated the contract call, an admin role
374      * bearer except when using {_setupRole}.
375      */
376     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
377 
378     /**
379      * @dev Emitted when `account` is revoked `role`.
380      *
381      * `sender` is the account that originated the contract call:
382      *   - if using `revokeRole`, it is the admin role bearer
383      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
384      */
385     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
386 
387     /**
388      * @dev Returns `true` if `account` has been granted `role`.
389      */
390     function hasRole(bytes32 role, address account) public view returns (bool) {
391         return _roles[role].members.contains(account);
392     }
393 
394     /**
395      * @dev Returns the number of accounts that have `role`. Can be used
396      * together with {getRoleMember} to enumerate all bearers of a role.
397      */
398     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
399         return _roles[role].members.length();
400     }
401 
402     /**
403      * @dev Returns one of the accounts that have `role`. `index` must be a
404      * value between 0 and {getRoleMemberCount}, non-inclusive.
405      *
406      * Role bearers are not sorted in any particular way, and their ordering may
407      * change at any point.
408      *
409      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
410      * you perform all queries on the same block. See the following
411      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
412      * for more information.
413      */
414     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
415         return _roles[role].members.at(index);
416     }
417 
418     /**
419      * @dev Returns the admin role that controls `role`. See {grantRole} and
420      * {revokeRole}.
421      *
422      * To change a role's admin, use {_setRoleAdmin}.
423      */
424     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
425         return _roles[role].adminRole;
426     }
427 
428     /**
429      * @dev Grants `role` to `account`.
430      *
431      * If `account` had not been already granted `role`, emits a {RoleGranted}
432      * event.
433      *
434      * Requirements:
435      *
436      * - the caller must have ``role``'s admin role.
437      */
438     function grantRole(bytes32 role, address account) public virtual {
439         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
440 
441         _grantRole(role, account);
442     }
443 
444     /**
445      * @dev Revokes `role` from `account`.
446      *
447      * If `account` had been granted `role`, emits a {RoleRevoked} event.
448      *
449      * Requirements:
450      *
451      * - the caller must have ``role``'s admin role.
452      */
453     function revokeRole(bytes32 role, address account) public virtual {
454         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
455 
456         _revokeRole(role, account);
457     }
458 
459     /**
460      * @dev Revokes `role` from the calling account.
461      *
462      * Roles are often managed via {grantRole} and {revokeRole}: this function's
463      * purpose is to provide a mechanism for accounts to lose their privileges
464      * if they are compromised (such as when a trusted device is misplaced).
465      *
466      * If the calling account had been granted `role`, emits a {RoleRevoked}
467      * event.
468      *
469      * Requirements:
470      *
471      * - the caller must be `account`.
472      */
473     function renounceRole(bytes32 role, address account) public virtual {
474         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
475 
476         _revokeRole(role, account);
477     }
478 
479     /**
480      * @dev Grants `role` to `account`.
481      *
482      * If `account` had not been already granted `role`, emits a {RoleGranted}
483      * event. Note that unlike {grantRole}, this function doesn't perform any
484      * checks on the calling account.
485      *
486      * [WARNING]
487      * ====
488      * This function should only be called from the constructor when setting
489      * up the initial roles for the system.
490      *
491      * Using this function in any other way is effectively circumventing the admin
492      * system imposed by {AccessControl}.
493      * ====
494      */
495     function _setupRole(bytes32 role, address account) internal virtual {
496         _grantRole(role, account);
497     }
498 
499     /**
500      * @dev Sets `adminRole` as ``role``'s admin role.
501      */
502     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
503         _roles[role].adminRole = adminRole;
504     }
505 
506     function _grantRole(bytes32 role, address account) private {
507         if (_roles[role].members.add(account)) {
508             emit RoleGranted(role, account, _msgSender());
509         }
510     }
511 
512     function _revokeRole(bytes32 role, address account) private {
513         if (_roles[role].members.remove(account)) {
514             emit RoleRevoked(role, account, _msgSender());
515         }
516     }
517 }
518 
519 
520 
521 /**
522  * @dev Interface of the ERC20 standard as defined in the EIP.
523  */
524 interface IERC20 {
525     /**
526      * @dev Returns the amount of tokens in existence.
527      */
528     function totalSupply() external view returns (uint256);
529 
530     /**
531      * @dev Returns the amount of tokens owned by `account`.
532      */
533     function balanceOf(address account) external view returns (uint256);
534 
535     /**
536      * @dev Moves `amount` tokens from the caller's account to `recipient`.
537      *
538      * Returns a boolean value indicating whether the operation succeeded.
539      *
540      * Emits a {Transfer} event.
541      */
542     function transfer(address recipient, uint256 amount) external returns (bool);
543 
544     /**
545      * @dev Returns the remaining number of tokens that `spender` will be
546      * allowed to spend on behalf of `owner` through {transferFrom}. This is
547      * zero by default.
548      *
549      * This value changes when {approve} or {transferFrom} are called.
550      */
551     function allowance(address owner, address spender) external view returns (uint256);
552 
553     /**
554      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
555      *
556      * Returns a boolean value indicating whether the operation succeeded.
557      *
558      * IMPORTANT: Beware that changing an allowance with this method brings the risk
559      * that someone may use both the old and the new allowance by unfortunate
560      * transaction ordering. One possible solution to mitigate this race
561      * condition is to first reduce the spender's allowance to 0 and set the
562      * desired value afterwards:
563      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
564      *
565      * Emits an {Approval} event.
566      */
567     function approve(address spender, uint256 amount) external returns (bool);
568 
569     /**
570      * @dev Moves `amount` tokens from `sender` to `recipient` using the
571      * allowance mechanism. `amount` is then deducted from the caller's
572      * allowance.
573      *
574      * Returns a boolean value indicating whether the operation succeeded.
575      *
576      * Emits a {Transfer} event.
577      */
578     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
579 
580     /**
581      * @dev Emitted when `value` tokens are moved from one account (`from`) to
582      * another (`to`).
583      *
584      * Note that `value` may be zero.
585      */
586     event Transfer(address indexed from, address indexed to, uint256 value);
587 
588     /**
589      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
590      * a call to {approve}. `value` is the new allowance.
591      */
592     event Approval(address indexed owner, address indexed spender, uint256 value);
593 }
594 
595 /**
596  * @dev Wrappers over Solidity's arithmetic operations with added overflow
597  * checks.
598  *
599  * Arithmetic operations in Solidity wrap on overflow. This can easily result
600  * in bugs, because programmers usually assume that an overflow raises an
601  * error, which is the standard behavior in high level programming languages.
602  * `SafeMath` restores this intuition by reverting the transaction when an
603  * operation overflows.
604  *
605  * Using this library instead of the unchecked operations eliminates an entire
606  * class of bugs, so it's recommended to use it always.
607  */
608 library SafeMath {
609     /**
610      * @dev Returns the addition of two unsigned integers, reverting on
611      * overflow.
612      *
613      * Counterpart to Solidity's `+` operator.
614      *
615      * Requirements:
616      * - Addition cannot overflow.
617      */
618     function add(uint256 a, uint256 b) internal pure returns (uint256) {
619         uint256 c = a + b;
620         require(c >= a, "SafeMath: addition overflow");
621 
622         return c;
623     }
624 
625     /**
626      * @dev Returns the subtraction of two unsigned integers, reverting on
627      * overflow (when the result is negative).
628      *
629      * Counterpart to Solidity's `-` operator.
630      *
631      * Requirements:
632      * - Subtraction cannot overflow.
633      */
634     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
635         return sub(a, b, "SafeMath: subtraction overflow");
636     }
637 
638     /**
639      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
640      * overflow (when the result is negative).
641      *
642      * Counterpart to Solidity's `-` operator.
643      *
644      * Requirements:
645      * - Subtraction cannot overflow.
646      */
647     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
648         require(b <= a, errorMessage);
649         uint256 c = a - b;
650 
651         return c;
652     }
653 
654     /**
655      * @dev Returns the multiplication of two unsigned integers, reverting on
656      * overflow.
657      *
658      * Counterpart to Solidity's `*` operator.
659      *
660      * Requirements:
661      * - Multiplication cannot overflow.
662      */
663     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
664         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
665         // benefit is lost if 'b' is also tested.
666         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
667         if (a == 0) {
668             return 0;
669         }
670 
671         uint256 c = a * b;
672         require(c / a == b, "SafeMath: multiplication overflow");
673 
674         return c;
675     }
676 
677     /**
678      * @dev Returns the integer division of two unsigned integers. Reverts on
679      * division by zero. The result is rounded towards zero.
680      *
681      * Counterpart to Solidity's `/` operator. Note: this function uses a
682      * `revert` opcode (which leaves remaining gas untouched) while Solidity
683      * uses an invalid opcode to revert (consuming all remaining gas).
684      *
685      * Requirements:
686      * - The divisor cannot be zero.
687      */
688     function div(uint256 a, uint256 b) internal pure returns (uint256) {
689         return div(a, b, "SafeMath: division by zero");
690     }
691 
692     /**
693      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
694      * division by zero. The result is rounded towards zero.
695      *
696      * Counterpart to Solidity's `/` operator. Note: this function uses a
697      * `revert` opcode (which leaves remaining gas untouched) while Solidity
698      * uses an invalid opcode to revert (consuming all remaining gas).
699      *
700      * Requirements:
701      * - The divisor cannot be zero.
702      */
703     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
704         // Solidity only automatically asserts when dividing by 0
705         require(b > 0, errorMessage);
706         uint256 c = a / b;
707         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
708 
709         return c;
710     }
711 
712     /**
713      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
714      * Reverts when dividing by zero.
715      *
716      * Counterpart to Solidity's `%` operator. This function uses a `revert`
717      * opcode (which leaves remaining gas untouched) while Solidity uses an
718      * invalid opcode to revert (consuming all remaining gas).
719      *
720      * Requirements:
721      * - The divisor cannot be zero.
722      */
723     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
724         return mod(a, b, "SafeMath: modulo by zero");
725     }
726 
727     /**
728      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
729      * Reverts with custom message when dividing by zero.
730      *
731      * Counterpart to Solidity's `%` operator. This function uses a `revert`
732      * opcode (which leaves remaining gas untouched) while Solidity uses an
733      * invalid opcode to revert (consuming all remaining gas).
734      *
735      * Requirements:
736      * - The divisor cannot be zero.
737      */
738     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
739         require(b != 0, errorMessage);
740         return a % b;
741     }
742 }
743 
744 /**
745  * @dev Implementation of the {IERC20} interface.
746  *
747  * This implementation is agnostic to the way tokens are created. This means
748  * that a supply mechanism has to be added in a derived contract using {_mint}.
749  * For a generic mechanism see {ERC20MinterPauser}.
750  *
751  * TIP: For a detailed writeup see our guide
752  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
753  * to implement supply mechanisms].
754  *
755  * We have followed general OpenZeppelin guidelines: functions revert instead
756  * of returning `false` on failure. This behavior is nonetheless conventional
757  * and does not conflict with the expectations of ERC20 applications.
758  *
759  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
760  * This allows applications to reconstruct the allowance for all accounts just
761  * by listening to said events. Other implementations of the EIP may not emit
762  * these events, as it isn't required by the specification.
763  *
764  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
765  * functions have been added to mitigate the well-known issues around setting
766  * allowances. See {IERC20-approve}.
767  */
768 contract ERC20 is Context, IERC20 {
769     using SafeMath for uint256;
770     using Address for address;
771 
772     mapping (address => uint256) private _balances;
773 
774     mapping (address => mapping (address => uint256)) private _allowances;
775 
776     uint256 private _totalSupply;
777 
778     string private _name;
779     string private _symbol;
780     uint8 private _decimals;
781 
782     /**
783      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
784      * a default value of 18.
785      *
786      * To select a different value for {decimals}, use {_setupDecimals}.
787      *
788      * All three of these values are immutable: they can only be set once during
789      * construction.
790      */
791     constructor (string memory name, string memory symbol) public {
792         _name = name;
793         _symbol = symbol;
794         _decimals = 18;
795     }
796 
797     /**
798      * @dev Returns the name of the token.
799      */
800     function name() public view returns (string memory) {
801         return _name;
802     }
803 
804     /**
805      * @dev Returns the symbol of the token, usually a shorter version of the
806      * name.
807      */
808     function symbol() public view returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev Returns the number of decimals used to get its user representation.
814      * For example, if `decimals` equals `2`, a balance of `505` tokens should
815      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
816      *
817      * Tokens usually opt for a value of 18, imitating the relationship between
818      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
819      * called.
820      *
821      * NOTE: This information is only used for _display_ purposes: it in
822      * no way affects any of the arithmetic of the contract, including
823      * {IERC20-balanceOf} and {IERC20-transfer}.
824      */
825     function decimals() public view returns (uint8) {
826         return _decimals;
827     }
828 
829     /**
830      * @dev See {IERC20-totalSupply}.
831      */
832     function totalSupply() public view override returns (uint256) {
833         return _totalSupply;
834     }
835 
836     /**
837      * @dev See {IERC20-balanceOf}.
838      */
839     function balanceOf(address account) public view override returns (uint256) {
840         return _balances[account];
841     }
842 
843     /**
844      * @dev See {IERC20-transfer}.
845      *
846      * Requirements:
847      *
848      * - `recipient` cannot be the zero address.
849      * - the caller must have a balance of at least `amount`.
850      */
851     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
852         _transfer(_msgSender(), recipient, amount);
853         return true;
854     }
855 
856     /**
857      * @dev See {IERC20-allowance}.
858      */
859     function allowance(address owner, address spender) public view virtual override returns (uint256) {
860         return _allowances[owner][spender];
861     }
862 
863     /**
864      * @dev See {IERC20-approve}.
865      *
866      * Requirements:
867      *
868      * - `spender` cannot be the zero address.
869      */
870     function approve(address spender, uint256 amount) public virtual override returns (bool) {
871         _approve(_msgSender(), spender, amount);
872         return true;
873     }
874 
875     /**
876      * @dev See {IERC20-transferFrom}.
877      *
878      * Emits an {Approval} event indicating the updated allowance. This is not
879      * required by the EIP. See the note at the beginning of {ERC20};
880      *
881      * Requirements:
882      * - `sender` and `recipient` cannot be the zero address.
883      * - `sender` must have a balance of at least `amount`.
884      * - the caller must have allowance for ``sender``'s tokens of at least
885      * `amount`.
886      */
887     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
888         _transfer(sender, recipient, amount);
889         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
890         return true;
891     }
892 
893     /**
894      * @dev Atomically increases the allowance granted to `spender` by the caller.
895      *
896      * This is an alternative to {approve} that can be used as a mitigation for
897      * problems described in {IERC20-approve}.
898      *
899      * Emits an {Approval} event indicating the updated allowance.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      */
905     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
906         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
907         return true;
908     }
909 
910     /**
911      * @dev Atomically decreases the allowance granted to `spender` by the caller.
912      *
913      * This is an alternative to {approve} that can be used as a mitigation for
914      * problems described in {IERC20-approve}.
915      *
916      * Emits an {Approval} event indicating the updated allowance.
917      *
918      * Requirements:
919      *
920      * - `spender` cannot be the zero address.
921      * - `spender` must have allowance for the caller of at least
922      * `subtractedValue`.
923      */
924     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
925         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
926         return true;
927     }
928 
929     /**
930      * @dev Moves tokens `amount` from `sender` to `recipient`.
931      *
932      * This is internal function is equivalent to {transfer}, and can be used to
933      * e.g. implement automatic token fees, slashing mechanisms, etc.
934      *
935      * Emits a {Transfer} event.
936      *
937      * Requirements:
938      *
939      * - `sender` cannot be the zero address.
940      * - `recipient` cannot be the zero address.
941      * - `sender` must have a balance of at least `amount`.
942      */
943     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
944         require(sender != address(0), "ERC20: transfer from the zero address");
945         require(recipient != address(0), "ERC20: transfer to the zero address");
946 
947         _beforeTokenTransfer(sender, recipient, amount);
948 
949         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
950         _balances[recipient] = _balances[recipient].add(amount);
951         emit Transfer(sender, recipient, amount);
952     }
953 
954     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
955      * the total supply.
956      *
957      * Emits a {Transfer} event with `from` set to the zero address.
958      *
959      * Requirements
960      *
961      * - `to` cannot be the zero address.
962      */
963     function _mint(address account, uint256 amount) internal virtual {
964         require(account != address(0), "ERC20: mint to the zero address");
965 
966         _beforeTokenTransfer(address(0), account, amount);
967 
968         _totalSupply = _totalSupply.add(amount);
969         _balances[account] = _balances[account].add(amount);
970         emit Transfer(address(0), account, amount);
971     }
972 
973     /**
974      * @dev Destroys `amount` tokens from `account`, reducing the
975      * total supply.
976      *
977      * Emits a {Transfer} event with `to` set to the zero address.
978      *
979      * Requirements
980      *
981      * - `account` cannot be the zero address.
982      * - `account` must have at least `amount` tokens.
983      */
984     function _burn(address account, uint256 amount) internal virtual {
985         require(account != address(0), "ERC20: burn from the zero address");
986 
987         _beforeTokenTransfer(account, address(0), amount);
988 
989         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
990         _totalSupply = _totalSupply.sub(amount);
991         emit Transfer(account, address(0), amount);
992     }
993 
994     /**
995      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
996      *
997      * This is internal function is equivalent to `approve`, and can be used to
998      * e.g. set automatic allowances for certain subsystems, etc.
999      *
1000      * Emits an {Approval} event.
1001      *
1002      * Requirements:
1003      *
1004      * - `owner` cannot be the zero address.
1005      * - `spender` cannot be the zero address.
1006      */
1007     function _approve(address owner, address spender, uint256 amount) internal virtual {
1008         require(owner != address(0), "ERC20: approve from the zero address");
1009         require(spender != address(0), "ERC20: approve to the zero address");
1010 
1011         _allowances[owner][spender] = amount;
1012         emit Approval(owner, spender, amount);
1013     }
1014 
1015     /**
1016      * @dev Sets {decimals} to a value other than the default one of 18.
1017      *
1018      * WARNING: This function should only be called from the constructor. Most
1019      * applications that interact with token contracts will not expect
1020      * {decimals} to ever change, and may work incorrectly if it does.
1021      */
1022     function _setupDecimals(uint8 decimals_) internal {
1023         _decimals = decimals_;
1024     }
1025 
1026     /**
1027      * @dev Hook that is called before any transfer of tokens. This includes
1028      * minting and burning.
1029      *
1030      * Calling conditions:
1031      *
1032      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1033      * will be to transferred to `to`.
1034      * - when `from` is zero, `amount` tokens will be minted for `to`.
1035      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1036      * - `from` and `to` are never both zero.
1037      *
1038      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1039      */
1040     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1041 }
1042 
1043 
1044 /**
1045  * @dev Contract module which allows children to implement an emergency stop
1046  * mechanism that can be triggered by an authorized account.
1047  *
1048  * This module is used through inheritance. It will make available the
1049  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1050  * the functions of your contract. Note that they will not be pausable by
1051  * simply including this module, only once the modifiers are put in place.
1052  */
1053 contract Pausable is Context {
1054     /**
1055      * @dev Emitted when the pause is triggered by `account`.
1056      */
1057     event Paused(address account);
1058 
1059     /**
1060      * @dev Emitted when the pause is lifted by `account`.
1061      */
1062     event Unpaused(address account);
1063 
1064     bool private _paused;
1065 
1066     /**
1067      * @dev Initializes the contract in unpaused state.
1068      */
1069     constructor () internal {
1070         _paused = false;
1071     }
1072 
1073     /**
1074      * @dev Returns true if the contract is paused, and false otherwise.
1075      */
1076     function paused() public view returns (bool) {
1077         return _paused;
1078     }
1079 
1080     /**
1081      * @dev Modifier to make a function callable only when the contract is not paused.
1082      */
1083     modifier whenNotPaused() {
1084         require(!_paused, "Pausable: paused");
1085         _;
1086     }
1087 
1088     /**
1089      * @dev Modifier to make a function callable only when the contract is paused.
1090      */
1091     modifier whenPaused() {
1092         require(_paused, "Pausable: not paused");
1093         _;
1094     }
1095 
1096     /**
1097      * @dev Triggers stopped state.
1098      */
1099     function _pause() internal virtual whenNotPaused {
1100         _paused = true;
1101         emit Paused(_msgSender());
1102     }
1103 
1104     /**
1105      * @dev Returns to normal state.
1106      */
1107     function _unpause() internal virtual whenPaused {
1108         _paused = false;
1109         emit Unpaused(_msgSender());
1110     }
1111 }
1112 
1113 /**
1114  * @dev ERC20 token with pausable token transfers, minting and burning.
1115  *
1116  * Useful for scenarios such as preventing trades until the end of an evaluation
1117  * period, or having an emergency switch for freezing all token transfers in the
1118  * event of a large bug.
1119  */
1120 abstract contract ERC20Pausable is ERC20, Pausable {
1121     /**
1122      * @dev See {ERC20-_beforeTokenTransfer}.
1123      *
1124      * Requirements:
1125      *
1126      * - the contract must not be paused.
1127      */
1128     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1129         super._beforeTokenTransfer(from, to, amount);
1130 
1131         require(!paused(), "ERC20Pausable: token transfer while paused");
1132     }
1133 }
1134 
1135 
1136 /**
1137  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1138  * tokens and those that they have an allowance for, in a way that can be
1139  * recognized off-chain (via event analysis).
1140  */
1141 abstract contract ERC20Burnable is Context, ERC20 {
1142     /**
1143      * @dev Destroys `amount` tokens from the caller.
1144      *
1145      * See {ERC20-_burn}.
1146      */
1147     function burn(uint256 amount) external {
1148         _burn(_msgSender(), amount);
1149     }
1150 
1151     /**
1152      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1153      * allowance.
1154      *
1155      * See {ERC20-_burn} and {ERC20-allowance}.
1156      *
1157      * Requirements:
1158      *
1159      * - the caller must have allowance for ``accounts``'s tokens of at least
1160      * `amount`.
1161      */
1162     function burnFrom(address account, uint256 amount) external {
1163         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1164 
1165         _approve(account, _msgSender(), decreasedAllowance);
1166         _burn(account, amount);
1167     }
1168 }
1169 
1170 /**
1171  * @dev {ERC20} token, including:
1172  *
1173  *  - ability for holders to burn (destroy) their tokens
1174  *  - a minter role that allows for token minting (creation)
1175  *  - a pauser role that allows to stop all token transfers
1176  *
1177  * This contract uses {AccessControl} to lock permissioned functions using the
1178  * different roles - head to its documentation for details.
1179  *
1180  * The account that deploys the contract will be granted the minter and pauser
1181  * roles, as well as the default admin role, which will let it grant both minter
1182  * and pauser roles to other accounts.
1183  */
1184 contract FetchToken is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1185     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1186     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1187 
1188     /**
1189      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1190      * account that deploys the contract.
1191      *
1192      * See {ERC20-constructor}.
1193      */
1194 
1195 
1196     modifier onlyMinter {
1197         require(hasRole(MINTER_ROLE, _msgSender()), "signer must have minter role to mint");
1198         _; 
1199         }
1200 
1201     modifier onlyPauser {
1202         require(hasRole(PAUSER_ROLE, _msgSender()), "signer must have pauser role to pause/unpause");
1203         _; 
1204         }
1205 
1206 
1207     constructor(string memory name, 
1208                 string memory symbol, 
1209                 uint256 _initialSupply) public ERC20(name, symbol) {
1210         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1211 
1212         _setupRole(MINTER_ROLE, _msgSender());
1213         _setupRole(PAUSER_ROLE, _msgSender());
1214         _mint(_msgSender(), _initialSupply); 
1215     }
1216 
1217     /**
1218      * @dev Creates `amount` new tokens for `to`.
1219      *
1220      * See {ERC20-_mint}.
1221      *
1222      * Requirements:
1223      *
1224      * - the caller must have the `MINTER_ROLE`.
1225      */
1226     function mint(address to, uint256 amount) onlyMinter external {
1227         _mint(to, amount);
1228     }
1229 
1230     /**
1231      * @dev Pauses all token transfers.
1232      *
1233      * See {ERC20Pausable} and {Pausable-_pause}.
1234      *
1235      * Requirements:
1236      *
1237      * - the caller must have the `PAUSER_ROLE`.
1238      */
1239     function pause() onlyPauser external {
1240         _pause();
1241     }
1242 
1243     /**
1244      * @dev Unpauses all token transfers.
1245      *
1246      * See {ERC20Pausable} and {Pausable-_unpause}.
1247      *
1248      * Requirements:
1249      *
1250      * - the caller must have the `PAUSER_ROLE`.
1251      */
1252     function unpause() onlyPauser external {
1253         _unpause();
1254     }
1255 
1256     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Pausable) {
1257         super._beforeTokenTransfer(from, to, amount);
1258     }
1259 }