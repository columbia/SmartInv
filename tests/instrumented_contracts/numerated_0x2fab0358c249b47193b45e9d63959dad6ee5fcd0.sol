1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 // 
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
81 // 
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
238 // 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
262         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
263         // for accounts without code, i.e. `keccak256('')`
264         bytes32 codehash;
265         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
266         // solhint-disable-next-line no-inline-assembly
267         assembly { codehash := extcodehash(account) }
268         return (codehash != accountHash && codehash != 0x0);
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
291         (bool success, ) = recipient.call{ value: amount }("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain`call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314       return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
324         return _functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344      * with `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
349         require(address(this).balance >= value, "Address: insufficient balance for call");
350         return _functionCallWithValue(target, data, value, errorMessage);
351     }
352 
353     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
358         if (success) {
359             return returndata;
360         } else {
361             // Look for revert reason and bubble it up if present
362             if (returndata.length > 0) {
363                 // The easiest way to bubble the revert reason is using memory via assembly
364 
365                 // solhint-disable-next-line no-inline-assembly
366                 assembly {
367                     let returndata_size := mload(returndata)
368                     revert(add(32, returndata), returndata_size)
369                 }
370             } else {
371                 revert(errorMessage);
372             }
373         }
374     }
375 }
376 
377 // 
378 /**
379  * @title SafeERC20
380  * @dev Wrappers around ERC20 operations that throw on failure (when the token
381  * contract returns false). Tokens that return no value (and instead revert or
382  * throw on failure) are also supported, non-reverting calls are assumed to be
383  * successful.
384  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
385  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
386  */
387 library SafeERC20 {
388     using SafeMath for uint256;
389     using Address for address;
390 
391     function safeTransfer(IERC20 token, address to, uint256 value) internal {
392         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
393     }
394 
395     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
396         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
397     }
398 
399     /**
400      * @dev Deprecated. This function has issues similar to the ones found in
401      * {IERC20-approve}, and its usage is discouraged.
402      *
403      * Whenever possible, use {safeIncreaseAllowance} and
404      * {safeDecreaseAllowance} instead.
405      */
406     function safeApprove(IERC20 token, address spender, uint256 value) internal {
407         // safeApprove should only be called when setting an initial allowance,
408         // or when resetting it to zero. To increase and decrease it, use
409         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
410         // solhint-disable-next-line max-line-length
411         require((value == 0) || (token.allowance(address(this), spender) == 0),
412             "SafeERC20: approve from non-zero to non-zero allowance"
413         );
414         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
415     }
416 
417     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
418         uint256 newAllowance = token.allowance(address(this), spender).add(value);
419         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
420     }
421 
422     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
423         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
425     }
426 
427     /**
428      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
429      * on the return value: the return value is optional (but if data is returned, it must not be false).
430      * @param token The token targeted by the call.
431      * @param data The call data (encoded using abi.encode or one of its variants).
432      */
433     function _callOptionalReturn(IERC20 token, bytes memory data) private {
434         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
435         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
436         // the target address contains contract code and also asserts for success in the low-level call.
437 
438         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
439         if (returndata.length > 0) { // Return data is optional
440             // solhint-disable-next-line max-line-length
441             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
442         }
443     }
444 }
445 
446 // 
447 /**
448  * @dev Library for managing
449  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
450  * types.
451  *
452  * Sets have the following properties:
453  *
454  * - Elements are added, removed, and checked for existence in constant time
455  * (O(1)).
456  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
457  *
458  * ```
459  * contract Example {
460  *     // Add the library methods
461  *     using EnumerableSet for EnumerableSet.AddressSet;
462  *
463  *     // Declare a set state variable
464  *     EnumerableSet.AddressSet private mySet;
465  * }
466  * ```
467  *
468  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
469  * (`UintSet`) are supported.
470  */
471 library EnumerableSet {
472     // To implement this library for multiple types with as little code
473     // repetition as possible, we write it in terms of a generic Set type with
474     // bytes32 values.
475     // The Set implementation uses private functions, and user-facing
476     // implementations (such as AddressSet) are just wrappers around the
477     // underlying Set.
478     // This means that we can only create new EnumerableSets for types that fit
479     // in bytes32.
480 
481     struct Set {
482         // Storage of set values
483         bytes32[] _values;
484 
485         // Position of the value in the `values` array, plus 1 because index 0
486         // means a value is not in the set.
487         mapping (bytes32 => uint256) _indexes;
488     }
489 
490     /**
491      * @dev Add a value to a set. O(1).
492      *
493      * Returns true if the value was added to the set, that is if it was not
494      * already present.
495      */
496     function _add(Set storage set, bytes32 value) private returns (bool) {
497         if (!_contains(set, value)) {
498             set._values.push(value);
499             // The value is stored at length-1, but we add 1 to all indexes
500             // and use 0 as a sentinel value
501             set._indexes[value] = set._values.length;
502             return true;
503         } else {
504             return false;
505         }
506     }
507 
508     /**
509      * @dev Removes a value from a set. O(1).
510      *
511      * Returns true if the value was removed from the set, that is if it was
512      * present.
513      */
514     function _remove(Set storage set, bytes32 value) private returns (bool) {
515         // We read and store the value's index to prevent multiple reads from the same storage slot
516         uint256 valueIndex = set._indexes[value];
517 
518         if (valueIndex != 0) { // Equivalent to contains(set, value)
519             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
520             // the array, and then remove the last element (sometimes called as 'swap and pop').
521             // This modifies the order of the array, as noted in {at}.
522 
523             uint256 toDeleteIndex = valueIndex - 1;
524             uint256 lastIndex = set._values.length - 1;
525 
526             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
527             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
528 
529             bytes32 lastvalue = set._values[lastIndex];
530 
531             // Move the last value to the index where the value to delete is
532             set._values[toDeleteIndex] = lastvalue;
533             // Update the index for the moved value
534             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
535 
536             // Delete the slot where the moved value was stored
537             set._values.pop();
538 
539             // Delete the index for the deleted slot
540             delete set._indexes[value];
541 
542             return true;
543         } else {
544             return false;
545         }
546     }
547 
548     /**
549      * @dev Returns true if the value is in the set. O(1).
550      */
551     function _contains(Set storage set, bytes32 value) private view returns (bool) {
552         return set._indexes[value] != 0;
553     }
554 
555     /**
556      * @dev Returns the number of values on the set. O(1).
557      */
558     function _length(Set storage set) private view returns (uint256) {
559         return set._values.length;
560     }
561 
562    /**
563     * @dev Returns the value stored at position `index` in the set. O(1).
564     *
565     * Note that there are no guarantees on the ordering of values inside the
566     * array, and it may change when more values are added or removed.
567     *
568     * Requirements:
569     *
570     * - `index` must be strictly less than {length}.
571     */
572     function _at(Set storage set, uint256 index) private view returns (bytes32) {
573         require(set._values.length > index, "EnumerableSet: index out of bounds");
574         return set._values[index];
575     }
576 
577     // AddressSet
578 
579     struct AddressSet {
580         Set _inner;
581     }
582 
583     /**
584      * @dev Add a value to a set. O(1).
585      *
586      * Returns true if the value was added to the set, that is if it was not
587      * already present.
588      */
589     function add(AddressSet storage set, address value) internal returns (bool) {
590         return _add(set._inner, bytes32(uint256(value)));
591     }
592 
593     /**
594      * @dev Removes a value from a set. O(1).
595      *
596      * Returns true if the value was removed from the set, that is if it was
597      * present.
598      */
599     function remove(AddressSet storage set, address value) internal returns (bool) {
600         return _remove(set._inner, bytes32(uint256(value)));
601     }
602 
603     /**
604      * @dev Returns true if the value is in the set. O(1).
605      */
606     function contains(AddressSet storage set, address value) internal view returns (bool) {
607         return _contains(set._inner, bytes32(uint256(value)));
608     }
609 
610     /**
611      * @dev Returns the number of values in the set. O(1).
612      */
613     function length(AddressSet storage set) internal view returns (uint256) {
614         return _length(set._inner);
615     }
616 
617    /**
618     * @dev Returns the value stored at position `index` in the set. O(1).
619     *
620     * Note that there are no guarantees on the ordering of values inside the
621     * array, and it may change when more values are added or removed.
622     *
623     * Requirements:
624     *
625     * - `index` must be strictly less than {length}.
626     */
627     function at(AddressSet storage set, uint256 index) internal view returns (address) {
628         return address(uint256(_at(set._inner, index)));
629     }
630 
631 
632     // UintSet
633 
634     struct UintSet {
635         Set _inner;
636     }
637 
638     /**
639      * @dev Add a value to a set. O(1).
640      *
641      * Returns true if the value was added to the set, that is if it was not
642      * already present.
643      */
644     function add(UintSet storage set, uint256 value) internal returns (bool) {
645         return _add(set._inner, bytes32(value));
646     }
647 
648     /**
649      * @dev Removes a value from a set. O(1).
650      *
651      * Returns true if the value was removed from the set, that is if it was
652      * present.
653      */
654     function remove(UintSet storage set, uint256 value) internal returns (bool) {
655         return _remove(set._inner, bytes32(value));
656     }
657 
658     /**
659      * @dev Returns true if the value is in the set. O(1).
660      */
661     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
662         return _contains(set._inner, bytes32(value));
663     }
664 
665     /**
666      * @dev Returns the number of values on the set. O(1).
667      */
668     function length(UintSet storage set) internal view returns (uint256) {
669         return _length(set._inner);
670     }
671 
672    /**
673     * @dev Returns the value stored at position `index` in the set. O(1).
674     *
675     * Note that there are no guarantees on the ordering of values inside the
676     * array, and it may change when more values are added or removed.
677     *
678     * Requirements:
679     *
680     * - `index` must be strictly less than {length}.
681     */
682     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
683         return uint256(_at(set._inner, index));
684     }
685 }
686 
687 // 
688 /*
689  * @dev Provides information about the current execution context, including the
690  * sender of the transaction and its data. While these are generally available
691  * via msg.sender and msg.data, they should not be accessed in such a direct
692  * manner, since when dealing with GSN meta-transactions the account sending and
693  * paying for execution may not be the actual sender (as far as an application
694  * is concerned).
695  *
696  * This contract is only required for intermediate, library-like contracts.
697  */
698 abstract contract Context {
699     function _msgSender() internal view virtual returns (address payable) {
700         return msg.sender;
701     }
702 
703     function _msgData() internal view virtual returns (bytes memory) {
704         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
705         return msg.data;
706     }
707 }
708 
709 // 
710 /**
711  * @dev Contract module which provides a basic access control mechanism, where
712  * there is an account (an owner) that can be granted exclusive access to
713  * specific functions.
714  *
715  * By default, the owner account will be the one that deploys the contract. This
716  * can later be changed with {transferOwnership}.
717  *
718  * This module is used through inheritance. It will make available the modifier
719  * `onlyOwner`, which can be applied to your functions to restrict their use to
720  * the owner.
721  */
722 contract Ownable is Context {
723     address private _owner;
724 
725     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
726 
727     /**
728      * @dev Initializes the contract setting the deployer as the initial owner.
729      */
730     constructor () internal {
731         address msgSender = _msgSender();
732         _owner = msgSender;
733         emit OwnershipTransferred(address(0), msgSender);
734     }
735 
736     /**
737      * @dev Returns the address of the current owner.
738      */
739     function owner() public view returns (address) {
740         return _owner;
741     }
742 
743     /**
744      * @dev Throws if called by any account other than the owner.
745      */
746     modifier onlyOwner() {
747         require(_owner == _msgSender(), "Ownable: caller is not the owner");
748         _;
749     }
750 
751     /**
752      * @dev Leaves the contract without owner. It will not be possible to call
753      * `onlyOwner` functions anymore. Can only be called by the current owner.
754      *
755      * NOTE: Renouncing ownership will leave the contract without an owner,
756      * thereby removing any functionality that is only available to the owner.
757      */
758     function renounceOwnership() public virtual onlyOwner {
759         emit OwnershipTransferred(_owner, address(0));
760         _owner = address(0);
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Can only be called by the current owner.
766      */
767     function transferOwnership(address newOwner) public virtual onlyOwner {
768         require(newOwner != address(0), "Ownable: new owner is the zero address");
769         emit OwnershipTransferred(_owner, newOwner);
770         _owner = newOwner;
771     }
772 }
773 
774 // 
775 interface IGRAPWine {
776     function mint(address _to, uint256 _id, uint256 _quantity, bytes memory _data) external ;
777 	function totalSupply(uint256 _id) external view returns (uint256);
778     function maxSupply(uint256 _id) external view returns (uint256);
779     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
780 }
781 
782 // 
783 /**
784 Copyright 2020 PoolTogether Inc.
785 This file is part of PoolTogether.
786 PoolTogether is free software: you can redistribute it and/or modify
787 it under the terms of the GNU General Public License as published by
788 the Free Software Foundation under version 3 of the License.
789 PoolTogether is distributed in the hope that it will be useful,
790 but WITHOUT ANY WARRANTY; without even the implied warranty of
791 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
792 GNU General Public License for more details.
793 You should have received a copy of the GNU General Public License
794 along with PoolTogether.  If not, see <https://www.gnu.org/licenses/>.
795 */
796 /**
797  * @author Brendan Asselstine
798  * @notice A library that uses entropy to select a random number within a bound.  Compensates for modulo bias.
799  * @dev Thanks to https://medium.com/hownetworks/dont-waste-cycles-with-modulo-bias-35b6fdafcf94
800  */
801 library UniformRandomNumber {
802   /// @notice Select a random number without modulo bias using a random seed and upper bound
803   /// @param _entropy The seed for randomness
804   /// @param _upperBound The upper bound of the desired number
805   /// @return A random number less than the _upperBound
806   function uniform(uint256 _entropy, uint256 _upperBound) internal pure returns (uint256) {
807     require(_upperBound > 0, "UniformRand/min-bound");
808     uint256 min = -_upperBound % _upperBound;
809     uint256 random = _entropy;
810     while (true) {
811       if (random >= min) {
812         break;
813       }
814       random = uint256(keccak256(abi.encodePacked(random)));
815     }
816     return random % _upperBound;
817   }
818 }
819 
820 contract Brewer is Ownable {
821     using SafeMath for uint256;
822     using SafeERC20 for IERC20;
823 
824     // Airdrop list
825     address[] public airdropList;
826     // Only deposit user can get airdrop.
827     mapping(address => bool) addressAvailable;
828     mapping(address => bool) addressAvailableHistory;
829 
830     // Claimable wine of user.
831     struct UserWineInfo {
832         uint256 amount;
833     }
834     // Info of each user that claimable wine.
835     mapping (address => mapping (uint256 => UserWineInfo)) public userWineInfo;
836 
837     // Ticket of users
838     mapping(address => uint256) ticketBalances;
839     // Info of each wine.
840     struct WineInfo {
841         uint256 wineID;            // Wine's ID. 
842         uint256 amount;            // Distribution amount.
843         uint256 fixedPrice;        // Claim the wine need pay some wETH.
844     }
845     // Info of each wine.
846     WineInfo[] public wineInfo;
847     // Total wine amount.
848     uint256 public totalWineAmount = 0;
849     // Original total wine amount.
850     uint256 public originalTotalWineAmount = 0;
851     // Draw consumption
852     uint256 public ticketsConsumed = 1000 * (10 ** 18);
853     // Base number
854     uint256 public base = 10 ** 6;
855     // Claim fee is 3%.
856     // Pool's fee 1%. Artist's fee 2%.
857     uint256 public totalFee = 3 * (base) / 100;
858 
859     // Wine token.
860     IGRAPWine GRAPWine;
861 
862     event Reward(address indexed user, uint256 indexed wineID);
863     event AirDrop(address indexed user, uint256 indexed wineID);
864 
865     function wineLength() public view returns (uint256) {
866         return wineInfo.length;
867     }
868 
869     function ticketBalanceOf(address tokenOwner) public view returns (uint256) {
870         return ticketBalances[tokenOwner];
871     }
872 
873     function userWineBalanceOf(address tokenOwner, uint256 _wineID) public view returns (uint256) {
874         return userWineInfo[tokenOwner][_wineID].amount;
875     }
876 
877     function userUnclaimWine(address tokenOwner) public view returns (uint256[] memory) {
878         uint256[] memory userWine = new uint256[](wineInfo.length);
879         for(uint i = 0; i < wineInfo.length; i++) {
880             userWine[i] = userWineInfo[tokenOwner][i].amount;
881         }
882         return userWine;
883     }
884 
885     function wineBalanceOf(uint256 _wineID) public view returns (uint256) {
886         return wineInfo[_wineID].amount;
887     }
888 
889     // Add a new wine. Can only be called by the owner.
890     function addWine(uint256 _wineID, uint256 _amount, uint256 _fixedPrice) external onlyOwner {
891         require(_amount.add(GRAPWine.totalSupply(_wineID)) <= GRAPWine.maxSupply(_wineID), "Max supply reached");
892         totalWineAmount = totalWineAmount.add(_amount);
893         originalTotalWineAmount = originalTotalWineAmount.add(_amount);
894         wineInfo.push(WineInfo({
895             wineID: _wineID,
896             amount: _amount,
897             fixedPrice: _fixedPrice
898         }));
899     }
900 
901     // Update wine.
902     // It's always decrease.
903     function _updateWine(uint256 _wid, uint256 amount) internal {
904         WineInfo storage wine = wineInfo[_wid];
905         wine.amount = wine.amount.sub(amount);
906         totalWineAmount = totalWineAmount.sub(amount);
907     }
908 
909     // Update user wine
910     function _addUserWine(address user, uint256 _wid, uint256 amount) internal {
911         UserWineInfo storage userWine = userWineInfo[user][_wid];
912         userWine.amount = userWine.amount.add(amount);
913     }
914     function _removeUserWine(address user, uint256 _wid, uint256 amount) internal {
915         UserWineInfo storage userWine = userWineInfo[user][_wid];
916         userWine.amount = userWine.amount.sub(amount);
917     }
918 
919     // Draw main function
920     function _draw() internal view returns (uint256) {
921         uint256 seed = uint256(keccak256(abi.encodePacked(now, block.difficulty, msg.sender)));
922         uint256 rnd = UniformRandomNumber.uniform(seed, totalWineAmount);
923         // Sort by rarity. Avoid gas attacks, start from the tail.
924         for(uint i = wineInfo.length - 1; i > 0; --i){
925             if(rnd < wineInfo[i].amount){
926                 return i;
927             }
928             rnd = rnd - wineInfo[i].amount;
929         }
930         // should not happen.
931         return uint256(-1);
932     }
933 
934     // Draw a wine
935     function draw() external {
936         // EOA only
937         require(msg.sender == tx.origin);
938 
939         require(ticketBalances[msg.sender] >= ticketsConsumed, "Tickets are not enough.");
940         ticketBalances[msg.sender] = ticketBalances[msg.sender].sub(ticketsConsumed);
941 
942         uint256 _rwid = _draw();
943         // Reward reduced
944         _updateWine(_rwid, 1);
945         _addUserWine(msg.sender, _rwid, 1);
946 
947         emit Reward(msg.sender, _rwid);
948     }
949 
950     // Airdrop by owner
951     function airDrop() external onlyOwner {
952 
953         uint256 _rwid = _draw();
954         // Reward reduced
955         _updateWine(_rwid, 1);
956 
957         uint256 seed = uint256(keccak256(abi.encodePacked(now, _rwid)));
958         bool status = false;
959         uint256 rnd = 0;
960 
961         while (!status) {
962             rnd = UniformRandomNumber.uniform(seed, airdropList.length);
963             status = addressAvailable[airdropList[rnd]];
964             seed = uint256(keccak256(abi.encodePacked(seed, rnd)));
965         }
966 
967         _addUserWine(airdropList[rnd], _rwid, 1);
968         emit AirDrop(airdropList[rnd], _rwid);
969     }
970 
971     // Airdrop by user
972     function airDropByUser() external {
973 
974         // EOA only
975         require(msg.sender == tx.origin);
976 
977         require(ticketBalances[msg.sender] >= ticketsConsumed, "Tickets are not enough.");
978         ticketBalances[msg.sender] = ticketBalances[msg.sender].sub(ticketsConsumed);
979         
980         uint256 _rwid = _draw();
981         // Reward reduced
982         _updateWine(_rwid, 1);
983 
984         uint256 seed = uint256(keccak256(abi.encodePacked(now, _rwid)));
985         bool status = false;
986         uint256 rnd = 0;
987 
988         while (!status) {
989             rnd = UniformRandomNumber.uniform(seed, airdropList.length);
990             status = addressAvailable[airdropList[rnd]];
991             seed = uint256(keccak256(abi.encodePacked(seed, rnd)));
992         }
993 
994         _addUserWine(airdropList[rnd], _rwid, 1);
995         emit AirDrop(airdropList[rnd], _rwid);
996     }
997 
998     // pool's fee & artist's fee
999     function withdrawFee() external onlyOwner {
1000         msg.sender.transfer(address(this).balance);
1001     }
1002 
1003     // Compute claim fee.
1004     function claimFee(uint256 _wid, uint256 amount) public view returns (uint256){
1005         WineInfo storage wine = wineInfo[_wid];
1006         return amount * wine.fixedPrice * (totalFee) / (base);
1007     }
1008 
1009     // User claim wine.
1010     function claim(uint256 _wid, uint256 amount) external payable {
1011         UserWineInfo storage userWine = userWineInfo[msg.sender][_wid];
1012         require(amount > 0, "amount must not zero");
1013         require(userWine.amount >= amount, "amount is bad");
1014         require(msg.value == claimFee(_wid, amount), "need payout claim fee");
1015 
1016         _removeUserWine(msg.sender, _wid, amount);
1017         GRAPWine.mint(msg.sender, _wid, amount, "");
1018     }
1019 }
1020 
1021 contract BrewMaster is Brewer {
1022     // Info of each user.
1023     struct UserLPInfo {
1024         uint256 amount;       // How many LP tokens the user has provided.
1025         uint256 rewardTicket; // Reward ticket. 
1026     }
1027 
1028     // Info of each pool.
1029     struct PoolInfo {
1030         IERC20 lpToken;            // Address of LP token contract.
1031         uint256 allocPoint;        // How many allocation points assigned to this pool. TICKETs to distribute per block.
1032         uint256 lastRewardBlock;   // Last block number that TICKETs distribution occurs.
1033         uint256 accTicketPerShare; // Accumulated TICKETs per share, times 1e12. See below.
1034     }
1035     // TICKET tokens created per block.
1036     uint256 public ticketPerBlock;
1037     // Info of each pool.
1038     PoolInfo[] public poolInfo;
1039     // Info of each user that stakes LP tokens.
1040     mapping (uint256 => mapping (address => UserLPInfo)) public userLPInfo;
1041     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1042     uint256 public totalAllocPoint = 0;
1043     // The block number when TICKET mining starts.
1044     uint256 public startBlock;
1045 
1046     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1047     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1048     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1049 
1050     constructor(
1051         IGRAPWine _GRAPWine,
1052         uint256 _ticketPerBlock,
1053         uint256 _startBlock
1054     ) public {
1055         GRAPWine = _GRAPWine;
1056         ticketPerBlock = _ticketPerBlock;
1057         startBlock = _startBlock;
1058         wineInfo.push(WineInfo({
1059             wineID: 0,
1060             amount: 0,
1061             fixedPrice: 0
1062         }));
1063     }
1064 
1065     function poolLength() external view returns (uint256) {
1066         return poolInfo.length;
1067     }
1068 
1069     // Add a new lp to the pool. Can only be called by the owner.
1070     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1071     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1072         if (_withUpdate) {
1073             massUpdatePools();
1074         }
1075         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1076         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1077         poolInfo.push(PoolInfo({
1078             lpToken: _lpToken,
1079             allocPoint: _allocPoint,
1080             lastRewardBlock: lastRewardBlock,
1081             accTicketPerShare: 0
1082         }));
1083     }
1084 
1085     // Update the given pool's Tickets allocation point. Can only be called by the owner.
1086     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1087         if (_withUpdate) {
1088             massUpdatePools();
1089         }
1090         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1091         poolInfo[_pid].allocPoint = _allocPoint;
1092     }
1093 
1094     // Return reward multiplier over the given _from to _to block.
1095     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
1096         return _to.sub(_from);
1097     }
1098 
1099     // View function to see pending Tickets on frontend.
1100     function pendingTicket(uint256 _pid, address _user) external view returns (uint256) {
1101         PoolInfo storage pool = poolInfo[_pid];
1102         UserLPInfo storage user = userLPInfo[_pid][_user];
1103         uint256 accTicketPerShare = pool.accTicketPerShare;
1104         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1105         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1106             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1107             uint256 ticketReward = multiplier.mul(ticketPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1108             accTicketPerShare = accTicketPerShare.add(ticketReward.mul(1e12).div(lpSupply));
1109         }
1110         return user.amount.mul(accTicketPerShare).div(1e12).sub(user.rewardTicket);
1111     }
1112 
1113     // Update reward vairables for all pools. Be careful of gas spending!
1114     function massUpdatePools() public {
1115         uint256 length = poolInfo.length;
1116         for (uint256 pid = 0; pid < length; ++pid) {
1117             updatePool(pid);
1118         }
1119     }
1120 
1121     // Update reward variables of the given pool to be up-to-date.
1122     function updatePool(uint256 _pid) public {
1123         PoolInfo storage pool = poolInfo[_pid];
1124         if (block.number <= pool.lastRewardBlock) {
1125             return;
1126         }
1127         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1128         if (lpSupply == 0) {
1129             pool.lastRewardBlock = block.number;
1130             return;
1131         }
1132         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1133         uint256 ticketReward = multiplier.mul(ticketPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1134         pool.accTicketPerShare = pool.accTicketPerShare.add(ticketReward.mul(1e12).div(lpSupply));
1135         pool.lastRewardBlock = block.number;
1136     }
1137 
1138     // Deposit LP tokens to Brewer for TICKET allocation.
1139     function deposit(uint256 _pid, uint256 _amount) public {
1140         // EOA only
1141         require(msg.sender == tx.origin);
1142 
1143         PoolInfo storage pool = poolInfo[_pid];
1144         UserLPInfo storage user = userLPInfo[_pid][msg.sender];
1145         updatePool(_pid);
1146         if (user.amount > 0) {
1147             uint256 pending = user.amount.mul(pool.accTicketPerShare).div(1e12).sub(user.rewardTicket);
1148             ticketBalances[msg.sender] = ticketBalances[msg.sender].add(pending);
1149         }
1150         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1151         user.amount = user.amount.add(_amount);
1152         user.rewardTicket = user.amount.mul(pool.accTicketPerShare).div(1e12);
1153         if (user.amount > 0){
1154             addressAvailable[msg.sender] = true;
1155             if(!addressAvailableHistory[msg.sender]){
1156                 addressAvailableHistory[msg.sender] = true;
1157                 airdropList.push(msg.sender);
1158             }
1159         }
1160         emit Deposit(msg.sender, _pid, _amount);
1161     }
1162 
1163     // Withdraw LP tokens from Brewer.
1164     function withdraw(uint256 _pid, uint256 _amount) public {
1165         PoolInfo storage pool = poolInfo[_pid];
1166         UserLPInfo storage user = userLPInfo[_pid][msg.sender];
1167         require(user.amount >= _amount, "withdraw: not good");
1168         updatePool(_pid);
1169         uint256 pending = user.amount.mul(pool.accTicketPerShare).div(1e12).sub(user.rewardTicket);
1170         ticketBalances[msg.sender] = ticketBalances[msg.sender].add(pending);
1171         user.amount = user.amount.sub(_amount);
1172         user.rewardTicket = user.amount.mul(pool.accTicketPerShare).div(1e12);
1173         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1174         if (user.amount == 0){
1175             addressAvailable[msg.sender] = false;
1176         }
1177         emit Withdraw(msg.sender, _pid, _amount);
1178     }
1179 
1180     // Withdraw without caring about rewards. EMERGENCY ONLY.
1181     function emergencyWithdraw(uint256 _pid) public {
1182         PoolInfo storage pool = poolInfo[_pid];
1183         UserLPInfo storage user = userLPInfo[_pid][msg.sender];
1184         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1185         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1186         user.amount = 0;
1187         user.rewardTicket = 0;
1188         addressAvailable[msg.sender] = false;
1189     }
1190 }