1 // contracts/BTSE-ERC20.sol
2 pragma solidity ^0.6.0;
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
119     /**
120      * @dev Returns the value stored at position `index` in the set. O(1).
121      *
122      * Note that there are no guarantees on the ordering of values inside the
123      * array, and it may change when more values are added or removed.
124      *
125      * Requirements:
126      *
127      * - `index` must be strictly less than {length}.
128      */
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
174     /**
175      * @dev Returns the value stored at position `index` in the set. O(1).
176      *
177      * Note that there are no guarantees on the ordering of values inside the
178      * array, and it may change when more values are added or removed.
179      *
180      * Requirements:
181      *
182      * - `index` must be strictly less than {length}.
183      */
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
229     /**
230      * @dev Returns the value stored at position `index` in the set. O(1).
231      *
232      * Note that there are no guarantees on the ordering of values inside the
233      * array, and it may change when more values are added or removed.
234      *
235      * Requirements:
236      *
237      * - `index` must be strictly less than {length}.
238      */
239     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
240         return uint256(_at(set._inner, index));
241     }
242 }
243 
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
302 /**
303  * @dev Wrappers over Solidity's arithmetic operations with added overflow
304  * checks.
305  *
306  * Arithmetic operations in Solidity wrap on overflow. This can easily result
307  * in bugs, because programmers usually assume that an overflow raises an
308  * error, which is the standard behavior in high level programming languages.
309  * `SafeMath` restores this intuition by reverting the transaction when an
310  * operation overflows.
311  *
312  * Using this library instead of the unchecked operations eliminates an entire
313  * class of bugs, so it's recommended to use it always.
314  */
315 library SafeMath {
316     /**
317      * @dev Returns the addition of two unsigned integers, reverting on
318      * overflow.
319      *
320      * Counterpart to Solidity's `+` operator.
321      *
322      * Requirements:
323      * - Addition cannot overflow.
324      */
325     function add(uint256 a, uint256 b) internal pure returns (uint256) {
326         uint256 c = a + b;
327         require(c >= a, "SafeMath: addition overflow");
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the subtraction of two unsigned integers, reverting on
334      * overflow (when the result is negative).
335      *
336      * Counterpart to Solidity's `-` operator.
337      *
338      * Requirements:
339      * - Subtraction cannot overflow.
340      */
341     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
342         return sub(a, b, "SafeMath: subtraction overflow");
343     }
344 
345     /**
346      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
347      * overflow (when the result is negative).
348      *
349      * Counterpart to Solidity's `-` operator.
350      *
351      * Requirements:
352      * - Subtraction cannot overflow.
353      */
354     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
355         require(b <= a, errorMessage);
356         uint256 c = a - b;
357 
358         return c;
359     }
360 
361     /**
362      * @dev Returns the multiplication of two unsigned integers, reverting on
363      * overflow.
364      *
365      * Counterpart to Solidity's `*` operator.
366      *
367      * Requirements:
368      * - Multiplication cannot overflow.
369      */
370     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
371         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
372         // benefit is lost if 'b' is also tested.
373         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
374         if (a == 0) {
375             return 0;
376         }
377 
378         uint256 c = a * b;
379         require(c / a == b, "SafeMath: multiplication overflow");
380 
381         return c;
382     }
383 
384     /**
385      * @dev Returns the integer division of two unsigned integers. Reverts on
386      * division by zero. The result is rounded towards zero.
387      *
388      * Counterpart to Solidity's `/` operator. Note: this function uses a
389      * `revert` opcode (which leaves remaining gas untouched) while Solidity
390      * uses an invalid opcode to revert (consuming all remaining gas).
391      *
392      * Requirements:
393      * - The divisor cannot be zero.
394      */
395     function div(uint256 a, uint256 b) internal pure returns (uint256) {
396         return div(a, b, "SafeMath: division by zero");
397     }
398 
399     /**
400      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
401      * division by zero. The result is rounded towards zero.
402      *
403      * Counterpart to Solidity's `/` operator. Note: this function uses a
404      * `revert` opcode (which leaves remaining gas untouched) while Solidity
405      * uses an invalid opcode to revert (consuming all remaining gas).
406      *
407      * Requirements:
408      * - The divisor cannot be zero.
409      */
410     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
411         // Solidity only automatically asserts when dividing by 0
412         require(b > 0, errorMessage);
413         uint256 c = a / b;
414         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
415 
416         return c;
417     }
418 
419     /**
420      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
421      * Reverts when dividing by zero.
422      *
423      * Counterpart to Solidity's `%` operator. This function uses a `revert`
424      * opcode (which leaves remaining gas untouched) while Solidity uses an
425      * invalid opcode to revert (consuming all remaining gas).
426      *
427      * Requirements:
428      * - The divisor cannot be zero.
429      */
430     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
431         return mod(a, b, "SafeMath: modulo by zero");
432     }
433 
434     /**
435      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
436      * Reverts with custom message when dividing by zero.
437      *
438      * Counterpart to Solidity's `%` operator. This function uses a `revert`
439      * opcode (which leaves remaining gas untouched) while Solidity uses an
440      * invalid opcode to revert (consuming all remaining gas).
441      *
442      * Requirements:
443      * - The divisor cannot be zero.
444      */
445     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
446         require(b != 0, errorMessage);
447         return a % b;
448     }
449 }
450 
451 
452 /**
453  * @dev Interface of the ERC20 standard as defined in the EIP.
454  */
455 interface IERC20 {
456     /**
457      * @dev Returns the amount of tokens in existence.
458      */
459     function totalSupply() external view returns (uint256);
460 
461     /**
462      * @dev Returns the amount of tokens owned by `account`.
463      */
464     function balanceOf(address account) external view returns (uint256);
465 
466     /**
467      * @dev Moves `amount` tokens from the caller's account to `recipient`.
468      *
469      * Returns a boolean value indicating whether the operation succeeded.
470      *
471      * Emits a {Transfer} event.
472      */
473     function transfer(address recipient, uint256 amount) external returns (bool);
474 
475     /**
476      * @dev Returns the remaining number of tokens that `spender` will be
477      * allowed to spend on behalf of `owner` through {transferFrom}. This is
478      * zero by default.
479      *
480      * This value changes when {approve} or {transferFrom} are called.
481      */
482     function allowance(address owner, address spender) external view returns (uint256);
483 
484     /**
485      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
486      *
487      * Returns a boolean value indicating whether the operation succeeded.
488      *
489      * IMPORTANT: Beware that changing an allowance with this method brings the risk
490      * that someone may use both the old and the new allowance by unfortunate
491      * transaction ordering. One possible solution to mitigate this race
492      * condition is to first reduce the spender's allowance to 0 and set the
493      * desired value afterwards:
494      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
495      *
496      * Emits an {Approval} event.
497      */
498     function approve(address spender, uint256 amount) external returns (bool);
499 
500     /**
501      * @dev Moves `amount` tokens from `sender` to `recipient` using the
502      * allowance mechanism. `amount` is then deducted from the caller's
503      * allowance.
504      *
505      * Returns a boolean value indicating whether the operation succeeded.
506      *
507      * Emits a {Transfer} event.
508      */
509     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
510 
511     /**
512      * @dev Emitted when `value` tokens are moved from one account (`from`) to
513      * another (`to`).
514      *
515      * Note that `value` may be zero.
516      */
517     event Transfer(address indexed from, address indexed to, uint256 value);
518 
519     /**
520      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
521      * a call to {approve}. `value` is the new allowance.
522      */
523     event Approval(address indexed owner, address indexed spender, uint256 value);
524 }
525 
526 
527 /**
528  * @title Initializable
529  *
530  * @dev Helper contract to support initializer functions. To use it, replace
531  * the constructor with a function that has the `initializer` modifier.
532  * WARNING: Unlike constructors, initializer functions must be manually
533  * invoked. This applies both to deploying an Initializable contract, as well
534  * as extending an Initializable contract via inheritance.
535  * WARNING: When used with inheritance, manual care must be taken to not invoke
536  * a parent initializer twice, or ensure that all initializers are idempotent,
537  * because this is not dealt with automatically as with constructors.
538  */
539 contract Initializable {
540 
541     /**
542      * @dev Indicates that the contract has been initialized.
543      */
544     bool private initialized;
545 
546     /**
547      * @dev Indicates that the contract is in the process of being initialized.
548      */
549     bool private initializing;
550 
551     /**
552      * @dev Modifier to use in the initializer function of a contract.
553      */
554     modifier initializer() {
555         require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
556 
557         bool isTopLevelCall = !initializing;
558         if (isTopLevelCall) {
559             initializing = true;
560             initialized = true;
561         }
562 
563         _;
564 
565         if (isTopLevelCall) {
566             initializing = false;
567         }
568     }
569 
570     /// @dev Returns true if and only if the function is running in the constructor
571     function isConstructor() private view returns (bool) {
572         // extcodesize checks the size of the code stored in an address, and
573         // address returns the current address. Since the code is still not
574         // deployed when running a constructor, any checks on its code size will
575         // yield zero, making it an effective way to detect if a contract is
576         // under construction or not.
577         address self = address(this);
578         uint256 cs;
579         assembly { cs := extcodesize(self) }
580         return cs == 0;
581     }
582 
583     // Reserved storage space to allow for layout changes in the future.
584     uint256[50] private ______gap;
585 }
586 
587 /*
588  * @dev Provides information about the current execution context, including the
589  * sender of the transaction and its data. While these are generally available
590  * via msg.sender and msg.data, they should not be accessed in such a direct
591  * manner, since when dealing with GSN meta-transactions the account sending and
592  * paying for execution may not be the actual sender (as far as an application
593  * is concerned).
594  *
595  * This contract is only required for intermediate, library-like contracts.
596  */
597 contract ContextUpgradeSafe is Initializable {
598     // Empty internal constructor, to prevent people from mistakenly deploying
599     // an instance of this contract, which should be used via inheritance.
600 
601     function __Context_init() internal initializer {
602         __Context_init_unchained();
603     }
604 
605     function __Context_init_unchained() internal initializer {
606 
607 
608     }
609 
610 
611     function _msgSender() internal view virtual returns (address payable) {
612         return msg.sender;
613     }
614 
615     function _msgData() internal view virtual returns (bytes memory) {
616         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
617         return msg.data;
618     }
619 
620     uint256[50] private __gap;
621 }
622 
623 /**
624  * @dev Contract module that allows children to implement role-based access
625  * control mechanisms.
626  *
627  * Roles are referred to by their `bytes32` identifier. These should be exposed
628  * in the external API and be unique. The best way to achieve this is by
629  * using `public constant` hash digests:
630  *
631  * ```
632  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
633  * ```
634  *
635  * Roles can be used to represent a set of permissions. To restrict access to a
636  * function call, use {hasRole}:
637  *
638  * ```
639  * function foo() public {
640  *     require(hasRole(MY_ROLE, _msgSender()));
641  *     ...
642  * }
643  * ```
644  *
645  * Roles can be granted and revoked dynamically via the {grantRole} and
646  * {revokeRole} functions. Each role has an associated admin role, and only
647  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
648  *
649  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
650  * that only accounts with this role will be able to grant or revoke other
651  * roles. More complex role relationships can be created by using
652  * {_setRoleAdmin}.
653  */
654 abstract contract AccessControlUpgradeSafe is Initializable, ContextUpgradeSafe {
655     function __AccessControl_init() internal initializer {
656         __Context_init_unchained();
657         __AccessControl_init_unchained();
658     }
659 
660     function __AccessControl_init_unchained() internal initializer {
661 
662 
663     }
664 
665     using EnumerableSet for EnumerableSet.AddressSet;
666     using Address for address;
667 
668     struct RoleData {
669         EnumerableSet.AddressSet members;
670         bytes32 adminRole;
671     }
672 
673     mapping (bytes32 => RoleData) private _roles;
674 
675     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
676 
677     /**
678      * @dev Emitted when `account` is granted `role`.
679      *
680      * `sender` is the account that originated the contract call, an admin role
681      * bearer except when using {_setupRole}.
682      */
683     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
684 
685     /**
686      * @dev Emitted when `account` is revoked `role`.
687      *
688      * `sender` is the account that originated the contract call:
689      *   - if using `revokeRole`, it is the admin role bearer
690      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
691      */
692     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
693 
694     /**
695      * @dev Returns `true` if `account` has been granted `role`.
696      */
697     function hasRole(bytes32 role, address account) public view returns (bool) {
698         return _roles[role].members.contains(account);
699     }
700 
701     /**
702      * @dev Returns the number of accounts that have `role`. Can be used
703      * together with {getRoleMember} to enumerate all bearers of a role.
704      */
705     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
706         return _roles[role].members.length();
707     }
708 
709     /**
710      * @dev Returns one of the accounts that have `role`. `index` must be a
711      * value between 0 and {getRoleMemberCount}, non-inclusive.
712      *
713      * Role bearers are not sorted in any particular way, and their ordering may
714      * change at any point.
715      *
716      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
717      * you perform all queries on the same block. See the following
718      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
719      * for more information.
720      */
721     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
722         return _roles[role].members.at(index);
723     }
724 
725     /**
726      * @dev Returns the admin role that controls `role`. See {grantRole} and
727      * {revokeRole}.
728      *
729      * To change a role's admin, use {_setRoleAdmin}.
730      */
731     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
732         return _roles[role].adminRole;
733     }
734 
735     /**
736      * @dev Grants `role` to `account`.
737      *
738      * If `account` had not been already granted `role`, emits a {RoleGranted}
739      * event.
740      *
741      * Requirements:
742      *
743      * - the caller must have ``role``'s admin role.
744      */
745     function grantRole(bytes32 role, address account) public virtual {
746         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
747 
748         _grantRole(role, account);
749     }
750 
751     /**
752      * @dev Revokes `role` from `account`.
753      *
754      * If `account` had been granted `role`, emits a {RoleRevoked} event.
755      *
756      * Requirements:
757      *
758      * - the caller must have ``role``'s admin role.
759      */
760     function revokeRole(bytes32 role, address account) public virtual {
761         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
762 
763         _revokeRole(role, account);
764     }
765 
766     /**
767      * @dev Revokes `role` from the calling account.
768      *
769      * Roles are often managed via {grantRole} and {revokeRole}: this function's
770      * purpose is to provide a mechanism for accounts to lose their privileges
771      * if they are compromised (such as when a trusted device is misplaced).
772      *
773      * If the calling account had been granted `role`, emits a {RoleRevoked}
774      * event.
775      *
776      * Requirements:
777      *
778      * - the caller must be `account`.
779      */
780     function renounceRole(bytes32 role, address account) public virtual {
781         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
782 
783         _revokeRole(role, account);
784     }
785 
786     /**
787      * @dev Grants `role` to `account`.
788      *
789      * If `account` had not been already granted `role`, emits a {RoleGranted}
790      * event. Note that unlike {grantRole}, this function doesn't perform any
791      * checks on the calling account.
792      *
793      * [WARNING]
794      * ====
795      * This function should only be called from the constructor when setting
796      * up the initial roles for the system.
797      *
798      * Using this function in any other way is effectively circumventing the admin
799      * system imposed by {AccessControl}.
800      * ====
801      */
802     function _setupRole(bytes32 role, address account) internal virtual {
803         _grantRole(role, account);
804     }
805 
806     /**
807      * @dev Sets `adminRole` as ``role``'s admin role.
808      */
809     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
810         _roles[role].adminRole = adminRole;
811     }
812 
813     function _grantRole(bytes32 role, address account) private {
814         if (_roles[role].members.add(account)) {
815             emit RoleGranted(role, account, _msgSender());
816         }
817     }
818 
819     function _revokeRole(bytes32 role, address account) private {
820         if (_roles[role].members.remove(account)) {
821             emit RoleRevoked(role, account, _msgSender());
822         }
823     }
824 
825     uint256[49] private __gap;
826 }
827 
828 
829 /**
830  * @dev Contract module which allows children to implement an emergency stop
831  * mechanism that can be triggered by an authorized account.
832  *
833  * This module is used through inheritance. It will make available the
834  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
835  * the functions of your contract. Note that they will not be pausable by
836  * simply including this module, only once the modifiers are put in place.
837  */
838 contract PausableUpgradeSafe is Initializable, ContextUpgradeSafe {
839     /**
840      * @dev Emitted when the pause is triggered by `account`.
841      */
842     event Paused(address account);
843 
844     /**
845      * @dev Emitted when the pause is lifted by `account`.
846      */
847     event Unpaused(address account);
848 
849     bool private _paused;
850 
851     /**
852      * @dev Initializes the contract in unpaused state.
853      */
854 
855     function __Pausable_init() internal initializer {
856         __Context_init_unchained();
857         __Pausable_init_unchained();
858     }
859 
860     function __Pausable_init_unchained() internal initializer {
861 
862 
863         _paused = false;
864 
865     }
866 
867 
868     /**
869      * @dev Returns true if the contract is paused, and false otherwise.
870      */
871     function paused() public view returns (bool) {
872         return _paused;
873     }
874 
875     /**
876      * @dev Modifier to make a function callable only when the contract is not paused.
877      */
878     modifier whenNotPaused() {
879         require(!_paused, "Pausable: paused");
880         _;
881     }
882 
883     /**
884      * @dev Modifier to make a function callable only when the contract is paused.
885      */
886     modifier whenPaused() {
887         require(_paused, "Pausable: not paused");
888         _;
889     }
890 
891     /**
892      * @dev Triggers stopped state.
893      */
894     function _pause() internal virtual whenNotPaused {
895         _paused = true;
896         emit Paused(_msgSender());
897     }
898 
899     /**
900      * @dev Returns to normal state.
901      */
902     function _unpause() internal virtual whenPaused {
903         _paused = false;
904         emit Unpaused(_msgSender());
905     }
906 
907     uint256[49] private __gap;
908 }
909 
910 /**
911  * @dev Implementation of the {IERC20} interface.
912  *
913  * This implementation is agnostic to the way tokens are created. This means
914  * that a supply mechanism has to be added in a derived contract using {_mint}.
915  * For a generic mechanism see {ERC20MinterPauser}.
916  *
917  * TIP: For a detailed writeup see our guide
918  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
919  * to implement supply mechanisms].
920  *
921  * We have followed general OpenZeppelin guidelines: functions revert instead
922  * of returning `false` on failure. This behavior is nonetheless conventional
923  * and does not conflict with the expectations of ERC20 applications.
924  *
925  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
926  * This allows applications to reconstruct the allowance for all accounts just
927  * by listening to said events. Other implementations of the EIP may not emit
928  * these events, as it isn't required by the specification.
929  *
930  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
931  * functions have been added to mitigate the well-known issues around setting
932  * allowances. See {IERC20-approve}.
933  */
934 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
935     using SafeMath for uint256;
936     using Address for address;
937 
938     mapping (address => uint256) private _balances;
939 
940     mapping (address => mapping (address => uint256)) private _allowances;
941 
942     uint256 private _totalSupply;
943 
944     string private _name;
945     string private _symbol;
946     uint8 private _decimals;
947 
948     /**
949      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
950      * a default value of 18.
951      *
952      * To select a different value for {decimals}, use {_setupDecimals}.
953      *
954      * All three of these values are immutable: they can only be set once during
955      * construction.
956      */
957 
958     function __ERC20_init(string memory name, string memory symbol) internal initializer {
959         __Context_init_unchained();
960         __ERC20_init_unchained(name, symbol);
961     }
962 
963     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
964 
965 
966         _name = name;
967         _symbol = symbol;
968         _decimals = 18;
969 
970     }
971 
972 
973     /**
974      * @dev Returns the name of the token.
975      */
976     function name() public view returns (string memory) {
977         return _name;
978     }
979 
980     /**
981      * @dev Returns the symbol of the token, usually a shorter version of the
982      * name.
983      */
984     function symbol() public view returns (string memory) {
985         return _symbol;
986     }
987 
988     /**
989      * @dev Returns the number of decimals used to get its user representation.
990      * For example, if `decimals` equals `2`, a balance of `505` tokens should
991      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
992      *
993      * Tokens usually opt for a value of 18, imitating the relationship between
994      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
995      * called.
996      *
997      * NOTE: This information is only used for _display_ purposes: it in
998      * no way affects any of the arithmetic of the contract, including
999      * {IERC20-balanceOf} and {IERC20-transfer}.
1000      */
1001     function decimals() public view returns (uint8) {
1002         return _decimals;
1003     }
1004 
1005     /**
1006      * @dev See {IERC20-totalSupply}.
1007      */
1008     function totalSupply() public view override returns (uint256) {
1009         return _totalSupply;
1010     }
1011 
1012     /**
1013      * @dev See {IERC20-balanceOf}.
1014      */
1015     function balanceOf(address account) public view override returns (uint256) {
1016         return _balances[account];
1017     }
1018 
1019     /**
1020      * @dev See {IERC20-transfer}.
1021      *
1022      * Requirements:
1023      *
1024      * - `recipient` cannot be the zero address.
1025      * - the caller must have a balance of at least `amount`.
1026      */
1027     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1028         _transfer(_msgSender(), recipient, amount);
1029         return true;
1030     }
1031 
1032     /**
1033      * @dev See {IERC20-allowance}.
1034      */
1035     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1036         return _allowances[owner][spender];
1037     }
1038 
1039     /**
1040      * @dev See {IERC20-approve}.
1041      *
1042      * Requirements:
1043      *
1044      * - `spender` cannot be the zero address.
1045      */
1046     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1047         _approve(_msgSender(), spender, amount);
1048         return true;
1049     }
1050 
1051     /**
1052      * @dev See {IERC20-transferFrom}.
1053      *
1054      * Emits an {Approval} event indicating the updated allowance. This is not
1055      * required by the EIP. See the note at the beginning of {ERC20};
1056      *
1057      * Requirements:
1058      * - `sender` and `recipient` cannot be the zero address.
1059      * - `sender` must have a balance of at least `amount`.
1060      * - the caller must have allowance for ``sender``'s tokens of at least
1061      * `amount`.
1062      */
1063     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1064         _transfer(sender, recipient, amount);
1065         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1066         return true;
1067     }
1068 
1069     /**
1070      * @dev Atomically increases the allowance granted to `spender` by the caller.
1071      *
1072      * This is an alternative to {approve} that can be used as a mitigation for
1073      * problems described in {IERC20-approve}.
1074      *
1075      * Emits an {Approval} event indicating the updated allowance.
1076      *
1077      * Requirements:
1078      *
1079      * - `spender` cannot be the zero address.
1080      */
1081     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1082         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1083         return true;
1084     }
1085 
1086     /**
1087      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1088      *
1089      * This is an alternative to {approve} that can be used as a mitigation for
1090      * problems described in {IERC20-approve}.
1091      *
1092      * Emits an {Approval} event indicating the updated allowance.
1093      *
1094      * Requirements:
1095      *
1096      * - `spender` cannot be the zero address.
1097      * - `spender` must have allowance for the caller of at least
1098      * `subtractedValue`.
1099      */
1100     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1101         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1102         return true;
1103     }
1104 
1105     /**
1106      * @dev Moves tokens `amount` from `sender` to `recipient`.
1107      *
1108      * This is internal function is equivalent to {transfer}, and can be used to
1109      * e.g. implement automatic token fees, slashing mechanisms, etc.
1110      *
1111      * Emits a {Transfer} event.
1112      *
1113      * Requirements:
1114      *
1115      * - `sender` cannot be the zero address.
1116      * - `recipient` cannot be the zero address.
1117      * - `sender` must have a balance of at least `amount`.
1118      */
1119     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1120         require(sender != address(0), "ERC20: transfer from the zero address");
1121         require(recipient != address(0), "ERC20: transfer to the zero address");
1122 
1123         _beforeTokenTransfer(sender, recipient, amount);
1124 
1125         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1126         _balances[recipient] = _balances[recipient].add(amount);
1127         emit Transfer(sender, recipient, amount);
1128     }
1129 
1130     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1131      * the total supply.
1132      *
1133      * Emits a {Transfer} event with `from` set to the zero address.
1134      *
1135      * Requirements
1136      *
1137      * - `to` cannot be the zero address.
1138      */
1139     function _mint(address account, uint256 amount) internal virtual {
1140         require(account != address(0), "ERC20: mint to the zero address");
1141 
1142         _beforeTokenTransfer(address(0), account, amount);
1143 
1144         _totalSupply = _totalSupply.add(amount);
1145         _balances[account] = _balances[account].add(amount);
1146         emit Transfer(address(0), account, amount);
1147     }
1148 
1149     /**
1150      * @dev Destroys `amount` tokens from `account`, reducing the
1151      * total supply.
1152      *
1153      * Emits a {Transfer} event with `to` set to the zero address.
1154      *
1155      * Requirements
1156      *
1157      * - `account` cannot be the zero address.
1158      * - `account` must have at least `amount` tokens.
1159      */
1160     function _burn(address account, uint256 amount) internal virtual {
1161         require(account != address(0), "ERC20: burn from the zero address");
1162 
1163         _beforeTokenTransfer(account, address(0), amount);
1164 
1165         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1166         _totalSupply = _totalSupply.sub(amount);
1167         emit Transfer(account, address(0), amount);
1168     }
1169 
1170     /**
1171      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1172      *
1173      * This is internal function is equivalent to `approve`, and can be used to
1174      * e.g. set automatic allowances for certain subsystems, etc.
1175      *
1176      * Emits an {Approval} event.
1177      *
1178      * Requirements:
1179      *
1180      * - `owner` cannot be the zero address.
1181      * - `spender` cannot be the zero address.
1182      */
1183     function _approve(address owner, address spender, uint256 amount) internal virtual {
1184         require(owner != address(0), "ERC20: approve from the zero address");
1185         require(spender != address(0), "ERC20: approve to the zero address");
1186 
1187         _allowances[owner][spender] = amount;
1188         emit Approval(owner, spender, amount);
1189     }
1190 
1191     /**
1192      * @dev Sets {decimals} to a value other than the default one of 18.
1193      *
1194      * WARNING: This function should only be called from the constructor. Most
1195      * applications that interact with token contracts will not expect
1196      * {decimals} to ever change, and may work incorrectly if it does.
1197      */
1198     function _setupDecimals(uint8 decimals_) internal {
1199         _decimals = decimals_;
1200     }
1201 
1202     /**
1203      * @dev Hook that is called before any transfer of tokens. This includes
1204      * minting and burning.
1205      *
1206      * Calling conditions:
1207      *
1208      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1209      * will be to transferred to `to`.
1210      * - when `from` is zero, `amount` tokens will be minted for `to`.
1211      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1212      * - `from` and `to` are never both zero.
1213      *
1214      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1215      */
1216     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1217 
1218     uint256[44] private __gap;
1219 }
1220 
1221 /**
1222  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1223  * tokens and those that they have an allowance for, in a way that can be
1224  * recognized off-chain (via event analysis).
1225  */
1226 abstract contract ERC20BurnableUpgradeSafe is Initializable, ContextUpgradeSafe, ERC20UpgradeSafe {
1227     function __ERC20Burnable_init() internal initializer {
1228         __Context_init_unchained();
1229         __ERC20Burnable_init_unchained();
1230     }
1231 
1232     function __ERC20Burnable_init_unchained() internal initializer {
1233 
1234 
1235     }
1236 
1237     /**
1238      * @dev Destroys `amount` tokens from the caller.
1239      *
1240      * See {ERC20-_burn}.
1241      */
1242     function burn(uint256 amount) public virtual {
1243         _burn(_msgSender(), amount);
1244     }
1245 
1246     /**
1247      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1248      * allowance.
1249      *
1250      * See {ERC20-_burn} and {ERC20-allowance}.
1251      *
1252      * Requirements:
1253      *
1254      * - the caller must have allowance for ``accounts``'s tokens of at least
1255      * `amount`.
1256      */
1257     function burnFrom(address account, uint256 amount) public virtual {
1258         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1259 
1260         _approve(account, _msgSender(), decreasedAllowance);
1261         _burn(account, amount);
1262     }
1263 
1264     uint256[50] private __gap;
1265 }
1266 
1267 
1268 /**
1269  * @dev ERC20 token with pausable token transfers, minting and burning.
1270  *
1271  * Useful for scenarios such as preventing trades until the end of an evaluation
1272  * period, or having an emergency switch for freezing all token transfers in the
1273  * event of a large bug.
1274  */
1275 abstract contract ERC20PausableUpgradeSafe is Initializable, ERC20UpgradeSafe, PausableUpgradeSafe {
1276     function __ERC20Pausable_init() internal initializer {
1277         __Context_init_unchained();
1278         __Pausable_init_unchained();
1279         __ERC20Pausable_init_unchained();
1280     }
1281 
1282     function __ERC20Pausable_init_unchained() internal initializer {
1283 
1284 
1285     }
1286 
1287     /**
1288      * @dev See {ERC20-_beforeTokenTransfer}.
1289      *
1290      * Requirements:
1291      *
1292      * - the contract must not be paused.
1293      */
1294     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1295         super._beforeTokenTransfer(from, to, amount);
1296 
1297         require(!paused(), "ERC20Pausable: token transfer while paused");
1298     }
1299 
1300     uint256[50] private __gap;
1301 }
1302 
1303 contract BTSE is Initializable, ContextUpgradeSafe, AccessControlUpgradeSafe, ERC20BurnableUpgradeSafe, ERC20PausableUpgradeSafe {
1304     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1305     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1306     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
1307 
1308 
1309     function initialize(string memory name, string memory symbol, address admin) public {
1310         __BTSE_init(name, symbol, admin);
1311     }
1312 
1313     function __BTSE_init(string memory name, string memory symbol, address admin) internal initializer {
1314         __Context_init_unchained();
1315         __AccessControl_init_unchained();
1316         __ERC20_init_unchained(name, symbol);
1317         __ERC20Burnable_init_unchained();
1318         __Pausable_init_unchained();
1319         __ERC20Pausable_init_unchained();
1320         __BTSE_init_unchained(name, symbol, admin);
1321     }
1322 
1323     function __BTSE_init_unchained(string memory name, string memory symbol, address admin) internal initializer {
1324 
1325         _setupRole(DEFAULT_ADMIN_ROLE, admin);
1326         _setupRole(MINTER_ROLE, admin);
1327         _setupRole(BURNER_ROLE, admin);
1328         _setupRole(PAUSER_ROLE, admin);
1329 
1330         _setupDecimals(8);
1331     }
1332 
1333     /**
1334     * @dev Destroys `amount` tokens for `from`.
1335     *
1336     * See {ERC20-_burn}.
1337     *
1338     * Requirements:
1339     *
1340     * - the caller must have the `BURNER_ROLE`.
1341     */
1342     function burn(address from, uint256 amount) public {
1343         require(hasRole(BURNER_ROLE, msg.sender), "BTSE: must have burner role to burn"); // _msgSender() ?
1344         _burn(from, amount);
1345     }
1346 
1347     /**
1348      * @dev Creates `amount` new tokens for `to`.
1349      *
1350      * See {ERC20-_mint}.
1351      *
1352      * Requirements:
1353      *
1354      * - the caller must have the `MINTER_ROLE`.
1355      */
1356     function mint(address to, uint256 amount) public {
1357         require(hasRole(MINTER_ROLE, msg.sender), "BTSE: must have minter role to mint");
1358         _mint(to, amount);
1359     }
1360 
1361     /**
1362      * @dev Pauses all token transfers.
1363      *
1364      * See {ERC20Pausable} and {Pausable-_pause}.
1365      *
1366      * Requirements:
1367      *
1368      * - the caller must have the `PAUSER_ROLE`.
1369      */
1370     function pause() public {
1371         require(hasRole(PAUSER_ROLE, msg.sender), "BTSE: must have pauser role to pause");
1372         _pause();
1373     }
1374 
1375     /**
1376      * @dev Unpauses all token transfers.
1377      *
1378      * See {ERC20Pausable} and {Pausable-_unpause}.
1379      *
1380      * Requirements:
1381      *
1382      * - the caller must have the `PAUSER_ROLE`.
1383      */
1384     function unpause() public {
1385         require(hasRole(PAUSER_ROLE, msg.sender), "BTSE: must have pauser role to unpause");
1386         _unpause();
1387     }
1388 
1389     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20UpgradeSafe, ERC20PausableUpgradeSafe) {
1390         super._beforeTokenTransfer(from, to, amount);
1391     }
1392 }