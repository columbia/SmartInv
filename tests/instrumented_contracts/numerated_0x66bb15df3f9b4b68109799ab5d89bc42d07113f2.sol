1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
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
80 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
81 
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
297 
298 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
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
490 
491 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
492 
493 
494 
495 pragma solidity >=0.6.0 <0.8.0;
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
567 
568 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
569 
570 
571 
572 pragma solidity >=0.6.0 <0.8.0;
573 
574 /**
575  * @dev Library for managing
576  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
577  * types.
578  *
579  * Sets have the following properties:
580  *
581  * - Elements are added, removed, and checked for existence in constant time
582  * (O(1)).
583  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
584  *
585  * ```
586  * contract Example {
587  *     // Add the library methods
588  *     using EnumerableSet for EnumerableSet.AddressSet;
589  *
590  *     // Declare a set state variable
591  *     EnumerableSet.AddressSet private mySet;
592  * }
593  * ```
594  *
595  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
596  * and `uint256` (`UintSet`) are supported.
597  */
598 library EnumerableSet {
599     // To implement this library for multiple types with as little code
600     // repetition as possible, we write it in terms of a generic Set type with
601     // bytes32 values.
602     // The Set implementation uses private functions, and user-facing
603     // implementations (such as AddressSet) are just wrappers around the
604     // underlying Set.
605     // This means that we can only create new EnumerableSets for types that fit
606     // in bytes32.
607 
608     struct Set {
609         // Storage of set values
610         bytes32[] _values;
611 
612         // Position of the value in the `values` array, plus 1 because index 0
613         // means a value is not in the set.
614         mapping (bytes32 => uint256) _indexes;
615     }
616 
617     /**
618      * @dev Add a value to a set. O(1).
619      *
620      * Returns true if the value was added to the set, that is if it was not
621      * already present.
622      */
623     function _add(Set storage set, bytes32 value) private returns (bool) {
624         if (!_contains(set, value)) {
625             set._values.push(value);
626             // The value is stored at length-1, but we add 1 to all indexes
627             // and use 0 as a sentinel value
628             set._indexes[value] = set._values.length;
629             return true;
630         } else {
631             return false;
632         }
633     }
634 
635     /**
636      * @dev Removes a value from a set. O(1).
637      *
638      * Returns true if the value was removed from the set, that is if it was
639      * present.
640      */
641     function _remove(Set storage set, bytes32 value) private returns (bool) {
642         // We read and store the value's index to prevent multiple reads from the same storage slot
643         uint256 valueIndex = set._indexes[value];
644 
645         if (valueIndex != 0) { // Equivalent to contains(set, value)
646             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
647             // the array, and then remove the last element (sometimes called as 'swap and pop').
648             // This modifies the order of the array, as noted in {at}.
649 
650             uint256 toDeleteIndex = valueIndex - 1;
651             uint256 lastIndex = set._values.length - 1;
652 
653             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
654             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
655 
656             bytes32 lastvalue = set._values[lastIndex];
657 
658             // Move the last value to the index where the value to delete is
659             set._values[toDeleteIndex] = lastvalue;
660             // Update the index for the moved value
661             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
662 
663             // Delete the slot where the moved value was stored
664             set._values.pop();
665 
666             // Delete the index for the deleted slot
667             delete set._indexes[value];
668 
669             return true;
670         } else {
671             return false;
672         }
673     }
674 
675     /**
676      * @dev Returns true if the value is in the set. O(1).
677      */
678     function _contains(Set storage set, bytes32 value) private view returns (bool) {
679         return set._indexes[value] != 0;
680     }
681 
682     /**
683      * @dev Returns the number of values on the set. O(1).
684      */
685     function _length(Set storage set) private view returns (uint256) {
686         return set._values.length;
687     }
688 
689    /**
690     * @dev Returns the value stored at position `index` in the set. O(1).
691     *
692     * Note that there are no guarantees on the ordering of values inside the
693     * array, and it may change when more values are added or removed.
694     *
695     * Requirements:
696     *
697     * - `index` must be strictly less than {length}.
698     */
699     function _at(Set storage set, uint256 index) private view returns (bytes32) {
700         require(set._values.length > index, "EnumerableSet: index out of bounds");
701         return set._values[index];
702     }
703 
704     // Bytes32Set
705 
706     struct Bytes32Set {
707         Set _inner;
708     }
709 
710     /**
711      * @dev Add a value to a set. O(1).
712      *
713      * Returns true if the value was added to the set, that is if it was not
714      * already present.
715      */
716     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
717         return _add(set._inner, value);
718     }
719 
720     /**
721      * @dev Removes a value from a set. O(1).
722      *
723      * Returns true if the value was removed from the set, that is if it was
724      * present.
725      */
726     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
727         return _remove(set._inner, value);
728     }
729 
730     /**
731      * @dev Returns true if the value is in the set. O(1).
732      */
733     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
734         return _contains(set._inner, value);
735     }
736 
737     /**
738      * @dev Returns the number of values in the set. O(1).
739      */
740     function length(Bytes32Set storage set) internal view returns (uint256) {
741         return _length(set._inner);
742     }
743 
744    /**
745     * @dev Returns the value stored at position `index` in the set. O(1).
746     *
747     * Note that there are no guarantees on the ordering of values inside the
748     * array, and it may change when more values are added or removed.
749     *
750     * Requirements:
751     *
752     * - `index` must be strictly less than {length}.
753     */
754     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
755         return _at(set._inner, index);
756     }
757 
758     // AddressSet
759 
760     struct AddressSet {
761         Set _inner;
762     }
763 
764     /**
765      * @dev Add a value to a set. O(1).
766      *
767      * Returns true if the value was added to the set, that is if it was not
768      * already present.
769      */
770     function add(AddressSet storage set, address value) internal returns (bool) {
771         return _add(set._inner, bytes32(uint256(uint160(value))));
772     }
773 
774     /**
775      * @dev Removes a value from a set. O(1).
776      *
777      * Returns true if the value was removed from the set, that is if it was
778      * present.
779      */
780     function remove(AddressSet storage set, address value) internal returns (bool) {
781         return _remove(set._inner, bytes32(uint256(uint160(value))));
782     }
783 
784     /**
785      * @dev Returns true if the value is in the set. O(1).
786      */
787     function contains(AddressSet storage set, address value) internal view returns (bool) {
788         return _contains(set._inner, bytes32(uint256(uint160(value))));
789     }
790 
791     /**
792      * @dev Returns the number of values in the set. O(1).
793      */
794     function length(AddressSet storage set) internal view returns (uint256) {
795         return _length(set._inner);
796     }
797 
798    /**
799     * @dev Returns the value stored at position `index` in the set. O(1).
800     *
801     * Note that there are no guarantees on the ordering of values inside the
802     * array, and it may change when more values are added or removed.
803     *
804     * Requirements:
805     *
806     * - `index` must be strictly less than {length}.
807     */
808     function at(AddressSet storage set, uint256 index) internal view returns (address) {
809         return address(uint160(uint256(_at(set._inner, index))));
810     }
811 
812 
813     // UintSet
814 
815     struct UintSet {
816         Set _inner;
817     }
818 
819     /**
820      * @dev Add a value to a set. O(1).
821      *
822      * Returns true if the value was added to the set, that is if it was not
823      * already present.
824      */
825     function add(UintSet storage set, uint256 value) internal returns (bool) {
826         return _add(set._inner, bytes32(value));
827     }
828 
829     /**
830      * @dev Removes a value from a set. O(1).
831      *
832      * Returns true if the value was removed from the set, that is if it was
833      * present.
834      */
835     function remove(UintSet storage set, uint256 value) internal returns (bool) {
836         return _remove(set._inner, bytes32(value));
837     }
838 
839     /**
840      * @dev Returns true if the value is in the set. O(1).
841      */
842     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
843         return _contains(set._inner, bytes32(value));
844     }
845 
846     /**
847      * @dev Returns the number of values on the set. O(1).
848      */
849     function length(UintSet storage set) internal view returns (uint256) {
850         return _length(set._inner);
851     }
852 
853    /**
854     * @dev Returns the value stored at position `index` in the set. O(1).
855     *
856     * Note that there are no guarantees on the ordering of values inside the
857     * array, and it may change when more values are added or removed.
858     *
859     * Requirements:
860     *
861     * - `index` must be strictly less than {length}.
862     */
863     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
864         return uint256(_at(set._inner, index));
865     }
866 }
867 
868 
869 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
870 
871 
872 
873 pragma solidity >=0.6.0 <0.8.0;
874 
875 /*
876  * @dev Provides information about the current execution context, including the
877  * sender of the transaction and its data. While these are generally available
878  * via msg.sender and msg.data, they should not be accessed in such a direct
879  * manner, since when dealing with GSN meta-transactions the account sending and
880  * paying for execution may not be the actual sender (as far as an application
881  * is concerned).
882  *
883  * This contract is only required for intermediate, library-like contracts.
884  */
885 abstract contract Context {
886     function _msgSender() internal view virtual returns (address payable) {
887         return msg.sender;
888     }
889 
890     function _msgData() internal view virtual returns (bytes memory) {
891         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
892         return msg.data;
893     }
894 }
895 
896 
897 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
898 
899 
900 
901 pragma solidity >=0.6.0 <0.8.0;
902 
903 /**
904  * @dev Contract module which provides a basic access control mechanism, where
905  * there is an account (an owner) that can be granted exclusive access to
906  * specific functions.
907  *
908  * By default, the owner account will be the one that deploys the contract. This
909  * can later be changed with {transferOwnership}.
910  *
911  * This module is used through inheritance. It will make available the modifier
912  * `onlyOwner`, which can be applied to your functions to restrict their use to
913  * the owner.
914  */
915 abstract contract Ownable is Context {
916     address private _owner;
917 
918     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
919 
920     /**
921      * @dev Initializes the contract setting the deployer as the initial owner.
922      */
923     constructor () internal {
924         address msgSender = _msgSender();
925         _owner = msgSender;
926         emit OwnershipTransferred(address(0), msgSender);
927     }
928 
929     /**
930      * @dev Returns the address of the current owner.
931      */
932     function owner() public view virtual returns (address) {
933         return _owner;
934     }
935 
936     /**
937      * @dev Throws if called by any account other than the owner.
938      */
939     modifier onlyOwner() {
940         require(owner() == _msgSender(), "Ownable: caller is not the owner");
941         _;
942     }
943 
944     /**
945      * @dev Leaves the contract without owner. It will not be possible to call
946      * `onlyOwner` functions anymore. Can only be called by the current owner.
947      *
948      * NOTE: Renouncing ownership will leave the contract without an owner,
949      * thereby removing any functionality that is only available to the owner.
950      */
951     function renounceOwnership() public virtual onlyOwner {
952         emit OwnershipTransferred(_owner, address(0));
953         _owner = address(0);
954     }
955 
956     /**
957      * @dev Transfers ownership of the contract to a new account (`newOwner`).
958      * Can only be called by the current owner.
959      */
960     function transferOwnership(address newOwner) public virtual onlyOwner {
961         require(newOwner != address(0), "Ownable: new owner is the zero address");
962         emit OwnershipTransferred(_owner, newOwner);
963         _owner = newOwner;
964     }
965 }
966 
967 
968 // File contracts/interface/ICC.sol
969 
970 
971 pragma solidity ^0.6.0;
972 
973 interface ICC is IERC20 {
974     function mint(address to, uint256 amount) external returns (bool);
975 }
976 
977 
978 // File contracts/main/MasterChefV2.sol
979 
980 
981 
982 pragma solidity 0.6.12;
983 
984 
985 
986 
987 
988 
989 interface IMigratorChef {
990     // Perform LP token migration from legacy UniswapV2 to CCSwap.
991     // Take the current LP token address and return the new LP token address.
992     // Migrator should have full access to the caller's LP token.
993     // Return the new LP token address.
994     //
995     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
996     // CCSwap must mint EXACTLY the same amount of CCSwap LP tokens or
997     // else something bad will happen. Traditional UniswapV2 does not
998     // do that so be careful!
999     function migrate(IERC20 token) external returns (IERC20);
1000 }
1001 
1002 interface IMasterChef {
1003     function pending(uint256 pid, address user) external view returns (uint256);
1004 
1005     function deposit(uint256 pid, uint256 amount) external;
1006 
1007     function withdraw(uint256 pid, uint256 amount) external;
1008 
1009     function emergencyWithdraw(uint256 pid) external;
1010 }
1011 
1012 // MasterChef is the master of CC. He can make CC and he is a fair guy.
1013 //
1014 // Note that it's ownable and the owner wields tremendous power. The ownership
1015 // will be transferred to a governance smart contract once CC is sufficiently
1016 // distributed and the community can show to govern itself.
1017 //
1018 // Have fun reading it. Hopefully it's bug-free. God bless.
1019 contract MasterChef is Ownable {
1020     using SafeMath for uint256;
1021     using SafeERC20 for IERC20;
1022 
1023     // Info of each user.
1024     struct UserInfo {
1025         uint256 amount;     // How many LP tokens the user has provided.
1026         uint256 rewardDebt; // Reward debt. See explanation below.
1027         //
1028         // We do some fancy math here. Basically, any point in time, the amount of CCs
1029         // entitled to a user but is pending to be distributed is:
1030         //
1031         //   pending reward = (user.amount * pool.accCCPerShare) - user.rewardDebt
1032         //
1033         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1034         //   1. The pool's `accCCPerShare` (and `lastRewardBlock`) gets updated.
1035         //   2. User receives the pending reward sent to his/her address.
1036         //   3. User's `amount` gets updated.
1037         //   4. User's `rewardDebt` gets updated.
1038     }
1039 
1040     // Info of each pool.
1041     struct PoolInfo {
1042         IERC20 lpToken;           // Address of LP token contract.
1043         uint256 allocPoint;       // How many allocation points assigned to this pool. CCs to distribute per block.
1044         uint256 lastRewardBlock;  // Last block number that CCs distribution occurs.
1045         uint256 accCCPerShare; // Accumulated CCs per share, times 1e12. See below.
1046         uint256 totalAmount; // The total amount of lpTokens;
1047     }
1048 
1049     // The CC TOKEN!
1050     ICC public cc;
1051     // Block number when bonus CC period ends.
1052     uint256 public bonusEndBlock;
1053     // CC tokens created per block.
1054     uint256 public ccPerBlock;
1055     // Bonus muliplier for early cc makers.
1056     uint256 public constant BONUS_MULTIPLIER = 10;
1057     // For pause check
1058     bool public paused = false;
1059     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1060     IMigratorChef public migrator;
1061 
1062     // Info of each pool.
1063     PoolInfo[] public poolInfo;
1064     // Info of each user that stakes LP tokens.
1065     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1066     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1067     uint256 public totalAllocPoint = 0;
1068     // The block number when CC mining starts.
1069     uint256 public startBlock;
1070 
1071     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1072     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1073     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1074 
1075     constructor(
1076         ICC _cc,
1077         uint256 _ccPerBlock,
1078         uint256 _startBlock,
1079         uint256 _bonusEndBlock
1080     ) public {
1081         cc = _cc;
1082         ccPerBlock = _ccPerBlock;
1083         bonusEndBlock = _bonusEndBlock;
1084         startBlock = _startBlock;
1085     }
1086 
1087     function poolLength() external view returns (uint256) {
1088         return poolInfo.length;
1089     }
1090 
1091     // Add a new lp to the pool. Can only be called by the owner.
1092     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1093     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1094         if (_withUpdate) {
1095             massUpdatePools();
1096         }
1097         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1098         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1099         poolInfo.push(PoolInfo({
1100             lpToken: _lpToken,
1101             allocPoint: _allocPoint,
1102             lastRewardBlock: lastRewardBlock,
1103             accCCPerShare: 0,
1104             totalAmount: 0
1105         }));
1106     }
1107 
1108     // Update the given pool's CC allocation point. Can only be called by the owner.
1109     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1110         if (_withUpdate) {
1111             massUpdatePools();
1112         }
1113         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1114         poolInfo[_pid].allocPoint = _allocPoint;
1115     }
1116 
1117     // Set the migrator contract. Can only be called by the owner.
1118     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1119         migrator = _migrator;
1120     }
1121 
1122     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1123     function migrate(uint256 _pid) public notPause {
1124         require(address(migrator) != address(0), "migrate: no migrator");
1125         PoolInfo storage pool = poolInfo[_pid];
1126         IERC20 lpToken = pool.lpToken;
1127         uint256 bal = lpToken.balanceOf(address(this));
1128         lpToken.safeApprove(address(migrator), bal);
1129         IERC20 newLpToken = migrator.migrate(lpToken);
1130         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1131         pool.lpToken = newLpToken;
1132     }
1133 
1134     // Return reward multiplier over the given _from to _to block.
1135     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1136         if (_to <= bonusEndBlock) {
1137             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1138         } else if (_from >= bonusEndBlock) {
1139             return _to.sub(_from);
1140         } else {
1141             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1142                 _to.sub(bonusEndBlock)
1143             );
1144         }
1145     }
1146 
1147     // View function to see pending CCs on frontend.
1148     function pendingCC(uint256 _pid, address _user) external view returns (uint256) {
1149         PoolInfo storage pool = poolInfo[_pid];
1150         UserInfo storage user = userInfo[_pid][_user];
1151         uint256 accCCPerShare = pool.accCCPerShare;
1152         uint256 lpSupply = pool.totalAmount;
1153         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1154             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1155             uint256 ccReward = multiplier.mul(ccPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1156             accCCPerShare = accCCPerShare.add(ccReward.mul(1e12).div(lpSupply));
1157         }
1158         return user.amount.mul(accCCPerShare).div(1e12).sub(user.rewardDebt);
1159     }
1160 
1161     // Update reward vairables for all pools. Be careful of gas spending!
1162     function massUpdatePools() public {
1163         uint256 length = poolInfo.length;
1164         for (uint256 pid = 0; pid < length; ++pid) {
1165             updatePool(pid);
1166         }
1167     }
1168 
1169     // Update reward variables of the given pool to be up-to-date.
1170     function updatePool(uint256 _pid) public {
1171         PoolInfo storage pool = poolInfo[_pid];
1172         if (block.number <= pool.lastRewardBlock) {
1173             return;
1174         }
1175         uint256 lpSupply = pool.totalAmount;
1176         if (lpSupply == 0) {
1177             pool.lastRewardBlock = block.number;
1178             return;
1179         }
1180         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1181         uint256 ccReward = multiplier.mul(ccPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1182         cc.mint(address(this), ccReward);
1183         pool.accCCPerShare = pool.accCCPerShare.add(ccReward.mul(1e12).div(lpSupply));
1184         pool.lastRewardBlock = block.number;
1185     }
1186 
1187     // Deposit LP tokens to MasterChef for CC allocation.
1188     function deposit(uint256 _pid, uint256 _amount) public notPause {
1189         PoolInfo storage pool = poolInfo[_pid];
1190         UserInfo storage user = userInfo[_pid][msg.sender];
1191         updatePool(_pid);
1192         if (user.amount > 0) {
1193             uint256 pending = user.amount.mul(pool.accCCPerShare).div(1e12).sub(user.rewardDebt);
1194             safeCCTransfer(msg.sender, pending);
1195         }
1196         pool.totalAmount = pool.totalAmount.add(_amount);
1197         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1198         user.amount = user.amount.add(_amount);
1199         user.rewardDebt = user.amount.mul(pool.accCCPerShare).div(1e12);
1200         emit Deposit(msg.sender, _pid, _amount);
1201     }
1202 
1203     // Withdraw LP tokens from MasterChef.
1204     function withdraw(uint256 _pid, uint256 _amount) public notPause {
1205         PoolInfo storage pool = poolInfo[_pid];
1206         UserInfo storage user = userInfo[_pid][msg.sender];
1207         require(user.amount >= _amount, "withdraw: not good");
1208         updatePool(_pid);
1209         uint256 pending = user.amount.mul(pool.accCCPerShare).div(1e12).sub(user.rewardDebt);
1210         safeCCTransfer(msg.sender, pending);
1211         user.amount = user.amount.sub(_amount);
1212         user.rewardDebt = user.amount.mul(pool.accCCPerShare).div(1e12);
1213         pool.totalAmount = pool.totalAmount.sub(_amount);
1214         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1215         emit Withdraw(msg.sender, _pid, _amount);
1216     }
1217 
1218     // Withdraw without caring about rewards. EMERGENCY ONLY.
1219     function emergencyWithdraw(uint256 _pid) public {
1220         PoolInfo storage pool = poolInfo[_pid];
1221         UserInfo storage user = userInfo[_pid][msg.sender];
1222         uint256 amount = user.amount;
1223         user.amount = 0;
1224         user.rewardDebt = 0;
1225         pool.totalAmount = pool.totalAmount.sub(amount);
1226         pool.lpToken.safeTransfer(address(msg.sender), amount);
1227         emit EmergencyWithdraw(msg.sender, _pid, amount);
1228        
1229         
1230     }
1231 
1232     // Safe cc transfer function, just in case if rounding error causes pool to not have enough CCs.
1233     function safeCCTransfer(address _to, uint256 _amount) internal {
1234         uint256 ccBal = cc.balanceOf(address(this));
1235         if (_amount > ccBal) {
1236             cc.transfer(_to, ccBal);
1237         } else {
1238             cc.transfer(_to, _amount);
1239         }
1240     }
1241 
1242     
1243     function setPause() public onlyOwner {
1244         paused = !paused;
1245     }
1246     
1247     
1248     modifier notPause() {
1249         require(paused == false, "Mining has been suspended");
1250         _;
1251     }
1252 }