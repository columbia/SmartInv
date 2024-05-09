1 // Sources flattened with hardhat v2.0.5 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.3.0
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
301 
302 // File @openzeppelin/contracts/utils/Address.sol@v3.3.0
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
469 
470 // File @openzeppelin/contracts/GSN/Context.sol@v3.3.0
471 
472 pragma solidity >=0.6.0 <0.8.0;
473 
474 /*
475  * @dev Provides information about the current execution context, including the
476  * sender of the transaction and its data. While these are generally available
477  * via msg.sender and msg.data, they should not be accessed in such a direct
478  * manner, since when dealing with GSN meta-transactions the account sending and
479  * paying for execution may not be the actual sender (as far as an application
480  * is concerned).
481  *
482  * This contract is only required for intermediate, library-like contracts.
483  */
484 abstract contract Context {
485     function _msgSender() internal view virtual returns (address payable) {
486         return msg.sender;
487     }
488 
489     function _msgData() internal view virtual returns (bytes memory) {
490         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
491         return msg.data;
492     }
493 }
494 
495 
496 // File @openzeppelin/contracts/access/AccessControl.sol@v3.3.0
497 
498 pragma solidity >=0.6.0 <0.8.0;
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
712 
713 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0
714 
715 pragma solidity >=0.6.0 <0.8.0;
716 
717 /**
718  * @dev Interface of the ERC20 standard as defined in the EIP.
719  */
720 interface IERC20 {
721     /**
722      * @dev Returns the amount of tokens in existence.
723      */
724     function totalSupply() external view returns (uint256);
725 
726     /**
727      * @dev Returns the amount of tokens owned by `account`.
728      */
729     function balanceOf(address account) external view returns (uint256);
730 
731     /**
732      * @dev Moves `amount` tokens from the caller's account to `recipient`.
733      *
734      * Returns a boolean value indicating whether the operation succeeded.
735      *
736      * Emits a {Transfer} event.
737      */
738     function transfer(address recipient, uint256 amount) external returns (bool);
739 
740     /**
741      * @dev Returns the remaining number of tokens that `spender` will be
742      * allowed to spend on behalf of `owner` through {transferFrom}. This is
743      * zero by default.
744      *
745      * This value changes when {approve} or {transferFrom} are called.
746      */
747     function allowance(address owner, address spender) external view returns (uint256);
748 
749     /**
750      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
751      *
752      * Returns a boolean value indicating whether the operation succeeded.
753      *
754      * IMPORTANT: Beware that changing an allowance with this method brings the risk
755      * that someone may use both the old and the new allowance by unfortunate
756      * transaction ordering. One possible solution to mitigate this race
757      * condition is to first reduce the spender's allowance to 0 and set the
758      * desired value afterwards:
759      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
760      *
761      * Emits an {Approval} event.
762      */
763     function approve(address spender, uint256 amount) external returns (bool);
764 
765     /**
766      * @dev Moves `amount` tokens from `sender` to `recipient` using the
767      * allowance mechanism. `amount` is then deducted from the caller's
768      * allowance.
769      *
770      * Returns a boolean value indicating whether the operation succeeded.
771      *
772      * Emits a {Transfer} event.
773      */
774     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
775 
776     /**
777      * @dev Emitted when `value` tokens are moved from one account (`from`) to
778      * another (`to`).
779      *
780      * Note that `value` may be zero.
781      */
782     event Transfer(address indexed from, address indexed to, uint256 value);
783 
784     /**
785      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
786      * a call to {approve}. `value` is the new allowance.
787      */
788     event Approval(address indexed owner, address indexed spender, uint256 value);
789 }
790 
791 
792 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
793 
794 pragma solidity >=0.6.0 <0.8.0;
795 
796 /**
797  * @dev Wrappers over Solidity's arithmetic operations with added overflow
798  * checks.
799  *
800  * Arithmetic operations in Solidity wrap on overflow. This can easily result
801  * in bugs, because programmers usually assume that an overflow raises an
802  * error, which is the standard behavior in high level programming languages.
803  * `SafeMath` restores this intuition by reverting the transaction when an
804  * operation overflows.
805  *
806  * Using this library instead of the unchecked operations eliminates an entire
807  * class of bugs, so it's recommended to use it always.
808  */
809 library SafeMath {
810     /**
811      * @dev Returns the addition of two unsigned integers, reverting on
812      * overflow.
813      *
814      * Counterpart to Solidity's `+` operator.
815      *
816      * Requirements:
817      *
818      * - Addition cannot overflow.
819      */
820     function add(uint256 a, uint256 b) internal pure returns (uint256) {
821         uint256 c = a + b;
822         require(c >= a, "SafeMath: addition overflow");
823 
824         return c;
825     }
826 
827     /**
828      * @dev Returns the subtraction of two unsigned integers, reverting on
829      * overflow (when the result is negative).
830      *
831      * Counterpart to Solidity's `-` operator.
832      *
833      * Requirements:
834      *
835      * - Subtraction cannot overflow.
836      */
837     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
838         return sub(a, b, "SafeMath: subtraction overflow");
839     }
840 
841     /**
842      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
843      * overflow (when the result is negative).
844      *
845      * Counterpart to Solidity's `-` operator.
846      *
847      * Requirements:
848      *
849      * - Subtraction cannot overflow.
850      */
851     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
852         require(b <= a, errorMessage);
853         uint256 c = a - b;
854 
855         return c;
856     }
857 
858     /**
859      * @dev Returns the multiplication of two unsigned integers, reverting on
860      * overflow.
861      *
862      * Counterpart to Solidity's `*` operator.
863      *
864      * Requirements:
865      *
866      * - Multiplication cannot overflow.
867      */
868     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
869         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
870         // benefit is lost if 'b' is also tested.
871         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
872         if (a == 0) {
873             return 0;
874         }
875 
876         uint256 c = a * b;
877         require(c / a == b, "SafeMath: multiplication overflow");
878 
879         return c;
880     }
881 
882     /**
883      * @dev Returns the integer division of two unsigned integers. Reverts on
884      * division by zero. The result is rounded towards zero.
885      *
886      * Counterpart to Solidity's `/` operator. Note: this function uses a
887      * `revert` opcode (which leaves remaining gas untouched) while Solidity
888      * uses an invalid opcode to revert (consuming all remaining gas).
889      *
890      * Requirements:
891      *
892      * - The divisor cannot be zero.
893      */
894     function div(uint256 a, uint256 b) internal pure returns (uint256) {
895         return div(a, b, "SafeMath: division by zero");
896     }
897 
898     /**
899      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
900      * division by zero. The result is rounded towards zero.
901      *
902      * Counterpart to Solidity's `/` operator. Note: this function uses a
903      * `revert` opcode (which leaves remaining gas untouched) while Solidity
904      * uses an invalid opcode to revert (consuming all remaining gas).
905      *
906      * Requirements:
907      *
908      * - The divisor cannot be zero.
909      */
910     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
911         require(b > 0, errorMessage);
912         uint256 c = a / b;
913         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
914 
915         return c;
916     }
917 
918     /**
919      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
920      * Reverts when dividing by zero.
921      *
922      * Counterpart to Solidity's `%` operator. This function uses a `revert`
923      * opcode (which leaves remaining gas untouched) while Solidity uses an
924      * invalid opcode to revert (consuming all remaining gas).
925      *
926      * Requirements:
927      *
928      * - The divisor cannot be zero.
929      */
930     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
931         return mod(a, b, "SafeMath: modulo by zero");
932     }
933 
934     /**
935      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
936      * Reverts with custom message when dividing by zero.
937      *
938      * Counterpart to Solidity's `%` operator. This function uses a `revert`
939      * opcode (which leaves remaining gas untouched) while Solidity uses an
940      * invalid opcode to revert (consuming all remaining gas).
941      *
942      * Requirements:
943      *
944      * - The divisor cannot be zero.
945      */
946     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
947         require(b != 0, errorMessage);
948         return a % b;
949     }
950 }
951 
952 
953 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.3.0
954 
955 
956 pragma solidity >=0.6.0 <0.8.0;
957 
958 
959 
960 /**
961  * @dev Implementation of the {IERC20} interface.
962  *
963  * This implementation is agnostic to the way tokens are created. This means
964  * that a supply mechanism has to be added in a derived contract using {_mint}.
965  * For a generic mechanism see {ERC20PresetMinterPauser}.
966  *
967  * TIP: For a detailed writeup see our guide
968  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
969  * to implement supply mechanisms].
970  *
971  * We have followed general OpenZeppelin guidelines: functions revert instead
972  * of returning `false` on failure. This behavior is nonetheless conventional
973  * and does not conflict with the expectations of ERC20 applications.
974  *
975  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
976  * This allows applications to reconstruct the allowance for all accounts just
977  * by listening to said events. Other implementations of the EIP may not emit
978  * these events, as it isn't required by the specification.
979  *
980  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
981  * functions have been added to mitigate the well-known issues around setting
982  * allowances. See {IERC20-approve}.
983  */
984 contract ERC20 is Context, IERC20 {
985     using SafeMath for uint256;
986 
987     mapping (address => uint256) private _balances;
988 
989     mapping (address => mapping (address => uint256)) private _allowances;
990 
991     uint256 private _totalSupply;
992 
993     string private _name;
994     string private _symbol;
995     uint8 private _decimals;
996 
997     /**
998      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
999      * a default value of 18.
1000      *
1001      * To select a different value for {decimals}, use {_setupDecimals}.
1002      *
1003      * All three of these values are immutable: they can only be set once during
1004      * construction.
1005      */
1006     constructor (string memory name_, string memory symbol_) public {
1007         _name = name_;
1008         _symbol = symbol_;
1009         _decimals = 4;
1010     }
1011 
1012     /**
1013      * @dev Returns the name of the token.
1014      */
1015     function name() public view returns (string memory) {
1016         return _name;
1017     }
1018 
1019     /**
1020      * @dev Returns the symbol of the token, usually a shorter version of the
1021      * name.
1022      */
1023     function symbol() public view returns (string memory) {
1024         return _symbol;
1025     }
1026 
1027     /**
1028      * @dev Returns the number of decimals used to get its user representation.
1029      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1030      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1031      *
1032      * Tokens usually opt for a value of 18, imitating the relationship between
1033      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1034      * called.
1035      *
1036      * NOTE: This information is only used for _display_ purposes: it in
1037      * no way affects any of the arithmetic of the contract, including
1038      * {IERC20-balanceOf} and {IERC20-transfer}.
1039      */
1040     function decimals() public view returns (uint8) {
1041         return _decimals;
1042     }
1043 
1044     /**
1045      * @dev See {IERC20-totalSupply}.
1046      */
1047     function totalSupply() public view override returns (uint256) {
1048         return _totalSupply;
1049     }
1050 
1051     /**
1052      * @dev See {IERC20-balanceOf}.
1053      */
1054     function balanceOf(address account) public view override returns (uint256) {
1055         return _balances[account];
1056     }
1057 
1058     /**
1059      * @dev See {IERC20-transfer}.
1060      *
1061      * Requirements:
1062      *
1063      * - `recipient` cannot be the zero address.
1064      * - the caller must have a balance of at least `amount`.
1065      */
1066     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1067         _transfer(_msgSender(), recipient, amount);
1068         return true;
1069     }
1070 
1071     /**
1072      * @dev See {IERC20-allowance}.
1073      */
1074     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1075         return _allowances[owner][spender];
1076     }
1077 
1078     /**
1079      * @dev See {IERC20-approve}.
1080      *
1081      * Requirements:
1082      *
1083      * - `spender` cannot be the zero address.
1084      */
1085     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1086         _approve(_msgSender(), spender, amount);
1087         return true;
1088     }
1089 
1090     /**
1091      * @dev See {IERC20-transferFrom}.
1092      *
1093      * Emits an {Approval} event indicating the updated allowance. This is not
1094      * required by the EIP. See the note at the beginning of {ERC20}.
1095      *
1096      * Requirements:
1097      *
1098      * - `sender` and `recipient` cannot be the zero address.
1099      * - `sender` must have a balance of at least `amount`.
1100      * - the caller must have allowance for ``sender``'s tokens of at least
1101      * `amount`.
1102      */
1103     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1104         _transfer(sender, recipient, amount);
1105         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1106         return true;
1107     }
1108 
1109     /**
1110      * @dev Atomically increases the allowance granted to `spender` by the caller.
1111      *
1112      * This is an alternative to {approve} that can be used as a mitigation for
1113      * problems described in {IERC20-approve}.
1114      *
1115      * Emits an {Approval} event indicating the updated allowance.
1116      *
1117      * Requirements:
1118      *
1119      * - `spender` cannot be the zero address.
1120      */
1121     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1122         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1123         return true;
1124     }
1125 
1126     /**
1127      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1128      *
1129      * This is an alternative to {approve} that can be used as a mitigation for
1130      * problems described in {IERC20-approve}.
1131      *
1132      * Emits an {Approval} event indicating the updated allowance.
1133      *
1134      * Requirements:
1135      *
1136      * - `spender` cannot be the zero address.
1137      * - `spender` must have allowance for the caller of at least
1138      * `subtractedValue`.
1139      */
1140     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1141         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1142         return true;
1143     }
1144 
1145     /**
1146      * @dev Moves tokens `amount` from `sender` to `recipient`.
1147      *
1148      * This is internal function is equivalent to {transfer}, and can be used to
1149      * e.g. implement automatic token fees, slashing mechanisms, etc.
1150      *
1151      * Emits a {Transfer} event.
1152      *
1153      * Requirements:
1154      *
1155      * - `sender` cannot be the zero address.
1156      * - `recipient` cannot be the zero address.
1157      * - `sender` must have a balance of at least `amount`.
1158      */
1159     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1160         require(sender != address(0), "ERC20: transfer from the zero address");
1161         require(recipient != address(0), "ERC20: transfer to the zero address");
1162 
1163         _beforeTokenTransfer(sender, recipient, amount);
1164 
1165         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1166         _balances[recipient] = _balances[recipient].add(amount);
1167         emit Transfer(sender, recipient, amount);
1168     }
1169 
1170     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1171      * the total supply.
1172      *
1173      * Emits a {Transfer} event with `from` set to the zero address.
1174      *
1175      * Requirements:
1176      *
1177      * - `to` cannot be the zero address.
1178      */
1179     function _mint(address account, uint256 amount) internal virtual {
1180         require(account != address(0), "ERC20: mint to the zero address");
1181 
1182         _beforeTokenTransfer(address(0), account, amount);
1183 
1184         _totalSupply = _totalSupply.add(amount);
1185         _balances[account] = _balances[account].add(amount);
1186         emit Transfer(address(0), account, amount);
1187     }
1188 
1189     /**
1190      * @dev Destroys `amount` tokens from `account`, reducing the
1191      * total supply.
1192      *
1193      * Emits a {Transfer} event with `to` set to the zero address.
1194      *
1195      * Requirements:
1196      *
1197      * - `account` cannot be the zero address.
1198      * - `account` must have at least `amount` tokens.
1199      */
1200     function _burn(address account, uint256 amount) internal virtual {
1201         require(account != address(0), "ERC20: burn from the zero address");
1202 
1203         _beforeTokenTransfer(account, address(0), amount);
1204 
1205         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1206         _totalSupply = _totalSupply.sub(amount);
1207         emit Transfer(account, address(0), amount);
1208     }
1209 
1210     /**
1211      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1212      *
1213      * This internal function is equivalent to `approve`, and can be used to
1214      * e.g. set automatic allowances for certain subsystems, etc.
1215      *
1216      * Emits an {Approval} event.
1217      *
1218      * Requirements:
1219      *
1220      * - `owner` cannot be the zero address.
1221      * - `spender` cannot be the zero address.
1222      */
1223     function _approve(address owner, address spender, uint256 amount) internal virtual {
1224         require(owner != address(0), "ERC20: approve from the zero address");
1225         require(spender != address(0), "ERC20: approve to the zero address");
1226 
1227         _allowances[owner][spender] = amount;
1228         emit Approval(owner, spender, amount);
1229     }
1230 
1231     /**
1232      * @dev Sets {decimals} to a value other than the default one of 18.
1233      *
1234      * WARNING: This function should only be called from the constructor. Most
1235      * applications that interact with token contracts will not expect
1236      * {decimals} to ever change, and may work incorrectly if it does.
1237      */
1238     function _setupDecimals(uint8 decimals_) internal {
1239         _decimals = decimals_;
1240     }
1241 
1242     /**
1243      * @dev Hook that is called before any transfer of tokens. This includes
1244      * minting and burning.
1245      *
1246      * Calling conditions:
1247      *
1248      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1249      * will be to transferred to `to`.
1250      * - when `from` is zero, `amount` tokens will be minted for `to`.
1251      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1252      * - `from` and `to` are never both zero.
1253      *
1254      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1255      */
1256     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1257 }
1258 
1259 
1260 // File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.3.0
1261 
1262 
1263 pragma solidity >=0.6.0 <0.8.0;
1264 
1265 
1266 /**
1267  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1268  * tokens and those that they have an allowance for, in a way that can be
1269  * recognized off-chain (via event analysis).
1270  */
1271 abstract contract ERC20Burnable is Context, ERC20 {
1272     using SafeMath for uint256;
1273 
1274     /**
1275      * @dev Destroys `amount` tokens from the caller.
1276      *
1277      * See {ERC20-_burn}.
1278      */
1279     function burn(uint256 amount) public virtual {
1280         _burn(_msgSender(), amount);
1281     }
1282 
1283     /**
1284      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1285      * allowance.
1286      *
1287      * See {ERC20-_burn} and {ERC20-allowance}.
1288      *
1289      * Requirements:
1290      *
1291      * - the caller must have allowance for ``accounts``'s tokens of at least
1292      * `amount`.
1293      */
1294     function burnFrom(address account, uint256 amount) public virtual {
1295         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1296 
1297         _approve(account, _msgSender(), decreasedAllowance);
1298         _burn(account, amount);
1299     }
1300 }
1301 
1302 
1303 // File @openzeppelin/contracts/utils/Pausable.sol@v3.3.0
1304 
1305 
1306 pragma solidity >=0.6.0 <0.8.0;
1307 
1308 /**
1309  * @dev Contract module which allows children to implement an emergency stop
1310  * mechanism that can be triggered by an authorized account.
1311  *
1312  * This module is used through inheritance. It will make available the
1313  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1314  * the functions of your contract. Note that they will not be pausable by
1315  * simply including this module, only once the modifiers are put in place.
1316  */
1317 abstract contract Pausable is Context {
1318     /**
1319      * @dev Emitted when the pause is triggered by `account`.
1320      */
1321     event Paused(address account);
1322 
1323     /**
1324      * @dev Emitted when the pause is lifted by `account`.
1325      */
1326     event Unpaused(address account);
1327 
1328     bool private _paused;
1329 
1330     /**
1331      * @dev Initializes the contract in unpaused state.
1332      */
1333     constructor () internal {
1334         _paused = false;
1335     }
1336 
1337     /**
1338      * @dev Returns true if the contract is paused, and false otherwise.
1339      */
1340     function paused() public view returns (bool) {
1341         return _paused;
1342     }
1343 
1344     /**
1345      * @dev Modifier to make a function callable only when the contract is not paused.
1346      *
1347      * Requirements:
1348      *
1349      * - The contract must not be paused.
1350      */
1351     modifier whenNotPaused() {
1352         require(!_paused, "Pausable: paused");
1353         _;
1354     }
1355 
1356     /**
1357      * @dev Modifier to make a function callable only when the contract is paused.
1358      *
1359      * Requirements:
1360      *
1361      * - The contract must be paused.
1362      */
1363     modifier whenPaused() {
1364         require(_paused, "Pausable: not paused");
1365         _;
1366     }
1367 
1368     /**
1369      * @dev Triggers stopped state.
1370      *
1371      * Requirements:
1372      *
1373      * - The contract must not be paused.
1374      */
1375     function _pause() internal virtual whenNotPaused {
1376         _paused = true;
1377         emit Paused(_msgSender());
1378     }
1379 
1380     /**
1381      * @dev Returns to normal state.
1382      *
1383      * Requirements:
1384      *
1385      * - The contract must be paused.
1386      */
1387     function _unpause() internal virtual whenPaused {
1388         _paused = false;
1389         emit Unpaused(_msgSender());
1390     }
1391 }
1392 
1393 
1394 // File @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol@v3.3.0
1395 
1396 
1397 pragma solidity >=0.6.0 <0.8.0;
1398 
1399 
1400 /**
1401  * @dev ERC20 token with pausable token transfers, minting and burning.
1402  *
1403  * Useful for scenarios such as preventing trades until the end of an evaluation
1404  * period, or having an emergency switch for freezing all token transfers in the
1405  * event of a large bug.
1406  */
1407 abstract contract ERC20Pausable is ERC20, Pausable {
1408     /**
1409      * @dev See {ERC20-_beforeTokenTransfer}.
1410      *
1411      * Requirements:
1412      *
1413      * - the contract must not be paused.
1414      */
1415     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1416         super._beforeTokenTransfer(from, to, amount);
1417 
1418         require(!paused(), "ERC20Pausable: token transfer while paused");
1419     }
1420 }
1421 
1422 
1423 // File @openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol@v3.3.0
1424 
1425 // SPDX-License-Identifier: MIT
1426 
1427 pragma solidity >=0.6.0 <0.8.0;
1428 
1429 
1430 
1431 
1432 
1433 /**
1434  * @dev {ERC20} token, including:
1435  *
1436  *  - ability for holders to burn (destroy) their tokens
1437  *  - a minter role that allows for token minting (creation)
1438  *  - a pauser role that allows to stop all token transfers
1439  *
1440  * This contract uses {AccessControl} to lock permissioned functions using the
1441  * different roles - head to its documentation for details.
1442  *
1443  * The account that deploys the contract will be granted the minter and pauser
1444  * roles, as well as the default admin role, which will let it grant both minter
1445  * and pauser roles to other accounts.
1446  */
1447 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1448     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1449     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1450 
1451     /**
1452      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1453      * account that deploys the contract.
1454      *
1455      * See {ERC20-constructor}.
1456      */
1457     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1458         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1459 
1460         _setupRole(MINTER_ROLE, _msgSender());
1461         _setupRole(PAUSER_ROLE, _msgSender());
1462     }
1463 
1464     /**
1465      * @dev Creates `amount` new tokens for `to`.
1466      *
1467      * See {ERC20-_mint}.
1468      *
1469      * Requirements:
1470      *
1471      * - the caller must have the `MINTER_ROLE`.
1472      */
1473     function mint(address to, uint256 amount) public virtual {
1474         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1475         _mint(to, amount);
1476     }
1477 
1478     /**
1479      * @dev Pauses all token transfers.
1480      *
1481      * See {ERC20Pausable} and {Pausable-_pause}.
1482      *
1483      * Requirements:
1484      *
1485      * - the caller must have the `PAUSER_ROLE`.
1486      */
1487     function pause() public virtual {
1488         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1489         _pause();
1490     }
1491 
1492     /**
1493      * @dev Unpauses all token transfers.
1494      *
1495      * See {ERC20Pausable} and {Pausable-_unpause}.
1496      *
1497      * Requirements:
1498      *
1499      * - the caller must have the `PAUSER_ROLE`.
1500      */
1501     function unpause() public virtual {
1502         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1503         _unpause();
1504     }
1505 
1506     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1507         super._beforeTokenTransfer(from, to, amount);
1508     }
1509 }
1510 
1511 
1512 // File @openzeppelin/contracts/access/Ownable.sol@v3.3.0
1513 
1514 
1515 pragma solidity >=0.6.0 <0.8.0;
1516 
1517 /**
1518  * @dev Contract module which provides a basic access control mechanism, where
1519  * there is an account (an owner) that can be granted exclusive access to
1520  * specific functions.
1521  *
1522  * By default, the owner account will be the one that deploys the contract. This
1523  * can later be changed with {transferOwnership}.
1524  *
1525  * This module is used through inheritance. It will make available the modifier
1526  * `onlyOwner`, which can be applied to your functions to restrict their use to
1527  * the owner.
1528  */
1529 abstract contract Ownable is Context {
1530     address private _owner;
1531 
1532     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1533 
1534     /**
1535      * @dev Initializes the contract setting the deployer as the initial owner.
1536      */
1537     constructor () internal {
1538         address msgSender = _msgSender();
1539         _owner = msgSender;
1540         emit OwnershipTransferred(address(0), msgSender);
1541     }
1542 
1543     /**
1544      * @dev Returns the address of the current owner.
1545      */
1546     function owner() public view returns (address) {
1547         return _owner;
1548     }
1549 
1550     /**
1551      * @dev Throws if called by any account other than the owner.
1552      */
1553     modifier onlyOwner() {
1554         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1555         _;
1556     }
1557 
1558     /**
1559      * @dev Leaves the contract without owner. It will not be possible to call
1560      * `onlyOwner` functions anymore. Can only be called by the current owner.
1561      *
1562      * NOTE: Renouncing ownership will leave the contract without an owner,
1563      * thereby removing any functionality that is only available to the owner.
1564      */
1565     function renounceOwnership() public virtual onlyOwner {
1566         emit OwnershipTransferred(_owner, address(0));
1567         _owner = address(0);
1568     }
1569 
1570     /**
1571      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1572      * Can only be called by the current owner.
1573      */
1574     function transferOwnership(address newOwner) public virtual onlyOwner {
1575         require(newOwner != address(0), "Ownable: new owner is the zero address");
1576         emit OwnershipTransferred(_owner, newOwner);
1577         _owner = newOwner;
1578     }
1579 }
1580 
1581 
1582 // File contracts/SquiggleDAOToken.sol
1583 
1584 pragma solidity >=0.6.0 <0.8.0;
1585 
1586 // SquiggleDAOToken on a fixed supply.
1587 
1588 
1589 
1590 contract SquiggleDAOToken is ERC20PresetMinterPauser {    
1591     // _amount = 100000000000 (mints 10M tokens right away)
1592 
1593     constructor(
1594         address _vestingBeneficiary,
1595         uint256 _amount
1596     ) ERC20PresetMinterPauser('Squiggle DAO Token', 'SQUIG') {
1597         _mint(_vestingBeneficiary, _amount);
1598     }
1599 }