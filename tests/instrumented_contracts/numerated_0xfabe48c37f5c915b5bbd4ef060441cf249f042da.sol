1 pragma solidity ^0.6.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 pragma solidity ^0.6.0;
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 pragma solidity ^0.6.2;
236 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies in extcodesize, which returns 0 for contracts in
260         // construction, since the code is only stored at the end of the
261         // constructor execution.
262 
263         uint256 size;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { size := extcodesize(account) }
266         return size > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain`call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312       return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return _functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         return _functionCallWithValue(target, data, value, errorMessage);
349     }
350 
351     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
352         require(isContract(target), "Address: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
356         if (success) {
357             return returndata;
358         } else {
359             // Look for revert reason and bubble it up if present
360             if (returndata.length > 0) {
361                 // The easiest way to bubble the revert reason is using memory via assembly
362 
363                 // solhint-disable-next-line no-inline-assembly
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 pragma solidity ^0.6.0;
376 
377 
378 
379 
380 /**
381  * @title SafeERC20
382  * @dev Wrappers around ERC20 operations that throw on failure (when the token
383  * contract returns false). Tokens that return no value (and instead revert or
384  * throw on failure) are also supported, non-reverting calls are assumed to be
385  * successful.
386  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
387  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
388  */
389 library SafeERC20 {
390     using SafeMath for uint256;
391     using Address for address;
392 
393     function safeTransfer(IERC20 token, address to, uint256 value) internal {
394         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
395     }
396 
397     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
398         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
399     }
400 
401     /**
402      * @dev Deprecated. This function has issues similar to the ones found in
403      * {IERC20-approve}, and its usage is discouraged.
404      *
405      * Whenever possible, use {safeIncreaseAllowance} and
406      * {safeDecreaseAllowance} instead.
407      */
408     function safeApprove(IERC20 token, address spender, uint256 value) internal {
409         // safeApprove should only be called when setting an initial allowance,
410         // or when resetting it to zero. To increase and decrease it, use
411         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
412         // solhint-disable-next-line max-line-length
413         require((value == 0) || (token.allowance(address(this), spender) == 0),
414             "SafeERC20: approve from non-zero to non-zero allowance"
415         );
416         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
417     }
418 
419     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
420         uint256 newAllowance = token.allowance(address(this), spender).add(value);
421         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
422     }
423 
424     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
425         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
426         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
427     }
428 
429     /**
430      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
431      * on the return value: the return value is optional (but if data is returned, it must not be false).
432      * @param token The token targeted by the call.
433      * @param data The call data (encoded using abi.encode or one of its variants).
434      */
435     function _callOptionalReturn(IERC20 token, bytes memory data) private {
436         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
437         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
438         // the target address contains contract code and also asserts for success in the low-level call.
439 
440         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
441         if (returndata.length > 0) { // Return data is optional
442             // solhint-disable-next-line max-line-length
443             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
444         }
445     }
446 }
447 
448 pragma solidity ^0.6.0;
449 
450 /**
451  * @dev Library for managing
452  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
453  * types.
454  *
455  * Sets have the following properties:
456  *
457  * - Elements are added, removed, and checked for existence in constant time
458  * (O(1)).
459  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
460  *
461  * ```
462  * contract Example {
463  *     // Add the library methods
464  *     using EnumerableSet for EnumerableSet.AddressSet;
465  *
466  *     // Declare a set state variable
467  *     EnumerableSet.AddressSet private mySet;
468  * }
469  * ```
470  *
471  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
472  * (`UintSet`) are supported.
473  */
474 library EnumerableSet {
475     // To implement this library for multiple types with as little code
476     // repetition as possible, we write it in terms of a generic Set type with
477     // bytes32 values.
478     // The Set implementation uses private functions, and user-facing
479     // implementations (such as AddressSet) are just wrappers around the
480     // underlying Set.
481     // This means that we can only create new EnumerableSets for types that fit
482     // in bytes32.
483 
484     struct Set {
485         // Storage of set values
486         bytes32[] _values;
487 
488         // Position of the value in the `values` array, plus 1 because index 0
489         // means a value is not in the set.
490         mapping (bytes32 => uint256) _indexes;
491     }
492 
493     /**
494      * @dev Add a value to a set. O(1).
495      *
496      * Returns true if the value was added to the set, that is if it was not
497      * already present.
498      */
499     function _add(Set storage set, bytes32 value) private returns (bool) {
500         if (!_contains(set, value)) {
501             set._values.push(value);
502             // The value is stored at length-1, but we add 1 to all indexes
503             // and use 0 as a sentinel value
504             set._indexes[value] = set._values.length;
505             return true;
506         } else {
507             return false;
508         }
509     }
510 
511     /**
512      * @dev Removes a value from a set. O(1).
513      *
514      * Returns true if the value was removed from the set, that is if it was
515      * present.
516      */
517     function _remove(Set storage set, bytes32 value) private returns (bool) {
518         // We read and store the value's index to prevent multiple reads from the same storage slot
519         uint256 valueIndex = set._indexes[value];
520 
521         if (valueIndex != 0) { // Equivalent to contains(set, value)
522             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
523             // the array, and then remove the last element (sometimes called as 'swap and pop').
524             // This modifies the order of the array, as noted in {at}.
525 
526             uint256 toDeleteIndex = valueIndex - 1;
527             uint256 lastIndex = set._values.length - 1;
528 
529             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
530             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
531 
532             bytes32 lastvalue = set._values[lastIndex];
533 
534             // Move the last value to the index where the value to delete is
535             set._values[toDeleteIndex] = lastvalue;
536             // Update the index for the moved value
537             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
538 
539             // Delete the slot where the moved value was stored
540             set._values.pop();
541 
542             // Delete the index for the deleted slot
543             delete set._indexes[value];
544 
545             return true;
546         } else {
547             return false;
548         }
549     }
550 
551     /**
552      * @dev Returns true if the value is in the set. O(1).
553      */
554     function _contains(Set storage set, bytes32 value) private view returns (bool) {
555         return set._indexes[value] != 0;
556     }
557 
558     /**
559      * @dev Returns the number of values on the set. O(1).
560      */
561     function _length(Set storage set) private view returns (uint256) {
562         return set._values.length;
563     }
564 
565    /**
566     * @dev Returns the value stored at position `index` in the set. O(1).
567     *
568     * Note that there are no guarantees on the ordering of values inside the
569     * array, and it may change when more values are added or removed.
570     *
571     * Requirements:
572     *
573     * - `index` must be strictly less than {length}.
574     */
575     function _at(Set storage set, uint256 index) private view returns (bytes32) {
576         require(set._values.length > index, "EnumerableSet: index out of bounds");
577         return set._values[index];
578     }
579 
580     // AddressSet
581 
582     struct AddressSet {
583         Set _inner;
584     }
585 
586     /**
587      * @dev Add a value to a set. O(1).
588      *
589      * Returns true if the value was added to the set, that is if it was not
590      * already present.
591      */
592     function add(AddressSet storage set, address value) internal returns (bool) {
593         return _add(set._inner, bytes32(uint256(value)));
594     }
595 
596     /**
597      * @dev Removes a value from a set. O(1).
598      *
599      * Returns true if the value was removed from the set, that is if it was
600      * present.
601      */
602     function remove(AddressSet storage set, address value) internal returns (bool) {
603         return _remove(set._inner, bytes32(uint256(value)));
604     }
605 
606     /**
607      * @dev Returns true if the value is in the set. O(1).
608      */
609     function contains(AddressSet storage set, address value) internal view returns (bool) {
610         return _contains(set._inner, bytes32(uint256(value)));
611     }
612 
613     /**
614      * @dev Returns the number of values in the set. O(1).
615      */
616     function length(AddressSet storage set) internal view returns (uint256) {
617         return _length(set._inner);
618     }
619 
620    /**
621     * @dev Returns the value stored at position `index` in the set. O(1).
622     *
623     * Note that there are no guarantees on the ordering of values inside the
624     * array, and it may change when more values are added or removed.
625     *
626     * Requirements:
627     *
628     * - `index` must be strictly less than {length}.
629     */
630     function at(AddressSet storage set, uint256 index) internal view returns (address) {
631         return address(uint256(_at(set._inner, index)));
632     }
633 
634 
635     // UintSet
636 
637     struct UintSet {
638         Set _inner;
639     }
640 
641     /**
642      * @dev Add a value to a set. O(1).
643      *
644      * Returns true if the value was added to the set, that is if it was not
645      * already present.
646      */
647     function add(UintSet storage set, uint256 value) internal returns (bool) {
648         return _add(set._inner, bytes32(value));
649     }
650 
651     /**
652      * @dev Removes a value from a set. O(1).
653      *
654      * Returns true if the value was removed from the set, that is if it was
655      * present.
656      */
657     function remove(UintSet storage set, uint256 value) internal returns (bool) {
658         return _remove(set._inner, bytes32(value));
659     }
660 
661     /**
662      * @dev Returns true if the value is in the set. O(1).
663      */
664     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
665         return _contains(set._inner, bytes32(value));
666     }
667 
668     /**
669      * @dev Returns the number of values on the set. O(1).
670      */
671     function length(UintSet storage set) internal view returns (uint256) {
672         return _length(set._inner);
673     }
674 
675    /**
676     * @dev Returns the value stored at position `index` in the set. O(1).
677     *
678     * Note that there are no guarantees on the ordering of values inside the
679     * array, and it may change when more values are added or removed.
680     *
681     * Requirements:
682     *
683     * - `index` must be strictly less than {length}.
684     */
685     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
686         return uint256(_at(set._inner, index));
687     }
688 }
689 
690 pragma solidity ^0.6.0;
691 
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
713 pragma solidity ^0.6.0;
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
779 pragma solidity ^0.6.0;
780 
781 
782 
783 
784 
785 /**
786  * @dev Implementation of the {IERC20} interface.
787  *
788  * This implementation is agnostic to the way tokens are created. This means
789  * that a supply mechanism has to be added in a derived contract using {_mint}.
790  * For a generic mechanism see {ERC20PresetMinterPauser}.
791  *
792  * TIP: For a detailed writeup see our guide
793  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
794  * to implement supply mechanisms].
795  *
796  * We have followed general OpenZeppelin guidelines: functions revert instead
797  * of returning `false` on failure. This behavior is nonetheless conventional
798  * and does not conflict with the expectations of ERC20 applications.
799  *
800  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
801  * This allows applications to reconstruct the allowance for all accounts just
802  * by listening to said events. Other implementations of the EIP may not emit
803  * these events, as it isn't required by the specification.
804  *
805  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
806  * functions have been added to mitigate the well-known issues around setting
807  * allowances. See {IERC20-approve}.
808  */
809 contract ERC20 is Context, IERC20 {
810     using SafeMath for uint256;
811     using Address for address;
812 
813     mapping (address => uint256) private _balances;
814 
815     mapping (address => mapping (address => uint256)) private _allowances;
816 
817     uint256 private _totalSupply;
818 
819     string private _name;
820     string private _symbol;
821     uint8 private _decimals;
822 
823     /**
824      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
825      * a default value of 18.
826      *
827      * To select a different value for {decimals}, use {_setupDecimals}.
828      *
829      * All three of these values are immutable: they can only be set once during
830      * construction.
831      */
832     constructor (string memory name, string memory symbol) public {
833         _name = name;
834         _symbol = symbol;
835         _decimals = 18;
836     }
837 
838     /**
839      * @dev Returns the name of the token.
840      */
841     function name() public view returns (string memory) {
842         return _name;
843     }
844 
845     /**
846      * @dev Returns the symbol of the token, usually a shorter version of the
847      * name.
848      */
849     function symbol() public view returns (string memory) {
850         return _symbol;
851     }
852 
853     /**
854      * @dev Returns the number of decimals used to get its user representation.
855      * For example, if `decimals` equals `2`, a balance of `505` tokens should
856      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
857      *
858      * Tokens usually opt for a value of 18, imitating the relationship between
859      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
860      * called.
861      *
862      * NOTE: This information is only used for _display_ purposes: it in
863      * no way affects any of the arithmetic of the contract, including
864      * {IERC20-balanceOf} and {IERC20-transfer}.
865      */
866     function decimals() public view returns (uint8) {
867         return _decimals;
868     }
869 
870     /**
871      * @dev See {IERC20-totalSupply}.
872      */
873     function totalSupply() public view override returns (uint256) {
874         return _totalSupply;
875     }
876 
877     /**
878      * @dev See {IERC20-balanceOf}.
879      */
880     function balanceOf(address account) public view override returns (uint256) {
881         return _balances[account];
882     }
883 
884     /**
885      * @dev See {IERC20-transfer}.
886      *
887      * Requirements:
888      *
889      * - `recipient` cannot be the zero address.
890      * - the caller must have a balance of at least `amount`.
891      */
892     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
893         _transfer(_msgSender(), recipient, amount);
894         return true;
895     }
896 
897     /**
898      * @dev See {IERC20-allowance}.
899      */
900     function allowance(address owner, address spender) public view virtual override returns (uint256) {
901         return _allowances[owner][spender];
902     }
903 
904     /**
905      * @dev See {IERC20-approve}.
906      *
907      * Requirements:
908      *
909      * - `spender` cannot be the zero address.
910      */
911     function approve(address spender, uint256 amount) public virtual override returns (bool) {
912         _approve(_msgSender(), spender, amount);
913         return true;
914     }
915 
916     /**
917      * @dev See {IERC20-transferFrom}.
918      *
919      * Emits an {Approval} event indicating the updated allowance. This is not
920      * required by the EIP. See the note at the beginning of {ERC20};
921      *
922      * Requirements:
923      * - `sender` and `recipient` cannot be the zero address.
924      * - `sender` must have a balance of at least `amount`.
925      * - the caller must have allowance for ``sender``'s tokens of at least
926      * `amount`.
927      */
928     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
929         _transfer(sender, recipient, amount);
930         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
931         return true;
932     }
933 
934     /**
935      * @dev Atomically increases the allowance granted to `spender` by the caller.
936      *
937      * This is an alternative to {approve} that can be used as a mitigation for
938      * problems described in {IERC20-approve}.
939      *
940      * Emits an {Approval} event indicating the updated allowance.
941      *
942      * Requirements:
943      *
944      * - `spender` cannot be the zero address.
945      */
946     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
947         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
948         return true;
949     }
950 
951     /**
952      * @dev Atomically decreases the allowance granted to `spender` by the caller.
953      *
954      * This is an alternative to {approve} that can be used as a mitigation for
955      * problems described in {IERC20-approve}.
956      *
957      * Emits an {Approval} event indicating the updated allowance.
958      *
959      * Requirements:
960      *
961      * - `spender` cannot be the zero address.
962      * - `spender` must have allowance for the caller of at least
963      * `subtractedValue`.
964      */
965     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
966         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
967         return true;
968     }
969 
970     /**
971      * @dev Moves tokens `amount` from `sender` to `recipient`.
972      *
973      * This is internal function is equivalent to {transfer}, and can be used to
974      * e.g. implement automatic token fees, slashing mechanisms, etc.
975      *
976      * Emits a {Transfer} event.
977      *
978      * Requirements:
979      *
980      * - `sender` cannot be the zero address.
981      * - `recipient` cannot be the zero address.
982      * - `sender` must have a balance of at least `amount`.
983      */
984     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
985         require(sender != address(0), "ERC20: transfer from the zero address");
986         require(recipient != address(0), "ERC20: transfer to the zero address");
987 
988         _beforeTokenTransfer(sender, recipient, amount);
989 
990         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
991         _balances[recipient] = _balances[recipient].add(amount);
992         emit Transfer(sender, recipient, amount);
993     }
994 
995     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
996      * the total supply.
997      *
998      * Emits a {Transfer} event with `from` set to the zero address.
999      *
1000      * Requirements
1001      *
1002      * - `to` cannot be the zero address.
1003      */
1004     function _mint(address account, uint256 amount) internal virtual {
1005         require(account != address(0), "ERC20: mint to the zero address");
1006 
1007         _beforeTokenTransfer(address(0), account, amount);
1008 
1009         _totalSupply = _totalSupply.add(amount);
1010         _balances[account] = _balances[account].add(amount);
1011         emit Transfer(address(0), account, amount);
1012     }
1013 
1014     /**
1015      * @dev Destroys `amount` tokens from `account`, reducing the
1016      * total supply.
1017      *
1018      * Emits a {Transfer} event with `to` set to the zero address.
1019      *
1020      * Requirements
1021      *
1022      * - `account` cannot be the zero address.
1023      * - `account` must have at least `amount` tokens.
1024      */
1025     function _burn(address account, uint256 amount) internal virtual {
1026         require(account != address(0), "ERC20: burn from the zero address");
1027 
1028         _beforeTokenTransfer(account, address(0), amount);
1029 
1030         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1031         _totalSupply = _totalSupply.sub(amount);
1032         emit Transfer(account, address(0), amount);
1033     }
1034 
1035     /**
1036      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1037      *
1038      * This internal function is equivalent to `approve`, and can be used to
1039      * e.g. set automatic allowances for certain subsystems, etc.
1040      *
1041      * Emits an {Approval} event.
1042      *
1043      * Requirements:
1044      *
1045      * - `owner` cannot be the zero address.
1046      * - `spender` cannot be the zero address.
1047      */
1048     function _approve(address owner, address spender, uint256 amount) internal virtual {
1049         require(owner != address(0), "ERC20: approve from the zero address");
1050         require(spender != address(0), "ERC20: approve to the zero address");
1051 
1052         _allowances[owner][spender] = amount;
1053         emit Approval(owner, spender, amount);
1054     }
1055 
1056     /**
1057      * @dev Sets {decimals} to a value other than the default one of 18.
1058      *
1059      * WARNING: This function should only be called from the constructor. Most
1060      * applications that interact with token contracts will not expect
1061      * {decimals} to ever change, and may work incorrectly if it does.
1062      */
1063     function _setupDecimals(uint8 decimals_) internal {
1064         _decimals = decimals_;
1065     }
1066 
1067     /**
1068      * @dev Hook that is called before any transfer of tokens. This includes
1069      * minting and burning.
1070      *
1071      * Calling conditions:
1072      *
1073      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1074      * will be to transferred to `to`.
1075      * - when `from` is zero, `amount` tokens will be minted for `to`.
1076      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1077      * - `from` and `to` are never both zero.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1082 }
1083 
1084 pragma solidity 0.6.12;
1085 
1086 contract MiraqleDefi is ERC20("Miraqle Defi", "QFI"), Ownable {
1087     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (0x).
1088     function mint(address _to, uint256 _amount) public onlyOwner {
1089         _mint(_to, _amount);
1090     }
1091 }
1092 
1093 
1094 pragma solidity 0.6.12;
1095 
1096 
1097 interface IMigratorPool {
1098     function migrate(IERC20 token) external returns (IERC20);
1099 }
1100 
1101 
1102 contract QFIPool is Ownable {
1103     using SafeMath for uint256;
1104     using SafeERC20 for IERC20;
1105 
1106     struct UserInfo {
1107         uint256 amount;
1108         uint256 rewardDebt;
1109     }
1110 
1111     // Info of each pool.
1112     struct PoolInfo {
1113         IERC20 lpToken;
1114         uint256 allocPoint;
1115         uint256 lastRewardBlock;
1116         uint256 accTokenPerShare;
1117     }
1118 
1119     MiraqleDefi public token;
1120     address public teamAddr;
1121     uint256 public bonusEndBlock;
1122     uint256 public tokenPerBlock;
1123     uint256 public constant BONUS_MULTIPLIER = 2;
1124     IMigratorPool public migrator;
1125     PoolInfo[] public poolInfo;
1126     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1127     uint256 public totalAllocPoint;
1128     uint256 public startBlock;
1129 
1130     uint256 public endBlock;
1131 
1132     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1133     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1134     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1135 
1136     constructor(
1137         MiraqleDefi _token,
1138         address _teamAddr,
1139         uint256 _tokenPerBlock,
1140         uint256 _startBlock,
1141         uint256 _endBlock,
1142         uint256 _bonusEndBlock
1143     ) public {
1144         token = _token;
1145         teamAddr = _teamAddr;
1146         tokenPerBlock = _tokenPerBlock;
1147         startBlock = _startBlock;
1148         endBlock = _endBlock;
1149         bonusEndBlock = _bonusEndBlock;
1150     }
1151 
1152     function poolLength() external view returns (uint256) {
1153         return poolInfo.length;
1154     }
1155 
1156     // Add a new lp to the pool. Can only be called by the owner.
1157     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1158     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1159         if (_withUpdate) {
1160             massUpdatePools();
1161         }
1162         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1163         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1164         poolInfo.push(PoolInfo({
1165             lpToken: _lpToken,
1166             allocPoint: _allocPoint,
1167             lastRewardBlock: lastRewardBlock,
1168             accTokenPerShare: 0
1169         }));
1170     }
1171 
1172     // Update the given pool's Token allocation point. Can only be called by the owner.
1173     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1174         if (_withUpdate) {
1175             massUpdatePools();
1176         }
1177         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1178         poolInfo[_pid].allocPoint = _allocPoint;
1179     }
1180 
1181     // Set the migrator contract. Can only be called by the owner.
1182     function setMigrator(IMigratorPool _migrator) public onlyOwner {
1183         migrator = _migrator;
1184     }
1185 
1186     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1187     function migrate(uint256 _pid) public {
1188         require(address(migrator) != address(0), "migrate: no migrator");
1189         PoolInfo storage pool = poolInfo[_pid];
1190         IERC20 lpToken = pool.lpToken;
1191         uint256 bal = lpToken.balanceOf(address(this));
1192         lpToken.safeApprove(address(migrator), bal);
1193         IERC20 newLpToken = migrator.migrate(lpToken);
1194         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1195         pool.lpToken = newLpToken;
1196     }
1197 
1198     // Return reward multiplier over the given _from to _to block.
1199     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1200         if (_to <= bonusEndBlock) {
1201             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1202         } else if (_from >= bonusEndBlock) {
1203             return _to.sub(_from);
1204         } else {
1205             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1206                 _to.sub(bonusEndBlock)
1207             );
1208         }
1209     }
1210 
1211     // View function to see pending Tokens on frontend.
1212     function pendingToken(uint256 _pid, address _user) external view returns (uint256) {
1213         PoolInfo storage pool = poolInfo[_pid];
1214         UserInfo storage user = userInfo[_pid][_user];
1215         uint256 accTokenPerShare = pool.accTokenPerShare;
1216         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1217 
1218         uint256 blockNumber = 0;
1219         if(block.number > endBlock)
1220             blockNumber = endBlock;
1221         else
1222             blockNumber = block.number;
1223         
1224         if (blockNumber > pool.lastRewardBlock && lpSupply != 0) {
1225             uint256 multiplier = getMultiplier(pool.lastRewardBlock, blockNumber);
1226             uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1227             accTokenPerShare = accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1228         }
1229         return user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
1230     }
1231 
1232     // Update reward vairables for all pools. Be careful of gas spending!
1233     function massUpdatePools() public {
1234         uint256 length = poolInfo.length;
1235         for (uint256 pid = 0; pid < length; ++pid) {
1236             updatePool(pid);
1237         }
1238     }
1239 
1240     // Update reward variables of the given pool to be up-to-date.
1241     function updatePool(uint256 _pid) public {
1242         PoolInfo storage pool = poolInfo[_pid];
1243         if (block.number <= pool.lastRewardBlock) {
1244             return;
1245         }
1246         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1247         if (lpSupply == 0) {
1248             if (block.number > endBlock)
1249                 pool.lastRewardBlock = endBlock;
1250             else
1251                 pool.lastRewardBlock = block.number;
1252             return;
1253         }
1254         if (pool.lastRewardBlock == endBlock){
1255             return;
1256         }
1257 
1258         if (block.number > endBlock){
1259             uint256 multiplier = getMultiplier(pool.lastRewardBlock, endBlock);
1260             uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1261             //token.mint(teamAddr, tokenReward.div(10));
1262             //token.mint(address(this), tokenReward);
1263             pool.accTokenPerShare = pool.accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1264             pool.lastRewardBlock = endBlock;
1265             return;
1266         }
1267 
1268         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1269         uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1270         //token.mint(teamAddr, tokenReward.div(10));
1271         //token.mint(address(this), tokenReward);
1272         pool.accTokenPerShare = pool.accTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1273         pool.lastRewardBlock = block.number;
1274         
1275     }
1276 
1277     // Deposit tokens to Pool for Token allocation.
1278     function deposit(uint256 _pid, uint256 _amount) public {
1279         PoolInfo storage pool = poolInfo[_pid];
1280         UserInfo storage user = userInfo[_pid][msg.sender];
1281 
1282         updatePool(_pid);
1283         if (user.amount > 0) {
1284             uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1285             safeTokenTransfer(msg.sender, pending);
1286         }
1287         if(_amount > 0) { //kevin
1288             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1289             user.amount = user.amount.add(_amount);
1290         }
1291         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1292         emit Deposit(msg.sender, _pid, _amount);
1293     }
1294     
1295     // DepositFor tokens to Pool for Token allocation.
1296     function depositFor(address _beneficiary, uint256 _pid, uint256 _amount) public {
1297         PoolInfo storage pool = poolInfo[_pid];
1298         UserInfo storage user = userInfo[_pid][_beneficiary];
1299         updatePool(_pid);
1300         if (user.amount > 0) {
1301             uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1302             safeTokenTransfer(_beneficiary, pending);
1303         }
1304         if(_amount > 0) { //kevin
1305             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1306             user.amount = user.amount.add(_amount);
1307         }
1308         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1309         emit Deposit(_beneficiary, _pid, _amount);
1310     }
1311 
1312     // Withdraw tokens from Pool.
1313     function withdraw(uint256 _pid, uint256 _amount) public {
1314         PoolInfo storage pool = poolInfo[_pid];
1315         UserInfo storage user = userInfo[_pid][msg.sender];
1316         require(user.amount >= _amount, "withdraw: not good");
1317         updatePool(_pid);
1318         uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1319         safeTokenTransfer(msg.sender, pending);
1320         user.amount = user.amount.sub(_amount);
1321         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1322         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1323         emit Withdraw(msg.sender, _pid, _amount);
1324     }
1325 
1326     // Withdraw without caring about rewards. EMERGENCY ONLY.
1327     function emergencyWithdraw(uint256 _pid) public {
1328         PoolInfo storage pool = poolInfo[_pid];
1329         UserInfo storage user = userInfo[_pid][msg.sender];
1330         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1331         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1332         user.amount = 0;
1333         user.rewardDebt = 0;
1334     }
1335 
1336     // Safe token transfer function, just in case if rounding error causes pool to not have enough Tokens.
1337     function safeTokenTransfer(address _to, uint256 _amount) internal {
1338         uint256 tokenBal = token.balanceOf(address(this));
1339         if (_amount > tokenBal) {
1340             token.transfer(_to, tokenBal);
1341         } else {
1342             token.transfer(_to, _amount);
1343         }
1344     }
1345 
1346     // Update team address by the previous team.
1347     function team(address _teamAddr) public {
1348         require(msg.sender == teamAddr, "dev: wut?");
1349         teamAddr = _teamAddr;
1350     }
1351 
1352 }