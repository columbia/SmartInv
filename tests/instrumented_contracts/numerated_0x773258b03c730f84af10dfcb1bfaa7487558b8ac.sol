1 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
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
28  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
29  * and `uint256` (`UintSet`) are supported.
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
137     // Bytes32Set
138 
139     struct Bytes32Set {
140         Set _inner;
141     }
142 
143     /**
144      * @dev Add a value to a set. O(1).
145      *
146      * Returns true if the value was added to the set, that is if it was not
147      * already present.
148      */
149     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
150         return _add(set._inner, value);
151     }
152 
153     /**
154      * @dev Removes a value from a set. O(1).
155      *
156      * Returns true if the value was removed from the set, that is if it was
157      * present.
158      */
159     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
160         return _remove(set._inner, value);
161     }
162 
163     /**
164      * @dev Returns true if the value is in the set. O(1).
165      */
166     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
167         return _contains(set._inner, value);
168     }
169 
170     /**
171      * @dev Returns the number of values in the set. O(1).
172      */
173     function length(Bytes32Set storage set) internal view returns (uint256) {
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
187     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
188         return _at(set._inner, index);
189     }
190 
191     // AddressSet
192 
193     struct AddressSet {
194         Set _inner;
195     }
196 
197     /**
198      * @dev Add a value to a set. O(1).
199      *
200      * Returns true if the value was added to the set, that is if it was not
201      * already present.
202      */
203     function add(AddressSet storage set, address value) internal returns (bool) {
204         return _add(set._inner, bytes32(uint256(uint160(value))));
205     }
206 
207     /**
208      * @dev Removes a value from a set. O(1).
209      *
210      * Returns true if the value was removed from the set, that is if it was
211      * present.
212      */
213     function remove(AddressSet storage set, address value) internal returns (bool) {
214         return _remove(set._inner, bytes32(uint256(uint160(value))));
215     }
216 
217     /**
218      * @dev Returns true if the value is in the set. O(1).
219      */
220     function contains(AddressSet storage set, address value) internal view returns (bool) {
221         return _contains(set._inner, bytes32(uint256(uint160(value))));
222     }
223 
224     /**
225      * @dev Returns the number of values in the set. O(1).
226      */
227     function length(AddressSet storage set) internal view returns (uint256) {
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
241     function at(AddressSet storage set, uint256 index) internal view returns (address) {
242         return address(uint160(uint256(_at(set._inner, index))));
243     }
244 
245 
246     // UintSet
247 
248     struct UintSet {
249         Set _inner;
250     }
251 
252     /**
253      * @dev Add a value to a set. O(1).
254      *
255      * Returns true if the value was added to the set, that is if it was not
256      * already present.
257      */
258     function add(UintSet storage set, uint256 value) internal returns (bool) {
259         return _add(set._inner, bytes32(value));
260     }
261 
262     /**
263      * @dev Removes a value from a set. O(1).
264      *
265      * Returns true if the value was removed from the set, that is if it was
266      * present.
267      */
268     function remove(UintSet storage set, uint256 value) internal returns (bool) {
269         return _remove(set._inner, bytes32(value));
270     }
271 
272     /**
273      * @dev Returns true if the value is in the set. O(1).
274      */
275     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
276         return _contains(set._inner, bytes32(value));
277     }
278 
279     /**
280      * @dev Returns the number of values on the set. O(1).
281      */
282     function length(UintSet storage set) internal view returns (uint256) {
283         return _length(set._inner);
284     }
285 
286    /**
287     * @dev Returns the value stored at position `index` in the set. O(1).
288     *
289     * Note that there are no guarantees on the ordering of values inside the
290     * array, and it may change when more values are added or removed.
291     *
292     * Requirements:
293     *
294     * - `index` must be strictly less than {length}.
295     */
296     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
297         return uint256(_at(set._inner, index));
298     }
299 }
300 
301 // File: @openzeppelin/contracts/utils/Address.sol
302 
303 pragma solidity >=0.6.2 <0.8.0;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize, which returns 0 for contracts in
328         // construction, since the code is only stored at the end of the
329         // constructor execution.
330 
331         uint256 size;
332         // solhint-disable-next-line no-inline-assembly
333         assembly { size := extcodesize(account) }
334         return size > 0;
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(address(this).balance >= amount, "Address: insufficient balance");
355 
356         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
357         (bool success, ) = recipient.call{ value: amount }("");
358         require(success, "Address: unable to send value, recipient may have reverted");
359     }
360 
361     /**
362      * @dev Performs a Solidity function call using a low level `call`. A
363      * plain`call` is an unsafe replacement for a function call: use this
364      * function instead.
365      *
366      * If `target` reverts with a revert reason, it is bubbled up by this
367      * function (like regular Solidity function calls).
368      *
369      * Returns the raw returned data. To convert to the expected return value,
370      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
371      *
372      * Requirements:
373      *
374      * - `target` must be a contract.
375      * - calling `target` with `data` must not revert.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
380       return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
415         require(address(this).balance >= value, "Address: insufficient balance for call");
416         require(isContract(target), "Address: call to non-contract");
417 
418         // solhint-disable-next-line avoid-low-level-calls
419         (bool success, bytes memory returndata) = target.call{ value: value }(data);
420         return _verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
440         require(isContract(target), "Address: static call to non-contract");
441 
442         // solhint-disable-next-line avoid-low-level-calls
443         (bool success, bytes memory returndata) = target.staticcall(data);
444         return _verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
454         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a delegate call.
460      *
461      * _Available since v3.4._
462      */
463     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
464         require(isContract(target), "Address: delegate call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.delegatecall(data);
468         return _verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 // solhint-disable-next-line no-inline-assembly
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 // File: @openzeppelin/contracts/utils/Context.sol
492 
493 pragma solidity >=0.6.0 <0.8.0;
494 
495 /*
496  * @dev Provides information about the current execution context, including the
497  * sender of the transaction and its data. While these are generally available
498  * via msg.sender and msg.data, they should not be accessed in such a direct
499  * manner, since when dealing with GSN meta-transactions the account sending and
500  * paying for execution may not be the actual sender (as far as an application
501  * is concerned).
502  *
503  * This contract is only required for intermediate, library-like contracts.
504  */
505 abstract contract Context {
506     function _msgSender() internal view virtual returns (address payable) {
507         return msg.sender;
508     }
509 
510     function _msgData() internal view virtual returns (bytes memory) {
511         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
512         return msg.data;
513     }
514 }
515 
516 // File: @openzeppelin/contracts/access/AccessControl.sol
517 
518 pragma solidity >=0.6.0 <0.8.0;
519 
520 
521 
522 
523 /**
524  * @dev Contract module that allows children to implement role-based access
525  * control mechanisms.
526  *
527  * Roles are referred to by their `bytes32` identifier. These should be exposed
528  * in the external API and be unique. The best way to achieve this is by
529  * using `public constant` hash digests:
530  *
531  * ```
532  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
533  * ```
534  *
535  * Roles can be used to represent a set of permissions. To restrict access to a
536  * function call, use {hasRole}:
537  *
538  * ```
539  * function foo() public {
540  *     require(hasRole(MY_ROLE, msg.sender));
541  *     ...
542  * }
543  * ```
544  *
545  * Roles can be granted and revoked dynamically via the {grantRole} and
546  * {revokeRole} functions. Each role has an associated admin role, and only
547  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
548  *
549  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
550  * that only accounts with this role will be able to grant or revoke other
551  * roles. More complex role relationships can be created by using
552  * {_setRoleAdmin}.
553  *
554  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
555  * grant and revoke this role. Extra precautions should be taken to secure
556  * accounts that have been granted it.
557  */
558 abstract contract AccessControl is Context {
559     using EnumerableSet for EnumerableSet.AddressSet;
560     using Address for address;
561 
562     struct RoleData {
563         EnumerableSet.AddressSet members;
564         bytes32 adminRole;
565     }
566 
567     mapping (bytes32 => RoleData) private _roles;
568 
569     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
570 
571     /**
572      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
573      *
574      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
575      * {RoleAdminChanged} not being emitted signaling this.
576      *
577      * _Available since v3.1._
578      */
579     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
580 
581     /**
582      * @dev Emitted when `account` is granted `role`.
583      *
584      * `sender` is the account that originated the contract call, an admin role
585      * bearer except when using {_setupRole}.
586      */
587     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
588 
589     /**
590      * @dev Emitted when `account` is revoked `role`.
591      *
592      * `sender` is the account that originated the contract call:
593      *   - if using `revokeRole`, it is the admin role bearer
594      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
595      */
596     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
597 
598     /**
599      * @dev Returns `true` if `account` has been granted `role`.
600      */
601     function hasRole(bytes32 role, address account) public view returns (bool) {
602         return _roles[role].members.contains(account);
603     }
604 
605     /**
606      * @dev Returns the number of accounts that have `role`. Can be used
607      * together with {getRoleMember} to enumerate all bearers of a role.
608      */
609     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
610         return _roles[role].members.length();
611     }
612 
613     /**
614      * @dev Returns one of the accounts that have `role`. `index` must be a
615      * value between 0 and {getRoleMemberCount}, non-inclusive.
616      *
617      * Role bearers are not sorted in any particular way, and their ordering may
618      * change at any point.
619      *
620      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
621      * you perform all queries on the same block. See the following
622      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
623      * for more information.
624      */
625     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
626         return _roles[role].members.at(index);
627     }
628 
629     /**
630      * @dev Returns the admin role that controls `role`. See {grantRole} and
631      * {revokeRole}.
632      *
633      * To change a role's admin, use {_setRoleAdmin}.
634      */
635     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
636         return _roles[role].adminRole;
637     }
638 
639     /**
640      * @dev Grants `role` to `account`.
641      *
642      * If `account` had not been already granted `role`, emits a {RoleGranted}
643      * event.
644      *
645      * Requirements:
646      *
647      * - the caller must have ``role``'s admin role.
648      */
649     function grantRole(bytes32 role, address account) public virtual {
650         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
651 
652         _grantRole(role, account);
653     }
654 
655     /**
656      * @dev Revokes `role` from `account`.
657      *
658      * If `account` had been granted `role`, emits a {RoleRevoked} event.
659      *
660      * Requirements:
661      *
662      * - the caller must have ``role``'s admin role.
663      */
664     function revokeRole(bytes32 role, address account) public virtual {
665         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
666 
667         _revokeRole(role, account);
668     }
669 
670     /**
671      * @dev Revokes `role` from the calling account.
672      *
673      * Roles are often managed via {grantRole} and {revokeRole}: this function's
674      * purpose is to provide a mechanism for accounts to lose their privileges
675      * if they are compromised (such as when a trusted device is misplaced).
676      *
677      * If the calling account had been granted `role`, emits a {RoleRevoked}
678      * event.
679      *
680      * Requirements:
681      *
682      * - the caller must be `account`.
683      */
684     function renounceRole(bytes32 role, address account) public virtual {
685         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
686 
687         _revokeRole(role, account);
688     }
689 
690     /**
691      * @dev Grants `role` to `account`.
692      *
693      * If `account` had not been already granted `role`, emits a {RoleGranted}
694      * event. Note that unlike {grantRole}, this function doesn't perform any
695      * checks on the calling account.
696      *
697      * [WARNING]
698      * ====
699      * This function should only be called from the constructor when setting
700      * up the initial roles for the system.
701      *
702      * Using this function in any other way is effectively circumventing the admin
703      * system imposed by {AccessControl}.
704      * ====
705      */
706     function _setupRole(bytes32 role, address account) internal virtual {
707         _grantRole(role, account);
708     }
709 
710     /**
711      * @dev Sets `adminRole` as ``role``'s admin role.
712      *
713      * Emits a {RoleAdminChanged} event.
714      */
715     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
716         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
717         _roles[role].adminRole = adminRole;
718     }
719 
720     function _grantRole(bytes32 role, address account) private {
721         if (_roles[role].members.add(account)) {
722             emit RoleGranted(role, account, _msgSender());
723         }
724     }
725 
726     function _revokeRole(bytes32 role, address account) private {
727         if (_roles[role].members.remove(account)) {
728             emit RoleRevoked(role, account, _msgSender());
729         }
730     }
731 }
732 
733 // File: @openzeppelin/contracts/GSN/Context.sol
734 
735 pragma solidity >=0.6.0 <0.8.0;
736 
737 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
738 
739 pragma solidity >=0.6.0 <0.8.0;
740 
741 /**
742  * @dev Interface of the ERC20 standard as defined in the EIP.
743  */
744 interface IERC20 {
745     /**
746      * @dev Returns the amount of tokens in existence.
747      */
748     function totalSupply() external view returns (uint256);
749 
750     /**
751      * @dev Returns the amount of tokens owned by `account`.
752      */
753     function balanceOf(address account) external view returns (uint256);
754 
755     /**
756      * @dev Moves `amount` tokens from the caller's account to `recipient`.
757      *
758      * Returns a boolean value indicating whether the operation succeeded.
759      *
760      * Emits a {Transfer} event.
761      */
762     function transfer(address recipient, uint256 amount) external returns (bool);
763 
764     /**
765      * @dev Returns the remaining number of tokens that `spender` will be
766      * allowed to spend on behalf of `owner` through {transferFrom}. This is
767      * zero by default.
768      *
769      * This value changes when {approve} or {transferFrom} are called.
770      */
771     function allowance(address owner, address spender) external view returns (uint256);
772 
773     /**
774      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
775      *
776      * Returns a boolean value indicating whether the operation succeeded.
777      *
778      * IMPORTANT: Beware that changing an allowance with this method brings the risk
779      * that someone may use both the old and the new allowance by unfortunate
780      * transaction ordering. One possible solution to mitigate this race
781      * condition is to first reduce the spender's allowance to 0 and set the
782      * desired value afterwards:
783      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
784      *
785      * Emits an {Approval} event.
786      */
787     function approve(address spender, uint256 amount) external returns (bool);
788 
789     /**
790      * @dev Moves `amount` tokens from `sender` to `recipient` using the
791      * allowance mechanism. `amount` is then deducted from the caller's
792      * allowance.
793      *
794      * Returns a boolean value indicating whether the operation succeeded.
795      *
796      * Emits a {Transfer} event.
797      */
798     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
799 
800     /**
801      * @dev Emitted when `value` tokens are moved from one account (`from`) to
802      * another (`to`).
803      *
804      * Note that `value` may be zero.
805      */
806     event Transfer(address indexed from, address indexed to, uint256 value);
807 
808     /**
809      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
810      * a call to {approve}. `value` is the new allowance.
811      */
812     event Approval(address indexed owner, address indexed spender, uint256 value);
813 }
814 
815 // File: @openzeppelin/contracts/math/SafeMath.sol
816 
817 pragma solidity >=0.6.0 <0.8.0;
818 
819 /**
820  * @dev Wrappers over Solidity's arithmetic operations with added overflow
821  * checks.
822  *
823  * Arithmetic operations in Solidity wrap on overflow. This can easily result
824  * in bugs, because programmers usually assume that an overflow raises an
825  * error, which is the standard behavior in high level programming languages.
826  * `SafeMath` restores this intuition by reverting the transaction when an
827  * operation overflows.
828  *
829  * Using this library instead of the unchecked operations eliminates an entire
830  * class of bugs, so it's recommended to use it always.
831  */
832 library SafeMath {
833     /**
834      * @dev Returns the addition of two unsigned integers, with an overflow flag.
835      *
836      * _Available since v3.4._
837      */
838     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
839         uint256 c = a + b;
840         if (c < a) return (false, 0);
841         return (true, c);
842     }
843 
844     /**
845      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
846      *
847      * _Available since v3.4._
848      */
849     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
850         if (b > a) return (false, 0);
851         return (true, a - b);
852     }
853 
854     /**
855      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
856      *
857      * _Available since v3.4._
858      */
859     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
860         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
861         // benefit is lost if 'b' is also tested.
862         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
863         if (a == 0) return (true, 0);
864         uint256 c = a * b;
865         if (c / a != b) return (false, 0);
866         return (true, c);
867     }
868 
869     /**
870      * @dev Returns the division of two unsigned integers, with a division by zero flag.
871      *
872      * _Available since v3.4._
873      */
874     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
875         if (b == 0) return (false, 0);
876         return (true, a / b);
877     }
878 
879     /**
880      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
881      *
882      * _Available since v3.4._
883      */
884     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
885         if (b == 0) return (false, 0);
886         return (true, a % b);
887     }
888 
889     /**
890      * @dev Returns the addition of two unsigned integers, reverting on
891      * overflow.
892      *
893      * Counterpart to Solidity's `+` operator.
894      *
895      * Requirements:
896      *
897      * - Addition cannot overflow.
898      */
899     function add(uint256 a, uint256 b) internal pure returns (uint256) {
900         uint256 c = a + b;
901         require(c >= a, "SafeMath: addition overflow");
902         return c;
903     }
904 
905     /**
906      * @dev Returns the subtraction of two unsigned integers, reverting on
907      * overflow (when the result is negative).
908      *
909      * Counterpart to Solidity's `-` operator.
910      *
911      * Requirements:
912      *
913      * - Subtraction cannot overflow.
914      */
915     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
916         require(b <= a, "SafeMath: subtraction overflow");
917         return a - b;
918     }
919 
920     /**
921      * @dev Returns the multiplication of two unsigned integers, reverting on
922      * overflow.
923      *
924      * Counterpart to Solidity's `*` operator.
925      *
926      * Requirements:
927      *
928      * - Multiplication cannot overflow.
929      */
930     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
931         if (a == 0) return 0;
932         uint256 c = a * b;
933         require(c / a == b, "SafeMath: multiplication overflow");
934         return c;
935     }
936 
937     /**
938      * @dev Returns the integer division of two unsigned integers, reverting on
939      * division by zero. The result is rounded towards zero.
940      *
941      * Counterpart to Solidity's `/` operator. Note: this function uses a
942      * `revert` opcode (which leaves remaining gas untouched) while Solidity
943      * uses an invalid opcode to revert (consuming all remaining gas).
944      *
945      * Requirements:
946      *
947      * - The divisor cannot be zero.
948      */
949     function div(uint256 a, uint256 b) internal pure returns (uint256) {
950         require(b > 0, "SafeMath: division by zero");
951         return a / b;
952     }
953 
954     /**
955      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
956      * reverting when dividing by zero.
957      *
958      * Counterpart to Solidity's `%` operator. This function uses a `revert`
959      * opcode (which leaves remaining gas untouched) while Solidity uses an
960      * invalid opcode to revert (consuming all remaining gas).
961      *
962      * Requirements:
963      *
964      * - The divisor cannot be zero.
965      */
966     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
967         require(b > 0, "SafeMath: modulo by zero");
968         return a % b;
969     }
970 
971     /**
972      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
973      * overflow (when the result is negative).
974      *
975      * CAUTION: This function is deprecated because it requires allocating memory for the error
976      * message unnecessarily. For custom revert reasons use {trySub}.
977      *
978      * Counterpart to Solidity's `-` operator.
979      *
980      * Requirements:
981      *
982      * - Subtraction cannot overflow.
983      */
984     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
985         require(b <= a, errorMessage);
986         return a - b;
987     }
988 
989     /**
990      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
991      * division by zero. The result is rounded towards zero.
992      *
993      * CAUTION: This function is deprecated because it requires allocating memory for the error
994      * message unnecessarily. For custom revert reasons use {tryDiv}.
995      *
996      * Counterpart to Solidity's `/` operator. Note: this function uses a
997      * `revert` opcode (which leaves remaining gas untouched) while Solidity
998      * uses an invalid opcode to revert (consuming all remaining gas).
999      *
1000      * Requirements:
1001      *
1002      * - The divisor cannot be zero.
1003      */
1004     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1005         require(b > 0, errorMessage);
1006         return a / b;
1007     }
1008 
1009     /**
1010      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1011      * reverting with custom message when dividing by zero.
1012      *
1013      * CAUTION: This function is deprecated because it requires allocating memory for the error
1014      * message unnecessarily. For custom revert reasons use {tryMod}.
1015      *
1016      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1017      * opcode (which leaves remaining gas untouched) while Solidity uses an
1018      * invalid opcode to revert (consuming all remaining gas).
1019      *
1020      * Requirements:
1021      *
1022      * - The divisor cannot be zero.
1023      */
1024     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1025         require(b > 0, errorMessage);
1026         return a % b;
1027     }
1028 }
1029 
1030 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1031 
1032 pragma solidity >=0.6.0 <0.8.0;
1033 
1034 
1035 
1036 
1037 /**
1038  * @dev Implementation of the {IERC20} interface.
1039  *
1040  * This implementation is agnostic to the way tokens are created. This means
1041  * that a supply mechanism has to be added in a derived contract using {_mint}.
1042  * For a generic mechanism see {ERC20PresetMinterPauser}.
1043  *
1044  * TIP: For a detailed writeup see our guide
1045  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1046  * to implement supply mechanisms].
1047  *
1048  * We have followed general OpenZeppelin guidelines: functions revert instead
1049  * of returning `false` on failure. This behavior is nonetheless conventional
1050  * and does not conflict with the expectations of ERC20 applications.
1051  *
1052  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1053  * This allows applications to reconstruct the allowance for all accounts just
1054  * by listening to said events. Other implementations of the EIP may not emit
1055  * these events, as it isn't required by the specification.
1056  *
1057  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1058  * functions have been added to mitigate the well-known issues around setting
1059  * allowances. See {IERC20-approve}.
1060  */
1061 contract ERC20 is Context, IERC20 {
1062     using SafeMath for uint256;
1063 
1064     mapping (address => uint256) private _balances;
1065 
1066     mapping (address => mapping (address => uint256)) private _allowances;
1067 
1068     uint256 private _totalSupply;
1069 
1070     string private _name;
1071     string private _symbol;
1072     uint8 private _decimals;
1073 
1074     /**
1075      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1076      * a default value of 18.
1077      *
1078      * To select a different value for {decimals}, use {_setupDecimals}.
1079      *
1080      * All three of these values are immutable: they can only be set once during
1081      * construction.
1082      */
1083     constructor (string memory name_, string memory symbol_) public {
1084         _name = name_;
1085         _symbol = symbol_;
1086         _decimals = 18;
1087     }
1088 
1089     /**
1090      * @dev Returns the name of the token.
1091      */
1092     function name() public view virtual returns (string memory) {
1093         return _name;
1094     }
1095 
1096     /**
1097      * @dev Returns the symbol of the token, usually a shorter version of the
1098      * name.
1099      */
1100     function symbol() public view virtual returns (string memory) {
1101         return _symbol;
1102     }
1103 
1104     /**
1105      * @dev Returns the number of decimals used to get its user representation.
1106      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1107      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1108      *
1109      * Tokens usually opt for a value of 18, imitating the relationship between
1110      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1111      * called.
1112      *
1113      * NOTE: This information is only used for _display_ purposes: it in
1114      * no way affects any of the arithmetic of the contract, including
1115      * {IERC20-balanceOf} and {IERC20-transfer}.
1116      */
1117     function decimals() public view virtual returns (uint8) {
1118         return _decimals;
1119     }
1120 
1121     /**
1122      * @dev See {IERC20-totalSupply}.
1123      */
1124     function totalSupply() public view virtual override returns (uint256) {
1125         return _totalSupply;
1126     }
1127 
1128     /**
1129      * @dev See {IERC20-balanceOf}.
1130      */
1131     function balanceOf(address account) public view virtual override returns (uint256) {
1132         return _balances[account];
1133     }
1134 
1135     /**
1136      * @dev See {IERC20-transfer}.
1137      *
1138      * Requirements:
1139      *
1140      * - `recipient` cannot be the zero address.
1141      * - the caller must have a balance of at least `amount`.
1142      */
1143     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1144         _transfer(_msgSender(), recipient, amount);
1145         return true;
1146     }
1147 
1148     /**
1149      * @dev See {IERC20-allowance}.
1150      */
1151     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1152         return _allowances[owner][spender];
1153     }
1154 
1155     /**
1156      * @dev See {IERC20-approve}.
1157      *
1158      * Requirements:
1159      *
1160      * - `spender` cannot be the zero address.
1161      */
1162     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1163         _approve(_msgSender(), spender, amount);
1164         return true;
1165     }
1166 
1167     /**
1168      * @dev See {IERC20-transferFrom}.
1169      *
1170      * Emits an {Approval} event indicating the updated allowance. This is not
1171      * required by the EIP. See the note at the beginning of {ERC20}.
1172      *
1173      * Requirements:
1174      *
1175      * - `sender` and `recipient` cannot be the zero address.
1176      * - `sender` must have a balance of at least `amount`.
1177      * - the caller must have allowance for ``sender``'s tokens of at least
1178      * `amount`.
1179      */
1180     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1181         _transfer(sender, recipient, amount);
1182         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1183         return true;
1184     }
1185 
1186     /**
1187      * @dev Atomically increases the allowance granted to `spender` by the caller.
1188      *
1189      * This is an alternative to {approve} that can be used as a mitigation for
1190      * problems described in {IERC20-approve}.
1191      *
1192      * Emits an {Approval} event indicating the updated allowance.
1193      *
1194      * Requirements:
1195      *
1196      * - `spender` cannot be the zero address.
1197      */
1198     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1199         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1200         return true;
1201     }
1202 
1203     /**
1204      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1205      *
1206      * This is an alternative to {approve} that can be used as a mitigation for
1207      * problems described in {IERC20-approve}.
1208      *
1209      * Emits an {Approval} event indicating the updated allowance.
1210      *
1211      * Requirements:
1212      *
1213      * - `spender` cannot be the zero address.
1214      * - `spender` must have allowance for the caller of at least
1215      * `subtractedValue`.
1216      */
1217     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1218         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1219         return true;
1220     }
1221 
1222     /**
1223      * @dev Moves tokens `amount` from `sender` to `recipient`.
1224      *
1225      * This is internal function is equivalent to {transfer}, and can be used to
1226      * e.g. implement automatic token fees, slashing mechanisms, etc.
1227      *
1228      * Emits a {Transfer} event.
1229      *
1230      * Requirements:
1231      *
1232      * - `sender` cannot be the zero address.
1233      * - `recipient` cannot be the zero address.
1234      * - `sender` must have a balance of at least `amount`.
1235      */
1236     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1237         require(sender != address(0), "ERC20: transfer from the zero address");
1238         require(recipient != address(0), "ERC20: transfer to the zero address");
1239 
1240         _beforeTokenTransfer(sender, recipient, amount);
1241 
1242         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1243         _balances[recipient] = _balances[recipient].add(amount);
1244         emit Transfer(sender, recipient, amount);
1245     }
1246 
1247     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1248      * the total supply.
1249      *
1250      * Emits a {Transfer} event with `from` set to the zero address.
1251      *
1252      * Requirements:
1253      *
1254      * - `to` cannot be the zero address.
1255      */
1256     function _mint(address account, uint256 amount) internal virtual {
1257         require(account != address(0), "ERC20: mint to the zero address");
1258 
1259         _beforeTokenTransfer(address(0), account, amount);
1260 
1261         _totalSupply = _totalSupply.add(amount);
1262         _balances[account] = _balances[account].add(amount);
1263         emit Transfer(address(0), account, amount);
1264     }
1265 
1266     /**
1267      * @dev Destroys `amount` tokens from `account`, reducing the
1268      * total supply.
1269      *
1270      * Emits a {Transfer} event with `to` set to the zero address.
1271      *
1272      * Requirements:
1273      *
1274      * - `account` cannot be the zero address.
1275      * - `account` must have at least `amount` tokens.
1276      */
1277     function _burn(address account, uint256 amount) internal virtual {
1278         require(account != address(0), "ERC20: burn from the zero address");
1279 
1280         _beforeTokenTransfer(account, address(0), amount);
1281 
1282         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1283         _totalSupply = _totalSupply.sub(amount);
1284         emit Transfer(account, address(0), amount);
1285     }
1286 
1287     /**
1288      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1289      *
1290      * This internal function is equivalent to `approve`, and can be used to
1291      * e.g. set automatic allowances for certain subsystems, etc.
1292      *
1293      * Emits an {Approval} event.
1294      *
1295      * Requirements:
1296      *
1297      * - `owner` cannot be the zero address.
1298      * - `spender` cannot be the zero address.
1299      */
1300     function _approve(address owner, address spender, uint256 amount) internal virtual {
1301         require(owner != address(0), "ERC20: approve from the zero address");
1302         require(spender != address(0), "ERC20: approve to the zero address");
1303 
1304         _allowances[owner][spender] = amount;
1305         emit Approval(owner, spender, amount);
1306     }
1307 
1308     /**
1309      * @dev Sets {decimals} to a value other than the default one of 18.
1310      *
1311      * WARNING: This function should only be called from the constructor. Most
1312      * applications that interact with token contracts will not expect
1313      * {decimals} to ever change, and may work incorrectly if it does.
1314      */
1315     function _setupDecimals(uint8 decimals_) internal virtual {
1316         _decimals = decimals_;
1317     }
1318 
1319     /**
1320      * @dev Hook that is called before any transfer of tokens. This includes
1321      * minting and burning.
1322      *
1323      * Calling conditions:
1324      *
1325      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1326      * will be to transferred to `to`.
1327      * - when `from` is zero, `amount` tokens will be minted for `to`.
1328      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1329      * - `from` and `to` are never both zero.
1330      *
1331      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1332      */
1333     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1334 }
1335 
1336 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1337 
1338 pragma solidity >=0.6.0 <0.8.0;
1339 
1340 
1341 
1342 /**
1343  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1344  * tokens and those that they have an allowance for, in a way that can be
1345  * recognized off-chain (via event analysis).
1346  */
1347 abstract contract ERC20Burnable is Context, ERC20 {
1348     using SafeMath for uint256;
1349 
1350     /**
1351      * @dev Destroys `amount` tokens from the caller.
1352      *
1353      * See {ERC20-_burn}.
1354      */
1355     function burn(uint256 amount) public virtual {
1356         _burn(_msgSender(), amount);
1357     }
1358 
1359     /**
1360      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1361      * allowance.
1362      *
1363      * See {ERC20-_burn} and {ERC20-allowance}.
1364      *
1365      * Requirements:
1366      *
1367      * - the caller must have allowance for ``accounts``'s tokens of at least
1368      * `amount`.
1369      */
1370     function burnFrom(address account, uint256 amount) public virtual {
1371         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1372 
1373         _approve(account, _msgSender(), decreasedAllowance);
1374         _burn(account, amount);
1375     }
1376 }
1377 
1378 // File: @openzeppelin/contracts/utils/Pausable.sol
1379 
1380 pragma solidity >=0.6.0 <0.8.0;
1381 
1382 
1383 /**
1384  * @dev Contract module which allows children to implement an emergency stop
1385  * mechanism that can be triggered by an authorized account.
1386  *
1387  * This module is used through inheritance. It will make available the
1388  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1389  * the functions of your contract. Note that they will not be pausable by
1390  * simply including this module, only once the modifiers are put in place.
1391  */
1392 abstract contract Pausable is Context {
1393     /**
1394      * @dev Emitted when the pause is triggered by `account`.
1395      */
1396     event Paused(address account);
1397 
1398     /**
1399      * @dev Emitted when the pause is lifted by `account`.
1400      */
1401     event Unpaused(address account);
1402 
1403     bool private _paused;
1404 
1405     /**
1406      * @dev Initializes the contract in unpaused state.
1407      */
1408     constructor () internal {
1409         _paused = false;
1410     }
1411 
1412     /**
1413      * @dev Returns true if the contract is paused, and false otherwise.
1414      */
1415     function paused() public view virtual returns (bool) {
1416         return _paused;
1417     }
1418 
1419     /**
1420      * @dev Modifier to make a function callable only when the contract is not paused.
1421      *
1422      * Requirements:
1423      *
1424      * - The contract must not be paused.
1425      */
1426     modifier whenNotPaused() {
1427         require(!paused(), "Pausable: paused");
1428         _;
1429     }
1430 
1431     /**
1432      * @dev Modifier to make a function callable only when the contract is paused.
1433      *
1434      * Requirements:
1435      *
1436      * - The contract must be paused.
1437      */
1438     modifier whenPaused() {
1439         require(paused(), "Pausable: not paused");
1440         _;
1441     }
1442 
1443     /**
1444      * @dev Triggers stopped state.
1445      *
1446      * Requirements:
1447      *
1448      * - The contract must not be paused.
1449      */
1450     function _pause() internal virtual whenNotPaused {
1451         _paused = true;
1452         emit Paused(_msgSender());
1453     }
1454 
1455     /**
1456      * @dev Returns to normal state.
1457      *
1458      * Requirements:
1459      *
1460      * - The contract must be paused.
1461      */
1462     function _unpause() internal virtual whenPaused {
1463         _paused = false;
1464         emit Unpaused(_msgSender());
1465     }
1466 }
1467 
1468 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
1469 
1470 pragma solidity >=0.6.0 <0.8.0;
1471 
1472 
1473 
1474 /**
1475  * @dev ERC20 token with pausable token transfers, minting and burning.
1476  *
1477  * Useful for scenarios such as preventing trades until the end of an evaluation
1478  * period, or having an emergency switch for freezing all token transfers in the
1479  * event of a large bug.
1480  */
1481 abstract contract ERC20Pausable is ERC20, Pausable {
1482     /**
1483      * @dev See {ERC20-_beforeTokenTransfer}.
1484      *
1485      * Requirements:
1486      *
1487      * - the contract must not be paused.
1488      */
1489     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1490         super._beforeTokenTransfer(from, to, amount);
1491 
1492         require(!paused(), "ERC20Pausable: token transfer while paused");
1493     }
1494 }
1495 
1496 // File: eth-contracts/SEFI.sol
1497 
1498 pragma solidity >=0.6.0 <0.8.0;
1499 
1500 
1501 
1502 
1503 
1504 
1505 contract SEFI is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1506     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1507     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1508 
1509     /**
1510      * @dev Grants `DEFAULT_ADMIN_ROLE` and `PAUSER_ROLE` to the
1511      * account that deploys the contract. Grnats `MINTER_ROLE` to the bridge.
1512      *
1513      * See {ERC20-constructor}.
1514      */
1515     constructor(address bridge, uint256 airdrop)
1516         public
1517         ERC20("Secret Finance", "SEFI")
1518     {
1519         _setupDecimals(6);
1520 
1521         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1522         _setupRole(PAUSER_ROLE, _msgSender());
1523         _setupRole(MINTER_ROLE, bridge);
1524 
1525         _mint(_msgSender(), airdrop);
1526     }
1527 
1528     /**
1529      * @dev Pauses all token transfers.
1530      *
1531      * See {ERC20Pausable} and {Pausable-_pause}.
1532      *
1533      * Requirements:
1534      *
1535      * - the caller must have the `PAUSER_ROLE`.
1536      */
1537     function pause() public virtual {
1538         require(
1539             hasRole(PAUSER_ROLE, _msgSender()),
1540             "SEFI: must have pauser role to pause"
1541         );
1542         _pause();
1543     }
1544 
1545     /**
1546      * @dev Unpauses all token transfers.
1547      *
1548      * See {ERC20Pausable} and {Pausable-_unpause}.
1549      *
1550      * Requirements:
1551      *
1552      * - the caller must have the `PAUSER_ROLE`.
1553      */
1554     function unpause() public virtual {
1555         require(
1556             hasRole(PAUSER_ROLE, _msgSender()),
1557             "SEFI: must have pauser role to unpause"
1558         );
1559         _unpause();
1560     }
1561 
1562     function _transfer(
1563         address sender,
1564         address recipient,
1565         uint256 amount
1566     ) internal virtual override {
1567         if (hasRole(MINTER_ROLE, sender)) {
1568             _mint(recipient, amount);
1569         } else if (hasRole(MINTER_ROLE, recipient)) {
1570             _burn(sender, amount);
1571         } else {
1572             super._transfer(sender, recipient, amount);
1573         }
1574     }
1575 
1576     function _beforeTokenTransfer(
1577         address from,
1578         address to,
1579         uint256 amount
1580     ) internal virtual override(ERC20, ERC20Pausable) {
1581         super._beforeTokenTransfer(from, to, amount);
1582     }
1583 }