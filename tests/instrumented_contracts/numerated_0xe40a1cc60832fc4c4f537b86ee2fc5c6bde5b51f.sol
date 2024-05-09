1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File contracts/OpenZeppelin/utils/ReentrancyGuard.sol
4 
5 pragma solidity 0.6.12;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor () internal {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and make it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 
67 // File contracts/OpenZeppelin/utils/EnumerableSet.sol
68 
69 pragma solidity 0.6.12;
70 
71 /**
72  * @dev Library for managing
73  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
74  * types.
75  *
76  * Sets have the following properties:
77  *
78  * - Elements are added, removed, and checked for existence in constant time
79  * (O(1)).
80  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
81  *
82  * ```
83  * contract Example {
84  *     // Add the library methods
85  *     using EnumerableSet for EnumerableSet.AddressSet;
86  *
87  *     // Declare a set state variable
88  *     EnumerableSet.AddressSet private mySet;
89  * }
90  * ```
91  *
92  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
93  * and `uint256` (`UintSet`) are supported.
94  */
95 library EnumerableSet {
96     // To implement this library for multiple types with as little code
97     // repetition as possible, we write it in terms of a generic Set type with
98     // bytes32 values.
99     // The Set implementation uses private functions, and user-facing
100     // implementations (such as AddressSet) are just wrappers around the
101     // underlying Set.
102     // This means that we can only create new EnumerableSets for types that fit
103     // in bytes32.
104 
105     struct Set {
106         // Storage of set values
107         bytes32[] _values;
108 
109         // Position of the value in the `values` array, plus 1 because index 0
110         // means a value is not in the set.
111         mapping (bytes32 => uint256) _indexes;
112     }
113 
114     /**
115      * @dev Add a value to a set. O(1).
116      *
117      * Returns true if the value was added to the set, that is if it was not
118      * already present.
119      */
120     function _add(Set storage set, bytes32 value) private returns (bool) {
121         if (!_contains(set, value)) {
122             set._values.push(value);
123             // The value is stored at length-1, but we add 1 to all indexes
124             // and use 0 as a sentinel value
125             set._indexes[value] = set._values.length;
126             return true;
127         } else {
128             return false;
129         }
130     }
131 
132     /**
133      * @dev Removes a value from a set. O(1).
134      *
135      * Returns true if the value was removed from the set, that is if it was
136      * present.
137      */
138     function _remove(Set storage set, bytes32 value) private returns (bool) {
139         // We read and store the value's index to prevent multiple reads from the same storage slot
140         uint256 valueIndex = set._indexes[value];
141 
142         if (valueIndex != 0) { // Equivalent to contains(set, value)
143             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
144             // the array, and then remove the last element (sometimes called as 'swap and pop').
145             // This modifies the order of the array, as noted in {at}.
146 
147             uint256 toDeleteIndex = valueIndex - 1;
148             uint256 lastIndex = set._values.length - 1;
149 
150             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
151             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
152 
153             bytes32 lastvalue = set._values[lastIndex];
154 
155             // Move the last value to the index where the value to delete is
156             set._values[toDeleteIndex] = lastvalue;
157             // Update the index for the moved value
158             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
159 
160             // Delete the slot where the moved value was stored
161             set._values.pop();
162 
163             // Delete the index for the deleted slot
164             delete set._indexes[value];
165 
166             return true;
167         } else {
168             return false;
169         }
170     }
171 
172     /**
173      * @dev Returns true if the value is in the set. O(1).
174      */
175     function _contains(Set storage set, bytes32 value) private view returns (bool) {
176         return set._indexes[value] != 0;
177     }
178 
179     /**
180      * @dev Returns the number of values on the set. O(1).
181      */
182     function _length(Set storage set) private view returns (uint256) {
183         return set._values.length;
184     }
185 
186    /**
187     * @dev Returns the value stored at position `index` in the set. O(1).
188     *
189     * Note that there are no guarantees on the ordering of values inside the
190     * array, and it may change when more values are added or removed.
191     *
192     * Requirements:
193     *
194     * - `index` must be strictly less than {length}.
195     */
196     function _at(Set storage set, uint256 index) private view returns (bytes32) {
197         require(set._values.length > index, "EnumerableSet: index out of bounds");
198         return set._values[index];
199     }
200 
201     // Bytes32Set
202 
203     struct Bytes32Set {
204         Set _inner;
205     }
206 
207     /**
208      * @dev Add a value to a set. O(1).
209      *
210      * Returns true if the value was added to the set, that is if it was not
211      * already present.
212      */
213     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
214         return _add(set._inner, value);
215     }
216 
217     /**
218      * @dev Removes a value from a set. O(1).
219      *
220      * Returns true if the value was removed from the set, that is if it was
221      * present.
222      */
223     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
224         return _remove(set._inner, value);
225     }
226 
227     /**
228      * @dev Returns true if the value is in the set. O(1).
229      */
230     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
231         return _contains(set._inner, value);
232     }
233 
234     /**
235      * @dev Returns the number of values in the set. O(1).
236      */
237     function length(Bytes32Set storage set) internal view returns (uint256) {
238         return _length(set._inner);
239     }
240 
241    /**
242     * @dev Returns the value stored at position `index` in the set. O(1).
243     *
244     * Note that there are no guarantees on the ordering of values inside the
245     * array, and it may change when more values are added or removed.
246     *
247     * Requirements:
248     *
249     * - `index` must be strictly less than {length}.
250     */
251     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
252         return _at(set._inner, index);
253     }
254 
255     // AddressSet
256 
257     struct AddressSet {
258         Set _inner;
259     }
260 
261     /**
262      * @dev Add a value to a set. O(1).
263      *
264      * Returns true if the value was added to the set, that is if it was not
265      * already present.
266      */
267     function add(AddressSet storage set, address value) internal returns (bool) {
268         return _add(set._inner, bytes32(uint256(uint160(value))));
269     }
270 
271     /**
272      * @dev Removes a value from a set. O(1).
273      *
274      * Returns true if the value was removed from the set, that is if it was
275      * present.
276      */
277     function remove(AddressSet storage set, address value) internal returns (bool) {
278         return _remove(set._inner, bytes32(uint256(uint160(value))));
279     }
280 
281     /**
282      * @dev Returns true if the value is in the set. O(1).
283      */
284     function contains(AddressSet storage set, address value) internal view returns (bool) {
285         return _contains(set._inner, bytes32(uint256(uint160(value))));
286     }
287 
288     /**
289      * @dev Returns the number of values in the set. O(1).
290      */
291     function length(AddressSet storage set) internal view returns (uint256) {
292         return _length(set._inner);
293     }
294 
295    /**
296     * @dev Returns the value stored at position `index` in the set. O(1).
297     *
298     * Note that there are no guarantees on the ordering of values inside the
299     * array, and it may change when more values are added or removed.
300     *
301     * Requirements:
302     *
303     * - `index` must be strictly less than {length}.
304     */
305     function at(AddressSet storage set, uint256 index) internal view returns (address) {
306         return address(uint160(uint256(_at(set._inner, index))));
307     }
308 
309 
310     // UintSet
311 
312     struct UintSet {
313         Set _inner;
314     }
315 
316     /**
317      * @dev Add a value to a set. O(1).
318      *
319      * Returns true if the value was added to the set, that is if it was not
320      * already present.
321      */
322     function add(UintSet storage set, uint256 value) internal returns (bool) {
323         return _add(set._inner, bytes32(value));
324     }
325 
326     /**
327      * @dev Removes a value from a set. O(1).
328      *
329      * Returns true if the value was removed from the set, that is if it was
330      * present.
331      */
332     function remove(UintSet storage set, uint256 value) internal returns (bool) {
333         return _remove(set._inner, bytes32(value));
334     }
335 
336     /**
337      * @dev Returns true if the value is in the set. O(1).
338      */
339     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
340         return _contains(set._inner, bytes32(value));
341     }
342 
343     /**
344      * @dev Returns the number of values on the set. O(1).
345      */
346     function length(UintSet storage set) internal view returns (uint256) {
347         return _length(set._inner);
348     }
349 
350    /**
351     * @dev Returns the value stored at position `index` in the set. O(1).
352     *
353     * Note that there are no guarantees on the ordering of values inside the
354     * array, and it may change when more values are added or removed.
355     *
356     * Requirements:
357     *
358     * - `index` must be strictly less than {length}.
359     */
360     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
361         return uint256(_at(set._inner, index));
362     }
363 }
364 
365 
366 // File contracts/OpenZeppelin/utils/Address.sol
367 
368 pragma solidity 0.6.12;
369 
370 /**
371  * @dev Collection of functions related to the address type
372  */
373 library Address {
374     /**
375      * @dev Returns true if `account` is a contract.
376      *
377      * [IMPORTANT]
378      * ====
379      * It is unsafe to assume that an address for which this function returns
380      * false is an externally-owned account (EOA) and not a contract.
381      *
382      * Among others, `isContract` will return false for the following
383      * types of addresses:
384      *
385      *  - an externally-owned account
386      *  - a contract in construction
387      *  - an address where a contract will be created
388      *  - an address where a contract lived, but was destroyed
389      * ====
390      */
391     function isContract(address account) internal view returns (bool) {
392         // This method relies on extcodesize, which returns 0 for contracts in
393         // construction, since the code is only stored at the end of the
394         // constructor execution.
395 
396         uint256 size;
397         // solhint-disable-next-line no-inline-assembly
398         assembly { size := extcodesize(account) }
399         return size > 0;
400     }
401 
402     /**
403      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
404      * `recipient`, forwarding all available gas and reverting on errors.
405      *
406      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
407      * of certain opcodes, possibly making contracts go over the 2300 gas limit
408      * imposed by `transfer`, making them unable to receive funds via
409      * `transfer`. {sendValue} removes this limitation.
410      *
411      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
412      *
413      * IMPORTANT: because control is transferred to `recipient`, care must be
414      * taken to not create reentrancy vulnerabilities. Consider using
415      * {ReentrancyGuard} or the
416      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
417      */
418     function sendValue(address payable recipient, uint256 amount) internal {
419         require(address(this).balance >= amount, "Address: insufficient balance");
420 
421         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
422         (bool success, ) = recipient.call{ value: amount }("");
423         require(success, "Address: unable to send value, recipient may have reverted");
424     }
425 
426     /**
427      * @dev Performs a Solidity function call using a low level `call`. A
428      * plain`call` is an unsafe replacement for a function call: use this
429      * function instead.
430      *
431      * If `target` reverts with a revert reason, it is bubbled up by this
432      * function (like regular Solidity function calls).
433      *
434      * Returns the raw returned data. To convert to the expected return value,
435      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
436      *
437      * Requirements:
438      *
439      * - `target` must be a contract.
440      * - calling `target` with `data` must not revert.
441      *
442      * _Available since v3.1._
443      */
444     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
445       return functionCall(target, data, "Address: low-level call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
450      * `errorMessage` as a fallback revert reason when `target` reverts.
451      *
452      * _Available since v3.1._
453      */
454     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
455         return functionCallWithValue(target, data, 0, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but also transferring `value` wei to `target`.
461      *
462      * Requirements:
463      *
464      * - the calling contract must have an ETH balance of at least `value`.
465      * - the called Solidity function must be `payable`.
466      *
467      * _Available since v3.1._
468      */
469     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
470         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
475      * with `errorMessage` as a fallback revert reason when `target` reverts.
476      *
477      * _Available since v3.1._
478      */
479     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
480         require(address(this).balance >= value, "Address: insufficient balance for call");
481         require(isContract(target), "Address: call to non-contract");
482 
483         // solhint-disable-next-line avoid-low-level-calls
484         (bool success, bytes memory returndata) = target.call{ value: value }(data);
485         return _verifyCallResult(success, returndata, errorMessage);
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
490      * but performing a static call.
491      *
492      * _Available since v3.3._
493      */
494     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
495         return functionStaticCall(target, data, "Address: low-level static call failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
500      * but performing a static call.
501      *
502      * _Available since v3.3._
503      */
504     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
505         require(isContract(target), "Address: static call to non-contract");
506 
507         // solhint-disable-next-line avoid-low-level-calls
508         (bool success, bytes memory returndata) = target.staticcall(data);
509         return _verifyCallResult(success, returndata, errorMessage);
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
519         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
524      * but performing a delegate call.
525      *
526      * _Available since v3.4._
527      */
528     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
529         require(isContract(target), "Address: delegate call to non-contract");
530 
531         // solhint-disable-next-line avoid-low-level-calls
532         (bool success, bytes memory returndata) = target.delegatecall(data);
533         return _verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
537         if (success) {
538             return returndata;
539         } else {
540             // Look for revert reason and bubble it up if present
541             if (returndata.length > 0) {
542                 // The easiest way to bubble the revert reason is using memory via assembly
543 
544                 // solhint-disable-next-line no-inline-assembly
545                 assembly {
546                     let returndata_size := mload(returndata)
547                     revert(add(32, returndata), returndata_size)
548                 }
549             } else {
550                 revert(errorMessage);
551             }
552         }
553     }
554 }
555 
556 
557 // File contracts/OpenZeppelin/utils/Context.sol
558 
559 pragma solidity 0.6.12;
560 
561 /*
562  * @dev Provides information about the current execution context, including the
563  * sender of the transaction and its data. While these are generally available
564  * via msg.sender and msg.data, they should not be accessed in such a direct
565  * manner, since when dealing with GSN meta-transactions the account sending and
566  * paying for execution may not be the actual sender (as far as an application
567  * is concerned).
568  *
569  * This contract is only required for intermediate, library-like contracts.
570  */
571 abstract contract Context {
572     function _msgSender() internal view virtual returns (address payable) {
573         return msg.sender;
574     }
575 
576     function _msgData() internal view virtual returns (bytes memory) {
577         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
578         return msg.data;
579     }
580 }
581 
582 
583 // File contracts/OpenZeppelin/access/AccessControl.sol
584 
585 pragma solidity 0.6.12;
586 
587 
588 
589 /**
590  * @dev Contract module that allows children to implement role-based access
591  * control mechanisms.
592  *
593  * Roles are referred to by their `bytes32` identifier. These should be exposed
594  * in the external API and be unique. The best way to achieve this is by
595  * using `public constant` hash digests:
596  *
597  * ```
598  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
599  * ```
600  *
601  * Roles can be used to represent a set of permissions. To restrict access to a
602  * function call, use {hasRole}:
603  *
604  * ```
605  * function foo() public {
606  *     require(hasRole(MY_ROLE, msg.sender));
607  *     ...
608  * }
609  * ```
610  *
611  * Roles can be granted and revoked dynamically via the {grantRole} and
612  * {revokeRole} functions. Each role has an associated admin role, and only
613  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
614  *
615  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
616  * that only accounts with this role will be able to grant or revoke other
617  * roles. More complex role relationships can be created by using
618  * {_setRoleAdmin}.
619  *
620  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
621  * grant and revoke this role. Extra precautions should be taken to secure
622  * accounts that have been granted it.
623  */
624 abstract contract AccessControl is Context {
625     using EnumerableSet for EnumerableSet.AddressSet;
626     using Address for address;
627 
628     struct RoleData {
629         EnumerableSet.AddressSet members;
630         bytes32 adminRole;
631     }
632 
633     mapping (bytes32 => RoleData) private _roles;
634 
635     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
636 
637     /**
638      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
639      *
640      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
641      * {RoleAdminChanged} not being emitted signaling this.
642      *
643      * _Available since v3.1._
644      */
645     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
646 
647     /**
648      * @dev Emitted when `account` is granted `role`.
649      *
650      * `sender` is the account that originated the contract call, an admin role
651      * bearer except when using {_setupRole}.
652      */
653     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
654 
655     /**
656      * @dev Emitted when `account` is revoked `role`.
657      *
658      * `sender` is the account that originated the contract call:
659      *   - if using `revokeRole`, it is the admin role bearer
660      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
661      */
662     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
663 
664     /**
665      * @dev Returns `true` if `account` has been granted `role`.
666      */
667     function hasRole(bytes32 role, address account) public view returns (bool) {
668         return _roles[role].members.contains(account);
669     }
670 
671     /**
672      * @dev Returns the number of accounts that have `role`. Can be used
673      * together with {getRoleMember} to enumerate all bearers of a role.
674      */
675     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
676         return _roles[role].members.length();
677     }
678 
679     /**
680      * @dev Returns one of the accounts that have `role`. `index` must be a
681      * value between 0 and {getRoleMemberCount}, non-inclusive.
682      *
683      * Role bearers are not sorted in any particular way, and their ordering may
684      * change at any point.
685      *
686      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
687      * you perform all queries on the same block. See the following
688      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
689      * for more information.
690      */
691     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
692         return _roles[role].members.at(index);
693     }
694 
695     /**
696      * @dev Returns the admin role that controls `role`. See {grantRole} and
697      * {revokeRole}.
698      *
699      * To change a role's admin, use {_setRoleAdmin}.
700      */
701     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
702         return _roles[role].adminRole;
703     }
704 
705     /**
706      * @dev Grants `role` to `account`.
707      *
708      * If `account` had not been already granted `role`, emits a {RoleGranted}
709      * event.
710      *
711      * Requirements:
712      *
713      * - the caller must have ``role``'s admin role.
714      */
715     function grantRole(bytes32 role, address account) public virtual {
716         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
717 
718         _grantRole(role, account);
719     }
720 
721     /**
722      * @dev Revokes `role` from `account`.
723      *
724      * If `account` had been granted `role`, emits a {RoleRevoked} event.
725      *
726      * Requirements:
727      *
728      * - the caller must have ``role``'s admin role.
729      */
730     function revokeRole(bytes32 role, address account) public virtual {
731         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
732 
733         _revokeRole(role, account);
734     }
735 
736     /**
737      * @dev Revokes `role` from the calling account.
738      *
739      * Roles are often managed via {grantRole} and {revokeRole}: this function's
740      * purpose is to provide a mechanism for accounts to lose their privileges
741      * if they are compromised (such as when a trusted device is misplaced).
742      *
743      * If the calling account had been granted `role`, emits a {RoleRevoked}
744      * event.
745      *
746      * Requirements:
747      *
748      * - the caller must be `account`.
749      */
750     function renounceRole(bytes32 role, address account) public virtual {
751         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
752 
753         _revokeRole(role, account);
754     }
755 
756     /**
757      * @dev Grants `role` to `account`.
758      *
759      * If `account` had not been already granted `role`, emits a {RoleGranted}
760      * event. Note that unlike {grantRole}, this function doesn't perform any
761      * checks on the calling account.
762      *
763      * [WARNING]
764      * ====
765      * This function should only be called from the constructor when setting
766      * up the initial roles for the system.
767      *
768      * Using this function in any other way is effectively circumventing the admin
769      * system imposed by {AccessControl}.
770      * ====
771      */
772     function _setupRole(bytes32 role, address account) internal virtual {
773         _grantRole(role, account);
774     }
775 
776     /**
777      * @dev Sets `adminRole` as ``role``'s admin role.
778      *
779      * Emits a {RoleAdminChanged} event.
780      */
781     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
782         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
783         _roles[role].adminRole = adminRole;
784     }
785 
786     function _grantRole(bytes32 role, address account) private {
787         if (_roles[role].members.add(account)) {
788             emit RoleGranted(role, account, _msgSender());
789         }
790     }
791 
792     function _revokeRole(bytes32 role, address account) private {
793         if (_roles[role].members.remove(account)) {
794             emit RoleRevoked(role, account, _msgSender());
795         }
796     }
797 }
798 
799 
800 // File contracts/Access/MISOAdminAccess.sol
801 
802 pragma solidity 0.6.12;
803 
804 contract MISOAdminAccess is AccessControl {
805 
806     /// @dev Whether access is initialised.
807     bool private initAccess;
808 
809     /// @notice Events for adding and removing various roles.
810     event AdminRoleGranted(
811         address indexed beneficiary,
812         address indexed caller
813     );
814 
815     event AdminRoleRemoved(
816         address indexed beneficiary,
817         address indexed caller
818     );
819 
820 
821     /// @notice The deployer is automatically given the admin role which will allow them to then grant roles to other addresses.
822     constructor() public {
823     }
824 
825     /**
826      * @notice Initializes access controls.
827      * @param _admin Admins address.
828      */
829     function initAccessControls(address _admin) public {
830         require(!initAccess, "Already initialised");
831         _setupRole(DEFAULT_ADMIN_ROLE, _admin);
832         initAccess = true;
833     }
834 
835     /////////////
836     // Lookups //
837     /////////////
838 
839     /**
840      * @notice Used to check whether an address has the admin role.
841      * @param _address EOA or contract being checked.
842      * @return bool True if the account has the role or false if it does not.
843      */
844     function hasAdminRole(address _address) public  view returns (bool) {
845         return hasRole(DEFAULT_ADMIN_ROLE, _address);
846     }
847 
848     ///////////////
849     // Modifiers //
850     ///////////////
851 
852     /**
853      * @notice Grants the admin role to an address.
854      * @dev The sender must have the admin role.
855      * @param _address EOA or contract receiving the new role.
856      */
857     function addAdminRole(address _address) external {
858         grantRole(DEFAULT_ADMIN_ROLE, _address);
859         emit AdminRoleGranted(_address, _msgSender());
860     }
861 
862     /**
863      * @notice Removes the admin role from an address.
864      * @dev The sender must have the admin role.
865      * @param _address EOA or contract affected.
866      */
867     function removeAdminRole(address _address) external {
868         revokeRole(DEFAULT_ADMIN_ROLE, _address);
869         emit AdminRoleRemoved(_address, _msgSender());
870     }
871 }
872 
873 
874 // File contracts/Access/MISOAccessControls.sol
875 
876 pragma solidity 0.6.12;
877 
878 /**
879  * @notice Access Controls
880  * @author Attr: BlockRocket.tech
881  */
882 contract MISOAccessControls is MISOAdminAccess {
883     /// @notice Role definitions
884     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
885     bytes32 public constant SMART_CONTRACT_ROLE = keccak256("SMART_CONTRACT_ROLE");
886     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
887 
888     /// @notice Events for adding and removing various roles
889 
890     event MinterRoleGranted(
891         address indexed beneficiary,
892         address indexed caller
893     );
894 
895     event MinterRoleRemoved(
896         address indexed beneficiary,
897         address indexed caller
898     );
899 
900     event OperatorRoleGranted(
901         address indexed beneficiary,
902         address indexed caller
903     );
904 
905     event OperatorRoleRemoved(
906         address indexed beneficiary,
907         address indexed caller
908     );
909 
910     event SmartContractRoleGranted(
911         address indexed beneficiary,
912         address indexed caller
913     );
914 
915     event SmartContractRoleRemoved(
916         address indexed beneficiary,
917         address indexed caller
918     );
919 
920     /**
921      * @notice The deployer is automatically given the admin role which will allow them to then grant roles to other addresses
922      */
923     constructor() public {
924     }
925 
926 
927     /////////////
928     // Lookups //
929     /////////////
930 
931     /**
932      * @notice Used to check whether an address has the minter role
933      * @param _address EOA or contract being checked
934      * @return bool True if the account has the role or false if it does not
935      */
936     function hasMinterRole(address _address) public view returns (bool) {
937         return hasRole(MINTER_ROLE, _address);
938     }
939 
940     /**
941      * @notice Used to check whether an address has the smart contract role
942      * @param _address EOA or contract being checked
943      * @return bool True if the account has the role or false if it does not
944      */
945     function hasSmartContractRole(address _address) public view returns (bool) {
946         return hasRole(SMART_CONTRACT_ROLE, _address);
947     }
948 
949     /**
950      * @notice Used to check whether an address has the operator role
951      * @param _address EOA or contract being checked
952      * @return bool True if the account has the role or false if it does not
953      */
954     function hasOperatorRole(address _address) public view returns (bool) {
955         return hasRole(OPERATOR_ROLE, _address);
956     }
957 
958     ///////////////
959     // Modifiers //
960     ///////////////
961 
962     /**
963      * @notice Grants the minter role to an address
964      * @dev The sender must have the admin role
965      * @param _address EOA or contract receiving the new role
966      */
967     function addMinterRole(address _address) external {
968         grantRole(MINTER_ROLE, _address);
969         emit MinterRoleGranted(_address, _msgSender());
970     }
971 
972     /**
973      * @notice Removes the minter role from an address
974      * @dev The sender must have the admin role
975      * @param _address EOA or contract affected
976      */
977     function removeMinterRole(address _address) external {
978         revokeRole(MINTER_ROLE, _address);
979         emit MinterRoleRemoved(_address, _msgSender());
980     }
981 
982     /**
983      * @notice Grants the smart contract role to an address
984      * @dev The sender must have the admin role
985      * @param _address EOA or contract receiving the new role
986      */
987     function addSmartContractRole(address _address) external {
988         grantRole(SMART_CONTRACT_ROLE, _address);
989         emit SmartContractRoleGranted(_address, _msgSender());
990     }
991 
992     /**
993      * @notice Removes the smart contract role from an address
994      * @dev The sender must have the admin role
995      * @param _address EOA or contract affected
996      */
997     function removeSmartContractRole(address _address) external {
998         revokeRole(SMART_CONTRACT_ROLE, _address);
999         emit SmartContractRoleRemoved(_address, _msgSender());
1000     }
1001 
1002     /**
1003      * @notice Grants the operator role to an address
1004      * @dev The sender must have the admin role
1005      * @param _address EOA or contract receiving the new role
1006      */
1007     function addOperatorRole(address _address) external {
1008         grantRole(OPERATOR_ROLE, _address);
1009         emit OperatorRoleGranted(_address, _msgSender());
1010     }
1011 
1012     /**
1013      * @notice Removes the operator role from an address
1014      * @dev The sender must have the admin role
1015      * @param _address EOA or contract affected
1016      */
1017     function removeOperatorRole(address _address) external {
1018         revokeRole(OPERATOR_ROLE, _address);
1019         emit OperatorRoleRemoved(_address, _msgSender());
1020     }
1021 
1022 }
1023 
1024 
1025 // File contracts/Utils/SafeTransfer.sol
1026 
1027 pragma solidity 0.6.12;
1028 
1029 contract SafeTransfer {
1030 
1031     address private constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1032 
1033     /// @dev Helper function to handle both ETH and ERC20 payments
1034     function _safeTokenPayment(
1035         address _token,
1036         address payable _to,
1037         uint256 _amount
1038     ) internal {
1039         if (address(_token) == ETH_ADDRESS) {
1040             _safeTransferETH(_to,_amount );
1041         } else {
1042             _safeTransfer(_token, _to, _amount);
1043         }
1044     }
1045 
1046 
1047     /// @dev Helper function to handle both ETH and ERC20 payments
1048     function _tokenPayment(
1049         address _token,
1050         address payable _to,
1051         uint256 _amount
1052     ) internal {
1053         if (address(_token) == ETH_ADDRESS) {
1054             _to.transfer(_amount);
1055         } else {
1056             _safeTransfer(_token, _to, _amount);
1057         }
1058     }
1059 
1060 
1061     /// @dev Transfer helper from UniswapV2 Router
1062     function _safeApprove(address token, address to, uint value) internal {
1063         // bytes4(keccak256(bytes('approve(address,uint256)')));
1064         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
1065         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
1066     }
1067 
1068 
1069     /**
1070      * There are many non-compliant ERC20 tokens... this can handle most, adapted from UniSwap V2
1071      * Im trying to make it a habit to put external calls last (reentrancy)
1072      * You can put this in an internal function if you like.
1073      */
1074     function _safeTransfer(
1075         address token,
1076         address to,
1077         uint256 amount
1078     ) internal virtual {
1079         // solium-disable-next-line security/no-low-level-calls
1080         (bool success, bytes memory data) =
1081             token.call(
1082                 // 0xa9059cbb = bytes4(keccak256("transfer(address,uint256)"))
1083                 abi.encodeWithSelector(0xa9059cbb, to, amount)
1084             );
1085         require(success && (data.length == 0 || abi.decode(data, (bool)))); // ERC20 Transfer failed
1086     }
1087 
1088     function _safeTransferFrom(
1089         address token,
1090         address from,
1091         uint256 amount
1092     ) internal virtual {
1093         // solium-disable-next-line security/no-low-level-calls
1094         (bool success, bytes memory data) =
1095             token.call(
1096                 // 0x23b872dd = bytes4(keccak256("transferFrom(address,address,uint256)"))
1097                 abi.encodeWithSelector(0x23b872dd, from, address(this), amount)
1098             );
1099         require(success && (data.length == 0 || abi.decode(data, (bool)))); // ERC20 TransferFrom failed
1100     }
1101 
1102     function _safeTransferFrom(address token, address from, address to, uint value) internal {
1103         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1104         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
1105         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
1106     }
1107 
1108     function _safeTransferETH(address to, uint value) internal {
1109         (bool success,) = to.call{value:value}(new bytes(0));
1110         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
1111     }
1112 
1113 
1114 }
1115 
1116 
1117 // File contracts/interfaces/IERC20.sol
1118 
1119 pragma solidity 0.6.12;
1120 
1121 interface IERC20 {
1122     function totalSupply() external view returns (uint256);
1123     function balanceOf(address account) external view returns (uint256);
1124     function allowance(address owner, address spender) external view returns (uint256);
1125     function approve(address spender, uint256 amount) external returns (bool);
1126     function name() external view returns (string memory);
1127     function symbol() external view returns (string memory);
1128     function decimals() external view returns (uint8);
1129 
1130     event Transfer(address indexed from, address indexed to, uint256 value);
1131     event Approval(address indexed owner, address indexed spender, uint256 value);
1132 
1133     function permit(
1134         address owner,
1135         address spender,
1136         uint256 value,
1137         uint256 deadline,
1138         uint8 v,
1139         bytes32 r,
1140         bytes32 s
1141     ) external;
1142 }
1143 
1144 
1145 // File contracts/Utils/BoringERC20.sol
1146 
1147 pragma solidity 0.6.12;
1148 
1149 // solhint-disable avoid-low-level-calls
1150 
1151 library BoringERC20 {
1152     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
1153     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
1154     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
1155     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
1156     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
1157 
1158     /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.
1159     /// @param token The address of the ERC-20 token contract.
1160     /// @return (string) Token symbol.
1161     function safeSymbol(IERC20 token) internal view returns (string memory) {
1162         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_SYMBOL));
1163         return success && data.length > 0 ? abi.decode(data, (string)) : "???";
1164     }
1165 
1166     /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.
1167     /// @param token The address of the ERC-20 token contract.
1168     /// @return (string) Token name.
1169     function safeName(IERC20 token) internal view returns (string memory) {
1170         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_NAME));
1171         return success && data.length > 0 ? abi.decode(data, (string)) : "???";
1172     }
1173 
1174     /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.
1175     /// @param token The address of the ERC-20 token contract.
1176     /// @return (uint8) Token decimals.
1177     function safeDecimals(IERC20 token) internal view returns (uint8) {
1178         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_DECIMALS));
1179         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
1180     }
1181 
1182     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
1183     /// Reverts on a failed transfer.
1184     /// @param token The address of the ERC-20 token.
1185     /// @param to Transfer tokens to.
1186     /// @param amount The token amount.
1187     function safeTransfer(
1188         IERC20 token,
1189         address to,
1190         uint256 amount
1191     ) internal {
1192         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
1193         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
1194     }
1195 
1196     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
1197     /// Reverts on a failed transfer.
1198     /// @param token The address of the ERC-20 token.
1199     /// @param from Transfer tokens from.
1200     /// @param to Transfer tokens to.
1201     /// @param amount The token amount.
1202     function safeTransferFrom(
1203         IERC20 token,
1204         address from,
1205         address to,
1206         uint256 amount
1207     ) internal {
1208         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
1209         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
1210     }
1211 }
1212 
1213 
1214 // File contracts/Utils/BoringBatchable.sol
1215 
1216 pragma solidity 0.6.12;
1217 
1218 // solhint-disable avoid-low-level-calls
1219 // solhint-disable no-inline-assembly
1220 
1221 // Audit on 5-Jan-2021 by Keno and BoringCrypto
1222 
1223 contract BaseBoringBatchable {
1224     /// @dev Helper function to extract a useful revert message from a failed call.
1225     /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.
1226     function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
1227         // If the _res length is less than 68, then the transaction failed silently (without a revert message)
1228         if (_returnData.length < 68) return "Transaction reverted silently";
1229 
1230         assembly {
1231             // Slice the sighash.
1232             _returnData := add(_returnData, 0x04)
1233         }
1234         return abi.decode(_returnData, (string)); // All that remains is the revert string
1235     }
1236 
1237     /// @notice Allows batched call to self (this contract).
1238     /// @param calls An array of inputs for each call.
1239     /// @param revertOnFail If True then reverts after a failed call and stops doing further calls.
1240     /// @return successes An array indicating the success of a call, mapped one-to-one to `calls`.
1241     /// @return results An array with the returned data of each function call, mapped one-to-one to `calls`.
1242     // F1: External is ok here because this is the batch function, adding it to a batch makes no sense
1243     // F2: Calls in the batch may be payable, delegatecall operates in the same context, so each call in the batch has access to msg.value
1244     // C3: The length of the loop is fully under user control, so can't be exploited
1245     // C7: Delegatecall is only used on the same contract, so it's safe
1246     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results) {
1247         successes = new bool[](calls.length);
1248         results = new bytes[](calls.length);
1249         for (uint256 i = 0; i < calls.length; i++) {
1250             (bool success, bytes memory result) = address(this).delegatecall(calls[i]);
1251             require(success || !revertOnFail, _getRevertMsg(result));
1252             successes[i] = success;
1253             results[i] = result;
1254         }
1255     }
1256 }
1257 
1258 contract BoringBatchable is BaseBoringBatchable {
1259     /// @notice Call wrapper that performs `ERC20.permit` on `token`.
1260     /// Lookup `IERC20.permit`.
1261     // F6: Parameters can be used front-run the permit and the user's permit will fail (due to nonce or other revert)
1262     //     if part of a batch this could be used to grief once as the second call would not need the permit
1263     function permitToken(
1264         IERC20 token,
1265         address from,
1266         address to,
1267         uint256 amount,
1268         uint256 deadline,
1269         uint8 v,
1270         bytes32 r,
1271         bytes32 s
1272     ) public {
1273         token.permit(from, to, amount, deadline, v, r, s);
1274     }
1275 }
1276 
1277 
1278 // File contracts/Utils/BoringMath.sol
1279 
1280 pragma solidity 0.6.12;
1281 
1282 /// @notice A library for performing overflow-/underflow-safe math,
1283 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
1284 library BoringMath {
1285     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1286         require((c = a + b) >= b, "BoringMath: Add Overflow");
1287     }
1288 
1289     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
1290         require((c = a - b) <= a, "BoringMath: Underflow");
1291     }
1292 
1293     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1294         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
1295     }
1296 
1297     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
1298         require(b > 0, "BoringMath: Div zero");
1299         c = a / b;
1300     }
1301 
1302     function to128(uint256 a) internal pure returns (uint128 c) {
1303         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
1304         c = uint128(a);
1305     }
1306 
1307     function to64(uint256 a) internal pure returns (uint64 c) {
1308         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
1309         c = uint64(a);
1310     }
1311 
1312     function to32(uint256 a) internal pure returns (uint32 c) {
1313         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
1314         c = uint32(a);
1315     }
1316 
1317     function to16(uint256 a) internal pure returns (uint16 c) {
1318         require(a <= uint16(-1), "BoringMath: uint16 Overflow");
1319         c = uint16(a);
1320     }
1321 
1322 }
1323 
1324 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
1325 library BoringMath128 {
1326     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
1327         require((c = a + b) >= b, "BoringMath: Add Overflow");
1328     }
1329 
1330     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
1331         require((c = a - b) <= a, "BoringMath: Underflow");
1332     }
1333 }
1334 
1335 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
1336 library BoringMath64 {
1337     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
1338         require((c = a + b) >= b, "BoringMath: Add Overflow");
1339     }
1340 
1341     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
1342         require((c = a - b) <= a, "BoringMath: Underflow");
1343     }
1344 }
1345 
1346 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
1347 library BoringMath32 {
1348     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
1349         require((c = a + b) >= b, "BoringMath: Add Overflow");
1350     }
1351 
1352     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
1353         require((c = a - b) <= a, "BoringMath: Underflow");
1354     }
1355 }
1356 
1357 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
1358 library BoringMath16 {
1359     function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
1360         require((c = a + b) >= b, "BoringMath: Add Overflow");
1361     }
1362 
1363     function sub(uint16 a, uint16 b) internal pure returns (uint16 c) {
1364         require((c = a - b) <= a, "BoringMath: Underflow");
1365     }
1366 }
1367 
1368 
1369 // File contracts/Utils/Documents.sol
1370 
1371 pragma solidity 0.6.12;
1372 
1373 
1374 /**
1375  * @title Standard implementation of ERC1643 Document management
1376  */
1377 contract Documents {
1378 
1379     struct Document {
1380         uint32 docIndex;    // Store the document name indexes
1381         uint64 lastModified; // Timestamp at which document details was last modified
1382         string data; // data of the document that exist off-chain
1383     }
1384 
1385     // mapping to store the documents details in the document
1386     mapping(string => Document) internal _documents;
1387     // mapping to store the document name indexes
1388     mapping(string => uint32) internal _docIndexes;
1389     // Array use to store all the document name present in the contracts
1390     string[] _docNames;
1391 
1392     // Document Events
1393     event DocumentRemoved(string indexed _name, string _data);
1394     event DocumentUpdated(string indexed _name, string _data);
1395 
1396     /**
1397      * @notice Used to attach a new document to the contract, or update the data or hash of an existing attached document
1398      * @dev Can only be executed by the owner of the contract.
1399      * @param _name Name of the document. It should be unique always
1400      * @param _data Off-chain data of the document from where it is accessible to investors/advisors to read.
1401      */
1402     function _setDocument(string calldata _name, string calldata _data) internal {
1403         require(bytes(_name).length > 0, "Zero name is not allowed");
1404         require(bytes(_data).length > 0, "Should not be a empty data");
1405         // Document storage document = _documents[_name];
1406         if (_documents[_name].lastModified == uint64(0)) {
1407             _docNames.push(_name);
1408             _documents[_name].docIndex = uint32(_docNames.length);
1409         }
1410         _documents[_name] = Document(_documents[_name].docIndex, uint64(now), _data);
1411         emit DocumentUpdated(_name, _data);
1412     }
1413 
1414     /**
1415      * @notice Used to remove an existing document from the contract by giving the name of the document.
1416      * @dev Can only be executed by the owner of the contract.
1417      * @param _name Name of the document. It should be unique always
1418      */
1419 
1420     function _removeDocument(string calldata _name) internal {
1421         require(_documents[_name].lastModified != uint64(0), "Document should exist");
1422         uint32 index = _documents[_name].docIndex - 1;
1423         if (index != _docNames.length - 1) {
1424             _docNames[index] = _docNames[_docNames.length - 1];
1425             _documents[_docNames[index]].docIndex = index + 1; 
1426         }
1427         _docNames.pop();
1428         emit DocumentRemoved(_name, _documents[_name].data);
1429         delete _documents[_name];
1430     }
1431 
1432     /**
1433      * @notice Used to return the details of a document with a known name (`string`).
1434      * @param _name Name of the document
1435      * @return string The data associated with the document.
1436      * @return uint256 the timestamp at which the document was last modified.
1437      */
1438     function getDocument(string calldata _name) external view returns (string memory, uint256) {
1439         return (
1440             _documents[_name].data,
1441             uint256(_documents[_name].lastModified)
1442         );
1443     }
1444 
1445     /**
1446      * @notice Used to retrieve a full list of documents attached to the smart contract.
1447      * @return string List of all documents names present in the contract.
1448      */
1449     function getAllDocuments() external view returns (string[] memory) {
1450         return _docNames;
1451     }
1452 
1453     /**
1454      * @notice Used to retrieve the total documents in the smart contract.
1455      * @return uint256 Count of the document names present in the contract.
1456      */
1457     function getDocumentCount() external view returns (uint256) {
1458         return _docNames.length;
1459     }
1460 
1461     /**
1462      * @notice Used to retrieve the document name from index in the smart contract.
1463      * @return string Name of the document name.
1464      */
1465     function getDocumentName(uint256 _index) external view returns (string memory) {
1466         require(_index < _docNames.length, "Index out of bounds");
1467         return _docNames[_index];
1468     }
1469 
1470 }
1471 
1472 
1473 // File contracts/interfaces/IPointList.sol
1474 
1475 pragma solidity 0.6.12;
1476 
1477 // ----------------------------------------------------------------------------
1478 // White List interface
1479 // ----------------------------------------------------------------------------
1480 
1481 interface IPointList {
1482     function isInList(address account) external view returns (bool);
1483     function hasPoints(address account, uint256 amount) external view  returns (bool);
1484     function setPoints(
1485         address[] memory accounts,
1486         uint256[] memory amounts
1487     ) external; 
1488     function initPointList(address accessControl) external ;
1489 
1490 }
1491 
1492 
1493 // File contracts/interfaces/IMisoMarket.sol
1494 
1495 pragma solidity 0.6.12;
1496 
1497 interface IMisoMarket {
1498 
1499     function init(bytes calldata data) external payable;
1500     function initMarket( bytes calldata data ) external;
1501     function marketTemplate() external view returns (uint256);
1502 
1503 }
1504 
1505 
1506 // File contracts/Auctions/DutchAuction.sol
1507 
1508 pragma solidity 0.6.12;
1509 pragma experimental ABIEncoderV2;
1510 
1511 
1512 //----------------------------------------------------------------------------------
1513 //    I n s t a n t
1514 //
1515 //        .:mmm.         .:mmm:.       .ii.  .:SSSSSSSSSSSSS.     .oOOOOOOOOOOOo.  
1516 //      .mMM'':Mm.     .:MM'':Mm:.     .II:  :SSs..........     .oOO'''''''''''OOo.
1517 //    .:Mm'   ':Mm.   .:Mm'   'MM:.    .II:  'sSSSSSSSSSSSSS:.  :OO.           .OO:
1518 //  .'mMm'     ':MM:.:MMm'     ':MM:.  .II:  .:...........:SS.  'OOo:.........:oOO'
1519 //  'mMm'        ':MMmm'         'mMm:  II:  'sSSSSSSSSSSSSS'     'oOOOOOOOOOOOO'  
1520 //
1521 //----------------------------------------------------------------------------------
1522 //
1523 // Chef Gonpachi's Dutch Auction
1524 //
1525 // A declining price auction with fair price discovery. 
1526 //
1527 // Inspired by DutchSwap's Dutch Auctions
1528 // https://github.com/deepyr/DutchSwap
1529 // 
1530 // This program is free software: you can redistribute it and/or modify
1531 // it under the terms of the GNU General Public License as published by
1532 // the Free Software Foundation, either version 3 of the License
1533 //
1534 // This program is distributed in the hope that it will be useful,
1535 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1536 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1537 // GNU General Public License for more details.
1538 //
1539 // The above copyright notice and this permission notice shall be included 
1540 // in all copies or substantial portions of the Software.
1541 //
1542 // Made for Sushi.com 
1543 // 
1544 // Enjoy. (c) Chef Gonpachi, Kusatoshi, SSMikazu 2021 
1545 // <https://github.com/chefgonpachi/MISO/>
1546 //
1547 // ---------------------------------------------------------------------
1548 // SPDX-License-Identifier: GPL-3.0                        
1549 // ---------------------------------------------------------------------
1550 
1551 
1552 
1553 
1554 
1555 
1556 
1557 
1558 
1559 /// @notice Attribution to delta.financial
1560 /// @notice Attribution to dutchswap.com
1561 
1562 contract DutchAuction is IMisoMarket, MISOAccessControls, BoringBatchable, SafeTransfer, Documents , ReentrancyGuard  {
1563     using BoringMath for uint256;
1564     using BoringMath128 for uint128;
1565     using BoringMath64 for uint64;
1566     using BoringERC20 for IERC20;
1567 
1568     /// @notice MISOMarket template id for the factory contract.
1569     /// @dev For different marketplace types, this must be incremented.
1570     uint256 public constant override marketTemplate = 2;
1571     /// @dev The placeholder ETH address.
1572     address private constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1573 
1574     /// @notice Main market variables.
1575     struct MarketInfo {
1576         uint64 startTime;
1577         uint64 endTime;
1578         uint128 totalTokens;
1579     }
1580     MarketInfo public marketInfo;
1581 
1582     /// @notice Market price variables.
1583     struct MarketPrice {
1584         uint128 startPrice;
1585         uint128 minimumPrice;
1586     }
1587     MarketPrice public marketPrice;
1588 
1589     /// @notice Market dynamic variables.
1590     struct MarketStatus {
1591         uint128 commitmentsTotal;
1592         bool finalized;
1593         bool usePointList;
1594     }
1595 
1596     MarketStatus public marketStatus;
1597 
1598     /// @notice The token being sold.
1599     address public auctionToken; 
1600     /// @notice The currency the auction accepts for payment. Can be ETH or token address.
1601     address public paymentCurrency;  
1602     /// @notice Where the auction funds will get paid.
1603     address payable public wallet;  
1604     /// @notice Address that manages auction approvals.
1605     address public pointList;
1606 
1607     /// @notice The commited amount of accounts.
1608     mapping(address => uint256) public commitments; 
1609     /// @notice Amount of tokens to claim per address.
1610     mapping(address => uint256) public claimed;
1611 
1612     /// @notice Event for updating auction times.  Needs to be before auction starts.
1613     event AuctionTimeUpdated(uint256 startTime, uint256 endTime); 
1614     /// @notice Event for updating auction prices. Needs to be before auction starts.
1615     event AuctionPriceUpdated(uint256 startPrice, uint256 minimumPrice); 
1616     /// @notice Event for updating auction wallet. Needs to be before auction starts.
1617     event AuctionWalletUpdated(address wallet); 
1618 
1619     /// @notice Event for adding a commitment.
1620     event AddedCommitment(address addr, uint256 commitment);   
1621     /// @notice Event for finalization of the auction.
1622     event AuctionFinalized();
1623     /// @notice Event for cancellation of the auction.
1624     event AuctionCancelled();
1625 
1626     /**
1627      * @notice Initializes main contract variables and transfers funds for the auction.
1628      * @dev Init function.
1629      * @param _funder The address that funds the token for crowdsale.
1630      * @param _token Address of the token being sold.
1631      * @param _totalTokens The total number of tokens to sell in auction.
1632      * @param _startTime Auction start time.
1633      * @param _endTime Auction end time.
1634      * @param _paymentCurrency The currency the crowdsale accepts for payment. Can be ETH or token address.
1635      * @param _startPrice Starting price of the auction.
1636      * @param _minimumPrice The minimum auction price.
1637      * @param _admin Address that can finalize auction.
1638      * @param _pointList Address that will manage auction approvals.
1639      * @param _wallet Address where collected funds will be forwarded to.
1640      */
1641     function initAuction(
1642         address _funder,
1643         address _token,
1644         uint256 _totalTokens,
1645         uint256 _startTime,
1646         uint256 _endTime,
1647         address _paymentCurrency,
1648         uint256 _startPrice,
1649         uint256 _minimumPrice,
1650         address _admin,
1651         address _pointList,
1652         address payable _wallet
1653     ) public {
1654         require(_startTime < 10000000000, "DutchAuction: enter an unix timestamp in seconds, not miliseconds");
1655         require(_endTime < 10000000000, "DutchAuction: enter an unix timestamp in seconds, not miliseconds");
1656         require(_startTime >= block.timestamp, "DutchAuction: start time is before current time");
1657         require(_endTime > _startTime, "DutchAuction: end time must be older than start price");
1658         require(_totalTokens > 0,"DutchAuction: total tokens must be greater than zero");
1659         require(_startPrice > _minimumPrice, "DutchAuction: start price must be higher than minimum price");
1660         require(_minimumPrice > 0, "DutchAuction: minimum price must be greater than 0"); 
1661         require(_admin != address(0), "DutchAuction: admin is the zero address");
1662         require(_wallet != address(0), "DutchAuction: wallet is the zero address");
1663         require(IERC20(_token).decimals() == 18, "DutchAuction: Token does not have 18 decimals");
1664         if (_paymentCurrency != ETH_ADDRESS) {
1665             require(IERC20(_paymentCurrency).decimals() > 0, "DutchAuction: Payment currency is not ERC20");
1666         }
1667 
1668         marketInfo.startTime = BoringMath.to64(_startTime);
1669         marketInfo.endTime = BoringMath.to64(_endTime);
1670         marketInfo.totalTokens = BoringMath.to128(_totalTokens);
1671 
1672         marketPrice.startPrice = BoringMath.to128(_startPrice);
1673         marketPrice.minimumPrice = BoringMath.to128(_minimumPrice);
1674 
1675         auctionToken = _token;
1676         paymentCurrency = _paymentCurrency;
1677         wallet = _wallet;
1678 
1679         initAccessControls(_admin);
1680 
1681         _setList(_pointList);
1682         _safeTransferFrom(_token, _funder, _totalTokens);
1683     }
1684 
1685 
1686 
1687     /**
1688      Dutch Auction Price Function
1689      ============================
1690      
1691      Start Price -----
1692                       \
1693                        \
1694                         \
1695                          \ ------------ Clearing Price
1696                         / \            = AmountRaised/TokenSupply
1697          Token Price  --   \
1698                      /      \
1699                    --        ----------- Minimum Price
1700      Amount raised /          End Time
1701     */
1702 
1703     /**
1704      * @notice Calculates the average price of each token from all commitments.
1705      * @return Average token price.
1706      */
1707     function tokenPrice() public view returns (uint256) {
1708         return uint256(marketStatus.commitmentsTotal).mul(1e18).div(uint256(marketInfo.totalTokens));
1709     }
1710 
1711     /**
1712      * @notice Returns auction price in any time.
1713      * @return Fixed start price or minimum price if outside of auction time, otherwise calculated current price.
1714      */
1715     function priceFunction() public view returns (uint256) {
1716         /// @dev Return Auction Price
1717         if (block.timestamp <= uint256(marketInfo.startTime)) {
1718             return uint256(marketPrice.startPrice);
1719         }
1720         if (block.timestamp >= uint256(marketInfo.endTime)) {
1721             return uint256(marketPrice.minimumPrice);
1722         }
1723 
1724         return _currentPrice();
1725     }
1726 
1727     /**
1728      * @notice The current clearing price of the Dutch auction.
1729      * @return The bigger from tokenPrice and priceFunction.
1730      */
1731     function clearingPrice() public view returns (uint256) {
1732         /// @dev If auction successful, return tokenPrice
1733         if (tokenPrice() > priceFunction()) {
1734             return tokenPrice();
1735         }
1736         return priceFunction();
1737     }
1738 
1739 
1740     ///--------------------------------------------------------
1741     /// Commit to buying tokens!
1742     ///--------------------------------------------------------
1743 
1744     receive() external payable {
1745         revertBecauseUserDidNotProvideAgreement();
1746     }
1747 
1748     /** 
1749      * @dev Attribution to the awesome delta.financial contracts
1750     */  
1751     function marketParticipationAgreement() public pure returns (string memory) {
1752         return "I understand that I'm interacting with a smart contract. I understand that tokens commited are subject to the token issuer and local laws where applicable. I reviewed code of the smart contract and understand it fully. I agree to not hold developers or other people associated with the project liable for any losses or misunderstandings";
1753     }
1754     /** 
1755      * @dev Not using modifiers is a purposeful choice for code readability.
1756     */ 
1757     function revertBecauseUserDidNotProvideAgreement() internal pure {
1758         revert("No agreement provided, please review the smart contract before interacting with it");
1759     }
1760 
1761     /**
1762      * @notice Checks the amount of ETH to commit and adds the commitment. Refunds the buyer if commit is too high.
1763      * @param _beneficiary Auction participant ETH address.
1764      */
1765     function commitEth(
1766         address payable _beneficiary,
1767         bool readAndAgreedToMarketParticipationAgreement
1768     )
1769         public payable
1770     {
1771         require(paymentCurrency == ETH_ADDRESS, "DutchAuction: payment currency is not ETH address"); 
1772         if(readAndAgreedToMarketParticipationAgreement == false) {
1773             revertBecauseUserDidNotProvideAgreement();
1774         }
1775         // Get ETH able to be committed
1776         uint256 ethToTransfer = calculateCommitment(msg.value);
1777 
1778         /// @notice Accept ETH Payments.
1779         uint256 ethToRefund = msg.value.sub(ethToTransfer);
1780         if (ethToTransfer > 0) {
1781             _addCommitment(_beneficiary, ethToTransfer);
1782         }
1783         /// @notice Return any ETH to be refunded.
1784         if (ethToRefund > 0) {
1785             _beneficiary.transfer(ethToRefund);
1786         }
1787     }
1788 
1789     /**
1790      * @notice Buy Tokens by commiting approved ERC20 tokens to this contract address.
1791      * @param _amount Amount of tokens to commit.
1792      */
1793     function commitTokens(uint256 _amount, bool readAndAgreedToMarketParticipationAgreement) public {
1794         commitTokensFrom(msg.sender, _amount, readAndAgreedToMarketParticipationAgreement);
1795     }
1796 
1797 
1798     /**
1799      * @notice Checks how much is user able to commit and processes that commitment.
1800      * @dev Users must approve contract prior to committing tokens to auction.
1801      * @param _from User ERC20 address.
1802      * @param _amount Amount of approved ERC20 tokens.
1803      */
1804     function commitTokensFrom(
1805         address _from,
1806         uint256 _amount,
1807         bool readAndAgreedToMarketParticipationAgreement
1808     )
1809         public   nonReentrant  
1810     {
1811         require(address(paymentCurrency) != ETH_ADDRESS, "DutchAuction: Payment currency is not a token");
1812         if(readAndAgreedToMarketParticipationAgreement == false) {
1813             revertBecauseUserDidNotProvideAgreement();
1814         }
1815         uint256 tokensToTransfer = calculateCommitment(_amount);
1816         if (tokensToTransfer > 0) {
1817             _safeTransferFrom(paymentCurrency, msg.sender, tokensToTransfer);
1818             _addCommitment(_from, tokensToTransfer);
1819         }
1820     }
1821 
1822     /**
1823      * @notice Calculates the pricedrop factor.
1824      * @return Value calculated from auction start and end price difference divided the auction duration.
1825      */
1826     function priceDrop() public view returns (uint256) {
1827         MarketInfo memory _marketInfo = marketInfo;
1828         MarketPrice memory _marketPrice = marketPrice;
1829 
1830         uint256 numerator = uint256(_marketPrice.startPrice.sub(_marketPrice.minimumPrice));
1831         uint256 denominator = uint256(_marketInfo.endTime.sub(_marketInfo.startTime));
1832         return numerator / denominator;
1833     }
1834 
1835 
1836    /**
1837      * @notice How many tokens the user is able to claim.
1838      * @param _user Auction participant address.
1839      * @return User commitments reduced by already claimed tokens.
1840      */
1841     function tokensClaimable(address _user) public view returns (uint256) {
1842         uint256 tokensAvailable = commitments[_user].mul(1e18).div(clearingPrice());
1843         return tokensAvailable.sub(claimed[_user]);
1844     }
1845 
1846     /**
1847      * @notice Calculates total amount of tokens committed at current auction price.
1848      * @return Number of tokens commited.
1849      */
1850     function totalTokensCommitted() public view returns (uint256) {
1851         return uint256(marketStatus.commitmentsTotal).mul(1e18).div(clearingPrice());
1852     }
1853 
1854     /**
1855      * @notice Calculates the amout able to be committed during an auction.
1856      * @param _commitment Commitment user would like to make.
1857      * @return committed Amount allowed to commit.
1858      */
1859     function calculateCommitment(uint256 _commitment) public view returns (uint256 committed) {
1860         uint256 maxCommitment = uint256(marketInfo.totalTokens).mul(clearingPrice()).div(1e18);
1861         if (uint256(marketStatus.commitmentsTotal).add(_commitment) > maxCommitment) {
1862             return maxCommitment.sub(uint256(marketStatus.commitmentsTotal));
1863         }
1864         return _commitment;
1865     }
1866 
1867     /**
1868      * @notice Checks if the auction is open.
1869      * @return True if current time is greater than startTime and less than endTime.
1870      */
1871     function isOpen() public view returns (bool) {
1872         return block.timestamp >= uint256(marketInfo.startTime) && block.timestamp <= uint256(marketInfo.endTime);
1873     }
1874 
1875     /**
1876      * @notice Successful if tokens sold equals totalTokens.
1877      * @return True if tokenPrice is bigger or equal clearingPrice.
1878      */
1879     function auctionSuccessful() public view returns (bool) {
1880         return tokenPrice() >= clearingPrice();
1881     }
1882 
1883     /**
1884      * @notice Checks if the auction has ended.
1885      * @return True if auction is successful or time has ended.
1886      */
1887     function auctionEnded() public view returns (bool) {
1888         return auctionSuccessful() || block.timestamp > uint256(marketInfo.endTime);
1889     }
1890 
1891     /**
1892      * @return Returns true if market has been finalized
1893      */
1894     function finalized() public view returns (bool) {
1895         return marketStatus.finalized;
1896     }
1897 
1898     /**
1899      * @return Returns true if 14 days have passed since the end of the auction
1900      */
1901     function finalizeTimeExpired() public view returns (bool) {
1902         return uint256(marketInfo.endTime) + 7 days < block.timestamp;
1903     }
1904 
1905     /**
1906      * @notice Calculates price during the auction.
1907      * @return Current auction price.
1908      */
1909     function _currentPrice() private view returns (uint256) {
1910         uint256 priceDiff = block.timestamp.sub(uint256(marketInfo.startTime)).mul(priceDrop());
1911         return uint256(marketPrice.startPrice).sub(priceDiff);
1912     }
1913 
1914     /**
1915      * @notice Updates commitment for this address and total commitment of the auction.
1916      * @param _addr Bidders address.
1917      * @param _commitment The amount to commit.
1918      */
1919     function _addCommitment(address _addr, uint256 _commitment) internal {
1920         require(block.timestamp >= uint256(marketInfo.startTime) && block.timestamp <= uint256(marketInfo.endTime), "DutchAuction: outside auction hours");
1921         MarketStatus storage status = marketStatus;
1922         
1923         uint256 newCommitment = commitments[_addr].add(_commitment);
1924         if (status.usePointList) {
1925             require(IPointList(pointList).hasPoints(_addr, newCommitment));
1926         }
1927         
1928         commitments[_addr] = newCommitment;
1929         status.commitmentsTotal = BoringMath.to128(uint256(status.commitmentsTotal).add(_commitment));
1930         emit AddedCommitment(_addr, _commitment);
1931     }
1932 
1933 
1934     //--------------------------------------------------------
1935     // Finalize Auction
1936     //--------------------------------------------------------
1937 
1938 
1939     /**
1940      * @notice Cancel Auction
1941      * @dev Admin can cancel the auction before it starts
1942      */
1943     function cancelAuction() public   nonReentrant  
1944     {
1945         require(hasAdminRole(msg.sender));
1946         MarketStatus storage status = marketStatus;
1947         require(!status.finalized, "DutchAuction: auction already finalized");
1948         require( uint256(status.commitmentsTotal) == 0, "DutchAuction: auction already committed" );
1949         _safeTokenPayment(auctionToken, wallet, uint256(marketInfo.totalTokens));
1950         status.finalized = true;
1951         emit AuctionCancelled();
1952     }
1953 
1954     /**
1955      * @notice Auction finishes successfully above the reserve.
1956      * @dev Transfer contract funds to initialized wallet.
1957      */
1958     function finalize() public   nonReentrant  
1959     {
1960 
1961         require(hasAdminRole(msg.sender) 
1962                 || hasSmartContractRole(msg.sender) 
1963                 || wallet == msg.sender
1964                 || finalizeTimeExpired(), "DutchAuction: sender must be an admin");
1965         MarketStatus storage status = marketStatus;
1966 
1967         require(!status.finalized, "DutchAuction: auction already finalized");
1968         if (auctionSuccessful()) {
1969             /// @dev Successful auction
1970             /// @dev Transfer contributed tokens to wallet.
1971             _safeTokenPayment(paymentCurrency, wallet, uint256(status.commitmentsTotal));
1972         } else {
1973             /// @dev Failed auction
1974             /// @dev Return auction tokens back to wallet.
1975             require(block.timestamp > uint256(marketInfo.endTime), "DutchAuction: auction has not finished yet"); 
1976             _safeTokenPayment(auctionToken, wallet, uint256(marketInfo.totalTokens));
1977         }
1978         status.finalized = true;
1979         emit AuctionFinalized();
1980     }
1981 
1982 
1983     /// @notice Withdraws bought tokens, or returns commitment if the sale is unsuccessful.
1984     function withdrawTokens() public  {
1985         withdrawTokens(msg.sender);
1986     }
1987 
1988    /**
1989      * @notice Withdraws bought tokens, or returns commitment if the sale is unsuccessful.
1990      * @dev Withdraw tokens only after auction ends.
1991      * @param beneficiary Whose tokens will be withdrawn.
1992      */
1993     function withdrawTokens(address payable beneficiary) public   nonReentrant  {
1994         if (auctionSuccessful()) {
1995             require(marketStatus.finalized, "DutchAuction: not finalized");
1996             /// @dev Successful auction! Transfer claimed tokens.
1997             uint256 tokensToClaim = tokensClaimable(beneficiary);
1998             require(tokensToClaim > 0, "DutchAuction: No tokens to claim"); 
1999             claimed[beneficiary] = claimed[beneficiary].add(tokensToClaim);
2000             _safeTokenPayment(auctionToken, beneficiary, tokensToClaim);
2001         } else {
2002             /// @dev Auction did not meet reserve price.
2003             /// @dev Return committed funds back to user.
2004             require(block.timestamp > uint256(marketInfo.endTime), "DutchAuction: auction has not finished yet");
2005             uint256 fundsCommitted = commitments[beneficiary];
2006             commitments[beneficiary] = 0; // Stop multiple withdrawals and free some gas
2007             _safeTokenPayment(paymentCurrency, beneficiary, fundsCommitted);
2008         }
2009     }
2010 
2011 
2012     //--------------------------------------------------------
2013     // Documents
2014     //--------------------------------------------------------
2015 
2016     function setDocument(string calldata _name, string calldata _data) external {
2017         require(hasAdminRole(msg.sender) );
2018         _setDocument( _name, _data);
2019     }
2020 
2021     function setDocuments(string[] calldata _name, string[] calldata _data) external {
2022         require(hasAdminRole(msg.sender) );
2023         uint256 numDocs = _name.length;
2024         for (uint256 i = 0; i < numDocs; i++) {
2025             _setDocument( _name[i], _data[i]);
2026         }
2027     }
2028 
2029     function removeDocument(string calldata _name) external {
2030         require(hasAdminRole(msg.sender));
2031         _removeDocument(_name);
2032     }
2033 
2034 
2035     //--------------------------------------------------------
2036     // Point Lists
2037     //--------------------------------------------------------
2038 
2039 
2040     function setList(address _list) external {
2041         require(hasAdminRole(msg.sender));
2042         _setList(_list);
2043     }
2044 
2045     function enableList(bool _status) external {
2046         require(hasAdminRole(msg.sender));
2047         marketStatus.usePointList = _status;
2048     }
2049 
2050     function _setList(address _pointList) private {
2051         if (_pointList != address(0)) {
2052             pointList = _pointList;
2053             marketStatus.usePointList = true;
2054         }
2055     }
2056 
2057     //--------------------------------------------------------
2058     // Setter Functions
2059     //--------------------------------------------------------
2060 
2061     /**
2062      * @notice Admin can set start and end time through this function.
2063      * @param _startTime Auction start time.
2064      * @param _endTime Auction end time.
2065      */
2066     function setAuctionTime(uint256 _startTime, uint256 _endTime) external {
2067         require(hasAdminRole(msg.sender));
2068         require(_startTime < 10000000000, "DutchAuction: enter an unix timestamp in seconds, not miliseconds");
2069         require(_endTime < 10000000000, "DutchAuction: enter an unix timestamp in seconds, not miliseconds");
2070         require(_startTime >= block.timestamp, "DutchAuction: start time is before current time");
2071         require(_endTime > _startTime, "DutchAuction: end time must be older than start time");
2072         require(marketStatus.commitmentsTotal == 0, "DutchAuction: auction cannot have already started");
2073 
2074         marketInfo.startTime = BoringMath.to64(_startTime);
2075         marketInfo.endTime = BoringMath.to64(_endTime);
2076         
2077         emit AuctionTimeUpdated(_startTime,_endTime);
2078     }
2079 
2080     /**
2081      * @notice Admin can set start and min price through this function.
2082      * @param _startPrice Auction start price.
2083      * @param _minimumPrice Auction minimum price.
2084      */
2085     function setAuctionPrice(uint256 _startPrice, uint256 _minimumPrice) external {
2086         require(hasAdminRole(msg.sender));
2087         require(_startPrice > _minimumPrice, "DutchAuction: start price must be higher than minimum price");
2088         require(_minimumPrice > 0, "DutchAuction: minimum price must be greater than 0"); 
2089         require(marketStatus.commitmentsTotal == 0, "DutchAuction: auction cannot have already started");
2090 
2091         marketPrice.startPrice = BoringMath.to128(_startPrice);
2092         marketPrice.minimumPrice = BoringMath.to128(_minimumPrice);
2093 
2094         emit AuctionPriceUpdated(_startPrice,_minimumPrice);
2095     }
2096 
2097     /**
2098      * @notice Admin can set the auction wallet through this function.
2099      * @param _wallet Auction wallet is where funds will be sent.
2100      */
2101     function setAuctionWallet(address payable _wallet) external {
2102         require(hasAdminRole(msg.sender));
2103         require(_wallet != address(0), "DutchAuction: wallet is the zero address");
2104 
2105         wallet = _wallet;
2106 
2107         emit AuctionWalletUpdated(_wallet);
2108     }
2109 
2110 
2111    //--------------------------------------------------------
2112     // Market Launchers
2113     //--------------------------------------------------------
2114 
2115     /**
2116      * @notice Decodes and hands auction data to the initAuction function.
2117      * @param _data Encoded data for initialization.
2118      */
2119 
2120     function init(bytes calldata _data) external override payable {
2121 
2122     }
2123 
2124     function initMarket(
2125         bytes calldata _data
2126     ) public override {
2127         (
2128         address _funder,
2129         address _token,
2130         uint256 _totalTokens,
2131         uint256 _startTime,
2132         uint256 _endTime,
2133         address _paymentCurrency,
2134         uint256 _startPrice,
2135         uint256 _minimumPrice,
2136         address _admin,
2137         address _pointList,
2138         address payable _wallet
2139         ) = abi.decode(_data, (
2140             address,
2141             address,
2142             uint256,
2143             uint256,
2144             uint256,
2145             address,
2146             uint256,
2147             uint256,
2148             address,
2149             address,
2150             address
2151         ));
2152         initAuction(_funder, _token, _totalTokens, _startTime, _endTime, _paymentCurrency, _startPrice, _minimumPrice, _admin, _pointList, _wallet);
2153     }
2154 
2155     /**
2156      * @notice Collects data to initialize the auction and encodes them.
2157      * @param _funder The address that funds the token for crowdsale.
2158      * @param _token Address of the token being sold.
2159      * @param _totalTokens The total number of tokens to sell in auction.
2160      * @param _startTime Auction start time.
2161      * @param _endTime Auction end time.
2162      * @param _paymentCurrency The currency the crowdsale accepts for payment. Can be ETH or token address.
2163      * @param _startPrice Starting price of the auction.
2164      * @param _minimumPrice The minimum auction price.
2165      * @param _admin Address that can finalize auction.
2166      * @param _pointList Address that will manage auction approvals.
2167      * @param _wallet Address where collected funds will be forwarded to.
2168      * @return _data All the data in bytes format.
2169      */
2170     function getAuctionInitData(
2171         address _funder,
2172         address _token,
2173         uint256 _totalTokens,
2174         uint256 _startTime,
2175         uint256 _endTime,
2176         address _paymentCurrency,
2177         uint256 _startPrice,
2178         uint256 _minimumPrice,
2179         address _admin,
2180         address _pointList,
2181         address payable _wallet
2182     )
2183         external 
2184         pure
2185         returns (bytes memory _data)
2186     {
2187             return abi.encode(
2188                 _funder,
2189                 _token,
2190                 _totalTokens,
2191                 _startTime,
2192                 _endTime,
2193                 _paymentCurrency,
2194                 _startPrice,
2195                 _minimumPrice,
2196                 _admin,
2197                 _pointList,
2198                 _wallet
2199             );
2200     }
2201         
2202     function getBaseInformation() external view returns(
2203         address, 
2204         uint64,
2205         uint64,
2206         bool 
2207     ) {
2208         return (auctionToken, marketInfo.startTime, marketInfo.endTime, marketStatus.finalized);
2209     }
2210 
2211     function getTotalTokens() external view returns(uint256) {
2212         return uint256(marketInfo.totalTokens);
2213     }
2214 
2215 }