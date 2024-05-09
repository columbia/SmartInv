1 // SPDX-License-Identifier: MIT
2 // Micro Tuber
3 
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
300 pragma solidity >=0.6.2 <0.8.0;
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
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.3._
449      */
450     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
451         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.3._
459      */
460     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
461         require(isContract(target), "Address: delegate call to non-contract");
462 
463         // solhint-disable-next-line avoid-low-level-calls
464         (bool success, bytes memory returndata) = target.delegatecall(data);
465         return _verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
469         if (success) {
470             return returndata;
471         } else {
472             // Look for revert reason and bubble it up if present
473             if (returndata.length > 0) {
474                 // The easiest way to bubble the revert reason is using memory via assembly
475 
476                 // solhint-disable-next-line no-inline-assembly
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 pragma solidity >=0.6.0 <0.8.0;
489 
490 /*
491  * @dev Provides information about the current execution context, including the
492  * sender of the transaction and its data. While these are generally available
493  * via msg.sender and msg.data, they should not be accessed in such a direct
494  * manner, since when dealing with GSN meta-transactions the account sending and
495  * paying for execution may not be the actual sender (as far as an application
496  * is concerned).
497  *
498  * This contract is only required for intermediate, library-like contracts.
499  */
500 abstract contract Context {
501     function _msgSender() internal view virtual returns (address payable) {
502         return msg.sender;
503     }
504 
505     function _msgData() internal view virtual returns (bytes memory) {
506         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
507         return msg.data;
508     }
509 }
510 
511 pragma solidity >=0.6.0 <0.8.0;
512 
513 /**
514  * @dev Contract module that allows children to implement role-based access
515  * control mechanisms.
516  *
517  * Roles are referred to by their `bytes32` identifier. These should be exposed
518  * in the external API and be unique. The best way to achieve this is by
519  * using `public constant` hash digests:
520  *
521  * ```
522  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
523  * ```
524  *
525  * Roles can be used to represent a set of permissions. To restrict access to a
526  * function call, use {hasRole}:
527  *
528  * ```
529  * function foo() public {
530  *     require(hasRole(MY_ROLE, msg.sender));
531  *     ...
532  * }
533  * ```
534  *
535  * Roles can be granted and revoked dynamically via the {grantRole} and
536  * {revokeRole} functions. Each role has an associated admin role, and only
537  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
538  *
539  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
540  * that only accounts with this role will be able to grant or revoke other
541  * roles. More complex role relationships can be created by using
542  * {_setRoleAdmin}.
543  *
544  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
545  * grant and revoke this role. Extra precautions should be taken to secure
546  * accounts that have been granted it.
547  */
548 abstract contract AccessControl is Context {
549     using EnumerableSet for EnumerableSet.AddressSet;
550     using Address for address;
551 
552     struct RoleData {
553         EnumerableSet.AddressSet members;
554         bytes32 adminRole;
555     }
556 
557     mapping (bytes32 => RoleData) private _roles;
558 
559     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
560 
561     /**
562      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
563      *
564      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
565      * {RoleAdminChanged} not being emitted signaling this.
566      *
567      * _Available since v3.1._
568      */
569     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
570 
571     /**
572      * @dev Emitted when `account` is granted `role`.
573      *
574      * `sender` is the account that originated the contract call, an admin role
575      * bearer except when using {_setupRole}.
576      */
577     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
578 
579     /**
580      * @dev Emitted when `account` is revoked `role`.
581      *
582      * `sender` is the account that originated the contract call:
583      *   - if using `revokeRole`, it is the admin role bearer
584      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
585      */
586     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
587 
588     /**
589      * @dev Returns `true` if `account` has been granted `role`.
590      */
591     function hasRole(bytes32 role, address account) public view returns (bool) {
592         return _roles[role].members.contains(account);
593     }
594 
595     /**
596      * @dev Returns the number of accounts that have `role`. Can be used
597      * together with {getRoleMember} to enumerate all bearers of a role.
598      */
599     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
600         return _roles[role].members.length();
601     }
602 
603     /**
604      * @dev Returns one of the accounts that have `role`. `index` must be a
605      * value between 0 and {getRoleMemberCount}, non-inclusive.
606      *
607      * Role bearers are not sorted in any particular way, and their ordering may
608      * change at any point.
609      *
610      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
611      * you perform all queries on the same block. See the following
612      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
613      * for more information.
614      */
615     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
616         return _roles[role].members.at(index);
617     }
618 
619     /**
620      * @dev Returns the admin role that controls `role`. See {grantRole} and
621      * {revokeRole}.
622      *
623      * To change a role's admin, use {_setRoleAdmin}.
624      */
625     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
626         return _roles[role].adminRole;
627     }
628 
629     /**
630      * @dev Grants `role` to `account`.
631      *
632      * If `account` had not been already granted `role`, emits a {RoleGranted}
633      * event.
634      *
635      * Requirements:
636      *
637      * - the caller must have ``role``'s admin role.
638      */
639     function grantRole(bytes32 role, address account) public virtual {
640         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
641 
642         _grantRole(role, account);
643     }
644 
645     /**
646      * @dev Revokes `role` from `account`.
647      *
648      * If `account` had been granted `role`, emits a {RoleRevoked} event.
649      *
650      * Requirements:
651      *
652      * - the caller must have ``role``'s admin role.
653      */
654     function revokeRole(bytes32 role, address account) public virtual {
655         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
656 
657         _revokeRole(role, account);
658     }
659 
660     /**
661      * @dev Revokes `role` from the calling account.
662      *
663      * Roles are often managed via {grantRole} and {revokeRole}: this function's
664      * purpose is to provide a mechanism for accounts to lose their privileges
665      * if they are compromised (such as when a trusted device is misplaced).
666      *
667      * If the calling account had been granted `role`, emits a {RoleRevoked}
668      * event.
669      *
670      * Requirements:
671      *
672      * - the caller must be `account`.
673      */
674     function renounceRole(bytes32 role, address account) public virtual {
675         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
676 
677         _revokeRole(role, account);
678     }
679 
680     /**
681      * @dev Grants `role` to `account`.
682      *
683      * If `account` had not been already granted `role`, emits a {RoleGranted}
684      * event. Note that unlike {grantRole}, this function doesn't perform any
685      * checks on the calling account.
686      *
687      * [WARNING]
688      * ====
689      * This function should only be called from the constructor when setting
690      * up the initial roles for the system.
691      *
692      * Using this function in any other way is effectively circumventing the admin
693      * system imposed by {AccessControl}.
694      * ====
695      */
696     function _setupRole(bytes32 role, address account) internal virtual {
697         _grantRole(role, account);
698     }
699 
700     /**
701      * @dev Sets `adminRole` as ``role``'s admin role.
702      *
703      * Emits a {RoleAdminChanged} event.
704      */
705     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
706         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
707         _roles[role].adminRole = adminRole;
708     }
709 
710     function _grantRole(bytes32 role, address account) private {
711         if (_roles[role].members.add(account)) {
712             emit RoleGranted(role, account, _msgSender());
713         }
714     }
715 
716     function _revokeRole(bytes32 role, address account) private {
717         if (_roles[role].members.remove(account)) {
718             emit RoleRevoked(role, account, _msgSender());
719         }
720     }
721 }
722 
723 pragma solidity >=0.6.0 <0.8.0;
724 
725 /**
726  * @dev Interface of the ERC20 standard as defined in the EIP.
727  */
728 interface IERC20 {
729     /**
730      * @dev Returns the amount of tokens in existence.
731      */
732     function totalSupply() external view returns (uint256);
733 
734     /**
735      * @dev Returns the amount of tokens owned by `account`.
736      */
737     function balanceOf(address account) external view returns (uint256);
738 
739     /**
740      * @dev Moves `amount` tokens from the caller's account to `recipient`.
741      *
742      * Returns a boolean value indicating whether the operation succeeded.
743      *
744      * Emits a {Transfer} event.
745      */
746     function transfer(address recipient, uint256 amount) external returns (bool);
747 
748     /**
749      * @dev Returns the remaining number of tokens that `spender` will be
750      * allowed to spend on behalf of `owner` through {transferFrom}. This is
751      * zero by default.
752      *
753      * This value changes when {approve} or {transferFrom} are called.
754      */
755     function allowance(address owner, address spender) external view returns (uint256);
756 
757     /**
758      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
759      *
760      * Returns a boolean value indicating whether the operation succeeded.
761      *
762      * IMPORTANT: Beware that changing an allowance with this method brings the risk
763      * that someone may use both the old and the new allowance by unfortunate
764      * transaction ordering. One possible solution to mitigate this race
765      * condition is to first reduce the spender's allowance to 0 and set the
766      * desired value afterwards:
767      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
768      *
769      * Emits an {Approval} event.
770      */
771     function approve(address spender, uint256 amount) external returns (bool);
772 
773     /**
774      * @dev Moves `amount` tokens from `sender` to `recipient` using the
775      * allowance mechanism. `amount` is then deducted from the caller's
776      * allowance.
777      *
778      * Returns a boolean value indicating whether the operation succeeded.
779      *
780      * Emits a {Transfer} event.
781      */
782     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
783 
784     /**
785      * @dev Emitted when `value` tokens are moved from one account (`from`) to
786      * another (`to`).
787      *
788      * Note that `value` may be zero.
789      */
790     event Transfer(address indexed from, address indexed to, uint256 value);
791 
792     /**
793      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
794      * a call to {approve}. `value` is the new allowance.
795      */
796     event Approval(address indexed owner, address indexed spender, uint256 value);
797 }
798 
799 pragma solidity >=0.6.0 <0.8.0;
800 
801 /**
802  * @dev Wrappers over Solidity's arithmetic operations with added overflow
803  * checks.
804  *
805  * Arithmetic operations in Solidity wrap on overflow. This can easily result
806  * in bugs, because programmers usually assume that an overflow raises an
807  * error, which is the standard behavior in high level programming languages.
808  * `SafeMath` restores this intuition by reverting the transaction when an
809  * operation overflows.
810  *
811  * Using this library instead of the unchecked operations eliminates an entire
812  * class of bugs, so it's recommended to use it always.
813  */
814 library SafeMath {
815     /**
816      * @dev Returns the addition of two unsigned integers, reverting on
817      * overflow.
818      *
819      * Counterpart to Solidity's `+` operator.
820      *
821      * Requirements:
822      *
823      * - Addition cannot overflow.
824      */
825     function add(uint256 a, uint256 b) internal pure returns (uint256) {
826         uint256 c = a + b;
827         require(c >= a, "SafeMath: addition overflow");
828 
829         return c;
830     }
831 
832     /**
833      * @dev Returns the subtraction of two unsigned integers, reverting on
834      * overflow (when the result is negative).
835      *
836      * Counterpart to Solidity's `-` operator.
837      *
838      * Requirements:
839      *
840      * - Subtraction cannot overflow.
841      */
842     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
843         return sub(a, b, "SafeMath: subtraction overflow");
844     }
845 
846     /**
847      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
848      * overflow (when the result is negative).
849      *
850      * Counterpart to Solidity's `-` operator.
851      *
852      * Requirements:
853      *
854      * - Subtraction cannot overflow.
855      */
856     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
857         require(b <= a, errorMessage);
858         uint256 c = a - b;
859 
860         return c;
861     }
862 
863     /**
864      * @dev Returns the multiplication of two unsigned integers, reverting on
865      * overflow.
866      *
867      * Counterpart to Solidity's `*` operator.
868      *
869      * Requirements:
870      *
871      * - Multiplication cannot overflow.
872      */
873     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
874         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
875         // benefit is lost if 'b' is also tested.
876         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
877         if (a == 0) {
878             return 0;
879         }
880 
881         uint256 c = a * b;
882         require(c / a == b, "SafeMath: multiplication overflow");
883 
884         return c;
885     }
886 
887     /**
888      * @dev Returns the integer division of two unsigned integers. Reverts on
889      * division by zero. The result is rounded towards zero.
890      *
891      * Counterpart to Solidity's `/` operator. Note: this function uses a
892      * `revert` opcode (which leaves remaining gas untouched) while Solidity
893      * uses an invalid opcode to revert (consuming all remaining gas).
894      *
895      * Requirements:
896      *
897      * - The divisor cannot be zero.
898      */
899     function div(uint256 a, uint256 b) internal pure returns (uint256) {
900         return div(a, b, "SafeMath: division by zero");
901     }
902 
903     /**
904      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
905      * division by zero. The result is rounded towards zero.
906      *
907      * Counterpart to Solidity's `/` operator. Note: this function uses a
908      * `revert` opcode (which leaves remaining gas untouched) while Solidity
909      * uses an invalid opcode to revert (consuming all remaining gas).
910      *
911      * Requirements:
912      *
913      * - The divisor cannot be zero.
914      */
915     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
916         require(b > 0, errorMessage);
917         uint256 c = a / b;
918         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
919 
920         return c;
921     }
922 
923     /**
924      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
925      * Reverts when dividing by zero.
926      *
927      * Counterpart to Solidity's `%` operator. This function uses a `revert`
928      * opcode (which leaves remaining gas untouched) while Solidity uses an
929      * invalid opcode to revert (consuming all remaining gas).
930      *
931      * Requirements:
932      *
933      * - The divisor cannot be zero.
934      */
935     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
936         return mod(a, b, "SafeMath: modulo by zero");
937     }
938 
939     /**
940      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
941      * Reverts with custom message when dividing by zero.
942      *
943      * Counterpart to Solidity's `%` operator. This function uses a `revert`
944      * opcode (which leaves remaining gas untouched) while Solidity uses an
945      * invalid opcode to revert (consuming all remaining gas).
946      *
947      * Requirements:
948      *
949      * - The divisor cannot be zero.
950      */
951     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
952         require(b != 0, errorMessage);
953         return a % b;
954     }
955 }
956 
957 pragma solidity >=0.6.0 <0.8.0;
958 
959 /**
960  * @dev Implementation of the {IERC20} interface.
961  *
962  * This implementation is agnostic to the way tokens are created. This means
963  * that a supply mechanism has to be added in a derived contract using {_mint}.
964  * For a generic mechanism see {ERC20PresetMinterPauser}.
965  *
966  * TIP: For a detailed writeup see our guide
967  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
968  * to implement supply mechanisms].
969  *
970  * We have followed general OpenZeppelin guidelines: functions revert instead
971  * of returning `false` on failure. This behavior is nonetheless conventional
972  * and does not conflict with the expectations of ERC20 applications.
973  *
974  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
975  * This allows applications to reconstruct the allowance for all accounts just
976  * by listening to said events. Other implementations of the EIP may not emit
977  * these events, as it isn't required by the specification.
978  *
979  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
980  * functions have been added to mitigate the well-known issues around setting
981  * allowances. See {IERC20-approve}.
982  */
983 contract ERC20 is Context, IERC20 {
984     using SafeMath for uint256;
985 
986     mapping (address => uint256) private _balances;
987 
988     mapping (address => mapping (address => uint256)) private _allowances;
989 
990     uint256 private _totalSupply;
991 
992     string private _name;
993     string private _symbol;
994     uint8 private _decimals;
995 
996     /**
997      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
998      * a default value of 18.
999      *
1000      * To select a different value for {decimals}, use {_setupDecimals}.
1001      *
1002      * All three of these values are immutable: they can only be set once during
1003      * construction.
1004      */
1005     constructor (string memory name_, string memory symbol_) public {
1006         _name = name_;
1007         _symbol = symbol_;
1008         _decimals = 18;
1009     }
1010 
1011     /**
1012      * @dev Returns the name of the token.
1013      */
1014     function name() public view returns (string memory) {
1015         return _name;
1016     }
1017 
1018     /**
1019      * @dev Returns the symbol of the token, usually a shorter version of the
1020      * name.
1021      */
1022     function symbol() public view returns (string memory) {
1023         return _symbol;
1024     }
1025 
1026     /**
1027      * @dev Returns the number of decimals used to get its user representation.
1028      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1029      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1030      *
1031      * Tokens usually opt for a value of 18, imitating the relationship between
1032      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1033      * called.
1034      *
1035      * NOTE: This information is only used for _display_ purposes: it in
1036      * no way affects any of the arithmetic of the contract, including
1037      * {IERC20-balanceOf} and {IERC20-transfer}.
1038      */
1039     function decimals() public view returns (uint8) {
1040         return _decimals;
1041     }
1042 
1043     /**
1044      * @dev See {IERC20-totalSupply}.
1045      */
1046     function totalSupply() public view override returns (uint256) {
1047         return _totalSupply;
1048     }
1049 
1050     /**
1051      * @dev See {IERC20-balanceOf}.
1052      */
1053     function balanceOf(address account) public view override returns (uint256) {
1054         return _balances[account];
1055     }
1056 
1057     /**
1058      * @dev See {IERC20-transfer}.
1059      *
1060      * Requirements:
1061      *
1062      * - `recipient` cannot be the zero address.
1063      * - the caller must have a balance of at least `amount`.
1064      */
1065     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1066         _transfer(_msgSender(), recipient, amount);
1067         return true;
1068     }
1069 
1070     /**
1071      * @dev See {IERC20-allowance}.
1072      */
1073     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1074         return _allowances[owner][spender];
1075     }
1076 
1077     /**
1078      * @dev See {IERC20-approve}.
1079      *
1080      * Requirements:
1081      *
1082      * - `spender` cannot be the zero address.
1083      */
1084     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1085         _approve(_msgSender(), spender, amount);
1086         return true;
1087     }
1088 
1089     /**
1090      * @dev See {IERC20-transferFrom}.
1091      *
1092      * Emits an {Approval} event indicating the updated allowance. This is not
1093      * required by the EIP. See the note at the beginning of {ERC20}.
1094      *
1095      * Requirements:
1096      *
1097      * - `sender` and `recipient` cannot be the zero address.
1098      * - `sender` must have a balance of at least `amount`.
1099      * - the caller must have allowance for ``sender``'s tokens of at least
1100      * `amount`.
1101      */
1102     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1103         _transfer(sender, recipient, amount);
1104         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1105         return true;
1106     }
1107 
1108     /**
1109      * @dev Atomically increases the allowance granted to `spender` by the caller.
1110      *
1111      * This is an alternative to {approve} that can be used as a mitigation for
1112      * problems described in {IERC20-approve}.
1113      *
1114      * Emits an {Approval} event indicating the updated allowance.
1115      *
1116      * Requirements:
1117      *
1118      * - `spender` cannot be the zero address.
1119      */
1120     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1121         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1122         return true;
1123     }
1124 
1125     /**
1126      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1127      *
1128      * This is an alternative to {approve} that can be used as a mitigation for
1129      * problems described in {IERC20-approve}.
1130      *
1131      * Emits an {Approval} event indicating the updated allowance.
1132      *
1133      * Requirements:
1134      *
1135      * - `spender` cannot be the zero address.
1136      * - `spender` must have allowance for the caller of at least
1137      * `subtractedValue`.
1138      */
1139     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1140         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1141         return true;
1142     }
1143 
1144     /**
1145      * @dev Moves tokens `amount` from `sender` to `recipient`.
1146      *
1147      * This is internal function is equivalent to {transfer}, and can be used to
1148      * e.g. implement automatic token fees, slashing mechanisms, etc.
1149      *
1150      * Emits a {Transfer} event.
1151      *
1152      * Requirements:
1153      *
1154      * - `sender` cannot be the zero address.
1155      * - `recipient` cannot be the zero address.
1156      * - `sender` must have a balance of at least `amount`.
1157      */
1158     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1159         require(sender != address(0), "ERC20: transfer from the zero address");
1160         require(recipient != address(0), "ERC20: transfer to the zero address");
1161 
1162         _beforeTokenTransfer(sender, recipient, amount);
1163 
1164         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1165         _balances[recipient] = _balances[recipient].add(amount);
1166         emit Transfer(sender, recipient, amount);
1167     }
1168 
1169     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1170      * the total supply.
1171      *
1172      * Emits a {Transfer} event with `from` set to the zero address.
1173      *
1174      * Requirements:
1175      *
1176      * - `to` cannot be the zero address.
1177      */
1178     function _mint(address account, uint256 amount) internal virtual {
1179         require(account != address(0), "ERC20: mint to the zero address");
1180 
1181         _beforeTokenTransfer(address(0), account, amount);
1182 
1183         _totalSupply = _totalSupply.add(amount);
1184         _balances[account] = _balances[account].add(amount);
1185         emit Transfer(address(0), account, amount);
1186     }
1187 
1188     /**
1189      * @dev Destroys `amount` tokens from `account`, reducing the
1190      * total supply.
1191      *
1192      * Emits a {Transfer} event with `to` set to the zero address.
1193      *
1194      * Requirements:
1195      *
1196      * - `account` cannot be the zero address.
1197      * - `account` must have at least `amount` tokens.
1198      */
1199     function _burn(address account, uint256 amount) internal virtual {
1200         require(account != address(0), "ERC20: burn from the zero address");
1201 
1202         _beforeTokenTransfer(account, address(0), amount);
1203 
1204         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1205         _totalSupply = _totalSupply.sub(amount);
1206         emit Transfer(account, address(0), amount);
1207     }
1208 
1209     /**
1210      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1211      *
1212      * This internal function is equivalent to `approve`, and can be used to
1213      * e.g. set automatic allowances for certain subsystems, etc.
1214      *
1215      * Emits an {Approval} event.
1216      *
1217      * Requirements:
1218      *
1219      * - `owner` cannot be the zero address.
1220      * - `spender` cannot be the zero address.
1221      */
1222     function _approve(address owner, address spender, uint256 amount) internal virtual {
1223         require(owner != address(0), "ERC20: approve from the zero address");
1224         require(spender != address(0), "ERC20: approve to the zero address");
1225 
1226         _allowances[owner][spender] = amount;
1227         emit Approval(owner, spender, amount);
1228     }
1229 
1230     /**
1231      * @dev Sets {decimals} to a value other than the default one of 18.
1232      *
1233      * WARNING: This function should only be called from the constructor. Most
1234      * applications that interact with token contracts will not expect
1235      * {decimals} to ever change, and may work incorrectly if it does.
1236      */
1237     function _setupDecimals(uint8 decimals_) internal {
1238         _decimals = decimals_;
1239     }
1240 
1241     /**
1242      * @dev Hook that is called before any transfer of tokens. This includes
1243      * minting and burning.
1244      *
1245      * Calling conditions:
1246      *
1247      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1248      * will be to transferred to `to`.
1249      * - when `from` is zero, `amount` tokens will be minted for `to`.
1250      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1251      * - `from` and `to` are never both zero.
1252      *
1253      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1254      */
1255     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1256 }
1257 
1258 pragma solidity >=0.6.0 <0.8.0;
1259 
1260 /**
1261  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1262  * tokens and those that they have an allowance for, in a way that can be
1263  * recognized off-chain (via event analysis).
1264  */
1265 abstract contract ERC20Burnable is Context, ERC20 {
1266     using SafeMath for uint256;
1267 
1268     /**
1269      * @dev Destroys `amount` tokens from the caller.
1270      *
1271      * See {ERC20-_burn}.
1272      */
1273     function burn(uint256 amount) public virtual {
1274         _burn(_msgSender(), amount);
1275     }
1276 
1277     /**
1278      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1279      * allowance.
1280      *
1281      * See {ERC20-_burn} and {ERC20-allowance}.
1282      *
1283      * Requirements:
1284      *
1285      * - the caller must have allowance for ``accounts``'s tokens of at least
1286      * `amount`.
1287      */
1288     function burnFrom(address account, uint256 amount) public virtual {
1289         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1290 
1291         _approve(account, _msgSender(), decreasedAllowance);
1292         _burn(account, amount);
1293     }
1294 }
1295 
1296 pragma solidity >=0.6.0 <0.8.0;
1297 
1298 /**
1299  * @dev Contract module which allows children to implement an emergency stop
1300  * mechanism that can be triggered by an authorized account.
1301  *
1302  * This module is used through inheritance. It will make available the
1303  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1304  * the functions of your contract. Note that they will not be pausable by
1305  * simply including this module, only once the modifiers are put in place.
1306  */
1307 abstract contract Pausable is Context {
1308     /**
1309      * @dev Emitted when the pause is triggered by `account`.
1310      */
1311     event Paused(address account);
1312 
1313     /**
1314      * @dev Emitted when the pause is lifted by `account`.
1315      */
1316     event Unpaused(address account);
1317 
1318     bool private _paused;
1319 
1320     /**
1321      * @dev Initializes the contract in unpaused state.
1322      */
1323     constructor () internal {
1324         _paused = false;
1325     }
1326 
1327     /**
1328      * @dev Returns true if the contract is paused, and false otherwise.
1329      */
1330     function paused() public view returns (bool) {
1331         return _paused;
1332     }
1333 
1334     /**
1335      * @dev Modifier to make a function callable only when the contract is not paused.
1336      *
1337      * Requirements:
1338      *
1339      * - The contract must not be paused.
1340      */
1341     modifier whenNotPaused() {
1342         require(!_paused, "Pausable: paused");
1343         _;
1344     }
1345 
1346     /**
1347      * @dev Modifier to make a function callable only when the contract is paused.
1348      *
1349      * Requirements:
1350      *
1351      * - The contract must be paused.
1352      */
1353     modifier whenPaused() {
1354         require(_paused, "Pausable: not paused");
1355         _;
1356     }
1357 
1358     /**
1359      * @dev Triggers stopped state.
1360      *
1361      * Requirements:
1362      *
1363      * - The contract must not be paused.
1364      */
1365     function _pause() internal virtual whenNotPaused {
1366         _paused = true;
1367         emit Paused(_msgSender());
1368     }
1369 
1370     /**
1371      * @dev Returns to normal state.
1372      *
1373      * Requirements:
1374      *
1375      * - The contract must be paused.
1376      */
1377     function _unpause() internal virtual whenPaused {
1378         _paused = false;
1379         emit Unpaused(_msgSender());
1380     }
1381 }
1382 
1383 pragma solidity >=0.6.0 <0.8.0;
1384 
1385 /**
1386  * @dev ERC20 token with pausable token transfers, minting and burning.
1387  *
1388  * Useful for scenarios such as preventing trades until the end of an evaluation
1389  * period, or having an emergency switch for freezing all token transfers in the
1390  * event of a large bug.
1391  */
1392 abstract contract ERC20Pausable is ERC20, Pausable {
1393     /**
1394      * @dev See {ERC20-_beforeTokenTransfer}.
1395      *
1396      * Requirements:
1397      *
1398      * - the contract must not be paused.
1399      */
1400     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1401         super._beforeTokenTransfer(from, to, amount);
1402 
1403         require(!paused(), "ERC20Pausable: token transfer while paused");
1404     }
1405 }
1406 
1407 pragma solidity >=0.6.0 <0.8.0;
1408 
1409 /**
1410  * @dev {ERC20} token, including:
1411  *
1412  *  - ability for holders to burn (destroy) their tokens
1413  *  - a minter role that allows for token minting (creation)
1414  *  - a pauser role that allows to stop all token transfers
1415  *
1416  * This contract uses {AccessControl} to lock permissioned functions using the
1417  * different roles - head to its documentation for details.
1418  *
1419  * The account that deploys the contract will be granted the minter and pauser
1420  * roles, as well as the default admin role, which will let it grant both minter
1421  * and pauser roles to other accounts.
1422  */
1423 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1424     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1425     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1426 
1427     /**
1428      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1429      * account that deploys the contract.
1430      *
1431      * See {ERC20-constructor}.
1432      */
1433     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1434         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1435 
1436         _setupRole(MINTER_ROLE, _msgSender());
1437         _setupRole(PAUSER_ROLE, _msgSender());
1438     }
1439 
1440     /**
1441      * @dev Creates `amount` new tokens for `to`.
1442      *
1443      * See {ERC20-_mint}.
1444      *
1445      * Requirements:
1446      *
1447      * - the caller must have the `MINTER_ROLE`.
1448      */
1449     function mint(address to, uint256 amount) public virtual {
1450         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1451         _mint(to, amount);
1452     }
1453 
1454     /**
1455      * @dev Pauses all token transfers.
1456      *
1457      * See {ERC20Pausable} and {Pausable-_pause}.
1458      *
1459      * Requirements:
1460      *
1461      * - the caller must have the `PAUSER_ROLE`.
1462      */
1463     function pause() public virtual {
1464         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1465         _pause();
1466     }
1467 
1468     /**
1469      * @dev Unpauses all token transfers.
1470      *
1471      * See {ERC20Pausable} and {Pausable-_unpause}.
1472      *
1473      * Requirements:
1474      *
1475      * - the caller must have the `PAUSER_ROLE`.
1476      */
1477     function unpause() public virtual {
1478         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1479         _unpause();
1480     }
1481 
1482     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1483         super._beforeTokenTransfer(from, to, amount);
1484     }
1485 }