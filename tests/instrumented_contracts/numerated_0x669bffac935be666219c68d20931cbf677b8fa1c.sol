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
77 // File: @openzeppelin/contracts/math/SafeMath.sol
78 
79 // SPDX-License-Identifier: MIT
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
241 // SPDX-License-Identifier: MIT
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
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
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
383 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
384 
385 // SPDX-License-Identifier: MIT
386 
387 pragma solidity ^0.6.0;
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
460 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
461 
462 // SPDX-License-Identifier: MIT
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
708 // SPDX-License-Identifier: MIT
709 
710 pragma solidity ^0.6.0;
711 
712 /*
713  * @dev Provides information about the current execution context, including the
714  * sender of the transaction and its data. While these are generally available
715  * via msg.sender and msg.data, they should not be accessed in such a direct
716  * manner, since when dealing with GSN meta-transactions the account sending and
717  * paying for execution may not be the actual sender (as far as an application
718  * is concerned).
719  *
720  * This contract is only required for intermediate, library-like contracts.
721  */
722 abstract contract Context {
723     function _msgSender() internal view virtual returns (address payable) {
724         return msg.sender;
725     }
726 
727     function _msgData() internal view virtual returns (bytes memory) {
728         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
729         return msg.data;
730     }
731 }
732 
733 // File: @openzeppelin/contracts/access/Ownable.sol
734 
735 // SPDX-License-Identifier: MIT
736 
737 pragma solidity ^0.6.0;
738 
739 /**
740  * @dev Contract module which provides a basic access control mechanism, where
741  * there is an account (an owner) that can be granted exclusive access to
742  * specific functions.
743  *
744  * By default, the owner account will be the one that deploys the contract. This
745  * can later be changed with {transferOwnership}.
746  *
747  * This module is used through inheritance. It will make available the modifier
748  * `onlyOwner`, which can be applied to your functions to restrict their use to
749  * the owner.
750  */
751 contract Ownable is Context {
752     address private _owner;
753 
754     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
755 
756     /**
757      * @dev Initializes the contract setting the deployer as the initial owner.
758      */
759     constructor () internal {
760         address msgSender = _msgSender();
761         _owner = msgSender;
762         emit OwnershipTransferred(address(0), msgSender);
763     }
764 
765     /**
766      * @dev Returns the address of the current owner.
767      */
768     function owner() public view returns (address) {
769         return _owner;
770     }
771 
772     /**
773      * @dev Throws if called by any account other than the owner.
774      */
775     modifier onlyOwner() {
776         require(_owner == _msgSender(), "Ownable: caller is not the owner");
777         _;
778     }
779 
780     /**
781      * @dev Leaves the contract without owner. It will not be possible to call
782      * `onlyOwner` functions anymore. Can only be called by the current owner.
783      *
784      * NOTE: Renouncing ownership will leave the contract without an owner,
785      * thereby removing any functionality that is only available to the owner.
786      */
787     function renounceOwnership() public virtual onlyOwner {
788         emit OwnershipTransferred(_owner, address(0));
789         _owner = address(0);
790     }
791 
792     /**
793      * @dev Transfers ownership of the contract to a new account (`newOwner`).
794      * Can only be called by the current owner.
795      */
796     function transferOwnership(address newOwner) public virtual onlyOwner {
797         require(newOwner != address(0), "Ownable: new owner is the zero address");
798         emit OwnershipTransferred(_owner, newOwner);
799         _owner = newOwner;
800     }
801 }
802 
803 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
804 
805 // SPDX-License-Identifier: MIT
806 
807 pragma solidity ^0.6.0;
808 
809 
810 
811 
812 
813 /**
814  * @dev Implementation of the {IERC20} interface.
815  *
816  * This implementation is agnostic to the way tokens are created. This means
817  * that a supply mechanism has to be added in a derived contract using {_mint}.
818  * For a generic mechanism see {ERC20PresetMinterPauser}.
819  *
820  * TIP: For a detailed writeup see our guide
821  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
822  * to implement supply mechanisms].
823  *
824  * We have followed general OpenZeppelin guidelines: functions revert instead
825  * of returning `false` on failure. This behavior is nonetheless conventional
826  * and does not conflict with the expectations of ERC20 applications.
827  *
828  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
829  * This allows applications to reconstruct the allowance for all accounts just
830  * by listening to said events. Other implementations of the EIP may not emit
831  * these events, as it isn't required by the specification.
832  *
833  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
834  * functions have been added to mitigate the well-known issues around setting
835  * allowances. See {IERC20-approve}.
836  */
837 contract ERC20 is Context, IERC20 {
838     using SafeMath for uint256;
839     using Address for address;
840 
841     mapping (address => uint256) private _balances;
842 
843     mapping (address => mapping (address => uint256)) private _allowances;
844 
845     uint256 private _totalSupply;
846 
847     string private _name;
848     string private _symbol;
849     uint8 private _decimals;
850 
851     /**
852      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
853      * a default value of 18.
854      *
855      * To select a different value for {decimals}, use {_setupDecimals}.
856      *
857      * All three of these values are immutable: they can only be set once during
858      * construction.
859      */
860     constructor (string memory name, string memory symbol) public {
861         _name = name;
862         _symbol = symbol;
863         _decimals = 18;
864     }
865 
866     /**
867      * @dev Returns the name of the token.
868      */
869     function name() public view returns (string memory) {
870         return _name;
871     }
872 
873     /**
874      * @dev Returns the symbol of the token, usually a shorter version of the
875      * name.
876      */
877     function symbol() public view returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev Returns the number of decimals used to get its user representation.
883      * For example, if `decimals` equals `2`, a balance of `505` tokens should
884      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
885      *
886      * Tokens usually opt for a value of 18, imitating the relationship between
887      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
888      * called.
889      *
890      * NOTE: This information is only used for _display_ purposes: it in
891      * no way affects any of the arithmetic of the contract, including
892      * {IERC20-balanceOf} and {IERC20-transfer}.
893      */
894     function decimals() public view returns (uint8) {
895         return _decimals;
896     }
897 
898     /**
899      * @dev See {IERC20-totalSupply}.
900      */
901     function totalSupply() public view override returns (uint256) {
902         return _totalSupply;
903     }
904 
905     /**
906      * @dev See {IERC20-balanceOf}.
907      */
908     function balanceOf(address account) public view override returns (uint256) {
909         return _balances[account];
910     }
911 
912     /**
913      * @dev See {IERC20-transfer}.
914      *
915      * Requirements:
916      *
917      * - `recipient` cannot be the zero address.
918      * - the caller must have a balance of at least `amount`.
919      */
920     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
921         _transfer(_msgSender(), recipient, amount);
922         return true;
923     }
924 
925     /**
926      * @dev See {IERC20-allowance}.
927      */
928     function allowance(address owner, address spender) public view virtual override returns (uint256) {
929         return _allowances[owner][spender];
930     }
931 
932     /**
933      * @dev See {IERC20-approve}.
934      *
935      * Requirements:
936      *
937      * - `spender` cannot be the zero address.
938      */
939     function approve(address spender, uint256 amount) public virtual override returns (bool) {
940         _approve(_msgSender(), spender, amount);
941         return true;
942     }
943 
944     /**
945      * @dev See {IERC20-transferFrom}.
946      *
947      * Emits an {Approval} event indicating the updated allowance. This is not
948      * required by the EIP. See the note at the beginning of {ERC20};
949      *
950      * Requirements:
951      * - `sender` and `recipient` cannot be the zero address.
952      * - `sender` must have a balance of at least `amount`.
953      * - the caller must have allowance for ``sender``'s tokens of at least
954      * `amount`.
955      */
956     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
957         _transfer(sender, recipient, amount);
958         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
959         return true;
960     }
961 
962     /**
963      * @dev Atomically increases the allowance granted to `spender` by the caller.
964      *
965      * This is an alternative to {approve} that can be used as a mitigation for
966      * problems described in {IERC20-approve}.
967      *
968      * Emits an {Approval} event indicating the updated allowance.
969      *
970      * Requirements:
971      *
972      * - `spender` cannot be the zero address.
973      */
974     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
975         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
976         return true;
977     }
978 
979     /**
980      * @dev Atomically decreases the allowance granted to `spender` by the caller.
981      *
982      * This is an alternative to {approve} that can be used as a mitigation for
983      * problems described in {IERC20-approve}.
984      *
985      * Emits an {Approval} event indicating the updated allowance.
986      *
987      * Requirements:
988      *
989      * - `spender` cannot be the zero address.
990      * - `spender` must have allowance for the caller of at least
991      * `subtractedValue`.
992      */
993     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
994         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
995         return true;
996     }
997 
998     /**
999      * @dev Moves tokens `amount` from `sender` to `recipient`.
1000      *
1001      * This is internal function is equivalent to {transfer}, and can be used to
1002      * e.g. implement automatic token fees, slashing mechanisms, etc.
1003      *
1004      * Emits a {Transfer} event.
1005      *
1006      * Requirements:
1007      *
1008      * - `sender` cannot be the zero address.
1009      * - `recipient` cannot be the zero address.
1010      * - `sender` must have a balance of at least `amount`.
1011      */
1012     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1013         require(sender != address(0), "ERC20: transfer from the zero address");
1014         require(recipient != address(0), "ERC20: transfer to the zero address");
1015 
1016         _beforeTokenTransfer(sender, recipient, amount);
1017 
1018         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1019         _balances[recipient] = _balances[recipient].add(amount);
1020         emit Transfer(sender, recipient, amount);
1021     }
1022 
1023     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1024      * the total supply.
1025      *
1026      * Emits a {Transfer} event with `from` set to the zero address.
1027      *
1028      * Requirements
1029      *
1030      * - `to` cannot be the zero address.
1031      */
1032     function _mint(address account, uint256 amount) internal virtual {
1033         require(account != address(0), "ERC20: mint to the zero address");
1034 
1035         _beforeTokenTransfer(address(0), account, amount);
1036 
1037         _totalSupply = _totalSupply.add(amount);
1038         _balances[account] = _balances[account].add(amount);
1039         emit Transfer(address(0), account, amount);
1040     }
1041 
1042     /**
1043      * @dev Destroys `amount` tokens from `account`, reducing the
1044      * total supply.
1045      *
1046      * Emits a {Transfer} event with `to` set to the zero address.
1047      *
1048      * Requirements
1049      *
1050      * - `account` cannot be the zero address.
1051      * - `account` must have at least `amount` tokens.
1052      */
1053     function _burn(address account, uint256 amount) internal virtual {
1054         require(account != address(0), "ERC20: burn from the zero address");
1055 
1056         _beforeTokenTransfer(account, address(0), amount);
1057 
1058         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1059         _totalSupply = _totalSupply.sub(amount);
1060         emit Transfer(account, address(0), amount);
1061     }
1062 
1063     /**
1064      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1065      *
1066      * This is internal function is equivalent to `approve`, and can be used to
1067      * e.g. set automatic allowances for certain subsystems, etc.
1068      *
1069      * Emits an {Approval} event.
1070      *
1071      * Requirements:
1072      *
1073      * - `owner` cannot be the zero address.
1074      * - `spender` cannot be the zero address.
1075      */
1076     function _approve(address owner, address spender, uint256 amount) internal virtual {
1077         require(owner != address(0), "ERC20: approve from the zero address");
1078         require(spender != address(0), "ERC20: approve to the zero address");
1079 
1080         _allowances[owner][spender] = amount;
1081         emit Approval(owner, spender, amount);
1082     }
1083 
1084     /**
1085      * @dev Sets {decimals} to a value other than the default one of 18.
1086      *
1087      * WARNING: This function should only be called from the constructor. Most
1088      * applications that interact with token contracts will not expect
1089      * {decimals} to ever change, and may work incorrectly if it does.
1090      */
1091     function _setupDecimals(uint8 decimals_) internal {
1092         _decimals = decimals_;
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any transfer of tokens. This includes
1097      * minting and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1102      * will be to transferred to `to`.
1103      * - when `from` is zero, `amount` tokens will be minted for `to`.
1104      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1110 }
1111 
1112 // File: contracts/NiceToken.sol
1113 
1114 pragma solidity ^0.6.2;
1115 
1116 
1117 
1118 // SushiToken with Governance.
1119 contract NiceToken is ERC20("NiceToken", "NICE"), Ownable {
1120     // START OF NICE SPECIFIC CODE
1121 
1122     // NICE is a copy of SUSHI https://etherscan.io/token/0x6b3595068778dd592e39a122f4f5a5cf09c90fe2
1123     // except for the following code, which implements 
1124     // a burn percent on each transfer. The burn percent (burnDivisor) 
1125     // is set periodically and automatically by the 
1126     // contract owner (PoliceChief contract) to make sure
1127     // NICE total supply remains pegged between 69 and 420
1128 
1129     // It also fixes the governance move delegate bug
1130     // https://medium.com/bulldax-finance/sushiswap-delegation-double-spending-bug-5adcc7b3830f
1131 
1132     using SafeMath for uint256;
1133 
1134     // the amount of burn during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
1135     uint256 public burnDivisor = 100;
1136     // keep track of total supply burned (for fun only, serves no purpose)
1137     uint256 public totalSupplyBurned;
1138 
1139     function setBurnDivisor(uint256 _burnDivisor) public onlyOwner {
1140         require(_burnDivisor > 3, "NICE::setBurnDivisor: burnDivisor must be bigger than 3"); // 100 / 4 == 25% max burn
1141         burnDivisor = _burnDivisor;
1142     }
1143 
1144     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1145         // calculate burn amount
1146         uint256 burnAmount = amount.div(burnDivisor);
1147         // burn burn amount
1148         burn(msg.sender, burnAmount);
1149         // fix governance delegate bug
1150         _moveDelegates(_delegates[msg.sender], _delegates[recipient], amount.sub(burnAmount));
1151         // transfer amount minus burn amount
1152         return super.transfer(recipient, amount.sub(burnAmount));
1153     }
1154 
1155     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1156         // calculate burn amount
1157         uint256 burnAmount = amount.div(burnDivisor);
1158         // burn burn amount
1159         burn(sender, burnAmount);
1160         // fix governance delegate bug
1161         _moveDelegates(_delegates[sender], _delegates[recipient], amount.sub(burnAmount));
1162         // transfer amount minus burn amount
1163         return super.transferFrom(sender, recipient, amount.sub(burnAmount));
1164     }
1165 
1166     // we need to implement our own burn function similar to 
1167     // sushi's mint function in order to call _moveDelegates
1168     // and to keep track of totalSupplyBurned
1169     function burn(address account, uint256 amount) private {
1170         _burn(account, amount);
1171         // keep track of total supply burned
1172         totalSupplyBurned = totalSupplyBurned.add(amount);
1173         // fix governance delegate bug
1174         _moveDelegates(_delegates[account], address(0), amount);
1175     }
1176 
1177     // END OF NICE SPECIFIC CODE
1178 
1179     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (PoliceChef).
1180     function mint(address _to, uint256 _amount) public onlyOwner {
1181         _mint(_to, _amount);
1182         _moveDelegates(address(0), _delegates[_to], _amount);
1183     }
1184 
1185     // Copied and modified from YAM code:
1186     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1187     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1188     // Which is copied and modified from COMPOUND:
1189     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1190 
1191     /// @notice A record of each accounts delegate
1192     mapping (address => address) internal _delegates;
1193 
1194     /// @notice A checkpoint for marking number of votes from a given block
1195     struct Checkpoint {
1196         uint32 fromBlock;
1197         uint256 votes;
1198     }
1199 
1200     /// @notice A record of votes checkpoints for each account, by index
1201     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1202 
1203     /// @notice The number of checkpoints for each account
1204     mapping (address => uint32) public numCheckpoints;
1205 
1206     /// @notice The EIP-712 typehash for the contract's domain
1207     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1208 
1209     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1210     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1211 
1212     /// @notice A record of states for signing / validating signatures
1213     mapping (address => uint) public nonces;
1214 
1215       /// @notice An event thats emitted when an account changes its delegate
1216     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1217 
1218     /// @notice An event thats emitted when a delegate account's vote balance changes
1219     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1220 
1221     /**
1222      * @notice Delegate votes from `msg.sender` to `delegatee`
1223      * @param delegator The address to get delegatee for
1224      */
1225     function delegates(address delegator)
1226         external
1227         view
1228         returns (address)
1229     {
1230         return _delegates[delegator];
1231     }
1232 
1233    /**
1234     * @notice Delegate votes from `msg.sender` to `delegatee`
1235     * @param delegatee The address to delegate votes to
1236     */
1237     function delegate(address delegatee) external {
1238         return _delegate(msg.sender, delegatee);
1239     }
1240 
1241     /**
1242      * @notice Delegates votes from signatory to `delegatee`
1243      * @param delegatee The address to delegate votes to
1244      * @param nonce The contract state required to match the signature
1245      * @param expiry The time at which to expire the signature
1246      * @param v The recovery byte of the signature
1247      * @param r Half of the ECDSA signature pair
1248      * @param s Half of the ECDSA signature pair
1249      */
1250     function delegateBySig(
1251         address delegatee,
1252         uint nonce,
1253         uint expiry,
1254         uint8 v,
1255         bytes32 r,
1256         bytes32 s
1257     )
1258         external
1259     {
1260         bytes32 domainSeparator = keccak256(
1261             abi.encode(
1262                 DOMAIN_TYPEHASH,
1263                 keccak256(bytes(name())),
1264                 getChainId(),
1265                 address(this)
1266             )
1267         );
1268 
1269         bytes32 structHash = keccak256(
1270             abi.encode(
1271                 DELEGATION_TYPEHASH,
1272                 delegatee,
1273                 nonce,
1274                 expiry
1275             )
1276         );
1277 
1278         bytes32 digest = keccak256(
1279             abi.encodePacked(
1280                 "\x19\x01",
1281                 domainSeparator,
1282                 structHash
1283             )
1284         );
1285 
1286         address signatory = ecrecover(digest, v, r, s);
1287         require(signatory != address(0), "SUSHI::delegateBySig: invalid signature");
1288         require(nonce == nonces[signatory]++, "SUSHI::delegateBySig: invalid nonce");
1289         require(now <= expiry, "SUSHI::delegateBySig: signature expired");
1290         return _delegate(signatory, delegatee);
1291     }
1292 
1293     /**
1294      * @notice Gets the current votes balance for `account`
1295      * @param account The address to get votes balance
1296      * @return The number of current votes for `account`
1297      */
1298     function getCurrentVotes(address account)
1299         external
1300         view
1301         returns (uint256)
1302     {
1303         uint32 nCheckpoints = numCheckpoints[account];
1304         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1305     }
1306 
1307     /**
1308      * @notice Determine the prior number of votes for an account as of a block number
1309      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1310      * @param account The address of the account to check
1311      * @param blockNumber The block number to get the vote balance at
1312      * @return The number of votes the account had as of the given block
1313      */
1314     function getPriorVotes(address account, uint blockNumber)
1315         external
1316         view
1317         returns (uint256)
1318     {
1319         require(blockNumber < block.number, "SUSHI::getPriorVotes: not yet determined");
1320 
1321         uint32 nCheckpoints = numCheckpoints[account];
1322         if (nCheckpoints == 0) {
1323             return 0;
1324         }
1325 
1326         // First check most recent balance
1327         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1328             return checkpoints[account][nCheckpoints - 1].votes;
1329         }
1330 
1331         // Next check implicit zero balance
1332         if (checkpoints[account][0].fromBlock > blockNumber) {
1333             return 0;
1334         }
1335 
1336         uint32 lower = 0;
1337         uint32 upper = nCheckpoints - 1;
1338         while (upper > lower) {
1339             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1340             Checkpoint memory cp = checkpoints[account][center];
1341             if (cp.fromBlock == blockNumber) {
1342                 return cp.votes;
1343             } else if (cp.fromBlock < blockNumber) {
1344                 lower = center;
1345             } else {
1346                 upper = center - 1;
1347             }
1348         }
1349         return checkpoints[account][lower].votes;
1350     }
1351 
1352     function _delegate(address delegator, address delegatee)
1353         internal
1354     {
1355         address currentDelegate = _delegates[delegator];
1356         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SUSHIs (not scaled);
1357         _delegates[delegator] = delegatee;
1358 
1359         emit DelegateChanged(delegator, currentDelegate, delegatee);
1360 
1361         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1362     }
1363 
1364     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1365         if (srcRep != dstRep && amount > 0) {
1366             if (srcRep != address(0)) {
1367                 // decrease old representative
1368                 uint32 srcRepNum = numCheckpoints[srcRep];
1369                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1370                 uint256 srcRepNew = srcRepOld.sub(amount);
1371                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1372             }
1373 
1374             if (dstRep != address(0)) {
1375                 // increase new representative
1376                 uint32 dstRepNum = numCheckpoints[dstRep];
1377                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1378                 uint256 dstRepNew = dstRepOld.add(amount);
1379                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1380             }
1381         }
1382     }
1383 
1384     function _writeCheckpoint(
1385         address delegatee,
1386         uint32 nCheckpoints,
1387         uint256 oldVotes,
1388         uint256 newVotes
1389     )
1390         internal
1391     {
1392         uint32 blockNumber = safe32(block.number, "SUSHI::_writeCheckpoint: block number exceeds 32 bits");
1393 
1394         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1395             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1396         } else {
1397             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1398             numCheckpoints[delegatee] = nCheckpoints + 1;
1399         }
1400 
1401         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1402     }
1403 
1404     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1405         require(n < 2**32, errorMessage);
1406         return uint32(n);
1407     }
1408 
1409     function getChainId() internal pure returns (uint) {
1410         uint256 chainId;
1411         assembly { chainId := chainid() }
1412         return chainId;
1413     }
1414 }
1415 
1416 // File: contracts/PoliceChief.sol
1417 
1418 pragma solidity ^0.6.2;
1419 
1420 
1421 
1422 
1423 
1424 
1425 
1426 /* START OF POLICE CHIEF EXPLANATION
1427 
1428 PoliceChief is a copy of SushiSwap's MasterChef 
1429 https://etherscan.io/address/0xc2edad668740f1aa35e4d8f227fb8e17dca888cd
1430 with a few differences, all annoted with the comment "NICE EDIT"
1431 to make it easy to verify that it is a copy.
1432 
1433 Difference 1:
1434 
1435 When the supply goes above 420, NICE burn rates are increased 
1436 dramatically and emissions cut, and when supply goes below 69, 
1437 emissions are increased dramatically and burn rates cut, 
1438 resulting in a token that has a total supply pegged between 
1439 69 and 420.
1440 
1441 Difference 2:
1442 
1443 The dev fund is set to 0.69% (nice) instead of 10%, so
1444 no rug pulls.
1445 
1446 Difference 3:
1447 
1448 Migrator is removed, so LP staked in PoliceChief are
1449 100% safe and cannot be stolen by the owner. This removes
1450 the need to use a timelock, because the only malicious thing
1451 the PoliceChief owner can do is add sketchy pools, which do
1452 not endanger your LP https://twitter.com/Quantstamp/status/1301280991021993984
1453 
1454 Emissions:
1455 
1456 The initial sushi per block is set to 5000000000000000 (0.005)
1457 NICE per block, which leads to ~420 NICE very 2 weeks.
1458 
1459 END OF POLICE CHIEF EXPLANATION */
1460 
1461 // PoliceChief is the master of Sushi. He can make Sushi and he is a fair guy.
1462 //
1463 // Note that it's ownable and the owner wields tremendous power. The ownership
1464 // will be transferred to a governance smart contract once SUSHI is sufficiently
1465 // distributed and the community can show to govern itself.
1466 //
1467 // Have fun reading it. Hopefully it's bug-free. God bless.
1468 contract PoliceChief is Ownable {
1469     using SafeMath for uint256;
1470     using SafeERC20 for IERC20;
1471 
1472     // Info of each user.
1473     struct UserInfo {
1474         uint256 amount;     // How many LP tokens the user has provided.
1475         uint256 rewardDebt; // Reward debt. See explanation below.
1476         //
1477         // We do some fancy math here. Basically, any point in time, the amount of SUSHIs
1478         // entitled to a user but is pending to be distributed is:
1479         //
1480         //   pending reward = (user.amount * pool.accSushiPerShare) - user.rewardDebt
1481         //
1482         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1483         //   1. The pool's `accSushiPerShare` (and `lastRewardBlock`) gets updated.
1484         //   2. User receives the pending reward sent to his/her address.
1485         //   3. User's `amount` gets updated.
1486         //   4. User's `rewardDebt` gets updated.
1487     }
1488 
1489     // Info of each pool.
1490     struct PoolInfo {
1491         IERC20 lpToken;           // Address of LP token contract.
1492         uint256 allocPoint;       // How many allocation points assigned to this pool. SUSHIs to distribute per block.
1493         uint256 lastRewardBlock;  // Last block number that SUSHIs distribution occurs.
1494         uint256 accSushiPerShare; // Accumulated SUSHIs per share, times 1e12. See below.
1495     }
1496 
1497     // NICE EDIT: Use NiceToken instead of SushiToken
1498     // The SUSHI TOKEN!
1499     NiceToken public sushi;
1500 
1501     // NICE EDIT: Set the dev fund to 0.69% (nice) instead of 10%
1502     // Dev address.
1503     address public devaddr;
1504 
1505     // Block number when bonus SUSHI period ends.
1506     uint256 public bonusEndBlock;
1507     // SUSHI tokens created per block.
1508     uint256 public sushiPerBlock;
1509     // Bonus muliplier for early sushi makers.
1510     uint256 public constant BONUS_MULTIPLIER = 10;
1511     // NICE EDIT: Remove migrator to protect LP tokens
1512     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1513     // IMigratorChef public migrator;
1514 
1515     // Info of each pool.
1516     PoolInfo[] public poolInfo;
1517     // Info of each user that stakes LP tokens.
1518     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1519     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1520     uint256 public totalAllocPoint = 0;
1521     // The block number when SUSHI mining starts.
1522     uint256 public startBlock;
1523 
1524     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1525     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1526     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1527 
1528     // NICE EDIT: Don't add same pool twice https://twitter.com/Quantstamp/status/1301280989906231296
1529     mapping (address => bool) private poolIsAdded;
1530 
1531     // NICE EDIT: If isInflating is true supply has not yet reached 420 and NICE is inflating
1532     bool public isInflating = true;
1533 
1534     // NICE EDIT: Divide mint by this number during deflation periods
1535     uint256 public deflationMintDivisor = 100;
1536 
1537     // NICE EDIT: Burn this amount per transaction during inflation/deflation periods
1538     // those are defaults and can be safely changed by governance with setDivisors
1539     uint256 public deflationBurnDivisor = 5; // 100 / 5 == 20%
1540     uint256 public inflationBurnDivisor = 100; // 100 / 100 == 1%
1541 
1542     // NICE EDIT: Allow governance to adjust mint and burn rates during 
1543     // defation periods in case it's too low / too high, not a dangerous function
1544     function setDivisors(uint256 _deflationMintDivisor, uint256 _deflationBurnDivisor, uint256 _inflationBurnDivisor) public onlyOwner {
1545         require(_deflationMintDivisor > 0, "setDivisors: deflationMintDivisor must be bigger than 0");
1546         deflationMintDivisor = _deflationMintDivisor;
1547         deflationBurnDivisor = _deflationBurnDivisor;
1548         inflationBurnDivisor = _inflationBurnDivisor;
1549 
1550         // always try setting both numbers to make sure 
1551         // they both don't revert
1552         if (isInflating) {
1553             sushi.setBurnDivisor(deflationBurnDivisor);
1554             sushi.setBurnDivisor(inflationBurnDivisor);
1555         }
1556         else {
1557             sushi.setBurnDivisor(inflationBurnDivisor);
1558             sushi.setBurnDivisor(deflationBurnDivisor);
1559         }
1560     }
1561 
1562     // NICE EDIT: Call this function every pool update, if total supply
1563     // is above 420, start deflation, if under 69, start inflation
1564     function updateIsInflating() public {
1565         // was inflating, should start deflating
1566         if (isInflating == true && sushi.totalSupply() > 420e18) {
1567             isInflating = false;
1568             sushi.setBurnDivisor(deflationBurnDivisor);
1569         }
1570         // was deflating, should start inflating
1571         else if (isInflating == false && sushi.totalSupply() < 69e18) {
1572             isInflating = true;
1573             sushi.setBurnDivisor(inflationBurnDivisor);
1574         }
1575     }
1576 
1577     // NICE EDIT: Read only util function for easier access from website, never called internally
1578     function niceBalancePendingHarvest(address _user) public view returns (uint256) {
1579         uint256 totalPendingNice = 0;
1580         uint256 poolCount = poolInfo.length;
1581         for (uint256 pid = 0; pid < poolCount; ++pid) {
1582             PoolInfo storage pool = poolInfo[pid];
1583             UserInfo storage user = userInfo[pid][_user];
1584             uint256 accSushiPerShare = pool.accSushiPerShare;
1585             uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1586             if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1587                 uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1588                 uint256 sushiReward = multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1589                 if (!isInflating) {
1590                     sushiReward = sushiReward.div(deflationMintDivisor);
1591                 }
1592                 accSushiPerShare = accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1593             }
1594             totalPendingNice = totalPendingNice.add(user.amount.mul(accSushiPerShare).div(1e12).sub(user.rewardDebt));
1595         }
1596         return totalPendingNice;
1597     }
1598 
1599     // NICE EDIT: Read only util function for easier access from website, never called internally
1600     function niceBalanceStaked(address _user) public view returns (uint256) {
1601         uint256 totalNiceStaked = 0;
1602         uint256 poolCount = poolInfo.length;
1603         for (uint256 pid = 0; pid < poolCount; ++pid) {
1604             UserInfo storage user = userInfo[pid][_user];
1605             if (user.amount == 0) {
1606                 continue;
1607             }
1608             PoolInfo storage pool = poolInfo[pid];
1609             uint256 uniswapPairNiceBalance = sushi.balanceOf(address(pool.lpToken));
1610             if (uniswapPairNiceBalance == 0) {
1611                 continue;
1612             }
1613             uint256 userPercentOfLpOwned = user.amount.mul(1e12).div(pool.lpToken.totalSupply());
1614             totalNiceStaked = totalNiceStaked.add(uniswapPairNiceBalance.mul(userPercentOfLpOwned).div(1e12));
1615         }
1616         return totalNiceStaked;
1617     }
1618 
1619     // NICE EDIT: Read only util function for easier access from website, never called internally
1620     function niceBalanceAll(address _user) external view returns (uint256) {
1621         return sushi.balanceOf(_user).add(niceBalanceStaked(_user)).add(niceBalancePendingHarvest(_user));
1622     }
1623 
1624     constructor(
1625         // NICE EDIT: Use NiceToken instead of SushiToken
1626         NiceToken _sushi,
1627         address _devaddr,
1628         uint256 _sushiPerBlock,
1629         uint256 _startBlock,
1630         uint256 _bonusEndBlock
1631     ) public {
1632         sushi = _sushi;
1633         devaddr = _devaddr;
1634         sushiPerBlock = _sushiPerBlock;
1635         bonusEndBlock = _bonusEndBlock;
1636         startBlock = _startBlock;
1637     }
1638 
1639     function poolLength() external view returns (uint256) {
1640         return poolInfo.length;
1641     }
1642 
1643     // Add a new lp to the pool. Can only be called by the owner.
1644     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1645     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1646         // NICE EDIT: Don't add same pool twice https://twitter.com/Quantstamp/status/1301280989906231296
1647         require(poolIsAdded[address(_lpToken)] == false, 'add: pool already added');
1648         poolIsAdded[address(_lpToken)] = true;
1649 
1650         if (_withUpdate) {
1651             massUpdatePools();
1652         }
1653         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1654         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1655         poolInfo.push(PoolInfo({
1656             lpToken: _lpToken,
1657             allocPoint: _allocPoint,
1658             lastRewardBlock: lastRewardBlock,
1659             accSushiPerShare: 0
1660         }));
1661     }
1662 
1663     // Update the given pool's SUSHI allocation point. Can only be called by the owner.
1664     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1665         if (_withUpdate) {
1666             massUpdatePools();
1667         }
1668         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1669         poolInfo[_pid].allocPoint = _allocPoint;
1670     }
1671 
1672     // NICE EDIT: Remove migrator to protect LP tokens
1673     // Set the migrator contract. Can only be called by the owner.
1674     // function setMigrator(IMigratorChef _migrator) public onlyOwner {
1675     //     migrator = _migrator;
1676     // }
1677 
1678     // NICE EDIT: Remove migrator to protect LP tokens
1679     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1680     // function migrate(uint256 _pid) public {
1681     //     require(address(migrator) != address(0), "migrate: no migrator");
1682     //     PoolInfo storage pool = poolInfo[_pid];
1683     //     IERC20 lpToken = pool.lpToken;
1684     //     uint256 bal = lpToken.balanceOf(address(this));
1685     //     lpToken.safeApprove(address(migrator), bal);
1686     //     IERC20 newLpToken = migrator.migrate(lpToken);
1687     //     require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1688     //     pool.lpToken = newLpToken;
1689     // }
1690 
1691     // Return reward multiplier over the given _from to _to block.
1692     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1693         if (_to <= bonusEndBlock) {
1694             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1695         } else if (_from >= bonusEndBlock) {
1696             return _to.sub(_from);
1697         } else {
1698             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1699                 _to.sub(bonusEndBlock)
1700             );
1701         }
1702     }
1703 
1704     // View function to see pending SUSHIs on frontend.
1705     function pendingSushi(uint256 _pid, address _user) external view returns (uint256) {
1706         PoolInfo storage pool = poolInfo[_pid];
1707         UserInfo storage user = userInfo[_pid][_user];
1708         uint256 accSushiPerShare = pool.accSushiPerShare;
1709         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1710         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1711             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1712             uint256 sushiReward = multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1713 
1714             // NICE EDIT: During deflation periods, cut the reward by the deflationMintDivisor amount
1715             if (!isInflating) {
1716                 sushiReward = sushiReward.div(deflationMintDivisor);
1717             }
1718 
1719             accSushiPerShare = accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1720         }
1721         return user.amount.mul(accSushiPerShare).div(1e12).sub(user.rewardDebt);
1722     }
1723 
1724     // Update reward vairables for all pools. Be careful of gas spending!
1725     function massUpdatePools() public {
1726         uint256 length = poolInfo.length;
1727         for (uint256 pid = 0; pid < length; ++pid) {
1728             updatePool(pid);
1729         }
1730     }
1731 
1732     // Update reward variables of the given pool to be up-to-date.
1733     function updatePool(uint256 _pid) public {
1734         // NICE EDIT: If total supply is above 420, start deflation, if under 69, start inflation
1735         updateIsInflating();
1736 
1737         PoolInfo storage pool = poolInfo[_pid];
1738         if (block.number <= pool.lastRewardBlock) {
1739             return;
1740         }
1741 
1742         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1743         if (lpSupply == 0) {
1744             pool.lastRewardBlock = block.number;
1745             return;
1746         }
1747         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1748         uint256 sushiReward = multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1749 
1750         // NICE EDIT: During deflation periods, cut the reward by the deflationMintDivisor amount
1751         if (!isInflating) {
1752             sushiReward = sushiReward.div(deflationMintDivisor);
1753         }
1754 
1755         // NICE EDIT: Set the dev fund to 0.69% (nice)
1756         sushi.mint(devaddr, sushiReward.div(144)); // 100 / 144 == 0.694444444
1757         // sushi.mint(devaddr, sushiReward.div(10));
1758 
1759         sushi.mint(address(this), sushiReward);
1760         pool.accSushiPerShare = pool.accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1761         pool.lastRewardBlock = block.number;
1762     }
1763 
1764     // Deposit LP tokens to PoliceChief for SUSHI allocation.
1765     function deposit(uint256 _pid, uint256 _amount) public {
1766         PoolInfo storage pool = poolInfo[_pid];
1767         UserInfo storage user = userInfo[_pid][msg.sender];
1768         updatePool(_pid);
1769         if (user.amount > 0) {
1770             uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
1771             safeSushiTransfer(msg.sender, pending);
1772         }
1773         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1774         user.amount = user.amount.add(_amount);
1775         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1776         emit Deposit(msg.sender, _pid, _amount);
1777     }
1778 
1779     // Withdraw LP tokens from PoliceChief.
1780     function withdraw(uint256 _pid, uint256 _amount) public {
1781         PoolInfo storage pool = poolInfo[_pid];
1782         UserInfo storage user = userInfo[_pid][msg.sender];
1783         require(user.amount >= _amount, "withdraw: not good");
1784         updatePool(_pid);
1785         uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
1786         safeSushiTransfer(msg.sender, pending);
1787         user.amount = user.amount.sub(_amount);
1788         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1789         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1790         emit Withdraw(msg.sender, _pid, _amount);
1791     }
1792 
1793     // Withdraw without caring about rewards. EMERGENCY ONLY.
1794     function emergencyWithdraw(uint256 _pid) public {
1795         PoolInfo storage pool = poolInfo[_pid];
1796         UserInfo storage user = userInfo[_pid][msg.sender];
1797         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1798         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1799         user.amount = 0;
1800         user.rewardDebt = 0;
1801     }
1802 
1803     // Safe sushi transfer function, just in case if rounding error causes pool to not have enough SUSHIs.
1804     function safeSushiTransfer(address _to, uint256 _amount) internal {
1805         uint256 sushiBal = sushi.balanceOf(address(this));
1806         if (_amount > sushiBal) {
1807             sushi.transfer(_to, sushiBal);
1808         } else {
1809             sushi.transfer(_to, _amount);
1810         }
1811     }
1812 
1813     function dev(address _devaddr) public {
1814         // NICE EDIT: Minting to 0 address reverts and breaks harvesting
1815         require(_devaddr != address(0), "dev: don't set to 0 address");
1816         require(msg.sender == devaddr, "dev: wut?");
1817         devaddr = _devaddr;
1818     }
1819 }