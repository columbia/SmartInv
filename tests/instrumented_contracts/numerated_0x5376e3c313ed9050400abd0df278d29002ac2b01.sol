1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
84 pragma solidity ^0.6.0;
85 
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
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 pragma solidity ^0.6.2;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies in extcodesize, which returns 0 for contracts in
270         // construction, since the code is only stored at the end of the
271         // constructor execution.
272 
273         uint256 size;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { size := extcodesize(account) }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
386 
387 
388 pragma solidity ^0.6.0;
389 
390 
391 
392 
393 /**
394  * @title SafeERC20
395  * @dev Wrappers around ERC20 operations that throw on failure (when the token
396  * contract returns false). Tokens that return no value (and instead revert or
397  * throw on failure) are also supported, non-reverting calls are assumed to be
398  * successful.
399  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
400  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
401  */
402 library SafeERC20 {
403     using SafeMath for uint256;
404     using Address for address;
405 
406     function safeTransfer(IERC20 token, address to, uint256 value) internal {
407         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
408     }
409 
410     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
411         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
412     }
413 
414     /**
415      * @dev Deprecated. This function has issues similar to the ones found in
416      * {IERC20-approve}, and its usage is discouraged.
417      *
418      * Whenever possible, use {safeIncreaseAllowance} and
419      * {safeDecreaseAllowance} instead.
420      */
421     function safeApprove(IERC20 token, address spender, uint256 value) internal {
422         // safeApprove should only be called when setting an initial allowance,
423         // or when resetting it to zero. To increase and decrease it, use
424         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
425         // solhint-disable-next-line max-line-length
426         require((value == 0) || (token.allowance(address(this), spender) == 0),
427             "SafeERC20: approve from non-zero to non-zero allowance"
428         );
429         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
430     }
431 
432     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
433         uint256 newAllowance = token.allowance(address(this), spender).add(value);
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435     }
436 
437     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
438         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
440     }
441 
442     /**
443      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
444      * on the return value: the return value is optional (but if data is returned, it must not be false).
445      * @param token The token targeted by the call.
446      * @param data The call data (encoded using abi.encode or one of its variants).
447      */
448     function _callOptionalReturn(IERC20 token, bytes memory data) private {
449         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
450         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
451         // the target address contains contract code and also asserts for success in the low-level call.
452 
453         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
454         if (returndata.length > 0) { // Return data is optional
455             // solhint-disable-next-line max-line-length
456             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
457         }
458     }
459 }
460 
461 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
462 
463 
464 pragma solidity ^0.6.0;
465 
466 /**
467  * @dev Library for managing
468  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
469  * types.
470  *
471  * Sets have the following properties:
472  *
473  * - Elements are added, removed, and checked for existence in constant time
474  * (O(1)).
475  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
476  *
477  * ```
478  * contract Example {
479  *     // Add the library methods
480  *     using EnumerableSet for EnumerableSet.AddressSet;
481  *
482  *     // Declare a set state variable
483  *     EnumerableSet.AddressSet private mySet;
484  * }
485  * ```
486  *
487  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
488  * (`UintSet`) are supported.
489  */
490 library EnumerableSet {
491     // To implement this library for multiple types with as little code
492     // repetition as possible, we write it in terms of a generic Set type with
493     // bytes32 values.
494     // The Set implementation uses private functions, and user-facing
495     // implementations (such as AddressSet) are just wrappers around the
496     // underlying Set.
497     // This means that we can only create new EnumerableSets for types that fit
498     // in bytes32.
499 
500     struct Set {
501         // Storage of set values
502         bytes32[] _values;
503 
504         // Position of the value in the `values` array, plus 1 because index 0
505         // means a value is not in the set.
506         mapping (bytes32 => uint256) _indexes;
507     }
508 
509     /**
510      * @dev Add a value to a set. O(1).
511      *
512      * Returns true if the value was added to the set, that is if it was not
513      * already present.
514      */
515     function _add(Set storage set, bytes32 value) private returns (bool) {
516         if (!_contains(set, value)) {
517             set._values.push(value);
518             // The value is stored at length-1, but we add 1 to all indexes
519             // and use 0 as a sentinel value
520             set._indexes[value] = set._values.length;
521             return true;
522         } else {
523             return false;
524         }
525     }
526 
527     /**
528      * @dev Removes a value from a set. O(1).
529      *
530      * Returns true if the value was removed from the set, that is if it was
531      * present.
532      */
533     function _remove(Set storage set, bytes32 value) private returns (bool) {
534         // We read and store the value's index to prevent multiple reads from the same storage slot
535         uint256 valueIndex = set._indexes[value];
536 
537         if (valueIndex != 0) { // Equivalent to contains(set, value)
538             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
539             // the array, and then remove the last element (sometimes called as 'swap and pop').
540             // This modifies the order of the array, as noted in {at}.
541 
542             uint256 toDeleteIndex = valueIndex - 1;
543             uint256 lastIndex = set._values.length - 1;
544 
545             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
546             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
547 
548             bytes32 lastvalue = set._values[lastIndex];
549 
550             // Move the last value to the index where the value to delete is
551             set._values[toDeleteIndex] = lastvalue;
552             // Update the index for the moved value
553             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
554 
555             // Delete the slot where the moved value was stored
556             set._values.pop();
557 
558             // Delete the index for the deleted slot
559             delete set._indexes[value];
560 
561             return true;
562         } else {
563             return false;
564         }
565     }
566 
567     /**
568      * @dev Returns true if the value is in the set. O(1).
569      */
570     function _contains(Set storage set, bytes32 value) private view returns (bool) {
571         return set._indexes[value] != 0;
572     }
573 
574     /**
575      * @dev Returns the number of values on the set. O(1).
576      */
577     function _length(Set storage set) private view returns (uint256) {
578         return set._values.length;
579     }
580 
581    /**
582     * @dev Returns the value stored at position `index` in the set. O(1).
583     *
584     * Note that there are no guarantees on the ordering of values inside the
585     * array, and it may change when more values are added or removed.
586     *
587     * Requirements:
588     *
589     * - `index` must be strictly less than {length}.
590     */
591     function _at(Set storage set, uint256 index) private view returns (bytes32) {
592         require(set._values.length > index, "EnumerableSet: index out of bounds");
593         return set._values[index];
594     }
595 
596     // AddressSet
597 
598     struct AddressSet {
599         Set _inner;
600     }
601 
602     /**
603      * @dev Add a value to a set. O(1).
604      *
605      * Returns true if the value was added to the set, that is if it was not
606      * already present.
607      */
608     function add(AddressSet storage set, address value) internal returns (bool) {
609         return _add(set._inner, bytes32(uint256(value)));
610     }
611 
612     /**
613      * @dev Removes a value from a set. O(1).
614      *
615      * Returns true if the value was removed from the set, that is if it was
616      * present.
617      */
618     function remove(AddressSet storage set, address value) internal returns (bool) {
619         return _remove(set._inner, bytes32(uint256(value)));
620     }
621 
622     /**
623      * @dev Returns true if the value is in the set. O(1).
624      */
625     function contains(AddressSet storage set, address value) internal view returns (bool) {
626         return _contains(set._inner, bytes32(uint256(value)));
627     }
628 
629     /**
630      * @dev Returns the number of values in the set. O(1).
631      */
632     function length(AddressSet storage set) internal view returns (uint256) {
633         return _length(set._inner);
634     }
635 
636    /**
637     * @dev Returns the value stored at position `index` in the set. O(1).
638     *
639     * Note that there are no guarantees on the ordering of values inside the
640     * array, and it may change when more values are added or removed.
641     *
642     * Requirements:
643     *
644     * - `index` must be strictly less than {length}.
645     */
646     function at(AddressSet storage set, uint256 index) internal view returns (address) {
647         return address(uint256(_at(set._inner, index)));
648     }
649 
650 
651     // UintSet
652 
653     struct UintSet {
654         Set _inner;
655     }
656 
657     /**
658      * @dev Add a value to a set. O(1).
659      *
660      * Returns true if the value was added to the set, that is if it was not
661      * already present.
662      */
663     function add(UintSet storage set, uint256 value) internal returns (bool) {
664         return _add(set._inner, bytes32(value));
665     }
666 
667     /**
668      * @dev Removes a value from a set. O(1).
669      *
670      * Returns true if the value was removed from the set, that is if it was
671      * present.
672      */
673     function remove(UintSet storage set, uint256 value) internal returns (bool) {
674         return _remove(set._inner, bytes32(value));
675     }
676 
677     /**
678      * @dev Returns true if the value is in the set. O(1).
679      */
680     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
681         return _contains(set._inner, bytes32(value));
682     }
683 
684     /**
685      * @dev Returns the number of values on the set. O(1).
686      */
687     function length(UintSet storage set) internal view returns (uint256) {
688         return _length(set._inner);
689     }
690 
691    /**
692     * @dev Returns the value stored at position `index` in the set. O(1).
693     *
694     * Note that there are no guarantees on the ordering of values inside the
695     * array, and it may change when more values are added or removed.
696     *
697     * Requirements:
698     *
699     * - `index` must be strictly less than {length}.
700     */
701     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
702         return uint256(_at(set._inner, index));
703     }
704 }
705 
706 // File: @openzeppelin/contracts/GSN/Context.sol
707 
708 
709 pragma solidity ^0.6.0;
710 
711 /*
712  * @dev Provides information about the current execution context, including the
713  * sender of the transaction and its data. While these are generally available
714  * via msg.sender and msg.data, they should not be accessed in such a direct
715  * manner, since when dealing with GSN meta-transactions the account sending and
716  * paying for execution may not be the actual sender (as far as an application
717  * is concerned).
718  *
719  * This contract is only required for intermediate, library-like contracts.
720  */
721 abstract contract Context {
722     function _msgSender() internal view virtual returns (address payable) {
723         return msg.sender;
724     }
725 
726     function _msgData() internal view virtual returns (bytes memory) {
727         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
728         return msg.data;
729     }
730 }
731 
732 // File: @openzeppelin/contracts/access/Ownable.sol
733 
734 
735 pragma solidity ^0.6.0;
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
801 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
802 
803 
804 pragma solidity ^0.6.0;
805 
806 
807 
808 
809 
810 /**
811  * @dev Implementation of the {IERC20} interface.
812  *
813  * This implementation is agnostic to the way tokens are created. This means
814  * that a supply mechanism has to be added in a derived contract using {_mint}.
815  * For a generic mechanism see {ERC20PresetMinterPauser}.
816  *
817  * TIP: For a detailed writeup see our guide
818  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
819  * to implement supply mechanisms].
820  *
821  * We have followed general OpenZeppelin guidelines: functions revert instead
822  * of returning `false` on failure. This behavior is nonetheless conventional
823  * and does not conflict with the expectations of ERC20 applications.
824  *
825  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
826  * This allows applications to reconstruct the allowance for all accounts just
827  * by listening to said events. Other implementations of the EIP may not emit
828  * these events, as it isn't required by the specification.
829  *
830  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
831  * functions have been added to mitigate the well-known issues around setting
832  * allowances. See {IERC20-approve}.
833  */
834 contract ERC20 is Context, IERC20 {
835     using SafeMath for uint256;
836     using Address for address;
837 
838     mapping (address => uint256) private _balances;
839 
840     mapping (address => mapping (address => uint256)) private _allowances;
841 
842     uint256 private _totalSupply;
843 
844     string private _name;
845     string private _symbol;
846     uint8 private _decimals;
847 
848     /**
849      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
850      * a default value of 18.
851      *
852      * To select a different value for {decimals}, use {_setupDecimals}.
853      *
854      * All three of these values are immutable: they can only be set once during
855      * construction.
856      */
857     constructor (string memory name, string memory symbol) public {
858         _name = name;
859         _symbol = symbol;
860         _decimals = 18;
861     }
862 
863     /**
864      * @dev Returns the name of the token.
865      */
866     function name() public view returns (string memory) {
867         return _name;
868     }
869 
870     /**
871      * @dev Returns the symbol of the token, usually a shorter version of the
872      * name.
873      */
874     function symbol() public view returns (string memory) {
875         return _symbol;
876     }
877 
878     /**
879      * @dev Returns the number of decimals used to get its user representation.
880      * For example, if `decimals` equals `2`, a balance of `505` tokens should
881      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
882      *
883      * Tokens usually opt for a value of 18, imitating the relationship between
884      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
885      * called.
886      *
887      * NOTE: This information is only used for _display_ purposes: it in
888      * no way affects any of the arithmetic of the contract, including
889      * {IERC20-balanceOf} and {IERC20-transfer}.
890      */
891     function decimals() public view returns (uint8) {
892         return _decimals;
893     }
894 
895     /**
896      * @dev See {IERC20-totalSupply}.
897      */
898     function totalSupply() public view override returns (uint256) {
899         return _totalSupply;
900     }
901 
902     /**
903      * @dev See {IERC20-balanceOf}.
904      */
905     function balanceOf(address account) public view override returns (uint256) {
906         return _balances[account];
907     }
908 
909     /**
910      * @dev See {IERC20-transfer}.
911      *
912      * Requirements:
913      *
914      * - `recipient` cannot be the zero address.
915      * - the caller must have a balance of at least `amount`.
916      */
917     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
918         _transfer(_msgSender(), recipient, amount);
919         return true;
920     }
921 
922     /**
923      * @dev See {IERC20-allowance}.
924      */
925     function allowance(address owner, address spender) public view virtual override returns (uint256) {
926         return _allowances[owner][spender];
927     }
928 
929     /**
930      * @dev See {IERC20-approve}.
931      *
932      * Requirements:
933      *
934      * - `spender` cannot be the zero address.
935      */
936     function approve(address spender, uint256 amount) public virtual override returns (bool) {
937         _approve(_msgSender(), spender, amount);
938         return true;
939     }
940 
941     /**
942      * @dev See {IERC20-transferFrom}.
943      *
944      * Emits an {Approval} event indicating the updated allowance. This is not
945      * required by the EIP. See the note at the beginning of {ERC20};
946      *
947      * Requirements:
948      * - `sender` and `recipient` cannot be the zero address.
949      * - `sender` must have a balance of at least `amount`.
950      * - the caller must have allowance for ``sender``'s tokens of at least
951      * `amount`.
952      */
953     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
954         _transfer(sender, recipient, amount);
955         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
956         return true;
957     }
958 
959     /**
960      * @dev Atomically increases the allowance granted to `spender` by the caller.
961      *
962      * This is an alternative to {approve} that can be used as a mitigation for
963      * problems described in {IERC20-approve}.
964      *
965      * Emits an {Approval} event indicating the updated allowance.
966      *
967      * Requirements:
968      *
969      * - `spender` cannot be the zero address.
970      */
971     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
972         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
973         return true;
974     }
975 
976     /**
977      * @dev Atomically decreases the allowance granted to `spender` by the caller.
978      *
979      * This is an alternative to {approve} that can be used as a mitigation for
980      * problems described in {IERC20-approve}.
981      *
982      * Emits an {Approval} event indicating the updated allowance.
983      *
984      * Requirements:
985      *
986      * - `spender` cannot be the zero address.
987      * - `spender` must have allowance for the caller of at least
988      * `subtractedValue`.
989      */
990     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
991         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
992         return true;
993     }
994 
995     /**
996      * @dev Moves tokens `amount` from `sender` to `recipient`.
997      *
998      * This is internal function is equivalent to {transfer}, and can be used to
999      * e.g. implement automatic token fees, slashing mechanisms, etc.
1000      *
1001      * Emits a {Transfer} event.
1002      *
1003      * Requirements:
1004      *
1005      * - `sender` cannot be the zero address.
1006      * - `recipient` cannot be the zero address.
1007      * - `sender` must have a balance of at least `amount`.
1008      */
1009     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1010         require(sender != address(0), "ERC20: transfer from the zero address");
1011         require(recipient != address(0), "ERC20: transfer to the zero address");
1012 
1013         _beforeTokenTransfer(sender, recipient, amount);
1014 
1015         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1016         _balances[recipient] = _balances[recipient].add(amount);
1017         emit Transfer(sender, recipient, amount);
1018     }
1019 
1020     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1021      * the total supply.
1022      *
1023      * Emits a {Transfer} event with `from` set to the zero address.
1024      *
1025      * Requirements
1026      *
1027      * - `to` cannot be the zero address.
1028      */
1029     function _mint(address account, uint256 amount) internal virtual {
1030         require(account != address(0), "ERC20: mint to the zero address");
1031 
1032         _beforeTokenTransfer(address(0), account, amount);
1033 
1034         _totalSupply = _totalSupply.add(amount);
1035         _balances[account] = _balances[account].add(amount);
1036         emit Transfer(address(0), account, amount);
1037     }
1038 
1039     /**
1040      * @dev Destroys `amount` tokens from `account`, reducing the
1041      * total supply.
1042      *
1043      * Emits a {Transfer} event with `to` set to the zero address.
1044      *
1045      * Requirements
1046      *
1047      * - `account` cannot be the zero address.
1048      * - `account` must have at least `amount` tokens.
1049      */
1050     function _burn(address account, uint256 amount) internal virtual {
1051         require(account != address(0), "ERC20: burn from the zero address");
1052 
1053         _beforeTokenTransfer(account, address(0), amount);
1054 
1055         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1056         _totalSupply = _totalSupply.sub(amount);
1057         emit Transfer(account, address(0), amount);
1058     }
1059 
1060     /**
1061      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1062      *
1063      * This internal function is equivalent to `approve`, and can be used to
1064      * e.g. set automatic allowances for certain subsystems, etc.
1065      *
1066      * Emits an {Approval} event.
1067      *
1068      * Requirements:
1069      *
1070      * - `owner` cannot be the zero address.
1071      * - `spender` cannot be the zero address.
1072      */
1073     function _approve(address owner, address spender, uint256 amount) internal virtual {
1074         require(owner != address(0), "ERC20: approve from the zero address");
1075         require(spender != address(0), "ERC20: approve to the zero address");
1076 
1077         _allowances[owner][spender] = amount;
1078         emit Approval(owner, spender, amount);
1079     }
1080 
1081     /**
1082      * @dev Sets {decimals} to a value other than the default one of 18.
1083      *
1084      * WARNING: This function should only be called from the constructor. Most
1085      * applications that interact with token contracts will not expect
1086      * {decimals} to ever change, and may work incorrectly if it does.
1087      */
1088     function _setupDecimals(uint8 decimals_) internal {
1089         _decimals = decimals_;
1090     }
1091 
1092     /**
1093      * @dev Hook that is called before any transfer of tokens. This includes
1094      * minting and burning.
1095      *
1096      * Calling conditions:
1097      *
1098      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1099      * will be to transferred to `to`.
1100      * - when `from` is zero, `amount` tokens will be minted for `to`.
1101      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1102      * - `from` and `to` are never both zero.
1103      *
1104      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1105      */
1106     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1107 }
1108 
1109 // File: contracts/MilkToken.sol
1110 
1111 pragma solidity 0.6.12;
1112 
1113 
1114 
1115 contract MilkToken is ERC20("MilkToken", "MILK"), Ownable {
1116     function mint(address _to, uint256 _amount) public onlyOwner {
1117         _mint(_to, _amount);
1118         _moveDelegates(address(0), _delegates[_to], _amount);
1119     }
1120     mapping (address => address) internal _delegates;
1121     struct Checkpoint { uint32 fromBlock; uint256 votes; }
1122     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1123     mapping (address => uint32) public numCheckpoints;
1124     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1125     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1126     mapping (address => uint) public nonces;
1127     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1128     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1129     function delegates(address delegator) external view returns (address) {
1130         return _delegates[delegator];
1131     }
1132     function delegate(address delegatee) external {
1133         return _delegate(msg.sender, delegatee);
1134     }
1135     function delegateBySig( address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external {
1136         bytes32 domainSeparator = keccak256(
1137             abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), getChainId(), address(this))
1138         );
1139         bytes32 structHash = keccak256(
1140             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
1141         );
1142         bytes32 digest = keccak256(
1143             abi.encodePacked("\x19\x01", domainSeparator, structHash)
1144         );
1145         address signatory = ecrecover(digest, v, r, s);
1146         require(signatory != address(0), "MILK::delegateBySig: invalid signature");
1147         require(nonce == nonces[signatory]++, "MILK::delegateBySig: invalid nonce");
1148         require(now <= expiry, "MILK::delegateBySig: signature expired");
1149         return _delegate(signatory, delegatee);
1150     }
1151     function getCurrentVotes(address account) external view returns (uint256) {
1152         uint32 nCheckpoints = numCheckpoints[account];
1153         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1154     }
1155     function getPriorVotes(address account, uint blockNumber) external view returns (uint256) {
1156         require(blockNumber < block.number, "MILK::getPriorVotes: not yet determined");
1157         uint32 nCheckpoints = numCheckpoints[account];
1158         if (nCheckpoints == 0) {
1159             return 0;
1160         }
1161         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1162             return checkpoints[account][nCheckpoints - 1].votes;
1163         }
1164         if (checkpoints[account][0].fromBlock > blockNumber) {
1165             return 0;
1166         }
1167         uint32 lower = 0;
1168         uint32 upper = nCheckpoints - 1;
1169         while (upper > lower) {
1170             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1171             Checkpoint memory cp = checkpoints[account][center];
1172             if (cp.fromBlock == blockNumber) {
1173                 return cp.votes;
1174             } else if (cp.fromBlock < blockNumber) {
1175                 lower = center;
1176             } else {
1177                 upper = center - 1;
1178             }
1179         }
1180         return checkpoints[account][lower].votes;
1181     }
1182     function _delegate(address delegator, address delegatee) internal {
1183         address currentDelegate = _delegates[delegator];
1184         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MILK (not scaled);
1185         _delegates[delegator] = delegatee;
1186         emit DelegateChanged(delegator, currentDelegate, delegatee);
1187         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1188     }
1189     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1190         if (srcRep != dstRep && amount > 0) {
1191             if (srcRep != address(0)) {
1192                 uint32 srcRepNum = numCheckpoints[srcRep];
1193                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1194                 uint256 srcRepNew = srcRepOld.sub(amount);
1195                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1196             }
1197             if (dstRep != address(0)) {
1198                 uint32 dstRepNum = numCheckpoints[dstRep];
1199                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1200                 uint256 dstRepNew = dstRepOld.add(amount);
1201                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1202             }
1203         }
1204     }
1205     function _writeCheckpoint( address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {
1206         uint32 blockNumber = safe32(block.number, "MILK::_writeCheckpoint: block number exceeds 32 bits");
1207         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1208             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1209         } else {
1210             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1211             numCheckpoints[delegatee] = nCheckpoints + 1;
1212         }
1213         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1214     }
1215     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1216         require(n < 2**32, errorMessage);
1217         return uint32(n);
1218     }
1219     function getChainId() internal pure returns (uint) {
1220         uint256 chainId;
1221         assembly { chainId := chainid() }
1222         return chainId;
1223     }
1224 }
1225 
1226 // File: contracts/MilkChef.sol
1227 
1228 pragma solidity 0.6.12;
1229 
1230 
1231 
1232 
1233 
1234 
1235 interface IMigratorChef {
1236     function migrate(IERC20 token) external returns (IERC20);
1237 }
1238 contract MasterChef is Ownable {
1239     using SafeMath for uint256;
1240     using SafeERC20 for IERC20;
1241     struct UserInfo {
1242         uint256 amount;     // How many LP tokens the user has provided.
1243         uint256 rewardDebt; // Reward debt. See explanation below.
1244     }
1245     struct PoolInfo {
1246         IERC20 lpToken;           // Address of LP token contract.
1247         uint256 allocPoint;       // How many allocation points assigned to this pool. MILKs to distribute per block.
1248         uint256 lastRewardBlock;  // Last block number that MILKs distribution occurs.
1249         uint256 accMilkPerShare; // Accumulated MILKs per share, times 1e12. See below.
1250     }
1251     MilkToken public milk;
1252     uint256 public bonusEndBlock;
1253     uint256 public milkPerBlock;
1254     uint256 public constant BONUS_MULTIPLIER = 3;
1255     IMigratorChef public migrator;
1256     PoolInfo[] public poolInfo;
1257     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1258     uint256 public totalAllocPoint = 0;
1259     uint256 public startBlock;
1260     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1261     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1262     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1263     constructor( MilkToken _milk, uint256 _milkPerBlock, uint256 _startBlock, uint256 _bonusEndBlock) public {
1264         milk = _milk;
1265         milkPerBlock = _milkPerBlock;
1266         bonusEndBlock = _bonusEndBlock;
1267         startBlock = _startBlock;
1268     }
1269     function poolLength() external view returns (uint256) {
1270         return poolInfo.length;
1271     }
1272     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1273         if (_withUpdate) {
1274             massUpdatePools();
1275         }
1276         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1277         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1278         poolInfo.push(PoolInfo({
1279             lpToken: _lpToken,
1280             allocPoint: _allocPoint,
1281             lastRewardBlock: lastRewardBlock,
1282             accMilkPerShare: 0
1283         }));
1284     }
1285     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1286         if (_withUpdate) {
1287             massUpdatePools();
1288         }
1289         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1290         poolInfo[_pid].allocPoint = _allocPoint;
1291     }
1292     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1293         migrator = _migrator;
1294     }
1295     function migrate(uint256 _pid) public {
1296         require(address(migrator) != address(0), "migrate: no migrator");
1297         PoolInfo storage pool = poolInfo[_pid];
1298         IERC20 lpToken = pool.lpToken;
1299         uint256 bal = lpToken.balanceOf(address(this));
1300         lpToken.safeApprove(address(migrator), bal);
1301         IERC20 newLpToken = migrator.migrate(lpToken);
1302         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1303         pool.lpToken = newLpToken;
1304     }
1305     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1306         if (_to <= bonusEndBlock) {
1307             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1308         } else if (_from >= bonusEndBlock) {
1309             return _to.sub(_from);
1310         } else {
1311             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1312                 _to.sub(bonusEndBlock)
1313             );
1314         }
1315     }
1316     function pendingMilk(uint256 _pid, address _user) external view returns (uint256) {
1317         PoolInfo storage pool = poolInfo[_pid];
1318         UserInfo storage user = userInfo[_pid][_user];
1319         uint256 accMilkPerShare = pool.accMilkPerShare;
1320         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1321         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1322             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1323             uint256 milkReward = multiplier.mul(milkPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1324             accMilkPerShare = accMilkPerShare.add(milkReward.mul(1e12).div(lpSupply));
1325         }
1326         return user.amount.mul(accMilkPerShare).div(1e12).sub(user.rewardDebt);
1327     }
1328     function massUpdatePools() public {
1329         uint256 length = poolInfo.length;
1330         for (uint256 pid = 0; pid < length; ++pid) {
1331             updatePool(pid);
1332         }
1333     }
1334     function updatePool(uint256 _pid) public {
1335         PoolInfo storage pool = poolInfo[_pid];
1336         if (block.number <= pool.lastRewardBlock) {
1337             return;
1338         }
1339         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1340         if (lpSupply == 0) {
1341             pool.lastRewardBlock = block.number;
1342             return;
1343         }
1344         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1345         uint256 milkReward = multiplier.mul(milkPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1346         milk.mint(address(this), milkReward);
1347         pool.accMilkPerShare = pool.accMilkPerShare.add(milkReward.mul(1e12).div(lpSupply));
1348         pool.lastRewardBlock = block.number;
1349     }
1350     function deposit(uint256 _pid, uint256 _amount) public {
1351         PoolInfo storage pool = poolInfo[_pid];
1352         UserInfo storage user = userInfo[_pid][msg.sender];
1353         updatePool(_pid);
1354         if (user.amount > 0) {
1355             uint256 pending = user.amount.mul(pool.accMilkPerShare).div(1e12).sub(user.rewardDebt);
1356             safeMilkTransfer(msg.sender, pending);
1357         }
1358         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1359         user.amount = user.amount.add(_amount);
1360         user.rewardDebt = user.amount.mul(pool.accMilkPerShare).div(1e12);
1361         emit Deposit(msg.sender, _pid, _amount);
1362     }
1363     function withdraw(uint256 _pid, uint256 _amount) public {
1364         PoolInfo storage pool = poolInfo[_pid];
1365         UserInfo storage user = userInfo[_pid][msg.sender];
1366         require(user.amount >= _amount, "withdraw: not good");
1367         updatePool(_pid);
1368         uint256 pending = user.amount.mul(pool.accMilkPerShare).div(1e12).sub(user.rewardDebt);
1369         safeMilkTransfer(msg.sender, pending);
1370         user.amount = user.amount.sub(_amount);
1371         user.rewardDebt = user.amount.mul(pool.accMilkPerShare).div(1e12);
1372         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1373         emit Withdraw(msg.sender, _pid, _amount);
1374     }
1375     function emergencyWithdraw(uint256 _pid) public {
1376         PoolInfo storage pool = poolInfo[_pid];
1377         UserInfo storage user = userInfo[_pid][msg.sender];
1378         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1379         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1380         user.amount = 0;
1381         user.rewardDebt = 0;
1382     }
1383     function safeMilkTransfer(address _to, uint256 _amount) internal {
1384         uint256 milkBal = milk.balanceOf(address(this));
1385         if (_amount > milkBal) {
1386             milk.transfer(_to, milkBal);
1387         } else {
1388             milk.transfer(_to, _amount);
1389         }
1390     }
1391 }