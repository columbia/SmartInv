1 // File: openzeppelin-solidity/contracts/utils/EnumerableSet.sol
2 
3 // SPDX-License-Identifier: MIT
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
247 // File: openzeppelin-solidity/contracts/utils/Address.sol
248 
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
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return _functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         return _functionCallWithValue(target, data, value, errorMessage);
364     }
365 
366     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 // File: openzeppelin-solidity/contracts/GSN/Context.sol
391 
392 
393 pragma solidity ^0.6.0;
394 
395 /*
396  * @dev Provides information about the current execution context, including the
397  * sender of the transaction and its data. While these are generally available
398  * via msg.sender and msg.data, they should not be accessed in such a direct
399  * manner, since when dealing with GSN meta-transactions the account sending and
400  * paying for execution may not be the actual sender (as far as an application
401  * is concerned).
402  *
403  * This contract is only required for intermediate, library-like contracts.
404  */
405 abstract contract Context {
406     function _msgSender() internal view virtual returns (address payable) {
407         return msg.sender;
408     }
409 
410     function _msgData() internal view virtual returns (bytes memory) {
411         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
412         return msg.data;
413     }
414 }
415 
416 // File: openzeppelin-solidity/contracts/access/AccessControl.sol
417 
418 
419 pragma solidity ^0.6.0;
420 
421 
422 
423 
424 /**
425  * @dev Contract module that allows children to implement role-based access
426  * control mechanisms.
427  *
428  * Roles are referred to by their `bytes32` identifier. These should be exposed
429  * in the external API and be unique. The best way to achieve this is by
430  * using `public constant` hash digests:
431  *
432  * ```
433  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
434  * ```
435  *
436  * Roles can be used to represent a set of permissions. To restrict access to a
437  * function call, use {hasRole}:
438  *
439  * ```
440  * function foo() public {
441  *     require(hasRole(MY_ROLE, msg.sender));
442  *     ...
443  * }
444  * ```
445  *
446  * Roles can be granted and revoked dynamically via the {grantRole} and
447  * {revokeRole} functions. Each role has an associated admin role, and only
448  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
449  *
450  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
451  * that only accounts with this role will be able to grant or revoke other
452  * roles. More complex role relationships can be created by using
453  * {_setRoleAdmin}.
454  *
455  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
456  * grant and revoke this role. Extra precautions should be taken to secure
457  * accounts that have been granted it.
458  */
459 abstract contract AccessControl is Context {
460     using EnumerableSet for EnumerableSet.AddressSet;
461     using Address for address;
462 
463     struct RoleData {
464         EnumerableSet.AddressSet members;
465         bytes32 adminRole;
466     }
467 
468     mapping (bytes32 => RoleData) private _roles;
469 
470     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
471 
472     /**
473      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
474      *
475      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
476      * {RoleAdminChanged} not being emitted signaling this.
477      *
478      * _Available since v3.1._
479      */
480     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
481 
482     /**
483      * @dev Emitted when `account` is granted `role`.
484      *
485      * `sender` is the account that originated the contract call, an admin role
486      * bearer except when using {_setupRole}.
487      */
488     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
489 
490     /**
491      * @dev Emitted when `account` is revoked `role`.
492      *
493      * `sender` is the account that originated the contract call:
494      *   - if using `revokeRole`, it is the admin role bearer
495      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
496      */
497     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
498 
499     /**
500      * @dev Returns `true` if `account` has been granted `role`.
501      */
502     function hasRole(bytes32 role, address account) public view returns (bool) {
503         return _roles[role].members.contains(account);
504     }
505 
506     /**
507      * @dev Returns the number of accounts that have `role`. Can be used
508      * together with {getRoleMember} to enumerate all bearers of a role.
509      */
510     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
511         return _roles[role].members.length();
512     }
513 
514     /**
515      * @dev Returns one of the accounts that have `role`. `index` must be a
516      * value between 0 and {getRoleMemberCount}, non-inclusive.
517      *
518      * Role bearers are not sorted in any particular way, and their ordering may
519      * change at any point.
520      *
521      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
522      * you perform all queries on the same block. See the following
523      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
524      * for more information.
525      */
526     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
527         return _roles[role].members.at(index);
528     }
529 
530     /**
531      * @dev Returns the admin role that controls `role`. See {grantRole} and
532      * {revokeRole}.
533      *
534      * To change a role's admin, use {_setRoleAdmin}.
535      */
536     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
537         return _roles[role].adminRole;
538     }
539 
540     /**
541      * @dev Grants `role` to `account`.
542      *
543      * If `account` had not been already granted `role`, emits a {RoleGranted}
544      * event.
545      *
546      * Requirements:
547      *
548      * - the caller must have ``role``'s admin role.
549      */
550     function grantRole(bytes32 role, address account) public virtual {
551         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
552 
553         _grantRole(role, account);
554     }
555 
556     /**
557      * @dev Revokes `role` from `account`.
558      *
559      * If `account` had been granted `role`, emits a {RoleRevoked} event.
560      *
561      * Requirements:
562      *
563      * - the caller must have ``role``'s admin role.
564      */
565     function revokeRole(bytes32 role, address account) public virtual {
566         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
567 
568         _revokeRole(role, account);
569     }
570 
571     /**
572      * @dev Revokes `role` from the calling account.
573      *
574      * Roles are often managed via {grantRole} and {revokeRole}: this function's
575      * purpose is to provide a mechanism for accounts to lose their privileges
576      * if they are compromised (such as when a trusted device is misplaced).
577      *
578      * If the calling account had been granted `role`, emits a {RoleRevoked}
579      * event.
580      *
581      * Requirements:
582      *
583      * - the caller must be `account`.
584      */
585     function renounceRole(bytes32 role, address account) public virtual {
586         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
587 
588         _revokeRole(role, account);
589     }
590 
591     /**
592      * @dev Grants `role` to `account`.
593      *
594      * If `account` had not been already granted `role`, emits a {RoleGranted}
595      * event. Note that unlike {grantRole}, this function doesn't perform any
596      * checks on the calling account.
597      *
598      * [WARNING]
599      * ====
600      * This function should only be called from the constructor when setting
601      * up the initial roles for the system.
602      *
603      * Using this function in any other way is effectively circumventing the admin
604      * system imposed by {AccessControl}.
605      * ====
606      */
607     function _setupRole(bytes32 role, address account) internal virtual {
608         _grantRole(role, account);
609     }
610 
611     /**
612      * @dev Sets `adminRole` as ``role``'s admin role.
613      *
614      * Emits a {RoleAdminChanged} event.
615      */
616     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
617         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
618         _roles[role].adminRole = adminRole;
619     }
620 
621     function _grantRole(bytes32 role, address account) private {
622         if (_roles[role].members.add(account)) {
623             emit RoleGranted(role, account, _msgSender());
624         }
625     }
626 
627     function _revokeRole(bytes32 role, address account) private {
628         if (_roles[role].members.remove(account)) {
629             emit RoleRevoked(role, account, _msgSender());
630         }
631     }
632 }
633 
634 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
635 
636 
637 pragma solidity ^0.6.0;
638 
639 /**
640  * @dev Wrappers over Solidity's arithmetic operations with added overflow
641  * checks.
642  *
643  * Arithmetic operations in Solidity wrap on overflow. This can easily result
644  * in bugs, because programmers usually assume that an overflow raises an
645  * error, which is the standard behavior in high level programming languages.
646  * `SafeMath` restores this intuition by reverting the transaction when an
647  * operation overflows.
648  *
649  * Using this library instead of the unchecked operations eliminates an entire
650  * class of bugs, so it's recommended to use it always.
651  */
652 library SafeMath {
653     /**
654      * @dev Returns the addition of two unsigned integers, reverting on
655      * overflow.
656      *
657      * Counterpart to Solidity's `+` operator.
658      *
659      * Requirements:
660      *
661      * - Addition cannot overflow.
662      */
663     function add(uint256 a, uint256 b) internal pure returns (uint256) {
664         uint256 c = a + b;
665         require(c >= a, "SafeMath: addition overflow");
666 
667         return c;
668     }
669 
670     /**
671      * @dev Returns the subtraction of two unsigned integers, reverting on
672      * overflow (when the result is negative).
673      *
674      * Counterpart to Solidity's `-` operator.
675      *
676      * Requirements:
677      *
678      * - Subtraction cannot overflow.
679      */
680     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
681         return sub(a, b, "SafeMath: subtraction overflow");
682     }
683 
684     /**
685      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
686      * overflow (when the result is negative).
687      *
688      * Counterpart to Solidity's `-` operator.
689      *
690      * Requirements:
691      *
692      * - Subtraction cannot overflow.
693      */
694     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
695         require(b <= a, errorMessage);
696         uint256 c = a - b;
697 
698         return c;
699     }
700 
701     /**
702      * @dev Returns the multiplication of two unsigned integers, reverting on
703      * overflow.
704      *
705      * Counterpart to Solidity's `*` operator.
706      *
707      * Requirements:
708      *
709      * - Multiplication cannot overflow.
710      */
711     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
712         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
713         // benefit is lost if 'b' is also tested.
714         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
715         if (a == 0) {
716             return 0;
717         }
718 
719         uint256 c = a * b;
720         require(c / a == b, "SafeMath: multiplication overflow");
721 
722         return c;
723     }
724 
725     /**
726      * @dev Returns the integer division of two unsigned integers. Reverts on
727      * division by zero. The result is rounded towards zero.
728      *
729      * Counterpart to Solidity's `/` operator. Note: this function uses a
730      * `revert` opcode (which leaves remaining gas untouched) while Solidity
731      * uses an invalid opcode to revert (consuming all remaining gas).
732      *
733      * Requirements:
734      *
735      * - The divisor cannot be zero.
736      */
737     function div(uint256 a, uint256 b) internal pure returns (uint256) {
738         return div(a, b, "SafeMath: division by zero");
739     }
740 
741     /**
742      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
743      * division by zero. The result is rounded towards zero.
744      *
745      * Counterpart to Solidity's `/` operator. Note: this function uses a
746      * `revert` opcode (which leaves remaining gas untouched) while Solidity
747      * uses an invalid opcode to revert (consuming all remaining gas).
748      *
749      * Requirements:
750      *
751      * - The divisor cannot be zero.
752      */
753     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
754         require(b > 0, errorMessage);
755         uint256 c = a / b;
756         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
757 
758         return c;
759     }
760 
761     /**
762      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
763      * Reverts when dividing by zero.
764      *
765      * Counterpart to Solidity's `%` operator. This function uses a `revert`
766      * opcode (which leaves remaining gas untouched) while Solidity uses an
767      * invalid opcode to revert (consuming all remaining gas).
768      *
769      * Requirements:
770      *
771      * - The divisor cannot be zero.
772      */
773     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
774         return mod(a, b, "SafeMath: modulo by zero");
775     }
776 
777     /**
778      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
779      * Reverts with custom message when dividing by zero.
780      *
781      * Counterpart to Solidity's `%` operator. This function uses a `revert`
782      * opcode (which leaves remaining gas untouched) while Solidity uses an
783      * invalid opcode to revert (consuming all remaining gas).
784      *
785      * Requirements:
786      *
787      * - The divisor cannot be zero.
788      */
789     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
790         require(b != 0, errorMessage);
791         return a % b;
792     }
793 }
794 
795 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
796 
797 
798 pragma solidity ^0.6.0;
799 
800 /**
801  * @dev Interface of the ERC20 standard as defined in the EIP.
802  */
803 interface IERC20 {
804     /**
805      * @dev Returns the amount of tokens in existence.
806      */
807     function totalSupply() external view returns (uint256);
808 
809     /**
810      * @dev Returns the amount of tokens owned by `account`.
811      */
812     function balanceOf(address account) external view returns (uint256);
813 
814     /**
815      * @dev Moves `amount` tokens from the caller's account to `recipient`.
816      *
817      * Returns a boolean value indicating whether the operation succeeded.
818      *
819      * Emits a {Transfer} event.
820      */
821     function transfer(address recipient, uint256 amount) external returns (bool);
822 
823     /**
824      * @dev Returns the remaining number of tokens that `spender` will be
825      * allowed to spend on behalf of `owner` through {transferFrom}. This is
826      * zero by default.
827      *
828      * This value changes when {approve} or {transferFrom} are called.
829      */
830     function allowance(address owner, address spender) external view returns (uint256);
831 
832     /**
833      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
834      *
835      * Returns a boolean value indicating whether the operation succeeded.
836      *
837      * IMPORTANT: Beware that changing an allowance with this method brings the risk
838      * that someone may use both the old and the new allowance by unfortunate
839      * transaction ordering. One possible solution to mitigate this race
840      * condition is to first reduce the spender's allowance to 0 and set the
841      * desired value afterwards:
842      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
843      *
844      * Emits an {Approval} event.
845      */
846     function approve(address spender, uint256 amount) external returns (bool);
847 
848     /**
849      * @dev Moves `amount` tokens from `sender` to `recipient` using the
850      * allowance mechanism. `amount` is then deducted from the caller's
851      * allowance.
852      *
853      * Returns a boolean value indicating whether the operation succeeded.
854      *
855      * Emits a {Transfer} event.
856      */
857     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
858 
859     /**
860      * @dev Emitted when `value` tokens are moved from one account (`from`) to
861      * another (`to`).
862      *
863      * Note that `value` may be zero.
864      */
865     event Transfer(address indexed from, address indexed to, uint256 value);
866 
867     /**
868      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
869      * a call to {approve}. `value` is the new allowance.
870      */
871     event Approval(address indexed owner, address indexed spender, uint256 value);
872 }
873 
874 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
875 
876 
877 pragma solidity ^0.6.0;
878 
879 
880 
881 
882 /**
883  * @title SafeERC20
884  * @dev Wrappers around ERC20 operations that throw on failure (when the token
885  * contract returns false). Tokens that return no value (and instead revert or
886  * throw on failure) are also supported, non-reverting calls are assumed to be
887  * successful.
888  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
889  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
890  */
891 library SafeERC20 {
892     using SafeMath for uint256;
893     using Address for address;
894 
895     function safeTransfer(IERC20 token, address to, uint256 value) internal {
896         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
897     }
898 
899     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
900         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
901     }
902 
903     /**
904      * @dev Deprecated. This function has issues similar to the ones found in
905      * {IERC20-approve}, and its usage is discouraged.
906      *
907      * Whenever possible, use {safeIncreaseAllowance} and
908      * {safeDecreaseAllowance} instead.
909      */
910     function safeApprove(IERC20 token, address spender, uint256 value) internal {
911         // safeApprove should only be called when setting an initial allowance,
912         // or when resetting it to zero. To increase and decrease it, use
913         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
914         // solhint-disable-next-line max-line-length
915         require((value == 0) || (token.allowance(address(this), spender) == 0),
916             "SafeERC20: approve from non-zero to non-zero allowance"
917         );
918         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
919     }
920 
921     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
922         uint256 newAllowance = token.allowance(address(this), spender).add(value);
923         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
924     }
925 
926     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
927         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
928         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
929     }
930 
931     /**
932      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
933      * on the return value: the return value is optional (but if data is returned, it must not be false).
934      * @param token The token targeted by the call.
935      * @param data The call data (encoded using abi.encode or one of its variants).
936      */
937     function _callOptionalReturn(IERC20 token, bytes memory data) private {
938         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
939         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
940         // the target address contains contract code and also asserts for success in the low-level call.
941 
942         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
943         if (returndata.length > 0) { // Return data is optional
944             // solhint-disable-next-line max-line-length
945             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
946         }
947     }
948 }
949 
950 // File: contracts/ConvergentAuction.sol
951 
952 
953 pragma solidity ^0.6.12;
954 
955 
956 
957 
958 
959 interface SupportsWhitelisting {
960   function addToWhiteList(address account) external;
961 }
962 
963 contract ConvergentAuction is AccessControl, SupportsWhitelisting {
964     using SafeMath for uint256;
965     using SafeERC20 for IERC20;
966 
967     bytes32 private constant WHITELIST = keccak256("WHITELIST"); // whitelist role
968     bytes32 private constant WHITELIST_ADMIN = keccak256("WHITELIST_ADMIN"); // whitelist admin role
969 
970     uint256 private constant price_external_multiplier = 100; // price we recieve is multiplied by 100, which allows 2 decimals
971     uint256 private constant price_internal_multiplier = 1;
972     uint256 private constant price_divisor = 100; 
973 
974     uint256 private constant at_unit = 1_000_000; // unit of auctioned token, 6 decimals
975     uint256 private constant pt_unit = 1_000_000; // unit of payment token, 6 decimals
976 
977     uint private constant dayish = 86400; 
978     
979     uint256 public min_price; // Minimal price
980     uint256 private max_price; // Maximal price
981     uint256 private constant min_amount = 10 * at_unit;
982     uint256 private constant tokens_for_sale = 211_500 * at_unit;
983 
984     // each point allows increase by 0.1% of the original_price
985     uint[5] daily_increase_points = [
986         900,
987         700,
988         500,
989         300,
990         100
991     ];
992 
993     address private _owner;
994     uint public _start_time;
995     bool private _threshold_finalized = false;
996     uint private _distributed_count = 0;
997     IERC20 public auctioned_token;
998     IERC20 public payment_token;
999     uint256 public threshold_price;
1000     uint256 public threshold_ratio; // execution ration for bids exactly at threshold_price, should be divided by 1000
1001 
1002     struct Bid {
1003         address bid_address;
1004         uint64 amount;
1005         uint16 original_price;
1006         uint16 price;
1007         uint32 last_update;
1008         uint8 day_of_auction;
1009         uint16 points_used;
1010         bool distributed;
1011     }
1012     
1013     Bid[] private _bids;    
1014     mapping (address => uint) private bid_indices; // index in _bids array plus one
1015 
1016     modifier whenAuctionGoing() {
1017         require(isInSubmissionPhase() || isInBiddingPhase(), "auction is not going");
1018         _;
1019     }
1020 
1021     modifier whenAuctionEnded() {
1022         require(auctionEnded(), "auction is still on going");
1023         _;
1024     }
1025 
1026     modifier isThresholdFinalized() {
1027         require(_threshold_finalized == true, "auction threshold was not finalized yet");
1028         _;
1029     }
1030 
1031     event WhitelistAdded(address indexed account);
1032     event ThresholdSet(uint256 price, uint256 ratio);
1033     event BidCreated(address indexed account, uint256 amount, uint256 price);
1034     event BidUpdated(address indexed account, uint256 amount, uint256 price);
1035 
1036     // compute amount of payment tokens corresponding to purchase of amount of auctioned tokens at price
1037     // we assume that price was multiplied by price_external_multiplier by the front-end
1038     function compute_payment(uint256 amount, uint256 price) internal pure returns (uint256) {
1039        return amount.mul(price).mul(price_internal_multiplier).div(price_divisor);
1040     }
1041 
1042     constructor(address owner, address wl_admin, uint _min_price, uint start_time, IERC20 a_token, IERC20 p_token) public {
1043         // make sure that unit scaling is consistent
1044         // for 1 unit of auctioned token and price of 1 (which is scaled by price_external_multiplier) we should get 1 unit of payment unit
1045         require(compute_payment(at_unit, price_external_multiplier) == pt_unit, "units not consistent");
1046         require(start_time >= block.timestamp, "start time should be in the future time");
1047 
1048         min_price = _min_price;
1049         max_price = _min_price.mul(100);
1050         
1051         _owner = owner;
1052         _setupRole(DEFAULT_ADMIN_ROLE, owner); // owner can change wl admin list via grantRole/revokeRole
1053         _setRoleAdmin(WHITELIST, WHITELIST_ADMIN); // accounts with WHITELIST_ADMIN role will be able to add accounts to WHITELIST role
1054         _setupRole(WHITELIST_ADMIN, wl_admin); // start with one whitelist admin
1055         _start_time = start_time;
1056         auctioned_token = a_token;
1057         payment_token = p_token;
1058     }
1059 
1060     /**
1061      * @dev Returns the address of the current owner.
1062      */
1063     function owner() public view returns (address) {
1064         return _owner;
1065     }
1066 
1067     /**
1068      * @dev Throws if called by any account other than the owner.
1069      */
1070     modifier onlyOwner() {
1071         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1072         _;
1073     }
1074 
1075     function isInSubmissionPhase() public view returns (bool) {
1076         return (block.timestamp >= _start_time && block.timestamp <= _start_time + (2 * dayish));
1077     }
1078 
1079     function isInBiddingPhase() public view returns (bool) {
1080         return (block.timestamp > _start_time + (2 * dayish) && block.timestamp <= _start_time + (7 * dayish));
1081     }
1082 
1083     function auctionEnded() public view returns (bool) {
1084         return block.timestamp > _start_time + (7 * dayish);
1085     }
1086 
1087     /**
1088      * @dev admin can add a specific address to white list address
1089      */
1090     function addToWhiteList(address account) external override {
1091         // caller must have WHITELIST_ADMIN role
1092         grantRole(WHITELIST, account);
1093         emit WhitelistAdded(account);
1094     }
1095     
1096     function create_bid(uint64 amount, uint16 price) external whenAuctionGoing {
1097         address _sender = _msgSender();
1098         // verify that auction token was already fully deposited into the smart contract
1099         if (_bids.length == 0) {
1100             require(auctioned_token.balanceOf(address(this)) >= tokens_for_sale, 'auction token was not deposited enough');
1101         }
1102         // only white list address can join the auction
1103         require(hasRole(WHITELIST, _sender), "AccessControl: only white list address can join the auction");
1104         // check bidding submission is still allowed
1105         require(isInSubmissionPhase(), "submission time is over");
1106         // check parameter sanity
1107         require(bid_indices[_sender] == 0, "bidder already exists");
1108         require(price >= min_price && price <= max_price, "bidding price is out of range");
1109         require(amount >= min_amount, "too small amount");
1110 
1111         Bid storage bid = _bids.push();
1112         bid.bid_address = _sender;
1113         bid.amount = amount;
1114         bid.original_price = price;
1115         bid.price = price;
1116         bid.last_update = uint32(block.timestamp);
1117         // the rest of fields are zero-initialized
1118         bid_indices[_sender] = _bids.length; // note: starting from 1
1119         payment_token.safeTransferFrom(_sender, address(this), compute_payment(amount, price));
1120         emit BidCreated(_sender, amount, price);
1121     }
1122 
1123     // this function is called only from the client 
1124     function max_price_increase_allowed(address bidder) external view returns (uint256) {
1125         require(bid_indices[bidder] > 0, "bid does not exist");
1126         Bid storage bid = _bids[bid_indices[bidder] - 1];
1127         if (isInBiddingPhase()) {
1128             uint8 day_of_auction = uint8((block.timestamp - _start_time) / dayish);
1129             uint points_used = 0;
1130             uint this_day_increase_points = daily_increase_points[day_of_auction-2];
1131             
1132             if (bid.day_of_auction == day_of_auction) {
1133               points_used = bid.points_used;
1134             }
1135 
1136             if (points_used >= this_day_increase_points) {
1137               return bid.price;
1138             }
1139             uint points_usable = this_day_increase_points - points_used - 1; // we remove 1 point to compensate for different rounding
1140 
1141             uint calc_max_price = ((points_usable.mul(bid.original_price)).div(1000)).add(bid.price);
1142             
1143             if (calc_max_price <= max_price)
1144               return calc_max_price;
1145             else
1146               return max_price;
1147         } else {
1148           return max_price;
1149         }
1150 
1151     }
1152     
1153     function update_bid(uint64 amount, uint16 price) external whenAuctionGoing {
1154         address _sender = _msgSender();
1155         require(bid_indices[_sender] > 0, "bid does not exist");
1156         Bid storage bid = _bids[bid_indices[_sender] - 1];
1157         // updating bid can't be more often than once an hour
1158         require(block.timestamp - bid.last_update >= (dayish/24), "updating bid can't be more often than once an hour");
1159         bid.last_update = uint32(block.timestamp);
1160         // sanity check
1161         require(price <= max_price, "bidding price is out of range");
1162         require(price >= bid.price, "new price must be greater or equal to current price");
1163         require(amount >= min_amount, "too small amount");
1164         
1165         uint256 old_collateral = compute_payment(bid.amount, bid.price);
1166         uint256 new_collateral = compute_payment(amount, price);
1167         require(new_collateral >= old_collateral, "collateral cannot be decreased");
1168 
1169         // restrict update amount & price after 2 days of the submission phase
1170         if (isInBiddingPhase()) {
1171             require(price > bid.price, "new price must be greater than current price");
1172             require(amount <= bid.amount, "new amount must be less than or equal to current amount");
1173             uint8 day_of_auction = uint8((block.timestamp - _start_time) / dayish);
1174             if (bid.day_of_auction < day_of_auction) { // reset points_used on new day 
1175                 bid.day_of_auction = day_of_auction;
1176                 bid.points_used = 0;
1177             }
1178 
1179             // how many increase points are needed for this price increase?
1180             uint points_needed =  uint(price - bid.price).mul(1000).div( bid.original_price );
1181             uint points_this_day = daily_increase_points[day_of_auction-2];
1182             
1183             require(  points_needed.add( bid.points_used ) <=  points_this_day,
1184                       "price is over maximum daily price increment allowance");
1185             bid.points_used = uint16(bid.points_used + points_needed); // overflow is impossible
1186         } else if (isInSubmissionPhase()) {
1187             // update original_price also
1188             bid.original_price = price;
1189         }
1190 
1191         // first two days have no restriction on price increase
1192         bid.amount = amount;
1193         bid.price = price;
1194 
1195         if (new_collateral > old_collateral) {
1196             payment_token.safeTransferFrom(_sender, address(this), new_collateral.sub(old_collateral));
1197         }
1198         emit BidUpdated(_sender, amount, price);
1199     }
1200 
1201     /**
1202      * @dev get bid detail of the specific address
1203      */
1204     function getBid(address addr) external view returns (address, uint256, uint256, uint256, uint, uint, uint, bool) {
1205         Bid memory bid = _bids[bid_indices[addr] - 1];
1206         return (bid.bid_address, 
1207                 bid.amount, 
1208                 bid.original_price, 
1209                 bid.price, 
1210                 bid.last_update, 
1211                 bid.day_of_auction,
1212                 bid.points_used, 
1213                 bid.distributed);
1214     }
1215 
1216     /**
1217      * @dev return array of bids (bid_address, amount, price) joining in the auction to calculate threshold price and threshold ratio off-chain
1218      */
1219     function getBids(uint from, uint count) external view returns (address[] memory, uint256[] memory, uint256[] memory)
1220     {
1221         uint length = from + count;
1222         require(from >= 0 && from < _bids.length && count > 0 && length <= _bids.length, "index out of range");
1223         address[] memory addresses = new address[](count);
1224         uint256[] memory amounts = new uint256[](count);
1225         uint256[] memory prices = new uint256[](count);
1226         uint j = 0;
1227         for (uint i = from; i < length; i++) {
1228             Bid storage bid = _bids[i];
1229             addresses[j] = bid.bid_address;
1230             amounts[j] = bid.amount;
1231             prices[j] = bid.price;
1232             j++;
1233         }
1234         return (addresses, amounts, prices);
1235     }
1236     
1237     function getBidsExtra(uint from, uint count) external view
1238       returns (uint[] memory original_price, uint[] memory last_update, uint[] memory day_of_auction,
1239                uint[] memory points_used, bool[] memory distributed)
1240     {
1241         uint length = from + count;
1242         original_price = new uint[](count);
1243         last_update = new uint[](count);
1244         day_of_auction = new uint[](count);
1245         points_used = new uint[](count);
1246         distributed = new bool[](count);
1247         
1248         require(from >= 0 && from < _bids.length && count > 0 && length <= _bids.length, "index out of range");
1249         uint j = 0;
1250         for (uint i = from; i < length; i++) {
1251             Bid storage bid = _bids[i];
1252             original_price[j] = bid.original_price;
1253             last_update[j] = bid.last_update;
1254             day_of_auction[j] = bid.day_of_auction;
1255             points_used[j] = bid.points_used;
1256             distributed[j] = bid.distributed;
1257             j++;
1258         }
1259     }
1260 
1261     /**
1262      * @dev return the total number of bids
1263      */
1264     function getBidCount() external view returns (uint) {
1265         return _bids.length;
1266     }
1267 
1268     /**
1269      * @dev contract owner can set temporarily current threshold price and ratio.
1270      * Do not allow to reset threshold price and ratio when the auction already ended.
1271      */
1272     function setThreshold(uint256 price, uint256 ratio) external onlyOwner whenAuctionEnded {
1273         require(_threshold_finalized == false, "threshold already finalized");
1274         require(price >= min_price && price <= max_price, 'threshold price is out of range');
1275         require(ratio >= 0 && ratio <= 1000, 'threshold ratio is out of range');
1276         require(_distributed_count == 0); // if we started "distributing" before setThreshold via returnCollateral, the auction is considered failed, and cannot be finalized.
1277         threshold_price = price;
1278         threshold_ratio = ratio;
1279         _threshold_finalized = true;
1280         emit ThresholdSet(price, ratio);
1281     }
1282 
1283     function distributeTokens(address addr) public isThresholdFinalized {
1284         require(bid_indices[addr] > 0);
1285         Bid storage bid = _bids[bid_indices[addr] - 1];
1286         require(bid.distributed == false);
1287         bid.distributed = true;
1288         _distributed_count++;
1289         if (bid.price >= threshold_price) {
1290             uint256 b_amount = bid.amount;
1291             if (bid.price == threshold_price && threshold_ratio != 1000) {
1292                 // reduce bought amount using ratio
1293                 b_amount = b_amount.mul(threshold_ratio).div(1000);
1294             }
1295             
1296             uint256 unused_collateral = compute_payment(bid.amount, bid.price).sub(compute_payment(b_amount, threshold_price));
1297             if (unused_collateral > 0) {
1298                 payment_token.safeTransfer(addr, unused_collateral);
1299             }
1300             auctioned_token.safeTransfer(addr, b_amount);
1301         } else {
1302             // bid haven't won, just return the collateral
1303             payment_token.safeTransfer(addr, compute_payment(bid.amount, bid.price));
1304         }
1305     }
1306 
1307     function distributeTokensMulti(uint from, uint count) external isThresholdFinalized {
1308         for (uint i = from; i < from + count; i++) {
1309             Bid storage bid = _bids[i];
1310             
1311             address addr = bid.bid_address;
1312             if (addr != address(0x0) && !bid.distributed)
1313               distributeTokens(addr);
1314        }
1315     }
1316 
1317     function returnCollateral(address addr) external whenAuctionEnded {
1318         require(block.timestamp > _start_time + (10 * dayish), "funds are still locked for auction");
1319         require(_threshold_finalized == false, "auction threshold was already set to proceed");
1320         require(bid_indices[addr] > 0);
1321         Bid storage bid = _bids[bid_indices[addr] - 1];
1322         require(bid.distributed == false);
1323         bid.distributed = true;
1324         _distributed_count++;
1325         payment_token.safeTransfer(addr, compute_payment(bid.amount, bid.price));
1326     }
1327 
1328     /**
1329      * @dev owner should be able to withdraw proceedings
1330      */
1331     function withdraw(address addr) external onlyOwner whenAuctionEnded {
1332         require(_distributed_count >= _bids.length, "still not fully distribute token for the bidders");
1333         payment_token.safeTransfer(addr, payment_token.balanceOf(address(this)));
1334         auctioned_token.safeTransfer(addr, auctioned_token.balanceOf(address(this)));
1335     }
1336 }