1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.2;
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
1074 // 
1075 contract Ectoplasma is ERC20("Ectoplasma", "ECTO"), Ownable {
1076     using SafeMath for uint256;
1077     address public devaddr;
1078 
1079     // the amount of burn to ecto during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%, 255 being the lowest burn
1080     uint8 public burnDivisor;
1081 
1082     constructor(uint8 _burnDivisor, address _devaddr) public {
1083         require(_burnDivisor > 0, "Ecto: burnDivisor must be bigger than 0");
1084         burnDivisor = _burnDivisor;
1085         devaddr = _devaddr;
1086     }
1087     // mints new ecto tokens, can only be called by BooBank
1088     // contract during burns, no users or dev can call this
1089     function mint(address _to, uint256 _amount) public onlyOwner {
1090         _mint(_to, _amount);
1091     }
1092 
1093     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1094         // ecto amount is adjustable
1095         uint256 burnAmount = amount.div(burnDivisor);
1096 
1097         _burn(msg.sender, burnAmount);
1098         // 1%
1099         _mint(devaddr, amount.div(100));
1100 
1101         // sender transfers 99% of the ecto
1102         return super.transfer(recipient, amount.sub(burnAmount));
1103     }
1104 
1105     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1106         // ecto amount is 1%
1107         uint256 burnAmount = amount.div(burnDivisor);
1108         // recipient receives 1% ecto tokens
1109 
1110         // sender loses the 1% of the ecto
1111         _burn(sender, burnAmount);
1112         _mint(devaddr, amount.div(100));
1113         // sender transfers 99% of the ecto
1114         return super.transferFrom(sender, recipient, amount.sub(burnDivisor));
1115     }
1116 
1117     function setDevAddr(address _devaddr) public onlyOwner {
1118         devaddr = _devaddr;
1119     }
1120 
1121     function setBurnRate(uint8 _burnDivisor) public onlyOwner {
1122         require(_burnDivisor > 0, "Boo: burnDivisor must be bigger than 0");
1123         burnDivisor = _burnDivisor;
1124     }
1125 }
1126 
1127 // 
1128 // Boo with Governance.
1129 contract BooBank is ERC20("BooBank", "BOOB"), Ownable {
1130     // START OF BOO BANK SPECIFIC CODE
1131     // BooBank is an exact copy of sushi except for the
1132     // following code, which implements a burn every transfer
1133     // https://etherscan.io/token/0x6b3595068778dd592e39a122f4f5a5cf09c90fe2
1134     // the Boo burn a variable quantity of the transfer amount, and gives the
1135     // recipient the equivalent Ecto token
1136     using SafeMath for uint256;
1137     address public devaddr;
1138     // the ecto token that gets generated when transfers occur
1139     Ectoplasma public ecto;
1140     // the amount of burn to ecto during every transfer, i.e. 255 = 0.4%, 100 = 1%, 50 = 2%, 40 = 2.5%
1141     uint8 public burnDivisor;
1142     // Pause until block x (to prevent at lp init bots from taking large chunks of coins for cheap)
1143     uint256 public pauseUntilBlock = 0;
1144 
1145     constructor(uint8 _burnDivisor, Ectoplasma _ecto, address _devaddr) public {
1146         require(_burnDivisor > 0, "Boo: burnDivisor must be bigger than 0");
1147         ecto = _ecto;
1148         burnDivisor = _burnDivisor;
1149         devaddr = _devaddr;
1150     }
1151     
1152     function transfer(address recipient, uint256 amount) public checkRunning virtual override returns (bool) {
1153         // ecto amount is 1%
1154         uint256 ectoAmount = amount.div(burnDivisor);
1155         uint256 onePct = amount.div(100);
1156         // sender receives the burnDivisor - 1% ecto tokens
1157         ecto.mint(msg.sender, ectoAmount > onePct ? ectoAmount.sub(onePct) : ectoAmount);
1158         // sender loses the 1% of the BOOB
1159         _burn(msg.sender, ectoAmount);
1160         // 1%
1161         _mint(devaddr, amount.div(100));
1162         // sender transfers 99% of the BOOB
1163         return super.transfer(recipient, amount.sub(ectoAmount));
1164     }
1165 
1166     function transferFrom(address sender, address recipient, uint256 amount) public checkRunning virtual override returns (bool) {
1167         // ecto amount from burn
1168         uint256 ectoAmount = amount.div(burnDivisor);
1169         uint256 onePct = amount.div(100);
1170         // recipient receives the burnDivisor - 1% ecto tokens
1171         ecto.mint(sender, ectoAmount > onePct ? ectoAmount.sub(onePct) : ectoAmount);
1172         // sender loses the 1% of the BOOB
1173         _burn(sender, ectoAmount);
1174         // 1%
1175         _mint(devaddr, amount.div(100));
1176         // sender transfers 99% of the BOOB
1177         return super.transferFrom(sender, recipient, amount.sub(ectoAmount));
1178     }
1179 
1180     function setBurnRate(uint8 _burnDivisor) public onlyOwner {
1181         require(_burnDivisor > 0, "Boo: burnDivisor must be bigger than 0");
1182         burnDivisor = _burnDivisor;
1183         ecto.setBurnRate(_burnDivisor);
1184     }
1185 
1186     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MrBanker).
1187     function mint(address _to, uint256 _amount) public onlyOwner {
1188         _mint(_to, _amount);
1189         _moveDelegates(address(0), _delegates[_to], _amount);
1190     }
1191 
1192     function setDevAddr(address _devAddr) public onlyOwner {
1193         devaddr = _devAddr;
1194         ecto.setDevAddr(devaddr);
1195     }
1196 
1197     function setPauseBlock(uint256 _pauseUntilBlock) public onlyOwner {
1198         pauseUntilBlock = _pauseUntilBlock;
1199     }
1200 
1201     modifier checkRunning(){
1202         require(block.number > pauseUntilBlock, "Go away bot");
1203         _;
1204     }
1205 
1206     // Copied and modified from YAM code:
1207     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1208     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1209     // Which is copied and modified from COMPOUND:
1210     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1211 
1212     /// @notice A record of each accounts delegate
1213     mapping (address => address) internal _delegates;
1214 
1215     /// @notice A checkpoint for marking number of votes from a given block
1216     struct Checkpoint {
1217         uint32 fromBlock;
1218         uint256 votes;
1219     }
1220 
1221     /// @notice A record of votes checkpoints for each account, by index
1222     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1223 
1224     /// @notice The number of checkpoints for each account
1225     mapping (address => uint32) public numCheckpoints;
1226 
1227     /// @notice The EIP-712 typehash for the contract's domain
1228     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1229 
1230     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1231     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1232 
1233     /// @notice A record of states for signing / validating signatures
1234     mapping (address => uint) public nonces;
1235 
1236       /// @notice An event thats emitted when an account changes its delegate
1237     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1238 
1239     /// @notice An event thats emitted when a delegate account's vote balance changes
1240     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1241 
1242     /**
1243      * @notice Delegate votes from `msg.sender` to `delegatee`
1244      * @param delegator The address to get delegatee for
1245      */
1246     function delegates(address delegator)
1247         external
1248         view
1249         returns (address)
1250     {
1251         return _delegates[delegator];
1252     }
1253 
1254    /**
1255     * @notice Delegate votes from `msg.sender` to `delegatee`
1256     * @param delegatee The address to delegate votes to
1257     */
1258     function delegate(address delegatee) external {
1259         return _delegate(msg.sender, delegatee);
1260     }
1261 
1262     /**
1263      * @notice Delegates votes from signatory to `delegatee`
1264      * @param delegatee The address to delegate votes to
1265      * @param nonce The contract state required to match the signature
1266      * @param expiry The time at which to expire the signature
1267      * @param v The recovery byte of the signature
1268      * @param r Half of the ECDSA signature pair
1269      * @param s Half of the ECDSA signature pair
1270      */
1271     function delegateBySig(
1272         address delegatee,
1273         uint nonce,
1274         uint expiry,
1275         uint8 v,
1276         bytes32 r,
1277         bytes32 s
1278     )
1279         external
1280     {
1281         bytes32 domainSeparator = keccak256(
1282             abi.encode(
1283                 DOMAIN_TYPEHASH,
1284                 keccak256(bytes(name())),
1285                 getChainId(),
1286                 address(this)
1287             )
1288         );
1289 
1290         bytes32 structHash = keccak256(
1291             abi.encode(
1292                 DELEGATION_TYPEHASH,
1293                 delegatee,
1294                 nonce,
1295                 expiry
1296             )
1297         );
1298 
1299         bytes32 digest = keccak256(
1300             abi.encodePacked(
1301                 "\x19\x01",
1302                 domainSeparator,
1303                 structHash
1304             )
1305         );
1306 
1307         address signatory = ecrecover(digest, v, r, s);
1308         require(signatory != address(0), "BOOB::delegateBySig: invalid signature");
1309         require(nonce == nonces[signatory]++, "BOOB::delegateBySig: invalid nonce");
1310         require(now <= expiry, "BOOB::delegateBySig: signature expired");
1311         return _delegate(signatory, delegatee);
1312     }
1313 
1314     /**
1315      * @notice Gets the current votes balance for `account`
1316      * @param account The address to get votes balance
1317      * @return The number of current votes for `account`
1318      */
1319     function getCurrentVotes(address account)
1320         external
1321         view
1322         returns (uint256)
1323     {
1324         uint32 nCheckpoints = numCheckpoints[account];
1325         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1326     }
1327 
1328     /**
1329      * @notice Determine the prior number of votes for an account as of a block number
1330      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1331      * @param account The address of the account to check
1332      * @param blockNumber The block number to get the vote balance at
1333      * @return The number of votes the account had as of the given block
1334      */
1335     function getPriorVotes(address account, uint blockNumber)
1336         external
1337         view
1338         returns (uint256)
1339     {
1340         require(blockNumber < block.number, "BOOB::getPriorVotes: not yet determined");
1341 
1342         uint32 nCheckpoints = numCheckpoints[account];
1343         if (nCheckpoints == 0) {
1344             return 0;
1345         }
1346 
1347         // First check most recent balance
1348         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1349             return checkpoints[account][nCheckpoints - 1].votes;
1350         }
1351 
1352         // Next check implicit zero balance
1353         if (checkpoints[account][0].fromBlock > blockNumber) {
1354             return 0;
1355         }
1356 
1357         uint32 lower = 0;
1358         uint32 upper = nCheckpoints - 1;
1359         while (upper > lower) {
1360             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1361             Checkpoint memory cp = checkpoints[account][center];
1362             if (cp.fromBlock == blockNumber) {
1363                 return cp.votes;
1364             } else if (cp.fromBlock < blockNumber) {
1365                 lower = center;
1366             } else {
1367                 upper = center - 1;
1368             }
1369         }
1370         return checkpoints[account][lower].votes;
1371     }
1372 
1373     function _delegate(address delegator, address delegatee)
1374         internal
1375     {
1376         address currentDelegate = _delegates[delegator];
1377         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BOOBs (not scaled);
1378         _delegates[delegator] = delegatee;
1379 
1380         emit DelegateChanged(delegator, currentDelegate, delegatee);
1381 
1382         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1383     }
1384 
1385     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1386         if (srcRep != dstRep && amount > 0) {
1387             if (srcRep != address(0)) {
1388                 // decrease old representative
1389                 uint32 srcRepNum = numCheckpoints[srcRep];
1390                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1391                 uint256 srcRepNew = srcRepOld.sub(amount);
1392                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1393             }
1394 
1395             if (dstRep != address(0)) {
1396                 // increase new representative
1397                 uint32 dstRepNum = numCheckpoints[dstRep];
1398                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1399                 uint256 dstRepNew = dstRepOld.add(amount);
1400                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1401             }
1402         }
1403     }
1404 
1405     function _writeCheckpoint(
1406         address delegatee,
1407         uint32 nCheckpoints,
1408         uint256 oldVotes,
1409         uint256 newVotes
1410     )
1411         internal
1412     {
1413         uint32 blockNumber = safe32(block.number, "BOOB::_writeCheckpoint: block number exceeds 32 bits");
1414 
1415         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1416             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1417         } else {
1418             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1419             numCheckpoints[delegatee] = nCheckpoints + 1;
1420         }
1421 
1422         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1423     }
1424 
1425     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1426         require(n < 2**32, errorMessage);
1427         return uint32(n);
1428     }
1429 
1430     function getChainId() internal pure returns (uint) {
1431         uint256 chainId;
1432         assembly { chainId := chainid() }
1433         return chainId;
1434     }
1435 }
1436 
1437 // 
1438 // MrBanker is the master of BooBank. He can make BooBank and he is a fair guy.
1439 //
1440 // Note that it's ownable and the owner wields tremendous power. The ownership
1441 // will be transferred to a governance smart contract once BOOB is sufficiently
1442 // distributed and the community can show to govern itself.
1443 //
1444 // Have fun reading it. Hopefully it's bug-free. God bless.
1445 contract MrBanker is Ownable {
1446     using SafeMath for uint256;
1447     using SafeERC20 for IERC20;
1448 
1449     // Info of each user.
1450     struct UserInfo {
1451         uint256 amount;     // How many LP tokens the user has provided.
1452         uint256 rewardDebt; // Reward debt. See explanation below.
1453         uint256 earlyRewardMultiplier; // If an early LP provider reward applies
1454         //
1455         // We do some fancy math here. Basically, any point in time, the amount of BOOBs
1456         // entitled to a user but is pending to be distributed is:
1457         //
1458         //   pending reward = (user.amount * pool.accSushiPerShare) - user.rewardDebt
1459         //
1460         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1461         //   1. The pool's `accSushiPerShare` (and `lastRewardBlock`) gets updated.
1462         //   2. User receives the pending reward sent to his/her address.
1463         //   3. User's `amount` gets updated.
1464         //   4. User's `rewardDebt` gets updated.
1465     }
1466 
1467     // Info of each pool.
1468     struct PoolInfo {
1469         IERC20 lpToken;           // Address of LP token contract.
1470         uint256 allocPoint;       // How many allocation points assigned to this pool. BOOBs to distribute per block.
1471         uint256 lastRewardBlock;  // Last block number that BOOBs distribution occurs.
1472         uint256 accSushiPerShare; // Accumulated BOOBs per share, times 1e12. See below.
1473     }
1474 
1475     // The BOOBANK TOKEN!
1476     BooBank public sushi;
1477     // Dev address.
1478     address public devaddr;
1479     // Block number when bonus BOOB period ends.
1480     uint256 public bonusEndBlock;
1481     // BOOB tokens created per block.
1482     uint256 public sushiPerBlock;
1483     // Block number when early lp rewards end.
1484     uint256 public bonusLpEndBlock;
1485     // Bonus muliplier for early boob makers.
1486     uint256 public BONUS_MULTIPLIER = 2;
1487 
1488     // The migrator contract removed. It has a lot of power. Can only be set through governance (owner).
1489     // IMigratorChef public migrator;
1490 
1491     // Info of each pool.
1492     PoolInfo[] public poolInfo;
1493     // Info of each user that stakes LP tokens.
1494     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1495     // Total allocation points. Must be the sum of all allocation points in all pools.
1496     uint256 public totalAllocPoint = 0;
1497     // The block number when BOOB mining starts.
1498     uint256 public startBlock;
1499     // Don't add same pool twice https://twitter.com/Quantstamp/status/1301280989906231296
1500     mapping (address => bool) private poolIsAdded;
1501 
1502     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1503     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1504     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1505     event EarlyAdopter(address indexed user, uint256 indexed pid, uint256 amount);
1506 
1507     constructor(
1508         BooBank _sushi,
1509         address _devaddr,
1510         uint256 _sushiPerBlock,
1511         uint256 _startBlock,
1512         uint256 _bonusEndBlock,
1513         uint256 _bonusLpEndBlock
1514     ) public {
1515         sushi = _sushi;
1516         devaddr = _devaddr;
1517         sushiPerBlock = _sushiPerBlock;
1518         bonusEndBlock = _bonusEndBlock;
1519         bonusLpEndBlock = _bonusLpEndBlock;
1520         startBlock = _startBlock;
1521     }
1522 
1523     function poolLength() external view returns (uint256) {
1524         return poolInfo.length;
1525     }
1526 
1527     // Add a new lp to the pool. Can only be called by the owner.
1528     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1529     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1530         require(poolIsAdded[address(_lpToken)] == false, 'add: pool already added');
1531         poolIsAdded[address(_lpToken)] = true;
1532 
1533         if (_withUpdate) {
1534             massUpdatePools();
1535         }
1536         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1537         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1538         poolInfo.push(PoolInfo({
1539             lpToken: _lpToken,
1540             allocPoint: _allocPoint,
1541             lastRewardBlock: lastRewardBlock,
1542             accSushiPerShare: 0
1543         }));
1544     }
1545 
1546     // Update the given pool's BOOB allocation point. Can only be called by the owner.
1547     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1548         if (_withUpdate) {
1549             massUpdatePools();
1550         }
1551         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1552         poolInfo[_pid].allocPoint = _allocPoint;
1553     }
1554 
1555     function setStartBlock(uint256 _startBlock) public onlyOwner {
1556         startBlock = _startBlock;
1557     }
1558 
1559     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1560         bonusEndBlock = _bonusEndBlock;
1561     }
1562 
1563     function setBonusLpEndBlock(uint256 _bonusLpEndBlock) public onlyOwner {
1564         bonusLpEndBlock = _bonusLpEndBlock;
1565     }
1566 
1567     // Updates bonus multiplier for early farmers
1568     function setBonusMultiplier(uint256 _bonusMultiplier) public onlyOwner {
1569         BONUS_MULTIPLIER = _bonusMultiplier;
1570     }
1571 
1572     function updateBooOwner(address _newOwner) public onlyOwner {
1573         sushi.transferOwnership(_newOwner);
1574     }
1575 
1576     // Return reward multiplier over the given _from to _to block.
1577     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1578         if (_to <= bonusEndBlock) {
1579             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1580         } else if (_from >= bonusEndBlock) {
1581             return _to.sub(_from);
1582         } else {
1583             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1584                 _to.sub(bonusEndBlock)
1585             );
1586         }
1587     }
1588 
1589     // View function to see pending BOOBs on frontend.
1590     function pendingSushi(uint256 _pid, address _user) external view returns (uint256) {
1591         PoolInfo storage pool = poolInfo[_pid];
1592         UserInfo storage user = userInfo[_pid][_user];
1593         uint256 accSushiPerShare = pool.accSushiPerShare;
1594         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1595         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1596             uint256 _sushiPerBlock = sushiPerBlock;
1597 
1598             if (user.earlyRewardMultiplier > 100 && block.number < bonusLpEndBlock) {
1599                 _sushiPerBlock = _sushiPerBlock.mul(user.earlyRewardMultiplier).div(100);
1600             }
1601             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1602             uint256 sushiReward = multiplier.mul(_sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1603             accSushiPerShare = accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1604         }
1605         return user.amount.mul(accSushiPerShare).div(1e12).sub(user.rewardDebt);
1606     }
1607 
1608     // Update reward variables for all pools. Be careful of gas spending!
1609     function massUpdatePools() public {
1610         uint256 length = poolInfo.length;
1611         for (uint256 pid = 0; pid < length; ++pid) {
1612             updatePool(pid);
1613         }
1614     }
1615 
1616     // Update reward variables of the given pool to be up-to-date.
1617     function updatePool(uint256 _pid) public {
1618         PoolInfo storage pool = poolInfo[_pid];
1619         if (block.number <= pool.lastRewardBlock) {
1620             return;
1621         }
1622         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1623         if (lpSupply == 0) {
1624             pool.lastRewardBlock = block.number;
1625             return;
1626         }
1627         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1628         uint256 sushiReward = multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1629 
1630         sushi.mint(devaddr, sushiReward.div(100));
1631 
1632         sushi.mint(address(this), sushiReward);
1633         pool.accSushiPerShare = pool.accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1634         pool.lastRewardBlock = block.number;
1635     }
1636 
1637     // Deposit LP tokens to MrBanker for BOOB allocation.
1638     function deposit(uint256 _pid, uint256 _amount) public {
1639         PoolInfo storage pool = poolInfo[_pid];
1640         UserInfo storage user = userInfo[_pid][msg.sender];
1641         updatePool(_pid);
1642         if (block.number < startBlock) {
1643             user.earlyRewardMultiplier = 110;
1644         } else {
1645             user.earlyRewardMultiplier = user.earlyRewardMultiplier > 100 ? user.earlyRewardMultiplier : 100;
1646         }
1647 
1648         if (user.amount > 0) {
1649             uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
1650             safeSushiTransfer(msg.sender, pending);
1651             if (block.number < bonusLpEndBlock && user.earlyRewardMultiplier > 100) {
1652                 // since pool balance isn't calculated on individual contributions we must mint the early adopters rewards
1653                 // as we might come short otherwise.
1654                 sushi.mint(msg.sender, pending.mul(user.earlyRewardMultiplier).div(100).sub(pending));
1655             }
1656         }
1657         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1658         user.amount = user.amount.add(_amount);
1659         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1660         if (block.number < startBlock) {
1661             emit EarlyAdopter(msg.sender, _pid, _amount);
1662         }
1663         emit Deposit(msg.sender, _pid, _amount);
1664     }
1665 
1666     // Withdraw LP tokens from MrBanker.
1667     function withdraw(uint256 _pid, uint256 _amount) public {
1668         PoolInfo storage pool = poolInfo[_pid];
1669         UserInfo storage user = userInfo[_pid][msg.sender];
1670         require(user.amount >= _amount, "withdraw: not good");
1671         updatePool(_pid);
1672         uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
1673         safeSushiTransfer(msg.sender, pending);
1674         if (pending > 0 && block.number < bonusLpEndBlock && user.earlyRewardMultiplier > 100) {
1675             // since pool balance isn't calculated on individual contributions we must mint the early adopters rewards
1676             // as we might come short otherwise.
1677             sushi.mint(msg.sender, pending.mul(user.earlyRewardMultiplier).div(100).sub(pending));
1678         }
1679         user.amount = user.amount.sub(_amount);
1680         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1681         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1682         emit Withdraw(msg.sender, _pid, _amount);
1683     }
1684 
1685     // Withdraw without caring about rewards. EMERGENCY ONLY.
1686     function emergencyWithdraw(uint256 _pid) public {
1687         PoolInfo storage pool = poolInfo[_pid];
1688         UserInfo storage user = userInfo[_pid][msg.sender];
1689         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1690         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1691         user.amount = 0;
1692         user.rewardDebt = 0;
1693     }
1694 
1695     // Safe boo transfer function, just in case if rounding error causes pool to not have enough BOOBs.
1696     function safeSushiTransfer(address _to, uint256 _amount) internal {
1697         uint256 sushiBal = sushi.balanceOf(address(this));
1698         if (_amount > sushiBal) {
1699             sushi.transfer(_to, sushiBal);
1700         } else {
1701             sushi.transfer(_to, _amount);
1702         }
1703     }
1704 
1705     // Set burn rate for both BooBank and Ectoplasma
1706     function setBurnRate(uint8 _burnDivisor) public onlyOwner {
1707         require(_burnDivisor > 0, "Boo: burnDivisor must be bigger than 0");
1708         sushi.setBurnRate(_burnDivisor);
1709     }
1710 
1711     function dev(address _devaddr) public {
1712         // Minting to 0 address reverts and breaks harvesting
1713         require(_devaddr != address(0), "dev: don't set to 0 address");
1714         require(msg.sender == devaddr, "dev: wut?");
1715         devaddr = _devaddr;
1716         sushi.setDevAddr(_devaddr);
1717     }
1718 
1719     function setPauseBlock(uint256 _pauseUntilBlock) public onlyOwner {
1720         sushi.setPauseBlock(_pauseUntilBlock);
1721     }
1722 }