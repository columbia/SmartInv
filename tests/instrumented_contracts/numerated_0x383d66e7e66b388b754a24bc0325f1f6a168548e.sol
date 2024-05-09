1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
99 
100 // SPDX-License-Identifier: MIT
101 
102 pragma solidity ^0.6.0;
103 
104 /**
105  * @dev Library for managing
106  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
107  * types.
108  *
109  * Sets have the following properties:
110  *
111  * - Elements are added, removed, and checked for existence in constant time
112  * (O(1)).
113  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
114  *
115  * ```
116  * contract Example {
117  *     // Add the library methods
118  *     using EnumerableSet for EnumerableSet.AddressSet;
119  *
120  *     // Declare a set state variable
121  *     EnumerableSet.AddressSet private mySet;
122  * }
123  * ```
124  *
125  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
126  * (`UintSet`) are supported.
127  */
128 library EnumerableSet {
129     // To implement this library for multiple types with as little code
130     // repetition as possible, we write it in terms of a generic Set type with
131     // bytes32 values.
132     // The Set implementation uses private functions, and user-facing
133     // implementations (such as AddressSet) are just wrappers around the
134     // underlying Set.
135     // This means that we can only create new EnumerableSets for types that fit
136     // in bytes32.
137 
138     struct Set {
139         // Storage of set values
140         bytes32[] _values;
141 
142         // Position of the value in the `values` array, plus 1 because index 0
143         // means a value is not in the set.
144         mapping (bytes32 => uint256) _indexes;
145     }
146 
147     /**
148      * @dev Add a value to a set. O(1).
149      *
150      * Returns true if the value was added to the set, that is if it was not
151      * already present.
152      */
153     function _add(Set storage set, bytes32 value) private returns (bool) {
154         if (!_contains(set, value)) {
155             set._values.push(value);
156             // The value is stored at length-1, but we add 1 to all indexes
157             // and use 0 as a sentinel value
158             set._indexes[value] = set._values.length;
159             return true;
160         } else {
161             return false;
162         }
163     }
164 
165     /**
166      * @dev Removes a value from a set. O(1).
167      *
168      * Returns true if the value was removed from the set, that is if it was
169      * present.
170      */
171     function _remove(Set storage set, bytes32 value) private returns (bool) {
172         // We read and store the value's index to prevent multiple reads from the same storage slot
173         uint256 valueIndex = set._indexes[value];
174 
175         if (valueIndex != 0) { // Equivalent to contains(set, value)
176             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
177             // the array, and then remove the last element (sometimes called as 'swap and pop').
178             // This modifies the order of the array, as noted in {at}.
179 
180             uint256 toDeleteIndex = valueIndex - 1;
181             uint256 lastIndex = set._values.length - 1;
182 
183             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
184             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
185 
186             bytes32 lastvalue = set._values[lastIndex];
187 
188             // Move the last value to the index where the value to delete is
189             set._values[toDeleteIndex] = lastvalue;
190             // Update the index for the moved value
191             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
192 
193             // Delete the slot where the moved value was stored
194             set._values.pop();
195 
196             // Delete the index for the deleted slot
197             delete set._indexes[value];
198 
199             return true;
200         } else {
201             return false;
202         }
203     }
204 
205     /**
206      * @dev Returns true if the value is in the set. O(1).
207      */
208     function _contains(Set storage set, bytes32 value) private view returns (bool) {
209         return set._indexes[value] != 0;
210     }
211 
212     /**
213      * @dev Returns the number of values on the set. O(1).
214      */
215     function _length(Set storage set) private view returns (uint256) {
216         return set._values.length;
217     }
218 
219    /**
220     * @dev Returns the value stored at position `index` in the set. O(1).
221     *
222     * Note that there are no guarantees on the ordering of values inside the
223     * array, and it may change when more values are added or removed.
224     *
225     * Requirements:
226     *
227     * - `index` must be strictly less than {length}.
228     */
229     function _at(Set storage set, uint256 index) private view returns (bytes32) {
230         require(set._values.length > index, "EnumerableSet: index out of bounds");
231         return set._values[index];
232     }
233 
234     // AddressSet
235 
236     struct AddressSet {
237         Set _inner;
238     }
239 
240     /**
241      * @dev Add a value to a set. O(1).
242      *
243      * Returns true if the value was added to the set, that is if it was not
244      * already present.
245      */
246     function add(AddressSet storage set, address value) internal returns (bool) {
247         return _add(set._inner, bytes32(uint256(value)));
248     }
249 
250     /**
251      * @dev Removes a value from a set. O(1).
252      *
253      * Returns true if the value was removed from the set, that is if it was
254      * present.
255      */
256     function remove(AddressSet storage set, address value) internal returns (bool) {
257         return _remove(set._inner, bytes32(uint256(value)));
258     }
259 
260     /**
261      * @dev Returns true if the value is in the set. O(1).
262      */
263     function contains(AddressSet storage set, address value) internal view returns (bool) {
264         return _contains(set._inner, bytes32(uint256(value)));
265     }
266 
267     /**
268      * @dev Returns the number of values in the set. O(1).
269      */
270     function length(AddressSet storage set) internal view returns (uint256) {
271         return _length(set._inner);
272     }
273 
274    /**
275     * @dev Returns the value stored at position `index` in the set. O(1).
276     *
277     * Note that there are no guarantees on the ordering of values inside the
278     * array, and it may change when more values are added or removed.
279     *
280     * Requirements:
281     *
282     * - `index` must be strictly less than {length}.
283     */
284     function at(AddressSet storage set, uint256 index) internal view returns (address) {
285         return address(uint256(_at(set._inner, index)));
286     }
287 
288 
289     // UintSet
290 
291     struct UintSet {
292         Set _inner;
293     }
294 
295     /**
296      * @dev Add a value to a set. O(1).
297      *
298      * Returns true if the value was added to the set, that is if it was not
299      * already present.
300      */
301     function add(UintSet storage set, uint256 value) internal returns (bool) {
302         return _add(set._inner, bytes32(value));
303     }
304 
305     /**
306      * @dev Removes a value from a set. O(1).
307      *
308      * Returns true if the value was removed from the set, that is if it was
309      * present.
310      */
311     function remove(UintSet storage set, uint256 value) internal returns (bool) {
312         return _remove(set._inner, bytes32(value));
313     }
314 
315     /**
316      * @dev Returns true if the value is in the set. O(1).
317      */
318     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
319         return _contains(set._inner, bytes32(value));
320     }
321 
322     /**
323      * @dev Returns the number of values on the set. O(1).
324      */
325     function length(UintSet storage set) internal view returns (uint256) {
326         return _length(set._inner);
327     }
328 
329    /**
330     * @dev Returns the value stored at position `index` in the set. O(1).
331     *
332     * Note that there are no guarantees on the ordering of values inside the
333     * array, and it may change when more values are added or removed.
334     *
335     * Requirements:
336     *
337     * - `index` must be strictly less than {length}.
338     */
339     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
340         return uint256(_at(set._inner, index));
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Address.sol
345 
346 // SPDX-License-Identifier: MIT
347 
348 pragma solidity ^0.6.2;
349 
350 /**
351  * @dev Collection of functions related to the address type
352  */
353 library Address {
354     /**
355      * @dev Returns true if `account` is a contract.
356      *
357      * [IMPORTANT]
358      * ====
359      * It is unsafe to assume that an address for which this function returns
360      * false is an externally-owned account (EOA) and not a contract.
361      *
362      * Among others, `isContract` will return false for the following
363      * types of addresses:
364      *
365      *  - an externally-owned account
366      *  - a contract in construction
367      *  - an address where a contract will be created
368      *  - an address where a contract lived, but was destroyed
369      * ====
370      */
371     function isContract(address account) internal view returns (bool) {
372         // This method relies in extcodesize, which returns 0 for contracts in
373         // construction, since the code is only stored at the end of the
374         // constructor execution.
375 
376         uint256 size;
377         // solhint-disable-next-line no-inline-assembly
378         assembly { size := extcodesize(account) }
379         return size > 0;
380     }
381 
382     /**
383      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
384      * `recipient`, forwarding all available gas and reverting on errors.
385      *
386      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
387      * of certain opcodes, possibly making contracts go over the 2300 gas limit
388      * imposed by `transfer`, making them unable to receive funds via
389      * `transfer`. {sendValue} removes this limitation.
390      *
391      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
392      *
393      * IMPORTANT: because control is transferred to `recipient`, care must be
394      * taken to not create reentrancy vulnerabilities. Consider using
395      * {ReentrancyGuard} or the
396      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
397      */
398     function sendValue(address payable recipient, uint256 amount) internal {
399         require(address(this).balance >= amount, "Address: insufficient balance");
400 
401         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
402         (bool success, ) = recipient.call{ value: amount }("");
403         require(success, "Address: unable to send value, recipient may have reverted");
404     }
405 
406     /**
407      * @dev Performs a Solidity function call using a low level `call`. A
408      * plain`call` is an unsafe replacement for a function call: use this
409      * function instead.
410      *
411      * If `target` reverts with a revert reason, it is bubbled up by this
412      * function (like regular Solidity function calls).
413      *
414      * Returns the raw returned data. To convert to the expected return value,
415      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
416      *
417      * Requirements:
418      *
419      * - `target` must be a contract.
420      * - calling `target` with `data` must not revert.
421      *
422      * _Available since v3.1._
423      */
424     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
425       return functionCall(target, data, "Address: low-level call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
430      * `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
435         return _functionCallWithValue(target, data, 0, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but also transferring `value` wei to `target`.
441      *
442      * Requirements:
443      *
444      * - the calling contract must have an ETH balance of at least `value`.
445      * - the called Solidity function must be `payable`.
446      *
447      * _Available since v3.1._
448      */
449     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
455      * with `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
460         require(address(this).balance >= value, "Address: insufficient balance for call");
461         return _functionCallWithValue(target, data, value, errorMessage);
462     }
463 
464     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
465         require(isContract(target), "Address: call to non-contract");
466 
467         // solhint-disable-next-line avoid-low-level-calls
468         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
469         if (success) {
470             return returndata;
471         } else {
472             // Look for revert reason and bubble it up if present
473             if (returndata.length > 0) {
474                 // The easiest way to bubble the revert reason is using memory via assembly
475 
476                 // solhint-disable-next-line no-inline-assembly
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 // File: @openzeppelin/contracts/access/AccessControl.sol
489 
490 // SPDX-License-Identifier: MIT
491 
492 pragma solidity ^0.6.0;
493 
494 
495 
496 
497 /**
498  * @dev Contract module that allows children to implement role-based access
499  * control mechanisms.
500  *
501  * Roles are referred to by their `bytes32` identifier. These should be exposed
502  * in the external API and be unique. The best way to achieve this is by
503  * using `public constant` hash digests:
504  *
505  * ```
506  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
507  * ```
508  *
509  * Roles can be used to represent a set of permissions. To restrict access to a
510  * function call, use {hasRole}:
511  *
512  * ```
513  * function foo() public {
514  *     require(hasRole(MY_ROLE, msg.sender));
515  *     ...
516  * }
517  * ```
518  *
519  * Roles can be granted and revoked dynamically via the {grantRole} and
520  * {revokeRole} functions. Each role has an associated admin role, and only
521  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
522  *
523  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
524  * that only accounts with this role will be able to grant or revoke other
525  * roles. More complex role relationships can be created by using
526  * {_setRoleAdmin}.
527  *
528  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
529  * grant and revoke this role. Extra precautions should be taken to secure
530  * accounts that have been granted it.
531  */
532 abstract contract AccessControl is Context {
533     using EnumerableSet for EnumerableSet.AddressSet;
534     using Address for address;
535 
536     struct RoleData {
537         EnumerableSet.AddressSet members;
538         bytes32 adminRole;
539     }
540 
541     mapping (bytes32 => RoleData) private _roles;
542 
543     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
544 
545     /**
546      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
547      *
548      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
549      * {RoleAdminChanged} not being emitted signaling this.
550      *
551      * _Available since v3.1._
552      */
553     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
554 
555     /**
556      * @dev Emitted when `account` is granted `role`.
557      *
558      * `sender` is the account that originated the contract call, an admin role
559      * bearer except when using {_setupRole}.
560      */
561     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
562 
563     /**
564      * @dev Emitted when `account` is revoked `role`.
565      *
566      * `sender` is the account that originated the contract call:
567      *   - if using `revokeRole`, it is the admin role bearer
568      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
569      */
570     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
571 
572     /**
573      * @dev Returns `true` if `account` has been granted `role`.
574      */
575     function hasRole(bytes32 role, address account) public view returns (bool) {
576         return _roles[role].members.contains(account);
577     }
578 
579     /**
580      * @dev Returns the number of accounts that have `role`. Can be used
581      * together with {getRoleMember} to enumerate all bearers of a role.
582      */
583     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
584         return _roles[role].members.length();
585     }
586 
587     /**
588      * @dev Returns one of the accounts that have `role`. `index` must be a
589      * value between 0 and {getRoleMemberCount}, non-inclusive.
590      *
591      * Role bearers are not sorted in any particular way, and their ordering may
592      * change at any point.
593      *
594      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
595      * you perform all queries on the same block. See the following
596      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
597      * for more information.
598      */
599     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
600         return _roles[role].members.at(index);
601     }
602 
603     /**
604      * @dev Returns the admin role that controls `role`. See {grantRole} and
605      * {revokeRole}.
606      *
607      * To change a role's admin, use {_setRoleAdmin}.
608      */
609     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
610         return _roles[role].adminRole;
611     }
612 
613     /**
614      * @dev Grants `role` to `account`.
615      *
616      * If `account` had not been already granted `role`, emits a {RoleGranted}
617      * event.
618      *
619      * Requirements:
620      *
621      * - the caller must have ``role``'s admin role.
622      */
623     function grantRole(bytes32 role, address account) public virtual {
624         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
625 
626         _grantRole(role, account);
627     }
628 
629     /**
630      * @dev Revokes `role` from `account`.
631      *
632      * If `account` had been granted `role`, emits a {RoleRevoked} event.
633      *
634      * Requirements:
635      *
636      * - the caller must have ``role``'s admin role.
637      */
638     function revokeRole(bytes32 role, address account) public virtual {
639         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
640 
641         _revokeRole(role, account);
642     }
643 
644     /**
645      * @dev Revokes `role` from the calling account.
646      *
647      * Roles are often managed via {grantRole} and {revokeRole}: this function's
648      * purpose is to provide a mechanism for accounts to lose their privileges
649      * if they are compromised (such as when a trusted device is misplaced).
650      *
651      * If the calling account had been granted `role`, emits a {RoleRevoked}
652      * event.
653      *
654      * Requirements:
655      *
656      * - the caller must be `account`.
657      */
658     function renounceRole(bytes32 role, address account) public virtual {
659         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
660 
661         _revokeRole(role, account);
662     }
663 
664     /**
665      * @dev Grants `role` to `account`.
666      *
667      * If `account` had not been already granted `role`, emits a {RoleGranted}
668      * event. Note that unlike {grantRole}, this function doesn't perform any
669      * checks on the calling account.
670      *
671      * [WARNING]
672      * ====
673      * This function should only be called from the constructor when setting
674      * up the initial roles for the system.
675      *
676      * Using this function in any other way is effectively circumventing the admin
677      * system imposed by {AccessControl}.
678      * ====
679      */
680     function _setupRole(bytes32 role, address account) internal virtual {
681         _grantRole(role, account);
682     }
683 
684     /**
685      * @dev Sets `adminRole` as ``role``'s admin role.
686      *
687      * Emits a {RoleAdminChanged} event.
688      */
689     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
690         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
691         _roles[role].adminRole = adminRole;
692     }
693 
694     function _grantRole(bytes32 role, address account) private {
695         if (_roles[role].members.add(account)) {
696             emit RoleGranted(role, account, _msgSender());
697         }
698     }
699 
700     function _revokeRole(bytes32 role, address account) private {
701         if (_roles[role].members.remove(account)) {
702             emit RoleRevoked(role, account, _msgSender());
703         }
704     }
705 }
706 
707 // File: @openzeppelin/contracts/introspection/IERC165.sol
708 
709 // SPDX-License-Identifier: MIT
710 
711 pragma solidity ^0.6.0;
712 
713 /**
714  * @dev Interface of the ERC165 standard, as defined in the
715  * https://eips.ethereum.org/EIPS/eip-165[EIP].
716  *
717  * Implementers can declare support of contract interfaces, which can then be
718  * queried by others ({ERC165Checker}).
719  *
720  * For an implementation, see {ERC165}.
721  */
722 interface IERC165 {
723     /**
724      * @dev Returns true if this contract implements the interface defined by
725      * `interfaceId`. See the corresponding
726      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
727      * to learn more about how these ids are created.
728      *
729      * This function call must use less than 30 000 gas.
730      */
731     function supportsInterface(bytes4 interfaceId) external view returns (bool);
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
735 
736 // SPDX-License-Identifier: MIT
737 
738 pragma solidity ^0.6.2;
739 
740 
741 /**
742  * @dev Required interface of an ERC721 compliant contract.
743  */
744 interface IERC721 is IERC165 {
745     /**
746      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
747      */
748     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
749 
750     /**
751      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
752      */
753     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
754 
755     /**
756      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
757      */
758     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
759 
760     /**
761      * @dev Returns the number of tokens in ``owner``'s account.
762      */
763     function balanceOf(address owner) external view returns (uint256 balance);
764 
765     /**
766      * @dev Returns the owner of the `tokenId` token.
767      *
768      * Requirements:
769      *
770      * - `tokenId` must exist.
771      */
772     function ownerOf(uint256 tokenId) external view returns (address owner);
773 
774     /**
775      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
776      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
777      *
778      * Requirements:
779      *
780      * - `from` cannot be the zero address.
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must exist and be owned by `from`.
783      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
784      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
785      *
786      * Emits a {Transfer} event.
787      */
788     function safeTransferFrom(address from, address to, uint256 tokenId) external;
789 
790     /**
791      * @dev Transfers `tokenId` token from `from` to `to`.
792      *
793      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
794      *
795      * Requirements:
796      *
797      * - `from` cannot be the zero address.
798      * - `to` cannot be the zero address.
799      * - `tokenId` token must be owned by `from`.
800      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
801      *
802      * Emits a {Transfer} event.
803      */
804     function transferFrom(address from, address to, uint256 tokenId) external;
805 
806     /**
807      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
808      * The approval is cleared when the token is transferred.
809      *
810      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
811      *
812      * Requirements:
813      *
814      * - The caller must own the token or be an approved operator.
815      * - `tokenId` must exist.
816      *
817      * Emits an {Approval} event.
818      */
819     function approve(address to, uint256 tokenId) external;
820 
821     /**
822      * @dev Returns the account approved for `tokenId` token.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      */
828     function getApproved(uint256 tokenId) external view returns (address operator);
829 
830     /**
831      * @dev Approve or remove `operator` as an operator for the caller.
832      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
833      *
834      * Requirements:
835      *
836      * - The `operator` cannot be the caller.
837      *
838      * Emits an {ApprovalForAll} event.
839      */
840     function setApprovalForAll(address operator, bool _approved) external;
841 
842     /**
843      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
844      *
845      * See {setApprovalForAll}
846      */
847     function isApprovedForAll(address owner, address operator) external view returns (bool);
848 
849     /**
850       * @dev Safely transfers `tokenId` token from `from` to `to`.
851       *
852       * Requirements:
853       *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856       * - `tokenId` token must exist and be owned by `from`.
857       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
858       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
859       *
860       * Emits a {Transfer} event.
861       */
862     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
863 }
864 
865 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
866 
867 // SPDX-License-Identifier: MIT
868 
869 pragma solidity ^0.6.2;
870 
871 
872 /**
873  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
874  * @dev See https://eips.ethereum.org/EIPS/eip-721
875  */
876 interface IERC721Metadata is IERC721 {
877 
878     /**
879      * @dev Returns the token collection name.
880      */
881     function name() external view returns (string memory);
882 
883     /**
884      * @dev Returns the token collection symbol.
885      */
886     function symbol() external view returns (string memory);
887 
888     /**
889      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
890      */
891     function tokenURI(uint256 tokenId) external view returns (string memory);
892 }
893 
894 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
895 
896 // SPDX-License-Identifier: MIT
897 
898 pragma solidity ^0.6.2;
899 
900 
901 /**
902  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
903  * @dev See https://eips.ethereum.org/EIPS/eip-721
904  */
905 interface IERC721Enumerable is IERC721 {
906 
907     /**
908      * @dev Returns the total amount of tokens stored by the contract.
909      */
910     function totalSupply() external view returns (uint256);
911 
912     /**
913      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
914      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
915      */
916     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
917 
918     /**
919      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
920      * Use along with {totalSupply} to enumerate all tokens.
921      */
922     function tokenByIndex(uint256 index) external view returns (uint256);
923 }
924 
925 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
926 
927 // SPDX-License-Identifier: MIT
928 
929 pragma solidity ^0.6.0;
930 
931 /**
932  * @title ERC721 token receiver interface
933  * @dev Interface for any contract that wants to support safeTransfers
934  * from ERC721 asset contracts.
935  */
936 interface IERC721Receiver {
937     /**
938      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
939      * by `operator` from `from`, this function is called.
940      *
941      * It must return its Solidity selector to confirm the token transfer.
942      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
943      *
944      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
945      */
946     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
947     external returns (bytes4);
948 }
949 
950 // File: @openzeppelin/contracts/introspection/ERC165.sol
951 
952 // SPDX-License-Identifier: MIT
953 
954 pragma solidity ^0.6.0;
955 
956 
957 /**
958  * @dev Implementation of the {IERC165} interface.
959  *
960  * Contracts may inherit from this and call {_registerInterface} to declare
961  * their support of an interface.
962  */
963 contract ERC165 is IERC165 {
964     /*
965      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
966      */
967     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
968 
969     /**
970      * @dev Mapping of interface ids to whether or not it's supported.
971      */
972     mapping(bytes4 => bool) private _supportedInterfaces;
973 
974     constructor () internal {
975         // Derived contracts need only register support for their own interfaces,
976         // we register support for ERC165 itself here
977         _registerInterface(_INTERFACE_ID_ERC165);
978     }
979 
980     /**
981      * @dev See {IERC165-supportsInterface}.
982      *
983      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
984      */
985     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
986         return _supportedInterfaces[interfaceId];
987     }
988 
989     /**
990      * @dev Registers the contract as an implementer of the interface defined by
991      * `interfaceId`. Support of the actual ERC165 interface is automatic and
992      * registering its interface id is not required.
993      *
994      * See {IERC165-supportsInterface}.
995      *
996      * Requirements:
997      *
998      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
999      */
1000     function _registerInterface(bytes4 interfaceId) internal virtual {
1001         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1002         _supportedInterfaces[interfaceId] = true;
1003     }
1004 }
1005 
1006 // File: @openzeppelin/contracts/math/SafeMath.sol
1007 
1008 // SPDX-License-Identifier: MIT
1009 
1010 pragma solidity ^0.6.0;
1011 
1012 /**
1013  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1014  * checks.
1015  *
1016  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1017  * in bugs, because programmers usually assume that an overflow raises an
1018  * error, which is the standard behavior in high level programming languages.
1019  * `SafeMath` restores this intuition by reverting the transaction when an
1020  * operation overflows.
1021  *
1022  * Using this library instead of the unchecked operations eliminates an entire
1023  * class of bugs, so it's recommended to use it always.
1024  */
1025 library SafeMath {
1026     /**
1027      * @dev Returns the addition of two unsigned integers, reverting on
1028      * overflow.
1029      *
1030      * Counterpart to Solidity's `+` operator.
1031      *
1032      * Requirements:
1033      *
1034      * - Addition cannot overflow.
1035      */
1036     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1037         uint256 c = a + b;
1038         require(c >= a, "SafeMath: addition overflow");
1039 
1040         return c;
1041     }
1042 
1043     /**
1044      * @dev Returns the subtraction of two unsigned integers, reverting on
1045      * overflow (when the result is negative).
1046      *
1047      * Counterpart to Solidity's `-` operator.
1048      *
1049      * Requirements:
1050      *
1051      * - Subtraction cannot overflow.
1052      */
1053     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1054         return sub(a, b, "SafeMath: subtraction overflow");
1055     }
1056 
1057     /**
1058      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1059      * overflow (when the result is negative).
1060      *
1061      * Counterpart to Solidity's `-` operator.
1062      *
1063      * Requirements:
1064      *
1065      * - Subtraction cannot overflow.
1066      */
1067     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1068         require(b <= a, errorMessage);
1069         uint256 c = a - b;
1070 
1071         return c;
1072     }
1073 
1074     /**
1075      * @dev Returns the multiplication of two unsigned integers, reverting on
1076      * overflow.
1077      *
1078      * Counterpart to Solidity's `*` operator.
1079      *
1080      * Requirements:
1081      *
1082      * - Multiplication cannot overflow.
1083      */
1084     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1085         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1086         // benefit is lost if 'b' is also tested.
1087         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1088         if (a == 0) {
1089             return 0;
1090         }
1091 
1092         uint256 c = a * b;
1093         require(c / a == b, "SafeMath: multiplication overflow");
1094 
1095         return c;
1096     }
1097 
1098     /**
1099      * @dev Returns the integer division of two unsigned integers. Reverts on
1100      * division by zero. The result is rounded towards zero.
1101      *
1102      * Counterpart to Solidity's `/` operator. Note: this function uses a
1103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1104      * uses an invalid opcode to revert (consuming all remaining gas).
1105      *
1106      * Requirements:
1107      *
1108      * - The divisor cannot be zero.
1109      */
1110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1111         return div(a, b, "SafeMath: division by zero");
1112     }
1113 
1114     /**
1115      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1116      * division by zero. The result is rounded towards zero.
1117      *
1118      * Counterpart to Solidity's `/` operator. Note: this function uses a
1119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1120      * uses an invalid opcode to revert (consuming all remaining gas).
1121      *
1122      * Requirements:
1123      *
1124      * - The divisor cannot be zero.
1125      */
1126     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1127         require(b > 0, errorMessage);
1128         uint256 c = a / b;
1129         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1130 
1131         return c;
1132     }
1133 
1134     /**
1135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1136      * Reverts when dividing by zero.
1137      *
1138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1139      * opcode (which leaves remaining gas untouched) while Solidity uses an
1140      * invalid opcode to revert (consuming all remaining gas).
1141      *
1142      * Requirements:
1143      *
1144      * - The divisor cannot be zero.
1145      */
1146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1147         return mod(a, b, "SafeMath: modulo by zero");
1148     }
1149 
1150     /**
1151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1152      * Reverts with custom message when dividing by zero.
1153      *
1154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1155      * opcode (which leaves remaining gas untouched) while Solidity uses an
1156      * invalid opcode to revert (consuming all remaining gas).
1157      *
1158      * Requirements:
1159      *
1160      * - The divisor cannot be zero.
1161      */
1162     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1163         require(b != 0, errorMessage);
1164         return a % b;
1165     }
1166 }
1167 
1168 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1169 
1170 // SPDX-License-Identifier: MIT
1171 
1172 pragma solidity ^0.6.0;
1173 
1174 /**
1175  * @dev Library for managing an enumerable variant of Solidity's
1176  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1177  * type.
1178  *
1179  * Maps have the following properties:
1180  *
1181  * - Entries are added, removed, and checked for existence in constant time
1182  * (O(1)).
1183  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1184  *
1185  * ```
1186  * contract Example {
1187  *     // Add the library methods
1188  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1189  *
1190  *     // Declare a set state variable
1191  *     EnumerableMap.UintToAddressMap private myMap;
1192  * }
1193  * ```
1194  *
1195  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1196  * supported.
1197  */
1198 library EnumerableMap {
1199     // To implement this library for multiple types with as little code
1200     // repetition as possible, we write it in terms of a generic Map type with
1201     // bytes32 keys and values.
1202     // The Map implementation uses private functions, and user-facing
1203     // implementations (such as Uint256ToAddressMap) are just wrappers around
1204     // the underlying Map.
1205     // This means that we can only create new EnumerableMaps for types that fit
1206     // in bytes32.
1207 
1208     struct MapEntry {
1209         bytes32 _key;
1210         bytes32 _value;
1211     }
1212 
1213     struct Map {
1214         // Storage of map keys and values
1215         MapEntry[] _entries;
1216 
1217         // Position of the entry defined by a key in the `entries` array, plus 1
1218         // because index 0 means a key is not in the map.
1219         mapping (bytes32 => uint256) _indexes;
1220     }
1221 
1222     /**
1223      * @dev Adds a key-value pair to a map, or updates the value for an existing
1224      * key. O(1).
1225      *
1226      * Returns true if the key was added to the map, that is if it was not
1227      * already present.
1228      */
1229     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1230         // We read and store the key's index to prevent multiple reads from the same storage slot
1231         uint256 keyIndex = map._indexes[key];
1232 
1233         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1234             map._entries.push(MapEntry({ _key: key, _value: value }));
1235             // The entry is stored at length-1, but we add 1 to all indexes
1236             // and use 0 as a sentinel value
1237             map._indexes[key] = map._entries.length;
1238             return true;
1239         } else {
1240             map._entries[keyIndex - 1]._value = value;
1241             return false;
1242         }
1243     }
1244 
1245     /**
1246      * @dev Removes a key-value pair from a map. O(1).
1247      *
1248      * Returns true if the key was removed from the map, that is if it was present.
1249      */
1250     function _remove(Map storage map, bytes32 key) private returns (bool) {
1251         // We read and store the key's index to prevent multiple reads from the same storage slot
1252         uint256 keyIndex = map._indexes[key];
1253 
1254         if (keyIndex != 0) { // Equivalent to contains(map, key)
1255             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1256             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1257             // This modifies the order of the array, as noted in {at}.
1258 
1259             uint256 toDeleteIndex = keyIndex - 1;
1260             uint256 lastIndex = map._entries.length - 1;
1261 
1262             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1263             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1264 
1265             MapEntry storage lastEntry = map._entries[lastIndex];
1266 
1267             // Move the last entry to the index where the entry to delete is
1268             map._entries[toDeleteIndex] = lastEntry;
1269             // Update the index for the moved entry
1270             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1271 
1272             // Delete the slot where the moved entry was stored
1273             map._entries.pop();
1274 
1275             // Delete the index for the deleted slot
1276             delete map._indexes[key];
1277 
1278             return true;
1279         } else {
1280             return false;
1281         }
1282     }
1283 
1284     /**
1285      * @dev Returns true if the key is in the map. O(1).
1286      */
1287     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1288         return map._indexes[key] != 0;
1289     }
1290 
1291     /**
1292      * @dev Returns the number of key-value pairs in the map. O(1).
1293      */
1294     function _length(Map storage map) private view returns (uint256) {
1295         return map._entries.length;
1296     }
1297 
1298    /**
1299     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1300     *
1301     * Note that there are no guarantees on the ordering of entries inside the
1302     * array, and it may change when more entries are added or removed.
1303     *
1304     * Requirements:
1305     *
1306     * - `index` must be strictly less than {length}.
1307     */
1308     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1309         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1310 
1311         MapEntry storage entry = map._entries[index];
1312         return (entry._key, entry._value);
1313     }
1314 
1315     /**
1316      * @dev Returns the value associated with `key`.  O(1).
1317      *
1318      * Requirements:
1319      *
1320      * - `key` must be in the map.
1321      */
1322     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1323         return _get(map, key, "EnumerableMap: nonexistent key");
1324     }
1325 
1326     /**
1327      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1328      */
1329     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1330         uint256 keyIndex = map._indexes[key];
1331         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1332         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1333     }
1334 
1335     // UintToAddressMap
1336 
1337     struct UintToAddressMap {
1338         Map _inner;
1339     }
1340 
1341     /**
1342      * @dev Adds a key-value pair to a map, or updates the value for an existing
1343      * key. O(1).
1344      *
1345      * Returns true if the key was added to the map, that is if it was not
1346      * already present.
1347      */
1348     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1349         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1350     }
1351 
1352     /**
1353      * @dev Removes a value from a set. O(1).
1354      *
1355      * Returns true if the key was removed from the map, that is if it was present.
1356      */
1357     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1358         return _remove(map._inner, bytes32(key));
1359     }
1360 
1361     /**
1362      * @dev Returns true if the key is in the map. O(1).
1363      */
1364     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1365         return _contains(map._inner, bytes32(key));
1366     }
1367 
1368     /**
1369      * @dev Returns the number of elements in the map. O(1).
1370      */
1371     function length(UintToAddressMap storage map) internal view returns (uint256) {
1372         return _length(map._inner);
1373     }
1374 
1375    /**
1376     * @dev Returns the element stored at position `index` in the set. O(1).
1377     * Note that there are no guarantees on the ordering of values inside the
1378     * array, and it may change when more values are added or removed.
1379     *
1380     * Requirements:
1381     *
1382     * - `index` must be strictly less than {length}.
1383     */
1384     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1385         (bytes32 key, bytes32 value) = _at(map._inner, index);
1386         return (uint256(key), address(uint256(value)));
1387     }
1388 
1389     /**
1390      * @dev Returns the value associated with `key`.  O(1).
1391      *
1392      * Requirements:
1393      *
1394      * - `key` must be in the map.
1395      */
1396     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1397         return address(uint256(_get(map._inner, bytes32(key))));
1398     }
1399 
1400     /**
1401      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1402      */
1403     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1404         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1405     }
1406 }
1407 
1408 // File: @openzeppelin/contracts/utils/Strings.sol
1409 
1410 // SPDX-License-Identifier: MIT
1411 
1412 pragma solidity ^0.6.0;
1413 
1414 /**
1415  * @dev String operations.
1416  */
1417 library Strings {
1418     /**
1419      * @dev Converts a `uint256` to its ASCII `string` representation.
1420      */
1421     function toString(uint256 value) internal pure returns (string memory) {
1422         // Inspired by OraclizeAPI's implementation - MIT licence
1423         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1424 
1425         if (value == 0) {
1426             return "0";
1427         }
1428         uint256 temp = value;
1429         uint256 digits;
1430         while (temp != 0) {
1431             digits++;
1432             temp /= 10;
1433         }
1434         bytes memory buffer = new bytes(digits);
1435         uint256 index = digits - 1;
1436         temp = value;
1437         while (temp != 0) {
1438             buffer[index--] = byte(uint8(48 + temp % 10));
1439             temp /= 10;
1440         }
1441         return string(buffer);
1442     }
1443 }
1444 
1445 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1446 
1447 // SPDX-License-Identifier: MIT
1448 
1449 pragma solidity ^0.6.0;
1450 
1451 
1452 
1453 
1454 
1455 
1456 
1457 
1458 
1459 
1460 
1461 
1462 /**
1463  * @title ERC721 Non-Fungible Token Standard basic implementation
1464  * @dev see https://eips.ethereum.org/EIPS/eip-721
1465  */
1466 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1467     using SafeMath for uint256;
1468     using Address for address;
1469     using EnumerableSet for EnumerableSet.UintSet;
1470     using EnumerableMap for EnumerableMap.UintToAddressMap;
1471     using Strings for uint256;
1472 
1473     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1474     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1475     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1476 
1477     // Mapping from holder address to their (enumerable) set of owned tokens
1478     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1479 
1480     // Enumerable mapping from token ids to their owners
1481     EnumerableMap.UintToAddressMap private _tokenOwners;
1482 
1483     // Mapping from token ID to approved address
1484     mapping (uint256 => address) private _tokenApprovals;
1485 
1486     // Mapping from owner to operator approvals
1487     mapping (address => mapping (address => bool)) private _operatorApprovals;
1488 
1489     // Token name
1490     string private _name;
1491 
1492     // Token symbol
1493     string private _symbol;
1494 
1495     // Optional mapping for token URIs
1496     mapping (uint256 => string) private _tokenURIs;
1497 
1498     // Base URI
1499     string private _baseURI;
1500 
1501     /*
1502      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1503      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1504      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1505      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1506      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1507      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1508      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1509      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1510      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1511      *
1512      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1513      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1514      */
1515     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1516 
1517     /*
1518      *     bytes4(keccak256('name()')) == 0x06fdde03
1519      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1520      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1521      *
1522      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1523      */
1524     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1525 
1526     /*
1527      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1528      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1529      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1530      *
1531      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1532      */
1533     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1534 
1535     /**
1536      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1537      */
1538     constructor (string memory name, string memory symbol) public {
1539         _name = name;
1540         _symbol = symbol;
1541 
1542         // register the supported interfaces to conform to ERC721 via ERC165
1543         _registerInterface(_INTERFACE_ID_ERC721);
1544         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1545         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1546     }
1547 
1548     /**
1549      * @dev See {IERC721-balanceOf}.
1550      */
1551     function balanceOf(address owner) public view override returns (uint256) {
1552         require(owner != address(0), "ERC721: balance query for the zero address");
1553 
1554         return _holderTokens[owner].length();
1555     }
1556 
1557     /**
1558      * @dev See {IERC721-ownerOf}.
1559      */
1560     function ownerOf(uint256 tokenId) public view override returns (address) {
1561         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1562     }
1563 
1564     /**
1565      * @dev See {IERC721Metadata-name}.
1566      */
1567     function name() public view override returns (string memory) {
1568         return _name;
1569     }
1570 
1571     /**
1572      * @dev See {IERC721Metadata-symbol}.
1573      */
1574     function symbol() public view override returns (string memory) {
1575         return _symbol;
1576     }
1577 
1578     /**
1579      * @dev See {IERC721Metadata-tokenURI}.
1580      */
1581     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1582         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1583 
1584         string memory _tokenURI = _tokenURIs[tokenId];
1585 
1586         // If there is no base URI, return the token URI.
1587         if (bytes(_baseURI).length == 0) {
1588             return _tokenURI;
1589         }
1590         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1591         if (bytes(_tokenURI).length > 0) {
1592             return string(abi.encodePacked(_baseURI, _tokenURI));
1593         }
1594         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1595         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1596     }
1597 
1598     /**
1599     * @dev Returns the base URI set via {_setBaseURI}. This will be
1600     * automatically added as a prefix in {tokenURI} to each token's URI, or
1601     * to the token ID if no specific URI is set for that token ID.
1602     */
1603     function baseURI() public view returns (string memory) {
1604         return _baseURI;
1605     }
1606 
1607     /**
1608      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1609      */
1610     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1611         return _holderTokens[owner].at(index);
1612     }
1613 
1614     /**
1615      * @dev See {IERC721Enumerable-totalSupply}.
1616      */
1617     function totalSupply() public view override returns (uint256) {
1618         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1619         return _tokenOwners.length();
1620     }
1621 
1622     /**
1623      * @dev See {IERC721Enumerable-tokenByIndex}.
1624      */
1625     function tokenByIndex(uint256 index) public view override returns (uint256) {
1626         (uint256 tokenId, ) = _tokenOwners.at(index);
1627         return tokenId;
1628     }
1629 
1630     /**
1631      * @dev See {IERC721-approve}.
1632      */
1633     function approve(address to, uint256 tokenId) public virtual override {
1634         address owner = ownerOf(tokenId);
1635         require(to != owner, "ERC721: approval to current owner");
1636 
1637         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1638             "ERC721: approve caller is not owner nor approved for all"
1639         );
1640 
1641         _approve(to, tokenId);
1642     }
1643 
1644     /**
1645      * @dev See {IERC721-getApproved}.
1646      */
1647     function getApproved(uint256 tokenId) public view override returns (address) {
1648         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1649 
1650         return _tokenApprovals[tokenId];
1651     }
1652 
1653     /**
1654      * @dev See {IERC721-setApprovalForAll}.
1655      */
1656     function setApprovalForAll(address operator, bool approved) public virtual override {
1657         require(operator != _msgSender(), "ERC721: approve to caller");
1658 
1659         _operatorApprovals[_msgSender()][operator] = approved;
1660         emit ApprovalForAll(_msgSender(), operator, approved);
1661     }
1662 
1663     /**
1664      * @dev See {IERC721-isApprovedForAll}.
1665      */
1666     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1667         return _operatorApprovals[owner][operator];
1668     }
1669 
1670     /**
1671      * @dev See {IERC721-transferFrom}.
1672      */
1673     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1674         //solhint-disable-next-line max-line-length
1675         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1676 
1677         _transfer(from, to, tokenId);
1678     }
1679 
1680     /**
1681      * @dev See {IERC721-safeTransferFrom}.
1682      */
1683     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1684         safeTransferFrom(from, to, tokenId, "");
1685     }
1686 
1687     /**
1688      * @dev See {IERC721-safeTransferFrom}.
1689      */
1690     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1691         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1692         _safeTransfer(from, to, tokenId, _data);
1693     }
1694 
1695     /**
1696      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1697      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1698      *
1699      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1700      *
1701      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1702      * implement alternative mechanisms to perform token transfer, such as signature-based.
1703      *
1704      * Requirements:
1705      *
1706      * - `from` cannot be the zero address.
1707      * - `to` cannot be the zero address.
1708      * - `tokenId` token must exist and be owned by `from`.
1709      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1710      *
1711      * Emits a {Transfer} event.
1712      */
1713     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1714         _transfer(from, to, tokenId);
1715         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1716     }
1717 
1718     /**
1719      * @dev Returns whether `tokenId` exists.
1720      *
1721      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1722      *
1723      * Tokens start existing when they are minted (`_mint`),
1724      * and stop existing when they are burned (`_burn`).
1725      */
1726     function _exists(uint256 tokenId) internal view returns (bool) {
1727         return _tokenOwners.contains(tokenId);
1728     }
1729 
1730     /**
1731      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1732      *
1733      * Requirements:
1734      *
1735      * - `tokenId` must exist.
1736      */
1737     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1738         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1739         address owner = ownerOf(tokenId);
1740         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1741     }
1742 
1743     /**
1744      * @dev Safely mints `tokenId` and transfers it to `to`.
1745      *
1746      * Requirements:
1747      d*
1748      * - `tokenId` must not exist.
1749      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1750      *
1751      * Emits a {Transfer} event.
1752      */
1753     function _safeMint(address to, uint256 tokenId) internal virtual {
1754         _safeMint(to, tokenId, "");
1755     }
1756 
1757     /**
1758      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1759      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1760      */
1761     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1762         _mint(to, tokenId);
1763         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1764     }
1765 
1766     /**
1767      * @dev Mints `tokenId` and transfers it to `to`.
1768      *
1769      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1770      *
1771      * Requirements:
1772      *
1773      * - `tokenId` must not exist.
1774      * - `to` cannot be the zero address.
1775      *
1776      * Emits a {Transfer} event.
1777      */
1778     function _mint(address to, uint256 tokenId) internal virtual {
1779         require(to != address(0), "ERC721: mint to the zero address");
1780         require(!_exists(tokenId), "ERC721: token already minted");
1781 
1782         _beforeTokenTransfer(address(0), to, tokenId);
1783 
1784         _holderTokens[to].add(tokenId);
1785 
1786         _tokenOwners.set(tokenId, to);
1787 
1788         emit Transfer(address(0), to, tokenId);
1789     }
1790 
1791     /**
1792      * @dev Destroys `tokenId`.
1793      * The approval is cleared when the token is burned.
1794      *
1795      * Requirements:
1796      *
1797      * - `tokenId` must exist.
1798      *
1799      * Emits a {Transfer} event.
1800      */
1801     function _burn(uint256 tokenId) internal virtual {
1802         address owner = ownerOf(tokenId);
1803 
1804         _beforeTokenTransfer(owner, address(0), tokenId);
1805 
1806         // Clear approvals
1807         _approve(address(0), tokenId);
1808 
1809         // Clear metadata (if any)
1810         if (bytes(_tokenURIs[tokenId]).length != 0) {
1811             delete _tokenURIs[tokenId];
1812         }
1813 
1814         _holderTokens[owner].remove(tokenId);
1815 
1816         _tokenOwners.remove(tokenId);
1817 
1818         emit Transfer(owner, address(0), tokenId);
1819     }
1820 
1821     /**
1822      * @dev Transfers `tokenId` from `from` to `to`.
1823      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1824      *
1825      * Requirements:
1826      *
1827      * - `to` cannot be the zero address.
1828      * - `tokenId` token must be owned by `from`.
1829      *
1830      * Emits a {Transfer} event.
1831      */
1832     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1833         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1834         require(to != address(0), "ERC721: transfer to the zero address");
1835 
1836         _beforeTokenTransfer(from, to, tokenId);
1837 
1838         // Clear approvals from the previous owner
1839         _approve(address(0), tokenId);
1840 
1841         _holderTokens[from].remove(tokenId);
1842         _holderTokens[to].add(tokenId);
1843 
1844         _tokenOwners.set(tokenId, to);
1845 
1846         emit Transfer(from, to, tokenId);
1847     }
1848 
1849     /**
1850      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1851      *
1852      * Requirements:
1853      *
1854      * - `tokenId` must exist.
1855      */
1856     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1857         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1858         _tokenURIs[tokenId] = _tokenURI;
1859     }
1860 
1861     /**
1862      * @dev Internal function to set the base URI for all token IDs. It is
1863      * automatically added as a prefix to the value returned in {tokenURI},
1864      * or to the token ID if {tokenURI} is empty.
1865      */
1866     function _setBaseURI(string memory baseURI_) internal virtual {
1867         _baseURI = baseURI_;
1868     }
1869 
1870     /**
1871      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1872      * The call is not executed if the target address is not a contract.
1873      *
1874      * @param from address representing the previous owner of the given token ID
1875      * @param to target address that will receive the tokens
1876      * @param tokenId uint256 ID of the token to be transferred
1877      * @param _data bytes optional data to send along with the call
1878      * @return bool whether the call correctly returned the expected magic value
1879      */
1880     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1881         private returns (bool)
1882     {
1883         if (!to.isContract()) {
1884             return true;
1885         }
1886         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1887             IERC721Receiver(to).onERC721Received.selector,
1888             _msgSender(),
1889             from,
1890             tokenId,
1891             _data
1892         ), "ERC721: transfer to non ERC721Receiver implementer");
1893         bytes4 retval = abi.decode(returndata, (bytes4));
1894         return (retval == _ERC721_RECEIVED);
1895     }
1896 
1897     function _approve(address to, uint256 tokenId) private {
1898         _tokenApprovals[tokenId] = to;
1899         emit Approval(ownerOf(tokenId), to, tokenId);
1900     }
1901 
1902     /**
1903      * @dev Hook that is called before any token transfer. This includes minting
1904      * and burning.
1905      *
1906      * Calling conditions:
1907      *
1908      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1909      * transferred to `to`.
1910      * - When `from` is zero, `tokenId` will be minted for `to`.
1911      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1912      * - `from` cannot be the zero address.
1913      * - `to` cannot be the zero address.
1914      *
1915      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1916      */
1917     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1918 }
1919 
1920 // File: @openzeppelin/contracts/utils/Counters.sol
1921 
1922 // SPDX-License-Identifier: MIT
1923 
1924 pragma solidity ^0.6.0;
1925 
1926 
1927 /**
1928  * @title Counters
1929  * @author Matt Condon (@shrugs)
1930  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1931  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1932  *
1933  * Include with `using Counters for Counters.Counter;`
1934  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1935  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1936  * directly accessed.
1937  */
1938 library Counters {
1939     using SafeMath for uint256;
1940 
1941     struct Counter {
1942         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1943         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1944         // this feature: see https://github.com/ethereum/solidity/issues/4637
1945         uint256 _value; // default: 0
1946     }
1947 
1948     function current(Counter storage counter) internal view returns (uint256) {
1949         return counter._value;
1950     }
1951 
1952     function increment(Counter storage counter) internal {
1953         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1954         counter._value += 1;
1955     }
1956 
1957     function decrement(Counter storage counter) internal {
1958         counter._value = counter._value.sub(1);
1959     }
1960 }
1961 
1962 // File: contracts/BcaexOwnershipV2.sol
1963 
1964 // contracts/BcaexOwnershipV2.sol
1965 // SPDX-License-Identifier: MIT
1966 pragma solidity >=0.4.21 <0.7.0;
1967 
1968 
1969 
1970 
1971 
1972 
1973 contract BcaexOwnershipV2 is Ownable, AccessControl, ERC721 {
1974     using SafeMath for uint256;
1975     using Counters for Counters.Counter;
1976 
1977     Counters.Counter private _tokenIds;
1978     // Mapping from token ID to the creator's address.
1979     mapping(uint256 => address) private tokenCreators;
1980 
1981     // Event indicating metadata was updated.
1982     event TokenURIUpdated(uint256 indexed _tokenId, string  _uri);
1983 
1984     constructor() public ERC721("BCAEX", "BCA") {
1985         addRootRole();
1986     }
1987 
1988     // ----------------------------
1989     // Create a new role identifier for the minter role
1990     bytes32 public constant ROOT_ROLE = keccak256("ROOT_ROLE");
1991     // Create a new role identifier for the minter role
1992     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1993 
1994     function addRootRole() public onlyOwner {
1995         _setRoleAdmin(MINTER_ROLE, ROOT_ROLE);
1996         _setupRole(ROOT_ROLE,  msg.sender);
1997         _setupRole(MINTER_ROLE, msg.sender);
1998     }
1999 
2000     function addMinter(address _minter) public onlyOwner {
2001         _setupRole(MINTER_ROLE,  _minter);
2002     }
2003 
2004     function revokeMinter(address _minter) public onlyOwner {
2005         revokeRole(MINTER_ROLE,  _minter);
2006     }
2007     // ----------------------------
2008 
2009     /**
2010      * @dev Internal function creating a new token.
2011      * @param _uri string metadata uri associated with the token
2012      * @param _owner address of the _owner of the token.
2013      */
2014     function _createToken(string memory _uri, address _owner) internal returns (uint256) {
2015         _tokenIds.increment();
2016         uint256 newId = _tokenIds.current();
2017         _mint(_owner, newId);
2018         _setTokenURI(newId, _uri);
2019         tokenCreators[newId] = _owner;
2020         return newId;
2021     }
2022 
2023     /**
2024      * @dev Adds a new unique token to the supply.
2025      * @param _uri string metadata uri associated with the token.
2026      */
2027     function addNewToken(string memory _uri) public returns (uint256) {
2028       require(hasRole(MINTER_ROLE, msg.sender), "must be whitelisted to create tokens");
2029       _createToken(_uri, msg.sender);
2030     }
2031 
2032     /**
2033      * @dev Adds a new unique token to the supply by onlyOwner to creator.
2034      * @param _uri string metadata uri associated with the token.
2035      * @param _creator address of the owner of the token.
2036      */
2037     function addNewTokenToCreator(string memory _uri, address _creator) public onlyOwner returns (uint256) {
2038         return _createToken(_uri, _creator);
2039     }
2040 
2041     /**
2042      * @dev Adds a new unique token to the supply by onlyOwner to creator.
2043      * @param _uri string metadata uri associated with the token.
2044      * @param _creator address of the owner of the token.
2045      * @param _owner address of the owner of the token.
2046      */
2047     function addNewTokenToOwner(string memory _uri, address _creator, address _owner) public onlyOwner returns (uint256) {
2048         _tokenIds.increment();
2049         uint256 newId = _tokenIds.current();
2050         _mint(_owner, newId);
2051         _setTokenURI(newId, _uri);
2052         tokenCreators[newId] = _creator;
2053         return newId;
2054     }
2055 
2056     /**
2057     * @dev Gets the creator of the token.
2058     * @param _tokenId uint256 ID of the token.
2059     * @return address of the creator.
2060     */
2061     function tokenCreator(uint256 _tokenId) public view returns (address) {
2062         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2063         return tokenCreators[_tokenId];
2064     }
2065 
2066     /**
2067      * @dev Internal function for setting the token's creator.
2068      * @param _tokenId uint256 id of the token.
2069      * @param _creator address of the creator of the token.
2070      */
2071     function setTokenCreator(uint256 _tokenId, address _creator) public onlyOwner {
2072         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2073         tokenCreators[_tokenId] = _creator;
2074     }
2075 
2076     /**
2077      * @dev Updates the token metadata if the owner is also the creator.
2078      * @param _tokenId uint256 ID of the token.
2079      * @param _uri string metadata URI.
2080      */
2081     function updateTokenMetadata(uint256 _tokenId, string memory _uri)
2082       public
2083     {
2084         require(_isApprovedOrOwner(msg.sender, _tokenId), "BcaexOwnershipV2: transfer caller is not owner nor approved");
2085         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2086         _setTokenURI(_tokenId, _uri);
2087         emit TokenURIUpdated(_tokenId, _uri);
2088     }
2089 
2090     /**
2091      * @dev Updates the token metadata if the owner is also the creator.
2092      * @param _tokenId uint256 ID of the token.
2093      * @param _uri string metadata URI.
2094      */
2095     function updateTokenMetadataOnlyOwner(uint256 _tokenId, string memory _uri)
2096       public onlyOwner
2097     {
2098         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2099         _setTokenURI(_tokenId, _uri);
2100         emit TokenURIUpdated(_tokenId, _uri);
2101     }
2102 
2103     /**
2104      * @dev Deletes the token with the provided ID.
2105      * @param _tokenId uint256 ID of the token.
2106      */
2107     function deleteToken(uint256 _tokenId) public {
2108       require(_isApprovedOrOwner(msg.sender, _tokenId), "BcaexOwnershipV2: transfer caller is not owner nor approved");
2109       require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2110       _burn(_tokenId);
2111       delete tokenCreators[_tokenId];
2112     }
2113 
2114     /**
2115      * @dev Deletes the token with the provided ID.
2116      * @param _tokenId uint256 ID of the token.
2117     */
2118     function deleteTokenOnlyOwner(uint256 _tokenId) public onlyOwner {
2119       require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2120       _burn(_tokenId);
2121       delete tokenCreators[_tokenId];
2122     }
2123 }