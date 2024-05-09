1 // SPDX-License-Identifier: MIT
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
79 
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
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 
240 pragma solidity ^0.6.2;
241 
242 /**
243  * @dev Collection of functions related to the address type
244  */
245 library Address {
246     /**
247      * @dev Returns true if `account` is a contract.
248      *
249      * [IMPORTANT]
250      * ====
251      * It is unsafe to assume that an address for which this function returns
252      * false is an externally-owned account (EOA) and not a contract.
253      *
254      * Among others, `isContract` will return false for the following
255      * types of addresses:
256      *
257      *  - an externally-owned account
258      *  - a contract in construction
259      *  - an address where a contract will be created
260      *  - an address where a contract lived, but was destroyed
261      * ====
262      */
263     function isContract(address account) internal view returns (bool) {
264         // This method relies in extcodesize, which returns 0 for contracts in
265         // construction, since the code is only stored at the end of the
266         // constructor execution.
267 
268         uint256 size;
269         // solhint-disable-next-line no-inline-assembly
270         assembly { size := extcodesize(account) }
271         return size > 0;
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
294         (bool success, ) = recipient.call{ value: amount }("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297 
298     /**
299      * @dev Performs a Solidity function call using a low level `call`. A
300      * plain`call` is an unsafe replacement for a function call: use this
301      * function instead.
302      *
303      * If `target` reverts with a revert reason, it is bubbled up by this
304      * function (like regular Solidity function calls).
305      *
306      * Returns the raw returned data. To convert to the expected return value,
307      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308      *
309      * Requirements:
310      *
311      * - `target` must be a contract.
312      * - calling `target` with `data` must not revert.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317       return functionCall(target, data, "Address: low-level call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322      * `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
327         return _functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         return _functionCallWithValue(target, data, value, errorMessage);
354     }
355 
356     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
357         require(isContract(target), "Address: call to non-contract");
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
361         if (success) {
362             return returndata;
363         } else {
364             // Look for revert reason and bubble it up if present
365             if (returndata.length > 0) {
366                 // The easiest way to bubble the revert reason is using memory via assembly
367 
368                 // solhint-disable-next-line no-inline-assembly
369                 assembly {
370                     let returndata_size := mload(returndata)
371                     revert(add(32, returndata), returndata_size)
372                 }
373             } else {
374                 revert(errorMessage);
375             }
376         }
377     }
378 }
379 
380 pragma solidity ^0.6.0;
381 
382 /**
383  * @title SafeERC20
384  * @dev Wrappers around ERC20 operations that throw on failure (when the token
385  * contract returns false). Tokens that return no value (and instead revert or
386  * throw on failure) are also supported, non-reverting calls are assumed to be
387  * successful.
388  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
389  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
390  */
391 library SafeERC20 {
392     using SafeMath for uint256;
393     using Address for address;
394 
395     function safeTransfer(IERC20 token, address to, uint256 value) internal {
396         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
397     }
398 
399     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
400         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
401     }
402 
403     /**
404      * @dev Deprecated. This function has issues similar to the ones found in
405      * {IERC20-approve}, and its usage is discouraged.
406      *
407      * Whenever possible, use {safeIncreaseAllowance} and
408      * {safeDecreaseAllowance} instead.
409      */
410     function safeApprove(IERC20 token, address spender, uint256 value) internal {
411         // safeApprove should only be called when setting an initial allowance,
412         // or when resetting it to zero. To increase and decrease it, use
413         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
414         // solhint-disable-next-line max-line-length
415         require((value == 0) || (token.allowance(address(this), spender) == 0),
416             "SafeERC20: approve from non-zero to non-zero allowance"
417         );
418         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
419     }
420 
421     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
422         uint256 newAllowance = token.allowance(address(this), spender).add(value);
423         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
424     }
425 
426     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
427         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
429     }
430 
431     /**
432      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
433      * on the return value: the return value is optional (but if data is returned, it must not be false).
434      * @param token The token targeted by the call.
435      * @param data The call data (encoded using abi.encode or one of its variants).
436      */
437     function _callOptionalReturn(IERC20 token, bytes memory data) private {
438         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
439         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
440         // the target address contains contract code and also asserts for success in the low-level call.
441 
442         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
443         if (returndata.length > 0) { // Return data is optional
444             // solhint-disable-next-line max-line-length
445             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
446         }
447     }
448 }
449 
450 
451 pragma solidity ^0.6.0;
452 
453 /**
454  * @dev Library for managing
455  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
456  * types.
457  *
458  * Sets have the following properties:
459  *
460  * - Elements are added, removed, and checked for existence in constant time
461  * (O(1)).
462  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
463  *
464  * ```
465  * contract Example {
466  *     // Add the library methods
467  *     using EnumerableSet for EnumerableSet.AddressSet;
468  *
469  *     // Declare a set state variable
470  *     EnumerableSet.AddressSet private mySet;
471  * }
472  * ```
473  *
474  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
475  * (`UintSet`) are supported.
476  */
477 library EnumerableSet {
478     // To implement this library for multiple types with as little code
479     // repetition as possible, we write it in terms of a generic Set type with
480     // bytes32 values.
481     // The Set implementation uses private functions, and user-facing
482     // implementations (such as AddressSet) are just wrappers around the
483     // underlying Set.
484     // This means that we can only create new EnumerableSets for types that fit
485     // in bytes32.
486 
487     struct Set {
488         // Storage of set values
489         bytes32[] _values;
490 
491         // Position of the value in the `values` array, plus 1 because index 0
492         // means a value is not in the set.
493         mapping (bytes32 => uint256) _indexes;
494     }
495 
496     /**
497      * @dev Add a value to a set. O(1).
498      *
499      * Returns true if the value was added to the set, that is if it was not
500      * already present.
501      */
502     function _add(Set storage set, bytes32 value) private returns (bool) {
503         if (!_contains(set, value)) {
504             set._values.push(value);
505             // The value is stored at length-1, but we add 1 to all indexes
506             // and use 0 as a sentinel value
507             set._indexes[value] = set._values.length;
508             return true;
509         } else {
510             return false;
511         }
512     }
513 
514     /**
515      * @dev Removes a value from a set. O(1).
516      *
517      * Returns true if the value was removed from the set, that is if it was
518      * present.
519      */
520     function _remove(Set storage set, bytes32 value) private returns (bool) {
521         // We read and store the value's index to prevent multiple reads from the same storage slot
522         uint256 valueIndex = set._indexes[value];
523 
524         if (valueIndex != 0) { // Equivalent to contains(set, value)
525             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
526             // the array, and then remove the last element (sometimes called as 'swap and pop').
527             // This modifies the order of the array, as noted in {at}.
528 
529             uint256 toDeleteIndex = valueIndex - 1;
530             uint256 lastIndex = set._values.length - 1;
531 
532             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
533             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
534 
535             bytes32 lastvalue = set._values[lastIndex];
536 
537             // Move the last value to the index where the value to delete is
538             set._values[toDeleteIndex] = lastvalue;
539             // Update the index for the moved value
540             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
541 
542             // Delete the slot where the moved value was stored
543             set._values.pop();
544 
545             // Delete the index for the deleted slot
546             delete set._indexes[value];
547 
548             return true;
549         } else {
550             return false;
551         }
552     }
553 
554     /**
555      * @dev Returns true if the value is in the set. O(1).
556      */
557     function _contains(Set storage set, bytes32 value) private view returns (bool) {
558         return set._indexes[value] != 0;
559     }
560 
561     /**
562      * @dev Returns the number of values on the set. O(1).
563      */
564     function _length(Set storage set) private view returns (uint256) {
565         return set._values.length;
566     }
567 
568    /**
569     * @dev Returns the value stored at position `index` in the set. O(1).
570     *
571     * Note that there are no guarantees on the ordering of values inside the
572     * array, and it may change when more values are added or removed.
573     *
574     * Requirements:
575     *
576     * - `index` must be strictly less than {length}.
577     */
578     function _at(Set storage set, uint256 index) private view returns (bytes32) {
579         require(set._values.length > index, "EnumerableSet: index out of bounds");
580         return set._values[index];
581     }
582 
583     // AddressSet
584 
585     struct AddressSet {
586         Set _inner;
587     }
588 
589     /**
590      * @dev Add a value to a set. O(1).
591      *
592      * Returns true if the value was added to the set, that is if it was not
593      * already present.
594      */
595     function add(AddressSet storage set, address value) internal returns (bool) {
596         return _add(set._inner, bytes32(uint256(value)));
597     }
598 
599     /**
600      * @dev Removes a value from a set. O(1).
601      *
602      * Returns true if the value was removed from the set, that is if it was
603      * present.
604      */
605     function remove(AddressSet storage set, address value) internal returns (bool) {
606         return _remove(set._inner, bytes32(uint256(value)));
607     }
608 
609     /**
610      * @dev Returns true if the value is in the set. O(1).
611      */
612     function contains(AddressSet storage set, address value) internal view returns (bool) {
613         return _contains(set._inner, bytes32(uint256(value)));
614     }
615 
616     /**
617      * @dev Returns the number of values in the set. O(1).
618      */
619     function length(AddressSet storage set) internal view returns (uint256) {
620         return _length(set._inner);
621     }
622 
623    /**
624     * @dev Returns the value stored at position `index` in the set. O(1).
625     *
626     * Note that there are no guarantees on the ordering of values inside the
627     * array, and it may change when more values are added or removed.
628     *
629     * Requirements:
630     *
631     * - `index` must be strictly less than {length}.
632     */
633     function at(AddressSet storage set, uint256 index) internal view returns (address) {
634         return address(uint256(_at(set._inner, index)));
635     }
636 
637 
638     // UintSet
639 
640     struct UintSet {
641         Set _inner;
642     }
643 
644     /**
645      * @dev Add a value to a set. O(1).
646      *
647      * Returns true if the value was added to the set, that is if it was not
648      * already present.
649      */
650     function add(UintSet storage set, uint256 value) internal returns (bool) {
651         return _add(set._inner, bytes32(value));
652     }
653 
654     /**
655      * @dev Removes a value from a set. O(1).
656      *
657      * Returns true if the value was removed from the set, that is if it was
658      * present.
659      */
660     function remove(UintSet storage set, uint256 value) internal returns (bool) {
661         return _remove(set._inner, bytes32(value));
662     }
663 
664     /**
665      * @dev Returns true if the value is in the set. O(1).
666      */
667     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
668         return _contains(set._inner, bytes32(value));
669     }
670 
671     /**
672      * @dev Returns the number of values on the set. O(1).
673      */
674     function length(UintSet storage set) internal view returns (uint256) {
675         return _length(set._inner);
676     }
677 
678    /**
679     * @dev Returns the value stored at position `index` in the set. O(1).
680     *
681     * Note that there are no guarantees on the ordering of values inside the
682     * array, and it may change when more values are added or removed.
683     *
684     * Requirements:
685     *
686     * - `index` must be strictly less than {length}.
687     */
688     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
689         return uint256(_at(set._inner, index));
690     }
691 }
692 
693 /**
694  *Submitted for verification at Etherscan.io on 2020-09-26
695 */
696 
697 
698 pragma solidity ^0.6.0;
699 
700 /*
701  * @dev Provides information about the current execution context, including the
702  * sender of the transaction and its data. While these are generally available
703  * via msg.sender and msg.data, they should not be accessed in such a direct
704  * manner, since when dealing with GSN meta-transactions the account sending and
705  * paying for execution may not be the actual sender (as far as an application
706  * is concerned).
707  *
708  * This contract is only required for intermediate, library-like contracts.
709  */
710 abstract contract Context {
711     function _msgSender() internal view virtual returns (address payable) {
712         return msg.sender;
713     }
714 
715     function _msgData() internal view virtual returns (bytes memory) {
716         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
717         return msg.data;
718     }
719 }
720 
721 
722 pragma solidity ^0.6.0;
723 
724 /**
725  * @dev Contract module which provides a basic access control mechanism, where
726  * there is an account (an owner) that can be granted exclusive access to
727  * specific functions.
728  *
729  * By default, the owner account will be the one that deploys the contract. This
730  * can later be changed with {transferOwnership}.
731  *
732  * This module is used through inheritance. It will make available the modifier
733  * `onlyOwner`, which can be applied to your functions to restrict their use to
734  * the owner.
735  */
736 contract Ownable is Context {
737     address private _owner;
738 
739     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
740 
741     /**
742      * @dev Initializes the contract setting the deployer as the initial owner.
743      */
744     constructor () internal {
745         address msgSender = _msgSender();
746         _owner = msgSender;
747         emit OwnershipTransferred(address(0), msgSender);
748     }
749 
750     /**
751      * @dev Returns the address of the current owner.
752      */
753     function owner() public view returns (address) {
754         return _owner;
755     }
756 
757     /**
758      * @dev Throws if called by any account other than the owner.
759      */
760     modifier onlyOwner() {
761         require(_owner == _msgSender(), "Ownable: caller is not the owner");
762         _;
763     }
764 
765     /**
766      * @dev Leaves the contract without owner. It will not be possible to call
767      * `onlyOwner` functions anymore. Can only be called by the current owner.
768      *
769      * NOTE: Renouncing ownership will leave the contract without an owner,
770      * thereby removing any functionality that is only available to the owner.
771      */
772     function renounceOwnership() public virtual onlyOwner {
773         emit OwnershipTransferred(_owner, address(0));
774         _owner = address(0);
775     }
776 
777     /**
778      * @dev Transfers ownership of the contract to a new account (`newOwner`).
779      * Can only be called by the current owner.
780      */
781     function transferOwnership(address newOwner) public virtual onlyOwner {
782         require(newOwner != address(0), "Ownable: new owner is the zero address");
783         emit OwnershipTransferred(_owner, newOwner);
784         _owner = newOwner;
785     }
786 }
787 
788 
789 
790 pragma solidity ^0.6.0;
791 
792 /**
793  * @dev Implementation of the {IERC20} interface.
794  *
795  * This implementation is agnostic to the way tokens are created. This means
796  * that a supply mechanism has to be added in a derived contract using {_mint}.
797  * For a generic mechanism see {ERC20PresetMinterPauser}.
798  *
799  * TIP: For a detailed writeup see our guide
800  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
801  * to implement supply mechanisms].
802  *
803  * We have followed general OpenZeppelin guidelines: functions revert instead
804  * of returning `false` on failure. This behavior is nonetheless conventional
805  * and does not conflict with the expectations of ERC20 applications.
806  *
807  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
808  * This allows applications to reconstruct the allowance for all accounts just
809  * by listening to said events. Other implementations of the EIP may not emit
810  * these events, as it isn't required by the specification.
811  *
812  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
813  * functions have been added to mitigate the well-known issues around setting
814  * allowances. See {IERC20-approve}.
815  */
816 contract ERC20 is Context, IERC20 {
817     using SafeMath for uint256;
818     using Address for address;
819 
820     mapping (address => uint256) private _balances;
821 
822     mapping (address => mapping (address => uint256)) private _allowances;
823 
824     uint256 private _totalSupply;
825 
826     string private _name;
827     string private _symbol;
828     uint8 private _decimals;
829 
830     /**
831      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
832      * a default value of 18.
833      *
834      * To select a different value for {decimals}, use {_setupDecimals}.
835      *
836      * All three of these values are immutable: they can only be set once during
837      * construction.
838      */
839     constructor (string memory name, string memory symbol) public {
840         _name = name;
841         _symbol = symbol;
842         _decimals = 18;
843     }
844 
845     /**
846      * @dev Returns the name of the token.
847      */
848     function name() public view returns (string memory) {
849         return _name;
850     }
851 
852     /**
853      * @dev Returns the symbol of the token, usually a shorter version of the
854      * name.
855      */
856     function symbol() public view returns (string memory) {
857         return _symbol;
858     }
859 
860     /**
861      * @dev Returns the number of decimals used to get its user representation.
862      * For example, if `decimals` equals `2`, a balance of `505` tokens should
863      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
864      *
865      * Tokens usually opt for a value of 18, imitating the relationship between
866      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
867      * called.
868      *
869      * NOTE: This information is only used for _display_ purposes: it in
870      * no way affects any of the arithmetic of the contract, including
871      * {IERC20-balanceOf} and {IERC20-transfer}.
872      */
873     function decimals() public view returns (uint8) {
874         return _decimals;
875     }
876 
877     /**
878      * @dev See {IERC20-totalSupply}.
879      */
880     function totalSupply() public view override returns (uint256) {
881         return _totalSupply;
882     }
883 
884     /**
885      * @dev See {IERC20-balanceOf}.
886      */
887     function balanceOf(address account) public view override returns (uint256) {
888         return _balances[account];
889     }
890 
891     /**
892      * @dev See {IERC20-transfer}.
893      *
894      * Requirements:
895      *
896      * - `recipient` cannot be the zero address.
897      * - the caller must have a balance of at least `amount`.
898      */
899     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
900         _transfer(_msgSender(), recipient, amount);
901         return true;
902     }
903 
904     /**
905      * @dev See {IERC20-allowance}.
906      */
907     function allowance(address owner, address spender) public view virtual override returns (uint256) {
908         return _allowances[owner][spender];
909     }
910 
911     /**
912      * @dev See {IERC20-approve}.
913      *
914      * Requirements:
915      *
916      * - `spender` cannot be the zero address.
917      */
918     function approve(address spender, uint256 amount) public virtual override returns (bool) {
919         _approve(_msgSender(), spender, amount);
920         return true;
921     }
922 
923     /**
924      * @dev See {IERC20-transferFrom}.
925      *
926      * Emits an {Approval} event indicating the updated allowance. This is not
927      * required by the EIP. See the note at the beginning of {ERC20};
928      *
929      * Requirements:
930      * - `sender` and `recipient` cannot be the zero address.
931      * - `sender` must have a balance of at least `amount`.
932      * - the caller must have allowance for ``sender``'s tokens of at least
933      * `amount`.
934      */
935     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
936         _transfer(sender, recipient, amount);
937         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
938         return true;
939     }
940 
941     /**
942      * @dev Atomically increases the allowance granted to `spender` by the caller.
943      *
944      * This is an alternative to {approve} that can be used as a mitigation for
945      * problems described in {IERC20-approve}.
946      *
947      * Emits an {Approval} event indicating the updated allowance.
948      *
949      * Requirements:
950      *
951      * - `spender` cannot be the zero address.
952      */
953     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
954         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
955         return true;
956     }
957 
958     /**
959      * @dev Atomically decreases the allowance granted to `spender` by the caller.
960      *
961      * This is an alternative to {approve} that can be used as a mitigation for
962      * problems described in {IERC20-approve}.
963      *
964      * Emits an {Approval} event indicating the updated allowance.
965      *
966      * Requirements:
967      *
968      * - `spender` cannot be the zero address.
969      * - `spender` must have allowance for the caller of at least
970      * `subtractedValue`.
971      */
972     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
973         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
974         return true;
975     }
976 
977     /**
978      * @dev Moves tokens `amount` from `sender` to `recipient`.
979      *
980      * This is internal function is equivalent to {transfer}, and can be used to
981      * e.g. implement automatic token fees, slashing mechanisms, etc.
982      *
983      * Emits a {Transfer} event.
984      *
985      * Requirements:
986      *
987      * - `sender` cannot be the zero address.
988      * - `recipient` cannot be the zero address.
989      * - `sender` must have a balance of at least `amount`.
990      */
991     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
992         require(sender != address(0), "ERC20: transfer from the zero address");
993         require(recipient != address(0), "ERC20: transfer to the zero address");
994 
995         _beforeTokenTransfer(sender, recipient, amount);
996 
997         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
998         _balances[recipient] = _balances[recipient].add(amount);
999         emit Transfer(sender, recipient, amount);
1000     }
1001 
1002     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1003      * the total supply.
1004      *
1005      * Emits a {Transfer} event with `from` set to the zero address.
1006      *
1007      * Requirements
1008      *
1009      * - `to` cannot be the zero address.
1010      */
1011     function _mint(address account, uint256 amount) internal virtual {
1012         require(account != address(0), "ERC20: mint to the zero address");
1013 
1014         _beforeTokenTransfer(address(0), account, amount);
1015 
1016         _totalSupply = _totalSupply.add(amount);
1017         _balances[account] = _balances[account].add(amount);
1018         emit Transfer(address(0), account, amount);
1019     }
1020 
1021     /**
1022      * @dev Destroys `amount` tokens from `account`, reducing the
1023      * total supply.
1024      *
1025      * Emits a {Transfer} event with `to` set to the zero address.
1026      *
1027      * Requirements
1028      *
1029      * - `account` cannot be the zero address.
1030      * - `account` must have at least `amount` tokens.
1031      */
1032     function _burn(address account, uint256 amount) internal virtual {
1033         require(account != address(0), "ERC20: burn from the zero address");
1034 
1035         _beforeTokenTransfer(account, address(0), amount);
1036 
1037         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1038         _totalSupply = _totalSupply.sub(amount);
1039         emit Transfer(account, address(0), amount);
1040     }
1041 
1042     /**
1043      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1044      *
1045      * This internal function is equivalent to `approve`, and can be used to
1046      * e.g. set automatic allowances for certain subsystems, etc.
1047      *
1048      * Emits an {Approval} event.
1049      *
1050      * Requirements:
1051      *
1052      * - `owner` cannot be the zero address.
1053      * - `spender` cannot be the zero address.
1054      */
1055     function _approve(address owner, address spender, uint256 amount) internal virtual {
1056         require(owner != address(0), "ERC20: approve from the zero address");
1057         require(spender != address(0), "ERC20: approve to the zero address");
1058 
1059         _allowances[owner][spender] = amount;
1060         emit Approval(owner, spender, amount);
1061     }
1062 
1063     /**
1064      * @dev Sets {decimals} to a value other than the default one of 18.
1065      *
1066      * WARNING: This function should only be called from the constructor. Most
1067      * applications that interact with token contracts will not expect
1068      * {decimals} to ever change, and may work incorrectly if it does.
1069      */
1070     function _setupDecimals(uint8 decimals_) internal {
1071         _decimals = decimals_;
1072     }
1073 
1074     /**
1075      * @dev Hook that is called before any transfer of tokens. This includes
1076      * minting and burning.
1077      *
1078      * Calling conditions:
1079      *
1080      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1081      * will be to transferred to `to`.
1082      * - when `from` is zero, `amount` tokens will be minted for `to`.
1083      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1084      * - `from` and `to` are never both zero.
1085      *
1086      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1087      */
1088     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1089 }
1090 
1091 
1092 
1093 pragma solidity 0.6.12;
1094 
1095 
1096 // JokerToken with Governance.
1097 contract JokerToken is ERC20("JokerToken", "JOKER"), Ownable {
1098     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1099     function mint(address _to, uint256 _amount) public onlyOwner {
1100         _mint(_to, _amount);
1101         _moveDelegates(address(0), _delegates[_to], _amount);
1102     }
1103 
1104     // Copied and modified from SUSHI code:
1105     // https://github.com/sushiswap/sushiswap/blob/master/contracts/SushiToken.sol
1106     // Which is copied and modified from YAM and COMPOUND:
1107     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1108     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1109     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1110 
1111     /// @dev A record of each accounts delegate
1112     mapping (address => address) internal _delegates;
1113 
1114     /// @notice A checkpoint for marking number of votes from a given block
1115     struct Checkpoint {
1116         uint32 fromBlock;
1117         uint256 votes;
1118     }
1119 
1120     /// @notice A record of votes checkpoints for each account, by index
1121     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1122 
1123     /// @notice The number of checkpoints for each account
1124     mapping (address => uint32) public numCheckpoints;
1125 
1126     /// @notice The EIP-712 typehash for the contract's domain
1127     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1128 
1129     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1130     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1131 
1132     /// @notice A record of states for signing / validating signatures
1133     mapping (address => uint) public nonces;
1134 
1135       /// @notice An event thats emitted when an account changes its delegate
1136     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1137 
1138     /// @notice An event thats emitted when a delegate account's vote balance changes
1139     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1140 
1141     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1142         _transfer(_msgSender(), recipient, amount);
1143         _moveDelegates(_delegates[_msgSender()], _delegates[recipient], amount);
1144         return true;
1145     }
1146 
1147     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1148         _transfer(sender, recipient, amount);
1149         _approve(sender, _msgSender(), allowance(sender, _msgSender()).sub(amount, "ERC20: transfer amount exceeds allowance"));
1150         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1151         return true;
1152     }
1153 
1154     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1155         require((amount == 0) || (allowance(_msgSender(), spender) == 0), "JOKER: use increaseAllowance or decreaseAllowance instead");
1156         return super.approve(spender, amount);
1157     }
1158 
1159     /**
1160      * @notice Delegate votes from `msg.sender` to `delegatee`
1161      * @param delegator The address to get delegatee for
1162      */
1163     function delegates(address delegator)
1164         external
1165         view
1166         returns (address)
1167     {
1168         return _delegates[delegator];
1169     }
1170 
1171    /**
1172     * @notice Delegate votes from `msg.sender` to `delegatee`
1173     * @param delegatee The address to delegate votes to
1174     */
1175     function delegate(address delegatee) external {
1176         require(delegatee != _delegates[msg.sender], "JOKER::delegate: delegatee not change");
1177         return _delegate(msg.sender, delegatee);
1178     }
1179 
1180     /**
1181      * @notice Delegates votes from signatory to `delegatee`
1182      * @param delegatee The address to delegate votes to
1183      * @param nonce The contract state required to match the signature
1184      * @param expiry The time at which to expire the signature
1185      * @param v The recovery byte of the signature
1186      * @param r Half of the ECDSA signature pair
1187      * @param s Half of the ECDSA signature pair
1188      */
1189     function delegateBySig(
1190         address delegatee,
1191         uint nonce,
1192         uint expiry,
1193         uint8 v,
1194         bytes32 r,
1195         bytes32 s
1196     )
1197         external
1198     {
1199         bytes32 domainSeparator = keccak256(
1200             abi.encode(
1201                 DOMAIN_TYPEHASH,
1202                 keccak256(bytes(name())),
1203                 getChainId(),
1204                 address(this)
1205             )
1206         );
1207 
1208         bytes32 structHash = keccak256(
1209             abi.encode(
1210                 DELEGATION_TYPEHASH,
1211                 delegatee,
1212                 nonce,
1213                 expiry
1214             )
1215         );
1216 
1217         bytes32 digest = keccak256(
1218             abi.encodePacked(
1219                 "\x19\x01",
1220                 domainSeparator,
1221                 structHash
1222             )
1223         );
1224 
1225         address signatory = ecrecover(digest, v, r, s);
1226         require(signatory != address(0), "JOCKER::delegateBySig: invalid signature");
1227         require(nonce == nonces[signatory]++, "JOCKER::delegateBySig: invalid nonce");
1228         require(now <= expiry, "JOCKER::delegateBySig: signature expired");
1229         return _delegate(signatory, delegatee);
1230     }
1231 
1232     /**
1233      * @notice Gets the current votes balance for `account`
1234      * @param account The address to get votes balance
1235      * @return The number of current votes for `account`
1236      */
1237     function getCurrentVotes(address account)
1238         external
1239         view
1240         returns (uint256)
1241     {
1242         uint32 nCheckpoints = numCheckpoints[account];
1243         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1244     }
1245 
1246     /**
1247      * @notice Determine the prior number of votes for an account as of a block number
1248      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1249      * @param account The address of the account to check
1250      * @param blockNumber The block number to get the vote balance at
1251      * @return The number of votes the account had as of the given block
1252      */
1253     function getPriorVotes(address account, uint blockNumber)
1254         external
1255         view
1256         returns (uint256)
1257     {
1258         require(blockNumber < block.number, "JOCKER::getPriorVotes: not yet determined");
1259 
1260         uint32 nCheckpoints = numCheckpoints[account];
1261         if (nCheckpoints == 0) {
1262             return 0;
1263         }
1264 
1265         // First check most recent balance
1266         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1267             return checkpoints[account][nCheckpoints - 1].votes;
1268         }
1269 
1270         // Next check implicit zero balance
1271         if (checkpoints[account][0].fromBlock > blockNumber) {
1272             return 0;
1273         }
1274 
1275         uint32 lower = 0;
1276         uint32 upper = nCheckpoints - 1;
1277         while (upper > lower) {
1278             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1279             Checkpoint memory cp = checkpoints[account][center];
1280             if (cp.fromBlock == blockNumber) {
1281                 return cp.votes;
1282             } else if (cp.fromBlock < blockNumber) {
1283                 lower = center;
1284             } else {
1285                 upper = center - 1;
1286             }
1287         }
1288         return checkpoints[account][lower].votes;
1289     }
1290 
1291     function _delegate(address delegator, address delegatee)
1292         internal
1293     {
1294         address currentDelegate = _delegates[delegator];
1295         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying JOCKERs;
1296         _delegates[delegator] = delegatee;
1297 
1298         emit DelegateChanged(delegator, currentDelegate, delegatee);
1299 
1300         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1301     }
1302 
1303     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1304         if (srcRep != dstRep && amount > 0) {
1305             if (srcRep != address(0)) {
1306                 // decrease old representative
1307                 uint32 srcRepNum = numCheckpoints[srcRep];
1308                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1309                 uint256 srcRepNew = srcRepOld.sub(amount);
1310                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1311             }
1312 
1313             if (dstRep != address(0)) {
1314                 // increase new representative
1315                 uint32 dstRepNum = numCheckpoints[dstRep];
1316                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1317                 uint256 dstRepNew = dstRepOld.add(amount);
1318                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1319             }
1320         }
1321     }
1322 
1323     function _writeCheckpoint(
1324         address delegatee,
1325         uint32 nCheckpoints,
1326         uint256 oldVotes,
1327         uint256 newVotes
1328     )
1329         internal
1330     {
1331         uint32 blockNumber = safe32(block.number, "JOCKER::_writeCheckpoint: block number exceeds 32 bits");
1332 
1333         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1334             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1335         } else {
1336             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1337             numCheckpoints[delegatee] = nCheckpoints + 1;
1338         }
1339 
1340         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1341     }
1342 
1343     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1344         require(n < 2**32, errorMessage);
1345         return uint32(n);
1346     }
1347 
1348     function getChainId() internal pure returns (uint) {
1349         uint256 chainId;
1350         assembly { chainId := chainid() }
1351         return chainId;
1352     }
1353 }
1354 
1355 
1356 
1357 interface IMigratorChef {
1358     // Perform LP token migration from legacy UniswapV2 to SushiSwap.
1359     // Take the current LP token address and return the new LP token address.
1360     // Migrator should have full access to the caller's LP token.
1361     // Return the new LP token address.
1362     //
1363     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1364     // SushiSwap must mint EXACTLY the same amount of SushiSwap LP tokens or
1365     // else something bad will happen. Traditional UniswapV2 does not
1366     // do that so be careful!
1367     function migrate(IERC20 token) external returns (IERC20);
1368 }
1369 
1370 // LordJoker is the master of Joker. He can make JOKER and he is a fair guy.
1371 //
1372 // Note that it's ownable and the owner wields tremendous power. The ownership
1373 // will be transferred to a governance smart contract once JOCKER is sufficiently
1374 // distributed and the community can show to govern itself.
1375 //
1376 // Have fun reading it. Hopefully it's bug-free. God bless.
1377 contract LordJoker is Ownable {
1378     using SafeMath for uint256;
1379     using SafeERC20 for IERC20;
1380 
1381     // Info of each user.
1382     struct UserInfo {
1383         uint256 amount;     // How many LP tokens the user has provided.
1384         uint256 rewardDebt; // Reward debt. See explanation below.
1385         //
1386         // We do some fancy math here. Basically, any point in time, the amount of JOCKERs
1387         // entitled to a user but is pending to be distributed is:
1388         //
1389         //   pending reward = (user.amount * pool.accJockerPerShare) - user.rewardDebt
1390         //
1391         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1392         //   1. The pool's `accJockerPerShare` (and `lastRewardBlock`) gets updated.
1393         //   2. User receives the pending reward sent to his/her address.
1394         //   3. User's `amount` gets updated.
1395         //   4. User's `rewardDebt` gets updated.
1396     }
1397 
1398     // Info of each pool.
1399     struct PoolInfo {
1400         bool lendPool;              // Whether is lending pool.
1401         IERC20 lpToken;             // Address of LP token contract.
1402         uint256 allocPoint;         // How many allocation points assigned to this pool. JOCKERs to distribute per block.
1403         uint256 lastRewardBlock;    // Last block number that JOCKERs distribution occurs.
1404         uint256 accJockerPerShare;  // Accumulated JOCKERs per share, times 1e12. See below.
1405         uint256 totalDeposit;       // Accumulated deposit tokens.
1406         // uint256 totalLend;          // Accumulated lent tokens.
1407     }
1408 
1409     // The JOCKER TOKEN!
1410     JokerToken public jocker;
1411     // Dev address.
1412     address public devaddr;
1413     // Treasury address.
1414     address public treasury;
1415     // Block number when bonus JOCKER period ends.
1416     // uint256 public bonusEndBlock;
1417     // JOCKER tokens created per block.
1418     uint256 public jockerPerBlock = 80 * 1e18;
1419     // Min rewards per block.
1420     uint256 public constant MIN_JOCKERs = 5 * 1e18;
1421     // Max supply 100m
1422     uint256 public constant MAX_SUPPLY = 100000000 * 1e18;
1423     // Bonus muliplier for early jocker makers.
1424     // uint256 public constant BONUS_MULTIPLIER = 10;
1425     // Half ervry blocks
1426     uint256 public constant HALVE_NUM = 200000;
1427     // Block number when half happens
1428     uint256 public halveBlockNum;
1429     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1430     IMigratorChef public migrator;
1431     // The lender contract. It can modify lendPool derectly. Can only be set through governance (owner).
1432     address public lender;
1433     // The vaults contract. It can transfer token derectly. Can only be set through governance (owner).
1434     address public vaults;
1435     
1436     // Info of each pool.
1437     PoolInfo[] public poolInfo;
1438     // Info of each user that stakes LP tokens.
1439     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1440     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1441     uint256 public totalAllocPoint = 0;
1442     // The block number when JOCKER mining starts.
1443     uint256 public startBlock;
1444 
1445     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1446     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1447     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1448     event ClaimRewards(address indexed user, uint256 indexed pid, uint256 amount);
1449     event HalveRewards(uint256 indexed before, uint256 afther);
1450 
1451     constructor(
1452         JokerToken _joker,
1453         address _devaddr,
1454         address _treasury,
1455         // uint256 _jockerPerBlock,
1456         uint256 _startBlock
1457         // uint256 _bonusEndBlock
1458     ) public {
1459         jocker = _joker;
1460         devaddr = _devaddr;
1461         treasury = _treasury;
1462         // jockerPerBlock = _jockerPerBlock;
1463         // bonusEndBlock = _bonusEndBlock;
1464         startBlock = _startBlock;
1465         halveBlockNum = _startBlock.add(HALVE_NUM);
1466     }
1467 
1468     modifier checkHalve() {
1469         if (block.number >= halveBlockNum && jockerPerBlock > MIN_JOCKERs) {
1470             uint256 before = jockerPerBlock;
1471             jockerPerBlock = jockerPerBlock.mul(50).div(100);
1472             halveBlockNum = halveBlockNum.add(HALVE_NUM);
1473             emit HalveRewards(before, jockerPerBlock);
1474         }
1475         _;
1476     }
1477 
1478     function poolLength() external view returns (uint256) {
1479         return poolInfo.length;
1480     }
1481 
1482     // Add a new lp to the pool. Can only be called by the owner.
1483     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1484     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, bool _lendPool) public onlyOwner {
1485         if (_lendPool) {
1486             require(address(0) != lender, "add: no lender");
1487         }
1488         if (_withUpdate) {
1489             massUpdatePools();
1490         }
1491         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1492         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1493         poolInfo.push(PoolInfo({
1494             lendPool: _lendPool,
1495             lpToken: _lpToken,
1496             allocPoint: _allocPoint,
1497             lastRewardBlock: lastRewardBlock,
1498             accJockerPerShare: 0,
1499             totalDeposit: 0
1500             // totalLend: 0
1501         }));
1502     }
1503 
1504     // Update the given pool's JOCKER allocation point. Can only be called by the owner.
1505     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1506         // !!!When change pool weight without massUpdatePools, will mint more or less jockerReward
1507         if (_withUpdate) {
1508             massUpdatePools();
1509         }
1510         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1511         poolInfo[_pid].allocPoint = _allocPoint;
1512     }
1513 
1514     // Transfer token contract owner. Can only be called by the owner.
1515     function transferTokenOwner(address _owner) public onlyOwner {
1516         jocker.transferOwnership(_owner);
1517     }
1518 
1519     // Set the migrator contract. Can only be called by the owner.
1520     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1521         migrator = _migrator;
1522     }
1523 
1524     // Set the lender contract. Can only be called by the owner.
1525     function setLender(address _lender) public onlyOwner {
1526         lender = _lender;
1527     }
1528 
1529     // Set the vaults contract. Can only be called by the owner.
1530     function setVaults(address _vaults) public onlyOwner {
1531         vaults = _vaults;
1532     }
1533 
1534     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1535     function migrate(uint256 _pid) public {
1536         require(address(migrator) != address(0), "migrate: no migrator");
1537         PoolInfo storage pool = poolInfo[_pid];
1538         IERC20 lpToken = pool.lpToken;
1539         uint256 bal = lpToken.balanceOf(address(this));
1540         lpToken.safeApprove(address(migrator), bal);
1541         IERC20 newLpToken = migrator.migrate(lpToken);
1542         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1543         pool.lpToken = newLpToken;
1544     }
1545 
1546     // Return reward multiplier over the given _from to _to block.
1547     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
1548         // if (_to <= bonusEndBlock) {
1549         //     return _to.sub(_from).mul(BONUS_MULTIPLIER);
1550         // } else if (_from >= bonusEndBlock) {
1551         //     return _to.sub(_from);
1552         // } else {
1553         //     return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1554         //         _to.sub(bonusEndBlock)
1555         //     );
1556         // }
1557         return _to.sub(_from);
1558     }
1559 
1560     // View function to see pending JOCKERs on frontend.
1561     function pendingJocker(uint256 _pid, address _user) external view returns (uint256) {
1562         PoolInfo storage pool = poolInfo[_pid];
1563         UserInfo storage user = userInfo[_pid][_user];
1564         uint256 accJockerPerShare = pool.accJockerPerShare;
1565         if (block.number > pool.lastRewardBlock && pool.totalDeposit != 0) {
1566             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1567             uint256 jockerReward = multiplier.mul(jockerPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1568             uint256 devReward = jockerReward.div(10);
1569             uint256 treasuryReward = jockerReward.div(10);
1570             uint256 poolReward = jockerReward.sub(devReward).sub(treasuryReward);
1571             accJockerPerShare = accJockerPerShare.add(poolReward.mul(1e12).div(pool.totalDeposit));
1572         }
1573         return user.amount.mul(accJockerPerShare).div(1e12).sub(user.rewardDebt);
1574     }
1575 
1576     // Update reward variables for all pools. Be careful of gas spending!
1577     function massUpdatePools() public {
1578         uint256 length = poolInfo.length;
1579         for (uint256 pid = 0; pid < length; ++pid) {
1580             updatePool(pid);
1581         }
1582     }
1583 
1584     // Update reward variables of the given pool to be up-to-date.
1585     function updatePool(uint256 _pid) public checkHalve {
1586         uint256 totalSupply = jocker.totalSupply();
1587         if (totalSupply >= MAX_SUPPLY) {
1588             return;
1589         }
1590         PoolInfo storage pool = poolInfo[_pid];
1591         if (block.number <= pool.lastRewardBlock) {
1592             return;
1593         }
1594         if (pool.totalDeposit == 0) {
1595             pool.lastRewardBlock = block.number;
1596             return;
1597         }
1598         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1599         uint256 jockerReward = multiplier.mul(jockerPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1600         // !!!When change pool weight without massUpdatePools, will mint more or less jockerReward
1601         uint256 devReward = jockerReward.div(10);
1602         uint256 treasuryReward = jockerReward.div(10);
1603         uint256 poolReward = jockerReward.sub(devReward).sub(treasuryReward);
1604         jocker.mint(devaddr, devReward);
1605         jocker.mint(treasury, treasuryReward);
1606         jocker.mint(address(this), poolReward);
1607         pool.accJockerPerShare = pool.accJockerPerShare.add(poolReward.mul(1e12).div(pool.totalDeposit));
1608         pool.lastRewardBlock = block.number;
1609     }
1610 
1611     // Deposit LP tokens to LordJoker for JOCKER allocation.
1612     function deposit(address _user, uint256 _pid, uint256 _amount) public {
1613         if(lender != address(0)) {
1614             require(msg.sender == lender, "deposit: caller must be lender");
1615         } else {
1616             require(msg.sender == _user, "deposit: caller must be _user");
1617         }
1618         PoolInfo storage pool = poolInfo[_pid];
1619         require(!pool.lendPool, "deposit: can not be lendPool");
1620         UserInfo storage user = userInfo[_pid][_user];
1621         updatePool(_pid);
1622         if (user.amount > 0) {
1623             uint256 pending = user.amount.mul(pool.accJockerPerShare).div(1e12).sub(user.rewardDebt);
1624             if(pending > 0) {
1625                 safeJockerTransfer(_user, pending);
1626             }
1627         }
1628         if(_amount > 0) {
1629             pool.lpToken.safeTransferFrom(address(_user), address(this), _amount);
1630             user.amount = user.amount.add(_amount);
1631             pool.totalDeposit = pool.totalDeposit.add(_amount);
1632         }
1633         user.rewardDebt = user.amount.mul(pool.accJockerPerShare).div(1e12);
1634         emit Deposit(_user, _pid, _amount);
1635     }
1636 
1637     // Withdraw LP tokens from LordJoker.
1638     function withdraw(address _user, uint256 _pid, uint256 _amount) public {
1639         if(lender != address(0)) {
1640             require(msg.sender == lender, "withdraw: caller must be lender");
1641         } else {
1642             require(msg.sender == _user, "withdraw: caller must be _user");
1643         }
1644         PoolInfo storage pool = poolInfo[_pid];
1645         require(!pool.lendPool, "withdraw: can not be lendPool");
1646         UserInfo storage user = userInfo[_pid][_user];
1647         require(user.amount >= _amount, "withdraw: not good");
1648         updatePool(_pid);
1649         uint256 pending = user.amount.mul(pool.accJockerPerShare).div(1e12).sub(user.rewardDebt);
1650         if(pending > 0) {
1651             safeJockerTransfer(_user, pending);
1652         }
1653         if(_amount > 0) {
1654             user.amount = user.amount.sub(_amount);
1655             pool.totalDeposit = pool.totalDeposit.sub(_amount);
1656             pool.lpToken.safeTransfer(address(_user), _amount);
1657         }
1658         user.rewardDebt = user.amount.mul(pool.accJockerPerShare).div(1e12);
1659         emit Withdraw(_user, _pid, _amount);
1660     }
1661 
1662     // Withdraw without caring about rewards. EMERGENCY ONLY.
1663     function emergencyWithdraw(address _user, uint256 _pid) public {
1664         if(lender != address(0)) {
1665             require(msg.sender == lender, "emergencyWithdraw: caller must be lender");
1666         } else {
1667             require(msg.sender == _user, "emergencyWithdraw: caller must be _user");
1668         }
1669         PoolInfo storage pool = poolInfo[_pid];
1670         require(!pool.lendPool, "emergencyWithdraw: can not be lendPool");
1671         UserInfo storage user = userInfo[_pid][_user];
1672         uint256 amount = user.amount;
1673         user.amount = 0;
1674         user.rewardDebt = 0;
1675         pool.totalDeposit = pool.totalDeposit.sub(amount);
1676         pool.lpToken.safeTransfer(address(_user), amount);
1677         emit EmergencyWithdraw(_user, _pid, amount);
1678     }
1679 
1680     // Claim JOCKER allocation rewards.
1681     function claim(uint256 _pid) public {
1682         PoolInfo storage pool = poolInfo[_pid];
1683         UserInfo storage user = userInfo[_pid][msg.sender];
1684         updatePool(_pid);
1685         uint256 pending = 0;
1686         if (user.amount > 0) {
1687             pending = user.amount.mul(pool.accJockerPerShare).div(1e12).sub(user.rewardDebt);
1688             if(pending > 0) {
1689                 safeJockerTransfer(msg.sender, pending);
1690             }
1691         }
1692         user.rewardDebt = user.amount.mul(pool.accJockerPerShare).div(1e12);
1693         emit ClaimRewards(msg.sender, _pid, pending);
1694     }
1695 
1696     // Claim all JOCKER allocation rewards. Be careful of gas spending!
1697     function claimAll() public {
1698         uint256 length = poolInfo.length;
1699         for (uint256 pid = 0; pid < length; ++pid) {
1700             UserInfo storage user = userInfo[pid][msg.sender];
1701             if (user.amount > 0) {
1702                 claim(pid);
1703             }
1704         }
1705     }
1706 
1707     // Increase user lendPool deposit amount for JOCKER allocation.
1708     function depositLendPool(address _user, uint256 _pid, uint256 _amount) external {
1709         require(msg.sender == lender, "depositLendPool: caller must be lender");
1710         PoolInfo storage pool = poolInfo[_pid];
1711         require(pool.lendPool, "depositLendPool: must be lendPool");
1712         UserInfo storage user = userInfo[_pid][_user];
1713         updatePool(_pid);
1714         if (user.amount > 0) {
1715             uint256 pending = user.amount.mul(pool.accJockerPerShare).div(1e12).sub(user.rewardDebt);
1716             if(pending > 0) {
1717                 safeJockerTransfer(_user, pending);
1718             }
1719         }
1720         if(_amount > 0) {
1721             user.amount = user.amount.add(_amount);
1722             pool.totalDeposit = pool.totalDeposit.add(_amount);
1723         }
1724         user.rewardDebt = user.amount.mul(pool.accJockerPerShare).div(1e12);
1725         emit Deposit(_user, _pid, _amount);
1726     }
1727 
1728     // Decrease user lendPool deposit amount for JOCKER allocation.
1729     function withdrawLendPool(address _user, uint256 _pid, uint256 _amount) external {
1730         require(msg.sender == lender, "withdrawLendPool: caller must be lender");
1731         PoolInfo storage pool = poolInfo[_pid];
1732         require(pool.lendPool, "withdrawLendPool: must be lendPool");
1733         UserInfo storage user = userInfo[_pid][_user];
1734         require(user.amount >= _amount, "withdrawLendPool: not good");
1735         updatePool(_pid);
1736         uint256 pending = user.amount.mul(pool.accJockerPerShare).div(1e12).sub(user.rewardDebt);
1737         if(pending > 0) {
1738             safeJockerTransfer(_user, pending);
1739         }
1740         if(_amount > 0) {
1741             user.amount = user.amount.sub(_amount);
1742             pool.totalDeposit = pool.totalDeposit.sub(_amount);
1743         }
1744         user.rewardDebt = user.amount.mul(pool.accJockerPerShare).div(1e12);
1745         emit Withdraw(_user, _pid, _amount);
1746     }
1747 
1748     // Lend token to user, only called by lender. Be careful of cashability!!
1749     function lendToken(address _user, uint256 _pid, uint256 _amount) external {
1750         require(address(0) != lender, "lendToken: no lender");
1751         require(msg.sender == lender, "lendToken: caller must be lender");
1752         require(address(0) != _user, "lendToken: can not lend to 0");
1753         if(_amount > 0) {
1754             PoolInfo storage pool = poolInfo[_pid];
1755             pool.lpToken.safeTransfer(address(_user), _amount);  // XXX Must make sure have enough balance.
1756             // pool.totalLend = pool.totalLend.add(_amount);
1757         }
1758     }
1759 
1760     // Vault token to other pool, only called by vaults.
1761     function transferTokenToVaults(uint256 _pid, uint256 _amount) external {
1762         require(address(0) != vaults, "transferTokenToVaults: no vaults");
1763         require(msg.sender == vaults, "transferTokenToVaults: caller must be vaults");
1764         if(_amount > 0) {
1765             PoolInfo storage pool = poolInfo[_pid];
1766             pool.lpToken.safeTransfer(address(vaults), _amount);  // XXX Must make sure have enough balance.
1767         }
1768     }
1769 
1770     // Safe jocker transfer function, just in case if rounding error causes pool to not have enough JOCKERs.
1771     function safeJockerTransfer(address _to, uint256 _amount) internal {
1772         uint256 jockerBal = jocker.balanceOf(address(this));
1773         if (_amount > jockerBal) {
1774             jocker.transfer(_to, jockerBal);
1775         } else {
1776             jocker.transfer(_to, _amount);
1777         }
1778     }
1779 
1780     // Update dev address by the previous dev.
1781     function updateDev(address _devaddr) public {
1782         require(msg.sender == devaddr, "updateDev: wut?");
1783         devaddr = _devaddr;
1784     }
1785     
1786     // Update treasury address by the previous treasury.
1787     function updateTreasury(address _treasury) public {
1788         require(msg.sender == treasury, "updateTreasury: wut?");
1789         treasury = _treasury;
1790     }
1791 }