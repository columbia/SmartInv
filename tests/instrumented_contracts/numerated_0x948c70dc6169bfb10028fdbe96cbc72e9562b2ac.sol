1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
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
245 // File: @openzeppelin/contracts/utils/Address.sol
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/GSN/Context.sol
388 
389 pragma solidity ^0.6.0;
390 
391 /*
392  * @dev Provides information about the current execution context, including the
393  * sender of the transaction and its data. While these are generally available
394  * via msg.sender and msg.data, they should not be accessed in such a direct
395  * manner, since when dealing with GSN meta-transactions the account sending and
396  * paying for execution may not be the actual sender (as far as an application
397  * is concerned).
398  *
399  * This contract is only required for intermediate, library-like contracts.
400  */
401 abstract contract Context {
402     function _msgSender() internal view virtual returns (address payable) {
403         return msg.sender;
404     }
405 
406     function _msgData() internal view virtual returns (bytes memory) {
407         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
408         return msg.data;
409     }
410 }
411 
412 // File: @openzeppelin/contracts/access/AccessControl.sol
413 
414 pragma solidity ^0.6.0;
415 
416 
417 
418 
419 /**
420  * @dev Contract module that allows children to implement role-based access
421  * control mechanisms.
422  *
423  * Roles are referred to by their `bytes32` identifier. These should be exposed
424  * in the external API and be unique. The best way to achieve this is by
425  * using `public constant` hash digests:
426  *
427  * ```
428  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
429  * ```
430  *
431  * Roles can be used to represent a set of permissions. To restrict access to a
432  * function call, use {hasRole}:
433  *
434  * ```
435  * function foo() public {
436  *     require(hasRole(MY_ROLE, msg.sender));
437  *     ...
438  * }
439  * ```
440  *
441  * Roles can be granted and revoked dynamically via the {grantRole} and
442  * {revokeRole} functions. Each role has an associated admin role, and only
443  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
444  *
445  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
446  * that only accounts with this role will be able to grant or revoke other
447  * roles. More complex role relationships can be created by using
448  * {_setRoleAdmin}.
449  *
450  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
451  * grant and revoke this role. Extra precautions should be taken to secure
452  * accounts that have been granted it.
453  */
454 abstract contract AccessControl is Context {
455     using EnumerableSet for EnumerableSet.AddressSet;
456     using Address for address;
457 
458     struct RoleData {
459         EnumerableSet.AddressSet members;
460         bytes32 adminRole;
461     }
462 
463     mapping (bytes32 => RoleData) private _roles;
464 
465     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
466 
467     /**
468      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
469      *
470      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
471      * {RoleAdminChanged} not being emitted signaling this.
472      *
473      * _Available since v3.1._
474      */
475     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
476 
477     /**
478      * @dev Emitted when `account` is granted `role`.
479      *
480      * `sender` is the account that originated the contract call, an admin role
481      * bearer except when using {_setupRole}.
482      */
483     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
484 
485     /**
486      * @dev Emitted when `account` is revoked `role`.
487      *
488      * `sender` is the account that originated the contract call:
489      *   - if using `revokeRole`, it is the admin role bearer
490      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
491      */
492     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
493 
494     /**
495      * @dev Returns `true` if `account` has been granted `role`.
496      */
497     function hasRole(bytes32 role, address account) public view returns (bool) {
498         return _roles[role].members.contains(account);
499     }
500 
501     /**
502      * @dev Returns the number of accounts that have `role`. Can be used
503      * together with {getRoleMember} to enumerate all bearers of a role.
504      */
505     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
506         return _roles[role].members.length();
507     }
508 
509     /**
510      * @dev Returns one of the accounts that have `role`. `index` must be a
511      * value between 0 and {getRoleMemberCount}, non-inclusive.
512      *
513      * Role bearers are not sorted in any particular way, and their ordering may
514      * change at any point.
515      *
516      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
517      * you perform all queries on the same block. See the following
518      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
519      * for more information.
520      */
521     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
522         return _roles[role].members.at(index);
523     }
524 
525     /**
526      * @dev Returns the admin role that controls `role`. See {grantRole} and
527      * {revokeRole}.
528      *
529      * To change a role's admin, use {_setRoleAdmin}.
530      */
531     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
532         return _roles[role].adminRole;
533     }
534 
535     /**
536      * @dev Grants `role` to `account`.
537      *
538      * If `account` had not been already granted `role`, emits a {RoleGranted}
539      * event.
540      *
541      * Requirements:
542      *
543      * - the caller must have ``role``'s admin role.
544      */
545     function grantRole(bytes32 role, address account) public virtual {
546         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
547 
548         _grantRole(role, account);
549     }
550 
551     /**
552      * @dev Revokes `role` from `account`.
553      *
554      * If `account` had been granted `role`, emits a {RoleRevoked} event.
555      *
556      * Requirements:
557      *
558      * - the caller must have ``role``'s admin role.
559      */
560     function revokeRole(bytes32 role, address account) public virtual {
561         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
562 
563         _revokeRole(role, account);
564     }
565 
566     /**
567      * @dev Revokes `role` from the calling account.
568      *
569      * Roles are often managed via {grantRole} and {revokeRole}: this function's
570      * purpose is to provide a mechanism for accounts to lose their privileges
571      * if they are compromised (such as when a trusted device is misplaced).
572      *
573      * If the calling account had been granted `role`, emits a {RoleRevoked}
574      * event.
575      *
576      * Requirements:
577      *
578      * - the caller must be `account`.
579      */
580     function renounceRole(bytes32 role, address account) public virtual {
581         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
582 
583         _revokeRole(role, account);
584     }
585 
586     /**
587      * @dev Grants `role` to `account`.
588      *
589      * If `account` had not been already granted `role`, emits a {RoleGranted}
590      * event. Note that unlike {grantRole}, this function doesn't perform any
591      * checks on the calling account.
592      *
593      * [WARNING]
594      * ====
595      * This function should only be called from the constructor when setting
596      * up the initial roles for the system.
597      *
598      * Using this function in any other way is effectively circumventing the admin
599      * system imposed by {AccessControl}.
600      * ====
601      */
602     function _setupRole(bytes32 role, address account) internal virtual {
603         _grantRole(role, account);
604     }
605 
606     /**
607      * @dev Sets `adminRole` as ``role``'s admin role.
608      *
609      * Emits a {RoleAdminChanged} event.
610      */
611     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
612         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
613         _roles[role].adminRole = adminRole;
614     }
615 
616     function _grantRole(bytes32 role, address account) private {
617         if (_roles[role].members.add(account)) {
618             emit RoleGranted(role, account, _msgSender());
619         }
620     }
621 
622     function _revokeRole(bytes32 role, address account) private {
623         if (_roles[role].members.remove(account)) {
624             emit RoleRevoked(role, account, _msgSender());
625         }
626     }
627 }
628 
629 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
630 
631 pragma solidity ^0.6.0;
632 
633 /**
634  * @dev Interface of the ERC20 standard as defined in the EIP.
635  */
636 interface IERC20 {
637     /**
638      * @dev Returns the amount of tokens in existence.
639      */
640     function totalSupply() external view returns (uint256);
641 
642     /**
643      * @dev Returns the amount of tokens owned by `account`.
644      */
645     function balanceOf(address account) external view returns (uint256);
646 
647     /**
648      * @dev Moves `amount` tokens from the caller's account to `recipient`.
649      *
650      * Returns a boolean value indicating whether the operation succeeded.
651      *
652      * Emits a {Transfer} event.
653      */
654     function transfer(address recipient, uint256 amount) external returns (bool);
655 
656     /**
657      * @dev Returns the remaining number of tokens that `spender` will be
658      * allowed to spend on behalf of `owner` through {transferFrom}. This is
659      * zero by default.
660      *
661      * This value changes when {approve} or {transferFrom} are called.
662      */
663     function allowance(address owner, address spender) external view returns (uint256);
664 
665     /**
666      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
667      *
668      * Returns a boolean value indicating whether the operation succeeded.
669      *
670      * IMPORTANT: Beware that changing an allowance with this method brings the risk
671      * that someone may use both the old and the new allowance by unfortunate
672      * transaction ordering. One possible solution to mitigate this race
673      * condition is to first reduce the spender's allowance to 0 and set the
674      * desired value afterwards:
675      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
676      *
677      * Emits an {Approval} event.
678      */
679     function approve(address spender, uint256 amount) external returns (bool);
680 
681     /**
682      * @dev Moves `amount` tokens from `sender` to `recipient` using the
683      * allowance mechanism. `amount` is then deducted from the caller's
684      * allowance.
685      *
686      * Returns a boolean value indicating whether the operation succeeded.
687      *
688      * Emits a {Transfer} event.
689      */
690     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
691 
692     /**
693      * @dev Emitted when `value` tokens are moved from one account (`from`) to
694      * another (`to`).
695      *
696      * Note that `value` may be zero.
697      */
698     event Transfer(address indexed from, address indexed to, uint256 value);
699 
700     /**
701      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
702      * a call to {approve}. `value` is the new allowance.
703      */
704     event Approval(address indexed owner, address indexed spender, uint256 value);
705 }
706 
707 // File: @openzeppelin/contracts/math/SafeMath.sol
708 
709 pragma solidity ^0.6.0;
710 
711 /**
712  * @dev Wrappers over Solidity's arithmetic operations with added overflow
713  * checks.
714  *
715  * Arithmetic operations in Solidity wrap on overflow. This can easily result
716  * in bugs, because programmers usually assume that an overflow raises an
717  * error, which is the standard behavior in high level programming languages.
718  * `SafeMath` restores this intuition by reverting the transaction when an
719  * operation overflows.
720  *
721  * Using this library instead of the unchecked operations eliminates an entire
722  * class of bugs, so it's recommended to use it always.
723  */
724 library SafeMath {
725     /**
726      * @dev Returns the addition of two unsigned integers, reverting on
727      * overflow.
728      *
729      * Counterpart to Solidity's `+` operator.
730      *
731      * Requirements:
732      *
733      * - Addition cannot overflow.
734      */
735     function add(uint256 a, uint256 b) internal pure returns (uint256) {
736         uint256 c = a + b;
737         require(c >= a, "SafeMath: addition overflow");
738 
739         return c;
740     }
741 
742     /**
743      * @dev Returns the subtraction of two unsigned integers, reverting on
744      * overflow (when the result is negative).
745      *
746      * Counterpart to Solidity's `-` operator.
747      *
748      * Requirements:
749      *
750      * - Subtraction cannot overflow.
751      */
752     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
753         return sub(a, b, "SafeMath: subtraction overflow");
754     }
755 
756     /**
757      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
758      * overflow (when the result is negative).
759      *
760      * Counterpart to Solidity's `-` operator.
761      *
762      * Requirements:
763      *
764      * - Subtraction cannot overflow.
765      */
766     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
767         require(b <= a, errorMessage);
768         uint256 c = a - b;
769 
770         return c;
771     }
772 
773     /**
774      * @dev Returns the multiplication of two unsigned integers, reverting on
775      * overflow.
776      *
777      * Counterpart to Solidity's `*` operator.
778      *
779      * Requirements:
780      *
781      * - Multiplication cannot overflow.
782      */
783     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
784         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
785         // benefit is lost if 'b' is also tested.
786         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
787         if (a == 0) {
788             return 0;
789         }
790 
791         uint256 c = a * b;
792         require(c / a == b, "SafeMath: multiplication overflow");
793 
794         return c;
795     }
796 
797     /**
798      * @dev Returns the integer division of two unsigned integers. Reverts on
799      * division by zero. The result is rounded towards zero.
800      *
801      * Counterpart to Solidity's `/` operator. Note: this function uses a
802      * `revert` opcode (which leaves remaining gas untouched) while Solidity
803      * uses an invalid opcode to revert (consuming all remaining gas).
804      *
805      * Requirements:
806      *
807      * - The divisor cannot be zero.
808      */
809     function div(uint256 a, uint256 b) internal pure returns (uint256) {
810         return div(a, b, "SafeMath: division by zero");
811     }
812 
813     /**
814      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
825     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
826         require(b > 0, errorMessage);
827         uint256 c = a / b;
828         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
829 
830         return c;
831     }
832 
833     /**
834      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
835      * Reverts when dividing by zero.
836      *
837      * Counterpart to Solidity's `%` operator. This function uses a `revert`
838      * opcode (which leaves remaining gas untouched) while Solidity uses an
839      * invalid opcode to revert (consuming all remaining gas).
840      *
841      * Requirements:
842      *
843      * - The divisor cannot be zero.
844      */
845     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
846         return mod(a, b, "SafeMath: modulo by zero");
847     }
848 
849     /**
850      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
851      * Reverts with custom message when dividing by zero.
852      *
853      * Counterpart to Solidity's `%` operator. This function uses a `revert`
854      * opcode (which leaves remaining gas untouched) while Solidity uses an
855      * invalid opcode to revert (consuming all remaining gas).
856      *
857      * Requirements:
858      *
859      * - The divisor cannot be zero.
860      */
861     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
862         require(b != 0, errorMessage);
863         return a % b;
864     }
865 }
866 
867 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
868 
869 pragma solidity ^0.6.0;
870 
871 
872 
873 
874 
875 /**
876  * @dev Implementation of the {IERC20} interface.
877  *
878  * This implementation is agnostic to the way tokens are created. This means
879  * that a supply mechanism has to be added in a derived contract using {_mint}.
880  * For a generic mechanism see {ERC20PresetMinterPauser}.
881  *
882  * TIP: For a detailed writeup see our guide
883  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
884  * to implement supply mechanisms].
885  *
886  * We have followed general OpenZeppelin guidelines: functions revert instead
887  * of returning `false` on failure. This behavior is nonetheless conventional
888  * and does not conflict with the expectations of ERC20 applications.
889  *
890  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
891  * This allows applications to reconstruct the allowance for all accounts just
892  * by listening to said events. Other implementations of the EIP may not emit
893  * these events, as it isn't required by the specification.
894  *
895  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
896  * functions have been added to mitigate the well-known issues around setting
897  * allowances. See {IERC20-approve}.
898  */
899 contract ERC20 is Context, IERC20 {
900     using SafeMath for uint256;
901     using Address for address;
902 
903     mapping (address => uint256) private _balances;
904 
905     mapping (address => mapping (address => uint256)) private _allowances;
906 
907     uint256 private _totalSupply;
908 
909     string private _name;
910     string private _symbol;
911     uint8 private _decimals;
912 
913     /**
914      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
915      * a default value of 18.
916      *
917      * To select a different value for {decimals}, use {_setupDecimals}.
918      *
919      * All three of these values are immutable: they can only be set once during
920      * construction.
921      */
922     constructor (string memory name, string memory symbol) public {
923         _name = name;
924         _symbol = symbol;
925         _decimals = 18;
926     }
927 
928     /**
929      * @dev Returns the name of the token.
930      */
931     function name() public view returns (string memory) {
932         return _name;
933     }
934 
935     /**
936      * @dev Returns the symbol of the token, usually a shorter version of the
937      * name.
938      */
939     function symbol() public view returns (string memory) {
940         return _symbol;
941     }
942 
943     /**
944      * @dev Returns the number of decimals used to get its user representation.
945      * For example, if `decimals` equals `2`, a balance of `505` tokens should
946      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
947      *
948      * Tokens usually opt for a value of 18, imitating the relationship between
949      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
950      * called.
951      *
952      * NOTE: This information is only used for _display_ purposes: it in
953      * no way affects any of the arithmetic of the contract, including
954      * {IERC20-balanceOf} and {IERC20-transfer}.
955      */
956     function decimals() public view returns (uint8) {
957         return _decimals;
958     }
959 
960     /**
961      * @dev See {IERC20-totalSupply}.
962      */
963     function totalSupply() public view override returns (uint256) {
964         return _totalSupply;
965     }
966 
967     /**
968      * @dev See {IERC20-balanceOf}.
969      */
970     function balanceOf(address account) public view override returns (uint256) {
971         return _balances[account];
972     }
973 
974     /**
975      * @dev See {IERC20-transfer}.
976      *
977      * Requirements:
978      *
979      * - `recipient` cannot be the zero address.
980      * - the caller must have a balance of at least `amount`.
981      */
982     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
983         _transfer(_msgSender(), recipient, amount);
984         return true;
985     }
986 
987     /**
988      * @dev See {IERC20-allowance}.
989      */
990     function allowance(address owner, address spender) public view virtual override returns (uint256) {
991         return _allowances[owner][spender];
992     }
993 
994     /**
995      * @dev See {IERC20-approve}.
996      *
997      * Requirements:
998      *
999      * - `spender` cannot be the zero address.
1000      */
1001     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1002         _approve(_msgSender(), spender, amount);
1003         return true;
1004     }
1005 
1006     /**
1007      * @dev See {IERC20-transferFrom}.
1008      *
1009      * Emits an {Approval} event indicating the updated allowance. This is not
1010      * required by the EIP. See the note at the beginning of {ERC20};
1011      *
1012      * Requirements:
1013      * - `sender` and `recipient` cannot be the zero address.
1014      * - `sender` must have a balance of at least `amount`.
1015      * - the caller must have allowance for ``sender``'s tokens of at least
1016      * `amount`.
1017      */
1018     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1019         _transfer(sender, recipient, amount);
1020         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1021         return true;
1022     }
1023 
1024     /**
1025      * @dev Atomically increases the allowance granted to `spender` by the caller.
1026      *
1027      * This is an alternative to {approve} that can be used as a mitigation for
1028      * problems described in {IERC20-approve}.
1029      *
1030      * Emits an {Approval} event indicating the updated allowance.
1031      *
1032      * Requirements:
1033      *
1034      * - `spender` cannot be the zero address.
1035      */
1036     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1037         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1038         return true;
1039     }
1040 
1041     /**
1042      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1043      *
1044      * This is an alternative to {approve} that can be used as a mitigation for
1045      * problems described in {IERC20-approve}.
1046      *
1047      * Emits an {Approval} event indicating the updated allowance.
1048      *
1049      * Requirements:
1050      *
1051      * - `spender` cannot be the zero address.
1052      * - `spender` must have allowance for the caller of at least
1053      * `subtractedValue`.
1054      */
1055     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1056         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1057         return true;
1058     }
1059 
1060     /**
1061      * @dev Moves tokens `amount` from `sender` to `recipient`.
1062      *
1063      * This is internal function is equivalent to {transfer}, and can be used to
1064      * e.g. implement automatic token fees, slashing mechanisms, etc.
1065      *
1066      * Emits a {Transfer} event.
1067      *
1068      * Requirements:
1069      *
1070      * - `sender` cannot be the zero address.
1071      * - `recipient` cannot be the zero address.
1072      * - `sender` must have a balance of at least `amount`.
1073      */
1074     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1075         require(sender != address(0), "ERC20: transfer from the zero address");
1076         require(recipient != address(0), "ERC20: transfer to the zero address");
1077 
1078         _beforeTokenTransfer(sender, recipient, amount);
1079 
1080         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1081         _balances[recipient] = _balances[recipient].add(amount);
1082         emit Transfer(sender, recipient, amount);
1083     }
1084 
1085     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1086      * the total supply.
1087      *
1088      * Emits a {Transfer} event with `from` set to the zero address.
1089      *
1090      * Requirements
1091      *
1092      * - `to` cannot be the zero address.
1093      */
1094     function _mint(address account, uint256 amount) internal virtual {
1095         require(account != address(0), "ERC20: mint to the zero address");
1096 
1097         _beforeTokenTransfer(address(0), account, amount);
1098 
1099         _totalSupply = _totalSupply.add(amount);
1100         _balances[account] = _balances[account].add(amount);
1101         emit Transfer(address(0), account, amount);
1102     }
1103 
1104     /**
1105      * @dev Destroys `amount` tokens from `account`, reducing the
1106      * total supply.
1107      *
1108      * Emits a {Transfer} event with `to` set to the zero address.
1109      *
1110      * Requirements
1111      *
1112      * - `account` cannot be the zero address.
1113      * - `account` must have at least `amount` tokens.
1114      */
1115     function _burn(address account, uint256 amount) internal virtual {
1116         require(account != address(0), "ERC20: burn from the zero address");
1117 
1118         _beforeTokenTransfer(account, address(0), amount);
1119 
1120         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1121         _totalSupply = _totalSupply.sub(amount);
1122         emit Transfer(account, address(0), amount);
1123     }
1124 
1125     /**
1126      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1127      *
1128      * This internal function is equivalent to `approve`, and can be used to
1129      * e.g. set automatic allowances for certain subsystems, etc.
1130      *
1131      * Emits an {Approval} event.
1132      *
1133      * Requirements:
1134      *
1135      * - `owner` cannot be the zero address.
1136      * - `spender` cannot be the zero address.
1137      */
1138     function _approve(address owner, address spender, uint256 amount) internal virtual {
1139         require(owner != address(0), "ERC20: approve from the zero address");
1140         require(spender != address(0), "ERC20: approve to the zero address");
1141 
1142         _allowances[owner][spender] = amount;
1143         emit Approval(owner, spender, amount);
1144     }
1145 
1146     /**
1147      * @dev Sets {decimals} to a value other than the default one of 18.
1148      *
1149      * WARNING: This function should only be called from the constructor. Most
1150      * applications that interact with token contracts will not expect
1151      * {decimals} to ever change, and may work incorrectly if it does.
1152      */
1153     function _setupDecimals(uint8 decimals_) internal {
1154         _decimals = decimals_;
1155     }
1156 
1157     /**
1158      * @dev Hook that is called before any transfer of tokens. This includes
1159      * minting and burning.
1160      *
1161      * Calling conditions:
1162      *
1163      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1164      * will be to transferred to `to`.
1165      * - when `from` is zero, `amount` tokens will be minted for `to`.
1166      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1167      * - `from` and `to` are never both zero.
1168      *
1169      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1170      */
1171     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1172 }
1173 
1174 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1175 
1176 pragma solidity ^0.6.0;
1177 
1178 
1179 
1180 /**
1181  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1182  * tokens and those that they have an allowance for, in a way that can be
1183  * recognized off-chain (via event analysis).
1184  */
1185 abstract contract ERC20Burnable is Context, ERC20 {
1186     /**
1187      * @dev Destroys `amount` tokens from the caller.
1188      *
1189      * See {ERC20-_burn}.
1190      */
1191     function burn(uint256 amount) public virtual {
1192         _burn(_msgSender(), amount);
1193     }
1194 
1195     /**
1196      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1197      * allowance.
1198      *
1199      * See {ERC20-_burn} and {ERC20-allowance}.
1200      *
1201      * Requirements:
1202      *
1203      * - the caller must have allowance for ``accounts``'s tokens of at least
1204      * `amount`.
1205      */
1206     function burnFrom(address account, uint256 amount) public virtual {
1207         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1208 
1209         _approve(account, _msgSender(), decreasedAllowance);
1210         _burn(account, amount);
1211     }
1212 }
1213 
1214 // File: @openzeppelin/contracts/utils/Pausable.sol
1215 
1216 pragma solidity ^0.6.0;
1217 
1218 
1219 /**
1220  * @dev Contract module which allows children to implement an emergency stop
1221  * mechanism that can be triggered by an authorized account.
1222  *
1223  * This module is used through inheritance. It will make available the
1224  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1225  * the functions of your contract. Note that they will not be pausable by
1226  * simply including this module, only once the modifiers are put in place.
1227  */
1228 contract Pausable is Context {
1229     /**
1230      * @dev Emitted when the pause is triggered by `account`.
1231      */
1232     event Paused(address account);
1233 
1234     /**
1235      * @dev Emitted when the pause is lifted by `account`.
1236      */
1237     event Unpaused(address account);
1238 
1239     bool private _paused;
1240 
1241     /**
1242      * @dev Initializes the contract in unpaused state.
1243      */
1244     constructor () internal {
1245         _paused = false;
1246     }
1247 
1248     /**
1249      * @dev Returns true if the contract is paused, and false otherwise.
1250      */
1251     function paused() public view returns (bool) {
1252         return _paused;
1253     }
1254 
1255     /**
1256      * @dev Modifier to make a function callable only when the contract is not paused.
1257      *
1258      * Requirements:
1259      *
1260      * - The contract must not be paused.
1261      */
1262     modifier whenNotPaused() {
1263         require(!_paused, "Pausable: paused");
1264         _;
1265     }
1266 
1267     /**
1268      * @dev Modifier to make a function callable only when the contract is paused.
1269      *
1270      * Requirements:
1271      *
1272      * - The contract must be paused.
1273      */
1274     modifier whenPaused() {
1275         require(_paused, "Pausable: not paused");
1276         _;
1277     }
1278 
1279     /**
1280      * @dev Triggers stopped state.
1281      *
1282      * Requirements:
1283      *
1284      * - The contract must not be paused.
1285      */
1286     function _pause() internal virtual whenNotPaused {
1287         _paused = true;
1288         emit Paused(_msgSender());
1289     }
1290 
1291     /**
1292      * @dev Returns to normal state.
1293      *
1294      * Requirements:
1295      *
1296      * - The contract must be paused.
1297      */
1298     function _unpause() internal virtual whenPaused {
1299         _paused = false;
1300         emit Unpaused(_msgSender());
1301     }
1302 }
1303 
1304 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
1305 
1306 pragma solidity ^0.6.0;
1307 
1308 
1309 
1310 /**
1311  * @dev ERC20 token with pausable token transfers, minting and burning.
1312  *
1313  * Useful for scenarios such as preventing trades until the end of an evaluation
1314  * period, or having an emergency switch for freezing all token transfers in the
1315  * event of a large bug.
1316  */
1317 abstract contract ERC20Pausable is ERC20, Pausable {
1318     /**
1319      * @dev See {ERC20-_beforeTokenTransfer}.
1320      *
1321      * Requirements:
1322      *
1323      * - the contract must not be paused.
1324      */
1325     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1326         super._beforeTokenTransfer(from, to, amount);
1327 
1328         require(!paused(), "ERC20Pausable: token transfer while paused");
1329     }
1330 }
1331 
1332 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
1333 
1334 pragma solidity ^0.6.0;
1335 
1336 
1337 /**
1338  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1339  */
1340 abstract contract ERC20Capped is ERC20 {
1341     uint256 private _cap;
1342 
1343     /**
1344      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1345      * set once during construction.
1346      */
1347     constructor (uint256 cap) public {
1348         require(cap > 0, "ERC20Capped: cap is 0");
1349         _cap = cap;
1350     }
1351 
1352     /**
1353      * @dev Returns the cap on the token's total supply.
1354      */
1355     function cap() public view returns (uint256) {
1356         return _cap;
1357     }
1358 
1359     /**
1360      * @dev See {ERC20-_beforeTokenTransfer}.
1361      *
1362      * Requirements:
1363      *
1364      * - minted tokens must not cause the total supply to go over the cap.
1365      */
1366     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1367         super._beforeTokenTransfer(from, to, amount);
1368 
1369         if (from == address(0)) { // When minting tokens
1370             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1371         }
1372     }
1373 }
1374 
1375 // File: contracts/erc20Token.sol
1376 
1377 pragma solidity ^0.6.0;
1378 
1379 contract erc20Token is Context, AccessControl, ERC20, ERC20Burnable, ERC20Pausable, ERC20Capped {
1380     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1381     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1382 
1383     /**
1384      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1385      * account.
1386      *
1387      */
1388     constructor(string memory name, string memory symbol, address account, uint256 cap, uint8 decimals) public ERC20(name, symbol) ERC20Capped(cap * (10**uint256(decimals))) {
1389         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1390 
1391         _setupRole(MINTER_ROLE, account);
1392         _setupRole(PAUSER_ROLE, account);
1393         _setupDecimals(decimals);
1394     }
1395 
1396     /**
1397      * @dev Creates `amount` new tokens for `to`.
1398      *
1399      * Requirements:
1400      *
1401      * - the caller must have the `MINTER_ROLE`.
1402      */
1403     function mint(address to, uint256 amount) public virtual {
1404         require(hasRole(MINTER_ROLE, _msgSender()), "MyToken: must have minter role to mint");
1405         _mint(to, amount);
1406     }
1407 
1408     /**
1409      * @dev Pauses all token transfers.
1410      *
1411      * Requirements:
1412      *
1413      * - the caller must have the `PAUSER_ROLE`.
1414      */
1415     function pause() public virtual {
1416         require(hasRole(PAUSER_ROLE, _msgSender()), "MyToken: must have pauser role to pause");
1417         _pause();
1418     }
1419 
1420     /**
1421      * @dev Unpauses all token transfers.
1422      *
1423      * Requirements:
1424      *
1425      * - the caller must have the `PAUSER_ROLE`.
1426      */
1427     function unpause() public virtual {
1428         require(hasRole(PAUSER_ROLE, _msgSender()), "MyToken: must have pauser role to unpause");
1429         _unpause();
1430     }
1431 
1432     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable, ERC20Capped) {
1433         super._beforeTokenTransfer(from, to, amount);
1434     }
1435 }