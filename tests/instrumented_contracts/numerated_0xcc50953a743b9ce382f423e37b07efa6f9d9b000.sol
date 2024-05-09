1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
79 // File: @openzeppelin/contracts/math/SafeMath.sol
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
239 // File: @openzeppelin/contracts/utils/Address.sol
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
381 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
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
456 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
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
700 // File: @openzeppelin/contracts/GSN/Context.sol
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
725 // File: @openzeppelin/contracts/access/Ownable.sol
726 
727 // SPDX-License-Identifier: MIT
728 
729 pragma solidity ^0.6.0;
730 
731 /**
732  * @dev Contract module which provides a basic access control mechanism, where
733  * there is an account (an owner) that can be granted exclusive access to
734  * specific functions.
735  *
736  * By default, the owner account will be the one that deploys the contract. This
737  * can later be changed with {transferOwnership}.
738  *
739  * This module is used through inheritance. It will make available the modifier
740  * `onlyOwner`, which can be applied to your functions to restrict their use to
741  * the owner.
742  */
743 contract Ownable is Context {
744     address private _owner;
745 
746     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
747 
748     /**
749      * @dev Initializes the contract setting the deployer as the initial owner.
750      */
751     constructor () internal {
752         address msgSender = _msgSender();
753         _owner = msgSender;
754         emit OwnershipTransferred(address(0), msgSender);
755     }
756 
757     /**
758      * @dev Returns the address of the current owner.
759      */
760     function owner() public view returns (address) {
761         return _owner;
762     }
763 
764     /**
765      * @dev Throws if called by any account other than the owner.
766      */
767     modifier onlyOwner() {
768         require(_owner == _msgSender(), "Ownable: caller is not the owner");
769         _;
770     }
771 
772     /**
773      * @dev Leaves the contract without owner. It will not be possible to call
774      * `onlyOwner` functions anymore. Can only be called by the current owner.
775      *
776      * NOTE: Renouncing ownership will leave the contract without an owner,
777      * thereby removing any functionality that is only available to the owner.
778      */
779     function renounceOwnership() public virtual onlyOwner {
780         emit OwnershipTransferred(_owner, address(0));
781         _owner = address(0);
782     }
783 
784     /**
785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
786      * Can only be called by the current owner.
787      */
788     function transferOwnership(address newOwner) public virtual onlyOwner {
789         require(newOwner != address(0), "Ownable: new owner is the zero address");
790         emit OwnershipTransferred(_owner, newOwner);
791         _owner = newOwner;
792     }
793 }
794 
795 // File: contracts/lib/HitchensList.sol
796 
797 pragma solidity ^0.6.0;
798 
799 /* 
800 Hitchens Order Statistics Tree v0.98
801 
802 A Solidity Red-Black Tree library to store and maintain a sorted data
803 structure in a Red-Black binary search tree, with O(log 2n) insert, remove
804 and search time (and gas, approximately)
805 
806 https://github.com/rob-Hitchens/OrderStatisticsTree
807 
808 Copyright (c) Rob Hitchens. the MIT License
809 
810 Permission is hereby granted, free of charge, to any person obtaining a copy
811 of this software and associated documentation files (the "Software"), to deal
812 in the Software without restriction, including without limitation the rights
813 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
814 copies of the Software, and to permit persons to whom the Software is
815 furnished to do so, subject to the following conditions:
816 
817 The above copyright notice and this permission notice shall be included in all
818 copies or substantial portions of the Software.
819 
820 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
821 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
822 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
823 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
824 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
825 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
826 SOFTWARE.
827 
828 Significant portions from BokkyPooBahsRedBlackTreeLibrary, 
829 https://github.com/bokkypoobah/BokkyPooBahsRedBlackTreeLibrary
830 
831 THIS SOFTWARE IS NOT TESTED OR AUDITED. DO NOT USE FOR PRODUCTION.
832 */
833 
834 library HitchensList {
835     uint private constant EMPTY = 0;
836     struct Node {
837         uint parent;
838         uint left;
839         uint right;
840         bool red;
841         bytes32[] keys;
842         mapping(bytes32 => uint) keyMap;
843         uint count;
844     }
845     struct Tree {
846         uint root;
847         mapping(uint => Node) nodes;
848     }
849     function first(Tree storage self) internal view returns (uint _value) {
850         _value = self.root;
851         if(_value == EMPTY) return 0;
852         while (self.nodes[_value].left != EMPTY) {
853             _value = self.nodes[_value].left;
854         }
855     }
856     function last(Tree storage self) internal view returns (uint _value) {
857         _value = self.root;
858         if(_value == EMPTY) return 0;
859         while (self.nodes[_value].right != EMPTY) {
860             _value = self.nodes[_value].right;
861         }
862     }
863     function next(Tree storage self, uint value) internal view returns (uint _cursor) {
864         require(value != EMPTY, "OrderStatisticsTree(401) - Starting value cannot be zero");
865         if (self.nodes[value].right != EMPTY) {
866             _cursor = treeMinimum(self, self.nodes[value].right);
867         } else {
868             _cursor = self.nodes[value].parent;
869             while (_cursor != EMPTY && value == self.nodes[_cursor].right) {
870                 value = _cursor;
871                 _cursor = self.nodes[_cursor].parent;
872             }
873         }
874     }
875     function prev(Tree storage self, uint value) internal view returns (uint _cursor) {
876         require(value != EMPTY, "OrderStatisticsTree(402) - Starting value cannot be zero");
877         if (self.nodes[value].left != EMPTY) {
878             _cursor = treeMaximum(self, self.nodes[value].left);
879         } else {
880             _cursor = self.nodes[value].parent;
881             while (_cursor != EMPTY && value == self.nodes[_cursor].left) {
882                 value = _cursor;
883                 _cursor = self.nodes[_cursor].parent;
884             }
885         }
886     }
887     function exists(Tree storage self, uint value) internal view returns (bool _exists) {
888         if(value == EMPTY) return false;
889         if(value == self.root) return true;
890         if(self.nodes[value].parent != EMPTY) return true;
891         return false;       
892     }
893     function keyExists(Tree storage self, bytes32 key, uint value) internal view returns (bool _exists) {
894         if(!exists(self, value)) return false;
895         return self.nodes[value].keys[self.nodes[value].keyMap[key]] == key;
896     } 
897     function getNode(Tree storage self, uint value) internal view returns (uint _parent, uint _left, uint _right, bool _red, uint keyCount, uint count) {
898         require(exists(self,value), "OrderStatisticsTree(403) - Value does not exist.");
899         Node storage gn = self.nodes[value];
900         return(gn.parent, gn.left, gn.right, gn.red, gn.keys.length, gn.keys.length+gn.count);
901     }
902     function getNodeCount(Tree storage self, uint value) internal view returns(uint count) {
903         Node storage gn = self.nodes[value];
904         return gn.keys.length+gn.count;
905     }
906     function valueKeyAtIndex(Tree storage self, uint value, uint index) internal view returns(bytes32 _key) {
907         require(exists(self,value), "OrderStatisticsTree(404) - Value does not exist.");
908         return self.nodes[value].keys[index];
909     }
910     function count(Tree storage self) internal view returns(uint _count) {
911         return getNodeCount(self,self.root);
912     }
913     function percentile(Tree storage self, uint value) internal view returns(uint _percentile) {
914         uint denominator = count(self);
915         uint numerator = rank(self, value);
916         _percentile = ((uint(1000) * numerator)/denominator+(uint(5)))/uint(10);
917     }
918     function permil(Tree storage self, uint value) internal view returns(uint _permil) {
919         uint denominator = count(self);
920         uint numerator = rank(self, value);
921         _permil = ((uint(10000) * numerator)/denominator+(uint(5)))/uint(10);
922     }
923     function atPercentile(Tree storage self, uint _percentile) internal view returns(uint _value) {
924         uint findRank = (((_percentile * count(self))/uint(10)) + uint(5)) / uint(10);
925         return atRank(self,findRank);
926     }
927     function atPermil(Tree storage self, uint _permil) internal view returns(uint _value) {
928         uint findRank = (((_permil * count(self))/uint(100)) + uint(5)) / uint(10);
929         return atRank(self,findRank);
930     }    
931     function median(Tree storage self) internal view returns(uint value) {
932         return atPercentile(self,50);
933     }
934     function below(Tree storage self, uint value) public view returns(uint _below) {
935         if(count(self) > 0 && value > 0) _below = rank(self,value)-uint(1);
936     }
937     function above(Tree storage self, uint value) public view returns(uint _above) {
938         if(count(self) > 0) _above = count(self)-rank(self,value);
939     } 
940     function rank(Tree storage self, uint value) internal view returns(uint _rank) {
941         if(count(self) > 0) {
942             bool finished;
943             uint cursor = self.root;
944             Node storage c = self.nodes[cursor];
945             uint smaller = getNodeCount(self,c.left);
946             while (!finished) {
947                 uint keyCount = c.keys.length;
948                 if(cursor == value) {
949                     finished = true;
950                 } else {
951                     if(cursor < value) {
952                         cursor = c.right;
953                         c = self.nodes[cursor];
954                         smaller += keyCount + getNodeCount(self,c.left);
955                     } else {
956                         cursor = c.left;
957                         c = self.nodes[cursor];
958                         smaller -= (keyCount + getNodeCount(self,c.right));
959                     }
960                 }
961                 if (!exists(self,cursor)) {
962                     finished = true;
963                 }
964             }
965             return smaller + 1;
966         }
967     }
968     function atRank(Tree storage self, uint _rank) internal view returns(uint _value) {
969         bool finished;
970         uint cursor = self.root;
971         Node storage c = self.nodes[cursor];
972         uint smaller = getNodeCount(self,c.left);
973         while (!finished) {
974             _value = cursor;
975             c = self.nodes[cursor];
976             uint keyCount = c.keys.length;
977             if(smaller + 1 >= _rank && smaller + keyCount <= _rank) {
978                 _value = cursor;
979                 finished = true;
980             } else {
981                 if(smaller + keyCount <= _rank) {
982                     cursor = c.right;
983                     c = self.nodes[cursor];
984                     smaller += keyCount + getNodeCount(self,c.left);
985                 } else {
986                     cursor = c.left;
987                     c = self.nodes[cursor];
988                     smaller -= (keyCount + getNodeCount(self,c.right));
989                 }
990             }
991             if (!exists(self,cursor)) {
992                 finished = true;
993             }
994         }
995     }
996     function insert(Tree storage self, bytes32 key, uint value) internal {
997         require(value != EMPTY, "OrderStatisticsTree(405) - Value to insert cannot be zero");
998         require(!keyExists(self,key,value), "OrderStatisticsTree(406) - Value and Key pair exists. Cannot be inserted again.");
999         uint cursor;
1000         uint probe = self.root;
1001         while (probe != EMPTY) {
1002             cursor = probe;
1003             if (value < probe) {
1004                 probe = self.nodes[probe].left;
1005             } else if (value > probe) {
1006                 probe = self.nodes[probe].right;
1007             } else if (value == probe) {
1008                 self.nodes[probe].keys.push(key);
1009                 self.nodes[probe].keyMap[key] = self.nodes[probe].keys.length - uint(1);
1010                 return;
1011             }
1012             self.nodes[cursor].count++;
1013         }
1014         Node storage nValue = self.nodes[value];
1015         nValue.parent = cursor;
1016         nValue.left = EMPTY;
1017         nValue.right = EMPTY;
1018         nValue.red = true;
1019         nValue.keys.push(key);
1020         nValue.keyMap[key] = nValue.keys.length - uint256(1);
1021         if (cursor == EMPTY) {
1022             self.root = value;
1023         } else if (value < cursor) {
1024             self.nodes[cursor].left = value;
1025         } else {
1026             self.nodes[cursor].right = value;
1027         }
1028         insertFixup(self, value);
1029     }
1030     function remove(Tree storage self, bytes32 key, uint value) internal {
1031         require(value != EMPTY, "OrderStatisticsTree(407) - Value to delete cannot be zero");
1032         require(keyExists(self,key,value), "OrderStatisticsTree(408) - Value to delete does not exist.");
1033         Node storage nValue = self.nodes[value];
1034         uint rowToDelete = nValue.keyMap[key];
1035         nValue.keys[rowToDelete] = nValue.keys[nValue.keys.length - uint(1)];
1036         nValue.keyMap[key]=rowToDelete;
1037         nValue.keys.pop();
1038         uint probe;
1039         uint cursor;
1040         if(nValue.keys.length == 0) {
1041             if (self.nodes[value].left == EMPTY || self.nodes[value].right == EMPTY) {
1042                 cursor = value;
1043             } else {
1044                 cursor = self.nodes[value].right;
1045                 while (self.nodes[cursor].left != EMPTY) { 
1046                     cursor = self.nodes[cursor].left;
1047                 }
1048             } 
1049             if (self.nodes[cursor].left != EMPTY) {
1050                 probe = self.nodes[cursor].left; 
1051             } else {
1052                 probe = self.nodes[cursor].right; 
1053             }
1054             uint cursorParent = self.nodes[cursor].parent;
1055             self.nodes[probe].parent = cursorParent;
1056             if (cursorParent != EMPTY) {
1057                 if (cursor == self.nodes[cursorParent].left) {
1058                     self.nodes[cursorParent].left = probe;
1059                 } else {
1060                     self.nodes[cursorParent].right = probe;
1061                 }
1062             } else {
1063                 self.root = probe;
1064             }
1065             bool doFixup = !self.nodes[cursor].red;
1066             if (cursor != value) {
1067                 replaceParent(self, cursor, value); 
1068                 self.nodes[cursor].left = self.nodes[value].left;
1069                 self.nodes[self.nodes[cursor].left].parent = cursor;
1070                 self.nodes[cursor].right = self.nodes[value].right;
1071                 self.nodes[self.nodes[cursor].right].parent = cursor;
1072                 self.nodes[cursor].red = self.nodes[value].red;
1073                 (cursor, value) = (value, cursor);
1074                 fixCountRecurse(self, value);
1075             }
1076             if (doFixup) {
1077                 removeFixup(self, probe);
1078             }
1079             fixCountRecurse(self,cursorParent);
1080             delete self.nodes[cursor];
1081         }
1082     }
1083     function fixCountRecurse(Tree storage self, uint value) private {
1084         while (value != EMPTY) {
1085            self.nodes[value].count = getNodeCount(self,self.nodes[value].left) + getNodeCount(self,self.nodes[value].right);
1086            value = self.nodes[value].parent;
1087         }
1088     }
1089     function treeMinimum(Tree storage self, uint value) private view returns (uint) {
1090         while (self.nodes[value].left != EMPTY) {
1091             value = self.nodes[value].left;
1092         }
1093         return value;
1094     }
1095     function treeMaximum(Tree storage self, uint value) private view returns (uint) {
1096         while (self.nodes[value].right != EMPTY) {
1097             value = self.nodes[value].right;
1098         }
1099         return value;
1100     }
1101     function rotateLeft(Tree storage self, uint value) private {
1102         uint cursor = self.nodes[value].right;
1103         uint parent = self.nodes[value].parent;
1104         uint cursorLeft = self.nodes[cursor].left;
1105         self.nodes[value].right = cursorLeft;
1106         if (cursorLeft != EMPTY) {
1107             self.nodes[cursorLeft].parent = value;
1108         }
1109         self.nodes[cursor].parent = parent;
1110         if (parent == EMPTY) {
1111             self.root = cursor;
1112         } else if (value == self.nodes[parent].left) {
1113             self.nodes[parent].left = cursor;
1114         } else {
1115             self.nodes[parent].right = cursor;
1116         }
1117         self.nodes[cursor].left = value;
1118         self.nodes[value].parent = cursor;
1119         self.nodes[value].count = getNodeCount(self,self.nodes[value].left) + getNodeCount(self,self.nodes[value].right);
1120         self.nodes[cursor].count = getNodeCount(self,self.nodes[cursor].left) + getNodeCount(self,self.nodes[cursor].right);
1121     }
1122     function rotateRight(Tree storage self, uint value) private {
1123         uint cursor = self.nodes[value].left;
1124         uint parent = self.nodes[value].parent;
1125         uint cursorRight = self.nodes[cursor].right;
1126         self.nodes[value].left = cursorRight;
1127         if (cursorRight != EMPTY) {
1128             self.nodes[cursorRight].parent = value;
1129         }
1130         self.nodes[cursor].parent = parent;
1131         if (parent == EMPTY) {
1132             self.root = cursor;
1133         } else if (value == self.nodes[parent].right) {
1134             self.nodes[parent].right = cursor;
1135         } else {
1136             self.nodes[parent].left = cursor;
1137         }
1138         self.nodes[cursor].right = value;
1139         self.nodes[value].parent = cursor;
1140         self.nodes[value].count = getNodeCount(self,self.nodes[value].left) + getNodeCount(self,self.nodes[value].right);
1141         self.nodes[cursor].count = getNodeCount(self,self.nodes[cursor].left) + getNodeCount(self,self.nodes[cursor].right);
1142     }
1143     function insertFixup(Tree storage self, uint value) private {
1144         uint cursor;
1145         while (value != self.root && self.nodes[self.nodes[value].parent].red) {
1146             uint valueParent = self.nodes[value].parent;
1147             if (valueParent == self.nodes[self.nodes[valueParent].parent].left) {
1148                 cursor = self.nodes[self.nodes[valueParent].parent].right;
1149                 if (self.nodes[cursor].red) {
1150                     self.nodes[valueParent].red = false;
1151                     self.nodes[cursor].red = false;
1152                     self.nodes[self.nodes[valueParent].parent].red = true;
1153                     value = self.nodes[valueParent].parent;
1154                 } else {
1155                     if (value == self.nodes[valueParent].right) {
1156                       value = valueParent;
1157                       rotateLeft(self, value);
1158                     }
1159                     valueParent = self.nodes[value].parent;
1160                     self.nodes[valueParent].red = false;
1161                     self.nodes[self.nodes[valueParent].parent].red = true;
1162                     rotateRight(self, self.nodes[valueParent].parent);
1163                 }
1164             } else {
1165                 cursor = self.nodes[self.nodes[valueParent].parent].left;
1166                 if (self.nodes[cursor].red) {
1167                     self.nodes[valueParent].red = false;
1168                     self.nodes[cursor].red = false;
1169                     self.nodes[self.nodes[valueParent].parent].red = true;
1170                     value = self.nodes[valueParent].parent;
1171                 } else {
1172                     if (value == self.nodes[valueParent].left) {
1173                       value = valueParent;
1174                       rotateRight(self, value);
1175                     }
1176                     valueParent = self.nodes[value].parent;
1177                     self.nodes[valueParent].red = false;
1178                     self.nodes[self.nodes[valueParent].parent].red = true;
1179                     rotateLeft(self, self.nodes[valueParent].parent);
1180                 }
1181             }
1182         }
1183         self.nodes[self.root].red = false;
1184     }
1185     function replaceParent(Tree storage self, uint a, uint b) private {
1186         uint bParent = self.nodes[b].parent;
1187         self.nodes[a].parent = bParent;
1188         if (bParent == EMPTY) {
1189             self.root = a;
1190         } else {
1191             if (b == self.nodes[bParent].left) {
1192                 self.nodes[bParent].left = a;
1193             } else {
1194                 self.nodes[bParent].right = a;
1195             }
1196         }
1197     }
1198     function removeFixup(Tree storage self, uint value) private {
1199         uint cursor;
1200         while (value != self.root && !self.nodes[value].red) {
1201             uint valueParent = self.nodes[value].parent;
1202             if (value == self.nodes[valueParent].left) {
1203                 cursor = self.nodes[valueParent].right;
1204                 if (self.nodes[cursor].red) {
1205                     self.nodes[cursor].red = false;
1206                     self.nodes[valueParent].red = true;
1207                     rotateLeft(self, valueParent);
1208                     cursor = self.nodes[valueParent].right;
1209                 }
1210                 if (!self.nodes[self.nodes[cursor].left].red && !self.nodes[self.nodes[cursor].right].red) {
1211                     self.nodes[cursor].red = true;
1212                     value = valueParent;
1213                 } else {
1214                     if (!self.nodes[self.nodes[cursor].right].red) {
1215                         self.nodes[self.nodes[cursor].left].red = false;
1216                         self.nodes[cursor].red = true;
1217                         rotateRight(self, cursor);
1218                         cursor = self.nodes[valueParent].right;
1219                     }
1220                     self.nodes[cursor].red = self.nodes[valueParent].red;
1221                     self.nodes[valueParent].red = false;
1222                     self.nodes[self.nodes[cursor].right].red = false;
1223                     rotateLeft(self, valueParent);
1224                     value = self.root;
1225                 }
1226             } else {
1227                 cursor = self.nodes[valueParent].left;
1228                 if (self.nodes[cursor].red) {
1229                     self.nodes[cursor].red = false;
1230                     self.nodes[valueParent].red = true;
1231                     rotateRight(self, valueParent);
1232                     cursor = self.nodes[valueParent].left;
1233                 }
1234                 if (!self.nodes[self.nodes[cursor].right].red && !self.nodes[self.nodes[cursor].left].red) {
1235                     self.nodes[cursor].red = true;
1236                     value = valueParent;
1237                 } else {
1238                     if (!self.nodes[self.nodes[cursor].left].red) {
1239                         self.nodes[self.nodes[cursor].right].red = false;
1240                         self.nodes[cursor].red = true;
1241                         rotateLeft(self, cursor);
1242                         cursor = self.nodes[valueParent].left;
1243                     }
1244                     self.nodes[cursor].red = self.nodes[valueParent].red;
1245                     self.nodes[valueParent].red = false;
1246                     self.nodes[self.nodes[cursor].left].red = false;
1247                     rotateRight(self, valueParent);
1248                     value = self.root;
1249                 }
1250             }
1251         }
1252         self.nodes[value].red = false;
1253     }
1254 }
1255 
1256 // File: contracts/ichiFarm.sol
1257 
1258 pragma solidity 0.6.12;
1259 
1260 
1261 
1262 
1263 
1264 
1265 
1266 interface IUniswapOracle {
1267     function changeInterval(uint256 seconds_) external;
1268     function update() external;
1269     function consult(address token, uint amountIn) external view returns (uint amountOut);
1270 }
1271 
1272 interface IFactor {
1273     function getFactorList(uint256 key) external view returns (uint256[] memory);       // get factor list
1274     function populateFactors(uint256 startingKey, uint256 endingKey) external;          // add new factors
1275 }
1276 
1277 // deposit ichiLP tokens to farm ICHI
1278 contract ichiFarm is Ownable {
1279     using SafeMath for uint256;
1280     using SafeERC20 for IERC20;
1281     using HitchensList for HitchensList.Tree;
1282 
1283     //   pending reward = (user.amount * pool.accIchiPerShare) - user.rewardDebt
1284     //   Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1285     //   1. The pool's `accIchiPerShare` (and `lastRewardBlock`) gets updated.
1286     //   2. User receives the pending reward sent to his/her address.
1287     //   3. User's `amount` gets updated.
1288     //   4. User's `rewardDebt` gets updated.
1289 
1290     struct UserInfo {
1291         uint256 amount;                                                 // How many LP tokens the user has provided.
1292         uint256 rewardDebt;                                             // Reward debt. See explanation below.
1293         uint256 bonusReward;                                            // Bonous Reward Tokens
1294     }
1295                                                                         // Info of each pool.
1296     struct PoolInfo {
1297         IERC20 lpToken;                                                 // Address of LP token contract.
1298         uint256 allocPoint;                                             // How many allocation points assigned to this pool. ICHIs to distribute per block.
1299         uint256 lastRewardBlock;                                        // Last block number that ICHIs distribution occurs.
1300         uint256 lastRewardBonusBlock;                                   // Last bonus number block
1301         uint256 accIchiPerShare;                                        // Accumulated ICHIs per share, times 10 ** 9. See below.
1302         uint256 startBlock;                                             // start block for rewards
1303         uint256 endBlock;                                               // end block for rewards
1304         uint256 bonusToRealRatio;                                       // ranges from 0 to 100. 0 = 0% of bonus tokens distributed, 100 = 100% of tokens distributed to bonus
1305                                                                         // initial val = 50 (50% goes to regular, 50% goes to bonus)
1306 
1307         uint256 maxWinnersPerBlock;                                     // maximum winners per block
1308         uint256 maxTransactionLoop;                                     // maximimze winners per tx
1309                                                                         // if miners > this value, increase the 3 variables above
1310         uint256 gasTank;                                                // amount of ichi in the gas tank (10 ** 9)
1311 
1312         HitchensList.Tree blockRank;                                    // sorted list data structure (red black tree)
1313     }
1314 
1315     IERC20 public ichi;
1316     uint256 public ichiPerBlock;                                        // ICHI tokens created per block.
1317 
1318     PoolInfo[] internal poolInfo;                                       // Info of each pool (must be internal for blockRank data structure)
1319     mapping (uint256 => mapping (address => UserInfo)) public userInfo; // Info of each user that stakes LP tokens.
1320 
1321     uint256 public totalAllocPoint;                                     // Total allocation points. Must be the sum of all allocation points in all pools.
1322 
1323     address public oneFactorContract;                                   // contract address uses to add new factor and get existing factor
1324 
1325     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1326     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1327     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1328     event NewMaxBlock(uint256 maxLoops);
1329     
1330     bool nonReentrant;
1331     event LogTree(string action, uint256 indexed pid, bytes32 key, uint256 value);
1332 
1333     address public ichiEthOracle;
1334     address public wethAddress;
1335 
1336     event LogGas(uint256 index, uint256 gasPrice, uint256 gasLimit, uint256 gasUsed);
1337     event LogIchiPerWinner(uint256 blockNumber, uint256 winners, uint256 ichiPaid);
1338 
1339     // ============================================================================
1340     // all initial ICHI circulation initially will be deposited into this ichiFarm contract
1341 
1342     constructor (
1343         IERC20 _ichi,
1344         uint256 _ichiPerBlock,
1345         address _oneFactorContract,
1346         address _ichiEthOracle,
1347         address _wethAddress
1348     )  
1349         public
1350     {
1351         ichi = _ichi;
1352         ichiEthOracle = _ichiEthOracle;
1353         wethAddress = _wethAddress;
1354         ichiPerBlock = _ichiPerBlock; // 5 => 5*2 = 5,000,000 coins
1355         totalAllocPoint = 0;
1356         oneFactorContract = _oneFactorContract;
1357     }
1358 
1359     function setMaxWinnersPerBlock(uint256 _poolID, uint256 _val) external onlyOwner {
1360         poolInfo[_poolID].maxWinnersPerBlock = _val;
1361     }
1362 
1363     function setMaxTransactionLoop(uint256 _poolID, uint256 _val) external onlyOwner {
1364         poolInfo[_poolID].maxTransactionLoop = _val;
1365     }
1366 
1367     function setIchiEthOracle(address address_) external onlyOwner {
1368         ichiEthOracle = address_;
1369     }
1370 
1371     function setWethAddress(address address_) external onlyOwner {
1372         wethAddress = address_;
1373     }
1374 
1375     function poolLength() external view returns (uint256) {
1376         return poolInfo.length;
1377     }
1378 
1379     function setNonReentrant(bool _val) external onlyOwner returns (bool) {
1380         nonReentrant = _val;
1381         return nonReentrant;
1382     }
1383 
1384     function gasTank(uint256 _poolID) external view returns (uint256) {
1385         return poolInfo[_poolID].gasTank;
1386     }
1387 
1388     function getMaxTransactionLoop(uint256 _poolID) external view returns (uint256) {
1389         return poolInfo[_poolID].maxTransactionLoop;
1390     }
1391 
1392     function getMaxWinnersPerBlock(uint256 _poolID) external view returns (uint256) {
1393         return poolInfo[_poolID].maxWinnersPerBlock;
1394     }
1395 
1396     function getBonusToRealRatio(uint256 _poolID) external view returns (uint256) {
1397         return poolInfo[_poolID].bonusToRealRatio;
1398     }
1399 
1400     function setBonusToRealRatio(uint256 _poolID, uint256 _val) external returns (uint256) {
1401         require(_val <= 100, "must not exceed 100%");
1402         require(_val >= 0, "must be at least 0%");
1403 
1404         poolInfo[_poolID].bonusToRealRatio = _val;
1405     }
1406 
1407     function lastRewardsBlock(uint256 _poolID) external view returns (uint256) {
1408         return poolInfo[_poolID].lastRewardBlock;
1409     }
1410 
1411     function lastRewardsBonusBlock(uint256 _poolID) external view returns (uint256) {
1412         return poolInfo[_poolID].lastRewardBonusBlock;
1413     }
1414 
1415     function startBlock(uint256 _poolID) external view returns (uint256) {
1416         return poolInfo[_poolID].startBlock;
1417     }
1418 
1419 
1420     function getPoolToken(uint256 _poolID) external view returns (address) {
1421         return address(poolInfo[_poolID].lpToken);
1422     }
1423 
1424     function getAllocPoint(uint256 _poolID) external view returns (uint256) {
1425         return poolInfo[_poolID].allocPoint;
1426     }
1427 
1428     function getAllocPerShare(uint256 _poolID) external view returns (uint256) {
1429         return poolInfo[_poolID].accIchiPerShare;
1430     }
1431 
1432     function ichiReward(uint256 _poolID) external view returns (uint256) {
1433         return (ichiPerBlock * 10 ** 9).mul(poolInfo[_poolID].allocPoint).div(totalAllocPoint);
1434     }
1435 
1436     function getLPSupply(uint256 _poolID) external view returns (uint256) {
1437         uint256 lpSupply = poolInfo[_poolID].lpToken.balanceOf(address(this));
1438         return lpSupply;
1439     }
1440 
1441     function endBlock(uint256 _poolID) external view returns (uint256) {
1442         return poolInfo[_poolID].endBlock;
1443     }
1444 
1445     // Add a new lp to the pool. Can only be called by the owner.
1446     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1447     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, uint256 _startBlock, uint256 _endBlock)
1448         public
1449         onlyOwner
1450     {
1451         if (_withUpdate) {
1452             massUpdatePools();
1453         }
1454 
1455         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1456 
1457         HitchensList.Tree storage blockRankObject;
1458 
1459         // create pool info
1460         poolInfo.push(PoolInfo({
1461             lpToken: _lpToken,
1462             allocPoint: _allocPoint,
1463             lastRewardBlock: _startBlock,
1464             lastRewardBonusBlock: _startBlock,
1465             startBlock: _startBlock,
1466             endBlock: _endBlock,
1467             bonusToRealRatio: 50,       // 1-1 split of 2 ichi reward per block
1468             accIchiPerShare: 0,
1469             maxWinnersPerBlock: 8,      // for good luck
1470             maxTransactionLoop: 100,    // 100 total winners per update bonus reward
1471             gasTank: 0,
1472             blockRank: blockRankObject
1473         }));
1474     }
1475 
1476     // Update the given pool's ICHI allocation point. Can only be called by the owner.
1477     function set(uint256 _poolID, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1478         if (_withUpdate) {
1479             massUpdatePools();
1480         }
1481         totalAllocPoint = totalAllocPoint.sub(poolInfo[_poolID].allocPoint).add(_allocPoint);
1482         poolInfo[_poolID].allocPoint = _allocPoint;
1483     }
1484 
1485     // View function to see pending ICHIs on frontend.
1486     function pendingIchi(uint256 _poolID, address _user) external view returns (uint256) {
1487         PoolInfo storage pool = poolInfo[_poolID];
1488         UserInfo storage user = userInfo[_poolID][_user];
1489         uint256 accIchiPerShare = pool.accIchiPerShare;
1490         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1491         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1492             uint256 latestBlock = block.number <= pool.endBlock ? block.number : pool.endBlock;
1493             uint256 blocks = latestBlock.sub(pool.lastRewardBlock);
1494             uint256 ichiRewardAmount = blocks.mul(ichiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1495             accIchiPerShare = accIchiPerShare.add(ichiRewardAmount.mul(10 ** 18).div(lpSupply)); // 10 ** 18 to match the LP supply
1496         }
1497         return user.amount.mul(accIchiPerShare).div(10 ** 9).sub(user.rewardDebt);
1498     }
1499 
1500     // View bonus Ichi
1501     function pendingBonusIchi(uint256 _poolID, address _user) external view returns (uint256) {
1502         UserInfo storage user = userInfo[_poolID][_user];
1503         return user.bonusReward;
1504     }
1505 
1506     // Update reward variables for all pools. Be careful of gas spending!
1507     function massUpdatePools() public {
1508         uint256 length = poolInfo.length;
1509         for (uint256 pid = 0; pid < length; ++pid) {
1510             updatePool(pid);
1511         }
1512     }
1513 
1514     // Update reward variables of the given pool to be up-to-date.
1515     // also run bonus rewards calculations
1516     function updatePool(uint256 _poolID) public {
1517         PoolInfo storage pool = poolInfo[_poolID];
1518 
1519         if (block.number <= pool.lastRewardBlock) {
1520             return;
1521         }
1522         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1523         if (lpSupply == 0) {
1524             pool.lastRewardBlock = block.number;
1525             return;
1526         }
1527 
1528         uint256 blocks = block.number.sub(pool.lastRewardBlock);
1529 
1530         // must be within end block
1531         if (block.number <= pool.endBlock) {
1532             uint256 bonusToRealRatio = pool.bonusToRealRatio;
1533             uint256 ichiRewardAmount = blocks.mul(ichiPerBlock).mul(pool.allocPoint).div(totalAllocPoint).mul(uint256(100).sub(bonusToRealRatio)).div(50);
1534             pool.accIchiPerShare = pool.accIchiPerShare.add(ichiRewardAmount.mul(10 ** 18).div(lpSupply)); // 10 ** 18 to match LP supply
1535             pool.lastRewardBlock = block.number;
1536         }
1537     }
1538 
1539     function setFactorContract(address contract_) external onlyOwner {
1540         oneFactorContract = contract_;
1541     }
1542 
1543     // separate function to call by the public
1544     function updateBonusRewards(uint256 _poolID)
1545         public
1546     {
1547         require(!nonReentrant, "ichiFarm::nonReentrant - try again");
1548         nonReentrant = true;
1549         updatePool(_poolID);
1550         uint256 startGas = gasleft();
1551 
1552         if (address(ichiEthOracle) != address(0)) IUniswapOracle(ichiEthOracle).update();
1553 
1554         PoolInfo storage pool = poolInfo[_poolID];
1555 
1556         if (block.number <= pool.lastRewardBonusBlock || block.number < pool.startBlock || block.number > pool.endBlock) {
1557             nonReentrant = false;
1558             return;
1559         }
1560 
1561         uint256 lastRewardBlock = pool.lastRewardBonusBlock;
1562 
1563         // run bonus rewards calculations
1564         uint256 totalMinersInPool = valueKeyCount(_poolID);
1565 
1566         // increment this to see if it hits the max
1567         uint256 totalWinnersPerTX = 0;
1568         for (uint256 blockIter = lastRewardBlock; blockIter < block.number; ++blockIter) { // block.number
1569 
1570             uint256 cutoff = findBlockNumberCutoff(totalMinersInPool, blockIter);
1571 
1572             // add factor list if not found
1573             if (IFactor(oneFactorContract).getFactorList(cutoff).length == 0) {
1574                 IFactor(oneFactorContract).populateFactors(cutoff, cutoff.add(1));  
1575             }
1576 
1577             // rank factors in the block number
1578             uint256[] memory factors = IFactor(oneFactorContract).getFactorList(cutoff);
1579             uint256 extraFactors = ((totalMinersInPool.sub(totalMinersInPool.mod(cutoff))).div(cutoff));
1580             extraFactors = extraFactors != 0 ? extraFactors.sub(1) : 0;
1581 
1582             uint256 currentBlockWinners = factors.length.add(extraFactors);                         // total winners
1583             uint256 rewardPerWinner = uint256(ichiPerBlock * 10 ** 9).div(currentBlockWinners);     // assume 10 ** 9 = 1 ICHI token
1584 
1585             // keep winners payout to less than the max transaction loop size
1586             if (totalWinnersPerTX.add(currentBlockWinners) > pool.maxTransactionLoop) {
1587                 uint256 unpaidBlocks = block.number.sub(blockIter);                                 // pay gasTank for unpaid blocks
1588                 pool.gasTank = pool.gasTank.add((ichiPerBlock * 10 ** 9).mul(unpaidBlocks.mul(pool.allocPoint).div(totalAllocPoint)));                // ICHI!
1589                 break;
1590             }
1591 
1592             // save to gasTank
1593             if (currentBlockWinners > pool.maxWinnersPerBlock) {
1594                 pool.gasTank = pool.gasTank.add((ichiPerBlock * 10 ** 9).mul(pool.allocPoint).div(totalAllocPoint)); // ICHI!
1595                 totalWinnersPerTX = totalWinnersPerTX.add(1);
1596             } else {
1597                 updateBonusRewardsHelper(factors, _poolID, rewardPerWinner, cutoff, totalMinersInPool, extraFactors);
1598                 totalWinnersPerTX = totalWinnersPerTX.add(currentBlockWinners); // add winners
1599             }
1600         }
1601 
1602         // update new variables based on the number of farmers paid
1603         if (totalWinnersPerTX > pool.maxTransactionLoop) {
1604             if (pool.maxWinnersPerBlock > 2) pool.maxWinnersPerBlock = pool.maxWinnersPerBlock.sub(1);
1605         } else if (totalWinnersPerTX < 25) {
1606             if (pool.maxWinnersPerBlock < 25) pool.maxWinnersPerBlock = pool.maxWinnersPerBlock.add(1);
1607         }
1608 
1609         uint256 gasPrice = tx.gasprice;
1610         uint256 gasUsed = (startGas - gasleft()).mul(gasPrice); // gets gas used in wei
1611         uint256 ichiPayment = address(ichiEthOracle) != address(0) ? IUniswapOracle(ichiEthOracle).consult(wethAddress, gasUsed) : totalWinnersPerTX.mul(10 ** 8); // default is 0.1 Ichi per winner
1612         ichiPayment = ichiPayment.add(ichiPayment.div(10));    // add 10%
1613         uint256 ichiToPayCaller = ichiPayment <= pool.gasTank ? ichiPayment : pool.gasTank;
1614 
1615         // minimum pay 3 users
1616         if (ichiToPayCaller != 0 && totalWinnersPerTX >= 3 && block.number <= pool.endBlock) {
1617             safeIchiTransfer(msg.sender, ichiToPayCaller);              // send ichi to caller
1618             pool.gasTank = pool.gasTank.sub(ichiToPayCaller);           // update gas tank
1619             emit LogIchiPerWinner(block.number, totalWinnersPerTX, ichiToPayCaller);
1620         }
1621 
1622         emit LogGas(0, gasPrice, startGas - gasleft(), gasUsed);
1623 
1624         // update the last block.number for bonus
1625         pool.lastRewardBonusBlock = block.number;
1626         nonReentrant = false;
1627     }
1628 
1629     // loop through winners and update their keys
1630     function updateBonusRewardsHelper(
1631         uint256[] memory factors,
1632         uint256 _poolID,
1633         uint256 rewardPerWinner,
1634         uint256 cutoff,
1635         uint256 totalMinersInPool,
1636         uint256 extraFactors
1637     ) private {
1638         uint256 bonusToRealRatio = poolInfo[_poolID].bonusToRealRatio;
1639 
1640         // loop through factors and factors2 and add `rewardPerWinner` to each
1641         for (uint256 i = 0; i < factors.length; ++i) {
1642             // factor cannot be last node
1643             if (factors[i] != totalMinersInPool || totalMinersInPool == 1) {
1644                 uint256 value = valueAtRankReverse(_poolID, factors[i]);
1645                 address key = getValueKey(_poolID, value, 0);
1646                 userInfo[_poolID][key].bonusReward = userInfo[_poolID][key].bonusReward.add(rewardPerWinner.mul(bonusToRealRatio).div(50));
1647             }
1648         }
1649 
1650         // increment to next
1651         uint256 startingCutoff = cutoff;
1652 
1653         for (uint256 j = 1; j <= extraFactors; ++j) {
1654             uint256 value = valueAtRankReverse(_poolID, startingCutoff.mul(j));
1655             address key = getValueKey(_poolID, value, 0);
1656             userInfo[_poolID][key].bonusReward = userInfo[_poolID][key].bonusReward.add(rewardPerWinner.mul(bonusToRealRatio).div(50));
1657         }
1658     }
1659 
1660     // Deposit LP tokens to ichiFarm for ICHI allocation.
1661     // call ichiFactor function (add if not enough)
1662     function deposit(uint256 _poolID, uint256 _amount) public {
1663         require(!nonReentrant, "ichiFarm::nonReentrant - try again");
1664         nonReentrant = true;
1665 
1666         PoolInfo storage pool = poolInfo[_poolID];
1667         UserInfo storage user = userInfo[_poolID][msg.sender];
1668 
1669         if (user.amount > 0) {
1670             uint256 pending = user.amount.mul(pool.accIchiPerShare).div(10 ** 9).sub(user.rewardDebt);
1671 
1672             if (pending > 0) {
1673                 safeIchiTransfer(msg.sender, pending);
1674             }
1675 
1676             if (user.bonusReward > 0) {
1677                 safeIchiTransfer(msg.sender, user.bonusReward);
1678             }
1679         }
1680 
1681         if (_amount > 0) {
1682             // if key exists, remove and re add
1683             require(!valueExists(_poolID, user.amount.add(_amount)), "ichiFarm::LP collision - please try a different LP amount");
1684             require(pool.lpToken.balanceOf(msg.sender) >= _amount, "insufficient LP balance");
1685 
1686             if (keyValueExists(_poolID, bytes32(uint256(msg.sender)), user.amount)) {
1687                 removeKeyValue(_poolID, bytes32(uint256(msg.sender)), user.amount);
1688             }
1689 
1690             pool.lpToken.safeTransferFrom(msg.sender, address(this), _amount);
1691             user.amount = user.amount.add(_amount);
1692 
1693             insertKeyValue(_poolID, bytes32(uint256(msg.sender)), user.amount);
1694         }
1695 
1696         // calculate the new total miners after this deposit
1697         uint256 totalMinersInPool = valueKeyCount(_poolID);
1698 
1699         // add factor list if not found
1700         if (IFactor(oneFactorContract).getFactorList(totalMinersInPool).length == 0) {
1701             IFactor(oneFactorContract).populateFactors(totalMinersInPool, totalMinersInPool.add(1));  
1702         }
1703 
1704         updatePool(_poolID);
1705 
1706         user.rewardDebt = user.amount.mul(pool.accIchiPerShare).div(10 ** 9);
1707         emit Deposit(msg.sender, _poolID, _amount);
1708         nonReentrant = false;
1709     }
1710 
1711     // Withdraw from ichiFarm
1712     function withdraw(uint256 _poolID) public {
1713         require(!nonReentrant, "ichiFarm::nonReentrant - try again");
1714         nonReentrant = true;
1715 
1716         PoolInfo storage pool = poolInfo[_poolID];
1717         UserInfo storage user = userInfo[_poolID][msg.sender];
1718         uint256 bonusToRealRatio = pool.bonusToRealRatio;
1719 
1720         updatePool(_poolID);
1721 
1722         uint256 pending = user.amount.mul(pool.accIchiPerShare).div(10 ** 9).sub(user.rewardDebt);
1723         if (pending > 0) {
1724             safeIchiTransfer(msg.sender, pending.mul(uint256(100).sub(bonusToRealRatio)).div(50));
1725         }
1726         if (user.bonusReward > 0) {
1727             safeIchiTransfer(msg.sender, uint256(user.bonusReward).mul(bonusToRealRatio).div(50));
1728             user.bonusReward = 0;
1729         }
1730 
1731         removeKeyValue(_poolID, bytes32(uint256(msg.sender)), user.amount); // remove current key
1732 
1733         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1734         emit Withdraw(msg.sender, _poolID, user.amount);
1735         user.amount = 0;
1736 
1737         user.rewardDebt = user.amount.mul(pool.accIchiPerShare).div(10 ** 9);
1738         nonReentrant = false;
1739     }
1740 
1741     // get rewards but no LP
1742     function claimRewards(uint256 _poolID) public {
1743         require(!nonReentrant, "ichiFarm::nonReentrant - try again");
1744         nonReentrant = true;
1745 
1746         PoolInfo storage pool = poolInfo[_poolID];
1747         UserInfo storage user = userInfo[_poolID][msg.sender];
1748         uint256 bonusToRealRatio = pool.bonusToRealRatio;
1749 
1750         updatePool(_poolID);
1751 
1752         uint256 pending = user.amount.mul(pool.accIchiPerShare).div(10 ** 9).sub(user.rewardDebt);
1753         if (pending > 0) {
1754             safeIchiTransfer(msg.sender, pending.mul(uint256(100).sub(bonusToRealRatio)).div(50));
1755         }
1756         if (user.bonusReward > 0) {
1757             safeIchiTransfer(msg.sender, uint256(user.bonusReward).mul(bonusToRealRatio).div(50));
1758             user.bonusReward = 0;
1759         }
1760 
1761         user.rewardDebt = user.amount.mul(pool.accIchiPerShare).div(10 ** 9);
1762         nonReentrant = false;
1763     }
1764 
1765     // Withdraw without caring about rewards.
1766     function emergencyWithdraw(uint256 _poolID) public {
1767         PoolInfo storage pool = poolInfo[_poolID];
1768         UserInfo storage user = userInfo[_poolID][msg.sender];
1769         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1770         emit EmergencyWithdraw(msg.sender, _poolID, user.amount);
1771 
1772         removeKeyValue(_poolID, bytes32(uint256(msg.sender)), user.amount); // remove current key
1773         user.amount = 0;
1774         user.rewardDebt = 0;
1775         user.bonusReward = 0;
1776     }
1777 
1778     // Safe ichi transfer function, just in case if rounding error causes pool to not have enough ICHIs.
1779     function safeIchiTransfer(address _to, uint256 _amount) internal {
1780         uint256 ichiBal = ichi.balanceOf(address(this));
1781         if (_amount > ichiBal) {
1782             ichi.transfer(_to, ichiBal);
1783         } else {
1784             ichi.transfer(_to, _amount);
1785         }
1786     }
1787 
1788     // finds the smallest block number cutoff that is <= total ranks in a given pool
1789     function findBlockNumberCutoff(uint256 _totalRanks, uint256 _currentBlockNumber) public pure returns (uint256) {
1790         uint256 modulo = 1000000;
1791         uint256 potentialCutoff = _currentBlockNumber % modulo;
1792 
1793         while (potentialCutoff > _totalRanks) {
1794             modulo = modulo.div(10);
1795             potentialCutoff = _currentBlockNumber % modulo;
1796         }
1797 
1798         return potentialCutoff == 0 ? 1 : potentialCutoff;
1799     }
1800 
1801     // internal functions to call our sorted list
1802     function treeRootNode(uint256 _poolID) public view returns (uint _value) {
1803         _value = poolInfo[_poolID].blockRank.root;
1804     }
1805     function firstValue(uint256 _poolID) public view returns (uint _value) {
1806         _value = poolInfo[_poolID].blockRank.first();
1807     }
1808     function lastValue(uint256 _poolID) public view returns (uint _value) {
1809         _value = poolInfo[_poolID].blockRank.last();
1810     }
1811     function nextValue(uint256 _poolID, uint value) public view returns (uint _value) {
1812         _value = poolInfo[_poolID].blockRank.next(value);
1813     }
1814     function prevValue(uint256 _poolID, uint value) public view returns (uint _value) {
1815         _value = poolInfo[_poolID].blockRank.prev(value);
1816     }
1817     function valueExists(uint256 _poolID, uint value) public view returns (bool _exists) {
1818         _exists = poolInfo[_poolID].blockRank.exists(value);
1819     }
1820     function keyValueExists(uint256 _poolID, bytes32 key, uint value) public view returns (bool _exists) {
1821         _exists = poolInfo[_poolID].blockRank.keyExists(key, value);
1822     }
1823     function getNode(uint256 _poolID, uint value) public view returns (uint _parent, uint _left, uint _right, bool _red, uint _keyCount, uint _count) {
1824         (_parent, _left, _right, _red, _keyCount, _count) = poolInfo[_poolID].blockRank.getNode(value);
1825     }
1826     function getValueKey(uint256 _poolID, uint value, uint row) public view returns (address _key) {
1827         _key = address(uint160(uint256(poolInfo[_poolID].blockRank.valueKeyAtIndex(value,row))));
1828     }
1829     function getValueKeyRaw(uint256 _poolID, uint256 value, uint256 row) public view returns (bytes32) {
1830         return poolInfo[_poolID].blockRank.valueKeyAtIndex(value,row);
1831     }
1832     function valueKeyCount(uint256 _poolID) public view returns (uint _count) {
1833         _count = poolInfo[_poolID].blockRank.count();
1834     } 
1835     function valuePercentile(uint256 _poolID, uint value) public view returns (uint _percentile) {
1836         _percentile = poolInfo[_poolID].blockRank.percentile(value);
1837     }
1838     function valuePermil(uint256 _poolID, uint value) public view returns (uint _permil) {
1839         _permil = poolInfo[_poolID].blockRank.permil(value);
1840     }  
1841     function valueAtPercentile(uint256 _poolID, uint _percentile) public view returns (uint _value) {
1842         _value = poolInfo[_poolID].blockRank.atPercentile(_percentile);
1843     }
1844     function valueAtPermil(uint256 _poolID, uint value) public view returns (uint _value) {
1845         _value = poolInfo[_poolID].blockRank.atPermil(value);
1846     }
1847     function medianValue(uint256 _poolID) public view returns (uint _value) {
1848         return poolInfo[_poolID].blockRank.median();
1849     }
1850     function valueRank(uint256 _poolID, uint value) public view returns (uint _rank) {
1851         _rank = poolInfo[_poolID].blockRank.rank(value);
1852     }
1853     function valuesBelow(uint256 _poolID, uint value) public view returns (uint _below) {
1854         _below = poolInfo[_poolID].blockRank.below(value);
1855     }
1856     function valuesAbove(uint256 _poolID, uint value) public view returns (uint _above) {
1857         _above = poolInfo[_poolID].blockRank.above(value);
1858     }    
1859     function valueAtRank(uint256 _poolID, uint _rank) public view returns (uint _value) {
1860         _value = poolInfo[_poolID].blockRank.atRank(_rank);
1861     }
1862     function valueAtRankReverse(uint256 _poolID, uint256 _rank) public view returns (uint256) {
1863         if (poolInfo[_poolID].blockRank.count() == 1) return poolInfo[_poolID].blockRank.atRank(2);
1864 
1865         return poolInfo[_poolID].blockRank.atRank(poolInfo[_poolID].blockRank.count() - (_rank - 1));
1866     }
1867     function valueRankReverse(uint256 _poolID, uint256 value) public view returns (uint256) {
1868         return poolInfo[_poolID].blockRank.count() - (poolInfo[_poolID].blockRank.rank(value) - 1);
1869     }
1870     function insertKeyValue(uint256 _poolID, bytes32 key, uint value) private {
1871         emit LogTree("insert", _poolID, key, value);
1872         poolInfo[_poolID].blockRank.insert(key, value);
1873     }
1874     function removeKeyValue(uint256 _poolID, bytes32 key, uint value) private {
1875         emit LogTree("delete", _poolID, key, value);
1876         poolInfo[_poolID].blockRank.remove(key, value);
1877     }
1878 }