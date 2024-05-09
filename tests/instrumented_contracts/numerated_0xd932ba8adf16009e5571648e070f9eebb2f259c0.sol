1 // SPDX-License-Identifier: UNLICENSED
2 
3 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.3.0
4 pragma solidity >=0.6.0 <0.8.0;
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
27  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
28  * and `uint256` (`UintSet`) are supported.
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
136     // Bytes32Set
137 
138     struct Bytes32Set {
139         Set _inner;
140     }
141 
142     /**
143      * @dev Add a value to a set. O(1).
144      *
145      * Returns true if the value was added to the set, that is if it was not
146      * already present.
147      */
148     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
149         return _add(set._inner, value);
150     }
151 
152     /**
153      * @dev Removes a value from a set. O(1).
154      *
155      * Returns true if the value was removed from the set, that is if it was
156      * present.
157      */
158     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
159         return _remove(set._inner, value);
160     }
161 
162     /**
163      * @dev Returns true if the value is in the set. O(1).
164      */
165     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
166         return _contains(set._inner, value);
167     }
168 
169     /**
170      * @dev Returns the number of values in the set. O(1).
171      */
172     function length(Bytes32Set storage set) internal view returns (uint256) {
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
186     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
187         return _at(set._inner, index);
188     }
189 
190     // AddressSet
191 
192     struct AddressSet {
193         Set _inner;
194     }
195 
196     /**
197      * @dev Add a value to a set. O(1).
198      *
199      * Returns true if the value was added to the set, that is if it was not
200      * already present.
201      */
202     function add(AddressSet storage set, address value) internal returns (bool) {
203         return _add(set._inner, bytes32(uint256(value)));
204     }
205 
206     /**
207      * @dev Removes a value from a set. O(1).
208      *
209      * Returns true if the value was removed from the set, that is if it was
210      * present.
211      */
212     function remove(AddressSet storage set, address value) internal returns (bool) {
213         return _remove(set._inner, bytes32(uint256(value)));
214     }
215 
216     /**
217      * @dev Returns true if the value is in the set. O(1).
218      */
219     function contains(AddressSet storage set, address value) internal view returns (bool) {
220         return _contains(set._inner, bytes32(uint256(value)));
221     }
222 
223     /**
224      * @dev Returns the number of values in the set. O(1).
225      */
226     function length(AddressSet storage set) internal view returns (uint256) {
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
240     function at(AddressSet storage set, uint256 index) internal view returns (address) {
241         return address(uint256(_at(set._inner, index)));
242     }
243 
244 
245     // UintSet
246 
247     struct UintSet {
248         Set _inner;
249     }
250 
251     /**
252      * @dev Add a value to a set. O(1).
253      *
254      * Returns true if the value was added to the set, that is if it was not
255      * already present.
256      */
257     function add(UintSet storage set, uint256 value) internal returns (bool) {
258         return _add(set._inner, bytes32(value));
259     }
260 
261     /**
262      * @dev Removes a value from a set. O(1).
263      *
264      * Returns true if the value was removed from the set, that is if it was
265      * present.
266      */
267     function remove(UintSet storage set, uint256 value) internal returns (bool) {
268         return _remove(set._inner, bytes32(value));
269     }
270 
271     /**
272      * @dev Returns true if the value is in the set. O(1).
273      */
274     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
275         return _contains(set._inner, bytes32(value));
276     }
277 
278     /**
279      * @dev Returns the number of values on the set. O(1).
280      */
281     function length(UintSet storage set) internal view returns (uint256) {
282         return _length(set._inner);
283     }
284 
285    /**
286     * @dev Returns the value stored at position `index` in the set. O(1).
287     *
288     * Note that there are no guarantees on the ordering of values inside the
289     * array, and it may change when more values are added or removed.
290     *
291     * Requirements:
292     *
293     * - `index` must be strictly less than {length}.
294     */
295     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
296         return uint256(_at(set._inner, index));
297     }
298 }
299 
300 
301 // File @openzeppelin/contracts/utils/Address.sol@v3.3.0
302 pragma solidity >=0.6.2 <0.8.0;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         uint256 size;
331         // solhint-disable-next-line no-inline-assembly
332         assembly { size := extcodesize(account) }
333         return size > 0;
334     }
335 
336     /**
337      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
338      * `recipient`, forwarding all available gas and reverting on errors.
339      *
340      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
341      * of certain opcodes, possibly making contracts go over the 2300 gas limit
342      * imposed by `transfer`, making them unable to receive funds via
343      * `transfer`. {sendValue} removes this limitation.
344      *
345      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
346      *
347      * IMPORTANT: because control is transferred to `recipient`, care must be
348      * taken to not create reentrancy vulnerabilities. Consider using
349      * {ReentrancyGuard} or the
350      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
351      */
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(address(this).balance >= amount, "Address: insufficient balance");
354 
355         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
356         (bool success, ) = recipient.call{ value: amount }("");
357         require(success, "Address: unable to send value, recipient may have reverted");
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain`call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
379       return functionCall(target, data, "Address: low-level call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
384      * `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
414         require(address(this).balance >= value, "Address: insufficient balance for call");
415         require(isContract(target), "Address: call to non-contract");
416 
417         // solhint-disable-next-line avoid-low-level-calls
418         (bool success, bytes memory returndata) = target.call{ value: value }(data);
419         return _verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
429         return functionStaticCall(target, data, "Address: low-level static call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
439         require(isContract(target), "Address: static call to non-contract");
440 
441         // solhint-disable-next-line avoid-low-level-calls
442         (bool success, bytes memory returndata) = target.staticcall(data);
443         return _verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 // solhint-disable-next-line no-inline-assembly
455                 assembly {
456                     let returndata_size := mload(returndata)
457                     revert(add(32, returndata), returndata_size)
458                 }
459             } else {
460                 revert(errorMessage);
461             }
462         }
463     }
464 }
465 
466 
467 // File @openzeppelin/contracts/GSN/Context.sol@v3.3.0
468 pragma solidity >=0.6.0 <0.8.0;
469 
470 /*
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with GSN meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address payable) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes memory) {
486         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
487         return msg.data;
488     }
489 }
490 
491 
492 // File @openzeppelin/contracts/access/AccessControl.sol@v3.3.0
493 pragma solidity >=0.6.0 <0.8.0;
494 
495 
496 
497 /**
498  * @dev Contract module that allows children to implement role-based access
499  * control mechanisms.
500  *
501  * Roles are referred to by their `bytes32` identifier. These should be exposed
502  * in the external API and be unique. The best way to achieve this is by
503  * using `public constant` hash digests:
504  *
505  * ```
506  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
507  * ```
508  *
509  * Roles can be used to represent a set of permissions. To restrict access to a
510  * function call, use {hasRole}:
511  *
512  * ```
513  * function foo() public {
514  *     require(hasRole(MY_ROLE, msg.sender));
515  *     ...
516  * }
517  * ```
518  *
519  * Roles can be granted and revoked dynamically via the {grantRole} and
520  * {revokeRole} functions. Each role has an associated admin role, and only
521  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
522  *
523  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
524  * that only accounts with this role will be able to grant or revoke other
525  * roles. More complex role relationships can be created by using
526  * {_setRoleAdmin}.
527  *
528  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
529  * grant and revoke this role. Extra precautions should be taken to secure
530  * accounts that have been granted it.
531  */
532 abstract contract AccessControl is Context {
533     using EnumerableSet for EnumerableSet.AddressSet;
534     using Address for address;
535 
536     struct RoleData {
537         EnumerableSet.AddressSet members;
538         bytes32 adminRole;
539     }
540 
541     mapping (bytes32 => RoleData) private _roles;
542 
543     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
544 
545     /**
546      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
547      *
548      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
549      * {RoleAdminChanged} not being emitted signaling this.
550      *
551      * _Available since v3.1._
552      */
553     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
554 
555     /**
556      * @dev Emitted when `account` is granted `role`.
557      *
558      * `sender` is the account that originated the contract call, an admin role
559      * bearer except when using {_setupRole}.
560      */
561     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
562 
563     /**
564      * @dev Emitted when `account` is revoked `role`.
565      *
566      * `sender` is the account that originated the contract call:
567      *   - if using `revokeRole`, it is the admin role bearer
568      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
569      */
570     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
571 
572     /**
573      * @dev Returns `true` if `account` has been granted `role`.
574      */
575     function hasRole(bytes32 role, address account) public view returns (bool) {
576         return _roles[role].members.contains(account);
577     }
578 
579     /**
580      * @dev Returns the number of accounts that have `role`. Can be used
581      * together with {getRoleMember} to enumerate all bearers of a role.
582      */
583     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
584         return _roles[role].members.length();
585     }
586 
587     /**
588      * @dev Returns one of the accounts that have `role`. `index` must be a
589      * value between 0 and {getRoleMemberCount}, non-inclusive.
590      *
591      * Role bearers are not sorted in any particular way, and their ordering may
592      * change at any point.
593      *
594      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
595      * you perform all queries on the same block. See the following
596      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
597      * for more information.
598      */
599     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
600         return _roles[role].members.at(index);
601     }
602 
603     /**
604      * @dev Returns the admin role that controls `role`. See {grantRole} and
605      * {revokeRole}.
606      *
607      * To change a role's admin, use {_setRoleAdmin}.
608      */
609     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
610         return _roles[role].adminRole;
611     }
612 
613     /**
614      * @dev Grants `role` to `account`.
615      *
616      * If `account` had not been already granted `role`, emits a {RoleGranted}
617      * event.
618      *
619      * Requirements:
620      *
621      * - the caller must have ``role``'s admin role.
622      */
623     function grantRole(bytes32 role, address account) public virtual {
624         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
625 
626         _grantRole(role, account);
627     }
628 
629     /**
630      * @dev Revokes `role` from `account`.
631      *
632      * If `account` had been granted `role`, emits a {RoleRevoked} event.
633      *
634      * Requirements:
635      *
636      * - the caller must have ``role``'s admin role.
637      */
638     function revokeRole(bytes32 role, address account) public virtual {
639         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
640 
641         _revokeRole(role, account);
642     }
643 
644     /**
645      * @dev Revokes `role` from the calling account.
646      *
647      * Roles are often managed via {grantRole} and {revokeRole}: this function's
648      * purpose is to provide a mechanism for accounts to lose their privileges
649      * if they are compromised (such as when a trusted device is misplaced).
650      *
651      * If the calling account had been granted `role`, emits a {RoleRevoked}
652      * event.
653      *
654      * Requirements:
655      *
656      * - the caller must be `account`.
657      */
658     function renounceRole(bytes32 role, address account) public virtual {
659         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
660 
661         _revokeRole(role, account);
662     }
663 
664     /**
665      * @dev Grants `role` to `account`.
666      *
667      * If `account` had not been already granted `role`, emits a {RoleGranted}
668      * event. Note that unlike {grantRole}, this function doesn't perform any
669      * checks on the calling account.
670      *
671      * [WARNING]
672      * ====
673      * This function should only be called from the constructor when setting
674      * up the initial roles for the system.
675      *
676      * Using this function in any other way is effectively circumventing the admin
677      * system imposed by {AccessControl}.
678      * ====
679      */
680     function _setupRole(bytes32 role, address account) internal virtual {
681         _grantRole(role, account);
682     }
683 
684     /**
685      * @dev Sets `adminRole` as ``role``'s admin role.
686      *
687      * Emits a {RoleAdminChanged} event.
688      */
689     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
690         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
691         _roles[role].adminRole = adminRole;
692     }
693 
694     function _grantRole(bytes32 role, address account) private {
695         if (_roles[role].members.add(account)) {
696             emit RoleGranted(role, account, _msgSender());
697         }
698     }
699 
700     function _revokeRole(bytes32 role, address account) private {
701         if (_roles[role].members.remove(account)) {
702             emit RoleRevoked(role, account, _msgSender());
703         }
704     }
705 }
706 
707 
708 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
709 pragma solidity >=0.6.0 <0.8.0;
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
867 
868 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0
869 pragma solidity >=0.6.0 <0.8.0;
870 
871 /**
872  * @dev Interface of the ERC20 standard as defined in the EIP.
873  */
874 interface IERC20 {
875     /**
876      * @dev Returns the amount of tokens in existence.
877      */
878     function totalSupply() external view returns (uint256);
879 
880     /**
881      * @dev Returns the amount of tokens owned by `account`.
882      */
883     function balanceOf(address account) external view returns (uint256);
884 
885     /**
886      * @dev Moves `amount` tokens from the caller's account to `recipient`.
887      *
888      * Returns a boolean value indicating whether the operation succeeded.
889      *
890      * Emits a {Transfer} event.
891      */
892     function transfer(address recipient, uint256 amount) external returns (bool);
893 
894     /**
895      * @dev Returns the remaining number of tokens that `spender` will be
896      * allowed to spend on behalf of `owner` through {transferFrom}. This is
897      * zero by default.
898      *
899      * This value changes when {approve} or {transferFrom} are called.
900      */
901     function allowance(address owner, address spender) external view returns (uint256);
902 
903     /**
904      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
905      *
906      * Returns a boolean value indicating whether the operation succeeded.
907      *
908      * IMPORTANT: Beware that changing an allowance with this method brings the risk
909      * that someone may use both the old and the new allowance by unfortunate
910      * transaction ordering. One possible solution to mitigate this race
911      * condition is to first reduce the spender's allowance to 0 and set the
912      * desired value afterwards:
913      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
914      *
915      * Emits an {Approval} event.
916      */
917     function approve(address spender, uint256 amount) external returns (bool);
918 
919     /**
920      * @dev Moves `amount` tokens from `sender` to `recipient` using the
921      * allowance mechanism. `amount` is then deducted from the caller's
922      * allowance.
923      *
924      * Returns a boolean value indicating whether the operation succeeded.
925      *
926      * Emits a {Transfer} event.
927      */
928     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
929 
930     /**
931      * @dev Emitted when `value` tokens are moved from one account (`from`) to
932      * another (`to`).
933      *
934      * Note that `value` may be zero.
935      */
936     event Transfer(address indexed from, address indexed to, uint256 value);
937 
938     /**
939      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
940      * a call to {approve}. `value` is the new allowance.
941      */
942     event Approval(address indexed owner, address indexed spender, uint256 value);
943 }
944 
945 
946 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.3.0
947 pragma solidity >=0.6.0 <0.8.0;
948 
949 
950 
951 /**
952  * @dev Implementation of the {IERC20} interface.
953  *
954  * This implementation is agnostic to the way tokens are created. This means
955  * that a supply mechanism has to be added in a derived contract using {_mint}.
956  * For a generic mechanism see {ERC20PresetMinterPauser}.
957  *
958  * TIP: For a detailed writeup see our guide
959  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
960  * to implement supply mechanisms].
961  *
962  * We have followed general OpenZeppelin guidelines: functions revert instead
963  * of returning `false` on failure. This behavior is nonetheless conventional
964  * and does not conflict with the expectations of ERC20 applications.
965  *
966  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
967  * This allows applications to reconstruct the allowance for all accounts just
968  * by listening to said events. Other implementations of the EIP may not emit
969  * these events, as it isn't required by the specification.
970  *
971  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
972  * functions have been added to mitigate the well-known issues around setting
973  * allowances. See {IERC20-approve}.
974  */
975 contract ERC20 is Context, IERC20 {
976     using SafeMath for uint256;
977 
978     mapping (address => uint256) private _balances;
979 
980     mapping (address => mapping (address => uint256)) private _allowances;
981 
982     uint256 private _totalSupply;
983 
984     string private _name;
985     string private _symbol;
986     uint8 private _decimals;
987 
988     /**
989      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
990      * a default value of 18.
991      *
992      * To select a different value for {decimals}, use {_setupDecimals}.
993      *
994      * All three of these values are immutable: they can only be set once during
995      * construction.
996      */
997     constructor (string memory name_, string memory symbol_) public {
998         _name = name_;
999         _symbol = symbol_;
1000         _decimals = 18;
1001     }
1002 
1003     /**
1004      * @dev Returns the name of the token.
1005      */
1006     function name() public view returns (string memory) {
1007         return _name;
1008     }
1009 
1010     /**
1011      * @dev Returns the symbol of the token, usually a shorter version of the
1012      * name.
1013      */
1014     function symbol() public view returns (string memory) {
1015         return _symbol;
1016     }
1017 
1018     /**
1019      * @dev Returns the number of decimals used to get its user representation.
1020      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1021      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1022      *
1023      * Tokens usually opt for a value of 18, imitating the relationship between
1024      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1025      * called.
1026      *
1027      * NOTE: This information is only used for _display_ purposes: it in
1028      * no way affects any of the arithmetic of the contract, including
1029      * {IERC20-balanceOf} and {IERC20-transfer}.
1030      */
1031     function decimals() public view returns (uint8) {
1032         return _decimals;
1033     }
1034 
1035     /**
1036      * @dev See {IERC20-totalSupply}.
1037      */
1038     function totalSupply() public view override returns (uint256) {
1039         return _totalSupply;
1040     }
1041 
1042     /**
1043      * @dev See {IERC20-balanceOf}.
1044      */
1045     function balanceOf(address account) public view override returns (uint256) {
1046         return _balances[account];
1047     }
1048 
1049     /**
1050      * @dev See {IERC20-transfer}.
1051      *
1052      * Requirements:
1053      *
1054      * - `recipient` cannot be the zero address.
1055      * - the caller must have a balance of at least `amount`.
1056      */
1057     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1058         _transfer(_msgSender(), recipient, amount);
1059         return true;
1060     }
1061 
1062     /**
1063      * @dev See {IERC20-allowance}.
1064      */
1065     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1066         return _allowances[owner][spender];
1067     }
1068 
1069     /**
1070      * @dev See {IERC20-approve}.
1071      *
1072      * Requirements:
1073      *
1074      * - `spender` cannot be the zero address.
1075      */
1076     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1077         _approve(_msgSender(), spender, amount);
1078         return true;
1079     }
1080 
1081     /**
1082      * @dev See {IERC20-transferFrom}.
1083      *
1084      * Emits an {Approval} event indicating the updated allowance. This is not
1085      * required by the EIP. See the note at the beginning of {ERC20}.
1086      *
1087      * Requirements:
1088      *
1089      * - `sender` and `recipient` cannot be the zero address.
1090      * - `sender` must have a balance of at least `amount`.
1091      * - the caller must have allowance for ``sender``'s tokens of at least
1092      * `amount`.
1093      */
1094     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1095         _transfer(sender, recipient, amount);
1096         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1097         return true;
1098     }
1099 
1100     /**
1101      * @dev Atomically increases the allowance granted to `spender` by the caller.
1102      *
1103      * This is an alternative to {approve} that can be used as a mitigation for
1104      * problems described in {IERC20-approve}.
1105      *
1106      * Emits an {Approval} event indicating the updated allowance.
1107      *
1108      * Requirements:
1109      *
1110      * - `spender` cannot be the zero address.
1111      */
1112     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1113         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1114         return true;
1115     }
1116 
1117     /**
1118      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1119      *
1120      * This is an alternative to {approve} that can be used as a mitigation for
1121      * problems described in {IERC20-approve}.
1122      *
1123      * Emits an {Approval} event indicating the updated allowance.
1124      *
1125      * Requirements:
1126      *
1127      * - `spender` cannot be the zero address.
1128      * - `spender` must have allowance for the caller of at least
1129      * `subtractedValue`.
1130      */
1131     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1132         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1133         return true;
1134     }
1135 
1136     /**
1137      * @dev Moves tokens `amount` from `sender` to `recipient`.
1138      *
1139      * This is internal function is equivalent to {transfer}, and can be used to
1140      * e.g. implement automatic token fees, slashing mechanisms, etc.
1141      *
1142      * Emits a {Transfer} event.
1143      *
1144      * Requirements:
1145      *
1146      * - `sender` cannot be the zero address.
1147      * - `recipient` cannot be the zero address.
1148      * - `sender` must have a balance of at least `amount`.
1149      */
1150     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1151         require(sender != address(0), "ERC20: transfer from the zero address");
1152         require(recipient != address(0), "ERC20: transfer to the zero address");
1153 
1154         _beforeTokenTransfer(sender, recipient, amount);
1155 
1156         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1157         _balances[recipient] = _balances[recipient].add(amount);
1158         emit Transfer(sender, recipient, amount);
1159     }
1160 
1161     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1162      * the total supply.
1163      *
1164      * Emits a {Transfer} event with `from` set to the zero address.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      */
1170     function _mint(address account, uint256 amount) internal virtual {
1171         require(account != address(0), "ERC20: mint to the zero address");
1172 
1173         _beforeTokenTransfer(address(0), account, amount);
1174 
1175         _totalSupply = _totalSupply.add(amount);
1176         _balances[account] = _balances[account].add(amount);
1177         emit Transfer(address(0), account, amount);
1178     }
1179 
1180     /**
1181      * @dev Destroys `amount` tokens from `account`, reducing the
1182      * total supply.
1183      *
1184      * Emits a {Transfer} event with `to` set to the zero address.
1185      *
1186      * Requirements:
1187      *
1188      * - `account` cannot be the zero address.
1189      * - `account` must have at least `amount` tokens.
1190      */
1191     function _burn(address account, uint256 amount) internal virtual {
1192         require(account != address(0), "ERC20: burn from the zero address");
1193 
1194         _beforeTokenTransfer(account, address(0), amount);
1195 
1196         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1197         _totalSupply = _totalSupply.sub(amount);
1198         emit Transfer(account, address(0), amount);
1199     }
1200 
1201     /**
1202      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1203      *
1204      * This internal function is equivalent to `approve`, and can be used to
1205      * e.g. set automatic allowances for certain subsystems, etc.
1206      *
1207      * Emits an {Approval} event.
1208      *
1209      * Requirements:
1210      *
1211      * - `owner` cannot be the zero address.
1212      * - `spender` cannot be the zero address.
1213      */
1214     function _approve(address owner, address spender, uint256 amount) internal virtual {
1215         require(owner != address(0), "ERC20: approve from the zero address");
1216         require(spender != address(0), "ERC20: approve to the zero address");
1217 
1218         _allowances[owner][spender] = amount;
1219         emit Approval(owner, spender, amount);
1220     }
1221 
1222     /**
1223      * @dev Sets {decimals} to a value other than the default one of 18.
1224      *
1225      * WARNING: This function should only be called from the constructor. Most
1226      * applications that interact with token contracts will not expect
1227      * {decimals} to ever change, and may work incorrectly if it does.
1228      */
1229     function _setupDecimals(uint8 decimals_) internal {
1230         _decimals = decimals_;
1231     }
1232 
1233     /**
1234      * @dev Hook that is called before any transfer of tokens. This includes
1235      * minting and burning.
1236      *
1237      * Calling conditions:
1238      *
1239      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1240      * will be to transferred to `to`.
1241      * - when `from` is zero, `amount` tokens will be minted for `to`.
1242      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1243      * - `from` and `to` are never both zero.
1244      *
1245      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1246      */
1247     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1248 }
1249 
1250 
1251 // File contracts/token/erc20/IERC20Mintable.sol
1252 pragma solidity >=0.6.0 <0.8.0;
1253 
1254 /// @title IERC20 with mint function
1255 /// @author Le Brian
1256 /// @notice Add mintable function to IERC20
1257 interface IERC20Mintable {
1258     function mint(address to, uint256 amount) external returns(bool);
1259 }
1260 
1261 
1262 // File contracts/token/erc20/Aeternalism.sol
1263 pragma solidity >=0.6.0 <0.8.0;
1264 
1265 
1266 
1267 
1268 /// @title Aeternalism smart contract
1269 /// @author Le Brian
1270 /// @notice This contract is used for trading, token sale event and future DAO
1271 contract Aeternalism is ERC20, IERC20Mintable, AccessControl {
1272 
1273     using SafeMath for uint256;
1274 
1275     uint256 private _cap = 10**24;
1276     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1277 
1278     constructor()
1279         ERC20("Aeternalism", "AES")
1280     {
1281         /// deployer will be the default admin
1282         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1283         /// grant MINTER role to deployer & issuance contract to mint token to investors
1284         grantRole(MINTER_ROLE, msg.sender);
1285         grantRole(MINTER_ROLE, 0xC0F5c3aB6e76B30deec963c86175F0f4e75a16A9);
1286     }
1287 
1288     /// @notice Hook before token transfer
1289     /// @param from Address transfer token - Address(0) means minting
1290     /// @param to Address to receive token
1291     /// @param amount Amount to transfer (decimals 18)
1292     function _beforeTokenTransfer(address from, address to, uint256 amount) 
1293         internal 
1294         virtual 
1295         override
1296     {
1297         super._beforeTokenTransfer(from, to, amount);
1298 
1299         /// check minting doesn't exceed _cap
1300         if (from == address(0)) {
1301             require(totalSupply().add(amount) <= _cap, "Max cap reached");
1302         }
1303     }
1304     
1305     /// @notice Mint token to specific address
1306     /// @dev Requires sender has MINTER role
1307     /// @param to address to receive token
1308     /// @param amount amount to mint (decimals 18)
1309     function mint(address to, uint256 amount)
1310         external
1311         override
1312         returns(bool)
1313     {
1314         require(hasRole(MINTER_ROLE, msg.sender), "Not a minter");
1315         super._mint(to, amount);
1316     }
1317 }