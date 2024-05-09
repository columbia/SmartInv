1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
80 
81 pragma solidity ^0.6.0;
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
239 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
240 
241 pragma solidity ^0.6.2;
242 
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
265         // This method relies in extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { size := extcodesize(account) }
272         return size > 0;
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
381 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
382 
383 pragma solidity ^0.6.0;
384 
385 
386 
387 
388 /**
389  * @title SafeERC20
390  * @dev Wrappers around ERC20 operations that throw on failure (when the token
391  * contract returns false). Tokens that return no value (and instead revert or
392  * throw on failure) are also supported, non-reverting calls are assumed to be
393  * successful.
394  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
395  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
396  */
397 library SafeERC20 {
398     using SafeMath for uint256;
399     using Address for address;
400 
401     function safeTransfer(IERC20 token, address to, uint256 value) internal {
402         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
403     }
404 
405     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
407     }
408 
409     /**
410      * @dev Deprecated. This function has issues similar to the ones found in
411      * {IERC20-approve}, and its usage is discouraged.
412      *
413      * Whenever possible, use {safeIncreaseAllowance} and
414      * {safeDecreaseAllowance} instead.
415      */
416     function safeApprove(IERC20 token, address spender, uint256 value) internal {
417         // safeApprove should only be called when setting an initial allowance,
418         // or when resetting it to zero. To increase and decrease it, use
419         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
420         // solhint-disable-next-line max-line-length
421         require((value == 0) || (token.allowance(address(this), spender) == 0),
422             "SafeERC20: approve from non-zero to non-zero allowance"
423         );
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
425     }
426 
427     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
428         uint256 newAllowance = token.allowance(address(this), spender).add(value);
429         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
430     }
431 
432     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
433         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435     }
436 
437     /**
438      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
439      * on the return value: the return value is optional (but if data is returned, it must not be false).
440      * @param token The token targeted by the call.
441      * @param data The call data (encoded using abi.encode or one of its variants).
442      */
443     function _callOptionalReturn(IERC20 token, bytes memory data) private {
444         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
445         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
446         // the target address contains contract code and also asserts for success in the low-level call.
447 
448         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
449         if (returndata.length > 0) { // Return data is optional
450             // solhint-disable-next-line max-line-length
451             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
452         }
453     }
454 }
455 
456 // File: @openzeppelin\contracts\utils\EnumerableSet.sol
457 
458 pragma solidity ^0.6.0;
459 
460 /**
461  * @dev Library for managing
462  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
463  * types.
464  *
465  * Sets have the following properties:
466  *
467  * - Elements are added, removed, and checked for existence in constant time
468  * (O(1)).
469  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
470  *
471  * ```
472  * contract Example {
473  *     // Add the library methods
474  *     using EnumerableSet for EnumerableSet.AddressSet;
475  *
476  *     // Declare a set state variable
477  *     EnumerableSet.AddressSet private mySet;
478  * }
479  * ```
480  *
481  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
482  * (`UintSet`) are supported.
483  */
484 library EnumerableSet {
485     // To implement this library for multiple types with as little code
486     // repetition as possible, we write it in terms of a generic Set type with
487     // bytes32 values.
488     // The Set implementation uses private functions, and user-facing
489     // implementations (such as AddressSet) are just wrappers around the
490     // underlying Set.
491     // This means that we can only create new EnumerableSets for types that fit
492     // in bytes32.
493 
494     struct Set {
495         // Storage of set values
496         bytes32[] _values;
497 
498         // Position of the value in the `values` array, plus 1 because index 0
499         // means a value is not in the set.
500         mapping (bytes32 => uint256) _indexes;
501     }
502 
503     /**
504      * @dev Add a value to a set. O(1).
505      *
506      * Returns true if the value was added to the set, that is if it was not
507      * already present.
508      */
509     function _add(Set storage set, bytes32 value) private returns (bool) {
510         if (!_contains(set, value)) {
511             set._values.push(value);
512             // The value is stored at length-1, but we add 1 to all indexes
513             // and use 0 as a sentinel value
514             set._indexes[value] = set._values.length;
515             return true;
516         } else {
517             return false;
518         }
519     }
520 
521     /**
522      * @dev Removes a value from a set. O(1).
523      *
524      * Returns true if the value was removed from the set, that is if it was
525      * present.
526      */
527     function _remove(Set storage set, bytes32 value) private returns (bool) {
528         // We read and store the value's index to prevent multiple reads from the same storage slot
529         uint256 valueIndex = set._indexes[value];
530 
531         if (valueIndex != 0) { // Equivalent to contains(set, value)
532             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
533             // the array, and then remove the last element (sometimes called as 'swap and pop').
534             // This modifies the order of the array, as noted in {at}.
535 
536             uint256 toDeleteIndex = valueIndex - 1;
537             uint256 lastIndex = set._values.length - 1;
538 
539             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
540             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
541 
542             bytes32 lastvalue = set._values[lastIndex];
543 
544             // Move the last value to the index where the value to delete is
545             set._values[toDeleteIndex] = lastvalue;
546             // Update the index for the moved value
547             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
548 
549             // Delete the slot where the moved value was stored
550             set._values.pop();
551 
552             // Delete the index for the deleted slot
553             delete set._indexes[value];
554 
555             return true;
556         } else {
557             return false;
558         }
559     }
560 
561     /**
562      * @dev Returns true if the value is in the set. O(1).
563      */
564     function _contains(Set storage set, bytes32 value) private view returns (bool) {
565         return set._indexes[value] != 0;
566     }
567 
568     /**
569      * @dev Returns the number of values on the set. O(1).
570      */
571     function _length(Set storage set) private view returns (uint256) {
572         return set._values.length;
573     }
574 
575    /**
576     * @dev Returns the value stored at position `index` in the set. O(1).
577     *
578     * Note that there are no guarantees on the ordering of values inside the
579     * array, and it may change when more values are added or removed.
580     *
581     * Requirements:
582     *
583     * - `index` must be strictly less than {length}.
584     */
585     function _at(Set storage set, uint256 index) private view returns (bytes32) {
586         require(set._values.length > index, "EnumerableSet: index out of bounds");
587         return set._values[index];
588     }
589 
590     // AddressSet
591 
592     struct AddressSet {
593         Set _inner;
594     }
595 
596     /**
597      * @dev Add a value to a set. O(1).
598      *
599      * Returns true if the value was added to the set, that is if it was not
600      * already present.
601      */
602     function add(AddressSet storage set, address value) internal returns (bool) {
603         return _add(set._inner, bytes32(uint256(value)));
604     }
605 
606     /**
607      * @dev Removes a value from a set. O(1).
608      *
609      * Returns true if the value was removed from the set, that is if it was
610      * present.
611      */
612     function remove(AddressSet storage set, address value) internal returns (bool) {
613         return _remove(set._inner, bytes32(uint256(value)));
614     }
615 
616     /**
617      * @dev Returns true if the value is in the set. O(1).
618      */
619     function contains(AddressSet storage set, address value) internal view returns (bool) {
620         return _contains(set._inner, bytes32(uint256(value)));
621     }
622 
623     /**
624      * @dev Returns the number of values in the set. O(1).
625      */
626     function length(AddressSet storage set) internal view returns (uint256) {
627         return _length(set._inner);
628     }
629 
630    /**
631     * @dev Returns the value stored at position `index` in the set. O(1).
632     *
633     * Note that there are no guarantees on the ordering of values inside the
634     * array, and it may change when more values are added or removed.
635     *
636     * Requirements:
637     *
638     * - `index` must be strictly less than {length}.
639     */
640     function at(AddressSet storage set, uint256 index) internal view returns (address) {
641         return address(uint256(_at(set._inner, index)));
642     }
643 
644 
645     // UintSet
646 
647     struct UintSet {
648         Set _inner;
649     }
650 
651     /**
652      * @dev Add a value to a set. O(1).
653      *
654      * Returns true if the value was added to the set, that is if it was not
655      * already present.
656      */
657     function add(UintSet storage set, uint256 value) internal returns (bool) {
658         return _add(set._inner, bytes32(value));
659     }
660 
661     /**
662      * @dev Removes a value from a set. O(1).
663      *
664      * Returns true if the value was removed from the set, that is if it was
665      * present.
666      */
667     function remove(UintSet storage set, uint256 value) internal returns (bool) {
668         return _remove(set._inner, bytes32(value));
669     }
670 
671     /**
672      * @dev Returns true if the value is in the set. O(1).
673      */
674     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
675         return _contains(set._inner, bytes32(value));
676     }
677 
678     /**
679      * @dev Returns the number of values on the set. O(1).
680      */
681     function length(UintSet storage set) internal view returns (uint256) {
682         return _length(set._inner);
683     }
684 
685    /**
686     * @dev Returns the value stored at position `index` in the set. O(1).
687     *
688     * Note that there are no guarantees on the ordering of values inside the
689     * array, and it may change when more values are added or removed.
690     *
691     * Requirements:
692     *
693     * - `index` must be strictly less than {length}.
694     */
695     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
696         return uint256(_at(set._inner, index));
697     }
698 }
699 
700 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
701 
702 pragma solidity ^0.6.0;
703 
704 /*
705  * @dev Provides information about the current execution context, including the
706  * sender of the transaction and its data. While these are generally available
707  * via msg.sender and msg.data, they should not be accessed in such a direct
708  * manner, since when dealing with GSN meta-transactions the account sending and
709  * paying for execution may not be the actual sender (as far as an application
710  * is concerned).
711  *
712  * This contract is only required for intermediate, library-like contracts.
713  */
714 abstract contract Context {
715     function _msgSender() internal view virtual returns (address payable) {
716         return msg.sender;
717     }
718 
719     function _msgData() internal view virtual returns (bytes memory) {
720         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
721         return msg.data;
722     }
723 }
724 
725 // File: @openzeppelin\contracts\access\Ownable.sol
726 
727 pragma solidity ^0.6.0;
728 
729 /**
730  * @dev Contract module which provides a basic access control mechanism, where
731  * there is an account (an owner) that can be granted exclusive access to
732  * specific functions.
733  *
734  * By default, the owner account will be the one that deploys the contract. This
735  * can later be changed with {transferOwnership}.
736  *
737  * This module is used through inheritance. It will make available the modifier
738  * `onlyOwner`, which can be applied to your functions to restrict their use to
739  * the owner.
740  */
741 contract Ownable is Context {
742     address private _owner;
743 
744     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
745 
746     /**
747      * @dev Initializes the contract setting the deployer as the initial owner.
748      */
749     constructor () internal {
750         address msgSender = _msgSender();
751         _owner = msgSender;
752         emit OwnershipTransferred(address(0), msgSender);
753     }
754 
755     /**
756      * @dev Returns the address of the current owner.
757      */
758     function owner() public view returns (address) {
759         return _owner;
760     }
761 
762     /**
763      * @dev Throws if called by any account other than the owner.
764      */
765     modifier onlyOwner() {
766         require(_owner == _msgSender(), "Ownable: caller is not the owner");
767         _;
768     }
769 
770     /**
771      * @dev Leaves the contract without owner. It will not be possible to call
772      * `onlyOwner` functions anymore. Can only be called by the current owner.
773      *
774      * NOTE: Renouncing ownership will leave the contract without an owner,
775      * thereby removing any functionality that is only available to the owner.
776      */
777     function renounceOwnership() public virtual onlyOwner {
778         emit OwnershipTransferred(_owner, address(0));
779         _owner = address(0);
780     }
781 
782     /**
783      * @dev Transfers ownership of the contract to a new account (`newOwner`).
784      * Can only be called by the current owner.
785      */
786     function transferOwnership(address newOwner) public virtual onlyOwner {
787         require(newOwner != address(0), "Ownable: new owner is the zero address");
788         emit OwnershipTransferred(_owner, newOwner);
789         _owner = newOwner;
790     }
791 }
792 
793 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
794 
795 pragma solidity ^0.6.0;
796 
797 
798 
799 
800 
801 /**
802  * @dev Implementation of the {IERC20} interface.
803  *
804  * This implementation is agnostic to the way tokens are created. This means
805  * that a supply mechanism has to be added in a derived contract using {_mint}.
806  * For a generic mechanism see {ERC20PresetMinterPauser}.
807  *
808  * TIP: For a detailed writeup see our guide
809  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
810  * to implement supply mechanisms].
811  *
812  * We have followed general OpenZeppelin guidelines: functions revert instead
813  * of returning `false` on failure. This behavior is nonetheless conventional
814  * and does not conflict with the expectations of ERC20 applications.
815  *
816  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
817  * This allows applications to reconstruct the allowance for all accounts just
818  * by listening to said events. Other implementations of the EIP may not emit
819  * these events, as it isn't required by the specification.
820  *
821  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
822  * functions have been added to mitigate the well-known issues around setting
823  * allowances. See {IERC20-approve}.
824  */
825 contract ERC20 is Context, IERC20 {
826     using SafeMath for uint256;
827     using Address for address;
828 
829     mapping (address => uint256) private _balances;
830 
831     mapping (address => mapping (address => uint256)) private _allowances;
832 
833     uint256 private _totalSupply;
834 
835     string private _name;
836     string private _symbol;
837     uint8 private _decimals;
838 
839     /**
840      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
841      * a default value of 18.
842      *
843      * To select a different value for {decimals}, use {_setupDecimals}.
844      *
845      * All three of these values are immutable: they can only be set once during
846      * construction.
847      */
848     constructor (string memory name, string memory symbol) public {
849         _name = name;
850         _symbol = symbol;
851         _decimals = 18;
852     }
853 
854     /**
855      * @dev Returns the name of the token.
856      */
857     function name() public view returns (string memory) {
858         return _name;
859     }
860 
861     /**
862      * @dev Returns the symbol of the token, usually a shorter version of the
863      * name.
864      */
865     function symbol() public view returns (string memory) {
866         return _symbol;
867     }
868 
869     /**
870      * @dev Returns the number of decimals used to get its user representation.
871      * For example, if `decimals` equals `2`, a balance of `505` tokens should
872      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
873      *
874      * Tokens usually opt for a value of 18, imitating the relationship between
875      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
876      * called.
877      *
878      * NOTE: This information is only used for _display_ purposes: it in
879      * no way affects any of the arithmetic of the contract, including
880      * {IERC20-balanceOf} and {IERC20-transfer}.
881      */
882     function decimals() public view returns (uint8) {
883         return _decimals;
884     }
885 
886     /**
887      * @dev See {IERC20-totalSupply}.
888      */
889     function totalSupply() public view override returns (uint256) {
890         return _totalSupply;
891     }
892 
893     /**
894      * @dev See {IERC20-balanceOf}.
895      */
896     function balanceOf(address account) public view override returns (uint256) {
897         return _balances[account];
898     }
899 
900     /**
901      * @dev See {IERC20-transfer}.
902      *
903      * Requirements:
904      *
905      * - `recipient` cannot be the zero address.
906      * - the caller must have a balance of at least `amount`.
907      */
908     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
909         _transfer(_msgSender(), recipient, amount);
910         return true;
911     }
912 
913     /**
914      * @dev See {IERC20-allowance}.
915      */
916     function allowance(address owner, address spender) public view virtual override returns (uint256) {
917         return _allowances[owner][spender];
918     }
919 
920     /**
921      * @dev See {IERC20-approve}.
922      *
923      * Requirements:
924      *
925      * - `spender` cannot be the zero address.
926      */
927     function approve(address spender, uint256 amount) public virtual override returns (bool) {
928         _approve(_msgSender(), spender, amount);
929         return true;
930     }
931 
932     /**
933      * @dev See {IERC20-transferFrom}.
934      *
935      * Emits an {Approval} event indicating the updated allowance. This is not
936      * required by the EIP. See the note at the beginning of {ERC20};
937      *
938      * Requirements:
939      * - `sender` and `recipient` cannot be the zero address.
940      * - `sender` must have a balance of at least `amount`.
941      * - the caller must have allowance for ``sender``'s tokens of at least
942      * `amount`.
943      */
944     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
945         _transfer(sender, recipient, amount);
946         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
947         return true;
948     }
949 
950     /**
951      * @dev Atomically increases the allowance granted to `spender` by the caller.
952      *
953      * This is an alternative to {approve} that can be used as a mitigation for
954      * problems described in {IERC20-approve}.
955      *
956      * Emits an {Approval} event indicating the updated allowance.
957      *
958      * Requirements:
959      *
960      * - `spender` cannot be the zero address.
961      */
962     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
963         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
964         return true;
965     }
966 
967     /**
968      * @dev Atomically decreases the allowance granted to `spender` by the caller.
969      *
970      * This is an alternative to {approve} that can be used as a mitigation for
971      * problems described in {IERC20-approve}.
972      *
973      * Emits an {Approval} event indicating the updated allowance.
974      *
975      * Requirements:
976      *
977      * - `spender` cannot be the zero address.
978      * - `spender` must have allowance for the caller of at least
979      * `subtractedValue`.
980      */
981     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
982         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
983         return true;
984     }
985 
986     /**
987      * @dev Moves tokens `amount` from `sender` to `recipient`.
988      *
989      * This is internal function is equivalent to {transfer}, and can be used to
990      * e.g. implement automatic token fees, slashing mechanisms, etc.
991      *
992      * Emits a {Transfer} event.
993      *
994      * Requirements:
995      *
996      * - `sender` cannot be the zero address.
997      * - `recipient` cannot be the zero address.
998      * - `sender` must have a balance of at least `amount`.
999      */
1000     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1001         require(sender != address(0), "ERC20: transfer from the zero address");
1002         require(recipient != address(0), "ERC20: transfer to the zero address");
1003 
1004         _beforeTokenTransfer(sender, recipient, amount);
1005 
1006         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1007         _balances[recipient] = _balances[recipient].add(amount);
1008         emit Transfer(sender, recipient, amount);
1009     }
1010 
1011     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1012      * the total supply.
1013      *
1014      * Emits a {Transfer} event with `from` set to the zero address.
1015      *
1016      * Requirements
1017      *
1018      * - `to` cannot be the zero address.
1019      */
1020     function _mint(address account, uint256 amount) internal virtual {
1021         require(account != address(0), "ERC20: mint to the zero address");
1022 
1023         _beforeTokenTransfer(address(0), account, amount);
1024 
1025         _totalSupply = _totalSupply.add(amount);
1026         _balances[account] = _balances[account].add(amount);
1027         emit Transfer(address(0), account, amount);
1028     }
1029 
1030     /**
1031      * @dev Destroys `amount` tokens from `account`, reducing the
1032      * total supply.
1033      *
1034      * Emits a {Transfer} event with `to` set to the zero address.
1035      *
1036      * Requirements
1037      *
1038      * - `account` cannot be the zero address.
1039      * - `account` must have at least `amount` tokens.
1040      */
1041     function _burn(address account, uint256 amount) internal virtual {
1042         require(account != address(0), "ERC20: burn from the zero address");
1043 
1044         _beforeTokenTransfer(account, address(0), amount);
1045 
1046         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1047         _totalSupply = _totalSupply.sub(amount);
1048         emit Transfer(account, address(0), amount);
1049     }
1050 
1051     /**
1052      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1053      *
1054      * This internal function is equivalent to `approve`, and can be used to
1055      * e.g. set automatic allowances for certain subsystems, etc.
1056      *
1057      * Emits an {Approval} event.
1058      *
1059      * Requirements:
1060      *
1061      * - `owner` cannot be the zero address.
1062      * - `spender` cannot be the zero address.
1063      */
1064     function _approve(address owner, address spender, uint256 amount) internal virtual {
1065         require(owner != address(0), "ERC20: approve from the zero address");
1066         require(spender != address(0), "ERC20: approve to the zero address");
1067 
1068         _allowances[owner][spender] = amount;
1069         emit Approval(owner, spender, amount);
1070     }
1071 
1072     /**
1073      * @dev Sets {decimals} to a value other than the default one of 18.
1074      *
1075      * WARNING: This function should only be called from the constructor. Most
1076      * applications that interact with token contracts will not expect
1077      * {decimals} to ever change, and may work incorrectly if it does.
1078      */
1079     function _setupDecimals(uint8 decimals_) internal {
1080         _decimals = decimals_;
1081     }
1082 
1083     /**
1084      * @dev Hook that is called before any transfer of tokens. This includes
1085      * minting and burning.
1086      *
1087      * Calling conditions:
1088      *
1089      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1090      * will be to transferred to `to`.
1091      * - when `from` is zero, `amount` tokens will be minted for `to`.
1092      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1093      * - `from` and `to` are never both zero.
1094      *
1095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1096      */
1097     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1098 }
1099 
1100 // File: contracts\PigstyToken.sol
1101 
1102 pragma solidity ^0.6.2;
1103 
1104 // SushiToken with Governance.
1105 contract PigstyToken is ERC20("PigstyToken", "STY"), Ownable {
1106     // START OF Pigsty SUSHI SPECIFIC CODE
1107     // Pigsty sushi is an exact copy of sushi except for the
1108     // https://etherscan.io/token/0x6b3595068778dd592e39a122f4f5a5cf09c90fe2
1109     // every transfer 1% gets burned and % gets transfered to vault
1110     using SafeMath for uint256;
1111     address public vaultAddress = 0xac66953a0163594194b1b42fB734222feb46E7Ae;
1112     bool public hardCapReached = false;
1113     uint256 private bp150 = 150; //1.5%
1114     uint256 private bp125 = 125; //1.25%
1115     uint256 private bp100 = 100; // 1%
1116     uint256 private bp200 = 200; // 2%
1117     uint256 public onepointfiveperc = 150 ether; //150 STY  1.5%
1118     uint256 public onepointtwentyfiveperc = 125 ether; //125 STY  1.25%
1119     uint256 public oneperc = 100 ether; //100 STY  1%
1120     uint256 public vaultFee = 20; //2%
1121 
1122     constructor() public {}
1123 
1124     function transfer(address recipient, uint256 amount)
1125         public
1126         virtual
1127         override
1128         returns (bool)
1129     {
1130         uint256 burnAmount = amount.div(1000).mul(10);
1131 
1132         if (hardCapReached) {
1133             oneperc = bp100.mul(totalSupply().sub(burnAmount)).div(10000);
1134             onepointtwentyfiveperc = bp125
1135                 .mul(totalSupply().sub(burnAmount))
1136                 .div(10000);
1137             onepointfiveperc = bp150.mul(totalSupply().sub(burnAmount)).div(
1138                 10000
1139             );
1140             vaultFee = bp200.mul(totalSupply()).div(10000);
1141             uint256 vaultBalance = balanceOf(vaultAddress);
1142             if (vaultBalance <= oneperc) {
1143                 //100 STY
1144                 vaultFee = 80; //8%
1145             } else if (vaultBalance <= onepointtwentyfiveperc) {
1146                 //125 STY
1147                 vaultFee = 60; //6%
1148             } else if (vaultBalance <= onepointfiveperc) {
1149                 //150 STY
1150                 vaultFee = 40; //4%
1151             } else {
1152                 vaultFee = 20; //2%
1153             }
1154         }
1155         uint256 _amount;
1156         // burn amount is 1%
1157         _amount = burnAmount;
1158         uint256 vaultAmount = amount.div(1000).mul(vaultFee);
1159         _amount = _amount.add(vaultAmount);
1160 
1161         // sender loses the 1% of the STY
1162         _burn(msg.sender, burnAmount);
1163 
1164         //transfer vaultFee to vault
1165         super.transfer(vaultAddress, vaultAmount);
1166         // sender transfers the rest
1167         return super.transfer(recipient, amount.sub(_amount));
1168     }
1169 
1170     function transferFrom(
1171         address sender,
1172         address recipient,
1173         uint256 amount
1174     ) public virtual override returns (bool) {
1175         uint256 burnAmount = amount.div(1000).mul(10);
1176 
1177         // sender loses the 1% of the STY
1178         _burn(sender, burnAmount);
1179 
1180         return super.transferFrom(sender, recipient, amount.sub(burnAmount));
1181     }
1182 
1183     // END OF Pigsty SUSHI SPECIFIC CODE
1184 
1185     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (PigstyChef).
1186     function mint(address _to, uint256 _amount) public onlyOwner {
1187         require(
1188             totalSupply().add(_amount) <= 10000 ether,
1189             "Can't mint more than 10k max supply"
1190         );
1191         _mint(_to, _amount);
1192         _moveDelegates(address(0), _delegates[_to], _amount);
1193     }
1194 
1195     function mintToFull(address _to) public onlyOwner {
1196         uint256 maxSupply = 10000 ether;
1197         uint256 diff = maxSupply.sub(totalSupply());
1198         if (diff.add(totalSupply()) != maxSupply) {
1199             uint256 real = diff.add(totalSupply());
1200             uint256 xd = maxSupply.sub(real);
1201             _mint(_to, xd);
1202             _moveDelegates(address(0), _delegates[_to], xd);
1203         } else {
1204             _mint(_to, diff);
1205             _moveDelegates(address(0), _delegates[_to], diff);
1206         }
1207         hardCapReached = true;
1208     }
1209     
1210     function setVaultAddress(address _address) public onlyOwner {
1211         vaultAddress = _address;
1212     }
1213 
1214     // Copied and modified from YAM code:
1215     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1216     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1217     // Which is copied and modified from COMPOUND:
1218     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1219 
1220     /// @notice A record of each accounts delegate
1221     mapping(address => address) internal _delegates;
1222 
1223     /// @notice A checkpoint for marking number of votes from a given block
1224     struct Checkpoint {
1225         uint32 fromBlock;
1226         uint256 votes;
1227     }
1228 
1229     /// @notice A record of votes checkpoints for each account, by index
1230     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1231 
1232     /// @notice The number of checkpoints for each account
1233     mapping(address => uint32) public numCheckpoints;
1234 
1235     /// @notice The EIP-712 typehash for the contract's domain
1236     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
1237         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
1238     );
1239 
1240     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1241     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
1242         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
1243     );
1244 
1245     /// @notice A record of states for signing / validating signatures
1246     mapping(address => uint256) public nonces;
1247 
1248     /// @notice An event thats emitted when an account changes its delegate
1249     event DelegateChanged(
1250         address indexed delegator,
1251         address indexed fromDelegate,
1252         address indexed toDelegate
1253     );
1254 
1255     /// @notice An event thats emitted when a delegate account's vote balance changes
1256     event DelegateVotesChanged(
1257         address indexed delegate,
1258         uint256 previousBalance,
1259         uint256 newBalance
1260     );
1261 
1262     /**
1263      * @notice Delegate votes from `msg.sender` to `delegatee`
1264      * @param delegator The address to get delegatee for
1265      */
1266     function delegates(address delegator) external view returns (address) {
1267         return _delegates[delegator];
1268     }
1269 
1270     /**
1271      * @notice Delegate votes from `msg.sender` to `delegatee`
1272      * @param delegatee The address to delegate votes to
1273      */
1274     function delegate(address delegatee) external {
1275         return _delegate(msg.sender, delegatee);
1276     }
1277 
1278     /**
1279      * @notice Delegates votes from signatory to `delegatee`
1280      * @param delegatee The address to delegate votes to
1281      * @param nonce The contract state required to match the signature
1282      * @param expiry The time at which to expire the signature
1283      * @param v The recovery byte of the signature
1284      * @param r Half of the ECDSA signature pair
1285      * @param s Half of the ECDSA signature pair
1286      */
1287     function delegateBySig(
1288         address delegatee,
1289         uint256 nonce,
1290         uint256 expiry,
1291         uint8 v,
1292         bytes32 r,
1293         bytes32 s
1294     ) external {
1295         bytes32 domainSeparator = keccak256(
1296             abi.encode(
1297                 DOMAIN_TYPEHASH,
1298                 keccak256(bytes(name())),
1299                 getChainId(),
1300                 address(this)
1301             )
1302         );
1303 
1304         bytes32 structHash = keccak256(
1305             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
1306         );
1307 
1308         bytes32 digest = keccak256(
1309             abi.encodePacked("\x19\x01", domainSeparator, structHash)
1310         );
1311 
1312         address signatory = ecrecover(digest, v, r, s);
1313         require(
1314             signatory != address(0),
1315             "SUSHI::delegateBySig: invalid signature"
1316         );
1317         require(
1318             nonce == nonces[signatory]++,
1319             "SUSHI::delegateBySig: invalid nonce"
1320         );
1321         require(now <= expiry, "SUSHI::delegateBySig: signature expired");
1322         return _delegate(signatory, delegatee);
1323     }
1324 
1325     /**
1326      * @notice Gets the current votes balance for `account`
1327      * @param account The address to get votes balance
1328      * @return The number of current votes for `account`
1329      */
1330     function getCurrentVotes(address account) external view returns (uint256) {
1331         uint32 nCheckpoints = numCheckpoints[account];
1332         return
1333             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1334     }
1335 
1336     /**
1337      * @notice Determine the prior number of votes for an account as of a block number
1338      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1339      * @param account The address of the account to check
1340      * @param blockNumber The block number to get the vote balance at
1341      * @return The number of votes the account had as of the given block
1342      */
1343     function getPriorVotes(address account, uint256 blockNumber)
1344         external
1345         view
1346         returns (uint256)
1347     {
1348         require(
1349             blockNumber < block.number,
1350             "SUSHI::getPriorVotes: not yet determined"
1351         );
1352 
1353         uint32 nCheckpoints = numCheckpoints[account];
1354         if (nCheckpoints == 0) {
1355             return 0;
1356         }
1357 
1358         // First check most recent balance
1359         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1360             return checkpoints[account][nCheckpoints - 1].votes;
1361         }
1362 
1363         // Next check implicit zero balance
1364         if (checkpoints[account][0].fromBlock > blockNumber) {
1365             return 0;
1366         }
1367 
1368         uint32 lower = 0;
1369         uint32 upper = nCheckpoints - 1;
1370         while (upper > lower) {
1371             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1372             Checkpoint memory cp = checkpoints[account][center];
1373             if (cp.fromBlock == blockNumber) {
1374                 return cp.votes;
1375             } else if (cp.fromBlock < blockNumber) {
1376                 lower = center;
1377             } else {
1378                 upper = center - 1;
1379             }
1380         }
1381         return checkpoints[account][lower].votes;
1382     }
1383 
1384     function _delegate(address delegator, address delegatee) internal {
1385         address currentDelegate = _delegates[delegator];
1386         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SUSHIs (not scaled);
1387         _delegates[delegator] = delegatee;
1388 
1389         emit DelegateChanged(delegator, currentDelegate, delegatee);
1390 
1391         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1392     }
1393 
1394     function _moveDelegates(
1395         address srcRep,
1396         address dstRep,
1397         uint256 amount
1398     ) internal {
1399         if (srcRep != dstRep && amount > 0) {
1400             if (srcRep != address(0)) {
1401                 // decrease old representative
1402                 uint32 srcRepNum = numCheckpoints[srcRep];
1403                 uint256 srcRepOld = srcRepNum > 0
1404                     ? checkpoints[srcRep][srcRepNum - 1].votes
1405                     : 0;
1406                 uint256 srcRepNew = srcRepOld.sub(amount);
1407                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1408             }
1409 
1410             if (dstRep != address(0)) {
1411                 // increase new representative
1412                 uint32 dstRepNum = numCheckpoints[dstRep];
1413                 uint256 dstRepOld = dstRepNum > 0
1414                     ? checkpoints[dstRep][dstRepNum - 1].votes
1415                     : 0;
1416                 uint256 dstRepNew = dstRepOld.add(amount);
1417                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1418             }
1419         }
1420     }
1421 
1422     function _writeCheckpoint(
1423         address delegatee,
1424         uint32 nCheckpoints,
1425         uint256 oldVotes,
1426         uint256 newVotes
1427     ) internal {
1428         uint32 blockNumber = safe32(
1429             block.number,
1430             "SUSHI::_writeCheckpoint: block number exceeds 32 bits"
1431         );
1432 
1433         if (
1434             nCheckpoints > 0 &&
1435             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
1436         ) {
1437             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1438         } else {
1439             checkpoints[delegatee][nCheckpoints] = Checkpoint(
1440                 blockNumber,
1441                 newVotes
1442             );
1443             numCheckpoints[delegatee] = nCheckpoints + 1;
1444         }
1445 
1446         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1447     }
1448 
1449     function safe32(uint256 n, string memory errorMessage)
1450         internal
1451         pure
1452         returns (uint32)
1453     {
1454         require(n < 2**32, errorMessage);
1455         return uint32(n);
1456     }
1457 
1458     function getChainId() internal pure returns (uint256) {
1459         uint256 chainId;
1460         assembly {
1461             chainId := chainid()
1462         }
1463         return chainId;
1464     }
1465 }
1466 
1467 // File: contracts\PigstyChef.sol
1468 
1469 pragma solidity ^0.6.2;
1470 
1471 interface IMigratorChef {
1472     // Perform LP token migration from legacy UniswapV2 to SushiSwap.
1473     // Take the current LP token address and return the new LP token address.
1474     // Migrator should have full access to the caller's LP token.
1475     // Return the new LP token address.
1476     //
1477     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1478     // SushiSwap must mint EXACTLY the same amount of SushiSwap LP tokens or
1479     // else something bad will happen. Traditional UniswapV2 does not
1480     // do that so be careful!
1481     function migrate(IERC20 token) external returns (IERC20);
1482 }
1483 
1484 // PigstyChef is an exact copy of Sushi https://etherscan.io/address/0xc2edad668740f1aa35e4d8f227fb8e17dca888cd
1485 // we have commented an few lines to remove the dev fund
1486 // the rest is exactly the same
1487 
1488 // PigstyChef is the master of Sushi. He can make Sushi and he is a fair guy.
1489 //
1490 // Note that it's ownable and the owner wields tremendous power. The ownership
1491 // will be transferred to a governance smart contract once SUSHI is sufficiently
1492 // distributed and the community can show to govern itself.
1493 //
1494 // Have fun reading it. Hopefully it's bug-free. God bless.
1495 contract PigstyChef is Ownable {
1496     using SafeMath for uint256;
1497     using SafeERC20 for IERC20;
1498 
1499     // Info of each user.
1500     struct UserInfo {
1501         uint256 amount; // How many LP tokens the user has provided.
1502         uint256 rewardDebt; // Reward debt. See explanation below.
1503         //
1504         // We do some fancy math here. Basically, any point in time, the amount of SUSHIs
1505         // entitled to a user but is pending to be distributed is:
1506         //
1507         //   pending reward = (user.amount * pool.accSushiPerShare) - user.rewardDebt
1508         //
1509         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1510         //   1. The pool's `accSushiPerShare` (and `lastRewardBlock`) gets updated.
1511         //   2. User receives the pending reward sent to his/her address.
1512         //   3. User's `amount` gets updated.
1513         //   4. User's `rewardDebt` gets updated.
1514     }
1515 
1516     // Info of each pool.
1517     struct PoolInfo {
1518         IERC20 lpToken; // Address of LP token contract.
1519         uint256 allocPoint; // How many allocation points assigned to this pool. SUSHIs to distribute per block.
1520         uint256 lastRewardBlock; // Last block number that SUSHIs distribution occurs.
1521         uint256 accSushiPerShare; // Accumulated SUSHIs per share, times 1e12. See below.
1522     }
1523 
1524     // The SUSHI TOKEN!
1525     PigstyToken public sushi;
1526 
1527     // Dev address.
1528     // Pigsty swap does not have a dev fund
1529     // address public devaddr;
1530 
1531     // Block number when bonus SUSHI period ends.
1532     uint256 public bonusEndBlock;
1533     // SUSHI tokens created per block.
1534     uint256 public sushiPerBlock;
1535     // Bonus muliplier for early sushi makers.
1536     uint256 public constant BONUS_MULTIPLIER = 2;
1537     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1538     IMigratorChef public migrator;
1539     // Info of each pool.
1540     PoolInfo[] public poolInfo;
1541     // Info of each user that stakes LP tokens.
1542     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1543     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1544     uint256 public totalAllocPoint = 0;
1545     // The block number when SUSHI mining starts.
1546     uint256 public startBlock;
1547 
1548     uint256 public constant maxTokenSupply = 10000 ether;
1549     bool public maxCapReached = false;
1550 
1551     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1552     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1553     event EmergencyWithdraw(
1554         address indexed user,
1555         uint256 indexed pid,
1556         uint256 amount
1557     );
1558 
1559     constructor(
1560         PigstyToken _sushi,
1561         // Pigsty swap does not have a dev fund
1562         // address _devaddr,
1563         uint256 _sushiPerBlock, //100000000000000000000
1564         uint256 _startBlock,
1565         uint256 _bonusEndBlock
1566     ) public {
1567         sushi = _sushi;
1568         // devaddr = _devaddr;
1569         sushiPerBlock = _sushiPerBlock;
1570         bonusEndBlock = _bonusEndBlock;
1571         startBlock = _startBlock;
1572     }
1573 
1574     function poolLength() external view returns (uint256) {
1575         return poolInfo.length;
1576     }
1577 
1578     // Add a new lp to the pool. Can only be called by the owner.
1579     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1580     function add(
1581         uint256 _allocPoint,
1582         IERC20 _lpToken,
1583         bool _withUpdate
1584     ) public onlyOwner {
1585         if (_withUpdate) {
1586             massUpdatePools();
1587         }
1588         uint256 lastRewardBlock = block.number > startBlock
1589             ? block.number
1590             : startBlock;
1591         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1592         poolInfo.push(
1593             PoolInfo({
1594                 lpToken: _lpToken,
1595                 allocPoint: _allocPoint,
1596                 lastRewardBlock: lastRewardBlock,
1597                 accSushiPerShare: 0
1598             })
1599         );
1600     }
1601 
1602     // Update the given pool's SUSHI allocation point. Can only be called by the owner.
1603     function set(
1604         uint256 _pid,
1605         uint256 _allocPoint,
1606         bool _withUpdate
1607     ) public onlyOwner {
1608         if (_withUpdate) {
1609             massUpdatePools();
1610         }
1611         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1612             _allocPoint
1613         );
1614         poolInfo[_pid].allocPoint = _allocPoint;
1615     }
1616 
1617     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1618         bonusEndBlock = _bonusEndBlock;
1619     }
1620 
1621     // Set the migrator contract. Can only be called by the owner.
1622     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1623         migrator = _migrator;
1624     }
1625 
1626     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1627     function migrate(uint256 _pid) public {
1628         require(address(migrator) != address(0), "migrate: no migrator");
1629         PoolInfo storage pool = poolInfo[_pid];
1630         IERC20 lpToken = pool.lpToken;
1631         uint256 bal = lpToken.balanceOf(address(this));
1632         lpToken.safeApprove(address(migrator), bal);
1633         IERC20 newLpToken = migrator.migrate(lpToken);
1634         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1635         pool.lpToken = newLpToken;
1636     }
1637 
1638     // Return reward multiplier over the given _from to _to block.
1639     function getMultiplier(uint256 _from, uint256 _to)
1640         public
1641         view
1642         returns (uint256)
1643     {
1644         if (_to <= bonusEndBlock) {
1645             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1646         } else if (_from >= bonusEndBlock) {
1647             return _to.sub(_from);
1648         } else {
1649             return
1650                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1651                     _to.sub(bonusEndBlock)
1652                 );
1653         }
1654     }
1655 
1656     // View function to see pending SUSHIs on frontend.
1657     function pendingSushi(uint256 _pid, address _user)
1658         external
1659         view
1660         returns (uint256)
1661     {
1662         PoolInfo storage pool = poolInfo[_pid];
1663         UserInfo storage user = userInfo[_pid][_user];
1664         uint256 accSushiPerShare = pool.accSushiPerShare;
1665         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1666         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1667             if (maxCapReached) {
1668                 uint256 styBalance = sushi.balanceOf(address(this));
1669                 uint256 sushiReward = styBalance.mul(pool.allocPoint).div(
1670                     totalAllocPoint
1671                 );
1672                 accSushiPerShare = accSushiPerShare.add(
1673                     sushiReward.mul(1e12).div(lpSupply)
1674                 );
1675             } else {
1676                 uint256 multiplier = getMultiplier(
1677                     pool.lastRewardBlock,
1678                     block.number
1679                 );
1680                 uint256 sushiReward = multiplier
1681                     .mul(sushiPerBlock)
1682                     .mul(pool.allocPoint)
1683                     .div(totalAllocPoint);
1684                 accSushiPerShare = accSushiPerShare.add(
1685                     sushiReward.mul(1e12).div(lpSupply)
1686                 );
1687             }
1688         }
1689         return user.amount.mul(accSushiPerShare).div(1e12).sub(user.rewardDebt);
1690     }
1691 
1692     // Update reward vairables for all pools. Be careful of gas spending!
1693     function massUpdatePools() public {
1694         uint256 length = poolInfo.length;
1695         for (uint256 pid = 0; pid < length; ++pid) {
1696             updatePool(pid);
1697         }
1698     }
1699 
1700     // Update reward variables of the given pool to be up-to-date.
1701     function updatePool(uint256 _pid) public {
1702         PoolInfo storage pool = poolInfo[_pid];
1703         if (block.number <= pool.lastRewardBlock) {
1704             return;
1705         }
1706         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1707         if (lpSupply == 0) {
1708             pool.lastRewardBlock = block.number;
1709             return;
1710         }
1711         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1712         uint256 sushiReward = multiplier
1713             .mul(sushiPerBlock)
1714             .mul(pool.allocPoint)
1715             .div(totalAllocPoint);
1716         if (maxCapReached) {
1717             pool.accSushiPerShare = pool.accSushiPerShare.add(
1718                 sushiReward.mul(1e12).div(lpSupply)
1719             );
1720             pool.lastRewardBlock = block.number;
1721         } else {
1722             if (sushi.totalSupply().add(sushiReward) < maxTokenSupply) {
1723                 //checks if total supply + sushireward are higher than max allowed total supply
1724                 //mints if the amounts are smaller
1725                 sushi.mint(address(this), sushiReward);
1726                 pool.accSushiPerShare = pool.accSushiPerShare.add(
1727                     sushiReward.mul(1e12).div(lpSupply)
1728                 );
1729                 pool.lastRewardBlock = block.number;
1730             } else {
1731                 if (!maxCapReached) {
1732                     sushi.mintToFull(address(this));
1733                     maxCapReached = true; //if this is triggered, then the reward scheme is changed to only take the contracts token balance.
1734                 }
1735                 pool.accSushiPerShare = pool.accSushiPerShare.add(
1736                     sushiReward.mul(1e12).div(lpSupply)
1737                 );
1738                 pool.lastRewardBlock = block.number;
1739             }
1740         }
1741     }
1742 
1743     // Deposit LP tokens to PigstyChef for SUSHI allocation.
1744     function deposit(uint256 _pid, uint256 _amount) public {
1745         PoolInfo storage pool = poolInfo[_pid];
1746         UserInfo storage user = userInfo[_pid][msg.sender];
1747         updatePool(_pid);
1748         if (user.amount > 0) {
1749             uint256 pending = user
1750                 .amount
1751                 .mul(pool.accSushiPerShare)
1752                 .div(1e12)
1753                 .sub(user.rewardDebt);
1754             safeSushiTransfer(msg.sender, pending);
1755         }
1756         pool.lpToken.safeTransferFrom(
1757             address(msg.sender),
1758             address(this),
1759             _amount
1760         );
1761         user.amount = user.amount.add(_amount);
1762         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1763         emit Deposit(msg.sender, _pid, _amount);
1764     }
1765 
1766     // Withdraw LP tokens from PigstyChef.
1767     function withdraw(uint256 _pid, uint256 _amount) public {
1768         PoolInfo storage pool = poolInfo[_pid];
1769         UserInfo storage user = userInfo[_pid][msg.sender];
1770         require(user.amount >= _amount, "withdraw: not good");
1771         updatePool(_pid);
1772         uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(
1773             user.rewardDebt
1774         );
1775         safeSushiTransfer(msg.sender, pending);
1776         user.amount = user.amount.sub(_amount);
1777         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1778         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1779         emit Withdraw(msg.sender, _pid, _amount);
1780     }
1781 
1782     // Withdraw without caring about rewards. EMERGENCY ONLY.
1783     function emergencyWithdraw(uint256 _pid) public {
1784         PoolInfo storage pool = poolInfo[_pid];
1785         UserInfo storage user = userInfo[_pid][msg.sender];
1786         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1787         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1788         user.amount = 0;
1789         user.rewardDebt = 0;
1790     }
1791 
1792     // Safe sushi transfer function, just in case if rounding error causes pool to not have enough SUSHIs.
1793     function safeSushiTransfer(address _to, uint256 _amount) internal {
1794         uint256 sushiBal = sushi.balanceOf(address(this));
1795         if (_amount > sushiBal) {
1796             sushi.transfer(_to, sushiBal);
1797         } else {
1798             sushi.transfer(_to, _amount);
1799         }
1800     }
1801 
1802     // Pigsty swap does not have a dev fund
1803     // Update dev address by the previous dev.
1804     // function dev(address _devaddr) public {
1805     //     require(msg.sender == devaddr, "dev: wut?");
1806     //     devaddr = _devaddr;
1807     // }
1808 }