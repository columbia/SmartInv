1 // File contracts/OpenZeppelin/utils/ReentrancyGuard.sol
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  */
21 abstract contract ReentrancyGuard {
22     // Booleans are more expensive than uint256 or any type that takes up a full
23     // word because each write operation emits an extra SLOAD to first read the
24     // slot's contents, replace the bits taken up by the boolean, and then write
25     // back. This is the compiler's defense against contract upgrades and
26     // pointer aliasing, and it cannot be disabled.
27 
28     // The values being non-zero value makes deployment a bit more expensive,
29     // but in exchange the refund on every call to nonReentrant will be lower in
30     // amount. Since refunds are capped to a percentage of the total
31     // transaction's gas, it is best to keep them low in cases like this one, to
32     // increase the likelihood of the full refund coming into effect.
33     uint256 private constant _NOT_ENTERED = 1;
34     uint256 private constant _ENTERED = 2;
35 
36     uint256 private _status;
37 
38     constructor () internal {
39         _status = _NOT_ENTERED;
40     }
41 
42     /**
43      * @dev Prevents a contract from calling itself, directly or indirectly.
44      * Calling a `nonReentrant` function from another `nonReentrant`
45      * function is not supported. It is possible to prevent this from happening
46      * by making the `nonReentrant` function external, and make it call a
47      * `private` function that does the actual work.
48      */
49     modifier nonReentrant() {
50         // On the first call to nonReentrant, _notEntered will be true
51         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
52 
53         // Any calls to nonReentrant after this point will fail
54         _status = _ENTERED;
55 
56         _;
57 
58         // By storing the original value once again, a refund is triggered (see
59         // https://eips.ethereum.org/EIPS/eip-2200)
60         _status = _NOT_ENTERED;
61     }
62 }
63 
64 
65 // File contracts/OpenZeppelin/utils/EnumerableSet.sol
66 
67 pragma solidity 0.6.12;
68 
69 /**
70  * @dev Library for managing
71  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
72  * types.
73  *
74  * Sets have the following properties:
75  *
76  * - Elements are added, removed, and checked for existence in constant time
77  * (O(1)).
78  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
79  *
80  * ```
81  * contract Example {
82  *     // Add the library methods
83  *     using EnumerableSet for EnumerableSet.AddressSet;
84  *
85  *     // Declare a set state variable
86  *     EnumerableSet.AddressSet private mySet;
87  * }
88  * ```
89  *
90  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
91  * and `uint256` (`UintSet`) are supported.
92  */
93 library EnumerableSet {
94     // To implement this library for multiple types with as little code
95     // repetition as possible, we write it in terms of a generic Set type with
96     // bytes32 values.
97     // The Set implementation uses private functions, and user-facing
98     // implementations (such as AddressSet) are just wrappers around the
99     // underlying Set.
100     // This means that we can only create new EnumerableSets for types that fit
101     // in bytes32.
102 
103     struct Set {
104         // Storage of set values
105         bytes32[] _values;
106 
107         // Position of the value in the `values` array, plus 1 because index 0
108         // means a value is not in the set.
109         mapping (bytes32 => uint256) _indexes;
110     }
111 
112     /**
113      * @dev Add a value to a set. O(1).
114      *
115      * Returns true if the value was added to the set, that is if it was not
116      * already present.
117      */
118     function _add(Set storage set, bytes32 value) private returns (bool) {
119         if (!_contains(set, value)) {
120             set._values.push(value);
121             // The value is stored at length-1, but we add 1 to all indexes
122             // and use 0 as a sentinel value
123             set._indexes[value] = set._values.length;
124             return true;
125         } else {
126             return false;
127         }
128     }
129 
130     /**
131      * @dev Removes a value from a set. O(1).
132      *
133      * Returns true if the value was removed from the set, that is if it was
134      * present.
135      */
136     function _remove(Set storage set, bytes32 value) private returns (bool) {
137         // We read and store the value's index to prevent multiple reads from the same storage slot
138         uint256 valueIndex = set._indexes[value];
139 
140         if (valueIndex != 0) { // Equivalent to contains(set, value)
141             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
142             // the array, and then remove the last element (sometimes called as 'swap and pop').
143             // This modifies the order of the array, as noted in {at}.
144 
145             uint256 toDeleteIndex = valueIndex - 1;
146             uint256 lastIndex = set._values.length - 1;
147 
148             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
149             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
150 
151             bytes32 lastvalue = set._values[lastIndex];
152 
153             // Move the last value to the index where the value to delete is
154             set._values[toDeleteIndex] = lastvalue;
155             // Update the index for the moved value
156             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
157 
158             // Delete the slot where the moved value was stored
159             set._values.pop();
160 
161             // Delete the index for the deleted slot
162             delete set._indexes[value];
163 
164             return true;
165         } else {
166             return false;
167         }
168     }
169 
170     /**
171      * @dev Returns true if the value is in the set. O(1).
172      */
173     function _contains(Set storage set, bytes32 value) private view returns (bool) {
174         return set._indexes[value] != 0;
175     }
176 
177     /**
178      * @dev Returns the number of values on the set. O(1).
179      */
180     function _length(Set storage set) private view returns (uint256) {
181         return set._values.length;
182     }
183 
184    /**
185     * @dev Returns the value stored at position `index` in the set. O(1).
186     *
187     * Note that there are no guarantees on the ordering of values inside the
188     * array, and it may change when more values are added or removed.
189     *
190     * Requirements:
191     *
192     * - `index` must be strictly less than {length}.
193     */
194     function _at(Set storage set, uint256 index) private view returns (bytes32) {
195         require(set._values.length > index, "EnumerableSet: index out of bounds");
196         return set._values[index];
197     }
198 
199     // Bytes32Set
200 
201     struct Bytes32Set {
202         Set _inner;
203     }
204 
205     /**
206      * @dev Add a value to a set. O(1).
207      *
208      * Returns true if the value was added to the set, that is if it was not
209      * already present.
210      */
211     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
212         return _add(set._inner, value);
213     }
214 
215     /**
216      * @dev Removes a value from a set. O(1).
217      *
218      * Returns true if the value was removed from the set, that is if it was
219      * present.
220      */
221     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
222         return _remove(set._inner, value);
223     }
224 
225     /**
226      * @dev Returns true if the value is in the set. O(1).
227      */
228     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
229         return _contains(set._inner, value);
230     }
231 
232     /**
233      * @dev Returns the number of values in the set. O(1).
234      */
235     function length(Bytes32Set storage set) internal view returns (uint256) {
236         return _length(set._inner);
237     }
238 
239    /**
240     * @dev Returns the value stored at position `index` in the set. O(1).
241     *
242     * Note that there are no guarantees on the ordering of values inside the
243     * array, and it may change when more values are added or removed.
244     *
245     * Requirements:
246     *
247     * - `index` must be strictly less than {length}.
248     */
249     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
250         return _at(set._inner, index);
251     }
252 
253     // AddressSet
254 
255     struct AddressSet {
256         Set _inner;
257     }
258 
259     /**
260      * @dev Add a value to a set. O(1).
261      *
262      * Returns true if the value was added to the set, that is if it was not
263      * already present.
264      */
265     function add(AddressSet storage set, address value) internal returns (bool) {
266         return _add(set._inner, bytes32(uint256(uint160(value))));
267     }
268 
269     /**
270      * @dev Removes a value from a set. O(1).
271      *
272      * Returns true if the value was removed from the set, that is if it was
273      * present.
274      */
275     function remove(AddressSet storage set, address value) internal returns (bool) {
276         return _remove(set._inner, bytes32(uint256(uint160(value))));
277     }
278 
279     /**
280      * @dev Returns true if the value is in the set. O(1).
281      */
282     function contains(AddressSet storage set, address value) internal view returns (bool) {
283         return _contains(set._inner, bytes32(uint256(uint160(value))));
284     }
285 
286     /**
287      * @dev Returns the number of values in the set. O(1).
288      */
289     function length(AddressSet storage set) internal view returns (uint256) {
290         return _length(set._inner);
291     }
292 
293    /**
294     * @dev Returns the value stored at position `index` in the set. O(1).
295     *
296     * Note that there are no guarantees on the ordering of values inside the
297     * array, and it may change when more values are added or removed.
298     *
299     * Requirements:
300     *
301     * - `index` must be strictly less than {length}.
302     */
303     function at(AddressSet storage set, uint256 index) internal view returns (address) {
304         return address(uint160(uint256(_at(set._inner, index))));
305     }
306 
307 
308     // UintSet
309 
310     struct UintSet {
311         Set _inner;
312     }
313 
314     /**
315      * @dev Add a value to a set. O(1).
316      *
317      * Returns true if the value was added to the set, that is if it was not
318      * already present.
319      */
320     function add(UintSet storage set, uint256 value) internal returns (bool) {
321         return _add(set._inner, bytes32(value));
322     }
323 
324     /**
325      * @dev Removes a value from a set. O(1).
326      *
327      * Returns true if the value was removed from the set, that is if it was
328      * present.
329      */
330     function remove(UintSet storage set, uint256 value) internal returns (bool) {
331         return _remove(set._inner, bytes32(value));
332     }
333 
334     /**
335      * @dev Returns true if the value is in the set. O(1).
336      */
337     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
338         return _contains(set._inner, bytes32(value));
339     }
340 
341     /**
342      * @dev Returns the number of values on the set. O(1).
343      */
344     function length(UintSet storage set) internal view returns (uint256) {
345         return _length(set._inner);
346     }
347 
348    /**
349     * @dev Returns the value stored at position `index` in the set. O(1).
350     *
351     * Note that there are no guarantees on the ordering of values inside the
352     * array, and it may change when more values are added or removed.
353     *
354     * Requirements:
355     *
356     * - `index` must be strictly less than {length}.
357     */
358     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
359         return uint256(_at(set._inner, index));
360     }
361 }
362 
363 
364 // File contracts/OpenZeppelin/utils/Address.sol
365 
366 pragma solidity 0.6.12;
367 
368 /**
369  * @dev Collection of functions related to the address type
370  */
371 library Address {
372     /**
373      * @dev Returns true if `account` is a contract.
374      *
375      * [IMPORTANT]
376      * ====
377      * It is unsafe to assume that an address for which this function returns
378      * false is an externally-owned account (EOA) and not a contract.
379      *
380      * Among others, `isContract` will return false for the following
381      * types of addresses:
382      *
383      *  - an externally-owned account
384      *  - a contract in construction
385      *  - an address where a contract will be created
386      *  - an address where a contract lived, but was destroyed
387      * ====
388      */
389     function isContract(address account) internal view returns (bool) {
390         // This method relies on extcodesize, which returns 0 for contracts in
391         // construction, since the code is only stored at the end of the
392         // constructor execution.
393 
394         uint256 size;
395         // solhint-disable-next-line no-inline-assembly
396         assembly { size := extcodesize(account) }
397         return size > 0;
398     }
399 
400     /**
401      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
402      * `recipient`, forwarding all available gas and reverting on errors.
403      *
404      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
405      * of certain opcodes, possibly making contracts go over the 2300 gas limit
406      * imposed by `transfer`, making them unable to receive funds via
407      * `transfer`. {sendValue} removes this limitation.
408      *
409      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
410      *
411      * IMPORTANT: because control is transferred to `recipient`, care must be
412      * taken to not create reentrancy vulnerabilities. Consider using
413      * {ReentrancyGuard} or the
414      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
415      */
416     function sendValue(address payable recipient, uint256 amount) internal {
417         require(address(this).balance >= amount, "Address: insufficient balance");
418 
419         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
420         (bool success, ) = recipient.call{ value: amount }("");
421         require(success, "Address: unable to send value, recipient may have reverted");
422     }
423 
424     /**
425      * @dev Performs a Solidity function call using a low level `call`. A
426      * plain`call` is an unsafe replacement for a function call: use this
427      * function instead.
428      *
429      * If `target` reverts with a revert reason, it is bubbled up by this
430      * function (like regular Solidity function calls).
431      *
432      * Returns the raw returned data. To convert to the expected return value,
433      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
434      *
435      * Requirements:
436      *
437      * - `target` must be a contract.
438      * - calling `target` with `data` must not revert.
439      *
440      * _Available since v3.1._
441      */
442     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
443       return functionCall(target, data, "Address: low-level call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
448      * `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, 0, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but also transferring `value` wei to `target`.
459      *
460      * Requirements:
461      *
462      * - the calling contract must have an ETH balance of at least `value`.
463      * - the called Solidity function must be `payable`.
464      *
465      * _Available since v3.1._
466      */
467     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
468         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
473      * with `errorMessage` as a fallback revert reason when `target` reverts.
474      *
475      * _Available since v3.1._
476      */
477     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
478         require(address(this).balance >= value, "Address: insufficient balance for call");
479         require(isContract(target), "Address: call to non-contract");
480 
481         // solhint-disable-next-line avoid-low-level-calls
482         (bool success, bytes memory returndata) = target.call{ value: value }(data);
483         return _verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
488      * but performing a static call.
489      *
490      * _Available since v3.3._
491      */
492     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
493         return functionStaticCall(target, data, "Address: low-level static call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
498      * but performing a static call.
499      *
500      * _Available since v3.3._
501      */
502     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
503         require(isContract(target), "Address: static call to non-contract");
504 
505         // solhint-disable-next-line avoid-low-level-calls
506         (bool success, bytes memory returndata) = target.staticcall(data);
507         return _verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
527         require(isContract(target), "Address: delegate call to non-contract");
528 
529         // solhint-disable-next-line avoid-low-level-calls
530         (bool success, bytes memory returndata) = target.delegatecall(data);
531         return _verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
535         if (success) {
536             return returndata;
537         } else {
538             // Look for revert reason and bubble it up if present
539             if (returndata.length > 0) {
540                 // The easiest way to bubble the revert reason is using memory via assembly
541 
542                 // solhint-disable-next-line no-inline-assembly
543                 assembly {
544                     let returndata_size := mload(returndata)
545                     revert(add(32, returndata), returndata_size)
546                 }
547             } else {
548                 revert(errorMessage);
549             }
550         }
551     }
552 }
553 
554 
555 // File contracts/OpenZeppelin/utils/Context.sol
556 
557 pragma solidity 0.6.12;
558 
559 /*
560  * @dev Provides information about the current execution context, including the
561  * sender of the transaction and its data. While these are generally available
562  * via msg.sender and msg.data, they should not be accessed in such a direct
563  * manner, since when dealing with GSN meta-transactions the account sending and
564  * paying for execution may not be the actual sender (as far as an application
565  * is concerned).
566  *
567  * This contract is only required for intermediate, library-like contracts.
568  */
569 abstract contract Context {
570     function _msgSender() internal view virtual returns (address payable) {
571         return msg.sender;
572     }
573 
574     function _msgData() internal view virtual returns (bytes memory) {
575         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
576         return msg.data;
577     }
578 }
579 
580 
581 // File contracts/OpenZeppelin/access/AccessControl.sol
582 
583 pragma solidity 0.6.12;
584 
585 
586 
587 /**
588  * @dev Contract module that allows children to implement role-based access
589  * control mechanisms.
590  *
591  * Roles are referred to by their `bytes32` identifier. These should be exposed
592  * in the external API and be unique. The best way to achieve this is by
593  * using `public constant` hash digests:
594  *
595  * ```
596  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
597  * ```
598  *
599  * Roles can be used to represent a set of permissions. To restrict access to a
600  * function call, use {hasRole}:
601  *
602  * ```
603  * function foo() public {
604  *     require(hasRole(MY_ROLE, msg.sender));
605  *     ...
606  * }
607  * ```
608  *
609  * Roles can be granted and revoked dynamically via the {grantRole} and
610  * {revokeRole} functions. Each role has an associated admin role, and only
611  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
612  *
613  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
614  * that only accounts with this role will be able to grant or revoke other
615  * roles. More complex role relationships can be created by using
616  * {_setRoleAdmin}.
617  *
618  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
619  * grant and revoke this role. Extra precautions should be taken to secure
620  * accounts that have been granted it.
621  */
622 abstract contract AccessControl is Context {
623     using EnumerableSet for EnumerableSet.AddressSet;
624     using Address for address;
625 
626     struct RoleData {
627         EnumerableSet.AddressSet members;
628         bytes32 adminRole;
629     }
630 
631     mapping (bytes32 => RoleData) private _roles;
632 
633     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
634 
635     /**
636      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
637      *
638      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
639      * {RoleAdminChanged} not being emitted signaling this.
640      *
641      * _Available since v3.1._
642      */
643     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
644 
645     /**
646      * @dev Emitted when `account` is granted `role`.
647      *
648      * `sender` is the account that originated the contract call, an admin role
649      * bearer except when using {_setupRole}.
650      */
651     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
652 
653     /**
654      * @dev Emitted when `account` is revoked `role`.
655      *
656      * `sender` is the account that originated the contract call:
657      *   - if using `revokeRole`, it is the admin role bearer
658      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
659      */
660     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
661 
662     /**
663      * @dev Returns `true` if `account` has been granted `role`.
664      */
665     function hasRole(bytes32 role, address account) public view returns (bool) {
666         return _roles[role].members.contains(account);
667     }
668 
669     /**
670      * @dev Returns the number of accounts that have `role`. Can be used
671      * together with {getRoleMember} to enumerate all bearers of a role.
672      */
673     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
674         return _roles[role].members.length();
675     }
676 
677     /**
678      * @dev Returns one of the accounts that have `role`. `index` must be a
679      * value between 0 and {getRoleMemberCount}, non-inclusive.
680      *
681      * Role bearers are not sorted in any particular way, and their ordering may
682      * change at any point.
683      *
684      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
685      * you perform all queries on the same block. See the following
686      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
687      * for more information.
688      */
689     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
690         return _roles[role].members.at(index);
691     }
692 
693     /**
694      * @dev Returns the admin role that controls `role`. See {grantRole} and
695      * {revokeRole}.
696      *
697      * To change a role's admin, use {_setRoleAdmin}.
698      */
699     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
700         return _roles[role].adminRole;
701     }
702 
703     /**
704      * @dev Grants `role` to `account`.
705      *
706      * If `account` had not been already granted `role`, emits a {RoleGranted}
707      * event.
708      *
709      * Requirements:
710      *
711      * - the caller must have ``role``'s admin role.
712      */
713     function grantRole(bytes32 role, address account) public virtual {
714         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
715 
716         _grantRole(role, account);
717     }
718 
719     /**
720      * @dev Revokes `role` from `account`.
721      *
722      * If `account` had been granted `role`, emits a {RoleRevoked} event.
723      *
724      * Requirements:
725      *
726      * - the caller must have ``role``'s admin role.
727      */
728     function revokeRole(bytes32 role, address account) public virtual {
729         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
730 
731         _revokeRole(role, account);
732     }
733 
734     /**
735      * @dev Revokes `role` from the calling account.
736      *
737      * Roles are often managed via {grantRole} and {revokeRole}: this function's
738      * purpose is to provide a mechanism for accounts to lose their privileges
739      * if they are compromised (such as when a trusted device is misplaced).
740      *
741      * If the calling account had been granted `role`, emits a {RoleRevoked}
742      * event.
743      *
744      * Requirements:
745      *
746      * - the caller must be `account`.
747      */
748     function renounceRole(bytes32 role, address account) public virtual {
749         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
750 
751         _revokeRole(role, account);
752     }
753 
754     /**
755      * @dev Grants `role` to `account`.
756      *
757      * If `account` had not been already granted `role`, emits a {RoleGranted}
758      * event. Note that unlike {grantRole}, this function doesn't perform any
759      * checks on the calling account.
760      *
761      * [WARNING]
762      * ====
763      * This function should only be called from the constructor when setting
764      * up the initial roles for the system.
765      *
766      * Using this function in any other way is effectively circumventing the admin
767      * system imposed by {AccessControl}.
768      * ====
769      */
770     function _setupRole(bytes32 role, address account) internal virtual {
771         _grantRole(role, account);
772     }
773 
774     /**
775      * @dev Sets `adminRole` as ``role``'s admin role.
776      *
777      * Emits a {RoleAdminChanged} event.
778      */
779     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
780         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
781         _roles[role].adminRole = adminRole;
782     }
783 
784     function _grantRole(bytes32 role, address account) private {
785         if (_roles[role].members.add(account)) {
786             emit RoleGranted(role, account, _msgSender());
787         }
788     }
789 
790     function _revokeRole(bytes32 role, address account) private {
791         if (_roles[role].members.remove(account)) {
792             emit RoleRevoked(role, account, _msgSender());
793         }
794     }
795 }
796 
797 
798 // File contracts/Access/MISOAdminAccess.sol
799 
800 pragma solidity 0.6.12;
801 
802 contract MISOAdminAccess is AccessControl {
803 
804     /// @dev Whether access is initialised.
805     bool private initAccess;
806 
807     /// @notice Events for adding and removing various roles.
808     event AdminRoleGranted(
809         address indexed beneficiary,
810         address indexed caller
811     );
812 
813     event AdminRoleRemoved(
814         address indexed beneficiary,
815         address indexed caller
816     );
817 
818 
819     /// @notice The deployer is automatically given the admin role which will allow them to then grant roles to other addresses.
820     constructor() public {
821     }
822 
823     /**
824      * @notice Initializes access controls.
825      * @param _admin Admins address.
826      */
827     function initAccessControls(address _admin) public {
828         require(!initAccess, "Already initialised");
829         _setupRole(DEFAULT_ADMIN_ROLE, _admin);
830         initAccess = true;
831     }
832 
833     /////////////
834     // Lookups //
835     /////////////
836 
837     /**
838      * @notice Used to check whether an address has the admin role.
839      * @param _address EOA or contract being checked.
840      * @return bool True if the account has the role or false if it does not.
841      */
842     function hasAdminRole(address _address) public  view returns (bool) {
843         return hasRole(DEFAULT_ADMIN_ROLE, _address);
844     }
845 
846     ///////////////
847     // Modifiers //
848     ///////////////
849 
850     /**
851      * @notice Grants the admin role to an address.
852      * @dev The sender must have the admin role.
853      * @param _address EOA or contract receiving the new role.
854      */
855     function addAdminRole(address _address) external {
856         grantRole(DEFAULT_ADMIN_ROLE, _address);
857         emit AdminRoleGranted(_address, _msgSender());
858     }
859 
860     /**
861      * @notice Removes the admin role from an address.
862      * @dev The sender must have the admin role.
863      * @param _address EOA or contract affected.
864      */
865     function removeAdminRole(address _address) external {
866         revokeRole(DEFAULT_ADMIN_ROLE, _address);
867         emit AdminRoleRemoved(_address, _msgSender());
868     }
869 }
870 
871 
872 // File contracts/Access/MISOAccessControls.sol
873 
874 pragma solidity 0.6.12;
875 
876 /**
877  * @notice Access Controls
878  * @author Attr: BlockRocket.tech
879  */
880 contract MISOAccessControls is MISOAdminAccess {
881     /// @notice Role definitions
882     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
883     bytes32 public constant SMART_CONTRACT_ROLE = keccak256("SMART_CONTRACT_ROLE");
884     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
885 
886     /// @notice Events for adding and removing various roles
887 
888     event MinterRoleGranted(
889         address indexed beneficiary,
890         address indexed caller
891     );
892 
893     event MinterRoleRemoved(
894         address indexed beneficiary,
895         address indexed caller
896     );
897 
898     event OperatorRoleGranted(
899         address indexed beneficiary,
900         address indexed caller
901     );
902 
903     event OperatorRoleRemoved(
904         address indexed beneficiary,
905         address indexed caller
906     );
907 
908     event SmartContractRoleGranted(
909         address indexed beneficiary,
910         address indexed caller
911     );
912 
913     event SmartContractRoleRemoved(
914         address indexed beneficiary,
915         address indexed caller
916     );
917 
918     /**
919      * @notice The deployer is automatically given the admin role which will allow them to then grant roles to other addresses
920      */
921     constructor() public {
922     }
923 
924 
925     /////////////
926     // Lookups //
927     /////////////
928 
929     /**
930      * @notice Used to check whether an address has the minter role
931      * @param _address EOA or contract being checked
932      * @return bool True if the account has the role or false if it does not
933      */
934     function hasMinterRole(address _address) public view returns (bool) {
935         return hasRole(MINTER_ROLE, _address);
936     }
937 
938     /**
939      * @notice Used to check whether an address has the smart contract role
940      * @param _address EOA or contract being checked
941      * @return bool True if the account has the role or false if it does not
942      */
943     function hasSmartContractRole(address _address) public view returns (bool) {
944         return hasRole(SMART_CONTRACT_ROLE, _address);
945     }
946 
947     /**
948      * @notice Used to check whether an address has the operator role
949      * @param _address EOA or contract being checked
950      * @return bool True if the account has the role or false if it does not
951      */
952     function hasOperatorRole(address _address) public view returns (bool) {
953         return hasRole(OPERATOR_ROLE, _address);
954     }
955 
956     ///////////////
957     // Modifiers //
958     ///////////////
959 
960     /**
961      * @notice Grants the minter role to an address
962      * @dev The sender must have the admin role
963      * @param _address EOA or contract receiving the new role
964      */
965     function addMinterRole(address _address) external {
966         grantRole(MINTER_ROLE, _address);
967         emit MinterRoleGranted(_address, _msgSender());
968     }
969 
970     /**
971      * @notice Removes the minter role from an address
972      * @dev The sender must have the admin role
973      * @param _address EOA or contract affected
974      */
975     function removeMinterRole(address _address) external {
976         revokeRole(MINTER_ROLE, _address);
977         emit MinterRoleRemoved(_address, _msgSender());
978     }
979 
980     /**
981      * @notice Grants the smart contract role to an address
982      * @dev The sender must have the admin role
983      * @param _address EOA or contract receiving the new role
984      */
985     function addSmartContractRole(address _address) external {
986         grantRole(SMART_CONTRACT_ROLE, _address);
987         emit SmartContractRoleGranted(_address, _msgSender());
988     }
989 
990     /**
991      * @notice Removes the smart contract role from an address
992      * @dev The sender must have the admin role
993      * @param _address EOA or contract affected
994      */
995     function removeSmartContractRole(address _address) external {
996         revokeRole(SMART_CONTRACT_ROLE, _address);
997         emit SmartContractRoleRemoved(_address, _msgSender());
998     }
999 
1000     /**
1001      * @notice Grants the operator role to an address
1002      * @dev The sender must have the admin role
1003      * @param _address EOA or contract receiving the new role
1004      */
1005     function addOperatorRole(address _address) external {
1006         grantRole(OPERATOR_ROLE, _address);
1007         emit OperatorRoleGranted(_address, _msgSender());
1008     }
1009 
1010     /**
1011      * @notice Removes the operator role from an address
1012      * @dev The sender must have the admin role
1013      * @param _address EOA or contract affected
1014      */
1015     function removeOperatorRole(address _address) external {
1016         revokeRole(OPERATOR_ROLE, _address);
1017         emit OperatorRoleRemoved(_address, _msgSender());
1018     }
1019 
1020 }
1021 
1022 
1023 // File contracts/Utils/SafeTransfer.sol
1024 
1025 pragma solidity 0.6.12;
1026 
1027 contract SafeTransfer {
1028 
1029     address private constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1030 
1031     /// @dev Helper function to handle both ETH and ERC20 payments
1032     function _safeTokenPayment(
1033         address _token,
1034         address payable _to,
1035         uint256 _amount
1036     ) internal {
1037         if (address(_token) == ETH_ADDRESS) {
1038             _safeTransferETH(_to,_amount );
1039         } else {
1040             _safeTransfer(_token, _to, _amount);
1041         }
1042     }
1043 
1044 
1045     /// @dev Helper function to handle both ETH and ERC20 payments
1046     function _tokenPayment(
1047         address _token,
1048         address payable _to,
1049         uint256 _amount
1050     ) internal {
1051         if (address(_token) == ETH_ADDRESS) {
1052             _to.transfer(_amount);
1053         } else {
1054             _safeTransfer(_token, _to, _amount);
1055         }
1056     }
1057 
1058 
1059     /// @dev Transfer helper from UniswapV2 Router
1060     function _safeApprove(address token, address to, uint value) internal {
1061         // bytes4(keccak256(bytes('approve(address,uint256)')));
1062         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
1063         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
1064     }
1065 
1066 
1067     /**
1068      * There are many non-compliant ERC20 tokens... this can handle most, adapted from UniSwap V2
1069      * Im trying to make it a habit to put external calls last (reentrancy)
1070      * You can put this in an internal function if you like.
1071      */
1072     function _safeTransfer(
1073         address token,
1074         address to,
1075         uint256 amount
1076     ) internal virtual {
1077         // solium-disable-next-line security/no-low-level-calls
1078         (bool success, bytes memory data) =
1079             token.call(
1080                 // 0xa9059cbb = bytes4(keccak256("transfer(address,uint256)"))
1081                 abi.encodeWithSelector(0xa9059cbb, to, amount)
1082             );
1083         require(success && (data.length == 0 || abi.decode(data, (bool)))); // ERC20 Transfer failed
1084     }
1085 
1086     function _safeTransferFrom(
1087         address token,
1088         address from,
1089         uint256 amount
1090     ) internal virtual {
1091         // solium-disable-next-line security/no-low-level-calls
1092         (bool success, bytes memory data) =
1093             token.call(
1094                 // 0x23b872dd = bytes4(keccak256("transferFrom(address,address,uint256)"))
1095                 abi.encodeWithSelector(0x23b872dd, from, address(this), amount)
1096             );
1097         require(success && (data.length == 0 || abi.decode(data, (bool)))); // ERC20 TransferFrom failed
1098     }
1099 
1100     function _safeTransferFrom(address token, address from, address to, uint value) internal {
1101         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1102         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
1103         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
1104     }
1105 
1106     function _safeTransferETH(address to, uint value) internal {
1107         (bool success,) = to.call{value:value}(new bytes(0));
1108         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
1109     }
1110 
1111 
1112 }
1113 
1114 
1115 // File contracts/interfaces/IERC20.sol
1116 
1117 pragma solidity 0.6.12;
1118 
1119 interface IERC20 {
1120     function totalSupply() external view returns (uint256);
1121     function balanceOf(address account) external view returns (uint256);
1122     function allowance(address owner, address spender) external view returns (uint256);
1123     function approve(address spender, uint256 amount) external returns (bool);
1124     function name() external view returns (string memory);
1125     function symbol() external view returns (string memory);
1126     function decimals() external view returns (uint8);
1127 
1128     event Transfer(address indexed from, address indexed to, uint256 value);
1129     event Approval(address indexed owner, address indexed spender, uint256 value);
1130 
1131     function permit(
1132         address owner,
1133         address spender,
1134         uint256 value,
1135         uint256 deadline,
1136         uint8 v,
1137         bytes32 r,
1138         bytes32 s
1139     ) external;
1140 }
1141 
1142 
1143 // File contracts/Utils/BoringERC20.sol
1144 
1145 pragma solidity 0.6.12;
1146 
1147 // solhint-disable avoid-low-level-calls
1148 
1149 library BoringERC20 {
1150     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
1151     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
1152     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
1153     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
1154     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
1155 
1156     /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.
1157     /// @param token The address of the ERC-20 token contract.
1158     /// @return (string) Token symbol.
1159     function safeSymbol(IERC20 token) internal view returns (string memory) {
1160         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_SYMBOL));
1161         return success && data.length > 0 ? abi.decode(data, (string)) : "???";
1162     }
1163 
1164     /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.
1165     /// @param token The address of the ERC-20 token contract.
1166     /// @return (string) Token name.
1167     function safeName(IERC20 token) internal view returns (string memory) {
1168         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_NAME));
1169         return success && data.length > 0 ? abi.decode(data, (string)) : "???";
1170     }
1171 
1172     /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.
1173     /// @param token The address of the ERC-20 token contract.
1174     /// @return (uint8) Token decimals.
1175     function safeDecimals(IERC20 token) internal view returns (uint8) {
1176         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_DECIMALS));
1177         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
1178     }
1179 
1180     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
1181     /// Reverts on a failed transfer.
1182     /// @param token The address of the ERC-20 token.
1183     /// @param to Transfer tokens to.
1184     /// @param amount The token amount.
1185     function safeTransfer(
1186         IERC20 token,
1187         address to,
1188         uint256 amount
1189     ) internal {
1190         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
1191         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
1192     }
1193 
1194     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
1195     /// Reverts on a failed transfer.
1196     /// @param token The address of the ERC-20 token.
1197     /// @param from Transfer tokens from.
1198     /// @param to Transfer tokens to.
1199     /// @param amount The token amount.
1200     function safeTransferFrom(
1201         IERC20 token,
1202         address from,
1203         address to,
1204         uint256 amount
1205     ) internal {
1206         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
1207         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
1208     }
1209 }
1210 
1211 
1212 // File contracts/Utils/BoringBatchable.sol
1213 
1214 pragma solidity 0.6.12;
1215 pragma experimental ABIEncoderV2;
1216 
1217 // solhint-disable avoid-low-level-calls
1218 // solhint-disable no-inline-assembly
1219 
1220 // Audit on 5-Jan-2021 by Keno and BoringCrypto
1221 
1222 contract BaseBoringBatchable {
1223     /// @dev Helper function to extract a useful revert message from a failed call.
1224     /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.
1225     function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
1226         // If the _res length is less than 68, then the transaction failed silently (without a revert message)
1227         if (_returnData.length < 68) return "Transaction reverted silently";
1228 
1229         assembly {
1230             // Slice the sighash.
1231             _returnData := add(_returnData, 0x04)
1232         }
1233         return abi.decode(_returnData, (string)); // All that remains is the revert string
1234     }
1235 
1236     /// @notice Allows batched call to self (this contract).
1237     /// @param calls An array of inputs for each call.
1238     /// @param revertOnFail If True then reverts after a failed call and stops doing further calls.
1239     /// @return successes An array indicating the success of a call, mapped one-to-one to `calls`.
1240     /// @return results An array with the returned data of each function call, mapped one-to-one to `calls`.
1241     // F1: External is ok here because this is the batch function, adding it to a batch makes no sense
1242     // F2: Calls in the batch may be payable, delegatecall operates in the same context, so each call in the batch has access to msg.value
1243     // C3: The length of the loop is fully under user control, so can't be exploited
1244     // C7: Delegatecall is only used on the same contract, so it's safe
1245     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results) {
1246         successes = new bool[](calls.length);
1247         results = new bytes[](calls.length);
1248         for (uint256 i = 0; i < calls.length; i++) {
1249             (bool success, bytes memory result) = address(this).delegatecall(calls[i]);
1250             require(success || !revertOnFail, _getRevertMsg(result));
1251             successes[i] = success;
1252             results[i] = result;
1253         }
1254     }
1255 }
1256 
1257 contract BoringBatchable is BaseBoringBatchable {
1258     /// @notice Call wrapper that performs `ERC20.permit` on `token`.
1259     /// Lookup `IERC20.permit`.
1260     // F6: Parameters can be used front-run the permit and the user's permit will fail (due to nonce or other revert)
1261     //     if part of a batch this could be used to grief once as the second call would not need the permit
1262     function permitToken(
1263         IERC20 token,
1264         address from,
1265         address to,
1266         uint256 amount,
1267         uint256 deadline,
1268         uint8 v,
1269         bytes32 r,
1270         bytes32 s
1271     ) public {
1272         token.permit(from, to, amount, deadline, v, r, s);
1273     }
1274 }
1275 
1276 
1277 // File contracts/Utils/BoringMath.sol
1278 
1279 pragma solidity 0.6.12;
1280 
1281 /// @notice A library for performing overflow-/underflow-safe math,
1282 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
1283 library BoringMath {
1284     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1285         require((c = a + b) >= b, "BoringMath: Add Overflow");
1286     }
1287 
1288     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
1289         require((c = a - b) <= a, "BoringMath: Underflow");
1290     }
1291 
1292     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1293         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
1294     }
1295 
1296     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
1297         require(b > 0, "BoringMath: Div zero");
1298         c = a / b;
1299     }
1300 
1301     function to128(uint256 a) internal pure returns (uint128 c) {
1302         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
1303         c = uint128(a);
1304     }
1305 
1306     function to64(uint256 a) internal pure returns (uint64 c) {
1307         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
1308         c = uint64(a);
1309     }
1310 
1311     function to32(uint256 a) internal pure returns (uint32 c) {
1312         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
1313         c = uint32(a);
1314     }
1315 
1316     function to16(uint256 a) internal pure returns (uint16 c) {
1317         require(a <= uint16(-1), "BoringMath: uint16 Overflow");
1318         c = uint16(a);
1319     }
1320 
1321 }
1322 
1323 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
1324 library BoringMath128 {
1325     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
1326         require((c = a + b) >= b, "BoringMath: Add Overflow");
1327     }
1328 
1329     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
1330         require((c = a - b) <= a, "BoringMath: Underflow");
1331     }
1332 }
1333 
1334 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
1335 library BoringMath64 {
1336     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
1337         require((c = a + b) >= b, "BoringMath: Add Overflow");
1338     }
1339 
1340     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
1341         require((c = a - b) <= a, "BoringMath: Underflow");
1342     }
1343 }
1344 
1345 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
1346 library BoringMath32 {
1347     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
1348         require((c = a + b) >= b, "BoringMath: Add Overflow");
1349     }
1350 
1351     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
1352         require((c = a - b) <= a, "BoringMath: Underflow");
1353     }
1354 }
1355 
1356 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
1357 library BoringMath16 {
1358     function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
1359         require((c = a + b) >= b, "BoringMath: Add Overflow");
1360     }
1361 
1362     function sub(uint16 a, uint16 b) internal pure returns (uint16 c) {
1363         require((c = a - b) <= a, "BoringMath: Underflow");
1364     }
1365 }
1366 
1367 
1368 // File contracts/Utils/Documents.sol
1369 
1370 pragma solidity 0.6.12;
1371 
1372 
1373 /**
1374  * @title Standard implementation of ERC1643 Document management
1375  */
1376 contract Documents {
1377 
1378     struct Document {
1379         uint32 docIndex;    // Store the document name indexes
1380         uint64 lastModified; // Timestamp at which document details was last modified
1381         string data; // data of the document that exist off-chain
1382     }
1383 
1384     // mapping to store the documents details in the document
1385     mapping(string => Document) internal _documents;
1386     // mapping to store the document name indexes
1387     mapping(string => uint32) internal _docIndexes;
1388     // Array use to store all the document name present in the contracts
1389     string[] _docNames;
1390 
1391     // Document Events
1392     event DocumentRemoved(string indexed _name, string _data);
1393     event DocumentUpdated(string indexed _name, string _data);
1394 
1395     /**
1396      * @notice Used to attach a new document to the contract, or update the data or hash of an existing attached document
1397      * @dev Can only be executed by the owner of the contract.
1398      * @param _name Name of the document. It should be unique always
1399      * @param _data Off-chain data of the document from where it is accessible to investors/advisors to read.
1400      */
1401     function _setDocument(string calldata _name, string calldata _data) internal {
1402         require(bytes(_name).length > 0, "Zero name is not allowed");
1403         require(bytes(_data).length > 0, "Should not be a empty data");
1404         // Document storage document = _documents[_name];
1405         if (_documents[_name].lastModified == uint64(0)) {
1406             _docNames.push(_name);
1407             _documents[_name].docIndex = uint32(_docNames.length);
1408         }
1409         _documents[_name] = Document(_documents[_name].docIndex, uint64(now), _data);
1410         emit DocumentUpdated(_name, _data);
1411     }
1412 
1413     /**
1414      * @notice Used to remove an existing document from the contract by giving the name of the document.
1415      * @dev Can only be executed by the owner of the contract.
1416      * @param _name Name of the document. It should be unique always
1417      */
1418 
1419     function _removeDocument(string calldata _name) internal {
1420         require(_documents[_name].lastModified != uint64(0), "Document should exist");
1421         uint32 index = _documents[_name].docIndex - 1;
1422         if (index != _docNames.length - 1) {
1423             _docNames[index] = _docNames[_docNames.length - 1];
1424             _documents[_docNames[index]].docIndex = index + 1; 
1425         }
1426         _docNames.pop();
1427         emit DocumentRemoved(_name, _documents[_name].data);
1428         delete _documents[_name];
1429     }
1430 
1431     /**
1432      * @notice Used to return the details of a document with a known name (`string`).
1433      * @param _name Name of the document
1434      * @return string The data associated with the document.
1435      * @return uint256 the timestamp at which the document was last modified.
1436      */
1437     function getDocument(string calldata _name) external view returns (string memory, uint256) {
1438         return (
1439             _documents[_name].data,
1440             uint256(_documents[_name].lastModified)
1441         );
1442     }
1443 
1444     /**
1445      * @notice Used to retrieve a full list of documents attached to the smart contract.
1446      * @return string List of all documents names present in the contract.
1447      */
1448     function getAllDocuments() external view returns (string[] memory) {
1449         return _docNames;
1450     }
1451 
1452     /**
1453      * @notice Used to retrieve the total documents in the smart contract.
1454      * @return uint256 Count of the document names present in the contract.
1455      */
1456     function getDocumentCount() external view returns (uint256) {
1457         return _docNames.length;
1458     }
1459 
1460     /**
1461      * @notice Used to retrieve the document name from index in the smart contract.
1462      * @return string Name of the document name.
1463      */
1464     function getDocumentName(uint256 _index) external view returns (string memory) {
1465         require(_index < _docNames.length, "Index out of bounds");
1466         return _docNames[_index];
1467     }
1468 
1469 }
1470 
1471 
1472 // File contracts/interfaces/IPointList.sol
1473 
1474 pragma solidity 0.6.12;
1475 
1476 // ----------------------------------------------------------------------------
1477 // White List interface
1478 // ----------------------------------------------------------------------------
1479 
1480 interface IPointList {
1481     function isInList(address account) external view returns (bool);
1482     function hasPoints(address account, uint256 amount) external view  returns (bool);
1483     function setPoints(
1484         address[] memory accounts,
1485         uint256[] memory amounts
1486     ) external; 
1487     function initPointList(address accessControl) external ;
1488 
1489 }
1490 
1491 
1492 // File contracts/interfaces/IMisoMarket.sol
1493 
1494 pragma solidity 0.6.12;
1495 
1496 interface IMisoMarket {
1497 
1498     function init(bytes calldata data) external payable;
1499     function initMarket( bytes calldata data ) external;
1500     function marketTemplate() external view returns (uint256);
1501 
1502 }
1503 
1504 
1505 // File contracts/Auctions/BatchAuction.sol
1506 
1507 pragma solidity 0.6.12;
1508 
1509 //----------------------------------------------------------------------------------
1510 //    I n s t a n t
1511 //
1512 //        .:mmm.         .:mmm:.       .ii.  .:SSSSSSSSSSSSS.     .oOOOOOOOOOOOo.  
1513 //      .mMM'':Mm.     .:MM'':Mm:.     .II:  :SSs..........     .oOO'''''''''''OOo.
1514 //    .:Mm'   ':Mm.   .:Mm'   'MM:.    .II:  'sSSSSSSSSSSSSS:.  :OO.           .OO:
1515 //  .'mMm'     ':MM:.:MMm'     ':MM:.  .II:  .:...........:SS.  'OOo:.........:oOO'
1516 //  'mMm'        ':MMmm'         'mMm:  II:  'sSSSSSSSSSSSSS'     'oOOOOOOOOOOOO'  
1517 //
1518 //----------------------------------------------------------------------------------
1519 //
1520 // Chef Gonpachi's Batch Auction
1521 //
1522 // An auction where contributions are swaped for a batch of tokens pro-rata
1523 // 
1524 // This program is free software: you can redistribute it and/or modify
1525 // it under the terms of the GNU General Public License as published by
1526 // the Free Software Foundation, either version 3 of the License
1527 //
1528 // This program is distributed in the hope that it will be useful,
1529 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1530 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1531 // GNU General Public License for more details.
1532 //
1533 // The above copyright notice and this permission notice shall be included 
1534 // in all copies or substantial portions of the Software.
1535 //
1536 // Made for Sushi.com 
1537 // 
1538 // Enjoy. (c) Chef Gonpachi, Kusatoshi, SSMikazu 2021 
1539 // <https://github.com/chefgonpachi/MISO/>
1540 //
1541 // ---------------------------------------------------------------------
1542 // SPDX-License-Identifier: GPL-3.0                        
1543 // ---------------------------------------------------------------------
1544 
1545 
1546 
1547 
1548 
1549 
1550 
1551 
1552 
1553 /// @notice Attribution to delta.financial
1554 /// @notice Attribution to dutchswap.com
1555 
1556 
1557 contract BatchAuction is  IMisoMarket, MISOAccessControls, BoringBatchable, SafeTransfer, Documents, ReentrancyGuard  {
1558 
1559     using BoringMath for uint256;
1560     using BoringMath128 for uint128;
1561     using BoringMath64 for uint64;
1562     using BoringERC20 for IERC20;
1563 
1564     /// @notice MISOMarket template id for the factory contract.
1565     /// @dev For different marketplace types, this must be incremented.
1566     uint256 public constant override marketTemplate = 3;
1567 
1568     /// @dev The multiplier for decimal precision
1569     uint256 private constant MISO_PRECISION = 1e18;
1570 
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
1582     /// @notice Market dynamic variables.
1583     struct MarketStatus {
1584         uint128 commitmentsTotal;
1585         uint128 minimumCommitmentAmount;
1586         bool finalized;
1587         bool usePointList;
1588     }
1589 
1590     MarketStatus public marketStatus;
1591 
1592     address public auctionToken;
1593     /// @notice The currency the crowdsale accepts for payment. Can be ETH or token address.
1594     address public paymentCurrency;
1595     /// @notice Address that manages auction approvals.
1596     address public pointList;
1597     address payable public wallet; // Where the auction funds will get paid
1598 
1599     mapping(address => uint256) public commitments;
1600     /// @notice Amount of tokens to claim per address.
1601     mapping(address => uint256) public claimed;
1602 
1603     /// @notice Event for updating auction times.  Needs to be before auction starts.
1604     event AuctionTimeUpdated(uint256 startTime, uint256 endTime); 
1605     /// @notice Event for updating auction prices. Needs to be before auction starts.
1606     event AuctionPriceUpdated(uint256 minimumCommitmentAmount); 
1607     /// @notice Event for updating auction wallet. Needs to be before auction starts.
1608     event AuctionWalletUpdated(address wallet); 
1609 
1610     /// @notice Event for adding a commitment.
1611     event AddedCommitment(address addr, uint256 commitment);
1612     /// @notice Event for finalization of the auction.
1613     event AuctionFinalized();
1614     /// @notice Event for cancellation of the auction.
1615     event AuctionCancelled();
1616 
1617     /**
1618      * @notice Initializes main contract variables and transfers funds for the auction.
1619      * @dev Init function.
1620      * @param _funder The address that funds the token for crowdsale.
1621      * @param _token Address of the token being sold.
1622      * @param _totalTokens The total number of tokens to sell in auction.
1623      * @param _startTime Auction start time.
1624      * @param _endTime Auction end time.
1625      * @param _paymentCurrency The currency the crowdsale accepts for payment. Can be ETH or token address.
1626      * @param _minimumCommitmentAmount Minimum amount collected at which the auction will be successful.
1627      * @param _admin Address that can finalize auction.
1628      * @param _wallet Address where collected funds will be forwarded to.
1629      */
1630     function initAuction(
1631         address _funder,
1632         address _token,
1633         uint256 _totalTokens,
1634         uint256 _startTime,
1635         uint256 _endTime,
1636         address _paymentCurrency,
1637         uint256 _minimumCommitmentAmount,
1638         address _admin,
1639         address _pointList,
1640         address payable _wallet
1641     ) public {
1642         require(_startTime < 10000000000, "BatchAuction: enter an unix timestamp in seconds, not miliseconds");
1643         require(_endTime < 10000000000, "BatchAuction: enter an unix timestamp in seconds, not miliseconds");
1644         require(_startTime >= block.timestamp, "BatchAuction: start time is before current time");
1645         require(_endTime > _startTime, "BatchAuction: end time must be older than start time");
1646         require(_totalTokens > 0,"BatchAuction: total tokens must be greater than zero");
1647         require(_admin != address(0), "BatchAuction: admin is the zero address");
1648         require(_wallet != address(0), "BatchAuction: wallet is the zero address");
1649         require(IERC20(_token).decimals() == 18, "BatchAuction: Token does not have 18 decimals");
1650         if (_paymentCurrency != ETH_ADDRESS) {
1651             require(IERC20(_paymentCurrency).decimals() > 0, "BatchAuction: Payment currency is not ERC20");
1652         }
1653 
1654         marketStatus.minimumCommitmentAmount = BoringMath.to128(_minimumCommitmentAmount);
1655         
1656         marketInfo.startTime = BoringMath.to64(_startTime);
1657         marketInfo.endTime = BoringMath.to64(_endTime);
1658         marketInfo.totalTokens = BoringMath.to128(_totalTokens);
1659 
1660         auctionToken = _token;
1661         paymentCurrency = _paymentCurrency;
1662         wallet = _wallet;
1663 
1664         initAccessControls(_admin);
1665 
1666         _setList(_pointList);
1667         _safeTransferFrom(auctionToken, _funder, _totalTokens);
1668     }
1669 
1670 
1671     ///--------------------------------------------------------
1672     /// Commit to buying tokens!
1673     ///--------------------------------------------------------
1674 
1675     receive() external payable {
1676         revertBecauseUserDidNotProvideAgreement();
1677     }
1678     
1679     /** 
1680      * @dev Attribution to the awesome delta.financial contracts
1681     */  
1682     function marketParticipationAgreement() public pure returns (string memory) {
1683         return "I understand that I am interacting with a smart contract. I understand that tokens commited are subject to the token issuer and local laws where applicable. I have reviewed the code of this smart contract and understand it fully. I agree to not hold developers or other people associated with the project liable for any losses or misunderstandings";
1684     }
1685     /** 
1686      * @dev Not using modifiers is a purposeful choice for code readability.
1687     */ 
1688     function revertBecauseUserDidNotProvideAgreement() internal pure {
1689         revert("No agreement provided, please review the smart contract before interacting with it");
1690     }
1691 
1692     /**
1693      * @notice Commit ETH to buy tokens on auction.
1694      * @param _beneficiary Auction participant ETH address.
1695      */
1696     function commitEth(address payable _beneficiary, bool readAndAgreedToMarketParticipationAgreement) public payable {
1697         require(paymentCurrency == ETH_ADDRESS, "BatchAuction: payment currency is not ETH");
1698 
1699         require(msg.value > 0, "BatchAuction: Value must be higher than 0");
1700         if(readAndAgreedToMarketParticipationAgreement == false) {
1701             revertBecauseUserDidNotProvideAgreement();
1702         }
1703         _addCommitment(_beneficiary, msg.value);
1704     }
1705 
1706     /**
1707      * @notice Buy Tokens by commiting approved ERC20 tokens to this contract address.
1708      * @param _amount Amount of tokens to commit.
1709      */
1710     function commitTokens(uint256 _amount, bool readAndAgreedToMarketParticipationAgreement) public {
1711         commitTokensFrom(msg.sender, _amount, readAndAgreedToMarketParticipationAgreement);
1712     }
1713 
1714     /**
1715      * @notice Checks if amout not 0 and makes the transfer and adds commitment.
1716      * @dev Users must approve contract prior to committing tokens to auction.
1717      * @param _from User ERC20 address.
1718      * @param _amount Amount of approved ERC20 tokens.
1719      */
1720     function commitTokensFrom(address _from, uint256 _amount, bool readAndAgreedToMarketParticipationAgreement) public   nonReentrant  {
1721         require(paymentCurrency != ETH_ADDRESS, "BatchAuction: Payment currency is not a token");
1722         if(readAndAgreedToMarketParticipationAgreement == false) {
1723             revertBecauseUserDidNotProvideAgreement();
1724         }
1725         require(_amount> 0, "BatchAuction: Value must be higher than 0");
1726         _safeTransferFrom(paymentCurrency, msg.sender, _amount);
1727         _addCommitment(_from, _amount);
1728 
1729     }
1730 
1731 
1732     /// @notice Commits to an amount during an auction
1733     /**
1734      * @notice Updates commitment for this address and total commitment of the auction.
1735      * @param _addr Auction participant address.
1736      * @param _commitment The amount to commit.
1737      */
1738     function _addCommitment(address _addr, uint256 _commitment) internal {
1739         require(block.timestamp >= marketInfo.startTime && block.timestamp <= marketInfo.endTime, "BatchAuction: outside auction hours"); 
1740 
1741         uint256 newCommitment = commitments[_addr].add(_commitment);
1742         if (marketStatus.usePointList) {
1743             require(IPointList(pointList).hasPoints(_addr, newCommitment));
1744         }
1745         commitments[_addr] = newCommitment;
1746         marketStatus.commitmentsTotal = BoringMath.to128(uint256(marketStatus.commitmentsTotal).add(_commitment));
1747         emit AddedCommitment(_addr, _commitment);
1748     }
1749 
1750     /**
1751      * @notice Calculates amount of auction tokens for user to receive.
1752      * @param amount Amount of tokens to commit.
1753      * @return Auction token amount.
1754      */
1755     function _getTokenAmount(uint256 amount) internal view returns (uint256) { 
1756         if (marketStatus.commitmentsTotal == 0) return 0;
1757         return amount.mul(uint256(marketInfo.totalTokens)).div(uint256(marketStatus.commitmentsTotal));
1758     }
1759 
1760     /**
1761      * @notice Calculates the price of each token from all commitments.
1762      * @return Token price.
1763      */
1764     function tokenPrice() public view returns (uint256) {
1765         return uint256(marketStatus.commitmentsTotal).mul(MISO_PRECISION)
1766             .mul(1e18).div(uint256(marketInfo.totalTokens)).div(MISO_PRECISION);
1767     }
1768 
1769 
1770     ///--------------------------------------------------------
1771     /// Finalize Auction
1772     ///--------------------------------------------------------
1773 
1774     /// @notice Auction finishes successfully above the reserve
1775     /// @dev Transfer contract funds to initialized wallet.
1776     function finalize() public    nonReentrant 
1777     {
1778         require(hasAdminRole(msg.sender) 
1779                 || wallet == msg.sender
1780                 || hasSmartContractRole(msg.sender) 
1781                 || finalizeTimeExpired(),  "BatchAuction: Sender must be admin");
1782         require(!marketStatus.finalized, "BatchAuction: Auction has already finalized");
1783         require(block.timestamp > marketInfo.endTime, "BatchAuction: Auction has not finished yet");
1784         if (auctionSuccessful()) {
1785             /// @dev Successful auction
1786             /// @dev Transfer contributed tokens to wallet.
1787             _safeTokenPayment(paymentCurrency, wallet, uint256(marketStatus.commitmentsTotal));
1788         } else {
1789             /// @dev Failed auction
1790             /// @dev Return auction tokens back to wallet.
1791             require(block.timestamp > marketInfo.endTime, "BatchAuction: Auction has not finished yet");
1792             _safeTokenPayment(auctionToken, wallet, marketInfo.totalTokens);
1793         }
1794         marketStatus.finalized = true;
1795         emit AuctionFinalized();
1796     }
1797 
1798     /**
1799      * @notice Cancel Auction
1800      * @dev Admin can cancel the auction before it starts
1801      */
1802     function cancelAuction() public   nonReentrant  
1803     {
1804         require(hasAdminRole(msg.sender));
1805         MarketStatus storage status = marketStatus;
1806         require(!status.finalized, "Crowdsale: already finalized");
1807         require( uint256(status.commitmentsTotal) == 0, "Crowdsale: Funds already raised" );
1808 
1809         _safeTokenPayment(auctionToken, wallet, uint256(marketInfo.totalTokens));
1810 
1811         status.finalized = true;
1812         emit AuctionCancelled();
1813     }
1814 
1815     /// @notice Withdraws bought tokens, or returns commitment if the sale is unsuccessful.
1816     function withdrawTokens() public  {
1817         withdrawTokens(msg.sender);
1818     }
1819 
1820     /// @notice Withdraw your tokens once the Auction has ended.
1821     function withdrawTokens(address payable beneficiary) public   nonReentrant  {
1822         if (auctionSuccessful()) {
1823             require(marketStatus.finalized, "BatchAuction: not finalized");
1824             /// @dev Successful auction! Transfer claimed tokens.
1825             uint256 tokensToClaim = tokensClaimable(beneficiary);
1826             require(tokensToClaim > 0, "BatchAuction: No tokens to claim");
1827             claimed[beneficiary] = claimed[beneficiary].add(tokensToClaim);
1828 
1829             _safeTokenPayment(auctionToken, beneficiary, tokensToClaim);
1830         } else {
1831             /// @dev Auction did not meet reserve price.
1832             /// @dev Return committed funds back to user.
1833             require(block.timestamp > marketInfo.endTime, "BatchAuction: Auction has not finished yet");
1834             uint256 fundsCommitted = commitments[beneficiary];
1835             require(fundsCommitted > 0, "BatchAuction: No funds committed");
1836             commitments[beneficiary] = 0; // Stop multiple withdrawals and free some gas
1837             _safeTokenPayment(paymentCurrency, beneficiary, fundsCommitted);
1838         }
1839     }
1840 
1841 
1842     /**
1843      * @notice How many tokens the user is able to claim.
1844      * @param _user Auction participant address.
1845      * @return claimerCommitment Tokens left to claim.
1846      */
1847     function tokensClaimable(address _user) public view returns (uint256 claimerCommitment) {
1848         if (commitments[_user] == 0) return 0;
1849         uint256 unclaimedTokens = IERC20(auctionToken).balanceOf(address(this));
1850         claimerCommitment = _getTokenAmount(commitments[_user]);
1851         claimerCommitment = claimerCommitment.sub(claimed[_user]);
1852 
1853         if(claimerCommitment > unclaimedTokens){
1854             claimerCommitment = unclaimedTokens;
1855         }
1856     }
1857 
1858     /**
1859      * @notice Checks if raised more than minimum amount.
1860      * @return True if tokens sold greater than or equals to the minimum commitment amount.
1861      */
1862     function auctionSuccessful() public view returns (bool) {
1863         return uint256(marketStatus.commitmentsTotal) >= uint256(marketStatus.minimumCommitmentAmount) && uint256(marketStatus.commitmentsTotal) > 0;
1864     }
1865 
1866     /**
1867      * @notice Checks if the auction has ended.
1868      * @return bool True if current time is greater than auction end time.
1869      */
1870     function auctionEnded() public view returns (bool) {
1871         return block.timestamp > marketInfo.endTime;
1872     }
1873 
1874     /**
1875      * @notice Checks if the auction has been finalised.
1876      * @return bool True if auction has been finalised.
1877      */
1878     function finalized() public view returns (bool) {
1879         return marketStatus.finalized;
1880     }
1881 
1882     /// @notice Returns true if 7 days have passed since the end of the auction
1883     function finalizeTimeExpired() public view returns (bool) {
1884         return uint256(marketInfo.endTime) + 7 days < block.timestamp;
1885     }
1886 
1887 
1888     //--------------------------------------------------------
1889     // Documents
1890     //--------------------------------------------------------
1891 
1892     function setDocument(string calldata _name, string calldata _data) external {
1893         require(hasAdminRole(msg.sender) );
1894         _setDocument( _name, _data);
1895     }
1896 
1897     function setDocuments(string[] calldata _name, string[] calldata _data) external {
1898         require(hasAdminRole(msg.sender) );
1899         uint256 numDocs = _name.length;
1900         for (uint256 i = 0; i < numDocs; i++) {
1901             _setDocument( _name[i], _data[i]);
1902         }
1903     }
1904 
1905     function removeDocument(string calldata _name) external {
1906         require(hasAdminRole(msg.sender));
1907         _removeDocument(_name);
1908     }
1909 
1910 
1911     //--------------------------------------------------------
1912     // Point Lists
1913     //--------------------------------------------------------
1914 
1915 
1916     function setList(address _list) external {
1917         require(hasAdminRole(msg.sender));
1918         _setList(_list);
1919     }
1920 
1921     function enableList(bool _status) external {
1922         require(hasAdminRole(msg.sender));
1923         marketStatus.usePointList = _status;
1924     }
1925 
1926     function _setList(address _pointList) private {
1927         if (_pointList != address(0)) {
1928             pointList = _pointList;
1929             marketStatus.usePointList = true;
1930         }
1931     }
1932 
1933     //--------------------------------------------------------
1934     // Setter Functions
1935     //--------------------------------------------------------
1936 
1937     /**
1938      * @notice Admin can set start and end time through this function.
1939      * @param _startTime Auction start time.
1940      * @param _endTime Auction end time.
1941      */
1942     function setAuctionTime(uint256 _startTime, uint256 _endTime) external {
1943         require(hasAdminRole(msg.sender));
1944         require(_startTime < 10000000000, "BatchAuction: enter an unix timestamp in seconds, not miliseconds");
1945         require(_endTime < 10000000000, "BatchAuction: enter an unix timestamp in seconds, not miliseconds");
1946         require(_startTime >= block.timestamp, "BatchAuction: start time is before current time");
1947         require(_endTime > _startTime, "BatchAuction: end time must be older than start price");
1948 
1949         require(marketStatus.commitmentsTotal == 0, "BatchAuction: auction cannot have already started");
1950 
1951         marketInfo.startTime = BoringMath.to64(_startTime);
1952         marketInfo.endTime = BoringMath.to64(_endTime);
1953         
1954         emit AuctionTimeUpdated(_startTime,_endTime);
1955     }
1956 
1957     /**
1958      * @notice Admin can set start and min price through this function.
1959      * @param _minimumCommitmentAmount Auction minimum raised target.
1960      */
1961     function setAuctionPrice(uint256 _minimumCommitmentAmount) external {
1962         require(hasAdminRole(msg.sender));
1963 
1964         require(marketStatus.commitmentsTotal == 0, "BatchAuction: auction cannot have already started");
1965 
1966         marketStatus.minimumCommitmentAmount = BoringMath.to128(_minimumCommitmentAmount);
1967 
1968         emit AuctionPriceUpdated(_minimumCommitmentAmount);
1969     }
1970 
1971     /**
1972      * @notice Admin can set the auction wallet through this function.
1973      * @param _wallet Auction wallet is where funds will be sent.
1974      */
1975     function setAuctionWallet(address payable _wallet) external {
1976         require(hasAdminRole(msg.sender));
1977         require(_wallet != address(0), "BatchAuction: wallet is the zero address");
1978 
1979         wallet = _wallet;
1980 
1981         emit AuctionWalletUpdated(_wallet);
1982     }
1983 
1984 
1985     //--------------------------------------------------------
1986     // Market Launchers
1987     //--------------------------------------------------------
1988 
1989     function init(bytes calldata _data) external override payable {
1990     }
1991 
1992     function initMarket(
1993         bytes calldata _data
1994     ) public override {
1995         (
1996         address _funder,
1997         address _token,
1998         uint256 _totalTokens,
1999         uint256 _startTime,
2000         uint256 _endTime,
2001         address _paymentCurrency,
2002         uint256 _minimumCommitmentAmount,
2003         address _admin,
2004         address _pointList,
2005         address payable _wallet
2006         ) = abi.decode(_data, (
2007             address,
2008             address,
2009             uint256,
2010             uint256,
2011             uint256,
2012             address,
2013             uint256,
2014             address,
2015             address,
2016             address
2017         ));
2018         initAuction(_funder, _token, _totalTokens, _startTime, _endTime, _paymentCurrency, _minimumCommitmentAmount, _admin, _pointList,  _wallet);
2019     }
2020 
2021      function getBatchAuctionInitData(
2022        address _funder,
2023         address _token,
2024         uint256 _totalTokens,
2025         uint256 _startTime,
2026         uint256 _endTime,
2027         address _paymentCurrency,
2028         uint256 _minimumCommitmentAmount,
2029         address _admin,
2030         address _pointList,
2031         address payable _wallet
2032     )
2033         external
2034         pure
2035         returns (bytes memory _data)
2036     {
2037         return abi.encode(
2038             _funder,
2039             _token,
2040             _totalTokens,
2041             _startTime,
2042             _endTime,
2043             _paymentCurrency,
2044             _minimumCommitmentAmount,
2045             _admin,
2046             _pointList,
2047             _wallet
2048             );
2049     }
2050 
2051     function getBaseInformation() external view returns(
2052         address token, 
2053         uint64 startTime,
2054         uint64 endTime,
2055         bool marketFinalized
2056     ) {
2057         return (auctionToken, marketInfo.startTime, marketInfo.endTime, marketStatus.finalized);
2058     }
2059 
2060     function getTotalTokens() external view returns(uint256) {
2061         return uint256(marketInfo.totalTokens);
2062     }
2063 
2064 }