1 // Sources flattened with hardhat v2.1.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Library for managing
11  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
12  * types.
13  *
14  * Sets have the following properties:
15  *
16  * - Elements are added, removed, and checked for existence in constant time
17  * (O(1)).
18  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
19  *
20  * ```
21  * contract Example {
22  *     // Add the library methods
23  *     using EnumerableSet for EnumerableSet.AddressSet;
24  *
25  *     // Declare a set state variable
26  *     EnumerableSet.AddressSet private mySet;
27  * }
28  * ```
29  *
30  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
31  * and `uint256` (`UintSet`) are supported.
32  */
33 library EnumerableSet {
34     // To implement this library for multiple types with as little code
35     // repetition as possible, we write it in terms of a generic Set type with
36     // bytes32 values.
37     // The Set implementation uses private functions, and user-facing
38     // implementations (such as AddressSet) are just wrappers around the
39     // underlying Set.
40     // This means that we can only create new EnumerableSets for types that fit
41     // in bytes32.
42 
43     struct Set {
44         // Storage of set values
45         bytes32[] _values;
46 
47         // Position of the value in the `values` array, plus 1 because index 0
48         // means a value is not in the set.
49         mapping (bytes32 => uint256) _indexes;
50     }
51 
52     /**
53      * @dev Add a value to a set. O(1).
54      *
55      * Returns true if the value was added to the set, that is if it was not
56      * already present.
57      */
58     function _add(Set storage set, bytes32 value) private returns (bool) {
59         if (!_contains(set, value)) {
60             set._values.push(value);
61             // The value is stored at length-1, but we add 1 to all indexes
62             // and use 0 as a sentinel value
63             set._indexes[value] = set._values.length;
64             return true;
65         } else {
66             return false;
67         }
68     }
69 
70     /**
71      * @dev Removes a value from a set. O(1).
72      *
73      * Returns true if the value was removed from the set, that is if it was
74      * present.
75      */
76     function _remove(Set storage set, bytes32 value) private returns (bool) {
77         // We read and store the value's index to prevent multiple reads from the same storage slot
78         uint256 valueIndex = set._indexes[value];
79 
80         if (valueIndex != 0) { // Equivalent to contains(set, value)
81             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
82             // the array, and then remove the last element (sometimes called as 'swap and pop').
83             // This modifies the order of the array, as noted in {at}.
84 
85             uint256 toDeleteIndex = valueIndex - 1;
86             uint256 lastIndex = set._values.length - 1;
87 
88             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
89             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
90 
91             bytes32 lastvalue = set._values[lastIndex];
92 
93             // Move the last value to the index where the value to delete is
94             set._values[toDeleteIndex] = lastvalue;
95             // Update the index for the moved value
96             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
97 
98             // Delete the slot where the moved value was stored
99             set._values.pop();
100 
101             // Delete the index for the deleted slot
102             delete set._indexes[value];
103 
104             return true;
105         } else {
106             return false;
107         }
108     }
109 
110     /**
111      * @dev Returns true if the value is in the set. O(1).
112      */
113     function _contains(Set storage set, bytes32 value) private view returns (bool) {
114         return set._indexes[value] != 0;
115     }
116 
117     /**
118      * @dev Returns the number of values on the set. O(1).
119      */
120     function _length(Set storage set) private view returns (uint256) {
121         return set._values.length;
122     }
123 
124    /**
125     * @dev Returns the value stored at position `index` in the set. O(1).
126     *
127     * Note that there are no guarantees on the ordering of values inside the
128     * array, and it may change when more values are added or removed.
129     *
130     * Requirements:
131     *
132     * - `index` must be strictly less than {length}.
133     */
134     function _at(Set storage set, uint256 index) private view returns (bytes32) {
135         require(set._values.length > index, "EnumerableSet: index out of bounds");
136         return set._values[index];
137     }
138 
139     // Bytes32Set
140 
141     struct Bytes32Set {
142         Set _inner;
143     }
144 
145     /**
146      * @dev Add a value to a set. O(1).
147      *
148      * Returns true if the value was added to the set, that is if it was not
149      * already present.
150      */
151     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
152         return _add(set._inner, value);
153     }
154 
155     /**
156      * @dev Removes a value from a set. O(1).
157      *
158      * Returns true if the value was removed from the set, that is if it was
159      * present.
160      */
161     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
162         return _remove(set._inner, value);
163     }
164 
165     /**
166      * @dev Returns true if the value is in the set. O(1).
167      */
168     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
169         return _contains(set._inner, value);
170     }
171 
172     /**
173      * @dev Returns the number of values in the set. O(1).
174      */
175     function length(Bytes32Set storage set) internal view returns (uint256) {
176         return _length(set._inner);
177     }
178 
179    /**
180     * @dev Returns the value stored at position `index` in the set. O(1).
181     *
182     * Note that there are no guarantees on the ordering of values inside the
183     * array, and it may change when more values are added or removed.
184     *
185     * Requirements:
186     *
187     * - `index` must be strictly less than {length}.
188     */
189     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
190         return _at(set._inner, index);
191     }
192 
193     // AddressSet
194 
195     struct AddressSet {
196         Set _inner;
197     }
198 
199     /**
200      * @dev Add a value to a set. O(1).
201      *
202      * Returns true if the value was added to the set, that is if it was not
203      * already present.
204      */
205     function add(AddressSet storage set, address value) internal returns (bool) {
206         return _add(set._inner, bytes32(uint256(uint160(value))));
207     }
208 
209     /**
210      * @dev Removes a value from a set. O(1).
211      *
212      * Returns true if the value was removed from the set, that is if it was
213      * present.
214      */
215     function remove(AddressSet storage set, address value) internal returns (bool) {
216         return _remove(set._inner, bytes32(uint256(uint160(value))));
217     }
218 
219     /**
220      * @dev Returns true if the value is in the set. O(1).
221      */
222     function contains(AddressSet storage set, address value) internal view returns (bool) {
223         return _contains(set._inner, bytes32(uint256(uint160(value))));
224     }
225 
226     /**
227      * @dev Returns the number of values in the set. O(1).
228      */
229     function length(AddressSet storage set) internal view returns (uint256) {
230         return _length(set._inner);
231     }
232 
233    /**
234     * @dev Returns the value stored at position `index` in the set. O(1).
235     *
236     * Note that there are no guarantees on the ordering of values inside the
237     * array, and it may change when more values are added or removed.
238     *
239     * Requirements:
240     *
241     * - `index` must be strictly less than {length}.
242     */
243     function at(AddressSet storage set, uint256 index) internal view returns (address) {
244         return address(uint160(uint256(_at(set._inner, index))));
245     }
246 
247 
248     // UintSet
249 
250     struct UintSet {
251         Set _inner;
252     }
253 
254     /**
255      * @dev Add a value to a set. O(1).
256      *
257      * Returns true if the value was added to the set, that is if it was not
258      * already present.
259      */
260     function add(UintSet storage set, uint256 value) internal returns (bool) {
261         return _add(set._inner, bytes32(value));
262     }
263 
264     /**
265      * @dev Removes a value from a set. O(1).
266      *
267      * Returns true if the value was removed from the set, that is if it was
268      * present.
269      */
270     function remove(UintSet storage set, uint256 value) internal returns (bool) {
271         return _remove(set._inner, bytes32(value));
272     }
273 
274     /**
275      * @dev Returns true if the value is in the set. O(1).
276      */
277     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
278         return _contains(set._inner, bytes32(value));
279     }
280 
281     /**
282      * @dev Returns the number of values on the set. O(1).
283      */
284     function length(UintSet storage set) internal view returns (uint256) {
285         return _length(set._inner);
286     }
287 
288    /**
289     * @dev Returns the value stored at position `index` in the set. O(1).
290     *
291     * Note that there are no guarantees on the ordering of values inside the
292     * array, and it may change when more values are added or removed.
293     *
294     * Requirements:
295     *
296     * - `index` must be strictly less than {length}.
297     */
298     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
299         return uint256(_at(set._inner, index));
300     }
301 }
302 
303 
304 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
305 
306 pragma solidity >=0.6.2 <0.8.0;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      */
329     function isContract(address account) internal view returns (bool) {
330         // This method relies on extcodesize, which returns 0 for contracts in
331         // construction, since the code is only stored at the end of the
332         // constructor execution.
333 
334         uint256 size;
335         // solhint-disable-next-line no-inline-assembly
336         assembly { size := extcodesize(account) }
337         return size > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
360         (bool success, ) = recipient.call{ value: amount }("");
361         require(success, "Address: unable to send value, recipient may have reverted");
362     }
363 
364     /**
365      * @dev Performs a Solidity function call using a low level `call`. A
366      * plain`call` is an unsafe replacement for a function call: use this
367      * function instead.
368      *
369      * If `target` reverts with a revert reason, it is bubbled up by this
370      * function (like regular Solidity function calls).
371      *
372      * Returns the raw returned data. To convert to the expected return value,
373      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
374      *
375      * Requirements:
376      *
377      * - `target` must be a contract.
378      * - calling `target` with `data` must not revert.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
383       return functionCall(target, data, "Address: low-level call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
388      * `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, 0, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but also transferring `value` wei to `target`.
399      *
400      * Requirements:
401      *
402      * - the calling contract must have an ETH balance of at least `value`.
403      * - the called Solidity function must be `payable`.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
418         require(address(this).balance >= value, "Address: insufficient balance for call");
419         require(isContract(target), "Address: call to non-contract");
420 
421         // solhint-disable-next-line avoid-low-level-calls
422         (bool success, bytes memory returndata) = target.call{ value: value }(data);
423         return _verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
433         return functionStaticCall(target, data, "Address: low-level static call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
443         require(isContract(target), "Address: static call to non-contract");
444 
445         // solhint-disable-next-line avoid-low-level-calls
446         (bool success, bytes memory returndata) = target.staticcall(data);
447         return _verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
457         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
467         require(isContract(target), "Address: delegate call to non-contract");
468 
469         // solhint-disable-next-line avoid-low-level-calls
470         (bool success, bytes memory returndata) = target.delegatecall(data);
471         return _verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481 
482                 // solhint-disable-next-line no-inline-assembly
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 
495 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
496 
497 pragma solidity >=0.6.0 <0.8.0;
498 
499 /*
500  * @dev Provides information about the current execution context, including the
501  * sender of the transaction and its data. While these are generally available
502  * via msg.sender and msg.data, they should not be accessed in such a direct
503  * manner, since when dealing with GSN meta-transactions the account sending and
504  * paying for execution may not be the actual sender (as far as an application
505  * is concerned).
506  *
507  * This contract is only required for intermediate, library-like contracts.
508  */
509 abstract contract Context {
510     function _msgSender() internal view virtual returns (address payable) {
511         return msg.sender;
512     }
513 
514     function _msgData() internal view virtual returns (bytes memory) {
515         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
516         return msg.data;
517     }
518 }
519 
520 
521 // File @openzeppelin/contracts/access/AccessControl.sol@v3.4.1
522 
523 pragma solidity >=0.6.0 <0.8.0;
524 
525 
526 
527 /**
528  * @dev Contract module that allows children to implement role-based access
529  * control mechanisms.
530  *
531  * Roles are referred to by their `bytes32` identifier. These should be exposed
532  * in the external API and be unique. The best way to achieve this is by
533  * using `public constant` hash digests:
534  *
535  * ```
536  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
537  * ```
538  *
539  * Roles can be used to represent a set of permissions. To restrict access to a
540  * function call, use {hasRole}:
541  *
542  * ```
543  * function foo() public {
544  *     require(hasRole(MY_ROLE, msg.sender));
545  *     ...
546  * }
547  * ```
548  *
549  * Roles can be granted and revoked dynamically via the {grantRole} and
550  * {revokeRole} functions. Each role has an associated admin role, and only
551  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
552  *
553  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
554  * that only accounts with this role will be able to grant or revoke other
555  * roles. More complex role relationships can be created by using
556  * {_setRoleAdmin}.
557  *
558  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
559  * grant and revoke this role. Extra precautions should be taken to secure
560  * accounts that have been granted it.
561  */
562 abstract contract AccessControl is Context {
563     using EnumerableSet for EnumerableSet.AddressSet;
564     using Address for address;
565 
566     struct RoleData {
567         EnumerableSet.AddressSet members;
568         bytes32 adminRole;
569     }
570 
571     mapping (bytes32 => RoleData) private _roles;
572 
573     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
574 
575     /**
576      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
577      *
578      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
579      * {RoleAdminChanged} not being emitted signaling this.
580      *
581      * _Available since v3.1._
582      */
583     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
584 
585     /**
586      * @dev Emitted when `account` is granted `role`.
587      *
588      * `sender` is the account that originated the contract call, an admin role
589      * bearer except when using {_setupRole}.
590      */
591     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
592 
593     /**
594      * @dev Emitted when `account` is revoked `role`.
595      *
596      * `sender` is the account that originated the contract call:
597      *   - if using `revokeRole`, it is the admin role bearer
598      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
599      */
600     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
601 
602     /**
603      * @dev Returns `true` if `account` has been granted `role`.
604      */
605     function hasRole(bytes32 role, address account) public view returns (bool) {
606         return _roles[role].members.contains(account);
607     }
608 
609     /**
610      * @dev Returns the number of accounts that have `role`. Can be used
611      * together with {getRoleMember} to enumerate all bearers of a role.
612      */
613     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
614         return _roles[role].members.length();
615     }
616 
617     /**
618      * @dev Returns one of the accounts that have `role`. `index` must be a
619      * value between 0 and {getRoleMemberCount}, non-inclusive.
620      *
621      * Role bearers are not sorted in any particular way, and their ordering may
622      * change at any point.
623      *
624      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
625      * you perform all queries on the same block. See the following
626      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
627      * for more information.
628      */
629     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
630         return _roles[role].members.at(index);
631     }
632 
633     /**
634      * @dev Returns the admin role that controls `role`. See {grantRole} and
635      * {revokeRole}.
636      *
637      * To change a role's admin, use {_setRoleAdmin}.
638      */
639     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
640         return _roles[role].adminRole;
641     }
642 
643     /**
644      * @dev Grants `role` to `account`.
645      *
646      * If `account` had not been already granted `role`, emits a {RoleGranted}
647      * event.
648      *
649      * Requirements:
650      *
651      * - the caller must have ``role``'s admin role.
652      */
653     function grantRole(bytes32 role, address account) public virtual {
654         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
655 
656         _grantRole(role, account);
657     }
658 
659     /**
660      * @dev Revokes `role` from `account`.
661      *
662      * If `account` had been granted `role`, emits a {RoleRevoked} event.
663      *
664      * Requirements:
665      *
666      * - the caller must have ``role``'s admin role.
667      */
668     function revokeRole(bytes32 role, address account) public virtual {
669         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
670 
671         _revokeRole(role, account);
672     }
673 
674     /**
675      * @dev Revokes `role` from the calling account.
676      *
677      * Roles are often managed via {grantRole} and {revokeRole}: this function's
678      * purpose is to provide a mechanism for accounts to lose their privileges
679      * if they are compromised (such as when a trusted device is misplaced).
680      *
681      * If the calling account had been granted `role`, emits a {RoleRevoked}
682      * event.
683      *
684      * Requirements:
685      *
686      * - the caller must be `account`.
687      */
688     function renounceRole(bytes32 role, address account) public virtual {
689         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
690 
691         _revokeRole(role, account);
692     }
693 
694     /**
695      * @dev Grants `role` to `account`.
696      *
697      * If `account` had not been already granted `role`, emits a {RoleGranted}
698      * event. Note that unlike {grantRole}, this function doesn't perform any
699      * checks on the calling account.
700      *
701      * [WARNING]
702      * ====
703      * This function should only be called from the constructor when setting
704      * up the initial roles for the system.
705      *
706      * Using this function in any other way is effectively circumventing the admin
707      * system imposed by {AccessControl}.
708      * ====
709      */
710     function _setupRole(bytes32 role, address account) internal virtual {
711         _grantRole(role, account);
712     }
713 
714     /**
715      * @dev Sets `adminRole` as ``role``'s admin role.
716      *
717      * Emits a {RoleAdminChanged} event.
718      */
719     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
720         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
721         _roles[role].adminRole = adminRole;
722     }
723 
724     function _grantRole(bytes32 role, address account) private {
725         if (_roles[role].members.add(account)) {
726             emit RoleGranted(role, account, _msgSender());
727         }
728     }
729 
730     function _revokeRole(bytes32 role, address account) private {
731         if (_roles[role].members.remove(account)) {
732             emit RoleRevoked(role, account, _msgSender());
733         }
734     }
735 }
736 
737 
738 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
739 
740 pragma solidity >=0.6.0 <0.8.0;
741 
742 /**
743  * @dev Interface of the ERC20 standard as defined in the EIP.
744  */
745 interface IERC20 {
746     /**
747      * @dev Returns the amount of tokens in existence.
748      */
749     function totalSupply() external view returns (uint256);
750 
751     /**
752      * @dev Returns the amount of tokens owned by `account`.
753      */
754     function balanceOf(address account) external view returns (uint256);
755 
756     /**
757      * @dev Moves `amount` tokens from the caller's account to `recipient`.
758      *
759      * Returns a boolean value indicating whether the operation succeeded.
760      *
761      * Emits a {Transfer} event.
762      */
763     function transfer(address recipient, uint256 amount) external returns (bool);
764 
765     /**
766      * @dev Returns the remaining number of tokens that `spender` will be
767      * allowed to spend on behalf of `owner` through {transferFrom}. This is
768      * zero by default.
769      *
770      * This value changes when {approve} or {transferFrom} are called.
771      */
772     function allowance(address owner, address spender) external view returns (uint256);
773 
774     /**
775      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
776      *
777      * Returns a boolean value indicating whether the operation succeeded.
778      *
779      * IMPORTANT: Beware that changing an allowance with this method brings the risk
780      * that someone may use both the old and the new allowance by unfortunate
781      * transaction ordering. One possible solution to mitigate this race
782      * condition is to first reduce the spender's allowance to 0 and set the
783      * desired value afterwards:
784      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
785      *
786      * Emits an {Approval} event.
787      */
788     function approve(address spender, uint256 amount) external returns (bool);
789 
790     /**
791      * @dev Moves `amount` tokens from `sender` to `recipient` using the
792      * allowance mechanism. `amount` is then deducted from the caller's
793      * allowance.
794      *
795      * Returns a boolean value indicating whether the operation succeeded.
796      *
797      * Emits a {Transfer} event.
798      */
799     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
800 
801     /**
802      * @dev Emitted when `value` tokens are moved from one account (`from`) to
803      * another (`to`).
804      *
805      * Note that `value` may be zero.
806      */
807     event Transfer(address indexed from, address indexed to, uint256 value);
808 
809     /**
810      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
811      * a call to {approve}. `value` is the new allowance.
812      */
813     event Approval(address indexed owner, address indexed spender, uint256 value);
814 }
815 
816 
817 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
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
1032 
1033 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
1034 
1035 pragma solidity >=0.6.0 <0.8.0;
1036 
1037 
1038 
1039 /**
1040  * @dev Implementation of the {IERC20} interface.
1041  *
1042  * This implementation is agnostic to the way tokens are created. This means
1043  * that a supply mechanism has to be added in a derived contract using {_mint}.
1044  * For a generic mechanism see {ERC20PresetMinterPauser}.
1045  *
1046  * TIP: For a detailed writeup see our guide
1047  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1048  * to implement supply mechanisms].
1049  *
1050  * We have followed general OpenZeppelin guidelines: functions revert instead
1051  * of returning `false` on failure. This behavior is nonetheless conventional
1052  * and does not conflict with the expectations of ERC20 applications.
1053  *
1054  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1055  * This allows applications to reconstruct the allowance for all accounts just
1056  * by listening to said events. Other implementations of the EIP may not emit
1057  * these events, as it isn't required by the specification.
1058  *
1059  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1060  * functions have been added to mitigate the well-known issues around setting
1061  * allowances. See {IERC20-approve}.
1062  */
1063 contract ERC20 is Context, IERC20 {
1064     using SafeMath for uint256;
1065 
1066     mapping (address => uint256) private _balances;
1067 
1068     mapping (address => mapping (address => uint256)) private _allowances;
1069 
1070     uint256 private _totalSupply;
1071 
1072     string private _name;
1073     string private _symbol;
1074     uint8 private _decimals;
1075 
1076     /**
1077      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1078      * a default value of 18.
1079      *
1080      * To select a different value for {decimals}, use {_setupDecimals}.
1081      *
1082      * All three of these values are immutable: they can only be set once during
1083      * construction.
1084      */
1085     constructor (string memory name_, string memory symbol_) public {
1086         _name = name_;
1087         _symbol = symbol_;
1088         _decimals = 18;
1089     }
1090 
1091     /**
1092      * @dev Returns the name of the token.
1093      */
1094     function name() public view virtual returns (string memory) {
1095         return _name;
1096     }
1097 
1098     /**
1099      * @dev Returns the symbol of the token, usually a shorter version of the
1100      * name.
1101      */
1102     function symbol() public view virtual returns (string memory) {
1103         return _symbol;
1104     }
1105 
1106     /**
1107      * @dev Returns the number of decimals used to get its user representation.
1108      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1109      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1110      *
1111      * Tokens usually opt for a value of 18, imitating the relationship between
1112      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1113      * called.
1114      *
1115      * NOTE: This information is only used for _display_ purposes: it in
1116      * no way affects any of the arithmetic of the contract, including
1117      * {IERC20-balanceOf} and {IERC20-transfer}.
1118      */
1119     function decimals() public view virtual returns (uint8) {
1120         return _decimals;
1121     }
1122 
1123     /**
1124      * @dev See {IERC20-totalSupply}.
1125      */
1126     function totalSupply() public view virtual override returns (uint256) {
1127         return _totalSupply;
1128     }
1129 
1130     /**
1131      * @dev See {IERC20-balanceOf}.
1132      */
1133     function balanceOf(address account) public view virtual override returns (uint256) {
1134         return _balances[account];
1135     }
1136 
1137     /**
1138      * @dev See {IERC20-transfer}.
1139      *
1140      * Requirements:
1141      *
1142      * - `recipient` cannot be the zero address.
1143      * - the caller must have a balance of at least `amount`.
1144      */
1145     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1146         _transfer(_msgSender(), recipient, amount);
1147         return true;
1148     }
1149 
1150     /**
1151      * @dev See {IERC20-allowance}.
1152      */
1153     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1154         return _allowances[owner][spender];
1155     }
1156 
1157     /**
1158      * @dev See {IERC20-approve}.
1159      *
1160      * Requirements:
1161      *
1162      * - `spender` cannot be the zero address.
1163      */
1164     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1165         _approve(_msgSender(), spender, amount);
1166         return true;
1167     }
1168 
1169     /**
1170      * @dev See {IERC20-transferFrom}.
1171      *
1172      * Emits an {Approval} event indicating the updated allowance. This is not
1173      * required by the EIP. See the note at the beginning of {ERC20}.
1174      *
1175      * Requirements:
1176      *
1177      * - `sender` and `recipient` cannot be the zero address.
1178      * - `sender` must have a balance of at least `amount`.
1179      * - the caller must have allowance for ``sender``'s tokens of at least
1180      * `amount`.
1181      */
1182     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1183         _transfer(sender, recipient, amount);
1184         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1185         return true;
1186     }
1187 
1188     /**
1189      * @dev Atomically increases the allowance granted to `spender` by the caller.
1190      *
1191      * This is an alternative to {approve} that can be used as a mitigation for
1192      * problems described in {IERC20-approve}.
1193      *
1194      * Emits an {Approval} event indicating the updated allowance.
1195      *
1196      * Requirements:
1197      *
1198      * - `spender` cannot be the zero address.
1199      */
1200     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1201         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1202         return true;
1203     }
1204 
1205     /**
1206      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1207      *
1208      * This is an alternative to {approve} that can be used as a mitigation for
1209      * problems described in {IERC20-approve}.
1210      *
1211      * Emits an {Approval} event indicating the updated allowance.
1212      *
1213      * Requirements:
1214      *
1215      * - `spender` cannot be the zero address.
1216      * - `spender` must have allowance for the caller of at least
1217      * `subtractedValue`.
1218      */
1219     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1220         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1221         return true;
1222     }
1223 
1224     /**
1225      * @dev Moves tokens `amount` from `sender` to `recipient`.
1226      *
1227      * This is internal function is equivalent to {transfer}, and can be used to
1228      * e.g. implement automatic token fees, slashing mechanisms, etc.
1229      *
1230      * Emits a {Transfer} event.
1231      *
1232      * Requirements:
1233      *
1234      * - `sender` cannot be the zero address.
1235      * - `recipient` cannot be the zero address.
1236      * - `sender` must have a balance of at least `amount`.
1237      */
1238     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1239         require(sender != address(0), "ERC20: transfer from the zero address");
1240         require(recipient != address(0), "ERC20: transfer to the zero address");
1241 
1242         _beforeTokenTransfer(sender, recipient, amount);
1243 
1244         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1245         _balances[recipient] = _balances[recipient].add(amount);
1246         emit Transfer(sender, recipient, amount);
1247     }
1248 
1249     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1250      * the total supply.
1251      *
1252      * Emits a {Transfer} event with `from` set to the zero address.
1253      *
1254      * Requirements:
1255      *
1256      * - `to` cannot be the zero address.
1257      */
1258     function _mint(address account, uint256 amount) internal virtual {
1259         require(account != address(0), "ERC20: mint to the zero address");
1260 
1261         _beforeTokenTransfer(address(0), account, amount);
1262 
1263         _totalSupply = _totalSupply.add(amount);
1264         _balances[account] = _balances[account].add(amount);
1265         emit Transfer(address(0), account, amount);
1266     }
1267 
1268     /**
1269      * @dev Destroys `amount` tokens from `account`, reducing the
1270      * total supply.
1271      *
1272      * Emits a {Transfer} event with `to` set to the zero address.
1273      *
1274      * Requirements:
1275      *
1276      * - `account` cannot be the zero address.
1277      * - `account` must have at least `amount` tokens.
1278      */
1279     function _burn(address account, uint256 amount) internal virtual {
1280         require(account != address(0), "ERC20: burn from the zero address");
1281 
1282         _beforeTokenTransfer(account, address(0), amount);
1283 
1284         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1285         _totalSupply = _totalSupply.sub(amount);
1286         emit Transfer(account, address(0), amount);
1287     }
1288 
1289     /**
1290      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1291      *
1292      * This internal function is equivalent to `approve`, and can be used to
1293      * e.g. set automatic allowances for certain subsystems, etc.
1294      *
1295      * Emits an {Approval} event.
1296      *
1297      * Requirements:
1298      *
1299      * - `owner` cannot be the zero address.
1300      * - `spender` cannot be the zero address.
1301      */
1302     function _approve(address owner, address spender, uint256 amount) internal virtual {
1303         require(owner != address(0), "ERC20: approve from the zero address");
1304         require(spender != address(0), "ERC20: approve to the zero address");
1305 
1306         _allowances[owner][spender] = amount;
1307         emit Approval(owner, spender, amount);
1308     }
1309 
1310     /**
1311      * @dev Sets {decimals} to a value other than the default one of 18.
1312      *
1313      * WARNING: This function should only be called from the constructor. Most
1314      * applications that interact with token contracts will not expect
1315      * {decimals} to ever change, and may work incorrectly if it does.
1316      */
1317     function _setupDecimals(uint8 decimals_) internal virtual {
1318         _decimals = decimals_;
1319     }
1320 
1321     /**
1322      * @dev Hook that is called before any transfer of tokens. This includes
1323      * minting and burning.
1324      *
1325      * Calling conditions:
1326      *
1327      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1328      * will be to transferred to `to`.
1329      * - when `from` is zero, `amount` tokens will be minted for `to`.
1330      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1331      * - `from` and `to` are never both zero.
1332      *
1333      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1334      */
1335     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1336 }
1337 
1338 
1339 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
1340 
1341 pragma solidity >=0.6.0 <0.8.0;
1342 
1343 /**
1344  * @dev Contract module which provides a basic access control mechanism, where
1345  * there is an account (an owner) that can be granted exclusive access to
1346  * specific functions.
1347  *
1348  * By default, the owner account will be the one that deploys the contract. This
1349  * can later be changed with {transferOwnership}.
1350  *
1351  * This module is used through inheritance. It will make available the modifier
1352  * `onlyOwner`, which can be applied to your functions to restrict their use to
1353  * the owner.
1354  */
1355 abstract contract Ownable is Context {
1356     address private _owner;
1357 
1358     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1359 
1360     /**
1361      * @dev Initializes the contract setting the deployer as the initial owner.
1362      */
1363     constructor () internal {
1364         address msgSender = _msgSender();
1365         _owner = msgSender;
1366         emit OwnershipTransferred(address(0), msgSender);
1367     }
1368 
1369     /**
1370      * @dev Returns the address of the current owner.
1371      */
1372     function owner() public view virtual returns (address) {
1373         return _owner;
1374     }
1375 
1376     /**
1377      * @dev Throws if called by any account other than the owner.
1378      */
1379     modifier onlyOwner() {
1380         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1381         _;
1382     }
1383 
1384     /**
1385      * @dev Leaves the contract without owner. It will not be possible to call
1386      * `onlyOwner` functions anymore. Can only be called by the current owner.
1387      *
1388      * NOTE: Renouncing ownership will leave the contract without an owner,
1389      * thereby removing any functionality that is only available to the owner.
1390      */
1391     function renounceOwnership() public virtual onlyOwner {
1392         emit OwnershipTransferred(_owner, address(0));
1393         _owner = address(0);
1394     }
1395 
1396     /**
1397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1398      * Can only be called by the current owner.
1399      */
1400     function transferOwnership(address newOwner) public virtual onlyOwner {
1401         require(newOwner != address(0), "Ownable: new owner is the zero address");
1402         emit OwnershipTransferred(_owner, newOwner);
1403         _owner = newOwner;
1404     }
1405 }
1406 
1407 
1408 // File contracts/interfaces/IDetailedERC20.sol
1409 
1410 pragma solidity ^0.6.12;
1411 
1412 interface IDetailedERC20 is IERC20 {
1413   function name() external returns (string memory);
1414   function symbol() external returns (string memory);
1415   function decimals() external returns (uint8);
1416 }
1417 
1418 
1419 // File contracts/WasabiToken.sol
1420 
1421 pragma solidity ^0.6.12;
1422 pragma experimental ABIEncoderV2;
1423 
1424 
1425 
1426 /// @title WasabiToken
1427 ///
1428 /// @dev This is the contract for the Wasabi governance token.
1429 ///
1430 /// Initially, the contract deployer is given both the admin and minter role. This allows them to pre-mine tokens,
1431 /// transfer admin to a timelock contract, and lastly, grant the staking pools the minter role. After this is done,
1432 /// the deployer must revoke their admin role and minter role.
1433 contract WasabiToken is AccessControl, ERC20("Wasabi", "WASABI") {
1434 
1435   /// @dev The identifier of the role which maintains other roles.
1436   bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
1437 
1438   /// @dev The identifier of the role which allows accounts to mint tokens.
1439   bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1440 
1441   constructor() public {
1442     _setupRole(ADMIN_ROLE, msg.sender);
1443     _setupRole(MINTER_ROLE, msg.sender);
1444     _setRoleAdmin(MINTER_ROLE, ADMIN_ROLE);
1445     _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
1446   }
1447 
1448   /// @dev A modifier which checks that the caller has the minter role.
1449   modifier onlyMinter() {
1450     require(hasRole(MINTER_ROLE, msg.sender), "WasabiToken: only minter");
1451     _;
1452   }
1453 
1454   /// @dev Mints tokens to a recipient.
1455   ///
1456   /// This function reverts if the caller does not have the minter role.
1457   ///
1458   /// @param _recipient the account to mint tokens to.
1459   /// @param _amount    the amount of tokens to mint.
1460   function mint(address _recipient, uint256 _amount) external onlyMinter {
1461     _mint(_recipient, _amount);
1462   }
1463 }