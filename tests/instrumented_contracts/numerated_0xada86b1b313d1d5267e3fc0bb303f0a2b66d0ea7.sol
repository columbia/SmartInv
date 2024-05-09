1 pragma solidity ^0.6.2;
2 
3 /**
4  * @dev Library for managing
5  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
6  * types.
7  *
8  * Sets have the following properties:
9  *
10  * - Elements are added, removed, and checked for existence in constant time
11  * (O(1)).
12  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
13  *
14  * ```
15  * contract Example {
16  *     // Add the library methods
17  *     using EnumerableSet for EnumerableSet.AddressSet;
18  *
19  *     // Declare a set state variable
20  *     EnumerableSet.AddressSet private mySet;
21  * }
22  * ```
23  *
24  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
25  * (`UintSet`) are supported.
26  */
27 library EnumerableSet {
28     // To implement this library for multiple types with as little code
29     // repetition as possible, we write it in terms of a generic Set type with
30     // bytes32 values.
31     // The Set implementation uses private functions, and user-facing
32     // implementations (such as AddressSet) are just wrappers around the
33     // underlying Set.
34     // This means that we can only create new EnumerableSets for types that fit
35     // in bytes32.
36 
37     struct Set {
38         // Storage of set values
39         bytes32[] _values;
40 
41         // Position of the value in the `values` array, plus 1 because index 0
42         // means a value is not in the set.
43         mapping (bytes32 => uint256) _indexes;
44     }
45 
46     /**
47      * @dev Add a value to a set. O(1).
48      *
49      * Returns true if the value was added to the set, that is if it was not
50      * already present.
51      */
52     function _add(Set storage set, bytes32 value) private returns (bool) {
53         if (!_contains(set, value)) {
54             set._values.push(value);
55             // The value is stored at length-1, but we add 1 to all indexes
56             // and use 0 as a sentinel value
57             set._indexes[value] = set._values.length;
58             return true;
59         } else {
60             return false;
61         }
62     }
63 
64     /**
65      * @dev Removes a value from a set. O(1).
66      *
67      * Returns true if the value was removed from the set, that is if it was
68      * present.
69      */
70     function _remove(Set storage set, bytes32 value) private returns (bool) {
71         // We read and store the value's index to prevent multiple reads from the same storage slot
72         uint256 valueIndex = set._indexes[value];
73 
74         if (valueIndex != 0) { // Equivalent to contains(set, value)
75             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
76             // the array, and then remove the last element (sometimes called as 'swap and pop').
77             // This modifies the order of the array, as noted in {at}.
78 
79             uint256 toDeleteIndex = valueIndex - 1;
80             uint256 lastIndex = set._values.length - 1;
81 
82             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
83             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
84 
85             bytes32 lastvalue = set._values[lastIndex];
86 
87             // Move the last value to the index where the value to delete is
88             set._values[toDeleteIndex] = lastvalue;
89             // Update the index for the moved value
90             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
91 
92             // Delete the slot where the moved value was stored
93             set._values.pop();
94 
95             // Delete the index for the deleted slot
96             delete set._indexes[value];
97 
98             return true;
99         } else {
100             return false;
101         }
102     }
103 
104     /**
105      * @dev Returns true if the value is in the set. O(1).
106      */
107     function _contains(Set storage set, bytes32 value) private view returns (bool) {
108         return set._indexes[value] != 0;
109     }
110 
111     /**
112      * @dev Returns the number of values on the set. O(1).
113      */
114     function _length(Set storage set) private view returns (uint256) {
115         return set._values.length;
116     }
117 
118    /**
119     * @dev Returns the value stored at position `index` in the set. O(1).
120     *
121     * Note that there are no guarantees on the ordering of values inside the
122     * array, and it may change when more values are added or removed.
123     *
124     * Requirements:
125     *
126     * - `index` must be strictly less than {length}.
127     */
128     function _at(Set storage set, uint256 index) private view returns (bytes32) {
129         require(set._values.length > index, "EnumerableSet: index out of bounds");
130         return set._values[index];
131     }
132 
133     // AddressSet
134 
135     struct AddressSet {
136         Set _inner;
137     }
138 
139     /**
140      * @dev Add a value to a set. O(1).
141      *
142      * Returns true if the value was added to the set, that is if it was not
143      * already present.
144      */
145     function add(AddressSet storage set, address value) internal returns (bool) {
146         return _add(set._inner, bytes32(uint256(value)));
147     }
148 
149     /**
150      * @dev Removes a value from a set. O(1).
151      *
152      * Returns true if the value was removed from the set, that is if it was
153      * present.
154      */
155     function remove(AddressSet storage set, address value) internal returns (bool) {
156         return _remove(set._inner, bytes32(uint256(value)));
157     }
158 
159     /**
160      * @dev Returns true if the value is in the set. O(1).
161      */
162     function contains(AddressSet storage set, address value) internal view returns (bool) {
163         return _contains(set._inner, bytes32(uint256(value)));
164     }
165 
166     /**
167      * @dev Returns the number of values in the set. O(1).
168      */
169     function length(AddressSet storage set) internal view returns (uint256) {
170         return _length(set._inner);
171     }
172 
173    /**
174     * @dev Returns the value stored at position `index` in the set. O(1).
175     *
176     * Note that there are no guarantees on the ordering of values inside the
177     * array, and it may change when more values are added or removed.
178     *
179     * Requirements:
180     *
181     * - `index` must be strictly less than {length}.
182     */
183     function at(AddressSet storage set, uint256 index) internal view returns (address) {
184         return address(uint256(_at(set._inner, index)));
185     }
186 
187 
188     // UintSet
189 
190     struct UintSet {
191         Set _inner;
192     }
193 
194     /**
195      * @dev Add a value to a set. O(1).
196      *
197      * Returns true if the value was added to the set, that is if it was not
198      * already present.
199      */
200     function add(UintSet storage set, uint256 value) internal returns (bool) {
201         return _add(set._inner, bytes32(value));
202     }
203 
204     /**
205      * @dev Removes a value from a set. O(1).
206      *
207      * Returns true if the value was removed from the set, that is if it was
208      * present.
209      */
210     function remove(UintSet storage set, uint256 value) internal returns (bool) {
211         return _remove(set._inner, bytes32(value));
212     }
213 
214     /**
215      * @dev Returns true if the value is in the set. O(1).
216      */
217     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
218         return _contains(set._inner, bytes32(value));
219     }
220 
221     /**
222      * @dev Returns the number of values on the set. O(1).
223      */
224     function length(UintSet storage set) internal view returns (uint256) {
225         return _length(set._inner);
226     }
227 
228    /**
229     * @dev Returns the value stored at position `index` in the set. O(1).
230     *
231     * Note that there are no guarantees on the ordering of values inside the
232     * array, and it may change when more values are added or removed.
233     *
234     * Requirements:
235     *
236     * - `index` must be strictly less than {length}.
237     */
238     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
239         return uint256(_at(set._inner, index));
240     }
241 }
242 
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies in extcodesize, which returns 0 for contracts in
267         // construction, since the code is only stored at the end of the
268         // constructor execution.
269 
270         uint256 size;
271         // solhint-disable-next-line no-inline-assembly
272         assembly { size := extcodesize(account) }
273         return size > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
296         (bool success, ) = recipient.call{ value: amount }("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain`call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319       return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         return _functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         return _functionCallWithValue(target, data, value, errorMessage);
356     }
357 
358     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
359         require(isContract(target), "Address: call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 // solhint-disable-next-line no-inline-assembly
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 
382 
383 /*
384  * @dev Provides information about the current execution context, including the
385  * sender of the transaction and its data. While these are generally available
386  * via msg.sender and msg.data, they should not be accessed in such a direct
387  * manner, since when dealing with GSN meta-transactions the account sending and
388  * paying for execution may not be the actual sender (as far as an application
389  * is concerned).
390  *
391  * This contract is only required for intermediate, library-like contracts.
392  */
393 abstract contract Context {
394     function _msgSender() internal view virtual returns (address payable) {
395         return msg.sender;
396     }
397 
398     function _msgData() internal view virtual returns (bytes memory) {
399         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
400         return msg.data;
401     }
402 }
403 
404 
405 
406 
407 /**
408  * @dev Contract module that allows children to implement role-based access
409  * control mechanisms.
410  *
411  * Roles are referred to by their `bytes32` identifier. These should be exposed
412  * in the external API and be unique. The best way to achieve this is by
413  * using `public constant` hash digests:
414  *
415  * ```
416  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
417  * ```
418  *
419  * Roles can be used to represent a set of permissions. To restrict access to a
420  * function call, use {hasRole}:
421  *
422  * ```
423  * function foo() public {
424  *     require(hasRole(MY_ROLE, msg.sender));
425  *     ...
426  * }
427  * ```
428  *
429  * Roles can be granted and revoked dynamically via the {grantRole} and
430  * {revokeRole} functions. Each role has an associated admin role, and only
431  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
432  *
433  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
434  * that only accounts with this role will be able to grant or revoke other
435  * roles. More complex role relationships can be created by using
436  * {_setRoleAdmin}.
437  *
438  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
439  * grant and revoke this role. Extra precautions should be taken to secure
440  * accounts that have been granted it.
441  */
442 abstract contract AccessControl is Context {
443     using EnumerableSet for EnumerableSet.AddressSet;
444     using Address for address;
445 
446     struct RoleData {
447         EnumerableSet.AddressSet members;
448         bytes32 adminRole;
449     }
450 
451     mapping (bytes32 => RoleData) private _roles;
452 
453     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
454 
455     /**
456      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
457      *
458      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
459      * {RoleAdminChanged} not being emitted signaling this.
460      *
461      * _Available since v3.1._
462      */
463     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
464 
465     /**
466      * @dev Emitted when `account` is granted `role`.
467      *
468      * `sender` is the account that originated the contract call, an admin role
469      * bearer except when using {_setupRole}.
470      */
471     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
472 
473     /**
474      * @dev Emitted when `account` is revoked `role`.
475      *
476      * `sender` is the account that originated the contract call:
477      *   - if using `revokeRole`, it is the admin role bearer
478      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
479      */
480     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
481 
482     /**
483      * @dev Returns `true` if `account` has been granted `role`.
484      */
485     function hasRole(bytes32 role, address account) public view returns (bool) {
486         return _roles[role].members.contains(account);
487     }
488 
489     /**
490      * @dev Returns the number of accounts that have `role`. Can be used
491      * together with {getRoleMember} to enumerate all bearers of a role.
492      */
493     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
494         return _roles[role].members.length();
495     }
496 
497     /**
498      * @dev Returns one of the accounts that have `role`. `index` must be a
499      * value between 0 and {getRoleMemberCount}, non-inclusive.
500      *
501      * Role bearers are not sorted in any particular way, and their ordering may
502      * change at any point.
503      *
504      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
505      * you perform all queries on the same block. See the following
506      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
507      * for more information.
508      */
509     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
510         return _roles[role].members.at(index);
511     }
512 
513     /**
514      * @dev Returns the admin role that controls `role`. See {grantRole} and
515      * {revokeRole}.
516      *
517      * To change a role's admin, use {_setRoleAdmin}.
518      */
519     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
520         return _roles[role].adminRole;
521     }
522 
523     /**
524      * @dev Grants `role` to `account`.
525      *
526      * If `account` had not been already granted `role`, emits a {RoleGranted}
527      * event.
528      *
529      * Requirements:
530      *
531      * - the caller must have ``role``'s admin role.
532      */
533     function grantRole(bytes32 role, address account) public virtual {
534         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
535 
536         _grantRole(role, account);
537     }
538 
539     /**
540      * @dev Revokes `role` from `account`.
541      *
542      * If `account` had been granted `role`, emits a {RoleRevoked} event.
543      *
544      * Requirements:
545      *
546      * - the caller must have ``role``'s admin role.
547      */
548     function revokeRole(bytes32 role, address account) public virtual {
549         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
550 
551         _revokeRole(role, account);
552     }
553 
554     /**
555      * @dev Revokes `role` from the calling account.
556      *
557      * Roles are often managed via {grantRole} and {revokeRole}: this function's
558      * purpose is to provide a mechanism for accounts to lose their privileges
559      * if they are compromised (such as when a trusted device is misplaced).
560      *
561      * If the calling account had been granted `role`, emits a {RoleRevoked}
562      * event.
563      *
564      * Requirements:
565      *
566      * - the caller must be `account`.
567      */
568     function renounceRole(bytes32 role, address account) public virtual {
569         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
570 
571         _revokeRole(role, account);
572     }
573 
574     /**
575      * @dev Grants `role` to `account`.
576      *
577      * If `account` had not been already granted `role`, emits a {RoleGranted}
578      * event. Note that unlike {grantRole}, this function doesn't perform any
579      * checks on the calling account.
580      *
581      * [WARNING]
582      * ====
583      * This function should only be called from the constructor when setting
584      * up the initial roles for the system.
585      *
586      * Using this function in any other way is effectively circumventing the admin
587      * system imposed by {AccessControl}.
588      * ====
589      */
590     function _setupRole(bytes32 role, address account) internal virtual {
591         _grantRole(role, account);
592     }
593 
594     /**
595      * @dev Sets `adminRole` as ``role``'s admin role.
596      *
597      * Emits a {RoleAdminChanged} event.
598      */
599     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
600         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
601         _roles[role].adminRole = adminRole;
602     }
603 
604     function _grantRole(bytes32 role, address account) private {
605         if (_roles[role].members.add(account)) {
606             emit RoleGranted(role, account, _msgSender());
607         }
608     }
609 
610     function _revokeRole(bytes32 role, address account) private {
611         if (_roles[role].members.remove(account)) {
612             emit RoleRevoked(role, account, _msgSender());
613         }
614     }
615 }
616 
617 interface IOldCOVToken {
618 
619   function lock(address addr, uint periodInDays) external;
620 
621 }
622 
623 interface IERC20Cutted {
624 
625     function balanceOf(address who) external view returns (uint256);
626 
627     // Some old tokens implemented without retrun parameter (It happanes before ERC20 chnaged as standart)
628     function transfer(address to, uint256 value) external;
629 
630 }
631 
632 /**
633  * @dev Interface of the ERC20 standard as defined in the EIP.
634  */
635 interface IERC20 {
636     /**
637      * @dev Returns the amount of tokens in existence.
638      */
639     function totalSupply() external view returns (uint256);
640 
641     /**
642      * @dev Returns the amount of tokens owned by `account`.
643      */
644     function balanceOf(address account) external view returns (uint256);
645 
646     /**
647      * @dev Moves `amount` tokens from the caller's account to `recipient`.
648      *
649      * Returns a boolean value indicating whether the operation succeeded.
650      *
651      * Emits a {Transfer} event.
652      */
653     function transfer(address recipient, uint256 amount) external returns (bool);
654 
655     /**
656      * @dev Returns the remaining number of tokens that `spender` will be
657      * allowed to spend on behalf of `owner` through {transferFrom}. This is
658      * zero by default.
659      *
660      * This value changes when {approve} or {transferFrom} are called.
661      */
662     function allowance(address owner, address spender) external view returns (uint256);
663 
664     /**
665      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
666      *
667      * Returns a boolean value indicating whether the operation succeeded.
668      *
669      * IMPORTANT: Beware that changing an allowance with this method brings the risk
670      * that someone may use both the old and the new allowance by unfortunate
671      * transaction ordering. One possible solution to mitigate this race
672      * condition is to first reduce the spender's allowance to 0 and set the
673      * desired value afterwards:
674      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
675      *
676      * Emits an {Approval} event.
677      */
678     function approve(address spender, uint256 amount) external returns (bool);
679 
680     /**
681      * @dev Moves `amount` tokens from `sender` to `recipient` using the
682      * allowance mechanism. `amount` is then deducted from the caller's
683      * allowance.
684      *
685      * Returns a boolean value indicating whether the operation succeeded.
686      *
687      * Emits a {Transfer} event.
688      */
689     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
690 
691     /**
692      * @dev Emitted when `value` tokens are moved from one account (`from`) to
693      * another (`to`).
694      *
695      * Note that `value` may be zero.
696      */
697     event Transfer(address indexed from, address indexed to, uint256 value);
698 
699     /**
700      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
701      * a call to {approve}. `value` is the new allowance.
702      */
703     event Approval(address indexed owner, address indexed spender, uint256 value);
704 }
705 
706 /**
707  * @dev Wrappers over Solidity's arithmetic operations with added overflow
708  * checks.
709  *
710  * Arithmetic operations in Solidity wrap on overflow. This can easily result
711  * in bugs, because programmers usually assume that an overflow raises an
712  * error, which is the standard behavior in high level programming languages.
713  * `SafeMath` restores this intuition by reverting the transaction when an
714  * operation overflows.
715  *
716  * Using this library instead of the unchecked operations eliminates an entire
717  * class of bugs, so it's recommended to use it always.
718  */
719 library SafeMath {
720     /**
721      * @dev Returns the addition of two unsigned integers, reverting on
722      * overflow.
723      *
724      * Counterpart to Solidity's `+` operator.
725      *
726      * Requirements:
727      *
728      * - Addition cannot overflow.
729      */
730     function add(uint256 a, uint256 b) internal pure returns (uint256) {
731         uint256 c = a + b;
732         require(c >= a, "SafeMath: addition overflow");
733 
734         return c;
735     }
736 
737     /**
738      * @dev Returns the subtraction of two unsigned integers, reverting on
739      * overflow (when the result is negative).
740      *
741      * Counterpart to Solidity's `-` operator.
742      *
743      * Requirements:
744      *
745      * - Subtraction cannot overflow.
746      */
747     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
748         return sub(a, b, "SafeMath: subtraction overflow");
749     }
750 
751     /**
752      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
753      * overflow (when the result is negative).
754      *
755      * Counterpart to Solidity's `-` operator.
756      *
757      * Requirements:
758      *
759      * - Subtraction cannot overflow.
760      */
761     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
762         require(b <= a, errorMessage);
763         uint256 c = a - b;
764 
765         return c;
766     }
767 
768     /**
769      * @dev Returns the multiplication of two unsigned integers, reverting on
770      * overflow.
771      *
772      * Counterpart to Solidity's `*` operator.
773      *
774      * Requirements:
775      *
776      * - Multiplication cannot overflow.
777      */
778     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
779         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
780         // benefit is lost if 'b' is also tested.
781         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
782         if (a == 0) {
783             return 0;
784         }
785 
786         uint256 c = a * b;
787         require(c / a == b, "SafeMath: multiplication overflow");
788 
789         return c;
790     }
791 
792     /**
793      * @dev Returns the integer division of two unsigned integers. Reverts on
794      * division by zero. The result is rounded towards zero.
795      *
796      * Counterpart to Solidity's `/` operator. Note: this function uses a
797      * `revert` opcode (which leaves remaining gas untouched) while Solidity
798      * uses an invalid opcode to revert (consuming all remaining gas).
799      *
800      * Requirements:
801      *
802      * - The divisor cannot be zero.
803      */
804     function div(uint256 a, uint256 b) internal pure returns (uint256) {
805         return div(a, b, "SafeMath: division by zero");
806     }
807 
808     /**
809      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
810      * division by zero. The result is rounded towards zero.
811      *
812      * Counterpart to Solidity's `/` operator. Note: this function uses a
813      * `revert` opcode (which leaves remaining gas untouched) while Solidity
814      * uses an invalid opcode to revert (consuming all remaining gas).
815      *
816      * Requirements:
817      *
818      * - The divisor cannot be zero.
819      */
820     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
821         require(b > 0, errorMessage);
822         uint256 c = a / b;
823         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
824 
825         return c;
826     }
827 
828     /**
829      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
830      * Reverts when dividing by zero.
831      *
832      * Counterpart to Solidity's `%` operator. This function uses a `revert`
833      * opcode (which leaves remaining gas untouched) while Solidity uses an
834      * invalid opcode to revert (consuming all remaining gas).
835      *
836      * Requirements:
837      *
838      * - The divisor cannot be zero.
839      */
840     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
841         return mod(a, b, "SafeMath: modulo by zero");
842     }
843 
844     /**
845      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
846      * Reverts with custom message when dividing by zero.
847      *
848      * Counterpart to Solidity's `%` operator. This function uses a `revert`
849      * opcode (which leaves remaining gas untouched) while Solidity uses an
850      * invalid opcode to revert (consuming all remaining gas).
851      *
852      * Requirements:
853      *
854      * - The divisor cannot be zero.
855      */
856     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
857         require(b != 0, errorMessage);
858         return a % b;
859     }
860 }
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
891 
892     mapping (address => uint256) internal _balances;
893 
894     mapping (address => mapping (address => uint256)) private _allowances;
895 
896     uint256 internal _totalSupply;
897 
898     string private _name;
899     string private _symbol;
900     uint8 private _decimals;
901 
902     /**
903      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
904      * a default value of 18.
905      *
906      * To select a different value for {decimals}, use {_setupDecimals}.
907      *
908      * All three of these values are immutable: they can only be set once during
909      * construction.
910      */
911     constructor (string memory name, string memory symbol) public {
912         _name = name;
913         _symbol = symbol;
914         _decimals = 18;
915     }
916 
917     /**
918      * @dev Returns the name of the token.
919      */
920     function name() public view returns (string memory) {
921         return _name;
922     }
923 
924     /**
925      * @dev Returns the symbol of the token, usually a shorter version of the
926      * name.
927      */
928     function symbol() public view returns (string memory) {
929         return _symbol;
930     }
931 
932     /**
933      * @dev Returns the number of decimals used to get its user representation.
934      * For example, if `decimals` equals `2`, a balance of `505` tokens should
935      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
936      *
937      * Tokens usually opt for a value of 18, imitating the relationship between
938      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
939      * called.
940      *
941      * NOTE: This information is only used for _display_ purposes: it in
942      * no way affects any of the arithmetic of the contract, including
943      * {IERC20-balanceOf} and {IERC20-transfer}.
944      */
945     function decimals() public view returns (uint8) {
946         return _decimals;
947     }
948 
949     /**
950      * @dev See {IERC20-totalSupply}.
951      */
952     function totalSupply() public view override returns (uint256) {
953         return _totalSupply;
954     }
955 
956     /**
957      * @dev See {IERC20-balanceOf}.
958      */
959     function balanceOf(address account) public view override returns (uint256) {
960         return _balances[account];
961     }
962 
963     /**
964      * @dev See {IERC20-transfer}.
965      *
966      * Requirements:
967      *
968      * - `recipient` cannot be the zero address.
969      * - the caller must have a balance of at least `amount`.
970      */
971     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
972         _transfer(_msgSender(), recipient, amount);
973         return true;
974     }
975 
976     /**
977      * @dev See {IERC20-allowance}.
978      */
979     function allowance(address owner, address spender) public view virtual override returns (uint256) {
980         return _allowances[owner][spender];
981     }
982 
983     /**
984      * @dev See {IERC20-approve}.
985      *
986      * Requirements:
987      *
988      * - `spender` cannot be the zero address.
989      */
990     function approve(address spender, uint256 amount) public virtual override returns (bool) {
991         _approve(_msgSender(), spender, amount);
992         return true;
993     }
994 
995     /**
996      * @dev See {IERC20-transferFrom}.
997      *
998      * Emits an {Approval} event indicating the updated allowance. This is not
999      * required by the EIP. See the note at the beginning of {ERC20}.
1000      *
1001      * Requirements:
1002      *
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
1068         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1069         _balances[recipient] = _balances[recipient].add(amount);
1070         emit Transfer(sender, recipient, amount);
1071     }
1072 
1073     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1074      * the total supply.
1075      *
1076      * Emits a {Transfer} event with `from` set to the zero address.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      */
1082     function _mint(address account, uint256 amount) internal virtual {
1083         require(account != address(0), "ERC20: mint to the zero address");
1084 
1085         _totalSupply = _totalSupply.add(amount);
1086         _balances[account] = _balances[account].add(amount);
1087         emit Transfer(address(0), account, amount);
1088     }
1089 
1090     /**
1091      * @dev Destroys `amount` tokens from `account`, reducing the
1092      * total supply.
1093      *
1094      * Emits a {Transfer} event with `to` set to the zero address.
1095      *
1096      * Requirements:
1097      *
1098      * - `account` cannot be the zero address.
1099      * - `account` must have at least `amount` tokens.
1100      */
1101     function _burn(address account, uint256 amount) internal virtual {
1102         require(account != address(0), "ERC20: burn from the zero address");
1103 
1104         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1105         _totalSupply = _totalSupply.sub(amount);
1106         emit Transfer(account, address(0), amount);
1107     }
1108 
1109     /**
1110      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1111      *
1112      * This internal function is equivalent to `approve`, and can be used to
1113      * e.g. set automatic allowances for certain subsystems, etc.
1114      *
1115      * Emits an {Approval} event.
1116      *
1117      * Requirements:
1118      *
1119      * - `owner` cannot be the zero address.
1120      * - `spender` cannot be the zero address.
1121      */
1122     function _approve(address owner, address spender, uint256 amount) internal virtual {
1123         require(owner != address(0), "ERC20: approve from the zero address");
1124         require(spender != address(0), "ERC20: approve to the zero address");
1125 
1126         _allowances[owner][spender] = amount;
1127         emit Approval(owner, spender, amount);
1128     }
1129 
1130     /**
1131      * @dev Sets {decimals} to a value other than the default one of 18.
1132      *
1133      * WARNING: This function should only be called from the constructor. Most
1134      * applications that interact with token contracts will not expect
1135      * {decimals} to ever change, and may work incorrectly if it does.
1136      */
1137     function _setupDecimals(uint8 decimals_) internal {
1138         _decimals = decimals_;
1139     }
1140 
1141 }
1142 
1143 
1144 interface ITransferContarctCallback {
1145 
1146   function tokenFallback(address _from, address _to,  uint _value) external;
1147 
1148 }
1149 
1150 
1151 contract COVToken is ERC20, AccessControl {
1152 
1153     IOldCOVToken public oldCOVToken = IOldCOVToken(0xE2FB6529EF566a080e6d23dE0bd351311087D567);
1154 
1155     uint256 public constant MAX_INT = uint256(-1);
1156 
1157     bytes32 public constant ROLE_ADMIN = 0x00;
1158     bytes32 public constant ROLE_MINTER = bytes32(uint256(1));
1159     bytes32 public constant ROLE_BURNER = bytes32(uint256(2));
1160     bytes32 public constant ROLE_TRANSFER = bytes32(uint256(3));
1161     bytes32 public constant ROLE_ALIEN_TOKEN_SENDER = bytes32(uint256(4));
1162 
1163     bytes32 public constant LOCK_BURN = 0x00;
1164     bytes32 public constant LOCK_TRANSFER = bytes32(uint256(1));
1165     bytes32 public constant LOCK_MINT = bytes32(uint256(2));
1166     bytes32 public constant LOCK_ADDR_TIME_LOCK = bytes32(uint256(3));
1167 
1168     mapping(bytes32 => bool) public tempFuncLocks;
1169     mapping(bytes32 => bool) public finalFuncLocks;
1170 
1171     mapping(address => uint256) public locks;
1172 
1173     address public registeredCallback = address(0x0);
1174 
1175     constructor () public ERC20("Covesting", "COV") {
1176         _setRoleAdmin(ROLE_ADMIN, ROLE_ADMIN);
1177         _setRoleAdmin(ROLE_MINTER, ROLE_ADMIN);
1178         _setRoleAdmin(ROLE_BURNER, ROLE_ADMIN);
1179         _setRoleAdmin(ROLE_TRANSFER, ROLE_ADMIN);
1180         _setRoleAdmin(ROLE_ALIEN_TOKEN_SENDER, ROLE_ADMIN);
1181 
1182         _setupRole(ROLE_ADMIN, _msgSender());
1183         _setupRole(ROLE_MINTER, _msgSender());
1184         _setupRole(ROLE_BURNER, _msgSender());
1185         _setupRole(ROLE_TRANSFER, _msgSender());
1186         _setupRole(ROLE_ALIEN_TOKEN_SENDER, _msgSender());
1187 
1188         _setupRole(ROLE_ADMIN, address(this));
1189         _setupRole(ROLE_MINTER, address(this));
1190         _setupRole(ROLE_BURNER, address(this));
1191         _setupRole(ROLE_TRANSFER, address(this));
1192         _setupRole(ROLE_ALIEN_TOKEN_SENDER, address(this));
1193     }
1194 
1195     modifier onlyRole(bytes32 role) {
1196         require(hasRole(role, _msgSender()), "Sender requires permission");
1197         _;
1198     }
1199 
1200     modifier notFinalFuncLocked(bytes32 lock) {
1201         require(!finalFuncLocks[lock], "Locked");
1202         _;
1203     }
1204 
1205     function burn(uint256 amount) public virtual {
1206         _burn(_msgSender(), amount);
1207     }
1208 
1209     function burnFrom(address account, uint256 amount) public virtual {
1210         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1211         _approve(account, _msgSender(), decreasedAllowance);
1212         _burn(account, amount);
1213     }
1214 
1215     function setTempFuncLock(bytes32 lock, bool status) public onlyRole(ROLE_ADMIN) {
1216         tempFuncLocks[lock] = status;
1217     }
1218 
1219     function setOldCOVToken(address oldCOVTokenAddress) public onlyRole(ROLE_ADMIN) {
1220         oldCOVToken = IOldCOVToken(oldCOVTokenAddress);
1221     }
1222 
1223     function finalFuncLock(bytes32 lock) public onlyRole(ROLE_ADMIN) {
1224         finalFuncLocks[lock] = true;
1225     }
1226 
1227     function adminMint(address account, uint256 amount) public onlyRole(ROLE_MINTER) notFinalFuncLocked(LOCK_MINT) {
1228         _mint(account, amount);
1229     }
1230 
1231     function adminBurn(address account, uint256 amount) public onlyRole(ROLE_BURNER) notFinalFuncLocked(LOCK_BURN) {
1232         _burn(account, amount);
1233     }
1234 
1235     function adminTimelockTransfer(address account, uint256 periodInDays) public onlyRole(ROLE_ADMIN) notFinalFuncLocked(LOCK_ADDR_TIME_LOCK) {
1236         locks[account] = now + periodInDays * 1 days;
1237     }
1238 
1239     function retrieveTokens(address to, address anotherToken) public onlyRole(ROLE_ALIEN_TOKEN_SENDER) {
1240         IERC20Cutted alienToken = IERC20Cutted(anotherToken);
1241         alienToken.transfer(to, alienToken.balanceOf(address(this)));
1242     }
1243 
1244     function distributeMint(address[] memory receivers, uint[] memory balances) public onlyRole(ROLE_MINTER) notFinalFuncLocked(LOCK_MINT) {
1245         for (uint i = 0; i < receivers.length; i++) {
1246             _totalSupply = _totalSupply.add(balances[i]);
1247             _balances[receivers[i]] = _balances[receivers[i]].add(balances[i]);
1248             emit Transfer(address(0), receivers[i], balances[i]);
1249         }
1250     }
1251 
1252     function distributeLockOldToken(address[] memory receivers) public onlyRole(ROLE_ADMIN) {
1253         for(uint i = 0; i < receivers.length; i++) {
1254            oldCOVToken.lock(receivers[i], MAX_INT.div(1 days));
1255         }
1256     }
1257 
1258     function registerCallback(address callback) public onlyRole(ROLE_ADMIN) {
1259         registeredCallback = callback;
1260     }
1261 
1262     function deregisterCallback() public onlyRole(ROLE_ADMIN) {
1263         registeredCallback = address(0x0);
1264     }
1265 
1266     function _burn(address account, uint256 amount) internal virtual override {
1267         require(!tempFuncLocks[LOCK_BURN] || hasRole(ROLE_BURNER, _msgSender()), "Token burn locked");
1268         super._burn(account, amount);
1269     }
1270 
1271     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
1272         require((!tempFuncLocks[LOCK_TRANSFER] && locks[sender] < now) || hasRole(ROLE_TRANSFER, _msgSender()), "Token transfer locked");
1273         super._transfer(sender, recipient, amount);
1274         if (registeredCallback != address(0x0)) {
1275             ITransferContarctCallback targetCallback = ITransferContarctCallback(registeredCallback);
1276             targetCallback.tokenFallback(sender, recipient, amount);
1277         }
1278     }
1279 
1280 }