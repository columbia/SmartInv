1 pragma solidity 0.6.12;
2 
3 
4 // 
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
79 // 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
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
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
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
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 // 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies on extcodesize, which returns 0 for contracts in
260         // construction, since the code is only stored at the end of the
261         // constructor execution.
262 
263         uint256 size;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { size := extcodesize(account) }
266         return size > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain`call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312       return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         require(isContract(target), "Address: call to non-contract");
349 
350         // solhint-disable-next-line avoid-low-level-calls
351         (bool success, bytes memory returndata) = target.call{ value: value }(data);
352         return _verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a static call.
358      *
359      * _Available since v3.3._
360      */
361     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
362         return functionStaticCall(target, data, "Address: low-level static call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
372         require(isContract(target), "Address: static call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.staticcall(data);
376         return _verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.3._
384      */
385     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.3._
394      */
395     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
396         require(isContract(target), "Address: delegate call to non-contract");
397 
398         // solhint-disable-next-line avoid-low-level-calls
399         (bool success, bytes memory returndata) = target.delegatecall(data);
400         return _verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 // solhint-disable-next-line no-inline-assembly
412                 assembly {
413                     let returndata_size := mload(returndata)
414                     revert(add(32, returndata), returndata_size)
415                 }
416             } else {
417                 revert(errorMessage);
418             }
419         }
420     }
421 }
422 
423 // 
424 /**
425  * @title SafeERC20
426  * @dev Wrappers around ERC20 operations that throw on failure (when the token
427  * contract returns false). Tokens that return no value (and instead revert or
428  * throw on failure) are also supported, non-reverting calls are assumed to be
429  * successful.
430  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
431  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
432  */
433 library SafeERC20 {
434     using SafeMath for uint256;
435     using Address for address;
436 
437     function safeTransfer(IERC20 token, address to, uint256 value) internal {
438         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
439     }
440 
441     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
442         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
443     }
444 
445     /**
446      * @dev Deprecated. This function has issues similar to the ones found in
447      * {IERC20-approve}, and its usage is discouraged.
448      *
449      * Whenever possible, use {safeIncreaseAllowance} and
450      * {safeDecreaseAllowance} instead.
451      */
452     function safeApprove(IERC20 token, address spender, uint256 value) internal {
453         // safeApprove should only be called when setting an initial allowance,
454         // or when resetting it to zero. To increase and decrease it, use
455         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
456         // solhint-disable-next-line max-line-length
457         require((value == 0) || (token.allowance(address(this), spender) == 0),
458             "SafeERC20: approve from non-zero to non-zero allowance"
459         );
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
461     }
462 
463     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
464         uint256 newAllowance = token.allowance(address(this), spender).add(value);
465         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
466     }
467 
468     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
469         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
470         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
471     }
472 
473     /**
474      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
475      * on the return value: the return value is optional (but if data is returned, it must not be false).
476      * @param token The token targeted by the call.
477      * @param data The call data (encoded using abi.encode or one of its variants).
478      */
479     function _callOptionalReturn(IERC20 token, bytes memory data) private {
480         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
481         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
482         // the target address contains contract code and also asserts for success in the low-level call.
483 
484         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
485         if (returndata.length > 0) { // Return data is optional
486             // solhint-disable-next-line max-line-length
487             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
488         }
489     }
490 }
491 
492 // 
493 /**
494  * @dev Library for managing
495  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
496  * types.
497  *
498  * Sets have the following properties:
499  *
500  * - Elements are added, removed, and checked for existence in constant time
501  * (O(1)).
502  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
503  *
504  * ```
505  * contract Example {
506  *     // Add the library methods
507  *     using EnumerableSet for EnumerableSet.AddressSet;
508  *
509  *     // Declare a set state variable
510  *     EnumerableSet.AddressSet private mySet;
511  * }
512  * ```
513  *
514  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
515  * (`UintSet`) are supported.
516  */
517 library EnumerableSet {
518     // To implement this library for multiple types with as little code
519     // repetition as possible, we write it in terms of a generic Set type with
520     // bytes32 values.
521     // The Set implementation uses private functions, and user-facing
522     // implementations (such as AddressSet) are just wrappers around the
523     // underlying Set.
524     // This means that we can only create new EnumerableSets for types that fit
525     // in bytes32.
526 
527     struct Set {
528         // Storage of set values
529         bytes32[] _values;
530 
531         // Position of the value in the `values` array, plus 1 because index 0
532         // means a value is not in the set.
533         mapping (bytes32 => uint256) _indexes;
534     }
535 
536     /**
537      * @dev Add a value to a set. O(1).
538      *
539      * Returns true if the value was added to the set, that is if it was not
540      * already present.
541      */
542     function _add(Set storage set, bytes32 value) private returns (bool) {
543         if (!_contains(set, value)) {
544             set._values.push(value);
545             // The value is stored at length-1, but we add 1 to all indexes
546             // and use 0 as a sentinel value
547             set._indexes[value] = set._values.length;
548             return true;
549         } else {
550             return false;
551         }
552     }
553 
554     /**
555      * @dev Removes a value from a set. O(1).
556      *
557      * Returns true if the value was removed from the set, that is if it was
558      * present.
559      */
560     function _remove(Set storage set, bytes32 value) private returns (bool) {
561         // We read and store the value's index to prevent multiple reads from the same storage slot
562         uint256 valueIndex = set._indexes[value];
563 
564         if (valueIndex != 0) { // Equivalent to contains(set, value)
565             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
566             // the array, and then remove the last element (sometimes called as 'swap and pop').
567             // This modifies the order of the array, as noted in {at}.
568 
569             uint256 toDeleteIndex = valueIndex - 1;
570             uint256 lastIndex = set._values.length - 1;
571 
572             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
573             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
574 
575             bytes32 lastvalue = set._values[lastIndex];
576 
577             // Move the last value to the index where the value to delete is
578             set._values[toDeleteIndex] = lastvalue;
579             // Update the index for the moved value
580             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
581 
582             // Delete the slot where the moved value was stored
583             set._values.pop();
584 
585             // Delete the index for the deleted slot
586             delete set._indexes[value];
587 
588             return true;
589         } else {
590             return false;
591         }
592     }
593 
594     /**
595      * @dev Returns true if the value is in the set. O(1).
596      */
597     function _contains(Set storage set, bytes32 value) private view returns (bool) {
598         return set._indexes[value] != 0;
599     }
600 
601     /**
602      * @dev Returns the number of values on the set. O(1).
603      */
604     function _length(Set storage set) private view returns (uint256) {
605         return set._values.length;
606     }
607 
608    /**
609     * @dev Returns the value stored at position `index` in the set. O(1).
610     *
611     * Note that there are no guarantees on the ordering of values inside the
612     * array, and it may change when more values are added or removed.
613     *
614     * Requirements:
615     *
616     * - `index` must be strictly less than {length}.
617     */
618     function _at(Set storage set, uint256 index) private view returns (bytes32) {
619         require(set._values.length > index, "EnumerableSet: index out of bounds");
620         return set._values[index];
621     }
622 
623     // AddressSet
624 
625     struct AddressSet {
626         Set _inner;
627     }
628 
629     /**
630      * @dev Add a value to a set. O(1).
631      *
632      * Returns true if the value was added to the set, that is if it was not
633      * already present.
634      */
635     function add(AddressSet storage set, address value) internal returns (bool) {
636         return _add(set._inner, bytes32(uint256(value)));
637     }
638 
639     /**
640      * @dev Removes a value from a set. O(1).
641      *
642      * Returns true if the value was removed from the set, that is if it was
643      * present.
644      */
645     function remove(AddressSet storage set, address value) internal returns (bool) {
646         return _remove(set._inner, bytes32(uint256(value)));
647     }
648 
649     /**
650      * @dev Returns true if the value is in the set. O(1).
651      */
652     function contains(AddressSet storage set, address value) internal view returns (bool) {
653         return _contains(set._inner, bytes32(uint256(value)));
654     }
655 
656     /**
657      * @dev Returns the number of values in the set. O(1).
658      */
659     function length(AddressSet storage set) internal view returns (uint256) {
660         return _length(set._inner);
661     }
662 
663    /**
664     * @dev Returns the value stored at position `index` in the set. O(1).
665     *
666     * Note that there are no guarantees on the ordering of values inside the
667     * array, and it may change when more values are added or removed.
668     *
669     * Requirements:
670     *
671     * - `index` must be strictly less than {length}.
672     */
673     function at(AddressSet storage set, uint256 index) internal view returns (address) {
674         return address(uint256(_at(set._inner, index)));
675     }
676 
677 
678     // UintSet
679 
680     struct UintSet {
681         Set _inner;
682     }
683 
684     /**
685      * @dev Add a value to a set. O(1).
686      *
687      * Returns true if the value was added to the set, that is if it was not
688      * already present.
689      */
690     function add(UintSet storage set, uint256 value) internal returns (bool) {
691         return _add(set._inner, bytes32(value));
692     }
693 
694     /**
695      * @dev Removes a value from a set. O(1).
696      *
697      * Returns true if the value was removed from the set, that is if it was
698      * present.
699      */
700     function remove(UintSet storage set, uint256 value) internal returns (bool) {
701         return _remove(set._inner, bytes32(value));
702     }
703 
704     /**
705      * @dev Returns true if the value is in the set. O(1).
706      */
707     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
708         return _contains(set._inner, bytes32(value));
709     }
710 
711     /**
712      * @dev Returns the number of values on the set. O(1).
713      */
714     function length(UintSet storage set) internal view returns (uint256) {
715         return _length(set._inner);
716     }
717 
718    /**
719     * @dev Returns the value stored at position `index` in the set. O(1).
720     *
721     * Note that there are no guarantees on the ordering of values inside the
722     * array, and it may change when more values are added or removed.
723     *
724     * Requirements:
725     *
726     * - `index` must be strictly less than {length}.
727     */
728     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
729         return uint256(_at(set._inner, index));
730     }
731 }
732 
733 // 
734 /*
735  * @dev Provides information about the current execution context, including the
736  * sender of the transaction and its data. While these are generally available
737  * via msg.sender and msg.data, they should not be accessed in such a direct
738  * manner, since when dealing with GSN meta-transactions the account sending and
739  * paying for execution may not be the actual sender (as far as an application
740  * is concerned).
741  *
742  * This contract is only required for intermediate, library-like contracts.
743  */
744 abstract contract Context {
745     function _msgSender() internal view virtual returns (address payable) {
746         return msg.sender;
747     }
748 
749     function _msgData() internal view virtual returns (bytes memory) {
750         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
751         return msg.data;
752     }
753 }
754 
755 // 
756 /**
757  * @dev Contract module which provides a basic access control mechanism, where
758  * there is an account (an owner) that can be granted exclusive access to
759  * specific functions.
760  *
761  * By default, the owner account will be the one that deploys the contract. This
762  * can later be changed with {transferOwnership}.
763  *
764  * This module is used through inheritance. It will make available the modifier
765  * `onlyOwner`, which can be applied to your functions to restrict their use to
766  * the owner.
767  */
768 contract Ownable is Context {
769     address private _owner;
770 
771     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
772 
773     /**
774      * @dev Initializes the contract setting the deployer as the initial owner.
775      */
776     constructor () internal {
777         address msgSender = _msgSender();
778         _owner = msgSender;
779         emit OwnershipTransferred(address(0), msgSender);
780     }
781 
782     /**
783      * @dev Returns the address of the current owner.
784      */
785     function owner() public view returns (address) {
786         return _owner;
787     }
788 
789     /**
790      * @dev Throws if called by any account other than the owner.
791      */
792     modifier onlyOwner() {
793         require(_owner == _msgSender(), "Ownable: caller is not the owner");
794         _;
795     }
796 
797     /**
798      * @dev Leaves the contract without owner. It will not be possible to call
799      * `onlyOwner` functions anymore. Can only be called by the current owner.
800      *
801      * NOTE: Renouncing ownership will leave the contract without an owner,
802      * thereby removing any functionality that is only available to the owner.
803      */
804     function renounceOwnership() public virtual onlyOwner {
805         emit OwnershipTransferred(_owner, address(0));
806         _owner = address(0);
807     }
808 
809     /**
810      * @dev Transfers ownership of the contract to a new account (`newOwner`).
811      * Can only be called by the current owner.
812      */
813     function transferOwnership(address newOwner) public virtual onlyOwner {
814         require(newOwner != address(0), "Ownable: new owner is the zero address");
815         emit OwnershipTransferred(_owner, newOwner);
816         _owner = newOwner;
817     }
818 }
819 
820 // 
821 /**
822  * @dev Implementation of the {IERC20} interface.
823  *
824  * This implementation is agnostic to the way tokens are created. This means
825  * that a supply mechanism has to be added in a derived contract using {_mint}.
826  * For a generic mechanism see {ERC20PresetMinterPauser}.
827  *
828  * TIP: For a detailed writeup see our guide
829  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
830  * to implement supply mechanisms].
831  *
832  * We have followed general OpenZeppelin guidelines: functions revert instead
833  * of returning `false` on failure. This behavior is nonetheless conventional
834  * and does not conflict with the expectations of ERC20 applications.
835  *
836  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
837  * This allows applications to reconstruct the allowance for all accounts just
838  * by listening to said events. Other implementations of the EIP may not emit
839  * these events, as it isn't required by the specification.
840  *
841  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
842  * functions have been added to mitigate the well-known issues around setting
843  * allowances. See {IERC20-approve}.
844  */
845 contract ERC20 is Context, IERC20 {
846     using SafeMath for uint256;
847 
848     mapping (address => uint256) private _balances;
849 
850     mapping (address => mapping (address => uint256)) private _allowances;
851 
852     uint256 private _totalSupply;
853 
854     string private _name;
855     string private _symbol;
856     uint8 private _decimals;
857 
858     /**
859      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
860      * a default value of 18.
861      *
862      * To select a different value for {decimals}, use {_setupDecimals}.
863      *
864      * All three of these values are immutable: they can only be set once during
865      * construction.
866      */
867     constructor (string memory name, string memory symbol) public {
868         _name = name;
869         _symbol = symbol;
870         _decimals = 18;
871     }
872 
873     /**
874      * @dev Returns the name of the token.
875      */
876     function name() public view returns (string memory) {
877         return _name;
878     }
879 
880     /**
881      * @dev Returns the symbol of the token, usually a shorter version of the
882      * name.
883      */
884     function symbol() public view returns (string memory) {
885         return _symbol;
886     }
887 
888     /**
889      * @dev Returns the number of decimals used to get its user representation.
890      * For example, if `decimals` equals `2`, a balance of `505` tokens should
891      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
892      *
893      * Tokens usually opt for a value of 18, imitating the relationship between
894      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
895      * called.
896      *
897      * NOTE: This information is only used for _display_ purposes: it in
898      * no way affects any of the arithmetic of the contract, including
899      * {IERC20-balanceOf} and {IERC20-transfer}.
900      */
901     function decimals() public view returns (uint8) {
902         return _decimals;
903     }
904 
905     /**
906      * @dev See {IERC20-totalSupply}.
907      */
908     function totalSupply() public view override returns (uint256) {
909         return _totalSupply;
910     }
911 
912     /**
913      * @dev See {IERC20-balanceOf}.
914      */
915     function balanceOf(address account) public view override returns (uint256) {
916         return _balances[account];
917     }
918 
919     /**
920      * @dev See {IERC20-transfer}.
921      *
922      * Requirements:
923      *
924      * - `recipient` cannot be the zero address.
925      * - the caller must have a balance of at least `amount`.
926      */
927     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
928         _transfer(_msgSender(), recipient, amount);
929         return true;
930     }
931 
932     /**
933      * @dev See {IERC20-allowance}.
934      */
935     function allowance(address owner, address spender) public view virtual override returns (uint256) {
936         return _allowances[owner][spender];
937     }
938 
939     /**
940      * @dev See {IERC20-approve}.
941      *
942      * Requirements:
943      *
944      * - `spender` cannot be the zero address.
945      */
946     function approve(address spender, uint256 amount) public virtual override returns (bool) {
947         _approve(_msgSender(), spender, amount);
948         return true;
949     }
950 
951     /**
952      * @dev See {IERC20-transferFrom}.
953      *
954      * Emits an {Approval} event indicating the updated allowance. This is not
955      * required by the EIP. See the note at the beginning of {ERC20}.
956      *
957      * Requirements:
958      *
959      * - `sender` and `recipient` cannot be the zero address.
960      * - `sender` must have a balance of at least `amount`.
961      * - the caller must have allowance for ``sender``'s tokens of at least
962      * `amount`.
963      */
964     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
965         _transfer(sender, recipient, amount);
966         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
967         return true;
968     }
969 
970     /**
971      * @dev Atomically increases the allowance granted to `spender` by the caller.
972      *
973      * This is an alternative to {approve} that can be used as a mitigation for
974      * problems described in {IERC20-approve}.
975      *
976      * Emits an {Approval} event indicating the updated allowance.
977      *
978      * Requirements:
979      *
980      * - `spender` cannot be the zero address.
981      */
982     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
983         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
984         return true;
985     }
986 
987     /**
988      * @dev Atomically decreases the allowance granted to `spender` by the caller.
989      *
990      * This is an alternative to {approve} that can be used as a mitigation for
991      * problems described in {IERC20-approve}.
992      *
993      * Emits an {Approval} event indicating the updated allowance.
994      *
995      * Requirements:
996      *
997      * - `spender` cannot be the zero address.
998      * - `spender` must have allowance for the caller of at least
999      * `subtractedValue`.
1000      */
1001     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1002         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1003         return true;
1004     }
1005 
1006     /**
1007      * @dev Moves tokens `amount` from `sender` to `recipient`.
1008      *
1009      * This is internal function is equivalent to {transfer}, and can be used to
1010      * e.g. implement automatic token fees, slashing mechanisms, etc.
1011      *
1012      * Emits a {Transfer} event.
1013      *
1014      * Requirements:
1015      *
1016      * - `sender` cannot be the zero address.
1017      * - `recipient` cannot be the zero address.
1018      * - `sender` must have a balance of at least `amount`.
1019      */
1020     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1021         require(sender != address(0), "ERC20: transfer from the zero address");
1022         require(recipient != address(0), "ERC20: transfer to the zero address");
1023 
1024         _beforeTokenTransfer(sender, recipient, amount);
1025 
1026         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1027         _balances[recipient] = _balances[recipient].add(amount);
1028         emit Transfer(sender, recipient, amount);
1029     }
1030 
1031     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1032      * the total supply.
1033      *
1034      * Emits a {Transfer} event with `from` set to the zero address.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      */
1040     function _mint(address account, uint256 amount) internal virtual {
1041         require(account != address(0), "ERC20: mint to the zero address");
1042 
1043         _beforeTokenTransfer(address(0), account, amount);
1044 
1045         _totalSupply = _totalSupply.add(amount);
1046         _balances[account] = _balances[account].add(amount);
1047         emit Transfer(address(0), account, amount);
1048     }
1049 
1050     /**
1051      * @dev Destroys `amount` tokens from `account`, reducing the
1052      * total supply.
1053      *
1054      * Emits a {Transfer} event with `to` set to the zero address.
1055      *
1056      * Requirements:
1057      *
1058      * - `account` cannot be the zero address.
1059      * - `account` must have at least `amount` tokens.
1060      */
1061     function _burn(address account, uint256 amount) internal virtual {
1062         require(account != address(0), "ERC20: burn from the zero address");
1063 
1064         _beforeTokenTransfer(account, address(0), amount);
1065 
1066         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1067         _totalSupply = _totalSupply.sub(amount);
1068         emit Transfer(account, address(0), amount);
1069     }
1070 
1071     /**
1072      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1073      *
1074      * This internal function is equivalent to `approve`, and can be used to
1075      * e.g. set automatic allowances for certain subsystems, etc.
1076      *
1077      * Emits an {Approval} event.
1078      *
1079      * Requirements:
1080      *
1081      * - `owner` cannot be the zero address.
1082      * - `spender` cannot be the zero address.
1083      */
1084     function _approve(address owner, address spender, uint256 amount) internal virtual {
1085         require(owner != address(0), "ERC20: approve from the zero address");
1086         require(spender != address(0), "ERC20: approve to the zero address");
1087 
1088         _allowances[owner][spender] = amount;
1089         emit Approval(owner, spender, amount);
1090     }
1091 
1092     /**
1093      * @dev Sets {decimals} to a value other than the default one of 18.
1094      *
1095      * WARNING: This function should only be called from the constructor. Most
1096      * applications that interact with token contracts will not expect
1097      * {decimals} to ever change, and may work incorrectly if it does.
1098      */
1099     function _setupDecimals(uint8 decimals_) internal {
1100         _decimals = decimals_;
1101     }
1102 
1103     /**
1104      * @dev Hook that is called before any transfer of tokens. This includes
1105      * minting and burning.
1106      *
1107      * Calling conditions:
1108      *
1109      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1110      * will be to transferred to `to`.
1111      * - when `from` is zero, `amount` tokens will be minted for `to`.
1112      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1113      * - `from` and `to` are never both zero.
1114      *
1115      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1116      */
1117     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1118 }
1119 
1120 // 
1121 // LumosToken
1122 contract LumosToken is ERC20("Lumos", "LMS"), Ownable {
1123     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner
1124     function mint(address _to, uint256 _amount) public onlyOwner {
1125         _mint(_to, _amount);
1126     }
1127 }
1128 
1129 interface IUniswapV2Pair {
1130     event Approval(address indexed owner, address indexed spender, uint value);
1131     event Transfer(address indexed from, address indexed to, uint value);
1132 
1133     function name() external pure returns (string memory);
1134     function symbol() external pure returns (string memory);
1135     function decimals() external pure returns (uint8);
1136     function totalSupply() external view returns (uint);
1137     function balanceOf(address owner) external view returns (uint);
1138     function allowance(address owner, address spender) external view returns (uint);
1139 
1140     function approve(address spender, uint value) external returns (bool);
1141     function transfer(address to, uint value) external returns (bool);
1142     function transferFrom(address from, address to, uint value) external returns (bool);
1143 
1144     function DOMAIN_SEPARATOR() external view returns (bytes32);
1145     function PERMIT_TYPEHASH() external pure returns (bytes32);
1146     function nonces(address owner) external view returns (uint);
1147 
1148     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1149 
1150     event Mint(address indexed sender, uint amount0, uint amount1);
1151     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1152     event Swap(
1153         address indexed sender,
1154         uint amount0In,
1155         uint amount1In,
1156         uint amount0Out,
1157         uint amount1Out,
1158         address indexed to
1159     );
1160     event Sync(uint112 reserve0, uint112 reserve1);
1161 
1162     function MINIMUM_LIQUIDITY() external pure returns (uint);
1163     function factory() external view returns (address);
1164     function token0() external view returns (address);
1165     function token1() external view returns (address);
1166     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1167     function price0CumulativeLast() external view returns (uint);
1168     function price1CumulativeLast() external view returns (uint);
1169     function kLast() external view returns (uint);
1170 
1171     function mint(address to) external returns (uint liquidity);
1172     function burn(address to) external returns (uint amount0, uint amount1);
1173     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1174     function skim(address to) external;
1175     function sync() external;
1176 
1177     function initialize(address, address) external;
1178 }
1179 
1180 // 
1181 // computes square roots using the babylonian method
1182 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
1183 library Babylonian {
1184     function sqrt(uint y) internal pure returns (uint z) {
1185         if (y > 3) {
1186             z = y;
1187             uint x = y / 2 + 1;
1188             while (x < z) {
1189                 z = x;
1190                 x = (y / x + x) / 2;
1191             }
1192         } else if (y != 0) {
1193             z = 1;
1194         }
1195         // else z = 0
1196     }
1197 }
1198 
1199 // 
1200 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
1201 library FixedPoint {
1202     // range: [0, 2**112 - 1]
1203     // resolution: 1 / 2**112
1204     struct uq112x112 {
1205         uint224 _x;
1206     }
1207 
1208     // range: [0, 2**144 - 1]
1209     // resolution: 1 / 2**112
1210     struct uq144x112 {
1211         uint _x;
1212     }
1213 
1214     uint8 private constant RESOLUTION = 112;
1215     uint private constant Q112 = uint(1) << RESOLUTION;
1216     uint private constant Q224 = Q112 << RESOLUTION;
1217 
1218     // encode a uint112 as a UQ112x112
1219     function encode(uint112 x) internal pure returns (uq112x112 memory) {
1220         return uq112x112(uint224(x) << RESOLUTION);
1221     }
1222 
1223     // encodes a uint144 as a UQ144x112
1224     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
1225         return uq144x112(uint256(x) << RESOLUTION);
1226     }
1227 
1228     // divide a UQ112x112 by a uint112, returning a UQ112x112
1229     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
1230         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
1231         return uq112x112(self._x / uint224(x));
1232     }
1233 
1234     // multiply a UQ112x112 by a uint, returning a UQ144x112
1235     // reverts on overflow
1236     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
1237         uint z;
1238         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
1239         return uq144x112(z);
1240     }
1241 
1242     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
1243     // equivalent to encode(numerator).div(denominator)
1244     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
1245         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
1246         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
1247     }
1248 
1249     // decode a UQ112x112 into a uint112 by truncating after the radix point
1250     function decode(uq112x112 memory self) internal pure returns (uint112) {
1251         return uint112(self._x >> RESOLUTION);
1252     }
1253 
1254     // decode a UQ144x112 into a uint144 by truncating after the radix point
1255     function decode144(uq144x112 memory self) internal pure returns (uint144) {
1256         return uint144(self._x >> RESOLUTION);
1257     }
1258 
1259     // take the reciprocal of a UQ112x112
1260     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
1261         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
1262         return uq112x112(uint224(Q224 / self._x));
1263     }
1264 
1265     // square root of a UQ112x112
1266     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
1267         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
1268     }
1269 }
1270 
1271 // 
1272 // library with helper methods for oracles that are concerned with computing average prices
1273 library UniswapV2OracleLibrary {
1274     using FixedPoint for *;
1275 
1276     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
1277     function currentBlockTimestamp() internal view returns (uint32) {
1278         return uint32(block.timestamp % 2 ** 32);
1279     }
1280 
1281     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
1282     function currentCumulativePrices(
1283         address pair,
1284         bool isToken0
1285     ) internal view returns (uint priceCumulative, uint32 blockTimestamp) {
1286         blockTimestamp = currentBlockTimestamp();
1287         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
1288         if (isToken0) {
1289           priceCumulative = IUniswapV2Pair(pair).price0CumulativeLast();
1290 
1291           // if time has elapsed since the last update on the pair, mock the accumulated price values
1292           if (blockTimestampLast != blockTimestamp) {
1293               // subtraction overflow is desired
1294               uint32 timeElapsed = blockTimestamp - blockTimestampLast;
1295               // addition overflow is desired
1296               // counterfactual
1297               priceCumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
1298           }
1299         } else {
1300           priceCumulative = IUniswapV2Pair(pair).price1CumulativeLast();
1301           // if time has elapsed since the last update on the pair, mock the accumulated price values
1302           if (blockTimestampLast != blockTimestamp) {
1303               // subtraction overflow is desired
1304               uint32 timeElapsed = blockTimestamp - blockTimestampLast;
1305               // addition overflow is desired
1306               // counterfactual
1307               priceCumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
1308           }
1309         }
1310 
1311     }
1312     function getUniswapV2Pair(address _token0, address _token1) internal pure returns (address uni_pair, bool isToken0) {
1313         
1314         (address token0, address token1) = UniswapV2OracleLibrary.sortTokens(
1315             _token0,
1316             _token1
1317         );
1318         //bool _isToken0;
1319         // used for interacting with uniswap
1320         if (token0 == _token0) {
1321             isToken0 = true;
1322         } else {
1323             isToken0 = false;
1324         }
1325 
1326         uni_pair = UniswapV2OracleLibrary.pairFor(address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f), token0, token1);
1327 
1328         return (uni_pair, isToken0);
1329 
1330     }
1331     /* - Constructor Helpers - */
1332 
1333     // calculates the CREATE2 address for a pair without making any external calls
1334     function pairFor(
1335         address factory,
1336         address token0,
1337         address token1
1338     ) internal pure returns (address pair) {
1339         pair = address(
1340             uint256(
1341                 keccak256(
1342                     abi.encodePacked(
1343                         hex"ff",
1344                         factory,
1345                         keccak256(abi.encodePacked(token0, token1)),
1346                         hex"96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f" // init code hash
1347                     )
1348                 )
1349             )
1350         );
1351     }
1352 
1353     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1354     function sortTokens(address tokenA, address tokenB)
1355         internal
1356         pure
1357         returns (address token0, address token1)
1358     {
1359         require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
1360         (token0, token1) = tokenA < tokenB
1361             ? (tokenA, tokenB)
1362             : (tokenB, tokenA);
1363         require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");
1364     }
1365 }
1366 
1367 // 
1368 interface IMakerPriceFeed {
1369   function read() external view returns (bytes32);
1370 }
1371 
1372 // 
1373 /// math.sol -- mixin for inline numerical wizardry
1374 // This program is free software: you can redistribute it and/or modify
1375 // it under the terms of the GNU General Public License as published by
1376 // the Free Software Foundation, either version 3 of the License, or
1377 // (at your option) any later version.
1378 // This program is distributed in the hope that it will be useful,
1379 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1380 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1381 // GNU General Public License for more details.
1382 // You should have received a copy of the GNU General Public License
1383 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1384 library DSMath {
1385     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
1386         require((z = x + y) >= x, "ds-math-add-overflow");
1387     }
1388 
1389     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
1390         require((z = x - y) <= x, "ds-math-sub-underflow");
1391     }
1392 
1393     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1394         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
1395     }
1396 
1397     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
1398         require(y > 0, "ds-math-division-by-zero");
1399         return x / y;
1400     }
1401 
1402     function add(
1403         uint256 x,
1404         uint256 y,
1405         string memory errorMessage
1406     ) internal pure returns (uint256 z) {
1407         require((z = x + y) >= x, errorMessage);
1408     }
1409 
1410     function sub(
1411         uint256 x,
1412         uint256 y,
1413         string memory errorMessage
1414     ) internal pure returns (uint256 z) {
1415         require((z = x - y) <= x, errorMessage);
1416     }
1417 
1418     function mul(
1419         uint256 x,
1420         uint256 y,
1421         string memory errorMessage
1422     ) internal pure returns (uint256 z) {
1423         require(y == 0 || (z = x * y) / y == x, errorMessage);
1424     }
1425 
1426     function div(
1427         uint256 x,
1428         uint256 y,
1429         string memory errorMessage
1430     ) internal pure returns (uint256 z) {
1431         require(y > 0, errorMessage);
1432         return x / y;
1433     }
1434 
1435     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
1436         return x <= y ? x : y;
1437     }
1438 
1439     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
1440         return x >= y ? x : y;
1441     }
1442 
1443     function imin(int256 x, int256 y) internal pure returns (int256 z) {
1444         return x <= y ? x : y;
1445     }
1446 
1447     function imax(int256 x, int256 y) internal pure returns (int256 z) {
1448         return x >= y ? x : y;
1449     }
1450 
1451     uint256 constant WAD = 10**18;
1452     uint256 constant RAY = 10**27;
1453 
1454     //rounds to zero if x*y < WAD / 2
1455     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1456         z = add(mul(x, y), WAD / 2) / WAD;
1457     }
1458 
1459     //rounds to zero if x*y < WAD / 2
1460     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1461         z = add(mul(x, y), RAY / 2) / RAY;
1462     }
1463 
1464     //rounds to zero if x*y < WAD / 2
1465     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
1466         z = add(mul(x, WAD), y / 2) / y;
1467     }
1468     /*
1469     function wdivM(uint256 x, uint256 y) internal pure returns (uint256 z) {
1470         x = toWAD18(x);
1471         y = toWAD18(y);
1472         z = add(mul(x, WAD), y / 2) / y;
1473     }
1474    */
1475     //rounds to zero if x*y < RAY / 2
1476     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
1477         z = add(mul(x, RAY), y / 2) / y;
1478     }
1479 
1480     function toWAD18(uint256 x) internal pure returns (uint256 z) {
1481         z = mul(x, WAD);
1482     }
1483 
1484     function toRAY27(uint256 x) internal pure returns (uint256 z) {
1485         z = mul(x, RAY);
1486     }
1487 
1488     // computes square roots using the babylonian method
1489     // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
1490 
1491     function sqrt(uint256 y) internal pure returns (uint256 z) {
1492         if (y > 3) {
1493             z = y;
1494             uint256 x = y / 2 + 1;
1495             while (x < z) {
1496                 z = x;
1497                 x = (y / x + x) / 2;
1498             }
1499         } else if (y != 0) {
1500             z = 1;
1501         }
1502         // else z = 0
1503     }
1504 
1505     // This famous algorithm is called "exponentiation by squaring"
1506     // and calculates x^n with x as fixed-point and n as regular unsigned.
1507     //
1508     // It's O(log n), instead of O(n) for naive repeated multiplication.
1509     //
1510     // These facts are why it works:
1511     //
1512     //  If n is even, then x^n = (x^2)^(n/2).
1513     //  If n is odd,  then x^n = x * x^(n-1),
1514     //   and applying the equation for even x gives
1515     //    x^n = x * (x^2)^((n-1) / 2).
1516     //
1517     //  Also, EVM division is flooring and
1518     //    floor[(n-1) / 2] = floor[n / 2].
1519     //
1520     function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
1521         z = n % 2 != 0 ? x : RAY;
1522 
1523         for (n /= 2; n != 0; n /= 2) {
1524             x = rmul(x, x);
1525 
1526             if (n % 2 != 0) {
1527                 z = rmul(z, x);
1528             }
1529         }
1530     }
1531 }
1532 
1533 // 
1534 // Grand Master is the wisest and oldest Wizard of lumos. He now governs over LUMOS. He's wise and helpful so he lets adventurers
1535 //craft LMS while they learn casting spells. He will guide you all in all fairness.
1536 //
1537 // Note that it's ownable and the owner wields tremendous power. The ownership
1538 // will be transferred to a governance smart contract once the key ingredient LMS is sufficiently
1539 // distributed and the community can show to govern itself in peace.
1540 //
1541 // Have fun reading it. Hopefully it's bug-free. May the magic be with you.
1542 contract MasterWizard is Ownable {
1543     using DSMath for uint;
1544     using SafeERC20 for IERC20;
1545 
1546     // Info of each adventurer.
1547     struct UserInfo {
1548         uint amount; // How many LP tokens the adventurer has provided.
1549         uint rewardDebt; // Reward debt. See explanation below.
1550         uint lastHarvestBlock;
1551         uint totalHarvestReward;
1552         //
1553         // We do some fancy math here. Basically, any point in time, the amount of LMS
1554         // entitled to an adventurer but is pending to be distributed is:
1555         //
1556         //   pending reward = (user.amount * pool.accLumosPerShare) - user.rewardDebt
1557         //
1558         // Whenever an adventurer deposits or withdraws LP tokens to a pool. Here's what happens:
1559         //   1. The pool's `accLumosPerShare` (and `lastRewardBlock`) gets updated.
1560         //   2. Adventurer receives the pending reward sent to his/her address.
1561         //   3. Adventurer's `amount` gets updated.
1562         //   4. Adventurer's `rewardDebt` gets updated.
1563     }
1564 
1565     // Info of each pool.
1566     struct PoolInfo {
1567         IERC20 lpToken; // Address of LP token contract.
1568         uint allocPoint; // How many allocation points assigned to this pool. LMS to distribute per block.
1569         uint lastRewardBlock; // Last block number that LMS distribution occurs.
1570         uint accLumosPerShare; // Accumulated LMS per share, times 1e6. See below.
1571     }
1572 
1573     // The LUMOS TOKEN!
1574     LumosToken public lumos;
1575     // Dev fund (2%, initially)
1576     uint public devFundDivRate = 50 * 1e18; //Wizards casting spells while teaching so some LMS is created. These will be used wisely to develop Lumos. 
1577     // Dev address.
1578     address public devaddr;
1579     // LUMOS tokens created per block.
1580     uint public lumosPerBlock;
1581 
1582     // Info of each pool.
1583     PoolInfo[] public poolInfo;
1584 
1585     mapping(address => uint256) public poolId1; // poolId1 count from 1, subtraction 1 before using with poolInfo
1586 
1587     // Info of each user that stakes LP tokens.
1588     mapping(uint => mapping(address => UserInfo)) public userInfo;
1589     // Total allocation points. Must be the sum of all allocation points in all pools.
1590     uint public totalAllocPoint = 0;
1591     // The block number when LMS mining starts.
1592     uint public startBlock;
1593 
1594     uint public endBlock;
1595     //uint public endBlock;
1596     uint public startBlockTime;
1597 
1598     /// @notice pair for reserveToken <> LMS
1599     address public uniswap_pair;
1600 
1601     /// @notice last TWAP update time
1602     uint public blockTimestampLast;
1603 
1604     /// @notice last TWAP cumulative price;
1605     uint public priceCumulativeLast;
1606 
1607     /// @notice Whether or not this token is first in uniswap LMS<>Reserve pair
1608     bool public isToken0;
1609 
1610     uint public lmsPriceMultiplier;
1611 
1612     uint public minLMSTWAPIntervalSec;
1613 
1614     address public makerEthPriceFeed;
1615 
1616     uint public timeOfInitTWAP;
1617 
1618     //bool public testMode;
1619 
1620     bool public craftingEnded;
1621 
1622     // Events
1623     event Recovered(address token, uint amount);
1624     event Deposit(address indexed user, uint indexed pid, uint amount);
1625     event Withdraw(address indexed user, uint indexed pid, uint amount);
1626     event EmergencyWithdraw(
1627         address indexed user,
1628         uint indexed pid,
1629         uint amount
1630     );
1631 
1632     constructor(
1633         LumosToken _lumos,
1634         address reserveToken_,//WETH
1635         address _devaddr
1636         //,bool _testMode
1637     ) public {
1638         lumos = _lumos;
1639         devaddr = _devaddr;
1640         //startBlock = _startBlock;
1641 
1642         (address _uniswap_pair, bool _isToken0) = UniswapV2OracleLibrary.getUniswapV2Pair(address(lumos),reserveToken_);
1643 
1644         uniswap_pair = _uniswap_pair;
1645         isToken0 = _isToken0;
1646 
1647         makerEthPriceFeed = 0x729D19f657BD0614b4985Cf1D82531c67569197B;
1648         /*
1649         testMode = _testMode;
1650         
1651          if(testMode == true) {
1652             minLMSTWAPIntervalSec = 1 minutes;
1653          }
1654          else {
1655         */          
1656         minLMSTWAPIntervalSec = 24 hours;
1657         // }
1658 
1659          //init_TWAP();
1660     }
1661 
1662     function poolLength() external view returns (uint) {
1663         return poolInfo.length;
1664     }
1665 
1666     function start_crafting() external onlyOwner {
1667         require(startBlock > 0 && block.number > startBlock, "not this time.!");
1668         require(startBlockTime == 0, "crafting already started.!");
1669 
1670         startBlockTime = block.timestamp;
1671 
1672         lumosPerBlock = getLumosPerBlock();
1673         lmsPriceMultiplier = 1e18;
1674 
1675         massUpdatePools();
1676     }
1677    function end_crafting() external 
1678     {
1679         require(startBlockTime > 0, "crafting not started.!");
1680 
1681         if(lumos.totalSupply() > (1e18 * 2000000)) {
1682 
1683             massUpdatePools();
1684 
1685             craftingEnded = true;
1686             endBlock = block.number;
1687         }
1688 
1689     }
1690     function init_TWAP() public onlyOwner {
1691         require(timeOfInitTWAP == 0,"already initialized.!");
1692         (uint priceCumulative, uint32 blockTimestamp) = UniswapV2OracleLibrary.currentCumulativePrices(uniswap_pair, isToken0);
1693 
1694         require(blockTimestamp > 0, "no trades");
1695 
1696         blockTimestampLast = blockTimestamp;
1697         priceCumulativeLast = priceCumulative;
1698         timeOfInitTWAP = blockTimestamp;
1699     }
1700 
1701     // Add a new lp to the pool. Can only be called by the owner.
1702     function add(
1703         uint _allocPoint,
1704         IERC20 _lpToken,
1705         bool _withUpdate
1706     ) public onlyOwner {
1707         require(poolId1[address(_lpToken)] == 0, "add: lp is already in pool");
1708 
1709         if (_withUpdate) {
1710             massUpdatePools();
1711         }
1712         _allocPoint = _allocPoint.toWAD18();
1713 
1714         uint lastRewardBlock = block.number > startBlock
1715             ? block.number
1716             : startBlock;
1717         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1718         poolId1[address(_lpToken)] = poolInfo.length + 1;
1719         poolInfo.push(
1720             PoolInfo({
1721                 lpToken: _lpToken,
1722                 allocPoint: _allocPoint,
1723                 lastRewardBlock: lastRewardBlock,
1724                 accLumosPerShare: 0
1725             })
1726         );
1727     }
1728 
1729     // Update the given pool's LMS allocation point. Can only be called by the owner.
1730     function set(
1731         uint _pid,
1732         uint _allocPoint,
1733         bool _withUpdate
1734     ) public onlyOwner {
1735         if (_withUpdate) {
1736             massUpdatePools();
1737         }
1738 
1739         _allocPoint = _allocPoint.toWAD18();
1740 
1741         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1742             _allocPoint
1743         );
1744         poolInfo[_pid].allocPoint = _allocPoint;
1745     }
1746      //Updates the price of LMS token
1747     function getTWAP() private returns (uint) {
1748 
1749         (uint priceCumulative,uint blockTimestamp) = UniswapV2OracleLibrary.currentCumulativePrices(uniswap_pair, isToken0);
1750         
1751         uint timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
1752 
1753         // overflow is desired, casting never truncates
1754         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
1755         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
1756             uint224((priceCumulative - priceCumulativeLast) / timeElapsed)
1757         );
1758 
1759         priceCumulativeLast = priceCumulative;
1760         blockTimestampLast = blockTimestamp;
1761 
1762         return FixedPoint.decode144(FixedPoint.mul(priceAverage, 10**18));
1763     }
1764     function getCurrentTWAP() public view returns (uint) {
1765 
1766         (uint priceCumulative,uint blockTimestamp) = UniswapV2OracleLibrary.currentCumulativePrices(uniswap_pair, isToken0);
1767         
1768         uint timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
1769 
1770         // overflow is desired, casting never truncates
1771         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
1772         FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
1773             uint224((priceCumulative - priceCumulativeLast) / timeElapsed)
1774         );
1775 
1776         return FixedPoint.decode144(FixedPoint.mul(priceAverage, 10**18));
1777     }
1778     //Updates the ETHUSD price to calculate LMS price in USD. 
1779     function getETHUSDPrice() public view returns(uint) {
1780         /*if(testMode){
1781             return 384.2e18;
1782         }*/
1783         return uint(IMakerPriceFeed(makerEthPriceFeed).read());
1784     }
1785     // Return reward multiplier over the given _from to _to block.
1786     function getMultiplier(uint _from, uint _to) private view returns (uint) {
1787         //require(startBlockTime > 0, "farming not activated yet.!");
1788         uint _blockCount = _to.sub(_from);
1789 
1790         return lumosPerBlock.wmul(lmsPriceMultiplier).mul(_blockCount);//.wdiv(1 ether);
1791     }
1792 
1793     // View function to see pending LMS on frontend.
1794     function pendingLumos(uint _pid, address _user)
1795         external
1796         view
1797         returns (uint)
1798     {
1799         PoolInfo storage pool = poolInfo[_pid];
1800         UserInfo storage user = userInfo[_pid][_user];
1801         uint accLumosPerShare = pool.accLumosPerShare;
1802         uint lpSupply = pool.lpToken.balanceOf(address(this));
1803         if (block.number > pool.lastRewardBlock && lpSupply != 0 && craftingEnded == false) {
1804             uint multiplier = getMultiplier(
1805                 pool.lastRewardBlock,
1806                 block.number
1807             );
1808             uint lumosReward = multiplier
1809             //.mul(lumosPerBlock)
1810                 .wmul(pool.allocPoint)
1811                 .wdiv(totalAllocPoint);
1812                 //.wdiv(1e18);
1813             accLumosPerShare = accLumosPerShare.add(
1814                 lumosReward
1815                 .mul(1e6)
1816                 .wdiv(lpSupply)
1817             );
1818         }
1819         return user.amount.wmul(accLumosPerShare)
1820         .div(1e6)
1821         .sub(user.rewardDebt);
1822     }
1823 
1824     // Update reward vairables for all pools. Be careful of gas spending!
1825     function massUpdatePools() public {
1826         uint length = poolInfo.length;
1827         for (uint pid = 0; pid < length; ++pid) {
1828             updatePool(pid);
1829         }
1830     }
1831 
1832     // Update reward variables of the given pool to be up-to-date.
1833     function updatePool(uint _pid) public {
1834         if(startBlock == 0) {
1835             return;
1836         }
1837 
1838         PoolInfo storage pool = poolInfo[_pid];
1839         if (block.number <= pool.lastRewardBlock) {
1840             return;
1841         }
1842         uint lpSupply = pool.lpToken.balanceOf(address(this));
1843         if (lpSupply == 0) {
1844             pool.lastRewardBlock = block.number;
1845             return;
1846         }
1847         
1848         if(craftingEnded){
1849             return;
1850         }
1851 
1852         uint multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1853         uint lmsReward = multiplier
1854         //.mul(lumosPerBlock)
1855             .wmul(pool.allocPoint)
1856             .wdiv(totalAllocPoint);
1857             //.wdiv(1e18);
1858         lumos.mint(devaddr, lmsReward.wdiv(devFundDivRate));
1859         lumos.mint(address(this), lmsReward);
1860         pool.accLumosPerShare = pool.accLumosPerShare.add(
1861             lmsReward
1862             .mul(1e6)
1863             .wdiv(lpSupply)
1864         );
1865         pool.lastRewardBlock = block.number;
1866     }
1867 
1868     // Deposit LP tokens to MasterWizard for LMS allocation.
1869     function deposit(uint _pid, uint _amount) public {
1870         require(startBlockTime > 0, "crafting not activated yet.!");
1871         
1872         PoolInfo storage pool = poolInfo[_pid];
1873         UserInfo storage user = userInfo[_pid][msg.sender];
1874         updatePool(_pid);
1875         if (user.amount > 0) {
1876             uint pending = user
1877                 .amount
1878                 .wmul(pool.accLumosPerShare)
1879                 .div(1e6)
1880                 .sub(user.rewardDebt);
1881             if (pending > 0) {
1882                 uint _harvestMultiplier = getLumosHarvestMultiplier(
1883                     user.lastHarvestBlock
1884                 );
1885 
1886                 uint _harvestBonus = pending.wmul(_harvestMultiplier);
1887 
1888                 // With magic, Grand Master rewards adventurer if she chooses to let their rewards stays in the Crafting Pool.    
1889                 if (_harvestBonus > 1e18) {
1890                     lumos.mint(msg.sender, _harvestBonus);
1891                     user.totalHarvestReward = user.totalHarvestReward.add(
1892                         _harvestBonus
1893                     );
1894                 }
1895                 safeLMSTransfer(msg.sender, pending);
1896             }
1897         }
1898         if (_amount > 0) {
1899             pool.lpToken.safeTransferFrom(
1900                 address(msg.sender),
1901                 address(this),
1902                 _amount
1903             );
1904             user.amount = user.amount.add(_amount);
1905         }
1906         user.lastHarvestBlock = block.number;
1907         user.rewardDebt = user.amount.wmul(pool.accLumosPerShare).div(1e6);
1908 
1909         emit Deposit(msg.sender, _pid, _amount);
1910     }
1911 
1912     // Withdraw LP tokens from MasterWizard.
1913     function withdraw(uint _pid, uint _amount) public {
1914         PoolInfo storage pool = poolInfo[_pid];
1915         UserInfo storage user = userInfo[_pid][msg.sender];
1916         require(user.amount >= _amount, "withdraw: not good");
1917 
1918         updatePool(_pid);
1919         uint pending = user.amount.wmul(pool.accLumosPerShare)
1920         .div(1e6)
1921         .sub(user.rewardDebt);
1922 
1923         if (pending > 0) {
1924             safeLMSTransfer(msg.sender, pending);
1925         }
1926         if (_amount > 0) {
1927             user.amount = user.amount.sub(_amount);
1928             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1929         }
1930         user.rewardDebt = user.amount.wmul(pool.accLumosPerShare).div(1e6);
1931 
1932         user.lastHarvestBlock = block.number;
1933 
1934         emit Withdraw(msg.sender, _pid, _amount);
1935     }
1936 
1937     // Withdraw without caring about rewards. EMERGENCY ONLY.
1938     function emergencyWithdraw(uint _pid) public {
1939         PoolInfo storage pool = poolInfo[_pid];
1940         UserInfo storage user = userInfo[_pid][msg.sender];
1941         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1942         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1943         user.amount = 0;
1944         user.rewardDebt = 0;
1945         user.lastHarvestBlock = block.number;
1946         // user.withdrawalCount++;
1947     }
1948 
1949     // Safe lumos transfer function, just in case if rounding error causes pool to not have enough LMS.
1950     function safeLMSTransfer(address _to, uint _amount) private {
1951         uint lmsBalance = lumos.balanceOf(address(this));
1952         if (_amount > lmsBalance) {
1953             lumos.transfer(_to, lmsBalance);
1954         } else {
1955             lumos.transfer(_to, _amount);
1956         }
1957     }
1958 
1959     // Update dev address by the previous dev.
1960     //function dev(address _devaddr) public {
1961     //    require(msg.sender == devaddr, "dev: wut?");
1962     //    devaddr = _devaddr;
1963     //}
1964     /*
1965     function setStartBlockTime(uint _startBlockTime) external {
1966         require(testMode, "testing or not ?");
1967 
1968         startBlockTime = _startBlockTime;
1969     }
1970     */
1971     function setLumosPerBlock() external {
1972         require(startBlockTime > 0, "crafting not activated yet.!");
1973 
1974         uint _lumosPerBlock = getLumosPerBlock();
1975         if(_lumosPerBlock != lumosPerBlock){
1976             massUpdatePools();
1977             
1978             lumosPerBlock = _lumosPerBlock;
1979         }
1980     }
1981     /*
1982     function getLumosTotalSupply() external view returns(uint) {
1983         require(testMode, "testing or not ?");
1984 
1985         return lumos.totalSupply();
1986     }
1987 */
1988     // Community casting this spell every day and decides the daily bonus multiplier for the next day. This spell can be cast only once in every day. 
1989     function setLMSPriceMultiplier() external {
1990         require(startBlockTime > 0 && blockTimestampLast.add(minLMSTWAPIntervalSec) < now, "not this time.!");
1991         require(timeOfInitTWAP > 0, "crafting not initialized.!");
1992         require(craftingEnded == false, "crafting ended :(");
1993         
1994         massUpdatePools();
1995         
1996         setLMSPriceMultiplierInt();
1997     }
1998     function getCurrentPriceMultiplier() external view returns(uint){
1999 
2000         uint _lmsPriceETH = getCurrentTWAP();
2001         uint _ethPriceUSD = getETHUSDPrice();
2002         uint _price = _lmsPriceETH.wmul(_ethPriceUSD);
2003 
2004         if (_price < 3e18) 
2005             return 1e18;
2006         else if (_price >= 3e18 && _price < 5e18)
2007             return 2e18; 
2008         else if (_price >= 5e18 && _price < 8e18)
2009             return 3e18;
2010         else return 4e18;
2011     }
2012     function setLMSPriceMultiplierInt() private {
2013         if(startBlockTime == 0 || blockTimestampLast.add(minLMSTWAPIntervalSec) > now || timeOfInitTWAP == 0 || craftingEnded == true) {
2014             return;
2015         }
2016         uint _lmsPriceETH = getTWAP();
2017         uint _ethPriceUSD = getETHUSDPrice();
2018         uint _price = _lmsPriceETH.wmul(_ethPriceUSD);
2019 
2020         if (_price < 3e18) 
2021             lmsPriceMultiplier = 1e18;
2022         else if (_price >= 3e18 && _price < 5e18)
2023             lmsPriceMultiplier = 2e18; 
2024         else if (_price >= 5e18 && _price < 8e18)
2025             lmsPriceMultiplier = 3e18;
2026         else lmsPriceMultiplier = 4e18;
2027 
2028         lumosPerBlock = getLumosPerBlock();
2029     }
2030 
2031     // lumos per block multiplier
2032     function getLumosPerBlock() private view returns (uint) {
2033         uint elapsedDays = ((now - startBlockTime).div(86400) + 1) * 1e6;
2034         return elapsedDays.sqrt().wdiv(6363);
2035     }
2036 
2037     // harvest multiplier
2038     function getLumosHarvestMultiplier(uint _lastHarvestBlock) private view returns (uint) {
2039         return
2040             (block.number - _lastHarvestBlock).wdiv(67000).min(1e18);
2041     }
2042 
2043     function setStartBlock(uint _startBlock) external onlyOwner {
2044         require(startBlock == 0 && _startBlock > 0, " startBlock > 0 ?");
2045         startBlock = _startBlock;
2046     }
2047 
2048     function setDevFundDivRate(uint _devFundDivRate) external onlyOwner {
2049         require(_devFundDivRate > 0, "dev fund rate 0 ?");
2050         devFundDivRate = _devFundDivRate;
2051     }
2052 
2053     function setminLMSTWAPIntervalSec(uint _interval) external onlyOwner {
2054         require(_interval > 0, "minLMSTWAPIntervalSec 0 ?");
2055         minLMSTWAPIntervalSec = _interval;
2056     }    
2057 }