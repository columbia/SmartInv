1 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
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
247 // File: @openzeppelin/contracts/utils/Address.sol
248 
249 // 
250 
251 pragma solidity ^0.6.2;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies in extcodesize, which returns 0 for contracts in
276         // construction, since the code is only stored at the end of the
277         // constructor execution.
278 
279         uint256 size;
280         // solhint-disable-next-line no-inline-assembly
281         assembly { size := extcodesize(account) }
282         return size > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
305         (bool success, ) = recipient.call{ value: amount }("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain`call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328       return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
338         return _functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         return _functionCallWithValue(target, data, value, errorMessage);
365     }
366 
367     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
368         require(isContract(target), "Address: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 // solhint-disable-next-line no-inline-assembly
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 // File: @openzeppelin/contracts/GSN/Context.sol
392 
393 // 
394 
395 pragma solidity ^0.6.0;
396 
397 /*
398  * @dev Provides information about the current execution context, including the
399  * sender of the transaction and its data. While these are generally available
400  * via msg.sender and msg.data, they should not be accessed in such a direct
401  * manner, since when dealing with GSN meta-transactions the account sending and
402  * paying for execution may not be the actual sender (as far as an application
403  * is concerned).
404  *
405  * This contract is only required for intermediate, library-like contracts.
406  */
407 abstract contract Context {
408     function _msgSender() internal view virtual returns (address payable) {
409         return msg.sender;
410     }
411 
412     function _msgData() internal view virtual returns (bytes memory) {
413         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
414         return msg.data;
415     }
416 }
417 
418 // File: @openzeppelin/contracts/access/AccessControl.sol
419 
420 // 
421 
422 pragma solidity ^0.6.0;
423 
424 
425 
426 
427 /**
428  * @dev Contract module that allows children to implement role-based access
429  * control mechanisms.
430  *
431  * Roles are referred to by their `bytes32` identifier. These should be exposed
432  * in the external API and be unique. The best way to achieve this is by
433  * using `public constant` hash digests:
434  *
435  * ```
436  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
437  * ```
438  *
439  * Roles can be used to represent a set of permissions. To restrict access to a
440  * function call, use {hasRole}:
441  *
442  * ```
443  * function foo() public {
444  *     require(hasRole(MY_ROLE, msg.sender));
445  *     ...
446  * }
447  * ```
448  *
449  * Roles can be granted and revoked dynamically via the {grantRole} and
450  * {revokeRole} functions. Each role has an associated admin role, and only
451  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
452  *
453  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
454  * that only accounts with this role will be able to grant or revoke other
455  * roles. More complex role relationships can be created by using
456  * {_setRoleAdmin}.
457  *
458  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
459  * grant and revoke this role. Extra precautions should be taken to secure
460  * accounts that have been granted it.
461  */
462 abstract contract AccessControl is Context {
463     using EnumerableSet for EnumerableSet.AddressSet;
464     using Address for address;
465 
466     struct RoleData {
467         EnumerableSet.AddressSet members;
468         bytes32 adminRole;
469     }
470 
471     mapping (bytes32 => RoleData) private _roles;
472 
473     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
474 
475     /**
476      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
477      *
478      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
479      * {RoleAdminChanged} not being emitted signaling this.
480      *
481      * _Available since v3.1._
482      */
483     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
484 
485     /**
486      * @dev Emitted when `account` is granted `role`.
487      *
488      * `sender` is the account that originated the contract call, an admin role
489      * bearer except when using {_setupRole}.
490      */
491     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
492 
493     /**
494      * @dev Emitted when `account` is revoked `role`.
495      *
496      * `sender` is the account that originated the contract call:
497      *   - if using `revokeRole`, it is the admin role bearer
498      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
499      */
500     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
501 
502     /**
503      * @dev Returns `true` if `account` has been granted `role`.
504      */
505     function hasRole(bytes32 role, address account) public view returns (bool) {
506         return _roles[role].members.contains(account);
507     }
508 
509     /**
510      * @dev Returns the number of accounts that have `role`. Can be used
511      * together with {getRoleMember} to enumerate all bearers of a role.
512      */
513     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
514         return _roles[role].members.length();
515     }
516 
517     /**
518      * @dev Returns one of the accounts that have `role`. `index` must be a
519      * value between 0 and {getRoleMemberCount}, non-inclusive.
520      *
521      * Role bearers are not sorted in any particular way, and their ordering may
522      * change at any point.
523      *
524      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
525      * you perform all queries on the same block. See the following
526      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
527      * for more information.
528      */
529     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
530         return _roles[role].members.at(index);
531     }
532 
533     /**
534      * @dev Returns the admin role that controls `role`. See {grantRole} and
535      * {revokeRole}.
536      *
537      * To change a role's admin, use {_setRoleAdmin}.
538      */
539     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
540         return _roles[role].adminRole;
541     }
542 
543     /**
544      * @dev Grants `role` to `account`.
545      *
546      * If `account` had not been already granted `role`, emits a {RoleGranted}
547      * event.
548      *
549      * Requirements:
550      *
551      * - the caller must have ``role``'s admin role.
552      */
553     function grantRole(bytes32 role, address account) public virtual {
554         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
555 
556         _grantRole(role, account);
557     }
558 
559     /**
560      * @dev Revokes `role` from `account`.
561      *
562      * If `account` had been granted `role`, emits a {RoleRevoked} event.
563      *
564      * Requirements:
565      *
566      * - the caller must have ``role``'s admin role.
567      */
568     function revokeRole(bytes32 role, address account) public virtual {
569         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
570 
571         _revokeRole(role, account);
572     }
573 
574     /**
575      * @dev Revokes `role` from the calling account.
576      *
577      * Roles are often managed via {grantRole} and {revokeRole}: this function's
578      * purpose is to provide a mechanism for accounts to lose their privileges
579      * if they are compromised (such as when a trusted device is misplaced).
580      *
581      * If the calling account had been granted `role`, emits a {RoleRevoked}
582      * event.
583      *
584      * Requirements:
585      *
586      * - the caller must be `account`.
587      */
588     function renounceRole(bytes32 role, address account) public virtual {
589         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
590 
591         _revokeRole(role, account);
592     }
593 
594     /**
595      * @dev Grants `role` to `account`.
596      *
597      * If `account` had not been already granted `role`, emits a {RoleGranted}
598      * event. Note that unlike {grantRole}, this function doesn't perform any
599      * checks on the calling account.
600      *
601      * [WARNING]
602      * ====
603      * This function should only be called from the constructor when setting
604      * up the initial roles for the system.
605      *
606      * Using this function in any other way is effectively circumventing the admin
607      * system imposed by {AccessControl}.
608      * ====
609      */
610     function _setupRole(bytes32 role, address account) internal virtual {
611         _grantRole(role, account);
612     }
613 
614     /**
615      * @dev Sets `adminRole` as ``role``'s admin role.
616      *
617      * Emits a {RoleAdminChanged} event.
618      */
619     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
620         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
621         _roles[role].adminRole = adminRole;
622     }
623 
624     function _grantRole(bytes32 role, address account) private {
625         if (_roles[role].members.add(account)) {
626             emit RoleGranted(role, account, _msgSender());
627         }
628     }
629 
630     function _revokeRole(bytes32 role, address account) private {
631         if (_roles[role].members.remove(account)) {
632             emit RoleRevoked(role, account, _msgSender());
633         }
634     }
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
638 
639 // 
640 
641 pragma solidity ^0.6.0;
642 
643 /**
644  * @dev Interface of the ERC20 standard as defined in the EIP.
645  */
646 interface IERC20 {
647     /**
648      * @dev Returns the amount of tokens in existence.
649      */
650     function totalSupply() external view returns (uint256);
651 
652     /**
653      * @dev Returns the amount of tokens owned by `account`.
654      */
655     function balanceOf(address account) external view returns (uint256);
656 
657     /**
658      * @dev Moves `amount` tokens from the caller's account to `recipient`.
659      *
660      * Returns a boolean value indicating whether the operation succeeded.
661      *
662      * Emits a {Transfer} event.
663      */
664     function transfer(address recipient, uint256 amount) external returns (bool);
665 
666     /**
667      * @dev Returns the remaining number of tokens that `spender` will be
668      * allowed to spend on behalf of `owner` through {transferFrom}. This is
669      * zero by default.
670      *
671      * This value changes when {approve} or {transferFrom} are called.
672      */
673     function allowance(address owner, address spender) external view returns (uint256);
674 
675     /**
676      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
677      *
678      * Returns a boolean value indicating whether the operation succeeded.
679      *
680      * IMPORTANT: Beware that changing an allowance with this method brings the risk
681      * that someone may use both the old and the new allowance by unfortunate
682      * transaction ordering. One possible solution to mitigate this race
683      * condition is to first reduce the spender's allowance to 0 and set the
684      * desired value afterwards:
685      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
686      *
687      * Emits an {Approval} event.
688      */
689     function approve(address spender, uint256 amount) external returns (bool);
690 
691     /**
692      * @dev Moves `amount` tokens from `sender` to `recipient` using the
693      * allowance mechanism. `amount` is then deducted from the caller's
694      * allowance.
695      *
696      * Returns a boolean value indicating whether the operation succeeded.
697      *
698      * Emits a {Transfer} event.
699      */
700     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
701 
702     /**
703      * @dev Emitted when `value` tokens are moved from one account (`from`) to
704      * another (`to`).
705      *
706      * Note that `value` may be zero.
707      */
708     event Transfer(address indexed from, address indexed to, uint256 value);
709 
710     /**
711      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
712      * a call to {approve}. `value` is the new allowance.
713      */
714     event Approval(address indexed owner, address indexed spender, uint256 value);
715 }
716 
717 // File: @openzeppelin/contracts/math/SafeMath.sol
718 
719 // 
720 
721 pragma solidity ^0.6.0;
722 
723 /**
724  * @dev Wrappers over Solidity's arithmetic operations with added overflow
725  * checks.
726  *
727  * Arithmetic operations in Solidity wrap on overflow. This can easily result
728  * in bugs, because programmers usually assume that an overflow raises an
729  * error, which is the standard behavior in high level programming languages.
730  * `SafeMath` restores this intuition by reverting the transaction when an
731  * operation overflows.
732  *
733  * Using this library instead of the unchecked operations eliminates an entire
734  * class of bugs, so it's recommended to use it always.
735  */
736 library SafeMath {
737     /**
738      * @dev Returns the addition of two unsigned integers, reverting on
739      * overflow.
740      *
741      * Counterpart to Solidity's `+` operator.
742      *
743      * Requirements:
744      *
745      * - Addition cannot overflow.
746      */
747     function add(uint256 a, uint256 b) internal pure returns (uint256) {
748         uint256 c = a + b;
749         require(c >= a, "SafeMath: addition overflow");
750 
751         return c;
752     }
753 
754     /**
755      * @dev Returns the subtraction of two unsigned integers, reverting on
756      * overflow (when the result is negative).
757      *
758      * Counterpart to Solidity's `-` operator.
759      *
760      * Requirements:
761      *
762      * - Subtraction cannot overflow.
763      */
764     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
765         return sub(a, b, "SafeMath: subtraction overflow");
766     }
767 
768     /**
769      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
770      * overflow (when the result is negative).
771      *
772      * Counterpart to Solidity's `-` operator.
773      *
774      * Requirements:
775      *
776      * - Subtraction cannot overflow.
777      */
778     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
779         require(b <= a, errorMessage);
780         uint256 c = a - b;
781 
782         return c;
783     }
784 
785     /**
786      * @dev Returns the multiplication of two unsigned integers, reverting on
787      * overflow.
788      *
789      * Counterpart to Solidity's `*` operator.
790      *
791      * Requirements:
792      *
793      * - Multiplication cannot overflow.
794      */
795     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
796         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
797         // benefit is lost if 'b' is also tested.
798         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
799         if (a == 0) {
800             return 0;
801         }
802 
803         uint256 c = a * b;
804         require(c / a == b, "SafeMath: multiplication overflow");
805 
806         return c;
807     }
808 
809     /**
810      * @dev Returns the integer division of two unsigned integers. Reverts on
811      * division by zero. The result is rounded towards zero.
812      *
813      * Counterpart to Solidity's `/` operator. Note: this function uses a
814      * `revert` opcode (which leaves remaining gas untouched) while Solidity
815      * uses an invalid opcode to revert (consuming all remaining gas).
816      *
817      * Requirements:
818      *
819      * - The divisor cannot be zero.
820      */
821     function div(uint256 a, uint256 b) internal pure returns (uint256) {
822         return div(a, b, "SafeMath: division by zero");
823     }
824 
825     /**
826      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
827      * division by zero. The result is rounded towards zero.
828      *
829      * Counterpart to Solidity's `/` operator. Note: this function uses a
830      * `revert` opcode (which leaves remaining gas untouched) while Solidity
831      * uses an invalid opcode to revert (consuming all remaining gas).
832      *
833      * Requirements:
834      *
835      * - The divisor cannot be zero.
836      */
837     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
838         require(b > 0, errorMessage);
839         uint256 c = a / b;
840         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
841 
842         return c;
843     }
844 
845     /**
846      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
847      * Reverts when dividing by zero.
848      *
849      * Counterpart to Solidity's `%` operator. This function uses a `revert`
850      * opcode (which leaves remaining gas untouched) while Solidity uses an
851      * invalid opcode to revert (consuming all remaining gas).
852      *
853      * Requirements:
854      *
855      * - The divisor cannot be zero.
856      */
857     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
858         return mod(a, b, "SafeMath: modulo by zero");
859     }
860 
861     /**
862      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
863      * Reverts with custom message when dividing by zero.
864      *
865      * Counterpart to Solidity's `%` operator. This function uses a `revert`
866      * opcode (which leaves remaining gas untouched) while Solidity uses an
867      * invalid opcode to revert (consuming all remaining gas).
868      *
869      * Requirements:
870      *
871      * - The divisor cannot be zero.
872      */
873     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
874         require(b != 0, errorMessage);
875         return a % b;
876     }
877 }
878 
879 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
880 
881 // 
882 
883 pragma solidity ^0.6.0;
884 
885 
886 
887 
888 
889 /**
890  * @dev Implementation of the {IERC20} interface.
891  *
892  * This implementation is agnostic to the way tokens are created. This means
893  * that a supply mechanism has to be added in a derived contract using {_mint}.
894  * For a generic mechanism see {ERC20PresetMinterPauser}.
895  *
896  * TIP: For a detailed writeup see our guide
897  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
898  * to implement supply mechanisms].
899  *
900  * We have followed general OpenZeppelin guidelines: functions revert instead
901  * of returning `false` on failure. This behavior is nonetheless conventional
902  * and does not conflict with the expectations of ERC20 applications.
903  *
904  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
905  * This allows applications to reconstruct the allowance for all accounts just
906  * by listening to said events. Other implementations of the EIP may not emit
907  * these events, as it isn't required by the specification.
908  *
909  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
910  * functions have been added to mitigate the well-known issues around setting
911  * allowances. See {IERC20-approve}.
912  */
913 contract ERC20 is Context, IERC20 {
914     using SafeMath for uint256;
915     using Address for address;
916 
917     mapping (address => uint256) private _balances;
918 
919     mapping (address => mapping (address => uint256)) private _allowances;
920 
921     uint256 private _totalSupply;
922 
923     string private _name;
924     string private _symbol;
925     uint8 private _decimals;
926 
927     /**
928      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
929      * a default value of 18.
930      *
931      * To select a different value for {decimals}, use {_setupDecimals}.
932      *
933      * All three of these values are immutable: they can only be set once during
934      * construction.
935      */
936     constructor (string memory name, string memory symbol) public {
937         _name = name;
938         _symbol = symbol;
939         _decimals = 18;
940     }
941 
942     /**
943      * @dev Returns the name of the token.
944      */
945     function name() public view returns (string memory) {
946         return _name;
947     }
948 
949     /**
950      * @dev Returns the symbol of the token, usually a shorter version of the
951      * name.
952      */
953     function symbol() public view returns (string memory) {
954         return _symbol;
955     }
956 
957     /**
958      * @dev Returns the number of decimals used to get its user representation.
959      * For example, if `decimals` equals `2`, a balance of `505` tokens should
960      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
961      *
962      * Tokens usually opt for a value of 18, imitating the relationship between
963      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
964      * called.
965      *
966      * NOTE: This information is only used for _display_ purposes: it in
967      * no way affects any of the arithmetic of the contract, including
968      * {IERC20-balanceOf} and {IERC20-transfer}.
969      */
970     function decimals() public view returns (uint8) {
971         return _decimals;
972     }
973 
974     /**
975      * @dev See {IERC20-totalSupply}.
976      */
977     function totalSupply() public view override returns (uint256) {
978         return _totalSupply;
979     }
980 
981     /**
982      * @dev See {IERC20-balanceOf}.
983      */
984     function balanceOf(address account) public view override returns (uint256) {
985         return _balances[account];
986     }
987 
988     /**
989      * @dev See {IERC20-transfer}.
990      *
991      * Requirements:
992      *
993      * - `recipient` cannot be the zero address.
994      * - the caller must have a balance of at least `amount`.
995      */
996     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
997         _transfer(_msgSender(), recipient, amount);
998         return true;
999     }
1000 
1001     /**
1002      * @dev See {IERC20-allowance}.
1003      */
1004     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1005         return _allowances[owner][spender];
1006     }
1007 
1008     /**
1009      * @dev See {IERC20-approve}.
1010      *
1011      * Requirements:
1012      *
1013      * - `spender` cannot be the zero address.
1014      */
1015     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1016         _approve(_msgSender(), spender, amount);
1017         return true;
1018     }
1019 
1020     /**
1021      * @dev See {IERC20-transferFrom}.
1022      *
1023      * Emits an {Approval} event indicating the updated allowance. This is not
1024      * required by the EIP. See the note at the beginning of {ERC20};
1025      *
1026      * Requirements:
1027      * - `sender` and `recipient` cannot be the zero address.
1028      * - `sender` must have a balance of at least `amount`.
1029      * - the caller must have allowance for ``sender``'s tokens of at least
1030      * `amount`.
1031      */
1032     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1033         _transfer(sender, recipient, amount);
1034         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1035         return true;
1036     }
1037 
1038     /**
1039      * @dev Atomically increases the allowance granted to `spender` by the caller.
1040      *
1041      * This is an alternative to {approve} that can be used as a mitigation for
1042      * problems described in {IERC20-approve}.
1043      *
1044      * Emits an {Approval} event indicating the updated allowance.
1045      *
1046      * Requirements:
1047      *
1048      * - `spender` cannot be the zero address.
1049      */
1050     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1051         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1052         return true;
1053     }
1054 
1055     /**
1056      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1057      *
1058      * This is an alternative to {approve} that can be used as a mitigation for
1059      * problems described in {IERC20-approve}.
1060      *
1061      * Emits an {Approval} event indicating the updated allowance.
1062      *
1063      * Requirements:
1064      *
1065      * - `spender` cannot be the zero address.
1066      * - `spender` must have allowance for the caller of at least
1067      * `subtractedValue`.
1068      */
1069     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1070         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1071         return true;
1072     }
1073 
1074     /**
1075      * @dev Moves tokens `amount` from `sender` to `recipient`.
1076      *
1077      * This is internal function is equivalent to {transfer}, and can be used to
1078      * e.g. implement automatic token fees, slashing mechanisms, etc.
1079      *
1080      * Emits a {Transfer} event.
1081      *
1082      * Requirements:
1083      *
1084      * - `sender` cannot be the zero address.
1085      * - `recipient` cannot be the zero address.
1086      * - `sender` must have a balance of at least `amount`.
1087      */
1088     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1089         require(sender != address(0), "ERC20: transfer from the zero address");
1090         require(recipient != address(0), "ERC20: transfer to the zero address");
1091 
1092         _beforeTokenTransfer(sender, recipient, amount);
1093 
1094         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1095         _balances[recipient] = _balances[recipient].add(amount);
1096         emit Transfer(sender, recipient, amount);
1097     }
1098 
1099     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1100      * the total supply.
1101      *
1102      * Emits a {Transfer} event with `from` set to the zero address.
1103      *
1104      * Requirements
1105      *
1106      * - `to` cannot be the zero address.
1107      */
1108     function _mint(address account, uint256 amount) internal virtual {
1109         require(account != address(0), "ERC20: mint to the zero address");
1110 
1111         _beforeTokenTransfer(address(0), account, amount);
1112 
1113         _totalSupply = _totalSupply.add(amount);
1114         _balances[account] = _balances[account].add(amount);
1115         emit Transfer(address(0), account, amount);
1116     }
1117 
1118     /**
1119      * @dev Destroys `amount` tokens from `account`, reducing the
1120      * total supply.
1121      *
1122      * Emits a {Transfer} event with `to` set to the zero address.
1123      *
1124      * Requirements
1125      *
1126      * - `account` cannot be the zero address.
1127      * - `account` must have at least `amount` tokens.
1128      */
1129     function _burn(address account, uint256 amount) internal virtual {
1130         require(account != address(0), "ERC20: burn from the zero address");
1131 
1132         _beforeTokenTransfer(account, address(0), amount);
1133 
1134         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1135         _totalSupply = _totalSupply.sub(amount);
1136         emit Transfer(account, address(0), amount);
1137     }
1138 
1139     /**
1140      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1141      *
1142      * This internal function is equivalent to `approve`, and can be used to
1143      * e.g. set automatic allowances for certain subsystems, etc.
1144      *
1145      * Emits an {Approval} event.
1146      *
1147      * Requirements:
1148      *
1149      * - `owner` cannot be the zero address.
1150      * - `spender` cannot be the zero address.
1151      */
1152     function _approve(address owner, address spender, uint256 amount) internal virtual {
1153         require(owner != address(0), "ERC20: approve from the zero address");
1154         require(spender != address(0), "ERC20: approve to the zero address");
1155 
1156         _allowances[owner][spender] = amount;
1157         emit Approval(owner, spender, amount);
1158     }
1159 
1160     /**
1161      * @dev Sets {decimals} to a value other than the default one of 18.
1162      *
1163      * WARNING: This function should only be called from the constructor. Most
1164      * applications that interact with token contracts will not expect
1165      * {decimals} to ever change, and may work incorrectly if it does.
1166      */
1167     function _setupDecimals(uint8 decimals_) internal {
1168         _decimals = decimals_;
1169     }
1170 
1171     /**
1172      * @dev Hook that is called before any transfer of tokens. This includes
1173      * minting and burning.
1174      *
1175      * Calling conditions:
1176      *
1177      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1178      * will be to transferred to `to`.
1179      * - when `from` is zero, `amount` tokens will be minted for `to`.
1180      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1181      * - `from` and `to` are never both zero.
1182      *
1183      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1184      */
1185     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1186 }
1187 
1188 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1189 
1190 // 
1191 
1192 pragma solidity ^0.6.0;
1193 
1194 
1195 
1196 /**
1197  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1198  * tokens and those that they have an allowance for, in a way that can be
1199  * recognized off-chain (via event analysis).
1200  */
1201 abstract contract ERC20Burnable is Context, ERC20 {
1202     /**
1203      * @dev Destroys `amount` tokens from the caller.
1204      *
1205      * See {ERC20-_burn}.
1206      */
1207     function burn(uint256 amount) public virtual {
1208         _burn(_msgSender(), amount);
1209     }
1210 
1211     /**
1212      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1213      * allowance.
1214      *
1215      * See {ERC20-_burn} and {ERC20-allowance}.
1216      *
1217      * Requirements:
1218      *
1219      * - the caller must have allowance for ``accounts``'s tokens of at least
1220      * `amount`.
1221      */
1222     function burnFrom(address account, uint256 amount) public virtual {
1223         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1224 
1225         _approve(account, _msgSender(), decreasedAllowance);
1226         _burn(account, amount);
1227     }
1228 }
1229 
1230 // File: @openzeppelin/contracts/utils/Pausable.sol
1231 
1232 // 
1233 
1234 pragma solidity ^0.6.0;
1235 
1236 
1237 /**
1238  * @dev Contract module which allows children to implement an emergency stop
1239  * mechanism that can be triggered by an authorized account.
1240  *
1241  * This module is used through inheritance. It will make available the
1242  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1243  * the functions of your contract. Note that they will not be pausable by
1244  * simply including this module, only once the modifiers are put in place.
1245  */
1246 contract Pausable is Context {
1247     /**
1248      * @dev Emitted when the pause is triggered by `account`.
1249      */
1250     event Paused(address account);
1251 
1252     /**
1253      * @dev Emitted when the pause is lifted by `account`.
1254      */
1255     event Unpaused(address account);
1256 
1257     bool private _paused;
1258 
1259     /**
1260      * @dev Initializes the contract in unpaused state.
1261      */
1262     constructor () internal {
1263         _paused = false;
1264     }
1265 
1266     /**
1267      * @dev Returns true if the contract is paused, and false otherwise.
1268      */
1269     function paused() public view returns (bool) {
1270         return _paused;
1271     }
1272 
1273     /**
1274      * @dev Modifier to make a function callable only when the contract is not paused.
1275      *
1276      * Requirements:
1277      *
1278      * - The contract must not be paused.
1279      */
1280     modifier whenNotPaused() {
1281         require(!_paused, "Pausable: paused");
1282         _;
1283     }
1284 
1285     /**
1286      * @dev Modifier to make a function callable only when the contract is paused.
1287      *
1288      * Requirements:
1289      *
1290      * - The contract must be paused.
1291      */
1292     modifier whenPaused() {
1293         require(_paused, "Pausable: not paused");
1294         _;
1295     }
1296 
1297     /**
1298      * @dev Triggers stopped state.
1299      *
1300      * Requirements:
1301      *
1302      * - The contract must not be paused.
1303      */
1304     function _pause() internal virtual whenNotPaused {
1305         _paused = true;
1306         emit Paused(_msgSender());
1307     }
1308 
1309     /**
1310      * @dev Returns to normal state.
1311      *
1312      * Requirements:
1313      *
1314      * - The contract must be paused.
1315      */
1316     function _unpause() internal virtual whenPaused {
1317         _paused = false;
1318         emit Unpaused(_msgSender());
1319     }
1320 }
1321 
1322 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
1323 
1324 // 
1325 
1326 pragma solidity ^0.6.0;
1327 
1328 
1329 
1330 /**
1331  * @dev ERC20 token with pausable token transfers, minting and burning.
1332  *
1333  * Useful for scenarios such as preventing trades until the end of an evaluation
1334  * period, or having an emergency switch for freezing all token transfers in the
1335  * event of a large bug.
1336  */
1337 abstract contract ERC20Pausable is ERC20, Pausable {
1338     /**
1339      * @dev See {ERC20-_beforeTokenTransfer}.
1340      *
1341      * Requirements:
1342      *
1343      * - the contract must not be paused.
1344      */
1345     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1346         super._beforeTokenTransfer(from, to, amount);
1347 
1348         require(!paused(), "ERC20Pausable: token transfer while paused");
1349     }
1350 }
1351 
1352 // File: @openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol
1353 
1354 // 
1355 
1356 pragma solidity ^0.6.0;
1357 
1358 
1359 
1360 
1361 
1362 
1363 /**
1364  * @dev {ERC20} token, including:
1365  *
1366  *  - ability for holders to burn (destroy) their tokens
1367  *  - a minter role that allows for token minting (creation)
1368  *  - a pauser role that allows to stop all token transfers
1369  *
1370  * This contract uses {AccessControl} to lock permissioned functions using the
1371  * different roles - head to its documentation for details.
1372  *
1373  * The account that deploys the contract will be granted the minter and pauser
1374  * roles, as well as the default admin role, which will let it grant both minter
1375  * and pauser roles to other accounts.
1376  */
1377 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1378     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1379     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1380 
1381     /**
1382      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1383      * account that deploys the contract.
1384      *
1385      * See {ERC20-constructor}.
1386      */
1387     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1388         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1389 
1390         _setupRole(MINTER_ROLE, _msgSender());
1391         _setupRole(PAUSER_ROLE, _msgSender());
1392     }
1393 
1394     /**
1395      * @dev Creates `amount` new tokens for `to`.
1396      *
1397      * See {ERC20-_mint}.
1398      *
1399      * Requirements:
1400      *
1401      * - the caller must have the `MINTER_ROLE`.
1402      */
1403     function mint(address to, uint256 amount) public virtual {
1404         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1405         _mint(to, amount);
1406     }
1407 
1408     /**
1409      * @dev Pauses all token transfers.
1410      *
1411      * See {ERC20Pausable} and {Pausable-_pause}.
1412      *
1413      * Requirements:
1414      *
1415      * - the caller must have the `PAUSER_ROLE`.
1416      */
1417     function pause() public virtual {
1418         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1419         _pause();
1420     }
1421 
1422     /**
1423      * @dev Unpauses all token transfers.
1424      *
1425      * See {ERC20Pausable} and {Pausable-_unpause}.
1426      *
1427      * Requirements:
1428      *
1429      * - the caller must have the `PAUSER_ROLE`.
1430      */
1431     function unpause() public virtual {
1432         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1433         _unpause();
1434     }
1435 
1436     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1437         super._beforeTokenTransfer(from, to, amount);
1438     }
1439 }
1440 
1441 // File: contracts/BaseToken.sol
1442 
1443 // 
1444 
1445 // XX: pragma solidity 0.6.2;
1446 
1447 pragma solidity 0.6.12;
1448 
1449 pragma experimental ABIEncoderV2;
1450 
1451 
1452 contract BaseToken is ERC20PresetMinterPauser {
1453     bytes32 public constant ADJUST_ROLE = keccak256("ADJUST_ROLE");
1454     bytes32 public constant DELIVER_ROLE = keccak256("DELIVER_ROLE");
1455 
1456     string[30] private txidArray;
1457     uint256 arrayLength = 30;
1458     uint256 private id;
1459 
1460     uint256 private _minDeliver;
1461     uint256 private _minCollect;
1462 
1463     // uint8 private decimals_;
1464 
1465     event Deliver(address indexed to, uint256 amount, string from, string txid);
1466 
1467     event Collect(address indexed from, uint256 amount, string to);
1468 
1469     constructor(
1470         uint8 decimal,
1471         uint256 minDeliver,
1472         uint256 minCollect,
1473         string memory name,
1474         string memory symbol
1475     ) public ERC20PresetMinterPauser(name, symbol) {
1476         super._setupDecimals(decimal);
1477         _minDeliver = minDeliver;
1478         _minCollect = minCollect;
1479         _setupRole(ADJUST_ROLE, _msgSender());
1480         _setupRole(DELIVER_ROLE, _msgSender()); //SET TO Constructor
1481     }
1482 
1483     function deliver(
1484         address to,
1485         uint256 amount,
1486         string memory from,
1487         string memory txid
1488     ) public {
1489         require(
1490             amount >= _minDeliver,
1491             "The minimum value must be greater than minDeliver"
1492         );
1493         require(
1494             hasRole(DELIVER_ROLE, _msgSender()),
1495             "Must have deliver role to deliver"
1496         );
1497         for (uint256 i = 0; i < arrayLength; i++) {
1498             require(
1499                 keccak256(abi.encodePacked(txidArray[i])) !=
1500                     keccak256(abi.encodePacked(txid)),
1501                 "The txid has existed"
1502             );
1503         }
1504         uint256 id_number = id % arrayLength;
1505         txidArray[id_number] = txid;
1506         id++;
1507         //transfer(to, amount);
1508         //NEED MINTER_ROLE
1509         super.mint(to, amount);
1510         emit Deliver(to, amount, from, txid);
1511     }
1512 
1513     function collect(uint256 amount, string memory to) public {
1514         require(
1515             amount >= _minCollect,
1516             "The minimum value must be greater than minCollect"
1517         );
1518         super.burn(amount);
1519         emit Collect(msg.sender, amount, to);
1520     }
1521 
1522     function adjustParams(uint256 minDeliver, uint256 minCollect) public {
1523         require(hasRole(ADJUST_ROLE, _msgSender()), "Adjust role required");
1524         _minDeliver = minDeliver;
1525         _minCollect = minCollect;
1526     }
1527 
1528     function getParams() public view returns (uint256, uint256) {
1529         return (_minDeliver, _minCollect);
1530     }
1531 
1532     function getTxids() public view returns (string[30] memory) {
1533         return txidArray;
1534     }
1535 }
1536 
1537 // File: contracts/DnaToken.sol
1538 
1539 // 
1540 
1541 // XX: pragma solidity 0.6.2;
1542 
1543 pragma solidity 0.6.12;
1544 
1545 
1546 
1547 contract DnaToken is BaseToken {
1548     constructor(string memory name, string memory symbol)
1549         public
1550         BaseToken(4, 10000, 10000, name, symbol)
1551     {}
1552 }