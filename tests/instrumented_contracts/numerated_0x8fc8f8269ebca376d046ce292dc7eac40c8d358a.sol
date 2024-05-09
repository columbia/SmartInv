1 // SPDX-License-Identifier: MIT
2 // DeFiChain DFI as ERC20
3 // See DFI.sol for main contract 
4 
5 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
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
206         return _add(set._inner, bytes32(uint256(value)));
207     }
208 
209     /**
210      * @dev Removes a value from a set. O(1).
211      *
212      * Returns true if the value was removed from the set, that is if it was
213      * present.
214      */
215     function remove(AddressSet storage set, address value) internal returns (bool) {
216         return _remove(set._inner, bytes32(uint256(value)));
217     }
218 
219     /**
220      * @dev Returns true if the value is in the set. O(1).
221      */
222     function contains(AddressSet storage set, address value) internal view returns (bool) {
223         return _contains(set._inner, bytes32(uint256(value)));
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
244         return address(uint256(_at(set._inner, index)));
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
303 // File: @openzeppelin/contracts/utils/Address.sol
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
496 pragma solidity >=0.6.0 <0.8.0;
497 
498 
499 
500 
501 /**
502  * @dev Contract module that allows children to implement role-based access
503  * control mechanisms.
504  *
505  * Roles are referred to by their `bytes32` identifier. These should be exposed
506  * in the external API and be unique. The best way to achieve this is by
507  * using `public constant` hash digests:
508  *
509  * ```
510  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
511  * ```
512  *
513  * Roles can be used to represent a set of permissions. To restrict access to a
514  * function call, use {hasRole}:
515  *
516  * ```
517  * function foo() public {
518  *     require(hasRole(MY_ROLE, msg.sender));
519  *     ...
520  * }
521  * ```
522  *
523  * Roles can be granted and revoked dynamically via the {grantRole} and
524  * {revokeRole} functions. Each role has an associated admin role, and only
525  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
526  *
527  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
528  * that only accounts with this role will be able to grant or revoke other
529  * roles. More complex role relationships can be created by using
530  * {_setRoleAdmin}.
531  *
532  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
533  * grant and revoke this role. Extra precautions should be taken to secure
534  * accounts that have been granted it.
535  */
536 abstract contract AccessControl is Context {
537     using EnumerableSet for EnumerableSet.AddressSet;
538     using Address for address;
539 
540     struct RoleData {
541         EnumerableSet.AddressSet members;
542         bytes32 adminRole;
543     }
544 
545     mapping (bytes32 => RoleData) private _roles;
546 
547     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
548 
549     /**
550      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
551      *
552      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
553      * {RoleAdminChanged} not being emitted signaling this.
554      *
555      * _Available since v3.1._
556      */
557     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
558 
559     /**
560      * @dev Emitted when `account` is granted `role`.
561      *
562      * `sender` is the account that originated the contract call, an admin role
563      * bearer except when using {_setupRole}.
564      */
565     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
566 
567     /**
568      * @dev Emitted when `account` is revoked `role`.
569      *
570      * `sender` is the account that originated the contract call:
571      *   - if using `revokeRole`, it is the admin role bearer
572      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
573      */
574     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
575 
576     /**
577      * @dev Returns `true` if `account` has been granted `role`.
578      */
579     function hasRole(bytes32 role, address account) public view returns (bool) {
580         return _roles[role].members.contains(account);
581     }
582 
583     /**
584      * @dev Returns the number of accounts that have `role`. Can be used
585      * together with {getRoleMember} to enumerate all bearers of a role.
586      */
587     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
588         return _roles[role].members.length();
589     }
590 
591     /**
592      * @dev Returns one of the accounts that have `role`. `index` must be a
593      * value between 0 and {getRoleMemberCount}, non-inclusive.
594      *
595      * Role bearers are not sorted in any particular way, and their ordering may
596      * change at any point.
597      *
598      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
599      * you perform all queries on the same block. See the following
600      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
601      * for more information.
602      */
603     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
604         return _roles[role].members.at(index);
605     }
606 
607     /**
608      * @dev Returns the admin role that controls `role`. See {grantRole} and
609      * {revokeRole}.
610      *
611      * To change a role's admin, use {_setRoleAdmin}.
612      */
613     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
614         return _roles[role].adminRole;
615     }
616 
617     /**
618      * @dev Grants `role` to `account`.
619      *
620      * If `account` had not been already granted `role`, emits a {RoleGranted}
621      * event.
622      *
623      * Requirements:
624      *
625      * - the caller must have ``role``'s admin role.
626      */
627     function grantRole(bytes32 role, address account) public virtual {
628         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
629 
630         _grantRole(role, account);
631     }
632 
633     /**
634      * @dev Revokes `role` from `account`.
635      *
636      * If `account` had been granted `role`, emits a {RoleRevoked} event.
637      *
638      * Requirements:
639      *
640      * - the caller must have ``role``'s admin role.
641      */
642     function revokeRole(bytes32 role, address account) public virtual {
643         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
644 
645         _revokeRole(role, account);
646     }
647 
648     /**
649      * @dev Revokes `role` from the calling account.
650      *
651      * Roles are often managed via {grantRole} and {revokeRole}: this function's
652      * purpose is to provide a mechanism for accounts to lose their privileges
653      * if they are compromised (such as when a trusted device is misplaced).
654      *
655      * If the calling account had been granted `role`, emits a {RoleRevoked}
656      * event.
657      *
658      * Requirements:
659      *
660      * - the caller must be `account`.
661      */
662     function renounceRole(bytes32 role, address account) public virtual {
663         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
664 
665         _revokeRole(role, account);
666     }
667 
668     /**
669      * @dev Grants `role` to `account`.
670      *
671      * If `account` had not been already granted `role`, emits a {RoleGranted}
672      * event. Note that unlike {grantRole}, this function doesn't perform any
673      * checks on the calling account.
674      *
675      * [WARNING]
676      * ====
677      * This function should only be called from the constructor when setting
678      * up the initial roles for the system.
679      *
680      * Using this function in any other way is effectively circumventing the admin
681      * system imposed by {AccessControl}.
682      * ====
683      */
684     function _setupRole(bytes32 role, address account) internal virtual {
685         _grantRole(role, account);
686     }
687 
688     /**
689      * @dev Sets `adminRole` as ``role``'s admin role.
690      *
691      * Emits a {RoleAdminChanged} event.
692      */
693     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
694         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
695         _roles[role].adminRole = adminRole;
696     }
697 
698     function _grantRole(bytes32 role, address account) private {
699         if (_roles[role].members.add(account)) {
700             emit RoleGranted(role, account, _msgSender());
701         }
702     }
703 
704     function _revokeRole(bytes32 role, address account) private {
705         if (_roles[role].members.remove(account)) {
706             emit RoleRevoked(role, account, _msgSender());
707         }
708     }
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
712 
713 pragma solidity >=0.6.0 <0.8.0;
714 
715 /**
716  * @dev Interface of the ERC20 standard as defined in the EIP.
717  */
718 interface IERC20 {
719     /**
720      * @dev Returns the amount of tokens in existence.
721      */
722     function totalSupply() external view returns (uint256);
723 
724     /**
725      * @dev Returns the amount of tokens owned by `account`.
726      */
727     function balanceOf(address account) external view returns (uint256);
728 
729     /**
730      * @dev Moves `amount` tokens from the caller's account to `recipient`.
731      *
732      * Returns a boolean value indicating whether the operation succeeded.
733      *
734      * Emits a {Transfer} event.
735      */
736     function transfer(address recipient, uint256 amount) external returns (bool);
737 
738     /**
739      * @dev Returns the remaining number of tokens that `spender` will be
740      * allowed to spend on behalf of `owner` through {transferFrom}. This is
741      * zero by default.
742      *
743      * This value changes when {approve} or {transferFrom} are called.
744      */
745     function allowance(address owner, address spender) external view returns (uint256);
746 
747     /**
748      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
749      *
750      * Returns a boolean value indicating whether the operation succeeded.
751      *
752      * IMPORTANT: Beware that changing an allowance with this method brings the risk
753      * that someone may use both the old and the new allowance by unfortunate
754      * transaction ordering. One possible solution to mitigate this race
755      * condition is to first reduce the spender's allowance to 0 and set the
756      * desired value afterwards:
757      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
758      *
759      * Emits an {Approval} event.
760      */
761     function approve(address spender, uint256 amount) external returns (bool);
762 
763     /**
764      * @dev Moves `amount` tokens from `sender` to `recipient` using the
765      * allowance mechanism. `amount` is then deducted from the caller's
766      * allowance.
767      *
768      * Returns a boolean value indicating whether the operation succeeded.
769      *
770      * Emits a {Transfer} event.
771      */
772     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
773 
774     /**
775      * @dev Emitted when `value` tokens are moved from one account (`from`) to
776      * another (`to`).
777      *
778      * Note that `value` may be zero.
779      */
780     event Transfer(address indexed from, address indexed to, uint256 value);
781 
782     /**
783      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
784      * a call to {approve}. `value` is the new allowance.
785      */
786     event Approval(address indexed owner, address indexed spender, uint256 value);
787 }
788 
789 // File: @openzeppelin/contracts/math/SafeMath.sol
790 
791 pragma solidity >=0.6.0 <0.8.0;
792 
793 /**
794  * @dev Wrappers over Solidity's arithmetic operations with added overflow
795  * checks.
796  *
797  * Arithmetic operations in Solidity wrap on overflow. This can easily result
798  * in bugs, because programmers usually assume that an overflow raises an
799  * error, which is the standard behavior in high level programming languages.
800  * `SafeMath` restores this intuition by reverting the transaction when an
801  * operation overflows.
802  *
803  * Using this library instead of the unchecked operations eliminates an entire
804  * class of bugs, so it's recommended to use it always.
805  */
806 library SafeMath {
807     /**
808      * @dev Returns the addition of two unsigned integers, reverting on
809      * overflow.
810      *
811      * Counterpart to Solidity's `+` operator.
812      *
813      * Requirements:
814      *
815      * - Addition cannot overflow.
816      */
817     function add(uint256 a, uint256 b) internal pure returns (uint256) {
818         uint256 c = a + b;
819         require(c >= a, "SafeMath: addition overflow");
820 
821         return c;
822     }
823 
824     /**
825      * @dev Returns the subtraction of two unsigned integers, reverting on
826      * overflow (when the result is negative).
827      *
828      * Counterpart to Solidity's `-` operator.
829      *
830      * Requirements:
831      *
832      * - Subtraction cannot overflow.
833      */
834     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
835         return sub(a, b, "SafeMath: subtraction overflow");
836     }
837 
838     /**
839      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
840      * overflow (when the result is negative).
841      *
842      * Counterpart to Solidity's `-` operator.
843      *
844      * Requirements:
845      *
846      * - Subtraction cannot overflow.
847      */
848     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
849         require(b <= a, errorMessage);
850         uint256 c = a - b;
851 
852         return c;
853     }
854 
855     /**
856      * @dev Returns the multiplication of two unsigned integers, reverting on
857      * overflow.
858      *
859      * Counterpart to Solidity's `*` operator.
860      *
861      * Requirements:
862      *
863      * - Multiplication cannot overflow.
864      */
865     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
866         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
867         // benefit is lost if 'b' is also tested.
868         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
869         if (a == 0) {
870             return 0;
871         }
872 
873         uint256 c = a * b;
874         require(c / a == b, "SafeMath: multiplication overflow");
875 
876         return c;
877     }
878 
879     /**
880      * @dev Returns the integer division of two unsigned integers. Reverts on
881      * division by zero. The result is rounded towards zero.
882      *
883      * Counterpart to Solidity's `/` operator. Note: this function uses a
884      * `revert` opcode (which leaves remaining gas untouched) while Solidity
885      * uses an invalid opcode to revert (consuming all remaining gas).
886      *
887      * Requirements:
888      *
889      * - The divisor cannot be zero.
890      */
891     function div(uint256 a, uint256 b) internal pure returns (uint256) {
892         return div(a, b, "SafeMath: division by zero");
893     }
894 
895     /**
896      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
897      * division by zero. The result is rounded towards zero.
898      *
899      * Counterpart to Solidity's `/` operator. Note: this function uses a
900      * `revert` opcode (which leaves remaining gas untouched) while Solidity
901      * uses an invalid opcode to revert (consuming all remaining gas).
902      *
903      * Requirements:
904      *
905      * - The divisor cannot be zero.
906      */
907     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
908         require(b > 0, errorMessage);
909         uint256 c = a / b;
910         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
911 
912         return c;
913     }
914 
915     /**
916      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
917      * Reverts when dividing by zero.
918      *
919      * Counterpart to Solidity's `%` operator. This function uses a `revert`
920      * opcode (which leaves remaining gas untouched) while Solidity uses an
921      * invalid opcode to revert (consuming all remaining gas).
922      *
923      * Requirements:
924      *
925      * - The divisor cannot be zero.
926      */
927     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
928         return mod(a, b, "SafeMath: modulo by zero");
929     }
930 
931     /**
932      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
933      * Reverts with custom message when dividing by zero.
934      *
935      * Counterpart to Solidity's `%` operator. This function uses a `revert`
936      * opcode (which leaves remaining gas untouched) while Solidity uses an
937      * invalid opcode to revert (consuming all remaining gas).
938      *
939      * Requirements:
940      *
941      * - The divisor cannot be zero.
942      */
943     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
944         require(b != 0, errorMessage);
945         return a % b;
946     }
947 }
948 
949 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
950 
951 pragma solidity >=0.6.0 <0.8.0;
952 
953 
954 
955 
956 /**
957  * @dev Implementation of the {IERC20} interface.
958  *
959  * This implementation is agnostic to the way tokens are created. This means
960  * that a supply mechanism has to be added in a derived contract using {_mint}.
961  * For a generic mechanism see {ERC20PresetMinterPauser}.
962  *
963  * TIP: For a detailed writeup see our guide
964  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
965  * to implement supply mechanisms].
966  *
967  * We have followed general OpenZeppelin guidelines: functions revert instead
968  * of returning `false` on failure. This behavior is nonetheless conventional
969  * and does not conflict with the expectations of ERC20 applications.
970  *
971  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
972  * This allows applications to reconstruct the allowance for all accounts just
973  * by listening to said events. Other implementations of the EIP may not emit
974  * these events, as it isn't required by the specification.
975  *
976  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
977  * functions have been added to mitigate the well-known issues around setting
978  * allowances. See {IERC20-approve}.
979  */
980 contract ERC20 is Context, IERC20 {
981     using SafeMath for uint256;
982 
983     mapping (address => uint256) private _balances;
984 
985     mapping (address => mapping (address => uint256)) private _allowances;
986 
987     uint256 private _totalSupply;
988 
989     string private _name;
990     string private _symbol;
991     uint8 private _decimals;
992 
993     /**
994      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
995      * a default value of 18.
996      *
997      * To select a different value for {decimals}, use {_setupDecimals}.
998      *
999      * All three of these values are immutable: they can only be set once during
1000      * construction.
1001      */
1002     constructor (string memory name_, string memory symbol_) public {
1003         _name = name_;
1004         _symbol = symbol_;
1005         _decimals = 18;
1006     }
1007 
1008     /**
1009      * @dev Returns the name of the token.
1010      */
1011     function name() public view returns (string memory) {
1012         return _name;
1013     }
1014 
1015     /**
1016      * @dev Returns the symbol of the token, usually a shorter version of the
1017      * name.
1018      */
1019     function symbol() public view returns (string memory) {
1020         return _symbol;
1021     }
1022 
1023     /**
1024      * @dev Returns the number of decimals used to get its user representation.
1025      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1026      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1027      *
1028      * Tokens usually opt for a value of 18, imitating the relationship between
1029      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1030      * called.
1031      *
1032      * NOTE: This information is only used for _display_ purposes: it in
1033      * no way affects any of the arithmetic of the contract, including
1034      * {IERC20-balanceOf} and {IERC20-transfer}.
1035      */
1036     function decimals() public view returns (uint8) {
1037         return _decimals;
1038     }
1039 
1040     /**
1041      * @dev See {IERC20-totalSupply}.
1042      */
1043     function totalSupply() public view override returns (uint256) {
1044         return _totalSupply;
1045     }
1046 
1047     /**
1048      * @dev See {IERC20-balanceOf}.
1049      */
1050     function balanceOf(address account) public view override returns (uint256) {
1051         return _balances[account];
1052     }
1053 
1054     /**
1055      * @dev See {IERC20-transfer}.
1056      *
1057      * Requirements:
1058      *
1059      * - `recipient` cannot be the zero address.
1060      * - the caller must have a balance of at least `amount`.
1061      */
1062     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1063         _transfer(_msgSender(), recipient, amount);
1064         return true;
1065     }
1066 
1067     /**
1068      * @dev See {IERC20-allowance}.
1069      */
1070     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1071         return _allowances[owner][spender];
1072     }
1073 
1074     /**
1075      * @dev See {IERC20-approve}.
1076      *
1077      * Requirements:
1078      *
1079      * - `spender` cannot be the zero address.
1080      */
1081     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1082         _approve(_msgSender(), spender, amount);
1083         return true;
1084     }
1085 
1086     /**
1087      * @dev See {IERC20-transferFrom}.
1088      *
1089      * Emits an {Approval} event indicating the updated allowance. This is not
1090      * required by the EIP. See the note at the beginning of {ERC20}.
1091      *
1092      * Requirements:
1093      *
1094      * - `sender` and `recipient` cannot be the zero address.
1095      * - `sender` must have a balance of at least `amount`.
1096      * - the caller must have allowance for ``sender``'s tokens of at least
1097      * `amount`.
1098      */
1099     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1100         _transfer(sender, recipient, amount);
1101         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1102         return true;
1103     }
1104 
1105     /**
1106      * @dev Atomically increases the allowance granted to `spender` by the caller.
1107      *
1108      * This is an alternative to {approve} that can be used as a mitigation for
1109      * problems described in {IERC20-approve}.
1110      *
1111      * Emits an {Approval} event indicating the updated allowance.
1112      *
1113      * Requirements:
1114      *
1115      * - `spender` cannot be the zero address.
1116      */
1117     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1118         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1119         return true;
1120     }
1121 
1122     /**
1123      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1124      *
1125      * This is an alternative to {approve} that can be used as a mitigation for
1126      * problems described in {IERC20-approve}.
1127      *
1128      * Emits an {Approval} event indicating the updated allowance.
1129      *
1130      * Requirements:
1131      *
1132      * - `spender` cannot be the zero address.
1133      * - `spender` must have allowance for the caller of at least
1134      * `subtractedValue`.
1135      */
1136     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1137         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1138         return true;
1139     }
1140 
1141     /**
1142      * @dev Moves tokens `amount` from `sender` to `recipient`.
1143      *
1144      * This is internal function is equivalent to {transfer}, and can be used to
1145      * e.g. implement automatic token fees, slashing mechanisms, etc.
1146      *
1147      * Emits a {Transfer} event.
1148      *
1149      * Requirements:
1150      *
1151      * - `sender` cannot be the zero address.
1152      * - `recipient` cannot be the zero address.
1153      * - `sender` must have a balance of at least `amount`.
1154      */
1155     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1156         require(sender != address(0), "ERC20: transfer from the zero address");
1157         require(recipient != address(0), "ERC20: transfer to the zero address");
1158 
1159         _beforeTokenTransfer(sender, recipient, amount);
1160 
1161         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1162         _balances[recipient] = _balances[recipient].add(amount);
1163         emit Transfer(sender, recipient, amount);
1164     }
1165 
1166     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1167      * the total supply.
1168      *
1169      * Emits a {Transfer} event with `from` set to the zero address.
1170      *
1171      * Requirements:
1172      *
1173      * - `to` cannot be the zero address.
1174      */
1175     function _mint(address account, uint256 amount) internal virtual {
1176         require(account != address(0), "ERC20: mint to the zero address");
1177 
1178         _beforeTokenTransfer(address(0), account, amount);
1179 
1180         _totalSupply = _totalSupply.add(amount);
1181         _balances[account] = _balances[account].add(amount);
1182         emit Transfer(address(0), account, amount);
1183     }
1184 
1185     /**
1186      * @dev Destroys `amount` tokens from `account`, reducing the
1187      * total supply.
1188      *
1189      * Emits a {Transfer} event with `to` set to the zero address.
1190      *
1191      * Requirements:
1192      *
1193      * - `account` cannot be the zero address.
1194      * - `account` must have at least `amount` tokens.
1195      */
1196     function _burn(address account, uint256 amount) internal virtual {
1197         require(account != address(0), "ERC20: burn from the zero address");
1198 
1199         _beforeTokenTransfer(account, address(0), amount);
1200 
1201         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1202         _totalSupply = _totalSupply.sub(amount);
1203         emit Transfer(account, address(0), amount);
1204     }
1205 
1206     /**
1207      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1208      *
1209      * This internal function is equivalent to `approve`, and can be used to
1210      * e.g. set automatic allowances for certain subsystems, etc.
1211      *
1212      * Emits an {Approval} event.
1213      *
1214      * Requirements:
1215      *
1216      * - `owner` cannot be the zero address.
1217      * - `spender` cannot be the zero address.
1218      */
1219     function _approve(address owner, address spender, uint256 amount) internal virtual {
1220         require(owner != address(0), "ERC20: approve from the zero address");
1221         require(spender != address(0), "ERC20: approve to the zero address");
1222 
1223         _allowances[owner][spender] = amount;
1224         emit Approval(owner, spender, amount);
1225     }
1226 
1227     /**
1228      * @dev Sets {decimals} to a value other than the default one of 18.
1229      *
1230      * WARNING: This function should only be called from the constructor. Most
1231      * applications that interact with token contracts will not expect
1232      * {decimals} to ever change, and may work incorrectly if it does.
1233      */
1234     function _setupDecimals(uint8 decimals_) internal {
1235         _decimals = decimals_;
1236     }
1237 
1238     /**
1239      * @dev Hook that is called before any transfer of tokens. This includes
1240      * minting and burning.
1241      *
1242      * Calling conditions:
1243      *
1244      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1245      * will be to transferred to `to`.
1246      * - when `from` is zero, `amount` tokens will be minted for `to`.
1247      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1248      * - `from` and `to` are never both zero.
1249      *
1250      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1251      */
1252     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1253 }
1254 
1255 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1256 
1257 pragma solidity >=0.6.0 <0.8.0;
1258 
1259 
1260 
1261 /**
1262  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1263  * tokens and those that they have an allowance for, in a way that can be
1264  * recognized off-chain (via event analysis).
1265  */
1266 abstract contract ERC20Burnable is Context, ERC20 {
1267     using SafeMath for uint256;
1268 
1269     /**
1270      * @dev Destroys `amount` tokens from the caller.
1271      *
1272      * See {ERC20-_burn}.
1273      */
1274     function burn(uint256 amount) public virtual {
1275         _burn(_msgSender(), amount);
1276     }
1277 
1278     /**
1279      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1280      * allowance.
1281      *
1282      * See {ERC20-_burn} and {ERC20-allowance}.
1283      *
1284      * Requirements:
1285      *
1286      * - the caller must have allowance for ``accounts``'s tokens of at least
1287      * `amount`.
1288      */
1289     function burnFrom(address account, uint256 amount) public virtual {
1290         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1291 
1292         _approve(account, _msgSender(), decreasedAllowance);
1293         _burn(account, amount);
1294     }
1295 }
1296 
1297 // File: contracts/DFI.sol
1298 
1299 pragma solidity >=0.6.0 <0.8.0;
1300 
1301 
1302 
1303 
1304 
1305 /**
1306  * @dev DFI ERC20 token, including:
1307  *
1308  *  - Referenced from OpenZeppelin v3.3 preset: presets/ERC20PresetMinterPauser.sol
1309  *  - with pauser role and pause functionality removed
1310  */
1311 contract DFI is Context, AccessControl, ERC20Burnable {
1312     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1313     string private _backingAddress = "dZFYejknFdHMHNfHMNQAtwihzvq7DkzV49";
1314 
1315     /**
1316      * See {ERC20-constructor}.
1317      */
1318     constructor() ERC20("DeFiChain Token", "DFI") {
1319         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1320         _setupRole(MINTER_ROLE, _msgSender());
1321         _setupDecimals(8);
1322     }
1323 
1324     /**
1325      * @dev Creates `amount` new tokens for `to`.
1326      *
1327      * Requirements:
1328      * - the caller must have the `MINTER_ROLE`.
1329      */
1330     function mint(address to, uint256 amount) public virtual {
1331         require(hasRole(MINTER_ROLE, _msgSender()), "DFI: must have minter role to mint");
1332         _mint(to, amount);
1333     }
1334 
1335     /**
1336      * @dev Returns backing address of DFI on DeFiChain
1337      */
1338     function backingAddress() public view returns (string memory) {
1339         return _backingAddress;
1340     }
1341 
1342     /**
1343      * @dev Sets and overrides the backing address on DeFiChain
1344      * Requires admin's role
1345      */
1346     function setBackingAddress(string memory backingAddress_) public virtual {
1347       require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "DFI: must have admin role to set backing address");
1348       _backingAddress = backingAddress_;
1349     }
1350 
1351 }