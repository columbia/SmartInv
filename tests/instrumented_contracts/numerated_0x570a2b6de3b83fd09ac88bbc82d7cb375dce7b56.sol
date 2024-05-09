1 // Partial License: MIT
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
79 
80 // Partial License: MIT
81 
82 pragma solidity ^0.6.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      *
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts with custom message when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 
241 // Partial License: MIT
242 
243 pragma solidity ^0.6.2;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // This method relies in extcodesize, which returns 0 for contracts in
268         // construction, since the code is only stored at the end of the
269         // constructor execution.
270 
271         uint256 size;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { size := extcodesize(account) }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 
384 // Partial License: MIT
385 
386 pragma solidity ^0.6.0;
387 
388 
389 
390 
391 
392 /**
393  * @title SafeERC20
394  * @dev Wrappers around ERC20 operations that throw on failure (when the token
395  * contract returns false). Tokens that return no value (and instead revert or
396  * throw on failure) are also supported, non-reverting calls are assumed to be
397  * successful.
398  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
399  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
400  */
401 library SafeERC20 {
402     using SafeMath for uint256;
403     using Address for address;
404 
405     function safeTransfer(IERC20 token, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
407     }
408 
409     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
411     }
412 
413     /**
414      * @dev Deprecated. This function has issues similar to the ones found in
415      * {IERC20-approve}, and its usage is discouraged.
416      *
417      * Whenever possible, use {safeIncreaseAllowance} and
418      * {safeDecreaseAllowance} instead.
419      */
420     function safeApprove(IERC20 token, address spender, uint256 value) internal {
421         // safeApprove should only be called when setting an initial allowance,
422         // or when resetting it to zero. To increase and decrease it, use
423         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
424         // solhint-disable-next-line max-line-length
425         require((value == 0) || (token.allowance(address(this), spender) == 0),
426             "SafeERC20: approve from non-zero to non-zero allowance"
427         );
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
429     }
430 
431     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
432         uint256 newAllowance = token.allowance(address(this), spender).add(value);
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434     }
435 
436     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
437         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
439     }
440 
441     /**
442      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
443      * on the return value: the return value is optional (but if data is returned, it must not be false).
444      * @param token The token targeted by the call.
445      * @param data The call data (encoded using abi.encode or one of its variants).
446      */
447     function _callOptionalReturn(IERC20 token, bytes memory data) private {
448         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
449         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
450         // the target address contains contract code and also asserts for success in the low-level call.
451 
452         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
453         if (returndata.length > 0) { // Return data is optional
454             // solhint-disable-next-line max-line-length
455             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
456         }
457     }
458 }
459 
460 
461 // Partial License: MIT
462 
463 pragma solidity ^0.6.0;
464 
465 /**
466  * @dev Library for managing
467  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
468  * types.
469  *
470  * Sets have the following properties:
471  *
472  * - Elements are added, removed, and checked for existence in constant time
473  * (O(1)).
474  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
475  *
476  * ```
477  * contract Example {
478  *     // Add the library methods
479  *     using EnumerableSet for EnumerableSet.AddressSet;
480  *
481  *     // Declare a set state variable
482  *     EnumerableSet.AddressSet private mySet;
483  * }
484  * ```
485  *
486  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
487  * (`UintSet`) are supported.
488  */
489 library EnumerableSet {
490     // To implement this library for multiple types with as little code
491     // repetition as possible, we write it in terms of a generic Set type with
492     // bytes32 values.
493     // The Set implementation uses private functions, and user-facing
494     // implementations (such as AddressSet) are just wrappers around the
495     // underlying Set.
496     // This means that we can only create new EnumerableSets for types that fit
497     // in bytes32.
498 
499     struct Set {
500         // Storage of set values
501         bytes32[] _values;
502 
503         // Position of the value in the `values` array, plus 1 because index 0
504         // means a value is not in the set.
505         mapping (bytes32 => uint256) _indexes;
506     }
507 
508     /**
509      * @dev Add a value to a set. O(1).
510      *
511      * Returns true if the value was added to the set, that is if it was not
512      * already present.
513      */
514     function _add(Set storage set, bytes32 value) private returns (bool) {
515         if (!_contains(set, value)) {
516             set._values.push(value);
517             // The value is stored at length-1, but we add 1 to all indexes
518             // and use 0 as a sentinel value
519             set._indexes[value] = set._values.length;
520             return true;
521         } else {
522             return false;
523         }
524     }
525 
526     /**
527      * @dev Removes a value from a set. O(1).
528      *
529      * Returns true if the value was removed from the set, that is if it was
530      * present.
531      */
532     function _remove(Set storage set, bytes32 value) private returns (bool) {
533         // We read and store the value's index to prevent multiple reads from the same storage slot
534         uint256 valueIndex = set._indexes[value];
535 
536         if (valueIndex != 0) { // Equivalent to contains(set, value)
537             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
538             // the array, and then remove the last element (sometimes called as 'swap and pop').
539             // This modifies the order of the array, as noted in {at}.
540 
541             uint256 toDeleteIndex = valueIndex - 1;
542             uint256 lastIndex = set._values.length - 1;
543 
544             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
545             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
546 
547             bytes32 lastvalue = set._values[lastIndex];
548 
549             // Move the last value to the index where the value to delete is
550             set._values[toDeleteIndex] = lastvalue;
551             // Update the index for the moved value
552             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
553 
554             // Delete the slot where the moved value was stored
555             set._values.pop();
556 
557             // Delete the index for the deleted slot
558             delete set._indexes[value];
559 
560             return true;
561         } else {
562             return false;
563         }
564     }
565 
566     /**
567      * @dev Returns true if the value is in the set. O(1).
568      */
569     function _contains(Set storage set, bytes32 value) private view returns (bool) {
570         return set._indexes[value] != 0;
571     }
572 
573     /**
574      * @dev Returns the number of values on the set. O(1).
575      */
576     function _length(Set storage set) private view returns (uint256) {
577         return set._values.length;
578     }
579 
580    /**
581     * @dev Returns the value stored at position `index` in the set. O(1).
582     *
583     * Note that there are no guarantees on the ordering of values inside the
584     * array, and it may change when more values are added or removed.
585     *
586     * Requirements:
587     *
588     * - `index` must be strictly less than {length}.
589     */
590     function _at(Set storage set, uint256 index) private view returns (bytes32) {
591         require(set._values.length > index, "EnumerableSet: index out of bounds");
592         return set._values[index];
593     }
594 
595     // AddressSet
596 
597     struct AddressSet {
598         Set _inner;
599     }
600 
601     /**
602      * @dev Add a value to a set. O(1).
603      *
604      * Returns true if the value was added to the set, that is if it was not
605      * already present.
606      */
607     function add(AddressSet storage set, address value) internal returns (bool) {
608         return _add(set._inner, bytes32(uint256(value)));
609     }
610 
611     /**
612      * @dev Removes a value from a set. O(1).
613      *
614      * Returns true if the value was removed from the set, that is if it was
615      * present.
616      */
617     function remove(AddressSet storage set, address value) internal returns (bool) {
618         return _remove(set._inner, bytes32(uint256(value)));
619     }
620 
621     /**
622      * @dev Returns true if the value is in the set. O(1).
623      */
624     function contains(AddressSet storage set, address value) internal view returns (bool) {
625         return _contains(set._inner, bytes32(uint256(value)));
626     }
627 
628     /**
629      * @dev Returns the number of values in the set. O(1).
630      */
631     function length(AddressSet storage set) internal view returns (uint256) {
632         return _length(set._inner);
633     }
634 
635    /**
636     * @dev Returns the value stored at position `index` in the set. O(1).
637     *
638     * Note that there are no guarantees on the ordering of values inside the
639     * array, and it may change when more values are added or removed.
640     *
641     * Requirements:
642     *
643     * - `index` must be strictly less than {length}.
644     */
645     function at(AddressSet storage set, uint256 index) internal view returns (address) {
646         return address(uint256(_at(set._inner, index)));
647     }
648 
649 
650     // UintSet
651 
652     struct UintSet {
653         Set _inner;
654     }
655 
656     /**
657      * @dev Add a value to a set. O(1).
658      *
659      * Returns true if the value was added to the set, that is if it was not
660      * already present.
661      */
662     function add(UintSet storage set, uint256 value) internal returns (bool) {
663         return _add(set._inner, bytes32(value));
664     }
665 
666     /**
667      * @dev Removes a value from a set. O(1).
668      *
669      * Returns true if the value was removed from the set, that is if it was
670      * present.
671      */
672     function remove(UintSet storage set, uint256 value) internal returns (bool) {
673         return _remove(set._inner, bytes32(value));
674     }
675 
676     /**
677      * @dev Returns true if the value is in the set. O(1).
678      */
679     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
680         return _contains(set._inner, bytes32(value));
681     }
682 
683     /**
684      * @dev Returns the number of values on the set. O(1).
685      */
686     function length(UintSet storage set) internal view returns (uint256) {
687         return _length(set._inner);
688     }
689 
690    /**
691     * @dev Returns the value stored at position `index` in the set. O(1).
692     *
693     * Note that there are no guarantees on the ordering of values inside the
694     * array, and it may change when more values are added or removed.
695     *
696     * Requirements:
697     *
698     * - `index` must be strictly less than {length}.
699     */
700     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
701         return uint256(_at(set._inner, index));
702     }
703 }
704 
705 
706 // Partial License: MIT
707 
708 pragma solidity ^0.6.0;
709 
710 /*
711  * @dev Provides information about the current execution context, including the
712  * sender of the transaction and its data. While these are generally available
713  * via msg.sender and msg.data, they should not be accessed in such a direct
714  * manner, since when dealing with GSN meta-transactions the account sending and
715  * paying for execution may not be the actual sender (as far as an application
716  * is concerned).
717  *
718  * This contract is only required for intermediate, library-like contracts.
719  */
720 abstract contract Context {
721     function _msgSender() internal view virtual returns (address payable) {
722         return msg.sender;
723     }
724 
725     function _msgData() internal view virtual returns (bytes memory) {
726         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
727         return msg.data;
728     }
729 }
730 
731 
732 // Partial License: MIT
733 
734 pragma solidity ^0.6.0;
735 
736 
737 /**
738  * @dev Contract module which provides a basic access control mechanism, where
739  * there is an account (an owner) that can be granted exclusive access to
740  * specific functions.
741  *
742  * By default, the owner account will be the one that deploys the contract. This
743  * can later be changed with {transferOwnership}.
744  *
745  * This module is used through inheritance. It will make available the modifier
746  * `onlyOwner`, which can be applied to your functions to restrict their use to
747  * the owner.
748  */
749 contract Ownable is Context {
750     address private _owner;
751 
752     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
753 
754     /**
755      * @dev Initializes the contract setting the deployer as the initial owner.
756      */
757     constructor () internal {
758         address msgSender = _msgSender();
759         _owner = msgSender;
760         emit OwnershipTransferred(address(0), msgSender);
761     }
762 
763     /**
764      * @dev Returns the address of the current owner.
765      */
766     function owner() public view returns (address) {
767         return _owner;
768     }
769 
770     /**
771      * @dev Throws if called by any account other than the owner.
772      */
773     modifier onlyOwner() {
774         require(_owner == _msgSender(), "Ownable: caller is not the owner");
775         _;
776     }
777 
778     /**
779      * @dev Leaves the contract without owner. It will not be possible to call
780      * `onlyOwner` functions anymore. Can only be called by the current owner.
781      *
782      * NOTE: Renouncing ownership will leave the contract without an owner,
783      * thereby removing any functionality that is only available to the owner.
784      */
785     function renounceOwnership() public virtual onlyOwner {
786         emit OwnershipTransferred(_owner, address(0));
787         _owner = address(0);
788     }
789 
790     /**
791      * @dev Transfers ownership of the contract to a new account (`newOwner`).
792      * Can only be called by the current owner.
793      */
794     function transferOwnership(address newOwner) public virtual onlyOwner {
795         require(newOwner != address(0), "Ownable: new owner is the zero address");
796         emit OwnershipTransferred(_owner, newOwner);
797         _owner = newOwner;
798     }
799 }
800 
801 
802 pragma solidity 0.6.6;
803 
804 interface IUniswapV2Router01 {
805     function factory() external pure returns (address);
806     function WETH() external pure returns (address);
807 
808     function addLiquidity(
809         address tokenA,
810         address tokenB,
811         uint amountADesired,
812         uint amountBDesired,
813         uint amountAMin,
814         uint amountBMin,
815         address to,
816         uint deadline
817     ) external returns (uint amountA, uint amountB, uint liquidity);
818     function addLiquidityETH(
819         address token,
820         uint amountTokenDesired,
821         uint amountTokenMin,
822         uint amountETHMin,
823         address to,
824         uint deadline
825     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
826     function removeLiquidity(
827         address tokenA,
828         address tokenB,
829         uint liquidity,
830         uint amountAMin,
831         uint amountBMin,
832         address to,
833         uint deadline
834     ) external returns (uint amountA, uint amountB);
835     function removeLiquidityETH(
836         address token,
837         uint liquidity,
838         uint amountTokenMin,
839         uint amountETHMin,
840         address to,
841         uint deadline
842     ) external returns (uint amountToken, uint amountETH);
843     function removeLiquidityWithPermit(
844         address tokenA,
845         address tokenB,
846         uint liquidity,
847         uint amountAMin,
848         uint amountBMin,
849         address to,
850         uint deadline,
851         bool approveMax, uint8 v, bytes32 r, bytes32 s
852     ) external returns (uint amountA, uint amountB);
853     function removeLiquidityETHWithPermit(
854         address token,
855         uint liquidity,
856         uint amountTokenMin,
857         uint amountETHMin,
858         address to,
859         uint deadline,
860         bool approveMax, uint8 v, bytes32 r, bytes32 s
861     ) external returns (uint amountToken, uint amountETH);
862     function swapExactTokensForTokens(
863         uint amountIn,
864         uint amountOutMin,
865         address[] calldata path,
866         address to,
867         uint deadline
868     ) external returns (uint[] memory amounts);
869     function swapTokensForExactTokens(
870         uint amountOut,
871         uint amountInMax,
872         address[] calldata path,
873         address to,
874         uint deadline
875     ) external returns (uint[] memory amounts);
876     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
877         external
878         payable
879         returns (uint[] memory amounts);
880     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
881         external
882         returns (uint[] memory amounts);
883     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
884         external
885         returns (uint[] memory amounts);
886     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
887         external
888         payable
889         returns (uint[] memory amounts);
890 
891     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
892     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
893     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
894     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
895     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
896 }
897 
898 interface IUniswapV2Router02 is IUniswapV2Router01 {
899     function removeLiquidityETHSupportingFeeOnTransferTokens(
900         address token,
901         uint liquidity,
902         uint amountTokenMin,
903         uint amountETHMin,
904         address to,
905         uint deadline
906     ) external returns (uint amountETH);
907     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
908         address token,
909         uint liquidity,
910         uint amountTokenMin,
911         uint amountETHMin,
912         address to,
913         uint deadline,
914         bool approveMax, uint8 v, bytes32 r, bytes32 s
915     ) external returns (uint amountETH);
916 
917     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
918         uint amountIn,
919         uint amountOutMin,
920         address[] calldata path,
921         address to,
922         uint deadline
923     ) external;
924     function swapExactETHForTokensSupportingFeeOnTransferTokens(
925         uint amountOutMin,
926         address[] calldata path,
927         address to,
928         uint deadline
929     ) external payable;
930     function swapExactTokensForETHSupportingFeeOnTransferTokens(
931         uint amountIn,
932         uint amountOutMin,
933         address[] calldata path,
934         address to,
935         uint deadline
936     ) external;
937 }
938 
939 // ETHY Farms
940 // Based on SushiSwaps MasterChef, big credit to the sushiswap dev,
941 // we've left in some of their comments as they described some mechanics perfectly.
942 
943 // Here is a note from sushi dev that is still relevant to this ETHY contract:
944 // - Note that it's ownable and the owner wields tremendous power. The ownership
945 //   will be transferred to a governance smart contract once ETHY is sufficiently
946 //   distributed and the community can show to govern itself.
947 //
948 // After initial deployment and setup of the base pools, we will look towards 
949 // transferring governance over this to a multisignture contract (with community trust
950 // validators). After this the next step will be to "transfer to a governance contract
951 // once the community can show to govern itself."
952 
953 pragma solidity 0.6.6;
954 
955 
956 
957 
958 
959 
960 
961 
962 interface Strategy {
963     function execute(uint256 LP) external;
964 }
965 
966 // ETHY accountant will
967 interface IAccountant {
968     function onSpendLP(uint256 amount) external;
969     function calculateStrategyBudget() external returns (uint256);
970 }
971 
972 interface UpdatedFarms {
973     function depositFor(
974         address pool,
975         address account,
976         uint256 withdrawable,
977         uint256 shares
978         ) external;
979 }
980 
981 // Have fun reading it. Hopefully it's bug-free. God bless.
982 contract FarmV1 is Ownable {
983     using SafeMath for uint256;
984     using SafeERC20 for IERC20;
985 
986     // Info of each user.
987     struct UserInfo {
988         uint256 amount;     // How many LP tokens the user has provided.
989         uint256 rewardDebt; // Reward debt. See explanation below.
990         uint256 lockedUntil; // The time when tokens can be unlocked.
991         //
992         // We do some fancy math here. Basically, any point in time, the amount of ETHYs
993         // entitled to a user but is pending to be distributed is:
994         //
995         //   pending reward = (user.amount * pool.accEthyPerShare) - user.rewardDebt
996         //
997         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
998         //   1. The pool's `accEthyPerShare` (and `lastRewardBlock`) gets updated.
999         //   2. User receives the pending reward sent to his/her address.
1000         //   3. User's `amount` gets updated.
1001         //   4. User's `rewardDebt` gets updated.
1002     }
1003 
1004     // Info of each pool.
1005     struct PoolInfo {
1006         IERC20 lpToken;           // Address of LP token contract.
1007         uint256 allocPoint;       // How many allocation points assigned to this pool. ETHYs to distribute per block.
1008         uint256 lastRewardBlock;  // Last block number that ETHYs distribution occurs.
1009         uint256 accEthyPerShare;  // Accumulated ETHYs per share, times 1e12. See below.
1010         uint256 minimumStay;      // The minimum length of time a user must stay after depositing
1011 
1012         // The below variables are related to the ethy strategy:
1013         Strategy strat;           // Executes a strategy using a given budget.
1014         IAccountant accountant;      // set the budget strat for this pool.
1015         uint256 stratLastCalled;  // When the strategy was last called;.
1016         uint256 shareTotals;       // The sum of all active shares.
1017     }
1018 
1019     // The ETHY token
1020     IERC20 public ethy;
1021     // Block number when bonus ETHY period ends.
1022     uint256 public bonusEndBlock;
1023     // ETHY tokens created per block.
1024     uint256 public ethyPerBlock;
1025     // Bonus muliplier for early ethy makers.
1026     uint256 public constant BONUS_MULTIPLIER = 10;
1027 
1028     bool public canChangeAccountants = true;
1029 
1030     // Info of each pool.
1031     PoolInfo[] public poolInfo;
1032     // Info of each user that stakes LP tokens.
1033     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1034     // depositeer
1035     mapping (address => bool) public depositeer;
1036     // Total allocation points. Must be the sum of all allocation points in all pools.
1037     uint256 public totalAllocPoint = 0;
1038     // The block number when ETHY mining starts.
1039     uint256 public startBlock;
1040 
1041     // How often strategies can be called
1042     uint256 public stratCooldown = 23 hours;
1043 
1044     // Updated version of this contract, users must consentually
1045     // migrate themselves to the newer version.
1046     UpdatedFarms public updated;
1047 
1048     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1049     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1050     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1051 
1052     constructor(
1053         address _ethy,
1054         // address _devaddr,
1055         uint256 _ethyPerBlock,
1056         uint256 _bonusEndBlock
1057     ) public {
1058         ethy = IERC20(_ethy);
1059         // devaddr = _devaddr;
1060         ethyPerBlock = _ethyPerBlock;
1061         bonusEndBlock = _bonusEndBlock;
1062         startBlock = block.number;
1063     }
1064 
1065     // update the ethy block reward, minimum viable block reward is 
1066     // 210.24 ETHY a year (1e+14 units pre block). Ignoring any
1067     // multipliers
1068     function updateEthyPerBlock(uint256 _ethyPerBlock) public onlyOwner {
1069         require(_ethyPerBlock > 100000000000000, "rewards too Small");
1070         ethyPerBlock = _ethyPerBlock;
1071     }
1072 
1073     function updateVersion(address _updated) public onlyOwner {
1074         // still requires users to consentually upgrade themselves
1075         updated = UpdatedFarms(_updated);
1076     }
1077 
1078     function disableChangingAccountants() public onlyOwner {
1079         canChangeAccountants = false;
1080     }
1081     
1082     function setDepositeer(address _depositeer, bool _enabled) public onlyOwner {
1083         depositeer[_depositeer] = _enabled;
1084     }
1085 
1086     function poolLength() external view returns (uint256) {
1087         return poolInfo.length;
1088     }
1089 
1090     // Add a new lp to the pool. Can only be called by the owner.
1091     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1092     function add(uint256 _allocPoint,
1093          IERC20 _lpToken,
1094          bool _withUpdate,
1095          address _accountant,
1096          address _strat,
1097          uint256 _minimumStay
1098         ) public onlyOwner {
1099         
1100         // update all the pools
1101         if (_withUpdate) {
1102             massUpdatePools();
1103         }
1104 
1105         // attach new pool
1106         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1107         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1108 
1109         poolInfo.push(PoolInfo({
1110             lpToken: _lpToken,
1111             allocPoint: _allocPoint,
1112             lastRewardBlock: lastRewardBlock,
1113             accEthyPerShare: 0,
1114             minimumStay: _minimumStay,
1115             strat: Strategy(_strat),
1116             accountant: IAccountant(_accountant), // accountant cannot be changed
1117             stratLastCalled: 0,
1118             shareTotals: 0
1119         }));
1120     }
1121 
1122     // Update the given pool's ETHY allocation point. Can only be called by the owner.
1123     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1124         if (_withUpdate) {
1125             massUpdatePools();
1126         }
1127         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1128         poolInfo[_pid].allocPoint = _allocPoint;
1129     }
1130 
1131     // set a new strategy
1132     function setStrat(uint256 _pid, address _strat)  public onlyOwner {
1133         poolInfo[_pid].strat = Strategy(_strat);
1134         // Apply a double cooldown to give the accountant contract time to respond.
1135         // IAccountant can slash the strat if the calldown.
1136         poolInfo[_pid].stratLastCalled = block.timestamp.add(stratCooldown);
1137     }
1138 
1139     function setAccountant(uint256 _pid, address _accountant) public onlyOwner {
1140         require(canChangeAccountants, "can no longer change accountants");
1141         poolInfo[_pid].accountant = IAccountant(_accountant);
1142     }
1143 
1144     // Return reward multiplier over the given _from to _to block.
1145     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1146         if (_to <= bonusEndBlock) {
1147             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1148         } else if (_from >= bonusEndBlock) {
1149             return _to.sub(_from);
1150         } else {
1151             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1152                 _to.sub(bonusEndBlock)
1153             );
1154         }
1155     }
1156 
1157     // View function to see pending ETHYs on frontend.
1158     function pendingEthy(uint256 _pid, address _user) external view returns (uint256) {
1159         PoolInfo storage pool = poolInfo[_pid];
1160         UserInfo storage user = userInfo[_pid][_user];
1161         uint256 accEthyPerShare = pool.accEthyPerShare;
1162         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1163         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1164             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1165             uint256 ethyReward = multiplier.mul(ethyPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1166             accEthyPerShare = accEthyPerShare.add(ethyReward.mul(1e12).div(lpSupply));
1167         }
1168         return user.amount.mul(accEthyPerShare).div(1e12).sub(user.rewardDebt);
1169     }
1170 
1171     // Update reward variables for all pools. Be careful of gas spending!
1172     function massUpdatePools() public {
1173         uint256 length = poolInfo.length;
1174         for (uint256 pid = 0; pid < length; ++pid) {
1175             updatePool(pid);
1176         }
1177     }
1178 
1179     // Update reward variables of the given pool to be up-to-date.
1180     function updatePool(uint256 _pid) public {
1181         PoolInfo storage pool = poolInfo[_pid];
1182         if (block.number <= pool.lastRewardBlock) {
1183             return;
1184         }
1185         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1186         if (lpSupply == 0) {
1187             pool.lastRewardBlock = block.number;
1188             return;
1189         }
1190         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1191         uint256 ethyReward = multiplier.mul(ethyPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1192         // Reserve claim ???
1193         // sushi.mint(devaddr, sushiReward.div(10));
1194         // sushi.mint(address(this), sushiReward);
1195         pool.accEthyPerShare = pool.accEthyPerShare.add(ethyReward.mul(1e12).div(lpSupply));
1196         pool.lastRewardBlock = block.number;
1197     }
1198 
1199     function depositFor(address _user, uint256 _pid, uint256 _amount) public {
1200         PoolInfo storage pool = poolInfo[_pid];
1201         UserInfo storage user = userInfo[_pid][_user];
1202 
1203         require(msg.sender == _user || depositeer[msg.sender], "invalid depositeer");
1204 
1205         updatePool(_pid);
1206         if (user.amount > 0) {
1207             uint256 pending = user.amount.mul(pool.accEthyPerShare).div(1e12).sub(user.rewardDebt);
1208             if(pending > 0) {
1209                 safeEthyTransfer(_user, pending);
1210             }
1211         }
1212 
1213         if(_amount > 0) {
1214             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1215             user.amount = user.amount.add(_amount);
1216             pool.shareTotals = pool.shareTotals.add(_amount);
1217             user.lockedUntil = block.timestamp.add(pool.minimumStay);
1218         }
1219 
1220         user.rewardDebt = user.amount.mul(pool.accEthyPerShare).div(1e12);
1221         emit Deposit(msg.sender, _pid, _amount);
1222     }
1223 
1224     // Deposit LP tokens to MasterChef for ETHY allocation.
1225     function deposit(uint256 _pid, uint256 _amount) public {
1226         depositFor(msg.sender, _pid, _amount);
1227     }
1228 
1229     // Withdraw LP tokens from MasterChef.
1230     function withdraw(uint256 _pid, uint256 _amount) public {
1231         PoolInfo storage pool = poolInfo[_pid];
1232         UserInfo storage user = userInfo[_pid][msg.sender];
1233         require(user.amount >= _amount, "withdraw: not good");
1234 
1235         updatePool(_pid);
1236         uint256 pending = user.amount.mul(pool.accEthyPerShare).div(1e12).sub(user.rewardDebt);
1237         if(pending > 0) {
1238             safeEthyTransfer(msg.sender, pending);
1239         }
1240 
1241         // do the withdraw
1242         if(_amount > 0) {
1243             // prevent users from withdrawing early
1244             require(block.timestamp >= user.lockedUntil, "cannot withdraw early");
1245             user.amount = user.amount.sub(_amount);
1246             // calculate withdrawable amount
1247             uint256 withdrawable = calculateWithdrawable(_pid, _amount);
1248             pool.shareTotals = pool.shareTotals.sub(_amount);
1249             pool.lpToken.safeTransfer(address(msg.sender), withdrawable);
1250         }
1251 
1252         user.rewardDebt = user.amount.mul(pool.accEthyPerShare).div(1e12);
1253         emit Withdraw(msg.sender, _pid, _amount);
1254     }
1255 
1256     // Withdraw without caring about rewards. EMERGENCY ONLY.
1257     function emergencyWithdraw(uint256 _pid) public {
1258         PoolInfo storage pool = poolInfo[_pid];
1259         UserInfo storage user = userInfo[_pid][msg.sender];
1260 
1261         // prevent users from withdrawing early
1262         require(block.timestamp >= user.lockedUntil, "cannot withdraw early");
1263 
1264         uint256 amount = user.amount;
1265         user.amount = 0; // goodbye shares
1266         user.rewardDebt = 0; // goodbye debt
1267 
1268         // calculate withdrawable balance
1269         uint256 withdrawable = calculateWithdrawable(_pid, amount);
1270         pool.shareTotals = pool.shareTotals.sub(amount);
1271 
1272         // transfer users their LP
1273         pool.lpToken.safeTransfer(address(msg.sender), withdrawable);
1274 
1275         emit EmergencyWithdraw(msg.sender, _pid, amount);
1276     }
1277 
1278     // Safe ethy transfer function, just in case if rounding error causes pool to not have enough EHTY.
1279     function safeEthyTransfer(address _to, uint256 _amount) internal {
1280         uint256 ethyBal = ethy.balanceOf(address(this));
1281         if (_amount > ethyBal) {
1282             ethy.transfer(_to, ethyBal);
1283         } else {
1284             ethy.transfer(_to, _amount);
1285         }
1286     }
1287 
1288     // Calculates the LP value of shares (user.amount).
1289     // As LP tokens are spent by the strategy, total shares
1290     // will diverge from the total LP
1291     function calculateWithdrawable(uint256 _pid, uint256 _amount) public view returns(uint256) {
1292         PoolInfo storage pool = poolInfo[_pid];
1293         return _amount.mul(pool.lpToken.balanceOf(address(this))).div(pool.shareTotals);
1294     }
1295 
1296     // strategy execution has a cooldown, if strategy is changed the
1297     // cooldown is doubled, giving the accountant smart contract time to
1298     // adjust balance.
1299     // 
1300     // Even still strategy execution is limited by a maximum budget of
1301     // 10% of the liquidity.
1302     function executeStrategy(uint256 _pid) public  {
1303         PoolInfo storage pool = poolInfo[_pid];
1304         require(address(pool.strat) != address(0), "no strategy set");
1305         require(block.timestamp > pool.stratLastCalled.add(stratCooldown) , "this strategy is on cooldown");
1306         pool.stratLastCalled = block.timestamp;
1307 
1308         // calculate the maximum budget that the strategy can uses
1309         uint256 totalLP   = pool.lpToken.balanceOf(address(this));
1310         uint256 maxBudget = totalLP.mul(10).div(100); // 10%
1311 
1312         // use budget set by the accountant
1313         uint256 budget = pool.accountant.calculateStrategyBudget();
1314         if (budget > maxBudget) { budget = maxBudget;}
1315 
1316         // spend the budget on strategy
1317         pool.accountant.onSpendLP(budget); // tell accountant budget has been spent
1318         pool.lpToken.safeTransfer(address(pool.strat), budget);
1319         pool.strat.execute(budget); // execute the budget
1320     }
1321 
1322     // consentually update yourself to a new version of this pool
1323     function upgradeSelf(uint256 _pid) public {
1324         require(address(updated) != address(0), "no updated farm to move too...");
1325 
1326         PoolInfo storage pool = poolInfo[_pid];
1327         UserInfo storage user = userInfo[_pid][msg.sender];
1328 
1329         // amount
1330         uint256 amount = user.amount;
1331         require(amount > 0, "nothing to upgrade");
1332         
1333         // claim your rewards before you upgrade otherwise
1334         // they are lost forever.
1335         user.amount = 0;
1336         user.rewardDebt = 0;
1337 
1338         // withdrawable
1339         uint256 withdrawable = calculateWithdrawable(_pid, amount);
1340 
1341         // allow the pool to move your LP tokens
1342         pool.lpToken.safeIncreaseAllowance(address(updated), withdrawable);
1343 
1344         // update yourself
1345         updated.depositFor(
1346            address(pool.lpToken),
1347             msg.sender,
1348             withdrawable,
1349             amount
1350         );
1351     }
1352 
1353 }