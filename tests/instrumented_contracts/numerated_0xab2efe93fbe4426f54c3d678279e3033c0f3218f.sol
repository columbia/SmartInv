1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 // 
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
247 // 
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
270         // This method relies in extcodesize, which returns 0 for contracts in
271         // construction, since the code is only stored at the end of the
272         // constructor execution.
273 
274         uint256 size;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { size := extcodesize(account) }
277         return size > 0;
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
386 // 
387 /*
388  * @dev Provides information about the current execution context, including the
389  * sender of the transaction and its data. While these are generally available
390  * via msg.sender and msg.data, they should not be accessed in such a direct
391  * manner, since when dealing with GSN meta-transactions the account sending and
392  * paying for execution may not be the actual sender (as far as an application
393  * is concerned).
394  *
395  * This contract is only required for intermediate, library-like contracts.
396  */
397 abstract contract Context {
398     function _msgSender() internal view virtual returns (address payable) {
399         return msg.sender;
400     }
401 
402     function _msgData() internal view virtual returns (bytes memory) {
403         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
404         return msg.data;
405     }
406 }
407 
408 // 
409 /**
410  * @dev Contract module that allows children to implement role-based access
411  * control mechanisms.
412  *
413  * Roles are referred to by their `bytes32` identifier. These should be exposed
414  * in the external API and be unique. The best way to achieve this is by
415  * using `public constant` hash digests:
416  *
417  * ```
418  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
419  * ```
420  *
421  * Roles can be used to represent a set of permissions. To restrict access to a
422  * function call, use {hasRole}:
423  *
424  * ```
425  * function foo() public {
426  *     require(hasRole(MY_ROLE, msg.sender));
427  *     ...
428  * }
429  * ```
430  *
431  * Roles can be granted and revoked dynamically via the {grantRole} and
432  * {revokeRole} functions. Each role has an associated admin role, and only
433  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
434  *
435  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
436  * that only accounts with this role will be able to grant or revoke other
437  * roles. More complex role relationships can be created by using
438  * {_setRoleAdmin}.
439  *
440  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
441  * grant and revoke this role. Extra precautions should be taken to secure
442  * accounts that have been granted it.
443  */
444 abstract contract AccessControl is Context {
445     using EnumerableSet for EnumerableSet.AddressSet;
446     using Address for address;
447 
448     struct RoleData {
449         EnumerableSet.AddressSet members;
450         bytes32 adminRole;
451     }
452 
453     mapping (bytes32 => RoleData) private _roles;
454 
455     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
456 
457     /**
458      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
459      *
460      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
461      * {RoleAdminChanged} not being emitted signaling this.
462      *
463      * _Available since v3.1._
464      */
465     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
466 
467     /**
468      * @dev Emitted when `account` is granted `role`.
469      *
470      * `sender` is the account that originated the contract call, an admin role
471      * bearer except when using {_setupRole}.
472      */
473     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
474 
475     /**
476      * @dev Emitted when `account` is revoked `role`.
477      *
478      * `sender` is the account that originated the contract call:
479      *   - if using `revokeRole`, it is the admin role bearer
480      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
481      */
482     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
483 
484     /**
485      * @dev Returns `true` if `account` has been granted `role`.
486      */
487     function hasRole(bytes32 role, address account) public view returns (bool) {
488         return _roles[role].members.contains(account);
489     }
490 
491     /**
492      * @dev Returns the number of accounts that have `role`. Can be used
493      * together with {getRoleMember} to enumerate all bearers of a role.
494      */
495     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
496         return _roles[role].members.length();
497     }
498 
499     /**
500      * @dev Returns one of the accounts that have `role`. `index` must be a
501      * value between 0 and {getRoleMemberCount}, non-inclusive.
502      *
503      * Role bearers are not sorted in any particular way, and their ordering may
504      * change at any point.
505      *
506      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
507      * you perform all queries on the same block. See the following
508      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
509      * for more information.
510      */
511     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
512         return _roles[role].members.at(index);
513     }
514 
515     /**
516      * @dev Returns the admin role that controls `role`. See {grantRole} and
517      * {revokeRole}.
518      *
519      * To change a role's admin, use {_setRoleAdmin}.
520      */
521     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
522         return _roles[role].adminRole;
523     }
524 
525     /**
526      * @dev Grants `role` to `account`.
527      *
528      * If `account` had not been already granted `role`, emits a {RoleGranted}
529      * event.
530      *
531      * Requirements:
532      *
533      * - the caller must have ``role``'s admin role.
534      */
535     function grantRole(bytes32 role, address account) public virtual {
536         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
537 
538         _grantRole(role, account);
539     }
540 
541     /**
542      * @dev Revokes `role` from `account`.
543      *
544      * If `account` had been granted `role`, emits a {RoleRevoked} event.
545      *
546      * Requirements:
547      *
548      * - the caller must have ``role``'s admin role.
549      */
550     function revokeRole(bytes32 role, address account) public virtual {
551         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
552 
553         _revokeRole(role, account);
554     }
555 
556     /**
557      * @dev Revokes `role` from the calling account.
558      *
559      * Roles are often managed via {grantRole} and {revokeRole}: this function's
560      * purpose is to provide a mechanism for accounts to lose their privileges
561      * if they are compromised (such as when a trusted device is misplaced).
562      *
563      * If the calling account had been granted `role`, emits a {RoleRevoked}
564      * event.
565      *
566      * Requirements:
567      *
568      * - the caller must be `account`.
569      */
570     function renounceRole(bytes32 role, address account) public virtual {
571         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
572 
573         _revokeRole(role, account);
574     }
575 
576     /**
577      * @dev Grants `role` to `account`.
578      *
579      * If `account` had not been already granted `role`, emits a {RoleGranted}
580      * event. Note that unlike {grantRole}, this function doesn't perform any
581      * checks on the calling account.
582      *
583      * [WARNING]
584      * ====
585      * This function should only be called from the constructor when setting
586      * up the initial roles for the system.
587      *
588      * Using this function in any other way is effectively circumventing the admin
589      * system imposed by {AccessControl}.
590      * ====
591      */
592     function _setupRole(bytes32 role, address account) internal virtual {
593         _grantRole(role, account);
594     }
595 
596     /**
597      * @dev Sets `adminRole` as ``role``'s admin role.
598      *
599      * Emits a {RoleAdminChanged} event.
600      */
601     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
602         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
603         _roles[role].adminRole = adminRole;
604     }
605 
606     function _grantRole(bytes32 role, address account) private {
607         if (_roles[role].members.add(account)) {
608             emit RoleGranted(role, account, _msgSender());
609         }
610     }
611 
612     function _revokeRole(bytes32 role, address account) private {
613         if (_roles[role].members.remove(account)) {
614             emit RoleRevoked(role, account, _msgSender());
615         }
616     }
617 }
618 
619 // 
620 /**
621  * @dev Interface of the ERC20 standard as defined in the EIP.
622  */
623 interface IERC20 {
624     /**
625      * @dev Returns the amount of tokens in existence.
626      */
627     function totalSupply() external view returns (uint256);
628 
629     /**
630      * @dev Returns the amount of tokens owned by `account`.
631      */
632     function balanceOf(address account) external view returns (uint256);
633 
634     /**
635      * @dev Moves `amount` tokens from the caller's account to `recipient`.
636      *
637      * Returns a boolean value indicating whether the operation succeeded.
638      *
639      * Emits a {Transfer} event.
640      */
641     function transfer(address recipient, uint256 amount) external returns (bool);
642 
643     /**
644      * @dev Returns the remaining number of tokens that `spender` will be
645      * allowed to spend on behalf of `owner` through {transferFrom}. This is
646      * zero by default.
647      *
648      * This value changes when {approve} or {transferFrom} are called.
649      */
650     function allowance(address owner, address spender) external view returns (uint256);
651 
652     /**
653      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
654      *
655      * Returns a boolean value indicating whether the operation succeeded.
656      *
657      * IMPORTANT: Beware that changing an allowance with this method brings the risk
658      * that someone may use both the old and the new allowance by unfortunate
659      * transaction ordering. One possible solution to mitigate this race
660      * condition is to first reduce the spender's allowance to 0 and set the
661      * desired value afterwards:
662      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
663      *
664      * Emits an {Approval} event.
665      */
666     function approve(address spender, uint256 amount) external returns (bool);
667 
668     /**
669      * @dev Moves `amount` tokens from `sender` to `recipient` using the
670      * allowance mechanism. `amount` is then deducted from the caller's
671      * allowance.
672      *
673      * Returns a boolean value indicating whether the operation succeeded.
674      *
675      * Emits a {Transfer} event.
676      */
677     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
678 
679     /**
680      * @dev Emitted when `value` tokens are moved from one account (`from`) to
681      * another (`to`).
682      *
683      * Note that `value` may be zero.
684      */
685     event Transfer(address indexed from, address indexed to, uint256 value);
686 
687     /**
688      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
689      * a call to {approve}. `value` is the new allowance.
690      */
691     event Approval(address indexed owner, address indexed spender, uint256 value);
692 }
693 
694 // 
695 /**
696  * @dev Wrappers over Solidity's arithmetic operations with added overflow
697  * checks.
698  *
699  * Arithmetic operations in Solidity wrap on overflow. This can easily result
700  * in bugs, because programmers usually assume that an overflow raises an
701  * error, which is the standard behavior in high level programming languages.
702  * `SafeMath` restores this intuition by reverting the transaction when an
703  * operation overflows.
704  *
705  * Using this library instead of the unchecked operations eliminates an entire
706  * class of bugs, so it's recommended to use it always.
707  */
708 library SafeMath {
709     /**
710      * @dev Returns the addition of two unsigned integers, reverting on
711      * overflow.
712      *
713      * Counterpart to Solidity's `+` operator.
714      *
715      * Requirements:
716      *
717      * - Addition cannot overflow.
718      */
719     function add(uint256 a, uint256 b) internal pure returns (uint256) {
720         uint256 c = a + b;
721         require(c >= a, "SafeMath: addition overflow");
722 
723         return c;
724     }
725 
726     /**
727      * @dev Returns the subtraction of two unsigned integers, reverting on
728      * overflow (when the result is negative).
729      *
730      * Counterpart to Solidity's `-` operator.
731      *
732      * Requirements:
733      *
734      * - Subtraction cannot overflow.
735      */
736     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
737         return sub(a, b, "SafeMath: subtraction overflow");
738     }
739 
740     /**
741      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
742      * overflow (when the result is negative).
743      *
744      * Counterpart to Solidity's `-` operator.
745      *
746      * Requirements:
747      *
748      * - Subtraction cannot overflow.
749      */
750     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
751         require(b <= a, errorMessage);
752         uint256 c = a - b;
753 
754         return c;
755     }
756 
757     /**
758      * @dev Returns the multiplication of two unsigned integers, reverting on
759      * overflow.
760      *
761      * Counterpart to Solidity's `*` operator.
762      *
763      * Requirements:
764      *
765      * - Multiplication cannot overflow.
766      */
767     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
768         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
769         // benefit is lost if 'b' is also tested.
770         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
771         if (a == 0) {
772             return 0;
773         }
774 
775         uint256 c = a * b;
776         require(c / a == b, "SafeMath: multiplication overflow");
777 
778         return c;
779     }
780 
781     /**
782      * @dev Returns the integer division of two unsigned integers. Reverts on
783      * division by zero. The result is rounded towards zero.
784      *
785      * Counterpart to Solidity's `/` operator. Note: this function uses a
786      * `revert` opcode (which leaves remaining gas untouched) while Solidity
787      * uses an invalid opcode to revert (consuming all remaining gas).
788      *
789      * Requirements:
790      *
791      * - The divisor cannot be zero.
792      */
793     function div(uint256 a, uint256 b) internal pure returns (uint256) {
794         return div(a, b, "SafeMath: division by zero");
795     }
796 
797     /**
798      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
809     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
810         require(b > 0, errorMessage);
811         uint256 c = a / b;
812         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
813 
814         return c;
815     }
816 
817     /**
818      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
819      * Reverts when dividing by zero.
820      *
821      * Counterpart to Solidity's `%` operator. This function uses a `revert`
822      * opcode (which leaves remaining gas untouched) while Solidity uses an
823      * invalid opcode to revert (consuming all remaining gas).
824      *
825      * Requirements:
826      *
827      * - The divisor cannot be zero.
828      */
829     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
830         return mod(a, b, "SafeMath: modulo by zero");
831     }
832 
833     /**
834      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
835      * Reverts with custom message when dividing by zero.
836      *
837      * Counterpart to Solidity's `%` operator. This function uses a `revert`
838      * opcode (which leaves remaining gas untouched) while Solidity uses an
839      * invalid opcode to revert (consuming all remaining gas).
840      *
841      * Requirements:
842      *
843      * - The divisor cannot be zero.
844      */
845     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
846         require(b != 0, errorMessage);
847         return a % b;
848     }
849 }
850 
851 // 
852 /**
853  * @dev Implementation of the {IERC20} interface.
854  *
855  * This implementation is agnostic to the way tokens are created. This means
856  * that a supply mechanism has to be added in a derived contract using {_mint}.
857  * For a generic mechanism see {ERC20PresetMinterPauser}.
858  *
859  * TIP: For a detailed writeup see our guide
860  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
861  * to implement supply mechanisms].
862  *
863  * We have followed general OpenZeppelin guidelines: functions revert instead
864  * of returning `false` on failure. This behavior is nonetheless conventional
865  * and does not conflict with the expectations of ERC20 applications.
866  *
867  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
868  * This allows applications to reconstruct the allowance for all accounts just
869  * by listening to said events. Other implementations of the EIP may not emit
870  * these events, as it isn't required by the specification.
871  *
872  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
873  * functions have been added to mitigate the well-known issues around setting
874  * allowances. See {IERC20-approve}.
875  */
876 contract ERC20 is Context, IERC20 {
877     using SafeMath for uint256;
878     using Address for address;
879 
880     mapping (address => uint256) private _balances;
881 
882     mapping (address => mapping (address => uint256)) private _allowances;
883 
884     uint256 private _totalSupply;
885 
886     string private _name;
887     string private _symbol;
888     uint8 private _decimals;
889 
890     /**
891      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
892      * a default value of 18.
893      *
894      * To select a different value for {decimals}, use {_setupDecimals}.
895      *
896      * All three of these values are immutable: they can only be set once during
897      * construction.
898      */
899     constructor (string memory name, string memory symbol) public {
900         _name = name;
901         _symbol = symbol;
902         _decimals = 18;
903     }
904 
905     /**
906      * @dev Returns the name of the token.
907      */
908     function name() public view returns (string memory) {
909         return _name;
910     }
911 
912     /**
913      * @dev Returns the symbol of the token, usually a shorter version of the
914      * name.
915      */
916     function symbol() public view returns (string memory) {
917         return _symbol;
918     }
919 
920     /**
921      * @dev Returns the number of decimals used to get its user representation.
922      * For example, if `decimals` equals `2`, a balance of `505` tokens should
923      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
924      *
925      * Tokens usually opt for a value of 18, imitating the relationship between
926      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
927      * called.
928      *
929      * NOTE: This information is only used for _display_ purposes: it in
930      * no way affects any of the arithmetic of the contract, including
931      * {IERC20-balanceOf} and {IERC20-transfer}.
932      */
933     function decimals() public view returns (uint8) {
934         return _decimals;
935     }
936 
937     /**
938      * @dev See {IERC20-totalSupply}.
939      */
940     function totalSupply() public view override returns (uint256) {
941         return _totalSupply;
942     }
943 
944     /**
945      * @dev See {IERC20-balanceOf}.
946      */
947     function balanceOf(address account) public view override returns (uint256) {
948         return _balances[account];
949     }
950 
951     /**
952      * @dev See {IERC20-transfer}.
953      *
954      * Requirements:
955      *
956      * - `recipient` cannot be the zero address.
957      * - the caller must have a balance of at least `amount`.
958      */
959     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
960         _transfer(_msgSender(), recipient, amount);
961         return true;
962     }
963 
964     /**
965      * @dev See {IERC20-allowance}.
966      */
967     function allowance(address owner, address spender) public view virtual override returns (uint256) {
968         return _allowances[owner][spender];
969     }
970 
971     /**
972      * @dev See {IERC20-approve}.
973      *
974      * Requirements:
975      *
976      * - `spender` cannot be the zero address.
977      */
978     function approve(address spender, uint256 amount) public virtual override returns (bool) {
979         _approve(_msgSender(), spender, amount);
980         return true;
981     }
982 
983     /**
984      * @dev See {IERC20-transferFrom}.
985      *
986      * Emits an {Approval} event indicating the updated allowance. This is not
987      * required by the EIP. See the note at the beginning of {ERC20};
988      *
989      * Requirements:
990      * - `sender` and `recipient` cannot be the zero address.
991      * - `sender` must have a balance of at least `amount`.
992      * - the caller must have allowance for ``sender``'s tokens of at least
993      * `amount`.
994      */
995     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
996         _transfer(sender, recipient, amount);
997         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
998         return true;
999     }
1000 
1001     /**
1002      * @dev Atomically increases the allowance granted to `spender` by the caller.
1003      *
1004      * This is an alternative to {approve} that can be used as a mitigation for
1005      * problems described in {IERC20-approve}.
1006      *
1007      * Emits an {Approval} event indicating the updated allowance.
1008      *
1009      * Requirements:
1010      *
1011      * - `spender` cannot be the zero address.
1012      */
1013     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1014         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1015         return true;
1016     }
1017 
1018     /**
1019      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1020      *
1021      * This is an alternative to {approve} that can be used as a mitigation for
1022      * problems described in {IERC20-approve}.
1023      *
1024      * Emits an {Approval} event indicating the updated allowance.
1025      *
1026      * Requirements:
1027      *
1028      * - `spender` cannot be the zero address.
1029      * - `spender` must have allowance for the caller of at least
1030      * `subtractedValue`.
1031      */
1032     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1033         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1034         return true;
1035     }
1036 
1037     /**
1038      * @dev Moves tokens `amount` from `sender` to `recipient`.
1039      *
1040      * This is internal function is equivalent to {transfer}, and can be used to
1041      * e.g. implement automatic token fees, slashing mechanisms, etc.
1042      *
1043      * Emits a {Transfer} event.
1044      *
1045      * Requirements:
1046      *
1047      * - `sender` cannot be the zero address.
1048      * - `recipient` cannot be the zero address.
1049      * - `sender` must have a balance of at least `amount`.
1050      */
1051     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1052         require(sender != address(0), "ERC20: transfer from the zero address");
1053         require(recipient != address(0), "ERC20: transfer to the zero address");
1054 
1055         _beforeTokenTransfer(sender, recipient, amount);
1056 
1057         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1058         _balances[recipient] = _balances[recipient].add(amount);
1059         emit Transfer(sender, recipient, amount);
1060     }
1061 
1062     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1063      * the total supply.
1064      *
1065      * Emits a {Transfer} event with `from` set to the zero address.
1066      *
1067      * Requirements
1068      *
1069      * - `to` cannot be the zero address.
1070      */
1071     function _mint(address account, uint256 amount) internal virtual {
1072         require(account != address(0), "ERC20: mint to the zero address");
1073 
1074         _beforeTokenTransfer(address(0), account, amount);
1075 
1076         _totalSupply = _totalSupply.add(amount);
1077         _balances[account] = _balances[account].add(amount);
1078         emit Transfer(address(0), account, amount);
1079     }
1080 
1081     /**
1082      * @dev Destroys `amount` tokens from `account`, reducing the
1083      * total supply.
1084      *
1085      * Emits a {Transfer} event with `to` set to the zero address.
1086      *
1087      * Requirements
1088      *
1089      * - `account` cannot be the zero address.
1090      * - `account` must have at least `amount` tokens.
1091      */
1092     function _burn(address account, uint256 amount) internal virtual {
1093         require(account != address(0), "ERC20: burn from the zero address");
1094 
1095         _beforeTokenTransfer(account, address(0), amount);
1096 
1097         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1098         _totalSupply = _totalSupply.sub(amount);
1099         emit Transfer(account, address(0), amount);
1100     }
1101 
1102     /**
1103      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1104      *
1105      * This internal function is equivalent to `approve`, and can be used to
1106      * e.g. set automatic allowances for certain subsystems, etc.
1107      *
1108      * Emits an {Approval} event.
1109      *
1110      * Requirements:
1111      *
1112      * - `owner` cannot be the zero address.
1113      * - `spender` cannot be the zero address.
1114      */
1115     function _approve(address owner, address spender, uint256 amount) internal virtual {
1116         require(owner != address(0), "ERC20: approve from the zero address");
1117         require(spender != address(0), "ERC20: approve to the zero address");
1118 
1119         _allowances[owner][spender] = amount;
1120         emit Approval(owner, spender, amount);
1121     }
1122 
1123     /**
1124      * @dev Sets {decimals} to a value other than the default one of 18.
1125      *
1126      * WARNING: This function should only be called from the constructor. Most
1127      * applications that interact with token contracts will not expect
1128      * {decimals} to ever change, and may work incorrectly if it does.
1129      */
1130     function _setupDecimals(uint8 decimals_) internal {
1131         _decimals = decimals_;
1132     }
1133 
1134     /**
1135      * @dev Hook that is called before any transfer of tokens. This includes
1136      * minting and burning.
1137      *
1138      * Calling conditions:
1139      *
1140      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1141      * will be to transferred to `to`.
1142      * - when `from` is zero, `amount` tokens will be minted for `to`.
1143      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1144      * - `from` and `to` are never both zero.
1145      *
1146      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1147      */
1148     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1149 }
1150 
1151 // 
1152 /**
1153  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1154  * tokens and those that they have an allowance for, in a way that can be
1155  * recognized off-chain (via event analysis).
1156  */
1157 abstract contract ERC20Burnable is Context, ERC20 {
1158     /**
1159      * @dev Destroys `amount` tokens from the caller.
1160      *
1161      * See {ERC20-_burn}.
1162      */
1163     function burn(uint256 amount) public virtual {
1164         _burn(_msgSender(), amount);
1165     }
1166 
1167     /**
1168      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1169      * allowance.
1170      *
1171      * See {ERC20-_burn} and {ERC20-allowance}.
1172      *
1173      * Requirements:
1174      *
1175      * - the caller must have allowance for ``accounts``'s tokens of at least
1176      * `amount`.
1177      */
1178     function burnFrom(address account, uint256 amount) public virtual {
1179         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1180 
1181         _approve(account, _msgSender(), decreasedAllowance);
1182         _burn(account, amount);
1183     }
1184 }
1185 
1186 // 
1187 /**
1188  * @dev Contract module which allows children to implement an emergency stop
1189  * mechanism that can be triggered by an authorized account.
1190  *
1191  * This module is used through inheritance. It will make available the
1192  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1193  * the functions of your contract. Note that they will not be pausable by
1194  * simply including this module, only once the modifiers are put in place.
1195  */
1196 contract Pausable is Context {
1197     /**
1198      * @dev Emitted when the pause is triggered by `account`.
1199      */
1200     event Paused(address account);
1201 
1202     /**
1203      * @dev Emitted when the pause is lifted by `account`.
1204      */
1205     event Unpaused(address account);
1206 
1207     bool private _paused;
1208 
1209     /**
1210      * @dev Initializes the contract in unpaused state.
1211      */
1212     constructor () internal {
1213         _paused = false;
1214     }
1215 
1216     /**
1217      * @dev Returns true if the contract is paused, and false otherwise.
1218      */
1219     function paused() public view returns (bool) {
1220         return _paused;
1221     }
1222 
1223     /**
1224      * @dev Modifier to make a function callable only when the contract is not paused.
1225      *
1226      * Requirements:
1227      *
1228      * - The contract must not be paused.
1229      */
1230     modifier whenNotPaused() {
1231         require(!_paused, "Pausable: paused");
1232         _;
1233     }
1234 
1235     /**
1236      * @dev Modifier to make a function callable only when the contract is paused.
1237      *
1238      * Requirements:
1239      *
1240      * - The contract must be paused.
1241      */
1242     modifier whenPaused() {
1243         require(_paused, "Pausable: not paused");
1244         _;
1245     }
1246 
1247     /**
1248      * @dev Triggers stopped state.
1249      *
1250      * Requirements:
1251      *
1252      * - The contract must not be paused.
1253      */
1254     function _pause() internal virtual whenNotPaused {
1255         _paused = true;
1256         emit Paused(_msgSender());
1257     }
1258 
1259     /**
1260      * @dev Returns to normal state.
1261      *
1262      * Requirements:
1263      *
1264      * - The contract must be paused.
1265      */
1266     function _unpause() internal virtual whenPaused {
1267         _paused = false;
1268         emit Unpaused(_msgSender());
1269     }
1270 }
1271 
1272 // 
1273 /**
1274  * @dev ERC20 token with pausable token transfers, minting and burning.
1275  *
1276  * Useful for scenarios such as preventing trades until the end of an evaluation
1277  * period, or having an emergency switch for freezing all token transfers in the
1278  * event of a large bug.
1279  */
1280 abstract contract ERC20Pausable is ERC20, Pausable {
1281     /**
1282      * @dev See {ERC20-_beforeTokenTransfer}.
1283      *
1284      * Requirements:
1285      *
1286      * - the contract must not be paused.
1287      */
1288     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1289         super._beforeTokenTransfer(from, to, amount);
1290 
1291         require(!paused(), "ERC20Pausable: token transfer while paused");
1292     }
1293 }
1294 
1295 // 
1296 /**
1297  * @dev {ERC20} token, including:
1298  *
1299  *  - ability for holders to burn (destroy) their tokens
1300  *  - a minter role that allows for token minting (creation)
1301  *  - a pauser role that allows to stop all token transfers
1302  *
1303  * This contract uses {AccessControl} to lock permissioned functions using the
1304  * different roles - head to its documentation for details.
1305  *
1306  * The account that deploys the contract will be granted the minter and pauser
1307  * roles, as well as the default admin role, which will let it grant both minter
1308  * and pauser roles to other accounts.
1309  */
1310 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1311     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1312     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1313 
1314     /**
1315      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1316      * account that deploys the contract.
1317      *
1318      * See {ERC20-constructor}.
1319      */
1320     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1321         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1322 
1323         _setupRole(MINTER_ROLE, _msgSender());
1324         _setupRole(PAUSER_ROLE, _msgSender());
1325     }
1326 
1327     /**
1328      * @dev Creates `amount` new tokens for `to`.
1329      *
1330      * See {ERC20-_mint}.
1331      *
1332      * Requirements:
1333      *
1334      * - the caller must have the `MINTER_ROLE`.
1335      */
1336     function mint(address to, uint256 amount) public virtual {
1337         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1338         _mint(to, amount);
1339     }
1340 
1341     /**
1342      * @dev Pauses all token transfers.
1343      *
1344      * See {ERC20Pausable} and {Pausable-_pause}.
1345      *
1346      * Requirements:
1347      *
1348      * - the caller must have the `PAUSER_ROLE`.
1349      */
1350     function pause() public virtual {
1351         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1352         _pause();
1353     }
1354 
1355     /**
1356      * @dev Unpauses all token transfers.
1357      *
1358      * See {ERC20Pausable} and {Pausable-_unpause}.
1359      *
1360      * Requirements:
1361      *
1362      * - the caller must have the `PAUSER_ROLE`.
1363      */
1364     function unpause() public virtual {
1365         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1366         _unpause();
1367     }
1368 
1369     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1370         super._beforeTokenTransfer(from, to, amount);
1371     }
1372 }
1373 
1374 // 
1375 contract Grow is ERC20PresetMinterPauser {
1376     constructor(
1377         string memory _name,
1378         string memory _symbol,
1379         uint256 _initialSupply
1380     ) public ERC20PresetMinterPauser(_name, _symbol) {
1381         _mint(msg.sender, _initialSupply);
1382     }
1383 }