1 // File: contracts\utils\EnumerableSet.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.6.12;
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
246 // File: contracts\utils\Address.sol
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
270         // This method relies on extcodesize, which returns 0 for contracts in
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
333         return functionCallWithValue(target, data, 0, errorMessage);
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
359         require(isContract(target), "Address: call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.call{ value: value }(data);
363         return _verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a static call.
369      *
370      * _Available since v3.3._
371      */
372     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
373         return functionStaticCall(target, data, "Address: low-level static call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
383         require(isContract(target), "Address: static call to non-contract");
384 
385         // solhint-disable-next-line avoid-low-level-calls
386         (bool success, bytes memory returndata) = target.staticcall(data);
387         return _verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.3._
395      */
396     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.3._
405      */
406     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         // solhint-disable-next-line avoid-low-level-calls
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return _verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
415         if (success) {
416             return returndata;
417         } else {
418             // Look for revert reason and bubble it up if present
419             if (returndata.length > 0) {
420                 // The easiest way to bubble the revert reason is using memory via assembly
421 
422                 // solhint-disable-next-line no-inline-assembly
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 // File: contracts\GSN\Context.sol
435 
436 /*
437  * @dev Provides information about the current execution context, including the
438  * sender of the transaction and its data. While these are generally available
439  * via msg.sender and msg.data, they should not be accessed in such a direct
440  * manner, since when dealing with GSN meta-transactions the account sending and
441  * paying for execution may not be the actual sender (as far as an application
442  * is concerned).
443  *
444  * This contract is only required for intermediate, library-like contracts.
445  */
446 abstract contract Context {
447     function _msgSender() internal view virtual returns (address payable) {
448         return msg.sender;
449     }
450 
451     function _msgData() internal view virtual returns (bytes memory) {
452         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
453         return msg.data;
454     }
455 }
456 
457 // File: contracts\access\AccessControl.sol
458 
459 /**
460  * @dev Contract module that allows children to implement role-based access
461  * control mechanisms.
462  *
463  * Roles are referred to by their `bytes32` identifier. These should be exposed
464  * in the external API and be unique. The best way to achieve this is by
465  * using `public constant` hash digests:
466  *
467  * ```
468  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
469  * ```
470  *
471  * Roles can be used to represent a set of permissions. To restrict access to a
472  * function call, use {hasRole}:
473  *
474  * ```
475  * function foo() public {
476  *     require(hasRole(MY_ROLE, msg.sender));
477  *     ...
478  * }
479  * ```
480  *
481  * Roles can be granted and revoked dynamically via the {grantRole} and
482  * {revokeRole} functions. Each role has an associated admin role, and only
483  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
484  *
485  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
486  * that only accounts with this role will be able to grant or revoke other
487  * roles. More complex role relationships can be created by using
488  * {_setRoleAdmin}.
489  *
490  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
491  * grant and revoke this role. Extra precautions should be taken to secure
492  * accounts that have been granted it.
493  */
494 abstract contract AccessControl is Context {
495     using EnumerableSet for EnumerableSet.AddressSet;
496     using Address for address;
497 
498     struct RoleData {
499         EnumerableSet.AddressSet members;
500         bytes32 adminRole;
501     }
502 
503     mapping (bytes32 => RoleData) private _roles;
504 
505     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
506 
507     /**
508      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
509      *
510      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
511      * {RoleAdminChanged} not being emitted signaling this.
512      *
513      * _Available since v3.1._
514      */
515     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
516 
517     /**
518      * @dev Emitted when `account` is granted `role`.
519      *
520      * `sender` is the account that originated the contract call, an admin role
521      * bearer except when using {_setupRole}.
522      */
523     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
524 
525     /**
526      * @dev Emitted when `account` is revoked `role`.
527      *
528      * `sender` is the account that originated the contract call:
529      *   - if using `revokeRole`, it is the admin role bearer
530      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
531      */
532     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
533 
534     /**
535      * @dev Returns `true` if `account` has been granted `role`.
536      */
537     function hasRole(bytes32 role, address account) public view returns (bool) {
538         return _roles[role].members.contains(account);
539     }
540 
541     /**
542      * @dev Returns the number of accounts that have `role`. Can be used
543      * together with {getRoleMember} to enumerate all bearers of a role.
544      */
545     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
546         return _roles[role].members.length();
547     }
548 
549     /**
550      * @dev Returns one of the accounts that have `role`. `index` must be a
551      * value between 0 and {getRoleMemberCount}, non-inclusive.
552      *
553      * Role bearers are not sorted in any particular way, and their ordering may
554      * change at any point.
555      *
556      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
557      * you perform all queries on the same block. See the following
558      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
559      * for more information.
560      */
561     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
562         return _roles[role].members.at(index);
563     }
564 
565     /**
566      * @dev Returns the admin role that controls `role`. See {grantRole} and
567      * {revokeRole}.
568      *
569      * To change a role's admin, use {_setRoleAdmin}.
570      */
571     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
572         return _roles[role].adminRole;
573     }
574 
575     /**
576      * @dev Grants `role` to `account`.
577      *
578      * If `account` had not been already granted `role`, emits a {RoleGranted}
579      * event.
580      *
581      * Requirements:
582      *
583      * - the caller must have ``role``'s admin role.
584      */
585     function grantRole(bytes32 role, address account) public virtual {
586         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
587 
588         _grantRole(role, account);
589     }
590 
591     /**
592      * @dev Revokes `role` from `account`.
593      *
594      * If `account` had been granted `role`, emits a {RoleRevoked} event.
595      *
596      * Requirements:
597      *
598      * - the caller must have ``role``'s admin role.
599      */
600     function revokeRole(bytes32 role, address account) public virtual {
601         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
602 
603         _revokeRole(role, account);
604     }
605 
606     /**
607      * @dev Revokes `role` from the calling account.
608      *
609      * Roles are often managed via {grantRole} and {revokeRole}: this function's
610      * purpose is to provide a mechanism for accounts to lose their privileges
611      * if they are compromised (such as when a trusted device is misplaced).
612      *
613      * If the calling account had been granted `role`, emits a {RoleRevoked}
614      * event.
615      *
616      * Requirements:
617      *
618      * - the caller must be `account`.
619      */
620     function renounceRole(bytes32 role, address account) public virtual {
621         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
622 
623         _revokeRole(role, account);
624     }
625 
626     /**
627      * @dev Grants `role` to `account`.
628      *
629      * If `account` had not been already granted `role`, emits a {RoleGranted}
630      * event. Note that unlike {grantRole}, this function doesn't perform any
631      * checks on the calling account.
632      *
633      * [WARNING]
634      * ====
635      * This function should only be called from the constructor when setting
636      * up the initial roles for the system.
637      *
638      * Using this function in any other way is effectively circumventing the admin
639      * system imposed by {AccessControl}.
640      * ====
641      */
642     function _setupRole(bytes32 role, address account) internal virtual {
643         _grantRole(role, account);
644     }
645 
646     /**
647      * @dev Sets `adminRole` as ``role``'s admin role.
648      *
649      * Emits a {RoleAdminChanged} event.
650      */
651     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
652         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
653         _roles[role].adminRole = adminRole;
654     }
655 
656     function _grantRole(bytes32 role, address account) private {
657         if (_roles[role].members.add(account)) {
658             emit RoleGranted(role, account, _msgSender());
659         }
660     }
661 
662     function _revokeRole(bytes32 role, address account) private {
663         if (_roles[role].members.remove(account)) {
664             emit RoleRevoked(role, account, _msgSender());
665         }
666     }
667 }
668 
669 // File: contracts\math\SafeMath.sol
670 
671 /**
672  * @dev Wrappers over Solidity's arithmetic operations with added overflow
673  * checks.
674  *
675  * Arithmetic operations in Solidity wrap on overflow. This can easily result
676  * in bugs, because programmers usually assume that an overflow raises an
677  * error, which is the standard behavior in high level programming languages.
678  * `SafeMath` restores this intuition by reverting the transaction when an
679  * operation overflows.
680  *
681  * Using this library instead of the unchecked operations eliminates an entire
682  * class of bugs, so it's recommended to use it always.
683  */
684 library SafeMath {
685     /**
686      * @dev Returns the addition of two unsigned integers, reverting on
687      * overflow.
688      *
689      * Counterpart to Solidity's `+` operator.
690      *
691      * Requirements:
692      *
693      * - Addition cannot overflow.
694      */
695     function add(uint256 a, uint256 b) internal pure returns (uint256) {
696         uint256 c = a + b;
697         require(c >= a, "SafeMath: addition overflow");
698 
699         return c;
700     }
701 
702     /**
703      * @dev Returns the subtraction of two unsigned integers, reverting on
704      * overflow (when the result is negative).
705      *
706      * Counterpart to Solidity's `-` operator.
707      *
708      * Requirements:
709      *
710      * - Subtraction cannot overflow.
711      */
712     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
713         return sub(a, b, "SafeMath: subtraction overflow");
714     }
715 
716     /**
717      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
718      * overflow (when the result is negative).
719      *
720      * Counterpart to Solidity's `-` operator.
721      *
722      * Requirements:
723      *
724      * - Subtraction cannot overflow.
725      */
726     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
727         require(b <= a, errorMessage);
728         uint256 c = a - b;
729 
730         return c;
731     }
732 
733     /**
734      * @dev Returns the multiplication of two unsigned integers, reverting on
735      * overflow.
736      *
737      * Counterpart to Solidity's `*` operator.
738      *
739      * Requirements:
740      *
741      * - Multiplication cannot overflow.
742      */
743     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
744         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
745         // benefit is lost if 'b' is also tested.
746         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
747         if (a == 0) {
748             return 0;
749         }
750 
751         uint256 c = a * b;
752         require(c / a == b, "SafeMath: multiplication overflow");
753 
754         return c;
755     }
756 
757     /**
758      * @dev Returns the integer division of two unsigned integers. Reverts on
759      * division by zero. The result is rounded towards zero.
760      *
761      * Counterpart to Solidity's `/` operator. Note: this function uses a
762      * `revert` opcode (which leaves remaining gas untouched) while Solidity
763      * uses an invalid opcode to revert (consuming all remaining gas).
764      *
765      * Requirements:
766      *
767      * - The divisor cannot be zero.
768      */
769     function div(uint256 a, uint256 b) internal pure returns (uint256) {
770         return div(a, b, "SafeMath: division by zero");
771     }
772 
773     /**
774      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
775      * division by zero. The result is rounded towards zero.
776      *
777      * Counterpart to Solidity's `/` operator. Note: this function uses a
778      * `revert` opcode (which leaves remaining gas untouched) while Solidity
779      * uses an invalid opcode to revert (consuming all remaining gas).
780      *
781      * Requirements:
782      *
783      * - The divisor cannot be zero.
784      */
785     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
786         require(b > 0, errorMessage);
787         uint256 c = a / b;
788         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
789 
790         return c;
791     }
792 
793     /**
794      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
795      * Reverts when dividing by zero.
796      *
797      * Counterpart to Solidity's `%` operator. This function uses a `revert`
798      * opcode (which leaves remaining gas untouched) while Solidity uses an
799      * invalid opcode to revert (consuming all remaining gas).
800      *
801      * Requirements:
802      *
803      * - The divisor cannot be zero.
804      */
805     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
806         return mod(a, b, "SafeMath: modulo by zero");
807     }
808 
809     /**
810      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
811      * Reverts with custom message when dividing by zero.
812      *
813      * Counterpart to Solidity's `%` operator. This function uses a `revert`
814      * opcode (which leaves remaining gas untouched) while Solidity uses an
815      * invalid opcode to revert (consuming all remaining gas).
816      *
817      * Requirements:
818      *
819      * - The divisor cannot be zero.
820      */
821     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
822         require(b != 0, errorMessage);
823         return a % b;
824     }
825 }
826 
827 // File: contracts\utils\Counters.sol
828 
829 /**
830  * @title Counters
831  * @author Matt Condon (@shrugs)
832  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
833  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
834  *
835  * Include with `using Counters for Counters.Counter;`
836  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
837  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
838  * directly accessed.
839  */
840 library Counters {
841     using SafeMath for uint256;
842 
843     struct Counter {
844         // This variable should never be directly accessed by users of the library: interactions must be restricted to
845         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
846         // this feature: see https://github.com/ethereum/solidity/issues/4637
847         uint256 _value; // default: 0
848     }
849 
850     function current(Counter storage counter) internal view returns (uint256) {
851         return counter._value;
852     }
853 
854     function increment(Counter storage counter) internal {
855         // The {SafeMath} overflow check can be skipped here, see the comment at the top
856         counter._value += 1;
857     }
858 
859     function decrement(Counter storage counter) internal {
860         counter._value = counter._value.sub(1);
861     }
862 }
863 
864 // File: contracts\introspection\IERC165.sol
865 
866 /**
867  * @dev Interface of the ERC165 standard, as defined in the
868  * https://eips.ethereum.org/EIPS/eip-165[EIP].
869  *
870  * Implementers can declare support of contract interfaces, which can then be
871  * queried by others ({ERC165Checker}).
872  *
873  * For an implementation, see {ERC165}.
874  */
875 interface IERC165 {
876     /**
877      * @dev Returns true if this contract implements the interface defined by
878      * `interfaceId`. See the corresponding
879      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
880      * to learn more about how these ids are created.
881      *
882      * This function call must use less than 30 000 gas.
883      */
884     function supportsInterface(bytes4 interfaceId) external view returns (bool);
885 }
886 
887 // File: contracts\token\ERC721\IERC721.sol
888 
889 /**
890  * @dev Required interface of an ERC721 compliant contract.
891  */
892 interface IERC721 is IERC165 {
893     /**
894      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
895      */
896     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
897 
898     /**
899      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
900      */
901     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
902 
903     /**
904      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
905      */
906     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
907 
908     /**
909      * @dev Returns the number of tokens in ``owner``'s account.
910      */
911     function balanceOf(address owner) external view returns (uint256 balance);
912 
913     /**
914      * @dev Returns the owner of the `tokenId` token.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      */
920     function ownerOf(uint256 tokenId) external view returns (address owner);
921 
922     /**
923      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
924      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
925      *
926      * Requirements:
927      *
928      * - `from` cannot be the zero address.
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must exist and be owned by `from`.
931      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
932      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
933      *
934      * Emits a {Transfer} event.
935      */
936     function safeTransferFrom(address from, address to, uint256 tokenId) external;
937 
938     /**
939      * @dev Transfers `tokenId` token from `from` to `to`.
940      *
941      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
942      *
943      * Requirements:
944      *
945      * - `from` cannot be the zero address.
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must be owned by `from`.
948      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
949      *
950      * Emits a {Transfer} event.
951      */
952     function transferFrom(address from, address to, uint256 tokenId) external;
953 
954     /**
955      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
956      * The approval is cleared when the token is transferred.
957      *
958      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
959      *
960      * Requirements:
961      *
962      * - The caller must own the token or be an approved operator.
963      * - `tokenId` must exist.
964      *
965      * Emits an {Approval} event.
966      */
967     function approve(address to, uint256 tokenId) external;
968 
969     /**
970      * @dev Returns the account approved for `tokenId` token.
971      *
972      * Requirements:
973      *
974      * - `tokenId` must exist.
975      */
976     function getApproved(uint256 tokenId) external view returns (address operator);
977 
978     /**
979      * @dev Approve or remove `operator` as an operator for the caller.
980      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
981      *
982      * Requirements:
983      *
984      * - The `operator` cannot be the caller.
985      *
986      * Emits an {ApprovalForAll} event.
987      */
988     function setApprovalForAll(address operator, bool _approved) external;
989 
990     /**
991      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
992      *
993      * See {setApprovalForAll}
994      */
995     function isApprovedForAll(address owner, address operator) external view returns (bool);
996 
997     /**
998       * @dev Safely transfers `tokenId` token from `from` to `to`.
999       *
1000       * Requirements:
1001       *
1002      * - `from` cannot be the zero address.
1003      * - `to` cannot be the zero address.
1004       * - `tokenId` token must exist and be owned by `from`.
1005       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1006       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1007       *
1008       * Emits a {Transfer} event.
1009       */
1010     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1011 }
1012 
1013 // File: contracts\token\ERC721\IERC721Metadata.sol
1014 
1015 /**
1016  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1017  * @dev See https://eips.ethereum.org/EIPS/eip-721
1018  */
1019 interface IERC721Metadata is IERC721 {
1020 
1021     /**
1022      * @dev Returns the token collection name.
1023      */
1024     function name() external view returns (string memory);
1025 
1026     /**
1027      * @dev Returns the token collection symbol.
1028      */
1029     function symbol() external view returns (string memory);
1030 
1031     /**
1032      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1033      */
1034     function tokenURI(uint256 tokenId) external view returns (string memory);
1035 }
1036 
1037 // File: contracts\token\ERC721\IERC721Enumerable.sol
1038 
1039 /**
1040  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1041  * @dev See https://eips.ethereum.org/EIPS/eip-721
1042  */
1043 interface IERC721Enumerable is IERC721 {
1044 
1045     /**
1046      * @dev Returns the total amount of tokens stored by the contract.
1047      */
1048     function totalSupply() external view returns (uint256);
1049 
1050     /**
1051      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1052      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1053      */
1054     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1055 
1056     /**
1057      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1058      * Use along with {totalSupply} to enumerate all tokens.
1059      */
1060     function tokenByIndex(uint256 index) external view returns (uint256);
1061 }
1062 
1063 // File: contracts\token\ERC721\IERC721Receiver.sol
1064 
1065 /**
1066  * @title ERC721 token receiver interface
1067  * @dev Interface for any contract that wants to support safeTransfers
1068  * from ERC721 asset contracts.
1069  */
1070 interface IERC721Receiver {
1071     /**
1072      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1073      * by `operator` from `from`, this function is called.
1074      *
1075      * It must return its Solidity selector to confirm the token transfer.
1076      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1077      *
1078      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1079      */
1080     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1081 }
1082 
1083 // File: contracts\introspection\ERC165.sol
1084 
1085 /**
1086  * @dev Implementation of the {IERC165} interface.
1087  *
1088  * Contracts may inherit from this and call {_registerInterface} to declare
1089  * their support of an interface.
1090  */
1091 contract ERC165 is IERC165 {
1092     /*
1093      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1094      */
1095     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1096 
1097     /**
1098      * @dev Mapping of interface ids to whether or not it's supported.
1099      */
1100     mapping(bytes4 => bool) private _supportedInterfaces;
1101 
1102     constructor () internal {
1103         // Derived contracts need only register support for their own interfaces,
1104         // we register support for ERC165 itself here
1105         _registerInterface(_INTERFACE_ID_ERC165);
1106     }
1107 
1108     /**
1109      * @dev See {IERC165-supportsInterface}.
1110      *
1111      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1112      */
1113     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1114         return _supportedInterfaces[interfaceId];
1115     }
1116 
1117     /**
1118      * @dev Registers the contract as an implementer of the interface defined by
1119      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1120      * registering its interface id is not required.
1121      *
1122      * See {IERC165-supportsInterface}.
1123      *
1124      * Requirements:
1125      *
1126      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1127      */
1128     function _registerInterface(bytes4 interfaceId) internal virtual {
1129         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1130         _supportedInterfaces[interfaceId] = true;
1131     }
1132 }
1133 
1134 // File: contracts\utils\EnumerableMap.sol
1135 
1136 /**
1137  * @dev Library for managing an enumerable variant of Solidity's
1138  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1139  * type.
1140  *
1141  * Maps have the following properties:
1142  *
1143  * - Entries are added, removed, and checked for existence in constant time
1144  * (O(1)).
1145  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1146  *
1147  * ```
1148  * contract Example {
1149  *     // Add the library methods
1150  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1151  *
1152  *     // Declare a set state variable
1153  *     EnumerableMap.UintToAddressMap private myMap;
1154  * }
1155  * ```
1156  *
1157  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1158  * supported.
1159  */
1160 library EnumerableMap {
1161     // To implement this library for multiple types with as little code
1162     // repetition as possible, we write it in terms of a generic Map type with
1163     // bytes32 keys and values.
1164     // The Map implementation uses private functions, and user-facing
1165     // implementations (such as Uint256ToAddressMap) are just wrappers around
1166     // the underlying Map.
1167     // This means that we can only create new EnumerableMaps for types that fit
1168     // in bytes32.
1169 
1170     struct MapEntry {
1171         bytes32 _key;
1172         bytes32 _value;
1173     }
1174 
1175     struct Map {
1176         // Storage of map keys and values
1177         MapEntry[] _entries;
1178 
1179         // Position of the entry defined by a key in the `entries` array, plus 1
1180         // because index 0 means a key is not in the map.
1181         mapping (bytes32 => uint256) _indexes;
1182     }
1183 
1184     /**
1185      * @dev Adds a key-value pair to a map, or updates the value for an existing
1186      * key. O(1).
1187      *
1188      * Returns true if the key was added to the map, that is if it was not
1189      * already present.
1190      */
1191     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1192         // We read and store the key's index to prevent multiple reads from the same storage slot
1193         uint256 keyIndex = map._indexes[key];
1194 
1195         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1196             map._entries.push(MapEntry({ _key: key, _value: value }));
1197             // The entry is stored at length-1, but we add 1 to all indexes
1198             // and use 0 as a sentinel value
1199             map._indexes[key] = map._entries.length;
1200             return true;
1201         } else {
1202             map._entries[keyIndex - 1]._value = value;
1203             return false;
1204         }
1205     }
1206 
1207     /**
1208      * @dev Removes a key-value pair from a map. O(1).
1209      *
1210      * Returns true if the key was removed from the map, that is if it was present.
1211      */
1212     function _remove(Map storage map, bytes32 key) private returns (bool) {
1213         // We read and store the key's index to prevent multiple reads from the same storage slot
1214         uint256 keyIndex = map._indexes[key];
1215 
1216         if (keyIndex != 0) { // Equivalent to contains(map, key)
1217             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1218             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1219             // This modifies the order of the array, as noted in {at}.
1220 
1221             uint256 toDeleteIndex = keyIndex - 1;
1222             uint256 lastIndex = map._entries.length - 1;
1223 
1224             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1225             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1226 
1227             MapEntry storage lastEntry = map._entries[lastIndex];
1228 
1229             // Move the last entry to the index where the entry to delete is
1230             map._entries[toDeleteIndex] = lastEntry;
1231             // Update the index for the moved entry
1232             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1233 
1234             // Delete the slot where the moved entry was stored
1235             map._entries.pop();
1236 
1237             // Delete the index for the deleted slot
1238             delete map._indexes[key];
1239 
1240             return true;
1241         } else {
1242             return false;
1243         }
1244     }
1245 
1246     /**
1247      * @dev Returns true if the key is in the map. O(1).
1248      */
1249     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1250         return map._indexes[key] != 0;
1251     }
1252 
1253     /**
1254      * @dev Returns the number of key-value pairs in the map. O(1).
1255      */
1256     function _length(Map storage map) private view returns (uint256) {
1257         return map._entries.length;
1258     }
1259 
1260    /**
1261     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1262     *
1263     * Note that there are no guarantees on the ordering of entries inside the
1264     * array, and it may change when more entries are added or removed.
1265     *
1266     * Requirements:
1267     *
1268     * - `index` must be strictly less than {length}.
1269     */
1270     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1271         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1272 
1273         MapEntry storage entry = map._entries[index];
1274         return (entry._key, entry._value);
1275     }
1276 
1277     /**
1278      * @dev Returns the value associated with `key`.  O(1).
1279      *
1280      * Requirements:
1281      *
1282      * - `key` must be in the map.
1283      */
1284     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1285         return _get(map, key, "EnumerableMap: nonexistent key");
1286     }
1287 
1288     /**
1289      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1290      */
1291     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1292         uint256 keyIndex = map._indexes[key];
1293         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1294         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1295     }
1296 
1297     // UintToAddressMap
1298 
1299     struct UintToAddressMap {
1300         Map _inner;
1301     }
1302 
1303     /**
1304      * @dev Adds a key-value pair to a map, or updates the value for an existing
1305      * key. O(1).
1306      *
1307      * Returns true if the key was added to the map, that is if it was not
1308      * already present.
1309      */
1310     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1311         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1312     }
1313 
1314     /**
1315      * @dev Removes a value from a set. O(1).
1316      *
1317      * Returns true if the key was removed from the map, that is if it was present.
1318      */
1319     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1320         return _remove(map._inner, bytes32(key));
1321     }
1322 
1323     /**
1324      * @dev Returns true if the key is in the map. O(1).
1325      */
1326     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1327         return _contains(map._inner, bytes32(key));
1328     }
1329 
1330     /**
1331      * @dev Returns the number of elements in the map. O(1).
1332      */
1333     function length(UintToAddressMap storage map) internal view returns (uint256) {
1334         return _length(map._inner);
1335     }
1336 
1337    /**
1338     * @dev Returns the element stored at position `index` in the set. O(1).
1339     * Note that there are no guarantees on the ordering of values inside the
1340     * array, and it may change when more values are added or removed.
1341     *
1342     * Requirements:
1343     *
1344     * - `index` must be strictly less than {length}.
1345     */
1346     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1347         (bytes32 key, bytes32 value) = _at(map._inner, index);
1348         return (uint256(key), address(uint256(value)));
1349     }
1350 
1351     /**
1352      * @dev Returns the value associated with `key`.  O(1).
1353      *
1354      * Requirements:
1355      *
1356      * - `key` must be in the map.
1357      */
1358     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1359         return address(uint256(_get(map._inner, bytes32(key))));
1360     }
1361 
1362     /**
1363      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1364      */
1365     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1366         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1367     }
1368 }
1369 
1370 // File: contracts\utils\Strings.sol
1371 
1372 /**
1373  * @dev String operations.
1374  */
1375 library Strings {
1376     /**
1377      * @dev Converts a `uint256` to its ASCII `string` representation.
1378      */
1379     function toString(uint256 value) internal pure returns (string memory) {
1380         // Inspired by OraclizeAPI's implementation - MIT licence
1381         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1382 
1383         if (value == 0) {
1384             return "0";
1385         }
1386         uint256 temp = value;
1387         uint256 digits;
1388         while (temp != 0) {
1389             digits++;
1390             temp /= 10;
1391         }
1392         bytes memory buffer = new bytes(digits);
1393         uint256 index = digits - 1;
1394         temp = value;
1395         while (temp != 0) {
1396             buffer[index--] = byte(uint8(48 + temp % 10));
1397             temp /= 10;
1398         }
1399         return string(buffer);
1400     }
1401 }
1402 
1403 // File: contracts\token\ERC721\ERC721.sol
1404 
1405 /**
1406  * @title ERC721 Non-Fungible Token Standard basic implementation
1407  * @dev see https://eips.ethereum.org/EIPS/eip-721
1408  */
1409 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1410     using SafeMath for uint256;
1411     using Address for address;
1412     using EnumerableSet for EnumerableSet.UintSet;
1413     using EnumerableMap for EnumerableMap.UintToAddressMap;
1414     using Strings for uint256;
1415     mapping (address => bool) public whitelists;
1416 
1417     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1418     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1419     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1420 
1421     // mapping (address => bool) public whitelists;
1422 
1423     // Mapping from holder address to their (enumerable) set of owned tokens
1424     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1425 
1426     // Enumerable mapping from token ids to their owners
1427     EnumerableMap.UintToAddressMap private _tokenOwners;
1428 
1429     // Mapping from token ID to approved address
1430     mapping (uint256 => address) private _tokenApprovals;
1431 
1432     // Mapping from owner to operator approvals
1433     mapping (address => mapping (address => bool)) private _operatorApprovals;
1434 
1435     // Token name
1436     string private _name;
1437 
1438     // Token symbol
1439     string private _symbol;
1440 
1441     // Optional mapping for token URIs
1442     mapping (uint256 => string) private _tokenURIs;
1443 
1444     // Base URI
1445     string private _baseURI;
1446 
1447     /*
1448      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1449      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1450      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1451      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1452      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1453      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1454      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1455      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1456      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1457      *
1458      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1459      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1460      */
1461     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1462 
1463     /*
1464      *     bytes4(keccak256('name()')) == 0x06fdde03
1465      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1466      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1467      *
1468      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1469      */
1470     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1471 
1472     /*
1473      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1474      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1475      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1476      *
1477      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1478      */
1479     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1480 
1481     /**
1482      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1483      */
1484     constructor (string memory name, string memory symbol) public {
1485         _name = name;
1486         _symbol = symbol;
1487 
1488         // register the supported interfaces to conform to ERC721 via ERC165
1489         _registerInterface(_INTERFACE_ID_ERC721);
1490         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1491         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1492     }
1493 
1494     /**
1495      * @dev See {IERC721-balanceOf}.
1496      */
1497     function balanceOf(address owner) public view override returns (uint256) {
1498         require(owner != address(0), "ERC721: balance query for the zero address");
1499 
1500         return _holderTokens[owner].length();
1501     }
1502 
1503     /**
1504      * @dev See {IERC721-ownerOf}.
1505      */
1506     function ownerOf(uint256 tokenId) public view override returns (address) {
1507         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1508     }
1509 
1510     /**
1511      * @dev See {IERC721Metadata-name}.
1512      */
1513     function name() public view override returns (string memory) {
1514         return _name;
1515     }
1516 
1517     /**
1518      * @dev See {IERC721Metadata-symbol}.
1519      */
1520     function symbol() public view override returns (string memory) {
1521         return _symbol;
1522     }
1523 
1524     /**
1525      * @dev See {IERC721Metadata-tokenURI}.
1526      */
1527     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1528         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1529 
1530         string memory _tokenURI = _tokenURIs[tokenId];
1531 
1532         // If there is no base URI, return the token URI.
1533         if (bytes(_baseURI).length == 0) {
1534             return _tokenURI;
1535         }
1536         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1537         if (bytes(_tokenURI).length > 0) {
1538             return string(abi.encodePacked(_baseURI, _tokenURI));
1539         }
1540         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1541         return string(abi.encodePacked(_baseURI, tokenId.toString(), ".json"));
1542     }
1543 
1544     /**
1545     * @dev Returns the base URI set via {_setBaseURI}. This will be
1546     * automatically added as a prefix in {tokenURI} to each token's URI, or
1547     * to the token ID if no specific URI is set for that token ID.
1548     */
1549     function baseURI() public view returns (string memory) {
1550         return _baseURI;
1551     }
1552 
1553     /**
1554      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1555      */
1556     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1557         return _holderTokens[owner].at(index);
1558     }
1559 
1560     /**
1561      * @dev See {IERC721Enumerable-totalSupply}.
1562      */
1563     function totalSupply() public view override returns (uint256) {
1564         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1565         return _tokenOwners.length();
1566     }
1567 
1568     /**
1569      * @dev See {IERC721Enumerable-tokenByIndex}.
1570      */
1571     function tokenByIndex(uint256 index) public view override returns (uint256) {
1572         (uint256 tokenId, ) = _tokenOwners.at(index);
1573         return tokenId;
1574     }
1575 
1576     /**
1577      * @dev See {IERC721-approve}.
1578      */
1579     function approve(address to, uint256 tokenId) public virtual override {
1580         address owner = ownerOf(tokenId);
1581         require(to != owner, "ERC721: approval to current owner");
1582 
1583         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1584             "ERC721: approve caller is not owner nor approved for all"
1585         );
1586 
1587         _approve(to, tokenId);
1588     }
1589 
1590     /**
1591      * @dev See {IERC721-getApproved}.
1592      */
1593     function getApproved(uint256 tokenId) public view override returns (address) {
1594         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1595 
1596         return _tokenApprovals[tokenId];
1597     }
1598 
1599     /**
1600      * @dev See {IERC721-setApprovalForAll}.
1601      */
1602     function setApprovalForAll(address operator, bool approved) public virtual override {
1603         require(operator != _msgSender(), "ERC721: approve to caller");
1604 
1605         _operatorApprovals[_msgSender()][operator] = approved;
1606         emit ApprovalForAll(_msgSender(), operator, approved);
1607     }
1608 
1609     /**
1610      * @dev See {IERC721-isApprovedForAll}.
1611      */
1612     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1613         return _operatorApprovals[owner][operator];
1614     }
1615 
1616     /**
1617      * @dev See {IERC721-transferFrom}.
1618      */
1619     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1620         //solhint-disable-next-line max-line-length
1621         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1622 
1623         _transfer(from, to, tokenId);
1624     }
1625 
1626     /**
1627      * @dev See {IERC721-safeTransferFrom}.
1628      */
1629     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1630         safeTransferFrom(from, to, tokenId, "");
1631     }
1632 
1633     /**
1634      * @dev See {IERC721-safeTransferFrom}.
1635      */
1636     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1637         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1638         _safeTransfer(from, to, tokenId, _data);
1639     }
1640 
1641     /**
1642      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1643      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1644      *
1645      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1646      *
1647      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1648      * implement alternative mechanisms to perform token transfer, such as signature-based.
1649      *
1650      * Requirements:
1651      *
1652      * - `from` cannot be the zero address.
1653      * - `to` cannot be the zero address.
1654      * - `tokenId` token must exist and be owned by `from`.
1655      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1656      *
1657      * Emits a {Transfer} event.
1658      */
1659     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1660         _transfer(from, to, tokenId);
1661         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1662     }
1663 
1664     /**
1665      * @dev Returns whether `tokenId` exists.
1666      *
1667      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1668      *
1669      * Tokens start existing when they are minted (`_mint`),
1670      * and stop existing when they are burned (`_burn`).
1671      */
1672     function _exists(uint256 tokenId) internal view returns (bool) {
1673         return _tokenOwners.contains(tokenId);
1674     }
1675 
1676     /**
1677      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1678      *
1679      * Requirements:
1680      *
1681      * - `tokenId` must exist.
1682      */
1683     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1684         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1685         address owner = ownerOf(tokenId);
1686         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1687     }
1688 
1689     /**
1690      * @dev Safely mints `tokenId` and transfers it to `to`.
1691      *
1692      * Requirements:
1693      d*
1694      * - `tokenId` must not exist.
1695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1696      *
1697      * Emits a {Transfer} event.
1698      */
1699     function _safeMint(address to, uint256 tokenId) internal virtual {
1700         _safeMint(to, tokenId, "");
1701     }
1702 
1703     /**
1704      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1705      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1706      */
1707     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1708         _mint(to, tokenId);
1709         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1710     }
1711 
1712     /**
1713      * @dev Mints `tokenId` and transfers it to `to`.
1714      *
1715      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1716      *
1717      * Requirements:
1718      *
1719      * - `tokenId` must not exist.
1720      * - `to` cannot be the zero address.
1721      *
1722      * Emits a {Transfer} event.
1723      */
1724     function _mint(address to, uint256 tokenId) internal virtual {
1725         require(to != address(0), "ERC721: mint to the zero address");
1726         require(!_exists(tokenId), "ERC721: token already minted");
1727 
1728         _beforeTokenTransfer(address(0), to, tokenId);
1729 
1730         _holderTokens[to].add(tokenId);
1731 
1732         _tokenOwners.set(tokenId, to);
1733 
1734         emit Transfer(address(0), to, tokenId);
1735     }
1736 
1737     /**
1738      * @dev Destroys `tokenId`.
1739      * The approval is cleared when the token is burned.
1740      *
1741      * Requirements:
1742      *
1743      * - `tokenId` must exist.
1744      *
1745      * Emits a {Transfer} event.
1746      */
1747     function _burn(uint256 tokenId) internal virtual {
1748         address owner = ownerOf(tokenId);
1749 
1750         _beforeTokenTransfer(owner, address(0), tokenId);
1751 
1752         // Clear approvals
1753         _approve(address(0), tokenId);
1754 
1755         // Clear metadata (if any)
1756         if (bytes(_tokenURIs[tokenId]).length != 0) {
1757             delete _tokenURIs[tokenId];
1758         }
1759 
1760         _holderTokens[owner].remove(tokenId);
1761 
1762         _tokenOwners.remove(tokenId);
1763 
1764         emit Transfer(owner, address(0), tokenId);
1765     }
1766 
1767     /**
1768      * @dev Transfers `tokenId` from `from` to `to`.
1769      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1770      *
1771      * Requirements:
1772      *
1773      * - `to` cannot be the zero address.
1774      * - `tokenId` token must be owned by `from`.
1775      *
1776      * Emits a {Transfer} event.
1777      */
1778     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1779         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1780         require(to != address(0), "ERC721: transfer to the zero address");
1781 
1782         _beforeTokenTransfer(from, to, tokenId);
1783 
1784         // Clear approvals from the previous owner
1785         _approve(address(0), tokenId);
1786 
1787         _holderTokens[from].remove(tokenId);
1788         _holderTokens[to].add(tokenId);
1789 
1790         _tokenOwners.set(tokenId, to);
1791 
1792         emit Transfer(from, to, tokenId);
1793     }
1794 
1795     /**
1796      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1797      *
1798      * Requirements:
1799      *
1800      * - `tokenId` must exist.
1801      */
1802     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1803         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1804         _tokenURIs[tokenId] = _tokenURI;
1805     }
1806 
1807     /**
1808      * @dev Internal function to set the base URI for all token IDs. It is
1809      * automatically added as a prefix to the value returned in {tokenURI},
1810      * or to the token ID if {tokenURI} is empty.
1811      */
1812     function _setBaseURI(string memory baseURI_) internal virtual {
1813         _baseURI = baseURI_;
1814     }
1815 
1816     /**
1817      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1818      * The call is not executed if the target address is not a contract.
1819      *
1820      * @param from address representing the previous owner of the given token ID
1821      * @param to target address that will receive the tokens
1822      * @param tokenId uint256 ID of the token to be transferred
1823      * @param _data bytes optional data to send along with the call
1824      * @return bool whether the call correctly returned the expected magic value
1825      */
1826     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1827         private returns (bool)
1828     {
1829         if (!to.isContract()) {
1830             return true;
1831         }
1832         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1833             IERC721Receiver(to).onERC721Received.selector,
1834             _msgSender(),
1835             from,
1836             tokenId,
1837             _data
1838         ), "ERC721: transfer to non ERC721Receiver implementer");
1839         bytes4 retval = abi.decode(returndata, (bytes4));
1840         return (retval == _ERC721_RECEIVED);
1841     }
1842 
1843     function _approve(address to, uint256 tokenId) private {
1844         _tokenApprovals[tokenId] = to;
1845         emit Approval(ownerOf(tokenId), to, tokenId);
1846     }
1847 
1848     /**
1849      * @dev Hook that is called before any token transfer. This includes minting
1850      * and burning.
1851      *
1852      * Calling conditions:
1853      *
1854      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1855      * transferred to `to`.
1856      * - When `from` is zero, `tokenId` will be minted for `to`.
1857      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1858      * - `from` cannot be the zero address.
1859      * - `to` cannot be the zero address.
1860      *
1861      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1862      */
1863     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1864 }
1865 
1866 // File: contracts\token\ERC721\ERC721Burnable.sol
1867 
1868 /**
1869  * @title ERC721 Burnable Token
1870  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1871  */
1872 abstract contract ERC721Burnable is Context, ERC721 {
1873     /**
1874      * @dev Burns `tokenId`. See {ERC721-_burn}.
1875      *
1876      * Requirements:
1877      *
1878      * - The caller must own `tokenId` or be an approved operator.
1879      */
1880     function burn(uint256 tokenId) public virtual {
1881         //solhint-disable-next-line max-line-length
1882         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1883         _burn(tokenId);
1884     }
1885 }
1886 
1887 // File: contracts\utils\Pausable.sol
1888 
1889 /**
1890  * @dev Contract module which allows children to implement an emergency stop
1891  * mechanism that can be triggered by an authorized account.
1892  *
1893  * This module is used through inheritance. It will make available the
1894  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1895  * the functions of your contract. Note that they will not be pausable by
1896  * simply including this module, only once the modifiers are put in place.
1897  */
1898 contract Pausable is Context {
1899     /**
1900      * @dev Emitted when the pause is triggered by `account`.
1901      */
1902     event Paused(address account);
1903 
1904     /**
1905      * @dev Emitted when the pause is lifted by `account`.
1906      */
1907     event Unpaused(address account);
1908 
1909     bool private _paused;
1910 
1911     /**
1912      * @dev Initializes the contract in unpaused state.
1913      */
1914     constructor () internal {
1915         _paused = false;
1916     }
1917 
1918     /**
1919      * @dev Returns true if the contract is paused, and false otherwise.
1920      */
1921     function paused() public view returns (bool) {
1922         return _paused;
1923     }
1924 
1925     /**
1926      * @dev Modifier to make a function callable only when the contract is not paused.
1927      *
1928      * Requirements:
1929      *
1930      * - The contract must not be paused.
1931      */
1932     modifier whenNotPaused() {
1933         require(!_paused, "Pausable: paused");
1934         _;
1935     }
1936 
1937     /**
1938      * @dev Modifier to make a function callable only when the contract is paused.
1939      *
1940      * Requirements:
1941      *
1942      * - The contract must be paused.
1943      */
1944     modifier whenPaused() {
1945         require(_paused, "Pausable: not paused");
1946         _;
1947     }
1948 
1949     /**
1950      * @dev Triggers stopped state.
1951      *
1952      * Requirements:
1953      *
1954      * - The contract must not be paused.
1955      */
1956     function _pause() internal virtual whenNotPaused {
1957         _paused = true;
1958         emit Paused(_msgSender());
1959     }
1960 
1961     /**
1962      * @dev Returns to normal state.
1963      *
1964      * Requirements:
1965      *
1966      * - The contract must be paused.
1967      */
1968     function _unpause() internal virtual whenPaused {
1969         _paused = false;
1970         emit Unpaused(_msgSender());
1971     }
1972 }
1973 
1974 // File: contracts\token\ERC721\ERC721Pausable.sol
1975 
1976 /**
1977  * @dev ERC721 token with pausable token transfers, minting and burning.
1978  *
1979  * Useful for scenarios such as preventing trades until the end of an evaluation
1980  * period, or having an emergency switch for freezing all token transfers in the
1981  * event of a large bug.
1982  */
1983 abstract contract ERC721Pausable is ERC721, Pausable {
1984     /**
1985      * @dev See {ERC721-_beforeTokenTransfer}.
1986      *
1987      * Requirements:
1988      *
1989      * - the contract must not be paused.
1990      */
1991     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1992         super._beforeTokenTransfer(from, to, tokenId);
1993 
1994         require(!paused(), "ERC721Pausable: token transfer while paused");
1995     }
1996 }
1997 
1998 // File: contracts\presets\NonFungibleToken.sol
1999 
2000 /**
2001  * @dev {ERC721} token, including:
2002  *
2003  *  - ability for holders to burn (destroy) their tokens
2004  *  - a minter role that allows for token minting (creation)
2005  *  - a pauser role that allows to stop all token transfers
2006  *  - token ID and URI autogeneration
2007  *
2008  * This contract uses {AccessControl} to lock permissioned functions using the
2009  * different roles - head to its documentation for details.
2010  *
2011  * The account that deploys the contract will be granted the minter and pauser
2012  * roles, as well as the default admin role, which will let it grant both minter
2013  * and pauser roles to other accounts.
2014  */
2015 contract NonFungibleToken is Context, AccessControl, ERC721 {
2016     using Counters for Counters.Counter;
2017 
2018     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2019   //  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2020     address public owner;
2021     bool public whitelistingEnabled = false;
2022     bool public mintingEnabled = true;
2023     //uint256 public maxPerWallet = 100;
2024     //uint256 public maxPerWallet;
2025     uint256 private _maxPerWallet;
2026     uint256 public numberOfWhitelisted;
2027 
2028 
2029    // mapping (address => bool) public whitelists;
2030     Counters.Counter private _tokenIdTracker;
2031 
2032     uint256 private _revealsCount = 0;
2033 
2034     /**
2035      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2036      * account that deploys the contract.
2037      *
2038      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
2039      * See {ERC721-tokenURI}.
2040      */
2041     constructor(string memory name, string memory symbol, string memory baseURI, uint256 maxPerWallet) public ERC721(name, symbol) {
2042         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2043 
2044         _setupRole(MINTER_ROLE, _msgSender());
2045       //  _setupRole(PAUSER_ROLE, _msgSender());
2046 
2047         _setBaseURI(baseURI);
2048 
2049         owner = msg.sender;
2050 
2051         _maxPerWallet = maxPerWallet;
2052     }
2053 
2054 
2055     function getMaxPerWallet() public view returns (uint256) {
2056         return _maxPerWallet;
2057     }
2058 
2059     function setMaxPerWallet(uint256 maxPerWallet) public virtual {
2060         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have minter role to mint");
2061         _maxPerWallet = maxPerWallet;
2062     }
2063 
2064 
2065     function setURI(string memory baseURI) public virtual {
2066         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have admin role");
2067         require((_revealsCount < 2), "You cannot make more than three reveals");
2068         _setBaseURI(baseURI);
2069         _revealsCount +=1;
2070     }
2071 
2072 
2073     function setOwner(address _owner) public virtual {
2074         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have admin role");
2075         _setupRole(DEFAULT_ADMIN_ROLE, _owner);
2076         _setupRole(MINTER_ROLE, _owner);
2077         owner = _owner;
2078     }
2079 
2080     function toggleMinting(bool _bool) public virtual {
2081         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have admin role to mint");
2082         mintingEnabled = _bool;
2083     }
2084 
2085     function toggleWhitelisting(bool _toggle) public virtual {
2086         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have admin role");
2087         whitelistingEnabled = _toggle;
2088     }
2089 
2090 
2091     function whitelist(address[] memory _beneficiaries) external {
2092       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have admin role");
2093       for (uint256 i = 0; i < _beneficiaries.length; i++) {
2094         if (! whitelists[_beneficiaries[i]]){
2095             numberOfWhitelisted = numberOfWhitelisted + 1;
2096         }
2097         whitelists[_beneficiaries[i]] = true;
2098       }
2099     }
2100 
2101     function removeFromWhitelist(address[] memory _beneficiaries) external {
2102       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have admin role");
2103       for (uint256 i = 0; i < _beneficiaries.length; i++) {
2104 
2105         if (whitelists[_beneficiaries[i]]){
2106             numberOfWhitelisted = numberOfWhitelisted.sub(1);
2107         }
2108         whitelists[_beneficiaries[i]] = false;
2109       }
2110     }
2111 
2112 
2113     function contractURI() public view returns (string memory) {
2114         return string(abi.encodePacked(baseURI(), "contract-metadata.json"));
2115     }
2116 
2117 
2118 
2119     /**
2120      * @dev Creates a new token for `to`. Its token ID will be automatically
2121      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
2122      * URI autogenerated based on the base URI passed at construction.
2123      *
2124      * See {ERC721-_mint}.
2125      *
2126      * Requirements:
2127      *
2128      * - the caller must have the `MINTER_ROLE`.
2129      */
2130     function mint(address to) public virtual {
2131         require(hasRole(MINTER_ROLE, _msgSender()), "NonFungibleToken: must have minter role to mint");
2132         require(whitelists[to] || ! whitelistingEnabled, "User not whitelisted !");
2133 
2134         require(mintingEnabled, "Minting not enabled !");
2135         // We cannot just use balanceOf to create the new tokenId because tokens
2136         // can be burned (destroyed), so we need a separate counter.
2137         _mint(to, _tokenIdTracker.current() + 1);
2138         _tokenIdTracker.increment();
2139         require(balanceOf(to) <= getMaxPerWallet(), "Max NFTs reached by wallet");
2140     }
2141 
2142     function batchMint(address[] memory _beneficiaries) external {
2143       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have admin role");
2144       for (uint256 i = 0; i < _beneficiaries.length; i++) {
2145 
2146         _mint(_beneficiaries[i], _tokenIdTracker.current() + 1);
2147         _tokenIdTracker.increment();
2148       }
2149     }
2150 
2151 
2152  /*   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Pausable) {
2153         super._beforeTokenTransfer(from, to, tokenId);
2154     }*/
2155 }