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
837 interface IERC20 {
838     event Approval(address indexed owner, address indexed spender, uint256 value);
839     event Transfer(address indexed from, address indexed to, uint256 value);
840 
841     function name() external view returns (string memory);
842     function symbol() external view returns (string memory);
843     function decimals() external view returns (uint8);
844     function totalSupply() external view returns (uint256);
845     function balanceOf(address account) external view returns (uint256);
846     function allowance(address owner, address spender) external view returns (uint256);
847 
848     function approve(address spender, uint256 amount) external returns (bool);
849     function transfer(address recipient, uint256 amount) external returns (bool);
850     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
851 }
852 
853 // 
854 /**
855  * XFI token extends the interface of ERC20 standard.
856  */
857 interface IXFIToken is IERC20 {
858     event VestingStartChanged(uint256 newVestingStart, uint256 newVestingEnd, uint256 newReserveFrozenUntil);
859     event TransfersStarted();
860     event TransfersStopped();
861     event MigrationsAllowed();
862     event ReserveWithdrawal(address indexed to, uint256 amount);
863     event VestingBalanceMigrated(address indexed from, bytes32 to, uint256 vestingDaysLeft, uint256 vestingBalance);
864 
865     function isTransferringStopped() external view returns (bool);
866     function isMigratingAllowed() external view returns (bool);
867     function VESTING_DURATION() external view returns (uint256);
868     function VESTING_DURATION_DAYS() external view returns (uint256);
869     function RESERVE_FREEZE_DURATION() external view returns (uint256);
870     function RESERVE_FREEZE_DURATION_DAYS() external view returns (uint256);
871     function MAX_VESTING_TOTAL_SUPPLY() external view returns (uint256);
872     function vestingStart() external view returns (uint256);
873     function vestingEnd() external view returns (uint256);
874     function reserveFrozenUntil() external view returns (uint256);
875     function reserveAmount() external view returns (uint256);
876     function vestingDaysSinceStart() external view returns (uint256);
877     function vestingDaysLeft() external view returns (uint256);
878     function convertAmountUsingRatio(uint256 amount) external view returns (uint256);
879     function convertAmountUsingReverseRatio(uint256 amount) external view returns (uint256);
880     function totalVestedBalanceOf(address account) external view returns (uint256);
881     function unspentVestedBalanceOf(address account) external view returns (uint256);
882     function spentVestedBalanceOf(address account) external view returns (uint256);
883 
884     function mint(address account, uint256 amount) external returns (bool);
885     function mintWithoutVesting(address account, uint256 amount) external returns (bool);
886     function burn(uint256 amount) external returns (bool);
887     function burnFrom(address account, uint256 amount) external returns (bool);
888     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
889     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
890     function startTransfers() external returns (bool);
891     function stopTransfers() external returns (bool);
892     function allowMigrations() external returns (bool);
893     function changeVestingStart(uint256 newVestingStart) external returns (bool);
894     function withdrawReserve(address to) external returns (bool);
895     function migrateVestingBalance(bytes32 to) external returns (bool);
896 }
897 
898 // 
899 /**
900  * Implementation of the {IXFIToken} interface.
901  *
902  * We have followed general OpenZeppelin guidelines: functions revert instead
903  * of returning `false` on failure. This behavior is nonetheless conventional
904  * and does not conflict with the expectations of ERC20 applications.
905  *
906  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
907  * This allows applications to reconstruct the allowance for all accounts just
908  * by listening to said events. Other implementations of the EIP may not emit
909  * these events, as it isn't required by the specification.
910  *
911  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
912  * functions have been added to mitigate the well-known issues around setting
913  * allowances.
914  */
915 contract XFIToken is AccessControl, ReentrancyGuard, IXFIToken {
916     using SafeMath for uint256;
917     using Address for address;
918 
919     string private constant _name = 'dfinance';
920 
921     string private constant _symbol = 'XFI';
922 
923     uint8 private constant _decimals = 18;
924 
925     bytes32 public constant MINTER_ROLE = keccak256('minter');
926 
927     uint256 public constant override MAX_VESTING_TOTAL_SUPPLY = 1e26; // 100 million XFI.
928 
929     uint256 public constant override VESTING_DURATION_DAYS = 182;
930     uint256 public constant override VESTING_DURATION = 182 days;
931 
932     /**
933      * @dev Reserve is the final amount of tokens that weren't distributed
934      * during the vesting.
935      */
936     uint256 public constant override RESERVE_FREEZE_DURATION_DAYS = 730; // Around 2 years.
937     uint256 public constant override RESERVE_FREEZE_DURATION = 730 days;
938 
939     mapping (address => uint256) private _vestingBalances;
940 
941     mapping (address => uint256) private _balances;
942 
943     mapping (address => uint256) private _spentVestedBalances;
944 
945     mapping (address => mapping (address => uint256)) private _allowances;
946 
947     uint256 private _vestingTotalSupply;
948 
949     uint256 private _totalSupply;
950 
951     uint256 private _spentVestedTotalSupply;
952 
953     uint256 private _vestingStart;
954 
955     uint256 private _vestingEnd;
956 
957     uint256 private _reserveFrozenUntil;
958 
959     bool private _stopped = false;
960 
961     bool private _migratingAllowed = false;
962 
963     uint256 private _reserveAmount;
964 
965     /**
966      * Sets {DEFAULT_ADMIN_ROLE} (alias `owner`) role for caller.
967      * Assigns vesting and freeze period dates.
968      */
969     constructor (uint256 vestingStart_) public {
970         require(vestingStart_ > block.timestamp, 'XFIToken: vesting start must be greater than current timestamp');
971         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
972 
973         _vestingStart = vestingStart_;
974         _vestingEnd = vestingStart_.add(VESTING_DURATION);
975         _reserveFrozenUntil = vestingStart_.add(RESERVE_FREEZE_DURATION);
976         _reserveAmount = MAX_VESTING_TOTAL_SUPPLY;
977     }
978 
979     /**
980      * Transfers `amount` tokens to `recipient`.
981      *
982      * Emits a {Transfer} event.
983      *
984      * Requirements:
985      * - `recipient` cannot be the zero address.
986      * - the caller must have a balance of at least `amount`.
987      */
988     function transfer(address recipient, uint256 amount) external override returns (bool) {
989         _transfer(msg.sender, recipient, amount);
990 
991         return true;
992     }
993 
994     /**
995      * Approves `spender` to spend `amount` of caller's tokens.
996      *
997      * IMPORTANT: Beware that changing an allowance with this method brings the risk
998      * that someone may use both the old and the new allowance by unfortunate
999      * transaction ordering. One possible solution to mitigate this race
1000      * condition is to first reduce the spender's allowance to 0 and set the
1001      * desired value afterwards:
1002      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1003      *
1004      * Emits an {Approval} event.
1005      *
1006      * Requirements:
1007      * - `spender` cannot be the zero address.
1008      */
1009     function approve(address spender, uint256 amount) external override returns (bool) {
1010         _approve(msg.sender, spender, amount);
1011 
1012         return true;
1013     }
1014 
1015     /**
1016      * Transfers `amount` tokens from `sender` to `recipient`.
1017      *
1018      * Emits a {Transfer} event.
1019      * Emits an {Approval} event indicating the updated allowance.
1020      *
1021      * Requirements:
1022      * - `sender` and `recipient` cannot be the zero address.
1023      * - `sender` must have a balance of at least `amount`.
1024      * - the caller must have allowance for `sender`'s tokens of at least
1025      * `amount`.
1026      */
1027     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1028         _transfer(sender, recipient, amount);
1029         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, 'XFIToken: transfer amount exceeds allowance'));
1030 
1031         return true;
1032     }
1033 
1034     /**
1035      * Atomically increases the allowance granted to `spender` by the caller.
1036      *
1037      * This is an alternative to {approve} that can be used as a mitigation for
1038      * problems described in {approve}.
1039      *
1040      * Emits an {Approval} event indicating the updated allowance.
1041      *
1042      * Requirements:
1043      * - `spender` cannot be the zero address.
1044      */
1045     function increaseAllowance(address spender, uint256 addedValue) external override returns (bool) {
1046         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
1047 
1048         return true;
1049     }
1050 
1051     /**
1052      * Atomically decreases the allowance granted to `spender` by the caller.
1053      *
1054      * This is an alternative to {approve} that can be used as a mitigation for
1055      * problems described in {approve}.
1056      *
1057      * Emits an {Approval} event indicating the updated allowance.
1058      *
1059      * Requirements:
1060      * - `spender` cannot be the zero address.
1061      * - `spender` must have allowance for the caller of at least
1062      * `subtractedValue`.
1063      */
1064     function decreaseAllowance(address spender, uint256 subtractedValue) external override returns (bool) {
1065         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, 'XFIToken: decreased allowance below zero'));
1066 
1067         return true;
1068     }
1069 
1070     /**
1071      * Creates `amount` tokens and assigns them to `account`, increasing
1072      * the total supply.
1073      *
1074      * Emits a {Transfer} event with `from` set to the zero address.
1075      *
1076      * Requirements:
1077      * - Caller must have minter role.
1078      * - `account` cannot be the zero address.
1079      */
1080     function mint(address account, uint256 amount) external override returns (bool) {
1081         require(hasRole(MINTER_ROLE, msg.sender), 'XFIToken: sender is not minter');
1082 
1083         _mint(account, amount);
1084 
1085         return true;
1086     }
1087 
1088     /**
1089      * Creates `amount` tokens and assigns them to `account`, increasing
1090      * the total supply without vesting.
1091      *
1092      * Emits a {Transfer} event with `from` set to the zero address.
1093      *
1094      * Requirements:
1095      * - Caller must have minter role.
1096      * - `account` cannot be the zero address.
1097      */
1098     function mintWithoutVesting(address account, uint256 amount) external override returns (bool) {
1099         require(hasRole(MINTER_ROLE, msg.sender), 'XFIToken: sender is not minter');
1100 
1101         _mintWithoutVesting(account, amount);
1102 
1103         return true;
1104     }
1105 
1106     /**
1107      * Destroys `amount` tokens from `account`, reducing the
1108      * total supply.
1109      *
1110      * Emits a {Transfer} event with `to` set to the zero address.
1111      *
1112      * Requirements:
1113      * - Caller must have minter role.
1114      */
1115     function burnFrom(address account, uint256 amount) external override returns (bool) {
1116         require(hasRole(MINTER_ROLE, msg.sender), 'XFIToken: sender is not minter');
1117 
1118         _burn(account, amount);
1119 
1120         return true;
1121     }
1122 
1123     /**
1124      * Destroys `amount` tokens from sender, reducing the
1125      * total supply.
1126      *
1127      * Emits a {Transfer} event with `to` set to the zero address.
1128      */
1129     function burn(uint256 amount) external override returns (bool) {
1130         _burn(msg.sender, amount);
1131 
1132         return true;
1133     }
1134 
1135     /**
1136      * Change vesting start and end timestamps.
1137      *
1138      * Emits a {VestingStartChanged} event.
1139      *
1140      * Requirements:
1141      * - Caller must have owner role.
1142      * - Vesting must be pending.
1143      * - `vestingStart_` must be greater than the current timestamp.
1144      */
1145     function changeVestingStart(uint256 vestingStart_) external override returns (bool) {
1146         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), 'XFIToken: sender is not owner');
1147         require(_vestingStart > block.timestamp, 'XFIToken: vesting has started');
1148         require(vestingStart_ > block.timestamp, 'XFIToken: vesting start must be greater than current timestamp');
1149 
1150         _vestingStart = vestingStart_;
1151         _vestingEnd = vestingStart_.add(VESTING_DURATION);
1152         _reserveFrozenUntil = vestingStart_.add(RESERVE_FREEZE_DURATION);
1153 
1154         emit VestingStartChanged(vestingStart_, _vestingEnd, _reserveFrozenUntil);
1155 
1156         return true;
1157     }
1158 
1159     /**
1160      * Starts all transfers.
1161      *
1162      * Emits a {TransfersStarted} event.
1163      *
1164      * Requirements:
1165      * - Caller must have owner role.
1166      * - Transferring is stopped.
1167      */
1168     function startTransfers() external override returns (bool) {
1169         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), 'XFIToken: sender is not owner');
1170         require(_stopped, 'XFIToken: transferring is not stopped');
1171 
1172         _stopped = false;
1173 
1174         emit TransfersStarted();
1175 
1176         return true;
1177     }
1178 
1179     /**
1180      * Stops all transfers.
1181      *
1182      * Emits a {TransfersStopped} event.
1183      *
1184      * Requirements:
1185      * - Caller must have owner role.
1186      * - Transferring isn't stopped.
1187      */
1188     function stopTransfers() external override returns (bool) {
1189         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), 'XFIToken: sender is not owner');
1190         require(!_stopped, 'XFIToken: transferring is stopped');
1191 
1192         _stopped = true;
1193 
1194         emit TransfersStopped();
1195 
1196         return true;
1197     }
1198 
1199     /**
1200      * Start migrations.
1201      *
1202      * Emits a {MigrationsStarted} event.
1203      *
1204      * Requirements:
1205      * - Caller must have owner role.
1206      * - Migrating isn't allowed.
1207      */
1208     function allowMigrations() external override returns (bool) {
1209         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), 'XFIToken: sender is not owner');
1210         require(!_migratingAllowed, 'XFIToken: migrating is allowed');
1211 
1212         _migratingAllowed = true;
1213 
1214         emit MigrationsAllowed();
1215 
1216         return true;
1217     }
1218 
1219     /**
1220      * Withdraws reserve amount to a destination specified as `to`.
1221      *
1222      * Emits a {ReserveWithdrawal} event.
1223      *
1224      * Requirements:
1225      * - `to` cannot be the zero address.
1226      * - Caller must have owner role.
1227      * - Reserve has unfrozen.
1228      */
1229     function withdrawReserve(address to) external override nonReentrant returns (bool) {
1230         require(to != address(0), 'XFIToken: withdraw to the zero address');
1231         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), 'XFIToken: sender is not owner');
1232         require(block.timestamp > _reserveFrozenUntil, 'XFIToken: reserve is frozen');
1233 
1234         uint256 amount = reserveAmount();
1235 
1236         _mintWithoutVesting(to, amount);
1237 
1238         _reserveAmount = 0;
1239 
1240         emit ReserveWithdrawal(to, amount);
1241 
1242         return true;
1243     }
1244 
1245     /**
1246      * Migrate vesting balance to the Dfinance blockchain.
1247      *
1248      * Emits a {VestingBalanceMigrated} event.
1249      *
1250      * Requirements:
1251      * - `to` is not the zero bytes.
1252      * - Vesting balance is greater than zero.
1253      * - Vesting hasn't ended.
1254      */
1255     function migrateVestingBalance(bytes32 to) external override nonReentrant returns (bool) {
1256         require(to != bytes32(0), 'XFIToken: migrate to the zero bytes');
1257         require(_migratingAllowed, 'XFIToken: migrating is disallowed');
1258         require(block.timestamp < _vestingEnd, 'XFIToken: vesting has ended');
1259 
1260         uint256 vestingBalance = _vestingBalances[msg.sender];
1261 
1262         require(vestingBalance > 0, 'XFIToken: vesting balance is zero');
1263 
1264         uint256 spentVestedBalance = spentVestedBalanceOf(msg.sender);
1265         uint256 unspentVestedBalance = unspentVestedBalanceOf(msg.sender);
1266 
1267         // Subtract the vesting balance from total supply.
1268         _vestingTotalSupply = _vestingTotalSupply.sub(vestingBalance);
1269 
1270         // Add the unspent vesting balance to total supply.
1271         _totalSupply = _totalSupply.add(unspentVestedBalance);
1272 
1273         // Subtract the spent vested balance from total supply.
1274         _spentVestedTotalSupply = _spentVestedTotalSupply.sub(spentVestedBalance);
1275 
1276         // Make unspent vested balance persistent.
1277         _balances[msg.sender] = _balances[msg.sender].add(unspentVestedBalance);
1278 
1279         // Reset the account's vesting.
1280         _vestingBalances[msg.sender] = 0;
1281         _spentVestedBalances[msg.sender] = 0;
1282 
1283         emit VestingBalanceMigrated(msg.sender, to, vestingDaysLeft(), vestingBalance);
1284 
1285         return true;
1286     }
1287 
1288     /**
1289      * Returns name of the token.
1290      */
1291     function name() external view override returns (string memory) {
1292         return _name;
1293     }
1294 
1295     /**
1296      * Returns symbol of the token.
1297      */
1298     function symbol() external view override returns (string memory) {
1299         return _symbol;
1300     }
1301 
1302     /**
1303      * Returns number of decimals of the token.
1304      */
1305     function decimals() external view override returns (uint8) {
1306         return _decimals;
1307     }
1308 
1309     /**
1310      * Returnes amount of `owner`'s tokens that `spender` is allowed to transfer.
1311      */
1312     function allowance(address owner, address spender) external view override returns (uint256) {
1313         return _allowances[owner][spender];
1314     }
1315 
1316     /**
1317      * Returns the vesting start.
1318      */
1319     function vestingStart() external view override returns (uint256) {
1320         return _vestingStart;
1321     }
1322 
1323     /**
1324      * Returns the vesting end.
1325      */
1326     function vestingEnd() external view override returns (uint256) {
1327         return _vestingEnd;
1328     }
1329 
1330     /**
1331      * Returns the date when freeze of the reserve XFI amount.
1332      */
1333     function reserveFrozenUntil() external view override returns (uint256) {
1334         return _reserveFrozenUntil;
1335     }
1336 
1337     /**
1338      * Returns whether transfering is stopped.
1339      */
1340     function isTransferringStopped() external view override returns (bool) {
1341         return _stopped;
1342     }
1343 
1344     /**
1345      * Returns whether migrating is allowed.
1346      */
1347     function isMigratingAllowed() external view override returns (bool) {
1348         return _migratingAllowed;
1349     }
1350 
1351     /**
1352      * Convert input amount to the output amount using the vesting ratio
1353      * (days since vesting start / vesting duration).
1354      */
1355     function convertAmountUsingRatio(uint256 amount) public view override returns (uint256) {
1356         uint256 convertedAmount = amount
1357             .mul(vestingDaysSinceStart())
1358             .div(VESTING_DURATION_DAYS);
1359 
1360         return (convertedAmount < amount)
1361             ? convertedAmount
1362             : amount;
1363     }
1364 
1365     /**
1366      * Convert input amount to the output amount using the vesting reverse
1367      * ratio (days until vesting end / vesting duration).
1368      */
1369     function convertAmountUsingReverseRatio(uint256 amount) public view override returns (uint256) {
1370         if (vestingDaysSinceStart() > 0) {
1371             return amount
1372                 .mul(vestingDaysLeft().add(1))
1373                 .div(VESTING_DURATION_DAYS);
1374         } else {
1375             return amount;
1376         }
1377     }
1378 
1379     /**
1380      * Returns days since the vesting start.
1381      */
1382     function vestingDaysSinceStart() public view override returns (uint256) {
1383         if (block.timestamp > _vestingStart) {
1384             return block.timestamp
1385                 .sub(_vestingStart)
1386                 .div(1 days)
1387                 .add(1);
1388         } else {
1389             return 0;
1390         }
1391     }
1392 
1393     /**
1394      * Returns vesting days left.
1395      */
1396     function vestingDaysLeft() public view override returns (uint256) {
1397         if (block.timestamp < _vestingEnd) {
1398             return VESTING_DURATION_DAYS
1399                 .sub(vestingDaysSinceStart());
1400         } else {
1401             return 0;
1402         }
1403     }
1404 
1405     /**
1406      * Returns total supply of the token.
1407      */
1408     function totalSupply() public view override returns (uint256) {
1409         return convertAmountUsingRatio(_vestingTotalSupply)
1410             .add(_totalSupply)
1411             .sub(_spentVestedTotalSupply);
1412     }
1413 
1414     /**
1415      * Returns total vested balance of the `account`.
1416      */
1417     function totalVestedBalanceOf(address account) public view override returns (uint256) {
1418         return convertAmountUsingRatio(_vestingBalances[account]);
1419     }
1420 
1421     /**
1422      * Returns unspent vested balance of the `account`.
1423      */
1424     function unspentVestedBalanceOf(address account) public view override returns (uint256) {
1425         return totalVestedBalanceOf(account)
1426             .sub(_spentVestedBalances[account]);
1427     }
1428 
1429     /**
1430      * Returns spent vested balance of the `account`.
1431      */
1432     function spentVestedBalanceOf(address account) public view override returns (uint256) {
1433         return _spentVestedBalances[account];
1434     }
1435 
1436     /**
1437      * Returns token balance of the `account`.
1438      */
1439     function balanceOf(address account) public view override returns (uint256) {
1440         return unspentVestedBalanceOf(account)
1441             .add(_balances[account]);
1442     }
1443 
1444     /**
1445      * Returns reserve amount.
1446      */
1447     function reserveAmount() public view override returns (uint256) {
1448         return _reserveAmount;
1449     }
1450 
1451     /**
1452      * Moves tokens `amount` from `sender` to `recipient`.
1453      *
1454      * Emits a {Transfer} event.
1455      *
1456      * Requirements:
1457      * - `sender` cannot be the zero address.
1458      * - `recipient` cannot be the zero address.
1459      * - `sender` must have a balance of at least `amount`.
1460      * - Transferring is not stopped.
1461      */
1462     function _transfer(address sender, address recipient, uint256 amount) internal {
1463         require(sender != address(0), 'XFIToken: transfer from the zero address');
1464         require(recipient != address(0), 'XFIToken: transfer to the zero address');
1465         require(!_stopped, 'XFIToken: transferring is stopped');
1466 
1467         _decreaseAccountBalance(sender, amount);
1468 
1469         _balances[recipient] = _balances[recipient].add(amount);
1470 
1471         emit Transfer(sender, recipient, amount);
1472     }
1473 
1474     /**
1475      * Creates `amount` tokens and assigns them to `account`, increasing
1476      * the total supply.
1477      *
1478      * Emits a {Transfer} event with `from` set to the zero address.
1479      *
1480      * Requirements:
1481      * - `account` cannot be the zero address.
1482      * - Transferring is not stopped.
1483      * - `amount` doesn't exceed reserve amount.
1484      */
1485     function _mint(address account, uint256 amount) internal {
1486         require(account != address(0), 'XFIToken: mint to the zero address');
1487         require(!_stopped, 'XFIToken: transferring is stopped');
1488         require(_reserveAmount >= amount, 'XFIToken: mint amount exceeds reserve amount');
1489 
1490         _vestingTotalSupply = _vestingTotalSupply.add(amount);
1491 
1492         _vestingBalances[account] = _vestingBalances[account].add(amount);
1493 
1494         _reserveAmount = _reserveAmount.sub(amount);
1495 
1496         emit Transfer(address(0), account, amount);
1497     }
1498 
1499     /**
1500      * Creates `amount` tokens and assigns them to `account`, increasing
1501      * the total supply without vesting.
1502      *
1503      * Emits a {Transfer} event with `from` set to the zero address.
1504      *
1505      * Requirements:
1506      * - `account` cannot be the zero address.
1507      * - Transferring is not stopped.
1508      */
1509     function _mintWithoutVesting(address account, uint256 amount) internal {
1510         require(account != address(0), 'XFIToken: mint to the zero address');
1511         require(!_stopped, 'XFIToken: transferring is stopped');
1512 
1513         _totalSupply = _totalSupply.add(amount);
1514 
1515         _balances[account] = _balances[account].add(amount);
1516 
1517         emit Transfer(address(0), account, amount);
1518     }
1519 
1520     /**
1521      * Destroys `amount` tokens from `account`, reducing the
1522      * total supply.
1523      *
1524      * Emits a {Transfer} event with `to` set to the zero address.
1525      *
1526      * Requirements:
1527      * - `account` cannot be the zero address.
1528      * - Transferring is not stopped.
1529      * - `account` must have at least `amount` tokens.
1530      */
1531     function _burn(address account, uint256 amount) internal {
1532         require(account != address(0), 'XFIToken: burn from the zero address');
1533         require(!_stopped, 'XFIToken: transferring is stopped');
1534         require(balanceOf(account) >= amount, 'XFIToken: burn amount exceeds balance');
1535 
1536         _decreaseAccountBalance(account, amount);
1537 
1538         _totalSupply = _totalSupply.sub(amount);
1539 
1540         emit Transfer(account, address(0), amount);
1541     }
1542 
1543     /**
1544      * Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1545      *
1546      * Emits an {Approval} event.
1547      *
1548      * Requirements:
1549      * - `owner` cannot be the zero address.
1550      * - `spender` cannot be the zero address.
1551      */
1552     function _approve(address owner, address spender, uint256 amount) internal {
1553         require(owner != address(0), 'XFIToken: approve from the zero address');
1554         require(spender != address(0), 'XFIToken: approve to the zero address');
1555 
1556         _allowances[owner][spender] = amount;
1557 
1558         emit Approval(owner, spender, amount);
1559     }
1560 
1561     /**
1562      * Decrease balance of the `account`.
1563      *
1564      * The use of vested balance is in priority. Otherwise, the normal balance
1565      * will be used.
1566      */
1567     function _decreaseAccountBalance(address account, uint256 amount) internal {
1568         uint256 accountBalance = balanceOf(account);
1569 
1570         require(accountBalance >= amount, 'XFIToken: transfer amount exceeds balance');
1571 
1572         uint256 accountVestedBalance = unspentVestedBalanceOf(account);
1573         uint256 usedVestedBalance = 0;
1574         uint256 usedBalance = 0;
1575 
1576         if (accountVestedBalance >= amount) {
1577             usedVestedBalance = amount;
1578         } else {
1579             usedVestedBalance = accountVestedBalance;
1580             usedBalance = amount.sub(usedVestedBalance);
1581         }
1582 
1583         _balances[account] = _balances[account].sub(usedBalance);
1584         _spentVestedBalances[account] = _spentVestedBalances[account].add(usedVestedBalance);
1585 
1586         _totalSupply = _totalSupply.add(usedVestedBalance);
1587         _spentVestedTotalSupply = _spentVestedTotalSupply.add(usedVestedBalance);
1588     }
1589 }