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
847 // Kore Vault distributes fees equally amongst staked pools
848 // Have fun reading it. Hopefully it's bug-free. God bless.
849 contract KoreVaultV2 is OwnableUpgradeSafe {
850     using SafeMath for uint256;
851     using SafeERC20 for IERC20;
852 
853     // Info of each user.
854     struct UserInfo {
855         uint256 amount; // How many  tokens the user has provided.
856         uint256 rewardDebt; // Reward debt. See explanation below.
857         //
858         // We do some fancy math here. Basically, any point in time, the amount of KOREs
859         // entitled to a user but is pending to be distributed is:
860         //
861         //   pending reward = (user.amount * pool.accKorePerShare) - user.rewardDebt
862         //
863         // Whenever a user deposits or withdraws  tokens to a pool. Here's what happens:
864         //   1. The pool's `accKorePerShare` (and `lastRewardBlock`) gets updated.
865         //   2. User receives the pending reward sent to his/her address.
866         //   3. User's `amount` gets updated.
867         //   4. User's `rewardDebt` gets updated.
868 
869     }
870 
871     // Info of each pool.
872     struct PoolInfo {
873         IERC20 token; // Address of  token contract.
874         uint256 allocPoint; // How many allocation points assigned to this pool. KOREs to distribute per block.
875         uint256 accKorePerShare; // Accumulated KOREs per share, times 1e12. See below.
876         bool withdrawable; // Is this pool withdrawable?
877         mapping(address => mapping(address => uint256)) allowance;
878 
879     }
880 
881     // The KORE TOKEN!
882     INBUNIERC20 public kore;
883     // Dev address.
884     address public devaddr;
885 
886     // Info of each pool.
887     PoolInfo[] public poolInfo;
888     // Info of each user that stakes  tokens.
889     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
890     // Total allocation poitns. Must be the sum of all allocation points in all pools.
891     uint256 public totalAllocPoint;
892 
893     //// pending rewards awaiting anyone to massUpdate
894     uint256 public pendingRewards;
895 
896     uint256 public contractStartBlock;
897     uint256 public epochCalculationStartBlock;
898     uint256 public cumulativeRewardsSinceStart;
899     uint256 public rewardsInThisEpoch;
900     uint public epoch;
901 
902     // Returns fees generated since start of this contract
903     function averageFeesPerBlockSinceStart() external view returns (uint averagePerBlock) {
904         averagePerBlock = cumulativeRewardsSinceStart.add(rewardsInThisEpoch).div(block.number.sub(contractStartBlock));
905     }
906 
907     // Returns averge fees in this epoch
908     function averageFeesPerBlockEpoch() external view returns (uint256 averagePerBlock) {
909         averagePerBlock = rewardsInThisEpoch.div(block.number.sub(epochCalculationStartBlock));
910     }
911 
912     // For easy graphing historical epoch rewards
913     mapping(uint => uint256) public epochRewards;
914 
915     //Starts a new calculation epoch
916     // Because averge since start will not be accurate
917     function startNewEpoch() public {
918         require(epochCalculationStartBlock + 50000 < block.number, "New epoch not ready yet"); // About a week
919         epochRewards[epoch] = rewardsInThisEpoch;
920         cumulativeRewardsSinceStart = cumulativeRewardsSinceStart.add(rewardsInThisEpoch);
921         rewardsInThisEpoch = 0;
922         epochCalculationStartBlock = block.number;
923         ++epoch;
924     }
925 
926     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
927     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
928     event EmergencyWithdraw(
929         address indexed user,
930         uint256 indexed pid,
931         uint256 amount
932     );
933     event Approval(address indexed owner, address indexed spender, uint256 _pid, uint256 value);
934 
935 
936     function initialize(
937         INBUNIERC20 _kore
938     ) public initializer {
939         OwnableUpgradeSafe.__Ownable_init();
940         DEV_FEE = 724;
941         kore = _kore;
942         devaddr = msg.sender;
943         contractStartBlock = block.number;
944         _superAdmin = msg.sender;
945     }
946 
947     function poolLength() external view returns (uint256) {
948         return poolInfo.length;
949     }
950 
951 
952 
953     // Add a new token pool. Can only be called by the owner.
954     // Note contract owner is meant to be a governance contract allowing KORE governance consensus
955     function add(
956         uint256 _allocPoint,
957         IERC20 _token,
958         bool _withUpdate,
959         bool _withdrawable
960     ) public onlyOwner {
961         if (_withUpdate) {
962             massUpdatePools();
963         }
964 
965         uint256 length = poolInfo.length;
966         for (uint256 pid = 0; pid < length; ++pid) {
967             require(poolInfo[pid].token != _token,"Error pool already added");
968         }
969 
970         totalAllocPoint = totalAllocPoint.add(_allocPoint);
971 
972 
973         poolInfo.push(
974             PoolInfo({
975                 token: _token,
976                 allocPoint: _allocPoint,
977                 accKorePerShare: 0,
978                 withdrawable : _withdrawable
979             })
980         );
981     }
982 
983     // Update the given pool's KOREs allocation point. Can only be called by the owner.
984     // Note contract owner is meant to be a governance contract allowing KORE governance consensus
985 
986     function set(
987         uint256 _pid,
988         uint256 _allocPoint,
989         bool _withUpdate
990     ) public onlyOwner {
991         if (_withUpdate) {
992             massUpdatePools();
993         }
994 
995         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
996             _allocPoint
997         );
998         poolInfo[_pid].allocPoint = _allocPoint;
999     }
1000 
1001     // Update the given pool's ability to withdraw tokens
1002     // Note contract owner is meant to be a governance contract allowing KORE governance consensus
1003     function setPoolWithdrawable(
1004         uint256 _pid,
1005         bool _withdrawable
1006     ) public onlyOwner {
1007         poolInfo[_pid].withdrawable = _withdrawable;
1008     }
1009 
1010 
1011 
1012     // Sets the dev fee for this contract
1013     // defaults at 7.24%
1014     // Note contract owner is meant to be a governance contract allowing KORE governance consensus
1015     uint16 DEV_FEE;
1016     function setDevFee(uint16 _DEV_FEE) public onlyOwner {
1017         require(_DEV_FEE <= 1000, 'Dev fee clamped at 10%');
1018         DEV_FEE = _DEV_FEE;
1019     }
1020     uint256 pending_DEV_rewards;
1021 
1022 
1023     // View function to see pending KOREs on frontend.
1024     function pendingKore(uint256 _pid, address _user)
1025         external
1026         view
1027         returns (uint256)
1028     {
1029         PoolInfo storage pool = poolInfo[_pid];
1030         UserInfo storage user = userInfo[_pid][_user];
1031         uint256 accKorePerShare = pool.accKorePerShare;
1032 
1033         return user.amount.mul(accKorePerShare).div(1e12).sub(user.rewardDebt);
1034     }
1035 
1036     // Update reward vairables for all pools. Be careful of gas spending!
1037     function massUpdatePools() public {
1038         uint256 length = poolInfo.length;
1039         uint allRewards;
1040         for (uint256 pid = 0; pid < length; ++pid) {
1041             allRewards = allRewards.add(updatePool(pid));
1042         }
1043 
1044         pendingRewards = pendingRewards.sub(allRewards);
1045     }
1046 
1047     // ----
1048     // Function that adds pending rewards, called by the KORE token.
1049     // ----
1050     uint256 private koreBalance;
1051     function addPendingRewards(uint256 _) public {
1052         uint256 newRewards = kore.balanceOf(address(this)).sub(koreBalance);
1053 
1054         if(newRewards > 0) {
1055             koreBalance = kore.balanceOf(address(this)); // If there is no change the balance didn't change
1056             pendingRewards = pendingRewards.add(newRewards);
1057             rewardsInThisEpoch = rewardsInThisEpoch.add(newRewards);
1058         }
1059     }
1060 
1061     // Update reward variables of the given pool to be up-to-date.
1062     function updatePool(uint256 _pid) internal returns (uint256 koreRewardWhole) {
1063         PoolInfo storage pool = poolInfo[_pid];
1064 
1065         uint256 tokenSupply = pool.token.balanceOf(address(this));
1066         if (tokenSupply == 0) { // avoids division by 0 errors
1067             return 0;
1068         }
1069         koreRewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
1070             .mul(pool.allocPoint)        // getting the percent of total pending rewards this pool should get
1071             .div(totalAllocPoint);       // we can do this because pools are only mass updated
1072         uint256 koreRewardFee = koreRewardWhole.mul(DEV_FEE).div(10000);
1073         uint256 koreRewardToDistribute = koreRewardWhole.sub(koreRewardFee);
1074 
1075         pending_DEV_rewards = pending_DEV_rewards.add(koreRewardFee);
1076 
1077         pool.accKorePerShare = pool.accKorePerShare.add(
1078             koreRewardToDistribute.mul(1e12).div(tokenSupply)
1079         );
1080 
1081     }
1082 
1083     function depositAll(uint256 _pid) external {
1084         PoolInfo storage pool = poolInfo[_pid];
1085         deposit(_pid, pool.token.balanceOf(msg.sender));
1086     }
1087 
1088     // Deposit  tokens to KoreVault for KORE allocation.
1089     function deposit(uint256 _pid, uint256 _amount) public {
1090         PoolInfo storage pool = poolInfo[_pid];
1091         UserInfo storage user = userInfo[_pid][msg.sender];
1092 
1093         massUpdatePools();
1094 
1095         // Transfer pending tokens
1096         // to user
1097         updateAndPayOutPending(_pid, pool, user, msg.sender);
1098 
1099         //Transfer in the amounts from user
1100         // save gas
1101         if(_amount > 0) {
1102             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
1103             user.amount = user.amount.add(_amount);
1104         }
1105 
1106         user.rewardDebt = user.amount.mul(pool.accKorePerShare).div(1e12);
1107         emit Deposit(msg.sender, _pid, _amount);
1108     }
1109 
1110     // Test coverage
1111     // [x] Does user get the deposited amounts?
1112     // [x] Does user that its deposited for update correcty?
1113     // [x] Does the depositor get their tokens decreased
1114     function depositFor(address depositFor, uint256 _pid, uint256 _amount) public {
1115         // requires no allowances
1116         PoolInfo storage pool = poolInfo[_pid];
1117         UserInfo storage user = userInfo[_pid][depositFor];
1118 
1119         massUpdatePools();
1120 
1121         // Transfer pending tokens
1122         // to user
1123         updateAndPayOutPending(_pid, pool, user, depositFor); // Update the balances of person that amount is being deposited for
1124 
1125         if(_amount > 0) {
1126             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
1127             user.amount = user.amount.add(_amount); // This is depositedFor address
1128         }
1129 
1130         user.rewardDebt = user.amount.mul(pool.accKorePerShare).div(1e12); /// This is deposited for address
1131         emit Deposit(depositFor, _pid, _amount);
1132 
1133     }
1134 
1135     // Test coverage
1136     // [x] Does allowance update correctly?
1137     function setAllowanceForPoolToken(address spender, uint256 _pid, uint256 value) public {
1138         PoolInfo storage pool = poolInfo[_pid];
1139         pool.allowance[msg.sender][spender] = value;
1140         emit Approval(msg.sender, spender, _pid, value);
1141     }
1142 
1143     // Test coverage
1144     // [x] Does allowance decrease?
1145     // [x] Do oyu need allowance
1146     // [x] Withdraws to correct address
1147     function withdrawFrom(address owner, uint256 _pid, uint256 _amount) public{
1148 
1149         PoolInfo storage pool = poolInfo[_pid];
1150         require(pool.allowance[owner][msg.sender] >= _amount, "withdraw: insufficient allowance");
1151         pool.allowance[owner][msg.sender] = pool.allowance[owner][msg.sender].sub(_amount);
1152         _withdraw(_pid, _amount, owner, msg.sender);
1153 
1154     }
1155 
1156     function withdrawAll(uint256 _pid) external {
1157         UserInfo storage user = userInfo[_pid][msg.sender];
1158         withdraw(_pid, user.amount);
1159     }
1160 
1161     // Withdraw  tokens from KoreVault.
1162     function withdraw(uint256 _pid, uint256 _amount) public {
1163         _withdraw(_pid, _amount, msg.sender, msg.sender);
1164     }
1165 
1166     // Low level withdraw function
1167     function _withdraw(uint256 _pid, uint256 _amount, address from, address to) internal {
1168         PoolInfo storage pool = poolInfo[_pid];
1169         require(pool.withdrawable, "Withdrawing from this pool is disabled");
1170         UserInfo storage user = userInfo[_pid][from];
1171         require(user.amount >= _amount, "withdraw: not good");
1172 
1173         massUpdatePools();
1174         updateAndPayOutPending(_pid,  pool, user, from); // Update balances of from this is not withdrawal but claiming KORE farmed
1175 
1176         if(_amount > 0) {
1177             user.amount = user.amount.sub(_amount);
1178             pool.token.safeTransfer(address(to), _amount);
1179         }
1180         user.rewardDebt = user.amount.mul(pool.accKorePerShare).div(1e12);
1181 
1182         emit Withdraw(to, _pid, _amount);
1183     }
1184 
1185     function updateAndPayOutPending(uint256 _pid, PoolInfo storage pool, UserInfo storage user, address from) internal {
1186 
1187         if(user.amount == 0) return;
1188 
1189         uint256 pending = user
1190             .amount
1191             .mul(pool.accKorePerShare)
1192             .div(1e12)
1193             .sub(user.rewardDebt);
1194 
1195         if(pending > 0) {
1196             safeKoreTransfer(from, pending);
1197         }
1198 
1199     }
1200 
1201     // function that lets owner/governance contract
1202     // approve allowance for any token inside this contract
1203     // This means all future UNI like airdrops are covered
1204     // And at the same time allows us to give allowance to strategy contracts.
1205     // Upcoming cYFI etc vaults strategy contracts will use this function to manage and farm yield on value locked
1206     function setStrategyContractOrDistributionContractAllowance(address tokenAddress, uint256 _amount, address contractAddress) public onlySuperAdmin {
1207         require(isContract(contractAddress), "Recipent is not a smart contract, BAD");
1208         require(block.number > contractStartBlock.add(95_000), "Governance setup grace period not over"); // about 2weeks
1209         IERC20(tokenAddress).approve(contractAddress, _amount);
1210     }
1211 
1212     function isContract(address addr) public returns (bool) {
1213         uint size;
1214         assembly { size := extcodesize(addr) }
1215         return size > 0;
1216     }
1217 
1218 
1219 
1220 
1221 
1222     // Withdraw without caring about rewards. EMERGENCY ONLY.
1223     // !Caution this will remove all your pending rewards!
1224     function emergencyWithdraw(uint256 _pid) public {
1225         PoolInfo storage pool = poolInfo[_pid];
1226         require(pool.withdrawable, "Withdrawing from this pool is disabled");
1227         UserInfo storage user = userInfo[_pid][msg.sender];
1228         pool.token.safeTransfer(address(msg.sender), user.amount);
1229         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1230         user.amount = 0;
1231         user.rewardDebt = 0;
1232         // No mass update dont update pending rewards
1233     }
1234 
1235     // Safe kore transfer function, just in case if rounding error causes pool to not have enough KOREs.
1236     function safeKoreTransfer(address _to, uint256 _amount) internal {
1237         if(_amount == 0) return;
1238 
1239         uint256 koreBal = kore.balanceOf(address(this));
1240         if (_amount > koreBal) {
1241             kore.transfer(_to, koreBal);
1242             koreBalance = kore.balanceOf(address(this));
1243 
1244         } else {
1245             kore.transfer(_to, _amount);
1246             koreBalance = kore.balanceOf(address(this));
1247 
1248         }
1249 
1250         //Avoids possible recursion loop
1251         transferDevFee();
1252     }
1253 
1254     function transferDevFee() public {
1255         if(pending_DEV_rewards == 0) return;
1256         uint256 koreBal = kore.balanceOf(address(this));
1257         if (pending_DEV_rewards > koreBal) {
1258             kore.transfer(devaddr, koreBal);
1259             koreBalance = kore.balanceOf(address(this));
1260         } else {
1261             kore.transfer(devaddr, pending_DEV_rewards);
1262             koreBalance = kore.balanceOf(address(this));
1263         }
1264         pending_DEV_rewards = 0;
1265     }
1266 
1267     // Update dev address by the previous dev.
1268     // Note onlyOwner functions are meant for the governance contract
1269     // allowing KORE governance token holders to do this functions.
1270     function setDevFeeReciever(address _devaddr) public onlyOwner {
1271         devaddr = _devaddr;
1272     }
1273 
1274 
1275 
1276     address private _superAdmin;
1277 
1278     event SuperAdminTransfered(address indexed previousOwner, address indexed newOwner);
1279 
1280     /**
1281      * @dev Returns the address of the current super admin
1282      */
1283     function superAdmin() public view returns (address) {
1284         return _superAdmin;
1285     }
1286 
1287     /**
1288      * @dev Throws if called by any account other than the superAdmin
1289      */
1290     modifier onlySuperAdmin() {
1291         require(_superAdmin == _msgSender(), "Super admin : caller is not super admin.");
1292         _;
1293     }
1294 
1295     // Assisns super admint to address 0, making it unreachable forever
1296     function burnSuperAdmin() public virtual onlySuperAdmin {
1297         emit SuperAdminTransfered(_superAdmin, address(0));
1298         _superAdmin = address(0);
1299     }
1300 
1301     // Super admin can transfer its powers to another address
1302     function newSuperAdmin(address newOwner) public virtual onlySuperAdmin {
1303         require(newOwner != address(0), "Ownable: new owner is the zero address");
1304         emit SuperAdminTransfered(_superAdmin, newOwner);
1305         _superAdmin = newOwner;
1306     }
1307 }