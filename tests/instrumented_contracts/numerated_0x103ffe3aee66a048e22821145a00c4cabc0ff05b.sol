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
248 
249 
250 
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // This method relies on extcodesize, which returns 0 for contracts in
275         // construction, since the code is only stored at the end of the
276         // constructor execution.
277 
278         uint256 size;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { size := extcodesize(account) }
281         return size > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: value }(data);
367         return _verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
387         require(isContract(target), "Address: static call to non-contract");
388 
389         // solhint-disable-next-line avoid-low-level-calls
390         (bool success, bytes memory returndata) = target.staticcall(data);
391         return _verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.3._
399      */
400     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
401         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a delegate call.
407      *
408      * _Available since v3.3._
409      */
410     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
411         require(isContract(target), "Address: delegate call to non-contract");
412 
413         // solhint-disable-next-line avoid-low-level-calls
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return _verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
419         if (success) {
420             return returndata;
421         } else {
422             // Look for revert reason and bubble it up if present
423             if (returndata.length > 0) {
424                 // The easiest way to bubble the revert reason is using memory via assembly
425 
426                 // solhint-disable-next-line no-inline-assembly
427                 assembly {
428                     let returndata_size := mload(returndata)
429                     revert(add(32, returndata), returndata_size)
430                 }
431             } else {
432                 revert(errorMessage);
433             }
434         }
435     }
436 }
437 
438 // File: contracts\GSN\Context.sol
439 
440 
441 
442 
443 
444 /*
445  * @dev Provides information about the current execution context, including the
446  * sender of the transaction and its data. While these are generally available
447  * via msg.sender and msg.data, they should not be accessed in such a direct
448  * manner, since when dealing with GSN meta-transactions the account sending and
449  * paying for execution may not be the actual sender (as far as an application
450  * is concerned).
451  *
452  * This contract is only required for intermediate, library-like contracts.
453  */
454 abstract contract Context {
455     function _msgSender() internal view virtual returns (address payable) {
456         return msg.sender;
457     }
458 
459     function _msgData() internal view virtual returns (bytes memory) {
460         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
461         return msg.data;
462     }
463 }
464 
465 // File: contracts\access\AccessControl.sol
466 
467 
468 
469 
470 
471 
472 
473 
474 /**
475  * @dev Contract module that allows children to implement role-based access
476  * control mechanisms.
477  *
478  * Roles are referred to by their `bytes32` identifier. These should be exposed
479  * in the external API and be unique. The best way to achieve this is by
480  * using `public constant` hash digests:
481  *
482  * ```
483  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
484  * ```
485  *
486  * Roles can be used to represent a set of permissions. To restrict access to a
487  * function call, use {hasRole}:
488  *
489  * ```
490  * function foo() public {
491  *     require(hasRole(MY_ROLE, msg.sender));
492  *     ...
493  * }
494  * ```
495  *
496  * Roles can be granted and revoked dynamically via the {grantRole} and
497  * {revokeRole} functions. Each role has an associated admin role, and only
498  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
499  *
500  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
501  * that only accounts with this role will be able to grant or revoke other
502  * roles. More complex role relationships can be created by using
503  * {_setRoleAdmin}.
504  *
505  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
506  * grant and revoke this role. Extra precautions should be taken to secure
507  * accounts that have been granted it.
508  */
509 abstract contract AccessControl is Context {
510     using EnumerableSet for EnumerableSet.AddressSet;
511     using Address for address;
512 
513     struct RoleData {
514         EnumerableSet.AddressSet members;
515         bytes32 adminRole;
516     }
517 
518     mapping (bytes32 => RoleData) private _roles;
519 
520     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
521 
522     /**
523      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
524      *
525      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
526      * {RoleAdminChanged} not being emitted signaling this.
527      *
528      * _Available since v3.1._
529      */
530     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
531 
532     /**
533      * @dev Emitted when `account` is granted `role`.
534      *
535      * `sender` is the account that originated the contract call, an admin role
536      * bearer except when using {_setupRole}.
537      */
538     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
539 
540     /**
541      * @dev Emitted when `account` is revoked `role`.
542      *
543      * `sender` is the account that originated the contract call:
544      *   - if using `revokeRole`, it is the admin role bearer
545      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
546      */
547     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
548 
549     /**
550      * @dev Returns `true` if `account` has been granted `role`.
551      */
552     function hasRole(bytes32 role, address account) public view returns (bool) {
553         return _roles[role].members.contains(account);
554     }
555 
556     /**
557      * @dev Returns the number of accounts that have `role`. Can be used
558      * together with {getRoleMember} to enumerate all bearers of a role.
559      */
560     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
561         return _roles[role].members.length();
562     }
563 
564     /**
565      * @dev Returns one of the accounts that have `role`. `index` must be a
566      * value between 0 and {getRoleMemberCount}, non-inclusive.
567      *
568      * Role bearers are not sorted in any particular way, and their ordering may
569      * change at any point.
570      *
571      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
572      * you perform all queries on the same block. See the following
573      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
574      * for more information.
575      */
576     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
577         return _roles[role].members.at(index);
578     }
579 
580     /**
581      * @dev Returns the admin role that controls `role`. See {grantRole} and
582      * {revokeRole}.
583      *
584      * To change a role's admin, use {_setRoleAdmin}.
585      */
586     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
587         return _roles[role].adminRole;
588     }
589 
590     /**
591      * @dev Grants `role` to `account`.
592      *
593      * If `account` had not been already granted `role`, emits a {RoleGranted}
594      * event.
595      *
596      * Requirements:
597      *
598      * - the caller must have ``role``'s admin role.
599      */
600     function grantRole(bytes32 role, address account) public virtual {
601         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
602 
603         _grantRole(role, account);
604     }
605 
606     /**
607      * @dev Revokes `role` from `account`.
608      *
609      * If `account` had been granted `role`, emits a {RoleRevoked} event.
610      *
611      * Requirements:
612      *
613      * - the caller must have ``role``'s admin role.
614      */
615     function revokeRole(bytes32 role, address account) public virtual {
616         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
617 
618         _revokeRole(role, account);
619     }
620 
621     /**
622      * @dev Revokes `role` from the calling account.
623      *
624      * Roles are often managed via {grantRole} and {revokeRole}: this function's
625      * purpose is to provide a mechanism for accounts to lose their privileges
626      * if they are compromised (such as when a trusted device is misplaced).
627      *
628      * If the calling account had been granted `role`, emits a {RoleRevoked}
629      * event.
630      *
631      * Requirements:
632      *
633      * - the caller must be `account`.
634      */
635     function renounceRole(bytes32 role, address account) public virtual {
636         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
637 
638         _revokeRole(role, account);
639     }
640 
641     /**
642      * @dev Grants `role` to `account`.
643      *
644      * If `account` had not been already granted `role`, emits a {RoleGranted}
645      * event. Note that unlike {grantRole}, this function doesn't perform any
646      * checks on the calling account.
647      *
648      * [WARNING]
649      * ====
650      * This function should only be called from the constructor when setting
651      * up the initial roles for the system.
652      *
653      * Using this function in any other way is effectively circumventing the admin
654      * system imposed by {AccessControl}.
655      * ====
656      */
657     function _setupRole(bytes32 role, address account) internal virtual {
658         _grantRole(role, account);
659     }
660 
661     /**
662      * @dev Sets `adminRole` as ``role``'s admin role.
663      *
664      * Emits a {RoleAdminChanged} event.
665      */
666     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
667         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
668         _roles[role].adminRole = adminRole;
669     }
670 
671     function _grantRole(bytes32 role, address account) private {
672         if (_roles[role].members.add(account)) {
673             emit RoleGranted(role, account, _msgSender());
674         }
675     }
676 
677     function _revokeRole(bytes32 role, address account) private {
678         if (_roles[role].members.remove(account)) {
679             emit RoleRevoked(role, account, _msgSender());
680         }
681     }
682 }
683 
684 // File: contracts\math\SafeMath.sol
685 
686 
687 
688 
689 
690 /**
691  * @dev Wrappers over Solidity's arithmetic operations with added overflow
692  * checks.
693  *
694  * Arithmetic operations in Solidity wrap on overflow. This can easily result
695  * in bugs, because programmers usually assume that an overflow raises an
696  * error, which is the standard behavior in high level programming languages.
697  * `SafeMath` restores this intuition by reverting the transaction when an
698  * operation overflows.
699  *
700  * Using this library instead of the unchecked operations eliminates an entire
701  * class of bugs, so it's recommended to use it always.
702  */
703 library SafeMath {
704     /**
705      * @dev Returns the addition of two unsigned integers, reverting on
706      * overflow.
707      *
708      * Counterpart to Solidity's `+` operator.
709      *
710      * Requirements:
711      *
712      * - Addition cannot overflow.
713      */
714     function add(uint256 a, uint256 b) internal pure returns (uint256) {
715         uint256 c = a + b;
716         require(c >= a, "SafeMath: addition overflow");
717 
718         return c;
719     }
720 
721     /**
722      * @dev Returns the subtraction of two unsigned integers, reverting on
723      * overflow (when the result is negative).
724      *
725      * Counterpart to Solidity's `-` operator.
726      *
727      * Requirements:
728      *
729      * - Subtraction cannot overflow.
730      */
731     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
732         return sub(a, b, "SafeMath: subtraction overflow");
733     }
734 
735     /**
736      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
737      * overflow (when the result is negative).
738      *
739      * Counterpart to Solidity's `-` operator.
740      *
741      * Requirements:
742      *
743      * - Subtraction cannot overflow.
744      */
745     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
746         require(b <= a, errorMessage);
747         uint256 c = a - b;
748 
749         return c;
750     }
751 
752     /**
753      * @dev Returns the multiplication of two unsigned integers, reverting on
754      * overflow.
755      *
756      * Counterpart to Solidity's `*` operator.
757      *
758      * Requirements:
759      *
760      * - Multiplication cannot overflow.
761      */
762     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
763         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
764         // benefit is lost if 'b' is also tested.
765         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
766         if (a == 0) {
767             return 0;
768         }
769 
770         uint256 c = a * b;
771         require(c / a == b, "SafeMath: multiplication overflow");
772 
773         return c;
774     }
775 
776     /**
777      * @dev Returns the integer division of two unsigned integers. Reverts on
778      * division by zero. The result is rounded towards zero.
779      *
780      * Counterpart to Solidity's `/` operator. Note: this function uses a
781      * `revert` opcode (which leaves remaining gas untouched) while Solidity
782      * uses an invalid opcode to revert (consuming all remaining gas).
783      *
784      * Requirements:
785      *
786      * - The divisor cannot be zero.
787      */
788     function div(uint256 a, uint256 b) internal pure returns (uint256) {
789         return div(a, b, "SafeMath: division by zero");
790     }
791 
792     /**
793      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
804     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
805         require(b > 0, errorMessage);
806         uint256 c = a / b;
807         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
808 
809         return c;
810     }
811 
812     /**
813      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
814      * Reverts when dividing by zero.
815      *
816      * Counterpart to Solidity's `%` operator. This function uses a `revert`
817      * opcode (which leaves remaining gas untouched) while Solidity uses an
818      * invalid opcode to revert (consuming all remaining gas).
819      *
820      * Requirements:
821      *
822      * - The divisor cannot be zero.
823      */
824     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
825         return mod(a, b, "SafeMath: modulo by zero");
826     }
827 
828     /**
829      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
830      * Reverts with custom message when dividing by zero.
831      *
832      * Counterpart to Solidity's `%` operator. This function uses a `revert`
833      * opcode (which leaves remaining gas untouched) while Solidity uses an
834      * invalid opcode to revert (consuming all remaining gas).
835      *
836      * Requirements:
837      *
838      * - The divisor cannot be zero.
839      */
840     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
841         require(b != 0, errorMessage);
842         return a % b;
843     }
844 }
845 
846 // File: contracts\utils\Counters.sol
847 
848 
849 
850 
851 
852 
853 /**
854  * @title Counters
855  * @author Matt Condon (@shrugs)
856  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
857  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
858  *
859  * Include with `using Counters for Counters.Counter;`
860  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
861  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
862  * directly accessed.
863  */
864 library Counters {
865     using SafeMath for uint256;
866 
867     struct Counter {
868         // This variable should never be directly accessed by users of the library: interactions must be restricted to
869         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
870         // this feature: see https://github.com/ethereum/solidity/issues/4637
871         uint256 _value; // default: 0
872     }
873 
874     function current(Counter storage counter) internal view returns (uint256) {
875         return counter._value;
876     }
877 
878     function increment(Counter storage counter) internal {
879         // The {SafeMath} overflow check can be skipped here, see the comment at the top
880         counter._value += 1;
881     }
882 
883     function decrement(Counter storage counter) internal {
884         counter._value = counter._value.sub(1);
885     }
886 }
887 
888 // File: contracts\introspection\IERC165.sol
889 
890 
891 
892 
893 
894 /**
895  * @dev Interface of the ERC165 standard, as defined in the
896  * https://eips.ethereum.org/EIPS/eip-165[EIP].
897  *
898  * Implementers can declare support of contract interfaces, which can then be
899  * queried by others ({ERC165Checker}).
900  *
901  * For an implementation, see {ERC165}.
902  */
903 interface IERC165 {
904     /**
905      * @dev Returns true if this contract implements the interface defined by
906      * `interfaceId`. See the corresponding
907      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
908      * to learn more about how these ids are created.
909      *
910      * This function call must use less than 30 000 gas.
911      */
912     function supportsInterface(bytes4 interfaceId) external view returns (bool);
913 }
914 
915 // File: contracts\token\ERC721\IERC721.sol
916 
917 
918 
919 
920 
921 
922 /**
923  * @dev Required interface of an ERC721 compliant contract.
924  */
925 interface IERC721 is IERC165 {
926     /**
927      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
928      */
929     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
930 
931     /**
932      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
933      */
934     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
935 
936     /**
937      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
938      */
939     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
940 
941     /**
942      * @dev Returns the number of tokens in ``owner``'s account.
943      */
944     function balanceOf(address owner) external view returns (uint256 balance);
945 
946     /**
947      * @dev Returns the owner of the `tokenId` token.
948      *
949      * Requirements:
950      *
951      * - `tokenId` must exist.
952      */
953     function ownerOf(uint256 tokenId) external view returns (address owner);
954 
955     /**
956      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
957      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
958      *
959      * Requirements:
960      *
961      * - `from` cannot be the zero address.
962      * - `to` cannot be the zero address.
963      * - `tokenId` token must exist and be owned by `from`.
964      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
966      *
967      * Emits a {Transfer} event.
968      */
969     function safeTransferFrom(address from, address to, uint256 tokenId) external;
970 
971     /**
972      * @dev Transfers `tokenId` token from `from` to `to`.
973      *
974      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
975      *
976      * Requirements:
977      *
978      * - `from` cannot be the zero address.
979      * - `to` cannot be the zero address.
980      * - `tokenId` token must be owned by `from`.
981      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
982      *
983      * Emits a {Transfer} event.
984      */
985     function transferFrom(address from, address to, uint256 tokenId) external;
986 
987     /**
988      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
989      * The approval is cleared when the token is transferred.
990      *
991      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
992      *
993      * Requirements:
994      *
995      * - The caller must own the token or be an approved operator.
996      * - `tokenId` must exist.
997      *
998      * Emits an {Approval} event.
999      */
1000     function approve(address to, uint256 tokenId) external;
1001 
1002     /**
1003      * @dev Returns the account approved for `tokenId` token.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      */
1009     function getApproved(uint256 tokenId) external view returns (address operator);
1010 
1011     /**
1012      * @dev Approve or remove `operator` as an operator for the caller.
1013      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1014      *
1015      * Requirements:
1016      *
1017      * - The `operator` cannot be the caller.
1018      *
1019      * Emits an {ApprovalForAll} event.
1020      */
1021     function setApprovalForAll(address operator, bool _approved) external;
1022 
1023     /**
1024      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1025      *
1026      * See {setApprovalForAll}
1027      */
1028     function isApprovedForAll(address owner, address operator) external view returns (bool);
1029 
1030     /**
1031       * @dev Safely transfers `tokenId` token from `from` to `to`.
1032       *
1033       * Requirements:
1034       *
1035      * - `from` cannot be the zero address.
1036      * - `to` cannot be the zero address.
1037       * - `tokenId` token must exist and be owned by `from`.
1038       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1039       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1040       *
1041       * Emits a {Transfer} event.
1042       */
1043     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1044 }
1045 
1046 // File: contracts\token\ERC721\IERC721Metadata.sol
1047 
1048 
1049 
1050 
1051 
1052 
1053 /**
1054  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1055  * @dev See https://eips.ethereum.org/EIPS/eip-721
1056  */
1057 interface IERC721Metadata is IERC721 {
1058 
1059     /**
1060      * @dev Returns the token collection name.
1061      */
1062     function name() external view returns (string memory);
1063 
1064     /**
1065      * @dev Returns the token collection symbol.
1066      */
1067     function symbol() external view returns (string memory);
1068 
1069     /**
1070      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1071      */
1072     function tokenURI(uint256 tokenId) external view returns (string memory);
1073 }
1074 
1075 // File: contracts\token\ERC721\IERC721Enumerable.sol
1076 
1077 
1078 
1079 
1080 
1081 
1082 /**
1083  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1084  * @dev See https://eips.ethereum.org/EIPS/eip-721
1085  */
1086 interface IERC721Enumerable is IERC721 {
1087 
1088     /**
1089      * @dev Returns the total amount of tokens stored by the contract.
1090      */
1091     function totalSupply() external view returns (uint256);
1092 
1093     /**
1094      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1095      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1096      */
1097     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1098 
1099     /**
1100      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1101      * Use along with {totalSupply} to enumerate all tokens.
1102      */
1103     function tokenByIndex(uint256 index) external view returns (uint256);
1104 }
1105 
1106 // File: contracts\token\ERC721\IERC721Receiver.sol
1107 
1108 
1109 
1110 
1111 
1112 /**
1113  * @title ERC721 token receiver interface
1114  * @dev Interface for any contract that wants to support safeTransfers
1115  * from ERC721 asset contracts.
1116  */
1117 interface IERC721Receiver {
1118     /**
1119      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1120      * by `operator` from `from`, this function is called.
1121      *
1122      * It must return its Solidity selector to confirm the token transfer.
1123      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1124      *
1125      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1126      */
1127     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1128 }
1129 
1130 // File: contracts\introspection\ERC165.sol
1131 
1132 
1133 
1134 
1135 
1136 
1137 /**
1138  * @dev Implementation of the {IERC165} interface.
1139  *
1140  * Contracts may inherit from this and call {_registerInterface} to declare
1141  * their support of an interface.
1142  */
1143 contract ERC165 is IERC165 {
1144     /*
1145      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1146      */
1147     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1148 
1149     /**
1150      * @dev Mapping of interface ids to whether or not it's supported.
1151      */
1152     mapping(bytes4 => bool) private _supportedInterfaces;
1153 
1154     constructor () internal {
1155         // Derived contracts need only register support for their own interfaces,
1156         // we register support for ERC165 itself here
1157         _registerInterface(_INTERFACE_ID_ERC165);
1158     }
1159 
1160     /**
1161      * @dev See {IERC165-supportsInterface}.
1162      *
1163      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1164      */
1165     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1166         return _supportedInterfaces[interfaceId];
1167     }
1168 
1169     /**
1170      * @dev Registers the contract as an implementer of the interface defined by
1171      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1172      * registering its interface id is not required.
1173      *
1174      * See {IERC165-supportsInterface}.
1175      *
1176      * Requirements:
1177      *
1178      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1179      */
1180     function _registerInterface(bytes4 interfaceId) internal virtual {
1181         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1182         _supportedInterfaces[interfaceId] = true;
1183     }
1184 }
1185 
1186 // File: contracts\utils\EnumerableMap.sol
1187 
1188 
1189 
1190 
1191 
1192 /**
1193  * @dev Library for managing an enumerable variant of Solidity's
1194  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1195  * type.
1196  *
1197  * Maps have the following properties:
1198  *
1199  * - Entries are added, removed, and checked for existence in constant time
1200  * (O(1)).
1201  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1202  *
1203  * ```
1204  * contract Example {
1205  *     // Add the library methods
1206  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1207  *
1208  *     // Declare a set state variable
1209  *     EnumerableMap.UintToAddressMap private myMap;
1210  * }
1211  * ```
1212  *
1213  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1214  * supported.
1215  */
1216 library EnumerableMap {
1217     // To implement this library for multiple types with as little code
1218     // repetition as possible, we write it in terms of a generic Map type with
1219     // bytes32 keys and values.
1220     // The Map implementation uses private functions, and user-facing
1221     // implementations (such as Uint256ToAddressMap) are just wrappers around
1222     // the underlying Map.
1223     // This means that we can only create new EnumerableMaps for types that fit
1224     // in bytes32.
1225 
1226     struct MapEntry {
1227         bytes32 _key;
1228         bytes32 _value;
1229     }
1230 
1231     struct Map {
1232         // Storage of map keys and values
1233         MapEntry[] _entries;
1234 
1235         // Position of the entry defined by a key in the `entries` array, plus 1
1236         // because index 0 means a key is not in the map.
1237         mapping (bytes32 => uint256) _indexes;
1238     }
1239 
1240     /**
1241      * @dev Adds a key-value pair to a map, or updates the value for an existing
1242      * key. O(1).
1243      *
1244      * Returns true if the key was added to the map, that is if it was not
1245      * already present.
1246      */
1247     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1248         // We read and store the key's index to prevent multiple reads from the same storage slot
1249         uint256 keyIndex = map._indexes[key];
1250 
1251         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1252             map._entries.push(MapEntry({ _key: key, _value: value }));
1253             // The entry is stored at length-1, but we add 1 to all indexes
1254             // and use 0 as a sentinel value
1255             map._indexes[key] = map._entries.length;
1256             return true;
1257         } else {
1258             map._entries[keyIndex - 1]._value = value;
1259             return false;
1260         }
1261     }
1262 
1263     /**
1264      * @dev Removes a key-value pair from a map. O(1).
1265      *
1266      * Returns true if the key was removed from the map, that is if it was present.
1267      */
1268     function _remove(Map storage map, bytes32 key) private returns (bool) {
1269         // We read and store the key's index to prevent multiple reads from the same storage slot
1270         uint256 keyIndex = map._indexes[key];
1271 
1272         if (keyIndex != 0) { // Equivalent to contains(map, key)
1273             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1274             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1275             // This modifies the order of the array, as noted in {at}.
1276 
1277             uint256 toDeleteIndex = keyIndex - 1;
1278             uint256 lastIndex = map._entries.length - 1;
1279 
1280             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1281             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1282 
1283             MapEntry storage lastEntry = map._entries[lastIndex];
1284 
1285             // Move the last entry to the index where the entry to delete is
1286             map._entries[toDeleteIndex] = lastEntry;
1287             // Update the index for the moved entry
1288             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1289 
1290             // Delete the slot where the moved entry was stored
1291             map._entries.pop();
1292 
1293             // Delete the index for the deleted slot
1294             delete map._indexes[key];
1295 
1296             return true;
1297         } else {
1298             return false;
1299         }
1300     }
1301 
1302     /**
1303      * @dev Returns true if the key is in the map. O(1).
1304      */
1305     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1306         return map._indexes[key] != 0;
1307     }
1308 
1309     /**
1310      * @dev Returns the number of key-value pairs in the map. O(1).
1311      */
1312     function _length(Map storage map) private view returns (uint256) {
1313         return map._entries.length;
1314     }
1315 
1316    /**
1317     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1318     *
1319     * Note that there are no guarantees on the ordering of entries inside the
1320     * array, and it may change when more entries are added or removed.
1321     *
1322     * Requirements:
1323     *
1324     * - `index` must be strictly less than {length}.
1325     */
1326     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1327         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1328 
1329         MapEntry storage entry = map._entries[index];
1330         return (entry._key, entry._value);
1331     }
1332 
1333     /**
1334      * @dev Returns the value associated with `key`.  O(1).
1335      *
1336      * Requirements:
1337      *
1338      * - `key` must be in the map.
1339      */
1340     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1341         return _get(map, key, "EnumerableMap: nonexistent key");
1342     }
1343 
1344     /**
1345      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1346      */
1347     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1348         uint256 keyIndex = map._indexes[key];
1349         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1350         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1351     }
1352 
1353     // UintToAddressMap
1354 
1355     struct UintToAddressMap {
1356         Map _inner;
1357     }
1358 
1359     /**
1360      * @dev Adds a key-value pair to a map, or updates the value for an existing
1361      * key. O(1).
1362      *
1363      * Returns true if the key was added to the map, that is if it was not
1364      * already present.
1365      */
1366     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1367         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1368     }
1369 
1370     /**
1371      * @dev Removes a value from a set. O(1).
1372      *
1373      * Returns true if the key was removed from the map, that is if it was present.
1374      */
1375     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1376         return _remove(map._inner, bytes32(key));
1377     }
1378 
1379     /**
1380      * @dev Returns true if the key is in the map. O(1).
1381      */
1382     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1383         return _contains(map._inner, bytes32(key));
1384     }
1385 
1386     /**
1387      * @dev Returns the number of elements in the map. O(1).
1388      */
1389     function length(UintToAddressMap storage map) internal view returns (uint256) {
1390         return _length(map._inner);
1391     }
1392 
1393    /**
1394     * @dev Returns the element stored at position `index` in the set. O(1).
1395     * Note that there are no guarantees on the ordering of values inside the
1396     * array, and it may change when more values are added or removed.
1397     *
1398     * Requirements:
1399     *
1400     * - `index` must be strictly less than {length}.
1401     */
1402     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1403         (bytes32 key, bytes32 value) = _at(map._inner, index);
1404         return (uint256(key), address(uint256(value)));
1405     }
1406 
1407     /**
1408      * @dev Returns the value associated with `key`.  O(1).
1409      *
1410      * Requirements:
1411      *
1412      * - `key` must be in the map.
1413      */
1414     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1415         return address(uint256(_get(map._inner, bytes32(key))));
1416     }
1417 
1418     /**
1419      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1420      */
1421     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1422         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1423     }
1424 }
1425 
1426 // File: contracts\utils\Strings.sol
1427 
1428 
1429 
1430 
1431 
1432 /**
1433  * @dev String operations.
1434  */
1435 library Strings {
1436     /**
1437      * @dev Converts a `uint256` to its ASCII `string` representation.
1438      */
1439     function toString(uint256 value) internal pure returns (string memory) {
1440         // Inspired by OraclizeAPI's implementation - MIT licence
1441         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1442 
1443         if (value == 0) {
1444             return "0";
1445         }
1446         uint256 temp = value;
1447         uint256 digits;
1448         while (temp != 0) {
1449             digits++;
1450             temp /= 10;
1451         }
1452         bytes memory buffer = new bytes(digits);
1453         uint256 index = digits - 1;
1454         temp = value;
1455         while (temp != 0) {
1456             buffer[index--] = byte(uint8(48 + temp % 10));
1457             temp /= 10;
1458         }
1459         return string(buffer);
1460     }
1461 }
1462 
1463 // File: contracts\token\ERC721\ERC721.sol
1464 
1465 
1466 
1467 
1468 
1469 
1470 
1471 
1472 
1473 
1474 
1475 
1476 
1477 
1478 
1479 
1480 /**
1481  * @title ERC721 Non-Fungible Token Standard basic implementation
1482  * @dev see https://eips.ethereum.org/EIPS/eip-721
1483  */
1484 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1485     using SafeMath for uint256;
1486     using Address for address;
1487     using EnumerableSet for EnumerableSet.UintSet;
1488     using EnumerableMap for EnumerableMap.UintToAddressMap;
1489     using Strings for uint256;
1490 
1491     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1492     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1493     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1494 
1495     // Mapping from holder address to their (enumerable) set of owned tokens
1496     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1497 
1498     // Enumerable mapping from token ids to their owners
1499     EnumerableMap.UintToAddressMap private _tokenOwners;
1500 
1501     // Mapping from token ID to approved address
1502     mapping (uint256 => address) private _tokenApprovals;
1503 
1504     // Mapping from owner to operator approvals
1505     mapping (address => mapping (address => bool)) private _operatorApprovals;
1506 
1507     // Token name
1508     string private _name;
1509 
1510     // Token symbol
1511     string private _symbol;
1512 
1513     // Optional mapping for token URIs
1514     mapping (uint256 => string) private _tokenURIs;
1515 
1516     // Base URI
1517     string private _baseURI;
1518 
1519     /*
1520      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1521      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1522      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1523      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1524      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1525      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1526      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1527      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1528      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1529      *
1530      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1531      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1532      */
1533     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1534 
1535     /*
1536      *     bytes4(keccak256('name()')) == 0x06fdde03
1537      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1538      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1539      *
1540      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1541      */
1542     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1543 
1544     /*
1545      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1546      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1547      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1548      *
1549      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1550      */
1551     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1552 
1553     /**
1554      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1555      */
1556     constructor (string memory name, string memory symbol) public {
1557         _name = name;
1558         _symbol = symbol;
1559 
1560         // register the supported interfaces to conform to ERC721 via ERC165
1561         _registerInterface(_INTERFACE_ID_ERC721);
1562         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1563         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1564     }
1565 
1566     /**
1567      * @dev See {IERC721-balanceOf}.
1568      */
1569     function balanceOf(address owner) public view override returns (uint256) {
1570         require(owner != address(0), "ERC721: balance query for the zero address");
1571 
1572         return _holderTokens[owner].length();
1573     }
1574 
1575     /**
1576      * @dev See {IERC721-ownerOf}.
1577      */
1578     function ownerOf(uint256 tokenId) public view override returns (address) {
1579         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1580     }
1581 
1582     /**
1583      * @dev See {IERC721Metadata-name}.
1584      */
1585     function name() public view override returns (string memory) {
1586         return _name;
1587     }
1588 
1589     /**
1590      * @dev See {IERC721Metadata-symbol}.
1591      */
1592     function symbol() public view override returns (string memory) {
1593         return _symbol;
1594     }
1595 
1596     /**
1597      * @dev See {IERC721Metadata-tokenURI}.
1598      */
1599     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1600         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1601 
1602         string memory _tokenURI = _tokenURIs[tokenId];
1603 
1604         // If there is no base URI, return the token URI.
1605         if (bytes(_baseURI).length == 0) {
1606             return _tokenURI;
1607         }
1608         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1609         if (bytes(_tokenURI).length > 0) {
1610             return string(abi.encodePacked(_baseURI, _tokenURI));
1611         }
1612         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1613         return string(abi.encodePacked(_baseURI, tokenId.toString(), ".json"));
1614     }
1615 
1616     /**
1617     * @dev Returns the base URI set via {_setBaseURI}. This will be
1618     * automatically added as a prefix in {tokenURI} to each token's URI, or
1619     * to the token ID if no specific URI is set for that token ID.
1620     */
1621     function baseURI() public view returns (string memory) {
1622         return _baseURI;
1623     }
1624 
1625     /**
1626      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1627      */
1628     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1629         return _holderTokens[owner].at(index);
1630     }
1631 
1632     /**
1633      * @dev See {IERC721Enumerable-totalSupply}.
1634      */
1635     function totalSupply() public view override returns (uint256) {
1636         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1637         return _tokenOwners.length();
1638     }
1639 
1640     /**
1641      * @dev See {IERC721Enumerable-tokenByIndex}.
1642      */
1643     function tokenByIndex(uint256 index) public view override returns (uint256) {
1644         (uint256 tokenId, ) = _tokenOwners.at(index);
1645         return tokenId;
1646     }
1647 
1648     /**
1649      * @dev See {IERC721-approve}.
1650      */
1651     function approve(address to, uint256 tokenId) public virtual override {
1652         address owner = ownerOf(tokenId);
1653         require(to != owner, "ERC721: approval to current owner");
1654 
1655         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1656             "ERC721: approve caller is not owner nor approved for all"
1657         );
1658 
1659         _approve(to, tokenId);
1660     }
1661 
1662     /**
1663      * @dev See {IERC721-getApproved}.
1664      */
1665     function getApproved(uint256 tokenId) public view override returns (address) {
1666         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1667 
1668         return _tokenApprovals[tokenId];
1669     }
1670 
1671     /**
1672      * @dev See {IERC721-setApprovalForAll}.
1673      */
1674     function setApprovalForAll(address operator, bool approved) public virtual override {
1675         require(operator != _msgSender(), "ERC721: approve to caller");
1676 
1677         _operatorApprovals[_msgSender()][operator] = approved;
1678         emit ApprovalForAll(_msgSender(), operator, approved);
1679     }
1680 
1681     /**
1682      * @dev See {IERC721-isApprovedForAll}.
1683      */
1684     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1685         return _operatorApprovals[owner][operator];
1686     }
1687 
1688     /**
1689      * @dev See {IERC721-transferFrom}.
1690      */
1691     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1692         //solhint-disable-next-line max-line-length
1693         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1694 
1695         _transfer(from, to, tokenId);
1696     }
1697 
1698     /**
1699      * @dev See {IERC721-safeTransferFrom}.
1700      */
1701     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1702         safeTransferFrom(from, to, tokenId, "");
1703     }
1704 
1705     /**
1706      * @dev See {IERC721-safeTransferFrom}.
1707      */
1708     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1709         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1710         _safeTransfer(from, to, tokenId, _data);
1711     }
1712 
1713     /**
1714      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1715      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1716      *
1717      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1718      *
1719      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1720      * implement alternative mechanisms to perform token transfer, such as signature-based.
1721      *
1722      * Requirements:
1723      *
1724      * - `from` cannot be the zero address.
1725      * - `to` cannot be the zero address.
1726      * - `tokenId` token must exist and be owned by `from`.
1727      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1728      *
1729      * Emits a {Transfer} event.
1730      */
1731     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1732         _transfer(from, to, tokenId);
1733         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1734     }
1735 
1736     /**
1737      * @dev Returns whether `tokenId` exists.
1738      *
1739      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1740      *
1741      * Tokens start existing when they are minted (`_mint`),
1742      * and stop existing when they are burned (`_burn`).
1743      */
1744     function _exists(uint256 tokenId) internal view returns (bool) {
1745         return _tokenOwners.contains(tokenId);
1746     }
1747 
1748     /**
1749      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1750      *
1751      * Requirements:
1752      *
1753      * - `tokenId` must exist.
1754      */
1755     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1756         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1757         address owner = ownerOf(tokenId);
1758         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1759     }
1760 
1761     /**
1762      * @dev Safely mints `tokenId` and transfers it to `to`.
1763      *
1764      * Requirements:
1765      d*
1766      * - `tokenId` must not exist.
1767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1768      *
1769      * Emits a {Transfer} event.
1770      */
1771     function _safeMint(address to, uint256 tokenId) internal virtual {
1772         _safeMint(to, tokenId, "");
1773     }
1774 
1775     /**
1776      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1777      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1778      */
1779     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1780         _mint(to, tokenId);
1781         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1782     }
1783 
1784     /**
1785      * @dev Mints `tokenId` and transfers it to `to`.
1786      *
1787      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1788      *
1789      * Requirements:
1790      *
1791      * - `tokenId` must not exist.
1792      * - `to` cannot be the zero address.
1793      *
1794      * Emits a {Transfer} event.
1795      */
1796     function _mint(address to, uint256 tokenId) internal virtual {
1797         require(to != address(0), "ERC721: mint to the zero address");
1798         require(!_exists(tokenId), "ERC721: token already minted");
1799 
1800         _beforeTokenTransfer(address(0), to, tokenId);
1801 
1802         _holderTokens[to].add(tokenId);
1803 
1804         _tokenOwners.set(tokenId, to);
1805 
1806         emit Transfer(address(0), to, tokenId);
1807     }
1808 
1809     /**
1810      * @dev Destroys `tokenId`.
1811      * The approval is cleared when the token is burned.
1812      *
1813      * Requirements:
1814      *
1815      * - `tokenId` must exist.
1816      *
1817      * Emits a {Transfer} event.
1818      */
1819     function _burn(uint256 tokenId) internal virtual {
1820         address owner = ownerOf(tokenId);
1821 
1822         _beforeTokenTransfer(owner, address(0), tokenId);
1823 
1824         // Clear approvals
1825         _approve(address(0), tokenId);
1826 
1827         // Clear metadata (if any)
1828         if (bytes(_tokenURIs[tokenId]).length != 0) {
1829             delete _tokenURIs[tokenId];
1830         }
1831 
1832         _holderTokens[owner].remove(tokenId);
1833 
1834         _tokenOwners.remove(tokenId);
1835 
1836         emit Transfer(owner, address(0), tokenId);
1837     }
1838 
1839     /**
1840      * @dev Transfers `tokenId` from `from` to `to`.
1841      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1842      *
1843      * Requirements:
1844      *
1845      * - `to` cannot be the zero address.
1846      * - `tokenId` token must be owned by `from`.
1847      *
1848      * Emits a {Transfer} event.
1849      */
1850     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1851         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1852         require(to != address(0), "ERC721: transfer to the zero address");
1853 
1854         _beforeTokenTransfer(from, to, tokenId);
1855 
1856         // Clear approvals from the previous owner
1857         _approve(address(0), tokenId);
1858 
1859         _holderTokens[from].remove(tokenId);
1860         _holderTokens[to].add(tokenId);
1861 
1862         _tokenOwners.set(tokenId, to);
1863 
1864         emit Transfer(from, to, tokenId);
1865     }
1866 
1867     /**
1868      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1869      *
1870      * Requirements:
1871      *
1872      * - `tokenId` must exist.
1873      */
1874     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1875         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1876         _tokenURIs[tokenId] = _tokenURI;
1877     }
1878 
1879     /**
1880      * @dev Internal function to set the base URI for all token IDs. It is
1881      * automatically added as a prefix to the value returned in {tokenURI},
1882      * or to the token ID if {tokenURI} is empty.
1883      */
1884     function _setBaseURI(string memory baseURI_) internal virtual {
1885         _baseURI = baseURI_;
1886     }
1887 
1888     /**
1889      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1890      * The call is not executed if the target address is not a contract.
1891      *
1892      * @param from address representing the previous owner of the given token ID
1893      * @param to target address that will receive the tokens
1894      * @param tokenId uint256 ID of the token to be transferred
1895      * @param _data bytes optional data to send along with the call
1896      * @return bool whether the call correctly returned the expected magic value
1897      */
1898     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1899         private returns (bool)
1900     {
1901         if (!to.isContract()) {
1902             return true;
1903         }
1904         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1905             IERC721Receiver(to).onERC721Received.selector,
1906             _msgSender(),
1907             from,
1908             tokenId,
1909             _data
1910         ), "ERC721: transfer to non ERC721Receiver implementer");
1911         bytes4 retval = abi.decode(returndata, (bytes4));
1912         return (retval == _ERC721_RECEIVED);
1913     }
1914 
1915     function _approve(address to, uint256 tokenId) private {
1916         _tokenApprovals[tokenId] = to;
1917         emit Approval(ownerOf(tokenId), to, tokenId);
1918     }
1919 
1920     /**
1921      * @dev Hook that is called before any token transfer. This includes minting
1922      * and burning.
1923      *
1924      * Calling conditions:
1925      *
1926      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1927      * transferred to `to`.
1928      * - When `from` is zero, `tokenId` will be minted for `to`.
1929      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1930      * - `from` cannot be the zero address.
1931      * - `to` cannot be the zero address.
1932      *
1933      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1934      */
1935     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1936 }
1937 
1938 // File: contracts\token\ERC721\ERC721Burnable.sol
1939 
1940 
1941 
1942 
1943 
1944 
1945 
1946 /**
1947  * @title ERC721 Burnable Token
1948  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1949  */
1950 abstract contract ERC721Burnable is Context, ERC721 {
1951     /**
1952      * @dev Burns `tokenId`. See {ERC721-_burn}.
1953      *
1954      * Requirements:
1955      *
1956      * - The caller must own `tokenId` or be an approved operator.
1957      */
1958     function burn(uint256 tokenId) public virtual {
1959         //solhint-disable-next-line max-line-length
1960         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1961         _burn(tokenId);
1962     }
1963 }
1964 
1965 // File: contracts\utils\Pausable.sol
1966 
1967 
1968 
1969 
1970 
1971 
1972 /**
1973  * @dev Contract module which allows children to implement an emergency stop
1974  * mechanism that can be triggered by an authorized account.
1975  *
1976  * This module is used through inheritance. It will make available the
1977  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1978  * the functions of your contract. Note that they will not be pausable by
1979  * simply including this module, only once the modifiers are put in place.
1980  */
1981 contract Pausable is Context {
1982     /**
1983      * @dev Emitted when the pause is triggered by `account`.
1984      */
1985     event Paused(address account);
1986 
1987     /**
1988      * @dev Emitted when the pause is lifted by `account`.
1989      */
1990     event Unpaused(address account);
1991 
1992     bool private _paused;
1993 
1994     /**
1995      * @dev Initializes the contract in unpaused state.
1996      */
1997     constructor () internal {
1998         _paused = false;
1999     }
2000 
2001     /**
2002      * @dev Returns true if the contract is paused, and false otherwise.
2003      */
2004     function paused() public view returns (bool) {
2005         return _paused;
2006     }
2007 
2008     /**
2009      * @dev Modifier to make a function callable only when the contract is not paused.
2010      *
2011      * Requirements:
2012      *
2013      * - The contract must not be paused.
2014      */
2015     modifier whenNotPaused() {
2016         require(!_paused, "Pausable: paused");
2017         _;
2018     }
2019 
2020     /**
2021      * @dev Modifier to make a function callable only when the contract is paused.
2022      *
2023      * Requirements:
2024      *
2025      * - The contract must be paused.
2026      */
2027     modifier whenPaused() {
2028         require(_paused, "Pausable: not paused");
2029         _;
2030     }
2031 
2032     /**
2033      * @dev Triggers stopped state.
2034      *
2035      * Requirements:
2036      *
2037      * - The contract must not be paused.
2038      */
2039     function _pause() internal virtual whenNotPaused {
2040         _paused = true;
2041         emit Paused(_msgSender());
2042     }
2043 
2044     /**
2045      * @dev Returns to normal state.
2046      *
2047      * Requirements:
2048      *
2049      * - The contract must be paused.
2050      */
2051     function _unpause() internal virtual whenPaused {
2052         _paused = false;
2053         emit Unpaused(_msgSender());
2054     }
2055 }
2056 
2057 // File: contracts\token\ERC721\ERC721Pausable.sol
2058 
2059 
2060 
2061 
2062 
2063 
2064 
2065 /**
2066  * @dev ERC721 token with pausable token transfers, minting and burning.
2067  *
2068  * Useful for scenarios such as preventing trades until the end of an evaluation
2069  * period, or having an emergency switch for freezing all token transfers in the
2070  * event of a large bug.
2071  */
2072 abstract contract ERC721Pausable is ERC721, Pausable {
2073     /**
2074      * @dev See {ERC721-_beforeTokenTransfer}.
2075      *
2076      * Requirements:
2077      *
2078      * - the contract must not be paused.
2079      */
2080     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
2081         super._beforeTokenTransfer(from, to, tokenId);
2082 
2083         require(!paused(), "ERC721Pausable: token transfer while paused");
2084     }
2085 }
2086 
2087 // File: contracts\presets\NonFungibleToken.sol
2088 
2089 
2090 
2091 
2092 
2093 
2094 
2095 
2096 
2097 
2098 
2099 /**
2100  * @dev {ERC721} token, including:
2101  *
2102  *  - ability for holders to burn (destroy) their tokens
2103  *  - a minter role that allows for token minting (creation)
2104  *  - a pauser role that allows to stop all token transfers
2105  *  - token ID and URI autogeneration
2106  *
2107  * This contract uses {AccessControl} to lock permissioned functions using the
2108  * different roles - head to its documentation for details.
2109  *
2110  * The account that deploys the contract will be granted the minter and pauser
2111  * roles, as well as the default admin role, which will let it grant both minter
2112  * and pauser roles to other accounts.
2113  */
2114 contract NonFungibleToken is Context, AccessControl, ERC721Burnable, ERC721Pausable {
2115     using Counters for Counters.Counter;
2116 
2117     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2118     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2119     uint256 public maxPerWallet = 100;
2120     address public owner;
2121     uint256 public treasury = 0;
2122     uint256 public nftPerCall = 50;
2123 
2124     Counters.Counter private _tokenIdTracker;
2125 
2126     /**
2127      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2128      * account that deploys the contract.
2129      *
2130      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
2131      * See {ERC721-tokenURI}.
2132      */
2133     constructor(string memory name, string memory symbol, string memory baseURI) public ERC721(name, symbol) {
2134         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2135 
2136         _setupRole(MINTER_ROLE, _msgSender());
2137         _setupRole(PAUSER_ROLE, _msgSender());
2138 
2139         owner = msg.sender;
2140 
2141         _setBaseURI(baseURI);
2142     }
2143 
2144     function setURI(string memory baseURI) public virtual {
2145         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have minter role to mint");
2146         _setBaseURI(baseURI);
2147 
2148     }
2149 
2150     function setOwner(address _owner) public virtual {
2151         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have minter role to mint");
2152         owner = _owner;
2153 
2154     }
2155 
2156     function contractURI() public view returns (string memory) {
2157         return string(abi.encodePacked(baseURI(), "contract-metadata.json"));
2158     }
2159     
2160     function mintOwner() public virtual {
2161         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "NonFungibleToken: must have minter role to mint");
2162         require(treasury < 3, "All treasury NFTs have been minted");
2163         for(uint i = 0; i < nftPerCall; i++){
2164             _mint(msg.sender, _tokenIdTracker.current() +1);
2165             
2166             _tokenIdTracker.increment();
2167         }
2168         treasury = treasury + 1;
2169 
2170     }
2171 /*
2172     function getTokens(uint startIndex, uint endIndex) public view returns (uint[] memory tokens) {
2173         require(startIndex < endIndex, "Invalid index supplied!");
2174         uint len = endIndex.sub(startIndex);
2175         require(len <= totalSupply(), "Invalid length!");
2176         tokens = new uint[](len);
2177 
2178         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
2179             uint listIndex = i.sub(startIndex);
2180             tokens[listIndex] = tokenByIndex(i);
2181         }
2182     }
2183     function getTokens(address holder, uint startIndex, uint endIndex) public view returns (uint[] memory tokens) {
2184         require(startIndex < endIndex, "Invalid index supplied!");
2185         uint len = endIndex.sub(startIndex);
2186         require(len <= balanceOf(holder), "Invalid length!");
2187         tokens = new uint[](len);
2188 
2189         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
2190             uint listIndex = i.sub(startIndex);
2191             tokens[listIndex] = tokenOfOwnerByIndex(holder, i);
2192         }
2193     }*/
2194 
2195     /**
2196      * @dev Creates a new token for `to`. Its token ID will be automatically
2197      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
2198      * URI autogenerated based on the base URI passed at construction.
2199      *
2200      * See {ERC721-_mint}.
2201      *
2202      * Requirements:
2203      *
2204      * - the caller must have the `MINTER_ROLE`.
2205      */
2206     function mint(address to) public virtual {
2207         require(hasRole(MINTER_ROLE, _msgSender()), "NonFungibleToken: must have minter role to mint");
2208         require(balanceOf(to) < maxPerWallet, "Max NFTs reached by wallet");
2209         // We cannot just use balanceOf to create the new tokenId because tokens
2210         // can be burned (destroyed), so we need a separate counter.
2211         _mint(to, _tokenIdTracker.current() +1);
2212         _tokenIdTracker.increment();
2213     }
2214 
2215     /**
2216      * @dev Pauses all token transfers.
2217      *
2218      * See {ERC721Pausable} and {Pausable-_pause}.
2219      *
2220      * Requirements:
2221      *
2222      * - the caller must have the `PAUSER_ROLE`.
2223      */
2224     function pause() public virtual {
2225         require(hasRole(PAUSER_ROLE, _msgSender()), "NonFungibleToken: must have pauser role to pause");
2226         _pause();
2227     }
2228 
2229     /**
2230      * @dev Unpauses all token transfers.
2231      *
2232      * See {ERC721Pausable} and {Pausable-_unpause}.
2233      *
2234      * Requirements:
2235      *
2236      * - the caller must have the `PAUSER_ROLE`.
2237      */
2238     function unpause() public virtual {
2239         require(hasRole(PAUSER_ROLE, _msgSender()), "NonFungibleToken: must have pauser role to unpause");
2240         _unpause();
2241     }
2242 
2243     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Pausable) {
2244         super._beforeTokenTransfer(from, to, tokenId);
2245     }
2246 }