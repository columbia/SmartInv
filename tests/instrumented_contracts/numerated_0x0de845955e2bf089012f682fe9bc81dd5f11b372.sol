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
84 pragma solidity >=0.6.0 <0.8.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, with an overflow flag.
102      *
103      * _Available since v3.4._
104      */
105     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         uint256 c = a + b;
107         if (c < a) return (false, 0);
108         return (true, c);
109     }
110 
111     /**
112      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
113      *
114      * _Available since v3.4._
115      */
116     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         if (b > a) return (false, 0);
118         return (true, a - b);
119     }
120 
121     /**
122      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
123      *
124      * _Available since v3.4._
125      */
126     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
128         // benefit is lost if 'b' is also tested.
129         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
130         if (a == 0) return (true, 0);
131         uint256 c = a * b;
132         if (c / a != b) return (false, 0);
133         return (true, c);
134     }
135 
136     /**
137      * @dev Returns the division of two unsigned integers, with a division by zero flag.
138      *
139      * _Available since v3.4._
140      */
141     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         if (b == 0) return (false, 0);
143         return (true, a / b);
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         if (b == 0) return (false, 0);
153         return (true, a % b);
154     }
155 
156     /**
157      * @dev Returns the addition of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `+` operator.
161      *
162      * Requirements:
163      *
164      * - Addition cannot overflow.
165      */
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         require(c >= a, "SafeMath: addition overflow");
169         return c;
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting on
174      * overflow (when the result is negative).
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b <= a, "SafeMath: subtraction overflow");
184         return a - b;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      *
195      * - Multiplication cannot overflow.
196      */
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198         if (a == 0) return 0;
199         uint256 c = a * b;
200         require(c / a == b, "SafeMath: multiplication overflow");
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers, reverting on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         require(b > 0, "SafeMath: division by zero");
218         return a / b;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * reverting when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         require(b > 0, "SafeMath: modulo by zero");
235         return a % b;
236     }
237 
238     /**
239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
240      * overflow (when the result is negative).
241      *
242      * CAUTION: This function is deprecated because it requires allocating memory for the error
243      * message unnecessarily. For custom revert reasons use {trySub}.
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b <= a, errorMessage);
253         return a - b;
254     }
255 
256     /**
257      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
258      * division by zero. The result is rounded towards zero.
259      *
260      * CAUTION: This function is deprecated because it requires allocating memory for the error
261      * message unnecessarily. For custom revert reasons use {tryDiv}.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b > 0, errorMessage);
273         return a / b;
274     }
275 
276     /**
277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278      * reverting with custom message when dividing by zero.
279      *
280      * CAUTION: This function is deprecated because it requires allocating memory for the error
281      * message unnecessarily. For custom revert reasons use {tryMod}.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b > 0, errorMessage);
293         return a % b;
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Address.sol
298 
299 
300 pragma solidity >=0.6.2 <0.8.0;
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      */
323     function isContract(address account) internal view returns (bool) {
324         // This method relies on extcodesize, which returns 0 for contracts in
325         // construction, since the code is only stored at the end of the
326         // constructor execution.
327 
328         uint256 size;
329         // solhint-disable-next-line no-inline-assembly
330         assembly { size := extcodesize(account) }
331         return size > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
354         (bool success, ) = recipient.call{ value: amount }("");
355         require(success, "Address: unable to send value, recipient may have reverted");
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain`call` is an unsafe replacement for a function call: use this
361      * function instead.
362      *
363      * If `target` reverts with a revert reason, it is bubbled up by this
364      * function (like regular Solidity function calls).
365      *
366      * Returns the raw returned data. To convert to the expected return value,
367      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
368      *
369      * Requirements:
370      *
371      * - `target` must be a contract.
372      * - calling `target` with `data` must not revert.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
377       return functionCall(target, data, "Address: low-level call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382      * `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, 0, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but also transferring `value` wei to `target`.
393      *
394      * Requirements:
395      *
396      * - the calling contract must have an ETH balance of at least `value`.
397      * - the called Solidity function must be `payable`.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
412         require(address(this).balance >= value, "Address: insufficient balance for call");
413         require(isContract(target), "Address: call to non-contract");
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = target.call{ value: value }(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
427         return functionStaticCall(target, data, "Address: low-level static call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
437         require(isContract(target), "Address: static call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.staticcall(data);
441         return _verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
451         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.4._
459      */
460     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
461         require(isContract(target), "Address: delegate call to non-contract");
462 
463         // solhint-disable-next-line avoid-low-level-calls
464         (bool success, bytes memory returndata) = target.delegatecall(data);
465         return _verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
469         if (success) {
470             return returndata;
471         } else {
472             // Look for revert reason and bubble it up if present
473             if (returndata.length > 0) {
474                 // The easiest way to bubble the revert reason is using memory via assembly
475 
476                 // solhint-disable-next-line no-inline-assembly
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
489 
490 
491 pragma solidity >=0.6.0 <0.8.0;
492 
493 
494 
495 
496 /**
497  * @title SafeERC20
498  * @dev Wrappers around ERC20 operations that throw on failure (when the token
499  * contract returns false). Tokens that return no value (and instead revert or
500  * throw on failure) are also supported, non-reverting calls are assumed to be
501  * successful.
502  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
503  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
504  */
505 library SafeERC20 {
506     using SafeMath for uint256;
507     using Address for address;
508 
509     function safeTransfer(IERC20 token, address to, uint256 value) internal {
510         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
511     }
512 
513     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
514         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
515     }
516 
517     /**
518      * @dev Deprecated. This function has issues similar to the ones found in
519      * {IERC20-approve}, and its usage is discouraged.
520      *
521      * Whenever possible, use {safeIncreaseAllowance} and
522      * {safeDecreaseAllowance} instead.
523      */
524     function safeApprove(IERC20 token, address spender, uint256 value) internal {
525         // safeApprove should only be called when setting an initial allowance,
526         // or when resetting it to zero. To increase and decrease it, use
527         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
528         // solhint-disable-next-line max-line-length
529         require((value == 0) || (token.allowance(address(this), spender) == 0),
530             "SafeERC20: approve from non-zero to non-zero allowance"
531         );
532         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
533     }
534 
535     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
536         uint256 newAllowance = token.allowance(address(this), spender).add(value);
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
538     }
539 
540     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
541         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
542         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
543     }
544 
545     /**
546      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
547      * on the return value: the return value is optional (but if data is returned, it must not be false).
548      * @param token The token targeted by the call.
549      * @param data The call data (encoded using abi.encode or one of its variants).
550      */
551     function _callOptionalReturn(IERC20 token, bytes memory data) private {
552         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
553         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
554         // the target address contains contract code and also asserts for success in the low-level call.
555 
556         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
557         if (returndata.length > 0) { // Return data is optional
558             // solhint-disable-next-line max-line-length
559             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
560         }
561     }
562 }
563 
564 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
565 
566 
567 pragma solidity >=0.6.0 <0.8.0;
568 
569 /**
570  * @dev Library for managing
571  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
572  * types.
573  *
574  * Sets have the following properties:
575  *
576  * - Elements are added, removed, and checked for existence in constant time
577  * (O(1)).
578  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
579  *
580  * ```
581  * contract Example {
582  *     // Add the library methods
583  *     using EnumerableSet for EnumerableSet.AddressSet;
584  *
585  *     // Declare a set state variable
586  *     EnumerableSet.AddressSet private mySet;
587  * }
588  * ```
589  *
590  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
591  * and `uint256` (`UintSet`) are supported.
592  */
593 library EnumerableSet {
594     // To implement this library for multiple types with as little code
595     // repetition as possible, we write it in terms of a generic Set type with
596     // bytes32 values.
597     // The Set implementation uses private functions, and user-facing
598     // implementations (such as AddressSet) are just wrappers around the
599     // underlying Set.
600     // This means that we can only create new EnumerableSets for types that fit
601     // in bytes32.
602 
603     struct Set {
604         // Storage of set values
605         bytes32[] _values;
606 
607         // Position of the value in the `values` array, plus 1 because index 0
608         // means a value is not in the set.
609         mapping (bytes32 => uint256) _indexes;
610     }
611 
612     /**
613      * @dev Add a value to a set. O(1).
614      *
615      * Returns true if the value was added to the set, that is if it was not
616      * already present.
617      */
618     function _add(Set storage set, bytes32 value) private returns (bool) {
619         if (!_contains(set, value)) {
620             set._values.push(value);
621             // The value is stored at length-1, but we add 1 to all indexes
622             // and use 0 as a sentinel value
623             set._indexes[value] = set._values.length;
624             return true;
625         } else {
626             return false;
627         }
628     }
629 
630     /**
631      * @dev Removes a value from a set. O(1).
632      *
633      * Returns true if the value was removed from the set, that is if it was
634      * present.
635      */
636     function _remove(Set storage set, bytes32 value) private returns (bool) {
637         // We read and store the value's index to prevent multiple reads from the same storage slot
638         uint256 valueIndex = set._indexes[value];
639 
640         if (valueIndex != 0) { // Equivalent to contains(set, value)
641             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
642             // the array, and then remove the last element (sometimes called as 'swap and pop').
643             // This modifies the order of the array, as noted in {at}.
644 
645             uint256 toDeleteIndex = valueIndex - 1;
646             uint256 lastIndex = set._values.length - 1;
647 
648             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
649             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
650 
651             bytes32 lastvalue = set._values[lastIndex];
652 
653             // Move the last value to the index where the value to delete is
654             set._values[toDeleteIndex] = lastvalue;
655             // Update the index for the moved value
656             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
657 
658             // Delete the slot where the moved value was stored
659             set._values.pop();
660 
661             // Delete the index for the deleted slot
662             delete set._indexes[value];
663 
664             return true;
665         } else {
666             return false;
667         }
668     }
669 
670     /**
671      * @dev Returns true if the value is in the set. O(1).
672      */
673     function _contains(Set storage set, bytes32 value) private view returns (bool) {
674         return set._indexes[value] != 0;
675     }
676 
677     /**
678      * @dev Returns the number of values on the set. O(1).
679      */
680     function _length(Set storage set) private view returns (uint256) {
681         return set._values.length;
682     }
683 
684    /**
685     * @dev Returns the value stored at position `index` in the set. O(1).
686     *
687     * Note that there are no guarantees on the ordering of values inside the
688     * array, and it may change when more values are added or removed.
689     *
690     * Requirements:
691     *
692     * - `index` must be strictly less than {length}.
693     */
694     function _at(Set storage set, uint256 index) private view returns (bytes32) {
695         require(set._values.length > index, "EnumerableSet: index out of bounds");
696         return set._values[index];
697     }
698 
699     // Bytes32Set
700 
701     struct Bytes32Set {
702         Set _inner;
703     }
704 
705     /**
706      * @dev Add a value to a set. O(1).
707      *
708      * Returns true if the value was added to the set, that is if it was not
709      * already present.
710      */
711     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
712         return _add(set._inner, value);
713     }
714 
715     /**
716      * @dev Removes a value from a set. O(1).
717      *
718      * Returns true if the value was removed from the set, that is if it was
719      * present.
720      */
721     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
722         return _remove(set._inner, value);
723     }
724 
725     /**
726      * @dev Returns true if the value is in the set. O(1).
727      */
728     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
729         return _contains(set._inner, value);
730     }
731 
732     /**
733      * @dev Returns the number of values in the set. O(1).
734      */
735     function length(Bytes32Set storage set) internal view returns (uint256) {
736         return _length(set._inner);
737     }
738 
739    /**
740     * @dev Returns the value stored at position `index` in the set. O(1).
741     *
742     * Note that there are no guarantees on the ordering of values inside the
743     * array, and it may change when more values are added or removed.
744     *
745     * Requirements:
746     *
747     * - `index` must be strictly less than {length}.
748     */
749     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
750         return _at(set._inner, index);
751     }
752 
753     // AddressSet
754 
755     struct AddressSet {
756         Set _inner;
757     }
758 
759     /**
760      * @dev Add a value to a set. O(1).
761      *
762      * Returns true if the value was added to the set, that is if it was not
763      * already present.
764      */
765     function add(AddressSet storage set, address value) internal returns (bool) {
766         return _add(set._inner, bytes32(uint256(uint160(value))));
767     }
768 
769     /**
770      * @dev Removes a value from a set. O(1).
771      *
772      * Returns true if the value was removed from the set, that is if it was
773      * present.
774      */
775     function remove(AddressSet storage set, address value) internal returns (bool) {
776         return _remove(set._inner, bytes32(uint256(uint160(value))));
777     }
778 
779     /**
780      * @dev Returns true if the value is in the set. O(1).
781      */
782     function contains(AddressSet storage set, address value) internal view returns (bool) {
783         return _contains(set._inner, bytes32(uint256(uint160(value))));
784     }
785 
786     /**
787      * @dev Returns the number of values in the set. O(1).
788      */
789     function length(AddressSet storage set) internal view returns (uint256) {
790         return _length(set._inner);
791     }
792 
793    /**
794     * @dev Returns the value stored at position `index` in the set. O(1).
795     *
796     * Note that there are no guarantees on the ordering of values inside the
797     * array, and it may change when more values are added or removed.
798     *
799     * Requirements:
800     *
801     * - `index` must be strictly less than {length}.
802     */
803     function at(AddressSet storage set, uint256 index) internal view returns (address) {
804         return address(uint160(uint256(_at(set._inner, index))));
805     }
806 
807 
808     // UintSet
809 
810     struct UintSet {
811         Set _inner;
812     }
813 
814     /**
815      * @dev Add a value to a set. O(1).
816      *
817      * Returns true if the value was added to the set, that is if it was not
818      * already present.
819      */
820     function add(UintSet storage set, uint256 value) internal returns (bool) {
821         return _add(set._inner, bytes32(value));
822     }
823 
824     /**
825      * @dev Removes a value from a set. O(1).
826      *
827      * Returns true if the value was removed from the set, that is if it was
828      * present.
829      */
830     function remove(UintSet storage set, uint256 value) internal returns (bool) {
831         return _remove(set._inner, bytes32(value));
832     }
833 
834     /**
835      * @dev Returns true if the value is in the set. O(1).
836      */
837     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
838         return _contains(set._inner, bytes32(value));
839     }
840 
841     /**
842      * @dev Returns the number of values on the set. O(1).
843      */
844     function length(UintSet storage set) internal view returns (uint256) {
845         return _length(set._inner);
846     }
847 
848    /**
849     * @dev Returns the value stored at position `index` in the set. O(1).
850     *
851     * Note that there are no guarantees on the ordering of values inside the
852     * array, and it may change when more values are added or removed.
853     *
854     * Requirements:
855     *
856     * - `index` must be strictly less than {length}.
857     */
858     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
859         return uint256(_at(set._inner, index));
860     }
861 }
862 
863 // File: @openzeppelin/contracts/utils/Context.sol
864 
865 
866 pragma solidity >=0.6.0 <0.8.0;
867 
868 /*
869  * @dev Provides information about the current execution context, including the
870  * sender of the transaction and its data. While these are generally available
871  * via msg.sender and msg.data, they should not be accessed in such a direct
872  * manner, since when dealing with GSN meta-transactions the account sending and
873  * paying for execution may not be the actual sender (as far as an application
874  * is concerned).
875  *
876  * This contract is only required for intermediate, library-like contracts.
877  */
878 abstract contract Context {
879     function _msgSender() internal view virtual returns (address payable) {
880         return msg.sender;
881     }
882 
883     function _msgData() internal view virtual returns (bytes memory) {
884         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
885         return msg.data;
886     }
887 }
888 
889 // File: @openzeppelin/contracts/access/Ownable.sol
890 
891 
892 pragma solidity >=0.6.0 <0.8.0;
893 
894 /**
895  * @dev Contract module which provides a basic access control mechanism, where
896  * there is an account (an owner) that can be granted exclusive access to
897  * specific functions.
898  *
899  * By default, the owner account will be the one that deploys the contract. This
900  * can later be changed with {transferOwnership}.
901  *
902  * This module is used through inheritance. It will make available the modifier
903  * `onlyOwner`, which can be applied to your functions to restrict their use to
904  * the owner.
905  */
906 abstract contract Ownable is Context {
907     address private _owner;
908 
909     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
910 
911     /**
912      * @dev Initializes the contract setting the deployer as the initial owner.
913      */
914     constructor () internal {
915         address msgSender = _msgSender();
916         _owner = msgSender;
917         emit OwnershipTransferred(address(0), msgSender);
918     }
919 
920     /**
921      * @dev Returns the address of the current owner.
922      */
923     function owner() public view virtual returns (address) {
924         return _owner;
925     }
926 
927     /**
928      * @dev Throws if called by any account other than the owner.
929      */
930     modifier onlyOwner() {
931         require(owner() == _msgSender(), "Ownable: caller is not the owner");
932         _;
933     }
934 
935     /**
936      * @dev Leaves the contract without owner. It will not be possible to call
937      * `onlyOwner` functions anymore. Can only be called by the current owner.
938      *
939      * NOTE: Renouncing ownership will leave the contract without an owner,
940      * thereby removing any functionality that is only available to the owner.
941      */
942     function renounceOwnership() public virtual onlyOwner {
943         emit OwnershipTransferred(_owner, address(0));
944         _owner = address(0);
945     }
946 
947     /**
948      * @dev Transfers ownership of the contract to a new account (`newOwner`).
949      * Can only be called by the current owner.
950      */
951     function transferOwnership(address newOwner) public virtual onlyOwner {
952         require(newOwner != address(0), "Ownable: new owner is the zero address");
953         emit OwnershipTransferred(_owner, newOwner);
954         _owner = newOwner;
955     }
956 }
957 
958 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
959 
960 
961 pragma solidity >=0.6.0 <0.8.0;
962 
963 
964 
965 
966 /**
967  * @dev Implementation of the {IERC20} interface.
968  *
969  * This implementation is agnostic to the way tokens are created. This means
970  * that a supply mechanism has to be added in a derived contract using {_mint}.
971  * For a generic mechanism see {ERC20PresetMinterPauser}.
972  *
973  * TIP: For a detailed writeup see our guide
974  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
975  * to implement supply mechanisms].
976  *
977  * We have followed general OpenZeppelin guidelines: functions revert instead
978  * of returning `false` on failure. This behavior is nonetheless conventional
979  * and does not conflict with the expectations of ERC20 applications.
980  *
981  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
982  * This allows applications to reconstruct the allowance for all accounts just
983  * by listening to said events. Other implementations of the EIP may not emit
984  * these events, as it isn't required by the specification.
985  *
986  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
987  * functions have been added to mitigate the well-known issues around setting
988  * allowances. See {IERC20-approve}.
989  */
990 contract ERC20 is Context, IERC20 {
991     using SafeMath for uint256;
992 
993     mapping (address => uint256) private _balances;
994 
995     mapping (address => mapping (address => uint256)) private _allowances;
996 
997     uint256 private _totalSupply;
998 
999     string private _name;
1000     string private _symbol;
1001     uint8 private _decimals;
1002 
1003     /**
1004      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1005      * a default value of 18.
1006      *
1007      * To select a different value for {decimals}, use {_setupDecimals}.
1008      *
1009      * All three of these values are immutable: they can only be set once during
1010      * construction.
1011      */
1012     constructor (string memory name_, string memory symbol_) public {
1013         _name = name_;
1014         _symbol = symbol_;
1015         _decimals = 18;
1016     }
1017 
1018     /**
1019      * @dev Returns the name of the token.
1020      */
1021     function name() public view virtual returns (string memory) {
1022         return _name;
1023     }
1024 
1025     /**
1026      * @dev Returns the symbol of the token, usually a shorter version of the
1027      * name.
1028      */
1029     function symbol() public view virtual returns (string memory) {
1030         return _symbol;
1031     }
1032 
1033     /**
1034      * @dev Returns the number of decimals used to get its user representation.
1035      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1036      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1037      *
1038      * Tokens usually opt for a value of 18, imitating the relationship between
1039      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1040      * called.
1041      *
1042      * NOTE: This information is only used for _display_ purposes: it in
1043      * no way affects any of the arithmetic of the contract, including
1044      * {IERC20-balanceOf} and {IERC20-transfer}.
1045      */
1046     function decimals() public view virtual returns (uint8) {
1047         return _decimals;
1048     }
1049 
1050     /**
1051      * @dev See {IERC20-totalSupply}.
1052      */
1053     function totalSupply() public view virtual override returns (uint256) {
1054         return _totalSupply;
1055     }
1056 
1057     /**
1058      * @dev See {IERC20-balanceOf}.
1059      */
1060     function balanceOf(address account) public view virtual override returns (uint256) {
1061         return _balances[account];
1062     }
1063 
1064     /**
1065      * @dev See {IERC20-transfer}.
1066      *
1067      * Requirements:
1068      *
1069      * - `recipient` cannot be the zero address.
1070      * - the caller must have a balance of at least `amount`.
1071      */
1072     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1073         _transfer(_msgSender(), recipient, amount);
1074         return true;
1075     }
1076 
1077     /**
1078      * @dev See {IERC20-allowance}.
1079      */
1080     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1081         return _allowances[owner][spender];
1082     }
1083 
1084     /**
1085      * @dev See {IERC20-approve}.
1086      *
1087      * Requirements:
1088      *
1089      * - `spender` cannot be the zero address.
1090      */
1091     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1092         _approve(_msgSender(), spender, amount);
1093         return true;
1094     }
1095 
1096     /**
1097      * @dev See {IERC20-transferFrom}.
1098      *
1099      * Emits an {Approval} event indicating the updated allowance. This is not
1100      * required by the EIP. See the note at the beginning of {ERC20}.
1101      *
1102      * Requirements:
1103      *
1104      * - `sender` and `recipient` cannot be the zero address.
1105      * - `sender` must have a balance of at least `amount`.
1106      * - the caller must have allowance for ``sender``'s tokens of at least
1107      * `amount`.
1108      */
1109     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1110         _transfer(sender, recipient, amount);
1111         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1112         return true;
1113     }
1114 
1115     /**
1116      * @dev Atomically increases the allowance granted to `spender` by the caller.
1117      *
1118      * This is an alternative to {approve} that can be used as a mitigation for
1119      * problems described in {IERC20-approve}.
1120      *
1121      * Emits an {Approval} event indicating the updated allowance.
1122      *
1123      * Requirements:
1124      *
1125      * - `spender` cannot be the zero address.
1126      */
1127     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1128         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1129         return true;
1130     }
1131 
1132     /**
1133      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1134      *
1135      * This is an alternative to {approve} that can be used as a mitigation for
1136      * problems described in {IERC20-approve}.
1137      *
1138      * Emits an {Approval} event indicating the updated allowance.
1139      *
1140      * Requirements:
1141      *
1142      * - `spender` cannot be the zero address.
1143      * - `spender` must have allowance for the caller of at least
1144      * `subtractedValue`.
1145      */
1146     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1147         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1148         return true;
1149     }
1150 
1151     /**
1152      * @dev Moves tokens `amount` from `sender` to `recipient`.
1153      *
1154      * This is internal function is equivalent to {transfer}, and can be used to
1155      * e.g. implement automatic token fees, slashing mechanisms, etc.
1156      *
1157      * Emits a {Transfer} event.
1158      *
1159      * Requirements:
1160      *
1161      * - `sender` cannot be the zero address.
1162      * - `recipient` cannot be the zero address.
1163      * - `sender` must have a balance of at least `amount`.
1164      */
1165     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1166         require(sender != address(0), "ERC20: transfer from the zero address");
1167         require(recipient != address(0), "ERC20: transfer to the zero address");
1168 
1169         _beforeTokenTransfer(sender, recipient, amount);
1170 
1171         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1172         _balances[recipient] = _balances[recipient].add(amount);
1173         emit Transfer(sender, recipient, amount);
1174     }
1175 
1176     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1177      * the total supply.
1178      *
1179      * Emits a {Transfer} event with `from` set to the zero address.
1180      *
1181      * Requirements:
1182      *
1183      * - `to` cannot be the zero address.
1184      */
1185     function _mint(address account, uint256 amount) internal virtual {
1186         require(account != address(0), "ERC20: mint to the zero address");
1187 
1188         _beforeTokenTransfer(address(0), account, amount);
1189 
1190         _totalSupply = _totalSupply.add(amount);
1191         _balances[account] = _balances[account].add(amount);
1192         emit Transfer(address(0), account, amount);
1193     }
1194 
1195     /**
1196      * @dev Destroys `amount` tokens from `account`, reducing the
1197      * total supply.
1198      *
1199      * Emits a {Transfer} event with `to` set to the zero address.
1200      *
1201      * Requirements:
1202      *
1203      * - `account` cannot be the zero address.
1204      * - `account` must have at least `amount` tokens.
1205      */
1206     function _burn(address account, uint256 amount) internal virtual {
1207         require(account != address(0), "ERC20: burn from the zero address");
1208 
1209         _beforeTokenTransfer(account, address(0), amount);
1210 
1211         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1212         _totalSupply = _totalSupply.sub(amount);
1213         emit Transfer(account, address(0), amount);
1214     }
1215 
1216     /**
1217      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1218      *
1219      * This internal function is equivalent to `approve`, and can be used to
1220      * e.g. set automatic allowances for certain subsystems, etc.
1221      *
1222      * Emits an {Approval} event.
1223      *
1224      * Requirements:
1225      *
1226      * - `owner` cannot be the zero address.
1227      * - `spender` cannot be the zero address.
1228      */
1229     function _approve(address owner, address spender, uint256 amount) internal virtual {
1230         require(owner != address(0), "ERC20: approve from the zero address");
1231         require(spender != address(0), "ERC20: approve to the zero address");
1232 
1233         _allowances[owner][spender] = amount;
1234         emit Approval(owner, spender, amount);
1235     }
1236 
1237     /**
1238      * @dev Sets {decimals} to a value other than the default one of 18.
1239      *
1240      * WARNING: This function should only be called from the constructor. Most
1241      * applications that interact with token contracts will not expect
1242      * {decimals} to ever change, and may work incorrectly if it does.
1243      */
1244     function _setupDecimals(uint8 decimals_) internal virtual {
1245         _decimals = decimals_;
1246     }
1247 
1248     /**
1249      * @dev Hook that is called before any transfer of tokens. This includes
1250      * minting and burning.
1251      *
1252      * Calling conditions:
1253      *
1254      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1255      * will be to transferred to `to`.
1256      * - when `from` is zero, `amount` tokens will be minted for `to`.
1257      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1258      * - `from` and `to` are never both zero.
1259      *
1260      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1261      */
1262     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1263 }
1264 
1265 // File: contracts/BDPToken.sol
1266 
1267 
1268 pragma solidity 0.6.12;
1269 
1270 
1271 
1272 
1273 contract BDPToken is ERC20("BDPToken", "BDP"), Ownable {
1274     using SafeMath for uint256;
1275 
1276     uint256 public NUMBER_BLOCKS_PER_DAY;
1277     uint256 public cap = 80000000e18 + 1e18;
1278     address public BDPMaster;
1279     address public BDPMasterPending;
1280     uint public setBDPMasterPendingAtBlock;
1281 
1282     uint256 public seedPoolAmount = 24000000e18;
1283 
1284     uint256 constant public PARTNERSHIP_TOTAL_AMOUNT = 20000000e18;
1285     uint256 constant public PARTNERSHIP_FIRST_MINT = 8000000e18;
1286     uint256 public partnershipAmount = PARTNERSHIP_TOTAL_AMOUNT;
1287     uint256 public partnershipMintedAtBlock = 0;
1288 
1289     uint256 constant public TEAM_TOTAL_AMOUNT = 8000000e18;
1290     uint256 public teamAmount = TEAM_TOTAL_AMOUNT;
1291     uint256 public teamMintedAtBlock = 0;
1292 
1293     uint256 constant public FUTURE_TOTAL_AMOUNT = 28000000e18;
1294     uint256 constant public FUTURE_EACH_MINT = 9333333e18;
1295     uint256 public futureAmount = FUTURE_TOTAL_AMOUNT;
1296     uint256 public futureCanMintAtBlock = 0;
1297 
1298     uint256 public startAtBlock;
1299 
1300     constructor (uint _startAtBlock, uint _numberBlockPerDay, address _sendTo) public {
1301         startAtBlock = _startAtBlock;
1302         NUMBER_BLOCKS_PER_DAY = _numberBlockPerDay > 0 ? _numberBlockPerDay : 6000;
1303         _mint(_sendTo, 1e18);
1304     }
1305     
1306     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1307         super._beforeTokenTransfer(from, to, amount);
1308 
1309         if (from == address(0)) {
1310             require(totalSupply().add(amount) <= cap, "BDPToken: cap exceeded");
1311         }
1312     }
1313 
1314     function setPendingMaster(address _BDPMaster) public onlyOwner {
1315         BDPMasterPending = _BDPMaster;
1316         setBDPMasterPendingAtBlock = block.number;
1317     }
1318 
1319     function confirmMaster() public onlyOwner {
1320         require(block.number - setBDPMasterPendingAtBlock > 2 * NUMBER_BLOCKS_PER_DAY, "BDPToken: cannot confirm at this time");
1321         BDPMaster = BDPMasterPending;
1322     }
1323 
1324     function setMaster(address _BDPMaster) public onlyOwner {
1325         require(BDPMaster == address(0x0), "BDPToken: Cannot set master");
1326         BDPMaster = _BDPMaster;
1327     }
1328 
1329     function mint(address _to, uint256 _amount) public {
1330         require(msg.sender == BDPMaster, "BDPToken: only master farmer can mint");
1331         require(seedPoolAmount > 0, "BDPToken: cannot mint for pool");
1332         require(seedPoolAmount >= _amount, "BDPToken: amount greater than limitation");
1333         seedPoolAmount = seedPoolAmount.sub(_amount);
1334         _mint(_to, _amount);
1335     }
1336 
1337     function mintForPartnership(address _to) public onlyOwner {
1338         uint amount;
1339 
1340         require(block.number >= startAtBlock + 7 * NUMBER_BLOCKS_PER_DAY, "BDPToken: Cannot mint at this time");
1341         require(partnershipAmount > 0, "BDPToken: Cannot mint more token for partnership");
1342 
1343         // This first minting
1344         if (partnershipMintedAtBlock == 0) {
1345             amount = PARTNERSHIP_FIRST_MINT;
1346             partnershipMintedAtBlock = startAtBlock + 7 * NUMBER_BLOCKS_PER_DAY;
1347         }
1348         else {
1349             amount = PARTNERSHIP_TOTAL_AMOUNT
1350                 .sub(PARTNERSHIP_FIRST_MINT)
1351                 .mul(block.number - partnershipMintedAtBlock)
1352                 .div(270 * NUMBER_BLOCKS_PER_DAY);
1353             partnershipMintedAtBlock = block.number;
1354         }
1355 
1356         amount = amount < partnershipAmount ? amount : partnershipAmount;
1357 
1358         partnershipAmount = partnershipAmount.sub(amount);
1359         _mint(_to, amount);
1360     }
1361 
1362     function mintForTeam(address _to) public onlyOwner {
1363         uint amount;
1364 
1365         require(block.number >= startAtBlock + 7 * NUMBER_BLOCKS_PER_DAY, "BDPToken: Cannot mint at this time");
1366         require(teamAmount > 0, "BDPToken: Cannot mint more token for team");
1367         // This first minting
1368         if (teamMintedAtBlock == 0) {
1369             teamMintedAtBlock = startAtBlock + 7 * NUMBER_BLOCKS_PER_DAY;
1370         }
1371         amount = TEAM_TOTAL_AMOUNT
1372             .mul(block.number - teamMintedAtBlock)
1373             .div(270 * NUMBER_BLOCKS_PER_DAY);
1374         teamMintedAtBlock = block.number;
1375 
1376         amount = amount < teamAmount ? amount : teamAmount;
1377 
1378         teamAmount = teamAmount.sub(amount);
1379         _mint(_to, amount);
1380     }
1381 
1382     function mintForFutureFarming(address _to) public onlyOwner {
1383         require(block.number >= startAtBlock + 56 * NUMBER_BLOCKS_PER_DAY, "BDPToken: Cannot mint at this time");
1384         require(futureAmount > 0, "BDPToken: Cannot mint more token for future farming");
1385 
1386 
1387         if (block.number >= startAtBlock + 56 * NUMBER_BLOCKS_PER_DAY 
1388             && futureAmount >= FUTURE_TOTAL_AMOUNT) {
1389             _mint(_to, FUTURE_EACH_MINT);
1390             futureAmount = futureAmount.sub(FUTURE_EACH_MINT);
1391         }
1392 
1393         if (block.number >= startAtBlock + 86 * NUMBER_BLOCKS_PER_DAY 
1394             && futureAmount >= FUTURE_TOTAL_AMOUNT.sub(FUTURE_EACH_MINT)) {
1395             _mint(_to, FUTURE_EACH_MINT);
1396             futureAmount = futureAmount.sub(FUTURE_EACH_MINT);
1397         }
1398 
1399         if (block.number >= startAtBlock + 116 * NUMBER_BLOCKS_PER_DAY
1400             && futureAmount > 0) {
1401             _mint(_to, futureAmount);
1402             futureAmount = 0;
1403         }
1404     }
1405 }
1406 
1407 // File: contracts/BDPMaster.sol
1408 
1409 pragma solidity 0.6.12;
1410 
1411 
1412 
1413 
1414 
1415 
1416 
1417 contract BDPMaster is Ownable {
1418     using SafeMath for uint256;
1419     using SafeERC20 for IERC20;
1420 
1421     struct UserInfo {
1422         uint256 amount;     // How many LP tokens the user has provided.
1423         uint256 rewardDebt; // Reward debt. See explanation below.
1424     }
1425 
1426     // Info of each pool.
1427     struct PoolInfo {
1428         IERC20 lpToken;
1429         uint256 allocPoint;
1430         uint256 lastRewardBlock;
1431         uint256 rewardPerShare;
1432     }
1433 
1434     BDPToken public BDP;
1435     
1436     uint256 public REWARD_PER_BLOCK;
1437     uint256 public START_BLOCK;
1438 
1439     // Info of each pool.
1440     PoolInfo[] public poolInfo;
1441     mapping(address => uint256) public poolId1; // poolId1 count from 1, subtraction 1 before using with poolInfo
1442     // Info of each user that stakes LP tokens. pid => user address => info
1443     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1444     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1445     uint256 public totalAllocPoint = 0;
1446 
1447     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1448     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1449     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1450     event SendReward(address indexed user, uint256 indexed pid, uint256 amount);
1451 
1452     constructor(
1453         BDPToken _BDP,
1454         uint256 _rewardPerBlock,
1455         uint256 _startBlock
1456     ) public {
1457         BDP = _BDP;
1458         REWARD_PER_BLOCK = _rewardPerBlock;
1459         START_BLOCK = _startBlock;
1460     }
1461 
1462     // -------- For manage pool ---------
1463     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1464         require(poolId1[address(_lpToken)] == 0, "BDPMaster::add: lp is already in pool");
1465         if (_withUpdate) {
1466             massUpdatePools();
1467         }
1468         uint256 lastRewardBlock = block.number > START_BLOCK ? block.number : START_BLOCK;
1469         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1470         poolId1[address(_lpToken)] = poolInfo.length + 1;
1471         poolInfo.push(PoolInfo({
1472             lpToken: _lpToken,
1473             allocPoint: _allocPoint,
1474             lastRewardBlock: lastRewardBlock,
1475             rewardPerShare: 0
1476         }));
1477     }
1478 
1479     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1480         if (_withUpdate) {
1481             massUpdatePools();
1482         }
1483         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1484         poolInfo[_pid].allocPoint = _allocPoint;
1485     }
1486 
1487     function massUpdatePools() public {
1488         uint256 length = poolInfo.length;
1489         for (uint256 pid = 0; pid < length; ++pid) {
1490             updatePool(pid);
1491         }
1492     }
1493 
1494     function updatePool(uint256 _pid) public {
1495         PoolInfo storage pool = poolInfo[_pid];
1496         if (block.number <= pool.lastRewardBlock) {
1497             return;
1498         }
1499         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1500         if (lpSupply == 0) {
1501             pool.lastRewardBlock = block.number;
1502             return;
1503         }
1504         uint256 reward = getPoolReward(pool.lastRewardBlock, block.number, pool.allocPoint);
1505         
1506         BDP.mint(address(this), reward);
1507         pool.rewardPerShare = pool.rewardPerShare.add(reward.mul(1e12).div(lpSupply));
1508         pool.lastRewardBlock = block.number;
1509     }
1510 
1511     function deposit(uint256 _pid, uint256 _amount) public {
1512         PoolInfo storage pool = poolInfo[_pid];
1513         UserInfo storage user = userInfo[_pid][msg.sender];
1514         updatePool(_pid);
1515         if (user.amount > 0) {
1516             uint256 pending = user.amount.mul(pool.rewardPerShare).div(1e12).sub(user.rewardDebt);
1517             if(pending > 0) {
1518                 safeTransferReward(msg.sender, pending);
1519             }
1520         }
1521         if(_amount > 0) {
1522             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1523             user.amount = user.amount.add(_amount);
1524         }
1525         user.rewardDebt = user.amount.mul(pool.rewardPerShare).div(1e12);
1526         emit Deposit(msg.sender, _pid, _amount);
1527     }
1528 
1529     function withdraw(uint256 _pid, uint256 _amount) public {
1530         PoolInfo storage pool = poolInfo[_pid];
1531         UserInfo storage user = userInfo[_pid][msg.sender];
1532         require(user.amount >= _amount, "withdraw: not good");
1533         updatePool(_pid);
1534         uint256 pending = user.amount.mul(pool.rewardPerShare).div(1e12).sub(user.rewardDebt);
1535         if(pending > 0) {
1536             safeTransferReward(msg.sender, pending);
1537         }
1538         if(_amount > 0) {
1539             user.amount = user.amount.sub(_amount);
1540             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1541         }
1542         user.rewardDebt = user.amount.mul(pool.rewardPerShare).div(1e12);
1543         emit Withdraw(msg.sender, _pid, _amount);
1544     }
1545 
1546     function claimReward(uint256 _pid) public {
1547         deposit(_pid, 0);
1548     }
1549 
1550     function safeTransferReward(address _to, uint256 _amount) internal {
1551         uint256 bal = BDP.balanceOf(address(this));
1552         if (_amount > bal) {
1553             BDP.transfer(_to, bal);
1554         } else {
1555             BDP.transfer(_to, _amount);
1556         }
1557     }
1558 
1559     // Withdraw without caring about rewards. EMERGENCY ONLY.
1560     function emergencyWithdraw(uint256 _pid) public {
1561         PoolInfo storage pool = poolInfo[_pid];
1562         UserInfo storage user = userInfo[_pid][msg.sender];
1563         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1564         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1565         user.amount = 0;
1566         user.rewardDebt = 0;
1567     }
1568 
1569     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
1570         return _to.sub(_from);
1571     }
1572 
1573     function getPoolReward(uint256 _from, uint256 _to, uint256 _allocPoint) public view returns (uint) {
1574         uint256 multiplier = getMultiplier(_from, _to);
1575         uint256 amount = multiplier.mul(REWARD_PER_BLOCK).mul(_allocPoint).div(totalAllocPoint);
1576         uint256 amountCanMint = BDP.seedPoolAmount();
1577         return amountCanMint < amount ? amountCanMint : amount;
1578     }
1579 
1580     function getNewRewardPerBlock(uint256 pid1) public view returns (uint256) {
1581         uint256 multiplier = getMultiplier(block.number -1, block.number);
1582         if (pid1 == 0) {
1583             return multiplier.mul(REWARD_PER_BLOCK);
1584         }
1585         else {
1586             return multiplier
1587                 .mul(REWARD_PER_BLOCK)
1588                 .mul(poolInfo[pid1 - 1].allocPoint)
1589                 .div(totalAllocPoint);
1590         }
1591     }
1592 
1593     function pendingReward(uint256 _pid, address _user) external view returns (uint256) {
1594         PoolInfo storage pool = poolInfo[_pid];
1595         UserInfo storage user = userInfo[_pid][_user];
1596         uint256 rewardPerShare = pool.rewardPerShare;
1597         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1598         if (block.number > pool.lastRewardBlock && lpSupply > 0) {
1599             uint256 reward = getPoolReward(pool.lastRewardBlock, block.number, pool.allocPoint);
1600             rewardPerShare = rewardPerShare.add(reward.mul(1e12).div(lpSupply));
1601         }
1602         return user.amount.mul(rewardPerShare).div(1e12).sub(user.rewardDebt);
1603     }
1604 
1605     function poolLength() external view returns (uint256) {
1606         return poolInfo.length;
1607     }
1608 
1609     function getStakedAmount(uint _pid, address _user) public view returns (uint256) {
1610         UserInfo storage user = userInfo[_pid][_user];
1611         return user.amount;
1612     }
1613 }