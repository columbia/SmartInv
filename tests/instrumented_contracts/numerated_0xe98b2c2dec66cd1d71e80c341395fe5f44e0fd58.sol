1 pragma solidity ^0.6.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 // SPDX-License-Identifier: MIT
162 /**
163  * @dev Library for managing
164  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
165  * types.
166  *
167  * Sets have the following properties:
168  *
169  * - Elements are added, removed, and checked for existence in constant time
170  * (O(1)).
171  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
172  *
173  * ```
174  * contract Example {
175  *     // Add the library methods
176  *     using EnumerableSet for EnumerableSet.AddressSet;
177  *
178  *     // Declare a set state variable
179  *     EnumerableSet.AddressSet private mySet;
180  * }
181  * ```
182  *
183  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
184  * (`UintSet`) are supported.
185  */
186 library EnumerableSet {
187     // To implement this library for multiple types with as little code
188     // repetition as possible, we write it in terms of a generic Set type with
189     // bytes32 values.
190     // The Set implementation uses private functions, and user-facing
191     // implementations (such as AddressSet) are just wrappers around the
192     // underlying Set.
193     // This means that we can only create new EnumerableSets for types that fit
194     // in bytes32.
195 
196     struct Set {
197         // Storage of set values
198         bytes32[] _values;
199 
200         // Position of the value in the `values` array, plus 1 because index 0
201         // means a value is not in the set.
202         mapping (bytes32 => uint256) _indexes;
203     }
204 
205     /**
206      * @dev Add a value to a set. O(1).
207      *
208      * Returns true if the value was added to the set, that is if it was not
209      * already present.
210      */
211     function _add(Set storage set, bytes32 value) private returns (bool) {
212         if (!_contains(set, value)) {
213             set._values.push(value);
214             // The value is stored at length-1, but we add 1 to all indexes
215             // and use 0 as a sentinel value
216             set._indexes[value] = set._values.length;
217             return true;
218         } else {
219             return false;
220         }
221     }
222 
223     /**
224      * @dev Removes a value from a set. O(1).
225      *
226      * Returns true if the value was removed from the set, that is if it was
227      * present.
228      */
229     function _remove(Set storage set, bytes32 value) private returns (bool) {
230         // We read and store the value's index to prevent multiple reads from the same storage slot
231         uint256 valueIndex = set._indexes[value];
232 
233         if (valueIndex != 0) { // Equivalent to contains(set, value)
234             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
235             // the array, and then remove the last element (sometimes called as 'swap and pop').
236             // This modifies the order of the array, as noted in {at}.
237 
238             uint256 toDeleteIndex = valueIndex - 1;
239             uint256 lastIndex = set._values.length - 1;
240 
241             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
242             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
243 
244             bytes32 lastvalue = set._values[lastIndex];
245 
246             // Move the last value to the index where the value to delete is
247             set._values[toDeleteIndex] = lastvalue;
248             // Update the index for the moved value
249             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
250 
251             // Delete the slot where the moved value was stored
252             set._values.pop();
253 
254             // Delete the index for the deleted slot
255             delete set._indexes[value];
256 
257             return true;
258         } else {
259             return false;
260         }
261     }
262 
263     /**
264      * @dev Returns true if the value is in the set. O(1).
265      */
266     function _contains(Set storage set, bytes32 value) private view returns (bool) {
267         return set._indexes[value] != 0;
268     }
269 
270     /**
271      * @dev Returns the number of values on the set. O(1).
272      */
273     function _length(Set storage set) private view returns (uint256) {
274         return set._values.length;
275     }
276 
277    /**
278     * @dev Returns the value stored at position `index` in the set. O(1).
279     *
280     * Note that there are no guarantees on the ordering of values inside the
281     * array, and it may change when more values are added or removed.
282     *
283     * Requirements:
284     *
285     * - `index` must be strictly less than {length}.
286     */
287     function _at(Set storage set, uint256 index) private view returns (bytes32) {
288         require(set._values.length > index, "EnumerableSet: index out of bounds");
289         return set._values[index];
290     }
291 
292     // AddressSet
293 
294     struct AddressSet {
295         Set _inner;
296     }
297 
298     /**
299      * @dev Add a value to a set. O(1).
300      *
301      * Returns true if the value was added to the set, that is if it was not
302      * already present.
303      */
304     function add(AddressSet storage set, address value) internal returns (bool) {
305         return _add(set._inner, bytes32(uint256(value)));
306     }
307 
308     /**
309      * @dev Removes a value from a set. O(1).
310      *
311      * Returns true if the value was removed from the set, that is if it was
312      * present.
313      */
314     function remove(AddressSet storage set, address value) internal returns (bool) {
315         return _remove(set._inner, bytes32(uint256(value)));
316     }
317 
318     /**
319      * @dev Returns true if the value is in the set. O(1).
320      */
321     function contains(AddressSet storage set, address value) internal view returns (bool) {
322         return _contains(set._inner, bytes32(uint256(value)));
323     }
324 
325     /**
326      * @dev Returns the number of values in the set. O(1).
327      */
328     function length(AddressSet storage set) internal view returns (uint256) {
329         return _length(set._inner);
330     }
331 
332    /**
333     * @dev Returns the value stored at position `index` in the set. O(1).
334     *
335     * Note that there are no guarantees on the ordering of values inside the
336     * array, and it may change when more values are added or removed.
337     *
338     * Requirements:
339     *
340     * - `index` must be strictly less than {length}.
341     */
342     function at(AddressSet storage set, uint256 index) internal view returns (address) {
343         return address(uint256(_at(set._inner, index)));
344     }
345 
346 
347     // UintSet
348 
349     struct UintSet {
350         Set _inner;
351     }
352 
353     /**
354      * @dev Add a value to a set. O(1).
355      *
356      * Returns true if the value was added to the set, that is if it was not
357      * already present.
358      */
359     function add(UintSet storage set, uint256 value) internal returns (bool) {
360         return _add(set._inner, bytes32(value));
361     }
362 
363     /**
364      * @dev Removes a value from a set. O(1).
365      *
366      * Returns true if the value was removed from the set, that is if it was
367      * present.
368      */
369     function remove(UintSet storage set, uint256 value) internal returns (bool) {
370         return _remove(set._inner, bytes32(value));
371     }
372 
373     /**
374      * @dev Returns true if the value is in the set. O(1).
375      */
376     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
377         return _contains(set._inner, bytes32(value));
378     }
379 
380     /**
381      * @dev Returns the number of values on the set. O(1).
382      */
383     function length(UintSet storage set) internal view returns (uint256) {
384         return _length(set._inner);
385     }
386 
387    /**
388     * @dev Returns the value stored at position `index` in the set. O(1).
389     *
390     * Note that there are no guarantees on the ordering of values inside the
391     * array, and it may change when more values are added or removed.
392     *
393     * Requirements:
394     *
395     * - `index` must be strictly less than {length}.
396     */
397     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
398         return uint256(_at(set._inner, index));
399     }
400 }
401 
402 // SPDX-License-Identifier: MIT
403 /**
404  * @dev Collection of functions related to the address type
405  */
406 library Address {
407     /**
408      * @dev Returns true if `account` is a contract.
409      *
410      * [IMPORTANT]
411      * ====
412      * It is unsafe to assume that an address for which this function returns
413      * false is an externally-owned account (EOA) and not a contract.
414      *
415      * Among others, `isContract` will return false for the following
416      * types of addresses:
417      *
418      *  - an externally-owned account
419      *  - a contract in construction
420      *  - an address where a contract will be created
421      *  - an address where a contract lived, but was destroyed
422      * ====
423      */
424     function isContract(address account) internal view returns (bool) {
425         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
426         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
427         // for accounts without code, i.e. `keccak256('')`
428         bytes32 codehash;
429         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
430         // solhint-disable-next-line no-inline-assembly
431         assembly { codehash := extcodehash(account) }
432         return (codehash != accountHash && codehash != 0x0);
433     }
434 
435     /**
436      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
437      * `recipient`, forwarding all available gas and reverting on errors.
438      *
439      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
440      * of certain opcodes, possibly making contracts go over the 2300 gas limit
441      * imposed by `transfer`, making them unable to receive funds via
442      * `transfer`. {sendValue} removes this limitation.
443      *
444      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
445      *
446      * IMPORTANT: because control is transferred to `recipient`, care must be
447      * taken to not create reentrancy vulnerabilities. Consider using
448      * {ReentrancyGuard} or the
449      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
450      */
451     function sendValue(address payable recipient, uint256 amount) internal {
452         require(address(this).balance >= amount, "Address: insufficient balance");
453 
454         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
455         (bool success, ) = recipient.call{ value: amount }("");
456         require(success, "Address: unable to send value, recipient may have reverted");
457     }
458 
459     /**
460      * @dev Performs a Solidity function call using a low level `call`. A
461      * plain`call` is an unsafe replacement for a function call: use this
462      * function instead.
463      *
464      * If `target` reverts with a revert reason, it is bubbled up by this
465      * function (like regular Solidity function calls).
466      *
467      * Returns the raw returned data. To convert to the expected return value,
468      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
469      *
470      * Requirements:
471      *
472      * - `target` must be a contract.
473      * - calling `target` with `data` must not revert.
474      *
475      * _Available since v3.1._
476      */
477     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
478       return functionCall(target, data, "Address: low-level call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
483      * `errorMessage` as a fallback revert reason when `target` reverts.
484      *
485      * _Available since v3.1._
486      */
487     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
488         return _functionCallWithValue(target, data, 0, errorMessage);
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
493      * but also transferring `value` wei to `target`.
494      *
495      * Requirements:
496      *
497      * - the calling contract must have an ETH balance of at least `value`.
498      * - the called Solidity function must be `payable`.
499      *
500      * _Available since v3.1._
501      */
502     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
503         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
508      * with `errorMessage` as a fallback revert reason when `target` reverts.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
513         require(address(this).balance >= value, "Address: insufficient balance for call");
514         return _functionCallWithValue(target, data, value, errorMessage);
515     }
516 
517     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
518         require(isContract(target), "Address: call to non-contract");
519 
520         // solhint-disable-next-line avoid-low-level-calls
521         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
522         if (success) {
523             return returndata;
524         } else {
525             // Look for revert reason and bubble it up if present
526             if (returndata.length > 0) {
527                 // The easiest way to bubble the revert reason is using memory via assembly
528 
529                 // solhint-disable-next-line no-inline-assembly
530                 assembly {
531                     let returndata_size := mload(returndata)
532                     revert(add(32, returndata), returndata_size)
533                 }
534             } else {
535                 revert(errorMessage);
536             }
537         }
538     }
539 }
540 
541 // SPDX-License-Identifier: MIT
542 /*
543  * @dev Provides information about the current execution context, including the
544  * sender of the transaction and its data. While these are generally available
545  * via msg.sender and msg.data, they should not be accessed in such a direct
546  * manner, since when dealing with GSN meta-transactions the account sending and
547  * paying for execution may not be the actual sender (as far as an application
548  * is concerned).
549  *
550  * This contract is only required for intermediate, library-like contracts.
551  */
552 abstract contract Context {
553     function _msgSender() internal view virtual returns (address payable) {
554         return msg.sender;
555     }
556 
557     function _msgData() internal view virtual returns (bytes memory) {
558         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
559         return msg.data;
560     }
561 }
562 
563 // SPDX-License-Identifier: MIT
564 /**
565  * @dev Contract module that allows children to implement role-based access
566  * control mechanisms.
567  *
568  * Roles are referred to by their `bytes32` identifier. These should be exposed
569  * in the external API and be unique. The best way to achieve this is by
570  * using `public constant` hash digests:
571  *
572  * ```
573  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
574  * ```
575  *
576  * Roles can be used to represent a set of permissions. To restrict access to a
577  * function call, use {hasRole}:
578  *
579  * ```
580  * function foo() public {
581  *     require(hasRole(MY_ROLE, msg.sender));
582  *     ...
583  * }
584  * ```
585  *
586  * Roles can be granted and revoked dynamically via the {grantRole} and
587  * {revokeRole} functions. Each role has an associated admin role, and only
588  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
589  *
590  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
591  * that only accounts with this role will be able to grant or revoke other
592  * roles. More complex role relationships can be created by using
593  * {_setRoleAdmin}.
594  *
595  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
596  * grant and revoke this role. Extra precautions should be taken to secure
597  * accounts that have been granted it.
598  */
599 abstract contract AccessControl is Context {
600     using EnumerableSet for EnumerableSet.AddressSet;
601     using Address for address;
602 
603     struct RoleData {
604         EnumerableSet.AddressSet members;
605         bytes32 adminRole;
606     }
607 
608     mapping (bytes32 => RoleData) private _roles;
609 
610     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
611 
612     /**
613      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
614      *
615      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
616      * {RoleAdminChanged} not being emitted signaling this.
617      *
618      * _Available since v3.1._
619      */
620     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
621 
622     /**
623      * @dev Emitted when `account` is granted `role`.
624      *
625      * `sender` is the account that originated the contract call, an admin role
626      * bearer except when using {_setupRole}.
627      */
628     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
629 
630     /**
631      * @dev Emitted when `account` is revoked `role`.
632      *
633      * `sender` is the account that originated the contract call:
634      *   - if using `revokeRole`, it is the admin role bearer
635      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
636      */
637     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
638 
639     /**
640      * @dev Returns `true` if `account` has been granted `role`.
641      */
642     function hasRole(bytes32 role, address account) public view returns (bool) {
643         return _roles[role].members.contains(account);
644     }
645 
646     /**
647      * @dev Returns the number of accounts that have `role`. Can be used
648      * together with {getRoleMember} to enumerate all bearers of a role.
649      */
650     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
651         return _roles[role].members.length();
652     }
653 
654     /**
655      * @dev Returns one of the accounts that have `role`. `index` must be a
656      * value between 0 and {getRoleMemberCount}, non-inclusive.
657      *
658      * Role bearers are not sorted in any particular way, and their ordering may
659      * change at any point.
660      *
661      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
662      * you perform all queries on the same block. See the following
663      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
664      * for more information.
665      */
666     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
667         return _roles[role].members.at(index);
668     }
669 
670     /**
671      * @dev Returns the admin role that controls `role`. See {grantRole} and
672      * {revokeRole}.
673      *
674      * To change a role's admin, use {_setRoleAdmin}.
675      */
676     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
677         return _roles[role].adminRole;
678     }
679 
680     /**
681      * @dev Grants `role` to `account`.
682      *
683      * If `account` had not been already granted `role`, emits a {RoleGranted}
684      * event.
685      *
686      * Requirements:
687      *
688      * - the caller must have ``role``'s admin role.
689      */
690     function grantRole(bytes32 role, address account) public virtual {
691         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
692 
693         _grantRole(role, account);
694     }
695 
696     /**
697      * @dev Revokes `role` from `account`.
698      *
699      * If `account` had been granted `role`, emits a {RoleRevoked} event.
700      *
701      * Requirements:
702      *
703      * - the caller must have ``role``'s admin role.
704      */
705     function revokeRole(bytes32 role, address account) public virtual {
706         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
707 
708         _revokeRole(role, account);
709     }
710 
711     /**
712      * @dev Revokes `role` from the calling account.
713      *
714      * Roles are often managed via {grantRole} and {revokeRole}: this function's
715      * purpose is to provide a mechanism for accounts to lose their privileges
716      * if they are compromised (such as when a trusted device is misplaced).
717      *
718      * If the calling account had been granted `role`, emits a {RoleRevoked}
719      * event.
720      *
721      * Requirements:
722      *
723      * - the caller must be `account`.
724      */
725     function renounceRole(bytes32 role, address account) public virtual {
726         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
727 
728         _revokeRole(role, account);
729     }
730 
731     /**
732      * @dev Grants `role` to `account`.
733      *
734      * If `account` had not been already granted `role`, emits a {RoleGranted}
735      * event. Note that unlike {grantRole}, this function doesn't perform any
736      * checks on the calling account.
737      *
738      * [WARNING]
739      * ====
740      * This function should only be called from the constructor when setting
741      * up the initial roles for the system.
742      *
743      * Using this function in any other way is effectively circumventing the admin
744      * system imposed by {AccessControl}.
745      * ====
746      */
747     function _setupRole(bytes32 role, address account) internal virtual {
748         _grantRole(role, account);
749     }
750 
751     /**
752      * @dev Sets `adminRole` as ``role``'s admin role.
753      *
754      * Emits a {RoleAdminChanged} event.
755      */
756     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
757         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
758         _roles[role].adminRole = adminRole;
759     }
760 
761     function _grantRole(bytes32 role, address account) private {
762         if (_roles[role].members.add(account)) {
763             emit RoleGranted(role, account, _msgSender());
764         }
765     }
766 
767     function _revokeRole(bytes32 role, address account) private {
768         if (_roles[role].members.remove(account)) {
769             emit RoleRevoked(role, account, _msgSender());
770         }
771     }
772 }
773 
774 // SPDX-License-Identifier: MIT
775 contract Administered is AccessControl {
776     bytes32 public constant USER_ROLE = keccak256("USER");
777 
778     /// @dev Add `root` to the admin role as a member.
779     constructor (address root) public {
780         _setupRole(DEFAULT_ADMIN_ROLE, root);
781         _setRoleAdmin(USER_ROLE, DEFAULT_ADMIN_ROLE);
782     }
783 
784     /// @dev Restricted to members of the admin role.
785     modifier onlyAdmin() {
786         require(isAdmin(msg.sender), "Restricted to admins.");
787         _;
788     }
789 
790     /// @dev Restricted to members of the user role.
791     modifier onlyUser() {
792         require(isUser(msg.sender), "Restricted to users.");
793         _;
794     }
795 
796     /// @dev Return `true` if the account belongs to the admin role.
797     function isAdmin(address account) public virtual view returns (bool) {
798         return hasRole(DEFAULT_ADMIN_ROLE, account);
799     }
800 
801     /// @dev Return `true` if the account belongs to the user role.
802     function isUser(address account) public virtual view returns (bool) {
803         return hasRole(USER_ROLE, account);
804     }
805 
806     /// @dev Add an account to the user role. Restricted to admins.
807     function addUser(address account) public virtual onlyAdmin {
808         grantRole(USER_ROLE, account);
809     }
810 
811     /// @dev Add an account to the admin role. Restricted to admins.
812     function addAdmin(address account) public virtual onlyAdmin {
813         grantRole(DEFAULT_ADMIN_ROLE, account);
814     }
815 
816     /// @dev Remove an account from the user role. Restricted to admins.
817     function removeUser(address account) public virtual onlyAdmin {
818         revokeRole(USER_ROLE, account);
819     }
820 
821     /// @dev Remove oneself from the admin role.
822     function renounceAdmin() public virtual {
823         renounceRole(DEFAULT_ADMIN_ROLE, msg.sender);
824     }
825 }
826 
827 // SPDX-License-Identifier: MIT
828 contract Wallet is Administered {
829     using SafeMath for uint256;
830 
831     event Deposit(address indexed from, uint256 indexed value);
832     event TransferETH(address indexed to, uint256 indexed amount);
833 
834     constructor() public Administered(msg.sender) {
835         addUser(msg.sender);
836     }
837 
838     receive() external payable {
839         emit Deposit(msg.sender, msg.value);
840     }
841 
842     function batchTransferETH(address payable[] memory _contributors, uint256[] memory _amount) public payable onlyUser {
843         uint8 i = 0;
844         for (i; i < _amount.length; i++) {
845             _contributors[i].transfer(_amount[i]);
846             emit TransferETH(_contributors[i], _amount[i]);
847         }
848     }
849 }