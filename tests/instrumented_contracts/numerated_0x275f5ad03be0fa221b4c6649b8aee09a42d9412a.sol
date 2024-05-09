1 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.2.0
2 
3 
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 // File @openzeppelin/contracts/math/SafeMath.sol@v3.2.0
83 
84 
85 
86 pragma solidity ^0.6.0;
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      *
158      * - Multiplication cannot overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint256 c = a * b;
169         require(c / a == b, "SafeMath: multiplication overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         return div(a, b, "SafeMath: division by zero");
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b > 0, errorMessage);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         return mod(a, b, "SafeMath: modulo by zero");
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts with custom message when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b != 0, errorMessage);
240         return a % b;
241     }
242 }
243 
244 
245 // File @openzeppelin/contracts/GSN/Context.sol@v3.2.0
246 
247 
248 
249 pragma solidity ^0.6.0;
250 
251 /*
252  * @dev Provides information about the current execution context, including the
253  * sender of the transaction and its data. While these are generally available
254  * via msg.sender and msg.data, they should not be accessed in such a direct
255  * manner, since when dealing with GSN meta-transactions the account sending and
256  * paying for execution may not be the actual sender (as far as an application
257  * is concerned).
258  *
259  * This contract is only required for intermediate, library-like contracts.
260  */
261 abstract contract Context {
262     function _msgSender() internal view virtual returns (address payable) {
263         return msg.sender;
264     }
265 
266     function _msgData() internal view virtual returns (bytes memory) {
267         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
268         return msg.data;
269     }
270 }
271 
272 
273 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.2.0
274 
275 
276 
277 pragma solidity ^0.6.0;
278 
279 /**
280  * @dev Library for managing
281  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
282  * types.
283  *
284  * Sets have the following properties:
285  *
286  * - Elements are added, removed, and checked for existence in constant time
287  * (O(1)).
288  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
289  *
290  * ```
291  * contract Example {
292  *     // Add the library methods
293  *     using EnumerableSet for EnumerableSet.AddressSet;
294  *
295  *     // Declare a set state variable
296  *     EnumerableSet.AddressSet private mySet;
297  * }
298  * ```
299  *
300  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
301  * (`UintSet`) are supported.
302  */
303 library EnumerableSet {
304     // To implement this library for multiple types with as little code
305     // repetition as possible, we write it in terms of a generic Set type with
306     // bytes32 values.
307     // The Set implementation uses private functions, and user-facing
308     // implementations (such as AddressSet) are just wrappers around the
309     // underlying Set.
310     // This means that we can only create new EnumerableSets for types that fit
311     // in bytes32.
312 
313     struct Set {
314         // Storage of set values
315         bytes32[] _values;
316 
317         // Position of the value in the `values` array, plus 1 because index 0
318         // means a value is not in the set.
319         mapping (bytes32 => uint256) _indexes;
320     }
321 
322     /**
323      * @dev Add a value to a set. O(1).
324      *
325      * Returns true if the value was added to the set, that is if it was not
326      * already present.
327      */
328     function _add(Set storage set, bytes32 value) private returns (bool) {
329         if (!_contains(set, value)) {
330             set._values.push(value);
331             // The value is stored at length-1, but we add 1 to all indexes
332             // and use 0 as a sentinel value
333             set._indexes[value] = set._values.length;
334             return true;
335         } else {
336             return false;
337         }
338     }
339 
340     /**
341      * @dev Removes a value from a set. O(1).
342      *
343      * Returns true if the value was removed from the set, that is if it was
344      * present.
345      */
346     function _remove(Set storage set, bytes32 value) private returns (bool) {
347         // We read and store the value's index to prevent multiple reads from the same storage slot
348         uint256 valueIndex = set._indexes[value];
349 
350         if (valueIndex != 0) { // Equivalent to contains(set, value)
351             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
352             // the array, and then remove the last element (sometimes called as 'swap and pop').
353             // This modifies the order of the array, as noted in {at}.
354 
355             uint256 toDeleteIndex = valueIndex - 1;
356             uint256 lastIndex = set._values.length - 1;
357 
358             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
359             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
360 
361             bytes32 lastvalue = set._values[lastIndex];
362 
363             // Move the last value to the index where the value to delete is
364             set._values[toDeleteIndex] = lastvalue;
365             // Update the index for the moved value
366             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
367 
368             // Delete the slot where the moved value was stored
369             set._values.pop();
370 
371             // Delete the index for the deleted slot
372             delete set._indexes[value];
373 
374             return true;
375         } else {
376             return false;
377         }
378     }
379 
380     /**
381      * @dev Returns true if the value is in the set. O(1).
382      */
383     function _contains(Set storage set, bytes32 value) private view returns (bool) {
384         return set._indexes[value] != 0;
385     }
386 
387     /**
388      * @dev Returns the number of values on the set. O(1).
389      */
390     function _length(Set storage set) private view returns (uint256) {
391         return set._values.length;
392     }
393 
394    /**
395     * @dev Returns the value stored at position `index` in the set. O(1).
396     *
397     * Note that there are no guarantees on the ordering of values inside the
398     * array, and it may change when more values are added or removed.
399     *
400     * Requirements:
401     *
402     * - `index` must be strictly less than {length}.
403     */
404     function _at(Set storage set, uint256 index) private view returns (bytes32) {
405         require(set._values.length > index, "EnumerableSet: index out of bounds");
406         return set._values[index];
407     }
408 
409     // AddressSet
410 
411     struct AddressSet {
412         Set _inner;
413     }
414 
415     /**
416      * @dev Add a value to a set. O(1).
417      *
418      * Returns true if the value was added to the set, that is if it was not
419      * already present.
420      */
421     function add(AddressSet storage set, address value) internal returns (bool) {
422         return _add(set._inner, bytes32(uint256(value)));
423     }
424 
425     /**
426      * @dev Removes a value from a set. O(1).
427      *
428      * Returns true if the value was removed from the set, that is if it was
429      * present.
430      */
431     function remove(AddressSet storage set, address value) internal returns (bool) {
432         return _remove(set._inner, bytes32(uint256(value)));
433     }
434 
435     /**
436      * @dev Returns true if the value is in the set. O(1).
437      */
438     function contains(AddressSet storage set, address value) internal view returns (bool) {
439         return _contains(set._inner, bytes32(uint256(value)));
440     }
441 
442     /**
443      * @dev Returns the number of values in the set. O(1).
444      */
445     function length(AddressSet storage set) internal view returns (uint256) {
446         return _length(set._inner);
447     }
448 
449    /**
450     * @dev Returns the value stored at position `index` in the set. O(1).
451     *
452     * Note that there are no guarantees on the ordering of values inside the
453     * array, and it may change when more values are added or removed.
454     *
455     * Requirements:
456     *
457     * - `index` must be strictly less than {length}.
458     */
459     function at(AddressSet storage set, uint256 index) internal view returns (address) {
460         return address(uint256(_at(set._inner, index)));
461     }
462 
463 
464     // UintSet
465 
466     struct UintSet {
467         Set _inner;
468     }
469 
470     /**
471      * @dev Add a value to a set. O(1).
472      *
473      * Returns true if the value was added to the set, that is if it was not
474      * already present.
475      */
476     function add(UintSet storage set, uint256 value) internal returns (bool) {
477         return _add(set._inner, bytes32(value));
478     }
479 
480     /**
481      * @dev Removes a value from a set. O(1).
482      *
483      * Returns true if the value was removed from the set, that is if it was
484      * present.
485      */
486     function remove(UintSet storage set, uint256 value) internal returns (bool) {
487         return _remove(set._inner, bytes32(value));
488     }
489 
490     /**
491      * @dev Returns true if the value is in the set. O(1).
492      */
493     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
494         return _contains(set._inner, bytes32(value));
495     }
496 
497     /**
498      * @dev Returns the number of values on the set. O(1).
499      */
500     function length(UintSet storage set) internal view returns (uint256) {
501         return _length(set._inner);
502     }
503 
504    /**
505     * @dev Returns the value stored at position `index` in the set. O(1).
506     *
507     * Note that there are no guarantees on the ordering of values inside the
508     * array, and it may change when more values are added or removed.
509     *
510     * Requirements:
511     *
512     * - `index` must be strictly less than {length}.
513     */
514     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
515         return uint256(_at(set._inner, index));
516     }
517 }
518 
519 
520 // File @openzeppelin/contracts/utils/Address.sol@v3.2.0
521 
522 
523 
524 pragma solidity ^0.6.2;
525 
526 /**
527  * @dev Collection of functions related to the address type
528  */
529 library Address {
530     /**
531      * @dev Returns true if `account` is a contract.
532      *
533      * [IMPORTANT]
534      * ====
535      * It is unsafe to assume that an address for which this function returns
536      * false is an externally-owned account (EOA) and not a contract.
537      *
538      * Among others, `isContract` will return false for the following
539      * types of addresses:
540      *
541      *  - an externally-owned account
542      *  - a contract in construction
543      *  - an address where a contract will be created
544      *  - an address where a contract lived, but was destroyed
545      * ====
546      */
547     function isContract(address account) internal view returns (bool) {
548         // This method relies in extcodesize, which returns 0 for contracts in
549         // construction, since the code is only stored at the end of the
550         // constructor execution.
551 
552         uint256 size;
553         // solhint-disable-next-line no-inline-assembly
554         assembly { size := extcodesize(account) }
555         return size > 0;
556     }
557 
558     /**
559      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
560      * `recipient`, forwarding all available gas and reverting on errors.
561      *
562      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
563      * of certain opcodes, possibly making contracts go over the 2300 gas limit
564      * imposed by `transfer`, making them unable to receive funds via
565      * `transfer`. {sendValue} removes this limitation.
566      *
567      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
568      *
569      * IMPORTANT: because control is transferred to `recipient`, care must be
570      * taken to not create reentrancy vulnerabilities. Consider using
571      * {ReentrancyGuard} or the
572      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
573      */
574     function sendValue(address payable recipient, uint256 amount) internal {
575         require(address(this).balance >= amount, "Address: insufficient balance");
576 
577         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
578         (bool success, ) = recipient.call{ value: amount }("");
579         require(success, "Address: unable to send value, recipient may have reverted");
580     }
581 
582     /**
583      * @dev Performs a Solidity function call using a low level `call`. A
584      * plain`call` is an unsafe replacement for a function call: use this
585      * function instead.
586      *
587      * If `target` reverts with a revert reason, it is bubbled up by this
588      * function (like regular Solidity function calls).
589      *
590      * Returns the raw returned data. To convert to the expected return value,
591      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
592      *
593      * Requirements:
594      *
595      * - `target` must be a contract.
596      * - calling `target` with `data` must not revert.
597      *
598      * _Available since v3.1._
599      */
600     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
601       return functionCall(target, data, "Address: low-level call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
606      * `errorMessage` as a fallback revert reason when `target` reverts.
607      *
608      * _Available since v3.1._
609      */
610     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
611         return _functionCallWithValue(target, data, 0, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but also transferring `value` wei to `target`.
617      *
618      * Requirements:
619      *
620      * - the calling contract must have an ETH balance of at least `value`.
621      * - the called Solidity function must be `payable`.
622      *
623      * _Available since v3.1._
624      */
625     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
626         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
631      * with `errorMessage` as a fallback revert reason when `target` reverts.
632      *
633      * _Available since v3.1._
634      */
635     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
636         require(address(this).balance >= value, "Address: insufficient balance for call");
637         return _functionCallWithValue(target, data, value, errorMessage);
638     }
639 
640     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
641         require(isContract(target), "Address: call to non-contract");
642 
643         // solhint-disable-next-line avoid-low-level-calls
644         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
645         if (success) {
646             return returndata;
647         } else {
648             // Look for revert reason and bubble it up if present
649             if (returndata.length > 0) {
650                 // The easiest way to bubble the revert reason is using memory via assembly
651 
652                 // solhint-disable-next-line no-inline-assembly
653                 assembly {
654                     let returndata_size := mload(returndata)
655                     revert(add(32, returndata), returndata_size)
656                 }
657             } else {
658                 revert(errorMessage);
659             }
660         }
661     }
662 }
663 
664 
665 // File @openzeppelin/contracts/access/AccessControl.sol@v3.2.0
666 
667 
668 
669 pragma solidity ^0.6.0;
670 
671 
672 
673 /**
674  * @dev Contract module that allows children to implement role-based access
675  * control mechanisms.
676  *
677  * Roles are referred to by their `bytes32` identifier. These should be exposed
678  * in the external API and be unique. The best way to achieve this is by
679  * using `public constant` hash digests:
680  *
681  * ```
682  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
683  * ```
684  *
685  * Roles can be used to represent a set of permissions. To restrict access to a
686  * function call, use {hasRole}:
687  *
688  * ```
689  * function foo() public {
690  *     require(hasRole(MY_ROLE, msg.sender));
691  *     ...
692  * }
693  * ```
694  *
695  * Roles can be granted and revoked dynamically via the {grantRole} and
696  * {revokeRole} functions. Each role has an associated admin role, and only
697  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
698  *
699  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
700  * that only accounts with this role will be able to grant or revoke other
701  * roles. More complex role relationships can be created by using
702  * {_setRoleAdmin}.
703  *
704  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
705  * grant and revoke this role. Extra precautions should be taken to secure
706  * accounts that have been granted it.
707  */
708 abstract contract AccessControl is Context {
709     using EnumerableSet for EnumerableSet.AddressSet;
710     using Address for address;
711 
712     struct RoleData {
713         EnumerableSet.AddressSet members;
714         bytes32 adminRole;
715     }
716 
717     mapping (bytes32 => RoleData) private _roles;
718 
719     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
720 
721     /**
722      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
723      *
724      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
725      * {RoleAdminChanged} not being emitted signaling this.
726      *
727      * _Available since v3.1._
728      */
729     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
730 
731     /**
732      * @dev Emitted when `account` is granted `role`.
733      *
734      * `sender` is the account that originated the contract call, an admin role
735      * bearer except when using {_setupRole}.
736      */
737     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
738 
739     /**
740      * @dev Emitted when `account` is revoked `role`.
741      *
742      * `sender` is the account that originated the contract call:
743      *   - if using `revokeRole`, it is the admin role bearer
744      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
745      */
746     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
747 
748     /**
749      * @dev Returns `true` if `account` has been granted `role`.
750      */
751     function hasRole(bytes32 role, address account) public view returns (bool) {
752         return _roles[role].members.contains(account);
753     }
754 
755     /**
756      * @dev Returns the number of accounts that have `role`. Can be used
757      * together with {getRoleMember} to enumerate all bearers of a role.
758      */
759     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
760         return _roles[role].members.length();
761     }
762 
763     /**
764      * @dev Returns one of the accounts that have `role`. `index` must be a
765      * value between 0 and {getRoleMemberCount}, non-inclusive.
766      *
767      * Role bearers are not sorted in any particular way, and their ordering may
768      * change at any point.
769      *
770      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
771      * you perform all queries on the same block. See the following
772      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
773      * for more information.
774      */
775     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
776         return _roles[role].members.at(index);
777     }
778 
779     /**
780      * @dev Returns the admin role that controls `role`. See {grantRole} and
781      * {revokeRole}.
782      *
783      * To change a role's admin, use {_setRoleAdmin}.
784      */
785     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
786         return _roles[role].adminRole;
787     }
788 
789     /**
790      * @dev Grants `role` to `account`.
791      *
792      * If `account` had not been already granted `role`, emits a {RoleGranted}
793      * event.
794      *
795      * Requirements:
796      *
797      * - the caller must have ``role``'s admin role.
798      */
799     function grantRole(bytes32 role, address account) public virtual {
800         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
801 
802         _grantRole(role, account);
803     }
804 
805     /**
806      * @dev Revokes `role` from `account`.
807      *
808      * If `account` had been granted `role`, emits a {RoleRevoked} event.
809      *
810      * Requirements:
811      *
812      * - the caller must have ``role``'s admin role.
813      */
814     function revokeRole(bytes32 role, address account) public virtual {
815         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
816 
817         _revokeRole(role, account);
818     }
819 
820     /**
821      * @dev Revokes `role` from the calling account.
822      *
823      * Roles are often managed via {grantRole} and {revokeRole}: this function's
824      * purpose is to provide a mechanism for accounts to lose their privileges
825      * if they are compromised (such as when a trusted device is misplaced).
826      *
827      * If the calling account had been granted `role`, emits a {RoleRevoked}
828      * event.
829      *
830      * Requirements:
831      *
832      * - the caller must be `account`.
833      */
834     function renounceRole(bytes32 role, address account) public virtual {
835         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
836 
837         _revokeRole(role, account);
838     }
839 
840     /**
841      * @dev Grants `role` to `account`.
842      *
843      * If `account` had not been already granted `role`, emits a {RoleGranted}
844      * event. Note that unlike {grantRole}, this function doesn't perform any
845      * checks on the calling account.
846      *
847      * [WARNING]
848      * ====
849      * This function should only be called from the constructor when setting
850      * up the initial roles for the system.
851      *
852      * Using this function in any other way is effectively circumventing the admin
853      * system imposed by {AccessControl}.
854      * ====
855      */
856     function _setupRole(bytes32 role, address account) internal virtual {
857         _grantRole(role, account);
858     }
859 
860     /**
861      * @dev Sets `adminRole` as ``role``'s admin role.
862      *
863      * Emits a {RoleAdminChanged} event.
864      */
865     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
866         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
867         _roles[role].adminRole = adminRole;
868     }
869 
870     function _grantRole(bytes32 role, address account) private {
871         if (_roles[role].members.add(account)) {
872             emit RoleGranted(role, account, _msgSender());
873         }
874     }
875 
876     function _revokeRole(bytes32 role, address account) private {
877         if (_roles[role].members.remove(account)) {
878             emit RoleRevoked(role, account, _msgSender());
879         }
880     }
881 }
882 
883 
884 // File contracts/DigitalaxAccessControls.sol
885 
886 pragma solidity 0.6.12;
887 
888 /**
889  * @notice Access Controls contract for the Digitalax Platform
890  * @author BlockRocket.tech
891  */
892 contract DigitalaxAccessControls is AccessControl {
893     /// @notice Role definitions
894     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
895     bytes32 public constant SMART_CONTRACT_ROLE = keccak256("SMART_CONTRACT_ROLE");
896 
897     /// @notice Events for adding and removing various roles
898     event AdminRoleGranted(
899         address indexed beneficiary,
900         address indexed caller
901     );
902 
903     event AdminRoleRemoved(
904         address indexed beneficiary,
905         address indexed caller
906     );
907 
908     event MinterRoleGranted(
909         address indexed beneficiary,
910         address indexed caller
911     );
912 
913     event MinterRoleRemoved(
914         address indexed beneficiary,
915         address indexed caller
916     );
917 
918     event SmartContractRoleGranted(
919         address indexed beneficiary,
920         address indexed caller
921     );
922 
923     event SmartContractRoleRemoved(
924         address indexed beneficiary,
925         address indexed caller
926     );
927 
928     /**
929      * @notice The deployer is automatically given the admin role which will allow them to then grant roles to other addresses
930      */
931     constructor() public {
932         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
933     }
934 
935     /////////////
936     // Lookups //
937     /////////////
938 
939     /**
940      * @notice Used to check whether an address has the admin role
941      * @param _address EOA or contract being checked
942      * @return bool True if the account has the role or false if it does not
943      */
944     function hasAdminRole(address _address) external view returns (bool) {
945         return hasRole(DEFAULT_ADMIN_ROLE, _address);
946     }
947 
948     /**
949      * @notice Used to check whether an address has the minter role
950      * @param _address EOA or contract being checked
951      * @return bool True if the account has the role or false if it does not
952      */
953     function hasMinterRole(address _address) external view returns (bool) {
954         return hasRole(MINTER_ROLE, _address);
955     }
956 
957     /**
958      * @notice Used to check whether an address has the smart contract role
959      * @param _address EOA or contract being checked
960      * @return bool True if the account has the role or false if it does not
961      */
962     function hasSmartContractRole(address _address) external view returns (bool) {
963         return hasRole(SMART_CONTRACT_ROLE, _address);
964     }
965 
966     ///////////////
967     // Modifiers //
968     ///////////////
969 
970     /**
971      * @notice Grants the admin role to an address
972      * @dev The sender must have the admin role
973      * @param _address EOA or contract receiving the new role
974      */
975     function addAdminRole(address _address) external {
976         grantRole(DEFAULT_ADMIN_ROLE, _address);
977         emit AdminRoleGranted(_address, _msgSender());
978     }
979 
980     /**
981      * @notice Removes the admin role from an address
982      * @dev The sender must have the admin role
983      * @param _address EOA or contract affected
984      */
985     function removeAdminRole(address _address) external {
986         revokeRole(DEFAULT_ADMIN_ROLE, _address);
987         emit AdminRoleRemoved(_address, _msgSender());
988     }
989 
990     /**
991      * @notice Grants the minter role to an address
992      * @dev The sender must have the admin role
993      * @param _address EOA or contract receiving the new role
994      */
995     function addMinterRole(address _address) external {
996         grantRole(MINTER_ROLE, _address);
997         emit MinterRoleGranted(_address, _msgSender());
998     }
999 
1000     /**
1001      * @notice Removes the minter role from an address
1002      * @dev The sender must have the admin role
1003      * @param _address EOA or contract affected
1004      */
1005     function removeMinterRole(address _address) external {
1006         revokeRole(MINTER_ROLE, _address);
1007         emit MinterRoleRemoved(_address, _msgSender());
1008     }
1009 
1010     /**
1011      * @notice Grants the smart contract role to an address
1012      * @dev The sender must have the admin role
1013      * @param _address EOA or contract receiving the new role
1014      */
1015     function addSmartContractRole(address _address) external {
1016         grantRole(SMART_CONTRACT_ROLE, _address);
1017         emit SmartContractRoleGranted(_address, _msgSender());
1018     }
1019 
1020     /**
1021      * @notice Removes the smart contract role from an address
1022      * @dev The sender must have the admin role
1023      * @param _address EOA or contract affected
1024      */
1025     function removeSmartContractRole(address _address) external {
1026         revokeRole(SMART_CONTRACT_ROLE, _address);
1027         emit SmartContractRoleRemoved(_address, _msgSender());
1028     }
1029 }
1030 
1031 
1032 // File contracts/MONA.sol
1033 
1034 pragma solidity ^0.6.12;
1035 
1036 
1037 
1038 
1039 /**
1040  * @notice Mona Governance Token = ERC20 + mint + burn.
1041  * @author Adrian Guerrera (deepyr)
1042  * @author Attr: BokkyPooBah (c) The Optino Project
1043  * @dev https://github.com/ogDAO/Governance/
1044  */
1045 
1046 // SPDX-License-Identifier: GPLv2
1047 contract MONA is Context, IERC20  {
1048     using SafeMath for uint;
1049 
1050     string _symbol;
1051     string  _name;
1052     uint8 _decimals;
1053     uint _totalSupply;
1054     mapping(address => uint) balances;
1055 
1056     mapping(address => mapping(address => uint)) allowed;
1057     uint public cap;
1058     bool public freezeCap;
1059 
1060     DigitalaxAccessControls public accessControls;
1061 
1062     event CapUpdated(uint256 cap, bool freezeCap);
1063 
1064     constructor(
1065         string memory symbol_,
1066         string memory name_,
1067         uint8 decimals_,
1068         DigitalaxAccessControls accessControls_,
1069         address tokenOwner,
1070         uint256 initialSupply
1071     ) 
1072         public 
1073     {
1074         _symbol = symbol_;
1075         _name = name_;
1076         _decimals = decimals_;
1077         accessControls = accessControls_;
1078         balances[tokenOwner] = initialSupply;
1079         _totalSupply = initialSupply;
1080         emit Transfer(address(0), tokenOwner, _totalSupply);
1081     }
1082 
1083     function symbol() external view returns (string memory) {
1084         return _symbol;
1085     }
1086     function name() external view returns (string memory) {
1087         return _name;
1088     }
1089     function decimals() external view returns (uint8) {
1090         return _decimals;
1091     }
1092     function totalSupply() override external view returns (uint) {
1093         return _totalSupply.sub(balances[address(0)]);
1094     }
1095     function balanceOf(address tokenOwner) override external view returns (uint balance) {
1096         return balances[tokenOwner];
1097     }
1098     function transfer(address to, uint tokens) override external returns (bool success) {
1099         balances[_msgSender()] = balances[_msgSender()].sub(tokens);
1100         balances[to] = balances[to].add(tokens);
1101         emit Transfer(_msgSender(), to, tokens);
1102         return true;
1103     }
1104     function approve(address spender, uint tokens) override external returns (bool success) {
1105         allowed[_msgSender()][spender] = tokens;
1106         emit Approval(_msgSender(), spender, tokens);
1107         return true;
1108     }
1109     function transferFrom(address from, address to, uint tokens) override external returns (bool success) {
1110         balances[from] = balances[from].sub(tokens);
1111         allowed[from][_msgSender()] = allowed[from][_msgSender()].sub(tokens);
1112         balances[to] = balances[to].add(tokens);
1113         emit Transfer(from, to, tokens);
1114         return true;
1115     }
1116     function allowance(address tokenOwner, address spender) override external view returns (uint remaining) {
1117         return allowed[tokenOwner][spender];
1118     }
1119 
1120     function setCap(uint _cap, bool _freezeCap) external  {
1121         require(
1122             accessControls.hasAdminRole(_msgSender()),
1123             "MONA.setCap: Sender must be admin"
1124         );
1125         require(_freezeCap || _cap >= _totalSupply, "Cap less than totalSupply");
1126         require(!freezeCap, "Cap frozen");
1127         (cap, freezeCap) = (_cap, _freezeCap);
1128         emit CapUpdated(cap, freezeCap);
1129     }
1130 
1131     function availableToMint() external view returns (uint tokens) {
1132         if (accessControls.hasMinterRole(_msgSender())) {
1133             if (cap > 0) {
1134                 tokens = cap.sub(_totalSupply.sub(balances[address(0)]));
1135             } else {
1136                 tokens = uint(-1);
1137             }
1138         } 
1139     }
1140 
1141     function mint(address tokenOwner, uint tokens) external returns (bool success) {
1142         require(
1143             accessControls.hasMinterRole(_msgSender()),
1144             "MONA.mint: Sender must have permission to mint"
1145         );
1146         require(cap == 0 || _totalSupply + tokens <= cap, "Cap exceeded");
1147         balances[tokenOwner] = balances[tokenOwner].add(tokens);
1148         _totalSupply = _totalSupply.add(tokens);
1149         emit Transfer(address(0), tokenOwner, tokens);
1150         return true;
1151     }
1152     function burn(uint tokens) external returns (bool success) {
1153         balances[_msgSender()] = balances[_msgSender()].sub(tokens);
1154         _totalSupply = _totalSupply.sub(tokens);
1155         emit Transfer(_msgSender(), address(0), tokens);
1156         return true;
1157     }
1158 }