1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
79 // File: @openzeppelin/contracts/math/SafeMath.sol
80 
81 pragma solidity >=0.6.0 <0.8.0;
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, with an overflow flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         uint256 c = a + b;
104         if (c < a) return (false, 0);
105         return (true, c);
106     }
107 
108     /**
109      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         if (b > a) return (false, 0);
115         return (true, a - b);
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125         // benefit is lost if 'b' is also tested.
126         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
127         if (a == 0) return (true, 0);
128         uint256 c = a * b;
129         if (c / a != b) return (false, 0);
130         return (true, c);
131     }
132 
133     /**
134      * @dev Returns the division of two unsigned integers, with a division by zero flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         if (b == 0) return (false, 0);
140         return (true, a / b);
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         if (b == 0) return (false, 0);
150         return (true, a % b);
151     }
152 
153     /**
154      * @dev Returns the addition of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `+` operator.
158      *
159      * Requirements:
160      *
161      * - Addition cannot overflow.
162      */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a, "SafeMath: addition overflow");
166         return c;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b <= a, "SafeMath: subtraction overflow");
181         return a - b;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         if (a == 0) return 0;
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers, reverting on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         require(b > 0, "SafeMath: division by zero");
215         return a / b;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b > 0, "SafeMath: modulo by zero");
232         return a % b;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * CAUTION: This function is deprecated because it requires allocating memory for the error
240      * message unnecessarily. For custom revert reasons use {trySub}.
241      *
242      * Counterpart to Solidity's `-` operator.
243      *
244      * Requirements:
245      *
246      * - Subtraction cannot overflow.
247      */
248     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b <= a, errorMessage);
250         return a - b;
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
255      * division by zero. The result is rounded towards zero.
256      *
257      * CAUTION: This function is deprecated because it requires allocating memory for the error
258      * message unnecessarily. For custom revert reasons use {tryDiv}.
259      *
260      * Counterpart to Solidity's `/` operator. Note: this function uses a
261      * `revert` opcode (which leaves remaining gas untouched) while Solidity
262      * uses an invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b > 0, errorMessage);
270         return a / b;
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * reverting with custom message when dividing by zero.
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {tryMod}.
279      *
280      * Counterpart to Solidity's `%` operator. This function uses a `revert`
281      * opcode (which leaves remaining gas untouched) while Solidity uses an
282      * invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
289         require(b > 0, errorMessage);
290         return a % b;
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/Address.sol
295 
296 pragma solidity >=0.6.2 <0.8.0;
297 
298 /**
299  * @dev Collection of functions related to the address type
300  */
301 library Address {
302     /**
303      * @dev Returns true if `account` is a contract.
304      *
305      * [IMPORTANT]
306      * ====
307      * It is unsafe to assume that an address for which this function returns
308      * false is an externally-owned account (EOA) and not a contract.
309      *
310      * Among others, `isContract` will return false for the following
311      * types of addresses:
312      *
313      *  - an externally-owned account
314      *  - a contract in construction
315      *  - an address where a contract will be created
316      *  - an address where a contract lived, but was destroyed
317      * ====
318      */
319     function isContract(address account) internal view returns (bool) {
320         // This method relies on extcodesize, which returns 0 for contracts in
321         // construction, since the code is only stored at the end of the
322         // constructor execution.
323 
324         uint256 size;
325         // solhint-disable-next-line no-inline-assembly
326         assembly { size := extcodesize(account) }
327         return size > 0;
328     }
329 
330     /**
331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
332      * `recipient`, forwarding all available gas and reverting on errors.
333      *
334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
336      * imposed by `transfer`, making them unable to receive funds via
337      * `transfer`. {sendValue} removes this limitation.
338      *
339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
340      *
341      * IMPORTANT: because control is transferred to `recipient`, care must be
342      * taken to not create reentrancy vulnerabilities. Consider using
343      * {ReentrancyGuard} or the
344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(address(this).balance >= amount, "Address: insufficient balance");
348 
349         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
350         (bool success, ) = recipient.call{ value: amount }("");
351         require(success, "Address: unable to send value, recipient may have reverted");
352     }
353 
354     /**
355      * @dev Performs a Solidity function call using a low level `call`. A
356      * plain`call` is an unsafe replacement for a function call: use this
357      * function instead.
358      *
359      * If `target` reverts with a revert reason, it is bubbled up by this
360      * function (like regular Solidity function calls).
361      *
362      * Returns the raw returned data. To convert to the expected return value,
363      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
364      *
365      * Requirements:
366      *
367      * - `target` must be a contract.
368      * - calling `target` with `data` must not revert.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
373       return functionCall(target, data, "Address: low-level call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
378      * `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, 0, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but also transferring `value` wei to `target`.
389      *
390      * Requirements:
391      *
392      * - the calling contract must have an ETH balance of at least `value`.
393      * - the called Solidity function must be `payable`.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
403      * with `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
408         require(address(this).balance >= value, "Address: insufficient balance for call");
409         require(isContract(target), "Address: call to non-contract");
410 
411         // solhint-disable-next-line avoid-low-level-calls
412         (bool success, bytes memory returndata) = target.call{ value: value }(data);
413         return _verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
423         return functionStaticCall(target, data, "Address: low-level static call failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
433         require(isContract(target), "Address: static call to non-contract");
434 
435         // solhint-disable-next-line avoid-low-level-calls
436         (bool success, bytes memory returndata) = target.staticcall(data);
437         return _verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but performing a delegate call.
443      *
444      * _Available since v3.4._
445      */
446     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
447         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
457         require(isContract(target), "Address: delegate call to non-contract");
458 
459         // solhint-disable-next-line avoid-low-level-calls
460         (bool success, bytes memory returndata) = target.delegatecall(data);
461         return _verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 // solhint-disable-next-line no-inline-assembly
473                 assembly {
474                     let returndata_size := mload(returndata)
475                     revert(add(32, returndata), returndata_size)
476                 }
477             } else {
478                 revert(errorMessage);
479             }
480         }
481     }
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
485 
486 pragma solidity >=0.6.0 <0.8.0;
487 
488 
489 
490 
491 /**
492  * @title SafeERC20
493  * @dev Wrappers around ERC20 operations that throw on failure (when the token
494  * contract returns false). Tokens that return no value (and instead revert or
495  * throw on failure) are also supported, non-reverting calls are assumed to be
496  * successful.
497  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
498  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
499  */
500 library SafeERC20 {
501     using SafeMath for uint256;
502     using Address for address;
503 
504     function safeTransfer(IERC20 token, address to, uint256 value) internal {
505         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
506     }
507 
508     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
509         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
510     }
511 
512     /**
513      * @dev Deprecated. This function has issues similar to the ones found in
514      * {IERC20-approve}, and its usage is discouraged.
515      *
516      * Whenever possible, use {safeIncreaseAllowance} and
517      * {safeDecreaseAllowance} instead.
518      */
519     function safeApprove(IERC20 token, address spender, uint256 value) internal {
520         // safeApprove should only be called when setting an initial allowance,
521         // or when resetting it to zero. To increase and decrease it, use
522         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
523         // solhint-disable-next-line max-line-length
524         require((value == 0) || (token.allowance(address(this), spender) == 0),
525             "SafeERC20: approve from non-zero to non-zero allowance"
526         );
527         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
528     }
529 
530     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).add(value);
532         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
533     }
534 
535     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
536         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
538     }
539 
540     /**
541      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
542      * on the return value: the return value is optional (but if data is returned, it must not be false).
543      * @param token The token targeted by the call.
544      * @param data The call data (encoded using abi.encode or one of its variants).
545      */
546     function _callOptionalReturn(IERC20 token, bytes memory data) private {
547         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
548         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
549         // the target address contains contract code and also asserts for success in the low-level call.
550 
551         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
552         if (returndata.length > 0) { // Return data is optional
553             // solhint-disable-next-line max-line-length
554             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
555         }
556     }
557 }
558 
559 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
560 
561 pragma solidity >=0.6.0 <0.8.0;
562 
563 /**
564  * @dev Library for managing
565  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
566  * types.
567  *
568  * Sets have the following properties:
569  *
570  * - Elements are added, removed, and checked for existence in constant time
571  * (O(1)).
572  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
573  *
574  * ```
575  * contract Example {
576  *     // Add the library methods
577  *     using EnumerableSet for EnumerableSet.AddressSet;
578  *
579  *     // Declare a set state variable
580  *     EnumerableSet.AddressSet private mySet;
581  * }
582  * ```
583  *
584  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
585  * and `uint256` (`UintSet`) are supported.
586  */
587 library EnumerableSet {
588     // To implement this library for multiple types with as little code
589     // repetition as possible, we write it in terms of a generic Set type with
590     // bytes32 values.
591     // The Set implementation uses private functions, and user-facing
592     // implementations (such as AddressSet) are just wrappers around the
593     // underlying Set.
594     // This means that we can only create new EnumerableSets for types that fit
595     // in bytes32.
596 
597     struct Set {
598         // Storage of set values
599         bytes32[] _values;
600 
601         // Position of the value in the `values` array, plus 1 because index 0
602         // means a value is not in the set.
603         mapping (bytes32 => uint256) _indexes;
604     }
605 
606     /**
607      * @dev Add a value to a set. O(1).
608      *
609      * Returns true if the value was added to the set, that is if it was not
610      * already present.
611      */
612     function _add(Set storage set, bytes32 value) private returns (bool) {
613         if (!_contains(set, value)) {
614             set._values.push(value);
615             // The value is stored at length-1, but we add 1 to all indexes
616             // and use 0 as a sentinel value
617             set._indexes[value] = set._values.length;
618             return true;
619         } else {
620             return false;
621         }
622     }
623 
624     /**
625      * @dev Removes a value from a set. O(1).
626      *
627      * Returns true if the value was removed from the set, that is if it was
628      * present.
629      */
630     function _remove(Set storage set, bytes32 value) private returns (bool) {
631         // We read and store the value's index to prevent multiple reads from the same storage slot
632         uint256 valueIndex = set._indexes[value];
633 
634         if (valueIndex != 0) { // Equivalent to contains(set, value)
635             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
636             // the array, and then remove the last element (sometimes called as 'swap and pop').
637             // This modifies the order of the array, as noted in {at}.
638 
639             uint256 toDeleteIndex = valueIndex - 1;
640             uint256 lastIndex = set._values.length - 1;
641 
642             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
643             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
644 
645             bytes32 lastvalue = set._values[lastIndex];
646 
647             // Move the last value to the index where the value to delete is
648             set._values[toDeleteIndex] = lastvalue;
649             // Update the index for the moved value
650             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
651 
652             // Delete the slot where the moved value was stored
653             set._values.pop();
654 
655             // Delete the index for the deleted slot
656             delete set._indexes[value];
657 
658             return true;
659         } else {
660             return false;
661         }
662     }
663 
664     /**
665      * @dev Returns true if the value is in the set. O(1).
666      */
667     function _contains(Set storage set, bytes32 value) private view returns (bool) {
668         return set._indexes[value] != 0;
669     }
670 
671     /**
672      * @dev Returns the number of values on the set. O(1).
673      */
674     function _length(Set storage set) private view returns (uint256) {
675         return set._values.length;
676     }
677 
678    /**
679     * @dev Returns the value stored at position `index` in the set. O(1).
680     *
681     * Note that there are no guarantees on the ordering of values inside the
682     * array, and it may change when more values are added or removed.
683     *
684     * Requirements:
685     *
686     * - `index` must be strictly less than {length}.
687     */
688     function _at(Set storage set, uint256 index) private view returns (bytes32) {
689         require(set._values.length > index, "EnumerableSet: index out of bounds");
690         return set._values[index];
691     }
692 
693     // Bytes32Set
694 
695     struct Bytes32Set {
696         Set _inner;
697     }
698 
699     /**
700      * @dev Add a value to a set. O(1).
701      *
702      * Returns true if the value was added to the set, that is if it was not
703      * already present.
704      */
705     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
706         return _add(set._inner, value);
707     }
708 
709     /**
710      * @dev Removes a value from a set. O(1).
711      *
712      * Returns true if the value was removed from the set, that is if it was
713      * present.
714      */
715     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
716         return _remove(set._inner, value);
717     }
718 
719     /**
720      * @dev Returns true if the value is in the set. O(1).
721      */
722     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
723         return _contains(set._inner, value);
724     }
725 
726     /**
727      * @dev Returns the number of values in the set. O(1).
728      */
729     function length(Bytes32Set storage set) internal view returns (uint256) {
730         return _length(set._inner);
731     }
732 
733    /**
734     * @dev Returns the value stored at position `index` in the set. O(1).
735     *
736     * Note that there are no guarantees on the ordering of values inside the
737     * array, and it may change when more values are added or removed.
738     *
739     * Requirements:
740     *
741     * - `index` must be strictly less than {length}.
742     */
743     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
744         return _at(set._inner, index);
745     }
746 
747     // AddressSet
748 
749     struct AddressSet {
750         Set _inner;
751     }
752 
753     /**
754      * @dev Add a value to a set. O(1).
755      *
756      * Returns true if the value was added to the set, that is if it was not
757      * already present.
758      */
759     function add(AddressSet storage set, address value) internal returns (bool) {
760         return _add(set._inner, bytes32(uint256(uint160(value))));
761     }
762 
763     /**
764      * @dev Removes a value from a set. O(1).
765      *
766      * Returns true if the value was removed from the set, that is if it was
767      * present.
768      */
769     function remove(AddressSet storage set, address value) internal returns (bool) {
770         return _remove(set._inner, bytes32(uint256(uint160(value))));
771     }
772 
773     /**
774      * @dev Returns true if the value is in the set. O(1).
775      */
776     function contains(AddressSet storage set, address value) internal view returns (bool) {
777         return _contains(set._inner, bytes32(uint256(uint160(value))));
778     }
779 
780     /**
781      * @dev Returns the number of values in the set. O(1).
782      */
783     function length(AddressSet storage set) internal view returns (uint256) {
784         return _length(set._inner);
785     }
786 
787    /**
788     * @dev Returns the value stored at position `index` in the set. O(1).
789     *
790     * Note that there are no guarantees on the ordering of values inside the
791     * array, and it may change when more values are added or removed.
792     *
793     * Requirements:
794     *
795     * - `index` must be strictly less than {length}.
796     */
797     function at(AddressSet storage set, uint256 index) internal view returns (address) {
798         return address(uint160(uint256(_at(set._inner, index))));
799     }
800 
801 
802     // UintSet
803 
804     struct UintSet {
805         Set _inner;
806     }
807 
808     /**
809      * @dev Add a value to a set. O(1).
810      *
811      * Returns true if the value was added to the set, that is if it was not
812      * already present.
813      */
814     function add(UintSet storage set, uint256 value) internal returns (bool) {
815         return _add(set._inner, bytes32(value));
816     }
817 
818     /**
819      * @dev Removes a value from a set. O(1).
820      *
821      * Returns true if the value was removed from the set, that is if it was
822      * present.
823      */
824     function remove(UintSet storage set, uint256 value) internal returns (bool) {
825         return _remove(set._inner, bytes32(value));
826     }
827 
828     /**
829      * @dev Returns true if the value is in the set. O(1).
830      */
831     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
832         return _contains(set._inner, bytes32(value));
833     }
834 
835     /**
836      * @dev Returns the number of values on the set. O(1).
837      */
838     function length(UintSet storage set) internal view returns (uint256) {
839         return _length(set._inner);
840     }
841 
842    /**
843     * @dev Returns the value stored at position `index` in the set. O(1).
844     *
845     * Note that there are no guarantees on the ordering of values inside the
846     * array, and it may change when more values are added or removed.
847     *
848     * Requirements:
849     *
850     * - `index` must be strictly less than {length}.
851     */
852     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
853         return uint256(_at(set._inner, index));
854     }
855 }
856 
857 // File: @openzeppelin/contracts/utils/Context.sol
858 
859 pragma solidity >=0.6.0 <0.8.0;
860 
861 /*
862  * @dev Provides information about the current execution context, including the
863  * sender of the transaction and its data. While these are generally available
864  * via msg.sender and msg.data, they should not be accessed in such a direct
865  * manner, since when dealing with GSN meta-transactions the account sending and
866  * paying for execution may not be the actual sender (as far as an application
867  * is concerned).
868  *
869  * This contract is only required for intermediate, library-like contracts.
870  */
871 abstract contract Context {
872     function _msgSender() internal view virtual returns (address payable) {
873         return msg.sender;
874     }
875 
876     function _msgData() internal view virtual returns (bytes memory) {
877         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
878         return msg.data;
879     }
880 }
881 
882 // File: @openzeppelin/contracts/access/Ownable.sol
883 
884 // SPDX-License-Identifier: MIT
885 
886 pragma solidity >=0.6.0 <0.8.0;
887 
888 /**
889  * @dev Contract module which provides a basic access control mechanism, where
890  * there is an account (an owner) that can be granted exclusive access to
891  * specific functions.
892  *
893  * By default, the owner account will be the one that deploys the contract. This
894  * can later be changed with {transferOwnership}.
895  *
896  * This module is used through inheritance. It will make available the modifier
897  * `onlyOwner`, which can be applied to your functions to restrict their use to
898  * the owner.
899  */
900 abstract contract Ownable is Context {
901     address private _owner;
902 
903     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
904 
905     /**
906      * @dev Initializes the contract setting the deployer as the initial owner.
907      */
908     constructor () internal {
909         address msgSender = _msgSender();
910         _owner = msgSender;
911         emit OwnershipTransferred(address(0), msgSender);
912     }
913 
914     /**
915      * @dev Returns the address of the current owner.
916      */
917     function owner() public view virtual returns (address) {
918         return _owner;
919     }
920 
921     /**
922      * @dev Throws if called by any account other than the owner.
923      */
924     modifier onlyOwner() {
925         require(owner() == _msgSender(), "Ownable: caller is not the owner");
926         _;
927     }
928 
929     /**
930      * @dev Leaves the contract without owner. It will not be possible to call
931      * `onlyOwner` functions anymore. Can only be called by the current owner.
932      *
933      * NOTE: Renouncing ownership will leave the contract without an owner,
934      * thereby removing any functionality that is only available to the owner.
935      */
936     function renounceOwnership() public virtual onlyOwner {
937         emit OwnershipTransferred(_owner, address(0));
938         _owner = address(0);
939     }
940 
941     /**
942      * @dev Transfers ownership of the contract to a new account (`newOwner`).
943      * Can only be called by the current owner.
944      */
945     function transferOwnership(address newOwner) public virtual onlyOwner {
946         require(newOwner != address(0), "Ownable: new owner is the zero address");
947         emit OwnershipTransferred(_owner, newOwner);
948         _owner = newOwner;
949     }
950 }
951 
952 // File: contracts/gaia/gaiaFarm.sol
953 
954 pragma solidity 0.6.12;
955 
956 
957 
958 
959 
960 
961 contract gaiaFarm is Ownable {
962     using SafeMath for uint256;
963     using SafeERC20 for IERC20;
964 
965     struct UserInfo {
966         uint256 amount;
967         uint256 rewardDebt;
968     }
969 
970     struct PoolInfo {
971         IERC20 lpToken;
972         uint256 allocPoint;
973         uint256 lastRewardBlock;
974         uint256 accGaiaPerShare;
975         uint256 startBlock;
976         uint256 endBlock;
977     }
978 
979     IERC20 public gaia;
980     PoolInfo[] internal poolInfo;
981 
982     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
983     mapping (address => bool) private _addedLP;
984 
985     uint256 public gaiaPerBlock;
986     uint256 public totalAllocPoint;
987 
988     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
989     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
990     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
991 
992     constructor (
993         IERC20 _gaia,
994         uint256 _gaiaPerBlock
995     )  
996         public
997     {
998         gaia = _gaia;
999         gaiaPerBlock = _gaiaPerBlock;
1000         totalAllocPoint = 0;
1001     }
1002 
1003     // view functions
1004     function poolLength() external view returns (uint256) {
1005         return poolInfo.length;
1006     }
1007 
1008     function lastRewardsBlock(uint256 _poolID) external view returns (uint256) {
1009         return poolInfo[_poolID].lastRewardBlock;
1010     }
1011 
1012     function startBlock(uint256 _poolID) external view returns (uint256) {
1013         return poolInfo[_poolID].startBlock;
1014     }
1015 
1016     function getPoolToken(uint256 _poolID) external view returns (address) {
1017         return address(poolInfo[_poolID].lpToken);
1018     }
1019 
1020     function getAllocPoint(uint256 _poolID) external view returns (uint256) {
1021         return poolInfo[_poolID].allocPoint;
1022     }
1023 
1024     function getAllocPerShare(uint256 _poolID) external view returns (uint256) {
1025         return poolInfo[_poolID].accGaiaPerShare;
1026     }
1027 
1028     function gaiaReward(uint256 _poolID) external view returns (uint256) {
1029         return (gaiaPerBlock * 10 ** 9).mul(poolInfo[_poolID].allocPoint).div(totalAllocPoint);
1030     }
1031 
1032     function getLPSupply(uint256 _poolID) external view returns (uint256) {
1033         uint256 lpSupply = poolInfo[_poolID].lpToken.balanceOf(address(this));
1034         return lpSupply;
1035     }
1036 
1037     function endBlock(uint256 _poolID) external view returns (uint256) {
1038         return poolInfo[_poolID].endBlock;
1039     }
1040 
1041     function pendingGaia(uint256 _poolID, address _user) external view returns (uint256) {
1042         PoolInfo storage pool = poolInfo[_poolID];
1043         UserInfo storage user = userInfo[_poolID][_user];
1044         uint256 accGaiaPerShare = pool.accGaiaPerShare;
1045         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1046         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1047             uint256 latestBlock = block.number <= pool.endBlock ? block.number : pool.endBlock;
1048             uint256 blocks = latestBlock.sub(pool.lastRewardBlock);
1049             uint256 gaiaRewardAmount = blocks.mul(gaiaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1050             accGaiaPerShare = accGaiaPerShare.add(gaiaRewardAmount.mul(10 ** 18).div(lpSupply)); // 10 ** 18 to match the LP supply
1051         }
1052         return user.amount.mul(accGaiaPerShare).div(10 ** 9).sub(user.rewardDebt);
1053     }
1054 
1055     // mutative functions
1056     function setGaiaPerBlock(uint256 _newGaiaPerBlock) external onlyOwner {
1057         gaiaPerBlock = _newGaiaPerBlock;
1058     }
1059 
1060     function setEndBlock(uint256 _poolID, uint256 _newEndBlock) external onlyOwner {
1061         poolInfo[_poolID].endBlock = _newEndBlock;
1062     }
1063 
1064     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, uint256 _startBlock, uint256 _endBlock)
1065         public
1066         onlyOwner
1067     {
1068         require(!_addedLP[address(_lpToken)], 'lp exists already');
1069         if (_withUpdate) {
1070             massUpdatePools();
1071         }
1072 
1073         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1074 
1075         _addedLP[address(_lpToken)] = true;
1076 
1077         poolInfo.push(PoolInfo({
1078             lpToken: _lpToken,
1079             allocPoint: _allocPoint,
1080             lastRewardBlock: _startBlock,
1081             startBlock: _startBlock,
1082             endBlock: _endBlock,
1083             accGaiaPerShare: 0
1084         }));
1085     }
1086 
1087     function set(uint256 _poolID, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1088         if (_withUpdate) {
1089             massUpdatePools();
1090         }
1091         totalAllocPoint = totalAllocPoint.sub(poolInfo[_poolID].allocPoint).add(_allocPoint);
1092         poolInfo[_poolID].allocPoint = _allocPoint;
1093     }
1094 
1095     function massUpdatePools() public {
1096         uint256 length = poolInfo.length;
1097         for (uint256 pid = 0; pid < length; ++pid) {
1098             updatePool(pid);
1099         }
1100     }
1101 
1102     function updatePool(uint256 _poolID) public {
1103         PoolInfo storage pool = poolInfo[_poolID];
1104 
1105         if (block.number <= pool.lastRewardBlock) {
1106             return;
1107         }
1108         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1109         if (lpSupply == 0) {
1110             pool.lastRewardBlock = block.number;
1111             return;
1112         }
1113 
1114         if (pool.lastRewardBlock <= pool.endBlock) {
1115             uint256 blocks = block.number <= pool.endBlock ? block.number.sub(pool.lastRewardBlock) : pool.endBlock.sub(pool.lastRewardBlock);
1116             
1117             uint256 gaiaRewardAmount = blocks.mul(gaiaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1118             pool.accGaiaPerShare = pool.accGaiaPerShare.add(gaiaRewardAmount.mul(10 ** 18).div(lpSupply));
1119             pool.lastRewardBlock = block.number;
1120         }
1121     }
1122 
1123     function deposit(uint256 _poolID, uint256 _amount) public {
1124         PoolInfo storage pool = poolInfo[_poolID];
1125         UserInfo storage user = userInfo[_poolID][msg.sender];
1126 
1127         if (user.amount > 0) {
1128             uint256 pending = user.amount.mul(pool.accGaiaPerShare).div(10 ** 9).sub(user.rewardDebt);
1129 
1130             if (pending > 0) {
1131                 safeGaiaTransfer(msg.sender, pending);
1132             }
1133         }
1134 
1135         if (_amount > 0) {
1136             require(pool.lpToken.balanceOf(msg.sender) >= _amount, "insufficient LP balance");
1137 
1138             pool.lpToken.safeTransferFrom(msg.sender, address(this), _amount);
1139             user.amount = user.amount.add(_amount);
1140         }
1141 
1142         updatePool(_poolID);
1143 
1144         user.rewardDebt = user.amount.mul(pool.accGaiaPerShare).div(10 ** 9);
1145         emit Deposit(msg.sender, _poolID, _amount);
1146     }
1147 
1148     function withdraw(uint256 _poolID) public {
1149         PoolInfo storage pool = poolInfo[_poolID];
1150         UserInfo storage user = userInfo[_poolID][msg.sender];
1151 
1152         updatePool(_poolID);
1153 
1154         uint256 pending = user.amount.mul(pool.accGaiaPerShare).div(10 ** 9).sub(user.rewardDebt);
1155         if (pending > 0) {
1156             safeGaiaTransfer(msg.sender, pending);
1157         }
1158 
1159         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1160         emit Withdraw(msg.sender, _poolID, user.amount);
1161         user.amount = 0;
1162 
1163         user.rewardDebt = user.amount.mul(pool.accGaiaPerShare).div(10 ** 9);
1164     }
1165 
1166     function claimRewards(uint256 _poolID) public {
1167         PoolInfo storage pool = poolInfo[_poolID];
1168         UserInfo storage user = userInfo[_poolID][msg.sender];
1169 
1170         updatePool(_poolID);
1171 
1172         uint256 pending = user.amount.mul(pool.accGaiaPerShare).div(10 ** 9).sub(user.rewardDebt);
1173         if (pending > 0) {
1174             safeGaiaTransfer(msg.sender, pending);
1175         }
1176 
1177         user.rewardDebt = user.amount.mul(pool.accGaiaPerShare).div(10 ** 9);
1178     }
1179 
1180     function emergencyWithdraw(uint256 _poolID) public {
1181         PoolInfo storage pool = poolInfo[_poolID];
1182         UserInfo storage user = userInfo[_poolID][msg.sender];
1183         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1184         emit EmergencyWithdraw(msg.sender, _poolID, user.amount);
1185 
1186         user.amount = 0;
1187         user.rewardDebt = 0;
1188     }
1189 
1190     function safeGaiaTransfer(address _to, uint256 _amount) internal {
1191         uint256 gaiaBal = gaia.balanceOf(address(this));
1192         if (_amount > gaiaBal) {
1193             gaia.transfer(_to, gaiaBal);
1194         } else {
1195             gaia.transfer(_to, _amount);
1196         }
1197     }
1198 }