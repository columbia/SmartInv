1 pragma solidity 0.6.12;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      *
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
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
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.
259 
260         uint256 size;
261         // solhint-disable-next-line no-inline-assembly
262         assembly { size := extcodesize(account) }
263         return size > 0;
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(address(this).balance >= amount, "Address: insufficient balance");
284 
285         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
286         (bool success, ) = recipient.call{ value: amount }("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain`call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309       return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
339      * with `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
344         require(address(this).balance >= value, "Address: insufficient balance for call");
345         require(isContract(target), "Address: call to non-contract");
346 
347         // solhint-disable-next-line avoid-low-level-calls
348         (bool success, bytes memory returndata) = target.call{ value: value }(data);
349         return _verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a static call.
355      *
356      * _Available since v3.3._
357      */
358     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
359         return functionStaticCall(target, data, "Address: low-level static call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
369         require(isContract(target), "Address: static call to non-contract");
370 
371         // solhint-disable-next-line avoid-low-level-calls
372         (bool success, bytes memory returndata) = target.staticcall(data);
373         return _verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.3._
381      */
382     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
383         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.3._
391      */
392     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
393         require(isContract(target), "Address: delegate call to non-contract");
394 
395         // solhint-disable-next-line avoid-low-level-calls
396         (bool success, bytes memory returndata) = target.delegatecall(data);
397         return _verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407 
408                 // solhint-disable-next-line no-inline-assembly
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 /**
421  * @title SafeERC20
422  * @dev Wrappers around ERC20 operations that throw on failure (when the token
423  * contract returns false). Tokens that return no value (and instead revert or
424  * throw on failure) are also supported, non-reverting calls are assumed to be
425  * successful.
426  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
427  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
428  */
429 library SafeERC20 {
430     using SafeMath for uint256;
431     using Address for address;
432 
433     function safeTransfer(IERC20 token, address to, uint256 value) internal {
434         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
435     }
436 
437     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
438         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
439     }
440 
441     /**
442      * @dev Deprecated. This function has issues similar to the ones found in
443      * {IERC20-approve}, and its usage is discouraged.
444      *
445      * Whenever possible, use {safeIncreaseAllowance} and
446      * {safeDecreaseAllowance} instead.
447      */
448     function safeApprove(IERC20 token, address spender, uint256 value) internal {
449         // safeApprove should only be called when setting an initial allowance,
450         // or when resetting it to zero. To increase and decrease it, use
451         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
452         // solhint-disable-next-line max-line-length
453         require((value == 0) || (token.allowance(address(this), spender) == 0),
454             "SafeERC20: approve from non-zero to non-zero allowance"
455         );
456         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
457     }
458 
459     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
460         uint256 newAllowance = token.allowance(address(this), spender).add(value);
461         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
462     }
463 
464     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
465         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
466         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
467     }
468 
469     /**
470      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
471      * on the return value: the return value is optional (but if data is returned, it must not be false).
472      * @param token The token targeted by the call.
473      * @param data The call data (encoded using abi.encode or one of its variants).
474      */
475     function _callOptionalReturn(IERC20 token, bytes memory data) private {
476         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
477         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
478         // the target address contains contract code and also asserts for success in the low-level call.
479 
480         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
481         if (returndata.length > 0) { // Return data is optional
482             // solhint-disable-next-line max-line-length
483             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
484         }
485     }
486 }
487 
488 /**
489  * @dev Library for managing
490  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
491  * types.
492  *
493  * Sets have the following properties:
494  *
495  * - Elements are added, removed, and checked for existence in constant time
496  * (O(1)).
497  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
498  *
499  * ```
500  * contract Example {
501  *     // Add the library methods
502  *     using EnumerableSet for EnumerableSet.AddressSet;
503  *
504  *     // Declare a set state variable
505  *     EnumerableSet.AddressSet private mySet;
506  * }
507  * ```
508  *
509  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
510  * (`UintSet`) are supported.
511  */
512 library EnumerableSet {
513     // To implement this library for multiple types with as little code
514     // repetition as possible, we write it in terms of a generic Set type with
515     // bytes32 values.
516     // The Set implementation uses private functions, and user-facing
517     // implementations (such as AddressSet) are just wrappers around the
518     // underlying Set.
519     // This means that we can only create new EnumerableSets for types that fit
520     // in bytes32.
521 
522     struct Set {
523         // Storage of set values
524         bytes32[] _values;
525 
526         // Position of the value in the `values` array, plus 1 because index 0
527         // means a value is not in the set.
528         mapping (bytes32 => uint256) _indexes;
529     }
530 
531     /**
532      * @dev Add a value to a set. O(1).
533      *
534      * Returns true if the value was added to the set, that is if it was not
535      * already present.
536      */
537     function _add(Set storage set, bytes32 value) private returns (bool) {
538         if (!_contains(set, value)) {
539             set._values.push(value);
540             // The value is stored at length-1, but we add 1 to all indexes
541             // and use 0 as a sentinel value
542             set._indexes[value] = set._values.length;
543             return true;
544         } else {
545             return false;
546         }
547     }
548 
549     /**
550      * @dev Removes a value from a set. O(1).
551      *
552      * Returns true if the value was removed from the set, that is if it was
553      * present.
554      */
555     function _remove(Set storage set, bytes32 value) private returns (bool) {
556         // We read and store the value's index to prevent multiple reads from the same storage slot
557         uint256 valueIndex = set._indexes[value];
558 
559         if (valueIndex != 0) { // Equivalent to contains(set, value)
560             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
561             // the array, and then remove the last element (sometimes called as 'swap and pop').
562             // This modifies the order of the array, as noted in {at}.
563 
564             uint256 toDeleteIndex = valueIndex - 1;
565             uint256 lastIndex = set._values.length - 1;
566 
567             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
568             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
569 
570             bytes32 lastvalue = set._values[lastIndex];
571 
572             // Move the last value to the index where the value to delete is
573             set._values[toDeleteIndex] = lastvalue;
574             // Update the index for the moved value
575             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
576 
577             // Delete the slot where the moved value was stored
578             set._values.pop();
579 
580             // Delete the index for the deleted slot
581             delete set._indexes[value];
582 
583             return true;
584         } else {
585             return false;
586         }
587     }
588 
589     /**
590      * @dev Returns true if the value is in the set. O(1).
591      */
592     function _contains(Set storage set, bytes32 value) private view returns (bool) {
593         return set._indexes[value] != 0;
594     }
595 
596     /**
597      * @dev Returns the number of values on the set. O(1).
598      */
599     function _length(Set storage set) private view returns (uint256) {
600         return set._values.length;
601     }
602 
603    /**
604     * @dev Returns the value stored at position `index` in the set. O(1).
605     *
606     * Note that there are no guarantees on the ordering of values inside the
607     * array, and it may change when more values are added or removed.
608     *
609     * Requirements:
610     *
611     * - `index` must be strictly less than {length}.
612     */
613     function _at(Set storage set, uint256 index) private view returns (bytes32) {
614         require(set._values.length > index, "EnumerableSet: index out of bounds");
615         return set._values[index];
616     }
617 
618     // AddressSet
619 
620     struct AddressSet {
621         Set _inner;
622     }
623 
624     /**
625      * @dev Add a value to a set. O(1).
626      *
627      * Returns true if the value was added to the set, that is if it was not
628      * already present.
629      */
630     function add(AddressSet storage set, address value) internal returns (bool) {
631         return _add(set._inner, bytes32(uint256(value)));
632     }
633 
634     /**
635      * @dev Removes a value from a set. O(1).
636      *
637      * Returns true if the value was removed from the set, that is if it was
638      * present.
639      */
640     function remove(AddressSet storage set, address value) internal returns (bool) {
641         return _remove(set._inner, bytes32(uint256(value)));
642     }
643 
644     /**
645      * @dev Returns true if the value is in the set. O(1).
646      */
647     function contains(AddressSet storage set, address value) internal view returns (bool) {
648         return _contains(set._inner, bytes32(uint256(value)));
649     }
650 
651     /**
652      * @dev Returns the number of values in the set. O(1).
653      */
654     function length(AddressSet storage set) internal view returns (uint256) {
655         return _length(set._inner);
656     }
657 
658    /**
659     * @dev Returns the value stored at position `index` in the set. O(1).
660     *
661     * Note that there are no guarantees on the ordering of values inside the
662     * array, and it may change when more values are added or removed.
663     *
664     * Requirements:
665     *
666     * - `index` must be strictly less than {length}.
667     */
668     function at(AddressSet storage set, uint256 index) internal view returns (address) {
669         return address(uint256(_at(set._inner, index)));
670     }
671 
672 
673     // UintSet
674 
675     struct UintSet {
676         Set _inner;
677     }
678 
679     /**
680      * @dev Add a value to a set. O(1).
681      *
682      * Returns true if the value was added to the set, that is if it was not
683      * already present.
684      */
685     function add(UintSet storage set, uint256 value) internal returns (bool) {
686         return _add(set._inner, bytes32(value));
687     }
688 
689     /**
690      * @dev Removes a value from a set. O(1).
691      *
692      * Returns true if the value was removed from the set, that is if it was
693      * present.
694      */
695     function remove(UintSet storage set, uint256 value) internal returns (bool) {
696         return _remove(set._inner, bytes32(value));
697     }
698 
699     /**
700      * @dev Returns true if the value is in the set. O(1).
701      */
702     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
703         return _contains(set._inner, bytes32(value));
704     }
705 
706     /**
707      * @dev Returns the number of values on the set. O(1).
708      */
709     function length(UintSet storage set) internal view returns (uint256) {
710         return _length(set._inner);
711     }
712 
713    /**
714     * @dev Returns the value stored at position `index` in the set. O(1).
715     *
716     * Note that there are no guarantees on the ordering of values inside the
717     * array, and it may change when more values are added or removed.
718     *
719     * Requirements:
720     *
721     * - `index` must be strictly less than {length}.
722     */
723     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
724         return uint256(_at(set._inner, index));
725     }
726 }
727 
728 /*
729  * @dev Provides information about the current execution context, including the
730  * sender of the transaction and its data. While these are generally available
731  * via msg.sender and msg.data, they should not be accessed in such a direct
732  * manner, since when dealing with GSN meta-transactions the account sending and
733  * paying for execution may not be the actual sender (as far as an application
734  * is concerned).
735  *
736  * This contract is only required for intermediate, library-like contracts.
737  */
738 abstract contract Context {
739     function _msgSender() internal view virtual returns (address payable) {
740         return msg.sender;
741     }
742 
743     function _msgData() internal view virtual returns (bytes memory) {
744         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
745         return msg.data;
746     }
747 }
748 
749 /**
750  * @dev Contract module which provides a basic access control mechanism, where
751  * there is an account (an owner) that can be granted exclusive access to
752  * specific functions.
753  *
754  * By default, the owner account will be the one that deploys the contract. This
755  * can later be changed with {transferOwnership}.
756  *
757  * This module is used through inheritance. It will make available the modifier
758  * `onlyOwner`, which can be applied to your functions to restrict their use to
759  * the owner.
760  */
761 contract Ownable is Context {
762     address private _owner;
763 
764     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
765 
766     /**
767      * @dev Initializes the contract setting the deployer as the initial owner.
768      */
769     constructor () internal {
770         address msgSender = _msgSender();
771         _owner = msgSender;
772         emit OwnershipTransferred(address(0), msgSender);
773     }
774 
775     /**
776      * @dev Returns the address of the current owner.
777      */
778     function owner() public view returns (address) {
779         return _owner;
780     }
781 
782     /**
783      * @dev Throws if called by any account other than the owner.
784      */
785     modifier onlyOwner() {
786         require(_owner == _msgSender(), "Ownable: caller is not the owner");
787         _;
788     }
789 
790     /**
791      * @dev Leaves the contract without owner. It will not be possible to call
792      * `onlyOwner` functions anymore. Can only be called by the current owner.
793      *
794      * NOTE: Renouncing ownership will leave the contract without an owner,
795      * thereby removing any functionality that is only available to the owner.
796      */
797     function renounceOwnership() public virtual onlyOwner {
798         emit OwnershipTransferred(_owner, address(0));
799         _owner = address(0);
800     }
801 
802     /**
803      * @dev Transfers ownership of the contract to a new account (`newOwner`).
804      * Can only be called by the current owner.
805      */
806     function transferOwnership(address newOwner) public virtual onlyOwner {
807         require(newOwner != address(0), "Ownable: new owner is the zero address");
808         emit OwnershipTransferred(_owner, newOwner);
809         _owner = newOwner;
810     }
811 }
812 
813 interface IUniswapV2Pair {
814     event Approval(address indexed owner, address indexed spender, uint value);
815     event Transfer(address indexed from, address indexed to, uint value);
816 
817     function name() external pure returns (string memory);
818     function symbol() external pure returns (string memory);
819     function decimals() external pure returns (uint8);
820     function totalSupply() external view returns (uint);
821     function balanceOf(address owner) external view returns (uint);
822     function allowance(address owner, address spender) external view returns (uint);
823 
824     function approve(address spender, uint value) external returns (bool);
825     function transfer(address to, uint value) external returns (bool);
826     function transferFrom(address from, address to, uint value) external returns (bool);
827 
828     function DOMAIN_SEPARATOR() external view returns (bytes32);
829     function PERMIT_TYPEHASH() external pure returns (bytes32);
830     function nonces(address owner) external view returns (uint);
831 
832     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
833 
834     event Mint(address indexed sender, uint amount0, uint amount1);
835     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
836     event Swap(
837         address indexed sender,
838         uint amount0In,
839         uint amount1In,
840         uint amount0Out,
841         uint amount1Out,
842         address indexed to
843     );
844     event Sync(uint112 reserve0, uint112 reserve1);
845 
846     function MINIMUM_LIQUIDITY() external pure returns (uint);
847     function factory() external view returns (address);
848     function token0() external view returns (address);
849     function token1() external view returns (address);
850     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
851     function price0CumulativeLast() external view returns (uint);
852     function price1CumulativeLast() external view returns (uint);
853     function kLast() external view returns (uint);
854 
855     function mint(address to) external returns (uint liquidity);
856     function burn(address to) external returns (uint amount0, uint amount1);
857     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
858     function skim(address to) external;
859     function sync() external;
860 
861     function initialize(address, address) external;
862 }
863 
864 interface AggregatorV3Interface {
865 
866   function decimals() external view returns (uint8);
867   function description() external view returns (string memory);
868   function version() external view returns (uint256);
869 
870   // getRoundData and latestRoundData should both raise "No data present"
871   // if they do not have data to report, instead of returning unset values
872   // which could be misinterpreted as actual reported values.
873   function getRoundData(uint80 _roundId)
874     external
875     view
876     returns (
877       uint80 roundId,
878       int256 answer,
879       uint256 startedAt,
880       uint256 updatedAt,
881       uint80 answeredInRound
882     );
883   function latestRoundData()
884     external
885     view
886     returns (
887       uint80 roundId,
888       int256 answer,
889       uint256 startedAt,
890       uint256 updatedAt,
891       uint80 answeredInRound
892     );
893 
894 }
895 
896 interface IMigratorChef {
897     // Perform LP token migration from legacy UniswapV2 to Testa.
898     // Take the current LP token address and return the new LP token address.
899     // Migrator should have full access to the caller's LP token.
900     // Return the new LP token address.
901     //
902     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
903     // Testa must mint EXACTLY the same amount of Testa LP tokens or
904     // else something bad will happen. Traditional UniswapV2 does not
905     // do that so be careful!
906     function migrate(IERC20 token) external returns (IERC20);
907 }
908 
909 
910 /**
911  * @dev Contract module that helps prevent reentrant calls to a function.
912  *
913  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
914  * available, which can be aplied to functions to make sure there are no nested
915  * (reentrant) calls to them.
916  *
917  * Note that because there is a single `nonReentrant` guard, functions marked as
918  * `nonReentrant` may not call one another. This can be worked around by making
919  * those functions `private`, and then adding `external` `nonReentrant` entry
920  * points to them.
921  */
922 contract ReentrancyGuard {
923     /// @dev counter to allow mutex lock with only one SSTORE operation
924     uint256 private _guardCounter;
925 
926     constructor () internal {
927         // The counter starts at one to prevent changing it from zero to a non-zero
928         // value, which is a more expensive operation.
929         _guardCounter = 1;
930     }
931 
932     /**
933      * @dev Prevents a contract from calling itself, directly or indirectly.
934      * Calling a `nonReentrant` function from another `nonReentrant`
935      * function is not supported. It is possible to prevent this from happening
936      * by making the `nonReentrant` function external, and make it call a
937      * `private` function that does the actual work.
938      */
939     modifier nonReentrant() {
940         _guardCounter += 1;
941         uint256 localCounter = _guardCounter;
942         _;
943         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
944     }
945 }
946 
947 // Note that it's ownable and the owner wields tremendous power. The ownership
948 // will be transferred to a governance smart contract once Testa is sufficiently
949 // distributed and the community can show to govern itself.
950 //
951 // Have fun reading it. Hopefully it's bug-free. God bless.
952 contract TestaFarmV2 is Ownable, ReentrancyGuard {
953     using SafeMath for uint256;
954     using SafeERC20 for IERC20;
955 
956     // Info of each user.
957     struct UserInfo {
958         uint256 amount;     // How many LP tokens the user has provided.
959         mapping (uint256 => uint256) pendingTesta;
960         mapping (uint256 => uint256) rewardDebt; // Reward debt. See explanation below.
961         //
962         // We do some fancy math here. Basically, any point in time, the amount of Testa
963         // entitled to a user but is pending to be distributed is:
964         //
965         //   pending reward = (user.amount * pool.accTestaPerShare) - user.rewardDebt
966         //
967         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
968         //   1. The pool's `accTestaPerShare` (and `lastRewardBlock`) gets updated.
969         //   2. User receives the pending reward sent to his/her address.
970         //   3. User's `amount` gets updated.
971         //   4. User's `rewardDebt` gets updated.
972     }
973 
974     // Info of each pool.
975     struct PoolInfo {
976         IERC20 lpToken;           // Address of LP token contract.
977         IUniswapV2Pair uniswap;
978         uint112 startLiquidity;
979         uint256 allocPoint;       // How many allocation points assigned to this pool. Testa to distribute per block.
980         uint256 lastRewardBlock;  // Last block number that Testa distribution occurs.
981         uint256 accTestaPerShare; // Accumulated Testa per share, times 1e18. See below.
982         uint256 debtIndexKey;
983         uint256 startBlock;
984         uint256 initStartBlock;
985     }
986 
987     // The Testa TOKEN!
988     address public testa;
989     // Testa tokens created per block.
990     uint256 public testaPerBlock;
991     // Bonus muliplier for early testa makers.
992     uint256 public constant BONUS_MULTIPLIER = 10;
993     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
994     IMigratorChef public migrator;
995 
996     // Info of each pool.
997     PoolInfo[] public poolInfo;
998     // Info of each user that stakes LP tokens.
999     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1000     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1001     uint256 public totalAllocPoint = 0;
1002     uint256 public activeReward = 10;
1003     int public progressive = 0;
1004     int public maxProgressive;
1005     int public minProgressive;
1006     uint256 public numberOfBlock;
1007     uint112 public startLiquidity;
1008     uint112 public currentLiquidity;
1009     AggregatorV3Interface public priceFeed;
1010     
1011     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1012     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1013     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1014 
1015     constructor(
1016         address _testa,
1017         uint256 _testaPerBlock,
1018         int _maxProgressive,
1019         int _minProgressive,
1020         uint256 activateAtBlock,
1021         address _priceFeed
1022     ) public {
1023         testa = _testa;
1024         testaPerBlock = _testaPerBlock;
1025         maxProgressive = _maxProgressive;
1026         minProgressive = _minProgressive;
1027         numberOfBlock = activateAtBlock;
1028         priceFeed = AggregatorV3Interface(_priceFeed);
1029     }
1030 
1031     /// @dev Require that the caller must be an EOA account to avoid flash loans.
1032     modifier onlyEOA() {
1033         require(msg.sender == tx.origin, "Not EOA");
1034         _;
1035     }
1036 
1037     function setTestaPerBlock(uint256 _testaPerBlock) public onlyOwner{
1038         testaPerBlock = _testaPerBlock;
1039     }
1040 
1041     function setProgressive(int _maxProgressive, int _minProgressive) public onlyOwner{
1042         maxProgressive = _maxProgressive;
1043         minProgressive = _minProgressive;
1044     }
1045 
1046     function setNumberOfBlock(uint256 _numberOfBlock) public onlyOwner{
1047         numberOfBlock = _numberOfBlock;
1048     }
1049 
1050     function setActiveReward(uint256 _activeReward) public onlyOwner{
1051         activeReward = _activeReward;
1052     }
1053 
1054     function harvestAndWithdraw(uint256 _pid, uint256 _amount) public nonReentrant {
1055         PoolInfo storage pool = poolInfo[_pid];
1056         UserInfo storage user = userInfo[_pid][msg.sender];
1057         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1058 
1059         require(getCountDown(_pid) <= numberOfBlock);
1060         require((progressive == maxProgressive) && (lpSupply != 0), "Must have lpSupply and reach maxProgressive to harvest");
1061         require(user.amount >= _amount, "No lpToken cannot withdraw");
1062         updatePool(_pid);
1063         
1064         uint256 testaAmount = pendingTesta( _pid, msg.sender);
1065         
1066         if(_amount > 0) {
1067             user.amount = user.amount.sub(_amount);
1068             user.rewardDebt[pool.debtIndexKey] = user.amount.mul(pool.accTestaPerShare).div(1e18);
1069             user.pendingTesta[pool.debtIndexKey] = 0;
1070             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1071             safeTestaTransfer(msg.sender, testaAmount);
1072         }
1073         emit Withdraw(msg.sender, _pid, _amount);
1074     }
1075 
1076     function harvest(uint256 _pid) public nonReentrant {
1077         PoolInfo storage pool = poolInfo[_pid];
1078         UserInfo storage user = userInfo[_pid][msg.sender];
1079         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1080 
1081         require(getCountDown(_pid) <= numberOfBlock);
1082         require((progressive == maxProgressive) && (lpSupply != 0), "Must have lpSupply and reach maxProgressive to harvest");
1083         require(user.amount > 0, "No lpToken cannot withdraw");
1084         updatePool(_pid);
1085         
1086         uint256 testaAmount = pendingTesta( _pid, msg.sender);
1087         user.rewardDebt[pool.debtIndexKey] = user.amount.mul(pool.accTestaPerShare).div(1e18);
1088         user.pendingTesta[pool.debtIndexKey] = 0;
1089         safeTestaTransfer(msg.sender, testaAmount);
1090     }
1091     
1092     function firstActivate(uint256 _pid) public onlyEOA nonReentrant {
1093         currentLiquidity = getLiquidity(_pid);
1094         PoolInfo storage pool = poolInfo[_pid];
1095         require(pool.initStartBlock == pool.startBlock);
1096         require(block.number >= pool.initStartBlock, "Cannot activate until the specific block time arrive");
1097         pool.startBlock = getLatestBlock();
1098         pool.startLiquidity = currentLiquidity;
1099         // send Testa to user who press activate button
1100         safeTestaTransfer(msg.sender, getTestaReward(_pid));
1101     }
1102 
1103     function activate(uint256 _pid) public onlyEOA nonReentrant {
1104         currentLiquidity = getLiquidity(_pid);
1105         PoolInfo storage pool = poolInfo[_pid];
1106         require(pool.initStartBlock != pool.startBlock);
1107         require(getCountDown(_pid) >= numberOfBlock, "Cannot activate until specific amount of blocks pass");
1108         if(currentLiquidity > pool.startLiquidity){
1109             progressive++;
1110             pool.startLiquidity = currentLiquidity;
1111         }else{
1112             progressive--;
1113         }
1114             
1115         if(progressive <= minProgressive){
1116             progressive = minProgressive;
1117             clearPool(_pid);
1118         }else if(progressive >= maxProgressive){
1119             progressive = maxProgressive;
1120         }
1121         pool.startBlock = getLatestBlock();    
1122         // send Testa to user who press activate button
1123         safeTestaTransfer(msg.sender, getTestaReward(_pid));
1124     }
1125     
1126     function getTestaPoolBalance() public view returns (uint256){
1127         return IERC20(testa).balanceOf(address(this));
1128     }
1129     
1130     function getProgressive() public view returns (int){
1131         return progressive;
1132     }
1133     
1134     function getLatestBlock() public view returns (uint256) {
1135         return block.number;
1136     }
1137     
1138     function getCountDown(uint256 _pid) public view returns (uint256){
1139         require(getLatestBlock() > getStartedBlock(_pid));
1140         return getLatestBlock().sub(getStartedBlock(_pid));
1141     }
1142 
1143     function getStartedBlock(uint256 _pid) public view returns (uint256){
1144         PoolInfo storage pool = poolInfo[_pid];
1145         return pool.startBlock;
1146     }
1147     
1148     function getLiquidity(uint256 _pid) public view returns (uint112){
1149         PoolInfo storage pool = poolInfo[_pid];
1150         ( , uint112 _reserve1, ) = pool.uniswap.getReserves();
1151         return _reserve1;
1152     }
1153 
1154     function getLatestPrice() public view returns (int) {
1155         (
1156             uint80 roundID, 
1157             int price,
1158             uint startedAt,
1159             uint timeStamp,
1160             uint80 answeredInRound
1161         ) = priceFeed.latestRoundData();
1162         // If the round is not complete yet, timestamp is 0
1163         require(timeStamp > 0, "Round not complete");
1164         return price;
1165     }
1166 
1167     function getTestaReward(uint256 _pid) public view returns (uint256){
1168          PoolInfo storage pool = poolInfo[_pid];
1169         (uint112 _reserve0, uint112 _reserve1, ) = pool.uniswap.getReserves();
1170         uint256 reserve = uint256(_reserve0).mul(1e18).div(uint256(_reserve1));
1171         uint256 ethPerDollar = uint256(getLatestPrice()).mul(1e10); // 1e8
1172         uint256 testaPerDollar = ethPerDollar.mul(1e18).div(reserve);
1173         uint256 _activeReward = activeReward.mul(1e18);
1174         uint256 testaAmount = _activeReward.mul(1e18).div(testaPerDollar);
1175         return testaAmount;
1176     }
1177     
1178     function poolLength() external view returns (uint256) {
1179         return poolInfo.length;
1180     }
1181 
1182     // Add a new lp to the pool. Can only be called by the owner.
1183     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1184     function add(uint256 startBlock, uint256 _allocPoint, address _lpToken, bool _withUpdate) public onlyOwner {
1185         if (_withUpdate) {
1186             massUpdatePools();
1187         }
1188         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1189         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1190         IUniswapV2Pair uniswap = IUniswapV2Pair(_lpToken);
1191         ( , uint112 _reserve1, ) = uniswap.getReserves(); 
1192         
1193         poolInfo.push(PoolInfo({
1194             lpToken: IERC20(_lpToken),
1195             allocPoint: _allocPoint,
1196             lastRewardBlock: lastRewardBlock,
1197             accTestaPerShare: 0,
1198             debtIndexKey: 0,
1199             uniswap: uniswap,
1200             startLiquidity: _reserve1,
1201             startBlock: startBlock,
1202             initStartBlock: startBlock
1203         }));
1204 
1205         
1206     }
1207 
1208     // Update the given pool's Testa allocation point. Can only be called by the owner.
1209     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1210         if (_withUpdate) {
1211             massUpdatePools();
1212         }
1213         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1214         poolInfo[_pid].allocPoint = _allocPoint;
1215     }
1216 
1217     // Set the migrator contract. Can only be called by the owner.
1218     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1219         migrator = _migrator;
1220     }
1221 
1222     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1223     function migrate(uint256 _pid) public {
1224         require(address(migrator) != address(0), "migrate: no migrator");
1225         PoolInfo storage pool = poolInfo[_pid];
1226         IERC20 lpToken = pool.lpToken;
1227         uint256 bal = lpToken.balanceOf(address(this));
1228         lpToken.safeApprove(address(migrator), bal);
1229         IERC20 newLpToken = migrator.migrate(lpToken);
1230         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1231         pool.lpToken = newLpToken;
1232     }
1233 
1234     // Return reward multiplier over the given _from to _to block.
1235     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1236         return _to.sub(_from);
1237     }
1238     
1239     function clearPool(uint256 _pid) internal {
1240         PoolInfo storage pool = poolInfo[_pid];
1241         pool.accTestaPerShare = 0;
1242         pool.lastRewardBlock = block.number;
1243         pool.debtIndexKey++;
1244     }
1245 
1246     // View function to see pending Testa on frontend.
1247     function pendingTesta(uint256 _pid, address _user) public view returns (uint256) {
1248         PoolInfo storage pool = poolInfo[_pid];
1249         UserInfo storage user = userInfo[_pid][_user];
1250         uint256 accTestaPerShare = pool.accTestaPerShare;
1251         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1252         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1253             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1254             uint256 testaReward = multiplier.mul(testaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1255             accTestaPerShare = accTestaPerShare.add(testaReward.mul(1e18).div(lpSupply));
1256         }
1257         uint256 rewardDebt = user.rewardDebt[pool.debtIndexKey];
1258         return user.amount.mul(accTestaPerShare).div(1e18).sub(rewardDebt).add(user.pendingTesta[pool.debtIndexKey]);
1259     }
1260 
1261     // Update reward variables for all pools. Be careful of gas spending!
1262     function massUpdatePools() public {
1263         uint256 length = poolInfo.length;
1264         for (uint256 pid = 0; pid < length; ++pid) {
1265             updatePool(pid);
1266         }
1267     }
1268 
1269     // Update reward variables of the given pool to be up-to-date.
1270     function updatePool(uint256 _pid) public {
1271         PoolInfo storage pool = poolInfo[_pid];
1272         if (block.number <= pool.lastRewardBlock) {
1273             return;
1274         }
1275         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1276         if (lpSupply == 0) {
1277             pool.lastRewardBlock = block.number;
1278             return;
1279         }
1280         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1281         uint256 testaReward = multiplier.mul(testaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1282         pool.accTestaPerShare = pool.accTestaPerShare.add(testaReward.mul(1e18).div(lpSupply));
1283         pool.lastRewardBlock = block.number;
1284     }
1285 
1286     // Deposit LP tokens to TestaFarm for Testa allocation.
1287     function deposit(uint256 _pid, uint256 _amount) public {
1288         PoolInfo storage pool = poolInfo[_pid];
1289         UserInfo storage user = userInfo[_pid][msg.sender];
1290         updatePool(_pid);
1291 
1292         if (user.amount > 0) {
1293           user.pendingTesta[pool.debtIndexKey] = pendingTesta(_pid, msg.sender);
1294         }
1295         
1296         if(_amount > 0) {
1297             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1298             user.amount = user.amount.add(_amount);
1299         }
1300         
1301         user.rewardDebt[pool.debtIndexKey] = user.amount.mul(pool.accTestaPerShare).div(1e18);
1302         emit Deposit(msg.sender, _pid, _amount);
1303     }
1304 
1305     // Withdraw LP tokens from TestaFarm.
1306     function withdraw(uint256 _pid, uint256 _amount) public {
1307         PoolInfo storage pool = poolInfo[_pid];
1308         UserInfo storage user = userInfo[_pid][msg.sender];
1309         require(user.amount >= _amount, "No lpToken cannot withdraw");
1310         updatePool(_pid);
1311         
1312         if(_amount > 0) {
1313             user.amount = user.amount.sub(_amount);
1314             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1315         }
1316         user.rewardDebt[pool.debtIndexKey] = user.amount.mul(pool.accTestaPerShare).div(1e18);
1317         emit Withdraw(msg.sender, _pid, _amount);
1318     }
1319 
1320     // Withdraw without caring about rewards. EMERGENCY ONLY.
1321     function emergencyWithdraw(uint256 _pid) public {
1322         PoolInfo storage pool = poolInfo[_pid];
1323         UserInfo storage user = userInfo[_pid][msg.sender];
1324         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1325         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1326         user.amount = 0;
1327         user.rewardDebt[pool.debtIndexKey] = 0;
1328     }
1329 
1330     // Safe testa transfer function, just in case if rounding error causes pool to not have enough Testa.
1331     function safeTestaTransfer(address _to, uint256 _amount) internal {
1332         uint256 testaBal = IERC20(testa).balanceOf(address(this));
1333         if (_amount > testaBal) {
1334             testa.call(abi.encodeWithSignature("transfer(address,uint256)", _to, testaBal));
1335         } else {
1336             testa.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _amount));
1337         }
1338     }
1339 }