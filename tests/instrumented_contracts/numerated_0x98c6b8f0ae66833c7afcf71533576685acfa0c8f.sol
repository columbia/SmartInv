1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.6.12;
3 
4 /**
5  * @dev Standard math utilities missing in the Solidity language.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the average of two numbers. The result is rounded towards
24      * zero.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
32 /**
33  * @dev Wrappers over Solidity's arithmetic operations with added overflow
34  * checks.
35  *
36  * Arithmetic operations in Solidity wrap on overflow. This can easily result
37  * in bugs, because programmers usually assume that an overflow raises an
38  * error, which is the standard behavior in high level programming languages.
39  * `SafeMath` restores this intuition by reverting the transaction when an
40  * operation overflows.
41  *
42  * Using this library instead of the unchecked operations eliminates an entire
43  * class of bugs, so it's recommended to use it always.
44  */
45 library SafeMath {
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting on
48      * overflow.
49      *
50      * Counterpart to Solidity's `+` operator.
51      *
52      * Requirements:
53      *
54      * - Addition cannot overflow.
55      */
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting on
65      * overflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      *
71      * - Subtraction cannot overflow.
72      */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      *
85      * - Subtraction cannot overflow.
86      */
87     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the multiplication of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `*` operator.
99      *
100      * Requirements:
101      *
102      * - Multiplication cannot overflow.
103      */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      *
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return div(a, b, "SafeMath: division by zero");
132     }
133 
134     /**
135      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
136      * division by zero. The result is rounded towards zero.
137      *
138      * Counterpart to Solidity's `/` operator. Note: this function uses a
139      * `revert` opcode (which leaves remaining gas untouched) while Solidity
140      * uses an invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b > 0, errorMessage);
148         uint256 c = a / b;
149         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * Reverts when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return mod(a, b, "SafeMath: modulo by zero");
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts with custom message when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         require(b != 0, errorMessage);
184         return a % b;
185     }
186 }
187 
188 /**
189  * @dev Library for managing
190  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
191  * types.
192  *
193  * Sets have the following properties:
194  *
195  * - Elements are added, removed, and checked for existence in constant time
196  * (O(1)).
197  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
198  *
199  * ```
200  * contract Example {
201  *     // Add the library methods
202  *     using EnumerableSet for EnumerableSet.AddressSet;
203  *
204  *     // Declare a set state variable
205  *     EnumerableSet.AddressSet private mySet;
206  * }
207  * ```
208  *
209  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
210  * (`UintSet`) are supported.
211  */
212 library EnumerableSet {
213     // To implement this library for multiple types with as little code
214     // repetition as possible, we write it in terms of a generic Set type with
215     // bytes32 values.
216     // The Set implementation uses private functions, and user-facing
217     // implementations (such as AddressSet) are just wrappers around the
218     // underlying Set.
219     // This means that we can only create new EnumerableSets for types that fit
220     // in bytes32.
221 
222     struct Set {
223         // Storage of set values
224         bytes32[] _values;
225 
226         // Position of the value in the `values` array, plus 1 because index 0
227         // means a value is not in the set.
228         mapping (bytes32 => uint256) _indexes;
229     }
230 
231     /**
232      * @dev Add a value to a set. O(1).
233      *
234      * Returns true if the value was added to the set, that is if it was not
235      * already present.
236      */
237     function _add(Set storage set, bytes32 value) private returns (bool) {
238         if (!_contains(set, value)) {
239             set._values.push(value);
240             // The value is stored at length-1, but we add 1 to all indexes
241             // and use 0 as a sentinel value
242             set._indexes[value] = set._values.length;
243             return true;
244         } else {
245             return false;
246         }
247     }
248 
249     /**
250      * @dev Removes a value from a set. O(1).
251      *
252      * Returns true if the value was removed from the set, that is if it was
253      * present.
254      */
255     function _remove(Set storage set, bytes32 value) private returns (bool) {
256         // We read and store the value's index to prevent multiple reads from the same storage slot
257         uint256 valueIndex = set._indexes[value];
258 
259         if (valueIndex != 0) { // Equivalent to contains(set, value)
260             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
261             // the array, and then remove the last element (sometimes called as 'swap and pop').
262             // This modifies the order of the array, as noted in {at}.
263 
264             uint256 toDeleteIndex = valueIndex - 1;
265             uint256 lastIndex = set._values.length - 1;
266 
267             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
268             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
269 
270             bytes32 lastvalue = set._values[lastIndex];
271 
272             // Move the last value to the index where the value to delete is
273             set._values[toDeleteIndex] = lastvalue;
274             // Update the index for the moved value
275             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
276 
277             // Delete the slot where the moved value was stored
278             set._values.pop();
279 
280             // Delete the index for the deleted slot
281             delete set._indexes[value];
282 
283             return true;
284         } else {
285             return false;
286         }
287     }
288 
289     /**
290      * @dev Returns true if the value is in the set. O(1).
291      */
292     function _contains(Set storage set, bytes32 value) private view returns (bool) {
293         return set._indexes[value] != 0;
294     }
295 
296     /**
297      * @dev Returns the number of values on the set. O(1).
298      */
299     function _length(Set storage set) private view returns (uint256) {
300         return set._values.length;
301     }
302 
303    /**
304     * @dev Returns the value stored at position `index` in the set. O(1).
305     *
306     * Note that there are no guarantees on the ordering of values inside the
307     * array, and it may change when more values are added or removed.
308     *
309     * Requirements:
310     *
311     * - `index` must be strictly less than {length}.
312     */
313     function _at(Set storage set, uint256 index) private view returns (bytes32) {
314         require(set._values.length > index, "EnumerableSet: index out of bounds");
315         return set._values[index];
316     }
317 
318     // AddressSet
319 
320     struct AddressSet {
321         Set _inner;
322     }
323 
324     /**
325      * @dev Add a value to a set. O(1).
326      *
327      * Returns true if the value was added to the set, that is if it was not
328      * already present.
329      */
330     function add(AddressSet storage set, address value) internal returns (bool) {
331         return _add(set._inner, bytes32(uint256(value)));
332     }
333 
334     /**
335      * @dev Removes a value from a set. O(1).
336      *
337      * Returns true if the value was removed from the set, that is if it was
338      * present.
339      */
340     function remove(AddressSet storage set, address value) internal returns (bool) {
341         return _remove(set._inner, bytes32(uint256(value)));
342     }
343 
344     /**
345      * @dev Returns true if the value is in the set. O(1).
346      */
347     function contains(AddressSet storage set, address value) internal view returns (bool) {
348         return _contains(set._inner, bytes32(uint256(value)));
349     }
350 
351     /**
352      * @dev Returns the number of values in the set. O(1).
353      */
354     function length(AddressSet storage set) internal view returns (uint256) {
355         return _length(set._inner);
356     }
357 
358    /**
359     * @dev Returns the value stored at position `index` in the set. O(1).
360     *
361     * Note that there are no guarantees on the ordering of values inside the
362     * array, and it may change when more values are added or removed.
363     *
364     * Requirements:
365     *
366     * - `index` must be strictly less than {length}.
367     */
368     function at(AddressSet storage set, uint256 index) internal view returns (address) {
369         return address(uint256(_at(set._inner, index)));
370     }
371 
372 
373     // UintSet
374 
375     struct UintSet {
376         Set _inner;
377     }
378 
379     /**
380      * @dev Add a value to a set. O(1).
381      *
382      * Returns true if the value was added to the set, that is if it was not
383      * already present.
384      */
385     function add(UintSet storage set, uint256 value) internal returns (bool) {
386         return _add(set._inner, bytes32(value));
387     }
388 
389     /**
390      * @dev Removes a value from a set. O(1).
391      *
392      * Returns true if the value was removed from the set, that is if it was
393      * present.
394      */
395     function remove(UintSet storage set, uint256 value) internal returns (bool) {
396         return _remove(set._inner, bytes32(value));
397     }
398 
399     /**
400      * @dev Returns true if the value is in the set. O(1).
401      */
402     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
403         return _contains(set._inner, bytes32(value));
404     }
405 
406     /**
407      * @dev Returns the number of values on the set. O(1).
408      */
409     function length(UintSet storage set) internal view returns (uint256) {
410         return _length(set._inner);
411     }
412 
413    /**
414     * @dev Returns the value stored at position `index` in the set. O(1).
415     *
416     * Note that there are no guarantees on the ordering of values inside the
417     * array, and it may change when more values are added or removed.
418     *
419     * Requirements:
420     *
421     * - `index` must be strictly less than {length}.
422     */
423     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
424         return uint256(_at(set._inner, index));
425     }
426 }
427 
428 /**
429  * @dev Collection of functions related to the address type
430  */
431 library Address {
432     /**
433      * @dev Returns true if `account` is a contract.
434      *
435      * [IMPORTANT]
436      * ====
437      * It is unsafe to assume that an address for which this function returns
438      * false is an externally-owned account (EOA) and not a contract.
439      *
440      * Among others, `isContract` will return false for the following
441      * types of addresses:
442      *
443      *  - an externally-owned account
444      *  - a contract in construction
445      *  - an address where a contract will be created
446      *  - an address where a contract lived, but was destroyed
447      * ====
448      */
449     function isContract(address account) internal view returns (bool) {
450         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
451         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
452         // for accounts without code, i.e. `keccak256('')`
453         bytes32 codehash;
454         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
455         // solhint-disable-next-line no-inline-assembly
456         assembly { codehash := extcodehash(account) }
457         return (codehash != accountHash && codehash != 0x0);
458     }
459 
460     /**
461      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
462      * `recipient`, forwarding all available gas and reverting on errors.
463      *
464      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
465      * of certain opcodes, possibly making contracts go over the 2300 gas limit
466      * imposed by `transfer`, making them unable to receive funds via
467      * `transfer`. {sendValue} removes this limitation.
468      *
469      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
470      *
471      * IMPORTANT: because control is transferred to `recipient`, care must be
472      * taken to not create reentrancy vulnerabilities. Consider using
473      * {ReentrancyGuard} or the
474      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
475      */
476     function sendValue(address payable recipient, uint256 amount) internal {
477         require(address(this).balance >= amount, "Address: insufficient balance");
478 
479         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
480         (bool success, ) = recipient.call{ value: amount }("");
481         require(success, "Address: unable to send value, recipient may have reverted");
482     }
483 
484     /**
485      * @dev Performs a Solidity function call using a low level `call`. A
486      * plain`call` is an unsafe replacement for a function call: use this
487      * function instead.
488      *
489      * If `target` reverts with a revert reason, it is bubbled up by this
490      * function (like regular Solidity function calls).
491      *
492      * Returns the raw returned data. To convert to the expected return value,
493      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
494      *
495      * Requirements:
496      *
497      * - `target` must be a contract.
498      * - calling `target` with `data` must not revert.
499      *
500      * _Available since v3.1._
501      */
502     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
503       return functionCall(target, data, "Address: low-level call failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
508      * `errorMessage` as a fallback revert reason when `target` reverts.
509      *
510      * _Available since v3.1._
511      */
512     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
513         return _functionCallWithValue(target, data, 0, errorMessage);
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
518      * but also transferring `value` wei to `target`.
519      *
520      * Requirements:
521      *
522      * - the calling contract must have an ETH balance of at least `value`.
523      * - the called Solidity function must be `payable`.
524      *
525      * _Available since v3.1._
526      */
527     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
528         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
533      * with `errorMessage` as a fallback revert reason when `target` reverts.
534      *
535      * _Available since v3.1._
536      */
537     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
538         require(address(this).balance >= value, "Address: insufficient balance for call");
539         return _functionCallWithValue(target, data, value, errorMessage);
540     }
541 
542     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
543         require(isContract(target), "Address: call to non-contract");
544 
545         // solhint-disable-next-line avoid-low-level-calls
546         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
547         if (success) {
548             return returndata;
549         } else {
550             // Look for revert reason and bubble it up if present
551             if (returndata.length > 0) {
552                 // The easiest way to bubble the revert reason is using memory via assembly
553 
554                 // solhint-disable-next-line no-inline-assembly
555                 assembly {
556                     let returndata_size := mload(returndata)
557                     revert(add(32, returndata), returndata_size)
558                 }
559             } else {
560                 revert(errorMessage);
561             }
562         }
563     }
564 }
565 
566 /*
567  * @dev Provides information about the current execution context, including the
568  * sender of the transaction and its data. While these are generally available
569  * via msg.sender and msg.data, they should not be accessed in such a direct
570  * manner, since when dealing with GSN meta-transactions the account sending and
571  * paying for execution may not be the actual sender (as far as an application
572  * is concerned).
573  *
574  * This contract is only required for intermediate, library-like contracts.
575  */
576 abstract contract Context {
577     function _msgSender() internal view virtual returns (address payable) {
578         return msg.sender;
579     }
580 
581     function _msgData() internal view virtual returns (bytes memory) {
582         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
583         return msg.data;
584     }
585 }
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
797 /**
798  * @dev Interface of the ERC20 standard as defined in the EIP.
799  */
800 interface IERC20 {
801     /**
802      * @dev Returns the amount of tokens in existence.
803      */
804     function totalSupply() external view returns (uint256);
805 
806     /**
807      * @dev Returns the amount of tokens owned by `account`.
808      */
809     function balanceOf(address account) external view returns (uint256);
810 
811     /**
812      * @dev Moves `amount` tokens from the caller's account to `recipient`.
813      *
814      * Returns a boolean value indicating whether the operation succeeded.
815      *
816      * Emits a {Transfer} event.
817      */
818     function transfer(address recipient, uint256 amount) external returns (bool);
819 
820     /**
821      * @dev Returns the remaining number of tokens that `spender` will be
822      * allowed to spend on behalf of `owner` through {transferFrom}. This is
823      * zero by default.
824      *
825      * This value changes when {approve} or {transferFrom} are called.
826      */
827     function allowance(address owner, address spender) external view returns (uint256);
828 
829     /**
830      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
831      *
832      * Returns a boolean value indicating whether the operation succeeded.
833      *
834      * IMPORTANT: Beware that changing an allowance with this method brings the risk
835      * that someone may use both the old and the new allowance by unfortunate
836      * transaction ordering. One possible solution to mitigate this race
837      * condition is to first reduce the spender's allowance to 0 and set the
838      * desired value afterwards:
839      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
840      *
841      * Emits an {Approval} event.
842      */
843     function approve(address spender, uint256 amount) external returns (bool);
844 
845     /**
846      * @dev Moves `amount` tokens from `sender` to `recipient` using the
847      * allowance mechanism. `amount` is then deducted from the caller's
848      * allowance.
849      *
850      * Returns a boolean value indicating whether the operation succeeded.
851      *
852      * Emits a {Transfer} event.
853      */
854     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
855 
856     /**
857      * @dev Emitted when `value` tokens are moved from one account (`from`) to
858      * another (`to`).
859      *
860      * Note that `value` may be zero.
861      */
862     event Transfer(address indexed from, address indexed to, uint256 value);
863 
864     /**
865      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
866      * a call to {approve}. `value` is the new allowance.
867      */
868     event Approval(address indexed owner, address indexed spender, uint256 value);
869 }
870 
871 /**
872  * @title SafeERC20
873  * @dev Wrappers around ERC20 operations that throw on failure (when the token
874  * contract returns false). Tokens that return no value (and instead revert or
875  * throw on failure) are also supported, non-reverting calls are assumed to be
876  * successful.
877  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
878  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
879  */
880 library SafeERC20 {
881     using SafeMath for uint256;
882     using Address for address;
883 
884     function safeTransfer(IERC20 token, address to, uint256 value) internal {
885         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
886     }
887 
888     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
889         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
890     }
891 
892     /**
893      * @dev Deprecated. This function has issues similar to the ones found in
894      * {IERC20-approve}, and its usage is discouraged.
895      *
896      * Whenever possible, use {safeIncreaseAllowance} and
897      * {safeDecreaseAllowance} instead.
898      */
899     function safeApprove(IERC20 token, address spender, uint256 value) internal {
900         // safeApprove should only be called when setting an initial allowance,
901         // or when resetting it to zero. To increase and decrease it, use
902         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
903         // solhint-disable-next-line max-line-length
904         require((value == 0) || (token.allowance(address(this), spender) == 0),
905             "SafeERC20: approve from non-zero to non-zero allowance"
906         );
907         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
908     }
909 
910     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
911         uint256 newAllowance = token.allowance(address(this), spender).add(value);
912         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
913     }
914 
915     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
916         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
917         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
918     }
919 
920     /**
921      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
922      * on the return value: the return value is optional (but if data is returned, it must not be false).
923      * @param token The token targeted by the call.
924      * @param data The call data (encoded using abi.encode or one of its variants).
925      */
926     function _callOptionalReturn(IERC20 token, bytes memory data) private {
927         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
928         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
929         // the target address contains contract code and also asserts for success in the low-level call.
930 
931         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
932         if (returndata.length > 0) { // Return data is optional
933             // solhint-disable-next-line max-line-length
934             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
935         }
936     }
937 }
938 
939 interface IUniswapV2Pair {
940     event Approval(address indexed owner, address indexed spender, uint value);
941     event Transfer(address indexed from, address indexed to, uint value);
942 
943     function name() external pure returns (string memory);
944     function symbol() external pure returns (string memory);
945     function decimals() external pure returns (uint8);
946     function totalSupply() external view returns (uint);
947     function balanceOf(address owner) external view returns (uint);
948     function allowance(address owner, address spender) external view returns (uint);
949 
950     function approve(address spender, uint value) external returns (bool);
951     function transfer(address to, uint value) external returns (bool);
952     function transferFrom(address from, address to, uint value) external returns (bool);
953 
954     function DOMAIN_SEPARATOR() external view returns (bytes32);
955     function PERMIT_TYPEHASH() external pure returns (bytes32);
956     function nonces(address owner) external view returns (uint);
957 
958     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
959 
960     event Mint(address indexed sender, uint amount0, uint amount1);
961     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
962     event Swap(
963         address indexed sender,
964         uint amount0In,
965         uint amount1In,
966         uint amount0Out,
967         uint amount1Out,
968         address indexed to
969     );
970     event Sync(uint112 reserve0, uint112 reserve1);
971 
972     function MINIMUM_LIQUIDITY() external pure returns (uint);
973     function factory() external view returns (address);
974     function token0() external view returns (address);
975     function token1() external view returns (address);
976     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
977     function price0CumulativeLast() external view returns (uint);
978     function price1CumulativeLast() external view returns (uint);
979     function kLast() external view returns (uint);
980 
981     function mint(address to) external returns (uint liquidity);
982     function burn(address to) external returns (uint amount0, uint amount1);
983     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
984     function skim(address to) external;
985     function sync() external;
986 
987     function initialize(address, address) external;
988 }
989 
990 contract Staking is AccessControl {
991   using SafeMath for uint256;
992   using SafeERC20 for IERC20;
993 
994   // Uniswap v2 KIRO/Other pair
995   IUniswapV2Pair public PAIR;
996   // Kirobo Token
997   IERC20 public KIRO;
998   // keccak256("DISTRIBUTER_ROLE")
999   bytes32 public constant DISTRIBUTER_ROLE = 0x09630fffc1c31ed9c8dd68f6e39219ed189b07ff9a25e1efc743b828f69d555e;
1000 
1001   uint256 private s_totalSupply;
1002   uint256 private s_periodFinish;
1003   uint256 private s_rewardRate;
1004   uint256 private s_lastUpdateTime;
1005   uint256 private s_rewardPerTokenStored;
1006   uint256 private s_stakingLimit;
1007   uint256 private s_leftover;
1008   mapping(address => uint256) private s_balances;
1009   mapping(address => uint256) private s_userRewardPerTokenPaid;
1010   mapping(address => uint256) private s_rewards;
1011 
1012   event RewardAdded(address indexed distributer, uint256 reward, uint256 duration);
1013   event LeftoverCollected(address indexed distributer, uint256 amount);
1014   event Staked(address indexed user, uint256 amount);
1015   event Withdrawn(address indexed user, uint256 amount);
1016   event RewardPaid(address indexed user, uint256 reward);
1017 
1018   modifier updateReward(address account) {
1019     s_rewardPerTokenStored = rewardPerToken();
1020     uint256 lastTimeRewardApplicable = lastTimeRewardApplicable();
1021     if (s_totalSupply == 0) {
1022       s_leftover = s_leftover.add(lastTimeRewardApplicable.sub(s_lastUpdateTime).mul(s_rewardRate));
1023     }
1024     s_lastUpdateTime = lastTimeRewardApplicable;
1025     if (account != address(0)) {
1026       s_rewards[account] = earned(account);
1027       s_userRewardPerTokenPaid[account] = s_rewardPerTokenStored;
1028     }
1029     _;
1030   }
1031 
1032   modifier onlyDistributer() {
1033     require(hasRole(DISTRIBUTER_ROLE, msg.sender), "Staking: Caller is not a distributer");
1034     _;
1035   }
1036 
1037   constructor (address pair, address kiro) public {
1038     _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1039     _setupRole(DISTRIBUTER_ROLE, msg.sender);
1040     PAIR = IUniswapV2Pair(pair);
1041     KIRO = IERC20(kiro);
1042     s_stakingLimit = 7e18;
1043     require(address(PAIR).isContract(), "Staking: pair is not a contract");
1044     require(address(KIRO).isContract(), "Staking: kiro is not a contract");
1045     require(address(PAIR) != address(KIRO), "Staking: pair and kiro are the same");
1046   }
1047 
1048   receive() external payable {
1049     require(false, "Staking: not aceepting ether");
1050   }
1051 
1052   function setStakingLimit(uint256 other) external onlyDistributer() {
1053     s_stakingLimit = other;
1054   }
1055 
1056   function addReward(address from, uint256 amount, uint256 duration) external onlyDistributer() updateReward(address(0)) {
1057     require(amount > duration, 'Staking: Cannot approve less than 1');
1058     uint256 newRate = amount.div(duration);
1059     require(newRate >= s_rewardRate, "Staking: degragration is not allowed");
1060     if(now < s_periodFinish)
1061       amount = amount.sub(s_periodFinish.sub(now).mul(s_rewardRate));
1062     s_rewardRate = newRate;
1063     s_lastUpdateTime = now;
1064     s_periodFinish = now.add(duration);
1065     KIRO.safeTransferFrom(from, address(this), amount);
1066     emit RewardAdded(msg.sender, amount, duration);
1067   }
1068 
1069   function collectLeftover() external onlyDistributer() updateReward(address(0)) {
1070     uint256 balance = KIRO.balanceOf(address(this));
1071     uint256 amount = Math.min(s_leftover, balance);
1072     s_leftover = 0;
1073     KIRO.safeTransfer(msg.sender, amount);
1074     emit LeftoverCollected(msg.sender, amount);
1075   }
1076 
1077   function stake(uint256 amount) external updateReward(msg.sender) {
1078     require(amount > 0, "Staking: cannot stake 0");
1079     require(amount <= pairLimit(msg.sender), "Staking: amount exceeds limit");
1080     s_balances[msg.sender] = s_balances[msg.sender].add(amount);
1081     s_totalSupply = s_totalSupply.add(amount);
1082     IERC20(address(PAIR)).safeTransferFrom(msg.sender, address(this), amount);
1083     emit Staked(msg.sender, amount);
1084   }
1085 
1086   function exit() external {
1087     withdraw(s_balances[msg.sender]);
1088     getReward();
1089   }
1090 
1091   function withdraw(uint256 amount) public updateReward(msg.sender) {
1092     require(amount > 0, 'Staking: cannot withdraw 0');
1093     s_totalSupply = s_totalSupply.sub(amount);
1094     s_balances[msg.sender] = s_balances[msg.sender].sub(amount);
1095     IERC20(address(PAIR)).safeTransfer(msg.sender, amount);
1096     emit Withdrawn(msg.sender, amount);
1097   }
1098 
1099   function getReward() public updateReward(msg.sender) {
1100     uint256 reward = earned(msg.sender);
1101     if (reward > 0) {
1102       s_rewards[msg.sender] = 0;
1103       KIRO.safeTransfer(msg.sender, reward);
1104       emit RewardPaid(msg.sender, reward);
1105     }
1106   }
1107 
1108   function earned(address account) public view returns (uint256) {
1109     return
1110     (
1111       s_balances[account]
1112       .mul
1113       (
1114         rewardPerToken()
1115         .sub(s_userRewardPerTokenPaid[account])
1116       )
1117       .div(1e18)
1118       .add(s_rewards[account])
1119     );
1120   }
1121 
1122   function rewardPerToken() public view returns (uint256) {
1123     if (s_totalSupply == 0) {
1124       return s_rewardPerTokenStored;
1125     }
1126     return
1127       s_rewardPerTokenStored
1128       .add
1129       (
1130         lastTimeRewardApplicable()
1131         .sub(s_lastUpdateTime)
1132         .mul(s_rewardRate)
1133         .mul(1e18)
1134         .div(s_totalSupply)
1135       );
1136   }
1137 
1138   function lastTimeRewardApplicable() public view returns (uint256) {
1139     return Math.min(now, s_periodFinish);
1140   }
1141 
1142   function pairLimit(address account) public view returns (uint256) {
1143     (, uint256 other, uint256 totalSupply) = pairInfo();
1144     uint256 limit = totalSupply.mul(s_stakingLimit).div(other);
1145     uint256 balance = s_balances[account];
1146     return limit > balance ? limit - balance : 0;
1147   }
1148 
1149   function pairInfo() public view returns (uint256 kiro, uint256 other, uint256 totalSupply) {
1150     totalSupply = PAIR.totalSupply();
1151     (uint256 reserves0, uint256 reserves1,) = PAIR.getReserves();
1152     (kiro, other) = address(KIRO) == PAIR.token0() ? (reserves0, reserves1) : (reserves1, reserves0);
1153   }
1154 
1155   function pairOtherBalance(uint256 amount) external view returns (uint256) {
1156     (, uint256 other, uint256 totalSupply) = pairInfo();
1157     return other.mul(amount).div(totalSupply);
1158   }
1159 
1160   function pairKiroBalance(uint256 amount) external view returns (uint256) {
1161     (uint256 kiro, , uint256 totalSupply) = pairInfo();
1162     return kiro.mul(amount).div(totalSupply);
1163   }
1164 
1165   function totalSupply() external view returns (uint256) {
1166     return s_totalSupply;
1167   }
1168 
1169   function periodFinish() external view returns (uint256) {
1170     return s_periodFinish;
1171   }
1172 
1173   function rewardRate() external view returns (uint256) {
1174     return s_rewardRate;
1175   }
1176 
1177   function lastUpdateTime() external view returns (uint256) {
1178     return s_lastUpdateTime;
1179   }
1180 
1181   function rewardPerTokenStored() external view returns (uint256) {
1182     return s_rewardPerTokenStored;
1183   }
1184 
1185   function balanceOf(address account) external view returns (uint256) {
1186     return s_balances[account];
1187   }
1188 
1189   function userRewardPerTokenPaid(address account) external view returns (uint256) {
1190     return s_userRewardPerTokenPaid[account];
1191   }
1192 
1193   function rewards(address account) external view returns (uint256) {
1194     return s_rewards[account];
1195   }
1196 
1197   function stakingLimit() external view returns (uint256) {
1198     return s_stakingLimit;
1199   }
1200 
1201   function leftover() external view returns (uint256) {
1202     return s_leftover;
1203   }
1204 
1205 }