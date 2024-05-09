1 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol
80 
81 pragma solidity ^0.6.0;
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
232 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol
233 
234 pragma solidity ^0.6.2;
235 
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
259         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
260         // for accounts without code, i.e. `keccak256('')`
261         bytes32 codehash;
262         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
263         // solhint-disable-next-line no-inline-assembly
264         assembly { codehash := extcodehash(account) }
265         return (codehash != accountHash && codehash != 0x0);
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
288         (bool success, ) = recipient.call{ value: amount }("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 }
292 
293 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol
294 
295 pragma solidity ^0.6.0;
296 
297 
298 
299 
300 /**
301  * @title SafeERC20
302  * @dev Wrappers around ERC20 operations that throw on failure (when the token
303  * contract returns false). Tokens that return no value (and instead revert or
304  * throw on failure) are also supported, non-reverting calls are assumed to be
305  * successful.
306  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
307  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
308  */
309 library SafeERC20 {
310     using SafeMath for uint256;
311     using Address for address;
312 
313     function safeTransfer(IERC20 token, address to, uint256 value) internal {
314         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
315     }
316 
317     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
318         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
319     }
320 
321     function safeApprove(IERC20 token, address spender, uint256 value) internal {
322         // safeApprove should only be called when setting an initial allowance,
323         // or when resetting it to zero. To increase and decrease it, use
324         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
325         // solhint-disable-next-line max-line-length
326         require((value == 0) || (token.allowance(address(this), spender) == 0),
327             "SafeERC20: approve from non-zero to non-zero allowance"
328         );
329         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
330     }
331 
332     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
333         uint256 newAllowance = token.allowance(address(this), spender).add(value);
334         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
335     }
336 
337     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
338         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
339         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
340     }
341 
342     /**
343      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
344      * on the return value: the return value is optional (but if data is returned, it must not be false).
345      * @param token The token targeted by the call.
346      * @param data The call data (encoded using abi.encode or one of its variants).
347      */
348     function _callOptionalReturn(IERC20 token, bytes memory data) private {
349         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
350         // we're implementing it ourselves.
351 
352         // A Solidity high level call has three parts:
353         //  1. The target address is checked to verify it contains contract code
354         //  2. The call itself is made, and success asserted
355         //  3. The return value is decoded, which in turn checks the size of the returned data.
356         // solhint-disable-next-line max-line-length
357         require(address(token).isContract(), "SafeERC20: call to non-contract");
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = address(token).call(data);
361         require(success, "SafeERC20: low-level call failed");
362 
363         if (returndata.length > 0) { // Return data is optional
364             // solhint-disable-next-line max-line-length
365             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
366         }
367     }
368 }
369 
370 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/EnumerableSet.sol
371 
372 pragma solidity ^0.6.0;
373 
374 /**
375  * @dev Library for managing
376  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
377  * types.
378  *
379  * Sets have the following properties:
380  *
381  * - Elements are added, removed, and checked for existence in constant time
382  * (O(1)).
383  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
384  *
385  * ```
386  * contract Example {
387  *     // Add the library methods
388  *     using EnumerableSet for EnumerableSet.AddressSet;
389  *
390  *     // Declare a set state variable
391  *     EnumerableSet.AddressSet private mySet;
392  * }
393  * ```
394  *
395  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
396  * (`UintSet`) are supported.
397  */
398 library EnumerableSet {
399     // To implement this library for multiple types with as little code
400     // repetition as possible, we write it in terms of a generic Set type with
401     // bytes32 values.
402     // The Set implementation uses private functions, and user-facing
403     // implementations (such as AddressSet) are just wrappers around the
404     // underlying Set.
405     // This means that we can only create new EnumerableSets for types that fit
406     // in bytes32.
407 
408     struct Set {
409         // Storage of set values
410         bytes32[] _values;
411 
412         // Position of the value in the `values` array, plus 1 because index 0
413         // means a value is not in the set.
414         mapping (bytes32 => uint256) _indexes;
415     }
416 
417     /**
418      * @dev Add a value to a set. O(1).
419      *
420      * Returns true if the value was added to the set, that is if it was not
421      * already present.
422      */
423     function _add(Set storage set, bytes32 value) private returns (bool) {
424         if (!_contains(set, value)) {
425             set._values.push(value);
426             // The value is stored at length-1, but we add 1 to all indexes
427             // and use 0 as a sentinel value
428             set._indexes[value] = set._values.length;
429             return true;
430         } else {
431             return false;
432         }
433     }
434 
435     /**
436      * @dev Removes a value from a set. O(1).
437      *
438      * Returns true if the value was removed from the set, that is if it was
439      * present.
440      */
441     function _remove(Set storage set, bytes32 value) private returns (bool) {
442         // We read and store the value's index to prevent multiple reads from the same storage slot
443         uint256 valueIndex = set._indexes[value];
444 
445         if (valueIndex != 0) { // Equivalent to contains(set, value)
446             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
447             // the array, and then remove the last element (sometimes called as 'swap and pop').
448             // This modifies the order of the array, as noted in {at}.
449 
450             uint256 toDeleteIndex = valueIndex - 1;
451             uint256 lastIndex = set._values.length - 1;
452 
453             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
454             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
455 
456             bytes32 lastvalue = set._values[lastIndex];
457 
458             // Move the last value to the index where the value to delete is
459             set._values[toDeleteIndex] = lastvalue;
460             // Update the index for the moved value
461             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
462 
463             // Delete the slot where the moved value was stored
464             set._values.pop();
465 
466             // Delete the index for the deleted slot
467             delete set._indexes[value];
468 
469             return true;
470         } else {
471             return false;
472         }
473     }
474 
475     /**
476      * @dev Returns true if the value is in the set. O(1).
477      */
478     function _contains(Set storage set, bytes32 value) private view returns (bool) {
479         return set._indexes[value] != 0;
480     }
481 
482     /**
483      * @dev Returns the number of values on the set. O(1).
484      */
485     function _length(Set storage set) private view returns (uint256) {
486         return set._values.length;
487     }
488 
489    /**
490     * @dev Returns the value stored at position `index` in the set. O(1).
491     *
492     * Note that there are no guarantees on the ordering of values inside the
493     * array, and it may change when more values are added or removed.
494     *
495     * Requirements:
496     *
497     * - `index` must be strictly less than {length}.
498     */
499     function _at(Set storage set, uint256 index) private view returns (bytes32) {
500         require(set._values.length > index, "EnumerableSet: index out of bounds");
501         return set._values[index];
502     }
503 
504     // AddressSet
505 
506     struct AddressSet {
507         Set _inner;
508     }
509 
510     /**
511      * @dev Add a value to a set. O(1).
512      *
513      * Returns true if the value was added to the set, that is if it was not
514      * already present.
515      */
516     function add(AddressSet storage set, address value) internal returns (bool) {
517         return _add(set._inner, bytes32(uint256(value)));
518     }
519 
520     /**
521      * @dev Removes a value from a set. O(1).
522      *
523      * Returns true if the value was removed from the set, that is if it was
524      * present.
525      */
526     function remove(AddressSet storage set, address value) internal returns (bool) {
527         return _remove(set._inner, bytes32(uint256(value)));
528     }
529 
530     /**
531      * @dev Returns true if the value is in the set. O(1).
532      */
533     function contains(AddressSet storage set, address value) internal view returns (bool) {
534         return _contains(set._inner, bytes32(uint256(value)));
535     }
536 
537     /**
538      * @dev Returns the number of values in the set. O(1).
539      */
540     function length(AddressSet storage set) internal view returns (uint256) {
541         return _length(set._inner);
542     }
543 
544    /**
545     * @dev Returns the value stored at position `index` in the set. O(1).
546     *
547     * Note that there are no guarantees on the ordering of values inside the
548     * array, and it may change when more values are added or removed.
549     *
550     * Requirements:
551     *
552     * - `index` must be strictly less than {length}.
553     */
554     function at(AddressSet storage set, uint256 index) internal view returns (address) {
555         return address(uint256(_at(set._inner, index)));
556     }
557 
558 
559     // UintSet
560 
561     struct UintSet {
562         Set _inner;
563     }
564 
565     /**
566      * @dev Add a value to a set. O(1).
567      *
568      * Returns true if the value was added to the set, that is if it was not
569      * already present.
570      */
571     function add(UintSet storage set, uint256 value) internal returns (bool) {
572         return _add(set._inner, bytes32(value));
573     }
574 
575     /**
576      * @dev Removes a value from a set. O(1).
577      *
578      * Returns true if the value was removed from the set, that is if it was
579      * present.
580      */
581     function remove(UintSet storage set, uint256 value) internal returns (bool) {
582         return _remove(set._inner, bytes32(value));
583     }
584 
585     /**
586      * @dev Returns true if the value is in the set. O(1).
587      */
588     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
589         return _contains(set._inner, bytes32(value));
590     }
591 
592     /**
593      * @dev Returns the number of values on the set. O(1).
594      */
595     function length(UintSet storage set) internal view returns (uint256) {
596         return _length(set._inner);
597     }
598 
599    /**
600     * @dev Returns the value stored at position `index` in the set. O(1).
601     *
602     * Note that there are no guarantees on the ordering of values inside the
603     * array, and it may change when more values are added or removed.
604     *
605     * Requirements:
606     *
607     * - `index` must be strictly less than {length}.
608     */
609     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
610         return uint256(_at(set._inner, index));
611     }
612 }
613 
614 // File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol
615 
616 pragma solidity >=0.4.24 <0.7.0;
617 
618 
619 /**
620  * @title Initializable
621  *
622  * @dev Helper contract to support initializer functions. To use it, replace
623  * the constructor with a function that has the `initializer` modifier.
624  * WARNING: Unlike constructors, initializer functions must be manually
625  * invoked. This applies both to deploying an Initializable contract, as well
626  * as extending an Initializable contract via inheritance.
627  * WARNING: When used with inheritance, manual care must be taken to not invoke
628  * a parent initializer twice, or ensure that all initializers are idempotent,
629  * because this is not dealt with automatically as with constructors.
630  */
631 contract Initializable {
632 
633   /**
634    * @dev Indicates that the contract has been initialized.
635    */
636   bool private initialized;
637 
638   /**
639    * @dev Indicates that the contract is in the process of being initialized.
640    */
641   bool private initializing;
642 
643   /**
644    * @dev Modifier to use in the initializer function of a contract.
645    */
646   modifier initializer() {
647     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
648 
649     bool isTopLevelCall = !initializing;
650     if (isTopLevelCall) {
651       initializing = true;
652       initialized = true;
653     }
654 
655     _;
656 
657     if (isTopLevelCall) {
658       initializing = false;
659     }
660   }
661 
662   /// @dev Returns true if and only if the function is running in the constructor
663   function isConstructor() private view returns (bool) {
664     // extcodesize checks the size of the code stored in an address, and
665     // address returns the current address. Since the code is still not
666     // deployed when running a constructor, any checks on its code size will
667     // yield zero, making it an effective way to detect if a contract is
668     // under construction or not.
669     address self = address(this);
670     uint256 cs;
671     assembly { cs := extcodesize(self) }
672     return cs == 0;
673   }
674 
675   // Reserved storage space to allow for layout changes in the future.
676   uint256[50] private ______gap;
677 }
678 
679 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol
680 
681 pragma solidity ^0.6.0;
682 
683 
684 /*
685  * @dev Provides information about the current execution context, including the
686  * sender of the transaction and its data. While these are generally available
687  * via msg.sender and msg.data, they should not be accessed in such a direct
688  * manner, since when dealing with GSN meta-transactions the account sending and
689  * paying for execution may not be the actual sender (as far as an application
690  * is concerned).
691  *
692  * This contract is only required for intermediate, library-like contracts.
693  */
694 contract ContextUpgradeSafe is Initializable {
695     // Empty internal constructor, to prevent people from mistakenly deploying
696     // an instance of this contract, which should be used via inheritance.
697 
698     function __Context_init() internal initializer {
699         __Context_init_unchained();
700     }
701 
702     function __Context_init_unchained() internal initializer {
703 
704 
705     }
706 
707 
708     function _msgSender() internal view virtual returns (address payable) {
709         return msg.sender;
710     }
711 
712     function _msgData() internal view virtual returns (bytes memory) {
713         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
714         return msg.data;
715     }
716 
717     uint256[50] private __gap;
718 }
719 
720 // File: @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol
721 
722 pragma solidity ^0.6.0;
723 
724 
725 /**
726  * @dev Contract module which provides a basic access control mechanism, where
727  * there is an account (an owner) that can be granted exclusive access to
728  * specific functions.
729  *
730  * By default, the owner account will be the one that deploys the contract. This
731  * can later be changed with {transferOwnership}.
732  *
733  * This module is used through inheritance. It will make available the modifier
734  * `onlyOwner`, which can be applied to your functions to restrict their use to
735  * the owner.
736  */
737 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
738     address private _owner;
739 
740     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
741 
742     /**
743      * @dev Initializes the contract setting the deployer as the initial owner.
744      */
745 
746     function __Ownable_init() internal initializer {
747         __Context_init_unchained();
748         __Ownable_init_unchained();
749     }
750 
751     function __Ownable_init_unchained() internal initializer {
752 
753 
754         address msgSender = _msgSender();
755         _owner = msgSender;
756         emit OwnershipTransferred(address(0), msgSender);
757 
758     }
759 
760 
761     /**
762      * @dev Returns the address of the current owner.
763      */
764     function owner() public view returns (address) {
765         return _owner;
766     }
767 
768     /**
769      * @dev Throws if called by any account other than the owner.
770      */
771     modifier onlyOwner() {
772         require(_owner == _msgSender(), "Ownable: caller is not the owner");
773         _;
774     }
775 
776     /**
777      * @dev Leaves the contract without owner. It will not be possible to call
778      * `onlyOwner` functions anymore. Can only be called by the current owner.
779      *
780      * NOTE: Renouncing ownership will leave the contract without an owner,
781      * thereby removing any functionality that is only available to the owner.
782      */
783     function renounceOwnership() public virtual onlyOwner {
784         emit OwnershipTransferred(_owner, address(0));
785         _owner = address(0);
786     }
787 
788     /**
789      * @dev Transfers ownership of the contract to a new account (`newOwner`).
790      * Can only be called by the current owner.
791      */
792     function transferOwnership(address newOwner) public virtual onlyOwner {
793         require(newOwner != address(0), "Ownable: new owner is the zero address");
794         emit OwnershipTransferred(_owner, newOwner);
795         _owner = newOwner;
796     }
797 
798     uint256[49] private __gap;
799 }
800 
801 // File: contracts/INerdBaseToken.sol
802 
803 
804 pragma solidity 0.6.12;
805 
806 /**
807  * @dev Interface of the ERC20 standard as defined in the EIP.
808  */
809 interface INerdBaseToken {
810     /**
811      * @dev Returns the amount of tokens in existence.
812      */
813     function totalSupply() external view returns (uint256);
814 
815     /**
816      * @dev Returns the amount of tokens owned by `account`.
817      */
818     function balanceOf(address account) external view returns (uint256);
819 
820     /**
821      * @dev Moves `amount` tokens from the caller's account to `recipient`.
822      *
823      * Returns a boolean value indicating whether the operation succeeded.
824      *
825      * Emits a {Transfer} event.
826      */
827     function transfer(address recipient, uint256 amount)
828         external
829         returns (bool);
830 
831     /**
832      * @dev Returns the remaining number of tokens that `spender` will be
833      * allowed to spend on behalf of `owner` through {transferFrom}. This is
834      * zero by default.
835      *
836      * This value changes when {approve} or {transferFrom} are called.
837      */
838     function allowance(address owner, address spender)
839         external
840         view
841         returns (uint256);
842 
843     /**
844      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
845      *
846      * Returns a boolean value indicating whether the operation succeeded.
847      *
848      * IMPORTANT: Beware that changing an allowance with this method brings the risk
849      * that someone may use both the old and the new allowance by unfortunate
850      * transaction ordering. One possible solution to mitigate this race
851      * condition is to first reduce the spender's allowance to 0 and set the
852      * desired value afterwards:
853      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
854      *
855      * Emits an {Approval} event.
856      */
857     function approve(address spender, uint256 amount) external returns (bool);
858 
859     /**
860      * @dev Moves `amount` tokens from `sender` to `recipient` using the
861      * allowance mechanism. `amount` is then deducted from the caller's
862      * allowance.
863      *
864      * Returns a boolean value indicating whether the operation succeeded.
865      *
866      * Emits a {Transfer} event.
867      */
868     function transferFrom(
869         address sender,
870         address recipient,
871         uint256 amount
872     ) external returns (bool);
873 
874     /**
875      * @dev Emitted when `value` tokens are moved from one account (`from`) to
876      * another (`to`).
877      *
878      * Note that `value` may be zero.
879      */
880     event Transfer(address indexed from, address indexed to, uint256 value);
881 
882     /**
883      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
884      * a call to {approve}. `value` is the new allowance.
885      */
886     event Approval(
887         address indexed owner,
888         address indexed spender,
889         uint256 value
890     );
891 
892     event Log(string log);
893 }
894 
895 interface INerdBaseTokenLGE is INerdBaseToken {
896     function getAllocatedLP(address _user) external view returns (uint256);
897 
898     function getLpReleaseStart() external view returns (uint256);
899 
900     function getTokenUniswapPair() external view returns (address);
901 
902     function getTotalLPTokensMinted() external view returns (uint256);
903 
904     function getReleasableLPTokensMinted() external view returns (uint256);
905 
906     function isLPGenerationCompleted() external view returns (bool);
907 
908     function tokenUniswapPair() external view returns (address);
909 
910     function getUniswapRouterV2() external view returns (address);
911 
912     function getUniswapFactory() external view returns (address);
913 
914     function devFundAddress() external view returns (address);
915 
916     function transferCheckerAddress() external view returns (address);
917 
918     function feeDistributor() external view returns (address);
919 }
920 
921 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
922 
923 pragma solidity 0.6.12;
924 
925 interface IUniswapV2Factory {
926     event PairCreated(
927         address indexed token0,
928         address indexed token1,
929         address pair,
930         uint256
931     );
932 
933     function feeTo() external view returns (address);
934 
935     function feeToSetter() external view returns (address);
936 
937     function migrator() external view returns (address);
938 
939     function getPair(address tokenA, address tokenB)
940         external
941         view
942         returns (address pair);
943 
944     function allPairs(uint256) external view returns (address pair);
945 
946     function allPairsLength() external view returns (uint256);
947 
948     function createPair(address tokenA, address tokenB)
949         external
950         returns (address pair);
951 
952     function setFeeTo(address) external;
953 
954     function setFeeToSetter(address) external;
955 
956     function setMigrator(address) external;
957 }
958 
959 // File: contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
960 
961 pragma solidity 0.6.12;
962 
963 interface IUniswapV2Router01 {
964     function factory() external pure returns (address);
965 
966     function WETH() external pure returns (address);
967 
968     function addLiquidity(
969         address tokenA,
970         address tokenB,
971         uint256 amountADesired,
972         uint256 amountBDesired,
973         uint256 amountAMin,
974         uint256 amountBMin,
975         address to,
976         uint256 deadline
977     )
978         external
979         returns (
980             uint256 amountA,
981             uint256 amountB,
982             uint256 liquidity
983         );
984 
985     function addLiquidityETH(
986         address token,
987         uint256 amountTokenDesired,
988         uint256 amountTokenMin,
989         uint256 amountETHMin,
990         address to,
991         uint256 deadline
992     )
993         external
994         payable
995         returns (
996             uint256 amountToken,
997             uint256 amountETH,
998             uint256 liquidity
999         );
1000 
1001     function removeLiquidity(
1002         address tokenA,
1003         address tokenB,
1004         uint256 liquidity,
1005         uint256 amountAMin,
1006         uint256 amountBMin,
1007         address to,
1008         uint256 deadline
1009     ) external returns (uint256 amountA, uint256 amountB);
1010 
1011     function removeLiquidityETH(
1012         address token,
1013         uint256 liquidity,
1014         uint256 amountTokenMin,
1015         uint256 amountETHMin,
1016         address to,
1017         uint256 deadline
1018     ) external returns (uint256 amountToken, uint256 amountETH);
1019 
1020     function removeLiquidityWithPermit(
1021         address tokenA,
1022         address tokenB,
1023         uint256 liquidity,
1024         uint256 amountAMin,
1025         uint256 amountBMin,
1026         address to,
1027         uint256 deadline,
1028         bool approveMax,
1029         uint8 v,
1030         bytes32 r,
1031         bytes32 s
1032     ) external returns (uint256 amountA, uint256 amountB);
1033 
1034     function removeLiquidityETHWithPermit(
1035         address token,
1036         uint256 liquidity,
1037         uint256 amountTokenMin,
1038         uint256 amountETHMin,
1039         address to,
1040         uint256 deadline,
1041         bool approveMax,
1042         uint8 v,
1043         bytes32 r,
1044         bytes32 s
1045     ) external returns (uint256 amountToken, uint256 amountETH);
1046 
1047     function swapExactTokensForTokens(
1048         uint256 amountIn,
1049         uint256 amountOutMin,
1050         address[] calldata path,
1051         address to,
1052         uint256 deadline
1053     ) external returns (uint256[] memory amounts);
1054 
1055     function swapTokensForExactTokens(
1056         uint256 amountOut,
1057         uint256 amountInMax,
1058         address[] calldata path,
1059         address to,
1060         uint256 deadline
1061     ) external returns (uint256[] memory amounts);
1062 
1063     function swapExactETHForTokens(
1064         uint256 amountOutMin,
1065         address[] calldata path,
1066         address to,
1067         uint256 deadline
1068     ) external payable returns (uint256[] memory amounts);
1069 
1070     function swapTokensForExactETH(
1071         uint256 amountOut,
1072         uint256 amountInMax,
1073         address[] calldata path,
1074         address to,
1075         uint256 deadline
1076     ) external returns (uint256[] memory amounts);
1077 
1078     function swapExactTokensForETH(
1079         uint256 amountIn,
1080         uint256 amountOutMin,
1081         address[] calldata path,
1082         address to,
1083         uint256 deadline
1084     ) external returns (uint256[] memory amounts);
1085 
1086     function swapETHForExactTokens(
1087         uint256 amountOut,
1088         address[] calldata path,
1089         address to,
1090         uint256 deadline
1091     ) external payable returns (uint256[] memory amounts);
1092 
1093     function quote(
1094         uint256 amountA,
1095         uint256 reserveA,
1096         uint256 reserveB
1097     ) external pure returns (uint256 amountB);
1098 
1099     function getAmountOut(
1100         uint256 amountIn,
1101         uint256 reserveIn,
1102         uint256 reserveOut
1103     ) external pure returns (uint256 amountOut);
1104 
1105     function getAmountIn(
1106         uint256 amountOut,
1107         uint256 reserveIn,
1108         uint256 reserveOut
1109     ) external pure returns (uint256 amountIn);
1110 
1111     function getAmountsOut(uint256 amountIn, address[] calldata path)
1112         external
1113         view
1114         returns (uint256[] memory amounts);
1115 
1116     function getAmountsIn(uint256 amountOut, address[] calldata path)
1117         external
1118         view
1119         returns (uint256[] memory amounts);
1120 }
1121 
1122 // File: contracts/uniswapv2/interfaces/IUniswapV2Router02.sol
1123 
1124 pragma solidity 0.6.12;
1125 
1126 
1127 interface IUniswapV2Router02 is IUniswapV2Router01 {
1128     function removeLiquidityETHSupportingFeeOnTransferTokens(
1129         address token,
1130         uint256 liquidity,
1131         uint256 amountTokenMin,
1132         uint256 amountETHMin,
1133         address to,
1134         uint256 deadline
1135     ) external returns (uint256 amountETH);
1136 
1137     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1138         address token,
1139         uint256 liquidity,
1140         uint256 amountTokenMin,
1141         uint256 amountETHMin,
1142         address to,
1143         uint256 deadline,
1144         bool approveMax,
1145         uint8 v,
1146         bytes32 r,
1147         bytes32 s
1148     ) external returns (uint256 amountETH);
1149 
1150     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1151         uint256 amountIn,
1152         uint256 amountOutMin,
1153         address[] calldata path,
1154         address to,
1155         uint256 deadline
1156     ) external;
1157 
1158     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1159         uint256 amountOutMin,
1160         address[] calldata path,
1161         address to,
1162         uint256 deadline
1163     ) external payable;
1164 
1165     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1166         uint256 amountIn,
1167         uint256 amountOutMin,
1168         address[] calldata path,
1169         address to,
1170         uint256 deadline
1171     ) external;
1172 }
1173 
1174 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
1175 
1176 pragma solidity 0.6.12;
1177 
1178 interface IUniswapV2Pair {
1179     event Approval(
1180         address indexed owner,
1181         address indexed spender,
1182         uint256 value
1183     );
1184     event Transfer(address indexed from, address indexed to, uint256 value);
1185 
1186     function name() external pure returns (string memory);
1187 
1188     function symbol() external pure returns (string memory);
1189 
1190     function decimals() external pure returns (uint8);
1191 
1192     function totalSupply() external view returns (uint256);
1193 
1194     function balanceOf(address owner) external view returns (uint256);
1195 
1196     function allowance(address owner, address spender)
1197         external
1198         view
1199         returns (uint256);
1200 
1201     function approve(address spender, uint256 value) external returns (bool);
1202 
1203     function transfer(address to, uint256 value) external returns (bool);
1204 
1205     function transferFrom(
1206         address from,
1207         address to,
1208         uint256 value
1209     ) external returns (bool);
1210 
1211     function DOMAIN_SEPARATOR() external view returns (bytes32);
1212 
1213     function PERMIT_TYPEHASH() external pure returns (bytes32);
1214 
1215     function nonces(address owner) external view returns (uint256);
1216 
1217     function permit(
1218         address owner,
1219         address spender,
1220         uint256 value,
1221         uint256 deadline,
1222         uint8 v,
1223         bytes32 r,
1224         bytes32 s
1225     ) external;
1226 
1227     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1228     event Burn(
1229         address indexed sender,
1230         uint256 amount0,
1231         uint256 amount1,
1232         address indexed to
1233     );
1234     event Swap(
1235         address indexed sender,
1236         uint256 amount0In,
1237         uint256 amount1In,
1238         uint256 amount0Out,
1239         uint256 amount1Out,
1240         address indexed to
1241     );
1242     event Sync(uint112 reserve0, uint112 reserve1);
1243 
1244     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1245 
1246     function factory() external view returns (address);
1247 
1248     function token0() external view returns (address);
1249 
1250     function token1() external view returns (address);
1251 
1252     function getReserves()
1253         external
1254         view
1255         returns (
1256             uint112 reserve0,
1257             uint112 reserve1,
1258             uint32 blockTimestampLast
1259         );
1260 
1261     function price0CumulativeLast() external view returns (uint256);
1262 
1263     function price1CumulativeLast() external view returns (uint256);
1264 
1265     function kLast() external view returns (uint256);
1266 
1267     function mint(address to) external returns (uint256 liquidity);
1268 
1269     function burn(address to)
1270         external
1271         returns (uint256 amount0, uint256 amount1);
1272 
1273     function swap(
1274         uint256 amount0Out,
1275         uint256 amount1Out,
1276         address to,
1277         bytes calldata data
1278     ) external;
1279 
1280     function skim(address to) external;
1281 
1282     function sync() external;
1283 
1284     function initialize(address, address) external;
1285 }
1286 
1287 // File: contracts/uniswapv2/interfaces/IWETH.sol
1288 
1289 pragma solidity 0.6.12;
1290 
1291 interface IWETH {
1292     function deposit() external payable;
1293 
1294     function transfer(address to, uint256 value) external returns (bool);
1295 
1296     function withdraw(uint256) external;
1297 
1298     function approve(address guy, uint256 wad) external returns (bool);
1299 
1300     function balanceOf(address addr) external view returns (uint256);
1301 }
1302 
1303 // File: @nomiclabs/buidler/console.sol
1304 
1305 pragma solidity >= 0.4.22 <0.8.0;
1306 
1307 library console {
1308 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1309 
1310 	function _sendLogPayload(bytes memory payload) private view {
1311 		uint256 payloadLength = payload.length;
1312 		address consoleAddress = CONSOLE_ADDRESS;
1313 		assembly {
1314 			let payloadStart := add(payload, 32)
1315 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1316 		}
1317 	}
1318 
1319 	function log() internal view {
1320 		_sendLogPayload(abi.encodeWithSignature("log()"));
1321 	}
1322 
1323 	function logInt(int p0) internal view {
1324 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1325 	}
1326 
1327 	function logUint(uint p0) internal view {
1328 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1329 	}
1330 
1331 	function logString(string memory p0) internal view {
1332 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1333 	}
1334 
1335 	function logBool(bool p0) internal view {
1336 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1337 	}
1338 
1339 	function logAddress(address p0) internal view {
1340 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1341 	}
1342 
1343 	function logBytes(bytes memory p0) internal view {
1344 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1345 	}
1346 
1347 	function logByte(byte p0) internal view {
1348 		_sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
1349 	}
1350 
1351 	function logBytes1(bytes1 p0) internal view {
1352 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1353 	}
1354 
1355 	function logBytes2(bytes2 p0) internal view {
1356 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1357 	}
1358 
1359 	function logBytes3(bytes3 p0) internal view {
1360 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1361 	}
1362 
1363 	function logBytes4(bytes4 p0) internal view {
1364 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1365 	}
1366 
1367 	function logBytes5(bytes5 p0) internal view {
1368 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1369 	}
1370 
1371 	function logBytes6(bytes6 p0) internal view {
1372 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1373 	}
1374 
1375 	function logBytes7(bytes7 p0) internal view {
1376 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1377 	}
1378 
1379 	function logBytes8(bytes8 p0) internal view {
1380 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1381 	}
1382 
1383 	function logBytes9(bytes9 p0) internal view {
1384 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1385 	}
1386 
1387 	function logBytes10(bytes10 p0) internal view {
1388 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1389 	}
1390 
1391 	function logBytes11(bytes11 p0) internal view {
1392 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1393 	}
1394 
1395 	function logBytes12(bytes12 p0) internal view {
1396 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1397 	}
1398 
1399 	function logBytes13(bytes13 p0) internal view {
1400 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1401 	}
1402 
1403 	function logBytes14(bytes14 p0) internal view {
1404 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1405 	}
1406 
1407 	function logBytes15(bytes15 p0) internal view {
1408 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1409 	}
1410 
1411 	function logBytes16(bytes16 p0) internal view {
1412 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1413 	}
1414 
1415 	function logBytes17(bytes17 p0) internal view {
1416 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1417 	}
1418 
1419 	function logBytes18(bytes18 p0) internal view {
1420 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1421 	}
1422 
1423 	function logBytes19(bytes19 p0) internal view {
1424 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1425 	}
1426 
1427 	function logBytes20(bytes20 p0) internal view {
1428 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1429 	}
1430 
1431 	function logBytes21(bytes21 p0) internal view {
1432 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1433 	}
1434 
1435 	function logBytes22(bytes22 p0) internal view {
1436 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1437 	}
1438 
1439 	function logBytes23(bytes23 p0) internal view {
1440 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1441 	}
1442 
1443 	function logBytes24(bytes24 p0) internal view {
1444 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1445 	}
1446 
1447 	function logBytes25(bytes25 p0) internal view {
1448 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1449 	}
1450 
1451 	function logBytes26(bytes26 p0) internal view {
1452 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1453 	}
1454 
1455 	function logBytes27(bytes27 p0) internal view {
1456 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1457 	}
1458 
1459 	function logBytes28(bytes28 p0) internal view {
1460 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1461 	}
1462 
1463 	function logBytes29(bytes29 p0) internal view {
1464 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1465 	}
1466 
1467 	function logBytes30(bytes30 p0) internal view {
1468 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1469 	}
1470 
1471 	function logBytes31(bytes31 p0) internal view {
1472 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1473 	}
1474 
1475 	function logBytes32(bytes32 p0) internal view {
1476 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1477 	}
1478 
1479 	function log(uint p0) internal view {
1480 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1481 	}
1482 
1483 	function log(string memory p0) internal view {
1484 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1485 	}
1486 
1487 	function log(bool p0) internal view {
1488 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1489 	}
1490 
1491 	function log(address p0) internal view {
1492 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1493 	}
1494 
1495 	function log(uint p0, uint p1) internal view {
1496 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1497 	}
1498 
1499 	function log(uint p0, string memory p1) internal view {
1500 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1501 	}
1502 
1503 	function log(uint p0, bool p1) internal view {
1504 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1505 	}
1506 
1507 	function log(uint p0, address p1) internal view {
1508 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1509 	}
1510 
1511 	function log(string memory p0, uint p1) internal view {
1512 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1513 	}
1514 
1515 	function log(string memory p0, string memory p1) internal view {
1516 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1517 	}
1518 
1519 	function log(string memory p0, bool p1) internal view {
1520 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1521 	}
1522 
1523 	function log(string memory p0, address p1) internal view {
1524 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1525 	}
1526 
1527 	function log(bool p0, uint p1) internal view {
1528 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1529 	}
1530 
1531 	function log(bool p0, string memory p1) internal view {
1532 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1533 	}
1534 
1535 	function log(bool p0, bool p1) internal view {
1536 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1537 	}
1538 
1539 	function log(bool p0, address p1) internal view {
1540 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1541 	}
1542 
1543 	function log(address p0, uint p1) internal view {
1544 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1545 	}
1546 
1547 	function log(address p0, string memory p1) internal view {
1548 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1549 	}
1550 
1551 	function log(address p0, bool p1) internal view {
1552 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1553 	}
1554 
1555 	function log(address p0, address p1) internal view {
1556 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1557 	}
1558 
1559 	function log(uint p0, uint p1, uint p2) internal view {
1560 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1561 	}
1562 
1563 	function log(uint p0, uint p1, string memory p2) internal view {
1564 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1565 	}
1566 
1567 	function log(uint p0, uint p1, bool p2) internal view {
1568 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1569 	}
1570 
1571 	function log(uint p0, uint p1, address p2) internal view {
1572 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1573 	}
1574 
1575 	function log(uint p0, string memory p1, uint p2) internal view {
1576 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1577 	}
1578 
1579 	function log(uint p0, string memory p1, string memory p2) internal view {
1580 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1581 	}
1582 
1583 	function log(uint p0, string memory p1, bool p2) internal view {
1584 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1585 	}
1586 
1587 	function log(uint p0, string memory p1, address p2) internal view {
1588 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1589 	}
1590 
1591 	function log(uint p0, bool p1, uint p2) internal view {
1592 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1593 	}
1594 
1595 	function log(uint p0, bool p1, string memory p2) internal view {
1596 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1597 	}
1598 
1599 	function log(uint p0, bool p1, bool p2) internal view {
1600 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1601 	}
1602 
1603 	function log(uint p0, bool p1, address p2) internal view {
1604 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1605 	}
1606 
1607 	function log(uint p0, address p1, uint p2) internal view {
1608 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1609 	}
1610 
1611 	function log(uint p0, address p1, string memory p2) internal view {
1612 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1613 	}
1614 
1615 	function log(uint p0, address p1, bool p2) internal view {
1616 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1617 	}
1618 
1619 	function log(uint p0, address p1, address p2) internal view {
1620 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1621 	}
1622 
1623 	function log(string memory p0, uint p1, uint p2) internal view {
1624 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1625 	}
1626 
1627 	function log(string memory p0, uint p1, string memory p2) internal view {
1628 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1629 	}
1630 
1631 	function log(string memory p0, uint p1, bool p2) internal view {
1632 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1633 	}
1634 
1635 	function log(string memory p0, uint p1, address p2) internal view {
1636 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1637 	}
1638 
1639 	function log(string memory p0, string memory p1, uint p2) internal view {
1640 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1641 	}
1642 
1643 	function log(string memory p0, string memory p1, string memory p2) internal view {
1644 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1645 	}
1646 
1647 	function log(string memory p0, string memory p1, bool p2) internal view {
1648 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1649 	}
1650 
1651 	function log(string memory p0, string memory p1, address p2) internal view {
1652 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1653 	}
1654 
1655 	function log(string memory p0, bool p1, uint p2) internal view {
1656 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1657 	}
1658 
1659 	function log(string memory p0, bool p1, string memory p2) internal view {
1660 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1661 	}
1662 
1663 	function log(string memory p0, bool p1, bool p2) internal view {
1664 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1665 	}
1666 
1667 	function log(string memory p0, bool p1, address p2) internal view {
1668 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1669 	}
1670 
1671 	function log(string memory p0, address p1, uint p2) internal view {
1672 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1673 	}
1674 
1675 	function log(string memory p0, address p1, string memory p2) internal view {
1676 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1677 	}
1678 
1679 	function log(string memory p0, address p1, bool p2) internal view {
1680 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1681 	}
1682 
1683 	function log(string memory p0, address p1, address p2) internal view {
1684 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1685 	}
1686 
1687 	function log(bool p0, uint p1, uint p2) internal view {
1688 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1689 	}
1690 
1691 	function log(bool p0, uint p1, string memory p2) internal view {
1692 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1693 	}
1694 
1695 	function log(bool p0, uint p1, bool p2) internal view {
1696 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1697 	}
1698 
1699 	function log(bool p0, uint p1, address p2) internal view {
1700 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1701 	}
1702 
1703 	function log(bool p0, string memory p1, uint p2) internal view {
1704 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1705 	}
1706 
1707 	function log(bool p0, string memory p1, string memory p2) internal view {
1708 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1709 	}
1710 
1711 	function log(bool p0, string memory p1, bool p2) internal view {
1712 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1713 	}
1714 
1715 	function log(bool p0, string memory p1, address p2) internal view {
1716 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1717 	}
1718 
1719 	function log(bool p0, bool p1, uint p2) internal view {
1720 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1721 	}
1722 
1723 	function log(bool p0, bool p1, string memory p2) internal view {
1724 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1725 	}
1726 
1727 	function log(bool p0, bool p1, bool p2) internal view {
1728 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1729 	}
1730 
1731 	function log(bool p0, bool p1, address p2) internal view {
1732 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1733 	}
1734 
1735 	function log(bool p0, address p1, uint p2) internal view {
1736 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1737 	}
1738 
1739 	function log(bool p0, address p1, string memory p2) internal view {
1740 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1741 	}
1742 
1743 	function log(bool p0, address p1, bool p2) internal view {
1744 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1745 	}
1746 
1747 	function log(bool p0, address p1, address p2) internal view {
1748 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1749 	}
1750 
1751 	function log(address p0, uint p1, uint p2) internal view {
1752 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1753 	}
1754 
1755 	function log(address p0, uint p1, string memory p2) internal view {
1756 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1757 	}
1758 
1759 	function log(address p0, uint p1, bool p2) internal view {
1760 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1761 	}
1762 
1763 	function log(address p0, uint p1, address p2) internal view {
1764 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1765 	}
1766 
1767 	function log(address p0, string memory p1, uint p2) internal view {
1768 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1769 	}
1770 
1771 	function log(address p0, string memory p1, string memory p2) internal view {
1772 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1773 	}
1774 
1775 	function log(address p0, string memory p1, bool p2) internal view {
1776 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1777 	}
1778 
1779 	function log(address p0, string memory p1, address p2) internal view {
1780 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1781 	}
1782 
1783 	function log(address p0, bool p1, uint p2) internal view {
1784 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1785 	}
1786 
1787 	function log(address p0, bool p1, string memory p2) internal view {
1788 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1789 	}
1790 
1791 	function log(address p0, bool p1, bool p2) internal view {
1792 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1793 	}
1794 
1795 	function log(address p0, bool p1, address p2) internal view {
1796 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1797 	}
1798 
1799 	function log(address p0, address p1, uint p2) internal view {
1800 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1801 	}
1802 
1803 	function log(address p0, address p1, string memory p2) internal view {
1804 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1805 	}
1806 
1807 	function log(address p0, address p1, bool p2) internal view {
1808 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1809 	}
1810 
1811 	function log(address p0, address p1, address p2) internal view {
1812 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1813 	}
1814 
1815 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1816 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1817 	}
1818 
1819 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1820 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1821 	}
1822 
1823 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1824 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1825 	}
1826 
1827 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1828 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1829 	}
1830 
1831 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1832 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1833 	}
1834 
1835 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1836 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1837 	}
1838 
1839 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1840 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1841 	}
1842 
1843 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1844 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1845 	}
1846 
1847 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1848 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1849 	}
1850 
1851 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1852 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1853 	}
1854 
1855 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1856 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1857 	}
1858 
1859 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1860 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1861 	}
1862 
1863 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1864 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1865 	}
1866 
1867 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1868 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1869 	}
1870 
1871 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1872 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1873 	}
1874 
1875 	function log(uint p0, uint p1, address p2, address p3) internal view {
1876 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1877 	}
1878 
1879 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1880 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1881 	}
1882 
1883 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1884 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1885 	}
1886 
1887 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1888 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1889 	}
1890 
1891 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1892 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1893 	}
1894 
1895 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1896 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1897 	}
1898 
1899 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1900 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1901 	}
1902 
1903 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1904 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1905 	}
1906 
1907 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1908 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1909 	}
1910 
1911 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1912 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1913 	}
1914 
1915 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1916 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1917 	}
1918 
1919 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1920 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1921 	}
1922 
1923 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1924 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1925 	}
1926 
1927 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1928 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1929 	}
1930 
1931 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1932 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1933 	}
1934 
1935 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1936 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1937 	}
1938 
1939 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1940 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1941 	}
1942 
1943 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1944 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1945 	}
1946 
1947 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1948 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1949 	}
1950 
1951 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1952 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1953 	}
1954 
1955 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1956 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1957 	}
1958 
1959 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1960 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1961 	}
1962 
1963 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1964 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1965 	}
1966 
1967 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1968 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1969 	}
1970 
1971 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1972 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1973 	}
1974 
1975 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1976 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1977 	}
1978 
1979 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1980 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1981 	}
1982 
1983 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1984 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1985 	}
1986 
1987 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1988 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1989 	}
1990 
1991 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1992 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1993 	}
1994 
1995 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1996 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1997 	}
1998 
1999 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2000 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2001 	}
2002 
2003 	function log(uint p0, bool p1, address p2, address p3) internal view {
2004 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2005 	}
2006 
2007 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2008 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2009 	}
2010 
2011 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2012 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2013 	}
2014 
2015 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2016 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2017 	}
2018 
2019 	function log(uint p0, address p1, uint p2, address p3) internal view {
2020 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2021 	}
2022 
2023 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2024 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2025 	}
2026 
2027 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2028 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2029 	}
2030 
2031 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2032 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2033 	}
2034 
2035 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2036 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2037 	}
2038 
2039 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2040 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2041 	}
2042 
2043 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2044 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2045 	}
2046 
2047 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2048 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2049 	}
2050 
2051 	function log(uint p0, address p1, bool p2, address p3) internal view {
2052 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2053 	}
2054 
2055 	function log(uint p0, address p1, address p2, uint p3) internal view {
2056 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2057 	}
2058 
2059 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2060 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2061 	}
2062 
2063 	function log(uint p0, address p1, address p2, bool p3) internal view {
2064 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2065 	}
2066 
2067 	function log(uint p0, address p1, address p2, address p3) internal view {
2068 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2069 	}
2070 
2071 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2072 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2073 	}
2074 
2075 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2076 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2077 	}
2078 
2079 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2080 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2081 	}
2082 
2083 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2084 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2085 	}
2086 
2087 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2088 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2089 	}
2090 
2091 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2092 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2093 	}
2094 
2095 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2096 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2097 	}
2098 
2099 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2100 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2101 	}
2102 
2103 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2104 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2105 	}
2106 
2107 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2108 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2109 	}
2110 
2111 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2112 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2113 	}
2114 
2115 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2116 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2117 	}
2118 
2119 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2120 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2121 	}
2122 
2123 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2124 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2125 	}
2126 
2127 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2128 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2129 	}
2130 
2131 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2132 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2133 	}
2134 
2135 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2136 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2137 	}
2138 
2139 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2140 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2141 	}
2142 
2143 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2144 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2145 	}
2146 
2147 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2148 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2149 	}
2150 
2151 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2152 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2153 	}
2154 
2155 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2156 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2157 	}
2158 
2159 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2160 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2161 	}
2162 
2163 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2164 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2165 	}
2166 
2167 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2168 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2169 	}
2170 
2171 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2172 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2173 	}
2174 
2175 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2176 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2177 	}
2178 
2179 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2180 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2181 	}
2182 
2183 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2184 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2185 	}
2186 
2187 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2188 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2189 	}
2190 
2191 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2192 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2193 	}
2194 
2195 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2196 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2197 	}
2198 
2199 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2200 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2201 	}
2202 
2203 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2204 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2205 	}
2206 
2207 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2208 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2209 	}
2210 
2211 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2212 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2213 	}
2214 
2215 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2216 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2217 	}
2218 
2219 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2220 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2221 	}
2222 
2223 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2224 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2225 	}
2226 
2227 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2228 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2229 	}
2230 
2231 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2232 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2233 	}
2234 
2235 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2236 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2237 	}
2238 
2239 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2240 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2241 	}
2242 
2243 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2244 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2245 	}
2246 
2247 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2248 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2249 	}
2250 
2251 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2252 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2253 	}
2254 
2255 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2256 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2257 	}
2258 
2259 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2260 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2261 	}
2262 
2263 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2264 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2265 	}
2266 
2267 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2268 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2269 	}
2270 
2271 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2272 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2273 	}
2274 
2275 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2276 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2277 	}
2278 
2279 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2280 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2281 	}
2282 
2283 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2284 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2285 	}
2286 
2287 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2288 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2289 	}
2290 
2291 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2292 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2293 	}
2294 
2295 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2296 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2297 	}
2298 
2299 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2300 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2301 	}
2302 
2303 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2304 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2305 	}
2306 
2307 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2308 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2309 	}
2310 
2311 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2312 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2313 	}
2314 
2315 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2316 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2317 	}
2318 
2319 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2320 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2321 	}
2322 
2323 	function log(string memory p0, address p1, address p2, address p3) internal view {
2324 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2325 	}
2326 
2327 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2328 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2329 	}
2330 
2331 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2332 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2333 	}
2334 
2335 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2336 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2337 	}
2338 
2339 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2340 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2341 	}
2342 
2343 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2344 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2345 	}
2346 
2347 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2348 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2349 	}
2350 
2351 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2352 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2353 	}
2354 
2355 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2356 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2357 	}
2358 
2359 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2360 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2361 	}
2362 
2363 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2364 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2365 	}
2366 
2367 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2368 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2369 	}
2370 
2371 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2372 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2373 	}
2374 
2375 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2376 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2377 	}
2378 
2379 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2380 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2381 	}
2382 
2383 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2384 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2385 	}
2386 
2387 	function log(bool p0, uint p1, address p2, address p3) internal view {
2388 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2389 	}
2390 
2391 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2392 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2393 	}
2394 
2395 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2396 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2397 	}
2398 
2399 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2400 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2401 	}
2402 
2403 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2404 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2405 	}
2406 
2407 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2408 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2409 	}
2410 
2411 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2412 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2413 	}
2414 
2415 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2416 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2417 	}
2418 
2419 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2420 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2421 	}
2422 
2423 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2424 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2425 	}
2426 
2427 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2428 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2429 	}
2430 
2431 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2432 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2433 	}
2434 
2435 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2436 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2437 	}
2438 
2439 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2440 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2441 	}
2442 
2443 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2444 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2445 	}
2446 
2447 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2448 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2449 	}
2450 
2451 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2452 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2453 	}
2454 
2455 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2456 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2457 	}
2458 
2459 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2460 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2461 	}
2462 
2463 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2464 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2465 	}
2466 
2467 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2468 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2469 	}
2470 
2471 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2472 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2473 	}
2474 
2475 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2476 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2477 	}
2478 
2479 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2480 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2481 	}
2482 
2483 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2484 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2485 	}
2486 
2487 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2488 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2489 	}
2490 
2491 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2492 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2493 	}
2494 
2495 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2496 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2497 	}
2498 
2499 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2500 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2501 	}
2502 
2503 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2504 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2505 	}
2506 
2507 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2508 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2509 	}
2510 
2511 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2512 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2513 	}
2514 
2515 	function log(bool p0, bool p1, address p2, address p3) internal view {
2516 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2517 	}
2518 
2519 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2520 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2521 	}
2522 
2523 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2524 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2525 	}
2526 
2527 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2528 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2529 	}
2530 
2531 	function log(bool p0, address p1, uint p2, address p3) internal view {
2532 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2533 	}
2534 
2535 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2536 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2537 	}
2538 
2539 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2540 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2541 	}
2542 
2543 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2544 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2545 	}
2546 
2547 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2548 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2549 	}
2550 
2551 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2552 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2553 	}
2554 
2555 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2556 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2557 	}
2558 
2559 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2560 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2561 	}
2562 
2563 	function log(bool p0, address p1, bool p2, address p3) internal view {
2564 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2565 	}
2566 
2567 	function log(bool p0, address p1, address p2, uint p3) internal view {
2568 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2569 	}
2570 
2571 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2572 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2573 	}
2574 
2575 	function log(bool p0, address p1, address p2, bool p3) internal view {
2576 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2577 	}
2578 
2579 	function log(bool p0, address p1, address p2, address p3) internal view {
2580 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2581 	}
2582 
2583 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2584 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2585 	}
2586 
2587 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2588 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2589 	}
2590 
2591 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2592 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2593 	}
2594 
2595 	function log(address p0, uint p1, uint p2, address p3) internal view {
2596 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2597 	}
2598 
2599 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2600 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2601 	}
2602 
2603 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2604 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2605 	}
2606 
2607 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2608 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2609 	}
2610 
2611 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2612 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2613 	}
2614 
2615 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2616 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2617 	}
2618 
2619 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2620 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2621 	}
2622 
2623 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2624 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2625 	}
2626 
2627 	function log(address p0, uint p1, bool p2, address p3) internal view {
2628 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2629 	}
2630 
2631 	function log(address p0, uint p1, address p2, uint p3) internal view {
2632 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2633 	}
2634 
2635 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2636 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2637 	}
2638 
2639 	function log(address p0, uint p1, address p2, bool p3) internal view {
2640 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2641 	}
2642 
2643 	function log(address p0, uint p1, address p2, address p3) internal view {
2644 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2645 	}
2646 
2647 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2648 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2649 	}
2650 
2651 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2652 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2653 	}
2654 
2655 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2656 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2657 	}
2658 
2659 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2660 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2661 	}
2662 
2663 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2664 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2665 	}
2666 
2667 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2668 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2669 	}
2670 
2671 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2672 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2673 	}
2674 
2675 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2676 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2677 	}
2678 
2679 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2680 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2681 	}
2682 
2683 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2684 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2685 	}
2686 
2687 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2688 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2689 	}
2690 
2691 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2692 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2693 	}
2694 
2695 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2696 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2697 	}
2698 
2699 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2700 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2701 	}
2702 
2703 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2704 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2705 	}
2706 
2707 	function log(address p0, string memory p1, address p2, address p3) internal view {
2708 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2709 	}
2710 
2711 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2712 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2713 	}
2714 
2715 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2716 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2717 	}
2718 
2719 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2720 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2721 	}
2722 
2723 	function log(address p0, bool p1, uint p2, address p3) internal view {
2724 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2725 	}
2726 
2727 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2728 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2729 	}
2730 
2731 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2732 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2733 	}
2734 
2735 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2736 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2737 	}
2738 
2739 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2740 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2741 	}
2742 
2743 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2744 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2745 	}
2746 
2747 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2748 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2749 	}
2750 
2751 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2752 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2753 	}
2754 
2755 	function log(address p0, bool p1, bool p2, address p3) internal view {
2756 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2757 	}
2758 
2759 	function log(address p0, bool p1, address p2, uint p3) internal view {
2760 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2761 	}
2762 
2763 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2764 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2765 	}
2766 
2767 	function log(address p0, bool p1, address p2, bool p3) internal view {
2768 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2769 	}
2770 
2771 	function log(address p0, bool p1, address p2, address p3) internal view {
2772 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2773 	}
2774 
2775 	function log(address p0, address p1, uint p2, uint p3) internal view {
2776 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2777 	}
2778 
2779 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2780 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2781 	}
2782 
2783 	function log(address p0, address p1, uint p2, bool p3) internal view {
2784 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2785 	}
2786 
2787 	function log(address p0, address p1, uint p2, address p3) internal view {
2788 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2789 	}
2790 
2791 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2792 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2793 	}
2794 
2795 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2796 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2797 	}
2798 
2799 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2800 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2801 	}
2802 
2803 	function log(address p0, address p1, string memory p2, address p3) internal view {
2804 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2805 	}
2806 
2807 	function log(address p0, address p1, bool p2, uint p3) internal view {
2808 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2809 	}
2810 
2811 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2812 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2813 	}
2814 
2815 	function log(address p0, address p1, bool p2, bool p3) internal view {
2816 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2817 	}
2818 
2819 	function log(address p0, address p1, bool p2, address p3) internal view {
2820 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2821 	}
2822 
2823 	function log(address p0, address p1, address p2, uint p3) internal view {
2824 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2825 	}
2826 
2827 	function log(address p0, address p1, address p2, string memory p3) internal view {
2828 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2829 	}
2830 
2831 	function log(address p0, address p1, address p2, bool p3) internal view {
2832 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2833 	}
2834 
2835 	function log(address p0, address p1, address p2, address p3) internal view {
2836 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2837 	}
2838 
2839 }
2840 
2841 // File: contracts/NerdVault.sol
2842 
2843 pragma solidity 0.6.12;
2844 
2845 
2846 
2847 
2848 
2849 
2850 
2851 
2852 
2853 
2854 
2855 
2856 // Nerd Vault distributes fees equally amongst staked pools
2857 // Have fun reading it. Hopefully it's bug-free. God bless.
2858 
2859 contract TimeLockLPToken {
2860     using SafeMath for uint256;
2861     using Address for address;
2862 
2863     uint256 public constant LP_LOCKED_PERIOD_WEEKS = 10; //10 weeks,
2864     uint256 public constant LP_RELEASE_TRUNK = 1 weeks; //releasable every week,
2865     uint256 public constant LP_LOCK_FOREVER_PERCENT = 40; //40%
2866     uint256 public constant LP_INITIAL_LOCKED_PERIOD = 28 days;
2867     uint256 public constant LP_ACCUMULATION_FEE = 1; //1/1000
2868     address public constant ADDRESS_LOCKED_LP_ACCUMULATION = address(0);
2869 
2870     // Info of each user.
2871     struct UserInfo {
2872         bool genesisLPClaimed;
2873         uint256 amount; // How many  tokens the user currently has.
2874         uint256 referenceAmount; //this amount is used for computing releasable LP amount
2875         uint256 rewardDebt; // Reward debt. See explanation below.
2876         uint256 rewardLocked;
2877         uint256 releaseTime;
2878         //
2879         // We do some fancy math here. Basically, any point in time, the amount of NERDs
2880         // entitled to a user but is pending to be distributed is:
2881         //
2882         //   pending reward = (user.amount * pool.accNerdPerShare) - user.rewardDebt
2883         //
2884         // Whenever a user deposits or withdraws  tokens to a pool. Here's what happens:
2885         //   1. The pool's `accNerdPerShare` (and `lastRewardBlock`) gets updated.
2886         //   2. User receives the pending reward sent to his/her address.
2887         //   3. User's `amount` gets updated.
2888         //   4. User's `rewardDebt` gets updated.
2889 
2890         uint256 depositTime; //See explanation below.
2891         //this is a dynamic value. It changes every time user deposit to the pool
2892         //1. initial deposit X => deposit time is block time
2893         //2. deposit more at time deposit2 without amount Y =>
2894         //  => compute current releasable amount R
2895         //  => compute diffTime = R*lockedPeriod/(X + Y) => this is the duration users can unlock R with new deposit amount
2896         //  => updated depositTime = (blocktime - diffTime/2)
2897     }
2898 
2899     // Info of each pool.
2900     struct PoolInfo {
2901         IERC20 token; // Address of  token contract.
2902         uint256 allocPoint; // How many allocation points assigned to this pool. NERDs to distribute per block.
2903         uint256 accNerdPerShare; // Accumulated NERDs per share, times 1e18. See below.
2904         uint256 lockedPeriod; // liquidity locked period
2905         mapping(address => mapping(address => uint256)) allowance;
2906         bool emergencyWithdrawable;
2907         uint256 rewardsInThisEpoch;
2908         uint256 cumulativeRewardsSinceStart;
2909         uint256 startBlock;
2910         // For easy graphing historical epoch rewards
2911         mapping(uint256 => uint256) epochRewards;
2912         uint256 epochCalculationStartBlock;
2913     }
2914 
2915     // Info of each pool.
2916     PoolInfo[] public poolInfo;
2917     // Info of each user that stakes  tokens.
2918     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
2919     bool genesisLPClaimed;
2920 
2921     // The NERD TOKEN!
2922     INerdBaseTokenLGE public nerd;
2923 
2924     event LPTokenClaimed(address dst, uint256 value);
2925 
2926     function getAllocatedLP(address _user) public view returns (uint256) {
2927         return nerd.getAllocatedLP(_user);
2928     }
2929 
2930     function getLpReleaseStart(uint256 _pid, address _user)
2931         public
2932         view
2933         returns (uint256)
2934     {
2935         if (_pid == 0 && !userInfo[_pid][_user].genesisLPClaimed) {
2936             return nerd.getLpReleaseStart();
2937         } else {
2938             return
2939                 userInfo[_pid][_user].depositTime.add(LP_INITIAL_LOCKED_PERIOD);
2940         }
2941     }
2942 
2943     function getRemainingLP(uint256 _pid, address _user)
2944         public
2945         view
2946         returns (uint256)
2947     {
2948         if (_pid == 0 && !userInfo[_pid][_user].genesisLPClaimed) {
2949             return getAllocatedLP(_user);
2950         } else {
2951             return userInfo[_pid][_user].amount;
2952         }
2953     }
2954 
2955     function getReferenceAmount(uint256 _pid, address _user)
2956         public
2957         view
2958         returns (uint256)
2959     {
2960         if (_pid == 0 && !userInfo[_pid][_user].genesisLPClaimed) {
2961             return getAllocatedLP(_user);
2962         } else {
2963             return userInfo[_pid][_user].referenceAmount;
2964         }
2965     }
2966 
2967     function computeReleasableLP(uint256 _pid, address _addr)
2968         public
2969         view
2970         returns (uint256)
2971     {
2972         uint256 lpReleaseStart = getLpReleaseStart(_pid, _addr);
2973         if (block.timestamp < lpReleaseStart) {
2974             return 0;
2975         }
2976 
2977         uint256 amountLP = getReferenceAmount(_pid, _addr);
2978         if (amountLP == 0) return 0;
2979 
2980         uint256 totalReleasableTilNow = 0;
2981 
2982         if (block.timestamp > lpReleaseStart.add(poolInfo[_pid].lockedPeriod)) {
2983             totalReleasableTilNow = amountLP;
2984         } else {
2985             uint256 weeksTilNow = weeksSinceLPReleaseTilNow(_pid, _addr);
2986 
2987             totalReleasableTilNow = weeksTilNow
2988                 .mul(LP_RELEASE_TRUNK)
2989                 .mul(amountLP)
2990                 .div(poolInfo[_pid].lockedPeriod);
2991         }
2992         if (totalReleasableTilNow > amountLP) {
2993             totalReleasableTilNow = amountLP;
2994         }
2995         uint256 alreadyReleased = amountLP.sub(getRemainingLP(_pid, _addr));
2996         if (totalReleasableTilNow > alreadyReleased) {
2997             return totalReleasableTilNow.sub(alreadyReleased);
2998         }
2999         return 0;
3000     }
3001 
3002     function computeLockedLP(uint256 _pid, address _addr)
3003         public
3004         view
3005         returns (uint256)
3006     {
3007         return getRemainingLP(_pid, _addr);
3008     }
3009 
3010     function weeksSinceLPReleaseTilNow(uint256 _pid, address _addr)
3011         public
3012         view
3013         returns (uint256)
3014     {
3015         uint256 lpReleaseStart = getLpReleaseStart(_pid, _addr);
3016         if (lpReleaseStart == 0 || block.timestamp < lpReleaseStart) return 0;
3017         uint256 timeTillNow = block.timestamp.sub(lpReleaseStart);
3018         uint256 weeksTilNow = timeTillNow.div(LP_RELEASE_TRUNK);
3019         weeksTilNow = weeksTilNow.add(1);
3020         return weeksTilNow;
3021     }
3022 }
3023 
3024 contract NerdVault is OwnableUpgradeSafe, TimeLockLPToken {
3025     using SafeMath for uint256;
3026     using SafeERC20 for IERC20;
3027 
3028     // Dev address.
3029     address public devaddr;
3030     address public tentativeDevAddress;
3031 
3032     // Total allocation poitns. Must be the sum of all allocation points in all pools.
3033     uint256 public totalAllocPoint;
3034 
3035     //// pending rewards awaiting anyone to massUpdate
3036     uint256 public pendingRewards;
3037 
3038     uint256 public epoch;
3039 
3040     uint256 public constant REWARD_LOCKED_PERIOD = 28 days;
3041     uint256 public constant REWARD_RELEASE_PERCENTAGE = 50;
3042     uint256 public contractStartBlock;
3043 
3044     uint256 private nerdBalance;
3045 
3046     // Sets the dev fee for this contract
3047     // defaults at 7.24%
3048     // Note contract owner is meant to be a governance contract allowing NERD governance consensus
3049     uint16 DEV_FEE;
3050 
3051     uint256 public pending_DEV_rewards;
3052 
3053     address private _superAdmin;
3054 
3055     IUniswapV2Router02 public uniswapRouterV2;
3056     IUniswapV2Factory public uniswapFactory;
3057 
3058     // Returns fees generated since start of this contract
3059     function averageFeesPerBlockSinceStart(uint256 _pid)
3060         external
3061         view
3062         returns (uint256 averagePerBlock)
3063     {
3064         averagePerBlock = poolInfo[_pid]
3065             .cumulativeRewardsSinceStart
3066             .add(poolInfo[_pid].rewardsInThisEpoch)
3067             .add(pendingNerdForPool(_pid))
3068             .div(block.number.sub(poolInfo[_pid].startBlock));
3069     }
3070 
3071     // Returns averge fees in this epoch
3072     function averageFeesPerBlockEpoch(uint256 _pid)
3073         external
3074         view
3075         returns (uint256 averagePerBlock)
3076     {
3077         averagePerBlock = poolInfo[_pid]
3078             .rewardsInThisEpoch
3079             .add(pendingNerdForPool(_pid))
3080             .div(block.number.sub(poolInfo[_pid].epochCalculationStartBlock));
3081     }
3082 
3083     function getEpochReward(uint256 _pid, uint256 _epoch)
3084         public
3085         view
3086         returns (uint256)
3087     {
3088         return poolInfo[_pid].epochRewards[_epoch];
3089     }
3090 
3091     //Starts a new calculation epoch
3092     // Because averge since start will not be accurate
3093     function startNewEpoch() public {
3094         for (uint256 _pid = 0; _pid < poolInfo.length; _pid++) {
3095             require(
3096                 poolInfo[_pid].epochCalculationStartBlock + 50000 <
3097                     block.number,
3098                 "New epoch not ready yet"
3099             ); // About a week
3100             poolInfo[_pid].epochRewards[epoch] = poolInfo[_pid]
3101                 .rewardsInThisEpoch;
3102             poolInfo[_pid].cumulativeRewardsSinceStart = poolInfo[_pid]
3103                 .cumulativeRewardsSinceStart
3104                 .add(poolInfo[_pid].rewardsInThisEpoch);
3105             poolInfo[_pid].rewardsInThisEpoch = 0;
3106             poolInfo[_pid].epochCalculationStartBlock = block.number;
3107             ++epoch;
3108         }
3109     }
3110 
3111     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
3112     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
3113     event EmergencyWithdraw(
3114         address indexed user,
3115         uint256 indexed pid,
3116         uint256 amount
3117     );
3118     event Approval(
3119         address indexed owner,
3120         address indexed spender,
3121         uint256 _pid,
3122         uint256 value
3123     );
3124 
3125     function initialize(INerdBaseTokenLGE _nerd, address superAdmin)
3126         public
3127         initializer
3128     {
3129         OwnableUpgradeSafe.__Ownable_init();
3130         DEV_FEE = 724;
3131         nerd = _nerd;
3132         devaddr = nerd.devFundAddress();
3133         tentativeDevAddress = address(0);
3134         contractStartBlock = block.number;
3135         _superAdmin = superAdmin;
3136 
3137         require(
3138             isTokenPairValid(nerd.tokenUniswapPair()),
3139             "One of the paired tokens must be NERD"
3140         );
3141 
3142         //add first pool: genesis pool
3143         add(uint256(1000), IERC20(nerd.tokenUniswapPair()), true);
3144         uniswapRouterV2 = IUniswapV2Router02(nerd.getUniswapRouterV2());
3145         uniswapFactory = IUniswapV2Factory(nerd.getUniswapFactory());
3146     }
3147 
3148     function isTokenPairValid(address _pair) public view returns (bool) {
3149         IUniswapV2Pair tokenPair = IUniswapV2Pair(_pair);
3150         return
3151             tokenPair.token0() == address(nerd) ||
3152             tokenPair.token1() == address(nerd);
3153     }
3154 
3155     function poolLength() external view returns (uint256) {
3156         return poolInfo.length;
3157     }
3158 
3159     function poolToken(uint256 _pid) external view returns (address) {
3160         return address(poolInfo[_pid].token);
3161     }
3162 
3163     function isMultipleOfWeek(uint256 _period) public pure returns (bool) {
3164         uint256 numWeeks = _period.div(LP_RELEASE_TRUNK);
3165         return (_period == numWeeks.mul(LP_RELEASE_TRUNK));
3166     }
3167 
3168     // Add a new token pool. Can only be called by the owner.
3169     // Note contract owner is meant to be a governance contract allowing NERD governance consensus
3170     function add(
3171         uint256 _allocPoint,
3172         IERC20 _token,
3173         bool _withUpdate
3174     ) public onlyOwner {
3175         require(
3176             isTokenPairValid(address(_token)),
3177             "One of the paired tokens must be NERD"
3178         );
3179         if (_withUpdate) {
3180             massUpdatePools();
3181         }
3182 
3183         uint256 length = poolInfo.length;
3184         for (uint256 pid = 0; pid < length; ++pid) {
3185             require(poolInfo[pid].token != _token, "Error pool already added");
3186         }
3187 
3188         totalAllocPoint = totalAllocPoint.add(_allocPoint);
3189 
3190         poolInfo.push(
3191             PoolInfo({
3192                 token: _token,
3193                 allocPoint: _allocPoint,
3194                 accNerdPerShare: 0,
3195                 lockedPeriod: LP_LOCKED_PERIOD_WEEKS.mul(LP_RELEASE_TRUNK),
3196                 emergencyWithdrawable: false,
3197                 rewardsInThisEpoch: 0,
3198                 cumulativeRewardsSinceStart: 0,
3199                 startBlock: block.number,
3200                 epochCalculationStartBlock: block.number
3201             })
3202         );
3203     }
3204 
3205     function claimLPToken() public {
3206         if (!genesisLPClaimed) {
3207             if (nerd.isLPGenerationCompleted()) {
3208                 genesisLPClaimed = true;
3209                 uint256 totalMinted = nerd.getReleasableLPTokensMinted();
3210                 poolInfo[0].token.safeTransferFrom(
3211                     address(nerd),
3212                     address(this),
3213                     totalMinted
3214                 );
3215             }
3216         }
3217     }
3218 
3219     function claimLPTokensToFarmingPool(address _addr) public {
3220         claimLPToken();
3221         if (genesisLPClaimed) {
3222             if (!userInfo[0][_addr].genesisLPClaimed) {
3223                 uint256 allocated = getAllocatedLP(_addr);
3224                 userInfo[0][_addr].genesisLPClaimed = true;
3225                 userInfo[0][_addr].amount = allocated;
3226                 userInfo[0][_addr].referenceAmount = allocated;
3227                 userInfo[0][_addr].depositTime = nerd.getLpReleaseStart().sub(
3228                     LP_INITIAL_LOCKED_PERIOD
3229                 );
3230             }
3231         }
3232     }
3233 
3234     function getDepositTime(uint256 _pid, address _addr)
3235         public
3236         view
3237         returns (uint256)
3238     {
3239         return userInfo[_pid][_addr].depositTime;
3240     }
3241 
3242     //return value is /1000
3243     function getPenaltyFactorForEarlyUnlockers(uint256 _pid, address _addr)
3244         public
3245         view
3246         returns (uint256)
3247     {
3248         uint256 lpReleaseStart = getLpReleaseStart(_pid, _addr);
3249         if (lpReleaseStart == 0 || block.timestamp < lpReleaseStart)
3250             return 1000;
3251         uint256 weeksTilNow = weeksSinceLPReleaseTilNow(_pid, _addr);
3252         uint256 numReleaseWeeks = poolInfo[_pid].lockedPeriod.div(
3253             LP_RELEASE_TRUNK
3254         ); //10
3255         if (weeksTilNow >= numReleaseWeeks) return 0;
3256         uint256 remainingWeeks = numReleaseWeeks.sub(weeksTilNow);
3257         //week 1: 45/1000 = 4.5%
3258         //week 2: 40/1000 = 4%
3259         uint256 ret = remainingWeeks.mul(50000).div(1000).div(numReleaseWeeks);
3260         return ret > 1000 ? 1000 : ret;
3261     }
3262 
3263     function computeReleasableLPWithPenalty(uint256 _pid, address _addr)
3264         public
3265         view
3266         returns (uint256 userAmount, uint256 penaltyAmount)
3267     {
3268         uint256 releasableWithoutPenalty = computeReleasableLP(_pid, _addr);
3269         uint256 penalty = getPenaltyFactorForEarlyUnlockers(_pid, _addr);
3270         penaltyAmount = releasableWithoutPenalty.mul(penalty).div(1000);
3271         userAmount = releasableWithoutPenalty
3272             .mul(uint256(1000).sub(penalty))
3273             .div(1000);
3274     }
3275 
3276     function removeLiquidity(address _pair, uint256 _lpAmount)
3277         internal
3278         returns (uint256)
3279     {
3280         IUniswapV2Pair _tokenPair = IUniswapV2Pair(_pair);
3281         _tokenPair.approve(address(uniswapRouterV2), _lpAmount);
3282         (uint256 amountA, uint256 amountB) = uniswapRouterV2.removeLiquidity(
3283             _tokenPair.token0(),
3284             _tokenPair.token1(),
3285             _lpAmount,
3286             0,
3287             0,
3288             address(this),
3289             block.timestamp + 86400
3290         );
3291         uint256 otherTokenAmount = _tokenPair.token0() == address(nerd)
3292             ? amountB
3293             : amountA;
3294         return otherTokenAmount;
3295     }
3296 
3297     function swapTokenForNerd(address _pair, uint256 _tokenAmount) internal {
3298         //withdraw liquidtity for _actualPenalty
3299         IUniswapV2Pair _tokenPair = IUniswapV2Pair(_pair);
3300         address otherTokenAddress = _tokenPair.token0() == address(nerd)
3301             ? _tokenPair.token1()
3302             : _tokenPair.token0();
3303         address[] memory paths = new address[](2);
3304         paths[0] = otherTokenAddress;
3305         paths[1] = address(nerd);
3306 
3307         IERC20 otherToken = IERC20(otherTokenAddress);
3308         otherToken.approve(address(uniswapRouterV2), _tokenAmount);
3309         uniswapRouterV2.swapExactTokensForTokens(
3310             _tokenAmount,
3311             0,
3312             paths,
3313             address(this),
3314             block.timestamp.add(86400)
3315         );
3316     }
3317 
3318     // Update the given pool's NERDs allocation point. Can only be called by the owner.
3319     // Note contract owner is meant to be a governance contract allowing NERD governance consensus
3320 
3321     function set(
3322         uint256 _pid,
3323         uint256 _allocPoint,
3324         bool _withUpdate
3325     ) public onlyOwner {
3326         if (_withUpdate) {
3327             massUpdatePools();
3328         }
3329 
3330         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
3331             _allocPoint
3332         );
3333         poolInfo[_pid].allocPoint = _allocPoint;
3334     }
3335 
3336     // Update the given pool's ability to withdraw tokens
3337     // Note contract owner is meant to be a governance contract allowing NERD governance consensus
3338     function setPoolLockPeriod(uint256 _pid, uint256 _lockedPeriod)
3339         public
3340         onlyOwner
3341     {
3342         require(
3343             isMultipleOfWeek(_lockedPeriod),
3344             "Locked period must be a multiple of week"
3345         );
3346         poolInfo[_pid].lockedPeriod = _lockedPeriod;
3347     }
3348 
3349     function setEmergencyWithdrawable(uint256 _pid, bool _withdrawable)
3350         public
3351         onlyOwner
3352     {
3353         poolInfo[_pid].emergencyWithdrawable = _withdrawable;
3354     }
3355 
3356     function setDevFee(uint16 _DEV_FEE) public onlyOwner {
3357         require(_DEV_FEE <= 1000, "Dev fee clamped at 10%");
3358         DEV_FEE = _DEV_FEE;
3359     }
3360 
3361     function pendingNerdForPool(uint256 _pid) public view returns (uint256) {
3362         PoolInfo storage pool = poolInfo[_pid];
3363 
3364         uint256 tokenSupply = pool.token.balanceOf(address(this));
3365         if (_pid == 0 && !genesisLPClaimed) {
3366             uint256 totalMinted = nerd.getReleasableLPTokensMinted();
3367             tokenSupply = tokenSupply.add(totalMinted);
3368         }
3369 
3370         if (tokenSupply == 0) return 0;
3371 
3372         uint256 nerdRewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
3373             .mul(pool.allocPoint) // getting the percent of total pending rewards this pool should get
3374             .div(totalAllocPoint); // we can do this because pools are only mass updated
3375         uint256 nerdRewardFee = nerdRewardWhole.mul(DEV_FEE).div(10000);
3376         return nerdRewardWhole.sub(nerdRewardFee);
3377     }
3378 
3379     // View function to see pending NERDs on frontend.
3380     function pendingNerd(uint256 _pid, address _user)
3381         public
3382         view
3383         returns (uint256)
3384     {
3385         PoolInfo storage pool = poolInfo[_pid];
3386         UserInfo storage user = userInfo[_pid][_user];
3387         uint256 accNerdPerShare = pool.accNerdPerShare;
3388         uint256 amount = user.amount;
3389 
3390         uint256 tokenSupply = pool.token.balanceOf(address(this));
3391         if (_pid == 0 && !genesisLPClaimed) {
3392             uint256 totalMinted = nerd.getReleasableLPTokensMinted();
3393             tokenSupply = tokenSupply.add(totalMinted);
3394         }
3395 
3396         if (tokenSupply == 0) return 0;
3397 
3398         if (_pid == 0 && !user.genesisLPClaimed) {
3399             uint256 allocated = getAllocatedLP(_user);
3400             amount = amount.add(allocated);
3401         }
3402 
3403         uint256 nerdRewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
3404             .mul(pool.allocPoint) // getting the percent of total pending rewards this pool should get
3405             .div(totalAllocPoint); // we can do this because pools are only mass updated
3406         uint256 nerdRewardFee = nerdRewardWhole.mul(DEV_FEE).div(10000);
3407         uint256 nerdRewardToDistribute = nerdRewardWhole.sub(nerdRewardFee);
3408         uint256 inc = nerdRewardToDistribute.mul(1e18).div(tokenSupply);
3409         accNerdPerShare = accNerdPerShare.add(inc);
3410 
3411         return amount.mul(accNerdPerShare).div(1e18).sub(user.rewardDebt);
3412     }
3413 
3414     function getLockedReward(uint256 _pid, address _user)
3415         public
3416         view
3417         returns (uint256)
3418     {
3419         return userInfo[_pid][_user].rewardLocked;
3420     }
3421 
3422     // Update reward vairables for all pools. Be careful of gas spending!
3423     function massUpdatePools() public {
3424         console.log("Mass Updating Pools");
3425         uint256 length = poolInfo.length;
3426         uint256 allRewards;
3427         for (uint256 pid = 0; pid < length; ++pid) {
3428             allRewards = allRewards.add(updatePool(pid));
3429         }
3430 
3431         pendingRewards = pendingRewards.sub(allRewards);
3432     }
3433 
3434     // ----
3435     // Function that adds pending rewards, called by the NERD token.
3436     // ----
3437     function updatePendingRewards() public {
3438         uint256 newRewards = nerd.balanceOf(address(this)).sub(nerdBalance);
3439 
3440         if (newRewards > 0) {
3441             nerdBalance = nerd.balanceOf(address(this)); // If there is no change the balance didn't change
3442             pendingRewards = pendingRewards.add(newRewards);
3443         }
3444     }
3445 
3446     // Update reward variables of the given pool to be up-to-date.
3447     function updatePool(uint256 _pid)
3448         internal
3449         returns (uint256 nerdRewardWhole)
3450     {
3451         PoolInfo storage pool = poolInfo[_pid];
3452 
3453         uint256 tokenSupply = pool.token.balanceOf(address(this));
3454         if (_pid == 0 && !genesisLPClaimed) {
3455             uint256 totalMinted = nerd.getReleasableLPTokensMinted();
3456             tokenSupply = tokenSupply.add(totalMinted);
3457         }
3458         if (tokenSupply == 0) {
3459             // avoids division by 0 errors
3460             return 0;
3461         }
3462         nerdRewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
3463             .mul(pool.allocPoint) // getting the percent of total pending rewards this pool should get
3464             .div(totalAllocPoint); // we can do this because pools are only mass updated
3465 
3466         uint256 nerdRewardFee = nerdRewardWhole.mul(DEV_FEE).div(10000);
3467         uint256 nerdRewardToDistribute = nerdRewardWhole.sub(nerdRewardFee);
3468 
3469         uint256 inc = nerdRewardToDistribute.mul(1e18).div(tokenSupply);
3470         nerdRewardToDistribute = tokenSupply.mul(inc).div(1e18);
3471         nerdRewardFee = nerdRewardWhole.sub(nerdRewardToDistribute);
3472         pending_DEV_rewards = pending_DEV_rewards.add(nerdRewardFee);
3473 
3474         pool.accNerdPerShare = pool.accNerdPerShare.add(inc);
3475         pool.rewardsInThisEpoch = pool.rewardsInThisEpoch.add(
3476             nerdRewardToDistribute
3477         );
3478     }
3479 
3480     function withdrawNerd(uint256 _pid) public {
3481         withdraw(_pid, 0);
3482     }
3483 
3484     // Deposit  tokens to NerdVault for NERD allocation.
3485     function deposit(uint256 _pid, uint256 _originAmount) public {
3486         claimLPTokensToFarmingPool(msg.sender);
3487         PoolInfo storage pool = poolInfo[_pid];
3488         UserInfo storage user = userInfo[_pid][msg.sender];
3489 
3490         massUpdatePools();
3491 
3492         // Transfer pending tokens
3493         // to user
3494         updateAndPayOutPending(_pid, msg.sender);
3495 
3496         uint256 lpAccumulationFee = _originAmount.mul(LP_ACCUMULATION_FEE).div(
3497             1000
3498         );
3499         uint256 _amount = _originAmount.sub(lpAccumulationFee);
3500 
3501         //Transfer in the amounts from user
3502         // save gas
3503         if (_amount > 0) {
3504             pool.token.safeTransferFrom(
3505                 address(msg.sender),
3506                 ADDRESS_LOCKED_LP_ACCUMULATION,
3507                 lpAccumulationFee
3508             );
3509             pool.token.safeTransferFrom(
3510                 address(msg.sender),
3511                 address(this),
3512                 _amount
3513             );
3514             updateDepositTime(_pid, msg.sender, _amount);
3515             user.amount = user.amount.add(_amount);
3516         }
3517 
3518         user.rewardDebt = user.amount.mul(pool.accNerdPerShare).div(1e18);
3519         emit Deposit(msg.sender, _pid, _amount);
3520     }
3521 
3522     function updateDepositTime(
3523         uint256 _pid,
3524         address _addr,
3525         uint256 _depositAmount
3526     ) internal {
3527         UserInfo storage user = userInfo[_pid][_addr];
3528         if (user.amount == 0) {
3529             user.depositTime = block.timestamp;
3530             user.referenceAmount = _depositAmount;
3531         } else {
3532             uint256 lockedPeriod = poolInfo[_pid].lockedPeriod;
3533             uint256 tobeReleased = computeReleasableLP(_pid, _addr);
3534             uint256 amountAfterDeposit = user.amount.add(_depositAmount);
3535             uint256 diffTime = tobeReleased.mul(lockedPeriod).div(
3536                 amountAfterDeposit
3537             );
3538             user.depositTime = block.timestamp.sub(diffTime.div(2));
3539             //reset referenceAmount to start a new lock-release period
3540             user.referenceAmount = amountAfterDeposit;
3541         }
3542     }
3543 
3544     // Test coverage
3545     // [x] Does user get the deposited amounts?
3546     // [x] Does user that its deposited for update correcty?
3547     // [x] Does the depositor get their tokens decreased
3548     function depositFor(
3549         address _depositFor,
3550         uint256 _pid,
3551         uint256 _originAmount
3552     ) public {
3553         claimLPTokensToFarmingPool(_depositFor);
3554         // requires no allowances
3555         PoolInfo storage pool = poolInfo[_pid];
3556         UserInfo storage user = userInfo[_pid][_depositFor];
3557 
3558         massUpdatePools();
3559 
3560         // Transfer pending tokens
3561         // to user
3562         updateAndPayOutPending(_pid, _depositFor); // Update the balances of person that amount is being deposited for
3563         uint256 lpAccumulationFee = _originAmount.mul(LP_ACCUMULATION_FEE).div(
3564             1000
3565         );
3566         uint256 _amount = _originAmount.sub(lpAccumulationFee);
3567 
3568         if (_amount > 0) {
3569             pool.token.safeTransferFrom(
3570                 address(msg.sender),
3571                 ADDRESS_LOCKED_LP_ACCUMULATION,
3572                 lpAccumulationFee
3573             );
3574             pool.token.safeTransferFrom(
3575                 address(msg.sender),
3576                 address(this),
3577                 _amount
3578             );
3579             updateDepositTime(_pid, _depositFor, _amount);
3580             user.amount = user.amount.add(_amount); // This is depositedFor address
3581         }
3582 
3583         user.rewardDebt = user.amount.mul(pool.accNerdPerShare).div(1e18); /// This is deposited for address
3584         emit Deposit(_depositFor, _pid, _amount);
3585     }
3586 
3587     // Test coverage
3588     // [x] Does allowance update correctly?
3589     function setAllowanceForPoolToken(
3590         address spender,
3591         uint256 _pid,
3592         uint256 value
3593     ) public {
3594         PoolInfo storage pool = poolInfo[_pid];
3595         pool.allowance[msg.sender][spender] = value;
3596         emit Approval(msg.sender, spender, _pid, value);
3597     }
3598 
3599     function quitPool(uint256 _pid) public {
3600         require(
3601             block.timestamp > getLpReleaseStart(_pid, msg.sender),
3602             "cannot withdraw all lp tokens before"
3603         );
3604 
3605         (uint256 withdrawnableAmount, ) = computeReleasableLPWithPenalty(
3606             _pid,
3607             msg.sender
3608         );
3609         withdraw(_pid, withdrawnableAmount);
3610     }
3611 
3612     // Test coverage
3613     // [x] Does allowance decrease?
3614     // [x] Do oyu need allowance
3615     // [x] Withdraws to correct address
3616     function withdrawFrom(
3617         address owner,
3618         uint256 _pid,
3619         uint256 _amount
3620     ) public {
3621         claimLPTokensToFarmingPool(owner);
3622         PoolInfo storage pool = poolInfo[_pid];
3623         require(
3624             pool.allowance[owner][msg.sender] >= _amount,
3625             "withdraw: insufficient allowance"
3626         );
3627         pool.allowance[owner][msg.sender] = pool.allowance[owner][msg.sender]
3628             .sub(_amount);
3629         _withdraw(_pid, _amount, owner, msg.sender);
3630     }
3631 
3632     // Withdraw  tokens from NerdVault.
3633     function withdraw(uint256 _pid, uint256 _amount) public {
3634         claimLPTokensToFarmingPool(msg.sender);
3635         _withdraw(_pid, _amount, msg.sender, msg.sender);
3636     }
3637 
3638     // Low level withdraw function
3639     function _withdraw(
3640         uint256 _pid,
3641         uint256 _amount,
3642         address from,
3643         address to
3644     ) internal {
3645         PoolInfo storage pool = poolInfo[_pid];
3646         //require(pool.withdrawable, "Withdrawing from this pool is disabled");
3647         UserInfo storage user = userInfo[_pid][from];
3648         (
3649             uint256 withdrawnableAmount,
3650             uint256 penaltyAmount
3651         ) = computeReleasableLPWithPenalty(_pid, from);
3652         require(withdrawnableAmount >= _amount, "withdraw: not good");
3653 
3654         massUpdatePools();
3655         updateAndPayOutPending(_pid, from); // Update balances of from this is not withdrawal but claiming NERD farmed
3656 
3657         if (_amount > 0) {
3658             uint256 _actualWithdrawn = _amount;
3659             uint256 _actualPenalty = _actualWithdrawn.mul(penaltyAmount).div(
3660                 withdrawnableAmount
3661             );
3662             user.amount = user.amount.sub(_actualWithdrawn.add(_actualPenalty));
3663 
3664             pool.token.safeTransfer(address(to), _actualWithdrawn);
3665 
3666             if (_actualPenalty > 0) {
3667                 //withdraw liquidtity for _actualPenalty
3668                 uint256 otherTokenAmount = removeLiquidity(
3669                     address(pool.token),
3670                     _actualPenalty
3671                 );
3672                 swapTokenForNerd(address(pool.token), otherTokenAmount);
3673 
3674                 updatePendingRewards();
3675             }
3676         }
3677         user.rewardDebt = user.amount.mul(pool.accNerdPerShare).div(1e18);
3678 
3679         emit Withdraw(to, _pid, _amount);
3680     }
3681 
3682     function updateAndPayOutPending(uint256 _pid, address from) internal {
3683         UserInfo storage user = userInfo[_pid][from];
3684         if (user.releaseTime == 0) {
3685             user.releaseTime = block.timestamp.add(REWARD_LOCKED_PERIOD);
3686         }
3687         if (block.timestamp > user.releaseTime) {
3688             //compute withdrawnable amount
3689             uint256 lockedAmount = user.rewardLocked;
3690             user.rewardLocked = 0;
3691             safeNerdTransfer(from, lockedAmount);
3692             user.releaseTime = block.timestamp.add(REWARD_LOCKED_PERIOD);
3693         }
3694 
3695         uint256 pending = pendingNerd(_pid, from);
3696         uint256 paid = pending.mul(REWARD_RELEASE_PERCENTAGE).div(100);
3697         uint256 _lockedReward = pending.sub(paid);
3698         if (_lockedReward > 0) {
3699             user.rewardLocked = user.rewardLocked.add(_lockedReward);
3700         }
3701 
3702         if (paid > 0) {
3703             safeNerdTransfer(from, paid);
3704         }
3705     }
3706 
3707     // function that lets owner/governance contract
3708     // approve allowance for any token inside this contract
3709     // This means all future UNI like airdrops are covered
3710     // And at the same time allows us to give allowance to strategy contracts.
3711     // Upcoming cYFI etc vaults strategy contracts will  se this function to manage and farm yield on value locked
3712     function setStrategyContractOrDistributionContractAllowance(
3713         address tokenAddress,
3714         uint256 _amount,
3715         address contractAddress
3716     ) public onlySuperAdmin {
3717         require(
3718             isContract(contractAddress),
3719             "Recipent is not a smart contract, BAD"
3720         );
3721         require(
3722             block.number > contractStartBlock.add(95_000),
3723             "Governance setup grace period not over"
3724         );
3725         IERC20(tokenAddress).approve(contractAddress, _amount);
3726     }
3727 
3728     function isContract(address addr) public view returns (bool) {
3729         uint256 size;
3730         assembly {
3731             size := extcodesize(addr)
3732         }
3733         return size > 0;
3734     }
3735 
3736     function emergencyWithdraw(uint256 _pid) public {
3737         PoolInfo storage pool = poolInfo[_pid];
3738         require(
3739             pool.emergencyWithdrawable,
3740             "Withdrawing from this pool is disabled"
3741         );
3742         claimLPTokensToFarmingPool(msg.sender);
3743         UserInfo storage user = userInfo[_pid][msg.sender];
3744         pool.token.safeTransfer(address(msg.sender), user.amount);
3745         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
3746         user.amount = 0;
3747         user.rewardDebt = 0;
3748     }
3749 
3750     function safeNerdTransfer(address _to, uint256 _amount) internal {
3751         uint256 nerdBal = nerd.balanceOf(address(this));
3752 
3753         if (_amount > nerdBal) {
3754             nerd.transfer(_to, nerdBal);
3755             nerdBalance = nerd.balanceOf(address(this));
3756         } else {
3757             nerd.transfer(_to, _amount);
3758             nerdBalance = nerd.balanceOf(address(this));
3759         }
3760         transferDevFee();
3761     }
3762 
3763     function transferDevFee() public {
3764         if (pending_DEV_rewards == 0) return;
3765 
3766         uint256 nerdBal = nerd.balanceOf(address(this));
3767         if (pending_DEV_rewards > nerdBal) {
3768             nerd.transfer(devaddr, nerdBal);
3769             nerdBalance = nerd.balanceOf(address(this));
3770         } else {
3771             nerd.transfer(devaddr, pending_DEV_rewards);
3772             nerdBalance = nerd.balanceOf(address(this));
3773         }
3774 
3775         pending_DEV_rewards = 0;
3776     }
3777 
3778     function setDevFeeReciever(address _devaddr) public onlyOwner {
3779         require(devaddr == msg.sender, "only dev can change");
3780         tentativeDevAddress = _devaddr;
3781     }
3782 
3783     function confirmDevAddress() public {
3784         require(tentativeDevAddress == msg.sender, "not tentativeDevAddress!");
3785         devaddr = tentativeDevAddress;
3786         tentativeDevAddress = address(0);
3787     }
3788 
3789     event SuperAdminTransfered(
3790         address indexed previousOwner,
3791         address indexed newOwner
3792     );
3793 
3794     function superAdmin() public view returns (address) {
3795         return _superAdmin;
3796     }
3797 
3798     modifier onlySuperAdmin() {
3799         require(
3800             _superAdmin == _msgSender(),
3801             "Super admin : caller is not super admin."
3802         );
3803         _;
3804     }
3805 
3806     function burnSuperAdmin() public virtual onlySuperAdmin {
3807         emit SuperAdminTransfered(_superAdmin, address(0));
3808         _superAdmin = address(0);
3809     }
3810 
3811     function newSuperAdmin(address newOwner) public virtual onlySuperAdmin {
3812         require(
3813             newOwner != address(0),
3814             "Ownable: new owner is the zero address"
3815         );
3816         emit SuperAdminTransfered(_superAdmin, newOwner);
3817         _superAdmin = newOwner;
3818     }
3819 
3820     function getLiquidityInfo(uint256 _pid)
3821         public
3822         view
3823         returns (
3824             uint256 lpSupply,
3825             uint256 nerdAmount,
3826             uint256 totalNerdAmount,
3827             uint256 tokenAmount,
3828             uint256 totalTokenAmount,
3829             uint256 lockedLP,
3830             uint256 totalLockedLP
3831         )
3832     {
3833         IERC20 lpToken = poolInfo[_pid].token;
3834         IERC20 nerdToken = IERC20(address(nerd));
3835         IUniswapV2Pair pair = IUniswapV2Pair(address(lpToken));
3836         address otherTokenAddress = (pair.token0() == address(nerd))
3837             ? pair.token1()
3838             : pair.token0();
3839         IERC20 otherToken = IERC20(otherTokenAddress);
3840 
3841         lpSupply = lpToken.totalSupply();
3842         if (lpSupply > 0) {
3843             uint256 lpNerdBalance = nerdToken.balanceOf(address(lpToken));
3844             uint256 lpOtherBalance = otherToken.balanceOf(address(lpToken));
3845 
3846             lockedLP = lpToken.balanceOf(address(this));
3847             if (lockedLP == 0 && _pid == 0 && !genesisLPClaimed) {
3848                 lockedLP = nerd.getReleasableLPTokensMinted();
3849                 totalLockedLP = nerd.getTotalLPTokensMinted();
3850             } else {
3851                 totalLockedLP = lockedLP;
3852                 if (_pid == 0) {
3853                     totalLockedLP = totalLockedLP.add(
3854                         nerd.getTotalLPTokensMinted().sub(
3855                             nerd.getReleasableLPTokensMinted()
3856                         )
3857                     );
3858                 }
3859             }
3860             nerdAmount = lockedLP.mul(lpNerdBalance).div(lpSupply);
3861             totalNerdAmount = totalLockedLP.mul(lpNerdBalance).div(lpSupply);
3862 
3863             tokenAmount = lockedLP.mul(lpOtherBalance).div(lpSupply);
3864             totalTokenAmount = totalLockedLP.mul(lpOtherBalance).div(lpSupply);
3865         }
3866     }
3867 }