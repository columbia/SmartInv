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
951 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.2.0
952 
953 
954 
955 pragma solidity ^0.6.0;
956 
957 /**
958  * @dev Interface of the ERC165 standard, as defined in the
959  * https://eips.ethereum.org/EIPS/eip-165[EIP].
960  *
961  * Implementers can declare support of contract interfaces, which can then be
962  * queried by others ({ERC165Checker}).
963  *
964  * For an implementation, see {ERC165}.
965  */
966 interface IERC165 {
967     /**
968      * @dev Returns true if this contract implements the interface defined by
969      * `interfaceId`. See the corresponding
970      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
971      * to learn more about how these ids are created.
972      *
973      * This function call must use less than 30 000 gas.
974      */
975     function supportsInterface(bytes4 interfaceId) external view returns (bool);
976 }
977 
978 
979 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.2.0
980 
981 
982 
983 pragma solidity ^0.6.2;
984 
985 /**
986  * @dev Required interface of an ERC721 compliant contract.
987  */
988 interface IERC721 is IERC165 {
989     /**
990      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
991      */
992     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
993 
994     /**
995      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
996      */
997     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
998 
999     /**
1000      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1001      */
1002     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1003 
1004     /**
1005      * @dev Returns the number of tokens in ``owner``'s account.
1006      */
1007     function balanceOf(address owner) external view returns (uint256 balance);
1008 
1009     /**
1010      * @dev Returns the owner of the `tokenId` token.
1011      *
1012      * Requirements:
1013      *
1014      * - `tokenId` must exist.
1015      */
1016     function ownerOf(uint256 tokenId) external view returns (address owner);
1017 
1018     /**
1019      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1020      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1021      *
1022      * Requirements:
1023      *
1024      * - `from` cannot be the zero address.
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must exist and be owned by `from`.
1027      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1028      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1033 
1034     /**
1035      * @dev Transfers `tokenId` token from `from` to `to`.
1036      *
1037      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1038      *
1039      * Requirements:
1040      *
1041      * - `from` cannot be the zero address.
1042      * - `to` cannot be the zero address.
1043      * - `tokenId` token must be owned by `from`.
1044      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function transferFrom(address from, address to, uint256 tokenId) external;
1049 
1050     /**
1051      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1052      * The approval is cleared when the token is transferred.
1053      *
1054      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1055      *
1056      * Requirements:
1057      *
1058      * - The caller must own the token or be an approved operator.
1059      * - `tokenId` must exist.
1060      *
1061      * Emits an {Approval} event.
1062      */
1063     function approve(address to, uint256 tokenId) external;
1064 
1065     /**
1066      * @dev Returns the account approved for `tokenId` token.
1067      *
1068      * Requirements:
1069      *
1070      * - `tokenId` must exist.
1071      */
1072     function getApproved(uint256 tokenId) external view returns (address operator);
1073 
1074     /**
1075      * @dev Approve or remove `operator` as an operator for the caller.
1076      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1077      *
1078      * Requirements:
1079      *
1080      * - The `operator` cannot be the caller.
1081      *
1082      * Emits an {ApprovalForAll} event.
1083      */
1084     function setApprovalForAll(address operator, bool _approved) external;
1085 
1086     /**
1087      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1088      *
1089      * See {setApprovalForAll}
1090      */
1091     function isApprovedForAll(address owner, address operator) external view returns (bool);
1092 
1093     /**
1094       * @dev Safely transfers `tokenId` token from `from` to `to`.
1095       *
1096       * Requirements:
1097       *
1098      * - `from` cannot be the zero address.
1099      * - `to` cannot be the zero address.
1100       * - `tokenId` token must exist and be owned by `from`.
1101       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1102       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1103       *
1104       * Emits a {Transfer} event.
1105       */
1106     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1107 }
1108 
1109 
1110 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.2.0
1111 
1112 
1113 
1114 pragma solidity ^0.6.2;
1115 
1116 /**
1117  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1118  * @dev See https://eips.ethereum.org/EIPS/eip-721
1119  */
1120 interface IERC721Metadata is IERC721 {
1121 
1122     /**
1123      * @dev Returns the token collection name.
1124      */
1125     function name() external view returns (string memory);
1126 
1127     /**
1128      * @dev Returns the token collection symbol.
1129      */
1130     function symbol() external view returns (string memory);
1131 
1132     /**
1133      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1134      */
1135     function tokenURI(uint256 tokenId) external view returns (string memory);
1136 }
1137 
1138 
1139 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.2.0
1140 
1141 
1142 
1143 pragma solidity ^0.6.2;
1144 
1145 /**
1146  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1147  * @dev See https://eips.ethereum.org/EIPS/eip-721
1148  */
1149 interface IERC721Enumerable is IERC721 {
1150 
1151     /**
1152      * @dev Returns the total amount of tokens stored by the contract.
1153      */
1154     function totalSupply() external view returns (uint256);
1155 
1156     /**
1157      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1158      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1159      */
1160     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1161 
1162     /**
1163      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1164      * Use along with {totalSupply} to enumerate all tokens.
1165      */
1166     function tokenByIndex(uint256 index) external view returns (uint256);
1167 }
1168 
1169 
1170 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.2.0
1171 
1172 
1173 
1174 pragma solidity ^0.6.0;
1175 
1176 /**
1177  * @title ERC721 token receiver interface
1178  * @dev Interface for any contract that wants to support safeTransfers
1179  * from ERC721 asset contracts.
1180  */
1181 interface IERC721Receiver {
1182     /**
1183      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1184      * by `operator` from `from`, this function is called.
1185      *
1186      * It must return its Solidity selector to confirm the token transfer.
1187      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1188      *
1189      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1190      */
1191     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
1192     external returns (bytes4);
1193 }
1194 
1195 
1196 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.2.0
1197 
1198 
1199 
1200 pragma solidity ^0.6.0;
1201 
1202 /**
1203  * @dev Implementation of the {IERC165} interface.
1204  *
1205  * Contracts may inherit from this and call {_registerInterface} to declare
1206  * their support of an interface.
1207  */
1208 contract ERC165 is IERC165 {
1209     /*
1210      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1211      */
1212     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1213 
1214     /**
1215      * @dev Mapping of interface ids to whether or not it's supported.
1216      */
1217     mapping(bytes4 => bool) private _supportedInterfaces;
1218 
1219     constructor () internal {
1220         // Derived contracts need only register support for their own interfaces,
1221         // we register support for ERC165 itself here
1222         _registerInterface(_INTERFACE_ID_ERC165);
1223     }
1224 
1225     /**
1226      * @dev See {IERC165-supportsInterface}.
1227      *
1228      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1229      */
1230     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1231         return _supportedInterfaces[interfaceId];
1232     }
1233 
1234     /**
1235      * @dev Registers the contract as an implementer of the interface defined by
1236      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1237      * registering its interface id is not required.
1238      *
1239      * See {IERC165-supportsInterface}.
1240      *
1241      * Requirements:
1242      *
1243      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1244      */
1245     function _registerInterface(bytes4 interfaceId) internal virtual {
1246         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1247         _supportedInterfaces[interfaceId] = true;
1248     }
1249 }
1250 
1251 
1252 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.2.0
1253 
1254 
1255 
1256 pragma solidity ^0.6.0;
1257 
1258 /**
1259  * @dev Library for managing an enumerable variant of Solidity's
1260  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1261  * type.
1262  *
1263  * Maps have the following properties:
1264  *
1265  * - Entries are added, removed, and checked for existence in constant time
1266  * (O(1)).
1267  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1268  *
1269  * ```
1270  * contract Example {
1271  *     // Add the library methods
1272  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1273  *
1274  *     // Declare a set state variable
1275  *     EnumerableMap.UintToAddressMap private myMap;
1276  * }
1277  * ```
1278  *
1279  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1280  * supported.
1281  */
1282 library EnumerableMap {
1283     // To implement this library for multiple types with as little code
1284     // repetition as possible, we write it in terms of a generic Map type with
1285     // bytes32 keys and values.
1286     // The Map implementation uses private functions, and user-facing
1287     // implementations (such as Uint256ToAddressMap) are just wrappers around
1288     // the underlying Map.
1289     // This means that we can only create new EnumerableMaps for types that fit
1290     // in bytes32.
1291 
1292     struct MapEntry {
1293         bytes32 _key;
1294         bytes32 _value;
1295     }
1296 
1297     struct Map {
1298         // Storage of map keys and values
1299         MapEntry[] _entries;
1300 
1301         // Position of the entry defined by a key in the `entries` array, plus 1
1302         // because index 0 means a key is not in the map.
1303         mapping (bytes32 => uint256) _indexes;
1304     }
1305 
1306     /**
1307      * @dev Adds a key-value pair to a map, or updates the value for an existing
1308      * key. O(1).
1309      *
1310      * Returns true if the key was added to the map, that is if it was not
1311      * already present.
1312      */
1313     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1314         // We read and store the key's index to prevent multiple reads from the same storage slot
1315         uint256 keyIndex = map._indexes[key];
1316 
1317         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1318             map._entries.push(MapEntry({ _key: key, _value: value }));
1319             // The entry is stored at length-1, but we add 1 to all indexes
1320             // and use 0 as a sentinel value
1321             map._indexes[key] = map._entries.length;
1322             return true;
1323         } else {
1324             map._entries[keyIndex - 1]._value = value;
1325             return false;
1326         }
1327     }
1328 
1329     /**
1330      * @dev Removes a key-value pair from a map. O(1).
1331      *
1332      * Returns true if the key was removed from the map, that is if it was present.
1333      */
1334     function _remove(Map storage map, bytes32 key) private returns (bool) {
1335         // We read and store the key's index to prevent multiple reads from the same storage slot
1336         uint256 keyIndex = map._indexes[key];
1337 
1338         if (keyIndex != 0) { // Equivalent to contains(map, key)
1339             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1340             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1341             // This modifies the order of the array, as noted in {at}.
1342 
1343             uint256 toDeleteIndex = keyIndex - 1;
1344             uint256 lastIndex = map._entries.length - 1;
1345 
1346             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1347             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1348 
1349             MapEntry storage lastEntry = map._entries[lastIndex];
1350 
1351             // Move the last entry to the index where the entry to delete is
1352             map._entries[toDeleteIndex] = lastEntry;
1353             // Update the index for the moved entry
1354             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1355 
1356             // Delete the slot where the moved entry was stored
1357             map._entries.pop();
1358 
1359             // Delete the index for the deleted slot
1360             delete map._indexes[key];
1361 
1362             return true;
1363         } else {
1364             return false;
1365         }
1366     }
1367 
1368     /**
1369      * @dev Returns true if the key is in the map. O(1).
1370      */
1371     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1372         return map._indexes[key] != 0;
1373     }
1374 
1375     /**
1376      * @dev Returns the number of key-value pairs in the map. O(1).
1377      */
1378     function _length(Map storage map) private view returns (uint256) {
1379         return map._entries.length;
1380     }
1381 
1382    /**
1383     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1384     *
1385     * Note that there are no guarantees on the ordering of entries inside the
1386     * array, and it may change when more entries are added or removed.
1387     *
1388     * Requirements:
1389     *
1390     * - `index` must be strictly less than {length}.
1391     */
1392     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1393         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1394 
1395         MapEntry storage entry = map._entries[index];
1396         return (entry._key, entry._value);
1397     }
1398 
1399     /**
1400      * @dev Returns the value associated with `key`.  O(1).
1401      *
1402      * Requirements:
1403      *
1404      * - `key` must be in the map.
1405      */
1406     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1407         return _get(map, key, "EnumerableMap: nonexistent key");
1408     }
1409 
1410     /**
1411      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1412      */
1413     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1414         uint256 keyIndex = map._indexes[key];
1415         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1416         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1417     }
1418 
1419     // UintToAddressMap
1420 
1421     struct UintToAddressMap {
1422         Map _inner;
1423     }
1424 
1425     /**
1426      * @dev Adds a key-value pair to a map, or updates the value for an existing
1427      * key. O(1).
1428      *
1429      * Returns true if the key was added to the map, that is if it was not
1430      * already present.
1431      */
1432     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1433         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1434     }
1435 
1436     /**
1437      * @dev Removes a value from a set. O(1).
1438      *
1439      * Returns true if the key was removed from the map, that is if it was present.
1440      */
1441     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1442         return _remove(map._inner, bytes32(key));
1443     }
1444 
1445     /**
1446      * @dev Returns true if the key is in the map. O(1).
1447      */
1448     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1449         return _contains(map._inner, bytes32(key));
1450     }
1451 
1452     /**
1453      * @dev Returns the number of elements in the map. O(1).
1454      */
1455     function length(UintToAddressMap storage map) internal view returns (uint256) {
1456         return _length(map._inner);
1457     }
1458 
1459    /**
1460     * @dev Returns the element stored at position `index` in the set. O(1).
1461     * Note that there are no guarantees on the ordering of values inside the
1462     * array, and it may change when more values are added or removed.
1463     *
1464     * Requirements:
1465     *
1466     * - `index` must be strictly less than {length}.
1467     */
1468     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1469         (bytes32 key, bytes32 value) = _at(map._inner, index);
1470         return (uint256(key), address(uint256(value)));
1471     }
1472 
1473     /**
1474      * @dev Returns the value associated with `key`.  O(1).
1475      *
1476      * Requirements:
1477      *
1478      * - `key` must be in the map.
1479      */
1480     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1481         return address(uint256(_get(map._inner, bytes32(key))));
1482     }
1483 
1484     /**
1485      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1486      */
1487     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1488         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1489     }
1490 }
1491 
1492 
1493 // File @openzeppelin/contracts/utils/Strings.sol@v3.2.0
1494 
1495 
1496 
1497 pragma solidity ^0.6.0;
1498 
1499 /**
1500  * @dev String operations.
1501  */
1502 library Strings {
1503     /**
1504      * @dev Converts a `uint256` to its ASCII `string` representation.
1505      */
1506     function toString(uint256 value) internal pure returns (string memory) {
1507         // Inspired by OraclizeAPI's implementation - MIT licence
1508         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1509 
1510         if (value == 0) {
1511             return "0";
1512         }
1513         uint256 temp = value;
1514         uint256 digits;
1515         while (temp != 0) {
1516             digits++;
1517             temp /= 10;
1518         }
1519         bytes memory buffer = new bytes(digits);
1520         uint256 index = digits - 1;
1521         temp = value;
1522         while (temp != 0) {
1523             buffer[index--] = byte(uint8(48 + temp % 10));
1524             temp /= 10;
1525         }
1526         return string(buffer);
1527     }
1528 }
1529 
1530 
1531 // File contracts/ERC721/ERC721WithSameTokenURIForAllTokens.sol
1532 
1533 
1534 
1535 pragma solidity 0.6.12;
1536 
1537 
1538 
1539 
1540 
1541 
1542 
1543 
1544 
1545 
1546 /**
1547  * @title ERC721 Non-Fungible Token Standard basic implementation
1548  * @dev see https://eips.ethereum.org/EIPS/eip-721
1549  * @dev This is a modified OZ ERC721 base contract with one change where all tokens have the same token URI
1550  */
1551 contract ERC721WithSameTokenURIForAllTokens is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1552     using SafeMath for uint256;
1553     using Address for address;
1554     using EnumerableSet for EnumerableSet.UintSet;
1555     using EnumerableMap for EnumerableMap.UintToAddressMap;
1556     using Strings for uint256;
1557 
1558     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1559     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1560     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1561 
1562     // Mapping from holder address to their (enumerable) set of owned tokens
1563     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1564 
1565     // Enumerable mapping from token ids to their owners
1566     EnumerableMap.UintToAddressMap private _tokenOwners;
1567 
1568     // Mapping from token ID to approved address
1569     mapping (uint256 => address) private _tokenApprovals;
1570 
1571     // Mapping from owner to operator approvals
1572     mapping (address => mapping (address => bool)) private _operatorApprovals;
1573 
1574     // Token name
1575     string private _name;
1576 
1577     // Token symbol
1578     string private _symbol;
1579 
1580     // Single token URI for all tokens
1581     string public tokenURI_;
1582 
1583     /*
1584      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1585      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1586      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1587      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1588      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1589      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1590      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1591      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1592      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1593      *
1594      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1595      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1596      */
1597     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1598 
1599     /*
1600      *     bytes4(keccak256('name()')) == 0x06fdde03
1601      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1602      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1603      *
1604      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1605      */
1606     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1607 
1608     /*
1609      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1610      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1611      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1612      *
1613      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1614      */
1615     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1616 
1617     /**
1618      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1619      */
1620     constructor (string memory name, string memory symbol) public {
1621         _name = name;
1622         _symbol = symbol;
1623 
1624         // register the supported interfaces to conform to ERC721 via ERC165
1625         _registerInterface(_INTERFACE_ID_ERC721);
1626         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1627         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1628     }
1629 
1630     /**
1631      * @dev See {IERC721-balanceOf}.
1632      */
1633     function balanceOf(address owner) public view override returns (uint256) {
1634         require(owner != address(0), "ERC721: balance query for the zero address");
1635 
1636         return _holderTokens[owner].length();
1637     }
1638 
1639     /**
1640      * @dev See {IERC721-ownerOf}.
1641      */
1642     function ownerOf(uint256 tokenId) public view override returns (address) {
1643         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1644     }
1645 
1646     /**
1647      * @dev See {IERC721Metadata-name}.
1648      */
1649     function name() public view override returns (string memory) {
1650         return _name;
1651     }
1652 
1653     /**
1654      * @dev See {IERC721Metadata-symbol}.
1655      */
1656     function symbol() public view override returns (string memory) {
1657         return _symbol;
1658     }
1659 
1660     /**
1661      * @dev See {IERC721Metadata-tokenURI}.
1662      */
1663     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1664         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1665 
1666         return tokenURI_;
1667     }
1668 
1669     /**
1670      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1671      */
1672     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1673         return _holderTokens[owner].at(index);
1674     }
1675 
1676     /**
1677      * @dev See {IERC721Enumerable-totalSupply}.
1678      */
1679     function totalSupply() public view override returns (uint256) {
1680         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1681         return _tokenOwners.length();
1682     }
1683 
1684     /**
1685      * @dev See {IERC721Enumerable-tokenByIndex}.
1686      */
1687     function tokenByIndex(uint256 index) public view override returns (uint256) {
1688         (uint256 tokenId, ) = _tokenOwners.at(index);
1689         return tokenId;
1690     }
1691 
1692     /**
1693      * @dev See {IERC721-approve}.
1694      */
1695     function approve(address to, uint256 tokenId) public virtual override {
1696         address owner = ownerOf(tokenId);
1697         require(to != owner, "ERC721: approval to current owner");
1698 
1699         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1700             "ERC721: approve caller is not owner nor approved for all"
1701         );
1702 
1703         _approve(to, tokenId);
1704     }
1705 
1706     /**
1707      * @dev See {IERC721-getApproved}.
1708      */
1709     function getApproved(uint256 tokenId) public view override returns (address) {
1710         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1711 
1712         return _tokenApprovals[tokenId];
1713     }
1714 
1715     /**
1716      * @dev See {IERC721-setApprovalForAll}.
1717      */
1718     function setApprovalForAll(address operator, bool approved) public virtual override {
1719         require(operator != _msgSender(), "ERC721: approve to caller");
1720 
1721         _operatorApprovals[_msgSender()][operator] = approved;
1722         emit ApprovalForAll(_msgSender(), operator, approved);
1723     }
1724 
1725     /**
1726      * @dev See {IERC721-isApprovedForAll}.
1727      */
1728     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1729         return _operatorApprovals[owner][operator];
1730     }
1731 
1732     /**
1733      * @dev See {IERC721-transferFrom}.
1734      */
1735     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1736         //solhint-disable-next-line max-line-length
1737         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1738 
1739         _transfer(from, to, tokenId);
1740     }
1741 
1742     /**
1743      * @dev See {IERC721-safeTransferFrom}.
1744      */
1745     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1746         safeTransferFrom(from, to, tokenId, "");
1747     }
1748 
1749     /**
1750      * @dev See {IERC721-safeTransferFrom}.
1751      */
1752     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1753         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1754         _safeTransfer(from, to, tokenId, _data);
1755     }
1756 
1757     /**
1758      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1759      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1760      *
1761      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1762      *
1763      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1764      * implement alternative mechanisms to perform token transfer, such as signature-based.
1765      *
1766      * Requirements:
1767      *
1768      * - `from` cannot be the zero address.
1769      * - `to` cannot be the zero address.
1770      * - `tokenId` token must exist and be owned by `from`.
1771      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1772      *
1773      * Emits a {Transfer} event.
1774      */
1775     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1776         _transfer(from, to, tokenId);
1777         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1778     }
1779 
1780     /**
1781      * @dev Returns whether `tokenId` exists.
1782      *
1783      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1784      *
1785      * Tokens start existing when they are minted (`_mint`),
1786      * and stop existing when they are burned (`_burn`).
1787      */
1788     function _exists(uint256 tokenId) internal view returns (bool) {
1789         return _tokenOwners.contains(tokenId);
1790     }
1791 
1792     /**
1793      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1794      *
1795      * Requirements:
1796      *
1797      * - `tokenId` must exist.
1798      */
1799     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1800         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1801         address owner = ownerOf(tokenId);
1802         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1803     }
1804 
1805     /**
1806      * @dev Safely mints `tokenId` and transfers it to `to`.
1807      *
1808      * Requirements:
1809      d*
1810      * - `tokenId` must not exist.
1811      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1812      *
1813      * Emits a {Transfer} event.
1814      */
1815     function _safeMint(address to, uint256 tokenId) internal virtual {
1816         _safeMint(to, tokenId, "");
1817     }
1818 
1819     /**
1820      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1821      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1822      */
1823     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1824         _mint(to, tokenId);
1825         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1826     }
1827 
1828     /**
1829      * @dev Mints `tokenId` and transfers it to `to`.
1830      *
1831      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1832      *
1833      * Requirements:
1834      *
1835      * - `tokenId` must not exist.
1836      * - `to` cannot be the zero address.
1837      *
1838      * Emits a {Transfer} event.
1839      */
1840     function _mint(address to, uint256 tokenId) internal virtual {
1841         require(to != address(0), "ERC721: mint to the zero address");
1842         require(!_exists(tokenId), "ERC721: token already minted");
1843 
1844         _beforeTokenTransfer(address(0), to, tokenId);
1845 
1846         _holderTokens[to].add(tokenId);
1847 
1848         _tokenOwners.set(tokenId, to);
1849 
1850         emit Transfer(address(0), to, tokenId);
1851     }
1852 
1853     /**
1854      * @dev Destroys `tokenId`.
1855      * The approval is cleared when the token is burned.
1856      *
1857      * Requirements:
1858      *
1859      * - `tokenId` must exist.
1860      *
1861      * Emits a {Transfer} event.
1862      */
1863     function _burn(uint256 tokenId) internal virtual {
1864         address owner = ownerOf(tokenId);
1865 
1866         _beforeTokenTransfer(owner, address(0), tokenId);
1867 
1868         // Clear approvals
1869         _approve(address(0), tokenId);
1870 
1871         _holderTokens[owner].remove(tokenId);
1872 
1873         _tokenOwners.remove(tokenId);
1874 
1875         emit Transfer(owner, address(0), tokenId);
1876     }
1877 
1878     /**
1879      * @dev Transfers `tokenId` from `from` to `to`.
1880      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1881      *
1882      * Requirements:
1883      *
1884      * - `to` cannot be the zero address.
1885      * - `tokenId` token must be owned by `from`.
1886      *
1887      * Emits a {Transfer} event.
1888      */
1889     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1890         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1891         require(to != address(0), "ERC721: transfer to the zero address");
1892 
1893         _beforeTokenTransfer(from, to, tokenId);
1894 
1895         // Clear approvals from the previous owner
1896         _approve(address(0), tokenId);
1897 
1898         _holderTokens[from].remove(tokenId);
1899         _holderTokens[to].add(tokenId);
1900 
1901         _tokenOwners.set(tokenId, to);
1902 
1903         emit Transfer(from, to, tokenId);
1904     }
1905 
1906     /**
1907      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1908      * The call is not executed if the target address is not a contract.
1909      *
1910      * @param from address representing the previous owner of the given token ID
1911      * @param to target address that will receive the tokens
1912      * @param tokenId uint256 ID of the token to be transferred
1913      * @param _data bytes optional data to send along with the call
1914      * @return bool whether the call correctly returned the expected magic value
1915      */
1916     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1917     private returns (bool)
1918     {
1919         if (!to.isContract()) {
1920             return true;
1921         }
1922         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1923                 IERC721Receiver(to).onERC721Received.selector,
1924                 _msgSender(),
1925                 from,
1926                 tokenId,
1927                 _data
1928             ), "ERC721: transfer to non ERC721Receiver implementer");
1929         bytes4 retval = abi.decode(returndata, (bytes4));
1930         return (retval == _ERC721_RECEIVED);
1931     }
1932 
1933     function _approve(address to, uint256 tokenId) private {
1934         _tokenApprovals[tokenId] = to;
1935         emit Approval(ownerOf(tokenId), to, tokenId);
1936     }
1937 
1938     /**
1939      * @dev Hook that is called before any token transfer. This includes minting
1940      * and burning.
1941      *
1942      * Calling conditions:
1943      *
1944      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1945      * transferred to `to`.
1946      * - When `from` is zero, `tokenId` will be minted for `to`.
1947      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1948      * - `from` cannot be the zero address.
1949      * - `to` cannot be the zero address.
1950      *
1951      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1952      */
1953     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1954 }
1955 
1956 
1957 // File contracts/DigitalaxGenesisNFT.sol
1958 
1959 
1960 
1961 pragma solidity 0.6.12;
1962 
1963 
1964 
1965 /**
1966  * @title Digitalax Genesis NFT
1967  * @dev To facilitate the genesis sale for the Digitialax platform
1968  */
1969 contract DigitalaxGenesisNFT is ERC721WithSameTokenURIForAllTokens("DigitalaxGenesis", "DXG") {
1970     using SafeMath for uint256;
1971 
1972     // @notice event emitted upon construction of this contract, used to bootstrap external indexers
1973     event DigitalaxGenesisNFTContractDeployed();
1974 
1975     // @notice event emitted when a contributor buys a Genesis NFT
1976     event GenesisPurchased(
1977         address indexed buyer,
1978         uint256 indexed tokenId,
1979         uint256 contribution
1980     );
1981 
1982     // @notice event emitted when a admin mints a Genesis NFT
1983     event AdminGenesisMinted(
1984         address indexed beneficiary,
1985         address indexed admin,
1986         uint256 indexed tokenId
1987     );
1988 
1989     // @notice event emitted when a contributors amount is increased
1990     event ContributionIncreased(
1991         address indexed buyer,
1992         uint256 contribution
1993     );
1994 
1995     // @notice event emitted when end date is changed
1996     event GenesisEndUpdated(
1997         uint256 genesisEndTimestamp,
1998         address indexed admin
1999     );
2000 
2001     // @notice event emitted when DigitalaxAccessControls is updated
2002     event AccessControlsUpdated(
2003         address indexed newAdress
2004     );
2005 
2006     // @notice responsible for enforcing admin access
2007     DigitalaxAccessControls public accessControls;
2008 
2009     // @notice all funds will be sent to this address pon purchase of a Genesis NFT
2010     address payable public fundsMultisig;
2011 
2012     // @notice start date for them the Genesis sale is open to the public, before this data no purchases can be made
2013     uint256 public genesisStartTimestamp;
2014 
2015     // @notice end date for them the Genesis sale is closed, no more purchased can be made after this point
2016     uint256 public genesisEndTimestamp;
2017 
2018     // @notice set after end time has been changed once, prevents further changes to end timestamp
2019     bool public genesisEndTimestampLocked;
2020 
2021     // @notice the minimum amount a buyer can contribute in a single go
2022     uint256 public constant minimumContributionAmount = 0.1 ether;
2023 
2024     // @notice the maximum accumulative amount a user can contribute to the genesis sale
2025     uint256 public constant maximumContributionAmount = 2 ether;
2026 
2027     // @notice accumulative => contribution total
2028     mapping(address => uint256) public contribution;
2029 
2030     // @notice global accumulative contribution amount
2031     uint256 public totalContributions;
2032 
2033     // @notice max number of paid contributions to the genesis sale
2034     uint256 public constant maxGenesisContributionTokens = 460;
2035 
2036     uint256 public totalAdminMints;
2037 
2038     constructor(
2039         DigitalaxAccessControls _accessControls,
2040         address payable _fundsMultisig,
2041         uint256 _genesisStartTimestamp,
2042         uint256 _genesisEndTimestamp,
2043         string memory _tokenURI
2044     ) public {
2045         accessControls = _accessControls;
2046         fundsMultisig = _fundsMultisig;
2047         genesisStartTimestamp = _genesisStartTimestamp;
2048         genesisEndTimestamp = _genesisEndTimestamp;
2049         tokenURI_ = _tokenURI;
2050         emit DigitalaxGenesisNFTContractDeployed();
2051     }
2052 
2053     /**
2054      * @dev Proxy method for facilitating a single point of entry to either buy or contribute additional value to the Genesis sale
2055      * @dev Cannot contribute less than minimumContributionAmount
2056      * @dev Cannot contribute accumulative more than than maximumContributionAmount
2057      */
2058     function buyOrIncreaseContribution() external payable {
2059         if (contribution[_msgSender()] == 0) {
2060             buy();
2061         } else {
2062             increaseContribution();
2063         }
2064     }
2065 
2066     /**
2067      * @dev Facilitating the initial purchase of a Genesis NFT
2068      * @dev Cannot contribute less than minimumContributionAmount
2069      * @dev Cannot contribute accumulative more than than maximumContributionAmount
2070      * @dev Reverts if already owns an genesis token
2071      * @dev Buyer receives a NFT on success
2072      * @dev All funds move to fundsMultisig
2073      */
2074     function buy() public payable {
2075         require(contribution[_msgSender()] == 0, "DigitalaxGenesisNFT.buy: You already own a genesis NFT");
2076         require(
2077             _getNow() >= genesisStartTimestamp && _getNow() <= genesisEndTimestamp,
2078             "DigitalaxGenesisNFT.buy: No genesis are available outside of the genesis window"
2079         );
2080 
2081         uint256 _contributionAmount = msg.value;
2082         require(
2083             _contributionAmount >= minimumContributionAmount,
2084             "DigitalaxGenesisNFT.buy: Contribution does not meet minimum requirement"
2085         );
2086 
2087         require(
2088             _contributionAmount <= maximumContributionAmount,
2089             "DigitalaxGenesisNFT.buy: You cannot exceed the maximum contribution amount"
2090         );
2091 
2092         require(remainingGenesisTokens() > 0, "DigitalaxGenesisNFT.buy: Total number of genesis token holders reached");
2093 
2094         contribution[_msgSender()] = _contributionAmount;
2095         totalContributions = totalContributions.add(_contributionAmount);
2096 
2097         (bool fundsTransferSuccess,) = fundsMultisig.call{value : _contributionAmount}("");
2098         require(fundsTransferSuccess, "DigitalaxGenesisNFT.buy: Unable to send contribution to funds multisig");
2099 
2100         uint256 tokenId = totalSupply().add(1);
2101         _safeMint(_msgSender(), tokenId);
2102 
2103         emit GenesisPurchased(_msgSender(), tokenId, _contributionAmount);
2104     }
2105 
2106     /**
2107      * @dev Facilitates an owner to increase there contribution
2108      * @dev Cannot contribute less than minimumContributionAmount
2109      * @dev Cannot contribute accumulative more than than maximumContributionAmount
2110      * @dev Reverts if caller does not already owns an genesis token
2111      * @dev All funds move to fundsMultisig
2112      */
2113     function increaseContribution() public payable {
2114         require(
2115             _getNow() >= genesisStartTimestamp && _getNow() <= genesisEndTimestamp,
2116             "DigitalaxGenesisNFT.increaseContribution: No increases are possible outside of the genesis window"
2117         );
2118 
2119         require(
2120             contribution[_msgSender()] > 0,
2121             "DigitalaxGenesisNFT.increaseContribution: You do not own a genesis NFT"
2122         );
2123 
2124         uint256 _amountToIncrease = msg.value;
2125         contribution[_msgSender()] = contribution[_msgSender()].add(_amountToIncrease);
2126 
2127         require(
2128             contribution[_msgSender()] <= maximumContributionAmount,
2129             "DigitalaxGenesisNFT.increaseContribution: You cannot exceed the maximum contribution amount"
2130         );
2131 
2132         totalContributions = totalContributions.add(_amountToIncrease);
2133 
2134         (bool fundsTransferSuccess,) = fundsMultisig.call{value : _amountToIncrease}("");
2135         require(
2136             fundsTransferSuccess,
2137             "DigitalaxGenesisNFT.increaseContribution: Unable to send contribution to funds multisig"
2138         );
2139 
2140         emit ContributionIncreased(_msgSender(), _amountToIncrease);
2141     }
2142 
2143     // Admin
2144 
2145     /**
2146      * @dev Allows a whitelisted admin to mint a token and issue it to a beneficiary
2147      * @dev One token per holder
2148      * @dev All holders contribution as set o zero on creation
2149      */
2150     function adminBuy(address _beneficiary) external {
2151         require(
2152             accessControls.hasAdminRole(_msgSender()),
2153             "DigitalaxGenesisNFT.adminBuy: Sender must be admin"
2154         );
2155         require(_beneficiary != address(0), "DigitalaxGenesisNFT.adminBuy: Beneficiary cannot be ZERO");
2156         require(balanceOf(_beneficiary) == 0, "DigitalaxGenesisNFT.adminBuy: Beneficiary already owns a genesis NFT");
2157 
2158         uint256 tokenId = totalSupply().add(1);
2159         _safeMint(_beneficiary, tokenId);
2160 
2161         // Increase admin mint counts
2162         totalAdminMints = totalAdminMints.add(1);
2163 
2164         emit AdminGenesisMinted(_beneficiary, _msgSender(), tokenId);
2165     }
2166 
2167     /**
2168      * @dev Allows a whitelisted admin to update the end date of the genesis
2169      */
2170     function updateGenesisEnd(uint256 _end) external {
2171         require(
2172             accessControls.hasAdminRole(_msgSender()),
2173             "DigitalaxGenesisNFT.updateGenesisEnd: Sender must be admin"
2174         );
2175         // If already passed, dont allow opening again
2176         require(genesisEndTimestamp > _getNow(), "DigitalaxGenesisNFT.updateGenesisEnd: End time already passed");
2177 
2178         // Only allow setting this once
2179         require(!genesisEndTimestampLocked, "DigitalaxGenesisNFT.updateGenesisEnd: End time locked");
2180 
2181         genesisEndTimestamp = _end;
2182 
2183         // Lock future end time modifications
2184         genesisEndTimestampLocked = true;
2185 
2186         emit GenesisEndUpdated(genesisEndTimestamp, _msgSender());
2187     }
2188 
2189     /**
2190      * @dev Allows a whitelisted admin to update the start date of the genesis
2191      */
2192     function updateAccessControls(DigitalaxAccessControls _accessControls) external {
2193         require(
2194             accessControls.hasAdminRole(_msgSender()),
2195             "DigitalaxGenesisNFT.updateAccessControls: Sender must be admin"
2196         );
2197         require(address(_accessControls) != address(0), "DigitalaxGenesisNFT.updateAccessControls: Zero Address");
2198         accessControls = _accessControls;
2199 
2200         emit AccessControlsUpdated(address(_accessControls));
2201     }
2202 
2203     /**
2204     * @dev Returns total remaining number of tokens available in the Genesis sale
2205     */
2206     function remainingGenesisTokens() public view returns (uint256) {
2207         return _getMaxGenesisContributionTokens() - (totalSupply() - totalAdminMints);
2208     }
2209 
2210     // Internal
2211 
2212     function _getNow() internal virtual view returns (uint256) {
2213         return block.timestamp;
2214     }
2215 
2216     function _getMaxGenesisContributionTokens() internal virtual view returns (uint256) {
2217         return maxGenesisContributionTokens;
2218     }
2219 
2220     /**
2221      * @dev Before token transfer hook to enforce that no token can be moved to another address until the genesis sale has ended
2222      */
2223     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
2224         if (from != address(0) && _getNow() <= genesisEndTimestamp) {
2225             revert("DigitalaxGenesisNFT._beforeTokenTransfer: Transfers are currently locked at this time");
2226         }
2227     }
2228 }
2229 
2230 
2231 // File interfaces/IERC20.sol
2232 
2233 pragma solidity ^0.6.2;
2234 
2235 
2236 
2237 interface IERC20 {
2238     function name() external view returns (string memory);
2239     function symbol() external view returns (string memory);
2240     function decimals() external view returns (uint8);
2241     function totalSupply() external view returns (uint256);
2242     function balanceOf(address owner) external view returns (uint256);
2243     function transfer(address to, uint256 amount) external returns (bool);
2244     function transferFrom(address from, address to, uint256 amount) external returns (bool);
2245     function approve(address spender, uint256 amount) external returns (bool);
2246     function allowance(address owner, address spender) external view returns (uint256);
2247 
2248     event Transfer(address indexed from, address indexed to, uint256 amount);
2249     event Approval(address indexed owner, address indexed spender, uint256 amount);
2250 }
2251 
2252 
2253 // File interfaces/IDigitalaxRewards.sol
2254 
2255 
2256 
2257 pragma solidity 0.6.12;
2258 
2259 /// @dev an interface to interact with the Genesis MONA NFT that will 
2260 interface IDigitalaxRewards {
2261     function updateRewards() external returns (bool);
2262     function genesisRewards(uint256 _from, uint256 _to) external view returns(uint256);
2263     function parentRewards(uint256 _from, uint256 _to) external view returns(uint256);
2264     function LPRewards(uint256 _from, uint256 _to) external view returns(uint256);
2265     function lastRewardTime() external view returns (uint256);
2266 }
2267 
2268 
2269 // File interfaces/IDigitalaxNFT.sol
2270 
2271 
2272 
2273 pragma solidity 0.6.12;
2274 
2275 /// @dev an interface to interact with the Genesis MONA NFT that will 
2276 interface IDigitalaxNFT {
2277     function primarySalePrice(uint256 tokenId) external view returns (uint256);
2278     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
2279     function balanceOf(address owner) external view returns (uint256);
2280     function safeTransferFrom(address from, address to, uint256 tokenId) external;
2281 }
2282 
2283 
2284 // File contracts/DigitalaxNFTStaking.sol
2285 
2286 
2287 
2288 pragma solidity 0.6.12;
2289 
2290 
2291 
2292 
2293 
2294 
2295 /**
2296  * @title Digitalax Staking
2297  * @dev Stake NFTs, earn tokens on the Digitialax platform
2298  * @author Adrian Guerrera (deepyr)
2299  */
2300 
2301 contract DigitalaxNFTStaking {
2302     using SafeMath for uint256;
2303     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
2304 
2305     IERC20 public rewardsToken;
2306     IDigitalaxNFT public parentNFT;
2307     DigitalaxAccessControls public accessControls;
2308     IDigitalaxRewards public rewardsContract;
2309 
2310 
2311     /// @notice total ethereum staked currently in the gensesis staking contract
2312     uint256 public stakedEthTotal;
2313     uint256 public lastUpdateTime;
2314 
2315     uint256 public rewardsPerTokenPoints;
2316     uint256 public totalUnclaimedRewards;
2317 
2318     uint256 constant pointMultiplier = 10e18;
2319 
2320     /**
2321     @notice Struct to track what user is staking which tokens
2322     @dev tokenIds are all the tokens staked by the staker
2323     @dev balance is the current ether balance of the staker
2324     @dev rewardsEarned is the total reward for the staker till now
2325     @dev rewardsReleased is how much reward has been paid to the staker
2326     */
2327     struct Staker {
2328         uint256[] tokenIds;
2329         mapping (uint256 => uint256) tokenIndex;
2330         uint256 balance;
2331         uint256 lastRewardPoints;
2332         uint256 rewardsEarned;
2333         uint256 rewardsReleased;
2334     }
2335 
2336     /// @notice mapping of a staker to its current properties
2337     mapping (address => Staker) public stakers;
2338 
2339     // Mapping from token ID to owner address
2340     mapping (uint256 => address) public tokenOwner;
2341 
2342     /// @notice sets the token to be claimable or not, cannot claim if it set to false
2343     bool public tokensClaimable;
2344     bool initialised;
2345 
2346     /// @notice event emitted when a user has staked a token
2347     event Staked(address owner, uint256 amount);
2348 
2349     /// @notice event emitted when a user has unstaked a token
2350     event Unstaked(address owner, uint256 amount);
2351 
2352     /// @notice event emitted when a user claims reward
2353     event RewardPaid(address indexed user, uint256 reward);
2354     
2355     /// @notice Allows reward tokens to be claimed
2356     event ClaimableStatusUpdated(bool status);
2357 
2358     /// @notice Emergency unstake tokens without rewards
2359     event EmergencyUnstake(address indexed user, uint256 tokenId);
2360 
2361     /// @notice Admin update of rewards contract
2362     event RewardsTokenUpdated(address indexed oldRewardsToken, address newRewardsToken );
2363 
2364     constructor() public {
2365     }
2366      /**
2367      * @dev Single gateway to intialize the staking contract after deploying
2368      * @dev Sets the contract with the MONA NFT and MONA reward token 
2369      */
2370     function initStaking(
2371         IERC20 _rewardsToken,
2372         IDigitalaxNFT _parentNFT,
2373         DigitalaxAccessControls _accessControls
2374     )
2375         external
2376     {
2377         require(!initialised, "Already initialised");
2378         rewardsToken = _rewardsToken;
2379         parentNFT = _parentNFT;
2380         accessControls = _accessControls;
2381         lastUpdateTime = block.timestamp;
2382         initialised = true;
2383     }
2384 
2385 
2386     /// @notice Lets admin set the Rewards Token
2387     function setRewardsContract(
2388         address _addr
2389     )
2390         external
2391     {
2392         require(
2393             accessControls.hasAdminRole(msg.sender),
2394             "DigitalaxParentStaking.setRewardsContract: Sender must be admin"
2395         );
2396         require(_addr != address(0));
2397         address oldAddr = address(rewardsContract);
2398         rewardsContract = IDigitalaxRewards(_addr);
2399         emit RewardsTokenUpdated(oldAddr, _addr);
2400     }
2401 
2402     /// @notice Lets admin set the Rewards to be claimable
2403     function setTokensClaimable(
2404         bool _enabled
2405     )
2406         external
2407     {
2408         require(
2409             accessControls.hasAdminRole(msg.sender),
2410             "DigitalaxParentStaking.setTokensClaimable: Sender must be admin"
2411         );
2412         tokensClaimable = _enabled;
2413         emit ClaimableStatusUpdated(_enabled);
2414     }
2415 
2416     /// @dev Getter functions for Staking contract
2417     /// @dev Get the tokens staked by a user
2418     function getStakedTokens(
2419         address _user
2420     )
2421         external
2422         view
2423         returns (uint256[] memory tokenIds)
2424     {
2425         return stakers[_user].tokenIds;
2426     }
2427 
2428 
2429     /// @dev Get the amount a staked nft is valued at ie bought at
2430     function getContribution (
2431         uint256 _tokenId
2432     ) 
2433         public
2434         view
2435         returns (uint256)
2436     {
2437         return parentNFT.primarySalePrice(_tokenId);
2438     }
2439 
2440     /// @notice Stake MONA NFTs and earn reward tokens. 
2441     function stake(
2442         uint256 tokenId
2443     )
2444         external
2445     {
2446         // require();
2447         _stake(msg.sender, tokenId);
2448     }
2449 
2450     /// @notice Stake multiple MONA NFTs and earn reward tokens. 
2451     function stakeBatch(uint256[] memory tokenIds)
2452         external
2453     {
2454         for (uint i = 0; i < tokenIds.length; i++) {
2455             _stake(msg.sender, tokenIds[i]);
2456         }
2457     }
2458 
2459     /// @notice Stake all your MONA NFTs and earn reward tokens. 
2460     function stakeAll()
2461         external
2462     {
2463         uint256 balance = parentNFT.balanceOf(msg.sender);
2464         for (uint i = 0; i < balance; i++) {
2465             _stake(msg.sender, parentNFT.tokenOfOwnerByIndex(msg.sender,i));
2466         }
2467     }
2468 
2469 
2470     /**
2471      * @dev All the staking goes through this function
2472      * @dev Rewards to be given out is calculated
2473      * @dev Balance of stakers are updated as they stake the nfts based on ether price
2474     */
2475     function _stake(
2476         address _user,
2477         uint256 _tokenId
2478     )
2479         internal
2480     {
2481         Staker storage staker = stakers[_user];
2482 
2483         if (staker.balance == 0 && staker.lastRewardPoints == 0 ) {
2484           staker.lastRewardPoints = rewardsPerTokenPoints;
2485         }
2486 
2487         updateReward(_user);
2488         uint256 amount = getContribution(_tokenId);
2489         staker.balance = staker.balance.add(amount);
2490         stakedEthTotal = stakedEthTotal.add(amount);
2491         staker.tokenIds.push(_tokenId);
2492         staker.tokenIndex[staker.tokenIds.length - 1];
2493         tokenOwner[_tokenId] = _user;
2494         parentNFT.safeTransferFrom(
2495             _user,
2496             address(this),
2497             _tokenId
2498         );
2499 
2500         emit Staked(_user, _tokenId);
2501     }
2502 
2503     /// @notice Unstake Genesis MONA NFTs. 
2504     function unstake(
2505         uint256 _tokenId
2506     ) 
2507         external 
2508     {
2509         require(
2510             tokenOwner[_tokenId] == msg.sender,
2511             "DigitalaxParentStaking._unstake: Sender must have staked tokenID"
2512         );
2513         claimReward(msg.sender);
2514         _unstake(msg.sender, _tokenId);
2515     }
2516 
2517     /// @notice Stake multiple MONA NFTs and claim reward tokens. 
2518     function unstakeBatch(
2519         uint256[] memory tokenIds
2520     )
2521         external
2522     {
2523         claimReward(msg.sender);
2524         for (uint i = 0; i < tokenIds.length; i++) {
2525             if (tokenOwner[i] == msg.sender) {
2526                 _unstake(msg.sender, tokenIds[i]);
2527             }
2528         }
2529     }
2530 
2531      /**
2532      * @dev All the unstaking goes through this function
2533      * @dev Rewards to be given out is calculated
2534      * @dev Balance of stakers are updated as they unstake the nfts based on ether price
2535     */
2536     function _unstake(
2537         address _user,
2538         uint256 _tokenId
2539     ) 
2540         internal 
2541     {
2542 
2543         Staker storage staker = stakers[_user];
2544 
2545         uint256 amount = getContribution(_tokenId);
2546         staker.balance = staker.balance.sub(amount);
2547         stakedEthTotal = stakedEthTotal.sub(amount);
2548 
2549         uint256 lastIndex = staker.tokenIds.length - 1;
2550         uint256 lastIndexKey = staker.tokenIds[lastIndex];
2551         uint256 tokenIdIndex = staker.tokenIndex[_tokenId];
2552         
2553         staker.tokenIds[staker.tokenIndex[_tokenId]] = lastIndexKey;
2554         staker.tokenIndex[lastIndexKey] = tokenIdIndex;
2555         if (staker.tokenIds.length > 0) {
2556             staker.tokenIds.pop();
2557             delete staker.tokenIndex[_tokenId];
2558         }
2559 
2560         if (staker.balance == 0) {
2561             delete stakers[_user];
2562         }
2563         delete tokenOwner[_tokenId];
2564 
2565         parentNFT.safeTransferFrom(
2566             address(this),
2567             _user,
2568             _tokenId
2569         );
2570 
2571         emit Unstaked(_user, _tokenId);
2572 
2573     }
2574 
2575     // Unstake without caring about rewards. EMERGENCY ONLY.
2576     function emergencyUnstake(uint256 _tokenId) public {
2577         require(
2578             tokenOwner[_tokenId] == msg.sender,
2579             "DigitalaxParentStaking._unstake: Sender must have staked tokenID"
2580         );
2581         _unstake(msg.sender, _tokenId);
2582         emit EmergencyUnstake(msg.sender, _tokenId);
2583 
2584     }
2585 
2586 
2587     /// @dev Updates the amount of rewards owed for each user before any tokens are moved
2588     function updateReward(
2589         address _user
2590     ) 
2591         public 
2592     {
2593 
2594         rewardsContract.updateRewards();
2595         uint256 parentRewards = rewardsContract.parentRewards(lastUpdateTime, block.timestamp);
2596 
2597         if (stakedEthTotal > 0) {
2598             rewardsPerTokenPoints = rewardsPerTokenPoints.add(parentRewards
2599                                             .mul(1e18)
2600                                             .mul(pointMultiplier)
2601                                             .div(stakedEthTotal));
2602         }
2603         
2604         lastUpdateTime = block.timestamp;
2605         uint256 rewards = rewardsOwing(_user);
2606 
2607         Staker storage staker = stakers[_user];
2608         if (_user != address(0)) {
2609             staker.rewardsEarned = staker.rewardsEarned.add(rewards);
2610             staker.lastRewardPoints = rewardsPerTokenPoints; 
2611         }
2612     }
2613 
2614 
2615     /// @notice Returns the rewards owing for a user
2616     /// @dev The rewards are dynamic and normalised from the other pools
2617     /// @dev This gets the rewards from each of the periods as one multiplier
2618     function rewardsOwing(
2619         address _user
2620     )
2621         public
2622         view
2623         returns(uint256)
2624     {
2625         uint256 newRewardPerToken = rewardsPerTokenPoints.sub(stakers[_user].lastRewardPoints);
2626         uint256 rewards = stakers[_user].balance.mul(newRewardPerToken)
2627                                                 .div(1e18)
2628                                                 .div(pointMultiplier);
2629         return rewards;
2630     }
2631 
2632 
2633     /// @notice Returns the about of rewards yet to be claimed
2634     function unclaimedRewards(
2635         address _user
2636     )
2637         external
2638         view
2639         returns(uint256)
2640     {
2641         if (stakedEthTotal == 0) {
2642             return 0;
2643         }
2644 
2645         uint256 parentRewards = rewardsContract.parentRewards(lastUpdateTime,
2646                                                         block.timestamp);
2647 
2648         uint256 newRewardPerToken = rewardsPerTokenPoints.add(parentRewards
2649                                                                 .mul(1e18)
2650                                                                 .mul(pointMultiplier)
2651                                                                 .div(stakedEthTotal))
2652                                                          .sub(stakers[_user].lastRewardPoints);
2653                                                          
2654         uint256 rewards = stakers[_user].balance.mul(newRewardPerToken)
2655                                                 .div(1e18)
2656                                                 .div(pointMultiplier);
2657         return rewards.add(stakers[_user].rewardsEarned).sub(stakers[_user].rewardsReleased);
2658     }
2659 
2660 
2661     /// @notice Lets a user with rewards owing to claim tokens
2662     function claimReward(
2663         address _user
2664     )
2665         public
2666     {
2667         require(
2668             tokensClaimable == true,
2669             "Tokens cannnot be claimed yet"
2670         );
2671         updateReward(_user);
2672 
2673         Staker storage staker = stakers[_user];
2674     
2675         uint256 payableAmount = staker.rewardsEarned.sub(staker.rewardsReleased);
2676         staker.rewardsReleased = staker.rewardsReleased.add(payableAmount);
2677 
2678         /// @dev accounts for dust 
2679         uint256 rewardBal = rewardsToken.balanceOf(address(this));
2680         if (payableAmount > rewardBal) {
2681             payableAmount = rewardBal;
2682         }
2683 
2684         rewardsToken.transfer(_user, payableAmount);
2685         emit RewardPaid(_user, payableAmount);
2686     }
2687 
2688 
2689     function onERC721Received(
2690         address,
2691         address,
2692         uint256,
2693         bytes calldata data
2694     )
2695         public returns(bytes4)
2696     {
2697         return _ERC721_RECEIVED;
2698     }
2699 
2700 
2701 
2702 }