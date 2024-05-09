1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.11;
4 
5 
6 // 
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
163 // 
164 /**
165  * @dev Library for managing
166  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
167  * types.
168  *
169  * Sets have the following properties:
170  *
171  * - Elements are added, removed, and checked for existence in constant time
172  * (O(1)).
173  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
174  *
175  * ```
176  * contract Example {
177  *     // Add the library methods
178  *     using EnumerableSet for EnumerableSet.AddressSet;
179  *
180  *     // Declare a set state variable
181  *     EnumerableSet.AddressSet private mySet;
182  * }
183  * ```
184  *
185  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
186  * (`UintSet`) are supported.
187  */
188 library EnumerableSet {
189     // To implement this library for multiple types with as little code
190     // repetition as possible, we write it in terms of a generic Set type with
191     // bytes32 values.
192     // The Set implementation uses private functions, and user-facing
193     // implementations (such as AddressSet) are just wrappers around the
194     // underlying Set.
195     // This means that we can only create new EnumerableSets for types that fit
196     // in bytes32.
197 
198     struct Set {
199         // Storage of set values
200         bytes32[] _values;
201 
202         // Position of the value in the `values` array, plus 1 because index 0
203         // means a value is not in the set.
204         mapping (bytes32 => uint256) _indexes;
205     }
206 
207     /**
208      * @dev Add a value to a set. O(1).
209      *
210      * Returns true if the value was added to the set, that is if it was not
211      * already present.
212      */
213     function _add(Set storage set, bytes32 value) private returns (bool) {
214         if (!_contains(set, value)) {
215             set._values.push(value);
216             // The value is stored at length-1, but we add 1 to all indexes
217             // and use 0 as a sentinel value
218             set._indexes[value] = set._values.length;
219             return true;
220         } else {
221             return false;
222         }
223     }
224 
225     /**
226      * @dev Removes a value from a set. O(1).
227      *
228      * Returns true if the value was removed from the set, that is if it was
229      * present.
230      */
231     function _remove(Set storage set, bytes32 value) private returns (bool) {
232         // We read and store the value's index to prevent multiple reads from the same storage slot
233         uint256 valueIndex = set._indexes[value];
234 
235         if (valueIndex != 0) { // Equivalent to contains(set, value)
236             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
237             // the array, and then remove the last element (sometimes called as 'swap and pop').
238             // This modifies the order of the array, as noted in {at}.
239 
240             uint256 toDeleteIndex = valueIndex - 1;
241             uint256 lastIndex = set._values.length - 1;
242 
243             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
244             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
245 
246             bytes32 lastvalue = set._values[lastIndex];
247 
248             // Move the last value to the index where the value to delete is
249             set._values[toDeleteIndex] = lastvalue;
250             // Update the index for the moved value
251             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
252 
253             // Delete the slot where the moved value was stored
254             set._values.pop();
255 
256             // Delete the index for the deleted slot
257             delete set._indexes[value];
258 
259             return true;
260         } else {
261             return false;
262         }
263     }
264 
265     /**
266      * @dev Returns true if the value is in the set. O(1).
267      */
268     function _contains(Set storage set, bytes32 value) private view returns (bool) {
269         return set._indexes[value] != 0;
270     }
271 
272     /**
273      * @dev Returns the number of values on the set. O(1).
274      */
275     function _length(Set storage set) private view returns (uint256) {
276         return set._values.length;
277     }
278 
279    /**
280     * @dev Returns the value stored at position `index` in the set. O(1).
281     *
282     * Note that there are no guarantees on the ordering of values inside the
283     * array, and it may change when more values are added or removed.
284     *
285     * Requirements:
286     *
287     * - `index` must be strictly less than {length}.
288     */
289     function _at(Set storage set, uint256 index) private view returns (bytes32) {
290         require(set._values.length > index, "EnumerableSet: index out of bounds");
291         return set._values[index];
292     }
293 
294     // AddressSet
295 
296     struct AddressSet {
297         Set _inner;
298     }
299 
300     /**
301      * @dev Add a value to a set. O(1).
302      *
303      * Returns true if the value was added to the set, that is if it was not
304      * already present.
305      */
306     function add(AddressSet storage set, address value) internal returns (bool) {
307         return _add(set._inner, bytes32(uint256(value)));
308     }
309 
310     /**
311      * @dev Removes a value from a set. O(1).
312      *
313      * Returns true if the value was removed from the set, that is if it was
314      * present.
315      */
316     function remove(AddressSet storage set, address value) internal returns (bool) {
317         return _remove(set._inner, bytes32(uint256(value)));
318     }
319 
320     /**
321      * @dev Returns true if the value is in the set. O(1).
322      */
323     function contains(AddressSet storage set, address value) internal view returns (bool) {
324         return _contains(set._inner, bytes32(uint256(value)));
325     }
326 
327     /**
328      * @dev Returns the number of values in the set. O(1).
329      */
330     function length(AddressSet storage set) internal view returns (uint256) {
331         return _length(set._inner);
332     }
333 
334    /**
335     * @dev Returns the value stored at position `index` in the set. O(1).
336     *
337     * Note that there are no guarantees on the ordering of values inside the
338     * array, and it may change when more values are added or removed.
339     *
340     * Requirements:
341     *
342     * - `index` must be strictly less than {length}.
343     */
344     function at(AddressSet storage set, uint256 index) internal view returns (address) {
345         return address(uint256(_at(set._inner, index)));
346     }
347 
348 
349     // UintSet
350 
351     struct UintSet {
352         Set _inner;
353     }
354 
355     /**
356      * @dev Add a value to a set. O(1).
357      *
358      * Returns true if the value was added to the set, that is if it was not
359      * already present.
360      */
361     function add(UintSet storage set, uint256 value) internal returns (bool) {
362         return _add(set._inner, bytes32(value));
363     }
364 
365     /**
366      * @dev Removes a value from a set. O(1).
367      *
368      * Returns true if the value was removed from the set, that is if it was
369      * present.
370      */
371     function remove(UintSet storage set, uint256 value) internal returns (bool) {
372         return _remove(set._inner, bytes32(value));
373     }
374 
375     /**
376      * @dev Returns true if the value is in the set. O(1).
377      */
378     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
379         return _contains(set._inner, bytes32(value));
380     }
381 
382     /**
383      * @dev Returns the number of values on the set. O(1).
384      */
385     function length(UintSet storage set) internal view returns (uint256) {
386         return _length(set._inner);
387     }
388 
389    /**
390     * @dev Returns the value stored at position `index` in the set. O(1).
391     *
392     * Note that there are no guarantees on the ordering of values inside the
393     * array, and it may change when more values are added or removed.
394     *
395     * Requirements:
396     *
397     * - `index` must be strictly less than {length}.
398     */
399     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
400         return uint256(_at(set._inner, index));
401     }
402 }
403 
404 // 
405 /**
406  * @dev Collection of functions related to the address type
407  */
408 library Address {
409     /**
410      * @dev Returns true if `account` is a contract.
411      *
412      * [IMPORTANT]
413      * ====
414      * It is unsafe to assume that an address for which this function returns
415      * false is an externally-owned account (EOA) and not a contract.
416      *
417      * Among others, `isContract` will return false for the following
418      * types of addresses:
419      *
420      *  - an externally-owned account
421      *  - a contract in construction
422      *  - an address where a contract will be created
423      *  - an address where a contract lived, but was destroyed
424      * ====
425      */
426     function isContract(address account) internal view returns (bool) {
427         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
428         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
429         // for accounts without code, i.e. `keccak256('')`
430         bytes32 codehash;
431         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
432         // solhint-disable-next-line no-inline-assembly
433         assembly { codehash := extcodehash(account) }
434         return (codehash != accountHash && codehash != 0x0);
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(address(this).balance >= amount, "Address: insufficient balance");
455 
456         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
457         (bool success, ) = recipient.call{ value: amount }("");
458         require(success, "Address: unable to send value, recipient may have reverted");
459     }
460 
461     /**
462      * @dev Performs a Solidity function call using a low level `call`. A
463      * plain`call` is an unsafe replacement for a function call: use this
464      * function instead.
465      *
466      * If `target` reverts with a revert reason, it is bubbled up by this
467      * function (like regular Solidity function calls).
468      *
469      * Returns the raw returned data. To convert to the expected return value,
470      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
471      *
472      * Requirements:
473      *
474      * - `target` must be a contract.
475      * - calling `target` with `data` must not revert.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
480       return functionCall(target, data, "Address: low-level call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
485      * `errorMessage` as a fallback revert reason when `target` reverts.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
490         return _functionCallWithValue(target, data, 0, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but also transferring `value` wei to `target`.
496      *
497      * Requirements:
498      *
499      * - the calling contract must have an ETH balance of at least `value`.
500      * - the called Solidity function must be `payable`.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
510      * with `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
515         require(address(this).balance >= value, "Address: insufficient balance for call");
516         return _functionCallWithValue(target, data, value, errorMessage);
517     }
518 
519     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
520         require(isContract(target), "Address: call to non-contract");
521 
522         // solhint-disable-next-line avoid-low-level-calls
523         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
524         if (success) {
525             return returndata;
526         } else {
527             // Look for revert reason and bubble it up if present
528             if (returndata.length > 0) {
529                 // The easiest way to bubble the revert reason is using memory via assembly
530 
531                 // solhint-disable-next-line no-inline-assembly
532                 assembly {
533                     let returndata_size := mload(returndata)
534                     revert(add(32, returndata), returndata_size)
535                 }
536             } else {
537                 revert(errorMessage);
538             }
539         }
540     }
541 }
542 
543 // 
544 /*
545  * @dev Provides information about the current execution context, including the
546  * sender of the transaction and its data. While these are generally available
547  * via msg.sender and msg.data, they should not be accessed in such a direct
548  * manner, since when dealing with GSN meta-transactions the account sending and
549  * paying for execution may not be the actual sender (as far as an application
550  * is concerned).
551  *
552  * This contract is only required for intermediate, library-like contracts.
553  */
554 abstract contract Context {
555     function _msgSender() internal view virtual returns (address payable) {
556         return msg.sender;
557     }
558 
559     function _msgData() internal view virtual returns (bytes memory) {
560         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
561         return msg.data;
562     }
563 }
564 
565 // 
566 /**
567  * @dev Contract module that allows children to implement role-based access
568  * control mechanisms.
569  *
570  * Roles are referred to by their `bytes32` identifier. These should be exposed
571  * in the external API and be unique. The best way to achieve this is by
572  * using `public constant` hash digests:
573  *
574  * ```
575  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
576  * ```
577  *
578  * Roles can be used to represent a set of permissions. To restrict access to a
579  * function call, use {hasRole}:
580  *
581  * ```
582  * function foo() public {
583  *     require(hasRole(MY_ROLE, msg.sender));
584  *     ...
585  * }
586  * ```
587  *
588  * Roles can be granted and revoked dynamically via the {grantRole} and
589  * {revokeRole} functions. Each role has an associated admin role, and only
590  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
591  *
592  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
593  * that only accounts with this role will be able to grant or revoke other
594  * roles. More complex role relationships can be created by using
595  * {_setRoleAdmin}.
596  *
597  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
598  * grant and revoke this role. Extra precautions should be taken to secure
599  * accounts that have been granted it.
600  */
601 abstract contract AccessControl is Context {
602     using EnumerableSet for EnumerableSet.AddressSet;
603     using Address for address;
604 
605     struct RoleData {
606         EnumerableSet.AddressSet members;
607         bytes32 adminRole;
608     }
609 
610     mapping (bytes32 => RoleData) private _roles;
611 
612     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
613 
614     /**
615      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
616      *
617      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
618      * {RoleAdminChanged} not being emitted signaling this.
619      *
620      * _Available since v3.1._
621      */
622     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
623 
624     /**
625      * @dev Emitted when `account` is granted `role`.
626      *
627      * `sender` is the account that originated the contract call, an admin role
628      * bearer except when using {_setupRole}.
629      */
630     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
631 
632     /**
633      * @dev Emitted when `account` is revoked `role`.
634      *
635      * `sender` is the account that originated the contract call:
636      *   - if using `revokeRole`, it is the admin role bearer
637      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
638      */
639     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
640 
641     /**
642      * @dev Returns `true` if `account` has been granted `role`.
643      */
644     function hasRole(bytes32 role, address account) public view returns (bool) {
645         return _roles[role].members.contains(account);
646     }
647 
648     /**
649      * @dev Returns the number of accounts that have `role`. Can be used
650      * together with {getRoleMember} to enumerate all bearers of a role.
651      */
652     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
653         return _roles[role].members.length();
654     }
655 
656     /**
657      * @dev Returns one of the accounts that have `role`. `index` must be a
658      * value between 0 and {getRoleMemberCount}, non-inclusive.
659      *
660      * Role bearers are not sorted in any particular way, and their ordering may
661      * change at any point.
662      *
663      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
664      * you perform all queries on the same block. See the following
665      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
666      * for more information.
667      */
668     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
669         return _roles[role].members.at(index);
670     }
671 
672     /**
673      * @dev Returns the admin role that controls `role`. See {grantRole} and
674      * {revokeRole}.
675      *
676      * To change a role's admin, use {_setRoleAdmin}.
677      */
678     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
679         return _roles[role].adminRole;
680     }
681 
682     /**
683      * @dev Grants `role` to `account`.
684      *
685      * If `account` had not been already granted `role`, emits a {RoleGranted}
686      * event.
687      *
688      * Requirements:
689      *
690      * - the caller must have ``role``'s admin role.
691      */
692     function grantRole(bytes32 role, address account) public virtual {
693         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
694 
695         _grantRole(role, account);
696     }
697 
698     /**
699      * @dev Revokes `role` from `account`.
700      *
701      * If `account` had been granted `role`, emits a {RoleRevoked} event.
702      *
703      * Requirements:
704      *
705      * - the caller must have ``role``'s admin role.
706      */
707     function revokeRole(bytes32 role, address account) public virtual {
708         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
709 
710         _revokeRole(role, account);
711     }
712 
713     /**
714      * @dev Revokes `role` from the calling account.
715      *
716      * Roles are often managed via {grantRole} and {revokeRole}: this function's
717      * purpose is to provide a mechanism for accounts to lose their privileges
718      * if they are compromised (such as when a trusted device is misplaced).
719      *
720      * If the calling account had been granted `role`, emits a {RoleRevoked}
721      * event.
722      *
723      * Requirements:
724      *
725      * - the caller must be `account`.
726      */
727     function renounceRole(bytes32 role, address account) public virtual {
728         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
729 
730         _revokeRole(role, account);
731     }
732 
733     /**
734      * @dev Grants `role` to `account`.
735      *
736      * If `account` had not been already granted `role`, emits a {RoleGranted}
737      * event. Note that unlike {grantRole}, this function doesn't perform any
738      * checks on the calling account.
739      *
740      * [WARNING]
741      * ====
742      * This function should only be called from the constructor when setting
743      * up the initial roles for the system.
744      *
745      * Using this function in any other way is effectively circumventing the admin
746      * system imposed by {AccessControl}.
747      * ====
748      */
749     function _setupRole(bytes32 role, address account) internal virtual {
750         _grantRole(role, account);
751     }
752 
753     /**
754      * @dev Sets `adminRole` as ``role``'s admin role.
755      *
756      * Emits a {RoleAdminChanged} event.
757      */
758     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
759         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
760         _roles[role].adminRole = adminRole;
761     }
762 
763     function _grantRole(bytes32 role, address account) private {
764         if (_roles[role].members.add(account)) {
765             emit RoleGranted(role, account, _msgSender());
766         }
767     }
768 
769     function _revokeRole(bytes32 role, address account) private {
770         if (_roles[role].members.remove(account)) {
771             emit RoleRevoked(role, account, _msgSender());
772         }
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
837 interface IExchange {
838     event SwapWINGSForXFI(address indexed sender, uint256 amountIn, uint256 amountOut);
839     event SwapsStarted();
840     event SwapsStopped();
841     event WINGSWithdrawal(address indexed to, uint256 amount);
842     event MaxGasPriceChanged(uint256 newMaxGasPrice);
843 
844     function wingsToken() external view returns (address);
845     function xfiToken() external view returns (address);
846     function estimateSwapWINGSForXFI(uint256 amountIn) external view returns (uint256[] memory amounts);
847     function estimateSwapWINGSForXFIPerDay(uint256 amountIn) external view returns (uint256);
848     function isSwappingStopped() external view returns (bool);
849     function maxGasPrice() external view returns (uint256);
850 
851     function swapWINGSForXFI(uint256 amountIn) external returns (uint256[] memory amounts);
852     function stopSwaps() external returns (bool);
853     function startSwaps() external returns (bool);
854     function withdrawWINGS(address to, uint256 amount) external returns (bool);
855     function setMaxGasPrice(uint256 maxGasPrice_) external returns (bool);
856 }
857 
858 // 
859 interface IERC20 {
860     event Approval(address indexed owner, address indexed spender, uint256 value);
861     event Transfer(address indexed from, address indexed to, uint256 value);
862 
863     function name() external view returns (string memory);
864     function symbol() external view returns (string memory);
865     function decimals() external view returns (uint8);
866     function totalSupply() external view returns (uint256);
867     function balanceOf(address account) external view returns (uint256);
868     function allowance(address owner, address spender) external view returns (uint256);
869 
870     function approve(address spender, uint256 amount) external returns (bool);
871     function transfer(address recipient, uint256 amount) external returns (bool);
872     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
873 }
874 
875 // 
876 /**
877  * XFI token extends the interface of ERC20 standard.
878  */
879 interface IXFIToken is IERC20 {
880     event VestingStartChanged(uint256 newVestingStart, uint256 newVestingEnd, uint256 newReserveFrozenUntil);
881     event TransfersStarted();
882     event TransfersStopped();
883     event MigrationsAllowed();
884     event ReserveWithdrawal(address indexed to, uint256 amount);
885     event VestingBalanceMigrated(address indexed from, bytes32 to, uint256 vestingDaysLeft, uint256 vestingBalance);
886 
887     function isTransferringStopped() external view returns (bool);
888     function isMigratingAllowed() external view returns (bool);
889     function VESTING_DURATION() external view returns (uint256);
890     function VESTING_DURATION_DAYS() external view returns (uint256);
891     function RESERVE_FREEZE_DURATION() external view returns (uint256);
892     function RESERVE_FREEZE_DURATION_DAYS() external view returns (uint256);
893     function MAX_VESTING_TOTAL_SUPPLY() external view returns (uint256);
894     function vestingStart() external view returns (uint256);
895     function vestingEnd() external view returns (uint256);
896     function reserveFrozenUntil() external view returns (uint256);
897     function reserveAmount() external view returns (uint256);
898     function vestingDaysSinceStart() external view returns (uint256);
899     function vestingDaysLeft() external view returns (uint256);
900     function convertAmountUsingRatio(uint256 amount) external view returns (uint256);
901     function convertAmountUsingReverseRatio(uint256 amount) external view returns (uint256);
902     function totalVestedBalanceOf(address account) external view returns (uint256);
903     function unspentVestedBalanceOf(address account) external view returns (uint256);
904     function spentVestedBalanceOf(address account) external view returns (uint256);
905 
906     function mint(address account, uint256 amount) external returns (bool);
907     function mintWithoutVesting(address account, uint256 amount) external returns (bool);
908     function burn(uint256 amount) external returns (bool);
909     function burnFrom(address account, uint256 amount) external returns (bool);
910     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
911     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
912     function startTransfers() external returns (bool);
913     function stopTransfers() external returns (bool);
914     function allowMigrations() external returns (bool);
915     function changeVestingStart(uint256 newVestingStart) external returns (bool);
916     function withdrawReserve(address to) external returns (bool);
917     function migrateVestingBalance(bytes32 to) external returns (bool);
918 }
919 
920 // 
921 /**
922  * Implementation of the {IExchange} interface.
923  *
924  * Ethereum XFI Exchange allows Ethereum accounts to convert their WINGS or ETH
925  * to XFI and vice versa.
926  *
927  * Swap between WINGS and XFI happens with a 1:1 ratio.
928  *
929  * To enable swap the Exchange plays a role of a storage for WINGS tokens as
930  * well as a minter of XFI Tokens.
931  */
932 contract Exchange is AccessControl, ReentrancyGuard, IExchange {
933     using SafeMath for uint256;
934 
935     IERC20 private immutable _wingsToken;
936     IXFIToken private immutable _xfiToken;
937 
938     bool private _stopped = false;
939     uint256 private _maxGasPrice;
940 
941     /**
942      * Sets {DEFAULT_ADMIN_ROLE} (alias `owner`) role for caller.
943      * Initializes Wings Token, XFI Token.
944      */
945     constructor (address wingsToken_, address xfiToken_) public {
946         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
947 
948         _wingsToken = IERC20(wingsToken_);
949         _xfiToken = IXFIToken(xfiToken_);
950     }
951 
952     /**
953      * Executes swap of WINGS-XFI pair.
954      *
955      * Emits a {SwapWINGSForXFI} event.
956      *
957      * Returns:
958      * - `amounts` the input token amount and all subsequent output token amounts.
959      *
960      * Requirements:
961      * - Contract is approved to spend `amountIn` of WINGS tokens.
962      */
963     function swapWINGSForXFI(uint256 amountIn) external override nonReentrant returns (uint256[] memory amounts) {
964         _beforeSwap();
965 
966         uint256 amountOut = _calculateSwapAmount(amountIn);
967 
968         amounts = new uint256[](2);
969         amounts[0] = amountIn;
970 
971         amounts[1] = amountOut;
972 
973         require(_wingsToken.transferFrom(msg.sender, address(this), amounts[0]), 'Exchange: WINGS transferFrom failed');
974         require(_xfiToken.mint(msg.sender, amounts[amounts.length - 1]), 'Exchange: XFI mint failed');
975 
976         emit SwapWINGSForXFI(msg.sender, amounts[0], amounts[amounts.length - 1]);
977     }
978 
979     /**
980      * Starts all swaps.
981      *
982      * Emits a {SwapsStarted} event.
983      *
984      * Requirements:
985      * - Caller must have owner role.
986      * - Contract is stopped.
987      */
988     function startSwaps() external override returns (bool) {
989         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), 'Exchange: sender is not owner');
990         require(_stopped, 'Exchange: swapping is not stopped');
991 
992         _stopped = false;
993 
994         emit SwapsStarted();
995 
996         return true;
997     }
998 
999     /**
1000      * Stops all swaps.
1001      *
1002      * Emits a {SwapsStopped} event.
1003      *
1004      * Requirements:
1005      * - Caller must have owner role.
1006      * - Contract is not stopped.
1007      */
1008     function stopSwaps() external override returns (bool) {
1009         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), 'Exchange: sender is not owner');
1010         require(!_stopped, 'Exchange: swapping is stopped');
1011 
1012         _stopped = true;
1013 
1014         emit SwapsStopped();
1015 
1016         return true;
1017     }
1018 
1019      /**
1020       * Withdraws `amount` of locked WINGS to a destination specified as `to`.
1021       *
1022       * Emits a {WINGSWithdrawal} event.
1023       *
1024       * Requirements:
1025       * - `to` cannot be the zero address.
1026       * - Caller must have owner role.
1027       * - Swapping has ended.
1028       */
1029     function withdrawWINGS(address to, uint256 amount) external override nonReentrant returns (bool) {
1030         require(to != address(0), 'Exchange: withdraw to the zero address');
1031         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), 'Exchange: sender is not owner');
1032         require(block.timestamp > _xfiToken.vestingEnd(), 'Exchange: swapping has not ended');
1033 
1034         require(_wingsToken.transfer(to, amount), 'Exchange: WINGS transfer failed');
1035 
1036         emit WINGSWithdrawal(to, amount);
1037 
1038         return true;
1039     }
1040 
1041     /**
1042      * Sets maximum gas price for swap to `maxGasPrice_`.
1043      *
1044      * Emits a {MaxGasPriceUpdated} event.
1045      *
1046      * Requirements:
1047      * - Caller must have owner role.
1048      */
1049     function setMaxGasPrice(uint256 maxGasPrice_) external override returns (bool) {
1050         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), 'Exchange: sender is not owner');
1051 
1052         _maxGasPrice = maxGasPrice_;
1053 
1054         emit MaxGasPriceChanged(maxGasPrice_);
1055 
1056         return true;
1057     }
1058 
1059     /**
1060      * Returns the address of the Wings Token.
1061      */
1062     function wingsToken() external view override returns (address) {
1063         return address(_wingsToken);
1064     }
1065 
1066     /**
1067      * Returns the address of the XFI Token.
1068      */
1069     function xfiToken() external view override returns (address) {
1070         return address(_xfiToken);
1071     }
1072 
1073     /**
1074      * Returns `amount` XFI estimation that user will receive per day after the swap of WINGS-XFI pair.
1075      */
1076     function estimateSwapWINGSForXFIPerDay(uint256 amountIn) external view override returns (uint256 amount) {
1077         uint256[] memory amounts = estimateSwapWINGSForXFI(amountIn);
1078 
1079         amount = amounts[1].div(_xfiToken.VESTING_DURATION_DAYS());
1080     }
1081 
1082 
1083     /**
1084      * Returns whether swapping is stopped.
1085      */
1086     function isSwappingStopped() external view override returns (bool) {
1087         return _stopped;
1088     }
1089 
1090     /**
1091      * Returns maximum gas price for swap. If set, any swap transaction that has
1092      * a gas price exceeding this limit will be reverted.
1093      */
1094     function maxGasPrice() external view override returns (uint256) {
1095         return _maxGasPrice;
1096     }
1097 
1098     /**
1099      * Returns `amounts` estimation for swap of WINGS-XFI pair.
1100      */
1101     function estimateSwapWINGSForXFI(uint256 amountIn) public view override returns (uint256[] memory amounts) {
1102         amounts = new uint256[](2);
1103         amounts[0] = amountIn;
1104 
1105         uint256 amountOut = _calculateSwapAmount(amounts[0]);
1106 
1107         amounts[1] = amountOut;
1108     }
1109 
1110     /**
1111      * Executes before swap hook.
1112      *
1113      * Requirements:
1114      * - Contract is not stopped.
1115      * - Swapping has started.
1116      * - Swapping hasn't ended.
1117      * - Gas price doesn't exceed the limit (if set).
1118      */
1119     function _beforeSwap() internal view {
1120         require(!_stopped, 'Exchange: swapping is stopped');
1121         require(block.timestamp >= _xfiToken.vestingStart(), 'Exchange: swapping has not started');
1122         require(block.timestamp <= _xfiToken.vestingEnd(), 'Exchange: swapping has ended');
1123 
1124         if (_maxGasPrice > 0) {
1125             require(tx.gasprice <= _maxGasPrice, 'Exchange: gas price exceeds the limit');
1126         }
1127     }
1128 
1129     /**
1130      * Convert input amount to the output XFI amount using timed swap ratio.
1131      */
1132     function _calculateSwapAmount(uint256 amount) internal view returns (uint256) {
1133         require(amount >= 182, 'Exchange: minimum XFI swap output amount is 182 * 10 ** -18');
1134 
1135         if (block.timestamp < _xfiToken.vestingEnd()) {
1136             uint256 amountOut = _xfiToken.convertAmountUsingReverseRatio(amount);
1137 
1138             return amountOut;
1139         } else {
1140             return 0;
1141         }
1142     }
1143 }