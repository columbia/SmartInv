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
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations with added overflow
79  * checks.
80  *
81  * Arithmetic operations in Solidity wrap on overflow. This can easily result
82  * in bugs, because programmers usually assume that an overflow raises an
83  * error, which is the standard behavior in high level programming languages.
84  * `SafeMath` restores this intuition by reverting the transaction when an
85  * operation overflows.
86  *
87  * Using this library instead of the unchecked operations eliminates an entire
88  * class of bugs, so it's recommended to use it always.
89  */
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      *
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
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
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 /**
234  * @dev Collection of functions related to the address type
235  */
236 library Address {
237     /**
238      * @dev Returns true if `account` is a contract.
239      *
240      * [IMPORTANT]
241      * ====
242      * It is unsafe to assume that an address for which this function returns
243      * false is an externally-owned account (EOA) and not a contract.
244      *
245      * Among others, `isContract` will return false for the following
246      * types of addresses:
247      *
248      *  - an externally-owned account
249      *  - a contract in construction
250      *  - an address where a contract will be created
251      *  - an address where a contract lived, but was destroyed
252      * ====
253      */
254     function isContract(address account) internal view returns (bool) {
255         // This method relies on extcodesize, which returns 0 for contracts in
256         // construction, since the code is only stored at the end of the
257         // constructor execution.
258 
259         uint256 size;
260         // solhint-disable-next-line no-inline-assembly
261         assembly { size := extcodesize(account) }
262         return size > 0;
263     }
264 
265     /**
266      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267      * `recipient`, forwarding all available gas and reverting on errors.
268      *
269      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270      * of certain opcodes, possibly making contracts go over the 2300 gas limit
271      * imposed by `transfer`, making them unable to receive funds via
272      * `transfer`. {sendValue} removes this limitation.
273      *
274      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275      *
276      * IMPORTANT: because control is transferred to `recipient`, care must be
277      * taken to not create reentrancy vulnerabilities. Consider using
278      * {ReentrancyGuard} or the
279      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280      */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, "Address: insufficient balance");
283 
284         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
285         (bool success, ) = recipient.call{ value: amount }("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain`call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308       return functionCall(target, data, "Address: low-level call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
338      * with `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
343         require(address(this).balance >= value, "Address: insufficient balance for call");
344         require(isContract(target), "Address: call to non-contract");
345 
346         // solhint-disable-next-line avoid-low-level-calls
347         (bool success, bytes memory returndata) = target.call{ value: value }(data);
348         return _verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
358         return functionStaticCall(target, data, "Address: low-level static call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
368         require(isContract(target), "Address: static call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.staticcall(data);
372         return _verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.3._
380      */
381     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.3._
390      */
391     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
392         require(isContract(target), "Address: delegate call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.delegatecall(data);
396         return _verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
400         if (success) {
401             return returndata;
402         } else {
403             // Look for revert reason and bubble it up if present
404             if (returndata.length > 0) {
405                 // The easiest way to bubble the revert reason is using memory via assembly
406 
407                 // solhint-disable-next-line no-inline-assembly
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 
419 /**
420  * @title SafeERC20
421  * @dev Wrappers around ERC20 operations that throw on failure (when the token
422  * contract returns false). Tokens that return no value (and instead revert or
423  * throw on failure) are also supported, non-reverting calls are assumed to be
424  * successful.
425  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
426  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
427  */
428 library SafeERC20 {
429     using SafeMath for uint256;
430     using Address for address;
431 
432     function safeTransfer(IERC20 token, address to, uint256 value) internal {
433         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
434     }
435 
436     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
437         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
438     }
439 
440     /**
441      * @dev Deprecated. This function has issues similar to the ones found in
442      * {IERC20-approve}, and its usage is discouraged.
443      *
444      * Whenever possible, use {safeIncreaseAllowance} and
445      * {safeDecreaseAllowance} instead.
446      */
447     function safeApprove(IERC20 token, address spender, uint256 value) internal {
448         // safeApprove should only be called when setting an initial allowance,
449         // or when resetting it to zero. To increase and decrease it, use
450         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
451         // solhint-disable-next-line max-line-length
452         require((value == 0) || (token.allowance(address(this), spender) == 0),
453             "SafeERC20: approve from non-zero to non-zero allowance"
454         );
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
456     }
457 
458     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
459         uint256 newAllowance = token.allowance(address(this), spender).add(value);
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
461     }
462 
463     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
464         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
465         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
466     }
467 
468     /**
469      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
470      * on the return value: the return value is optional (but if data is returned, it must not be false).
471      * @param token The token targeted by the call.
472      * @param data The call data (encoded using abi.encode or one of its variants).
473      */
474     function _callOptionalReturn(IERC20 token, bytes memory data) private {
475         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
476         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
477         // the target address contains contract code and also asserts for success in the low-level call.
478 
479         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
480         if (returndata.length > 0) { // Return data is optional
481             // solhint-disable-next-line max-line-length
482             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
483         }
484     }
485 }
486 
487 /**
488  * @dev Library for managing
489  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
490  * types.
491  *
492  * Sets have the following properties:
493  *
494  * - Elements are added, removed, and checked for existence in constant time
495  * (O(1)).
496  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
497  *
498  * ```
499  * contract Example {
500  *     // Add the library methods
501  *     using EnumerableSet for EnumerableSet.AddressSet;
502  *
503  *     // Declare a set state variable
504  *     EnumerableSet.AddressSet private mySet;
505  * }
506  * ```
507  *
508  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
509  * (`UintSet`) are supported.
510  */
511 library EnumerableSet {
512     // To implement this library for multiple types with as little code
513     // repetition as possible, we write it in terms of a generic Set type with
514     // bytes32 values.
515     // The Set implementation uses private functions, and user-facing
516     // implementations (such as AddressSet) are just wrappers around the
517     // underlying Set.
518     // This means that we can only create new EnumerableSets for types that fit
519     // in bytes32.
520 
521     struct Set {
522         // Storage of set values
523         bytes32[] _values;
524 
525         // Position of the value in the `values` array, plus 1 because index 0
526         // means a value is not in the set.
527         mapping (bytes32 => uint256) _indexes;
528     }
529 
530     /**
531      * @dev Add a value to a set. O(1).
532      *
533      * Returns true if the value was added to the set, that is if it was not
534      * already present.
535      */
536     function _add(Set storage set, bytes32 value) private returns (bool) {
537         if (!_contains(set, value)) {
538             set._values.push(value);
539             // The value is stored at length-1, but we add 1 to all indexes
540             // and use 0 as a sentinel value
541             set._indexes[value] = set._values.length;
542             return true;
543         } else {
544             return false;
545         }
546     }
547 
548     /**
549      * @dev Removes a value from a set. O(1).
550      *
551      * Returns true if the value was removed from the set, that is if it was
552      * present.
553      */
554     function _remove(Set storage set, bytes32 value) private returns (bool) {
555         // We read and store the value's index to prevent multiple reads from the same storage slot
556         uint256 valueIndex = set._indexes[value];
557 
558         if (valueIndex != 0) { // Equivalent to contains(set, value)
559             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
560             // the array, and then remove the last element (sometimes called as 'swap and pop').
561             // This modifies the order of the array, as noted in {at}.
562 
563             uint256 toDeleteIndex = valueIndex - 1;
564             uint256 lastIndex = set._values.length - 1;
565 
566             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
567             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
568 
569             bytes32 lastvalue = set._values[lastIndex];
570 
571             // Move the last value to the index where the value to delete is
572             set._values[toDeleteIndex] = lastvalue;
573             // Update the index for the moved value
574             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
575 
576             // Delete the slot where the moved value was stored
577             set._values.pop();
578 
579             // Delete the index for the deleted slot
580             delete set._indexes[value];
581 
582             return true;
583         } else {
584             return false;
585         }
586     }
587 
588     /**
589      * @dev Returns true if the value is in the set. O(1).
590      */
591     function _contains(Set storage set, bytes32 value) private view returns (bool) {
592         return set._indexes[value] != 0;
593     }
594 
595     /**
596      * @dev Returns the number of values on the set. O(1).
597      */
598     function _length(Set storage set) private view returns (uint256) {
599         return set._values.length;
600     }
601 
602    /**
603     * @dev Returns the value stored at position `index` in the set. O(1).
604     *
605     * Note that there are no guarantees on the ordering of values inside the
606     * array, and it may change when more values are added or removed.
607     *
608     * Requirements:
609     *
610     * - `index` must be strictly less than {length}.
611     */
612     function _at(Set storage set, uint256 index) private view returns (bytes32) {
613         require(set._values.length > index, "EnumerableSet: index out of bounds");
614         return set._values[index];
615     }
616 
617     // AddressSet
618 
619     struct AddressSet {
620         Set _inner;
621     }
622 
623     /**
624      * @dev Add a value to a set. O(1).
625      *
626      * Returns true if the value was added to the set, that is if it was not
627      * already present.
628      */
629     function add(AddressSet storage set, address value) internal returns (bool) {
630         return _add(set._inner, bytes32(uint256(value)));
631     }
632 
633     /**
634      * @dev Removes a value from a set. O(1).
635      *
636      * Returns true if the value was removed from the set, that is if it was
637      * present.
638      */
639     function remove(AddressSet storage set, address value) internal returns (bool) {
640         return _remove(set._inner, bytes32(uint256(value)));
641     }
642 
643     /**
644      * @dev Returns true if the value is in the set. O(1).
645      */
646     function contains(AddressSet storage set, address value) internal view returns (bool) {
647         return _contains(set._inner, bytes32(uint256(value)));
648     }
649 
650     /**
651      * @dev Returns the number of values in the set. O(1).
652      */
653     function length(AddressSet storage set) internal view returns (uint256) {
654         return _length(set._inner);
655     }
656 
657    /**
658     * @dev Returns the value stored at position `index` in the set. O(1).
659     *
660     * Note that there are no guarantees on the ordering of values inside the
661     * array, and it may change when more values are added or removed.
662     *
663     * Requirements:
664     *
665     * - `index` must be strictly less than {length}.
666     */
667     function at(AddressSet storage set, uint256 index) internal view returns (address) {
668         return address(uint256(_at(set._inner, index)));
669     }
670 
671 
672     // UintSet
673 
674     struct UintSet {
675         Set _inner;
676     }
677 
678     /**
679      * @dev Add a value to a set. O(1).
680      *
681      * Returns true if the value was added to the set, that is if it was not
682      * already present.
683      */
684     function add(UintSet storage set, uint256 value) internal returns (bool) {
685         return _add(set._inner, bytes32(value));
686     }
687 
688     /**
689      * @dev Removes a value from a set. O(1).
690      *
691      * Returns true if the value was removed from the set, that is if it was
692      * present.
693      */
694     function remove(UintSet storage set, uint256 value) internal returns (bool) {
695         return _remove(set._inner, bytes32(value));
696     }
697 
698     /**
699      * @dev Returns true if the value is in the set. O(1).
700      */
701     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
702         return _contains(set._inner, bytes32(value));
703     }
704 
705     /**
706      * @dev Returns the number of values on the set. O(1).
707      */
708     function length(UintSet storage set) internal view returns (uint256) {
709         return _length(set._inner);
710     }
711 
712    /**
713     * @dev Returns the value stored at position `index` in the set. O(1).
714     *
715     * Note that there are no guarantees on the ordering of values inside the
716     * array, and it may change when more values are added or removed.
717     *
718     * Requirements:
719     *
720     * - `index` must be strictly less than {length}.
721     */
722     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
723         return uint256(_at(set._inner, index));
724     }
725 }
726 
727 /*
728  * @dev Provides information about the current execution context, including the
729  * sender of the transaction and its data. While these are generally available
730  * via msg.sender and msg.data, they should not be accessed in such a direct
731  * manner, since when dealing with GSN meta-transactions the account sending and
732  * paying for execution may not be the actual sender (as far as an application
733  * is concerned).
734  *
735  * This contract is only required for intermediate, library-like contracts.
736  */
737 abstract contract Context {
738     function _msgSender() internal view virtual returns (address payable) {
739         return msg.sender;
740     }
741 
742     function _msgData() internal view virtual returns (bytes memory) {
743         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
744         return msg.data;
745     }
746 }
747 
748 /**
749  * @dev Contract module which provides a basic access control mechanism, where
750  * there is an account (an owner) that can be granted exclusive access to
751  * specific functions.
752  *
753  * By default, the owner account will be the one that deploys the contract. This
754  * can later be changed with {transferOwnership}.
755  *
756  * This module is used through inheritance. It will make available the modifier
757  * `onlyOwner`, which can be applied to your functions to restrict their use to
758  * the owner.
759  */
760 contract Ownable is Context {
761     address private _owner;
762 
763     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
764 
765     /**
766      * @dev Initializes the contract setting the deployer as the initial owner.
767      */
768     constructor () internal {
769         address msgSender = _msgSender();
770         _owner = msgSender;
771         emit OwnershipTransferred(address(0), msgSender);
772     }
773 
774     /**
775      * @dev Returns the address of the current owner.
776      */
777     function owner() public view returns (address) {
778         return _owner;
779     }
780 
781     /**
782      * @dev Throws if called by any account other than the owner.
783      */
784     modifier onlyOwner() {
785         require(_owner == _msgSender(), "Ownable: caller is not the owner");
786         _;
787     }
788 
789     /**
790      * @dev Leaves the contract without owner. It will not be possible to call
791      * `onlyOwner` functions anymore. Can only be called by the current owner.
792      *
793      * NOTE: Renouncing ownership will leave the contract without an owner,
794      * thereby removing any functionality that is only available to the owner.
795      */
796     function renounceOwnership() public virtual onlyOwner {
797         emit OwnershipTransferred(_owner, address(0));
798         _owner = address(0);
799     }
800 
801     /**
802      * @dev Transfers ownership of the contract to a new account (`newOwner`).
803      * Can only be called by the current owner.
804      */
805     function transferOwnership(address newOwner) public virtual onlyOwner {
806         require(newOwner != address(0), "Ownable: new owner is the zero address");
807         emit OwnershipTransferred(_owner, newOwner);
808         _owner = newOwner;
809     }
810 }
811 
812 /**
813  * @dev Implementation of the {IERC20} interface.
814  *
815  * This implementation is agnostic to the way tokens are created. This means
816  * that a supply mechanism has to be added in a derived contract using {_mint}.
817  * For a generic mechanism see {ERC20PresetMinterPauser}.
818  *
819  * TIP: For a detailed writeup see our guide
820  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
821  * to implement supply mechanisms].
822  *
823  * We have followed general OpenZeppelin guidelines: functions revert instead
824  * of returning `false` on failure. This behavior is nonetheless conventional
825  * and does not conflict with the expectations of ERC20 applications.
826  *
827  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
828  * This allows applications to reconstruct the allowance for all accounts just
829  * by listening to said events. Other implementations of the EIP may not emit
830  * these events, as it isn't required by the specification.
831  *
832  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
833  * functions have been added to mitigate the well-known issues around setting
834  * allowances. See {IERC20-approve}.
835  */
836 contract ERC20 is Context, IERC20 {
837     using SafeMath for uint256;
838     using Address for address;
839 
840     mapping (address => uint256) private _balances;
841     mapping (address => mapping (address => uint256)) private _allowances;
842     mapping (address => bool) public _whitelistedAddresses;
843 
844     uint256 private _totalSupply;
845     uint256 private _burnedSupply;
846     uint256 private _minSupply;
847     uint256 private _burnRate;
848     string private _name;
849     string private _symbol;
850     uint256 private _decimals;
851 
852     /**
853      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
854      * a default value of 18.
855      *
856      * To select a different value for {decimals}, use {_setupDecimals}.
857      *
858      * All three of these values are immutable: they can only be set once during
859      * construction.
860      */
861     constructor (string memory name, string memory symbol, uint256 decimals, uint256 burnrate, uint256 initSupply, uint256 minSupply) public {
862         _name = name;
863         _symbol = symbol;
864         _decimals = decimals;
865         _burnRate = burnrate;
866         _totalSupply = 0;
867         _mint(msg.sender, initSupply*(10**_decimals));
868         _burnedSupply = 0;
869         _minSupply = minSupply*(10**_decimals);
870     }
871 
872     /**
873      * @dev Returns the name of the token.
874      */
875     function name() public view returns (string memory) {
876         return _name;
877     }
878 
879     /**
880      * @dev Returns the symbol of the token, usually a shorter version of the
881      * name.
882      */
883     function symbol() public view returns (string memory) {
884         return _symbol;
885     }
886 
887     /**
888      * @dev Returns the number of decimals used to get its user representation.
889      * For example, if `decimals` equals `2`, a balance of `505` tokens should
890      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
891      *
892      * Tokens usually opt for a value of 18, imitating the relationship between
893      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
894      * called.
895      *
896      * NOTE: This information is only used for _display_ purposes: it in
897      * no way affects any of the arithmetic of the contract, including
898      * {IERC20-balanceOf} and {IERC20-transfer}.
899      */
900     function decimals() public view returns (uint256) {
901         return _decimals;
902     }
903 
904     /**
905      * @dev See {IERC20-totalSupply}.
906      */
907     function totalSupply() public view override returns (uint256) {
908         return _totalSupply;
909     }
910 
911     /**
912      * @dev Returns the amount of burned tokens.
913      */
914     function burnedSupply() public view returns (uint256) {
915         return _burnedSupply;
916     }
917 
918     /**
919      * @dev Returns the burnrate.
920      */
921     function burnRate() public view returns (uint256) {
922         return _burnRate;
923     }
924 
925     /**
926      * @dev See {IERC20-balanceOf}.
927      */
928     function balanceOf(address account) public view override returns (uint256) {
929         return _balances[account];
930     }
931 
932     /**
933      * @dev See {IERC20-transfer}.
934      *
935      * Requirements:
936      *
937      * - `recipient` cannot be the zero address.
938      * - the caller must have a balance of at least `amount`.
939      */
940     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
941         _transfer(_msgSender(), recipient, amount);
942         return true;
943     }
944 
945     /**
946      * @dev See {IERC20-transfer}.
947      *
948      * Requirements:
949      *
950      * - `account` cannot be the zero address.
951      * - the caller must have a balance of at least `amount`.
952      */
953     function burn(uint256 amount) public virtual returns (bool) {
954         _burn(_msgSender(), amount);
955         return true;
956     }
957 
958     /**
959      * @dev See {IERC20-allowance}.
960      */
961     function allowance(address owner, address spender) public view virtual override returns (uint256) {
962         return _allowances[owner][spender];
963     }
964 
965     /**
966      * @dev See {IERC20-approve}.
967      *
968      * Requirements:
969      *
970      * - `spender` cannot be the zero address.
971      */
972     function approve(address spender, uint256 amount) public virtual override returns (bool) {
973         _approve(_msgSender(), spender, amount);
974         return true;
975     }
976 
977     /**
978      * @dev See {IERC20-transferFrom}.
979      *
980      * Emits an {Approval} event indicating the updated allowance. This is not
981      * required by the EIP. See the note at the beginning of {ERC20};
982      *
983      * Requirements:
984      * - `sender` and `recipient` cannot be the zero address.
985      * - `sender` must have a balance of at least `amount`.
986      * - the caller must have allowance for ``sender``'s tokens of at least
987      * `amount`.
988      */
989     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
990         _transfer(sender, recipient, amount);
991         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
992         return true;
993     }
994 
995     /**
996      * @dev Atomically increases the allowance granted to `spender` by the caller.
997      *
998      * This is an alternative to {approve} that can be used as a mitigation for
999      * problems described in {IERC20-approve}.
1000      *
1001      * Emits an {Approval} event indicating the updated allowance.
1002      *
1003      * Requirements:
1004      *
1005      * - `spender` cannot be the zero address.
1006      */
1007     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1008         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1009         return true;
1010     }
1011 
1012     /**
1013      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1014      *
1015      * This is an alternative to {approve} that can be used as a mitigation for
1016      * problems described in {IERC20-approve}.
1017      *
1018      * Emits an {Approval} event indicating the updated allowance.
1019      *
1020      * Requirements:
1021      *
1022      * - `spender` cannot be the zero address.
1023      * - `spender` must have allowance for the caller of at least
1024      * `subtractedValue`.
1025      */
1026     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1027         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1028         return true;
1029     }
1030 
1031     /**
1032      * @dev Moves tokens `amount` from `sender` to `recipient`.
1033      *
1034      * This is internal function is equivalent to {transfer}, and can be used to
1035      * e.g. implement automatic token fees, slashing mechanisms, etc.
1036      *
1037      * Emits a {Transfer} event.
1038      *
1039      * Requirements:
1040      *
1041      * - `sender` cannot be the zero address.
1042      * - `recipient` cannot be the zero address.
1043      * - `sender` must have a balance of at least `amount`.
1044      */
1045     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1046         require(sender != address(0), "ERC20: transfer from the zero address");
1047         require(recipient != address(0), "ERC20: transfer to the zero address");
1048 
1049         if (_whitelistedAddresses[sender] == true || _whitelistedAddresses[recipient] == true) {
1050             _beforeTokenTransfer(sender, recipient, amount);
1051             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1052             _balances[recipient] = _balances[recipient].add(amount);
1053             emit Transfer(sender, recipient, amount);
1054         } else {
1055             uint256 amount_burn = amount.mul(_burnRate).div(1000);
1056             uint256 amount_send = amount.sub(amount_burn);
1057             require(amount == amount_send + amount_burn, "Burn value invalid");
1058             if(_totalSupply.sub(amount_burn) >= _minSupply) {
1059                 _burn(sender, amount_burn);
1060                 amount = amount_send;
1061             } else {
1062                 amount = amount_send + amount_burn;
1063             }
1064             _beforeTokenTransfer(sender, recipient, amount);
1065             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1066             _balances[recipient] = _balances[recipient].add(amount);
1067             emit Transfer(sender, recipient, amount);
1068         }
1069     }
1070 
1071     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1072      * the total supply.
1073      *
1074      * Emits a {Transfer} event with `from` set to the zero address.
1075      *
1076      * Requirements
1077      *
1078      * - `to` cannot be the zero address.
1079      * 
1080      * HINT: This function is 'internal' and therefore can only be called from another
1081      * function inside this contract!
1082      */
1083     function _mint(address account, uint256 amount) internal virtual {
1084         require(account != address(0), "ERC20: mint to the zero address");
1085         _beforeTokenTransfer(address(0), account, amount);
1086         _totalSupply = _totalSupply.add(amount);
1087         _balances[account] = _balances[account].add(amount);
1088         emit Transfer(address(0), account, amount);
1089     }
1090 
1091     /**
1092      * @dev Destroys `amount` tokens from `account`, reducing the
1093      * total supply.
1094      *
1095      * Emits a {Transfer} event with `to` set to the zero address.
1096      *
1097      * Requirements
1098      *
1099      * - `account` cannot be the zero address.
1100      * - `account` must have at least `amount` tokens.
1101      */
1102     function _burn(address account, uint256 amount) internal virtual {
1103         require(account != address(0), "ERC20: burn from the zero address");
1104         _beforeTokenTransfer(account, address(0), amount);
1105         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1106         _totalSupply = _totalSupply.sub(amount);
1107         _burnedSupply = _burnedSupply.add(amount);
1108         emit Transfer(account, address(0), amount);
1109     }
1110 
1111     /**
1112      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1113      *
1114      * This is internal function is equivalent to `approve`, and can be used to
1115      * e.g. set automatic allowances for certain subsystems, etc.
1116      *
1117      * Emits an {Approval} event.
1118      *
1119      * Requirements:
1120      *
1121      * - `owner` cannot be the zero address.
1122      * - `spender` cannot be the zero address.
1123      */
1124     function _approve(address owner, address spender, uint256 amount) internal virtual {
1125         require(owner != address(0), "ERC20: approve from the zero address");
1126         require(spender != address(0), "ERC20: approve to the zero address");
1127         _allowances[owner][spender] = amount;
1128         emit Approval(owner, spender, amount);
1129     }
1130 
1131     /**
1132      * @dev Sets {burnRate} to a value other than the initial one.
1133      */
1134     function _setupBurnrate(uint8 burnrate_) internal virtual {
1135         _burnRate = burnrate_;
1136     }
1137 
1138     /**
1139      * @dev Hook that is called before any transfer of tokens. This includes
1140      * minting and burning.
1141      *
1142      * Calling conditions:
1143      *
1144      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1145      * will be to transferred to `to`.
1146      * - when `from` is zero, `amount` tokens will be minted for `to`.
1147      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1148      * - `from` and `to` are never both zero.
1149      *
1150      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1151      */
1152     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1153 }
1154 
1155 /**
1156  * @dev Contract module which provides a basic access control mechanism, where
1157  * there is an account (an minter) that can be granted exclusive access to
1158  * specific functions.
1159  *
1160  * By default, the minter account will be the one that deploys the contract. This
1161  * can later be changed with {transferMintership}.
1162  *
1163  * This module is used through inheritance. It will make available the modifier
1164  * `onlyMinter`, which can be applied to your functions to restrict their use to
1165  * the minter.
1166  */
1167 contract Mintable is Context {
1168 
1169     /**
1170      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'minter'
1171      * this way the developer/owner stays the 'owner' and can make changes like adding a pool
1172      * at any time but cannot mint anymore as soon as the 'minter' gets changes (to the chef contract)
1173      */
1174     address private _minter;
1175 
1176     event MintershipTransferred(address indexed previousMinter, address indexed newMinter);
1177 
1178     /**
1179      * @dev Initializes the contract setting the deployer as the initial minter.
1180      */
1181     constructor () internal {
1182         address msgSender = _msgSender();
1183         _minter = msgSender;
1184         emit MintershipTransferred(address(0), msgSender);
1185     }
1186 
1187     /**
1188      * @dev Returns the address of the current minter.
1189      */
1190     function minter() public view returns (address) {
1191         return _minter;
1192     }
1193 
1194     /**
1195      * @dev Throws if called by any account other than the minter.
1196      */
1197     modifier onlyMinter() {
1198         require(_minter == _msgSender(), "Mintable: caller is not the minter");
1199         _;
1200     }
1201 
1202     /**
1203      * @dev Transfers mintership of the contract to a new account (`newMinter`).
1204      * Can only be called by the current minter.
1205      */
1206     function transferMintership(address newMinter) public virtual onlyMinter {
1207         require(newMinter != address(0), "Mintable: new minter is the zero address");
1208         emit MintershipTransferred(_minter, newMinter);
1209         _minter = newMinter;
1210     }
1211 }
1212 
1213 contract DopeSwap is ERC20("DopeSwap", "DOPE", 18, 25, 1000, 500), Ownable, Mintable {
1214     /// @notice Creates `_amount` token to `_to`. Must only be called by the minter (DopeDealer).
1215     function mint(address _to, uint256 _amount) public onlyMinter {
1216         _mint(_to, _amount);
1217     }
1218 
1219     function setBurnrate(uint8 burnrate_) public onlyOwner {
1220         _setupBurnrate(burnrate_);
1221     }
1222 
1223     function addWhitelistedAddress(address _address) public onlyOwner {
1224         _whitelistedAddresses[_address] = true;
1225     }
1226 
1227     function removeWhitelistedAddress(address _address) public onlyOwner {
1228         _whitelistedAddresses[_address] = false;
1229     }
1230 }
1231 
1232 interface IMigrationMaster {
1233     // Perform LP token migration for swapping liquidity providers.
1234     // Take the current LP token address and return the new LP token address.
1235     // Migrator should have full access to the caller's LP token.
1236     // Return the new LP token address.
1237     //
1238     // Migrator must have allowance access to old LP tokens.
1239     // EXACTLY the same amount of new LP tokens must be minted or
1240     // else something bad will happen. This function is meant to be used to swap
1241     // to the native liquidity provider in the future!
1242     function migrate(IERC20 token) external returns (IERC20);
1243 }
1244 
1245 contract DopeDealer is Ownable {
1246     using SafeMath for uint256;
1247     using SafeERC20 for IERC20;
1248 
1249     // Info of each user.
1250     struct UserInfo {
1251         uint256 amount; // How many LP tokens the user has provided.
1252         uint256 rewardDebt; // Reward debt.
1253         uint256 pendingRewards; // Pending rewards for user.
1254         uint256 lastHarvestBlock; //Block of last harvest, used for vesting
1255     }
1256 
1257     // Info of each pool.
1258     struct PoolInfo {
1259         IERC20 lpToken; // Address of LP token contract.
1260         uint256 allocPoint; // How many allocation points assigned to this pool. DOPEs to distribute per block.
1261         uint256 lastRewardBlock; // Last block number that DOPEs distribution occurs.
1262         uint256 accDopePerShare; // Accumulated DOPEs per share, times 1e12. See below.
1263         uint256 harvestVestingBlocks; // How much vesting for harvesting
1264     }
1265 
1266     // DOPE token
1267     DopeSwap public dope;
1268     // DOPE tokens created per block.
1269     uint256 public dopePerBlock;
1270     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1271     IMigrationMaster public migrator;
1272     //Has the minting rate halved?
1273     bool isMintingHalved;
1274     //Maximum DOPE supply
1275     uint256 public maxDopeSupply;
1276 
1277     // Info of each pool.
1278     PoolInfo[] public poolInfo;
1279     // Info of each user that stakes LP tokens.
1280     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1281     // Total allocation points. Must be the sum of all allocation points in all pools.
1282     uint256 public totalAllocPoint = 0;
1283     // The block number when DOPE mining starts.
1284     uint256 public startBlock;
1285 
1286     // Events
1287     event Recovered(address token, uint256 amount);
1288     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1289     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1290     event Claim(address indexed user, uint256 indexed pid, uint256 amount);
1291     event ClaimAndStake(address indexed user, uint256 indexed pid, uint256 amount);
1292     event EmergencyWithdraw(
1293         address indexed user,
1294         uint256 indexed pid,
1295         uint256 amount
1296     );
1297 
1298     constructor(
1299         DopeSwap _dope,
1300         uint256 _dopePerBlock,
1301         uint256 _startBlock,
1302         uint256 _maxDopeSupply
1303     ) public {
1304         dope = _dope;
1305         dopePerBlock = _dopePerBlock;
1306         startBlock = _startBlock;
1307         isMintingHalved = false;
1308         maxDopeSupply = _maxDopeSupply*(10**dope.decimals());
1309 
1310         // staking pool
1311         poolInfo.push(PoolInfo({
1312             lpToken: _dope,
1313             allocPoint: 1000,
1314             lastRewardBlock: startBlock,
1315             accDopePerShare: 0,
1316             harvestVestingBlocks: 0
1317         }));
1318 
1319         totalAllocPoint = 1000;
1320     }
1321 
1322     function poolLength() external view returns (uint256) {
1323         return poolInfo.length;
1324     }
1325     
1326     // Return reward multiplier over the given _from to _to block.
1327     // maybe add bonus
1328     function getMultiplier(uint256 _from, uint256 _to)
1329         public
1330         pure
1331         returns (uint256)
1332     {
1333         return _to.sub(_from);
1334         //Maybe add bonuses based on block?
1335     }
1336 
1337     // Add a new lp to the pool. Can only be called by the owner.
1338     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1339     function add(
1340         uint256 _allocPoint,
1341         IERC20 _lpToken,
1342         bool _withUpdate,
1343         uint _harvestVestingBlocks
1344     ) public onlyOwner {
1345         if (_withUpdate) {
1346             massUpdatePools();
1347         }
1348         uint256 lastRewardBlock = block.number > startBlock
1349             ? block.number
1350             : startBlock;
1351         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1352         poolInfo.push(
1353             PoolInfo({
1354                 lpToken: _lpToken,
1355                 allocPoint: _allocPoint,
1356                 lastRewardBlock: lastRewardBlock,
1357                 accDopePerShare: 0,
1358                 harvestVestingBlocks: _harvestVestingBlocks
1359             })
1360         );
1361         updateStakingPool();
1362     }
1363 
1364     // Update the given pool's DOPE allocation point. Can only be called by the owner.
1365     function set(
1366         uint256 _pid,
1367         uint256 _allocPoint,
1368         bool _withUpdate
1369     ) public onlyOwner {
1370         if (_withUpdate) {
1371             massUpdatePools();
1372         }
1373         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1374             _allocPoint
1375         );
1376         uint256 prevAllocPoint = poolInfo[_pid].allocPoint;
1377         poolInfo[_pid].allocPoint = _allocPoint;
1378         if (prevAllocPoint != _allocPoint) {
1379             updateStakingPool();
1380         }
1381     }
1382 
1383     function updateStakingPool() internal {
1384         uint256 length = poolInfo.length;
1385         uint256 points = 0;
1386         for (uint256 pid = 1; pid < length; ++pid) {
1387             points = points.add(poolInfo[pid].allocPoint);
1388         }
1389         if (points != 0) {
1390             points = points.div(3);
1391             totalAllocPoint = totalAllocPoint.sub(poolInfo[0].allocPoint).add(points);
1392             poolInfo[0].allocPoint = points;
1393         }
1394     }
1395 
1396     // Migrate lp token to another lp contract. Can be called by anyone. 
1397     // We trust that migrator contract is good.
1398     function migrate(uint256 _pid) public {
1399         require(address(migrator) != address(0), "migrate: no migrator");
1400         PoolInfo storage pool = poolInfo[_pid];
1401         IERC20 lpToken = pool.lpToken;
1402         uint256 bal = lpToken.balanceOf(address(this));
1403         lpToken.safeApprove(address(migrator), bal);
1404         IERC20 newLpToken = migrator.migrate(lpToken);
1405         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1406         pool.lpToken = newLpToken;
1407     }
1408 
1409     // View function to see pending DOPEs on frontend.
1410     function pendingDOPEs(uint256 _pid, address _user)
1411         external
1412         view
1413         returns (uint256)
1414     {
1415         PoolInfo storage pool = poolInfo[_pid];
1416         UserInfo storage user = userInfo[_pid][_user];
1417         uint256 accDopePerShare = pool.accDopePerShare;
1418         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1419         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1420             uint256 multiplier = getMultiplier(
1421                 pool.lastRewardBlock,
1422                 block.number
1423             );
1424             uint256 dopeReward = multiplier
1425                 .mul(dopePerBlock)
1426                 .mul(pool.allocPoint)
1427                 .div(totalAllocPoint);
1428             accDopePerShare = accDopePerShare.add(
1429                 dopeReward.mul(1e12).div(lpSupply)
1430             );
1431         }
1432         return
1433             user.amount.mul(accDopePerShare).div(1e12).sub(user.rewardDebt).add(user.pendingRewards);
1434     }
1435 
1436     // Update reward vairables for all pools. Be careful of gas spending!
1437     function massUpdatePools() public {
1438         uint256 length = poolInfo.length;
1439         for (uint256 pid = 0; pid < length; ++pid) {
1440             updatePool(pid);
1441         }
1442     }
1443 
1444     // Update reward variables of the given pool to be up-to-date.
1445     function updatePool(uint256 _pid) public {
1446         PoolInfo storage pool = poolInfo[_pid];
1447         if (block.number <= pool.lastRewardBlock) {
1448             return;
1449         }
1450         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1451         if (lpSupply == 0) {
1452             pool.lastRewardBlock = block.number;
1453             return;
1454         }
1455         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1456         uint256 dopeReward = multiplier
1457             .mul(dopePerBlock)
1458             .mul(pool.allocPoint)
1459             .div(totalAllocPoint);
1460         uint256 currentSupply = dope.totalSupply();
1461         if(currentSupply.add(dopeReward) <= maxDopeSupply) {
1462             dope.mint(address(this), dopeReward);
1463         }
1464         pool.accDopePerShare = pool.accDopePerShare.add(
1465             dopeReward.mul(1e12).div(lpSupply)
1466         );
1467         pool.lastRewardBlock = block.number;
1468         //Should we halve the minting?
1469         if(block.number >= startBlock.add(100000) && !isMintingHalved) {
1470             dopePerBlock = dopePerBlock.div(2);
1471             isMintingHalved = true;
1472         }
1473     }
1474 
1475     // Deposit LP tokens to DopeDealer for DOPE allocation.
1476     function deposit(uint256 _pid, uint256 _amount, bool _withdrawRewards) public {
1477         require (_pid != 0, 'please deposit DOPE by staking');
1478         PoolInfo storage pool = poolInfo[_pid];
1479         UserInfo storage user = userInfo[_pid][msg.sender];
1480         updatePool(_pid);
1481         if (user.amount > 0) {
1482             uint256 pending = user
1483                 .amount
1484                 .mul(pool.accDopePerShare)
1485                 .div(1e12)
1486                 .sub(user.rewardDebt);
1487             
1488             if (pending > 0) {
1489                 user.pendingRewards = user.pendingRewards.add(pending);
1490 
1491                 if (_withdrawRewards) {
1492                     safeDopeTransfer(msg.sender, user.pendingRewards);
1493                     emit Claim(msg.sender, _pid, user.pendingRewards);
1494                     user.pendingRewards = 0;
1495                 }
1496             }
1497         }
1498         if (_amount > 0) {
1499             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1500             user.amount = user.amount.add(_amount);
1501         }
1502         user.rewardDebt = user.amount.mul(pool.accDopePerShare).div(1e12);
1503         user.lastHarvestBlock = block.number;
1504         emit Deposit(msg.sender, _pid, _amount);
1505     }
1506 
1507     // Withdraw LP tokens from DopeDealer.
1508     function withdraw(uint256 _pid, uint256 _amount, bool _withdrawRewards) public {
1509         require (_pid != 0, 'please withdraw DOPE by unstaking');
1510         PoolInfo storage pool = poolInfo[_pid];
1511         UserInfo storage user = userInfo[_pid][msg.sender];
1512         require(user.amount >= _amount, "withdraw: not good");
1513         require (block.number >= user.lastHarvestBlock.add(pool.harvestVestingBlocks), 'withdraw: you cant harvest yet');
1514         updatePool(_pid);
1515         uint256 pending = user.amount.mul(pool.accDopePerShare).div(1e12).sub(user.rewardDebt);
1516         if (pending > 0) {
1517             user.pendingRewards = user.pendingRewards.add(pending);
1518 
1519             if (_withdrawRewards) {
1520                 safeDopeTransfer(msg.sender, user.pendingRewards);
1521                 emit Claim(msg.sender, _pid, user.pendingRewards);
1522                 user.pendingRewards = 0;
1523             }
1524         }
1525         if (_amount > 0) {
1526             user.amount = user.amount.sub(_amount);
1527             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1528         }
1529         user.rewardDebt = user.amount.mul(pool.accDopePerShare).div(1e12);
1530         user.lastHarvestBlock = block.number;
1531         emit Withdraw(msg.sender, _pid, _amount);
1532     }
1533 
1534     // Withdraw without caring about rewards. EMERGENCY ONLY.
1535     function emergencyWithdraw(uint256 _pid) public {
1536         require (_pid != 0, 'please withdraw DOPE by unstaking');
1537         PoolInfo storage pool = poolInfo[_pid];
1538         UserInfo storage user = userInfo[_pid][msg.sender];
1539         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1540         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1541         user.amount = 0;
1542         user.rewardDebt = 0;
1543         user.pendingRewards = 0;
1544         user.lastHarvestBlock = block.number;
1545     }
1546 
1547     // Claim rewards from DopeDealer.
1548     function claim(uint256 _pid) public {
1549         require (_pid != 0, 'please claim staking rewards on stake page');
1550         PoolInfo storage pool = poolInfo[_pid];
1551         UserInfo storage user = userInfo[_pid][msg.sender];
1552         require (block.number >= user.lastHarvestBlock.add(pool.harvestVestingBlocks), 'withdraw: you cant harvest yet');
1553         updatePool(_pid);
1554         uint256 pending = user.amount.mul(pool.accDopePerShare).div(1e12).sub(user.rewardDebt);
1555         if (pending > 0 || user.pendingRewards > 0) {
1556             user.pendingRewards = user.pendingRewards.add(pending);
1557             safeDopeTransfer(msg.sender, user.pendingRewards);
1558             emit Claim(msg.sender, _pid, user.pendingRewards);
1559             user.pendingRewards = 0;
1560             user.lastHarvestBlock = block.number;
1561         }
1562         user.rewardDebt = user.amount.mul(pool.accDopePerShare).div(1e12);
1563     }
1564 
1565     // Claim rewards from DopeDealer and deposit them directly to staking pool.
1566     function claimAndStake(uint256 _pid) public {
1567         require (_pid != 0, 'please claim and stake staking rewards on stake page');
1568         PoolInfo storage pool = poolInfo[_pid];
1569         UserInfo storage user = userInfo[_pid][msg.sender];
1570         updatePool(_pid);
1571         uint256 pending = user.amount.mul(pool.accDopePerShare).div(1e12).sub(user.rewardDebt);
1572         if (pending > 0 || user.pendingRewards > 0) {
1573             user.pendingRewards = user.pendingRewards.add(pending);
1574             transferToStake(user.pendingRewards);
1575             emit ClaimAndStake(msg.sender, _pid, user.pendingRewards);
1576             user.pendingRewards = 0;
1577         }
1578         user.rewardDebt = user.amount.mul(pool.accDopePerShare).div(1e12);
1579     }
1580 
1581     // Transfer rewards from LP pools to staking pool.
1582     function transferToStake(uint256 _amount) internal {
1583         PoolInfo storage pool = poolInfo[0];
1584         UserInfo storage user = userInfo[0][msg.sender];
1585         updatePool(0);
1586         if (user.amount > 0) {
1587             uint256 pending = user.amount.mul(pool.accDopePerShare).div(1e12).sub(user.rewardDebt);
1588             if (pending > 0) {
1589                 user.pendingRewards = user.pendingRewards.add(pending);
1590             }
1591         }
1592         if (_amount > 0) {
1593             user.amount = user.amount.add(_amount);
1594         }
1595         user.rewardDebt = user.amount.mul(pool.accDopePerShare).div(1e12);
1596 
1597         emit Deposit(msg.sender, 0, _amount);
1598     }
1599 
1600     // Stake DOPE tokens to DopeDealer.
1601     function enterStaking(uint256 _amount, bool _withdrawRewards) public {
1602         PoolInfo storage pool = poolInfo[0];
1603         UserInfo storage user = userInfo[0][msg.sender];
1604         updatePool(0);
1605         if (user.amount > 0) {
1606             uint256 pending = user.amount.mul(pool.accDopePerShare).div(1e12).sub(user.rewardDebt);
1607             if (pending > 0) {
1608                 user.pendingRewards = user.pendingRewards.add(pending);
1609 
1610                 if (_withdrawRewards) {
1611                     safeDopeTransfer(msg.sender, user.pendingRewards);
1612                     user.pendingRewards = 0;
1613                 }
1614             }
1615         }
1616         if (_amount > 0) {
1617             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1618             user.amount = user.amount.add(_amount);
1619         }
1620         user.rewardDebt = user.amount.mul(pool.accDopePerShare).div(1e12);
1621 
1622         emit Deposit(msg.sender, 0, _amount);
1623     }
1624 
1625     // Withdraw DOPE tokens from staking.
1626     function leaveStaking(uint256 _amount, bool _withdrawRewards) public {
1627         PoolInfo storage pool = poolInfo[0];
1628         UserInfo storage user = userInfo[0][msg.sender];
1629         require(user.amount >= _amount, "unstake: not good");
1630         updatePool(0);
1631         uint256 pending = user.amount.mul(pool.accDopePerShare).div(1e12).sub(user.rewardDebt);
1632         if (pending > 0) {
1633                 user.pendingRewards = user.pendingRewards.add(pending);
1634 
1635                 if (_withdrawRewards) {
1636                     safeDopeTransfer(msg.sender, user.pendingRewards);
1637                     user.pendingRewards = 0;
1638                 }
1639             }
1640         if (_amount > 0) {
1641             user.amount = user.amount.sub(_amount);
1642             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1643         }
1644         user.rewardDebt = user.amount.mul(pool.accDopePerShare).div(1e12);
1645 
1646         emit Withdraw(msg.sender, 0, _amount);
1647     }
1648 
1649     // Claim staking rewards from DopeDealer.
1650     function claimStaking() public {
1651         PoolInfo storage pool = poolInfo[0];
1652         UserInfo storage user = userInfo[0][msg.sender];
1653         updatePool(0);
1654         uint256 pending = user.amount.mul(pool.accDopePerShare).div(1e12).sub(user.rewardDebt);
1655         if (pending > 0 || user.pendingRewards > 0) {
1656             user.pendingRewards = user.pendingRewards.add(pending);
1657             safeDopeTransfer(msg.sender, user.pendingRewards);
1658             emit Claim(msg.sender, 0, user.pendingRewards);
1659             user.pendingRewards = 0;
1660         }
1661         user.rewardDebt = user.amount.mul(pool.accDopePerShare).div(1e12);
1662     }
1663 
1664     // Transfer staking rewards to staking pool.
1665     function stakeRewardsStaking() public {
1666         PoolInfo storage pool = poolInfo[0];
1667         UserInfo storage user = userInfo[0][msg.sender];
1668         uint256 rewardsToStake;
1669         updatePool(0);
1670         if (user.amount > 0) {
1671             uint256 pending = user.amount.mul(pool.accDopePerShare).div(1e12).sub(user.rewardDebt);
1672             if (pending > 0) {
1673                 user.pendingRewards = user.pendingRewards.add(pending);
1674             }
1675         }
1676         if (user.pendingRewards > 0) {
1677             rewardsToStake = user.pendingRewards;
1678             user.pendingRewards = 0;
1679             user.amount = user.amount.add(rewardsToStake);
1680         }
1681         user.rewardDebt = user.amount.mul(pool.accDopePerShare).div(1e12);
1682 
1683         emit Deposit(msg.sender, 0, rewardsToStake);
1684     }
1685 
1686     // Safe DOPE transfer function, just in case if rounding error causes pool to not have enough DOPEs.
1687     function safeDopeTransfer(address _to, uint256 _amount) internal {
1688         uint256 dopeBal = dope.balanceOf(address(this));
1689         if (_amount > dopeBal) {
1690             dope.transfer(_to, dopeBal);
1691         } else {
1692             dope.transfer(_to, _amount);
1693         }
1694     }
1695 
1696     // **** Additional functions to edit master attributes ****
1697 
1698     function setDopePerBlock(uint256 _dopePerBlock) public onlyOwner {
1699         require(_dopePerBlock > 0, "!dopePerBlock-0");
1700         dopePerBlock = _dopePerBlock;
1701     }
1702 
1703     // Set the migrator contract. Can only be called by the owner.
1704     function setMigrator(IMigrationMaster _migrator) public onlyOwner {
1705         migrator = _migrator;
1706     }
1707 }