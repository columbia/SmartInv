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
247 pragma solidity >=0.6.2 <0.8.0;
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
271         // This method relies on extcodesize, which returns 0 for contracts in
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
334         return functionCallWithValue(target, data, 0, errorMessage);
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
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: value }(data);
364         return _verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
374         return functionStaticCall(target, data, "Address: low-level static call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
384         require(isContract(target), "Address: static call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 // solhint-disable-next-line no-inline-assembly
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
412 
413 
414 
415 pragma solidity >=0.6.0 <0.8.0;
416 
417 
418 
419 
420 /**
421  * @title SafeERC20
422  * @dev Wrappers around ERC20 operations that throw on failure (when the token
423  * contract returns false). Tokens that return no value (and instead revert or
424  * throw on failure) are also supported, non-reverting calls are assumed to be
425  * successful.
426  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
427  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
428  */
429 library SafeERC20 {
430     using SafeMath for uint256;
431     using Address for address;
432 
433     function safeTransfer(IERC20 token, address to, uint256 value) internal {
434         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
435     }
436 
437     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
438         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
439     }
440 
441     /**
442      * @dev Deprecated. This function has issues similar to the ones found in
443      * {IERC20-approve}, and its usage is discouraged.
444      *
445      * Whenever possible, use {safeIncreaseAllowance} and
446      * {safeDecreaseAllowance} instead.
447      */
448     function safeApprove(IERC20 token, address spender, uint256 value) internal {
449         // safeApprove should only be called when setting an initial allowance,
450         // or when resetting it to zero. To increase and decrease it, use
451         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
452         // solhint-disable-next-line max-line-length
453         require((value == 0) || (token.allowance(address(this), spender) == 0),
454             "SafeERC20: approve from non-zero to non-zero allowance"
455         );
456         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
457     }
458 
459     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
460         uint256 newAllowance = token.allowance(address(this), spender).add(value);
461         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
462     }
463 
464     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
465         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
466         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
467     }
468 
469     /**
470      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
471      * on the return value: the return value is optional (but if data is returned, it must not be false).
472      * @param token The token targeted by the call.
473      * @param data The call data (encoded using abi.encode or one of its variants).
474      */
475     function _callOptionalReturn(IERC20 token, bytes memory data) private {
476         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
477         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
478         // the target address contains contract code and also asserts for success in the low-level call.
479 
480         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
481         if (returndata.length > 0) { // Return data is optional
482             // solhint-disable-next-line max-line-length
483             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
484         }
485     }
486 }
487 
488 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
489 
490 
491 
492 pragma solidity >=0.6.0 <0.8.0;
493 
494 /**
495  * @dev Library for managing
496  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
497  * types.
498  *
499  * Sets have the following properties:
500  *
501  * - Elements are added, removed, and checked for existence in constant time
502  * (O(1)).
503  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
504  *
505  * ```
506  * contract Example {
507  *     // Add the library methods
508  *     using EnumerableSet for EnumerableSet.AddressSet;
509  *
510  *     // Declare a set state variable
511  *     EnumerableSet.AddressSet private mySet;
512  * }
513  * ```
514  *
515  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
516  * and `uint256` (`UintSet`) are supported.
517  */
518 library EnumerableSet {
519     // To implement this library for multiple types with as little code
520     // repetition as possible, we write it in terms of a generic Set type with
521     // bytes32 values.
522     // The Set implementation uses private functions, and user-facing
523     // implementations (such as AddressSet) are just wrappers around the
524     // underlying Set.
525     // This means that we can only create new EnumerableSets for types that fit
526     // in bytes32.
527 
528     struct Set {
529         // Storage of set values
530         bytes32[] _values;
531 
532         // Position of the value in the `values` array, plus 1 because index 0
533         // means a value is not in the set.
534         mapping (bytes32 => uint256) _indexes;
535     }
536 
537     /**
538      * @dev Add a value to a set. O(1).
539      *
540      * Returns true if the value was added to the set, that is if it was not
541      * already present.
542      */
543     function _add(Set storage set, bytes32 value) private returns (bool) {
544         if (!_contains(set, value)) {
545             set._values.push(value);
546             // The value is stored at length-1, but we add 1 to all indexes
547             // and use 0 as a sentinel value
548             set._indexes[value] = set._values.length;
549             return true;
550         } else {
551             return false;
552         }
553     }
554 
555     /**
556      * @dev Removes a value from a set. O(1).
557      *
558      * Returns true if the value was removed from the set, that is if it was
559      * present.
560      */
561     function _remove(Set storage set, bytes32 value) private returns (bool) {
562         // We read and store the value's index to prevent multiple reads from the same storage slot
563         uint256 valueIndex = set._indexes[value];
564 
565         if (valueIndex != 0) { // Equivalent to contains(set, value)
566             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
567             // the array, and then remove the last element (sometimes called as 'swap and pop').
568             // This modifies the order of the array, as noted in {at}.
569 
570             uint256 toDeleteIndex = valueIndex - 1;
571             uint256 lastIndex = set._values.length - 1;
572 
573             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
574             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
575 
576             bytes32 lastvalue = set._values[lastIndex];
577 
578             // Move the last value to the index where the value to delete is
579             set._values[toDeleteIndex] = lastvalue;
580             // Update the index for the moved value
581             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
582 
583             // Delete the slot where the moved value was stored
584             set._values.pop();
585 
586             // Delete the index for the deleted slot
587             delete set._indexes[value];
588 
589             return true;
590         } else {
591             return false;
592         }
593     }
594 
595     /**
596      * @dev Returns true if the value is in the set. O(1).
597      */
598     function _contains(Set storage set, bytes32 value) private view returns (bool) {
599         return set._indexes[value] != 0;
600     }
601 
602     /**
603      * @dev Returns the number of values on the set. O(1).
604      */
605     function _length(Set storage set) private view returns (uint256) {
606         return set._values.length;
607     }
608 
609    /**
610     * @dev Returns the value stored at position `index` in the set. O(1).
611     *
612     * Note that there are no guarantees on the ordering of values inside the
613     * array, and it may change when more values are added or removed.
614     *
615     * Requirements:
616     *
617     * - `index` must be strictly less than {length}.
618     */
619     function _at(Set storage set, uint256 index) private view returns (bytes32) {
620         require(set._values.length > index, "EnumerableSet: index out of bounds");
621         return set._values[index];
622     }
623 
624     // Bytes32Set
625 
626     struct Bytes32Set {
627         Set _inner;
628     }
629 
630     /**
631      * @dev Add a value to a set. O(1).
632      *
633      * Returns true if the value was added to the set, that is if it was not
634      * already present.
635      */
636     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
637         return _add(set._inner, value);
638     }
639 
640     /**
641      * @dev Removes a value from a set. O(1).
642      *
643      * Returns true if the value was removed from the set, that is if it was
644      * present.
645      */
646     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
647         return _remove(set._inner, value);
648     }
649 
650     /**
651      * @dev Returns true if the value is in the set. O(1).
652      */
653     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
654         return _contains(set._inner, value);
655     }
656 
657     /**
658      * @dev Returns the number of values in the set. O(1).
659      */
660     function length(Bytes32Set storage set) internal view returns (uint256) {
661         return _length(set._inner);
662     }
663 
664    /**
665     * @dev Returns the value stored at position `index` in the set. O(1).
666     *
667     * Note that there are no guarantees on the ordering of values inside the
668     * array, and it may change when more values are added or removed.
669     *
670     * Requirements:
671     *
672     * - `index` must be strictly less than {length}.
673     */
674     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
675         return _at(set._inner, index);
676     }
677 
678     // AddressSet
679 
680     struct AddressSet {
681         Set _inner;
682     }
683 
684     /**
685      * @dev Add a value to a set. O(1).
686      *
687      * Returns true if the value was added to the set, that is if it was not
688      * already present.
689      */
690     function add(AddressSet storage set, address value) internal returns (bool) {
691         return _add(set._inner, bytes32(uint256(value)));
692     }
693 
694     /**
695      * @dev Removes a value from a set. O(1).
696      *
697      * Returns true if the value was removed from the set, that is if it was
698      * present.
699      */
700     function remove(AddressSet storage set, address value) internal returns (bool) {
701         return _remove(set._inner, bytes32(uint256(value)));
702     }
703 
704     /**
705      * @dev Returns true if the value is in the set. O(1).
706      */
707     function contains(AddressSet storage set, address value) internal view returns (bool) {
708         return _contains(set._inner, bytes32(uint256(value)));
709     }
710 
711     /**
712      * @dev Returns the number of values in the set. O(1).
713      */
714     function length(AddressSet storage set) internal view returns (uint256) {
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
728     function at(AddressSet storage set, uint256 index) internal view returns (address) {
729         return address(uint256(_at(set._inner, index)));
730     }
731 
732 
733     // UintSet
734 
735     struct UintSet {
736         Set _inner;
737     }
738 
739     /**
740      * @dev Add a value to a set. O(1).
741      *
742      * Returns true if the value was added to the set, that is if it was not
743      * already present.
744      */
745     function add(UintSet storage set, uint256 value) internal returns (bool) {
746         return _add(set._inner, bytes32(value));
747     }
748 
749     /**
750      * @dev Removes a value from a set. O(1).
751      *
752      * Returns true if the value was removed from the set, that is if it was
753      * present.
754      */
755     function remove(UintSet storage set, uint256 value) internal returns (bool) {
756         return _remove(set._inner, bytes32(value));
757     }
758 
759     /**
760      * @dev Returns true if the value is in the set. O(1).
761      */
762     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
763         return _contains(set._inner, bytes32(value));
764     }
765 
766     /**
767      * @dev Returns the number of values on the set. O(1).
768      */
769     function length(UintSet storage set) internal view returns (uint256) {
770         return _length(set._inner);
771     }
772 
773    /**
774     * @dev Returns the value stored at position `index` in the set. O(1).
775     *
776     * Note that there are no guarantees on the ordering of values inside the
777     * array, and it may change when more values are added or removed.
778     *
779     * Requirements:
780     *
781     * - `index` must be strictly less than {length}.
782     */
783     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
784         return uint256(_at(set._inner, index));
785     }
786 }
787 
788 // File: @openzeppelin/contracts/GSN/Context.sol
789 
790 
791 
792 pragma solidity >=0.6.0 <0.8.0;
793 
794 /*
795  * @dev Provides information about the current execution context, including the
796  * sender of the transaction and its data. While these are generally available
797  * via msg.sender and msg.data, they should not be accessed in such a direct
798  * manner, since when dealing with GSN meta-transactions the account sending and
799  * paying for execution may not be the actual sender (as far as an application
800  * is concerned).
801  *
802  * This contract is only required for intermediate, library-like contracts.
803  */
804 abstract contract Context {
805     function _msgSender() internal view virtual returns (address payable) {
806         return msg.sender;
807     }
808 
809     function _msgData() internal view virtual returns (bytes memory) {
810         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
811         return msg.data;
812     }
813 }
814 
815 // File: @openzeppelin/contracts/access/Ownable.sol
816 
817 
818 
819 pragma solidity >=0.6.0 <0.8.0;
820 
821 /**
822  * @dev Contract module which provides a basic access control mechanism, where
823  * there is an account (an owner) that can be granted exclusive access to
824  * specific functions.
825  *
826  * By default, the owner account will be the one that deploys the contract. This
827  * can later be changed with {transferOwnership}.
828  *
829  * This module is used through inheritance. It will make available the modifier
830  * `onlyOwner`, which can be applied to your functions to restrict their use to
831  * the owner.
832  */
833 abstract contract Ownable is Context {
834     address private _owner;
835 
836     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
837 
838     /**
839      * @dev Initializes the contract setting the deployer as the initial owner.
840      */
841     constructor () internal {
842         address msgSender = _msgSender();
843         _owner = msgSender;
844         emit OwnershipTransferred(address(0), msgSender);
845     }
846 
847     /**
848      * @dev Returns the address of the current owner.
849      */
850     function owner() public view returns (address) {
851         return _owner;
852     }
853 
854     /**
855      * @dev Throws if called by any account other than the owner.
856      */
857     modifier onlyOwner() {
858         require(_owner == _msgSender(), "Ownable: caller is not the owner");
859         _;
860     }
861 
862     /**
863      * @dev Leaves the contract without owner. It will not be possible to call
864      * `onlyOwner` functions anymore. Can only be called by the current owner.
865      *
866      * NOTE: Renouncing ownership will leave the contract without an owner,
867      * thereby removing any functionality that is only available to the owner.
868      */
869     function renounceOwnership() public virtual onlyOwner {
870         emit OwnershipTransferred(_owner, address(0));
871         _owner = address(0);
872     }
873 
874     /**
875      * @dev Transfers ownership of the contract to a new account (`newOwner`).
876      * Can only be called by the current owner.
877      */
878     function transferOwnership(address newOwner) public virtual onlyOwner {
879         require(newOwner != address(0), "Ownable: new owner is the zero address");
880         emit OwnershipTransferred(_owner, newOwner);
881         _owner = newOwner;
882     }
883 }
884 
885 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
886 
887 
888 
889 pragma solidity >=0.6.0 <0.8.0;
890 
891 
892 
893 
894 /**
895  * @dev Implementation of the {IERC20} interface.
896  *
897  * This implementation is agnostic to the way tokens are created. This means
898  * that a supply mechanism has to be added in a derived contract using {_mint}.
899  * For a generic mechanism see {ERC20PresetMinterPauser}.
900  *
901  * TIP: For a detailed writeup see our guide
902  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
903  * to implement supply mechanisms].
904  *
905  * We have followed general OpenZeppelin guidelines: functions revert instead
906  * of returning `false` on failure. This behavior is nonetheless conventional
907  * and does not conflict with the expectations of ERC20 applications.
908  *
909  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
910  * This allows applications to reconstruct the allowance for all accounts just
911  * by listening to said events. Other implementations of the EIP may not emit
912  * these events, as it isn't required by the specification.
913  *
914  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
915  * functions have been added to mitigate the well-known issues around setting
916  * allowances. See {IERC20-approve}.
917  */
918 contract ERC20 is Context, IERC20 {
919     using SafeMath for uint256;
920 
921     mapping (address => uint256) private _balances;
922 
923     mapping (address => mapping (address => uint256)) private _allowances;
924 
925     uint256 private _totalSupply;
926 
927     string private _name;
928     string private _symbol;
929     uint8 private _decimals;
930 
931     /**
932      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
933      * a default value of 18.
934      *
935      * To select a different value for {decimals}, use {_setupDecimals}.
936      *
937      * All three of these values are immutable: they can only be set once during
938      * construction.
939      */
940     constructor (string memory name_, string memory symbol_) public {
941         _name = name_;
942         _symbol = symbol_;
943         _decimals = 18;
944     }
945 
946     /**
947      * @dev Returns the name of the token.
948      */
949     function name() public view returns (string memory) {
950         return _name;
951     }
952 
953     /**
954      * @dev Returns the symbol of the token, usually a shorter version of the
955      * name.
956      */
957     function symbol() public view returns (string memory) {
958         return _symbol;
959     }
960 
961     /**
962      * @dev Returns the number of decimals used to get its user representation.
963      * For example, if `decimals` equals `2`, a balance of `505` tokens should
964      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
965      *
966      * Tokens usually opt for a value of 18, imitating the relationship between
967      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
968      * called.
969      *
970      * NOTE: This information is only used for _display_ purposes: it in
971      * no way affects any of the arithmetic of the contract, including
972      * {IERC20-balanceOf} and {IERC20-transfer}.
973      */
974     function decimals() public view returns (uint8) {
975         return _decimals;
976     }
977 
978     /**
979      * @dev See {IERC20-totalSupply}.
980      */
981     function totalSupply() public view override returns (uint256) {
982         return _totalSupply;
983     }
984 
985     /**
986      * @dev See {IERC20-balanceOf}.
987      */
988     function balanceOf(address account) public view override returns (uint256) {
989         return _balances[account];
990     }
991 
992     /**
993      * @dev See {IERC20-transfer}.
994      *
995      * Requirements:
996      *
997      * - `recipient` cannot be the zero address.
998      * - the caller must have a balance of at least `amount`.
999      */
1000     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1001         _transfer(_msgSender(), recipient, amount);
1002         return true;
1003     }
1004 
1005     /**
1006      * @dev See {IERC20-allowance}.
1007      */
1008     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1009         return _allowances[owner][spender];
1010     }
1011 
1012     /**
1013      * @dev See {IERC20-approve}.
1014      *
1015      * Requirements:
1016      *
1017      * - `spender` cannot be the zero address.
1018      */
1019     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1020         _approve(_msgSender(), spender, amount);
1021         return true;
1022     }
1023 
1024     /**
1025      * @dev See {IERC20-transferFrom}.
1026      *
1027      * Emits an {Approval} event indicating the updated allowance. This is not
1028      * required by the EIP. See the note at the beginning of {ERC20}.
1029      *
1030      * Requirements:
1031      *
1032      * - `sender` and `recipient` cannot be the zero address.
1033      * - `sender` must have a balance of at least `amount`.
1034      * - the caller must have allowance for ``sender``'s tokens of at least
1035      * `amount`.
1036      */
1037     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1038         _transfer(sender, recipient, amount);
1039         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1040         return true;
1041     }
1042 
1043     /**
1044      * @dev Atomically increases the allowance granted to `spender` by the caller.
1045      *
1046      * This is an alternative to {approve} that can be used as a mitigation for
1047      * problems described in {IERC20-approve}.
1048      *
1049      * Emits an {Approval} event indicating the updated allowance.
1050      *
1051      * Requirements:
1052      *
1053      * - `spender` cannot be the zero address.
1054      */
1055     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1056         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1057         return true;
1058     }
1059 
1060     /**
1061      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1062      *
1063      * This is an alternative to {approve} that can be used as a mitigation for
1064      * problems described in {IERC20-approve}.
1065      *
1066      * Emits an {Approval} event indicating the updated allowance.
1067      *
1068      * Requirements:
1069      *
1070      * - `spender` cannot be the zero address.
1071      * - `spender` must have allowance for the caller of at least
1072      * `subtractedValue`.
1073      */
1074     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1075         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1076         return true;
1077     }
1078 
1079     /**
1080      * @dev Moves tokens `amount` from `sender` to `recipient`.
1081      *
1082      * This is internal function is equivalent to {transfer}, and can be used to
1083      * e.g. implement automatic token fees, slashing mechanisms, etc.
1084      *
1085      * Emits a {Transfer} event.
1086      *
1087      * Requirements:
1088      *
1089      * - `sender` cannot be the zero address.
1090      * - `recipient` cannot be the zero address.
1091      * - `sender` must have a balance of at least `amount`.
1092      */
1093     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1094         require(sender != address(0), "ERC20: transfer from the zero address");
1095         require(recipient != address(0), "ERC20: transfer to the zero address");
1096 
1097         _beforeTokenTransfer(sender, recipient, amount);
1098 
1099         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1100         _balances[recipient] = _balances[recipient].add(amount);
1101         emit Transfer(sender, recipient, amount);
1102     }
1103 
1104     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1105      * the total supply.
1106      *
1107      * Emits a {Transfer} event with `from` set to the zero address.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      */
1113     function _mint(address account, uint256 amount) internal virtual {
1114         require(account != address(0), "ERC20: mint to the zero address");
1115 
1116         _beforeTokenTransfer(address(0), account, amount);
1117 
1118         _totalSupply = _totalSupply.add(amount);
1119         _balances[account] = _balances[account].add(amount);
1120         emit Transfer(address(0), account, amount);
1121     }
1122 
1123     /**
1124      * @dev Destroys `amount` tokens from `account`, reducing the
1125      * total supply.
1126      *
1127      * Emits a {Transfer} event with `to` set to the zero address.
1128      *
1129      * Requirements:
1130      *
1131      * - `account` cannot be the zero address.
1132      * - `account` must have at least `amount` tokens.
1133      */
1134     function _burn(address account, uint256 amount) internal virtual {
1135         require(account != address(0), "ERC20: burn from the zero address");
1136 
1137         _beforeTokenTransfer(account, address(0), amount);
1138 
1139         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1140         _totalSupply = _totalSupply.sub(amount);
1141         emit Transfer(account, address(0), amount);
1142     }
1143 
1144     /**
1145      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1146      *
1147      * This internal function is equivalent to `approve`, and can be used to
1148      * e.g. set automatic allowances for certain subsystems, etc.
1149      *
1150      * Emits an {Approval} event.
1151      *
1152      * Requirements:
1153      *
1154      * - `owner` cannot be the zero address.
1155      * - `spender` cannot be the zero address.
1156      */
1157     function _approve(address owner, address spender, uint256 amount) internal virtual {
1158         require(owner != address(0), "ERC20: approve from the zero address");
1159         require(spender != address(0), "ERC20: approve to the zero address");
1160 
1161         _allowances[owner][spender] = amount;
1162         emit Approval(owner, spender, amount);
1163     }
1164 
1165     /**
1166      * @dev Sets {decimals} to a value other than the default one of 18.
1167      *
1168      * WARNING: This function should only be called from the constructor. Most
1169      * applications that interact with token contracts will not expect
1170      * {decimals} to ever change, and may work incorrectly if it does.
1171      */
1172     function _setupDecimals(uint8 decimals_) internal {
1173         _decimals = decimals_;
1174     }
1175 
1176     /**
1177      * @dev Hook that is called before any transfer of tokens. This includes
1178      * minting and burning.
1179      *
1180      * Calling conditions:
1181      *
1182      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1183      * will be to transferred to `to`.
1184      * - when `from` is zero, `amount` tokens will be minted for `to`.
1185      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1186      * - `from` and `to` are never both zero.
1187      *
1188      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1189      */
1190     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1191 }
1192 
1193 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
1194 
1195 
1196 
1197 pragma solidity >=0.6.0 <0.8.0;
1198 
1199 
1200 /**
1201  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1202  */
1203 abstract contract ERC20Capped is ERC20 {
1204     using SafeMath for uint256;
1205 
1206     uint256 private _cap;
1207 
1208     /**
1209      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1210      * set once during construction.
1211      */
1212     constructor (uint256 cap_) internal {
1213         require(cap_ > 0, "ERC20Capped: cap is 0");
1214         _cap = cap_;
1215     }
1216 
1217     /**
1218      * @dev Returns the cap on the token's total supply.
1219      */
1220     function cap() public view returns (uint256) {
1221         return _cap;
1222     }
1223 
1224     /**
1225      * @dev See {ERC20-_beforeTokenTransfer}.
1226      *
1227      * Requirements:
1228      *
1229      * - minted tokens must not cause the total supply to go over the cap.
1230      */
1231     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1232         super._beforeTokenTransfer(from, to, amount);
1233 
1234         if (from == address(0)) { // When minting tokens
1235             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1236         }
1237     }
1238 }
1239 
1240 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1241 
1242 
1243 
1244 pragma solidity >=0.6.0 <0.8.0;
1245 
1246 
1247 
1248 /**
1249  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1250  * tokens and those that they have an allowance for, in a way that can be
1251  * recognized off-chain (via event analysis).
1252  */
1253 abstract contract ERC20Burnable is Context, ERC20 {
1254     using SafeMath for uint256;
1255 
1256     /**
1257      * @dev Destroys `amount` tokens from the caller.
1258      *
1259      * See {ERC20-_burn}.
1260      */
1261     function burn(uint256 amount) public virtual {
1262         _burn(_msgSender(), amount);
1263     }
1264 
1265     /**
1266      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1267      * allowance.
1268      *
1269      * See {ERC20-_burn} and {ERC20-allowance}.
1270      *
1271      * Requirements:
1272      *
1273      * - the caller must have allowance for ``accounts``'s tokens of at least
1274      * `amount`.
1275      */
1276     function burnFrom(address account, uint256 amount) public virtual {
1277         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1278 
1279         _approve(account, _msgSender(), decreasedAllowance);
1280         _burn(account, amount);
1281     }
1282 }
1283 
1284 // File: contracts/Unic.sol
1285 
1286 pragma solidity 0.6.12;
1287 
1288 
1289 
1290 
1291 
1292 // Unic with Governance.
1293 contract Unic is ERC20, ERC20Capped, ERC20Burnable, Ownable {
1294     constructor () 
1295         public 
1296         ERC20("UNIC", "UNIC")
1297         ERC20Capped(1_000_000e18)
1298     {
1299         // Mint 1 UNIC to me because I deserve it
1300         _mint(_msgSender(), 1e18);
1301         _moveDelegates(address(0), _delegates[_msgSender()], 1e18);
1302     }
1303 
1304     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
1305     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
1306         _mint(_to, _amount);
1307         _moveDelegates(address(0), _delegates[_to], _amount);
1308         return true;
1309     }
1310 
1311     // Copied and modified from YAM code:
1312     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1313     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1314     // Which is copied and modified from COMPOUND:
1315     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1316 
1317     /// @dev A record of each accounts delegate
1318     mapping (address => address) internal _delegates;
1319 
1320     /// @notice A checkpoint for marking number of votes from a given block
1321     struct Checkpoint {
1322         uint32 fromBlock;
1323         uint256 votes;
1324     }
1325 
1326     /// @notice A record of votes checkpoints for each account, by index
1327     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1328 
1329     /// @notice The number of checkpoints for each account
1330     mapping (address => uint32) public numCheckpoints;
1331 
1332     /// @notice The EIP-712 typehash for the contract's domain
1333     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1334 
1335     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1336     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1337 
1338     /// @notice A record of states for signing / validating signatures
1339     mapping (address => uint) public nonces;
1340 
1341       /// @notice An event thats emitted when an account changes its delegate
1342     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1343 
1344     /// @notice An event thats emitted when a delegate account's vote balance changes
1345     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1346 
1347     /**
1348      * @notice Delegate votes from `msg.sender` to `delegatee`
1349      * @param delegator The address to get delegatee for
1350      */
1351     function delegates(address delegator)
1352         external
1353         view
1354         returns (address)
1355     {
1356         return _delegates[delegator];
1357     }
1358 
1359    /**
1360     * @notice Delegate votes from `msg.sender` to `delegatee`
1361     * @param delegatee The address to delegate votes to
1362     */
1363     function delegate(address delegatee) external {
1364         return _delegate(msg.sender, delegatee);
1365     }
1366 
1367     /**
1368      * @notice Delegates votes from signatory to `delegatee`
1369      * @param delegatee The address to delegate votes to
1370      * @param nonce The contract state required to match the signature
1371      * @param expiry The time at which to expire the signature
1372      * @param v The recovery byte of the signature
1373      * @param r Half of the ECDSA signature pair
1374      * @param s Half of the ECDSA signature pair
1375      */
1376     function delegateBySig(
1377         address delegatee,
1378         uint nonce,
1379         uint expiry,
1380         uint8 v,
1381         bytes32 r,
1382         bytes32 s
1383     )
1384         external
1385     {
1386         bytes32 domainSeparator = keccak256(
1387             abi.encode(
1388                 DOMAIN_TYPEHASH,
1389                 keccak256(bytes(name())),
1390                 getChainId(),
1391                 address(this)
1392             )
1393         );
1394 
1395         bytes32 structHash = keccak256(
1396             abi.encode(
1397                 DELEGATION_TYPEHASH,
1398                 delegatee,
1399                 nonce,
1400                 expiry
1401             )
1402         );
1403 
1404         bytes32 digest = keccak256(
1405             abi.encodePacked(
1406                 "\x19\x01",
1407                 domainSeparator,
1408                 structHash
1409             )
1410         );
1411 
1412         address signatory = ecrecover(digest, v, r, s);
1413         require(signatory != address(0), "UNIC::delegateBySig: invalid signature");
1414         require(nonce == nonces[signatory]++, "UNIC::delegateBySig: invalid nonce");
1415         require(now <= expiry, "UNIC::delegateBySig: signature expired");
1416         return _delegate(signatory, delegatee);
1417     }
1418 
1419     /**
1420      * @notice Gets the current votes balance for `account`
1421      * @param account The address to get votes balance
1422      * @return The number of current votes for `account`
1423      */
1424     function getCurrentVotes(address account)
1425         external
1426         view
1427         returns (uint256)
1428     {
1429         uint32 nCheckpoints = numCheckpoints[account];
1430         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1431     }
1432 
1433     /**
1434      * @notice Determine the prior number of votes for an account as of a block number
1435      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1436      * @param account The address of the account to check
1437      * @param blockNumber The block number to get the vote balance at
1438      * @return The number of votes the account had as of the given block
1439      */
1440     function getPriorVotes(address account, uint blockNumber)
1441         external
1442         view
1443         returns (uint256)
1444     {
1445         require(blockNumber < block.number, "UNIC::getPriorVotes: not yet determined");
1446 
1447         uint32 nCheckpoints = numCheckpoints[account];
1448         if (nCheckpoints == 0) {
1449             return 0;
1450         }
1451 
1452         // First check most recent balance
1453         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1454             return checkpoints[account][nCheckpoints - 1].votes;
1455         }
1456 
1457         // Next check implicit zero balance
1458         if (checkpoints[account][0].fromBlock > blockNumber) {
1459             return 0;
1460         }
1461 
1462         uint32 lower = 0;
1463         uint32 upper = nCheckpoints - 1;
1464         while (upper > lower) {
1465             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1466             Checkpoint memory cp = checkpoints[account][center];
1467             if (cp.fromBlock == blockNumber) {
1468                 return cp.votes;
1469             } else if (cp.fromBlock < blockNumber) {
1470                 lower = center;
1471             } else {
1472                 upper = center - 1;
1473             }
1474         }
1475         return checkpoints[account][lower].votes;
1476     }
1477 
1478     function _delegate(address delegator, address delegatee)
1479         internal
1480     {
1481         address currentDelegate = _delegates[delegator];
1482         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying UNICs (not scaled);
1483         _delegates[delegator] = delegatee;
1484 
1485         emit DelegateChanged(delegator, currentDelegate, delegatee);
1486 
1487         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1488     }
1489 
1490     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1491         if (srcRep != dstRep && amount > 0) {
1492             if (srcRep != address(0)) {
1493                 // decrease old representative
1494                 uint32 srcRepNum = numCheckpoints[srcRep];
1495                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1496                 uint256 srcRepNew = srcRepOld.sub(amount);
1497                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1498             }
1499 
1500             if (dstRep != address(0)) {
1501                 // increase new representative
1502                 uint32 dstRepNum = numCheckpoints[dstRep];
1503                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1504                 uint256 dstRepNew = dstRepOld.add(amount);
1505                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1506             }
1507         }
1508     }
1509 
1510     function _writeCheckpoint(
1511         address delegatee,
1512         uint32 nCheckpoints,
1513         uint256 oldVotes,
1514         uint256 newVotes
1515     )
1516         internal
1517     {
1518         uint32 blockNumber = safe32(block.number, "UNIC::_writeCheckpoint: block number exceeds 32 bits");
1519 
1520         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1521             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1522         } else {
1523             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1524             numCheckpoints[delegatee] = nCheckpoints + 1;
1525         }
1526 
1527         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1528     }
1529 
1530     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1531         require(n < 2**32, errorMessage);
1532         return uint32(n);
1533     }
1534 
1535     function getChainId() internal pure returns (uint) {
1536         uint256 chainId;
1537         assembly { chainId := chainid() }
1538         return chainId;
1539     }
1540 
1541     /**
1542      * @dev See {ERC20-_beforeTokenTransfer}.
1543      */
1544     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1545         super._beforeTokenTransfer(from, to, amount);
1546     }
1547 }
1548 
1549 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
1550 
1551 
1552 
1553 pragma solidity >=0.6.2 <0.8.0;
1554 
1555 /**
1556  * @dev Library used to query support of an interface declared via {IERC165}.
1557  *
1558  * Note that these functions return the actual result of the query: they do not
1559  * `revert` if an interface is not supported. It is up to the caller to decide
1560  * what to do in these cases.
1561  */
1562 library ERC165Checker {
1563     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1564     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1565 
1566     /*
1567      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1568      */
1569     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1570 
1571     /**
1572      * @dev Returns true if `account` supports the {IERC165} interface,
1573      */
1574     function supportsERC165(address account) internal view returns (bool) {
1575         // Any contract that implements ERC165 must explicitly indicate support of
1576         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1577         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1578             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1579     }
1580 
1581     /**
1582      * @dev Returns true if `account` supports the interface defined by
1583      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1584      *
1585      * See {IERC165-supportsInterface}.
1586      */
1587     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1588         // query support of both ERC165 as per the spec and support of _interfaceId
1589         return supportsERC165(account) &&
1590             _supportsERC165Interface(account, interfaceId);
1591     }
1592 
1593     /**
1594      * @dev Returns true if `account` supports all the interfaces defined in
1595      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1596      *
1597      * Batch-querying can lead to gas savings by skipping repeated checks for
1598      * {IERC165} support.
1599      *
1600      * See {IERC165-supportsInterface}.
1601      */
1602     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1603         // query support of ERC165 itself
1604         if (!supportsERC165(account)) {
1605             return false;
1606         }
1607 
1608         // query support of each interface in _interfaceIds
1609         for (uint256 i = 0; i < interfaceIds.length; i++) {
1610             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1611                 return false;
1612             }
1613         }
1614 
1615         // all interfaces supported
1616         return true;
1617     }
1618 
1619     /**
1620      * @notice Query if a contract implements an interface, does not check ERC165 support
1621      * @param account The address of the contract to query for support of an interface
1622      * @param interfaceId The interface identifier, as specified in ERC-165
1623      * @return true if the contract at account indicates support of the interface with
1624      * identifier interfaceId, false otherwise
1625      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1626      * the behavior of this method is undefined. This precondition can be checked
1627      * with {supportsERC165}.
1628      * Interface identification is specified in ERC-165.
1629      */
1630     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1631         // success determines whether the staticcall succeeded and result determines
1632         // whether the contract at account indicates support of _interfaceId
1633         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1634 
1635         return (success && result);
1636     }
1637 
1638     /**
1639      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1640      * @param account The address of the contract to query for support of an interface
1641      * @param interfaceId The interface identifier, as specified in ERC-165
1642      * @return success true if the STATICCALL succeeded, false otherwise
1643      * @return result true if the STATICCALL succeeded and the contract at account
1644      * indicates support of the interface with identifier interfaceId, false otherwise
1645      */
1646     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1647         private
1648         view
1649         returns (bool, bool)
1650     {
1651         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1652         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1653         if (result.length < 32) return (false, false);
1654         return (success, abi.decode(result, (bool)));
1655     }
1656 }
1657 
1658 // File: @openzeppelin/contracts/introspection/IERC165.sol
1659 
1660 
1661 
1662 pragma solidity >=0.6.0 <0.8.0;
1663 
1664 /**
1665  * @dev Interface of the ERC165 standard, as defined in the
1666  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1667  *
1668  * Implementers can declare support of contract interfaces, which can then be
1669  * queried by others ({ERC165Checker}).
1670  *
1671  * For an implementation, see {ERC165}.
1672  */
1673 interface IERC165 {
1674     /**
1675      * @dev Returns true if this contract implements the interface defined by
1676      * `interfaceId`. See the corresponding
1677      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1678      * to learn more about how these ids are created.
1679      *
1680      * This function call must use less than 30 000 gas.
1681      */
1682     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1683 }
1684 
1685 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1686 
1687 
1688 
1689 pragma solidity >=0.6.2 <0.8.0;
1690 
1691 
1692 /**
1693  * @dev Required interface of an ERC721 compliant contract.
1694  */
1695 interface IERC721 is IERC165 {
1696     /**
1697      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1698      */
1699     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1700 
1701     /**
1702      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1703      */
1704     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1705 
1706     /**
1707      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1708      */
1709     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1710 
1711     /**
1712      * @dev Returns the number of tokens in ``owner``'s account.
1713      */
1714     function balanceOf(address owner) external view returns (uint256 balance);
1715 
1716     /**
1717      * @dev Returns the owner of the `tokenId` token.
1718      *
1719      * Requirements:
1720      *
1721      * - `tokenId` must exist.
1722      */
1723     function ownerOf(uint256 tokenId) external view returns (address owner);
1724 
1725     /**
1726      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1727      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1728      *
1729      * Requirements:
1730      *
1731      * - `from` cannot be the zero address.
1732      * - `to` cannot be the zero address.
1733      * - `tokenId` token must exist and be owned by `from`.
1734      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1735      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1736      *
1737      * Emits a {Transfer} event.
1738      */
1739     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1740 
1741     /**
1742      * @dev Transfers `tokenId` token from `from` to `to`.
1743      *
1744      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1745      *
1746      * Requirements:
1747      *
1748      * - `from` cannot be the zero address.
1749      * - `to` cannot be the zero address.
1750      * - `tokenId` token must be owned by `from`.
1751      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1752      *
1753      * Emits a {Transfer} event.
1754      */
1755     function transferFrom(address from, address to, uint256 tokenId) external;
1756 
1757     /**
1758      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1759      * The approval is cleared when the token is transferred.
1760      *
1761      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1762      *
1763      * Requirements:
1764      *
1765      * - The caller must own the token or be an approved operator.
1766      * - `tokenId` must exist.
1767      *
1768      * Emits an {Approval} event.
1769      */
1770     function approve(address to, uint256 tokenId) external;
1771 
1772     /**
1773      * @dev Returns the account approved for `tokenId` token.
1774      *
1775      * Requirements:
1776      *
1777      * - `tokenId` must exist.
1778      */
1779     function getApproved(uint256 tokenId) external view returns (address operator);
1780 
1781     /**
1782      * @dev Approve or remove `operator` as an operator for the caller.
1783      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1784      *
1785      * Requirements:
1786      *
1787      * - The `operator` cannot be the caller.
1788      *
1789      * Emits an {ApprovalForAll} event.
1790      */
1791     function setApprovalForAll(address operator, bool _approved) external;
1792 
1793     /**
1794      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1795      *
1796      * See {setApprovalForAll}
1797      */
1798     function isApprovedForAll(address owner, address operator) external view returns (bool);
1799 
1800     /**
1801       * @dev Safely transfers `tokenId` token from `from` to `to`.
1802       *
1803       * Requirements:
1804       *
1805      * - `from` cannot be the zero address.
1806      * - `to` cannot be the zero address.
1807       * - `tokenId` token must exist and be owned by `from`.
1808       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1809       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1810       *
1811       * Emits a {Transfer} event.
1812       */
1813     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1814 }
1815 
1816 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1817 
1818 
1819 
1820 pragma solidity >=0.6.2 <0.8.0;
1821 
1822 
1823 /**
1824  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1825  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1826  *
1827  * _Available since v3.1._
1828  */
1829 interface IERC1155 is IERC165 {
1830     /**
1831      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1832      */
1833     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1834 
1835     /**
1836      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1837      * transfers.
1838      */
1839     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
1840 
1841     /**
1842      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1843      * `approved`.
1844      */
1845     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1846 
1847     /**
1848      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1849      *
1850      * If an {URI} event was emitted for `id`, the standard
1851      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1852      * returned by {IERC1155MetadataURI-uri}.
1853      */
1854     event URI(string value, uint256 indexed id);
1855 
1856     /**
1857      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1858      *
1859      * Requirements:
1860      *
1861      * - `account` cannot be the zero address.
1862      */
1863     function balanceOf(address account, uint256 id) external view returns (uint256);
1864 
1865     /**
1866      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1867      *
1868      * Requirements:
1869      *
1870      * - `accounts` and `ids` must have the same length.
1871      */
1872     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
1873 
1874     /**
1875      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1876      *
1877      * Emits an {ApprovalForAll} event.
1878      *
1879      * Requirements:
1880      *
1881      * - `operator` cannot be the caller.
1882      */
1883     function setApprovalForAll(address operator, bool approved) external;
1884 
1885     /**
1886      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1887      *
1888      * See {setApprovalForAll}.
1889      */
1890     function isApprovedForAll(address account, address operator) external view returns (bool);
1891 
1892     /**
1893      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1894      *
1895      * Emits a {TransferSingle} event.
1896      *
1897      * Requirements:
1898      *
1899      * - `to` cannot be the zero address.
1900      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1901      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1902      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1903      * acceptance magic value.
1904      */
1905     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
1906 
1907     /**
1908      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1909      *
1910      * Emits a {TransferBatch} event.
1911      *
1912      * Requirements:
1913      *
1914      * - `ids` and `amounts` must have the same length.
1915      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1916      * acceptance magic value.
1917      */
1918     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
1919 }
1920 
1921 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1922 
1923 
1924 
1925 pragma solidity >=0.6.0 <0.8.0;
1926 
1927 
1928 /**
1929  * _Available since v3.1._
1930  */
1931 interface IERC1155Receiver is IERC165 {
1932 
1933     /**
1934         @dev Handles the receipt of a single ERC1155 token type. This function is
1935         called at the end of a `safeTransferFrom` after the balance has been updated.
1936         To accept the transfer, this must return
1937         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1938         (i.e. 0xf23a6e61, or its own function selector).
1939         @param operator The address which initiated the transfer (i.e. msg.sender)
1940         @param from The address which previously owned the token
1941         @param id The ID of the token being transferred
1942         @param value The amount of tokens being transferred
1943         @param data Additional data with no specified format
1944         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1945     */
1946     function onERC1155Received(
1947         address operator,
1948         address from,
1949         uint256 id,
1950         uint256 value,
1951         bytes calldata data
1952     )
1953         external
1954         returns(bytes4);
1955 
1956     /**
1957         @dev Handles the receipt of a multiple ERC1155 token types. This function
1958         is called at the end of a `safeBatchTransferFrom` after the balances have
1959         been updated. To accept the transfer(s), this must return
1960         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1961         (i.e. 0xbc197c81, or its own function selector).
1962         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1963         @param from The address which previously owned the token
1964         @param ids An array containing ids of each token being transferred (order and length must match values array)
1965         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1966         @param data Additional data with no specified format
1967         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1968     */
1969     function onERC1155BatchReceived(
1970         address operator,
1971         address from,
1972         uint256[] calldata ids,
1973         uint256[] calldata values,
1974         bytes calldata data
1975     )
1976         external
1977         returns(bytes4);
1978 }
1979 
1980 // File: @openzeppelin/contracts/introspection/ERC165.sol
1981 
1982 
1983 
1984 pragma solidity >=0.6.0 <0.8.0;
1985 
1986 
1987 /**
1988  * @dev Implementation of the {IERC165} interface.
1989  *
1990  * Contracts may inherit from this and call {_registerInterface} to declare
1991  * their support of an interface.
1992  */
1993 abstract contract ERC165 is IERC165 {
1994     /*
1995      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1996      */
1997     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1998 
1999     /**
2000      * @dev Mapping of interface ids to whether or not it's supported.
2001      */
2002     mapping(bytes4 => bool) private _supportedInterfaces;
2003 
2004     constructor () internal {
2005         // Derived contracts need only register support for their own interfaces,
2006         // we register support for ERC165 itself here
2007         _registerInterface(_INTERFACE_ID_ERC165);
2008     }
2009 
2010     /**
2011      * @dev See {IERC165-supportsInterface}.
2012      *
2013      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
2014      */
2015     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
2016         return _supportedInterfaces[interfaceId];
2017     }
2018 
2019     /**
2020      * @dev Registers the contract as an implementer of the interface defined by
2021      * `interfaceId`. Support of the actual ERC165 interface is automatic and
2022      * registering its interface id is not required.
2023      *
2024      * See {IERC165-supportsInterface}.
2025      *
2026      * Requirements:
2027      *
2028      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
2029      */
2030     function _registerInterface(bytes4 interfaceId) internal virtual {
2031         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
2032         _supportedInterfaces[interfaceId] = true;
2033     }
2034 }
2035 
2036 // File: @openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol
2037 
2038 
2039 
2040 pragma solidity >=0.6.0 <0.8.0;
2041 
2042 
2043 
2044 /**
2045  * @dev _Available since v3.1._
2046  */
2047 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
2048     constructor() internal {
2049         _registerInterface(
2050             ERC1155Receiver(0).onERC1155Received.selector ^
2051             ERC1155Receiver(0).onERC1155BatchReceived.selector
2052         );
2053     }
2054 }
2055 
2056 // File: contracts/interfaces/IUnicFactory.sol
2057 
2058 pragma solidity >=0.5.0;
2059 
2060 interface IUnicFactory {
2061     event TokenCreated(address indexed caller, address indexed uToken);
2062 
2063     function feeTo() external view returns (address);
2064     function feeToSetter() external view returns (address);
2065 
2066     function getUToken(address uToken) external view returns (uint);
2067     function uTokens(uint) external view returns (address);
2068     function uTokensLength() external view returns (uint);
2069 
2070     function createUToken(uint256 totalSupply, uint8 decimals, string calldata name, string calldata symbol, uint256 threshold, string calldata description) external returns (address);
2071 
2072     function setFeeTo(address) external;
2073     function setFeeToSetter(address) external;
2074 }
2075 
2076 // File: contracts/Converter.sol
2077 
2078 pragma solidity 0.6.12;
2079 
2080 
2081 
2082 
2083 
2084 
2085 
2086 
2087 contract Converter is ERC20, ERC1155Receiver {
2088     using SafeMath for uint;
2089 
2090     // List of NFTs that have been deposited
2091     struct NFT {
2092         address contractAddr;
2093         uint256 tokenId;
2094         uint256 amount;
2095         bool claimed;
2096     }
2097 
2098     struct Bid {
2099         address bidder;
2100         uint256 amount;
2101         uint time;
2102     }
2103 
2104     mapping(uint256 => NFT) public nfts;
2105     // Current index and length of nfts
2106     uint256 public currentNFTIndex = 0;
2107 
2108     // If active, NFTs can’t be withdrawn
2109     bool public active = false;
2110     uint256 public totalBidAmount = 0;
2111     uint256 public unlockVotes = 0;
2112     uint256 public _threshold;
2113     address public issuer;
2114     string public _description;
2115     uint256 public cap;
2116 
2117     // Amount of uTokens each user has voted to unlock collection
2118     mapping(address => uint256) public unlockApproved;
2119 
2120     IUnicFactory public factory;
2121 
2122     // NFT index to Bid
2123     mapping(uint256 => Bid) public bids;
2124     // NFT index to address to amount
2125     mapping(uint256 => mapping(address => uint256)) public bidRefunds;
2126     uint public constant TOP_BID_LOCK_TIME = 3 days;
2127 
2128     event Deposited(uint256[] tokenIDs, uint256[] amounts, address contractAddr);
2129     event Refunded();
2130     event Issued();
2131     event BidCreated(address sender, uint256 nftIndex, uint256 bidAmount);
2132     event BidRemoved(address sender, uint256 nftIndex);
2133     event ClaimedNFT(address winner, uint256 nftIndex, uint256 tokenId);
2134 
2135     bytes private constant VALIDATOR = bytes('JCMY');
2136 
2137     constructor (uint256 totalSupply, uint8 decimals, string memory name, string memory symbol, uint256 threshold, string memory description, address _issuer, IUnicFactory _factory)
2138         public
2139         ERC20(name, symbol)
2140     {
2141         _setupDecimals(decimals);
2142         issuer = _issuer;
2143         _description = description;
2144         _threshold = threshold;
2145         factory = _factory;
2146         cap = totalSupply;
2147     }
2148 
2149     // deposits an nft using the transferFrom action of the NFT contractAddr
2150     function deposit(uint256[] calldata tokenIDs, uint256[] calldata amounts, address contractAddr) external {
2151         require(msg.sender == issuer, "Converter: Only issuer can deposit");
2152         require(tokenIDs.length <= 50, "Converter: A maximum of 50 tokens can be deposited in one go");
2153         require(tokenIDs.length > 0, "Converter: You must specify at least one token ID");
2154 
2155         if (ERC165Checker.supportsInterface(contractAddr, 0xd9b67a26)){
2156             IERC1155(contractAddr).safeBatchTransferFrom(msg.sender, address(this), tokenIDs, amounts, VALIDATOR);
2157 
2158             for (uint8 i = 0; i < 50; i++){
2159                 if (tokenIDs.length == i){
2160                     break;
2161                 }
2162                 nfts[currentNFTIndex++] = NFT(contractAddr, tokenIDs[i], amounts[i], false);
2163             }
2164         }
2165         else if (ERC165Checker.supportsInterface(contractAddr, 0x80ac58cd)){
2166             for (uint8 i = 0; i < 50; i++){
2167                 if (tokenIDs.length == i){
2168                     break;
2169                 }
2170                 IERC721(contractAddr).transferFrom(msg.sender, address(this), tokenIDs[i]);
2171                 nfts[currentNFTIndex++] = NFT(contractAddr, tokenIDs[i], 1, false);
2172             }
2173         }
2174 
2175         emit Deposited(tokenIDs, amounts, contractAddr);
2176     }
2177 
2178     // Function that locks NFT collateral and issues the uTokens to the issuer
2179     function issue() external {
2180         require(msg.sender == issuer, "Converter: Only issuer can issue the tokens");
2181         require(active == false, "Converter: Token is already active");
2182 
2183         active = true;
2184         address feeTo = factory.feeTo();
2185         uint256 feeAmount = 0;
2186         if (feeTo != address(0)) {
2187             // 0.5% of uToken supply is sent to feeToAddress if fee is on
2188             feeAmount = cap.div(200);
2189             _mint(feeTo, feeAmount);
2190         }
2191 
2192         _mint(issuer, cap - feeAmount);
2193 
2194         emit Issued();
2195     }
2196 
2197     // Function that allows NFTs to be refunded (prior to issue being called)
2198     function refund(address _to) external {
2199         require(!active, "Converter: Contract is already active - cannot refund");
2200         require(msg.sender == issuer, "Converter: Only issuer can refund");
2201 
2202         // Only transfer maximum of 50 at a time to limit gas per call
2203         uint8 _i = 0;
2204         uint256 _index = currentNFTIndex;
2205         bytes memory data;
2206 
2207         while (_index > 0 && _i < 50){
2208             NFT memory nft = nfts[_index - 1];
2209 
2210             if (ERC165Checker.supportsInterface(nft.contractAddr, 0xd9b67a26)){
2211                 IERC1155(nft.contractAddr).safeTransferFrom(address(this), _to, nft.tokenId, nft.amount, data);
2212             }
2213             else if (ERC165Checker.supportsInterface(nft.contractAddr, 0x80ac58cd)){
2214                 IERC721(nft.contractAddr).safeTransferFrom(address(this), _to, nft.tokenId);
2215             }
2216 
2217             delete nfts[_index - 1];
2218 
2219             _index--;
2220             _i++;
2221         }
2222 
2223         currentNFTIndex = _index;
2224 
2225         emit Refunded();
2226     }
2227 
2228     function bid(uint256 nftIndex) external payable {
2229         require(unlockVotes < _threshold, "Converter: Release threshold has been met, no more bids allowed");
2230         Bid memory topBid = bids[nftIndex];
2231         require(topBid.bidder != msg.sender, "Converter: You have an active bid");
2232         require(topBid.amount < msg.value, "Converter: Bid too low");
2233         require(bidRefunds[nftIndex][msg.sender] == 0, "Converter: Collect bid refund");
2234 
2235         bids[nftIndex] = Bid(msg.sender, msg.value, getBlockTimestamp());
2236         bidRefunds[nftIndex][topBid.bidder] = topBid.amount;
2237         totalBidAmount += msg.value - topBid.amount;
2238 
2239         emit BidCreated(msg.sender, nftIndex, msg.value);
2240     }
2241 
2242     function unbid(uint256 nftIndex) external {
2243         Bid memory topBid = bids[nftIndex];
2244         bool isTopBidder = topBid.bidder == msg.sender;
2245         if (unlockVotes >= _threshold) {
2246             require(!isTopBidder, "Converter: Release threshold has been met, winner can't unbid");
2247         }
2248 
2249         if (isTopBidder) {
2250             require(topBid.time + TOP_BID_LOCK_TIME < getBlockTimestamp(), "Converter: Top bid locked");
2251             totalBidAmount -= topBid.amount;
2252             bids[nftIndex] = Bid(address(0), 0, getBlockTimestamp());
2253             (bool sent, bytes memory data) = msg.sender.call{value: topBid.amount}("");
2254             require(sent, "Converter: Failed to send Ether");
2255 
2256             emit BidRemoved(msg.sender, nftIndex);
2257         }
2258         else { 
2259             uint256 refundAmount = bidRefunds[nftIndex][msg.sender];
2260             require(refundAmount > 0, "Converter: no bid found");
2261             bidRefunds[nftIndex][msg.sender] = 0;
2262             (bool sent, bytes memory data) = msg.sender.call{value: refundAmount}("");
2263             require(sent, "Converter: Failed to send Ether");
2264         }
2265     }
2266 
2267     // Claim NFT if address is winning bidder
2268     function claim(uint256 nftIndex) external {
2269         require(unlockVotes >= _threshold, "Converter: Threshold not met");
2270         require(!nfts[nftIndex].claimed, "Converter: Already claimed");
2271         Bid memory topBid = bids[nftIndex];
2272         require(msg.sender == topBid.bidder, "Converter: Only winner can claim");
2273 
2274         nfts[nftIndex].claimed = true;
2275         NFT memory winningNFT = nfts[nftIndex];
2276 
2277         if (ERC165Checker.supportsInterface(winningNFT.contractAddr, 0xd9b67a26)){
2278             bytes memory data;
2279             IERC1155(winningNFT.contractAddr).safeTransferFrom(address(this), topBid.bidder, winningNFT.tokenId, winningNFT.amount, data);
2280         }
2281         else if (ERC165Checker.supportsInterface(winningNFT.contractAddr, 0x80ac58cd)){
2282             IERC721(winningNFT.contractAddr).safeTransferFrom(address(this), topBid.bidder, winningNFT.tokenId);
2283         }
2284 
2285         emit ClaimedNFT(topBid.bidder, nftIndex, winningNFT.tokenId);
2286     }
2287 
2288     // Approve collection unlock
2289     function approveUnlock(uint256 amount) external {
2290         require(unlockVotes < _threshold, "Converter: Threshold reached");
2291         _transfer(msg.sender, address(this), amount);
2292 
2293         unlockApproved[msg.sender] += amount;
2294         unlockVotes += amount;
2295     }
2296 
2297     // Unapprove collection unlock
2298     function unapproveUnlock(uint256 amount) external {
2299         require(unlockVotes < _threshold, "Converter: Threshold reached");
2300         require(unlockApproved[msg.sender] >= amount, "Converter: Not enough uTokens locked by user");
2301         unlockVotes -= amount;
2302         unlockApproved[msg.sender] -= amount;
2303 
2304         _transfer(address(this), msg.sender, amount);
2305     }
2306 
2307     // Claim ETH function
2308     function redeemETH(uint256 amount) external {
2309         require(unlockVotes >= _threshold, "Converter: Threshold not met");
2310         // Deposit uTokens
2311         if (amount > 0) {
2312             _transfer(msg.sender, address(this), amount);
2313         }
2314         // Combine approved balance + newly deposited balance
2315         uint256 finalBalance = amount + unlockApproved[msg.sender];
2316         // Remove locked uTokens tracked for user
2317         unlockApproved[msg.sender] = 0;
2318 
2319         // Redeem ETH corresponding to uToken amount
2320         (bool sent, bytes memory data) = msg.sender.call{value: totalBidAmount.mul(finalBalance).div(this.totalSupply())}("");
2321         require(sent, "Converter: Failed to send Ether");
2322     }
2323 
2324     function getBlockTimestamp() internal view returns (uint) {
2325         // solium-disable-next-line security/no-block-members
2326         return block.timestamp;
2327     }
2328 
2329     /**
2330      * ERC1155 Token ERC1155Receiver
2331      */
2332     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) override external returns(bytes4) {
2333         if(keccak256(_data) == keccak256(VALIDATOR)){
2334             return 0xf23a6e61;
2335         }
2336     }
2337 
2338     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) override external returns(bytes4) {
2339         if(keccak256(_data) == keccak256(VALIDATOR)){
2340             return 0xbc197c81;
2341         }
2342     }
2343 
2344 }
2345 
2346 // File: contracts/UnicFarm.sol
2347 
2348 pragma solidity 0.6.12;
2349 
2350 
2351 
2352 
2353 
2354 
2355 
2356 
2357 // Copied from https://github.com/sushiswap/sushiswap/blob/master/contracts/MasterChef.sol
2358 // Modified by 0xLeia
2359 
2360 // UnicFarm is where liquidity providers on UnicSwap can stake their LP tokens for UNIC rewards
2361 // The ownership of UnicFarm will be transferred to a governance smart contract once UNIC has been sufficiently distributed
2362 
2363 contract UnicFarm is Ownable {
2364     using SafeMath for uint256;
2365     using SafeERC20 for IERC20;
2366 
2367     // Info of each user.
2368     struct UserInfo {
2369         uint256 amount;     // How many LP tokens the user has provided.
2370         uint256 rewardDebt; // Reward debt. See explanation below.
2371         //
2372         // We do some fancy math here. Basically, any point in time, the amount of UNICs
2373         // entitled to a user but is pending to be distributed is:
2374         //
2375         //   pending reward = (user.amount * pool.accUnicPerShare) - user.rewardDebt
2376         //
2377         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
2378         //   1. The pool's `accUnicPerShare` (and `lastRewardBlock`) gets updated.
2379         //   2. User receives the pending reward sent to his/her address.
2380         //   3. User's `amount` gets updated.
2381         //   4. User's `rewardDebt` gets updated.
2382     }
2383 
2384     // Info of each pool.
2385     struct PoolInfo {
2386         IERC20 lpToken;           // Address of LP token contract.
2387         uint256 allocPoint;       // How many allocation points assigned to this pool. UNICs to distribute per block.
2388         uint256 lastRewardBlock;  // Last block number that UNICs distribution occurs.
2389         uint256 accUnicPerShare; // Accumulated UNICs per share, times 1e12. See below.
2390         address uToken;
2391     }
2392 
2393     // The UNIC TOKEN!
2394     Unic public unic;
2395     // Dev address.
2396     address public devaddr;
2397     // Mint rate controllers
2398     uint256 public mintRateMultiplier;
2399     uint256 public mintRateDivider;
2400     // Blocks per tranche used to calculate current mint rate (6500 blocks per day * 30 = 195000)
2401     uint256 public blocksPerTranche;
2402     // Current tranche
2403     uint256 public tranche = 0;
2404     // Whitelist mapping of address to bool
2405     mapping(address => bool) public whitelist;
2406     // UNIC tokens created per block.
2407     uint256 public unicPerBlock;
2408 
2409     // Info of each pool.
2410     PoolInfo[] public poolInfo;
2411     // Info of each user that stakes LP tokens.
2412     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
2413     // Total allocation points. Must be the sum of all allocation points in all pools.
2414     uint256 public totalAllocPoint = 0;
2415     // The block number when UNIC mining starts.
2416     uint256 public startBlock;
2417 
2418     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
2419     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
2420     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
2421 
2422     // New events so that the graph works
2423     event Add(uint256 allocPoint, address lpToken, bool withUpdate);
2424     event Set(uint256 pid, uint256 allocPoint, bool withUpdate);
2425     event MassUpdatePools();
2426     event UpdatePool(uint256 pid);
2427     event Dev(address devaddr);
2428 
2429     constructor(
2430         Unic _unic,
2431         address _devaddr,
2432         uint256 _mintRateMultiplier,
2433         uint256 _mintRateDivider,
2434         uint256 _unicPerBlock,
2435         uint256 _startBlock,
2436         uint256 _blocksPerTranche
2437     ) public {
2438         unic = _unic;
2439         devaddr = _devaddr;
2440         mintRateMultiplier = _mintRateMultiplier;
2441         mintRateDivider = _mintRateDivider;
2442         unicPerBlock = _unicPerBlock;
2443         startBlock = _startBlock;
2444         blocksPerTranche = _blocksPerTranche;
2445     }
2446 
2447     function poolLength() external view returns (uint256) {
2448         return poolInfo.length;
2449     }
2450 
2451     // Add a new lp to the pool. Can only be called by the owner.
2452     // address(0) for uToken if there's no uToken involved. Input uToken address if there is.
2453     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, address _uToken) public onlyOwner {
2454         require(!whitelist[address(_lpToken)]);
2455         if (_withUpdate) {
2456             massUpdatePools();
2457         }
2458         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
2459         totalAllocPoint = totalAllocPoint.add(_allocPoint);
2460         poolInfo.push(PoolInfo({
2461             lpToken: _lpToken,
2462             allocPoint: _allocPoint,
2463             lastRewardBlock: lastRewardBlock,
2464             accUnicPerShare: 0,
2465             uToken: _uToken
2466         }));
2467 
2468         whitelist[address(_lpToken)] = true;
2469 
2470         emit Add(_allocPoint, address(_lpToken), _withUpdate);
2471     }
2472 
2473     // Update the given pool's UNIC allocation point. Can only be called by the owner.
2474     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
2475         if (_withUpdate) {
2476             massUpdatePools();
2477         }
2478         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
2479         poolInfo[_pid].allocPoint = _allocPoint;
2480 
2481         emit Set(_pid, _allocPoint, _withUpdate);
2482     }
2483 
2484     // Return rewards over the given _from to _to block.
2485     // Rewards accumulate for a maximum of 195000 blocks.
2486     function getRewards(uint256 _from, uint256 _to) public view returns (uint256) {
2487         uint256 lastTrancheBlock = startBlock.add(tranche.mul(blocksPerTranche));
2488         if (_to.sub(_from) > blocksPerTranche) {
2489             _from = _to.sub(blocksPerTranche);
2490         }
2491 
2492         if (_from > lastTrancheBlock) {
2493             return _to.sub(_from).mul(unicPerBlock);
2494         } else {
2495             // Use prior mint rate for blocks staked before last tranche block
2496             return lastTrancheBlock.sub(_from).mul(unicPerBlock).mul(mintRateDivider).div(mintRateMultiplier).add(
2497                 _to.sub(lastTrancheBlock).mul(unicPerBlock)
2498             );
2499         }
2500     }
2501 
2502     // View function to see pending UNICs on frontend.
2503     function pendingUnic(uint256 _pid, address _user) external view returns (uint256) {
2504         PoolInfo storage pool = poolInfo[_pid];
2505         UserInfo storage user = userInfo[_pid][_user];
2506         uint256 accUnicPerShare = pool.accUnicPerShare;
2507         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2508         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
2509             uint256 unicReward = getRewards(pool.lastRewardBlock, block.number).mul(pool.allocPoint).div(totalAllocPoint);
2510             accUnicPerShare = accUnicPerShare.add(unicReward.mul(1e12).div(lpSupply));
2511         }
2512         return user.amount.mul(accUnicPerShare).div(1e12).sub(user.rewardDebt);
2513     }
2514 
2515     // Update reward variables for all pools. Be careful of gas spending!
2516     function massUpdatePools() public {
2517         uint256 length = poolInfo.length;
2518         for (uint256 pid = 0; pid < length; ++pid) {
2519             updatePool(pid);
2520         }
2521 
2522         emit MassUpdatePools();
2523     }
2524 
2525     // Update reward variables of the given pool to be up-to-date.
2526     function updatePool(uint256 _pid) public {
2527         PoolInfo storage pool = poolInfo[_pid];
2528         if (pool.uToken != address(0) && pool.allocPoint > 0) {
2529             if (Converter(pool.uToken).unlockVotes() >= Converter(pool.uToken)._threshold()) {
2530                 totalAllocPoint = totalAllocPoint.sub(pool.allocPoint);
2531                 pool.allocPoint = 0;
2532                 emit Set(_pid, 0, false);
2533             }
2534         }
2535         if (block.number <= pool.lastRewardBlock) {
2536             return;
2537         }
2538         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2539         if (lpSupply == 0) {
2540             pool.lastRewardBlock = block.number;
2541             return;
2542         }
2543         // Update block rewards and tranche based on block height
2544         if (block.number >= startBlock.add(tranche.mul(blocksPerTranche)).add(blocksPerTranche)) {
2545             tranche++;
2546             unicPerBlock = unicPerBlock.mul(mintRateMultiplier).div(mintRateDivider);
2547         }
2548         uint256 unicReward = getRewards(pool.lastRewardBlock, block.number).mul(pool.allocPoint).div(totalAllocPoint);
2549         unic.mint(devaddr, unicReward.div(9));
2550         unic.mint(address(this), unicReward);
2551         pool.accUnicPerShare = pool.accUnicPerShare.add(unicReward.mul(1e12).div(lpSupply));
2552         pool.lastRewardBlock = block.number;
2553 
2554         emit UpdatePool(_pid);
2555     }
2556 
2557     // Deposit LP tokens to UnicFarm for UNIC allocation.
2558     function deposit(uint256 _pid, uint256 _amount) public {
2559         PoolInfo storage pool = poolInfo[_pid];
2560         UserInfo storage user = userInfo[_pid][msg.sender];
2561         updatePool(_pid);
2562         if (user.amount > 0) {
2563             uint256 pending = user.amount.mul(pool.accUnicPerShare).div(1e12).sub(user.rewardDebt);
2564             if(pending > 0) {
2565                 safeUnicTransfer(msg.sender, pending);
2566             }
2567         }
2568         if(_amount > 0) {
2569             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
2570             user.amount = user.amount.add(_amount);
2571         }
2572         user.rewardDebt = user.amount.mul(pool.accUnicPerShare).div(1e12);
2573         emit Deposit(msg.sender, _pid, _amount);
2574     }
2575 
2576     // Withdraw LP tokens from UnicFarm.
2577     function withdraw(uint256 _pid, uint256 _amount) public {
2578         PoolInfo storage pool = poolInfo[_pid];
2579         UserInfo storage user = userInfo[_pid][msg.sender];
2580         require(user.amount >= _amount, "withdraw: not good");
2581         updatePool(_pid);
2582         uint256 pending = user.amount.mul(pool.accUnicPerShare).div(1e12).sub(user.rewardDebt);
2583         if(pending > 0) {
2584             safeUnicTransfer(msg.sender, pending);
2585         }
2586         if(_amount > 0) {
2587             user.amount = user.amount.sub(_amount);
2588             pool.lpToken.safeTransfer(address(msg.sender), _amount);
2589         }
2590         user.rewardDebt = user.amount.mul(pool.accUnicPerShare).div(1e12);
2591         emit Withdraw(msg.sender, _pid, _amount);
2592     }
2593 
2594     // Withdraw without caring about rewards. EMERGENCY ONLY.
2595     function emergencyWithdraw(uint256 _pid) public {
2596         PoolInfo storage pool = poolInfo[_pid];
2597         UserInfo storage user = userInfo[_pid][msg.sender];
2598         uint256 amount = user.amount;
2599         user.amount = 0;
2600         user.rewardDebt = 0;
2601         pool.lpToken.safeTransfer(address(msg.sender), amount);
2602         emit EmergencyWithdraw(msg.sender, _pid, amount);
2603     }
2604 
2605     // Safe unic transfer function, just in case if rounding error causes pool to not have enough UNICs.
2606     function safeUnicTransfer(address _to, uint256 _amount) internal {
2607         uint256 unicBal = unic.balanceOf(address(this));
2608         if (_amount > unicBal) {
2609             unic.transfer(_to, unicBal);
2610         } else {
2611             unic.transfer(_to, _amount);
2612         }
2613     }
2614 
2615     // Update dev address by the previous dev.
2616     function dev(address _devaddr) public {
2617         require(msg.sender == devaddr, "dev: wut?");
2618         devaddr = _devaddr;
2619 
2620         emit Dev(_devaddr);
2621     }
2622 
2623     // Set mint rate
2624     function setMintRules(uint256 _mintRateMultiplier, uint256 _mintRateDivider, uint256 _unicPerBlock, uint256 _blocksPerTranche) public onlyOwner {
2625         require(_mintRateDivider > 0, "no dividing by zero");
2626         require(_blocksPerTranche > 0, "zero blocks per tranche not allowed");
2627         mintRateMultiplier = _mintRateMultiplier;
2628         mintRateDivider = _mintRateDivider;
2629         unicPerBlock = _unicPerBlock;
2630         blocksPerTranche = _blocksPerTranche;
2631     }
2632 
2633     function setStartBlock(uint256 _startBlock) public onlyOwner {
2634         require(block.number < startBlock, "start block can not be modified after it has passed");
2635         require(block.number < _startBlock, "new start block needs to be in the future");
2636         startBlock = _startBlock;
2637     }
2638 }