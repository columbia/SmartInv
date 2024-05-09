1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity 0.6.12;
4 
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
259         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
260         // for accounts without code, i.e. `keccak256('')`
261         bytes32 codehash;
262         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
263         // solhint-disable-next-line no-inline-assembly
264         assembly { codehash := extcodehash(account) }
265         return (codehash != accountHash && codehash != 0x0);
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
288         (bool success, ) = recipient.call{ value: amount }("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain`call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311       return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
321         return _functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but also transferring `value` wei to `target`.
327      *
328      * Requirements:
329      *
330      * - the calling contract must have an ETH balance of at least `value`.
331      * - the called Solidity function must be `payable`.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
341      * with `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         return _functionCallWithValue(target, data, value, errorMessage);
348     }
349 
350     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
351         require(isContract(target), "Address: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
355         if (success) {
356             return returndata;
357         } else {
358             // Look for revert reason and bubble it up if present
359             if (returndata.length > 0) {
360                 // The easiest way to bubble the revert reason is using memory via assembly
361 
362                 // solhint-disable-next-line no-inline-assembly
363                 assembly {
364                     let returndata_size := mload(returndata)
365                     revert(add(32, returndata), returndata_size)
366                 }
367             } else {
368                 revert(errorMessage);
369             }
370         }
371     }
372 }
373 
374 /**
375  * @title SafeERC20
376  * @dev Wrappers around ERC20 operations that throw on failure (when the token
377  * contract returns false). Tokens that return no value (and instead revert or
378  * throw on failure) are also supported, non-reverting calls are assumed to be
379  * successful.
380  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
381  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
382  */
383 library SafeERC20 {
384     using SafeMath for uint256;
385     using Address for address;
386 
387     function safeTransfer(IERC20 token, address to, uint256 value) internal {
388         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
389     }
390 
391     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
392         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
393     }
394 
395     /**
396      * @dev Deprecated. This function has issues similar to the ones found in
397      * {IERC20-approve}, and its usage is discouraged.
398      *
399      * Whenever possible, use {safeIncreaseAllowance} and
400      * {safeDecreaseAllowance} instead.
401      */
402     function safeApprove(IERC20 token, address spender, uint256 value) internal {
403         // safeApprove should only be called when setting an initial allowance,
404         // or when resetting it to zero. To increase and decrease it, use
405         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
406         // solhint-disable-next-line max-line-length
407         require((value == 0) || (token.allowance(address(this), spender) == 0),
408             "SafeERC20: approve from non-zero to non-zero allowance"
409         );
410         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
411     }
412 
413     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
414         uint256 newAllowance = token.allowance(address(this), spender).add(value);
415         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
416     }
417 
418     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
419         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
420         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
421     }
422 
423     /**
424      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
425      * on the return value: the return value is optional (but if data is returned, it must not be false).
426      * @param token The token targeted by the call.
427      * @param data The call data (encoded using abi.encode or one of its variants).
428      */
429     function _callOptionalReturn(IERC20 token, bytes memory data) private {
430         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
431         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
432         // the target address contains contract code and also asserts for success in the low-level call.
433 
434         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
435         if (returndata.length > 0) { // Return data is optional
436             // solhint-disable-next-line max-line-length
437             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
438         }
439     }
440 }
441 
442 /**
443  * @dev Library for managing
444  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
445  * types.
446  *
447  * Sets have the following properties:
448  *
449  * - Elements are added, removed, and checked for existence in constant time
450  * (O(1)).
451  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
452  *
453  * ```
454  * contract Example {
455  *     // Add the library methods
456  *     using EnumerableSet for EnumerableSet.AddressSet;
457  *
458  *     // Declare a set state variable
459  *     EnumerableSet.AddressSet private mySet;
460  * }
461  * ```
462  *
463  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
464  * (`UintSet`) are supported.
465  */
466 library EnumerableSet {
467     // To implement this library for multiple types with as little code
468     // repetition as possible, we write it in terms of a generic Set type with
469     // bytes32 values.
470     // The Set implementation uses private functions, and user-facing
471     // implementations (such as AddressSet) are just wrappers around the
472     // underlying Set.
473     // This means that we can only create new EnumerableSets for types that fit
474     // in bytes32.
475 
476     struct Set {
477         // Storage of set values
478         bytes32[] _values;
479 
480         // Position of the value in the `values` array, plus 1 because index 0
481         // means a value is not in the set.
482         mapping (bytes32 => uint256) _indexes;
483     }
484 
485     /**
486      * @dev Add a value to a set. O(1).
487      *
488      * Returns true if the value was added to the set, that is if it was not
489      * already present.
490      */
491     function _add(Set storage set, bytes32 value) private returns (bool) {
492         if (!_contains(set, value)) {
493             set._values.push(value);
494             // The value is stored at length-1, but we add 1 to all indexes
495             // and use 0 as a sentinel value
496             set._indexes[value] = set._values.length;
497             return true;
498         } else {
499             return false;
500         }
501     }
502 
503     /**
504      * @dev Removes a value from a set. O(1).
505      *
506      * Returns true if the value was removed from the set, that is if it was
507      * present.
508      */
509     function _remove(Set storage set, bytes32 value) private returns (bool) {
510         // We read and store the value's index to prevent multiple reads from the same storage slot
511         uint256 valueIndex = set._indexes[value];
512 
513         if (valueIndex != 0) { // Equivalent to contains(set, value)
514             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
515             // the array, and then remove the last element (sometimes called as 'swap and pop').
516             // This modifies the order of the array, as noted in {at}.
517 
518             uint256 toDeleteIndex = valueIndex - 1;
519             uint256 lastIndex = set._values.length - 1;
520 
521             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
522             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
523 
524             bytes32 lastvalue = set._values[lastIndex];
525 
526             // Move the last value to the index where the value to delete is
527             set._values[toDeleteIndex] = lastvalue;
528             // Update the index for the moved value
529             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
530 
531             // Delete the slot where the moved value was stored
532             set._values.pop();
533 
534             // Delete the index for the deleted slot
535             delete set._indexes[value];
536 
537             return true;
538         } else {
539             return false;
540         }
541     }
542 
543     /**
544      * @dev Returns true if the value is in the set. O(1).
545      */
546     function _contains(Set storage set, bytes32 value) private view returns (bool) {
547         return set._indexes[value] != 0;
548     }
549 
550     /**
551      * @dev Returns the number of values on the set. O(1).
552      */
553     function _length(Set storage set) private view returns (uint256) {
554         return set._values.length;
555     }
556 
557    /**
558     * @dev Returns the value stored at position `index` in the set. O(1).
559     *
560     * Note that there are no guarantees on the ordering of values inside the
561     * array, and it may change when more values are added or removed.
562     *
563     * Requirements:
564     *
565     * - `index` must be strictly less than {length}.
566     */
567     function _at(Set storage set, uint256 index) private view returns (bytes32) {
568         require(set._values.length > index, "EnumerableSet: index out of bounds");
569         return set._values[index];
570     }
571 
572     // AddressSet
573 
574     struct AddressSet {
575         Set _inner;
576     }
577 
578     /**
579      * @dev Add a value to a set. O(1).
580      *
581      * Returns true if the value was added to the set, that is if it was not
582      * already present.
583      */
584     function add(AddressSet storage set, address value) internal returns (bool) {
585         return _add(set._inner, bytes32(uint256(value)));
586     }
587 
588     /**
589      * @dev Removes a value from a set. O(1).
590      *
591      * Returns true if the value was removed from the set, that is if it was
592      * present.
593      */
594     function remove(AddressSet storage set, address value) internal returns (bool) {
595         return _remove(set._inner, bytes32(uint256(value)));
596     }
597 
598     /**
599      * @dev Returns true if the value is in the set. O(1).
600      */
601     function contains(AddressSet storage set, address value) internal view returns (bool) {
602         return _contains(set._inner, bytes32(uint256(value)));
603     }
604 
605     /**
606      * @dev Returns the number of values in the set. O(1).
607      */
608     function length(AddressSet storage set) internal view returns (uint256) {
609         return _length(set._inner);
610     }
611 
612    /**
613     * @dev Returns the value stored at position `index` in the set. O(1).
614     *
615     * Note that there are no guarantees on the ordering of values inside the
616     * array, and it may change when more values are added or removed.
617     *
618     * Requirements:
619     *
620     * - `index` must be strictly less than {length}.
621     */
622     function at(AddressSet storage set, uint256 index) internal view returns (address) {
623         return address(uint256(_at(set._inner, index)));
624     }
625 
626 
627     // UintSet
628 
629     struct UintSet {
630         Set _inner;
631     }
632 
633     /**
634      * @dev Add a value to a set. O(1).
635      *
636      * Returns true if the value was added to the set, that is if it was not
637      * already present.
638      */
639     function add(UintSet storage set, uint256 value) internal returns (bool) {
640         return _add(set._inner, bytes32(value));
641     }
642 
643     /**
644      * @dev Removes a value from a set. O(1).
645      *
646      * Returns true if the value was removed from the set, that is if it was
647      * present.
648      */
649     function remove(UintSet storage set, uint256 value) internal returns (bool) {
650         return _remove(set._inner, bytes32(value));
651     }
652 
653     /**
654      * @dev Returns true if the value is in the set. O(1).
655      */
656     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
657         return _contains(set._inner, bytes32(value));
658     }
659 
660     /**
661      * @dev Returns the number of values on the set. O(1).
662      */
663     function length(UintSet storage set) internal view returns (uint256) {
664         return _length(set._inner);
665     }
666 
667    /**
668     * @dev Returns the value stored at position `index` in the set. O(1).
669     *
670     * Note that there are no guarantees on the ordering of values inside the
671     * array, and it may change when more values are added or removed.
672     *
673     * Requirements:
674     *
675     * - `index` must be strictly less than {length}.
676     */
677     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
678         return uint256(_at(set._inner, index));
679     }
680 }
681 
682 /*
683  * @dev Provides information about the current execution context, including the
684  * sender of the transaction and its data. While these are generally available
685  * via msg.sender and msg.data, they should not be accessed in such a direct
686  * manner, since when dealing with GSN meta-transactions the account sending and
687  * paying for execution may not be the actual sender (as far as an application
688  * is concerned).
689  *
690  * This contract is only required for intermediate, library-like contracts.
691  */
692 abstract contract Context {
693     function _msgSender() internal view virtual returns (address payable) {
694         return msg.sender;
695     }
696 
697     function _msgData() internal view virtual returns (bytes memory) {
698         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
699         return msg.data;
700     }
701 }
702 
703 /**
704  * @dev Contract module which provides a basic access control mechanism, where
705  * there is an account (an owner) that can be granted exclusive access to
706  * specific functions.
707  *
708  * By default, the owner account will be the one that deploys the contract. This
709  * can later be changed with {transferOwnership}.
710  *
711  * This module is used through inheritance. It will make available the modifier
712  * `onlyOwner`, which can be applied to your functions to restrict their use to
713  * the owner.
714  */
715 contract Ownable is Context {
716     address private _owner;
717 
718     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
719 
720     /**
721      * @dev Initializes the contract setting the deployer as the initial owner.
722      */
723     constructor () internal {
724         address msgSender = _msgSender();
725         _owner = msgSender;
726         emit OwnershipTransferred(address(0), msgSender);
727     }
728 
729     /**
730      * @dev Returns the address of the current owner.
731      */
732     function owner() public view returns (address) {
733         return _owner;
734     }
735 
736     /**
737      * @dev Throws if called by any account other than the owner.
738      */
739     modifier onlyOwner() {
740         require(_owner == _msgSender(), "Ownable: caller is not the owner");
741         _;
742     }
743 
744     /**
745      * @dev Leaves the contract without owner. It will not be possible to call
746      * `onlyOwner` functions anymore. Can only be called by the current owner.
747      *
748      * NOTE: Renouncing ownership will leave the contract without an owner,
749      * thereby removing any functionality that is only available to the owner.
750      */
751     function renounceOwnership() public virtual onlyOwner {
752         emit OwnershipTransferred(_owner, address(0));
753         _owner = address(0);
754     }
755 
756     /**
757      * @dev Transfers ownership of the contract to a new account (`newOwner`).
758      * Can only be called by the current owner.
759      */
760     function transferOwnership(address newOwner) public virtual onlyOwner {
761         require(newOwner != address(0), "Ownable: new owner is the zero address");
762         emit OwnershipTransferred(_owner, newOwner);
763         _owner = newOwner;
764     }
765 }
766 
767 /**
768  * @dev Implementation of the {IERC20} interface.
769  *
770  * This implementation is agnostic to the way tokens are created. This means
771  * that a supply mechanism has to be added in a derived contract using {_mint}.
772  * For a generic mechanism see {ERC20PresetMinterPauser}.
773  *
774  * TIP: For a detailed writeup see our guide
775  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
776  * to implement supply mechanisms].
777  *
778  * We have followed general OpenZeppelin guidelines: functions revert instead
779  * of returning `false` on failure. This behavior is nonetheless conventional
780  * and does not conflict with the expectations of ERC20 applications.
781  *
782  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
783  * This allows applications to reconstruct the allowance for all accounts just
784  * by listening to said events. Other implementations of the EIP may not emit
785  * these events, as it isn't required by the specification.
786  *
787  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
788  * functions have been added to mitigate the well-known issues around setting
789  * allowances. See {IERC20-approve}.
790  */
791 contract ERC20 is Context, IERC20 {
792     using SafeMath for uint256;
793     using Address for address;
794 
795     mapping (address => uint256) private _balances;
796 
797     mapping (address => mapping (address => uint256)) private _allowances;
798 
799     uint256 private _totalSupply;
800 
801     string private _name;
802     string private _symbol;
803     uint8 private _decimals;
804 
805     /**
806      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
807      * a default value of 18.
808      *
809      * To select a different value for {decimals}, use {_setupDecimals}.
810      *
811      * All three of these values are immutable: they can only be set once during
812      * construction.
813      */
814     constructor (string memory name, string memory symbol) public {
815         _name = name;
816         _symbol = symbol;
817         _decimals = 18;
818     }
819 
820     /**
821      * @dev Returns the name of the token.
822      */
823     function name() public view returns (string memory) {
824         return _name;
825     }
826 
827     /**
828      * @dev Returns the symbol of the token, usually a shorter version of the
829      * name.
830      */
831     function symbol() public view returns (string memory) {
832         return _symbol;
833     }
834 
835     /**
836      * @dev Returns the number of decimals used to get its user representation.
837      * For example, if `decimals` equals `2`, a balance of `505` tokens should
838      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
839      *
840      * Tokens usually opt for a value of 18, imitating the relationship between
841      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
842      * called.
843      *
844      * NOTE: This information is only used for _display_ purposes: it in
845      * no way affects any of the arithmetic of the contract, including
846      * {IERC20-balanceOf} and {IERC20-transfer}.
847      */
848     function decimals() public view returns (uint8) {
849         return _decimals;
850     }
851 
852     /**
853      * @dev See {IERC20-totalSupply}.
854      */
855     function totalSupply() public view override returns (uint256) {
856         return _totalSupply;
857     }
858 
859     /**
860      * @dev See {IERC20-balanceOf}.
861      */
862     function balanceOf(address account) public view override returns (uint256) {
863         return _balances[account];
864     }
865 
866     /**
867      * @dev See {IERC20-transfer}.
868      *
869      * Requirements:
870      *
871      * - `recipient` cannot be the zero address.
872      * - the caller must have a balance of at least `amount`.
873      */
874     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
875         _transfer(_msgSender(), recipient, amount);
876         return true;
877     }
878 
879     /**
880      * @dev See {IERC20-allowance}.
881      */
882     function allowance(address owner, address spender) public view virtual override returns (uint256) {
883         return _allowances[owner][spender];
884     }
885 
886     /**
887      * @dev See {IERC20-approve}.
888      *
889      * Requirements:
890      *
891      * - `spender` cannot be the zero address.
892      */
893     function approve(address spender, uint256 amount) public virtual override returns (bool) {
894         _approve(_msgSender(), spender, amount);
895         return true;
896     }
897 
898     /**
899      * @dev See {IERC20-transferFrom}.
900      *
901      * Emits an {Approval} event indicating the updated allowance. This is not
902      * required by the EIP. See the note at the beginning of {ERC20};
903      *
904      * Requirements:
905      * - `sender` and `recipient` cannot be the zero address.
906      * - `sender` must have a balance of at least `amount`.
907      * - the caller must have allowance for ``sender``'s tokens of at least
908      * `amount`.
909      */
910     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
911         _transfer(sender, recipient, amount);
912         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
913         return true;
914     }
915 
916     /**
917      * @dev Atomically increases the allowance granted to `spender` by the caller.
918      *
919      * This is an alternative to {approve} that can be used as a mitigation for
920      * problems described in {IERC20-approve}.
921      *
922      * Emits an {Approval} event indicating the updated allowance.
923      *
924      * Requirements:
925      *
926      * - `spender` cannot be the zero address.
927      */
928     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
929         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
930         return true;
931     }
932 
933     /**
934      * @dev Atomically decreases the allowance granted to `spender` by the caller.
935      *
936      * This is an alternative to {approve} that can be used as a mitigation for
937      * problems described in {IERC20-approve}.
938      *
939      * Emits an {Approval} event indicating the updated allowance.
940      *
941      * Requirements:
942      *
943      * - `spender` cannot be the zero address.
944      * - `spender` must have allowance for the caller of at least
945      * `subtractedValue`.
946      */
947     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
948         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
949         return true;
950     }
951 
952     /**
953      * @dev Moves tokens `amount` from `sender` to `recipient`.
954      *
955      * This is internal function is equivalent to {transfer}, and can be used to
956      * e.g. implement automatic token fees, slashing mechanisms, etc.
957      *
958      * Emits a {Transfer} event.
959      *
960      * Requirements:
961      *
962      * - `sender` cannot be the zero address.
963      * - `recipient` cannot be the zero address.
964      * - `sender` must have a balance of at least `amount`.
965      */
966     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
967         require(sender != address(0), "ERC20: transfer from the zero address");
968         require(recipient != address(0), "ERC20: transfer to the zero address");
969 
970         _beforeTokenTransfer(sender, recipient, amount);
971 
972         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
973         _balances[recipient] = _balances[recipient].add(amount);
974         emit Transfer(sender, recipient, amount);
975     }
976 
977     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
978      * the total supply.
979      *
980      * Emits a {Transfer} event with `from` set to the zero address.
981      *
982      * Requirements
983      *
984      * - `to` cannot be the zero address.
985      */
986     function _mint(address account, uint256 amount) internal virtual {
987         require(account != address(0), "ERC20: mint to the zero address");
988 
989         _beforeTokenTransfer(address(0), account, amount);
990 
991         _totalSupply = _totalSupply.add(amount);
992         _balances[account] = _balances[account].add(amount);
993         emit Transfer(address(0), account, amount);
994     }
995 
996     /**
997      * @dev Destroys `amount` tokens from `account`, reducing the
998      * total supply.
999      *
1000      * Emits a {Transfer} event with `to` set to the zero address.
1001      *
1002      * Requirements
1003      *
1004      * - `account` cannot be the zero address.
1005      * - `account` must have at least `amount` tokens.
1006      */
1007     function _burn(address account, uint256 amount) internal virtual {
1008         require(account != address(0), "ERC20: burn from the zero address");
1009 
1010         _beforeTokenTransfer(account, address(0), amount);
1011 
1012         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1013         _totalSupply = _totalSupply.sub(amount);
1014         emit Transfer(account, address(0), amount);
1015     }
1016 
1017     /**
1018      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1019      *
1020      * This is internal function is equivalent to `approve`, and can be used to
1021      * e.g. set automatic allowances for certain subsystems, etc.
1022      *
1023      * Emits an {Approval} event.
1024      *
1025      * Requirements:
1026      *
1027      * - `owner` cannot be the zero address.
1028      * - `spender` cannot be the zero address.
1029      */
1030     function _approve(address owner, address spender, uint256 amount) internal virtual {
1031         require(owner != address(0), "ERC20: approve from the zero address");
1032         require(spender != address(0), "ERC20: approve to the zero address");
1033 
1034         _allowances[owner][spender] = amount;
1035         emit Approval(owner, spender, amount);
1036     }
1037 
1038     /**
1039      * @dev Sets {decimals} to a value other than the default one of 18.
1040      *
1041      * WARNING: This function should only be called from the constructor. Most
1042      * applications that interact with token contracts will not expect
1043      * {decimals} to ever change, and may work incorrectly if it does.
1044      */
1045     function _setupDecimals(uint8 decimals_) internal {
1046         _decimals = decimals_;
1047     }
1048 
1049     /**
1050      * @dev Hook that is called before any transfer of tokens. This includes
1051      * minting and burning.
1052      *
1053      * Calling conditions:
1054      *
1055      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1056      * will be to transferred to `to`.
1057      * - when `from` is zero, `amount` tokens will be minted for `to`.
1058      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1059      * - `from` and `to` are never both zero.
1060      *
1061      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1062      */
1063     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1064 }
1065 
1066 // BeerToken with Governance.
1067 contract BeerToken is ERC20("BeerToken", "BEER"), Ownable {
1068     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1069     function mint(address _to, uint256 _amount) public onlyOwner {
1070         _mint(_to, _amount);
1071         _moveDelegates(address(0), _delegates[_to], _amount);
1072     }
1073 
1074     // Copied and modified from YAM code:
1075     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1076     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1077     // Which is copied and modified from COMPOUND:
1078     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1079 
1080     /// @notice A record of each accounts delegate
1081     mapping (address => address) internal _delegates;
1082 
1083     /// @notice A checkpoint for marking number of votes from a given block
1084     struct Checkpoint {
1085         uint32 fromBlock;
1086         uint256 votes;
1087     }
1088 
1089     /// @notice A record of votes checkpoints for each account, by index
1090     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1091 
1092     /// @notice The number of checkpoints for each account
1093     mapping (address => uint32) public numCheckpoints;
1094 
1095     /// @notice The EIP-712 typehash for the contract's domain
1096     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1097 
1098     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1099     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1100 
1101     /// @notice A record of states for signing / validating signatures
1102     mapping (address => uint) public nonces;
1103 
1104       /// @notice An event thats emitted when an account changes its delegate
1105     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1106 
1107     /// @notice An event thats emitted when a delegate account's vote balance changes
1108     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1109 
1110     /**
1111      * @notice Delegate votes from `msg.sender` to `delegatee`
1112      * @param delegator The address to get delegatee for
1113      */
1114     function delegates(address delegator)
1115         external
1116         view
1117         returns (address)
1118     {
1119         return _delegates[delegator];
1120     }
1121 
1122    /**
1123     * @notice Delegate votes from `msg.sender` to `delegatee`
1124     * @param delegatee The address to delegate votes to
1125     */
1126     function delegate(address delegatee) external {
1127         return _delegate(msg.sender, delegatee);
1128     }
1129 
1130     /**
1131      * @notice Delegates votes from signatory to `delegatee`
1132      * @param delegatee The address to delegate votes to
1133      * @param nonce The contract state required to match the signature
1134      * @param expiry The time at which to expire the signature
1135      * @param v The recovery byte of the signature
1136      * @param r Half of the ECDSA signature pair
1137      * @param s Half of the ECDSA signature pair
1138      */
1139     function delegateBySig(
1140         address delegatee,
1141         uint nonce,
1142         uint expiry,
1143         uint8 v,
1144         bytes32 r,
1145         bytes32 s
1146     )
1147         external
1148     {
1149         bytes32 domainSeparator = keccak256(
1150             abi.encode(
1151                 DOMAIN_TYPEHASH,
1152                 keccak256(bytes(name())),
1153                 getChainId(),
1154                 address(this)
1155             )
1156         );
1157 
1158         bytes32 structHash = keccak256(
1159             abi.encode(
1160                 DELEGATION_TYPEHASH,
1161                 delegatee,
1162                 nonce,
1163                 expiry
1164             )
1165         );
1166 
1167         bytes32 digest = keccak256(
1168             abi.encodePacked(
1169                 "\x19\x01",
1170                 domainSeparator,
1171                 structHash
1172             )
1173         );
1174 
1175         address signatory = ecrecover(digest, v, r, s);
1176         require(signatory != address(0), "BEER::delegateBySig: invalid signature");
1177         require(nonce == nonces[signatory]++, "BEER::delegateBySig: invalid nonce");
1178         require(now <= expiry, "BEER::delegateBySig: signature expired");
1179         return _delegate(signatory, delegatee);
1180     }
1181 
1182     /**
1183      * @notice Gets the current votes balance for `account`
1184      * @param account The address to get votes balance
1185      * @return The number of current votes for `account`
1186      */
1187     function getCurrentVotes(address account)
1188         external
1189         view
1190         returns (uint256)
1191     {
1192         uint32 nCheckpoints = numCheckpoints[account];
1193         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1194     }
1195 
1196     /**
1197      * @notice Determine the prior number of votes for an account as of a block number
1198      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1199      * @param account The address of the account to check
1200      * @param blockNumber The block number to get the vote balance at
1201      * @return The number of votes the account had as of the given block
1202      */
1203     function getPriorVotes(address account, uint blockNumber)
1204         external
1205         view
1206         returns (uint256)
1207     {
1208         require(blockNumber < block.number, "BEER::getPriorVotes: not yet determined");
1209 
1210         uint32 nCheckpoints = numCheckpoints[account];
1211         if (nCheckpoints == 0) {
1212             return 0;
1213         }
1214 
1215         // First check most recent balance
1216         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1217             return checkpoints[account][nCheckpoints - 1].votes;
1218         }
1219 
1220         // Next check implicit zero balance
1221         if (checkpoints[account][0].fromBlock > blockNumber) {
1222             return 0;
1223         }
1224 
1225         uint32 lower = 0;
1226         uint32 upper = nCheckpoints - 1;
1227         while (upper > lower) {
1228             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1229             Checkpoint memory cp = checkpoints[account][center];
1230             if (cp.fromBlock == blockNumber) {
1231                 return cp.votes;
1232             } else if (cp.fromBlock < blockNumber) {
1233                 lower = center;
1234             } else {
1235                 upper = center - 1;
1236             }
1237         }
1238         return checkpoints[account][lower].votes;
1239     }
1240 
1241     function _delegate(address delegator, address delegatee)
1242         internal
1243     {
1244         address currentDelegate = _delegates[delegator];
1245         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BEERs (not scaled);
1246         _delegates[delegator] = delegatee;
1247 
1248         emit DelegateChanged(delegator, currentDelegate, delegatee);
1249 
1250         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1251     }
1252 
1253     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1254         if (srcRep != dstRep && amount > 0) {
1255             if (srcRep != address(0)) {
1256                 // decrease old representative
1257                 uint32 srcRepNum = numCheckpoints[srcRep];
1258                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1259                 uint256 srcRepNew = srcRepOld.sub(amount);
1260                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1261             }
1262 
1263             if (dstRep != address(0)) {
1264                 // increase new representative
1265                 uint32 dstRepNum = numCheckpoints[dstRep];
1266                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1267                 uint256 dstRepNew = dstRepOld.add(amount);
1268                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1269             }
1270         }
1271     }
1272 
1273     function _writeCheckpoint(
1274         address delegatee,
1275         uint32 nCheckpoints,
1276         uint256 oldVotes,
1277         uint256 newVotes
1278     )
1279         internal
1280     {
1281         uint32 blockNumber = safe32(block.number, "BEER::_writeCheckpoint: block number exceeds 32 bits");
1282 
1283         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1284             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1285         } else {
1286             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1287             numCheckpoints[delegatee] = nCheckpoints + 1;
1288         }
1289 
1290         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1291     }
1292 
1293     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1294         require(n < 2**32, errorMessage);
1295         return uint32(n);
1296     }
1297 
1298     function getChainId() internal pure returns (uint) {
1299         uint256 chainId;
1300         assembly { chainId := chainid() }
1301         return chainId;
1302     }
1303 }
1304 
1305 
1306 interface IMigratorChef {
1307     // Perform LP token migration from legacy UniswapV2 to BeerSwap.
1308     // Take the current LP token address and return the new LP token address.
1309     // Migrator should have full access to the caller's LP token.
1310     // Return the new LP token address.
1311     //
1312     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1313     // BeerSwap must mint EXACTLY the same amount of BeerSwap LP tokens or
1314     // else something bad will happen. Traditional UniswapV2 does not
1315     // do that so be careful!
1316     function migrate(IERC20 token) external returns (IERC20);
1317 }
1318 
1319 // MasterChef is the master of Beer. He can make Beer and he is a fair guy.
1320 //
1321 // Note that it's ownable and the owner wields tremendous power. The ownership
1322 // will be transferred to a governance smart contract once BEER is sufficiently
1323 // distributed and the community can show to govern itself.
1324 //
1325 // Have fun reading it. Hopefully it's bug-free. God bless.
1326 
1327 contract MasterChef is Ownable {
1328     using SafeMath for uint256;
1329     using SafeERC20 for IERC20;
1330 
1331     // Info of each user.
1332     struct UserInfo {
1333         uint256 amount;     // How many LP tokens the user has provided.
1334         uint256 rewardDebt; // Reward debt. See explanation below.
1335         //
1336         // We do some fancy math here. Basically, any point in time, the amount of BEERs
1337         // entitled to a user but is pending to be distributed is:
1338         //
1339         //   pending reward = (user.amount * pool.accBeerPerShare) - user.rewardDebt
1340         //
1341         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1342         //   1. The pool's `accBeerPerShare` (and `lastRewardBlock`) gets updated.
1343         //   2. User receives the pending reward sent to his/her address.
1344         //   3. User's `amount` gets updated.
1345         //   4. User's `rewardDebt` gets updated.
1346     }
1347 
1348     // Info of each pool.
1349     struct PoolInfo {
1350         IERC20 lpToken;           // Address of LP token contract.
1351         uint256 allocPoint;       // How many allocation points assigned to this pool. BEERs to distribute per block.
1352         uint256 lastRewardBlock;  // Last block number that BEERs distribution occurs.
1353         uint256 accBeerPerShare; // Accumulated BEERs per share, times 1e12. See below.
1354     }
1355 
1356     // The BEER TOKEN!
1357     BeerToken public beer;
1358     // Dev address.
1359     address public devaddr;
1360     // Block number when bonus BEER period ends.
1361     uint256 public bonusEndBlock;
1362     // BEER tokens created per block.
1363     uint256 public beerPerBlock;
1364     // Bonus muliplier for early beer makers.
1365     uint256 public constant BONUS_MULTIPLIER = 10;
1366     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1367     IMigratorChef public migrator;
1368 
1369     // Info of each pool.
1370     PoolInfo[] public poolInfo;
1371     // Info of each user that stakes LP tokens.
1372     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1373     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1374     uint256 public totalAllocPoint = 0;
1375     // The block number when BEER mining starts.
1376     uint256 public startBlock;
1377 
1378     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1379     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1380     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1381 
1382     constructor(
1383         BeerToken _beer,
1384         address _devaddr,
1385         uint256 _beerPerBlock,
1386         uint256 _startBlock,
1387         uint256 _bonusEndBlock
1388     ) public {
1389         beer = _beer;
1390         devaddr = _devaddr;
1391         beerPerBlock = _beerPerBlock;
1392         bonusEndBlock = _bonusEndBlock;
1393         startBlock = _startBlock;
1394     }
1395 
1396     function poolLength() external view returns (uint256) {
1397         return poolInfo.length;
1398     }
1399 
1400     // Add a new lp to the pool. Can only be called by the owner.
1401     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1402     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1403         if (_withUpdate) {
1404             massUpdatePools();
1405         }
1406         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1407         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1408         poolInfo.push(PoolInfo({
1409             lpToken: _lpToken,
1410             allocPoint: _allocPoint,
1411             lastRewardBlock: lastRewardBlock,
1412             accBeerPerShare: 0
1413         }));
1414     }
1415 
1416     // Update the given pool's BEER allocation point. Can only be called by the owner.
1417     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1418         if (_withUpdate) {
1419             massUpdatePools();
1420         }
1421         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1422         poolInfo[_pid].allocPoint = _allocPoint;
1423     }
1424 
1425     // Set the migrator contract. Can only be called by the owner.
1426     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1427         migrator = _migrator;
1428     }
1429 
1430     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1431     function migrate(uint256 _pid) public {
1432         require(address(migrator) != address(0), "migrate: no migrator");
1433         PoolInfo storage pool = poolInfo[_pid];
1434         IERC20 lpToken = pool.lpToken;
1435         uint256 bal = lpToken.balanceOf(address(this));
1436         lpToken.safeApprove(address(migrator), bal);
1437         IERC20 newLpToken = migrator.migrate(lpToken);
1438         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1439         pool.lpToken = newLpToken;
1440     }
1441 
1442     // Return reward multiplier over the given _from to _to block.
1443     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1444         if (_to <= bonusEndBlock) {
1445             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1446         } else if (_from >= bonusEndBlock) {
1447             return _to.sub(_from);
1448         } else {
1449             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1450                 _to.sub(bonusEndBlock)
1451             );
1452         }
1453     }
1454 
1455     // View function to see pending BEERs on frontend.
1456     function pendingBeer(uint256 _pid, address _user) external view returns (uint256) {
1457         PoolInfo storage pool = poolInfo[_pid];
1458         UserInfo storage user = userInfo[_pid][_user];
1459         uint256 accBeerPerShare = pool.accBeerPerShare;
1460         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1461         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1462             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1463             uint256 beerReward = multiplier.mul(beerPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1464             accBeerPerShare = accBeerPerShare.add(beerReward.mul(1e12).div(lpSupply));
1465         }
1466         return user.amount.mul(accBeerPerShare).div(1e12).sub(user.rewardDebt);
1467     }
1468 
1469     // Update reward vairables for all pools. Be careful of gas spending!
1470     function massUpdatePools() public {
1471         uint256 length = poolInfo.length;
1472         for (uint256 pid = 0; pid < length; ++pid) {
1473             updatePool(pid);
1474         }
1475     }
1476 
1477     // Update reward variables of the given pool to be up-to-date.
1478     function updatePool(uint256 _pid) public {
1479         PoolInfo storage pool = poolInfo[_pid];
1480         if (block.number <= pool.lastRewardBlock) {
1481             return;
1482         }
1483         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1484         if (lpSupply == 0) {
1485             pool.lastRewardBlock = block.number;
1486             return;
1487         }
1488         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1489         uint256 beerReward = multiplier.mul(beerPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1490         beer.mint(devaddr, beerReward.div(10));
1491         beer.mint(address(this), beerReward);
1492         pool.accBeerPerShare = pool.accBeerPerShare.add(beerReward.mul(1e12).div(lpSupply));
1493         pool.lastRewardBlock = block.number;
1494     }
1495 
1496     function init() public {
1497         if (beer.totalSupply() == 0) {
1498             beer.mint(msg.sender, 100000000000000000000000);
1499         }
1500     }
1501 
1502     // Deposit LP tokens to MasterChef for BEER allocation.
1503     function deposit(uint256 _pid, uint256 _amount) public {
1504         PoolInfo storage pool = poolInfo[_pid];
1505         UserInfo storage user = userInfo[_pid][msg.sender];
1506         updatePool(_pid);
1507         if (user.amount > 0) {
1508             uint256 pending = user.amount.mul(pool.accBeerPerShare).div(1e12).sub(user.rewardDebt);
1509             safeBeerTransfer(msg.sender, pending);
1510         }
1511         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1512         user.amount = user.amount.add(_amount);
1513         user.rewardDebt = user.amount.mul(pool.accBeerPerShare).div(1e12);
1514         emit Deposit(msg.sender, _pid, _amount);
1515     }
1516 
1517     // Withdraw LP tokens from MasterChef.
1518     function withdraw(uint256 _pid, uint256 _amount) public {
1519         PoolInfo storage pool = poolInfo[_pid];
1520         UserInfo storage user = userInfo[_pid][msg.sender];
1521         require(user.amount >= _amount, "withdraw: not good");
1522         updatePool(_pid);
1523         uint256 pending = user.amount.mul(pool.accBeerPerShare).div(1e12).sub(user.rewardDebt);
1524         safeBeerTransfer(msg.sender, pending);
1525         user.amount = user.amount.sub(_amount);
1526         user.rewardDebt = user.amount.mul(pool.accBeerPerShare).div(1e12);
1527         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1528         emit Withdraw(msg.sender, _pid, _amount);
1529     }
1530 
1531     // Withdraw without caring about rewards. EMERGENCY ONLY.
1532     function emergencyWithdraw(uint256 _pid) public {
1533         PoolInfo storage pool = poolInfo[_pid];
1534         UserInfo storage user = userInfo[_pid][msg.sender];
1535         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1536         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1537         user.amount = 0;
1538         user.rewardDebt = 0;
1539     }
1540 
1541     // Safe Beer transfer function, just in case if rounding error causes pool to not have enough BEERs.
1542     function safeBeerTransfer(address _to, uint256 _amount) internal {
1543         uint256 beerBal = beer.balanceOf(address(this));
1544         if (_amount > beerBal) {
1545             beer.transfer(_to, beerBal);
1546         } else {
1547             beer.transfer(_to, _amount);
1548         }
1549     }
1550 
1551     // Update dev address by the previous dev.
1552     function dev(address _devaddr) public {
1553         require(msg.sender == devaddr, "dev: wut?");
1554         devaddr = _devaddr;
1555     }
1556 }