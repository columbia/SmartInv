1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/GSN/Context.sol
2 
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 
28 // File: browser/IMintableToken.sol
29 
30 // SPDX-License-Identifier: BSD-3-Clause
31 pragma solidity ^0.7.0;
32 
33 /**
34  * @dev Interface for minting fungible tokens.
35  */
36 interface IMintableToken {
37     /**
38      * @dev Mints the specified `amount` of tokens for `to`.
39      */
40     function mint(address to, uint256 amount) external;
41 }
42 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/utils/Address.sol
43 
44 
45 pragma solidity >=0.6.2 <0.8.0;
46 
47 /**
48  * @dev Collection of functions related to the address type
49  */
50 library Address {
51     /**
52      * @dev Returns true if `account` is a contract.
53      *
54      * [IMPORTANT]
55      * ====
56      * It is unsafe to assume that an address for which this function returns
57      * false is an externally-owned account (EOA) and not a contract.
58      *
59      * Among others, `isContract` will return false for the following
60      * types of addresses:
61      *
62      *  - an externally-owned account
63      *  - a contract in construction
64      *  - an address where a contract will be created
65      *  - an address where a contract lived, but was destroyed
66      * ====
67      */
68     function isContract(address account) internal view returns (bool) {
69         // This method relies on extcodesize, which returns 0 for contracts in
70         // construction, since the code is only stored at the end of the
71         // constructor execution.
72 
73         uint256 size;
74         // solhint-disable-next-line no-inline-assembly
75         assembly { size := extcodesize(account) }
76         return size > 0;
77     }
78 
79     /**
80      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
81      * `recipient`, forwarding all available gas and reverting on errors.
82      *
83      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
84      * of certain opcodes, possibly making contracts go over the 2300 gas limit
85      * imposed by `transfer`, making them unable to receive funds via
86      * `transfer`. {sendValue} removes this limitation.
87      *
88      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
89      *
90      * IMPORTANT: because control is transferred to `recipient`, care must be
91      * taken to not create reentrancy vulnerabilities. Consider using
92      * {ReentrancyGuard} or the
93      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
94      */
95     function sendValue(address payable recipient, uint256 amount) internal {
96         require(address(this).balance >= amount, "Address: insufficient balance");
97 
98         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
99         (bool success, ) = recipient.call{ value: amount }("");
100         require(success, "Address: unable to send value, recipient may have reverted");
101     }
102 
103     /**
104      * @dev Performs a Solidity function call using a low level `call`. A
105      * plain`call` is an unsafe replacement for a function call: use this
106      * function instead.
107      *
108      * If `target` reverts with a revert reason, it is bubbled up by this
109      * function (like regular Solidity function calls).
110      *
111      * Returns the raw returned data. To convert to the expected return value,
112      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
113      *
114      * Requirements:
115      *
116      * - `target` must be a contract.
117      * - calling `target` with `data` must not revert.
118      *
119      * _Available since v3.1._
120      */
121     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
122       return functionCall(target, data, "Address: low-level call failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
127      * `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
132         return functionCallWithValue(target, data, 0, errorMessage);
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
137      * but also transferring `value` wei to `target`.
138      *
139      * Requirements:
140      *
141      * - the calling contract must have an ETH balance of at least `value`.
142      * - the called Solidity function must be `payable`.
143      *
144      * _Available since v3.1._
145      */
146     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
147         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
152      * with `errorMessage` as a fallback revert reason when `target` reverts.
153      *
154      * _Available since v3.1._
155      */
156     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
157         require(address(this).balance >= value, "Address: insufficient balance for call");
158         require(isContract(target), "Address: call to non-contract");
159 
160         // solhint-disable-next-line avoid-low-level-calls
161         (bool success, bytes memory returndata) = target.call{ value: value }(data);
162         return _verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a static call.
168      *
169      * _Available since v3.3._
170      */
171     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
172         return functionStaticCall(target, data, "Address: low-level static call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a static call.
178      *
179      * _Available since v3.3._
180      */
181     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
182         require(isContract(target), "Address: static call to non-contract");
183 
184         // solhint-disable-next-line avoid-low-level-calls
185         (bool success, bytes memory returndata) = target.staticcall(data);
186         return _verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
190         if (success) {
191             return returndata;
192         } else {
193             // Look for revert reason and bubble it up if present
194             if (returndata.length > 0) {
195                 // The easiest way to bubble the revert reason is using memory via assembly
196 
197                 // solhint-disable-next-line no-inline-assembly
198                 assembly {
199                     let returndata_size := mload(returndata)
200                     revert(add(32, returndata), returndata_size)
201                 }
202             } else {
203                 revert(errorMessage);
204             }
205         }
206     }
207 }
208 
209 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/utils/EnumerableSet.sol
210 
211 pragma solidity >=0.6.0 <0.8.0;
212 
213 /**
214  * @dev Library for managing
215  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
216  * types.
217  *
218  * Sets have the following properties:
219  *
220  * - Elements are added, removed, and checked for existence in constant time
221  * (O(1)).
222  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
223  *
224  * ```
225  * contract Example {
226  *     // Add the library methods
227  *     using EnumerableSet for EnumerableSet.AddressSet;
228  *
229  *     // Declare a set state variable
230  *     EnumerableSet.AddressSet private mySet;
231  * }
232  * ```
233  *
234  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
235  * and `uint256` (`UintSet`) are supported.
236  */
237 library EnumerableSet {
238     // To implement this library for multiple types with as little code
239     // repetition as possible, we write it in terms of a generic Set type with
240     // bytes32 values.
241     // The Set implementation uses private functions, and user-facing
242     // implementations (such as AddressSet) are just wrappers around the
243     // underlying Set.
244     // This means that we can only create new EnumerableSets for types that fit
245     // in bytes32.
246 
247     struct Set {
248         // Storage of set values
249         bytes32[] _values;
250 
251         // Position of the value in the `values` array, plus 1 because index 0
252         // means a value is not in the set.
253         mapping (bytes32 => uint256) _indexes;
254     }
255 
256     /**
257      * @dev Add a value to a set. O(1).
258      *
259      * Returns true if the value was added to the set, that is if it was not
260      * already present.
261      */
262     function _add(Set storage set, bytes32 value) private returns (bool) {
263         if (!_contains(set, value)) {
264             set._values.push(value);
265             // The value is stored at length-1, but we add 1 to all indexes
266             // and use 0 as a sentinel value
267             set._indexes[value] = set._values.length;
268             return true;
269         } else {
270             return false;
271         }
272     }
273 
274     /**
275      * @dev Removes a value from a set. O(1).
276      *
277      * Returns true if the value was removed from the set, that is if it was
278      * present.
279      */
280     function _remove(Set storage set, bytes32 value) private returns (bool) {
281         // We read and store the value's index to prevent multiple reads from the same storage slot
282         uint256 valueIndex = set._indexes[value];
283 
284         if (valueIndex != 0) { // Equivalent to contains(set, value)
285             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
286             // the array, and then remove the last element (sometimes called as 'swap and pop').
287             // This modifies the order of the array, as noted in {at}.
288 
289             uint256 toDeleteIndex = valueIndex - 1;
290             uint256 lastIndex = set._values.length - 1;
291 
292             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
293             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
294 
295             bytes32 lastvalue = set._values[lastIndex];
296 
297             // Move the last value to the index where the value to delete is
298             set._values[toDeleteIndex] = lastvalue;
299             // Update the index for the moved value
300             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
301 
302             // Delete the slot where the moved value was stored
303             set._values.pop();
304 
305             // Delete the index for the deleted slot
306             delete set._indexes[value];
307 
308             return true;
309         } else {
310             return false;
311         }
312     }
313 
314     /**
315      * @dev Returns true if the value is in the set. O(1).
316      */
317     function _contains(Set storage set, bytes32 value) private view returns (bool) {
318         return set._indexes[value] != 0;
319     }
320 
321     /**
322      * @dev Returns the number of values on the set. O(1).
323      */
324     function _length(Set storage set) private view returns (uint256) {
325         return set._values.length;
326     }
327 
328    /**
329     * @dev Returns the value stored at position `index` in the set. O(1).
330     *
331     * Note that there are no guarantees on the ordering of values inside the
332     * array, and it may change when more values are added or removed.
333     *
334     * Requirements:
335     *
336     * - `index` must be strictly less than {length}.
337     */
338     function _at(Set storage set, uint256 index) private view returns (bytes32) {
339         require(set._values.length > index, "EnumerableSet: index out of bounds");
340         return set._values[index];
341     }
342 
343     // Bytes32Set
344 
345     struct Bytes32Set {
346         Set _inner;
347     }
348 
349     /**
350      * @dev Add a value to a set. O(1).
351      *
352      * Returns true if the value was added to the set, that is if it was not
353      * already present.
354      */
355     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
356         return _add(set._inner, value);
357     }
358 
359     /**
360      * @dev Removes a value from a set. O(1).
361      *
362      * Returns true if the value was removed from the set, that is if it was
363      * present.
364      */
365     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
366         return _remove(set._inner, value);
367     }
368 
369     /**
370      * @dev Returns true if the value is in the set. O(1).
371      */
372     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
373         return _contains(set._inner, value);
374     }
375 
376     /**
377      * @dev Returns the number of values in the set. O(1).
378      */
379     function length(Bytes32Set storage set) internal view returns (uint256) {
380         return _length(set._inner);
381     }
382 
383    /**
384     * @dev Returns the value stored at position `index` in the set. O(1).
385     *
386     * Note that there are no guarantees on the ordering of values inside the
387     * array, and it may change when more values are added or removed.
388     *
389     * Requirements:
390     *
391     * - `index` must be strictly less than {length}.
392     */
393     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
394         return _at(set._inner, index);
395     }
396 
397     // AddressSet
398 
399     struct AddressSet {
400         Set _inner;
401     }
402 
403     /**
404      * @dev Add a value to a set. O(1).
405      *
406      * Returns true if the value was added to the set, that is if it was not
407      * already present.
408      */
409     function add(AddressSet storage set, address value) internal returns (bool) {
410         return _add(set._inner, bytes32(uint256(value)));
411     }
412 
413     /**
414      * @dev Removes a value from a set. O(1).
415      *
416      * Returns true if the value was removed from the set, that is if it was
417      * present.
418      */
419     function remove(AddressSet storage set, address value) internal returns (bool) {
420         return _remove(set._inner, bytes32(uint256(value)));
421     }
422 
423     /**
424      * @dev Returns true if the value is in the set. O(1).
425      */
426     function contains(AddressSet storage set, address value) internal view returns (bool) {
427         return _contains(set._inner, bytes32(uint256(value)));
428     }
429 
430     /**
431      * @dev Returns the number of values in the set. O(1).
432      */
433     function length(AddressSet storage set) internal view returns (uint256) {
434         return _length(set._inner);
435     }
436 
437    /**
438     * @dev Returns the value stored at position `index` in the set. O(1).
439     *
440     * Note that there are no guarantees on the ordering of values inside the
441     * array, and it may change when more values are added or removed.
442     *
443     * Requirements:
444     *
445     * - `index` must be strictly less than {length}.
446     */
447     function at(AddressSet storage set, uint256 index) internal view returns (address) {
448         return address(uint256(_at(set._inner, index)));
449     }
450 
451 
452     // UintSet
453 
454     struct UintSet {
455         Set _inner;
456     }
457 
458     /**
459      * @dev Add a value to a set. O(1).
460      *
461      * Returns true if the value was added to the set, that is if it was not
462      * already present.
463      */
464     function add(UintSet storage set, uint256 value) internal returns (bool) {
465         return _add(set._inner, bytes32(value));
466     }
467 
468     /**
469      * @dev Removes a value from a set. O(1).
470      *
471      * Returns true if the value was removed from the set, that is if it was
472      * present.
473      */
474     function remove(UintSet storage set, uint256 value) internal returns (bool) {
475         return _remove(set._inner, bytes32(value));
476     }
477 
478     /**
479      * @dev Returns true if the value is in the set. O(1).
480      */
481     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
482         return _contains(set._inner, bytes32(value));
483     }
484 
485     /**
486      * @dev Returns the number of values on the set. O(1).
487      */
488     function length(UintSet storage set) internal view returns (uint256) {
489         return _length(set._inner);
490     }
491 
492    /**
493     * @dev Returns the value stored at position `index` in the set. O(1).
494     *
495     * Note that there are no guarantees on the ordering of values inside the
496     * array, and it may change when more values are added or removed.
497     *
498     * Requirements:
499     *
500     * - `index` must be strictly less than {length}.
501     */
502     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
503         return uint256(_at(set._inner, index));
504     }
505 }
506 
507 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/access/AccessControl.sol
508 
509 
510 pragma solidity >=0.6.0 <0.8.0;
511 
512 
513 
514 
515 /**
516  * @dev Contract module that allows children to implement role-based access
517  * control mechanisms.
518  *
519  * Roles are referred to by their `bytes32` identifier. These should be exposed
520  * in the external API and be unique. The best way to achieve this is by
521  * using `public constant` hash digests:
522  *
523  * ```
524  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
525  * ```
526  *
527  * Roles can be used to represent a set of permissions. To restrict access to a
528  * function call, use {hasRole}:
529  *
530  * ```
531  * function foo() public {
532  *     require(hasRole(MY_ROLE, msg.sender));
533  *     ...
534  * }
535  * ```
536  *
537  * Roles can be granted and revoked dynamically via the {grantRole} and
538  * {revokeRole} functions. Each role has an associated admin role, and only
539  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
540  *
541  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
542  * that only accounts with this role will be able to grant or revoke other
543  * roles. More complex role relationships can be created by using
544  * {_setRoleAdmin}.
545  *
546  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
547  * grant and revoke this role. Extra precautions should be taken to secure
548  * accounts that have been granted it.
549  */
550 abstract contract AccessControl is Context {
551     using EnumerableSet for EnumerableSet.AddressSet;
552     using Address for address;
553 
554     struct RoleData {
555         EnumerableSet.AddressSet members;
556         bytes32 adminRole;
557     }
558 
559     mapping (bytes32 => RoleData) private _roles;
560 
561     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
562 
563     /**
564      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
565      *
566      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
567      * {RoleAdminChanged} not being emitted signaling this.
568      *
569      * _Available since v3.1._
570      */
571     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
572 
573     /**
574      * @dev Emitted when `account` is granted `role`.
575      *
576      * `sender` is the account that originated the contract call, an admin role
577      * bearer except when using {_setupRole}.
578      */
579     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
580 
581     /**
582      * @dev Emitted when `account` is revoked `role`.
583      *
584      * `sender` is the account that originated the contract call:
585      *   - if using `revokeRole`, it is the admin role bearer
586      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
587      */
588     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
589 
590     /**
591      * @dev Returns `true` if `account` has been granted `role`.
592      */
593     function hasRole(bytes32 role, address account) public view returns (bool) {
594         return _roles[role].members.contains(account);
595     }
596 
597     /**
598      * @dev Returns the number of accounts that have `role`. Can be used
599      * together with {getRoleMember} to enumerate all bearers of a role.
600      */
601     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
602         return _roles[role].members.length();
603     }
604 
605     /**
606      * @dev Returns one of the accounts that have `role`. `index` must be a
607      * value between 0 and {getRoleMemberCount}, non-inclusive.
608      *
609      * Role bearers are not sorted in any particular way, and their ordering may
610      * change at any point.
611      *
612      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
613      * you perform all queries on the same block. See the following
614      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
615      * for more information.
616      */
617     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
618         return _roles[role].members.at(index);
619     }
620 
621     /**
622      * @dev Returns the admin role that controls `role`. See {grantRole} and
623      * {revokeRole}.
624      *
625      * To change a role's admin, use {_setRoleAdmin}.
626      */
627     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
628         return _roles[role].adminRole;
629     }
630 
631     /**
632      * @dev Grants `role` to `account`.
633      *
634      * If `account` had not been already granted `role`, emits a {RoleGranted}
635      * event.
636      *
637      * Requirements:
638      *
639      * - the caller must have ``role``'s admin role.
640      */
641     function grantRole(bytes32 role, address account) public virtual {
642         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
643 
644         _grantRole(role, account);
645     }
646 
647     /**
648      * @dev Revokes `role` from `account`.
649      *
650      * If `account` had been granted `role`, emits a {RoleRevoked} event.
651      *
652      * Requirements:
653      *
654      * - the caller must have ``role``'s admin role.
655      */
656     function revokeRole(bytes32 role, address account) public virtual {
657         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
658 
659         _revokeRole(role, account);
660     }
661 
662     /**
663      * @dev Revokes `role` from the calling account.
664      *
665      * Roles are often managed via {grantRole} and {revokeRole}: this function's
666      * purpose is to provide a mechanism for accounts to lose their privileges
667      * if they are compromised (such as when a trusted device is misplaced).
668      *
669      * If the calling account had been granted `role`, emits a {RoleRevoked}
670      * event.
671      *
672      * Requirements:
673      *
674      * - the caller must be `account`.
675      */
676     function renounceRole(bytes32 role, address account) public virtual {
677         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
678 
679         _revokeRole(role, account);
680     }
681 
682     /**
683      * @dev Grants `role` to `account`.
684      *
685      * If `account` had not been already granted `role`, emits a {RoleGranted}
686      * event. Note that unlike {grantRole}, this function doesn't perform any
687      * checks on the calling account.
688      *
689      * [WARNING]
690      * ====
691      * This function should only be called from the constructor when setting
692      * up the initial roles for the system.
693      *
694      * Using this function in any other way is effectively circumventing the admin
695      * system imposed by {AccessControl}.
696      * ====
697      */
698     function _setupRole(bytes32 role, address account) internal virtual {
699         _grantRole(role, account);
700     }
701 
702     /**
703      * @dev Sets `adminRole` as ``role``'s admin role.
704      *
705      * Emits a {RoleAdminChanged} event.
706      */
707     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
708         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
709         _roles[role].adminRole = adminRole;
710     }
711 
712     function _grantRole(bytes32 role, address account) private {
713         if (_roles[role].members.add(account)) {
714             emit RoleGranted(role, account, _msgSender());
715         }
716     }
717 
718     function _revokeRole(bytes32 role, address account) private {
719         if (_roles[role].members.remove(account)) {
720             emit RoleRevoked(role, account, _msgSender());
721         }
722     }
723 }
724 
725 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/math/SafeMath.sol
726 
727 
728 pragma solidity >=0.6.0 <0.8.0;
729 
730 /**
731  * @dev Wrappers over Solidity's arithmetic operations with added overflow
732  * checks.
733  *
734  * Arithmetic operations in Solidity wrap on overflow. This can easily result
735  * in bugs, because programmers usually assume that an overflow raises an
736  * error, which is the standard behavior in high level programming languages.
737  * `SafeMath` restores this intuition by reverting the transaction when an
738  * operation overflows.
739  *
740  * Using this library instead of the unchecked operations eliminates an entire
741  * class of bugs, so it's recommended to use it always.
742  */
743 library SafeMath {
744     /**
745      * @dev Returns the addition of two unsigned integers, reverting on
746      * overflow.
747      *
748      * Counterpart to Solidity's `+` operator.
749      *
750      * Requirements:
751      *
752      * - Addition cannot overflow.
753      */
754     function add(uint256 a, uint256 b) internal pure returns (uint256) {
755         uint256 c = a + b;
756         require(c >= a, "SafeMath: addition overflow");
757 
758         return c;
759     }
760 
761     /**
762      * @dev Returns the subtraction of two unsigned integers, reverting on
763      * overflow (when the result is negative).
764      *
765      * Counterpart to Solidity's `-` operator.
766      *
767      * Requirements:
768      *
769      * - Subtraction cannot overflow.
770      */
771     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
772         return sub(a, b, "SafeMath: subtraction overflow");
773     }
774 
775     /**
776      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
777      * overflow (when the result is negative).
778      *
779      * Counterpart to Solidity's `-` operator.
780      *
781      * Requirements:
782      *
783      * - Subtraction cannot overflow.
784      */
785     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
786         require(b <= a, errorMessage);
787         uint256 c = a - b;
788 
789         return c;
790     }
791 
792     /**
793      * @dev Returns the multiplication of two unsigned integers, reverting on
794      * overflow.
795      *
796      * Counterpart to Solidity's `*` operator.
797      *
798      * Requirements:
799      *
800      * - Multiplication cannot overflow.
801      */
802     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
803         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
804         // benefit is lost if 'b' is also tested.
805         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
806         if (a == 0) {
807             return 0;
808         }
809 
810         uint256 c = a * b;
811         require(c / a == b, "SafeMath: multiplication overflow");
812 
813         return c;
814     }
815 
816     /**
817      * @dev Returns the integer division of two unsigned integers. Reverts on
818      * division by zero. The result is rounded towards zero.
819      *
820      * Counterpart to Solidity's `/` operator. Note: this function uses a
821      * `revert` opcode (which leaves remaining gas untouched) while Solidity
822      * uses an invalid opcode to revert (consuming all remaining gas).
823      *
824      * Requirements:
825      *
826      * - The divisor cannot be zero.
827      */
828     function div(uint256 a, uint256 b) internal pure returns (uint256) {
829         return div(a, b, "SafeMath: division by zero");
830     }
831 
832     /**
833      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
834      * division by zero. The result is rounded towards zero.
835      *
836      * Counterpart to Solidity's `/` operator. Note: this function uses a
837      * `revert` opcode (which leaves remaining gas untouched) while Solidity
838      * uses an invalid opcode to revert (consuming all remaining gas).
839      *
840      * Requirements:
841      *
842      * - The divisor cannot be zero.
843      */
844     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
845         require(b > 0, errorMessage);
846         uint256 c = a / b;
847         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
848 
849         return c;
850     }
851 
852     /**
853      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
854      * Reverts when dividing by zero.
855      *
856      * Counterpart to Solidity's `%` operator. This function uses a `revert`
857      * opcode (which leaves remaining gas untouched) while Solidity uses an
858      * invalid opcode to revert (consuming all remaining gas).
859      *
860      * Requirements:
861      *
862      * - The divisor cannot be zero.
863      */
864     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
865         return mod(a, b, "SafeMath: modulo by zero");
866     }
867 
868     /**
869      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
870      * Reverts with custom message when dividing by zero.
871      *
872      * Counterpart to Solidity's `%` operator. This function uses a `revert`
873      * opcode (which leaves remaining gas untouched) while Solidity uses an
874      * invalid opcode to revert (consuming all remaining gas).
875      *
876      * Requirements:
877      *
878      * - The divisor cannot be zero.
879      */
880     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
881         require(b != 0, errorMessage);
882         return a % b;
883     }
884 }
885 
886 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/IERC20.sol
887 
888 
889 pragma solidity >=0.6.0 <0.8.0;
890 
891 /**
892  * @dev Interface of the ERC20 standard as defined in the EIP.
893  */
894 interface IERC20 {
895     /**
896      * @dev Returns the amount of tokens in existence.
897      */
898     function totalSupply() external view returns (uint256);
899 
900     /**
901      * @dev Returns the amount of tokens owned by `account`.
902      */
903     function balanceOf(address account) external view returns (uint256);
904 
905     /**
906      * @dev Moves `amount` tokens from the caller's account to `recipient`.
907      *
908      * Returns a boolean value indicating whether the operation succeeded.
909      *
910      * Emits a {Transfer} event.
911      */
912     function transfer(address recipient, uint256 amount) external returns (bool);
913 
914     /**
915      * @dev Returns the remaining number of tokens that `spender` will be
916      * allowed to spend on behalf of `owner` through {transferFrom}. This is
917      * zero by default.
918      *
919      * This value changes when {approve} or {transferFrom} are called.
920      */
921     function allowance(address owner, address spender) external view returns (uint256);
922 
923     /**
924      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
925      *
926      * Returns a boolean value indicating whether the operation succeeded.
927      *
928      * IMPORTANT: Beware that changing an allowance with this method brings the risk
929      * that someone may use both the old and the new allowance by unfortunate
930      * transaction ordering. One possible solution to mitigate this race
931      * condition is to first reduce the spender's allowance to 0 and set the
932      * desired value afterwards:
933      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
934      *
935      * Emits an {Approval} event.
936      */
937     function approve(address spender, uint256 amount) external returns (bool);
938 
939     /**
940      * @dev Moves `amount` tokens from `sender` to `recipient` using the
941      * allowance mechanism. `amount` is then deducted from the caller's
942      * allowance.
943      *
944      * Returns a boolean value indicating whether the operation succeeded.
945      *
946      * Emits a {Transfer} event.
947      */
948     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
949 
950     /**
951      * @dev Emitted when `value` tokens are moved from one account (`from`) to
952      * another (`to`).
953      *
954      * Note that `value` may be zero.
955      */
956     event Transfer(address indexed from, address indexed to, uint256 value);
957 
958     /**
959      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
960      * a call to {approve}. `value` is the new allowance.
961      */
962     event Approval(address indexed owner, address indexed spender, uint256 value);
963 }
964 
965 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/ERC20.sol
966 
967 
968 pragma solidity >=0.6.0 <0.8.0;
969 
970 
971 
972 
973 /**
974  * @dev Implementation of the {IERC20} interface.
975  *
976  * This implementation is agnostic to the way tokens are created. This means
977  * that a supply mechanism has to be added in a derived contract using {_mint}.
978  * For a generic mechanism see {ERC20PresetMinterPauser}.
979  *
980  * TIP: For a detailed writeup see our guide
981  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
982  * to implement supply mechanisms].
983  *
984  * We have followed general OpenZeppelin guidelines: functions revert instead
985  * of returning `false` on failure. This behavior is nonetheless conventional
986  * and does not conflict with the expectations of ERC20 applications.
987  *
988  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
989  * This allows applications to reconstruct the allowance for all accounts just
990  * by listening to said events. Other implementations of the EIP may not emit
991  * these events, as it isn't required by the specification.
992  *
993  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
994  * functions have been added to mitigate the well-known issues around setting
995  * allowances. See {IERC20-approve}.
996  */
997 contract ERC20 is Context, IERC20 {
998     using SafeMath for uint256;
999 
1000     mapping (address => uint256) private _balances;
1001 
1002     mapping (address => mapping (address => uint256)) private _allowances;
1003 
1004     uint256 private _totalSupply;
1005 
1006     string private _name;
1007     string private _symbol;
1008     uint8 private _decimals;
1009 
1010     /**
1011      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1012      * a default value of 18.
1013      *
1014      * To select a different value for {decimals}, use {_setupDecimals}.
1015      *
1016      * All three of these values are immutable: they can only be set once during
1017      * construction.
1018      */
1019     constructor (string memory name_, string memory symbol_) public {
1020         _name = name_;
1021         _symbol = symbol_;
1022         _decimals = 18;
1023     }
1024 
1025     /**
1026      * @dev Returns the name of the token.
1027      */
1028     function name() public view returns (string memory) {
1029         return _name;
1030     }
1031 
1032     /**
1033      * @dev Returns the symbol of the token, usually a shorter version of the
1034      * name.
1035      */
1036     function symbol() public view returns (string memory) {
1037         return _symbol;
1038     }
1039 
1040     /**
1041      * @dev Returns the number of decimals used to get its user representation.
1042      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1043      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1044      *
1045      * Tokens usually opt for a value of 18, imitating the relationship between
1046      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1047      * called.
1048      *
1049      * NOTE: This information is only used for _display_ purposes: it in
1050      * no way affects any of the arithmetic of the contract, including
1051      * {IERC20-balanceOf} and {IERC20-transfer}.
1052      */
1053     function decimals() public view returns (uint8) {
1054         return _decimals;
1055     }
1056 
1057     /**
1058      * @dev See {IERC20-totalSupply}.
1059      */
1060     function totalSupply() public view override returns (uint256) {
1061         return _totalSupply;
1062     }
1063 
1064     /**
1065      * @dev See {IERC20-balanceOf}.
1066      */
1067     function balanceOf(address account) public view override returns (uint256) {
1068         return _balances[account];
1069     }
1070 
1071     /**
1072      * @dev See {IERC20-transfer}.
1073      *
1074      * Requirements:
1075      *
1076      * - `recipient` cannot be the zero address.
1077      * - the caller must have a balance of at least `amount`.
1078      */
1079     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1080         _transfer(_msgSender(), recipient, amount);
1081         return true;
1082     }
1083 
1084     /**
1085      * @dev See {IERC20-allowance}.
1086      */
1087     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1088         return _allowances[owner][spender];
1089     }
1090 
1091     /**
1092      * @dev See {IERC20-approve}.
1093      *
1094      * Requirements:
1095      *
1096      * - `spender` cannot be the zero address.
1097      */
1098     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1099         _approve(_msgSender(), spender, amount);
1100         return true;
1101     }
1102 
1103     /**
1104      * @dev See {IERC20-transferFrom}.
1105      *
1106      * Emits an {Approval} event indicating the updated allowance. This is not
1107      * required by the EIP. See the note at the beginning of {ERC20}.
1108      *
1109      * Requirements:
1110      *
1111      * - `sender` and `recipient` cannot be the zero address.
1112      * - `sender` must have a balance of at least `amount`.
1113      * - the caller must have allowance for ``sender``'s tokens of at least
1114      * `amount`.
1115      */
1116     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1117         _transfer(sender, recipient, amount);
1118         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1119         return true;
1120     }
1121 
1122     /**
1123      * @dev Atomically increases the allowance granted to `spender` by the caller.
1124      *
1125      * This is an alternative to {approve} that can be used as a mitigation for
1126      * problems described in {IERC20-approve}.
1127      *
1128      * Emits an {Approval} event indicating the updated allowance.
1129      *
1130      * Requirements:
1131      *
1132      * - `spender` cannot be the zero address.
1133      */
1134     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1135         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1136         return true;
1137     }
1138 
1139     /**
1140      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1141      *
1142      * This is an alternative to {approve} that can be used as a mitigation for
1143      * problems described in {IERC20-approve}.
1144      *
1145      * Emits an {Approval} event indicating the updated allowance.
1146      *
1147      * Requirements:
1148      *
1149      * - `spender` cannot be the zero address.
1150      * - `spender` must have allowance for the caller of at least
1151      * `subtractedValue`.
1152      */
1153     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1154         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1155         return true;
1156     }
1157 
1158     /**
1159      * @dev Moves tokens `amount` from `sender` to `recipient`.
1160      *
1161      * This is internal function is equivalent to {transfer}, and can be used to
1162      * e.g. implement automatic token fees, slashing mechanisms, etc.
1163      *
1164      * Emits a {Transfer} event.
1165      *
1166      * Requirements:
1167      *
1168      * - `sender` cannot be the zero address.
1169      * - `recipient` cannot be the zero address.
1170      * - `sender` must have a balance of at least `amount`.
1171      */
1172     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1173         require(sender != address(0), "ERC20: transfer from the zero address");
1174         require(recipient != address(0), "ERC20: transfer to the zero address");
1175 
1176         _beforeTokenTransfer(sender, recipient, amount);
1177 
1178         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1179         _balances[recipient] = _balances[recipient].add(amount);
1180         emit Transfer(sender, recipient, amount);
1181     }
1182 
1183     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1184      * the total supply.
1185      *
1186      * Emits a {Transfer} event with `from` set to the zero address.
1187      *
1188      * Requirements:
1189      *
1190      * - `to` cannot be the zero address.
1191      */
1192     function _mint(address account, uint256 amount) internal virtual {
1193         require(account != address(0), "ERC20: mint to the zero address");
1194 
1195         _beforeTokenTransfer(address(0), account, amount);
1196 
1197         _totalSupply = _totalSupply.add(amount);
1198         _balances[account] = _balances[account].add(amount);
1199         emit Transfer(address(0), account, amount);
1200     }
1201 
1202     /**
1203      * @dev Destroys `amount` tokens from `account`, reducing the
1204      * total supply.
1205      *
1206      * Emits a {Transfer} event with `to` set to the zero address.
1207      *
1208      * Requirements:
1209      *
1210      * - `account` cannot be the zero address.
1211      * - `account` must have at least `amount` tokens.
1212      */
1213     function _burn(address account, uint256 amount) internal virtual {
1214         require(account != address(0), "ERC20: burn from the zero address");
1215 
1216         _beforeTokenTransfer(account, address(0), amount);
1217 
1218         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1219         _totalSupply = _totalSupply.sub(amount);
1220         emit Transfer(account, address(0), amount);
1221     }
1222 
1223     /**
1224      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1225      *
1226      * This internal function is equivalent to `approve`, and can be used to
1227      * e.g. set automatic allowances for certain subsystems, etc.
1228      *
1229      * Emits an {Approval} event.
1230      *
1231      * Requirements:
1232      *
1233      * - `owner` cannot be the zero address.
1234      * - `spender` cannot be the zero address.
1235      */
1236     function _approve(address owner, address spender, uint256 amount) internal virtual {
1237         require(owner != address(0), "ERC20: approve from the zero address");
1238         require(spender != address(0), "ERC20: approve to the zero address");
1239 
1240         _allowances[owner][spender] = amount;
1241         emit Approval(owner, spender, amount);
1242     }
1243 
1244     /**
1245      * @dev Sets {decimals} to a value other than the default one of 18.
1246      *
1247      * WARNING: This function should only be called from the constructor. Most
1248      * applications that interact with token contracts will not expect
1249      * {decimals} to ever change, and may work incorrectly if it does.
1250      */
1251     function _setupDecimals(uint8 decimals_) internal {
1252         _decimals = decimals_;
1253     }
1254 
1255     /**
1256      * @dev Hook that is called before any transfer of tokens. This includes
1257      * minting and burning.
1258      *
1259      * Calling conditions:
1260      *
1261      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1262      * will be to transferred to `to`.
1263      * - when `from` is zero, `amount` tokens will be minted for `to`.
1264      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1265      * - `from` and `to` are never both zero.
1266      *
1267      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1268      */
1269     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1270 }
1271 
1272 
1273 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/ERC20Burnable.sol
1274 
1275 
1276 pragma solidity >=0.6.0 <0.8.0;
1277 
1278 
1279 
1280 /**
1281  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1282  * tokens and those that they have an allowance for, in a way that can be
1283  * recognized off-chain (via event analysis).
1284  */
1285 abstract contract ERC20Burnable is Context, ERC20 {
1286     using SafeMath for uint256;
1287 
1288     /**
1289      * @dev Destroys `amount` tokens from the caller.
1290      *
1291      * See {ERC20-_burn}.
1292      */
1293     function burn(uint256 amount) public virtual {
1294         _burn(_msgSender(), amount);
1295     }
1296 
1297     /**
1298      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1299      * allowance.
1300      *
1301      * See {ERC20-_burn} and {ERC20-allowance}.
1302      *
1303      * Requirements:
1304      *
1305      * - the caller must have allowance for ``accounts``'s tokens of at least
1306      * `amount`.
1307      */
1308     function burnFrom(address account, uint256 amount) public virtual {
1309         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1310 
1311         _approve(account, _msgSender(), decreasedAllowance);
1312         _burn(account, amount);
1313     }
1314 }
1315 
1316 // File: browser/lixir.sol
1317 
1318 pragma solidity ^0.7.0;
1319 
1320 
1321 
1322 
1323 
1324 
1325 contract LixToken is AccessControl, ERC20Burnable, IMintableToken {
1326     using Address for address;
1327 
1328     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1329 
1330     uint256 public constant INITIAL_SUPPLY = 10000000; // 10 MILLION
1331 
1332     constructor() ERC20("Lixir Token", "LIX") {
1333         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1334         _mint(msg.sender, INITIAL_SUPPLY * 1e18);
1335     }
1336 
1337     /**
1338      * @notice Mints `amount` tokens for `to`.
1339      *
1340      * Requirements:
1341      *
1342      * - The caller must have the `MINTER` role.
1343      */
1344     function mint(address to, uint256 amount) external override {
1345         require(hasRole(MINTER_ROLE, msg.sender), "LIX: Mint Not Authorized");
1346         _mint(to, amount);
1347     }
1348 }