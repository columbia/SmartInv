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
495 pragma solidity >=0.6.0 <0.8.0;
496 
497 /**
498  * @dev Contract module which provides a basic access control mechanism, where
499  * there is an account (an owner) that can be granted exclusive access to
500  * specific functions.
501  *
502  * By default, the owner account will be the one that deploys the contract. This
503  * can later be changed with {transferOwnership}.
504  *
505  * This module is used through inheritance. It will make available the modifier
506  * `onlyOwner`, which can be applied to your functions to restrict their use to
507  * the owner.
508  */
509 abstract contract Ownable is Context {
510     address private _owner;
511 
512     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
513 
514     /**
515      * @dev Initializes the contract setting the deployer as the initial owner.
516      */
517     constructor () internal {
518         address msgSender = _msgSender();
519         _owner = msgSender;
520         emit OwnershipTransferred(address(0), msgSender);
521     }
522 
523     /**
524      * @dev Returns the address of the current owner.
525      */
526     function owner() public view virtual returns (address) {
527         return _owner;
528     }
529 
530     /**
531      * @dev Throws if called by any account other than the owner.
532      */
533     modifier onlyOwner() {
534         require(owner() == _msgSender(), "Ownable: caller is not the owner");
535         _;
536     }
537 
538     /**
539      * @dev Leaves the contract without owner. It will not be possible to call
540      * `onlyOwner` functions anymore. Can only be called by the current owner.
541      *
542      * NOTE: Renouncing ownership will leave the contract without an owner,
543      * thereby removing any functionality that is only available to the owner.
544      */
545     function renounceOwnership() public virtual onlyOwner {
546         emit OwnershipTransferred(_owner, address(0));
547         _owner = address(0);
548     }
549 
550     /**
551      * @dev Transfers ownership of the contract to a new account (`newOwner`).
552      * Can only be called by the current owner.
553      */
554     function transferOwnership(address newOwner) public virtual onlyOwner {
555         require(newOwner != address(0), "Ownable: new owner is the zero address");
556         emit OwnershipTransferred(_owner, newOwner);
557         _owner = newOwner;
558     }
559 }
560 
561 
562 // File @openzeppelin/contracts/access/AccessControl.sol@v3.3.0
563 
564 pragma solidity >=0.6.0 <0.8.0;
565 
566 
567 
568 /**
569  * @dev Contract module that allows children to implement role-based access
570  * control mechanisms.
571  *
572  * Roles are referred to by their `bytes32` identifier. These should be exposed
573  * in the external API and be unique. The best way to achieve this is by
574  * using `public constant` hash digests:
575  *
576  * ```
577  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
578  * ```
579  *
580  * Roles can be used to represent a set of permissions. To restrict access to a
581  * function call, use {hasRole}:
582  *
583  * ```
584  * function foo() public {
585  *     require(hasRole(MY_ROLE, msg.sender));
586  *     ...
587  * }
588  * ```
589  *
590  * Roles can be granted and revoked dynamically via the {grantRole} and
591  * {revokeRole} functions. Each role has an associated admin role, and only
592  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
593  *
594  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
595  * that only accounts with this role will be able to grant or revoke other
596  * roles. More complex role relationships can be created by using
597  * {_setRoleAdmin}.
598  *
599  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
600  * grant and revoke this role. Extra precautions should be taken to secure
601  * accounts that have been granted it.
602  */
603 abstract contract AccessControl is Context {
604     using EnumerableSet for EnumerableSet.AddressSet;
605     using Address for address;
606 
607     struct RoleData {
608         EnumerableSet.AddressSet members;
609         bytes32 adminRole;
610     }
611 
612     mapping (bytes32 => RoleData) private _roles;
613 
614     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
615 
616     /**
617      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
618      *
619      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
620      * {RoleAdminChanged} not being emitted signaling this.
621      *
622      * _Available since v3.1._
623      */
624     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
625 
626     /**
627      * @dev Emitted when `account` is granted `role`.
628      *
629      * `sender` is the account that originated the contract call, an admin role
630      * bearer except when using {_setupRole}.
631      */
632     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
633 
634     /**
635      * @dev Emitted when `account` is revoked `role`.
636      *
637      * `sender` is the account that originated the contract call:
638      *   - if using `revokeRole`, it is the admin role bearer
639      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
640      */
641     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
642 
643     /**
644      * @dev Returns `true` if `account` has been granted `role`.
645      */
646     function hasRole(bytes32 role, address account) public view returns (bool) {
647         return _roles[role].members.contains(account);
648     }
649 
650     /**
651      * @dev Returns the number of accounts that have `role`. Can be used
652      * together with {getRoleMember} to enumerate all bearers of a role.
653      */
654     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
655         return _roles[role].members.length();
656     }
657 
658     /**
659      * @dev Returns one of the accounts that have `role`. `index` must be a
660      * value between 0 and {getRoleMemberCount}, non-inclusive.
661      *
662      * Role bearers are not sorted in any particular way, and their ordering may
663      * change at any point.
664      *
665      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
666      * you perform all queries on the same block. See the following
667      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
668      * for more information.
669      */
670     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
671         return _roles[role].members.at(index);
672     }
673 
674     /**
675      * @dev Returns the admin role that controls `role`. See {grantRole} and
676      * {revokeRole}.
677      *
678      * To change a role's admin, use {_setRoleAdmin}.
679      */
680     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
681         return _roles[role].adminRole;
682     }
683 
684     /**
685      * @dev Grants `role` to `account`.
686      *
687      * If `account` had not been already granted `role`, emits a {RoleGranted}
688      * event.
689      *
690      * Requirements:
691      *
692      * - the caller must have ``role``'s admin role.
693      */
694     function grantRole(bytes32 role, address account) public virtual {
695         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
696 
697         _grantRole(role, account);
698     }
699 
700     /**
701      * @dev Revokes `role` from `account`.
702      *
703      * If `account` had been granted `role`, emits a {RoleRevoked} event.
704      *
705      * Requirements:
706      *
707      * - the caller must have ``role``'s admin role.
708      */
709     function revokeRole(bytes32 role, address account) public virtual {
710         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
711 
712         _revokeRole(role, account);
713     }
714 
715     /**
716      * @dev Revokes `role` from the calling account.
717      *
718      * Roles are often managed via {grantRole} and {revokeRole}: this function's
719      * purpose is to provide a mechanism for accounts to lose their privileges
720      * if they are compromised (such as when a trusted device is misplaced).
721      *
722      * If the calling account had been granted `role`, emits a {RoleRevoked}
723      * event.
724      *
725      * Requirements:
726      *
727      * - the caller must be `account`.
728      */
729     function renounceRole(bytes32 role, address account) public virtual {
730         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
731 
732         _revokeRole(role, account);
733     }
734 
735     /**
736      * @dev Grants `role` to `account`.
737      *
738      * If `account` had not been already granted `role`, emits a {RoleGranted}
739      * event. Note that unlike {grantRole}, this function doesn't perform any
740      * checks on the calling account.
741      *
742      * [WARNING]
743      * ====
744      * This function should only be called from the constructor when setting
745      * up the initial roles for the system.
746      *
747      * Using this function in any other way is effectively circumventing the admin
748      * system imposed by {AccessControl}.
749      * ====
750      */
751     function _setupRole(bytes32 role, address account) internal virtual {
752         _grantRole(role, account);
753     }
754 
755     /**
756      * @dev Sets `adminRole` as ``role``'s admin role.
757      *
758      * Emits a {RoleAdminChanged} event.
759      */
760     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
761         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
762         _roles[role].adminRole = adminRole;
763     }
764 
765     function _grantRole(bytes32 role, address account) private {
766         if (_roles[role].members.add(account)) {
767             emit RoleGranted(role, account, _msgSender());
768         }
769     }
770 
771     function _revokeRole(bytes32 role, address account) private {
772         if (_roles[role].members.remove(account)) {
773             emit RoleRevoked(role, account, _msgSender());
774         }
775     }
776 }
777 
778 
779 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0
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
857 
858 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
859 
860 pragma solidity >=0.6.0 <0.8.0;
861 
862 /**
863  * @dev Wrappers over Solidity's arithmetic operations with added overflow
864  * checks.
865  *
866  * Arithmetic operations in Solidity wrap on overflow. This can easily result
867  * in bugs, because programmers usually assume that an overflow raises an
868  * error, which is the standard behavior in high level programming languages.
869  * `SafeMath` restores this intuition by reverting the transaction when an
870  * operation overflows.
871  *
872  * Using this library instead of the unchecked operations eliminates an entire
873  * class of bugs, so it's recommended to use it always.
874  */
875 library SafeMath {
876     /**
877      * @dev Returns the addition of two unsigned integers, reverting on
878      * overflow.
879      *
880      * Counterpart to Solidity's `+` operator.
881      *
882      * Requirements:
883      *
884      * - Addition cannot overflow.
885      */
886     function add(uint256 a, uint256 b) internal pure returns (uint256) {
887         uint256 c = a + b;
888         require(c >= a, "SafeMath: addition overflow");
889 
890         return c;
891     }
892 
893     /**
894      * @dev Returns the subtraction of two unsigned integers, reverting on
895      * overflow (when the result is negative).
896      *
897      * Counterpart to Solidity's `-` operator.
898      *
899      * Requirements:
900      *
901      * - Subtraction cannot overflow.
902      */
903     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
904         return sub(a, b, "SafeMath: subtraction overflow");
905     }
906 
907     /**
908      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
909      * overflow (when the result is negative).
910      *
911      * Counterpart to Solidity's `-` operator.
912      *
913      * Requirements:
914      *
915      * - Subtraction cannot overflow.
916      */
917     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
918         require(b <= a, errorMessage);
919         uint256 c = a - b;
920 
921         return c;
922     }
923 
924     /**
925      * @dev Returns the multiplication of two unsigned integers, reverting on
926      * overflow.
927      *
928      * Counterpart to Solidity's `*` operator.
929      *
930      * Requirements:
931      *
932      * - Multiplication cannot overflow.
933      */
934     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
935         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
936         // benefit is lost if 'b' is also tested.
937         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
938         if (a == 0) {
939             return 0;
940         }
941 
942         uint256 c = a * b;
943         require(c / a == b, "SafeMath: multiplication overflow");
944 
945         return c;
946     }
947 
948     /**
949      * @dev Returns the integer division of two unsigned integers. Reverts on
950      * division by zero. The result is rounded towards zero.
951      *
952      * Counterpart to Solidity's `/` operator. Note: this function uses a
953      * `revert` opcode (which leaves remaining gas untouched) while Solidity
954      * uses an invalid opcode to revert (consuming all remaining gas).
955      *
956      * Requirements:
957      *
958      * - The divisor cannot be zero.
959      */
960     function div(uint256 a, uint256 b) internal pure returns (uint256) {
961         return div(a, b, "SafeMath: division by zero");
962     }
963 
964     /**
965      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
966      * division by zero. The result is rounded towards zero.
967      *
968      * Counterpart to Solidity's `/` operator. Note: this function uses a
969      * `revert` opcode (which leaves remaining gas untouched) while Solidity
970      * uses an invalid opcode to revert (consuming all remaining gas).
971      *
972      * Requirements:
973      *
974      * - The divisor cannot be zero.
975      */
976     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
977         require(b > 0, errorMessage);
978         uint256 c = a / b;
979         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
980 
981         return c;
982     }
983 
984     /**
985      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
986      * Reverts when dividing by zero.
987      *
988      * Counterpart to Solidity's `%` operator. This function uses a `revert`
989      * opcode (which leaves remaining gas untouched) while Solidity uses an
990      * invalid opcode to revert (consuming all remaining gas).
991      *
992      * Requirements:
993      *
994      * - The divisor cannot be zero.
995      */
996     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
997         return mod(a, b, "SafeMath: modulo by zero");
998     }
999 
1000     /**
1001      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1002      * Reverts with custom message when dividing by zero.
1003      *
1004      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1005      * opcode (which leaves remaining gas untouched) while Solidity uses an
1006      * invalid opcode to revert (consuming all remaining gas).
1007      *
1008      * Requirements:
1009      *
1010      * - The divisor cannot be zero.
1011      */
1012     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1013         require(b != 0, errorMessage);
1014         return a % b;
1015     }
1016 }
1017 
1018 
1019 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.3.0
1020 
1021 
1022 pragma solidity >=0.6.0 <0.8.0;
1023 
1024 
1025 
1026 /**
1027  * @dev Implementation of the {IERC20} interface.
1028  *
1029  * This implementation is agnostic to the way tokens are created. This means
1030  * that a supply mechanism has to be added in a derived contract using {_mint}.
1031  * For a generic mechanism see {ERC20PresetMinterPauser}.
1032  *
1033  * TIP: For a detailed writeup see our guide
1034  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1035  * to implement supply mechanisms].
1036  *
1037  * We have followed general OpenZeppelin guidelines: functions revert instead
1038  * of returning `false` on failure. This behavior is nonetheless conventional
1039  * and does not conflict with the expectations of ERC20 applications.
1040  *
1041  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1042  * This allows applications to reconstruct the allowance for all accounts just
1043  * by listening to said events. Other implementations of the EIP may not emit
1044  * these events, as it isn't required by the specification.
1045  *
1046  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1047  * functions have been added to mitigate the well-known issues around setting
1048  * allowances. See {IERC20-approve}.
1049  */
1050 contract ERC20 is Context, IERC20 {
1051     using SafeMath for uint256;
1052 
1053     mapping (address => uint256) private _balances;
1054 
1055     mapping (address => mapping (address => uint256)) private _allowances;
1056 
1057     uint256 private _totalSupply;
1058 
1059     string private _name;
1060     string private _symbol;
1061     uint8 private _decimals;
1062 
1063     /**
1064      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1065      * a default value of 18.
1066      *
1067      * To select a different value for {decimals}, use {_setupDecimals}.
1068      *
1069      * All three of these values are immutable: they can only be set once during
1070      * construction.
1071      */
1072     constructor (string memory name_, string memory symbol_) public {
1073         _name = name_;
1074         _symbol = symbol_;
1075         _decimals = 18;
1076     }
1077 
1078     /**
1079      * @dev Returns the name of the token.
1080      */
1081     function name() public view returns (string memory) {
1082         return _name;
1083     }
1084 
1085     /**
1086      * @dev Returns the symbol of the token, usually a shorter version of the
1087      * name.
1088      */
1089     function symbol() public view returns (string memory) {
1090         return _symbol;
1091     }
1092 
1093     /**
1094      * @dev Returns the number of decimals used to get its user representation.
1095      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1096      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1097      *
1098      * Tokens usually opt for a value of 18, imitating the relationship between
1099      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1100      * called.
1101      *
1102      * NOTE: This information is only used for _display_ purposes: it in
1103      * no way affects any of the arithmetic of the contract, including
1104      * {IERC20-balanceOf} and {IERC20-transfer}.
1105      */
1106     function decimals() public view returns (uint8) {
1107         return _decimals;
1108     }
1109 
1110     /**
1111      * @dev See {IERC20-totalSupply}.
1112      */
1113     function totalSupply() public view override returns (uint256) {
1114         return _totalSupply;
1115     }
1116 
1117     /**
1118      * @dev See {IERC20-balanceOf}.
1119      */
1120     function balanceOf(address account) public view override returns (uint256) {
1121         return _balances[account];
1122     }
1123 
1124     /**
1125      * @dev See {IERC20-transfer}.
1126      *
1127      * Requirements:
1128      *
1129      * - `recipient` cannot be the zero address.
1130      * - the caller must have a balance of at least `amount`.
1131      */
1132     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1133         _transfer(_msgSender(), recipient, amount);
1134         return true;
1135     }
1136 
1137     /**
1138      * @dev See {IERC20-allowance}.
1139      */
1140     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1141         return _allowances[owner][spender];
1142     }
1143 
1144     /**
1145      * @dev See {IERC20-approve}.
1146      *
1147      * Requirements:
1148      *
1149      * - `spender` cannot be the zero address.
1150      */
1151     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1152         _approve(_msgSender(), spender, amount);
1153         return true;
1154     }
1155 
1156     /**
1157      * @dev See {IERC20-transferFrom}.
1158      *
1159      * Emits an {Approval} event indicating the updated allowance. This is not
1160      * required by the EIP. See the note at the beginning of {ERC20}.
1161      *
1162      * Requirements:
1163      *
1164      * - `sender` and `recipient` cannot be the zero address.
1165      * - `sender` must have a balance of at least `amount`.
1166      * - the caller must have allowance for ``sender``'s tokens of at least
1167      * `amount`.
1168      */
1169     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1170         _transfer(sender, recipient, amount);
1171         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1172         return true;
1173     }
1174 
1175     /**
1176      * @dev Atomically increases the allowance granted to `spender` by the caller.
1177      *
1178      * This is an alternative to {approve} that can be used as a mitigation for
1179      * problems described in {IERC20-approve}.
1180      *
1181      * Emits an {Approval} event indicating the updated allowance.
1182      *
1183      * Requirements:
1184      *
1185      * - `spender` cannot be the zero address.
1186      */
1187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1189         return true;
1190     }
1191 
1192     /**
1193      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1194      *
1195      * This is an alternative to {approve} that can be used as a mitigation for
1196      * problems described in {IERC20-approve}.
1197      *
1198      * Emits an {Approval} event indicating the updated allowance.
1199      *
1200      * Requirements:
1201      *
1202      * - `spender` cannot be the zero address.
1203      * - `spender` must have allowance for the caller of at least
1204      * `subtractedValue`.
1205      */
1206     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1207         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1208         return true;
1209     }
1210 
1211     /**
1212      * @dev Moves tokens `amount` from `sender` to `recipient`.
1213      *
1214      * This is internal function is equivalent to {transfer}, and can be used to
1215      * e.g. implement automatic token fees, slashing mechanisms, etc.
1216      *
1217      * Emits a {Transfer} event.
1218      *
1219      * Requirements:
1220      *
1221      * - `sender` cannot be the zero address.
1222      * - `recipient` cannot be the zero address.
1223      * - `sender` must have a balance of at least `amount`.
1224      */
1225     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1226         require(sender != address(0), "ERC20: transfer from the zero address");
1227         require(recipient != address(0), "ERC20: transfer to the zero address");
1228 
1229         _beforeTokenTransfer(sender, recipient, amount);
1230 
1231         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1232         _balances[recipient] = _balances[recipient].add(amount);
1233         emit Transfer(sender, recipient, amount);
1234     }
1235 
1236     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1237      * the total supply.
1238      *
1239      * Emits a {Transfer} event with `from` set to the zero address.
1240      *
1241      * Requirements:
1242      *
1243      * - `to` cannot be the zero address.
1244      */
1245     function _mint(address account, uint256 amount) internal virtual {
1246         require(account != address(0), "ERC20: mint to the zero address");
1247 
1248         _beforeTokenTransfer(address(0), account, amount);
1249 
1250         _totalSupply = _totalSupply.add(amount);
1251         _balances[account] = _balances[account].add(amount);
1252         emit Transfer(address(0), account, amount);
1253     }
1254 
1255     /**
1256      * @dev Destroys `amount` tokens from `account`, reducing the
1257      * total supply.
1258      *
1259      * Emits a {Transfer} event with `to` set to the zero address.
1260      *
1261      * Requirements:
1262      *
1263      * - `account` cannot be the zero address.
1264      * - `account` must have at least `amount` tokens.
1265      */
1266     function _burn(address account, uint256 amount) internal virtual {
1267         require(account != address(0), "ERC20: burn from the zero address");
1268 
1269         _beforeTokenTransfer(account, address(0), amount);
1270 
1271         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1272         _totalSupply = _totalSupply.sub(amount);
1273         emit Transfer(account, address(0), amount);
1274     }
1275 
1276     /**
1277      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1278      *
1279      * This internal function is equivalent to `approve`, and can be used to
1280      * e.g. set automatic allowances for certain subsystems, etc.
1281      *
1282      * Emits an {Approval} event.
1283      *
1284      * Requirements:
1285      *
1286      * - `owner` cannot be the zero address.
1287      * - `spender` cannot be the zero address.
1288      */
1289     function _approve(address owner, address spender, uint256 amount) internal virtual {
1290         require(owner != address(0), "ERC20: approve from the zero address");
1291         require(spender != address(0), "ERC20: approve to the zero address");
1292 
1293         _allowances[owner][spender] = amount;
1294         emit Approval(owner, spender, amount);
1295     }
1296 
1297     /**
1298      * @dev Sets {decimals} to a value other than the default one of 18.
1299      *
1300      * WARNING: This function should only be called from the constructor. Most
1301      * applications that interact with token contracts will not expect
1302      * {decimals} to ever change, and may work incorrectly if it does.
1303      */
1304     function _setupDecimals(uint8 decimals_) internal {
1305         _decimals = decimals_;
1306     }
1307 
1308     /**
1309      * @dev Hook that is called before any transfer of tokens. This includes
1310      * minting and burning.
1311      *
1312      * Calling conditions:
1313      *
1314      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1315      * will be to transferred to `to`.
1316      * - when `from` is zero, `amount` tokens will be minted for `to`.
1317      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1318      * - `from` and `to` are never both zero.
1319      *
1320      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1321      */
1322     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1323 }
1324 
1325 
1326 // File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.3.0
1327 
1328 
1329 pragma solidity >=0.6.0 <0.8.0;
1330 
1331 
1332 /**
1333  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1334  * tokens and those that they have an allowance for, in a way that can be
1335  * recognized off-chain (via event analysis).
1336  */
1337 abstract contract ERC20Burnable is Context, ERC20 {
1338     using SafeMath for uint256;
1339 
1340     /**
1341      * @dev Destroys `amount` tokens from the caller.
1342      *
1343      * See {ERC20-_burn}.
1344      */
1345     function burn(uint256 amount) public virtual {
1346         _burn(_msgSender(), amount);
1347     }
1348 
1349     /**
1350      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1351      * allowance.
1352      *
1353      * See {ERC20-_burn} and {ERC20-allowance}.
1354      *
1355      * Requirements:
1356      *
1357      * - the caller must have allowance for ``accounts``'s tokens of at least
1358      * `amount`.
1359      */
1360     function burnFrom(address account, uint256 amount) public virtual {
1361         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1362 
1363         _approve(account, _msgSender(), decreasedAllowance);
1364         _burn(account, amount);
1365     }
1366 }
1367 
1368 
1369 // File @openzeppelin/contracts/utils/Pausable.sol@v3.3.0
1370 
1371 
1372 pragma solidity >=0.6.0 <0.8.0;
1373 
1374 /**
1375  * @dev Contract module which allows children to implement an emergency stop
1376  * mechanism that can be triggered by an authorized account.
1377  *
1378  * This module is used through inheritance. It will make available the
1379  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1380  * the functions of your contract. Note that they will not be pausable by
1381  * simply including this module, only once the modifiers are put in place.
1382  */
1383 abstract contract Pausable is Context {
1384     /**
1385      * @dev Emitted when the pause is triggered by `account`.
1386      */
1387     event Paused(address account);
1388 
1389     /**
1390      * @dev Emitted when the pause is lifted by `account`.
1391      */
1392     event Unpaused(address account);
1393 
1394     bool private _paused;
1395 
1396     /**
1397      * @dev Initializes the contract in unpaused state.
1398      */
1399     constructor () internal {
1400         _paused = false;
1401     }
1402 
1403     /**
1404      * @dev Returns true if the contract is paused, and false otherwise.
1405      */
1406     function paused() public view returns (bool) {
1407         return _paused;
1408     }
1409 
1410     /**
1411      * @dev Modifier to make a function callable only when the contract is not paused.
1412      *
1413      * Requirements:
1414      *
1415      * - The contract must not be paused.
1416      */
1417     modifier whenNotPaused() {
1418         require(!_paused, "Pausable: paused");
1419         _;
1420     }
1421 
1422     /**
1423      * @dev Modifier to make a function callable only when the contract is paused.
1424      *
1425      * Requirements:
1426      *
1427      * - The contract must be paused.
1428      */
1429     modifier whenPaused() {
1430         require(_paused, "Pausable: not paused");
1431         _;
1432     }
1433 
1434     /**
1435      * @dev Triggers stopped state.
1436      *
1437      * Requirements:
1438      *
1439      * - The contract must not be paused.
1440      */
1441     function _pause() internal virtual whenNotPaused {
1442         _paused = true;
1443         emit Paused(_msgSender());
1444     }
1445 
1446     /**
1447      * @dev Returns to normal state.
1448      *
1449      * Requirements:
1450      *
1451      * - The contract must be paused.
1452      */
1453     function _unpause() internal virtual whenPaused {
1454         _paused = false;
1455         emit Unpaused(_msgSender());
1456     }
1457 }
1458 
1459 
1460 // File @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol@v3.3.0
1461 
1462 
1463 pragma solidity >=0.6.0 <0.8.0;
1464 
1465 
1466 /**
1467  * @dev ERC20 token with pausable token transfers, minting and burning.
1468  *
1469  * Useful for scenarios such as preventing trades until the end of an evaluation
1470  * period, or having an emergency switch for freezing all token transfers in the
1471  * event of a large bug.
1472  */
1473 abstract contract ERC20Pausable is ERC20, Pausable {
1474     /**
1475      * @dev See {ERC20-_beforeTokenTransfer}.
1476      *
1477      * Requirements:
1478      *
1479      * - the contract must not be paused.
1480      */
1481     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1482         super._beforeTokenTransfer(from, to, amount);
1483 
1484         require(!paused(), "ERC20Pausable: token transfer while paused");
1485     }
1486 }
1487 
1488 
1489 // File @openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol@v3.3.0
1490 
1491 // SPDX-License-Identifier: MIT
1492 
1493 pragma solidity >=0.6.0 <0.8.0;
1494 
1495 
1496 
1497 
1498 
1499 /**
1500  * @dev {ERC20} token, including:
1501  *
1502  *  - ability for holders to burn (destroy) their tokens
1503  *  - a minter role that allows for token minting (creation)
1504  *  - a pauser role that allows to stop all token transfers
1505  *
1506  * This contract uses {AccessControl} to lock permissioned functions using the
1507  * different roles - head to its documentation for details.
1508  *
1509  * The account that deploys the contract will be granted the minter and pauser
1510  * roles, as well as the default admin role, which will let it grant both minter
1511  * and pauser roles to other accounts.
1512  */
1513 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1514     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1515     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1516 
1517     /**
1518      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1519      * account that deploys the contract.
1520      *
1521      * See {ERC20-constructor}.
1522      */
1523     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1524         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1525 
1526         _setupRole(MINTER_ROLE, _msgSender());
1527         _setupRole(PAUSER_ROLE, _msgSender());
1528     }
1529 
1530     /**
1531      * @dev Creates `amount` new tokens for `to`.
1532      *
1533      * See {ERC20-_mint}.
1534      *
1535      * Requirements:
1536      *
1537      * - the caller must have the `MINTER_ROLE`.
1538      */
1539     function mint(address to, uint256 amount) public virtual {
1540         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1541         _mint(to, amount);
1542     }
1543 
1544     /**
1545      * @dev Pauses all token transfers.
1546      *
1547      * See {ERC20Pausable} and {Pausable-_pause}.
1548      *
1549      * Requirements:
1550      *
1551      * - the caller must have the `PAUSER_ROLE`.
1552      */
1553     function pause() public virtual {
1554         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1555         _pause();
1556     }
1557 
1558     /**
1559      * @dev Unpauses all token transfers.
1560      *
1561      * See {ERC20Pausable} and {Pausable-_unpause}.
1562      *
1563      * Requirements:
1564      *
1565      * - the caller must have the `PAUSER_ROLE`.
1566      */
1567     function unpause() public virtual {
1568         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1569         _unpause();
1570     }
1571 
1572     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1573         super._beforeTokenTransfer(from, to, amount);
1574     }
1575 }
1576 
1577 pragma solidity >=0.6.0 <0.8.0;
1578 
1579 contract CultureToken is ERC20PresetMinterPauser, Ownable {    
1580     // _amount = 10000000000000000000000000 (mints 10M tokens)
1581     // _vestingBeneficiary = 0x0eebF2126B67924A2785687aaF64aBFA4B2EA76f
1582 
1583 
1584     uint256 CreatorAmount = 9925000000000000000000000;
1585     uint256 OwnershipAmount = 75000000000000000000000;
1586 
1587     constructor(
1588         address _vestingBeneficiary,
1589         address _cOwnership
1590     ) ERC20PresetMinterPauser('The Culture DAO', 'CULTUR') {
1591         _mint(_vestingBeneficiary, CreatorAmount);
1592         _mint(_cOwnership, OwnershipAmount);
1593     }
1594 }