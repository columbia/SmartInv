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
801 // File: contracts/IPISBaseToken.sol
802 
803 
804 pragma solidity 0.6.12;
805 
806 /**
807  * @dev Interface of the ERC20 standard as defined in the EIP.
808  */
809 interface IPISBaseToken {
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
895 interface IPISBaseTokenEx is IPISBaseToken {
896     function devFundAddress() external view returns (address);
897 
898     function transferCheckerAddress() external view returns (address);
899 
900     function feeDistributor() external view returns (address);
901 }
902 
903 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
904 
905 pragma solidity 0.6.12;
906 
907 interface IUniswapV2Pair {
908     event Approval(
909         address indexed owner,
910         address indexed spender,
911         uint256 value
912     );
913     event Transfer(address indexed from, address indexed to, uint256 value);
914 
915     function name() external pure returns (string memory);
916 
917     function symbol() external pure returns (string memory);
918 
919     function decimals() external pure returns (uint8);
920 
921     function totalSupply() external view returns (uint256);
922 
923     function balanceOf(address owner) external view returns (uint256);
924 
925     function allowance(address owner, address spender)
926         external
927         view
928         returns (uint256);
929 
930     function approve(address spender, uint256 value) external returns (bool);
931 
932     function transfer(address to, uint256 value) external returns (bool);
933 
934     function transferFrom(
935         address from,
936         address to,
937         uint256 value
938     ) external returns (bool);
939 
940     function DOMAIN_SEPARATOR() external view returns (bytes32);
941 
942     function PERMIT_TYPEHASH() external pure returns (bytes32);
943 
944     function nonces(address owner) external view returns (uint256);
945 
946     function permit(
947         address owner,
948         address spender,
949         uint256 value,
950         uint256 deadline,
951         uint8 v,
952         bytes32 r,
953         bytes32 s
954     ) external;
955 
956     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
957     event Burn(
958         address indexed sender,
959         uint256 amount0,
960         uint256 amount1,
961         address indexed to
962     );
963     event Swap(
964         address indexed sender,
965         uint256 amount0In,
966         uint256 amount1In,
967         uint256 amount0Out,
968         uint256 amount1Out,
969         address indexed to
970     );
971     event Sync(uint112 reserve0, uint112 reserve1);
972 
973     function MINIMUM_LIQUIDITY() external pure returns (uint256);
974 
975     function factory() external view returns (address);
976 
977     function token0() external view returns (address);
978 
979     function token1() external view returns (address);
980 
981     function getReserves()
982         external
983         view
984         returns (
985             uint112 reserve0,
986             uint112 reserve1,
987             uint32 blockTimestampLast
988         );
989 
990     function price0CumulativeLast() external view returns (uint256);
991 
992     function price1CumulativeLast() external view returns (uint256);
993 
994     function kLast() external view returns (uint256);
995 
996     function mint(address to) external returns (uint256 liquidity);
997 
998     function burn(address to)
999         external
1000         returns (uint256 amount0, uint256 amount1);
1001 
1002     function swap(
1003         uint256 amount0Out,
1004         uint256 amount1Out,
1005         address to,
1006         bytes calldata data
1007     ) external;
1008 
1009     function skim(address to) external;
1010 
1011     function sync() external;
1012 
1013     function initialize(address, address) external;
1014 }
1015 
1016 // File: contracts/PISVault.sol
1017 
1018 pragma solidity 0.6.12;
1019 
1020 
1021 
1022 
1023 
1024 
1025 
1026 
1027 // PISVault distributes fees equally amongst staked pools
1028 // Have fun reading it. Hopefully it's bug-free. God bless.
1029 
1030 contract TimeLockLPToken {
1031     using SafeMath for uint256;
1032     using Address for address;
1033 
1034     uint256 public constant LP_LOCKED_PERIOD_WEEKS = 4; //4 weeks,
1035     uint256 public constant LP_RELEASE_TRUNK = 1 weeks; //releasable every week,
1036     uint256 public constant LP_INITIAL_LOCKED_PERIOD = 14 days;
1037 
1038     // Info of each user.
1039     struct UserInfo {
1040         uint256 amount; // How many  tokens the user currently has.
1041         uint256 referenceAmount; //this amount is used for computing releasable LP amount
1042         uint256 rewardDebt; // Reward debt. See explanation below.
1043         uint256 rewardLocked;
1044         uint256 releaseTime;
1045         //
1046         // We do some fancy math here. Basically, any point in time, the amount of PISs
1047         // entitled to a user but is pending to be distributed is:
1048         //
1049         //   pending reward = (user.amount * pool.accPISPerShare) - user.rewardDebt
1050         //
1051         // Whenever a user deposits or withdraws  tokens to a pool. Here's what happens:
1052         //   1. The pool's `accPISPerShare` (and `lastRewardBlock`) gets updated.
1053         //   2. User receives the pending reward sent to his/her address.
1054         //   3. User's `amount` gets updated.
1055         //   4. User's `rewardDebt` gets updated.
1056 
1057         uint256 depositTime; //See explanation below.
1058         //this is a dynamic value. It changes every time user deposit to the pool
1059         //1. initial deposit X => deposit time is block time
1060         //2. deposit more at time deposit2 without amount Y =>
1061         //  => compute current releasable amount R
1062         //  => compute diffTime = R*lockedPeriod/(X + Y) => this is the duration users can unlock R with new deposit amount
1063         //  => updated depositTime = (blocktime - diffTime/2)
1064     }
1065 
1066     // Info of each pool.
1067     struct PoolInfo {
1068         IERC20 token; // Address of  token contract.
1069         uint256 allocPoint; // How many allocation points assigned to this pool. PISs to distribute per block.
1070         uint256 accPISPerShare; // Accumulated PISs per share, times 1e18. See below.
1071         uint256 lockedPeriod; // liquidity locked period
1072         mapping(address => mapping(address => uint256)) allowance;
1073         bool emergencyWithdrawable;
1074         uint256 rewardsInThisEpoch;
1075         uint256 cumulativeRewardsSinceStart;
1076         uint256 startBlock;
1077         // For easy graphing historical epoch rewards
1078         mapping(uint256 => uint256) epochRewards;
1079         uint256 epochCalculationStartBlock;
1080     }
1081 
1082     // Info of each pool.
1083     PoolInfo[] public poolInfo;
1084     // Info of each user that stakes  tokens.
1085     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1086 
1087     // The PIS TOKEN!
1088     IPISBaseTokenEx public pis;
1089 
1090     function getLpReleaseStart(uint256 _pid, address _user)
1091         public
1092         view
1093         returns (uint256)
1094     {
1095         return userInfo[_pid][_user].depositTime.add(LP_INITIAL_LOCKED_PERIOD);
1096     }
1097 
1098     function computeReleasableLP(uint256 _pid, address _addr)
1099         public
1100         view
1101         returns (uint256)
1102     {
1103         uint256 lpReleaseStart = getLpReleaseStart(_pid, _addr);
1104         if (block.timestamp < lpReleaseStart) {
1105             return 0;
1106         }
1107 
1108         uint256 amountLP = userInfo[_pid][_addr].referenceAmount;
1109         if (amountLP == 0) return 0;
1110 
1111         uint256 totalReleasableTilNow = 0;
1112 
1113         if (block.timestamp > lpReleaseStart.add(poolInfo[_pid].lockedPeriod)) {
1114             totalReleasableTilNow = amountLP;
1115         } else {
1116             uint256 weeksTilNow = weeksSinceLPReleaseTilNow(_pid, _addr);
1117 
1118             totalReleasableTilNow = weeksTilNow
1119                 .mul(LP_RELEASE_TRUNK)
1120                 .mul(amountLP)
1121                 .div(poolInfo[_pid].lockedPeriod);
1122         }
1123         if (totalReleasableTilNow > amountLP) {
1124             totalReleasableTilNow = amountLP;
1125         }
1126         uint256 alreadyReleased = amountLP.sub(userInfo[_pid][_addr].amount);
1127         if (totalReleasableTilNow > alreadyReleased) {
1128             return totalReleasableTilNow.sub(alreadyReleased);
1129         }
1130         return 0;
1131     }
1132 
1133     function weeksSinceLPReleaseTilNow(uint256 _pid, address _addr)
1134         public
1135         view
1136         returns (uint256)
1137     {
1138         uint256 lpReleaseStart = getLpReleaseStart(_pid, _addr);
1139         if (lpReleaseStart == 0 || block.timestamp < lpReleaseStart) return 0;
1140         uint256 timeTillNow = block.timestamp.sub(lpReleaseStart);
1141         uint256 weeksTilNow = timeTillNow.div(LP_RELEASE_TRUNK);
1142         weeksTilNow = weeksTilNow.add(1);
1143         return weeksTilNow;
1144     }
1145 }
1146 
1147 contract PISVault is OwnableUpgradeSafe, TimeLockLPToken {
1148     using SafeMath for uint256;
1149     using SafeERC20 for IERC20;
1150 
1151     // Dev address.
1152     address public devaddr;
1153 
1154     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1155     uint256 public totalAllocPoint;
1156 
1157     //// pending rewards awaiting anyone to massUpdate
1158     uint256 public pendingRewards;
1159 
1160     uint256 public epoch;
1161 
1162     uint256 public constant REWARD_LOCKED_PERIOD = 14 days;
1163     uint256 public constant REWARD_RELEASE_PERCENTAGE = 40;
1164     uint256 public contractStartBlock;
1165 
1166     uint256 private pisBalance;
1167 
1168     // Sets the dev fee for this contract
1169     // defaults at 7.24%
1170     // Note contract owner is meant to be a governance contract allowing PIS governance consensus
1171     uint16 DEV_FEE;
1172 
1173     uint256 public pending_DEV_rewards;
1174 
1175     // Returns fees generated since start of this contract
1176     function averageFeesPerBlockSinceStart(uint256 _pid)
1177         external
1178         view
1179         returns (uint256 averagePerBlock)
1180     {
1181         averagePerBlock = poolInfo[_pid]
1182             .cumulativeRewardsSinceStart
1183             .add(poolInfo[_pid].rewardsInThisEpoch)
1184             .add(pendingPISForPool(_pid))
1185             .div(block.number.sub(poolInfo[_pid].startBlock));
1186     }
1187 
1188     // Returns averge fees in this epoch
1189     function averageFeesPerBlockEpoch(uint256 _pid)
1190         external
1191         view
1192         returns (uint256 averagePerBlock)
1193     {
1194         averagePerBlock = poolInfo[_pid]
1195             .rewardsInThisEpoch
1196             .add(pendingPISForPool(_pid))
1197             .div(block.number.sub(poolInfo[_pid].epochCalculationStartBlock));
1198     }
1199 
1200     function getEpochReward(uint256 _pid, uint256 _epoch)
1201         public
1202         view
1203         returns (uint256)
1204     {
1205         return poolInfo[_pid].epochRewards[_epoch];
1206     }
1207 
1208     //Starts a new calculation epoch
1209     // Because averge since start will not be accurate
1210     function startNewEpoch() public {
1211         for (uint256 _pid = 0; _pid < poolInfo.length; _pid++) {
1212             require(
1213                 poolInfo[_pid].epochCalculationStartBlock + 50000 <
1214                     block.number,
1215                 "New epoch not ready yet"
1216             ); // About a week
1217             poolInfo[_pid].epochRewards[epoch] = poolInfo[_pid]
1218                 .rewardsInThisEpoch;
1219             poolInfo[_pid].cumulativeRewardsSinceStart = poolInfo[_pid]
1220                 .cumulativeRewardsSinceStart
1221                 .add(poolInfo[_pid].rewardsInThisEpoch);
1222             poolInfo[_pid].rewardsInThisEpoch = 0;
1223             poolInfo[_pid].epochCalculationStartBlock = block.number;
1224             ++epoch;
1225         }
1226     }
1227 
1228     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1229     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1230     event EmergencyWithdraw(
1231         address indexed user,
1232         uint256 indexed pid,
1233         uint256 amount
1234     );
1235     event Approval(
1236         address indexed owner,
1237         address indexed spender,
1238         uint256 _pid,
1239         uint256 value
1240     );
1241 
1242     function initialize(IPISBaseTokenEx _pis) public initializer {
1243         OwnableUpgradeSafe.__Ownable_init();
1244         DEV_FEE = 1000; //10%
1245         pis = _pis;
1246         devaddr = pis.devFundAddress();
1247         contractStartBlock = block.number;
1248     }
1249 
1250     function poolLength() external view returns (uint256) {
1251         return poolInfo.length;
1252     }
1253 
1254     function poolToken(uint256 _pid) external view returns (address) {
1255         return address(poolInfo[_pid].token);
1256     }
1257 
1258     function isMultipleOfWeek(uint256 _period) public pure returns (bool) {
1259         uint256 numWeeks = _period.div(LP_RELEASE_TRUNK);
1260         return (_period == numWeeks.mul(LP_RELEASE_TRUNK));
1261     }
1262 
1263     // Add a new token pool. Can only be called by the owner.
1264     // Note contract owner is meant to be a governance contract allowing PIS governance consensus
1265     function add(
1266         uint256 _allocPoint,
1267         IERC20 _token,
1268         bool _withUpdate
1269     ) public onlyOwner {
1270         require(address(_token) != address(pis), "!PIS token");
1271         if (_withUpdate) {
1272             massUpdatePools();
1273         }
1274 
1275         uint256 length = poolInfo.length;
1276         for (uint256 pid = 0; pid < length; ++pid) {
1277             require(poolInfo[pid].token != _token, "Error pool already added");
1278         }
1279 
1280         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1281 
1282         poolInfo.push(
1283             PoolInfo({
1284                 token: _token,
1285                 allocPoint: _allocPoint,
1286                 accPISPerShare: 0,
1287                 lockedPeriod: LP_LOCKED_PERIOD_WEEKS.mul(LP_RELEASE_TRUNK),
1288                 emergencyWithdrawable: false,
1289                 rewardsInThisEpoch: 0,
1290                 cumulativeRewardsSinceStart: 0,
1291                 startBlock: block.number,
1292                 epochCalculationStartBlock: block.number
1293             })
1294         );
1295     }
1296 
1297     function getDepositTime(uint256 _pid, address _addr)
1298         public
1299         view
1300         returns (uint256)
1301     {
1302         return userInfo[_pid][_addr].depositTime;
1303     }
1304 
1305     // Update the given pool's PISs allocation point. Can only be called by the owner.
1306     // Note contract owner is meant to be a governance contract allowing PIS governance consensus
1307 
1308     function set(
1309         uint256 _pid,
1310         uint256 _allocPoint,
1311         bool _withUpdate
1312     ) public onlyOwner {
1313         if (_withUpdate) {
1314             massUpdatePools();
1315         }
1316 
1317         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1318             _allocPoint
1319         );
1320         poolInfo[_pid].allocPoint = _allocPoint;
1321     }
1322 
1323     function setEmergencyWithdrawable(uint256 _pid, bool _withdrawable)
1324         public
1325         onlyOwner
1326     {
1327         poolInfo[_pid].emergencyWithdrawable = _withdrawable;
1328     }
1329 
1330     function setDevFee(uint16 _DEV_FEE) public onlyOwner {
1331         require(_DEV_FEE <= 1000, "Dev fee clamped at 10%");
1332         DEV_FEE = _DEV_FEE;
1333     }
1334 
1335     function pendingPISForPool(uint256 _pid) public view returns (uint256) {
1336         PoolInfo storage pool = poolInfo[_pid];
1337 
1338         uint256 tokenSupply = pool.token.balanceOf(address(this));
1339 
1340         if (tokenSupply == 0) return 0;
1341 
1342         uint256 rewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
1343             .mul(pool.allocPoint) // getting the percent of total pending rewards this pool should get
1344             .div(totalAllocPoint); // we can do this because pools are only mass updated
1345         uint256 rewardFee = rewardWhole.mul(DEV_FEE).div(10000);
1346         return rewardWhole.sub(rewardFee);
1347     }
1348 
1349     // View function to see pending PISs on frontend.
1350     function pendingPIS(uint256 _pid, address _user)
1351         public
1352         view
1353         returns (uint256)
1354     {
1355         PoolInfo storage pool = poolInfo[_pid];
1356         UserInfo storage user = userInfo[_pid][_user];
1357         uint256 accPISPerShare = pool.accPISPerShare;
1358         uint256 amount = user.amount;
1359 
1360         uint256 tokenSupply = pool.token.balanceOf(address(this));
1361 
1362         if (tokenSupply == 0) return 0;
1363 
1364         uint256 rewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
1365             .mul(pool.allocPoint) // getting the percent of total pending rewards this pool should get
1366             .div(totalAllocPoint); // we can do this because pools are only mass updated
1367         uint256 rewardFee = rewardWhole.mul(DEV_FEE).div(10000);
1368         uint256 rewardToDistribute = rewardWhole.sub(rewardFee);
1369         uint256 inc = rewardToDistribute.mul(1e18).div(tokenSupply);
1370         accPISPerShare = accPISPerShare.add(inc);
1371 
1372         return amount.mul(accPISPerShare).div(1e18).sub(user.rewardDebt);
1373     }
1374 
1375     function getLockedReward(uint256 _pid, address _user)
1376         public
1377         view
1378         returns (uint256)
1379     {
1380         return userInfo[_pid][_user].rewardLocked;
1381     }
1382 
1383     // Update reward vairables for all pools. Be careful of gas spending!
1384     function massUpdatePools() public {
1385         uint256 length = poolInfo.length;
1386         uint256 allRewards;
1387         for (uint256 pid = 0; pid < length; ++pid) {
1388             allRewards = allRewards.add(updatePool(pid));
1389         }
1390 
1391         pendingRewards = pendingRewards.sub(allRewards);
1392     }
1393 
1394     // ----
1395     // Function that adds pending rewards, called by the PIS token.
1396     // ----
1397     function updatePendingRewards() public {
1398         uint256 newRewards = pis.balanceOf(address(this)).sub(pisBalance);
1399 
1400         if (newRewards > 0) {
1401             pisBalance = pis.balanceOf(address(this)); // If there is no change the balance didn't change
1402             pendingRewards = pendingRewards.add(newRewards);
1403         }
1404     }
1405 
1406     // Update reward variables of the given pool to be up-to-date.
1407     function updatePool(uint256 _pid)
1408         internal
1409         returns (uint256 pisRewardWhole)
1410     {
1411         PoolInfo storage pool = poolInfo[_pid];
1412 
1413         uint256 tokenSupply = pool.token.balanceOf(address(this));
1414 
1415         if (tokenSupply == 0) {
1416             // avoids division by 0 errors
1417             return 0;
1418         }
1419         pisRewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
1420             .mul(pool.allocPoint) // getting the percent of total pending rewards this pool should get
1421             .div(totalAllocPoint); // we can do this because pools are only mass updated
1422 
1423         uint256 rewardFee = pisRewardWhole.mul(DEV_FEE).div(10000);
1424         uint256 rewardToDistribute = pisRewardWhole.sub(rewardFee);
1425 
1426         uint256 inc = rewardToDistribute.mul(1e18).div(tokenSupply);
1427         pending_DEV_rewards = pending_DEV_rewards.add(rewardFee);
1428 
1429         pool.accPISPerShare = pool.accPISPerShare.add(inc);
1430         pool.rewardsInThisEpoch = pool.rewardsInThisEpoch.add(
1431             rewardToDistribute
1432         );
1433     }
1434 
1435     function withdrawReward(uint256 _pid) public {
1436         withdraw(_pid, 0);
1437     }
1438 
1439     // Deposit  tokens to PISVault for PIS allocation.
1440     function deposit(uint256 _pid, uint256 _originAmount) public {
1441         PoolInfo storage pool = poolInfo[_pid];
1442         UserInfo storage user = userInfo[_pid][msg.sender];
1443 
1444         massUpdatePools();
1445 
1446         // Transfer pending tokens
1447         // to user
1448         updateAndPayOutPending(_pid, msg.sender);
1449 
1450         uint256 _amount = _originAmount;
1451 
1452         //Transfer in the amounts from user
1453         // save gas
1454         if (_amount > 0) {
1455             pool.token.safeTransferFrom(
1456                 address(msg.sender),
1457                 address(this),
1458                 _amount
1459             );
1460             updateDepositTime(_pid, msg.sender, _amount);
1461             user.amount = user.amount.add(_amount);
1462         }
1463 
1464         user.rewardDebt = user.amount.mul(pool.accPISPerShare).div(1e18);
1465         emit Deposit(msg.sender, _pid, _amount);
1466     }
1467 
1468     function updateDepositTime(
1469         uint256 _pid,
1470         address _addr,
1471         uint256 _depositAmount
1472     ) internal {
1473         UserInfo storage user = userInfo[_pid][_addr];
1474         if (user.amount == 0) {
1475             user.depositTime = block.timestamp;
1476             user.referenceAmount = _depositAmount;
1477         } else {
1478             uint256 lockedPeriod = poolInfo[_pid].lockedPeriod;
1479             uint256 tobeReleased = computeReleasableLP(_pid, _addr);
1480             uint256 amountAfterDeposit = user.amount.add(_depositAmount);
1481             uint256 diffTime = tobeReleased.mul(lockedPeriod).div(
1482                 amountAfterDeposit
1483             );
1484             user.depositTime = block.timestamp.sub(diffTime.div(2));
1485             //reset referenceAmount to start a new lock-release period
1486             user.referenceAmount = amountAfterDeposit;
1487         }
1488     }
1489 
1490     // Test coverage
1491     // [x] Does user get the deposited amounts?
1492     // [x] Does user that its deposited for update correcty?
1493     // [x] Does the depositor get their tokens decreased
1494     function depositFor(
1495         address _depositFor,
1496         uint256 _pid,
1497         uint256 _originAmount
1498     ) public {
1499         // requires no allowances
1500         PoolInfo storage pool = poolInfo[_pid];
1501         UserInfo storage user = userInfo[_pid][_depositFor];
1502 
1503         massUpdatePools();
1504 
1505         // Transfer pending tokens
1506         // to user
1507         updateAndPayOutPending(_pid, _depositFor); // Update the balances of person that amount is being deposited for
1508         uint256 _amount = _originAmount;
1509 
1510         if (_amount > 0) {
1511             pool.token.safeTransferFrom(
1512                 address(msg.sender),
1513                 address(this),
1514                 _amount
1515             );
1516             updateDepositTime(_pid, _depositFor, _amount);
1517             user.amount = user.amount.add(_amount); // This is depositedFor address
1518         }
1519 
1520         user.rewardDebt = user.amount.mul(pool.accPISPerShare).div(1e18); /// This is deposited for address
1521         emit Deposit(_depositFor, _pid, _amount);
1522     }
1523 
1524     // Test coverage
1525     // [x] Does allowance update correctly?
1526     function setAllowanceForPoolToken(
1527         address spender,
1528         uint256 _pid,
1529         uint256 value
1530     ) public {
1531         PoolInfo storage pool = poolInfo[_pid];
1532         pool.allowance[msg.sender][spender] = value;
1533         emit Approval(msg.sender, spender, _pid, value);
1534     }
1535 
1536     function quitPool(uint256 _pid) public {
1537         require(
1538             block.timestamp > getLpReleaseStart(_pid, msg.sender),
1539             "cannot withdraw all lp tokens before"
1540         );
1541 
1542         uint256 withdrawnableAmount = computeReleasableLP(_pid, msg.sender);
1543         withdraw(_pid, withdrawnableAmount);
1544     }
1545 
1546     // Test coverage
1547     // [x] Does allowance decrease?
1548     // [x] Do oyu need allowance
1549     // [x] Withdraws to correct address
1550     function withdrawFrom(
1551         address owner,
1552         uint256 _pid,
1553         uint256 _amount
1554     ) public {
1555         PoolInfo storage pool = poolInfo[_pid];
1556         require(
1557             pool.allowance[owner][msg.sender] >= _amount,
1558             "withdraw: insufficient allowance"
1559         );
1560         pool.allowance[owner][msg.sender] = pool.allowance[owner][msg.sender]
1561             .sub(_amount);
1562         _withdraw(_pid, _amount, owner, msg.sender);
1563     }
1564 
1565     // Withdraw  tokens from PISVault.
1566     function withdraw(uint256 _pid, uint256 _amount) public {
1567         _withdraw(_pid, _amount, msg.sender, msg.sender);
1568     }
1569 
1570     // Low level withdraw function
1571     function _withdraw(
1572         uint256 _pid,
1573         uint256 _amount,
1574         address from,
1575         address to
1576     ) internal {
1577         PoolInfo storage pool = poolInfo[_pid];
1578         //require(pool.withdrawable, "Withdrawing from this pool is disabled");
1579         UserInfo storage user = userInfo[_pid][from];
1580 
1581         uint256 withdrawnableAmount = computeReleasableLP(_pid, from);
1582         require(withdrawnableAmount >= _amount, "withdraw: not good");
1583 
1584         massUpdatePools();
1585         updateAndPayOutPending(_pid, from); // Update balances of from this is not withdrawal but claiming PIS farmed
1586 
1587         if (_amount > 0) {
1588             user.amount = user.amount.sub(_amount);
1589 
1590             pool.token.safeTransfer(address(to), _amount);
1591         }
1592         user.rewardDebt = user.amount.mul(pool.accPISPerShare).div(1e18);
1593 
1594         emit Withdraw(to, _pid, _amount);
1595     }
1596 
1597     function updateAndPayOutPending(uint256 _pid, address from) internal {
1598         UserInfo storage user = userInfo[_pid][from];
1599         if (user.releaseTime == 0) {
1600             user.releaseTime = block.timestamp.add(REWARD_LOCKED_PERIOD);
1601         }
1602         if (block.timestamp > user.releaseTime) {
1603             //compute withdrawnable amount
1604             uint256 lockedAmount = user.rewardLocked;
1605             user.rewardLocked = 0;
1606             safePISTransfer(from, lockedAmount);
1607             user.releaseTime = block.timestamp.add(REWARD_LOCKED_PERIOD);
1608         }
1609 
1610         uint256 pending = pendingPIS(_pid, from);
1611         uint256 paid = pending.mul(REWARD_RELEASE_PERCENTAGE).div(100);
1612         uint256 _lockedReward = pending.sub(paid);
1613         if (_lockedReward > 0) {
1614             user.rewardLocked = user.rewardLocked.add(_lockedReward);
1615         }
1616 
1617         if (paid > 0) {
1618             safePISTransfer(from, paid);
1619         }
1620     }
1621 
1622     function emergencyWithdraw(uint256 _pid) public {
1623         PoolInfo storage pool = poolInfo[_pid];
1624         require(
1625             pool.emergencyWithdrawable,
1626             "Withdrawing from this pool is disabled"
1627         );
1628         UserInfo storage user = userInfo[_pid][msg.sender];
1629         pool.token.safeTransfer(address(msg.sender), user.amount);
1630         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1631         user.amount = 0;
1632         user.rewardDebt = 0;
1633     }
1634 
1635     function safePISTransfer(address _to, uint256 _amount) internal {
1636         uint256 pisBal = pis.balanceOf(address(this));
1637 
1638         if (_amount > pisBal) {
1639             pis.transfer(_to, pisBal);
1640             pisBalance = pis.balanceOf(address(this));
1641         } else {
1642             pis.transfer(_to, _amount);
1643             pisBalance = pis.balanceOf(address(this));
1644         }
1645         transferDevFee();
1646     }
1647 
1648     function transferDevFee() public {
1649         if (pending_DEV_rewards == 0) return;
1650 
1651         uint256 pisBal = pis.balanceOf(address(this));
1652         if (pending_DEV_rewards > pisBal) {
1653             pis.transfer(devaddr, pisBal);
1654             pisBalance = pis.balanceOf(address(this));
1655         } else {
1656             pis.transfer(devaddr, pending_DEV_rewards);
1657             pisBalance = pis.balanceOf(address(this));
1658         }
1659 
1660         pending_DEV_rewards = 0;
1661     }
1662 
1663     function setDevFeeReciever(address _devaddr) public {
1664         require(devaddr == msg.sender, "only dev can change");
1665         devaddr = _devaddr;
1666     }
1667 
1668     function getLiquidityInfo(uint256 _pid)
1669         public
1670         view
1671         returns (
1672             uint256 lpSupply,
1673             uint256 pisAmount,
1674             uint256 totalPISAmount,
1675             uint256 tokenAmount,
1676             uint256 totalTokenAmount,
1677             uint256 lockedLP,
1678             uint256 totalLockedLP
1679         )
1680     {
1681         IERC20 lpToken = poolInfo[_pid].token;
1682         IERC20 pisToken = IERC20(address(pis));
1683         IUniswapV2Pair pair = IUniswapV2Pair(address(lpToken));
1684         address otherTokenAddress = (pair.token0() == address(pis))
1685             ? pair.token1()
1686             : pair.token0();
1687         IERC20 otherToken = IERC20(otherTokenAddress);
1688 
1689         lpSupply = lpToken.totalSupply();
1690         if (lpSupply > 0) {
1691             uint256 lpPISBalance = pisToken.balanceOf(address(lpToken));
1692             uint256 lpOtherBalance = otherToken.balanceOf(address(lpToken));
1693 
1694             lockedLP = lpToken.balanceOf(address(this));
1695 
1696             totalLockedLP = lockedLP;
1697 
1698             pisAmount = lockedLP.mul(lpPISBalance).div(lpSupply);
1699             totalPISAmount = totalLockedLP.mul(lpPISBalance).div(lpSupply);
1700 
1701             tokenAmount = lockedLP.mul(lpOtherBalance).div(lpSupply);
1702             totalTokenAmount = totalLockedLP.mul(lpOtherBalance).div(lpSupply);
1703         }
1704     }
1705 }