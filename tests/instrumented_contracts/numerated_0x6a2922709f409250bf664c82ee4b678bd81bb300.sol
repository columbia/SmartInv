1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-07
3 */
4 
5 pragma solidity 0.6.12;
6 
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
81 
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
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize, which returns 0 for contracts in
261         // construction, since the code is only stored at the end of the
262         // constructor execution.
263 
264         uint256 size;
265         // solhint-disable-next-line no-inline-assembly
266         assembly { size := extcodesize(account) }
267         return size > 0;
268     }
269 
270     /**
271      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
272      * `recipient`, forwarding all available gas and reverting on errors.
273      *
274      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
275      * of certain opcodes, possibly making contracts go over the 2300 gas limit
276      * imposed by `transfer`, making them unable to receive funds via
277      * `transfer`. {sendValue} removes this limitation.
278      *
279      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
280      *
281      * IMPORTANT: because control is transferred to `recipient`, care must be
282      * taken to not create reentrancy vulnerabilities. Consider using
283      * {ReentrancyGuard} or the
284      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
285      */
286     function sendValue(address payable recipient, uint256 amount) internal {
287         require(address(this).balance >= amount, "Address: insufficient balance");
288 
289         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
290         (bool success, ) = recipient.call{ value: amount }("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain`call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313       return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
348         require(address(this).balance >= value, "Address: insufficient balance for call");
349         require(isContract(target), "Address: call to non-contract");
350 
351         // solhint-disable-next-line avoid-low-level-calls
352         (bool success, bytes memory returndata) = target.call{ value: value }(data);
353         return _verifyCallResult(success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a static call.
359      *
360      * _Available since v3.3._
361      */
362     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
363         return functionStaticCall(target, data, "Address: low-level static call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a static call.
369      *
370      * _Available since v3.3._
371      */
372     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
373         require(isContract(target), "Address: static call to non-contract");
374 
375         // solhint-disable-next-line avoid-low-level-calls
376         (bool success, bytes memory returndata) = target.staticcall(data);
377         return _verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.3._
385      */
386     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.3._
395      */
396     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
397         require(isContract(target), "Address: delegate call to non-contract");
398 
399         // solhint-disable-next-line avoid-low-level-calls
400         (bool success, bytes memory returndata) = target.delegatecall(data);
401         return _verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
405         if (success) {
406             return returndata;
407         } else {
408             // Look for revert reason and bubble it up if present
409             if (returndata.length > 0) {
410                 // The easiest way to bubble the revert reason is using memory via assembly
411 
412                 // solhint-disable-next-line no-inline-assembly
413                 assembly {
414                     let returndata_size := mload(returndata)
415                     revert(add(32, returndata), returndata_size)
416                 }
417             } else {
418                 revert(errorMessage);
419             }
420         }
421     }
422 }
423 
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
492 /**
493  * @dev Library for managing
494  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
495  * types.
496  *
497  * Sets have the following properties:
498  *
499  * - Elements are added, removed, and checked for existence in constant time
500  * (O(1)).
501  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
502  *
503  * ```
504  * contract Example {
505  *     // Add the library methods
506  *     using EnumerableSet for EnumerableSet.AddressSet;
507  *
508  *     // Declare a set state variable
509  *     EnumerableSet.AddressSet private mySet;
510  * }
511  * ```
512  *
513  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
514  * (`UintSet`) are supported.
515  */
516 library EnumerableSet {
517     // To implement this library for multiple types with as little code
518     // repetition as possible, we write it in terms of a generic Set type with
519     // bytes32 values.
520     // The Set implementation uses private functions, and user-facing
521     // implementations (such as AddressSet) are just wrappers around the
522     // underlying Set.
523     // This means that we can only create new EnumerableSets for types that fit
524     // in bytes32.
525 
526     struct Set {
527         // Storage of set values
528         bytes32[] _values;
529 
530         // Position of the value in the `values` array, plus 1 because index 0
531         // means a value is not in the set.
532         mapping (bytes32 => uint256) _indexes;
533     }
534 
535     /**
536      * @dev Add a value to a set. O(1).
537      *
538      * Returns true if the value was added to the set, that is if it was not
539      * already present.
540      */
541     function _add(Set storage set, bytes32 value) private returns (bool) {
542         if (!_contains(set, value)) {
543             set._values.push(value);
544             // The value is stored at length-1, but we add 1 to all indexes
545             // and use 0 as a sentinel value
546             set._indexes[value] = set._values.length;
547             return true;
548         } else {
549             return false;
550         }
551     }
552 
553     /**
554      * @dev Removes a value from a set. O(1).
555      *
556      * Returns true if the value was removed from the set, that is if it was
557      * present.
558      */
559     function _remove(Set storage set, bytes32 value) private returns (bool) {
560         // We read and store the value's index to prevent multiple reads from the same storage slot
561         uint256 valueIndex = set._indexes[value];
562 
563         if (valueIndex != 0) { // Equivalent to contains(set, value)
564             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
565             // the array, and then remove the last element (sometimes called as 'swap and pop').
566             // This modifies the order of the array, as noted in {at}.
567 
568             uint256 toDeleteIndex = valueIndex - 1;
569             uint256 lastIndex = set._values.length - 1;
570 
571             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
572             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
573 
574             bytes32 lastvalue = set._values[lastIndex];
575 
576             // Move the last value to the index where the value to delete is
577             set._values[toDeleteIndex] = lastvalue;
578             // Update the index for the moved value
579             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
580 
581             // Delete the slot where the moved value was stored
582             set._values.pop();
583 
584             // Delete the index for the deleted slot
585             delete set._indexes[value];
586 
587             return true;
588         } else {
589             return false;
590         }
591     }
592 
593     /**
594      * @dev Returns true if the value is in the set. O(1).
595      */
596     function _contains(Set storage set, bytes32 value) private view returns (bool) {
597         return set._indexes[value] != 0;
598     }
599 
600     /**
601      * @dev Returns the number of values on the set. O(1).
602      */
603     function _length(Set storage set) private view returns (uint256) {
604         return set._values.length;
605     }
606 
607    /**
608     * @dev Returns the value stored at position `index` in the set. O(1).
609     *
610     * Note that there are no guarantees on the ordering of values inside the
611     * array, and it may change when more values are added or removed.
612     *
613     * Requirements:
614     *
615     * - `index` must be strictly less than {length}.
616     */
617     function _at(Set storage set, uint256 index) private view returns (bytes32) {
618         require(set._values.length > index, "EnumerableSet: index out of bounds");
619         return set._values[index];
620     }
621 
622     // AddressSet
623 
624     struct AddressSet {
625         Set _inner;
626     }
627 
628     /**
629      * @dev Add a value to a set. O(1).
630      *
631      * Returns true if the value was added to the set, that is if it was not
632      * already present.
633      */
634     function add(AddressSet storage set, address value) internal returns (bool) {
635         return _add(set._inner, bytes32(uint256(value)));
636     }
637 
638     /**
639      * @dev Removes a value from a set. O(1).
640      *
641      * Returns true if the value was removed from the set, that is if it was
642      * present.
643      */
644     function remove(AddressSet storage set, address value) internal returns (bool) {
645         return _remove(set._inner, bytes32(uint256(value)));
646     }
647 
648     /**
649      * @dev Returns true if the value is in the set. O(1).
650      */
651     function contains(AddressSet storage set, address value) internal view returns (bool) {
652         return _contains(set._inner, bytes32(uint256(value)));
653     }
654 
655     /**
656      * @dev Returns the number of values in the set. O(1).
657      */
658     function length(AddressSet storage set) internal view returns (uint256) {
659         return _length(set._inner);
660     }
661 
662    /**
663     * @dev Returns the value stored at position `index` in the set. O(1).
664     *
665     * Note that there are no guarantees on the ordering of values inside the
666     * array, and it may change when more values are added or removed.
667     *
668     * Requirements:
669     *
670     * - `index` must be strictly less than {length}.
671     */
672     function at(AddressSet storage set, uint256 index) internal view returns (address) {
673         return address(uint256(_at(set._inner, index)));
674     }
675 
676 
677     // UintSet
678 
679     struct UintSet {
680         Set _inner;
681     }
682 
683     /**
684      * @dev Add a value to a set. O(1).
685      *
686      * Returns true if the value was added to the set, that is if it was not
687      * already present.
688      */
689     function add(UintSet storage set, uint256 value) internal returns (bool) {
690         return _add(set._inner, bytes32(value));
691     }
692 
693     /**
694      * @dev Removes a value from a set. O(1).
695      *
696      * Returns true if the value was removed from the set, that is if it was
697      * present.
698      */
699     function remove(UintSet storage set, uint256 value) internal returns (bool) {
700         return _remove(set._inner, bytes32(value));
701     }
702 
703     /**
704      * @dev Returns true if the value is in the set. O(1).
705      */
706     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
707         return _contains(set._inner, bytes32(value));
708     }
709 
710     /**
711      * @dev Returns the number of values on the set. O(1).
712      */
713     function length(UintSet storage set) internal view returns (uint256) {
714         return _length(set._inner);
715     }
716 
717    /**
718     * @dev Returns the value stored at position `index` in the set. O(1).
719     *
720     * Note that there are no guarantees on the ordering of values inside the
721     * array, and it may change when more values are added or removed.
722     *
723     * Requirements:
724     *
725     * - `index` must be strictly less than {length}.
726     */
727     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
728         return uint256(_at(set._inner, index));
729     }
730 }
731 
732 /*
733  * @dev Provides information about the current execution context, including the
734  * sender of the transaction and its data. While these are generally available
735  * via msg.sender and msg.data, they should not be accessed in such a direct
736  * manner, since when dealing with GSN meta-transactions the account sending and
737  * paying for execution may not be the actual sender (as far as an application
738  * is concerned).
739  *
740  * This contract is only required for intermediate, library-like contracts.
741  */
742 abstract contract Context {
743     function _msgSender() internal view virtual returns (address payable) {
744         return msg.sender;
745     }
746 
747     function _msgData() internal view virtual returns (bytes memory) {
748         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
749         return msg.data;
750     }
751 }
752 
753 /**
754  * @dev Contract module which provides a basic access control mechanism, where
755  * there is an account (an owner) that can be granted exclusive access to
756  * specific functions.
757  *
758  * By default, the owner account will be the one that deploys the contract. This
759  * can later be changed with {transferOwnership}.
760  *
761  * This module is used through inheritance. It will make available the modifier
762  * `onlyOwner`, which can be applied to your functions to restrict their use to
763  * the owner.
764  */
765 contract Ownable is Context {
766     address private _owner;
767 
768     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
769 
770     /**
771      * @dev Initializes the contract setting the deployer as the initial owner.
772      */
773     constructor () internal {
774         address msgSender = _msgSender();
775         _owner = msgSender;
776         emit OwnershipTransferred(address(0), msgSender);
777     }
778 
779     /**
780      * @dev Returns the address of the current owner.
781      */
782     function owner() public view returns (address) {
783         return _owner;
784     }
785 
786     /**
787      * @dev Throws if called by any account other than the owner.
788      */
789     modifier onlyOwner() {
790         require(_owner == _msgSender(), "Ownable: caller is not the owner");
791         _;
792     }
793 
794     /**
795      * @dev Leaves the contract without owner. It will not be possible to call
796      * `onlyOwner` functions anymore. Can only be called by the current owner.
797      *
798      * NOTE: Renouncing ownership will leave the contract without an owner,
799      * thereby removing any functionality that is only available to the owner.
800      */
801     function renounceOwnership() public virtual onlyOwner {
802         emit OwnershipTransferred(_owner, address(0));
803         _owner = address(0);
804     }
805 
806     /**
807      * @dev Transfers ownership of the contract to a new account (`newOwner`).
808      * Can only be called by the current owner.
809      */
810     function transferOwnership(address newOwner) public virtual onlyOwner {
811         require(newOwner != address(0), "Ownable: new owner is the zero address");
812         emit OwnershipTransferred(_owner, newOwner);
813         _owner = newOwner;
814     }
815 }
816 
817 interface IUniswapV2Pair {
818     event Approval(address indexed owner, address indexed spender, uint value);
819     event Transfer(address indexed from, address indexed to, uint value);
820 
821     function name() external pure returns (string memory);
822     function symbol() external pure returns (string memory);
823     function decimals() external pure returns (uint8);
824     function totalSupply() external view returns (uint);
825     function balanceOf(address owner) external view returns (uint);
826     function allowance(address owner, address spender) external view returns (uint);
827 
828     function approve(address spender, uint value) external returns (bool);
829     function transfer(address to, uint value) external returns (bool);
830     function transferFrom(address from, address to, uint value) external returns (bool);
831 
832     function DOMAIN_SEPARATOR() external view returns (bytes32);
833     function PERMIT_TYPEHASH() external pure returns (bytes32);
834     function nonces(address owner) external view returns (uint);
835 
836     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
837 
838     event Mint(address indexed sender, uint amount0, uint amount1);
839     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
840     event Swap(
841         address indexed sender,
842         uint amount0In,
843         uint amount1In,
844         uint amount0Out,
845         uint amount1Out,
846         address indexed to
847     );
848     event Sync(uint112 reserve0, uint112 reserve1);
849 
850     function MINIMUM_LIQUIDITY() external pure returns (uint);
851     function factory() external view returns (address);
852     function token0() external view returns (address);
853     function token1() external view returns (address);
854     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
855     function price0CumulativeLast() external view returns (uint);
856     function price1CumulativeLast() external view returns (uint);
857     function kLast() external view returns (uint);
858 
859     function mint(address to) external returns (uint liquidity);
860     function burn(address to) external returns (uint amount0, uint amount1);
861     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
862     function skim(address to) external;
863     function sync() external;
864 
865     function initialize(address, address) external;
866 }
867 
868 interface AggregatorV3Interface {
869 
870   function decimals() external view returns (uint8);
871   function description() external view returns (string memory);
872   function version() external view returns (uint256);
873 
874   // getRoundData and latestRoundData should both raise "No data present"
875   // if they do not have data to report, instead of returning unset values
876   // which could be misinterpreted as actual reported values.
877   function getRoundData(uint80 _roundId)
878     external
879     view
880     returns (
881       uint80 roundId,
882       int256 answer,
883       uint256 startedAt,
884       uint256 updatedAt,
885       uint80 answeredInRound
886     );
887   function latestRoundData()
888     external
889     view
890     returns (
891       uint80 roundId,
892       int256 answer,
893       uint256 startedAt,
894       uint256 updatedAt,
895       uint80 answeredInRound
896     );
897 
898 }
899 
900 interface IMigratorChef {
901     // Perform LP token migration from legacy UniswapV2 to Testa.
902     // Take the current LP token address and return the new LP token address.
903     // Migrator should have full access to the caller's LP token.
904     // Return the new LP token address.
905     //
906     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
907     // Testa must mint EXACTLY the same amount of Testa LP tokens or
908     // else something bad will happen. Traditional UniswapV2 does not
909     // do that so be careful!
910     function migrate(IERC20 token) external returns (IERC20);
911 }
912 
913 
914 /**
915  * @dev Contract module that helps prevent reentrant calls to a function.
916  *
917  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
918  * available, which can be aplied to functions to make sure there are no nested
919  * (reentrant) calls to them.
920  *
921  * Note that because there is a single `nonReentrant` guard, functions marked as
922  * `nonReentrant` may not call one another. This can be worked around by making
923  * those functions `private`, and then adding `external` `nonReentrant` entry
924  * points to them.
925  */
926 contract ReentrancyGuard {
927     /// @dev counter to allow mutex lock with only one SSTORE operation
928     uint256 private _guardCounter;
929 
930     constructor () internal {
931         // The counter starts at one to prevent changing it from zero to a non-zero
932         // value, which is a more expensive operation.
933         _guardCounter = 1;
934     }
935 
936     /**
937      * @dev Prevents a contract from calling itself, directly or indirectly.
938      * Calling a `nonReentrant` function from another `nonReentrant`
939      * function is not supported. It is possible to prevent this from happening
940      * by making the `nonReentrant` function external, and make it call a
941      * `private` function that does the actual work.
942      */
943     modifier nonReentrant() {
944         _guardCounter += 1;
945         uint256 localCounter = _guardCounter;
946         _;
947         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
948     }
949 }
950 
951 // Note that it's ownable and the owner wields tremendous power. The ownership
952 // will be transferred to a governance smart contract once Testa is sufficiently
953 // distributed and the community can show to govern itself.
954 //
955 // Have fun reading it. Hopefully it's bug-free. God bless.
956 contract TestaFarmV1Plus is Ownable, ReentrancyGuard {
957     using SafeMath for uint256;
958     using SafeERC20 for IERC20;
959 
960     // Info of each user.
961     struct UserInfo {
962         uint256 amount;     // How many LP tokens the user has provided.
963         mapping (uint256 => uint256) pendingTesta;
964         mapping (uint256 => uint256) rewardDebt; // Reward debt. See explanation below.
965     }
966 
967     // Info of each pool.
968     struct PoolInfo {
969         IERC20 lpToken;           // Address of LP token contract.
970         IUniswapV2Pair uniswap;
971         uint112 startLiquidity;
972         uint256 allocPoint;       // How many allocation points assigned to this pool. Testa to distribute per block.
973         uint256 lastRewardBlock;  // Last block number that Testa distribution occurs.
974         uint256 accTestaPerShare; // Accumulated Testa per share, times 1e18. See below.
975         uint256 debtIndexKey;
976         uint256 startBlock;
977         uint256 initStartBlock;
978     }
979 
980     // The Testa TOKEN!
981     address public testa;
982     // Testa tokens created per block.
983     uint256 public testaPerBlock;
984     // Bonus muliplier for early testa makers.
985     uint256 public constant BONUS_MULTIPLIER = 10;
986     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
987     IMigratorChef public migrator;
988 
989     // Info of each pool.
990     PoolInfo[] public poolInfo;
991     // Info of each user that stakes LP tokens.
992     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
993     // Total allocation poitns. Must be the sum of all allocation points in all pools.
994     uint256 public totalAllocPoint = 0;
995     uint256 public activeReward = 10;
996     uint256 public fiveHundred = 40;
997     uint256 public thousand = 50;
998     int public progressive = 0;
999     int public maxProgressive;
1000     int public minProgressive;
1001     uint256 public numberOfBlock;
1002     uint112 public startLiquidity;
1003     uint112 public currentLiquidity;
1004     AggregatorV3Interface public priceFeed;
1005     
1006     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1007     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1008     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1009 
1010     constructor(
1011         address _testa,
1012         uint256 _testaPerBlock,
1013         int _maxProgressive,
1014         int _minProgressive,
1015         uint256 activateAtBlock,
1016         address _priceFeed
1017     ) public {
1018         testa = _testa;
1019         testaPerBlock = _testaPerBlock;
1020         maxProgressive = _maxProgressive;
1021         minProgressive = _minProgressive;
1022         numberOfBlock = activateAtBlock;
1023         priceFeed = AggregatorV3Interface(_priceFeed);
1024     }
1025 
1026     /// @dev Require that the caller must be an EOA account to avoid flash loans.
1027     modifier onlyEOA() {
1028         require(msg.sender == tx.origin, "Not EOA");
1029         _;
1030     }
1031 
1032     function setTestaPerBlock(uint256 _testaPerBlock) public onlyOwner{
1033         testaPerBlock = _testaPerBlock;
1034     }
1035 
1036     function setProgressive(int _maxProgressive, int _minProgressive) public onlyOwner{
1037         maxProgressive = _maxProgressive;
1038         minProgressive = _minProgressive;
1039     }
1040 
1041     function setNumberOfBlock(uint256 _numberOfBlock) public onlyOwner{
1042         numberOfBlock = _numberOfBlock;
1043     }
1044 
1045     function setActiveReward(uint256 _activeReward) public onlyOwner{
1046         activeReward = _activeReward;
1047     }
1048 
1049     function harvestAndWithdraw(uint256 _pid, uint256 _amount) public nonReentrant {
1050         PoolInfo storage pool = poolInfo[_pid];
1051         UserInfo storage user = userInfo[_pid][msg.sender];
1052         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1053 
1054         require(getCountDown(_pid) <= numberOfBlock);
1055         require((progressive == maxProgressive) && (lpSupply != 0), "Must have lpSupply and reach maxProgressive to harvest");
1056         require(user.amount >= _amount, "No lpToken cannot withdraw");
1057         updatePool(_pid);
1058         
1059         uint256 testaAmount = pendingTesta( _pid, msg.sender);
1060         
1061         if(_amount > 0) {
1062             user.amount = user.amount.sub(_amount);
1063             user.rewardDebt[pool.debtIndexKey] = user.amount.mul(pool.accTestaPerShare).div(1e18);
1064             user.pendingTesta[pool.debtIndexKey] = 0;
1065             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1066             safeTestaTransfer(msg.sender, testaAmount);
1067         }
1068         emit Withdraw(msg.sender, _pid, _amount);
1069     }
1070 
1071     function harvest(uint256 _pid) public nonReentrant {
1072         PoolInfo storage pool = poolInfo[_pid];
1073         UserInfo storage user = userInfo[_pid][msg.sender];
1074         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1075 
1076         require(getCountDown(_pid) <= numberOfBlock);
1077         require((progressive == maxProgressive) && (lpSupply != 0), "Must have lpSupply and reach maxProgressive to harvest");
1078         require(user.amount > 0, "No lpToken cannot withdraw");
1079         updatePool(_pid);
1080         
1081         uint256 testaAmount = pendingTesta( _pid, msg.sender);
1082         user.rewardDebt[pool.debtIndexKey] = user.amount.mul(pool.accTestaPerShare).div(1e18);
1083         user.pendingTesta[pool.debtIndexKey] = 0;
1084         safeTestaTransfer(msg.sender, testaAmount);
1085     }
1086     
1087     function firstActivate(uint256 _pid) public onlyEOA nonReentrant {
1088         currentLiquidity = getLiquidity(_pid);
1089         PoolInfo storage pool = poolInfo[_pid];
1090         require(pool.initStartBlock == pool.startBlock);
1091         require(block.number >= pool.initStartBlock, "Cannot activate until the specific block time arrive");
1092         pool.startBlock = getLatestBlock();
1093         pool.startLiquidity = currentLiquidity;
1094         // send Testa to user who press activate button
1095         safeTestaTransfer(msg.sender, getTestaReward(_pid));
1096     }
1097 
1098     function activate(uint256 _pid) public onlyEOA nonReentrant {
1099         currentLiquidity = getLiquidity(_pid);
1100         PoolInfo storage pool = poolInfo[_pid];
1101         
1102         require(pool.initStartBlock != pool.startBlock);
1103         require(getCountDown(_pid) >= numberOfBlock, "Cannot activate until specific amount of blocks pass");
1104         
1105         if(currentLiquidity > pool.startLiquidity){
1106             progressive++;
1107         }else{
1108             progressive--;
1109         }
1110             
1111         if(progressive <= minProgressive){
1112             progressive = minProgressive;
1113             clearPool(_pid);
1114         }else if(progressive >= maxProgressive){
1115             progressive = maxProgressive;
1116         }
1117         pool.startBlock = getLatestBlock();  
1118         pool.startLiquidity = currentLiquidity;
1119         // send Testa to user who press activate button
1120         safeTestaTransfer(msg.sender, getTestaReward(_pid));
1121     }
1122 
1123     function getTestaPoolBalance() public view returns (uint256){
1124         return IERC20(testa).balanceOf(address(this));
1125     }
1126     
1127     function getProgressive() public view returns (int){
1128         return progressive;
1129     }
1130     
1131     function getLatestBlock() public view returns (uint256) {
1132         return block.number;
1133     }
1134     
1135     function getCountDown(uint256 _pid) public view returns (uint256){
1136         require(getLatestBlock() > getStartedBlock(_pid));
1137         return getLatestBlock().sub(getStartedBlock(_pid));
1138     }
1139 
1140     function getStartedBlock(uint256 _pid) public view returns (uint256){
1141         PoolInfo storage pool = poolInfo[_pid];
1142         return pool.startBlock;
1143     }
1144     
1145     function getLiquidity(uint256 _pid) public view returns (uint112){
1146         PoolInfo storage pool = poolInfo[_pid];
1147         ( , uint112 _reserve1, ) = pool.uniswap.getReserves();
1148         return _reserve1;
1149     }
1150 
1151     function getLatestPrice() public view returns (int) {
1152         (
1153             uint80 roundID, 
1154             int price,
1155             uint startedAt,
1156             uint timeStamp,
1157             uint80 answeredInRound
1158         ) = priceFeed.latestRoundData();
1159         // If the round is not complete yet, timestamp is 0
1160         require(timeStamp > 0, "Round not complete");
1161         return price;
1162     }
1163 
1164     function getTestaReward(uint256 _pid) public view returns (uint256){
1165          PoolInfo storage pool = poolInfo[_pid];
1166         (uint112 _reserve0, uint112 _reserve1, ) = pool.uniswap.getReserves();
1167         uint256 reserve = uint256(_reserve0).mul(1e18).div(uint256(_reserve1));
1168         uint256 ethPerDollar = uint256(getLatestPrice()).mul(1e10); // 1e8
1169         uint256 testaPerDollar = ethPerDollar.mul(1e18).div(reserve);
1170         uint256 _activeReward = activeReward.mul(1e18);
1171         uint256 testaAmount = _activeReward.mul(1e18).div(testaPerDollar);
1172         return testaAmount;
1173     }
1174     
1175     function poolLength() external view returns (uint256) {
1176         return poolInfo.length;
1177     }
1178 
1179     // Add a new lp to the pool. Can only be called by the owner.
1180     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1181     function add(uint256 startBlock, uint256 _allocPoint, address _lpToken, bool _withUpdate) public onlyOwner {
1182         if (_withUpdate) {
1183             massUpdatePools();
1184         }
1185         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1186         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1187         IUniswapV2Pair uniswap = IUniswapV2Pair(_lpToken);
1188         ( , uint112 _reserve1, ) = uniswap.getReserves(); 
1189         
1190         poolInfo.push(PoolInfo({
1191             lpToken: IERC20(_lpToken),
1192             allocPoint: _allocPoint,
1193             lastRewardBlock: lastRewardBlock,
1194             accTestaPerShare: 0,
1195             debtIndexKey: 0,
1196             uniswap: uniswap,
1197             startLiquidity: _reserve1,
1198             startBlock: startBlock,
1199             initStartBlock: startBlock
1200         }));
1201 
1202         
1203     }
1204 
1205     // Update the given pool's Testa allocation point. Can only be called by the owner.
1206     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1207         if (_withUpdate) {
1208             massUpdatePools();
1209         }
1210         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1211         poolInfo[_pid].allocPoint = _allocPoint;
1212     }
1213 
1214     // Set the migrator contract. Can only be called by the owner.
1215     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1216         migrator = _migrator;
1217     }
1218 
1219     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1220     function migrate(uint256 _pid) public {
1221         require(address(migrator) != address(0), "migrate: no migrator");
1222         PoolInfo storage pool = poolInfo[_pid];
1223         IERC20 lpToken = pool.lpToken;
1224         uint256 bal = lpToken.balanceOf(address(this));
1225         lpToken.safeApprove(address(migrator), bal);
1226         IERC20 newLpToken = migrator.migrate(lpToken);
1227         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1228         pool.lpToken = newLpToken;
1229     }
1230 
1231     // Return reward multiplier over the given _from to _to block.
1232     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1233         return _to.sub(_from);
1234     }
1235     
1236     function clearPool(uint256 _pid) internal {
1237         PoolInfo storage pool = poolInfo[_pid];
1238         pool.accTestaPerShare = 0;
1239         pool.lastRewardBlock = block.number;
1240         pool.debtIndexKey++;
1241     }
1242 
1243     // View function to see pending Testa on frontend.
1244     function pendingTesta(uint256 _pid, address _user) public view returns (uint256) {
1245         PoolInfo storage pool = poolInfo[_pid];
1246         UserInfo storage user = userInfo[_pid][_user];
1247         uint256 accTestaPerShare = pool.accTestaPerShare;
1248         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1249         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1250             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1251             uint256 testaReward = multiplier.mul(testaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1252             accTestaPerShare = accTestaPerShare.add(testaReward.mul(1e18).div(lpSupply));
1253         }
1254         uint256 rewardDebt = user.rewardDebt[pool.debtIndexKey];
1255         return user.amount.mul(accTestaPerShare).div(1e18).sub(rewardDebt).add(user.pendingTesta[pool.debtIndexKey]);
1256     }
1257 
1258     // Update reward variables for all pools. Be careful of gas spending!
1259     function massUpdatePools() public {
1260         uint256 length = poolInfo.length;
1261         for (uint256 pid = 0; pid < length; ++pid) {
1262             updatePool(pid);
1263         }
1264     }
1265 
1266     // Update reward variables of the given pool to be up-to-date.
1267     function updatePool(uint256 _pid) public {
1268         PoolInfo storage pool = poolInfo[_pid];
1269         if (block.number <= pool.lastRewardBlock) {
1270             return;
1271         }
1272         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1273         if (lpSupply == 0) {
1274             pool.lastRewardBlock = block.number;
1275             return;
1276         }
1277         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1278         uint256 testaReward = multiplier.mul(testaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1279         pool.accTestaPerShare = pool.accTestaPerShare.add(testaReward.mul(1e18).div(lpSupply));
1280         pool.lastRewardBlock = block.number;
1281     }
1282 
1283     // Deposit LP tokens to TestaFarm for Testa allocation.
1284     function deposit(uint256 _pid, uint256 _amount) public {
1285         PoolInfo storage pool = poolInfo[_pid];
1286         UserInfo storage user = userInfo[_pid][msg.sender];
1287         updatePool(_pid);
1288 
1289         if (user.amount > 0) {
1290           user.pendingTesta[pool.debtIndexKey] = pendingTesta(_pid, msg.sender);
1291         }
1292         
1293         if(_amount > 0) {
1294             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1295             user.amount = user.amount.add(_amount);
1296         }
1297         
1298         user.rewardDebt[pool.debtIndexKey] = user.amount.mul(pool.accTestaPerShare).div(1e18);
1299         emit Deposit(msg.sender, _pid, _amount);
1300     }
1301 
1302     // Withdraw LP tokens from TestaFarm.
1303     function withdraw(uint256 _pid, uint256 _amount) public {
1304         PoolInfo storage pool = poolInfo[_pid];
1305         UserInfo storage user = userInfo[_pid][msg.sender];
1306         require(user.amount >= _amount, "No lpToken cannot withdraw");
1307         updatePool(_pid);
1308         
1309         if(_amount > 0) {
1310             user.amount = user.amount.sub(_amount);
1311             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1312         }
1313         user.rewardDebt[pool.debtIndexKey] = user.amount.mul(pool.accTestaPerShare).div(1e18);
1314         user.pendingTesta[pool.debtIndexKey] = 0;
1315         emit Withdraw(msg.sender, _pid, _amount);
1316     }
1317 
1318     // Withdraw without caring about rewards. EMERGENCY ONLY.
1319     function emergencyWithdraw(uint256 _pid) public {
1320         PoolInfo storage pool = poolInfo[_pid];
1321         UserInfo storage user = userInfo[_pid][msg.sender];
1322         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1323         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1324         user.amount = 0;
1325         user.rewardDebt[pool.debtIndexKey] = 0;
1326     }
1327 
1328     // Safe testa transfer function, just in case if rounding error causes pool to not have enough Testa.
1329     function safeTestaTransfer(address _to, uint256 _amount) internal {
1330         uint256 testaBal = IERC20(testa).balanceOf(address(this));
1331         if (_amount > testaBal) {
1332             testa.call(abi.encodeWithSignature("transfer(address,uint256)", _to, testaBal));
1333         } else {
1334             testa.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _amount));
1335         }
1336     }
1337 }