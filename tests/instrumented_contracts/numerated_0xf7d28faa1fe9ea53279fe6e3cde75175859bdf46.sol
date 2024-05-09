1 
2 // File: @openzeppelin/contracts/math/SafeMath.sol
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.6.0;
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      *
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      *
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      *
78      * - Multiplication cannot overflow.
79      */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
165 
166 
167 
168 pragma solidity ^0.6.0;
169 
170 /**
171  * @dev Library for managing
172  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
173  * types.
174  *
175  * Sets have the following properties:
176  *
177  * - Elements are added, removed, and checked for existence in constant time
178  * (O(1)).
179  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
180  *
181  * ```
182  * contract Example {
183  *     // Add the library methods
184  *     using EnumerableSet for EnumerableSet.AddressSet;
185  *
186  *     // Declare a set state variable
187  *     EnumerableSet.AddressSet private mySet;
188  * }
189  * ```
190  *
191  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
192  * (`UintSet`) are supported.
193  */
194 library EnumerableSet {
195     // To implement this library for multiple types with as little code
196     // repetition as possible, we write it in terms of a generic Set type with
197     // bytes32 values.
198     // The Set implementation uses private functions, and user-facing
199     // implementations (such as AddressSet) are just wrappers around the
200     // underlying Set.
201     // This means that we can only create new EnumerableSets for types that fit
202     // in bytes32.
203 
204     struct Set {
205         // Storage of set values
206         bytes32[] _values;
207 
208         // Position of the value in the `values` array, plus 1 because index 0
209         // means a value is not in the set.
210         mapping (bytes32 => uint256) _indexes;
211     }
212 
213     /**
214      * @dev Add a value to a set. O(1).
215      *
216      * Returns true if the value was added to the set, that is if it was not
217      * already present.
218      */
219     function _add(Set storage set, bytes32 value) private returns (bool) {
220         if (!_contains(set, value)) {
221             set._values.push(value);
222             // The value is stored at length-1, but we add 1 to all indexes
223             // and use 0 as a sentinel value
224             set._indexes[value] = set._values.length;
225             return true;
226         } else {
227             return false;
228         }
229     }
230 
231     /**
232      * @dev Removes a value from a set. O(1).
233      *
234      * Returns true if the value was removed from the set, that is if it was
235      * present.
236      */
237     function _remove(Set storage set, bytes32 value) private returns (bool) {
238         // We read and store the value's index to prevent multiple reads from the same storage slot
239         uint256 valueIndex = set._indexes[value];
240 
241         if (valueIndex != 0) { // Equivalent to contains(set, value)
242             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
243             // the array, and then remove the last element (sometimes called as 'swap and pop').
244             // This modifies the order of the array, as noted in {at}.
245 
246             uint256 toDeleteIndex = valueIndex - 1;
247             uint256 lastIndex = set._values.length - 1;
248 
249             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
250             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
251 
252             bytes32 lastvalue = set._values[lastIndex];
253 
254             // Move the last value to the index where the value to delete is
255             set._values[toDeleteIndex] = lastvalue;
256             // Update the index for the moved value
257             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
258 
259             // Delete the slot where the moved value was stored
260             set._values.pop();
261 
262             // Delete the index for the deleted slot
263             delete set._indexes[value];
264 
265             return true;
266         } else {
267             return false;
268         }
269     }
270 
271     /**
272      * @dev Returns true if the value is in the set. O(1).
273      */
274     function _contains(Set storage set, bytes32 value) private view returns (bool) {
275         return set._indexes[value] != 0;
276     }
277 
278     /**
279      * @dev Returns the number of values on the set. O(1).
280      */
281     function _length(Set storage set) private view returns (uint256) {
282         return set._values.length;
283     }
284 
285    /**
286     * @dev Returns the value stored at position `index` in the set. O(1).
287     *
288     * Note that there are no guarantees on the ordering of values inside the
289     * array, and it may change when more values are added or removed.
290     *
291     * Requirements:
292     *
293     * - `index` must be strictly less than {length}.
294     */
295     function _at(Set storage set, uint256 index) private view returns (bytes32) {
296         require(set._values.length > index, "EnumerableSet: index out of bounds");
297         return set._values[index];
298     }
299 
300     // AddressSet
301 
302     struct AddressSet {
303         Set _inner;
304     }
305 
306     /**
307      * @dev Add a value to a set. O(1).
308      *
309      * Returns true if the value was added to the set, that is if it was not
310      * already present.
311      */
312     function add(AddressSet storage set, address value) internal returns (bool) {
313         return _add(set._inner, bytes32(uint256(value)));
314     }
315 
316     /**
317      * @dev Removes a value from a set. O(1).
318      *
319      * Returns true if the value was removed from the set, that is if it was
320      * present.
321      */
322     function remove(AddressSet storage set, address value) internal returns (bool) {
323         return _remove(set._inner, bytes32(uint256(value)));
324     }
325 
326     /**
327      * @dev Returns true if the value is in the set. O(1).
328      */
329     function contains(AddressSet storage set, address value) internal view returns (bool) {
330         return _contains(set._inner, bytes32(uint256(value)));
331     }
332 
333     /**
334      * @dev Returns the number of values in the set. O(1).
335      */
336     function length(AddressSet storage set) internal view returns (uint256) {
337         return _length(set._inner);
338     }
339 
340    /**
341     * @dev Returns the value stored at position `index` in the set. O(1).
342     *
343     * Note that there are no guarantees on the ordering of values inside the
344     * array, and it may change when more values are added or removed.
345     *
346     * Requirements:
347     *
348     * - `index` must be strictly less than {length}.
349     */
350     function at(AddressSet storage set, uint256 index) internal view returns (address) {
351         return address(uint256(_at(set._inner, index)));
352     }
353 
354 
355     // UintSet
356 
357     struct UintSet {
358         Set _inner;
359     }
360 
361     /**
362      * @dev Add a value to a set. O(1).
363      *
364      * Returns true if the value was added to the set, that is if it was not
365      * already present.
366      */
367     function add(UintSet storage set, uint256 value) internal returns (bool) {
368         return _add(set._inner, bytes32(value));
369     }
370 
371     /**
372      * @dev Removes a value from a set. O(1).
373      *
374      * Returns true if the value was removed from the set, that is if it was
375      * present.
376      */
377     function remove(UintSet storage set, uint256 value) internal returns (bool) {
378         return _remove(set._inner, bytes32(value));
379     }
380 
381     /**
382      * @dev Returns true if the value is in the set. O(1).
383      */
384     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
385         return _contains(set._inner, bytes32(value));
386     }
387 
388     /**
389      * @dev Returns the number of values on the set. O(1).
390      */
391     function length(UintSet storage set) internal view returns (uint256) {
392         return _length(set._inner);
393     }
394 
395    /**
396     * @dev Returns the value stored at position `index` in the set. O(1).
397     *
398     * Note that there are no guarantees on the ordering of values inside the
399     * array, and it may change when more values are added or removed.
400     *
401     * Requirements:
402     *
403     * - `index` must be strictly less than {length}.
404     */
405     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
406         return uint256(_at(set._inner, index));
407     }
408 }
409 
410 // File: @openzeppelin/contracts/utils/Address.sol
411 
412 
413 
414 pragma solidity ^0.6.2;
415 
416 /**
417  * @dev Collection of functions related to the address type
418  */
419 library Address {
420     /**
421      * @dev Returns true if `account` is a contract.
422      *
423      * [IMPORTANT]
424      * ====
425      * It is unsafe to assume that an address for which this function returns
426      * false is an externally-owned account (EOA) and not a contract.
427      *
428      * Among others, `isContract` will return false for the following
429      * types of addresses:
430      *
431      *  - an externally-owned account
432      *  - a contract in construction
433      *  - an address where a contract will be created
434      *  - an address where a contract lived, but was destroyed
435      * ====
436      */
437     function isContract(address account) internal view returns (bool) {
438         // This method relies in extcodesize, which returns 0 for contracts in
439         // construction, since the code is only stored at the end of the
440         // constructor execution.
441 
442         uint256 size;
443         // solhint-disable-next-line no-inline-assembly
444         assembly { size := extcodesize(account) }
445         return size > 0;
446     }
447 
448     /**
449      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
450      * `recipient`, forwarding all available gas and reverting on errors.
451      *
452      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
453      * of certain opcodes, possibly making contracts go over the 2300 gas limit
454      * imposed by `transfer`, making them unable to receive funds via
455      * `transfer`. {sendValue} removes this limitation.
456      *
457      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
458      *
459      * IMPORTANT: because control is transferred to `recipient`, care must be
460      * taken to not create reentrancy vulnerabilities. Consider using
461      * {ReentrancyGuard} or the
462      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
463      */
464     function sendValue(address payable recipient, uint256 amount) internal {
465         require(address(this).balance >= amount, "Address: insufficient balance");
466 
467         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
468         (bool success, ) = recipient.call{ value: amount }("");
469         require(success, "Address: unable to send value, recipient may have reverted");
470     }
471 
472     /**
473      * @dev Performs a Solidity function call using a low level `call`. A
474      * plain`call` is an unsafe replacement for a function call: use this
475      * function instead.
476      *
477      * If `target` reverts with a revert reason, it is bubbled up by this
478      * function (like regular Solidity function calls).
479      *
480      * Returns the raw returned data. To convert to the expected return value,
481      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
482      *
483      * Requirements:
484      *
485      * - `target` must be a contract.
486      * - calling `target` with `data` must not revert.
487      *
488      * _Available since v3.1._
489      */
490     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
491       return functionCall(target, data, "Address: low-level call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
496      * `errorMessage` as a fallback revert reason when `target` reverts.
497      *
498      * _Available since v3.1._
499      */
500     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
501         return _functionCallWithValue(target, data, 0, errorMessage);
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
506      * but also transferring `value` wei to `target`.
507      *
508      * Requirements:
509      *
510      * - the calling contract must have an ETH balance of at least `value`.
511      * - the called Solidity function must be `payable`.
512      *
513      * _Available since v3.1._
514      */
515     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
516         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
521      * with `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
526         require(address(this).balance >= value, "Address: insufficient balance for call");
527         return _functionCallWithValue(target, data, value, errorMessage);
528     }
529 
530     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
531         require(isContract(target), "Address: call to non-contract");
532 
533         // solhint-disable-next-line avoid-low-level-calls
534         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
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
554 // File: @openzeppelin/contracts/GSN/Context.sol
555 
556 
557 
558 pragma solidity ^0.6.0;
559 
560 /*
561  * @dev Provides information about the current execution context, including the
562  * sender of the transaction and its data. While these are generally available
563  * via msg.sender and msg.data, they should not be accessed in such a direct
564  * manner, since when dealing with GSN meta-transactions the account sending and
565  * paying for execution may not be the actual sender (as far as an application
566  * is concerned).
567  *
568  * This contract is only required for intermediate, library-like contracts.
569  */
570 abstract contract Context {
571     function _msgSender() internal view virtual returns (address payable) {
572         return msg.sender;
573     }
574 
575     function _msgData() internal view virtual returns (bytes memory) {
576         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
577         return msg.data;
578     }
579 }
580 
581 // File: @openzeppelin/contracts/access/AccessControl.sol
582 
583 
584 
585 pragma solidity ^0.6.0;
586 
587 
588 
589 
590 /**
591  * @dev Contract module that allows children to implement role-based access
592  * control mechanisms.
593  *
594  * Roles are referred to by their `bytes32` identifier. These should be exposed
595  * in the external API and be unique. The best way to achieve this is by
596  * using `public constant` hash digests:
597  *
598  * ```
599  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
600  * ```
601  *
602  * Roles can be used to represent a set of permissions. To restrict access to a
603  * function call, use {hasRole}:
604  *
605  * ```
606  * function foo() public {
607  *     require(hasRole(MY_ROLE, msg.sender));
608  *     ...
609  * }
610  * ```
611  *
612  * Roles can be granted and revoked dynamically via the {grantRole} and
613  * {revokeRole} functions. Each role has an associated admin role, and only
614  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
615  *
616  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
617  * that only accounts with this role will be able to grant or revoke other
618  * roles. More complex role relationships can be created by using
619  * {_setRoleAdmin}.
620  *
621  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
622  * grant and revoke this role. Extra precautions should be taken to secure
623  * accounts that have been granted it.
624  */
625 abstract contract AccessControl is Context {
626     using EnumerableSet for EnumerableSet.AddressSet;
627     using Address for address;
628 
629     struct RoleData {
630         EnumerableSet.AddressSet members;
631         bytes32 adminRole;
632     }
633 
634     mapping (bytes32 => RoleData) private _roles;
635 
636     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
637 
638     /**
639      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
640      *
641      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
642      * {RoleAdminChanged} not being emitted signaling this.
643      *
644      * _Available since v3.1._
645      */
646     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
647 
648     /**
649      * @dev Emitted when `account` is granted `role`.
650      *
651      * `sender` is the account that originated the contract call, an admin role
652      * bearer except when using {_setupRole}.
653      */
654     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
655 
656     /**
657      * @dev Emitted when `account` is revoked `role`.
658      *
659      * `sender` is the account that originated the contract call:
660      *   - if using `revokeRole`, it is the admin role bearer
661      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
662      */
663     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
664 
665     /**
666      * @dev Returns `true` if `account` has been granted `role`.
667      */
668     function hasRole(bytes32 role, address account) public view returns (bool) {
669         return _roles[role].members.contains(account);
670     }
671 
672     /**
673      * @dev Returns the number of accounts that have `role`. Can be used
674      * together with {getRoleMember} to enumerate all bearers of a role.
675      */
676     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
677         return _roles[role].members.length();
678     }
679 
680     /**
681      * @dev Returns one of the accounts that have `role`. `index` must be a
682      * value between 0 and {getRoleMemberCount}, non-inclusive.
683      *
684      * Role bearers are not sorted in any particular way, and their ordering may
685      * change at any point.
686      *
687      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
688      * you perform all queries on the same block. See the following
689      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
690      * for more information.
691      */
692     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
693         return _roles[role].members.at(index);
694     }
695 
696     /**
697      * @dev Returns the admin role that controls `role`. See {grantRole} and
698      * {revokeRole}.
699      *
700      * To change a role's admin, use {_setRoleAdmin}.
701      */
702     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
703         return _roles[role].adminRole;
704     }
705 
706     /**
707      * @dev Grants `role` to `account`.
708      *
709      * If `account` had not been already granted `role`, emits a {RoleGranted}
710      * event.
711      *
712      * Requirements:
713      *
714      * - the caller must have ``role``'s admin role.
715      */
716     function grantRole(bytes32 role, address account) public virtual {
717         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
718 
719         _grantRole(role, account);
720     }
721 
722     /**
723      * @dev Revokes `role` from `account`.
724      *
725      * If `account` had been granted `role`, emits a {RoleRevoked} event.
726      *
727      * Requirements:
728      *
729      * - the caller must have ``role``'s admin role.
730      */
731     function revokeRole(bytes32 role, address account) public virtual {
732         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
733 
734         _revokeRole(role, account);
735     }
736 
737     /**
738      * @dev Revokes `role` from the calling account.
739      *
740      * Roles are often managed via {grantRole} and {revokeRole}: this function's
741      * purpose is to provide a mechanism for accounts to lose their privileges
742      * if they are compromised (such as when a trusted device is misplaced).
743      *
744      * If the calling account had been granted `role`, emits a {RoleRevoked}
745      * event.
746      *
747      * Requirements:
748      *
749      * - the caller must be `account`.
750      */
751     function renounceRole(bytes32 role, address account) public virtual {
752         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
753 
754         _revokeRole(role, account);
755     }
756 
757     /**
758      * @dev Grants `role` to `account`.
759      *
760      * If `account` had not been already granted `role`, emits a {RoleGranted}
761      * event. Note that unlike {grantRole}, this function doesn't perform any
762      * checks on the calling account.
763      *
764      * [WARNING]
765      * ====
766      * This function should only be called from the constructor when setting
767      * up the initial roles for the system.
768      *
769      * Using this function in any other way is effectively circumventing the admin
770      * system imposed by {AccessControl}.
771      * ====
772      */
773     function _setupRole(bytes32 role, address account) internal virtual {
774         _grantRole(role, account);
775     }
776 
777     /**
778      * @dev Sets `adminRole` as ``role``'s admin role.
779      *
780      * Emits a {RoleAdminChanged} event.
781      */
782     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
783         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
784         _roles[role].adminRole = adminRole;
785     }
786 
787     function _grantRole(bytes32 role, address account) private {
788         if (_roles[role].members.add(account)) {
789             emit RoleGranted(role, account, _msgSender());
790         }
791     }
792 
793     function _revokeRole(bytes32 role, address account) private {
794         if (_roles[role].members.remove(account)) {
795             emit RoleRevoked(role, account, _msgSender());
796         }
797     }
798 }
799 
800 // File: solidity/contracts/utility/interfaces/IOwned.sol
801 
802 
803 pragma solidity 0.6.12;
804 
805 /*
806     Owned contract interface
807 */
808 interface IOwned {
809     // this function isn't since the compiler emits automatically generated getter functions as external
810     function owner() external view returns (address);
811 
812     function transferOwnership(address _newOwner) external;
813 
814     function acceptOwnership() external;
815 }
816 
817 // File: solidity/contracts/converter/interfaces/IConverterAnchor.sol
818 
819 
820 pragma solidity 0.6.12;
821 
822 
823 /*
824     Converter Anchor interface
825 */
826 interface IConverterAnchor is IOwned {
827 
828 }
829 
830 // File: solidity/contracts/token/interfaces/IERC20Token.sol
831 
832 
833 pragma solidity 0.6.12;
834 
835 /*
836     ERC20 Standard Token interface
837 */
838 interface IERC20Token {
839     function name() external view returns (string memory);
840 
841     function symbol() external view returns (string memory);
842 
843     function decimals() external view returns (uint8);
844 
845     function totalSupply() external view returns (uint256);
846 
847     function balanceOf(address _owner) external view returns (uint256);
848 
849     function allowance(address _owner, address _spender) external view returns (uint256);
850 
851     function transfer(address _to, uint256 _value) external returns (bool);
852 
853     function transferFrom(
854         address _from,
855         address _to,
856         uint256 _value
857     ) external returns (bool);
858 
859     function approve(address _spender, uint256 _value) external returns (bool);
860 }
861 
862 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionEventsSubscriber.sol
863 
864 
865 pragma solidity 0.6.12;
866 
867 
868 
869 /**
870  * @dev Liquidity protection events subscriber interface
871  */
872 interface ILiquidityProtectionEventsSubscriber {
873     function onAddingLiquidity(
874         address provider,
875         IConverterAnchor poolAnchor,
876         IERC20Token reserveToken,
877         uint256 poolAmount,
878         uint256 reserveAmount
879     ) external;
880 
881     function onRemovingLiquidity(
882         uint256 id,
883         address provider,
884         IConverterAnchor poolAnchor,
885         IERC20Token reserveToken,
886         uint256 poolAmount,
887         uint256 reserveAmount
888     ) external;
889 }
890 
891 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionSettings.sol
892 
893 
894 pragma solidity 0.6.12;
895 
896 
897 
898 
899 /*
900     Liquidity Protection Store Settings interface
901 */
902 interface ILiquidityProtectionSettings {
903     function isPoolWhitelisted(IConverterAnchor poolAnchor) external view returns (bool);
904 
905     function poolWhitelist() external view returns (address[] memory);
906 
907     function subscribers() external view returns (address[] memory);
908 
909     function isPoolSupported(IConverterAnchor poolAnchor) external view returns (bool);
910 
911     function minNetworkTokenLiquidityForMinting() external view returns (uint256);
912 
913     function defaultNetworkTokenMintingLimit() external view returns (uint256);
914 
915     function networkTokenMintingLimits(IConverterAnchor poolAnchor) external view returns (uint256);
916 
917     function addLiquidityDisabled(IConverterAnchor poolAnchor, IERC20Token reserveToken) external view returns (bool);
918 
919     function minProtectionDelay() external view returns (uint256);
920 
921     function maxProtectionDelay() external view returns (uint256);
922 
923     function minNetworkCompensation() external view returns (uint256);
924 
925     function lockDuration() external view returns (uint256);
926 
927     function averageRateMaxDeviation() external view returns (uint32);
928 }
929 
930 // File: solidity/contracts/converter/interfaces/IConverter.sol
931 
932 
933 pragma solidity 0.6.12;
934 
935 
936 
937 
938 /*
939     Converter interface
940 */
941 interface IConverter is IOwned {
942     function converterType() external pure returns (uint16);
943 
944     function anchor() external view returns (IConverterAnchor);
945 
946     function isActive() external view returns (bool);
947 
948     function targetAmountAndFee(
949         IERC20Token _sourceToken,
950         IERC20Token _targetToken,
951         uint256 _amount
952     ) external view returns (uint256, uint256);
953 
954     function convert(
955         IERC20Token _sourceToken,
956         IERC20Token _targetToken,
957         uint256 _amount,
958         address _trader,
959         address payable _beneficiary
960     ) external payable returns (uint256);
961 
962     function conversionFee() external view returns (uint32);
963 
964     function maxConversionFee() external view returns (uint32);
965 
966     function reserveBalance(IERC20Token _reserveToken) external view returns (uint256);
967 
968     receive() external payable;
969 
970     function transferAnchorOwnership(address _newOwner) external;
971 
972     function acceptAnchorOwnership() external;
973 
974     function setConversionFee(uint32 _conversionFee) external;
975 
976     function withdrawTokens(
977         IERC20Token _token,
978         address _to,
979         uint256 _amount
980     ) external;
981 
982     function withdrawETH(address payable _to) external;
983 
984     function addReserve(IERC20Token _token, uint32 _ratio) external;
985 
986     // deprecated, backward compatibility
987     function token() external view returns (IConverterAnchor);
988 
989     function transferTokenOwnership(address _newOwner) external;
990 
991     function acceptTokenOwnership() external;
992 
993     function connectors(IERC20Token _address)
994         external
995         view
996         returns (
997             uint256,
998             uint32,
999             bool,
1000             bool,
1001             bool
1002         );
1003 
1004     function getConnectorBalance(IERC20Token _connectorToken) external view returns (uint256);
1005 
1006     function connectorTokens(uint256 _index) external view returns (IERC20Token);
1007 
1008     function connectorTokenCount() external view returns (uint16);
1009 
1010     /**
1011      * @dev triggered when the converter is activated
1012      *
1013      * @param _type        converter type
1014      * @param _anchor      converter anchor
1015      * @param _activated   true if the converter was activated, false if it was deactivated
1016      */
1017     event Activation(uint16 indexed _type, IConverterAnchor indexed _anchor, bool indexed _activated);
1018 
1019     /**
1020      * @dev triggered when a conversion between two tokens occurs
1021      *
1022      * @param _fromToken       source ERC20 token
1023      * @param _toToken         target ERC20 token
1024      * @param _trader          wallet that initiated the trade
1025      * @param _amount          input amount in units of the source token
1026      * @param _return          output amount minus conversion fee in units of the target token
1027      * @param _conversionFee   conversion fee in units of the target token
1028      */
1029     event Conversion(
1030         IERC20Token indexed _fromToken,
1031         IERC20Token indexed _toToken,
1032         address indexed _trader,
1033         uint256 _amount,
1034         uint256 _return,
1035         int256 _conversionFee
1036     );
1037 
1038     /**
1039      * @dev triggered when the rate between two tokens in the converter changes
1040      * note that the event might be dispatched for rate updates between any two tokens in the converter
1041      *
1042      * @param  _token1 address of the first token
1043      * @param  _token2 address of the second token
1044      * @param  _rateN  rate of 1 unit of `_token1` in `_token2` (numerator)
1045      * @param  _rateD  rate of 1 unit of `_token1` in `_token2` (denominator)
1046      */
1047     event TokenRateUpdate(IERC20Token indexed _token1, IERC20Token indexed _token2, uint256 _rateN, uint256 _rateD);
1048 
1049     /**
1050      * @dev triggered when the conversion fee is updated
1051      *
1052      * @param  _prevFee    previous fee percentage, represented in ppm
1053      * @param  _newFee     new fee percentage, represented in ppm
1054      */
1055     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
1056 }
1057 
1058 // File: solidity/contracts/converter/interfaces/IConverterRegistry.sol
1059 
1060 
1061 pragma solidity 0.6.12;
1062 
1063 
1064 
1065 interface IConverterRegistry {
1066     function getAnchorCount() external view returns (uint256);
1067 
1068     function getAnchors() external view returns (address[] memory);
1069 
1070     function getAnchor(uint256 _index) external view returns (IConverterAnchor);
1071 
1072     function isAnchor(address _value) external view returns (bool);
1073 
1074     function getLiquidityPoolCount() external view returns (uint256);
1075 
1076     function getLiquidityPools() external view returns (address[] memory);
1077 
1078     function getLiquidityPool(uint256 _index) external view returns (IConverterAnchor);
1079 
1080     function isLiquidityPool(address _value) external view returns (bool);
1081 
1082     function getConvertibleTokenCount() external view returns (uint256);
1083 
1084     function getConvertibleTokens() external view returns (address[] memory);
1085 
1086     function getConvertibleToken(uint256 _index) external view returns (IERC20Token);
1087 
1088     function isConvertibleToken(address _value) external view returns (bool);
1089 
1090     function getConvertibleTokenAnchorCount(IERC20Token _convertibleToken) external view returns (uint256);
1091 
1092     function getConvertibleTokenAnchors(IERC20Token _convertibleToken) external view returns (address[] memory);
1093 
1094     function getConvertibleTokenAnchor(IERC20Token _convertibleToken, uint256 _index)
1095         external
1096         view
1097         returns (IConverterAnchor);
1098 
1099     function isConvertibleTokenAnchor(IERC20Token _convertibleToken, address _value) external view returns (bool);
1100 }
1101 
1102 // File: solidity/contracts/utility/Owned.sol
1103 
1104 
1105 pragma solidity 0.6.12;
1106 
1107 
1108 /**
1109  * @dev This contract provides support and utilities for contract ownership.
1110  */
1111 contract Owned is IOwned {
1112     address public override owner;
1113     address public newOwner;
1114 
1115     /**
1116      * @dev triggered when the owner is updated
1117      *
1118      * @param _prevOwner previous owner
1119      * @param _newOwner  new owner
1120      */
1121     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
1122 
1123     /**
1124      * @dev initializes a new Owned instance
1125      */
1126     constructor() public {
1127         owner = msg.sender;
1128     }
1129 
1130     // allows execution by the owner only
1131     modifier ownerOnly {
1132         _ownerOnly();
1133         _;
1134     }
1135 
1136     // error message binary size optimization
1137     function _ownerOnly() internal view {
1138         require(msg.sender == owner, "ERR_ACCESS_DENIED");
1139     }
1140 
1141     /**
1142      * @dev allows transferring the contract ownership
1143      * the new owner still needs to accept the transfer
1144      * can only be called by the contract owner
1145      *
1146      * @param _newOwner    new contract owner
1147      */
1148     function transferOwnership(address _newOwner) public override ownerOnly {
1149         require(_newOwner != owner, "ERR_SAME_OWNER");
1150         newOwner = _newOwner;
1151     }
1152 
1153     /**
1154      * @dev used by a new owner to accept an ownership transfer
1155      */
1156     function acceptOwnership() public override {
1157         require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
1158         emit OwnerUpdate(owner, newOwner);
1159         owner = newOwner;
1160         newOwner = address(0);
1161     }
1162 }
1163 
1164 // File: solidity/contracts/utility/Utils.sol
1165 
1166 
1167 pragma solidity 0.6.12;
1168 
1169 /**
1170  * @dev Utilities & Common Modifiers
1171  */
1172 contract Utils {
1173     // verifies that a value is greater than zero
1174     modifier greaterThanZero(uint256 _value) {
1175         _greaterThanZero(_value);
1176         _;
1177     }
1178 
1179     // error message binary size optimization
1180     function _greaterThanZero(uint256 _value) internal pure {
1181         require(_value > 0, "ERR_ZERO_VALUE");
1182     }
1183 
1184     // validates an address - currently only checks that it isn't null
1185     modifier validAddress(address _address) {
1186         _validAddress(_address);
1187         _;
1188     }
1189 
1190     // error message binary size optimization
1191     function _validAddress(address _address) internal pure {
1192         require(_address != address(0), "ERR_INVALID_ADDRESS");
1193     }
1194 
1195     // verifies that the address is different than this contract address
1196     modifier notThis(address _address) {
1197         _notThis(_address);
1198         _;
1199     }
1200 
1201     // error message binary size optimization
1202     function _notThis(address _address) internal view {
1203         require(_address != address(this), "ERR_ADDRESS_IS_SELF");
1204     }
1205 
1206     // validates an external address - currently only checks that it isn't null or this
1207     modifier validExternalAddress(address _address) {
1208         _validExternalAddress(_address);
1209         _;
1210     }
1211 
1212     // error message binary size optimization
1213     function _validExternalAddress(address _address) internal view {
1214         require(_address != address(0) && _address != address(this), "ERR_INVALID_EXTERNAL_ADDRESS");
1215     }
1216 }
1217 
1218 // File: solidity/contracts/utility/interfaces/IContractRegistry.sol
1219 
1220 
1221 pragma solidity 0.6.12;
1222 
1223 /*
1224     Contract Registry interface
1225 */
1226 interface IContractRegistry {
1227     function addressOf(bytes32 _contractName) external view returns (address);
1228 }
1229 
1230 // File: solidity/contracts/utility/ContractRegistryClient.sol
1231 
1232 
1233 pragma solidity 0.6.12;
1234 
1235 
1236 
1237 
1238 /**
1239  * @dev This is the base contract for ContractRegistry clients.
1240  */
1241 contract ContractRegistryClient is Owned, Utils {
1242     bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
1243     bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
1244     bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
1245     bytes32 internal constant CONVERTER_FACTORY = "ConverterFactory";
1246     bytes32 internal constant CONVERSION_PATH_FINDER = "ConversionPathFinder";
1247     bytes32 internal constant CONVERTER_UPGRADER = "BancorConverterUpgrader";
1248     bytes32 internal constant CONVERTER_REGISTRY = "BancorConverterRegistry";
1249     bytes32 internal constant CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
1250     bytes32 internal constant BNT_TOKEN = "BNTToken";
1251     bytes32 internal constant BANCOR_X = "BancorX";
1252     bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";
1253     bytes32 internal constant LIQUIDITY_PROTECTION = "LiquidityProtection";
1254 
1255     IContractRegistry public registry; // address of the current contract-registry
1256     IContractRegistry public prevRegistry; // address of the previous contract-registry
1257     bool public onlyOwnerCanUpdateRegistry; // only an owner can update the contract-registry
1258 
1259     /**
1260      * @dev verifies that the caller is mapped to the given contract name
1261      *
1262      * @param _contractName    contract name
1263      */
1264     modifier only(bytes32 _contractName) {
1265         _only(_contractName);
1266         _;
1267     }
1268 
1269     // error message binary size optimization
1270     function _only(bytes32 _contractName) internal view {
1271         require(msg.sender == addressOf(_contractName), "ERR_ACCESS_DENIED");
1272     }
1273 
1274     /**
1275      * @dev initializes a new ContractRegistryClient instance
1276      *
1277      * @param  _registry   address of a contract-registry contract
1278      */
1279     constructor(IContractRegistry _registry) internal validAddress(address(_registry)) {
1280         registry = IContractRegistry(_registry);
1281         prevRegistry = IContractRegistry(_registry);
1282     }
1283 
1284     /**
1285      * @dev updates to the new contract-registry
1286      */
1287     function updateRegistry() public {
1288         // verify that this function is permitted
1289         require(msg.sender == owner || !onlyOwnerCanUpdateRegistry, "ERR_ACCESS_DENIED");
1290 
1291         // get the new contract-registry
1292         IContractRegistry newRegistry = IContractRegistry(addressOf(CONTRACT_REGISTRY));
1293 
1294         // verify that the new contract-registry is different and not zero
1295         require(newRegistry != registry && address(newRegistry) != address(0), "ERR_INVALID_REGISTRY");
1296 
1297         // verify that the new contract-registry is pointing to a non-zero contract-registry
1298         require(newRegistry.addressOf(CONTRACT_REGISTRY) != address(0), "ERR_INVALID_REGISTRY");
1299 
1300         // save a backup of the current contract-registry before replacing it
1301         prevRegistry = registry;
1302 
1303         // replace the current contract-registry with the new contract-registry
1304         registry = newRegistry;
1305     }
1306 
1307     /**
1308      * @dev restores the previous contract-registry
1309      */
1310     function restoreRegistry() public ownerOnly {
1311         // restore the previous contract-registry
1312         registry = prevRegistry;
1313     }
1314 
1315     /**
1316      * @dev restricts the permission to update the contract-registry
1317      *
1318      * @param _onlyOwnerCanUpdateRegistry  indicates whether or not permission is restricted to owner only
1319      */
1320     function restrictRegistryUpdate(bool _onlyOwnerCanUpdateRegistry) public ownerOnly {
1321         // change the permission to update the contract-registry
1322         onlyOwnerCanUpdateRegistry = _onlyOwnerCanUpdateRegistry;
1323     }
1324 
1325     /**
1326      * @dev returns the address associated with the given contract name
1327      *
1328      * @param _contractName    contract name
1329      *
1330      * @return contract address
1331      */
1332     function addressOf(bytes32 _contractName) internal view returns (address) {
1333         return registry.addressOf(_contractName);
1334     }
1335 }
1336 
1337 // File: solidity/contracts/liquidity-protection/LiquidityProtectionSettings.sol
1338 
1339 
1340 pragma solidity 0.6.12;
1341 
1342 
1343 
1344 
1345 
1346 
1347 
1348 
1349 
1350 /**
1351  * @dev Liquidity Protection Settings contract
1352  */
1353 contract LiquidityProtectionSettings is ILiquidityProtectionSettings, AccessControl, ContractRegistryClient {
1354     using SafeMath for uint256;
1355     using EnumerableSet for EnumerableSet.AddressSet;
1356 
1357     // the owner role is used to update the settings
1358     bytes32 public constant ROLE_OWNER = keccak256("ROLE_OWNER");
1359 
1360     uint32 private constant PPM_RESOLUTION = 1000000;
1361 
1362     IERC20Token private immutable _networkToken;
1363 
1364     // list of whitelisted pools
1365     EnumerableSet.AddressSet private _poolWhitelist;
1366 
1367     // list of subscribers
1368     EnumerableSet.AddressSet private _subscribers;
1369 
1370     // network token minting limits
1371     uint256 private _minNetworkTokenLiquidityForMinting = 1000e18;
1372     uint256 private _defaultNetworkTokenMintingLimit = 20000e18;
1373     mapping(IConverterAnchor => uint256) private _networkTokenMintingLimits;
1374 
1375     // permission of adding liquidity for a given reserve on a given pool
1376     mapping(IConverterAnchor => mapping(IERC20Token => bool)) private _addLiquidityDisabled;
1377 
1378     // number of seconds until any protection is in effect
1379     uint256 private _minProtectionDelay = 30 days;
1380 
1381     // number of seconds until full protection is in effect
1382     uint256 private _maxProtectionDelay = 100 days;
1383 
1384     // minimum amount of network tokens that the system can mint as compensation for base token losses
1385     uint256 private _minNetworkCompensation = 1e16; // = 0.01 network tokens
1386 
1387     // number of seconds from liquidation to full network token release
1388     uint256 private _lockDuration = 24 hours;
1389 
1390     // maximum deviation of the average rate from the spot rate
1391     uint32 private _averageRateMaxDeviation = 5000; // PPM units
1392 
1393     /**
1394      * @dev triggered when the pool whitelist is updated
1395      *
1396      * @param poolAnchor    pool anchor
1397      * @param added         true if the pool was added to the whitelist, false if it was removed
1398      */
1399     event PoolWhitelistUpdated(IConverterAnchor indexed poolAnchor, bool added);
1400 
1401     /**
1402      * @dev triggered when a subscriber is added or removed
1403      *
1404      * @param subscriber    subscriber
1405      * @param added         true if the subscriber was added, false if it was removed
1406      */
1407     event SubscriberUpdated(ILiquidityProtectionEventsSubscriber indexed subscriber, bool added);
1408 
1409     /**
1410      * @dev triggered when the minimum amount of network token liquidity to allow minting is updated
1411      *
1412      * @param prevMin   previous minimum amount of network token liquidity for minting
1413      * @param newMin    new minimum amount of network token liquidity for minting
1414      */
1415     event MinNetworkTokenLiquidityForMintingUpdated(uint256 prevMin, uint256 newMin);
1416 
1417     /**
1418      * @dev triggered when the default network token minting limit is updated
1419      *
1420      * @param prevDefault   previous default network token minting limit
1421      * @param newDefault    new default network token minting limit
1422      */
1423     event DefaultNetworkTokenMintingLimitUpdated(uint256 prevDefault, uint256 newDefault);
1424 
1425     /**
1426      * @dev triggered when a pool network token minting limit is updated
1427      *
1428      * @param poolAnchor    pool anchor
1429      * @param prevLimit     previous limit
1430      * @param newLimit      new limit
1431      */
1432     event NetworkTokenMintingLimitUpdated(IConverterAnchor indexed poolAnchor, uint256 prevLimit, uint256 newLimit);
1433 
1434     /**
1435      * @dev triggered when the protection delays are updated
1436      *
1437      * @param prevMinProtectionDelay    previous seconds until the protection starts
1438      * @param newMinProtectionDelay     new seconds until the protection starts
1439      * @param prevMaxProtectionDelay    previous seconds until full protection
1440      * @param newMaxProtectionDelay     new seconds until full protection
1441      */
1442     event ProtectionDelaysUpdated(
1443         uint256 prevMinProtectionDelay,
1444         uint256 newMinProtectionDelay,
1445         uint256 prevMaxProtectionDelay,
1446         uint256 newMaxProtectionDelay
1447     );
1448 
1449     /**
1450      * @dev triggered when the minimum network token compensation is updated
1451      *
1452      * @param prevMinNetworkCompensation    previous minimum network token compensation
1453      * @param newMinNetworkCompensation     new minimum network token compensation
1454      */
1455     event MinNetworkCompensationUpdated(uint256 prevMinNetworkCompensation, uint256 newMinNetworkCompensation);
1456 
1457     /**
1458      * @dev triggered when the network token lock duration is updated
1459      *
1460      * @param prevLockDuration  previous network token lock duration, in seconds
1461      * @param newLockDuration   new network token lock duration, in seconds
1462      */
1463     event LockDurationUpdated(uint256 prevLockDuration, uint256 newLockDuration);
1464 
1465     /**
1466      * @dev triggered when the maximum deviation of the average rate from the spot rate is updated
1467      *
1468      * @param prevAverageRateMaxDeviation   previous maximum deviation of the average rate from the spot rate
1469      * @param newAverageRateMaxDeviation    new maximum deviation of the average rate from the spot rate
1470      */
1471     event AverageRateMaxDeviationUpdated(uint32 prevAverageRateMaxDeviation, uint32 newAverageRateMaxDeviation);
1472 
1473     /**
1474      * @dev triggered when adding liquidity is disabled or enabled for a given reserve on a given pool
1475      *
1476      * @param poolAnchor    pool anchor
1477      * @param reserveToken  reserve token
1478      * @param disabled      true if disabled, false otherwise
1479      */
1480     event AddLiquidityDisabled(IConverterAnchor indexed poolAnchor, IERC20Token indexed reserveToken, bool disabled);
1481 
1482     /**
1483      * @dev initializes a new LiquidityProtectionSettings contract
1484      *
1485      * @param registry  contract registry
1486      * @param token     the network token
1487      */
1488     constructor(IERC20Token token, IContractRegistry registry)
1489         public
1490         ContractRegistryClient(registry)
1491         validAddress(address(token))
1492         notThis(address(token))
1493     {
1494         // set up administrative roles.
1495         _setRoleAdmin(ROLE_OWNER, ROLE_OWNER);
1496 
1497         // allow the deployer to initially govern the contract.
1498         _setupRole(ROLE_OWNER, msg.sender);
1499 
1500         _networkToken = token;
1501     }
1502 
1503     modifier onlyOwner() {
1504         _onlyOwner();
1505         _;
1506     }
1507 
1508     // error message binary size optimization
1509     function _onlyOwner() internal view {
1510         require(hasRole(ROLE_OWNER, msg.sender), "ERR_ACCESS_DENIED");
1511     }
1512 
1513     // ensures that the portion is valid
1514     modifier validPortion(uint32 portion) {
1515         _validPortion(portion);
1516         _;
1517     }
1518 
1519     // error message binary size optimization
1520     function _validPortion(uint32 portion) internal pure {
1521         require(portion > 0 && portion <= PPM_RESOLUTION, "ERR_INVALID_PORTION");
1522     }
1523 
1524     /**
1525      * @dev returns the network token
1526      *
1527      * @return the network token
1528      */
1529     function networkToken() external view returns (IERC20Token) {
1530         return _networkToken;
1531     }
1532 
1533     /**
1534      * @dev returns the minimum network token liquidity for minting
1535      *
1536      * @return the minimum network token liquidity for minting
1537      */
1538     function minNetworkTokenLiquidityForMinting() external view override returns (uint256) {
1539         return _minNetworkTokenLiquidityForMinting;
1540     }
1541 
1542     /**
1543      * @dev returns the default network token minting limit
1544      *
1545      * @return the default network token minting limit
1546      */
1547     function defaultNetworkTokenMintingLimit() external view override returns (uint256) {
1548         return _defaultNetworkTokenMintingLimit;
1549     }
1550 
1551     /**
1552      * @dev returns the network token minting limit for a given pool
1553      *
1554      * @param poolAnchor    pool anchor
1555      * @return the network token minting limit for a given pool
1556      */
1557     function networkTokenMintingLimits(IConverterAnchor poolAnchor) external view override returns (uint256) {
1558         return _networkTokenMintingLimits[poolAnchor];
1559     }
1560 
1561     /**
1562      * @dev returns the permission of adding liquidity for a given reserve on a given pool
1563      *
1564      * @param poolAnchor    pool anchor
1565      * @param reserveToken  reserve token
1566      * @return true if adding liquidity is disabled, false otherwise
1567      */
1568     function addLiquidityDisabled(IConverterAnchor poolAnchor, IERC20Token reserveToken)
1569         external
1570         view
1571         override
1572         returns (bool)
1573     {
1574         return _addLiquidityDisabled[poolAnchor][reserveToken];
1575     }
1576 
1577     /**
1578      * @dev returns the minimum number of seconds until any protection is in effect
1579      *
1580      * @return the minimum number of seconds until any protection is in effect
1581      */
1582     function minProtectionDelay() external view override returns (uint256) {
1583         return _minProtectionDelay;
1584     }
1585 
1586     /**
1587      * @dev returns the maximum number of seconds until full protection is in effect
1588      *
1589      * @return the maximum number of seconds until full protection is in effect
1590      */
1591     function maxProtectionDelay() external view override returns (uint256) {
1592         return _maxProtectionDelay;
1593     }
1594 
1595     /**
1596      * @dev returns the minimum amount of network tokens that the system can mint as compensation for base token losses
1597      *
1598      * @return the minimum amount of network tokens that the system can mint as compensation for base token losses
1599      */
1600     function minNetworkCompensation() external view override returns (uint256) {
1601         return _minNetworkCompensation;
1602     }
1603 
1604     /**
1605      * @dev returns the number of seconds from liquidation to full network token release
1606      *
1607      * @return the number of seconds from liquidation to full network token release
1608      */
1609     function lockDuration() external view override returns (uint256) {
1610         return _lockDuration;
1611     }
1612 
1613     /**
1614      * @dev returns the maximum deviation of the average rate from the spot rate
1615      *
1616      * @return the maximum deviation of the average rate from the spot rate
1617      */
1618     function averageRateMaxDeviation() external view override returns (uint32) {
1619         return _averageRateMaxDeviation;
1620     }
1621 
1622     /**
1623      * @dev adds a pool to the whitelist
1624      * can only be called by the contract owner
1625      *
1626      * @param poolAnchor    pool anchor
1627      */
1628     function addPoolToWhitelist(IConverterAnchor poolAnchor)
1629         external
1630         onlyOwner
1631         validAddress(address(poolAnchor))
1632         notThis(address(poolAnchor))
1633     {
1634         require(_poolWhitelist.add(address(poolAnchor)), "ERR_POOL_ALREADY_WHITELISTED");
1635 
1636         emit PoolWhitelistUpdated(poolAnchor, true);
1637     }
1638 
1639     /**
1640      * @dev removes a pool from the whitelist
1641      * can only be called by the contract owner
1642      *
1643      * @param poolAnchor    pool anchor
1644      */
1645     function removePoolFromWhitelist(IConverterAnchor poolAnchor)
1646         external
1647         onlyOwner
1648         validAddress(address(poolAnchor))
1649         notThis(address(poolAnchor))
1650     {
1651         require(_poolWhitelist.remove(address(poolAnchor)), "ERR_POOL_NOT_WHITELISTED");
1652 
1653         emit PoolWhitelistUpdated(poolAnchor, false);
1654     }
1655 
1656     /**
1657      * @dev checks whether a given pool is whitelisted
1658      *
1659      * @param poolAnchor    pool anchor
1660      * @return true if the given pool is whitelisted, false otherwise
1661      */
1662     function isPoolWhitelisted(IConverterAnchor poolAnchor) external view override returns (bool) {
1663         return _poolWhitelist.contains(address(poolAnchor));
1664     }
1665 
1666     /**
1667      * @dev returns pools whitelist
1668      *
1669      * @return pools whitelist
1670      */
1671     function poolWhitelist() external view override returns (address[] memory) {
1672         uint256 length = _poolWhitelist.length();
1673         address[] memory list = new address[](length);
1674         for (uint256 i = 0; i < length; i++) {
1675             list[i] = _poolWhitelist.at(i);
1676         }
1677         return list;
1678     }
1679 
1680     /**
1681      * @dev adds a subscriber
1682      * can only be called by the contract owner
1683      *
1684      * @param subscriber    subscriber address
1685      */
1686     function addSubscriber(ILiquidityProtectionEventsSubscriber subscriber)
1687         external
1688         onlyOwner
1689         validAddress(address(subscriber))
1690         notThis(address(subscriber))
1691     {
1692         require(_subscribers.add(address(subscriber)), "ERR_SUBSCRIBER_ALREADY_SET");
1693 
1694         emit SubscriberUpdated(subscriber, true);
1695     }
1696 
1697     /**
1698      * @dev removes a subscriber
1699      * can only be called by the contract owner
1700      *
1701      * @param subscriber    subscriber address
1702      */
1703     function removeSubscriber(ILiquidityProtectionEventsSubscriber subscriber)
1704         external
1705         onlyOwner
1706         validAddress(address(subscriber))
1707         notThis(address(subscriber))
1708     {
1709         require(_subscribers.remove(address(subscriber)), "ERR_INVALID_SUBSCRIBER");
1710 
1711         emit SubscriberUpdated(subscriber, false);
1712     }
1713 
1714     /**
1715      * @dev returns subscribers list
1716      *
1717      * @return subscribers list
1718      */
1719     function subscribers() external view override returns (address[] memory) {
1720         uint256 length = _subscribers.length();
1721         address[] memory list = new address[](length);
1722         for (uint256 i = 0; i < length; i++) {
1723             list[i] = _subscribers.at(i);
1724         }
1725         return list;
1726     }
1727 
1728     /**
1729      * @dev updates the minimum amount of network token liquidity to allow minting
1730      * can only be called by the contract owner
1731      *
1732      * @param amount   the minimum amount of network token liquidity to allow minting
1733      */
1734     function setMinNetworkTokenLiquidityForMinting(uint256 amount) external onlyOwner() {
1735         emit MinNetworkTokenLiquidityForMintingUpdated(_minNetworkTokenLiquidityForMinting, amount);
1736 
1737         _minNetworkTokenLiquidityForMinting = amount;
1738     }
1739 
1740     /**
1741      * @dev updates the default amount of network token that the system can mint into each pool
1742      * can only be called by the contract owner
1743      *
1744      * @param amount    the default amount of network token that the system can mint into each pool
1745      */
1746     function setDefaultNetworkTokenMintingLimit(uint256 amount) external onlyOwner() {
1747         emit DefaultNetworkTokenMintingLimitUpdated(_defaultNetworkTokenMintingLimit, amount);
1748 
1749         _defaultNetworkTokenMintingLimit = amount;
1750     }
1751 
1752     /**
1753      * @dev updates the amount of network tokens that the system can mint into a specific pool
1754      * can only be called by the contract owner
1755      *
1756      * @param poolAnchor    pool anchor
1757      * @param amount        the amount of network tokens that the system can mint into a specific pool
1758      */
1759     function setNetworkTokenMintingLimit(IConverterAnchor poolAnchor, uint256 amount)
1760         external
1761         onlyOwner()
1762         validAddress(address(poolAnchor))
1763     {
1764         emit NetworkTokenMintingLimitUpdated(poolAnchor, _networkTokenMintingLimits[poolAnchor], amount);
1765 
1766         _networkTokenMintingLimits[poolAnchor] = amount;
1767     }
1768 
1769     /**
1770      * @dev updates the protection delays
1771      * can only be called by the contract owner
1772      *
1773      * @param minDelay   seconds until the protection starts
1774      * @param maxDelay   seconds until full protection
1775      */
1776     function setProtectionDelays(uint256 minDelay, uint256 maxDelay) external onlyOwner() {
1777         require(minDelay < maxDelay, "ERR_INVALID_PROTECTION_DELAY");
1778 
1779         emit ProtectionDelaysUpdated(_minProtectionDelay, minDelay, _maxProtectionDelay, maxDelay);
1780 
1781         _minProtectionDelay = minDelay;
1782         _maxProtectionDelay = maxDelay;
1783     }
1784 
1785     /**
1786      * @dev updates the minimum amount of network token compensation
1787      * can only be called by the contract owner
1788      *
1789      * @param amount    the minimum amount of network token compensation
1790      */
1791     function setMinNetworkCompensation(uint256 amount) external onlyOwner() {
1792         emit MinNetworkCompensationUpdated(_minNetworkCompensation, amount);
1793 
1794         _minNetworkCompensation = amount;
1795     }
1796 
1797     /**
1798      * @dev updates the network token lock duration
1799      * can only be called by the contract owner
1800      *
1801      * @param duration  network token lock duration, in seconds
1802      */
1803     function setLockDuration(uint256 duration) external onlyOwner() {
1804         emit LockDurationUpdated(_lockDuration, duration);
1805 
1806         _lockDuration = duration;
1807     }
1808 
1809     /**
1810      * @dev sets the maximum deviation of the average rate from the spot rate
1811      * can only be called by the contract owner
1812      *
1813      * @param deviation maximum deviation of the average rate from the spot rate
1814      */
1815     function setAverageRateMaxDeviation(uint32 deviation) external onlyOwner() validPortion(deviation) {
1816         emit AverageRateMaxDeviationUpdated(_averageRateMaxDeviation, deviation);
1817 
1818         _averageRateMaxDeviation = deviation;
1819     }
1820 
1821     /**
1822      * @dev disables or enables adding liquidity for a given reserve on a given pool
1823      * can only be called by the contract owner
1824      *
1825      * @param poolAnchor    pool anchor
1826      * @param reserveToken  reserve token
1827      * @param disable       true to disable, false otherwise
1828      */
1829     function disableAddLiquidity(
1830         IConverterAnchor poolAnchor,
1831         IERC20Token reserveToken,
1832         bool disable
1833     ) external onlyOwner() {
1834         emit AddLiquidityDisabled(poolAnchor, reserveToken, disable);
1835 
1836         _addLiquidityDisabled[poolAnchor][reserveToken] = disable;
1837     }
1838 
1839     /**
1840      * @dev checks if protection is supported for the given pool
1841      * only standard pools are supported (2 reserves, 50%/50% weights)
1842      * note that the pool should still be whitelisted
1843      *
1844      * @param poolAnchor    anchor of the pool
1845      * @return true if the pool is supported, false otherwise
1846      */
1847     function isPoolSupported(IConverterAnchor poolAnchor) external view override returns (bool) {
1848         IERC20Token tmpNetworkToken = _networkToken;
1849 
1850         // verify that the pool exists in the registry
1851         IConverterRegistry converterRegistry = IConverterRegistry(addressOf(CONVERTER_REGISTRY));
1852         require(converterRegistry.isAnchor(address(poolAnchor)), "ERR_INVALID_ANCHOR");
1853 
1854         // get the converter
1855         IConverter converter = IConverter(payable(poolAnchor.owner()));
1856 
1857         // verify that the converter has 2 reserves
1858         if (converter.connectorTokenCount() != 2) {
1859             return false;
1860         }
1861 
1862         // verify that one of the reserves is the network token
1863         IERC20Token reserve0Token = converter.connectorTokens(0);
1864         IERC20Token reserve1Token = converter.connectorTokens(1);
1865         if (reserve0Token != tmpNetworkToken && reserve1Token != tmpNetworkToken) {
1866             return false;
1867         }
1868 
1869         // verify that the reserve weights are exactly 50%/50%
1870         if (
1871             converterReserveWeight(converter, reserve0Token) != PPM_RESOLUTION / 2 ||
1872             converterReserveWeight(converter, reserve1Token) != PPM_RESOLUTION / 2
1873         ) {
1874             return false;
1875         }
1876 
1877         return true;
1878     }
1879 
1880     // utility to get the reserve weight (including from older converters that don't support the new converterReserveWeight function)
1881     function converterReserveWeight(IConverter converter, IERC20Token reserveToken) private view returns (uint32) {
1882         (, uint32 weight, , , ) = converter.connectors(reserveToken);
1883         return weight;
1884     }
1885 }
