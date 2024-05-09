1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-17
3 */
4 
5 pragma solidity 0.6.12;
6 
7 
8 // SPDX-License-Identifier: MIT
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      * - Addition cannot overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return sub(a, b, "SafeMath: subtraction overflow");
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         // Solidity only automatically asserts when dividing by 0
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
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
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 /**
233  * @dev Collection of functions related to the address type
234  */
235 library Address {
236     /**
237      * @dev Returns true if `account` is a contract.
238      *
239      * [IMPORTANT]
240      * ====
241      * It is unsafe to assume that an address for which this function returns
242      * false is an externally-owned account (EOA) and not a contract.
243      *
244      * Among others, `isContract` will return false for the following
245      * types of addresses:
246      *
247      *  - an externally-owned account
248      *  - a contract in construction
249      *  - an address where a contract will be created
250      *  - an address where a contract lived, but was destroyed
251      * ====
252      */
253     function isContract(address account) internal view returns (bool) {
254         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
255         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
256         // for accounts without code, i.e. `keccak256('')`
257         bytes32 codehash;
258         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
259         // solhint-disable-next-line no-inline-assembly
260         assembly { codehash := extcodehash(account) }
261         return (codehash != accountHash && codehash != 0x0);
262     }
263 
264     /**
265      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
266      * `recipient`, forwarding all available gas and reverting on errors.
267      *
268      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
269      * of certain opcodes, possibly making contracts go over the 2300 gas limit
270      * imposed by `transfer`, making them unable to receive funds via
271      * `transfer`. {sendValue} removes this limitation.
272      *
273      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
274      *
275      * IMPORTANT: because control is transferred to `recipient`, care must be
276      * taken to not create reentrancy vulnerabilities. Consider using
277      * {ReentrancyGuard} or the
278      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
279      */
280     function sendValue(address payable recipient, uint256 amount) internal {
281         require(address(this).balance >= amount, "Address: insufficient balance");
282 
283         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
284         (bool success, ) = recipient.call{ value: amount }("");
285         require(success, "Address: unable to send value, recipient may have reverted");
286     }
287 }
288 
289 /**
290  * @title SafeERC20
291  * @dev Wrappers around ERC20 operations that throw on failure (when the token
292  * contract returns false). Tokens that return no value (and instead revert or
293  * throw on failure) are also supported, non-reverting calls are assumed to be
294  * successful.
295  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
296  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
297  */
298 library SafeERC20 {
299     using SafeMath for uint256;
300     using Address for address;
301 
302     function safeTransfer(IERC20 token, address to, uint256 value) internal {
303         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
304     }
305 
306     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
307         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
308     }
309 
310     function safeApprove(IERC20 token, address spender, uint256 value) internal {
311         // safeApprove should only be called when setting an initial allowance,
312         // or when resetting it to zero. To increase and decrease it, use
313         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
314         // solhint-disable-next-line max-line-length
315         require((value == 0) || (token.allowance(address(this), spender) == 0),
316             "SafeERC20: approve from non-zero to non-zero allowance"
317         );
318         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
319     }
320 
321     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
322         uint256 newAllowance = token.allowance(address(this), spender).add(value);
323         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
324     }
325 
326     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
327         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
328         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
329     }
330 
331     /**
332      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
333      * on the return value: the return value is optional (but if data is returned, it must not be false).
334      * @param token The token targeted by the call.
335      * @param data The call data (encoded using abi.encode or one of its variants).
336      */
337     function _callOptionalReturn(IERC20 token, bytes memory data) private {
338         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
339         // we're implementing it ourselves.
340 
341         // A Solidity high level call has three parts:
342         //  1. The target address is checked to verify it contains contract code
343         //  2. The call itself is made, and success asserted
344         //  3. The return value is decoded, which in turn checks the size of the returned data.
345         // solhint-disable-next-line max-line-length
346         require(address(token).isContract(), "SafeERC20: call to non-contract");
347 
348         // solhint-disable-next-line avoid-low-level-calls
349         (bool success, bytes memory returndata) = address(token).call(data);
350         require(success, "SafeERC20: low-level call failed");
351 
352         if (returndata.length > 0) { // Return data is optional
353             // solhint-disable-next-line max-line-length
354             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
355         }
356     }
357 }
358 
359 /**
360  * @dev Library for managing
361  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
362  * types.
363  *
364  * Sets have the following properties:
365  *
366  * - Elements are added, removed, and checked for existence in constant time
367  * (O(1)).
368  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
369  *
370  * ```
371  * contract Example {
372  *     // Add the library methods
373  *     using EnumerableSet for EnumerableSet.AddressSet;
374  *
375  *     // Declare a set state variable
376  *     EnumerableSet.AddressSet private mySet;
377  * }
378  * ```
379  *
380  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
381  * (`UintSet`) are supported.
382  */
383 library EnumerableSet {
384     // To implement this library for multiple types with as little code
385     // repetition as possible, we write it in terms of a generic Set type with
386     // bytes32 values.
387     // The Set implementation uses private functions, and user-facing
388     // implementations (such as AddressSet) are just wrappers around the
389     // underlying Set.
390     // This means that we can only create new EnumerableSets for types that fit
391     // in bytes32.
392 
393     struct Set {
394         // Storage of set values
395         bytes32[] _values;
396 
397         // Position of the value in the `values` array, plus 1 because index 0
398         // means a value is not in the set.
399         mapping (bytes32 => uint256) _indexes;
400     }
401 
402     /**
403      * @dev Add a value to a set. O(1).
404      *
405      * Returns true if the value was added to the set, that is if it was not
406      * already present.
407      */
408     function _add(Set storage set, bytes32 value) private returns (bool) {
409         if (!_contains(set, value)) {
410             set._values.push(value);
411             // The value is stored at length-1, but we add 1 to all indexes
412             // and use 0 as a sentinel value
413             set._indexes[value] = set._values.length;
414             return true;
415         } else {
416             return false;
417         }
418     }
419 
420     /**
421      * @dev Removes a value from a set. O(1).
422      *
423      * Returns true if the value was removed from the set, that is if it was
424      * present.
425      */
426     function _remove(Set storage set, bytes32 value) private returns (bool) {
427         // We read and store the value's index to prevent multiple reads from the same storage slot
428         uint256 valueIndex = set._indexes[value];
429 
430         if (valueIndex != 0) { // Equivalent to contains(set, value)
431             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
432             // the array, and then remove the last element (sometimes called as 'swap and pop').
433             // This modifies the order of the array, as noted in {at}.
434 
435             uint256 toDeleteIndex = valueIndex - 1;
436             uint256 lastIndex = set._values.length - 1;
437 
438             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
439             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
440 
441             bytes32 lastvalue = set._values[lastIndex];
442 
443             // Move the last value to the index where the value to delete is
444             set._values[toDeleteIndex] = lastvalue;
445             // Update the index for the moved value
446             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
447 
448             // Delete the slot where the moved value was stored
449             set._values.pop();
450 
451             // Delete the index for the deleted slot
452             delete set._indexes[value];
453 
454             return true;
455         } else {
456             return false;
457         }
458     }
459 
460     /**
461      * @dev Returns true if the value is in the set. O(1).
462      */
463     function _contains(Set storage set, bytes32 value) private view returns (bool) {
464         return set._indexes[value] != 0;
465     }
466 
467     /**
468      * @dev Returns the number of values on the set. O(1).
469      */
470     function _length(Set storage set) private view returns (uint256) {
471         return set._values.length;
472     }
473 
474    /**
475     * @dev Returns the value stored at position `index` in the set. O(1).
476     *
477     * Note that there are no guarantees on the ordering of values inside the
478     * array, and it may change when more values are added or removed.
479     *
480     * Requirements:
481     *
482     * - `index` must be strictly less than {length}.
483     */
484     function _at(Set storage set, uint256 index) private view returns (bytes32) {
485         require(set._values.length > index, "EnumerableSet: index out of bounds");
486         return set._values[index];
487     }
488 
489     // AddressSet
490 
491     struct AddressSet {
492         Set _inner;
493     }
494 
495     /**
496      * @dev Add a value to a set. O(1).
497      *
498      * Returns true if the value was added to the set, that is if it was not
499      * already present.
500      */
501     function add(AddressSet storage set, address value) internal returns (bool) {
502         return _add(set._inner, bytes32(uint256(value)));
503     }
504 
505     /**
506      * @dev Removes a value from a set. O(1).
507      *
508      * Returns true if the value was removed from the set, that is if it was
509      * present.
510      */
511     function remove(AddressSet storage set, address value) internal returns (bool) {
512         return _remove(set._inner, bytes32(uint256(value)));
513     }
514 
515     /**
516      * @dev Returns true if the value is in the set. O(1).
517      */
518     function contains(AddressSet storage set, address value) internal view returns (bool) {
519         return _contains(set._inner, bytes32(uint256(value)));
520     }
521 
522     /**
523      * @dev Returns the number of values in the set. O(1).
524      */
525     function length(AddressSet storage set) internal view returns (uint256) {
526         return _length(set._inner);
527     }
528 
529    /**
530     * @dev Returns the value stored at position `index` in the set. O(1).
531     *
532     * Note that there are no guarantees on the ordering of values inside the
533     * array, and it may change when more values are added or removed.
534     *
535     * Requirements:
536     *
537     * - `index` must be strictly less than {length}.
538     */
539     function at(AddressSet storage set, uint256 index) internal view returns (address) {
540         return address(uint256(_at(set._inner, index)));
541     }
542 
543 
544     // UintSet
545 
546     struct UintSet {
547         Set _inner;
548     }
549 
550     /**
551      * @dev Add a value to a set. O(1).
552      *
553      * Returns true if the value was added to the set, that is if it was not
554      * already present.
555      */
556     function add(UintSet storage set, uint256 value) internal returns (bool) {
557         return _add(set._inner, bytes32(value));
558     }
559 
560     /**
561      * @dev Removes a value from a set. O(1).
562      *
563      * Returns true if the value was removed from the set, that is if it was
564      * present.
565      */
566     function remove(UintSet storage set, uint256 value) internal returns (bool) {
567         return _remove(set._inner, bytes32(value));
568     }
569 
570     /**
571      * @dev Returns true if the value is in the set. O(1).
572      */
573     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
574         return _contains(set._inner, bytes32(value));
575     }
576 
577     /**
578      * @dev Returns the number of values on the set. O(1).
579      */
580     function length(UintSet storage set) internal view returns (uint256) {
581         return _length(set._inner);
582     }
583 
584    /**
585     * @dev Returns the value stored at position `index` in the set. O(1).
586     *
587     * Note that there are no guarantees on the ordering of values inside the
588     * array, and it may change when more values are added or removed.
589     *
590     * Requirements:
591     *
592     * - `index` must be strictly less than {length}.
593     */
594     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
595         return uint256(_at(set._inner, index));
596     }
597 }
598 
599 /**
600  * @title Initializable
601  *
602  * @dev Helper contract to support initializer functions. To use it, replace
603  * the constructor with a function that has the `initializer` modifier.
604  * WARNING: Unlike constructors, initializer functions must be manually
605  * invoked. This applies both to deploying an Initializable contract, as well
606  * as extending an Initializable contract via inheritance.
607  * WARNING: When used with inheritance, manual care must be taken to not invoke
608  * a parent initializer twice, or ensure that all initializers are idempotent,
609  * because this is not dealt with automatically as with constructors.
610  */
611 contract Initializable {
612 
613   /**
614    * @dev Indicates that the contract has been initialized.
615    */
616   bool private initialized;
617 
618   /**
619    * @dev Indicates that the contract is in the process of being initialized.
620    */
621   bool private initializing;
622 
623   /**
624    * @dev Modifier to use in the initializer function of a contract.
625    */
626   modifier initializer() {
627     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
628 
629     bool isTopLevelCall = !initializing;
630     if (isTopLevelCall) {
631       initializing = true;
632       initialized = true;
633     }
634 
635     _;
636 
637     if (isTopLevelCall) {
638       initializing = false;
639     }
640   }
641 
642   /// @dev Returns true if and only if the function is running in the constructor
643   function isConstructor() private view returns (bool) {
644     // extcodesize checks the size of the code stored in an address, and
645     // address returns the current address. Since the code is still not
646     // deployed when running a constructor, any checks on its code size will
647     // yield zero, making it an effective way to detect if a contract is
648     // under construction or not.
649     address self = address(this);
650     uint256 cs;
651     assembly { cs := extcodesize(self) }
652     return cs == 0;
653   }
654 
655   // Reserved storage space to allow for layout changes in the future.
656   uint256[50] private ______gap;
657 }
658 
659 /*
660  * @dev Provides information about the current execution context, including the
661  * sender of the transaction and its data. While these are generally available
662  * via msg.sender and msg.data, they should not be accessed in such a direct
663  * manner, since when dealing with GSN meta-transactions the account sending and
664  * paying for execution may not be the actual sender (as far as an application
665  * is concerned).
666  *
667  * This contract is only required for intermediate, library-like contracts.
668  */
669 contract ContextUpgradeSafe is Initializable {
670     // Empty internal constructor, to prevent people from mistakenly deploying
671     // an instance of this contract, which should be used via inheritance.
672 
673     function __Context_init() internal initializer {
674         __Context_init_unchained();
675     }
676 
677     function __Context_init_unchained() internal initializer {
678 
679 
680     }
681 
682 
683     function _msgSender() internal view virtual returns (address payable) {
684         return msg.sender;
685     }
686 
687     function _msgData() internal view virtual returns (bytes memory) {
688         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
689         return msg.data;
690     }
691 
692     uint256[50] private __gap;
693 }
694 
695 /**
696  * @dev Contract module which provides a basic access control mechanism, where
697  * there is an account (an owner) that can be granted exclusive access to
698  * specific functions.
699  *
700  * By default, the owner account will be the one that deploys the contract. This
701  * can later be changed with {transferOwnership}.
702  *
703  * This module is used through inheritance. It will make available the modifier
704  * `onlyOwner`, which can be applied to your functions to restrict their use to
705  * the owner.
706  */
707 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
708     address private _owner;
709 
710     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
711 
712     /**
713      * @dev Initializes the contract setting the deployer as the initial owner.
714      */
715 
716     function __Ownable_init() internal initializer {
717         __Context_init_unchained();
718         __Ownable_init_unchained();
719     }
720 
721     function __Ownable_init_unchained() internal initializer {
722 
723 
724         address msgSender = _msgSender();
725         _owner = msgSender;
726         emit OwnershipTransferred(address(0), msgSender);
727 
728     }
729 
730 
731     /**
732      * @dev Returns the address of the current owner.
733      */
734     function owner() public view returns (address) {
735         return _owner;
736     }
737 
738     /**
739      * @dev Throws if called by any account other than the owner.
740      */
741     modifier onlyOwner() {
742         require(_owner == _msgSender(), "Ownable: caller is not the owner");
743         _;
744     }
745 
746     /**
747      * @dev Leaves the contract without owner. It will not be possible to call
748      * `onlyOwner` functions anymore. Can only be called by the current owner.
749      *
750      * NOTE: Renouncing ownership will leave the contract without an owner,
751      * thereby removing any functionality that is only available to the owner.
752      */
753     function renounceOwnership() public virtual onlyOwner {
754         emit OwnershipTransferred(_owner, address(0));
755         _owner = address(0);
756     }
757 
758     /**
759      * @dev Transfers ownership of the contract to a new account (`newOwner`).
760      * Can only be called by the current owner.
761      */
762     function transferOwnership(address newOwner) public virtual onlyOwner {
763         require(newOwner != address(0), "Ownable: new owner is the zero address");
764         emit OwnershipTransferred(_owner, newOwner);
765         _owner = newOwner;
766     }
767 
768     uint256[49] private __gap;
769 }
770 
771 /**
772  * @dev Interface of the ERC20 standard as defined in the EIP.
773  */
774 interface INBUNIERC20 {
775     /**
776      * @dev Returns the amount of tokens in existence.
777      */
778     function totalSupply() external view returns (uint256);
779 
780     /**
781      * @dev Returns the amount of tokens owned by `account`.
782      */
783     function balanceOf(address account) external view returns (uint256);
784 
785     /**
786      * @dev Moves `amount` tokens from the caller's account to `recipient`.
787      *
788      * Returns a boolean value indicating whether the operation succeeded.
789      *
790      * Emits a {Transfer} event.
791      */
792     function transfer(address recipient, uint256 amount) external returns (bool);
793 
794     /**
795      * @dev Returns the remaining number of tokens that `spender` will be
796      * allowed to spend on behalf of `owner` through {transferFrom}. This is
797      * zero by default.
798      *
799      * This value changes when {approve} or {transferFrom} are called.
800      */
801     function allowance(address owner, address spender) external view returns (uint256);
802 
803     /**
804      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
805      *
806      * Returns a boolean value indicating whether the operation succeeded.
807      *
808      * IMPORTANT: Beware that changing an allowance with this method brings the risk
809      * that someone may use both the old and the new allowance by unfortunate
810      * transaction ordering. One possible solution to mitigate this race
811      * condition is to first reduce the spender's allowance to 0 and set the
812      * desired value afterwards:
813      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
814      *
815      * Emits an {Approval} event.
816      */
817     function approve(address spender, uint256 amount) external returns (bool);
818 
819     /**
820      * @dev Moves `amount` tokens from `sender` to `recipient` using the
821      * allowance mechanism. `amount` is then deducted from the caller's
822      * allowance.
823      *
824      * Returns a boolean value indicating whether the operation succeeded.
825      *
826      * Emits a {Transfer} event.
827      */
828     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
829 
830     /**
831      * @dev Emitted when `value` tokens are moved from one account (`from`) to
832      * another (`to`).
833      *
834      * Note that `value` may be zero.
835      */
836     event Transfer(address indexed from, address indexed to, uint256 value);
837 
838     /**
839      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
840      * a call to {approve}. `value` is the new allowance.
841      */
842     event Approval(address indexed owner, address indexed spender, uint256 value);
843 
844 
845     event Log(string log);
846 
847 }
848 
849 library console {
850 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
851 
852 	function _sendLogPayload(bytes memory payload) private view {
853 		uint256 payloadLength = payload.length;
854 		address consoleAddress = CONSOLE_ADDRESS;
855 		assembly {
856 			let payloadStart := add(payload, 32)
857 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
858 		}
859 	}
860 
861 	function log() internal view {
862 		_sendLogPayload(abi.encodeWithSignature("log()"));
863 	}
864 
865 	function logInt(int p0) internal view {
866 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
867 	}
868 
869 	function logUint(uint p0) internal view {
870 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
871 	}
872 
873 	function logString(string memory p0) internal view {
874 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
875 	}
876 
877 	function logBool(bool p0) internal view {
878 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
879 	}
880 
881 	function logAddress(address p0) internal view {
882 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
883 	}
884 
885 	function logBytes(bytes memory p0) internal view {
886 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
887 	}
888 
889 	function logByte(byte p0) internal view {
890 		_sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
891 	}
892 
893 	function logBytes1(bytes1 p0) internal view {
894 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
895 	}
896 
897 	function logBytes2(bytes2 p0) internal view {
898 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
899 	}
900 
901 	function logBytes3(bytes3 p0) internal view {
902 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
903 	}
904 
905 	function logBytes4(bytes4 p0) internal view {
906 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
907 	}
908 
909 	function logBytes5(bytes5 p0) internal view {
910 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
911 	}
912 
913 	function logBytes6(bytes6 p0) internal view {
914 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
915 	}
916 
917 	function logBytes7(bytes7 p0) internal view {
918 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
919 	}
920 
921 	function logBytes8(bytes8 p0) internal view {
922 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
923 	}
924 
925 	function logBytes9(bytes9 p0) internal view {
926 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
927 	}
928 
929 	function logBytes10(bytes10 p0) internal view {
930 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
931 	}
932 
933 	function logBytes11(bytes11 p0) internal view {
934 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
935 	}
936 
937 	function logBytes12(bytes12 p0) internal view {
938 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
939 	}
940 
941 	function logBytes13(bytes13 p0) internal view {
942 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
943 	}
944 
945 	function logBytes14(bytes14 p0) internal view {
946 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
947 	}
948 
949 	function logBytes15(bytes15 p0) internal view {
950 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
951 	}
952 
953 	function logBytes16(bytes16 p0) internal view {
954 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
955 	}
956 
957 	function logBytes17(bytes17 p0) internal view {
958 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
959 	}
960 
961 	function logBytes18(bytes18 p0) internal view {
962 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
963 	}
964 
965 	function logBytes19(bytes19 p0) internal view {
966 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
967 	}
968 
969 	function logBytes20(bytes20 p0) internal view {
970 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
971 	}
972 
973 	function logBytes21(bytes21 p0) internal view {
974 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
975 	}
976 
977 	function logBytes22(bytes22 p0) internal view {
978 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
979 	}
980 
981 	function logBytes23(bytes23 p0) internal view {
982 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
983 	}
984 
985 	function logBytes24(bytes24 p0) internal view {
986 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
987 	}
988 
989 	function logBytes25(bytes25 p0) internal view {
990 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
991 	}
992 
993 	function logBytes26(bytes26 p0) internal view {
994 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
995 	}
996 
997 	function logBytes27(bytes27 p0) internal view {
998 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
999 	}
1000 
1001 	function logBytes28(bytes28 p0) internal view {
1002 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1003 	}
1004 
1005 	function logBytes29(bytes29 p0) internal view {
1006 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1007 	}
1008 
1009 	function logBytes30(bytes30 p0) internal view {
1010 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1011 	}
1012 
1013 	function logBytes31(bytes31 p0) internal view {
1014 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1015 	}
1016 
1017 	function logBytes32(bytes32 p0) internal view {
1018 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1019 	}
1020 
1021 	function log(uint p0) internal view {
1022 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1023 	}
1024 
1025 	function log(string memory p0) internal view {
1026 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1027 	}
1028 
1029 	function log(bool p0) internal view {
1030 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1031 	}
1032 
1033 	function log(address p0) internal view {
1034 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1035 	}
1036 
1037 	function log(uint p0, uint p1) internal view {
1038 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1039 	}
1040 
1041 	function log(uint p0, string memory p1) internal view {
1042 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1043 	}
1044 
1045 	function log(uint p0, bool p1) internal view {
1046 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1047 	}
1048 
1049 	function log(uint p0, address p1) internal view {
1050 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1051 	}
1052 
1053 	function log(string memory p0, uint p1) internal view {
1054 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1055 	}
1056 
1057 	function log(string memory p0, string memory p1) internal view {
1058 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1059 	}
1060 
1061 	function log(string memory p0, bool p1) internal view {
1062 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1063 	}
1064 
1065 	function log(string memory p0, address p1) internal view {
1066 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1067 	}
1068 
1069 	function log(bool p0, uint p1) internal view {
1070 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1071 	}
1072 
1073 	function log(bool p0, string memory p1) internal view {
1074 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1075 	}
1076 
1077 	function log(bool p0, bool p1) internal view {
1078 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1079 	}
1080 
1081 	function log(bool p0, address p1) internal view {
1082 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1083 	}
1084 
1085 	function log(address p0, uint p1) internal view {
1086 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1087 	}
1088 
1089 	function log(address p0, string memory p1) internal view {
1090 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1091 	}
1092 
1093 	function log(address p0, bool p1) internal view {
1094 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1095 	}
1096 
1097 	function log(address p0, address p1) internal view {
1098 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1099 	}
1100 
1101 	function log(uint p0, uint p1, uint p2) internal view {
1102 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1103 	}
1104 
1105 	function log(uint p0, uint p1, string memory p2) internal view {
1106 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1107 	}
1108 
1109 	function log(uint p0, uint p1, bool p2) internal view {
1110 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1111 	}
1112 
1113 	function log(uint p0, uint p1, address p2) internal view {
1114 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1115 	}
1116 
1117 	function log(uint p0, string memory p1, uint p2) internal view {
1118 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1119 	}
1120 
1121 	function log(uint p0, string memory p1, string memory p2) internal view {
1122 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1123 	}
1124 
1125 	function log(uint p0, string memory p1, bool p2) internal view {
1126 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1127 	}
1128 
1129 	function log(uint p0, string memory p1, address p2) internal view {
1130 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1131 	}
1132 
1133 	function log(uint p0, bool p1, uint p2) internal view {
1134 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1135 	}
1136 
1137 	function log(uint p0, bool p1, string memory p2) internal view {
1138 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1139 	}
1140 
1141 	function log(uint p0, bool p1, bool p2) internal view {
1142 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1143 	}
1144 
1145 	function log(uint p0, bool p1, address p2) internal view {
1146 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1147 	}
1148 
1149 	function log(uint p0, address p1, uint p2) internal view {
1150 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1151 	}
1152 
1153 	function log(uint p0, address p1, string memory p2) internal view {
1154 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1155 	}
1156 
1157 	function log(uint p0, address p1, bool p2) internal view {
1158 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1159 	}
1160 
1161 	function log(uint p0, address p1, address p2) internal view {
1162 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1163 	}
1164 
1165 	function log(string memory p0, uint p1, uint p2) internal view {
1166 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1167 	}
1168 
1169 	function log(string memory p0, uint p1, string memory p2) internal view {
1170 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1171 	}
1172 
1173 	function log(string memory p0, uint p1, bool p2) internal view {
1174 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1175 	}
1176 
1177 	function log(string memory p0, uint p1, address p2) internal view {
1178 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1179 	}
1180 
1181 	function log(string memory p0, string memory p1, uint p2) internal view {
1182 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1183 	}
1184 
1185 	function log(string memory p0, string memory p1, string memory p2) internal view {
1186 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1187 	}
1188 
1189 	function log(string memory p0, string memory p1, bool p2) internal view {
1190 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1191 	}
1192 
1193 	function log(string memory p0, string memory p1, address p2) internal view {
1194 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1195 	}
1196 
1197 	function log(string memory p0, bool p1, uint p2) internal view {
1198 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1199 	}
1200 
1201 	function log(string memory p0, bool p1, string memory p2) internal view {
1202 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1203 	}
1204 
1205 	function log(string memory p0, bool p1, bool p2) internal view {
1206 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1207 	}
1208 
1209 	function log(string memory p0, bool p1, address p2) internal view {
1210 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1211 	}
1212 
1213 	function log(string memory p0, address p1, uint p2) internal view {
1214 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1215 	}
1216 
1217 	function log(string memory p0, address p1, string memory p2) internal view {
1218 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1219 	}
1220 
1221 	function log(string memory p0, address p1, bool p2) internal view {
1222 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1223 	}
1224 
1225 	function log(string memory p0, address p1, address p2) internal view {
1226 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1227 	}
1228 
1229 	function log(bool p0, uint p1, uint p2) internal view {
1230 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1231 	}
1232 
1233 	function log(bool p0, uint p1, string memory p2) internal view {
1234 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1235 	}
1236 
1237 	function log(bool p0, uint p1, bool p2) internal view {
1238 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1239 	}
1240 
1241 	function log(bool p0, uint p1, address p2) internal view {
1242 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1243 	}
1244 
1245 	function log(bool p0, string memory p1, uint p2) internal view {
1246 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1247 	}
1248 
1249 	function log(bool p0, string memory p1, string memory p2) internal view {
1250 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1251 	}
1252 
1253 	function log(bool p0, string memory p1, bool p2) internal view {
1254 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1255 	}
1256 
1257 	function log(bool p0, string memory p1, address p2) internal view {
1258 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1259 	}
1260 
1261 	function log(bool p0, bool p1, uint p2) internal view {
1262 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1263 	}
1264 
1265 	function log(bool p0, bool p1, string memory p2) internal view {
1266 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1267 	}
1268 
1269 	function log(bool p0, bool p1, bool p2) internal view {
1270 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1271 	}
1272 
1273 	function log(bool p0, bool p1, address p2) internal view {
1274 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1275 	}
1276 
1277 	function log(bool p0, address p1, uint p2) internal view {
1278 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1279 	}
1280 
1281 	function log(bool p0, address p1, string memory p2) internal view {
1282 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1283 	}
1284 
1285 	function log(bool p0, address p1, bool p2) internal view {
1286 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1287 	}
1288 
1289 	function log(bool p0, address p1, address p2) internal view {
1290 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1291 	}
1292 
1293 	function log(address p0, uint p1, uint p2) internal view {
1294 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1295 	}
1296 
1297 	function log(address p0, uint p1, string memory p2) internal view {
1298 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1299 	}
1300 
1301 	function log(address p0, uint p1, bool p2) internal view {
1302 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1303 	}
1304 
1305 	function log(address p0, uint p1, address p2) internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1307 	}
1308 
1309 	function log(address p0, string memory p1, uint p2) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1311 	}
1312 
1313 	function log(address p0, string memory p1, string memory p2) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1315 	}
1316 
1317 	function log(address p0, string memory p1, bool p2) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1319 	}
1320 
1321 	function log(address p0, string memory p1, address p2) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1323 	}
1324 
1325 	function log(address p0, bool p1, uint p2) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1327 	}
1328 
1329 	function log(address p0, bool p1, string memory p2) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1331 	}
1332 
1333 	function log(address p0, bool p1, bool p2) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1335 	}
1336 
1337 	function log(address p0, bool p1, address p2) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1339 	}
1340 
1341 	function log(address p0, address p1, uint p2) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1343 	}
1344 
1345 	function log(address p0, address p1, string memory p2) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1347 	}
1348 
1349 	function log(address p0, address p1, bool p2) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1351 	}
1352 
1353 	function log(address p0, address p1, address p2) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1355 	}
1356 
1357 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1359 	}
1360 
1361 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1363 	}
1364 
1365 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1367 	}
1368 
1369 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1371 	}
1372 
1373 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1375 	}
1376 
1377 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1379 	}
1380 
1381 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1383 	}
1384 
1385 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1387 	}
1388 
1389 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1391 	}
1392 
1393 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1395 	}
1396 
1397 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1399 	}
1400 
1401 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1403 	}
1404 
1405 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1407 	}
1408 
1409 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1411 	}
1412 
1413 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1415 	}
1416 
1417 	function log(uint p0, uint p1, address p2, address p3) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1419 	}
1420 
1421 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1423 	}
1424 
1425 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1427 	}
1428 
1429 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1431 	}
1432 
1433 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1435 	}
1436 
1437 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1439 	}
1440 
1441 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1443 	}
1444 
1445 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1447 	}
1448 
1449 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1451 	}
1452 
1453 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1455 	}
1456 
1457 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1459 	}
1460 
1461 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1463 	}
1464 
1465 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1467 	}
1468 
1469 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1471 	}
1472 
1473 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1475 	}
1476 
1477 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1479 	}
1480 
1481 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1483 	}
1484 
1485 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1487 	}
1488 
1489 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1491 	}
1492 
1493 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1495 	}
1496 
1497 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1499 	}
1500 
1501 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1503 	}
1504 
1505 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1507 	}
1508 
1509 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1511 	}
1512 
1513 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1515 	}
1516 
1517 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1519 	}
1520 
1521 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1523 	}
1524 
1525 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1527 	}
1528 
1529 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1531 	}
1532 
1533 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1535 	}
1536 
1537 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1539 	}
1540 
1541 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1542 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1543 	}
1544 
1545 	function log(uint p0, bool p1, address p2, address p3) internal view {
1546 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1547 	}
1548 
1549 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1550 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1551 	}
1552 
1553 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1554 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1555 	}
1556 
1557 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1558 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1559 	}
1560 
1561 	function log(uint p0, address p1, uint p2, address p3) internal view {
1562 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1563 	}
1564 
1565 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1566 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1567 	}
1568 
1569 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1570 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1571 	}
1572 
1573 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1574 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1575 	}
1576 
1577 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1578 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1579 	}
1580 
1581 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1582 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1583 	}
1584 
1585 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1586 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1587 	}
1588 
1589 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1590 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1591 	}
1592 
1593 	function log(uint p0, address p1, bool p2, address p3) internal view {
1594 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1595 	}
1596 
1597 	function log(uint p0, address p1, address p2, uint p3) internal view {
1598 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1599 	}
1600 
1601 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1602 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1603 	}
1604 
1605 	function log(uint p0, address p1, address p2, bool p3) internal view {
1606 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1607 	}
1608 
1609 	function log(uint p0, address p1, address p2, address p3) internal view {
1610 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1611 	}
1612 
1613 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1614 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1615 	}
1616 
1617 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1618 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1619 	}
1620 
1621 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1622 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1623 	}
1624 
1625 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1626 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1627 	}
1628 
1629 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1630 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1631 	}
1632 
1633 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1634 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1635 	}
1636 
1637 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1638 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1639 	}
1640 
1641 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1642 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1643 	}
1644 
1645 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1646 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1647 	}
1648 
1649 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1650 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1651 	}
1652 
1653 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1654 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1655 	}
1656 
1657 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1658 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1659 	}
1660 
1661 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1662 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1663 	}
1664 
1665 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1666 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1667 	}
1668 
1669 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1670 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1671 	}
1672 
1673 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1674 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1675 	}
1676 
1677 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1678 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1679 	}
1680 
1681 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1682 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1683 	}
1684 
1685 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1686 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1687 	}
1688 
1689 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1690 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1691 	}
1692 
1693 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1694 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1695 	}
1696 
1697 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1698 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1699 	}
1700 
1701 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1702 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1703 	}
1704 
1705 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1706 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1707 	}
1708 
1709 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1710 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1711 	}
1712 
1713 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1714 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1715 	}
1716 
1717 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1718 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1719 	}
1720 
1721 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1722 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1723 	}
1724 
1725 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1726 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1727 	}
1728 
1729 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1730 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1731 	}
1732 
1733 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1734 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1735 	}
1736 
1737 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1738 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1739 	}
1740 
1741 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1742 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1743 	}
1744 
1745 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1746 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1747 	}
1748 
1749 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1750 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1751 	}
1752 
1753 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1754 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1755 	}
1756 
1757 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1758 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1759 	}
1760 
1761 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1762 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1763 	}
1764 
1765 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1766 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1767 	}
1768 
1769 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1770 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1771 	}
1772 
1773 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1774 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1775 	}
1776 
1777 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1778 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1779 	}
1780 
1781 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1782 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1783 	}
1784 
1785 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1786 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1787 	}
1788 
1789 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1790 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1791 	}
1792 
1793 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1794 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1795 	}
1796 
1797 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1798 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1799 	}
1800 
1801 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1802 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1803 	}
1804 
1805 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1806 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1807 	}
1808 
1809 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1810 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1811 	}
1812 
1813 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1814 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1815 	}
1816 
1817 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1818 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1819 	}
1820 
1821 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1822 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1823 	}
1824 
1825 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1826 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1827 	}
1828 
1829 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1830 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1831 	}
1832 
1833 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1834 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1835 	}
1836 
1837 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1838 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1839 	}
1840 
1841 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1842 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1843 	}
1844 
1845 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1846 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1847 	}
1848 
1849 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1850 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1851 	}
1852 
1853 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1854 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1855 	}
1856 
1857 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1858 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1859 	}
1860 
1861 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1862 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1863 	}
1864 
1865 	function log(string memory p0, address p1, address p2, address p3) internal view {
1866 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1867 	}
1868 
1869 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1870 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1871 	}
1872 
1873 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1874 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1875 	}
1876 
1877 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1878 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1879 	}
1880 
1881 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1882 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1883 	}
1884 
1885 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1886 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1887 	}
1888 
1889 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1890 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1891 	}
1892 
1893 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1894 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1895 	}
1896 
1897 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1898 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1899 	}
1900 
1901 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1902 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1903 	}
1904 
1905 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1906 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1907 	}
1908 
1909 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1910 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1911 	}
1912 
1913 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1914 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1915 	}
1916 
1917 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1918 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1919 	}
1920 
1921 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1922 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1923 	}
1924 
1925 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1926 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1927 	}
1928 
1929 	function log(bool p0, uint p1, address p2, address p3) internal view {
1930 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1931 	}
1932 
1933 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1934 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1935 	}
1936 
1937 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1938 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1939 	}
1940 
1941 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1942 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1943 	}
1944 
1945 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1946 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1947 	}
1948 
1949 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1950 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1951 	}
1952 
1953 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1954 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1955 	}
1956 
1957 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1958 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1959 	}
1960 
1961 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1962 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1963 	}
1964 
1965 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1966 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1967 	}
1968 
1969 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1970 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1971 	}
1972 
1973 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1974 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1975 	}
1976 
1977 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1978 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1979 	}
1980 
1981 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1982 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1983 	}
1984 
1985 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1986 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1987 	}
1988 
1989 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1990 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1991 	}
1992 
1993 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1994 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1995 	}
1996 
1997 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1998 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1999 	}
2000 
2001 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2002 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2003 	}
2004 
2005 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2006 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2007 	}
2008 
2009 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2010 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2011 	}
2012 
2013 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2014 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2015 	}
2016 
2017 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2018 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2019 	}
2020 
2021 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2022 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2023 	}
2024 
2025 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2026 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2027 	}
2028 
2029 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2030 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2031 	}
2032 
2033 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2034 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2035 	}
2036 
2037 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2038 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2039 	}
2040 
2041 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2042 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2043 	}
2044 
2045 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2046 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2047 	}
2048 
2049 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2050 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2051 	}
2052 
2053 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2054 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2055 	}
2056 
2057 	function log(bool p0, bool p1, address p2, address p3) internal view {
2058 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2059 	}
2060 
2061 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2062 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2063 	}
2064 
2065 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2066 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2067 	}
2068 
2069 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2070 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2071 	}
2072 
2073 	function log(bool p0, address p1, uint p2, address p3) internal view {
2074 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2075 	}
2076 
2077 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2078 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2079 	}
2080 
2081 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2082 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2083 	}
2084 
2085 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2086 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2087 	}
2088 
2089 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2090 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2091 	}
2092 
2093 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2094 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2095 	}
2096 
2097 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2098 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2099 	}
2100 
2101 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2102 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2103 	}
2104 
2105 	function log(bool p0, address p1, bool p2, address p3) internal view {
2106 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2107 	}
2108 
2109 	function log(bool p0, address p1, address p2, uint p3) internal view {
2110 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2111 	}
2112 
2113 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2114 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2115 	}
2116 
2117 	function log(bool p0, address p1, address p2, bool p3) internal view {
2118 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2119 	}
2120 
2121 	function log(bool p0, address p1, address p2, address p3) internal view {
2122 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2123 	}
2124 
2125 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2126 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2127 	}
2128 
2129 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2130 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2131 	}
2132 
2133 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2134 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2135 	}
2136 
2137 	function log(address p0, uint p1, uint p2, address p3) internal view {
2138 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2139 	}
2140 
2141 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2142 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2143 	}
2144 
2145 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2146 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2147 	}
2148 
2149 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2150 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2151 	}
2152 
2153 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2154 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2155 	}
2156 
2157 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2158 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2159 	}
2160 
2161 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2162 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2163 	}
2164 
2165 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2166 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2167 	}
2168 
2169 	function log(address p0, uint p1, bool p2, address p3) internal view {
2170 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2171 	}
2172 
2173 	function log(address p0, uint p1, address p2, uint p3) internal view {
2174 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2175 	}
2176 
2177 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2178 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2179 	}
2180 
2181 	function log(address p0, uint p1, address p2, bool p3) internal view {
2182 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2183 	}
2184 
2185 	function log(address p0, uint p1, address p2, address p3) internal view {
2186 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2187 	}
2188 
2189 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2190 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2191 	}
2192 
2193 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2194 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2195 	}
2196 
2197 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2198 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2199 	}
2200 
2201 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2202 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2203 	}
2204 
2205 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2206 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2207 	}
2208 
2209 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2210 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2211 	}
2212 
2213 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2214 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2215 	}
2216 
2217 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2218 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2219 	}
2220 
2221 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2222 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2223 	}
2224 
2225 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2226 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2227 	}
2228 
2229 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2230 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2231 	}
2232 
2233 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2234 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2235 	}
2236 
2237 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2238 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2239 	}
2240 
2241 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2242 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2243 	}
2244 
2245 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2246 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2247 	}
2248 
2249 	function log(address p0, string memory p1, address p2, address p3) internal view {
2250 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2251 	}
2252 
2253 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2254 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2255 	}
2256 
2257 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2258 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2259 	}
2260 
2261 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2262 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2263 	}
2264 
2265 	function log(address p0, bool p1, uint p2, address p3) internal view {
2266 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2267 	}
2268 
2269 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2270 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2271 	}
2272 
2273 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2274 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2275 	}
2276 
2277 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2278 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2279 	}
2280 
2281 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2282 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2283 	}
2284 
2285 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2286 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2287 	}
2288 
2289 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2290 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2291 	}
2292 
2293 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2294 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2295 	}
2296 
2297 	function log(address p0, bool p1, bool p2, address p3) internal view {
2298 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2299 	}
2300 
2301 	function log(address p0, bool p1, address p2, uint p3) internal view {
2302 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2303 	}
2304 
2305 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2306 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2307 	}
2308 
2309 	function log(address p0, bool p1, address p2, bool p3) internal view {
2310 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2311 	}
2312 
2313 	function log(address p0, bool p1, address p2, address p3) internal view {
2314 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2315 	}
2316 
2317 	function log(address p0, address p1, uint p2, uint p3) internal view {
2318 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2319 	}
2320 
2321 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2322 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2323 	}
2324 
2325 	function log(address p0, address p1, uint p2, bool p3) internal view {
2326 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2327 	}
2328 
2329 	function log(address p0, address p1, uint p2, address p3) internal view {
2330 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2331 	}
2332 
2333 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2334 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2335 	}
2336 
2337 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2338 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2339 	}
2340 
2341 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2342 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2343 	}
2344 
2345 	function log(address p0, address p1, string memory p2, address p3) internal view {
2346 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2347 	}
2348 
2349 	function log(address p0, address p1, bool p2, uint p3) internal view {
2350 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2351 	}
2352 
2353 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2354 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2355 	}
2356 
2357 	function log(address p0, address p1, bool p2, bool p3) internal view {
2358 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2359 	}
2360 
2361 	function log(address p0, address p1, bool p2, address p3) internal view {
2362 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2363 	}
2364 
2365 	function log(address p0, address p1, address p2, uint p3) internal view {
2366 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2367 	}
2368 
2369 	function log(address p0, address p1, address p2, string memory p3) internal view {
2370 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2371 	}
2372 
2373 	function log(address p0, address p1, address p2, bool p3) internal view {
2374 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2375 	}
2376 
2377 	function log(address p0, address p1, address p2, address p3) internal view {
2378 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2379 	}
2380 
2381 }
2382 
2383 // upcore Vault distributes fees equally amongst staked pools
2384 // Have fun reading it. Hopefully it's bug-free. God bless.
2385 contract upcoreVault is OwnableUpgradeSafe {
2386     using SafeMath for uint256;
2387     using SafeERC20 for IERC20;
2388 
2389     // Info of each user.
2390     struct UserInfo {
2391         uint256 amount; // How many  tokens the user has provided.
2392         uint256 rewardDebt; // Reward debt. See explanation below.
2393         //
2394         // We do some fancy math here. Basically, any point in time, the amount of upcores
2395         // entitled to a user but is pending to be distributed is:
2396         //
2397         //   pending reward = (user.amount * pool.accupcorePerShare) - user.rewardDebt
2398         //
2399         // Whenever a user deposits or withdraws  tokens to a pool. Here's what happens:
2400         //   1. The pool's `accupcorePerShare` (and `lastRewardBlock`) gets updated.
2401         //   2. User receives the pending reward sent to his/her address.
2402         //   3. User's `amount` gets updated.
2403         //   4. User's `rewardDebt` gets updated.
2404 
2405     }
2406 
2407     // Info of each pool.
2408     struct PoolInfo {
2409         IERC20 token; // Address of  token contract.
2410         uint256 allocPoint; // How many allocation points assigned to this pool. upcores to distribute per block.
2411         uint256 accupcorePerShare; // Accumulated upcores per share, times 1e12. See below.
2412         bool withdrawable; // Is this pool withdrawable?
2413         mapping(address => mapping(address => uint256)) allowance;
2414 
2415     }
2416 
2417     // The upcore TOKEN!
2418     INBUNIERC20 public upcore;
2419     // Dev address.
2420     address public devaddr;
2421 
2422     // Info of each pool.
2423     PoolInfo[] public poolInfo;
2424     // Info of each user that stakes  tokens.
2425     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
2426     // Total allocation poitns. Must be the sum of all allocation points in all pools.
2427     uint256 public totalAllocPoint;
2428 
2429     //// pending rewards awaiting anyone to massUpdate
2430     uint256 public pendingRewards;
2431 
2432     uint256 public contractStartBlock;
2433     uint256 public epochCalculationStartBlock;
2434     uint256 public cumulativeRewardsSinceStart;
2435     uint256 public rewardsInThisEpoch;
2436     uint public epoch;
2437 
2438     // Returns fees generated since start of this contract
2439     function averageFeesPerBlockSinceStart() external view returns (uint averagePerBlock) {
2440         averagePerBlock = cumulativeRewardsSinceStart.add(rewardsInThisEpoch).div(block.number.sub(contractStartBlock));
2441     }
2442 
2443     // Returns averge fees in this epoch
2444     function averageFeesPerBlockEpoch() external view returns (uint256 averagePerBlock) {
2445         averagePerBlock = rewardsInThisEpoch.div(block.number.sub(epochCalculationStartBlock));
2446     }
2447 
2448     // For easy graphing historical epoch rewards
2449     mapping(uint => uint256) public epochRewards;
2450 
2451     //Starts a new calculation epoch
2452     // Because averge since start will not be accurate
2453     function startNewEpoch() public {
2454         require(epochCalculationStartBlock + 50000 < block.number, "New epoch not ready yet"); // About a week
2455         epochRewards[epoch] = rewardsInThisEpoch;
2456         cumulativeRewardsSinceStart = cumulativeRewardsSinceStart.add(rewardsInThisEpoch);
2457         rewardsInThisEpoch = 0;
2458         epochCalculationStartBlock = block.number;
2459         ++epoch;
2460     }
2461 
2462     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
2463     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
2464     event EmergencyWithdraw(
2465         address indexed user,
2466         uint256 indexed pid,
2467         uint256 amount
2468     );
2469     event Approval(address indexed owner, address indexed spender, uint256 _pid, uint256 value);
2470 
2471 
2472     function initialize(
2473         INBUNIERC20 _upcore,
2474         address _devaddr,
2475         address superAdmin
2476     ) public initializer {
2477         OwnableUpgradeSafe.__Ownable_init();
2478         DEV_FEE = 1000;
2479         upcore = _upcore;
2480         devaddr = _devaddr;
2481         contractStartBlock = block.number;
2482         _superAdmin = superAdmin;
2483     }
2484 
2485     function poolLength() external view returns (uint256) {
2486         return poolInfo.length;
2487     }
2488 
2489 
2490 
2491     // Add a new token pool. Can only be called by the owner.
2492     // Note contract owner is meant to be a governance contract allowing upcore governance consensus
2493     function add(
2494         uint256 _allocPoint,
2495         IERC20 _token,
2496         bool _withUpdate,
2497         bool _withdrawable
2498     ) public onlyOwner {
2499         if (_withUpdate) {
2500             massUpdatePools();
2501         }
2502 
2503         uint256 length = poolInfo.length;
2504         for (uint256 pid = 0; pid < length; ++pid) {
2505             require(poolInfo[pid].token != _token,"Error pool already added");
2506         }
2507 
2508         totalAllocPoint = totalAllocPoint.add(_allocPoint);
2509 
2510 
2511         poolInfo.push(
2512             PoolInfo({
2513                 token: _token,
2514                 allocPoint: _allocPoint,
2515                 accupcorePerShare: 0,
2516                 withdrawable : _withdrawable
2517             })
2518         );
2519     }
2520 
2521     // Update the given pool's upcores allocation point. Can only be called by the owner.
2522         // Note contract owner is meant to be a governance contract allowing upcore governance consensus
2523 
2524     function set(
2525         uint256 _pid,
2526         uint256 _allocPoint,
2527         bool _withUpdate
2528     ) public onlyOwner {
2529         if (_withUpdate) {
2530             massUpdatePools();
2531         }
2532 
2533         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
2534             _allocPoint
2535         );
2536         poolInfo[_pid].allocPoint = _allocPoint;
2537     }
2538 
2539     // Update the given pool's ability to withdraw tokens
2540     // Note contract owner is meant to be a governance contract allowing upcore governance consensus
2541     function setPoolWithdrawable(
2542         uint256 _pid,
2543         bool _withdrawable
2544     ) public onlyOwner {
2545         poolInfo[_pid].withdrawable = _withdrawable;
2546     }
2547 
2548 
2549 
2550     // Sets the dev fee for this contract
2551     // defaults at 7.24%
2552     // Note contract owner is meant to be a governance contract allowing upcore governance consensus
2553     uint16 DEV_FEE;
2554     function setDevFee(uint16 _DEV_FEE) public onlyOwner {
2555         require(_DEV_FEE <= 1000, 'Dev fee clamped at 10%');
2556         DEV_FEE = _DEV_FEE;
2557     }
2558     uint256 pending_DEV_rewards;
2559 
2560 
2561     // View function to see pending upcores on frontend.
2562     function pendingupcore(uint256 _pid, address _user)
2563         external
2564         view
2565         returns (uint256)
2566     {
2567         PoolInfo storage pool = poolInfo[_pid];
2568         UserInfo storage user = userInfo[_pid][_user];
2569         uint256 accupcorePerShare = pool.accupcorePerShare;
2570 
2571         return user.amount.mul(accupcorePerShare).div(1e12).sub(user.rewardDebt);
2572     }
2573 
2574     // Update reward vairables for all pools. Be careful of gas spending!
2575     function massUpdatePools() public {
2576         console.log("Mass Updating Pools");
2577         uint256 length = poolInfo.length;
2578         uint allRewards;
2579         for (uint256 pid = 0; pid < length; ++pid) {
2580             allRewards = allRewards.add(updatePool(pid));
2581         }
2582 
2583         pendingRewards = pendingRewards.sub(allRewards);
2584     }
2585 
2586     // ----
2587     // Function that adds pending rewards, called by the upcore token.
2588     // ----
2589     uint256 private upcoreBalance;
2590     function addPendingRewards(uint256 _) public {
2591         uint256 newRewards = upcore.balanceOf(address(this)).sub(upcoreBalance);
2592 
2593         if(newRewards > 0) {
2594             upcoreBalance = upcore.balanceOf(address(this)); // If there is no change the balance didn't change
2595             pendingRewards = pendingRewards.add(newRewards);
2596             rewardsInThisEpoch = rewardsInThisEpoch.add(newRewards);
2597         }
2598     }
2599 
2600     // Update reward variables of the given pool to be up-to-date.
2601     function updatePool(uint256 _pid) internal returns (uint256 upcoreRewardWhole) {
2602         PoolInfo storage pool = poolInfo[_pid];
2603 
2604         uint256 tokenSupply = pool.token.balanceOf(address(this));
2605         if (tokenSupply == 0) { // avoids division by 0 errors
2606             return 0;
2607         }
2608         upcoreRewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
2609             .mul(pool.allocPoint)        // getting the percent of total pending rewards this pool should get
2610             .div(totalAllocPoint);       // we can do this because pools are only mass updated
2611         uint256 upcoreRewardFee = upcoreRewardWhole.mul(DEV_FEE).div(10000);
2612         uint256 upcoreRewardToDistribute = upcoreRewardWhole.sub(upcoreRewardFee);
2613 
2614         pending_DEV_rewards = pending_DEV_rewards.add(upcoreRewardFee);
2615 
2616         pool.accupcorePerShare = pool.accupcorePerShare.add(
2617             upcoreRewardToDistribute.mul(1e12).div(tokenSupply)
2618         );
2619 
2620     }
2621 
2622     // Deposit  tokens to upcoreVault for upcore allocation.
2623     function deposit(uint256 _pid, uint256 _amount) public {
2624 
2625         PoolInfo storage pool = poolInfo[_pid];
2626         UserInfo storage user = userInfo[_pid][msg.sender];
2627 
2628         massUpdatePools();
2629 
2630         // Transfer pending tokens
2631         // to user
2632         updateAndPayOutPending(_pid, pool, user, msg.sender);
2633 
2634 
2635         //Transfer in the amounts from user
2636         // save gas
2637         if(_amount > 0) {
2638             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
2639             user.amount = user.amount.add(_amount);
2640         }
2641 
2642         user.rewardDebt = user.amount.mul(pool.accupcorePerShare).div(1e12);
2643         emit Deposit(msg.sender, _pid, _amount);
2644     }
2645 
2646     // Test coverage
2647     // [x] Does user get the deposited amounts?
2648     // [x] Does user that its deposited for update correcty?
2649     // [x] Does the depositor get their tokens decreased
2650     function depositFor(address depositFor, uint256 _pid, uint256 _amount) public {
2651         // requires no allowances
2652         PoolInfo storage pool = poolInfo[_pid];
2653         UserInfo storage user = userInfo[_pid][depositFor];
2654 
2655         massUpdatePools();
2656 
2657         // Transfer pending tokens
2658         // to user
2659         updateAndPayOutPending(_pid, pool, user, depositFor); // Update the balances of person that amount is being deposited for
2660 
2661         if(_amount > 0) {
2662             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
2663             user.amount = user.amount.add(_amount); // This is depositedFor address
2664         }
2665 
2666         user.rewardDebt = user.amount.mul(pool.accupcorePerShare).div(1e12); /// This is deposited for address
2667         emit Deposit(depositFor, _pid, _amount);
2668 
2669     }
2670 
2671     // Test coverage
2672     // [x] Does allowance update correctly?
2673     function setAllowanceForPoolToken(address spender, uint256 _pid, uint256 value) public {
2674         PoolInfo storage pool = poolInfo[_pid];
2675         pool.allowance[msg.sender][spender] = value;
2676         emit Approval(msg.sender, spender, _pid, value);
2677     }
2678 
2679     // Test coverage
2680     // [x] Does allowance decrease?
2681     // [x] Do oyu need allowance
2682     // [x] Withdraws to correct address
2683     function withdrawFrom(address owner, uint256 _pid, uint256 _amount) public{
2684 
2685         PoolInfo storage pool = poolInfo[_pid];
2686         require(pool.allowance[owner][msg.sender] >= _amount, "withdraw: insufficient allowance");
2687         pool.allowance[owner][msg.sender] = pool.allowance[owner][msg.sender].sub(_amount);
2688         _withdraw(_pid, _amount, owner, msg.sender);
2689 
2690     }
2691 
2692 
2693     // Withdraw  tokens from upcoreVault.
2694     function withdraw(uint256 _pid, uint256 _amount) public {
2695 
2696         _withdraw(_pid, _amount, msg.sender, msg.sender);
2697 
2698     }
2699 
2700 
2701 
2702 
2703     // Low level withdraw function
2704     function _withdraw(uint256 _pid, uint256 _amount, address from, address to) internal {
2705         PoolInfo storage pool = poolInfo[_pid];
2706         require(pool.withdrawable, "Withdrawing from this pool is disabled");
2707         UserInfo storage user = userInfo[_pid][from];
2708         require(user.amount >= _amount, "withdraw: not good");
2709 
2710         massUpdatePools();
2711         updateAndPayOutPending(_pid,  pool, user, from); // Update balances of from this is not withdrawal but claiming upcore farmed
2712 
2713         if(_amount > 0) {
2714             user.amount = user.amount.sub(_amount);
2715             pool.token.safeTransfer(address(to), _amount);
2716         }
2717         user.rewardDebt = user.amount.mul(pool.accupcorePerShare).div(1e12);
2718 
2719         emit Withdraw(to, _pid, _amount);
2720     }
2721 
2722     function claim(uint256 _pid) public {
2723         PoolInfo storage pool = poolInfo[_pid];
2724         require(pool.withdrawable, "Withdrawing from this pool is disabled");
2725         UserInfo storage user = userInfo[_pid][msg.sender];
2726         
2727         massUpdatePools();
2728         updateAndPayOutPending(_pid, pool, user, msg.sender);
2729     }
2730 
2731     function updateAndPayOutPending(uint256 _pid, PoolInfo storage pool, UserInfo storage user, address from) internal {
2732 
2733         if(user.amount == 0) return;
2734 
2735         uint256 pending = user
2736             .amount
2737             .mul(pool.accupcorePerShare)
2738             .div(1e12)
2739             .sub(user.rewardDebt);
2740 
2741         if(pending > 0) {
2742             safeupcoreTransfer(from, pending);
2743         }
2744 
2745     }
2746 
2747     // function that lets owner/governance contract
2748     // approve allowance for any token inside this contract
2749     // This means all future UNI like airdrops are covered
2750     // And at the same time allows us to give allowance to strategy contracts.
2751     // Upcoming cYFI etc vaults strategy contracts will  se this function to manage and farm yield on value locked
2752     function setStrategyContractOrDistributionContractAllowance(address tokenAddress, uint256 _amount, address contractAddress) public onlySuperAdmin {
2753         require(isContract(contractAddress), "Recipent is not a smart contract, BAD");
2754         require(block.number > contractStartBlock.add(95_000), "Governance setup grace period not over"); // about 2weeks
2755         IERC20(tokenAddress).approve(contractAddress, _amount);
2756     }
2757 
2758     function isContract(address addr) public returns (bool) {
2759         uint size;
2760         assembly { size := extcodesize(addr) }
2761         return size > 0;
2762     }
2763 
2764 
2765 
2766 
2767 
2768     // Withdraw without caring about rewards. EMERGENCY ONLY.
2769     // !Caution this will remove all your pending rewards!
2770     function emergencyWithdraw(uint256 _pid) public {
2771         PoolInfo storage pool = poolInfo[_pid];
2772         require(pool.withdrawable, "Withdrawing from this pool is disabled");
2773         UserInfo storage user = userInfo[_pid][msg.sender];
2774         pool.token.safeTransfer(address(msg.sender), user.amount);
2775         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
2776         user.amount = 0;
2777         user.rewardDebt = 0;
2778         // No mass update dont update pending rewards
2779     }
2780 
2781     // Safe upcore transfer function, just in case if rounding error causes pool to not have enough upcores.
2782     function safeupcoreTransfer(address _to, uint256 _amount) internal {
2783         if(_amount == 0) return;
2784 
2785         uint256 upcoreBal = upcore.balanceOf(address(this));
2786         if (_amount > upcoreBal) {
2787             console.log("transfering out for to person:", _amount);
2788             console.log("Balance of this address is :", upcoreBal);
2789 
2790             upcore.transfer(_to, upcoreBal);
2791             upcoreBalance = upcore.balanceOf(address(this));
2792 
2793         } else {
2794             upcore.transfer(_to, _amount);
2795             upcoreBalance = upcore.balanceOf(address(this));
2796 
2797         }
2798 
2799         if(pending_DEV_rewards > 0) {
2800             uint256 devSend = pending_DEV_rewards; // Avoid recursive loop
2801             pending_DEV_rewards = 0;
2802             safeupcoreTransfer(devaddr, devSend);
2803         }
2804 
2805     }
2806 
2807     // Update dev address by the previous dev.
2808     // Note onlyOwner functions are meant for the governance contract
2809     // allowing upcore governance token holders to do this functions.
2810     function setDevFeeReciever(address _devaddr) public onlyOwner {
2811         devaddr = _devaddr;
2812     }
2813 
2814 
2815 
2816     address private _superAdmin;
2817 
2818     event SuperAdminTransfered(address indexed previousOwner, address indexed newOwner);
2819 
2820 
2821 
2822     /**
2823      * @dev Returns the address of the current super admin
2824      */
2825     function superAdmin() public view returns (address) {
2826         return _superAdmin;
2827     }
2828 
2829     /**
2830      * @dev Throws if called by any account other than the superAdmin
2831      */
2832     modifier onlySuperAdmin() {
2833         require(_superAdmin == _msgSender(), "Super admin : caller is not super admin.");
2834         _;
2835     }
2836 
2837     // Assisns super admint to address 0, making it unreachable forever
2838     function burnSuperAdmin() public virtual onlySuperAdmin {
2839         emit SuperAdminTransfered(_superAdmin, address(0));
2840         _superAdmin = address(0);
2841     }
2842 
2843     // Super admin can transfer its powers to another address
2844     function newSuperAdmin(address newOwner) public virtual onlySuperAdmin {
2845         require(newOwner != address(0), "Ownable: new owner is the zero address");
2846         emit SuperAdminTransfered(_superAdmin, newOwner);
2847         _superAdmin = newOwner;
2848     }
2849 }