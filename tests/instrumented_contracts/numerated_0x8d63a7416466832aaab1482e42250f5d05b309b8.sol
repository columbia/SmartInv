1 // https://idmoswap.com/
2 pragma solidity 0.6.12;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 
80 
81 /**
82  * @dev Wrappers over Solidity's arithmetic operations with added overflow
83  * checks.
84  *
85  * Arithmetic operations in Solidity wrap on overflow. This can easily result
86  * in bugs, because programmers usually assume that an overflow raises an
87  * error, which is the standard behavior in high level programming languages.
88  * `SafeMath` restores this intuition by reverting the transaction when an
89  * operation overflows.
90  *
91  * Using this library instead of the unchecked operations eliminates an entire
92  * class of bugs, so it's recommended to use it always.
93  */
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return sub(a, b, "SafeMath: subtraction overflow");
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      *
151      * - Multiplication cannot overflow.
152      */
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155         // benefit is lost if 'b' is also tested.
156         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157         if (a == 0) {
158             return 0;
159         }
160 
161         uint256 c = a * b;
162         require(c / a == b, "SafeMath: multiplication overflow");
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers. Reverts on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b > 0, errorMessage);
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * Reverts when dividing by zero.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216         return mod(a, b, "SafeMath: modulo by zero");
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts with custom message when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b != 0, errorMessage);
233         return a % b;
234     }
235 }
236 
237 
238 
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
377 
378 
379 /**
380  * @title SafeERC20
381  * @dev Wrappers around ERC20 operations that throw on failure (when the token
382  * contract returns false). Tokens that return no value (and instead revert or
383  * throw on failure) are also supported, non-reverting calls are assumed to be
384  * successful.
385  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
386  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
387  */
388 library SafeERC20 {
389     using SafeMath for uint256;
390     using Address for address;
391 
392     function safeTransfer(IERC20 token, address to, uint256 value) internal {
393         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
394     }
395 
396     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
397         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
398     }
399 
400     /**
401      * @dev Deprecated. This function has issues similar to the ones found in
402      * {IERC20-approve}, and its usage is discouraged.
403      *
404      * Whenever possible, use {safeIncreaseAllowance} and
405      * {safeDecreaseAllowance} instead.
406      */
407     function safeApprove(IERC20 token, address spender, uint256 value) internal {
408         // safeApprove should only be called when setting an initial allowance,
409         // or when resetting it to zero. To increase and decrease it, use
410         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
411         // solhint-disable-next-line max-line-length
412         require((value == 0) || (token.allowance(address(this), spender) == 0),
413             "SafeERC20: approve from non-zero to non-zero allowance"
414         );
415         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
416     }
417 
418     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
419         uint256 newAllowance = token.allowance(address(this), spender).add(value);
420         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
421     }
422 
423     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
424         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
425         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
426     }
427 
428     /**
429      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
430      * on the return value: the return value is optional (but if data is returned, it must not be false).
431      * @param token The token targeted by the call.
432      * @param data The call data (encoded using abi.encode or one of its variants).
433      */
434     function _callOptionalReturn(IERC20 token, bytes memory data) private {
435         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
436         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
437         // the target address contains contract code and also asserts for success in the low-level call.
438 
439         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
440         if (returndata.length > 0) { // Return data is optional
441             // solhint-disable-next-line max-line-length
442             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
443         }
444     }
445 }
446 
447 
448 
449 /**
450  * @dev Library for managing
451  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
452  * types.
453  *
454  * Sets have the following properties:
455  *
456  * - Elements are added, removed, and checked for existence in constant time
457  * (O(1)).
458  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
459  *
460  * ```
461  * contract Example {
462  *     // Add the library methods
463  *     using EnumerableSet for EnumerableSet.AddressSet;
464  *
465  *     // Declare a set state variable
466  *     EnumerableSet.AddressSet private mySet;
467  * }
468  * ```
469  *
470  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
471  * (`UintSet`) are supported.
472  */
473 library EnumerableSet {
474     // To implement this library for multiple types with as little code
475     // repetition as possible, we write it in terms of a generic Set type with
476     // bytes32 values.
477     // The Set implementation uses private functions, and user-facing
478     // implementations (such as AddressSet) are just wrappers around the
479     // underlying Set.
480     // This means that we can only create new EnumerableSets for types that fit
481     // in bytes32.
482 
483     struct Set {
484         // Storage of set values
485         bytes32[] _values;
486 
487         // Position of the value in the `values` array, plus 1 because index 0
488         // means a value is not in the set.
489         mapping (bytes32 => uint256) _indexes;
490     }
491 
492     /**
493      * @dev Add a value to a set. O(1).
494      *
495      * Returns true if the value was added to the set, that is if it was not
496      * already present.
497      */
498     function _add(Set storage set, bytes32 value) private returns (bool) {
499         if (!_contains(set, value)) {
500             set._values.push(value);
501             // The value is stored at length-1, but we add 1 to all indexes
502             // and use 0 as a sentinel value
503             set._indexes[value] = set._values.length;
504             return true;
505         } else {
506             return false;
507         }
508     }
509 
510     /**
511      * @dev Removes a value from a set. O(1).
512      *
513      * Returns true if the value was removed from the set, that is if it was
514      * present.
515      */
516     function _remove(Set storage set, bytes32 value) private returns (bool) {
517         // We read and store the value's index to prevent multiple reads from the same storage slot
518         uint256 valueIndex = set._indexes[value];
519 
520         if (valueIndex != 0) { // Equivalent to contains(set, value)
521             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
522             // the array, and then remove the last element (sometimes called as 'swap and pop').
523             // This modifies the order of the array, as noted in {at}.
524 
525             uint256 toDeleteIndex = valueIndex - 1;
526             uint256 lastIndex = set._values.length - 1;
527 
528             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
529             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
530 
531             bytes32 lastvalue = set._values[lastIndex];
532 
533             // Move the last value to the index where the value to delete is
534             set._values[toDeleteIndex] = lastvalue;
535             // Update the index for the moved value
536             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
537 
538             // Delete the slot where the moved value was stored
539             set._values.pop();
540 
541             // Delete the index for the deleted slot
542             delete set._indexes[value];
543 
544             return true;
545         } else {
546             return false;
547         }
548     }
549 
550     /**
551      * @dev Returns true if the value is in the set. O(1).
552      */
553     function _contains(Set storage set, bytes32 value) private view returns (bool) {
554         return set._indexes[value] != 0;
555     }
556 
557     /**
558      * @dev Returns the number of values on the set. O(1).
559      */
560     function _length(Set storage set) private view returns (uint256) {
561         return set._values.length;
562     }
563 
564    /**
565     * @dev Returns the value stored at position `index` in the set. O(1).
566     *
567     * Note that there are no guarantees on the ordering of values inside the
568     * array, and it may change when more values are added or removed.
569     *
570     * Requirements:
571     *
572     * - `index` must be strictly less than {length}.
573     */
574     function _at(Set storage set, uint256 index) private view returns (bytes32) {
575         require(set._values.length > index, "EnumerableSet: index out of bounds");
576         return set._values[index];
577     }
578 
579     // AddressSet
580 
581     struct AddressSet {
582         Set _inner;
583     }
584 
585     /**
586      * @dev Add a value to a set. O(1).
587      *
588      * Returns true if the value was added to the set, that is if it was not
589      * already present.
590      */
591     function add(AddressSet storage set, address value) internal returns (bool) {
592         return _add(set._inner, bytes32(uint256(value)));
593     }
594 
595     /**
596      * @dev Removes a value from a set. O(1).
597      *
598      * Returns true if the value was removed from the set, that is if it was
599      * present.
600      */
601     function remove(AddressSet storage set, address value) internal returns (bool) {
602         return _remove(set._inner, bytes32(uint256(value)));
603     }
604 
605     /**
606      * @dev Returns true if the value is in the set. O(1).
607      */
608     function contains(AddressSet storage set, address value) internal view returns (bool) {
609         return _contains(set._inner, bytes32(uint256(value)));
610     }
611 
612     /**
613      * @dev Returns the number of values in the set. O(1).
614      */
615     function length(AddressSet storage set) internal view returns (uint256) {
616         return _length(set._inner);
617     }
618 
619    /**
620     * @dev Returns the value stored at position `index` in the set. O(1).
621     *
622     * Note that there are no guarantees on the ordering of values inside the
623     * array, and it may change when more values are added or removed.
624     *
625     * Requirements:
626     *
627     * - `index` must be strictly less than {length}.
628     */
629     function at(AddressSet storage set, uint256 index) internal view returns (address) {
630         return address(uint256(_at(set._inner, index)));
631     }
632 
633 
634     // UintSet
635 
636     struct UintSet {
637         Set _inner;
638     }
639 
640     /**
641      * @dev Add a value to a set. O(1).
642      *
643      * Returns true if the value was added to the set, that is if it was not
644      * already present.
645      */
646     function add(UintSet storage set, uint256 value) internal returns (bool) {
647         return _add(set._inner, bytes32(value));
648     }
649 
650     /**
651      * @dev Removes a value from a set. O(1).
652      *
653      * Returns true if the value was removed from the set, that is if it was
654      * present.
655      */
656     function remove(UintSet storage set, uint256 value) internal returns (bool) {
657         return _remove(set._inner, bytes32(value));
658     }
659 
660     /**
661      * @dev Returns true if the value is in the set. O(1).
662      */
663     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
664         return _contains(set._inner, bytes32(value));
665     }
666 
667     /**
668      * @dev Returns the number of values on the set. O(1).
669      */
670     function length(UintSet storage set) internal view returns (uint256) {
671         return _length(set._inner);
672     }
673 
674    /**
675     * @dev Returns the value stored at position `index` in the set. O(1).
676     *
677     * Note that there are no guarantees on the ordering of values inside the
678     * array, and it may change when more values are added or removed.
679     *
680     * Requirements:
681     *
682     * - `index` must be strictly less than {length}.
683     */
684     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
685         return uint256(_at(set._inner, index));
686     }
687 }
688 
689 
690 
691 /*
692  * @dev Provides information about the current execution context, including the
693  * sender of the transaction and its data. While these are generally available
694  * via msg.sender and msg.data, they should not be accessed in such a direct
695  * manner, since when dealing with GSN meta-transactions the account sending and
696  * paying for execution may not be the actual sender (as far as an application
697  * is concerned).
698  *
699  * This contract is only required for intermediate, library-like contracts.
700  */
701 abstract contract Context {
702     function _msgSender() internal view virtual returns (address payable) {
703         return msg.sender;
704     }
705 
706     function _msgData() internal view virtual returns (bytes memory) {
707         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
708         return msg.data;
709     }
710 }
711 
712 
713 
714 
715 /**
716  * @dev Contract module which provides a basic access control mechanism, where
717  * there is an account (an owner) that can be granted exclusive access to
718  * specific functions.
719  *
720  * By default, the owner account will be the one that deploys the contract. This
721  * can later be changed with {transferOwnership}.
722  *
723  * This module is used through inheritance. It will make available the modifier
724  * `onlyOwner`, which can be applied to your functions to restrict their use to
725  * the owner.
726  */
727 contract Ownable is Context {
728     address private _owner;
729 
730     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
731 
732     /**
733      * @dev Initializes the contract setting the deployer as the initial owner.
734      */
735     constructor () internal {
736         address msgSender = _msgSender();
737         _owner = msgSender;
738         emit OwnershipTransferred(address(0), msgSender);
739     }
740 
741     /**
742      * @dev Returns the address of the current owner.
743      */
744     function owner() public view returns (address) {
745         return _owner;
746     }
747 
748     /**
749      * @dev Throws if called by any account other than the owner.
750      */
751     modifier onlyOwner() {
752         require(_owner == _msgSender(), "Ownable: caller is not the owner");
753         _;
754     }
755 
756     /**
757      * @dev Leaves the contract without owner. It will not be possible to call
758      * `onlyOwner` functions anymore. Can only be called by the current owner.
759      *
760      * NOTE: Renouncing ownership will leave the contract without an owner,
761      * thereby removing any functionality that is only available to the owner.
762      */
763     function renounceOwnership() public virtual onlyOwner {
764         emit OwnershipTransferred(_owner, address(0));
765         _owner = address(0);
766     }
767 
768     /**
769      * @dev Transfers ownership of the contract to a new account (`newOwner`).
770      * Can only be called by the current owner.
771      */
772     function transferOwnership(address newOwner) public virtual onlyOwner {
773         require(newOwner != address(0), "Ownable: new owner is the zero address");
774         emit OwnershipTransferred(_owner, newOwner);
775         _owner = newOwner;
776     }
777 }
778 
779 
780 
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
1033      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1034      *
1035      * This is internal function is equivalent to `approve`, and can be used to
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
1081 
1082 
1083 contract MyToken is ERC20("IDMOToken", "IDMO"), Ownable {
1084     
1085     function mint(address _to, uint256 _amount) public onlyOwner {
1086         _mint(_to, _amount);
1087     }
1088 }
1089 
1090 
1091 
1092 
1093 pragma experimental ABIEncoderV2;
1094 
1095 contract IDMO is Ownable {
1096     using SafeMath for uint256;
1097     using SafeERC20 for IERC20;
1098 
1099     // Info of each user.
1100     struct UserInfo {
1101         uint256 amount;     
1102         uint256 rewardDebt; 
1103 		uint256 lock_expire; 
1104 		uint256 lock_amount; 
1105     }
1106 
1107     // Info of each pool.
1108     struct PoolInfo {
1109         IERC20 lpToken;           
1110 		uint256 amount;           
1111         uint256 allocPoint;       
1112         uint256 lastRewardBlock;  
1113         uint256 accPerShare; 
1114     }
1115 	
1116 	struct TokenParam{
1117 		address myTokenAddr;   	
1118 		address devAddr; 	   	
1119 		uint amount1st;  		
1120 		uint blkNum1st;  		
1121 		uint amount2nd;  		
1122 		uint blkNum2nd;  		
1123 		uint amount3rd;  		
1124 		uint blkNum3rd;  		
1125 		uint feeRate;    		
1126 		uint blkNumPriMine; 
1127 	}	
1128 	 
1129 	mapping (uint256 => mapping(uint256 => PoolInfo)) public poolInfo;
1130 	
1131 	mapping (uint256 => mapping(uint256 => mapping (address => UserInfo))) public userInfo; 
1132 	
1133 	 
1134 	mapping(uint256=>uint256) public totalAllocPoint;
1135 	
1136 	 
1137 	mapping(uint256=>uint256) public startBlock; 
1138 	
1139 	uint256 public tokenIndex; 
1140 	
1141 	 
1142 	mapping(uint256=>TokenParam) public tokenInfo; 
1143 	
1144 	mapping(uint256=>uint256) public poolNum;   
1145 
1146 	address public delegateContract;  
1147 	
1148 	mapping(address=>uint256) public mapTokenExist;
1149 	
1150 	event Deposit(address indexed user, uint256 indexed tokenid, uint256 indexed pid, uint256 amount);
1151     event Withdraw(address indexed user, uint256 indexed tokenid, uint256 indexed pid, uint256 amount);
1152     event EmergencyWithdraw(address indexed user, uint256 indexed tokenid, uint256 indexed pid, uint256 amount);
1153 	
1154 	modifier onlyControl(){ 
1155 		address contractOwner = owner();
1156 		require((msg.sender == contractOwner || msg.sender == delegateContract), "Caller error.");
1157 		_;
1158 	}
1159 	modifier onlyDelegate(){ 
1160 		require(msg.sender == delegateContract, "caller error");
1161 		_;
1162 	}
1163 	
1164 	
1165 	function setDelegateContract(address _addr) public onlyOwner{
1166 		
1167 		delegateContract = _addr;
1168 	}
1169 	
1170 	function isTokenExist(address tokenAddr) public  view{
1171 		require(mapTokenExist[tokenAddr] == 0, "token exists");
1172 	}
1173 	
1174 	
1175 	
1176 	function checkTokenParam(TokenParam memory tokenParam) public  view{
1177 		require(tokenParam.myTokenAddr != address(0), "myTokenAddr error");
1178 		isTokenExist(tokenParam.myTokenAddr);
1179 		require(tokenParam.devAddr != address(0), "devAddr error");
1180 		require(((tokenParam.amount1st>0 && tokenParam.blkNum1st>=10000) || (tokenParam.amount1st==0 && tokenParam.blkNum1st==0)), "amount1st blkNum1st error");
1181 		require(((tokenParam.amount2nd>0 && tokenParam.blkNum2nd>=10000) || (tokenParam.amount2nd==0 && tokenParam.blkNum2nd==0)), "amount2nd blkNum2nd error");
1182 		require(((tokenParam.amount3rd>0 && tokenParam.blkNum3rd>=10000) || (tokenParam.amount3rd==0 && tokenParam.blkNum3rd==0)), "amount3rd blkNum3rd error");
1183 		require((tokenParam.feeRate>0 && tokenParam.feeRate<=20), "feeRate error");
1184 		require(tokenParam.blkNumPriMine >= 10000, "blkNumPriMine error");
1185 	}
1186 	
1187 	
1188 	constructor(TokenParam memory tokenParam) public {
1189         checkTokenParam(tokenParam);
1190 		tokenInfo[tokenIndex] = tokenParam;
1191 		tokenIndex = tokenIndex + 1;
1192 		mapTokenExist[tokenParam.myTokenAddr] = 1;
1193     }
1194 
1195 	function addToken(TokenParam memory tokenParam) public onlyControl returns(uint256){
1196 		checkTokenParam(tokenParam);
1197 		tokenInfo[tokenIndex] = tokenParam;
1198 		uint tokenId = tokenIndex;
1199 		tokenIndex = tokenIndex + 1;
1200 		mapTokenExist[tokenParam.myTokenAddr] = 1;
1201 		return tokenId;
1202 	}
1203 	
1204 
1205 	function setStartBlock(uint tokenId, uint _startBlk) public onlyControl{
1206 		require(tokenId < tokenIndex);
1207 		require(startBlock[tokenId] == 0);
1208 		require(_startBlk > block.number);
1209 		startBlock[tokenId] = _startBlk;
1210 
1211 		uint256 length = poolNum[tokenId];
1212         for (uint256 pid = 0; pid < length; ++pid) {
1213             poolInfo[tokenId][pid].lastRewardBlock = _startBlk;
1214         }
1215 	}
1216 	
1217 
1218 	function poolLength(uint tokenId) external view returns (uint256) {
1219         return poolNum[tokenId];
1220     }
1221 
1222 
1223 	function addPool(uint tokenId, uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyControl {
1224         if (_withUpdate) {
1225             massUpdatePools(tokenId);
1226         }
1227         uint256 lastRewardBlock = block.number > startBlock[tokenId] ? block.number : startBlock[tokenId];
1228         totalAllocPoint[tokenId] = totalAllocPoint[tokenId].add(_allocPoint);
1229         poolInfo[tokenId][poolNum[tokenId]] = PoolInfo({
1230             lpToken: _lpToken,
1231 			amount: 0,
1232             allocPoint: _allocPoint,
1233             lastRewardBlock: lastRewardBlock,
1234             accPerShare: 0
1235         });
1236 		poolNum[tokenId] = poolNum[tokenId].add(1);
1237     }
1238 	
1239 
1240 	function setPool(uint tokenId, uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyControl {
1241         if (_withUpdate) {
1242             massUpdatePools(tokenId);
1243         }
1244         totalAllocPoint[tokenId] = totalAllocPoint[tokenId].sub(poolInfo[tokenId][_pid].allocPoint).add(_allocPoint);
1245         poolInfo[tokenId][_pid].allocPoint = _allocPoint;
1246     }
1247 	
1248 
1249 	function pendingToken(uint tokenId, uint256 _pid, address _user) external view returns (uint256) {
1250         PoolInfo storage pool = poolInfo[tokenId][_pid];
1251         UserInfo storage user = userInfo[tokenId][_pid][_user];
1252         uint256 accPerShare = pool.accPerShare;
1253 		if(startBlock[tokenId] == 0){
1254 			return 0;
1255 		}
1256 
1257 		uint256 lpSupply = pool.amount;
1258         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1259             uint256 multiplier = getMultiplier(tokenId, pool.lastRewardBlock, block.number);
1260             uint256 tokenReward = multiplier.mul(pool.allocPoint).div(totalAllocPoint[tokenId]);
1261             accPerShare = accPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1262         }
1263         return user.amount.mul(accPerShare).div(1e12).sub(user.rewardDebt);
1264     }
1265 	
1266 
1267 	function massUpdatePools(uint tokenId) public {
1268         uint256 length = poolNum[tokenId];
1269         for (uint256 pid = 0; pid < length; ++pid) {
1270             updatePool(tokenId, pid);
1271         }
1272     }
1273 
1274 
1275 	function updatePool(uint tokenId, uint256 _pid) public {
1276 		require(tokenId < tokenIndex);
1277         PoolInfo storage pool = poolInfo[tokenId][_pid];
1278 		TokenParam storage pram = tokenInfo[tokenId];
1279         if (block.number <= pool.lastRewardBlock) {
1280             return;
1281         }
1282 		if(startBlock[tokenId] == 0){
1283 			return;
1284 		}
1285 
1286 		uint256 lpSupply = pool.amount;
1287         if (lpSupply == 0) {
1288             pool.lastRewardBlock = block.number;
1289             return;
1290         }
1291         uint256 multiplier = getMultiplier(tokenId, pool.lastRewardBlock, block.number);
1292         uint256 tokenReward = multiplier.mul(pool.allocPoint).div(totalAllocPoint[tokenId]);
1293         MyToken(pram.myTokenAddr).mint(pram.devAddr, tokenReward.mul(pram.feeRate).div(100));
1294         MyToken(pram.myTokenAddr).mint(address(this), tokenReward);
1295         pool.accPerShare = pool.accPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1296         pool.lastRewardBlock = block.number;
1297     }
1298 
1299 
1300 
1301 	function deposit(uint tokenId, uint256 _pid, uint256 _amount) public {
1302 		if(tokenId != 0){
1303 			require(startBlock[tokenId] != 0);
1304 			require(tokenInfo[tokenId].blkNumPriMine + startBlock[tokenId] <= block.number, "priority period");
1305 		}
1306         PoolInfo storage pool = poolInfo[tokenId][_pid];
1307         UserInfo storage user = userInfo[tokenId][_pid][msg.sender];
1308         updatePool(tokenId, _pid);
1309 		
1310         if (user.amount > 0) {
1311             uint256 pending = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
1312             safeTokenTransfer(tokenId, msg.sender, pending);
1313         }
1314         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1315         user.amount = user.amount.add(_amount);
1316 		pool.amount = pool.amount.add(_amount);
1317         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
1318         emit Deposit(msg.sender,tokenId, _pid, _amount);
1319     }
1320 	
1321 
1322 	function delegateDeposit(address _user, uint tokenId, uint256 _pid, uint256 _amount, uint256 _lock_expire)  public onlyDelegate{
1323 		PoolInfo storage pool = poolInfo[tokenId][_pid];
1324 		UserInfo storage user = userInfo[tokenId][_pid][_user];
1325 		updatePool(tokenId, _pid);
1326 		if (user.amount > 0) {
1327             uint256 pending = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
1328             safeTokenTransfer(tokenId, _user, pending);
1329         }
1330 		pool.lpToken.safeTransferFrom(delegateContract, address(this), _amount);
1331         user.amount = user.amount.add(_amount);
1332 		user.lock_amount = user.lock_amount.add(_amount);
1333 		user.lock_expire = _lock_expire;
1334 		pool.amount = pool.amount.add(_amount);
1335         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
1336         emit Deposit(_user,tokenId, _pid, _amount);
1337 	}
1338 	
1339 
1340     function withdraw(uint tokenId, uint256 _pid, uint256 _amount) public {
1341         PoolInfo storage pool = poolInfo[tokenId][_pid];
1342         UserInfo storage user = userInfo[tokenId][_pid][msg.sender];
1343         require(user.amount >= _amount, "withdraw: not good");
1344 		if(user.lock_expire != 0){
1345 			if(user.lock_expire > now){ 
1346 				require(user.amount.sub(user.lock_amount) >= _amount,"lock amount");
1347 			}
1348 			else{ 
1349 				user.lock_expire = 0;
1350 				user.lock_amount = 0;
1351 			}
1352 		}
1353         updatePool(tokenId, _pid);
1354         uint256 pending = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
1355         safeTokenTransfer(tokenId, msg.sender, pending);
1356         user.amount = user.amount.sub(_amount);
1357 		pool.amount = pool.amount.sub(_amount);
1358         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
1359         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1360         emit Withdraw(msg.sender,tokenId, _pid, _amount);
1361     }
1362 
1363 	function safeTokenTransfer(uint tokenId, address _to, uint256 _amount) internal {
1364 		TokenParam storage pram = tokenInfo[tokenId];
1365 		uint256 Bal = ERC20(pram.myTokenAddr).balanceOf(address(this));
1366         if (_amount > Bal) {
1367             ERC20(pram.myTokenAddr).transfer(_to, Bal);
1368         } else {
1369             ERC20(pram.myTokenAddr).transfer(_to, _amount);
1370         }
1371     }
1372 
1373 	function getMultiplier(uint tokenId, uint256 _from, uint256 _to) public view returns (uint256) {
1374 		TokenParam storage pram = tokenInfo[tokenId];
1375 		uint start = startBlock[tokenId];
1376 		uint bonusEndBlock = start.add(pram.blkNum1st);
1377 		
1378 		if(_to <= bonusEndBlock.add(pram.blkNum2nd)){
1379 			if(_to <= bonusEndBlock){
1380 				if(pram.blkNum1st == 0){
1381 					return 0;
1382 				}
1383 				else{
1384 					return _to.sub(_from).mul(pram.amount1st).div(pram.blkNum1st).mul(100).div(pram.feeRate.add(100));
1385 				}
1386 			}
1387 			else if(_from >= bonusEndBlock){
1388 				if(pram.blkNum2nd == 0){
1389 					return 0;
1390 				}
1391 				else{
1392 					return _to.sub(_from).mul(pram.amount2nd).div(pram.blkNum2nd).mul(100).div(pram.feeRate.add(100));
1393 				}
1394 			}
1395 			else{
1396 				uint first;
1397 				uint sec;
1398 				if(pram.blkNum1st == 0){
1399 					first = 0;
1400 				}
1401 				else{
1402 					first =  bonusEndBlock.sub(_from).mul(pram.amount1st).div(pram.blkNum1st);
1403 				}
1404 				if(pram.blkNum2nd == 0){
1405 					sec = 0;
1406 				}
1407 				else{
1408 					sec = _to.sub(bonusEndBlock).mul(pram.amount2nd).div(pram.blkNum2nd);
1409 				}
1410 			    return first.add(sec).mul(100).div(pram.feeRate.add(100));
1411 			}
1412 		}
1413 		else{
1414 			if(pram.blkNum3rd == 0){
1415 				return 0;
1416 			}
1417 			uint blockHalfstart = bonusEndBlock.add(pram.blkNum2nd);
1418 			uint num = _to.sub(blockHalfstart).div(pram.blkNum3rd).add(1);
1419 			uint perBlock = pram.amount3rd.div(2 ** num).div(pram.blkNum3rd);
1420 			return _to.sub(_from).mul(perBlock).mul(100).div(pram.feeRate.add(100));
1421 		}
1422     }
1423 
1424 	function dev(uint tokenId, address _devAddr) public {
1425         require(msg.sender == tokenInfo[tokenId].devAddr, "dev: wut?");
1426         tokenInfo[tokenId].devAddr = _devAddr;
1427     }
1428 	
1429 
1430 	function viewPoolInfo(uint tokenId) public view returns (PoolInfo[] memory){
1431 		uint256 length = poolNum[tokenId];
1432 		PoolInfo[] memory ret = new PoolInfo[](length);
1433 		for (uint256 pid = 0; pid < length; ++pid) {
1434             ret[pid] = poolInfo[tokenId][pid];
1435         }
1436 		return ret;
1437 	}
1438 	
1439 
1440 	function viewTokenInfo() public view returns (TokenParam[] memory){
1441 		TokenParam [] memory ret = new TokenParam[](tokenIndex);
1442 		for(uint256 index = 0; index < tokenIndex; ++index){
1443 			ret[index]=tokenInfo[index];
1444 		}
1445 		return ret;
1446 	}
1447 }