1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 
85 pragma solidity >=0.6.0 <0.8.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, with an overflow flag.
103      *
104      * _Available since v3.4._
105      */
106     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         uint256 c = a + b;
108         if (c < a) return (false, 0);
109         return (true, c);
110     }
111 
112     /**
113      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
114      *
115      * _Available since v3.4._
116      */
117     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
118         if (b > a) return (false, 0);
119         return (true, a - b);
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
124      *
125      * _Available since v3.4._
126      */
127     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
128         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129         // benefit is lost if 'b' is also tested.
130         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131         if (a == 0) return (true, 0);
132         uint256 c = a * b;
133         if (c / a != b) return (false, 0);
134         return (true, c);
135     }
136 
137     /**
138      * @dev Returns the division of two unsigned integers, with a division by zero flag.
139      *
140      * _Available since v3.4._
141      */
142     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
143         if (b == 0) return (false, 0);
144         return (true, a / b);
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
149      *
150      * _Available since v3.4._
151      */
152     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         if (b == 0) return (false, 0);
154         return (true, a % b);
155     }
156 
157     /**
158      * @dev Returns the addition of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `+` operator.
162      *
163      * Requirements:
164      *
165      * - Addition cannot overflow.
166      */
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         uint256 c = a + b;
169         require(c >= a, "SafeMath: addition overflow");
170         return c;
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
184         require(b <= a, "SafeMath: subtraction overflow");
185         return a - b;
186     }
187 
188     /**
189      * @dev Returns the multiplication of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `*` operator.
193      *
194      * Requirements:
195      *
196      * - Multiplication cannot overflow.
197      */
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         if (a == 0) return 0;
200         uint256 c = a * b;
201         require(c / a == b, "SafeMath: multiplication overflow");
202         return c;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers, reverting on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         require(b > 0, "SafeMath: division by zero");
219         return a / b;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * reverting when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b > 0, "SafeMath: modulo by zero");
236         return a % b;
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
241      * overflow (when the result is negative).
242      *
243      * CAUTION: This function is deprecated because it requires allocating memory for the error
244      * message unnecessarily. For custom revert reasons use {trySub}.
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      *
250      * - Subtraction cannot overflow.
251      */
252     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b <= a, errorMessage);
254         return a - b;
255     }
256 
257     /**
258      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
259      * division by zero. The result is rounded towards zero.
260      *
261      * CAUTION: This function is deprecated because it requires allocating memory for the error
262      * message unnecessarily. For custom revert reasons use {tryDiv}.
263      *
264      * Counterpart to Solidity's `/` operator. Note: this function uses a
265      * `revert` opcode (which leaves remaining gas untouched) while Solidity
266      * uses an invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b > 0, errorMessage);
274         return a / b;
275     }
276 
277     /**
278      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279      * reverting with custom message when dividing by zero.
280      *
281      * CAUTION: This function is deprecated because it requires allocating memory for the error
282      * message unnecessarily. For custom revert reasons use {tryMod}.
283      *
284      * Counterpart to Solidity's `%` operator. This function uses a `revert`
285      * opcode (which leaves remaining gas untouched) while Solidity uses an
286      * invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b > 0, errorMessage);
294         return a % b;
295     }
296 }
297 
298 // File: @openzeppelin/contracts/utils/Address.sol
299 
300 
301 
302 pragma solidity >=0.6.2 <0.8.0;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         uint256 size;
331         // solhint-disable-next-line no-inline-assembly
332         assembly { size := extcodesize(account) }
333         return size > 0;
334     }
335 
336     /**
337      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
338      * `recipient`, forwarding all available gas and reverting on errors.
339      *
340      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
341      * of certain opcodes, possibly making contracts go over the 2300 gas limit
342      * imposed by `transfer`, making them unable to receive funds via
343      * `transfer`. {sendValue} removes this limitation.
344      *
345      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
346      *
347      * IMPORTANT: because control is transferred to `recipient`, care must be
348      * taken to not create reentrancy vulnerabilities. Consider using
349      * {ReentrancyGuard} or the
350      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
351      */
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(address(this).balance >= amount, "Address: insufficient balance");
354 
355         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
356         (bool success, ) = recipient.call{ value: amount }("");
357         require(success, "Address: unable to send value, recipient may have reverted");
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain`call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
379       return functionCall(target, data, "Address: low-level call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
384      * `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
414         require(address(this).balance >= value, "Address: insufficient balance for call");
415         require(isContract(target), "Address: call to non-contract");
416 
417         // solhint-disable-next-line avoid-low-level-calls
418         (bool success, bytes memory returndata) = target.call{ value: value }(data);
419         return _verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
429         return functionStaticCall(target, data, "Address: low-level static call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
439         require(isContract(target), "Address: static call to non-contract");
440 
441         // solhint-disable-next-line avoid-low-level-calls
442         (bool success, bytes memory returndata) = target.staticcall(data);
443         return _verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
453         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
463         require(isContract(target), "Address: delegate call to non-contract");
464 
465         // solhint-disable-next-line avoid-low-level-calls
466         (bool success, bytes memory returndata) = target.delegatecall(data);
467         return _verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477 
478                 // solhint-disable-next-line no-inline-assembly
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
491 
492 
493 
494 pragma solidity >=0.6.0 <0.8.0;
495 
496 
497 
498 
499 /**
500  * @title SafeERC20
501  * @dev Wrappers around ERC20 operations that throw on failure (when the token
502  * contract returns false). Tokens that return no value (and instead revert or
503  * throw on failure) are also supported, non-reverting calls are assumed to be
504  * successful.
505  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
506  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
507  */
508 library SafeERC20 {
509     using SafeMath for uint256;
510     using Address for address;
511 
512     function safeTransfer(IERC20 token, address to, uint256 value) internal {
513         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
514     }
515 
516     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
518     }
519 
520     /**
521      * @dev Deprecated. This function has issues similar to the ones found in
522      * {IERC20-approve}, and its usage is discouraged.
523      *
524      * Whenever possible, use {safeIncreaseAllowance} and
525      * {safeDecreaseAllowance} instead.
526      */
527     function safeApprove(IERC20 token, address spender, uint256 value) internal {
528         // safeApprove should only be called when setting an initial allowance,
529         // or when resetting it to zero. To increase and decrease it, use
530         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
531         // solhint-disable-next-line max-line-length
532         require((value == 0) || (token.allowance(address(this), spender) == 0),
533             "SafeERC20: approve from non-zero to non-zero allowance"
534         );
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
536     }
537 
538     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).add(value);
540         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
544         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
545         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
546     }
547 
548     /**
549      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
550      * on the return value: the return value is optional (but if data is returned, it must not be false).
551      * @param token The token targeted by the call.
552      * @param data The call data (encoded using abi.encode or one of its variants).
553      */
554     function _callOptionalReturn(IERC20 token, bytes memory data) private {
555         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
556         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
557         // the target address contains contract code and also asserts for success in the low-level call.
558 
559         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
560         if (returndata.length > 0) { // Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
563         }
564     }
565 }
566 
567 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
568 
569 
570 
571 pragma solidity >=0.6.0 <0.8.0;
572 
573 /**
574  * @dev Library for managing
575  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
576  * types.
577  *
578  * Sets have the following properties:
579  *
580  * - Elements are added, removed, and checked for existence in constant time
581  * (O(1)).
582  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
583  *
584  * ```
585  * contract Example {
586  *     // Add the library methods
587  *     using EnumerableSet for EnumerableSet.AddressSet;
588  *
589  *     // Declare a set state variable
590  *     EnumerableSet.AddressSet private mySet;
591  * }
592  * ```
593  *
594  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
595  * and `uint256` (`UintSet`) are supported.
596  */
597 library EnumerableSet {
598     // To implement this library for multiple types with as little code
599     // repetition as possible, we write it in terms of a generic Set type with
600     // bytes32 values.
601     // The Set implementation uses private functions, and user-facing
602     // implementations (such as AddressSet) are just wrappers around the
603     // underlying Set.
604     // This means that we can only create new EnumerableSets for types that fit
605     // in bytes32.
606 
607     struct Set {
608         // Storage of set values
609         bytes32[] _values;
610 
611         // Position of the value in the `values` array, plus 1 because index 0
612         // means a value is not in the set.
613         mapping (bytes32 => uint256) _indexes;
614     }
615 
616     /**
617      * @dev Add a value to a set. O(1).
618      *
619      * Returns true if the value was added to the set, that is if it was not
620      * already present.
621      */
622     function _add(Set storage set, bytes32 value) private returns (bool) {
623         if (!_contains(set, value)) {
624             set._values.push(value);
625             // The value is stored at length-1, but we add 1 to all indexes
626             // and use 0 as a sentinel value
627             set._indexes[value] = set._values.length;
628             return true;
629         } else {
630             return false;
631         }
632     }
633 
634     /**
635      * @dev Removes a value from a set. O(1).
636      *
637      * Returns true if the value was removed from the set, that is if it was
638      * present.
639      */
640     function _remove(Set storage set, bytes32 value) private returns (bool) {
641         // We read and store the value's index to prevent multiple reads from the same storage slot
642         uint256 valueIndex = set._indexes[value];
643 
644         if (valueIndex != 0) { // Equivalent to contains(set, value)
645             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
646             // the array, and then remove the last element (sometimes called as 'swap and pop').
647             // This modifies the order of the array, as noted in {at}.
648 
649             uint256 toDeleteIndex = valueIndex - 1;
650             uint256 lastIndex = set._values.length - 1;
651 
652             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
653             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
654 
655             bytes32 lastvalue = set._values[lastIndex];
656 
657             // Move the last value to the index where the value to delete is
658             set._values[toDeleteIndex] = lastvalue;
659             // Update the index for the moved value
660             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
661 
662             // Delete the slot where the moved value was stored
663             set._values.pop();
664 
665             // Delete the index for the deleted slot
666             delete set._indexes[value];
667 
668             return true;
669         } else {
670             return false;
671         }
672     }
673 
674     /**
675      * @dev Returns true if the value is in the set. O(1).
676      */
677     function _contains(Set storage set, bytes32 value) private view returns (bool) {
678         return set._indexes[value] != 0;
679     }
680 
681     /**
682      * @dev Returns the number of values on the set. O(1).
683      */
684     function _length(Set storage set) private view returns (uint256) {
685         return set._values.length;
686     }
687 
688    /**
689     * @dev Returns the value stored at position `index` in the set. O(1).
690     *
691     * Note that there are no guarantees on the ordering of values inside the
692     * array, and it may change when more values are added or removed.
693     *
694     * Requirements:
695     *
696     * - `index` must be strictly less than {length}.
697     */
698     function _at(Set storage set, uint256 index) private view returns (bytes32) {
699         require(set._values.length > index, "EnumerableSet: index out of bounds");
700         return set._values[index];
701     }
702 
703     // Bytes32Set
704 
705     struct Bytes32Set {
706         Set _inner;
707     }
708 
709     /**
710      * @dev Add a value to a set. O(1).
711      *
712      * Returns true if the value was added to the set, that is if it was not
713      * already present.
714      */
715     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
716         return _add(set._inner, value);
717     }
718 
719     /**
720      * @dev Removes a value from a set. O(1).
721      *
722      * Returns true if the value was removed from the set, that is if it was
723      * present.
724      */
725     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
726         return _remove(set._inner, value);
727     }
728 
729     /**
730      * @dev Returns true if the value is in the set. O(1).
731      */
732     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
733         return _contains(set._inner, value);
734     }
735 
736     /**
737      * @dev Returns the number of values in the set. O(1).
738      */
739     function length(Bytes32Set storage set) internal view returns (uint256) {
740         return _length(set._inner);
741     }
742 
743    /**
744     * @dev Returns the value stored at position `index` in the set. O(1).
745     *
746     * Note that there are no guarantees on the ordering of values inside the
747     * array, and it may change when more values are added or removed.
748     *
749     * Requirements:
750     *
751     * - `index` must be strictly less than {length}.
752     */
753     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
754         return _at(set._inner, index);
755     }
756 
757     // AddressSet
758 
759     struct AddressSet {
760         Set _inner;
761     }
762 
763     /**
764      * @dev Add a value to a set. O(1).
765      *
766      * Returns true if the value was added to the set, that is if it was not
767      * already present.
768      */
769     function add(AddressSet storage set, address value) internal returns (bool) {
770         return _add(set._inner, bytes32(uint256(uint160(value))));
771     }
772 
773     /**
774      * @dev Removes a value from a set. O(1).
775      *
776      * Returns true if the value was removed from the set, that is if it was
777      * present.
778      */
779     function remove(AddressSet storage set, address value) internal returns (bool) {
780         return _remove(set._inner, bytes32(uint256(uint160(value))));
781     }
782 
783     /**
784      * @dev Returns true if the value is in the set. O(1).
785      */
786     function contains(AddressSet storage set, address value) internal view returns (bool) {
787         return _contains(set._inner, bytes32(uint256(uint160(value))));
788     }
789 
790     /**
791      * @dev Returns the number of values in the set. O(1).
792      */
793     function length(AddressSet storage set) internal view returns (uint256) {
794         return _length(set._inner);
795     }
796 
797    /**
798     * @dev Returns the value stored at position `index` in the set. O(1).
799     *
800     * Note that there are no guarantees on the ordering of values inside the
801     * array, and it may change when more values are added or removed.
802     *
803     * Requirements:
804     *
805     * - `index` must be strictly less than {length}.
806     */
807     function at(AddressSet storage set, uint256 index) internal view returns (address) {
808         return address(uint160(uint256(_at(set._inner, index))));
809     }
810 
811 
812     // UintSet
813 
814     struct UintSet {
815         Set _inner;
816     }
817 
818     /**
819      * @dev Add a value to a set. O(1).
820      *
821      * Returns true if the value was added to the set, that is if it was not
822      * already present.
823      */
824     function add(UintSet storage set, uint256 value) internal returns (bool) {
825         return _add(set._inner, bytes32(value));
826     }
827 
828     /**
829      * @dev Removes a value from a set. O(1).
830      *
831      * Returns true if the value was removed from the set, that is if it was
832      * present.
833      */
834     function remove(UintSet storage set, uint256 value) internal returns (bool) {
835         return _remove(set._inner, bytes32(value));
836     }
837 
838     /**
839      * @dev Returns true if the value is in the set. O(1).
840      */
841     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
842         return _contains(set._inner, bytes32(value));
843     }
844 
845     /**
846      * @dev Returns the number of values on the set. O(1).
847      */
848     function length(UintSet storage set) internal view returns (uint256) {
849         return _length(set._inner);
850     }
851 
852    /**
853     * @dev Returns the value stored at position `index` in the set. O(1).
854     *
855     * Note that there are no guarantees on the ordering of values inside the
856     * array, and it may change when more values are added or removed.
857     *
858     * Requirements:
859     *
860     * - `index` must be strictly less than {length}.
861     */
862     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
863         return uint256(_at(set._inner, index));
864     }
865 }
866 
867 // File: @openzeppelin/contracts/utils/Context.sol
868 
869 
870 
871 pragma solidity >=0.6.0 <0.8.0;
872 
873 /*
874  * @dev Provides information about the current execution context, including the
875  * sender of the transaction and its data. While these are generally available
876  * via msg.sender and msg.data, they should not be accessed in such a direct
877  * manner, since when dealing with GSN meta-transactions the account sending and
878  * paying for execution may not be the actual sender (as far as an application
879  * is concerned).
880  *
881  * This contract is only required for intermediate, library-like contracts.
882  */
883 abstract contract Context {
884     function _msgSender() internal view virtual returns (address payable) {
885         return msg.sender;
886     }
887 
888     function _msgData() internal view virtual returns (bytes memory) {
889         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
890         return msg.data;
891     }
892 }
893 
894 // File: @openzeppelin/contracts/access/Ownable.sol
895 
896 
897 
898 pragma solidity >=0.6.0 <0.8.0;
899 
900 /**
901  * @dev Contract module which provides a basic access control mechanism, where
902  * there is an account (an owner) that can be granted exclusive access to
903  * specific functions.
904  *
905  * By default, the owner account will be the one that deploys the contract. This
906  * can later be changed with {transferOwnership}.
907  *
908  * This module is used through inheritance. It will make available the modifier
909  * `onlyOwner`, which can be applied to your functions to restrict their use to
910  * the owner.
911  */
912 abstract contract Ownable is Context {
913     address private _owner;
914 
915     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
916 
917     /**
918      * @dev Initializes the contract setting the deployer as the initial owner.
919      */
920     constructor () internal {
921         address msgSender = _msgSender();
922         _owner = msgSender;
923         emit OwnershipTransferred(address(0), msgSender);
924     }
925 
926     /**
927      * @dev Returns the address of the current owner.
928      */
929     function owner() public view virtual returns (address) {
930         return _owner;
931     }
932 
933     /**
934      * @dev Throws if called by any account other than the owner.
935      */
936     modifier onlyOwner() {
937         require(owner() == _msgSender(), "Ownable: caller is not the owner");
938         _;
939     }
940 
941     /**
942      * @dev Leaves the contract without owner. It will not be possible to call
943      * `onlyOwner` functions anymore. Can only be called by the current owner.
944      *
945      * NOTE: Renouncing ownership will leave the contract without an owner,
946      * thereby removing any functionality that is only available to the owner.
947      */
948     function renounceOwnership() public virtual onlyOwner {
949         emit OwnershipTransferred(_owner, address(0));
950         _owner = address(0);
951     }
952 
953     /**
954      * @dev Transfers ownership of the contract to a new account (`newOwner`).
955      * Can only be called by the current owner.
956      */
957     function transferOwnership(address newOwner) public virtual onlyOwner {
958         require(newOwner != address(0), "Ownable: new owner is the zero address");
959         emit OwnershipTransferred(_owner, newOwner);
960         _owner = newOwner;
961     }
962 }
963 
964 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
965 
966 
967 
968 pragma solidity >=0.6.0 <0.8.0;
969 
970 
971 
972 
973 /**
974  * @dev Implementation of the {IERC20} interface.
975  *
976  * This implementation is agnostic to the way tokens are created. This means
977  * that a supply mechanism has to be added in a derived contract using {_mint}.
978  * For a generic mechanism see {ERC20PresetMinterPauser}.
979  *
980  * TIP: For a detailed writeup see our guide
981  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
982  * to implement supply mechanisms].
983  *
984  * We have followed general OpenZeppelin guidelines: functions revert instead
985  * of returning `false` on failure. This behavior is nonetheless conventional
986  * and does not conflict with the expectations of ERC20 applications.
987  *
988  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
989  * This allows applications to reconstruct the allowance for all accounts just
990  * by listening to said events. Other implementations of the EIP may not emit
991  * these events, as it isn't required by the specification.
992  *
993  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
994  * functions have been added to mitigate the well-known issues around setting
995  * allowances. See {IERC20-approve}.
996  */
997 contract ERC20 is Context, IERC20 {
998     using SafeMath for uint256;
999 
1000     mapping (address => uint256) private _balances;
1001 
1002     mapping (address => mapping (address => uint256)) private _allowances;
1003 
1004     uint256 private _totalSupply;
1005 
1006     string private _name;
1007     string private _symbol;
1008     uint8 private _decimals;
1009 
1010     /**
1011      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1012      * a default value of 18.
1013      *
1014      * To select a different value for {decimals}, use {_setupDecimals}.
1015      *
1016      * All three of these values are immutable: they can only be set once during
1017      * construction.
1018      */
1019     constructor (string memory name_, string memory symbol_) public {
1020         _name = name_;
1021         _symbol = symbol_;
1022         _decimals = 18;
1023     }
1024 
1025     /**
1026      * @dev Returns the name of the token.
1027      */
1028     function name() public view virtual returns (string memory) {
1029         return _name;
1030     }
1031 
1032     /**
1033      * @dev Returns the symbol of the token, usually a shorter version of the
1034      * name.
1035      */
1036     function symbol() public view virtual returns (string memory) {
1037         return _symbol;
1038     }
1039 
1040     /**
1041      * @dev Returns the number of decimals used to get its user representation.
1042      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1043      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1044      *
1045      * Tokens usually opt for a value of 18, imitating the relationship between
1046      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1047      * called.
1048      *
1049      * NOTE: This information is only used for _display_ purposes: it in
1050      * no way affects any of the arithmetic of the contract, including
1051      * {IERC20-balanceOf} and {IERC20-transfer}.
1052      */
1053     function decimals() public view virtual returns (uint8) {
1054         return _decimals;
1055     }
1056 
1057     /**
1058      * @dev See {IERC20-totalSupply}.
1059      */
1060     function totalSupply() public view virtual override returns (uint256) {
1061         return _totalSupply;
1062     }
1063 
1064     /**
1065      * @dev See {IERC20-balanceOf}.
1066      */
1067     function balanceOf(address account) public view virtual override returns (uint256) {
1068         return _balances[account];
1069     }
1070 
1071     /**
1072      * @dev See {IERC20-transfer}.
1073      *
1074      * Requirements:
1075      *
1076      * - `recipient` cannot be the zero address.
1077      * - the caller must have a balance of at least `amount`.
1078      */
1079     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1080         _transfer(_msgSender(), recipient, amount);
1081         return true;
1082     }
1083 
1084     /**
1085      * @dev See {IERC20-allowance}.
1086      */
1087     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1088         return _allowances[owner][spender];
1089     }
1090 
1091     /**
1092      * @dev See {IERC20-approve}.
1093      *
1094      * Requirements:
1095      *
1096      * - `spender` cannot be the zero address.
1097      */
1098     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1099         _approve(_msgSender(), spender, amount);
1100         return true;
1101     }
1102 
1103     /**
1104      * @dev See {IERC20-transferFrom}.
1105      *
1106      * Emits an {Approval} event indicating the updated allowance. This is not
1107      * required by the EIP. See the note at the beginning of {ERC20}.
1108      *
1109      * Requirements:
1110      *
1111      * - `sender` and `recipient` cannot be the zero address.
1112      * - `sender` must have a balance of at least `amount`.
1113      * - the caller must have allowance for ``sender``'s tokens of at least
1114      * `amount`.
1115      */
1116     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1117         _transfer(sender, recipient, amount);
1118         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1119         return true;
1120     }
1121 
1122     /**
1123      * @dev Atomically increases the allowance granted to `spender` by the caller.
1124      *
1125      * This is an alternative to {approve} that can be used as a mitigation for
1126      * problems described in {IERC20-approve}.
1127      *
1128      * Emits an {Approval} event indicating the updated allowance.
1129      *
1130      * Requirements:
1131      *
1132      * - `spender` cannot be the zero address.
1133      */
1134     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1135         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1136         return true;
1137     }
1138 
1139     /**
1140      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1141      *
1142      * This is an alternative to {approve} that can be used as a mitigation for
1143      * problems described in {IERC20-approve}.
1144      *
1145      * Emits an {Approval} event indicating the updated allowance.
1146      *
1147      * Requirements:
1148      *
1149      * - `spender` cannot be the zero address.
1150      * - `spender` must have allowance for the caller of at least
1151      * `subtractedValue`.
1152      */
1153     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1154         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1155         return true;
1156     }
1157 
1158     /**
1159      * @dev Moves tokens `amount` from `sender` to `recipient`.
1160      *
1161      * This is internal function is equivalent to {transfer}, and can be used to
1162      * e.g. implement automatic token fees, slashing mechanisms, etc.
1163      *
1164      * Emits a {Transfer} event.
1165      *
1166      * Requirements:
1167      *
1168      * - `sender` cannot be the zero address.
1169      * - `recipient` cannot be the zero address.
1170      * - `sender` must have a balance of at least `amount`.
1171      */
1172     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1173         require(sender != address(0), "ERC20: transfer from the zero address");
1174         require(recipient != address(0), "ERC20: transfer to the zero address");
1175 
1176         _beforeTokenTransfer(sender, recipient, amount);
1177 
1178         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1179         _balances[recipient] = _balances[recipient].add(amount);
1180         emit Transfer(sender, recipient, amount);
1181     }
1182 
1183     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1184      * the total supply.
1185      *
1186      * Emits a {Transfer} event with `from` set to the zero address.
1187      *
1188      * Requirements:
1189      *
1190      * - `to` cannot be the zero address.
1191      */
1192     function _mint(address account, uint256 amount) internal virtual {
1193         require(account != address(0), "ERC20: mint to the zero address");
1194 
1195         _beforeTokenTransfer(address(0), account, amount);
1196 
1197         _totalSupply = _totalSupply.add(amount);
1198         _balances[account] = _balances[account].add(amount);
1199         emit Transfer(address(0), account, amount);
1200     }
1201 
1202     /**
1203      * @dev Destroys `amount` tokens from `account`, reducing the
1204      * total supply.
1205      *
1206      * Emits a {Transfer} event with `to` set to the zero address.
1207      *
1208      * Requirements:
1209      *
1210      * - `account` cannot be the zero address.
1211      * - `account` must have at least `amount` tokens.
1212      */
1213     function _burn(address account, uint256 amount) internal virtual {
1214         require(account != address(0), "ERC20: burn from the zero address");
1215 
1216         _beforeTokenTransfer(account, address(0), amount);
1217 
1218         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1219         _totalSupply = _totalSupply.sub(amount);
1220         emit Transfer(account, address(0), amount);
1221     }
1222 
1223     /**
1224      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1225      *
1226      * This internal function is equivalent to `approve`, and can be used to
1227      * e.g. set automatic allowances for certain subsystems, etc.
1228      *
1229      * Emits an {Approval} event.
1230      *
1231      * Requirements:
1232      *
1233      * - `owner` cannot be the zero address.
1234      * - `spender` cannot be the zero address.
1235      */
1236     function _approve(address owner, address spender, uint256 amount) internal virtual {
1237         require(owner != address(0), "ERC20: approve from the zero address");
1238         require(spender != address(0), "ERC20: approve to the zero address");
1239 
1240         _allowances[owner][spender] = amount;
1241         emit Approval(owner, spender, amount);
1242     }
1243 
1244     /**
1245      * @dev Sets {decimals} to a value other than the default one of 18.
1246      *
1247      * WARNING: This function should only be called from the constructor. Most
1248      * applications that interact with token contracts will not expect
1249      * {decimals} to ever change, and may work incorrectly if it does.
1250      */
1251     function _setupDecimals(uint8 decimals_) internal virtual {
1252         _decimals = decimals_;
1253     }
1254 
1255     /**
1256      * @dev Hook that is called before any transfer of tokens. This includes
1257      * minting and burning.
1258      *
1259      * Calling conditions:
1260      *
1261      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1262      * will be to transferred to `to`.
1263      * - when `from` is zero, `amount` tokens will be minted for `to`.
1264      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1265      * - `from` and `to` are never both zero.
1266      *
1267      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1268      */
1269     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1270 }
1271 
1272 // File: contracts/bBetaToken.sol
1273 
1274 
1275 
1276 pragma solidity 0.6.12;
1277 
1278 
1279 
1280 contract bBetaToken is ERC20("bBeta", "bBETA"), Ownable {
1281     uint256 public cap = 20000e18;
1282     address public bBetaMaster;
1283     mapping(address => uint) public redeemed;
1284 
1285     uint256 public startAtBlock;
1286     uint256 public NUMBER_BLOCKS_PER_DAY;
1287     uint256 constant public DATA_PROVIDER_TOTAL_AMOUNT = 2000e18;
1288     uint256 constant public AIRDROP_TOTAL_AMOUNT = 2000e18;
1289     uint256 public dataProviderAmount = DATA_PROVIDER_TOTAL_AMOUNT;
1290     uint256 public farmingAmount = 16000e18;
1291 
1292     constructor(address _sendTo, uint256 _startAtBlock, uint256 _numberBlockPerDay) public {
1293         startAtBlock = _startAtBlock;
1294         NUMBER_BLOCKS_PER_DAY = _numberBlockPerDay == 0 ? 6000 : _numberBlockPerDay;
1295         _mint(_sendTo, AIRDROP_TOTAL_AMOUNT);
1296     }
1297     
1298     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1299         super._beforeTokenTransfer(from, to, amount);
1300 
1301         if (from == address(0)) {
1302             require(totalSupply().add(amount) <= cap, "ERC20Capped: cap exceeded");
1303         }
1304     }
1305 
1306     function setMaster(address _bBetaMaster) public onlyOwner {
1307         bBetaMaster = _bBetaMaster;
1308     }
1309 
1310     function mint(address _to, uint256 _amount) public {
1311         require(msg.sender == bBetaMaster, "bBetaToken: only master farmer can mint");
1312         if (_amount > farmingAmount) {
1313             _amount = farmingAmount;
1314         }
1315         farmingAmount = farmingAmount.sub(_amount);
1316         _mint(_to, _amount);
1317     }
1318 
1319     function safeBurn(uint256 _amount) public {
1320         uint canBurn = canBurnAmount(msg.sender);
1321         uint burnAmount = canBurn > _amount ? _amount : canBurn;
1322         redeemed[msg.sender] += burnAmount;
1323         _burn(msg.sender, burnAmount);
1324     }
1325 
1326     function burn(uint256 _amount) public {
1327         require(redeemed[msg.sender] + _amount <= 1e18, "bBetaToken: cannot burn more than 1 bBeta");
1328         redeemed[msg.sender] += _amount;
1329         _burn(msg.sender, _amount);
1330     }
1331 
1332     function canBurnAmount(address _add) public view returns (uint) {
1333         return 1e18 - redeemed[_add];
1334     }
1335 
1336     function mintForDataProvider(address _to) public onlyOwner {
1337         require(block.number >= startAtBlock + 14 * NUMBER_BLOCKS_PER_DAY, "bBetaToken: Cannot mint at this time");
1338         require(dataProviderAmount > 0, "bBetaToken: Cannot mint more token for future farming");
1339 
1340         _mint(_to, dataProviderAmount);
1341         dataProviderAmount = 0;
1342     }
1343 }
1344 
1345 // File: contracts/bBetaMaster.sol
1346 
1347 
1348 pragma solidity 0.6.12;
1349 
1350 
1351 
1352 
1353 
1354 
1355 
1356 contract bBetaMaster is Ownable {
1357     using SafeMath for uint256;
1358     using SafeERC20 for IERC20;
1359 
1360     struct UserInfo {
1361         uint256 amount;     // How many LP tokens the user has provided.
1362         uint256 rewardDebt; // Reward debt. See explanation below.
1363     }
1364 
1365     // Info of each pool.
1366     struct PoolInfo {
1367         IERC20 lpToken;
1368         uint256 allocPoint;
1369         uint256 lastRewardBlock;
1370         uint256 rewardPerShare;
1371     }
1372 
1373     bBetaToken public bBeta;
1374     
1375     uint256 public REWARD_PER_BLOCK;
1376     uint256[] public REWARD_MULTIPLIER = [222, 211, 200, 189, 178, 167, 156, 144, 133, 122, 111, 100, 0];
1377     uint256[] public HALVING_AT_BLOCK;
1378     uint256 public FINISH_BONUS_AT_BLOCK;
1379 
1380     uint256 public START_BLOCK;
1381 
1382     // Info of each pool.
1383     PoolInfo[] public poolInfo;
1384     mapping(address => uint256) public poolId1; // poolId1 count from 1, subtraction 1 before using with poolInfo
1385     // Info of each user that stakes LP tokens. pid => user address => info
1386     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1387     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1388     uint256 public totalAllocPoint = 0;
1389 
1390     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1391     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1392     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1393     event SendReward(address indexed user, uint256 indexed pid, uint256 amount);
1394 
1395     constructor(
1396         bBetaToken _bBeta,
1397         uint256 _rewardPerBlock,
1398         uint256 _startBlock,
1399         uint256 _halvingAfterBlock
1400     ) public {
1401         bBeta = _bBeta;
1402         REWARD_PER_BLOCK = _rewardPerBlock;
1403         START_BLOCK = _startBlock;
1404         for (uint256 i = 0; i < REWARD_MULTIPLIER.length - 1; i++) {
1405             uint256 halvingAtBlock = _halvingAfterBlock.mul(i + 1).add(_startBlock);
1406             HALVING_AT_BLOCK.push(halvingAtBlock);
1407         }
1408         FINISH_BONUS_AT_BLOCK = _halvingAfterBlock.mul(REWARD_MULTIPLIER.length - 1).add(_startBlock);
1409         HALVING_AT_BLOCK.push(uint256(-1));
1410     }
1411 
1412     // -------- For manage pool ---------
1413     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1414         require(address(_lpToken) != address(0x0), "bBetaMaster::add: wrong lptoken");
1415         require(poolId1[address(_lpToken)] == 0, "bBetaMaster::add: lp is already in pool");
1416         if (_withUpdate) {
1417             massUpdatePools();
1418         }
1419         uint256 lastRewardBlock = block.number > START_BLOCK ? block.number : START_BLOCK;
1420         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1421         poolId1[address(_lpToken)] = poolInfo.length + 1;
1422         poolInfo.push(PoolInfo({
1423             lpToken: _lpToken,
1424             allocPoint: _allocPoint,
1425             lastRewardBlock: lastRewardBlock,
1426             rewardPerShare: 0
1427         }));
1428     }
1429 
1430     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1431         if (_withUpdate) {
1432             massUpdatePools();
1433         }
1434         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1435         poolInfo[_pid].allocPoint = _allocPoint;
1436     }
1437 
1438     function massUpdatePools() public {
1439         uint256 length = poolInfo.length;
1440         for (uint256 pid = 0; pid < length; ++pid) {
1441             updatePool(pid);
1442         }
1443     }
1444 
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
1455         uint256 reward = getPoolReward(
1456             pool.lastRewardBlock, 
1457             block.number, 
1458             pool.allocPoint
1459         );
1460         if (reward == 0) {
1461             pool.lastRewardBlock = block.number;
1462             return;
1463         }
1464         bBeta.mint(address(this), reward);
1465         pool.rewardPerShare = pool.rewardPerShare.add(reward.mul(1e12).div(lpSupply));
1466         pool.lastRewardBlock = block.number;
1467     }
1468 
1469     // --------- For user ----------------
1470     function deposit(uint256 _pid, uint256 _amount) public {
1471         PoolInfo storage pool = poolInfo[_pid];
1472         UserInfo storage user = userInfo[_pid][msg.sender];
1473         updatePool(_pid);
1474         if (user.amount > 0) {
1475             uint256 pending = user.amount.mul(pool.rewardPerShare).div(1e12).sub(user.rewardDebt);
1476             if(pending > 0) {
1477                 safeTransferReward(msg.sender, pending);
1478             }
1479         }
1480         if(_amount > 0) {
1481             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1482             user.amount = user.amount.add(_amount);
1483         }
1484         user.rewardDebt = user.amount.mul(pool.rewardPerShare).div(1e12);
1485         emit Deposit(msg.sender, _pid, _amount);
1486     }
1487 
1488     function withdraw(uint256 _pid, uint256 _amount) public {
1489         PoolInfo storage pool = poolInfo[_pid];
1490         UserInfo storage user = userInfo[_pid][msg.sender];
1491         require(user.amount >= _amount, "withdraw: not good");
1492         updatePool(_pid);
1493         uint256 pending = user.amount.mul(pool.rewardPerShare).div(1e12).sub(user.rewardDebt);
1494         if(pending > 0) {
1495             safeTransferReward(msg.sender, pending);
1496         }
1497         if(_amount > 0) {
1498             user.amount = user.amount.sub(_amount);
1499             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1500         }
1501         user.rewardDebt = user.amount.mul(pool.rewardPerShare).div(1e12);
1502         emit Withdraw(msg.sender, _pid, _amount);
1503     }
1504 
1505     function claimReward(uint256 _pid) public {
1506         deposit(_pid, 0);
1507     }
1508 
1509     // Withdraw without caring about rewards. EMERGENCY ONLY.
1510     function emergencyWithdraw(uint256 _pid) public {
1511         PoolInfo storage pool = poolInfo[_pid];
1512         UserInfo storage user = userInfo[_pid][msg.sender];
1513         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1514         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1515         user.amount = 0;
1516         user.rewardDebt = 0;
1517     }
1518 
1519     // -----------------------------
1520     function safeTransferReward(address _to, uint256 _amount) internal {
1521         uint256 bal = bBeta.balanceOf(address(this));
1522         if (_amount > bal) {
1523             bBeta.transfer(_to, bal);
1524         } else {
1525             bBeta.transfer(_to, _amount);
1526         }
1527     }
1528 
1529     // GET INFO for UI
1530     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1531         uint256 result = 0;
1532         if (_from < START_BLOCK) return 0;
1533 
1534         for (uint256 i = 0; i < HALVING_AT_BLOCK.length; i++) {
1535             uint256 endBlock = HALVING_AT_BLOCK[i];
1536 
1537             if (_to <= endBlock) {
1538                 uint256 m = _to.sub(_from).mul(REWARD_MULTIPLIER[i]);
1539                 return result.add(m);
1540             }
1541 
1542             if (_from < endBlock) {
1543                 uint256 m = endBlock.sub(_from).mul(REWARD_MULTIPLIER[i]);
1544                 _from = endBlock;
1545                 result = result.add(m);
1546             }
1547         }
1548 
1549         return result;
1550     }
1551 
1552     function getPoolReward(uint256 _from, uint256 _to, uint256 _allocPoint) public view returns (uint) {
1553         uint256 multiplier = getMultiplier(_from, _to);
1554         uint256 amount = (multiplier.mul(REWARD_PER_BLOCK).mul(_allocPoint).div(totalAllocPoint)).div(100);
1555         uint256 amountCanMint = bBeta.farmingAmount();
1556         return amountCanMint < amount ? amountCanMint : amount;
1557     }
1558 
1559     function getRewardPerBlock(uint256 pid1) public view returns (uint256) {
1560         uint256 multiplier = getMultiplier(block.number -1, block.number);
1561         if (pid1 == 0) {
1562             return (multiplier.mul(REWARD_PER_BLOCK)).div(100);
1563         }
1564         else {
1565             return (multiplier
1566                 .mul(REWARD_PER_BLOCK)
1567                 .mul(poolInfo[pid1 - 1].allocPoint)
1568                 .div(totalAllocPoint))
1569                 .div(100);
1570         }
1571     }
1572 
1573     function pendingReward(uint256 _pid, address _user) public view returns (uint256) {
1574         PoolInfo storage pool = poolInfo[_pid];
1575         UserInfo storage user = userInfo[_pid][_user];
1576         uint256 rewardPerShare = pool.rewardPerShare;
1577         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1578         if (block.number > pool.lastRewardBlock && lpSupply > 0) {
1579             uint256 reward = getPoolReward(pool.lastRewardBlock, block.number, pool.allocPoint);
1580             rewardPerShare = rewardPerShare.add(reward.mul(1e12).div(lpSupply));
1581         }
1582         return user.amount.mul(rewardPerShare).div(1e12).sub(user.rewardDebt);
1583     }
1584 
1585     function poolLength() public view returns (uint256) {
1586         return poolInfo.length;
1587     }
1588 
1589     function getStakedAmount(uint _pid, address _user) public view returns (uint256) {
1590         UserInfo storage user = userInfo[_pid][_user];
1591         return user.amount;
1592     }
1593 }