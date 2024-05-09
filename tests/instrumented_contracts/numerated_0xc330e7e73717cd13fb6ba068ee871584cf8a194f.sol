1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // This method relies in extcodesize, which returns 0 for contracts in
264         // construction, since the code is only stored at the end of the
265         // constructor execution.
266 
267         uint256 size;
268         // solhint-disable-next-line no-inline-assembly
269         assembly { size := extcodesize(account) }
270         return size > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
293         (bool success, ) = recipient.call{ value: amount }("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain`call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316       return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
326         return _functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
351         require(address(this).balance >= value, "Address: insufficient balance for call");
352         return _functionCallWithValue(target, data, value, errorMessage);
353     }
354 
355     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
356         require(isContract(target), "Address: call to non-contract");
357 
358         // solhint-disable-next-line avoid-low-level-calls
359         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
360         if (success) {
361             return returndata;
362         } else {
363             // Look for revert reason and bubble it up if present
364             if (returndata.length > 0) {
365                 // The easiest way to bubble the revert reason is using memory via assembly
366 
367                 // solhint-disable-next-line no-inline-assembly
368                 assembly {
369                     let returndata_size := mload(returndata)
370                     revert(add(32, returndata), returndata_size)
371                 }
372             } else {
373                 revert(errorMessage);
374             }
375         }
376     }
377 }
378 
379 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
380 
381 /**
382  * @title SafeERC20
383  * @dev Wrappers around ERC20 operations that throw on failure (when the token
384  * contract returns false). Tokens that return no value (and instead revert or
385  * throw on failure) are also supported, non-reverting calls are assumed to be
386  * successful.
387  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
388  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
389  */
390 library SafeERC20 {
391     using SafeMath for uint256;
392     using Address for address;
393 
394     function safeTransfer(IERC20 token, address to, uint256 value) internal {
395         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
396     }
397 
398     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
399         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
400     }
401 
402     /**
403      * @dev Deprecated. This function has issues similar to the ones found in
404      * {IERC20-approve}, and its usage is discouraged.
405      *
406      * Whenever possible, use {safeIncreaseAllowance} and
407      * {safeDecreaseAllowance} instead.
408      */
409     function safeApprove(IERC20 token, address spender, uint256 value) internal {
410         // safeApprove should only be called when setting an initial allowance,
411         // or when resetting it to zero. To increase and decrease it, use
412         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
413         // solhint-disable-next-line max-line-length
414         require((value == 0) || (token.allowance(address(this), spender) == 0),
415             "SafeERC20: approve from non-zero to non-zero allowance"
416         );
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
418     }
419 
420     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).add(value);
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
426         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
427         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
428     }
429 
430     /**
431      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
432      * on the return value: the return value is optional (but if data is returned, it must not be false).
433      * @param token The token targeted by the call.
434      * @param data The call data (encoded using abi.encode or one of its variants).
435      */
436     function _callOptionalReturn(IERC20 token, bytes memory data) private {
437         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
438         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
439         // the target address contains contract code and also asserts for success in the low-level call.
440 
441         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
442         if (returndata.length > 0) { // Return data is optional
443             // solhint-disable-next-line max-line-length
444             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
445         }
446     }
447 }
448 
449 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
450 
451 /**
452  * @dev Library for managing
453  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
454  * types.
455  *
456  * Sets have the following properties:
457  *
458  * - Elements are added, removed, and checked for existence in constant time
459  * (O(1)).
460  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
461  *
462  * ```
463  * contract Example {
464  *     // Add the library methods
465  *     using EnumerableSet for EnumerableSet.AddressSet;
466  *
467  *     // Declare a set state variable
468  *     EnumerableSet.AddressSet private mySet;
469  * }
470  * ```
471  *
472  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
473  * (`UintSet`) are supported.
474  */
475 library EnumerableSet {
476     // To implement this library for multiple types with as little code
477     // repetition as possible, we write it in terms of a generic Set type with
478     // bytes32 values.
479     // The Set implementation uses private functions, and user-facing
480     // implementations (such as AddressSet) are just wrappers around the
481     // underlying Set.
482     // This means that we can only create new EnumerableSets for types that fit
483     // in bytes32.
484 
485     struct Set {
486         // Storage of set values
487         bytes32[] _values;
488 
489         // Position of the value in the `values` array, plus 1 because index 0
490         // means a value is not in the set.
491         mapping (bytes32 => uint256) _indexes;
492     }
493 
494     /**
495      * @dev Add a value to a set. O(1).
496      *
497      * Returns true if the value was added to the set, that is if it was not
498      * already present.
499      */
500     function _add(Set storage set, bytes32 value) private returns (bool) {
501         if (!_contains(set, value)) {
502             set._values.push(value);
503             // The value is stored at length-1, but we add 1 to all indexes
504             // and use 0 as a sentinel value
505             set._indexes[value] = set._values.length;
506             return true;
507         } else {
508             return false;
509         }
510     }
511 
512     /**
513      * @dev Removes a value from a set. O(1).
514      *
515      * Returns true if the value was removed from the set, that is if it was
516      * present.
517      */
518     function _remove(Set storage set, bytes32 value) private returns (bool) {
519         // We read and store the value's index to prevent multiple reads from the same storage slot
520         uint256 valueIndex = set._indexes[value];
521 
522         if (valueIndex != 0) { // Equivalent to contains(set, value)
523             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
524             // the array, and then remove the last element (sometimes called as 'swap and pop').
525             // This modifies the order of the array, as noted in {at}.
526 
527             uint256 toDeleteIndex = valueIndex - 1;
528             uint256 lastIndex = set._values.length - 1;
529 
530             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
531             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
532 
533             bytes32 lastvalue = set._values[lastIndex];
534 
535             // Move the last value to the index where the value to delete is
536             set._values[toDeleteIndex] = lastvalue;
537             // Update the index for the moved value
538             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
539 
540             // Delete the slot where the moved value was stored
541             set._values.pop();
542 
543             // Delete the index for the deleted slot
544             delete set._indexes[value];
545 
546             return true;
547         } else {
548             return false;
549         }
550     }
551 
552     /**
553      * @dev Returns true if the value is in the set. O(1).
554      */
555     function _contains(Set storage set, bytes32 value) private view returns (bool) {
556         return set._indexes[value] != 0;
557     }
558 
559     /**
560      * @dev Returns the number of values on the set. O(1).
561      */
562     function _length(Set storage set) private view returns (uint256) {
563         return set._values.length;
564     }
565 
566    /**
567     * @dev Returns the value stored at position `index` in the set. O(1).
568     *
569     * Note that there are no guarantees on the ordering of values inside the
570     * array, and it may change when more values are added or removed.
571     *
572     * Requirements:
573     *
574     * - `index` must be strictly less than {length}.
575     */
576     function _at(Set storage set, uint256 index) private view returns (bytes32) {
577         require(set._values.length > index, "EnumerableSet: index out of bounds");
578         return set._values[index];
579     }
580 
581     // AddressSet
582 
583     struct AddressSet {
584         Set _inner;
585     }
586 
587     /**
588      * @dev Add a value to a set. O(1).
589      *
590      * Returns true if the value was added to the set, that is if it was not
591      * already present.
592      */
593     function add(AddressSet storage set, address value) internal returns (bool) {
594         return _add(set._inner, bytes32(uint256(value)));
595     }
596 
597     /**
598      * @dev Removes a value from a set. O(1).
599      *
600      * Returns true if the value was removed from the set, that is if it was
601      * present.
602      */
603     function remove(AddressSet storage set, address value) internal returns (bool) {
604         return _remove(set._inner, bytes32(uint256(value)));
605     }
606 
607     /**
608      * @dev Returns true if the value is in the set. O(1).
609      */
610     function contains(AddressSet storage set, address value) internal view returns (bool) {
611         return _contains(set._inner, bytes32(uint256(value)));
612     }
613 
614     /**
615      * @dev Returns the number of values in the set. O(1).
616      */
617     function length(AddressSet storage set) internal view returns (uint256) {
618         return _length(set._inner);
619     }
620 
621    /**
622     * @dev Returns the value stored at position `index` in the set. O(1).
623     *
624     * Note that there are no guarantees on the ordering of values inside the
625     * array, and it may change when more values are added or removed.
626     *
627     * Requirements:
628     *
629     * - `index` must be strictly less than {length}.
630     */
631     function at(AddressSet storage set, uint256 index) internal view returns (address) {
632         return address(uint256(_at(set._inner, index)));
633     }
634 
635 
636     // UintSet
637 
638     struct UintSet {
639         Set _inner;
640     }
641 
642     /**
643      * @dev Add a value to a set. O(1).
644      *
645      * Returns true if the value was added to the set, that is if it was not
646      * already present.
647      */
648     function add(UintSet storage set, uint256 value) internal returns (bool) {
649         return _add(set._inner, bytes32(value));
650     }
651 
652     /**
653      * @dev Removes a value from a set. O(1).
654      *
655      * Returns true if the value was removed from the set, that is if it was
656      * present.
657      */
658     function remove(UintSet storage set, uint256 value) internal returns (bool) {
659         return _remove(set._inner, bytes32(value));
660     }
661 
662     /**
663      * @dev Returns true if the value is in the set. O(1).
664      */
665     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
666         return _contains(set._inner, bytes32(value));
667     }
668 
669     /**
670      * @dev Returns the number of values on the set. O(1).
671      */
672     function length(UintSet storage set) internal view returns (uint256) {
673         return _length(set._inner);
674     }
675 
676    /**
677     * @dev Returns the value stored at position `index` in the set. O(1).
678     *
679     * Note that there are no guarantees on the ordering of values inside the
680     * array, and it may change when more values are added or removed.
681     *
682     * Requirements:
683     *
684     * - `index` must be strictly less than {length}.
685     */
686     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
687         return uint256(_at(set._inner, index));
688     }
689 }
690 
691 // File: @openzeppelin/contracts/GSN/Context.sol
692 
693 /*
694  * @dev Provides information about the current execution context, including the
695  * sender of the transaction and its data. While these are generally available
696  * via msg.sender and msg.data, they should not be accessed in such a direct
697  * manner, since when dealing with GSN meta-transactions the account sending and
698  * paying for execution may not be the actual sender (as far as an application
699  * is concerned).
700  *
701  * This contract is only required for intermediate, library-like contracts.
702  */
703 abstract contract Context {
704     function _msgSender() internal view virtual returns (address payable) {
705         return msg.sender;
706     }
707 
708     function _msgData() internal view virtual returns (bytes memory) {
709         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
710         return msg.data;
711     }
712 }
713 
714 // File: @openzeppelin/contracts/access/Ownable.sol
715 
716 /**
717  * @dev Contract module which provides a basic access control mechanism, where
718  * there is an account (an owner) that can be granted exclusive access to
719  * specific functions.
720  *
721  * By default, the owner account will be the one that deploys the contract. This
722  * can later be changed with {transferOwnership}.
723  *
724  * This module is used through inheritance. It will make available the modifier
725  * `onlyOwner`, which can be applied to your functions to restrict their use to
726  * the owner.
727  */
728 contract Ownable is Context {
729     address private _owner;
730 
731     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
732 
733     /**
734      * @dev Initializes the contract setting the deployer as the initial owner.
735      */
736     constructor () internal {
737         address msgSender = _msgSender();
738         _owner = msgSender;
739         emit OwnershipTransferred(address(0), msgSender);
740     }
741 
742     /**
743      * @dev Returns the address of the current owner.
744      */
745     function owner() public view returns (address) {
746         return _owner;
747     }
748 
749     /**
750      * @dev Throws if called by any account other than the owner.
751      */
752     modifier onlyOwner() {
753         require(_owner == _msgSender(), "Ownable: caller is not the owner");
754         _;
755     }
756 
757     /**
758      * @dev Leaves the contract without owner. It will not be possible to call
759      * `onlyOwner` functions anymore. Can only be called by the current owner.
760      *
761      * NOTE: Renouncing ownership will leave the contract without an owner,
762      * thereby removing any functionality that is only available to the owner.
763      */
764     function renounceOwnership() public virtual onlyOwner {
765         emit OwnershipTransferred(_owner, address(0));
766         _owner = address(0);
767     }
768 
769     /**
770      * @dev Transfers ownership of the contract to a new account (`newOwner`).
771      * Can only be called by the current owner.
772      */
773     function transferOwnership(address newOwner) public virtual onlyOwner {
774         require(newOwner != address(0), "Ownable: new owner is the zero address");
775         emit OwnershipTransferred(_owner, newOwner);
776         _owner = newOwner;
777     }
778 }
779 
780 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
781 
782 /**
783  * @dev Implementation of the {IERC20} interface.
784  *
785  * This implementation is agnostic to the way tokens are created. This means
786  * that a supply mechanism has to be added in a derived contract using {_mint}.
787  * For a generic mechanism see {ERC20PresetMinterPauser}.
788  *
789  * TIP: For a detailed writeup see our guide
790  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
791  * to implement supply mechanisms].
792  *
793  * We have followed general OpenZeppelin guidelines: functions revert instead
794  * of returning `false` on failure. This behavior is nonetheless conventional
795  * and does not conflict with the expectations of ERC20 applications.
796  *
797  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
798  * This allows applications to reconstruct the allowance for all accounts just
799  * by listening to said events. Other implementations of the EIP may not emit
800  * these events, as it isn't required by the specification.
801  *
802  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
803  * functions have been added to mitigate the well-known issues around setting
804  * allowances. See {IERC20-approve}.
805  */
806 contract ERC20 is Context, IERC20 {
807     using SafeMath for uint256;
808     using Address for address;
809 
810     mapping (address => uint256) private _balances;
811 
812     mapping (address => mapping (address => uint256)) private _allowances;
813 
814     uint256 private _totalSupply;
815 
816     string private _name;
817     string private _symbol;
818     uint8 private _decimals;
819 
820     /**
821      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
822      * a default value of 18.
823      *
824      * To select a different value for {decimals}, use {_setupDecimals}.
825      *
826      * All three of these values are immutable: they can only be set once during
827      * construction.
828      */
829     constructor (string memory name, string memory symbol) public {
830         _name = name;
831         _symbol = symbol;
832         _decimals = 18;
833     }
834 
835     /**
836      * @dev Returns the name of the token.
837      */
838     function name() public view returns (string memory) {
839         return _name;
840     }
841 
842     /**
843      * @dev Returns the symbol of the token, usually a shorter version of the
844      * name.
845      */
846     function symbol() public view returns (string memory) {
847         return _symbol;
848     }
849 
850     /**
851      * @dev Returns the number of decimals used to get its user representation.
852      * For example, if `decimals` equals `2`, a balance of `505` tokens should
853      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
854      *
855      * Tokens usually opt for a value of 18, imitating the relationship between
856      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
857      * called.
858      *
859      * NOTE: This information is only used for _display_ purposes: it in
860      * no way affects any of the arithmetic of the contract, including
861      * {IERC20-balanceOf} and {IERC20-transfer}.
862      */
863     function decimals() public view returns (uint8) {
864         return _decimals;
865     }
866 
867     /**
868      * @dev See {IERC20-totalSupply}.
869      */
870     function totalSupply() public view override returns (uint256) {
871         return _totalSupply;
872     }
873 
874     /**
875      * @dev See {IERC20-balanceOf}.
876      */
877     function balanceOf(address account) public view override returns (uint256) {
878         return _balances[account];
879     }
880 
881     /**
882      * @dev See {IERC20-transfer}.
883      *
884      * Requirements:
885      *
886      * - `recipient` cannot be the zero address.
887      * - the caller must have a balance of at least `amount`.
888      */
889     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
890         _transfer(_msgSender(), recipient, amount);
891         return true;
892     }
893 
894     /**
895      * @dev See {IERC20-allowance}.
896      */
897     function allowance(address owner, address spender) public view virtual override returns (uint256) {
898         return _allowances[owner][spender];
899     }
900 
901     /**
902      * @dev See {IERC20-approve}.
903      *
904      * Requirements:
905      *
906      * - `spender` cannot be the zero address.
907      */
908     function approve(address spender, uint256 amount) public virtual override returns (bool) {
909         _approve(_msgSender(), spender, amount);
910         return true;
911     }
912 
913     /**
914      * @dev See {IERC20-transferFrom}.
915      *
916      * Emits an {Approval} event indicating the updated allowance. This is not
917      * required by the EIP. See the note at the beginning of {ERC20};
918      *
919      * Requirements:
920      * - `sender` and `recipient` cannot be the zero address.
921      * - `sender` must have a balance of at least `amount`.
922      * - the caller must have allowance for ``sender``'s tokens of at least
923      * `amount`.
924      */
925     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
926         _transfer(sender, recipient, amount);
927         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
928         return true;
929     }
930 
931     /**
932      * @dev Atomically increases the allowance granted to `spender` by the caller.
933      *
934      * This is an alternative to {approve} that can be used as a mitigation for
935      * problems described in {IERC20-approve}.
936      *
937      * Emits an {Approval} event indicating the updated allowance.
938      *
939      * Requirements:
940      *
941      * - `spender` cannot be the zero address.
942      */
943     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
944         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
945         return true;
946     }
947 
948     /**
949      * @dev Atomically decreases the allowance granted to `spender` by the caller.
950      *
951      * This is an alternative to {approve} that can be used as a mitigation for
952      * problems described in {IERC20-approve}.
953      *
954      * Emits an {Approval} event indicating the updated allowance.
955      *
956      * Requirements:
957      *
958      * - `spender` cannot be the zero address.
959      * - `spender` must have allowance for the caller of at least
960      * `subtractedValue`.
961      */
962     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
963         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
964         return true;
965     }
966 
967     /**
968      * @dev Moves tokens `amount` from `sender` to `recipient`.
969      *
970      * This is internal function is equivalent to {transfer}, and can be used to
971      * e.g. implement automatic token fees, slashing mechanisms, etc.
972      *
973      * Emits a {Transfer} event.
974      *
975      * Requirements:
976      *
977      * - `sender` cannot be the zero address.
978      * - `recipient` cannot be the zero address.
979      * - `sender` must have a balance of at least `amount`.
980      */
981     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
982         require(sender != address(0), "ERC20: transfer from the zero address");
983         require(recipient != address(0), "ERC20: transfer to the zero address");
984 
985         _beforeTokenTransfer(sender, recipient, amount);
986 
987         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
988         _balances[recipient] = _balances[recipient].add(amount);
989         emit Transfer(sender, recipient, amount);
990     }
991 
992     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
993      * the total supply.
994      *
995      * Emits a {Transfer} event with `from` set to the zero address.
996      *
997      * Requirements
998      *
999      * - `to` cannot be the zero address.
1000      */
1001     function _mint(address account, uint256 amount) internal virtual {
1002         require(account != address(0), "ERC20: mint to the zero address");
1003 
1004         _beforeTokenTransfer(address(0), account, amount);
1005 
1006         _totalSupply = _totalSupply.add(amount);
1007         _balances[account] = _balances[account].add(amount);
1008         emit Transfer(address(0), account, amount);
1009     }
1010 
1011     /**
1012      * @dev Destroys `amount` tokens from `account`, reducing the
1013      * total supply.
1014      *
1015      * Emits a {Transfer} event with `to` set to the zero address.
1016      *
1017      * Requirements
1018      *
1019      * - `account` cannot be the zero address.
1020      * - `account` must have at least `amount` tokens.
1021      */
1022     function _burn(address account, uint256 amount) internal virtual {
1023         require(account != address(0), "ERC20: burn from the zero address");
1024 
1025         _beforeTokenTransfer(account, address(0), amount);
1026 
1027         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1028         _totalSupply = _totalSupply.sub(amount);
1029         emit Transfer(account, address(0), amount);
1030     }
1031 
1032     /**
1033      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1034      *
1035      * This internal function is equivalent to `approve`, and can be used to
1036      * e.g. set automatic allowances for certain subsystems, etc.
1037      *
1038      * Emits an {Approval} event.
1039      *
1040      * Requirements:
1041      *
1042      * - `owner` cannot be the zero address.
1043      * - `spender` cannot be the zero address.
1044      */
1045     function _approve(address owner, address spender, uint256 amount) internal virtual {
1046         require(owner != address(0), "ERC20: approve from the zero address");
1047         require(spender != address(0), "ERC20: approve to the zero address");
1048 
1049         _allowances[owner][spender] = amount;
1050         emit Approval(owner, spender, amount);
1051     }
1052 
1053     /**
1054      * @dev Sets {decimals} to a value other than the default one of 18.
1055      *
1056      * WARNING: This function should only be called from the constructor. Most
1057      * applications that interact with token contracts will not expect
1058      * {decimals} to ever change, and may work incorrectly if it does.
1059      */
1060     function _setupDecimals(uint8 decimals_) internal {
1061         _decimals = decimals_;
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any transfer of tokens. This includes
1066      * minting and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1071      * will be to transferred to `to`.
1072      * - when `from` is zero, `amount` tokens will be minted for `to`.
1073      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1074      * - `from` and `to` are never both zero.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1079 }
1080 
1081 // File: contracts/YaxisToken.sol
1082 
1083 // yAxis (YAX) with Governance Alpha
1084 contract YaxisToken is ERC20 {
1085     using SafeERC20 for IERC20;
1086     using SafeMath for uint256;
1087 
1088     address public governance;
1089     uint256 public cap;
1090     mapping(address => bool) public minters;
1091 
1092     constructor (uint256 _cap) public ERC20("yAxis", "YAX") {
1093         governance = msg.sender;
1094         cap = _cap;
1095     }
1096 
1097     function mint(address _to, uint256 _amount) public {
1098         require(msg.sender == governance || minters[msg.sender], "!governance && !minter");
1099         _mint(_to, _amount);
1100         _moveDelegates(address(0), _delegates[_to], _amount);
1101     }
1102 
1103     function burn(uint256 _amount) public {
1104         _burn(msg.sender, _amount);
1105         _moveDelegates(_delegates[msg.sender], address(0), _amount);
1106     }
1107 
1108     function burnFrom(address _account, uint256 _amount) public {
1109         uint256 decreasedAllowance = allowance(_account, msg.sender).sub(_amount, "ERC20: burn amount exceeds allowance");
1110         _approve(_account, msg.sender, decreasedAllowance);
1111         _burn(_account, _amount);
1112         _moveDelegates(_delegates[_account], address(0), _amount);
1113     }
1114 
1115     function setGovernance(address _governance) public {
1116         require(msg.sender == governance, "!governance");
1117         governance = _governance;
1118     }
1119 
1120     function addMinter(address _minter) public {
1121         require(msg.sender == governance, "!governance");
1122         minters[_minter] = true;
1123     }
1124 
1125     function removeMinter(address _minter) public {
1126         require(msg.sender == governance, "!governance");
1127         minters[_minter] = false;
1128     }
1129 
1130     function setCap(uint256 _cap) public {
1131         require(msg.sender == governance, "!governance");
1132         require(_cap >= totalSupply(), "_cap is below current total supply");
1133         cap = _cap;
1134     }
1135 
1136     // This function allows governance to take unsupported tokens out of the contract.
1137     // This is in an effort to make someone whole, should they seriously mess up.
1138     // There is no guarantee governance will vote to return these.
1139     // It also allows for removal of airdropped tokens.
1140     function governanceRecoverUnsupported(IERC20 _token, address _to, uint256 _amount) external {
1141         require(msg.sender == governance, "!governance");
1142         _token.safeTransfer(_to, _amount);
1143     }
1144 
1145     /**
1146      * @dev See {ERC20-_beforeTokenTransfer}.
1147      *
1148      * Requirements:
1149      *
1150      * - minted tokens must not cause the total supply to go over the cap.
1151      */
1152     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1153         super._beforeTokenTransfer(from, to, amount);
1154 
1155         if (from == address(0)) {// When minting tokens
1156             require(totalSupply().add(amount) <= cap, "ERC20Capped: cap exceeded");
1157         }
1158     }
1159 
1160     // Copied and modified from YAM code:
1161     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1162     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1163     // Which is copied and modified from COMPOUND:
1164     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1165 
1166     /// @dev A record of each accounts delegate
1167     mapping(address => address) internal _delegates;
1168 
1169     /// @notice A checkpoint for marking number of votes from a given block
1170     struct Checkpoint {
1171         uint32 fromBlock;
1172         uint256 votes;
1173     }
1174 
1175     /// @notice A record of votes checkpoints for each account, by index
1176     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1177 
1178     /// @notice The number of checkpoints for each account
1179     mapping(address => uint32) public numCheckpoints;
1180 
1181     /// @notice The EIP-712 typehash for the contract's domain
1182     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1183 
1184     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1185     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1186 
1187     /// @dev A record of states for signing / validating signatures
1188     mapping(address => uint) public nonces;
1189 
1190     /// @notice An event thats emitted when an account changes its delegate
1191     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1192 
1193     /// @notice An event thats emitted when a delegate account's vote balance changes
1194     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1195 
1196     /**
1197      * @notice Delegate votes from `msg.sender` to `delegatee`
1198      * @param delegator The address to get delegatee for
1199      */
1200     function delegates(address delegator)
1201         external
1202         view
1203         returns (address)
1204     {
1205         return _delegates[delegator];
1206     }
1207 
1208     /**
1209      * @notice Delegate votes from `msg.sender` to `delegatee`
1210      * @param delegatee The address to delegate votes to
1211      */
1212     function delegate(address delegatee) external {
1213         return _delegate(msg.sender, delegatee);
1214     }
1215 
1216     /**
1217      * @notice Delegates votes from signatory to `delegatee`
1218      * @param delegatee The address to delegate votes to
1219      * @param nonce The contract state required to match the signature
1220      * @param expiry The time at which to expire the signature
1221      * @param v The recovery byte of the signature
1222      * @param r Half of the ECDSA signature pair
1223      * @param s Half of the ECDSA signature pair
1224      */
1225     function delegateBySig(
1226         address delegatee,
1227         uint nonce,
1228         uint expiry,
1229         uint8 v,
1230         bytes32 r,
1231         bytes32 s
1232     )
1233         external
1234     {
1235         bytes32 domainSeparator = keccak256(
1236             abi.encode(
1237                 DOMAIN_TYPEHASH,
1238                 keccak256(bytes(name())),
1239                 getChainId(),
1240                 address(this)
1241             )
1242         );
1243 
1244         bytes32 structHash = keccak256(
1245             abi.encode(
1246                 DELEGATION_TYPEHASH,
1247                 delegatee,
1248                 nonce,
1249                 expiry
1250             )
1251         );
1252 
1253         bytes32 digest = keccak256(
1254             abi.encodePacked(
1255                 "\x19\x01",
1256                 domainSeparator,
1257                 structHash
1258             )
1259         );
1260         address signatory = ecrecover(digest, v, r, s);
1261         require(signatory != address(0), "YAX::delegateBySig: invalid signature");
1262         require(nonce == nonces[signatory]++, "YAX::delegateBySig: invalid nonce");
1263         require(now <= expiry, "YAX::delegateBySig: signature expired");
1264         return _delegate(signatory, delegatee);
1265     }
1266 
1267     /**
1268      * @notice Gets the current votes balance for `account`
1269      * @param account The address to get votes balance
1270      * @return The number of current votes for `account`
1271      */
1272     function getCurrentVotes(address account)
1273         external
1274         view
1275         returns (uint256)
1276     {
1277         uint32 nCheckpoints = numCheckpoints[account];
1278         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1279     }
1280 
1281     /**
1282      * @notice Determine the prior number of votes for an account as of a block number
1283      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1284      * @param account The address of the account to check
1285      * @param blockNumber The block number to get the vote balance at
1286      * @return The number of votes the account had as of the given block
1287      */
1288     function getPriorVotes(address account, uint blockNumber)
1289         external
1290         view
1291         returns (uint256)
1292     {
1293         require(blockNumber < block.number, "YAX::getPriorVotes: not yet determined");
1294 
1295         uint32 nCheckpoints = numCheckpoints[account];
1296         if (nCheckpoints == 0) {
1297             return 0;
1298         }
1299 
1300         // First check most recent balance
1301         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1302             return checkpoints[account][nCheckpoints - 1].votes;
1303         }
1304 
1305         // Next check implicit zero balance
1306         if (checkpoints[account][0].fromBlock > blockNumber) {
1307             return 0;
1308         }
1309 
1310         uint32 lower = 0;
1311         uint32 upper = nCheckpoints - 1;
1312         while (upper > lower) {
1313             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1314             Checkpoint memory cp = checkpoints[account][center];
1315             if (cp.fromBlock == blockNumber) {
1316                 return cp.votes;
1317             } else if (cp.fromBlock < blockNumber) {
1318                 lower = center;
1319             } else {
1320                 upper = center - 1;
1321             }
1322         }
1323         return checkpoints[account][lower].votes;
1324     }
1325 
1326     function _delegate(address delegator, address delegatee)
1327         internal
1328     {
1329         address currentDelegate = _delegates[delegator];
1330         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying YAXs (not scaled);
1331         _delegates[delegator] = delegatee;
1332 
1333         emit DelegateChanged(delegator, currentDelegate, delegatee);
1334 
1335         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1336     }
1337 
1338     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1339         if (srcRep != dstRep && amount > 0) {
1340             if (srcRep != address(0)) {
1341                 // decrease old representative
1342                 uint32 srcRepNum = numCheckpoints[srcRep];
1343                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1344                 uint256 srcRepNew = srcRepOld.sub(amount);
1345                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1346             }
1347 
1348             if (dstRep != address(0)) {
1349                 // increase new representative
1350                 uint32 dstRepNum = numCheckpoints[dstRep];
1351                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1352                 uint256 dstRepNew = dstRepOld.add(amount);
1353                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1354             }
1355         }
1356     }
1357 
1358     function _writeCheckpoint(
1359         address delegatee,
1360         uint32 nCheckpoints,
1361         uint256 oldVotes,
1362         uint256 newVotes
1363     )
1364         internal
1365     {
1366         uint32 blockNumber = safe32(block.number, "YAX::_writeCheckpoint: block number exceeds 32 bits");
1367 
1368         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1369             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1370         } else {
1371             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1372             numCheckpoints[delegatee] = nCheckpoints + 1;
1373         }
1374 
1375         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1376     }
1377 
1378     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1379         require(n < 2 ** 32, errorMessage);
1380         return uint32(n);
1381     }
1382 
1383     function getChainId() internal pure returns (uint) {
1384         uint256 chainId;
1385         assembly {chainId := chainid()}
1386         return chainId;
1387     }
1388 }
1389 
1390 // File: contracts/YaxisChef.sol
1391 
1392 interface IMigratorChef {
1393     // Perform LP token migration from legacy UniswapV2 to yAxis.
1394     // Take the current LP token address and return the new LP token address.
1395     // Migrator should have full access to the caller's LP token.
1396     // Return the new LP token address.
1397     //
1398     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1399     // yAxis must mint EXACTLY the same amount of yAxis LP tokens or
1400     // else something bad will happen. Traditional UniswapV2 does not
1401     // do that so be careful!
1402     function migrate(IERC20 token) external returns (IERC20);
1403 }
1404 
1405 // YaxisChef is the master of yAxis. He can make yAxis and he is a fair guy.
1406 //
1407 // Note that it's ownable and the owner wields tremendous power. The ownership
1408 // will be transferred to a governance smart contract once YAX is sufficiently
1409 // distributed and the community can show to govern itself.
1410 //
1411 // Have fun reading it. Hopefully it's bug-free. God bless.
1412 contract YaxisChef is Ownable {
1413     using SafeMath for uint256;
1414     using SafeERC20 for IERC20;
1415 
1416     // Info of each user.
1417     struct UserInfo {
1418         uint256 amount;     // How many LP tokens the user has provided.
1419         uint256 rewardDebt; // Reward debt. See explanation below.
1420         //
1421         // We do some fancy math here. Basically, any point in time, the amount of YAXs
1422         // entitled to a user but is pending to be distributed is:
1423         //
1424         //   pending reward = (user.amount * pool.accYaxPerShare) - user.rewardDebt
1425         //
1426         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1427         //   1. The pool's `accYaxPerShare` (and `lastRewardBlock`) gets updated.
1428         //   2. User receives the pending reward sent to his/her address.
1429         //   3. User's `amount` gets updated.
1430         //   4. User's `rewardDebt` gets updated.
1431         uint256 accumulatedStakingPower; // will accumulate every time user harvest
1432     }
1433 
1434     // Info of each pool.
1435     struct PoolInfo {
1436         IERC20 lpToken;           // Address of LP token contract.
1437         uint256 allocPoint;       // How many allocation points assigned to this pool. YAXs to distribute per block.
1438         uint256 lastRewardBlock;  // Last block number that YAXs distribution occurs.
1439         uint256 accYaxPerShare; // Accumulated YAXs per share, times 1e12. See below.
1440         bool isStarted; // if lastRewardBlock has passed
1441     }
1442 
1443     // The YAX TOKEN!
1444     YaxisToken public yax;
1445     // Tresury address.
1446     address public tresuryaddr;
1447     // YAX tokens created per block.
1448     uint256 public yaxPerBlock;
1449     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1450     IMigratorChef public migrator;
1451 
1452     // Info of each pool.
1453     PoolInfo[] public poolInfo;
1454     // Info of each user that stakes LP tokens.
1455     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1456     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1457     uint256 public totalAllocPoint = 0;
1458     // The block number when YAX mining starts.
1459     uint256 public startBlock;
1460     // Block number when each epoch ends.
1461     uint256[4] public epochEndBlocks;
1462 
1463     // Reward multipler for each of 4 epoches (epochIndex: reward multipler)
1464     uint256[5] public epochRewardMultiplers = [3840, 2880, 1920, 960, 1];
1465 
1466     uint256 public constant BLOCKS_PER_WEEK = 46500;
1467 
1468     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1469     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1470     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1471 
1472     constructor(
1473         YaxisToken _yax,
1474         address _tresuryaddr,
1475         uint256 _yaxPerBlock,
1476         uint256 _startBlock
1477     ) public {
1478         yax = _yax;
1479         tresuryaddr = _tresuryaddr;
1480         yaxPerBlock = _yaxPerBlock; // supposed to be 0.001 (1e16 wei)
1481         startBlock = _startBlock; // supposed to be 10,883,800 (Fri Sep 18 2020 3:00:00 GMT+0)
1482         epochEndBlocks[0] = startBlock + BLOCKS_PER_WEEK * 2; // weeks 1-2
1483         epochEndBlocks[1] = epochEndBlocks[0] + BLOCKS_PER_WEEK * 2; // weeks 3-4
1484         epochEndBlocks[2] = epochEndBlocks[1] + BLOCKS_PER_WEEK * 2; // weeks 5-6
1485         epochEndBlocks[3] = epochEndBlocks[2] + BLOCKS_PER_WEEK * 2; // weeks 7-8
1486     }
1487 
1488     function poolLength() external view returns (uint256) {
1489         return poolInfo.length;
1490     }
1491 
1492     function setYaxPerBlock(uint256 _yaxPerBlock) public onlyOwner {
1493         massUpdatePools();
1494         yaxPerBlock = _yaxPerBlock;
1495     }
1496 
1497     function setEpochEndBlock(uint8 _index, uint256 _epochEndBlock) public onlyOwner {
1498         require(_index < 4, "_index out of range");
1499         require(_epochEndBlock > block.number, "Too late to update");
1500         require(epochEndBlocks[_index] > block.number, "Too late to update");
1501         epochEndBlocks[_index] = _epochEndBlock;
1502     }
1503 
1504     function setEpochRewardMultipler(uint8 _index, uint256 _epochRewardMultipler) public onlyOwner {
1505         require(_index > 0 && _index < 5, "Index out of range");
1506         require(epochEndBlocks[_index - 1] > block.number, "Too late to update");
1507         epochRewardMultiplers[_index] = _epochRewardMultipler;
1508     }
1509 
1510     // Add a new lp to the pool. Can only be called by the owner.
1511     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1512     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, uint256 _lastRewardBlock) public onlyOwner {
1513         if (_withUpdate) {
1514             massUpdatePools();
1515         }
1516         if (block.number < startBlock) {
1517             // chef is sleeping
1518             if (_lastRewardBlock == 0) {
1519                 _lastRewardBlock = startBlock;
1520             } else {
1521                 if (_lastRewardBlock < startBlock) {
1522                     _lastRewardBlock = startBlock;
1523                 }
1524             }
1525         } else {
1526             // chef is cooking
1527             if (_lastRewardBlock == 0 || _lastRewardBlock < block.number) {
1528                 _lastRewardBlock = block.number;
1529             }
1530         }
1531         bool _isStarted = (_lastRewardBlock <= startBlock) || (_lastRewardBlock <= block.number);
1532         poolInfo.push(PoolInfo({
1533             lpToken: _lpToken,
1534             allocPoint: _allocPoint,
1535             lastRewardBlock: _lastRewardBlock,
1536             accYaxPerShare: 0,
1537             isStarted: _isStarted
1538         }));
1539         if (_isStarted) {
1540             totalAllocPoint = totalAllocPoint.add(_allocPoint);
1541         }
1542     }
1543 
1544     // Update the given pool's YAX allocation point. Can only be called by the owner.
1545     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1546         if (_withUpdate) {
1547             massUpdatePools();
1548         }
1549         PoolInfo storage pool = poolInfo[_pid];
1550         if (pool.isStarted) {
1551             totalAllocPoint = totalAllocPoint.sub(pool.allocPoint).add(_allocPoint);
1552         }
1553         pool.allocPoint = _allocPoint;
1554     }
1555 
1556     // Set the migrator contract. Can only be called by the owner.
1557     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1558         migrator = _migrator;
1559     }
1560 
1561     // Migrate lp token to another lp contract.
1562     function migrate(uint256 _pid) public onlyOwner {
1563         require(address(migrator) != address(0), "migrate: no migrator");
1564         PoolInfo storage pool = poolInfo[_pid];
1565         IERC20 lpToken = pool.lpToken;
1566         uint256 bal = lpToken.balanceOf(address(this));
1567         lpToken.safeApprove(address(migrator), bal);
1568         IERC20 newLpToken = migrator.migrate(lpToken);
1569         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1570         pool.lpToken = newLpToken;
1571     }
1572 
1573     // Return reward multiplier over the given _from to _to block.
1574     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1575         for (uint8 epochId = 4; epochId >= 1; --epochId) {
1576             if (_to >= epochEndBlocks[epochId - 1]) {
1577                 if (_from >= epochEndBlocks[epochId - 1]) return _to.sub(_from).mul(epochRewardMultiplers[epochId]);
1578                 uint256 multiplier = _to.sub(epochEndBlocks[epochId - 1]).mul(epochRewardMultiplers[epochId]);
1579                 if (epochId == 1) return multiplier.add(epochEndBlocks[0].sub(_from).mul(epochRewardMultiplers[0]));
1580                 for (epochId = epochId - 1; epochId >= 1; --epochId) {
1581                     if (_from >= epochEndBlocks[epochId - 1]) return multiplier.add(epochEndBlocks[epochId].sub(_from).mul(epochRewardMultiplers[epochId]));
1582                     multiplier = multiplier.add(epochEndBlocks[epochId].sub(epochEndBlocks[epochId - 1]).mul(epochRewardMultiplers[epochId]));
1583                 }
1584                 return multiplier.add(epochEndBlocks[0].sub(_from).mul(epochRewardMultiplers[0]));
1585             }
1586         }
1587         return _to.sub(_from).mul(epochRewardMultiplers[0]);
1588     }
1589 
1590     // View function to see pending YAXs on frontend.
1591     function pendingYaxis(uint256 _pid, address _user) external view returns (uint256) {
1592         PoolInfo storage pool = poolInfo[_pid];
1593         UserInfo storage user = userInfo[_pid][_user];
1594         uint256 accYaxPerShare = pool.accYaxPerShare;
1595         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1596         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1597             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1598             if (totalAllocPoint > 0) {
1599                 uint256 yaxReward = multiplier.mul(yaxPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1600                 accYaxPerShare = accYaxPerShare.add(yaxReward.mul(1e12).div(lpSupply));
1601             }
1602         }
1603         return user.amount.mul(accYaxPerShare).div(1e12).sub(user.rewardDebt);
1604     }
1605 
1606     // Update reward variables for all pools. Be careful of gas spending!
1607     function massUpdatePools() public {
1608         uint256 length = poolInfo.length;
1609         for (uint256 pid = 0; pid < length; ++pid) {
1610             updatePool(pid);
1611         }
1612     }
1613 
1614     // Update reward variables of the given pool to be up-to-date.
1615     function updatePool(uint256 _pid) public {
1616         PoolInfo storage pool = poolInfo[_pid];
1617         if (block.number <= pool.lastRewardBlock) {
1618             return;
1619         }
1620         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1621         if (lpSupply == 0) {
1622             pool.lastRewardBlock = block.number;
1623             return;
1624         }
1625         if (!pool.isStarted) {
1626             pool.isStarted = true;
1627             totalAllocPoint = totalAllocPoint.add(pool.allocPoint);
1628         }
1629         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1630         if (totalAllocPoint > 0) {
1631             uint256 yaxReward = multiplier.mul(yaxPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1632             safeYaxMint(tresuryaddr, yaxReward.div(9));
1633             safeYaxMint(address(this), yaxReward);
1634             pool.accYaxPerShare = pool.accYaxPerShare.add(yaxReward.mul(1e12).div(lpSupply));
1635         }
1636         pool.lastRewardBlock = block.number;
1637     }
1638 
1639     // Deposit LP tokens to YaxisChef for YAX allocation.
1640     function deposit(uint256 _pid, uint256 _amount) public {
1641         PoolInfo storage pool = poolInfo[_pid];
1642         UserInfo storage user = userInfo[_pid][msg.sender];
1643         updatePool(_pid);
1644         if (user.amount > 0) {
1645             uint256 pending = user.amount.mul(pool.accYaxPerShare).div(1e12).sub(user.rewardDebt);
1646             if(pending > 0) {
1647                 user.accumulatedStakingPower = user.accumulatedStakingPower.add(pending);
1648                 safeYaxTransfer(msg.sender, pending);
1649             }
1650         }
1651         if(_amount > 0) {
1652             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1653             user.amount = user.amount.add(_amount);
1654         }
1655         user.rewardDebt = user.amount.mul(pool.accYaxPerShare).div(1e12);
1656         emit Deposit(msg.sender, _pid, _amount);
1657     }
1658 
1659     // Withdraw LP tokens from YaxisChef.
1660     function withdraw(uint256 _pid, uint256 _amount) public {
1661         PoolInfo storage pool = poolInfo[_pid];
1662         UserInfo storage user = userInfo[_pid][msg.sender];
1663         require(user.amount >= _amount, "withdraw: not good");
1664         updatePool(_pid);
1665         uint256 pending = user.amount.mul(pool.accYaxPerShare).div(1e12).sub(user.rewardDebt);
1666         if(pending > 0) {
1667             user.accumulatedStakingPower = user.accumulatedStakingPower.add(pending);
1668             safeYaxTransfer(msg.sender, pending);
1669         }
1670         if(_amount > 0) {
1671             user.amount = user.amount.sub(_amount);
1672             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1673         }
1674         user.rewardDebt = user.amount.mul(pool.accYaxPerShare).div(1e12);
1675         emit Withdraw(msg.sender, _pid, _amount);
1676     }
1677 
1678     // Withdraw without caring about rewards. EMERGENCY ONLY.
1679     function emergencyWithdraw(uint256 _pid) public {
1680         PoolInfo storage pool = poolInfo[_pid];
1681         UserInfo storage user = userInfo[_pid][msg.sender];
1682         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1683         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1684         user.amount = 0;
1685         user.rewardDebt = 0;
1686     }
1687 
1688     // Safe yax mint, ensure it is never over cap and we are the current owner.
1689     function safeYaxMint(address _to, uint256 _amount) internal {
1690         if (yax.minters(address(this)) && _to != address(0)) {
1691             uint256 totalSupply = yax.totalSupply();
1692             uint256 cap = yax.cap();
1693             if (totalSupply.add(_amount) > cap) {
1694                 yax.mint(_to, cap.sub(totalSupply));
1695             } else {
1696                 yax.mint(_to, _amount);
1697             }
1698         }
1699     }
1700 
1701     // Safe yax transfer function, just in case if rounding error causes pool to not have enough YAXs.
1702     function safeYaxTransfer(address _to, uint256 _amount) internal {
1703         uint256 yaxBal = yax.balanceOf(address(this));
1704         if (_amount > yaxBal) {
1705             yax.transfer(_to, yaxBal);
1706         } else {
1707             yax.transfer(_to, _amount);
1708         }
1709     }
1710 
1711     // Update tresury by the previous tresury contract.
1712     function tresury(address _tresuryaddr) public {
1713         require(msg.sender == tresuryaddr, "tresury: wut?");
1714         tresuryaddr = _tresuryaddr;
1715     }
1716 
1717     // This function allows governance to take unsupported tokens out of the contract, since this pool exists longer than the other pools.
1718     // This is in an effort to make someone whole, should they seriously mess up.
1719     // There is no guarantee governance will vote to return these.
1720     // It also allows for removal of airdropped tokens.
1721     function governanceRecoverUnsupported(IERC20 _token, uint256 amount, address to) external onlyOwner {
1722         uint256 length = poolInfo.length;
1723         for (uint256 pid = 0; pid < length; ++pid) {
1724             PoolInfo storage pool = poolInfo[pid];
1725             // cant take staked asset
1726             require(_token != pool.lpToken, "!pool.lpToken");
1727         }
1728         // transfer to
1729         _token.safeTransfer(to, amount);
1730     }
1731 }