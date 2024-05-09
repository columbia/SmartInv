1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.6.12;
4 
5 
6 // 
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
81 // 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      *
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
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b <= a, errorMessage);
139         uint256 c = a - b;
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `*` operator.
149      *
150      * Requirements:
151      *
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b > 0, errorMessage);
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b != 0, errorMessage);
234         return a % b;
235     }
236 }
237 
238 // 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies in extcodesize, which returns 0 for contracts in
262         // construction, since the code is only stored at the end of the
263         // constructor execution.
264 
265         uint256 size;
266         // solhint-disable-next-line no-inline-assembly
267         assembly { size := extcodesize(account) }
268         return size > 0;
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
291         (bool success, ) = recipient.call{ value: amount }("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain`call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314       return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
324         return _functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344      * with `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
349         require(address(this).balance >= value, "Address: insufficient balance for call");
350         return _functionCallWithValue(target, data, value, errorMessage);
351     }
352 
353     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
358         if (success) {
359             return returndata;
360         } else {
361             // Look for revert reason and bubble it up if present
362             if (returndata.length > 0) {
363                 // The easiest way to bubble the revert reason is using memory via assembly
364 
365                 // solhint-disable-next-line no-inline-assembly
366                 assembly {
367                     let returndata_size := mload(returndata)
368                     revert(add(32, returndata), returndata_size)
369                 }
370             } else {
371                 revert(errorMessage);
372             }
373         }
374     }
375 }
376 
377 // 
378 /**
379  * @title SafeERC20
380  * @dev Wrappers around ERC20 operations that throw on failure (when the token
381  * contract returns false). Tokens that return no value (and instead revert or
382  * throw on failure) are also supported, non-reverting calls are assumed to be
383  * successful.
384  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
385  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
386  */
387 library SafeERC20 {
388     using SafeMath for uint256;
389     using Address for address;
390 
391     function safeTransfer(IERC20 token, address to, uint256 value) internal {
392         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
393     }
394 
395     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
396         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
397     }
398 
399     /**
400      * @dev Deprecated. This function has issues similar to the ones found in
401      * {IERC20-approve}, and its usage is discouraged.
402      *
403      * Whenever possible, use {safeIncreaseAllowance} and
404      * {safeDecreaseAllowance} instead.
405      */
406     function safeApprove(IERC20 token, address spender, uint256 value) internal {
407         // safeApprove should only be called when setting an initial allowance,
408         // or when resetting it to zero. To increase and decrease it, use
409         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
410         // solhint-disable-next-line max-line-length
411         require((value == 0) || (token.allowance(address(this), spender) == 0),
412             "SafeERC20: approve from non-zero to non-zero allowance"
413         );
414         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
415     }
416 
417     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
418         uint256 newAllowance = token.allowance(address(this), spender).add(value);
419         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
420     }
421 
422     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
423         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
425     }
426 
427     /**
428      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
429      * on the return value: the return value is optional (but if data is returned, it must not be false).
430      * @param token The token targeted by the call.
431      * @param data The call data (encoded using abi.encode or one of its variants).
432      */
433     function _callOptionalReturn(IERC20 token, bytes memory data) private {
434         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
435         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
436         // the target address contains contract code and also asserts for success in the low-level call.
437 
438         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
439         if (returndata.length > 0) { // Return data is optional
440             // solhint-disable-next-line max-line-length
441             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
442         }
443     }
444 }
445 
446 // 
447 /**
448  * @dev Library for managing
449  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
450  * types.
451  *
452  * Sets have the following properties:
453  *
454  * - Elements are added, removed, and checked for existence in constant time
455  * (O(1)).
456  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
457  *
458  * ```
459  * contract Example {
460  *     // Add the library methods
461  *     using EnumerableSet for EnumerableSet.AddressSet;
462  *
463  *     // Declare a set state variable
464  *     EnumerableSet.AddressSet private mySet;
465  * }
466  * ```
467  *
468  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
469  * (`UintSet`) are supported.
470  */
471 library EnumerableSet {
472     // To implement this library for multiple types with as little code
473     // repetition as possible, we write it in terms of a generic Set type with
474     // bytes32 values.
475     // The Set implementation uses private functions, and user-facing
476     // implementations (such as AddressSet) are just wrappers around the
477     // underlying Set.
478     // This means that we can only create new EnumerableSets for types that fit
479     // in bytes32.
480 
481     struct Set {
482         // Storage of set values
483         bytes32[] _values;
484 
485         // Position of the value in the `values` array, plus 1 because index 0
486         // means a value is not in the set.
487         mapping (bytes32 => uint256) _indexes;
488     }
489 
490     /**
491      * @dev Add a value to a set. O(1).
492      *
493      * Returns true if the value was added to the set, that is if it was not
494      * already present.
495      */
496     function _add(Set storage set, bytes32 value) private returns (bool) {
497         if (!_contains(set, value)) {
498             set._values.push(value);
499             // The value is stored at length-1, but we add 1 to all indexes
500             // and use 0 as a sentinel value
501             set._indexes[value] = set._values.length;
502             return true;
503         } else {
504             return false;
505         }
506     }
507 
508     /**
509      * @dev Removes a value from a set. O(1).
510      *
511      * Returns true if the value was removed from the set, that is if it was
512      * present.
513      */
514     function _remove(Set storage set, bytes32 value) private returns (bool) {
515         // We read and store the value's index to prevent multiple reads from the same storage slot
516         uint256 valueIndex = set._indexes[value];
517 
518         if (valueIndex != 0) { // Equivalent to contains(set, value)
519             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
520             // the array, and then remove the last element (sometimes called as 'swap and pop').
521             // This modifies the order of the array, as noted in {at}.
522 
523             uint256 toDeleteIndex = valueIndex - 1;
524             uint256 lastIndex = set._values.length - 1;
525 
526             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
527             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
528 
529             bytes32 lastvalue = set._values[lastIndex];
530 
531             // Move the last value to the index where the value to delete is
532             set._values[toDeleteIndex] = lastvalue;
533             // Update the index for the moved value
534             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
535 
536             // Delete the slot where the moved value was stored
537             set._values.pop();
538 
539             // Delete the index for the deleted slot
540             delete set._indexes[value];
541 
542             return true;
543         } else {
544             return false;
545         }
546     }
547 
548     /**
549      * @dev Returns true if the value is in the set. O(1).
550      */
551     function _contains(Set storage set, bytes32 value) private view returns (bool) {
552         return set._indexes[value] != 0;
553     }
554 
555     /**
556      * @dev Returns the number of values on the set. O(1).
557      */
558     function _length(Set storage set) private view returns (uint256) {
559         return set._values.length;
560     }
561 
562    /**
563     * @dev Returns the value stored at position `index` in the set. O(1).
564     *
565     * Note that there are no guarantees on the ordering of values inside the
566     * array, and it may change when more values are added or removed.
567     *
568     * Requirements:
569     *
570     * - `index` must be strictly less than {length}.
571     */
572     function _at(Set storage set, uint256 index) private view returns (bytes32) {
573         require(set._values.length > index, "EnumerableSet: index out of bounds");
574         return set._values[index];
575     }
576 
577     // AddressSet
578 
579     struct AddressSet {
580         Set _inner;
581     }
582 
583     /**
584      * @dev Add a value to a set. O(1).
585      *
586      * Returns true if the value was added to the set, that is if it was not
587      * already present.
588      */
589     function add(AddressSet storage set, address value) internal returns (bool) {
590         return _add(set._inner, bytes32(uint256(value)));
591     }
592 
593     /**
594      * @dev Removes a value from a set. O(1).
595      *
596      * Returns true if the value was removed from the set, that is if it was
597      * present.
598      */
599     function remove(AddressSet storage set, address value) internal returns (bool) {
600         return _remove(set._inner, bytes32(uint256(value)));
601     }
602 
603     /**
604      * @dev Returns true if the value is in the set. O(1).
605      */
606     function contains(AddressSet storage set, address value) internal view returns (bool) {
607         return _contains(set._inner, bytes32(uint256(value)));
608     }
609 
610     /**
611      * @dev Returns the number of values in the set. O(1).
612      */
613     function length(AddressSet storage set) internal view returns (uint256) {
614         return _length(set._inner);
615     }
616 
617    /**
618     * @dev Returns the value stored at position `index` in the set. O(1).
619     *
620     * Note that there are no guarantees on the ordering of values inside the
621     * array, and it may change when more values are added or removed.
622     *
623     * Requirements:
624     *
625     * - `index` must be strictly less than {length}.
626     */
627     function at(AddressSet storage set, uint256 index) internal view returns (address) {
628         return address(uint256(_at(set._inner, index)));
629     }
630 
631 
632     // UintSet
633 
634     struct UintSet {
635         Set _inner;
636     }
637 
638     /**
639      * @dev Add a value to a set. O(1).
640      *
641      * Returns true if the value was added to the set, that is if it was not
642      * already present.
643      */
644     function add(UintSet storage set, uint256 value) internal returns (bool) {
645         return _add(set._inner, bytes32(value));
646     }
647 
648     /**
649      * @dev Removes a value from a set. O(1).
650      *
651      * Returns true if the value was removed from the set, that is if it was
652      * present.
653      */
654     function remove(UintSet storage set, uint256 value) internal returns (bool) {
655         return _remove(set._inner, bytes32(value));
656     }
657 
658     /**
659      * @dev Returns true if the value is in the set. O(1).
660      */
661     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
662         return _contains(set._inner, bytes32(value));
663     }
664 
665     /**
666      * @dev Returns the number of values on the set. O(1).
667      */
668     function length(UintSet storage set) internal view returns (uint256) {
669         return _length(set._inner);
670     }
671 
672    /**
673     * @dev Returns the value stored at position `index` in the set. O(1).
674     *
675     * Note that there are no guarantees on the ordering of values inside the
676     * array, and it may change when more values are added or removed.
677     *
678     * Requirements:
679     *
680     * - `index` must be strictly less than {length}.
681     */
682     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
683         return uint256(_at(set._inner, index));
684     }
685 }
686 
687 // 
688 /*
689  * @dev Provides information about the current execution context, including the
690  * sender of the transaction and its data. While these are generally available
691  * via msg.sender and msg.data, they should not be accessed in such a direct
692  * manner, since when dealing with GSN meta-transactions the account sending and
693  * paying for execution may not be the actual sender (as far as an application
694  * is concerned).
695  *
696  * This contract is only required for intermediate, library-like contracts.
697  */
698 abstract contract Context {
699     function _msgSender() internal view virtual returns (address payable) {
700         return msg.sender;
701     }
702 
703     function _msgData() internal view virtual returns (bytes memory) {
704         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
705         return msg.data;
706     }
707 }
708 
709 // 
710 /**
711  * @dev Contract module which provides a basic access control mechanism, where
712  * there is an account (an owner) that can be granted exclusive access to
713  * specific functions.
714  *
715  * By default, the owner account will be the one that deploys the contract. This
716  * can later be changed with {transferOwnership}.
717  *
718  * This module is used through inheritance. It will make available the modifier
719  * `onlyOwner`, which can be applied to your functions to restrict their use to
720  * the owner.
721  */
722 contract Ownable is Context {
723     address private _owner;
724 
725     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
726 
727     /**
728      * @dev Initializes the contract setting the deployer as the initial owner.
729      */
730     constructor () internal {
731         address msgSender = _msgSender();
732         _owner = msgSender;
733         emit OwnershipTransferred(address(0), msgSender);
734     }
735 
736     /**
737      * @dev Returns the address of the current owner.
738      */
739     function owner() public view returns (address) {
740         return _owner;
741     }
742 
743     /**
744      * @dev Throws if called by any account other than the owner.
745      */
746     modifier onlyOwner() {
747         require(_owner == _msgSender(), "Ownable: caller is not the owner");
748         _;
749     }
750 
751     /**
752      * @dev Leaves the contract without owner. It will not be possible to call
753      * `onlyOwner` functions anymore. Can only be called by the current owner.
754      *
755      * NOTE: Renouncing ownership will leave the contract without an owner,
756      * thereby removing any functionality that is only available to the owner.
757      */
758     function renounceOwnership() public virtual onlyOwner {
759         emit OwnershipTransferred(_owner, address(0));
760         _owner = address(0);
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Can only be called by the current owner.
766      */
767     function transferOwnership(address newOwner) public virtual onlyOwner {
768         require(newOwner != address(0), "Ownable: new owner is the zero address");
769         emit OwnershipTransferred(_owner, newOwner);
770         _owner = newOwner;
771     }
772 }
773 
774 // 
775 /**
776  * @dev Implementation of the {IERC20} interface.
777  *
778  * This implementation is agnostic to the way tokens are created. This means
779  * that a supply mechanism has to be added in a derived contract using {_mint}.
780  * For a generic mechanism see {ERC20PresetMinterPauser}.
781  *
782  * TIP: For a detailed writeup see our guide
783  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
784  * to implement supply mechanisms].
785  *
786  * We have followed general OpenZeppelin guidelines: functions revert instead
787  * of returning `false` on failure. This behavior is nonetheless conventional
788  * and does not conflict with the expectations of ERC20 applications.
789  *
790  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
791  * This allows applications to reconstruct the allowance for all accounts just
792  * by listening to said events. Other implementations of the EIP may not emit
793  * these events, as it isn't required by the specification.
794  *
795  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
796  * functions have been added to mitigate the well-known issues around setting
797  * allowances. See {IERC20-approve}.
798  */
799 contract ERC20BurnableMaxSupply is Context, IERC20 {
800     using SafeMath for uint256;
801     using Address for address;
802 
803     mapping (address => uint256) private _balances;
804 
805     mapping (address => mapping (address => uint256)) private _allowances;
806 
807     uint256 private _totalSupply;
808 
809     string private _name;
810     string private _symbol;
811     uint8 private _decimals;
812 
813     /**
814      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
815      * a default value of 18.
816      *
817      * To select a different value for {decimals}, use {_setupDecimals}.
818      *
819      * All three of these values are immutable: they can only be set once during
820      * construction.
821      */
822     constructor (string memory name, string memory symbol) public {
823         _name = name;
824         _symbol = symbol;
825         _decimals = 18;
826     }
827 
828     /**
829      * @dev Returns the name of the token.
830      */
831     function name() public view returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev Returns the symbol of the token, usually a shorter version of the
837      * name.
838      */
839     function symbol() public view returns (string memory) {
840         return _symbol;
841     }
842 
843     /**
844      * @dev Returns the number of decimals used to get its user representation.
845      * For example, if `decimals` equals `2`, a balance of `505` tokens should
846      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
847      *
848      * Tokens usually opt for a value of 18, imitating the relationship between
849      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
850      * called.
851      *
852      * NOTE: This information is only used for _display_ purposes: it in
853      * no way affects any of the arithmetic of the contract, including
854      * {IERC20-balanceOf} and {IERC20-transfer}.
855      */
856     function decimals() public view returns (uint8) {
857         return _decimals;
858     }
859 
860     /**
861      * @dev See {IERC20-totalSupply}.
862      */
863     function totalSupply() public view override returns (uint256) {
864         return _totalSupply;
865     }
866 
867     /**
868      * @dev See {IERC20-balanceOf}.
869      */
870     function balanceOf(address account) public view override returns (uint256) {
871         return _balances[account];
872     }
873 
874     /**
875      * @dev See {IERC20-transfer}.
876      *
877      * Requirements:
878      *
879      * - `recipient` cannot be the zero address.
880      * - the caller must have a balance of at least `amount`.
881      */
882     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
883         _transfer(_msgSender(), recipient, amount);
884         return true;
885     }
886 
887     /**
888      * @dev See {IERC20-allowance}.
889      */
890     function allowance(address owner, address spender) public view virtual override returns (uint256) {
891         return _allowances[owner][spender];
892     }
893 
894     /**
895      * @dev See {IERC20-approve}.
896      *
897      * Requirements:
898      *
899      * - `spender` cannot be the zero address.
900      */
901     function approve(address spender, uint256 amount) public virtual override returns (bool) {
902         _approve(_msgSender(), spender, amount);
903         return true;
904     }
905 
906     /**
907      * @dev See {IERC20-transferFrom}.
908      *
909      * Emits an {Approval} event indicating the updated allowance. This is not
910      * required by the EIP. See the note at the beginning of {ERC20};
911      *
912      * Requirements:
913      * - `sender` and `recipient` cannot be the zero address.
914      * - `sender` must have a balance of at least `amount`.
915      * - the caller must have allowance for ``sender``'s tokens of at least
916      * `amount`.
917      */
918     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
919         _transfer(sender, recipient, amount);
920         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
921         return true;
922     }
923 
924     /**
925      * @dev Atomically increases the allowance granted to `spender` by the caller.
926      *
927      * This is an alternative to {approve} that can be used as a mitigation for
928      * problems described in {IERC20-approve}.
929      *
930      * Emits an {Approval} event indicating the updated allowance.
931      *
932      * Requirements:
933      *
934      * - `spender` cannot be the zero address.
935      */
936     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
937         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
938         return true;
939     }
940 
941     /**
942      * @dev Atomically decreases the allowance granted to `spender` by the caller.
943      *
944      * This is an alternative to {approve} that can be used as a mitigation for
945      * problems described in {IERC20-approve}.
946      *
947      * Emits an {Approval} event indicating the updated allowance.
948      *
949      * Requirements:
950      *
951      * - `spender` cannot be the zero address.
952      * - `spender` must have allowance for the caller of at least
953      * `subtractedValue`.
954      */
955     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
956         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
957         return true;
958     }
959 
960     /**
961      * @dev Moves tokens `amount` from `sender` to `recipient`.
962      *
963      * This is internal function is equivalent to {transfer}, and can be used to
964      * e.g. implement automatic token fees, slashing mechanisms, etc.
965      *
966      * Emits a {Transfer} event.
967      *
968      * Requirements:
969      *
970      * - `sender` cannot be the zero address.
971      * - `recipient` cannot be the zero address.
972      * - `sender` must have a balance of at least `amount`.
973      */
974     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
975         require(sender != address(0), "ERC20: transfer from the zero address");
976         require(recipient != address(0), "ERC20: transfer to the zero address");
977 
978         _beforeTokenTransfer(sender, recipient, amount);
979 
980         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
981         _balances[recipient] = _balances[recipient].add(amount);
982         emit Transfer(sender, recipient, amount);
983     }
984 
985     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
986      * the total supply.
987      *
988      * ADJUSTMENTS: Can only mint up to 13k (13e21) BBRA (burn + farm rewards have to be stable at lower than 13k)
989      *
990      * Emits a {Transfer} event with `from` set to the zero address.
991      *
992      * Requirements
993      *
994      * - `to` cannot be the zero address.
995      */
996     function _mint(address account, uint256 amount) internal virtual {
997         require(account != address(0), "ERC20: mint to the zero address");
998 
999         _beforeTokenTransfer(address(0), account, amount);
1000 
1001         if (_totalSupply.add(amount) > 13e21) {
1002             // if supply is over 13k after adding 'amount' check what is available to be minted (13e21 - current supply)
1003             // if it's greater than 0 then we can mint up to that amount
1004             // Eg totalSupply = 12,999e18 BBRA and amount to be minted is 10e18 BBRA. We can't mint 10e18 because it takes us over
1005             // hard cap. However we can mint a partial amount aka 13e21 - 12,999e18 = 1e18
1006             amount = uint256(13e21).sub(_totalSupply);
1007 
1008             // can't mint even a partial amount so we must exit the function
1009             if (amount == 0)
1010                 return;
1011         }
1012 
1013         _totalSupply = _totalSupply.add(amount);
1014         _balances[account] = _balances[account].add(amount);
1015         emit Transfer(address(0), account, amount);
1016     }
1017 
1018     /**
1019      * @dev Destroys `amount` tokens from `account`, reducing the
1020      * total supply.
1021      *
1022      * Emits a {Transfer} event with `to` set to the zero address.
1023      *
1024      * Requirements
1025      *
1026      * - `account` cannot be the zero address.
1027      * - `account` must have at least `amount` tokens.
1028      */
1029     function _burn(address account, uint256 amount) internal virtual {
1030         require(account != address(0), "ERC20: burn from the zero address");
1031 
1032         _beforeTokenTransfer(account, address(0), amount);
1033 
1034         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1035         _totalSupply = _totalSupply.sub(amount);
1036         emit Transfer(account, address(0), amount);
1037     }
1038 
1039     /**
1040      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1041      *
1042      * This internal function is equivalent to `approve`, and can be used to
1043      * e.g. set automatic allowances for certain subsystems, etc.
1044      *
1045      * Emits an {Approval} event.
1046      *
1047      * Requirements:
1048      *
1049      * - `owner` cannot be the zero address.
1050      * - `spender` cannot be the zero address.
1051      */
1052     function _approve(address owner, address spender, uint256 amount) internal virtual {
1053         require(owner != address(0), "ERC20: approve from the zero address");
1054         require(spender != address(0), "ERC20: approve to the zero address");
1055 
1056         _allowances[owner][spender] = amount;
1057         emit Approval(owner, spender, amount);
1058     }
1059 
1060     /**
1061      * @dev Sets {decimals} to a value other than the default one of 18.
1062      *
1063      * WARNING: This function should only be called from the constructor. Most
1064      * applications that interact with token contracts will not expect
1065      * {decimals} to ever change, and may work incorrectly if it does.
1066      */
1067     function _setupDecimals(uint8 decimals_) internal {
1068         _decimals = decimals_;
1069     }
1070 
1071     /**
1072      * @dev Hook that is called before any transfer of tokens. This includes
1073      * minting and burning.
1074      *
1075      * Calling conditions:
1076      *
1077      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1078      * will be to transferred to `to`.
1079      * - when `from` is zero, `amount` tokens will be minted for `to`.
1080      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1081      * - `from` and `to` are never both zero.
1082      *
1083      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1084      */
1085     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1086 }
1087 
1088 interface IUniswapV2Router01 {
1089     function factory() external pure returns (address);
1090     function WETH() external pure returns (address);
1091 
1092     function addLiquidity(
1093         address tokenA,
1094         address tokenB,
1095         uint amountADesired,
1096         uint amountBDesired,
1097         uint amountAMin,
1098         uint amountBMin,
1099         address to,
1100         uint deadline
1101     ) external returns (uint amountA, uint amountB, uint liquidity);
1102     function addLiquidityETH(
1103         address token,
1104         uint amountTokenDesired,
1105         uint amountTokenMin,
1106         uint amountETHMin,
1107         address to,
1108         uint deadline
1109     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1110     function removeLiquidity(
1111         address tokenA,
1112         address tokenB,
1113         uint liquidity,
1114         uint amountAMin,
1115         uint amountBMin,
1116         address to,
1117         uint deadline
1118     ) external returns (uint amountA, uint amountB);
1119     function removeLiquidityETH(
1120         address token,
1121         uint liquidity,
1122         uint amountTokenMin,
1123         uint amountETHMin,
1124         address to,
1125         uint deadline
1126     ) external returns (uint amountToken, uint amountETH);
1127     function removeLiquidityWithPermit(
1128         address tokenA,
1129         address tokenB,
1130         uint liquidity,
1131         uint amountAMin,
1132         uint amountBMin,
1133         address to,
1134         uint deadline,
1135         bool approveMax, uint8 v, bytes32 r, bytes32 s
1136     ) external returns (uint amountA, uint amountB);
1137     function removeLiquidityETHWithPermit(
1138         address token,
1139         uint liquidity,
1140         uint amountTokenMin,
1141         uint amountETHMin,
1142         address to,
1143         uint deadline,
1144         bool approveMax, uint8 v, bytes32 r, bytes32 s
1145     ) external returns (uint amountToken, uint amountETH);
1146     function swapExactTokensForTokens(
1147         uint amountIn,
1148         uint amountOutMin,
1149         address[] calldata path,
1150         address to,
1151         uint deadline
1152     ) external returns (uint[] memory amounts);
1153     function swapTokensForExactTokens(
1154         uint amountOut,
1155         uint amountInMax,
1156         address[] calldata path,
1157         address to,
1158         uint deadline
1159     ) external returns (uint[] memory amounts);
1160     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1161         external
1162         payable
1163         returns (uint[] memory amounts);
1164     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1165         external
1166         returns (uint[] memory amounts);
1167     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1168         external
1169         returns (uint[] memory amounts);
1170     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1171         external
1172         payable
1173         returns (uint[] memory amounts);
1174 
1175     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1176     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1177     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1178     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1179     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1180 }
1181 
1182 interface IUniswapV2Router02 is IUniswapV2Router01 {
1183     function removeLiquidityETHSupportingFeeOnTransferTokens(
1184         address token,
1185         uint liquidity,
1186         uint amountTokenMin,
1187         uint amountETHMin,
1188         address to,
1189         uint deadline
1190     ) external returns (uint amountETH);
1191     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1192         address token,
1193         uint liquidity,
1194         uint amountTokenMin,
1195         uint amountETHMin,
1196         address to,
1197         uint deadline,
1198         bool approveMax, uint8 v, bytes32 r, bytes32 s
1199     ) external returns (uint amountETH);
1200 
1201     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1202         uint amountIn,
1203         uint amountOutMin,
1204         address[] calldata path,
1205         address to,
1206         uint deadline
1207     ) external;
1208     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1209         uint amountOutMin,
1210         address[] calldata path,
1211         address to,
1212         uint deadline
1213     ) external payable;
1214     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1215         uint amountIn,
1216         uint amountOutMin,
1217         address[] calldata path,
1218         address to,
1219         uint deadline
1220     ) external;
1221 }
1222 
1223 interface IUniswapV2Factory {
1224     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1225 
1226     function feeTo() external view returns (address);
1227     function feeToSetter() external view returns (address);
1228 
1229     function getPair(address tokenA, address tokenB) external view returns (address pair);
1230     function allPairs(uint) external view returns (address pair);
1231     function allPairsLength() external view returns (uint);
1232 
1233     function createPair(address tokenA, address tokenB) external returns (address pair);
1234 
1235     function setFeeTo(address) external;
1236     function setFeeToSetter(address) external;
1237 }
1238 
1239 // 
1240 /**
1241  * @dev Contract module which provides a basic access control mechanism, where
1242  * there is an account (an admin) that can be granted exclusive access to
1243  * specific functions.
1244  *
1245  * By default, the admin account will be the one that deploys the contract. This
1246  * can later be changed with {transferAdmin}.
1247  *
1248  * This module is used through inheritance. It will make available the modifier
1249  * `onlyAdmin`, which can be applied to your functions to restrict their use to
1250  * the owner.
1251  */
1252 contract Administrable is Context {
1253     address private _admin;
1254 
1255     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
1256 
1257     /**
1258      * @dev Initializes the contract setting the deployer as the initial admin.
1259      */
1260     constructor () internal {
1261         address msgSender = _msgSender();
1262         _admin = msgSender;
1263         emit AdminTransferred(address(0), msgSender);
1264     }
1265 
1266     /**
1267      * @dev Returns the address of the current admin.
1268      */
1269     function admin() public view returns (address) {
1270         return _admin;
1271     }
1272 
1273     /**
1274      * @dev Throws if called by any account other than the admin.
1275      */
1276     modifier onlyAdmin() {
1277         require(_admin == _msgSender(), "Administrable: caller is not the admin");
1278         _;
1279     }
1280 
1281     /**
1282      * @dev Leaves the contract without admin. It will not be possible to call
1283      * `onlyAdmin` functions anymore. Can only be called by the current admin.
1284      *
1285      * NOTE: Renouncing admin will leave the contract without an admin,
1286      * thereby removing any functionality that is only available to the admin.
1287      */
1288     function renounceAdmin() public virtual onlyAdmin {
1289         emit AdminTransferred(_admin, address(0));
1290         _admin = address(0);
1291     }
1292 
1293     /**
1294      * @dev Transfers admin of the contract to a new account (`newAdmin`).
1295      * Can only be called by the current ad,om.
1296      */
1297     function transferAdmin(address newAdmin) public virtual onlyAdmin {
1298         require(newAdmin != address(0), "Administrable: new admin is the zero address");
1299         emit AdminTransferred(_admin, newAdmin);
1300         _admin = newAdmin;
1301     }
1302 }
1303 
1304 // 
1305 abstract contract ERC20Payable {
1306 
1307     event Received(address indexed sender, uint256 amount);
1308 
1309     receive() external payable {
1310         emit Received(msg.sender, msg.value);
1311     }
1312 }
1313 
1314 // 
1315 interface ISecondaryToken {
1316     // placeholder interface for tokens generate from burn
1317     // could be used in future to pass the responsibility to a contract that
1318     // would then mint the burn with dynamic variables from nfts
1319 
1320     function mint(
1321         address account,
1322         uint256 amount
1323     ) external;
1324 }
1325 
1326 // 
1327 interface IProtocolAdapter {
1328     // Gets adapted burn divisor
1329     function getBurnDivisor(address _user, uint256 _currentBurnDivisor) external view returns (uint256);
1330 
1331     // Gets adapted farm rewards multiplier
1332     function getRewardsMultiplier(address _user, uint256 _currentRewardsMultiplier) external view returns (uint256);
1333 }
1334 
1335 // 
1336 /**
1337  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1338  * tokens and those that they have an allowance for, in a way that can be
1339  * recognized off-chain (via event analysis).
1340  */
1341 abstract contract ERC20Burnable is Context, ERC20BurnableMaxSupply {
1342     /**
1343      * @dev Destroys `amount` tokens from the caller. CANNOT BE USED TO BURN OTHER PEOPLES TOKENS
1344      * ONLY BBRA AND ONLY FROM THE PERSON CALLING THE FUNCTION
1345      *
1346      * See {ERC20-_burn}.
1347      */
1348     function burn(uint256 amount) public virtual {
1349         _burn(_msgSender(), amount);
1350     }
1351 }
1352 
1353 // 
1354 // Boo with Governance.
1355 // Ownership given to Farming contract and Adminship can be given to DAO contract
1356 contract BooBankerResearchAssociation is ERC20BurnableMaxSupply("BooBanker Research Association", "BBRA"), ERC20Burnable, Ownable, Administrable, ERC20Payable {
1357     using SafeMath for uint256;
1358 
1359     // uniswap info
1360     address public uniswapV2Router;
1361     address public uniswapV2Pair;
1362     address public uniswapV2Factory;
1363 
1364     // the amount burned tokens every transfer, i.e. 255 = 0.4%, 100 = 1%, 50 = 2%, 40 = 2.5%
1365     uint256 public burnDivisor;
1366     // the amount tokens saved for liquidity lock every transfer, i.e. 255 = 0.4%, 100 = 1%, 50 = 2%, 40 = 2.5%
1367     uint256 public liquidityDivisor;
1368 
1369     // If any token should be minted from burned $bbra (not $brra)
1370     ISecondaryToken public burnToken;
1371 
1372     // Dynamic burn regulator (less burn with a certain number of nfts etc)
1373     IProtocolAdapter public protocolAdapter;
1374 
1375     // Whether the protocol should reward those that spend their gas fees locking liquidity
1376     bool public rewardLiquidityLockCaller;
1377 
1378     // Pause trading after listing until x block - can only be used once
1379     bool public canPause;
1380     uint256 public pauseUntilBlock;
1381 
1382     // Timestamp of last liquidity lock call
1383     uint256 public lastLiquidityLock;
1384 
1385     // 1% of all transfers are sent to marketing fund
1386     address public _devaddr;
1387 
1388     // Events
1389     event LiquidityLock(uint256 tokenAmount, uint256 ethAmount);
1390     event LiquidityBurn(uint256 lpTokenAmount);
1391     event CallerReward(address caller, uint256 tokenAmount);
1392     event BuyBack(uint256 ethAmount, uint256 tokenAmount);
1393     event ProtocolAdapterChange(address _newProtocol);
1394 
1395     constructor(uint256 _burnDivisor, uint256 _liquidityDivisor) public {
1396 
1397         burnDivisor = _burnDivisor;
1398         liquidityDivisor = _liquidityDivisor;
1399         _devaddr = msg.sender;
1400         rewardLiquidityLockCaller = true;
1401         canPause = true;
1402         // initial quantity, 13k tokens
1403         _mint(msg.sender, 13e21);
1404     }
1405 
1406     function transferFrom(address sender, address recipient, uint256 amount) public checkRunning virtual override returns (bool) {
1407         uint256 onePct = amount.div(100);
1408         uint256 liquidityAmount = amount.div(liquidityDivisor);
1409         // Use dynamic burn divisor if Adapter contract is set
1410         uint256 burnAmount = amount.div(
1411             ( address(protocolAdapter) != address(0)
1412                 ? protocolAdapter.getBurnDivisor(pickHuman(sender, recipient), burnDivisor)
1413                 : burnDivisor
1414             )
1415         );
1416 
1417         _burn(sender, burnAmount);
1418 
1419         // Should a secondary token be given to recipient from burn amount?
1420         //
1421         if(address(burnToken) != address(0)) {
1422             burnToken.mint(recipient, burnAmount);
1423         }
1424 
1425         super.transferFrom(sender, _devaddr, onePct);
1426         super.transferFrom(sender, address(this), liquidityAmount);
1427         return super.transferFrom(sender, recipient, amount.sub(burnAmount).sub(liquidityAmount).sub(onePct));
1428     }
1429 
1430     function transfer(address recipient, uint256 amount) public checkRunning virtual override returns (bool) {
1431         uint256 onePct = amount.div(100);
1432         uint256 liquidityAmount = amount.div(liquidityDivisor);
1433         // Use dynamic burn divisor if Adapter contract is set
1434         uint256 burnAmount = amount.div(
1435             ( address(protocolAdapter) != address(0)
1436                 ? protocolAdapter.getBurnDivisor(pickHuman(msg.sender, recipient), burnDivisor)
1437                 : burnDivisor
1438             )
1439         );
1440 
1441         // do nft adapter
1442         _burn(msg.sender, burnAmount);
1443 
1444         // Should a secondary token be given to recipient from burn amount?
1445         if(address(burnToken) != address(0)) {
1446             burnToken.mint(recipient, burnAmount);
1447         }
1448 
1449         super.transfer(_devaddr, onePct);
1450         super.transfer(address(this), liquidityAmount);
1451         return super.transfer(recipient, amount.sub(burnAmount).sub(liquidityAmount).sub(onePct));
1452     }
1453 
1454     // Check if _from is human when calculating ProtocolAdapter settings (like burn)
1455     // so that if you're buying from Uniswap the adjusted burn still works
1456     function pickHuman(address _from, address _to) public view returns (address) {
1457         uint256 _codeLength;
1458         assembly {_codeLength := extcodesize(_from)}
1459         return _codeLength == 0 ? _from : _to;
1460     }
1461 
1462     /**
1463      * @dev Throws if called by any account other than the admin or owner.
1464      */
1465     modifier onlyAdminOrOwner() {
1466         require(admin() == _msgSender() || owner() == _msgSender(), "Ownable: caller is not the admin");
1467         _;
1468     }
1469 
1470     // To be used to stop trading at listing - prevent bots from buying
1471     modifier checkRunning(){
1472         require(block.number > pauseUntilBlock, "Go away bot");
1473         _;
1474     }
1475 
1476     // Trading can only be paused once, ever. Setting pauseUntilBlock to 0 resumes trading after pausing.
1477     function setPauseUntilBlock(uint256 _pauseUntilBlock) public onlyAdminOrOwner {
1478         require(canPause || _pauseUntilBlock == 0, 'Pause has already been used once. If disabling pause set block to 0');
1479         pauseUntilBlock = _pauseUntilBlock;
1480         // after the first pause we can no longer pause the protocol
1481         canPause = false;
1482     }
1483 
1484     /**
1485      * @dev prevents contracts from interacting with functions that have this modifier
1486      */
1487     modifier isHuman() {
1488         address _addr = msg.sender;
1489         uint256 _codeLength;
1490 
1491         assembly {_codeLength := extcodesize(_addr)}
1492 
1493 //        if (_codeLength == 0) {
1494 //            // use assert to consume all of the bots gas, kek
1495 //            assert(true == false, 'oh boy - bots get rekt');
1496 //        }
1497         require(_codeLength == 0, "sorry humans only");
1498         _;
1499     }
1500 
1501     // Sell half of burned tokens, provides liquidity and locks it away forever
1502     // can only be called when balance is > 1 and last lock is more than 2 hours ago
1503     function lockLiquidity() public isHuman() {
1504         // bbra balance
1505         uint256 _bal = balanceOf(address(this));
1506         require(uniswapV2Pair != address(0), "UniswapV2Pair not set in contract yet");
1507         require(uniswapV2Router != address(0), "UniswapV2Router not set in contract yet");
1508         require(_bal >= 1e18, "Minimum of 1 BBRA before we can lock liquidity");
1509         require(balanceOf(msg.sender) >= 5e18, "You must own at least 5 BBra to call lock");
1510 
1511         // caller rewards
1512         uint256 _callerReward = 0;
1513         if (rewardLiquidityLockCaller) {
1514             // subtract caller fee - 2% always
1515             _callerReward = _bal.div(50);
1516             _bal = _bal.sub(_callerReward);
1517         }
1518 
1519         // calculate ratios of bbra-eth for lp
1520         uint256 bbraToEth = _bal.div(2);
1521         uint256 brraForLiq = _bal.sub(bbraToEth);
1522 
1523         // Eth Balance before swap
1524         uint256 startingBalance = address(this).balance;
1525         swapTokensForWeth(bbraToEth);
1526 
1527         // due to price movements after selling it is likely that less than the amount of
1528         // eth received will be used for locking
1529         // instead of making the left over eth locked away forever we can call buyAndBurn() to buy back Bbra with leftover Eth
1530         uint256 ethFromBbra = address(this).balance.sub(startingBalance);
1531         addLiquidity(brraForLiq, ethFromBbra);
1532 
1533         emit LiquidityLock(brraForLiq, ethFromBbra);
1534 
1535         // only reward caller after trade to prevent any possible reentrancy
1536         // check balance is still available
1537         if (_callerReward != 0) {
1538             // in case LP takes more tokens than we are expecting reward _callerReward or balanceOf(this) - whichever is smallest
1539             if(balanceOf(address(this)) >= _callerReward) {
1540                 transfer(msg.sender, _callerReward);
1541             } else {
1542                 transfer(msg.sender, balanceOf(address(this)));
1543             }
1544         }
1545 
1546         lastLiquidityLock = block.timestamp;
1547     }
1548 
1549     // If for some reason we get more eth than expect from uniswap at time of locking liquidity
1550     // we buy and burn whatever amount of Bbra we get
1551     // can optout of burn so that instead it's added to the next liquidity lock instead
1552 
1553     // NOTE: Buy back not working due to address(this) being the token that we're buying from uniswap - apparently they
1554     // don't accept that. Leaving the code here however for anyone that wishes to adapt it and "fix" it
1555 //    function buyAndBurn(bool _burnTokens) public {
1556 //        // check minimum amount
1557 //        uint256 startingBbra = balanceOf(address(this));
1558 //        uint256 startingEth = address(this).balance;
1559 //
1560 //        require(startingEth >= 5e16, 'Contract balance must be at least 0.05 eth before invoking buyAndBurn');
1561 //
1562 //        swapWethForTokens(address(this).balance);
1563 //        uint256 buyBackAmount = startingBbra.sub(balanceOf(address(this)));
1564 //
1565 //        // if burn is active and we have bought some tokens back successfuly then burnnnn
1566 //        // if burn == false then tokens purchased will be used in liquidity at next lockLiquidity() call
1567 //        if(_burnTokens && buyBackAmount != 0) {
1568 //            // burn whatever amount was bought
1569 //            _burn(address(this), buyBackAmount);
1570 //        }
1571 //        emit BuyBack(startingEth.sub(address(this).balance), buyBackAmount);
1572 //    }
1573 //
1574 //    // buys bbra with left over eth - only called by liquidity lock function or buy&burn function
1575 //    function swapWethForTokens(uint256 ethAmount) internal {
1576 //        address[] memory uniswapPairPath = new address[](2);
1577 //        uniswapPairPath[0] = IUniswapV2Router02(uniswapV2Router).WETH();
1578 //        uniswapPairPath[1] = address(this);
1579 //
1580 //        IUniswapV2Router02(uniswapV2Router)
1581 //        .swapExactETHForTokensSupportingFeeOnTransferTokens{
1582 //        value: ethAmount
1583 //        }(
1584 //            0,
1585 //            uniswapPairPath,
1586 //            address(this),
1587 //            block.timestamp
1588 //        );
1589 //    }
1590 
1591     // swaps bra for eth - only called by liquidity lock function
1592     function swapTokensForWeth(uint256 tokenAmount) internal {
1593         address[] memory uniswapPairPath = new address[](2);
1594         uniswapPairPath[0] = address(this);
1595         uniswapPairPath[1] = IUniswapV2Router02(uniswapV2Router).WETH();
1596 
1597         _approve(address(this), uniswapV2Router, tokenAmount);
1598 
1599         IUniswapV2Router02(uniswapV2Router)
1600         .swapExactTokensForETHSupportingFeeOnTransferTokens(
1601             tokenAmount,
1602             0,
1603             uniswapPairPath,
1604             address(this),
1605             block.timestamp
1606         );
1607     }
1608 
1609     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
1610         // approve uniswapV2Router to transfer Brra
1611         _approve(address(this), uniswapV2Router, tokenAmount);
1612 
1613         // provide liquidity
1614         IUniswapV2Router02(uniswapV2Router)
1615         .addLiquidityETH{
1616             value: ethAmount
1617         }(
1618             address(this),
1619             tokenAmount,
1620             0,
1621             0,
1622             address(this),
1623             block.timestamp
1624         );
1625 
1626         // check LP balance
1627         uint256 _lpBalance = IERC20(uniswapV2Pair).balanceOf(address(this));
1628         if (_lpBalance != 0) {
1629             // transfer LP to burn address (aka locked forever)
1630             IERC20(uniswapV2Pair).transfer(address(0), _lpBalance);
1631             // any left over eth is sent to marketing for buy backs - will be a very minimal amount
1632             payable(_devaddr).transfer(address(this).balance);
1633             emit LiquidityBurn(_lpBalance);
1634         }
1635     }
1636 
1637     // returns amount of LP locked permanently
1638     function lockedLpAmount() public view returns(uint256) {
1639         if (uniswapV2Pair == address(0)) {
1640             return 0;
1641         }
1642 
1643         return IERC20(uniswapV2Pair).balanceOf(address(0));
1644     }
1645 
1646     // Whether Bbra should reward the person that pays for the gas calling the liquidity lock
1647     function setRewardLiquidityLockCaller(bool _rewardLiquidityLockCaller) public onlyAdminOrOwner {
1648         rewardLiquidityLockCaller = _rewardLiquidityLockCaller;
1649     }
1650 
1651     // Updates secondary token that could be minted from burned supply of BBRA (like BOOB mints ECTO on burn)
1652     function setSecondaryBurnToken(ISecondaryToken _token) public onlyAdminOrOwner {
1653         // this prevents the secondary token being itself and therefore negating burn
1654         require(address(_token) != address(this), 'Secondary token cannot be itself');
1655         // can be anything else, 0x0 disables secondary token usage
1656         burnToken = _token;
1657     }
1658 
1659     // Sets contract that regulates dynamic burn rates (changeable by DAO)
1660     function setProtocolAdapter(IProtocolAdapter _contract) public onlyAdminOrOwner {
1661         // setting to 0x0 disabled dynamic burn and is defaulted to regular burn
1662         protocolAdapter = _contract;
1663         emit ProtocolAdapterChange(address(_contract));
1664     }
1665 
1666     // self explanatory
1667     function setBurnRate(uint256 _burnDivisor) public onlyAdminOrOwner {
1668         require(_burnDivisor != 0, "Boo: burnDivisor must be bigger than 0");
1669         burnDivisor = _burnDivisor;
1670     }
1671 
1672     // self explanatory
1673     function setLiquidityDivisor(uint256 _liquidityDivisor) public onlyAdminOrOwner {
1674         require(_liquidityDivisor != 0, "Boo: _liquidityDivisor must be bigger than 0");
1675         liquidityDivisor = _liquidityDivisor;
1676     }
1677 
1678     /// @dev Creates `_amount` token to `_to`. Must only be called by the owner (MrBanker), used to mint farming rewards
1679     // and nothing else
1680     function mint(address _to, uint256 _amount) public onlyOwner {
1681         _mint(_to, _amount);
1682         _moveDelegates(address(0), _delegates[_to], _amount);
1683     }
1684 
1685     // Sets marketing address (where 1% is deposited)
1686     // Only owner can modify this (MrBanker)
1687     function setDevAddr(address _dev) public onlyOwner {
1688         _devaddr = _dev;
1689     }
1690 
1691     // sets uniswap router and LP pair addresses (needed for buy-back/sell and liquidity lock)
1692     function setUniswapAddresses(address _uniswapV2Factory, address _uniswapV2Router) public onlyAdminOrOwner {
1693         require(_uniswapV2Factory != address(0) && _uniswapV2Router != address(0), 'Uniswap addresses cannot be empty');
1694         uniswapV2Factory = _uniswapV2Factory;
1695         uniswapV2Router = _uniswapV2Router;
1696 
1697         if (uniswapV2Pair == address(0)) {
1698             createUniswapPair();
1699         }
1700     }
1701 
1702     // create LP pair if one hasn't been created
1703     // can be public, doesn't matter who calls it
1704     function createUniswapPair() public {
1705         require(uniswapV2Pair == address(0), "Pair has already been created");
1706         require(uniswapV2Factory != address(0) && uniswapV2Router != address(0), "Uniswap addresses have not been set");
1707 
1708         uniswapV2Pair = IUniswapV2Factory(uniswapV2Factory).createPair(
1709                 IUniswapV2Router02(uniswapV2Router).WETH(),
1710                 address(this)
1711         );
1712     }
1713 
1714     // Copied and modified from YAM code:
1715     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1716     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1717     // Which is copied and modified from COMPOUND:
1718     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1719 
1720     /// @dev A record of each accounts delegate
1721     mapping (address => address) internal _delegates;
1722 
1723     /// @dev A checkpoint for marking number of votes from a given block
1724     struct Checkpoint {
1725         uint32 fromBlock;
1726         uint256 votes;
1727     }
1728 
1729     /// @dev A record of votes checkpoints for each account, by index
1730     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1731 
1732     /// @dev The number of checkpoints for each account
1733     mapping (address => uint32) public numCheckpoints;
1734 
1735     /// @dev The EIP-712 typehash for the contract's domain
1736     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1737 
1738     /// @dev The EIP-712 typehash for the delegation struct used by the contract
1739     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1740 
1741     /// @dev A record of states for signing / validating signatures
1742     mapping (address => uint) public nonces;
1743 
1744     /// @dev An event thats emitted when an account changes its delegate
1745     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1746 
1747     /// @dev An event thats emitted when a delegate account's vote balance changes
1748     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1749 
1750     /**
1751      * @dev Delegate votes from `msg.sender` to `delegatee`
1752      * @param delegator The address to get delegatee for
1753      */
1754     function delegates(address delegator)
1755     external
1756     view
1757     returns (address)
1758     {
1759         return _delegates[delegator];
1760     }
1761 
1762     /**
1763      * @dev Delegate votes from `msg.sender` to `delegatee`
1764      * @param delegatee The address to delegate votes to
1765      */
1766     function delegate(address delegatee) external {
1767         return _delegate(msg.sender, delegatee);
1768     }
1769 
1770     /**
1771      * @dev Delegates votes from signatory to `delegatee`
1772      * @param delegatee The address to delegate votes to
1773      * @param nonce The contract state required to match the signature
1774      * @param expiry The time at which to expire the signature
1775      * @param v The recovery byte of the signature
1776      * @param r Half of the ECDSA signature pair
1777      * @param s Half of the ECDSA signature pair
1778      */
1779     function delegateBySig(
1780         address delegatee,
1781         uint nonce,
1782         uint expiry,
1783         uint8 v,
1784         bytes32 r,
1785         bytes32 s
1786     )
1787     external
1788     {
1789         bytes32 domainSeparator = keccak256(
1790             abi.encode(
1791                 DOMAIN_TYPEHASH,
1792                 keccak256(bytes(name())),
1793                 getChainId(),
1794                 address(this)
1795             )
1796         );
1797 
1798         bytes32 structHash = keccak256(
1799             abi.encode(
1800                 DELEGATION_TYPEHASH,
1801                 delegatee,
1802                 nonce,
1803                 expiry
1804             )
1805         );
1806 
1807         bytes32 digest = keccak256(
1808             abi.encodePacked(
1809                 "\x19\x01",
1810                 domainSeparator,
1811                 structHash
1812             )
1813         );
1814 
1815         address signatory = ecrecover(digest, v, r, s);
1816         require(signatory != address(0), "BOOB::delegateBySig: invalid signature");
1817         require(nonce == nonces[signatory]++, "BOOB::delegateBySig: invalid nonce");
1818         require(now <= expiry, "BOOB::delegateBySig: signature expired");
1819         return _delegate(signatory, delegatee);
1820     }
1821 
1822     /**
1823      * @dev Gets the current votes balance for `account`
1824      * @param account The address to get votes balance
1825      * @return The number of current votes for `account`
1826      */
1827     function getCurrentVotes(address account)
1828     external
1829     view
1830     returns (uint256)
1831     {
1832         uint32 nCheckpoints = numCheckpoints[account];
1833         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1834     }
1835 
1836     /**
1837      * @dev Determine the prior number of votes for an account as of a block number
1838      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1839      * @param account The address of the account to check
1840      * @param blockNumber The block number to get the vote balance at
1841      * @return The number of votes the account had as of the given block
1842      */
1843     function getPriorVotes(address account, uint blockNumber)
1844     external
1845     view
1846     returns (uint256)
1847     {
1848         require(blockNumber < block.number, "BOOB::getPriorVotes: not yet determined");
1849 
1850         uint32 nCheckpoints = numCheckpoints[account];
1851         if (nCheckpoints == 0) {
1852             return 0;
1853         }
1854 
1855         // First check most recent balance
1856         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1857             return checkpoints[account][nCheckpoints - 1].votes;
1858         }
1859 
1860         // Next check implicit zero balance
1861         if (checkpoints[account][0].fromBlock > blockNumber) {
1862             return 0;
1863         }
1864 
1865         uint32 lower = 0;
1866         uint32 upper = nCheckpoints - 1;
1867         while (upper > lower) {
1868             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1869             Checkpoint memory cp = checkpoints[account][center];
1870             if (cp.fromBlock == blockNumber) {
1871                 return cp.votes;
1872             } else if (cp.fromBlock < blockNumber) {
1873                 lower = center;
1874             } else {
1875                 upper = center - 1;
1876             }
1877         }
1878         return checkpoints[account][lower].votes;
1879     }
1880 
1881     function _delegate(address delegator, address delegatee)
1882     internal
1883     {
1884         address currentDelegate = _delegates[delegator];
1885         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BOOBs (not scaled);
1886         _delegates[delegator] = delegatee;
1887 
1888         emit DelegateChanged(delegator, currentDelegate, delegatee);
1889 
1890         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1891     }
1892 
1893     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1894         if (srcRep != dstRep && amount > 0) {
1895             if (srcRep != address(0)) {
1896                 // decrease old representative
1897                 uint32 srcRepNum = numCheckpoints[srcRep];
1898                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1899                 uint256 srcRepNew = srcRepOld.sub(amount);
1900                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1901             }
1902 
1903             if (dstRep != address(0)) {
1904                 // increase new representative
1905                 uint32 dstRepNum = numCheckpoints[dstRep];
1906                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1907                 uint256 dstRepNew = dstRepOld.add(amount);
1908                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1909             }
1910         }
1911     }
1912 
1913     function _writeCheckpoint(
1914         address delegatee,
1915         uint32 nCheckpoints,
1916         uint256 oldVotes,
1917         uint256 newVotes
1918     )
1919     internal
1920     {
1921         uint32 blockNumber = safe32(block.number, "BOOB::_writeCheckpoint: block number exceeds 32 bits");
1922 
1923         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1924             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1925         } else {
1926             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1927             numCheckpoints[delegatee] = nCheckpoints + 1;
1928         }
1929 
1930         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1931     }
1932 
1933     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1934         require(n < 2**32, errorMessage);
1935         return uint32(n);
1936     }
1937 
1938     function getChainId() internal pure returns (uint) {
1939         uint256 chainId;
1940         assembly { chainId := chainid() }
1941         return chainId;
1942     }
1943 }
1944 
1945 // 
1946 // MrBanker is the master of BooBank. He can make BooBank and he is a fair guy.
1947 //
1948 // Note that it's ownable and the owner wields tremendous power. The ownership
1949 // will be transferred to a governance smart contract once BBRA is sufficiently
1950 // distributed and the community can show to govern itself.
1951 //
1952 // Have fun reading it. Hopefully it's bug-free. God bless.
1953 contract BraShop is Ownable {
1954     using SafeMath for uint256;
1955     using SafeERC20 for IERC20;
1956 
1957     // Info of each user.
1958     struct UserInfo {
1959         uint256 amount;     // How many LP tokens the user has provided.
1960         uint256 rewardDebt; // Reward debt. See explanation below.
1961         uint256 lastDeposit; // block.timestamp
1962         uint256 earlyBaseRewardMultiplier;
1963         uint256 latestMultiplier;
1964     }
1965 
1966     // Protocol Adapter to regulate extra farming rewards from holding NFT and certain tokens
1967     IProtocolAdapter public protocolAdapter;
1968 
1969     // Info of each pool.
1970     struct PoolInfo {
1971         IERC20 lpToken;           // Address of LP token contract.
1972         uint256 allocPoint;       // How many allocation points assigned to this pool. BBRAs to distribute per block.
1973         uint256 lastRewardBlock;  // Last block number that BBRAs distribution occurs.
1974         uint256 accSushiPerShare; // Accumulated BBRAs per share, times 1e12. See below.
1975     }
1976 
1977     // The BBRA TOKEN!
1978     BooBankerResearchAssociation public sushi;
1979     // Dev address.
1980     address public devaddr;
1981     // Block number when bonus BBRA period ends.
1982     uint256 public bonusEndBlock;
1983     // BBRA tokens created per block.
1984     uint256 public sushiPerBlock;
1985     // Block number when early lp rewards end.
1986     uint256 public bonusLpEndBlock;
1987     // Bonus muliplier for early boob makers.
1988     uint256 public BONUS_MULTIPLIER = 1;
1989 
1990     // penalties for withdrawing within first x days of deposit
1991     // within d1 = 33.33%, d2 = 20%, d3 = 10%, d4 = 5%, on and after d5 = 0%
1992     uint32[] public earlyWithdrawalPenalties = [3, 5, 10, 20];
1993 
1994     // The migrator contract removed. It has a lot of power. Can only be set through governance (owner).
1995 
1996     // Info of each pool.
1997     PoolInfo[] public poolInfo;
1998     // Info of each user that stakes LP tokens.
1999     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
2000     // Total allocation points. Must be the sum of all allocation points in all pools.
2001     uint256 public totalAllocPoint = 0;
2002     // The block number when BBRA mining starts.
2003     uint256 public startBlock;
2004     // Don't add same pool twice https://twitter.com/Quantstamp/status/1301280989906231296
2005     mapping (address => bool) private poolIsAdded;
2006 
2007     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
2008     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
2009     event EarlyAdopter(address indexed user, uint256 indexed pid, uint256 amount);
2010     event ProtocolAdapterChange(address _newProtocol);
2011 
2012     constructor(
2013         BooBankerResearchAssociation _sushi,
2014         address _devaddr,
2015         uint256 _sushiPerBlock,
2016         uint256 _startBlock,
2017         uint256 _bonusLpEndBlock
2018     ) public {
2019         sushi = _sushi;
2020         devaddr = _devaddr;
2021         sushiPerBlock = _sushiPerBlock;
2022         bonusLpEndBlock = _bonusLpEndBlock;
2023         startBlock = _startBlock;
2024     }
2025 
2026     function getUserRewardsMultiplier(address _user, uint256 _current) public view returns (uint256) {
2027         if (address(protocolAdapter) == address(0))
2028             return _current;
2029 
2030         return protocolAdapter.getRewardsMultiplier(_user, _current);
2031     }
2032 
2033     function getUserWithdrawalPenalty(uint256 _depositTime) public view returns (uint256) {
2034 
2035         uint256 _int = block.timestamp.sub(_depositTime).div(86400);
2036 
2037         if (_int > (earlyWithdrawalPenalties.length - 1))
2038             return 0;
2039 
2040         return earlyWithdrawalPenalties[_int];
2041     }
2042 
2043     // Deposit LP tokens to MrBanker for BBRA allocation.
2044     function deposit(uint256 _pid, uint256 _amount) public {
2045         PoolInfo storage pool = poolInfo[_pid];
2046         UserInfo storage user = userInfo[_pid][msg.sender];
2047         updatePool(_pid);
2048 
2049         user.earlyBaseRewardMultiplier = getUserBaseRewards(user.earlyBaseRewardMultiplier);
2050 
2051         // multiplier at time of deposit must be maintained when withdrawing - otherwise lowest is selected
2052         uint256 _currentMultiplier = getUserRewardsMultiplier(msg.sender, user.earlyBaseRewardMultiplier);
2053 
2054         if (user.amount != 0) {
2055             uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
2056             uint256 penaltyDivisor = getUserWithdrawalPenalty(user.lastDeposit);
2057             uint256 penaltyToBurn;
2058 
2059             if (penaltyDivisor != 0) {
2060                 penaltyToBurn = pending.div(penaltyDivisor);
2061                 pending = pending.sub(penaltyToBurn);
2062             }
2063 
2064             safeSushiTransfer(msg.sender, pending);
2065 
2066             // burn any early withdraw penalties
2067             if (penaltyToBurn != 0) {
2068                 sushi.burn(penaltyToBurn);
2069             }
2070 
2071             if (user.latestMultiplier > 100) {
2072                 // since pool balance isn't calculated on individual contributions we must mint the early adopters rewards
2073                 // as we might come short otherwise.
2074                 sushi.mint(msg.sender, pending.mul(
2075                     // pick the smallest of current multiplier and multiplier at time of initial deposit
2076                     (user.latestMultiplier > _currentMultiplier ? _currentMultiplier : user.latestMultiplier)
2077                 ).div(100).sub(pending));
2078             }
2079         }
2080 
2081         user.amount = user.amount.add(_amount);
2082         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
2083         user.latestMultiplier = _currentMultiplier;
2084 
2085         if (_amount !=  0) {
2086             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
2087             // only reset clock when actually depositing. On _amount == 0 it only withdraws rewards
2088             user.lastDeposit = block.timestamp;
2089         }
2090     }
2091 
2092     // Withdraw LP tokens from MrBanker.
2093     function withdraw(uint256 _pid, uint256 _amount) public {
2094         PoolInfo storage pool = poolInfo[_pid];
2095         UserInfo storage user = userInfo[_pid][msg.sender];
2096         require(user.amount >= _amount, "withdraw: not good");
2097         updatePool(_pid);
2098         user.earlyBaseRewardMultiplier = getUserBaseRewards(user.earlyBaseRewardMultiplier);
2099         // multiplier at time of deposit must be maintained when withdrawing - otherwise lowest is selected
2100         uint256 _currentMultiplier = getUserRewardsMultiplier(msg.sender, user.earlyBaseRewardMultiplier);
2101 
2102         uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
2103         // check penalties
2104         uint256 penaltyDivisor = getUserWithdrawalPenalty(user.lastDeposit);
2105         uint256 penaltyToBurn;
2106 
2107         if (penaltyDivisor != 0) {
2108             penaltyToBurn = pending.div(penaltyDivisor);
2109             pending = pending.sub(penaltyToBurn);
2110         }
2111 
2112         safeSushiTransfer(msg.sender, pending);
2113 
2114         // burn any early withdraw penalties
2115         if (penaltyToBurn != 0) {
2116             sushi.burn(penaltyToBurn);
2117         }
2118 
2119         if (user.latestMultiplier > 100) {
2120             // since pool balance isn't calculated on individual contributions we must mint the early adopters rewards
2121             // as we might come short otherwise.
2122             sushi.mint(msg.sender, pending.mul(
2123             // pick the smallest of current multiplier and multiplier at time of initial deposit
2124                 (user.latestMultiplier > _currentMultiplier ? _currentMultiplier : user.latestMultiplier)
2125             ).div(100).sub(pending));
2126         }
2127 
2128         user.amount = user.amount.sub(_amount);
2129         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
2130         user.latestMultiplier = _currentMultiplier;
2131 
2132         // 1% of all withdrawn LP is locked away forever
2133         uint256 burnedLp = _amount.div(100);
2134         pool.lpToken.safeTransfer(address(msg.sender), _amount.sub(burnedLp));
2135         pool.lpToken.safeTransfer(address(0), burnedLp);
2136         emit Withdraw(msg.sender, _pid, _amount);
2137     }
2138 
2139     function getUserBaseRewards(uint256 _current) public view returns (uint256) {
2140         if (block.number > bonusLpEndBlock && _current > 100) {
2141             // reset early LP rewards after bonusLpEndBlock block
2142             // nft rewards still count
2143             _current = 100;
2144         }
2145 
2146         if (block.number < startBlock) {
2147             _current = 110;
2148         }
2149 
2150         if (_current == 0) {
2151             _current = 100;
2152         }
2153 
2154         return _current;
2155     }
2156 
2157     // Safe boo transfer function, just in case if rounding error causes pool to not have enough BBRAs.
2158     function safeSushiTransfer(address _to, uint256 _amount) internal {
2159         uint256 sushiBal = sushi.balanceOf(address(this));
2160         if (_amount > sushiBal) {
2161             sushi.transfer(_to, sushiBal);
2162         } else {
2163             sushi.transfer(_to, _amount);
2164         }
2165     }
2166 
2167     // Update reward variables of the given pool to be up-to-date.
2168     function updatePool(uint256 _pid) public {
2169         PoolInfo storage pool = poolInfo[_pid];
2170         if (block.number <= pool.lastRewardBlock) {
2171             return;
2172         }
2173         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2174         if (lpSupply == 0) {
2175             pool.lastRewardBlock = block.number;
2176             return;
2177         }
2178         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
2179         uint256 sushiReward = multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
2180         sushi.mint(address(this), sushiReward);
2181         pool.accSushiPerShare = pool.accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
2182         pool.lastRewardBlock = block.number;
2183     }
2184 
2185     // Return reward multiplier over the given _from to _to block.
2186     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
2187         if (_to <= bonusEndBlock) {
2188             return _to.sub(_from).mul(BONUS_MULTIPLIER);
2189         } else if (_from >= bonusEndBlock) {
2190             return _to.sub(_from);
2191         } else {
2192             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
2193                 _to.sub(bonusEndBlock)
2194             );
2195         }
2196     }
2197 
2198     // Withdraw without caring about rewards. EMERGENCY ONLY.
2199     function emergencyWithdraw(uint256 _pid) public {
2200         PoolInfo storage pool = poolInfo[_pid];
2201         UserInfo storage user = userInfo[_pid][msg.sender];
2202         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
2203         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
2204         user.amount = 0;
2205         user.rewardDebt = 0;
2206     }
2207 
2208     // Sets contract that regulates dynamic farm rewards and burn rates (changeable by DAO)
2209     function setProtocolAdapter(IProtocolAdapter _contract) public onlyOwner {
2210         // setting to 0x0 disabled nft rewards
2211         protocolAdapter = _contract;
2212         emit ProtocolAdapterChange(address(_contract));
2213     }
2214 
2215     // Add a new lp to the pool. Can only be called by the owner.
2216     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
2217     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
2218         require(poolIsAdded[address(_lpToken)] == false, 'add: pool already added');
2219         poolIsAdded[address(_lpToken)] = true;
2220 
2221         if (_withUpdate) {
2222             massUpdatePools();
2223         }
2224         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
2225         totalAllocPoint = totalAllocPoint.add(_allocPoint);
2226         poolInfo.push(PoolInfo({
2227         lpToken: _lpToken,
2228         allocPoint: _allocPoint,
2229         lastRewardBlock: lastRewardBlock,
2230         accSushiPerShare: 0
2231         }));
2232     }
2233 
2234     // Update the given pool's BBRA allocation point. Can only be called by the owner.
2235     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
2236         if (_withUpdate) {
2237             massUpdatePools();
2238         }
2239         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
2240         poolInfo[_pid].allocPoint = _allocPoint;
2241     }
2242 
2243     // Update reward variables for all pools. Be careful of gas spending!
2244     function massUpdatePools() public {
2245         uint256 length = poolInfo.length;
2246         for (uint256 pid = 0; pid < length; ++pid) {
2247             updatePool(pid);
2248         }
2249     }
2250 
2251     function poolLength() external view returns (uint256) {
2252         return poolInfo.length;
2253     }
2254 
2255     function setStartBlock(uint256 _startBlock) public onlyOwner {
2256         startBlock = _startBlock;
2257     }
2258 
2259     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
2260         bonusEndBlock = _bonusEndBlock;
2261     }
2262 
2263     function setBonusLpEndBlock(uint256 _bonusLpEndBlock) public onlyOwner {
2264         bonusLpEndBlock = _bonusLpEndBlock;
2265     }
2266 
2267     // Updates bonus multiplier for early farmers
2268     function setBonusMultiplier(uint256 _bonusMultiplier) public onlyOwner {
2269         BONUS_MULTIPLIER = _bonusMultiplier;
2270     }
2271 
2272     // Sets reward per block
2273     function setRewardPerBlock(uint256 _rewardPerBlock, bool _withUpdate) public onlyOwner {
2274         // if last a pool was update is a while ago it's best to update pools so no rewards go missing
2275         if (_withUpdate) {
2276             massUpdatePools();
2277         }
2278         sushiPerBlock = _rewardPerBlock;
2279     }
2280 
2281     // View function to see pending BBRAs on frontend.
2282     function pendingSushi(uint256 _pid, address _user) external view returns (uint256) {
2283         PoolInfo storage pool = poolInfo[_pid];
2284         UserInfo storage user = userInfo[_pid][_user];
2285         uint256 accSushiPerShare = pool.accSushiPerShare;
2286         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2287         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
2288             uint256 _sushiPerBlock = sushiPerBlock;
2289 
2290             uint256 _earlyBaseRewardMultiplier = getUserBaseRewards(user.earlyBaseRewardMultiplier);
2291 
2292             // multiplier at time of deposit must be maintained when withdrawing - otherwise lowest is selected
2293             uint256 _currentMultiplier = getUserRewardsMultiplier(_user, _earlyBaseRewardMultiplier);
2294             _sushiPerBlock = _sushiPerBlock.mul(_currentMultiplier).div(100);
2295 
2296             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
2297             uint256 sushiReward = multiplier.mul(_sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
2298             accSushiPerShare = accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
2299         }
2300         return user.amount.mul(accSushiPerShare).div(1e12).sub(user.rewardDebt);
2301     }
2302 
2303     // Set burn rate for Bbra
2304     function setBurnRate(uint8 _burnDivisor) public onlyOwner {
2305         require(_burnDivisor != 0, "Boo: burnDivisor must be bigger than 0");
2306         sushi.setBurnRate(_burnDivisor);
2307     }
2308 
2309     function updateDevAddre(address _devaddr) public {
2310         // Minting to 0 address reverts and breaks harvesting
2311         require(_devaddr != address(0), "dev: don't set to 0 address");
2312         require(msg.sender == devaddr, "dev: wut?");
2313         devaddr = _devaddr;
2314         sushi.setDevAddr(_devaddr);
2315     }
2316 }