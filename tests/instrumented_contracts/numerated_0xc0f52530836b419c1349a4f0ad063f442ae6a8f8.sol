1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
164 
165 // SPDX-License-Identifier: MIT
166 
167 pragma solidity ^0.6.0;
168 
169 /**
170  * @dev Library for managing
171  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
172  * types.
173  *
174  * Sets have the following properties:
175  *
176  * - Elements are added, removed, and checked for existence in constant time
177  * (O(1)).
178  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
179  *
180  * ```
181  * contract Example {
182  *     // Add the library methods
183  *     using EnumerableSet for EnumerableSet.AddressSet;
184  *
185  *     // Declare a set state variable
186  *     EnumerableSet.AddressSet private mySet;
187  * }
188  * ```
189  *
190  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
191  * (`UintSet`) are supported.
192  */
193 library EnumerableSet {
194     // To implement this library for multiple types with as little code
195     // repetition as possible, we write it in terms of a generic Set type with
196     // bytes32 values.
197     // The Set implementation uses private functions, and user-facing
198     // implementations (such as AddressSet) are just wrappers around the
199     // underlying Set.
200     // This means that we can only create new EnumerableSets for types that fit
201     // in bytes32.
202 
203     struct Set {
204         // Storage of set values
205         bytes32[] _values;
206 
207         // Position of the value in the `values` array, plus 1 because index 0
208         // means a value is not in the set.
209         mapping (bytes32 => uint256) _indexes;
210     }
211 
212     /**
213      * @dev Add a value to a set. O(1).
214      *
215      * Returns true if the value was added to the set, that is if it was not
216      * already present.
217      */
218     function _add(Set storage set, bytes32 value) private returns (bool) {
219         if (!_contains(set, value)) {
220             set._values.push(value);
221             // The value is stored at length-1, but we add 1 to all indexes
222             // and use 0 as a sentinel value
223             set._indexes[value] = set._values.length;
224             return true;
225         } else {
226             return false;
227         }
228     }
229 
230     /**
231      * @dev Removes a value from a set. O(1).
232      *
233      * Returns true if the value was removed from the set, that is if it was
234      * present.
235      */
236     function _remove(Set storage set, bytes32 value) private returns (bool) {
237         // We read and store the value's index to prevent multiple reads from the same storage slot
238         uint256 valueIndex = set._indexes[value];
239 
240         if (valueIndex != 0) { // Equivalent to contains(set, value)
241             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
242             // the array, and then remove the last element (sometimes called as 'swap and pop').
243             // This modifies the order of the array, as noted in {at}.
244 
245             uint256 toDeleteIndex = valueIndex - 1;
246             uint256 lastIndex = set._values.length - 1;
247 
248             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
249             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
250 
251             bytes32 lastvalue = set._values[lastIndex];
252 
253             // Move the last value to the index where the value to delete is
254             set._values[toDeleteIndex] = lastvalue;
255             // Update the index for the moved value
256             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
257 
258             // Delete the slot where the moved value was stored
259             set._values.pop();
260 
261             // Delete the index for the deleted slot
262             delete set._indexes[value];
263 
264             return true;
265         } else {
266             return false;
267         }
268     }
269 
270     /**
271      * @dev Returns true if the value is in the set. O(1).
272      */
273     function _contains(Set storage set, bytes32 value) private view returns (bool) {
274         return set._indexes[value] != 0;
275     }
276 
277     /**
278      * @dev Returns the number of values on the set. O(1).
279      */
280     function _length(Set storage set) private view returns (uint256) {
281         return set._values.length;
282     }
283 
284    /**
285     * @dev Returns the value stored at position `index` in the set. O(1).
286     *
287     * Note that there are no guarantees on the ordering of values inside the
288     * array, and it may change when more values are added or removed.
289     *
290     * Requirements:
291     *
292     * - `index` must be strictly less than {length}.
293     */
294     function _at(Set storage set, uint256 index) private view returns (bytes32) {
295         require(set._values.length > index, "EnumerableSet: index out of bounds");
296         return set._values[index];
297     }
298 
299     // AddressSet
300 
301     struct AddressSet {
302         Set _inner;
303     }
304 
305     /**
306      * @dev Add a value to a set. O(1).
307      *
308      * Returns true if the value was added to the set, that is if it was not
309      * already present.
310      */
311     function add(AddressSet storage set, address value) internal returns (bool) {
312         return _add(set._inner, bytes32(uint256(value)));
313     }
314 
315     /**
316      * @dev Removes a value from a set. O(1).
317      *
318      * Returns true if the value was removed from the set, that is if it was
319      * present.
320      */
321     function remove(AddressSet storage set, address value) internal returns (bool) {
322         return _remove(set._inner, bytes32(uint256(value)));
323     }
324 
325     /**
326      * @dev Returns true if the value is in the set. O(1).
327      */
328     function contains(AddressSet storage set, address value) internal view returns (bool) {
329         return _contains(set._inner, bytes32(uint256(value)));
330     }
331 
332     /**
333      * @dev Returns the number of values in the set. O(1).
334      */
335     function length(AddressSet storage set) internal view returns (uint256) {
336         return _length(set._inner);
337     }
338 
339    /**
340     * @dev Returns the value stored at position `index` in the set. O(1).
341     *
342     * Note that there are no guarantees on the ordering of values inside the
343     * array, and it may change when more values are added or removed.
344     *
345     * Requirements:
346     *
347     * - `index` must be strictly less than {length}.
348     */
349     function at(AddressSet storage set, uint256 index) internal view returns (address) {
350         return address(uint256(_at(set._inner, index)));
351     }
352 
353 
354     // UintSet
355 
356     struct UintSet {
357         Set _inner;
358     }
359 
360     /**
361      * @dev Add a value to a set. O(1).
362      *
363      * Returns true if the value was added to the set, that is if it was not
364      * already present.
365      */
366     function add(UintSet storage set, uint256 value) internal returns (bool) {
367         return _add(set._inner, bytes32(value));
368     }
369 
370     /**
371      * @dev Removes a value from a set. O(1).
372      *
373      * Returns true if the value was removed from the set, that is if it was
374      * present.
375      */
376     function remove(UintSet storage set, uint256 value) internal returns (bool) {
377         return _remove(set._inner, bytes32(value));
378     }
379 
380     /**
381      * @dev Returns true if the value is in the set. O(1).
382      */
383     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
384         return _contains(set._inner, bytes32(value));
385     }
386 
387     /**
388      * @dev Returns the number of values on the set. O(1).
389      */
390     function length(UintSet storage set) internal view returns (uint256) {
391         return _length(set._inner);
392     }
393 
394    /**
395     * @dev Returns the value stored at position `index` in the set. O(1).
396     *
397     * Note that there are no guarantees on the ordering of values inside the
398     * array, and it may change when more values are added or removed.
399     *
400     * Requirements:
401     *
402     * - `index` must be strictly less than {length}.
403     */
404     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
405         return uint256(_at(set._inner, index));
406     }
407 }
408 
409 // File: @openzeppelin/contracts/utils/Address.sol
410 
411 // SPDX-License-Identifier: MIT
412 
413 pragma solidity ^0.6.2;
414 
415 /**
416  * @dev Collection of functions related to the address type
417  */
418 library Address {
419     /**
420      * @dev Returns true if `account` is a contract.
421      *
422      * [IMPORTANT]
423      * ====
424      * It is unsafe to assume that an address for which this function returns
425      * false is an externally-owned account (EOA) and not a contract.
426      *
427      * Among others, `isContract` will return false for the following
428      * types of addresses:
429      *
430      *  - an externally-owned account
431      *  - a contract in construction
432      *  - an address where a contract will be created
433      *  - an address where a contract lived, but was destroyed
434      * ====
435      */
436     function isContract(address account) internal view returns (bool) {
437         // This method relies in extcodesize, which returns 0 for contracts in
438         // construction, since the code is only stored at the end of the
439         // constructor execution.
440 
441         uint256 size;
442         // solhint-disable-next-line no-inline-assembly
443         assembly { size := extcodesize(account) }
444         return size > 0;
445     }
446 
447     /**
448      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
449      * `recipient`, forwarding all available gas and reverting on errors.
450      *
451      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
452      * of certain opcodes, possibly making contracts go over the 2300 gas limit
453      * imposed by `transfer`, making them unable to receive funds via
454      * `transfer`. {sendValue} removes this limitation.
455      *
456      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
457      *
458      * IMPORTANT: because control is transferred to `recipient`, care must be
459      * taken to not create reentrancy vulnerabilities. Consider using
460      * {ReentrancyGuard} or the
461      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
462      */
463     function sendValue(address payable recipient, uint256 amount) internal {
464         require(address(this).balance >= amount, "Address: insufficient balance");
465 
466         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
467         (bool success, ) = recipient.call{ value: amount }("");
468         require(success, "Address: unable to send value, recipient may have reverted");
469     }
470 
471     /**
472      * @dev Performs a Solidity function call using a low level `call`. A
473      * plain`call` is an unsafe replacement for a function call: use this
474      * function instead.
475      *
476      * If `target` reverts with a revert reason, it is bubbled up by this
477      * function (like regular Solidity function calls).
478      *
479      * Returns the raw returned data. To convert to the expected return value,
480      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
481      *
482      * Requirements:
483      *
484      * - `target` must be a contract.
485      * - calling `target` with `data` must not revert.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
490       return functionCall(target, data, "Address: low-level call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
495      * `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
500         return _functionCallWithValue(target, data, 0, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but also transferring `value` wei to `target`.
506      *
507      * Requirements:
508      *
509      * - the calling contract must have an ETH balance of at least `value`.
510      * - the called Solidity function must be `payable`.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
515         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
520      * with `errorMessage` as a fallback revert reason when `target` reverts.
521      *
522      * _Available since v3.1._
523      */
524     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
525         require(address(this).balance >= value, "Address: insufficient balance for call");
526         return _functionCallWithValue(target, data, value, errorMessage);
527     }
528 
529     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
530         require(isContract(target), "Address: call to non-contract");
531 
532         // solhint-disable-next-line avoid-low-level-calls
533         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 // solhint-disable-next-line no-inline-assembly
542                 assembly {
543                     let returndata_size := mload(returndata)
544                     revert(add(32, returndata), returndata_size)
545                 }
546             } else {
547                 revert(errorMessage);
548             }
549         }
550     }
551 }
552 
553 // File: @openzeppelin/contracts/GSN/Context.sol
554 
555 // SPDX-License-Identifier: MIT
556 
557 pragma solidity ^0.6.0;
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
580 // File: @openzeppelin/contracts/access/AccessControl.sol
581 
582 // SPDX-License-Identifier: MIT
583 
584 pragma solidity ^0.6.0;
585 
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
799 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
800 
801 // SPDX-License-Identifier: MIT
802 
803 pragma solidity ^0.6.0;
804 
805 /**
806  * @dev Interface of the ERC20 standard as defined in the EIP.
807  */
808 interface IERC20 {
809     /**
810      * @dev Returns the amount of tokens in existence.
811      */
812     function totalSupply() external view returns (uint256);
813 
814     /**
815      * @dev Returns the amount of tokens owned by `account`.
816      */
817     function balanceOf(address account) external view returns (uint256);
818 
819     /**
820      * @dev Moves `amount` tokens from the caller's account to `recipient`.
821      *
822      * Returns a boolean value indicating whether the operation succeeded.
823      *
824      * Emits a {Transfer} event.
825      */
826     function transfer(address recipient, uint256 amount) external returns (bool);
827 
828     /**
829      * @dev Returns the remaining number of tokens that `spender` will be
830      * allowed to spend on behalf of `owner` through {transferFrom}. This is
831      * zero by default.
832      *
833      * This value changes when {approve} or {transferFrom} are called.
834      */
835     function allowance(address owner, address spender) external view returns (uint256);
836 
837     /**
838      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
839      *
840      * Returns a boolean value indicating whether the operation succeeded.
841      *
842      * IMPORTANT: Beware that changing an allowance with this method brings the risk
843      * that someone may use both the old and the new allowance by unfortunate
844      * transaction ordering. One possible solution to mitigate this race
845      * condition is to first reduce the spender's allowance to 0 and set the
846      * desired value afterwards:
847      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
848      *
849      * Emits an {Approval} event.
850      */
851     function approve(address spender, uint256 amount) external returns (bool);
852 
853     /**
854      * @dev Moves `amount` tokens from `sender` to `recipient` using the
855      * allowance mechanism. `amount` is then deducted from the caller's
856      * allowance.
857      *
858      * Returns a boolean value indicating whether the operation succeeded.
859      *
860      * Emits a {Transfer} event.
861      */
862     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
863 
864     /**
865      * @dev Emitted when `value` tokens are moved from one account (`from`) to
866      * another (`to`).
867      *
868      * Note that `value` may be zero.
869      */
870     event Transfer(address indexed from, address indexed to, uint256 value);
871 
872     /**
873      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
874      * a call to {approve}. `value` is the new allowance.
875      */
876     event Approval(address indexed owner, address indexed spender, uint256 value);
877 }
878 
879 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
880 
881 // SPDX-License-Identifier: MIT
882 
883 pragma solidity ^0.6.0;
884 
885 
886 
887 
888 /**
889  * @title SafeERC20
890  * @dev Wrappers around ERC20 operations that throw on failure (when the token
891  * contract returns false). Tokens that return no value (and instead revert or
892  * throw on failure) are also supported, non-reverting calls are assumed to be
893  * successful.
894  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
895  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
896  */
897 library SafeERC20 {
898     using SafeMath for uint256;
899     using Address for address;
900 
901     function safeTransfer(IERC20 token, address to, uint256 value) internal {
902         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
903     }
904 
905     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
906         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
907     }
908 
909     /**
910      * @dev Deprecated. This function has issues similar to the ones found in
911      * {IERC20-approve}, and its usage is discouraged.
912      *
913      * Whenever possible, use {safeIncreaseAllowance} and
914      * {safeDecreaseAllowance} instead.
915      */
916     function safeApprove(IERC20 token, address spender, uint256 value) internal {
917         // safeApprove should only be called when setting an initial allowance,
918         // or when resetting it to zero. To increase and decrease it, use
919         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
920         // solhint-disable-next-line max-line-length
921         require((value == 0) || (token.allowance(address(this), spender) == 0),
922             "SafeERC20: approve from non-zero to non-zero allowance"
923         );
924         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
925     }
926 
927     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
928         uint256 newAllowance = token.allowance(address(this), spender).add(value);
929         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
930     }
931 
932     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
933         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
934         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
935     }
936 
937     /**
938      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
939      * on the return value: the return value is optional (but if data is returned, it must not be false).
940      * @param token The token targeted by the call.
941      * @param data The call data (encoded using abi.encode or one of its variants).
942      */
943     function _callOptionalReturn(IERC20 token, bytes memory data) private {
944         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
945         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
946         // the target address contains contract code and also asserts for success in the low-level call.
947 
948         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
949         if (returndata.length > 0) { // Return data is optional
950             // solhint-disable-next-line max-line-length
951             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
952         }
953     }
954 }
955 
956 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
957 
958 // SPDX-License-Identifier: MIT
959 
960 pragma solidity ^0.6.0;
961 
962 
963 
964 
965 
966 /**
967  * @dev Implementation of the {IERC20} interface.
968  *
969  * This implementation is agnostic to the way tokens are created. This means
970  * that a supply mechanism has to be added in a derived contract using {_mint}.
971  * For a generic mechanism see {ERC20PresetMinterPauser}.
972  *
973  * TIP: For a detailed writeup see our guide
974  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
975  * to implement supply mechanisms].
976  *
977  * We have followed general OpenZeppelin guidelines: functions revert instead
978  * of returning `false` on failure. This behavior is nonetheless conventional
979  * and does not conflict with the expectations of ERC20 applications.
980  *
981  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
982  * This allows applications to reconstruct the allowance for all accounts just
983  * by listening to said events. Other implementations of the EIP may not emit
984  * these events, as it isn't required by the specification.
985  *
986  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
987  * functions have been added to mitigate the well-known issues around setting
988  * allowances. See {IERC20-approve}.
989  */
990 contract ERC20 is Context, IERC20 {
991     using SafeMath for uint256;
992     using Address for address;
993 
994     mapping (address => uint256) private _balances;
995 
996     mapping (address => mapping (address => uint256)) private _allowances;
997 
998     uint256 private _totalSupply;
999 
1000     string private _name;
1001     string private _symbol;
1002     uint8 private _decimals;
1003 
1004     /**
1005      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1006      * a default value of 18.
1007      *
1008      * To select a different value for {decimals}, use {_setupDecimals}.
1009      *
1010      * All three of these values are immutable: they can only be set once during
1011      * construction.
1012      */
1013     constructor (string memory name, string memory symbol) public {
1014         _name = name;
1015         _symbol = symbol;
1016         _decimals = 18;
1017     }
1018 
1019     /**
1020      * @dev Returns the name of the token.
1021      */
1022     function name() public view returns (string memory) {
1023         return _name;
1024     }
1025 
1026     /**
1027      * @dev Returns the symbol of the token, usually a shorter version of the
1028      * name.
1029      */
1030     function symbol() public view returns (string memory) {
1031         return _symbol;
1032     }
1033 
1034     /**
1035      * @dev Returns the number of decimals used to get its user representation.
1036      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1037      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1038      *
1039      * Tokens usually opt for a value of 18, imitating the relationship between
1040      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1041      * called.
1042      *
1043      * NOTE: This information is only used for _display_ purposes: it in
1044      * no way affects any of the arithmetic of the contract, including
1045      * {IERC20-balanceOf} and {IERC20-transfer}.
1046      */
1047     function decimals() public view returns (uint8) {
1048         return _decimals;
1049     }
1050 
1051     /**
1052      * @dev See {IERC20-totalSupply}.
1053      */
1054     function totalSupply() public view override returns (uint256) {
1055         return _totalSupply;
1056     }
1057 
1058     /**
1059      * @dev See {IERC20-balanceOf}.
1060      */
1061     function balanceOf(address account) public view override returns (uint256) {
1062         return _balances[account];
1063     }
1064 
1065     /**
1066      * @dev See {IERC20-transfer}.
1067      *
1068      * Requirements:
1069      *
1070      * - `recipient` cannot be the zero address.
1071      * - the caller must have a balance of at least `amount`.
1072      */
1073     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1074         _transfer(_msgSender(), recipient, amount);
1075         return true;
1076     }
1077 
1078     /**
1079      * @dev See {IERC20-allowance}.
1080      */
1081     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1082         return _allowances[owner][spender];
1083     }
1084 
1085     /**
1086      * @dev See {IERC20-approve}.
1087      *
1088      * Requirements:
1089      *
1090      * - `spender` cannot be the zero address.
1091      */
1092     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1093         _approve(_msgSender(), spender, amount);
1094         return true;
1095     }
1096 
1097     /**
1098      * @dev See {IERC20-transferFrom}.
1099      *
1100      * Emits an {Approval} event indicating the updated allowance. This is not
1101      * required by the EIP. See the note at the beginning of {ERC20};
1102      *
1103      * Requirements:
1104      * - `sender` and `recipient` cannot be the zero address.
1105      * - `sender` must have a balance of at least `amount`.
1106      * - the caller must have allowance for ``sender``'s tokens of at least
1107      * `amount`.
1108      */
1109     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1110         _transfer(sender, recipient, amount);
1111         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1112         return true;
1113     }
1114 
1115     /**
1116      * @dev Atomically increases the allowance granted to `spender` by the caller.
1117      *
1118      * This is an alternative to {approve} that can be used as a mitigation for
1119      * problems described in {IERC20-approve}.
1120      *
1121      * Emits an {Approval} event indicating the updated allowance.
1122      *
1123      * Requirements:
1124      *
1125      * - `spender` cannot be the zero address.
1126      */
1127     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1128         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1129         return true;
1130     }
1131 
1132     /**
1133      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1134      *
1135      * This is an alternative to {approve} that can be used as a mitigation for
1136      * problems described in {IERC20-approve}.
1137      *
1138      * Emits an {Approval} event indicating the updated allowance.
1139      *
1140      * Requirements:
1141      *
1142      * - `spender` cannot be the zero address.
1143      * - `spender` must have allowance for the caller of at least
1144      * `subtractedValue`.
1145      */
1146     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1147         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1148         return true;
1149     }
1150 
1151     /**
1152      * @dev Moves tokens `amount` from `sender` to `recipient`.
1153      *
1154      * This is internal function is equivalent to {transfer}, and can be used to
1155      * e.g. implement automatic token fees, slashing mechanisms, etc.
1156      *
1157      * Emits a {Transfer} event.
1158      *
1159      * Requirements:
1160      *
1161      * - `sender` cannot be the zero address.
1162      * - `recipient` cannot be the zero address.
1163      * - `sender` must have a balance of at least `amount`.
1164      */
1165     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1166         require(sender != address(0), "ERC20: transfer from the zero address");
1167         require(recipient != address(0), "ERC20: transfer to the zero address");
1168 
1169         _beforeTokenTransfer(sender, recipient, amount);
1170 
1171         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1172         _balances[recipient] = _balances[recipient].add(amount);
1173         emit Transfer(sender, recipient, amount);
1174     }
1175 
1176     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1177      * the total supply.
1178      *
1179      * Emits a {Transfer} event with `from` set to the zero address.
1180      *
1181      * Requirements
1182      *
1183      * - `to` cannot be the zero address.
1184      */
1185     function _mint(address account, uint256 amount) internal virtual {
1186         require(account != address(0), "ERC20: mint to the zero address");
1187 
1188         _beforeTokenTransfer(address(0), account, amount);
1189 
1190         _totalSupply = _totalSupply.add(amount);
1191         _balances[account] = _balances[account].add(amount);
1192         emit Transfer(address(0), account, amount);
1193     }
1194 
1195     /**
1196      * @dev Destroys `amount` tokens from `account`, reducing the
1197      * total supply.
1198      *
1199      * Emits a {Transfer} event with `to` set to the zero address.
1200      *
1201      * Requirements
1202      *
1203      * - `account` cannot be the zero address.
1204      * - `account` must have at least `amount` tokens.
1205      */
1206     function _burn(address account, uint256 amount) internal virtual {
1207         require(account != address(0), "ERC20: burn from the zero address");
1208 
1209         _beforeTokenTransfer(account, address(0), amount);
1210 
1211         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1212         _totalSupply = _totalSupply.sub(amount);
1213         emit Transfer(account, address(0), amount);
1214     }
1215 
1216     /**
1217      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1218      *
1219      * This internal function is equivalent to `approve`, and can be used to
1220      * e.g. set automatic allowances for certain subsystems, etc.
1221      *
1222      * Emits an {Approval} event.
1223      *
1224      * Requirements:
1225      *
1226      * - `owner` cannot be the zero address.
1227      * - `spender` cannot be the zero address.
1228      */
1229     function _approve(address owner, address spender, uint256 amount) internal virtual {
1230         require(owner != address(0), "ERC20: approve from the zero address");
1231         require(spender != address(0), "ERC20: approve to the zero address");
1232 
1233         _allowances[owner][spender] = amount;
1234         emit Approval(owner, spender, amount);
1235     }
1236 
1237     /**
1238      * @dev Sets {decimals} to a value other than the default one of 18.
1239      *
1240      * WARNING: This function should only be called from the constructor. Most
1241      * applications that interact with token contracts will not expect
1242      * {decimals} to ever change, and may work incorrectly if it does.
1243      */
1244     function _setupDecimals(uint8 decimals_) internal {
1245         _decimals = decimals_;
1246     }
1247 
1248     /**
1249      * @dev Hook that is called before any transfer of tokens. This includes
1250      * minting and burning.
1251      *
1252      * Calling conditions:
1253      *
1254      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1255      * will be to transferred to `to`.
1256      * - when `from` is zero, `amount` tokens will be minted for `to`.
1257      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1258      * - `from` and `to` are never both zero.
1259      *
1260      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1261      */
1262     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1263 }
1264 
1265 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1266 
1267 // SPDX-License-Identifier: MIT
1268 
1269 pragma solidity ^0.6.0;
1270 
1271 
1272 
1273 /**
1274  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1275  * tokens and those that they have an allowance for, in a way that can be
1276  * recognized off-chain (via event analysis).
1277  */
1278 abstract contract ERC20Burnable is Context, ERC20 {
1279     /**
1280      * @dev Destroys `amount` tokens from the caller.
1281      *
1282      * See {ERC20-_burn}.
1283      */
1284     function burn(uint256 amount) public virtual {
1285         _burn(_msgSender(), amount);
1286     }
1287 
1288     /**
1289      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1290      * allowance.
1291      *
1292      * See {ERC20-_burn} and {ERC20-allowance}.
1293      *
1294      * Requirements:
1295      *
1296      * - the caller must have allowance for ``accounts``'s tokens of at least
1297      * `amount`.
1298      */
1299     function burnFrom(address account, uint256 amount) public virtual {
1300         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1301 
1302         _approve(account, _msgSender(), decreasedAllowance);
1303         _burn(account, amount);
1304     }
1305 }
1306 
1307 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
1308 
1309 // SPDX-License-Identifier: MIT
1310 
1311 pragma solidity ^0.6.0;
1312 
1313 
1314 /**
1315  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1316  */
1317 abstract contract ERC20Capped is ERC20 {
1318     uint256 private _cap;
1319 
1320     /**
1321      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1322      * set once during construction.
1323      */
1324     constructor (uint256 cap) public {
1325         require(cap > 0, "ERC20Capped: cap is 0");
1326         _cap = cap;
1327     }
1328 
1329     /**
1330      * @dev Returns the cap on the token's total supply.
1331      */
1332     function cap() public view returns (uint256) {
1333         return _cap;
1334     }
1335 
1336     /**
1337      * @dev See {ERC20-_beforeTokenTransfer}.
1338      *
1339      * Requirements:
1340      *
1341      * - minted tokens must not cause the total supply to go over the cap.
1342      */
1343     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1344         super._beforeTokenTransfer(from, to, amount);
1345 
1346         if (from == address(0)) { // When minting tokens
1347             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1348         }
1349     }
1350 }
1351 
1352 // File: @openzeppelin/contracts/utils/Pausable.sol
1353 
1354 // SPDX-License-Identifier: MIT
1355 
1356 pragma solidity ^0.6.0;
1357 
1358 
1359 /**
1360  * @dev Contract module which allows children to implement an emergency stop
1361  * mechanism that can be triggered by an authorized account.
1362  *
1363  * This module is used through inheritance. It will make available the
1364  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1365  * the functions of your contract. Note that they will not be pausable by
1366  * simply including this module, only once the modifiers are put in place.
1367  */
1368 contract Pausable is Context {
1369     /**
1370      * @dev Emitted when the pause is triggered by `account`.
1371      */
1372     event Paused(address account);
1373 
1374     /**
1375      * @dev Emitted when the pause is lifted by `account`.
1376      */
1377     event Unpaused(address account);
1378 
1379     bool private _paused;
1380 
1381     /**
1382      * @dev Initializes the contract in unpaused state.
1383      */
1384     constructor () internal {
1385         _paused = false;
1386     }
1387 
1388     /**
1389      * @dev Returns true if the contract is paused, and false otherwise.
1390      */
1391     function paused() public view returns (bool) {
1392         return _paused;
1393     }
1394 
1395     /**
1396      * @dev Modifier to make a function callable only when the contract is not paused.
1397      *
1398      * Requirements:
1399      *
1400      * - The contract must not be paused.
1401      */
1402     modifier whenNotPaused() {
1403         require(!_paused, "Pausable: paused");
1404         _;
1405     }
1406 
1407     /**
1408      * @dev Modifier to make a function callable only when the contract is paused.
1409      *
1410      * Requirements:
1411      *
1412      * - The contract must be paused.
1413      */
1414     modifier whenPaused() {
1415         require(_paused, "Pausable: not paused");
1416         _;
1417     }
1418 
1419     /**
1420      * @dev Triggers stopped state.
1421      *
1422      * Requirements:
1423      *
1424      * - The contract must not be paused.
1425      */
1426     function _pause() internal virtual whenNotPaused {
1427         _paused = true;
1428         emit Paused(_msgSender());
1429     }
1430 
1431     /**
1432      * @dev Returns to normal state.
1433      *
1434      * Requirements:
1435      *
1436      * - The contract must be paused.
1437      */
1438     function _unpause() internal virtual whenPaused {
1439         _paused = false;
1440         emit Unpaused(_msgSender());
1441     }
1442 }
1443 
1444 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
1445 
1446 // SPDX-License-Identifier: MIT
1447 
1448 pragma solidity ^0.6.0;
1449 
1450 
1451 
1452 /**
1453  * @dev ERC20 token with pausable token transfers, minting and burning.
1454  *
1455  * Useful for scenarios such as preventing trades until the end of an evaluation
1456  * period, or having an emergency switch for freezing all token transfers in the
1457  * event of a large bug.
1458  */
1459 abstract contract ERC20Pausable is ERC20, Pausable {
1460     /**
1461      * @dev See {ERC20-_beforeTokenTransfer}.
1462      *
1463      * Requirements:
1464      *
1465      * - the contract must not be paused.
1466      */
1467     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1468         super._beforeTokenTransfer(from, to, amount);
1469 
1470         require(!paused(), "ERC20Pausable: token transfer while paused");
1471     }
1472 }
1473 
1474 // File: blockchain/contracts/omi.sol
1475 
1476 // contracts/ethereum/omi.sol
1477 // SPDX-License-Identifier: UNLICENSED
1478 pragma solidity ^0.6.0;
1479 
1480 
1481 
1482 
1483 
1484 
1485 contract OMI is AccessControl, ERC20Burnable, ERC20Capped, ERC20Pausable {
1486     using SafeERC20 for ERC20;
1487     bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');
1488     bytes32 public constant PAUSER_ROLE = keccak256('PAUSER_ROLE');
1489 
1490     constructor()
1491         public
1492         ERC20('Wrapped OMI Token', 'wOMI')
1493         ERC20Capped(750000000000 * 1e18)
1494     {
1495         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1496         _setupRole(MINTER_ROLE, msg.sender);
1497         _setupRole(PAUSER_ROLE, msg.sender);
1498     }
1499 
1500     function isWrappedOMITokenContract() public pure returns (bool) {
1501         return true;
1502     }
1503 
1504     /**
1505      * @dev Creates `amount` new tokens for `to`.
1506      *
1507      * See {ERC20-_mint}.
1508      *
1509      * Requirements:
1510      *
1511      * - the caller must have the `MINTER_ROLE`.
1512      */
1513     function mint(address to, uint256 amount) public virtual {
1514         require(
1515             hasRole(MINTER_ROLE, _msgSender()),
1516             'ERC20PresetMinterPauser: must have minter role to mint'
1517         );
1518         _mint(to, amount);
1519     }
1520 
1521     /**
1522      * @dev Pauses all token transfers.
1523      *
1524      * See {ERC20Pausable} and {Pausable-_pause}.
1525      *
1526      * Requirements:
1527      *
1528      * - the caller must have the `PAUSER_ROLE`.
1529      */
1530     function pause() public virtual {
1531         require(
1532             hasRole(PAUSER_ROLE, _msgSender()),
1533             'ERC20PresetMinterPauser: must have pauser role to pause'
1534         );
1535         _pause();
1536     }
1537 
1538     /**
1539      * @dev Unpauses all token transfers.
1540      *
1541      * See {ERC20Pausable} and {Pausable-_unpause}.
1542      *
1543      * Requirements:
1544      *
1545      * - the caller must have the `PAUSER_ROLE`.
1546      */
1547     function unpause() public virtual {
1548         require(
1549             hasRole(PAUSER_ROLE, _msgSender()),
1550             'ERC20PresetMinterPauser: must have pauser role to unpause'
1551         );
1552         _unpause();
1553     }
1554 
1555     function _beforeTokenTransfer(
1556         address from,
1557         address to,
1558         uint256 amount
1559     ) internal virtual override(ERC20, ERC20Pausable, ERC20Capped) {
1560         super._beforeTokenTransfer(from, to, amount);
1561     }
1562 }
1563 
1564 // File: blockchain/contracts/ethereumTokenSwap.sol
1565 
1566 // SPDX-License-Identifier: UNLICENSED
1567 pragma solidity ^0.6.0;
1568 
1569 
1570 
1571 contract OmiTokenEthereumToGochainSwap {
1572     using SafeMath for uint256;
1573     address private _omiContractAddress;
1574     address private _owner;
1575     uint256 private _swapIdCounter;
1576     bool private _paused;
1577     uint256 private _fee;
1578     address payable private _feeReceiver;
1579     mapping(uint256 => bool) private _feePaid;
1580     uint256 private _minimumSwapAmount;
1581     mapping(uint256 => bool) private _distributed;
1582 
1583     event Paused(address account);
1584 
1585     event Unpaused(address account);
1586 
1587     event OwnershipTransferred(
1588         address indexed previousOwner,
1589         address indexed newOwner
1590     );
1591 
1592     event OmiContractAddressChanged(
1593         address indexed previousOmiAddress,
1594         address indexed newOmiAddress
1595     );
1596 
1597     event FeeChanged(uint256 indexed previousFee, uint256 indexed newFee);
1598 
1599     event FeeReceiverChanged(
1600         address indexed previousFeeReceiver,
1601         address indexed newFeeReceiver
1602     );
1603 
1604     event FeePaid(uint256 indexed swapId, uint256 fee);
1605 
1606     event MinimumSwapAmountChanged(
1607         uint256 indexed previousSwapAmount,
1608         uint256 indexed newSwapAmount
1609     );
1610 
1611     event Swap(
1612         uint256 indexed swapId,
1613         address indexed fromAddress,
1614         address indexed toAddress,
1615         uint256 amount,
1616         string fromChain,
1617         string toChain
1618     );
1619 
1620     event Distribute(
1621         uint256 indexed swapId,
1622         address indexed toAddress,
1623         address indexed fromAddress,
1624         uint256 amount,
1625         string fromChain,
1626         string toChain
1627     );
1628 
1629     modifier onlyOwner() {
1630         require(_owner == msg.sender, 'Ownable: caller is not the owner');
1631         _;
1632     }
1633 
1634     modifier whenNotPaused() {
1635         require(!_paused, 'Pausable: paused');
1636         _;
1637     }
1638 
1639     modifier whenPaused() {
1640         require(_paused, 'Pausable: not paused');
1641         _;
1642     }
1643 
1644     constructor(address omiContractAddress) public {
1645         address payable msgSender = msg.sender;
1646         _owner = msgSender;
1647         emit OwnershipTransferred(address(0), msgSender);
1648         _omiContractAddress = omiContractAddress;
1649         _paused = false;
1650         _fee = 0;
1651         _feeReceiver = msgSender;
1652         emit FeeReceiverChanged(address(0), msgSender);
1653         _minimumSwapAmount = 1000000000000000000;
1654     }
1655 
1656     function owner() public view returns (address Owner) {
1657         return _owner;
1658     }
1659 
1660     function renounceOwnership() public virtual onlyOwner {
1661         emit OwnershipTransferred(_owner, address(0));
1662         _owner = address(0);
1663     }
1664 
1665     function transferOwnership(address newOwner) public virtual onlyOwner {
1666         require(
1667             newOwner != address(0),
1668             'Ownable: new owner is the zero address'
1669         );
1670         emit OwnershipTransferred(_owner, newOwner);
1671         _owner = newOwner;
1672     }
1673 
1674     function paused() public view returns (bool IsPaused) {
1675         return _paused;
1676     }
1677 
1678     function pause() public onlyOwner whenNotPaused {
1679         _paused = true;
1680         emit Paused(msg.sender);
1681     }
1682 
1683     function unpause() public onlyOwner whenPaused {
1684         _paused = false;
1685         emit Unpaused(msg.sender);
1686     }
1687 
1688     function getOmiContractAddress()
1689         public
1690         view
1691         returns (address OmiTokenAddress)
1692     {
1693         return _omiContractAddress;
1694     }
1695 
1696     function setOmiContractAddress(address newOmiContractAddress)
1697         public
1698         onlyOwner
1699     {
1700         emit OmiContractAddressChanged(
1701             _omiContractAddress,
1702             newOmiContractAddress
1703         );
1704         _omiContractAddress = newOmiContractAddress;
1705     }
1706 
1707     function getHasPaidFee(uint256 swapId) public view returns (bool) {
1708         return _feePaid[swapId] == true;
1709     }
1710 
1711     function getFee() public view returns (uint256 Fee) {
1712         return _fee;
1713     }
1714 
1715     function setFee(uint256 newFee) public onlyOwner {
1716         require(newFee >= 0, 'Fee rate must be 0 or greater');
1717         emit FeeChanged(_fee, newFee);
1718         _fee = newFee;
1719     }
1720 
1721     function payFee(uint256 swapId) public payable whenNotPaused {
1722         require(
1723             msg.value >= _fee,
1724             'Received value must be greater than the distribution fee'
1725         );
1726         require(
1727             _feePaid[swapId] != true,
1728             'Distribution fee has already been paid'
1729         );
1730         _feePaid[swapId] = true;
1731         _feeReceiver.transfer(msg.value);
1732         emit FeePaid(swapId, msg.value);
1733     }
1734 
1735     function getFeeReceiver()
1736         public
1737         view
1738         returns (address payable FeeReciever)
1739     {
1740         return _feeReceiver;
1741     }
1742 
1743     function setFeeReceiver(address payable newFeeReceiver) public onlyOwner {
1744         emit FeeReceiverChanged(_feeReceiver, newFeeReceiver);
1745         _feeReceiver = newFeeReceiver;
1746     }
1747 
1748     function getHasDistributed(uint256 swapId) public view returns (bool) {
1749         return _distributed[swapId] == true;
1750     }
1751 
1752     function getMinimumSwapAmount()
1753         public
1754         view
1755         returns (uint256 MinumumSwapAmount)
1756     {
1757         return _minimumSwapAmount;
1758     }
1759 
1760     function setMinumumSwapAmount(uint256 newMinimumSwapAmount)
1761         public
1762         onlyOwner
1763     {
1764         require(
1765             newMinimumSwapAmount > 0,
1766             'Minimum swap amount must be greater than 0'
1767         );
1768         emit MinimumSwapAmountChanged(_minimumSwapAmount, newMinimumSwapAmount);
1769         _minimumSwapAmount = newMinimumSwapAmount;
1770     }
1771 
1772     function swap(address toAddress, uint256 amount) public whenNotPaused {
1773         require(toAddress != address(0), 'Can not swap to the zero address');
1774         require(
1775             amount >= _minimumSwapAmount,
1776             'Amount must be greater than the minimum swap amount'
1777         );
1778         address msgSender = msg.sender;
1779         OMI omiContract = OMI(_omiContractAddress);
1780         omiContract.burnFrom(msgSender, amount);
1781         _swapIdCounter = _swapIdCounter.add(1);
1782         emit Swap(
1783             _swapIdCounter,
1784             msg.sender,
1785             toAddress,
1786             amount,
1787             'ethereum',
1788             'gochain'
1789         );
1790     }
1791 
1792     function distribute(
1793         uint256 swapId,
1794         address toAddress,
1795         address fromAddress,
1796         uint256 amount
1797     ) public whenNotPaused onlyOwner {
1798         require(
1799             _distributed[swapId] != true,
1800             'Swap id has already been distributed'
1801         );
1802         require(
1803             _fee == 0 || _feePaid[swapId] == true,
1804             'Distribution fee has not been paid'
1805         );
1806         _distributed[swapId] = true;
1807         OMI omiContract = OMI(_omiContractAddress);
1808         omiContract.mint(toAddress, amount);
1809         emit Distribute(
1810             swapId,
1811             toAddress,
1812             fromAddress,
1813             amount,
1814             'gochain',
1815             'ethereum'
1816         );
1817     }
1818 }