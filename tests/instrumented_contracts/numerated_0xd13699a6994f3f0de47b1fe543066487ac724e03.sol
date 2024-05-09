1 pragma solidity 0.6.12;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
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
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b <= a, errorMessage);
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         // Solidity only automatically asserts when dividing by 0
188         require(b > 0, errorMessage);
189         uint256 c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * Reverts when dividing by zero.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      * - The divisor cannot be zero.
205      */
206     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
207         return mod(a, b, "SafeMath: modulo by zero");
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts with custom message when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b != 0, errorMessage);
223         return a % b;
224     }
225 }
226 
227 /**
228  * @dev Collection of functions related to the address type
229  */
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * [IMPORTANT]
235      * ====
236      * It is unsafe to assume that an address for which this function returns
237      * false is an externally-owned account (EOA) and not a contract.
238      *
239      * Among others, `isContract` will return false for the following
240      * types of addresses:
241      *
242      *  - an externally-owned account
243      *  - a contract in construction
244      *  - an address where a contract will be created
245      *  - an address where a contract lived, but was destroyed
246      * ====
247      */
248     function isContract(address account) internal view returns (bool) {
249         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
250         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
251         // for accounts without code, i.e. `keccak256('')`
252         bytes32 codehash;
253         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
254         // solhint-disable-next-line no-inline-assembly
255         assembly { codehash := extcodehash(account) }
256         return (codehash != accountHash && codehash != 0x0);
257     }
258 
259     /**
260      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
261      * `recipient`, forwarding all available gas and reverting on errors.
262      *
263      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
264      * of certain opcodes, possibly making contracts go over the 2300 gas limit
265      * imposed by `transfer`, making them unable to receive funds via
266      * `transfer`. {sendValue} removes this limitation.
267      *
268      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
269      *
270      * IMPORTANT: because control is transferred to `recipient`, care must be
271      * taken to not create reentrancy vulnerabilities. Consider using
272      * {ReentrancyGuard} or the
273      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
274      */
275     function sendValue(address payable recipient, uint256 amount) internal {
276         require(address(this).balance >= amount, "Address: insufficient balance");
277 
278         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
279         (bool success, ) = recipient.call{ value: amount }("");
280         require(success, "Address: unable to send value, recipient may have reverted");
281     }
282 }
283 
284 /**
285  * @title SafeERC20
286  * @dev Wrappers around ERC20 operations that throw on failure (when the token
287  * contract returns false). Tokens that return no value (and instead revert or
288  * throw on failure) are also supported, non-reverting calls are assumed to be
289  * successful.
290  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
291  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
292  */
293 library SafeERC20 {
294     using SafeMath for uint256;
295     using Address for address;
296 
297     function safeTransfer(IERC20 token, address to, uint256 value) internal {
298         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
299     }
300 
301     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
302         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
303     }
304 
305     function safeApprove(IERC20 token, address spender, uint256 value) internal {
306         // safeApprove should only be called when setting an initial allowance,
307         // or when resetting it to zero. To increase and decrease it, use
308         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
309         // solhint-disable-next-line max-line-length
310         require((value == 0) || (token.allowance(address(this), spender) == 0),
311             "SafeERC20: approve from non-zero to non-zero allowance"
312         );
313         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
314     }
315 
316     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
317         uint256 newAllowance = token.allowance(address(this), spender).add(value);
318         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
319     }
320 
321     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
322         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
323         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
324     }
325 
326     /**
327      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
328      * on the return value: the return value is optional (but if data is returned, it must not be false).
329      * @param token The token targeted by the call.
330      * @param data The call data (encoded using abi.encode or one of its variants).
331      */
332     function _callOptionalReturn(IERC20 token, bytes memory data) private {
333         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
334         // we're implementing it ourselves.
335 
336         // A Solidity high level call has three parts:
337         //  1. The target address is checked to verify it contains contract code
338         //  2. The call itself is made, and success asserted
339         //  3. The return value is decoded, which in turn checks the size of the returned data.
340         // solhint-disable-next-line max-line-length
341         require(address(token).isContract(), "SafeERC20: call to non-contract");
342 
343         // solhint-disable-next-line avoid-low-level-calls
344         (bool success, bytes memory returndata) = address(token).call(data);
345         require(success, "SafeERC20: low-level call failed");
346 
347         if (returndata.length > 0) { // Return data is optional
348             // solhint-disable-next-line max-line-length
349             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
350         }
351     }
352 }
353 
354 /**
355  * @dev Library for managing
356  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
357  * types.
358  *
359  * Sets have the following properties:
360  *
361  * - Elements are added, removed, and checked for existence in constant time
362  * (O(1)).
363  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
364  *
365  * ```
366  * contract Example {
367  *     // Add the library methods
368  *     using EnumerableSet for EnumerableSet.AddressSet;
369  *
370  *     // Declare a set state variable
371  *     EnumerableSet.AddressSet private mySet;
372  * }
373  * ```
374  *
375  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
376  * (`UintSet`) are supported.
377  */
378 library EnumerableSet {
379     // To implement this library for multiple types with as little code
380     // repetition as possible, we write it in terms of a generic Set type with
381     // bytes32 values.
382     // The Set implementation uses private functions, and user-facing
383     // implementations (such as AddressSet) are just wrappers around the
384     // underlying Set.
385     // This means that we can only create new EnumerableSets for types that fit
386     // in bytes32.
387 
388     struct Set {
389         // Storage of set values
390         bytes32[] _values;
391 
392         // Position of the value in the `values` array, plus 1 because index 0
393         // means a value is not in the set.
394         mapping (bytes32 => uint256) _indexes;
395     }
396 
397     /**
398      * @dev Add a value to a set. O(1).
399      *
400      * Returns true if the value was added to the set, that is if it was not
401      * already present.
402      */
403     function _add(Set storage set, bytes32 value) private returns (bool) {
404         if (!_contains(set, value)) {
405             set._values.push(value);
406             // The value is stored at length-1, but we add 1 to all indexes
407             // and use 0 as a sentinel value
408             set._indexes[value] = set._values.length;
409             return true;
410         } else {
411             return false;
412         }
413     }
414 
415     /**
416      * @dev Removes a value from a set. O(1).
417      *
418      * Returns true if the value was removed from the set, that is if it was
419      * present.
420      */
421     function _remove(Set storage set, bytes32 value) private returns (bool) {
422         // We read and store the value's index to prevent multiple reads from the same storage slot
423         uint256 valueIndex = set._indexes[value];
424 
425         if (valueIndex != 0) { // Equivalent to contains(set, value)
426             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
427             // the array, and then remove the last element (sometimes called as 'swap and pop').
428             // This modifies the order of the array, as noted in {at}.
429 
430             uint256 toDeleteIndex = valueIndex - 1;
431             uint256 lastIndex = set._values.length - 1;
432 
433             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
434             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
435 
436             bytes32 lastvalue = set._values[lastIndex];
437 
438             // Move the last value to the index where the value to delete is
439             set._values[toDeleteIndex] = lastvalue;
440             // Update the index for the moved value
441             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
442 
443             // Delete the slot where the moved value was stored
444             set._values.pop();
445 
446             // Delete the index for the deleted slot
447             delete set._indexes[value];
448 
449             return true;
450         } else {
451             return false;
452         }
453     }
454 
455     /**
456      * @dev Returns true if the value is in the set. O(1).
457      */
458     function _contains(Set storage set, bytes32 value) private view returns (bool) {
459         return set._indexes[value] != 0;
460     }
461 
462     /**
463      * @dev Returns the number of values on the set. O(1).
464      */
465     function _length(Set storage set) private view returns (uint256) {
466         return set._values.length;
467     }
468 
469    /**
470     * @dev Returns the value stored at position `index` in the set. O(1).
471     *
472     * Note that there are no guarantees on the ordering of values inside the
473     * array, and it may change when more values are added or removed.
474     *
475     * Requirements:
476     *
477     * - `index` must be strictly less than {length}.
478     */
479     function _at(Set storage set, uint256 index) private view returns (bytes32) {
480         require(set._values.length > index, "EnumerableSet: index out of bounds");
481         return set._values[index];
482     }
483 
484     // AddressSet
485 
486     struct AddressSet {
487         Set _inner;
488     }
489 
490     /**
491      * @dev Add a value to a set. O(1).
492      *
493      * Returns true if the value was added to the set, that is if it was not
494      * already present.
495      */
496     function add(AddressSet storage set, address value) internal returns (bool) {
497         return _add(set._inner, bytes32(uint256(value)));
498     }
499 
500     /**
501      * @dev Removes a value from a set. O(1).
502      *
503      * Returns true if the value was removed from the set, that is if it was
504      * present.
505      */
506     function remove(AddressSet storage set, address value) internal returns (bool) {
507         return _remove(set._inner, bytes32(uint256(value)));
508     }
509 
510     /**
511      * @dev Returns true if the value is in the set. O(1).
512      */
513     function contains(AddressSet storage set, address value) internal view returns (bool) {
514         return _contains(set._inner, bytes32(uint256(value)));
515     }
516 
517     /**
518      * @dev Returns the number of values in the set. O(1).
519      */
520     function length(AddressSet storage set) internal view returns (uint256) {
521         return _length(set._inner);
522     }
523 
524    /**
525     * @dev Returns the value stored at position `index` in the set. O(1).
526     *
527     * Note that there are no guarantees on the ordering of values inside the
528     * array, and it may change when more values are added or removed.
529     *
530     * Requirements:
531     *
532     * - `index` must be strictly less than {length}.
533     */
534     function at(AddressSet storage set, uint256 index) internal view returns (address) {
535         return address(uint256(_at(set._inner, index)));
536     }
537 
538 
539     // UintSet
540 
541     struct UintSet {
542         Set _inner;
543     }
544 
545     /**
546      * @dev Add a value to a set. O(1).
547      *
548      * Returns true if the value was added to the set, that is if it was not
549      * already present.
550      */
551     function add(UintSet storage set, uint256 value) internal returns (bool) {
552         return _add(set._inner, bytes32(value));
553     }
554 
555     /**
556      * @dev Removes a value from a set. O(1).
557      *
558      * Returns true if the value was removed from the set, that is if it was
559      * present.
560      */
561     function remove(UintSet storage set, uint256 value) internal returns (bool) {
562         return _remove(set._inner, bytes32(value));
563     }
564 
565     /**
566      * @dev Returns true if the value is in the set. O(1).
567      */
568     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
569         return _contains(set._inner, bytes32(value));
570     }
571 
572     /**
573      * @dev Returns the number of values on the set. O(1).
574      */
575     function length(UintSet storage set) internal view returns (uint256) {
576         return _length(set._inner);
577     }
578 
579    /**
580     * @dev Returns the value stored at position `index` in the set. O(1).
581     *
582     * Note that there are no guarantees on the ordering of values inside the
583     * array, and it may change when more values are added or removed.
584     *
585     * Requirements:
586     *
587     * - `index` must be strictly less than {length}.
588     */
589     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
590         return uint256(_at(set._inner, index));
591     }
592 }
593 
594 /**
595  * @title Initializable
596  *
597  * @dev Helper contract to support initializer functions. To use it, replace
598  * the constructor with a function that has the `initializer` modifier.
599  * WARNING: Unlike constructors, initializer functions must be manually
600  * invoked. This applies both to deploying an Initializable contract, as well
601  * as extending an Initializable contract via inheritance.
602  * WARNING: When used with inheritance, manual care must be taken to not invoke
603  * a parent initializer twice, or ensure that all initializers are idempotent,
604  * because this is not dealt with automatically as with constructors.
605  */
606 contract Initializable {
607 
608   /**
609    * @dev Indicates that the contract has been initialized.
610    */
611   bool private initialized;
612 
613   /**
614    * @dev Indicates that the contract is in the process of being initialized.
615    */
616   bool private initializing;
617 
618   /**
619    * @dev Modifier to use in the initializer function of a contract.
620    */
621   modifier initializer() {
622     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
623 
624     bool isTopLevelCall = !initializing;
625     if (isTopLevelCall) {
626       initializing = true;
627       initialized = true;
628     }
629 
630     _;
631 
632     if (isTopLevelCall) {
633       initializing = false;
634     }
635   }
636 
637   /// @dev Returns true if and only if the function is running in the constructor
638   function isConstructor() private view returns (bool) {
639     // extcodesize checks the size of the code stored in an address, and
640     // address returns the current address. Since the code is still not
641     // deployed when running a constructor, any checks on its code size will
642     // yield zero, making it an effective way to detect if a contract is
643     // under construction or not.
644     address self = address(this);
645     uint256 cs;
646     assembly { cs := extcodesize(self) }
647     return cs == 0;
648   }
649 
650   // Reserved storage space to allow for layout changes in the future.
651   uint256[50] private ______gap;
652 }
653 
654 /*
655  * @dev Provides information about the current execution context, including the
656  * sender of the transaction and its data. While these are generally available
657  * via msg.sender and msg.data, they should not be accessed in such a direct
658  * manner, since when dealing with GSN meta-transactions the account sending and
659  * paying for execution may not be the actual sender (as far as an application
660  * is concerned).
661  *
662  * This contract is only required for intermediate, library-like contracts.
663  */
664 contract ContextUpgradeSafe is Initializable {
665     // Empty internal constructor, to prevent people from mistakenly deploying
666     // an instance of this contract, which should be used via inheritance.
667 
668     function __Context_init() internal initializer {
669         __Context_init_unchained();
670     }
671 
672     function __Context_init_unchained() internal initializer {
673 
674 
675     }
676 
677 
678     function _msgSender() internal view virtual returns (address payable) {
679         return msg.sender;
680     }
681 
682     function _msgData() internal view virtual returns (bytes memory) {
683         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
684         return msg.data;
685     }
686 
687     uint256[50] private __gap;
688 }
689 
690 /**
691  * @dev Contract module which provides a basic access control mechanism, where
692  * there is an account (an owner) that can be granted exclusive access to
693  * specific functions.
694  *
695  * By default, the owner account will be the one that deploys the contract. This
696  * can later be changed with {transferOwnership}.
697  *
698  * This module is used through inheritance. It will make available the modifier
699  * `onlyOwner`, which can be applied to your functions to restrict their use to
700  * the owner.
701  */
702 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
703     address private _owner;
704 
705     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
706 
707     /**
708      * @dev Initializes the contract setting the deployer as the initial owner.
709      */
710 
711     function __Ownable_init() internal initializer {
712         __Context_init_unchained();
713         __Ownable_init_unchained();
714     }
715 
716     function __Ownable_init_unchained() internal initializer {
717 
718 
719         address msgSender = _msgSender();
720         _owner = msgSender;
721         emit OwnershipTransferred(address(0), msgSender);
722 
723     }
724 
725 
726     /**
727      * @dev Returns the address of the current owner.
728      */
729     function owner() public view returns (address) {
730         return _owner;
731     }
732 
733     /**
734      * @dev Throws if called by any account other than the owner.
735      */
736     modifier onlyOwner() {
737         require(_owner == _msgSender(), "Ownable: caller is not the owner");
738         _;
739     }
740 
741     /**
742      * @dev Leaves the contract without owner. It will not be possible to call
743      * `onlyOwner` functions anymore. Can only be called by the current owner.
744      *
745      * NOTE: Renouncing ownership will leave the contract without an owner,
746      * thereby removing any functionality that is only available to the owner.
747      */
748     function renounceOwnership() public virtual onlyOwner {
749         emit OwnershipTransferred(_owner, address(0));
750         _owner = address(0);
751     }
752 
753     /**
754      * @dev Transfers ownership of the contract to a new account (`newOwner`).
755      * Can only be called by the current owner.
756      */
757     function transferOwnership(address newOwner) public virtual onlyOwner {
758         require(newOwner != address(0), "Ownable: new owner is the zero address");
759         emit OwnershipTransferred(_owner, newOwner);
760         _owner = newOwner;
761     }
762 
763     uint256[49] private __gap;
764 }
765 
766 /**
767  * @dev Interface of the ERC20 standard as defined in the EIP.
768  */
769 interface INBUNIERC20 {
770     /**
771      * @dev Returns the amount of tokens in existence.
772      */
773     function totalSupply() external view returns (uint256);
774 
775     /**
776      * @dev Returns the amount of tokens owned by `account`.
777      */
778     function balanceOf(address account) external view returns (uint256);
779 
780     /**
781      * @dev Moves `amount` tokens from the caller's account to `recipient`.
782      *
783      * Returns a boolean value indicating whether the operation succeeded.
784      *
785      * Emits a {Transfer} event.
786      */
787     function transfer(address recipient, uint256 amount) external returns (bool);
788 
789     /**
790      * @dev Returns the remaining number of tokens that `spender` will be
791      * allowed to spend on behalf of `owner` through {transferFrom}. This is
792      * zero by default.
793      *
794      * This value changes when {approve} or {transferFrom} are called.
795      */
796     function allowance(address owner, address spender) external view returns (uint256);
797 
798     /**
799      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
800      *
801      * Returns a boolean value indicating whether the operation succeeded.
802      *
803      * IMPORTANT: Beware that changing an allowance with this method brings the risk
804      * that someone may use both the old and the new allowance by unfortunate
805      * transaction ordering. One possible solution to mitigate this race
806      * condition is to first reduce the spender's allowance to 0 and set the
807      * desired value afterwards:
808      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
809      *
810      * Emits an {Approval} event.
811      */
812     function approve(address spender, uint256 amount) external returns (bool);
813 
814     /**
815      * @dev Moves `amount` tokens from `sender` to `recipient` using the
816      * allowance mechanism. `amount` is then deducted from the caller's
817      * allowance.
818      *
819      * Returns a boolean value indicating whether the operation succeeded.
820      *
821      * Emits a {Transfer} event.
822      */
823     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
824 
825     /**
826      * @dev Emitted when `value` tokens are moved from one account (`from`) to
827      * another (`to`).
828      *
829      * Note that `value` may be zero.
830      */
831     event Transfer(address indexed from, address indexed to, uint256 value);
832 
833     /**
834      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
835      * a call to {approve}. `value` is the new allowance.
836      */
837     event Approval(address indexed owner, address indexed spender, uint256 value);
838 
839 
840     event Log(string log);
841 
842 }
843 
844 library console {
845 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
846 
847 	function _sendLogPayload(bytes memory payload) private view {
848 		uint256 payloadLength = payload.length;
849 		address consoleAddress = CONSOLE_ADDRESS;
850 		assembly {
851 			let payloadStart := add(payload, 32)
852 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
853 		}
854 	}
855 
856 	function log() internal view {
857 		_sendLogPayload(abi.encodeWithSignature("log()"));
858 	}
859 
860 	function logInt(int p0) internal view {
861 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
862 	}
863 
864 	function logUint(uint p0) internal view {
865 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
866 	}
867 
868 	function logString(string memory p0) internal view {
869 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
870 	}
871 
872 	function logBool(bool p0) internal view {
873 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
874 	}
875 
876 	function logAddress(address p0) internal view {
877 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
878 	}
879 
880 	function logBytes(bytes memory p0) internal view {
881 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
882 	}
883 
884 	function logByte(byte p0) internal view {
885 		_sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
886 	}
887 
888 	function logBytes1(bytes1 p0) internal view {
889 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
890 	}
891 
892 	function logBytes2(bytes2 p0) internal view {
893 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
894 	}
895 
896 	function logBytes3(bytes3 p0) internal view {
897 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
898 	}
899 
900 	function logBytes4(bytes4 p0) internal view {
901 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
902 	}
903 
904 	function logBytes5(bytes5 p0) internal view {
905 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
906 	}
907 
908 	function logBytes6(bytes6 p0) internal view {
909 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
910 	}
911 
912 	function logBytes7(bytes7 p0) internal view {
913 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
914 	}
915 
916 	function logBytes8(bytes8 p0) internal view {
917 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
918 	}
919 
920 	function logBytes9(bytes9 p0) internal view {
921 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
922 	}
923 
924 	function logBytes10(bytes10 p0) internal view {
925 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
926 	}
927 
928 	function logBytes11(bytes11 p0) internal view {
929 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
930 	}
931 
932 	function logBytes12(bytes12 p0) internal view {
933 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
934 	}
935 
936 	function logBytes13(bytes13 p0) internal view {
937 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
938 	}
939 
940 	function logBytes14(bytes14 p0) internal view {
941 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
942 	}
943 
944 	function logBytes15(bytes15 p0) internal view {
945 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
946 	}
947 
948 	function logBytes16(bytes16 p0) internal view {
949 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
950 	}
951 
952 	function logBytes17(bytes17 p0) internal view {
953 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
954 	}
955 
956 	function logBytes18(bytes18 p0) internal view {
957 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
958 	}
959 
960 	function logBytes19(bytes19 p0) internal view {
961 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
962 	}
963 
964 	function logBytes20(bytes20 p0) internal view {
965 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
966 	}
967 
968 	function logBytes21(bytes21 p0) internal view {
969 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
970 	}
971 
972 	function logBytes22(bytes22 p0) internal view {
973 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
974 	}
975 
976 	function logBytes23(bytes23 p0) internal view {
977 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
978 	}
979 
980 	function logBytes24(bytes24 p0) internal view {
981 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
982 	}
983 
984 	function logBytes25(bytes25 p0) internal view {
985 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
986 	}
987 
988 	function logBytes26(bytes26 p0) internal view {
989 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
990 	}
991 
992 	function logBytes27(bytes27 p0) internal view {
993 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
994 	}
995 
996 	function logBytes28(bytes28 p0) internal view {
997 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
998 	}
999 
1000 	function logBytes29(bytes29 p0) internal view {
1001 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1002 	}
1003 
1004 	function logBytes30(bytes30 p0) internal view {
1005 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1006 	}
1007 
1008 	function logBytes31(bytes31 p0) internal view {
1009 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1010 	}
1011 
1012 	function logBytes32(bytes32 p0) internal view {
1013 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1014 	}
1015 
1016 	function log(uint p0) internal view {
1017 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1018 	}
1019 
1020 	function log(string memory p0) internal view {
1021 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1022 	}
1023 
1024 	function log(bool p0) internal view {
1025 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1026 	}
1027 
1028 	function log(address p0) internal view {
1029 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1030 	}
1031 
1032 	function log(uint p0, uint p1) internal view {
1033 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1034 	}
1035 
1036 	function log(uint p0, string memory p1) internal view {
1037 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1038 	}
1039 
1040 	function log(uint p0, bool p1) internal view {
1041 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1042 	}
1043 
1044 	function log(uint p0, address p1) internal view {
1045 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1046 	}
1047 
1048 	function log(string memory p0, uint p1) internal view {
1049 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1050 	}
1051 
1052 	function log(string memory p0, string memory p1) internal view {
1053 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1054 	}
1055 
1056 	function log(string memory p0, bool p1) internal view {
1057 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1058 	}
1059 
1060 	function log(string memory p0, address p1) internal view {
1061 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1062 	}
1063 
1064 	function log(bool p0, uint p1) internal view {
1065 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1066 	}
1067 
1068 	function log(bool p0, string memory p1) internal view {
1069 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1070 	}
1071 
1072 	function log(bool p0, bool p1) internal view {
1073 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1074 	}
1075 
1076 	function log(bool p0, address p1) internal view {
1077 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1078 	}
1079 
1080 	function log(address p0, uint p1) internal view {
1081 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1082 	}
1083 
1084 	function log(address p0, string memory p1) internal view {
1085 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1086 	}
1087 
1088 	function log(address p0, bool p1) internal view {
1089 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1090 	}
1091 
1092 	function log(address p0, address p1) internal view {
1093 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1094 	}
1095 
1096 	function log(uint p0, uint p1, uint p2) internal view {
1097 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1098 	}
1099 
1100 	function log(uint p0, uint p1, string memory p2) internal view {
1101 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1102 	}
1103 
1104 	function log(uint p0, uint p1, bool p2) internal view {
1105 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1106 	}
1107 
1108 	function log(uint p0, uint p1, address p2) internal view {
1109 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1110 	}
1111 
1112 	function log(uint p0, string memory p1, uint p2) internal view {
1113 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1114 	}
1115 
1116 	function log(uint p0, string memory p1, string memory p2) internal view {
1117 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1118 	}
1119 
1120 	function log(uint p0, string memory p1, bool p2) internal view {
1121 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1122 	}
1123 
1124 	function log(uint p0, string memory p1, address p2) internal view {
1125 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1126 	}
1127 
1128 	function log(uint p0, bool p1, uint p2) internal view {
1129 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1130 	}
1131 
1132 	function log(uint p0, bool p1, string memory p2) internal view {
1133 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1134 	}
1135 
1136 	function log(uint p0, bool p1, bool p2) internal view {
1137 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1138 	}
1139 
1140 	function log(uint p0, bool p1, address p2) internal view {
1141 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1142 	}
1143 
1144 	function log(uint p0, address p1, uint p2) internal view {
1145 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1146 	}
1147 
1148 	function log(uint p0, address p1, string memory p2) internal view {
1149 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1150 	}
1151 
1152 	function log(uint p0, address p1, bool p2) internal view {
1153 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1154 	}
1155 
1156 	function log(uint p0, address p1, address p2) internal view {
1157 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1158 	}
1159 
1160 	function log(string memory p0, uint p1, uint p2) internal view {
1161 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1162 	}
1163 
1164 	function log(string memory p0, uint p1, string memory p2) internal view {
1165 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1166 	}
1167 
1168 	function log(string memory p0, uint p1, bool p2) internal view {
1169 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1170 	}
1171 
1172 	function log(string memory p0, uint p1, address p2) internal view {
1173 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1174 	}
1175 
1176 	function log(string memory p0, string memory p1, uint p2) internal view {
1177 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1178 	}
1179 
1180 	function log(string memory p0, string memory p1, string memory p2) internal view {
1181 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1182 	}
1183 
1184 	function log(string memory p0, string memory p1, bool p2) internal view {
1185 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1186 	}
1187 
1188 	function log(string memory p0, string memory p1, address p2) internal view {
1189 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1190 	}
1191 
1192 	function log(string memory p0, bool p1, uint p2) internal view {
1193 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1194 	}
1195 
1196 	function log(string memory p0, bool p1, string memory p2) internal view {
1197 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1198 	}
1199 
1200 	function log(string memory p0, bool p1, bool p2) internal view {
1201 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1202 	}
1203 
1204 	function log(string memory p0, bool p1, address p2) internal view {
1205 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1206 	}
1207 
1208 	function log(string memory p0, address p1, uint p2) internal view {
1209 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1210 	}
1211 
1212 	function log(string memory p0, address p1, string memory p2) internal view {
1213 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1214 	}
1215 
1216 	function log(string memory p0, address p1, bool p2) internal view {
1217 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1218 	}
1219 
1220 	function log(string memory p0, address p1, address p2) internal view {
1221 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1222 	}
1223 
1224 	function log(bool p0, uint p1, uint p2) internal view {
1225 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1226 	}
1227 
1228 	function log(bool p0, uint p1, string memory p2) internal view {
1229 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1230 	}
1231 
1232 	function log(bool p0, uint p1, bool p2) internal view {
1233 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1234 	}
1235 
1236 	function log(bool p0, uint p1, address p2) internal view {
1237 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1238 	}
1239 
1240 	function log(bool p0, string memory p1, uint p2) internal view {
1241 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1242 	}
1243 
1244 	function log(bool p0, string memory p1, string memory p2) internal view {
1245 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1246 	}
1247 
1248 	function log(bool p0, string memory p1, bool p2) internal view {
1249 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1250 	}
1251 
1252 	function log(bool p0, string memory p1, address p2) internal view {
1253 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1254 	}
1255 
1256 	function log(bool p0, bool p1, uint p2) internal view {
1257 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1258 	}
1259 
1260 	function log(bool p0, bool p1, string memory p2) internal view {
1261 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1262 	}
1263 
1264 	function log(bool p0, bool p1, bool p2) internal view {
1265 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1266 	}
1267 
1268 	function log(bool p0, bool p1, address p2) internal view {
1269 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1270 	}
1271 
1272 	function log(bool p0, address p1, uint p2) internal view {
1273 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1274 	}
1275 
1276 	function log(bool p0, address p1, string memory p2) internal view {
1277 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1278 	}
1279 
1280 	function log(bool p0, address p1, bool p2) internal view {
1281 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1282 	}
1283 
1284 	function log(bool p0, address p1, address p2) internal view {
1285 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1286 	}
1287 
1288 	function log(address p0, uint p1, uint p2) internal view {
1289 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1290 	}
1291 
1292 	function log(address p0, uint p1, string memory p2) internal view {
1293 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1294 	}
1295 
1296 	function log(address p0, uint p1, bool p2) internal view {
1297 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1298 	}
1299 
1300 	function log(address p0, uint p1, address p2) internal view {
1301 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1302 	}
1303 
1304 	function log(address p0, string memory p1, uint p2) internal view {
1305 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1306 	}
1307 
1308 	function log(address p0, string memory p1, string memory p2) internal view {
1309 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1310 	}
1311 
1312 	function log(address p0, string memory p1, bool p2) internal view {
1313 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1314 	}
1315 
1316 	function log(address p0, string memory p1, address p2) internal view {
1317 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1318 	}
1319 
1320 	function log(address p0, bool p1, uint p2) internal view {
1321 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1322 	}
1323 
1324 	function log(address p0, bool p1, string memory p2) internal view {
1325 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1326 	}
1327 
1328 	function log(address p0, bool p1, bool p2) internal view {
1329 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1330 	}
1331 
1332 	function log(address p0, bool p1, address p2) internal view {
1333 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1334 	}
1335 
1336 	function log(address p0, address p1, uint p2) internal view {
1337 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1338 	}
1339 
1340 	function log(address p0, address p1, string memory p2) internal view {
1341 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1342 	}
1343 
1344 	function log(address p0, address p1, bool p2) internal view {
1345 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1346 	}
1347 
1348 	function log(address p0, address p1, address p2) internal view {
1349 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1350 	}
1351 
1352 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1353 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1354 	}
1355 
1356 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1357 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1358 	}
1359 
1360 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1361 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1362 	}
1363 
1364 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1365 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1366 	}
1367 
1368 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1369 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1370 	}
1371 
1372 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1373 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1374 	}
1375 
1376 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1377 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1378 	}
1379 
1380 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1381 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1382 	}
1383 
1384 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1385 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1386 	}
1387 
1388 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1389 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1390 	}
1391 
1392 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1393 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1394 	}
1395 
1396 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1397 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1398 	}
1399 
1400 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1401 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1402 	}
1403 
1404 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1405 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1406 	}
1407 
1408 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1409 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1410 	}
1411 
1412 	function log(uint p0, uint p1, address p2, address p3) internal view {
1413 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1414 	}
1415 
1416 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1417 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1418 	}
1419 
1420 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1421 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1422 	}
1423 
1424 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1425 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1426 	}
1427 
1428 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1429 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1430 	}
1431 
1432 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1433 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1434 	}
1435 
1436 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1437 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1438 	}
1439 
1440 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1441 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1442 	}
1443 
1444 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1445 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1446 	}
1447 
1448 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1449 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1450 	}
1451 
1452 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1453 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1454 	}
1455 
1456 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1457 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1458 	}
1459 
1460 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1461 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1462 	}
1463 
1464 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1465 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1466 	}
1467 
1468 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1469 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1470 	}
1471 
1472 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1473 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1474 	}
1475 
1476 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1477 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1478 	}
1479 
1480 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1481 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1482 	}
1483 
1484 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1485 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1486 	}
1487 
1488 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1489 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1490 	}
1491 
1492 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1493 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1494 	}
1495 
1496 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1497 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1498 	}
1499 
1500 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1501 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1502 	}
1503 
1504 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1506 	}
1507 
1508 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1509 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1510 	}
1511 
1512 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1513 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1514 	}
1515 
1516 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1517 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1518 	}
1519 
1520 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1522 	}
1523 
1524 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1526 	}
1527 
1528 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1530 	}
1531 
1532 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1534 	}
1535 
1536 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1537 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1538 	}
1539 
1540 	function log(uint p0, bool p1, address p2, address p3) internal view {
1541 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1542 	}
1543 
1544 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1545 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1546 	}
1547 
1548 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1549 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1550 	}
1551 
1552 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1553 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1554 	}
1555 
1556 	function log(uint p0, address p1, uint p2, address p3) internal view {
1557 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1558 	}
1559 
1560 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1561 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1562 	}
1563 
1564 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1565 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1566 	}
1567 
1568 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1569 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1570 	}
1571 
1572 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1573 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1574 	}
1575 
1576 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1577 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1578 	}
1579 
1580 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1581 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1582 	}
1583 
1584 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1585 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1586 	}
1587 
1588 	function log(uint p0, address p1, bool p2, address p3) internal view {
1589 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1590 	}
1591 
1592 	function log(uint p0, address p1, address p2, uint p3) internal view {
1593 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1594 	}
1595 
1596 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1597 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1598 	}
1599 
1600 	function log(uint p0, address p1, address p2, bool p3) internal view {
1601 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1602 	}
1603 
1604 	function log(uint p0, address p1, address p2, address p3) internal view {
1605 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1606 	}
1607 
1608 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1609 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1610 	}
1611 
1612 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1613 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1614 	}
1615 
1616 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1617 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1618 	}
1619 
1620 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1621 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1622 	}
1623 
1624 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1625 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1626 	}
1627 
1628 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1629 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1630 	}
1631 
1632 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1633 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1634 	}
1635 
1636 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1637 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1638 	}
1639 
1640 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1641 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1642 	}
1643 
1644 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1645 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1646 	}
1647 
1648 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1649 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1650 	}
1651 
1652 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1653 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1654 	}
1655 
1656 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1657 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1658 	}
1659 
1660 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1662 	}
1663 
1664 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1666 	}
1667 
1668 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1670 	}
1671 
1672 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1674 	}
1675 
1676 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1678 	}
1679 
1680 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1682 	}
1683 
1684 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1686 	}
1687 
1688 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1690 	}
1691 
1692 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1694 	}
1695 
1696 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1698 	}
1699 
1700 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1702 	}
1703 
1704 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1706 	}
1707 
1708 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1710 	}
1711 
1712 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1714 	}
1715 
1716 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1718 	}
1719 
1720 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1722 	}
1723 
1724 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1726 	}
1727 
1728 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1730 	}
1731 
1732 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1734 	}
1735 
1736 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1738 	}
1739 
1740 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1742 	}
1743 
1744 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1746 	}
1747 
1748 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1750 	}
1751 
1752 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1754 	}
1755 
1756 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1758 	}
1759 
1760 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1762 	}
1763 
1764 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1766 	}
1767 
1768 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1770 	}
1771 
1772 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1774 	}
1775 
1776 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1778 	}
1779 
1780 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1782 	}
1783 
1784 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1786 	}
1787 
1788 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1790 	}
1791 
1792 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1794 	}
1795 
1796 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1798 	}
1799 
1800 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1802 	}
1803 
1804 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1806 	}
1807 
1808 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1810 	}
1811 
1812 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1814 	}
1815 
1816 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1818 	}
1819 
1820 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1821 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1822 	}
1823 
1824 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1825 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1826 	}
1827 
1828 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1829 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1830 	}
1831 
1832 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1833 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1834 	}
1835 
1836 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1837 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1838 	}
1839 
1840 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1841 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1842 	}
1843 
1844 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1845 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1846 	}
1847 
1848 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1849 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1850 	}
1851 
1852 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1853 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1854 	}
1855 
1856 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1857 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1858 	}
1859 
1860 	function log(string memory p0, address p1, address p2, address p3) internal view {
1861 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1862 	}
1863 
1864 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1865 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1866 	}
1867 
1868 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1869 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1870 	}
1871 
1872 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1873 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1874 	}
1875 
1876 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1877 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1878 	}
1879 
1880 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1881 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1882 	}
1883 
1884 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1885 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1886 	}
1887 
1888 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1890 	}
1891 
1892 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1894 	}
1895 
1896 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1898 	}
1899 
1900 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1902 	}
1903 
1904 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1906 	}
1907 
1908 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1910 	}
1911 
1912 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1914 	}
1915 
1916 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1918 	}
1919 
1920 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1922 	}
1923 
1924 	function log(bool p0, uint p1, address p2, address p3) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1926 	}
1927 
1928 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1930 	}
1931 
1932 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1934 	}
1935 
1936 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1938 	}
1939 
1940 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1942 	}
1943 
1944 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1946 	}
1947 
1948 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1950 	}
1951 
1952 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1954 	}
1955 
1956 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1958 	}
1959 
1960 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1961 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1962 	}
1963 
1964 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1965 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1966 	}
1967 
1968 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1969 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1970 	}
1971 
1972 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1973 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1974 	}
1975 
1976 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1977 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1978 	}
1979 
1980 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1981 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1982 	}
1983 
1984 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1985 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1986 	}
1987 
1988 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1989 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1990 	}
1991 
1992 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1993 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1994 	}
1995 
1996 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1997 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1998 	}
1999 
2000 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2001 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2002 	}
2003 
2004 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2005 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2006 	}
2007 
2008 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2009 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2010 	}
2011 
2012 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2013 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2014 	}
2015 
2016 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2017 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2018 	}
2019 
2020 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2021 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2022 	}
2023 
2024 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2025 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2026 	}
2027 
2028 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2029 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2030 	}
2031 
2032 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2033 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2034 	}
2035 
2036 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2037 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2038 	}
2039 
2040 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2041 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2042 	}
2043 
2044 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2045 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2046 	}
2047 
2048 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2049 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2050 	}
2051 
2052 	function log(bool p0, bool p1, address p2, address p3) internal view {
2053 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2054 	}
2055 
2056 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2057 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2058 	}
2059 
2060 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2061 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2062 	}
2063 
2064 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2065 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2066 	}
2067 
2068 	function log(bool p0, address p1, uint p2, address p3) internal view {
2069 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2070 	}
2071 
2072 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2073 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2074 	}
2075 
2076 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2077 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2078 	}
2079 
2080 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2081 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2082 	}
2083 
2084 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2085 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2086 	}
2087 
2088 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2089 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2090 	}
2091 
2092 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2093 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2094 	}
2095 
2096 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2097 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2098 	}
2099 
2100 	function log(bool p0, address p1, bool p2, address p3) internal view {
2101 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2102 	}
2103 
2104 	function log(bool p0, address p1, address p2, uint p3) internal view {
2105 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2106 	}
2107 
2108 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2109 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2110 	}
2111 
2112 	function log(bool p0, address p1, address p2, bool p3) internal view {
2113 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2114 	}
2115 
2116 	function log(bool p0, address p1, address p2, address p3) internal view {
2117 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2118 	}
2119 
2120 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2121 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2122 	}
2123 
2124 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2125 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2126 	}
2127 
2128 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2129 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2130 	}
2131 
2132 	function log(address p0, uint p1, uint p2, address p3) internal view {
2133 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2134 	}
2135 
2136 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2137 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2138 	}
2139 
2140 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2141 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2142 	}
2143 
2144 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2145 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2146 	}
2147 
2148 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2149 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2150 	}
2151 
2152 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2153 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2154 	}
2155 
2156 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2157 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2158 	}
2159 
2160 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2161 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2162 	}
2163 
2164 	function log(address p0, uint p1, bool p2, address p3) internal view {
2165 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2166 	}
2167 
2168 	function log(address p0, uint p1, address p2, uint p3) internal view {
2169 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2170 	}
2171 
2172 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2173 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2174 	}
2175 
2176 	function log(address p0, uint p1, address p2, bool p3) internal view {
2177 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2178 	}
2179 
2180 	function log(address p0, uint p1, address p2, address p3) internal view {
2181 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2182 	}
2183 
2184 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2185 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2186 	}
2187 
2188 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2189 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2190 	}
2191 
2192 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2193 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2194 	}
2195 
2196 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2197 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2198 	}
2199 
2200 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2201 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2202 	}
2203 
2204 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2205 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2206 	}
2207 
2208 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2209 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2210 	}
2211 
2212 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2213 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2214 	}
2215 
2216 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2217 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2218 	}
2219 
2220 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2221 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2222 	}
2223 
2224 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2225 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2226 	}
2227 
2228 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2229 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2230 	}
2231 
2232 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2233 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2234 	}
2235 
2236 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2237 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2238 	}
2239 
2240 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2241 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2242 	}
2243 
2244 	function log(address p0, string memory p1, address p2, address p3) internal view {
2245 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2246 	}
2247 
2248 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2249 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2250 	}
2251 
2252 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2253 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2254 	}
2255 
2256 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2257 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2258 	}
2259 
2260 	function log(address p0, bool p1, uint p2, address p3) internal view {
2261 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2262 	}
2263 
2264 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2265 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2266 	}
2267 
2268 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2269 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2270 	}
2271 
2272 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2273 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2274 	}
2275 
2276 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2277 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2278 	}
2279 
2280 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2281 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2282 	}
2283 
2284 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2285 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2286 	}
2287 
2288 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2289 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2290 	}
2291 
2292 	function log(address p0, bool p1, bool p2, address p3) internal view {
2293 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2294 	}
2295 
2296 	function log(address p0, bool p1, address p2, uint p3) internal view {
2297 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2298 	}
2299 
2300 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2301 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2302 	}
2303 
2304 	function log(address p0, bool p1, address p2, bool p3) internal view {
2305 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2306 	}
2307 
2308 	function log(address p0, bool p1, address p2, address p3) internal view {
2309 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2310 	}
2311 
2312 	function log(address p0, address p1, uint p2, uint p3) internal view {
2313 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2314 	}
2315 
2316 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2317 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2318 	}
2319 
2320 	function log(address p0, address p1, uint p2, bool p3) internal view {
2321 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2322 	}
2323 
2324 	function log(address p0, address p1, uint p2, address p3) internal view {
2325 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2326 	}
2327 
2328 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2329 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2330 	}
2331 
2332 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2333 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2334 	}
2335 
2336 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2337 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2338 	}
2339 
2340 	function log(address p0, address p1, string memory p2, address p3) internal view {
2341 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2342 	}
2343 
2344 	function log(address p0, address p1, bool p2, uint p3) internal view {
2345 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2346 	}
2347 
2348 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2349 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2350 	}
2351 
2352 	function log(address p0, address p1, bool p2, bool p3) internal view {
2353 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2354 	}
2355 
2356 	function log(address p0, address p1, bool p2, address p3) internal view {
2357 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2358 	}
2359 
2360 	function log(address p0, address p1, address p2, uint p3) internal view {
2361 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2362 	}
2363 
2364 	function log(address p0, address p1, address p2, string memory p3) internal view {
2365 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2366 	}
2367 
2368 	function log(address p0, address p1, address p2, bool p3) internal view {
2369 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2370 	}
2371 
2372 	function log(address p0, address p1, address p2, address p3) internal view {
2373 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2374 	}
2375 
2376 }
2377 
2378 // decore Vault distributes fees equally amongst staked pools
2379 // Have fun reading it. Hopefully it's bug-free. God bless.
2380 contract decoreVault is OwnableUpgradeSafe {
2381     using SafeMath for uint256;
2382     using SafeERC20 for IERC20;
2383 
2384     // Info of each user.
2385     struct UserInfo {
2386         uint256 amount; // How many  tokens the user has provided.
2387         uint256 rewardDebt; // Reward debt. See explanation below.
2388         //
2389         // We do some fancy math here. Basically, any point in time, the amount of decores
2390         // entitled to a user but is pending to be distributed is:
2391         //
2392         //   pending reward = (user.amount * pool.accdecorePerShare) - user.rewardDebt
2393         //
2394         // Whenever a user deposits or withdraws  tokens to a pool. Here's what happens:
2395         //   1. The pool's `accdecorePerShare` (and `lastRewardBlock`) gets updated.
2396         //   2. User receives the pending reward sent to his/her address.
2397         //   3. User's `amount` gets updated.
2398         //   4. User's `rewardDebt` gets updated.
2399 
2400     }
2401 
2402     // Info of each pool.
2403     struct PoolInfo {
2404         IERC20 token; // Address of  token contract.
2405         uint256 allocPoint; // How many allocation points assigned to this pool. decores to distribute per block.
2406         uint256 accdecorePerShare; // Accumulated decores per share, times 1e12. See below.
2407         bool withdrawable; // Is this pool withdrawable?
2408         mapping(address => mapping(address => uint256)) allowance;
2409 
2410     }
2411 
2412     // The decore TOKEN!
2413     INBUNIERC20 public decore;
2414     // Dev address.
2415     address public devaddr;
2416 
2417     // Info of each pool.
2418     PoolInfo[] public poolInfo;
2419     // Info of each user that stakes  tokens.
2420     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
2421     // Total allocation poitns. Must be the sum of all allocation points in all pools.
2422     uint256 public totalAllocPoint;
2423 
2424     //// pending rewards awaiting anyone to massUpdate
2425     uint256 public pendingRewards;
2426 
2427     uint256 public contractStartBlock;
2428     uint256 public epochCalculationStartBlock;
2429     uint256 public cumulativeRewardsSinceStart;
2430     uint256 public rewardsInThisEpoch;
2431     uint public epoch;
2432 
2433     // Returns fees generated since start of this contract
2434     function averageFeesPerBlockSinceStart() external view returns (uint averagePerBlock) {
2435         averagePerBlock = cumulativeRewardsSinceStart.add(rewardsInThisEpoch).div(block.number.sub(contractStartBlock));
2436     }
2437 
2438     // Returns averge fees in this epoch
2439     function averageFeesPerBlockEpoch() external view returns (uint256 averagePerBlock) {
2440         averagePerBlock = rewardsInThisEpoch.div(block.number.sub(epochCalculationStartBlock));
2441     }
2442 
2443     // For easy graphing historical epoch rewards
2444     mapping(uint => uint256) public epochRewards;
2445 
2446     //Starts a new calculation epoch
2447     // Because averge since start will not be accurate
2448     function startNewEpoch() public {
2449         require(epochCalculationStartBlock + 50000 < block.number, "New epoch not ready yet"); // About a week
2450         epochRewards[epoch] = rewardsInThisEpoch;
2451         cumulativeRewardsSinceStart = cumulativeRewardsSinceStart.add(rewardsInThisEpoch);
2452         rewardsInThisEpoch = 0;
2453         epochCalculationStartBlock = block.number;
2454         ++epoch;
2455     }
2456 
2457     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
2458     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
2459     event EmergencyWithdraw(
2460         address indexed user,
2461         uint256 indexed pid,
2462         uint256 amount
2463     );
2464     event Approval(address indexed owner, address indexed spender, uint256 _pid, uint256 value);
2465 
2466 
2467     function initialize(
2468         INBUNIERC20 _decore,
2469         address _devaddr,
2470         address superAdmin
2471     ) public initializer {
2472         OwnableUpgradeSafe.__Ownable_init();
2473         DEV_FEE = 1000;
2474         decore = _decore;
2475         devaddr = _devaddr;
2476         contractStartBlock = block.number;
2477         _superAdmin = superAdmin;
2478     }
2479 
2480     function poolLength() external view returns (uint256) {
2481         return poolInfo.length;
2482     }
2483 
2484 
2485 
2486     // Add a new token pool. Can only be called by the owner.
2487     // Note contract owner is meant to be a governance contract allowing decore governance consensus
2488     function add(
2489         uint256 _allocPoint,
2490         IERC20 _token,
2491         bool _withUpdate,
2492         bool _withdrawable
2493     ) public onlyOwner {
2494         if (_withUpdate) {
2495             massUpdatePools();
2496         }
2497 
2498         uint256 length = poolInfo.length;
2499         for (uint256 pid = 0; pid < length; ++pid) {
2500             require(poolInfo[pid].token != _token,"Error pool already added");
2501         }
2502 
2503         totalAllocPoint = totalAllocPoint.add(_allocPoint);
2504 
2505 
2506         poolInfo.push(
2507             PoolInfo({
2508                 token: _token,
2509                 allocPoint: _allocPoint,
2510                 accdecorePerShare: 0,
2511                 withdrawable : _withdrawable
2512             })
2513         );
2514     }
2515 
2516     // Update the given pool's decores allocation point. Can only be called by the owner.
2517         // Note contract owner is meant to be a governance contract allowing decore governance consensus
2518 
2519     function set(
2520         uint256 _pid,
2521         uint256 _allocPoint,
2522         bool _withUpdate
2523     ) public onlyOwner {
2524         if (_withUpdate) {
2525             massUpdatePools();
2526         }
2527 
2528         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
2529             _allocPoint
2530         );
2531         poolInfo[_pid].allocPoint = _allocPoint;
2532     }
2533 
2534     // Update the given pool's ability to withdraw tokens
2535     // Note contract owner is meant to be a governance contract allowing decore governance consensus
2536     function setPoolWithdrawable(
2537         uint256 _pid,
2538         bool _withdrawable
2539     ) public onlyOwner {
2540         poolInfo[_pid].withdrawable = _withdrawable;
2541     }
2542 
2543 
2544 
2545     // Sets the dev fee for this contract
2546     // defaults at 7.24%
2547     // Note contract owner is meant to be a governance contract allowing decore governance consensus
2548     uint16 DEV_FEE;
2549     function setDevFee(uint16 _DEV_FEE) public onlyOwner {
2550         require(_DEV_FEE <= 1000, 'Dev fee clamped at 10%');
2551         DEV_FEE = _DEV_FEE;
2552     }
2553     uint256 pending_DEV_rewards;
2554 
2555 
2556     // View function to see pending decores on frontend.
2557     function pendingdecore(uint256 _pid, address _user)
2558         external
2559         view
2560         returns (uint256)
2561     {
2562         PoolInfo storage pool = poolInfo[_pid];
2563         UserInfo storage user = userInfo[_pid][_user];
2564         uint256 accdecorePerShare = pool.accdecorePerShare;
2565 
2566         return user.amount.mul(accdecorePerShare).div(1e12).sub(user.rewardDebt);
2567     }
2568 
2569     // Update reward vairables for all pools. Be careful of gas spending!
2570     function massUpdatePools() public {
2571         console.log("Mass Updating Pools");
2572         uint256 length = poolInfo.length;
2573         uint allRewards;
2574         for (uint256 pid = 0; pid < length; ++pid) {
2575             allRewards = allRewards.add(updatePool(pid));
2576         }
2577 
2578         pendingRewards = pendingRewards.sub(allRewards);
2579     }
2580 
2581     // ----
2582     // Function that adds pending rewards, called by the decore token.
2583     // ----
2584     uint256 private decoreBalance;
2585     function addPendingRewards(uint256 _) public {
2586         uint256 newRewards = decore.balanceOf(address(this)).sub(decoreBalance);
2587 
2588         if(newRewards > 0) {
2589             decoreBalance = decore.balanceOf(address(this)); // If there is no change the balance didn't change
2590             pendingRewards = pendingRewards.add(newRewards);
2591             rewardsInThisEpoch = rewardsInThisEpoch.add(newRewards);
2592         }
2593     }
2594 
2595     // Update reward variables of the given pool to be up-to-date.
2596     function updatePool(uint256 _pid) internal returns (uint256 decoreRewardWhole) {
2597         PoolInfo storage pool = poolInfo[_pid];
2598 
2599         uint256 tokenSupply = pool.token.balanceOf(address(this));
2600         if (tokenSupply == 0) { // avoids division by 0 errors
2601             return 0;
2602         }
2603         decoreRewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
2604             .mul(pool.allocPoint)        // getting the percent of total pending rewards this pool should get
2605             .div(totalAllocPoint);       // we can do this because pools are only mass updated
2606         uint256 decoreRewardFee = decoreRewardWhole.mul(DEV_FEE).div(10000);
2607         uint256 decoreRewardToDistribute = decoreRewardWhole.sub(decoreRewardFee);
2608 
2609         pending_DEV_rewards = pending_DEV_rewards.add(decoreRewardFee);
2610 
2611         pool.accdecorePerShare = pool.accdecorePerShare.add(
2612             decoreRewardToDistribute.mul(1e12).div(tokenSupply)
2613         );
2614 
2615     }
2616 
2617     // Deposit  tokens to decoreVault for decore allocation.
2618     function deposit(uint256 _pid, uint256 _amount) public {
2619 
2620         PoolInfo storage pool = poolInfo[_pid];
2621         UserInfo storage user = userInfo[_pid][msg.sender];
2622 
2623         massUpdatePools();
2624 
2625         // Transfer pending tokens
2626         // to user
2627         updateAndPayOutPending(_pid, pool, user, msg.sender);
2628 
2629 
2630         //Transfer in the amounts from user
2631         // save gas
2632         if(_amount > 0) {
2633             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
2634             user.amount = user.amount.add(_amount);
2635         }
2636 
2637         user.rewardDebt = user.amount.mul(pool.accdecorePerShare).div(1e12);
2638         emit Deposit(msg.sender, _pid, _amount);
2639     }
2640 
2641     // Test coverage
2642     // [x] Does user get the deposited amounts?
2643     // [x] Does user that its deposited for update correcty?
2644     // [x] Does the depositor get their tokens decreased
2645     function depositFor(address depositFor, uint256 _pid, uint256 _amount) public {
2646         // requires no allowances
2647         PoolInfo storage pool = poolInfo[_pid];
2648         UserInfo storage user = userInfo[_pid][depositFor];
2649 
2650         massUpdatePools();
2651 
2652         // Transfer pending tokens
2653         // to user
2654         updateAndPayOutPending(_pid, pool, user, depositFor); // Update the balances of person that amount is being deposited for
2655 
2656         if(_amount > 0) {
2657             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
2658             user.amount = user.amount.add(_amount); // This is depositedFor address
2659         }
2660 
2661         user.rewardDebt = user.amount.mul(pool.accdecorePerShare).div(1e12); /// This is deposited for address
2662         emit Deposit(depositFor, _pid, _amount);
2663 
2664     }
2665 
2666     // Test coverage
2667     // [x] Does allowance update correctly?
2668     function setAllowanceForPoolToken(address spender, uint256 _pid, uint256 value) public {
2669         PoolInfo storage pool = poolInfo[_pid];
2670         pool.allowance[msg.sender][spender] = value;
2671         emit Approval(msg.sender, spender, _pid, value);
2672     }
2673 
2674     // Test coverage
2675     // [x] Does allowance decrease?
2676     // [x] Do oyu need allowance
2677     // [x] Withdraws to correct address
2678     function withdrawFrom(address owner, uint256 _pid, uint256 _amount) public{
2679 
2680         PoolInfo storage pool = poolInfo[_pid];
2681         require(pool.allowance[owner][msg.sender] >= _amount, "withdraw: insufficient allowance");
2682         pool.allowance[owner][msg.sender] = pool.allowance[owner][msg.sender].sub(_amount);
2683         _withdraw(_pid, _amount, owner, msg.sender);
2684 
2685     }
2686 
2687 
2688     // Withdraw  tokens from decoreVault.
2689     function withdraw(uint256 _pid, uint256 _amount) public {
2690 
2691         _withdraw(_pid, _amount, msg.sender, msg.sender);
2692 
2693     }
2694 
2695 
2696 
2697 
2698     // Low level withdraw function
2699     function _withdraw(uint256 _pid, uint256 _amount, address from, address to) internal {
2700         PoolInfo storage pool = poolInfo[_pid];
2701         require(pool.withdrawable, "Withdrawing from this pool is disabled");
2702         UserInfo storage user = userInfo[_pid][from];
2703         require(user.amount >= _amount, "withdraw: not good");
2704 
2705         massUpdatePools();
2706         updateAndPayOutPending(_pid,  pool, user, from); // Update balances of from this is not withdrawal but claiming decore farmed
2707 
2708         if(_amount > 0) {
2709             user.amount = user.amount.sub(_amount);
2710             pool.token.safeTransfer(address(to), _amount);
2711         }
2712         user.rewardDebt = user.amount.mul(pool.accdecorePerShare).div(1e12);
2713 
2714         emit Withdraw(to, _pid, _amount);
2715     }
2716 
2717     function claim(uint256 _pid) public {
2718         PoolInfo storage pool = poolInfo[_pid];
2719         require(pool.withdrawable, "Withdrawing from this pool is disabled");
2720         UserInfo storage user = userInfo[_pid][msg.sender];
2721         
2722         massUpdatePools();
2723         updateAndPayOutPending(_pid, pool, user, msg.sender);
2724     }
2725 
2726     function updateAndPayOutPending(uint256 _pid, PoolInfo storage pool, UserInfo storage user, address from) internal {
2727 
2728         if(user.amount == 0) return;
2729 
2730         uint256 pending = user
2731             .amount
2732             .mul(pool.accdecorePerShare)
2733             .div(1e12)
2734             .sub(user.rewardDebt);
2735 
2736         if(pending > 0) {
2737             safedecoreTransfer(from, pending);
2738         }
2739 
2740     }
2741 
2742     // function that lets owner/governance contract
2743     // approve allowance for any token inside this contract
2744     // This means all future UNI like airdrops are covered
2745     // And at the same time allows us to give allowance to strategy contracts.
2746     // Upcoming cYFI etc vaults strategy contracts will  se this function to manage and farm yield on value locked
2747     function setStrategyContractOrDistributionContractAllowance(address tokenAddress, uint256 _amount, address contractAddress) public onlySuperAdmin {
2748         require(isContract(contractAddress), "Recipent is not a smart contract, BAD");
2749         require(block.number > contractStartBlock.add(95_000), "Governance setup grace period not over"); // about 2weeks
2750         IERC20(tokenAddress).approve(contractAddress, _amount);
2751     }
2752 
2753     function isContract(address addr) public returns (bool) {
2754         uint size;
2755         assembly { size := extcodesize(addr) }
2756         return size > 0;
2757     }
2758 
2759 
2760 
2761 
2762 
2763     // Withdraw without caring about rewards. EMERGENCY ONLY.
2764     // !Caution this will remove all your pending rewards!
2765     function emergencyWithdraw(uint256 _pid) public {
2766         PoolInfo storage pool = poolInfo[_pid];
2767         require(pool.withdrawable, "Withdrawing from this pool is disabled");
2768         UserInfo storage user = userInfo[_pid][msg.sender];
2769         pool.token.safeTransfer(address(msg.sender), user.amount);
2770         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
2771         user.amount = 0;
2772         user.rewardDebt = 0;
2773         // No mass update dont update pending rewards
2774     }
2775 
2776     // Safe decore transfer function, just in case if rounding error causes pool to not have enough decores.
2777     function safedecoreTransfer(address _to, uint256 _amount) internal {
2778         if(_amount == 0) return;
2779 
2780         uint256 decoreBal = decore.balanceOf(address(this));
2781         if (_amount > decoreBal) {
2782             console.log("transfering out for to person:", _amount);
2783             console.log("Balance of this address is :", decoreBal);
2784 
2785             decore.transfer(_to, decoreBal);
2786             decoreBalance = decore.balanceOf(address(this));
2787 
2788         } else {
2789             decore.transfer(_to, _amount);
2790             decoreBalance = decore.balanceOf(address(this));
2791 
2792         }
2793 
2794         if(pending_DEV_rewards > 0) {
2795             uint256 devSend = pending_DEV_rewards; // Avoid recursive loop
2796             pending_DEV_rewards = 0;
2797             safedecoreTransfer(devaddr, devSend);
2798         }
2799 
2800     }
2801 
2802     // Update dev address by the previous dev.
2803     // Note onlyOwner functions are meant for the governance contract
2804     // allowing decore governance token holders to do this functions.
2805     function setDevFeeReciever(address _devaddr) public onlyOwner {
2806         devaddr = _devaddr;
2807     }
2808 
2809 
2810 
2811     address private _superAdmin;
2812 
2813     event SuperAdminTransfered(address indexed previousOwner, address indexed newOwner);
2814 
2815 
2816 
2817     /**
2818      * @dev Returns the address of the current super admin
2819      */
2820     function superAdmin() public view returns (address) {
2821         return _superAdmin;
2822     }
2823 
2824     /**
2825      * @dev Throws if called by any account other than the superAdmin
2826      */
2827     modifier onlySuperAdmin() {
2828         require(_superAdmin == _msgSender(), "Super admin : caller is not super admin.");
2829         _;
2830     }
2831 
2832     // Assisns super admint to address 0, making it unreachable forever
2833     function burnSuperAdmin() public virtual onlySuperAdmin {
2834         emit SuperAdminTransfered(_superAdmin, address(0));
2835         _superAdmin = address(0);
2836     }
2837 
2838     // Super admin can transfer its powers to another address
2839     function newSuperAdmin(address newOwner) public virtual onlySuperAdmin {
2840         require(newOwner != address(0), "Ownable: new owner is the zero address");
2841         emit SuperAdminTransfered(_superAdmin, newOwner);
2842         _superAdmin = newOwner;
2843     }
2844 }