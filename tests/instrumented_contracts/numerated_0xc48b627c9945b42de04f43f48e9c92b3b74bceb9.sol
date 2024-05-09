1 pragma solidity 0.6.12;
2 
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2020-10-01
6 */
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
81 /**
82  * @dev Wrappers over Solidity's arithmetic operations with added overflow
83  * checks.
84  *
85  * Arithmetic operations in Solidity wrap on overflow. This can easily result
86  * in bugs, because programmers usually assume that an overflow raises an
87  * error, which is the standard behavior in high level programming languages.
88  * `SafeMath` restores this intuition by reverting the transaction when an
89  * operation overflows.
90  *
91  * Using this library instead of the unchecked operations eliminates an entire
92  * class of bugs, so it's recommended to use it always.
93  */
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
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
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         // Solidity only automatically asserts when dividing by 0
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts with custom message when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
253         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
254         // for accounts without code, i.e. `keccak256('')`
255         bytes32 codehash;
256         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
257         // solhint-disable-next-line no-inline-assembly
258         assembly { codehash := extcodehash(account) }
259         return (codehash != accountHash && codehash != 0x0);
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
282         (bool success, ) = recipient.call{ value: amount }("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 }
286 
287 /**
288  * @title SafeERC20
289  * @dev Wrappers around ERC20 operations that throw on failure (when the token
290  * contract returns false). Tokens that return no value (and instead revert or
291  * throw on failure) are also supported, non-reverting calls are assumed to be
292  * successful.
293  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
294  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
295  */
296 library SafeERC20 {
297     using SafeMath for uint256;
298     using Address for address;
299 
300     function safeTransfer(IERC20 token, address to, uint256 value) internal {
301         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
302     }
303 
304     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
305         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
306     }
307 
308     function safeApprove(IERC20 token, address spender, uint256 value) internal {
309         // safeApprove should only be called when setting an initial allowance,
310         // or when resetting it to zero. To increase and decrease it, use
311         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
312         // solhint-disable-next-line max-line-length
313         require((value == 0) || (token.allowance(address(this), spender) == 0),
314             "SafeERC20: approve from non-zero to non-zero allowance"
315         );
316         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
317     }
318 
319     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
320         uint256 newAllowance = token.allowance(address(this), spender).add(value);
321         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
322     }
323 
324     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
325         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
326         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
327     }
328 
329     /**
330      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
331      * on the return value: the return value is optional (but if data is returned, it must not be false).
332      * @param token The token targeted by the call.
333      * @param data The call data (encoded using abi.encode or one of its variants).
334      */
335     function _callOptionalReturn(IERC20 token, bytes memory data) private {
336         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
337         // we're implementing it ourselves.
338 
339         // A Solidity high level call has three parts:
340         //  1. The target address is checked to verify it contains contract code
341         //  2. The call itself is made, and success asserted
342         //  3. The return value is decoded, which in turn checks the size of the returned data.
343         // solhint-disable-next-line max-line-length
344         require(address(token).isContract(), "SafeERC20: call to non-contract");
345 
346         // solhint-disable-next-line avoid-low-level-calls
347         (bool success, bytes memory returndata) = address(token).call(data);
348         require(success, "SafeERC20: low-level call failed");
349 
350         if (returndata.length > 0) { // Return data is optional
351             // solhint-disable-next-line max-line-length
352             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
353         }
354     }
355 }
356 
357 /**
358  * @dev Library for managing
359  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
360  * types.
361  *
362  * Sets have the following properties:
363  *
364  * - Elements are added, removed, and checked for existence in constant time
365  * (O(1)).
366  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
367  *
368  * ```
369  * contract Example {
370  *     // Add the library methods
371  *     using EnumerableSet for EnumerableSet.AddressSet;
372  *
373  *     // Declare a set state variable
374  *     EnumerableSet.AddressSet private mySet;
375  * }
376  * ```
377  *
378  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
379  * (`UintSet`) are supported.
380  */
381 library EnumerableSet {
382     // To implement this library for multiple types with as little code
383     // repetition as possible, we write it in terms of a generic Set type with
384     // bytes32 values.
385     // The Set implementation uses private functions, and user-facing
386     // implementations (such as AddressSet) are just wrappers around the
387     // underlying Set.
388     // This means that we can only create new EnumerableSets for types that fit
389     // in bytes32.
390 
391     struct Set {
392         // Storage of set values
393         bytes32[] _values;
394 
395         // Position of the value in the `values` array, plus 1 because index 0
396         // means a value is not in the set.
397         mapping (bytes32 => uint256) _indexes;
398     }
399 
400     /**
401      * @dev Add a value to a set. O(1).
402      *
403      * Returns true if the value was added to the set, that is if it was not
404      * already present.
405      */
406     function _add(Set storage set, bytes32 value) private returns (bool) {
407         if (!_contains(set, value)) {
408             set._values.push(value);
409             // The value is stored at length-1, but we add 1 to all indexes
410             // and use 0 as a sentinel value
411             set._indexes[value] = set._values.length;
412             return true;
413         } else {
414             return false;
415         }
416     }
417 
418     /**
419      * @dev Removes a value from a set. O(1).
420      *
421      * Returns true if the value was removed from the set, that is if it was
422      * present.
423      */
424     function _remove(Set storage set, bytes32 value) private returns (bool) {
425         // We read and store the value's index to prevent multiple reads from the same storage slot
426         uint256 valueIndex = set._indexes[value];
427 
428         if (valueIndex != 0) { // Equivalent to contains(set, value)
429             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
430             // the array, and then remove the last element (sometimes called as 'swap and pop').
431             // This modifies the order of the array, as noted in {at}.
432 
433             uint256 toDeleteIndex = valueIndex - 1;
434             uint256 lastIndex = set._values.length - 1;
435 
436             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
437             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
438 
439             bytes32 lastvalue = set._values[lastIndex];
440 
441             // Move the last value to the index where the value to delete is
442             set._values[toDeleteIndex] = lastvalue;
443             // Update the index for the moved value
444             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
445 
446             // Delete the slot where the moved value was stored
447             set._values.pop();
448 
449             // Delete the index for the deleted slot
450             delete set._indexes[value];
451 
452             return true;
453         } else {
454             return false;
455         }
456     }
457 
458     /**
459      * @dev Returns true if the value is in the set. O(1).
460      */
461     function _contains(Set storage set, bytes32 value) private view returns (bool) {
462         return set._indexes[value] != 0;
463     }
464 
465     /**
466      * @dev Returns the number of values on the set. O(1).
467      */
468     function _length(Set storage set) private view returns (uint256) {
469         return set._values.length;
470     }
471 
472    /**
473     * @dev Returns the value stored at position `index` in the set. O(1).
474     *
475     * Note that there are no guarantees on the ordering of values inside the
476     * array, and it may change when more values are added or removed.
477     *
478     * Requirements:
479     *
480     * - `index` must be strictly less than {length}.
481     */
482     function _at(Set storage set, uint256 index) private view returns (bytes32) {
483         require(set._values.length > index, "EnumerableSet: index out of bounds");
484         return set._values[index];
485     }
486 
487     // AddressSet
488 
489     struct AddressSet {
490         Set _inner;
491     }
492 
493     /**
494      * @dev Add a value to a set. O(1).
495      *
496      * Returns true if the value was added to the set, that is if it was not
497      * already present.
498      */
499     function add(AddressSet storage set, address value) internal returns (bool) {
500         return _add(set._inner, bytes32(uint256(value)));
501     }
502 
503     /**
504      * @dev Removes a value from a set. O(1).
505      *
506      * Returns true if the value was removed from the set, that is if it was
507      * present.
508      */
509     function remove(AddressSet storage set, address value) internal returns (bool) {
510         return _remove(set._inner, bytes32(uint256(value)));
511     }
512 
513     /**
514      * @dev Returns true if the value is in the set. O(1).
515      */
516     function contains(AddressSet storage set, address value) internal view returns (bool) {
517         return _contains(set._inner, bytes32(uint256(value)));
518     }
519 
520     /**
521      * @dev Returns the number of values in the set. O(1).
522      */
523     function length(AddressSet storage set) internal view returns (uint256) {
524         return _length(set._inner);
525     }
526 
527    /**
528     * @dev Returns the value stored at position `index` in the set. O(1).
529     *
530     * Note that there are no guarantees on the ordering of values inside the
531     * array, and it may change when more values are added or removed.
532     *
533     * Requirements:
534     *
535     * - `index` must be strictly less than {length}.
536     */
537     function at(AddressSet storage set, uint256 index) internal view returns (address) {
538         return address(uint256(_at(set._inner, index)));
539     }
540 
541 
542     // UintSet
543 
544     struct UintSet {
545         Set _inner;
546     }
547 
548     /**
549      * @dev Add a value to a set. O(1).
550      *
551      * Returns true if the value was added to the set, that is if it was not
552      * already present.
553      */
554     function add(UintSet storage set, uint256 value) internal returns (bool) {
555         return _add(set._inner, bytes32(value));
556     }
557 
558     /**
559      * @dev Removes a value from a set. O(1).
560      *
561      * Returns true if the value was removed from the set, that is if it was
562      * present.
563      */
564     function remove(UintSet storage set, uint256 value) internal returns (bool) {
565         return _remove(set._inner, bytes32(value));
566     }
567 
568     /**
569      * @dev Returns true if the value is in the set. O(1).
570      */
571     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
572         return _contains(set._inner, bytes32(value));
573     }
574 
575     /**
576      * @dev Returns the number of values on the set. O(1).
577      */
578     function length(UintSet storage set) internal view returns (uint256) {
579         return _length(set._inner);
580     }
581 
582    /**
583     * @dev Returns the value stored at position `index` in the set. O(1).
584     *
585     * Note that there are no guarantees on the ordering of values inside the
586     * array, and it may change when more values are added or removed.
587     *
588     * Requirements:
589     *
590     * - `index` must be strictly less than {length}.
591     */
592     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
593         return uint256(_at(set._inner, index));
594     }
595 }
596 
597 /**
598  * @title Initializable
599  *
600  * @dev Helper contract to support initializer functions. To use it, replace
601  * the constructor with a function that has the `initializer` modifier.
602  * WARNING: Unlike constructors, initializer functions must be manually
603  * invoked. This applies both to deploying an Initializable contract, as well
604  * as extending an Initializable contract via inheritance.
605  * WARNING: When used with inheritance, manual care must be taken to not invoke
606  * a parent initializer twice, or ensure that all initializers are idempotent,
607  * because this is not dealt with automatically as with constructors.
608  */
609 contract Initializable {
610 
611   /**
612    * @dev Indicates that the contract has been initialized.
613    */
614   bool private initialized;
615 
616   /**
617    * @dev Indicates that the contract is in the process of being initialized.
618    */
619   bool private initializing;
620 
621   /**
622    * @dev Modifier to use in the initializer function of a contract.
623    */
624   modifier initializer() {
625     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
626 
627     bool isTopLevelCall = !initializing;
628     if (isTopLevelCall) {
629       initializing = true;
630       initialized = true;
631     }
632 
633     _;
634 
635     if (isTopLevelCall) {
636       initializing = false;
637     }
638   }
639 
640   /// @dev Returns true if and only if the function is running in the constructor
641   function isConstructor() private view returns (bool) {
642     // extcodesize checks the size of the code stored in an address, and
643     // address returns the current address. Since the code is still not
644     // deployed when running a constructor, any checks on its code size will
645     // yield zero, making it an effective way to detect if a contract is
646     // under construction or not.
647     address self = address(this);
648     uint256 cs;
649     assembly { cs := extcodesize(self) }
650     return cs == 0;
651   }
652 
653   // Reserved storage space to allow for layout changes in the future.
654   uint256[50] private ______gap;
655 }
656 
657 /*
658  * @dev Provides information about the current execution context, including the
659  * sender of the transaction and its data. While these are generally available
660  * via msg.sender and msg.data, they should not be accessed in such a direct
661  * manner, since when dealing with GSN meta-transactions the account sending and
662  * paying for execution may not be the actual sender (as far as an application
663  * is concerned).
664  *
665  * This contract is only required for intermediate, library-like contracts.
666  */
667 contract ContextUpgradeSafe is Initializable {
668     // Empty internal constructor, to prevent people from mistakenly deploying
669     // an instance of this contract, which should be used via inheritance.
670 
671     function __Context_init() internal initializer {
672         __Context_init_unchained();
673     }
674 
675     function __Context_init_unchained() internal initializer {
676 
677 
678     }
679 
680 
681     function _msgSender() internal view virtual returns (address payable) {
682         return msg.sender;
683     }
684 
685     function _msgData() internal view virtual returns (bytes memory) {
686         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
687         return msg.data;
688     }
689 
690     uint256[50] private __gap;
691 }
692 
693 /**
694  * @dev Contract module which provides a basic access control mechanism, where
695  * there is an account (an owner) that can be granted exclusive access to
696  * specific functions.
697  *
698  * By default, the owner account will be the one that deploys the contract. This
699  * can later be changed with {transferOwnership}.
700  *
701  * This module is used through inheritance. It will make available the modifier
702  * `onlyOwner`, which can be applied to your functions to restrict their use to
703  * the owner.
704  */
705 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
706     address private _owner;
707 
708     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
709 
710     /**
711      * @dev Initializes the contract setting the deployer as the initial owner.
712      */
713 
714     function __Ownable_init() internal initializer {
715         __Context_init_unchained();
716         __Ownable_init_unchained();
717     }
718 
719     function __Ownable_init_unchained() internal initializer {
720 
721 
722         address msgSender = _msgSender();
723         _owner = msgSender;
724         emit OwnershipTransferred(address(0), msgSender);
725 
726     }
727 
728 
729     /**
730      * @dev Returns the address of the current owner.
731      */
732     function owner() public view returns (address) {
733         return _owner;
734     }
735 
736     /**
737      * @dev Throws if called by any account other than the owner.
738      */
739     modifier onlyOwner() {
740         require(_owner == _msgSender(), "Ownable: caller is not the owner");
741         _;
742     }
743 
744     /**
745      * @dev Leaves the contract without owner. It will not be possible to call
746      * `onlyOwner` functions anymore. Can only be called by the current owner.
747      *
748      * NOTE: Renouncing ownership will leave the contract without an owner,
749      * thereby removing any functionality that is only available to the owner.
750      */
751     function renounceOwnership() public virtual onlyOwner {
752         emit OwnershipTransferred(_owner, address(0));
753         _owner = address(0);
754     }
755 
756     /**
757      * @dev Transfers ownership of the contract to a new account (`newOwner`).
758      * Can only be called by the current owner.
759      */
760     function transferOwnership(address newOwner) public virtual onlyOwner {
761         require(newOwner != address(0), "Ownable: new owner is the zero address");
762         emit OwnershipTransferred(_owner, newOwner);
763         _owner = newOwner;
764     }
765 
766     uint256[49] private __gap;
767 }
768 
769 /**
770  * @dev Interface of the ERC20 standard as defined in the EIP.
771  */
772 interface INBUNIERC20 {
773     /**
774      * @dev Returns the amount of tokens in existence.
775      */
776     function totalSupply() external view returns (uint256);
777 
778     /**
779      * @dev Returns the amount of tokens owned by `account`.
780      */
781     function balanceOf(address account) external view returns (uint256);
782 
783     /**
784      * @dev Moves `amount` tokens from the caller's account to `recipient`.
785      *
786      * Returns a boolean value indicating whether the operation succeeded.
787      *
788      * Emits a {Transfer} event.
789      */
790     function transfer(address recipient, uint256 amount) external returns (bool);
791 
792     /**
793      * @dev Returns the remaining number of tokens that `spender` will be
794      * allowed to spend on behalf of `owner` through {transferFrom}. This is
795      * zero by default.
796      *
797      * This value changes when {approve} or {transferFrom} are called.
798      */
799     function allowance(address owner, address spender) external view returns (uint256);
800 
801     /**
802      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
803      *
804      * Returns a boolean value indicating whether the operation succeeded.
805      *
806      * IMPORTANT: Beware that changing an allowance with this method brings the risk
807      * that someone may use both the old and the new allowance by unfortunate
808      * transaction ordering. One possible solution to mitigate this race
809      * condition is to first reduce the spender's allowance to 0 and set the
810      * desired value afterwards:
811      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
812      *
813      * Emits an {Approval} event.
814      */
815     function approve(address spender, uint256 amount) external returns (bool);
816 
817     /**
818      * @dev Moves `amount` tokens from `sender` to `recipient` using the
819      * allowance mechanism. `amount` is then deducted from the caller's
820      * allowance.
821      *
822      * Returns a boolean value indicating whether the operation succeeded.
823      *
824      * Emits a {Transfer} event.
825      */
826     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
827 
828     /**
829      * @dev Emitted when `value` tokens are moved from one account (`from`) to
830      * another (`to`).
831      *
832      * Note that `value` may be zero.
833      */
834     event Transfer(address indexed from, address indexed to, uint256 value);
835 
836     /**
837      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
838      * a call to {approve}. `value` is the new allowance.
839      */
840     event Approval(address indexed owner, address indexed spender, uint256 value);
841 
842 
843     event Log(string log);
844 
845 }
846 
847 library console {
848 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
849 
850 	function _sendLogPayload(bytes memory payload) private view {
851 		uint256 payloadLength = payload.length;
852 		address consoleAddress = CONSOLE_ADDRESS;
853 		assembly {
854 			let payloadStart := add(payload, 32)
855 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
856 		}
857 	}
858 
859 	function log() internal view {
860 		_sendLogPayload(abi.encodeWithSignature("log()"));
861 	}
862 
863 	function logInt(int p0) internal view {
864 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
865 	}
866 
867 	function logUint(uint p0) internal view {
868 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
869 	}
870 
871 	function logString(string memory p0) internal view {
872 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
873 	}
874 
875 	function logBool(bool p0) internal view {
876 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
877 	}
878 
879 	function logAddress(address p0) internal view {
880 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
881 	}
882 
883 	function logBytes(bytes memory p0) internal view {
884 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
885 	}
886 
887 	function logByte(byte p0) internal view {
888 		_sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
889 	}
890 
891 	function logBytes1(bytes1 p0) internal view {
892 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
893 	}
894 
895 	function logBytes2(bytes2 p0) internal view {
896 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
897 	}
898 
899 	function logBytes3(bytes3 p0) internal view {
900 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
901 	}
902 
903 	function logBytes4(bytes4 p0) internal view {
904 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
905 	}
906 
907 	function logBytes5(bytes5 p0) internal view {
908 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
909 	}
910 
911 	function logBytes6(bytes6 p0) internal view {
912 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
913 	}
914 
915 	function logBytes7(bytes7 p0) internal view {
916 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
917 	}
918 
919 	function logBytes8(bytes8 p0) internal view {
920 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
921 	}
922 
923 	function logBytes9(bytes9 p0) internal view {
924 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
925 	}
926 
927 	function logBytes10(bytes10 p0) internal view {
928 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
929 	}
930 
931 	function logBytes11(bytes11 p0) internal view {
932 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
933 	}
934 
935 	function logBytes12(bytes12 p0) internal view {
936 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
937 	}
938 
939 	function logBytes13(bytes13 p0) internal view {
940 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
941 	}
942 
943 	function logBytes14(bytes14 p0) internal view {
944 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
945 	}
946 
947 	function logBytes15(bytes15 p0) internal view {
948 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
949 	}
950 
951 	function logBytes16(bytes16 p0) internal view {
952 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
953 	}
954 
955 	function logBytes17(bytes17 p0) internal view {
956 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
957 	}
958 
959 	function logBytes18(bytes18 p0) internal view {
960 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
961 	}
962 
963 	function logBytes19(bytes19 p0) internal view {
964 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
965 	}
966 
967 	function logBytes20(bytes20 p0) internal view {
968 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
969 	}
970 
971 	function logBytes21(bytes21 p0) internal view {
972 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
973 	}
974 
975 	function logBytes22(bytes22 p0) internal view {
976 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
977 	}
978 
979 	function logBytes23(bytes23 p0) internal view {
980 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
981 	}
982 
983 	function logBytes24(bytes24 p0) internal view {
984 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
985 	}
986 
987 	function logBytes25(bytes25 p0) internal view {
988 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
989 	}
990 
991 	function logBytes26(bytes26 p0) internal view {
992 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
993 	}
994 
995 	function logBytes27(bytes27 p0) internal view {
996 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
997 	}
998 
999 	function logBytes28(bytes28 p0) internal view {
1000 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1001 	}
1002 
1003 	function logBytes29(bytes29 p0) internal view {
1004 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1005 	}
1006 
1007 	function logBytes30(bytes30 p0) internal view {
1008 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1009 	}
1010 
1011 	function logBytes31(bytes31 p0) internal view {
1012 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1013 	}
1014 
1015 	function logBytes32(bytes32 p0) internal view {
1016 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1017 	}
1018 
1019 	function log(uint p0) internal view {
1020 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1021 	}
1022 
1023 	function log(string memory p0) internal view {
1024 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1025 	}
1026 
1027 	function log(bool p0) internal view {
1028 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1029 	}
1030 
1031 	function log(address p0) internal view {
1032 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1033 	}
1034 
1035 	function log(uint p0, uint p1) internal view {
1036 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1037 	}
1038 
1039 	function log(uint p0, string memory p1) internal view {
1040 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1041 	}
1042 
1043 	function log(uint p0, bool p1) internal view {
1044 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1045 	}
1046 
1047 	function log(uint p0, address p1) internal view {
1048 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1049 	}
1050 
1051 	function log(string memory p0, uint p1) internal view {
1052 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1053 	}
1054 
1055 	function log(string memory p0, string memory p1) internal view {
1056 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1057 	}
1058 
1059 	function log(string memory p0, bool p1) internal view {
1060 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1061 	}
1062 
1063 	function log(string memory p0, address p1) internal view {
1064 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1065 	}
1066 
1067 	function log(bool p0, uint p1) internal view {
1068 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1069 	}
1070 
1071 	function log(bool p0, string memory p1) internal view {
1072 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1073 	}
1074 
1075 	function log(bool p0, bool p1) internal view {
1076 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1077 	}
1078 
1079 	function log(bool p0, address p1) internal view {
1080 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1081 	}
1082 
1083 	function log(address p0, uint p1) internal view {
1084 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1085 	}
1086 
1087 	function log(address p0, string memory p1) internal view {
1088 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1089 	}
1090 
1091 	function log(address p0, bool p1) internal view {
1092 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1093 	}
1094 
1095 	function log(address p0, address p1) internal view {
1096 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1097 	}
1098 
1099 	function log(uint p0, uint p1, uint p2) internal view {
1100 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1101 	}
1102 
1103 	function log(uint p0, uint p1, string memory p2) internal view {
1104 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1105 	}
1106 
1107 	function log(uint p0, uint p1, bool p2) internal view {
1108 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1109 	}
1110 
1111 	function log(uint p0, uint p1, address p2) internal view {
1112 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1113 	}
1114 
1115 	function log(uint p0, string memory p1, uint p2) internal view {
1116 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1117 	}
1118 
1119 	function log(uint p0, string memory p1, string memory p2) internal view {
1120 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1121 	}
1122 
1123 	function log(uint p0, string memory p1, bool p2) internal view {
1124 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1125 	}
1126 
1127 	function log(uint p0, string memory p1, address p2) internal view {
1128 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1129 	}
1130 
1131 	function log(uint p0, bool p1, uint p2) internal view {
1132 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1133 	}
1134 
1135 	function log(uint p0, bool p1, string memory p2) internal view {
1136 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1137 	}
1138 
1139 	function log(uint p0, bool p1, bool p2) internal view {
1140 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1141 	}
1142 
1143 	function log(uint p0, bool p1, address p2) internal view {
1144 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1145 	}
1146 
1147 	function log(uint p0, address p1, uint p2) internal view {
1148 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1149 	}
1150 
1151 	function log(uint p0, address p1, string memory p2) internal view {
1152 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1153 	}
1154 
1155 	function log(uint p0, address p1, bool p2) internal view {
1156 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1157 	}
1158 
1159 	function log(uint p0, address p1, address p2) internal view {
1160 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1161 	}
1162 
1163 	function log(string memory p0, uint p1, uint p2) internal view {
1164 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1165 	}
1166 
1167 	function log(string memory p0, uint p1, string memory p2) internal view {
1168 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1169 	}
1170 
1171 	function log(string memory p0, uint p1, bool p2) internal view {
1172 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1173 	}
1174 
1175 	function log(string memory p0, uint p1, address p2) internal view {
1176 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1177 	}
1178 
1179 	function log(string memory p0, string memory p1, uint p2) internal view {
1180 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1181 	}
1182 
1183 	function log(string memory p0, string memory p1, string memory p2) internal view {
1184 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1185 	}
1186 
1187 	function log(string memory p0, string memory p1, bool p2) internal view {
1188 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1189 	}
1190 
1191 	function log(string memory p0, string memory p1, address p2) internal view {
1192 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1193 	}
1194 
1195 	function log(string memory p0, bool p1, uint p2) internal view {
1196 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1197 	}
1198 
1199 	function log(string memory p0, bool p1, string memory p2) internal view {
1200 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1201 	}
1202 
1203 	function log(string memory p0, bool p1, bool p2) internal view {
1204 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1205 	}
1206 
1207 	function log(string memory p0, bool p1, address p2) internal view {
1208 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1209 	}
1210 
1211 	function log(string memory p0, address p1, uint p2) internal view {
1212 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1213 	}
1214 
1215 	function log(string memory p0, address p1, string memory p2) internal view {
1216 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1217 	}
1218 
1219 	function log(string memory p0, address p1, bool p2) internal view {
1220 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1221 	}
1222 
1223 	function log(string memory p0, address p1, address p2) internal view {
1224 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1225 	}
1226 
1227 	function log(bool p0, uint p1, uint p2) internal view {
1228 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1229 	}
1230 
1231 	function log(bool p0, uint p1, string memory p2) internal view {
1232 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1233 	}
1234 
1235 	function log(bool p0, uint p1, bool p2) internal view {
1236 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1237 	}
1238 
1239 	function log(bool p0, uint p1, address p2) internal view {
1240 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1241 	}
1242 
1243 	function log(bool p0, string memory p1, uint p2) internal view {
1244 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1245 	}
1246 
1247 	function log(bool p0, string memory p1, string memory p2) internal view {
1248 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1249 	}
1250 
1251 	function log(bool p0, string memory p1, bool p2) internal view {
1252 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1253 	}
1254 
1255 	function log(bool p0, string memory p1, address p2) internal view {
1256 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1257 	}
1258 
1259 	function log(bool p0, bool p1, uint p2) internal view {
1260 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1261 	}
1262 
1263 	function log(bool p0, bool p1, string memory p2) internal view {
1264 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1265 	}
1266 
1267 	function log(bool p0, bool p1, bool p2) internal view {
1268 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1269 	}
1270 
1271 	function log(bool p0, bool p1, address p2) internal view {
1272 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1273 	}
1274 
1275 	function log(bool p0, address p1, uint p2) internal view {
1276 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1277 	}
1278 
1279 	function log(bool p0, address p1, string memory p2) internal view {
1280 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1281 	}
1282 
1283 	function log(bool p0, address p1, bool p2) internal view {
1284 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1285 	}
1286 
1287 	function log(bool p0, address p1, address p2) internal view {
1288 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1289 	}
1290 
1291 	function log(address p0, uint p1, uint p2) internal view {
1292 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1293 	}
1294 
1295 	function log(address p0, uint p1, string memory p2) internal view {
1296 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1297 	}
1298 
1299 	function log(address p0, uint p1, bool p2) internal view {
1300 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1301 	}
1302 
1303 	function log(address p0, uint p1, address p2) internal view {
1304 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1305 	}
1306 
1307 	function log(address p0, string memory p1, uint p2) internal view {
1308 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1309 	}
1310 
1311 	function log(address p0, string memory p1, string memory p2) internal view {
1312 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1313 	}
1314 
1315 	function log(address p0, string memory p1, bool p2) internal view {
1316 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1317 	}
1318 
1319 	function log(address p0, string memory p1, address p2) internal view {
1320 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1321 	}
1322 
1323 	function log(address p0, bool p1, uint p2) internal view {
1324 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1325 	}
1326 
1327 	function log(address p0, bool p1, string memory p2) internal view {
1328 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1329 	}
1330 
1331 	function log(address p0, bool p1, bool p2) internal view {
1332 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1333 	}
1334 
1335 	function log(address p0, bool p1, address p2) internal view {
1336 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1337 	}
1338 
1339 	function log(address p0, address p1, uint p2) internal view {
1340 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1341 	}
1342 
1343 	function log(address p0, address p1, string memory p2) internal view {
1344 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1345 	}
1346 
1347 	function log(address p0, address p1, bool p2) internal view {
1348 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1349 	}
1350 
1351 	function log(address p0, address p1, address p2) internal view {
1352 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1353 	}
1354 
1355 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1356 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1357 	}
1358 
1359 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1360 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1361 	}
1362 
1363 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1364 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1365 	}
1366 
1367 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1368 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1369 	}
1370 
1371 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1372 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1373 	}
1374 
1375 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1376 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1377 	}
1378 
1379 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1380 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1381 	}
1382 
1383 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1384 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1385 	}
1386 
1387 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1388 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1389 	}
1390 
1391 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1392 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1393 	}
1394 
1395 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1396 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1397 	}
1398 
1399 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1400 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1401 	}
1402 
1403 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1404 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1405 	}
1406 
1407 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1408 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1409 	}
1410 
1411 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1412 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1413 	}
1414 
1415 	function log(uint p0, uint p1, address p2, address p3) internal view {
1416 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1417 	}
1418 
1419 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1420 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1421 	}
1422 
1423 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1424 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1425 	}
1426 
1427 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1428 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1429 	}
1430 
1431 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1432 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1433 	}
1434 
1435 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1436 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1437 	}
1438 
1439 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1440 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1441 	}
1442 
1443 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1444 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1445 	}
1446 
1447 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1448 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1449 	}
1450 
1451 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1452 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1453 	}
1454 
1455 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1456 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1457 	}
1458 
1459 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1460 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1461 	}
1462 
1463 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1464 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1465 	}
1466 
1467 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1468 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1469 	}
1470 
1471 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1472 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1473 	}
1474 
1475 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1476 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1477 	}
1478 
1479 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1480 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1481 	}
1482 
1483 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1484 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1485 	}
1486 
1487 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1488 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1489 	}
1490 
1491 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1492 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1493 	}
1494 
1495 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1496 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1497 	}
1498 
1499 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1500 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1501 	}
1502 
1503 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1504 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1505 	}
1506 
1507 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1508 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1509 	}
1510 
1511 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1512 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1513 	}
1514 
1515 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1516 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1517 	}
1518 
1519 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1520 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1521 	}
1522 
1523 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1524 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1525 	}
1526 
1527 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1528 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1529 	}
1530 
1531 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1532 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1533 	}
1534 
1535 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1536 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1537 	}
1538 
1539 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1540 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1541 	}
1542 
1543 	function log(uint p0, bool p1, address p2, address p3) internal view {
1544 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1545 	}
1546 
1547 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1548 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1549 	}
1550 
1551 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1552 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1553 	}
1554 
1555 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1556 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1557 	}
1558 
1559 	function log(uint p0, address p1, uint p2, address p3) internal view {
1560 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1561 	}
1562 
1563 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1564 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1565 	}
1566 
1567 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1568 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1569 	}
1570 
1571 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1572 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1573 	}
1574 
1575 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1576 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1577 	}
1578 
1579 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1580 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1581 	}
1582 
1583 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1584 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1585 	}
1586 
1587 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1588 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1589 	}
1590 
1591 	function log(uint p0, address p1, bool p2, address p3) internal view {
1592 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1593 	}
1594 
1595 	function log(uint p0, address p1, address p2, uint p3) internal view {
1596 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1597 	}
1598 
1599 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1600 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1601 	}
1602 
1603 	function log(uint p0, address p1, address p2, bool p3) internal view {
1604 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1605 	}
1606 
1607 	function log(uint p0, address p1, address p2, address p3) internal view {
1608 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1609 	}
1610 
1611 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1612 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1613 	}
1614 
1615 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1616 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1617 	}
1618 
1619 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1620 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1621 	}
1622 
1623 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1624 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1625 	}
1626 
1627 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1628 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1629 	}
1630 
1631 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1632 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1633 	}
1634 
1635 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1636 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1637 	}
1638 
1639 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1640 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1641 	}
1642 
1643 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1644 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1645 	}
1646 
1647 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1648 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1649 	}
1650 
1651 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1652 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1653 	}
1654 
1655 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1656 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1657 	}
1658 
1659 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1660 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1661 	}
1662 
1663 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1664 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1665 	}
1666 
1667 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1668 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1669 	}
1670 
1671 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1672 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1673 	}
1674 
1675 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1676 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1677 	}
1678 
1679 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1680 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1681 	}
1682 
1683 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1684 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1685 	}
1686 
1687 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1688 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1689 	}
1690 
1691 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1692 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1693 	}
1694 
1695 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1696 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1697 	}
1698 
1699 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1700 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1701 	}
1702 
1703 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1704 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1705 	}
1706 
1707 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1708 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1709 	}
1710 
1711 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1712 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1713 	}
1714 
1715 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1716 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1717 	}
1718 
1719 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1720 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1721 	}
1722 
1723 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1724 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1725 	}
1726 
1727 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1728 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1729 	}
1730 
1731 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1732 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1733 	}
1734 
1735 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1736 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1737 	}
1738 
1739 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1740 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1741 	}
1742 
1743 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1744 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1745 	}
1746 
1747 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1748 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1749 	}
1750 
1751 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1752 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1753 	}
1754 
1755 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1756 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1757 	}
1758 
1759 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1760 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1761 	}
1762 
1763 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1764 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1765 	}
1766 
1767 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1768 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1769 	}
1770 
1771 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1772 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1773 	}
1774 
1775 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1776 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1777 	}
1778 
1779 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1780 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1781 	}
1782 
1783 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1784 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1785 	}
1786 
1787 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1788 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1789 	}
1790 
1791 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1792 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1793 	}
1794 
1795 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1796 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1797 	}
1798 
1799 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1800 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1801 	}
1802 
1803 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1804 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1805 	}
1806 
1807 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1808 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1809 	}
1810 
1811 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1812 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1813 	}
1814 
1815 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1816 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1817 	}
1818 
1819 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1820 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1821 	}
1822 
1823 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1824 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1825 	}
1826 
1827 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1828 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1829 	}
1830 
1831 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1832 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1833 	}
1834 
1835 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1836 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1837 	}
1838 
1839 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1840 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1841 	}
1842 
1843 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1844 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1845 	}
1846 
1847 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1848 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1849 	}
1850 
1851 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1852 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1853 	}
1854 
1855 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1856 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1857 	}
1858 
1859 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1860 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1861 	}
1862 
1863 	function log(string memory p0, address p1, address p2, address p3) internal view {
1864 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1865 	}
1866 
1867 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1868 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1869 	}
1870 
1871 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1872 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1873 	}
1874 
1875 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1876 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1877 	}
1878 
1879 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1880 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1881 	}
1882 
1883 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1884 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1885 	}
1886 
1887 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1888 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1889 	}
1890 
1891 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1892 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1893 	}
1894 
1895 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1896 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1897 	}
1898 
1899 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1900 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1901 	}
1902 
1903 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1904 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1905 	}
1906 
1907 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1908 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1909 	}
1910 
1911 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1912 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1913 	}
1914 
1915 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1916 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1917 	}
1918 
1919 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1920 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1921 	}
1922 
1923 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1924 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1925 	}
1926 
1927 	function log(bool p0, uint p1, address p2, address p3) internal view {
1928 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1929 	}
1930 
1931 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1932 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1933 	}
1934 
1935 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1936 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1937 	}
1938 
1939 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1940 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1941 	}
1942 
1943 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1944 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1945 	}
1946 
1947 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1948 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1949 	}
1950 
1951 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1952 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1953 	}
1954 
1955 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1956 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1957 	}
1958 
1959 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1960 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1961 	}
1962 
1963 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1964 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1965 	}
1966 
1967 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1968 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1969 	}
1970 
1971 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1972 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1973 	}
1974 
1975 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1976 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1977 	}
1978 
1979 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1980 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1981 	}
1982 
1983 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1984 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1985 	}
1986 
1987 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1988 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1989 	}
1990 
1991 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1992 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1993 	}
1994 
1995 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1996 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1997 	}
1998 
1999 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2000 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2001 	}
2002 
2003 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2004 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2005 	}
2006 
2007 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2008 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2009 	}
2010 
2011 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2012 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2013 	}
2014 
2015 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2016 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2017 	}
2018 
2019 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2020 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2021 	}
2022 
2023 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2024 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2025 	}
2026 
2027 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2028 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2029 	}
2030 
2031 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2032 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2033 	}
2034 
2035 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2036 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2037 	}
2038 
2039 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2040 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2041 	}
2042 
2043 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2044 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2045 	}
2046 
2047 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2048 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2049 	}
2050 
2051 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2052 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2053 	}
2054 
2055 	function log(bool p0, bool p1, address p2, address p3) internal view {
2056 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2057 	}
2058 
2059 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2060 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2061 	}
2062 
2063 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2064 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2065 	}
2066 
2067 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2068 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2069 	}
2070 
2071 	function log(bool p0, address p1, uint p2, address p3) internal view {
2072 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2073 	}
2074 
2075 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2076 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2077 	}
2078 
2079 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2080 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2081 	}
2082 
2083 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2084 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2085 	}
2086 
2087 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2088 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2089 	}
2090 
2091 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2092 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2093 	}
2094 
2095 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2096 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2097 	}
2098 
2099 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2100 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2101 	}
2102 
2103 	function log(bool p0, address p1, bool p2, address p3) internal view {
2104 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2105 	}
2106 
2107 	function log(bool p0, address p1, address p2, uint p3) internal view {
2108 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2109 	}
2110 
2111 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2112 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2113 	}
2114 
2115 	function log(bool p0, address p1, address p2, bool p3) internal view {
2116 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2117 	}
2118 
2119 	function log(bool p0, address p1, address p2, address p3) internal view {
2120 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2121 	}
2122 
2123 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2124 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2125 	}
2126 
2127 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2128 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2129 	}
2130 
2131 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2132 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2133 	}
2134 
2135 	function log(address p0, uint p1, uint p2, address p3) internal view {
2136 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2137 	}
2138 
2139 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2140 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2141 	}
2142 
2143 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2144 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2145 	}
2146 
2147 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2148 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2149 	}
2150 
2151 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2152 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2153 	}
2154 
2155 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2156 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2157 	}
2158 
2159 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2160 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2161 	}
2162 
2163 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2164 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2165 	}
2166 
2167 	function log(address p0, uint p1, bool p2, address p3) internal view {
2168 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2169 	}
2170 
2171 	function log(address p0, uint p1, address p2, uint p3) internal view {
2172 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2173 	}
2174 
2175 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2176 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2177 	}
2178 
2179 	function log(address p0, uint p1, address p2, bool p3) internal view {
2180 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2181 	}
2182 
2183 	function log(address p0, uint p1, address p2, address p3) internal view {
2184 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2185 	}
2186 
2187 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2188 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2189 	}
2190 
2191 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2192 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2193 	}
2194 
2195 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2196 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2197 	}
2198 
2199 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2200 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2201 	}
2202 
2203 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2204 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2205 	}
2206 
2207 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2208 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2209 	}
2210 
2211 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2212 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2213 	}
2214 
2215 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2216 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2217 	}
2218 
2219 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2220 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2221 	}
2222 
2223 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2224 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2225 	}
2226 
2227 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2228 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2229 	}
2230 
2231 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2232 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2233 	}
2234 
2235 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2236 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2237 	}
2238 
2239 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2240 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2241 	}
2242 
2243 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2244 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2245 	}
2246 
2247 	function log(address p0, string memory p1, address p2, address p3) internal view {
2248 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2249 	}
2250 
2251 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2252 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2253 	}
2254 
2255 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2256 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2257 	}
2258 
2259 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2260 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2261 	}
2262 
2263 	function log(address p0, bool p1, uint p2, address p3) internal view {
2264 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2265 	}
2266 
2267 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2268 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2269 	}
2270 
2271 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2272 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2273 	}
2274 
2275 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2276 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2277 	}
2278 
2279 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2280 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2281 	}
2282 
2283 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2284 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2285 	}
2286 
2287 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2288 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2289 	}
2290 
2291 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2292 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2293 	}
2294 
2295 	function log(address p0, bool p1, bool p2, address p3) internal view {
2296 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2297 	}
2298 
2299 	function log(address p0, bool p1, address p2, uint p3) internal view {
2300 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2301 	}
2302 
2303 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2304 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2305 	}
2306 
2307 	function log(address p0, bool p1, address p2, bool p3) internal view {
2308 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2309 	}
2310 
2311 	function log(address p0, bool p1, address p2, address p3) internal view {
2312 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2313 	}
2314 
2315 	function log(address p0, address p1, uint p2, uint p3) internal view {
2316 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2317 	}
2318 
2319 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2320 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2321 	}
2322 
2323 	function log(address p0, address p1, uint p2, bool p3) internal view {
2324 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2325 	}
2326 
2327 	function log(address p0, address p1, uint p2, address p3) internal view {
2328 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2329 	}
2330 
2331 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2332 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2333 	}
2334 
2335 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2336 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2337 	}
2338 
2339 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2340 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2341 	}
2342 
2343 	function log(address p0, address p1, string memory p2, address p3) internal view {
2344 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2345 	}
2346 
2347 	function log(address p0, address p1, bool p2, uint p3) internal view {
2348 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2349 	}
2350 
2351 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2352 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2353 	}
2354 
2355 	function log(address p0, address p1, bool p2, bool p3) internal view {
2356 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2357 	}
2358 
2359 	function log(address p0, address p1, bool p2, address p3) internal view {
2360 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2361 	}
2362 
2363 	function log(address p0, address p1, address p2, uint p3) internal view {
2364 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2365 	}
2366 
2367 	function log(address p0, address p1, address p2, string memory p3) internal view {
2368 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2369 	}
2370 
2371 	function log(address p0, address p1, address p2, bool p3) internal view {
2372 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2373 	}
2374 
2375 	function log(address p0, address p1, address p2, address p3) internal view {
2376 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2377 	}
2378 
2379 }
2380 
2381 // Kore Vault distributes fees equally amongst staked pools
2382 // Have fun reading it. Hopefully it's bug-free. God bless.
2383 contract KoreVault is OwnableUpgradeSafe {
2384     using SafeMath for uint256;
2385     using SafeERC20 for IERC20;
2386 
2387     // Info of each user.
2388     struct UserInfo {
2389         uint256 amount; // How many  tokens the user has provided.
2390         uint256 rewardDebt; // Reward debt. See explanation below.
2391         //
2392         // We do some fancy math here. Basically, any point in time, the amount of KOREs
2393         // entitled to a user but is pending to be distributed is:
2394         //
2395         //   pending reward = (user.amount * pool.accKorePerShare) - user.rewardDebt
2396         //
2397         // Whenever a user deposits or withdraws  tokens to a pool. Here's what happens:
2398         //   1. The pool's `accKorePerShare` (and `lastRewardBlock`) gets updated.
2399         //   2. User receives the pending reward sent to his/her address.
2400         //   3. User's `amount` gets updated.
2401         //   4. User's `rewardDebt` gets updated.
2402 
2403     }
2404 
2405     // Info of each pool.
2406     struct PoolInfo {
2407         IERC20 token; // Address of  token contract.
2408         uint256 allocPoint; // How many allocation points assigned to this pool. KOREs to distribute per block.
2409         uint256 accKorePerShare; // Accumulated KOREs per share, times 1e12. See below.
2410         bool withdrawable; // Is this pool withdrawable?
2411         mapping(address => mapping(address => uint256)) allowance;
2412 
2413     }
2414 
2415     // The KORE TOKEN!
2416     INBUNIERC20 public kore;
2417     // Dev address.
2418     address public devaddr;
2419 
2420     // Info of each pool.
2421     PoolInfo[] public poolInfo;
2422     // Info of each user that stakes  tokens.
2423     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
2424     // Total allocation poitns. Must be the sum of all allocation points in all pools.
2425     uint256 public totalAllocPoint;
2426 
2427     //// pending rewards awaiting anyone to massUpdate
2428     uint256 public pendingRewards;
2429 
2430     uint256 public contractStartBlock;
2431     uint256 public epochCalculationStartBlock;
2432     uint256 public cumulativeRewardsSinceStart;
2433     uint256 public rewardsInThisEpoch;
2434     uint public epoch;
2435 
2436     // Returns fees generated since start of this contract
2437     function averageFeesPerBlockSinceStart() external view returns (uint averagePerBlock) {
2438         averagePerBlock = cumulativeRewardsSinceStart.add(rewardsInThisEpoch).div(block.number.sub(contractStartBlock));
2439     }
2440 
2441     // Returns averge fees in this epoch
2442     function averageFeesPerBlockEpoch() external view returns (uint256 averagePerBlock) {
2443         averagePerBlock = rewardsInThisEpoch.div(block.number.sub(epochCalculationStartBlock));
2444     }
2445 
2446     // For easy graphing historical epoch rewards
2447     mapping(uint => uint256) public epochRewards;
2448 
2449     //Starts a new calculation epoch
2450     // Because averge since start will not be accurate
2451     function startNewEpoch() public {
2452         require(epochCalculationStartBlock + 50000 < block.number, "New epoch not ready yet"); // About a week
2453         epochRewards[epoch] = rewardsInThisEpoch;
2454         cumulativeRewardsSinceStart = cumulativeRewardsSinceStart.add(rewardsInThisEpoch);
2455         rewardsInThisEpoch = 0;
2456         epochCalculationStartBlock = block.number;
2457         ++epoch;
2458     }
2459 
2460     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
2461     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
2462     event EmergencyWithdraw(
2463         address indexed user,
2464         uint256 indexed pid,
2465         uint256 amount
2466     );
2467     event Approval(address indexed owner, address indexed spender, uint256 _pid, uint256 value);
2468 
2469 
2470     function initialize(
2471         INBUNIERC20 _kore
2472     ) public initializer {
2473         OwnableUpgradeSafe.__Ownable_init();
2474         DEV_FEE = 724;
2475         kore = _kore;
2476         devaddr = msg.sender;
2477         contractStartBlock = block.number;
2478         _superAdmin = msg.sender;
2479     }
2480 
2481     function poolLength() external view returns (uint256) {
2482         return poolInfo.length;
2483     }
2484 
2485 
2486 
2487     // Add a new token pool. Can only be called by the owner.
2488     // Note contract owner is meant to be a governance contract allowing KORE governance consensus
2489     function add(
2490         uint256 _allocPoint,
2491         IERC20 _token,
2492         bool _withUpdate,
2493         bool _withdrawable
2494     ) public onlyOwner {
2495         if (_withUpdate) {
2496             massUpdatePools();
2497         }
2498 
2499         uint256 length = poolInfo.length;
2500         for (uint256 pid = 0; pid < length; ++pid) {
2501             require(poolInfo[pid].token != _token,"Error pool already added");
2502         }
2503 
2504         totalAllocPoint = totalAllocPoint.add(_allocPoint);
2505 
2506 
2507         poolInfo.push(
2508             PoolInfo({
2509                 token: _token,
2510                 allocPoint: _allocPoint,
2511                 accKorePerShare: 0,
2512                 withdrawable : _withdrawable
2513             })
2514         );
2515     }
2516 
2517     // Update the given pool's KOREs allocation point. Can only be called by the owner.
2518     // Note contract owner is meant to be a governance contract allowing KORE governance consensus
2519 
2520     function set(
2521         uint256 _pid,
2522         uint256 _allocPoint,
2523         bool _withUpdate
2524     ) public onlyOwner {
2525         if (_withUpdate) {
2526             massUpdatePools();
2527         }
2528 
2529         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
2530             _allocPoint
2531         );
2532         poolInfo[_pid].allocPoint = _allocPoint;
2533     }
2534 
2535     // Update the given pool's ability to withdraw tokens
2536     // Note contract owner is meant to be a governance contract allowing KORE governance consensus
2537     function setPoolWithdrawable(
2538         uint256 _pid,
2539         bool _withdrawable
2540     ) public onlyOwner {
2541         poolInfo[_pid].withdrawable = _withdrawable;
2542     }
2543 
2544 
2545 
2546     // Sets the dev fee for this contract
2547     // defaults at 7.24%
2548     // Note contract owner is meant to be a governance contract allowing KORE governance consensus
2549     uint16 DEV_FEE;
2550     function setDevFee(uint16 _DEV_FEE) public onlyOwner {
2551         require(_DEV_FEE <= 1000, 'Dev fee clamped at 10%');
2552         DEV_FEE = _DEV_FEE;
2553     }
2554     uint256 pending_DEV_rewards;
2555 
2556 
2557     // View function to see pending KOREs on frontend.
2558     function pendingKore(uint256 _pid, address _user)
2559         external
2560         view
2561         returns (uint256)
2562     {
2563         PoolInfo storage pool = poolInfo[_pid];
2564         UserInfo storage user = userInfo[_pid][_user];
2565         uint256 accKorePerShare = pool.accKorePerShare;
2566 
2567         return user.amount.mul(accKorePerShare).div(1e12).sub(user.rewardDebt);
2568     }
2569 
2570     // Update reward vairables for all pools. Be careful of gas spending!
2571     function massUpdatePools() public {
2572         console.log("Mass Updating Pools");
2573         uint256 length = poolInfo.length;
2574         uint allRewards;
2575         for (uint256 pid = 0; pid < length; ++pid) {
2576             allRewards = allRewards.add(updatePool(pid));
2577         }
2578 
2579         pendingRewards = pendingRewards.sub(allRewards);
2580     }
2581 
2582     // ----
2583     // Function that adds pending rewards, called by the KORE token.
2584     // ----
2585     uint256 private koreBalance;
2586     function addPendingRewards(uint256 _) public {
2587         uint256 newRewards = kore.balanceOf(address(this)).sub(koreBalance);
2588 
2589         if(newRewards > 0) {
2590             koreBalance = kore.balanceOf(address(this)); // If there is no change the balance didn't change
2591             pendingRewards = pendingRewards.add(newRewards);
2592             rewardsInThisEpoch = rewardsInThisEpoch.add(newRewards);
2593         }
2594     }
2595 
2596     // Update reward variables of the given pool to be up-to-date.
2597     function updatePool(uint256 _pid) internal returns (uint256 koreRewardWhole) {
2598         PoolInfo storage pool = poolInfo[_pid];
2599 
2600         uint256 tokenSupply = pool.token.balanceOf(address(this));
2601         if (tokenSupply == 0) { // avoids division by 0 errors
2602             return 0;
2603         }
2604         koreRewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
2605             .mul(pool.allocPoint)        // getting the percent of total pending rewards this pool should get
2606             .div(totalAllocPoint);       // we can do this because pools are only mass updated
2607         uint256 koreRewardFee = koreRewardWhole.mul(DEV_FEE).div(10000);
2608         uint256 koreRewardToDistribute = koreRewardWhole.sub(koreRewardFee);
2609 
2610         pending_DEV_rewards = pending_DEV_rewards.add(koreRewardFee);
2611 
2612         pool.accKorePerShare = pool.accKorePerShare.add(
2613             koreRewardToDistribute.mul(1e12).div(tokenSupply)
2614         );
2615 
2616     }
2617 
2618     // Deposit  tokens to KoreVault for KORE allocation.
2619     function deposit(uint256 _pid, uint256 _amount) public {
2620 
2621         PoolInfo storage pool = poolInfo[_pid];
2622         UserInfo storage user = userInfo[_pid][msg.sender];
2623 
2624         massUpdatePools();
2625 
2626         // Transfer pending tokens
2627         // to user
2628         updateAndPayOutPending(_pid, pool, user, msg.sender);
2629 
2630 
2631         //Transfer in the amounts from user
2632         // save gas
2633         if(_amount > 0) {
2634             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
2635             user.amount = user.amount.add(_amount);
2636         }
2637 
2638         user.rewardDebt = user.amount.mul(pool.accKorePerShare).div(1e12);
2639         emit Deposit(msg.sender, _pid, _amount);
2640     }
2641 
2642     // Test coverage
2643     // [x] Does user get the deposited amounts?
2644     // [x] Does user that its deposited for update correcty?
2645     // [x] Does the depositor get their tokens decreased
2646     function depositFor(address depositFor, uint256 _pid, uint256 _amount) public {
2647         // requires no allowances
2648         PoolInfo storage pool = poolInfo[_pid];
2649         UserInfo storage user = userInfo[_pid][depositFor];
2650 
2651         massUpdatePools();
2652 
2653         // Transfer pending tokens
2654         // to user
2655         updateAndPayOutPending(_pid, pool, user, depositFor); // Update the balances of person that amount is being deposited for
2656 
2657         if(_amount > 0) {
2658             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
2659             user.amount = user.amount.add(_amount); // This is depositedFor address
2660         }
2661 
2662         user.rewardDebt = user.amount.mul(pool.accKorePerShare).div(1e12); /// This is deposited for address
2663         emit Deposit(depositFor, _pid, _amount);
2664 
2665     }
2666 
2667     // Test coverage
2668     // [x] Does allowance update correctly?
2669     function setAllowanceForPoolToken(address spender, uint256 _pid, uint256 value) public {
2670         PoolInfo storage pool = poolInfo[_pid];
2671         pool.allowance[msg.sender][spender] = value;
2672         emit Approval(msg.sender, spender, _pid, value);
2673     }
2674 
2675     // Test coverage
2676     // [x] Does allowance decrease?
2677     // [x] Do oyu need allowance
2678     // [x] Withdraws to correct address
2679     function withdrawFrom(address owner, uint256 _pid, uint256 _amount) public{
2680 
2681         PoolInfo storage pool = poolInfo[_pid];
2682         require(pool.allowance[owner][msg.sender] >= _amount, "withdraw: insufficient allowance");
2683         pool.allowance[owner][msg.sender] = pool.allowance[owner][msg.sender].sub(_amount);
2684         _withdraw(_pid, _amount, owner, msg.sender);
2685 
2686     }
2687 
2688 
2689     // Withdraw  tokens from KoreVault.
2690     function withdraw(uint256 _pid, uint256 _amount) public {
2691 
2692         _withdraw(_pid, _amount, msg.sender, msg.sender);
2693 
2694     }
2695 
2696 
2697 
2698 
2699     // Low level withdraw function
2700     function _withdraw(uint256 _pid, uint256 _amount, address from, address to) internal {
2701         PoolInfo storage pool = poolInfo[_pid];
2702         require(pool.withdrawable, "Withdrawing from this pool is disabled");
2703         UserInfo storage user = userInfo[_pid][from];
2704         require(user.amount >= _amount, "withdraw: not good");
2705 
2706         massUpdatePools();
2707         updateAndPayOutPending(_pid,  pool, user, from); // Update balances of from this is not withdrawal but claiming KORE farmed
2708 
2709         if(_amount > 0) {
2710             user.amount = user.amount.sub(_amount);
2711             pool.token.safeTransfer(address(to), _amount);
2712         }
2713         user.rewardDebt = user.amount.mul(pool.accKorePerShare).div(1e12);
2714 
2715         emit Withdraw(to, _pid, _amount);
2716     }
2717 
2718     function claim(uint256 _pid) public {
2719         PoolInfo storage pool = poolInfo[_pid];
2720         require(pool.withdrawable, "Withdrawing from this pool is disabled");
2721         UserInfo storage user = userInfo[_pid][msg.sender];
2722 
2723         massUpdatePools();
2724         updateAndPayOutPending(_pid, pool, user, msg.sender);
2725     }
2726 
2727     function updateAndPayOutPending(uint256 _pid, PoolInfo storage pool, UserInfo storage user, address from) internal {
2728 
2729         if(user.amount == 0) return;
2730 
2731         uint256 pending = user
2732             .amount
2733             .mul(pool.accKorePerShare)
2734             .div(1e12)
2735             .sub(user.rewardDebt);
2736 
2737         if(pending > 0) {
2738             safeKoreTransfer(from, pending);
2739         }
2740 
2741     }
2742 
2743     // function that lets owner/governance contract
2744     // approve allowance for any token inside this contract
2745     // This means all future UNI like airdrops are covered
2746     // And at the same time allows us to give allowance to strategy contracts.
2747     // Upcoming cYFI etc vaults strategy contracts will use this function to manage and farm yield on value locked
2748     function setStrategyContractOrDistributionContractAllowance(address tokenAddress, uint256 _amount, address contractAddress) public onlySuperAdmin {
2749         require(isContract(contractAddress), "Recipent is not a smart contract, BAD");
2750         require(block.number > contractStartBlock.add(95_000), "Governance setup grace period not over"); // about 2weeks
2751         IERC20(tokenAddress).approve(contractAddress, _amount);
2752     }
2753 
2754     function isContract(address addr) public returns (bool) {
2755         uint size;
2756         assembly { size := extcodesize(addr) }
2757         return size > 0;
2758     }
2759 
2760 
2761 
2762 
2763 
2764     // Withdraw without caring about rewards. EMERGENCY ONLY.
2765     // !Caution this will remove all your pending rewards!
2766     function emergencyWithdraw(uint256 _pid) public {
2767         PoolInfo storage pool = poolInfo[_pid];
2768         require(pool.withdrawable, "Withdrawing from this pool is disabled");
2769         UserInfo storage user = userInfo[_pid][msg.sender];
2770         pool.token.safeTransfer(address(msg.sender), user.amount);
2771         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
2772         user.amount = 0;
2773         user.rewardDebt = 0;
2774         // No mass update dont update pending rewards
2775     }
2776 
2777     // Safe kore transfer function, just in case if rounding error causes pool to not have enough KOREs.
2778     function safeKoreTransfer(address _to, uint256 _amount) internal {
2779         if(_amount == 0) return;
2780 
2781         uint256 koreBal = kore.balanceOf(address(this));
2782         if (_amount > koreBal) {
2783             console.log("transfering out for to person:", _amount);
2784             console.log("Balance of this address is :", koreBal);
2785 
2786             kore.transfer(_to, koreBal);
2787             koreBalance = kore.balanceOf(address(this));
2788 
2789         } else {
2790             kore.transfer(_to, _amount);
2791             koreBalance = kore.balanceOf(address(this));
2792 
2793         }
2794 
2795         if(pending_DEV_rewards > 0) {
2796             uint256 devSend = pending_DEV_rewards; // Avoid recursive loop
2797             pending_DEV_rewards = 0;
2798             safeKoreTransfer(devaddr, devSend);
2799         }
2800 
2801     }
2802 
2803     // Update dev address by the previous dev.
2804     // Note onlyOwner functions are meant for the governance contract
2805     // allowing KORE governance token holders to do this functions.
2806     function setDevFeeReciever(address _devaddr) public onlyOwner {
2807         devaddr = _devaddr;
2808     }
2809 
2810 
2811 
2812     address private _superAdmin;
2813 
2814     event SuperAdminTransfered(address indexed previousOwner, address indexed newOwner);
2815 
2816     /**
2817      * @dev Returns the address of the current super admin
2818      */
2819     function superAdmin() public view returns (address) {
2820         return _superAdmin;
2821     }
2822 
2823     /**
2824      * @dev Throws if called by any account other than the superAdmin
2825      */
2826     modifier onlySuperAdmin() {
2827         require(_superAdmin == _msgSender(), "Super admin : caller is not super admin.");
2828         _;
2829     }
2830 
2831     // Assisns super admint to address 0, making it unreachable forever
2832     function burnSuperAdmin() public virtual onlySuperAdmin {
2833         emit SuperAdminTransfered(_superAdmin, address(0));
2834         _superAdmin = address(0);
2835     }
2836 
2837     // Super admin can transfer its powers to another address
2838     function newSuperAdmin(address newOwner) public virtual onlySuperAdmin {
2839         require(newOwner != address(0), "Ownable: new owner is the zero address");
2840         emit SuperAdminTransfered(_superAdmin, newOwner);
2841         _superAdmin = newOwner;
2842     }
2843 }