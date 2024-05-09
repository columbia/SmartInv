1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.6.12;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /**
161  * @dev Library for managing
162  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
163  * types.
164  *
165  * Sets have the following properties:
166  *
167  * - Elements are added, removed, and checked for existence in constant time
168  * (O(1)).
169  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
170  *
171  * ```
172  * contract Example {
173  *     // Add the library methods
174  *     using EnumerableSet for EnumerableSet.AddressSet;
175  *
176  *     // Declare a set state variable
177  *     EnumerableSet.AddressSet private mySet;
178  * }
179  * ```
180  *
181  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
182  * (`UintSet`) are supported.
183  */
184 library EnumerableSet {
185     // To implement this library for multiple types with as little code
186     // repetition as possible, we write it in terms of a generic Set type with
187     // bytes32 values.
188     // The Set implementation uses private functions, and user-facing
189     // implementations (such as AddressSet) are just wrappers around the
190     // underlying Set.
191     // This means that we can only create new EnumerableSets for types that fit
192     // in bytes32.
193 
194     struct Set {
195         // Storage of set values
196         bytes32[] _values;
197 
198         // Position of the value in the `values` array, plus 1 because index 0
199         // means a value is not in the set.
200         mapping (bytes32 => uint256) _indexes;
201     }
202 
203     /**
204      * @dev Add a value to a set. O(1).
205      *
206      * Returns true if the value was added to the set, that is if it was not
207      * already present.
208      */
209     function _add(Set storage set, bytes32 value) private returns (bool) {
210         if (!_contains(set, value)) {
211             set._values.push(value);
212             // The value is stored at length-1, but we add 1 to all indexes
213             // and use 0 as a sentinel value
214             set._indexes[value] = set._values.length;
215             return true;
216         } else {
217             return false;
218         }
219     }
220 
221     /**
222      * @dev Removes a value from a set. O(1).
223      *
224      * Returns true if the value was removed from the set, that is if it was
225      * present.
226      */
227     function _remove(Set storage set, bytes32 value) private returns (bool) {
228         // We read and store the value's index to prevent multiple reads from the same storage slot
229         uint256 valueIndex = set._indexes[value];
230 
231         if (valueIndex != 0) { // Equivalent to contains(set, value)
232             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
233             // the array, and then remove the last element (sometimes called as 'swap and pop').
234             // This modifies the order of the array, as noted in {at}.
235 
236             uint256 toDeleteIndex = valueIndex - 1;
237             uint256 lastIndex = set._values.length - 1;
238 
239             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
240             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
241 
242             bytes32 lastvalue = set._values[lastIndex];
243 
244             // Move the last value to the index where the value to delete is
245             set._values[toDeleteIndex] = lastvalue;
246             // Update the index for the moved value
247             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
248 
249             // Delete the slot where the moved value was stored
250             set._values.pop();
251 
252             // Delete the index for the deleted slot
253             delete set._indexes[value];
254 
255             return true;
256         } else {
257             return false;
258         }
259     }
260 
261     /**
262      * @dev Returns true if the value is in the set. O(1).
263      */
264     function _contains(Set storage set, bytes32 value) private view returns (bool) {
265         return set._indexes[value] != 0;
266     }
267 
268     /**
269      * @dev Returns the number of values on the set. O(1).
270      */
271     function _length(Set storage set) private view returns (uint256) {
272         return set._values.length;
273     }
274 
275    /**
276     * @dev Returns the value stored at position `index` in the set. O(1).
277     *
278     * Note that there are no guarantees on the ordering of values inside the
279     * array, and it may change when more values are added or removed.
280     *
281     * Requirements:
282     *
283     * - `index` must be strictly less than {length}.
284     */
285     function _at(Set storage set, uint256 index) private view returns (bytes32) {
286         require(set._values.length > index, "EnumerableSet: index out of bounds");
287         return set._values[index];
288     }
289 
290     // AddressSet
291 
292     struct AddressSet {
293         Set _inner;
294     }
295 
296     /**
297      * @dev Add a value to a set. O(1).
298      *
299      * Returns true if the value was added to the set, that is if it was not
300      * already present.
301      */
302     function add(AddressSet storage set, address value) internal returns (bool) {
303         return _add(set._inner, bytes32(uint256(value)));
304     }
305 
306     /**
307      * @dev Removes a value from a set. O(1).
308      *
309      * Returns true if the value was removed from the set, that is if it was
310      * present.
311      */
312     function remove(AddressSet storage set, address value) internal returns (bool) {
313         return _remove(set._inner, bytes32(uint256(value)));
314     }
315 
316     /**
317      * @dev Returns true if the value is in the set. O(1).
318      */
319     function contains(AddressSet storage set, address value) internal view returns (bool) {
320         return _contains(set._inner, bytes32(uint256(value)));
321     }
322 
323     /**
324      * @dev Returns the number of values in the set. O(1).
325      */
326     function length(AddressSet storage set) internal view returns (uint256) {
327         return _length(set._inner);
328     }
329 
330    /**
331     * @dev Returns the value stored at position `index` in the set. O(1).
332     *
333     * Note that there are no guarantees on the ordering of values inside the
334     * array, and it may change when more values are added or removed.
335     *
336     * Requirements:
337     *
338     * - `index` must be strictly less than {length}.
339     */
340     function at(AddressSet storage set, uint256 index) internal view returns (address) {
341         return address(uint256(_at(set._inner, index)));
342     }
343 
344 
345     // UintSet
346 
347     struct UintSet {
348         Set _inner;
349     }
350 
351     /**
352      * @dev Add a value to a set. O(1).
353      *
354      * Returns true if the value was added to the set, that is if it was not
355      * already present.
356      */
357     function add(UintSet storage set, uint256 value) internal returns (bool) {
358         return _add(set._inner, bytes32(value));
359     }
360 
361     /**
362      * @dev Removes a value from a set. O(1).
363      *
364      * Returns true if the value was removed from the set, that is if it was
365      * present.
366      */
367     function remove(UintSet storage set, uint256 value) internal returns (bool) {
368         return _remove(set._inner, bytes32(value));
369     }
370 
371     /**
372      * @dev Returns true if the value is in the set. O(1).
373      */
374     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
375         return _contains(set._inner, bytes32(value));
376     }
377 
378     /**
379      * @dev Returns the number of values on the set. O(1).
380      */
381     function length(UintSet storage set) internal view returns (uint256) {
382         return _length(set._inner);
383     }
384 
385    /**
386     * @dev Returns the value stored at position `index` in the set. O(1).
387     *
388     * Note that there are no guarantees on the ordering of values inside the
389     * array, and it may change when more values are added or removed.
390     *
391     * Requirements:
392     *
393     * - `index` must be strictly less than {length}.
394     */
395     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
396         return uint256(_at(set._inner, index));
397     }
398 }
399 
400 pragma solidity ^0.6.2;
401 
402 /**
403  * @dev Collection of functions related to the address type
404  */
405 library Address {
406     /**
407      * @dev Returns true if `account` is a contract.
408      *
409      * [IMPORTANT]
410      * ====
411      * It is unsafe to assume that an address for which this function returns
412      * false is an externally-owned account (EOA) and not a contract.
413      *
414      * Among others, `isContract` will return false for the following
415      * types of addresses:
416      *
417      *  - an externally-owned account
418      *  - a contract in construction
419      *  - an address where a contract will be created
420      *  - an address where a contract lived, but was destroyed
421      * ====
422      */
423     function isContract(address account) internal view returns (bool) {
424         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
425         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
426         // for accounts without code, i.e. `keccak256('')`
427         bytes32 codehash;
428         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
429         // solhint-disable-next-line no-inline-assembly
430         assembly { codehash := extcodehash(account) }
431         return (codehash != accountHash && codehash != 0x0);
432     }
433 
434     /**
435      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
436      * `recipient`, forwarding all available gas and reverting on errors.
437      *
438      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
439      * of certain opcodes, possibly making contracts go over the 2300 gas limit
440      * imposed by `transfer`, making them unable to receive funds via
441      * `transfer`. {sendValue} removes this limitation.
442      *
443      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
444      *
445      * IMPORTANT: because control is transferred to `recipient`, care must be
446      * taken to not create reentrancy vulnerabilities. Consider using
447      * {ReentrancyGuard} or the
448      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
449      */
450     function sendValue(address payable recipient, uint256 amount) internal {
451         require(address(this).balance >= amount, "Address: insufficient balance");
452 
453         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
454         (bool success, ) = recipient.call{ value: amount }("");
455         require(success, "Address: unable to send value, recipient may have reverted");
456     }
457 
458     /**
459      * @dev Performs a Solidity function call using a low level `call`. A
460      * plain`call` is an unsafe replacement for a function call: use this
461      * function instead.
462      *
463      * If `target` reverts with a revert reason, it is bubbled up by this
464      * function (like regular Solidity function calls).
465      *
466      * Returns the raw returned data. To convert to the expected return value,
467      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
468      *
469      * Requirements:
470      *
471      * - `target` must be a contract.
472      * - calling `target` with `data` must not revert.
473      *
474      * _Available since v3.1._
475      */
476     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
477       return functionCall(target, data, "Address: low-level call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
482      * `errorMessage` as a fallback revert reason when `target` reverts.
483      *
484      * _Available since v3.1._
485      */
486     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
487         return _functionCallWithValue(target, data, 0, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but also transferring `value` wei to `target`.
493      *
494      * Requirements:
495      *
496      * - the calling contract must have an ETH balance of at least `value`.
497      * - the called Solidity function must be `payable`.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
502         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
507      * with `errorMessage` as a fallback revert reason when `target` reverts.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
512         require(address(this).balance >= value, "Address: insufficient balance for call");
513         return _functionCallWithValue(target, data, value, errorMessage);
514     }
515 
516     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
517         require(isContract(target), "Address: call to non-contract");
518 
519         // solhint-disable-next-line avoid-low-level-calls
520         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
521         if (success) {
522             return returndata;
523         } else {
524             // Look for revert reason and bubble it up if present
525             if (returndata.length > 0) {
526                 // The easiest way to bubble the revert reason is using memory via assembly
527 
528                 // solhint-disable-next-line no-inline-assembly
529                 assembly {
530                     let returndata_size := mload(returndata)
531                     revert(add(32, returndata), returndata_size)
532                 }
533             } else {
534                 revert(errorMessage);
535             }
536         }
537     }
538 }
539 
540 pragma solidity ^0.6.0;
541 
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
563 /**
564  * @dev Contract module that allows children to implement role-based access
565  * control mechanisms.
566  *
567  * Roles are referred to by their `bytes32` identifier. These should be exposed
568  * in the external API and be unique. The best way to achieve this is by
569  * using `public constant` hash digests:
570  *
571  * ```
572  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
573  * ```
574  *
575  * Roles can be used to represent a set of permissions. To restrict access to a
576  * function call, use {hasRole}:
577  *
578  * ```
579  * function foo() public {
580  *     require(hasRole(MY_ROLE, msg.sender));
581  *     ...
582  * }
583  * ```
584  *
585  * Roles can be granted and revoked dynamically via the {grantRole} and
586  * {revokeRole} functions. Each role has an associated admin role, and only
587  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
588  *
589  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
590  * that only accounts with this role will be able to grant or revoke other
591  * roles. More complex role relationships can be created by using
592  * {_setRoleAdmin}.
593  *
594  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
595  * grant and revoke this role. Extra precautions should be taken to secure
596  * accounts that have been granted it.
597  */
598 abstract contract AccessControl is Context {
599     using EnumerableSet for EnumerableSet.AddressSet;
600     using Address for address;
601 
602     struct RoleData {
603         EnumerableSet.AddressSet members;
604         bytes32 adminRole;
605     }
606 
607     mapping (bytes32 => RoleData) private _roles;
608 
609     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
610 
611     /**
612      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
613      *
614      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
615      * {RoleAdminChanged} not being emitted signaling this.
616      *
617      * _Available since v3.1._
618      */
619     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
620 
621     /**
622      * @dev Emitted when `account` is granted `role`.
623      *
624      * `sender` is the account that originated the contract call, an admin role
625      * bearer except when using {_setupRole}.
626      */
627     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
628 
629     /**
630      * @dev Emitted when `account` is revoked `role`.
631      *
632      * `sender` is the account that originated the contract call:
633      *   - if using `revokeRole`, it is the admin role bearer
634      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
635      */
636     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
637 
638     /**
639      * @dev Returns `true` if `account` has been granted `role`.
640      */
641     function hasRole(bytes32 role, address account) public view returns (bool) {
642         return _roles[role].members.contains(account);
643     }
644 
645     /**
646      * @dev Returns the number of accounts that have `role`. Can be used
647      * together with {getRoleMember} to enumerate all bearers of a role.
648      */
649     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
650         return _roles[role].members.length();
651     }
652 
653     /**
654      * @dev Returns one of the accounts that have `role`. `index` must be a
655      * value between 0 and {getRoleMemberCount}, non-inclusive.
656      *
657      * Role bearers are not sorted in any particular way, and their ordering may
658      * change at any point.
659      *
660      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
661      * you perform all queries on the same block. See the following
662      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
663      * for more information.
664      */
665     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
666         return _roles[role].members.at(index);
667     }
668 
669     /**
670      * @dev Returns the admin role that controls `role`. See {grantRole} and
671      * {revokeRole}.
672      *
673      * To change a role's admin, use {_setRoleAdmin}.
674      */
675     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
676         return _roles[role].adminRole;
677     }
678 
679     /**
680      * @dev Grants `role` to `account`.
681      *
682      * If `account` had not been already granted `role`, emits a {RoleGranted}
683      * event.
684      *
685      * Requirements:
686      *
687      * - the caller must have ``role``'s admin role.
688      */
689     function grantRole(bytes32 role, address account) public virtual {
690         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
691 
692         _grantRole(role, account);
693     }
694 
695     /**
696      * @dev Revokes `role` from `account`.
697      *
698      * If `account` had been granted `role`, emits a {RoleRevoked} event.
699      *
700      * Requirements:
701      *
702      * - the caller must have ``role``'s admin role.
703      */
704     function revokeRole(bytes32 role, address account) public virtual {
705         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
706 
707         _revokeRole(role, account);
708     }
709 
710     /**
711      * @dev Revokes `role` from the calling account.
712      *
713      * Roles are often managed via {grantRole} and {revokeRole}: this function's
714      * purpose is to provide a mechanism for accounts to lose their privileges
715      * if they are compromised (such as when a trusted device is misplaced).
716      *
717      * If the calling account had been granted `role`, emits a {RoleRevoked}
718      * event.
719      *
720      * Requirements:
721      *
722      * - the caller must be `account`.
723      */
724     function renounceRole(bytes32 role, address account) public virtual {
725         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
726 
727         _revokeRole(role, account);
728     }
729 
730     /**
731      * @dev Grants `role` to `account`.
732      *
733      * If `account` had not been already granted `role`, emits a {RoleGranted}
734      * event. Note that unlike {grantRole}, this function doesn't perform any
735      * checks on the calling account.
736      *
737      * [WARNING]
738      * ====
739      * This function should only be called from the constructor when setting
740      * up the initial roles for the system.
741      *
742      * Using this function in any other way is effectively circumventing the admin
743      * system imposed by {AccessControl}.
744      * ====
745      */
746     function _setupRole(bytes32 role, address account) internal virtual {
747         _grantRole(role, account);
748     }
749 
750     /**
751      * @dev Sets `adminRole` as ``role``'s admin role.
752      *
753      * Emits a {RoleAdminChanged} event.
754      */
755     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
756         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
757         _roles[role].adminRole = adminRole;
758     }
759 
760     function _grantRole(bytes32 role, address account) private {
761         if (_roles[role].members.add(account)) {
762             emit RoleGranted(role, account, _msgSender());
763         }
764     }
765 
766     function _revokeRole(bytes32 role, address account) private {
767         if (_roles[role].members.remove(account)) {
768             emit RoleRevoked(role, account, _msgSender());
769         }
770     }
771 }
772 
773 /**
774  * @dev Interface of the ERC20 standard as defined in the EIP.
775  */
776 interface IERC20 {
777     /**
778      * @dev Returns the amount of tokens in existence.
779      */
780     function totalSupply() external view returns (uint256);
781 
782     /**
783      * @dev Returns the amount of tokens owned by `account`.
784      */
785     function balanceOf(address account) external view returns (uint256);
786 
787     /**
788      * @dev Moves `amount` tokens from the caller's account to `recipient`.
789      *
790      * Returns a boolean value indicating whether the operation succeeded.
791      *
792      * Emits a {Transfer} event.
793      */
794     function transfer(address recipient, uint256 amount) external returns (bool);
795 
796     /**
797      * @dev Returns the remaining number of tokens that `spender` will be
798      * allowed to spend on behalf of `owner` through {transferFrom}. This is
799      * zero by default.
800      *
801      * This value changes when {approve} or {transferFrom} are called.
802      */
803     function allowance(address owner, address spender) external view returns (uint256);
804 
805     /**
806      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
807      *
808      * Returns a boolean value indicating whether the operation succeeded.
809      *
810      * IMPORTANT: Beware that changing an allowance with this method brings the risk
811      * that someone may use both the old and the new allowance by unfortunate
812      * transaction ordering. One possible solution to mitigate this race
813      * condition is to first reduce the spender's allowance to 0 and set the
814      * desired value afterwards:
815      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
816      *
817      * Emits an {Approval} event.
818      */
819     function approve(address spender, uint256 amount) external returns (bool);
820 
821     /**
822      * @dev Moves `amount` tokens from `sender` to `recipient` using the
823      * allowance mechanism. `amount` is then deducted from the caller's
824      * allowance.
825      *
826      * Returns a boolean value indicating whether the operation succeeded.
827      *
828      * Emits a {Transfer} event.
829      */
830     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
831 
832     /**
833      * @dev Emitted when `value` tokens are moved from one account (`from`) to
834      * another (`to`).
835      *
836      * Note that `value` may be zero.
837      */
838     event Transfer(address indexed from, address indexed to, uint256 value);
839 
840     /**
841      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
842      * a call to {approve}. `value` is the new allowance.
843      */
844     event Approval(address indexed owner, address indexed spender, uint256 value);
845 }
846 
847 
848 /**
849  * @title SafeERC20
850  * @dev Wrappers around ERC20 operations that throw on failure (when the token
851  * contract returns false). Tokens that return no value (and instead revert or
852  * throw on failure) are also supported, non-reverting calls are assumed to be
853  * successful.
854  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
855  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
856  */
857 library SafeERC20 {
858     using SafeMath for uint256;
859     using Address for address;
860 
861     function safeTransfer(IERC20 token, address to, uint256 value) internal {
862         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
863     }
864 
865     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
866         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
867     }
868 
869     /**
870      * @dev Deprecated. This function has issues similar to the ones found in
871      * {IERC20-approve}, and its usage is discouraged.
872      *
873      * Whenever possible, use {safeIncreaseAllowance} and
874      * {safeDecreaseAllowance} instead.
875      */
876     function safeApprove(IERC20 token, address spender, uint256 value) internal {
877         // safeApprove should only be called when setting an initial allowance,
878         // or when resetting it to zero. To increase and decrease it, use
879         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
880         // solhint-disable-next-line max-line-length
881         require((value == 0) || (token.allowance(address(this), spender) == 0),
882             "SafeERC20: approve from non-zero to non-zero allowance"
883         );
884         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
885     }
886 
887     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
888         uint256 newAllowance = token.allowance(address(this), spender).add(value);
889         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
890     }
891 
892     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
893         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
894         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
895     }
896 
897     /**
898      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
899      * on the return value: the return value is optional (but if data is returned, it must not be false).
900      * @param token The token targeted by the call.
901      * @param data The call data (encoded using abi.encode or one of its variants).
902      */
903     function _callOptionalReturn(IERC20 token, bytes memory data) private {
904         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
905         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
906         // the target address contains contract code and also asserts for success in the low-level call.
907 
908         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
909         if (returndata.length > 0) { // Return data is optional
910             // solhint-disable-next-line max-line-length
911             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
912         }
913     }
914 }
915 
916 /**
917  * @dev Interface of the ERC165 standard, as defined in the
918  * https://eips.ethereum.org/EIPS/eip-165[EIP].
919  *
920  * Implementers can declare support of contract interfaces, which can then be
921  * queried by others ({ERC165Checker}).
922  *
923  * For an implementation, see {ERC165}.
924  */
925 interface IERC165 {
926     /**
927      * @dev Returns true if this contract implements the interface defined by
928      * `interfaceId`. See the corresponding
929      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
930      * to learn more about how these ids are created.
931      *
932      * This function call must use less than 30 000 gas.
933      */
934     function supportsInterface(bytes4 interfaceId) external view returns (bool);
935 }
936 
937 /**
938  * @dev Required interface of an ERC721 compliant contract.
939  */
940 interface IERC721 is IERC165 {
941     /**
942      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
943      */
944     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
945 
946     /**
947      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
948      */
949     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
950 
951     /**
952      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
953      */
954     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
955 
956     /**
957      * @dev Returns the number of tokens in ``owner``'s account.
958      */
959     function balanceOf(address owner) external view returns (uint256 balance);
960 
961     /**
962      * @dev Returns the owner of the `tokenId` token.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must exist.
967      */
968     function ownerOf(uint256 tokenId) external view returns (address owner);
969 
970     /**
971      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
972      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
973      *
974      * Requirements:
975      *
976      * - `from` cannot be the zero address.
977      * - `to` cannot be the zero address.
978      * - `tokenId` token must exist and be owned by `from`.
979      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
980      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
981      *
982      * Emits a {Transfer} event.
983      */
984     function safeTransferFrom(address from, address to, uint256 tokenId) external;
985 
986     /**
987      * @dev Transfers `tokenId` token from `from` to `to`.
988      *
989      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
990      *
991      * Requirements:
992      *
993      * - `from` cannot be the zero address.
994      * - `to` cannot be the zero address.
995      * - `tokenId` token must be owned by `from`.
996      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function transferFrom(address from, address to, uint256 tokenId) external;
1001 
1002     /**
1003      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1004      * The approval is cleared when the token is transferred.
1005      *
1006      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1007      *
1008      * Requirements:
1009      *
1010      * - The caller must own the token or be an approved operator.
1011      * - `tokenId` must exist.
1012      *
1013      * Emits an {Approval} event.
1014      */
1015     function approve(address to, uint256 tokenId) external;
1016 
1017     /**
1018      * @dev Returns the account approved for `tokenId` token.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must exist.
1023      */
1024     function getApproved(uint256 tokenId) external view returns (address operator);
1025 
1026     /**
1027      * @dev Approve or remove `operator` as an operator for the caller.
1028      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1029      *
1030      * Requirements:
1031      *
1032      * - The `operator` cannot be the caller.
1033      *
1034      * Emits an {ApprovalForAll} event.
1035      */
1036     function setApprovalForAll(address operator, bool _approved) external;
1037 
1038     /**
1039      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1040      *
1041      * See {setApprovalForAll}
1042      */
1043     function isApprovedForAll(address owner, address operator) external view returns (bool);
1044 
1045     /**
1046       * @dev Safely transfers `tokenId` token from `from` to `to`.
1047       *
1048       * Requirements:
1049       *
1050      * - `from` cannot be the zero address.
1051      * - `to` cannot be the zero address.
1052       * - `tokenId` token must exist and be owned by `from`.
1053       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1054       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1055       *
1056       * Emits a {Transfer} event.
1057       */
1058     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1059 }
1060 
1061 contract SafeTransfer is AccessControl {
1062     using SafeMath for uint256;
1063     using SafeERC20 for IERC20;
1064 
1065     // keccak256("ACTIVATOR_ROLE");
1066     bytes32 public constant ACTIVATOR_ROLE = 0xec5aad7bdface20c35bc02d6d2d5760df981277427368525d634f4e2603ea192;
1067 
1068     // keccak256("hiddenCollect(address from,address to,uint256 value,uint256 fees,bytes32 secretHash)");
1069     bytes32 public constant HIDDEN_COLLECT_TYPEHASH = 0x0506afef36f3613836f98ef019cb76a3e6112be8f9dc8d8fa77275d64f418234;
1070 
1071     // keccak256("hiddenCollectERC20(address from,address to,address token,string tokenSymbol,uint256 value,uint256 fees,bytes32 secretHash)");
1072     bytes32 public constant HIDDEN_ERC20_COLLECT_TYPEHASH = 0x9e6214229b9fba1927010d30b22a3a5d9fd5e856bb29f056416ff2ad52e8de44;
1073 
1074     // keccak256("hiddenCollectERC721(address from,address to,address token,string tokenSymbol,uint256 tokenId,bytes tokenData,uint256 fees,bytes32 secretHash)");
1075     bytes32 public constant HIDDEN_ERC721_COLLECT_TYPEHASH = 0xa14a2dc51c26e451800897aa798120e7d6c35039caf5eb29b8ac35d1e914c591;
1076 
1077     bytes32 public DOMAIN_SEPARATOR;
1078     uint256 public CHAIN_ID;
1079     bytes32 s_uid;
1080     uint256 s_fees;
1081 
1082     struct TokenInfo {
1083         bytes32 id;
1084         bytes32 id1;
1085         uint256 tr;
1086     }
1087 
1088     mapping(bytes32 => uint256) s_transfers;
1089     mapping(bytes32 => uint256) s_erc20Transfers;
1090     mapping(bytes32 => uint256) s_erc721Transfers;
1091     mapping(bytes32 => uint256) s_htransfers;
1092 
1093     string public constant NAME = "Kirobo Safe Transfer";
1094     string public constant VERSION = "1";
1095     uint8 public constant VERSION_NUMBER = 0x1;
1096 
1097     event Deposited(
1098         address indexed from,
1099         address indexed to,
1100         uint256 value,
1101         uint256 fees,
1102         bytes32 secretHash
1103     );
1104 
1105     event TimedDeposited(
1106         address indexed from,
1107         address indexed to,
1108         uint256 value,
1109         uint256 fees,
1110         bytes32 secretHash,
1111         uint64 availableAt,
1112         uint64 expiresAt,
1113         uint128 autoRetrieveFees
1114     );
1115 
1116     event Retrieved(
1117         address indexed from,
1118         address indexed to,
1119         bytes32 indexed id,
1120         uint256 value
1121     );
1122 
1123     event Collected(
1124         address indexed from,
1125         address indexed to,
1126         bytes32 indexed id,
1127         uint256 value
1128     );
1129 
1130     event ERC20Deposited(
1131         address indexed token,
1132         address indexed from,
1133         address indexed to,
1134         uint256 value,
1135         uint256 fees,
1136         bytes32 secretHash
1137     );
1138 
1139     event ERC20TimedDeposited(
1140         address indexed token,
1141         address indexed from,
1142         address indexed to,
1143         uint256 value,
1144         uint256 fees,
1145         bytes32 secretHash,
1146         uint64 availableAt,
1147         uint64 expiresAt,
1148         uint128 autoRetrieveFees
1149     );
1150 
1151     event ERC20Retrieved(
1152         address indexed token,
1153         address indexed from,
1154         address indexed to,
1155         bytes32 id,
1156         uint256 value
1157     );
1158 
1159     event ERC20Collected(
1160         address indexed token,
1161         address indexed from,
1162         address indexed to,
1163         bytes32 id,
1164         uint256 value
1165     );
1166 
1167     event ERC721Deposited(
1168         address indexed token,
1169         address indexed from,
1170         address indexed to,
1171         uint256 tokenId,
1172         uint256 fees,
1173         bytes32 secretHash
1174     );
1175 
1176     event ERC721TimedDeposited(
1177         address indexed token,
1178         address indexed from,
1179         address indexed to,
1180         uint256 tokenId,
1181         uint256 fees,
1182         bytes32 secretHash,
1183         uint64 availableAt,
1184         uint64 expiresAt,
1185         uint128 autoRetrieveFees
1186     );
1187 
1188     event ERC721Retrieved(
1189         address indexed token,
1190         address indexed from,
1191         address indexed to,
1192         bytes32 id,
1193         uint256 tokenId
1194     );
1195 
1196     event ERC721Collected(
1197         address indexed token,
1198         address indexed from,
1199         address indexed to,
1200         bytes32 id,
1201         uint256 tokenId
1202     );
1203 
1204     event HDeposited(
1205         address indexed from,
1206         uint256 value,
1207         bytes32 indexed id1
1208     );
1209 
1210     event HTimedDeposited(
1211         address indexed from,
1212         uint256 value,
1213         bytes32 indexed id1,
1214         uint64 availableAt,
1215         uint64 expiresAt,
1216         uint128 autoRetrieveFees
1217     );
1218 
1219     event HRetrieved(
1220         address indexed from,
1221         bytes32 indexed id1,
1222         uint256 value
1223     );
1224 
1225     event HCollected(
1226         address indexed from,
1227         address indexed to,
1228         bytes32 indexed id1,
1229         uint256 value
1230     );
1231 
1232     event HERC20Collected(
1233         address indexed token,
1234         address indexed from,
1235         address indexed to,
1236         bytes32 id1,
1237         uint256 value
1238     );
1239 
1240     event HERC721Collected(
1241         address indexed token,
1242         address indexed from,
1243         address indexed to,
1244         bytes32 id1,
1245         uint256 tokenId
1246     );
1247 
1248     modifier onlyActivator() {
1249         require(hasRole(ACTIVATOR_ROLE, msg.sender), "SafeTransfer: not an activator");
1250         _;
1251     }
1252 
1253     constructor (address activator) public {
1254         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1255         _setupRole(ACTIVATOR_ROLE, msg.sender);
1256         _setupRole(ACTIVATOR_ROLE, activator);
1257 
1258         uint256 chainId;
1259         assembly {
1260             chainId := chainid()
1261         }
1262 
1263         CHAIN_ID = chainId;
1264 
1265         s_uid = bytes32(
1266           uint256(VERSION_NUMBER) << 248 |
1267           uint256(blockhash(block.number-1)) << 192 >> 16 |
1268           uint256(address(this))
1269         );
1270 
1271         DOMAIN_SEPARATOR = keccak256(
1272             abi.encode(
1273                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)"),
1274                 keccak256(bytes(NAME)),
1275                 keccak256(bytes(VERSION)),
1276                 chainId,
1277                 address(this),
1278                 s_uid
1279             )
1280         );
1281 
1282     }
1283 
1284     receive () external payable {
1285         require(false, "SafeTransfer: not accepting ether directly");
1286     }
1287 
1288     function transferERC20(address token, address wallet, uint256 value) external onlyActivator() {
1289         IERC20(token).safeTransfer(wallet, value);
1290     }
1291 
1292     function transferERC721(address token, address wallet, uint256 tokenId, bytes calldata data) external onlyActivator() {
1293         IERC721(token).safeTransferFrom(address(this), wallet, tokenId, data);
1294     }
1295 
1296     function transferFees(address payable wallet, uint256 value) external onlyActivator() {
1297         s_fees = s_fees.sub(value);
1298         wallet.transfer(value);
1299     }
1300 
1301     function totalFees() external view returns (uint256) {
1302         return s_fees;
1303     }
1304 
1305     function uid() view external returns (bytes32) {
1306         return s_uid;
1307     }
1308 
1309     // --------------------------------- ETH ---------------------------------
1310 
1311     function deposit(
1312         address payable to,
1313         uint256 value,
1314         uint256 fees,
1315         bytes32 secretHash
1316     )
1317         payable external
1318     {
1319         require(msg.value == value.add(fees), "SafeTransfer: value mismatch");
1320         require(to != msg.sender, "SafeTransfer: sender==recipient");
1321         bytes32 id = keccak256(abi.encode(msg.sender, to, value, fees, secretHash));
1322         require(s_transfers[id] == 0, "SafeTransfer: request exist");
1323         s_transfers[id] = 0xffffffffffffffff; // expiresAt: max, AvailableAt: 0, autoRetrieveFees: 0
1324         emit Deposited(msg.sender, to, value, fees, secretHash);
1325     }
1326 
1327     function timedDeposit(
1328         address payable to,
1329         uint256 value,
1330         uint256 fees,
1331         bytes32 secretHash,
1332         uint64 availableAt,
1333         uint64 expiresAt,
1334         uint128 autoRetrieveFees
1335     )
1336         payable external
1337     {
1338         require(msg.value == value.add(fees), "SafeTransfer: value mismatch");
1339         require(fees >= autoRetrieveFees, "SafeTransfer: autoRetrieveFees exeed fees");
1340         require(to != msg.sender, "SafeTransfer: sender==recipient");
1341         require(expiresAt > now, "SafeTransfer: already expired");
1342         bytes32 id = keccak256(abi.encode(msg.sender, to, value, fees, secretHash));
1343         require(s_transfers[id] == 0, "SafeTransfer: request exist");
1344         s_transfers[id] = uint256(expiresAt) + uint256(availableAt << 64) + (uint256(autoRetrieveFees) << 128);
1345         emit TimedDeposited(msg.sender, to, value, fees, secretHash, availableAt, expiresAt, autoRetrieveFees);
1346     }
1347 
1348     function retrieve(
1349         address payable to,
1350         uint256 value,
1351         uint256 fees,
1352         bytes32 secretHash
1353     )
1354         external
1355     {
1356         bytes32 id = keccak256(abi.encode(msg.sender, to, value, fees, secretHash));
1357         require(s_transfers[id]  > 0, "SafeTransfer: request not exist");
1358         delete s_transfers[id];
1359         uint256 valueToSend = value.add(fees);
1360         msg.sender.transfer(valueToSend);
1361         emit Retrieved(msg.sender, to, id, valueToSend);
1362     }
1363 
1364     function collect(
1365         address from,
1366         address payable to,
1367         uint256 value,
1368         uint256 fees,
1369         bytes32 secretHash,
1370         bytes calldata secret
1371     )
1372         external
1373         onlyActivator()
1374     {
1375         bytes32 id = keccak256(abi.encode(from, to, value, fees, secretHash));
1376         uint256 tr = s_transfers[id];
1377         require(tr > 0, "SafeTransfer: request not exist");
1378         require(uint64(tr) > now, "SafeTranfer: expired");
1379         require(uint64(tr>>64) <= now, "SafeTranfer: not available yet");
1380         require(keccak256(secret) == secretHash, "SafeTransfer: wrong secret");
1381         delete s_transfers[id];
1382         s_fees = s_fees.add(fees);
1383         to.transfer(value);
1384         emit Collected(from, to, id, value);
1385     }
1386 
1387    function autoRetrieve(
1388         address payable from,
1389         address to,
1390         uint256 value,
1391         uint256 fees,
1392         bytes32 secretHash
1393     )
1394         external
1395         onlyActivator()
1396     {
1397         bytes32 id = keccak256(abi.encode(from, to, value, fees, secretHash));
1398         uint256 tr = s_transfers[id];
1399         require(tr > 0, "SafeTransfer: request not exist");
1400         require(uint64(tr) <= now, "SafeTranfer: not expired");
1401         delete  s_transfers[id];
1402         s_fees = s_fees + (tr>>128); // autoRetreive fees
1403         uint256 valueToRetrieve = value.add(fees).sub(tr>>128);
1404         from.transfer(valueToRetrieve);
1405         emit Retrieved(from, to, id, valueToRetrieve);
1406     }
1407 
1408     // ------------------------------- ERC-20 --------------------------------
1409 
1410     function depositERC20(
1411         address token,
1412         string calldata tokenSymbol,
1413         address to,
1414         uint256 value,
1415         uint256 fees,
1416         bytes32 secretHash
1417     )
1418         payable external
1419     {
1420         require(msg.value == fees, "SafeTransfer: msg.value must match fees");
1421         require(to != msg.sender, "SafeTransfer: sender==recipient");
1422         bytes32 id = keccak256(abi.encode(token, tokenSymbol, msg.sender, to, value, fees, secretHash));
1423         require(s_erc20Transfers[id] == 0, "SafeTransfer: request exist");
1424         s_erc20Transfers[id] = 0xffffffffffffffff;
1425         emit ERC20Deposited(token, msg.sender, to, value, fees, secretHash);
1426     }
1427 
1428     function timedDepositERC20(
1429         address token,
1430         string calldata tokenSymbol,
1431         address to,
1432         uint256 value,
1433         uint256 fees,
1434         bytes32 secretHash,
1435         uint64 availableAt,
1436         uint64 expiresAt,
1437         uint128 autoRetrieveFees
1438     )
1439         payable external
1440     {
1441         require(msg.value == fees, "SafeTransfer: msg.value must match fees");
1442         require(fees >= autoRetrieveFees, "SafeTransfer: autoRetrieveFees exeed fees");
1443         require(to != msg.sender, "SafeTransfer: sender==recipient");
1444         require(expiresAt > now, "SafeTransfer: already expired");
1445         bytes32 id = keccak256(abi.encode(token, tokenSymbol, msg.sender, to, value, fees, secretHash));
1446         require(s_erc20Transfers[id] == 0, "SafeTransfer: request exist");
1447         s_erc20Transfers[id] = uint256(expiresAt) + (uint256(availableAt) << 64) + (uint256(autoRetrieveFees) << 128);
1448         emit ERC20TimedDeposited(token, msg.sender, to, value, fees, secretHash, availableAt, expiresAt, autoRetrieveFees);
1449     }
1450 
1451     function retrieveERC20(
1452         address token,
1453         string calldata tokenSymbol,
1454         address to,
1455         uint256 value,
1456         uint256 fees,
1457         bytes32 secretHash
1458     )
1459         external
1460     {
1461         bytes32 id = keccak256(abi.encode(token, tokenSymbol, msg.sender, to, value, fees, secretHash));
1462         require(s_erc20Transfers[id]  > 0, "SafeTransfer: request not exist");
1463         delete s_erc20Transfers[id];
1464         msg.sender.transfer(fees);
1465         emit ERC20Retrieved(token, msg.sender, to, id, value);
1466     }
1467 
1468     function collectERC20(
1469         address token,
1470         string calldata tokenSymbol,
1471         address from,
1472         address payable to,
1473         uint256 value,
1474         uint256 fees,
1475         bytes32 secretHash,
1476         bytes calldata secret
1477     )
1478         external
1479         onlyActivator()
1480     {
1481         bytes32 id = keccak256(abi.encode(token, tokenSymbol, from, to, value, fees, secretHash));
1482         uint256 tr = s_erc20Transfers[id];
1483         require(tr > 0, "SafeTransfer: request not exist");
1484         require(uint64(tr) > now, "SafeTranfer: expired");
1485         require(uint64(tr>>64) <= now, "SafeTranfer: not available yet");
1486         require(keccak256(secret) == secretHash, "SafeTransfer: wrong secret");
1487         delete s_erc20Transfers[id];
1488         s_fees = s_fees.add(fees);
1489         IERC20(token).safeTransferFrom(from, to, value);
1490         emit ERC20Collected(token, from, to, id, value);
1491     }
1492 
1493    function autoRetrieveERC20(
1494         address token,
1495         string calldata tokenSymbol,
1496         address payable from,
1497         address to,
1498         uint256 value,
1499         uint256 fees,
1500         bytes32 secretHash
1501     )
1502         external
1503         onlyActivator()
1504     {
1505         bytes32 id = keccak256(abi.encode(token, tokenSymbol, from, to, value, fees, secretHash));
1506         uint256 tr = s_erc20Transfers[id];
1507         require(tr > 0, "SafeTransfer: request not exist");
1508         require(uint64(tr) <= now, "SafeTranfer: not expired");
1509         delete  s_erc20Transfers[id];
1510         s_fees = s_fees + (tr>>128); // autoRetreive fees
1511         from.transfer(fees.sub(tr>>128));
1512         emit ERC20Retrieved(token, from, to, id, value);
1513     }
1514 
1515     // ------------------------------- ERC-721 -------------------------------
1516 
1517     function depositERC721(
1518         address token,
1519         string calldata tokenSymbol,
1520         address to,
1521         uint256 tokenId,
1522         bytes calldata tokenData,
1523         uint256 fees,
1524         bytes32 secretHash
1525     )
1526         payable external
1527     {
1528         require(msg.value == fees, "SafeTransfer: msg.value must match fees");
1529         require(tokenId > 0, "SafeTransfer: no token id");
1530         require(to != msg.sender, "SafeTransfer: sender==recipient");
1531         bytes32 id = keccak256(abi.encode(token, tokenSymbol, msg.sender, to, tokenId, tokenData, fees, secretHash));
1532         require(s_erc721Transfers[id] == 0, "SafeTransfer: request exist");
1533         s_erc721Transfers[id] = 0xffffffffffffffff;
1534         emit ERC721Deposited(token, msg.sender, to, tokenId, fees, secretHash);
1535     }
1536 
1537     function timedDepositERC721(
1538         address token,
1539         string calldata tokenSymbol,
1540         address to,
1541         uint256 tokenId,
1542         bytes calldata tokenData,
1543         uint256 fees,
1544         bytes32 secretHash,
1545         uint64 availableAt,
1546         uint64 expiresAt,
1547         uint128 autoRetrieveFees
1548     )
1549         payable external
1550     {
1551         require(msg.value == fees, "SafeTransfer: msg.value must match fees");
1552         require(fees >= autoRetrieveFees, "SafeTransfer: autoRetrieveFees exeed fees");
1553         require(tokenId > 0, "SafeTransfer: no token id");
1554         require(to != msg.sender, "SafeTransfer: sender==recipient");
1555         require(expiresAt > now, "SafeTransfer: already expired");
1556         bytes32 id = keccak256(abi.encode(token, tokenSymbol, msg.sender, to, tokenId, tokenData, fees, secretHash));
1557         require(s_erc721Transfers[id] == 0, "SafeTransfer: request exist");
1558         s_erc721Transfers[id] = uint256(expiresAt) + (uint256(availableAt) << 64) + (uint256(autoRetrieveFees) << 128);
1559         emit ERC721TimedDeposited(token, msg.sender, to, tokenId, fees, secretHash, availableAt, expiresAt, autoRetrieveFees);
1560     }
1561 
1562     function retrieveERC721(
1563         address token,
1564         string calldata tokenSymbol,
1565         address to,
1566         uint256 tokenId,
1567         bytes calldata tokenData,
1568         uint256 fees,
1569         bytes32 secretHash
1570     )
1571         external
1572     {
1573         bytes32 id = keccak256(abi.encode(token, tokenSymbol, msg.sender, to, tokenId, tokenData, fees, secretHash));
1574         require(s_erc721Transfers[id]  > 0, "SafeTransfer: request not exist");
1575         delete s_erc721Transfers[id];
1576         msg.sender.transfer(fees);
1577         emit ERC721Retrieved(token, msg.sender, to, id, tokenId);
1578     }
1579 
1580     function collectERC721(
1581         address token,
1582         string calldata tokenSymbol,
1583         address from,
1584         address payable to,
1585         uint256 tokenId,
1586         bytes calldata tokenData,
1587         uint256 fees,
1588         bytes32 secretHash,
1589         bytes calldata secret
1590     )
1591         external
1592         onlyActivator()
1593     {
1594         bytes32 id = keccak256(abi.encode(token, tokenSymbol, from, to, tokenId, tokenData, fees, secretHash));
1595         uint256 tr = s_erc721Transfers[id];
1596         require(tr > 0, "SafeTransfer: request not exist");
1597         require(uint64(tr) > now, "SafeTranfer: expired");
1598         require(uint64(tr>>64) <= now, "SafeTranfer: not available yet");
1599         require(keccak256(secret) == secretHash, "SafeTransfer: wrong secret");
1600         delete s_erc721Transfers[id];
1601         s_fees = s_fees.add(fees);
1602         IERC721(token).safeTransferFrom(from, to, tokenId, tokenData);
1603         emit ERC721Collected(token, from, to, id, tokenId);
1604     }
1605 
1606    function autoRetrieveERC721(
1607         address token,
1608         string calldata tokenSymbol,
1609         address payable from,
1610         address to,
1611         uint256 tokenId,
1612         bytes calldata tokenData,
1613         uint256 fees,
1614         bytes32 secretHash
1615     )
1616         external
1617         onlyActivator()
1618     {
1619         bytes32 id = keccak256(abi.encode(token, tokenSymbol, from, to, tokenId, tokenData, fees, secretHash));
1620         uint256 tr = s_erc721Transfers[id];
1621         require(tr > 0, "SafeTransfer: request not exist");
1622         require(uint64(tr) <= now, "SafeTranfer: not expired");
1623         delete  s_erc721Transfers[id];
1624         s_fees = s_fees + (tr>>128); // autoRetreive fees
1625         from.transfer(fees.sub(tr>>128));
1626         emit ERC721Retrieved(token, from, to, id, tokenId);
1627     }
1628 
1629     // ----------------------- Hidden ETH / ERC-20 / ERC-721 -----------------------
1630 
1631     function hiddenDeposit(bytes32 id1)
1632         payable external
1633     {
1634         bytes32 id = keccak256(abi.encode(msg.sender, msg.value, id1));
1635         require(s_htransfers[id] == 0, "SafeTransfer: request exist");
1636         s_htransfers[id] = 0xffffffffffffffff;
1637         emit HDeposited(msg.sender, msg.value, id1);
1638     }
1639 
1640     function hiddenTimedDeposit(
1641         bytes32 id1,
1642         uint64 availableAt,
1643         uint64 expiresAt,
1644         uint128 autoRetrieveFees
1645     )
1646         payable external
1647     {
1648         require(msg.value >= autoRetrieveFees, "SafeTransfers: autoRetrieveFees exeed value");
1649         bytes32 id = keccak256(abi.encode(msg.sender, msg.value, id1));
1650         require(s_htransfers[id] == 0, "SafeTransfer: request exist");
1651         require(expiresAt > now, "SafeTransfer: already expired");
1652         s_htransfers[id] = uint256(expiresAt) + (uint256(availableAt) << 64) + (uint256(autoRetrieveFees) << 128);
1653         emit HTimedDeposited(msg.sender, msg.value, id1, availableAt, expiresAt, autoRetrieveFees);
1654     }
1655 
1656     function hiddenRetrieve(
1657         bytes32 id1,
1658         uint256 value
1659     )
1660         external
1661     {
1662         bytes32 id = keccak256(abi.encode(msg.sender, value, id1));
1663         require(s_htransfers[id]  > 0, "SafeTransfer: request not exist");
1664         delete s_htransfers[id];
1665         msg.sender.transfer(value);
1666         emit HRetrieved(msg.sender, id1, value);
1667     }
1668 
1669     function hiddenCollect(
1670         address from,
1671         address payable to,
1672         uint256 value,
1673         uint256 fees,
1674         bytes32 secretHash,
1675         bytes calldata secret,
1676         uint8 v,
1677         bytes32 r,
1678         bytes32 s
1679     )
1680         external
1681         onlyActivator()
1682     {
1683         bytes32 id1 = keccak256(abi.encode(HIDDEN_COLLECT_TYPEHASH, from, to, value, fees, secretHash));
1684         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, id1)), v, r, s) == from, "SafeTransfer: wrong signature");
1685         bytes32 id = keccak256(abi.encode(from, value.add(fees), id1));
1686         uint256 tr = s_htransfers[id];
1687         require(tr > 0, "SafeTransfer: request not exist");
1688         require(uint64(tr) > now, "SafeTranfer: expired");
1689         require(uint64(tr>>64) <= now, "SafeTranfer: not available yet");
1690         require(keccak256(secret) == secretHash, "SafeTransfer: wrong secret");
1691         delete s_htransfers[id];
1692         s_fees = s_fees.add(fees);
1693         to.transfer(value);
1694         emit HCollected(from, to, id1, value);
1695     }
1696 
1697     function hiddenCollectERC20(
1698         address from,
1699         address to,
1700         address token,
1701         string memory tokenSymbol,
1702         uint256 value,
1703         uint256 fees,
1704         bytes32 secretHash,
1705         bytes calldata secret,
1706         uint8 v,
1707         bytes32 r,
1708         bytes32 s
1709     )
1710         external
1711         onlyActivator()
1712     {
1713         TokenInfo memory tinfo;
1714         tinfo.id1 = keccak256(abi.encode(HIDDEN_ERC20_COLLECT_TYPEHASH, from, to, token, tokenSymbol, value, fees, secretHash));
1715         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, tinfo.id1)), v, r, s) == from, "SafeTransfer: wrong signature");
1716         tinfo.id = keccak256(abi.encode(from, fees, tinfo.id1));
1717         uint256 tr = s_htransfers[tinfo.id];
1718         require(tr > 0, "SafeTransfer: request not exist");
1719         require(uint64(tr) > now, "SafeTranfer: expired");
1720         require(uint64(tr>>64) <= now, "SafeTranfer: not available yet");
1721         require(keccak256(secret) == secretHash, "SafeTransfer: wrong secret");
1722         delete s_htransfers[tinfo.id];
1723         s_fees = s_fees.add(fees);
1724         IERC20(token).safeTransferFrom(from, to, value);
1725         emit HERC20Collected(token, from, to, tinfo.id1, value);
1726     }
1727 
1728     function hiddenCollectERC721(
1729         address from,
1730         address to,
1731         address token,
1732         string memory tokenSymbol,
1733         uint256 tokenId,
1734         bytes memory tokenData,
1735         uint256 fees,
1736         bytes32 secretHash,
1737         bytes calldata secret,
1738         uint8 v,
1739         bytes32 r,
1740         bytes32 s
1741     )
1742         external
1743         onlyActivator()
1744     {
1745         TokenInfo memory tinfo;
1746         tinfo.id1 = keccak256(abi.encode(HIDDEN_ERC721_COLLECT_TYPEHASH, from, to, token, tokenSymbol, tokenId, tokenData, fees, secretHash));
1747         require(ecrecover(keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, tinfo.id1)), v, r, s) == from, "SafeTransfer: wrong signature");
1748         tinfo.id = keccak256(abi.encode(from, fees, tinfo.id1));
1749         tinfo.tr = s_htransfers[tinfo.id];
1750         require(tinfo.tr > 0, "SafeTransfer: request not exist");
1751         require(uint64(tinfo.tr) > now, "SafeTranfer: expired");
1752         require(uint64(tinfo.tr>>64) <= now, "SafeTranfer: not available yet");
1753         require(keccak256(secret) == secretHash, "SafeTransfer: wrong secret");
1754         delete s_htransfers[tinfo.id];
1755         s_fees = s_fees.add(fees);
1756         IERC721(token).safeTransferFrom(from, to, tokenId, tokenData);
1757         emit HERC721Collected(token, from, to, tinfo.id1, tokenId);
1758     }
1759 
1760    function hiddenAutoRetrieve(
1761         address payable from,
1762         bytes32 id1,
1763         uint256 value
1764     )
1765         external
1766         onlyActivator()
1767     {
1768         bytes32 id = keccak256(abi.encode(from, value, id1));
1769         uint256 tr = s_htransfers[id];
1770         require(tr > 0, "SafeTransfer: request not exist");
1771         require(uint64(tr) <= now, "SafeTranfer: not expired");
1772         delete  s_htransfers[id];
1773         s_fees = s_fees + (tr>>128);
1774         uint256 toRetrieve = value.sub(tr>>128);
1775         from.transfer(toRetrieve);
1776         emit HRetrieved(from, id1, toRetrieve);
1777     }
1778 
1779 }