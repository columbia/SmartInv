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
518 
519 
520 pragma solidity >=0.6.0 <0.8.0;
521 
522 
523 
524 
525 /**
526  * @dev Contract module that allows children to implement role-based access
527  * control mechanisms.
528  *
529  * Roles are referred to by their `bytes32` identifier. These should be exposed
530  * in the external API and be unique. The best way to achieve this is by
531  * using `public constant` hash digests:
532  *
533  * ```
534  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
535  * ```
536  *
537  * Roles can be used to represent a set of permissions. To restrict access to a
538  * function call, use {hasRole}:
539  *
540  * ```
541  * function foo() public {
542  *     require(hasRole(MY_ROLE, msg.sender));
543  *     ...
544  * }
545  * ```
546  *
547  * Roles can be granted and revoked dynamically via the {grantRole} and
548  * {revokeRole} functions. Each role has an associated admin role, and only
549  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
550  *
551  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
552  * that only accounts with this role will be able to grant or revoke other
553  * roles. More complex role relationships can be created by using
554  * {_setRoleAdmin}.
555  *
556  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
557  * grant and revoke this role. Extra precautions should be taken to secure
558  * accounts that have been granted it.
559  */
560 abstract contract AccessControl is Context {
561     using EnumerableSet for EnumerableSet.AddressSet;
562     using Address for address;
563 
564     struct RoleData {
565         EnumerableSet.AddressSet members;
566         bytes32 adminRole;
567     }
568 
569     mapping (bytes32 => RoleData) private _roles;
570 
571     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
572 
573     /**
574      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
575      *
576      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
577      * {RoleAdminChanged} not being emitted signaling this.
578      *
579      * _Available since v3.1._
580      */
581     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
582 
583     /**
584      * @dev Emitted when `account` is granted `role`.
585      *
586      * `sender` is the account that originated the contract call, an admin role
587      * bearer except when using {_setupRole}.
588      */
589     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
590 
591     /**
592      * @dev Emitted when `account` is revoked `role`.
593      *
594      * `sender` is the account that originated the contract call:
595      *   - if using `revokeRole`, it is the admin role bearer
596      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
597      */
598     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
599 
600     /**
601      * @dev Returns `true` if `account` has been granted `role`.
602      */
603     function hasRole(bytes32 role, address account) public view returns (bool) {
604         return _roles[role].members.contains(account);
605     }
606 
607     /**
608      * @dev Returns the number of accounts that have `role`. Can be used
609      * together with {getRoleMember} to enumerate all bearers of a role.
610      */
611     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
612         return _roles[role].members.length();
613     }
614 
615     /**
616      * @dev Returns one of the accounts that have `role`. `index` must be a
617      * value between 0 and {getRoleMemberCount}, non-inclusive.
618      *
619      * Role bearers are not sorted in any particular way, and their ordering may
620      * change at any point.
621      *
622      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
623      * you perform all queries on the same block. See the following
624      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
625      * for more information.
626      */
627     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
628         return _roles[role].members.at(index);
629     }
630 
631     /**
632      * @dev Returns the admin role that controls `role`. See {grantRole} and
633      * {revokeRole}.
634      *
635      * To change a role's admin, use {_setRoleAdmin}.
636      */
637     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
638         return _roles[role].adminRole;
639     }
640 
641     /**
642      * @dev Grants `role` to `account`.
643      *
644      * If `account` had not been already granted `role`, emits a {RoleGranted}
645      * event.
646      *
647      * Requirements:
648      *
649      * - the caller must have ``role``'s admin role.
650      */
651     function grantRole(bytes32 role, address account) public virtual {
652         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
653 
654         _grantRole(role, account);
655     }
656 
657     /**
658      * @dev Revokes `role` from `account`.
659      *
660      * If `account` had been granted `role`, emits a {RoleRevoked} event.
661      *
662      * Requirements:
663      *
664      * - the caller must have ``role``'s admin role.
665      */
666     function revokeRole(bytes32 role, address account) public virtual {
667         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
668 
669         _revokeRole(role, account);
670     }
671 
672     /**
673      * @dev Revokes `role` from the calling account.
674      *
675      * Roles are often managed via {grantRole} and {revokeRole}: this function's
676      * purpose is to provide a mechanism for accounts to lose their privileges
677      * if they are compromised (such as when a trusted device is misplaced).
678      *
679      * If the calling account had been granted `role`, emits a {RoleRevoked}
680      * event.
681      *
682      * Requirements:
683      *
684      * - the caller must be `account`.
685      */
686     function renounceRole(bytes32 role, address account) public virtual {
687         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
688 
689         _revokeRole(role, account);
690     }
691 
692     /**
693      * @dev Grants `role` to `account`.
694      *
695      * If `account` had not been already granted `role`, emits a {RoleGranted}
696      * event. Note that unlike {grantRole}, this function doesn't perform any
697      * checks on the calling account.
698      *
699      * [WARNING]
700      * ====
701      * This function should only be called from the constructor when setting
702      * up the initial roles for the system.
703      *
704      * Using this function in any other way is effectively circumventing the admin
705      * system imposed by {AccessControl}.
706      * ====
707      */
708     function _setupRole(bytes32 role, address account) internal virtual {
709         _grantRole(role, account);
710     }
711 
712     /**
713      * @dev Sets `adminRole` as ``role``'s admin role.
714      *
715      * Emits a {RoleAdminChanged} event.
716      */
717     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
718         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
719         _roles[role].adminRole = adminRole;
720     }
721 
722     function _grantRole(bytes32 role, address account) private {
723         if (_roles[role].members.add(account)) {
724             emit RoleGranted(role, account, _msgSender());
725         }
726     }
727 
728     function _revokeRole(bytes32 role, address account) private {
729         if (_roles[role].members.remove(account)) {
730             emit RoleRevoked(role, account, _msgSender());
731         }
732     }
733 }
734 
735 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
736 
737 
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
817 
818 
819 pragma solidity >=0.6.0 <0.8.0;
820 
821 /**
822  * @dev Wrappers over Solidity's arithmetic operations with added overflow
823  * checks.
824  *
825  * Arithmetic operations in Solidity wrap on overflow. This can easily result
826  * in bugs, because programmers usually assume that an overflow raises an
827  * error, which is the standard behavior in high level programming languages.
828  * `SafeMath` restores this intuition by reverting the transaction when an
829  * operation overflows.
830  *
831  * Using this library instead of the unchecked operations eliminates an entire
832  * class of bugs, so it's recommended to use it always.
833  */
834 library SafeMath {
835     /**
836      * @dev Returns the addition of two unsigned integers, with an overflow flag.
837      *
838      * _Available since v3.4._
839      */
840     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
841         uint256 c = a + b;
842         if (c < a) return (false, 0);
843         return (true, c);
844     }
845 
846     /**
847      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
848      *
849      * _Available since v3.4._
850      */
851     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
852         if (b > a) return (false, 0);
853         return (true, a - b);
854     }
855 
856     /**
857      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
858      *
859      * _Available since v3.4._
860      */
861     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
862         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
863         // benefit is lost if 'b' is also tested.
864         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
865         if (a == 0) return (true, 0);
866         uint256 c = a * b;
867         if (c / a != b) return (false, 0);
868         return (true, c);
869     }
870 
871     /**
872      * @dev Returns the division of two unsigned integers, with a division by zero flag.
873      *
874      * _Available since v3.4._
875      */
876     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
877         if (b == 0) return (false, 0);
878         return (true, a / b);
879     }
880 
881     /**
882      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
883      *
884      * _Available since v3.4._
885      */
886     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
887         if (b == 0) return (false, 0);
888         return (true, a % b);
889     }
890 
891     /**
892      * @dev Returns the addition of two unsigned integers, reverting on
893      * overflow.
894      *
895      * Counterpart to Solidity's `+` operator.
896      *
897      * Requirements:
898      *
899      * - Addition cannot overflow.
900      */
901     function add(uint256 a, uint256 b) internal pure returns (uint256) {
902         uint256 c = a + b;
903         require(c >= a, "SafeMath: addition overflow");
904         return c;
905     }
906 
907     /**
908      * @dev Returns the subtraction of two unsigned integers, reverting on
909      * overflow (when the result is negative).
910      *
911      * Counterpart to Solidity's `-` operator.
912      *
913      * Requirements:
914      *
915      * - Subtraction cannot overflow.
916      */
917     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
918         require(b <= a, "SafeMath: subtraction overflow");
919         return a - b;
920     }
921 
922     /**
923      * @dev Returns the multiplication of two unsigned integers, reverting on
924      * overflow.
925      *
926      * Counterpart to Solidity's `*` operator.
927      *
928      * Requirements:
929      *
930      * - Multiplication cannot overflow.
931      */
932     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
933         if (a == 0) return 0;
934         uint256 c = a * b;
935         require(c / a == b, "SafeMath: multiplication overflow");
936         return c;
937     }
938 
939     /**
940      * @dev Returns the integer division of two unsigned integers, reverting on
941      * division by zero. The result is rounded towards zero.
942      *
943      * Counterpart to Solidity's `/` operator. Note: this function uses a
944      * `revert` opcode (which leaves remaining gas untouched) while Solidity
945      * uses an invalid opcode to revert (consuming all remaining gas).
946      *
947      * Requirements:
948      *
949      * - The divisor cannot be zero.
950      */
951     function div(uint256 a, uint256 b) internal pure returns (uint256) {
952         require(b > 0, "SafeMath: division by zero");
953         return a / b;
954     }
955 
956     /**
957      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
958      * reverting when dividing by zero.
959      *
960      * Counterpart to Solidity's `%` operator. This function uses a `revert`
961      * opcode (which leaves remaining gas untouched) while Solidity uses an
962      * invalid opcode to revert (consuming all remaining gas).
963      *
964      * Requirements:
965      *
966      * - The divisor cannot be zero.
967      */
968     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
969         require(b > 0, "SafeMath: modulo by zero");
970         return a % b;
971     }
972 
973     /**
974      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
975      * overflow (when the result is negative).
976      *
977      * CAUTION: This function is deprecated because it requires allocating memory for the error
978      * message unnecessarily. For custom revert reasons use {trySub}.
979      *
980      * Counterpart to Solidity's `-` operator.
981      *
982      * Requirements:
983      *
984      * - Subtraction cannot overflow.
985      */
986     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
987         require(b <= a, errorMessage);
988         return a - b;
989     }
990 
991     /**
992      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
993      * division by zero. The result is rounded towards zero.
994      *
995      * CAUTION: This function is deprecated because it requires allocating memory for the error
996      * message unnecessarily. For custom revert reasons use {tryDiv}.
997      *
998      * Counterpart to Solidity's `/` operator. Note: this function uses a
999      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1000      * uses an invalid opcode to revert (consuming all remaining gas).
1001      *
1002      * Requirements:
1003      *
1004      * - The divisor cannot be zero.
1005      */
1006     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1007         require(b > 0, errorMessage);
1008         return a / b;
1009     }
1010 
1011     /**
1012      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1013      * reverting with custom message when dividing by zero.
1014      *
1015      * CAUTION: This function is deprecated because it requires allocating memory for the error
1016      * message unnecessarily. For custom revert reasons use {tryMod}.
1017      *
1018      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1019      * opcode (which leaves remaining gas untouched) while Solidity uses an
1020      * invalid opcode to revert (consuming all remaining gas).
1021      *
1022      * Requirements:
1023      *
1024      * - The divisor cannot be zero.
1025      */
1026     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1027         require(b > 0, errorMessage);
1028         return a % b;
1029     }
1030 }
1031 
1032 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1033 
1034 
1035 
1036 pragma solidity >=0.6.0 <0.8.0;
1037 
1038 
1039 
1040 
1041 /**
1042  * @dev Implementation of the {IERC20} interface.
1043  *
1044  * This implementation is agnostic to the way tokens are created. This means
1045  * that a supply mechanism has to be added in a derived contract using {_mint}.
1046  * For a generic mechanism see {ERC20PresetMinterPauser}.
1047  *
1048  * TIP: For a detailed writeup see our guide
1049  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1050  * to implement supply mechanisms].
1051  *
1052  * We have followed general OpenZeppelin guidelines: functions revert instead
1053  * of returning `false` on failure. This behavior is nonetheless conventional
1054  * and does not conflict with the expectations of ERC20 applications.
1055  *
1056  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1057  * This allows applications to reconstruct the allowance for all accounts just
1058  * by listening to said events. Other implementations of the EIP may not emit
1059  * these events, as it isn't required by the specification.
1060  *
1061  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1062  * functions have been added to mitigate the well-known issues around setting
1063  * allowances. See {IERC20-approve}.
1064  */
1065 contract ERC20 is Context, IERC20 {
1066     using SafeMath for uint256;
1067 
1068     mapping (address => uint256) private _balances;
1069 
1070     mapping (address => mapping (address => uint256)) private _allowances;
1071 
1072     uint256 private _totalSupply;
1073 
1074     string private _name;
1075     string private _symbol;
1076     uint8 private _decimals;
1077 
1078     /**
1079      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1080      * a default value of 18.
1081      *
1082      * To select a different value for {decimals}, use {_setupDecimals}.
1083      *
1084      * All three of these values are immutable: they can only be set once during
1085      * construction.
1086      */
1087     constructor (string memory name_, string memory symbol_) public {
1088         _name = name_;
1089         _symbol = symbol_;
1090         _decimals = 18;
1091     }
1092 
1093     /**
1094      * @dev Returns the name of the token.
1095      */
1096     function name() public view virtual returns (string memory) {
1097         return _name;
1098     }
1099 
1100     /**
1101      * @dev Returns the symbol of the token, usually a shorter version of the
1102      * name.
1103      */
1104     function symbol() public view virtual returns (string memory) {
1105         return _symbol;
1106     }
1107 
1108     /**
1109      * @dev Returns the number of decimals used to get its user representation.
1110      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1111      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1112      *
1113      * Tokens usually opt for a value of 18, imitating the relationship between
1114      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1115      * called.
1116      *
1117      * NOTE: This information is only used for _display_ purposes: it in
1118      * no way affects any of the arithmetic of the contract, including
1119      * {IERC20-balanceOf} and {IERC20-transfer}.
1120      */
1121     function decimals() public view virtual returns (uint8) {
1122         return _decimals;
1123     }
1124 
1125     /**
1126      * @dev See {IERC20-totalSupply}.
1127      */
1128     function totalSupply() public view virtual override returns (uint256) {
1129         return _totalSupply;
1130     }
1131 
1132     /**
1133      * @dev See {IERC20-balanceOf}.
1134      */
1135     function balanceOf(address account) public view virtual override returns (uint256) {
1136         return _balances[account];
1137     }
1138 
1139     /**
1140      * @dev See {IERC20-transfer}.
1141      *
1142      * Requirements:
1143      *
1144      * - `recipient` cannot be the zero address.
1145      * - the caller must have a balance of at least `amount`.
1146      */
1147     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1148         _transfer(_msgSender(), recipient, amount);
1149         return true;
1150     }
1151 
1152     /**
1153      * @dev See {IERC20-allowance}.
1154      */
1155     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1156         return _allowances[owner][spender];
1157     }
1158 
1159     /**
1160      * @dev See {IERC20-approve}.
1161      *
1162      * Requirements:
1163      *
1164      * - `spender` cannot be the zero address.
1165      */
1166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1167         _approve(_msgSender(), spender, amount);
1168         return true;
1169     }
1170 
1171     /**
1172      * @dev See {IERC20-transferFrom}.
1173      *
1174      * Emits an {Approval} event indicating the updated allowance. This is not
1175      * required by the EIP. See the note at the beginning of {ERC20}.
1176      *
1177      * Requirements:
1178      *
1179      * - `sender` and `recipient` cannot be the zero address.
1180      * - `sender` must have a balance of at least `amount`.
1181      * - the caller must have allowance for ``sender``'s tokens of at least
1182      * `amount`.
1183      */
1184     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1185         _transfer(sender, recipient, amount);
1186         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1187         return true;
1188     }
1189 
1190     /**
1191      * @dev Atomically increases the allowance granted to `spender` by the caller.
1192      *
1193      * This is an alternative to {approve} that can be used as a mitigation for
1194      * problems described in {IERC20-approve}.
1195      *
1196      * Emits an {Approval} event indicating the updated allowance.
1197      *
1198      * Requirements:
1199      *
1200      * - `spender` cannot be the zero address.
1201      */
1202     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1203         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1204         return true;
1205     }
1206 
1207     /**
1208      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1209      *
1210      * This is an alternative to {approve} that can be used as a mitigation for
1211      * problems described in {IERC20-approve}.
1212      *
1213      * Emits an {Approval} event indicating the updated allowance.
1214      *
1215      * Requirements:
1216      *
1217      * - `spender` cannot be the zero address.
1218      * - `spender` must have allowance for the caller of at least
1219      * `subtractedValue`.
1220      */
1221     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1222         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1223         return true;
1224     }
1225 
1226     /**
1227      * @dev Moves tokens `amount` from `sender` to `recipient`.
1228      *
1229      * This is internal function is equivalent to {transfer}, and can be used to
1230      * e.g. implement automatic token fees, slashing mechanisms, etc.
1231      *
1232      * Emits a {Transfer} event.
1233      *
1234      * Requirements:
1235      *
1236      * - `sender` cannot be the zero address.
1237      * - `recipient` cannot be the zero address.
1238      * - `sender` must have a balance of at least `amount`.
1239      */
1240     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1241         require(sender != address(0), "ERC20: transfer from the zero address");
1242         require(recipient != address(0), "ERC20: transfer to the zero address");
1243 
1244         _beforeTokenTransfer(sender, recipient, amount);
1245 
1246         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1247         _balances[recipient] = _balances[recipient].add(amount);
1248         emit Transfer(sender, recipient, amount);
1249     }
1250 
1251     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1252      * the total supply.
1253      *
1254      * Emits a {Transfer} event with `from` set to the zero address.
1255      *
1256      * Requirements:
1257      *
1258      * - `to` cannot be the zero address.
1259      */
1260     function _mint(address account, uint256 amount) internal virtual {
1261         require(account != address(0), "ERC20: mint to the zero address");
1262 
1263         _beforeTokenTransfer(address(0), account, amount);
1264 
1265         _totalSupply = _totalSupply.add(amount);
1266         _balances[account] = _balances[account].add(amount);
1267         emit Transfer(address(0), account, amount);
1268     }
1269 
1270     /**
1271      * @dev Destroys `amount` tokens from `account`, reducing the
1272      * total supply.
1273      *
1274      * Emits a {Transfer} event with `to` set to the zero address.
1275      *
1276      * Requirements:
1277      *
1278      * - `account` cannot be the zero address.
1279      * - `account` must have at least `amount` tokens.
1280      */
1281     function _burn(address account, uint256 amount) internal virtual {
1282         require(account != address(0), "ERC20: burn from the zero address");
1283 
1284         _beforeTokenTransfer(account, address(0), amount);
1285 
1286         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1287         _totalSupply = _totalSupply.sub(amount);
1288         emit Transfer(account, address(0), amount);
1289     }
1290 
1291     /**
1292      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1293      *
1294      * This internal function is equivalent to `approve`, and can be used to
1295      * e.g. set automatic allowances for certain subsystems, etc.
1296      *
1297      * Emits an {Approval} event.
1298      *
1299      * Requirements:
1300      *
1301      * - `owner` cannot be the zero address.
1302      * - `spender` cannot be the zero address.
1303      */
1304     function _approve(address owner, address spender, uint256 amount) internal virtual {
1305         require(owner != address(0), "ERC20: approve from the zero address");
1306         require(spender != address(0), "ERC20: approve to the zero address");
1307 
1308         _allowances[owner][spender] = amount;
1309         emit Approval(owner, spender, amount);
1310     }
1311 
1312     /**
1313      * @dev Sets {decimals} to a value other than the default one of 18.
1314      *
1315      * WARNING: This function should only be called from the constructor. Most
1316      * applications that interact with token contracts will not expect
1317      * {decimals} to ever change, and may work incorrectly if it does.
1318      */
1319     function _setupDecimals(uint8 decimals_) internal virtual {
1320         _decimals = decimals_;
1321     }
1322 
1323     /**
1324      * @dev Hook that is called before any transfer of tokens. This includes
1325      * minting and burning.
1326      *
1327      * Calling conditions:
1328      *
1329      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1330      * will be to transferred to `to`.
1331      * - when `from` is zero, `amount` tokens will be minted for `to`.
1332      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1333      * - `from` and `to` are never both zero.
1334      *
1335      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1336      */
1337     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1338 }
1339 
1340 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1341 
1342 
1343 
1344 pragma solidity >=0.6.0 <0.8.0;
1345 
1346 
1347 
1348 /**
1349  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1350  * tokens and those that they have an allowance for, in a way that can be
1351  * recognized off-chain (via event analysis).
1352  */
1353 abstract contract ERC20Burnable is Context, ERC20 {
1354     using SafeMath for uint256;
1355 
1356     /**
1357      * @dev Destroys `amount` tokens from the caller.
1358      *
1359      * See {ERC20-_burn}.
1360      */
1361     function burn(uint256 amount) public virtual {
1362         _burn(_msgSender(), amount);
1363     }
1364 
1365     /**
1366      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1367      * allowance.
1368      *
1369      * See {ERC20-_burn} and {ERC20-allowance}.
1370      *
1371      * Requirements:
1372      *
1373      * - the caller must have allowance for ``accounts``'s tokens of at least
1374      * `amount`.
1375      */
1376     function burnFrom(address account, uint256 amount) public virtual {
1377         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1378 
1379         _approve(account, _msgSender(), decreasedAllowance);
1380         _burn(account, amount);
1381     }
1382 }
1383 
1384 // File: @openzeppelin/contracts/utils/Pausable.sol
1385 
1386 
1387 
1388 pragma solidity >=0.6.0 <0.8.0;
1389 
1390 
1391 /**
1392  * @dev Contract module which allows children to implement an emergency stop
1393  * mechanism that can be triggered by an authorized account.
1394  *
1395  * This module is used through inheritance. It will make available the
1396  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1397  * the functions of your contract. Note that they will not be pausable by
1398  * simply including this module, only once the modifiers are put in place.
1399  */
1400 abstract contract Pausable is Context {
1401     /**
1402      * @dev Emitted when the pause is triggered by `account`.
1403      */
1404     event Paused(address account);
1405 
1406     /**
1407      * @dev Emitted when the pause is lifted by `account`.
1408      */
1409     event Unpaused(address account);
1410 
1411     bool private _paused;
1412 
1413     /**
1414      * @dev Initializes the contract in unpaused state.
1415      */
1416     constructor () internal {
1417         _paused = false;
1418     }
1419 
1420     /**
1421      * @dev Returns true if the contract is paused, and false otherwise.
1422      */
1423     function paused() public view virtual returns (bool) {
1424         return _paused;
1425     }
1426 
1427     /**
1428      * @dev Modifier to make a function callable only when the contract is not paused.
1429      *
1430      * Requirements:
1431      *
1432      * - The contract must not be paused.
1433      */
1434     modifier whenNotPaused() {
1435         require(!paused(), "Pausable: paused");
1436         _;
1437     }
1438 
1439     /**
1440      * @dev Modifier to make a function callable only when the contract is paused.
1441      *
1442      * Requirements:
1443      *
1444      * - The contract must be paused.
1445      */
1446     modifier whenPaused() {
1447         require(paused(), "Pausable: not paused");
1448         _;
1449     }
1450 
1451     /**
1452      * @dev Triggers stopped state.
1453      *
1454      * Requirements:
1455      *
1456      * - The contract must not be paused.
1457      */
1458     function _pause() internal virtual whenNotPaused {
1459         _paused = true;
1460         emit Paused(_msgSender());
1461     }
1462 
1463     /**
1464      * @dev Returns to normal state.
1465      *
1466      * Requirements:
1467      *
1468      * - The contract must be paused.
1469      */
1470     function _unpause() internal virtual whenPaused {
1471         _paused = false;
1472         emit Unpaused(_msgSender());
1473     }
1474 }
1475 
1476 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
1477 
1478 
1479 
1480 pragma solidity >=0.6.0 <0.8.0;
1481 
1482 
1483 
1484 /**
1485  * @dev ERC20 token with pausable token transfers, minting and burning.
1486  *
1487  * Useful for scenarios such as preventing trades until the end of an evaluation
1488  * period, or having an emergency switch for freezing all token transfers in the
1489  * event of a large bug.
1490  */
1491 abstract contract ERC20Pausable is ERC20, Pausable {
1492     /**
1493      * @dev See {ERC20-_beforeTokenTransfer}.
1494      *
1495      * Requirements:
1496      *
1497      * - the contract must not be paused.
1498      */
1499     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1500         super._beforeTokenTransfer(from, to, amount);
1501 
1502         require(!paused(), "ERC20Pausable: token transfer while paused");
1503     }
1504 }
1505 
1506 // File: @openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol
1507 
1508 
1509 
1510 pragma solidity >=0.6.0 <0.8.0;
1511 
1512 
1513 
1514 
1515 
1516 
1517 /**
1518  * @dev {ERC20} token, including:
1519  *
1520  *  - ability for holders to burn (destroy) their tokens
1521  *  - a minter role that allows for token minting (creation)
1522  *  - a pauser role that allows to stop all token transfers
1523  *
1524  * This contract uses {AccessControl} to lock permissioned functions using the
1525  * different roles - head to its documentation for details.
1526  *
1527  * The account that deploys the contract will be granted the minter and pauser
1528  * roles, as well as the default admin role, which will let it grant both minter
1529  * and pauser roles to other accounts.
1530  */
1531 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1532     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1533     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1534 
1535     /**
1536      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1537      * account that deploys the contract.
1538      *
1539      * See {ERC20-constructor}.
1540      */
1541     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1542         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1543 
1544         _setupRole(MINTER_ROLE, _msgSender());
1545         _setupRole(PAUSER_ROLE, _msgSender());
1546     }
1547 
1548     /**
1549      * @dev Creates `amount` new tokens for `to`.
1550      *
1551      * See {ERC20-_mint}.
1552      *
1553      * Requirements:
1554      *
1555      * - the caller must have the `MINTER_ROLE`.
1556      */
1557     function mint(address to, uint256 amount) public virtual {
1558         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1559         _mint(to, amount);
1560     }
1561 
1562     /**
1563      * @dev Pauses all token transfers.
1564      *
1565      * See {ERC20Pausable} and {Pausable-_pause}.
1566      *
1567      * Requirements:
1568      *
1569      * - the caller must have the `PAUSER_ROLE`.
1570      */
1571     function pause() public virtual {
1572         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1573         _pause();
1574     }
1575 
1576     /**
1577      * @dev Unpauses all token transfers.
1578      *
1579      * See {ERC20Pausable} and {Pausable-_unpause}.
1580      *
1581      * Requirements:
1582      *
1583      * - the caller must have the `PAUSER_ROLE`.
1584      */
1585     function unpause() public virtual {
1586         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1587         _unpause();
1588     }
1589 
1590     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1591         super._beforeTokenTransfer(from, to, amount);
1592     }
1593 }