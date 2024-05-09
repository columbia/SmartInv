1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
81 
82 
83 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
84 
85 
86 pragma solidity ^0.6.0;
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      *
158      * - Multiplication cannot overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint256 c = a * b;
169         require(c / a == b, "SafeMath: multiplication overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         return div(a, b, "SafeMath: division by zero");
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b > 0, errorMessage);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         return mod(a, b, "SafeMath: modulo by zero");
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts with custom message when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b != 0, errorMessage);
240         return a % b;
241     }
242 }
243 
244 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
245 
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
388 
389 
390 pragma solidity ^0.6.0;
391 
392 
393 
394 
395 /**
396  * @title SafeERC20
397  * @dev Wrappers around ERC20 operations that throw on failure (when the token
398  * contract returns false). Tokens that return no value (and instead revert or
399  * throw on failure) are also supported, non-reverting calls are assumed to be
400  * successful.
401  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
402  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
403  */
404 library SafeERC20 {
405     using SafeMath for uint256;
406     using Address for address;
407 
408     function safeTransfer(IERC20 token, address to, uint256 value) internal {
409         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
410     }
411 
412     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
413         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
414     }
415 
416     /**
417      * @dev Deprecated. This function has issues similar to the ones found in
418      * {IERC20-approve}, and its usage is discouraged.
419      *
420      * Whenever possible, use {safeIncreaseAllowance} and
421      * {safeDecreaseAllowance} instead.
422      */
423     function safeApprove(IERC20 token, address spender, uint256 value) internal {
424         // safeApprove should only be called when setting an initial allowance,
425         // or when resetting it to zero. To increase and decrease it, use
426         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
427         // solhint-disable-next-line max-line-length
428         require((value == 0) || (token.allowance(address(this), spender) == 0),
429             "SafeERC20: approve from non-zero to non-zero allowance"
430         );
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
432     }
433 
434     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).add(value);
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     /**
445      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
446      * on the return value: the return value is optional (but if data is returned, it must not be false).
447      * @param token The token targeted by the call.
448      * @param data The call data (encoded using abi.encode or one of its variants).
449      */
450     function _callOptionalReturn(IERC20 token, bytes memory data) private {
451         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
452         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
453         // the target address contains contract code and also asserts for success in the low-level call.
454 
455         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
456         if (returndata.length > 0) { // Return data is optional
457             // solhint-disable-next-line max-line-length
458             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
459         }
460     }
461 }
462 
463 // File: @openzeppelin\contracts\utils\EnumerableSet.sol
464 
465 
466 pragma solidity ^0.6.0;
467 
468 /**
469  * @dev Library for managing
470  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
471  * types.
472  *
473  * Sets have the following properties:
474  *
475  * - Elements are added, removed, and checked for existence in constant time
476  * (O(1)).
477  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
478  *
479  * ```
480  * contract Example {
481  *     // Add the library methods
482  *     using EnumerableSet for EnumerableSet.AddressSet;
483  *
484  *     // Declare a set state variable
485  *     EnumerableSet.AddressSet private mySet;
486  * }
487  * ```
488  *
489  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
490  * (`UintSet`) are supported.
491  */
492 library EnumerableSet {
493     // To implement this library for multiple types with as little code
494     // repetition as possible, we write it in terms of a generic Set type with
495     // bytes32 values.
496     // The Set implementation uses private functions, and user-facing
497     // implementations (such as AddressSet) are just wrappers around the
498     // underlying Set.
499     // This means that we can only create new EnumerableSets for types that fit
500     // in bytes32.
501 
502     struct Set {
503         // Storage of set values
504         bytes32[] _values;
505 
506         // Position of the value in the `values` array, plus 1 because index 0
507         // means a value is not in the set.
508         mapping (bytes32 => uint256) _indexes;
509     }
510 
511     /**
512      * @dev Add a value to a set. O(1).
513      *
514      * Returns true if the value was added to the set, that is if it was not
515      * already present.
516      */
517     function _add(Set storage set, bytes32 value) private returns (bool) {
518         if (!_contains(set, value)) {
519             set._values.push(value);
520             // The value is stored at length-1, but we add 1 to all indexes
521             // and use 0 as a sentinel value
522             set._indexes[value] = set._values.length;
523             return true;
524         } else {
525             return false;
526         }
527     }
528 
529     /**
530      * @dev Removes a value from a set. O(1).
531      *
532      * Returns true if the value was removed from the set, that is if it was
533      * present.
534      */
535     function _remove(Set storage set, bytes32 value) private returns (bool) {
536         // We read and store the value's index to prevent multiple reads from the same storage slot
537         uint256 valueIndex = set._indexes[value];
538 
539         if (valueIndex != 0) { // Equivalent to contains(set, value)
540             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
541             // the array, and then remove the last element (sometimes called as 'swap and pop').
542             // This modifies the order of the array, as noted in {at}.
543 
544             uint256 toDeleteIndex = valueIndex - 1;
545             uint256 lastIndex = set._values.length - 1;
546 
547             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
548             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
549 
550             bytes32 lastvalue = set._values[lastIndex];
551 
552             // Move the last value to the index where the value to delete is
553             set._values[toDeleteIndex] = lastvalue;
554             // Update the index for the moved value
555             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
556 
557             // Delete the slot where the moved value was stored
558             set._values.pop();
559 
560             // Delete the index for the deleted slot
561             delete set._indexes[value];
562 
563             return true;
564         } else {
565             return false;
566         }
567     }
568 
569     /**
570      * @dev Returns true if the value is in the set. O(1).
571      */
572     function _contains(Set storage set, bytes32 value) private view returns (bool) {
573         return set._indexes[value] != 0;
574     }
575 
576     /**
577      * @dev Returns the number of values on the set. O(1).
578      */
579     function _length(Set storage set) private view returns (uint256) {
580         return set._values.length;
581     }
582 
583    /**
584     * @dev Returns the value stored at position `index` in the set. O(1).
585     *
586     * Note that there are no guarantees on the ordering of values inside the
587     * array, and it may change when more values are added or removed.
588     *
589     * Requirements:
590     *
591     * - `index` must be strictly less than {length}.
592     */
593     function _at(Set storage set, uint256 index) private view returns (bytes32) {
594         require(set._values.length > index, "EnumerableSet: index out of bounds");
595         return set._values[index];
596     }
597 
598     // AddressSet
599 
600     struct AddressSet {
601         Set _inner;
602     }
603 
604     /**
605      * @dev Add a value to a set. O(1).
606      *
607      * Returns true if the value was added to the set, that is if it was not
608      * already present.
609      */
610     function add(AddressSet storage set, address value) internal returns (bool) {
611         return _add(set._inner, bytes32(uint256(value)));
612     }
613 
614     /**
615      * @dev Removes a value from a set. O(1).
616      *
617      * Returns true if the value was removed from the set, that is if it was
618      * present.
619      */
620     function remove(AddressSet storage set, address value) internal returns (bool) {
621         return _remove(set._inner, bytes32(uint256(value)));
622     }
623 
624     /**
625      * @dev Returns true if the value is in the set. O(1).
626      */
627     function contains(AddressSet storage set, address value) internal view returns (bool) {
628         return _contains(set._inner, bytes32(uint256(value)));
629     }
630 
631     /**
632      * @dev Returns the number of values in the set. O(1).
633      */
634     function length(AddressSet storage set) internal view returns (uint256) {
635         return _length(set._inner);
636     }
637 
638    /**
639     * @dev Returns the value stored at position `index` in the set. O(1).
640     *
641     * Note that there are no guarantees on the ordering of values inside the
642     * array, and it may change when more values are added or removed.
643     *
644     * Requirements:
645     *
646     * - `index` must be strictly less than {length}.
647     */
648     function at(AddressSet storage set, uint256 index) internal view returns (address) {
649         return address(uint256(_at(set._inner, index)));
650     }
651 
652 
653     // UintSet
654 
655     struct UintSet {
656         Set _inner;
657     }
658 
659     /**
660      * @dev Add a value to a set. O(1).
661      *
662      * Returns true if the value was added to the set, that is if it was not
663      * already present.
664      */
665     function add(UintSet storage set, uint256 value) internal returns (bool) {
666         return _add(set._inner, bytes32(value));
667     }
668 
669     /**
670      * @dev Removes a value from a set. O(1).
671      *
672      * Returns true if the value was removed from the set, that is if it was
673      * present.
674      */
675     function remove(UintSet storage set, uint256 value) internal returns (bool) {
676         return _remove(set._inner, bytes32(value));
677     }
678 
679     /**
680      * @dev Returns true if the value is in the set. O(1).
681      */
682     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
683         return _contains(set._inner, bytes32(value));
684     }
685 
686     /**
687      * @dev Returns the number of values on the set. O(1).
688      */
689     function length(UintSet storage set) internal view returns (uint256) {
690         return _length(set._inner);
691     }
692 
693    /**
694     * @dev Returns the value stored at position `index` in the set. O(1).
695     *
696     * Note that there are no guarantees on the ordering of values inside the
697     * array, and it may change when more values are added or removed.
698     *
699     * Requirements:
700     *
701     * - `index` must be strictly less than {length}.
702     */
703     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
704         return uint256(_at(set._inner, index));
705     }
706 }
707 
708 
709 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
710 
711 
712 pragma solidity ^0.6.0;
713 
714 /*
715  * @dev Provides information about the current execution context, including the
716  * sender of the transaction and its data. While these are generally available
717  * via msg.sender and msg.data, they should not be accessed in such a direct
718  * manner, since when dealing with GSN meta-transactions the account sending and
719  * paying for execution may not be the actual sender (as far as an application
720  * is concerned).
721  *
722  * This contract is only required for intermediate, library-like contracts.
723  */
724 abstract contract Context {
725     function _msgSender() internal view virtual returns (address payable) {
726         return msg.sender;
727     }
728 
729     function _msgData() internal view virtual returns (bytes memory) {
730         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
731         return msg.data;
732     }
733 }
734 
735 // File: @openzeppelin\contracts\access\Ownable.sol
736 
737 
738 pragma solidity ^0.6.0;
739 
740 /**
741  * @dev Contract module which provides a basic access control mechanism, where
742  * there is an account (an owner) that can be granted exclusive access to
743  * specific functions.
744  *
745  * By default, the owner account will be the one that deploys the contract. This
746  * can later be changed with {transferOwnership}.
747  *
748  * This module is used through inheritance. It will make available the modifier
749  * `onlyOwner`, which can be applied to your functions to restrict their use to
750  * the owner.
751  */
752 contract Ownable is Context {
753     address private _owner;
754 
755     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
756 
757     /**
758      * @dev Initializes the contract setting the deployer as the initial owner.
759      */
760     constructor () internal {
761         address msgSender = _msgSender();
762         _owner = msgSender;
763         emit OwnershipTransferred(address(0), msgSender);
764     }
765 
766     /**
767      * @dev Returns the address of the current owner.
768      */
769     function owner() public view returns (address) {
770         return _owner;
771     }
772 
773     /**
774      * @dev Throws if called by any account other than the owner.
775      */
776     modifier onlyOwner() {
777         require(_owner == _msgSender(), "Ownable: caller is not the owner");
778         _;
779     }
780 
781     /**
782      * @dev Leaves the contract without owner. It will not be possible to call
783      * `onlyOwner` functions anymore. Can only be called by the current owner.
784      *
785      * NOTE: Renouncing ownership will leave the contract without an owner,
786      * thereby removing any functionality that is only available to the owner.
787      */
788     function renounceOwnership() public virtual onlyOwner {
789         emit OwnershipTransferred(_owner, address(0));
790         _owner = address(0);
791     }
792 
793     /**
794      * @dev Transfers ownership of the contract to a new account (`newOwner`).
795      * Can only be called by the current owner.
796      */
797     function transferOwnership(address newOwner) public virtual onlyOwner {
798         require(newOwner != address(0), "Ownable: new owner is the zero address");
799         emit OwnershipTransferred(_owner, newOwner);
800         _owner = newOwner;
801     }
802 }
803 
804 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
805 
806 
807 pragma solidity ^0.6.0;
808 
809 
810 
811 
812 
813 /**
814  * @dev Implementation of the {IERC20} interface.
815  *
816  * This implementation is agnostic to the way tokens are created. This means
817  * that a supply mechanism has to be added in a derived contract using {_mint}.
818  * For a generic mechanism see {ERC20PresetMinterPauser}.
819  *
820  * TIP: For a detailed writeup see our guide
821  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
822  * to implement supply mechanisms].
823  *
824  * We have followed general OpenZeppelin guidelines: functions revert instead
825  * of returning `false` on failure. This behavior is nonetheless conventional
826  * and does not conflict with the expectations of ERC20 applications.
827  *
828  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
829  * This allows applications to reconstruct the allowance for all accounts just
830  * by listening to said events. Other implementations of the EIP may not emit
831  * these events, as it isn't required by the specification.
832  *
833  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
834  * functions have been added to mitigate the well-known issues around setting
835  * allowances. See {IERC20-approve}.
836  */
837 contract ERC20 is Context, IERC20 {
838     using SafeMath for uint256;
839     using Address for address;
840 
841     mapping (address => uint256) private _balances;
842 
843     mapping (address => mapping (address => uint256)) private _allowances;
844 
845     uint256 private _totalSupply;
846 
847     string private _name;
848     string private _symbol;
849     uint8 private _decimals;
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
860     constructor (string memory name, string memory symbol) public {
861         _name = name;
862         _symbol = symbol;
863         _decimals = 18;
864     }
865 
866     /**
867      * @dev Returns the name of the token.
868      */
869     function name() public view returns (string memory) {
870         return _name;
871     }
872 
873     /**
874      * @dev Returns the symbol of the token, usually a shorter version of the
875      * name.
876      */
877     function symbol() public view returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev Returns the number of decimals used to get its user representation.
883      * For example, if `decimals` equals `2`, a balance of `505` tokens should
884      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
885      *
886      * Tokens usually opt for a value of 18, imitating the relationship between
887      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
888      * called.
889      *
890      * NOTE: This information is only used for _display_ purposes: it in
891      * no way affects any of the arithmetic of the contract, including
892      * {IERC20-balanceOf} and {IERC20-transfer}.
893      */
894     function decimals() public view returns (uint8) {
895         return _decimals;
896     }
897 
898     /**
899      * @dev See {IERC20-totalSupply}.
900      */
901     function totalSupply() public view override returns (uint256) {
902         return _totalSupply;
903     }
904 
905     /**
906      * @dev See {IERC20-balanceOf}.
907      */
908     function balanceOf(address account) public view override returns (uint256) {
909         return _balances[account];
910     }
911 
912     /**
913      * @dev See {IERC20-transfer}.
914      *
915      * Requirements:
916      *
917      * - `recipient` cannot be the zero address.
918      * - the caller must have a balance of at least `amount`.
919      */
920     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
921         _transfer(_msgSender(), recipient, amount);
922         return true;
923     }
924 
925     /**
926      * @dev See {IERC20-allowance}.
927      */
928     function allowance(address owner, address spender) public view virtual override returns (uint256) {
929         return _allowances[owner][spender];
930     }
931 
932     /**
933      * @dev See {IERC20-approve}.
934      *
935      * Requirements:
936      *
937      * - `spender` cannot be the zero address.
938      */
939     function approve(address spender, uint256 amount) public virtual override returns (bool) {
940         _approve(_msgSender(), spender, amount);
941         return true;
942     }
943 
944     /**
945      * @dev See {IERC20-transferFrom}.
946      *
947      * Emits an {Approval} event indicating the updated allowance. This is not
948      * required by the EIP. See the note at the beginning of {ERC20};
949      *
950      * Requirements:
951      * - `sender` and `recipient` cannot be the zero address.
952      * - `sender` must have a balance of at least `amount`.
953      * - the caller must have allowance for ``sender``'s tokens of at least
954      * `amount`.
955      */
956     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
957         _transfer(sender, recipient, amount);
958         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
959         return true;
960     }
961 
962     /**
963      * @dev Atomically increases the allowance granted to `spender` by the caller.
964      *
965      * This is an alternative to {approve} that can be used as a mitigation for
966      * problems described in {IERC20-approve}.
967      *
968      * Emits an {Approval} event indicating the updated allowance.
969      *
970      * Requirements:
971      *
972      * - `spender` cannot be the zero address.
973      */
974     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
975         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
976         return true;
977     }
978 
979     /**
980      * @dev Atomically decreases the allowance granted to `spender` by the caller.
981      *
982      * This is an alternative to {approve} that can be used as a mitigation for
983      * problems described in {IERC20-approve}.
984      *
985      * Emits an {Approval} event indicating the updated allowance.
986      *
987      * Requirements:
988      *
989      * - `spender` cannot be the zero address.
990      * - `spender` must have allowance for the caller of at least
991      * `subtractedValue`.
992      */
993     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
994         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
995         return true;
996     }
997 
998     /**
999      * @dev Moves tokens `amount` from `sender` to `recipient`.
1000      *
1001      * This is internal function is equivalent to {transfer}, and can be used to
1002      * e.g. implement automatic token fees, slashing mechanisms, etc.
1003      *
1004      * Emits a {Transfer} event.
1005      *
1006      * Requirements:
1007      *
1008      * - `sender` cannot be the zero address.
1009      * - `recipient` cannot be the zero address.
1010      * - `sender` must have a balance of at least `amount`.
1011      */
1012     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1013         require(sender != address(0), "ERC20: transfer from the zero address");
1014         require(recipient != address(0), "ERC20: transfer to the zero address");
1015 
1016         _beforeTokenTransfer(sender, recipient, amount);
1017 
1018         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1019         _balances[recipient] = _balances[recipient].add(amount);
1020         emit Transfer(sender, recipient, amount);
1021     }
1022 
1023     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1024      * the total supply.
1025      *
1026      * Emits a {Transfer} event with `from` set to the zero address.
1027      *
1028      * Requirements
1029      *
1030      * - `to` cannot be the zero address.
1031      */
1032     function _mint(address account, uint256 amount) internal virtual {
1033         require(account != address(0), "ERC20: mint to the zero address");
1034 
1035         _beforeTokenTransfer(address(0), account, amount);
1036 
1037         _totalSupply = _totalSupply.add(amount);
1038         _balances[account] = _balances[account].add(amount);
1039         emit Transfer(address(0), account, amount);
1040     }
1041 
1042     /**
1043      * @dev Destroys `amount` tokens from `account`, reducing the
1044      * total supply.
1045      *
1046      * Emits a {Transfer} event with `to` set to the zero address.
1047      *
1048      * Requirements
1049      *
1050      * - `account` cannot be the zero address.
1051      * - `account` must have at least `amount` tokens.
1052      */
1053     function _burn(address account, uint256 amount) internal virtual {
1054         require(account != address(0), "ERC20: burn from the zero address");
1055 
1056         _beforeTokenTransfer(account, address(0), amount);
1057 
1058         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1059         _totalSupply = _totalSupply.sub(amount);
1060         emit Transfer(account, address(0), amount);
1061     }
1062 
1063     /**
1064      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1065      *
1066      * This internal function is equivalent to `approve`, and can be used to
1067      * e.g. set automatic allowances for certain subsystems, etc.
1068      *
1069      * Emits an {Approval} event.
1070      *
1071      * Requirements:
1072      *
1073      * - `owner` cannot be the zero address.
1074      * - `spender` cannot be the zero address.
1075      */
1076     function _approve(address owner, address spender, uint256 amount) internal virtual {
1077         require(owner != address(0), "ERC20: approve from the zero address");
1078         require(spender != address(0), "ERC20: approve to the zero address");
1079 
1080         _allowances[owner][spender] = amount;
1081         emit Approval(owner, spender, amount);
1082     }
1083 
1084     /**
1085      * @dev Sets {decimals} to a value other than the default one of 18.
1086      *
1087      * WARNING: This function should only be called from the constructor. Most
1088      * applications that interact with token contracts will not expect
1089      * {decimals} to ever change, and may work incorrectly if it does.
1090      */
1091     function _setupDecimals(uint8 decimals_) internal {
1092         _decimals = decimals_;
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any transfer of tokens. This includes
1097      * minting and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1102      * will be to transferred to `to`.
1103      * - when `from` is zero, `amount` tokens will be minted for `to`.
1104      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1110 }
1111 
1112 // File: contracts\ZEUSToken.sol
1113 
1114 pragma solidity 0.6.12;
1115 
1116 
1117 
1118 
1119 // ZEUSToken with Governance.
1120 contract ZEUSToken is ERC20("ZEUSToken", "ZEUS"), Ownable {
1121     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1122     function mint(address _to, uint256 _amount) public onlyOwner {
1123         _mint(_to, _amount);
1124         _moveDelegates(address(0), _delegates[_to], _amount);
1125     }
1126 
1127     // Copied and modified from YAM code:
1128     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1129     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1130     // Which is copied and modified from COMPOUND:
1131     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1132 
1133     /// @notice A record of each accounts delegate
1134     mapping (address => address) internal _delegates;
1135 
1136     /// @notice A checkpoint for marking number of votes from a given block
1137     struct Checkpoint {
1138         uint32 fromBlock;
1139         uint256 votes;
1140     }
1141 
1142     /// @notice A record of votes checkpoints for each account, by index
1143     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1144 
1145     /// @notice The number of checkpoints for each account
1146     mapping (address => uint32) public numCheckpoints;
1147 
1148     /// @notice The EIP-712 typehash for the contract's domain
1149     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1150 
1151     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1152     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1153 
1154     /// @notice A record of states for signing / validating signatures
1155     mapping (address => uint) public nonces;
1156 
1157       /// @notice An event thats emitted when an account changes its delegate
1158     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1159 
1160     /// @notice An event thats emitted when a delegate account's vote balance changes
1161     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1162 
1163     /**
1164      * @notice Delegate votes from `msg.sender` to `delegatee`
1165      * @param delegator The address to get delegatee for
1166      */
1167     function delegates(address delegator)
1168         external
1169         view
1170         returns (address)
1171     {
1172         return _delegates[delegator];
1173     }
1174 
1175    /**
1176     * @notice Delegate votes from `msg.sender` to `delegatee`
1177     * @param delegatee The address to delegate votes to
1178     */
1179     function delegate(address delegatee) external {
1180         return _delegate(msg.sender, delegatee);
1181     }
1182 
1183     /**
1184      * @notice Delegates votes from signatory to `delegatee`
1185      * @param delegatee The address to delegate votes to
1186      * @param nonce The contract state required to match the signature
1187      * @param expiry The time at which to expire the signature
1188      * @param v The recovery byte of the signature
1189      * @param r Half of the ECDSA signature pair
1190      * @param s Half of the ECDSA signature pair
1191      */
1192     function delegateBySig(
1193         address delegatee,
1194         uint nonce,
1195         uint expiry,
1196         uint8 v,
1197         bytes32 r,
1198         bytes32 s
1199     )
1200         external
1201     {
1202         bytes32 domainSeparator = keccak256(
1203             abi.encode(
1204                 DOMAIN_TYPEHASH,
1205                 keccak256(bytes(name())),
1206                 getChainId(),
1207                 address(this)
1208             )
1209         );
1210 
1211         bytes32 structHash = keccak256(
1212             abi.encode(
1213                 DELEGATION_TYPEHASH,
1214                 delegatee,
1215                 nonce,
1216                 expiry
1217             )
1218         );
1219 
1220         bytes32 digest = keccak256(
1221             abi.encodePacked(
1222                 "\x19\x01",
1223                 domainSeparator,
1224                 structHash
1225             )
1226         );
1227 
1228         address signatory = ecrecover(digest, v, r, s);
1229         require(signatory != address(0), "ZEUS::delegateBySig: invalid signature");
1230         require(nonce == nonces[signatory]++, "ZEUS::delegateBySig: invalid nonce");
1231         require(now <= expiry, "ZEUS::delegateBySig: signature expired");
1232         return _delegate(signatory, delegatee);
1233     }
1234 
1235     /**
1236      * @notice Gets the current votes balance for `account`
1237      * @param account The address to get votes balance
1238      * @return The number of current votes for `account`
1239      */
1240     function getCurrentVotes(address account)
1241         external
1242         view
1243         returns (uint256)
1244     {
1245         uint32 nCheckpoints = numCheckpoints[account];
1246         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1247     }
1248 
1249     /**
1250      * @notice Determine the prior number of votes for an account as of a block number
1251      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1252      * @param account The address of the account to check
1253      * @param blockNumber The block number to get the vote balance at
1254      * @return The number of votes the account had as of the given block
1255      */
1256     function getPriorVotes(address account, uint blockNumber)
1257         external
1258         view
1259         returns (uint256)
1260     {
1261         require(blockNumber < block.number, "ZEUS::getPriorVotes: not yet determined");
1262 
1263         uint32 nCheckpoints = numCheckpoints[account];
1264         if (nCheckpoints == 0) {
1265             return 0;
1266         }
1267 
1268         // First check most recent balance
1269         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1270             return checkpoints[account][nCheckpoints - 1].votes;
1271         }
1272 
1273         // Next check implicit zero balance
1274         if (checkpoints[account][0].fromBlock > blockNumber) {
1275             return 0;
1276         }
1277 
1278         uint32 lower = 0;
1279         uint32 upper = nCheckpoints - 1;
1280         while (upper > lower) {
1281             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1282             Checkpoint memory cp = checkpoints[account][center];
1283             if (cp.fromBlock == blockNumber) {
1284                 return cp.votes;
1285             } else if (cp.fromBlock < blockNumber) {
1286                 lower = center;
1287             } else {
1288                 upper = center - 1;
1289             }
1290         }
1291         return checkpoints[account][lower].votes;
1292     }
1293 
1294     function _delegate(address delegator, address delegatee)
1295         internal
1296     {
1297         address currentDelegate = _delegates[delegator];
1298         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ZEUSs (not scaled);
1299         _delegates[delegator] = delegatee;
1300 
1301         emit DelegateChanged(delegator, currentDelegate, delegatee);
1302 
1303         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1304     }
1305 
1306     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1307         if (srcRep != dstRep && amount > 0) {
1308             if (srcRep != address(0)) {
1309                 // decrease old representative
1310                 uint32 srcRepNum = numCheckpoints[srcRep];
1311                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1312                 uint256 srcRepNew = srcRepOld.sub(amount);
1313                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1314             }
1315 
1316             if (dstRep != address(0)) {
1317                 // increase new representative
1318                 uint32 dstRepNum = numCheckpoints[dstRep];
1319                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1320                 uint256 dstRepNew = dstRepOld.add(amount);
1321                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1322             }
1323         }
1324     }
1325 
1326     function _writeCheckpoint(
1327         address delegatee,
1328         uint32 nCheckpoints,
1329         uint256 oldVotes,
1330         uint256 newVotes
1331     )
1332         internal
1333     {
1334         uint32 blockNumber = safe32(block.number, "ZEUS::_writeCheckpoint: block number exceeds 32 bits");
1335 
1336         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1337             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1338         } else {
1339             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1340             numCheckpoints[delegatee] = nCheckpoints + 1;
1341         }
1342 
1343         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1344     }
1345 
1346     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1347         require(n < 2**32, errorMessage);
1348         return uint32(n);
1349     }
1350 
1351     function getChainId() internal pure returns (uint) {
1352         uint256 chainId;
1353         assembly { chainId := chainid() }
1354         return chainId;
1355     }
1356 }
1357 
1358 // File: contracts\zeusmain.sol
1359 
1360 pragma solidity 0.6.12;
1361 
1362 
1363 
1364 
1365 
1366 
1367 
1368 
1369 interface IMigratorChef {
1370     // Perform LP token migration from legacy UniswapV2 to ZEUSSwap.
1371     // Take the current LP token address and return the new LP token address.
1372     // Migrator should have full access to the caller's LP token.
1373     // Return the new LP token address.
1374     //
1375     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1376     // ZEUSSwap must mint EXACTLY the same amount of ZEUSSwap LP tokens or
1377     // else something bad will happen. Traditional UniswapV2 does not
1378     // do that so be careful!
1379     function migrate(IERC20 token) external returns (IERC20);
1380 }
1381 
1382 // ZEUSMain is the master of ZEUS. He can make ZEUS and he is a fair guy.
1383 //
1384 // Note that it's ownable and the owner wields tremendous power. The ownership
1385 // will be transferred to a governance smart contract once ZEUS is sufficiently
1386 // distributed and the community can show to govern itself.
1387 //
1388 // Have fun reading it. Hopefully it's bug-free. God bless.
1389 contract ZEUSMain is Ownable {
1390     using SafeMath for uint256;
1391     using SafeERC20 for IERC20;
1392 
1393     // Info of each user.
1394     struct UserInfo {
1395         uint256 amount;     // How many LP tokens the user has provided.
1396         uint256 rewardDebt; // Reward debt. See explanation below.
1397         //
1398         // We do some fancy math here. Basically, any point in time, the amount of ZEUSs
1399         // entitled to a user but is pending to be distributed is:
1400         //
1401         //   pending reward = (user.amount * pool.accZEUSPerShare) - user.rewardDebt
1402         //
1403         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1404         //   1. The pool's `accZEUSPerShare` (and `lastRewardBlock`) gets updated.
1405         //   2. User receives the pending reward sent to his/her address.
1406         //   3. User's `amount` gets updated.
1407         //   4. User's `rewardDebt` gets updated.
1408     }
1409 
1410     // Info of each pool.
1411     struct PoolInfo {
1412         IERC20 lpToken;           // Address of LP token contract.
1413         bool bChange;             // 
1414         bool bLock;               // 
1415         bool bDepositFee;          //
1416         uint256 depositMount;     // 
1417         uint256 changeMount;     // 
1418         uint256 allocPoint;       // How many allocation points assigned to this pool. ZEUSs to distribute per block.
1419         uint256 lastRewardBlock;  // Last block number that ZEUSs distribution occurs.
1420         uint256 accZEUSPerShare; // Accumulated ZEUSs per share, times 1e12. See below.
1421     }
1422 
1423     struct AreaInfo {
1424         uint256 totalAllocPoint;
1425         uint256 rate;
1426     }
1427 
1428     // The ZEUS TOKEN!
1429     ZEUSToken public zeus;
1430     // Dev address.
1431     address public devaddr;
1432     // min per block mint
1433     uint256 public minPerBlock;
1434     // ZEUS tokens created per block.
1435     uint256 public zeusPerBlock;
1436     uint256 public halfPeriod;
1437     uint256 public lockPeriods; // lock periods
1438 
1439     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1440     IMigratorChef public migrator;
1441 
1442     // Info of each pool.
1443     //PoolInfo[] public poolInfo;
1444     mapping (uint256 => PoolInfo[]) public poolInfo;
1445     // Info of each user that stakes LP tokens.
1446     //mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1447     mapping (uint256 => mapping(uint256 => mapping (address => UserInfo))) public userInfo;
1448     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1449     //uint256 public totalAllocPoint = 0;
1450     AreaInfo[] public areaInfo;
1451     uint256 public totalRate = 0;
1452 
1453     // The block number when ZEUS mining starts.
1454     uint256 public startBlock;
1455 
1456     event Deposit(address indexed user, uint256 indexed aid, uint256 indexed pid, uint256 amount);
1457     event Withdraw(address indexed user, uint256 indexed aid, uint256 indexed pid, uint256 amount);
1458     event EmergencyWithdraw(address indexed user, uint256 indexed aid, uint256 indexed pid, uint256 amount);
1459 
1460     constructor(
1461         ZEUSToken _zeus,
1462         address _devaddr,
1463         uint256 _zeusPerBlock,
1464         uint256 _startBlock,
1465         uint256 _minPerBlock,
1466         uint256 _halfPeriod,
1467         uint256 _lockPeriods
1468     ) public {
1469         zeus = _zeus;
1470         devaddr = _devaddr;
1471         zeusPerBlock = _zeusPerBlock;
1472         minPerBlock = _minPerBlock;
1473         startBlock = _startBlock;
1474         halfPeriod = _halfPeriod;
1475         lockPeriods = _lockPeriods;
1476     }
1477 
1478     function buyBackToken(address payable buybackaddr) public onlyOwner {
1479         require(buybackaddr != address(0), "buy back is addr 0");
1480         buybackaddr.transfer(address(this).balance);
1481     }
1482 
1483     function areaLength() external view returns (uint256) {
1484         return areaInfo.length;
1485     }
1486 
1487     function poolLength(uint256 _aid) external view returns (uint256) {
1488         return poolInfo[_aid].length;
1489     }
1490 
1491     function addArea(uint256 _rate, bool _withUpdate) public onlyOwner {
1492 
1493         if (_withUpdate) {
1494             massUpdateAreas();
1495         }
1496 
1497         totalRate = totalRate.add(_rate);
1498         areaInfo.push(AreaInfo({
1499         totalAllocPoint: 0,
1500         rate: _rate
1501         }));
1502     }
1503 
1504     // Add a new lp to the pool. Can only be called by the owner.
1505     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1506     function add(uint256 _aid, uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, bool _bLock, bool _bDepositFee, uint256 _depositFee) public onlyOwner {
1507         if (_withUpdate) {
1508             massUpdatePools(_aid);
1509         }
1510         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1511         areaInfo[_aid].totalAllocPoint = areaInfo[_aid].totalAllocPoint.add(_allocPoint);
1512         poolInfo[_aid].push(PoolInfo({
1513         lpToken: _lpToken,
1514         bChange: false,
1515         bLock: _bLock,
1516         bDepositFee: _bDepositFee,
1517         depositMount: _depositFee,
1518         changeMount: 0,
1519         allocPoint: _allocPoint,
1520         lastRewardBlock: lastRewardBlock,
1521         accZEUSPerShare: 0
1522         }));
1523     }
1524 
1525     function setArea(uint256 _aid, uint256 _rate, bool _withUpdate) public onlyOwner {
1526 
1527         if (_withUpdate) {
1528             massUpdateAreas();
1529         }
1530 
1531         totalRate = totalRate.sub(areaInfo[_aid].rate).add(_rate);
1532         areaInfo[_aid].rate = _rate;
1533     }
1534 
1535     // Update the given pool's zeus allocation point. Can only be called by the owner.
1536     function set(uint256 _aid, uint256 _pid, uint256 _allocPoint, bool _withUpdate, bool _bChange, uint256 _changeMount, bool _bLock, bool _bDepositFee, uint256 _depositFee) public onlyOwner {
1537         if (_withUpdate) {
1538             massUpdatePools(_aid);
1539         }
1540         areaInfo[_aid].totalAllocPoint = areaInfo[_aid].totalAllocPoint.sub(poolInfo[_aid][_pid].allocPoint).add(_allocPoint);
1541         poolInfo[_aid][_pid].allocPoint = _allocPoint;
1542         poolInfo[_aid][_pid].bChange = _bChange;
1543         poolInfo[_aid][_pid].bLock = _bLock;
1544         poolInfo[_aid][_pid].changeMount = _changeMount;
1545         poolInfo[_aid][_pid].bDepositFee = _bDepositFee;
1546         poolInfo[_aid][_pid].depositMount = _depositFee;
1547     }
1548 
1549     // Set the migrator contract. Can only be called by the owner.
1550     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1551         migrator = _migrator;
1552     }
1553 
1554     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1555     function migrate(uint256 _aid, uint256 _pid) public {
1556         require(address(migrator) != address(0), "migrate: no migrator");
1557         PoolInfo storage pool = poolInfo[_aid][_pid];
1558         IERC20 lpToken = pool.lpToken;
1559         uint256 bal = lpToken.balanceOf(address(this));
1560         lpToken.safeApprove(address(migrator), bal);
1561         IERC20 newLpToken = migrator.migrate(lpToken);
1562         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1563         pool.lpToken = newLpToken;
1564     }
1565 
1566     // Reduce by 50% per halfPeriod blocks.
1567     function getBlockReward(uint256 number) public view returns (uint256) {
1568         if (number < startBlock){
1569             return 0;
1570         }
1571         uint256 mintBlocks = number.sub(startBlock);
1572 
1573         uint256 exp = mintBlocks.div(halfPeriod);
1574 
1575         if (exp == 0) return 100000000000000000000;
1576         if (exp == 1) return 80000000000000000000;
1577         if (exp == 2) return 60000000000000000000;
1578         if (exp == 3) return 40000000000000000000;
1579         if (exp == 4) return 20000000000000000000;
1580         if (exp == 5) return 10000000000000000000;
1581         if (exp == 6) return 8000000000000000000;
1582         if (exp == 7) return 6000000000000000000;
1583         if (exp == 8) return 4000000000000000000;
1584         if (exp == 9) return 2000000000000000000;
1585         if (exp >= 10) return 1000000000000000000;
1586 
1587         return 0;
1588     }
1589 
1590     // Return reward multiplier over the given _from to _to block.
1591     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1592 
1593         if(_from < startBlock){
1594             _from = startBlock;
1595         }
1596         if(_from >= _to){
1597             return 0;
1598         }
1599 
1600         uint256 blockReward1 = getBlockReward(_from);
1601         uint256 blockReward2 = getBlockReward(_to);
1602         uint256 blockGap = _to.sub(_from);
1603         if(blockReward1 != blockReward2){
1604             uint256 blocks2 = _to.mod(halfPeriod);
1605             uint256 blocks1 = blockGap.sub(blocks2);
1606             return blocks1.mul(blockReward1).add(blocks2.mul(blockReward2));
1607         }
1608         return blockGap.mul(blockReward1);
1609 
1610     }
1611 
1612     // View function to see pending ZEUSs on frontend.
1613     function pendingZEUS(uint256 _aid, uint256 _pid, address _user) external view returns (uint256) {
1614         PoolInfo storage pool = poolInfo[_aid][_pid];
1615         UserInfo storage user = userInfo[_aid][_pid][_user];
1616         uint256 accZEUSPerShare = pool.accZEUSPerShare;
1617         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1618         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1619             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1620             uint256 ZEUSReward = multiplier.mul(pool.allocPoint).div(areaInfo[_aid].totalAllocPoint);
1621             accZEUSPerShare = accZEUSPerShare.add((ZEUSReward.mul(1e12).div(lpSupply)).mul(areaInfo[_aid].rate).div(totalRate));
1622         }
1623         return user.amount.mul(accZEUSPerShare).div(1e12).sub(user.rewardDebt);
1624     }
1625 
1626     function massUpdateAreas() public {
1627         uint256 length = areaInfo.length;
1628         for (uint256 aid = 0; aid < length; ++aid) {
1629             massUpdatePools(aid);
1630         }
1631     }
1632 
1633 
1634     // Update reward variables for all pools. Be careful of gas spending!
1635     function massUpdatePools(uint256 _aid) public {
1636         uint256 length = poolInfo[_aid].length;
1637         for (uint256 pid = 0; pid < length; ++pid) {
1638             updatePool(_aid, pid);
1639         }
1640     }
1641 
1642     // Update reward variables of the given pool to be up-to-date.
1643     function updatePool(uint256 _aid, uint256 _pid) public {
1644         PoolInfo storage pool = poolInfo[_aid][_pid];
1645         if (block.number <= pool.lastRewardBlock) {
1646             return;
1647         }
1648         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1649         if (lpSupply == 0) {
1650             pool.lastRewardBlock = block.number;
1651             return;
1652         }
1653         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);        
1654         uint256 zeusReward = multiplier.mul(pool.allocPoint).div(areaInfo[_aid].totalAllocPoint);
1655         zeus.mint(devaddr, zeusReward.div(20));
1656         zeus.mint(address(this), zeusReward);
1657         pool.accZEUSPerShare = pool.accZEUSPerShare.add((zeusReward.mul(1e12).div(lpSupply)).mul(areaInfo[_aid].rate).div(totalRate));
1658         pool.lastRewardBlock = block.number;
1659 
1660     }
1661 
1662     // Deposit LP tokens to ZEUSMain for ZEUS allocation.
1663     function deposit(uint256 _aid, uint256 _pid, uint256 _amount) payable public {
1664         PoolInfo storage pool = poolInfo[_aid][_pid];
1665         UserInfo storage user = userInfo[_aid][_pid][msg.sender];
1666 
1667         if (_amount > 0){        
1668             require((pool.bDepositFee == false) || (pool.bDepositFee == true && msg.value == pool.depositMount), "deposit: not enough");
1669         }
1670         
1671         updatePool(_aid, _pid);
1672         if (user.amount > 0) {
1673             uint256 pending = user.amount.mul(pool.accZEUSPerShare).div(1e12).sub(user.rewardDebt);
1674             if(pending > 0) {
1675                 safeZEUSTransfer(msg.sender, pending);
1676             }
1677         }
1678         else {
1679             if (pool.bChange == true)
1680             {
1681                 pool.allocPoint += pool.changeMount;
1682                 areaInfo[_aid].totalAllocPoint += pool.changeMount;
1683             }
1684         }
1685         if(_amount > 0) {
1686             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1687             user.amount = user.amount.add(_amount);
1688         }
1689         user.rewardDebt = user.amount.mul(pool.accZEUSPerShare).div(1e12);
1690         emit Deposit(msg.sender, _aid, _pid, _amount);
1691     }
1692 
1693     // Withdraw LP tokens from ZEUSMain.
1694     function withdraw(uint256 _aid, uint256 _pid, uint256 _amount) public {
1695         PoolInfo storage pool = poolInfo[_aid][_pid];
1696         UserInfo storage user = userInfo[_aid][_pid][msg.sender];
1697         require((pool.bLock == false) || (pool.bLock && (block.number >= (startBlock.add(lockPeriods)))), "withdraw: pool lock");
1698         require(user.amount >= _amount, "withdraw: not good");
1699         updatePool(_aid, _pid);
1700         uint256 pending = user.amount.mul(pool.accZEUSPerShare).div(1e12).sub(user.rewardDebt);
1701         if(pending > 0) {
1702             safeZEUSTransfer(msg.sender, pending);
1703         }
1704         if(_amount > 0) {
1705             user.amount = user.amount.sub(_amount);
1706             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1707         }
1708         if (user.amount == 0)
1709         {
1710             if (pool.bChange == true)
1711             {
1712                 uint256 changenum = pool.allocPoint > pool.changeMount ? pool.changeMount : 0;
1713                 pool.allocPoint = pool.allocPoint.sub(changenum);
1714                 areaInfo[_aid].totalAllocPoint = areaInfo[_aid].totalAllocPoint.sub(changenum);
1715             }
1716         }
1717         user.rewardDebt = user.amount.mul(pool.accZEUSPerShare).div(1e12);
1718         emit Withdraw(msg.sender, _aid, _pid, _amount);
1719     }
1720 
1721     // Withdraw without caring about rewards. EMERGENCY ONLY.
1722     function emergencyWithdraw(uint256 _aid, uint256 _pid) public {
1723         PoolInfo storage pool = poolInfo[_aid][_pid];
1724         UserInfo storage user = userInfo[_aid][_pid][msg.sender];
1725 
1726         require((pool.bLock == false) || (pool.bLock && (block.number >= (startBlock.add(lockPeriods)))), "withdraw: pool lock");
1727 
1728         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1729         emit EmergencyWithdraw(msg.sender, _aid, _pid, user.amount);
1730         user.amount = 0;
1731         user.rewardDebt = 0;
1732         if (pool.bChange == true)
1733         {
1734             uint256 changenum = pool.allocPoint > pool.changeMount ? pool.changeMount : 0;
1735             pool.allocPoint = pool.allocPoint.sub(changenum);
1736             areaInfo[_aid].totalAllocPoint = areaInfo[_aid].totalAllocPoint.sub(changenum);
1737         }
1738 
1739     }
1740 
1741     // Safe ZEUS transfer function, just in case if rounding error causes pool to not have enough ZEUSs.
1742     function safeZEUSTransfer(address _to, uint256 _amount) internal {
1743         uint256 ZEUSBal = zeus.balanceOf(address(this));
1744         if (_amount > ZEUSBal) {
1745             zeus.transfer(_to, ZEUSBal);
1746         } else {
1747             zeus.transfer(_to, _amount);
1748         }
1749     }
1750 
1751     // Update dev address by the previous dev.
1752     function dev(address _devaddr) public {
1753         require(msg.sender == devaddr, "dev: wut?");
1754         devaddr = _devaddr;
1755     }
1756 }