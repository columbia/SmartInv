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
1075 contract RallyToken is ERC20 {
1076 
1077     //15 billion fixed token supply with default 18 decimals
1078     uint256 public constant TOKEN_SUPPLY = 15 * 10**9 * 10**18;
1079 
1080     constructor (
1081         address _escrow
1082     ) public ERC20(
1083 	"Rally",
1084 	"RLY"
1085     ) {
1086         _mint(_escrow, TOKEN_SUPPLY);	
1087     }
1088 }
1089 
1090 // 
1091 contract NoMintLiquidityRewardPools is Ownable {
1092     using SafeMath for uint256;
1093     using SafeERC20 for IERC20;
1094 
1095     // Info of each user.
1096     struct UserInfo {
1097         uint256 amount;     // How many LP tokens the user has provided.
1098         uint256 rewardDebt; // Reward debt. See explanation below.
1099         //
1100         // We do some fancy math here. Basically, any point in time, the amount of RLY
1101         // entitled to a user but is pending to be distributed is:
1102         //
1103         //   pending reward = (user.amount * pool.accRallyPerShare) - user.rewardDebt
1104         //
1105         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1106         //   1. The pool's `accRallyPerShare` (and `lastRewardBlock`) gets updated.
1107         //   2. User receives the pending reward sent to his/her address.
1108         //   3. User's `amount` gets updated.
1109         //   4. User's `rewardDebt` gets updated.
1110     }
1111 
1112     // Info of each pool.
1113     struct PoolInfo {
1114         IERC20 lpToken;           // Address of LP token contract.
1115         uint256 allocPoint;       // How many allocation points assigned to this pool. RLYs to distribute per block.
1116         uint256 lastRewardBlock;  // Last block number that RLYs distribution occurs.
1117         uint256 accRallyPerShare; // Accumulated RLYs per share, times 1e12. See below.
1118     }
1119 
1120     // The RALLY TOKEN!
1121     RallyToken public rally;
1122     // RLY tokens created per block.
1123     uint256 public rallyPerBlock;
1124 
1125     // Info of each pool.
1126     PoolInfo[] public poolInfo;
1127     // Info of each user that stakes LP tokens.
1128     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1129     // Total allocation points. Must be the sum of all allocation points in all pools.
1130     uint256 public totalAllocPoint = 0;
1131     // The block number when RLY mining starts.
1132     uint256 public startBlock;
1133 
1134     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1135     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1136     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1137 
1138     constructor(
1139         RallyToken _rally,
1140         uint256 _rallyPerBlock,
1141         uint256 _startBlock
1142     ) public {
1143         rally = _rally;
1144         rallyPerBlock = _rallyPerBlock;
1145         startBlock = _startBlock;
1146     }
1147 
1148     function poolLength() external view returns (uint256) {
1149         return poolInfo.length;
1150     }
1151 
1152     // Add a new lp to the pool. Can only be called by the owner.
1153     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1154     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1155         if (_withUpdate) {
1156             massUpdatePools();
1157         }
1158         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1159         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1160         poolInfo.push(PoolInfo({
1161             lpToken: _lpToken,
1162             allocPoint: _allocPoint,
1163             lastRewardBlock: lastRewardBlock,
1164             accRallyPerShare: 0
1165         }));
1166     }
1167 
1168     // Update the given pool's RLY allocation point. Can only be called by the owner.
1169     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1170         if (_withUpdate) {
1171             massUpdatePools();
1172         }
1173         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1174         poolInfo[_pid].allocPoint = _allocPoint;
1175     }
1176 
1177     // update the rate at which RLY is allocated to rewards, can only be called by the owner
1178     function setRallyPerBlock(uint256 _rallyPerBlock) public onlyOwner {
1179         massUpdatePools();
1180         rallyPerBlock = _rallyPerBlock;
1181     }
1182 
1183     // View function to see pending RLYs on frontend.
1184     function pendingRally(uint256 _pid, address _user) external view returns (uint256) {
1185         PoolInfo storage pool = poolInfo[_pid];
1186         UserInfo storage user = userInfo[_pid][_user];
1187         uint256 accRallyPerShare = pool.accRallyPerShare;
1188         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1189         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1190             uint256 multiplier = block.number.sub(pool.lastRewardBlock);
1191             uint256 rallyReward = multiplier.mul(rallyPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1192             accRallyPerShare = accRallyPerShare.add(rallyReward.mul(1e12).div(lpSupply));
1193         }
1194         return user.amount.mul(accRallyPerShare).div(1e12).sub(user.rewardDebt);
1195     }
1196 
1197     // Update reward variables for all pools. Be careful of gas spending!
1198     function massUpdatePools() public {
1199         uint256 length = poolInfo.length;
1200         for (uint256 pid = 0; pid < length; ++pid) {
1201             updatePool(pid);
1202         }
1203     }
1204 
1205     // Update reward variables of the given pool to be up-to-date.
1206     // No new RLY are minted, distribution is dependent on sufficient RLY tokens being sent to this contract
1207     function updatePool(uint256 _pid) public {
1208         PoolInfo storage pool = poolInfo[_pid];
1209         if (block.number <= pool.lastRewardBlock) {
1210             return;
1211         }
1212         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1213         if (lpSupply == 0) {
1214             pool.lastRewardBlock = block.number;
1215             return;
1216         }
1217         uint256 multiplier = block.number.sub(pool.lastRewardBlock);
1218         uint256 rallyReward = multiplier.mul(rallyPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1219         pool.accRallyPerShare = pool.accRallyPerShare.add(rallyReward.mul(1e12).div(lpSupply));
1220         pool.lastRewardBlock = block.number;
1221     }
1222 
1223     // Deposit LP tokens to pool for RLY allocation.
1224     function deposit(uint256 _pid, uint256 _amount) public {
1225         PoolInfo storage pool = poolInfo[_pid];
1226         UserInfo storage user = userInfo[_pid][msg.sender];
1227         updatePool(_pid);
1228         if (user.amount > 0) {
1229             uint256 pending = user.amount.mul(pool.accRallyPerShare).div(1e12).sub(user.rewardDebt);
1230             if(pending > 0) {
1231                 safeRallyTransfer(msg.sender, pending);
1232             }
1233         }
1234         if(_amount > 0) {
1235             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1236             user.amount = user.amount.add(_amount);
1237         }
1238         user.rewardDebt = user.amount.mul(pool.accRallyPerShare).div(1e12);
1239         emit Deposit(msg.sender, _pid, _amount);
1240     }
1241 
1242     // Withdraw LP tokens from pool.
1243     function withdraw(uint256 _pid, uint256 _amount) public {
1244         PoolInfo storage pool = poolInfo[_pid];
1245         UserInfo storage user = userInfo[_pid][msg.sender];
1246         require(user.amount >= _amount, "withdraw: not good");
1247         updatePool(_pid);
1248         uint256 pending = user.amount.mul(pool.accRallyPerShare).div(1e12).sub(user.rewardDebt);
1249         if(pending > 0) {
1250             safeRallyTransfer(msg.sender, pending);
1251         }
1252         if(_amount > 0) {
1253             user.amount = user.amount.sub(_amount);
1254             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1255         }
1256         user.rewardDebt = user.amount.mul(pool.accRallyPerShare).div(1e12);
1257         emit Withdraw(msg.sender, _pid, _amount);
1258     }
1259 
1260     // Withdraw without caring about rewards. EMERGENCY ONLY.
1261     function emergencyWithdraw(uint256 _pid) public {
1262         PoolInfo storage pool = poolInfo[_pid];
1263         UserInfo storage user = userInfo[_pid][msg.sender];
1264         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1265         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1266         user.amount = 0;
1267         user.rewardDebt = 0;
1268     }
1269 
1270     // Safe RLY transfer function, just in case pool does not have enough RLY; either rounding error or we're not supplying more rewards
1271     function safeRallyTransfer(address _to, uint256 _amount) internal {
1272         uint256 rallyBal = rally.balanceOf(address(this));
1273         if (_amount > rallyBal) {
1274             rally.transfer(_to, rallyBal);
1275         } else {
1276             rally.transfer(_to, _amount);
1277         }
1278     }
1279 }