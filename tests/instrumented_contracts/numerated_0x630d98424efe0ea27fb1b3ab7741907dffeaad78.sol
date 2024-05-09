1 pragma solidity ^0.6.2;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations with added overflow
79  * checks.
80  *
81  * Arithmetic operations in Solidity wrap on overflow. This can easily result
82  * in bugs, because programmers usually assume that an overflow raises an
83  * error, which is the standard behavior in high level programming languages.
84  * `SafeMath` restores this intuition by reverting the transaction when an
85  * operation overflows.
86  *
87  * Using this library instead of the unchecked operations eliminates an entire
88  * class of bugs, so it's recommended to use it always.
89  */
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      *
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 /**
234  * @dev Library for managing
235  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
236  * types.
237  *
238  * Sets have the following properties:
239  *
240  * - Elements are added, removed, and checked for existence in constant time
241  * (O(1)).
242  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
243  *
244  * ```
245  * contract Example {
246  *     // Add the library methods
247  *     using EnumerableSet for EnumerableSet.AddressSet;
248  *
249  *     // Declare a set state variable
250  *     EnumerableSet.AddressSet private mySet;
251  * }
252  * ```
253  *
254  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
255  * (`UintSet`) are supported.
256  */
257 library EnumerableSet {
258     // To implement this library for multiple types with as little code
259     // repetition as possible, we write it in terms of a generic Set type with
260     // bytes32 values.
261     // The Set implementation uses private functions, and user-facing
262     // implementations (such as AddressSet) are just wrappers around the
263     // underlying Set.
264     // This means that we can only create new EnumerableSets for types that fit
265     // in bytes32.
266 
267     struct Set {
268         // Storage of set values
269         bytes32[] _values;
270 
271         // Position of the value in the `values` array, plus 1 because index 0
272         // means a value is not in the set.
273         mapping (bytes32 => uint256) _indexes;
274     }
275 
276     /**
277      * @dev Add a value to a set. O(1).
278      *
279      * Returns true if the value was added to the set, that is if it was not
280      * already present.
281      */
282     function _add(Set storage set, bytes32 value) private returns (bool) {
283         if (!_contains(set, value)) {
284             set._values.push(value);
285             // The value is stored at length-1, but we add 1 to all indexes
286             // and use 0 as a sentinel value
287             set._indexes[value] = set._values.length;
288             return true;
289         } else {
290             return false;
291         }
292     }
293 
294     /**
295      * @dev Removes a value from a set. O(1).
296      *
297      * Returns true if the value was removed from the set, that is if it was
298      * present.
299      */
300     function _remove(Set storage set, bytes32 value) private returns (bool) {
301         // We read and store the value's index to prevent multiple reads from the same storage slot
302         uint256 valueIndex = set._indexes[value];
303 
304         if (valueIndex != 0) { // Equivalent to contains(set, value)
305             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
306             // the array, and then remove the last element (sometimes called as 'swap and pop').
307             // This modifies the order of the array, as noted in {at}.
308 
309             uint256 toDeleteIndex = valueIndex - 1;
310             uint256 lastIndex = set._values.length - 1;
311 
312             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
313             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
314 
315             bytes32 lastvalue = set._values[lastIndex];
316 
317             // Move the last value to the index where the value to delete is
318             set._values[toDeleteIndex] = lastvalue;
319             // Update the index for the moved value
320             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
321 
322             // Delete the slot where the moved value was stored
323             set._values.pop();
324 
325             // Delete the index for the deleted slot
326             delete set._indexes[value];
327 
328             return true;
329         } else {
330             return false;
331         }
332     }
333 
334     /**
335      * @dev Returns true if the value is in the set. O(1).
336      */
337     function _contains(Set storage set, bytes32 value) private view returns (bool) {
338         return set._indexes[value] != 0;
339     }
340 
341     /**
342      * @dev Returns the number of values on the set. O(1).
343      */
344     function _length(Set storage set) private view returns (uint256) {
345         return set._values.length;
346     }
347 
348    /**
349     * @dev Returns the value stored at position `index` in the set. O(1).
350     *
351     * Note that there are no guarantees on the ordering of values inside the
352     * array, and it may change when more values are added or removed.
353     *
354     * Requirements:
355     *
356     * - `index` must be strictly less than {length}.
357     */
358     function _at(Set storage set, uint256 index) private view returns (bytes32) {
359         require(set._values.length > index, "EnumerableSet: index out of bounds");
360         return set._values[index];
361     }
362 
363     // AddressSet
364 
365     struct AddressSet {
366         Set _inner;
367     }
368 
369     /**
370      * @dev Add a value to a set. O(1).
371      *
372      * Returns true if the value was added to the set, that is if it was not
373      * already present.
374      */
375     function add(AddressSet storage set, address value) internal returns (bool) {
376         return _add(set._inner, bytes32(uint256(value)));
377     }
378 
379     /**
380      * @dev Removes a value from a set. O(1).
381      *
382      * Returns true if the value was removed from the set, that is if it was
383      * present.
384      */
385     function remove(AddressSet storage set, address value) internal returns (bool) {
386         return _remove(set._inner, bytes32(uint256(value)));
387     }
388 
389     /**
390      * @dev Returns true if the value is in the set. O(1).
391      */
392     function contains(AddressSet storage set, address value) internal view returns (bool) {
393         return _contains(set._inner, bytes32(uint256(value)));
394     }
395 
396     /**
397      * @dev Returns the number of values in the set. O(1).
398      */
399     function length(AddressSet storage set) internal view returns (uint256) {
400         return _length(set._inner);
401     }
402 
403    /**
404     * @dev Returns the value stored at position `index` in the set. O(1).
405     *
406     * Note that there are no guarantees on the ordering of values inside the
407     * array, and it may change when more values are added or removed.
408     *
409     * Requirements:
410     *
411     * - `index` must be strictly less than {length}.
412     */
413     function at(AddressSet storage set, uint256 index) internal view returns (address) {
414         return address(uint256(_at(set._inner, index)));
415     }
416 
417 
418     // UintSet
419 
420     struct UintSet {
421         Set _inner;
422     }
423 
424     /**
425      * @dev Add a value to a set. O(1).
426      *
427      * Returns true if the value was added to the set, that is if it was not
428      * already present.
429      */
430     function add(UintSet storage set, uint256 value) internal returns (bool) {
431         return _add(set._inner, bytes32(value));
432     }
433 
434     /**
435      * @dev Removes a value from a set. O(1).
436      *
437      * Returns true if the value was removed from the set, that is if it was
438      * present.
439      */
440     function remove(UintSet storage set, uint256 value) internal returns (bool) {
441         return _remove(set._inner, bytes32(value));
442     }
443 
444     /**
445      * @dev Returns true if the value is in the set. O(1).
446      */
447     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
448         return _contains(set._inner, bytes32(value));
449     }
450 
451     /**
452      * @dev Returns the number of values on the set. O(1).
453      */
454     function length(UintSet storage set) internal view returns (uint256) {
455         return _length(set._inner);
456     }
457 
458    /**
459     * @dev Returns the value stored at position `index` in the set. O(1).
460     *
461     * Note that there are no guarantees on the ordering of values inside the
462     * array, and it may change when more values are added or removed.
463     *
464     * Requirements:
465     *
466     * - `index` must be strictly less than {length}.
467     */
468     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
469         return uint256(_at(set._inner, index));
470     }
471 }
472 
473 /**
474  * @dev Collection of functions related to the address type
475  */
476 library Address {
477     /**
478      * @dev Returns true if `account` is a contract.
479      *
480      * [IMPORTANT]
481      * ====
482      * It is unsafe to assume that an address for which this function returns
483      * false is an externally-owned account (EOA) and not a contract.
484      *
485      * Among others, `isContract` will return false for the following
486      * types of addresses:
487      *
488      *  - an externally-owned account
489      *  - a contract in construction
490      *  - an address where a contract will be created
491      *  - an address where a contract lived, but was destroyed
492      * ====
493      */
494     function isContract(address account) internal view returns (bool) {
495         // This method relies in extcodesize, which returns 0 for contracts in
496         // construction, since the code is only stored at the end of the
497         // constructor execution.
498 
499         uint256 size;
500         // solhint-disable-next-line no-inline-assembly
501         assembly { size := extcodesize(account) }
502         return size > 0;
503     }
504 
505     /**
506      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
507      * `recipient`, forwarding all available gas and reverting on errors.
508      *
509      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
510      * of certain opcodes, possibly making contracts go over the 2300 gas limit
511      * imposed by `transfer`, making them unable to receive funds via
512      * `transfer`. {sendValue} removes this limitation.
513      *
514      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
515      *
516      * IMPORTANT: because control is transferred to `recipient`, care must be
517      * taken to not create reentrancy vulnerabilities. Consider using
518      * {ReentrancyGuard} or the
519      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
520      */
521     function sendValue(address payable recipient, uint256 amount) internal {
522         require(address(this).balance >= amount, "Address: insufficient balance");
523 
524         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
525         (bool success, ) = recipient.call{ value: amount }("");
526         require(success, "Address: unable to send value, recipient may have reverted");
527     }
528 
529     /**
530      * @dev Performs a Solidity function call using a low level `call`. A
531      * plain`call` is an unsafe replacement for a function call: use this
532      * function instead.
533      *
534      * If `target` reverts with a revert reason, it is bubbled up by this
535      * function (like regular Solidity function calls).
536      *
537      * Returns the raw returned data. To convert to the expected return value,
538      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
539      *
540      * Requirements:
541      *
542      * - `target` must be a contract.
543      * - calling `target` with `data` must not revert.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
548       return functionCall(target, data, "Address: low-level call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
553      * `errorMessage` as a fallback revert reason when `target` reverts.
554      *
555      * _Available since v3.1._
556      */
557     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
558         return _functionCallWithValue(target, data, 0, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but also transferring `value` wei to `target`.
564      *
565      * Requirements:
566      *
567      * - the calling contract must have an ETH balance of at least `value`.
568      * - the called Solidity function must be `payable`.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
578      * with `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
583         require(address(this).balance >= value, "Address: insufficient balance for call");
584         return _functionCallWithValue(target, data, value, errorMessage);
585     }
586 
587     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
588         require(isContract(target), "Address: call to non-contract");
589 
590         // solhint-disable-next-line avoid-low-level-calls
591         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
592         if (success) {
593             return returndata;
594         } else {
595             // Look for revert reason and bubble it up if present
596             if (returndata.length > 0) {
597                 // The easiest way to bubble the revert reason is using memory via assembly
598 
599                 // solhint-disable-next-line no-inline-assembly
600                 assembly {
601                     let returndata_size := mload(returndata)
602                     revert(add(32, returndata), returndata_size)
603                 }
604             } else {
605                 revert(errorMessage);
606             }
607         }
608     }
609 }
610 
611 /*
612  * @dev Provides information about the current execution context, including the
613  * sender of the transaction and its data. While these are generally available
614  * via msg.sender and msg.data, they should not be accessed in such a direct
615  * manner, since when dealing with GSN meta-transactions the account sending and
616  * paying for execution may not be the actual sender (as far as an application
617  * is concerned).
618  *
619  * This contract is only required for intermediate, library-like contracts.
620  */
621 abstract contract Context {
622     function _msgSender() internal view virtual returns (address payable) {
623         return msg.sender;
624     }
625 
626     function _msgData() internal view virtual returns (bytes memory) {
627         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
628         return msg.data;
629     }
630 }
631 
632 /**
633  * @dev Contract module that allows children to implement role-based access
634  * control mechanisms.
635  *
636  * Roles are referred to by their `bytes32` identifier. These should be exposed
637  * in the external API and be unique. The best way to achieve this is by
638  * using `public constant` hash digests:
639  *
640  * ```
641  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
642  * ```
643  *
644  * Roles can be used to represent a set of permissions. To restrict access to a
645  * function call, use {hasRole}:
646  *
647  * ```
648  * function foo() public {
649  *     require(hasRole(MY_ROLE, msg.sender));
650  *     ...
651  * }
652  * ```
653  *
654  * Roles can be granted and revoked dynamically via the {grantRole} and
655  * {revokeRole} functions. Each role has an associated admin role, and only
656  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
657  *
658  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
659  * that only accounts with this role will be able to grant or revoke other
660  * roles. More complex role relationships can be created by using
661  * {_setRoleAdmin}.
662  *
663  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
664  * grant and revoke this role. Extra precautions should be taken to secure
665  * accounts that have been granted it.
666  */
667 abstract contract AccessControl is Context {
668     using EnumerableSet for EnumerableSet.AddressSet;
669     using Address for address;
670 
671     struct RoleData {
672         EnumerableSet.AddressSet members;
673         bytes32 adminRole;
674     }
675 
676     mapping (bytes32 => RoleData) private _roles;
677 
678     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
679 
680     /**
681      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
682      *
683      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
684      * {RoleAdminChanged} not being emitted signaling this.
685      *
686      * _Available since v3.1._
687      */
688     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
689 
690     /**
691      * @dev Emitted when `account` is granted `role`.
692      *
693      * `sender` is the account that originated the contract call, an admin role
694      * bearer except when using {_setupRole}.
695      */
696     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
697 
698     /**
699      * @dev Emitted when `account` is revoked `role`.
700      *
701      * `sender` is the account that originated the contract call:
702      *   - if using `revokeRole`, it is the admin role bearer
703      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
704      */
705     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
706 
707     /**
708      * @dev Returns `true` if `account` has been granted `role`.
709      */
710     function hasRole(bytes32 role, address account) public view returns (bool) {
711         return _roles[role].members.contains(account);
712     }
713 
714     /**
715      * @dev Returns the number of accounts that have `role`. Can be used
716      * together with {getRoleMember} to enumerate all bearers of a role.
717      */
718     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
719         return _roles[role].members.length();
720     }
721 
722     /**
723      * @dev Returns one of the accounts that have `role`. `index` must be a
724      * value between 0 and {getRoleMemberCount}, non-inclusive.
725      *
726      * Role bearers are not sorted in any particular way, and their ordering may
727      * change at any point.
728      *
729      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
730      * you perform all queries on the same block. See the following
731      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
732      * for more information.
733      */
734     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
735         return _roles[role].members.at(index);
736     }
737 
738     /**
739      * @dev Returns the admin role that controls `role`. See {grantRole} and
740      * {revokeRole}.
741      *
742      * To change a role's admin, use {_setRoleAdmin}.
743      */
744     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
745         return _roles[role].adminRole;
746     }
747 
748     /**
749      * @dev Grants `role` to `account`.
750      *
751      * If `account` had not been already granted `role`, emits a {RoleGranted}
752      * event.
753      *
754      * Requirements:
755      *
756      * - the caller must have ``role``'s admin role.
757      */
758     function grantRole(bytes32 role, address account) public virtual {
759         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
760 
761         _grantRole(role, account);
762     }
763 
764     /**
765      * @dev Revokes `role` from `account`.
766      *
767      * If `account` had been granted `role`, emits a {RoleRevoked} event.
768      *
769      * Requirements:
770      *
771      * - the caller must have ``role``'s admin role.
772      */
773     function revokeRole(bytes32 role, address account) public virtual {
774         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
775 
776         _revokeRole(role, account);
777     }
778 
779     /**
780      * @dev Revokes `role` from the calling account.
781      *
782      * Roles are often managed via {grantRole} and {revokeRole}: this function's
783      * purpose is to provide a mechanism for accounts to lose their privileges
784      * if they are compromised (such as when a trusted device is misplaced).
785      *
786      * If the calling account had been granted `role`, emits a {RoleRevoked}
787      * event.
788      *
789      * Requirements:
790      *
791      * - the caller must be `account`.
792      */
793     function renounceRole(bytes32 role, address account) public virtual {
794         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
795 
796         _revokeRole(role, account);
797     }
798 
799     /**
800      * @dev Grants `role` to `account`.
801      *
802      * If `account` had not been already granted `role`, emits a {RoleGranted}
803      * event. Note that unlike {grantRole}, this function doesn't perform any
804      * checks on the calling account.
805      *
806      * [WARNING]
807      * ====
808      * This function should only be called from the constructor when setting
809      * up the initial roles for the system.
810      *
811      * Using this function in any other way is effectively circumventing the admin
812      * system imposed by {AccessControl}.
813      * ====
814      */
815     function _setupRole(bytes32 role, address account) internal virtual {
816         _grantRole(role, account);
817     }
818 
819     /**
820      * @dev Sets `adminRole` as ``role``'s admin role.
821      *
822      * Emits a {RoleAdminChanged} event.
823      */
824     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
825         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
826         _roles[role].adminRole = adminRole;
827     }
828 
829     function _grantRole(bytes32 role, address account) private {
830         if (_roles[role].members.add(account)) {
831             emit RoleGranted(role, account, _msgSender());
832         }
833     }
834 
835     function _revokeRole(bytes32 role, address account) private {
836         if (_roles[role].members.remove(account)) {
837             emit RoleRevoked(role, account, _msgSender());
838         }
839     }
840 }
841 
842 /**
843  * @dev Implementation of the {IERC20} interface.
844  *
845  * This implementation is agnostic to the way tokens are created. This means
846  * that a supply mechanism has to be added in a derived contract using {_mint}.
847  * For a generic mechanism see {ERC20PresetMinterPauser}.
848  *
849  * TIP: For a detailed writeup see our guide
850  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
851  * to implement supply mechanisms].
852  *
853  * We have followed general OpenZeppelin guidelines: functions revert instead
854  * of returning `false` on failure. This behavior is nonetheless conventional
855  * and does not conflict with the expectations of ERC20 applications.
856  *
857  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
858  * This allows applications to reconstruct the allowance for all accounts just
859  * by listening to said events. Other implementations of the EIP may not emit
860  * these events, as it isn't required by the specification.
861  *
862  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
863  * functions have been added to mitigate the well-known issues around setting
864  * allowances. See {IERC20-approve}.
865  */
866 contract ERC20 is AccessControl, IERC20 {
867     using SafeMath for uint256;
868     using Address for address;
869 
870     string private _name;
871     string private _symbol;
872     uint8 private _decimals;
873 
874     uint256 private _totalSupply;
875 
876     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
877 
878     mapping (address => uint256) private _balances;
879     mapping (address => mapping (address => uint256)) private _allowances;
880 
881     /**
882      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
883      * a default value of 18.
884      */
885     function _initialize(
886         string memory name,
887         string memory symbol,
888         uint8 decimals
889     ) internal {
890         _name = name;
891         _symbol = symbol;
892         _decimals = decimals;
893     }
894 
895     /**
896      * @dev Returns the name of the token.
897      */
898     function name() public view returns (string memory) {
899         return _name;
900     }
901 
902     /**
903      * @dev Returns the symbol of the token, usually a shorter version of the
904      * name.
905      */
906     function symbol() public view returns (string memory) {
907         return _symbol;
908     }
909 
910     /**
911      * @dev Returns the number of decimals used to get its user representation.
912      * For example, if `decimals` equals `2`, a balance of `505` tokens should
913      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
914      *
915      * NOTE: This information is only used for _display_ purposes: it in
916      * no way affects any of the arithmetic of the contract, including
917      * {IERC20-balanceOf} and {IERC20-transfer}.
918      */
919     function decimals() public view returns (uint8) {
920         return _decimals;
921     }
922 
923     /**
924      * @dev See {IERC20-totalSupply}.
925      */
926     function totalSupply() public view override returns (uint256) {
927         return _totalSupply;
928     }
929 
930     /**
931      * @dev See {IERC20-balanceOf}.
932      */
933     function balanceOf(address account) public view override returns (uint256) {
934         return _balances[account];
935     }
936 
937     /**
938      * @dev See {IERC20-transfer}.
939      *
940      * Requirements:
941      *
942      * - `recipient` cannot be the zero address.
943      * - the caller must have a balance of at least `amount`.
944      */
945     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
946         _transfer(_msgSender(), recipient, amount);
947         return true;
948     }
949 
950     /**
951      * @dev See {IERC20-allowance}.
952      */
953     function allowance(address owner, address spender) public view virtual override returns (uint256) {
954         return _allowances[owner][spender];
955     }
956 
957     /**
958      * @dev See {IERC20-approve}.
959      *
960      * Requirements:
961      *
962      * - `spender` cannot be the zero address.
963      */
964     function approve(address spender, uint256 amount) public virtual override returns (bool) {
965         _approve(_msgSender(), spender, amount);
966         return true;
967     }
968 
969     /**
970      * @dev See {IERC20-transferFrom}.
971      *
972      * Emits an {Approval} event indicating the updated allowance. This is not
973      * required by the EIP. See the note at the beginning of {ERC20};
974      *
975      * Requirements:
976      * - `sender` and `recipient` cannot be the zero address.
977      * - `sender` must have a balance of at least `amount`.
978      * - the caller must have allowance for ``sender``'s tokens of at least
979      * `amount`.
980      */
981     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
982         _transfer(sender, recipient, amount);
983         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
984         return true;
985     }
986 
987     /**
988      * @dev Atomically increases the allowance granted to `spender` by the caller.
989      *
990      * This is an alternative to {approve} that can be used as a mitigation for
991      * problems described in {IERC20-approve}.
992      *
993      * Emits an {Approval} event indicating the updated allowance.
994      *
995      * Requirements:
996      *
997      * - `spender` cannot be the zero address.
998      */
999     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1000         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1001         return true;
1002     }
1003 
1004     /**
1005      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1006      *
1007      * This is an alternative to {approve} that can be used as a mitigation for
1008      * problems described in {IERC20-approve}.
1009      *
1010      * Emits an {Approval} event indicating the updated allowance.
1011      *
1012      * Requirements:
1013      *
1014      * - `spender` cannot be the zero address.
1015      * - `spender` must have allowance for the caller of at least
1016      * `subtractedValue`.
1017      */
1018     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1019         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1020         return true;
1021     }
1022 
1023     /**
1024      * @dev Moves tokens `amount` from `sender` to `recipient`.
1025      *
1026      * This is internal function is equivalent to {transfer}, and can be used to
1027      * e.g. implement automatic token fees, slashing mechanisms, etc.
1028      *
1029      * Emits a {Transfer} event.
1030      *
1031      * Requirements:
1032      *
1033      * - `sender` cannot be the zero address.
1034      * - `recipient` cannot be the zero address.
1035      * - `sender` must have a balance of at least `amount`.
1036      */
1037     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1038         require(sender != address(0), "ERC20: transfer from the zero address");
1039         require(recipient != address(0), "ERC20: transfer to the zero address");
1040 
1041         _beforeTokenTransfer(sender, recipient, amount);
1042 
1043         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1044         _balances[recipient] = _balances[recipient].add(amount);
1045         emit Transfer(sender, recipient, amount);
1046     }
1047 
1048     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1049      * the total supply.
1050      *
1051      * Emits a {Transfer} event with `from` set to the zero address.
1052      *
1053      * Requirements
1054      *
1055      * - `to` cannot be the zero address.
1056      */
1057     function _mint(address account, uint256 amount) internal virtual {
1058         require(account != address(0), "ERC20: mint to the zero address");
1059 
1060         _beforeTokenTransfer(address(0), account, amount);
1061 
1062         _totalSupply = _totalSupply.add(amount);
1063         _balances[account] = _balances[account].add(amount);
1064         emit Transfer(address(0), account, amount);
1065     }
1066 
1067     /**
1068      * @dev Destroys `amount` tokens from `account`, reducing the
1069      * total supply.
1070      *
1071      * Emits a {Transfer} event with `to` set to the zero address.
1072      *
1073      * Requirements
1074      *
1075      * - `account` cannot be the zero address.
1076      * - `account` must have at least `amount` tokens.
1077      */
1078     function _burn(address account, uint256 amount) internal virtual {
1079         require(account != address(0), "ERC20: burn from the zero address");
1080 
1081         _beforeTokenTransfer(account, address(0), amount);
1082 
1083         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1084         _totalSupply = _totalSupply.sub(amount);
1085         emit Transfer(account, address(0), amount);
1086     }
1087 
1088     /**
1089      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1090      *
1091      * This is internal function is equivalent to `approve`, and can be used to
1092      * e.g. set automatic allowances for certain subsystems, etc.
1093      *
1094      * Emits an {Approval} event.
1095      *
1096      * Requirements:
1097      *
1098      * - `owner` cannot be the zero address.
1099      * - `spender` cannot be the zero address.
1100      */
1101     function _approve(address owner, address spender, uint256 amount) internal virtual {
1102         require(owner != address(0), "ERC20: approve from the zero address");
1103         require(spender != address(0), "ERC20: approve to the zero address");
1104 
1105         _allowances[owner][spender] = amount;
1106         emit Approval(owner, spender, amount);
1107     }
1108 
1109     /**
1110      * @dev Hook that is called before any transfer of tokens. This includes
1111      * minting and burning.
1112      *
1113      * Calling conditions:
1114      *
1115      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1116      * will be to transferred to `to`.
1117      * - when `from` is zero, `amount` tokens will be minted for `to`.
1118      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1119      * - `from` and `to` are never both zero.
1120      *
1121      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1122      */
1123     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1124 }
1125 
1126 /**
1127  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
1128  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
1129  * be specified by overriding the virtual {_implementation} function.
1130  * 
1131  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
1132  * different contract through the {_delegate} function.
1133  * 
1134  * The success and return data of the delegated call will be returned back to the caller of the proxy.
1135  */
1136 abstract contract Proxy {
1137     /**
1138      * @dev Delegates the current call to `implementation`.
1139      * 
1140      * This function does not return to its internall call site, it will return directly to the external caller.
1141      */
1142     function _delegate(address implementation) internal {
1143         // solhint-disable-next-line no-inline-assembly
1144         assembly {
1145             // Copy msg.data. We take full control of memory in this inline assembly
1146             // block because it will not return to Solidity code. We overwrite the
1147             // Solidity scratch pad at memory position 0.
1148             calldatacopy(0, 0, calldatasize())
1149 
1150             // Call the implementation.
1151             // out and outsize are 0 because we don't know the size yet.
1152             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
1153 
1154             // Copy the returned data.
1155             returndatacopy(0, 0, returndatasize())
1156 
1157             switch result
1158             // delegatecall returns 0 on error.
1159             case 0 { revert(0, returndatasize()) }
1160             default { return(0, returndatasize()) }
1161         }
1162     }
1163 
1164     /**
1165      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
1166      * and {_fallback} should delegate.
1167      */
1168     function _implementation() internal virtual view returns (address);
1169 
1170     /**
1171      * @dev Delegates the current call to the address returned by `_implementation()`.
1172      * 
1173      * This function does not return to its internall call site, it will return directly to the external caller.
1174      */
1175     function _fallback() internal {
1176         _beforeFallback();
1177         _delegate(_implementation());
1178     }
1179 
1180     /**
1181      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
1182      * function in the contract matches the call data.
1183      */
1184     fallback () payable external {
1185         _fallback();
1186     }
1187 
1188     /**
1189      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
1190      * is empty.
1191      */
1192     receive () payable external {
1193         _fallback();
1194     }
1195 
1196     /**
1197      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
1198      * call, or as part of the Solidity `fallback` or `receive` functions.
1199      * 
1200      * If overriden should call `super._beforeFallback()`.
1201      */
1202     function _beforeFallback() internal virtual {
1203     }
1204 }
1205 
1206 /**
1207  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
1208  * implementation address that can be changed. This address is stored in storage in the location specified by
1209  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
1210  * implementation behind the proxy.
1211  * 
1212  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
1213  * {TransparentUpgradeableProxy}.
1214  */
1215 contract UpgradeableProxy is Proxy {
1216     /**
1217      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
1218      * 
1219      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
1220      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
1221      */
1222     constructor(address _logic, bytes memory _data) public payable {
1223         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
1224         _setImplementation(_logic);
1225         if(_data.length > 0) {
1226             // solhint-disable-next-line avoid-low-level-calls
1227             (bool success,) = _logic.delegatecall(_data);
1228             require(success);
1229         }
1230     }
1231 
1232     /**
1233      * @dev Emitted when the implementation is upgraded.
1234      */
1235     event Upgraded(address indexed implementation);
1236 
1237     /**
1238      * @dev Storage slot with the address of the current implementation.
1239      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
1240      * validated in the constructor.
1241      */
1242     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
1243 
1244     /**
1245      * @dev Returns the current implementation address.
1246      */
1247     function _implementation() internal override view returns (address impl) {
1248         bytes32 slot = _IMPLEMENTATION_SLOT;
1249         // solhint-disable-next-line no-inline-assembly
1250         assembly {
1251             impl := sload(slot)
1252         }
1253     }
1254 
1255     /**
1256      * @dev Upgrades the proxy to a new implementation.
1257      * 
1258      * Emits an {Upgraded} event.
1259      */
1260     function _upgradeTo(address newImplementation) internal {
1261         _setImplementation(newImplementation);
1262         emit Upgraded(newImplementation);
1263     }
1264 
1265     /**
1266      * @dev Stores a new address in the EIP1967 implementation slot.
1267      */
1268     function _setImplementation(address newImplementation) private {
1269         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
1270 
1271         bytes32 slot = _IMPLEMENTATION_SLOT;
1272 
1273         // solhint-disable-next-line no-inline-assembly
1274         assembly {
1275             sstore(slot, newImplementation)
1276         }
1277     }
1278 }
1279 
1280 /**
1281  * @dev This contract implements a proxy that is upgradeable by an admin.
1282  * 
1283  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
1284  * clashing], which can potentially be used in an attack, this contract uses the
1285  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
1286  * things that go hand in hand:
1287  * 
1288  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
1289  * that call matches one of the admin functions exposed by the proxy itself.
1290  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
1291  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
1292  * "admin cannot fallback to proxy target".
1293  * 
1294  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
1295  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
1296  * to sudden errors when trying to call a function from the proxy implementation.
1297  * 
1298  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
1299  * you should think of the `ProxyAdmin` instance as the real administrative inerface of your proxy.
1300  */
1301 contract TransparentUpgradeableProxy is UpgradeableProxy {
1302     /**
1303      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
1304      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
1305      */
1306     constructor(address _logic, address _admin, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
1307         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
1308         _setAdmin(_admin);
1309     }
1310 
1311     /**
1312      * @dev Emitted when the admin account has changed.
1313      */
1314     event AdminChanged(address previousAdmin, address newAdmin);
1315 
1316     /**
1317      * @dev Storage slot with the admin of the contract.
1318      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
1319      * validated in the constructor.
1320      */
1321     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
1322 
1323     /**
1324      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
1325      */
1326     modifier ifAdmin() {
1327         if (msg.sender == _admin()) {
1328             _;
1329         } else {
1330             _fallback();
1331         }
1332     }
1333 
1334     /**
1335      * @dev Returns the current admin.
1336      * 
1337      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
1338      * 
1339      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
1340      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
1341      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
1342      */
1343     function admin() external ifAdmin returns (address) {
1344         return _admin();
1345     }
1346 
1347     /**
1348      * @dev Returns the current implementation.
1349      * 
1350      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
1351      * 
1352      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
1353      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
1354      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
1355      */
1356     function implementation() external ifAdmin returns (address) {
1357         return _implementation();
1358     }
1359 
1360     /**
1361      * @dev Changes the admin of the proxy.
1362      * 
1363      * Emits an {AdminChanged} event.
1364      * 
1365      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
1366      */
1367     function changeAdmin(address newAdmin) external ifAdmin {
1368         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
1369         emit AdminChanged(_admin(), newAdmin);
1370         _setAdmin(newAdmin);
1371     }
1372 
1373     /**
1374      * @dev Upgrade the implementation of the proxy.
1375      * 
1376      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
1377      */
1378     function upgradeTo(address newImplementation) external ifAdmin {
1379         _upgradeTo(newImplementation);
1380     }
1381 
1382     /**
1383      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
1384      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
1385      * proxied contract.
1386      * 
1387      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
1388      */
1389     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
1390         _upgradeTo(newImplementation);
1391         // solhint-disable-next-line avoid-low-level-calls
1392         (bool success,) = newImplementation.delegatecall(data);
1393         require(success);
1394     }
1395 
1396     /**
1397      * @dev Returns the current admin.
1398      */
1399     function _admin() internal view returns (address adm) {
1400         bytes32 slot = _ADMIN_SLOT;
1401         // solhint-disable-next-line no-inline-assembly
1402         assembly {
1403             adm := sload(slot)
1404         }
1405     }
1406 
1407     /**
1408      * @dev Stores a new address in the EIP1967 admin slot.
1409      */
1410     function _setAdmin(address newAdmin) private {
1411         bytes32 slot = _ADMIN_SLOT;
1412 
1413         // solhint-disable-next-line no-inline-assembly
1414         assembly {
1415             sstore(slot, newAdmin)
1416         }
1417     }
1418 
1419     /**
1420      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
1421      */
1422     function _beforeFallback() internal override virtual {
1423         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
1424         super._beforeFallback();
1425     }
1426 }
1427 
1428 contract TokenProxy is TransparentUpgradeableProxy, ERC20 {
1429 	/**
1430 	 * Contract constructor.
1431 	 * @param _logic address of the initial implementation.
1432 	 * @param _admin Address of the proxy administrator.
1433 	 * @param _data Optional data for executing after deployment
1434 	 */
1435 	constructor(address _logic, address _admin, bytes memory _data) TransparentUpgradeableProxy(_logic, _admin, _data) public payable {}
1436 }