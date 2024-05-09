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
775 /**
776  * @dev Implementation of the {IERC20} interface.
777  *
778  * This implementation is agnostic to the way tokens are created. This means
779  * that a supply mechanism has to be added in a derived contract using {_mint}.
780  * For a generic mechanism see {ERC20PresetMinterPauser}.
781  *
782  * TIP: For a detailed writeup see our guide
783  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
784  * to implement supply mechanisms].
785  *
786  * We have followed general OpenZeppelin guidelines: functions revert instead
787  * of returning `false` on failure. This behavior is nonetheless conventional
788  * and does not conflict with the expectations of ERC20 applications.
789  *
790  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
791  * This allows applications to reconstruct the allowance for all accounts just
792  * by listening to said events. Other implementations of the EIP may not emit
793  * these events, as it isn't required by the specification.
794  *
795  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
796  * functions have been added to mitigate the well-known issues around setting
797  * allowances. See {IERC20-approve}.
798  */
799 contract ERC20 is Context, IERC20 {
800     using SafeMath for uint256;
801     using Address for address;
802 
803     mapping (address => uint256) private _balances;
804 
805     mapping (address => mapping (address => uint256)) private _allowances;
806 
807     uint256 private _totalSupply;
808 
809     string private _name;
810     string private _symbol;
811     uint8 private _decimals;
812 
813     /**
814      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
815      * a default value of 18.
816      *
817      * To select a different value for {decimals}, use {_setupDecimals}.
818      *
819      * All three of these values are immutable: they can only be set once during
820      * construction.
821      */
822     constructor (string memory name, string memory symbol) public {
823         _name = name;
824         _symbol = symbol;
825         _decimals = 18;
826     }
827 
828     /**
829      * @dev Returns the name of the token.
830      */
831     function name() public view returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev Returns the symbol of the token, usually a shorter version of the
837      * name.
838      */
839     function symbol() public view returns (string memory) {
840         return _symbol;
841     }
842 
843     /**
844      * @dev Returns the number of decimals used to get its user representation.
845      * For example, if `decimals` equals `2`, a balance of `505` tokens should
846      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
847      *
848      * Tokens usually opt for a value of 18, imitating the relationship between
849      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
850      * called.
851      *
852      * NOTE: This information is only used for _display_ purposes: it in
853      * no way affects any of the arithmetic of the contract, including
854      * {IERC20-balanceOf} and {IERC20-transfer}.
855      */
856     function decimals() public view returns (uint8) {
857         return _decimals;
858     }
859 
860     /**
861      * @dev See {IERC20-totalSupply}.
862      */
863     function totalSupply() public view override returns (uint256) {
864         return _totalSupply;
865     }
866 
867     /**
868      * @dev See {IERC20-balanceOf}.
869      */
870     function balanceOf(address account) public view override returns (uint256) {
871         return _balances[account];
872     }
873 
874     /**
875      * @dev See {IERC20-transfer}.
876      *
877      * Requirements:
878      *
879      * - `recipient` cannot be the zero address.
880      * - the caller must have a balance of at least `amount`.
881      */
882     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
883         _transfer(_msgSender(), recipient, amount);
884         return true;
885     }
886 
887     /**
888      * @dev See {IERC20-allowance}.
889      */
890     function allowance(address owner, address spender) public view virtual override returns (uint256) {
891         return _allowances[owner][spender];
892     }
893 
894     /**
895      * @dev See {IERC20-approve}.
896      *
897      * Requirements:
898      *
899      * - `spender` cannot be the zero address.
900      */
901     function approve(address spender, uint256 amount) public virtual override returns (bool) {
902         _approve(_msgSender(), spender, amount);
903         return true;
904     }
905 
906     /**
907      * @dev See {IERC20-transferFrom}.
908      *
909      * Emits an {Approval} event indicating the updated allowance. This is not
910      * required by the EIP. See the note at the beginning of {ERC20};
911      *
912      * Requirements:
913      * - `sender` and `recipient` cannot be the zero address.
914      * - `sender` must have a balance of at least `amount`.
915      * - the caller must have allowance for ``sender``'s tokens of at least
916      * `amount`.
917      */
918     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
919         _transfer(sender, recipient, amount);
920         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
921         return true;
922     }
923 
924     /**
925      * @dev Atomically increases the allowance granted to `spender` by the caller.
926      *
927      * This is an alternative to {approve} that can be used as a mitigation for
928      * problems described in {IERC20-approve}.
929      *
930      * Emits an {Approval} event indicating the updated allowance.
931      *
932      * Requirements:
933      *
934      * - `spender` cannot be the zero address.
935      */
936     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
937         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
938         return true;
939     }
940 
941     /**
942      * @dev Atomically decreases the allowance granted to `spender` by the caller.
943      *
944      * This is an alternative to {approve} that can be used as a mitigation for
945      * problems described in {IERC20-approve}.
946      *
947      * Emits an {Approval} event indicating the updated allowance.
948      *
949      * Requirements:
950      *
951      * - `spender` cannot be the zero address.
952      * - `spender` must have allowance for the caller of at least
953      * `subtractedValue`.
954      */
955     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
956         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
957         return true;
958     }
959 
960     /**
961      * @dev Moves tokens `amount` from `sender` to `recipient`.
962      *
963      * This is internal function is equivalent to {transfer}, and can be used to
964      * e.g. implement automatic token fees, slashing mechanisms, etc.
965      *
966      * Emits a {Transfer} event.
967      *
968      * Requirements:
969      *
970      * - `sender` cannot be the zero address.
971      * - `recipient` cannot be the zero address.
972      * - `sender` must have a balance of at least `amount`.
973      */
974     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
975         require(sender != address(0), "ERC20: transfer from the zero address");
976         require(recipient != address(0), "ERC20: transfer to the zero address");
977 
978         _beforeTokenTransfer(sender, recipient, amount);
979 
980         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
981         _balances[recipient] = _balances[recipient].add(amount);
982         emit Transfer(sender, recipient, amount);
983     }
984 
985     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
986      * the total supply.
987      *
988      * Emits a {Transfer} event with `from` set to the zero address.
989      *
990      * Requirements
991      *
992      * - `to` cannot be the zero address.
993      */
994     function _mint(address account, uint256 amount) internal virtual {
995         require(account != address(0), "ERC20: mint to the zero address");
996 
997         _beforeTokenTransfer(address(0), account, amount);
998 
999         _totalSupply = _totalSupply.add(amount);
1000         _balances[account] = _balances[account].add(amount);
1001         emit Transfer(address(0), account, amount);
1002     }
1003 
1004     /**
1005      * @dev Destroys `amount` tokens from `account`, reducing the
1006      * total supply.
1007      *
1008      * Emits a {Transfer} event with `to` set to the zero address.
1009      *
1010      * Requirements
1011      *
1012      * - `account` cannot be the zero address.
1013      * - `account` must have at least `amount` tokens.
1014      */
1015     function _burn(address account, uint256 amount) internal virtual {
1016         require(account != address(0), "ERC20: burn from the zero address");
1017 
1018         _beforeTokenTransfer(account, address(0), amount);
1019 
1020         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1021         _totalSupply = _totalSupply.sub(amount);
1022         emit Transfer(account, address(0), amount);
1023     }
1024 
1025     /**
1026      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1027      *
1028      * This is internal function is equivalent to `approve`, and can be used to
1029      * e.g. set automatic allowances for certain subsystems, etc.
1030      *
1031      * Emits an {Approval} event.
1032      *
1033      * Requirements:
1034      *
1035      * - `owner` cannot be the zero address.
1036      * - `spender` cannot be the zero address.
1037      */
1038     function _approve(address owner, address spender, uint256 amount) internal virtual {
1039         require(owner != address(0), "ERC20: approve from the zero address");
1040         require(spender != address(0), "ERC20: approve to the zero address");
1041 
1042         _allowances[owner][spender] = amount;
1043         emit Approval(owner, spender, amount);
1044     }
1045 
1046     /**
1047      * @dev Sets {decimals} to a value other than the default one of 18.
1048      *
1049      * WARNING: This function should only be called from the constructor. Most
1050      * applications that interact with token contracts will not expect
1051      * {decimals} to ever change, and may work incorrectly if it does.
1052      */
1053     function _setupDecimals(uint8 decimals_) internal {
1054         _decimals = decimals_;
1055     }
1056 
1057     /**
1058      * @dev Hook that is called before any transfer of tokens. This includes
1059      * minting and burning.
1060      *
1061      * Calling conditions:
1062      *
1063      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1064      * will be to transferred to `to`.
1065      * - when `from` is zero, `amount` tokens will be minted for `to`.
1066      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1067      * - `from` and `to` are never both zero.
1068      *
1069      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1070      */
1071     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1072 }
1073 
1074 // GrowDeFiToken with Governance.
1075 contract GrowDeFiToken is ERC20("GrowDeFi.capital", "GRDEFI"), Ownable {
1076     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (DefiMaster).
1077     function mint(address _to, uint256 _amount) public onlyOwner {
1078         _mint(_to, _amount);
1079         _moveDelegates(address(0), _delegates[_to], _amount);
1080     }
1081 
1082     // Copied and modified from YAM code:
1083     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1084     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1085     // Which is copied and modified from COMPOUND:
1086     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1087 
1088     /// @notice A record of each accounts delegate
1089     mapping (address => address) internal _delegates;
1090 
1091     /// @notice A checkpoint for marking number of votes from a given block
1092     struct Checkpoint {
1093         uint32 fromBlock;
1094         uint256 votes;
1095     }
1096 
1097     /// @notice A record of votes checkpoints for each account, by index
1098     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1099 
1100     /// @notice The number of checkpoints for each account
1101     mapping (address => uint32) public numCheckpoints;
1102 
1103     /// @notice The EIP-712 typehash for the contract's domain
1104     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1105 
1106     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1107     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1108 
1109     /// @notice A record of states for signing / validating signatures
1110     mapping (address => uint) public nonces;
1111 
1112       /// @notice An event thats emitted when an account changes its delegate
1113     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1114 
1115     /// @notice An event thats emitted when a delegate account's vote balance changes
1116     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1117 
1118     /**
1119      * @notice Delegate votes from `msg.sender` to `delegatee`
1120      * @param delegator The address to get delegatee for
1121      */
1122     function delegates(address delegator)
1123         external
1124         view
1125         returns (address)
1126     {
1127         return _delegates[delegator];
1128     }
1129 
1130    /**
1131     * @notice Delegate votes from `msg.sender` to `delegatee`
1132     * @param delegatee The address to delegate votes to
1133     */
1134     function delegate(address delegatee) external {
1135         return _delegate(msg.sender, delegatee);
1136     }
1137 
1138     /**
1139      * @notice Delegates votes from signatory to `delegatee`
1140      * @param delegatee The address to delegate votes to
1141      * @param nonce The contract state required to match the signature
1142      * @param expiry The time at which to expire the signature
1143      * @param v The recovery byte of the signature
1144      * @param r Half of the ECDSA signature pair
1145      * @param s Half of the ECDSA signature pair
1146      */
1147     function delegateBySig(
1148         address delegatee,
1149         uint nonce,
1150         uint expiry,
1151         uint8 v,
1152         bytes32 r,
1153         bytes32 s
1154     )
1155         external
1156     {
1157         bytes32 domainSeparator = keccak256(
1158             abi.encode(
1159                 DOMAIN_TYPEHASH,
1160                 keccak256(bytes(name())),
1161                 getChainId(),
1162                 address(this)
1163             )
1164         );
1165 
1166         bytes32 structHash = keccak256(
1167             abi.encode(
1168                 DELEGATION_TYPEHASH,
1169                 delegatee,
1170                 nonce,
1171                 expiry
1172             )
1173         );
1174 
1175         bytes32 digest = keccak256(
1176             abi.encodePacked(
1177                 "\x19\x01",
1178                 domainSeparator,
1179                 structHash
1180             )
1181         );
1182 
1183         address signatory = ecrecover(digest, v, r, s);
1184         require(signatory != address(0), "GrowDeFi::delegateBySig: invalid signature");
1185         require(nonce == nonces[signatory]++, "GrowDeFi::delegateBySig: invalid nonce");
1186         require(now <= expiry, "GrowDeFi::delegateBySig: signature expired");
1187         return _delegate(signatory, delegatee);
1188     }
1189 
1190     /**
1191      * @notice Gets the current votes balance for `account`
1192      * @param account The address to get votes balance
1193      * @return The number of current votes for `account`
1194      */
1195     function getCurrentVotes(address account)
1196         external
1197         view
1198         returns (uint256)
1199     {
1200         uint32 nCheckpoints = numCheckpoints[account];
1201         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1202     }
1203 
1204     /**
1205      * @notice Determine the prior number of votes for an account as of a block number
1206      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1207      * @param account The address of the account to check
1208      * @param blockNumber The block number to get the vote balance at
1209      * @return The number of votes the account had as of the given block
1210      */
1211     function getPriorVotes(address account, uint blockNumber)
1212         external
1213         view
1214         returns (uint256)
1215     {
1216         require(blockNumber < block.number, "GrowDeFi::getPriorVotes: not yet determined");
1217 
1218         uint32 nCheckpoints = numCheckpoints[account];
1219         if (nCheckpoints == 0) {
1220             return 0;
1221         }
1222 
1223         // First check most recent balance
1224         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1225             return checkpoints[account][nCheckpoints - 1].votes;
1226         }
1227 
1228         // Next check implicit zero balance
1229         if (checkpoints[account][0].fromBlock > blockNumber) {
1230             return 0;
1231         }
1232 
1233         uint32 lower = 0;
1234         uint32 upper = nCheckpoints - 1;
1235         while (upper > lower) {
1236             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1237             Checkpoint memory cp = checkpoints[account][center];
1238             if (cp.fromBlock == blockNumber) {
1239                 return cp.votes;
1240             } else if (cp.fromBlock < blockNumber) {
1241                 lower = center;
1242             } else {
1243                 upper = center - 1;
1244             }
1245         }
1246         return checkpoints[account][lower].votes;
1247     }
1248 
1249     function _delegate(address delegator, address delegatee)
1250         internal
1251     {
1252         address currentDelegate = _delegates[delegator];
1253         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying growdefis (not scaled);
1254         _delegates[delegator] = delegatee;
1255 
1256         emit DelegateChanged(delegator, currentDelegate, delegatee);
1257 
1258         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1259     }
1260 
1261     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1262         if (srcRep != dstRep && amount > 0) {
1263             if (srcRep != address(0)) {
1264                 // decrease old representative
1265                 uint32 srcRepNum = numCheckpoints[srcRep];
1266                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1267                 uint256 srcRepNew = srcRepOld.sub(amount);
1268                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1269             }
1270 
1271             if (dstRep != address(0)) {
1272                 // increase new representative
1273                 uint32 dstRepNum = numCheckpoints[dstRep];
1274                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1275                 uint256 dstRepNew = dstRepOld.add(amount);
1276                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1277             }
1278         }
1279     }
1280 
1281     function _writeCheckpoint(
1282         address delegatee,
1283         uint32 nCheckpoints,
1284         uint256 oldVotes,
1285         uint256 newVotes
1286     )
1287         internal
1288     {
1289         uint32 blockNumber = safe32(block.number, "GrowDeFi::_writeCheckpoint: block number exceeds 32 bits");
1290 
1291         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1292             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1293         } else {
1294             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1295             numCheckpoints[delegatee] = nCheckpoints + 1;
1296         }
1297 
1298         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1299     }
1300 
1301     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1302         require(n < 2**32, errorMessage);
1303         return uint32(n);
1304     }
1305 
1306     function getChainId() internal pure returns (uint) {
1307         uint256 chainId;
1308         assembly { chainId := chainid() }
1309         return chainId;
1310     }
1311 
1312     function transfer(address recipient, uint256 amount) public override returns (bool) {
1313         _transfer(_msgSender(), recipient, amount);
1314         _moveDelegates(_delegates[_msgSender()], _delegates[recipient], amount);
1315         return true;
1316     }
1317 }
1318 
1319 interface IMigratorDefiMaster {
1320     // Perform LP token migration from legacy UniswapV2 to GrowDeFiSwap.
1321     // Take the current LP token address and return the new LP token address.
1322     // Migrator should have full access to the caller's LP token.
1323     // Return the new LP token address.
1324     //
1325     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1326     // GrowDeFiSwap must mint EXACTLY the same amount of GrowDeFiSwap LP tokens or
1327     // else something bad will happen. Traditional UniswapV2 does not
1328     // do that so be careful!
1329     function migrate(IERC20 token) external returns (IERC20);
1330 }
1331 
1332 // DefiMaster is the master of GrowDeFi. He can make GrowDeFi and he is a fair guy.
1333 //
1334 // Note that it's ownable and the owner wields tremendous power. The ownership
1335 // will be transferred to a governance smart contract once GrowDeFi is sufficiently
1336 // distributed and the community can show to govern itself.
1337 //
1338 // Have fun reading it. Hopefully it's bug-free. God bless.
1339 contract DefiMaster is Ownable {
1340     using SafeMath for uint256;
1341     using SafeERC20 for IERC20;
1342 
1343     // Info of each user.
1344     struct UserInfo {
1345         uint256 amount;     // How many LP tokens the user has provided.
1346         uint256 rewardDebt; // Reward debt. See explanation below.
1347         //
1348         // We do some fancy math here. Basically, any point in time, the amount of growdefis
1349         // entitled to a user but is pending to be distributed is:
1350         //
1351         //   pending reward = (user.amount * pool.accGrowDeFiPerShare) - user.rewardDebt
1352         //
1353         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1354         //   1. The pool's `accGrowDeFiPerShare` (and `lastRewardBlock`) gets updated.
1355         //   2. User receives the pending reward sent to his/her address.
1356         //   3. User's `amount` gets updated.
1357         //   4. User's `rewardDebt` gets updated.
1358     }
1359 
1360     // Info of each pool.
1361     struct PoolInfo {
1362         IERC20 lpToken;           // Address of LP token contract.
1363         uint256 allocPoint;       // How many allocation points assigned to this pool. growdefis to distribute per block.
1364         uint256 lastRewardBlock;  // Last block number that growdefis distribution occurs.
1365         uint256 accGrowDeFiPerShare; // Accumulated growdefis per share, times 1e12. See below.
1366     }
1367 
1368     // The GrowDeFi TOKEN!
1369     GrowDeFiToken public GrowDeFi;
1370     // Dev address.
1371     address public devaddr;
1372     // Block number when bonus GrowDeFi period ends.
1373     uint256 public bonusEndBlock;
1374     // GrowDeFi tokens created per block.
1375     uint256 public growdefiPerBlock;
1376     // Bonus muliplier for early GrowDeFi makers.
1377     uint256 public constant BONUS_MULTIPLIER = 5;
1378     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1379     IMigratorDefiMaster public migrator;
1380 
1381     // Info of each pool.
1382     PoolInfo[] public poolInfo;
1383     // Info of each user that stakes LP tokens.
1384     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1385     // Track all added pools to prevent adding the same pool more then once.
1386     mapping (address => bool) public addedPoolLp;
1387     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1388     uint256 public totalAllocPoint = 0;
1389     // The block number when GrowDeFi mining starts.
1390     uint256 public startBlock;
1391 
1392     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1393     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1394     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1395 
1396     constructor(
1397         GrowDeFiToken _growdefi,
1398         address _devaddr,
1399         uint256 _growdefiPerBlock,
1400         uint256 _startBlock,
1401         uint256 _bonusEndBlock
1402     ) public {
1403         GrowDeFi = _growdefi;
1404         devaddr = _devaddr;
1405         growdefiPerBlock = _growdefiPerBlock;
1406         bonusEndBlock = _bonusEndBlock;
1407         startBlock = _startBlock;
1408     }
1409 
1410     function poolLength() external view returns (uint256) {
1411         return poolInfo.length;
1412     }
1413 
1414     // Add a new lp to the pool. Can only be called by the owner.
1415     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1416         require(addedPoolLp[address(_lpToken)] == false, "Token Address already exists in pool");
1417         addedPoolLp[address(_lpToken)] = true;
1418         if (_withUpdate) {
1419             massUpdatePools();
1420         }
1421         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1422         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1423         poolInfo.push(PoolInfo({
1424             lpToken: _lpToken,
1425             allocPoint: _allocPoint,
1426             lastRewardBlock: lastRewardBlock,
1427             accGrowDeFiPerShare: 0
1428         }));
1429     }
1430 
1431     // Update the given pool's GrowDeFi allocation point. Can only be called by the owner.
1432     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1433         if (_withUpdate) {
1434             massUpdatePools();
1435         }
1436         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1437         poolInfo[_pid].allocPoint = _allocPoint;
1438     }
1439 
1440     // Set the migrator contract. Can only be called by the owner.
1441     function setMigrator(IMigratorDefiMaster _migrator) public onlyOwner {
1442         migrator = _migrator;
1443     }
1444 
1445     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1446     function migrate(uint256 _pid) public {
1447         require(address(migrator) != address(0), "migrate: no migrator");
1448         PoolInfo storage pool = poolInfo[_pid];
1449         IERC20 lpToken = pool.lpToken;
1450         uint256 bal = lpToken.balanceOf(address(this));
1451         lpToken.safeApprove(address(migrator), bal);
1452         IERC20 newLpToken = migrator.migrate(lpToken);
1453         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1454         pool.lpToken = newLpToken;
1455     }
1456 
1457     // Return reward multiplier over the given _from to _to block.
1458     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1459         if (_to <= bonusEndBlock) {
1460             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1461         } else if (_from >= bonusEndBlock) {
1462             return _to.sub(_from);
1463         } else {
1464             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1465                 _to.sub(bonusEndBlock)
1466             );
1467         }
1468     }
1469 
1470     // View function to see pending growdefis on frontend.
1471     function pendingGrowDeFi(uint256 _pid, address _user) external view returns (uint256) {
1472         PoolInfo storage pool = poolInfo[_pid];
1473         UserInfo storage user = userInfo[_pid][_user];
1474         uint256 accGrowDeFiPerShare = pool.accGrowDeFiPerShare;
1475         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1476         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1477             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1478             uint256 growdefiReward = multiplier.mul(growdefiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1479             accGrowDeFiPerShare = accGrowDeFiPerShare.add(growdefiReward.mul(1e12).div(lpSupply));
1480         }
1481         return user.amount.mul(accGrowDeFiPerShare).div(1e12).sub(user.rewardDebt);
1482     }
1483 
1484     // Update reward vairables for all pools. Be careful of gas spending!
1485     function massUpdatePools() public {
1486         uint256 length = poolInfo.length;
1487         for (uint256 pid = 0; pid < length; ++pid) {
1488             updatePool(pid);
1489         }
1490     }
1491 
1492     // Update reward variables of the given pool to be up-to-date.
1493     function updatePool(uint256 _pid) public {
1494         PoolInfo storage pool = poolInfo[_pid];
1495         if (block.number <= pool.lastRewardBlock) {
1496             return;
1497         }
1498         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1499         if (lpSupply == 0) {
1500             pool.lastRewardBlock = block.number;
1501             return;
1502         }
1503         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1504         uint256 growdefiReward = multiplier.mul(growdefiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1505         GrowDeFi.mint(address(this), growdefiReward);
1506         pool.accGrowDeFiPerShare = pool.accGrowDeFiPerShare.add(growdefiReward.mul(1e12).div(lpSupply));
1507         pool.lastRewardBlock = block.number;
1508     }
1509 
1510     // Deposit LP tokens to DefiMaster for GrowDeFi allocation.
1511     function deposit(uint256 _pid, uint256 _amount) public {
1512         PoolInfo storage pool = poolInfo[_pid];
1513         UserInfo storage user = userInfo[_pid][msg.sender];
1514         updatePool(_pid);
1515         if (user.amount > 0) {
1516             uint256 pending = user.amount.mul(pool.accGrowDeFiPerShare).div(1e12).sub(user.rewardDebt);
1517             if(pending > 0) {
1518                 safeGrowDeFiTransfer(msg.sender, pending);
1519             }
1520         }
1521         if(_amount > 0) {
1522             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1523             user.amount = user.amount.add(_amount);
1524         }
1525         user.rewardDebt = user.amount.mul(pool.accGrowDeFiPerShare).div(1e12);
1526         emit Deposit(msg.sender, _pid, _amount);
1527     }
1528 
1529     // Withdraw LP tokens from DefiMaster.
1530     function withdraw(uint256 _pid, uint256 _amount) public {
1531         PoolInfo storage pool = poolInfo[_pid];
1532         UserInfo storage user = userInfo[_pid][msg.sender];
1533         require(user.amount >= _amount, "withdraw: not good");
1534         updatePool(_pid);
1535         uint256 pending = user.amount.mul(pool.accGrowDeFiPerShare).div(1e12).sub(user.rewardDebt);
1536         if(pending > 0) {
1537             safeGrowDeFiTransfer(msg.sender, pending);
1538         }
1539         if(_amount > 0) {
1540             user.amount = user.amount.sub(_amount);
1541             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1542         }
1543         user.rewardDebt = user.amount.mul(pool.accGrowDeFiPerShare).div(1e12);
1544         emit Withdraw(msg.sender, _pid, _amount);
1545     }
1546 
1547     // Withdraw without caring about rewards. EMERGENCY ONLY.
1548     function emergencyWithdraw(uint256 _pid) public {
1549         PoolInfo storage pool = poolInfo[_pid];
1550         UserInfo storage user = userInfo[_pid][msg.sender];
1551         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1552         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1553         user.amount = 0;
1554         user.rewardDebt = 0;
1555     }
1556 
1557     // Safe GrowDeFi transfer function, just in case if rounding error causes pool to not have enough growdefis.
1558     function safeGrowDeFiTransfer(address _to, uint256 _amount) internal {
1559         uint256 growdefiBal = GrowDeFi.balanceOf(address(this));
1560         if (_amount > growdefiBal) {
1561             GrowDeFi.transfer(_to, growdefiBal);
1562         } else {
1563             GrowDeFi.transfer(_to, _amount);
1564         }
1565     }
1566 
1567     // Update dev address by the previous dev.
1568     function dev(address _devaddr) public {
1569         require(msg.sender == devaddr, "dev: wut?");
1570         devaddr = _devaddr;
1571     }
1572 }