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
249 // SPDX-License-Identifier: MIT
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
393 // SPDX-License-Identifier: MIT
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
420 // SPDX-License-Identifier: MIT
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
639 // SPDX-License-Identifier: MIT
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
719 // SPDX-License-Identifier: MIT
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
879 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
880 
881 // SPDX-License-Identifier: MIT
882 
883 pragma solidity ^0.6.0;
884 
885 
886 
887 
888 /**
889  * @title SafeERC20
890  * @dev Wrappers around ERC20 operations that throw on failure (when the token
891  * contract returns false). Tokens that return no value (and instead revert or
892  * throw on failure) are also supported, non-reverting calls are assumed to be
893  * successful.
894  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
895  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
896  */
897 library SafeERC20 {
898     using SafeMath for uint256;
899     using Address for address;
900 
901     function safeTransfer(IERC20 token, address to, uint256 value) internal {
902         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
903     }
904 
905     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
906         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
907     }
908 
909     /**
910      * @dev Deprecated. This function has issues similar to the ones found in
911      * {IERC20-approve}, and its usage is discouraged.
912      *
913      * Whenever possible, use {safeIncreaseAllowance} and
914      * {safeDecreaseAllowance} instead.
915      */
916     function safeApprove(IERC20 token, address spender, uint256 value) internal {
917         // safeApprove should only be called when setting an initial allowance,
918         // or when resetting it to zero. To increase and decrease it, use
919         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
920         // solhint-disable-next-line max-line-length
921         require((value == 0) || (token.allowance(address(this), spender) == 0),
922             "SafeERC20: approve from non-zero to non-zero allowance"
923         );
924         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
925     }
926 
927     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
928         uint256 newAllowance = token.allowance(address(this), spender).add(value);
929         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
930     }
931 
932     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
933         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
934         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
935     }
936 
937     /**
938      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
939      * on the return value: the return value is optional (but if data is returned, it must not be false).
940      * @param token The token targeted by the call.
941      * @param data The call data (encoded using abi.encode or one of its variants).
942      */
943     function _callOptionalReturn(IERC20 token, bytes memory data) private {
944         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
945         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
946         // the target address contains contract code and also asserts for success in the low-level call.
947 
948         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
949         if (returndata.length > 0) { // Return data is optional
950             // solhint-disable-next-line max-line-length
951             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
952         }
953     }
954 }
955 
956 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
957 
958 // SPDX-License-Identifier: MIT
959 
960 pragma solidity ^0.6.0;
961 
962 
963 
964 
965 
966 /**
967  * @dev Implementation of the {IERC20} interface.
968  *
969  * This implementation is agnostic to the way tokens are created. This means
970  * that a supply mechanism has to be added in a derived contract using {_mint}.
971  * For a generic mechanism see {ERC20PresetMinterPauser}.
972  *
973  * TIP: For a detailed writeup see our guide
974  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
975  * to implement supply mechanisms].
976  *
977  * We have followed general OpenZeppelin guidelines: functions revert instead
978  * of returning `false` on failure. This behavior is nonetheless conventional
979  * and does not conflict with the expectations of ERC20 applications.
980  *
981  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
982  * This allows applications to reconstruct the allowance for all accounts just
983  * by listening to said events. Other implementations of the EIP may not emit
984  * these events, as it isn't required by the specification.
985  *
986  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
987  * functions have been added to mitigate the well-known issues around setting
988  * allowances. See {IERC20-approve}.
989  */
990 contract ERC20 is Context, IERC20 {
991     using SafeMath for uint256;
992     using Address for address;
993 
994     mapping (address => uint256) private _balances;
995 
996     mapping (address => mapping (address => uint256)) private _allowances;
997 
998     uint256 private _totalSupply;
999 
1000     string private _name;
1001     string private _symbol;
1002     uint8 private _decimals;
1003 
1004     /**
1005      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1006      * a default value of 18.
1007      *
1008      * To select a different value for {decimals}, use {_setupDecimals}.
1009      *
1010      * All three of these values are immutable: they can only be set once during
1011      * construction.
1012      */
1013     constructor (string memory name, string memory symbol) public {
1014         _name = name;
1015         _symbol = symbol;
1016         _decimals = 18;
1017     }
1018 
1019     /**
1020      * @dev Returns the name of the token.
1021      */
1022     function name() public view returns (string memory) {
1023         return _name;
1024     }
1025 
1026     /**
1027      * @dev Returns the symbol of the token, usually a shorter version of the
1028      * name.
1029      */
1030     function symbol() public view returns (string memory) {
1031         return _symbol;
1032     }
1033 
1034     /**
1035      * @dev Returns the number of decimals used to get its user representation.
1036      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1037      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1038      *
1039      * Tokens usually opt for a value of 18, imitating the relationship between
1040      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1041      * called.
1042      *
1043      * NOTE: This information is only used for _display_ purposes: it in
1044      * no way affects any of the arithmetic of the contract, including
1045      * {IERC20-balanceOf} and {IERC20-transfer}.
1046      */
1047     function decimals() public view returns (uint8) {
1048         return _decimals;
1049     }
1050 
1051     /**
1052      * @dev See {IERC20-totalSupply}.
1053      */
1054     function totalSupply() public view override returns (uint256) {
1055         return _totalSupply;
1056     }
1057 
1058     /**
1059      * @dev See {IERC20-balanceOf}.
1060      */
1061     function balanceOf(address account) public view override returns (uint256) {
1062         return _balances[account];
1063     }
1064 
1065     /**
1066      * @dev See {IERC20-transfer}.
1067      *
1068      * Requirements:
1069      *
1070      * - `recipient` cannot be the zero address.
1071      * - the caller must have a balance of at least `amount`.
1072      */
1073     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1074         _transfer(_msgSender(), recipient, amount);
1075         return true;
1076     }
1077 
1078     /**
1079      * @dev See {IERC20-allowance}.
1080      */
1081     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1082         return _allowances[owner][spender];
1083     }
1084 
1085     /**
1086      * @dev See {IERC20-approve}.
1087      *
1088      * Requirements:
1089      *
1090      * - `spender` cannot be the zero address.
1091      */
1092     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1093         _approve(_msgSender(), spender, amount);
1094         return true;
1095     }
1096 
1097     /**
1098      * @dev See {IERC20-transferFrom}.
1099      *
1100      * Emits an {Approval} event indicating the updated allowance. This is not
1101      * required by the EIP. See the note at the beginning of {ERC20};
1102      *
1103      * Requirements:
1104      * - `sender` and `recipient` cannot be the zero address.
1105      * - `sender` must have a balance of at least `amount`.
1106      * - the caller must have allowance for ``sender``'s tokens of at least
1107      * `amount`.
1108      */
1109     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1110         _transfer(sender, recipient, amount);
1111         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1112         return true;
1113     }
1114 
1115     /**
1116      * @dev Atomically increases the allowance granted to `spender` by the caller.
1117      *
1118      * This is an alternative to {approve} that can be used as a mitigation for
1119      * problems described in {IERC20-approve}.
1120      *
1121      * Emits an {Approval} event indicating the updated allowance.
1122      *
1123      * Requirements:
1124      *
1125      * - `spender` cannot be the zero address.
1126      */
1127     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1128         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1129         return true;
1130     }
1131 
1132     /**
1133      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1134      *
1135      * This is an alternative to {approve} that can be used as a mitigation for
1136      * problems described in {IERC20-approve}.
1137      *
1138      * Emits an {Approval} event indicating the updated allowance.
1139      *
1140      * Requirements:
1141      *
1142      * - `spender` cannot be the zero address.
1143      * - `spender` must have allowance for the caller of at least
1144      * `subtractedValue`.
1145      */
1146     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1147         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1148         return true;
1149     }
1150 
1151     /**
1152      * @dev Moves tokens `amount` from `sender` to `recipient`.
1153      *
1154      * This is internal function is equivalent to {transfer}, and can be used to
1155      * e.g. implement automatic token fees, slashing mechanisms, etc.
1156      *
1157      * Emits a {Transfer} event.
1158      *
1159      * Requirements:
1160      *
1161      * - `sender` cannot be the zero address.
1162      * - `recipient` cannot be the zero address.
1163      * - `sender` must have a balance of at least `amount`.
1164      */
1165     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1166         require(sender != address(0), "ERC20: transfer from the zero address");
1167         require(recipient != address(0), "ERC20: transfer to the zero address");
1168 
1169         _beforeTokenTransfer(sender, recipient, amount);
1170 
1171         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1172         _balances[recipient] = _balances[recipient].add(amount);
1173         emit Transfer(sender, recipient, amount);
1174     }
1175 
1176     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1177      * the total supply.
1178      *
1179      * Emits a {Transfer} event with `from` set to the zero address.
1180      *
1181      * Requirements
1182      *
1183      * - `to` cannot be the zero address.
1184      */
1185     function _mint(address account, uint256 amount) internal virtual {
1186         require(account != address(0), "ERC20: mint to the zero address");
1187 
1188         _beforeTokenTransfer(address(0), account, amount);
1189 
1190         _totalSupply = _totalSupply.add(amount);
1191         _balances[account] = _balances[account].add(amount);
1192         emit Transfer(address(0), account, amount);
1193     }
1194 
1195     /**
1196      * @dev Destroys `amount` tokens from `account`, reducing the
1197      * total supply.
1198      *
1199      * Emits a {Transfer} event with `to` set to the zero address.
1200      *
1201      * Requirements
1202      *
1203      * - `account` cannot be the zero address.
1204      * - `account` must have at least `amount` tokens.
1205      */
1206     function _burn(address account, uint256 amount) internal virtual {
1207         require(account != address(0), "ERC20: burn from the zero address");
1208 
1209         _beforeTokenTransfer(account, address(0), amount);
1210 
1211         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1212         _totalSupply = _totalSupply.sub(amount);
1213         emit Transfer(account, address(0), amount);
1214     }
1215 
1216     /**
1217      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1218      *
1219      * This internal function is equivalent to `approve`, and can be used to
1220      * e.g. set automatic allowances for certain subsystems, etc.
1221      *
1222      * Emits an {Approval} event.
1223      *
1224      * Requirements:
1225      *
1226      * - `owner` cannot be the zero address.
1227      * - `spender` cannot be the zero address.
1228      */
1229     function _approve(address owner, address spender, uint256 amount) internal virtual {
1230         require(owner != address(0), "ERC20: approve from the zero address");
1231         require(spender != address(0), "ERC20: approve to the zero address");
1232 
1233         _allowances[owner][spender] = amount;
1234         emit Approval(owner, spender, amount);
1235     }
1236 
1237     /**
1238      * @dev Sets {decimals} to a value other than the default one of 18.
1239      *
1240      * WARNING: This function should only be called from the constructor. Most
1241      * applications that interact with token contracts will not expect
1242      * {decimals} to ever change, and may work incorrectly if it does.
1243      */
1244     function _setupDecimals(uint8 decimals_) internal {
1245         _decimals = decimals_;
1246     }
1247 
1248     /**
1249      * @dev Hook that is called before any transfer of tokens. This includes
1250      * minting and burning.
1251      *
1252      * Calling conditions:
1253      *
1254      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1255      * will be to transferred to `to`.
1256      * - when `from` is zero, `amount` tokens will be minted for `to`.
1257      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1258      * - `from` and `to` are never both zero.
1259      *
1260      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1261      */
1262     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1263 }
1264 
1265 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1266 
1267 // SPDX-License-Identifier: MIT
1268 
1269 pragma solidity ^0.6.0;
1270 
1271 
1272 
1273 /**
1274  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1275  * tokens and those that they have an allowance for, in a way that can be
1276  * recognized off-chain (via event analysis).
1277  */
1278 abstract contract ERC20Burnable is Context, ERC20 {
1279     /**
1280      * @dev Destroys `amount` tokens from the caller.
1281      *
1282      * See {ERC20-_burn}.
1283      */
1284     function burn(uint256 amount) public virtual {
1285         _burn(_msgSender(), amount);
1286     }
1287 
1288     /**
1289      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1290      * allowance.
1291      *
1292      * See {ERC20-_burn} and {ERC20-allowance}.
1293      *
1294      * Requirements:
1295      *
1296      * - the caller must have allowance for ``accounts``'s tokens of at least
1297      * `amount`.
1298      */
1299     function burnFrom(address account, uint256 amount) public virtual {
1300         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1301 
1302         _approve(account, _msgSender(), decreasedAllowance);
1303         _burn(account, amount);
1304     }
1305 }
1306 
1307 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
1308 
1309 // SPDX-License-Identifier: MIT
1310 
1311 pragma solidity ^0.6.0;
1312 
1313 
1314 /**
1315  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1316  */
1317 abstract contract ERC20Capped is ERC20 {
1318     uint256 private _cap;
1319 
1320     /**
1321      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1322      * set once during construction.
1323      */
1324     constructor (uint256 cap) public {
1325         require(cap > 0, "ERC20Capped: cap is 0");
1326         _cap = cap;
1327     }
1328 
1329     /**
1330      * @dev Returns the cap on the token's total supply.
1331      */
1332     function cap() public view returns (uint256) {
1333         return _cap;
1334     }
1335 
1336     /**
1337      * @dev See {ERC20-_beforeTokenTransfer}.
1338      *
1339      * Requirements:
1340      *
1341      * - minted tokens must not cause the total supply to go over the cap.
1342      */
1343     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1344         super._beforeTokenTransfer(from, to, amount);
1345 
1346         if (from == address(0)) { // When minting tokens
1347             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1348         }
1349     }
1350 }
1351 
1352 // File: @openzeppelin/contracts/utils/Pausable.sol
1353 
1354 // SPDX-License-Identifier: MIT
1355 
1356 pragma solidity ^0.6.0;
1357 
1358 
1359 /**
1360  * @dev Contract module which allows children to implement an emergency stop
1361  * mechanism that can be triggered by an authorized account.
1362  *
1363  * This module is used through inheritance. It will make available the
1364  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1365  * the functions of your contract. Note that they will not be pausable by
1366  * simply including this module, only once the modifiers are put in place.
1367  */
1368 contract Pausable is Context {
1369     /**
1370      * @dev Emitted when the pause is triggered by `account`.
1371      */
1372     event Paused(address account);
1373 
1374     /**
1375      * @dev Emitted when the pause is lifted by `account`.
1376      */
1377     event Unpaused(address account);
1378 
1379     bool private _paused;
1380 
1381     /**
1382      * @dev Initializes the contract in unpaused state.
1383      */
1384     constructor () internal {
1385         _paused = false;
1386     }
1387 
1388     /**
1389      * @dev Returns true if the contract is paused, and false otherwise.
1390      */
1391     function paused() public view returns (bool) {
1392         return _paused;
1393     }
1394 
1395     /**
1396      * @dev Modifier to make a function callable only when the contract is not paused.
1397      *
1398      * Requirements:
1399      *
1400      * - The contract must not be paused.
1401      */
1402     modifier whenNotPaused() {
1403         require(!_paused, "Pausable: paused");
1404         _;
1405     }
1406 
1407     /**
1408      * @dev Modifier to make a function callable only when the contract is paused.
1409      *
1410      * Requirements:
1411      *
1412      * - The contract must be paused.
1413      */
1414     modifier whenPaused() {
1415         require(_paused, "Pausable: not paused");
1416         _;
1417     }
1418 
1419     /**
1420      * @dev Triggers stopped state.
1421      *
1422      * Requirements:
1423      *
1424      * - The contract must not be paused.
1425      */
1426     function _pause() internal virtual whenNotPaused {
1427         _paused = true;
1428         emit Paused(_msgSender());
1429     }
1430 
1431     /**
1432      * @dev Returns to normal state.
1433      *
1434      * Requirements:
1435      *
1436      * - The contract must be paused.
1437      */
1438     function _unpause() internal virtual whenPaused {
1439         _paused = false;
1440         emit Unpaused(_msgSender());
1441     }
1442 }
1443 
1444 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
1445 
1446 // SPDX-License-Identifier: MIT
1447 
1448 pragma solidity ^0.6.0;
1449 
1450 
1451 
1452 /**
1453  * @dev ERC20 token with pausable token transfers, minting and burning.
1454  *
1455  * Useful for scenarios such as preventing trades until the end of an evaluation
1456  * period, or having an emergency switch for freezing all token transfers in the
1457  * event of a large bug.
1458  */
1459 abstract contract ERC20Pausable is ERC20, Pausable {
1460     /**
1461      * @dev See {ERC20-_beforeTokenTransfer}.
1462      *
1463      * Requirements:
1464      *
1465      * - the contract must not be paused.
1466      */
1467     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1468         super._beforeTokenTransfer(from, to, amount);
1469 
1470         require(!paused(), "ERC20Pausable: token transfer while paused");
1471     }
1472 }
1473 
1474 // File: blockchain/contracts/omi.sol
1475 
1476 // contracts/ethereum/omi.sol
1477 // SPDX-License-Identifier: UNLICENSED
1478 pragma solidity ^0.6.0;
1479 
1480 
1481 
1482 
1483 
1484 
1485 contract OMI is AccessControl, ERC20Burnable, ERC20Capped, ERC20Pausable {
1486     using SafeERC20 for ERC20;
1487     bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');
1488     bytes32 public constant PAUSER_ROLE = keccak256('PAUSER_ROLE');
1489 
1490     constructor()
1491         public
1492         ERC20('Wrapped OMI Token', 'wOMI')
1493         ERC20Capped(750000000000 * 1e18)
1494     {
1495         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1496         _setupRole(MINTER_ROLE, msg.sender);
1497         _setupRole(PAUSER_ROLE, msg.sender);
1498     }
1499 
1500     function isWrappedOMITokenContract() public pure returns (bool) {
1501         return true;
1502     }
1503 
1504     /**
1505      * @dev Creates `amount` new tokens for `to`.
1506      *
1507      * See {ERC20-_mint}.
1508      *
1509      * Requirements:
1510      *
1511      * - the caller must have the `MINTER_ROLE`.
1512      */
1513     function mint(address to, uint256 amount) public virtual {
1514         require(
1515             hasRole(MINTER_ROLE, _msgSender()),
1516             'ERC20PresetMinterPauser: must have minter role to mint'
1517         );
1518         _mint(to, amount);
1519     }
1520 
1521     /**
1522      * @dev Pauses all token transfers.
1523      *
1524      * See {ERC20Pausable} and {Pausable-_pause}.
1525      *
1526      * Requirements:
1527      *
1528      * - the caller must have the `PAUSER_ROLE`.
1529      */
1530     function pause() public virtual {
1531         require(
1532             hasRole(PAUSER_ROLE, _msgSender()),
1533             'ERC20PresetMinterPauser: must have pauser role to pause'
1534         );
1535         _pause();
1536     }
1537 
1538     /**
1539      * @dev Unpauses all token transfers.
1540      *
1541      * See {ERC20Pausable} and {Pausable-_unpause}.
1542      *
1543      * Requirements:
1544      *
1545      * - the caller must have the `PAUSER_ROLE`.
1546      */
1547     function unpause() public virtual {
1548         require(
1549             hasRole(PAUSER_ROLE, _msgSender()),
1550             'ERC20PresetMinterPauser: must have pauser role to unpause'
1551         );
1552         _unpause();
1553     }
1554 
1555     function _beforeTokenTransfer(
1556         address from,
1557         address to,
1558         uint256 amount
1559     ) internal virtual override(ERC20, ERC20Pausable, ERC20Capped) {
1560         super._beforeTokenTransfer(from, to, amount);
1561     }
1562 }