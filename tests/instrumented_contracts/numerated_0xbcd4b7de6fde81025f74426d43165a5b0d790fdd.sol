1 pragma solidity 0.6.2;// SPDX-License-Identifier: MIT
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
26  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
27  * and `uint256` (`UintSet`) are supported.
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
135     // Bytes32Set
136 
137     struct Bytes32Set {
138         Set _inner;
139     }
140 
141     /**
142      * @dev Add a value to a set. O(1).
143      *
144      * Returns true if the value was added to the set, that is if it was not
145      * already present.
146      */
147     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
148         return _add(set._inner, value);
149     }
150 
151     /**
152      * @dev Removes a value from a set. O(1).
153      *
154      * Returns true if the value was removed from the set, that is if it was
155      * present.
156      */
157     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
158         return _remove(set._inner, value);
159     }
160 
161     /**
162      * @dev Returns true if the value is in the set. O(1).
163      */
164     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
165         return _contains(set._inner, value);
166     }
167 
168     /**
169      * @dev Returns the number of values in the set. O(1).
170      */
171     function length(Bytes32Set storage set) internal view returns (uint256) {
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
185     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
186         return _at(set._inner, index);
187     }
188 
189     // AddressSet
190 
191     struct AddressSet {
192         Set _inner;
193     }
194 
195     /**
196      * @dev Add a value to a set. O(1).
197      *
198      * Returns true if the value was added to the set, that is if it was not
199      * already present.
200      */
201     function add(AddressSet storage set, address value) internal returns (bool) {
202         return _add(set._inner, bytes32(uint256(value)));
203     }
204 
205     /**
206      * @dev Removes a value from a set. O(1).
207      *
208      * Returns true if the value was removed from the set, that is if it was
209      * present.
210      */
211     function remove(AddressSet storage set, address value) internal returns (bool) {
212         return _remove(set._inner, bytes32(uint256(value)));
213     }
214 
215     /**
216      * @dev Returns true if the value is in the set. O(1).
217      */
218     function contains(AddressSet storage set, address value) internal view returns (bool) {
219         return _contains(set._inner, bytes32(uint256(value)));
220     }
221 
222     /**
223      * @dev Returns the number of values in the set. O(1).
224      */
225     function length(AddressSet storage set) internal view returns (uint256) {
226         return _length(set._inner);
227     }
228 
229    /**
230     * @dev Returns the value stored at position `index` in the set. O(1).
231     *
232     * Note that there are no guarantees on the ordering of values inside the
233     * array, and it may change when more values are added or removed.
234     *
235     * Requirements:
236     *
237     * - `index` must be strictly less than {length}.
238     */
239     function at(AddressSet storage set, uint256 index) internal view returns (address) {
240         return address(uint256(_at(set._inner, index)));
241     }
242 
243 
244     // UintSet
245 
246     struct UintSet {
247         Set _inner;
248     }
249 
250     /**
251      * @dev Add a value to a set. O(1).
252      *
253      * Returns true if the value was added to the set, that is if it was not
254      * already present.
255      */
256     function add(UintSet storage set, uint256 value) internal returns (bool) {
257         return _add(set._inner, bytes32(value));
258     }
259 
260     /**
261      * @dev Removes a value from a set. O(1).
262      *
263      * Returns true if the value was removed from the set, that is if it was
264      * present.
265      */
266     function remove(UintSet storage set, uint256 value) internal returns (bool) {
267         return _remove(set._inner, bytes32(value));
268     }
269 
270     /**
271      * @dev Returns true if the value is in the set. O(1).
272      */
273     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
274         return _contains(set._inner, bytes32(value));
275     }
276 
277     /**
278      * @dev Returns the number of values on the set. O(1).
279      */
280     function length(UintSet storage set) internal view returns (uint256) {
281         return _length(set._inner);
282     }
283 
284    /**
285     * @dev Returns the value stored at position `index` in the set. O(1).
286     *
287     * Note that there are no guarantees on the ordering of values inside the
288     * array, and it may change when more values are added or removed.
289     *
290     * Requirements:
291     *
292     * - `index` must be strictly less than {length}.
293     */
294     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
295         return uint256(_at(set._inner, index));
296     }
297 }
298 // SPDX-License-Identifier: MIT
299 
300 
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      */
323     function isContract(address account) internal view returns (bool) {
324         // This method relies on extcodesize, which returns 0 for contracts in
325         // construction, since the code is only stored at the end of the
326         // constructor execution.
327 
328         uint256 size;
329         // solhint-disable-next-line no-inline-assembly
330         assembly { size := extcodesize(account) }
331         return size > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
354         (bool success, ) = recipient.call{ value: amount }("");
355         require(success, "Address: unable to send value, recipient may have reverted");
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain`call` is an unsafe replacement for a function call: use this
361      * function instead.
362      *
363      * If `target` reverts with a revert reason, it is bubbled up by this
364      * function (like regular Solidity function calls).
365      *
366      * Returns the raw returned data. To convert to the expected return value,
367      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
368      *
369      * Requirements:
370      *
371      * - `target` must be a contract.
372      * - calling `target` with `data` must not revert.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
377       return functionCall(target, data, "Address: low-level call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382      * `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, 0, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but also transferring `value` wei to `target`.
393      *
394      * Requirements:
395      *
396      * - the calling contract must have an ETH balance of at least `value`.
397      * - the called Solidity function must be `payable`.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
412         require(address(this).balance >= value, "Address: insufficient balance for call");
413         require(isContract(target), "Address: call to non-contract");
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = target.call{ value: value }(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
427         return functionStaticCall(target, data, "Address: low-level static call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
437         require(isContract(target), "Address: static call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.staticcall(data);
441         return _verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 // solhint-disable-next-line no-inline-assembly
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 // SPDX-License-Identifier: MIT
464 
465 
466 
467 /*
468  * @dev Provides information about the current execution context, including the
469  * sender of the transaction and its data. While these are generally available
470  * via msg.sender and msg.data, they should not be accessed in such a direct
471  * manner, since when dealing with GSN meta-transactions the account sending and
472  * paying for execution may not be the actual sender (as far as an application
473  * is concerned).
474  *
475  * This contract is only required for intermediate, library-like contracts.
476  */
477 abstract contract Context {
478     function _msgSender() internal view virtual returns (address payable) {
479         return msg.sender;
480     }
481 
482     function _msgData() internal view virtual returns (bytes memory) {
483         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
484         return msg.data;
485     }
486 }
487 // SPDX-License-Identifier: MIT
488 
489 
490 
491 
492 /**
493  * @dev Contract module that allows children to implement role-based access
494  * control mechanisms.
495  *
496  * Roles are referred to by their `bytes32` identifier. These should be exposed
497  * in the external API and be unique. The best way to achieve this is by
498  * using `public constant` hash digests:
499  *
500  * ```
501  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
502  * ```
503  *
504  * Roles can be used to represent a set of permissions. To restrict access to a
505  * function call, use {hasRole}:
506  *
507  * ```
508  * function foo() public {
509  *     require(hasRole(MY_ROLE, msg.sender));
510  *     ...
511  * }
512  * ```
513  *
514  * Roles can be granted and revoked dynamically via the {grantRole} and
515  * {revokeRole} functions. Each role has an associated admin role, and only
516  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
517  *
518  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
519  * that only accounts with this role will be able to grant or revoke other
520  * roles. More complex role relationships can be created by using
521  * {_setRoleAdmin}.
522  *
523  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
524  * grant and revoke this role. Extra precautions should be taken to secure
525  * accounts that have been granted it.
526  */
527 abstract contract AccessControl is Context {
528     using EnumerableSet for EnumerableSet.AddressSet;
529     using Address for address;
530 
531     struct RoleData {
532         EnumerableSet.AddressSet members;
533         bytes32 adminRole;
534     }
535 
536     mapping (bytes32 => RoleData) private _roles;
537 
538     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
539 
540     /**
541      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
542      *
543      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
544      * {RoleAdminChanged} not being emitted signaling this.
545      *
546      * _Available since v3.1._
547      */
548     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
549 
550     /**
551      * @dev Emitted when `account` is granted `role`.
552      *
553      * `sender` is the account that originated the contract call, an admin role
554      * bearer except when using {_setupRole}.
555      */
556     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
557 
558     /**
559      * @dev Emitted when `account` is revoked `role`.
560      *
561      * `sender` is the account that originated the contract call:
562      *   - if using `revokeRole`, it is the admin role bearer
563      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
564      */
565     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
566 
567     /**
568      * @dev Returns `true` if `account` has been granted `role`.
569      */
570     function hasRole(bytes32 role, address account) public view returns (bool) {
571         return _roles[role].members.contains(account);
572     }
573 
574     /**
575      * @dev Returns the number of accounts that have `role`. Can be used
576      * together with {getRoleMember} to enumerate all bearers of a role.
577      */
578     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
579         return _roles[role].members.length();
580     }
581 
582     /**
583      * @dev Returns one of the accounts that have `role`. `index` must be a
584      * value between 0 and {getRoleMemberCount}, non-inclusive.
585      *
586      * Role bearers are not sorted in any particular way, and their ordering may
587      * change at any point.
588      *
589      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
590      * you perform all queries on the same block. See the following
591      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
592      * for more information.
593      */
594     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
595         return _roles[role].members.at(index);
596     }
597 
598     /**
599      * @dev Returns the admin role that controls `role`. See {grantRole} and
600      * {revokeRole}.
601      *
602      * To change a role's admin, use {_setRoleAdmin}.
603      */
604     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
605         return _roles[role].adminRole;
606     }
607 
608     /**
609      * @dev Grants `role` to `account`.
610      *
611      * If `account` had not been already granted `role`, emits a {RoleGranted}
612      * event.
613      *
614      * Requirements:
615      *
616      * - the caller must have ``role``'s admin role.
617      */
618     function grantRole(bytes32 role, address account) public virtual {
619         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
620 
621         _grantRole(role, account);
622     }
623 
624     /**
625      * @dev Revokes `role` from `account`.
626      *
627      * If `account` had been granted `role`, emits a {RoleRevoked} event.
628      *
629      * Requirements:
630      *
631      * - the caller must have ``role``'s admin role.
632      */
633     function revokeRole(bytes32 role, address account) public virtual {
634         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
635 
636         _revokeRole(role, account);
637     }
638 
639     /**
640      * @dev Revokes `role` from the calling account.
641      *
642      * Roles are often managed via {grantRole} and {revokeRole}: this function's
643      * purpose is to provide a mechanism for accounts to lose their privileges
644      * if they are compromised (such as when a trusted device is misplaced).
645      *
646      * If the calling account had been granted `role`, emits a {RoleRevoked}
647      * event.
648      *
649      * Requirements:
650      *
651      * - the caller must be `account`.
652      */
653     function renounceRole(bytes32 role, address account) public virtual {
654         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
655 
656         _revokeRole(role, account);
657     }
658 
659     /**
660      * @dev Grants `role` to `account`.
661      *
662      * If `account` had not been already granted `role`, emits a {RoleGranted}
663      * event. Note that unlike {grantRole}, this function doesn't perform any
664      * checks on the calling account.
665      *
666      * [WARNING]
667      * ====
668      * This function should only be called from the constructor when setting
669      * up the initial roles for the system.
670      *
671      * Using this function in any other way is effectively circumventing the admin
672      * system imposed by {AccessControl}.
673      * ====
674      */
675     function _setupRole(bytes32 role, address account) internal virtual {
676         _grantRole(role, account);
677     }
678 
679     /**
680      * @dev Sets `adminRole` as ``role``'s admin role.
681      *
682      * Emits a {RoleAdminChanged} event.
683      */
684     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
685         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
686         _roles[role].adminRole = adminRole;
687     }
688 
689     function _grantRole(bytes32 role, address account) private {
690         if (_roles[role].members.add(account)) {
691             emit RoleGranted(role, account, _msgSender());
692         }
693     }
694 
695     function _revokeRole(bytes32 role, address account) private {
696         if (_roles[role].members.remove(account)) {
697             emit RoleRevoked(role, account, _msgSender());
698         }
699     }
700 }
701 // SPDX-License-Identifier: MIT
702 
703 
704 
705 /**
706  * @dev Interface of the ERC20 standard as defined in the EIP.
707  */
708 interface IERC20 {
709     /**
710      * @dev Returns the amount of tokens in existence.
711      */
712     function totalSupply() external view returns (uint256);
713 
714     /**
715      * @dev Returns the amount of tokens owned by `account`.
716      */
717     function balanceOf(address account) external view returns (uint256);
718 
719     /**
720      * @dev Moves `amount` tokens from the caller's account to `recipient`.
721      *
722      * Returns a boolean value indicating whether the operation succeeded.
723      *
724      * Emits a {Transfer} event.
725      */
726     function transfer(address recipient, uint256 amount) external returns (bool);
727 
728     /**
729      * @dev Returns the remaining number of tokens that `spender` will be
730      * allowed to spend on behalf of `owner` through {transferFrom}. This is
731      * zero by default.
732      *
733      * This value changes when {approve} or {transferFrom} are called.
734      */
735     function allowance(address owner, address spender) external view returns (uint256);
736 
737     /**
738      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
739      *
740      * Returns a boolean value indicating whether the operation succeeded.
741      *
742      * IMPORTANT: Beware that changing an allowance with this method brings the risk
743      * that someone may use both the old and the new allowance by unfortunate
744      * transaction ordering. One possible solution to mitigate this race
745      * condition is to first reduce the spender's allowance to 0 and set the
746      * desired value afterwards:
747      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
748      *
749      * Emits an {Approval} event.
750      */
751     function approve(address spender, uint256 amount) external returns (bool);
752 
753     /**
754      * @dev Moves `amount` tokens from `sender` to `recipient` using the
755      * allowance mechanism. `amount` is then deducted from the caller's
756      * allowance.
757      *
758      * Returns a boolean value indicating whether the operation succeeded.
759      *
760      * Emits a {Transfer} event.
761      */
762     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
763 
764     /**
765      * @dev Emitted when `value` tokens are moved from one account (`from`) to
766      * another (`to`).
767      *
768      * Note that `value` may be zero.
769      */
770     event Transfer(address indexed from, address indexed to, uint256 value);
771 
772     /**
773      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
774      * a call to {approve}. `value` is the new allowance.
775      */
776     event Approval(address indexed owner, address indexed spender, uint256 value);
777 }
778 // SPDX-License-Identifier: MIT
779 
780 
781 
782 /**
783  * @dev Wrappers over Solidity's arithmetic operations with added overflow
784  * checks.
785  *
786  * Arithmetic operations in Solidity wrap on overflow. This can easily result
787  * in bugs, because programmers usually assume that an overflow raises an
788  * error, which is the standard behavior in high level programming languages.
789  * `SafeMath` restores this intuition by reverting the transaction when an
790  * operation overflows.
791  *
792  * Using this library instead of the unchecked operations eliminates an entire
793  * class of bugs, so it's recommended to use it always.
794  */
795 library SafeMath {
796     /**
797      * @dev Returns the addition of two unsigned integers, reverting on
798      * overflow.
799      *
800      * Counterpart to Solidity's `+` operator.
801      *
802      * Requirements:
803      *
804      * - Addition cannot overflow.
805      */
806     function add(uint256 a, uint256 b) internal pure returns (uint256) {
807         uint256 c = a + b;
808         require(c >= a, "SafeMath: addition overflow");
809 
810         return c;
811     }
812 
813     /**
814      * @dev Returns the subtraction of two unsigned integers, reverting on
815      * overflow (when the result is negative).
816      *
817      * Counterpart to Solidity's `-` operator.
818      *
819      * Requirements:
820      *
821      * - Subtraction cannot overflow.
822      */
823     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
824         return sub(a, b, "SafeMath: subtraction overflow");
825     }
826 
827     /**
828      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
829      * overflow (when the result is negative).
830      *
831      * Counterpart to Solidity's `-` operator.
832      *
833      * Requirements:
834      *
835      * - Subtraction cannot overflow.
836      */
837     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
838         require(b <= a, errorMessage);
839         uint256 c = a - b;
840 
841         return c;
842     }
843 
844     /**
845      * @dev Returns the multiplication of two unsigned integers, reverting on
846      * overflow.
847      *
848      * Counterpart to Solidity's `*` operator.
849      *
850      * Requirements:
851      *
852      * - Multiplication cannot overflow.
853      */
854     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
855         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
856         // benefit is lost if 'b' is also tested.
857         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
858         if (a == 0) {
859             return 0;
860         }
861 
862         uint256 c = a * b;
863         require(c / a == b, "SafeMath: multiplication overflow");
864 
865         return c;
866     }
867 
868     /**
869      * @dev Returns the integer division of two unsigned integers. Reverts on
870      * division by zero. The result is rounded towards zero.
871      *
872      * Counterpart to Solidity's `/` operator. Note: this function uses a
873      * `revert` opcode (which leaves remaining gas untouched) while Solidity
874      * uses an invalid opcode to revert (consuming all remaining gas).
875      *
876      * Requirements:
877      *
878      * - The divisor cannot be zero.
879      */
880     function div(uint256 a, uint256 b) internal pure returns (uint256) {
881         return div(a, b, "SafeMath: division by zero");
882     }
883 
884     /**
885      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
886      * division by zero. The result is rounded towards zero.
887      *
888      * Counterpart to Solidity's `/` operator. Note: this function uses a
889      * `revert` opcode (which leaves remaining gas untouched) while Solidity
890      * uses an invalid opcode to revert (consuming all remaining gas).
891      *
892      * Requirements:
893      *
894      * - The divisor cannot be zero.
895      */
896     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
897         require(b > 0, errorMessage);
898         uint256 c = a / b;
899         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
900 
901         return c;
902     }
903 
904     /**
905      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
906      * Reverts when dividing by zero.
907      *
908      * Counterpart to Solidity's `%` operator. This function uses a `revert`
909      * opcode (which leaves remaining gas untouched) while Solidity uses an
910      * invalid opcode to revert (consuming all remaining gas).
911      *
912      * Requirements:
913      *
914      * - The divisor cannot be zero.
915      */
916     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
917         return mod(a, b, "SafeMath: modulo by zero");
918     }
919 
920     /**
921      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
922      * Reverts with custom message when dividing by zero.
923      *
924      * Counterpart to Solidity's `%` operator. This function uses a `revert`
925      * opcode (which leaves remaining gas untouched) while Solidity uses an
926      * invalid opcode to revert (consuming all remaining gas).
927      *
928      * Requirements:
929      *
930      * - The divisor cannot be zero.
931      */
932     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
933         require(b != 0, errorMessage);
934         return a % b;
935     }
936 }
937 // SPDX-License-Identifier: MIT
938 
939 
940 
941 
942 /**
943  * @dev Implementation of the {IERC20} interface.
944  *
945  * This implementation is agnostic to the way tokens are created. This means
946  * that a supply mechanism has to be added in a derived contract using {_mint}.
947  * For a generic mechanism see {ERC20PresetMinterPauser}.
948  *
949  * TIP: For a detailed writeup see our guide
950  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
951  * to implement supply mechanisms].
952  *
953  * We have followed general OpenZeppelin guidelines: functions revert instead
954  * of returning `false` on failure. This behavior is nonetheless conventional
955  * and does not conflict with the expectations of ERC20 applications.
956  *
957  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
958  * This allows applications to reconstruct the allowance for all accounts just
959  * by listening to said events. Other implementations of the EIP may not emit
960  * these events, as it isn't required by the specification.
961  *
962  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
963  * functions have been added to mitigate the well-known issues around setting
964  * allowances. See {IERC20-approve}.
965  */
966 contract ERC20 is Context, IERC20 {
967     using SafeMath for uint256;
968 
969     mapping (address => uint256) private _balances;
970 
971     mapping (address => mapping (address => uint256)) private _allowances;
972 
973     uint256 private _totalSupply;
974 
975     string private _name;
976     string private _symbol;
977     uint8 private _decimals;
978 
979     /**
980      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
981      * a default value of 18.
982      *
983      * To select a different value for {decimals}, use {_setupDecimals}.
984      *
985      * All three of these values are immutable: they can only be set once during
986      * construction.
987      */
988     constructor (string memory name_, string memory symbol_) public {
989         _name = name_;
990         _symbol = symbol_;
991         _decimals = 18;
992     }
993 
994     /**
995      * @dev Returns the name of the token.
996      */
997     function name() public view returns (string memory) {
998         return _name;
999     }
1000 
1001     /**
1002      * @dev Returns the symbol of the token, usually a shorter version of the
1003      * name.
1004      */
1005     function symbol() public view returns (string memory) {
1006         return _symbol;
1007     }
1008 
1009     /**
1010      * @dev Returns the number of decimals used to get its user representation.
1011      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1012      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1013      *
1014      * Tokens usually opt for a value of 18, imitating the relationship between
1015      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1016      * called.
1017      *
1018      * NOTE: This information is only used for _display_ purposes: it in
1019      * no way affects any of the arithmetic of the contract, including
1020      * {IERC20-balanceOf} and {IERC20-transfer}.
1021      */
1022     function decimals() public view returns (uint8) {
1023         return _decimals;
1024     }
1025 
1026     /**
1027      * @dev See {IERC20-totalSupply}.
1028      */
1029     function totalSupply() public view override returns (uint256) {
1030         return _totalSupply;
1031     }
1032 
1033     /**
1034      * @dev See {IERC20-balanceOf}.
1035      */
1036     function balanceOf(address account) public view override returns (uint256) {
1037         return _balances[account];
1038     }
1039 
1040     /**
1041      * @dev See {IERC20-transfer}.
1042      *
1043      * Requirements:
1044      *
1045      * - `recipient` cannot be the zero address.
1046      * - the caller must have a balance of at least `amount`.
1047      */
1048     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1049         _transfer(_msgSender(), recipient, amount);
1050         return true;
1051     }
1052 
1053     /**
1054      * @dev See {IERC20-allowance}.
1055      */
1056     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1057         return _allowances[owner][spender];
1058     }
1059 
1060     /**
1061      * @dev See {IERC20-approve}.
1062      *
1063      * Requirements:
1064      *
1065      * - `spender` cannot be the zero address.
1066      */
1067     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1068         _approve(_msgSender(), spender, amount);
1069         return true;
1070     }
1071 
1072     /**
1073      * @dev See {IERC20-transferFrom}.
1074      *
1075      * Emits an {Approval} event indicating the updated allowance. This is not
1076      * required by the EIP. See the note at the beginning of {ERC20}.
1077      *
1078      * Requirements:
1079      *
1080      * - `sender` and `recipient` cannot be the zero address.
1081      * - `sender` must have a balance of at least `amount`.
1082      * - the caller must have allowance for ``sender``'s tokens of at least
1083      * `amount`.
1084      */
1085     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1086         _transfer(sender, recipient, amount);
1087         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1088         return true;
1089     }
1090 
1091     /**
1092      * @dev Atomically increases the allowance granted to `spender` by the caller.
1093      *
1094      * This is an alternative to {approve} that can be used as a mitigation for
1095      * problems described in {IERC20-approve}.
1096      *
1097      * Emits an {Approval} event indicating the updated allowance.
1098      *
1099      * Requirements:
1100      *
1101      * - `spender` cannot be the zero address.
1102      */
1103     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1104         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1105         return true;
1106     }
1107 
1108     /**
1109      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1110      *
1111      * This is an alternative to {approve} that can be used as a mitigation for
1112      * problems described in {IERC20-approve}.
1113      *
1114      * Emits an {Approval} event indicating the updated allowance.
1115      *
1116      * Requirements:
1117      *
1118      * - `spender` cannot be the zero address.
1119      * - `spender` must have allowance for the caller of at least
1120      * `subtractedValue`.
1121      */
1122     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1123         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1124         return true;
1125     }
1126 
1127     /**
1128      * @dev Moves tokens `amount` from `sender` to `recipient`.
1129      *
1130      * This is internal function is equivalent to {transfer}, and can be used to
1131      * e.g. implement automatic token fees, slashing mechanisms, etc.
1132      *
1133      * Emits a {Transfer} event.
1134      *
1135      * Requirements:
1136      *
1137      * - `sender` cannot be the zero address.
1138      * - `recipient` cannot be the zero address.
1139      * - `sender` must have a balance of at least `amount`.
1140      */
1141     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1142         require(sender != address(0), "ERC20: transfer from the zero address");
1143         require(recipient != address(0), "ERC20: transfer to the zero address");
1144 
1145         _beforeTokenTransfer(sender, recipient, amount);
1146 
1147         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1148         _balances[recipient] = _balances[recipient].add(amount);
1149         emit Transfer(sender, recipient, amount);
1150     }
1151 
1152     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1153      * the total supply.
1154      *
1155      * Emits a {Transfer} event with `from` set to the zero address.
1156      *
1157      * Requirements:
1158      *
1159      * - `to` cannot be the zero address.
1160      */
1161     function _mint(address account, uint256 amount) internal virtual {
1162         require(account != address(0), "ERC20: mint to the zero address");
1163 
1164         _beforeTokenTransfer(address(0), account, amount);
1165 
1166         _totalSupply = _totalSupply.add(amount);
1167         _balances[account] = _balances[account].add(amount);
1168         emit Transfer(address(0), account, amount);
1169     }
1170 
1171     /**
1172      * @dev Destroys `amount` tokens from `account`, reducing the
1173      * total supply.
1174      *
1175      * Emits a {Transfer} event with `to` set to the zero address.
1176      *
1177      * Requirements:
1178      *
1179      * - `account` cannot be the zero address.
1180      * - `account` must have at least `amount` tokens.
1181      */
1182     function _burn(address account, uint256 amount) internal virtual {
1183         require(account != address(0), "ERC20: burn from the zero address");
1184 
1185         _beforeTokenTransfer(account, address(0), amount);
1186 
1187         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1188         _totalSupply = _totalSupply.sub(amount);
1189         emit Transfer(account, address(0), amount);
1190     }
1191 
1192     /**
1193      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1194      *
1195      * This internal function is equivalent to `approve`, and can be used to
1196      * e.g. set automatic allowances for certain subsystems, etc.
1197      *
1198      * Emits an {Approval} event.
1199      *
1200      * Requirements:
1201      *
1202      * - `owner` cannot be the zero address.
1203      * - `spender` cannot be the zero address.
1204      */
1205     function _approve(address owner, address spender, uint256 amount) internal virtual {
1206         require(owner != address(0), "ERC20: approve from the zero address");
1207         require(spender != address(0), "ERC20: approve to the zero address");
1208 
1209         _allowances[owner][spender] = amount;
1210         emit Approval(owner, spender, amount);
1211     }
1212 
1213     /**
1214      * @dev Sets {decimals} to a value other than the default one of 18.
1215      *
1216      * WARNING: This function should only be called from the constructor. Most
1217      * applications that interact with token contracts will not expect
1218      * {decimals} to ever change, and may work incorrectly if it does.
1219      */
1220     function _setupDecimals(uint8 decimals_) internal {
1221         _decimals = decimals_;
1222     }
1223 
1224     /**
1225      * @dev Hook that is called before any transfer of tokens. This includes
1226      * minting and burning.
1227      *
1228      * Calling conditions:
1229      *
1230      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1231      * will be to transferred to `to`.
1232      * - when `from` is zero, `amount` tokens will be minted for `to`.
1233      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1234      * - `from` and `to` are never both zero.
1235      *
1236      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1237      */
1238     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1239 }
1240 // SPDX-License-Identifier: MIT
1241 
1242 
1243 
1244 /**
1245  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1246  * tokens and those that they have an allowance for, in a way that can be
1247  * recognized off-chain (via event analysis).
1248  */
1249 abstract contract ERC20Burnable is Context, ERC20 {
1250     using SafeMath for uint256;
1251 
1252     /**
1253      * @dev Destroys `amount` tokens from the caller.
1254      *
1255      * See {ERC20-_burn}.
1256      */
1257     function burn(uint256 amount) public virtual {
1258         _burn(_msgSender(), amount);
1259     }
1260 
1261     /**
1262      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1263      * allowance.
1264      *
1265      * See {ERC20-_burn} and {ERC20-allowance}.
1266      *
1267      * Requirements:
1268      *
1269      * - the caller must have allowance for ``accounts``'s tokens of at least
1270      * `amount`.
1271      */
1272     function burnFrom(address account, uint256 amount) public virtual {
1273         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1274 
1275         _approve(account, _msgSender(), decreasedAllowance);
1276         _burn(account, amount);
1277     }
1278 }
1279 // SPDX-License-Identifier: MIT
1280 
1281 
1282 /**
1283  * @dev Contract module which allows children to implement an emergency stop
1284  * mechanism that can be triggered by an authorized account.
1285  *
1286  * This module is used through inheritance. It will make available the
1287  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1288  * the functions of your contract. Note that they will not be pausable by
1289  * simply including this module, only once the modifiers are put in place.
1290  */
1291 abstract contract Pausable is Context {
1292     /**
1293      * @dev Emitted when the pause is triggered by `account`.
1294      */
1295     event Paused(address account);
1296 
1297     /**
1298      * @dev Emitted when the pause is lifted by `account`.
1299      */
1300     event Unpaused(address account);
1301 
1302     bool private _paused;
1303 
1304     /**
1305      * @dev Initializes the contract in unpaused state.
1306      */
1307     constructor () internal {
1308         _paused = false;
1309     }
1310 
1311     /**
1312      * @dev Returns true if the contract is paused, and false otherwise.
1313      */
1314     function paused() public view returns (bool) {
1315         return _paused;
1316     }
1317 
1318     /**
1319      * @dev Modifier to make a function callable only when the contract is not paused.
1320      *
1321      * Requirements:
1322      *
1323      * - The contract must not be paused.
1324      */
1325     modifier whenNotPaused() {
1326         require(!_paused, "Pausable: paused");
1327         _;
1328     }
1329 
1330     /**
1331      * @dev Modifier to make a function callable only when the contract is paused.
1332      *
1333      * Requirements:
1334      *
1335      * - The contract must be paused.
1336      */
1337     modifier whenPaused() {
1338         require(_paused, "Pausable: not paused");
1339         _;
1340     }
1341 
1342     /**
1343      * @dev Triggers stopped state.
1344      *
1345      * Requirements:
1346      *
1347      * - The contract must not be paused.
1348      */
1349     function _pause() internal virtual whenNotPaused {
1350         _paused = true;
1351         emit Paused(_msgSender());
1352     }
1353 
1354     /**
1355      * @dev Returns to normal state.
1356      *
1357      * Requirements:
1358      *
1359      * - The contract must be paused.
1360      */
1361     function _unpause() internal virtual whenPaused {
1362         _paused = false;
1363         emit Unpaused(_msgSender());
1364     }
1365 }
1366 // SPDX-License-Identifier: MIT
1367 
1368 
1369 
1370 /**
1371  * @dev ERC20 token with pausable token transfers, minting and burning.
1372  *
1373  * Useful for scenarios such as preventing trades until the end of an evaluation
1374  * period, or having an emergency switch for freezing all token transfers in the
1375  * event of a large bug.
1376  */
1377 abstract contract ERC20Pausable is ERC20, Pausable {
1378     /**
1379      * @dev See {ERC20-_beforeTokenTransfer}.
1380      *
1381      * Requirements:
1382      *
1383      * - the contract must not be paused.
1384      */
1385     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1386         super._beforeTokenTransfer(from, to, amount);
1387 
1388         require(!paused(), "ERC20Pausable: token transfer while paused");
1389     }
1390 }
1391 // SPDX-License-Identifier: MIT
1392 
1393 
1394 
1395 
1396 
1397 
1398 /**
1399  * @dev {ERC20} token, including:
1400  *
1401  *  - ability for holders to burn (destroy) their tokens
1402  *  - a minter role that allows for token minting (creation)
1403  *  - a pauser role that allows to stop all token transfers
1404  *
1405  * This contract uses {AccessControl} to lock permissioned functions using the
1406  * different roles - head to its documentation for details.
1407  *
1408  * The account that deploys the contract will be granted the minter and pauser
1409  * roles, as well as the default admin role, which will let it grant both minter
1410  * and pauser roles to other accounts.
1411  */
1412 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1413     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1414     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1415 
1416     /**
1417      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1418      * account that deploys the contract.
1419      *
1420      * See {ERC20-constructor}.
1421      */
1422     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1423         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1424 
1425         _setupRole(MINTER_ROLE, _msgSender());
1426         _setupRole(PAUSER_ROLE, _msgSender());
1427     }
1428 
1429     /**
1430      * @dev Creates `amount` new tokens for `to`.
1431      *
1432      * See {ERC20-_mint}.
1433      *
1434      * Requirements:
1435      *
1436      * - the caller must have the `MINTER_ROLE`.
1437      */
1438     function mint(address to, uint256 amount) public virtual {
1439         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1440         _mint(to, amount);
1441     }
1442 
1443     /**
1444      * @dev Pauses all token transfers.
1445      *
1446      * See {ERC20Pausable} and {Pausable-_pause}.
1447      *
1448      * Requirements:
1449      *
1450      * - the caller must have the `PAUSER_ROLE`.
1451      */
1452     function pause() public virtual {
1453         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1454         _pause();
1455     }
1456 
1457     /**
1458      * @dev Unpauses all token transfers.
1459      *
1460      * See {ERC20Pausable} and {Pausable-_unpause}.
1461      *
1462      * Requirements:
1463      *
1464      * - the caller must have the `PAUSER_ROLE`.
1465      */
1466     function unpause() public virtual {
1467         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1468         _unpause();
1469     }
1470 
1471     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1472         super._beforeTokenTransfer(from, to, amount);
1473     }
1474 }
1475 // SPDX-License-Identifier: MIT
1476 
1477 
1478 contract SpiderToken is ERC20PresetMinterPauser {
1479      constructor() public ERC20PresetMinterPauser("SpiderDAO Token", "SPDR") {}
1480 
1481      function removeMinterRole(address owner) external { 
1482           revokeRole(MINTER_ROLE, owner);
1483      }
1484 }