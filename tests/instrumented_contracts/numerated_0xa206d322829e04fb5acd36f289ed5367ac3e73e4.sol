1 pragma solidity 0.6.12;
2 
3 
4 // SPDX-License-Identifier: MIT
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
95      * @dev Returns the addition of two unsigned integers, with an overflow flag.
96      *
97      * _Available since v3.4._
98      */
99     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
100         uint256 c = a + b;
101         if (c < a) return (false, 0);
102         return (true, c);
103     }
104 
105     /**
106      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
107      *
108      * _Available since v3.4._
109      */
110     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         if (b > a) return (false, 0);
112         return (true, a - b);
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
117      *
118      * _Available since v3.4._
119      */
120     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
121         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
122         // benefit is lost if 'b' is also tested.
123         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
124         if (a == 0) return (true, 0);
125         uint256 c = a * b;
126         if (c / a != b) return (false, 0);
127         return (true, c);
128     }
129 
130     /**
131      * @dev Returns the division of two unsigned integers, with a division by zero flag.
132      *
133      * _Available since v3.4._
134      */
135     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
136         if (b == 0) return (false, 0);
137         return (true, a / b);
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         if (b == 0) return (false, 0);
147         return (true, a % b);
148     }
149 
150     /**
151      * @dev Returns the addition of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `+` operator.
155      *
156      * Requirements:
157      *
158      * - Addition cannot overflow.
159      */
160     function add(uint256 a, uint256 b) internal pure returns (uint256) {
161         uint256 c = a + b;
162         require(c >= a, "SafeMath: addition overflow");
163         return c;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         require(b <= a, "SafeMath: subtraction overflow");
178         return a - b;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      *
189      * - Multiplication cannot overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         if (a == 0) return 0;
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers, reverting on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b > 0, "SafeMath: division by zero");
212         return a / b;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * reverting when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
228         require(b > 0, "SafeMath: modulo by zero");
229         return a % b;
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
234      * overflow (when the result is negative).
235      *
236      * CAUTION: This function is deprecated because it requires allocating memory for the error
237      * message unnecessarily. For custom revert reasons use {trySub}.
238      *
239      * Counterpart to Solidity's `-` operator.
240      *
241      * Requirements:
242      *
243      * - Subtraction cannot overflow.
244      */
245     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b <= a, errorMessage);
247         return a - b;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
252      * division by zero. The result is rounded towards zero.
253      *
254      * CAUTION: This function is deprecated because it requires allocating memory for the error
255      * message unnecessarily. For custom revert reasons use {tryDiv}.
256      *
257      * Counterpart to Solidity's `/` operator. Note: this function uses a
258      * `revert` opcode (which leaves remaining gas untouched) while Solidity
259      * uses an invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b > 0, errorMessage);
267         return a / b;
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * reverting with custom message when dividing by zero.
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {tryMod}.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b > 0, errorMessage);
287         return a % b;
288     }
289 }
290 
291 
292 /**
293  * @dev Collection of functions related to the address type
294  */
295 library Address {
296     /**
297      * @dev Returns true if `account` is a contract.
298      *
299      * [IMPORTANT]
300      * ====
301      * It is unsafe to assume that an address for which this function returns
302      * false is an externally-owned account (EOA) and not a contract.
303      *
304      * Among others, `isContract` will return false for the following
305      * types of addresses:
306      *
307      *  - an externally-owned account
308      *  - a contract in construction
309      *  - an address where a contract will be created
310      *  - an address where a contract lived, but was destroyed
311      * ====
312      */
313     function isContract(address account) internal view returns (bool) {
314         // This method relies on extcodesize, which returns 0 for contracts in
315         // construction, since the code is only stored at the end of the
316         // constructor execution.
317 
318         uint256 size;
319         // solhint-disable-next-line no-inline-assembly
320         assembly { size := extcodesize(account) }
321         return size > 0;
322     }
323 
324     /**
325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
326      * `recipient`, forwarding all available gas and reverting on errors.
327      *
328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
330      * imposed by `transfer`, making them unable to receive funds via
331      * `transfer`. {sendValue} removes this limitation.
332      *
333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
334      *
335      * IMPORTANT: because control is transferred to `recipient`, care must be
336      * taken to not create reentrancy vulnerabilities. Consider using
337      * {ReentrancyGuard} or the
338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
339      */
340     function sendValue(address payable recipient, uint256 amount) internal {
341         require(address(this).balance >= amount, "Address: insufficient balance");
342 
343         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
344         (bool success, ) = recipient.call{ value: amount }("");
345         require(success, "Address: unable to send value, recipient may have reverted");
346     }
347 
348     /**
349      * @dev Performs a Solidity function call using a low level `call`. A
350      * plain`call` is an unsafe replacement for a function call: use this
351      * function instead.
352      *
353      * If `target` reverts with a revert reason, it is bubbled up by this
354      * function (like regular Solidity function calls).
355      *
356      * Returns the raw returned data. To convert to the expected return value,
357      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
358      *
359      * Requirements:
360      *
361      * - `target` must be a contract.
362      * - calling `target` with `data` must not revert.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
367       return functionCall(target, data, "Address: low-level call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
372      * `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, 0, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but also transferring `value` wei to `target`.
383      *
384      * Requirements:
385      *
386      * - the calling contract must have an ETH balance of at least `value`.
387      * - the called Solidity function must be `payable`.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
392         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
397      * with `errorMessage` as a fallback revert reason when `target` reverts.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
402         require(address(this).balance >= value, "Address: insufficient balance for call");
403         require(isContract(target), "Address: call to non-contract");
404 
405         // solhint-disable-next-line avoid-low-level-calls
406         (bool success, bytes memory returndata) = target.call{ value: value }(data);
407         return _verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
417         return functionStaticCall(target, data, "Address: low-level static call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
427         require(isContract(target), "Address: static call to non-contract");
428 
429         // solhint-disable-next-line avoid-low-level-calls
430         (bool success, bytes memory returndata) = target.staticcall(data);
431         return _verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
441         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
451         require(isContract(target), "Address: delegate call to non-contract");
452 
453         // solhint-disable-next-line avoid-low-level-calls
454         (bool success, bytes memory returndata) = target.delegatecall(data);
455         return _verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
459         if (success) {
460             return returndata;
461         } else {
462             // Look for revert reason and bubble it up if present
463             if (returndata.length > 0) {
464                 // The easiest way to bubble the revert reason is using memory via assembly
465 
466                 // solhint-disable-next-line no-inline-assembly
467                 assembly {
468                     let returndata_size := mload(returndata)
469                     revert(add(32, returndata), returndata_size)
470                 }
471             } else {
472                 revert(errorMessage);
473             }
474         }
475     }
476 }
477 
478 
479 /**
480  * @title SafeERC20
481  * @dev Wrappers around ERC20 operations that throw on failure (when the token
482  * contract returns false). Tokens that return no value (and instead revert or
483  * throw on failure) are also supported, non-reverting calls are assumed to be
484  * successful.
485  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
486  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
487  */
488 library SafeERC20 {
489     using SafeMath for uint256;
490     using Address for address;
491 
492     function safeTransfer(IERC20 token, address to, uint256 value) internal {
493         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
494     }
495 
496     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
497         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
498     }
499 
500     /**
501      * @dev Deprecated. This function has issues similar to the ones found in
502      * {IERC20-approve}, and its usage is discouraged.
503      *
504      * Whenever possible, use {safeIncreaseAllowance} and
505      * {safeDecreaseAllowance} instead.
506      */
507     function safeApprove(IERC20 token, address spender, uint256 value) internal {
508         // safeApprove should only be called when setting an initial allowance,
509         // or when resetting it to zero. To increase and decrease it, use
510         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
511         // solhint-disable-next-line max-line-length
512         require((value == 0) || (token.allowance(address(this), spender) == 0),
513             "SafeERC20: approve from non-zero to non-zero allowance"
514         );
515         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
516     }
517 
518     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
519         uint256 newAllowance = token.allowance(address(this), spender).add(value);
520         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
521     }
522 
523     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
524         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
525         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
526     }
527 
528     /**
529      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
530      * on the return value: the return value is optional (but if data is returned, it must not be false).
531      * @param token The token targeted by the call.
532      * @param data The call data (encoded using abi.encode or one of its variants).
533      */
534     function _callOptionalReturn(IERC20 token, bytes memory data) private {
535         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
536         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
537         // the target address contains contract code and also asserts for success in the low-level call.
538 
539         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
540         if (returndata.length > 0) { // Return data is optional
541             // solhint-disable-next-line max-line-length
542             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
543         }
544     }
545 }
546 
547 
548 /**
549  * @dev Library for managing
550  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
551  * types.
552  *
553  * Sets have the following properties:
554  *
555  * - Elements are added, removed, and checked for existence in constant time
556  * (O(1)).
557  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
558  *
559  * ```
560  * contract Example {
561  *     // Add the library methods
562  *     using EnumerableSet for EnumerableSet.AddressSet;
563  *
564  *     // Declare a set state variable
565  *     EnumerableSet.AddressSet private mySet;
566  * }
567  * ```
568  *
569  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
570  * and `uint256` (`UintSet`) are supported.
571  */
572 library EnumerableSet {
573     // To implement this library for multiple types with as little code
574     // repetition as possible, we write it in terms of a generic Set type with
575     // bytes32 values.
576     // The Set implementation uses private functions, and user-facing
577     // implementations (such as AddressSet) are just wrappers around the
578     // underlying Set.
579     // This means that we can only create new EnumerableSets for types that fit
580     // in bytes32.
581 
582     struct Set {
583         // Storage of set values
584         bytes32[] _values;
585 
586         // Position of the value in the `values` array, plus 1 because index 0
587         // means a value is not in the set.
588         mapping (bytes32 => uint256) _indexes;
589     }
590 
591     /**
592      * @dev Add a value to a set. O(1).
593      *
594      * Returns true if the value was added to the set, that is if it was not
595      * already present.
596      */
597     function _add(Set storage set, bytes32 value) private returns (bool) {
598         if (!_contains(set, value)) {
599             set._values.push(value);
600             // The value is stored at length-1, but we add 1 to all indexes
601             // and use 0 as a sentinel value
602             set._indexes[value] = set._values.length;
603             return true;
604         } else {
605             return false;
606         }
607     }
608 
609     /**
610      * @dev Removes a value from a set. O(1).
611      *
612      * Returns true if the value was removed from the set, that is if it was
613      * present.
614      */
615     function _remove(Set storage set, bytes32 value) private returns (bool) {
616         // We read and store the value's index to prevent multiple reads from the same storage slot
617         uint256 valueIndex = set._indexes[value];
618 
619         if (valueIndex != 0) { // Equivalent to contains(set, value)
620             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
621             // the array, and then remove the last element (sometimes called as 'swap and pop').
622             // This modifies the order of the array, as noted in {at}.
623 
624             uint256 toDeleteIndex = valueIndex - 1;
625             uint256 lastIndex = set._values.length - 1;
626 
627             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
628             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
629 
630             bytes32 lastvalue = set._values[lastIndex];
631 
632             // Move the last value to the index where the value to delete is
633             set._values[toDeleteIndex] = lastvalue;
634             // Update the index for the moved value
635             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
636 
637             // Delete the slot where the moved value was stored
638             set._values.pop();
639 
640             // Delete the index for the deleted slot
641             delete set._indexes[value];
642 
643             return true;
644         } else {
645             return false;
646         }
647     }
648 
649     /**
650      * @dev Returns true if the value is in the set. O(1).
651      */
652     function _contains(Set storage set, bytes32 value) private view returns (bool) {
653         return set._indexes[value] != 0;
654     }
655 
656     /**
657      * @dev Returns the number of values on the set. O(1).
658      */
659     function _length(Set storage set) private view returns (uint256) {
660         return set._values.length;
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
673     function _at(Set storage set, uint256 index) private view returns (bytes32) {
674         require(set._values.length > index, "EnumerableSet: index out of bounds");
675         return set._values[index];
676     }
677 
678     // Bytes32Set
679 
680     struct Bytes32Set {
681         Set _inner;
682     }
683 
684     /**
685      * @dev Add a value to a set. O(1).
686      *
687      * Returns true if the value was added to the set, that is if it was not
688      * already present.
689      */
690     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
691         return _add(set._inner, value);
692     }
693 
694     /**
695      * @dev Removes a value from a set. O(1).
696      *
697      * Returns true if the value was removed from the set, that is if it was
698      * present.
699      */
700     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
701         return _remove(set._inner, value);
702     }
703 
704     /**
705      * @dev Returns true if the value is in the set. O(1).
706      */
707     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
708         return _contains(set._inner, value);
709     }
710 
711     /**
712      * @dev Returns the number of values in the set. O(1).
713      */
714     function length(Bytes32Set storage set) internal view returns (uint256) {
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
728     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
729         return _at(set._inner, index);
730     }
731 
732     // AddressSet
733 
734     struct AddressSet {
735         Set _inner;
736     }
737 
738     /**
739      * @dev Add a value to a set. O(1).
740      *
741      * Returns true if the value was added to the set, that is if it was not
742      * already present.
743      */
744     function add(AddressSet storage set, address value) internal returns (bool) {
745         return _add(set._inner, bytes32(uint256(uint160(value))));
746     }
747 
748     /**
749      * @dev Removes a value from a set. O(1).
750      *
751      * Returns true if the value was removed from the set, that is if it was
752      * present.
753      */
754     function remove(AddressSet storage set, address value) internal returns (bool) {
755         return _remove(set._inner, bytes32(uint256(uint160(value))));
756     }
757 
758     /**
759      * @dev Returns true if the value is in the set. O(1).
760      */
761     function contains(AddressSet storage set, address value) internal view returns (bool) {
762         return _contains(set._inner, bytes32(uint256(uint160(value))));
763     }
764 
765     /**
766      * @dev Returns the number of values in the set. O(1).
767      */
768     function length(AddressSet storage set) internal view returns (uint256) {
769         return _length(set._inner);
770     }
771 
772    /**
773     * @dev Returns the value stored at position `index` in the set. O(1).
774     *
775     * Note that there are no guarantees on the ordering of values inside the
776     * array, and it may change when more values are added or removed.
777     *
778     * Requirements:
779     *
780     * - `index` must be strictly less than {length}.
781     */
782     function at(AddressSet storage set, uint256 index) internal view returns (address) {
783         return address(uint160(uint256(_at(set._inner, index))));
784     }
785 
786 
787     // UintSet
788 
789     struct UintSet {
790         Set _inner;
791     }
792 
793     /**
794      * @dev Add a value to a set. O(1).
795      *
796      * Returns true if the value was added to the set, that is if it was not
797      * already present.
798      */
799     function add(UintSet storage set, uint256 value) internal returns (bool) {
800         return _add(set._inner, bytes32(value));
801     }
802 
803     /**
804      * @dev Removes a value from a set. O(1).
805      *
806      * Returns true if the value was removed from the set, that is if it was
807      * present.
808      */
809     function remove(UintSet storage set, uint256 value) internal returns (bool) {
810         return _remove(set._inner, bytes32(value));
811     }
812 
813     /**
814      * @dev Returns true if the value is in the set. O(1).
815      */
816     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
817         return _contains(set._inner, bytes32(value));
818     }
819 
820     /**
821      * @dev Returns the number of values on the set. O(1).
822      */
823     function length(UintSet storage set) internal view returns (uint256) {
824         return _length(set._inner);
825     }
826 
827    /**
828     * @dev Returns the value stored at position `index` in the set. O(1).
829     *
830     * Note that there are no guarantees on the ordering of values inside the
831     * array, and it may change when more values are added or removed.
832     *
833     * Requirements:
834     *
835     * - `index` must be strictly less than {length}.
836     */
837     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
838         return uint256(_at(set._inner, index));
839     }
840 }
841 
842 
843 /*
844  * @dev Provides information about the current execution context, including the
845  * sender of the transaction and its data. While these are generally available
846  * via msg.sender and msg.data, they should not be accessed in such a direct
847  * manner, since when dealing with GSN meta-transactions the account sending and
848  * paying for execution may not be the actual sender (as far as an application
849  * is concerned).
850  *
851  * This contract is only required for intermediate, library-like contracts.
852  */
853 abstract contract Context {
854     function _msgSender() internal view virtual returns (address payable) {
855         return msg.sender;
856     }
857 
858     function _msgData() internal view virtual returns (bytes memory) {
859         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
860         return msg.data;
861     }
862 }
863 
864 
865 /**
866  * @dev Contract module which provides a basic access control mechanism, where
867  * there is an account (an owner) that can be granted exclusive access to
868  * specific functions.
869  *
870  * By default, the owner account will be the one that deploys the contract. This
871  * can later be changed with {transferOwnership}.
872  *
873  * This module is used through inheritance. It will make available the modifier
874  * `onlyOwner`, which can be applied to your functions to restrict their use to
875  * the owner.
876  */
877 abstract contract Ownable is Context {
878     address private _owner;
879 
880     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
881 
882     /**
883      * @dev Initializes the contract setting the deployer as the initial owner.
884      */
885     constructor () internal {
886         address msgSender = _msgSender();
887         _owner = msgSender;
888         emit OwnershipTransferred(address(0), msgSender);
889     }
890 
891     /**
892      * @dev Returns the address of the current owner.
893      */
894     function owner() public view virtual returns (address) {
895         return _owner;
896     }
897 
898     /**
899      * @dev Throws if called by any account other than the owner.
900      */
901     modifier onlyOwner() {
902         require(owner() == _msgSender(), "Ownable: caller is not the owner");
903         _;
904     }
905 
906     /**
907      * @dev Leaves the contract without owner. It will not be possible to call
908      * `onlyOwner` functions anymore. Can only be called by the current owner.
909      *
910      * NOTE: Renouncing ownership will leave the contract without an owner,
911      * thereby removing any functionality that is only available to the owner.
912      */
913     function renounceOwnership() public virtual onlyOwner {
914         emit OwnershipTransferred(_owner, address(0));
915         _owner = address(0);
916     }
917 
918     /**
919      * @dev Transfers ownership of the contract to a new account (`newOwner`).
920      * Can only be called by the current owner.
921      */
922     function transferOwnership(address newOwner) public virtual onlyOwner {
923         require(newOwner != address(0), "Ownable: new owner is the zero address");
924         emit OwnershipTransferred(_owner, newOwner);
925         _owner = newOwner;
926     }
927 }
928 
929 
930 interface IKumaDexToken {
931     function balanceOf(address account) external view returns (uint256);
932     function transfer(address recipient, uint256 amount) external returns (bool);
933     function mint(address _to, uint256 _amount) external;
934 }
935 
936 
937 interface IMigratorBreeder {
938     // Perform LP token migration from legacy UniswapV2 to KumaBreeder.
939     // Take the current LP token address and return the new LP token address.
940     // Migrator should have full access to the caller's LP token.
941     // Return the new LP token address.
942     //
943     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
944     // KumaBreeder must mint EXACTLY the same amount of KumaBreeder LP tokens or
945     // else something bad will happen. Traditional UniswapV2 does not
946     // do that so be careful!
947     function migrate(IERC20 token) external returns (IERC20);
948 }
949 
950 // KumaBreeder is the master of dkuma. He can make dkuma and he is a fair guy.
951 //
952 // Note that it's ownable and the owner wields tremendous power. The ownership
953 // will be transferred to a governance smart contract once dKUMA is sufficiently
954 // distributed and the community can show to govern itself.
955 //
956 // Have fun reading it. Hopefully it's bug-free. God bless.
957 contract KumaBreeder is Ownable {
958     using SafeMath for uint256;
959     using SafeERC20 for IERC20;
960     // Info of each user.
961     struct UserInfo {
962         uint256 amount; // How many LP tokens the user has provided.
963         uint256 rewardDebt; // Reward debt. See explanation below.
964         //
965         // We do some fancy math here. Basically, any point in time, the amount of dKUMAs
966         // entitled to a user but is pending to be distributed is:
967         //
968         //   pending reward = (user.amount * pool.accSushiPerShare) - user.rewardDebt
969         //
970         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
971         //   1. The pool's `accSushiPerShare` (and `lastRewardBlock`) gets updated.
972         //   2. User receives the pending reward sent to his/her address.
973         //   3. User's `amount` gets updated.
974         //   4. User's `rewardDebt` gets updated.
975     }
976     // Info of each pool.
977     struct PoolInfo {
978         IERC20 lpToken; // Address of LP token contract.
979         uint256 allocPoint; // How many allocation points assigned to this pool. dKUMAs to distribute per block.
980         uint256 lastRewardBlock; // Last block number that dKUMAs distribution occurs.
981         uint256 accSushiPerShare; // Accumulated dKUMAs per share, times 1e12. See below.
982         uint256 poolFee;
983         uint256 limitPerWallet;
984     }
985     // The dKUMA TOKEN!
986     IKumaDexToken public dkuma;
987     // Dev address.
988     address public devaddr;
989     // Staking Fee address.
990     address public feeRecepient;
991     // Block number when bonus SUSHI period ends.
992     uint256 public bonusEndBlock;
993     // SUSHI tokens created per block.
994     uint256 public sushiPerBlock;
995     // Bonus muliplier for early sushi makers.
996     uint256 public constant BONUS_MULTIPLIER = 10;
997     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
998     IMigratorBreeder public migrator;
999     // Info of each pool.
1000     PoolInfo[] public poolInfo;
1001     // Info of each user that stakes LP tokens.
1002     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1003     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1004     uint256 public totalAllocPoint = 0;
1005     // The block number when SUSHI mining starts.
1006     uint256 public startBlock;
1007     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1008     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1009     event EmergencyWithdraw(
1010         address indexed user,
1011         uint256 indexed pid,
1012         uint256 amount
1013     );
1014 
1015     constructor(
1016         IKumaDexToken _dkuma,
1017         address _devaddr,
1018         address _feeRecepient,
1019         uint256 _sushiPerBlock,
1020         uint256 _startBlock,
1021         uint256 _bonusEndBlock
1022     ) public {
1023         dkuma = _dkuma;
1024         devaddr = _devaddr;
1025         sushiPerBlock = _sushiPerBlock;
1026         bonusEndBlock = _bonusEndBlock;
1027         startBlock = _startBlock;
1028         feeRecepient = _feeRecepient;
1029     }
1030 
1031     function poolLength() external view returns (uint256) {
1032         return poolInfo.length;
1033     }
1034 
1035     // Add a new lp to the pool. Can only be called by the owner.
1036     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1037     function add(
1038         uint256 _allocPoint,
1039         IERC20 _lpToken,
1040         bool _withUpdate,
1041         uint256 _poolFee,
1042         uint256 _limitPerWallet
1043     ) public onlyOwner {
1044         if (_withUpdate) {
1045             massUpdatePools();
1046         }
1047         uint256 lastRewardBlock =
1048             block.number > startBlock ? block.number : startBlock;
1049         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1050         poolInfo.push(
1051             PoolInfo({
1052                 lpToken: _lpToken,
1053                 allocPoint: _allocPoint,
1054                 lastRewardBlock: lastRewardBlock,
1055                 accSushiPerShare: 0,
1056                 poolFee: _poolFee,
1057                 limitPerWallet : _limitPerWallet
1058             })
1059         );
1060     }
1061 
1062     // Update the given pool's SUSHI allocation point. Can only be called by the owner.
1063     function set(
1064         uint256 _pid,
1065         uint256 _allocPoint,
1066         bool _withUpdate,
1067         uint256 _poolFee,
1068         uint256 _limitPerWallet
1069     ) public onlyOwner {
1070         if (_withUpdate) {
1071             massUpdatePools();
1072         }
1073         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1074             _allocPoint
1075         );
1076         poolInfo[_pid].allocPoint = _allocPoint;
1077         poolInfo[_pid].poolFee = _poolFee;
1078         poolInfo[_pid].limitPerWallet = _limitPerWallet;
1079     }
1080 
1081     // Set the migrator contract. Can only be called by the owner.
1082     function setMigrator(IMigratorBreeder _migrator) public onlyOwner {
1083         migrator = _migrator;
1084     }
1085 
1086     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1087     function migrate(uint256 _pid) public {
1088         require(address(migrator) != address(0), "migrate: no migrator");
1089         PoolInfo storage pool = poolInfo[_pid];
1090         IERC20 lpToken = pool.lpToken;
1091         uint256 bal = lpToken.balanceOf(address(this));
1092         lpToken.safeApprove(address(migrator), bal);
1093         IERC20 newLpToken = migrator.migrate(lpToken);
1094         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1095         pool.lpToken = newLpToken;
1096     }
1097 
1098     // Return reward multiplier over the given _from to _to block.
1099     function getMultiplier(uint256 _from, uint256 _to)
1100         public
1101         view
1102         returns (uint256)
1103     {
1104         if (_to <= bonusEndBlock) {
1105             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1106         } else if (_from >= bonusEndBlock) {
1107             return _to.sub(_from);
1108         } else {
1109             return
1110                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1111                     _to.sub(bonusEndBlock)
1112                 );
1113         }
1114     }
1115 
1116     // View function to see pending dKUMAs on frontend.
1117     function pendingSushi(uint256 _pid, address _user)
1118         external
1119         view
1120         returns (uint256)
1121     {
1122         PoolInfo storage pool = poolInfo[_pid];
1123         UserInfo storage user = userInfo[_pid][_user];
1124         uint256 accSushiPerShare = pool.accSushiPerShare;
1125         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1126         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1127             uint256 multiplier =
1128                 getMultiplier(pool.lastRewardBlock, block.number);
1129             uint256 sushiReward =
1130                 multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(
1131                     totalAllocPoint
1132                 );
1133             accSushiPerShare = accSushiPerShare.add(
1134                 sushiReward.mul(1e12).div(lpSupply)
1135             );
1136         }
1137         return user.amount.mul(accSushiPerShare).div(1e12).sub(user.rewardDebt);
1138     }
1139 
1140     // Update reward vairables for all pools. Be careful of gas spending!
1141     function massUpdatePools() public {
1142         uint256 length = poolInfo.length;
1143         for (uint256 pid = 0; pid < length; ++pid) {
1144             updatePool(pid);
1145         }
1146     }
1147 
1148     // Update reward variables of the given pool to be up-to-date.
1149     function updatePool(uint256 _pid) public {
1150         PoolInfo storage pool = poolInfo[_pid];
1151         if (block.number <= pool.lastRewardBlock) {
1152             return;
1153         }
1154         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1155         if (lpSupply == 0) {
1156             pool.lastRewardBlock = block.number;
1157             return;
1158         }
1159         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1160         uint256 sushiReward =
1161             multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(
1162                 totalAllocPoint
1163             );
1164         dkuma.mint(devaddr, sushiReward.div(10));
1165         dkuma.mint(address(this), sushiReward);
1166         pool.accSushiPerShare = pool.accSushiPerShare.add(
1167             sushiReward.mul(1e12).div(lpSupply)
1168         );
1169         pool.lastRewardBlock = block.number;
1170     }
1171 
1172     // Deposit LP tokens to KumaBreeder for SUSHI allocation.
1173     function deposit(uint256 _pid, uint256 _amount) public {
1174         PoolInfo storage pool = poolInfo[_pid];
1175         UserInfo storage user = userInfo[_pid][msg.sender];
1176         require(user.amount.add(_amount) <= pool.limitPerWallet, "deposit: staking amount overflow");
1177 
1178         updatePool(_pid);
1179         if (user.amount > 0) {
1180             uint256 pending =
1181                 user.amount.mul(pool.accSushiPerShare).div(1e12).sub(
1182                     user.rewardDebt
1183                 );
1184             safeSushiTransfer(msg.sender, pending);
1185         }
1186 
1187         pool.lpToken.safeTransferFrom(
1188             address(msg.sender),
1189             address(this),
1190             _amount
1191         );
1192         user.amount = user.amount.add(_amount);
1193         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1194         emit Deposit(msg.sender, _pid, _amount);
1195     }
1196 
1197     // Withdraw LP tokens from KumaBreeder.
1198     function withdraw(uint256 _pid, uint256 _amount) public {
1199         PoolInfo storage pool = poolInfo[_pid];
1200         UserInfo storage user = userInfo[_pid][msg.sender];
1201         require(user.amount >= _amount, "withdraw: insufficient amount to withdraw");
1202         updatePool(_pid);
1203         uint256 pending =
1204             user.amount.mul(pool.accSushiPerShare).div(1e12).sub(
1205                 user.rewardDebt
1206             );
1207         safeSushiTransfer(msg.sender, pending);
1208 
1209         uint256 stakingFee = _amount.mul(pool.poolFee).div(1000);
1210         pool.lpToken.safeTransfer(feeRecepient,stakingFee);
1211 
1212         user.amount = user.amount.sub(_amount);
1213         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1214         pool.lpToken.safeTransfer(address(msg.sender), _amount.sub(stakingFee));
1215         emit Withdraw(msg.sender, _pid, _amount.sub(stakingFee));
1216     }
1217 
1218     // Withdraw without caring about rewards. EMERGENCY ONLY.
1219     function emergencyWithdraw(uint256 _pid) public {
1220         PoolInfo storage pool = poolInfo[_pid];
1221         UserInfo storage user = userInfo[_pid][msg.sender];
1222         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1223         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1224         user.amount = 0;
1225         user.rewardDebt = 0;
1226     }
1227 
1228     // Safe dkuma transfer function, just in case if rounding error causes pool to not have enough dKUMAs.
1229     function safeSushiTransfer(address _to, uint256 _amount) internal {
1230         uint256 sushiBal = dkuma.balanceOf(address(this));
1231         if (_amount > sushiBal) {
1232             dkuma.transfer(_to, sushiBal);
1233         } else {
1234             dkuma.transfer(_to, _amount);
1235         }
1236     }
1237 
1238     // Update dev address by the previous dev.
1239     function dev(address _devaddr) public {
1240         require(msg.sender == devaddr, "dev: wut?");
1241         devaddr = _devaddr;
1242     }
1243 }