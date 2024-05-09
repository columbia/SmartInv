1 pragma solidity 0.6.12;
2 
3 /**
4  * @dev Library for managing
5  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
6  * types.
7  *
8  * Sets have the following properties:
9  *
10  * - Elements are added, removed, and checked for existence in constant time
11  * (O(1)).
12  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
13  *
14  * ```
15  * contract Example {
16  *     // Add the library methods
17  *     using EnumerableSet for EnumerableSet.AddressSet;
18  *
19  *     // Declare a set state variable
20  *     EnumerableSet.AddressSet private mySet;
21  * }
22  * ```
23  *
24  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
25  * and `uint256` (`UintSet`) are supported.
26  */
27 library EnumerableSet {
28     // To implement this library for multiple types with as little code
29     // repetition as possible, we write it in terms of a generic Set type with
30     // bytes32 values.
31     // The Set implementation uses private functions, and user-facing
32     // implementations (such as AddressSet) are just wrappers around the
33     // underlying Set.
34     // This means that we can only create new EnumerableSets for types that fit
35     // in bytes32.
36 
37     struct Set {
38         // Storage of set values
39         bytes32[] _values;
40 
41         // Position of the value in the `values` array, plus 1 because index 0
42         // means a value is not in the set.
43         mapping (bytes32 => uint256) _indexes;
44     }
45 
46     /**
47      * @dev Add a value to a set. O(1).
48      *
49      * Returns true if the value was added to the set, that is if it was not
50      * already present.
51      */
52     function _add(Set storage set, bytes32 value) private returns (bool) {
53         if (!_contains(set, value)) {
54             set._values.push(value);
55             // The value is stored at length-1, but we add 1 to all indexes
56             // and use 0 as a sentinel value
57             set._indexes[value] = set._values.length;
58             return true;
59         } else {
60             return false;
61         }
62     }
63 
64     /**
65      * @dev Removes a value from a set. O(1).
66      *
67      * Returns true if the value was removed from the set, that is if it was
68      * present.
69      */
70     function _remove(Set storage set, bytes32 value) private returns (bool) {
71         // We read and store the value's index to prevent multiple reads from the same storage slot
72         uint256 valueIndex = set._indexes[value];
73 
74         if (valueIndex != 0) { // Equivalent to contains(set, value)
75             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
76             // the array, and then remove the last element (sometimes called as 'swap and pop').
77             // This modifies the order of the array, as noted in {at}.
78 
79             uint256 toDeleteIndex = valueIndex - 1;
80             uint256 lastIndex = set._values.length - 1;
81 
82             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
83             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
84 
85             bytes32 lastvalue = set._values[lastIndex];
86 
87             // Move the last value to the index where the value to delete is
88             set._values[toDeleteIndex] = lastvalue;
89             // Update the index for the moved value
90             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
91 
92             // Delete the slot where the moved value was stored
93             set._values.pop();
94 
95             // Delete the index for the deleted slot
96             delete set._indexes[value];
97 
98             return true;
99         } else {
100             return false;
101         }
102     }
103 
104     /**
105      * @dev Returns true if the value is in the set. O(1).
106      */
107     function _contains(Set storage set, bytes32 value) private view returns (bool) {
108         return set._indexes[value] != 0;
109     }
110 
111     /**
112      * @dev Returns the number of values on the set. O(1).
113      */
114     function _length(Set storage set) private view returns (uint256) {
115         return set._values.length;
116     }
117 
118    /**
119     * @dev Returns the value stored at position `index` in the set. O(1).
120     *
121     * Note that there are no guarantees on the ordering of values inside the
122     * array, and it may change when more values are added or removed.
123     *
124     * Requirements:
125     *
126     * - `index` must be strictly less than {length}.
127     */
128     function _at(Set storage set, uint256 index) private view returns (bytes32) {
129         require(set._values.length > index, "EnumerableSet: index out of bounds");
130         return set._values[index];
131     }
132 
133     // Bytes32Set
134 
135     struct Bytes32Set {
136         Set _inner;
137     }
138 
139     /**
140      * @dev Add a value to a set. O(1).
141      *
142      * Returns true if the value was added to the set, that is if it was not
143      * already present.
144      */
145     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
146         return _add(set._inner, value);
147     }
148 
149     /**
150      * @dev Removes a value from a set. O(1).
151      *
152      * Returns true if the value was removed from the set, that is if it was
153      * present.
154      */
155     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
156         return _remove(set._inner, value);
157     }
158 
159     /**
160      * @dev Returns true if the value is in the set. O(1).
161      */
162     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
163         return _contains(set._inner, value);
164     }
165 
166     /**
167      * @dev Returns the number of values in the set. O(1).
168      */
169     function length(Bytes32Set storage set) internal view returns (uint256) {
170         return _length(set._inner);
171     }
172 
173    /**
174     * @dev Returns the value stored at position `index` in the set. O(1).
175     *
176     * Note that there are no guarantees on the ordering of values inside the
177     * array, and it may change when more values are added or removed.
178     *
179     * Requirements:
180     *
181     * - `index` must be strictly less than {length}.
182     */
183     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
184         return _at(set._inner, index);
185     }
186 
187     // AddressSet
188 
189     struct AddressSet {
190         Set _inner;
191     }
192 
193     /**
194      * @dev Add a value to a set. O(1).
195      *
196      * Returns true if the value was added to the set, that is if it was not
197      * already present.
198      */
199     function add(AddressSet storage set, address value) internal returns (bool) {
200         return _add(set._inner, bytes32(uint256(value)));
201     }
202 
203     /**
204      * @dev Removes a value from a set. O(1).
205      *
206      * Returns true if the value was removed from the set, that is if it was
207      * present.
208      */
209     function remove(AddressSet storage set, address value) internal returns (bool) {
210         return _remove(set._inner, bytes32(uint256(value)));
211     }
212 
213     /**
214      * @dev Returns true if the value is in the set. O(1).
215      */
216     function contains(AddressSet storage set, address value) internal view returns (bool) {
217         return _contains(set._inner, bytes32(uint256(value)));
218     }
219 
220     /**
221      * @dev Returns the number of values in the set. O(1).
222      */
223     function length(AddressSet storage set) internal view returns (uint256) {
224         return _length(set._inner);
225     }
226 
227    /**
228     * @dev Returns the value stored at position `index` in the set. O(1).
229     *
230     * Note that there are no guarantees on the ordering of values inside the
231     * array, and it may change when more values are added or removed.
232     *
233     * Requirements:
234     *
235     * - `index` must be strictly less than {length}.
236     */
237     function at(AddressSet storage set, uint256 index) internal view returns (address) {
238         return address(uint256(_at(set._inner, index)));
239     }
240 
241 
242     // UintSet
243 
244     struct UintSet {
245         Set _inner;
246     }
247 
248     /**
249      * @dev Add a value to a set. O(1).
250      *
251      * Returns true if the value was added to the set, that is if it was not
252      * already present.
253      */
254     function add(UintSet storage set, uint256 value) internal returns (bool) {
255         return _add(set._inner, bytes32(value));
256     }
257 
258     /**
259      * @dev Removes a value from a set. O(1).
260      *
261      * Returns true if the value was removed from the set, that is if it was
262      * present.
263      */
264     function remove(UintSet storage set, uint256 value) internal returns (bool) {
265         return _remove(set._inner, bytes32(value));
266     }
267 
268     /**
269      * @dev Returns true if the value is in the set. O(1).
270      */
271     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
272         return _contains(set._inner, bytes32(value));
273     }
274 
275     /**
276      * @dev Returns the number of values on the set. O(1).
277      */
278     function length(UintSet storage set) internal view returns (uint256) {
279         return _length(set._inner);
280     }
281 
282    /**
283     * @dev Returns the value stored at position `index` in the set. O(1).
284     *
285     * Note that there are no guarantees on the ordering of values inside the
286     * array, and it may change when more values are added or removed.
287     *
288     * Requirements:
289     *
290     * - `index` must be strictly less than {length}.
291     */
292     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
293         return uint256(_at(set._inner, index));
294     }
295 }
296 
297 
298 /**
299  * @dev Collection of functions related to the address type
300  */
301 library Address {
302     /**
303      * @dev Returns true if `account` is a contract.
304      *
305      * [IMPORTANT]
306      * ====
307      * It is unsafe to assume that an address for which this function returns
308      * false is an externally-owned account (EOA) and not a contract.
309      *
310      * Among others, `isContract` will return false for the following
311      * types of addresses:
312      *
313      *  - an externally-owned account
314      *  - a contract in construction
315      *  - an address where a contract will be created
316      *  - an address where a contract lived, but was destroyed
317      * ====
318      */
319     function isContract(address account) internal view returns (bool) {
320         // This method relies on extcodesize, which returns 0 for contracts in
321         // construction, since the code is only stored at the end of the
322         // constructor execution.
323 
324         uint256 size;
325         // solhint-disable-next-line no-inline-assembly
326         assembly { size := extcodesize(account) }
327         return size > 0;
328     }
329 
330     /**
331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
332      * `recipient`, forwarding all available gas and reverting on errors.
333      *
334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
336      * imposed by `transfer`, making them unable to receive funds via
337      * `transfer`. {sendValue} removes this limitation.
338      *
339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
340      *
341      * IMPORTANT: because control is transferred to `recipient`, care must be
342      * taken to not create reentrancy vulnerabilities. Consider using
343      * {ReentrancyGuard} or the
344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(address(this).balance >= amount, "Address: insufficient balance");
348 
349         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
350         (bool success, ) = recipient.call{ value: amount }("");
351         require(success, "Address: unable to send value, recipient may have reverted");
352     }
353 
354     /**
355      * @dev Performs a Solidity function call using a low level `call`. A
356      * plain`call` is an unsafe replacement for a function call: use this
357      * function instead.
358      *
359      * If `target` reverts with a revert reason, it is bubbled up by this
360      * function (like regular Solidity function calls).
361      *
362      * Returns the raw returned data. To convert to the expected return value,
363      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
364      *
365      * Requirements:
366      *
367      * - `target` must be a contract.
368      * - calling `target` with `data` must not revert.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
373       return functionCall(target, data, "Address: low-level call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
378      * `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, 0, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but also transferring `value` wei to `target`.
389      *
390      * Requirements:
391      *
392      * - the calling contract must have an ETH balance of at least `value`.
393      * - the called Solidity function must be `payable`.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
403      * with `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
408         require(address(this).balance >= value, "Address: insufficient balance for call");
409         require(isContract(target), "Address: call to non-contract");
410 
411         // solhint-disable-next-line avoid-low-level-calls
412         (bool success, bytes memory returndata) = target.call{ value: value }(data);
413         return _verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
423         return functionStaticCall(target, data, "Address: low-level static call failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
433         require(isContract(target), "Address: static call to non-contract");
434 
435         // solhint-disable-next-line avoid-low-level-calls
436         (bool success, bytes memory returndata) = target.staticcall(data);
437         return _verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 // solhint-disable-next-line no-inline-assembly
449                 assembly {
450                     let returndata_size := mload(returndata)
451                     revert(add(32, returndata), returndata_size)
452                 }
453             } else {
454                 revert(errorMessage);
455             }
456         }
457     }
458 }
459 
460 
461 /*
462  * @dev Provides information about the current execution context, including the
463  * sender of the transaction and its data. While these are generally available
464  * via msg.sender and msg.data, they should not be accessed in such a direct
465  * manner, since when dealing with GSN meta-transactions the account sending and
466  * paying for execution may not be the actual sender (as far as an application
467  * is concerned).
468  *
469  * This contract is only required for intermediate, library-like contracts.
470  */
471 abstract contract Context {
472     function _msgSender() internal view virtual returns (address payable) {
473         return msg.sender;
474     }
475 
476     function _msgData() internal view virtual returns (bytes memory) {
477         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
478         return msg.data;
479     }
480 }
481 
482 
483 /**
484  * @dev Contract module that allows children to implement role-based access
485  * control mechanisms.
486  *
487  * Roles are referred to by their `bytes32` identifier. These should be exposed
488  * in the external API and be unique. The best way to achieve this is by
489  * using `public constant` hash digests:
490  *
491  * ```
492  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
493  * ```
494  *
495  * Roles can be used to represent a set of permissions. To restrict access to a
496  * function call, use {hasRole}:
497  *
498  * ```
499  * function foo() public {
500  *     require(hasRole(MY_ROLE, msg.sender));
501  *     ...
502  * }
503  * ```
504  *
505  * Roles can be granted and revoked dynamically via the {grantRole} and
506  * {revokeRole} functions. Each role has an associated admin role, and only
507  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
508  *
509  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
510  * that only accounts with this role will be able to grant or revoke other
511  * roles. More complex role relationships can be created by using
512  * {_setRoleAdmin}.
513  *
514  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
515  * grant and revoke this role. Extra precautions should be taken to secure
516  * accounts that have been granted it.
517  */
518 abstract contract AccessControl is Context {
519     using EnumerableSet for EnumerableSet.AddressSet;
520     using Address for address;
521 
522     struct RoleData {
523         EnumerableSet.AddressSet members;
524         bytes32 adminRole;
525     }
526 
527     mapping (bytes32 => RoleData) private _roles;
528 
529     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
530 
531     /**
532      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
533      *
534      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
535      * {RoleAdminChanged} not being emitted signaling this.
536      *
537      * _Available since v3.1._
538      */
539     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
540 
541     /**
542      * @dev Emitted when `account` is granted `role`.
543      *
544      * `sender` is the account that originated the contract call, an admin role
545      * bearer except when using {_setupRole}.
546      */
547     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
548 
549     /**
550      * @dev Emitted when `account` is revoked `role`.
551      *
552      * `sender` is the account that originated the contract call:
553      *   - if using `revokeRole`, it is the admin role bearer
554      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
555      */
556     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
557 
558     /**
559      * @dev Returns `true` if `account` has been granted `role`.
560      */
561     function hasRole(bytes32 role, address account) public view returns (bool) {
562         return _roles[role].members.contains(account);
563     }
564 
565     /**
566      * @dev Returns the number of accounts that have `role`. Can be used
567      * together with {getRoleMember} to enumerate all bearers of a role.
568      */
569     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
570         return _roles[role].members.length();
571     }
572 
573     /**
574      * @dev Returns one of the accounts that have `role`. `index` must be a
575      * value between 0 and {getRoleMemberCount}, non-inclusive.
576      *
577      * Role bearers are not sorted in any particular way, and their ordering may
578      * change at any point.
579      *
580      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
581      * you perform all queries on the same block. See the following
582      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
583      * for more information.
584      */
585     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
586         return _roles[role].members.at(index);
587     }
588 
589     /**
590      * @dev Returns the admin role that controls `role`. See {grantRole} and
591      * {revokeRole}.
592      *
593      * To change a role's admin, use {_setRoleAdmin}.
594      */
595     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
596         return _roles[role].adminRole;
597     }
598 
599     /**
600      * @dev Grants `role` to `account`.
601      *
602      * If `account` had not been already granted `role`, emits a {RoleGranted}
603      * event.
604      *
605      * Requirements:
606      *
607      * - the caller must have ``role``'s admin role.
608      */
609     function grantRole(bytes32 role, address account) public virtual {
610         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
611 
612         _grantRole(role, account);
613     }
614 
615     /**
616      * @dev Revokes `role` from `account`.
617      *
618      * If `account` had been granted `role`, emits a {RoleRevoked} event.
619      *
620      * Requirements:
621      *
622      * - the caller must have ``role``'s admin role.
623      */
624     function revokeRole(bytes32 role, address account) public virtual {
625         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
626 
627         _revokeRole(role, account);
628     }
629 
630     /**
631      * @dev Revokes `role` from the calling account.
632      *
633      * Roles are often managed via {grantRole} and {revokeRole}: this function's
634      * purpose is to provide a mechanism for accounts to lose their privileges
635      * if they are compromised (such as when a trusted device is misplaced).
636      *
637      * If the calling account had been granted `role`, emits a {RoleRevoked}
638      * event.
639      *
640      * Requirements:
641      *
642      * - the caller must be `account`.
643      */
644     function renounceRole(bytes32 role, address account) public virtual {
645         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
646 
647         _revokeRole(role, account);
648     }
649 
650     /**
651      * @dev Grants `role` to `account`.
652      *
653      * If `account` had not been already granted `role`, emits a {RoleGranted}
654      * event. Note that unlike {grantRole}, this function doesn't perform any
655      * checks on the calling account.
656      *
657      * [WARNING]
658      * ====
659      * This function should only be called from the constructor when setting
660      * up the initial roles for the system.
661      *
662      * Using this function in any other way is effectively circumventing the admin
663      * system imposed by {AccessControl}.
664      * ====
665      */
666     function _setupRole(bytes32 role, address account) internal virtual {
667         _grantRole(role, account);
668     }
669 
670     /**
671      * @dev Sets `adminRole` as ``role``'s admin role.
672      *
673      * Emits a {RoleAdminChanged} event.
674      */
675     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
676         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
677         _roles[role].adminRole = adminRole;
678     }
679 
680     function _grantRole(bytes32 role, address account) private {
681         if (_roles[role].members.add(account)) {
682             emit RoleGranted(role, account, _msgSender());
683         }
684     }
685 
686     function _revokeRole(bytes32 role, address account) private {
687         if (_roles[role].members.remove(account)) {
688             emit RoleRevoked(role, account, _msgSender());
689         }
690     }
691 }
692 
693 
694 /**
695  * @dev Interface of the ERC20 standard as defined in the EIP.
696  */
697 interface IERC20 {
698     /**
699      * @dev Returns the amount of tokens in existence.
700      */
701     function totalSupply() external view returns (uint256);
702 
703     /**
704      * @dev Returns the amount of tokens owned by `account`.
705      */
706     function balanceOf(address account) external view returns (uint256);
707 
708     /**
709      * @dev Moves `amount` tokens from the caller's account to `recipient`.
710      *
711      * Returns a boolean value indicating whether the operation succeeded.
712      *
713      * Emits a {Transfer} event.
714      */
715     function transfer(address recipient, uint256 amount) external returns (bool);
716 
717     /**
718      * @dev Returns the remaining number of tokens that `spender` will be
719      * allowed to spend on behalf of `owner` through {transferFrom}. This is
720      * zero by default.
721      *
722      * This value changes when {approve} or {transferFrom} are called.
723      */
724     function allowance(address owner, address spender) external view returns (uint256);
725 
726     /**
727      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
728      *
729      * Returns a boolean value indicating whether the operation succeeded.
730      *
731      * IMPORTANT: Beware that changing an allowance with this method brings the risk
732      * that someone may use both the old and the new allowance by unfortunate
733      * transaction ordering. One possible solution to mitigate this race
734      * condition is to first reduce the spender's allowance to 0 and set the
735      * desired value afterwards:
736      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
737      *
738      * Emits an {Approval} event.
739      */
740     function approve(address spender, uint256 amount) external returns (bool);
741 
742     /**
743      * @dev Moves `amount` tokens from `sender` to `recipient` using the
744      * allowance mechanism. `amount` is then deducted from the caller's
745      * allowance.
746      *
747      * Returns a boolean value indicating whether the operation succeeded.
748      *
749      * Emits a {Transfer} event.
750      */
751     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
752 
753     /**
754      * @dev Emitted when `value` tokens are moved from one account (`from`) to
755      * another (`to`).
756      *
757      * Note that `value` may be zero.
758      */
759     event Transfer(address indexed from, address indexed to, uint256 value);
760 
761     /**
762      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
763      * a call to {approve}. `value` is the new allowance.
764      */
765     event Approval(address indexed owner, address indexed spender, uint256 value);
766 }
767 
768 
769 /**
770  * @dev Wrappers over Solidity's arithmetic operations with added overflow
771  * checks.
772  *
773  * Arithmetic operations in Solidity wrap on overflow. This can easily result
774  * in bugs, because programmers usually assume that an overflow raises an
775  * error, which is the standard behavior in high level programming languages.
776  * `SafeMath` restores this intuition by reverting the transaction when an
777  * operation overflows.
778  *
779  * Using this library instead of the unchecked operations eliminates an entire
780  * class of bugs, so it's recommended to use it always.
781  */
782 library SafeMath {
783     /**
784      * @dev Returns the addition of two unsigned integers, reverting on
785      * overflow.
786      *
787      * Counterpart to Solidity's `+` operator.
788      *
789      * Requirements:
790      *
791      * - Addition cannot overflow.
792      */
793     function add(uint256 a, uint256 b) internal pure returns (uint256) {
794         uint256 c = a + b;
795         require(c >= a, "SafeMath: addition overflow");
796 
797         return c;
798     }
799 
800     /**
801      * @dev Returns the subtraction of two unsigned integers, reverting on
802      * overflow (when the result is negative).
803      *
804      * Counterpart to Solidity's `-` operator.
805      *
806      * Requirements:
807      *
808      * - Subtraction cannot overflow.
809      */
810     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
811         return sub(a, b, "SafeMath: subtraction overflow");
812     }
813 
814     /**
815      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
816      * overflow (when the result is negative).
817      *
818      * Counterpart to Solidity's `-` operator.
819      *
820      * Requirements:
821      *
822      * - Subtraction cannot overflow.
823      */
824     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
825         require(b <= a, errorMessage);
826         uint256 c = a - b;
827 
828         return c;
829     }
830 
831     /**
832      * @dev Returns the multiplication of two unsigned integers, reverting on
833      * overflow.
834      *
835      * Counterpart to Solidity's `*` operator.
836      *
837      * Requirements:
838      *
839      * - Multiplication cannot overflow.
840      */
841     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
842         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
843         // benefit is lost if 'b' is also tested.
844         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
845         if (a == 0) {
846             return 0;
847         }
848 
849         uint256 c = a * b;
850         require(c / a == b, "SafeMath: multiplication overflow");
851 
852         return c;
853     }
854 
855     /**
856      * @dev Returns the integer division of two unsigned integers. Reverts on
857      * division by zero. The result is rounded towards zero.
858      *
859      * Counterpart to Solidity's `/` operator. Note: this function uses a
860      * `revert` opcode (which leaves remaining gas untouched) while Solidity
861      * uses an invalid opcode to revert (consuming all remaining gas).
862      *
863      * Requirements:
864      *
865      * - The divisor cannot be zero.
866      */
867     function div(uint256 a, uint256 b) internal pure returns (uint256) {
868         return div(a, b, "SafeMath: division by zero");
869     }
870 
871     /**
872      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
873      * division by zero. The result is rounded towards zero.
874      *
875      * Counterpart to Solidity's `/` operator. Note: this function uses a
876      * `revert` opcode (which leaves remaining gas untouched) while Solidity
877      * uses an invalid opcode to revert (consuming all remaining gas).
878      *
879      * Requirements:
880      *
881      * - The divisor cannot be zero.
882      */
883     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
884         require(b > 0, errorMessage);
885         uint256 c = a / b;
886         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
887 
888         return c;
889     }
890 
891     /**
892      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
893      * Reverts when dividing by zero.
894      *
895      * Counterpart to Solidity's `%` operator. This function uses a `revert`
896      * opcode (which leaves remaining gas untouched) while Solidity uses an
897      * invalid opcode to revert (consuming all remaining gas).
898      *
899      * Requirements:
900      *
901      * - The divisor cannot be zero.
902      */
903     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
904         return mod(a, b, "SafeMath: modulo by zero");
905     }
906 
907     /**
908      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
909      * Reverts with custom message when dividing by zero.
910      *
911      * Counterpart to Solidity's `%` operator. This function uses a `revert`
912      * opcode (which leaves remaining gas untouched) while Solidity uses an
913      * invalid opcode to revert (consuming all remaining gas).
914      *
915      * Requirements:
916      *
917      * - The divisor cannot be zero.
918      */
919     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
920         require(b != 0, errorMessage);
921         return a % b;
922     }
923 }
924 
925 
926 /**
927  * @dev Implementation of the {IERC20} interface.
928  *
929  * This implementation is agnostic to the way tokens are created. This means
930  * that a supply mechanism has to be added in a derived contract using {_mint}.
931  * For a generic mechanism see {ERC20PresetMinterPauser}.
932  *
933  * TIP: For a detailed writeup see our guide
934  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
935  * to implement supply mechanisms].
936  *
937  * We have followed general OpenZeppelin guidelines: functions revert instead
938  * of returning `false` on failure. This behavior is nonetheless conventional
939  * and does not conflict with the expectations of ERC20 applications.
940  *
941  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
942  * This allows applications to reconstruct the allowance for all accounts just
943  * by listening to said events. Other implementations of the EIP may not emit
944  * these events, as it isn't required by the specification.
945  *
946  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
947  * functions have been added to mitigate the well-known issues around setting
948  * allowances. See {IERC20-approve}.
949  */
950 contract ERC20 is Context, IERC20 {
951     using SafeMath for uint256;
952 
953     mapping (address => uint256) private _balances;
954 
955     mapping (address => mapping (address => uint256)) private _allowances;
956 
957     uint256 private _totalSupply;
958 
959     string private _name;
960     string private _symbol;
961     uint8 private _decimals;
962 
963     /**
964      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
965      * a default value of 18.
966      *
967      * To select a different value for {decimals}, use {_setupDecimals}.
968      *
969      * All three of these values are immutable: they can only be set once during
970      * construction.
971      */
972     constructor (string memory name_, string memory symbol_) public {
973         _name = name_;
974         _symbol = symbol_;
975         _decimals = 18;
976     }
977 
978     /**
979      * @dev Returns the name of the token.
980      */
981     function name() public view returns (string memory) {
982         return _name;
983     }
984 
985     /**
986      * @dev Returns the symbol of the token, usually a shorter version of the
987      * name.
988      */
989     function symbol() public view returns (string memory) {
990         return _symbol;
991     }
992 
993     /**
994      * @dev Returns the number of decimals used to get its user representation.
995      * For example, if `decimals` equals `2`, a balance of `505` tokens should
996      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
997      *
998      * Tokens usually opt for a value of 18, imitating the relationship between
999      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1000      * called.
1001      *
1002      * NOTE: This information is only used for _display_ purposes: it in
1003      * no way affects any of the arithmetic of the contract, including
1004      * {IERC20-balanceOf} and {IERC20-transfer}.
1005      */
1006     function decimals() public view returns (uint8) {
1007         return _decimals;
1008     }
1009 
1010     /**
1011      * @dev See {IERC20-totalSupply}.
1012      */
1013     function totalSupply() public view override returns (uint256) {
1014         return _totalSupply;
1015     }
1016 
1017     /**
1018      * @dev See {IERC20-balanceOf}.
1019      */
1020     function balanceOf(address account) public view override returns (uint256) {
1021         return _balances[account];
1022     }
1023 
1024     /**
1025      * @dev See {IERC20-transfer}.
1026      *
1027      * Requirements:
1028      *
1029      * - `recipient` cannot be the zero address.
1030      * - the caller must have a balance of at least `amount`.
1031      */
1032     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1033         _transfer(_msgSender(), recipient, amount);
1034         return true;
1035     }
1036 
1037     /**
1038      * @dev See {IERC20-allowance}.
1039      */
1040     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1041         return _allowances[owner][spender];
1042     }
1043 
1044     /**
1045      * @dev See {IERC20-approve}.
1046      *
1047      * Requirements:
1048      *
1049      * - `spender` cannot be the zero address.
1050      */
1051     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1052         _approve(_msgSender(), spender, amount);
1053         return true;
1054     }
1055 
1056     /**
1057      * @dev See {IERC20-transferFrom}.
1058      *
1059      * Emits an {Approval} event indicating the updated allowance. This is not
1060      * required by the EIP. See the note at the beginning of {ERC20}.
1061      *
1062      * Requirements:
1063      *
1064      * - `sender` and `recipient` cannot be the zero address.
1065      * - `sender` must have a balance of at least `amount`.
1066      * - the caller must have allowance for ``sender``'s tokens of at least
1067      * `amount`.
1068      */
1069     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1070         _transfer(sender, recipient, amount);
1071         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1072         return true;
1073     }
1074 
1075     /**
1076      * @dev Atomically increases the allowance granted to `spender` by the caller.
1077      *
1078      * This is an alternative to {approve} that can be used as a mitigation for
1079      * problems described in {IERC20-approve}.
1080      *
1081      * Emits an {Approval} event indicating the updated allowance.
1082      *
1083      * Requirements:
1084      *
1085      * - `spender` cannot be the zero address.
1086      */
1087     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1088         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1089         return true;
1090     }
1091 
1092     /**
1093      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1094      *
1095      * This is an alternative to {approve} that can be used as a mitigation for
1096      * problems described in {IERC20-approve}.
1097      *
1098      * Emits an {Approval} event indicating the updated allowance.
1099      *
1100      * Requirements:
1101      *
1102      * - `spender` cannot be the zero address.
1103      * - `spender` must have allowance for the caller of at least
1104      * `subtractedValue`.
1105      */
1106     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1107         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1108         return true;
1109     }
1110 
1111     /**
1112      * @dev Moves tokens `amount` from `sender` to `recipient`.
1113      *
1114      * This is internal function is equivalent to {transfer}, and can be used to
1115      * e.g. implement automatic token fees, slashing mechanisms, etc.
1116      *
1117      * Emits a {Transfer} event.
1118      *
1119      * Requirements:
1120      *
1121      * - `sender` cannot be the zero address.
1122      * - `recipient` cannot be the zero address.
1123      * - `sender` must have a balance of at least `amount`.
1124      */
1125     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1126         require(sender != address(0), "ERC20: transfer from the zero address");
1127         require(recipient != address(0), "ERC20: transfer to the zero address");
1128 
1129         _beforeTokenTransfer(sender, recipient, amount);
1130 
1131         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1132         _balances[recipient] = _balances[recipient].add(amount);
1133         emit Transfer(sender, recipient, amount);
1134     }
1135 
1136     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1137      * the total supply.
1138      *
1139      * Emits a {Transfer} event with `from` set to the zero address.
1140      *
1141      * Requirements:
1142      *
1143      * - `to` cannot be the zero address.
1144      */
1145     function _mint(address account, uint256 amount) internal virtual {
1146         require(account != address(0), "ERC20: mint to the zero address");
1147 
1148         _beforeTokenTransfer(address(0), account, amount);
1149 
1150         _totalSupply = _totalSupply.add(amount);
1151         _balances[account] = _balances[account].add(amount);
1152         emit Transfer(address(0), account, amount);
1153     }
1154 
1155     /**
1156      * @dev Destroys `amount` tokens from `account`, reducing the
1157      * total supply.
1158      *
1159      * Emits a {Transfer} event with `to` set to the zero address.
1160      *
1161      * Requirements:
1162      *
1163      * - `account` cannot be the zero address.
1164      * - `account` must have at least `amount` tokens.
1165      */
1166     function _burn(address account, uint256 amount) internal virtual {
1167         require(account != address(0), "ERC20: burn from the zero address");
1168 
1169         _beforeTokenTransfer(account, address(0), amount);
1170 
1171         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1172         _totalSupply = _totalSupply.sub(amount);
1173         emit Transfer(account, address(0), amount);
1174     }
1175 
1176     /**
1177      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1178      *
1179      * This internal function is equivalent to `approve`, and can be used to
1180      * e.g. set automatic allowances for certain subsystems, etc.
1181      *
1182      * Emits an {Approval} event.
1183      *
1184      * Requirements:
1185      *
1186      * - `owner` cannot be the zero address.
1187      * - `spender` cannot be the zero address.
1188      */
1189     function _approve(address owner, address spender, uint256 amount) internal virtual {
1190         require(owner != address(0), "ERC20: approve from the zero address");
1191         require(spender != address(0), "ERC20: approve to the zero address");
1192 
1193         _allowances[owner][spender] = amount;
1194         emit Approval(owner, spender, amount);
1195     }
1196 
1197     /**
1198      * @dev Sets {decimals} to a value other than the default one of 18.
1199      *
1200      * WARNING: This function should only be called from the constructor. Most
1201      * applications that interact with token contracts will not expect
1202      * {decimals} to ever change, and may work incorrectly if it does.
1203      */
1204     function _setupDecimals(uint8 decimals_) internal {
1205         _decimals = decimals_;
1206     }
1207 
1208     /**
1209      * @dev Hook that is called before any transfer of tokens. This includes
1210      * minting and burning.
1211      *
1212      * Calling conditions:
1213      *
1214      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1215      * will be to transferred to `to`.
1216      * - when `from` is zero, `amount` tokens will be minted for `to`.
1217      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1218      * - `from` and `to` are never both zero.
1219      *
1220      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1221      */
1222     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1223 }
1224 
1225 
1226 // Copied and modified from SUSHI code:
1227 // https://github.com/sushiswap/sushiswap/blob/master/contracts/SushiToken.sol
1228 // WePiggyToken with Governance.
1229 contract WePiggyToken is ERC20, AccessControl {
1230 
1231     // Create a new role identifier for the minter role
1232     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1233 
1234     constructor() public ERC20("WePiggy Coin", "WPC") {
1235 
1236         // Grant the contract deployer the default admin role: it will be able
1237         // to grant and revoke any roles
1238         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1239         _setupRole(MINTER_ROLE, msg.sender);
1240         mint(msg.sender,8000000000000000000000000000);
1241     }
1242 
1243     /// @notice Creates `_amount` token to `_to`.Must only be called by the minter role.
1244     function mint(address _to, uint256 _amount) public {
1245 
1246         // Check that the calling account has the minter role
1247         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1248 
1249         _mint(_to, _amount);
1250         _moveDelegates(address(0), _delegates[_to], _amount);
1251     }
1252 
1253     function burn(address account, uint256 amount) public {
1254         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1255 
1256         _burn(account, amount);
1257         _moveDelegates(_delegates[account], address(0), amount);
1258     }
1259 
1260     //  transfers delegate authority when sending a token.
1261     // https://medium.com/bulldax-finance/sushiswap-delegation-double-spending-bug-5adcc7b3830f
1262     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
1263         super._transfer(sender, recipient, amount);
1264         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1265     }
1266 
1267     // Copied and modified from YAM code:
1268     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1269     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1270     // Which is copied and modified from COMPOUND:
1271     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1272 
1273     /// @dev A record of each accounts delegate
1274     mapping(address => address) internal _delegates;
1275 
1276     /// @notice A checkpoint for marking number of votes from a given block
1277     struct Checkpoint {
1278         uint32 fromBlock;
1279         uint256 votes;
1280     }
1281 
1282     /// @notice A record of votes checkpoints for each account, by index
1283     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1284 
1285     /// @notice The number of checkpoints for each account
1286     mapping(address => uint32) public numCheckpoints;
1287 
1288     /// @notice The EIP-712 typehash for the contract's domain
1289     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1290 
1291     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1292     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1293 
1294     /// @notice A record of states for signing / validating signatures
1295     mapping(address => uint) public nonces;
1296 
1297     /// @notice An event thats emitted when an account changes its delegate
1298     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1299 
1300     /// @notice An event thats emitted when a delegate account's vote balance changes
1301     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1302 
1303     /**
1304      * @notice Delegate votes from `msg.sender` to `delegatee`
1305      * @param delegator The address to get delegatee for
1306      */
1307     function delegates(address delegator)
1308     external
1309     view
1310     returns (address)
1311     {
1312         return _delegates[delegator];
1313     }
1314 
1315     /**
1316      * @notice Delegate votes from `msg.sender` to `delegatee`
1317      * @param delegatee The address to delegate votes to
1318      */
1319     function delegate(address delegatee) external {
1320         return _delegate(msg.sender, delegatee);
1321     }
1322 
1323     /**
1324      * @notice Delegates votes from signatory to `delegatee`
1325      * @param delegatee The address to delegate votes to
1326      * @param nonce The contract state required to match the signature
1327      * @param expiry The time at which to expire the signature
1328      * @param v The recovery byte of the signature
1329      * @param r Half of the ECDSA signature pair
1330      * @param s Half of the ECDSA signature pair
1331      */
1332     function delegateBySig(
1333         address delegatee,
1334         uint nonce,
1335         uint expiry,
1336         uint8 v,
1337         bytes32 r,
1338         bytes32 s
1339     )
1340     external
1341     {
1342         bytes32 domainSeparator = keccak256(
1343             abi.encode(
1344                 DOMAIN_TYPEHASH,
1345                 keccak256(bytes(name())),
1346                 getChainId(),
1347                 address(this)
1348             )
1349         );
1350 
1351         bytes32 structHash = keccak256(
1352             abi.encode(
1353                 DELEGATION_TYPEHASH,
1354                 delegatee,
1355                 nonce,
1356                 expiry
1357             )
1358         );
1359 
1360         bytes32 digest = keccak256(
1361             abi.encodePacked(
1362                 "\x19\x01",
1363                 domainSeparator,
1364                 structHash
1365             )
1366         );
1367 
1368         address signatory = ecrecover(digest, v, r, s);
1369         require(signatory != address(0), "WePiggyToken::delegateBySig: invalid signature");
1370         require(nonce == nonces[signatory]++, "WePiggyToken::delegateBySig: invalid nonce");
1371         require(now <= expiry, "WePiggyToken::delegateBySig: signature expired");
1372         return _delegate(signatory, delegatee);
1373     }
1374 
1375     /**
1376      * @notice Gets the current votes balance for `account`
1377      * @param account The address to get votes balance
1378      * @return The number of current votes for `account`
1379      */
1380     function getCurrentVotes(address account)
1381     external
1382     view
1383     returns (uint256)
1384     {
1385         uint32 nCheckpoints = numCheckpoints[account];
1386         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1387     }
1388 
1389     /**
1390      * @notice Determine the prior number of votes for an account as of a block number
1391      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1392      * @param account The address of the account to check
1393      * @param blockNumber The block number to get the vote balance at
1394      * @return The number of votes the account had as of the given block
1395      */
1396     function getPriorVotes(address account, uint blockNumber)
1397     external
1398     view
1399     returns (uint256)
1400     {
1401         require(blockNumber < block.number, "WePiggyToken::getPriorVotes: not yet determined");
1402 
1403         uint32 nCheckpoints = numCheckpoints[account];
1404         if (nCheckpoints == 0) {
1405             return 0;
1406         }
1407 
1408         // First check most recent balance
1409         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1410             return checkpoints[account][nCheckpoints - 1].votes;
1411         }
1412 
1413         // Next check implicit zero balance
1414         if (checkpoints[account][0].fromBlock > blockNumber) {
1415             return 0;
1416         }
1417 
1418         uint32 lower = 0;
1419         uint32 upper = nCheckpoints - 1;
1420         while (upper > lower) {
1421             // ceil, avoiding overflow
1422             uint32 center = upper - (upper - lower) / 2;
1423             Checkpoint memory cp = checkpoints[account][center];
1424             if (cp.fromBlock == blockNumber) {
1425                 return cp.votes;
1426             } else if (cp.fromBlock < blockNumber) {
1427                 lower = center;
1428             } else {
1429                 upper = center - 1;
1430             }
1431         }
1432         return checkpoints[account][lower].votes;
1433     }
1434 
1435     function _delegate(address delegator, address delegatee)
1436     internal
1437     {
1438         address currentDelegate = _delegates[delegator];
1439         // balance of underlying WePiggyTokens (not scaled);
1440         uint256 delegatorBalance = balanceOf(delegator);
1441 
1442         _delegates[delegator] = delegatee;
1443 
1444         emit DelegateChanged(delegator, currentDelegate, delegatee);
1445 
1446         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1447     }
1448 
1449     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1450         if (srcRep != dstRep && amount > 0) {
1451             if (srcRep != address(0)) {
1452                 // decrease old representative
1453                 uint32 srcRepNum = numCheckpoints[srcRep];
1454                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1455                 uint256 srcRepNew = srcRepOld.sub(amount);
1456                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1457             }
1458 
1459             if (dstRep != address(0)) {
1460                 // increase new representative
1461                 uint32 dstRepNum = numCheckpoints[dstRep];
1462                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1463                 uint256 dstRepNew = dstRepOld.add(amount);
1464                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1465             }
1466         }
1467     }
1468 
1469     function _writeCheckpoint(
1470         address delegatee,
1471         uint32 nCheckpoints,
1472         uint256 oldVotes,
1473         uint256 newVotes
1474     )
1475     internal
1476     {
1477         uint32 blockNumber = safe32(block.number, "WePiggyToken::_writeCheckpoint: block number exceeds 32 bits");
1478 
1479         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1480             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1481         } else {
1482             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1483             numCheckpoints[delegatee] = nCheckpoints + 1;
1484         }
1485 
1486         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1487     }
1488 
1489     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1490         require(n < 2 ** 32, errorMessage);
1491         return uint32(n);
1492     }
1493 
1494     function getChainId() internal pure returns (uint) {
1495         uint256 chainId;
1496         assembly {chainId := chainid()}
1497         return chainId;
1498     }
1499 
1500 
1501 }