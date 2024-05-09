1 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
2 
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
304 
305 pragma solidity >=0.6.2 <0.8.0;
306 
307 /**
308  * @dev Collection of functions related to the address type
309  */
310 library Address {
311     /**
312      * @dev Returns true if `account` is a contract.
313      *
314      * [IMPORTANT]
315      * ====
316      * It is unsafe to assume that an address for which this function returns
317      * false is an externally-owned account (EOA) and not a contract.
318      *
319      * Among others, `isContract` will return false for the following
320      * types of addresses:
321      *
322      *  - an externally-owned account
323      *  - a contract in construction
324      *  - an address where a contract will be created
325      *  - an address where a contract lived, but was destroyed
326      * ====
327      */
328     function isContract(address account) internal view returns (bool) {
329         // This method relies on extcodesize, which returns 0 for contracts in
330         // construction, since the code is only stored at the end of the
331         // constructor execution.
332 
333         uint256 size;
334         // solhint-disable-next-line no-inline-assembly
335         assembly { size := extcodesize(account) }
336         return size > 0;
337     }
338 
339     /**
340      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
341      * `recipient`, forwarding all available gas and reverting on errors.
342      *
343      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
344      * of certain opcodes, possibly making contracts go over the 2300 gas limit
345      * imposed by `transfer`, making them unable to receive funds via
346      * `transfer`. {sendValue} removes this limitation.
347      *
348      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
349      *
350      * IMPORTANT: because control is transferred to `recipient`, care must be
351      * taken to not create reentrancy vulnerabilities. Consider using
352      * {ReentrancyGuard} or the
353      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
354      */
355     function sendValue(address payable recipient, uint256 amount) internal {
356         require(address(this).balance >= amount, "Address: insufficient balance");
357 
358         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
359         (bool success, ) = recipient.call{ value: amount }("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain`call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382       return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
392         return functionCallWithValue(target, data, 0, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but also transferring `value` wei to `target`.
398      *
399      * Requirements:
400      *
401      * - the calling contract must have an ETH balance of at least `value`.
402      * - the called Solidity function must be `payable`.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
412      * with `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
417         require(address(this).balance >= value, "Address: insufficient balance for call");
418         require(isContract(target), "Address: call to non-contract");
419 
420         // solhint-disable-next-line avoid-low-level-calls
421         (bool success, bytes memory returndata) = target.call{ value: value }(data);
422         return _verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
432         return functionStaticCall(target, data, "Address: low-level static call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
442         require(isContract(target), "Address: static call to non-contract");
443 
444         // solhint-disable-next-line avoid-low-level-calls
445         (bool success, bytes memory returndata) = target.staticcall(data);
446         return _verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
450         if (success) {
451             return returndata;
452         } else {
453             // Look for revert reason and bubble it up if present
454             if (returndata.length > 0) {
455                 // The easiest way to bubble the revert reason is using memory via assembly
456 
457                 // solhint-disable-next-line no-inline-assembly
458                 assembly {
459                     let returndata_size := mload(returndata)
460                     revert(add(32, returndata), returndata_size)
461                 }
462             } else {
463                 revert(errorMessage);
464             }
465         }
466     }
467 }
468 
469 // File: @openzeppelin/contracts/GSN/Context.sol
470 
471 
472 
473 pragma solidity >=0.6.0 <0.8.0;
474 
475 /*
476  * @dev Provides information about the current execution context, including the
477  * sender of the transaction and its data. While these are generally available
478  * via msg.sender and msg.data, they should not be accessed in such a direct
479  * manner, since when dealing with GSN meta-transactions the account sending and
480  * paying for execution may not be the actual sender (as far as an application
481  * is concerned).
482  *
483  * This contract is only required for intermediate, library-like contracts.
484  */
485 abstract contract Context {
486     function _msgSender() internal view virtual returns (address payable) {
487         return msg.sender;
488     }
489 
490     function _msgData() internal view virtual returns (bytes memory) {
491         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
492         return msg.data;
493     }
494 }
495 
496 // File: @openzeppelin/contracts/access/AccessControl.sol
497 
498 
499 
500 pragma solidity >=0.6.0 <0.8.0;
501 
502 
503 
504 
505 /**
506  * @dev Contract module that allows children to implement role-based access
507  * control mechanisms.
508  *
509  * Roles are referred to by their `bytes32` identifier. These should be exposed
510  * in the external API and be unique. The best way to achieve this is by
511  * using `public constant` hash digests:
512  *
513  * ```
514  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
515  * ```
516  *
517  * Roles can be used to represent a set of permissions. To restrict access to a
518  * function call, use {hasRole}:
519  *
520  * ```
521  * function foo() public {
522  *     require(hasRole(MY_ROLE, msg.sender));
523  *     ...
524  * }
525  * ```
526  *
527  * Roles can be granted and revoked dynamically via the {grantRole} and
528  * {revokeRole} functions. Each role has an associated admin role, and only
529  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
530  *
531  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
532  * that only accounts with this role will be able to grant or revoke other
533  * roles. More complex role relationships can be created by using
534  * {_setRoleAdmin}.
535  *
536  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
537  * grant and revoke this role. Extra precautions should be taken to secure
538  * accounts that have been granted it.
539  */
540 abstract contract AccessControl is Context {
541     using EnumerableSet for EnumerableSet.AddressSet;
542     using Address for address;
543 
544     struct RoleData {
545         EnumerableSet.AddressSet members;
546         bytes32 adminRole;
547     }
548 
549     mapping (bytes32 => RoleData) private _roles;
550 
551     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
552 
553     /**
554      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
555      *
556      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
557      * {RoleAdminChanged} not being emitted signaling this.
558      *
559      * _Available since v3.1._
560      */
561     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
562 
563     /**
564      * @dev Emitted when `account` is granted `role`.
565      *
566      * `sender` is the account that originated the contract call, an admin role
567      * bearer except when using {_setupRole}.
568      */
569     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
570 
571     /**
572      * @dev Emitted when `account` is revoked `role`.
573      *
574      * `sender` is the account that originated the contract call:
575      *   - if using `revokeRole`, it is the admin role bearer
576      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
577      */
578     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
579 
580     /**
581      * @dev Returns `true` if `account` has been granted `role`.
582      */
583     function hasRole(bytes32 role, address account) public view returns (bool) {
584         return _roles[role].members.contains(account);
585     }
586 
587     /**
588      * @dev Returns the number of accounts that have `role`. Can be used
589      * together with {getRoleMember} to enumerate all bearers of a role.
590      */
591     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
592         return _roles[role].members.length();
593     }
594 
595     /**
596      * @dev Returns one of the accounts that have `role`. `index` must be a
597      * value between 0 and {getRoleMemberCount}, non-inclusive.
598      *
599      * Role bearers are not sorted in any particular way, and their ordering may
600      * change at any point.
601      *
602      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
603      * you perform all queries on the same block. See the following
604      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
605      * for more information.
606      */
607     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
608         return _roles[role].members.at(index);
609     }
610 
611     /**
612      * @dev Returns the admin role that controls `role`. See {grantRole} and
613      * {revokeRole}.
614      *
615      * To change a role's admin, use {_setRoleAdmin}.
616      */
617     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
618         return _roles[role].adminRole;
619     }
620 
621     /**
622      * @dev Grants `role` to `account`.
623      *
624      * If `account` had not been already granted `role`, emits a {RoleGranted}
625      * event.
626      *
627      * Requirements:
628      *
629      * - the caller must have ``role``'s admin role.
630      */
631     function grantRole(bytes32 role, address account) public virtual {
632         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
633 
634         _grantRole(role, account);
635     }
636 
637     /**
638      * @dev Revokes `role` from `account`.
639      *
640      * If `account` had been granted `role`, emits a {RoleRevoked} event.
641      *
642      * Requirements:
643      *
644      * - the caller must have ``role``'s admin role.
645      */
646     function revokeRole(bytes32 role, address account) public virtual {
647         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
648 
649         _revokeRole(role, account);
650     }
651 
652     /**
653      * @dev Revokes `role` from the calling account.
654      *
655      * Roles are often managed via {grantRole} and {revokeRole}: this function's
656      * purpose is to provide a mechanism for accounts to lose their privileges
657      * if they are compromised (such as when a trusted device is misplaced).
658      *
659      * If the calling account had been granted `role`, emits a {RoleRevoked}
660      * event.
661      *
662      * Requirements:
663      *
664      * - the caller must be `account`.
665      */
666     function renounceRole(bytes32 role, address account) public virtual {
667         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
668 
669         _revokeRole(role, account);
670     }
671 
672     /**
673      * @dev Grants `role` to `account`.
674      *
675      * If `account` had not been already granted `role`, emits a {RoleGranted}
676      * event. Note that unlike {grantRole}, this function doesn't perform any
677      * checks on the calling account.
678      *
679      * [WARNING]
680      * ====
681      * This function should only be called from the constructor when setting
682      * up the initial roles for the system.
683      *
684      * Using this function in any other way is effectively circumventing the admin
685      * system imposed by {AccessControl}.
686      * ====
687      */
688     function _setupRole(bytes32 role, address account) internal virtual {
689         _grantRole(role, account);
690     }
691 
692     /**
693      * @dev Sets `adminRole` as ``role``'s admin role.
694      *
695      * Emits a {RoleAdminChanged} event.
696      */
697     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
698         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
699         _roles[role].adminRole = adminRole;
700     }
701 
702     function _grantRole(bytes32 role, address account) private {
703         if (_roles[role].members.add(account)) {
704             emit RoleGranted(role, account, _msgSender());
705         }
706     }
707 
708     function _revokeRole(bytes32 role, address account) private {
709         if (_roles[role].members.remove(account)) {
710             emit RoleRevoked(role, account, _msgSender());
711         }
712     }
713 }
714 
715 // File: contracts/interfaces/IERC20Sumswap.sol
716 
717 pragma solidity >=0.5.0;
718 
719 interface IERC20Sumswap{
720     event Approval(address indexed owner, address indexed spender, uint value);
721     event Transfer(address indexed from, address indexed to, uint value);
722 
723     function name() external view returns (string memory);
724     function symbol() external view returns (string memory);
725     function decimals() external view returns (uint8);
726     function totalSupply() external view returns (uint);
727     function balanceOf(address owner) external view returns (uint);
728     function allowance(address owner, address spender) external view returns (uint);
729 
730     function approve(address spender, uint value) external returns (bool);
731     function transfer(address to, uint value) external returns (bool);
732     function transferFrom(address from, address to, uint value) external returns (bool);
733 }
734 
735 // File: @openzeppelin/contracts/math/SafeMath.sol
736 
737 
738 
739 pragma solidity >=0.6.0 <0.8.0;
740 
741 /**
742  * @dev Wrappers over Solidity's arithmetic operations with added overflow
743  * checks.
744  *
745  * Arithmetic operations in Solidity wrap on overflow. This can easily result
746  * in bugs, because programmers usually assume that an overflow raises an
747  * error, which is the standard behavior in high level programming languages.
748  * `SafeMath` restores this intuition by reverting the transaction when an
749  * operation overflows.
750  *
751  * Using this library instead of the unchecked operations eliminates an entire
752  * class of bugs, so it's recommended to use it always.
753  */
754 library SafeMath {
755     /**
756      * @dev Returns the addition of two unsigned integers, reverting on
757      * overflow.
758      *
759      * Counterpart to Solidity's `+` operator.
760      *
761      * Requirements:
762      *
763      * - Addition cannot overflow.
764      */
765     function add(uint256 a, uint256 b) internal pure returns (uint256) {
766         uint256 c = a + b;
767         require(c >= a, "SafeMath: addition overflow");
768 
769         return c;
770     }
771 
772     /**
773      * @dev Returns the subtraction of two unsigned integers, reverting on
774      * overflow (when the result is negative).
775      *
776      * Counterpart to Solidity's `-` operator.
777      *
778      * Requirements:
779      *
780      * - Subtraction cannot overflow.
781      */
782     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
783         return sub(a, b, "SafeMath: subtraction overflow");
784     }
785 
786     /**
787      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
788      * overflow (when the result is negative).
789      *
790      * Counterpart to Solidity's `-` operator.
791      *
792      * Requirements:
793      *
794      * - Subtraction cannot overflow.
795      */
796     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
797         require(b <= a, errorMessage);
798         uint256 c = a - b;
799 
800         return c;
801     }
802 
803     /**
804      * @dev Returns the multiplication of two unsigned integers, reverting on
805      * overflow.
806      *
807      * Counterpart to Solidity's `*` operator.
808      *
809      * Requirements:
810      *
811      * - Multiplication cannot overflow.
812      */
813     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
814         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
815         // benefit is lost if 'b' is also tested.
816         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
817         if (a == 0) {
818             return 0;
819         }
820 
821         uint256 c = a * b;
822         require(c / a == b, "SafeMath: multiplication overflow");
823 
824         return c;
825     }
826 
827     /**
828      * @dev Returns the integer division of two unsigned integers. Reverts on
829      * division by zero. The result is rounded towards zero.
830      *
831      * Counterpart to Solidity's `/` operator. Note: this function uses a
832      * `revert` opcode (which leaves remaining gas untouched) while Solidity
833      * uses an invalid opcode to revert (consuming all remaining gas).
834      *
835      * Requirements:
836      *
837      * - The divisor cannot be zero.
838      */
839     function div(uint256 a, uint256 b) internal pure returns (uint256) {
840         return div(a, b, "SafeMath: division by zero");
841     }
842 
843     /**
844      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
845      * division by zero. The result is rounded towards zero.
846      *
847      * Counterpart to Solidity's `/` operator. Note: this function uses a
848      * `revert` opcode (which leaves remaining gas untouched) while Solidity
849      * uses an invalid opcode to revert (consuming all remaining gas).
850      *
851      * Requirements:
852      *
853      * - The divisor cannot be zero.
854      */
855     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
856         require(b > 0, errorMessage);
857         uint256 c = a / b;
858         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
859 
860         return c;
861     }
862 
863     /**
864      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
865      * Reverts when dividing by zero.
866      *
867      * Counterpart to Solidity's `%` operator. This function uses a `revert`
868      * opcode (which leaves remaining gas untouched) while Solidity uses an
869      * invalid opcode to revert (consuming all remaining gas).
870      *
871      * Requirements:
872      *
873      * - The divisor cannot be zero.
874      */
875     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
876         return mod(a, b, "SafeMath: modulo by zero");
877     }
878 
879     /**
880      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
881      * Reverts with custom message when dividing by zero.
882      *
883      * Counterpart to Solidity's `%` operator. This function uses a `revert`
884      * opcode (which leaves remaining gas untouched) while Solidity uses an
885      * invalid opcode to revert (consuming all remaining gas).
886      *
887      * Requirements:
888      *
889      * - The divisor cannot be zero.
890      */
891     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
892         require(b != 0, errorMessage);
893         return a % b;
894     }
895 }
896 
897 // File: contracts/SummaPri.sol
898 
899 pragma solidity ^0.6.0;
900 
901 
902 
903 
904 
905 contract SummaPri is AccessControl {
906 
907     using SafeMath for uint256;
908 
909     using Address for address;
910 
911     bytes32 public constant ANGEL_ROLE = keccak256("ANGEL_ROLE");
912 
913     bytes32 public constant INITIAL_ROLE = keccak256("INITIAL_ROLE");
914 
915     bytes32 public constant INVITE_ROLE = keccak256("INVITE_ROLE");
916 
917     bytes32 public constant NODE_ROLE = keccak256("NODE_ROLE");
918 
919     bytes32 public constant PUBLIC_ROLE = keccak256("PUBLIC_ROLE");
920 
921     bytes32 public constant TRANS_ROLE = keccak256("TRANS_ROLE");
922 
923     uint256 public angel_count = 15;
924 
925     uint256 public initial_count = 3000;
926 
927     uint256 public invite_count = 3000;
928 
929     uint256 public node_count = 400;
930 
931     uint256 public invitor_count = 10;
932 
933 
934     uint256 public initial_threshold = 0.1 * 10 ** 18;
935 
936     uint256 public initial_after_threshold = 0.01 * 10 ** 18;
937 
938     bool public pri_switch = true;
939 
940     bool public inviter_switch = true;
941 
942     bool public node_switch = false;
943 
944     address public nodeReceiveAddress;
945 
946     uint256 public priSum = 0;
947 
948     uint256 public node_time = 0;
949 
950     address public summa;
951 
952     address public summaMode;
953 
954     /*
955     key current address
956     value parent address
957     */
958     mapping(address => address) private relations;
959 
960     mapping(address => uint256) private invitor;
961 
962     constructor(address summaAddr) public payable{
963         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
964         nodeReceiveAddress = _msgSender();
965         summa = summaAddr;
966     }
967 
968     function getRelation(address addr) public view returns (address){
969         return relations[addr];
970     }
971 
972     function getInvitor(address addr) public view returns (uint256){
973         return invitor[addr];
974     }
975 
976     function inviteCompetition(address from, address to) public {
977         if (relations[from] == address(0) && _msgSender() == summa && !hasRole(ANGEL_ROLE, from)) {
978             if(hasRole(PUBLIC_ROLE, to) && !hasRole(PUBLIC_ROLE, from)){
979                 relations[from] = to;
980                 _setupRole(PUBLIC_ROLE, from);
981                 invitor[to] = invitor[to].add(1);
982             }
983             if (inviter_switch && hasRole(PUBLIC_ROLE, to)) {
984                 if (invitor[to] >= invitor_count && !hasRole(INVITE_ROLE, to)) {
985                     _setupRole(INVITE_ROLE, to);
986                     if(!node_switch && node_time <= 0){
987                         node_switch = true;
988                         node_time = block.number;
989                     }
990 
991                 }
992             }
993         }
994     }
995 
996     function addNode(address addr) public returns (bool){
997         if (node_switch && _msgSender() == summaMode && hasRole(INVITE_ROLE, addr) && !hasRole(NODE_ROLE, addr)) {
998             _setupRole(NODE_ROLE, addr);
999             if (getRoleMemberCount(NODE_ROLE) >= node_count) {
1000                 node_switch = false;
1001                 inviter_switch = false;
1002             }
1003             return true;
1004         }
1005         return false;
1006     }
1007 
1008     function privateRule() internal {
1009         if (!hasRole(ANGEL_ROLE, _msgSender()) && getRoleMemberCount(ANGEL_ROLE) < angel_count) {
1010             _setupRole(ANGEL_ROLE, _msgSender());
1011             _setupRole(INITIAL_ROLE, _msgSender());
1012             _setupRole(PUBLIC_ROLE, _msgSender());
1013         }
1014         if (!hasRole(INITIAL_ROLE, _msgSender()) && getRoleMemberCount(INITIAL_ROLE) < initial_count) {
1015             _setupRole(INITIAL_ROLE, _msgSender());
1016         }
1017     }
1018 
1019     function updateInitialThreshold(uint256 amount) public {
1020         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1021         initial_threshold = amount;
1022     }
1023 
1024     function updateSumma(address contractAddress) public {
1025         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1026         summa = contractAddress;
1027     }
1028 
1029     function updatePriSwitch(bool _switch) public {
1030         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1031         pri_switch = _switch;
1032     }
1033 
1034     function updateSummaMode(address contractAddress) public {
1035         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1036         summaMode = contractAddress;
1037     }
1038 
1039     function updateNodeReceiveAddress(address addr) public {
1040         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1041         nodeReceiveAddress = addr;
1042     }
1043 
1044     function updateInitialAfterThreshold(uint256 amount) public {
1045         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1046         initial_after_threshold = amount;
1047     }
1048 
1049     function withdrawETH() public {
1050         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1051         msg.sender.transfer(address(this).balance);
1052     }
1053 
1054     function withdrawToken(address addr) public {
1055         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
1056         IERC20Sumswap(addr).transfer(_msgSender(), IERC20Sumswap(addr).balanceOf(address(this)));
1057     }
1058 
1059     function prePrivateRule() internal {
1060         if (getRoleMemberCount(INITIAL_ROLE) < initial_count) {
1061             if (msg.value >= initial_threshold) {
1062                 privateRule();
1063                 IERC20Sumswap(summa).transfer(_msgSender(), 5 * 10 ** 18);
1064                 priSum = priSum.add(1);
1065             }
1066         } else {
1067             if (msg.value >= initial_after_threshold) {
1068                 IERC20Sumswap(summa).transfer(_msgSender(), 0.1 * 10 ** 18);
1069                 priSum = priSum.add(1);
1070             }
1071         }
1072     }
1073 
1074     receive() external payable {
1075         if (!(Address.isContract(_msgSender())) && pri_switch) {
1076             prePrivateRule();
1077         }
1078     }
1079 }