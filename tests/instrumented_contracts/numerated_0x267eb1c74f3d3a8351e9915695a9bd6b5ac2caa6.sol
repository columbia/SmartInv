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
799 contract ERC20 is Context, IERC20 {
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
988      * Emits a {Transfer} event with `from` set to the zero address.
989      *
990      * Requirements
991      *
992      * - `to` cannot be the zero address.
993      */
994     function _mint(address account, uint256 amount) internal virtual {
995         require(account != address(0), "ERC20: mint to the zero address");
996 
997         _beforeTokenTransfer(address(0), account, amount);
998 
999         _totalSupply = _totalSupply.add(amount);
1000         _balances[account] = _balances[account].add(amount);
1001         emit Transfer(address(0), account, amount);
1002     }
1003 
1004     /**
1005      * @dev Destroys `amount` tokens from `account`, reducing the
1006      * total supply.
1007      *
1008      * Emits a {Transfer} event with `to` set to the zero address.
1009      *
1010      * Requirements
1011      *
1012      * - `account` cannot be the zero address.
1013      * - `account` must have at least `amount` tokens.
1014      */
1015     function _burn(address account, uint256 amount) internal virtual {
1016         require(account != address(0), "ERC20: burn from the zero address");
1017 
1018         _beforeTokenTransfer(account, address(0), amount);
1019 
1020         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1021         _totalSupply = _totalSupply.sub(amount);
1022         emit Transfer(account, address(0), amount);
1023     }
1024 
1025     /**
1026      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1027      *
1028      * This internal function is equivalent to `approve`, and can be used to
1029      * e.g. set automatic allowances for certain subsystems, etc.
1030      *
1031      * Emits an {Approval} event.
1032      *
1033      * Requirements:
1034      *
1035      * - `owner` cannot be the zero address.
1036      * - `spender` cannot be the zero address.
1037      */
1038     function _approve(address owner, address spender, uint256 amount) internal virtual {
1039         require(owner != address(0), "ERC20: approve from the zero address");
1040         require(spender != address(0), "ERC20: approve to the zero address");
1041 
1042         _allowances[owner][spender] = amount;
1043         emit Approval(owner, spender, amount);
1044     }
1045 
1046     /**
1047      * @dev Sets {decimals} to a value other than the default one of 18.
1048      *
1049      * WARNING: This function should only be called from the constructor. Most
1050      * applications that interact with token contracts will not expect
1051      * {decimals} to ever change, and may work incorrectly if it does.
1052      */
1053     function _setupDecimals(uint8 decimals_) internal {
1054         _decimals = decimals_;
1055     }
1056 
1057     /**
1058      * @dev Hook that is called before any transfer of tokens. This includes
1059      * minting and burning.
1060      *
1061      * Calling conditions:
1062      *
1063      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1064      * will be to transferred to `to`.
1065      * - when `from` is zero, `amount` tokens will be minted for `to`.
1066      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1067      * - `from` and `to` are never both zero.
1068      *
1069      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1070      */
1071     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1072 }
1073 
1074 interface IUniswapV2Router01 {
1075     function factory() external pure returns (address);
1076     function WETH() external pure returns (address);
1077 
1078     function addLiquidity(
1079         address tokenA,
1080         address tokenB,
1081         uint amountADesired,
1082         uint amountBDesired,
1083         uint amountAMin,
1084         uint amountBMin,
1085         address to,
1086         uint deadline
1087     ) external returns (uint amountA, uint amountB, uint liquidity);
1088     function addLiquidityETH(
1089         address token,
1090         uint amountTokenDesired,
1091         uint amountTokenMin,
1092         uint amountETHMin,
1093         address to,
1094         uint deadline
1095     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1096     function removeLiquidity(
1097         address tokenA,
1098         address tokenB,
1099         uint liquidity,
1100         uint amountAMin,
1101         uint amountBMin,
1102         address to,
1103         uint deadline
1104     ) external returns (uint amountA, uint amountB);
1105     function removeLiquidityETH(
1106         address token,
1107         uint liquidity,
1108         uint amountTokenMin,
1109         uint amountETHMin,
1110         address to,
1111         uint deadline
1112     ) external returns (uint amountToken, uint amountETH);
1113     function removeLiquidityWithPermit(
1114         address tokenA,
1115         address tokenB,
1116         uint liquidity,
1117         uint amountAMin,
1118         uint amountBMin,
1119         address to,
1120         uint deadline,
1121         bool approveMax, uint8 v, bytes32 r, bytes32 s
1122     ) external returns (uint amountA, uint amountB);
1123     function removeLiquidityETHWithPermit(
1124         address token,
1125         uint liquidity,
1126         uint amountTokenMin,
1127         uint amountETHMin,
1128         address to,
1129         uint deadline,
1130         bool approveMax, uint8 v, bytes32 r, bytes32 s
1131     ) external returns (uint amountToken, uint amountETH);
1132     function swapExactTokensForTokens(
1133         uint amountIn,
1134         uint amountOutMin,
1135         address[] calldata path,
1136         address to,
1137         uint deadline
1138     ) external returns (uint[] memory amounts);
1139     function swapTokensForExactTokens(
1140         uint amountOut,
1141         uint amountInMax,
1142         address[] calldata path,
1143         address to,
1144         uint deadline
1145     ) external returns (uint[] memory amounts);
1146     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1147         external
1148         payable
1149         returns (uint[] memory amounts);
1150     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1151         external
1152         returns (uint[] memory amounts);
1153     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1154         external
1155         returns (uint[] memory amounts);
1156     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1157         external
1158         payable
1159         returns (uint[] memory amounts);
1160 
1161     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1162     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1163     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1164     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1165     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1166 }
1167 
1168 interface IUniswapV2Router02 is IUniswapV2Router01 {
1169     function removeLiquidityETHSupportingFeeOnTransferTokens(
1170         address token,
1171         uint liquidity,
1172         uint amountTokenMin,
1173         uint amountETHMin,
1174         address to,
1175         uint deadline
1176     ) external returns (uint amountETH);
1177     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1178         address token,
1179         uint liquidity,
1180         uint amountTokenMin,
1181         uint amountETHMin,
1182         address to,
1183         uint deadline,
1184         bool approveMax, uint8 v, bytes32 r, bytes32 s
1185     ) external returns (uint amountETH);
1186 
1187     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1188         uint amountIn,
1189         uint amountOutMin,
1190         address[] calldata path,
1191         address to,
1192         uint deadline
1193     ) external;
1194     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1195         uint amountOutMin,
1196         address[] calldata path,
1197         address to,
1198         uint deadline
1199     ) external payable;
1200     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1201         uint amountIn,
1202         uint amountOutMin,
1203         address[] calldata path,
1204         address to,
1205         uint deadline
1206     ) external;
1207 }
1208 
1209 interface IUniswapV2Factory {
1210     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1211 
1212     function feeTo() external view returns (address);
1213     function feeToSetter() external view returns (address);
1214 
1215     function getPair(address tokenA, address tokenB) external view returns (address pair);
1216     function allPairs(uint) external view returns (address pair);
1217     function allPairsLength() external view returns (uint);
1218 
1219     function createPair(address tokenA, address tokenB) external returns (address pair);
1220 
1221     function setFeeTo(address) external;
1222     function setFeeToSetter(address) external;
1223 }
1224 
1225 // 
1226 /**
1227  * @dev Contract module which provides a basic access control mechanism, where
1228  * there is an account (an admin) that can be granted exclusive access to
1229  * specific functions.
1230  *
1231  * By default, the admin account will be the one that deploys the contract. This
1232  * can later be changed with {transferAdmin}.
1233  *
1234  * This module is used through inheritance. It will make available the modifier
1235  * `onlyAdmin`, which can be applied to your functions to restrict their use to
1236  * the owner.
1237  */
1238 contract Administrable is Context {
1239     address private _admin;
1240 
1241     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
1242 
1243     /**
1244      * @dev Initializes the contract setting the deployer as the initial admin.
1245      */
1246     constructor () internal {
1247         address msgSender = _msgSender();
1248         _admin = msgSender;
1249         emit AdminTransferred(address(0), msgSender);
1250     }
1251 
1252     /**
1253      * @dev Returns the address of the current admin.
1254      */
1255     function admin() public view returns (address) {
1256         return _admin;
1257     }
1258 
1259     /**
1260      * @dev Throws if called by any account other than the admin.
1261      */
1262     modifier onlyAdmin() {
1263         require(_admin == _msgSender(), "Administrable: caller is not the admin");
1264         _;
1265     }
1266 
1267     /**
1268      * @dev Leaves the contract without admin. It will not be possible to call
1269      * `onlyAdmin` functions anymore. Can only be called by the current admin.
1270      *
1271      * NOTE: Renouncing admin will leave the contract without an admin,
1272      * thereby removing any functionality that is only available to the admin.
1273      */
1274     function renounceAdmin() public virtual onlyAdmin {
1275         emit AdminTransferred(_admin, address(0));
1276         _admin = address(0);
1277     }
1278 
1279     /**
1280      * @dev Transfers admin of the contract to a new account (`newAdmin`).
1281      * Can only be called by the current ad,om.
1282      */
1283     function transferAdmin(address newAdmin) public virtual onlyAdmin {
1284         require(newAdmin != address(0), "Administrable: new admin is the zero address");
1285         emit AdminTransferred(_admin, newAdmin);
1286         _admin = newAdmin;
1287     }
1288 }
1289 
1290 // 
1291 abstract contract ERC20Payable {
1292 
1293     event Received(address indexed sender, uint256 amount);
1294 
1295     receive() external payable {
1296         emit Received(msg.sender, msg.value);
1297     }
1298 }
1299 
1300 // 
1301 interface IProtocolAdapter {
1302     // Gets adapted burn divisor
1303     function getBurnDivisor(address _user, uint256 _currentBurnDivisor) external view returns (uint256);
1304 
1305     // Gets adapted farm rewards multiplier
1306     function getRewardsMultiplier(address _user, uint256 _currentRewardsMultiplier) external view returns (uint256);
1307 }
1308 
1309 // 
1310 /**
1311  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1312  * tokens and those that they have an allowance for, in a way that can be
1313  * recognized off-chain (via event analysis).
1314  */
1315 abstract contract ERC20Burnable is Context, ERC20 {
1316     /**
1317      * @dev Destroys `amount` tokens from the caller. CANNOT BE USED TO BURN OTHER PEOPLES TOKENS
1318      * ONLY BBRA AND ONLY FROM THE PERSON CALLING THE FUNCTION
1319      *
1320      * See {ERC20-_burn}.
1321      */
1322     function burn(uint256 amount) public virtual {
1323         _burn(_msgSender(), amount);
1324     }
1325 }
1326 
1327 // 
1328 // Boo with Governance.
1329 // Ownership given to Farming contract and Adminship can be given to DAO contract
1330 contract Gr1m is ERC20("Gr1m", "GR1M"), ERC20Burnable, Ownable, Administrable, ERC20Payable {
1331     using SafeMath for uint256;
1332 
1333     // uniswap info
1334     address public uniswapV2Router;
1335     address public uniswapV2Pair;
1336     address public uniswapV2Factory;
1337 
1338     // the amount burned tokens every transfer, i.e. 255 = 0.4%, 100 = 1%, 50 = 2%, 40 = 2.5%
1339     uint256 public burnDivisor;
1340     // the amount tokens saved for liquidity lock every transfer, i.e. 255 = 0.4%, 100 = 1%, 50 = 2%, 40 = 2.5%
1341     uint256 public liquidityDivisor;
1342 
1343     // Dynamic burn regulator (less burn with a certain number of nfts etc)
1344     IProtocolAdapter public protocolAdapter;
1345 
1346     // Timestamp of last liquidity lock call
1347     uint256 public lastLiquidityLock;
1348 
1349     // 1% of all transfers are sent to dev fund
1350     address public _devaddr;
1351 
1352     // 1% of all transfers are sent to marketing fund
1353     address public _marketingaddr;
1354 
1355     constructor() public {
1356         burnDivisor = 50;
1357         liquidityDivisor = 50;
1358         _marketingaddr = msg.sender;
1359         _devaddr = 0x29807F6f06ec2a7AD56ed1a6dB3C3648D4d88634;
1360 //        _mint(msg.sender, 1e23);
1361         // uniswapV2Factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
1362         // uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1363     }
1364 
1365     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1366         uint256 onePct = amount.div(100);
1367         uint256 liquidityAmount = amount.div(liquidityDivisor);
1368         // Use dynamic burn divisor if Adapter contract is set
1369         uint256 burnAmount = amount.div(
1370             ( address(protocolAdapter) != address(0)
1371                 ? protocolAdapter.getBurnDivisor(pickHuman(sender, recipient), burnDivisor)
1372                 : burnDivisor
1373             )
1374         );
1375 
1376         _burn(sender, burnAmount);
1377 
1378 
1379         if (_devaddr != address(0)) {
1380             super.transferFrom(sender, _devaddr, onePct);
1381         }
1382 
1383         super.transferFrom(sender, _marketingaddr, onePct);
1384         super.transferFrom(sender, address(this), liquidityAmount);
1385         return super.transferFrom(sender, recipient, amount.sub(burnAmount).sub(liquidityAmount).sub(onePct).sub(onePct));
1386     }
1387 
1388     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1389         uint256 onePct = amount.div(100);
1390         uint256 liquidityAmount = amount.div(liquidityDivisor);
1391         // Use dynamic burn divisor if Adapter contract is set
1392         uint256 burnAmount = amount.div(
1393             ( address(protocolAdapter) != address(0)
1394                 ? protocolAdapter.getBurnDivisor(pickHuman(msg.sender, recipient), burnDivisor)
1395                 : burnDivisor
1396             )
1397         );
1398 
1399         // do nft adapter
1400         _burn(msg.sender, burnAmount);
1401 
1402         if (_devaddr != address(0)) {
1403             super.transfer(_devaddr, onePct);
1404         }
1405         super.transfer(_marketingaddr, onePct);
1406         super.transfer(address(this), liquidityAmount);
1407         return super.transfer(recipient, amount.sub(burnAmount).sub(liquidityAmount).sub(onePct).sub(onePct));
1408     }
1409 
1410     // Check if _from is human when calculating ProtocolAdapter settings (like burn)
1411     // so that if you're buying from Uniswap the adjusted burn still works
1412     function pickHuman(address _from, address _to) public view returns (address) {
1413         uint256 _codeLength;
1414         assembly {_codeLength := extcodesize(_from)}
1415         return _codeLength == 0 ? _from : _to;
1416     }
1417 
1418     /**
1419      * @dev Throws if called by any account other than the admin or owner.
1420      */
1421     modifier onlyAdminOrOwner() {
1422         require(admin() == _msgSender() || owner() == _msgSender(), "Ownable: caller is not the admin");
1423         _;
1424     }
1425 
1426     /**
1427      * @dev Throws if called by any account other than the admin or owner.
1428      */
1429     modifier onlyDev() {
1430         require(_devaddr == _msgSender(), "Ownable: caller is not the admin");
1431         _;
1432     }
1433 
1434 
1435     /**
1436      * @dev prevents contracts from interacting with functions that have this modifier
1437      */
1438     modifier isHuman() {
1439         address _addr = msg.sender;
1440         uint256 _codeLength;
1441 
1442         assembly {_codeLength := extcodesize(_addr)}
1443 
1444 //        if (_codeLength == 0) {
1445 //            // use assert to consume all of the bots gas, kek
1446 //            assert(true == false, 'oh boy - bots get rekt');
1447 //        }
1448         require(_codeLength == 0, "sorry humans only");
1449         _;
1450     }
1451 
1452     // Sell half of burned tokens, provides liquidity and locks it away forever
1453     // can only be called when balance is > 1 and last lock is more than 2 hours ago
1454     function lockLiquidity() public isHuman() {
1455         // bbra balance
1456         uint256 _bal = balanceOf(address(this));
1457         require(uniswapV2Pair != address(0), "UniswapV2Pair not set in contract yet");
1458         require(uniswapV2Router != address(0), "UniswapV2Router not set in contract yet");
1459         require(_bal >= 1e18, "Minimum of 1 GR1M before we can lock liquidity");
1460 
1461         // caller rewards
1462         uint256 _callerReward = 0;
1463 
1464         // subtract caller fee - 2% always
1465         _callerReward = _bal.div(50);
1466         _bal = _bal.sub(_callerReward);
1467 
1468 
1469         // calculate ratios of bbra-eth for lp
1470         uint256 bbraToEth = _bal.div(2);
1471         uint256 brraForLiq = _bal.sub(bbraToEth);
1472 
1473         // Eth Balance before swap
1474         uint256 startingBalance = address(this).balance;
1475         swapTokensForWeth(bbraToEth);
1476 
1477         // due to price movements after selling it is likely that less than the amount of
1478         // eth received will be used for locking
1479         // instead of making the left over eth locked away forever we can call buyAndBurn() to buy back Bbra with leftover Eth
1480         uint256 ethFromBbra = address(this).balance.sub(startingBalance);
1481         addLiquidity(brraForLiq, ethFromBbra);
1482 
1483         // only reward caller after trade to prevent any possible reentrancy
1484         // check balance is still available
1485         if (_callerReward != 0) {
1486             // in case LP takes more tokens than we are expecting reward _callerReward or balanceOf(this) - whichever is smallest
1487             if(balanceOf(address(this)) >= _callerReward) {
1488                 super.transferFrom(address(this), msg.sender, _callerReward);
1489             } else {
1490                 super.transferFrom(address(this), msg.sender, balanceOf(address(this)));
1491             }
1492         }
1493 
1494         lastLiquidityLock = block.timestamp;
1495     }
1496 
1497     // swaps bra for eth - only called by liquidity lock function
1498     function swapTokensForWeth(uint256 tokenAmount) internal {
1499         address[] memory uniswapPairPath = new address[](2);
1500         uniswapPairPath[0] = address(this);
1501         uniswapPairPath[1] = IUniswapV2Router02(uniswapV2Router).WETH();
1502 
1503         _approve(address(this), uniswapV2Router, tokenAmount);
1504 
1505         IUniswapV2Router02(uniswapV2Router)
1506         .swapExactTokensForETHSupportingFeeOnTransferTokens(
1507             tokenAmount,
1508             0,
1509             uniswapPairPath,
1510             address(this),
1511             block.timestamp
1512         );
1513     }
1514 
1515     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
1516         // approve uniswapV2Router to transfer Brra
1517         _approve(address(this), uniswapV2Router, tokenAmount);
1518 
1519         // provide liquidity
1520         IUniswapV2Router02(uniswapV2Router)
1521         .addLiquidityETH{
1522             value: ethAmount
1523         }(
1524             address(this),
1525             tokenAmount,
1526             0,
1527             0,
1528             address(this),
1529             block.timestamp
1530         );
1531 
1532         // check LP balance
1533         uint256 _lpBalance = IERC20(uniswapV2Pair).balanceOf(address(this));
1534         if (_lpBalance != 0) {
1535             // transfer LP to burn address (aka locked forever)
1536             IERC20(uniswapV2Pair).transfer(address(0), _lpBalance);
1537             // any left over eth is sent to marketing for buy backs - will be a very minimal amount
1538             payable(_marketingaddr).transfer(address(this).balance);
1539         }
1540     }
1541 
1542     // returns amount of LP locked permanently
1543     function lockedLpAmount() public view returns(uint256) {
1544         if (uniswapV2Pair == address(0)) {
1545             return 0;
1546         }
1547 
1548         return IERC20(uniswapV2Pair).balanceOf(address(0));
1549     }
1550 
1551     // Sets contract that regulates dynamic burn rates (changeable by DAO)
1552     function setProtocolAdapter(IProtocolAdapter _contract) public onlyAdminOrOwner {
1553         // setting to 0x0 disabled dynamic burn and is defaulted to regular burn
1554         protocolAdapter = _contract;
1555     }
1556 
1557     // self explanatory
1558     function setBurnRate(uint256 _burnDivisor) public onlyAdminOrOwner {
1559         require(_burnDivisor != 0, "Boo: burnDivisor must be bigger than 0");
1560         burnDivisor = _burnDivisor;
1561     }
1562 
1563     // self explanatory
1564     function setLiquidityDivisor(uint256 _liquidityDivisor) public onlyAdminOrOwner {
1565         require(_liquidityDivisor != 0, "Boo: _liquidityDivisor must be bigger than 0");
1566         liquidityDivisor = _liquidityDivisor;
1567     }
1568 
1569     /// @dev Creates `_amount` token to `_to`. Must only be called by the owner (MrBanker), used to mint farming rewards
1570     // and nothing else
1571     function mint(address _to, uint256 _amount) public onlyOwner {
1572         _mint(_to, _amount);
1573     }
1574 
1575     // removes dev fee of 1% (irreversible)
1576     function unsetDevAddr() public onlyDev {
1577         _devaddr = address(0);
1578     }
1579 
1580     // Sets marketing address (where 1% is deposited)
1581     // Only owner can modify this (MrBanker)
1582     function setMarketingAddr(address _mark) public onlyAdminOrOwner {
1583         _marketingaddr = _mark;
1584     }
1585 
1586     // sets uniswap router and LP pair addresses (needed for buy-back/sell and liquidity lock)
1587     function setUniswapAddresses(address _uniswapV2Factory, address _uniswapV2Router) public onlyAdminOrOwner {
1588         require(_uniswapV2Factory != address(0) && _uniswapV2Router != address(0), 'Uniswap addresses cannot be empty');
1589         uniswapV2Factory = _uniswapV2Factory;
1590         uniswapV2Router = _uniswapV2Router;
1591 
1592         if (uniswapV2Pair == address(0)) {
1593             createUniswapPair();
1594         }
1595     }
1596 
1597     // create LP pair if one hasn't been created
1598     // can be public, doesn't matter who calls it
1599     function createUniswapPair() public {
1600         require(uniswapV2Pair == address(0), "Pair has already been created");
1601         require(uniswapV2Factory != address(0) && uniswapV2Router != address(0), "Uniswap addresses have not been set");
1602 
1603         uniswapV2Pair = IUniswapV2Factory(uniswapV2Factory).createPair(
1604                 IUniswapV2Router02(uniswapV2Router).WETH(),
1605                 address(this)
1606         );
1607     }
1608 }
1609 
1610 // 
1611 contract GrimReaper is Ownable {
1612     using SafeMath for uint256;
1613     using SafeERC20 for IERC20;
1614 
1615     // Info of each user.
1616     struct UserInfo {
1617         uint256 amount;     // How many LP tokens the user has provided.
1618         uint256 rewardDebt; // Reward debt. See explanation below.
1619         uint256 lastDeposit; // block.timestamp
1620         uint256 earlyBaseRewardMultiplier;
1621         uint256 latestMultiplier;
1622     }
1623 
1624     // Protocol Adapter to regulate extra farming rewards from holding NFT and certain tokens
1625     IProtocolAdapter public protocolAdapter;
1626 
1627     // Info of each pool.
1628     struct PoolInfo {
1629         IERC20 lpToken;           // Address of LP token contract.
1630         uint256 allocPoint;       // How many allocation points assigned to this pool. BBRAs to distribute per block.
1631         uint256 lastRewardBlock;  // Last block number that BBRAs distribution occurs.
1632         uint256 accSushiPerShare; // Accumulated BBRAs per share, times 1e12. See below.
1633     }
1634 
1635     // The Gr1m TOKEN!
1636     Gr1m public sushi;
1637     // Block number when bonus Gr1m period ends.
1638     uint256 public bonusEndBlock;
1639     // Gr1m tokens created per block.
1640     uint256 public sushiPerBlock;
1641     // Block number when early lp rewards end.
1642     uint256 public bonusLpEndBlock;
1643     // Bonus muliplier for early boob makers.
1644     uint256 public BONUS_MULTIPLIER = 1;
1645 
1646     // penalties for withdrawing within first x weeks of deposit
1647     // within w1 = 50%, w2 = 33.33%, w3 = 25%, w4 = 15%, on and after w5 = 0%
1648     uint256[] public earlyWithdrawalPenalties = [2, 3, 4, 7];
1649 
1650     // The migrator contract removed. It has a lot of power. Can only be set through governance (owner).
1651 
1652     // Info of each pool.
1653     PoolInfo[] public poolInfo;
1654     // Info of each user that stakes LP tokens.
1655     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1656     // Total allocation points. Must be the sum of all allocation points in all pools.
1657     uint256 public totalAllocPoint = 0;
1658     // The block number when Gr1m mining starts.
1659     uint256 public startBlock;
1660     // Don't add same pool twice https://twitter.com/Quantstamp/status/1301280989906231296
1661     mapping (address => bool) private poolIsAdded;
1662 
1663     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1664     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1665     event EarlyAdopter(address indexed user, uint256 indexed pid, uint256 amount);
1666     event ProtocolAdapterChange(address _newProtocol);
1667 
1668     constructor(
1669         Gr1m _sushi,
1670         uint256 _sushiPerBlock,
1671         uint256 _startBlock,
1672         uint256 _bonusLpEndBlock
1673     ) public {
1674         sushi = _sushi;
1675         sushiPerBlock = _sushiPerBlock;
1676         bonusLpEndBlock = _bonusLpEndBlock;
1677         startBlock = _startBlock;
1678     }
1679 
1680     function getUserRewardsMultiplier(address _user, uint256 _current) public view returns (uint256) {
1681         if (address(protocolAdapter) == address(0))
1682             return _current;
1683 
1684         return protocolAdapter.getRewardsMultiplier(_user, _current);
1685     }
1686 
1687     function getUserWithdrawalPenalty(uint256 _depositTime) public view returns (uint256) {
1688 
1689         uint256 _int = block.timestamp.sub(_depositTime).div(604800);
1690 
1691         if (_int > (earlyWithdrawalPenalties.length - 1))
1692             return 0;
1693 
1694         return earlyWithdrawalPenalties[_int];
1695     }
1696 
1697     // Deposit LP tokens to MrBanker for Gr1m allocation.
1698     function deposit(uint256 _pid, uint256 _amount) public {
1699         PoolInfo storage pool = poolInfo[_pid];
1700         UserInfo storage user = userInfo[_pid][msg.sender];
1701         updatePool(_pid);
1702 
1703         user.earlyBaseRewardMultiplier = getUserBaseRewards(user.earlyBaseRewardMultiplier);
1704 
1705         // multiplier at time of deposit must be maintained when withdrawing - otherwise lowest is selected
1706         uint256 _currentMultiplier = getUserRewardsMultiplier(msg.sender, user.earlyBaseRewardMultiplier);
1707 
1708         if (user.amount != 0) {
1709             uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
1710             uint256 penaltyDivisor = getUserWithdrawalPenalty(user.lastDeposit);
1711             uint256 penaltyToBurn;
1712 
1713             if (penaltyDivisor != 0) {
1714                 penaltyToBurn = pending.div(penaltyDivisor);
1715                 pending = pending.sub(penaltyToBurn);
1716             }
1717 
1718             safeSushiTransfer(msg.sender, pending);
1719 
1720             // burn any early withdraw penalties
1721             if (penaltyToBurn != 0) {
1722                 sushi.burn(penaltyToBurn);
1723             }
1724 
1725             if (user.latestMultiplier > 100) {
1726                 // since pool balance isn't calculated on individual contributions we must mint the early adopters rewards
1727                 // as we might come short otherwise.
1728                 sushi.mint(msg.sender, pending.mul(
1729                     // pick the smallest of current multiplier and multiplier at time of initial deposit
1730                     (user.latestMultiplier > _currentMultiplier ? _currentMultiplier : user.latestMultiplier)
1731                 ).div(100).sub(pending));
1732             }
1733         }
1734 
1735         user.amount = user.amount.add(_amount);
1736         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1737         user.latestMultiplier = _currentMultiplier;
1738 
1739         if (_amount !=  0) {
1740             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1741             // only reset clock when actually depositing. On _amount == 0 it only withdraws rewards
1742             user.lastDeposit = block.timestamp;
1743         }
1744     }
1745 
1746     // Withdraw LP tokens from MrBanker.
1747     function withdraw(uint256 _pid, uint256 _amount) public {
1748         PoolInfo storage pool = poolInfo[_pid];
1749         UserInfo storage user = userInfo[_pid][msg.sender];
1750         require(user.amount >= _amount, "withdraw: not good");
1751         updatePool(_pid);
1752         user.earlyBaseRewardMultiplier = getUserBaseRewards(user.earlyBaseRewardMultiplier);
1753         // multiplier at time of deposit must be maintained when withdrawing - otherwise lowest is selected
1754         uint256 _currentMultiplier = getUserRewardsMultiplier(msg.sender, user.earlyBaseRewardMultiplier);
1755 
1756         uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
1757         // check penalties
1758         uint256 penaltyDivisor = getUserWithdrawalPenalty(user.lastDeposit);
1759         uint256 penaltyToBurn;
1760 
1761         if (penaltyDivisor != 0) {
1762             penaltyToBurn = pending.div(penaltyDivisor);
1763             pending = pending.sub(penaltyToBurn);
1764         }
1765 
1766         safeSushiTransfer(msg.sender, pending);
1767 
1768         // burn any early withdraw penalties
1769         if (penaltyToBurn != 0) {
1770             sushi.burn(penaltyToBurn);
1771         }
1772 
1773         if (user.latestMultiplier > 100) {
1774             // since pool balance isn't calculated on individual contributions we must mint the early adopters rewards
1775             // as we might come short otherwise.
1776             sushi.mint(msg.sender, pending.mul(
1777             // pick the smallest of current multiplier and multiplier at time of initial deposit
1778                 (user.latestMultiplier > _currentMultiplier ? _currentMultiplier : user.latestMultiplier)
1779             ).div(100).sub(pending));
1780         }
1781 
1782         user.amount = user.amount.sub(_amount);
1783         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1784         user.latestMultiplier = _currentMultiplier;
1785 
1786         // 1% of all withdrawn LP is locked away forever
1787         uint256 burnedLp = _amount.div(100);
1788         pool.lpToken.safeTransfer(address(msg.sender), _amount.sub(burnedLp));
1789         pool.lpToken.safeTransfer(address(0), burnedLp);
1790         emit Withdraw(msg.sender, _pid, _amount);
1791     }
1792 
1793     function getUserBaseRewards(uint256 _current) public view returns (uint256) {
1794         if (block.number > bonusLpEndBlock && _current > 100) {
1795             // reset early LP rewards after bonusLpEndBlock block
1796             // nft rewards still count
1797             _current = 100;
1798         }
1799 
1800         if (block.number < startBlock) {
1801             _current = 110;
1802         }
1803 
1804         if (_current == 0) {
1805             _current = 100;
1806         }
1807 
1808         return _current;
1809     }
1810 
1811     // Safe boo transfer function, just in case if rounding error causes pool to not have enough Gr1ms.
1812     function safeSushiTransfer(address _to, uint256 _amount) internal {
1813         uint256 sushiBal = sushi.balanceOf(address(this));
1814         if (_amount > sushiBal) {
1815             sushi.transfer(_to, sushiBal);
1816         } else {
1817             sushi.transfer(_to, _amount);
1818         }
1819     }
1820 
1821     // Update reward variables of the given pool to be up-to-date.
1822     function updatePool(uint256 _pid) public {
1823         PoolInfo storage pool = poolInfo[_pid];
1824         if (block.number <= pool.lastRewardBlock) {
1825             return;
1826         }
1827         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1828         if (lpSupply == 0) {
1829             pool.lastRewardBlock = block.number;
1830             return;
1831         }
1832         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1833         uint256 sushiReward = multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1834         sushi.mint(address(this), sushiReward);
1835         pool.accSushiPerShare = pool.accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1836         pool.lastRewardBlock = block.number;
1837     }
1838 
1839     // Return reward multiplier over the given _from to _to block.
1840     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1841         if (_to <= bonusEndBlock) {
1842             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1843         } else if (_from >= bonusEndBlock) {
1844             return _to.sub(_from);
1845         } else {
1846             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1847                 _to.sub(bonusEndBlock)
1848             );
1849         }
1850     }
1851 
1852     // Withdraw without caring about rewards. EMERGENCY ONLY.
1853     function emergencyWithdraw(uint256 _pid) public {
1854         PoolInfo storage pool = poolInfo[_pid];
1855         UserInfo storage user = userInfo[_pid][msg.sender];
1856         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1857         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1858         user.amount = 0;
1859         user.rewardDebt = 0;
1860     }
1861 
1862     // Sets contract that regulates dynamic farm rewards and burn rates (changeable by DAO)
1863     function setProtocolAdapter(IProtocolAdapter _contract) public onlyOwner {
1864         // setting to 0x0 disabled nft rewards
1865         protocolAdapter = _contract;
1866         emit ProtocolAdapterChange(address(_contract));
1867     }
1868 
1869     // Add a new lp to the pool. Can only be called by the owner.
1870     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1871     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1872         require(poolIsAdded[address(_lpToken)] == false, 'add: pool already added');
1873         poolIsAdded[address(_lpToken)] = true;
1874 
1875         if (_withUpdate) {
1876             massUpdatePools();
1877         }
1878         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1879         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1880         poolInfo.push(PoolInfo({
1881         lpToken: _lpToken,
1882         allocPoint: _allocPoint,
1883         lastRewardBlock: lastRewardBlock,
1884         accSushiPerShare: 0
1885         }));
1886     }
1887 
1888     // Update the given pool's Gr1m allocation point. Can only be called by the owner.
1889     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1890         if (_withUpdate) {
1891             massUpdatePools();
1892         }
1893         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1894         poolInfo[_pid].allocPoint = _allocPoint;
1895     }
1896 
1897     // Update reward variables for all pools. Be careful of gas spending!
1898     function massUpdatePools() public {
1899         uint256 length = poolInfo.length;
1900         for (uint256 pid = 0; pid < length; ++pid) {
1901             updatePool(pid);
1902         }
1903     }
1904 
1905     function poolLength() external view returns (uint256) {
1906         return poolInfo.length;
1907     }
1908 
1909     function setStartBlock(uint256 _startBlock) public onlyOwner {
1910         startBlock = _startBlock;
1911     }
1912 
1913     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1914         bonusEndBlock = _bonusEndBlock;
1915     }
1916 
1917     function setBonusLpEndBlock(uint256 _bonusLpEndBlock) public onlyOwner {
1918         bonusLpEndBlock = _bonusLpEndBlock;
1919     }
1920 
1921     // Updates bonus multiplier for early farmers
1922     function setBonusMultiplier(uint256 _bonusMultiplier) public onlyOwner {
1923         BONUS_MULTIPLIER = _bonusMultiplier;
1924     }
1925 
1926     // Sets reward per block
1927     function setRewardPerBlock(uint256 _rewardPerBlock, bool _withUpdate) public onlyOwner {
1928         // if last a pool was update is a while ago it's best to update pools so no rewards go missing
1929         if (_withUpdate) {
1930             massUpdatePools();
1931         }
1932         sushiPerBlock = _rewardPerBlock;
1933     }
1934 
1935     // View function to see pending Gr1ms on frontend.
1936     function pendingSushi(uint256 _pid, address _user) external view returns (uint256) {
1937         PoolInfo storage pool = poolInfo[_pid];
1938         UserInfo storage user = userInfo[_pid][_user];
1939         uint256 accSushiPerShare = pool.accSushiPerShare;
1940         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1941         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1942             uint256 _sushiPerBlock = sushiPerBlock;
1943 
1944             uint256 _earlyBaseRewardMultiplier = getUserBaseRewards(user.earlyBaseRewardMultiplier);
1945 
1946             // multiplier at time of deposit must be maintained when withdrawing - otherwise lowest is selected
1947             uint256 _currentMultiplier = getUserRewardsMultiplier(_user, _earlyBaseRewardMultiplier);
1948             _sushiPerBlock = _sushiPerBlock.mul(_currentMultiplier).div(100);
1949 
1950             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1951             uint256 sushiReward = multiplier.mul(_sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1952             accSushiPerShare = accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1953         }
1954         return user.amount.mul(accSushiPerShare).div(1e12).sub(user.rewardDebt);
1955     }
1956 
1957     // Set burn rate for Gr1m
1958     function setBurnRate(uint8 _burnDivisor) public onlyOwner {
1959         require(_burnDivisor != 0, "Boo: burnDivisor must be bigger than 0");
1960         sushi.setBurnRate(_burnDivisor);
1961     }
1962 }