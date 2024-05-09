1 pragma solidity ^0.6.0;
2 
3 /**
4  * @dev Standard math utilities missing in the Solidity language.
5  */
6 library Math {
7     /**
8      * @dev Returns the largest of two numbers.
9      */
10     function max(uint256 a, uint256 b) internal pure returns (uint256) {
11         return a >= b ? a : b;
12     }
13 
14     /**
15      * @dev Returns the smallest of two numbers.
16      */
17     function min(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a < b ? a : b;
19     }
20 
21     /**
22      * @dev Returns the average of two numbers. The result is rounded towards
23      * zero.
24      */
25     function average(uint256 a, uint256 b) internal pure returns (uint256) {
26         // (a + b) / 2 can overflow, so we distribute
27         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
28     }
29 }
30 
31 
32 
33 pragma solidity ^0.6.0;
34 
35 /*
36  * @dev Provides information about the current execution context, including the
37  * sender of the transaction and its data. While these are generally available
38  * via msg.sender and msg.data, they should not be accessed in such a direct
39  * manner, since when dealing with GSN meta-transactions the account sending and
40  * paying for execution may not be the actual sender (as far as an application
41  * is concerned).
42  *
43  * This contract is only required for intermediate, library-like contracts.
44  */
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address payable) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes memory) {
51         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
52         return msg.data;
53     }
54 }
55 
56 
57 
58 pragma solidity ^0.6.0;
59 
60 /**
61  * @dev Contract module which provides a basic access control mechanism, where
62  * there is an account (an owner) that can be granted exclusive access to
63  * specific functions.
64  *
65  * By default, the owner account will be the one that deploys the contract. This
66  * can later be changed with {transferOwnership}.
67  *
68  * This module is used through inheritance. It will make available the modifier
69  * `onlyOwner`, which can be applied to your functions to restrict their use to
70  * the owner.
71  */
72 contract Ownable is Context {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev Initializes the contract setting the deployer as the initial owner.
79      */
80     constructor () internal {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     /**
87      * @dev Returns the address of the current owner.
88      */
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(_owner == _msgSender(), "Ownable: caller is not the owner");
98         _;
99     }
100 
101     /**
102      * @dev Leaves the contract without owner. It will not be possible to call
103      * `onlyOwner` functions anymore. Can only be called by the current owner.
104      *
105      * NOTE: Renouncing ownership will leave the contract without an owner,
106      * thereby removing any functionality that is only available to the owner.
107      */
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Can only be called by the current owner.
116      */
117     function transferOwnership(address newOwner) public virtual onlyOwner {
118         require(newOwner != address(0), "Ownable: new owner is the zero address");
119         emit OwnershipTransferred(_owner, newOwner);
120         _owner = newOwner;
121     }
122 }
123 
124 
125 
126 pragma solidity ^0.6.0;
127 
128 
129 /**
130  * @dev Contract module which allows children to implement an emergency stop
131  * mechanism that can be triggered by an authorized account.
132  *
133  * This module is used through inheritance. It will make available the
134  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
135  * the functions of your contract. Note that they will not be pausable by
136  * simply including this module, only once the modifiers are put in place.
137  */
138 contract Pausable is Context {
139     /**
140      * @dev Emitted when the pause is triggered by `account`.
141      */
142     event Paused(address account);
143 
144     /**
145      * @dev Emitted when the pause is lifted by `account`.
146      */
147     event Unpaused(address account);
148 
149     bool private _paused;
150 
151     /**
152      * @dev Initializes the contract in unpaused state.
153      */
154     constructor () internal {
155         _paused = false;
156     }
157 
158     /**
159      * @dev Returns true if the contract is paused, and false otherwise.
160      */
161     function paused() public view returns (bool) {
162         return _paused;
163     }
164 
165     /**
166      * @dev Modifier to make a function callable only when the contract is not paused.
167      *
168      * Requirements:
169      *
170      * - The contract must not be paused.
171      */
172     modifier whenNotPaused() {
173         require(!_paused, "Pausable: paused");
174         _;
175     }
176 
177     /**
178      * @dev Modifier to make a function callable only when the contract is paused.
179      *
180      * Requirements:
181      *
182      * - The contract must be paused.
183      */
184     modifier whenPaused() {
185         require(_paused, "Pausable: not paused");
186         _;
187     }
188 
189     /**
190      * @dev Triggers stopped state.
191      *
192      * Requirements:
193      *
194      * - The contract must not be paused.
195      */
196     function _pause() internal virtual whenNotPaused {
197         _paused = true;
198         emit Paused(_msgSender());
199     }
200 
201     /**
202      * @dev Returns to normal state.
203      *
204      * Requirements:
205      *
206      * - The contract must be paused.
207      */
208     function _unpause() internal virtual whenPaused {
209         _paused = false;
210         emit Unpaused(_msgSender());
211     }
212 }
213 
214 
215 
216 pragma solidity ^0.6.0;
217 
218 /**
219  * @dev Library for managing
220  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
221  * types.
222  *
223  * Sets have the following properties:
224  *
225  * - Elements are added, removed, and checked for existence in constant time
226  * (O(1)).
227  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
228  *
229  * ```
230  * contract Example {
231  *     // Add the library methods
232  *     using EnumerableSet for EnumerableSet.AddressSet;
233  *
234  *     // Declare a set state variable
235  *     EnumerableSet.AddressSet private mySet;
236  * }
237  * ```
238  *
239  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
240  * (`UintSet`) are supported.
241  */
242 library EnumerableSet {
243     // To implement this library for multiple types with as little code
244     // repetition as possible, we write it in terms of a generic Set type with
245     // bytes32 values.
246     // The Set implementation uses private functions, and user-facing
247     // implementations (such as AddressSet) are just wrappers around the
248     // underlying Set.
249     // This means that we can only create new EnumerableSets for types that fit
250     // in bytes32.
251 
252     struct Set {
253         // Storage of set values
254         bytes32[] _values;
255 
256         // Position of the value in the `values` array, plus 1 because index 0
257         // means a value is not in the set.
258         mapping (bytes32 => uint256) _indexes;
259     }
260 
261     /**
262      * @dev Add a value to a set. O(1).
263      *
264      * Returns true if the value was added to the set, that is if it was not
265      * already present.
266      */
267     function _add(Set storage set, bytes32 value) private returns (bool) {
268         if (!_contains(set, value)) {
269             set._values.push(value);
270             // The value is stored at length-1, but we add 1 to all indexes
271             // and use 0 as a sentinel value
272             set._indexes[value] = set._values.length;
273             return true;
274         } else {
275             return false;
276         }
277     }
278 
279     /**
280      * @dev Removes a value from a set. O(1).
281      *
282      * Returns true if the value was removed from the set, that is if it was
283      * present.
284      */
285     function _remove(Set storage set, bytes32 value) private returns (bool) {
286         // We read and store the value's index to prevent multiple reads from the same storage slot
287         uint256 valueIndex = set._indexes[value];
288 
289         if (valueIndex != 0) { // Equivalent to contains(set, value)
290             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
291             // the array, and then remove the last element (sometimes called as 'swap and pop').
292             // This modifies the order of the array, as noted in {at}.
293 
294             uint256 toDeleteIndex = valueIndex - 1;
295             uint256 lastIndex = set._values.length - 1;
296 
297             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
298             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
299 
300             bytes32 lastvalue = set._values[lastIndex];
301 
302             // Move the last value to the index where the value to delete is
303             set._values[toDeleteIndex] = lastvalue;
304             // Update the index for the moved value
305             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
306 
307             // Delete the slot where the moved value was stored
308             set._values.pop();
309 
310             // Delete the index for the deleted slot
311             delete set._indexes[value];
312 
313             return true;
314         } else {
315             return false;
316         }
317     }
318 
319     /**
320      * @dev Returns true if the value is in the set. O(1).
321      */
322     function _contains(Set storage set, bytes32 value) private view returns (bool) {
323         return set._indexes[value] != 0;
324     }
325 
326     /**
327      * @dev Returns the number of values on the set. O(1).
328      */
329     function _length(Set storage set) private view returns (uint256) {
330         return set._values.length;
331     }
332 
333    /**
334     * @dev Returns the value stored at position `index` in the set. O(1).
335     *
336     * Note that there are no guarantees on the ordering of values inside the
337     * array, and it may change when more values are added or removed.
338     *
339     * Requirements:
340     *
341     * - `index` must be strictly less than {length}.
342     */
343     function _at(Set storage set, uint256 index) private view returns (bytes32) {
344         require(set._values.length > index, "EnumerableSet: index out of bounds");
345         return set._values[index];
346     }
347 
348     // AddressSet
349 
350     struct AddressSet {
351         Set _inner;
352     }
353 
354     /**
355      * @dev Add a value to a set. O(1).
356      *
357      * Returns true if the value was added to the set, that is if it was not
358      * already present.
359      */
360     function add(AddressSet storage set, address value) internal returns (bool) {
361         return _add(set._inner, bytes32(uint256(value)));
362     }
363 
364     /**
365      * @dev Removes a value from a set. O(1).
366      *
367      * Returns true if the value was removed from the set, that is if it was
368      * present.
369      */
370     function remove(AddressSet storage set, address value) internal returns (bool) {
371         return _remove(set._inner, bytes32(uint256(value)));
372     }
373 
374     /**
375      * @dev Returns true if the value is in the set. O(1).
376      */
377     function contains(AddressSet storage set, address value) internal view returns (bool) {
378         return _contains(set._inner, bytes32(uint256(value)));
379     }
380 
381     /**
382      * @dev Returns the number of values in the set. O(1).
383      */
384     function length(AddressSet storage set) internal view returns (uint256) {
385         return _length(set._inner);
386     }
387 
388    /**
389     * @dev Returns the value stored at position `index` in the set. O(1).
390     *
391     * Note that there are no guarantees on the ordering of values inside the
392     * array, and it may change when more values are added or removed.
393     *
394     * Requirements:
395     *
396     * - `index` must be strictly less than {length}.
397     */
398     function at(AddressSet storage set, uint256 index) internal view returns (address) {
399         return address(uint256(_at(set._inner, index)));
400     }
401 
402 
403     // UintSet
404 
405     struct UintSet {
406         Set _inner;
407     }
408 
409     /**
410      * @dev Add a value to a set. O(1).
411      *
412      * Returns true if the value was added to the set, that is if it was not
413      * already present.
414      */
415     function add(UintSet storage set, uint256 value) internal returns (bool) {
416         return _add(set._inner, bytes32(value));
417     }
418 
419     /**
420      * @dev Removes a value from a set. O(1).
421      *
422      * Returns true if the value was removed from the set, that is if it was
423      * present.
424      */
425     function remove(UintSet storage set, uint256 value) internal returns (bool) {
426         return _remove(set._inner, bytes32(value));
427     }
428 
429     /**
430      * @dev Returns true if the value is in the set. O(1).
431      */
432     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
433         return _contains(set._inner, bytes32(value));
434     }
435 
436     /**
437      * @dev Returns the number of values on the set. O(1).
438      */
439     function length(UintSet storage set) internal view returns (uint256) {
440         return _length(set._inner);
441     }
442 
443    /**
444     * @dev Returns the value stored at position `index` in the set. O(1).
445     *
446     * Note that there are no guarantees on the ordering of values inside the
447     * array, and it may change when more values are added or removed.
448     *
449     * Requirements:
450     *
451     * - `index` must be strictly less than {length}.
452     */
453     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
454         return uint256(_at(set._inner, index));
455     }
456 }
457 
458 
459 
460 pragma solidity ^0.6.2;
461 
462 /**
463  * @dev Collection of functions related to the address type
464  */
465 library Address {
466     /**
467      * @dev Returns true if `account` is a contract.
468      *
469      * [IMPORTANT]
470      * ====
471      * It is unsafe to assume that an address for which this function returns
472      * false is an externally-owned account (EOA) and not a contract.
473      *
474      * Among others, `isContract` will return false for the following
475      * types of addresses:
476      *
477      *  - an externally-owned account
478      *  - a contract in construction
479      *  - an address where a contract will be created
480      *  - an address where a contract lived, but was destroyed
481      * ====
482      */
483     function isContract(address account) internal view returns (bool) {
484         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
485         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
486         // for accounts without code, i.e. `keccak256('')`
487         bytes32 codehash;
488         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
489         // solhint-disable-next-line no-inline-assembly
490         assembly { codehash := extcodehash(account) }
491         return (codehash != accountHash && codehash != 0x0);
492     }
493 
494     /**
495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
496      * `recipient`, forwarding all available gas and reverting on errors.
497      *
498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
500      * imposed by `transfer`, making them unable to receive funds via
501      * `transfer`. {sendValue} removes this limitation.
502      *
503      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
504      *
505      * IMPORTANT: because control is transferred to `recipient`, care must be
506      * taken to not create reentrancy vulnerabilities. Consider using
507      * {ReentrancyGuard} or the
508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
509      */
510     function sendValue(address payable recipient, uint256 amount) internal {
511         require(address(this).balance >= amount, "Address: insufficient balance");
512 
513         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
514         (bool success, ) = recipient.call{ value: amount }("");
515         require(success, "Address: unable to send value, recipient may have reverted");
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain`call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
537       return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
547         return _functionCallWithValue(target, data, 0, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but also transferring `value` wei to `target`.
553      *
554      * Requirements:
555      *
556      * - the calling contract must have an ETH balance of at least `value`.
557      * - the called Solidity function must be `payable`.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
562         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
567      * with `errorMessage` as a fallback revert reason when `target` reverts.
568      *
569      * _Available since v3.1._
570      */
571     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
572         require(address(this).balance >= value, "Address: insufficient balance for call");
573         return _functionCallWithValue(target, data, value, errorMessage);
574     }
575 
576     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
577         require(isContract(target), "Address: call to non-contract");
578 
579         // solhint-disable-next-line avoid-low-level-calls
580         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
581         if (success) {
582             return returndata;
583         } else {
584             // Look for revert reason and bubble it up if present
585             if (returndata.length > 0) {
586                 // The easiest way to bubble the revert reason is using memory via assembly
587 
588                 // solhint-disable-next-line no-inline-assembly
589                 assembly {
590                     let returndata_size := mload(returndata)
591                     revert(add(32, returndata), returndata_size)
592                 }
593             } else {
594                 revert(errorMessage);
595             }
596         }
597     }
598 }
599 
600 
601 
602 pragma solidity ^0.6.0;
603 
604 
605 
606 
607 /**
608  * @dev Contract module that allows children to implement role-based access
609  * control mechanisms.
610  *
611  * Roles are referred to by their `bytes32` identifier. These should be exposed
612  * in the external API and be unique. The best way to achieve this is by
613  * using `public constant` hash digests:
614  *
615  * ```
616  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
617  * ```
618  *
619  * Roles can be used to represent a set of permissions. To restrict access to a
620  * function call, use {hasRole}:
621  *
622  * ```
623  * function foo() public {
624  *     require(hasRole(MY_ROLE, msg.sender));
625  *     ...
626  * }
627  * ```
628  *
629  * Roles can be granted and revoked dynamically via the {grantRole} and
630  * {revokeRole} functions. Each role has an associated admin role, and only
631  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
632  *
633  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
634  * that only accounts with this role will be able to grant or revoke other
635  * roles. More complex role relationships can be created by using
636  * {_setRoleAdmin}.
637  *
638  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
639  * grant and revoke this role. Extra precautions should be taken to secure
640  * accounts that have been granted it.
641  */
642 abstract contract AccessControl is Context {
643     using EnumerableSet for EnumerableSet.AddressSet;
644     using Address for address;
645 
646     struct RoleData {
647         EnumerableSet.AddressSet members;
648         bytes32 adminRole;
649     }
650 
651     mapping (bytes32 => RoleData) private _roles;
652 
653     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
654 
655     /**
656      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
657      *
658      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
659      * {RoleAdminChanged} not being emitted signaling this.
660      *
661      * _Available since v3.1._
662      */
663     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
664 
665     /**
666      * @dev Emitted when `account` is granted `role`.
667      *
668      * `sender` is the account that originated the contract call, an admin role
669      * bearer except when using {_setupRole}.
670      */
671     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
672 
673     /**
674      * @dev Emitted when `account` is revoked `role`.
675      *
676      * `sender` is the account that originated the contract call:
677      *   - if using `revokeRole`, it is the admin role bearer
678      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
679      */
680     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
681 
682     /**
683      * @dev Returns `true` if `account` has been granted `role`.
684      */
685     function hasRole(bytes32 role, address account) public view returns (bool) {
686         return _roles[role].members.contains(account);
687     }
688 
689     /**
690      * @dev Returns the number of accounts that have `role`. Can be used
691      * together with {getRoleMember} to enumerate all bearers of a role.
692      */
693     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
694         return _roles[role].members.length();
695     }
696 
697     /**
698      * @dev Returns one of the accounts that have `role`. `index` must be a
699      * value between 0 and {getRoleMemberCount}, non-inclusive.
700      *
701      * Role bearers are not sorted in any particular way, and their ordering may
702      * change at any point.
703      *
704      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
705      * you perform all queries on the same block. See the following
706      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
707      * for more information.
708      */
709     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
710         return _roles[role].members.at(index);
711     }
712 
713     /**
714      * @dev Returns the admin role that controls `role`. See {grantRole} and
715      * {revokeRole}.
716      *
717      * To change a role's admin, use {_setRoleAdmin}.
718      */
719     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
720         return _roles[role].adminRole;
721     }
722 
723     /**
724      * @dev Grants `role` to `account`.
725      *
726      * If `account` had not been already granted `role`, emits a {RoleGranted}
727      * event.
728      *
729      * Requirements:
730      *
731      * - the caller must have ``role``'s admin role.
732      */
733     function grantRole(bytes32 role, address account) public virtual {
734         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
735 
736         _grantRole(role, account);
737     }
738 
739     /**
740      * @dev Revokes `role` from `account`.
741      *
742      * If `account` had been granted `role`, emits a {RoleRevoked} event.
743      *
744      * Requirements:
745      *
746      * - the caller must have ``role``'s admin role.
747      */
748     function revokeRole(bytes32 role, address account) public virtual {
749         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
750 
751         _revokeRole(role, account);
752     }
753 
754     /**
755      * @dev Revokes `role` from the calling account.
756      *
757      * Roles are often managed via {grantRole} and {revokeRole}: this function's
758      * purpose is to provide a mechanism for accounts to lose their privileges
759      * if they are compromised (such as when a trusted device is misplaced).
760      *
761      * If the calling account had been granted `role`, emits a {RoleRevoked}
762      * event.
763      *
764      * Requirements:
765      *
766      * - the caller must be `account`.
767      */
768     function renounceRole(bytes32 role, address account) public virtual {
769         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
770 
771         _revokeRole(role, account);
772     }
773 
774     /**
775      * @dev Grants `role` to `account`.
776      *
777      * If `account` had not been already granted `role`, emits a {RoleGranted}
778      * event. Note that unlike {grantRole}, this function doesn't perform any
779      * checks on the calling account.
780      *
781      * [WARNING]
782      * ====
783      * This function should only be called from the constructor when setting
784      * up the initial roles for the system.
785      *
786      * Using this function in any other way is effectively circumventing the admin
787      * system imposed by {AccessControl}.
788      * ====
789      */
790     function _setupRole(bytes32 role, address account) internal virtual {
791         _grantRole(role, account);
792     }
793 
794     /**
795      * @dev Sets `adminRole` as ``role``'s admin role.
796      *
797      * Emits a {RoleAdminChanged} event.
798      */
799     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
800         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
801         _roles[role].adminRole = adminRole;
802     }
803 
804     function _grantRole(bytes32 role, address account) private {
805         if (_roles[role].members.add(account)) {
806             emit RoleGranted(role, account, _msgSender());
807         }
808     }
809 
810     function _revokeRole(bytes32 role, address account) private {
811         if (_roles[role].members.remove(account)) {
812             emit RoleRevoked(role, account, _msgSender());
813         }
814     }
815 }
816 
817 
818 
819 pragma solidity ^0.6.0;
820 
821 /**
822  * @dev Interface of the ERC20 standard as defined in the EIP.
823  */
824 interface IERC20 {
825     /**
826      * @dev Returns the amount of tokens in existence.
827      */
828     function totalSupply() external view returns (uint256);
829 
830     /**
831      * @dev Returns the amount of tokens owned by `account`.
832      */
833     function balanceOf(address account) external view returns (uint256);
834 
835     /**
836      * @dev Moves `amount` tokens from the caller's account to `recipient`.
837      *
838      * Returns a boolean value indicating whether the operation succeeded.
839      *
840      * Emits a {Transfer} event.
841      */
842     function transfer(address recipient, uint256 amount) external returns (bool);
843 
844     /**
845      * @dev Returns the remaining number of tokens that `spender` will be
846      * allowed to spend on behalf of `owner` through {transferFrom}. This is
847      * zero by default.
848      *
849      * This value changes when {approve} or {transferFrom} are called.
850      */
851     function allowance(address owner, address spender) external view returns (uint256);
852 
853     /**
854      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
855      *
856      * Returns a boolean value indicating whether the operation succeeded.
857      *
858      * IMPORTANT: Beware that changing an allowance with this method brings the risk
859      * that someone may use both the old and the new allowance by unfortunate
860      * transaction ordering. One possible solution to mitigate this race
861      * condition is to first reduce the spender's allowance to 0 and set the
862      * desired value afterwards:
863      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
864      *
865      * Emits an {Approval} event.
866      */
867     function approve(address spender, uint256 amount) external returns (bool);
868 
869     /**
870      * @dev Moves `amount` tokens from `sender` to `recipient` using the
871      * allowance mechanism. `amount` is then deducted from the caller's
872      * allowance.
873      *
874      * Returns a boolean value indicating whether the operation succeeded.
875      *
876      * Emits a {Transfer} event.
877      */
878     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
879 
880     /**
881      * @dev Emitted when `value` tokens are moved from one account (`from`) to
882      * another (`to`).
883      *
884      * Note that `value` may be zero.
885      */
886     event Transfer(address indexed from, address indexed to, uint256 value);
887 
888     /**
889      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
890      * a call to {approve}. `value` is the new allowance.
891      */
892     event Approval(address indexed owner, address indexed spender, uint256 value);
893 }
894 
895 
896 
897 pragma solidity ^0.6.0;
898 
899 /**
900  * @dev Wrappers over Solidity's arithmetic operations with added overflow
901  * checks.
902  *
903  * Arithmetic operations in Solidity wrap on overflow. This can easily result
904  * in bugs, because programmers usually assume that an overflow raises an
905  * error, which is the standard behavior in high level programming languages.
906  * `SafeMath` restores this intuition by reverting the transaction when an
907  * operation overflows.
908  *
909  * Using this library instead of the unchecked operations eliminates an entire
910  * class of bugs, so it's recommended to use it always.
911  */
912 library SafeMath {
913     /**
914      * @dev Returns the addition of two unsigned integers, reverting on
915      * overflow.
916      *
917      * Counterpart to Solidity's `+` operator.
918      *
919      * Requirements:
920      *
921      * - Addition cannot overflow.
922      */
923     function add(uint256 a, uint256 b) internal pure returns (uint256) {
924         uint256 c = a + b;
925         require(c >= a, "SafeMath: addition overflow");
926 
927         return c;
928     }
929 
930     /**
931      * @dev Returns the subtraction of two unsigned integers, reverting on
932      * overflow (when the result is negative).
933      *
934      * Counterpart to Solidity's `-` operator.
935      *
936      * Requirements:
937      *
938      * - Subtraction cannot overflow.
939      */
940     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
941         return sub(a, b, "SafeMath: subtraction overflow");
942     }
943 
944     /**
945      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
946      * overflow (when the result is negative).
947      *
948      * Counterpart to Solidity's `-` operator.
949      *
950      * Requirements:
951      *
952      * - Subtraction cannot overflow.
953      */
954     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
955         require(b <= a, errorMessage);
956         uint256 c = a - b;
957 
958         return c;
959     }
960 
961     /**
962      * @dev Returns the multiplication of two unsigned integers, reverting on
963      * overflow.
964      *
965      * Counterpart to Solidity's `*` operator.
966      *
967      * Requirements:
968      *
969      * - Multiplication cannot overflow.
970      */
971     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
972         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
973         // benefit is lost if 'b' is also tested.
974         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
975         if (a == 0) {
976             return 0;
977         }
978 
979         uint256 c = a * b;
980         require(c / a == b, "SafeMath: multiplication overflow");
981 
982         return c;
983     }
984 
985     /**
986      * @dev Returns the integer division of two unsigned integers. Reverts on
987      * division by zero. The result is rounded towards zero.
988      *
989      * Counterpart to Solidity's `/` operator. Note: this function uses a
990      * `revert` opcode (which leaves remaining gas untouched) while Solidity
991      * uses an invalid opcode to revert (consuming all remaining gas).
992      *
993      * Requirements:
994      *
995      * - The divisor cannot be zero.
996      */
997     function div(uint256 a, uint256 b) internal pure returns (uint256) {
998         return div(a, b, "SafeMath: division by zero");
999     }
1000 
1001     /**
1002      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1003      * division by zero. The result is rounded towards zero.
1004      *
1005      * Counterpart to Solidity's `/` operator. Note: this function uses a
1006      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1007      * uses an invalid opcode to revert (consuming all remaining gas).
1008      *
1009      * Requirements:
1010      *
1011      * - The divisor cannot be zero.
1012      */
1013     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1014         require(b > 0, errorMessage);
1015         uint256 c = a / b;
1016         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1017 
1018         return c;
1019     }
1020 
1021     /**
1022      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1023      * Reverts when dividing by zero.
1024      *
1025      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1026      * opcode (which leaves remaining gas untouched) while Solidity uses an
1027      * invalid opcode to revert (consuming all remaining gas).
1028      *
1029      * Requirements:
1030      *
1031      * - The divisor cannot be zero.
1032      */
1033     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1034         return mod(a, b, "SafeMath: modulo by zero");
1035     }
1036 
1037     /**
1038      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1039      * Reverts with custom message when dividing by zero.
1040      *
1041      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1042      * opcode (which leaves remaining gas untouched) while Solidity uses an
1043      * invalid opcode to revert (consuming all remaining gas).
1044      *
1045      * Requirements:
1046      *
1047      * - The divisor cannot be zero.
1048      */
1049     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1050         require(b != 0, errorMessage);
1051         return a % b;
1052     }
1053 }
1054 
1055 
1056 
1057 pragma solidity ^0.6.0;
1058 
1059 
1060 
1061 
1062 
1063 /**
1064  * @dev Implementation of the {IERC20} interface.
1065  *
1066  * This implementation is agnostic to the way tokens are created. This means
1067  * that a supply mechanism has to be added in a derived contract using {_mint}.
1068  * For a generic mechanism see {ERC20PresetMinterPauser}.
1069  *
1070  * TIP: For a detailed writeup see our guide
1071  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1072  * to implement supply mechanisms].
1073  *
1074  * We have followed general OpenZeppelin guidelines: functions revert instead
1075  * of returning `false` on failure. This behavior is nonetheless conventional
1076  * and does not conflict with the expectations of ERC20 applications.
1077  *
1078  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1079  * This allows applications to reconstruct the allowance for all accounts just
1080  * by listening to said events. Other implementations of the EIP may not emit
1081  * these events, as it isn't required by the specification.
1082  *
1083  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1084  * functions have been added to mitigate the well-known issues around setting
1085  * allowances. See {IERC20-approve}.
1086  */
1087 contract ERC20 is Context, IERC20 {
1088     using SafeMath for uint256;
1089     using Address for address;
1090 
1091     mapping (address => uint256) private _balances;
1092 
1093     mapping (address => mapping (address => uint256)) private _allowances;
1094 
1095     uint256 private _totalSupply;
1096 
1097     string private _name;
1098     string private _symbol;
1099     uint8 private _decimals;
1100 
1101     /**
1102      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1103      * a default value of 18.
1104      *
1105      * To select a different value for {decimals}, use {_setupDecimals}.
1106      *
1107      * All three of these values are immutable: they can only be set once during
1108      * construction.
1109      */
1110     constructor (string memory name, string memory symbol) public {
1111         _name = name;
1112         _symbol = symbol;
1113         _decimals = 18;
1114     }
1115 
1116     /**
1117      * @dev Returns the name of the token.
1118      */
1119     function name() public view returns (string memory) {
1120         return _name;
1121     }
1122 
1123     /**
1124      * @dev Returns the symbol of the token, usually a shorter version of the
1125      * name.
1126      */
1127     function symbol() public view returns (string memory) {
1128         return _symbol;
1129     }
1130 
1131     /**
1132      * @dev Returns the number of decimals used to get its user representation.
1133      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1134      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1135      *
1136      * Tokens usually opt for a value of 18, imitating the relationship between
1137      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1138      * called.
1139      *
1140      * NOTE: This information is only used for _display_ purposes: it in
1141      * no way affects any of the arithmetic of the contract, including
1142      * {IERC20-balanceOf} and {IERC20-transfer}.
1143      */
1144     function decimals() public view returns (uint8) {
1145         return _decimals;
1146     }
1147 
1148     /**
1149      * @dev See {IERC20-totalSupply}.
1150      */
1151     function totalSupply() public view override returns (uint256) {
1152         return _totalSupply;
1153     }
1154 
1155     /**
1156      * @dev See {IERC20-balanceOf}.
1157      */
1158     function balanceOf(address account) public view override returns (uint256) {
1159         return _balances[account];
1160     }
1161 
1162     /**
1163      * @dev See {IERC20-transfer}.
1164      *
1165      * Requirements:
1166      *
1167      * - `recipient` cannot be the zero address.
1168      * - the caller must have a balance of at least `amount`.
1169      */
1170     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1171         _transfer(_msgSender(), recipient, amount);
1172         return true;
1173     }
1174 
1175     /**
1176      * @dev See {IERC20-allowance}.
1177      */
1178     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1179         return _allowances[owner][spender];
1180     }
1181 
1182     /**
1183      * @dev See {IERC20-approve}.
1184      *
1185      * Requirements:
1186      *
1187      * - `spender` cannot be the zero address.
1188      */
1189     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1190         _approve(_msgSender(), spender, amount);
1191         return true;
1192     }
1193 
1194     /**
1195      * @dev See {IERC20-transferFrom}.
1196      *
1197      * Emits an {Approval} event indicating the updated allowance. This is not
1198      * required by the EIP. See the note at the beginning of {ERC20};
1199      *
1200      * Requirements:
1201      * - `sender` and `recipient` cannot be the zero address.
1202      * - `sender` must have a balance of at least `amount`.
1203      * - the caller must have allowance for ``sender``'s tokens of at least
1204      * `amount`.
1205      */
1206     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1207         _transfer(sender, recipient, amount);
1208         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1209         return true;
1210     }
1211 
1212     /**
1213      * @dev Atomically increases the allowance granted to `spender` by the caller.
1214      *
1215      * This is an alternative to {approve} that can be used as a mitigation for
1216      * problems described in {IERC20-approve}.
1217      *
1218      * Emits an {Approval} event indicating the updated allowance.
1219      *
1220      * Requirements:
1221      *
1222      * - `spender` cannot be the zero address.
1223      */
1224     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1225         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1226         return true;
1227     }
1228 
1229     /**
1230      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1231      *
1232      * This is an alternative to {approve} that can be used as a mitigation for
1233      * problems described in {IERC20-approve}.
1234      *
1235      * Emits an {Approval} event indicating the updated allowance.
1236      *
1237      * Requirements:
1238      *
1239      * - `spender` cannot be the zero address.
1240      * - `spender` must have allowance for the caller of at least
1241      * `subtractedValue`.
1242      */
1243     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1244         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1245         return true;
1246     }
1247 
1248     /**
1249      * @dev Moves tokens `amount` from `sender` to `recipient`.
1250      *
1251      * This is internal function is equivalent to {transfer}, and can be used to
1252      * e.g. implement automatic token fees, slashing mechanisms, etc.
1253      *
1254      * Emits a {Transfer} event.
1255      *
1256      * Requirements:
1257      *
1258      * - `sender` cannot be the zero address.
1259      * - `recipient` cannot be the zero address.
1260      * - `sender` must have a balance of at least `amount`.
1261      */
1262     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1263         require(sender != address(0), "ERC20: transfer from the zero address");
1264         require(recipient != address(0), "ERC20: transfer to the zero address");
1265 
1266         _beforeTokenTransfer(sender, recipient, amount);
1267 
1268         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1269         _balances[recipient] = _balances[recipient].add(amount);
1270         emit Transfer(sender, recipient, amount);
1271     }
1272 
1273     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1274      * the total supply.
1275      *
1276      * Emits a {Transfer} event with `from` set to the zero address.
1277      *
1278      * Requirements
1279      *
1280      * - `to` cannot be the zero address.
1281      */
1282     function _mint(address account, uint256 amount) internal virtual {
1283         require(account != address(0), "ERC20: mint to the zero address");
1284 
1285         _beforeTokenTransfer(address(0), account, amount);
1286 
1287         _totalSupply = _totalSupply.add(amount);
1288         _balances[account] = _balances[account].add(amount);
1289         emit Transfer(address(0), account, amount);
1290     }
1291 
1292     /**
1293      * @dev Destroys `amount` tokens from `account`, reducing the
1294      * total supply.
1295      *
1296      * Emits a {Transfer} event with `to` set to the zero address.
1297      *
1298      * Requirements
1299      *
1300      * - `account` cannot be the zero address.
1301      * - `account` must have at least `amount` tokens.
1302      */
1303     function _burn(address account, uint256 amount) internal virtual {
1304         require(account != address(0), "ERC20: burn from the zero address");
1305 
1306         _beforeTokenTransfer(account, address(0), amount);
1307 
1308         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1309         _totalSupply = _totalSupply.sub(amount);
1310         emit Transfer(account, address(0), amount);
1311     }
1312 
1313     /**
1314      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1315      *
1316      * This is internal function is equivalent to `approve`, and can be used to
1317      * e.g. set automatic allowances for certain subsystems, etc.
1318      *
1319      * Emits an {Approval} event.
1320      *
1321      * Requirements:
1322      *
1323      * - `owner` cannot be the zero address.
1324      * - `spender` cannot be the zero address.
1325      */
1326     function _approve(address owner, address spender, uint256 amount) internal virtual {
1327         require(owner != address(0), "ERC20: approve from the zero address");
1328         require(spender != address(0), "ERC20: approve to the zero address");
1329 
1330         _allowances[owner][spender] = amount;
1331         emit Approval(owner, spender, amount);
1332     }
1333 
1334     /**
1335      * @dev Sets {decimals} to a value other than the default one of 18.
1336      *
1337      * WARNING: This function should only be called from the constructor. Most
1338      * applications that interact with token contracts will not expect
1339      * {decimals} to ever change, and may work incorrectly if it does.
1340      */
1341     function _setupDecimals(uint8 decimals_) internal {
1342         _decimals = decimals_;
1343     }
1344 
1345     /**
1346      * @dev Hook that is called before any transfer of tokens. This includes
1347      * minting and burning.
1348      *
1349      * Calling conditions:
1350      *
1351      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1352      * will be to transferred to `to`.
1353      * - when `from` is zero, `amount` tokens will be minted for `to`.
1354      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1355      * - `from` and `to` are never both zero.
1356      *
1357      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1358      */
1359     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1360 }
1361 
1362 
1363 
1364 pragma solidity ^0.6.0;
1365 
1366 
1367 
1368 /**
1369  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1370  * tokens and those that they have an allowance for, in a way that can be
1371  * recognized off-chain (via event analysis).
1372  */
1373 abstract contract ERC20Burnable is Context, ERC20 {
1374     /**
1375      * @dev Destroys `amount` tokens from the caller.
1376      *
1377      * See {ERC20-_burn}.
1378      */
1379     function burn(uint256 amount) public virtual {
1380         _burn(_msgSender(), amount);
1381     }
1382 
1383     /**
1384      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1385      * allowance.
1386      *
1387      * See {ERC20-_burn} and {ERC20-allowance}.
1388      *
1389      * Requirements:
1390      *
1391      * - the caller must have allowance for ``accounts``'s tokens of at least
1392      * `amount`.
1393      */
1394     function burnFrom(address account, uint256 amount) public virtual {
1395         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1396 
1397         _approve(account, _msgSender(), decreasedAllowance);
1398         _burn(account, amount);
1399     }
1400 }
1401 
1402 
1403 
1404 pragma solidity 0.6.11;
1405 
1406 
1407 
1408 
1409 /**
1410  * @dev {ERC20} token, including:
1411  *
1412  *  - ability for holders to burn (destroy) their tokens
1413  *  - a minter role that allows for token minting (creation)
1414  *  - a pauser role that allows to stop all token transfers
1415  *
1416  * This contract uses {AccessControl} to lock permissioned functions using the
1417  * different roles - head to its documentation for details.
1418  *
1419  * The account that deploys the contract will be granted the minter and pauser
1420  * roles, as well as the default admin role, which will let it grant both minter
1421  * and pauser roles to other accounts.
1422  */
1423 contract BARTToken is Context, AccessControl, ERC20Burnable {
1424     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1425 
1426     /**
1427      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1428      * account that deploys the contract.
1429      *
1430      * See {ERC20-constructor}.
1431      */
1432     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1433         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1434 
1435         _setupRole(MINTER_ROLE, _msgSender());
1436     }
1437 
1438     /**
1439      * @dev Creates `amount` new tokens for `to`.
1440      *
1441      * See {ERC20-_mint}.
1442      *
1443      * Requirements:
1444      *
1445      * - the caller must have the `MINTER_ROLE`.
1446      */
1447     function mint(address to, uint256 amount) public virtual {
1448         require(hasRole(MINTER_ROLE, _msgSender()), "BARTToken: must have minter role to mint");
1449         _mint(to, amount);
1450     }
1451 }
1452 
1453 
1454 
1455 pragma solidity 0.6.11;
1456 
1457 
1458 
1459 
1460 
1461 
1462 /**
1463  * @title ERC20Migrator
1464  * @dev This contract can be used to migrate an ERC20 token from one
1465  * contract to another, where each token holder has to opt-in to the migration.
1466  * To opt-in, users must approve for this contract the number of tokens they
1467  * want to migrate. Once the allowance is set up, anyone can trigger the
1468  * migration to the new token contract. In this way, token holders "turn in"
1469  * their old balance and will be minted an equal amount in the new token.
1470  * The new token contract must be mintable. For the precise interface refer to
1471  * OpenZeppelin's BARTToken, but the only functions that are needed are
1472  * `isMinter(address)` and `mint(address, amount)`. The migrator will check
1473  * that it is a minter for the token.
1474  * The balance from the legacy token will be burned by the migrator, as it
1475  * is migrated.
1476  */
1477 contract ERC20Migrator is Pausable, Ownable {
1478   BARTToken private _legacyToken;
1479 
1480   BARTToken private _newToken;
1481 
1482   /**
1483    * @param legacyToken address of the old token contract
1484    */
1485   constructor (address legacyToken) public {
1486     require(legacyToken != address(0), "legacyToken address is required");
1487     _legacyToken = BARTToken(legacyToken);
1488   }
1489 
1490   /**
1491    * @dev Returns the legacy token that is being migrated.
1492    */
1493   function legacyToken() public view returns (address) {
1494     return address(_legacyToken);
1495   }
1496 
1497   /**
1498    * @dev Returns the new token to which we are migrating.
1499    */
1500   function newToken() public view returns (address) {
1501     return address(_newToken);
1502   }
1503 
1504   /**
1505    * @dev Begins the migration by setting which is the new token that will be
1506    * minted. This contract must be a minter for the new token.
1507    * @param newTokenAddress the token that will be minted
1508    */
1509   function beginMigration(address newTokenAddress) public onlyOwner {
1510     require(address(_newToken) == address(0), "_newToken must be 0");
1511     require(newTokenAddress != address(0), "newTokenAddress cannot be 0");
1512 
1513     _newToken = BARTToken(newTokenAddress);
1514 
1515     bytes32 MINTER_ROLE = _newToken.MINTER_ROLE();
1516     require(_newToken.hasRole(MINTER_ROLE, address(this)), "ERC20Migrator must be a minter");
1517   }
1518 
1519   /**
1520    * @dev Burn part of an account's balance in the old token
1521    * and mints the same amount of new tokens for that account.
1522    * @param account whose tokens will be migrated
1523    * @param amount amount of tokens to be migrated
1524    */
1525   function migrate(address account, uint256 amount) public whenNotPaused {
1526     _legacyToken.burnFrom(account, amount);
1527     _newToken.mint(account, amount);
1528   }
1529 
1530   /**
1531    * @dev Burns all of an account's allowed balance in the old token
1532    * and mints the same amount of new tokens for that account.
1533    * @param account whose tokens will be migrated
1534    */
1535   function migrateAll(address account) public {
1536     uint256 balance = _legacyToken.balanceOf(account);
1537     uint256 allowance = _legacyToken.allowance(account, address(this));
1538     uint256 amount = Math.min(balance, allowance);
1539     migrate(account, amount);
1540   }
1541 
1542   function pause() external onlyOwner {
1543       _pause();
1544   }
1545 
1546   function unpause() external onlyOwner {
1547       _unpause();
1548   }
1549 }