1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.12;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/math/SafeMath.sol
29 
30 
31 
32 
33 
34 /**
35  * @dev Wrappers over Solidity's arithmetic operations with added overflow
36  * checks.
37  *
38  * Arithmetic operations in Solidity wrap on overflow. This can easily result
39  * in bugs, because programmers usually assume that an overflow raises an
40  * error, which is the standard behavior in high level programming languages.
41  * `SafeMath` restores this intuition by reverting the transaction when an
42  * operation overflows.
43  *
44  * Using this library instead of the unchecked operations eliminates an entire
45  * class of bugs, so it's recommended to use it always.
46  */
47 library SafeMath {
48     /**
49      * @dev Returns the addition of two unsigned integers, reverting on
50      * overflow.
51      *
52      * Counterpart to Solidity's `+` operator.
53      *
54      * Requirements:
55      *
56      * - Addition cannot overflow.
57      */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting on
67      * overflow (when the result is negative).
68      *
69      * Counterpart to Solidity's `-` operator.
70      *
71      * Requirements:
72      *
73      * - Subtraction cannot overflow.
74      */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     /**
80      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
81      * overflow (when the result is negative).
82      *
83      * Counterpart to Solidity's `-` operator.
84      *
85      * Requirements:
86      *
87      * - Subtraction cannot overflow.
88      */
89     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b <= a, errorMessage);
91         uint256 c = a - b;
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the multiplication of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `*` operator.
101      *
102      * Requirements:
103      *
104      * - Multiplication cannot overflow.
105      */
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108         // benefit is lost if 'b' is also tested.
109         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the integer division of two unsigned integers. Reverts on
122      * division by zero. The result is rounded towards zero.
123      *
124      * Counterpart to Solidity's `/` operator. Note: this function uses a
125      * `revert` opcode (which leaves remaining gas untouched) while Solidity
126      * uses an invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      *
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b > 0, errorMessage);
150         uint256 c = a / b;
151         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * Reverts when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      *
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return mod(a, b, "SafeMath: modulo by zero");
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts with custom message when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
191 
192 
193 
194 
195 
196 /**
197  * @dev Contract module that helps prevent reentrant calls to a function.
198  *
199  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
200  * available, which can be applied to functions to make sure there are no nested
201  * (reentrant) calls to them.
202  *
203  * Note that because there is a single `nonReentrant` guard, functions marked as
204  * `nonReentrant` may not call one another. This can be worked around by making
205  * those functions `private`, and then adding `external` `nonReentrant` entry
206  * points to them.
207  *
208  * TIP: If you would like to learn more about reentrancy and alternative ways
209  * to protect against it, check out our blog post
210  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
211  */
212 contract ReentrancyGuard {
213     // Booleans are more expensive than uint256 or any type that takes up a full
214     // word because each write operation emits an extra SLOAD to first read the
215     // slot's contents, replace the bits taken up by the boolean, and then write
216     // back. This is the compiler's defense against contract upgrades and
217     // pointer aliasing, and it cannot be disabled.
218 
219     // The values being non-zero value makes deployment a bit more expensive,
220     // but in exchange the refund on every call to nonReentrant will be lower in
221     // amount. Since refunds are capped to a percentage of the total
222     // transaction's gas, it is best to keep them low in cases like this one, to
223     // increase the likelihood of the full refund coming into effect.
224     uint256 private constant _NOT_ENTERED = 1;
225     uint256 private constant _ENTERED = 2;
226 
227     uint256 private _status;
228 
229     constructor () internal {
230         _status = _NOT_ENTERED;
231     }
232 
233     /**
234      * @dev Prevents a contract from calling itself, directly or indirectly.
235      * Calling a `nonReentrant` function from another `nonReentrant`
236      * function is not supported. It is possible to prevent this from happening
237      * by making the `nonReentrant` function external, and make it call a
238      * `private` function that does the actual work.
239      */
240     modifier nonReentrant() {
241         // On the first call to nonReentrant, _notEntered will be true
242         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
243 
244         // Any calls to nonReentrant after this point will fail
245         _status = _ENTERED;
246 
247         _;
248 
249         // By storing the original value once again, a refund is triggered (see
250         // https://eips.ethereum.org/EIPS/eip-2200)
251         _status = _NOT_ENTERED;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/utils/Address.sol
256 
257 
258 
259 pragma solidity ^0.6.2;
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // This method relies in extcodesize, which returns 0 for contracts in
284         // construction, since the code is only stored at the end of the
285         // constructor execution.
286 
287         uint256 size;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { size := extcodesize(account) }
290         return size > 0;
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336       return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         return _functionCallWithValue(target, data, value, errorMessage);
373     }
374 
375     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 // solhint-disable-next-line no-inline-assembly
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
400 
401 
402 
403 
404 
405 /**
406  * @dev Library for managing
407  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
408  * types.
409  *
410  * Sets have the following properties:
411  *
412  * - Elements are added, removed, and checked for existence in constant time
413  * (O(1)).
414  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
415  *
416  * ```
417  * contract Example {
418  *     // Add the library methods
419  *     using EnumerableSet for EnumerableSet.AddressSet;
420  *
421  *     // Declare a set state variable
422  *     EnumerableSet.AddressSet private mySet;
423  * }
424  * ```
425  *
426  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
427  * (`UintSet`) are supported.
428  */
429 library EnumerableSet {
430     // To implement this library for multiple types with as little code
431     // repetition as possible, we write it in terms of a generic Set type with
432     // bytes32 values.
433     // The Set implementation uses private functions, and user-facing
434     // implementations (such as AddressSet) are just wrappers around the
435     // underlying Set.
436     // This means that we can only create new EnumerableSets for types that fit
437     // in bytes32.
438 
439     struct Set {
440         // Storage of set values
441         bytes32[] _values;
442 
443         // Position of the value in the `values` array, plus 1 because index 0
444         // means a value is not in the set.
445         mapping (bytes32 => uint256) _indexes;
446     }
447 
448     /**
449      * @dev Add a value to a set. O(1).
450      *
451      * Returns true if the value was added to the set, that is if it was not
452      * already present.
453      */
454     function _add(Set storage set, bytes32 value) private returns (bool) {
455         if (!_contains(set, value)) {
456             set._values.push(value);
457             // The value is stored at length-1, but we add 1 to all indexes
458             // and use 0 as a sentinel value
459             set._indexes[value] = set._values.length;
460             return true;
461         } else {
462             return false;
463         }
464     }
465 
466     /**
467      * @dev Removes a value from a set. O(1).
468      *
469      * Returns true if the value was removed from the set, that is if it was
470      * present.
471      */
472     function _remove(Set storage set, bytes32 value) private returns (bool) {
473         // We read and store the value's index to prevent multiple reads from the same storage slot
474         uint256 valueIndex = set._indexes[value];
475 
476         if (valueIndex != 0) { // Equivalent to contains(set, value)
477             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
478             // the array, and then remove the last element (sometimes called as 'swap and pop').
479             // This modifies the order of the array, as noted in {at}.
480 
481             uint256 toDeleteIndex = valueIndex - 1;
482             uint256 lastIndex = set._values.length - 1;
483 
484             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
485             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
486 
487             bytes32 lastvalue = set._values[lastIndex];
488 
489             // Move the last value to the index where the value to delete is
490             set._values[toDeleteIndex] = lastvalue;
491             // Update the index for the moved value
492             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
493 
494             // Delete the slot where the moved value was stored
495             set._values.pop();
496 
497             // Delete the index for the deleted slot
498             delete set._indexes[value];
499 
500             return true;
501         } else {
502             return false;
503         }
504     }
505 
506     /**
507      * @dev Returns true if the value is in the set. O(1).
508      */
509     function _contains(Set storage set, bytes32 value) private view returns (bool) {
510         return set._indexes[value] != 0;
511     }
512 
513     /**
514      * @dev Returns the number of values on the set. O(1).
515      */
516     function _length(Set storage set) private view returns (uint256) {
517         return set._values.length;
518     }
519 
520    /**
521     * @dev Returns the value stored at position `index` in the set. O(1).
522     *
523     * Note that there are no guarantees on the ordering of values inside the
524     * array, and it may change when more values are added or removed.
525     *
526     * Requirements:
527     *
528     * - `index` must be strictly less than {length}.
529     */
530     function _at(Set storage set, uint256 index) private view returns (bytes32) {
531         require(set._values.length > index, "EnumerableSet: index out of bounds");
532         return set._values[index];
533     }
534 
535     // AddressSet
536 
537     struct AddressSet {
538         Set _inner;
539     }
540 
541     /**
542      * @dev Add a value to a set. O(1).
543      *
544      * Returns true if the value was added to the set, that is if it was not
545      * already present.
546      */
547     function add(AddressSet storage set, address value) internal returns (bool) {
548         return _add(set._inner, bytes32(uint256(value)));
549     }
550 
551     /**
552      * @dev Removes a value from a set. O(1).
553      *
554      * Returns true if the value was removed from the set, that is if it was
555      * present.
556      */
557     function remove(AddressSet storage set, address value) internal returns (bool) {
558         return _remove(set._inner, bytes32(uint256(value)));
559     }
560 
561     /**
562      * @dev Returns true if the value is in the set. O(1).
563      */
564     function contains(AddressSet storage set, address value) internal view returns (bool) {
565         return _contains(set._inner, bytes32(uint256(value)));
566     }
567 
568     /**
569      * @dev Returns the number of values in the set. O(1).
570      */
571     function length(AddressSet storage set) internal view returns (uint256) {
572         return _length(set._inner);
573     }
574 
575    /**
576     * @dev Returns the value stored at position `index` in the set. O(1).
577     *
578     * Note that there are no guarantees on the ordering of values inside the
579     * array, and it may change when more values are added or removed.
580     *
581     * Requirements:
582     *
583     * - `index` must be strictly less than {length}.
584     */
585     function at(AddressSet storage set, uint256 index) internal view returns (address) {
586         return address(uint256(_at(set._inner, index)));
587     }
588 
589 
590     // UintSet
591 
592     struct UintSet {
593         Set _inner;
594     }
595 
596     /**
597      * @dev Add a value to a set. O(1).
598      *
599      * Returns true if the value was added to the set, that is if it was not
600      * already present.
601      */
602     function add(UintSet storage set, uint256 value) internal returns (bool) {
603         return _add(set._inner, bytes32(value));
604     }
605 
606     /**
607      * @dev Removes a value from a set. O(1).
608      *
609      * Returns true if the value was removed from the set, that is if it was
610      * present.
611      */
612     function remove(UintSet storage set, uint256 value) internal returns (bool) {
613         return _remove(set._inner, bytes32(value));
614     }
615 
616     /**
617      * @dev Returns true if the value is in the set. O(1).
618      */
619     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
620         return _contains(set._inner, bytes32(value));
621     }
622 
623     /**
624      * @dev Returns the number of values on the set. O(1).
625      */
626     function length(UintSet storage set) internal view returns (uint256) {
627         return _length(set._inner);
628     }
629 
630    /**
631     * @dev Returns the value stored at position `index` in the set. O(1).
632     *
633     * Note that there are no guarantees on the ordering of values inside the
634     * array, and it may change when more values are added or removed.
635     *
636     * Requirements:
637     *
638     * - `index` must be strictly less than {length}.
639     */
640     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
641         return uint256(_at(set._inner, index));
642     }
643 }
644 
645 // File: @openzeppelin/contracts/access/AccessControl.sol
646 
647 
648 
649 
650 
651 
652 
653 
654 /**
655  * @dev Contract module that allows children to implement role-based access
656  * control mechanisms.
657  *
658  * Roles are referred to by their `bytes32` identifier. These should be exposed
659  * in the external API and be unique. The best way to achieve this is by
660  * using `public constant` hash digests:
661  *
662  * ```
663  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
664  * ```
665  *
666  * Roles can be used to represent a set of permissions. To restrict access to a
667  * function call, use {hasRole}:
668  *
669  * ```
670  * function foo() public {
671  *     require(hasRole(MY_ROLE, msg.sender));
672  *     ...
673  * }
674  * ```
675  *
676  * Roles can be granted and revoked dynamically via the {grantRole} and
677  * {revokeRole} functions. Each role has an associated admin role, and only
678  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
679  *
680  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
681  * that only accounts with this role will be able to grant or revoke other
682  * roles. More complex role relationships can be created by using
683  * {_setRoleAdmin}.
684  *
685  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
686  * grant and revoke this role. Extra precautions should be taken to secure
687  * accounts that have been granted it.
688  */
689 abstract contract AccessControl is Context {
690     using EnumerableSet for EnumerableSet.AddressSet;
691     using Address for address;
692 
693     struct RoleData {
694         EnumerableSet.AddressSet members;
695         bytes32 adminRole;
696     }
697 
698     mapping (bytes32 => RoleData) private _roles;
699 
700     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
701 
702     /**
703      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
704      *
705      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
706      * {RoleAdminChanged} not being emitted signaling this.
707      *
708      * _Available since v3.1._
709      */
710     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
711 
712     /**
713      * @dev Emitted when `account` is granted `role`.
714      *
715      * `sender` is the account that originated the contract call, an admin role
716      * bearer except when using {_setupRole}.
717      */
718     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
719 
720     /**
721      * @dev Emitted when `account` is revoked `role`.
722      *
723      * `sender` is the account that originated the contract call:
724      *   - if using `revokeRole`, it is the admin role bearer
725      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
726      */
727     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
728 
729     /**
730      * @dev Returns `true` if `account` has been granted `role`.
731      */
732     function hasRole(bytes32 role, address account) public view returns (bool) {
733         return _roles[role].members.contains(account);
734     }
735 
736     /**
737      * @dev Returns the number of accounts that have `role`. Can be used
738      * together with {getRoleMember} to enumerate all bearers of a role.
739      */
740     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
741         return _roles[role].members.length();
742     }
743 
744     /**
745      * @dev Returns one of the accounts that have `role`. `index` must be a
746      * value between 0 and {getRoleMemberCount}, non-inclusive.
747      *
748      * Role bearers are not sorted in any particular way, and their ordering may
749      * change at any point.
750      *
751      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
752      * you perform all queries on the same block. See the following
753      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
754      * for more information.
755      */
756     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
757         return _roles[role].members.at(index);
758     }
759 
760     /**
761      * @dev Returns the admin role that controls `role`. See {grantRole} and
762      * {revokeRole}.
763      *
764      * To change a role's admin, use {_setRoleAdmin}.
765      */
766     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
767         return _roles[role].adminRole;
768     }
769 
770     /**
771      * @dev Grants `role` to `account`.
772      *
773      * If `account` had not been already granted `role`, emits a {RoleGranted}
774      * event.
775      *
776      * Requirements:
777      *
778      * - the caller must have ``role``'s admin role.
779      */
780     function grantRole(bytes32 role, address account) public virtual {
781         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
782 
783         _grantRole(role, account);
784     }
785 
786     /**
787      * @dev Revokes `role` from `account`.
788      *
789      * If `account` had been granted `role`, emits a {RoleRevoked} event.
790      *
791      * Requirements:
792      *
793      * - the caller must have ``role``'s admin role.
794      */
795     function revokeRole(bytes32 role, address account) public virtual {
796         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
797 
798         _revokeRole(role, account);
799     }
800 
801     /**
802      * @dev Revokes `role` from the calling account.
803      *
804      * Roles are often managed via {grantRole} and {revokeRole}: this function's
805      * purpose is to provide a mechanism for accounts to lose their privileges
806      * if they are compromised (such as when a trusted device is misplaced).
807      *
808      * If the calling account had been granted `role`, emits a {RoleRevoked}
809      * event.
810      *
811      * Requirements:
812      *
813      * - the caller must be `account`.
814      */
815     function renounceRole(bytes32 role, address account) public virtual {
816         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
817 
818         _revokeRole(role, account);
819     }
820 
821     /**
822      * @dev Grants `role` to `account`.
823      *
824      * If `account` had not been already granted `role`, emits a {RoleGranted}
825      * event. Note that unlike {grantRole}, this function doesn't perform any
826      * checks on the calling account.
827      *
828      * [WARNING]
829      * ====
830      * This function should only be called from the constructor when setting
831      * up the initial roles for the system.
832      *
833      * Using this function in any other way is effectively circumventing the admin
834      * system imposed by {AccessControl}.
835      * ====
836      */
837     function _setupRole(bytes32 role, address account) internal virtual {
838         _grantRole(role, account);
839     }
840 
841     /**
842      * @dev Sets `adminRole` as ``role``'s admin role.
843      *
844      * Emits a {RoleAdminChanged} event.
845      */
846     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
847         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
848         _roles[role].adminRole = adminRole;
849     }
850 
851     function _grantRole(bytes32 role, address account) private {
852         if (_roles[role].members.add(account)) {
853             emit RoleGranted(role, account, _msgSender());
854         }
855     }
856 
857     function _revokeRole(bytes32 role, address account) private {
858         if (_roles[role].members.remove(account)) {
859             emit RoleRevoked(role, account, _msgSender());
860         }
861     }
862 }
863 
864 // File: contracts/DigitalaxAccessControls.sol
865 
866 
867 
868 pragma solidity 0.6.12;
869 
870 
871 /**
872  * @notice Access Controls contract for the Digitalax Platform
873  * @author BlockRocket.tech
874  */
875 contract DigitalaxAccessControls is AccessControl {
876     /// @notice Role definitions
877     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
878     bytes32 public constant SMART_CONTRACT_ROLE = keccak256("SMART_CONTRACT_ROLE");
879 
880     /// @notice Events for adding and removing various roles
881     event AdminRoleGranted(
882         address indexed beneficiary,
883         address indexed caller
884     );
885 
886     event AdminRoleRemoved(
887         address indexed beneficiary,
888         address indexed caller
889     );
890 
891     event MinterRoleGranted(
892         address indexed beneficiary,
893         address indexed caller
894     );
895 
896     event MinterRoleRemoved(
897         address indexed beneficiary,
898         address indexed caller
899     );
900 
901     event SmartContractRoleGranted(
902         address indexed beneficiary,
903         address indexed caller
904     );
905 
906     event SmartContractRoleRemoved(
907         address indexed beneficiary,
908         address indexed caller
909     );
910 
911     /**
912      * @notice The deployer is automatically given the admin role which will allow them to then grant roles to other addresses
913      */
914     constructor() public {
915         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
916     }
917 
918     /////////////
919     // Lookups //
920     /////////////
921 
922     /**
923      * @notice Used to check whether an address has the admin role
924      * @param _address EOA or contract being checked
925      * @return bool True if the account has the role or false if it does not
926      */
927     function hasAdminRole(address _address) external view returns (bool) {
928         return hasRole(DEFAULT_ADMIN_ROLE, _address);
929     }
930 
931     /**
932      * @notice Used to check whether an address has the minter role
933      * @param _address EOA or contract being checked
934      * @return bool True if the account has the role or false if it does not
935      */
936     function hasMinterRole(address _address) external view returns (bool) {
937         return hasRole(MINTER_ROLE, _address);
938     }
939 
940     /**
941      * @notice Used to check whether an address has the smart contract role
942      * @param _address EOA or contract being checked
943      * @return bool True if the account has the role or false if it does not
944      */
945     function hasSmartContractRole(address _address) external view returns (bool) {
946         return hasRole(SMART_CONTRACT_ROLE, _address);
947     }
948 
949     ///////////////
950     // Modifiers //
951     ///////////////
952 
953     /**
954      * @notice Grants the admin role to an address
955      * @dev The sender must have the admin role
956      * @param _address EOA or contract receiving the new role
957      */
958     function addAdminRole(address _address) external {
959         grantRole(DEFAULT_ADMIN_ROLE, _address);
960         emit AdminRoleGranted(_address, _msgSender());
961     }
962 
963     /**
964      * @notice Removes the admin role from an address
965      * @dev The sender must have the admin role
966      * @param _address EOA or contract affected
967      */
968     function removeAdminRole(address _address) external {
969         revokeRole(DEFAULT_ADMIN_ROLE, _address);
970         emit AdminRoleRemoved(_address, _msgSender());
971     }
972 
973     /**
974      * @notice Grants the minter role to an address
975      * @dev The sender must have the admin role
976      * @param _address EOA or contract receiving the new role
977      */
978     function addMinterRole(address _address) external {
979         grantRole(MINTER_ROLE, _address);
980         emit MinterRoleGranted(_address, _msgSender());
981     }
982 
983     /**
984      * @notice Removes the minter role from an address
985      * @dev The sender must have the admin role
986      * @param _address EOA or contract affected
987      */
988     function removeMinterRole(address _address) external {
989         revokeRole(MINTER_ROLE, _address);
990         emit MinterRoleRemoved(_address, _msgSender());
991     }
992 
993     /**
994      * @notice Grants the smart contract role to an address
995      * @dev The sender must have the admin role
996      * @param _address EOA or contract receiving the new role
997      */
998     function addSmartContractRole(address _address) external {
999         grantRole(SMART_CONTRACT_ROLE, _address);
1000         emit SmartContractRoleGranted(_address, _msgSender());
1001     }
1002 
1003     /**
1004      * @notice Removes the smart contract role from an address
1005      * @dev The sender must have the admin role
1006      * @param _address EOA or contract affected
1007      */
1008     function removeSmartContractRole(address _address) external {
1009         revokeRole(SMART_CONTRACT_ROLE, _address);
1010         emit SmartContractRoleRemoved(_address, _msgSender());
1011     }
1012 }
1013 
1014 // File: @openzeppelin/contracts/introspection/IERC165.sol
1015 
1016 
1017 
1018 
1019 
1020 /**
1021  * @dev Interface of the ERC165 standard, as defined in the
1022  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1023  *
1024  * Implementers can declare support of contract interfaces, which can then be
1025  * queried by others ({ERC165Checker}).
1026  *
1027  * For an implementation, see {ERC165}.
1028  */
1029 interface IERC165 {
1030     /**
1031      * @dev Returns true if this contract implements the interface defined by
1032      * `interfaceId`. See the corresponding
1033      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1034      * to learn more about how these ids are created.
1035      *
1036      * This function call must use less than 30 000 gas.
1037      */
1038     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1039 }
1040 
1041 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1042 
1043 
1044 
1045 pragma solidity ^0.6.2;
1046 
1047 
1048 /**
1049  * @dev Required interface of an ERC721 compliant contract.
1050  */
1051 interface IERC721 is IERC165 {
1052     /**
1053      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1054      */
1055     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1056 
1057     /**
1058      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1059      */
1060     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1061 
1062     /**
1063      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1064      */
1065     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1066 
1067     /**
1068      * @dev Returns the number of tokens in ``owner``'s account.
1069      */
1070     function balanceOf(address owner) external view returns (uint256 balance);
1071 
1072     /**
1073      * @dev Returns the owner of the `tokenId` token.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must exist.
1078      */
1079     function ownerOf(uint256 tokenId) external view returns (address owner);
1080 
1081     /**
1082      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1083      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1084      *
1085      * Requirements:
1086      *
1087      * - `from` cannot be the zero address.
1088      * - `to` cannot be the zero address.
1089      * - `tokenId` token must exist and be owned by `from`.
1090      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1091      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1096 
1097     /**
1098      * @dev Transfers `tokenId` token from `from` to `to`.
1099      *
1100      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1101      *
1102      * Requirements:
1103      *
1104      * - `from` cannot be the zero address.
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must be owned by `from`.
1107      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function transferFrom(address from, address to, uint256 tokenId) external;
1112 
1113     /**
1114      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1115      * The approval is cleared when the token is transferred.
1116      *
1117      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1118      *
1119      * Requirements:
1120      *
1121      * - The caller must own the token or be an approved operator.
1122      * - `tokenId` must exist.
1123      *
1124      * Emits an {Approval} event.
1125      */
1126     function approve(address to, uint256 tokenId) external;
1127 
1128     /**
1129      * @dev Returns the account approved for `tokenId` token.
1130      *
1131      * Requirements:
1132      *
1133      * - `tokenId` must exist.
1134      */
1135     function getApproved(uint256 tokenId) external view returns (address operator);
1136 
1137     /**
1138      * @dev Approve or remove `operator` as an operator for the caller.
1139      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1140      *
1141      * Requirements:
1142      *
1143      * - The `operator` cannot be the caller.
1144      *
1145      * Emits an {ApprovalForAll} event.
1146      */
1147     function setApprovalForAll(address operator, bool _approved) external;
1148 
1149     /**
1150      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1151      *
1152      * See {setApprovalForAll}
1153      */
1154     function isApprovedForAll(address owner, address operator) external view returns (bool);
1155 
1156     /**
1157       * @dev Safely transfers `tokenId` token from `from` to `to`.
1158       *
1159       * Requirements:
1160       *
1161      * - `from` cannot be the zero address.
1162      * - `to` cannot be the zero address.
1163       * - `tokenId` token must exist and be owned by `from`.
1164       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1165       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1166       *
1167       * Emits a {Transfer} event.
1168       */
1169     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1170 }
1171 
1172 // File: contracts/garment/IDigitalaxGarmentNFT.sol
1173 
1174 
1175 
1176 pragma solidity 0.6.12;
1177 
1178 
1179 interface IDigitalaxGarmentNFT is IERC721 {
1180     function isApproved(uint256 _tokenId, address _operator) external view returns (bool);
1181     function setPrimarySalePrice(uint256 _tokenId, uint256 _salePrice) external;
1182     function garmentDesigners(uint256 _tokenId) external view returns (address);
1183 }
1184 
1185 // File: contracts/DigitalaxAuction.sol
1186 
1187 
1188 
1189 pragma solidity 0.6.12;
1190 
1191 
1192 
1193 
1194 
1195 
1196 
1197 /**
1198  * @notice Primary sale auction contract for Digitalax NFTs
1199  */
1200 contract DigitalaxAuction is Context, ReentrancyGuard {
1201     using SafeMath for uint256;
1202     using Address for address payable;
1203 
1204     /// @notice Event emitted only on construction. To be used by indexers
1205     event DigitalaxAuctionContractDeployed();
1206 
1207     event PauseToggled(
1208         bool isPaused
1209     );
1210 
1211     event AuctionCreated(
1212         uint256 indexed garmentTokenId
1213     );
1214 
1215     event UpdateAuctionEndTime(
1216         uint256 indexed garmentTokenId,
1217         uint256 endTime
1218     );
1219 
1220     event UpdateAuctionStartTime(
1221         uint256 indexed garmentTokenId,
1222         uint256 startTime
1223     );
1224 
1225     event UpdateAuctionReservePrice(
1226         uint256 indexed garmentTokenId,
1227         uint256 reservePrice
1228     );
1229 
1230     event UpdateAccessControls(
1231         address indexed accessControls
1232     );
1233 
1234     event UpdatePlatformFee(
1235         uint256 platformFee
1236     );
1237 
1238     event UpdatePlatformFeeRecipient(
1239         address payable platformFeeRecipient
1240     );
1241 
1242     event UpdateMinBidIncrement(
1243         uint256 minBidIncrement
1244     );
1245 
1246     event UpdateBidWithdrawalLockTime(
1247         uint256 bidWithdrawalLockTime
1248     );
1249 
1250     event BidPlaced(
1251         uint256 indexed garmentTokenId,
1252         address indexed bidder,
1253         uint256 bid
1254     );
1255 
1256     event BidWithdrawn(
1257         uint256 indexed garmentTokenId,
1258         address indexed bidder,
1259         uint256 bid
1260     );
1261 
1262     event BidRefunded(
1263         address indexed bidder,
1264         uint256 bid
1265     );
1266 
1267     event AuctionResulted(
1268         uint256 indexed garmentTokenId,
1269         address indexed winner,
1270         uint256 winningBid
1271     );
1272 
1273     event AuctionCancelled(
1274         uint256 indexed garmentTokenId
1275     );
1276 
1277     /// @notice Parameters of an auction
1278     struct Auction {
1279         uint256 reservePrice;
1280         uint256 startTime;
1281         uint256 endTime;
1282         bool resulted;
1283     }
1284 
1285     /// @notice Information about the sender that placed a bit on an auction
1286     struct HighestBid {
1287         address payable bidder;
1288         uint256 bid;
1289         uint256 lastBidTime;
1290     }
1291 
1292     /// @notice Garment ERC721 Token ID -> Auction Parameters
1293     mapping(uint256 => Auction) public auctions;
1294 
1295     /// @notice Garment ERC721 Token ID -> highest bidder info (if a bid has been received)
1296     mapping(uint256 => HighestBid) public highestBids;
1297 
1298     /// @notice Garment ERC721 NFT - the only NFT that can be auctioned in this contract
1299     IDigitalaxGarmentNFT public garmentNft;
1300 
1301     // @notice responsible for enforcing admin access
1302     DigitalaxAccessControls public accessControls;
1303 
1304     /// @notice globally and across all auctions, the amount by which a bid has to increase
1305     uint256 public minBidIncrement = 0.1 ether;
1306 
1307     /// @notice global bid withdrawal lock time
1308     uint256 public bidWithdrawalLockTime = 20 minutes;
1309 
1310     /// @notice global platform fee, assumed to always be to 1 decimal place i.e. 120 = 12.0%
1311     uint256 public platformFee = 120;
1312 
1313     /// @notice where to send platform fee funds to
1314     address payable public platformFeeRecipient;
1315 
1316     /// @notice for switching off auction creations, bids and withdrawals
1317     bool public isPaused;
1318 
1319     modifier whenNotPaused() {
1320         require(!isPaused, "Function is currently paused");
1321         _;
1322     }
1323 
1324     constructor(
1325         DigitalaxAccessControls _accessControls,
1326         IDigitalaxGarmentNFT _garmentNft,
1327         address payable _platformFeeRecipient
1328     ) public {
1329         require(address(_accessControls) != address(0), "DigitalaxAuction: Invalid Access Controls");
1330         require(address(_garmentNft) != address(0), "DigitalaxAuction: Invalid NFT");
1331         require(_platformFeeRecipient != address(0), "DigitalaxAuction: Invalid Platform Fee Recipient");
1332 
1333         accessControls = _accessControls;
1334         garmentNft = _garmentNft;
1335         platformFeeRecipient = _platformFeeRecipient;
1336 
1337         emit DigitalaxAuctionContractDeployed();
1338     }
1339 
1340     /**
1341      @notice Creates a new auction for a given garment
1342      @dev Only the owner of a garment can create an auction and must have approved the contract
1343      @dev In addition to owning the garment, the sender also has to have the MINTER role.
1344      @dev End time for the auction must be in the future.
1345      @param _garmentTokenId Token ID of the garment being auctioned
1346      @param _reservePrice Garment cannot be sold for less than this or minBidIncrement, whichever is higher
1347      @param _startTimestamp Unix epoch in seconds for the auction start time
1348      @param _endTimestamp Unix epoch in seconds for the auction end time.
1349      */
1350     function createAuction(
1351         uint256 _garmentTokenId,
1352         uint256 _reservePrice,
1353         uint256 _startTimestamp,
1354         uint256 _endTimestamp
1355     ) external whenNotPaused {
1356         // Ensure caller has privileges
1357         require(
1358             accessControls.hasMinterRole(_msgSender()),
1359             "DigitalaxAuction.createAuction: Sender must have the minter role"
1360         );
1361 
1362         // Check owner of the token is the creator and approved
1363         require(
1364             garmentNft.ownerOf(_garmentTokenId) == _msgSender() && garmentNft.isApproved(_garmentTokenId, address(this)),
1365             "DigitalaxAuction.createAuction: Not owner and or contract not approved"
1366         );
1367 
1368         _createAuction(
1369             _garmentTokenId,
1370             _reservePrice,
1371             _startTimestamp,
1372             _endTimestamp
1373         );
1374     }
1375 
1376     /**
1377      @notice Admin or smart contract can list approved Garments
1378      @dev Sender must have admin or smart contract role
1379      @dev Owner must have approved this contract for the garment or all garments they own
1380      @dev End time for the auction must be in the future.
1381      @param _garmentTokenId Token ID of the garment being auctioned
1382      @param _reservePrice Garment cannot be sold for less than this or minBidIncrement, whichever is higher
1383      @param _startTimestamp Unix epoch in seconds for the auction start time
1384      @param _endTimestamp Unix epoch in seconds for the auction end time.
1385      */
1386     function createAuctionOnBehalfOfOwner(
1387         uint256 _garmentTokenId,
1388         uint256 _reservePrice,
1389         uint256 _startTimestamp,
1390         uint256 _endTimestamp
1391     ) external {
1392         // Ensure caller has privileges
1393         require(
1394             accessControls.hasAdminRole(_msgSender()) || accessControls.hasSmartContractRole(_msgSender()),
1395             "DigitalaxAuction.createAuctionOnBehalfOfOwner: Sender must have admin or smart contract role"
1396         );
1397 
1398         require(
1399             garmentNft.isApproved(_garmentTokenId, address(this)),
1400             "DigitalaxAuction.createAuctionOnBehalfOfOwner: Cannot create an auction if you do not have approval"
1401         );
1402 
1403         _createAuction(
1404             _garmentTokenId,
1405             _reservePrice,
1406             _startTimestamp,
1407             _endTimestamp
1408         );
1409     }
1410 
1411     /**
1412      @notice Places a new bid, out bidding the existing bidder if found and criteria is reached
1413      @dev Only callable when the auction is open
1414      @dev Bids from smart contracts are prohibited to prevent griefing with always reverting receiver
1415      @param _garmentTokenId Token ID of the garment being auctioned
1416      */
1417     function placeBid(uint256 _garmentTokenId) external payable nonReentrant whenNotPaused {
1418         require(_msgSender().isContract() == false, "DigitalaxAuction.placeBid: No contracts permitted");
1419 
1420         // Check the auction to see if this is a valid bid
1421         Auction storage auction = auctions[_garmentTokenId];
1422 
1423         // Ensure auction is in flight
1424         require(
1425             _getNow() >= auction.startTime && _getNow() <= auction.endTime,
1426             "DigitalaxAuction.placeBid: Bidding outside of the auction window"
1427         );
1428 
1429         uint256 bidAmount = msg.value;
1430 
1431         // Ensure bid adheres to outbid increment and threshold
1432         HighestBid storage highestBid = highestBids[_garmentTokenId];
1433         uint256 minBidRequired = highestBid.bid.add(minBidIncrement);
1434         require(bidAmount >= minBidRequired, "DigitalaxAuction.placeBid: Failed to outbid highest bidder");
1435 
1436         // Refund existing top bidder if found
1437         if (highestBid.bidder != address(0)) {
1438             _refundHighestBidder(highestBid.bidder, highestBid.bid);
1439         }
1440 
1441         // assign top bidder and bid time
1442         highestBid.bidder = _msgSender();
1443         highestBid.bid = bidAmount;
1444         highestBid.lastBidTime = _getNow();
1445 
1446         emit BidPlaced(_garmentTokenId, _msgSender(), bidAmount);
1447     }
1448 
1449     /**
1450      @notice Given a sender who has the highest bid on a garment, allows them to withdraw their bid
1451      @dev Only callable by the existing top bidder
1452      @param _garmentTokenId Token ID of the garment being auctioned
1453      */
1454     function withdrawBid(uint256 _garmentTokenId) external nonReentrant whenNotPaused {
1455         HighestBid storage highestBid = highestBids[_garmentTokenId];
1456 
1457         // Ensure highest bidder is the caller
1458         require(highestBid.bidder == _msgSender(), "DigitalaxAuction.withdrawBid: You are not the highest bidder");
1459 
1460         // Check withdrawal after delay time
1461         require(
1462             _getNow() >= highestBid.lastBidTime.add(bidWithdrawalLockTime),
1463             "DigitalaxAuction.withdrawBid: Cannot withdraw until lock time has passed"
1464         );
1465 
1466         require(_getNow() < auctions[_garmentTokenId].endTime, "DigitalaxAuction.withdrawBid: Past auction end");
1467 
1468         uint256 previousBid = highestBid.bid;
1469 
1470         // Clean up the existing top bid
1471         delete highestBids[_garmentTokenId];
1472 
1473         // Refund the top bidder
1474         _refundHighestBidder(_msgSender(), previousBid);
1475 
1476         emit BidWithdrawn(_garmentTokenId, _msgSender(), previousBid);
1477     }
1478 
1479     //////////
1480     // Admin /
1481     //////////
1482 
1483     /**
1484      @notice Results a finished auction
1485      @dev Only admin or smart contract
1486      @dev Auction can only be resulted if there has been a bidder and reserve met.
1487      @dev If there have been no bids, the auction needs to be cancelled instead using `cancelAuction()`
1488      @param _garmentTokenId Token ID of the garment being auctioned
1489      */
1490     function resultAuction(uint256 _garmentTokenId) external nonReentrant {
1491         require(
1492             accessControls.hasAdminRole(_msgSender()) || accessControls.hasSmartContractRole(_msgSender()),
1493             "DigitalaxAuction.resultAuction: Sender must be admin or smart contract"
1494         );
1495 
1496         // Check the auction to see if it can be resulted
1497         Auction storage auction = auctions[_garmentTokenId];
1498 
1499         // Check the auction real
1500         require(auction.endTime > 0, "DigitalaxAuction.resultAuction: Auction does not exist");
1501 
1502         // Check the auction has ended
1503         require(_getNow() > auction.endTime, "DigitalaxAuction.resultAuction: The auction has not ended");
1504 
1505         // Ensure auction not already resulted
1506         require(!auction.resulted, "DigitalaxAuction.resultAuction: auction already resulted");
1507 
1508         // Ensure this contract is approved to move the token
1509         require(garmentNft.isApproved(_garmentTokenId, address(this)), "DigitalaxAuction.resultAuction: auction not approved");
1510 
1511         // Get info on who the highest bidder is
1512         HighestBid storage highestBid = highestBids[_garmentTokenId];
1513         address winner = highestBid.bidder;
1514         uint256 winningBid = highestBid.bid;
1515 
1516         // Ensure auction not already resulted
1517         require(winningBid >= auction.reservePrice, "DigitalaxAuction.resultAuction: reserve not reached");
1518 
1519         // Ensure there is a winner
1520         require(winner != address(0), "DigitalaxAuction.resultAuction: no open bids");
1521 
1522         // Result the auction
1523         auctions[_garmentTokenId].resulted = true;
1524 
1525         // Clean up the highest bid
1526         delete highestBids[_garmentTokenId];
1527 
1528         // Record the primary sale price for the garment
1529         garmentNft.setPrimarySalePrice(_garmentTokenId, winningBid);
1530 
1531         if (winningBid > auction.reservePrice) {
1532             // Work out total above the reserve
1533             uint256 aboveReservePrice = winningBid.sub(auction.reservePrice);
1534 
1535             // Work out platform fee from above reserve amount
1536             uint256 platformFeeAboveReserve = aboveReservePrice.mul(platformFee).div(1000);
1537 
1538             // Send platform fee
1539             (bool platformTransferSuccess,) = platformFeeRecipient.call{value : platformFeeAboveReserve}("");
1540             require(platformTransferSuccess, "DigitalaxAuction.resultAuction: Failed to send platform fee");
1541 
1542             // Send remaining to designer
1543             (bool designerTransferSuccess,) = garmentNft.garmentDesigners(_garmentTokenId).call{value : winningBid.sub(platformFeeAboveReserve)}("");
1544             require(designerTransferSuccess, "DigitalaxAuction.resultAuction: Failed to send the designer their royalties");
1545         } else {
1546             // Send all to the designer
1547             (bool designerTransferSuccess,) = garmentNft.garmentDesigners(_garmentTokenId).call{value : winningBid}("");
1548             require(designerTransferSuccess, "DigitalaxAuction.resultAuction: Failed to send the designer their royalties");
1549         }
1550 
1551         // Transfer the token to the winner
1552         garmentNft.safeTransferFrom(garmentNft.ownerOf(_garmentTokenId), winner, _garmentTokenId);
1553 
1554         emit AuctionResulted(_garmentTokenId, winner, winningBid);
1555     }
1556 
1557     /**
1558      @notice Cancels and inflight and un-resulted auctions, returning the funds to the top bidder if found
1559      @dev Only admin
1560      @param _garmentTokenId Token ID of the garment being auctioned
1561      */
1562     function cancelAuction(uint256 _garmentTokenId) external nonReentrant {
1563         // Admin only resulting function
1564         require(
1565             accessControls.hasAdminRole(_msgSender()) || accessControls.hasSmartContractRole(_msgSender()),
1566             "DigitalaxAuction.cancelAuction: Sender must be admin or smart contract"
1567         );
1568 
1569         // Check valid and not resulted
1570         Auction storage auction = auctions[_garmentTokenId];
1571 
1572         // Check auction is real
1573         require(auction.endTime > 0, "DigitalaxAuction.cancelAuction: Auction does not exist");
1574 
1575         // Check auction not already resulted
1576         require(!auction.resulted, "DigitalaxAuction.cancelAuction: auction already resulted");
1577 
1578         // refund existing top bidder if found
1579         HighestBid storage highestBid = highestBids[_garmentTokenId];
1580         if (highestBid.bidder != address(0)) {
1581             _refundHighestBidder(highestBid.bidder, highestBid.bid);
1582 
1583             // Clear up highest bid
1584             delete highestBids[_garmentTokenId];
1585         }
1586 
1587         // Remove auction and top bidder
1588         delete auctions[_garmentTokenId];
1589 
1590         emit AuctionCancelled(_garmentTokenId);
1591     }
1592 
1593     /**
1594      @notice Toggling the pause flag
1595      @dev Only admin
1596      */
1597     function toggleIsPaused() external {
1598         require(accessControls.hasAdminRole(_msgSender()), "DigitalaxAuction.toggleIsPaused: Sender must be admin");
1599         isPaused = !isPaused;
1600         emit PauseToggled(isPaused);
1601     }
1602 
1603     /**
1604      @notice Update the amount by which bids have to increase, across all auctions
1605      @dev Only admin
1606      @param _minBidIncrement New bid step in WEI
1607      */
1608     function updateMinBidIncrement(uint256 _minBidIncrement) external {
1609         require(accessControls.hasAdminRole(_msgSender()), "DigitalaxAuction.updateMinBidIncrement: Sender must be admin");
1610         minBidIncrement = _minBidIncrement;
1611         emit UpdateMinBidIncrement(_minBidIncrement);
1612     }
1613 
1614     /**
1615      @notice Update the global bid withdrawal lockout time
1616      @dev Only admin
1617      @param _bidWithdrawalLockTime New bid withdrawal lock time
1618      */
1619     function updateBidWithdrawalLockTime(uint256 _bidWithdrawalLockTime) external {
1620         require(accessControls.hasAdminRole(_msgSender()), "DigitalaxAuction.updateBidWithdrawalLockTime: Sender must be admin");
1621         bidWithdrawalLockTime = _bidWithdrawalLockTime;
1622         emit UpdateBidWithdrawalLockTime(_bidWithdrawalLockTime);
1623     }
1624 
1625     /**
1626      @notice Update the current reserve price for an auction
1627      @dev Only admin
1628      @dev Auction must exist
1629      @param _garmentTokenId Token ID of the garment being auctioned
1630      @param _reservePrice New Ether reserve price (WEI value)
1631      */
1632     function updateAuctionReservePrice(uint256 _garmentTokenId, uint256 _reservePrice) external {
1633         require(
1634             accessControls.hasAdminRole(_msgSender()),
1635             "DigitalaxAuction.updateAuctionReservePrice: Sender must be admin"
1636         );
1637 
1638         require(
1639             auctions[_garmentTokenId].endTime > 0,
1640             "DigitalaxAuction.updateAuctionReservePrice: No Auction exists"
1641         );
1642 
1643         auctions[_garmentTokenId].reservePrice = _reservePrice;
1644         emit UpdateAuctionReservePrice(_garmentTokenId, _reservePrice);
1645     }
1646 
1647     /**
1648      @notice Update the current start time for an auction
1649      @dev Only admin
1650      @dev Auction must exist
1651      @param _garmentTokenId Token ID of the garment being auctioned
1652      @param _startTime New start time (unix epoch in seconds)
1653      */
1654     function updateAuctionStartTime(uint256 _garmentTokenId, uint256 _startTime) external {
1655         require(
1656             accessControls.hasAdminRole(_msgSender()),
1657             "DigitalaxAuction.updateAuctionStartTime: Sender must be admin"
1658         );
1659 
1660         require(
1661             auctions[_garmentTokenId].endTime > 0,
1662             "DigitalaxAuction.updateAuctionStartTime: No Auction exists"
1663         );
1664 
1665         auctions[_garmentTokenId].startTime = _startTime;
1666         emit UpdateAuctionStartTime(_garmentTokenId, _startTime);
1667     }
1668 
1669     /**
1670      @notice Update the current end time for an auction
1671      @dev Only admin
1672      @dev Auction must exist
1673      @param _garmentTokenId Token ID of the garment being auctioned
1674      @param _endTimestamp New end time (unix epoch in seconds)
1675      */
1676     function updateAuctionEndTime(uint256 _garmentTokenId, uint256 _endTimestamp) external {
1677         require(
1678             accessControls.hasAdminRole(_msgSender()),
1679             "DigitalaxAuction.updateAuctionEndTime: Sender must be admin"
1680         );
1681         require(
1682             auctions[_garmentTokenId].endTime > 0,
1683             "DigitalaxAuction.updateAuctionEndTime: No Auction exists"
1684         );
1685         require(
1686             auctions[_garmentTokenId].startTime < _endTimestamp,
1687             "DigitalaxAuction.updateAuctionEndTime: End time must be greater than start"
1688         );
1689         require(
1690             _endTimestamp > _getNow(),
1691             "DigitalaxAuction.updateAuctionEndTime: End time passed. Nobody can bid"
1692         );
1693 
1694         auctions[_garmentTokenId].endTime = _endTimestamp;
1695         emit UpdateAuctionEndTime(_garmentTokenId, _endTimestamp);
1696     }
1697 
1698     /**
1699      @notice Method for updating the access controls contract used by the NFT
1700      @dev Only admin
1701      @param _accessControls Address of the new access controls contract (Cannot be zero address)
1702      */
1703     function updateAccessControls(DigitalaxAccessControls _accessControls) external {
1704         require(
1705             accessControls.hasAdminRole(_msgSender()),
1706             "DigitalaxAuction.updateAccessControls: Sender must be admin"
1707         );
1708 
1709         require(address(_accessControls) != address(0), "DigitalaxAuction.updateAccessControls: Zero Address");
1710 
1711         accessControls = _accessControls;
1712         emit UpdateAccessControls(address(_accessControls));
1713     }
1714 
1715     /**
1716      @notice Method for updating platform fee
1717      @dev Only admin
1718      @param _platformFee uint256 the platform fee to set
1719      */
1720     function updatePlatformFee(uint256 _platformFee) external {
1721         require(
1722             accessControls.hasAdminRole(_msgSender()),
1723             "DigitalaxAuction.updatePlatformFee: Sender must be admin"
1724         );
1725 
1726         platformFee = _platformFee;
1727         emit UpdatePlatformFee(_platformFee);
1728     }
1729 
1730     /**
1731      @notice Method for updating platform fee address
1732      @dev Only admin
1733      @param _platformFeeRecipient payable address the address to sends the funds to
1734      */
1735     function updatePlatformFeeRecipient(address payable _platformFeeRecipient) external {
1736         require(
1737             accessControls.hasAdminRole(_msgSender()),
1738             "DigitalaxAuction.updatePlatformFeeRecipient: Sender must be admin"
1739         );
1740 
1741         require(_platformFeeRecipient != address(0), "DigitalaxAuction.updatePlatformFeeRecipient: Zero address");
1742 
1743         platformFeeRecipient = _platformFeeRecipient;
1744         emit UpdatePlatformFeeRecipient(_platformFeeRecipient);
1745     }
1746 
1747     ///////////////
1748     // Accessors //
1749     ///////////////
1750 
1751     /**
1752      @notice Method for getting all info about the auction
1753      @param _garmentTokenId Token ID of the garment being auctioned
1754      */
1755     function getAuction(uint256 _garmentTokenId)
1756     external
1757     view
1758     returns (uint256 _reservePrice, uint256 _startTime, uint256 _endTime, bool _resulted) {
1759         Auction storage auction = auctions[_garmentTokenId];
1760         return (
1761         auction.reservePrice,
1762         auction.startTime,
1763         auction.endTime,
1764         auction.resulted
1765         );
1766     }
1767 
1768     /**
1769      @notice Method for getting all info about the highest bidder
1770      @param _garmentTokenId Token ID of the garment being auctioned
1771      */
1772     function getHighestBidder(uint256 _garmentTokenId) external view returns (
1773         address payable _bidder,
1774         uint256 _bid,
1775         uint256 _lastBidTime
1776     ) {
1777         HighestBid storage highestBid = highestBids[_garmentTokenId];
1778         return (
1779             highestBid.bidder,
1780             highestBid.bid,
1781             highestBid.lastBidTime
1782         );
1783     }
1784 
1785     /////////////////////////
1786     // Internal and Private /
1787     /////////////////////////
1788 
1789     function _getNow() internal virtual view returns (uint256) {
1790         return block.timestamp;
1791     }
1792 
1793     /**
1794      @notice Private method doing the heavy lifting of creating an auction
1795      @param _garmentTokenId Token ID of the garment being auctioned
1796      @param _reservePrice Garment cannot be sold for less than this or minBidIncrement, whichever is higher
1797      @param _startTimestamp Unix epoch in seconds for the auction start time
1798      @param _endTimestamp Unix epoch in seconds for the auction end time.
1799      */
1800     function _createAuction(
1801         uint256 _garmentTokenId,
1802         uint256 _reservePrice,
1803         uint256 _startTimestamp,
1804         uint256 _endTimestamp
1805     ) private {
1806         // Ensure a token cannot be re-listed if previously successfully sold
1807         require(auctions[_garmentTokenId].endTime == 0, "DigitalaxAuction.createAuction: Cannot relist");
1808 
1809         // Check end time not before start time and that end is in the future
1810         require(_endTimestamp > _startTimestamp, "DigitalaxAuction.createAuction: End time must be greater than start");
1811         require(_endTimestamp > _getNow(), "DigitalaxAuction.createAuction: End time passed. Nobody can bid.");
1812 
1813         // Setup the auction
1814         auctions[_garmentTokenId] = Auction({
1815         reservePrice : _reservePrice,
1816         startTime : _startTimestamp,
1817         endTime : _endTimestamp,
1818         resulted : false
1819         });
1820 
1821         emit AuctionCreated(_garmentTokenId);
1822     }
1823 
1824     /**
1825      @notice Used for sending back escrowed funds from a previous bid
1826      @param _currentHighestBidder Address of the last highest bidder
1827      @param _currentHighestBid Ether amount in WEI that the bidder sent when placing their bid
1828      */
1829     function _refundHighestBidder(address payable _currentHighestBidder, uint256 _currentHighestBid) private {
1830         // refund previous best (if bid exists)
1831         (bool successRefund,) = _currentHighestBidder.call{value : _currentHighestBid}("");
1832         require(successRefund, "DigitalaxAuction._refundHighestBidder: failed to refund previous bidder");
1833         emit BidRefunded(_currentHighestBidder, _currentHighestBid);
1834     }
1835 }