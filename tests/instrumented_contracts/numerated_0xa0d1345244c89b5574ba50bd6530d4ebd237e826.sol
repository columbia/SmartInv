1 // File @openzeppelin/contracts/math/SafeMath.sol@v3.2.0
2 
3 // SPDX-License-Identifier: GPLv2
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
163 
164 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.2.0
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
410 
411 // File @openzeppelin/contracts/utils/Address.sol@v3.2.0
412 
413 
414 
415 pragma solidity ^0.6.2;
416 
417 /**
418  * @dev Collection of functions related to the address type
419  */
420 library Address {
421     /**
422      * @dev Returns true if `account` is a contract.
423      *
424      * [IMPORTANT]
425      * ====
426      * It is unsafe to assume that an address for which this function returns
427      * false is an externally-owned account (EOA) and not a contract.
428      *
429      * Among others, `isContract` will return false for the following
430      * types of addresses:
431      *
432      *  - an externally-owned account
433      *  - a contract in construction
434      *  - an address where a contract will be created
435      *  - an address where a contract lived, but was destroyed
436      * ====
437      */
438     function isContract(address account) internal view returns (bool) {
439         // This method relies in extcodesize, which returns 0 for contracts in
440         // construction, since the code is only stored at the end of the
441         // constructor execution.
442 
443         uint256 size;
444         // solhint-disable-next-line no-inline-assembly
445         assembly { size := extcodesize(account) }
446         return size > 0;
447     }
448 
449     /**
450      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
451      * `recipient`, forwarding all available gas and reverting on errors.
452      *
453      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
454      * of certain opcodes, possibly making contracts go over the 2300 gas limit
455      * imposed by `transfer`, making them unable to receive funds via
456      * `transfer`. {sendValue} removes this limitation.
457      *
458      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
459      *
460      * IMPORTANT: because control is transferred to `recipient`, care must be
461      * taken to not create reentrancy vulnerabilities. Consider using
462      * {ReentrancyGuard} or the
463      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
464      */
465     function sendValue(address payable recipient, uint256 amount) internal {
466         require(address(this).balance >= amount, "Address: insufficient balance");
467 
468         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
469         (bool success, ) = recipient.call{ value: amount }("");
470         require(success, "Address: unable to send value, recipient may have reverted");
471     }
472 
473     /**
474      * @dev Performs a Solidity function call using a low level `call`. A
475      * plain`call` is an unsafe replacement for a function call: use this
476      * function instead.
477      *
478      * If `target` reverts with a revert reason, it is bubbled up by this
479      * function (like regular Solidity function calls).
480      *
481      * Returns the raw returned data. To convert to the expected return value,
482      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
483      *
484      * Requirements:
485      *
486      * - `target` must be a contract.
487      * - calling `target` with `data` must not revert.
488      *
489      * _Available since v3.1._
490      */
491     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
492       return functionCall(target, data, "Address: low-level call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
497      * `errorMessage` as a fallback revert reason when `target` reverts.
498      *
499      * _Available since v3.1._
500      */
501     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
502         return _functionCallWithValue(target, data, 0, errorMessage);
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
507      * but also transferring `value` wei to `target`.
508      *
509      * Requirements:
510      *
511      * - the calling contract must have an ETH balance of at least `value`.
512      * - the called Solidity function must be `payable`.
513      *
514      * _Available since v3.1._
515      */
516     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
517         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
522      * with `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
527         require(address(this).balance >= value, "Address: insufficient balance for call");
528         return _functionCallWithValue(target, data, value, errorMessage);
529     }
530 
531     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
532         require(isContract(target), "Address: call to non-contract");
533 
534         // solhint-disable-next-line avoid-low-level-calls
535         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
536         if (success) {
537             return returndata;
538         } else {
539             // Look for revert reason and bubble it up if present
540             if (returndata.length > 0) {
541                 // The easiest way to bubble the revert reason is using memory via assembly
542 
543                 // solhint-disable-next-line no-inline-assembly
544                 assembly {
545                     let returndata_size := mload(returndata)
546                     revert(add(32, returndata), returndata_size)
547                 }
548             } else {
549                 revert(errorMessage);
550             }
551         }
552     }
553 }
554 
555 
556 // File @openzeppelin/contracts/GSN/Context.sol@v3.2.0
557 
558 
559 
560 pragma solidity ^0.6.0;
561 
562 /*
563  * @dev Provides information about the current execution context, including the
564  * sender of the transaction and its data. While these are generally available
565  * via msg.sender and msg.data, they should not be accessed in such a direct
566  * manner, since when dealing with GSN meta-transactions the account sending and
567  * paying for execution may not be the actual sender (as far as an application
568  * is concerned).
569  *
570  * This contract is only required for intermediate, library-like contracts.
571  */
572 abstract contract Context {
573     function _msgSender() internal view virtual returns (address payable) {
574         return msg.sender;
575     }
576 
577     function _msgData() internal view virtual returns (bytes memory) {
578         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
579         return msg.data;
580     }
581 }
582 
583 
584 // File @openzeppelin/contracts/access/AccessControl.sol@v3.2.0
585 
586 
587 
588 pragma solidity ^0.6.0;
589 
590 
591 
592 /**
593  * @dev Contract module that allows children to implement role-based access
594  * control mechanisms.
595  *
596  * Roles are referred to by their `bytes32` identifier. These should be exposed
597  * in the external API and be unique. The best way to achieve this is by
598  * using `public constant` hash digests:
599  *
600  * ```
601  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
602  * ```
603  *
604  * Roles can be used to represent a set of permissions. To restrict access to a
605  * function call, use {hasRole}:
606  *
607  * ```
608  * function foo() public {
609  *     require(hasRole(MY_ROLE, msg.sender));
610  *     ...
611  * }
612  * ```
613  *
614  * Roles can be granted and revoked dynamically via the {grantRole} and
615  * {revokeRole} functions. Each role has an associated admin role, and only
616  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
617  *
618  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
619  * that only accounts with this role will be able to grant or revoke other
620  * roles. More complex role relationships can be created by using
621  * {_setRoleAdmin}.
622  *
623  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
624  * grant and revoke this role. Extra precautions should be taken to secure
625  * accounts that have been granted it.
626  */
627 abstract contract AccessControl is Context {
628     using EnumerableSet for EnumerableSet.AddressSet;
629     using Address for address;
630 
631     struct RoleData {
632         EnumerableSet.AddressSet members;
633         bytes32 adminRole;
634     }
635 
636     mapping (bytes32 => RoleData) private _roles;
637 
638     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
639 
640     /**
641      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
642      *
643      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
644      * {RoleAdminChanged} not being emitted signaling this.
645      *
646      * _Available since v3.1._
647      */
648     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
649 
650     /**
651      * @dev Emitted when `account` is granted `role`.
652      *
653      * `sender` is the account that originated the contract call, an admin role
654      * bearer except when using {_setupRole}.
655      */
656     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
657 
658     /**
659      * @dev Emitted when `account` is revoked `role`.
660      *
661      * `sender` is the account that originated the contract call:
662      *   - if using `revokeRole`, it is the admin role bearer
663      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
664      */
665     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
666 
667     /**
668      * @dev Returns `true` if `account` has been granted `role`.
669      */
670     function hasRole(bytes32 role, address account) public view returns (bool) {
671         return _roles[role].members.contains(account);
672     }
673 
674     /**
675      * @dev Returns the number of accounts that have `role`. Can be used
676      * together with {getRoleMember} to enumerate all bearers of a role.
677      */
678     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
679         return _roles[role].members.length();
680     }
681 
682     /**
683      * @dev Returns one of the accounts that have `role`. `index` must be a
684      * value between 0 and {getRoleMemberCount}, non-inclusive.
685      *
686      * Role bearers are not sorted in any particular way, and their ordering may
687      * change at any point.
688      *
689      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
690      * you perform all queries on the same block. See the following
691      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
692      * for more information.
693      */
694     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
695         return _roles[role].members.at(index);
696     }
697 
698     /**
699      * @dev Returns the admin role that controls `role`. See {grantRole} and
700      * {revokeRole}.
701      *
702      * To change a role's admin, use {_setRoleAdmin}.
703      */
704     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
705         return _roles[role].adminRole;
706     }
707 
708     /**
709      * @dev Grants `role` to `account`.
710      *
711      * If `account` had not been already granted `role`, emits a {RoleGranted}
712      * event.
713      *
714      * Requirements:
715      *
716      * - the caller must have ``role``'s admin role.
717      */
718     function grantRole(bytes32 role, address account) public virtual {
719         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
720 
721         _grantRole(role, account);
722     }
723 
724     /**
725      * @dev Revokes `role` from `account`.
726      *
727      * If `account` had been granted `role`, emits a {RoleRevoked} event.
728      *
729      * Requirements:
730      *
731      * - the caller must have ``role``'s admin role.
732      */
733     function revokeRole(bytes32 role, address account) public virtual {
734         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
735 
736         _revokeRole(role, account);
737     }
738 
739     /**
740      * @dev Revokes `role` from the calling account.
741      *
742      * Roles are often managed via {grantRole} and {revokeRole}: this function's
743      * purpose is to provide a mechanism for accounts to lose their privileges
744      * if they are compromised (such as when a trusted device is misplaced).
745      *
746      * If the calling account had been granted `role`, emits a {RoleRevoked}
747      * event.
748      *
749      * Requirements:
750      *
751      * - the caller must be `account`.
752      */
753     function renounceRole(bytes32 role, address account) public virtual {
754         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
755 
756         _revokeRole(role, account);
757     }
758 
759     /**
760      * @dev Grants `role` to `account`.
761      *
762      * If `account` had not been already granted `role`, emits a {RoleGranted}
763      * event. Note that unlike {grantRole}, this function doesn't perform any
764      * checks on the calling account.
765      *
766      * [WARNING]
767      * ====
768      * This function should only be called from the constructor when setting
769      * up the initial roles for the system.
770      *
771      * Using this function in any other way is effectively circumventing the admin
772      * system imposed by {AccessControl}.
773      * ====
774      */
775     function _setupRole(bytes32 role, address account) internal virtual {
776         _grantRole(role, account);
777     }
778 
779     /**
780      * @dev Sets `adminRole` as ``role``'s admin role.
781      *
782      * Emits a {RoleAdminChanged} event.
783      */
784     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
785         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
786         _roles[role].adminRole = adminRole;
787     }
788 
789     function _grantRole(bytes32 role, address account) private {
790         if (_roles[role].members.add(account)) {
791             emit RoleGranted(role, account, _msgSender());
792         }
793     }
794 
795     function _revokeRole(bytes32 role, address account) private {
796         if (_roles[role].members.remove(account)) {
797             emit RoleRevoked(role, account, _msgSender());
798         }
799     }
800 }
801 
802 
803 // File contracts/DigitalaxAccessControls.sol
804 
805 pragma solidity 0.6.12;
806 
807 /**
808  * @notice Access Controls contract for the Digitalax Platform
809  * @author BlockRocket.tech
810  */
811 contract DigitalaxAccessControls is AccessControl {
812     /// @notice Role definitions
813     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
814     bytes32 public constant SMART_CONTRACT_ROLE = keccak256("SMART_CONTRACT_ROLE");
815 
816     /// @notice Events for adding and removing various roles
817     event AdminRoleGranted(
818         address indexed beneficiary,
819         address indexed caller
820     );
821 
822     event AdminRoleRemoved(
823         address indexed beneficiary,
824         address indexed caller
825     );
826 
827     event MinterRoleGranted(
828         address indexed beneficiary,
829         address indexed caller
830     );
831 
832     event MinterRoleRemoved(
833         address indexed beneficiary,
834         address indexed caller
835     );
836 
837     event SmartContractRoleGranted(
838         address indexed beneficiary,
839         address indexed caller
840     );
841 
842     event SmartContractRoleRemoved(
843         address indexed beneficiary,
844         address indexed caller
845     );
846 
847     /**
848      * @notice The deployer is automatically given the admin role which will allow them to then grant roles to other addresses
849      */
850     constructor() public {
851         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
852     }
853 
854     /////////////
855     // Lookups //
856     /////////////
857 
858     /**
859      * @notice Used to check whether an address has the admin role
860      * @param _address EOA or contract being checked
861      * @return bool True if the account has the role or false if it does not
862      */
863     function hasAdminRole(address _address) external view returns (bool) {
864         return hasRole(DEFAULT_ADMIN_ROLE, _address);
865     }
866 
867     /**
868      * @notice Used to check whether an address has the minter role
869      * @param _address EOA or contract being checked
870      * @return bool True if the account has the role or false if it does not
871      */
872     function hasMinterRole(address _address) external view returns (bool) {
873         return hasRole(MINTER_ROLE, _address);
874     }
875 
876     /**
877      * @notice Used to check whether an address has the smart contract role
878      * @param _address EOA or contract being checked
879      * @return bool True if the account has the role or false if it does not
880      */
881     function hasSmartContractRole(address _address) external view returns (bool) {
882         return hasRole(SMART_CONTRACT_ROLE, _address);
883     }
884 
885     ///////////////
886     // Modifiers //
887     ///////////////
888 
889     /**
890      * @notice Grants the admin role to an address
891      * @dev The sender must have the admin role
892      * @param _address EOA or contract receiving the new role
893      */
894     function addAdminRole(address _address) external {
895         grantRole(DEFAULT_ADMIN_ROLE, _address);
896         emit AdminRoleGranted(_address, _msgSender());
897     }
898 
899     /**
900      * @notice Removes the admin role from an address
901      * @dev The sender must have the admin role
902      * @param _address EOA or contract affected
903      */
904     function removeAdminRole(address _address) external {
905         revokeRole(DEFAULT_ADMIN_ROLE, _address);
906         emit AdminRoleRemoved(_address, _msgSender());
907     }
908 
909     /**
910      * @notice Grants the minter role to an address
911      * @dev The sender must have the admin role
912      * @param _address EOA or contract receiving the new role
913      */
914     function addMinterRole(address _address) external {
915         grantRole(MINTER_ROLE, _address);
916         emit MinterRoleGranted(_address, _msgSender());
917     }
918 
919     /**
920      * @notice Removes the minter role from an address
921      * @dev The sender must have the admin role
922      * @param _address EOA or contract affected
923      */
924     function removeMinterRole(address _address) external {
925         revokeRole(MINTER_ROLE, _address);
926         emit MinterRoleRemoved(_address, _msgSender());
927     }
928 
929     /**
930      * @notice Grants the smart contract role to an address
931      * @dev The sender must have the admin role
932      * @param _address EOA or contract receiving the new role
933      */
934     function addSmartContractRole(address _address) external {
935         grantRole(SMART_CONTRACT_ROLE, _address);
936         emit SmartContractRoleGranted(_address, _msgSender());
937     }
938 
939     /**
940      * @notice Removes the smart contract role from an address
941      * @dev The sender must have the admin role
942      * @param _address EOA or contract affected
943      */
944     function removeSmartContractRole(address _address) external {
945         revokeRole(SMART_CONTRACT_ROLE, _address);
946         emit SmartContractRoleRemoved(_address, _msgSender());
947     }
948 }
949 
950 
951 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.2.0
952 
953 
954 
955 pragma solidity ^0.6.0;
956 
957 /**
958  * @dev Interface of the ERC20 standard as defined in the EIP.
959  */
960 interface IERC20 {
961     /**
962      * @dev Returns the amount of tokens in existence.
963      */
964     function totalSupply() external view returns (uint256);
965 
966     /**
967      * @dev Returns the amount of tokens owned by `account`.
968      */
969     function balanceOf(address account) external view returns (uint256);
970 
971     /**
972      * @dev Moves `amount` tokens from the caller's account to `recipient`.
973      *
974      * Returns a boolean value indicating whether the operation succeeded.
975      *
976      * Emits a {Transfer} event.
977      */
978     function transfer(address recipient, uint256 amount) external returns (bool);
979 
980     /**
981      * @dev Returns the remaining number of tokens that `spender` will be
982      * allowed to spend on behalf of `owner` through {transferFrom}. This is
983      * zero by default.
984      *
985      * This value changes when {approve} or {transferFrom} are called.
986      */
987     function allowance(address owner, address spender) external view returns (uint256);
988 
989     /**
990      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
991      *
992      * Returns a boolean value indicating whether the operation succeeded.
993      *
994      * IMPORTANT: Beware that changing an allowance with this method brings the risk
995      * that someone may use both the old and the new allowance by unfortunate
996      * transaction ordering. One possible solution to mitigate this race
997      * condition is to first reduce the spender's allowance to 0 and set the
998      * desired value afterwards:
999      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1000      *
1001      * Emits an {Approval} event.
1002      */
1003     function approve(address spender, uint256 amount) external returns (bool);
1004 
1005     /**
1006      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1007      * allowance mechanism. `amount` is then deducted from the caller's
1008      * allowance.
1009      *
1010      * Returns a boolean value indicating whether the operation succeeded.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1015 
1016     /**
1017      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1018      * another (`to`).
1019      *
1020      * Note that `value` may be zero.
1021      */
1022     event Transfer(address indexed from, address indexed to, uint256 value);
1023 
1024     /**
1025      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1026      * a call to {approve}. `value` is the new allowance.
1027      */
1028     event Approval(address indexed owner, address indexed spender, uint256 value);
1029 }
1030 
1031 
1032 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.2.0
1033 
1034 
1035 
1036 pragma solidity ^0.6.0;
1037 
1038 
1039 
1040 /**
1041  * @title SafeERC20
1042  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1043  * contract returns false). Tokens that return no value (and instead revert or
1044  * throw on failure) are also supported, non-reverting calls are assumed to be
1045  * successful.
1046  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1047  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1048  */
1049 library SafeERC20 {
1050     using SafeMath for uint256;
1051     using Address for address;
1052 
1053     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1054         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1055     }
1056 
1057     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1058         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1059     }
1060 
1061     /**
1062      * @dev Deprecated. This function has issues similar to the ones found in
1063      * {IERC20-approve}, and its usage is discouraged.
1064      *
1065      * Whenever possible, use {safeIncreaseAllowance} and
1066      * {safeDecreaseAllowance} instead.
1067      */
1068     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1069         // safeApprove should only be called when setting an initial allowance,
1070         // or when resetting it to zero. To increase and decrease it, use
1071         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1072         // solhint-disable-next-line max-line-length
1073         require((value == 0) || (token.allowance(address(this), spender) == 0),
1074             "SafeERC20: approve from non-zero to non-zero allowance"
1075         );
1076         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1077     }
1078 
1079     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1080         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1081         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1082     }
1083 
1084     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1085         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1086         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1087     }
1088 
1089     /**
1090      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1091      * on the return value: the return value is optional (but if data is returned, it must not be false).
1092      * @param token The token targeted by the call.
1093      * @param data The call data (encoded using abi.encode or one of its variants).
1094      */
1095     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1096         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1097         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1098         // the target address contains contract code and also asserts for success in the low-level call.
1099 
1100         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1101         if (returndata.length > 0) { // Return data is optional
1102             // solhint-disable-next-line max-line-length
1103             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1104         }
1105     }
1106 }
1107 
1108 
1109 // File interfaces/IUniswapV2Pair.sol
1110 
1111 pragma solidity >=0.5.0;
1112 
1113 interface IUniswapV2Pair {
1114     event Approval(address indexed owner, address indexed spender, uint value);
1115     event Transfer(address indexed from, address indexed to, uint value);
1116 
1117     function name() external pure returns (string memory);
1118     function symbol() external pure returns (string memory);
1119     function decimals() external pure returns (uint8);
1120     function totalSupply() external view returns (uint);
1121     function balanceOf(address owner) external view returns (uint);
1122     function allowance(address owner, address spender) external view returns (uint);
1123 
1124     function approve(address spender, uint value) external returns (bool);
1125     function transfer(address to, uint value) external returns (bool);
1126     function transferFrom(address from, address to, uint value) external returns (bool);
1127 
1128     function DOMAIN_SEPARATOR() external view returns (bytes32);
1129     function PERMIT_TYPEHASH() external pure returns (bytes32);
1130     function nonces(address owner) external view returns (uint);
1131 
1132     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1133 
1134     event Mint(address indexed sender, uint amount0, uint amount1);
1135     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1136     event Swap(
1137         address indexed sender,
1138         uint amount0In,
1139         uint amount1In,
1140         uint amount0Out,
1141         uint amount1Out,
1142         address indexed to
1143     );
1144     event Sync(uint112 reserve0, uint112 reserve1);
1145 
1146     function MINIMUM_LIQUIDITY() external pure returns (uint);
1147     function factory() external view returns (address);
1148     function token0() external view returns (address);
1149     function token1() external view returns (address);
1150     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1151     function price0CumulativeLast() external view returns (uint);
1152     function price1CumulativeLast() external view returns (uint);
1153     function kLast() external view returns (uint);
1154 
1155     function mint(address to) external returns (uint liquidity);
1156     function burn(address to) external returns (uint amount0, uint amount1);
1157     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1158     function skim(address to) external;
1159     function sync() external;
1160 
1161     function initialize(address, address) external;
1162 }
1163 
1164 
1165 // File contracts/Utils/UniswapV2Library.sol
1166 
1167 pragma solidity 0.6.12;
1168 
1169 
1170 library UniswapV2Library {
1171     using SafeMath for uint;
1172 
1173     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1174     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1175         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1176         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1177         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1178     }
1179 
1180     // calculates the CREATE2 address for a pair without making any external calls
1181     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1182         (address token0, address token1) = sortTokens(tokenA, tokenB);
1183         pair = address(uint(keccak256(abi.encodePacked(
1184                 hex'ff',
1185                 factory,
1186                 keccak256(abi.encodePacked(token0, token1)),
1187                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1188             ))));
1189     }
1190 
1191     // fetches and sorts the reserves for a pair
1192     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1193         (address token0,) = sortTokens(tokenA, tokenB);
1194         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1195         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1196     }
1197 
1198     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1199     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1200         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1201         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1202         amountB = amountA.mul(reserveB) / reserveA;
1203     }
1204 
1205     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1206     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
1207         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
1208         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1209         uint amountInWithFee = amountIn.mul(997);
1210         uint numerator = amountInWithFee.mul(reserveOut);
1211         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
1212         amountOut = numerator / denominator;
1213     }
1214 
1215     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
1216     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
1217         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
1218         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1219         uint numerator = reserveIn.mul(amountOut).mul(1000);
1220         uint denominator = reserveOut.sub(amountOut).mul(997);
1221         amountIn = (numerator / denominator).add(1);
1222     }
1223 
1224     // performs chained getAmountOut calculations on any number of pairs
1225     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
1226         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1227         amounts = new uint[](path.length);
1228         amounts[0] = amountIn;
1229         for (uint i; i < path.length - 1; i++) {
1230             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
1231             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
1232         }
1233     }
1234 
1235     // performs chained getAmountIn calculations on any number of pairs
1236     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
1237         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1238         amounts = new uint[](path.length);
1239         amounts[amounts.length - 1] = amountOut;
1240         for (uint i = path.length - 1; i > 0; i--) {
1241             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
1242             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
1243         }
1244     }
1245 }
1246 
1247 
1248 // File interfaces/IWETH9.sol
1249 
1250 pragma solidity >=0.5.0;
1251 
1252 interface IWETH {
1253     function deposit() external payable;
1254     function transfer(address to, uint value) external returns (bool);
1255     function withdraw(uint) external;
1256 }
1257 
1258 
1259 // File interfaces/IDigitalaxRewards.sol
1260 
1261 
1262 
1263 pragma solidity 0.6.12;
1264 
1265 /// @dev an interface to interact with the Genesis MONA NFT that will 
1266 interface IDigitalaxRewards {
1267     function updateRewards() external returns (bool);
1268     function genesisRewards(uint256 _from, uint256 _to) external view returns(uint256);
1269     function parentRewards(uint256 _from, uint256 _to) external view returns(uint256);
1270     function LPRewards(uint256 _from, uint256 _to) external view returns(uint256);
1271     function lastRewardTime() external view returns (uint256);
1272 }
1273 
1274 
1275 // File contracts/DigitalaxLPStaking.sol
1276 
1277 
1278 
1279 pragma solidity 0.6.12;
1280 
1281 
1282 
1283 
1284 
1285 
1286 
1287 /**
1288  * @title Digitalax Staking
1289  * @dev Stake MONA LP tokens, earn MONA on the Digitialax platform
1290  * @author Adrian Guerrera (deepyr)
1291  */
1292 
1293 
1294 contract DigitalaxLPStaking  {
1295     using SafeMath for uint256;
1296     using SafeERC20 for IERC20;
1297 
1298     IERC20 public rewardsToken;
1299     address public lpToken; // Pool tokens for MONA/WETH pair
1300     IWETH public WETH;
1301 
1302     DigitalaxAccessControls public accessControls;
1303     IDigitalaxRewards public rewardsContract;
1304 
1305     uint256 public stakedLPTotal;
1306     uint256 public lastUpdateTime;
1307     uint256 public rewardsPerTokenPoints;
1308     uint256 public totalUnclaimedRewards;
1309 
1310     uint256 constant pointMultiplier = 10e32;
1311 
1312     /**
1313     @notice Struct to track what user is staking which tokens
1314     @dev balance is the current ether balance of the staker
1315     @dev balance is the current rewards point snapshot
1316     @dev rewardsEarned is the total reward for the staker till now
1317     @dev rewardsReleased is how much reward has been paid to the staker
1318     */
1319     struct Staker {
1320         uint256 balance;
1321         uint256 lastRewardPoints;
1322         uint256 rewardsEarned;
1323         uint256 rewardsReleased;
1324     }
1325 
1326     /// @notice mapping of a staker to its current properties
1327     mapping (address => Staker) public stakers;
1328 
1329     // Mapping from token ID to owner address
1330     mapping (uint256 => address) public tokenOwner;
1331 
1332     /// @notice sets the token to be claimable or not, cannot claim if it set to false
1333     bool public tokensClaimable;
1334     bool private initialised;
1335 
1336     /// @notice event emitted when a user has staked a token
1337     event Staked(address indexed owner, uint256 amount);
1338 
1339     /// @notice event emitted when a user has unstaked a token
1340     event Unstaked(address indexed owner, uint256 amount);
1341 
1342     /// @notice event emitted when a user claims reward
1343     event RewardPaid(address indexed user, uint256 reward);
1344     
1345     event ClaimableStatusUpdated(bool status);
1346     event EmergencyUnstake(address indexed user, uint256 amount);
1347     event RewardsTokenUpdated(address indexed oldRewardsToken, address newRewardsToken );
1348     event LpTokenUpdated(address indexed oldLpToken, address newLpToken );
1349 
1350     constructor() public {
1351     }
1352 
1353      /**
1354      * @dev Single gateway to intialize the staking contract after deploying
1355      * @dev Sets the contract with the MONA/WETH LP pair and MONA token 
1356      */
1357     function initLPStaking(
1358         IERC20 _rewardsToken,
1359         address _lpToken,
1360         IWETH _WETH,
1361         DigitalaxAccessControls _accessControls
1362     )
1363         public
1364     {
1365         require(!initialised, "Already initialised");
1366         rewardsToken = _rewardsToken;
1367         lpToken = _lpToken;
1368         WETH = _WETH;
1369         accessControls = _accessControls;
1370         lastUpdateTime = block.timestamp;
1371         initialised = true;
1372     }
1373 
1374     receive() external payable {
1375         if(msg.sender != address(WETH)){
1376             zapEth();
1377         }
1378     }
1379 
1380     /// @notice Wrapper function zapEth() for UI 
1381     function zapEth() 
1382         public 
1383         payable
1384     {
1385         uint256 startBal = IERC20(lpToken).balanceOf(address(this));
1386         addLiquidityETHOnly(address(this));
1387         uint256 endBal = IERC20(lpToken).balanceOf(address(this));
1388 
1389         require(
1390             endBal > startBal ,
1391             "DigitalaxLPStaking.zapEth: Zap amount must be greater than 0"
1392         );
1393         uint256 amount = endBal.sub(startBal);
1394 
1395         Staker storage staker = stakers[msg.sender];
1396         if (staker.balance == 0 && staker.lastRewardPoints == 0 ) {
1397           staker.lastRewardPoints = rewardsPerTokenPoints;
1398         }
1399 
1400         updateReward(msg.sender);
1401         staker.balance = staker.balance.add(amount);
1402         stakedLPTotal = stakedLPTotal.add(amount);
1403         emit Staked(msg.sender, amount);
1404     }
1405 
1406     /// @notice Lets admin set the Rewards Token
1407     function setRewardsContract(
1408         address _addr
1409     )
1410         external
1411     {
1412         require(
1413             accessControls.hasAdminRole(msg.sender),
1414             "DigitalaxLPStaking.setRewardsContract: Sender must be admin"
1415         );
1416         require(_addr != address(0));
1417         address oldAddr = address(rewardsContract);
1418         rewardsContract = IDigitalaxRewards(_addr);
1419         emit RewardsTokenUpdated(oldAddr, _addr);
1420     }
1421 
1422     /// @notice Lets admin set the Uniswap LP Token
1423     function setLpToken(
1424         address _addr
1425     )
1426         external
1427     {
1428         require(
1429             accessControls.hasAdminRole(msg.sender),
1430             "DigitalaxLPStaking.setLpToken: Sender must be admin"
1431         );
1432         require(_addr != address(0));
1433         address oldAddr = lpToken;
1434         lpToken = _addr;
1435         emit LpTokenUpdated(oldAddr, _addr);
1436     }
1437 
1438     /// @notice Lets admin set when tokens are claimable
1439     function setTokensClaimable(
1440         bool _enabled
1441     )
1442         external
1443     {
1444         require(
1445             accessControls.hasAdminRole(msg.sender),
1446             "DigitalaxLPStaking.setTokensClaimable: Sender must be admin"
1447         );
1448         tokensClaimable = _enabled;
1449         emit ClaimableStatusUpdated(_enabled);
1450     }
1451 
1452     /// @notice Getter functions for Staking contract
1453     /// @dev Get the tokens staked by a user
1454     function getStakedBalance(
1455         address _user
1456     )
1457         external
1458         view
1459         returns (uint256 balance)
1460     {
1461         return stakers[_user].balance;
1462     }
1463 
1464     /// @dev Get the total ETH staked in Uniswap
1465     function stakedEthTotal()
1466         external
1467         view
1468         returns (uint256)
1469     {
1470 
1471         uint256 lpPerEth = getLPTokenPerEthUnit(1e18);
1472         return stakedLPTotal.mul(1e18).div(lpPerEth);
1473     }
1474 
1475 
1476     /// @notice Stake MONA LP Tokens and earn rewards.
1477     function stake(
1478         uint256 _amount
1479     )
1480         external
1481     {
1482         _stake(msg.sender, _amount);
1483     }
1484 
1485     /// @notice Stake MONA LP Tokens and earn rewards.
1486     function stakeAll()
1487         external
1488     {
1489         uint256 balance = IERC20(lpToken).balanceOf(msg.sender);
1490         _stake(msg.sender, balance);
1491     }
1492 
1493     /**
1494      * @dev All the staking goes through this function
1495      * @dev Rewards to be given out is calculated
1496      * @dev Balance of stakers are updated as they stake the nfts based on ether price
1497     */
1498     function _stake(
1499         address _user,
1500         uint256 _amount
1501     )
1502         internal
1503     {
1504         require(
1505             _amount > 0 ,
1506             "DigitalaxLPStaking._stake: Staked amount must be greater than 0"
1507         );
1508         Staker storage staker = stakers[_user];
1509 
1510         if (staker.balance == 0 && staker.lastRewardPoints == 0 ) {
1511           staker.lastRewardPoints = rewardsPerTokenPoints;
1512         }
1513 
1514         updateReward(_user);
1515         staker.balance = staker.balance.add(_amount);
1516         stakedLPTotal = stakedLPTotal.add(_amount);
1517         IERC20(lpToken).safeTransferFrom(
1518             address(_user),
1519             address(this),
1520             _amount
1521         );
1522         emit Staked(_user, _amount);
1523     }
1524 
1525     /// @notice Unstake MONA LP Tokens. 
1526     function unstake(
1527         uint256 _amount
1528     ) 
1529         external 
1530     {
1531         _unstake(msg.sender, _amount);
1532     }
1533 
1534      /**
1535      * @dev All the unstaking goes through this function
1536      * @dev Rewards to be given out is calculated
1537      * @dev Balance of stakers are updated as they unstake the nfts based on ether price
1538     */
1539     function _unstake(
1540         address _user,
1541         uint256 _amount
1542     ) 
1543         internal 
1544     {
1545 
1546         require(
1547             stakers[_user].balance >= _amount,
1548             "DigitalaxLPStaking._unstake: Sender must have staked tokens"
1549         );
1550         claimReward(_user);
1551         Staker storage staker = stakers[_user];
1552         
1553         staker.balance = staker.balance.sub(_amount);
1554         stakedLPTotal = stakedLPTotal.sub(_amount);
1555 
1556         if (staker.balance == 0) {
1557             delete stakers[_user];
1558         }
1559 
1560         uint256 tokenBal = IERC20(lpToken).balanceOf(address(this));
1561         if (_amount > tokenBal) {
1562             IERC20(lpToken).safeTransfer(address(_user), tokenBal);
1563         } else {
1564             IERC20(lpToken).safeTransfer(address(_user), _amount);
1565         }
1566         emit Unstaked(_user, _amount);
1567     }
1568 
1569     /// @notice Unstake without caring about rewards. EMERGENCY ONLY.
1570     function emergencyUnstake() 
1571         external
1572     {
1573         uint256 amount = stakers[msg.sender].balance;
1574         stakers[msg.sender].balance = 0;
1575         stakers[msg.sender].rewardsEarned = 0;
1576 
1577         IERC20(lpToken).safeTransfer(address(msg.sender), amount);
1578         emit EmergencyUnstake(msg.sender, amount);
1579     }
1580 
1581     /// @dev Updates the amount of rewards owed for each user before any tokens are moved
1582     function updateReward(
1583         address _user
1584     ) 
1585         public 
1586     {
1587 
1588         rewardsContract.updateRewards();
1589         uint256 lpRewards = rewardsContract.LPRewards(lastUpdateTime,
1590                                                         block.timestamp);
1591 
1592         if (stakedLPTotal > 0) {
1593             rewardsPerTokenPoints = rewardsPerTokenPoints.add(lpRewards
1594                                                         .mul(1e18)
1595                                                         .mul(pointMultiplier)
1596                                                         .div(stakedLPTotal));
1597         }
1598         
1599         lastUpdateTime = block.timestamp;
1600         uint256 rewards = rewardsOwing(_user);
1601 
1602         Staker storage staker = stakers[_user];
1603         if (_user != address(0)) {
1604             staker.rewardsEarned = staker.rewardsEarned.add(rewards);
1605             staker.lastRewardPoints = rewardsPerTokenPoints; 
1606         }
1607     }
1608 
1609 
1610     /// @notice Returns the rewards owing for a user
1611     /// @dev The rewards are dynamic and normalised from the other pools
1612     /// @dev This gets the rewards from each of the periods as one multiplier
1613     function rewardsOwing(
1614         address _user
1615     )
1616         public
1617         view
1618         returns(uint256)
1619     {
1620         uint256 newRewardPerToken = rewardsPerTokenPoints.sub(stakers[_user].lastRewardPoints);
1621         uint256 rewards = stakers[_user].balance.mul(newRewardPerToken)
1622                                                 .div(1e18)
1623                                                 .div(pointMultiplier);
1624         return rewards;
1625     }
1626 
1627 
1628     /// @notice Returns the about of rewards yet to be claimed
1629     function unclaimedRewards(
1630         address _user
1631     )
1632         public
1633         view
1634         returns(uint256)
1635     {
1636         if (stakedLPTotal == 0) {
1637             return 0;
1638         }
1639 
1640         uint256 lpRewards = rewardsContract.LPRewards(lastUpdateTime,
1641                                                         block.timestamp);
1642 
1643         uint256 newRewardPerToken = rewardsPerTokenPoints.add(lpRewards
1644                                                                 .mul(1e18)
1645                                                                 .mul(pointMultiplier)
1646                                                                 .div(stakedLPTotal))
1647                                                          .sub(stakers[_user].lastRewardPoints);
1648 
1649         uint256 rewards = stakers[_user].balance.mul(newRewardPerToken)
1650                                                 .div(1e18)
1651                                                 .div(pointMultiplier);
1652         return rewards.add(stakers[_user].rewardsEarned).sub(stakers[_user].rewardsReleased);
1653     }
1654 
1655 
1656     /// @notice Lets a user with rewards owing to claim tokens
1657     function claimReward(
1658         address _user
1659     )
1660         public
1661     {
1662         require(
1663             tokensClaimable == true,
1664             "Tokens cannnot be claimed yet"
1665         );
1666         updateReward(_user);
1667 
1668         Staker storage staker = stakers[_user];
1669     
1670         uint256 payableAmount = staker.rewardsEarned.sub(staker.rewardsReleased);
1671         staker.rewardsReleased = staker.rewardsReleased.add(payableAmount);
1672 
1673         /// @dev accounts for dust 
1674         uint256 rewardBal = rewardsToken.balanceOf(address(this));
1675         if (payableAmount > rewardBal) {
1676             payableAmount = rewardBal;
1677         }
1678         
1679         rewardsToken.transfer(_user, payableAmount);
1680         emit RewardPaid(_user, payableAmount);
1681     }
1682 
1683     /* ========== Liquidity Zap ========== */
1684     //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
1685     //
1686     // LiquidityZAP - UniswapZAP
1687     //   Copyright (c) 2020 deepyr.com
1688     //
1689     // UniswapZAP takes ETH and converts to a Uniswap liquidity tokens. 
1690     //
1691     // This program is free software: you can redistribute it and/or modify
1692     // it under the terms of the GNU General Public License as published by
1693     // the Free Software Foundation, either version 3 of the License
1694     //
1695     // This program is distributed in the hope that it will be useful,
1696     // but WITHOUT ANY WARRANTY; without even the implied warranty of
1697     // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1698     // GNU General Public License for more details.
1699     //
1700     // You should have received a copy of the GNU General Public License
1701     // along with this program.  
1702     // If not, see <https://github.com/apguerrera/LiquidityZAP/>.
1703     //
1704     // The above copyright notice and this permission notice shall be included 
1705     // in all copies or substantial portions of the Software.
1706     //
1707     // Authors:
1708     // * Adrian Guerrera / Deepyr Pty Ltd
1709     // 
1710     // Attribution: CORE / cvault.finance
1711     //  https://github.com/cVault-finance/CORE-periphery/blob/master/contracts/COREv1Router.sol
1712     // ---------------------------------------------------------------------
1713     
1714     // ---------------------------------------------------------------------
1715 
1716     function addLiquidityETHOnly(address payable to) public payable {
1717         require(to != address(0), "Invalid address");
1718 
1719         uint256 buyAmount = msg.value.div(2);
1720         require(buyAmount > 0, "Insufficient ETH amount");
1721         WETH.deposit{value : msg.value}();
1722 
1723         (uint256 reserveWeth, uint256 reserveTokens) = getPairReserves();
1724         uint256 outTokens = UniswapV2Library.getAmountOut(buyAmount, reserveWeth, reserveTokens);
1725         
1726         WETH.transfer(lpToken, buyAmount);
1727 
1728         (address token0, address token1) = UniswapV2Library.sortTokens(address(WETH), address(rewardsToken));
1729         IUniswapV2Pair(lpToken).swap(address(rewardsToken) == token0 ? outTokens : 0, address(rewardsToken) == token1 ? outTokens : 0, address(this), "");
1730 
1731         _addLiquidity(outTokens, buyAmount, to);
1732 
1733     }
1734 
1735     function _addLiquidity(uint256 tokenAmount, uint256 wethAmount, address payable to) internal {
1736         (uint256 wethReserve, uint256 tokenReserve) = getPairReserves();
1737 
1738         uint256 optimalTokenAmount = UniswapV2Library.quote(wethAmount, wethReserve, tokenReserve);
1739 
1740         uint256 optimalWETHAmount;
1741         if (optimalTokenAmount > tokenAmount) {
1742             optimalWETHAmount = UniswapV2Library.quote(tokenAmount, tokenReserve, wethReserve);
1743             optimalTokenAmount = tokenAmount;
1744         }
1745         else
1746             optimalWETHAmount = wethAmount;
1747 
1748         assert(WETH.transfer(lpToken, optimalWETHAmount));
1749         assert(rewardsToken.transfer(lpToken, optimalTokenAmount));
1750 
1751         IUniswapV2Pair(lpToken).mint(to);
1752         
1753         //refund dust
1754         if (tokenAmount > optimalTokenAmount)
1755             rewardsToken.transfer(to, tokenAmount.sub(optimalTokenAmount));
1756 
1757         if (wethAmount > optimalWETHAmount) {
1758             uint256 withdrawAmount = wethAmount.sub(optimalWETHAmount);
1759             WETH.withdraw(withdrawAmount);
1760             to.transfer(withdrawAmount);
1761         }
1762     }
1763 
1764 
1765     function getLPTokenPerEthUnit(uint ethAmt) public view  returns (uint liquidity){
1766         (uint256 reserveWeth, uint256 reserveTokens) = getPairReserves();
1767         uint256 outTokens = UniswapV2Library.getAmountOut(ethAmt.div(2), reserveWeth, reserveTokens);
1768         uint _totalSupply =  IUniswapV2Pair(lpToken).totalSupply();
1769 
1770         (address token0, ) = UniswapV2Library.sortTokens(address(WETH), address(rewardsToken));
1771         (uint256 amount0, uint256 amount1) = token0 == address(rewardsToken) ? (outTokens, ethAmt.div(2)) : (ethAmt.div(2), outTokens);
1772         (uint256 _reserve0, uint256 _reserve1) = token0 == address(rewardsToken) ? (reserveTokens, reserveWeth) : (reserveWeth, reserveTokens);
1773         liquidity = min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
1774     }
1775 
1776     function getPairReserves() internal view returns (uint256 wethReserves, uint256 tokenReserves) {
1777         (address token0,) = UniswapV2Library.sortTokens(address(WETH), address(rewardsToken));
1778         (uint256 reserve0, uint reserve1,) = IUniswapV2Pair(lpToken).getReserves();
1779         (wethReserves, tokenReserves) = token0 == address(rewardsToken) ? (reserve1, reserve0) : (reserve0, reserve1);
1780     }
1781     
1782     function min(uint256 a, uint256 b) internal pure returns (uint256 c) {
1783         c = a <= b ? a : b;
1784     }
1785 
1786 
1787 }