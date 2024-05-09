1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.0.1
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Library for managing
9  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
10  * types.
11  *
12  * Sets have the following properties:
13  *
14  * - Elements are added, removed, and checked for existence in constant time
15  * (O(1)).
16  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
17  *
18  * ```
19  * contract Example {
20  *     // Add the library methods
21  *     using EnumerableSet for EnumerableSet.AddressSet;
22  *
23  *     // Declare a set state variable
24  *     EnumerableSet.AddressSet private mySet;
25  * }
26  * ```
27  *
28  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
29  * (`UintSet`) are supported.
30  */
31 library EnumerableSet {
32     // To implement this library for multiple types with as little code
33     // repetition as possible, we write it in terms of a generic Set type with
34     // bytes32 values.
35     // The Set implementation uses private functions, and user-facing
36     // implementations (such as AddressSet) are just wrappers around the
37     // underlying Set.
38     // This means that we can only create new EnumerableSets for types that fit
39     // in bytes32.
40 
41     struct Set {
42         // Storage of set values
43         bytes32[] _values;
44 
45         // Position of the value in the `values` array, plus 1 because index 0
46         // means a value is not in the set.
47         mapping (bytes32 => uint256) _indexes;
48     }
49 
50     /**
51      * @dev Add a value to a set. O(1).
52      *
53      * Returns true if the value was added to the set, that is if it was not
54      * already present.
55      */
56     function _add(Set storage set, bytes32 value) private returns (bool) {
57         if (!_contains(set, value)) {
58             set._values.push(value);
59             // The value is stored at length-1, but we add 1 to all indexes
60             // and use 0 as a sentinel value
61             set._indexes[value] = set._values.length;
62             return true;
63         } else {
64             return false;
65         }
66     }
67 
68     /**
69      * @dev Removes a value from a set. O(1).
70      *
71      * Returns true if the value was removed from the set, that is if it was
72      * present.
73      */
74     function _remove(Set storage set, bytes32 value) private returns (bool) {
75         // We read and store the value's index to prevent multiple reads from the same storage slot
76         uint256 valueIndex = set._indexes[value];
77 
78         if (valueIndex != 0) { // Equivalent to contains(set, value)
79             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
80             // the array, and then remove the last element (sometimes called as 'swap and pop').
81             // This modifies the order of the array, as noted in {at}.
82 
83             uint256 toDeleteIndex = valueIndex - 1;
84             uint256 lastIndex = set._values.length - 1;
85 
86             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
87             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
88 
89             bytes32 lastvalue = set._values[lastIndex];
90 
91             // Move the last value to the index where the value to delete is
92             set._values[toDeleteIndex] = lastvalue;
93             // Update the index for the moved value
94             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
95 
96             // Delete the slot where the moved value was stored
97             set._values.pop();
98 
99             // Delete the index for the deleted slot
100             delete set._indexes[value];
101 
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     /**
109      * @dev Returns true if the value is in the set. O(1).
110      */
111     function _contains(Set storage set, bytes32 value) private view returns (bool) {
112         return set._indexes[value] != 0;
113     }
114 
115     /**
116      * @dev Returns the number of values on the set. O(1).
117      */
118     function _length(Set storage set) private view returns (uint256) {
119         return set._values.length;
120     }
121 
122    /**
123     * @dev Returns the value stored at position `index` in the set. O(1).
124     *
125     * Note that there are no guarantees on the ordering of values inside the
126     * array, and it may change when more values are added or removed.
127     *
128     * Requirements:
129     *
130     * - `index` must be strictly less than {length}.
131     */
132     function _at(Set storage set, uint256 index) private view returns (bytes32) {
133         require(set._values.length > index, "EnumerableSet: index out of bounds");
134         return set._values[index];
135     }
136 
137     // AddressSet
138 
139     struct AddressSet {
140         Set _inner;
141     }
142 
143     /**
144      * @dev Add a value to a set. O(1).
145      *
146      * Returns true if the value was added to the set, that is if it was not
147      * already present.
148      */
149     function add(AddressSet storage set, address value) internal returns (bool) {
150         return _add(set._inner, bytes32(uint256(value)));
151     }
152 
153     /**
154      * @dev Removes a value from a set. O(1).
155      *
156      * Returns true if the value was removed from the set, that is if it was
157      * present.
158      */
159     function remove(AddressSet storage set, address value) internal returns (bool) {
160         return _remove(set._inner, bytes32(uint256(value)));
161     }
162 
163     /**
164      * @dev Returns true if the value is in the set. O(1).
165      */
166     function contains(AddressSet storage set, address value) internal view returns (bool) {
167         return _contains(set._inner, bytes32(uint256(value)));
168     }
169 
170     /**
171      * @dev Returns the number of values in the set. O(1).
172      */
173     function length(AddressSet storage set) internal view returns (uint256) {
174         return _length(set._inner);
175     }
176 
177    /**
178     * @dev Returns the value stored at position `index` in the set. O(1).
179     *
180     * Note that there are no guarantees on the ordering of values inside the
181     * array, and it may change when more values are added or removed.
182     *
183     * Requirements:
184     *
185     * - `index` must be strictly less than {length}.
186     */
187     function at(AddressSet storage set, uint256 index) internal view returns (address) {
188         return address(uint256(_at(set._inner, index)));
189     }
190 
191 
192     // UintSet
193 
194     struct UintSet {
195         Set _inner;
196     }
197 
198     /**
199      * @dev Add a value to a set. O(1).
200      *
201      * Returns true if the value was added to the set, that is if it was not
202      * already present.
203      */
204     function add(UintSet storage set, uint256 value) internal returns (bool) {
205         return _add(set._inner, bytes32(value));
206     }
207 
208     /**
209      * @dev Removes a value from a set. O(1).
210      *
211      * Returns true if the value was removed from the set, that is if it was
212      * present.
213      */
214     function remove(UintSet storage set, uint256 value) internal returns (bool) {
215         return _remove(set._inner, bytes32(value));
216     }
217 
218     /**
219      * @dev Returns true if the value is in the set. O(1).
220      */
221     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
222         return _contains(set._inner, bytes32(value));
223     }
224 
225     /**
226      * @dev Returns the number of values on the set. O(1).
227      */
228     function length(UintSet storage set) internal view returns (uint256) {
229         return _length(set._inner);
230     }
231 
232    /**
233     * @dev Returns the value stored at position `index` in the set. O(1).
234     *
235     * Note that there are no guarantees on the ordering of values inside the
236     * array, and it may change when more values are added or removed.
237     *
238     * Requirements:
239     *
240     * - `index` must be strictly less than {length}.
241     */
242     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
243         return uint256(_at(set._inner, index));
244     }
245 }
246 
247 
248 // File @openzeppelin/contracts/utils/Address.sol@v3.0.1
249 
250 pragma solidity ^0.6.2;
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276         // for accounts without code, i.e. `keccak256('')`
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { codehash := extcodehash(account) }
281         return (codehash != accountHash && codehash != 0x0);
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 }
308 
309 
310 // File @openzeppelin/contracts/GSN/Context.sol@v3.0.1
311 
312 pragma solidity ^0.6.0;
313 
314 /*
315  * @dev Provides information about the current execution context, including the
316  * sender of the transaction and its data. While these are generally available
317  * via msg.sender and msg.data, they should not be accessed in such a direct
318  * manner, since when dealing with GSN meta-transactions the account sending and
319  * paying for execution may not be the actual sender (as far as an application
320  * is concerned).
321  *
322  * This contract is only required for intermediate, library-like contracts.
323  */
324 contract Context {
325     // Empty internal constructor, to prevent people from mistakenly deploying
326     // an instance of this contract, which should be used via inheritance.
327     constructor () internal { }
328 
329     function _msgSender() internal view virtual returns (address payable) {
330         return msg.sender;
331     }
332 
333     function _msgData() internal view virtual returns (bytes memory) {
334         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
335         return msg.data;
336     }
337 }
338 
339 
340 // File @openzeppelin/contracts/access/AccessControl.sol@v3.0.1
341 
342 pragma solidity ^0.6.0;
343 
344 
345 
346 
347 /**
348  * @dev Contract module that allows children to implement role-based access
349  * control mechanisms.
350  *
351  * Roles are referred to by their `bytes32` identifier. These should be exposed
352  * in the external API and be unique. The best way to achieve this is by
353  * using `public constant` hash digests:
354  *
355  * ```
356  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
357  * ```
358  *
359  * Roles can be used to represent a set of permissions. To restrict access to a
360  * function call, use {hasRole}:
361  *
362  * ```
363  * function foo() public {
364  *     require(hasRole(MY_ROLE, msg.sender));
365  *     ...
366  * }
367  * ```
368  *
369  * Roles can be granted and revoked dynamically via the {grantRole} and
370  * {revokeRole} functions. Each role has an associated admin role, and only
371  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
372  *
373  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
374  * that only accounts with this role will be able to grant or revoke other
375  * roles. More complex role relationships can be created by using
376  * {_setRoleAdmin}.
377  *
378  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
379  * grant and revoke this role. Extra precautions should be taken to secure
380  * accounts that have been granted it.
381  */
382 abstract contract AccessControl is Context {
383     using EnumerableSet for EnumerableSet.AddressSet;
384     using Address for address;
385 
386     struct RoleData {
387         EnumerableSet.AddressSet members;
388         bytes32 adminRole;
389     }
390 
391     mapping (bytes32 => RoleData) private _roles;
392 
393     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
394 
395     /**
396      * @dev Emitted when `account` is granted `role`.
397      *
398      * `sender` is the account that originated the contract call, an admin role
399      * bearer except when using {_setupRole}.
400      */
401     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
402 
403     /**
404      * @dev Emitted when `account` is revoked `role`.
405      *
406      * `sender` is the account that originated the contract call:
407      *   - if using `revokeRole`, it is the admin role bearer
408      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
409      */
410     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
411 
412     /**
413      * @dev Returns `true` if `account` has been granted `role`.
414      */
415     function hasRole(bytes32 role, address account) public view returns (bool) {
416         return _roles[role].members.contains(account);
417     }
418 
419     /**
420      * @dev Returns the number of accounts that have `role`. Can be used
421      * together with {getRoleMember} to enumerate all bearers of a role.
422      */
423     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
424         return _roles[role].members.length();
425     }
426 
427     /**
428      * @dev Returns one of the accounts that have `role`. `index` must be a
429      * value between 0 and {getRoleMemberCount}, non-inclusive.
430      *
431      * Role bearers are not sorted in any particular way, and their ordering may
432      * change at any point.
433      *
434      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
435      * you perform all queries on the same block. See the following
436      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
437      * for more information.
438      */
439     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
440         return _roles[role].members.at(index);
441     }
442 
443     /**
444      * @dev Returns the admin role that controls `role`. See {grantRole} and
445      * {revokeRole}.
446      *
447      * To change a role's admin, use {_setRoleAdmin}.
448      */
449     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
450         return _roles[role].adminRole;
451     }
452 
453     /**
454      * @dev Grants `role` to `account`.
455      *
456      * If `account` had not been already granted `role`, emits a {RoleGranted}
457      * event.
458      *
459      * Requirements:
460      *
461      * - the caller must have ``role``'s admin role.
462      */
463     function grantRole(bytes32 role, address account) public virtual {
464         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
465 
466         _grantRole(role, account);
467     }
468 
469     /**
470      * @dev Revokes `role` from `account`.
471      *
472      * If `account` had been granted `role`, emits a {RoleRevoked} event.
473      *
474      * Requirements:
475      *
476      * - the caller must have ``role``'s admin role.
477      */
478     function revokeRole(bytes32 role, address account) public virtual {
479         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
480 
481         _revokeRole(role, account);
482     }
483 
484     /**
485      * @dev Revokes `role` from the calling account.
486      *
487      * Roles are often managed via {grantRole} and {revokeRole}: this function's
488      * purpose is to provide a mechanism for accounts to lose their privileges
489      * if they are compromised (such as when a trusted device is misplaced).
490      *
491      * If the calling account had been granted `role`, emits a {RoleRevoked}
492      * event.
493      *
494      * Requirements:
495      *
496      * - the caller must be `account`.
497      */
498     function renounceRole(bytes32 role, address account) public virtual {
499         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
500 
501         _revokeRole(role, account);
502     }
503 
504     /**
505      * @dev Grants `role` to `account`.
506      *
507      * If `account` had not been already granted `role`, emits a {RoleGranted}
508      * event. Note that unlike {grantRole}, this function doesn't perform any
509      * checks on the calling account.
510      *
511      * [WARNING]
512      * ====
513      * This function should only be called from the constructor when setting
514      * up the initial roles for the system.
515      *
516      * Using this function in any other way is effectively circumventing the admin
517      * system imposed by {AccessControl}.
518      * ====
519      */
520     function _setupRole(bytes32 role, address account) internal virtual {
521         _grantRole(role, account);
522     }
523 
524     /**
525      * @dev Sets `adminRole` as ``role``'s admin role.
526      */
527     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
528         _roles[role].adminRole = adminRole;
529     }
530 
531     function _grantRole(bytes32 role, address account) private {
532         if (_roles[role].members.add(account)) {
533             emit RoleGranted(role, account, _msgSender());
534         }
535     }
536 
537     function _revokeRole(bytes32 role, address account) private {
538         if (_roles[role].members.remove(account)) {
539             emit RoleRevoked(role, account, _msgSender());
540         }
541     }
542 }
543 
544 
545 // File @openzeppelin/contracts/math/SafeMath.sol@v3.0.1
546 
547 pragma solidity ^0.6.0;
548 
549 /**
550  * @dev Wrappers over Solidity's arithmetic operations with added overflow
551  * checks.
552  *
553  * Arithmetic operations in Solidity wrap on overflow. This can easily result
554  * in bugs, because programmers usually assume that an overflow raises an
555  * error, which is the standard behavior in high level programming languages.
556  * `SafeMath` restores this intuition by reverting the transaction when an
557  * operation overflows.
558  *
559  * Using this library instead of the unchecked operations eliminates an entire
560  * class of bugs, so it's recommended to use it always.
561  */
562 library SafeMath {
563     /**
564      * @dev Returns the addition of two unsigned integers, reverting on
565      * overflow.
566      *
567      * Counterpart to Solidity's `+` operator.
568      *
569      * Requirements:
570      * - Addition cannot overflow.
571      */
572     function add(uint256 a, uint256 b) internal pure returns (uint256) {
573         uint256 c = a + b;
574         require(c >= a, "SafeMath: addition overflow");
575 
576         return c;
577     }
578 
579     /**
580      * @dev Returns the subtraction of two unsigned integers, reverting on
581      * overflow (when the result is negative).
582      *
583      * Counterpart to Solidity's `-` operator.
584      *
585      * Requirements:
586      * - Subtraction cannot overflow.
587      */
588     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
589         return sub(a, b, "SafeMath: subtraction overflow");
590     }
591 
592     /**
593      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
594      * overflow (when the result is negative).
595      *
596      * Counterpart to Solidity's `-` operator.
597      *
598      * Requirements:
599      * - Subtraction cannot overflow.
600      */
601     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
602         require(b <= a, errorMessage);
603         uint256 c = a - b;
604 
605         return c;
606     }
607 
608     /**
609      * @dev Returns the multiplication of two unsigned integers, reverting on
610      * overflow.
611      *
612      * Counterpart to Solidity's `*` operator.
613      *
614      * Requirements:
615      * - Multiplication cannot overflow.
616      */
617     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
618         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
619         // benefit is lost if 'b' is also tested.
620         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
621         if (a == 0) {
622             return 0;
623         }
624 
625         uint256 c = a * b;
626         require(c / a == b, "SafeMath: multiplication overflow");
627 
628         return c;
629     }
630 
631     /**
632      * @dev Returns the integer division of two unsigned integers. Reverts on
633      * division by zero. The result is rounded towards zero.
634      *
635      * Counterpart to Solidity's `/` operator. Note: this function uses a
636      * `revert` opcode (which leaves remaining gas untouched) while Solidity
637      * uses an invalid opcode to revert (consuming all remaining gas).
638      *
639      * Requirements:
640      * - The divisor cannot be zero.
641      */
642     function div(uint256 a, uint256 b) internal pure returns (uint256) {
643         return div(a, b, "SafeMath: division by zero");
644     }
645 
646     /**
647      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
648      * division by zero. The result is rounded towards zero.
649      *
650      * Counterpart to Solidity's `/` operator. Note: this function uses a
651      * `revert` opcode (which leaves remaining gas untouched) while Solidity
652      * uses an invalid opcode to revert (consuming all remaining gas).
653      *
654      * Requirements:
655      * - The divisor cannot be zero.
656      */
657     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
658         // Solidity only automatically asserts when dividing by 0
659         require(b > 0, errorMessage);
660         uint256 c = a / b;
661         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
662 
663         return c;
664     }
665 
666     /**
667      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
668      * Reverts when dividing by zero.
669      *
670      * Counterpart to Solidity's `%` operator. This function uses a `revert`
671      * opcode (which leaves remaining gas untouched) while Solidity uses an
672      * invalid opcode to revert (consuming all remaining gas).
673      *
674      * Requirements:
675      * - The divisor cannot be zero.
676      */
677     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
678         return mod(a, b, "SafeMath: modulo by zero");
679     }
680 
681     /**
682      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
683      * Reverts with custom message when dividing by zero.
684      *
685      * Counterpart to Solidity's `%` operator. This function uses a `revert`
686      * opcode (which leaves remaining gas untouched) while Solidity uses an
687      * invalid opcode to revert (consuming all remaining gas).
688      *
689      * Requirements:
690      * - The divisor cannot be zero.
691      */
692     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
693         require(b != 0, errorMessage);
694         return a % b;
695     }
696 }
697 
698 
699 // File @openzeppelin/contracts/math/Math.sol@v3.0.1
700 
701 pragma solidity ^0.6.0;
702 
703 /**
704  * @dev Standard math utilities missing in the Solidity language.
705  */
706 library Math {
707     /**
708      * @dev Returns the largest of two numbers.
709      */
710     function max(uint256 a, uint256 b) internal pure returns (uint256) {
711         return a >= b ? a : b;
712     }
713 
714     /**
715      * @dev Returns the smallest of two numbers.
716      */
717     function min(uint256 a, uint256 b) internal pure returns (uint256) {
718         return a < b ? a : b;
719     }
720 
721     /**
722      * @dev Returns the average of two numbers. The result is rounded towards
723      * zero.
724      */
725     function average(uint256 a, uint256 b) internal pure returns (uint256) {
726         // (a + b) / 2 can overflow, so we distribute
727         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
728     }
729 }
730 
731 
732 // File @openzeppelin/contracts/utils/Arrays.sol@v3.0.1
733 
734 pragma solidity ^0.6.0;
735 
736 
737 /**
738  * @dev Collection of functions related to array types.
739  */
740 library Arrays {
741    /**
742      * @dev Searches a sorted `array` and returns the first index that contains
743      * a value greater or equal to `element`. If no such index exists (i.e. all
744      * values in the array are strictly less than `element`), the array length is
745      * returned. Time complexity O(log n).
746      *
747      * `array` is expected to be sorted in ascending order, and to contain no
748      * repeated elements.
749      */
750     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
751         if (array.length == 0) {
752             return 0;
753         }
754 
755         uint256 low = 0;
756         uint256 high = array.length;
757 
758         while (low < high) {
759             uint256 mid = Math.average(low, high);
760 
761             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
762             // because Math.average rounds down (it does integer division with truncation).
763             if (array[mid] > element) {
764                 high = mid;
765             } else {
766                 low = mid + 1;
767             }
768         }
769 
770         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
771         if (low > 0 && array[low - 1] == element) {
772             return low - 1;
773         } else {
774             return low;
775         }
776     }
777 }
778 
779 
780 // File @openzeppelin/contracts/utils/Counters.sol@v3.0.1
781 
782 pragma solidity ^0.6.0;
783 
784 
785 /**
786  * @title Counters
787  * @author Matt Condon (@shrugs)
788  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
789  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
790  *
791  * Include with `using Counters for Counters.Counter;`
792  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
793  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
794  * directly accessed.
795  */
796 library Counters {
797     using SafeMath for uint256;
798 
799     struct Counter {
800         // This variable should never be directly accessed by users of the library: interactions must be restricted to
801         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
802         // this feature: see https://github.com/ethereum/solidity/issues/4637
803         uint256 _value; // default: 0
804     }
805 
806     function current(Counter storage counter) internal view returns (uint256) {
807         return counter._value;
808     }
809 
810     function increment(Counter storage counter) internal {
811         // The {SafeMath} overflow check can be skipped here, see the comment at the top
812         counter._value += 1;
813     }
814 
815     function decrement(Counter storage counter) internal {
816         counter._value = counter._value.sub(1);
817     }
818 }
819 
820 
821 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.0.1
822 
823 pragma solidity ^0.6.0;
824 
825 /**
826  * @dev Interface of the ERC20 standard as defined in the EIP.
827  */
828 interface IERC20 {
829     /**
830      * @dev Returns the amount of tokens in existence.
831      */
832     function totalSupply() external view returns (uint256);
833 
834     /**
835      * @dev Returns the amount of tokens owned by `account`.
836      */
837     function balanceOf(address account) external view returns (uint256);
838 
839     /**
840      * @dev Moves `amount` tokens from the caller's account to `recipient`.
841      *
842      * Returns a boolean value indicating whether the operation succeeded.
843      *
844      * Emits a {Transfer} event.
845      */
846     function transfer(address recipient, uint256 amount) external returns (bool);
847 
848     /**
849      * @dev Returns the remaining number of tokens that `spender` will be
850      * allowed to spend on behalf of `owner` through {transferFrom}. This is
851      * zero by default.
852      *
853      * This value changes when {approve} or {transferFrom} are called.
854      */
855     function allowance(address owner, address spender) external view returns (uint256);
856 
857     /**
858      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
859      *
860      * Returns a boolean value indicating whether the operation succeeded.
861      *
862      * IMPORTANT: Beware that changing an allowance with this method brings the risk
863      * that someone may use both the old and the new allowance by unfortunate
864      * transaction ordering. One possible solution to mitigate this race
865      * condition is to first reduce the spender's allowance to 0 and set the
866      * desired value afterwards:
867      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
868      *
869      * Emits an {Approval} event.
870      */
871     function approve(address spender, uint256 amount) external returns (bool);
872 
873     /**
874      * @dev Moves `amount` tokens from `sender` to `recipient` using the
875      * allowance mechanism. `amount` is then deducted from the caller's
876      * allowance.
877      *
878      * Returns a boolean value indicating whether the operation succeeded.
879      *
880      * Emits a {Transfer} event.
881      */
882     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
883 
884     /**
885      * @dev Emitted when `value` tokens are moved from one account (`from`) to
886      * another (`to`).
887      *
888      * Note that `value` may be zero.
889      */
890     event Transfer(address indexed from, address indexed to, uint256 value);
891 
892     /**
893      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
894      * a call to {approve}. `value` is the new allowance.
895      */
896     event Approval(address indexed owner, address indexed spender, uint256 value);
897 }
898 
899 
900 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.0.1
901 
902 pragma solidity ^0.6.0;
903 
904 
905 
906 
907 
908 /**
909  * @dev Implementation of the {IERC20} interface.
910  *
911  * This implementation is agnostic to the way tokens are created. This means
912  * that a supply mechanism has to be added in a derived contract using {_mint}.
913  * For a generic mechanism see {ERC20MinterPauser}.
914  *
915  * TIP: For a detailed writeup see our guide
916  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
917  * to implement supply mechanisms].
918  *
919  * We have followed general OpenZeppelin guidelines: functions revert instead
920  * of returning `false` on failure. This behavior is nonetheless conventional
921  * and does not conflict with the expectations of ERC20 applications.
922  *
923  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
924  * This allows applications to reconstruct the allowance for all accounts just
925  * by listening to said events. Other implementations of the EIP may not emit
926  * these events, as it isn't required by the specification.
927  *
928  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
929  * functions have been added to mitigate the well-known issues around setting
930  * allowances. See {IERC20-approve}.
931  */
932 contract ERC20 is Context, IERC20 {
933     using SafeMath for uint256;
934     using Address for address;
935 
936     mapping (address => uint256) private _balances;
937 
938     mapping (address => mapping (address => uint256)) private _allowances;
939 
940     uint256 private _totalSupply;
941 
942     string private _name;
943     string private _symbol;
944     uint8 private _decimals;
945 
946     /**
947      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
948      * a default value of 18.
949      *
950      * To select a different value for {decimals}, use {_setupDecimals}.
951      *
952      * All three of these values are immutable: they can only be set once during
953      * construction.
954      */
955     constructor (string memory name, string memory symbol) public {
956         _name = name;
957         _symbol = symbol;
958         _decimals = 18;
959     }
960 
961     /**
962      * @dev Returns the name of the token.
963      */
964     function name() public view returns (string memory) {
965         return _name;
966     }
967 
968     /**
969      * @dev Returns the symbol of the token, usually a shorter version of the
970      * name.
971      */
972     function symbol() public view returns (string memory) {
973         return _symbol;
974     }
975 
976     /**
977      * @dev Returns the number of decimals used to get its user representation.
978      * For example, if `decimals` equals `2`, a balance of `505` tokens should
979      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
980      *
981      * Tokens usually opt for a value of 18, imitating the relationship between
982      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
983      * called.
984      *
985      * NOTE: This information is only used for _display_ purposes: it in
986      * no way affects any of the arithmetic of the contract, including
987      * {IERC20-balanceOf} and {IERC20-transfer}.
988      */
989     function decimals() public view returns (uint8) {
990         return _decimals;
991     }
992 
993     /**
994      * @dev See {IERC20-totalSupply}.
995      */
996     function totalSupply() public view override returns (uint256) {
997         return _totalSupply;
998     }
999 
1000     /**
1001      * @dev See {IERC20-balanceOf}.
1002      */
1003     function balanceOf(address account) public view override returns (uint256) {
1004         return _balances[account];
1005     }
1006 
1007     /**
1008      * @dev See {IERC20-transfer}.
1009      *
1010      * Requirements:
1011      *
1012      * - `recipient` cannot be the zero address.
1013      * - the caller must have a balance of at least `amount`.
1014      */
1015     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1016         _transfer(_msgSender(), recipient, amount);
1017         return true;
1018     }
1019 
1020     /**
1021      * @dev See {IERC20-allowance}.
1022      */
1023     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1024         return _allowances[owner][spender];
1025     }
1026 
1027     /**
1028      * @dev See {IERC20-approve}.
1029      *
1030      * Requirements:
1031      *
1032      * - `spender` cannot be the zero address.
1033      */
1034     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1035         _approve(_msgSender(), spender, amount);
1036         return true;
1037     }
1038 
1039     /**
1040      * @dev See {IERC20-transferFrom}.
1041      *
1042      * Emits an {Approval} event indicating the updated allowance. This is not
1043      * required by the EIP. See the note at the beginning of {ERC20};
1044      *
1045      * Requirements:
1046      * - `sender` and `recipient` cannot be the zero address.
1047      * - `sender` must have a balance of at least `amount`.
1048      * - the caller must have allowance for ``sender``'s tokens of at least
1049      * `amount`.
1050      */
1051     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1052         _transfer(sender, recipient, amount);
1053         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1054         return true;
1055     }
1056 
1057     /**
1058      * @dev Atomically increases the allowance granted to `spender` by the caller.
1059      *
1060      * This is an alternative to {approve} that can be used as a mitigation for
1061      * problems described in {IERC20-approve}.
1062      *
1063      * Emits an {Approval} event indicating the updated allowance.
1064      *
1065      * Requirements:
1066      *
1067      * - `spender` cannot be the zero address.
1068      */
1069     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1070         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1071         return true;
1072     }
1073 
1074     /**
1075      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1076      *
1077      * This is an alternative to {approve} that can be used as a mitigation for
1078      * problems described in {IERC20-approve}.
1079      *
1080      * Emits an {Approval} event indicating the updated allowance.
1081      *
1082      * Requirements:
1083      *
1084      * - `spender` cannot be the zero address.
1085      * - `spender` must have allowance for the caller of at least
1086      * `subtractedValue`.
1087      */
1088     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1089         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1090         return true;
1091     }
1092 
1093     /**
1094      * @dev Moves tokens `amount` from `sender` to `recipient`.
1095      *
1096      * This is internal function is equivalent to {transfer}, and can be used to
1097      * e.g. implement automatic token fees, slashing mechanisms, etc.
1098      *
1099      * Emits a {Transfer} event.
1100      *
1101      * Requirements:
1102      *
1103      * - `sender` cannot be the zero address.
1104      * - `recipient` cannot be the zero address.
1105      * - `sender` must have a balance of at least `amount`.
1106      */
1107     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1108         require(sender != address(0), "ERC20: transfer from the zero address");
1109         require(recipient != address(0), "ERC20: transfer to the zero address");
1110 
1111         _beforeTokenTransfer(sender, recipient, amount);
1112 
1113         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1114         _balances[recipient] = _balances[recipient].add(amount);
1115         emit Transfer(sender, recipient, amount);
1116     }
1117 
1118     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1119      * the total supply.
1120      *
1121      * Emits a {Transfer} event with `from` set to the zero address.
1122      *
1123      * Requirements
1124      *
1125      * - `to` cannot be the zero address.
1126      */
1127     function _mint(address account, uint256 amount) internal virtual {
1128         require(account != address(0), "ERC20: mint to the zero address");
1129 
1130         _beforeTokenTransfer(address(0), account, amount);
1131 
1132         _totalSupply = _totalSupply.add(amount);
1133         _balances[account] = _balances[account].add(amount);
1134         emit Transfer(address(0), account, amount);
1135     }
1136 
1137     /**
1138      * @dev Destroys `amount` tokens from `account`, reducing the
1139      * total supply.
1140      *
1141      * Emits a {Transfer} event with `to` set to the zero address.
1142      *
1143      * Requirements
1144      *
1145      * - `account` cannot be the zero address.
1146      * - `account` must have at least `amount` tokens.
1147      */
1148     function _burn(address account, uint256 amount) internal virtual {
1149         require(account != address(0), "ERC20: burn from the zero address");
1150 
1151         _beforeTokenTransfer(account, address(0), amount);
1152 
1153         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1154         _totalSupply = _totalSupply.sub(amount);
1155         emit Transfer(account, address(0), amount);
1156     }
1157 
1158     /**
1159      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1160      *
1161      * This is internal function is equivalent to `approve`, and can be used to
1162      * e.g. set automatic allowances for certain subsystems, etc.
1163      *
1164      * Emits an {Approval} event.
1165      *
1166      * Requirements:
1167      *
1168      * - `owner` cannot be the zero address.
1169      * - `spender` cannot be the zero address.
1170      */
1171     function _approve(address owner, address spender, uint256 amount) internal virtual {
1172         require(owner != address(0), "ERC20: approve from the zero address");
1173         require(spender != address(0), "ERC20: approve to the zero address");
1174 
1175         _allowances[owner][spender] = amount;
1176         emit Approval(owner, spender, amount);
1177     }
1178 
1179     /**
1180      * @dev Sets {decimals} to a value other than the default one of 18.
1181      *
1182      * WARNING: This function should only be called from the constructor. Most
1183      * applications that interact with token contracts will not expect
1184      * {decimals} to ever change, and may work incorrectly if it does.
1185      */
1186     function _setupDecimals(uint8 decimals_) internal {
1187         _decimals = decimals_;
1188     }
1189 
1190     /**
1191      * @dev Hook that is called before any transfer of tokens. This includes
1192      * minting and burning.
1193      *
1194      * Calling conditions:
1195      *
1196      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1197      * will be to transferred to `to`.
1198      * - when `from` is zero, `amount` tokens will be minted for `to`.
1199      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1200      * - `from` and `to` are never both zero.
1201      *
1202      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1203      */
1204     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1205 }
1206 
1207 
1208 // File @openzeppelin/contracts/token/ERC20/ERC20Snapshot.sol@v3.0.1
1209 
1210 pragma solidity ^0.6.0;
1211 
1212 
1213 
1214 
1215 
1216 /**
1217  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1218  * total supply at the time are recorded for later access.
1219  *
1220  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1221  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1222  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1223  * used to create an efficient ERC20 forking mechanism.
1224  *
1225  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1226  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1227  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1228  * and the account address.
1229  *
1230  * ==== Gas Costs
1231  *
1232  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1233  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1234  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1235  *
1236  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1237  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1238  * transfers will have normal cost until the next snapshot, and so on.
1239  */
1240 abstract contract ERC20Snapshot is ERC20 {
1241     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1242     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1243 
1244     using SafeMath for uint256;
1245     using Arrays for uint256[];
1246     using Counters for Counters.Counter;
1247 
1248     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1249     // Snapshot struct, but that would impede usage of functions that work on an array.
1250     struct Snapshots {
1251         uint256[] ids;
1252         uint256[] values;
1253     }
1254 
1255     mapping (address => Snapshots) private _accountBalanceSnapshots;
1256     Snapshots private _totalSupplySnapshots;
1257 
1258     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1259     Counters.Counter private _currentSnapshotId;
1260 
1261     /**
1262      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1263      */
1264     event Snapshot(uint256 id);
1265 
1266     /**
1267      * @dev Creates a new snapshot and returns its snapshot id.
1268      *
1269      * Emits a {Snapshot} event that contains the same id.
1270      *
1271      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1272      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1273      *
1274      * [WARNING]
1275      * ====
1276      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1277      * you must consider that it can potentially be used by attackers in two ways.
1278      *
1279      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1280      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1281      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1282      * section above.
1283      *
1284      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1285      * ====
1286      */
1287     function _snapshot() internal virtual returns (uint256) {
1288         _currentSnapshotId.increment();
1289 
1290         uint256 currentId = _currentSnapshotId.current();
1291         emit Snapshot(currentId);
1292         return currentId;
1293     }
1294 
1295     /**
1296      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1297      */
1298     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
1299         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1300 
1301         return snapshotted ? value : balanceOf(account);
1302     }
1303 
1304     /**
1305      * @dev Retrieves the total supply at the time `snapshotId` was created.
1306      */
1307     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
1308         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1309 
1310         return snapshotted ? value : totalSupply();
1311     }
1312 
1313     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
1314     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
1315     // The same is true for the total supply and _mint and _burn.
1316     function _transfer(address from, address to, uint256 value) internal virtual override {
1317         _updateAccountSnapshot(from);
1318         _updateAccountSnapshot(to);
1319 
1320         super._transfer(from, to, value);
1321     }
1322 
1323     function _mint(address account, uint256 value) internal virtual override {
1324         _updateAccountSnapshot(account);
1325         _updateTotalSupplySnapshot();
1326 
1327         super._mint(account, value);
1328     }
1329 
1330     function _burn(address account, uint256 value) internal virtual override {
1331         _updateAccountSnapshot(account);
1332         _updateTotalSupplySnapshot();
1333 
1334         super._burn(account, value);
1335     }
1336 
1337     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
1338         private view returns (bool, uint256)
1339     {
1340         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1341         // solhint-disable-next-line max-line-length
1342         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
1343 
1344         // When a valid snapshot is queried, there are three possibilities:
1345         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1346         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1347         //  to this id is the current one.
1348         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1349         //  requested id, and its value is the one to return.
1350         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1351         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1352         //  larger than the requested one.
1353         //
1354         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1355         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1356         // exactly this.
1357 
1358         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1359 
1360         if (index == snapshots.ids.length) {
1361             return (false, 0);
1362         } else {
1363             return (true, snapshots.values[index]);
1364         }
1365     }
1366 
1367     function _updateAccountSnapshot(address account) private {
1368         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1369     }
1370 
1371     function _updateTotalSupplySnapshot() private {
1372         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1373     }
1374 
1375     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1376         uint256 currentId = _currentSnapshotId.current();
1377         if (_lastSnapshotId(snapshots.ids) < currentId) {
1378             snapshots.ids.push(currentId);
1379             snapshots.values.push(currentValue);
1380         }
1381     }
1382 
1383     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1384         if (ids.length == 0) {
1385             return 0;
1386         } else {
1387             return ids[ids.length - 1];
1388         }
1389     }
1390 }
1391 
1392 
1393 // File contracts/BalancerGovernanceToken.sol
1394 
1395 pragma solidity =0.6.8;
1396 
1397 
1398 
1399 contract BalancerGovernanceToken is AccessControl, ERC20Snapshot {
1400 
1401     string  public constant version  = "1";
1402     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1403     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1404 
1405     bytes32 public immutable DOMAIN_SEPARATOR;
1406     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1407     bytes32 public immutable PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1408     mapping(address => uint) public nonces;
1409 
1410     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1411         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1412         _setupRole(MINTER_ROLE, _msgSender());
1413         _setupRole(SNAPSHOT_ROLE, _msgSender());
1414 
1415         uint256 chainId = _chainID();
1416         DOMAIN_SEPARATOR = keccak256(
1417             abi.encode(
1418                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
1419                 keccak256(bytes(name)),
1420                 keccak256(bytes(version)),
1421                 chainId,
1422                 address(this)
1423             )
1424         );
1425     }
1426 
1427     function _chainID() private pure returns (uint256) {
1428         uint256 chainID;
1429         assembly {
1430             chainID := chainid()
1431         }
1432         return chainID;
1433     }
1434 
1435     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
1436         require(block.timestamp <= deadline, "ERR_EXPIRED_SIG");
1437         bytes32 digest = keccak256(
1438             abi.encodePacked(
1439                 uint16(0x1901),
1440                 DOMAIN_SEPARATOR,
1441                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
1442             )
1443         );
1444         require(owner == _recover(digest, v, r, s), "ERR_INVALID_SIG");
1445         _approve(owner, spender, value);
1446     }
1447 
1448     function _recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) private pure returns (address) {
1449         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1450         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1451         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1452         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1453         //
1454         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1455         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1456         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1457         // these malleable signatures as well.
1458         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1459             revert("ECDSA: invalid signature 's' value");
1460         }
1461 
1462         if (v != 27 && v != 28) {
1463             revert("ECDSA: invalid signature 'v' value");
1464         }
1465 
1466         // If the signature is valid (and not malleable), return the signer address
1467         address signer = ecrecover(hash, v, r, s);
1468         require(signer != address(0), "ECDSA: invalid signature");
1469 
1470         return signer;
1471     }
1472 
1473     function mint(address to, uint256 amount) public virtual {
1474         require(hasRole(MINTER_ROLE, _msgSender()), "ERR_MINTER_ROLE");
1475         _mint(to, amount);
1476     }
1477 
1478     function burn(uint256 amount) public virtual {
1479         _burn(_msgSender(), amount);
1480     }
1481 
1482     function burnFrom(address account, uint256 amount) public virtual {
1483         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1484 
1485         _approve(account, _msgSender(), decreasedAllowance);
1486         _burn(account, amount);
1487     }
1488 
1489     function snapshot() public virtual {
1490         require(hasRole(SNAPSHOT_ROLE, _msgSender()), "ERR_SNAPSHOT_ROLE");
1491         _snapshot();
1492     }
1493 
1494 }