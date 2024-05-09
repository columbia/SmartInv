1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.11;
4 
5 
6 // 
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
28  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
29  * (`UintSet`) are supported.
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
137     // AddressSet
138 
139     struct AddressSet {
140         Set _inner;
141     }
142 
143     /**
144      * @dev Add a value to a set. O(1).
145      *
146      * Returns true if the value was added to the set, that is if it was not
147      * already present.
148      */
149     function add(AddressSet storage set, address value) internal returns (bool) {
150         return _add(set._inner, bytes32(uint256(value)));
151     }
152 
153     /**
154      * @dev Removes a value from a set. O(1).
155      *
156      * Returns true if the value was removed from the set, that is if it was
157      * present.
158      */
159     function remove(AddressSet storage set, address value) internal returns (bool) {
160         return _remove(set._inner, bytes32(uint256(value)));
161     }
162 
163     /**
164      * @dev Returns true if the value is in the set. O(1).
165      */
166     function contains(AddressSet storage set, address value) internal view returns (bool) {
167         return _contains(set._inner, bytes32(uint256(value)));
168     }
169 
170     /**
171      * @dev Returns the number of values in the set. O(1).
172      */
173     function length(AddressSet storage set) internal view returns (uint256) {
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
187     function at(AddressSet storage set, uint256 index) internal view returns (address) {
188         return address(uint256(_at(set._inner, index)));
189     }
190 
191 
192     // UintSet
193 
194     struct UintSet {
195         Set _inner;
196     }
197 
198     /**
199      * @dev Add a value to a set. O(1).
200      *
201      * Returns true if the value was added to the set, that is if it was not
202      * already present.
203      */
204     function add(UintSet storage set, uint256 value) internal returns (bool) {
205         return _add(set._inner, bytes32(value));
206     }
207 
208     /**
209      * @dev Removes a value from a set. O(1).
210      *
211      * Returns true if the value was removed from the set, that is if it was
212      * present.
213      */
214     function remove(UintSet storage set, uint256 value) internal returns (bool) {
215         return _remove(set._inner, bytes32(value));
216     }
217 
218     /**
219      * @dev Returns true if the value is in the set. O(1).
220      */
221     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
222         return _contains(set._inner, bytes32(value));
223     }
224 
225     /**
226      * @dev Returns the number of values on the set. O(1).
227      */
228     function length(UintSet storage set) internal view returns (uint256) {
229         return _length(set._inner);
230     }
231 
232    /**
233     * @dev Returns the value stored at position `index` in the set. O(1).
234     *
235     * Note that there are no guarantees on the ordering of values inside the
236     * array, and it may change when more values are added or removed.
237     *
238     * Requirements:
239     *
240     * - `index` must be strictly less than {length}.
241     */
242     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
243         return uint256(_at(set._inner, index));
244     }
245 }
246 
247 // 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272         // for accounts without code, i.e. `keccak256('')`
273         bytes32 codehash;
274         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { codehash := extcodehash(account) }
277         return (codehash != accountHash && codehash != 0x0);
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 // 
387 /*
388  * @dev Provides information about the current execution context, including the
389  * sender of the transaction and its data. While these are generally available
390  * via msg.sender and msg.data, they should not be accessed in such a direct
391  * manner, since when dealing with GSN meta-transactions the account sending and
392  * paying for execution may not be the actual sender (as far as an application
393  * is concerned).
394  *
395  * This contract is only required for intermediate, library-like contracts.
396  */
397 abstract contract Context {
398     function _msgSender() internal view virtual returns (address payable) {
399         return msg.sender;
400     }
401 
402     function _msgData() internal view virtual returns (bytes memory) {
403         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
404         return msg.data;
405     }
406 }
407 
408 // 
409 /**
410  * @dev Contract module that allows children to implement role-based access
411  * control mechanisms.
412  *
413  * Roles are referred to by their `bytes32` identifier. These should be exposed
414  * in the external API and be unique. The best way to achieve this is by
415  * using `public constant` hash digests:
416  *
417  * ```
418  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
419  * ```
420  *
421  * Roles can be used to represent a set of permissions. To restrict access to a
422  * function call, use {hasRole}:
423  *
424  * ```
425  * function foo() public {
426  *     require(hasRole(MY_ROLE, msg.sender));
427  *     ...
428  * }
429  * ```
430  *
431  * Roles can be granted and revoked dynamically via the {grantRole} and
432  * {revokeRole} functions. Each role has an associated admin role, and only
433  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
434  *
435  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
436  * that only accounts with this role will be able to grant or revoke other
437  * roles. More complex role relationships can be created by using
438  * {_setRoleAdmin}.
439  *
440  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
441  * grant and revoke this role. Extra precautions should be taken to secure
442  * accounts that have been granted it.
443  */
444 abstract contract AccessControl is Context {
445     using EnumerableSet for EnumerableSet.AddressSet;
446     using Address for address;
447 
448     struct RoleData {
449         EnumerableSet.AddressSet members;
450         bytes32 adminRole;
451     }
452 
453     mapping (bytes32 => RoleData) private _roles;
454 
455     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
456 
457     /**
458      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
459      *
460      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
461      * {RoleAdminChanged} not being emitted signaling this.
462      *
463      * _Available since v3.1._
464      */
465     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
466 
467     /**
468      * @dev Emitted when `account` is granted `role`.
469      *
470      * `sender` is the account that originated the contract call, an admin role
471      * bearer except when using {_setupRole}.
472      */
473     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
474 
475     /**
476      * @dev Emitted when `account` is revoked `role`.
477      *
478      * `sender` is the account that originated the contract call:
479      *   - if using `revokeRole`, it is the admin role bearer
480      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
481      */
482     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
483 
484     /**
485      * @dev Returns `true` if `account` has been granted `role`.
486      */
487     function hasRole(bytes32 role, address account) public view returns (bool) {
488         return _roles[role].members.contains(account);
489     }
490 
491     /**
492      * @dev Returns the number of accounts that have `role`. Can be used
493      * together with {getRoleMember} to enumerate all bearers of a role.
494      */
495     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
496         return _roles[role].members.length();
497     }
498 
499     /**
500      * @dev Returns one of the accounts that have `role`. `index` must be a
501      * value between 0 and {getRoleMemberCount}, non-inclusive.
502      *
503      * Role bearers are not sorted in any particular way, and their ordering may
504      * change at any point.
505      *
506      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
507      * you perform all queries on the same block. See the following
508      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
509      * for more information.
510      */
511     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
512         return _roles[role].members.at(index);
513     }
514 
515     /**
516      * @dev Returns the admin role that controls `role`. See {grantRole} and
517      * {revokeRole}.
518      *
519      * To change a role's admin, use {_setRoleAdmin}.
520      */
521     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
522         return _roles[role].adminRole;
523     }
524 
525     /**
526      * @dev Grants `role` to `account`.
527      *
528      * If `account` had not been already granted `role`, emits a {RoleGranted}
529      * event.
530      *
531      * Requirements:
532      *
533      * - the caller must have ``role``'s admin role.
534      */
535     function grantRole(bytes32 role, address account) public virtual {
536         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
537 
538         _grantRole(role, account);
539     }
540 
541     /**
542      * @dev Revokes `role` from `account`.
543      *
544      * If `account` had been granted `role`, emits a {RoleRevoked} event.
545      *
546      * Requirements:
547      *
548      * - the caller must have ``role``'s admin role.
549      */
550     function revokeRole(bytes32 role, address account) public virtual {
551         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
552 
553         _revokeRole(role, account);
554     }
555 
556     /**
557      * @dev Revokes `role` from the calling account.
558      *
559      * Roles are often managed via {grantRole} and {revokeRole}: this function's
560      * purpose is to provide a mechanism for accounts to lose their privileges
561      * if they are compromised (such as when a trusted device is misplaced).
562      *
563      * If the calling account had been granted `role`, emits a {RoleRevoked}
564      * event.
565      *
566      * Requirements:
567      *
568      * - the caller must be `account`.
569      */
570     function renounceRole(bytes32 role, address account) public virtual {
571         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
572 
573         _revokeRole(role, account);
574     }
575 
576     /**
577      * @dev Grants `role` to `account`.
578      *
579      * If `account` had not been already granted `role`, emits a {RoleGranted}
580      * event. Note that unlike {grantRole}, this function doesn't perform any
581      * checks on the calling account.
582      *
583      * [WARNING]
584      * ====
585      * This function should only be called from the constructor when setting
586      * up the initial roles for the system.
587      *
588      * Using this function in any other way is effectively circumventing the admin
589      * system imposed by {AccessControl}.
590      * ====
591      */
592     function _setupRole(bytes32 role, address account) internal virtual {
593         _grantRole(role, account);
594     }
595 
596     /**
597      * @dev Sets `adminRole` as ``role``'s admin role.
598      *
599      * Emits a {RoleAdminChanged} event.
600      */
601     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
602         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
603         _roles[role].adminRole = adminRole;
604     }
605 
606     function _grantRole(bytes32 role, address account) private {
607         if (_roles[role].members.add(account)) {
608             emit RoleGranted(role, account, _msgSender());
609         }
610     }
611 
612     function _revokeRole(bytes32 role, address account) private {
613         if (_roles[role].members.remove(account)) {
614             emit RoleRevoked(role, account, _msgSender());
615         }
616     }
617 }
618 
619 // 
620 /**
621  * @dev Wrappers over Solidity's arithmetic operations with added overflow
622  * checks.
623  *
624  * Arithmetic operations in Solidity wrap on overflow. This can easily result
625  * in bugs, because programmers usually assume that an overflow raises an
626  * error, which is the standard behavior in high level programming languages.
627  * `SafeMath` restores this intuition by reverting the transaction when an
628  * operation overflows.
629  *
630  * Using this library instead of the unchecked operations eliminates an entire
631  * class of bugs, so it's recommended to use it always.
632  */
633 library SafeMath {
634     /**
635      * @dev Returns the addition of two unsigned integers, reverting on
636      * overflow.
637      *
638      * Counterpart to Solidity's `+` operator.
639      *
640      * Requirements:
641      *
642      * - Addition cannot overflow.
643      */
644     function add(uint256 a, uint256 b) internal pure returns (uint256) {
645         uint256 c = a + b;
646         require(c >= a, "SafeMath: addition overflow");
647 
648         return c;
649     }
650 
651     /**
652      * @dev Returns the subtraction of two unsigned integers, reverting on
653      * overflow (when the result is negative).
654      *
655      * Counterpart to Solidity's `-` operator.
656      *
657      * Requirements:
658      *
659      * - Subtraction cannot overflow.
660      */
661     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
662         return sub(a, b, "SafeMath: subtraction overflow");
663     }
664 
665     /**
666      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
667      * overflow (when the result is negative).
668      *
669      * Counterpart to Solidity's `-` operator.
670      *
671      * Requirements:
672      *
673      * - Subtraction cannot overflow.
674      */
675     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
676         require(b <= a, errorMessage);
677         uint256 c = a - b;
678 
679         return c;
680     }
681 
682     /**
683      * @dev Returns the multiplication of two unsigned integers, reverting on
684      * overflow.
685      *
686      * Counterpart to Solidity's `*` operator.
687      *
688      * Requirements:
689      *
690      * - Multiplication cannot overflow.
691      */
692     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
693         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
694         // benefit is lost if 'b' is also tested.
695         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
696         if (a == 0) {
697             return 0;
698         }
699 
700         uint256 c = a * b;
701         require(c / a == b, "SafeMath: multiplication overflow");
702 
703         return c;
704     }
705 
706     /**
707      * @dev Returns the integer division of two unsigned integers. Reverts on
708      * division by zero. The result is rounded towards zero.
709      *
710      * Counterpart to Solidity's `/` operator. Note: this function uses a
711      * `revert` opcode (which leaves remaining gas untouched) while Solidity
712      * uses an invalid opcode to revert (consuming all remaining gas).
713      *
714      * Requirements:
715      *
716      * - The divisor cannot be zero.
717      */
718     function div(uint256 a, uint256 b) internal pure returns (uint256) {
719         return div(a, b, "SafeMath: division by zero");
720     }
721 
722     /**
723      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
724      * division by zero. The result is rounded towards zero.
725      *
726      * Counterpart to Solidity's `/` operator. Note: this function uses a
727      * `revert` opcode (which leaves remaining gas untouched) while Solidity
728      * uses an invalid opcode to revert (consuming all remaining gas).
729      *
730      * Requirements:
731      *
732      * - The divisor cannot be zero.
733      */
734     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
735         require(b > 0, errorMessage);
736         uint256 c = a / b;
737         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
738 
739         return c;
740     }
741 
742     /**
743      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
744      * Reverts when dividing by zero.
745      *
746      * Counterpart to Solidity's `%` operator. This function uses a `revert`
747      * opcode (which leaves remaining gas untouched) while Solidity uses an
748      * invalid opcode to revert (consuming all remaining gas).
749      *
750      * Requirements:
751      *
752      * - The divisor cannot be zero.
753      */
754     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
755         return mod(a, b, "SafeMath: modulo by zero");
756     }
757 
758     /**
759      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
760      * Reverts with custom message when dividing by zero.
761      *
762      * Counterpart to Solidity's `%` operator. This function uses a `revert`
763      * opcode (which leaves remaining gas untouched) while Solidity uses an
764      * invalid opcode to revert (consuming all remaining gas).
765      *
766      * Requirements:
767      *
768      * - The divisor cannot be zero.
769      */
770     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
771         require(b != 0, errorMessage);
772         return a % b;
773     }
774 }
775 
776 // 
777 /**
778  * @dev Contract module that helps prevent reentrant calls to a function.
779  *
780  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
781  * available, which can be applied to functions to make sure there are no nested
782  * (reentrant) calls to them.
783  *
784  * Note that because there is a single `nonReentrant` guard, functions marked as
785  * `nonReentrant` may not call one another. This can be worked around by making
786  * those functions `private`, and then adding `external` `nonReentrant` entry
787  * points to them.
788  *
789  * TIP: If you would like to learn more about reentrancy and alternative ways
790  * to protect against it, check out our blog post
791  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
792  */
793 contract ReentrancyGuard {
794     // Booleans are more expensive than uint256 or any type that takes up a full
795     // word because each write operation emits an extra SLOAD to first read the
796     // slot's contents, replace the bits taken up by the boolean, and then write
797     // back. This is the compiler's defense against contract upgrades and
798     // pointer aliasing, and it cannot be disabled.
799 
800     // The values being non-zero value makes deployment a bit more expensive,
801     // but in exchange the refund on every call to nonReentrant will be lower in
802     // amount. Since refunds are capped to a percentage of the total
803     // transaction's gas, it is best to keep them low in cases like this one, to
804     // increase the likelihood of the full refund coming into effect.
805     uint256 private constant _NOT_ENTERED = 1;
806     uint256 private constant _ENTERED = 2;
807 
808     uint256 private _status;
809 
810     constructor () internal {
811         _status = _NOT_ENTERED;
812     }
813 
814     /**
815      * @dev Prevents a contract from calling itself, directly or indirectly.
816      * Calling a `nonReentrant` function from another `nonReentrant`
817      * function is not supported. It is possible to prevent this from happening
818      * by making the `nonReentrant` function external, and make it call a
819      * `private` function that does the actual work.
820      */
821     modifier nonReentrant() {
822         // On the first call to nonReentrant, _notEntered will be true
823         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
824 
825         // Any calls to nonReentrant after this point will fail
826         _status = _ENTERED;
827 
828         _;
829 
830         // By storing the original value once again, a refund is triggered (see
831         // https://eips.ethereum.org/EIPS/eip-2200)
832         _status = _NOT_ENTERED;
833     }
834 }
835 
836 // 
837 /**
838  * @dev Interface of the ERC20 standard as defined in the EIP.
839  */
840 interface IERC20 {
841     /**
842      * @dev Returns the amount of tokens in existence.
843      */
844     function totalSupply() external view returns (uint256);
845 
846     /**
847      * @dev Returns the amount of tokens owned by `account`.
848      */
849     function balanceOf(address account) external view returns (uint256);
850 
851     /**
852      * @dev Moves `amount` tokens from the caller's account to `recipient`.
853      *
854      * Returns a boolean value indicating whether the operation succeeded.
855      *
856      * Emits a {Transfer} event.
857      */
858     function transfer(address recipient, uint256 amount) external returns (bool);
859 
860     /**
861      * @dev Returns the remaining number of tokens that `spender` will be
862      * allowed to spend on behalf of `owner` through {transferFrom}. This is
863      * zero by default.
864      *
865      * This value changes when {approve} or {transferFrom} are called.
866      */
867     function allowance(address owner, address spender) external view returns (uint256);
868 
869     /**
870      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
871      *
872      * Returns a boolean value indicating whether the operation succeeded.
873      *
874      * IMPORTANT: Beware that changing an allowance with this method brings the risk
875      * that someone may use both the old and the new allowance by unfortunate
876      * transaction ordering. One possible solution to mitigate this race
877      * condition is to first reduce the spender's allowance to 0 and set the
878      * desired value afterwards:
879      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
880      *
881      * Emits an {Approval} event.
882      */
883     function approve(address spender, uint256 amount) external returns (bool);
884 
885     /**
886      * @dev Moves `amount` tokens from `sender` to `recipient` using the
887      * allowance mechanism. `amount` is then deducted from the caller's
888      * allowance.
889      *
890      * Returns a boolean value indicating whether the operation succeeded.
891      *
892      * Emits a {Transfer} event.
893      */
894     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
895 
896     /**
897      * @dev Emitted when `value` tokens are moved from one account (`from`) to
898      * another (`to`).
899      *
900      * Note that `value` may be zero.
901      */
902     event Transfer(address indexed from, address indexed to, uint256 value);
903 
904     /**
905      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
906      * a call to {approve}. `value` is the new allowance.
907      */
908     event Approval(address indexed owner, address indexed spender, uint256 value);
909 }
910 
911 // 
912 interface IStaking {
913     // Events.
914     event Connection(bytes32 indexed account);
915     event Stake(bytes32 indexed account, uint256 amount, string stakeType);
916     event Unstake(bytes32 indexed account);
917     event UnstakingDisabled(string stakeType);
918     event Migration(uint256 amount, string stakeType);
919 
920     // Contract addresses.
921     function token() external view returns (address);
922     function XFIETHPair() external view returns (address);
923 
924     // Common view functions.
925     function staker(address account) external view returns (bytes32, uint256, uint256, uint256);
926     function isStaker(bytes32 account) external view returns (bool);
927 
928     // XFI view functions.
929     function isXFIUnstakingDisabled() external view returns (bool);
930 
931     // LPT view functions.
932     function isLPTStakingEnabled() external view returns (bool);
933     function LPTToXFIRatio() external view returns (uint256 lptTotalSupply, uint256 xfiReserve);
934 
935     // State-changing functions.
936     function connect(bytes32 account) external returns (bool);
937     function addXFI(uint256 amount) external returns (bool);
938     function addLPT(uint256 amount) external returns (bool);
939     function unstake() external returns (bool);
940 
941     // Functions that require owner access.
942     function disableXFIUnstaking() external returns (bool);
943     function migrateXFI(address pegZone) external returns (bool);
944     function setXFIETHPair(address xfiEthPairAddress) external returns (bool);
945     function enableLPTStaking() external returns (bool);
946 }
947 
948 // 
949 interface IUniswapV2Pair {
950     function totalSupply() external view returns (uint256);
951     function token0() external view returns (address);
952     function token1() external view returns (address);
953     function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
954 
955     function transfer(address recipient, uint256 amount) external returns (bool);
956     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
957 }
958 
959 // 
960 /**
961  * This staking contract allows to stake XFI and Uniswap Liquidity Pool Tokens
962  * (LPT).
963  */
964 contract Staking is IStaking, ReentrancyGuard, AccessControl {
965     using SafeMath for uint256;
966 
967     IERC20 private immutable _token;
968     IUniswapV2Pair private _xfiEthPair;
969 
970     bool private _isXfiUnstakingDisabled;
971     bool private _isLptStakingEnabled;
972 
973     struct Account {
974         bytes32 account;
975         uint256 xfiBalance;
976         uint256 lptBalance;
977         uint256 unstakedAt;
978     }
979 
980     mapping(address => Account) private _stakers;
981     mapping(bytes32 => bool) private _accounts;
982 
983     /**
984      * Sets {DEFAULT_ADMIN_ROLE} (alias `owner`) role for caller.
985      * Initializes XFI Token and XFI-ETH Uniswap pair.
986      */
987     constructor(address xfiToken_, address xfiEthPair_) public {
988         if (xfiEthPair_ != address(0)) {
989             _checkXFIETHPair(xfiToken_, xfiEthPair_);
990         }
991 
992         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
993 
994         _token = IERC20(xfiToken_);
995         _xfiEthPair = IUniswapV2Pair(xfiEthPair_);
996     }
997 
998     /**
999      * Connect Dfinance and Ethereum accounts.
1000      *
1001      * Emits a {Connection} event.
1002      *
1003      * Requirements:
1004      * - `account` is not the zero bytes.
1005      * - Ethereum account isn't connected.
1006      * - Dfinance account isn't connected.
1007      */
1008     function connect(bytes32 account) external override returns (bool) {
1009         require(account != bytes32(0), 'Staking: Dfinance account can not be the zero bytes');
1010         require(_stakers[msg.sender].account == bytes32(0), 'Staking: Ethereum account already connected');
1011         require(!_accounts[account], 'Staking: Dfinance account already connected');
1012 
1013         _accounts[account] = true;
1014         _stakers[msg.sender] = Account(account, 0, 0, 0);
1015 
1016         emit Connection(account);
1017 
1018         return true;
1019     }
1020 
1021     /**
1022      * Increase XFI stake.
1023      *
1024      * Emits a {Stake} event.
1025      *
1026      * Requirements:
1027      * - `amount` is greater than zero.
1028      * - Staking is not disabled.
1029      * - Dfinance account is connected.
1030      * - Account didn't unstake.
1031      */
1032     function addXFI(uint256 amount) external override nonReentrant returns (bool) {
1033         require(amount > 0, 'Staking: amount must be greater than zero');
1034         require(!_isXfiUnstakingDisabled, 'Staking: staking is disabled');
1035         require(_stakers[msg.sender].account != bytes32(0), 'Staking: Dfinance account is not connected');
1036         require(_stakers[msg.sender].unstakedAt == 0, 'Staking: unstaked account');
1037 
1038         _stakers[msg.sender].xfiBalance = _stakers[msg.sender].xfiBalance.add(amount);
1039 
1040         require(_token.transferFrom(msg.sender, address(this), amount), 'Staking: XFI transferFrom failed');
1041 
1042         emit Stake(_stakers[msg.sender].account, amount, 'XFI');
1043 
1044         return true;
1045     }
1046 
1047     /**
1048      * Increase LPT stake.
1049      *
1050      * Emits a {Stake} event.
1051      *
1052      * Requirements:
1053      * - `amount` is greater than zero.
1054      * - XFI-ETH pair must be set.
1055      * - LPT staking enabled.
1056      * - Staking is not disabled.
1057      * - Dfinance account is connected.
1058      * - Account didn't unstake.
1059      */
1060     function addLPT(uint256 amount) external override nonReentrant returns (bool) {
1061         require(amount > 0, 'Staking: amount must be greater than zero');
1062         require(address(_xfiEthPair) != address(0), 'Staking: XFI-ETH pair is not set');
1063         require(_isLptStakingEnabled, 'Staking: LPT staking is not enabled');
1064         require(!_isXfiUnstakingDisabled, 'Staking: staking is disabled');
1065         require(_stakers[msg.sender].account != bytes32(0), 'Staking: Dfinance account is not connected');
1066         require(_stakers[msg.sender].unstakedAt == 0, 'Staking: unstaked account');
1067 
1068         _stakers[msg.sender].lptBalance = _stakers[msg.sender].lptBalance.add(amount);
1069 
1070         require(_xfiEthPair.transferFrom(msg.sender, address(this), amount), 'Staking: LPT transferFrom failed');
1071 
1072         emit Stake(_stakers[msg.sender].account, amount, 'LPT');
1073 
1074         return true;
1075     }
1076 
1077     /**
1078      * Unstake.
1079      *
1080      * Emits an {Unstake} event.
1081      *
1082      * Requirements:
1083      * - Dfinance account is connected.
1084      * - Account didn't unstake.
1085      */
1086     function unstake() external override returns (bool) {
1087         require(_stakers[msg.sender].account != bytes32(0), 'Staking: Dfinance account is not connected');
1088         require(_stakers[msg.sender].unstakedAt == 0, 'Staking: unstaked account');
1089 
1090         _stakers[msg.sender].unstakedAt = block.timestamp;
1091 
1092         if (!_isXfiUnstakingDisabled) {
1093             uint256 unstakedXfiAmount = _stakers[msg.sender].xfiBalance;
1094 
1095             if (unstakedXfiAmount > 0) {
1096                 _stakers[msg.sender].xfiBalance = 0;
1097                 require(_token.transfer(msg.sender, unstakedXfiAmount), 'Staking: XFI transfer failed');
1098             }
1099         }
1100 
1101         uint256 unstakedLptAmount = _stakers[msg.sender].lptBalance;
1102 
1103         if (unstakedLptAmount > 0) {
1104             _stakers[msg.sender].lptBalance = 0;
1105             require(_xfiEthPair.transfer(msg.sender, unstakedLptAmount), 'Staking: LPT transfer failed');
1106         }
1107 
1108         emit Unstake(_stakers[msg.sender].account);
1109 
1110         return true;
1111     }
1112 
1113     /**
1114      * Disables XFI unstaking.
1115      *
1116      * Emits a {UnstakingDisabled} event.
1117      *
1118      * Requirements:
1119      * - Sender has the owner access role.
1120      * - Unstaking is not disabled.
1121      */
1122     function disableXFIUnstaking() external override returns (bool) {
1123         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), 'Staking: sender is not owner');
1124         require(!_isXfiUnstakingDisabled, 'Staking: XFI unstaking is already disabled');
1125 
1126         _isXfiUnstakingDisabled = true;
1127 
1128         emit UnstakingDisabled('XFI');
1129 
1130         return true;
1131     }
1132 
1133     /**
1134      * Migrate XFI to PegZone.
1135      *
1136      * Requirements:
1137      * - Sender has the owner access role.
1138      * - `pegZone` is not the zero address.
1139      * - XFI unstaking is disabled.
1140      * - Positive XFI balance.
1141      */
1142     function migrateXFI(address pegZone) external override returns (bool) {
1143         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), 'Staking: sender is not owner');
1144         require(pegZone != address(0), 'Staking: pegZone is the zero address');
1145         require(_isXfiUnstakingDisabled, 'Staking: XFI unstaking is not disabled');
1146 
1147         uint256 xfiBalance = _token.balanceOf(address(this));
1148 
1149         require(xfiBalance > 0, 'Staking: XFI balance is zero');
1150 
1151         require(_token.transfer(pegZone, xfiBalance), 'Staking: XFI transfer failed');
1152 
1153         emit Migration(xfiBalance, 'XFI');
1154 
1155         return true;
1156     }
1157 
1158     /**
1159      * Sets XFI-ETH pair (aka LPT address).
1160      *
1161      * Requirements:
1162      * - Sender has the owner access role.
1163      * - xfiEthPairAddress has XFI token.
1164      */
1165     function setXFIETHPair(address xfiEthPairAddress) external override returns (bool) {
1166         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), 'Staking: sender is not owner');
1167         _checkXFIETHPair(address(_token), xfiEthPairAddress);
1168 
1169         _xfiEthPair = IUniswapV2Pair(xfiEthPairAddress);
1170 
1171         return true;
1172     }
1173 
1174     /**
1175      * Enables LPT staking.
1176      *
1177      * Requirements:
1178      * - Sender has the owner access role.
1179      * - LPT staking isn't enabled.
1180      * - XFI-ETH pair must be set.
1181      */
1182     function enableLPTStaking() external override returns (bool) {
1183         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), 'Staking: sender is not owner');
1184         require(address(_xfiEthPair) != address(0), 'Staking: XFI-ETH pair is not set');
1185         require(!_isLptStakingEnabled, 'Staking: LPT staking enabled');
1186 
1187         _isLptStakingEnabled = true;
1188 
1189         return true;
1190     }
1191 
1192     /**
1193      * Returns the address of the XFI Token.
1194      */
1195     function token() external override view returns (address) {
1196         return address(_token);
1197     }
1198 
1199     /**
1200      * Returns the address of the Uniswap XFI-ETH pair.
1201      */
1202     function XFIETHPair() external view override returns (address) {
1203         return address(_xfiEthPair);
1204     }
1205 
1206     /**
1207      * Returns whether `account` is an existent staker.
1208      */
1209     function isStaker(bytes32 account) external override view returns (bool) {
1210         return _accounts[account];
1211     }
1212 
1213     /**
1214      * Returns properties of the staker account object using Ethereum `account` address.
1215      *
1216      * Returned tuple definition:
1217      * [0] - bytes32 XFI address.
1218      * [1] - uint256 XFI balance.
1219      * [2] - uint256 LPT balance.
1220      * [3] - uint256 unstaked at (timestamp).
1221      */
1222     function staker(address account) external view override returns (bytes32, uint256, uint256, uint256) {
1223         Account memory accountObject = _stakers[account];
1224 
1225         return (
1226             accountObject.account,
1227             accountObject.xfiBalance,
1228             accountObject.lptBalance,
1229             accountObject.unstakedAt
1230         );
1231     }
1232 
1233     /**
1234      * Returns whether XFI unstaking is disabled.
1235      */
1236     function isXFIUnstakingDisabled() external view override returns (bool) {
1237         return _isXfiUnstakingDisabled;
1238     }
1239 
1240     /**
1241      * Returns the ratio of LPT to XFI.
1242      *
1243      * Returned tuple definition:
1244      * - uint256 lptTotalSupply - LPT total supply.
1245      * - uint256 xfiReserve - XFI reserve.
1246      */
1247     function LPTToXFIRatio() external view override returns (uint256 lptTotalSupply, uint256 xfiReserve) {
1248         lptTotalSupply = _xfiEthPair.totalSupply();
1249 
1250         uint112 xfiReserve_;
1251 
1252         if (_xfiEthPair.token0() == address(_token)) {
1253             (xfiReserve_, , ) = _xfiEthPair.getReserves();
1254         } else {
1255             (, xfiReserve_, ) = _xfiEthPair.getReserves();
1256         }
1257 
1258         xfiReserve = uint256(xfiReserve_);
1259     }
1260 
1261     /**
1262      * Returns whether LPT staking is enabled.
1263      */
1264     function isLPTStakingEnabled() external view override returns (bool) {
1265         return _isLptStakingEnabled;
1266     }
1267 
1268     /**
1269      * Make sure the pair has XFI token reserve.
1270      */
1271     function _checkXFIETHPair(address xfiToken_, address xfiEthPairAddress) internal view {
1272         IUniswapV2Pair pair = IUniswapV2Pair(xfiEthPairAddress);
1273 
1274         require(
1275             (
1276                 (pair.token0() == xfiToken_) || (pair.token1() == xfiToken_)
1277             ),
1278             'Staking: invalid XFI-ETH pair address'
1279             );
1280     }
1281 }