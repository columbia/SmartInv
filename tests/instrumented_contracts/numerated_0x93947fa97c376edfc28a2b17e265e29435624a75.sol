1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
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
885 // File: contracts/interfaces/IAccessControl.sol
886 
887 pragma solidity ^0.6.0;
888 
889 interface IAccessControl {
890     function hasRole(bytes32 role, address account) external view returns (bool);
891 }
892 
893 // File: contracts/MasterChef.sol
894 
895 pragma solidity >=0.6.6;
896 
897 
898 
899 
900 
901 
902 
903 interface IMigratorChef {
904     function migrate(IERC20 token) external returns (IERC20);
905 }
906 
907 interface ITokenIssue {
908     function transByContract(address to, uint256 amount) external;
909 
910     function issueInfo(uint256 monthIndex) external view returns (uint256);
911 
912     function startIssueTime() external view returns (uint256);
913 
914     function issueInfoLength() external view returns (uint256);
915 
916     function TOTAL_AMOUNT() external view returns (uint256);
917 
918     function DAY_SECONDS() external view returns (uint256);
919 
920     function MONTH_SECONDS() external view returns (uint256);
921 
922     function INIT_MINE_SUPPLY() external view returns (uint256);
923 }
924 
925 // MasterChef is the master of Summa. He can make Summa and he is a fair guy.
926 //
927 // Note that it's ownable and the owner wields tremendous power. The ownership
928 // will be transferred to a governance smart contract once SUMMA is sufficiently
929 // distributed and the community can show to govern itself.
930 //
931 // Have fun reading it. Hopefully it's bug-free. God bless.
932 contract MasterChef is Ownable {
933     using SafeMath for uint256;
934     using SafeERC20 for IERC20;
935 
936     bytes32 public constant PUBLIC_ROLE = keccak256("PUBLIC_ROLE");
937 
938     // Info of each user.
939     struct UserInfo {
940         uint256 amount;     // How many LP tokens the user has provided.
941         uint256 rewardDebt; // Reward debt. See explanation below.
942         //
943         // We do some fancy math here. Basically, any point in time, the amount of SUMMAs
944         // entitled to a user but is pending to be distributed is:
945         //
946         //   pending reward = (user.amount * pool.accSUMMAPerShare) - user.rewardDebt
947         //
948         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
949         //   1. The pool's `accSUMMAPerShare` (and `lastRewardBlock`) gets updated.
950         //   2. User receives the pending reward sent to his/her address.
951         //   3. User's `amount` gets updated.
952         //   4. User's `rewardDebt` gets updated.
953     }
954 
955     // Info of each pool.
956     struct PoolInfo {
957         IERC20 lpToken;           // Address of LP token contract.
958         uint256 allocPoint;       // How many allocation points assigned to this pool. SUMMAs to distribute per block.
959         uint256 lastRewardTime;  // Last seconds that SUMMAs distribution occurs.
960         uint256 accSummaPerShare; // Accumulated SUMMAs per share, times 1e12. See below.
961     }
962 
963     // The SUMMA TOKEN!
964     IERC20 public summa;
965     // Block number when bonus SUMMA period ends.
966     uint256 public bonusEndTime;
967     // Bonus muliplier for early summa makers.
968     uint256 public constant BONUS_MULTIPLIER = 1;
969     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
970     IMigratorChef public migrator;
971 
972     IAccessControl public accessContract;
973 
974     ITokenIssue public tokenIssue;
975 
976     uint256 public totalIssueRate = 0.2 * 10000;
977     // Info of each pool.
978     PoolInfo[] public poolInfo;
979     // Info of each user that stakes LP tokens.
980     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
981     // Total allocation points. Must be the sum of all allocation points in all pools.
982     uint256 public totalAllocPoint = 0;
983     // The block number when SUMMA mining starts.
984     uint256 public startTime;
985 
986     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
987     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
988     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
989 
990     constructor(
991         IERC20 _summa,
992         uint256 _startTime,
993         uint256 _bonusEndTime,
994         IAccessControl _accessContract
995     ) public {
996         summa = _summa;
997         bonusEndTime = _bonusEndTime;
998         startTime = _startTime;
999         accessContract = _accessContract;
1000     }
1001 
1002     function poolLength() external view returns (uint256) {
1003         return poolInfo.length;
1004     }
1005 
1006     // Add a new lp to the pool. Can only be called by the owner.
1007     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1008     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1009         // avoid to add not erc20
1010         _lpToken.totalSupply();
1011 
1012         if (_withUpdate) {
1013             massUpdatePools();
1014         }
1015         uint256 lastRewardTime = block.number > startTime ? block.number : startTime;
1016         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1017         poolInfo.push(PoolInfo({
1018         lpToken : _lpToken,
1019         allocPoint : _allocPoint,
1020         lastRewardTime : lastRewardTime,
1021         accSummaPerShare : 0
1022         }));
1023     }
1024 
1025     // Update the given pool's SUMMA allocation point. Can only be called by the owner.
1026     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1027         if (_withUpdate) {
1028             massUpdatePools();
1029         }
1030         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1031         poolInfo[_pid].allocPoint = _allocPoint;
1032     }
1033 
1034     // Set the migrator contract. Can only be called by the owner.
1035     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1036         migrator = _migrator;
1037     }
1038 
1039     function setTokenIssue(ITokenIssue _tokenIssue) public onlyOwner {
1040         tokenIssue = _tokenIssue;
1041     }
1042 
1043     function setTotalIssueRate(uint256 _totalIssueRate) public onlyOwner {
1044         totalIssueRate = _totalIssueRate;
1045     }
1046 
1047     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1048     function migrate(uint256 _pid) public {
1049         require(address(migrator) != address(0), "migrate: no migrator");
1050         PoolInfo storage pool = poolInfo[_pid];
1051         IERC20 lpToken = pool.lpToken;
1052         uint256 bal = lpToken.balanceOf(address(this));
1053         lpToken.safeApprove(address(migrator), bal);
1054         IERC20 newLpToken = migrator.migrate(lpToken);
1055 //        require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1056         pool.lpToken = newLpToken;
1057     }
1058 
1059     // Return reward multiplier over the given _from to _to block.
1060     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1061         uint256 issueTime = tokenIssue.startIssueTime();
1062         if (_to <= bonusEndTime) {
1063             if (_to < issueTime) {
1064                 return 0;
1065             }
1066             if (_from < issueTime) {
1067                 return getIssue(issueTime, _to).mul(totalIssueRate).div(10000).mul(BONUS_MULTIPLIER);
1068             }
1069             return getIssue(issueTime, _to).sub(getIssue(issueTime, _from)).mul(totalIssueRate).div(10000).mul(BONUS_MULTIPLIER);
1070         } else if (_from >= bonusEndTime) {
1071             if (_to < issueTime) {
1072                 return 0;
1073             }
1074             if (_from < issueTime) {
1075                 return getIssue(issueTime, _to).mul(totalIssueRate).div(10000);
1076             }
1077             return getIssue(issueTime, _to).sub(getIssue(issueTime, _from)).mul(totalIssueRate).div(10000);
1078         } else {
1079             if (_to < issueTime) {
1080                 return 0;
1081             }
1082             if (_from < issueTime) {
1083                 if(issueTime < bonusEndTime){
1084                     return getIssue(issueTime,bonusEndTime).mul(BONUS_MULTIPLIER).add(
1085                         getIssue(issueTime, _to).sub(getIssue(issueTime, bonusEndTime))
1086                     ).mul(totalIssueRate).div(10000);
1087                 }
1088                 return getIssue(issueTime, _to);
1089             }
1090             return getIssue(issueTime, bonusEndTime).sub(getIssue(issueTime, _from)).mul(BONUS_MULTIPLIER).add(
1091                 getIssue(issueTime,_to).sub(getIssue(issueTime,bonusEndTime))
1092             ).mul(totalIssueRate).div(10000);
1093 
1094         }
1095     }
1096 
1097     function getIssue(uint256 _from, uint256 _to) private view returns (uint256){
1098         if (_to <= _from || _from <= 0) {
1099             return 0;
1100         }
1101         uint256 timeInterval = _to - _from;
1102         uint256 monthIndex = timeInterval.div(tokenIssue.MONTH_SECONDS());
1103         if (monthIndex < 1) {
1104             return timeInterval.mul(tokenIssue.issueInfo(monthIndex).div(tokenIssue.MONTH_SECONDS()));
1105         } else if (monthIndex < tokenIssue.issueInfoLength()) {
1106             uint256 tempTotal = 0;
1107             for (uint256 j = 0; j < monthIndex; j++) {
1108                 tempTotal = tempTotal.add(tokenIssue.issueInfo(j));
1109             }
1110             uint256 calcAmount = timeInterval.sub(monthIndex.mul(tokenIssue.MONTH_SECONDS())).mul(tokenIssue.issueInfo(monthIndex).div(tokenIssue.MONTH_SECONDS())).add(tempTotal);
1111             if (calcAmount > tokenIssue.TOTAL_AMOUNT().sub(tokenIssue.INIT_MINE_SUPPLY())) {
1112                 return tokenIssue.TOTAL_AMOUNT().sub(tokenIssue.INIT_MINE_SUPPLY());
1113             }
1114             return calcAmount;
1115         } else {
1116             return 0;
1117         }
1118     }
1119 
1120     // View function to see pending SUMMAs on frontend.
1121     function pendingSumma(uint256 _pid, address _user) external view returns (uint256) {
1122         PoolInfo storage pool = poolInfo[_pid];
1123         UserInfo storage user = userInfo[_pid][_user];
1124         uint256 accSummaPerShare = pool.accSummaPerShare;
1125         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1126         if (block.number > pool.lastRewardTime && lpSupply != 0) {
1127             uint256 multiplier = getMultiplier(pool.lastRewardTime, block.number);
1128             uint256 summaReward = multiplier.mul(pool.allocPoint).div(totalAllocPoint);
1129             accSummaPerShare = accSummaPerShare.add(summaReward.mul(1e12).div(lpSupply));
1130         }
1131         return user.amount.mul(accSummaPerShare).div(1e12).sub(user.rewardDebt);
1132     }
1133 
1134     // Update reward variables for all pools. Be careful of gas spending!
1135     function massUpdatePools() public {
1136         uint256 length = poolInfo.length;
1137         for (uint256 pid = 0; pid < length; ++pid) {
1138             updatePool(pid);
1139         }
1140     }
1141 
1142     // Update reward variables of the given pool to be up-to-date.
1143     function updatePool(uint256 _pid) public {
1144         PoolInfo storage pool = poolInfo[_pid];
1145         if (block.number <= pool.lastRewardTime) {
1146             return;
1147         }
1148         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1149         if (lpSupply == 0) {
1150             pool.lastRewardTime = block.number;
1151             return;
1152         }
1153         uint256 multiplier = getMultiplier(pool.lastRewardTime, block.number);
1154         uint256 summaReward = multiplier.mul(pool.allocPoint).div(totalAllocPoint);
1155         tokenIssue.transByContract(address(this), summaReward);
1156         pool.accSummaPerShare = pool.accSummaPerShare.add(summaReward.mul(1e12).div(lpSupply));
1157         pool.lastRewardTime = block.number;
1158     }
1159 
1160     // Deposit LP tokens to MasterChef for SUMMA allocation.
1161     function deposit(uint256 _pid, uint256 _amount) public {
1162 //        require(accessContract.hasRole(PUBLIC_ROLE,address(msg.sender)),"not permit");
1163         PoolInfo storage pool = poolInfo[_pid];
1164         UserInfo storage user = userInfo[_pid][msg.sender];
1165         updatePool(_pid);
1166         if (user.amount > 0) {
1167             uint256 pending = user.amount.mul(pool.accSummaPerShare).div(1e12).sub(user.rewardDebt);
1168             if (pending > 0) {
1169                 safeSummaTransfer(msg.sender, pending);
1170             }
1171         }
1172         if (_amount > 0) {
1173             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1174             user.amount = user.amount.add(_amount);
1175         }
1176         user.rewardDebt = user.amount.mul(pool.accSummaPerShare).div(1e12);
1177         emit Deposit(msg.sender, _pid, _amount);
1178     }
1179 
1180     // Withdraw LP tokens from MasterChef.
1181     function withdraw(uint256 _pid, uint256 _amount) public {
1182         PoolInfo storage pool = poolInfo[_pid];
1183         UserInfo storage user = userInfo[_pid][msg.sender];
1184         require(user.amount >= _amount, "withdraw: not good");
1185         updatePool(_pid);
1186         uint256 pending = user.amount.mul(pool.accSummaPerShare).div(1e12).sub(user.rewardDebt);
1187         if (pending > 0) {
1188             safeSummaTransfer(msg.sender, pending);
1189         }
1190         if (_amount > 0) {
1191             if(_amount < pool.lpToken.balanceOf(address(this))){
1192                 user.amount = user.amount.sub(_amount);
1193                 pool.lpToken.safeTransfer(address(msg.sender), _amount);
1194             }else{
1195                 user.amount = 0;
1196                 pool.lpToken.safeTransfer(address(msg.sender), pool.lpToken.balanceOf(address(this)));
1197             }
1198         }
1199         user.rewardDebt = user.amount.mul(pool.accSummaPerShare).div(1e12);
1200         emit Withdraw(msg.sender, _pid, _amount);
1201     }
1202 
1203     // Withdraw without caring about rewards. EMERGENCY ONLY.
1204     function emergencyWithdraw(uint256 _pid) public {
1205         PoolInfo storage pool = poolInfo[_pid];
1206         UserInfo storage user = userInfo[_pid][msg.sender];
1207         uint256 amount = user.amount;
1208         user.amount = 0;
1209         user.rewardDebt = 0;
1210         if(pool.lpToken.balanceOf(address(this)) < user.amount){
1211             amount = pool.lpToken.balanceOf(address(this));
1212         }
1213         pool.lpToken.safeTransfer(address(msg.sender), amount);
1214         emit EmergencyWithdraw(msg.sender, _pid, amount);
1215     }
1216 
1217     // Safe summa transfer function, just in case if rounding error causes pool to not have enough SUMMAs.
1218     function safeSummaTransfer(address _to, uint256 _amount) internal {
1219         uint256 summaBal = summa.balanceOf(address(this));
1220         if (_amount > summaBal) {
1221             summa.transfer(_to, summaBal);
1222         } else {
1223             summa.transfer(_to, _amount);
1224         }
1225     }
1226 }