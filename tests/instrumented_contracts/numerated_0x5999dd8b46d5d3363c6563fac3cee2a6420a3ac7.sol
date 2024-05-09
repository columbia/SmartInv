1 // SPDX-License-Identifier: UNLICENSED
2 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
3 
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
204         return _add(set._inner, bytes32(uint256(value)));
205     }
206 
207     /**
208      * @dev Removes a value from a set. O(1).
209      *
210      * Returns true if the value was removed from the set, that is if it was
211      * present.
212      */
213     function remove(AddressSet storage set, address value) internal returns (bool) {
214         return _remove(set._inner, bytes32(uint256(value)));
215     }
216 
217     /**
218      * @dev Returns true if the value is in the set. O(1).
219      */
220     function contains(AddressSet storage set, address value) internal view returns (bool) {
221         return _contains(set._inner, bytes32(uint256(value)));
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
242         return address(uint256(_at(set._inner, index)));
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
303 
304 pragma solidity >=0.6.2 <0.8.0;
305 
306 /**
307  * @dev Collection of functions related to the address type
308  */
309 library Address {
310     /**
311      * @dev Returns true if `account` is a contract.
312      *
313      * [IMPORTANT]
314      * ====
315      * It is unsafe to assume that an address for which this function returns
316      * false is an externally-owned account (EOA) and not a contract.
317      *
318      * Among others, `isContract` will return false for the following
319      * types of addresses:
320      *
321      *  - an externally-owned account
322      *  - a contract in construction
323      *  - an address where a contract will be created
324      *  - an address where a contract lived, but was destroyed
325      * ====
326      */
327     function isContract(address account) internal view returns (bool) {
328         // This method relies on extcodesize, which returns 0 for contracts in
329         // construction, since the code is only stored at the end of the
330         // constructor execution.
331 
332         uint256 size;
333         // solhint-disable-next-line no-inline-assembly
334         assembly { size := extcodesize(account) }
335         return size > 0;
336     }
337 
338     /**
339      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
340      * `recipient`, forwarding all available gas and reverting on errors.
341      *
342      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
343      * of certain opcodes, possibly making contracts go over the 2300 gas limit
344      * imposed by `transfer`, making them unable to receive funds via
345      * `transfer`. {sendValue} removes this limitation.
346      *
347      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
348      *
349      * IMPORTANT: because control is transferred to `recipient`, care must be
350      * taken to not create reentrancy vulnerabilities. Consider using
351      * {ReentrancyGuard} or the
352      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
353      */
354     function sendValue(address payable recipient, uint256 amount) internal {
355         require(address(this).balance >= amount, "Address: insufficient balance");
356 
357         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
358         (bool success, ) = recipient.call{ value: amount }("");
359         require(success, "Address: unable to send value, recipient may have reverted");
360     }
361 
362     /**
363      * @dev Performs a Solidity function call using a low level `call`. A
364      * plain`call` is an unsafe replacement for a function call: use this
365      * function instead.
366      *
367      * If `target` reverts with a revert reason, it is bubbled up by this
368      * function (like regular Solidity function calls).
369      *
370      * Returns the raw returned data. To convert to the expected return value,
371      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
372      *
373      * Requirements:
374      *
375      * - `target` must be a contract.
376      * - calling `target` with `data` must not revert.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
381       return functionCall(target, data, "Address: low-level call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
386      * `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
391         return functionCallWithValue(target, data, 0, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but also transferring `value` wei to `target`.
397      *
398      * Requirements:
399      *
400      * - the calling contract must have an ETH balance of at least `value`.
401      * - the called Solidity function must be `payable`.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
411      * with `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
416         require(address(this).balance >= value, "Address: insufficient balance for call");
417         require(isContract(target), "Address: call to non-contract");
418 
419         // solhint-disable-next-line avoid-low-level-calls
420         (bool success, bytes memory returndata) = target.call{ value: value }(data);
421         return _verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a static call.
427      *
428      * _Available since v3.3._
429      */
430     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
431         return functionStaticCall(target, data, "Address: low-level static call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a static call.
437      *
438      * _Available since v3.3._
439      */
440     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
441         require(isContract(target), "Address: static call to non-contract");
442 
443         // solhint-disable-next-line avoid-low-level-calls
444         (bool success, bytes memory returndata) = target.staticcall(data);
445         return _verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 // solhint-disable-next-line no-inline-assembly
457                 assembly {
458                     let returndata_size := mload(returndata)
459                     revert(add(32, returndata), returndata_size)
460                 }
461             } else {
462                 revert(errorMessage);
463             }
464         }
465     }
466 }
467 
468 // File: @openzeppelin/contracts/GSN/Context.sol
469 
470 
471 pragma solidity >=0.6.0 <0.8.0;
472 
473 /*
474  * @dev Provides information about the current execution context, including the
475  * sender of the transaction and its data. While these are generally available
476  * via msg.sender and msg.data, they should not be accessed in such a direct
477  * manner, since when dealing with GSN meta-transactions the account sending and
478  * paying for execution may not be the actual sender (as far as an application
479  * is concerned).
480  *
481  * This contract is only required for intermediate, library-like contracts.
482  */
483 abstract contract Context {
484     function _msgSender() internal view virtual returns (address payable) {
485         return msg.sender;
486     }
487 
488     function _msgData() internal view virtual returns (bytes memory) {
489         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
490         return msg.data;
491     }
492 }
493 
494 // File: @openzeppelin/contracts/access/AccessControl.sol
495 
496 
497 pragma solidity >=0.6.0 <0.8.0;
498 
499 
500 
501 
502 /**
503  * @dev Contract module that allows children to implement role-based access
504  * control mechanisms.
505  *
506  * Roles are referred to by their `bytes32` identifier. These should be exposed
507  * in the external API and be unique. The best way to achieve this is by
508  * using `public constant` hash digests:
509  *
510  * ```
511  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
512  * ```
513  *
514  * Roles can be used to represent a set of permissions. To restrict access to a
515  * function call, use {hasRole}:
516  *
517  * ```
518  * function foo() public {
519  *     require(hasRole(MY_ROLE, msg.sender));
520  *     ...
521  * }
522  * ```
523  *
524  * Roles can be granted and revoked dynamically via the {grantRole} and
525  * {revokeRole} functions. Each role has an associated admin role, and only
526  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
527  *
528  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
529  * that only accounts with this role will be able to grant or revoke other
530  * roles. More complex role relationships can be created by using
531  * {_setRoleAdmin}.
532  *
533  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
534  * grant and revoke this role. Extra precautions should be taken to secure
535  * accounts that have been granted it.
536  */
537 abstract contract AccessControl is Context {
538     using EnumerableSet for EnumerableSet.AddressSet;
539     using Address for address;
540 
541     struct RoleData {
542         EnumerableSet.AddressSet members;
543         bytes32 adminRole;
544     }
545 
546     mapping (bytes32 => RoleData) private _roles;
547 
548     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
549 
550     /**
551      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
552      *
553      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
554      * {RoleAdminChanged} not being emitted signaling this.
555      *
556      * _Available since v3.1._
557      */
558     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
559 
560     /**
561      * @dev Emitted when `account` is granted `role`.
562      *
563      * `sender` is the account that originated the contract call, an admin role
564      * bearer except when using {_setupRole}.
565      */
566     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
567 
568     /**
569      * @dev Emitted when `account` is revoked `role`.
570      *
571      * `sender` is the account that originated the contract call:
572      *   - if using `revokeRole`, it is the admin role bearer
573      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
574      */
575     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
576 
577     /**
578      * @dev Returns `true` if `account` has been granted `role`.
579      */
580     function hasRole(bytes32 role, address account) public view returns (bool) {
581         return _roles[role].members.contains(account);
582     }
583 
584     /**
585      * @dev Returns the number of accounts that have `role`. Can be used
586      * together with {getRoleMember} to enumerate all bearers of a role.
587      */
588     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
589         return _roles[role].members.length();
590     }
591 
592     /**
593      * @dev Returns one of the accounts that have `role`. `index` must be a
594      * value between 0 and {getRoleMemberCount}, non-inclusive.
595      *
596      * Role bearers are not sorted in any particular way, and their ordering may
597      * change at any point.
598      *
599      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
600      * you perform all queries on the same block. See the following
601      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
602      * for more information.
603      */
604     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
605         return _roles[role].members.at(index);
606     }
607 
608     /**
609      * @dev Returns the admin role that controls `role`. See {grantRole} and
610      * {revokeRole}.
611      *
612      * To change a role's admin, use {_setRoleAdmin}.
613      */
614     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
615         return _roles[role].adminRole;
616     }
617 
618     /**
619      * @dev Grants `role` to `account`.
620      *
621      * If `account` had not been already granted `role`, emits a {RoleGranted}
622      * event.
623      *
624      * Requirements:
625      *
626      * - the caller must have ``role``'s admin role.
627      */
628     function grantRole(bytes32 role, address account) public virtual {
629         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
630 
631         _grantRole(role, account);
632     }
633 
634     /**
635      * @dev Revokes `role` from `account`.
636      *
637      * If `account` had been granted `role`, emits a {RoleRevoked} event.
638      *
639      * Requirements:
640      *
641      * - the caller must have ``role``'s admin role.
642      */
643     function revokeRole(bytes32 role, address account) public virtual {
644         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
645 
646         _revokeRole(role, account);
647     }
648 
649     /**
650      * @dev Revokes `role` from the calling account.
651      *
652      * Roles are often managed via {grantRole} and {revokeRole}: this function's
653      * purpose is to provide a mechanism for accounts to lose their privileges
654      * if they are compromised (such as when a trusted device is misplaced).
655      *
656      * If the calling account had been granted `role`, emits a {RoleRevoked}
657      * event.
658      *
659      * Requirements:
660      *
661      * - the caller must be `account`.
662      */
663     function renounceRole(bytes32 role, address account) public virtual {
664         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
665 
666         _revokeRole(role, account);
667     }
668 
669     /**
670      * @dev Grants `role` to `account`.
671      *
672      * If `account` had not been already granted `role`, emits a {RoleGranted}
673      * event. Note that unlike {grantRole}, this function doesn't perform any
674      * checks on the calling account.
675      *
676      * [WARNING]
677      * ====
678      * This function should only be called from the constructor when setting
679      * up the initial roles for the system.
680      *
681      * Using this function in any other way is effectively circumventing the admin
682      * system imposed by {AccessControl}.
683      * ====
684      */
685     function _setupRole(bytes32 role, address account) internal virtual {
686         _grantRole(role, account);
687     }
688 
689     /**
690      * @dev Sets `adminRole` as ``role``'s admin role.
691      *
692      * Emits a {RoleAdminChanged} event.
693      */
694     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
695         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
696         _roles[role].adminRole = adminRole;
697     }
698 
699     function _grantRole(bytes32 role, address account) private {
700         if (_roles[role].members.add(account)) {
701             emit RoleGranted(role, account, _msgSender());
702         }
703     }
704 
705     function _revokeRole(bytes32 role, address account) private {
706         if (_roles[role].members.remove(account)) {
707             emit RoleRevoked(role, account, _msgSender());
708         }
709     }
710 }
711 
712 // File: @openzeppelin/contracts/access/Ownable.sol
713 
714 
715 pragma solidity >=0.6.0 <0.8.0;
716 
717 /**
718  * @dev Contract module which provides a basic access control mechanism, where
719  * there is an account (an owner) that can be granted exclusive access to
720  * specific functions.
721  *
722  * By default, the owner account will be the one that deploys the contract. This
723  * can later be changed with {transferOwnership}.
724  *
725  * This module is used through inheritance. It will make available the modifier
726  * `onlyOwner`, which can be applied to your functions to restrict their use to
727  * the owner.
728  */
729 abstract contract Ownable is Context {
730     address private _owner;
731 
732     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
733 
734     /**
735      * @dev Initializes the contract setting the deployer as the initial owner.
736      */
737     constructor () internal {
738         address msgSender = _msgSender();
739         _owner = msgSender;
740         emit OwnershipTransferred(address(0), msgSender);
741     }
742 
743     /**
744      * @dev Returns the address of the current owner.
745      */
746     function owner() public view returns (address) {
747         return _owner;
748     }
749 
750     /**
751      * @dev Throws if called by any account other than the owner.
752      */
753     modifier onlyOwner() {
754         require(_owner == _msgSender(), "Ownable: caller is not the owner");
755         _;
756     }
757 
758     /**
759      * @dev Leaves the contract without owner. It will not be possible to call
760      * `onlyOwner` functions anymore. Can only be called by the current owner.
761      *
762      * NOTE: Renouncing ownership will leave the contract without an owner,
763      * thereby removing any functionality that is only available to the owner.
764      */
765     function renounceOwnership() public virtual onlyOwner {
766         emit OwnershipTransferred(_owner, address(0));
767         _owner = address(0);
768     }
769 
770     /**
771      * @dev Transfers ownership of the contract to a new account (`newOwner`).
772      * Can only be called by the current owner.
773      */
774     function transferOwnership(address newOwner) public virtual onlyOwner {
775         require(newOwner != address(0), "Ownable: new owner is the zero address");
776         emit OwnershipTransferred(_owner, newOwner);
777         _owner = newOwner;
778     }
779 }
780 
781 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
782 
783 
784 pragma solidity >=0.6.0 <0.8.0;
785 
786 /**
787  * @dev Interface of the ERC20 standard as defined in the EIP.
788  */
789 interface IERC20 {
790     /**
791      * @dev Returns the amount of tokens in existence.
792      */
793     function totalSupply() external view returns (uint256);
794 
795     /**
796      * @dev Returns the amount of tokens owned by `account`.
797      */
798     function balanceOf(address account) external view returns (uint256);
799 
800     /**
801      * @dev Moves `amount` tokens from the caller's account to `recipient`.
802      *
803      * Returns a boolean value indicating whether the operation succeeded.
804      *
805      * Emits a {Transfer} event.
806      */
807     function transfer(address recipient, uint256 amount) external returns (bool);
808 
809     /**
810      * @dev Returns the remaining number of tokens that `spender` will be
811      * allowed to spend on behalf of `owner` through {transferFrom}. This is
812      * zero by default.
813      *
814      * This value changes when {approve} or {transferFrom} are called.
815      */
816     function allowance(address owner, address spender) external view returns (uint256);
817 
818     /**
819      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
820      *
821      * Returns a boolean value indicating whether the operation succeeded.
822      *
823      * IMPORTANT: Beware that changing an allowance with this method brings the risk
824      * that someone may use both the old and the new allowance by unfortunate
825      * transaction ordering. One possible solution to mitigate this race
826      * condition is to first reduce the spender's allowance to 0 and set the
827      * desired value afterwards:
828      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
829      *
830      * Emits an {Approval} event.
831      */
832     function approve(address spender, uint256 amount) external returns (bool);
833 
834     /**
835      * @dev Moves `amount` tokens from `sender` to `recipient` using the
836      * allowance mechanism. `amount` is then deducted from the caller's
837      * allowance.
838      *
839      * Returns a boolean value indicating whether the operation succeeded.
840      *
841      * Emits a {Transfer} event.
842      */
843     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
844 
845     /**
846      * @dev Emitted when `value` tokens are moved from one account (`from`) to
847      * another (`to`).
848      *
849      * Note that `value` may be zero.
850      */
851     event Transfer(address indexed from, address indexed to, uint256 value);
852 
853     /**
854      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
855      * a call to {approve}. `value` is the new allowance.
856      */
857     event Approval(address indexed owner, address indexed spender, uint256 value);
858 }
859 
860 // File: @openzeppelin/contracts/math/SafeMath.sol
861 
862 
863 pragma solidity >=0.6.0 <0.8.0;
864 
865 /**
866  * @dev Wrappers over Solidity's arithmetic operations with added overflow
867  * checks.
868  *
869  * Arithmetic operations in Solidity wrap on overflow. This can easily result
870  * in bugs, because programmers usually assume that an overflow raises an
871  * error, which is the standard behavior in high level programming languages.
872  * `SafeMath` restores this intuition by reverting the transaction when an
873  * operation overflows.
874  *
875  * Using this library instead of the unchecked operations eliminates an entire
876  * class of bugs, so it's recommended to use it always.
877  */
878 library SafeMath {
879     /**
880      * @dev Returns the addition of two unsigned integers, reverting on
881      * overflow.
882      *
883      * Counterpart to Solidity's `+` operator.
884      *
885      * Requirements:
886      *
887      * - Addition cannot overflow.
888      */
889     function add(uint256 a, uint256 b) internal pure returns (uint256) {
890         uint256 c = a + b;
891         require(c >= a, "SafeMath: addition overflow");
892 
893         return c;
894     }
895 
896     /**
897      * @dev Returns the subtraction of two unsigned integers, reverting on
898      * overflow (when the result is negative).
899      *
900      * Counterpart to Solidity's `-` operator.
901      *
902      * Requirements:
903      *
904      * - Subtraction cannot overflow.
905      */
906     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
907         return sub(a, b, "SafeMath: subtraction overflow");
908     }
909 
910     /**
911      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
912      * overflow (when the result is negative).
913      *
914      * Counterpart to Solidity's `-` operator.
915      *
916      * Requirements:
917      *
918      * - Subtraction cannot overflow.
919      */
920     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
921         require(b <= a, errorMessage);
922         uint256 c = a - b;
923 
924         return c;
925     }
926 
927     /**
928      * @dev Returns the multiplication of two unsigned integers, reverting on
929      * overflow.
930      *
931      * Counterpart to Solidity's `*` operator.
932      *
933      * Requirements:
934      *
935      * - Multiplication cannot overflow.
936      */
937     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
938         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
939         // benefit is lost if 'b' is also tested.
940         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
941         if (a == 0) {
942             return 0;
943         }
944 
945         uint256 c = a * b;
946         require(c / a == b, "SafeMath: multiplication overflow");
947 
948         return c;
949     }
950 
951     /**
952      * @dev Returns the integer division of two unsigned integers. Reverts on
953      * division by zero. The result is rounded towards zero.
954      *
955      * Counterpart to Solidity's `/` operator. Note: this function uses a
956      * `revert` opcode (which leaves remaining gas untouched) while Solidity
957      * uses an invalid opcode to revert (consuming all remaining gas).
958      *
959      * Requirements:
960      *
961      * - The divisor cannot be zero.
962      */
963     function div(uint256 a, uint256 b) internal pure returns (uint256) {
964         return div(a, b, "SafeMath: division by zero");
965     }
966 
967     /**
968      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
969      * division by zero. The result is rounded towards zero.
970      *
971      * Counterpart to Solidity's `/` operator. Note: this function uses a
972      * `revert` opcode (which leaves remaining gas untouched) while Solidity
973      * uses an invalid opcode to revert (consuming all remaining gas).
974      *
975      * Requirements:
976      *
977      * - The divisor cannot be zero.
978      */
979     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
980         require(b > 0, errorMessage);
981         uint256 c = a / b;
982         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
983 
984         return c;
985     }
986 
987     /**
988      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
989      * Reverts when dividing by zero.
990      *
991      * Counterpart to Solidity's `%` operator. This function uses a `revert`
992      * opcode (which leaves remaining gas untouched) while Solidity uses an
993      * invalid opcode to revert (consuming all remaining gas).
994      *
995      * Requirements:
996      *
997      * - The divisor cannot be zero.
998      */
999     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1000         return mod(a, b, "SafeMath: modulo by zero");
1001     }
1002 
1003     /**
1004      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1005      * Reverts with custom message when dividing by zero.
1006      *
1007      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1008      * opcode (which leaves remaining gas untouched) while Solidity uses an
1009      * invalid opcode to revert (consuming all remaining gas).
1010      *
1011      * Requirements:
1012      *
1013      * - The divisor cannot be zero.
1014      */
1015     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1016         require(b != 0, errorMessage);
1017         return a % b;
1018     }
1019 }
1020 
1021 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
1022 
1023 
1024 pragma solidity >=0.6.0 <0.8.0;
1025 
1026 
1027 
1028 
1029 /**
1030  * @title SafeERC20
1031  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1032  * contract returns false). Tokens that return no value (and instead revert or
1033  * throw on failure) are also supported, non-reverting calls are assumed to be
1034  * successful.
1035  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1036  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1037  */
1038 library SafeERC20 {
1039     using SafeMath for uint256;
1040     using Address for address;
1041 
1042     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1043         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1044     }
1045 
1046     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1047         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1048     }
1049 
1050     /**
1051      * @dev Deprecated. This function has issues similar to the ones found in
1052      * {IERC20-approve}, and its usage is discouraged.
1053      *
1054      * Whenever possible, use {safeIncreaseAllowance} and
1055      * {safeDecreaseAllowance} instead.
1056      */
1057     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1058         // safeApprove should only be called when setting an initial allowance,
1059         // or when resetting it to zero. To increase and decrease it, use
1060         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1061         // solhint-disable-next-line max-line-length
1062         require((value == 0) || (token.allowance(address(this), spender) == 0),
1063             "SafeERC20: approve from non-zero to non-zero allowance"
1064         );
1065         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1066     }
1067 
1068     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1069         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1070         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1071     }
1072 
1073     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1074         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1075         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1076     }
1077 
1078     /**
1079      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1080      * on the return value: the return value is optional (but if data is returned, it must not be false).
1081      * @param token The token targeted by the call.
1082      * @param data The call data (encoded using abi.encode or one of its variants).
1083      */
1084     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1085         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1086         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1087         // the target address contains contract code and also asserts for success in the low-level call.
1088 
1089         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1090         if (returndata.length > 0) { // Return data is optional
1091             // solhint-disable-next-line max-line-length
1092             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1093         }
1094     }
1095 }
1096 
1097 // File: contracts/Uniswap.sol
1098 
1099 
1100 pragma solidity 0.6.12;
1101 
1102 
1103 interface IUniswapV2Pair {
1104     function getReserves() external view returns (uint112 r0, uint112 r1, uint32 blockTimestampLast);
1105     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1106 }
1107 
1108 interface IUniswapV2Factory {
1109     function getPair(address a, address b) external view returns (address p);
1110 }
1111 
1112 interface IUniswapV2Router02 {
1113     function WETH() external returns (address);
1114 
1115     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1116         uint amountIn,
1117         uint amountOutMin,
1118         address[] calldata path,
1119         address to,
1120         uint deadline
1121     ) external;
1122 }
1123 
1124 library UniswapV2Library {
1125     using SafeMath for uint;
1126 
1127     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1128     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1129         require(tokenA != tokenB, 'UV2: IDENTICAL_ADDRESSES');
1130         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1131         require(token0 != address(0), 'UV2: ZERO_ADDRESS');
1132     }
1133     
1134     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1135     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
1136         require(amountIn > 0, 'UV2: INSUFFICIENT_INPUT_AMOUNT');
1137         require(reserveIn > 0 && reserveOut > 0, 'UV2: INSUFFICIENT_LIQUIDITY');
1138         uint amountInWithFee = amountIn.mul(997);
1139         uint numerator = amountInWithFee.mul(reserveOut);
1140         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
1141         amountOut = numerator / denominator;
1142     }
1143 }
1144 
1145 // File: contracts/IUniMexFactory.sol
1146 
1147 
1148 pragma solidity 0.6.12;
1149 
1150 interface IUniMexFactory {
1151   function getPool(address) external returns(address);
1152   function getMaxLeverage(address) external returns(uint256);
1153   function allowedMargins(address) external returns (bool);
1154   function utilizationScaled(address token) external pure returns(uint256);
1155 }
1156 
1157 // File: contracts/UniMexMargin.sol
1158 
1159 
1160 pragma solidity 0.6.12;
1161 
1162 
1163 
1164 
1165 
1166 
1167 
1168 interface IUniMexStaking {
1169     function distribute(uint256 _amount) external;
1170 }
1171 
1172 interface IUniMexPool {
1173     function borrow(uint256 _amount) external;
1174     function distribute(uint256 _amount) external;
1175     function repay(uint256 _amount) external returns (bool);
1176 }
1177 
1178 contract UniMexMargin is Ownable, AccessControl {
1179     using SafeMath for uint256;
1180     using SafeERC20 for IERC20;
1181 
1182     bytes32 public constant LIQUIDATOR_ROLE = keccak256("LIQUIDATOR_ROLE");
1183 
1184     address private WETH_ADDRESS;
1185     IERC20 public WETH;
1186     uint256 public constant MAG = 1e18;
1187     uint256 public constant LIQUIDATION_MARGIN = 11*1e17; //10%
1188     uint256 public liquidationBonus = 9 * 1e16;
1189     uint256 public borrowInterestPercentScaled = 100; //10%
1190     uint256 public constant YEAR = 31536000;
1191     uint256 public positionNonce = 0;
1192     bool public paused = false;
1193     
1194     struct Position {
1195         bytes32 id;
1196         address token;
1197         address owner;
1198         uint256 owed;
1199         uint256 input;
1200         uint256 commitment;
1201         uint256 leverage;
1202         uint256 startTimestamp;
1203         bool isShort;
1204         uint256 borrowInterest;
1205     }
1206     
1207     mapping(bytes32 => Position) public positionInfo;
1208     mapping(address => uint256) public balanceOf;
1209     mapping(address => uint256) public escrow;
1210     
1211     IUniMexStaking public staking;
1212     IUniMexFactory public unimex_factory;
1213     IUniswapV2Factory public uniswap_factory;
1214     IUniswapV2Router02 public uniswap_router;
1215 
1216     event OnClosePosition(
1217         bytes32 indexed positionId,
1218         address token,
1219         address indexed owner,
1220         uint256 owed,
1221         uint256 input,
1222         uint256 commitment,
1223         uint256 leverage,
1224         uint256 startTimestamp,
1225         bool isShort,
1226         uint256 borrowInterest,
1227         uint256 liquidationBonus, //amount that went to liquidator when position was liquidated. 0 if position was closed
1228         uint256 scaledCloseRate // weth/token multiplied by 1e18
1229     );
1230 
1231     event OnOpenPosition(
1232         address indexed sender,
1233         bytes32 positionId,
1234         bool isShort,
1235         address indexed token
1236     );
1237 
1238     event OnAddCommitment(
1239         bytes32 indexed positionId,
1240         uint256 amount
1241     );
1242 
1243     //to prevent flashloans
1244     modifier isHuman() {
1245         require(msg.sender == tx.origin);
1246         _;
1247     }
1248 
1249     constructor(
1250         address _staking,
1251         address _factory,
1252         address _weth,
1253         address _uniswap_factory,
1254         address _uniswap_router
1255     ) public {
1256         staking = IUniMexStaking(_staking);
1257         unimex_factory = IUniMexFactory(_factory);
1258         WETH_ADDRESS = _weth;
1259         WETH = IERC20(_weth);
1260         uniswap_factory = IUniswapV2Factory(_uniswap_factory);
1261         uniswap_router = IUniswapV2Router02(_uniswap_router);
1262 
1263         // Grant the contract deployer the default admin role: it will be able
1264         // to grant and revoke any roles
1265         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1266     }
1267 
1268     function deposit(uint256 _amount) public {
1269         WETH.safeTransferFrom(msg.sender, address(this), _amount);
1270         balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
1271     }
1272 
1273     function withdraw(uint256 _amount) public {
1274         require(balanceOf[msg.sender] >= _amount);
1275         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
1276         WETH.safeTransfer(msg.sender, _amount);
1277     }
1278 
1279     function calculateBorrowInterest(bytes32 positionId) public view returns (uint256) {
1280         Position storage position = positionInfo[positionId];
1281         uint256 loanTime = block.timestamp.sub(position.startTimestamp);
1282         return position.owed.mul(loanTime).mul(position.borrowInterest).div(1000).div(YEAR);
1283     }
1284 
1285     function openShortPosition(address token, uint256 amount, uint256 scaledLeverage, uint256 minimalSwapAmount) public isHuman {
1286         _openPosition(token, amount, scaledLeverage, minimalSwapAmount, true);
1287     }
1288 
1289     function openLongPosition(address token, uint256 amount, uint256 scaledLeverage, uint256 minimalSwapAmount) public isHuman {
1290         _openPosition(token, amount, scaledLeverage, minimalSwapAmount, false);
1291     }
1292 
1293     function _openPosition(address token, uint256 amount, uint256 scaledLeverage, uint256 minimalSwapAmount, bool isShort) private {
1294         require(!paused, "PAUSED");
1295         require(amount > 0, "AMOUNT_ZERO");
1296         address pool = unimex_factory.getPool(address(isShort ? IERC20(token) : WETH));
1297 
1298         require(pool != address(0), "POOL_DOES_NOT_EXIST");
1299         require(scaledLeverage <= unimex_factory.getMaxLeverage(token).mul(MAG), "LEVERAGE_EXCEEDS_MAX");
1300 
1301         uint amountInWeth = isShort ? calculateConvertedValue(token, WETH_ADDRESS, amount) : amount;
1302         uint256 commitment = getCommitment(amountInWeth, scaledLeverage);
1303         require(balanceOf[msg.sender] >= commitment.add(liquidationBonus), "NO_BALANCE");
1304 
1305         IUniMexPool(pool).borrow(amount);
1306 
1307         uint256 swap;
1308 
1309         {
1310             (address baseToken, address quoteToken) = isShort ? (token, WETH_ADDRESS) : (WETH_ADDRESS, token);
1311             swap = swapTokens(baseToken, quoteToken, amount);
1312             require(swap >= minimalSwapAmount, "INSUFFICIENT_SWAP");
1313         }
1314 
1315         uint256 fees = (swap.mul(8)).div(1000);
1316 
1317         swap = swap.sub(fees); // swap minus fees
1318 
1319         if(!isShort) {
1320             fees = swapTokens(token, WETH_ADDRESS, fees); // convert fees to ETH
1321         }
1322 
1323         transferFees(fees, pool);
1324 
1325         transferUserToEscrow(msg.sender, msg.sender, commitment.add(liquidationBonus));
1326 
1327         positionNonce = positionNonce + 1; //possible overflow is ok
1328         bytes32 positionId = getPositionId(
1329             msg.sender,
1330             token,
1331             amount,
1332             scaledLeverage,
1333             positionNonce
1334         );
1335 
1336         Position memory position = Position({
1337         owed: amount,
1338         input: swap,
1339         commitment: commitment.add(liquidationBonus),
1340         owner: msg.sender,
1341         startTimestamp: block.timestamp,
1342         isShort: isShort,
1343         leverage: scaledLeverage,
1344         token: token,
1345         id: positionId,
1346         borrowInterest: borrowInterestPercentScaled
1347         });
1348 
1349         positionInfo[position.id] = position;
1350 
1351         emit OnOpenPosition(msg.sender, position.id, isShort, token);
1352     }
1353 
1354     function addCommitmentToPosition(bytes32 positionId, uint256 amount) public {
1355         Position storage position = positionInfo[positionId];
1356         require(position.owner != address(0), "NO_POSITION");
1357         position.commitment = position.commitment.add(amount);
1358         WETH.safeTransferFrom(msg.sender, address(this), amount);
1359         escrow[position.owner] = escrow[position.owner].add(amount);
1360         emit OnAddCommitment(positionId, amount);
1361     }
1362 
1363     function closePosition(bytes32 positionId, uint256 minimalSwapAmount) external isHuman {
1364         Position storage position = positionInfo[positionId];
1365         require(position.owner != address(0), "NO_OPEN_POSITION");
1366         require(msg.sender == position.owner, "BORROWER_ONLY");
1367         uint256 scaledRate;
1368         if(position.isShort) {
1369             scaledRate = _closeShort(position, minimalSwapAmount);
1370         }else{
1371             scaledRate = _closeLong(position, minimalSwapAmount);
1372         }
1373         deletePosition(position, 0, scaledRate);
1374     }
1375 
1376     function _closeShort(Position storage position, uint256 minimalSwapAmount) private returns (uint256){
1377         uint256 input = position.input;
1378         uint256 owed = position.owed;
1379         uint256 commitment = position.commitment;
1380 
1381         address pool = unimex_factory.getPool(position.token);
1382 
1383         uint256 poolInterestInTokens = calculateBorrowInterest(position.id);
1384         uint256 swap = swapTokens(WETH_ADDRESS, position.token, input);
1385         require(swap >= minimalSwapAmount, "INSUFFICIENT_SWAP");
1386         uint256 scaledRate = calculateScaledRate(input, swap);
1387         require(swap >= owed.add(poolInterestInTokens).mul(input).div(input.add(commitment)), "LIQUIDATE_ONLY");
1388 
1389         bool isProfit = owed < swap;
1390         uint256 amount;
1391 
1392         uint256 fees = poolInterestInTokens > 0 ? calculateConvertedValue(position.token, address(WETH), poolInterestInTokens) : 0;
1393         if(isProfit) {
1394             uint256 profitInTokens = swap.sub(owed);
1395             amount = swapTokens(position.token, WETH_ADDRESS, profitInTokens); //profit in eth
1396         } else {
1397             uint256 commitmentInTokens = swapTokens(WETH_ADDRESS, position.token, commitment);
1398             uint256 remainder = owed.sub(swap);
1399             require(commitmentInTokens >= remainder, "LIQUIDATE_ONLY");
1400             amount = swapTokens(position.token, WETH_ADDRESS, commitmentInTokens.sub(remainder)); //return to user's balance
1401         }
1402         if(isProfit) {
1403             if(amount >= fees) {
1404                 transferEscrowToUser(position.owner, position.owner, commitment);
1405                 transferToUser(position.owner, amount.sub(fees));
1406             } else {
1407                 uint256 remainder = fees.sub(amount);
1408                 transferEscrowToUser(position.owner, position.owner, commitment.sub(remainder));
1409                 transferEscrowToUser(position.owner, address(0), remainder);
1410             }
1411         } else {
1412             require(amount >= fees, "LIQUIDATE_ONLY"); //safety check
1413             transferEscrowToUser(position.owner, address(0x0), commitment);
1414             transferToUser(position.owner, amount.sub(fees));
1415         }
1416         transferFees(fees, pool);
1417 
1418         transferToPool(pool, position.token, owed);
1419 
1420         return scaledRate;
1421     }
1422 
1423     function _closeLong(Position storage position, uint256 minimalSwapAmount) private returns (uint256){
1424         uint256 input = position.input;
1425         uint256 owed = position.owed;
1426         address pool = unimex_factory.getPool(WETH_ADDRESS);
1427 
1428         uint256 fees = calculateBorrowInterest(position.id);
1429         uint256 swap = swapTokens(position.token, WETH_ADDRESS, input);
1430         require(swap >= minimalSwapAmount, "INSUFFICIENT_SWAP");
1431         uint256 scaledRate = calculateScaledRate(swap, input);
1432         require(swap.add(position.commitment) >= owed.add(fees), "LIQUIDATE_ONLY");
1433 
1434         uint256 commitment = position.commitment;
1435 
1436         bool isProfit = swap >= owed;
1437 
1438         uint256 amount = isProfit ? swap.sub(owed) : commitment.sub(owed.sub(swap));
1439 
1440         transferToPool(pool, WETH_ADDRESS, owed);
1441 
1442         transferFees(fees, pool);
1443 
1444         transferEscrowToUser(position.owner, isProfit ? position.owner : address(0x0), commitment);
1445 
1446         transferToUser(position.owner, amount.sub(fees));
1447         return scaledRate;
1448     }
1449 
1450 
1451     /**
1452     * @dev helper function, indicates when a position can be liquidated.
1453     * Liquidation threshold is when position input plus commitment can be converted to 110% of owed tokens
1454     */
1455     function canLiquidate(bytes32 positionId) public view returns(bool) {
1456         Position storage position = positionInfo[positionId];
1457         uint256 canReturn;
1458         if(position.isShort) {
1459             uint positionBalance = position.input.add(position.commitment);
1460             uint valueToConvert = positionBalance < liquidationBonus ? 0 : positionBalance.sub(liquidationBonus);
1461             canReturn = calculateConvertedValue(WETH_ADDRESS, position.token, valueToConvert);
1462         } else {
1463             uint canReturnOverall = calculateConvertedValue(position.token, WETH_ADDRESS, position.input)
1464                     .add(position.commitment);
1465             canReturn = canReturnOverall < liquidationBonus ? 0 : canReturnOverall.sub(liquidationBonus);
1466         }
1467         uint256 poolInterest = calculateBorrowInterest(position.id);
1468         return canReturn < position.owed.add(poolInterest).mul(LIQUIDATION_MARGIN).div(MAG);
1469     }
1470 
1471     /**
1472     * @dev Liquidates position and sends a liquidation bonus from user's commitment to a caller.
1473     * can only be called from account that has the LIQUIDATOR role
1474     */
1475     function liquidatePosition(bytes32 positionId, uint256 minimalSwapAmount) external isHuman {
1476         Position storage position = positionInfo[positionId];
1477         require(position.owner != address(0), "NO_OPEN_POSITION");
1478         require(hasRole(LIQUIDATOR_ROLE, msg.sender) || position.owner == msg.sender, "NOT_LIQUIDATOR");
1479         uint256 canReturn;
1480         uint poolInterest = calculateBorrowInterest(position.id);
1481 
1482         uint256 liquidatorBonus;
1483         uint256 scaledRate;
1484         if(position.isShort) {
1485             uint256 positionBalance = position.input.add(position.commitment);
1486             uint256 valueToConvert;
1487             (valueToConvert, liquidatorBonus) = _safeSubtract(positionBalance, liquidationBonus);
1488             canReturn = swapTokens(WETH_ADDRESS, position.token, valueToConvert);
1489             require(canReturn >= minimalSwapAmount, "INSUFFICIENT_SWAP");
1490             scaledRate = calculateScaledRate(valueToConvert, canReturn);
1491         } else {
1492             uint256 swap = swapTokens(position.token, WETH_ADDRESS, position.input);
1493             require(swap >= minimalSwapAmount, "INSUFFICIENT_SWAP");
1494             scaledRate = calculateScaledRate(swap, position.input);
1495             uint256 canReturnOverall = swap.add(position.commitment);
1496             (canReturn, liquidatorBonus) = _safeSubtract(canReturnOverall, liquidationBonus);
1497         }
1498         require(canReturn < position.owed.add(poolInterest).mul(LIQUIDATION_MARGIN).div(MAG), "CANNOT_LIQUIDATE");
1499 
1500         _liquidate(position, canReturn, poolInterest);
1501 
1502         transferEscrowToUser(position.owner, address(0x0), position.commitment);
1503         WETH.safeTransfer(msg.sender, liquidatorBonus);
1504 
1505         deletePosition(position, liquidatorBonus, scaledRate);
1506     }
1507 
1508     function _liquidate(Position memory position, uint256 canReturn, uint fees) private {
1509         address baseToken = position.isShort ? position.token : WETH_ADDRESS;
1510         address pool = unimex_factory.getPool(baseToken);
1511         if(canReturn > position.owed) {
1512             transferToPool(pool, baseToken, position.owed);
1513             uint256 remainder = canReturn.sub(position.owed);
1514             if(remainder > fees) { //can pay fees completely
1515                 if(position.isShort) {
1516                     remainder = swapTokens(position.token, WETH_ADDRESS, remainder);
1517                     if(fees > 0) { //with fees == 0 calculation is reverted with "UV2: insufficient input amount"
1518                         fees = calculateConvertedValue(position.token, WETH_ADDRESS, fees);
1519                         if(fees > remainder) { //safety check
1520                             fees = remainder;
1521                         }
1522                     }
1523                 }
1524                 transferFees(fees, pool);
1525                 transferToUser(position.owner, remainder.sub(fees));
1526             } else { //all is left is for fees
1527                 if(position.isShort) {
1528                     //convert remainder to weth
1529                     remainder = swapTokens(position.token, WETH_ADDRESS, canReturn.sub(position.owed));
1530                 }
1531                 transferFees(remainder, pool);
1532             }
1533         } else {
1534             //return to pool all that's left
1535             transferToPool(pool, baseToken, canReturn);
1536         }
1537     }
1538 
1539     function setStaking(address _staking) external onlyOwner {
1540         require(_staking != address(0));
1541         staking = IUniMexStaking(_staking);
1542     }
1543 
1544     /**
1545     * @dev called by the owner to pause, triggers stopped state
1546     */
1547     function pause() onlyOwner public {
1548         paused = true;
1549     }
1550 
1551     /**
1552      * @dev called by the owner to unpause, returns to normal state
1553      */
1554     function unpause() onlyOwner public {
1555         paused = false;
1556     }
1557 
1558     /**
1559     * @dev set bonus for position liquidation. Can only be called from accounts with LIQUIDATOR role.
1560     */
1561     function setLiquidationBonus(uint256 _liquidationBonus) external {
1562         require(hasRole(LIQUIDATOR_ROLE, msg.sender), "NOT_LIQUIDATOR");
1563         require(_liquidationBonus > 0, "ZERO_LIQUIDATION_BONUS");
1564         require(_liquidationBonus <= 0.5 ether, "LIQUIDATION_BONUS_EXCEEDS_MAX");
1565         liquidationBonus = _liquidationBonus;
1566     }
1567 
1568     /**
1569     * @dev set interest rate for tokens owed from pools. Scaled to 10 (e.g. 150 is 15%)
1570     */
1571     function setBorrowPercent(uint256 _newPercentScaled) external onlyOwner {
1572         borrowInterestPercentScaled = _newPercentScaled;
1573     }
1574 
1575     function calculateScaledRate(uint256 wethAmount, uint256 tokenAmount) private pure returns (uint256 scaledRate){
1576         if(tokenAmount == 0) {
1577             return 0;
1578         }
1579         return wethAmount.mul(MAG).div(tokenAmount);
1580     }
1581 
1582     function transferUserToEscrow(address from, address to, uint256 amount) private {
1583         require(balanceOf[from] >= amount);
1584         balanceOf[from] = balanceOf[from].sub(amount);
1585         escrow[to] = escrow[to].add(amount);
1586     }
1587 
1588     function transferEscrowToUser(address from, address to, uint256 amount) private {
1589         require(escrow[from] >= amount);
1590         escrow[from] = escrow[from].sub(amount);
1591         balanceOf[to] = balanceOf[to].add(amount);
1592     }
1593 
1594     function transferToUser(address to, uint256 amount) private {
1595         balanceOf[to] = balanceOf[to].add(amount);
1596     }
1597 
1598     function getPositionId(
1599         address maker,
1600         address token,
1601         uint256 amount,
1602         uint256 leverage,
1603         uint256 nonce
1604     ) private pure returns (bytes32 positionId) {
1605         //date acts as a nonce
1606         positionId = keccak256(
1607             abi.encodePacked(maker, token, amount, leverage, nonce)
1608         );
1609     }
1610 
1611     function calculateConvertedValue(address baseToken, address quoteToken, uint256 amount) private view returns (uint256) {
1612         address token0;
1613         address token1;
1614         (token0, token1) = UniswapV2Library.sortTokens(baseToken, quoteToken);
1615         IUniswapV2Pair pair = IUniswapV2Pair(uniswap_factory.getPair(token0, token1));
1616         (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
1617         uint256 value;
1618         if (token1 == baseToken) {
1619             value = UniswapV2Library.getAmountOut(amount, reserve1, reserve0);
1620         } else {
1621             value = UniswapV2Library.getAmountOut(amount, reserve0, reserve1);
1622         }
1623         return value;
1624     }
1625 
1626     function swapTokens(address baseToken, address quoteToken, uint256 input) private returns (uint256 swap) {
1627         if(input == 0) {
1628             return 0;
1629         }
1630         IERC20(baseToken).approve(address(uniswap_router), input);
1631         address[] memory path = new address[](2);
1632         path[0] = baseToken;
1633         path[1] = quoteToken;
1634         uint256 balanceBefore = IERC20(quoteToken).balanceOf(address(this));
1635 
1636         IUniswapV2Router02(uniswap_router).swapExactTokensForTokensSupportingFeeOnTransferTokens(
1637             input,
1638             0, //checks are done after swap in caller functions
1639             path,
1640             address(this),
1641             block.timestamp
1642         );
1643 
1644         uint256 balanceAfter = IERC20(quoteToken).balanceOf(address(this));
1645         swap = balanceAfter.sub(balanceBefore);
1646     }
1647 
1648     function getCommitment(uint256 _amount, uint scaledLeverage) private pure returns (uint256 commitment) {
1649         commitment = (_amount.mul(MAG)).div(scaledLeverage);
1650     }
1651 
1652     function transferFees(uint256 fees, address pool) private {
1653         uint256 halfFees = fees.div(2);
1654 
1655         // Pool fees
1656         WETH.approve(pool, halfFees);
1657         IUniMexPool(pool).distribute(halfFees);
1658 
1659         // Staking Fees
1660         WETH.approve(address(staking), fees.sub(halfFees));
1661         staking.distribute(fees.sub(halfFees));
1662     }
1663 
1664     function transferToPool(address pool, address token, uint256 amount) private {
1665         IERC20(token).approve(pool, amount);
1666         IUniMexPool(pool).repay(amount);
1667     }
1668 
1669 
1670     function _safeSubtract(uint256 from, uint256 amount) private pure returns (uint256 remainder, uint256 subtractedAmount) {
1671         if(from < amount) {
1672             remainder = 0;
1673             subtractedAmount = from;
1674         } else {
1675             remainder = from.sub(amount);
1676             subtractedAmount = amount;
1677         }
1678     }
1679 
1680     function deletePosition(Position storage position, uint liquidatedAmount, uint scaledRate) private {
1681         emit OnClosePosition(
1682             position.id,
1683             position.token,
1684             position.owner,
1685             position.owed,
1686             position.input,
1687             position.commitment,
1688             position.leverage,
1689             position.startTimestamp,
1690             position.isShort,
1691             position.borrowInterest,
1692             liquidatedAmount,
1693             scaledRate
1694         );
1695         delete positionInfo[position.id];
1696     }
1697 
1698 }