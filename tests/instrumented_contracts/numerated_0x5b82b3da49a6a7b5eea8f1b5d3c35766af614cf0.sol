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
846     uint256 private _burnRate;
847     string private _name;
848     string private _symbol;
849     uint256 private _decimals;
850 
851     /**
852      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
853      * a default value of 18.
854      *
855      * To select a different value for {decimals}, use {_setupDecimals}.
856      *
857      * All three of these values are immutable: they can only be set once during
858      * construction.
859      */
860     constructor (string memory name, string memory symbol, uint256 decimals, uint256 burnrate, uint256 initSupply) public {
861         _name = name;
862         _symbol = symbol;
863         _decimals = decimals;
864         _burnRate = burnrate;
865         _totalSupply = 0;
866         _mint(msg.sender, initSupply*(10**_decimals));
867         _burnedSupply = 0;
868     }
869 
870     /**
871      * @dev Returns the name of the token.
872      */
873     function name() public view returns (string memory) {
874         return _name;
875     }
876 
877     /**
878      * @dev Returns the symbol of the token, usually a shorter version of the
879      * name.
880      */
881     function symbol() public view returns (string memory) {
882         return _symbol;
883     }
884 
885     /**
886      * @dev Returns the number of decimals used to get its user representation.
887      * For example, if `decimals` equals `2`, a balance of `505` tokens should
888      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
889      *
890      * Tokens usually opt for a value of 18, imitating the relationship between
891      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
892      * called.
893      *
894      * NOTE: This information is only used for _display_ purposes: it in
895      * no way affects any of the arithmetic of the contract, including
896      * {IERC20-balanceOf} and {IERC20-transfer}.
897      */
898     function decimals() public view returns (uint256) {
899         return _decimals;
900     }
901 
902     /**
903      * @dev See {IERC20-totalSupply}.
904      */
905     function totalSupply() public view override returns (uint256) {
906         return _totalSupply;
907     }
908 
909     /**
910      * @dev Returns the amount of burned tokens.
911      */
912     function burnedSupply() public view returns (uint256) {
913         return _burnedSupply;
914     }
915 
916     /**
917      * @dev Returns the burnrate.
918      */
919     function burnRate() public view returns (uint256) {
920         return _burnRate;
921     }
922 
923     /**
924      * @dev See {IERC20-balanceOf}.
925      */
926     function balanceOf(address account) public view override returns (uint256) {
927         return _balances[account];
928     }
929 
930     /**
931      * @dev See {IERC20-transfer}.
932      *
933      * Requirements:
934      *
935      * - `recipient` cannot be the zero address.
936      * - the caller must have a balance of at least `amount`.
937      */
938     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
939         _transfer(_msgSender(), recipient, amount);
940         return true;
941     }
942 
943     /**
944      * @dev See {IERC20-transfer}.
945      *
946      * Requirements:
947      *
948      * - `account` cannot be the zero address.
949      * - the caller must have a balance of at least `amount`.
950      */
951     function burn(uint256 amount) public virtual returns (bool) {
952         _burn(_msgSender(), amount);
953         return true;
954     }
955 
956     /**
957      * @dev See {IERC20-allowance}.
958      */
959     function allowance(address owner, address spender) public view virtual override returns (uint256) {
960         return _allowances[owner][spender];
961     }
962 
963     /**
964      * @dev See {IERC20-approve}.
965      *
966      * Requirements:
967      *
968      * - `spender` cannot be the zero address.
969      */
970     function approve(address spender, uint256 amount) public virtual override returns (bool) {
971         _approve(_msgSender(), spender, amount);
972         return true;
973     }
974 
975     /**
976      * @dev See {IERC20-transferFrom}.
977      *
978      * Emits an {Approval} event indicating the updated allowance. This is not
979      * required by the EIP. See the note at the beginning of {ERC20};
980      *
981      * Requirements:
982      * - `sender` and `recipient` cannot be the zero address.
983      * - `sender` must have a balance of at least `amount`.
984      * - the caller must have allowance for ``sender``'s tokens of at least
985      * `amount`.
986      */
987     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
988         _transfer(sender, recipient, amount);
989         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
990         return true;
991     }
992 
993     /**
994      * @dev Atomically increases the allowance granted to `spender` by the caller.
995      *
996      * This is an alternative to {approve} that can be used as a mitigation for
997      * problems described in {IERC20-approve}.
998      *
999      * Emits an {Approval} event indicating the updated allowance.
1000      *
1001      * Requirements:
1002      *
1003      * - `spender` cannot be the zero address.
1004      */
1005     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1006         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1007         return true;
1008     }
1009 
1010     /**
1011      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1012      *
1013      * This is an alternative to {approve} that can be used as a mitigation for
1014      * problems described in {IERC20-approve}.
1015      *
1016      * Emits an {Approval} event indicating the updated allowance.
1017      *
1018      * Requirements:
1019      *
1020      * - `spender` cannot be the zero address.
1021      * - `spender` must have allowance for the caller of at least
1022      * `subtractedValue`.
1023      */
1024     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1025         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1026         return true;
1027     }
1028 
1029     /**
1030      * @dev Moves tokens `amount` from `sender` to `recipient`.
1031      *
1032      * This is internal function is equivalent to {transfer}, and can be used to
1033      * e.g. implement automatic token fees, slashing mechanisms, etc.
1034      *
1035      * Emits a {Transfer} event.
1036      *
1037      * Requirements:
1038      *
1039      * - `sender` cannot be the zero address.
1040      * - `recipient` cannot be the zero address.
1041      * - `sender` must have a balance of at least `amount`.
1042      */
1043     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1044         require(sender != address(0), "ERC20: transfer from the zero address");
1045         require(recipient != address(0), "ERC20: transfer to the zero address");
1046 
1047         if (_whitelistedAddresses[sender] == true || _whitelistedAddresses[recipient] == true) {
1048             _beforeTokenTransfer(sender, recipient, amount);
1049             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1050             _balances[recipient] = _balances[recipient].add(amount);
1051             emit Transfer(sender, recipient, amount);
1052         } else {
1053             uint256 amount_burn = amount.mul(_burnRate).div(100);
1054             uint256 amount_send = amount.sub(amount_burn);
1055             require(amount == amount_send + amount_burn, "Burn value invalid");
1056             _burn(sender, amount_burn);
1057             amount = amount_send;
1058             _beforeTokenTransfer(sender, recipient, amount);
1059             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1060             _balances[recipient] = _balances[recipient].add(amount);
1061             emit Transfer(sender, recipient, amount);
1062         }
1063     }
1064 
1065     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1066      * the total supply.
1067      *
1068      * Emits a {Transfer} event with `from` set to the zero address.
1069      *
1070      * Requirements
1071      *
1072      * - `to` cannot be the zero address.
1073      * 
1074      * HINT: This function is 'internal' and therefore can only be called from another
1075      * function inside this contract!
1076      */
1077     function _mint(address account, uint256 amount) internal virtual {
1078         require(account != address(0), "ERC20: mint to the zero address");
1079         _beforeTokenTransfer(address(0), account, amount);
1080         _totalSupply = _totalSupply.add(amount);
1081         _balances[account] = _balances[account].add(amount);
1082         emit Transfer(address(0), account, amount);
1083     }
1084 
1085     /**
1086      * @dev Destroys `amount` tokens from `account`, reducing the
1087      * total supply.
1088      *
1089      * Emits a {Transfer} event with `to` set to the zero address.
1090      *
1091      * Requirements
1092      *
1093      * - `account` cannot be the zero address.
1094      * - `account` must have at least `amount` tokens.
1095      */
1096     function _burn(address account, uint256 amount) internal virtual {
1097         require(account != address(0), "ERC20: burn from the zero address");
1098         _beforeTokenTransfer(account, address(0), amount);
1099         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1100         _totalSupply = _totalSupply.sub(amount);
1101         _burnedSupply = _burnedSupply.add(amount);
1102         emit Transfer(account, address(0), amount);
1103     }
1104 
1105     /**
1106      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1107      *
1108      * This is internal function is equivalent to `approve`, and can be used to
1109      * e.g. set automatic allowances for certain subsystems, etc.
1110      *
1111      * Emits an {Approval} event.
1112      *
1113      * Requirements:
1114      *
1115      * - `owner` cannot be the zero address.
1116      * - `spender` cannot be the zero address.
1117      */
1118     function _approve(address owner, address spender, uint256 amount) internal virtual {
1119         require(owner != address(0), "ERC20: approve from the zero address");
1120         require(spender != address(0), "ERC20: approve to the zero address");
1121         _allowances[owner][spender] = amount;
1122         emit Approval(owner, spender, amount);
1123     }
1124 
1125     /**
1126      * @dev Sets {burnRate} to a value other than the initial one.
1127      */
1128     function _setupBurnrate(uint8 burnrate_) internal virtual {
1129         _burnRate = burnrate_;
1130     }
1131 
1132     /**
1133      * @dev Hook that is called before any transfer of tokens. This includes
1134      * minting and burning.
1135      *
1136      * Calling conditions:
1137      *
1138      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1139      * will be to transferred to `to`.
1140      * - when `from` is zero, `amount` tokens will be minted for `to`.
1141      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1142      * - `from` and `to` are never both zero.
1143      *
1144      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1145      */
1146     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1147 }
1148 
1149 /**
1150  * @dev Contract module which provides a basic access control mechanism, where
1151  * there is an account (an minter) that can be granted exclusive access to
1152  * specific functions.
1153  *
1154  * By default, the minter account will be the one that deploys the contract. This
1155  * can later be changed with {transferMintership}.
1156  *
1157  * This module is used through inheritance. It will make available the modifier
1158  * `onlyMinter`, which can be applied to your functions to restrict their use to
1159  * the minter.
1160  */
1161 contract Mintable is Context {
1162 
1163     /**
1164      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'minter'
1165      * this way the developer/owner stays the 'owner' and can make changes like adding a pool
1166      * at any time but cannot mint anymore as soon as the 'minter' gets changes (to the chef contract)
1167      */
1168     address private _minter;
1169 
1170     event MintershipTransferred(address indexed previousMinter, address indexed newMinter);
1171 
1172     /**
1173      * @dev Initializes the contract setting the deployer as the initial minter.
1174      */
1175     constructor () internal {
1176         address msgSender = _msgSender();
1177         _minter = msgSender;
1178         emit MintershipTransferred(address(0), msgSender);
1179     }
1180 
1181     /**
1182      * @dev Returns the address of the current minter.
1183      */
1184     function minter() public view returns (address) {
1185         return _minter;
1186     }
1187 
1188     /**
1189      * @dev Throws if called by any account other than the minter.
1190      */
1191     modifier onlyMinter() {
1192         require(_minter == _msgSender(), "Mintable: caller is not the minter");
1193         _;
1194     }
1195 
1196     /**
1197      * @dev Transfers mintership of the contract to a new account (`newMinter`).
1198      * Can only be called by the current minter.
1199      */
1200     function transferMintership(address newMinter) public virtual onlyMinter {
1201         require(newMinter != address(0), "Mintable: new minter is the zero address");
1202         emit MintershipTransferred(_minter, newMinter);
1203         _minter = newMinter;
1204     }
1205 }
1206 
1207 /*
1208 
1209 website: vox.finance
1210 
1211  _    ______ _  __   ___________   _____    _   ______________
1212 | |  / / __ \ |/ /  / ____/  _/ | / /   |  / | / / ____/ ____/
1213 | | / / / / /   /  / /_   / //  |/ / /| | /  |/ / /   / __/   
1214 | |/ / /_/ /   |_ / __/ _/ // /|  / ___ |/ /|  / /___/ /___   
1215 |___/\____/_/|_(_)_/   /___/_/ |_/_/  |_/_/ |_/\____/_____/   
1216                                                               
1217 */
1218 // VoxToken
1219 contract VoxToken is ERC20("Vox.Finance", "VOX", 18, 0, 1250), Ownable, Mintable {
1220     /// @notice Creates `_amount` token to `_to`. Must only be called by the minter (VoxMaster).
1221     function mint(address _to, uint256 _amount) public onlyMinter {
1222         _mint(_to, _amount);
1223     }
1224 
1225     function setBurnrate(uint8 burnrate_) public onlyOwner {
1226         _setupBurnrate(burnrate_);
1227     }
1228 
1229     function addWhitelistedAddress(address _address) public onlyOwner {
1230         _whitelistedAddresses[_address] = true;
1231     }
1232 
1233     function removeWhitelistedAddress(address _address) public onlyOwner {
1234         _whitelistedAddresses[_address] = false;
1235     }
1236 }
1237 
1238 /*
1239 
1240 website: vox.finance
1241 
1242  _    ______ _  __   ___________   _____    _   ______________
1243 | |  / / __ \ |/ /  / ____/  _/ | / /   |  / | / / ____/ ____/
1244 | | / / / / /   /  / /_   / //  |/ / /| | /  |/ / /   / __/   
1245 | |/ / /_/ /   |_ / __/ _/ // /|  / ___ |/ /|  / /___/ /___   
1246 |___/\____/_/|_(_)_/   /___/_/ |_/_/  |_/_/ |_/\____/_____/   
1247                                                               
1248 */
1249 // Vox Populi token for Governance.
1250 contract VoxPopuliToken is ERC20("Vox.Populi", "POPULI", 18, 0, 0), Ownable {
1251     /// @notice Creates `_amount` of tokens to `_to`. Must only be called by the minter (VoxMaster).
1252     function mint(address _to, uint256 _amount) public onlyOwner {
1253         _mint(_to, _amount);
1254     }
1255     
1256     /// @notice Burns `_amount` of tokens from `_from`. Must only be called by the minter (VoxMaster).
1257     function burn(address _from, uint256 _amount) public onlyOwner {
1258         _burn(_from, _amount);
1259     }
1260 }
1261 
1262 /*
1263 
1264 website: vox.finance
1265 
1266  _    ______ _  __   ___________   _____    _   ______________
1267 | |  / / __ \ |/ /  / ____/  _/ | / /   |  / | / / ____/ ____/
1268 | | / / / / /   /  / /_   / //  |/ / /| | /  |/ / /   / __/   
1269 | |/ / /_/ /   |_ / __/ _/ // /|  / ___ |/ /|  / /___/ /___   
1270 |___/\____/_/|_(_)_/   /___/_/ |_/_/  |_/_/ |_/\____/_____/   
1271                                                               
1272 */
1273 interface IMigrationMaster {
1274     // Perform LP token migration for swapping liquidity providers.
1275     // Take the current LP token address and return the new LP token address.
1276     // Migrator should have full access to the caller's LP token.
1277     // Return the new LP token address.
1278     //
1279     // Migrator must have allowance access to old LP tokens.
1280     // EXACTLY the same amount of new LP tokens must be minted or
1281     // else something bad will happen. This function is meant to be used to swap
1282     // to the native liquidity provider in the future (see the VOX roadmap)!
1283     function migrate(IERC20 token) external returns (IERC20);
1284 }
1285 
1286 contract VoxMaster is Ownable {
1287     using SafeMath for uint256;
1288     using SafeERC20 for IERC20;
1289 
1290     // Info of each user.
1291     struct UserInfo {
1292         uint256 amount; // How many LP tokens the user has provided.
1293         uint256 rewardDebt; // Reward debt. See explanation below.
1294         uint256 pendingRewards; // Pending rewards for user.
1295         //
1296         // We do some fancy math here. Basically, any point in time, the amount of VOXs
1297         // entitled to a user but is pending to be distributed is:
1298         //
1299         //   pending reward = (user.amount * pool.accVoxPerShare) - user.rewardDebt
1300         //
1301         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1302         //   1. The pool's `accVoxPerShare` (and `lastRewardBlock`) gets updated.
1303         //   2. User receives the pending reward sent to his/her address.
1304         //   3. User's `amount` gets updated.
1305         //   4. User's `rewardDebt` gets updated.
1306     }
1307 
1308     // Info of each pool.
1309     struct PoolInfo {
1310         IERC20 lpToken; // Address of LP token contract.
1311         uint256 allocPoint; // How many allocation points assigned to this pool. VOXs to distribute per block.
1312         uint256 lastRewardBlock; // Last block number that VOXs distribution occurs.
1313         uint256 accVoxPerShare; // Accumulated VOXs per share, times 1e12. See below.
1314     }
1315 
1316     // VOX token
1317     VoxToken public vox;
1318     // POPULI token
1319     VoxPopuliToken public populi;
1320     // Dev fund (4%, initially)
1321     uint256 public devFundDivRate = 25;
1322     // Dev address.
1323     address public devaddr;
1324     // Block number when bonus VOX period ends.
1325     uint256 public bonusEndBlock;
1326     // VOX tokens created per block.
1327     uint256 public voxPerBlock;
1328     // Bonus muliplier for early vox liquidity providers.
1329     uint256 public BONUS_MULTIPLIER = 1;
1330     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1331     IMigrationMaster public migrator;
1332 
1333     // Info of each pool.
1334     PoolInfo[] public poolInfo;
1335     // Info of each user that stakes LP tokens.
1336     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1337     // Total allocation points. Must be the sum of all allocation points in all pools.
1338     uint256 public totalAllocPoint = 0;
1339     // The block number when VOX mining starts.
1340     uint256 public startBlock;
1341 
1342     // Events
1343     event Recovered(address token, uint256 amount);
1344     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1345     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1346     event Claim(address indexed user, uint256 indexed pid, uint256 amount);
1347     event ClaimAndStake(address indexed user, uint256 indexed pid, uint256 amount);
1348     event EmergencyWithdraw(
1349         address indexed user,
1350         uint256 indexed pid,
1351         uint256 amount
1352     );
1353 
1354     constructor(
1355         VoxToken _vox,
1356         VoxPopuliToken _populi,
1357         address _devaddr,
1358         uint256 _voxPerBlock,
1359         uint256 _startBlock,
1360         uint256 _bonusEndBlock
1361     ) public {
1362         vox = _vox;
1363         populi = _populi;
1364         devaddr = _devaddr;
1365         voxPerBlock = _voxPerBlock;
1366         bonusEndBlock = _bonusEndBlock;
1367         startBlock = _startBlock;
1368 
1369         // staking pool
1370         poolInfo.push(PoolInfo({
1371             lpToken: _vox,
1372             allocPoint: 1000,
1373             lastRewardBlock: startBlock,
1374             accVoxPerShare: 0
1375         }));
1376 
1377         totalAllocPoint = 1000;
1378     }
1379 
1380     function poolLength() external view returns (uint256) {
1381         return poolInfo.length;
1382     }
1383 
1384     // Return reward multiplier over the given _from to _to block.
1385     function getMultiplier(uint256 _from, uint256 _to)
1386         public
1387         view
1388         returns (uint256)
1389     {
1390         if (_to <= bonusEndBlock) {
1391             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1392         } else if (_from >= bonusEndBlock) {
1393             return _to.sub(_from);
1394         } else {
1395             return
1396                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1397                     _to.sub(bonusEndBlock)
1398                 );
1399         }
1400     }
1401 
1402     // Add a new lp to the pool. Can only be called by the owner.
1403     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1404     function add(
1405         uint256 _allocPoint,
1406         IERC20 _lpToken,
1407         bool _withUpdate
1408     ) public onlyOwner {
1409         if (_withUpdate) {
1410             massUpdatePools();
1411         }
1412         uint256 lastRewardBlock = block.number > startBlock
1413             ? block.number
1414             : startBlock;
1415         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1416         poolInfo.push(
1417             PoolInfo({
1418                 lpToken: _lpToken,
1419                 allocPoint: _allocPoint,
1420                 lastRewardBlock: lastRewardBlock,
1421                 accVoxPerShare: 0
1422             })
1423         );
1424         updateStakingPool();
1425     }
1426 
1427     // Update the given pool's VOX allocation point. Can only be called by the owner.
1428     function set(
1429         uint256 _pid,
1430         uint256 _allocPoint,
1431         bool _withUpdate
1432     ) public onlyOwner {
1433         if (_withUpdate) {
1434             massUpdatePools();
1435         }
1436         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1437             _allocPoint
1438         );
1439         uint256 prevAllocPoint = poolInfo[_pid].allocPoint;
1440         poolInfo[_pid].allocPoint = _allocPoint;
1441         if (prevAllocPoint != _allocPoint) {
1442             updateStakingPool();
1443         }
1444     }
1445 
1446     function updateStakingPool() internal {
1447         uint256 length = poolInfo.length;
1448         uint256 points = 0;
1449         for (uint256 pid = 1; pid < length; ++pid) {
1450             points = points.add(poolInfo[pid].allocPoint);
1451         }
1452         if (points != 0) {
1453             points = points.div(3);
1454             totalAllocPoint = totalAllocPoint.sub(poolInfo[0].allocPoint).add(points);
1455             poolInfo[0].allocPoint = points;
1456         }
1457     }
1458 
1459     // Migrate lp token to another lp contract. Can be called by anyone. 
1460     // We trust that migrator contract is good.
1461     function migrate(uint256 _pid) public {
1462         require(address(migrator) != address(0), "migrate: no migrator");
1463         PoolInfo storage pool = poolInfo[_pid];
1464         IERC20 lpToken = pool.lpToken;
1465         uint256 bal = lpToken.balanceOf(address(this));
1466         lpToken.safeApprove(address(migrator), bal);
1467         IERC20 newLpToken = migrator.migrate(lpToken);
1468         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1469         pool.lpToken = newLpToken;
1470     }
1471 
1472     // View function to see pending VOXs on frontend.
1473     function pendingVox(uint256 _pid, address _user)
1474         external
1475         view
1476         returns (uint256)
1477     {
1478         PoolInfo storage pool = poolInfo[_pid];
1479         UserInfo storage user = userInfo[_pid][_user];
1480         uint256 accVoxPerShare = pool.accVoxPerShare;
1481         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1482         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1483             uint256 multiplier = getMultiplier(
1484                 pool.lastRewardBlock,
1485                 block.number
1486             );
1487             uint256 voxReward = multiplier
1488                 .mul(voxPerBlock)
1489                 .mul(pool.allocPoint)
1490                 .div(totalAllocPoint);
1491             accVoxPerShare = accVoxPerShare.add(
1492                 voxReward.mul(1e12).div(lpSupply)
1493             );
1494         }
1495         return
1496             user.amount.mul(accVoxPerShare).div(1e12).sub(user.rewardDebt).add(user.pendingRewards);
1497     }
1498 
1499     // Update reward vairables for all pools. Be careful of gas spending!
1500     function massUpdatePools() public {
1501         uint256 length = poolInfo.length;
1502         for (uint256 pid = 0; pid < length; ++pid) {
1503             updatePool(pid);
1504         }
1505     }
1506 
1507     // Update reward variables of the given pool to be up-to-date.
1508     function updatePool(uint256 _pid) public {
1509         PoolInfo storage pool = poolInfo[_pid];
1510         if (block.number <= pool.lastRewardBlock) {
1511             return;
1512         }
1513         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1514         if (lpSupply == 0) {
1515             pool.lastRewardBlock = block.number;
1516             return;
1517         }
1518         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1519         uint256 voxReward = multiplier
1520             .mul(voxPerBlock)
1521             .mul(pool.allocPoint)
1522             .div(totalAllocPoint);
1523         vox.mint(devaddr, voxReward.div(devFundDivRate));
1524         vox.mint(address(this), voxReward);
1525         pool.accVoxPerShare = pool.accVoxPerShare.add(
1526             voxReward.mul(1e12).div(lpSupply)
1527         );
1528         pool.lastRewardBlock = block.number;
1529     }
1530 
1531     // Deposit LP tokens to VoxMaster for VOX allocation.
1532     function deposit(uint256 _pid, uint256 _amount, bool _withdrawRewards) public {
1533         require (_pid != 0, 'please deposit VOX by staking');
1534         PoolInfo storage pool = poolInfo[_pid];
1535         UserInfo storage user = userInfo[_pid][msg.sender];
1536         updatePool(_pid);
1537         if (user.amount > 0) {
1538             uint256 pending = user
1539                 .amount
1540                 .mul(pool.accVoxPerShare)
1541                 .div(1e12)
1542                 .sub(user.rewardDebt);
1543             
1544             if (pending > 0) {
1545                 user.pendingRewards = user.pendingRewards.add(pending);
1546 
1547                 if (_withdrawRewards) {
1548                     safeVoxTransfer(msg.sender, user.pendingRewards);
1549                     emit Claim(msg.sender, _pid, user.pendingRewards);
1550                     user.pendingRewards = 0;
1551                 }
1552             }
1553         }
1554         if (_amount > 0) {
1555             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1556             user.amount = user.amount.add(_amount);
1557         }
1558         user.rewardDebt = user.amount.mul(pool.accVoxPerShare).div(1e12);
1559         emit Deposit(msg.sender, _pid, _amount);
1560     }
1561 
1562     // Withdraw LP tokens from VoxMaster.
1563     function withdraw(uint256 _pid, uint256 _amount, bool _withdrawRewards) public {
1564         require (_pid != 0, 'please withdraw VOX by unstaking');
1565         PoolInfo storage pool = poolInfo[_pid];
1566         UserInfo storage user = userInfo[_pid][msg.sender];
1567         require(user.amount >= _amount, "withdraw: not good");
1568         updatePool(_pid);
1569         uint256 pending = user.amount.mul(pool.accVoxPerShare).div(1e12).sub(user.rewardDebt);
1570         if (pending > 0) {
1571             user.pendingRewards = user.pendingRewards.add(pending);
1572 
1573             if (_withdrawRewards) {
1574                 safeVoxTransfer(msg.sender, user.pendingRewards);
1575                 emit Claim(msg.sender, _pid, user.pendingRewards);
1576                 user.pendingRewards = 0;
1577             }
1578         }
1579         if (_amount > 0) {
1580             user.amount = user.amount.sub(_amount);
1581             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1582         }
1583         user.rewardDebt = user.amount.mul(pool.accVoxPerShare).div(1e12);
1584         emit Withdraw(msg.sender, _pid, _amount);
1585     }
1586 
1587     // Withdraw without caring about rewards. EMERGENCY ONLY.
1588     function emergencyWithdraw(uint256 _pid) public {
1589         require (_pid != 0, 'please withdraw VOX by unstaking');
1590         PoolInfo storage pool = poolInfo[_pid];
1591         UserInfo storage user = userInfo[_pid][msg.sender];
1592         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1593         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1594         user.amount = 0;
1595         user.rewardDebt = 0;
1596         user.pendingRewards = 0;
1597     }
1598 
1599     // Claim rewards from VoxMaster.
1600     function claim(uint256 _pid) public {
1601         require (_pid != 0, 'please claim staking rewards on stake page');
1602         PoolInfo storage pool = poolInfo[_pid];
1603         UserInfo storage user = userInfo[_pid][msg.sender];
1604         updatePool(_pid);
1605         uint256 pending = user.amount.mul(pool.accVoxPerShare).div(1e12).sub(user.rewardDebt);
1606         if (pending > 0 || user.pendingRewards > 0) {
1607             user.pendingRewards = user.pendingRewards.add(pending);
1608             safeVoxTransfer(msg.sender, user.pendingRewards);
1609             emit Claim(msg.sender, _pid, user.pendingRewards);
1610             user.pendingRewards = 0;
1611         }
1612         user.rewardDebt = user.amount.mul(pool.accVoxPerShare).div(1e12);
1613     }
1614 
1615     // Claim rewards from VoxMaster and deposit them directly to staking pool.
1616     function claimAndStake(uint256 _pid) public {
1617         require (_pid != 0, 'please claim and stake staking rewards on stake page');
1618         PoolInfo storage pool = poolInfo[_pid];
1619         UserInfo storage user = userInfo[_pid][msg.sender];
1620         updatePool(_pid);
1621         uint256 pending = user.amount.mul(pool.accVoxPerShare).div(1e12).sub(user.rewardDebt);
1622         if (pending > 0 || user.pendingRewards > 0) {
1623             user.pendingRewards = user.pendingRewards.add(pending);
1624             transferToStake(user.pendingRewards);
1625             emit ClaimAndStake(msg.sender, _pid, user.pendingRewards);
1626             user.pendingRewards = 0;
1627         }
1628         user.rewardDebt = user.amount.mul(pool.accVoxPerShare).div(1e12);
1629     }
1630 
1631     // Transfer rewards from LP pools to staking pool.
1632     function transferToStake(uint256 _amount) internal {
1633         PoolInfo storage pool = poolInfo[0];
1634         UserInfo storage user = userInfo[0][msg.sender];
1635         updatePool(0);
1636         if (user.amount > 0) {
1637             uint256 pending = user.amount.mul(pool.accVoxPerShare).div(1e12).sub(user.rewardDebt);
1638             if (pending > 0) {
1639                 user.pendingRewards = user.pendingRewards.add(pending);
1640             }
1641         }
1642         if (_amount > 0) {
1643             user.amount = user.amount.add(_amount);
1644         }
1645         user.rewardDebt = user.amount.mul(pool.accVoxPerShare).div(1e12);
1646 
1647         populi.mint(msg.sender, _amount);
1648         emit Deposit(msg.sender, 0, _amount);
1649     }
1650 
1651     // Stake VOX tokens to VoxMaster.
1652     function enterStaking(uint256 _amount, bool _withdrawRewards) public {
1653         PoolInfo storage pool = poolInfo[0];
1654         UserInfo storage user = userInfo[0][msg.sender];
1655         updatePool(0);
1656         if (user.amount > 0) {
1657             uint256 pending = user.amount.mul(pool.accVoxPerShare).div(1e12).sub(user.rewardDebt);
1658             if (pending > 0) {
1659                 user.pendingRewards = user.pendingRewards.add(pending);
1660 
1661                 if (_withdrawRewards) {
1662                     safeVoxTransfer(msg.sender, user.pendingRewards);
1663                     user.pendingRewards = 0;
1664                 }
1665             }
1666         }
1667         if (_amount > 0) {
1668             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1669             user.amount = user.amount.add(_amount);
1670         }
1671         user.rewardDebt = user.amount.mul(pool.accVoxPerShare).div(1e12);
1672 
1673         populi.mint(msg.sender, _amount);
1674         emit Deposit(msg.sender, 0, _amount);
1675     }
1676 
1677     // Withdraw VOX tokens from staking.
1678     function leaveStaking(uint256 _amount, bool _withdrawRewards) public {
1679         PoolInfo storage pool = poolInfo[0];
1680         UserInfo storage user = userInfo[0][msg.sender];
1681         require(user.amount >= _amount, "unstake: not good");
1682         require(populi.balanceOf(msg.sender) >= _amount, "unstake: not enough POPULI tokens");
1683         updatePool(0);
1684         uint256 pending = user.amount.mul(pool.accVoxPerShare).div(1e12).sub(user.rewardDebt);
1685         if (pending > 0) {
1686                 user.pendingRewards = user.pendingRewards.add(pending);
1687 
1688                 if (_withdrawRewards) {
1689                     safeVoxTransfer(msg.sender, user.pendingRewards);
1690                     user.pendingRewards = 0;
1691                 }
1692             }
1693         if (_amount > 0) {
1694             user.amount = user.amount.sub(_amount);
1695             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1696         }
1697         user.rewardDebt = user.amount.mul(pool.accVoxPerShare).div(1e12);
1698 
1699         populi.burn(msg.sender, _amount);
1700         emit Withdraw(msg.sender, 0, _amount);
1701     }
1702 
1703     // Claim staking rewards from VoxMaster.
1704     function claimStaking() public {
1705         PoolInfo storage pool = poolInfo[0];
1706         UserInfo storage user = userInfo[0][msg.sender];
1707         updatePool(0);
1708         uint256 pending = user.amount.mul(pool.accVoxPerShare).div(1e12).sub(user.rewardDebt);
1709         if (pending > 0 || user.pendingRewards > 0) {
1710             user.pendingRewards = user.pendingRewards.add(pending);
1711             safeVoxTransfer(msg.sender, user.pendingRewards);
1712             emit Claim(msg.sender, 0, user.pendingRewards);
1713             user.pendingRewards = 0;
1714         }
1715         user.rewardDebt = user.amount.mul(pool.accVoxPerShare).div(1e12);
1716     }
1717 
1718     // Transfer staking rewards to staking pool.
1719     function stakeRewardsStaking() public {
1720         PoolInfo storage pool = poolInfo[0];
1721         UserInfo storage user = userInfo[0][msg.sender];
1722         uint256 rewardsToStake;
1723         updatePool(0);
1724         if (user.amount > 0) {
1725             uint256 pending = user.amount.mul(pool.accVoxPerShare).div(1e12).sub(user.rewardDebt);
1726             if (pending > 0) {
1727                 user.pendingRewards = user.pendingRewards.add(pending);
1728             }
1729         }
1730         if (user.pendingRewards > 0) {
1731             rewardsToStake = user.pendingRewards;
1732             user.pendingRewards = 0;
1733             user.amount = user.amount.add(rewardsToStake);
1734         }
1735         user.rewardDebt = user.amount.mul(pool.accVoxPerShare).div(1e12);
1736 
1737         populi.mint(msg.sender, rewardsToStake);
1738         emit Deposit(msg.sender, 0, rewardsToStake);
1739     }
1740 
1741     // Safe vox transfer function, just in case if rounding error causes pool to not have enough VOXs.
1742     function safeVoxTransfer(address _to, uint256 _amount) internal {
1743         uint256 voxBal = vox.balanceOf(address(this));
1744         if (_amount > voxBal) {
1745             vox.transfer(_to, voxBal);
1746         } else {
1747             vox.transfer(_to, _amount);
1748         }
1749     }
1750 
1751     // Update dev address by the previous dev.
1752     function setDevAddr(address _devaddr) public {
1753         require(msg.sender == devaddr, "!dev: nice try, amigo");
1754         devaddr = _devaddr;
1755     }
1756 
1757     // **** Additional functions to edit master attributes ****
1758 
1759     function setVoxPerBlock(uint256 _voxPerBlock) public onlyOwner {
1760         require(_voxPerBlock > 0, "!voxPerBlock-0");
1761         voxPerBlock = _voxPerBlock;
1762     }
1763 
1764     function setBonusMultiplier(uint256 _bonusMultiplier) public onlyOwner {
1765         require(_bonusMultiplier > 0, "!bonusMultiplier-0");
1766         BONUS_MULTIPLIER = _bonusMultiplier;
1767     }
1768 
1769     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1770         bonusEndBlock = _bonusEndBlock;
1771     }
1772 
1773     // Set the migrator contract. Can only be called by the owner.
1774     function setMigrator(IMigrationMaster _migrator) public onlyOwner {
1775         migrator = _migrator;
1776     }
1777 
1778     function setDevFundDivRate(uint256 _devFundDivRate) public onlyOwner {
1779         require(_devFundDivRate > 0, "!devFundDivRate-0");
1780         devFundDivRate = _devFundDivRate;
1781     }
1782 }