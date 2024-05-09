1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // File: @openzeppelin/contracts/math/SafeMath.sol
84 
85 pragma solidity ^0.6.0;
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
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
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
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 
390 pragma solidity ^0.6.0;
391 
392 /**
393  * @title SafeERC20
394  * @dev Wrappers around ERC20 operations that throw on failure (when the token
395  * contract returns false). Tokens that return no value (and instead revert or
396  * throw on failure) are also supported, non-reverting calls are assumed to be
397  * successful.
398  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
399  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
400  */
401 library SafeERC20 {
402     using SafeMath for uint256;
403     using Address for address;
404 
405     function safeTransfer(IERC20 token, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
407     }
408 
409     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
411     }
412 
413     /**
414      * @dev Deprecated. This function has issues similar to the ones found in
415      * {IERC20-approve}, and its usage is discouraged.
416      *
417      * Whenever possible, use {safeIncreaseAllowance} and
418      * {safeDecreaseAllowance} instead.
419      */
420     function safeApprove(IERC20 token, address spender, uint256 value) internal {
421         // safeApprove should only be called when setting an initial allowance,
422         // or when resetting it to zero. To increase and decrease it, use
423         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
424         // solhint-disable-next-line max-line-length
425         require((value == 0) || (token.allowance(address(this), spender) == 0),
426             "SafeERC20: approve from non-zero to non-zero allowance"
427         );
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
429     }
430 
431     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
432         uint256 newAllowance = token.allowance(address(this), spender).add(value);
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434     }
435 
436     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
437         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
439     }
440 
441     /**
442      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
443      * on the return value: the return value is optional (but if data is returned, it must not be false).
444      * @param token The token targeted by the call.
445      * @param data The call data (encoded using abi.encode or one of its variants).
446      */
447     function _callOptionalReturn(IERC20 token, bytes memory data) private {
448         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
449         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
450         // the target address contains contract code and also asserts for success in the low-level call.
451 
452         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
453         if (returndata.length > 0) { // Return data is optional
454             // solhint-disable-next-line max-line-length
455             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
456         }
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
461 
462 
463 
464 pragma solidity ^0.6.0;
465 
466 /**
467  * @dev Library for managing
468  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
469  * types.
470  *
471  * Sets have the following properties:
472  *
473  * - Elements are added, removed, and checked for existence in constant time
474  * (O(1)).
475  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
476  *
477  * ```
478  * contract Example {
479  *     // Add the library methods
480  *     using EnumerableSet for EnumerableSet.AddressSet;
481  *
482  *     // Declare a set state variable
483  *     EnumerableSet.AddressSet private mySet;
484  * }
485  * ```
486  *
487  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
488  * (`UintSet`) are supported.
489  */
490 library EnumerableSet {
491     // To implement this library for multiple types with as little code
492     // repetition as possible, we write it in terms of a generic Set type with
493     // bytes32 values.
494     // The Set implementation uses private functions, and user-facing
495     // implementations (such as AddressSet) are just wrappers around the
496     // underlying Set.
497     // This means that we can only create new EnumerableSets for types that fit
498     // in bytes32.
499 
500     struct Set {
501         // Storage of set values
502         bytes32[] _values;
503 
504         // Position of the value in the `values` array, plus 1 because index 0
505         // means a value is not in the set.
506         mapping (bytes32 => uint256) _indexes;
507     }
508 
509     /**
510      * @dev Add a value to a set. O(1).
511      *
512      * Returns true if the value was added to the set, that is if it was not
513      * already present.
514      */
515     function _add(Set storage set, bytes32 value) private returns (bool) {
516         if (!_contains(set, value)) {
517             set._values.push(value);
518             // The value is stored at length-1, but we add 1 to all indexes
519             // and use 0 as a sentinel value
520             set._indexes[value] = set._values.length;
521             return true;
522         } else {
523             return false;
524         }
525     }
526 
527     /**
528      * @dev Removes a value from a set. O(1).
529      *
530      * Returns true if the value was removed from the set, that is if it was
531      * present.
532      */
533     function _remove(Set storage set, bytes32 value) private returns (bool) {
534         // We read and store the value's index to prevent multiple reads from the same storage slot
535         uint256 valueIndex = set._indexes[value];
536 
537         if (valueIndex != 0) { // Equivalent to contains(set, value)
538             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
539             // the array, and then remove the last element (sometimes called as 'swap and pop').
540             // This modifies the order of the array, as noted in {at}.
541 
542             uint256 toDeleteIndex = valueIndex - 1;
543             uint256 lastIndex = set._values.length - 1;
544 
545             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
546             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
547 
548             bytes32 lastvalue = set._values[lastIndex];
549 
550             // Move the last value to the index where the value to delete is
551             set._values[toDeleteIndex] = lastvalue;
552             // Update the index for the moved value
553             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
554 
555             // Delete the slot where the moved value was stored
556             set._values.pop();
557 
558             // Delete the index for the deleted slot
559             delete set._indexes[value];
560 
561             return true;
562         } else {
563             return false;
564         }
565     }
566 
567     /**
568      * @dev Returns true if the value is in the set. O(1).
569      */
570     function _contains(Set storage set, bytes32 value) private view returns (bool) {
571         return set._indexes[value] != 0;
572     }
573 
574     /**
575      * @dev Returns the number of values on the set. O(1).
576      */
577     function _length(Set storage set) private view returns (uint256) {
578         return set._values.length;
579     }
580 
581    /**
582     * @dev Returns the value stored at position `index` in the set. O(1).
583     *
584     * Note that there are no guarantees on the ordering of values inside the
585     * array, and it may change when more values are added or removed.
586     *
587     * Requirements:
588     *
589     * - `index` must be strictly less than {length}.
590     */
591     function _at(Set storage set, uint256 index) private view returns (bytes32) {
592         require(set._values.length > index, "EnumerableSet: index out of bounds");
593         return set._values[index];
594     }
595 
596     // AddressSet
597 
598     struct AddressSet {
599         Set _inner;
600     }
601 
602     /**
603      * @dev Add a value to a set. O(1).
604      *
605      * Returns true if the value was added to the set, that is if it was not
606      * already present.
607      */
608     function add(AddressSet storage set, address value) internal returns (bool) {
609         return _add(set._inner, bytes32(uint256(value)));
610     }
611 
612     /**
613      * @dev Removes a value from a set. O(1).
614      *
615      * Returns true if the value was removed from the set, that is if it was
616      * present.
617      */
618     function remove(AddressSet storage set, address value) internal returns (bool) {
619         return _remove(set._inner, bytes32(uint256(value)));
620     }
621 
622     /**
623      * @dev Returns true if the value is in the set. O(1).
624      */
625     function contains(AddressSet storage set, address value) internal view returns (bool) {
626         return _contains(set._inner, bytes32(uint256(value)));
627     }
628 
629     /**
630      * @dev Returns the number of values in the set. O(1).
631      */
632     function length(AddressSet storage set) internal view returns (uint256) {
633         return _length(set._inner);
634     }
635 
636    /**
637     * @dev Returns the value stored at position `index` in the set. O(1).
638     *
639     * Note that there are no guarantees on the ordering of values inside the
640     * array, and it may change when more values are added or removed.
641     *
642     * Requirements:
643     *
644     * - `index` must be strictly less than {length}.
645     */
646     function at(AddressSet storage set, uint256 index) internal view returns (address) {
647         return address(uint256(_at(set._inner, index)));
648     }
649 
650 
651     // UintSet
652 
653     struct UintSet {
654         Set _inner;
655     }
656 
657     /**
658      * @dev Add a value to a set. O(1).
659      *
660      * Returns true if the value was added to the set, that is if it was not
661      * already present.
662      */
663     function add(UintSet storage set, uint256 value) internal returns (bool) {
664         return _add(set._inner, bytes32(value));
665     }
666 
667     /**
668      * @dev Removes a value from a set. O(1).
669      *
670      * Returns true if the value was removed from the set, that is if it was
671      * present.
672      */
673     function remove(UintSet storage set, uint256 value) internal returns (bool) {
674         return _remove(set._inner, bytes32(value));
675     }
676 
677     /**
678      * @dev Returns true if the value is in the set. O(1).
679      */
680     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
681         return _contains(set._inner, bytes32(value));
682     }
683 
684     /**
685      * @dev Returns the number of values on the set. O(1).
686      */
687     function length(UintSet storage set) internal view returns (uint256) {
688         return _length(set._inner);
689     }
690 
691    /**
692     * @dev Returns the value stored at position `index` in the set. O(1).
693     *
694     * Note that there are no guarantees on the ordering of values inside the
695     * array, and it may change when more values are added or removed.
696     *
697     * Requirements:
698     *
699     * - `index` must be strictly less than {length}.
700     */
701     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
702         return uint256(_at(set._inner, index));
703     }
704 }
705 
706 // File: @openzeppelin/contracts/GSN/Context.sol
707 
708 
709 
710 pragma solidity ^0.6.0;
711 
712 /*
713  * @dev Provides information about the current execution context, including the
714  * sender of the transaction and its data. While these are generally available
715  * via msg.sender and msg.data, they should not be accessed in such a direct
716  * manner, since when dealing with GSN meta-transactions the account sending and
717  * paying for execution may not be the actual sender (as far as an application
718  * is concerned).
719  *
720  * This contract is only required for intermediate, library-like contracts.
721  */
722 abstract contract Context {
723     function _msgSender() internal view virtual returns (address payable) {
724         return msg.sender;
725     }
726 
727     function _msgData() internal view virtual returns (bytes memory) {
728         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
729         return msg.data;
730     }
731 }
732 
733 // File: @openzeppelin/contracts/access/Ownable.sol
734 
735 
736 
737 pragma solidity ^0.6.0;
738 
739 /**
740  * @dev Contract module which provides a basic access control mechanism, where
741  * there is an account (an owner) that can be granted exclusive access to
742  * specific functions.
743  *
744  * By default, the owner account will be the one that deploys the contract. This
745  * can later be changed with {transferOwnership}.
746  *
747  * This module is used through inheritance. It will make available the modifier
748  * `onlyOwner`, which can be applied to your functions to restrict their use to
749  * the owner.
750  */
751 contract Ownable is Context {
752     address private _owner;
753 
754     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
755 
756     /**
757      * @dev Initializes the contract setting the deployer as the initial owner.
758      */
759     constructor () internal {
760         address msgSender = _msgSender();
761         _owner = msgSender;
762         emit OwnershipTransferred(address(0), msgSender);
763     }
764 
765     /**
766      * @dev Returns the address of the current owner.
767      */
768     function owner() public view returns (address) {
769         return _owner;
770     }
771 
772     /**
773      * @dev Throws if called by any account other than the owner.
774      */
775     modifier onlyOwner() {
776         require(_owner == _msgSender(), "Ownable: caller is not the owner");
777         _;
778     }
779 
780     /**
781      * @dev Leaves the contract without owner. It will not be possible to call
782      * `onlyOwner` functions anymore. Can only be called by the current owner.
783      *
784      * NOTE: Renouncing ownership will leave the contract without an owner,
785      * thereby removing any functionality that is only available to the owner.
786      */
787     function renounceOwnership() public virtual onlyOwner {
788         emit OwnershipTransferred(_owner, address(0));
789         _owner = address(0);
790     }
791 
792     /**
793      * @dev Transfers ownership of the contract to a new account (`newOwner`).
794      * Can only be called by the current owner.
795      */
796     function transferOwnership(address newOwner) public virtual onlyOwner {
797         require(newOwner != address(0), "Ownable: new owner is the zero address");
798         emit OwnershipTransferred(_owner, newOwner);
799         _owner = newOwner;
800     }
801 }
802 
803 // File: contracts/Farm.sol
804 
805 pragma solidity 0.6.12;
806 
807 contract CoShiFarm is Ownable {
808     using SafeMath for uint256;
809     using SafeERC20 for IERC20;
810 
811     // Info of each user.
812     struct UserInfo {
813         uint256 amount;     // How many LP tokens the user has provided.
814         uint256 rewardDebt; // Reward debt. See explanation below.
815         //
816         // We do some fancy math here. Basically, any point in time, the amount of ERC20s
817         // entitled to a user but is pending to be distributed is:
818         //
819         //   pending reward = (user.amount * pool.accERC20PerShare) - user.rewardDebt
820         //
821         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
822         //   1. The pool's `accERC20PerShare` (and `lastRewardBlock`) gets updated.
823         //   2. User receives the pending reward sent to his/her address.
824         //   3. User's `amount` gets updated.
825         //   4. User's `rewardDebt` gets updated.
826     }
827 
828     // Info of each pool.
829     struct PoolInfo {
830         IERC20 lpToken;             // Address of LP token contract.
831         uint256 allocPoint;         // How many allocation points assigned to this pool. ERC20s to distribute per block.
832         uint256 lastRewardBlock;    // Last block number that ERC20s distribution occurs.
833         uint256 accERC20PerShare;   // Accumulated ERC20s per share, times 1e36.
834     }
835 
836     // Address of the ERC20 Token contract.
837     IERC20 public erc20;
838     // The total amount of ERC20 that's paid out as reward.
839     uint256 public paidOut = 0;
840     // ERC20 tokens rewarded per block.
841     uint256 public rewardPerBlock;
842 
843     // Info of each pool.
844     PoolInfo[] public poolInfo;
845     // Info of each user that stakes LP tokens.
846     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
847     // Total allocation points. Must be the sum of all allocation points in all pools.
848     uint256 public totalAllocPoint = 0;
849 
850     // The block number when farming starts.
851     uint256 public startBlock;
852     // The block number when farming ends.
853     uint256 public endBlock;
854 
855     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
856     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
857     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
858 
859     constructor(IERC20 _erc20, uint256 _rewardPerBlock, uint256 _startBlock) public {
860         erc20 = _erc20;
861         rewardPerBlock = _rewardPerBlock;
862         startBlock = _startBlock;
863         endBlock = _startBlock;
864     }
865 
866     // Number of LP pools
867     function poolLength() external view returns (uint256) {
868         return poolInfo.length;
869     }
870 
871     function currentBlock() external view returns (uint256) {
872         return block.number;
873     }
874 
875     // Fund the farm, increase the end block
876     function fund(uint256 _amount) public {
877         require(block.number < endBlock, "fund: too late, the farm is closed");
878 
879         erc20.safeTransferFrom(address(msg.sender), address(this), _amount);
880         endBlock += _amount.div(rewardPerBlock);
881     }
882 
883     // Add a new lp to the pool. Can only be called by the owner.
884     // DO NOT add the same LP token more than once. Rewards will be messed up if you do.
885     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
886         if (_withUpdate) {
887             massUpdatePools();
888         }
889         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
890         totalAllocPoint = totalAllocPoint.add(_allocPoint);
891         poolInfo.push(PoolInfo({
892             lpToken: _lpToken,
893             allocPoint: _allocPoint,
894             lastRewardBlock: lastRewardBlock,
895             accERC20PerShare: 0
896         }));
897     }
898 
899     // Update the given pool's ERC20 allocation point. Can only be called by the owner.
900     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
901         if (_withUpdate) {
902             massUpdatePools();
903         }
904         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
905         poolInfo[_pid].allocPoint = _allocPoint;
906     }
907 
908     // View function to see deposited LP for a user.
909     function deposited(uint256 _pid, address _user) external view returns (uint256) {
910         UserInfo storage user = userInfo[_pid][_user];
911         return user.amount;
912     }
913 
914     // View function to see pending ERC20s for a user.
915     function pending(uint256 _pid, address _user) external view returns (uint256) {
916         PoolInfo storage pool = poolInfo[_pid];
917         UserInfo storage user = userInfo[_pid][_user];
918         uint256 accERC20PerShare = pool.accERC20PerShare;
919         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
920 
921         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
922             uint256 lastBlock = block.number < endBlock ? block.number : endBlock;
923             uint256 nrOfBlocks = lastBlock.sub(pool.lastRewardBlock);
924             uint256 erc20Reward = nrOfBlocks.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
925             accERC20PerShare = accERC20PerShare.add(erc20Reward.mul(1e36).div(lpSupply));
926         }
927 
928         return user.amount.mul(accERC20PerShare).div(1e36).sub(user.rewardDebt);
929     }
930 
931     // View function for total reward the farm has yet to pay out.
932     function totalPending() external view returns (uint256) {
933         if (block.number <= startBlock) {
934             return 0;
935         }
936 
937         uint256 lastBlock = block.number < endBlock ? block.number : endBlock;
938         return rewardPerBlock.mul(lastBlock - startBlock).sub(paidOut);
939     }
940 
941     // Update reward variables for all pools. Be careful of gas spending!
942     function massUpdatePools() public {
943         uint256 length = poolInfo.length;
944         for (uint256 pid = 0; pid < length; ++pid) {
945             updatePool(pid);
946         }
947     }
948 
949     // Update reward variables of the given pool to be up-to-date.
950     function updatePool(uint256 _pid) public {
951         PoolInfo storage pool = poolInfo[_pid];
952         uint256 lastBlock = block.number < endBlock ? block.number : endBlock;
953 
954         if (lastBlock <= pool.lastRewardBlock) {
955             return;
956         }
957         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
958         if (lpSupply == 0) {
959             pool.lastRewardBlock = lastBlock;
960             return;
961         }
962 
963         uint256 nrOfBlocks = lastBlock.sub(pool.lastRewardBlock);
964         uint256 erc20Reward = nrOfBlocks.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
965 
966         pool.accERC20PerShare = pool.accERC20PerShare.add(erc20Reward.mul(1e36).div(lpSupply));
967         pool.lastRewardBlock = block.number;
968     }
969 
970     // Deposit LP tokens to Farm for ERC20 allocation.
971     function deposit(uint256 _pid, uint256 _amount) public {
972         PoolInfo storage pool = poolInfo[_pid];
973         UserInfo storage user = userInfo[_pid][msg.sender];
974         updatePool(_pid);
975         if (user.amount > 0) {
976             uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
977             erc20Transfer(msg.sender, pendingAmount);
978         }
979         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
980         user.amount = user.amount.add(_amount);
981         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
982         emit Deposit(msg.sender, _pid, _amount);
983     }
984 
985     // Withdraw LP tokens from Farm.
986     function withdraw(uint256 _pid, uint256 _amount) public {
987         PoolInfo storage pool = poolInfo[_pid];
988         UserInfo storage user = userInfo[_pid][msg.sender];
989         require(user.amount >= _amount, "withdraw: can't withdraw more than deposit");
990         updatePool(_pid);
991         uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
992         erc20Transfer(msg.sender, pendingAmount);
993         user.amount = user.amount.sub(_amount);
994         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
995         pool.lpToken.safeTransfer(address(msg.sender), _amount);
996         emit Withdraw(msg.sender, _pid, _amount);
997     }
998 
999     // Withdraw without caring about rewards. EMERGENCY ONLY.
1000     function emergencyWithdraw(uint256 _pid) public {
1001         PoolInfo storage pool = poolInfo[_pid];
1002         UserInfo storage user = userInfo[_pid][msg.sender];
1003         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1004         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1005         user.amount = 0;
1006         user.rewardDebt = 0;
1007     }
1008 
1009     // Transfer ERC20 and update the required ERC20 to payout all rewards
1010     function erc20Transfer(address _to, uint256 _amount) internal {
1011         erc20.transfer(_to, _amount);
1012         paidOut += _amount;
1013     }
1014 
1015     function updateBlockReward(uint256 _rewardPerBlock, bool _withUpdate) public onlyOwner {
1016         if (_withUpdate) {
1017             massUpdatePools();
1018         }
1019         rewardPerBlock = _rewardPerBlock;
1020     }
1021 
1022     function updateStartBlock(uint256 _startBlock, bool _withUpdate) public onlyOwner {
1023         if (_withUpdate) {
1024             massUpdatePools();
1025         }
1026         startBlock = _startBlock;
1027     }
1028 
1029     function updateEndBlock(uint256 _endBlock, bool _withUpdate) public onlyOwner {
1030         if (_withUpdate) {
1031             massUpdatePools();
1032         }
1033         endBlock = _endBlock;
1034     }
1035 }