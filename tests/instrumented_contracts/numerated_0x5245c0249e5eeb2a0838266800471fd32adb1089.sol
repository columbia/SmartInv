1 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 /**
7  * @dev Library for managing
8  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
9  * types.
10  *
11  * Sets have the following properties:
12  *
13  * - Elements are added, removed, and checked for existence in constant time
14  * (O(1)).
15  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
16  *
17  * ```
18  * contract Example {
19  *     // Add the library methods
20  *     using EnumerableSet for EnumerableSet.AddressSet;
21  *
22  *     // Declare a set state variable
23  *     EnumerableSet.AddressSet private mySet;
24  * }
25  * ```
26  *
27  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
28  * (`UintSet`) are supported.
29  */
30 library EnumerableSet {
31     // To implement this library for multiple types with as little code
32     // repetition as possible, we write it in terms of a generic Set type with
33     // bytes32 values.
34     // The Set implementation uses private functions, and user-facing
35     // implementations (such as AddressSet) are just wrappers around the
36     // underlying Set.
37     // This means that we can only create new EnumerableSets for types that fit
38     // in bytes32.
39 
40     struct Set {
41         // Storage of set values
42         bytes32[] _values;
43 
44         // Position of the value in the `values` array, plus 1 because index 0
45         // means a value is not in the set.
46         mapping (bytes32 => uint256) _indexes;
47     }
48 
49     /**
50      * @dev Add a value to a set. O(1).
51      *
52      * Returns true if the value was added to the set, that is if it was not
53      * already present.
54      */
55     function _add(Set storage set, bytes32 value) private returns (bool) {
56         if (!_contains(set, value)) {
57             set._values.push(value);
58             // The value is stored at length-1, but we add 1 to all indexes
59             // and use 0 as a sentinel value
60             set._indexes[value] = set._values.length;
61             return true;
62         } else {
63             return false;
64         }
65     }
66 
67     /**
68      * @dev Removes a value from a set. O(1).
69      *
70      * Returns true if the value was removed from the set, that is if it was
71      * present.
72      */
73     function _remove(Set storage set, bytes32 value) private returns (bool) {
74         // We read and store the value's index to prevent multiple reads from the same storage slot
75         uint256 valueIndex = set._indexes[value];
76 
77         if (valueIndex != 0) { // Equivalent to contains(set, value)
78             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
79             // the array, and then remove the last element (sometimes called as 'swap and pop').
80             // This modifies the order of the array, as noted in {at}.
81 
82             uint256 toDeleteIndex = valueIndex - 1;
83             uint256 lastIndex = set._values.length - 1;
84 
85             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
86             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
87 
88             bytes32 lastvalue = set._values[lastIndex];
89 
90             // Move the last value to the index where the value to delete is
91             set._values[toDeleteIndex] = lastvalue;
92             // Update the index for the moved value
93             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
94 
95             // Delete the slot where the moved value was stored
96             set._values.pop();
97 
98             // Delete the index for the deleted slot
99             delete set._indexes[value];
100 
101             return true;
102         } else {
103             return false;
104         }
105     }
106 
107     /**
108      * @dev Returns true if the value is in the set. O(1).
109      */
110     function _contains(Set storage set, bytes32 value) private view returns (bool) {
111         return set._indexes[value] != 0;
112     }
113 
114     /**
115      * @dev Returns the number of values on the set. O(1).
116      */
117     function _length(Set storage set) private view returns (uint256) {
118         return set._values.length;
119     }
120 
121    /**
122     * @dev Returns the value stored at position `index` in the set. O(1).
123     *
124     * Note that there are no guarantees on the ordering of values inside the
125     * array, and it may change when more values are added or removed.
126     *
127     * Requirements:
128     *
129     * - `index` must be strictly less than {length}.
130     */
131     function _at(Set storage set, uint256 index) private view returns (bytes32) {
132         require(set._values.length > index, "EnumerableSet: index out of bounds");
133         return set._values[index];
134     }
135 
136     // AddressSet
137 
138     struct AddressSet {
139         Set _inner;
140     }
141 
142     /**
143      * @dev Add a value to a set. O(1).
144      *
145      * Returns true if the value was added to the set, that is if it was not
146      * already present.
147      */
148     function add(AddressSet storage set, address value) internal returns (bool) {
149         return _add(set._inner, bytes32(uint256(value)));
150     }
151 
152     /**
153      * @dev Removes a value from a set. O(1).
154      *
155      * Returns true if the value was removed from the set, that is if it was
156      * present.
157      */
158     function remove(AddressSet storage set, address value) internal returns (bool) {
159         return _remove(set._inner, bytes32(uint256(value)));
160     }
161 
162     /**
163      * @dev Returns true if the value is in the set. O(1).
164      */
165     function contains(AddressSet storage set, address value) internal view returns (bool) {
166         return _contains(set._inner, bytes32(uint256(value)));
167     }
168 
169     /**
170      * @dev Returns the number of values in the set. O(1).
171      */
172     function length(AddressSet storage set) internal view returns (uint256) {
173         return _length(set._inner);
174     }
175 
176    /**
177     * @dev Returns the value stored at position `index` in the set. O(1).
178     *
179     * Note that there are no guarantees on the ordering of values inside the
180     * array, and it may change when more values are added or removed.
181     *
182     * Requirements:
183     *
184     * - `index` must be strictly less than {length}.
185     */
186     function at(AddressSet storage set, uint256 index) internal view returns (address) {
187         return address(uint256(_at(set._inner, index)));
188     }
189 
190 
191     // UintSet
192 
193     struct UintSet {
194         Set _inner;
195     }
196 
197     /**
198      * @dev Add a value to a set. O(1).
199      *
200      * Returns true if the value was added to the set, that is if it was not
201      * already present.
202      */
203     function add(UintSet storage set, uint256 value) internal returns (bool) {
204         return _add(set._inner, bytes32(value));
205     }
206 
207     /**
208      * @dev Removes a value from a set. O(1).
209      *
210      * Returns true if the value was removed from the set, that is if it was
211      * present.
212      */
213     function remove(UintSet storage set, uint256 value) internal returns (bool) {
214         return _remove(set._inner, bytes32(value));
215     }
216 
217     /**
218      * @dev Returns true if the value is in the set. O(1).
219      */
220     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
221         return _contains(set._inner, bytes32(value));
222     }
223 
224     /**
225      * @dev Returns the number of values on the set. O(1).
226      */
227     function length(UintSet storage set) internal view returns (uint256) {
228         return _length(set._inner);
229     }
230 
231    /**
232     * @dev Returns the value stored at position `index` in the set. O(1).
233     *
234     * Note that there are no guarantees on the ordering of values inside the
235     * array, and it may change when more values are added or removed.
236     *
237     * Requirements:
238     *
239     * - `index` must be strictly less than {length}.
240     */
241     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
242         return uint256(_at(set._inner, index));
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Address.sol
247 
248 
249 pragma solidity ^0.6.2;
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
274         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
275         // for accounts without code, i.e. `keccak256('')`
276         bytes32 codehash;
277         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
278         // solhint-disable-next-line no-inline-assembly
279         assembly { codehash := extcodehash(account) }
280         return (codehash != accountHash && codehash != 0x0);
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
303         (bool success, ) = recipient.call{ value: amount }("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain`call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326       return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
336         return _functionCallWithValue(target, data, 0, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but also transferring `value` wei to `target`.
342      *
343      * Requirements:
344      *
345      * - the calling contract must have an ETH balance of at least `value`.
346      * - the called Solidity function must be `payable`.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         return _functionCallWithValue(target, data, value, errorMessage);
363     }
364 
365     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
366         require(isContract(target), "Address: call to non-contract");
367 
368         // solhint-disable-next-line avoid-low-level-calls
369         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 // solhint-disable-next-line no-inline-assembly
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 
389 // File: @openzeppelin/contracts/GSN/Context.sol
390 
391 
392 pragma solidity ^0.6.0;
393 
394 /*
395  * @dev Provides information about the current execution context, including the
396  * sender of the transaction and its data. While these are generally available
397  * via msg.sender and msg.data, they should not be accessed in such a direct
398  * manner, since when dealing with GSN meta-transactions the account sending and
399  * paying for execution may not be the actual sender (as far as an application
400  * is concerned).
401  *
402  * This contract is only required for intermediate, library-like contracts.
403  */
404 abstract contract Context {
405     function _msgSender() internal view virtual returns (address payable) {
406         return msg.sender;
407     }
408 
409     function _msgData() internal view virtual returns (bytes memory) {
410         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
411         return msg.data;
412     }
413 }
414 
415 // File: @openzeppelin/contracts/access/AccessControl.sol
416 
417 
418 pragma solidity ^0.6.0;
419 
420 
421 
422 
423 /**
424  * @dev Contract module that allows children to implement role-based access
425  * control mechanisms.
426  *
427  * Roles are referred to by their `bytes32` identifier. These should be exposed
428  * in the external API and be unique. The best way to achieve this is by
429  * using `public constant` hash digests:
430  *
431  * ```
432  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
433  * ```
434  *
435  * Roles can be used to represent a set of permissions. To restrict access to a
436  * function call, use {hasRole}:
437  *
438  * ```
439  * function foo() public {
440  *     require(hasRole(MY_ROLE, msg.sender));
441  *     ...
442  * }
443  * ```
444  *
445  * Roles can be granted and revoked dynamically via the {grantRole} and
446  * {revokeRole} functions. Each role has an associated admin role, and only
447  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
448  *
449  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
450  * that only accounts with this role will be able to grant or revoke other
451  * roles. More complex role relationships can be created by using
452  * {_setRoleAdmin}.
453  *
454  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
455  * grant and revoke this role. Extra precautions should be taken to secure
456  * accounts that have been granted it.
457  */
458 abstract contract AccessControl is Context {
459     using EnumerableSet for EnumerableSet.AddressSet;
460     using Address for address;
461 
462     struct RoleData {
463         EnumerableSet.AddressSet members;
464         bytes32 adminRole;
465     }
466 
467     mapping (bytes32 => RoleData) private _roles;
468 
469     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
470 
471     /**
472      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
473      *
474      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
475      * {RoleAdminChanged} not being emitted signaling this.
476      *
477      * _Available since v3.1._
478      */
479     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
480 
481     /**
482      * @dev Emitted when `account` is granted `role`.
483      *
484      * `sender` is the account that originated the contract call, an admin role
485      * bearer except when using {_setupRole}.
486      */
487     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
488 
489     /**
490      * @dev Emitted when `account` is revoked `role`.
491      *
492      * `sender` is the account that originated the contract call:
493      *   - if using `revokeRole`, it is the admin role bearer
494      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
495      */
496     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
497 
498     /**
499      * @dev Returns `true` if `account` has been granted `role`.
500      */
501     function hasRole(bytes32 role, address account) public view returns (bool) {
502         return _roles[role].members.contains(account);
503     }
504 
505     /**
506      * @dev Returns the number of accounts that have `role`. Can be used
507      * together with {getRoleMember} to enumerate all bearers of a role.
508      */
509     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
510         return _roles[role].members.length();
511     }
512 
513     /**
514      * @dev Returns one of the accounts that have `role`. `index` must be a
515      * value between 0 and {getRoleMemberCount}, non-inclusive.
516      *
517      * Role bearers are not sorted in any particular way, and their ordering may
518      * change at any point.
519      *
520      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
521      * you perform all queries on the same block. See the following
522      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
523      * for more information.
524      */
525     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
526         return _roles[role].members.at(index);
527     }
528 
529     /**
530      * @dev Returns the admin role that controls `role`. See {grantRole} and
531      * {revokeRole}.
532      *
533      * To change a role's admin, use {_setRoleAdmin}.
534      */
535     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
536         return _roles[role].adminRole;
537     }
538 
539     /**
540      * @dev Grants `role` to `account`.
541      *
542      * If `account` had not been already granted `role`, emits a {RoleGranted}
543      * event.
544      *
545      * Requirements:
546      *
547      * - the caller must have ``role``'s admin role.
548      */
549     function grantRole(bytes32 role, address account) public virtual {
550         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
551 
552         _grantRole(role, account);
553     }
554 
555     /**
556      * @dev Revokes `role` from `account`.
557      *
558      * If `account` had been granted `role`, emits a {RoleRevoked} event.
559      *
560      * Requirements:
561      *
562      * - the caller must have ``role``'s admin role.
563      */
564     function revokeRole(bytes32 role, address account) public virtual {
565         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
566 
567         _revokeRole(role, account);
568     }
569 
570     /**
571      * @dev Revokes `role` from the calling account.
572      *
573      * Roles are often managed via {grantRole} and {revokeRole}: this function's
574      * purpose is to provide a mechanism for accounts to lose their privileges
575      * if they are compromised (such as when a trusted device is misplaced).
576      *
577      * If the calling account had been granted `role`, emits a {RoleRevoked}
578      * event.
579      *
580      * Requirements:
581      *
582      * - the caller must be `account`.
583      */
584     function renounceRole(bytes32 role, address account) public virtual {
585         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
586 
587         _revokeRole(role, account);
588     }
589 
590     /**
591      * @dev Grants `role` to `account`.
592      *
593      * If `account` had not been already granted `role`, emits a {RoleGranted}
594      * event. Note that unlike {grantRole}, this function doesn't perform any
595      * checks on the calling account.
596      *
597      * [WARNING]
598      * ====
599      * This function should only be called from the constructor when setting
600      * up the initial roles for the system.
601      *
602      * Using this function in any other way is effectively circumventing the admin
603      * system imposed by {AccessControl}.
604      * ====
605      */
606     function _setupRole(bytes32 role, address account) internal virtual {
607         _grantRole(role, account);
608     }
609 
610     /**
611      * @dev Sets `adminRole` as ``role``'s admin role.
612      *
613      * Emits a {RoleAdminChanged} event.
614      */
615     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
616         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
617         _roles[role].adminRole = adminRole;
618     }
619 
620     function _grantRole(bytes32 role, address account) private {
621         if (_roles[role].members.add(account)) {
622             emit RoleGranted(role, account, _msgSender());
623         }
624     }
625 
626     function _revokeRole(bytes32 role, address account) private {
627         if (_roles[role].members.remove(account)) {
628             emit RoleRevoked(role, account, _msgSender());
629         }
630     }
631 }
632 
633 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
634 
635 
636 pragma solidity ^0.6.0;
637 
638 /**
639  * @dev Interface of the ERC20 standard as defined in the EIP.
640  */
641 interface IERC20 {
642     /**
643      * @dev Returns the amount of tokens in existence.
644      */
645     function totalSupply() external view returns (uint256);
646 
647     /**
648      * @dev Returns the amount of tokens owned by `account`.
649      */
650     function balanceOf(address account) external view returns (uint256);
651 
652     /**
653      * @dev Moves `amount` tokens from the caller's account to `recipient`.
654      *
655      * Returns a boolean value indicating whether the operation succeeded.
656      *
657      * Emits a {Transfer} event.
658      */
659     function transfer(address recipient, uint256 amount) external returns (bool);
660 
661     /**
662      * @dev Returns the remaining number of tokens that `spender` will be
663      * allowed to spend on behalf of `owner` through {transferFrom}. This is
664      * zero by default.
665      *
666      * This value changes when {approve} or {transferFrom} are called.
667      */
668     function allowance(address owner, address spender) external view returns (uint256);
669 
670     /**
671      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
672      *
673      * Returns a boolean value indicating whether the operation succeeded.
674      *
675      * IMPORTANT: Beware that changing an allowance with this method brings the risk
676      * that someone may use both the old and the new allowance by unfortunate
677      * transaction ordering. One possible solution to mitigate this race
678      * condition is to first reduce the spender's allowance to 0 and set the
679      * desired value afterwards:
680      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
681      *
682      * Emits an {Approval} event.
683      */
684     function approve(address spender, uint256 amount) external returns (bool);
685 
686     /**
687      * @dev Moves `amount` tokens from `sender` to `recipient` using the
688      * allowance mechanism. `amount` is then deducted from the caller's
689      * allowance.
690      *
691      * Returns a boolean value indicating whether the operation succeeded.
692      *
693      * Emits a {Transfer} event.
694      */
695     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
696 
697     /**
698      * @dev Emitted when `value` tokens are moved from one account (`from`) to
699      * another (`to`).
700      *
701      * Note that `value` may be zero.
702      */
703     event Transfer(address indexed from, address indexed to, uint256 value);
704 
705     /**
706      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
707      * a call to {approve}. `value` is the new allowance.
708      */
709     event Approval(address indexed owner, address indexed spender, uint256 value);
710 }
711 
712 // File: @openzeppelin/contracts/math/SafeMath.sol
713 
714 
715 pragma solidity ^0.6.0;
716 
717 /**
718  * @dev Wrappers over Solidity's arithmetic operations with added overflow
719  * checks.
720  *
721  * Arithmetic operations in Solidity wrap on overflow. This can easily result
722  * in bugs, because programmers usually assume that an overflow raises an
723  * error, which is the standard behavior in high level programming languages.
724  * `SafeMath` restores this intuition by reverting the transaction when an
725  * operation overflows.
726  *
727  * Using this library instead of the unchecked operations eliminates an entire
728  * class of bugs, so it's recommended to use it always.
729  */
730 library SafeMath {
731     /**
732      * @dev Returns the addition of two unsigned integers, reverting on
733      * overflow.
734      *
735      * Counterpart to Solidity's `+` operator.
736      *
737      * Requirements:
738      *
739      * - Addition cannot overflow.
740      */
741     function add(uint256 a, uint256 b) internal pure returns (uint256) {
742         uint256 c = a + b;
743         require(c >= a, "SafeMath: addition overflow");
744 
745         return c;
746     }
747 
748     /**
749      * @dev Returns the subtraction of two unsigned integers, reverting on
750      * overflow (when the result is negative).
751      *
752      * Counterpart to Solidity's `-` operator.
753      *
754      * Requirements:
755      *
756      * - Subtraction cannot overflow.
757      */
758     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
759         return sub(a, b, "SafeMath: subtraction overflow");
760     }
761 
762     /**
763      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
764      * overflow (when the result is negative).
765      *
766      * Counterpart to Solidity's `-` operator.
767      *
768      * Requirements:
769      *
770      * - Subtraction cannot overflow.
771      */
772     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
773         require(b <= a, errorMessage);
774         uint256 c = a - b;
775 
776         return c;
777     }
778 
779     /**
780      * @dev Returns the multiplication of two unsigned integers, reverting on
781      * overflow.
782      *
783      * Counterpart to Solidity's `*` operator.
784      *
785      * Requirements:
786      *
787      * - Multiplication cannot overflow.
788      */
789     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
790         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
791         // benefit is lost if 'b' is also tested.
792         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
793         if (a == 0) {
794             return 0;
795         }
796 
797         uint256 c = a * b;
798         require(c / a == b, "SafeMath: multiplication overflow");
799 
800         return c;
801     }
802 
803     /**
804      * @dev Returns the integer division of two unsigned integers. Reverts on
805      * division by zero. The result is rounded towards zero.
806      *
807      * Counterpart to Solidity's `/` operator. Note: this function uses a
808      * `revert` opcode (which leaves remaining gas untouched) while Solidity
809      * uses an invalid opcode to revert (consuming all remaining gas).
810      *
811      * Requirements:
812      *
813      * - The divisor cannot be zero.
814      */
815     function div(uint256 a, uint256 b) internal pure returns (uint256) {
816         return div(a, b, "SafeMath: division by zero");
817     }
818 
819     /**
820      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
821      * division by zero. The result is rounded towards zero.
822      *
823      * Counterpart to Solidity's `/` operator. Note: this function uses a
824      * `revert` opcode (which leaves remaining gas untouched) while Solidity
825      * uses an invalid opcode to revert (consuming all remaining gas).
826      *
827      * Requirements:
828      *
829      * - The divisor cannot be zero.
830      */
831     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
832         require(b > 0, errorMessage);
833         uint256 c = a / b;
834         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
835 
836         return c;
837     }
838 
839     /**
840      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
841      * Reverts when dividing by zero.
842      *
843      * Counterpart to Solidity's `%` operator. This function uses a `revert`
844      * opcode (which leaves remaining gas untouched) while Solidity uses an
845      * invalid opcode to revert (consuming all remaining gas).
846      *
847      * Requirements:
848      *
849      * - The divisor cannot be zero.
850      */
851     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
852         return mod(a, b, "SafeMath: modulo by zero");
853     }
854 
855     /**
856      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
857      * Reverts with custom message when dividing by zero.
858      *
859      * Counterpart to Solidity's `%` operator. This function uses a `revert`
860      * opcode (which leaves remaining gas untouched) while Solidity uses an
861      * invalid opcode to revert (consuming all remaining gas).
862      *
863      * Requirements:
864      *
865      * - The divisor cannot be zero.
866      */
867     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
868         require(b != 0, errorMessage);
869         return a % b;
870     }
871 }
872 
873 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
874 
875 
876 pragma solidity ^0.6.0;
877 
878 
879 
880 
881 
882 /**
883  * @dev Implementation of the {IERC20} interface.
884  *
885  * This implementation is agnostic to the way tokens are created. This means
886  * that a supply mechanism has to be added in a derived contract using {_mint}.
887  * For a generic mechanism see {ERC20PresetMinterPauser}.
888  *
889  * TIP: For a detailed writeup see our guide
890  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
891  * to implement supply mechanisms].
892  *
893  * We have followed general OpenZeppelin guidelines: functions revert instead
894  * of returning `false` on failure. This behavior is nonetheless conventional
895  * and does not conflict with the expectations of ERC20 applications.
896  *
897  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
898  * This allows applications to reconstruct the allowance for all accounts just
899  * by listening to said events. Other implementations of the EIP may not emit
900  * these events, as it isn't required by the specification.
901  *
902  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
903  * functions have been added to mitigate the well-known issues around setting
904  * allowances. See {IERC20-approve}.
905  */
906 contract ERC20 is Context, IERC20 {
907     using SafeMath for uint256;
908     using Address for address;
909 
910     mapping (address => uint256) private _balances;
911 
912     mapping (address => mapping (address => uint256)) private _allowances;
913 
914     uint256 private _totalSupply;
915 
916     string private _name;
917     string private _symbol;
918     uint8 private _decimals;
919 
920     /**
921      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
922      * a default value of 18.
923      *
924      * To select a different value for {decimals}, use {_setupDecimals}.
925      *
926      * All three of these values are immutable: they can only be set once during
927      * construction.
928      */
929     constructor (string memory name, string memory symbol) public {
930         _name = name;
931         _symbol = symbol;
932         _decimals = 18;
933     }
934 
935     /**
936      * @dev Returns the name of the token.
937      */
938     function name() public view returns (string memory) {
939         return _name;
940     }
941 
942     /**
943      * @dev Returns the symbol of the token, usually a shorter version of the
944      * name.
945      */
946     function symbol() public view returns (string memory) {
947         return _symbol;
948     }
949 
950     /**
951      * @dev Returns the number of decimals used to get its user representation.
952      * For example, if `decimals` equals `2`, a balance of `505` tokens should
953      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
954      *
955      * Tokens usually opt for a value of 18, imitating the relationship between
956      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
957      * called.
958      *
959      * NOTE: This information is only used for _display_ purposes: it in
960      * no way affects any of the arithmetic of the contract, including
961      * {IERC20-balanceOf} and {IERC20-transfer}.
962      */
963     function decimals() public view returns (uint8) {
964         return _decimals;
965     }
966 
967     /**
968      * @dev See {IERC20-totalSupply}.
969      */
970     function totalSupply() public view override returns (uint256) {
971         return _totalSupply;
972     }
973 
974     /**
975      * @dev See {IERC20-balanceOf}.
976      */
977     function balanceOf(address account) public view override returns (uint256) {
978         return _balances[account];
979     }
980 
981     /**
982      * @dev See {IERC20-transfer}.
983      *
984      * Requirements:
985      *
986      * - `recipient` cannot be the zero address.
987      * - the caller must have a balance of at least `amount`.
988      */
989     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
990         _transfer(_msgSender(), recipient, amount);
991         return true;
992     }
993 
994     /**
995      * @dev See {IERC20-allowance}.
996      */
997     function allowance(address owner, address spender) public view virtual override returns (uint256) {
998         return _allowances[owner][spender];
999     }
1000 
1001     /**
1002      * @dev See {IERC20-approve}.
1003      *
1004      * Requirements:
1005      *
1006      * - `spender` cannot be the zero address.
1007      */
1008     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1009         _approve(_msgSender(), spender, amount);
1010         return true;
1011     }
1012 
1013     /**
1014      * @dev See {IERC20-transferFrom}.
1015      *
1016      * Emits an {Approval} event indicating the updated allowance. This is not
1017      * required by the EIP. See the note at the beginning of {ERC20};
1018      *
1019      * Requirements:
1020      * - `sender` and `recipient` cannot be the zero address.
1021      * - `sender` must have a balance of at least `amount`.
1022      * - the caller must have allowance for ``sender``'s tokens of at least
1023      * `amount`.
1024      */
1025     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1026         _transfer(sender, recipient, amount);
1027         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1028         return true;
1029     }
1030 
1031     /**
1032      * @dev Atomically increases the allowance granted to `spender` by the caller.
1033      *
1034      * This is an alternative to {approve} that can be used as a mitigation for
1035      * problems described in {IERC20-approve}.
1036      *
1037      * Emits an {Approval} event indicating the updated allowance.
1038      *
1039      * Requirements:
1040      *
1041      * - `spender` cannot be the zero address.
1042      */
1043     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1044         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1045         return true;
1046     }
1047 
1048     /**
1049      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1050      *
1051      * This is an alternative to {approve} that can be used as a mitigation for
1052      * problems described in {IERC20-approve}.
1053      *
1054      * Emits an {Approval} event indicating the updated allowance.
1055      *
1056      * Requirements:
1057      *
1058      * - `spender` cannot be the zero address.
1059      * - `spender` must have allowance for the caller of at least
1060      * `subtractedValue`.
1061      */
1062     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1063         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1064         return true;
1065     }
1066 
1067     /**
1068      * @dev Moves tokens `amount` from `sender` to `recipient`.
1069      *
1070      * This is internal function is equivalent to {transfer}, and can be used to
1071      * e.g. implement automatic token fees, slashing mechanisms, etc.
1072      *
1073      * Emits a {Transfer} event.
1074      *
1075      * Requirements:
1076      *
1077      * - `sender` cannot be the zero address.
1078      * - `recipient` cannot be the zero address.
1079      * - `sender` must have a balance of at least `amount`.
1080      */
1081     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1082         require(sender != address(0), "ERC20: transfer from the zero address");
1083         require(recipient != address(0), "ERC20: transfer to the zero address");
1084 
1085         _beforeTokenTransfer(sender, recipient, amount);
1086 
1087         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1088         _balances[recipient] = _balances[recipient].add(amount);
1089         emit Transfer(sender, recipient, amount);
1090     }
1091 
1092     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1093      * the total supply.
1094      *
1095      * Emits a {Transfer} event with `from` set to the zero address.
1096      *
1097      * Requirements
1098      *
1099      * - `to` cannot be the zero address.
1100      */
1101     function _mint(address account, uint256 amount) internal virtual {
1102         require(account != address(0), "ERC20: mint to the zero address");
1103 
1104         _beforeTokenTransfer(address(0), account, amount);
1105 
1106         _totalSupply = _totalSupply.add(amount);
1107         _balances[account] = _balances[account].add(amount);
1108         emit Transfer(address(0), account, amount);
1109     }
1110 
1111     /**
1112      * @dev Destroys `amount` tokens from `account`, reducing the
1113      * total supply.
1114      *
1115      * Emits a {Transfer} event with `to` set to the zero address.
1116      *
1117      * Requirements
1118      *
1119      * - `account` cannot be the zero address.
1120      * - `account` must have at least `amount` tokens.
1121      */
1122     function _burn(address account, uint256 amount) internal virtual {
1123         require(account != address(0), "ERC20: burn from the zero address");
1124 
1125         _beforeTokenTransfer(account, address(0), amount);
1126 
1127         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1128         _totalSupply = _totalSupply.sub(amount);
1129         emit Transfer(account, address(0), amount);
1130     }
1131 
1132     /**
1133      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1134      *
1135      * This is internal function is equivalent to `approve`, and can be used to
1136      * e.g. set automatic allowances for certain subsystems, etc.
1137      *
1138      * Emits an {Approval} event.
1139      *
1140      * Requirements:
1141      *
1142      * - `owner` cannot be the zero address.
1143      * - `spender` cannot be the zero address.
1144      */
1145     function _approve(address owner, address spender, uint256 amount) internal virtual {
1146         require(owner != address(0), "ERC20: approve from the zero address");
1147         require(spender != address(0), "ERC20: approve to the zero address");
1148 
1149         _allowances[owner][spender] = amount;
1150         emit Approval(owner, spender, amount);
1151     }
1152 
1153     /**
1154      * @dev Sets {decimals} to a value other than the default one of 18.
1155      *
1156      * WARNING: This function should only be called from the constructor. Most
1157      * applications that interact with token contracts will not expect
1158      * {decimals} to ever change, and may work incorrectly if it does.
1159      */
1160     function _setupDecimals(uint8 decimals_) internal {
1161         _decimals = decimals_;
1162     }
1163 
1164     /**
1165      * @dev Hook that is called before any transfer of tokens. This includes
1166      * minting and burning.
1167      *
1168      * Calling conditions:
1169      *
1170      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1171      * will be to transferred to `to`.
1172      * - when `from` is zero, `amount` tokens will be minted for `to`.
1173      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1174      * - `from` and `to` are never both zero.
1175      *
1176      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1177      */
1178     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1179 }
1180 
1181 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1182 
1183 
1184 pragma solidity ^0.6.0;
1185 
1186 
1187 
1188 /**
1189  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1190  * tokens and those that they have an allowance for, in a way that can be
1191  * recognized off-chain (via event analysis).
1192  */
1193 abstract contract ERC20Burnable is Context, ERC20 {
1194     /**
1195      * @dev Destroys `amount` tokens from the caller.
1196      *
1197      * See {ERC20-_burn}.
1198      */
1199     function burn(uint256 amount) public virtual {
1200         _burn(_msgSender(), amount);
1201     }
1202 
1203     /**
1204      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1205      * allowance.
1206      *
1207      * See {ERC20-_burn} and {ERC20-allowance}.
1208      *
1209      * Requirements:
1210      *
1211      * - the caller must have allowance for ``accounts``'s tokens of at least
1212      * `amount`.
1213      */
1214     function burnFrom(address account, uint256 amount) public virtual {
1215         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1216 
1217         _approve(account, _msgSender(), decreasedAllowance);
1218         _burn(account, amount);
1219     }
1220 }
1221 
1222 // File: @openzeppelin/contracts/utils/Pausable.sol
1223 
1224 
1225 pragma solidity ^0.6.0;
1226 
1227 
1228 /**
1229  * @dev Contract module which allows children to implement an emergency stop
1230  * mechanism that can be triggered by an authorized account.
1231  *
1232  * This module is used through inheritance. It will make available the
1233  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1234  * the functions of your contract. Note that they will not be pausable by
1235  * simply including this module, only once the modifiers are put in place.
1236  */
1237 contract Pausable is Context {
1238     /**
1239      * @dev Emitted when the pause is triggered by `account`.
1240      */
1241     event Paused(address account);
1242 
1243     /**
1244      * @dev Emitted when the pause is lifted by `account`.
1245      */
1246     event Unpaused(address account);
1247 
1248     bool private _paused;
1249 
1250     /**
1251      * @dev Initializes the contract in unpaused state.
1252      */
1253     constructor () internal {
1254         _paused = false;
1255     }
1256 
1257     /**
1258      * @dev Returns true if the contract is paused, and false otherwise.
1259      */
1260     function paused() public view returns (bool) {
1261         return _paused;
1262     }
1263 
1264     /**
1265      * @dev Modifier to make a function callable only when the contract is not paused.
1266      *
1267      * Requirements:
1268      *
1269      * - The contract must not be paused.
1270      */
1271     modifier whenNotPaused() {
1272         require(!_paused, "Pausable: paused");
1273         _;
1274     }
1275 
1276     /**
1277      * @dev Modifier to make a function callable only when the contract is paused.
1278      *
1279      * Requirements:
1280      *
1281      * - The contract must be paused.
1282      */
1283     modifier whenPaused() {
1284         require(_paused, "Pausable: not paused");
1285         _;
1286     }
1287 
1288     /**
1289      * @dev Triggers stopped state.
1290      *
1291      * Requirements:
1292      *
1293      * - The contract must not be paused.
1294      */
1295     function _pause() internal virtual whenNotPaused {
1296         _paused = true;
1297         emit Paused(_msgSender());
1298     }
1299 
1300     /**
1301      * @dev Returns to normal state.
1302      *
1303      * Requirements:
1304      *
1305      * - The contract must be paused.
1306      */
1307     function _unpause() internal virtual whenPaused {
1308         _paused = false;
1309         emit Unpaused(_msgSender());
1310     }
1311 }
1312 
1313 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
1314 
1315 
1316 pragma solidity ^0.6.0;
1317 
1318 
1319 
1320 /**
1321  * @dev ERC20 token with pausable token transfers, minting and burning.
1322  *
1323  * Useful for scenarios such as preventing trades until the end of an evaluation
1324  * period, or having an emergency switch for freezing all token transfers in the
1325  * event of a large bug.
1326  */
1327 abstract contract ERC20Pausable is ERC20, Pausable {
1328     /**
1329      * @dev See {ERC20-_beforeTokenTransfer}.
1330      *
1331      * Requirements:
1332      *
1333      * - the contract must not be paused.
1334      */
1335     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1336         super._beforeTokenTransfer(from, to, amount);
1337 
1338         require(!paused(), "ERC20Pausable: token transfer while paused");
1339     }
1340 }
1341 
1342 // File: @openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol
1343 
1344 
1345 pragma solidity ^0.6.0;
1346 
1347 
1348 
1349 
1350 
1351 
1352 /**
1353  * @dev {ERC20} token, including:
1354  *
1355  *  - ability for holders to burn (destroy) their tokens
1356  *  - a minter role that allows for token minting (creation)
1357  *  - a pauser role that allows to stop all token transfers
1358  *
1359  * This contract uses {AccessControl} to lock permissioned functions using the
1360  * different roles - head to its documentation for details.
1361  *
1362  * The account that deploys the contract will be granted the minter and pauser
1363  * roles, as well as the default admin role, which will let it grant both minter
1364  * and pauser roles to other accounts.
1365  */
1366 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1367     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1368     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1369 
1370     /**
1371      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1372      * account that deploys the contract.
1373      *
1374      * See {ERC20-constructor}.
1375      */
1376     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1377         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1378 
1379         _setupRole(MINTER_ROLE, _msgSender());
1380         _setupRole(PAUSER_ROLE, _msgSender());
1381     }
1382 
1383     /**
1384      * @dev Creates `amount` new tokens for `to`.
1385      *
1386      * See {ERC20-_mint}.
1387      *
1388      * Requirements:
1389      *
1390      * - the caller must have the `MINTER_ROLE`.
1391      */
1392     function mint(address to, uint256 amount) public virtual {
1393         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1394         _mint(to, amount);
1395     }
1396 
1397     /**
1398      * @dev Pauses all token transfers.
1399      *
1400      * See {ERC20Pausable} and {Pausable-_pause}.
1401      *
1402      * Requirements:
1403      *
1404      * - the caller must have the `PAUSER_ROLE`.
1405      */
1406     function pause() public virtual {
1407         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1408         _pause();
1409     }
1410 
1411     /**
1412      * @dev Unpauses all token transfers.
1413      *
1414      * See {ERC20Pausable} and {Pausable-_unpause}.
1415      *
1416      * Requirements:
1417      *
1418      * - the caller must have the `PAUSER_ROLE`.
1419      */
1420     function unpause() public virtual {
1421         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1422         _unpause();
1423     }
1424 
1425     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1426         super._beforeTokenTransfer(from, to, amount);
1427     }
1428 }
1429 
1430 // File: contracts/Token.sol
1431 
1432 pragma solidity ^0.6.0;
1433 
1434 
1435 contract Token is ERC20PresetMinterPauser {
1436     constructor(string memory name, string memory symbol, uint8 decimals) public ERC20PresetMinterPauser(name, symbol) {
1437         _setupDecimals(decimals);
1438     }
1439 }