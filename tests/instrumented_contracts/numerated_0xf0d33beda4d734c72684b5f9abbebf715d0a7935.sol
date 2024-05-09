1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-28
3 */
4 
5 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.6.0;
10 
11 /**
12  * @dev Library for managing
13  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
14  * types.
15  *
16  * Sets have the following properties:
17  *
18  * - Elements are added, removed, and checked for existence in constant time
19  * (O(1)).
20  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
21  *
22  * ```
23  * contract Example {
24  *     // Add the library methods
25  *     using EnumerableSet for EnumerableSet.AddressSet;
26  *
27  *     // Declare a set state variable
28  *     EnumerableSet.AddressSet private mySet;
29  * }
30  * ```
31  *
32  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
33  * (`UintSet`) are supported.
34  */
35 library EnumerableSet {
36     // To implement this library for multiple types with as little code
37     // repetition as possible, we write it in terms of a generic Set type with
38     // bytes32 values.
39     // The Set implementation uses private functions, and user-facing
40     // implementations (such as AddressSet) are just wrappers around the
41     // underlying Set.
42     // This means that we can only create new EnumerableSets for types that fit
43     // in bytes32.
44 
45     struct Set {
46         // Storage of set values
47         bytes32[] _values;
48 
49         // Position of the value in the `values` array, plus 1 because index 0
50         // means a value is not in the set.
51         mapping (bytes32 => uint256) _indexes;
52     }
53 
54     /**
55      * @dev Add a value to a set. O(1).
56      *
57      * Returns true if the value was added to the set, that is if it was not
58      * already present.
59      */
60     function _add(Set storage set, bytes32 value) private returns (bool) {
61         if (!_contains(set, value)) {
62             set._values.push(value);
63             // The value is stored at length-1, but we add 1 to all indexes
64             // and use 0 as a sentinel value
65             set._indexes[value] = set._values.length;
66             return true;
67         } else {
68             return false;
69         }
70     }
71 
72     /**
73      * @dev Removes a value from a set. O(1).
74      *
75      * Returns true if the value was removed from the set, that is if it was
76      * present.
77      */
78     function _remove(Set storage set, bytes32 value) private returns (bool) {
79         // We read and store the value's index to prevent multiple reads from the same storage slot
80         uint256 valueIndex = set._indexes[value];
81 
82         if (valueIndex != 0) { // Equivalent to contains(set, value)
83             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
84             // the array, and then remove the last element (sometimes called as 'swap and pop').
85             // This modifies the order of the array, as noted in {at}.
86 
87             uint256 toDeleteIndex = valueIndex - 1;
88             uint256 lastIndex = set._values.length - 1;
89 
90             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
91             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
92 
93             bytes32 lastvalue = set._values[lastIndex];
94 
95             // Move the last value to the index where the value to delete is
96             set._values[toDeleteIndex] = lastvalue;
97             // Update the index for the moved value
98             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
99 
100             // Delete the slot where the moved value was stored
101             set._values.pop();
102 
103             // Delete the index for the deleted slot
104             delete set._indexes[value];
105 
106             return true;
107         } else {
108             return false;
109         }
110     }
111 
112     /**
113      * @dev Returns true if the value is in the set. O(1).
114      */
115     function _contains(Set storage set, bytes32 value) private view returns (bool) {
116         return set._indexes[value] != 0;
117     }
118 
119     /**
120      * @dev Returns the number of values on the set. O(1).
121      */
122     function _length(Set storage set) private view returns (uint256) {
123         return set._values.length;
124     }
125 
126    /**
127     * @dev Returns the value stored at position `index` in the set. O(1).
128     *
129     * Note that there are no guarantees on the ordering of values inside the
130     * array, and it may change when more values are added or removed.
131     *
132     * Requirements:
133     *
134     * - `index` must be strictly less than {length}.
135     */
136     function _at(Set storage set, uint256 index) private view returns (bytes32) {
137         require(set._values.length > index, "EnumerableSet: index out of bounds");
138         return set._values[index];
139     }
140 
141     // AddressSet
142 
143     struct AddressSet {
144         Set _inner;
145     }
146 
147     /**
148      * @dev Add a value to a set. O(1).
149      *
150      * Returns true if the value was added to the set, that is if it was not
151      * already present.
152      */
153     function add(AddressSet storage set, address value) internal returns (bool) {
154         return _add(set._inner, bytes32(uint256(value)));
155     }
156 
157     /**
158      * @dev Removes a value from a set. O(1).
159      *
160      * Returns true if the value was removed from the set, that is if it was
161      * present.
162      */
163     function remove(AddressSet storage set, address value) internal returns (bool) {
164         return _remove(set._inner, bytes32(uint256(value)));
165     }
166 
167     /**
168      * @dev Returns true if the value is in the set. O(1).
169      */
170     function contains(AddressSet storage set, address value) internal view returns (bool) {
171         return _contains(set._inner, bytes32(uint256(value)));
172     }
173 
174     /**
175      * @dev Returns the number of values in the set. O(1).
176      */
177     function length(AddressSet storage set) internal view returns (uint256) {
178         return _length(set._inner);
179     }
180 
181    /**
182     * @dev Returns the value stored at position `index` in the set. O(1).
183     *
184     * Note that there are no guarantees on the ordering of values inside the
185     * array, and it may change when more values are added or removed.
186     *
187     * Requirements:
188     *
189     * - `index` must be strictly less than {length}.
190     */
191     function at(AddressSet storage set, uint256 index) internal view returns (address) {
192         return address(uint256(_at(set._inner, index)));
193     }
194 
195 
196     // UintSet
197 
198     struct UintSet {
199         Set _inner;
200     }
201 
202     /**
203      * @dev Add a value to a set. O(1).
204      *
205      * Returns true if the value was added to the set, that is if it was not
206      * already present.
207      */
208     function add(UintSet storage set, uint256 value) internal returns (bool) {
209         return _add(set._inner, bytes32(value));
210     }
211 
212     /**
213      * @dev Removes a value from a set. O(1).
214      *
215      * Returns true if the value was removed from the set, that is if it was
216      * present.
217      */
218     function remove(UintSet storage set, uint256 value) internal returns (bool) {
219         return _remove(set._inner, bytes32(value));
220     }
221 
222     /**
223      * @dev Returns true if the value is in the set. O(1).
224      */
225     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
226         return _contains(set._inner, bytes32(value));
227     }
228 
229     /**
230      * @dev Returns the number of values on the set. O(1).
231      */
232     function length(UintSet storage set) internal view returns (uint256) {
233         return _length(set._inner);
234     }
235 
236    /**
237     * @dev Returns the value stored at position `index` in the set. O(1).
238     *
239     * Note that there are no guarantees on the ordering of values inside the
240     * array, and it may change when more values are added or removed.
241     *
242     * Requirements:
243     *
244     * - `index` must be strictly less than {length}.
245     */
246     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
247         return uint256(_at(set._inner, index));
248     }
249 }
250 
251 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
252 
253 // SPDX-License-Identifier: MIT
254 
255 pragma solidity ^0.6.2;
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies in extcodesize, which returns 0 for contracts in
280         // construction, since the code is only stored at the end of the
281         // constructor execution.
282 
283         uint256 size;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { size := extcodesize(account) }
286         return size > 0;
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
309         (bool success, ) = recipient.call{ value: amount }("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain`call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332       return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         return _functionCallWithValue(target, data, value, errorMessage);
369     }
370 
371     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
372         require(isContract(target), "Address: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
396 
397 // SPDX-License-Identifier: MIT
398 
399 pragma solidity ^0.6.0;
400 
401 /*
402  * @dev Provides information about the current execution context, including the
403  * sender of the transaction and its data. While these are generally available
404  * via msg.sender and msg.data, they should not be accessed in such a direct
405  * manner, since when dealing with GSN meta-transactions the account sending and
406  * paying for execution may not be the actual sender (as far as an application
407  * is concerned).
408  *
409  * This contract is only required for intermediate, library-like contracts.
410  */
411 abstract contract Context {
412     function _msgSender() internal view virtual returns (address payable) {
413         return msg.sender;
414     }
415 
416     function _msgData() internal view virtual returns (bytes memory) {
417         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
418         return msg.data;
419     }
420 }
421 
422 // File: @openzeppelin\contracts\access\AccessControl.sol
423 
424 // SPDX-License-Identifier: MIT
425 
426 pragma solidity ^0.6.0;
427 
428 
429 
430 
431 /**
432  * @dev Contract module that allows children to implement role-based access
433  * control mechanisms.
434  *
435  * Roles are referred to by their `bytes32` identifier. These should be exposed
436  * in the external API and be unique. The best way to achieve this is by
437  * using `public constant` hash digests:
438  *
439  * ```
440  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
441  * ```
442  *
443  * Roles can be used to represent a set of permissions. To restrict access to a
444  * function call, use {hasRole}:
445  *
446  * ```
447  * function foo() public {
448  *     require(hasRole(MY_ROLE, msg.sender));
449  *     ...
450  * }
451  * ```
452  *
453  * Roles can be granted and revoked dynamically via the {grantRole} and
454  * {revokeRole} functions. Each role has an associated admin role, and only
455  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
456  *
457  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
458  * that only accounts with this role will be able to grant or revoke other
459  * roles. More complex role relationships can be created by using
460  * {_setRoleAdmin}.
461  *
462  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
463  * grant and revoke this role. Extra precautions should be taken to secure
464  * accounts that have been granted it.
465  */
466 abstract contract AccessControl is Context {
467     using EnumerableSet for EnumerableSet.AddressSet;
468     using Address for address;
469 
470     struct RoleData {
471         EnumerableSet.AddressSet members;
472         bytes32 adminRole;
473     }
474 
475     mapping (bytes32 => RoleData) private _roles;
476 
477     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
478 
479     /**
480      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
481      *
482      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
483      * {RoleAdminChanged} not being emitted signaling this.
484      *
485      * _Available since v3.1._
486      */
487     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
488 
489     /**
490      * @dev Emitted when `account` is granted `role`.
491      *
492      * `sender` is the account that originated the contract call, an admin role
493      * bearer except when using {_setupRole}.
494      */
495     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
496 
497     /**
498      * @dev Emitted when `account` is revoked `role`.
499      *
500      * `sender` is the account that originated the contract call:
501      *   - if using `revokeRole`, it is the admin role bearer
502      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
503      */
504     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
505 
506     /**
507      * @dev Returns `true` if `account` has been granted `role`.
508      */
509     function hasRole(bytes32 role, address account) public view returns (bool) {
510         return _roles[role].members.contains(account);
511     }
512 
513     /**
514      * @dev Returns the number of accounts that have `role`. Can be used
515      * together with {getRoleMember} to enumerate all bearers of a role.
516      */
517     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
518         return _roles[role].members.length();
519     }
520 
521     /**
522      * @dev Returns one of the accounts that have `role`. `index` must be a
523      * value between 0 and {getRoleMemberCount}, non-inclusive.
524      *
525      * Role bearers are not sorted in any particular way, and their ordering may
526      * change at any point.
527      *
528      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
529      * you perform all queries on the same block. See the following
530      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
531      * for more information.
532      */
533     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
534         return _roles[role].members.at(index);
535     }
536 
537     /**
538      * @dev Returns the admin role that controls `role`. See {grantRole} and
539      * {revokeRole}.
540      *
541      * To change a role's admin, use {_setRoleAdmin}.
542      */
543     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
544         return _roles[role].adminRole;
545     }
546 
547     /**
548      * @dev Grants `role` to `account`.
549      *
550      * If `account` had not been already granted `role`, emits a {RoleGranted}
551      * event.
552      *
553      * Requirements:
554      *
555      * - the caller must have ``role``'s admin role.
556      */
557     function grantRole(bytes32 role, address account) public virtual {
558         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
559 
560         _grantRole(role, account);
561     }
562 
563     /**
564      * @dev Revokes `role` from `account`.
565      *
566      * If `account` had been granted `role`, emits a {RoleRevoked} event.
567      *
568      * Requirements:
569      *
570      * - the caller must have ``role``'s admin role.
571      */
572     function revokeRole(bytes32 role, address account) public virtual {
573         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
574 
575         _revokeRole(role, account);
576     }
577 
578     /**
579      * @dev Revokes `role` from the calling account.
580      *
581      * Roles are often managed via {grantRole} and {revokeRole}: this function's
582      * purpose is to provide a mechanism for accounts to lose their privileges
583      * if they are compromised (such as when a trusted device is misplaced).
584      *
585      * If the calling account had been granted `role`, emits a {RoleRevoked}
586      * event.
587      *
588      * Requirements:
589      *
590      * - the caller must be `account`.
591      */
592     function renounceRole(bytes32 role, address account) public virtual {
593         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
594 
595         _revokeRole(role, account);
596     }
597 
598     /**
599      * @dev Grants `role` to `account`.
600      *
601      * If `account` had not been already granted `role`, emits a {RoleGranted}
602      * event. Note that unlike {grantRole}, this function doesn't perform any
603      * checks on the calling account.
604      *
605      * [WARNING]
606      * ====
607      * This function should only be called from the constructor when setting
608      * up the initial roles for the system.
609      *
610      * Using this function in any other way is effectively circumventing the admin
611      * system imposed by {AccessControl}.
612      * ====
613      */
614     function _setupRole(bytes32 role, address account) internal virtual {
615         _grantRole(role, account);
616     }
617 
618     /**
619      * @dev Sets `adminRole` as ``role``'s admin role.
620      *
621      * Emits a {RoleAdminChanged} event.
622      */
623     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
624         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
625         _roles[role].adminRole = adminRole;
626     }
627 
628     function _grantRole(bytes32 role, address account) private {
629         if (_roles[role].members.add(account)) {
630             emit RoleGranted(role, account, _msgSender());
631         }
632     }
633 
634     function _revokeRole(bytes32 role, address account) private {
635         if (_roles[role].members.remove(account)) {
636             emit RoleRevoked(role, account, _msgSender());
637         }
638     }
639 }
640 
641 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
642 
643 // SPDX-License-Identifier: MIT
644 
645 pragma solidity ^0.6.0;
646 
647 /**
648  * @dev Interface of the ERC20 standard as defined in the EIP.
649  */
650 interface IERC20 {
651     /**
652      * @dev Returns the amount of tokens in existence.
653      */
654     function totalSupply() external view returns (uint256);
655 
656     /**
657      * @dev Returns the amount of tokens owned by `account`.
658      */
659     function balanceOf(address account) external view returns (uint256);
660 
661     /**
662      * @dev Moves `amount` tokens from the caller's account to `recipient`.
663      *
664      * Returns a boolean value indicating whether the operation succeeded.
665      *
666      * Emits a {Transfer} event.
667      */
668     function transfer(address recipient, uint256 amount) external returns (bool);
669 
670     /**
671      * @dev Returns the remaining number of tokens that `spender` will be
672      * allowed to spend on behalf of `owner` through {transferFrom}. This is
673      * zero by default.
674      *
675      * This value changes when {approve} or {transferFrom} are called.
676      */
677     function allowance(address owner, address spender) external view returns (uint256);
678 
679     /**
680      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
681      *
682      * Returns a boolean value indicating whether the operation succeeded.
683      *
684      * IMPORTANT: Beware that changing an allowance with this method brings the risk
685      * that someone may use both the old and the new allowance by unfortunate
686      * transaction ordering. One possible solution to mitigate this race
687      * condition is to first reduce the spender's allowance to 0 and set the
688      * desired value afterwards:
689      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
690      *
691      * Emits an {Approval} event.
692      */
693     function approve(address spender, uint256 amount) external returns (bool);
694 
695     /**
696      * @dev Moves `amount` tokens from `sender` to `recipient` using the
697      * allowance mechanism. `amount` is then deducted from the caller's
698      * allowance.
699      *
700      * Returns a boolean value indicating whether the operation succeeded.
701      *
702      * Emits a {Transfer} event.
703      */
704     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
705 
706     /**
707      * @dev Emitted when `value` tokens are moved from one account (`from`) to
708      * another (`to`).
709      *
710      * Note that `value` may be zero.
711      */
712     event Transfer(address indexed from, address indexed to, uint256 value);
713 
714     /**
715      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
716      * a call to {approve}. `value` is the new allowance.
717      */
718     event Approval(address indexed owner, address indexed spender, uint256 value);
719 }
720 
721 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
722 
723 // SPDX-License-Identifier: MIT
724 
725 pragma solidity ^0.6.0;
726 
727 /**
728  * @dev Wrappers over Solidity's arithmetic operations with added overflow
729  * checks.
730  *
731  * Arithmetic operations in Solidity wrap on overflow. This can easily result
732  * in bugs, because programmers usually assume that an overflow raises an
733  * error, which is the standard behavior in high level programming languages.
734  * `SafeMath` restores this intuition by reverting the transaction when an
735  * operation overflows.
736  *
737  * Using this library instead of the unchecked operations eliminates an entire
738  * class of bugs, so it's recommended to use it always.
739  */
740 library SafeMath {
741     /**
742      * @dev Returns the addition of two unsigned integers, reverting on
743      * overflow.
744      *
745      * Counterpart to Solidity's `+` operator.
746      *
747      * Requirements:
748      *
749      * - Addition cannot overflow.
750      */
751     function add(uint256 a, uint256 b) internal pure returns (uint256) {
752         uint256 c = a + b;
753         require(c >= a, "SafeMath: addition overflow");
754 
755         return c;
756     }
757 
758     /**
759      * @dev Returns the subtraction of two unsigned integers, reverting on
760      * overflow (when the result is negative).
761      *
762      * Counterpart to Solidity's `-` operator.
763      *
764      * Requirements:
765      *
766      * - Subtraction cannot overflow.
767      */
768     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
769         return sub(a, b, "SafeMath: subtraction overflow");
770     }
771 
772     /**
773      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
774      * overflow (when the result is negative).
775      *
776      * Counterpart to Solidity's `-` operator.
777      *
778      * Requirements:
779      *
780      * - Subtraction cannot overflow.
781      */
782     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
783         require(b <= a, errorMessage);
784         uint256 c = a - b;
785 
786         return c;
787     }
788 
789     /**
790      * @dev Returns the multiplication of two unsigned integers, reverting on
791      * overflow.
792      *
793      * Counterpart to Solidity's `*` operator.
794      *
795      * Requirements:
796      *
797      * - Multiplication cannot overflow.
798      */
799     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
800         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
801         // benefit is lost if 'b' is also tested.
802         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
803         if (a == 0) {
804             return 0;
805         }
806 
807         uint256 c = a * b;
808         require(c / a == b, "SafeMath: multiplication overflow");
809 
810         return c;
811     }
812 
813     /**
814      * @dev Returns the integer division of two unsigned integers. Reverts on
815      * division by zero. The result is rounded towards zero.
816      *
817      * Counterpart to Solidity's `/` operator. Note: this function uses a
818      * `revert` opcode (which leaves remaining gas untouched) while Solidity
819      * uses an invalid opcode to revert (consuming all remaining gas).
820      *
821      * Requirements:
822      *
823      * - The divisor cannot be zero.
824      */
825     function div(uint256 a, uint256 b) internal pure returns (uint256) {
826         return div(a, b, "SafeMath: division by zero");
827     }
828 
829     /**
830      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
831      * division by zero. The result is rounded towards zero.
832      *
833      * Counterpart to Solidity's `/` operator. Note: this function uses a
834      * `revert` opcode (which leaves remaining gas untouched) while Solidity
835      * uses an invalid opcode to revert (consuming all remaining gas).
836      *
837      * Requirements:
838      *
839      * - The divisor cannot be zero.
840      */
841     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
842         require(b > 0, errorMessage);
843         uint256 c = a / b;
844         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
845 
846         return c;
847     }
848 
849     /**
850      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
851      * Reverts when dividing by zero.
852      *
853      * Counterpart to Solidity's `%` operator. This function uses a `revert`
854      * opcode (which leaves remaining gas untouched) while Solidity uses an
855      * invalid opcode to revert (consuming all remaining gas).
856      *
857      * Requirements:
858      *
859      * - The divisor cannot be zero.
860      */
861     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
862         return mod(a, b, "SafeMath: modulo by zero");
863     }
864 
865     /**
866      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
867      * Reverts with custom message when dividing by zero.
868      *
869      * Counterpart to Solidity's `%` operator. This function uses a `revert`
870      * opcode (which leaves remaining gas untouched) while Solidity uses an
871      * invalid opcode to revert (consuming all remaining gas).
872      *
873      * Requirements:
874      *
875      * - The divisor cannot be zero.
876      */
877     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
878         require(b != 0, errorMessage);
879         return a % b;
880     }
881 }
882 
883 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
884 
885 // SPDX-License-Identifier: MIT
886 
887 pragma solidity ^0.6.0;
888 
889 
890 
891 
892 
893 /**
894  * @dev Implementation of the {IERC20} interface.
895  *
896  * This implementation is agnostic to the way tokens are created. This means
897  * that a supply mechanism has to be added in a derived contract using {_mint}.
898  * For a generic mechanism see {ERC20PresetMinterPauser}.
899  *
900  * TIP: For a detailed writeup see our guide
901  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
902  * to implement supply mechanisms].
903  *
904  * We have followed general OpenZeppelin guidelines: functions revert instead
905  * of returning `false` on failure. This behavior is nonetheless conventional
906  * and does not conflict with the expectations of ERC20 applications.
907  *
908  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
909  * This allows applications to reconstruct the allowance for all accounts just
910  * by listening to said events. Other implementations of the EIP may not emit
911  * these events, as it isn't required by the specification.
912  *
913  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
914  * functions have been added to mitigate the well-known issues around setting
915  * allowances. See {IERC20-approve}.
916  */
917 contract ERC20 is Context, IERC20 {
918     using SafeMath for uint256;
919     using Address for address;
920 
921     mapping (address => uint256) private _balances;
922 
923     mapping (address => mapping (address => uint256)) private _allowances;
924 
925     uint256 private _totalSupply;
926 
927     string private _name;
928     string private _symbol;
929     uint8 private _decimals;
930 
931     /**
932      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
933      * a default value of 18.
934      *
935      * To select a different value for {decimals}, use {_setupDecimals}.
936      *
937      * All three of these values are immutable: they can only be set once during
938      * construction.
939      */
940     constructor (string memory name, string memory symbol) public {
941         _name = name;
942         _symbol = symbol;
943         _decimals = 18;
944     }
945 
946     /**
947      * @dev Returns the name of the token.
948      */
949     function name() public view returns (string memory) {
950         return _name;
951     }
952 
953     /**
954      * @dev Returns the symbol of the token, usually a shorter version of the
955      * name.
956      */
957     function symbol() public view returns (string memory) {
958         return _symbol;
959     }
960 
961     /**
962      * @dev Returns the number of decimals used to get its user representation.
963      * For example, if `decimals` equals `2`, a balance of `505` tokens should
964      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
965      *
966      * Tokens usually opt for a value of 18, imitating the relationship between
967      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
968      * called.
969      *
970      * NOTE: This information is only used for _display_ purposes: it in
971      * no way affects any of the arithmetic of the contract, including
972      * {IERC20-balanceOf} and {IERC20-transfer}.
973      */
974     function decimals() public view returns (uint8) {
975         return _decimals;
976     }
977 
978     /**
979      * @dev See {IERC20-totalSupply}.
980      */
981     function totalSupply() public view override returns (uint256) {
982         return _totalSupply;
983     }
984 
985     /**
986      * @dev See {IERC20-balanceOf}.
987      */
988     function balanceOf(address account) public view override returns (uint256) {
989         return _balances[account];
990     }
991 
992     /**
993      * @dev See {IERC20-transfer}.
994      *
995      * Requirements:
996      *
997      * - `recipient` cannot be the zero address.
998      * - the caller must have a balance of at least `amount`.
999      */
1000     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1001         _transfer(_msgSender(), recipient, amount);
1002         return true;
1003     }
1004 
1005     /**
1006      * @dev See {IERC20-allowance}.
1007      */
1008     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1009         return _allowances[owner][spender];
1010     }
1011 
1012     /**
1013      * @dev See {IERC20-approve}.
1014      *
1015      * Requirements:
1016      *
1017      * - `spender` cannot be the zero address.
1018      */
1019     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1020         _approve(_msgSender(), spender, amount);
1021         return true;
1022     }
1023 
1024     /**
1025      * @dev See {IERC20-transferFrom}.
1026      *
1027      * Emits an {Approval} event indicating the updated allowance. This is not
1028      * required by the EIP. See the note at the beginning of {ERC20};
1029      *
1030      * Requirements:
1031      * - `sender` and `recipient` cannot be the zero address.
1032      * - `sender` must have a balance of at least `amount`.
1033      * - the caller must have allowance for ``sender``'s tokens of at least
1034      * `amount`.
1035      */
1036     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1037         _transfer(sender, recipient, amount);
1038         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1039         return true;
1040     }
1041 
1042     /**
1043      * @dev Atomically increases the allowance granted to `spender` by the caller.
1044      *
1045      * This is an alternative to {approve} that can be used as a mitigation for
1046      * problems described in {IERC20-approve}.
1047      *
1048      * Emits an {Approval} event indicating the updated allowance.
1049      *
1050      * Requirements:
1051      *
1052      * - `spender` cannot be the zero address.
1053      */
1054     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1055         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1056         return true;
1057     }
1058 
1059     /**
1060      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1061      *
1062      * This is an alternative to {approve} that can be used as a mitigation for
1063      * problems described in {IERC20-approve}.
1064      *
1065      * Emits an {Approval} event indicating the updated allowance.
1066      *
1067      * Requirements:
1068      *
1069      * - `spender` cannot be the zero address.
1070      * - `spender` must have allowance for the caller of at least
1071      * `subtractedValue`.
1072      */
1073     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1074         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1075         return true;
1076     }
1077 
1078     /**
1079      * @dev Moves tokens `amount` from `sender` to `recipient`.
1080      *
1081      * This is internal function is equivalent to {transfer}, and can be used to
1082      * e.g. implement automatic token fees, slashing mechanisms, etc.
1083      *
1084      * Emits a {Transfer} event.
1085      *
1086      * Requirements:
1087      *
1088      * - `sender` cannot be the zero address.
1089      * - `recipient` cannot be the zero address.
1090      * - `sender` must have a balance of at least `amount`.
1091      */
1092     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1093         require(sender != address(0), "ERC20: transfer from the zero address");
1094         require(recipient != address(0), "ERC20: transfer to the zero address");
1095 
1096         _beforeTokenTransfer(sender, recipient, amount);
1097 
1098         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1099         _balances[recipient] = _balances[recipient].add(amount);
1100         emit Transfer(sender, recipient, amount);
1101     }
1102 
1103     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1104      * the total supply.
1105      *
1106      * Emits a {Transfer} event with `from` set to the zero address.
1107      *
1108      * Requirements
1109      *
1110      * - `to` cannot be the zero address.
1111      */
1112     function _mint(address account, uint256 amount) internal virtual {
1113         require(account != address(0), "ERC20: mint to the zero address");
1114 
1115         _beforeTokenTransfer(address(0), account, amount);
1116 
1117         _totalSupply = _totalSupply.add(amount);
1118         _balances[account] = _balances[account].add(amount);
1119         emit Transfer(address(0), account, amount);
1120     }
1121 
1122     /**
1123      * @dev Destroys `amount` tokens from `account`, reducing the
1124      * total supply.
1125      *
1126      * Emits a {Transfer} event with `to` set to the zero address.
1127      *
1128      * Requirements
1129      *
1130      * - `account` cannot be the zero address.
1131      * - `account` must have at least `amount` tokens.
1132      */
1133     function _burn(address account, uint256 amount) internal virtual {
1134         require(account != address(0), "ERC20: burn from the zero address");
1135 
1136         _beforeTokenTransfer(account, address(0), amount);
1137 
1138         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1139         _totalSupply = _totalSupply.sub(amount);
1140         emit Transfer(account, address(0), amount);
1141     }
1142 
1143     /**
1144      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1145      *
1146      * This internal function is equivalent to `approve`, and can be used to
1147      * e.g. set automatic allowances for certain subsystems, etc.
1148      *
1149      * Emits an {Approval} event.
1150      *
1151      * Requirements:
1152      *
1153      * - `owner` cannot be the zero address.
1154      * - `spender` cannot be the zero address.
1155      */
1156     function _approve(address owner, address spender, uint256 amount) internal virtual {
1157         require(owner != address(0), "ERC20: approve from the zero address");
1158         require(spender != address(0), "ERC20: approve to the zero address");
1159 
1160         _allowances[owner][spender] = amount;
1161         emit Approval(owner, spender, amount);
1162     }
1163 
1164     /**
1165      * @dev Sets {decimals} to a value other than the default one of 18.
1166      *
1167      * WARNING: This function should only be called from the constructor. Most
1168      * applications that interact with token contracts will not expect
1169      * {decimals} to ever change, and may work incorrectly if it does.
1170      */
1171     function _setupDecimals(uint8 decimals_) internal {
1172         _decimals = decimals_;
1173     }
1174 
1175     /**
1176      * @dev Hook that is called before any transfer of tokens. This includes
1177      * minting and burning.
1178      *
1179      * Calling conditions:
1180      *
1181      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1182      * will be to transferred to `to`.
1183      * - when `from` is zero, `amount` tokens will be minted for `to`.
1184      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1185      * - `from` and `to` are never both zero.
1186      *
1187      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1188      */
1189     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1190 }
1191 
1192 
1193 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
1194 
1195 // SPDX-License-Identifier: MIT
1196 
1197 pragma solidity ^0.6.0;
1198 
1199 
1200 
1201 /**
1202  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1203  * tokens and those that they have an allowance for, in a way that can be
1204  * recognized off-chain (via event analysis).
1205  */
1206 abstract contract ERC20Burnable is Context, ERC20 {
1207     /**
1208      * @dev Destroys `amount` tokens from the caller.
1209      *
1210      * See {ERC20-_burn}.
1211      */
1212     function burn(uint256 amount) public virtual {
1213         _burn(_msgSender(), amount);
1214     }
1215 
1216     /**
1217      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1218      * allowance.
1219      *
1220      * See {ERC20-_burn} and {ERC20-allowance}.
1221      *
1222      * Requirements:
1223      *
1224      * - the caller must have allowance for ``accounts``'s tokens of at least
1225      * `amount`.
1226      */
1227     function burnFrom(address account, uint256 amount) public virtual {
1228         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1229 
1230         _approve(account, _msgSender(), decreasedAllowance);
1231         _burn(account, amount);
1232     }
1233 }
1234 
1235 // File: node_modules\@openzeppelin\contracts\utils\Pausable.sol
1236 
1237 // SPDX-License-Identifier: MIT
1238 
1239 pragma solidity ^0.6.0;
1240 
1241 
1242 /**
1243  * @dev Contract module which allows children to implement an emergency stop
1244  * mechanism that can be triggered by an authorized account.
1245  *
1246  * This module is used through inheritance. It will make available the
1247  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1248  * the functions of your contract. Note that they will not be pausable by
1249  * simply including this module, only once the modifiers are put in place.
1250  */
1251 contract Pausable is Context {
1252     /**
1253      * @dev Emitted when the pause is triggered by `account`.
1254      */
1255     event Paused(address account);
1256 
1257     /**
1258      * @dev Emitted when the pause is lifted by `account`.
1259      */
1260     event Unpaused(address account);
1261 
1262     bool private _paused;
1263 
1264     /**
1265      * @dev Initializes the contract in unpaused state.
1266      */
1267     constructor () internal {
1268         _paused = false;
1269     }
1270 
1271     /**
1272      * @dev Returns true if the contract is paused, and false otherwise.
1273      */
1274     function paused() public view returns (bool) {
1275         return _paused;
1276     }
1277 
1278     /**
1279      * @dev Modifier to make a function callable only when the contract is not paused.
1280      *
1281      * Requirements:
1282      *
1283      * - The contract must not be paused.
1284      */
1285     modifier whenNotPaused() {
1286         require(!_paused, "Pausable: paused");
1287         _;
1288     }
1289 
1290     /**
1291      * @dev Modifier to make a function callable only when the contract is paused.
1292      *
1293      * Requirements:
1294      *
1295      * - The contract must be paused.
1296      */
1297     modifier whenPaused() {
1298         require(_paused, "Pausable: not paused");
1299         _;
1300     }
1301 
1302     /**
1303      * @dev Triggers stopped state.
1304      *
1305      * Requirements:
1306      *
1307      * - The contract must not be paused.
1308      */
1309     function _pause() internal virtual whenNotPaused {
1310         _paused = true;
1311         emit Paused(_msgSender());
1312     }
1313 
1314     /**
1315      * @dev Returns to normal state.
1316      *
1317      * Requirements:
1318      *
1319      * - The contract must be paused.
1320      */
1321     function _unpause() internal virtual whenPaused {
1322         _paused = false;
1323         emit Unpaused(_msgSender());
1324     }
1325 }
1326 
1327 // File: @openzeppelin\contracts\token\ERC20\ERC20Pausable.sol
1328 
1329 // SPDX-License-Identifier: MIT
1330 
1331 pragma solidity ^0.6.0;
1332 
1333 
1334 
1335 /**
1336  * @dev ERC20 token with pausable token transfers, minting and burning.
1337  *
1338  * Useful for scenarios such as preventing trades until the end of an evaluation
1339  * period, or having an emergency switch for freezing all token transfers in the
1340  * event of a large bug.
1341  */
1342 abstract contract ERC20Pausable is ERC20, Pausable {
1343     /**
1344      * @dev See {ERC20-_beforeTokenTransfer}.
1345      *
1346      * Requirements:
1347      *
1348      * - the contract must not be paused.
1349      */
1350     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1351         super._beforeTokenTransfer(from, to, amount);
1352 
1353         require(!paused(), "ERC20Pausable: token transfer while paused");
1354     }
1355 }
1356 
1357 // File: contracts\NuNetToken.sol
1358 
1359 pragma solidity ^0.6.0;
1360 
1361 
1362 
1363 
1364 
1365 
1366 /**
1367  * @dev {ERC20} token, including:
1368  *
1369  *  - ability for holders to burn (destroy) their tokens
1370  *  - a minter role that allows for token minting (creation)
1371  *  - a pauser role that allows to stop all token transfers
1372  *
1373  * This contract uses {AccessControl} to lock permissioned functions using the
1374  * different roles - head to its documentation for details.
1375  *
1376  * The account that deploys the contract will be granted the minter and pauser
1377  * roles, as well as the default admin role, which will let it grant both minter
1378  * and pauser roles to other accounts.
1379  */
1380  contract NuNetToken is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1381     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1382     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1383 
1384     uint256 public constant MAX_SUPPLY = 1000000000 * 10**uint256(6);
1385 
1386     /**
1387      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1388      * account that deploys the contract.
1389      *
1390      * See {ERC20-constructor}.
1391      */
1392     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1393         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1394 
1395         _setupRole(MINTER_ROLE, _msgSender());
1396         _setupRole(PAUSER_ROLE, _msgSender());
1397 
1398         // Setting Demcimal Places to 6
1399         _setupDecimals(6);
1400     }
1401 
1402     /**
1403      * @dev Creates `amount` new tokens for `to`.
1404      *
1405      * See {ERC20-_mint}.
1406      *
1407      * Requirements:
1408      *
1409      * - the caller must have the `MINTER_ROLE`.
1410      */
1411     function mint(address to, uint256 amount) public virtual {
1412         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1413         require(totalSupply().add(amount) <= MAX_SUPPLY, "Mint: Cannot mint more than initial supply");
1414         _mint(to, amount);
1415     }
1416 
1417     /**
1418      * @dev Pauses all token transfers.
1419      *
1420      * See {ERC20Pausable} and {Pausable-_pause}.
1421      *
1422      * Requirements:
1423      *
1424      * - the caller must have the `PAUSER_ROLE`.
1425      */
1426     function pause() public virtual {
1427         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1428         _pause();
1429     }
1430 
1431     /**
1432      * @dev Unpauses all token transfers.
1433      *
1434      * See {ERC20Pausable} and {Pausable-_unpause}.
1435      *
1436      * Requirements:
1437      *
1438      * - the caller must have the `PAUSER_ROLE`.
1439      */
1440     function unpause() public virtual {
1441         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1442         _unpause();
1443     }
1444 
1445     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1446         super._beforeTokenTransfer(from, to, amount);
1447     }
1448 }