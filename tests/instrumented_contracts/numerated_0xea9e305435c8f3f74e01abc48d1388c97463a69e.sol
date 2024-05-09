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
815 // File: @openzeppelin/contracts/access/AccessControl.sol
816 
817 
818 
819 pragma solidity >=0.6.0 <0.8.0;
820 
821 
822 
823 
824 /**
825  * @dev Contract module that allows children to implement role-based access
826  * control mechanisms.
827  *
828  * Roles are referred to by their `bytes32` identifier. These should be exposed
829  * in the external API and be unique. The best way to achieve this is by
830  * using `public constant` hash digests:
831  *
832  * ```
833  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
834  * ```
835  *
836  * Roles can be used to represent a set of permissions. To restrict access to a
837  * function call, use {hasRole}:
838  *
839  * ```
840  * function foo() public {
841  *     require(hasRole(MY_ROLE, msg.sender));
842  *     ...
843  * }
844  * ```
845  *
846  * Roles can be granted and revoked dynamically via the {grantRole} and
847  * {revokeRole} functions. Each role has an associated admin role, and only
848  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
849  *
850  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
851  * that only accounts with this role will be able to grant or revoke other
852  * roles. More complex role relationships can be created by using
853  * {_setRoleAdmin}.
854  *
855  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
856  * grant and revoke this role. Extra precautions should be taken to secure
857  * accounts that have been granted it.
858  */
859 abstract contract AccessControl is Context {
860     using EnumerableSet for EnumerableSet.AddressSet;
861     using Address for address;
862 
863     struct RoleData {
864         EnumerableSet.AddressSet members;
865         bytes32 adminRole;
866     }
867 
868     mapping (bytes32 => RoleData) private _roles;
869 
870     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
871 
872     /**
873      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
874      *
875      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
876      * {RoleAdminChanged} not being emitted signaling this.
877      *
878      * _Available since v3.1._
879      */
880     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
881 
882     /**
883      * @dev Emitted when `account` is granted `role`.
884      *
885      * `sender` is the account that originated the contract call, an admin role
886      * bearer except when using {_setupRole}.
887      */
888     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
889 
890     /**
891      * @dev Emitted when `account` is revoked `role`.
892      *
893      * `sender` is the account that originated the contract call:
894      *   - if using `revokeRole`, it is the admin role bearer
895      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
896      */
897     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
898 
899     /**
900      * @dev Returns `true` if `account` has been granted `role`.
901      */
902     function hasRole(bytes32 role, address account) public view returns (bool) {
903         return _roles[role].members.contains(account);
904     }
905 
906     /**
907      * @dev Returns the number of accounts that have `role`. Can be used
908      * together with {getRoleMember} to enumerate all bearers of a role.
909      */
910     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
911         return _roles[role].members.length();
912     }
913 
914     /**
915      * @dev Returns one of the accounts that have `role`. `index` must be a
916      * value between 0 and {getRoleMemberCount}, non-inclusive.
917      *
918      * Role bearers are not sorted in any particular way, and their ordering may
919      * change at any point.
920      *
921      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
922      * you perform all queries on the same block. See the following
923      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
924      * for more information.
925      */
926     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
927         return _roles[role].members.at(index);
928     }
929 
930     /**
931      * @dev Returns the admin role that controls `role`. See {grantRole} and
932      * {revokeRole}.
933      *
934      * To change a role's admin, use {_setRoleAdmin}.
935      */
936     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
937         return _roles[role].adminRole;
938     }
939 
940     /**
941      * @dev Grants `role` to `account`.
942      *
943      * If `account` had not been already granted `role`, emits a {RoleGranted}
944      * event.
945      *
946      * Requirements:
947      *
948      * - the caller must have ``role``'s admin role.
949      */
950     function grantRole(bytes32 role, address account) public virtual {
951         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
952 
953         _grantRole(role, account);
954     }
955 
956     /**
957      * @dev Revokes `role` from `account`.
958      *
959      * If `account` had been granted `role`, emits a {RoleRevoked} event.
960      *
961      * Requirements:
962      *
963      * - the caller must have ``role``'s admin role.
964      */
965     function revokeRole(bytes32 role, address account) public virtual {
966         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
967 
968         _revokeRole(role, account);
969     }
970 
971     /**
972      * @dev Revokes `role` from the calling account.
973      *
974      * Roles are often managed via {grantRole} and {revokeRole}: this function's
975      * purpose is to provide a mechanism for accounts to lose their privileges
976      * if they are compromised (such as when a trusted device is misplaced).
977      *
978      * If the calling account had been granted `role`, emits a {RoleRevoked}
979      * event.
980      *
981      * Requirements:
982      *
983      * - the caller must be `account`.
984      */
985     function renounceRole(bytes32 role, address account) public virtual {
986         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
987 
988         _revokeRole(role, account);
989     }
990 
991     /**
992      * @dev Grants `role` to `account`.
993      *
994      * If `account` had not been already granted `role`, emits a {RoleGranted}
995      * event. Note that unlike {grantRole}, this function doesn't perform any
996      * checks on the calling account.
997      *
998      * [WARNING]
999      * ====
1000      * This function should only be called from the constructor when setting
1001      * up the initial roles for the system.
1002      *
1003      * Using this function in any other way is effectively circumventing the admin
1004      * system imposed by {AccessControl}.
1005      * ====
1006      */
1007     function _setupRole(bytes32 role, address account) internal virtual {
1008         _grantRole(role, account);
1009     }
1010 
1011     /**
1012      * @dev Sets `adminRole` as ``role``'s admin role.
1013      *
1014      * Emits a {RoleAdminChanged} event.
1015      */
1016     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1017         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1018         _roles[role].adminRole = adminRole;
1019     }
1020 
1021     function _grantRole(bytes32 role, address account) private {
1022         if (_roles[role].members.add(account)) {
1023             emit RoleGranted(role, account, _msgSender());
1024         }
1025     }
1026 
1027     function _revokeRole(bytes32 role, address account) private {
1028         if (_roles[role].members.remove(account)) {
1029             emit RoleRevoked(role, account, _msgSender());
1030         }
1031     }
1032 }
1033 
1034 // File: @openzeppelin/contracts/access/Ownable.sol
1035 
1036 
1037 
1038 pragma solidity >=0.6.0 <0.8.0;
1039 
1040 /**
1041  * @dev Contract module which provides a basic access control mechanism, where
1042  * there is an account (an owner) that can be granted exclusive access to
1043  * specific functions.
1044  *
1045  * By default, the owner account will be the one that deploys the contract. This
1046  * can later be changed with {transferOwnership}.
1047  *
1048  * This module is used through inheritance. It will make available the modifier
1049  * `onlyOwner`, which can be applied to your functions to restrict their use to
1050  * the owner.
1051  */
1052 abstract contract Ownable is Context {
1053     address private _owner;
1054 
1055     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1056 
1057     /**
1058      * @dev Initializes the contract setting the deployer as the initial owner.
1059      */
1060     constructor () internal {
1061         address msgSender = _msgSender();
1062         _owner = msgSender;
1063         emit OwnershipTransferred(address(0), msgSender);
1064     }
1065 
1066     /**
1067      * @dev Returns the address of the current owner.
1068      */
1069     function owner() public view returns (address) {
1070         return _owner;
1071     }
1072 
1073     /**
1074      * @dev Throws if called by any account other than the owner.
1075      */
1076     modifier onlyOwner() {
1077         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1078         _;
1079     }
1080 
1081     /**
1082      * @dev Leaves the contract without owner. It will not be possible to call
1083      * `onlyOwner` functions anymore. Can only be called by the current owner.
1084      *
1085      * NOTE: Renouncing ownership will leave the contract without an owner,
1086      * thereby removing any functionality that is only available to the owner.
1087      */
1088     function renounceOwnership() public virtual onlyOwner {
1089         emit OwnershipTransferred(_owner, address(0));
1090         _owner = address(0);
1091     }
1092 
1093     /**
1094      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1095      * Can only be called by the current owner.
1096      */
1097     function transferOwnership(address newOwner) public virtual onlyOwner {
1098         require(newOwner != address(0), "Ownable: new owner is the zero address");
1099         emit OwnershipTransferred(_owner, newOwner);
1100         _owner = newOwner;
1101     }
1102 }
1103 
1104 // File: contracts/SummaMode.sol
1105 
1106 pragma solidity ^0.6.0;
1107 
1108 
1109 
1110 
1111 interface IDecimals{
1112     function decimals() external view returns (uint8);
1113 }
1114 abstract contract SummaPriContract is AccessControl {
1115 
1116     function node_count() external virtual returns (uint256);
1117 
1118     function node_switch() external virtual returns (bool);
1119 
1120     function nodeReceiveAddress() external virtual returns (address);
1121 
1122     function node_time() external virtual returns (uint256);
1123 
1124     function getRelation(address addr) external virtual returns (address);
1125 
1126     function getInvitor(address addr) external virtual returns (uint256);
1127 
1128     function addNode(address addr) external virtual returns (bool);
1129 }
1130 
1131 contract SummaMode is Ownable {
1132 
1133     using Address for address;
1134 
1135     using SafeMath for uint256;
1136 
1137     struct PlaceType {
1138         address token;
1139         // how much token for summa (10000 -> 1)
1140         uint256 price;
1141         // seconds
1142         uint256 duration;
1143         uint256 minTurnOver;
1144         uint256 placeFeeRate;
1145     }
1146 
1147     bytes32 public constant ANGEL_ROLE = keccak256("ANGEL_ROLE");
1148 
1149     bytes32 public constant INITIAL_ROLE = keccak256("INITIAL_ROLE");
1150 
1151     bytes32 public constant INVITE_ROLE = keccak256("INVITE_ROLE");
1152 
1153     bytes32 public constant NODE_ROLE = keccak256("NODE_ROLE");
1154 
1155     bytes32 public constant PUBLIC_ROLE = keccak256("PUBLIC_ROLE");
1156 
1157     address public summaPri;
1158 
1159     address public summa;
1160 
1161     mapping(address => uint256) public _priBalances;
1162 
1163     mapping(address => uint256) public _pubBalances;
1164 
1165     PlaceType public priPlaceType = PlaceType({
1166     token : address(0),
1167     price : 0.5 * 10000,
1168     duration : 60 * 24 * 225,
1169     minTurnOver : 10000,
1170     placeFeeRate : 0.2 * 1000
1171     });
1172 
1173     uint256 public pub_count = 3000;
1174     // 16M summa
1175     uint256 public pub_total_summa = 16000000;
1176 
1177     PlaceType public pubPlaceType = PlaceType({
1178     token : address(0),
1179     price : 0.75 * 10000,
1180     duration : 90 * 24 * 225,
1181     minTurnOver : 4000,
1182     placeFeeRate : 0.2 * 1000
1183     });
1184 
1185     bool public pub_switch = false;
1186 
1187     uint256 public pub_time = 0;
1188 
1189     // received pubToken amount
1190     uint256 public pubTokenAmount = 0;
1191 
1192     uint256 public minBackAmount = 50;
1193 
1194     uint256 public pubSum = 0;
1195 
1196 
1197     mapping(address => bool) private hasPri;
1198 
1199     constructor(address addrSP, address addrS) public payable {
1200         summaPri = addrSP;
1201         summa = addrS;
1202     }
1203 
1204     function priBalanceOf(address account) public view returns (uint256) {
1205         return _priBalances[account];
1206     }
1207 
1208     function pubBalanceOf(address account) public view returns (uint256) {
1209         if ((!pub_switch || block.number > pub_time.add(pubPlaceType.duration) || pub_count <= 0) && pubTokenAmount > 0) {
1210             uint256 realPrice = pubTokenAmount.div(pub_total_summa).mul(10000).div(10 ** uint256(IDecimals(pubPlaceType.token).decimals()));
1211             if (realPrice > pubPlaceType.price) {
1212                 return _pubBalances[account].mul(10 ** uint256(IDecimals(summa).decimals())).div(pubTokenAmount.div(pub_total_summa));
1213             }
1214             return _pubBalances[account].mul(10 ** uint256(IDecimals(summa).decimals())).div(pubPlaceType.price.mul(10 ** uint256(IDecimals(pubPlaceType.token).decimals())).div(10000));
1215         }
1216         return 0;
1217     }
1218 
1219     function realPrice() public view returns (uint256){
1220         if ((!pub_switch || block.number > pub_time.add(pubPlaceType.duration) || pub_count <= 0) && pubTokenAmount > 0) {
1221             return pubTokenAmount.div(pub_total_summa).mul(10000).div(10 ** uint256(IDecimals(pubPlaceType.token).decimals()));
1222         }
1223         return 0;
1224     }
1225 
1226     function updateSumma(address addr) public onlyOwner {
1227         summa = addr;
1228     }
1229 
1230     function updateSummaPri(address addr) public onlyOwner {
1231         summaPri = addr;
1232     }
1233 
1234     function updatePriToken(address addr) public onlyOwner {
1235         require(addr.isContract(), "must be contract addr");
1236         priPlaceType.token = addr;
1237     }
1238 
1239     function updatePubToken(address addr) public onlyOwner {
1240         require(addr.isContract(), "must be contract addr");
1241         pubPlaceType.token = addr;
1242     }
1243 
1244     function updatePriType(address addr, uint256 price, uint256 duration, uint256 minTurnOver, uint256 placeFeeRate) public onlyOwner {
1245         require(addr.isContract(), "must be contract addr");
1246         priPlaceType.token = addr;
1247         priPlaceType.duration = duration;
1248         priPlaceType.minTurnOver = minTurnOver;
1249         priPlaceType.price = price;
1250         priPlaceType.placeFeeRate = placeFeeRate;
1251     }
1252 
1253     function updatePubType(address addr, uint256 price, uint256 duration, uint256 minTurnOver, uint256 placeFeeRate) public onlyOwner {
1254         require(addr.isContract(), "must be contract addr");
1255         pubPlaceType.token = addr;
1256         pubPlaceType.duration = duration;
1257         pubPlaceType.minTurnOver = minTurnOver;
1258         pubPlaceType.price = price;
1259         pubPlaceType.placeFeeRate = placeFeeRate;
1260     }
1261 
1262     /*to approve token before use this func*/
1263     function privatePlacement(uint256 amount) public {
1264         require(amount > 0, "amount must be gt 0");
1265         require(IERC20(priPlaceType.token).allowance(_msgSender(), address(this)) > 0, "allowance not enough");
1266         //        require(IERC20(priPlaceType.token).balanceOf(_msgSender()) >= IERC20(priPlaceType.token).allowance(_msgSender(), address(this)), "balance not enough");
1267         bool fullNode = SummaPriContract(summaPri).getRoleMemberCount(NODE_ROLE) >= SummaPriContract(summaPri).node_count() ? true : false;
1268         uint256 actualTurnOver = priPlaceType.minTurnOver * 10 ** uint256(IDecimals(priPlaceType.token).decimals());
1269         if (!hasPri[_msgSender()] && !(Address.isContract(_msgSender())) && !fullNode && SummaPriContract(summaPri).node_switch() && block.number <= SummaPriContract(summaPri).node_time().add(priPlaceType.duration) && actualTurnOver <= amount) {
1270             if (SummaPriContract(summaPri).addNode(_msgSender())) {
1271                 _priBalances[_msgSender()] = priPlaceType.minTurnOver.mul(10000).div(priPlaceType.price).mul(10 ** uint256(IDecimals(summa).decimals()));
1272                 hasPri[_msgSender()] = true;
1273                 if (SummaPriContract(summaPri).getRoleMemberCount(NODE_ROLE) >= SummaPriContract(summaPri).node_count()) {
1274                     pub_switch = true;
1275                     pub_time = block.number;
1276                 }
1277             }
1278             SafeERC20.safeTransferFrom(IERC20(priPlaceType.token),_msgSender(), SummaPriContract(summaPri).nodeReceiveAddress(), amount);
1279         } else {
1280             if (amount >= (minBackAmount * 10 ** uint256(IDecimals(priPlaceType.token).decimals()))) {
1281                 SafeERC20.safeTransferFrom(IERC20(priPlaceType.token),_msgSender(), SummaPriContract(summaPri).nodeReceiveAddress(), amount.mul(priPlaceType.placeFeeRate).div(1000));
1282             } else {
1283                 SafeERC20.safeTransferFrom(IERC20(priPlaceType.token),_msgSender(), SummaPriContract(summaPri).nodeReceiveAddress(), amount);
1284             }
1285         }
1286     }
1287 
1288 
1289     /*to approve token before use this func*/
1290     function publicPlacement(uint256 amount) public {
1291         require(amount > 0, "amount must be gt 0");
1292         require(IERC20(pubPlaceType.token).allowance(_msgSender(), address(this)) > 0, "allowance not enough");
1293         require(IERC20(pubPlaceType.token).allowance(_msgSender(), address(this)) >= amount, "please approve allowance for this contract");
1294         require(SummaPriContract(summaPri).node_time() > 0, "not start");
1295         //        require(IERC20(pubPlaceType.token).balanceOf(_msgSender()) >= IERC20(pubPlaceType.token).allowance(_msgSender(), address(this)), "balance not enough");
1296         bool closeNode = (block.number >= SummaPriContract(summaPri).node_time().add(priPlaceType.duration) || SummaPriContract(summaPri).getRoleMemberCount(NODE_ROLE) >= SummaPriContract(summaPri).node_count()) ? true : false;
1297         if (closeNode && !pub_switch) {
1298             pub_switch = true;
1299             pub_time = block.number;
1300         }
1301         uint256 actualTurnOver = pubPlaceType.minTurnOver * 10 ** uint256(IDecimals(pubPlaceType.token).decimals());
1302         if (!(Address.isContract(_msgSender())) && closeNode && block.number <= pub_time.add(pubPlaceType.duration) && pub_switch && pub_count > 0 && actualTurnOver <= amount) {
1303             if (SummaPriContract(summaPri).hasRole(PUBLIC_ROLE, _msgSender())) {
1304                 if (_pubBalances[_msgSender()] <= 0) {
1305                     pub_count = pub_count.sub(1);
1306                     pubSum = pubSum.add(1);
1307                     if (pub_count <= 0) {
1308                         pub_switch = false;
1309                     }
1310                 }
1311                 pubTokenAmount = pubTokenAmount.add(amount);
1312                 _pubBalances[_msgSender()] = _pubBalances[_msgSender()].add(amount);
1313             }
1314             SafeERC20.safeTransferFrom(IERC20(pubPlaceType.token),_msgSender(), address(this), amount);
1315         } else {
1316             if (amount < (minBackAmount * 10 ** uint256(IDecimals(priPlaceType.token).decimals()))) {
1317                 SafeERC20.safeTransferFrom(IERC20(priPlaceType.token),_msgSender(), address(this), amount);
1318             } else {
1319                 SafeERC20.safeTransferFrom(IERC20(pubPlaceType.token),_msgSender(), address(this), amount.mul(pubPlaceType.placeFeeRate).div(1000));
1320             }
1321         }
1322     }
1323 
1324 
1325     function withdrawETH() public onlyOwner {
1326         msg.sender.transfer(address(this).balance);
1327     }
1328 
1329     function withdrawToken(address addr) public onlyOwner {
1330         SafeERC20.safeTransfer(IERC20(addr),_msgSender(), IERC20(addr).balanceOf(address(this)));
1331     }
1332 
1333     receive() external payable {
1334     }
1335 
1336 }