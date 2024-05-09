1 pragma solidity ^0.6.0; // SPDX-License-Identifier: MIT
2 
3 
4 
5 /**
6  * @dev Library for managing
7  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
8  * types.
9  *
10  * Sets have the following properties:
11  *
12  * - Elements are added, removed, and checked for existence in constant time
13  * (O(1)).
14  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
15  *
16  * ```
17  * contract Example {
18  *     // Add the library methods
19  *     using EnumerableSet for EnumerableSet.AddressSet;
20  *
21  *     // Declare a set state variable
22  *     EnumerableSet.AddressSet private mySet;
23  * }
24  * ```
25  *
26  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
27  * (`UintSet`) are supported.
28  */
29 library EnumerableSet {
30     // To implement this library for multiple types with as little code
31     // repetition as possible, we write it in terms of a generic Set type with
32     // bytes32 values.
33     // The Set implementation uses private functions, and user-facing
34     // implementations (such as AddressSet) are just wrappers around the
35     // underlying Set.
36     // This means that we can only create new EnumerableSets for types that fit
37     // in bytes32.
38 
39     struct Set {
40         // Storage of set values
41         bytes32[] _values;
42 
43         // Position of the value in the `values` array, plus 1 because index 0
44         // means a value is not in the set.
45         mapping (bytes32 => uint256) _indexes;
46     }
47 
48     /**
49      * @dev Add a value to a set. O(1).
50      *
51      * Returns true if the value was added to the set, that is if it was not
52      * already present.
53      */
54     function _add(Set storage set, bytes32 value) private returns (bool) {
55         if (!_contains(set, value)) {
56             set._values.push(value);
57             // The value is stored at length-1, but we add 1 to all indexes
58             // and use 0 as a sentinel value
59             set._indexes[value] = set._values.length;
60             return true;
61         } else {
62             return false;
63         }
64     }
65 
66     /**
67      * @dev Removes a value from a set. O(1).
68      *
69      * Returns true if the value was removed from the set, that is if it was
70      * present.
71      */
72     function _remove(Set storage set, bytes32 value) private returns (bool) {
73         // We read and store the value's index to prevent multiple reads from the same storage slot
74         uint256 valueIndex = set._indexes[value];
75 
76         if (valueIndex != 0) { // Equivalent to contains(set, value)
77             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
78             // the array, and then remove the last element (sometimes called as 'swap and pop').
79             // This modifies the order of the array, as noted in {at}.
80 
81             uint256 toDeleteIndex = valueIndex - 1;
82             uint256 lastIndex = set._values.length - 1;
83 
84             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
85             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
86 
87             bytes32 lastvalue = set._values[lastIndex];
88 
89             // Move the last value to the index where the value to delete is
90             set._values[toDeleteIndex] = lastvalue;
91             // Update the index for the moved value
92             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
93 
94             // Delete the slot where the moved value was stored
95             set._values.pop();
96 
97             // Delete the index for the deleted slot
98             delete set._indexes[value];
99 
100             return true;
101         } else {
102             return false;
103         }
104     }
105 
106     /**
107      * @dev Returns true if the value is in the set. O(1).
108      */
109     function _contains(Set storage set, bytes32 value) private view returns (bool) {
110         return set._indexes[value] != 0;
111     }
112 
113     /**
114      * @dev Returns the number of values on the set. O(1).
115      */
116     function _length(Set storage set) private view returns (uint256) {
117         return set._values.length;
118     }
119 
120    /**
121     * @dev Returns the value stored at position `index` in the set. O(1).
122     *
123     * Note that there are no guarantees on the ordering of values inside the
124     * array, and it may change when more values are added or removed.
125     *
126     * Requirements:
127     *
128     * - `index` must be strictly less than {length}.
129     */
130     function _at(Set storage set, uint256 index) private view returns (bytes32) {
131         require(set._values.length > index, "EnumerableSet: index out of bounds");
132         return set._values[index];
133     }
134 
135     // AddressSet
136 
137     struct AddressSet {
138         Set _inner;
139     }
140 
141     /**
142      * @dev Add a value to a set. O(1).
143      *
144      * Returns true if the value was added to the set, that is if it was not
145      * already present.
146      */
147     function add(AddressSet storage set, address value) internal returns (bool) {
148         return _add(set._inner, bytes32(uint256(value)));
149     }
150 
151     /**
152      * @dev Removes a value from a set. O(1).
153      *
154      * Returns true if the value was removed from the set, that is if it was
155      * present.
156      */
157     function remove(AddressSet storage set, address value) internal returns (bool) {
158         return _remove(set._inner, bytes32(uint256(value)));
159     }
160 
161     /**
162      * @dev Returns true if the value is in the set. O(1).
163      */
164     function contains(AddressSet storage set, address value) internal view returns (bool) {
165         return _contains(set._inner, bytes32(uint256(value)));
166     }
167 
168     /**
169      * @dev Returns the number of values in the set. O(1).
170      */
171     function length(AddressSet storage set) internal view returns (uint256) {
172         return _length(set._inner);
173     }
174 
175    /**
176     * @dev Returns the value stored at position `index` in the set. O(1).
177     *
178     * Note that there are no guarantees on the ordering of values inside the
179     * array, and it may change when more values are added or removed.
180     *
181     * Requirements:
182     *
183     * - `index` must be strictly less than {length}.
184     */
185     function at(AddressSet storage set, uint256 index) internal view returns (address) {
186         return address(uint256(_at(set._inner, index)));
187     }
188 
189 
190     // UintSet
191 
192     struct UintSet {
193         Set _inner;
194     }
195 
196     /**
197      * @dev Add a value to a set. O(1).
198      *
199      * Returns true if the value was added to the set, that is if it was not
200      * already present.
201      */
202     function add(UintSet storage set, uint256 value) internal returns (bool) {
203         return _add(set._inner, bytes32(value));
204     }
205 
206     /**
207      * @dev Removes a value from a set. O(1).
208      *
209      * Returns true if the value was removed from the set, that is if it was
210      * present.
211      */
212     function remove(UintSet storage set, uint256 value) internal returns (bool) {
213         return _remove(set._inner, bytes32(value));
214     }
215 
216     /**
217      * @dev Returns true if the value is in the set. O(1).
218      */
219     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
220         return _contains(set._inner, bytes32(value));
221     }
222 
223     /**
224      * @dev Returns the number of values on the set. O(1).
225      */
226     function length(UintSet storage set) internal view returns (uint256) {
227         return _length(set._inner);
228     }
229 
230    /**
231     * @dev Returns the value stored at position `index` in the set. O(1).
232     *
233     * Note that there are no guarantees on the ordering of values inside the
234     * array, and it may change when more values are added or removed.
235     *
236     * Requirements:
237     *
238     * - `index` must be strictly less than {length}.
239     */
240     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
241         return uint256(_at(set._inner, index));
242     }
243 }
244 
245 
246 
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272         // for accounts without code, i.e. `keccak256('')`
273         bytes32 codehash;
274         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { codehash := extcodehash(account) }
277         return (codehash != accountHash && codehash != 0x0);
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 
387 
388 
389 /*
390  * @dev Provides information about the current execution context, including the
391  * sender of the transaction and its data. While these are generally available
392  * via msg.sender and msg.data, they should not be accessed in such a direct
393  * manner, since when dealing with GSN meta-transactions the account sending and
394  * paying for execution may not be the actual sender (as far as an application
395  * is concerned).
396  *
397  * This contract is only required for intermediate, library-like contracts.
398  */
399 abstract contract Context {
400     function _msgSender() internal view virtual returns (address payable) {
401         return msg.sender;
402     }
403 
404     function _msgData() internal view virtual returns (bytes memory) {
405         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
406         return msg.data;
407     }
408 }
409 
410 
411 
412 
413 
414 /**
415  * @dev Contract module that allows children to implement role-based access
416  * control mechanisms.
417  *
418  * Roles are referred to by their `bytes32` identifier. These should be exposed
419  * in the external API and be unique. The best way to achieve this is by
420  * using `public constant` hash digests:
421  *
422  * ```
423  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
424  * ```
425  *
426  * Roles can be used to represent a set of permissions. To restrict access to a
427  * function call, use {hasRole}:
428  *
429  * ```
430  * function foo() public {
431  *     require(hasRole(MY_ROLE, msg.sender));
432  *     ...
433  * }
434  * ```
435  *
436  * Roles can be granted and revoked dynamically via the {grantRole} and
437  * {revokeRole} functions. Each role has an associated admin role, and only
438  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
439  *
440  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
441  * that only accounts with this role will be able to grant or revoke other
442  * roles. More complex role relationships can be created by using
443  * {_setRoleAdmin}.
444  *
445  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
446  * grant and revoke this role. Extra precautions should be taken to secure
447  * accounts that have been granted it.
448  */
449 abstract contract AccessControl is Context {
450     using EnumerableSet for EnumerableSet.AddressSet;
451     using Address for address;
452 
453     struct RoleData {
454         EnumerableSet.AddressSet members;
455         bytes32 adminRole;
456     }
457 
458     mapping (bytes32 => RoleData) private _roles;
459 
460     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
461 
462     /**
463      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
464      *
465      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
466      * {RoleAdminChanged} not being emitted signaling this.
467      *
468      * _Available since v3.1._
469      */
470     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
471 
472     /**
473      * @dev Emitted when `account` is granted `role`.
474      *
475      * `sender` is the account that originated the contract call, an admin role
476      * bearer except when using {_setupRole}.
477      */
478     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
479 
480     /**
481      * @dev Emitted when `account` is revoked `role`.
482      *
483      * `sender` is the account that originated the contract call:
484      *   - if using `revokeRole`, it is the admin role bearer
485      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
486      */
487     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
488 
489     /**
490      * @dev Returns `true` if `account` has been granted `role`.
491      */
492     function hasRole(bytes32 role, address account) public view returns (bool) {
493         return _roles[role].members.contains(account);
494     }
495 
496     /**
497      * @dev Returns the number of accounts that have `role`. Can be used
498      * together with {getRoleMember} to enumerate all bearers of a role.
499      */
500     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
501         return _roles[role].members.length();
502     }
503 
504     /**
505      * @dev Returns one of the accounts that have `role`. `index` must be a
506      * value between 0 and {getRoleMemberCount}, non-inclusive.
507      *
508      * Role bearers are not sorted in any particular way, and their ordering may
509      * change at any point.
510      *
511      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
512      * you perform all queries on the same block. See the following
513      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
514      * for more information.
515      */
516     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
517         return _roles[role].members.at(index);
518     }
519 
520     /**
521      * @dev Returns the admin role that controls `role`. See {grantRole} and
522      * {revokeRole}.
523      *
524      * To change a role's admin, use {_setRoleAdmin}.
525      */
526     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
527         return _roles[role].adminRole;
528     }
529 
530     /**
531      * @dev Grants `role` to `account`.
532      *
533      * If `account` had not been already granted `role`, emits a {RoleGranted}
534      * event.
535      *
536      * Requirements:
537      *
538      * - the caller must have ``role``'s admin role.
539      */
540     function grantRole(bytes32 role, address account) public virtual {
541         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
542 
543         _grantRole(role, account);
544     }
545 
546     /**
547      * @dev Revokes `role` from `account`.
548      *
549      * If `account` had been granted `role`, emits a {RoleRevoked} event.
550      *
551      * Requirements:
552      *
553      * - the caller must have ``role``'s admin role.
554      */
555     function revokeRole(bytes32 role, address account) public virtual {
556         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
557 
558         _revokeRole(role, account);
559     }
560 
561     /**
562      * @dev Revokes `role` from the calling account.
563      *
564      * Roles are often managed via {grantRole} and {revokeRole}: this function's
565      * purpose is to provide a mechanism for accounts to lose their privileges
566      * if they are compromised (such as when a trusted device is misplaced).
567      *
568      * If the calling account had been granted `role`, emits a {RoleRevoked}
569      * event.
570      *
571      * Requirements:
572      *
573      * - the caller must be `account`.
574      */
575     function renounceRole(bytes32 role, address account) public virtual {
576         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
577 
578         _revokeRole(role, account);
579     }
580 
581     /**
582      * @dev Grants `role` to `account`.
583      *
584      * If `account` had not been already granted `role`, emits a {RoleGranted}
585      * event. Note that unlike {grantRole}, this function doesn't perform any
586      * checks on the calling account.
587      *
588      * [WARNING]
589      * ====
590      * This function should only be called from the constructor when setting
591      * up the initial roles for the system.
592      *
593      * Using this function in any other way is effectively circumventing the admin
594      * system imposed by {AccessControl}.
595      * ====
596      */
597     function _setupRole(bytes32 role, address account) internal virtual {
598         _grantRole(role, account);
599     }
600 
601     /**
602      * @dev Sets `adminRole` as ``role``'s admin role.
603      *
604      * Emits a {RoleAdminChanged} event.
605      */
606     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
607         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
608         _roles[role].adminRole = adminRole;
609     }
610 
611     function _grantRole(bytes32 role, address account) private {
612         if (_roles[role].members.add(account)) {
613             emit RoleGranted(role, account, _msgSender());
614         }
615     }
616 
617     function _revokeRole(bytes32 role, address account) private {
618         if (_roles[role].members.remove(account)) {
619             emit RoleRevoked(role, account, _msgSender());
620         }
621     }
622 }
623 
624 
625 
626 
627 /**
628  * @dev Interface of the ERC20 standard as defined in the EIP.
629  */
630 interface IERC20 {
631     /**
632      * @dev Returns the amount of tokens in existence.
633      */
634     function totalSupply() external view returns (uint256);
635 
636     /**
637      * @dev Returns the amount of tokens owned by `account`.
638      */
639     function balanceOf(address account) external view returns (uint256);
640 
641     /**
642      * @dev Moves `amount` tokens from the caller's account to `recipient`.
643      *
644      * Returns a boolean value indicating whether the operation succeeded.
645      *
646      * Emits a {Transfer} event.
647      */
648     function transfer(address recipient, uint256 amount) external returns (bool);
649 
650     /**
651      * @dev Returns the remaining number of tokens that `spender` will be
652      * allowed to spend on behalf of `owner` through {transferFrom}. This is
653      * zero by default.
654      *
655      * This value changes when {approve} or {transferFrom} are called.
656      */
657     function allowance(address owner, address spender) external view returns (uint256);
658 
659     /**
660      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
661      *
662      * Returns a boolean value indicating whether the operation succeeded.
663      *
664      * IMPORTANT: Beware that changing an allowance with this method brings the risk
665      * that someone may use both the old and the new allowance by unfortunate
666      * transaction ordering. One possible solution to mitigate this race
667      * condition is to first reduce the spender's allowance to 0 and set the
668      * desired value afterwards:
669      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
670      *
671      * Emits an {Approval} event.
672      */
673     function approve(address spender, uint256 amount) external returns (bool);
674 
675     /**
676      * @dev Moves `amount` tokens from `sender` to `recipient` using the
677      * allowance mechanism. `amount` is then deducted from the caller's
678      * allowance.
679      *
680      * Returns a boolean value indicating whether the operation succeeded.
681      *
682      * Emits a {Transfer} event.
683      */
684     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
685 
686     /**
687      * @dev Emitted when `value` tokens are moved from one account (`from`) to
688      * another (`to`).
689      *
690      * Note that `value` may be zero.
691      */
692     event Transfer(address indexed from, address indexed to, uint256 value);
693 
694     /**
695      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
696      * a call to {approve}. `value` is the new allowance.
697      */
698     event Approval(address indexed owner, address indexed spender, uint256 value);
699 }
700 
701 
702 
703 
704 /**
705  * @dev Wrappers over Solidity's arithmetic operations with added overflow
706  * checks.
707  *
708  * Arithmetic operations in Solidity wrap on overflow. This can easily result
709  * in bugs, because programmers usually assume that an overflow raises an
710  * error, which is the standard behavior in high level programming languages.
711  * `SafeMath` restores this intuition by reverting the transaction when an
712  * operation overflows.
713  *
714  * Using this library instead of the unchecked operations eliminates an entire
715  * class of bugs, so it's recommended to use it always.
716  */
717 library SafeMath {
718     /**
719      * @dev Returns the addition of two unsigned integers, reverting on
720      * overflow.
721      *
722      * Counterpart to Solidity's `+` operator.
723      *
724      * Requirements:
725      *
726      * - Addition cannot overflow.
727      */
728     function add(uint256 a, uint256 b) internal pure returns (uint256) {
729         uint256 c = a + b;
730         require(c >= a, "SafeMath: addition overflow");
731 
732         return c;
733     }
734 
735     /**
736      * @dev Returns the subtraction of two unsigned integers, reverting on
737      * overflow (when the result is negative).
738      *
739      * Counterpart to Solidity's `-` operator.
740      *
741      * Requirements:
742      *
743      * - Subtraction cannot overflow.
744      */
745     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
746         return sub(a, b, "SafeMath: subtraction overflow");
747     }
748 
749     /**
750      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
751      * overflow (when the result is negative).
752      *
753      * Counterpart to Solidity's `-` operator.
754      *
755      * Requirements:
756      *
757      * - Subtraction cannot overflow.
758      */
759     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
760         require(b <= a, errorMessage);
761         uint256 c = a - b;
762 
763         return c;
764     }
765 
766     /**
767      * @dev Returns the multiplication of two unsigned integers, reverting on
768      * overflow.
769      *
770      * Counterpart to Solidity's `*` operator.
771      *
772      * Requirements:
773      *
774      * - Multiplication cannot overflow.
775      */
776     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
777         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
778         // benefit is lost if 'b' is also tested.
779         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
780         if (a == 0) {
781             return 0;
782         }
783 
784         uint256 c = a * b;
785         require(c / a == b, "SafeMath: multiplication overflow");
786 
787         return c;
788     }
789 
790     /**
791      * @dev Returns the integer division of two unsigned integers. Reverts on
792      * division by zero. The result is rounded towards zero.
793      *
794      * Counterpart to Solidity's `/` operator. Note: this function uses a
795      * `revert` opcode (which leaves remaining gas untouched) while Solidity
796      * uses an invalid opcode to revert (consuming all remaining gas).
797      *
798      * Requirements:
799      *
800      * - The divisor cannot be zero.
801      */
802     function div(uint256 a, uint256 b) internal pure returns (uint256) {
803         return div(a, b, "SafeMath: division by zero");
804     }
805 
806     /**
807      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
808      * division by zero. The result is rounded towards zero.
809      *
810      * Counterpart to Solidity's `/` operator. Note: this function uses a
811      * `revert` opcode (which leaves remaining gas untouched) while Solidity
812      * uses an invalid opcode to revert (consuming all remaining gas).
813      *
814      * Requirements:
815      *
816      * - The divisor cannot be zero.
817      */
818     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
819         require(b > 0, errorMessage);
820         uint256 c = a / b;
821         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
822 
823         return c;
824     }
825 
826     /**
827      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
828      * Reverts when dividing by zero.
829      *
830      * Counterpart to Solidity's `%` operator. This function uses a `revert`
831      * opcode (which leaves remaining gas untouched) while Solidity uses an
832      * invalid opcode to revert (consuming all remaining gas).
833      *
834      * Requirements:
835      *
836      * - The divisor cannot be zero.
837      */
838     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
839         return mod(a, b, "SafeMath: modulo by zero");
840     }
841 
842     /**
843      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
844      * Reverts with custom message when dividing by zero.
845      *
846      * Counterpart to Solidity's `%` operator. This function uses a `revert`
847      * opcode (which leaves remaining gas untouched) while Solidity uses an
848      * invalid opcode to revert (consuming all remaining gas).
849      *
850      * Requirements:
851      *
852      * - The divisor cannot be zero.
853      */
854     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
855         require(b != 0, errorMessage);
856         return a % b;
857     }
858 }
859 
860 
861 
862 
863 
864 
865 /**
866  * @dev Implementation of the {IERC20} interface.
867  *
868  * This implementation is agnostic to the way tokens are created. This means
869  * that a supply mechanism has to be added in a derived contract using {_mint}.
870  * For a generic mechanism see {ERC20PresetMinterPauser}.
871  *
872  * TIP: For a detailed writeup see our guide
873  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
874  * to implement supply mechanisms].
875  *
876  * We have followed general OpenZeppelin guidelines: functions revert instead
877  * of returning `false` on failure. This behavior is nonetheless conventional
878  * and does not conflict with the expectations of ERC20 applications.
879  *
880  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
881  * This allows applications to reconstruct the allowance for all accounts just
882  * by listening to said events. Other implementations of the EIP may not emit
883  * these events, as it isn't required by the specification.
884  *
885  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
886  * functions have been added to mitigate the well-known issues around setting
887  * allowances. See {IERC20-approve}.
888  */
889 contract ERC20 is Context, IERC20 {
890     using SafeMath for uint256;
891     using Address for address;
892 
893     mapping (address => uint256) private _balances;
894 
895     mapping (address => mapping (address => uint256)) private _allowances;
896 
897     uint256 private _totalSupply;
898 
899     string private _name;
900     string private _symbol;
901     uint8 private _decimals;
902 
903     /**
904      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
905      * a default value of 18.
906      *
907      * To select a different value for {decimals}, use {_setupDecimals}.
908      *
909      * All three of these values are immutable: they can only be set once during
910      * construction.
911      */
912     constructor (string memory name, string memory symbol) public {
913         _name = name;
914         _symbol = symbol;
915         _decimals = 18;
916     }
917 
918     /**
919      * @dev Returns the name of the token.
920      */
921     function name() public view returns (string memory) {
922         return _name;
923     }
924 
925     /**
926      * @dev Returns the symbol of the token, usually a shorter version of the
927      * name.
928      */
929     function symbol() public view returns (string memory) {
930         return _symbol;
931     }
932 
933     /**
934      * @dev Returns the number of decimals used to get its user representation.
935      * For example, if `decimals` equals `2`, a balance of `505` tokens should
936      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
937      *
938      * Tokens usually opt for a value of 18, imitating the relationship between
939      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
940      * called.
941      *
942      * NOTE: This information is only used for _display_ purposes: it in
943      * no way affects any of the arithmetic of the contract, including
944      * {IERC20-balanceOf} and {IERC20-transfer}.
945      */
946     function decimals() public view returns (uint8) {
947         return _decimals;
948     }
949 
950     /**
951      * @dev See {IERC20-totalSupply}.
952      */
953     function totalSupply() public view override returns (uint256) {
954         return _totalSupply;
955     }
956 
957     /**
958      * @dev See {IERC20-balanceOf}.
959      */
960     function balanceOf(address account) public view override returns (uint256) {
961         return _balances[account];
962     }
963 
964     /**
965      * @dev See {IERC20-transfer}.
966      *
967      * Requirements:
968      *
969      * - `recipient` cannot be the zero address.
970      * - the caller must have a balance of at least `amount`.
971      */
972     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
973         _transfer(_msgSender(), recipient, amount);
974         return true;
975     }
976 
977     /**
978      * @dev See {IERC20-allowance}.
979      */
980     function allowance(address owner, address spender) public view virtual override returns (uint256) {
981         return _allowances[owner][spender];
982     }
983 
984     /**
985      * @dev See {IERC20-approve}.
986      *
987      * Requirements:
988      *
989      * - `spender` cannot be the zero address.
990      */
991     function approve(address spender, uint256 amount) public virtual override returns (bool) {
992         _approve(_msgSender(), spender, amount);
993         return true;
994     }
995 
996     /**
997      * @dev See {IERC20-transferFrom}.
998      *
999      * Emits an {Approval} event indicating the updated allowance. This is not
1000      * required by the EIP. See the note at the beginning of {ERC20};
1001      *
1002      * Requirements:
1003      * - `sender` and `recipient` cannot be the zero address.
1004      * - `sender` must have a balance of at least `amount`.
1005      * - the caller must have allowance for ``sender``'s tokens of at least
1006      * `amount`.
1007      */
1008     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1009         _transfer(sender, recipient, amount);
1010         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1011         return true;
1012     }
1013 
1014     /**
1015      * @dev Atomically increases the allowance granted to `spender` by the caller.
1016      *
1017      * This is an alternative to {approve} that can be used as a mitigation for
1018      * problems described in {IERC20-approve}.
1019      *
1020      * Emits an {Approval} event indicating the updated allowance.
1021      *
1022      * Requirements:
1023      *
1024      * - `spender` cannot be the zero address.
1025      */
1026     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1027         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1028         return true;
1029     }
1030 
1031     /**
1032      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1033      *
1034      * This is an alternative to {approve} that can be used as a mitigation for
1035      * problems described in {IERC20-approve}.
1036      *
1037      * Emits an {Approval} event indicating the updated allowance.
1038      *
1039      * Requirements:
1040      *
1041      * - `spender` cannot be the zero address.
1042      * - `spender` must have allowance for the caller of at least
1043      * `subtractedValue`.
1044      */
1045     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1046         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1047         return true;
1048     }
1049 
1050     /**
1051      * @dev Moves tokens `amount` from `sender` to `recipient`.
1052      *
1053      * This is internal function is equivalent to {transfer}, and can be used to
1054      * e.g. implement automatic token fees, slashing mechanisms, etc.
1055      *
1056      * Emits a {Transfer} event.
1057      *
1058      * Requirements:
1059      *
1060      * - `sender` cannot be the zero address.
1061      * - `recipient` cannot be the zero address.
1062      * - `sender` must have a balance of at least `amount`.
1063      */
1064     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1065         require(sender != address(0), "ERC20: transfer from the zero address");
1066         require(recipient != address(0), "ERC20: transfer to the zero address");
1067 
1068         _beforeTokenTransfer(sender, recipient, amount);
1069 
1070         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1071         _balances[recipient] = _balances[recipient].add(amount);
1072         emit Transfer(sender, recipient, amount);
1073     }
1074 
1075     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1076      * the total supply.
1077      *
1078      * Emits a {Transfer} event with `from` set to the zero address.
1079      *
1080      * Requirements
1081      *
1082      * - `to` cannot be the zero address.
1083      */
1084     function _mint(address account, uint256 amount) internal virtual {
1085         require(account != address(0), "ERC20: mint to the zero address");
1086 
1087         _beforeTokenTransfer(address(0), account, amount);
1088 
1089         _totalSupply = _totalSupply.add(amount);
1090         _balances[account] = _balances[account].add(amount);
1091         emit Transfer(address(0), account, amount);
1092     }
1093 
1094     /**
1095      * @dev Destroys `amount` tokens from `account`, reducing the
1096      * total supply.
1097      *
1098      * Emits a {Transfer} event with `to` set to the zero address.
1099      *
1100      * Requirements
1101      *
1102      * - `account` cannot be the zero address.
1103      * - `account` must have at least `amount` tokens.
1104      */
1105     function _burn(address account, uint256 amount) internal virtual {
1106         require(account != address(0), "ERC20: burn from the zero address");
1107 
1108         _beforeTokenTransfer(account, address(0), amount);
1109 
1110         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1111         _totalSupply = _totalSupply.sub(amount);
1112         emit Transfer(account, address(0), amount);
1113     }
1114 
1115     /**
1116      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1117      *
1118      * This is internal function is equivalent to `approve`, and can be used to
1119      * e.g. set automatic allowances for certain subsystems, etc.
1120      *
1121      * Emits an {Approval} event.
1122      *
1123      * Requirements:
1124      *
1125      * - `owner` cannot be the zero address.
1126      * - `spender` cannot be the zero address.
1127      */
1128     function _approve(address owner, address spender, uint256 amount) internal virtual {
1129         require(owner != address(0), "ERC20: approve from the zero address");
1130         require(spender != address(0), "ERC20: approve to the zero address");
1131 
1132         _allowances[owner][spender] = amount;
1133         emit Approval(owner, spender, amount);
1134     }
1135 
1136     /**
1137      * @dev Sets {decimals} to a value other than the default one of 18.
1138      *
1139      * WARNING: This function should only be called from the constructor. Most
1140      * applications that interact with token contracts will not expect
1141      * {decimals} to ever change, and may work incorrectly if it does.
1142      */
1143     function _setupDecimals(uint8 decimals_) internal {
1144         _decimals = decimals_;
1145     }
1146 
1147     /**
1148      * @dev Hook that is called before any transfer of tokens. This includes
1149      * minting and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1154      * will be to transferred to `to`.
1155      * - when `from` is zero, `amount` tokens will be minted for `to`.
1156      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1162 }
1163 
1164 
1165 
1166 
1167 /**
1168  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1169  * tokens and those that they have an allowance for, in a way that can be
1170  * recognized off-chain (via event analysis).
1171  */
1172 abstract contract ERC20Burnable is Context, ERC20 {
1173     /**
1174      * @dev Destroys `amount` tokens from the caller.
1175      *
1176      * See {ERC20-_burn}.
1177      */
1178     function burn(uint256 amount) public virtual {
1179         _burn(_msgSender(), amount);
1180     }
1181 
1182     /**
1183      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1184      * allowance.
1185      *
1186      * See {ERC20-_burn} and {ERC20-allowance}.
1187      *
1188      * Requirements:
1189      *
1190      * - the caller must have allowance for ``accounts``'s tokens of at least
1191      * `amount`.
1192      */
1193     function burnFrom(address account, uint256 amount) public virtual {
1194         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1195 
1196         _approve(account, _msgSender(), decreasedAllowance);
1197         _burn(account, amount);
1198     }
1199 }
1200 
1201 
1202 
1203 /**
1204  * @dev Contract module which allows children to implement an emergency stop
1205  * mechanism that can be triggered by an authorized account.
1206  *
1207  * This module is used through inheritance. It will make available the
1208  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1209  * the functions of your contract. Note that they will not be pausable by
1210  * simply including this module, only once the modifiers are put in place.
1211  */
1212 contract Pausable is Context {
1213     /**
1214      * @dev Emitted when the pause is triggered by `account`.
1215      */
1216     event Paused(address account);
1217 
1218     /**
1219      * @dev Emitted when the pause is lifted by `account`.
1220      */
1221     event Unpaused(address account);
1222 
1223     bool private _paused;
1224 
1225     /**
1226      * @dev Initializes the contract in unpaused state.
1227      */
1228     constructor () internal {
1229         _paused = false;
1230     }
1231 
1232     /**
1233      * @dev Returns true if the contract is paused, and false otherwise.
1234      */
1235     function paused() public view returns (bool) {
1236         return _paused;
1237     }
1238 
1239     /**
1240      * @dev Modifier to make a function callable only when the contract is not paused.
1241      *
1242      * Requirements:
1243      *
1244      * - The contract must not be paused.
1245      */
1246     modifier whenNotPaused() {
1247         require(!_paused, "Pausable: paused");
1248         _;
1249     }
1250 
1251     /**
1252      * @dev Modifier to make a function callable only when the contract is paused.
1253      *
1254      * Requirements:
1255      *
1256      * - The contract must be paused.
1257      */
1258     modifier whenPaused() {
1259         require(_paused, "Pausable: not paused");
1260         _;
1261     }
1262 
1263     /**
1264      * @dev Triggers stopped state.
1265      *
1266      * Requirements:
1267      *
1268      * - The contract must not be paused.
1269      */
1270     function _pause() internal virtual whenNotPaused {
1271         _paused = true;
1272         emit Paused(_msgSender());
1273     }
1274 
1275     /**
1276      * @dev Returns to normal state.
1277      *
1278      * Requirements:
1279      *
1280      * - The contract must be paused.
1281      */
1282     function _unpause() internal virtual whenPaused {
1283         _paused = false;
1284         emit Unpaused(_msgSender());
1285     }
1286 }
1287 
1288 
1289 
1290 
1291 /**
1292  * @dev ERC20 token with pausable token transfers, minting and burning.
1293  *
1294  * Useful for scenarios such as preventing trades until the end of an evaluation
1295  * period, or having an emergency switch for freezing all token transfers in the
1296  * event of a large bug.
1297  */
1298 abstract contract ERC20Pausable is ERC20, Pausable {
1299     /**
1300      * @dev See {ERC20-_beforeTokenTransfer}.
1301      *
1302      * Requirements:
1303      *
1304      * - the contract must not be paused.
1305      */
1306     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1307         super._beforeTokenTransfer(from, to, amount);
1308 
1309         require(!paused(), "ERC20Pausable: token transfer while paused");
1310     }
1311 }
1312 
1313 
1314 
1315 
1316 
1317 
1318 
1319 /**
1320  * @dev {ERC20} token, including:
1321  *
1322  *  - ability for holders to burn (destroy) their tokens
1323  *  - a minter role that allows for token minting (creation)
1324  *  - a pauser role that allows to stop all token transfers
1325  *
1326  * This contract uses {AccessControl} to lock permissioned functions using the
1327  * different roles - head to its documentation for details.
1328  *
1329  * The account that deploys the contract will be granted the minter and pauser
1330  * roles, as well as the default admin role, which will let it grant both minter
1331  * and pauser roles to other accounts.
1332  */
1333 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1334     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1335     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1336 
1337     /**
1338      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1339      * account that deploys the contract.
1340      *
1341      * See {ERC20-constructor}.
1342      */
1343     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1344         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1345 
1346         _setupRole(MINTER_ROLE, _msgSender());
1347         _setupRole(PAUSER_ROLE, _msgSender());
1348     }
1349 
1350     /**
1351      * @dev Creates `amount` new tokens for `to`.
1352      *
1353      * See {ERC20-_mint}.
1354      *
1355      * Requirements:
1356      *
1357      * - the caller must have the `MINTER_ROLE`.
1358      */
1359     function mint(address to, uint256 amount) public virtual {
1360         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1361         _mint(to, amount);
1362     }
1363 
1364     /**
1365      * @dev Pauses all token transfers.
1366      *
1367      * See {ERC20Pausable} and {Pausable-_pause}.
1368      *
1369      * Requirements:
1370      *
1371      * - the caller must have the `PAUSER_ROLE`.
1372      */
1373     function pause() public virtual {
1374         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1375         _pause();
1376     }
1377 
1378     /**
1379      * @dev Unpauses all token transfers.
1380      *
1381      * See {ERC20Pausable} and {Pausable-_unpause}.
1382      *
1383      * Requirements:
1384      *
1385      * - the caller must have the `PAUSER_ROLE`.
1386      */
1387     function unpause() public virtual {
1388         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1389         _unpause();
1390     }
1391 
1392     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1393         super._beforeTokenTransfer(from, to, amount);
1394     }
1395 }
1396 
1397 
1398 
1399 contract AllianceBlockToken is ERC20PresetMinterPauser {
1400      constructor() public ERC20PresetMinterPauser("AllianceBlock Token", "ALBT") {}
1401 
1402      function removeMinterRole(address owner) public {
1403           revokeRole(MINTER_ROLE, owner);
1404      }
1405 }