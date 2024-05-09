1 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
2 
3 // SPDX-License-Identifier: MIT AND GPL-3.0-or-later
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
391 pragma solidity ^0.6.0;
392 
393 /*
394  * @dev Provides information about the current execution context, including the
395  * sender of the transaction and its data. While these are generally available
396  * via msg.sender and msg.data, they should not be accessed in such a direct
397  * manner, since when dealing with GSN meta-transactions the account sending and
398  * paying for execution may not be the actual sender (as far as an application
399  * is concerned).
400  *
401  * This contract is only required for intermediate, library-like contracts.
402  */
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address payable) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes memory) {
409         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
410         return msg.data;
411     }
412 }
413 
414 // File: @openzeppelin/contracts/access/AccessControl.sol
415 
416 pragma solidity ^0.6.0;
417 
418 
419 
420 
421 /**
422  * @dev Contract module that allows children to implement role-based access
423  * control mechanisms.
424  *
425  * Roles are referred to by their `bytes32` identifier. These should be exposed
426  * in the external API and be unique. The best way to achieve this is by
427  * using `public constant` hash digests:
428  *
429  * ```
430  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
431  * ```
432  *
433  * Roles can be used to represent a set of permissions. To restrict access to a
434  * function call, use {hasRole}:
435  *
436  * ```
437  * function foo() public {
438  *     require(hasRole(MY_ROLE, msg.sender));
439  *     ...
440  * }
441  * ```
442  *
443  * Roles can be granted and revoked dynamically via the {grantRole} and
444  * {revokeRole} functions. Each role has an associated admin role, and only
445  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
446  *
447  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
448  * that only accounts with this role will be able to grant or revoke other
449  * roles. More complex role relationships can be created by using
450  * {_setRoleAdmin}.
451  *
452  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
453  * grant and revoke this role. Extra precautions should be taken to secure
454  * accounts that have been granted it.
455  */
456 abstract contract AccessControl is Context {
457     using EnumerableSet for EnumerableSet.AddressSet;
458     using Address for address;
459 
460     struct RoleData {
461         EnumerableSet.AddressSet members;
462         bytes32 adminRole;
463     }
464 
465     mapping (bytes32 => RoleData) private _roles;
466 
467     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
468 
469     /**
470      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
471      *
472      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
473      * {RoleAdminChanged} not being emitted signaling this.
474      *
475      * _Available since v3.1._
476      */
477     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
478 
479     /**
480      * @dev Emitted when `account` is granted `role`.
481      *
482      * `sender` is the account that originated the contract call, an admin role
483      * bearer except when using {_setupRole}.
484      */
485     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
486 
487     /**
488      * @dev Emitted when `account` is revoked `role`.
489      *
490      * `sender` is the account that originated the contract call:
491      *   - if using `revokeRole`, it is the admin role bearer
492      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
493      */
494     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
495 
496     /**
497      * @dev Returns `true` if `account` has been granted `role`.
498      */
499     function hasRole(bytes32 role, address account) public view returns (bool) {
500         return _roles[role].members.contains(account);
501     }
502 
503     /**
504      * @dev Returns the number of accounts that have `role`. Can be used
505      * together with {getRoleMember} to enumerate all bearers of a role.
506      */
507     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
508         return _roles[role].members.length();
509     }
510 
511     /**
512      * @dev Returns one of the accounts that have `role`. `index` must be a
513      * value between 0 and {getRoleMemberCount}, non-inclusive.
514      *
515      * Role bearers are not sorted in any particular way, and their ordering may
516      * change at any point.
517      *
518      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
519      * you perform all queries on the same block. See the following
520      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
521      * for more information.
522      */
523     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
524         return _roles[role].members.at(index);
525     }
526 
527     /**
528      * @dev Returns the admin role that controls `role`. See {grantRole} and
529      * {revokeRole}.
530      *
531      * To change a role's admin, use {_setRoleAdmin}.
532      */
533     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
534         return _roles[role].adminRole;
535     }
536 
537     /**
538      * @dev Grants `role` to `account`.
539      *
540      * If `account` had not been already granted `role`, emits a {RoleGranted}
541      * event.
542      *
543      * Requirements:
544      *
545      * - the caller must have ``role``'s admin role.
546      */
547     function grantRole(bytes32 role, address account) public virtual {
548         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
549 
550         _grantRole(role, account);
551     }
552 
553     /**
554      * @dev Revokes `role` from `account`.
555      *
556      * If `account` had been granted `role`, emits a {RoleRevoked} event.
557      *
558      * Requirements:
559      *
560      * - the caller must have ``role``'s admin role.
561      */
562     function revokeRole(bytes32 role, address account) public virtual {
563         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
564 
565         _revokeRole(role, account);
566     }
567 
568     /**
569      * @dev Revokes `role` from the calling account.
570      *
571      * Roles are often managed via {grantRole} and {revokeRole}: this function's
572      * purpose is to provide a mechanism for accounts to lose their privileges
573      * if they are compromised (such as when a trusted device is misplaced).
574      *
575      * If the calling account had been granted `role`, emits a {RoleRevoked}
576      * event.
577      *
578      * Requirements:
579      *
580      * - the caller must be `account`.
581      */
582     function renounceRole(bytes32 role, address account) public virtual {
583         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
584 
585         _revokeRole(role, account);
586     }
587 
588     /**
589      * @dev Grants `role` to `account`.
590      *
591      * If `account` had not been already granted `role`, emits a {RoleGranted}
592      * event. Note that unlike {grantRole}, this function doesn't perform any
593      * checks on the calling account.
594      *
595      * [WARNING]
596      * ====
597      * This function should only be called from the constructor when setting
598      * up the initial roles for the system.
599      *
600      * Using this function in any other way is effectively circumventing the admin
601      * system imposed by {AccessControl}.
602      * ====
603      */
604     function _setupRole(bytes32 role, address account) internal virtual {
605         _grantRole(role, account);
606     }
607 
608     /**
609      * @dev Sets `adminRole` as ``role``'s admin role.
610      *
611      * Emits a {RoleAdminChanged} event.
612      */
613     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
614         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
615         _roles[role].adminRole = adminRole;
616     }
617 
618     function _grantRole(bytes32 role, address account) private {
619         if (_roles[role].members.add(account)) {
620             emit RoleGranted(role, account, _msgSender());
621         }
622     }
623 
624     function _revokeRole(bytes32 role, address account) private {
625         if (_roles[role].members.remove(account)) {
626             emit RoleRevoked(role, account, _msgSender());
627         }
628     }
629 }
630 
631 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
632 
633 
634 pragma solidity ^0.6.0;
635 
636 /**
637  * @dev Interface of the ERC20 standard as defined in the EIP.
638  */
639 interface IERC20 {
640     /**
641      * @dev Returns the amount of tokens in existence.
642      */
643     function totalSupply() external view returns (uint256);
644 
645     /**
646      * @dev Returns the amount of tokens owned by `account`.
647      */
648     function balanceOf(address account) external view returns (uint256);
649 
650     /**
651      * @dev Moves `amount` tokens from the caller's account to `recipient`.
652      *
653      * Returns a boolean value indicating whether the operation succeeded.
654      *
655      * Emits a {Transfer} event.
656      */
657     function transfer(address recipient, uint256 amount) external returns (bool);
658 
659     /**
660      * @dev Returns the remaining number of tokens that `spender` will be
661      * allowed to spend on behalf of `owner` through {transferFrom}. This is
662      * zero by default.
663      *
664      * This value changes when {approve} or {transferFrom} are called.
665      */
666     function allowance(address owner, address spender) external view returns (uint256);
667 
668     /**
669      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
670      *
671      * Returns a boolean value indicating whether the operation succeeded.
672      *
673      * IMPORTANT: Beware that changing an allowance with this method brings the risk
674      * that someone may use both the old and the new allowance by unfortunate
675      * transaction ordering. One possible solution to mitigate this race
676      * condition is to first reduce the spender's allowance to 0 and set the
677      * desired value afterwards:
678      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
679      *
680      * Emits an {Approval} event.
681      */
682     function approve(address spender, uint256 amount) external returns (bool);
683 
684     /**
685      * @dev Moves `amount` tokens from `sender` to `recipient` using the
686      * allowance mechanism. `amount` is then deducted from the caller's
687      * allowance.
688      *
689      * Returns a boolean value indicating whether the operation succeeded.
690      *
691      * Emits a {Transfer} event.
692      */
693     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
694 
695     /**
696      * @dev Emitted when `value` tokens are moved from one account (`from`) to
697      * another (`to`).
698      *
699      * Note that `value` may be zero.
700      */
701     event Transfer(address indexed from, address indexed to, uint256 value);
702 
703     /**
704      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
705      * a call to {approve}. `value` is the new allowance.
706      */
707     event Approval(address indexed owner, address indexed spender, uint256 value);
708 }
709 
710 // File: @openzeppelin/contracts/math/SafeMath.sol
711 
712 
713 pragma solidity ^0.6.0;
714 
715 /**
716  * @dev Wrappers over Solidity's arithmetic operations with added overflow
717  * checks.
718  *
719  * Arithmetic operations in Solidity wrap on overflow. This can easily result
720  * in bugs, because programmers usually assume that an overflow raises an
721  * error, which is the standard behavior in high level programming languages.
722  * `SafeMath` restores this intuition by reverting the transaction when an
723  * operation overflows.
724  *
725  * Using this library instead of the unchecked operations eliminates an entire
726  * class of bugs, so it's recommended to use it always.
727  */
728 library SafeMath {
729     /**
730      * @dev Returns the addition of two unsigned integers, reverting on
731      * overflow.
732      *
733      * Counterpart to Solidity's `+` operator.
734      *
735      * Requirements:
736      *
737      * - Addition cannot overflow.
738      */
739     function add(uint256 a, uint256 b) internal pure returns (uint256) {
740         uint256 c = a + b;
741         require(c >= a, "SafeMath: addition overflow");
742 
743         return c;
744     }
745 
746     /**
747      * @dev Returns the subtraction of two unsigned integers, reverting on
748      * overflow (when the result is negative).
749      *
750      * Counterpart to Solidity's `-` operator.
751      *
752      * Requirements:
753      *
754      * - Subtraction cannot overflow.
755      */
756     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
757         return sub(a, b, "SafeMath: subtraction overflow");
758     }
759 
760     /**
761      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
762      * overflow (when the result is negative).
763      *
764      * Counterpart to Solidity's `-` operator.
765      *
766      * Requirements:
767      *
768      * - Subtraction cannot overflow.
769      */
770     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
771         require(b <= a, errorMessage);
772         uint256 c = a - b;
773 
774         return c;
775     }
776 
777     /**
778      * @dev Returns the multiplication of two unsigned integers, reverting on
779      * overflow.
780      *
781      * Counterpart to Solidity's `*` operator.
782      *
783      * Requirements:
784      *
785      * - Multiplication cannot overflow.
786      */
787     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
788         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
789         // benefit is lost if 'b' is also tested.
790         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
791         if (a == 0) {
792             return 0;
793         }
794 
795         uint256 c = a * b;
796         require(c / a == b, "SafeMath: multiplication overflow");
797 
798         return c;
799     }
800 
801     /**
802      * @dev Returns the integer division of two unsigned integers. Reverts on
803      * division by zero. The result is rounded towards zero.
804      *
805      * Counterpart to Solidity's `/` operator. Note: this function uses a
806      * `revert` opcode (which leaves remaining gas untouched) while Solidity
807      * uses an invalid opcode to revert (consuming all remaining gas).
808      *
809      * Requirements:
810      *
811      * - The divisor cannot be zero.
812      */
813     function div(uint256 a, uint256 b) internal pure returns (uint256) {
814         return div(a, b, "SafeMath: division by zero");
815     }
816 
817     /**
818      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
819      * division by zero. The result is rounded towards zero.
820      *
821      * Counterpart to Solidity's `/` operator. Note: this function uses a
822      * `revert` opcode (which leaves remaining gas untouched) while Solidity
823      * uses an invalid opcode to revert (consuming all remaining gas).
824      *
825      * Requirements:
826      *
827      * - The divisor cannot be zero.
828      */
829     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
830         require(b > 0, errorMessage);
831         uint256 c = a / b;
832         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
833 
834         return c;
835     }
836 
837     /**
838      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
839      * Reverts when dividing by zero.
840      *
841      * Counterpart to Solidity's `%` operator. This function uses a `revert`
842      * opcode (which leaves remaining gas untouched) while Solidity uses an
843      * invalid opcode to revert (consuming all remaining gas).
844      *
845      * Requirements:
846      *
847      * - The divisor cannot be zero.
848      */
849     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
850         return mod(a, b, "SafeMath: modulo by zero");
851     }
852 
853     /**
854      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
855      * Reverts with custom message when dividing by zero.
856      *
857      * Counterpart to Solidity's `%` operator. This function uses a `revert`
858      * opcode (which leaves remaining gas untouched) while Solidity uses an
859      * invalid opcode to revert (consuming all remaining gas).
860      *
861      * Requirements:
862      *
863      * - The divisor cannot be zero.
864      */
865     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
866         require(b != 0, errorMessage);
867         return a % b;
868     }
869 }
870 
871 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
872 
873 
874 pragma solidity ^0.6.0;
875 
876 
877 
878 
879 
880 /**
881  * @dev Implementation of the {IERC20} interface.
882  *
883  * This implementation is agnostic to the way tokens are created. This means
884  * that a supply mechanism has to be added in a derived contract using {_mint}.
885  * For a generic mechanism see {ERC20PresetMinterPauser}.
886  *
887  * TIP: For a detailed writeup see our guide
888  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
889  * to implement supply mechanisms].
890  *
891  * We have followed general OpenZeppelin guidelines: functions revert instead
892  * of returning `false` on failure. This behavior is nonetheless conventional
893  * and does not conflict with the expectations of ERC20 applications.
894  *
895  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
896  * This allows applications to reconstruct the allowance for all accounts just
897  * by listening to said events. Other implementations of the EIP may not emit
898  * these events, as it isn't required by the specification.
899  *
900  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
901  * functions have been added to mitigate the well-known issues around setting
902  * allowances. See {IERC20-approve}.
903  */
904 contract ERC20 is Context, IERC20 {
905     using SafeMath for uint256;
906     using Address for address;
907 
908     mapping (address => uint256) private _balances;
909 
910     mapping (address => mapping (address => uint256)) private _allowances;
911 
912     uint256 private _totalSupply;
913 
914     string private _name;
915     string private _symbol;
916     uint8 private _decimals;
917 
918     /**
919      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
920      * a default value of 18.
921      *
922      * To select a different value for {decimals}, use {_setupDecimals}.
923      *
924      * All three of these values are immutable: they can only be set once during
925      * construction.
926      */
927     constructor (string memory name, string memory symbol) public {
928         _name = name;
929         _symbol = symbol;
930         _decimals = 18;
931     }
932 
933     /**
934      * @dev Returns the name of the token.
935      */
936     function name() public view returns (string memory) {
937         return _name;
938     }
939 
940     /**
941      * @dev Returns the symbol of the token, usually a shorter version of the
942      * name.
943      */
944     function symbol() public view returns (string memory) {
945         return _symbol;
946     }
947 
948     /**
949      * @dev Returns the number of decimals used to get its user representation.
950      * For example, if `decimals` equals `2`, a balance of `505` tokens should
951      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
952      *
953      * Tokens usually opt for a value of 18, imitating the relationship between
954      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
955      * called.
956      *
957      * NOTE: This information is only used for _display_ purposes: it in
958      * no way affects any of the arithmetic of the contract, including
959      * {IERC20-balanceOf} and {IERC20-transfer}.
960      */
961     function decimals() public view returns (uint8) {
962         return _decimals;
963     }
964 
965     /**
966      * @dev See {IERC20-totalSupply}.
967      */
968     function totalSupply() public view override returns (uint256) {
969         return _totalSupply;
970     }
971 
972     /**
973      * @dev See {IERC20-balanceOf}.
974      */
975     function balanceOf(address account) public view override returns (uint256) {
976         return _balances[account];
977     }
978 
979     /**
980      * @dev See {IERC20-transfer}.
981      *
982      * Requirements:
983      *
984      * - `recipient` cannot be the zero address.
985      * - the caller must have a balance of at least `amount`.
986      */
987     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
988         _transfer(_msgSender(), recipient, amount);
989         return true;
990     }
991 
992     /**
993      * @dev See {IERC20-allowance}.
994      */
995     function allowance(address owner, address spender) public view virtual override returns (uint256) {
996         return _allowances[owner][spender];
997     }
998 
999     /**
1000      * @dev See {IERC20-approve}.
1001      *
1002      * Requirements:
1003      *
1004      * - `spender` cannot be the zero address.
1005      */
1006     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1007         _approve(_msgSender(), spender, amount);
1008         return true;
1009     }
1010 
1011     /**
1012      * @dev See {IERC20-transferFrom}.
1013      *
1014      * Emits an {Approval} event indicating the updated allowance. This is not
1015      * required by the EIP. See the note at the beginning of {ERC20};
1016      *
1017      * Requirements:
1018      * - `sender` and `recipient` cannot be the zero address.
1019      * - `sender` must have a balance of at least `amount`.
1020      * - the caller must have allowance for ``sender``'s tokens of at least
1021      * `amount`.
1022      */
1023     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1024         _transfer(sender, recipient, amount);
1025         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1026         return true;
1027     }
1028 
1029     /**
1030      * @dev Atomically increases the allowance granted to `spender` by the caller.
1031      *
1032      * This is an alternative to {approve} that can be used as a mitigation for
1033      * problems described in {IERC20-approve}.
1034      *
1035      * Emits an {Approval} event indicating the updated allowance.
1036      *
1037      * Requirements:
1038      *
1039      * - `spender` cannot be the zero address.
1040      */
1041     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1042         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1043         return true;
1044     }
1045 
1046     /**
1047      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1048      *
1049      * This is an alternative to {approve} that can be used as a mitigation for
1050      * problems described in {IERC20-approve}.
1051      *
1052      * Emits an {Approval} event indicating the updated allowance.
1053      *
1054      * Requirements:
1055      *
1056      * - `spender` cannot be the zero address.
1057      * - `spender` must have allowance for the caller of at least
1058      * `subtractedValue`.
1059      */
1060     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1061         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1062         return true;
1063     }
1064 
1065     /**
1066      * @dev Moves tokens `amount` from `sender` to `recipient`.
1067      *
1068      * This is internal function is equivalent to {transfer}, and can be used to
1069      * e.g. implement automatic token fees, slashing mechanisms, etc.
1070      *
1071      * Emits a {Transfer} event.
1072      *
1073      * Requirements:
1074      *
1075      * - `sender` cannot be the zero address.
1076      * - `recipient` cannot be the zero address.
1077      * - `sender` must have a balance of at least `amount`.
1078      */
1079     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1080         require(sender != address(0), "ERC20: transfer from the zero address");
1081         require(recipient != address(0), "ERC20: transfer to the zero address");
1082 
1083         _beforeTokenTransfer(sender, recipient, amount);
1084 
1085         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1086         _balances[recipient] = _balances[recipient].add(amount);
1087         emit Transfer(sender, recipient, amount);
1088     }
1089 
1090     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1091      * the total supply.
1092      *
1093      * Emits a {Transfer} event with `from` set to the zero address.
1094      *
1095      * Requirements
1096      *
1097      * - `to` cannot be the zero address.
1098      */
1099     function _mint(address account, uint256 amount) internal virtual {
1100         require(account != address(0), "ERC20: mint to the zero address");
1101 
1102         _beforeTokenTransfer(address(0), account, amount);
1103 
1104         _totalSupply = _totalSupply.add(amount);
1105         _balances[account] = _balances[account].add(amount);
1106         emit Transfer(address(0), account, amount);
1107     }
1108 
1109     /**
1110      * @dev Destroys `amount` tokens from `account`, reducing the
1111      * total supply.
1112      *
1113      * Emits a {Transfer} event with `to` set to the zero address.
1114      *
1115      * Requirements
1116      *
1117      * - `account` cannot be the zero address.
1118      * - `account` must have at least `amount` tokens.
1119      */
1120     function _burn(address account, uint256 amount) internal virtual {
1121         require(account != address(0), "ERC20: burn from the zero address");
1122 
1123         _beforeTokenTransfer(account, address(0), amount);
1124 
1125         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1126         _totalSupply = _totalSupply.sub(amount);
1127         emit Transfer(account, address(0), amount);
1128     }
1129 
1130     /**
1131      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1132      *
1133      * This is internal function is equivalent to `approve`, and can be used to
1134      * e.g. set automatic allowances for certain subsystems, etc.
1135      *
1136      * Emits an {Approval} event.
1137      *
1138      * Requirements:
1139      *
1140      * - `owner` cannot be the zero address.
1141      * - `spender` cannot be the zero address.
1142      */
1143     function _approve(address owner, address spender, uint256 amount) internal virtual {
1144         require(owner != address(0), "ERC20: approve from the zero address");
1145         require(spender != address(0), "ERC20: approve to the zero address");
1146 
1147         _allowances[owner][spender] = amount;
1148         emit Approval(owner, spender, amount);
1149     }
1150 
1151     /**
1152      * @dev Sets {decimals} to a value other than the default one of 18.
1153      *
1154      * WARNING: This function should only be called from the constructor. Most
1155      * applications that interact with token contracts will not expect
1156      * {decimals} to ever change, and may work incorrectly if it does.
1157      */
1158     function _setupDecimals(uint8 decimals_) internal {
1159         _decimals = decimals_;
1160     }
1161 
1162     /**
1163      * @dev Hook that is called before any transfer of tokens. This includes
1164      * minting and burning.
1165      *
1166      * Calling conditions:
1167      *
1168      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1169      * will be to transferred to `to`.
1170      * - when `from` is zero, `amount` tokens will be minted for `to`.
1171      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1172      * - `from` and `to` are never both zero.
1173      *
1174      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1175      */
1176     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1177 }
1178 
1179 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
1180 
1181 
1182 pragma solidity ^0.6.0;
1183 
1184 
1185 /**
1186  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1187  */
1188 abstract contract ERC20Capped is ERC20 {
1189     uint256 private _cap;
1190 
1191     /**
1192      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1193      * set once during construction.
1194      */
1195     constructor (uint256 cap) public {
1196         require(cap > 0, "ERC20Capped: cap is 0");
1197         _cap = cap;
1198     }
1199 
1200     /**
1201      * @dev Returns the cap on the token's total supply.
1202      */
1203     function cap() public view returns (uint256) {
1204         return _cap;
1205     }
1206 
1207     /**
1208      * @dev See {ERC20-_beforeTokenTransfer}.
1209      *
1210      * Requirements:
1211      *
1212      * - minted tokens must not cause the total supply to go over the cap.
1213      */
1214     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1215         super._beforeTokenTransfer(from, to, amount);
1216 
1217         if (from == address(0)) { // When minting tokens
1218             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1219         }
1220     }
1221 }
1222 
1223 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1224 
1225 
1226 pragma solidity ^0.6.0;
1227 
1228 
1229 
1230 /**
1231  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1232  * tokens and those that they have an allowance for, in a way that can be
1233  * recognized off-chain (via event analysis).
1234  */
1235 abstract contract ERC20Burnable is Context, ERC20 {
1236     /**
1237      * @dev Destroys `amount` tokens from the caller.
1238      *
1239      * See {ERC20-_burn}.
1240      */
1241     function burn(uint256 amount) public virtual {
1242         _burn(_msgSender(), amount);
1243     }
1244 
1245     /**
1246      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1247      * allowance.
1248      *
1249      * See {ERC20-_burn} and {ERC20-allowance}.
1250      *
1251      * Requirements:
1252      *
1253      * - the caller must have allowance for ``accounts``'s tokens of at least
1254      * `amount`.
1255      */
1256     function burnFrom(address account, uint256 amount) public virtual {
1257         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1258 
1259         _approve(account, _msgSender(), decreasedAllowance);
1260         _burn(account, amount);
1261     }
1262 }
1263 
1264 // File: @openzeppelin/contracts/math/Math.sol
1265 
1266 
1267 pragma solidity ^0.6.0;
1268 
1269 /**
1270  * @dev Standard math utilities missing in the Solidity language.
1271  */
1272 library Math {
1273     /**
1274      * @dev Returns the largest of two numbers.
1275      */
1276     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1277         return a >= b ? a : b;
1278     }
1279 
1280     /**
1281      * @dev Returns the smallest of two numbers.
1282      */
1283     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1284         return a < b ? a : b;
1285     }
1286 
1287     /**
1288      * @dev Returns the average of two numbers. The result is rounded towards
1289      * zero.
1290      */
1291     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1292         // (a + b) / 2 can overflow, so we distribute
1293         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1294     }
1295 }
1296 
1297 // File: @openzeppelin/contracts/utils/Arrays.sol
1298 
1299 
1300 pragma solidity ^0.6.0;
1301 
1302 
1303 /**
1304  * @dev Collection of functions related to array types.
1305  */
1306 library Arrays {
1307    /**
1308      * @dev Searches a sorted `array` and returns the first index that contains
1309      * a value greater or equal to `element`. If no such index exists (i.e. all
1310      * values in the array are strictly less than `element`), the array length is
1311      * returned. Time complexity O(log n).
1312      *
1313      * `array` is expected to be sorted in ascending order, and to contain no
1314      * repeated elements.
1315      */
1316     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1317         if (array.length == 0) {
1318             return 0;
1319         }
1320 
1321         uint256 low = 0;
1322         uint256 high = array.length;
1323 
1324         while (low < high) {
1325             uint256 mid = Math.average(low, high);
1326 
1327             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1328             // because Math.average rounds down (it does integer division with truncation).
1329             if (array[mid] > element) {
1330                 high = mid;
1331             } else {
1332                 low = mid + 1;
1333             }
1334         }
1335 
1336         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1337         if (low > 0 && array[low - 1] == element) {
1338             return low - 1;
1339         } else {
1340             return low;
1341         }
1342     }
1343 }
1344 
1345 // File: @openzeppelin/contracts/utils/Counters.sol
1346 
1347 
1348 pragma solidity ^0.6.0;
1349 
1350 
1351 /**
1352  * @title Counters
1353  * @author Matt Condon (@shrugs)
1354  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1355  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1356  *
1357  * Include with `using Counters for Counters.Counter;`
1358  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1359  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1360  * directly accessed.
1361  */
1362 library Counters {
1363     using SafeMath for uint256;
1364 
1365     struct Counter {
1366         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1367         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1368         // this feature: see https://github.com/ethereum/solidity/issues/4637
1369         uint256 _value; // default: 0
1370     }
1371 
1372     function current(Counter storage counter) internal view returns (uint256) {
1373         return counter._value;
1374     }
1375 
1376     function increment(Counter storage counter) internal {
1377         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1378         counter._value += 1;
1379     }
1380 
1381     function decrement(Counter storage counter) internal {
1382         counter._value = counter._value.sub(1);
1383     }
1384 }
1385 
1386 // File: @openzeppelin/contracts/token/ERC20/ERC20Snapshot.sol
1387 
1388 
1389 pragma solidity ^0.6.0;
1390 
1391 
1392 
1393 
1394 
1395 /**
1396  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1397  * total supply at the time are recorded for later access.
1398  *
1399  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1400  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1401  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1402  * used to create an efficient ERC20 forking mechanism.
1403  *
1404  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1405  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1406  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1407  * and the account address.
1408  *
1409  * ==== Gas Costs
1410  *
1411  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1412  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1413  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1414  *
1415  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1416  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1417  * transfers will have normal cost until the next snapshot, and so on.
1418  */
1419 abstract contract ERC20Snapshot is ERC20 {
1420     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1421     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1422 
1423     using SafeMath for uint256;
1424     using Arrays for uint256[];
1425     using Counters for Counters.Counter;
1426 
1427     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1428     // Snapshot struct, but that would impede usage of functions that work on an array.
1429     struct Snapshots {
1430         uint256[] ids;
1431         uint256[] values;
1432     }
1433 
1434     mapping (address => Snapshots) private _accountBalanceSnapshots;
1435     Snapshots private _totalSupplySnapshots;
1436 
1437     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1438     Counters.Counter private _currentSnapshotId;
1439 
1440     /**
1441      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1442      */
1443     event Snapshot(uint256 id);
1444 
1445     /**
1446      * @dev Creates a new snapshot and returns its snapshot id.
1447      *
1448      * Emits a {Snapshot} event that contains the same id.
1449      *
1450      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1451      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1452      *
1453      * [WARNING]
1454      * ====
1455      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1456      * you must consider that it can potentially be used by attackers in two ways.
1457      *
1458      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1459      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1460      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1461      * section above.
1462      *
1463      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1464      * ====
1465      */
1466     function _snapshot() internal virtual returns (uint256) {
1467         _currentSnapshotId.increment();
1468 
1469         uint256 currentId = _currentSnapshotId.current();
1470         emit Snapshot(currentId);
1471         return currentId;
1472     }
1473 
1474     /**
1475      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1476      */
1477     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
1478         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1479 
1480         return snapshotted ? value : balanceOf(account);
1481     }
1482 
1483     /**
1484      * @dev Retrieves the total supply at the time `snapshotId` was created.
1485      */
1486     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
1487         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1488 
1489         return snapshotted ? value : totalSupply();
1490     }
1491 
1492     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
1493     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
1494     // The same is true for the total supply and _mint and _burn.
1495     function _transfer(address from, address to, uint256 value) internal virtual override {
1496         _updateAccountSnapshot(from);
1497         _updateAccountSnapshot(to);
1498 
1499         super._transfer(from, to, value);
1500     }
1501 
1502     function _mint(address account, uint256 value) internal virtual override {
1503         _updateAccountSnapshot(account);
1504         _updateTotalSupplySnapshot();
1505 
1506         super._mint(account, value);
1507     }
1508 
1509     function _burn(address account, uint256 value) internal virtual override {
1510         _updateAccountSnapshot(account);
1511         _updateTotalSupplySnapshot();
1512 
1513         super._burn(account, value);
1514     }
1515 
1516     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
1517         private view returns (bool, uint256)
1518     {
1519         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1520         // solhint-disable-next-line max-line-length
1521         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
1522 
1523         // When a valid snapshot is queried, there are three possibilities:
1524         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1525         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1526         //  to this id is the current one.
1527         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1528         //  requested id, and its value is the one to return.
1529         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1530         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1531         //  larger than the requested one.
1532         //
1533         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1534         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1535         // exactly this.
1536 
1537         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1538 
1539         if (index == snapshots.ids.length) {
1540             return (false, 0);
1541         } else {
1542             return (true, snapshots.values[index]);
1543         }
1544     }
1545 
1546     function _updateAccountSnapshot(address account) private {
1547         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1548     }
1549 
1550     function _updateTotalSupplySnapshot() private {
1551         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1552     }
1553 
1554     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1555         uint256 currentId = _currentSnapshotId.current();
1556         if (_lastSnapshotId(snapshots.ids) < currentId) {
1557             snapshots.ids.push(currentId);
1558             snapshots.values.push(currentValue);
1559         }
1560     }
1561 
1562     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1563         if (ids.length == 0) {
1564             return 0;
1565         } else {
1566             return ids[ids.length - 1];
1567         }
1568     }
1569 }
1570 
1571 // File: contracts/KnsToken.sol
1572 
1573 
1574 pragma solidity ^0.6.0;
1575 
1576 
1577 
1578 
1579 
1580 
1581 contract KnsToken
1582    is AccessControl,
1583       ERC20,
1584       ERC20Capped,
1585       ERC20Burnable,
1586       ERC20Snapshot
1587 {
1588    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1589    bytes32 public constant SNAPSHOTTER_ROLE = keccak256("SNAPSHOTTER_ROLE");
1590    uint256 public constant ONE_KNS = 100000000;
1591    uint8 public constant KNS_DECIMALS = 8;
1592    uint256 public constant KNS_CAP = 100 * 1000000 * ONE_KNS;
1593 
1594    constructor(string memory name, string memory symbol, address minter)
1595       ERC20( name, symbol )
1596       ERC20Capped( KNS_CAP )
1597       public
1598    {
1599       _setupDecimals( KNS_DECIMALS );
1600       _setupRole( DEFAULT_ADMIN_ROLE, _msgSender() );
1601       if( minter != address(0) )
1602          _setupRole( MINTER_ROLE, minter );
1603    }
1604 
1605    /**
1606     * @dev Creates `amount` new tokens for `to`.
1607     *
1608     * See {ERC20-_mint}.
1609     *
1610     * Requirements:
1611     *
1612     * - the caller must have the `MINTER_ROLE`.
1613     */
1614    function mint(address to, uint256 amount) public
1615    {
1616       require(hasRole(MINTER_ROLE, _msgSender()), "KnsToken: mint() requires MINTER_ROLE");
1617       _mint(to, amount);
1618    }
1619 
1620    /**
1621     * @dev Creates a snapshot of current token balances.
1622     *
1623     * See {ERC20Snapsot-_snapshot}.
1624     *
1625     * Requirements:
1626     *
1627     * - the caller must have the 'SNAPSHOTTER_ROLE'.
1628     */
1629    function snapshot() public
1630    {
1631       require(hasRole(SNAPSHOTTER_ROLE, _msgSender()), "KnsToken: snapshot() requires SNAPSHOTTER_ROLE");
1632       _snapshot();
1633    }
1634 
1635    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Capped)
1636    {
1637        super._beforeTokenTransfer(from, to, amount);
1638    }
1639 
1640    function _burn(address account, uint256 value) internal override(ERC20, ERC20Snapshot)
1641    {
1642        super._burn(account, value);
1643    }
1644 
1645    function _mint(address account, uint256 amount) internal override(ERC20, ERC20Snapshot)
1646    {
1647        super._mint(account, amount);
1648    }
1649 
1650    function _transfer(address sender, address recipient, uint256 amount) internal override(ERC20, ERC20Snapshot)
1651    {
1652        super._transfer(sender, recipient, amount);
1653    }
1654 }