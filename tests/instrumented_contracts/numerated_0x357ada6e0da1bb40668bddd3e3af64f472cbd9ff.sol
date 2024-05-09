1 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^ 0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns(uint256);
13 
14 /**
15  * @dev Returns the amount of tokens owned by `account`.
16  */
17 function balanceOf(address account) external view returns(uint256);
18 
19 /**
20  * @dev Moves `amount` tokens from the caller's account to `recipient`.
21  *
22  * Returns a boolean value indicating whether the operation succeeded.
23  *
24  * Emits a {Transfer} event.
25  */
26 function transfer(address recipient, uint256 amount) external returns(bool);
27 
28 /**
29  * @dev Returns the remaining number of tokens that `spender` will be
30  * allowed to spend on behalf of `owner` through {transferFrom}. This is
31  * zero by default.
32  *
33  * This value changes when {approve} or {transferFrom} are called.
34  */
35 function allowance(address owner, address spender) external view returns(uint256);
36 
37 /**
38  * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39  *
40  * Returns a boolean value indicating whether the operation succeeded.
41  *
42  * IMPORTANT: Beware that changing an allowance with this method brings the risk
43  * that someone may use both the old and the new allowance by unfortunate
44  * transaction ordering. One possible solution to mitigate this race
45  * condition is to first reduce the spender's allowance to 0 and set the
46  * desired value afterwards:
47  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48  *
49  * Emits an {Approval} event.
50  */
51 function approve(address spender, uint256 amount) external returns(bool);
52 
53 /**
54  * @dev Moves `amount` tokens from `sender` to `recipient` using the
55  * allowance mechanism. `amount` is then deducted from the caller's
56  * allowance.
57  *
58  * Returns a boolean value indicating whether the operation succeeded.
59  *
60  * Emits a {Transfer} event.
61  */
62 function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
63 
64 /**
65  * @dev Emitted when `value` tokens are moved from one account (`from`) to
66  * another (`to`).
67  *
68  * Note that `value` may be zero.
69  */
70 event Transfer(address indexed from, address indexed to, uint256 value);
71 
72 /**
73  * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74  * a call to {approve}. `value` is the new allowance.
75  */
76 event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol
80 
81 pragma solidity ^ 0.6.0;
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
106     function add(uint256 a, uint256 b) internal pure returns(uint256) {
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
122     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
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
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
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
151     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
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
176     function div(uint256 a, uint256 b) internal pure returns(uint256) {
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
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
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
211     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
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
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol
233 
234 pragma solidity ^ 0.6.2;
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
257     function isContract(address account) internal view returns(bool) {
258         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
259         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
260         // for accounts without code, i.e. `keccak256('')`
261         bytes32 codehash;
262         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
263         // solhint-disable-next-line no-inline-assembly
264         assembly { codehash:= extcodehash(account) }
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
288         (bool success, ) = recipient.call{ value: amount } ("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 }
292 
293 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol
294 
295 pragma solidity ^ 0.6.0;
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
311         using Address for address;
312 
313             function safeTransfer(IERC20 token, address to, uint256 value) internal {
314             _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
315         }
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
372 pragma solidity ^ 0.6.0;
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
414         mapping(bytes32 => uint256) _indexes;
415     }
416 
417     /**
418      * @dev Add a value to a set. O(1).
419      *
420      * Returns true if the value was added to the set, that is if it was not
421      * already present.
422      */
423     function _add(Set storage set, bytes32 value) private returns(bool) {
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
441     function _remove(Set storage set, bytes32 value) private returns(bool) {
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
478     function _contains(Set storage set, bytes32 value) private view returns(bool) {
479         return set._indexes[value] != 0;
480     }
481 
482     /**
483      * @dev Returns the number of values on the set. O(1).
484      */
485     function _length(Set storage set) private view returns(uint256) {
486         return set._values.length;
487     }
488 
489     /**
490      * @dev Returns the value stored at position `index` in the set. O(1).
491      *
492      * Note that there are no guarantees on the ordering of values inside the
493      * array, and it may change when more values are added or removed.
494      *
495      * Requirements:
496      *
497      * - `index` must be strictly less than {length}.
498      */
499     function _at(Set storage set, uint256 index) private view returns(bytes32) {
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
516     function add(AddressSet storage set, address value) internal returns(bool) {
517         return _add(set._inner, bytes32(uint256(value)));
518     }
519 
520     /**
521      * @dev Removes a value from a set. O(1).
522      *
523      * Returns true if the value was removed from the set, that is if it was
524      * present.
525      */
526     function remove(AddressSet storage set, address value) internal returns(bool) {
527         return _remove(set._inner, bytes32(uint256(value)));
528     }
529 
530     /**
531      * @dev Returns true if the value is in the set. O(1).
532      */
533     function contains(AddressSet storage set, address value) internal view returns(bool) {
534         return _contains(set._inner, bytes32(uint256(value)));
535     }
536 
537     /**
538      * @dev Returns the number of values in the set. O(1).
539      */
540     function length(AddressSet storage set) internal view returns(uint256) {
541         return _length(set._inner);
542     }
543 
544     /**
545      * @dev Returns the value stored at position `index` in the set. O(1).
546      *
547      * Note that there are no guarantees on the ordering of values inside the
548      * array, and it may change when more values are added or removed.
549      *
550      * Requirements:
551      *
552      * - `index` must be strictly less than {length}.
553      */
554     function at(AddressSet storage set, uint256 index) internal view returns(address) {
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
571     function add(UintSet storage set, uint256 value) internal returns(bool) {
572         return _add(set._inner, bytes32(value));
573     }
574 
575     /**
576      * @dev Removes a value from a set. O(1).
577      *
578      * Returns true if the value was removed from the set, that is if it was
579      * present.
580      */
581     function remove(UintSet storage set, uint256 value) internal returns(bool) {
582         return _remove(set._inner, bytes32(value));
583     }
584 
585     /**
586      * @dev Returns true if the value is in the set. O(1).
587      */
588     function contains(UintSet storage set, uint256 value) internal view returns(bool) {
589         return _contains(set._inner, bytes32(value));
590     }
591 
592     /**
593      * @dev Returns the number of values on the set. O(1).
594      */
595     function length(UintSet storage set) internal view returns(uint256) {
596         return _length(set._inner);
597     }
598 
599     /**
600      * @dev Returns the value stored at position `index` in the set. O(1).
601      *
602      * Note that there are no guarantees on the ordering of values inside the
603      * array, and it may change when more values are added or removed.
604      *
605      * Requirements:
606      *
607      * - `index` must be strictly less than {length}.
608      */
609     function at(UintSet storage set, uint256 index) internal view returns(uint256) {
610         return uint256(_at(set._inner, index));
611     }
612 }
613 
614 // File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol
615 
616 pragma solidity >= 0.4.24 < 0.7.0;
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
633     /**
634      * @dev Indicates that the contract has been initialized.
635      */
636     bool private initialized;
637 
638     /**
639      * @dev Indicates that the contract is in the process of being initialized.
640      */
641     bool private initializing;
642 
643     /**
644      * @dev Modifier to use in the initializer function of a contract.
645      */
646     modifier initializer() {
647         require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
648 
649         bool isTopLevelCall = !initializing;
650         if (isTopLevelCall) {
651             initializing = true;
652             initialized = true;
653         }
654 
655         _;
656 
657         if (isTopLevelCall) {
658             initializing = false;
659         }
660     }
661 
662     /// @dev Returns true if and only if the function is running in the constructor
663     function isConstructor() private view returns(bool) {
664         // extcodesize checks the size of the code stored in an address, and
665         // address returns the current address. Since the code is still not
666         // deployed when running a constructor, any checks on its code size will
667         // yield zero, making it an effective way to detect if a contract is
668         // under construction or not.
669         address self = address(this);
670         uint256 cs;
671         assembly { cs:= extcodesize(self) }
672         return cs == 0;
673     }
674 
675     // Reserved storage space to allow for layout changes in the future.
676     uint256[50] private ______gap;
677 }
678 
679 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol
680 
681 pragma solidity ^ 0.6.0;
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
708     function _msgSender() internal view virtual returns(address payable) {
709         return msg.sender;
710     }
711 
712     function _msgData() internal view virtual returns(bytes memory) {
713         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
714         return msg.data;
715     }
716 
717     uint256[50] private __gap;
718 }
719 
720 // File: @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol
721 
722 pragma solidity ^ 0.6.0;
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
764     function owner() public view returns(address) {
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
813     function totalSupply() external view returns(uint256);
814 
815 /**
816  * @dev Returns the amount of tokens owned by `account`.
817  */
818 function balanceOf(address account) external view returns(uint256);
819 
820 /**
821  * @dev Moves `amount` tokens from the caller's account to `recipient`.
822  *
823  * Returns a boolean value indicating whether the operation succeeded.
824  *
825  * Emits a {Transfer} event.
826  */
827 function transfer(address recipient, uint256 amount)
828 external
829 returns(bool);
830 
831 /**
832  * @dev Returns the remaining number of tokens that `spender` will be
833  * allowed to spend on behalf of `owner` through {transferFrom}. This is
834  * zero by default.
835  *
836  * This value changes when {approve} or {transferFrom} are called.
837  */
838 function allowance(address owner, address spender)
839 external
840 view
841 returns(uint256);
842 
843 /**
844  * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
845  *
846  * Returns a boolean value indicating whether the operation succeeded.
847  *
848  * IMPORTANT: Beware that changing an allowance with this method brings the risk
849  * that someone may use both the old and the new allowance by unfortunate
850  * transaction ordering. One possible solution to mitigate this race
851  * condition is to first reduce the spender's allowance to 0 and set the
852  * desired value afterwards:
853  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
854  *
855  * Emits an {Approval} event.
856  */
857 function approve(address spender, uint256 amount) external returns(bool);
858 
859 /**
860  * @dev Moves `amount` tokens from `sender` to `recipient` using the
861  * allowance mechanism. `amount` is then deducted from the caller's
862  * allowance.
863  *
864  * Returns a boolean value indicating whether the operation succeeded.
865  *
866  * Emits a {Transfer} event.
867  */
868 function transferFrom(
869     address sender,
870     address recipient,
871     uint256 amount
872 ) external returns(bool);
873 
874 /**
875  * @dev Emitted when `value` tokens are moved from one account (`from`) to
876  * another (`to`).
877  *
878  * Note that `value` may be zero.
879  */
880 event Transfer(address indexed from, address indexed to, uint256 value);
881 
882 /**
883  * @dev Emitted when the allowance of a `spender` for an `owner` is set by
884  * a call to {approve}. `value` is the new allowance.
885  */
886 event Approval(
887     address indexed owner,
888     address indexed spender,
889     uint256 value
890 );
891 
892 event Log(string log);
893 }
894 
895 interface INerdBaseTokenLGE is INerdBaseToken {
896     function getAllocatedLP(address _user) external view returns(uint256);
897 
898     function getLpReleaseStart() external view returns(uint256);
899 
900     function getTokenUniswapPair() external view returns(address);
901 
902     function getTotalLPTokensMinted() external view returns(uint256);
903 
904     function getReleasableLPTokensMinted() external view returns(uint256);
905 
906     function isLPGenerationCompleted() external view returns(bool);
907 
908     function tokenUniswapPair() external view returns(address);
909 
910     function getUniswapRouterV2() external view returns(address);
911 
912     function getUniswapFactory() external view returns(address);
913 
914     function devFundAddress() external view returns(address);
915 
916     function transferCheckerAddress() external view returns(address);
917 
918     function feeDistributor() external view returns(address);
919 }
920 
921 // File: contracts/IFeeApprover.sol
922 
923 
924 pragma solidity 0.6.12;
925 
926 interface IFeeApprover {
927     function check(
928     address sender,
929     address recipient,
930     uint256 amount
931 ) external returns(bool);
932 
933 function setFeeMultiplier(uint256 _feeMultiplier) external;
934 
935 function feePercentX100() external view returns(uint256);
936 
937 function setTokenUniswapPair(address _tokenUniswapPair) external;
938 
939 function setNerdTokenAddress(address _nerdTokenAddress) external;
940 
941 function updateTxState() external;
942 
943 function calculateAmountsAfterFee(
944     address sender,
945     address recipient,
946     uint256 amount
947 )
948 external
949 returns(uint256 transferToAmount, uint256 transferToFeeBearerAmount);
950 
951 function setPaused() external;
952 }
953 
954 // File: contracts/INoFeeSimple.sol
955 
956 pragma solidity 0.6.12;
957 
958 interface INoFeeSimple {
959     function noFeeList(address) external view returns(bool);
960 }
961 
962 // File: contracts/StakingPool.sol
963 
964 pragma solidity 0.6.12;
965 
966 
967 
968 
969 
970 
971 
972 
973 
974 // Nerd Vault distributes fees equally amongst staked pools
975 // Have fun reading it. Hopefully it's bug-free. God bless.
976 
977 contract TimeLockNerdPool {
978     using SafeMath for uint256;
979         using Address for address;
980 
981             uint256 public constant NERD_LOCKED_PERIOD_DAYS = 14; //10 weeks,
982     uint256 public constant NERD_RELEASE_TRUNK = 1 days; //releasable every week,
983 
984     // Info of each user.
985     struct UserInfo {
986         uint256 amount; // How many  tokens the user currently has.
987         uint256 referenceAmount; //this amount is used for computing releasable LP amount
988         uint256 rewardDebt; // Reward debt. See explanation below.
989         uint256 rewardLocked;
990         uint256 releaseTime;
991         //
992         // We do some fancy math here. Basically, any point in time, the amount of NERDs
993         // entitled to a user but is pending to be distributed is:
994         //
995         //   pending reward = (user.amount * pool.accNerdPerShare) - user.rewardDebt
996         //
997         // Whenever a user deposits or withdraws  tokens to a pool. Here's what happens:
998         //   1. The pool's `accNerdPerShare` (and `lastRewardBlock`) gets updated.
999         //   2. User receives the pending reward sent to his/her address.
1000         //   3. User's `amount` gets updated.
1001         //   4. User's `rewardDebt` gets updated.
1002 
1003         uint256 depositTime; //See explanation below.
1004         //this is a dynamic value. It changes every time user deposit to the pool
1005         //1. initial deposit X => deposit time is block time
1006         //2. deposit more at time deposit2 without amount Y =>
1007         //  => compute current releasable amount R
1008         //  => compute diffTime = R*lockedPeriod/(X + Y) => this is the duration users can unlock R with new deposit amount
1009         //  => updated depositTime = (blocktime - diffTime/2)
1010     }
1011 
1012     // Info of each pool.
1013     struct PoolInfo {
1014         uint256 accNerdPerShare; // Accumulated NERDs per share, times 1e18. See below.
1015         uint256 lockedPeriod; // liquidity locked period
1016         bool emergencyWithdrawable;
1017         uint256 rewardsInThisEpoch;
1018         uint256 cumulativeRewardsSinceStart;
1019         uint256 startBlock;
1020         // For easy graphing historical epoch rewards
1021         mapping(uint256 => uint256) epochRewards;
1022         uint256 epochCalculationStartBlock;
1023         uint256 totalDeposit;
1024     }
1025 
1026     // Info of each pool.
1027     PoolInfo public poolInfo;
1028     // Info of each user that stakes  tokens.
1029     mapping(address => UserInfo) public userInfo;
1030 
1031     // The NERD TOKEN!
1032     INerdBaseTokenLGE public nerd = INerdBaseTokenLGE(
1033         0x32C868F6318D6334B2250F323D914Bc2239E4EeE
1034     );
1035     address public nerdAddress;
1036 
1037     function getNerdReleaseStart(address _user) public view returns(uint256) {
1038         return userInfo[_user].depositTime;
1039     }
1040 
1041     function getRemainingNerd(address _user) public view returns(uint256) {
1042         return userInfo[_user].amount;
1043     }
1044 
1045     function getReferenceAmount(address _user) public view returns(uint256) {
1046         return userInfo[_user].referenceAmount;
1047     }
1048 
1049     function computeReleasableNerd(address _addr)
1050     public
1051     view
1052     returns(uint256)
1053     {
1054         uint256 nerdReleaseStart = getNerdReleaseStart(_addr);
1055         if (block.timestamp < nerdReleaseStart) {
1056             return 0;
1057         }
1058 
1059         uint256 amountNerd = getReferenceAmount(_addr);
1060         if (amountNerd == 0) return 0;
1061 
1062         uint256 totalReleasableTilNow = 0;
1063 
1064         if (block.timestamp > nerdReleaseStart.add(poolInfo.lockedPeriod)) {
1065             totalReleasableTilNow = amountNerd;
1066         } else {
1067             uint256 daysTilNow = daysSinceNerdReleaseTilNow(_addr);
1068 
1069             totalReleasableTilNow = daysTilNow
1070                 .mul(NERD_RELEASE_TRUNK)
1071                 .mul(amountNerd)
1072                 .div(poolInfo.lockedPeriod);
1073         }
1074         if (totalReleasableTilNow > amountNerd) {
1075             totalReleasableTilNow = amountNerd;
1076         }
1077         uint256 alreadyReleased = amountNerd.sub(getRemainingNerd(_addr));
1078         if (totalReleasableTilNow > alreadyReleased) {
1079             return totalReleasableTilNow.sub(alreadyReleased);
1080         }
1081         return 0;
1082     }
1083 
1084     function daysSinceNerdReleaseTilNow(address _addr)
1085     public
1086     view
1087     returns(uint256)
1088     {
1089         uint256 nerdReleaseStart = getNerdReleaseStart(_addr);
1090         if (nerdReleaseStart == 0 || block.timestamp < nerdReleaseStart)
1091             return 0;
1092         uint256 timeTillNow = block.timestamp.sub(nerdReleaseStart);
1093         uint256 daysTilNow = timeTillNow.div(NERD_RELEASE_TRUNK);
1094         daysTilNow = daysTilNow.add(1);
1095         return daysTilNow;
1096     }
1097 }
1098 
1099 contract StakingPool is OwnableUpgradeSafe, TimeLockNerdPool {
1100     using SafeMath for uint256;
1101         using SafeERC20 for IERC20;
1102 
1103             // Dev address.
1104             address public devaddr;
1105     address public tentativeDevAddress;
1106 
1107     //// pending rewards awaiting anyone to massUpdate
1108     uint256 public pendingRewards;
1109 
1110     uint256 public epoch;
1111 
1112     uint256 public constant REWARD_LOCKED_PERIOD = 28 days;
1113     uint256 public constant REWARD_RELEASE_PERCENTAGE = 50;
1114     uint256 public contractStartBlock;
1115 
1116     // Sets the dev fee for this contract
1117     // defaults at 7.24%
1118     // Note contract owner is meant to be a governance contract allowing NERD governance consensus
1119     uint16 DEV_FEE;
1120 
1121     uint256 public pending_DEV_rewards;
1122     uint256 public nerdBalance;
1123     uint256 public pendingDeposit;
1124 
1125     // Returns fees generated since start of this contract
1126     function averageFeesPerBlockSinceStart()
1127     external
1128     view
1129     returns(uint256 averagePerBlock)
1130     {
1131         averagePerBlock = poolInfo
1132             .cumulativeRewardsSinceStart
1133             .add(poolInfo.rewardsInThisEpoch)
1134             .add(pendingNerdForPool())
1135             .div(block.number.sub(poolInfo.startBlock));
1136     }
1137 
1138     // Returns averge fees in this epoch
1139     function averageFeesPerBlockEpoch()
1140     external
1141     view
1142     returns(uint256 averagePerBlock)
1143     {
1144         averagePerBlock = poolInfo
1145             .rewardsInThisEpoch
1146             .add(pendingNerdForPool())
1147             .div(block.number.sub(poolInfo.epochCalculationStartBlock));
1148     }
1149 
1150     function getEpochReward(uint256 _epoch) public view returns(uint256) {
1151         return poolInfo.epochRewards[_epoch];
1152     }
1153 
1154     function nerdDeposit() public view returns(uint256) {
1155         return poolInfo.totalDeposit.add(pendingDeposit);
1156     }
1157 
1158     //Starts a new calculation epoch
1159     // Because averge since start will not be accurate
1160     function startNewEpoch() public {
1161         require(
1162             poolInfo.epochCalculationStartBlock + 50000 < block.number,
1163             "New epoch not ready yet"
1164         ); // About a week
1165         poolInfo.epochRewards[epoch] = poolInfo.rewardsInThisEpoch;
1166         poolInfo.cumulativeRewardsSinceStart = poolInfo
1167             .cumulativeRewardsSinceStart
1168             .add(poolInfo.rewardsInThisEpoch);
1169         poolInfo.rewardsInThisEpoch = 0;
1170         poolInfo.epochCalculationStartBlock = block.number;
1171         ++epoch;
1172     }
1173 
1174     event Deposit(address indexed user, uint256 amount);
1175     event Restake(address indexed user, uint256 amount);
1176     event Withdraw(address indexed user, uint256 amount);
1177     event EmergencyWithdraw(address indexed user, uint256 amount);
1178     event Approval(
1179         address indexed owner,
1180         address indexed spender,
1181         uint256 value
1182     );
1183 
1184     function initialize() public initializer {
1185         OwnableUpgradeSafe.__Ownable_init();
1186         nerd = INerdBaseTokenLGE(0x32C868F6318D6334B2250F323D914Bc2239E4EeE);
1187         require(
1188             INoFeeSimple(nerd.transferCheckerAddress()).noFeeList(
1189                 address(this)
1190             ),
1191             "!Staking pool should not have fee"
1192         );
1193         poolInfo.lockedPeriod = NERD_LOCKED_PERIOD_DAYS.mul(NERD_RELEASE_TRUNK);
1194         DEV_FEE = 724;
1195         devaddr = nerd.devFundAddress();
1196         tentativeDevAddress = address(0);
1197         contractStartBlock = block.number;
1198 
1199         poolInfo.emergencyWithdrawable = false;
1200         poolInfo.accNerdPerShare = 0;
1201         poolInfo.rewardsInThisEpoch = 0;
1202         poolInfo.cumulativeRewardsSinceStart = 0;
1203         poolInfo.startBlock = block.number;
1204         poolInfo.epochCalculationStartBlock = block.number;
1205         poolInfo.totalDeposit = 0;
1206     }
1207 
1208     function isMultipleOfWeek(uint256 _period) public pure returns(bool) {
1209         uint256 numWeeks = _period.div(NERD_RELEASE_TRUNK);
1210         return (_period == numWeeks.mul(NERD_RELEASE_TRUNK));
1211     }
1212 
1213     function getDepositTime(address _addr) public view returns(uint256) {
1214         return userInfo[_addr].depositTime;
1215     }
1216 
1217     function setEmergencyWithdrawable(bool _withdrawable) public onlyOwner {
1218         poolInfo.emergencyWithdrawable = _withdrawable;
1219     }
1220 
1221     function setDevFee(uint16 _DEV_FEE) public onlyOwner {
1222         require(_DEV_FEE <= 1000, "Dev fee clamped at 10%");
1223         DEV_FEE = _DEV_FEE;
1224     }
1225 
1226     function pendingNerdForPool() public view returns(uint256) {
1227         uint256 tokenSupply = poolInfo.totalDeposit;
1228 
1229         if (tokenSupply == 0) return 0;
1230 
1231         uint256 nerdRewardWhole = pendingRewards;
1232         uint256 nerdRewardFee = nerdRewardWhole.mul(DEV_FEE).div(10000);
1233         return nerdRewardWhole.sub(nerdRewardFee);
1234     }
1235 
1236     function computeDepositAmount(
1237         address _sender,
1238         address _recipient,
1239         uint256 _amount
1240     ) internal returns(uint256) {
1241         (uint256 _receiveAmount, ) = IFeeApprover(nerd.transferCheckerAddress())
1242             .calculateAmountsAfterFee(_sender, _recipient, _amount);
1243         return _receiveAmount;
1244     }
1245 
1246     // View function to see pending NERDs on frontend.
1247     function pendingNerd(address _user) public view returns(uint256) {
1248         UserInfo storage user = userInfo[_user];
1249         uint256 accNerdPerShare = poolInfo.accNerdPerShare;
1250         uint256 amount = user.amount;
1251 
1252         uint256 tokenSupply = poolInfo.totalDeposit;
1253 
1254         if (tokenSupply == 0) return 0;
1255 
1256         uint256 nerdRewardFee = pendingRewards.mul(DEV_FEE).div(10000);
1257         uint256 nerdRewardToDistribute = pendingRewards.sub(nerdRewardFee);
1258         uint256 inc = nerdRewardToDistribute.mul(1e18).div(tokenSupply);
1259         accNerdPerShare = accNerdPerShare.add(inc);
1260 
1261         return amount.mul(accNerdPerShare).div(1e18).sub(user.rewardDebt);
1262     }
1263 
1264     function getLockedReward(address _user) public view returns(uint256) {
1265         return userInfo[_user].rewardLocked;
1266     }
1267 
1268     // Update reward vairables for all pools. Be careful of gas spending!
1269     function massUpdatePools() public {
1270         uint256 allRewards = updatePool();
1271         pendingRewards = pendingRewards.sub(allRewards);
1272     }
1273 
1274     // ----
1275     // Function that adds pending rewards, called by the NERD token.
1276     // ----
1277     function updatePendingRewards() public {
1278         uint256 newRewards = nerd.balanceOf(address(this)).sub(nerdBalance).sub(
1279             nerdDeposit()
1280         );
1281 
1282         if (newRewards > 0) {
1283             nerdBalance = nerd.balanceOf(address(this)).sub(nerdDeposit()); // If there is no change the balance didn't change
1284             pendingRewards = pendingRewards.add(newRewards);
1285         }
1286     }
1287 
1288     // Update reward variables of the given pool to be up-to-date.
1289     function updatePool() internal returns(uint256 nerdRewardWhole) {
1290         uint256 tokenSupply = poolInfo.totalDeposit;
1291         if (tokenSupply == 0) {
1292             // avoids division by 0 errors
1293             return 0;
1294         }
1295         nerdRewardWhole = pendingRewards;
1296 
1297         uint256 nerdRewardFee = nerdRewardWhole.mul(DEV_FEE).div(10000);
1298         uint256 nerdRewardToDistribute = nerdRewardWhole.sub(nerdRewardFee);
1299 
1300         uint256 inc = nerdRewardToDistribute.mul(1e18).div(tokenSupply);
1301         pending_DEV_rewards = pending_DEV_rewards.add(nerdRewardFee);
1302 
1303         poolInfo.accNerdPerShare = poolInfo.accNerdPerShare.add(inc);
1304         poolInfo.rewardsInThisEpoch = poolInfo.rewardsInThisEpoch.add(
1305             nerdRewardToDistribute
1306         );
1307     }
1308 
1309     function withdrawNerd() public {
1310         withdraw(0);
1311     }
1312 
1313     function claimAndRestake() public {
1314         UserInfo storage user = userInfo[msg.sender];
1315         require(user.amount > 0);
1316         massUpdatePools();
1317 
1318         if (user.releaseTime == 0) {
1319             user.releaseTime = block.timestamp.add(REWARD_LOCKED_PERIOD);
1320         }
1321         uint256 _rewards = 0;
1322         if (block.timestamp > user.releaseTime) {
1323             //compute withdrawnable amount
1324             uint256 lockedAmount = user.rewardLocked;
1325             user.rewardLocked = 0;
1326             user.releaseTime = block.timestamp.add(REWARD_LOCKED_PERIOD);
1327             _rewards = _rewards.add(lockedAmount);
1328         }
1329 
1330         uint256 pending = pendingNerd(msg.sender);
1331         uint256 paid = pending.mul(REWARD_RELEASE_PERCENTAGE).div(100);
1332         uint256 _lockedReward = pending.sub(paid);
1333         if (_lockedReward > 0) {
1334             user.rewardLocked = user.rewardLocked.add(_lockedReward);
1335         }
1336 
1337         _rewards = _rewards.add(paid);
1338 
1339         uint256 lockedPeriod = poolInfo.lockedPeriod;
1340         uint256 tobeReleased = computeReleasableNerd(msg.sender);
1341         uint256 amountAfterDeposit = user.amount.add(_rewards);
1342         uint256 diffTime = tobeReleased.mul(lockedPeriod).div(
1343             amountAfterDeposit
1344         );
1345         user.depositTime = block.timestamp.sub(diffTime.div(2));
1346         //reset referenceAmount to start a new lock-release period
1347         user.referenceAmount = amountAfterDeposit;
1348 
1349         user.amount = user.amount.add(_rewards);
1350         user.rewardDebt = user.amount.mul(poolInfo.accNerdPerShare).div(1e18);
1351         poolInfo.totalDeposit = poolInfo.totalDeposit.add(_rewards);
1352         emit Restake(msg.sender, _rewards);
1353     }
1354 
1355     // Deposit  tokens to NerdVault for NERD allocation.
1356     function deposit(uint256 _originAmount) public {
1357         UserInfo storage user = userInfo[msg.sender];
1358 
1359         massUpdatePools();
1360 
1361         // Transfer pending tokens
1362         // to user
1363         updateAndPayOutPending(msg.sender);
1364 
1365         pendingDeposit = computeDepositAmount(
1366             msg.sender,
1367             address(this),
1368             _originAmount
1369         );
1370         uint256 _actualDepositReceive = pendingDeposit;
1371         //Transfer in the amounts from user
1372         // save gas
1373         if (_actualDepositReceive > 0) {
1374             nerd.transferFrom(
1375                 address(msg.sender),
1376                 address(this),
1377                 _originAmount
1378             );
1379             pendingDeposit = 0;
1380             updateDepositTime(msg.sender, _actualDepositReceive);
1381             user.amount = user.amount.add(_actualDepositReceive);
1382         }
1383         //massUpdatePools();
1384         user.rewardDebt = user.amount.mul(poolInfo.accNerdPerShare).div(1e18);
1385         poolInfo.totalDeposit = poolInfo.totalDeposit.add(
1386             _actualDepositReceive
1387         );
1388         emit Deposit(msg.sender, _actualDepositReceive);
1389     }
1390 
1391     function updateDepositTime(address _addr, uint256 _depositAmount) internal {
1392         UserInfo storage user = userInfo[_addr];
1393         if (user.amount == 0) {
1394             user.depositTime = block.timestamp;
1395             user.referenceAmount = _depositAmount;
1396         } else {
1397             uint256 lockedPeriod = poolInfo.lockedPeriod;
1398             uint256 tobeReleased = computeReleasableNerd(_addr);
1399             uint256 amountAfterDeposit = user.amount.add(_depositAmount);
1400             uint256 diffTime = tobeReleased.mul(lockedPeriod).div(
1401                 amountAfterDeposit
1402             );
1403             user.depositTime = block.timestamp.sub(diffTime.div(2));
1404             //reset referenceAmount to start a new lock-release period
1405             user.referenceAmount = amountAfterDeposit;
1406         }
1407     }
1408 
1409     // Test coverage
1410     // [x] Does user get the deposited amounts?
1411     // [x] Does user that its deposited for update correcty?
1412     // [x] Does the depositor get their tokens decreased
1413     function depositFor(address _depositFor, uint256 _originAmount) public {
1414         // requires no allowances
1415         UserInfo storage user = userInfo[_depositFor];
1416 
1417         massUpdatePools();
1418 
1419         // Transfer pending tokens
1420         // to user
1421         updateAndPayOutPending(_depositFor); // Update the balances of person that amount is being deposited for
1422 
1423         pendingDeposit = computeDepositAmount(
1424             msg.sender,
1425             address(this),
1426             _originAmount
1427         );
1428         uint256 _actualDepositReceive = pendingDeposit;
1429         if (_actualDepositReceive > 0) {
1430             nerd.transferFrom(
1431                 address(msg.sender),
1432                 address(this),
1433                 _originAmount
1434             );
1435             pendingDeposit = 0;
1436             updateDepositTime(_depositFor, _actualDepositReceive);
1437             user.amount = user.amount.add(_actualDepositReceive); // This is depositedFor address
1438         }
1439 
1440         user.rewardDebt = user.amount.mul(poolInfo.accNerdPerShare).div(1e18); /// This is deposited for address
1441         poolInfo.totalDeposit = poolInfo.totalDeposit.add(
1442             _actualDepositReceive
1443         );
1444         emit Deposit(_depositFor, _actualDepositReceive);
1445     }
1446 
1447     function quitPool() public {
1448         require(
1449             block.timestamp > getNerdReleaseStart(msg.sender),
1450             "cannot withdraw all lp tokens before"
1451         );
1452 
1453         uint256 withdrawnableAmount = computeReleasableNerd(msg.sender);
1454         withdraw(withdrawnableAmount);
1455     }
1456 
1457     // Withdraw  tokens from NerdVault.
1458     function withdraw(uint256 _amount) public {
1459         _withdraw(_amount, msg.sender, msg.sender);
1460     }
1461 
1462     // Low level withdraw function
1463     function _withdraw(
1464         uint256 _amount,
1465         address from,
1466         address to
1467     ) internal {
1468         //require(pool.withdrawable, "Withdrawing from this pool is disabled");
1469         UserInfo storage user = userInfo[from];
1470         require(computeReleasableNerd(from) >= _amount, "withdraw: not good");
1471 
1472         massUpdatePools();
1473         updateAndPayOutPending(from); // Update balances of from this is not withdrawal but claiming NERD farmed
1474 
1475         if (_amount > 0) {
1476             user.amount = user.amount.sub(_amount);
1477             poolInfo.totalDeposit = poolInfo.totalDeposit.sub(_amount);
1478             safeNerdTransfer(address(to), _amount);
1479         }
1480         user.rewardDebt = user.amount.mul(poolInfo.accNerdPerShare).div(1e18);
1481 
1482         emit Withdraw(to, _amount);
1483     }
1484 
1485     function updateAndPayOutPending(address from) internal {
1486         UserInfo storage user = userInfo[from];
1487         if (user.releaseTime == 0) {
1488             user.releaseTime = block.timestamp.add(REWARD_LOCKED_PERIOD);
1489         }
1490         if (block.timestamp > user.releaseTime) {
1491             //compute withdrawnable amount
1492             uint256 lockedAmount = user.rewardLocked;
1493             user.rewardLocked = 0;
1494             safeNerdTransfer(from, lockedAmount);
1495             user.releaseTime = block.timestamp.add(REWARD_LOCKED_PERIOD);
1496         }
1497 
1498         uint256 pending = pendingNerd(from);
1499         uint256 paid = pending.mul(REWARD_RELEASE_PERCENTAGE).div(100);
1500         uint256 _lockedReward = pending.sub(paid);
1501         if (_lockedReward > 0) {
1502             user.rewardLocked = user.rewardLocked.add(_lockedReward);
1503         }
1504 
1505         if (paid > 0) {
1506             safeNerdTransfer(from, paid);
1507         }
1508     }
1509 
1510     function emergencyWithdraw() public {
1511         require(
1512             poolInfo.emergencyWithdrawable,
1513             "Withdrawing from this pool is disabled"
1514         );
1515         UserInfo storage user = userInfo[msg.sender];
1516         poolInfo.totalDeposit = poolInfo.totalDeposit.sub(user.amount);
1517         uint256 withdrawnAmount = user.amount;
1518         if (withdrawnAmount > nerd.balanceOf(address(this))) {
1519             withdrawnAmount = nerd.balanceOf(address(this));
1520         }
1521         safeNerdTransfer(address(msg.sender), withdrawnAmount);
1522         emit EmergencyWithdraw(msg.sender, withdrawnAmount);
1523         user.amount = 0;
1524         user.rewardDebt = 0;
1525     }
1526 
1527     function safeNerdTransfer(address _to, uint256 _amount) internal {
1528         uint256 nerdBal = nerd.balanceOf(address(this));
1529 
1530         if (_amount > nerdBal) {
1531             nerd.transfer(_to, nerdBal);
1532             nerdBalance = nerd.balanceOf(address(this)).sub(nerdDeposit());
1533         } else {
1534             nerd.transfer(_to, _amount);
1535             nerdBalance = nerd.balanceOf(address(this)).sub(nerdDeposit());
1536         }
1537         transferDevFee();
1538     }
1539 
1540     function transferDevFee() public {
1541         if (pending_DEV_rewards == 0) return;
1542 
1543         uint256 nerdBal = nerd.balanceOf(address(this));
1544         if (pending_DEV_rewards > nerdBal) {
1545             nerd.transfer(devaddr, nerdBal);
1546             nerdBalance = nerd.balanceOf(address(this)).sub(nerdDeposit());
1547         } else {
1548             nerd.transfer(devaddr, pending_DEV_rewards);
1549             nerdBalance = nerd.balanceOf(address(this)).sub(nerdDeposit());
1550         }
1551 
1552         pending_DEV_rewards = 0;
1553     }
1554 
1555     function setDevFeeReciever(address _devaddr) public onlyOwner {
1556         require(devaddr == msg.sender, "only dev can change");
1557         tentativeDevAddress = _devaddr;
1558     }
1559 
1560     function confirmDevAddress() public {
1561         require(tentativeDevAddress == msg.sender, "not tentativeDevAddress!");
1562         devaddr = tentativeDevAddress;
1563         tentativeDevAddress = address(0);
1564     }
1565 }