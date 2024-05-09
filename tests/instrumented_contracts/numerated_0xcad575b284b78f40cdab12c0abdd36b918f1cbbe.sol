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
1081 // File: contracts/SusafeToken.sol
1082 
1083 abstract contract ERC20Capped is ERC20 {
1084     uint256 private _cap;
1085 
1086     /**
1087      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1088      * set once during construction.
1089      */
1090     constructor (string memory name, string memory symbol, uint256 cap) ERC20(name, symbol) public {
1091         require(cap > 0, "ERC20Capped: cap is 0");
1092         _cap = cap;
1093     }
1094 
1095     /**
1096      * @dev Returns the cap on the token's total supply.
1097      */
1098     function cap() public view returns (uint256) {
1099         return _cap;
1100     }
1101 
1102     /**
1103      * @dev See {ERC20-_beforeTokenTransfer}.
1104      *
1105      * Requirements:
1106      *
1107      * - minted tokens must not cause the total supply to go over the cap.
1108      */
1109     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1110         super._beforeTokenTransfer(from, to, amount);
1111 
1112         if (from == address(0)) { // When minting tokens
1113             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1114         }
1115     }
1116 }
1117 
1118 /**
1119   * @notice SusafeToken with Governance.
1120   */
1121 contract SusafeToken is ERC20Capped("SusafeToken", "SUSAFE", 210000 ether), Ownable {
1122     address public dev = address(0);
1123 
1124     function setDev(address _dev) public onlyOwner {
1125         require(dev == address(0) && _dev != address(0), "DevFund contract can be set once only (to avoid of rug-pull)");
1126         dev = _dev;
1127     }
1128 
1129     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (SusafeChef).
1130     function mint(address _to, uint256 _amount) public {
1131         require(owner() == msg.sender || dev == msg.sender, "Ownable: caller is not the owner nor dev fund contract");
1132         _mint(_to, _amount);
1133         _moveDelegates(address(0), _delegates[_to], _amount);
1134     }
1135 
1136     /**
1137      * support to burn SUSAFE
1138      */
1139     function burn(uint256 _amount) public {
1140         _burn(msg.sender, _amount);
1141         _moveDelegates(_delegates[msg.sender], address(0), _amount);
1142     }
1143 
1144     /**
1145      * See {ERC20-_burn} and {ERC20-allowance}.
1146      */
1147     function burnFrom(address _account, uint256 _amount) public virtual {
1148         uint256 decreasedAllowance = allowance(_account, msg.sender).sub(_amount, "ERC20: burn amount exceeds allowance");
1149         _approve(_account, msg.sender, decreasedAllowance);
1150         _burn(_account, _amount);
1151         _moveDelegates(_delegates[_account], address(0), _amount);
1152     }
1153 
1154     // Copied and modified from YAM code:
1155     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1156     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1157     // Which is copied and modified from COMPOUND:
1158     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1159 
1160     /// @dev A record of each accounts delegate
1161     mapping (address => address) internal _delegates;
1162 
1163     /// @notice A checkpoint for marking number of votes from a given block
1164     struct Checkpoint {
1165         uint32 fromBlock;
1166         uint256 votes;
1167     }
1168 
1169     /// @notice A record of votes checkpoints for each account, by index
1170     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1171 
1172     /// @notice The number of checkpoints for each account
1173     mapping (address => uint32) public numCheckpoints;
1174 
1175     /// @notice The EIP-712 typehash for the contract's domain
1176     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1177 
1178     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1179     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1180 
1181     /// @notice A record of states for signing / validating signatures
1182     mapping (address => uint) public nonces;
1183 
1184       /// @notice An event thats emitted when an account changes its delegate
1185     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1186 
1187     /// @notice An event thats emitted when a delegate account's vote balance changes
1188     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1189 
1190     /**
1191      * @notice Delegate votes from `msg.sender` to `delegatee`
1192      * @param delegator The address to get delegatee for
1193      */
1194     function delegates(address delegator)
1195         external
1196         view
1197         returns (address)
1198     {
1199         return _delegates[delegator];
1200     }
1201 
1202    /**
1203     * @notice Delegate votes from `msg.sender` to `delegatee`
1204     * @param delegatee The address to delegate votes to
1205     */
1206     function delegate(address delegatee) external {
1207         return _delegate(msg.sender, delegatee);
1208     }
1209 
1210     /**
1211      * @notice Delegates votes from signatory to `delegatee`
1212      * @param delegatee The address to delegate votes to
1213      * @param nonce The contract state required to match the signature
1214      * @param expiry The time at which to expire the signature
1215      * @param v The recovery byte of the signature
1216      * @param r Half of the ECDSA signature pair
1217      * @param s Half of the ECDSA signature pair
1218      */
1219     function delegateBySig(
1220         address delegatee,
1221         uint nonce,
1222         uint expiry,
1223         uint8 v,
1224         bytes32 r,
1225         bytes32 s
1226     )
1227         external
1228     {
1229         bytes32 domainSeparator = keccak256(
1230             abi.encode(
1231                 DOMAIN_TYPEHASH,
1232                 keccak256(bytes(name())),
1233                 getChainId(),
1234                 address(this)
1235             )
1236         );
1237 
1238         bytes32 structHash = keccak256(
1239             abi.encode(
1240                 DELEGATION_TYPEHASH,
1241                 delegatee,
1242                 nonce,
1243                 expiry
1244             )
1245         );
1246 
1247         bytes32 digest = keccak256(
1248             abi.encodePacked(
1249                 "\x19\x01",
1250                 domainSeparator,
1251                 structHash
1252             )
1253         );
1254 
1255         address signatory = ecrecover(digest, v, r, s);
1256         require(signatory != address(0), "SUSAFE::delegateBySig: invalid signature");
1257         require(nonce == nonces[signatory]++, "SUSAFE::delegateBySig: invalid nonce");
1258         require(now <= expiry, "SUSAFE::delegateBySig: signature expired");
1259         return _delegate(signatory, delegatee);
1260     }
1261 
1262     /**
1263      * @notice Gets the current votes balance for `account`
1264      * @param account The address to get votes balance
1265      * @return The number of current votes for `account`
1266      */
1267     function getCurrentVotes(address account)
1268         external
1269         view
1270         returns (uint256)
1271     {
1272         uint32 nCheckpoints = numCheckpoints[account];
1273         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1274     }
1275 
1276     /**
1277      * @notice Determine the prior number of votes for an account as of a block number
1278      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1279      * @param account The address of the account to check
1280      * @param blockNumber The block number to get the vote balance at
1281      * @return The number of votes the account had as of the given block
1282      */
1283     function getPriorVotes(address account, uint blockNumber)
1284         external
1285         view
1286         returns (uint256)
1287     {
1288         require(blockNumber < block.number, "SUSAFE::getPriorVotes: not yet determined");
1289 
1290         uint32 nCheckpoints = numCheckpoints[account];
1291         if (nCheckpoints == 0) {
1292             return 0;
1293         }
1294 
1295         // First check most recent balance
1296         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1297             return checkpoints[account][nCheckpoints - 1].votes;
1298         }
1299 
1300         // Next check implicit zero balance
1301         if (checkpoints[account][0].fromBlock > blockNumber) {
1302             return 0;
1303         }
1304 
1305         uint32 lower = 0;
1306         uint32 upper = nCheckpoints - 1;
1307         while (upper > lower) {
1308             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1309             Checkpoint memory cp = checkpoints[account][center];
1310             if (cp.fromBlock == blockNumber) {
1311                 return cp.votes;
1312             } else if (cp.fromBlock < blockNumber) {
1313                 lower = center;
1314             } else {
1315                 upper = center - 1;
1316             }
1317         }
1318         return checkpoints[account][lower].votes;
1319     }
1320 
1321     function _delegate(address delegator, address delegatee)
1322         internal
1323     {
1324         address currentDelegate = _delegates[delegator];
1325         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SUSAFEs (not scaled);
1326         _delegates[delegator] = delegatee;
1327 
1328         emit DelegateChanged(delegator, currentDelegate, delegatee);
1329 
1330         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1331     }
1332 
1333     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1334         if (srcRep != dstRep && amount > 0) {
1335             if (srcRep != address(0)) {
1336                 // decrease old representative
1337                 uint32 srcRepNum = numCheckpoints[srcRep];
1338                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1339                 uint256 srcRepNew = srcRepOld.sub(amount);
1340                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1341             }
1342 
1343             if (dstRep != address(0)) {
1344                 // increase new representative
1345                 uint32 dstRepNum = numCheckpoints[dstRep];
1346                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1347                 uint256 dstRepNew = dstRepOld.add(amount);
1348                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1349             }
1350         }
1351     }
1352 
1353     function _writeCheckpoint(
1354         address delegatee,
1355         uint32 nCheckpoints,
1356         uint256 oldVotes,
1357         uint256 newVotes
1358     )
1359         internal
1360     {
1361         uint32 blockNumber = safe32(block.number, "SUSAFE::_writeCheckpoint: block number exceeds 32 bits");
1362 
1363         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1364             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1365         } else {
1366             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1367             numCheckpoints[delegatee] = nCheckpoints + 1;
1368         }
1369 
1370         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1371     }
1372 
1373     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1374         require(n < 2**32, errorMessage);
1375         return uint32(n);
1376     }
1377 
1378     function getChainId() internal pure returns (uint) {
1379         uint256 chainId;
1380         assembly { chainId := chainid() }
1381         return chainId;
1382     }
1383 }
1384 
1385 // File: contracts/SusafeChef.sol
1386 
1387 pragma solidity 0.6.12;
1388 
1389 
1390 
1391 
1392 
1393 
1394 
1395 
1396 interface IMigratorChef {
1397     // Perform LP token migration from legacy UniswapV2 to SusafeSwap.
1398     // Take the current LP token address and return the new LP token address.
1399     // Migrator should have full access to the caller's LP token.
1400     // Return the new LP token address.
1401     //
1402     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1403     // SusafeSwap must mint EXACTLY the same amount of SusafeSwap LP tokens or
1404     // else something bad will happen. Traditional UniswapV2 does not
1405     // do that so be careful!
1406     function migrate(IERC20 token) external returns (IERC20);
1407 }
1408 
1409 interface ISusafeReferral {
1410     function setReferrer(address farmer, address referrer) external;
1411     function getReferrer(address farmer) external view returns (address);
1412 }
1413 
1414 // SusafeChef is the master of Susafe. He can make Susafe and he is a fair guy.
1415 //
1416 // Note that it's ownable and the owner wields tremendous power. The ownership
1417 // will be transferred to a governance smart contract once SUSAFE is sufficiently
1418 // distributed and the community can show to govern itself.
1419 //
1420 // Have fun reading it. Hopefully it's bug-free. God bless.
1421 contract SusafeChef is Ownable {
1422     using SafeMath for uint256;
1423     using SafeERC20 for IERC20;
1424 
1425     // Info of each user.
1426     struct UserInfo {
1427         uint256 amount;     // How many LP tokens the user has provided.
1428         uint256 rewardDebt; // Reward debt. See explanation below.
1429         //
1430         // We do some fancy math here. Basically, any point in time, the amount of SUSAFEs
1431         // entitled to a user but is pending to be distributed is:
1432         //
1433         //   pending reward = (user.amount * pool.accSusafePerShare) - user.rewardDebt
1434         //
1435         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1436         //   1. The pool's `accSusafePerShare` (and `lastRewardBlock`) gets updated.
1437         //   2. User receives the pending reward sent to his/her address.
1438         //   3. User's `amount` gets updated.
1439         //   4. User's `rewardDebt` gets updated.
1440     }
1441 
1442     // Info of each pool.
1443     struct PoolInfo {
1444         IERC20 lpToken;           // Address of LP token contract.
1445         uint256 allocPoint;       // How many allocation points assigned to this pool. SUSAFEs to distribute per block.
1446         uint256 lastRewardBlock;  // Last block number that SUSAFEs distribution occurs.
1447         uint256 accSusafePerShare; // Accumulated SUSAFEs per share, times 1e12. See below.
1448     }
1449 
1450     uint256 public constant REFERRAL_COMMISSION_PERCENT = 1;
1451     address public rewardReferral;
1452 
1453     // The SUSAFE TOKEN!
1454     SusafeToken public susafe;
1455     // SUSAFE tokens created per block.
1456     uint256 public susafePerBlock;
1457     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1458     IMigratorChef public migrator;
1459 
1460     // Info of each pool.
1461     PoolInfo[] public poolInfo;
1462     // Info of each user that stakes LP tokens.
1463     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1464     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1465     uint256 public totalAllocPoint = 0;
1466     // The block number when SUSAFE mining starts.
1467     uint256 public startBlock;
1468     // Block number when each epoch ends.
1469     uint256[6] public epochEndBlocks;
1470 
1471     // Reward multipler for each of 7 epoches (epochIndex: reward multipler)
1472     uint256[7] public epochRewardMultiplers = [100, 400, 600, 800, 400, 200, 1];
1473 
1474     uint256 public constant BLOCKS_PER_DAY = 6500;
1475 
1476     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1477     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1478     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1479 
1480     constructor(
1481         SusafeToken _susafe,
1482         uint256 _susafePerBlock,
1483         uint256 _startBlock
1484     ) public {
1485         susafe = _susafe;
1486         susafePerBlock = _susafePerBlock;
1487         startBlock = _startBlock;
1488         epochEndBlocks[0] = startBlock + BLOCKS_PER_DAY * 3; // 3 days
1489         epochEndBlocks[1] = epochEndBlocks[0] + BLOCKS_PER_DAY * 7; // 1 week
1490         epochEndBlocks[2] = epochEndBlocks[1] + BLOCKS_PER_DAY * 7; // 1 week
1491         epochEndBlocks[3] = epochEndBlocks[2] + BLOCKS_PER_DAY * 14; // 2 weeks
1492         epochEndBlocks[4] = epochEndBlocks[3] + BLOCKS_PER_DAY * 14; // 2 weeks
1493         epochEndBlocks[5] = epochEndBlocks[4] + BLOCKS_PER_DAY * 7 * 34 / 10; // 3.4 weeks
1494     }
1495 
1496     function poolLength() external view returns (uint256) {
1497         return poolInfo.length;
1498     }
1499 
1500     // Add a new lp to the pool. Can only be called by the owner.
1501     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1502     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, uint256 _lastRewardBlock) public onlyOwner {
1503         if (_withUpdate) {
1504             massUpdatePools();
1505         }
1506         if (_lastRewardBlock == 0) {
1507             _lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1508         }
1509         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1510         poolInfo.push(PoolInfo({
1511             lpToken: _lpToken,
1512             allocPoint: _allocPoint,
1513             lastRewardBlock: _lastRewardBlock,
1514             accSusafePerShare: 0
1515         }));
1516     }
1517 
1518     function setSusafePerBlock(uint256 _susafePerBlock) public onlyOwner {
1519         massUpdatePools();
1520         susafePerBlock = _susafePerBlock;
1521     }
1522 
1523     function setEpochEndBlock(uint8 _index, uint256 _epochEndBlock) public onlyOwner {
1524         require(_index < 6, "_index out of range");
1525         require(epochEndBlocks[_index] > block.number, "Too late to update");
1526         epochEndBlocks[_index] = _epochEndBlock;
1527     }
1528 
1529     function setEpochRewardMultipler(uint8 _index, uint256 _epochRewardMultipler) public onlyOwner {
1530         require(_index < 7, "Index out of range");
1531         require(_index == 6 || epochEndBlocks[_index] > block.number, "Too late to update");
1532         epochRewardMultiplers[_index] = _epochRewardMultipler;
1533     }
1534 
1535     function setRewardReferral(address _rewardReferral) external onlyOwner {
1536         rewardReferral = _rewardReferral;
1537     }
1538 
1539     // Update the given pool's SUSAFE allocation point. Can only be called by the owner.
1540     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1541         if (_withUpdate) {
1542             massUpdatePools();
1543         }
1544         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1545         poolInfo[_pid].allocPoint = _allocPoint;
1546     }
1547 
1548     // Set the migrator contract. Can only be called by the owner.
1549     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1550         migrator = _migrator;
1551     }
1552 
1553     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1554     function migrate(uint256 _pid) public {
1555         require(address(migrator) != address(0), "migrate: no migrator");
1556         PoolInfo storage pool = poolInfo[_pid];
1557         IERC20 lpToken = pool.lpToken;
1558         uint256 bal = lpToken.balanceOf(address(this));
1559         lpToken.safeApprove(address(migrator), bal);
1560         IERC20 newLpToken = migrator.migrate(lpToken);
1561         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1562         pool.lpToken = newLpToken;
1563     }
1564 
1565     // Return reward multiplier over the given _from to _to block.
1566     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1567         for (uint8 epochId = 6; epochId >= 1; --epochId) {
1568             if (_to >= epochEndBlocks[epochId - 1]) {
1569                 if (_from >= epochEndBlocks[epochId - 1]) return _to.sub(_from).mul(epochRewardMultiplers[epochId]);
1570                 uint256 multiplier = _to.sub(epochEndBlocks[epochId - 1]).mul(epochRewardMultiplers[epochId]);
1571                 if (epochId == 1) return multiplier.add(epochEndBlocks[0].sub(_from).mul(epochRewardMultiplers[0]));
1572                 for (epochId = epochId - 1; epochId >= 1; --epochId) {
1573                     if (_from >= epochEndBlocks[epochId - 1]) return multiplier.add(epochEndBlocks[epochId].sub(_from).mul(epochRewardMultiplers[epochId]));
1574                     multiplier = multiplier.add(epochEndBlocks[epochId].sub(epochEndBlocks[epochId - 1]).mul(epochRewardMultiplers[epochId]));
1575                 }
1576                 return multiplier.add(epochEndBlocks[0].sub(_from).mul(epochRewardMultiplers[0]));
1577             }
1578         }
1579         return _to.sub(_from).mul(epochRewardMultiplers[0]);
1580     }
1581 
1582     // View function to see pending SUSAFEs on frontend.
1583     function pendingSusafe(uint256 _pid, address _user) external view returns (uint256) {
1584         PoolInfo storage pool = poolInfo[_pid];
1585         UserInfo storage user = userInfo[_pid][_user];
1586         uint256 accSusafePerShare = pool.accSusafePerShare;
1587         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1588         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1589             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1590             uint256 susafeReward = multiplier.mul(susafePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1591             accSusafePerShare = accSusafePerShare.add(susafeReward.mul(1e12).div(lpSupply));
1592         }
1593         return user.amount.mul(accSusafePerShare).div(1e12).sub(user.rewardDebt);
1594     }
1595 
1596     // Update reward variables for all pools. Be careful of gas spending!
1597     function massUpdatePools() public {
1598         uint256 length = poolInfo.length;
1599         for (uint256 pid = 0; pid < length; ++pid) {
1600             updatePool(pid);
1601         }
1602     }
1603 
1604     // Update reward variables of the given pool to be up-to-date.
1605     function updatePool(uint256 _pid) public {
1606         PoolInfo storage pool = poolInfo[_pid];
1607         if (block.number <= pool.lastRewardBlock) {
1608             return;
1609         }
1610         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1611         if (lpSupply == 0) {
1612             pool.lastRewardBlock = block.number;
1613             return;
1614         }
1615         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1616         uint256 susafeReward = multiplier.mul(susafePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1617         safeSusafeMint(susafeReward);
1618         pool.accSusafePerShare = pool.accSusafePerShare.add(susafeReward.mul(1e12).div(lpSupply));
1619         pool.lastRewardBlock = block.number;
1620     }
1621 
1622     // Deposit LP tokens to SusafeChef for SUSAFE allocation.
1623     function deposit(uint256 _pid, uint256 _amount, address _referrer) public {
1624         PoolInfo storage pool = poolInfo[_pid];
1625         UserInfo storage user = userInfo[_pid][msg.sender];
1626         updatePool(_pid);
1627         if (rewardReferral != address(0) && _referrer != address(0)) {
1628             ISusafeReferral(rewardReferral).setReferrer(msg.sender, _referrer);
1629         }
1630         if (user.amount > 0) {
1631             uint256 pending = user.amount.mul(pool.accSusafePerShare).div(1e12).sub(user.rewardDebt);
1632             if(pending > 0) {
1633                 uint256 actualPaid = pending.mul(100 - REFERRAL_COMMISSION_PERCENT).div(100); // 99%
1634                 uint256 commission = pending - actualPaid; // 1%
1635                 safeSusafeTransfer(msg.sender, actualPaid);
1636                 if (rewardReferral != address(0)) {
1637                     _referrer = ISusafeReferral(rewardReferral).getReferrer(msg.sender);
1638                 }
1639                 if (_referrer != address(0)) { // send commission to referrer
1640                     safeSusafeTransfer(_referrer, commission);
1641                 } else { // or burn
1642                     safeSusafeBurn(commission);
1643                 }
1644             }
1645         }
1646         if(_amount > 0) {
1647             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1648             user.amount = user.amount.add(_amount);
1649         }
1650         user.rewardDebt = user.amount.mul(pool.accSusafePerShare).div(1e12);
1651         emit Deposit(msg.sender, _pid, _amount);
1652     }
1653 
1654     // Withdraw LP tokens from SusafeChef.
1655     function withdraw(uint256 _pid, uint256 _amount) public {
1656         PoolInfo storage pool = poolInfo[_pid];
1657         UserInfo storage user = userInfo[_pid][msg.sender];
1658         require(user.amount >= _amount, "withdraw: not good");
1659         updatePool(_pid);
1660         uint256 pending = user.amount.mul(pool.accSusafePerShare).div(1e12).sub(user.rewardDebt);
1661         if(pending > 0) {
1662             uint256 actualPaid = pending.mul(100 - REFERRAL_COMMISSION_PERCENT).div(100); // 99%
1663             uint256 commission = pending - actualPaid; // 1%
1664             safeSusafeTransfer(msg.sender, actualPaid);
1665             address _referrer = address(0);
1666             if (rewardReferral != address(0)) {
1667                 _referrer = ISusafeReferral(rewardReferral).getReferrer(msg.sender);
1668             }
1669             if (_referrer != address(0)) { // send commission to referrer
1670                 safeSusafeTransfer(_referrer, commission);
1671             } else { // or burn
1672                 safeSusafeBurn(commission);
1673             }
1674         }
1675         if(_amount > 0) {
1676             user.amount = user.amount.sub(_amount);
1677             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1678         }
1679         user.rewardDebt = user.amount.mul(pool.accSusafePerShare).div(1e12);
1680         emit Withdraw(msg.sender, _pid, _amount);
1681     }
1682 
1683     // Withdraw without caring about rewards. EMERGENCY ONLY.
1684     function emergencyWithdraw(uint256 _pid) public {
1685         PoolInfo storage pool = poolInfo[_pid];
1686         UserInfo storage user = userInfo[_pid][msg.sender];
1687         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1688         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1689         user.amount = 0;
1690         user.rewardDebt = 0;
1691     }
1692 
1693     // Safe susafe mint, ensure it is never over cap and we are the current owner.
1694     function safeSusafeMint(uint256 _amount) internal {
1695         if (susafe.owner() == address(this)) {
1696             uint256 totalSupply = susafe.totalSupply();
1697             uint256 cap = susafe.cap();
1698             if (totalSupply.add(_amount) > cap) {
1699                 susafe.mint(address(this), cap.sub(totalSupply));
1700             } else {
1701                 susafe.mint(address(this), _amount);
1702             }
1703         }
1704     }
1705 
1706     // Safe susafe burn function, just in case if rounding error causes pool to not have enough SUSAFEs.
1707     function safeSusafeBurn(uint256 _amount) internal {
1708         uint256 susafeBal = susafe.balanceOf(address(this));
1709         if (_amount > susafeBal) {
1710             susafe.burn(susafeBal);
1711         } else {
1712             susafe.burn(_amount);
1713         }
1714     }
1715 
1716     // Safe susafe transfer function, just in case if rounding error causes pool to not have enough SUSAFEs.
1717     function safeSusafeTransfer(address _to, uint256 _amount) internal {
1718         uint256 susafeBal = susafe.balanceOf(address(this));
1719         if (_amount > susafeBal) {
1720             susafe.transfer(_to, susafeBal);
1721         } else {
1722             susafe.transfer(_to, _amount);
1723         }
1724     }
1725 
1726     // Transfer ownership of Susafe (eg. a governance DAO contract)
1727     function transferSusafeOwnership(address newSusafeOwner) public onlyOwner {
1728         SusafeToken(susafe).transferOwnership(newSusafeOwner);
1729     }
1730 }