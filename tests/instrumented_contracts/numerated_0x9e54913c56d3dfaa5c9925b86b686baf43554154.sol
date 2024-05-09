1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.6.12;
8 
9 
10 // 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
266         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
267         // for accounts without code, i.e. `keccak256('')`
268         bytes32 codehash;
269         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { codehash := extcodehash(account) }
272         return (codehash != accountHash && codehash != 0x0);
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
295         (bool success, ) = recipient.call{ value: amount }("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain`call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318       return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
328         return _functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         return _functionCallWithValue(target, data, value, errorMessage);
355     }
356 
357     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
358         require(isContract(target), "Address: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
362         if (success) {
363             return returndata;
364         } else {
365             // Look for revert reason and bubble it up if present
366             if (returndata.length > 0) {
367                 // The easiest way to bubble the revert reason is using memory via assembly
368 
369                 // solhint-disable-next-line no-inline-assembly
370                 assembly {
371                     let returndata_size := mload(returndata)
372                     revert(add(32, returndata), returndata_size)
373                 }
374             } else {
375                 revert(errorMessage);
376             }
377         }
378     }
379 }
380 
381 // 
382 /**
383  * @title SafeERC20
384  * @dev Wrappers around ERC20 operations that throw on failure (when the token
385  * contract returns false). Tokens that return no value (and instead revert or
386  * throw on failure) are also supported, non-reverting calls are assumed to be
387  * successful.
388  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
389  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
390  */
391 library SafeERC20 {
392     using SafeMath for uint256;
393     using Address for address;
394 
395     function safeTransfer(IERC20 token, address to, uint256 value) internal {
396         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
397     }
398 
399     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
400         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
401     }
402 
403     /**
404      * @dev Deprecated. This function has issues similar to the ones found in
405      * {IERC20-approve}, and its usage is discouraged.
406      *
407      * Whenever possible, use {safeIncreaseAllowance} and
408      * {safeDecreaseAllowance} instead.
409      */
410     function safeApprove(IERC20 token, address spender, uint256 value) internal {
411         // safeApprove should only be called when setting an initial allowance,
412         // or when resetting it to zero. To increase and decrease it, use
413         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
414         // solhint-disable-next-line max-line-length
415         require((value == 0) || (token.allowance(address(this), spender) == 0),
416             "SafeERC20: approve from non-zero to non-zero allowance"
417         );
418         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
419     }
420 
421     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
422         uint256 newAllowance = token.allowance(address(this), spender).add(value);
423         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
424     }
425 
426     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
427         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
429     }
430 
431     /**
432      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
433      * on the return value: the return value is optional (but if data is returned, it must not be false).
434      * @param token The token targeted by the call.
435      * @param data The call data (encoded using abi.encode or one of its variants).
436      */
437     function _callOptionalReturn(IERC20 token, bytes memory data) private {
438         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
439         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
440         // the target address contains contract code and also asserts for success in the low-level call.
441 
442         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
443         if (returndata.length > 0) { // Return data is optional
444             // solhint-disable-next-line max-line-length
445             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
446         }
447     }
448 }
449 
450 // 
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
691 // 
692 /*
693  * @dev Provides information about the current execution context, including the
694  * sender of the transaction and its data. While these are generally available
695  * via msg.sender and msg.data, they should not be accessed in such a direct
696  * manner, since when dealing with GSN meta-transactions the account sending and
697  * paying for execution may not be the actual sender (as far as an application
698  * is concerned).
699  *
700  * This contract is only required for intermediate, library-like contracts.
701  */
702 abstract contract Context {
703     function _msgSender() internal view virtual returns (address payable) {
704         return msg.sender;
705     }
706 
707     function _msgData() internal view virtual returns (bytes memory) {
708         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
709         return msg.data;
710     }
711 }
712 
713 // 
714 /**
715  * @dev Contract module which provides a basic access control mechanism, where
716  * there is an account (an owner) that can be granted exclusive access to
717  * specific functions.
718  *
719  * By default, the owner account will be the one that deploys the contract. This
720  * can later be changed with {transferOwnership}.
721  *
722  * This module is used through inheritance. It will make available the modifier
723  * `onlyOwner`, which can be applied to your functions to restrict their use to
724  * the owner.
725  */
726 contract Ownable is Context {
727     address private _owner;
728 
729     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
730 
731     /**
732      * @dev Initializes the contract setting the deployer as the initial owner.
733      */
734     constructor () internal {
735         address msgSender = _msgSender();
736         _owner = msgSender;
737         emit OwnershipTransferred(address(0), msgSender);
738     }
739 
740     /**
741      * @dev Returns the address of the current owner.
742      */
743     function owner() public view returns (address) {
744         return _owner;
745     }
746 
747     /**
748      * @dev Throws if called by any account other than the owner.
749      */
750     modifier onlyOwner() {
751         require(_owner == _msgSender(), "Ownable: caller is not the owner");
752         _;
753     }
754 
755     /**
756      * @dev Leaves the contract without owner. It will not be possible to call
757      * `onlyOwner` functions anymore. Can only be called by the current owner.
758      *
759      * NOTE: Renouncing ownership will leave the contract without an owner,
760      * thereby removing any functionality that is only available to the owner.
761      */
762     function renounceOwnership() public virtual onlyOwner {
763         emit OwnershipTransferred(_owner, address(0));
764         _owner = address(0);
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      * Can only be called by the current owner.
770      */
771     function transferOwnership(address newOwner) public virtual onlyOwner {
772         require(newOwner != address(0), "Ownable: new owner is the zero address");
773         emit OwnershipTransferred(_owner, newOwner);
774         _owner = newOwner;
775     }
776 }
777 
778 // 
779 /**
780  * @dev Implementation of the {IERC20} interface.
781  *
782  * This implementation is agnostic to the way tokens are created. This means
783  * that a supply mechanism has to be added in a derived contract using {_mint}.
784  * For a generic mechanism see {ERC20PresetMinterPauser}.
785  *
786  * TIP: For a detailed writeup see our guide
787  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
788  * to implement supply mechanisms].
789  *
790  * We have followed general OpenZeppelin guidelines: functions revert instead
791  * of returning `false` on failure. This behavior is nonetheless conventional
792  * and does not conflict with the expectations of ERC20 applications.
793  *
794  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
795  * This allows applications to reconstruct the allowance for all accounts just
796  * by listening to said events. Other implementations of the EIP may not emit
797  * these events, as it isn't required by the specification.
798  *
799  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
800  * functions have been added to mitigate the well-known issues around setting
801  * allowances. See {IERC20-approve}.
802  */
803 contract ERC20 is Context, IERC20 {
804     using SafeMath for uint256;
805     using Address for address;
806 
807     mapping (address => uint256) private _balances;
808 
809     mapping (address => mapping (address => uint256)) private _allowances;
810 
811     uint256 private _totalSupply;
812 
813     string private _name;
814     string private _symbol;
815     uint8 private _decimals;
816 
817     /**
818      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
819      * a default value of 18.
820      *
821      * To select a different value for {decimals}, use {_setupDecimals}.
822      *
823      * All three of these values are immutable: they can only be set once during
824      * construction.
825      */
826     constructor (string memory name, string memory symbol) public {
827         _name = name;
828         _symbol = symbol;
829         _decimals = 18;
830     }
831 
832     /**
833      * @dev Returns the name of the token.
834      */
835     function name() public view returns (string memory) {
836         return _name;
837     }
838 
839     /**
840      * @dev Returns the symbol of the token, usually a shorter version of the
841      * name.
842      */
843     function symbol() public view returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev Returns the number of decimals used to get its user representation.
849      * For example, if `decimals` equals `2`, a balance of `505` tokens should
850      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
851      *
852      * Tokens usually opt for a value of 18, imitating the relationship between
853      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
854      * called.
855      *
856      * NOTE: This information is only used for _display_ purposes: it in
857      * no way affects any of the arithmetic of the contract, including
858      * {IERC20-balanceOf} and {IERC20-transfer}.
859      */
860     function decimals() public view returns (uint8) {
861         return _decimals;
862     }
863 
864     /**
865      * @dev See {IERC20-totalSupply}.
866      */
867     function totalSupply() public view override returns (uint256) {
868         return _totalSupply;
869     }
870 
871     /**
872      * @dev See {IERC20-balanceOf}.
873      */
874     function balanceOf(address account) public view override returns (uint256) {
875         return _balances[account];
876     }
877 
878     /**
879      * @dev See {IERC20-transfer}.
880      *
881      * Requirements:
882      *
883      * - `recipient` cannot be the zero address.
884      * - the caller must have a balance of at least `amount`.
885      */
886     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
887         _transfer(_msgSender(), recipient, amount);
888         return true;
889     }
890 
891     /**
892      * @dev See {IERC20-allowance}.
893      */
894     function allowance(address owner, address spender) public view virtual override returns (uint256) {
895         return _allowances[owner][spender];
896     }
897 
898     /**
899      * @dev See {IERC20-approve}.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      */
905     function approve(address spender, uint256 amount) public virtual override returns (bool) {
906         _approve(_msgSender(), spender, amount);
907         return true;
908     }
909 
910     /**
911      * @dev See {IERC20-transferFrom}.
912      *
913      * Emits an {Approval} event indicating the updated allowance. This is not
914      * required by the EIP. See the note at the beginning of {ERC20};
915      *
916      * Requirements:
917      * - `sender` and `recipient` cannot be the zero address.
918      * - `sender` must have a balance of at least `amount`.
919      * - the caller must have allowance for ``sender``'s tokens of at least
920      * `amount`.
921      */
922     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
923         _transfer(sender, recipient, amount);
924         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
925         return true;
926     }
927 
928     /**
929      * @dev Atomically increases the allowance granted to `spender` by the caller.
930      *
931      * This is an alternative to {approve} that can be used as a mitigation for
932      * problems described in {IERC20-approve}.
933      *
934      * Emits an {Approval} event indicating the updated allowance.
935      *
936      * Requirements:
937      *
938      * - `spender` cannot be the zero address.
939      */
940     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
941         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
942         return true;
943     }
944 
945     /**
946      * @dev Atomically decreases the allowance granted to `spender` by the caller.
947      *
948      * This is an alternative to {approve} that can be used as a mitigation for
949      * problems described in {IERC20-approve}.
950      *
951      * Emits an {Approval} event indicating the updated allowance.
952      *
953      * Requirements:
954      *
955      * - `spender` cannot be the zero address.
956      * - `spender` must have allowance for the caller of at least
957      * `subtractedValue`.
958      */
959     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
960         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
961         return true;
962     }
963 
964     /**
965      * @dev Moves tokens `amount` from `sender` to `recipient`.
966      *
967      * This is internal function is equivalent to {transfer}, and can be used to
968      * e.g. implement automatic token fees, slashing mechanisms, etc.
969      *
970      * Emits a {Transfer} event.
971      *
972      * Requirements:
973      *
974      * - `sender` cannot be the zero address.
975      * - `recipient` cannot be the zero address.
976      * - `sender` must have a balance of at least `amount`.
977      */
978     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
979         require(sender != address(0), "ERC20: transfer from the zero address");
980         require(recipient != address(0), "ERC20: transfer to the zero address");
981 
982         _beforeTokenTransfer(sender, recipient, amount);
983 
984         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
985         _balances[recipient] = _balances[recipient].add(amount);
986         emit Transfer(sender, recipient, amount);
987     }
988 
989     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
990      * the total supply.
991      *
992      * Emits a {Transfer} event with `from` set to the zero address.
993      *
994      * Requirements
995      *
996      * - `to` cannot be the zero address.
997      */
998     function _mint(address account, uint256 amount) internal virtual {
999         require(account != address(0), "ERC20: mint to the zero address");
1000 
1001         _beforeTokenTransfer(address(0), account, amount);
1002 
1003         _totalSupply = _totalSupply.add(amount);
1004         _balances[account] = _balances[account].add(amount);
1005         emit Transfer(address(0), account, amount);
1006     }
1007 
1008     /**
1009      * @dev Destroys `amount` tokens from `account`, reducing the
1010      * total supply.
1011      *
1012      * Emits a {Transfer} event with `to` set to the zero address.
1013      *
1014      * Requirements
1015      *
1016      * - `account` cannot be the zero address.
1017      * - `account` must have at least `amount` tokens.
1018      */
1019     function _burn(address account, uint256 amount) internal virtual {
1020         require(account != address(0), "ERC20: burn from the zero address");
1021 
1022         _beforeTokenTransfer(account, address(0), amount);
1023 
1024         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1025         _totalSupply = _totalSupply.sub(amount);
1026         emit Transfer(account, address(0), amount);
1027     }
1028 
1029     /**
1030      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1031      *
1032      * This is internal function is equivalent to `approve`, and can be used to
1033      * e.g. set automatic allowances for certain subsystems, etc.
1034      *
1035      * Emits an {Approval} event.
1036      *
1037      * Requirements:
1038      *
1039      * - `owner` cannot be the zero address.
1040      * - `spender` cannot be the zero address.
1041      */
1042     function _approve(address owner, address spender, uint256 amount) internal virtual {
1043         require(owner != address(0), "ERC20: approve from the zero address");
1044         require(spender != address(0), "ERC20: approve to the zero address");
1045 
1046         _allowances[owner][spender] = amount;
1047         emit Approval(owner, spender, amount);
1048     }
1049 
1050     /**
1051      * @dev Sets {decimals} to a value other than the default one of 18.
1052      *
1053      * WARNING: This function should only be called from the constructor. Most
1054      * applications that interact with token contracts will not expect
1055      * {decimals} to ever change, and may work incorrectly if it does.
1056      */
1057     function _setupDecimals(uint8 decimals_) internal {
1058         _decimals = decimals_;
1059     }
1060 
1061     /**
1062      * @dev Hook that is called before any transfer of tokens. This includes
1063      * minting and burning.
1064      *
1065      * Calling conditions:
1066      *
1067      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1068      * will be to transferred to `to`.
1069      * - when `from` is zero, `amount` tokens will be minted for `to`.
1070      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1071      * - `from` and `to` are never both zero.
1072      *
1073      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1074      */
1075     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1076 }
1077 
1078 // 
1079 // YfnpToken with Governance.
1080 contract YfnpToken is ERC20("pool.yfi.name", "YFNP"), Ownable {
1081     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1082     function mint(address _to, uint256 _amount) public onlyOwner {
1083         _mint(_to, _amount);
1084         _moveDelegates(address(0), _delegates[_to], _amount);
1085     }
1086 
1087     // Burn some yfnp, reduce total circulation.
1088     function burn(uint256 _amount) public {
1089         _burn(msg.sender, _amount);
1090     }
1091 
1092     // Copied and modified from YAM code:
1093     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1094     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1095     // Which is copied and modified from COMPOUND:
1096     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1097 
1098     /// @dev A record of each accounts delegate
1099     mapping (address => address) internal _delegates;
1100 
1101     /// @notice A checkpoint for marking number of votes from a given block
1102     struct Checkpoint {
1103         uint32 fromBlock;
1104         uint256 votes;
1105     }
1106 
1107     /// @notice A record of votes checkpoints for each account, by index
1108     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1109 
1110     /// @notice The number of checkpoints for each account
1111     mapping (address => uint32) public numCheckpoints;
1112 
1113     /// @notice The EIP-712 typehash for the contract's domain
1114     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1115 
1116     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1117     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1118 
1119     /// @notice A record of states for signing / validating signatures
1120     mapping (address => uint) public nonces;
1121 
1122       /// @notice An event thats emitted when an account changes its delegate
1123     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1124 
1125     /// @notice An event thats emitted when a delegate account's vote balance changes
1126     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1127 
1128     /**
1129      * @notice Delegate votes from `msg.sender` to `delegatee`
1130      * @param delegator The address to get delegatee for
1131      */
1132     function delegates(address delegator)
1133         external
1134         view
1135         returns (address)
1136     {
1137         return _delegates[delegator];
1138     }
1139 
1140    /**
1141     * @notice Delegate votes from `msg.sender` to `delegatee`
1142     * @param delegatee The address to delegate votes to
1143     */
1144     function delegate(address delegatee) external {
1145         return _delegate(msg.sender, delegatee);
1146     }
1147 
1148     /**
1149      * @notice Delegates votes from signatory to `delegatee`
1150      * @param delegatee The address to delegate votes to
1151      * @param nonce The contract state required to match the signature
1152      * @param expiry The time at which to expire the signature
1153      * @param v The recovery byte of the signature
1154      * @param r Half of the ECDSA signature pair
1155      * @param s Half of the ECDSA signature pair
1156      */
1157     function delegateBySig(
1158         address delegatee,
1159         uint nonce,
1160         uint expiry,
1161         uint8 v,
1162         bytes32 r,
1163         bytes32 s
1164     )
1165         external
1166     {
1167         bytes32 domainSeparator = keccak256(
1168             abi.encode(
1169                 DOMAIN_TYPEHASH,
1170                 keccak256(bytes(name())),
1171                 getChainId(),
1172                 address(this)
1173             )
1174         );
1175 
1176         bytes32 structHash = keccak256(
1177             abi.encode(
1178                 DELEGATION_TYPEHASH,
1179                 delegatee,
1180                 nonce,
1181                 expiry
1182             )
1183         );
1184 
1185         bytes32 digest = keccak256(
1186             abi.encodePacked(
1187                 "\x19\x01",
1188                 domainSeparator,
1189                 structHash
1190             )
1191         );
1192 
1193         address signatory = ecrecover(digest, v, r, s);
1194         require(signatory != address(0), "YFNP::delegateBySig: invalid signature");
1195         require(nonce == nonces[signatory]++, "YFNP::delegateBySig: invalid nonce");
1196         require(now <= expiry, "YFNP::delegateBySig: signature expired");
1197         return _delegate(signatory, delegatee);
1198     }
1199 
1200     /**
1201      * @notice Gets the current votes balance for `account`
1202      * @param account The address to get votes balance
1203      * @return The number of current votes for `account`
1204      */
1205     function getCurrentVotes(address account)
1206         external
1207         view
1208         returns (uint256)
1209     {
1210         uint32 nCheckpoints = numCheckpoints[account];
1211         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1212     }
1213 
1214     /**
1215      * @notice Determine the prior number of votes for an account as of a block number
1216      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1217      * @param account The address of the account to check
1218      * @param blockNumber The block number to get the vote balance at
1219      * @return The number of votes the account had as of the given block
1220      */
1221     function getPriorVotes(address account, uint blockNumber)
1222         external
1223         view
1224         returns (uint256)
1225     {
1226         require(blockNumber < block.number, "YFNP::getPriorVotes: not yet determined");
1227 
1228         uint32 nCheckpoints = numCheckpoints[account];
1229         if (nCheckpoints == 0) {
1230             return 0;
1231         }
1232 
1233         // First check most recent balance
1234         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1235             return checkpoints[account][nCheckpoints - 1].votes;
1236         }
1237 
1238         // Next check implicit zero balance
1239         if (checkpoints[account][0].fromBlock > blockNumber) {
1240             return 0;
1241         }
1242 
1243         uint32 lower = 0;
1244         uint32 upper = nCheckpoints - 1;
1245         while (upper > lower) {
1246             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1247             Checkpoint memory cp = checkpoints[account][center];
1248             if (cp.fromBlock == blockNumber) {
1249                 return cp.votes;
1250             } else if (cp.fromBlock < blockNumber) {
1251                 lower = center;
1252             } else {
1253                 upper = center - 1;
1254             }
1255         }
1256         return checkpoints[account][lower].votes;
1257     }
1258 
1259     function _delegate(address delegator, address delegatee)
1260         internal
1261     {
1262         address currentDelegate = _delegates[delegator];
1263         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying YFNPs (not scaled);
1264         _delegates[delegator] = delegatee;
1265 
1266         emit DelegateChanged(delegator, currentDelegate, delegatee);
1267 
1268         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1269     }
1270 
1271     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1272         if (srcRep != dstRep && amount > 0) {
1273             if (srcRep != address(0)) {
1274                 // decrease old representative
1275                 uint32 srcRepNum = numCheckpoints[srcRep];
1276                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1277                 uint256 srcRepNew = srcRepOld.sub(amount);
1278                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1279             }
1280 
1281             if (dstRep != address(0)) {
1282                 // increase new representative
1283                 uint32 dstRepNum = numCheckpoints[dstRep];
1284                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1285                 uint256 dstRepNew = dstRepOld.add(amount);
1286                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1287             }
1288         }
1289     }
1290 
1291     function _writeCheckpoint(
1292         address delegatee,
1293         uint32 nCheckpoints,
1294         uint256 oldVotes,
1295         uint256 newVotes
1296     )
1297         internal
1298     {
1299         uint32 blockNumber = safe32(block.number, "YFNP::_writeCheckpoint: block number exceeds 32 bits");
1300 
1301         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1302             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1303         } else {
1304             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1305             numCheckpoints[delegatee] = nCheckpoints + 1;
1306         }
1307 
1308         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1309     }
1310 
1311     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1312         require(n < 2**32, errorMessage);
1313         return uint32(n);
1314     }
1315 
1316     function getChainId() internal pure returns (uint) {
1317         uint256 chainId;
1318         assembly { chainId := chainid() }
1319         return chainId;
1320     }
1321 }
1322 
1323 // 
1324 // YfnpPools can make Yfnp and he is a fair guy.
1325 //
1326 // Note that it's ownable and the owner wields tremendous power. The ownership
1327 // will be transferred to a governance smart contract once YFNP is sufficiently
1328 // distributed and the community can show to govern itself.
1329 //
1330 // Have fun reading it. Hopefully it's bug-free. God bless.
1331 contract YfnpPools is Ownable {
1332     using SafeMath for uint256;
1333     using SafeERC20 for IERC20;
1334 
1335     // Info of each user.
1336     struct UserInfo {
1337         uint256 amount;     // How many LP tokens the user has provided.
1338         uint256 rewardDebt; // Reward debt. See explanation below.
1339         //
1340         // We do some fancy math here. Basically, any point in time, the amount of YFNPs
1341         // entitled to a user but is pending to be distributed is:
1342         //
1343         //   pending reward = (user.amount * pool.accYfnpPerShare) - user.rewardDebt
1344         //
1345         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1346         //   1. The pool's `accYfnpPerShare` (and `lastRewardBlock`) gets updated.
1347         //   2. User receives the pending reward sent to his/her address.
1348         //   3. User's `amount` gets updated.
1349         //   4. User's `rewardDebt` gets updated.
1350     }
1351 
1352     // Info of each pool.
1353     struct PoolInfo {
1354         IERC20 lpToken;           // Address of LP token contract.
1355         uint256 allocPoint;       // How many allocation points assigned to this pool. YFNPs to distribute per block.
1356         uint256 lastRewardBlock;  // Last block number that YFNPs distribution occurs.
1357         uint256 accYfnpPerShare; // Accumulated YFNPs per share, times 1e12. See below.
1358     }
1359 
1360     // Yfnp supply must be less than max supply!
1361     uint256 public maxYfnpSupply = 60*10**23;
1362     // When the yfnp reaches this level, the yield is halved!
1363     uint256 public halvingYfnpSupply = 15*10**23;
1364     // The YFNP TOKEN!
1365     YfnpToken public yfnp;
1366     // Dev address.
1367     address public devaddr;
1368     // Block number when bonus YFNP period ends.
1369     uint256 public bonusEndBlock;
1370     // YFNP tokens created per block.
1371     uint256 public yfnpPerBlock;
1372     // Bonus muliplier for early yfnp makers.
1373     uint256 public constant BONUS_MULTIPLIER = 2;
1374 
1375     // Info of each pool.
1376     PoolInfo[] public poolInfo;
1377     // Info of each user that stakes LP tokens.
1378     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1379     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1380     uint256 public totalAllocPoint = 0;
1381     // The block number when YFNP mining starts.
1382     uint256 public startBlock;
1383 
1384     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1385     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1386     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1387 
1388     constructor(
1389         YfnpToken _yfnp,
1390         address _devaddr,
1391         uint256 _yfnpPerBlock,
1392         uint256 _startBlock,
1393         uint256 _bonusEndBlock
1394     ) public {
1395         yfnp = _yfnp;
1396         devaddr = _devaddr;
1397         yfnpPerBlock = _yfnpPerBlock;
1398         bonusEndBlock = _bonusEndBlock;
1399         startBlock = _startBlock;
1400     }
1401 
1402     function poolLength() external view returns (uint256) {
1403         return poolInfo.length;
1404     }
1405 
1406     // Add a new lp to the pool. Can only be called by the owner.
1407     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1408     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1409         if (_withUpdate) {
1410             massUpdatePools();
1411         }
1412         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1413         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1414         poolInfo.push(PoolInfo({
1415             lpToken: _lpToken,
1416             allocPoint: _allocPoint,
1417             lastRewardBlock: lastRewardBlock,
1418             accYfnpPerShare: 0
1419         }));
1420     }
1421 
1422     // Update the given pool's YFNP allocation point. Can only be called by the owner.
1423     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1424         if (_withUpdate) {
1425             massUpdatePools();
1426         }
1427         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1428         poolInfo[_pid].allocPoint = _allocPoint;
1429     }
1430 
1431     // Return reward multiplier over the given _from to _to block, yield halved when reach point.
1432     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1433         if(yfnp.totalSupply() >= halvingYfnpSupply.mul(3)){
1434             return _to.sub(_from).div(8);
1435         }
1436         if(yfnp.totalSupply() >= halvingYfnpSupply.mul(2)){
1437             return _to.sub(_from).div(4);
1438         }
1439         if( yfnp.totalSupply() >= halvingYfnpSupply){
1440             return _to.sub(_from).div(2);
1441         }
1442         if (_to <= bonusEndBlock) {
1443             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1444         } else if (_from >= bonusEndBlock) {
1445             return _to.sub(_from);
1446         } else {
1447             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1448                 _to.sub(bonusEndBlock)
1449             );
1450         }
1451     }
1452 
1453     // View function to see pending YFNPs on frontend.
1454     function pendingYfnp(uint256 _pid, address _user) external view returns (uint256) {
1455         PoolInfo storage pool = poolInfo[_pid];
1456         UserInfo storage user = userInfo[_pid][_user];
1457         uint256 accYfnpPerShare = pool.accYfnpPerShare;
1458         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1459         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1460             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1461             uint256 yfnpReward = multiplier.mul(yfnpPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1462             accYfnpPerShare = accYfnpPerShare.add(yfnpReward.mul(1e12).div(lpSupply));
1463         }
1464         return user.amount.mul(accYfnpPerShare).div(1e12).sub(user.rewardDebt);
1465     }
1466 
1467     // Update reward vairables for all pools. Be careful of gas spending!
1468     function massUpdatePools() public {
1469         uint256 length = poolInfo.length;
1470         for (uint256 pid = 0; pid < length; ++pid) {
1471             updatePool(pid);
1472         }
1473     }
1474 
1475     // Update reward variables of the given pool to be up-to-date.
1476     function updatePool(uint256 _pid) public {
1477         if (yfnp.totalSupply() < maxYfnpSupply){
1478             PoolInfo storage pool = poolInfo[_pid];
1479             if (block.number <= pool.lastRewardBlock) {
1480                 return;
1481             }
1482             uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1483             if (lpSupply == 0) {
1484                 pool.lastRewardBlock = block.number;
1485                 return;
1486             }
1487             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1488             uint256 yfnpReward = multiplier.mul(yfnpPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1489             yfnp.mint(devaddr, yfnpReward.div(10));
1490             yfnp.mint(address(this), yfnpReward);
1491             pool.accYfnpPerShare = pool.accYfnpPerShare.add(yfnpReward.mul(1e12).div(lpSupply));
1492             pool.lastRewardBlock = block.number;
1493         }
1494 
1495     }
1496 
1497     // Deposit LP tokens to YfnpPools for YFNP allocation.
1498     function deposit(uint256 _pid, uint256 _amount) public {
1499         PoolInfo storage pool = poolInfo[_pid];
1500         UserInfo storage user = userInfo[_pid][msg.sender];
1501         updatePool(_pid);
1502         if (user.amount > 0) {
1503             uint256 pending = user.amount.mul(pool.accYfnpPerShare).div(1e12).sub(user.rewardDebt);
1504             safeYfnpTransfer(msg.sender, pending);
1505         }
1506         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1507         user.amount = user.amount.add(_amount);
1508         user.rewardDebt = user.amount.mul(pool.accYfnpPerShare).div(1e12);
1509         emit Deposit(msg.sender, _pid, _amount);
1510     }
1511 
1512     // Withdraw LP tokens from YfnpPools.
1513     function withdraw(uint256 _pid, uint256 _amount) public {
1514         PoolInfo storage pool = poolInfo[_pid];
1515         UserInfo storage user = userInfo[_pid][msg.sender];
1516         require(user.amount >= _amount, "withdraw: not good");
1517         updatePool(_pid);
1518         uint256 pending = user.amount.mul(pool.accYfnpPerShare).div(1e12).sub(user.rewardDebt);
1519         safeYfnpTransfer(msg.sender, pending);
1520         user.amount = user.amount.sub(_amount);
1521         user.rewardDebt = user.amount.mul(pool.accYfnpPerShare).div(1e12);
1522         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1523         emit Withdraw(msg.sender, _pid, _amount);
1524     }
1525 
1526     // Withdraw without caring about rewards. EMERGENCY ONLY.
1527     function emergencyWithdraw(uint256 _pid) public {
1528         PoolInfo storage pool = poolInfo[_pid];
1529         UserInfo storage user = userInfo[_pid][msg.sender];
1530         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1531         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1532         user.amount = 0;
1533         user.rewardDebt = 0;
1534     }
1535 
1536     // Safe yfnp transfer function, just in case if rounding error causes pool to not have enough YFNPs.
1537     function safeYfnpTransfer(address _to, uint256 _amount) internal {
1538         uint256 yfnpBal = yfnp.balanceOf(address(this));
1539         if (_amount > yfnpBal) {
1540             yfnp.transfer(_to, yfnpBal);
1541         } else {
1542             yfnp.transfer(_to, _amount);
1543         }
1544     }
1545 
1546     // Update dev address by the previous dev.
1547     function dev(address _devaddr) public {
1548         require(msg.sender == devaddr, "dev: wut?");
1549         devaddr = _devaddr;
1550     }
1551 
1552 }