1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-23
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-or-later
6 pragma solidity 0.6.12;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     /**
13      * @dev Returns the largest of two numbers.
14      */
15     function max(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a >= b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two numbers.
21      */
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two numbers. The result is rounded towards
28      * zero.
29      */
30     function average(uint256 a, uint256 b) internal pure returns (uint256) {
31         // (a + b) / 2 can overflow, so we distribute
32         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
33     }
34 }
35 
36 /**
37  * @dev Wrappers over Solidity's arithmetic operations with added overflow
38  * checks.
39  *
40  * Arithmetic operations in Solidity wrap on overflow. This can easily result
41  * in bugs, because programmers usually assume that an overflow raises an
42  * error, which is the standard behavior in high level programming languages.
43  * `SafeMath` restores this intuition by reverting the transaction when an
44  * operation overflows.
45  *
46  * Using this library instead of the unchecked operations eliminates an entire
47  * class of bugs, so it's recommended to use it always.
48  */
49 library SafeMath {
50     /**
51      * @dev Returns the addition of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `+` operator.
55      *
56      * Requirements:
57      *
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      *
75      * - Subtraction cannot overflow.
76      */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     /**
82      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
83      * overflow (when the result is negative).
84      *
85      * Counterpart to Solidity's `-` operator.
86      *
87      * Requirements:
88      *
89      * - Subtraction cannot overflow.
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      *
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b, "SafeMath: multiplication overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers. Reverts on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137 
138     /**
139      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
140      * division by zero. The result is rounded towards zero.
141      *
142      * Counterpart to Solidity's `/` operator. Note: this function uses a
143      * `revert` opcode (which leaves remaining gas untouched) while Solidity
144      * uses an invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return mod(a, b, "SafeMath: modulo by zero");
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
176      * Reverts with custom message when dividing by zero.
177      *
178      * Counterpart to Solidity's `%` operator. This function uses a `revert`
179      * opcode (which leaves remaining gas untouched) while Solidity uses an
180      * invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 /**
193  * @dev Library for managing
194  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
195  * types.
196  *
197  * Sets have the following properties:
198  *
199  * - Elements are added, removed, and checked for existence in constant time
200  * (O(1)).
201  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
202  *
203  * ```
204  * contract Example {
205  *     // Add the library methods
206  *     using EnumerableSet for EnumerableSet.AddressSet;
207  *
208  *     // Declare a set state variable
209  *     EnumerableSet.AddressSet private mySet;
210  * }
211  * ```
212  *
213  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
214  * (`UintSet`) are supported.
215  */
216 library EnumerableSet {
217     // To implement this library for multiple types with as little code
218     // repetition as possible, we write it in terms of a generic Set type with
219     // bytes32 values.
220     // The Set implementation uses private functions, and user-facing
221     // implementations (such as AddressSet) are just wrappers around the
222     // underlying Set.
223     // This means that we can only create new EnumerableSets for types that fit
224     // in bytes32.
225 
226     struct Set {
227         // Storage of set values
228         bytes32[] _values;
229 
230         // Position of the value in the `values` array, plus 1 because index 0
231         // means a value is not in the set.
232         mapping (bytes32 => uint256) _indexes;
233     }
234 
235     /**
236      * @dev Add a value to a set. O(1).
237      *
238      * Returns true if the value was added to the set, that is if it was not
239      * already present.
240      */
241     function _add(Set storage set, bytes32 value) private returns (bool) {
242         if (!_contains(set, value)) {
243             set._values.push(value);
244             // The value is stored at length-1, but we add 1 to all indexes
245             // and use 0 as a sentinel value
246             set._indexes[value] = set._values.length;
247             return true;
248         } else {
249             return false;
250         }
251     }
252 
253     /**
254      * @dev Removes a value from a set. O(1).
255      *
256      * Returns true if the value was removed from the set, that is if it was
257      * present.
258      */
259     function _remove(Set storage set, bytes32 value) private returns (bool) {
260         // We read and store the value's index to prevent multiple reads from the same storage slot
261         uint256 valueIndex = set._indexes[value];
262 
263         if (valueIndex != 0) { // Equivalent to contains(set, value)
264             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
265             // the array, and then remove the last element (sometimes called as 'swap and pop').
266             // This modifies the order of the array, as noted in {at}.
267 
268             uint256 toDeleteIndex = valueIndex - 1;
269             uint256 lastIndex = set._values.length - 1;
270 
271             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
272             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
273 
274             bytes32 lastvalue = set._values[lastIndex];
275 
276             // Move the last value to the index where the value to delete is
277             set._values[toDeleteIndex] = lastvalue;
278             // Update the index for the moved value
279             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
280 
281             // Delete the slot where the moved value was stored
282             set._values.pop();
283 
284             // Delete the index for the deleted slot
285             delete set._indexes[value];
286 
287             return true;
288         } else {
289             return false;
290         }
291     }
292 
293     /**
294      * @dev Returns true if the value is in the set. O(1).
295      */
296     function _contains(Set storage set, bytes32 value) private view returns (bool) {
297         return set._indexes[value] != 0;
298     }
299 
300     /**
301      * @dev Returns the number of values on the set. O(1).
302      */
303     function _length(Set storage set) private view returns (uint256) {
304         return set._values.length;
305     }
306 
307    /**
308     * @dev Returns the value stored at position `index` in the set. O(1).
309     *
310     * Note that there are no guarantees on the ordering of values inside the
311     * array, and it may change when more values are added or removed.
312     *
313     * Requirements:
314     *
315     * - `index` must be strictly less than {length}.
316     */
317     function _at(Set storage set, uint256 index) private view returns (bytes32) {
318         require(set._values.length > index, "EnumerableSet: index out of bounds");
319         return set._values[index];
320     }
321 
322     // AddressSet
323 
324     struct AddressSet {
325         Set _inner;
326     }
327 
328     /**
329      * @dev Add a value to a set. O(1).
330      *
331      * Returns true if the value was added to the set, that is if it was not
332      * already present.
333      */
334     function add(AddressSet storage set, address value) internal returns (bool) {
335         return _add(set._inner, bytes32(uint256(value)));
336     }
337 
338     /**
339      * @dev Removes a value from a set. O(1).
340      *
341      * Returns true if the value was removed from the set, that is if it was
342      * present.
343      */
344     function remove(AddressSet storage set, address value) internal returns (bool) {
345         return _remove(set._inner, bytes32(uint256(value)));
346     }
347 
348     /**
349      * @dev Returns true if the value is in the set. O(1).
350      */
351     function contains(AddressSet storage set, address value) internal view returns (bool) {
352         return _contains(set._inner, bytes32(uint256(value)));
353     }
354 
355     /**
356      * @dev Returns the number of values in the set. O(1).
357      */
358     function length(AddressSet storage set) internal view returns (uint256) {
359         return _length(set._inner);
360     }
361 
362    /**
363     * @dev Returns the value stored at position `index` in the set. O(1).
364     *
365     * Note that there are no guarantees on the ordering of values inside the
366     * array, and it may change when more values are added or removed.
367     *
368     * Requirements:
369     *
370     * - `index` must be strictly less than {length}.
371     */
372     function at(AddressSet storage set, uint256 index) internal view returns (address) {
373         return address(uint256(_at(set._inner, index)));
374     }
375 
376 
377     // UintSet
378 
379     struct UintSet {
380         Set _inner;
381     }
382 
383     /**
384      * @dev Add a value to a set. O(1).
385      *
386      * Returns true if the value was added to the set, that is if it was not
387      * already present.
388      */
389     function add(UintSet storage set, uint256 value) internal returns (bool) {
390         return _add(set._inner, bytes32(value));
391     }
392 
393     /**
394      * @dev Removes a value from a set. O(1).
395      *
396      * Returns true if the value was removed from the set, that is if it was
397      * present.
398      */
399     function remove(UintSet storage set, uint256 value) internal returns (bool) {
400         return _remove(set._inner, bytes32(value));
401     }
402 
403     /**
404      * @dev Returns true if the value is in the set. O(1).
405      */
406     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
407         return _contains(set._inner, bytes32(value));
408     }
409 
410     /**
411      * @dev Returns the number of values on the set. O(1).
412      */
413     function length(UintSet storage set) internal view returns (uint256) {
414         return _length(set._inner);
415     }
416 
417    /**
418     * @dev Returns the value stored at position `index` in the set. O(1).
419     *
420     * Note that there are no guarantees on the ordering of values inside the
421     * array, and it may change when more values are added or removed.
422     *
423     * Requirements:
424     *
425     * - `index` must be strictly less than {length}.
426     */
427     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
428         return uint256(_at(set._inner, index));
429     }
430 }
431 
432 /**
433  * @dev Collection of functions related to the address type
434  */
435 library Address {
436     /**
437      * @dev Returns true if `account` is a contract.
438      *
439      * [IMPORTANT]
440      * ====
441      * It is unsafe to assume that an address for which this function returns
442      * false is an externally-owned account (EOA) and not a contract.
443      *
444      * Among others, `isContract` will return false for the following
445      * types of addresses:
446      *
447      *  - an externally-owned account
448      *  - a contract in construction
449      *  - an address where a contract will be created
450      *  - an address where a contract lived, but was destroyed
451      * ====
452      */
453     function isContract(address account) internal view returns (bool) {
454         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
455         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
456         // for accounts without code, i.e. `keccak256('')`
457         bytes32 codehash;
458         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
459         // solhint-disable-next-line no-inline-assembly
460         assembly { codehash := extcodehash(account) }
461         return (codehash != accountHash && codehash != 0x0);
462     }
463 
464     /**
465      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
466      * `recipient`, forwarding all available gas and reverting on errors.
467      *
468      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
469      * of certain opcodes, possibly making contracts go over the 2300 gas limit
470      * imposed by `transfer`, making them unable to receive funds via
471      * `transfer`. {sendValue} removes this limitation.
472      *
473      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
474      *
475      * IMPORTANT: because control is transferred to `recipient`, care must be
476      * taken to not create reentrancy vulnerabilities. Consider using
477      * {ReentrancyGuard} or the
478      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
479      */
480     function sendValue(address payable recipient, uint256 amount) internal {
481         require(address(this).balance >= amount, "Address: insufficient balance");
482 
483         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
484         (bool success, ) = recipient.call{ value: amount }("");
485         require(success, "Address: unable to send value, recipient may have reverted");
486     }
487 
488     /**
489      * @dev Performs a Solidity function call using a low level `call`. A
490      * plain`call` is an unsafe replacement for a function call: use this
491      * function instead.
492      *
493      * If `target` reverts with a revert reason, it is bubbled up by this
494      * function (like regular Solidity function calls).
495      *
496      * Returns the raw returned data. To convert to the expected return value,
497      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
498      *
499      * Requirements:
500      *
501      * - `target` must be a contract.
502      * - calling `target` with `data` must not revert.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
507       return functionCall(target, data, "Address: low-level call failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
512      * `errorMessage` as a fallback revert reason when `target` reverts.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
517         return _functionCallWithValue(target, data, 0, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but also transferring `value` wei to `target`.
523      *
524      * Requirements:
525      *
526      * - the calling contract must have an ETH balance of at least `value`.
527      * - the called Solidity function must be `payable`.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
532         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
537      * with `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
542         require(address(this).balance >= value, "Address: insufficient balance for call");
543         return _functionCallWithValue(target, data, value, errorMessage);
544     }
545 
546     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
547         require(isContract(target), "Address: call to non-contract");
548 
549         // solhint-disable-next-line avoid-low-level-calls
550         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
551         if (success) {
552             return returndata;
553         } else {
554             // Look for revert reason and bubble it up if present
555             if (returndata.length > 0) {
556                 // The easiest way to bubble the revert reason is using memory via assembly
557 
558                 // solhint-disable-next-line no-inline-assembly
559                 assembly {
560                     let returndata_size := mload(returndata)
561                     revert(add(32, returndata), returndata_size)
562                 }
563             } else {
564                 revert(errorMessage);
565             }
566         }
567     }
568 }
569 
570 /*
571  * @dev Provides information about the current execution context, including the
572  * sender of the transaction and its data. While these are generally available
573  * via msg.sender and msg.data, they should not be accessed in such a direct
574  * manner, since when dealing with GSN meta-transactions the account sending and
575  * paying for execution may not be the actual sender (as far as an application
576  * is concerned).
577  *
578  * This contract is only required for intermediate, library-like contracts.
579  */
580 abstract contract Context {
581     function _msgSender() internal view virtual returns (address payable) {
582         return msg.sender;
583     }
584 
585     function _msgData() internal view virtual returns (bytes memory) {
586         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
587         return msg.data;
588     }
589 }
590 
591 /**
592  * @dev Contract module that allows children to implement role-based access
593  * control mechanisms.
594  *
595  * Roles are referred to by their `bytes32` identifier. These should be exposed
596  * in the external API and be unique. The best way to achieve this is by
597  * using `public constant` hash digests:
598  *
599  * ```
600  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
601  * ```
602  *
603  * Roles can be used to represent a set of permissions. To restrict access to a
604  * function call, use {hasRole}:
605  *
606  * ```
607  * function foo() public {
608  *     require(hasRole(MY_ROLE, msg.sender));
609  *     ...
610  * }
611  * ```
612  *
613  * Roles can be granted and revoked dynamically via the {grantRole} and
614  * {revokeRole} functions. Each role has an associated admin role, and only
615  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
616  *
617  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
618  * that only accounts with this role will be able to grant or revoke other
619  * roles. More complex role relationships can be created by using
620  * {_setRoleAdmin}.
621  *
622  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
623  * grant and revoke this role. Extra precautions should be taken to secure
624  * accounts that have been granted it.
625  */
626 abstract contract AccessControl is Context {
627     using EnumerableSet for EnumerableSet.AddressSet;
628     using Address for address;
629 
630     struct RoleData {
631         EnumerableSet.AddressSet members;
632         bytes32 adminRole;
633     }
634 
635     mapping (bytes32 => RoleData) private _roles;
636 
637     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
638 
639     /**
640      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
641      *
642      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
643      * {RoleAdminChanged} not being emitted signaling this.
644      *
645      * _Available since v3.1._
646      */
647     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
648 
649     /**
650      * @dev Emitted when `account` is granted `role`.
651      *
652      * `sender` is the account that originated the contract call, an admin role
653      * bearer except when using {_setupRole}.
654      */
655     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
656 
657     /**
658      * @dev Emitted when `account` is revoked `role`.
659      *
660      * `sender` is the account that originated the contract call:
661      *   - if using `revokeRole`, it is the admin role bearer
662      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
663      */
664     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
665 
666     /**
667      * @dev Returns `true` if `account` has been granted `role`.
668      */
669     function hasRole(bytes32 role, address account) public view returns (bool) {
670         return _roles[role].members.contains(account);
671     }
672 
673     /**
674      * @dev Returns the number of accounts that have `role`. Can be used
675      * together with {getRoleMember} to enumerate all bearers of a role.
676      */
677     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
678         return _roles[role].members.length();
679     }
680 
681     /**
682      * @dev Returns one of the accounts that have `role`. `index` must be a
683      * value between 0 and {getRoleMemberCount}, non-inclusive.
684      *
685      * Role bearers are not sorted in any particular way, and their ordering may
686      * change at any point.
687      *
688      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
689      * you perform all queries on the same block. See the following
690      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
691      * for more information.
692      */
693     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
694         return _roles[role].members.at(index);
695     }
696 
697     /**
698      * @dev Returns the admin role that controls `role`. See {grantRole} and
699      * {revokeRole}.
700      *
701      * To change a role's admin, use {_setRoleAdmin}.
702      */
703     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
704         return _roles[role].adminRole;
705     }
706 
707     /**
708      * @dev Grants `role` to `account`.
709      *
710      * If `account` had not been already granted `role`, emits a {RoleGranted}
711      * event.
712      *
713      * Requirements:
714      *
715      * - the caller must have ``role``'s admin role.
716      */
717     function grantRole(bytes32 role, address account) public virtual {
718         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
719 
720         _grantRole(role, account);
721     }
722 
723     /**
724      * @dev Revokes `role` from `account`.
725      *
726      * If `account` had been granted `role`, emits a {RoleRevoked} event.
727      *
728      * Requirements:
729      *
730      * - the caller must have ``role``'s admin role.
731      */
732     function revokeRole(bytes32 role, address account) public virtual {
733         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
734 
735         _revokeRole(role, account);
736     }
737 
738     /**
739      * @dev Revokes `role` from the calling account.
740      *
741      * Roles are often managed via {grantRole} and {revokeRole}: this function's
742      * purpose is to provide a mechanism for accounts to lose their privileges
743      * if they are compromised (such as when a trusted device is misplaced).
744      *
745      * If the calling account had been granted `role`, emits a {RoleRevoked}
746      * event.
747      *
748      * Requirements:
749      *
750      * - the caller must be `account`.
751      */
752     function renounceRole(bytes32 role, address account) public virtual {
753         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
754 
755         _revokeRole(role, account);
756     }
757 
758     /**
759      * @dev Grants `role` to `account`.
760      *
761      * If `account` had not been already granted `role`, emits a {RoleGranted}
762      * event. Note that unlike {grantRole}, this function doesn't perform any
763      * checks on the calling account.
764      *
765      * [WARNING]
766      * ====
767      * This function should only be called from the constructor when setting
768      * up the initial roles for the system.
769      *
770      * Using this function in any other way is effectively circumventing the admin
771      * system imposed by {AccessControl}.
772      * ====
773      */
774     function _setupRole(bytes32 role, address account) internal virtual {
775         _grantRole(role, account);
776     }
777 
778     /**
779      * @dev Sets `adminRole` as ``role``'s admin role.
780      *
781      * Emits a {RoleAdminChanged} event.
782      */
783     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
784         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
785         _roles[role].adminRole = adminRole;
786     }
787 
788     function _grantRole(bytes32 role, address account) private {
789         if (_roles[role].members.add(account)) {
790             emit RoleGranted(role, account, _msgSender());
791         }
792     }
793 
794     function _revokeRole(bytes32 role, address account) private {
795         if (_roles[role].members.remove(account)) {
796             emit RoleRevoked(role, account, _msgSender());
797         }
798     }
799 }
800 
801 /**
802  * @dev Interface of the ERC20 standard as defined in the EIP.
803  */
804 interface IERC20 {
805     /**
806      * @dev Returns the amount of tokens in existence.
807      */
808     function totalSupply() external view returns (uint256);
809 
810     /**
811      * @dev Returns the amount of tokens owned by `account`.
812      */
813     function balanceOf(address account) external view returns (uint256);
814 
815     /**
816      * @dev Moves `amount` tokens from the caller's account to `recipient`.
817      *
818      * Returns a boolean value indicating whether the operation succeeded.
819      *
820      * Emits a {Transfer} event.
821      */
822     function transfer(address recipient, uint256 amount) external returns (bool);
823 
824     /**
825      * @dev Returns the remaining number of tokens that `spender` will be
826      * allowed to spend on behalf of `owner` through {transferFrom}. This is
827      * zero by default.
828      *
829      * This value changes when {approve} or {transferFrom} are called.
830      */
831     function allowance(address owner, address spender) external view returns (uint256);
832 
833     /**
834      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
835      *
836      * Returns a boolean value indicating whether the operation succeeded.
837      *
838      * IMPORTANT: Beware that changing an allowance with this method brings the risk
839      * that someone may use both the old and the new allowance by unfortunate
840      * transaction ordering. One possible solution to mitigate this race
841      * condition is to first reduce the spender's allowance to 0 and set the
842      * desired value afterwards:
843      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
844      *
845      * Emits an {Approval} event.
846      */
847     function approve(address spender, uint256 amount) external returns (bool);
848 
849     /**
850      * @dev Moves `amount` tokens from `sender` to `recipient` using the
851      * allowance mechanism. `amount` is then deducted from the caller's
852      * allowance.
853      *
854      * Returns a boolean value indicating whether the operation succeeded.
855      *
856      * Emits a {Transfer} event.
857      */
858     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
859 
860     /**
861      * @dev Emitted when `value` tokens are moved from one account (`from`) to
862      * another (`to`).
863      *
864      * Note that `value` may be zero.
865      */
866     event Transfer(address indexed from, address indexed to, uint256 value);
867 
868     /**
869      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
870      * a call to {approve}. `value` is the new allowance.
871      */
872     event Approval(address indexed owner, address indexed spender, uint256 value);
873 }
874 
875 /**
876  * @title SafeERC20
877  * @dev Wrappers around ERC20 operations that throw on failure (when the token
878  * contract returns false). Tokens that return no value (and instead revert or
879  * throw on failure) are also supported, non-reverting calls are assumed to be
880  * successful.
881  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
882  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
883  */
884 library SafeERC20 {
885     using SafeMath for uint256;
886     using Address for address;
887 
888     function safeTransfer(IERC20 token, address to, uint256 value) internal {
889         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
890     }
891 
892     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
893         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
894     }
895 
896     /**
897      * @dev Deprecated. This function has issues similar to the ones found in
898      * {IERC20-approve}, and its usage is discouraged.
899      *
900      * Whenever possible, use {safeIncreaseAllowance} and
901      * {safeDecreaseAllowance} instead.
902      */
903     function safeApprove(IERC20 token, address spender, uint256 value) internal {
904         // safeApprove should only be called when setting an initial allowance,
905         // or when resetting it to zero. To increase and decrease it, use
906         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
907         // solhint-disable-next-line max-line-length
908         require((value == 0) || (token.allowance(address(this), spender) == 0),
909             "SafeERC20: approve from non-zero to non-zero allowance"
910         );
911         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
912     }
913 
914     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
915         uint256 newAllowance = token.allowance(address(this), spender).add(value);
916         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
917     }
918 
919     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
920         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
921         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
922     }
923 
924     /**
925      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
926      * on the return value: the return value is optional (but if data is returned, it must not be false).
927      * @param token The token targeted by the call.
928      * @param data The call data (encoded using abi.encode or one of its variants).
929      */
930     function _callOptionalReturn(IERC20 token, bytes memory data) private {
931         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
932         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
933         // the target address contains contract code and also asserts for success in the low-level call.
934 
935         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
936         if (returndata.length > 0) { // Return data is optional
937             // solhint-disable-next-line max-line-length
938             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
939         }
940     }
941 }
942 
943 interface IUniswapV2Pair {
944     event Approval(address indexed owner, address indexed spender, uint value);
945     event Transfer(address indexed from, address indexed to, uint value);
946 
947     function name() external pure returns (string memory);
948     function symbol() external pure returns (string memory);
949     function decimals() external pure returns (uint8);
950     function totalSupply() external view returns (uint);
951     function balanceOf(address owner) external view returns (uint);
952     function allowance(address owner, address spender) external view returns (uint);
953 
954     function approve(address spender, uint value) external returns (bool);
955     function transfer(address to, uint value) external returns (bool);
956     function transferFrom(address from, address to, uint value) external returns (bool);
957 
958     function DOMAIN_SEPARATOR() external view returns (bytes32);
959     function PERMIT_TYPEHASH() external pure returns (bytes32);
960     function nonces(address owner) external view returns (uint);
961 
962     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
963 
964     event Mint(address indexed sender, uint amount0, uint amount1);
965     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
966     event Swap(
967         address indexed sender,
968         uint amount0In,
969         uint amount1In,
970         uint amount0Out,
971         uint amount1Out,
972         address indexed to
973     );
974     event Sync(uint112 reserve0, uint112 reserve1);
975 
976     function MINIMUM_LIQUIDITY() external pure returns (uint);
977     function factory() external view returns (address);
978     function token0() external view returns (address);
979     function token1() external view returns (address);
980     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
981     function price0CumulativeLast() external view returns (uint);
982     function price1CumulativeLast() external view returns (uint);
983     function kLast() external view returns (uint);
984 
985     function mint(address to) external returns (uint liquidity);
986     function burn(address to) external returns (uint amount0, uint amount1);
987     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
988     function skim(address to) external;
989     function sync() external;
990 
991     function initialize(address, address) external;
992 }
993 
994 contract Staking is AccessControl {
995   using SafeMath for uint256;
996   using SafeERC20 for IERC20;
997 
998   // Uniswap v2 YIELDProtocol/Other pair
999   IUniswapV2Pair public PAIR;
1000   // YIELDProtocol Token
1001   IERC20 public YIELD;
1002   // keccak256("DISTRIBUTER_ROLE")
1003   bytes32 public constant DISTRIBUTER_ROLE = 0x09630fffc1c31ed9c8dd68f6e39219ed189b07ff9a25e1efc743b828f69d555e;
1004 
1005   uint256 private s_totalSupply;
1006   uint256 private s_periodFinish;
1007   uint256 private s_rewardRate;
1008   uint256 private s_lastUpdateTime;
1009   uint256 private s_rewardPerTokenStored;
1010   uint256 private s_stakingLimit;
1011   uint256 private s_leftover;
1012   mapping(address => uint256) private s_balances;
1013   mapping(address => uint256) private s_userRewardPerTokenPaid;
1014   mapping(address => uint256) private s_rewards;
1015 
1016   event RewardAdded(address indexed distributer, uint256 reward, uint256 duration);
1017   event LeftoverCollected(address indexed distributer, uint256 amount);
1018   event Staked(address indexed user, uint256 amount);
1019   event Withdrawn(address indexed user, uint256 amount);
1020   event RewardPaid(address indexed user, uint256 reward);
1021 
1022   modifier updateReward(address account) {
1023     s_rewardPerTokenStored = rewardPerToken();
1024     uint256 lastTimeRewardApplicable = lastTimeRewardApplicable();
1025     if (s_totalSupply == 0) {
1026       s_leftover = s_leftover.add(lastTimeRewardApplicable.sub(s_lastUpdateTime).mul(s_rewardRate));
1027     }
1028     s_lastUpdateTime = lastTimeRewardApplicable;
1029     if (account != address(0)) {
1030       s_rewards[account] = earned(account);
1031       s_userRewardPerTokenPaid[account] = s_rewardPerTokenStored;
1032     }
1033     _;
1034   }
1035 
1036   modifier onlyDistributer() {
1037     require(hasRole(DISTRIBUTER_ROLE, msg.sender), "Staking: Caller is not a distributer");
1038     _;
1039   }
1040 
1041   constructor (address pair, address yield) public {
1042     _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1043     _setupRole(DISTRIBUTER_ROLE, msg.sender);
1044     PAIR = IUniswapV2Pair(pair);
1045     YIELD = IERC20(yield);
1046     s_stakingLimit = 7e18;
1047     require(address(PAIR).isContract(), "Staking: pair is not a contract");
1048     require(address(YIELD).isContract(), "Staking: YIELD is not a contract");
1049     require(address(PAIR) != address(YIELD), "Staking: pair and YIELD are the same");
1050   }
1051 
1052   receive() external payable {
1053     require(false, "Staking: not aceepting ether");
1054   }
1055 
1056   function setStakingLimit(uint256 other) external onlyDistributer() {
1057     s_stakingLimit = other;
1058   }
1059 
1060   function addReward(address from, uint256 amount, uint256 duration) external onlyDistributer() updateReward(address(0)) {
1061     require(amount > duration, 'Staking: Cannot approve less than 1');
1062     uint256 newRate = amount.div(duration);
1063     if(now < s_periodFinish)
1064       amount = amount.sub(s_periodFinish.sub(now).mul(s_rewardRate));
1065     s_rewardRate = newRate;
1066     s_lastUpdateTime = now;
1067     s_periodFinish = now.add(duration);
1068     YIELD.safeTransferFrom(from, address(this), amount);
1069     emit RewardAdded(msg.sender, amount, duration);
1070   }
1071 
1072   function collectLeftover() external onlyDistributer() updateReward(address(0)) {
1073     uint256 balance = YIELD.balanceOf(address(this));
1074     uint256 amount = Math.min(s_leftover, balance);
1075     s_leftover = 0;
1076     YIELD.safeTransfer(msg.sender, amount);
1077     emit LeftoverCollected(msg.sender, amount);
1078   }
1079 
1080   function stake(uint256 amount) external updateReward(msg.sender) {
1081     require(amount > 0, "Staking: cannot stake 0");
1082     require(amount <= pairLimit(msg.sender), "Staking: amount exceeds limit");
1083     s_balances[msg.sender] = s_balances[msg.sender].add(amount);
1084     s_totalSupply = s_totalSupply.add(amount);
1085     IERC20(address(PAIR)).safeTransferFrom(msg.sender, address(this), amount);
1086     emit Staked(msg.sender, amount);
1087   }
1088 
1089   function exit() external {
1090     withdraw(s_balances[msg.sender]);
1091     getReward();
1092   }
1093 
1094   function withdraw(uint256 amount) public updateReward(msg.sender) {
1095     require(amount > 0, 'Staking: cannot withdraw 0');
1096     s_totalSupply = s_totalSupply.sub(amount);
1097     s_balances[msg.sender] = s_balances[msg.sender].sub(amount);
1098     IERC20(address(PAIR)).safeTransfer(msg.sender, amount);
1099     emit Withdrawn(msg.sender, amount);
1100   }
1101 
1102   function getReward() public updateReward(msg.sender) {
1103     uint256 reward = earned(msg.sender);
1104     if (reward > 0) {
1105       s_rewards[msg.sender] = 0;
1106       YIELD.safeTransfer(msg.sender, reward);
1107       emit RewardPaid(msg.sender, reward);
1108     }
1109   }
1110 
1111   function earned(address account) public view returns (uint256) {
1112     return
1113     (
1114       s_balances[account]
1115       .mul
1116       (
1117         rewardPerToken()
1118         .sub(s_userRewardPerTokenPaid[account])
1119       )
1120       .div(1e18)
1121       .add(s_rewards[account])
1122     );
1123   }
1124 
1125   function rewardPerToken() public view returns (uint256) {
1126     if (s_totalSupply == 0) {
1127       return s_rewardPerTokenStored;
1128     }
1129     return
1130       s_rewardPerTokenStored
1131       .add
1132       (
1133         lastTimeRewardApplicable()
1134         .sub(s_lastUpdateTime)
1135         .mul(s_rewardRate)
1136         .mul(1e18)
1137         .div(s_totalSupply)
1138       );
1139   }
1140 
1141   function lastTimeRewardApplicable() public view returns (uint256) {
1142     return Math.min(now, s_periodFinish);
1143   }
1144 
1145   function pairLimit(address account) public view returns (uint256) {
1146     (, uint256 other, uint256 totalSupply) = pairInfo();
1147     uint256 limit = totalSupply.mul(s_stakingLimit).div(other);
1148     uint256 balance = s_balances[account];
1149     return limit > balance ? limit - balance : 0;
1150   }
1151 
1152   function pairInfo() public view returns (uint256 yield, uint256 other, uint256 totalSupply) {
1153     totalSupply = PAIR.totalSupply();
1154     (uint256 reserves0, uint256 reserves1,) = PAIR.getReserves();
1155     (yield, other) = address(YIELD) == PAIR.token0() ? (reserves0, reserves1) : (reserves1, reserves0);
1156   }
1157 
1158   function pairOtherBalance(uint256 amount) external view returns (uint256) {
1159     (, uint256 other, uint256 totalSupply) = pairInfo();
1160     return other.mul(amount).div(totalSupply);
1161   }
1162 
1163   function pairYieldBalance(uint256 amount) external view returns (uint256) {
1164     (uint256 yield, , uint256 totalSupply) = pairInfo();
1165     return yield.mul(amount).div(totalSupply);
1166   }
1167 
1168   function totalSupply() external view returns (uint256) {
1169     return s_totalSupply;
1170   }
1171 
1172   function periodFinish() external view returns (uint256) {
1173     return s_periodFinish;
1174   }
1175 
1176   function rewardRate() external view returns (uint256) {
1177     return s_rewardRate;
1178   }
1179 
1180   function lastUpdateTime() external view returns (uint256) {
1181     return s_lastUpdateTime;
1182   }
1183 
1184   function rewardPerTokenStored() external view returns (uint256) {
1185     return s_rewardPerTokenStored;
1186   }
1187 
1188   function balanceOf(address account) external view returns (uint256) {
1189     return s_balances[account];
1190   }
1191 
1192   function userRewardPerTokenPaid(address account) external view returns (uint256) {
1193     return s_userRewardPerTokenPaid[account];
1194   }
1195 
1196   function rewards(address account) external view returns (uint256) {
1197     return s_rewards[account];
1198   }
1199 
1200   function stakingLimit() external view returns (uint256) {
1201     return s_stakingLimit;
1202   }
1203 
1204   function leftover() external view returns (uint256) {
1205     return s_leftover;
1206   }
1207 
1208 }