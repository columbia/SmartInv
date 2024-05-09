1 pragma solidity ^0.6.0;
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
244 
245 pragma solidity ^0.6.2;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 
386 
387 pragma solidity ^0.6.0;
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
412 pragma solidity ^0.6.0;
413 
414 
415 
416 
417 /**
418  * @dev Contract module that allows children to implement role-based access
419  * control mechanisms.
420  *
421  * Roles are referred to by their `bytes32` identifier. These should be exposed
422  * in the external API and be unique. The best way to achieve this is by
423  * using `public constant` hash digests:
424  *
425  * ```
426  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
427  * ```
428  *
429  * Roles can be used to represent a set of permissions. To restrict access to a
430  * function call, use {hasRole}:
431  *
432  * ```
433  * function foo() public {
434  *     require(hasRole(MY_ROLE, msg.sender));
435  *     ...
436  * }
437  * ```
438  *
439  * Roles can be granted and revoked dynamically via the {grantRole} and
440  * {revokeRole} functions. Each role has an associated admin role, and only
441  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
442  *
443  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
444  * that only accounts with this role will be able to grant or revoke other
445  * roles. More complex role relationships can be created by using
446  * {_setRoleAdmin}.
447  *
448  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
449  * grant and revoke this role. Extra precautions should be taken to secure
450  * accounts that have been granted it.
451  */
452 abstract contract AccessControl is Context {
453     using EnumerableSet for EnumerableSet.AddressSet;
454     using Address for address;
455 
456     struct RoleData {
457         EnumerableSet.AddressSet members;
458         bytes32 adminRole;
459     }
460 
461     mapping (bytes32 => RoleData) private _roles;
462 
463     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
464 
465     /**
466      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
467      *
468      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
469      * {RoleAdminChanged} not being emitted signaling this.
470      *
471      * _Available since v3.1._
472      */
473     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
474 
475     /**
476      * @dev Emitted when `account` is granted `role`.
477      *
478      * `sender` is the account that originated the contract call, an admin role
479      * bearer except when using {_setupRole}.
480      */
481     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
482 
483     /**
484      * @dev Emitted when `account` is revoked `role`.
485      *
486      * `sender` is the account that originated the contract call:
487      *   - if using `revokeRole`, it is the admin role bearer
488      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
489      */
490     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
491 
492     /**
493      * @dev Returns `true` if `account` has been granted `role`.
494      */
495     function hasRole(bytes32 role, address account) public view returns (bool) {
496         return _roles[role].members.contains(account);
497     }
498 
499     /**
500      * @dev Returns the number of accounts that have `role`. Can be used
501      * together with {getRoleMember} to enumerate all bearers of a role.
502      */
503     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
504         return _roles[role].members.length();
505     }
506 
507     /**
508      * @dev Returns one of the accounts that have `role`. `index` must be a
509      * value between 0 and {getRoleMemberCount}, non-inclusive.
510      *
511      * Role bearers are not sorted in any particular way, and their ordering may
512      * change at any point.
513      *
514      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
515      * you perform all queries on the same block. See the following
516      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
517      * for more information.
518      */
519     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
520         return _roles[role].members.at(index);
521     }
522 
523     /**
524      * @dev Returns the admin role that controls `role`. See {grantRole} and
525      * {revokeRole}.
526      *
527      * To change a role's admin, use {_setRoleAdmin}.
528      */
529     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
530         return _roles[role].adminRole;
531     }
532 
533     /**
534      * @dev Grants `role` to `account`.
535      *
536      * If `account` had not been already granted `role`, emits a {RoleGranted}
537      * event.
538      *
539      * Requirements:
540      *
541      * - the caller must have ``role``'s admin role.
542      */
543     function grantRole(bytes32 role, address account) public virtual {
544         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
545 
546         _grantRole(role, account);
547     }
548 
549     /**
550      * @dev Revokes `role` from `account`.
551      *
552      * If `account` had been granted `role`, emits a {RoleRevoked} event.
553      *
554      * Requirements:
555      *
556      * - the caller must have ``role``'s admin role.
557      */
558     function revokeRole(bytes32 role, address account) public virtual {
559         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
560 
561         _revokeRole(role, account);
562     }
563 
564     /**
565      * @dev Revokes `role` from the calling account.
566      *
567      * Roles are often managed via {grantRole} and {revokeRole}: this function's
568      * purpose is to provide a mechanism for accounts to lose their privileges
569      * if they are compromised (such as when a trusted device is misplaced).
570      *
571      * If the calling account had been granted `role`, emits a {RoleRevoked}
572      * event.
573      *
574      * Requirements:
575      *
576      * - the caller must be `account`.
577      */
578     function renounceRole(bytes32 role, address account) public virtual {
579         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
580 
581         _revokeRole(role, account);
582     }
583 
584     /**
585      * @dev Grants `role` to `account`.
586      *
587      * If `account` had not been already granted `role`, emits a {RoleGranted}
588      * event. Note that unlike {grantRole}, this function doesn't perform any
589      * checks on the calling account.
590      *
591      * [WARNING]
592      * ====
593      * This function should only be called from the constructor when setting
594      * up the initial roles for the system.
595      *
596      * Using this function in any other way is effectively circumventing the admin
597      * system imposed by {AccessControl}.
598      * ====
599      */
600     function _setupRole(bytes32 role, address account) internal virtual {
601         _grantRole(role, account);
602     }
603 
604     /**
605      * @dev Sets `adminRole` as ``role``'s admin role.
606      *
607      * Emits a {RoleAdminChanged} event.
608      */
609     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
610         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
611         _roles[role].adminRole = adminRole;
612     }
613 
614     function _grantRole(bytes32 role, address account) private {
615         if (_roles[role].members.add(account)) {
616             emit RoleGranted(role, account, _msgSender());
617         }
618     }
619 
620     function _revokeRole(bytes32 role, address account) private {
621         if (_roles[role].members.remove(account)) {
622             emit RoleRevoked(role, account, _msgSender());
623         }
624     }
625 }
626 
627 
628 
629 pragma solidity ^0.6.0;
630 
631 /**
632  * @dev Interface of the ERC20 standard as defined in the EIP.
633  */
634 interface IERC20 {
635     /**
636      * @dev Returns the amount of tokens in existence.
637      */
638     function totalSupply() external view returns (uint256);
639 
640     /**
641      * @dev Returns the amount of tokens owned by `account`.
642      */
643     function balanceOf(address account) external view returns (uint256);
644 
645     /**
646      * @dev Moves `amount` tokens from the caller's account to `recipient`.
647      *
648      * Returns a boolean value indicating whether the operation succeeded.
649      *
650      * Emits a {Transfer} event.
651      */
652     function transfer(address recipient, uint256 amount) external returns (bool);
653 
654     /**
655      * @dev Returns the remaining number of tokens that `spender` will be
656      * allowed to spend on behalf of `owner` through {transferFrom}. This is
657      * zero by default.
658      *
659      * This value changes when {approve} or {transferFrom} are called.
660      */
661     function allowance(address owner, address spender) external view returns (uint256);
662 
663     /**
664      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
665      *
666      * Returns a boolean value indicating whether the operation succeeded.
667      *
668      * IMPORTANT: Beware that changing an allowance with this method brings the risk
669      * that someone may use both the old and the new allowance by unfortunate
670      * transaction ordering. One possible solution to mitigate this race
671      * condition is to first reduce the spender's allowance to 0 and set the
672      * desired value afterwards:
673      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
674      *
675      * Emits an {Approval} event.
676      */
677     function approve(address spender, uint256 amount) external returns (bool);
678 
679     /**
680      * @dev Moves `amount` tokens from `sender` to `recipient` using the
681      * allowance mechanism. `amount` is then deducted from the caller's
682      * allowance.
683      *
684      * Returns a boolean value indicating whether the operation succeeded.
685      *
686      * Emits a {Transfer} event.
687      */
688     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
689 
690     /**
691      * @dev Emitted when `value` tokens are moved from one account (`from`) to
692      * another (`to`).
693      *
694      * Note that `value` may be zero.
695      */
696     event Transfer(address indexed from, address indexed to, uint256 value);
697 
698     /**
699      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
700      * a call to {approve}. `value` is the new allowance.
701      */
702     event Approval(address indexed owner, address indexed spender, uint256 value);
703 }
704 
705 
706 
707 pragma solidity ^0.6.0;
708 
709 /**
710  * @dev Wrappers over Solidity's arithmetic operations with added overflow
711  * checks.
712  *
713  * Arithmetic operations in Solidity wrap on overflow. This can easily result
714  * in bugs, because programmers usually assume that an overflow raises an
715  * error, which is the standard behavior in high level programming languages.
716  * `SafeMath` restores this intuition by reverting the transaction when an
717  * operation overflows.
718  *
719  * Using this library instead of the unchecked operations eliminates an entire
720  * class of bugs, so it's recommended to use it always.
721  */
722 library SafeMath {
723     /**
724      * @dev Returns the addition of two unsigned integers, reverting on
725      * overflow.
726      *
727      * Counterpart to Solidity's `+` operator.
728      *
729      * Requirements:
730      *
731      * - Addition cannot overflow.
732      */
733     function add(uint256 a, uint256 b) internal pure returns (uint256) {
734         uint256 c = a + b;
735         require(c >= a, "SafeMath: addition overflow");
736 
737         return c;
738     }
739 
740     /**
741      * @dev Returns the subtraction of two unsigned integers, reverting on
742      * overflow (when the result is negative).
743      *
744      * Counterpart to Solidity's `-` operator.
745      *
746      * Requirements:
747      *
748      * - Subtraction cannot overflow.
749      */
750     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
751         return sub(a, b, "SafeMath: subtraction overflow");
752     }
753 
754     /**
755      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
756      * overflow (when the result is negative).
757      *
758      * Counterpart to Solidity's `-` operator.
759      *
760      * Requirements:
761      *
762      * - Subtraction cannot overflow.
763      */
764     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
765         require(b <= a, errorMessage);
766         uint256 c = a - b;
767 
768         return c;
769     }
770 
771     /**
772      * @dev Returns the multiplication of two unsigned integers, reverting on
773      * overflow.
774      *
775      * Counterpart to Solidity's `*` operator.
776      *
777      * Requirements:
778      *
779      * - Multiplication cannot overflow.
780      */
781     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
782         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
783         // benefit is lost if 'b' is also tested.
784         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
785         if (a == 0) {
786             return 0;
787         }
788 
789         uint256 c = a * b;
790         require(c / a == b, "SafeMath: multiplication overflow");
791 
792         return c;
793     }
794 
795     /**
796      * @dev Returns the integer division of two unsigned integers. Reverts on
797      * division by zero. The result is rounded towards zero.
798      *
799      * Counterpart to Solidity's `/` operator. Note: this function uses a
800      * `revert` opcode (which leaves remaining gas untouched) while Solidity
801      * uses an invalid opcode to revert (consuming all remaining gas).
802      *
803      * Requirements:
804      *
805      * - The divisor cannot be zero.
806      */
807     function div(uint256 a, uint256 b) internal pure returns (uint256) {
808         return div(a, b, "SafeMath: division by zero");
809     }
810 
811     /**
812      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
813      * division by zero. The result is rounded towards zero.
814      *
815      * Counterpart to Solidity's `/` operator. Note: this function uses a
816      * `revert` opcode (which leaves remaining gas untouched) while Solidity
817      * uses an invalid opcode to revert (consuming all remaining gas).
818      *
819      * Requirements:
820      *
821      * - The divisor cannot be zero.
822      */
823     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
824         require(b > 0, errorMessage);
825         uint256 c = a / b;
826         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
827 
828         return c;
829     }
830 
831     /**
832      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
833      * Reverts when dividing by zero.
834      *
835      * Counterpart to Solidity's `%` operator. This function uses a `revert`
836      * opcode (which leaves remaining gas untouched) while Solidity uses an
837      * invalid opcode to revert (consuming all remaining gas).
838      *
839      * Requirements:
840      *
841      * - The divisor cannot be zero.
842      */
843     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
844         return mod(a, b, "SafeMath: modulo by zero");
845     }
846 
847     /**
848      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
849      * Reverts with custom message when dividing by zero.
850      *
851      * Counterpart to Solidity's `%` operator. This function uses a `revert`
852      * opcode (which leaves remaining gas untouched) while Solidity uses an
853      * invalid opcode to revert (consuming all remaining gas).
854      *
855      * Requirements:
856      *
857      * - The divisor cannot be zero.
858      */
859     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
860         require(b != 0, errorMessage);
861         return a % b;
862     }
863 }
864 
865 
866 
867 pragma solidity ^0.6.0;
868 
869 
870 
871 
872 
873 /**
874  * @dev Implementation of the {IERC20} interface.
875  *
876  * This implementation is agnostic to the way tokens are created. This means
877  * that a supply mechanism has to be added in a derived contract using {_mint}.
878  * For a generic mechanism see {ERC20PresetMinterPauser}.
879  *
880  * TIP: For a detailed writeup see our guide
881  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
882  * to implement supply mechanisms].
883  *
884  * We have followed general OpenZeppelin guidelines: functions revert instead
885  * of returning `false` on failure. This behavior is nonetheless conventional
886  * and does not conflict with the expectations of ERC20 applications.
887  *
888  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
889  * This allows applications to reconstruct the allowance for all accounts just
890  * by listening to said events. Other implementations of the EIP may not emit
891  * these events, as it isn't required by the specification.
892  *
893  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
894  * functions have been added to mitigate the well-known issues around setting
895  * allowances. See {IERC20-approve}.
896  */
897 contract ERC20 is Context, IERC20 {
898     using SafeMath for uint256;
899     using Address for address;
900 
901     mapping (address => uint256) private _balances;
902 
903     mapping (address => mapping (address => uint256)) private _allowances;
904 
905     uint256 private _totalSupply;
906 
907     string private _name;
908     string private _symbol;
909     uint8 private _decimals;
910 
911     /**
912      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
913      * a default value of 18.
914      *
915      * To select a different value for {decimals}, use {_setupDecimals}.
916      *
917      * All three of these values are immutable: they can only be set once during
918      * construction.
919      */
920     constructor (string memory name, string memory symbol) public {
921         _name = name;
922         _symbol = symbol;
923         _decimals = 18;
924     }
925 
926     /**
927      * @dev Returns the name of the token.
928      */
929     function name() public view returns (string memory) {
930         return _name;
931     }
932 
933     /**
934      * @dev Returns the symbol of the token, usually a shorter version of the
935      * name.
936      */
937     function symbol() public view returns (string memory) {
938         return _symbol;
939     }
940 
941     /**
942      * @dev Returns the number of decimals used to get its user representation.
943      * For example, if `decimals` equals `2`, a balance of `505` tokens should
944      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
945      *
946      * Tokens usually opt for a value of 18, imitating the relationship between
947      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
948      * called.
949      *
950      * NOTE: This information is only used for _display_ purposes: it in
951      * no way affects any of the arithmetic of the contract, including
952      * {IERC20-balanceOf} and {IERC20-transfer}.
953      */
954     function decimals() public view returns (uint8) {
955         return _decimals;
956     }
957 
958     /**
959      * @dev See {IERC20-totalSupply}.
960      */
961     function totalSupply() public view override returns (uint256) {
962         return _totalSupply;
963     }
964 
965     /**
966      * @dev See {IERC20-balanceOf}.
967      */
968     function balanceOf(address account) public view override returns (uint256) {
969         return _balances[account];
970     }
971 
972     /**
973      * @dev See {IERC20-transfer}.
974      *
975      * Requirements:
976      *
977      * - `recipient` cannot be the zero address.
978      * - the caller must have a balance of at least `amount`.
979      */
980     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
981         _transfer(_msgSender(), recipient, amount);
982         return true;
983     }
984 
985     /**
986      * @dev See {IERC20-allowance}.
987      */
988     function allowance(address owner, address spender) public view virtual override returns (uint256) {
989         return _allowances[owner][spender];
990     }
991 
992     /**
993      * @dev See {IERC20-approve}.
994      *
995      * Requirements:
996      *
997      * - `spender` cannot be the zero address.
998      */
999     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1000         _approve(_msgSender(), spender, amount);
1001         return true;
1002     }
1003 
1004     /**
1005      * @dev See {IERC20-transferFrom}.
1006      *
1007      * Emits an {Approval} event indicating the updated allowance. This is not
1008      * required by the EIP. See the note at the beginning of {ERC20};
1009      *
1010      * Requirements:
1011      * - `sender` and `recipient` cannot be the zero address.
1012      * - `sender` must have a balance of at least `amount`.
1013      * - the caller must have allowance for ``sender``'s tokens of at least
1014      * `amount`.
1015      */
1016     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1017         _transfer(sender, recipient, amount);
1018         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1019         return true;
1020     }
1021 
1022     /**
1023      * @dev Atomically increases the allowance granted to `spender` by the caller.
1024      *
1025      * This is an alternative to {approve} that can be used as a mitigation for
1026      * problems described in {IERC20-approve}.
1027      *
1028      * Emits an {Approval} event indicating the updated allowance.
1029      *
1030      * Requirements:
1031      *
1032      * - `spender` cannot be the zero address.
1033      */
1034     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1035         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1036         return true;
1037     }
1038 
1039     /**
1040      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1041      *
1042      * This is an alternative to {approve} that can be used as a mitigation for
1043      * problems described in {IERC20-approve}.
1044      *
1045      * Emits an {Approval} event indicating the updated allowance.
1046      *
1047      * Requirements:
1048      *
1049      * - `spender` cannot be the zero address.
1050      * - `spender` must have allowance for the caller of at least
1051      * `subtractedValue`.
1052      */
1053     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1054         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1055         return true;
1056     }
1057 
1058     /**
1059      * @dev Moves tokens `amount` from `sender` to `recipient`.
1060      *
1061      * This is internal function is equivalent to {transfer}, and can be used to
1062      * e.g. implement automatic token fees, slashing mechanisms, etc.
1063      *
1064      * Emits a {Transfer} event.
1065      *
1066      * Requirements:
1067      *
1068      * - `sender` cannot be the zero address.
1069      * - `recipient` cannot be the zero address.
1070      * - `sender` must have a balance of at least `amount`.
1071      */
1072     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1073         require(sender != address(0), "ERC20: transfer from the zero address");
1074         require(recipient != address(0), "ERC20: transfer to the zero address");
1075 
1076         _beforeTokenTransfer(sender, recipient, amount);
1077 
1078         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1079         _balances[recipient] = _balances[recipient].add(amount);
1080         emit Transfer(sender, recipient, amount);
1081     }
1082 
1083     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1084      * the total supply.
1085      *
1086      * Emits a {Transfer} event with `from` set to the zero address.
1087      *
1088      * Requirements
1089      *
1090      * - `to` cannot be the zero address.
1091      */
1092     function _mint(address account, uint256 amount) internal virtual {
1093         require(account != address(0), "ERC20: mint to the zero address");
1094 
1095         _beforeTokenTransfer(address(0), account, amount);
1096 
1097         _totalSupply = _totalSupply.add(amount);
1098         _balances[account] = _balances[account].add(amount);
1099         emit Transfer(address(0), account, amount);
1100     }
1101 
1102     /**
1103      * @dev Destroys `amount` tokens from `account`, reducing the
1104      * total supply.
1105      *
1106      * Emits a {Transfer} event with `to` set to the zero address.
1107      *
1108      * Requirements
1109      *
1110      * - `account` cannot be the zero address.
1111      * - `account` must have at least `amount` tokens.
1112      */
1113     function _burn(address account, uint256 amount) internal virtual {
1114         require(account != address(0), "ERC20: burn from the zero address");
1115 
1116         _beforeTokenTransfer(account, address(0), amount);
1117 
1118         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1119         _totalSupply = _totalSupply.sub(amount);
1120         emit Transfer(account, address(0), amount);
1121     }
1122 
1123     /**
1124      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1125      *
1126      * This is internal function is equivalent to `approve`, and can be used to
1127      * e.g. set automatic allowances for certain subsystems, etc.
1128      *
1129      * Emits an {Approval} event.
1130      *
1131      * Requirements:
1132      *
1133      * - `owner` cannot be the zero address.
1134      * - `spender` cannot be the zero address.
1135      */
1136     function _approve(address owner, address spender, uint256 amount) internal virtual {
1137         require(owner != address(0), "ERC20: approve from the zero address");
1138         require(spender != address(0), "ERC20: approve to the zero address");
1139 
1140         _allowances[owner][spender] = amount;
1141         emit Approval(owner, spender, amount);
1142     }
1143 
1144     /**
1145      * @dev Sets {decimals} to a value other than the default one of 18.
1146      *
1147      * WARNING: This function should only be called from the constructor. Most
1148      * applications that interact with token contracts will not expect
1149      * {decimals} to ever change, and may work incorrectly if it does.
1150      */
1151     function _setupDecimals(uint8 decimals_) internal {
1152         _decimals = decimals_;
1153     }
1154 
1155     /**
1156      * @dev Hook that is called before any transfer of tokens. This includes
1157      * minting and burning.
1158      *
1159      * Calling conditions:
1160      *
1161      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1162      * will be to transferred to `to`.
1163      * - when `from` is zero, `amount` tokens will be minted for `to`.
1164      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1165      * - `from` and `to` are never both zero.
1166      *
1167      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1168      */
1169     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1170 }
1171 
1172 
1173 
1174 pragma solidity ^0.6.0;
1175 
1176 
1177 
1178 /**
1179  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1180  * tokens and those that they have an allowance for, in a way that can be
1181  * recognized off-chain (via event analysis).
1182  */
1183 abstract contract ERC20Burnable is Context, ERC20 {
1184     /**
1185      * @dev Destroys `amount` tokens from the caller.
1186      *
1187      * See {ERC20-_burn}.
1188      */
1189     function burn(uint256 amount) public virtual {
1190         _burn(_msgSender(), amount);
1191     }
1192 
1193     /**
1194      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1195      * allowance.
1196      *
1197      * See {ERC20-_burn} and {ERC20-allowance}.
1198      *
1199      * Requirements:
1200      *
1201      * - the caller must have allowance for ``accounts``'s tokens of at least
1202      * `amount`.
1203      */
1204     function burnFrom(address account, uint256 amount) public virtual {
1205         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1206 
1207         _approve(account, _msgSender(), decreasedAllowance);
1208         _burn(account, amount);
1209     }
1210 }
1211 
1212 
1213 
1214 pragma solidity 0.6.11;
1215 
1216 
1217 
1218 
1219 /**
1220  * @dev {ERC20} token, including:
1221  *
1222  *  - ability for holders to burn (destroy) their tokens
1223  *  - a minter role that allows for token minting (creation)
1224  *  - a pauser role that allows to stop all token transfers
1225  *
1226  * This contract uses {AccessControl} to lock permissioned functions using the
1227  * different roles - head to its documentation for details.
1228  *
1229  * The account that deploys the contract will be granted the minter and pauser
1230  * roles, as well as the default admin role, which will let it grant both minter
1231  * and pauser roles to other accounts.
1232  */
1233 contract BARTToken is Context, AccessControl, ERC20Burnable {
1234     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1235 
1236     /**
1237      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1238      * account that deploys the contract.
1239      *
1240      * See {ERC20-constructor}.
1241      */
1242     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1243         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1244 
1245         _setupRole(MINTER_ROLE, _msgSender());
1246     }
1247 
1248     /**
1249      * @dev Creates `amount` new tokens for `to`.
1250      *
1251      * See {ERC20-_mint}.
1252      *
1253      * Requirements:
1254      *
1255      * - the caller must have the `MINTER_ROLE`.
1256      */
1257     function mint(address to, uint256 amount) public virtual {
1258         require(hasRole(MINTER_ROLE, _msgSender()), "BARTToken: must have minter role to mint");
1259         _mint(to, amount);
1260     }
1261 }