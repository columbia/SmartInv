1 pragma solidity ^0.6.0;
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
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 
25 
26 // File: contracts/utils/EnumerableSet.sol
27 
28 // SPDX-License-Identifier: MIT
29 
30 pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Library for managing
34  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
35  * types.
36  *
37  * Sets have the following properties:
38  *
39  * - Elements are added, removed, and checked for existence in constant time
40  * (O(1)).
41  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
42  *
43  * ```
44  * contract Example {
45  *     // Add the library methods
46  *     using EnumerableSet for EnumerableSet.AddressSet;
47  *
48  *     // Declare a set state variable
49  *     EnumerableSet.AddressSet private mySet;
50  * }
51  * ```
52  *
53  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
54  * (`UintSet`) are supported.
55  */
56 library EnumerableSet {
57     // To implement this library for multiple types with as little code
58     // repetition as possible, we write it in terms of a generic Set type with
59     // bytes32 values.
60     // The Set implementation uses private functions, and user-facing
61     // implementations (such as AddressSet) are just wrappers around the
62     // underlying Set.
63     // This means that we can only create new EnumerableSets for types that fit
64     // in bytes32.
65 
66     struct Set {
67         // Storage of set values
68         bytes32[] _values;
69 
70         // Position of the value in the `values` array, plus 1 because index 0
71         // means a value is not in the set.
72         mapping (bytes32 => uint256) _indexes;
73     }
74 
75     /**
76      * @dev Add a value to a set. O(1).
77      *
78      * Returns true if the value was added to the set, that is if it was not
79      * already present.
80      */
81     function _add(Set storage set, bytes32 value) private returns (bool) {
82         if (!_contains(set, value)) {
83             set._values.push(value);
84             // The value is stored at length-1, but we add 1 to all indexes
85             // and use 0 as a sentinel value
86             set._indexes[value] = set._values.length;
87             return true;
88         } else {
89             return false;
90         }
91     }
92 
93     /**
94      * @dev Removes a value from a set. O(1).
95      *
96      * Returns true if the value was removed from the set, that is if it was
97      * present.
98      */
99     function _remove(Set storage set, bytes32 value) private returns (bool) {
100         // We read and store the value's index to prevent multiple reads from the same storage slot
101         uint256 valueIndex = set._indexes[value];
102 
103         if (valueIndex != 0) { // Equivalent to contains(set, value)
104             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
105             // the array, and then remove the last element (sometimes called as 'swap and pop').
106             // This modifies the order of the array, as noted in {at}.
107 
108             uint256 toDeleteIndex = valueIndex - 1;
109             uint256 lastIndex = set._values.length - 1;
110 
111             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
112             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
113 
114             bytes32 lastvalue = set._values[lastIndex];
115 
116             // Move the last value to the index where the value to delete is
117             set._values[toDeleteIndex] = lastvalue;
118             // Update the index for the moved value
119             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
120 
121             // Delete the slot where the moved value was stored
122             set._values.pop();
123 
124             // Delete the index for the deleted slot
125             delete set._indexes[value];
126 
127             return true;
128         } else {
129             return false;
130         }
131     }
132 
133     /**
134      * @dev Returns true if the value is in the set. O(1).
135      */
136     function _contains(Set storage set, bytes32 value) private view returns (bool) {
137         return set._indexes[value] != 0;
138     }
139 
140     /**
141      * @dev Returns the number of values on the set. O(1).
142      */
143     function _length(Set storage set) private view returns (uint256) {
144         return set._values.length;
145     }
146 
147    /**
148     * @dev Returns the value stored at position `index` in the set. O(1).
149     *
150     * Note that there are no guarantees on the ordering of values inside the
151     * array, and it may change when more values are added or removed.
152     *
153     * Requirements:
154     *
155     * - `index` must be strictly less than {length}.
156     */
157     function _at(Set storage set, uint256 index) private view returns (bytes32) {
158         require(set._values.length > index, "EnumerableSet: index out of bounds");
159         return set._values[index];
160     }
161 
162     // AddressSet
163 
164     struct AddressSet {
165         Set _inner;
166     }
167 
168     /**
169      * @dev Add a value to a set. O(1).
170      *
171      * Returns true if the value was added to the set, that is if it was not
172      * already present.
173      */
174     function add(AddressSet storage set, address value) internal returns (bool) {
175         return _add(set._inner, bytes32(uint256(value)));
176     }
177 
178     /**
179      * @dev Removes a value from a set. O(1).
180      *
181      * Returns true if the value was removed from the set, that is if it was
182      * present.
183      */
184     function remove(AddressSet storage set, address value) internal returns (bool) {
185         return _remove(set._inner, bytes32(uint256(value)));
186     }
187 
188     /**
189      * @dev Returns true if the value is in the set. O(1).
190      */
191     function contains(AddressSet storage set, address value) internal view returns (bool) {
192         return _contains(set._inner, bytes32(uint256(value)));
193     }
194 
195     /**
196      * @dev Returns the number of values in the set. O(1).
197      */
198     function length(AddressSet storage set) internal view returns (uint256) {
199         return _length(set._inner);
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
212     function at(AddressSet storage set, uint256 index) internal view returns (address) {
213         return address(uint256(_at(set._inner, index)));
214     }
215 
216 
217     // UintSet
218 
219     struct UintSet {
220         Set _inner;
221     }
222 
223     /**
224      * @dev Add a value to a set. O(1).
225      *
226      * Returns true if the value was added to the set, that is if it was not
227      * already present.
228      */
229     function add(UintSet storage set, uint256 value) internal returns (bool) {
230         return _add(set._inner, bytes32(value));
231     }
232 
233     /**
234      * @dev Removes a value from a set. O(1).
235      *
236      * Returns true if the value was removed from the set, that is if it was
237      * present.
238      */
239     function remove(UintSet storage set, uint256 value) internal returns (bool) {
240         return _remove(set._inner, bytes32(value));
241     }
242 
243     /**
244      * @dev Returns true if the value is in the set. O(1).
245      */
246     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
247         return _contains(set._inner, bytes32(value));
248     }
249 
250     /**
251      * @dev Returns the number of values on the set. O(1).
252      */
253     function length(UintSet storage set) internal view returns (uint256) {
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
267     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
268         return uint256(_at(set._inner, index));
269     }
270 }
271 
272 
273 // File: contracts/access/AccessControl.sol
274 
275 // SPDX-License-Identifier: MIT
276 
277 pragma solidity ^0.6.0;
278 
279 // import "../utils/Address.sol";
280 
281 
282 /**
283  * @dev Contract module that allows children to implement role-based access
284  * control mechanisms.
285  *
286  * Roles are referred to by their `bytes32` identifier. These should be exposed
287  * in the external API and be unique. The best way to achieve this is by
288  * using `public constant` hash digests:
289  *
290  * ```
291  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
292  * ```
293  *
294  * Roles can be used to represent a set of permissions. To restrict access to a
295  * function call, use {hasRole}:
296  *
297  * ```
298  * function foo() public {
299  *     require(hasRole(MY_ROLE, msg.sender));
300  *     ...
301  * }
302  * ```
303  *
304  * Roles can be granted and revoked dynamically via the {grantRole} and
305  * {revokeRole} functions. Each role has an associated admin role, and only
306  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
307  *
308  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
309  * that only accounts with this role will be able to grant or revoke other
310  * roles. More complex role relationships can be created by using
311  * {_setRoleAdmin}.
312  *
313  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
314  * grant and revoke this role. Extra precautions should be taken to secure
315  * accounts that have been granted it.
316  */
317 abstract contract AccessControl is Context {
318     using EnumerableSet for EnumerableSet.AddressSet;
319     // using Address for address;
320 
321     struct RoleData {
322         EnumerableSet.AddressSet members;
323         bytes32 adminRole;
324     }
325 
326     mapping (bytes32 => RoleData) private _roles;
327 
328     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
329 
330     /**
331      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
332      *
333      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
334      * {RoleAdminChanged} not being emitted signaling this.
335      *
336      * _Available since v3.1._
337      */
338     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
339 
340     /**
341      * @dev Emitted when `account` is granted `role`.
342      *
343      * `sender` is the account that originated the contract call, an admin role
344      * bearer except when using {_setupRole}.
345      */
346     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
347 
348     /**
349      * @dev Emitted when `account` is revoked `role`.
350      *
351      * `sender` is the account that originated the contract call:
352      *   - if using `revokeRole`, it is the admin role bearer
353      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
354      */
355     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
356 
357     /**
358      * @dev Returns `true` if `account` has been granted `role`.
359      */
360     function hasRole(bytes32 role, address account) public view returns (bool) {
361         return _roles[role].members.contains(account);
362     }
363 
364     /**
365      * @dev Returns the number of accounts that have `role`. Can be used
366      * together with {getRoleMember} to enumerate all bearers of a role.
367      */
368     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
369         return _roles[role].members.length();
370     }
371 
372     /**
373      * @dev Returns one of the accounts that have `role`. `index` must be a
374      * value between 0 and {getRoleMemberCount}, non-inclusive.
375      *
376      * Role bearers are not sorted in any particular way, and their ordering may
377      * change at any point.
378      *
379      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
380      * you perform all queries on the same block. See the following
381      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
382      * for more information.
383      */
384     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
385         return _roles[role].members.at(index);
386     }
387 
388     /**
389      * @dev Returns the admin role that controls `role`. See {grantRole} and
390      * {revokeRole}.
391      *
392      * To change a role's admin, use {_setRoleAdmin}.
393      */
394     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
395         return _roles[role].adminRole;
396     }
397 
398     /**
399      * @dev Grants `role` to `account`.
400      *
401      * If `account` had not been already granted `role`, emits a {RoleGranted}
402      * event.
403      *
404      * Requirements:
405      *
406      * - the caller must have ``role``'s admin role.
407      */
408     function grantRole(bytes32 role, address account) public virtual {
409         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
410 
411         _grantRole(role, account);
412     }
413 
414     /**
415      * @dev Revokes `role` from `account`.
416      *
417      * If `account` had been granted `role`, emits a {RoleRevoked} event.
418      *
419      * Requirements:
420      *
421      * - the caller must have ``role``'s admin role.
422      */
423     function revokeRole(bytes32 role, address account) public virtual {
424         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
425 
426         _revokeRole(role, account);
427     }
428 
429     /**
430      * @dev Revokes `role` from the calling account.
431      *
432      * Roles are often managed via {grantRole} and {revokeRole}: this function's
433      * purpose is to provide a mechanism for accounts to lose their privileges
434      * if they are compromised (such as when a trusted device is misplaced).
435      *
436      * If the calling account had been granted `role`, emits a {RoleRevoked}
437      * event.
438      *
439      * Requirements:
440      *
441      * - the caller must be `account`.
442      */
443     function renounceRole(bytes32 role, address account) public virtual {
444         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
445 
446         _revokeRole(role, account);
447     }
448 
449     /**
450      * @dev Grants `role` to `account`.
451      *
452      * If `account` had not been already granted `role`, emits a {RoleGranted}
453      * event. Note that unlike {grantRole}, this function doesn't perform any
454      * checks on the calling account.
455      *
456      * [WARNING]
457      * ====
458      * This function should only be called from the constructor when setting
459      * up the initial roles for the system.
460      *
461      * Using this function in any other way is effectively circumventing the admin
462      * system imposed by {AccessControl}.
463      * ====
464      */
465     function _setupRole(bytes32 role, address account) internal virtual {
466         _grantRole(role, account);
467     }
468 
469     /**
470      * @dev Sets `adminRole` as ``role``'s admin role.
471      *
472      * Emits a {RoleAdminChanged} event.
473      */
474     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
475         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
476         _roles[role].adminRole = adminRole;
477     }
478 
479     function _grantRole(bytes32 role, address account) private {
480         if (_roles[role].members.add(account)) {
481             emit RoleGranted(role, account, _msgSender());
482         }
483     }
484 
485     function _revokeRole(bytes32 role, address account) private {
486         if (_roles[role].members.remove(account)) {
487             emit RoleRevoked(role, account, _msgSender());
488         }
489     }
490 }
491 
492 
493 
494 // File: contracts/token/ERC20/IERC20.sol
495 
496 // SPDX-License-Identifier: MIT
497 
498 
499 
500 /**
501  * @dev Interface of the ERC20 standard as defined in the EIP.
502  */
503 interface IERC20 {
504     /**
505      * @dev Returns the amount of tokens in existence.
506      */
507     function totalSupply() external view returns (uint256);
508 
509     /**
510      * @dev Returns the amount of tokens owned by `account`.
511      */
512     function balanceOf(address account) external view returns (uint256);
513 
514     /**
515      * @dev Moves `amount` tokens from the caller's account to `recipient`.
516      *
517      * Returns a boolean value indicating whether the operation succeeded.
518      *
519      * Emits a {Transfer} event.
520      */
521     function transfer(address recipient, uint256 amount) external returns (bool);
522 
523     /**
524      * @dev Returns the remaining number of tokens that `spender` will be
525      * allowed to spend on behalf of `owner` through {transferFrom}. This is
526      * zero by default.
527      *
528      * This value changes when {approve} or {transferFrom} are called.
529      */
530     function allowance(address owner, address spender) external view returns (uint256);
531 
532     /**
533      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
534      *
535      * Returns a boolean value indicating whether the operation succeeded.
536      *
537      * IMPORTANT: Beware that changing an allowance with this method brings the risk
538      * that someone may use both the old and the new allowance by unfortunate
539      * transaction ordering. One possible solution to mitigate this race
540      * condition is to first reduce the spender's allowance to 0 and set the
541      * desired value afterwards:
542      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
543      *
544      * Emits an {Approval} event.
545      */
546     function approve(address spender, uint256 amount) external returns (bool);
547 
548     /**
549      * @dev Moves `amount` tokens from `sender` to `recipient` using the
550      * allowance mechanism. `amount` is then deducted from the caller's
551      * allowance.
552      *
553      * Returns a boolean value indicating whether the operation succeeded.
554      *
555      * Emits a {Transfer} event.
556      */
557     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
558 
559     /**
560      * @dev Emitted when `value` tokens are moved from one account (`from`) to
561      * another (`to`).
562      *
563      * Note that `value` may be zero.
564      */
565     event Transfer(address indexed from, address indexed to, uint256 value);
566 
567     /**
568      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
569      * a call to {approve}. `value` is the new allowance.
570      */
571     event Approval(address indexed owner, address indexed spender, uint256 value);
572 }
573 
574 // File: contracts/math/SafeMath.sol
575 
576 // SPDX-License-Identifier: MIT
577 
578 
579 
580 /**
581  * @dev Wrappers over Solidity's arithmetic operations with added overflow
582  * checks.
583  *
584  * Arithmetic operations in Solidity wrap on overflow. This can easily result
585  * in bugs, because programmers usually assume that an overflow raises an
586  * error, which is the standard behavior in high level programming languages.
587  * `SafeMath` restores this intuition by reverting the transaction when an
588  * operation overflows.
589  *
590  * Using this library instead of the unchecked operations eliminates an entire
591  * class of bugs, so it's recommended to use it always.
592  */
593 library SafeMath {
594     /**
595      * @dev Returns the addition of two unsigned integers, reverting on
596      * overflow.
597      *
598      * Counterpart to Solidity's `+` operator.
599      *
600      * Requirements:
601      *
602      * - Addition cannot overflow.
603      */
604     function add(uint256 a, uint256 b) internal pure returns (uint256) {
605         uint256 c = a + b;
606         require(c >= a, "SafeMath: addition overflow");
607 
608         return c;
609     }
610 
611     /**
612      * @dev Returns the subtraction of two unsigned integers, reverting on
613      * overflow (when the result is negative).
614      *
615      * Counterpart to Solidity's `-` operator.
616      *
617      * Requirements:
618      *
619      * - Subtraction cannot overflow.
620      */
621     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
622         return sub(a, b, "SafeMath: subtraction overflow");
623     }
624 
625     /**
626      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
627      * overflow (when the result is negative).
628      *
629      * Counterpart to Solidity's `-` operator.
630      *
631      * Requirements:
632      *
633      * - Subtraction cannot overflow.
634      */
635     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
636         require(b <= a, errorMessage);
637         uint256 c = a - b;
638 
639         return c;
640     }
641 
642     /**
643      * @dev Returns the multiplication of two unsigned integers, reverting on
644      * overflow.
645      *
646      * Counterpart to Solidity's `*` operator.
647      *
648      * Requirements:
649      *
650      * - Multiplication cannot overflow.
651      */
652     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
653         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
654         // benefit is lost if 'b' is also tested.
655         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
656         if (a == 0) {
657             return 0;
658         }
659 
660         uint256 c = a * b;
661         require(c / a == b, "SafeMath: multiplication overflow");
662 
663         return c;
664     }
665 
666     /**
667      * @dev Returns the integer division of two unsigned integers. Reverts on
668      * division by zero. The result is rounded towards zero.
669      *
670      * Counterpart to Solidity's `/` operator. Note: this function uses a
671      * `revert` opcode (which leaves remaining gas untouched) while Solidity
672      * uses an invalid opcode to revert (consuming all remaining gas).
673      *
674      * Requirements:
675      *
676      * - The divisor cannot be zero.
677      */
678     function div(uint256 a, uint256 b) internal pure returns (uint256) {
679         return div(a, b, "SafeMath: division by zero");
680     }
681 
682     /**
683      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
684      * division by zero. The result is rounded towards zero.
685      *
686      * Counterpart to Solidity's `/` operator. Note: this function uses a
687      * `revert` opcode (which leaves remaining gas untouched) while Solidity
688      * uses an invalid opcode to revert (consuming all remaining gas).
689      *
690      * Requirements:
691      *
692      * - The divisor cannot be zero.
693      */
694     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
695         require(b > 0, errorMessage);
696         uint256 c = a / b;
697         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
698 
699         return c;
700     }
701 
702     /**
703      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
704      * Reverts when dividing by zero.
705      *
706      * Counterpart to Solidity's `%` operator. This function uses a `revert`
707      * opcode (which leaves remaining gas untouched) while Solidity uses an
708      * invalid opcode to revert (consuming all remaining gas).
709      *
710      * Requirements:
711      *
712      * - The divisor cannot be zero.
713      */
714     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
715         return mod(a, b, "SafeMath: modulo by zero");
716     }
717 
718     /**
719      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
720      * Reverts with custom message when dividing by zero.
721      *
722      * Counterpart to Solidity's `%` operator. This function uses a `revert`
723      * opcode (which leaves remaining gas untouched) while Solidity uses an
724      * invalid opcode to revert (consuming all remaining gas).
725      *
726      * Requirements:
727      *
728      * - The divisor cannot be zero.
729      */
730     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
731         require(b != 0, errorMessage);
732         return a % b;
733     }
734 }
735 
736 // File: contracts/token/ERC20/ERC20.sol
737 
738 // SPDX-License-Identifier: MIT
739 
740 
741 
742 
743 
744 
745 /**
746  * @dev Implementation of the {IERC20} interface.
747  *
748  * This implementation is agnostic to the way tokens are created. This means
749  * that a supply mechanism has to be added in a derived contract using {_mint}.
750  * For a generic mechanism see {ERC20PresetMinterPauser}.
751  *
752  * TIP: For a detailed writeup see our guide
753  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
754  * to implement supply mechanisms].
755  *
756  * We have followed general OpenZeppelin guidelines: functions revert instead
757  * of returning `false` on failure. This behavior is nonetheless conventional
758  * and does not conflict with the expectations of ERC20 applications.
759  *
760  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
761  * This allows applications to reconstruct the allowance for all accounts just
762  * by listening to said events. Other implementations of the EIP may not emit
763  * these events, as it isn't required by the specification.
764  *
765  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
766  * functions have been added to mitigate the well-known issues around setting
767  * allowances. See {IERC20-approve}.
768  */
769 contract ERC20 is Context, IERC20 {
770     using SafeMath for uint256;
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
879      * required by the EIP. See the note at the beginning of {ERC20}.
880      *
881      * Requirements:
882      *
883      * - `sender` and `recipient` cannot be the zero address.
884      * - `sender` must have a balance of at least `amount`.
885      * - the caller must have allowance for ``sender``'s tokens of at least
886      * `amount`.
887      */
888     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
889         _transfer(sender, recipient, amount);
890         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
891         return true;
892     }
893 
894     /**
895      * @dev Atomically increases the allowance granted to `spender` by the caller.
896      *
897      * This is an alternative to {approve} that can be used as a mitigation for
898      * problems described in {IERC20-approve}.
899      *
900      * Emits an {Approval} event indicating the updated allowance.
901      *
902      * Requirements:
903      *
904      * - `spender` cannot be the zero address.
905      */
906     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
907         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
908         return true;
909     }
910 
911     /**
912      * @dev Atomically decreases the allowance granted to `spender` by the caller.
913      *
914      * This is an alternative to {approve} that can be used as a mitigation for
915      * problems described in {IERC20-approve}.
916      *
917      * Emits an {Approval} event indicating the updated allowance.
918      *
919      * Requirements:
920      *
921      * - `spender` cannot be the zero address.
922      * - `spender` must have allowance for the caller of at least
923      * `subtractedValue`.
924      */
925     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
926         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
927         return true;
928     }
929 
930     /**
931      * @dev Moves tokens `amount` from `sender` to `recipient`.
932      *
933      * This is internal function is equivalent to {transfer}, and can be used to
934      * e.g. implement automatic token fees, slashing mechanisms, etc.
935      *
936      * Emits a {Transfer} event.
937      *
938      * Requirements:
939      *
940      * - `sender` cannot be the zero address.
941      * - `recipient` cannot be the zero address.
942      * - `sender` must have a balance of at least `amount`.
943      */
944     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
945         require(sender != address(0), "ERC20: transfer from the zero address");
946         require(recipient != address(0), "ERC20: transfer to the zero address");
947 
948         _beforeTokenTransfer(sender, recipient, amount);
949 
950         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
951         _balances[recipient] = _balances[recipient].add(amount);
952         emit Transfer(sender, recipient, amount);
953     }
954 
955     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
956      * the total supply.
957      *
958      * Emits a {Transfer} event with `from` set to the zero address.
959      *
960      * Requirements:
961      *
962      * - `to` cannot be the zero address.
963      */
964     function _mint(address account, uint256 amount) internal virtual {
965         require(account != address(0), "ERC20: mint to the zero address");
966 
967         _beforeTokenTransfer(address(0), account, amount);
968 
969         _totalSupply = _totalSupply.add(amount);
970         _balances[account] = _balances[account].add(amount);
971         emit Transfer(address(0), account, amount);
972     }
973 
974     /**
975      * @dev Destroys `amount` tokens from `account`, reducing the
976      * total supply.
977      *
978      * Emits a {Transfer} event with `to` set to the zero address.
979      *
980      * Requirements:
981      *
982      * - `account` cannot be the zero address.
983      * - `account` must have at least `amount` tokens.
984      */
985     function _burn(address account, uint256 amount) internal virtual {
986         require(account != address(0), "ERC20: burn from the zero address");
987 
988         _beforeTokenTransfer(account, address(0), amount);
989 
990         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
991         _totalSupply = _totalSupply.sub(amount);
992         emit Transfer(account, address(0), amount);
993     }
994 
995     /**
996      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
997      *
998      * This internal function is equivalent to `approve`, and can be used to
999      * e.g. set automatic allowances for certain subsystems, etc.
1000      *
1001      * Emits an {Approval} event.
1002      *
1003      * Requirements:
1004      *
1005      * - `owner` cannot be the zero address.
1006      * - `spender` cannot be the zero address.
1007      */
1008     function _approve(address owner, address spender, uint256 amount) internal virtual {
1009         require(owner != address(0), "ERC20: approve from the zero address");
1010         require(spender != address(0), "ERC20: approve to the zero address");
1011 
1012         _allowances[owner][spender] = amount;
1013         emit Approval(owner, spender, amount);
1014     }
1015 
1016     /**
1017      * @dev Sets {decimals} to a value other than the default one of 18.
1018      *
1019      * WARNING: This function should only be called from the constructor. Most
1020      * applications that interact with token contracts will not expect
1021      * {decimals} to ever change, and may work incorrectly if it does.
1022      */
1023     function _setupDecimals(uint8 decimals_) internal {
1024         _decimals = decimals_;
1025     }
1026 
1027     /**
1028      * @dev Hook that is called before any transfer of tokens. This includes
1029      * minting and burning.
1030      *
1031      * Calling conditions:
1032      *
1033      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1034      * will be to transferred to `to`.
1035      * - when `from` is zero, `amount` tokens will be minted for `to`.
1036      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1037      * - `from` and `to` are never both zero.
1038      *
1039      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1040      */
1041     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1042 }
1043 
1044 abstract contract ERC20Burnable is Context, ERC20 {
1045     /**
1046      * @dev Destroys `amount` tokens from the caller.
1047      *
1048      * See {ERC20-_burn}.
1049      */
1050     function burn(uint256 amount) public virtual {
1051         _burn(_msgSender(), amount);
1052     }
1053 
1054     /**
1055      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1056      * allowance.
1057      *
1058      * See {ERC20-_burn} and {ERC20-allowance}.
1059      *
1060      * Requirements:
1061      *
1062      * - the caller must have allowance for ``accounts``'s tokens of at least
1063      * `amount`.
1064      */
1065     function burnFrom(address account, uint256 amount) public virtual {
1066         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1067 
1068         _approve(account, _msgSender(), decreasedAllowance);
1069         _burn(account, amount);
1070     }
1071 }
1072 
1073 contract ReaktorCore is ERC20, ERC20Burnable {
1074   constructor(string memory _name, string memory _symbol, uint256 totalSupply) public ERC20(_name, _symbol) {
1075     _mint(msg.sender, totalSupply);
1076   }
1077 }