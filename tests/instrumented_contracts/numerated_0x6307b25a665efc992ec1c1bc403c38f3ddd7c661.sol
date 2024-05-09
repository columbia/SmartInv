1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 /**
91  * @dev Collection of functions related to the address type
92  */
93 library Address {
94     /**
95      * @dev Returns true if `account` is a contract.
96      *
97      * [IMPORTANT]
98      * ====
99      * It is unsafe to assume that an address for which this function returns
100      * false is an externally-owned account (EOA) and not a contract.
101      *
102      * Among others, `isContract` will return false for the following
103      * types of addresses:
104      *
105      *  - an externally-owned account
106      *  - a contract in construction
107      *  - an address where a contract will be created
108      *  - an address where a contract lived, but was destroyed
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize, which returns 0 for contracts in
113         // construction, since the code is only stored at the end of the
114         // constructor execution.
115 
116         uint256 size;
117         // solhint-disable-next-line no-inline-assembly
118         assembly { size := extcodesize(account) }
119         return size > 0;
120     }
121 
122     /**
123      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
124      * `recipient`, forwarding all available gas and reverting on errors.
125      *
126      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
127      * of certain opcodes, possibly making contracts go over the 2300 gas limit
128      * imposed by `transfer`, making them unable to receive funds via
129      * `transfer`. {sendValue} removes this limitation.
130      *
131      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
132      *
133      * IMPORTANT: because control is transferred to `recipient`, care must be
134      * taken to not create reentrancy vulnerabilities. Consider using
135      * {ReentrancyGuard} or the
136      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
137      */
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(address(this).balance >= amount, "Address: insufficient balance");
140 
141         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
142         (bool success, ) = recipient.call{ value: amount }("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain`call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165       return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
195      * with `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
200         require(address(this).balance >= value, "Address: insufficient balance for call");
201         require(isContract(target), "Address: call to non-contract");
202 
203         // solhint-disable-next-line avoid-low-level-calls
204         (bool success, bytes memory returndata) = target.call{ value: value }(data);
205         return _verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
225         require(isContract(target), "Address: static call to non-contract");
226 
227         // solhint-disable-next-line avoid-low-level-calls
228         (bool success, bytes memory returndata) = target.staticcall(data);
229         return _verifyCallResult(success, returndata, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but performing a delegate call.
235      *
236      * _Available since v3.4._
237      */
238     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
244      * but performing a delegate call.
245      *
246      * _Available since v3.4._
247      */
248     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
249         require(isContract(target), "Address: delegate call to non-contract");
250 
251         // solhint-disable-next-line avoid-low-level-calls
252         (bool success, bytes memory returndata) = target.delegatecall(data);
253         return _verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
257         if (success) {
258             return returndata;
259         } else {
260             // Look for revert reason and bubble it up if present
261             if (returndata.length > 0) {
262                 // The easiest way to bubble the revert reason is using memory via assembly
263 
264                 // solhint-disable-next-line no-inline-assembly
265                 assembly {
266                     let returndata_size := mload(returndata)
267                     revert(add(32, returndata), returndata_size)
268                 }
269             } else {
270                 revert(errorMessage);
271             }
272         }
273     }
274 }
275 pragma solidity >=0.6.0 <0.8.0;
276 
277 /**
278  * @dev Library for managing
279  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
280  * types.
281  *
282  * Sets have the following properties:
283  *
284  * - Elements are added, removed, and checked for existence in constant time
285  * (O(1)).
286  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
287  *
288  * ```
289  * contract Example {
290  *     // Add the library methods
291  *     using EnumerableSet for EnumerableSet.AddressSet;
292  *
293  *     // Declare a set state variable
294  *     EnumerableSet.AddressSet private mySet;
295  * }
296  * ```
297  *
298  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
299  * and `uint256` (`UintSet`) are supported.
300  */
301 library EnumerableSet {
302     // To implement this library for multiple types with as little code
303     // repetition as possible, we write it in terms of a generic Set type with
304     // bytes32 values.
305     // The Set implementation uses private functions, and user-facing
306     // implementations (such as AddressSet) are just wrappers around the
307     // underlying Set.
308     // This means that we can only create new EnumerableSets for types that fit
309     // in bytes32.
310 
311     struct Set {
312         // Storage of set values
313         bytes32[] _values;
314 
315         // Position of the value in the `values` array, plus 1 because index 0
316         // means a value is not in the set.
317         mapping (bytes32 => uint256) _indexes;
318     }
319 
320     /**
321      * @dev Add a value to a set. O(1).
322      *
323      * Returns true if the value was added to the set, that is if it was not
324      * already present.
325      */
326     function _add(Set storage set, bytes32 value) private returns (bool) {
327         if (!_contains(set, value)) {
328             set._values.push(value);
329             // The value is stored at length-1, but we add 1 to all indexes
330             // and use 0 as a sentinel value
331             set._indexes[value] = set._values.length;
332             return true;
333         } else {
334             return false;
335         }
336     }
337 
338     /**
339      * @dev Removes a value from a set. O(1).
340      *
341      * Returns true if the value was removed from the set, that is if it was
342      * present.
343      */
344     function _remove(Set storage set, bytes32 value) private returns (bool) {
345         // We read and store the value's index to prevent multiple reads from the same storage slot
346         uint256 valueIndex = set._indexes[value];
347 
348         if (valueIndex != 0) { // Equivalent to contains(set, value)
349             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
350             // the array, and then remove the last element (sometimes called as 'swap and pop').
351             // This modifies the order of the array, as noted in {at}.
352 
353             uint256 toDeleteIndex = valueIndex - 1;
354             uint256 lastIndex = set._values.length - 1;
355 
356             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
357             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
358 
359             bytes32 lastvalue = set._values[lastIndex];
360 
361             // Move the last value to the index where the value to delete is
362             set._values[toDeleteIndex] = lastvalue;
363             // Update the index for the moved value
364             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
365 
366             // Delete the slot where the moved value was stored
367             set._values.pop();
368 
369             // Delete the index for the deleted slot
370             delete set._indexes[value];
371 
372             return true;
373         } else {
374             return false;
375         }
376     }
377 
378     /**
379      * @dev Returns true if the value is in the set. O(1).
380      */
381     function _contains(Set storage set, bytes32 value) private view returns (bool) {
382         return set._indexes[value] != 0;
383     }
384 
385     /**
386      * @dev Returns the number of values on the set. O(1).
387      */
388     function _length(Set storage set) private view returns (uint256) {
389         return set._values.length;
390     }
391 
392    /**
393     * @dev Returns the value stored at position `index` in the set. O(1).
394     *
395     * Note that there are no guarantees on the ordering of values inside the
396     * array, and it may change when more values are added or removed.
397     *
398     * Requirements:
399     *
400     * - `index` must be strictly less than {length}.
401     */
402     function _at(Set storage set, uint256 index) private view returns (bytes32) {
403         require(set._values.length > index, "EnumerableSet: index out of bounds");
404         return set._values[index];
405     }
406 
407     // Bytes32Set
408 
409     struct Bytes32Set {
410         Set _inner;
411     }
412 
413     /**
414      * @dev Add a value to a set. O(1).
415      *
416      * Returns true if the value was added to the set, that is if it was not
417      * already present.
418      */
419     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
420         return _add(set._inner, value);
421     }
422 
423     /**
424      * @dev Removes a value from a set. O(1).
425      *
426      * Returns true if the value was removed from the set, that is if it was
427      * present.
428      */
429     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
430         return _remove(set._inner, value);
431     }
432 
433     /**
434      * @dev Returns true if the value is in the set. O(1).
435      */
436     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
437         return _contains(set._inner, value);
438     }
439 
440     /**
441      * @dev Returns the number of values in the set. O(1).
442      */
443     function length(Bytes32Set storage set) internal view returns (uint256) {
444         return _length(set._inner);
445     }
446 
447    /**
448     * @dev Returns the value stored at position `index` in the set. O(1).
449     *
450     * Note that there are no guarantees on the ordering of values inside the
451     * array, and it may change when more values are added or removed.
452     *
453     * Requirements:
454     *
455     * - `index` must be strictly less than {length}.
456     */
457     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
458         return _at(set._inner, index);
459     }
460 
461     // AddressSet
462 
463     struct AddressSet {
464         Set _inner;
465     }
466 
467     /**
468      * @dev Add a value to a set. O(1).
469      *
470      * Returns true if the value was added to the set, that is if it was not
471      * already present.
472      */
473     function add(AddressSet storage set, address value) internal returns (bool) {
474         return _add(set._inner, bytes32(uint256(uint160(value))));
475     }
476 
477     /**
478      * @dev Removes a value from a set. O(1).
479      *
480      * Returns true if the value was removed from the set, that is if it was
481      * present.
482      */
483     function remove(AddressSet storage set, address value) internal returns (bool) {
484         return _remove(set._inner, bytes32(uint256(uint160(value))));
485     }
486 
487     /**
488      * @dev Returns true if the value is in the set. O(1).
489      */
490     function contains(AddressSet storage set, address value) internal view returns (bool) {
491         return _contains(set._inner, bytes32(uint256(uint160(value))));
492     }
493 
494     /**
495      * @dev Returns the number of values in the set. O(1).
496      */
497     function length(AddressSet storage set) internal view returns (uint256) {
498         return _length(set._inner);
499     }
500 
501    /**
502     * @dev Returns the value stored at position `index` in the set. O(1).
503     *
504     * Note that there are no guarantees on the ordering of values inside the
505     * array, and it may change when more values are added or removed.
506     *
507     * Requirements:
508     *
509     * - `index` must be strictly less than {length}.
510     */
511     function at(AddressSet storage set, uint256 index) internal view returns (address) {
512         return address(uint160(uint256(_at(set._inner, index))));
513     }
514 
515 
516     // UintSet
517 
518     struct UintSet {
519         Set _inner;
520     }
521 
522     /**
523      * @dev Add a value to a set. O(1).
524      *
525      * Returns true if the value was added to the set, that is if it was not
526      * already present.
527      */
528     function add(UintSet storage set, uint256 value) internal returns (bool) {
529         return _add(set._inner, bytes32(value));
530     }
531 
532     /**
533      * @dev Removes a value from a set. O(1).
534      *
535      * Returns true if the value was removed from the set, that is if it was
536      * present.
537      */
538     function remove(UintSet storage set, uint256 value) internal returns (bool) {
539         return _remove(set._inner, bytes32(value));
540     }
541 
542     /**
543      * @dev Returns true if the value is in the set. O(1).
544      */
545     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
546         return _contains(set._inner, bytes32(value));
547     }
548 
549     /**
550      * @dev Returns the number of values on the set. O(1).
551      */
552     function length(UintSet storage set) internal view returns (uint256) {
553         return _length(set._inner);
554     }
555 
556    /**
557     * @dev Returns the value stored at position `index` in the set. O(1).
558     *
559     * Note that there are no guarantees on the ordering of values inside the
560     * array, and it may change when more values are added or removed.
561     *
562     * Requirements:
563     *
564     * - `index` must be strictly less than {length}.
565     */
566     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
567         return uint256(_at(set._inner, index));
568     }
569 }
570 
571 /**
572  * @dev Contract module that allows children to implement role-based access
573  * control mechanisms.
574  *
575  * Roles are referred to by their `bytes32` identifier. These should be exposed
576  * in the external API and be unique. The best way to achieve this is by
577  * using `public constant` hash digests:
578  *
579  * ```
580  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
581  * ```
582  *
583  * Roles can be used to represent a set of permissions. To restrict access to a
584  * function call, use {hasRole}:
585  *
586  * ```
587  * function foo() public {
588  *     require(hasRole(MY_ROLE, msg.sender));
589  *     ...
590  * }
591  * ```
592  *
593  * Roles can be granted and revoked dynamically via the {grantRole} and
594  * {revokeRole} functions. Each role has an associated admin role, and only
595  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
596  *
597  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
598  * that only accounts with this role will be able to grant or revoke other
599  * roles. More complex role relationships can be created by using
600  * {_setRoleAdmin}.
601  *
602  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
603  * grant and revoke this role. Extra precautions should be taken to secure
604  * accounts that have been granted it.
605  */
606 abstract contract AccessControl is Context {
607     using EnumerableSet for EnumerableSet.AddressSet;
608     using Address for address;
609 
610     struct RoleData {
611         EnumerableSet.AddressSet members;
612         bytes32 adminRole;
613     }
614 
615     mapping (bytes32 => RoleData) private _roles;
616 
617     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
618 
619     /**
620      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
621      *
622      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
623      * {RoleAdminChanged} not being emitted signaling this.
624      *
625      * _Available since v3.1._
626      */
627     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
628 
629     /**
630      * @dev Emitted when `account` is granted `role`.
631      *
632      * `sender` is the account that originated the contract call, an admin role
633      * bearer except when using {_setupRole}.
634      */
635     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
636 
637     /**
638      * @dev Emitted when `account` is revoked `role`.
639      *
640      * `sender` is the account that originated the contract call:
641      *   - if using `revokeRole`, it is the admin role bearer
642      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
643      */
644     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
645 
646     /**
647      * @dev Returns `true` if `account` has been granted `role`.
648      */
649     function hasRole(bytes32 role, address account) public view returns (bool) {
650         return _roles[role].members.contains(account);
651     }
652 
653     /**
654      * @dev Returns the number of accounts that have `role`. Can be used
655      * together with {getRoleMember} to enumerate all bearers of a role.
656      */
657     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
658         return _roles[role].members.length();
659     }
660 
661     /**
662      * @dev Returns one of the accounts that have `role`. `index` must be a
663      * value between 0 and {getRoleMemberCount}, non-inclusive.
664      *
665      * Role bearers are not sorted in any particular way, and their ordering may
666      * change at any point.
667      *
668      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
669      * you perform all queries on the same block. See the following
670      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
671      * for more information.
672      */
673     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
674         return _roles[role].members.at(index);
675     }
676 
677     /**
678      * @dev Returns the admin role that controls `role`. See {grantRole} and
679      * {revokeRole}.
680      *
681      * To change a role's admin, use {_setRoleAdmin}.
682      */
683     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
684         return _roles[role].adminRole;
685     }
686 
687     /**
688      * @dev Grants `role` to `account`.
689      *
690      * If `account` had not been already granted `role`, emits a {RoleGranted}
691      * event.
692      *
693      * Requirements:
694      *
695      * - the caller must have ``role``'s admin role.
696      */
697     function grantRole(bytes32 role, address account) public virtual {
698         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
699 
700         _grantRole(role, account);
701     }
702 
703     /**
704      * @dev Revokes `role` from `account`.
705      *
706      * If `account` had been granted `role`, emits a {RoleRevoked} event.
707      *
708      * Requirements:
709      *
710      * - the caller must have ``role``'s admin role.
711      */
712     function revokeRole(bytes32 role, address account) public virtual {
713         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
714 
715         _revokeRole(role, account);
716     }
717 
718     /**
719      * @dev Revokes `role` from the calling account.
720      *
721      * Roles are often managed via {grantRole} and {revokeRole}: this function's
722      * purpose is to provide a mechanism for accounts to lose their privileges
723      * if they are compromised (such as when a trusted device is misplaced).
724      *
725      * If the calling account had been granted `role`, emits a {RoleRevoked}
726      * event.
727      *
728      * Requirements:
729      *
730      * - the caller must be `account`.
731      */
732     function renounceRole(bytes32 role, address account) public virtual {
733         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
734 
735         _revokeRole(role, account);
736     }
737 
738     /**
739      * @dev Grants `role` to `account`.
740      *
741      * If `account` had not been already granted `role`, emits a {RoleGranted}
742      * event. Note that unlike {grantRole}, this function doesn't perform any
743      * checks on the calling account.
744      *
745      * [WARNING]
746      * ====
747      * This function should only be called from the constructor when setting
748      * up the initial roles for the system.
749      *
750      * Using this function in any other way is effectively circumventing the admin
751      * system imposed by {AccessControl}.
752      * ====
753      */
754     function _setupRole(bytes32 role, address account) internal virtual {
755         _grantRole(role, account);
756     }
757 
758     /**
759      * @dev Sets `adminRole` as ``role``'s admin role.
760      *
761      * Emits a {RoleAdminChanged} event.
762      */
763     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
764         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
765         _roles[role].adminRole = adminRole;
766     }
767 
768     function _grantRole(bytes32 role, address account) private {
769         if (_roles[role].members.add(account)) {
770             emit RoleGranted(role, account, _msgSender());
771         }
772     }
773 
774     function _revokeRole(bytes32 role, address account) private {
775         if (_roles[role].members.remove(account)) {
776             emit RoleRevoked(role, account, _msgSender());
777         }
778     }
779 }
780 
781 pragma solidity >=0.6.0 <0.8.0;
782 
783 /**
784  * @dev Interface of the ERC20 standard as defined in the EIP.
785  */
786 interface IERC20 {
787     /**
788      * @dev Returns the amount of tokens in existence.
789      */
790     function totalSupply() external view returns (uint256);
791 
792     /**
793      * @dev Returns the amount of tokens owned by `account`.
794      */
795     function balanceOf(address account) external view returns (uint256);
796 
797     /**
798      * @dev Moves `amount` tokens from the caller's account to `recipient`.
799      *
800      * Returns a boolean value indicating whether the operation succeeded.
801      *
802      * Emits a {Transfer} event.
803      */
804     function transfer(address recipient, uint256 amount) external returns (bool);
805 
806     /**
807      * @dev Returns the remaining number of tokens that `spender` will be
808      * allowed to spend on behalf of `owner` through {transferFrom}. This is
809      * zero by default.
810      *
811      * This value changes when {approve} or {transferFrom} are called.
812      */
813     function allowance(address owner, address spender) external view returns (uint256);
814 
815     /**
816      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
817      *
818      * Returns a boolean value indicating whether the operation succeeded.
819      *
820      * IMPORTANT: Beware that changing an allowance with this method brings the risk
821      * that someone may use both the old and the new allowance by unfortunate
822      * transaction ordering. One possible solution to mitigate this race
823      * condition is to first reduce the spender's allowance to 0 and set the
824      * desired value afterwards:
825      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
826      *
827      * Emits an {Approval} event.
828      */
829     function approve(address spender, uint256 amount) external returns (bool);
830 
831     /**
832      * @dev Moves `amount` tokens from `sender` to `recipient` using the
833      * allowance mechanism. `amount` is then deducted from the caller's
834      * allowance.
835      *
836      * Returns a boolean value indicating whether the operation succeeded.
837      *
838      * Emits a {Transfer} event.
839      */
840     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
841 
842     /**
843      * @dev Emitted when `value` tokens are moved from one account (`from`) to
844      * another (`to`).
845      *
846      * Note that `value` may be zero.
847      */
848     event Transfer(address indexed from, address indexed to, uint256 value);
849 
850     /**
851      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
852      * a call to {approve}. `value` is the new allowance.
853      */
854     event Approval(address indexed owner, address indexed spender, uint256 value);
855 }
856 
857 pragma solidity >=0.6.0 <0.8.0;
858 
859 /**
860  * @dev Wrappers over Solidity's arithmetic operations with added overflow
861  * checks.
862  *
863  * Arithmetic operations in Solidity wrap on overflow. This can easily result
864  * in bugs, because programmers usually assume that an overflow raises an
865  * error, which is the standard behavior in high level programming languages.
866  * `SafeMath` restores this intuition by reverting the transaction when an
867  * operation overflows.
868  *
869  * Using this library instead of the unchecked operations eliminates an entire
870  * class of bugs, so it's recommended to use it always.
871  */
872 library SafeMath {
873     /**
874      * @dev Returns the addition of two unsigned integers, reverting on
875      * overflow.
876      *
877      * Counterpart to Solidity's `+` operator.
878      *
879      * Requirements:
880      *
881      * - Addition cannot overflow.
882      */
883     function add(uint256 a, uint256 b) internal pure returns (uint256) {
884         uint256 c = a + b;
885         require(c >= a, "SafeMath: addition overflow");
886 
887         return c;
888     }
889 
890     /**
891      * @dev Returns the subtraction of two unsigned integers, reverting on
892      * overflow (when the result is negative).
893      *
894      * Counterpart to Solidity's `-` operator.
895      *
896      * Requirements:
897      *
898      * - Subtraction cannot overflow.
899      */
900     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
901         return sub(a, b, "SafeMath: subtraction overflow");
902     }
903 
904     /**
905      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
906      * overflow (when the result is negative).
907      *
908      * Counterpart to Solidity's `-` operator.
909      *
910      * Requirements:
911      *
912      * - Subtraction cannot overflow.
913      */
914     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
915         require(b <= a, errorMessage);
916         uint256 c = a - b;
917 
918         return c;
919     }
920 
921     /**
922      * @dev Returns the multiplication of two unsigned integers, reverting on
923      * overflow.
924      *
925      * Counterpart to Solidity's `*` operator.
926      *
927      * Requirements:
928      *
929      * - Multiplication cannot overflow.
930      */
931     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
932         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
933         // benefit is lost if 'b' is also tested.
934         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
935         if (a == 0) {
936             return 0;
937         }
938 
939         uint256 c = a * b;
940         require(c / a == b, "SafeMath: multiplication overflow");
941 
942         return c;
943     }
944 
945     /**
946      * @dev Returns the integer division of two unsigned integers. Reverts on
947      * division by zero. The result is rounded towards zero.
948      *
949      * Counterpart to Solidity's `/` operator. Note: this function uses a
950      * `revert` opcode (which leaves remaining gas untouched) while Solidity
951      * uses an invalid opcode to revert (consuming all remaining gas).
952      *
953      * Requirements:
954      *
955      * - The divisor cannot be zero.
956      */
957     function div(uint256 a, uint256 b) internal pure returns (uint256) {
958         return div(a, b, "SafeMath: division by zero");
959     }
960 
961     /**
962      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
963      * division by zero. The result is rounded towards zero.
964      *
965      * Counterpart to Solidity's `/` operator. Note: this function uses a
966      * `revert` opcode (which leaves remaining gas untouched) while Solidity
967      * uses an invalid opcode to revert (consuming all remaining gas).
968      *
969      * Requirements:
970      *
971      * - The divisor cannot be zero.
972      */
973     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
974         require(b > 0, errorMessage);
975         uint256 c = a / b;
976         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
977 
978         return c;
979     }
980 
981     /**
982      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
983      * Reverts when dividing by zero.
984      *
985      * Counterpart to Solidity's `%` operator. This function uses a `revert`
986      * opcode (which leaves remaining gas untouched) while Solidity uses an
987      * invalid opcode to revert (consuming all remaining gas).
988      *
989      * Requirements:
990      *
991      * - The divisor cannot be zero.
992      */
993     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
994         return mod(a, b, "SafeMath: modulo by zero");
995     }
996 
997     /**
998      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
999      * Reverts with custom message when dividing by zero.
1000      *
1001      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1002      * opcode (which leaves remaining gas untouched) while Solidity uses an
1003      * invalid opcode to revert (consuming all remaining gas).
1004      *
1005      * Requirements:
1006      *
1007      * - The divisor cannot be zero.
1008      */
1009     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1010         require(b != 0, errorMessage);
1011         return a % b;
1012     }
1013 }
1014 
1015 pragma solidity >=0.6.0 <0.8.0;
1016 
1017 /**
1018  * @dev Implementation of the {IERC20} interface.
1019  *
1020  * This implementation is agnostic to the way tokens are created. This means
1021  * that a supply mechanism has to be added in a derived contract using {_mint}.
1022  * For a generic mechanism see {ERC20PresetMinterPauser}.
1023  *
1024  * TIP: For a detailed writeup see our guide
1025  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1026  * to implement supply mechanisms].
1027  *
1028  * We have followed general OpenZeppelin guidelines: functions revert instead
1029  * of returning `false` on failure. This behavior is nonetheless conventional
1030  * and does not conflict with the expectations of ERC20 applications.
1031  *
1032  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1033  * This allows applications to reconstruct the allowance for all accounts just
1034  * by listening to said events. Other implementations of the EIP may not emit
1035  * these events, as it isn't required by the specification.
1036  *
1037  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1038  * functions have been added to mitigate the well-known issues around setting
1039  * allowances. See {IERC20-approve}.
1040  */
1041 contract ERC20 is Context, IERC20 {
1042     using SafeMath for uint256;
1043 
1044     mapping (address => uint256) private _balances;
1045 
1046     mapping (address => mapping (address => uint256)) private _allowances;
1047 
1048     uint256 private _totalSupply;
1049 
1050     string private _name;
1051     string private _symbol;
1052     uint8 private _decimals;
1053 
1054     /**
1055      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1056      * a default value of 18.
1057      *
1058      * To select a different value for {decimals}, use {_setupDecimals}.
1059      *
1060      * All three of these values are immutable: they can only be set once during
1061      * construction.
1062      */
1063     constructor (string memory name_, string memory symbol_) public {
1064         _name = name_;
1065         _symbol = symbol_;
1066         _decimals = 4;
1067     }
1068 
1069     /**
1070      * @dev Returns the name of the token.
1071      */
1072     function name() public view returns (string memory) {
1073         return _name;
1074     }
1075 
1076     /**
1077      * @dev Returns the symbol of the token, usually a shorter version of the
1078      * name.
1079      */
1080     function symbol() public view returns (string memory) {
1081         return _symbol;
1082     }
1083 
1084     /**
1085      * @dev Returns the number of decimals used to get its user representation.
1086      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1087      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1088      *
1089      * Tokens usually opt for a value of 18, imitating the relationship between
1090      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1091      * called.
1092      *
1093      * NOTE: This information is only used for _display_ purposes: it in
1094      * no way affects any of the arithmetic of the contract, including
1095      * {IERC20-balanceOf} and {IERC20-transfer}.
1096      */
1097     function decimals() public view returns (uint8) {
1098         return _decimals;
1099     }
1100 
1101     /**
1102      * @dev See {IERC20-totalSupply}.
1103      */
1104     function totalSupply() public view override returns (uint256) {
1105         return _totalSupply;
1106     }
1107 
1108     /**
1109      * @dev See {IERC20-balanceOf}.
1110      */
1111     function balanceOf(address account) public view override returns (uint256) {
1112         return _balances[account];
1113     }
1114 
1115     /**
1116      * @dev See {IERC20-transfer}.
1117      *
1118      * Requirements:
1119      *
1120      * - `recipient` cannot be the zero address.
1121      * - the caller must have a balance of at least `amount`.
1122      */
1123     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1124         _transfer(_msgSender(), recipient, amount);
1125         return true;
1126     }
1127 
1128     /**
1129      * @dev See {IERC20-allowance}.
1130      */
1131     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1132         return _allowances[owner][spender];
1133     }
1134 
1135     /**
1136      * @dev See {IERC20-approve}.
1137      *
1138      * Requirements:
1139      *
1140      * - `spender` cannot be the zero address.
1141      */
1142     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1143         _approve(_msgSender(), spender, amount);
1144         return true;
1145     }
1146 
1147     /**
1148      * @dev See {IERC20-transferFrom}.
1149      *
1150      * Emits an {Approval} event indicating the updated allowance. This is not
1151      * required by the EIP. See the note at the beginning of {ERC20}.
1152      *
1153      * Requirements:
1154      *
1155      * - `sender` and `recipient` cannot be the zero address.
1156      * - `sender` must have a balance of at least `amount`.
1157      * - the caller must have allowance for ``sender``'s tokens of at least
1158      * `amount`.
1159      */
1160     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1161         _transfer(sender, recipient, amount);
1162         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1163         return true;
1164     }
1165 
1166     /**
1167      * @dev Atomically increases the allowance granted to `spender` by the caller.
1168      *
1169      * This is an alternative to {approve} that can be used as a mitigation for
1170      * problems described in {IERC20-approve}.
1171      *
1172      * Emits an {Approval} event indicating the updated allowance.
1173      *
1174      * Requirements:
1175      *
1176      * - `spender` cannot be the zero address.
1177      */
1178     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1179         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1180         return true;
1181     }
1182 
1183     /**
1184      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1185      *
1186      * This is an alternative to {approve} that can be used as a mitigation for
1187      * problems described in {IERC20-approve}.
1188      *
1189      * Emits an {Approval} event indicating the updated allowance.
1190      *
1191      * Requirements:
1192      *
1193      * - `spender` cannot be the zero address.
1194      * - `spender` must have allowance for the caller of at least
1195      * `subtractedValue`.
1196      */
1197     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1198         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1199         return true;
1200     }
1201 
1202     /**
1203      * @dev Moves tokens `amount` from `sender` to `recipient`.
1204      *
1205      * This is internal function is equivalent to {transfer}, and can be used to
1206      * e.g. implement automatic token fees, slashing mechanisms, etc.
1207      *
1208      * Emits a {Transfer} event.
1209      *
1210      * Requirements:
1211      *
1212      * - `sender` cannot be the zero address.
1213      * - `recipient` cannot be the zero address.
1214      * - `sender` must have a balance of at least `amount`.
1215      */
1216     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1217         require(sender != address(0), "ERC20: transfer from the zero address");
1218         require(recipient != address(0), "ERC20: transfer to the zero address");
1219 
1220         _beforeTokenTransfer(sender, recipient, amount);
1221 
1222         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1223         _balances[recipient] = _balances[recipient].add(amount);
1224         emit Transfer(sender, recipient, amount);
1225     }
1226 
1227     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1228      * the total supply.
1229      *
1230      * Emits a {Transfer} event with `from` set to the zero address.
1231      *
1232      * Requirements:
1233      *
1234      * - `to` cannot be the zero address.
1235      */
1236     function _mint(address account, uint256 amount) internal virtual {
1237         require(account != address(0), "ERC20: mint to the zero address");
1238 
1239         _beforeTokenTransfer(address(0), account, amount);
1240 
1241         _totalSupply = _totalSupply.add(amount);
1242         _balances[account] = _balances[account].add(amount);
1243         emit Transfer(address(0), account, amount);
1244     }
1245 
1246     /**
1247      * @dev Destroys `amount` tokens from `account`, reducing the
1248      * total supply.
1249      *
1250      * Emits a {Transfer} event with `to` set to the zero address.
1251      *
1252      * Requirements:
1253      *
1254      * - `account` cannot be the zero address.
1255      * - `account` must have at least `amount` tokens.
1256      */
1257     function _burn(address account, uint256 amount) internal virtual {
1258         require(account != address(0), "ERC20: burn from the zero address");
1259 
1260         _beforeTokenTransfer(account, address(0), amount);
1261 
1262         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1263         _totalSupply = _totalSupply.sub(amount);
1264         emit Transfer(account, address(0), amount);
1265     }
1266 
1267     /**
1268      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1269      *
1270      * This internal function is equivalent to `approve`, and can be used to
1271      * e.g. set automatic allowances for certain subsystems, etc.
1272      *
1273      * Emits an {Approval} event.
1274      *
1275      * Requirements:
1276      *
1277      * - `owner` cannot be the zero address.
1278      * - `spender` cannot be the zero address.
1279      */
1280     function _approve(address owner, address spender, uint256 amount) internal virtual {
1281         require(owner != address(0), "ERC20: approve from the zero address");
1282         require(spender != address(0), "ERC20: approve to the zero address");
1283 
1284         _allowances[owner][spender] = amount;
1285         emit Approval(owner, spender, amount);
1286     }
1287 
1288     /**
1289      * @dev Sets {decimals} to a value other than the default one of 18.
1290      *
1291      * WARNING: This function should only be called from the constructor. Most
1292      * applications that interact with token contracts will not expect
1293      * {decimals} to ever change, and may work incorrectly if it does.
1294      */
1295     function _setupDecimals(uint8 decimals_) internal {
1296         _decimals = decimals_;
1297     }
1298 
1299     /**
1300      * @dev Hook that is called before any transfer of tokens. This includes
1301      * minting and burning.
1302      *
1303      * Calling conditions:
1304      *
1305      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1306      * will be to transferred to `to`.
1307      * - when `from` is zero, `amount` tokens will be minted for `to`.
1308      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1309      * - `from` and `to` are never both zero.
1310      *
1311      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1312      */
1313     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1314 }
1315 
1316 pragma solidity >=0.6.0 <0.8.0;
1317 
1318 
1319 /**
1320  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1321  * tokens and those that they have an allowance for, in a way that can be
1322  * recognized off-chain (via event analysis).
1323  */
1324 abstract contract ERC20Burnable is Context, ERC20 {
1325     using SafeMath for uint256;
1326 
1327     /**
1328      * @dev Destroys `amount` tokens from the caller.
1329      *
1330      * See {ERC20-_burn}.
1331      */
1332     function burn(uint256 amount) public virtual {
1333         _burn(_msgSender(), amount);
1334     }
1335 
1336     /**
1337      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1338      * allowance.
1339      *
1340      * See {ERC20-_burn} and {ERC20-allowance}.
1341      *
1342      * Requirements:
1343      *
1344      * - the caller must have allowance for ``accounts``'s tokens of at least
1345      * `amount`.
1346      */
1347     function burnFrom(address account, uint256 amount) public virtual {
1348         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1349 
1350         _approve(account, _msgSender(), decreasedAllowance);
1351         _burn(account, amount);
1352     }
1353 }
1354 
1355 pragma solidity >=0.6.0 <0.8.0;
1356 
1357 /**
1358  * @dev Contract module which allows children to implement an emergency stop
1359  * mechanism that can be triggered by an authorized account.
1360  *
1361  * This module is used through inheritance. It will make available the
1362  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1363  * the functions of your contract. Note that they will not be pausable by
1364  * simply including this module, only once the modifiers are put in place.
1365  */
1366 abstract contract Pausable is Context {
1367     /**
1368      * @dev Emitted when the pause is triggered by `account`.
1369      */
1370     event Paused(address account);
1371 
1372     /**
1373      * @dev Emitted when the pause is lifted by `account`.
1374      */
1375     event Unpaused(address account);
1376 
1377     bool private _paused;
1378 
1379     /**
1380      * @dev Initializes the contract in unpaused state.
1381      */
1382     constructor () internal {
1383         _paused = false;
1384     }
1385 
1386     /**
1387      * @dev Returns true if the contract is paused, and false otherwise.
1388      */
1389     function paused() public view returns (bool) {
1390         return _paused;
1391     }
1392 
1393     /**
1394      * @dev Modifier to make a function callable only when the contract is not paused.
1395      *
1396      * Requirements:
1397      *
1398      * - The contract must not be paused.
1399      */
1400     modifier whenNotPaused() {
1401         require(!_paused, "Pausable: paused");
1402         _;
1403     }
1404 
1405     /**
1406      * @dev Modifier to make a function callable only when the contract is paused.
1407      *
1408      * Requirements:
1409      *
1410      * - The contract must be paused.
1411      */
1412     modifier whenPaused() {
1413         require(_paused, "Pausable: not paused");
1414         _;
1415     }
1416 
1417     /**
1418      * @dev Triggers stopped state.
1419      *
1420      * Requirements:
1421      *
1422      * - The contract must not be paused.
1423      */
1424     function _pause() internal virtual whenNotPaused {
1425         _paused = true;
1426         emit Paused(_msgSender());
1427     }
1428 
1429     /**
1430      * @dev Returns to normal state.
1431      *
1432      * Requirements:
1433      *
1434      * - The contract must be paused.
1435      */
1436     function _unpause() internal virtual whenPaused {
1437         _paused = false;
1438         emit Unpaused(_msgSender());
1439     }
1440 }
1441 
1442 pragma solidity >=0.6.0 <0.8.0;
1443 
1444 
1445 /**
1446  * @dev ERC20 token with pausable token transfers, minting and burning.
1447  *
1448  * Useful for scenarios such as preventing trades until the end of an evaluation
1449  * period, or having an emergency switch for freezing all token transfers in the
1450  * event of a large bug.
1451  */
1452 abstract contract ERC20Pausable is ERC20, Pausable {
1453     /**
1454      * @dev See {ERC20-_beforeTokenTransfer}.
1455      *
1456      * Requirements:
1457      *
1458      * - the contract must not be paused.
1459      */
1460     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1461         super._beforeTokenTransfer(from, to, amount);
1462 
1463         require(!paused(), "ERC20Pausable: token transfer while paused");
1464     }
1465 }
1466 
1467 pragma solidity >=0.6.0 <0.8.0;
1468 
1469 /**
1470  * @dev {ERC20} token, including:
1471  *
1472  *  - ability for holders to burn (destroy) their tokens
1473  *  - a minter role that allows for token minting (creation)
1474  *  - a pauser role that allows to stop all token transfers
1475  *
1476  * This contract uses {AccessControl} to lock permissioned functions using the
1477  * different roles - head to its documentation for details.
1478  *
1479  * The account that deploys the contract will be granted the minter and pauser
1480  * roles, as well as the default admin role, which will let it grant both minter
1481  * and pauser roles to other accounts.
1482  */
1483 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1484     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1485     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1486 
1487     /**
1488      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1489      * account that deploys the contract.
1490      *
1491      * See {ERC20-constructor}.
1492      */
1493     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1494         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1495 
1496         _setupRole(MINTER_ROLE, _msgSender());
1497         _setupRole(PAUSER_ROLE, _msgSender());
1498     }
1499 
1500     /**
1501      * @dev Creates `amount` new tokens for `to`.
1502      *
1503      * See {ERC20-_mint}.
1504      *
1505      * Requirements:
1506      *
1507      * - the caller must have the `MINTER_ROLE`.
1508      */
1509     function mint(address to, uint256 amount) public virtual {
1510         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1511         _mint(to, amount);
1512     }
1513 
1514     /**
1515      * @dev Pauses all token transfers.
1516      *
1517      * See {ERC20Pausable} and {Pausable-_pause}.
1518      *
1519      * Requirements:
1520      *
1521      * - the caller must have the `PAUSER_ROLE`.
1522      */
1523     function pause() public virtual {
1524         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1525         _pause();
1526     }
1527 
1528     /**
1529      * @dev Unpauses all token transfers.
1530      *
1531      * See {ERC20Pausable} and {Pausable-_unpause}.
1532      *
1533      * Requirements:
1534      *
1535      * - the caller must have the `PAUSER_ROLE`.
1536      */
1537     function unpause() public virtual {
1538         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1539         _unpause();
1540     }
1541 
1542     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1543         super._beforeTokenTransfer(from, to, amount);
1544     }
1545 }
1546 
1547 
1548 pragma solidity >=0.6.0 <0.8.0;
1549 
1550 // Adds functionality for minting, burining and pausing GCR tokens.
1551 
1552 contract GCRToken is ERC20PresetMinterPauser, Ownable {
1553     uint256[3] public releaseTimes; // releaseTime 
1554     address public beneficiary; // vesting beneficiary
1555 
1556     // _amount = 40000000000 (mints 4M tokens right away)
1557     // _amount = 30000000000 (Invoke InitialRelease: mints 3M tokens)
1558     // _amount = 20000000000 (Invoke SecondRelease: mints 2M tokens)
1559     // _amount = 10000000000 (Invoke ThirdRelease: mints 1M tokens)
1560     
1561     uint256 InitialReleaseTime = 365 days;
1562     uint256 SecondReleaseTime = 730 days;
1563     uint256 ThirdReleaseTime = 1095 days;
1564 
1565     constructor(
1566         uint256 _amount,
1567         address _vestingBeneficiary
1568     ) ERC20PresetMinterPauser('Global Coin Research', 'GCR') {
1569         beneficiary = _vestingBeneficiary;
1570         // releaseTime in seconds
1571         releaseTimes = [(block.timestamp + InitialReleaseTime), (block.timestamp + SecondReleaseTime), (block.timestamp + ThirdReleaseTime)];
1572         _mint(_vestingBeneficiary, _amount);
1573     }
1574     
1575     /**
1576      * @notice Transfers tokens held by timelock to beneficiary.
1577      * Method adopted from TokenTimelock from OpenZepplin
1578      */
1579     function InitialRelease(uint256 _amount) public onlyOwner virtual {
1580         // solhint-disable-next-line not-rely-on-time
1581         require(_amount <= 60000000000, "Total supply must not exceed 10M.");
1582         require(block.timestamp >= releaseTimes[0], "Current time is before release time");
1583         _mint(beneficiary, _amount);
1584     }
1585     
1586     /**
1587      * @notice Transfers tokens held by timelock to beneficiary.
1588      * Method adopted from TokenTimelock from OpenZepplin
1589      */
1590     function SecondRelease(uint256 _amount) public onlyOwner virtual {
1591         // solhint-disable-next-line not-rely-on-time
1592         require(_amount <= 30000000000, "Total supply must not exceed 10M.");
1593         require(block.timestamp >= releaseTimes[1], "Current time is before release time");
1594         _mint(beneficiary, _amount);
1595     }
1596     
1597     /**
1598      * @notice Transfers tokens held by timelock to beneficiary.
1599      * Method adopted from TokenTimelock from OpenZepplin
1600      */
1601     function ThirdRelease(uint256 _amount) public onlyOwner virtual {
1602         // solhint-disable-next-line not-rely-on-time
1603         require(_amount <= 10000000000, "Total supply must not exceed 10M.");
1604         require(block.timestamp >= releaseTimes[2], "Current time is before release time");
1605         _mint(beneficiary, _amount);
1606     }
1607 }