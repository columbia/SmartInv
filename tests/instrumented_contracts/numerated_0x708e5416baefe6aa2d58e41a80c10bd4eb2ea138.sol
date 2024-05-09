1 // SPDX-License-Identifier: MIT
2 //File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 pragma solidity ^0.6.0;
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
79 // File: @openzeppelin/contracts/math/SafeMath.sol
80 pragma solidity ^0.6.0;
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
237 // File: @openzeppelin/contracts/utils/Address.sol
238 pragma solidity ^0.6.2;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
263         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
264         // for accounts without code, i.e. `keccak256('')`
265         bytes32 codehash;
266         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
267         // solhint-disable-next-line no-inline-assembly
268         assembly { codehash := extcodehash(account) }
269         return (codehash != accountHash && codehash != 0x0);
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
292         (bool success, ) = recipient.call{ value: amount }("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain`call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315       return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
325         return _functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         return _functionCallWithValue(target, data, value, errorMessage);
352     }
353 
354     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
355         require(isContract(target), "Address: call to non-contract");
356 
357         // solhint-disable-next-line avoid-low-level-calls
358         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
359         if (success) {
360             return returndata;
361         } else {
362             // Look for revert reason and bubble it up if present
363             if (returndata.length > 0) {
364                 // The easiest way to bubble the revert reason is using memory via assembly
365 
366                 // solhint-disable-next-line no-inline-assembly
367                 assembly {
368                     let returndata_size := mload(returndata)
369                     revert(add(32, returndata), returndata_size)
370                 }
371             } else {
372                 revert(errorMessage);
373             }
374         }
375     }
376 }
377 
378 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
379 pragma solidity ^0.6.0;
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
448 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
449 pragma solidity ^0.6.0;
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
689 // File: @openzeppelin/contracts/GSN/Context.sol
690 pragma solidity ^0.6.0;
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
712 // File: @openzeppelin/contracts/access/Ownable.sol
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
779 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
780 pragma solidity ^0.6.0;
781 /**
782  * @dev Implementation of the {IERC20} interface.
783  *
784  * This implementation is agnostic to the way tokens are created. This means
785  * that a supply mechanism has to be added in a derived contract using {_distribute}.
786  * For a generic mechanism see {ERC20PresetMinterPauser}.
787  *
788  * TIP: For a detailed writeup see our guide
789  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
790  * to implement supply mechanisms].
791  *
792  * We have followed general OpenZeppelin guidelines: functions revert instead
793  * of returning `false` on failure. This behavior is nonetheless conventional
794  * and does not conflict with the expectations of ERC20 applications.
795  *
796  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
797  * This allows applications to reconstruct the allowance for all accounts just
798  * by listening to said events. Other implementations of the EIP may not emit
799  * these events, as it isn't required by the specification.
800  *
801  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
802  * functions have been added to mitigate the well-known issues around setting
803  * allowances. See {IERC20-approve}.
804  */
805 contract ERC20 is Context, IERC20 {
806     using SafeMath for uint256;
807     using Address for address;
808 
809     mapping (address => uint256) private _balances;
810 
811     mapping (address => mapping (address => uint256)) private _allowances;
812 
813     uint256 private _totalSupply;
814 
815     string private _name;
816     string private _symbol;
817     uint8 private _decimals;
818 
819     /**
820      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
821      * a default value of 18.
822      *
823      * To select a different value for {decimals}, use {_setupDecimals}.
824      *
825      * All three of these values are immutable: they can only be set once during
826      * construction.
827      */
828     constructor (string memory name, string memory symbol) public {
829         _name = name;
830         _symbol = symbol;
831         _decimals = 18;
832     }
833 
834     /**
835      * @dev Returns the name of the token.
836      */
837     function name() public view returns (string memory) {
838         return _name;
839     }
840 
841     /**
842      * @dev Returns the symbol of the token, usually a shorter version of the
843      * name.
844      */
845     function symbol() public view returns (string memory) {
846         return _symbol;
847     }
848 
849     /**
850      * @dev Returns the number of decimals used to get its user representation.
851      * For example, if `decimals` equals `2`, a balance of `505` tokens should
852      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
853      *
854      * Tokens usually opt for a value of 18, imitating the relationship between
855      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
856      * called.
857      *
858      * NOTE: This information is only used for _display_ purposes: it in
859      * no way affects any of the arithmetic of the contract, including
860      * {IERC20-balanceOf} and {IERC20-transfer}.
861      */
862     function decimals() public view returns (uint8) {
863         return _decimals;
864     }
865 
866     /**
867      * @dev See {IERC20-totalSupply}.
868      */
869     function totalSupply() public view override returns (uint256) {
870         return _totalSupply;
871     }
872 
873     /**
874      * @dev See {IERC20-balanceOf}.
875      */
876     function balanceOf(address account) public view override returns (uint256) {
877         return _balances[account];
878     }
879 
880     /**
881      * @dev See {IERC20-transfer}.
882      *
883      * Requirements:
884      *
885      * - `recipient` cannot be the zero address.
886      * - the caller must have a balance of at least `amount`.
887      */
888     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
889         _transfer(_msgSender(), recipient, amount);
890         return true;
891     }
892 
893     /**
894      * @dev See {IERC20-allowance}.
895      */
896     function allowance(address owner, address spender) public view virtual override returns (uint256) {
897         return _allowances[owner][spender];
898     }
899 
900     /**
901      * @dev See {IERC20-approve}.
902      *
903      * Requirements:
904      *
905      * - `spender` cannot be the zero address.
906      */
907     function approve(address spender, uint256 amount) public virtual override returns (bool) {
908         _approve(_msgSender(), spender, amount);
909         return true;
910     }
911 
912     /**
913      * @dev See {IERC20-transferFrom}.
914      *
915      * Emits an {Approval} event indicating the updated allowance. This is not
916      * required by the EIP. See the note at the beginning of {ERC20};
917      *
918      * Requirements:
919      * - `sender` and `recipient` cannot be the zero address.
920      * - `sender` must have a balance of at least `amount`.
921      * - the caller must have allowance for ``sender``'s tokens of at least
922      * `amount`.
923      */
924     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
925         _transfer(sender, recipient, amount);
926         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
927         return true;
928     }
929 
930     /**
931      * @dev Atomically increases the allowance granted to `spender` by the caller.
932      *
933      * This is an alternative to {approve} that can be used as a mitigation for
934      * problems described in {IERC20-approve}.
935      *
936      * Emits an {Approval} event indicating the updated allowance.
937      *
938      * Requirements:
939      *
940      * - `spender` cannot be the zero address.
941      */
942     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
943         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
944         return true;
945     }
946 
947     /**
948      * @dev Atomically decreases the allowance granted to `spender` by the caller.
949      *
950      * This is an alternative to {approve} that can be used as a mitigation for
951      * problems described in {IERC20-approve}.
952      *
953      * Emits an {Approval} event indicating the updated allowance.
954      *
955      * Requirements:
956      *
957      * - `spender` cannot be the zero address.
958      * - `spender` must have allowance for the caller of at least
959      * `subtractedValue`.
960      */
961     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
962         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
963         return true;
964     }
965 
966     /**
967      * @dev Moves tokens `amount` from `sender` to `recipient`.
968      *
969      * This is internal function is equivalent to {transfer}, and can be used to
970      * e.g. implement automatic token fees, slashing mechanisms, etc.
971      *
972      * Emits a {Transfer} event.
973      *
974      * Requirements:
975      *
976      * - `sender` cannot be the zero address.
977      * - `recipient` cannot be the zero address.
978      * - `sender` must have a balance of at least `amount`.
979      */
980     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
981         require(sender != address(0), "ERC20: transfer from the zero address");
982         require(recipient != address(0), "ERC20: transfer to the zero address");
983 
984         _beforeTokenTransfer(sender, recipient, amount);
985 
986         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
987         _balances[recipient] = _balances[recipient].add(amount);
988         emit Transfer(sender, recipient, amount);
989     }
990 
991     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
992      * the total supply.
993      * - `to` cannot be the zero address.
994      */
995     function _distribute(address account, uint256 amount) internal virtual {
996         require(account != address(0), "ERC20: unable to do toward the zero address");
997 
998         _beforeTokenTransfer(address(0), account, amount);
999 
1000         _totalSupply = _totalSupply.add(amount);
1001         _balances[account] = _balances[account].add(amount);
1002         emit Transfer(address(0), account, amount);
1003     }
1004 
1005     /**
1006      * @dev Destroys `amount` tokens from `account`, reducing the
1007      * total supply.
1008      *
1009      * Emits a {Transfer} event with `to` set to the zero address.
1010      *
1011      * Requirements
1012      *
1013      * - `account` cannot be the zero address.
1014      * - `account` must have at least `amount` tokens.
1015      */
1016     function _burn(address account, uint256 amount) internal virtual {
1017         require(account != address(0), "ERC20: burn from the zero address");
1018 
1019         _beforeTokenTransfer(account, address(0), amount);
1020 
1021         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1022         _totalSupply = _totalSupply.sub(amount);
1023         emit Transfer(account, address(0), amount);
1024     }
1025 
1026     /**
1027      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1028      *
1029      * This is internal function is equivalent to `approve`, and can be used to
1030      * e.g. set automatic allowances for certain subsystems, etc.
1031      *
1032      * Emits an {Approval} event.
1033      *
1034      * Requirements:
1035      *
1036      * - `owner` cannot be the zero address.
1037      * - `spender` cannot be the zero address.
1038      */
1039     function _approve(address owner, address spender, uint256 amount) internal virtual {
1040         require(owner != address(0), "ERC20: approve from the zero address");
1041         require(spender != address(0), "ERC20: approve to the zero address");
1042 
1043         _allowances[owner][spender] = amount;
1044         emit Approval(owner, spender, amount);
1045     }
1046 
1047     /**
1048      * @dev Sets {decimals} to a value other than the default one of 18.
1049      *
1050      * WARNING: This function should only be called from the constructor. Most
1051      * applications that interact with token contracts will not expect
1052      * {decimals} to ever change, and may work incorrectly if it does.
1053      */
1054     function _setupDecimals(uint8 decimals_) internal {
1055         _decimals = decimals_;
1056     }
1057 
1058     /**
1059      * @dev Hook that is called before any transfer of tokens.
1060      */
1061     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1062 }
1063 
1064 
1065 // File: contracts/SilentSwapToken.sol
1066 pragma solidity 0.6.12;
1067 contract SilentSwapToken is ERC20("SilentSwap.org", "SILE"), Ownable {
1068     using SafeMath for uint256;
1069     uint8 public taxRatio = 3;
1070     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1071         uint256 taxAmount = amount.mul(taxRatio).div(100);
1072         _burn(msg.sender, taxAmount);
1073         return super.transfer(recipient, amount.sub(taxAmount));
1074     }
1075     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1076         uint256 taxAmount = amount.mul(taxRatio).div(100);
1077         _burn(sender, taxAmount);
1078         return super.transferFrom(sender, recipient, amount.sub(taxAmount));
1079     }
1080     
1081      /**
1082      * @dev Chef distributes newly generated SilentSwapToken to each farmmers
1083      * "onlyOwner" :: for the one who worries about the function, this distribute process is only done by MasterChef contract for farming process
1084      */
1085     function distribute(address _to, uint256 _amount) public onlyOwner {
1086         _distribute(_to, _amount);
1087         _moveDelegates(address(0), _delegates[_to], _amount);
1088     }
1089     
1090     /**
1091      * @dev Burning token
1092      */
1093     function burn(address _from, uint256 _amount) public {
1094         _burn(_from, _amount);
1095     }
1096     
1097     /**
1098      * @dev Tokenomic decition from governance
1099      */
1100     function changeTaxRatio(uint8 _taxRatio) public onlyOwner {
1101         taxRatio = _taxRatio;
1102     }
1103     
1104     mapping (address => address) internal _delegates;
1105     struct Checkpoint {
1106         uint32 fromBlock;
1107         uint256 votes;
1108     }
1109 
1110     /// @notice A record of votes checkpoints for each account, by index
1111     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1112     /// @notice The number of checkpoints for each account
1113     mapping (address => uint32) public numCheckpoints;
1114     /// @notice The EIP-712 typehash for the contract's domain
1115     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1116     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1117     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1118     /// @notice A record of states for signing / validating signatures
1119     mapping (address => uint) public nonces;
1120     /// @notice An event thats emitted when an account changes its delegate
1121     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1122     /// @notice An event thats emitted when a delegate account's vote balance changes
1123     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1124     
1125     /**
1126      * @notice Delegate votes from `msg.sender` to `delegatee`
1127      * @param delegator The address to get delegatee for
1128      */
1129     function delegates(address delegator)
1130         external
1131         view
1132         returns (address)
1133     {
1134         return _delegates[delegator];
1135     }
1136 
1137    /**
1138     * @notice Delegate votes from `msg.sender` to `delegatee`
1139     * @param delegatee The address to delegate votes to
1140     */
1141     function delegate(address delegatee) external {
1142         return _delegate(msg.sender, delegatee);
1143     }
1144 
1145     /**
1146      * @notice Delegates votes from signatory to `delegatee`
1147      * @param delegatee The address to delegate votes to
1148      * @param nonce The contract state required to match the signature
1149      * @param expiry The time at which to expire the signature
1150      * @param v The recovery byte of the signature
1151      * @param r Half of the ECDSA signature pair
1152      * @param s Half of the ECDSA signature pair
1153      */
1154     function delegateBySig(
1155         address delegatee,
1156         uint nonce,
1157         uint expiry,
1158         uint8 v,
1159         bytes32 r,
1160         bytes32 s
1161     )
1162         external
1163     {
1164         bytes32 domainSeparator = keccak256(
1165             abi.encode(
1166                 DOMAIN_TYPEHASH,
1167                 keccak256(bytes(name())),
1168                 getChainId(),
1169                 address(this)
1170             )
1171         );
1172 
1173         bytes32 structHash = keccak256(
1174             abi.encode(
1175                 DELEGATION_TYPEHASH,
1176                 delegatee,
1177                 nonce,
1178                 expiry
1179             )
1180         );
1181 
1182         bytes32 digest = keccak256(
1183             abi.encodePacked(
1184                 "\x19\x01",
1185                 domainSeparator,
1186                 structHash
1187             )
1188         );
1189 
1190         address signatory = ecrecover(digest, v, r, s);
1191         require(signatory != address(0), "SilentSwap.org::delegateBySig: invalid signature");
1192         require(nonce == nonces[signatory]++, "SilentSwap.org::delegateBySig: invalid nonce");
1193         require(now <= expiry, "SilentSwap.org::delegateBySig: signature expired");
1194         return _delegate(signatory, delegatee);
1195     }
1196 
1197     /**
1198      * @notice Gets the current votes balance for `account`
1199      * @param account The address to get votes balance
1200      * @return The number of current votes for `account`
1201      */
1202     function getCurrentVotes(address account)
1203         external
1204         view
1205         returns (uint256)
1206     {
1207         uint32 nCheckpoints = numCheckpoints[account];
1208         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1209     }
1210 
1211     /**
1212      * @notice Determine the prior number of votes for an account as of a block number
1213      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1214      * @param account The address of the account to check
1215      * @param blockNumber The block number to get the vote balance at
1216      * @return The number of votes the account had as of the given block
1217      */
1218     function getPriorVotes(address account, uint blockNumber)
1219         external
1220         view
1221         returns (uint256)
1222     {
1223         require(blockNumber < block.number, "SilentSwap.org::getPriorVotes: not yet determined");
1224 
1225         uint32 nCheckpoints = numCheckpoints[account];
1226         if (nCheckpoints == 0) {
1227             return 0;
1228         }
1229         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1230             return checkpoints[account][nCheckpoints - 1].votes;
1231         }
1232         if (checkpoints[account][0].fromBlock > blockNumber) {
1233             return 0;
1234         }
1235 
1236         uint32 lower = 0;
1237         uint32 upper = nCheckpoints - 1;
1238         while (upper > lower) {
1239             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1240             Checkpoint memory cp = checkpoints[account][center];
1241             if (cp.fromBlock == blockNumber) {
1242                 return cp.votes;
1243             } else if (cp.fromBlock < blockNumber) {
1244                 lower = center;
1245             } else {
1246                 upper = center - 1;
1247             }
1248         }
1249         return checkpoints[account][lower].votes;
1250     }
1251 
1252     function _delegate(address delegator, address delegatee)
1253         internal
1254     {
1255         address currentDelegate = _delegates[delegator];
1256         uint256 delegatorBalance = balanceOf(delegator);
1257         _delegates[delegator] = delegatee;
1258         emit DelegateChanged(delegator, currentDelegate, delegatee);
1259         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1260     }
1261 
1262     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1263         if (srcRep != dstRep && amount > 0) {
1264             if (srcRep != address(0)) {
1265                 // decrease old representative
1266                 uint32 srcRepNum = numCheckpoints[srcRep];
1267                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1268                 uint256 srcRepNew = srcRepOld.sub(amount);
1269                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1270             }
1271             if (dstRep != address(0)) {
1272                 // increase new representative
1273                 uint32 dstRepNum = numCheckpoints[dstRep];
1274                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1275                 uint256 dstRepNew = dstRepOld.add(amount);
1276                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1277             }
1278         }
1279     }
1280 
1281     function _writeCheckpoint(
1282         address delegatee,
1283         uint32 nCheckpoints,
1284         uint256 oldVotes,
1285         uint256 newVotes
1286     )
1287         internal
1288     {
1289         uint32 blockNumber = safe32(block.number, "SilentSwap.org::_writeCheckpoint: block number exceeds 32 bits");
1290         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1291             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1292         } else {
1293             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1294             numCheckpoints[delegatee] = nCheckpoints + 1;
1295         }
1296         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1297     }
1298 
1299     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1300         require(n < 2**32, errorMessage);
1301         return uint32(n);
1302     }
1303 
1304     function getChainId() internal pure returns (uint) {
1305         uint256 chainId;
1306         assembly { chainId := chainid() }
1307         return chainId;
1308     }
1309 }