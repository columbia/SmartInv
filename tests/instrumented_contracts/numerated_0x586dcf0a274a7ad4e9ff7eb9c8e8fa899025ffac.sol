1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 pragma solidity ^0.6.0;
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
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 pragma solidity ^0.6.0;
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      *
104      * - Addition cannot overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b <= a, errorMessage);
139         uint256 c = a - b;
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `*` operator.
149      *
150      * Requirements:
151      *
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b > 0, errorMessage);
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b != 0, errorMessage);
234         return a % b;
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/Address.sol
239 pragma solidity ^0.6.2;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
264         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
265         // for accounts without code, i.e. `keccak256('')`
266         bytes32 codehash;
267         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
268         // solhint-disable-next-line no-inline-assembly
269         assembly { codehash := extcodehash(account) }
270         return (codehash != accountHash && codehash != 0x0);
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
293         (bool success, ) = recipient.call{ value: amount }("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain`call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316       return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
326         return _functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
351         require(address(this).balance >= value, "Address: insufficient balance for call");
352         return _functionCallWithValue(target, data, value, errorMessage);
353     }
354 
355     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
356         require(isContract(target), "Address: call to non-contract");
357 
358         // solhint-disable-next-line avoid-low-level-calls
359         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
360         if (success) {
361             return returndata;
362         } else {
363             // Look for revert reason and bubble it up if present
364             if (returndata.length > 0) {
365                 // The easiest way to bubble the revert reason is using memory via assembly
366 
367                 // solhint-disable-next-line no-inline-assembly
368                 assembly {
369                     let returndata_size := mload(returndata)
370                     revert(add(32, returndata), returndata_size)
371                 }
372             } else {
373                 revert(errorMessage);
374             }
375         }
376     }
377 }
378 
379 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
380 pragma solidity ^0.6.0;
381 /**
382  * @title SafeERC20
383  * @dev Wrappers around ERC20 operations that throw on failure (when the token
384  * contract returns false). Tokens that return no value (and instead revert or
385  * throw on failure) are also supported, non-reverting calls are assumed to be
386  * successful.
387  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
388  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
389  */
390 library SafeERC20 {
391     using SafeMath for uint256;
392     using Address for address;
393 
394     function safeTransfer(IERC20 token, address to, uint256 value) internal {
395         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
396     }
397 
398     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
399         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
400     }
401 
402     /**
403      * @dev Deprecated. This function has issues similar to the ones found in
404      * {IERC20-approve}, and its usage is discouraged.
405      *
406      * Whenever possible, use {safeIncreaseAllowance} and
407      * {safeDecreaseAllowance} instead.
408      */
409     function safeApprove(IERC20 token, address spender, uint256 value) internal {
410         // safeApprove should only be called when setting an initial allowance,
411         // or when resetting it to zero. To increase and decrease it, use
412         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
413         // solhint-disable-next-line max-line-length
414         require((value == 0) || (token.allowance(address(this), spender) == 0),
415             "SafeERC20: approve from non-zero to non-zero allowance"
416         );
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
418     }
419 
420     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).add(value);
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
426         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
427         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
428     }
429 
430     /**
431      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
432      * on the return value: the return value is optional (but if data is returned, it must not be false).
433      * @param token The token targeted by the call.
434      * @param data The call data (encoded using abi.encode or one of its variants).
435      */
436     function _callOptionalReturn(IERC20 token, bytes memory data) private {
437         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
438         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
439         // the target address contains contract code and also asserts for success in the low-level call.
440 
441         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
442         if (returndata.length > 0) { // Return data is optional
443             // solhint-disable-next-line max-line-length
444             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
445         }
446     }
447 }
448 
449 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
450 pragma solidity ^0.6.0;
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
691 // File: @openzeppelin/contracts/GSN/Context.sol
692 pragma solidity ^0.6.0;
693 /*
694  * @dev Provides information about the current execution context, including the
695  * sender of the transaction and its data. While these are generally available
696  * via msg.sender and msg.data, they should not be accessed in such a direct
697  * manner, since when dealing with GSN meta-transactions the account sending and
698  * paying for execution may not be the actual sender (as far as an application
699  * is concerned).
700  *
701  * This contract is only required for intermediate, library-like contracts.
702  */
703 abstract contract Context {
704     function _msgSender() internal view virtual returns (address payable) {
705         return msg.sender;
706     }
707 
708     function _msgData() internal view virtual returns (bytes memory) {
709         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
710         return msg.data;
711     }
712 }
713 
714 // File: @openzeppelin/contracts/access/Ownable.sol
715 pragma solidity ^0.6.0;
716 
717 /**
718  * @dev Contract module which provides a basic access control mechanism, where
719  * there is an account (an owner) that can be granted exclusive access to
720  * specific functions.
721  *
722  * By default, the owner account will be the one that deploys the contract. This
723  * can later be changed with {transferOwnership}.
724  *
725  * This module is used through inheritance. It will make available the modifier
726  * `onlyOwner`, which can be applied to your functions to restrict their use to
727  * the owner.
728  */
729 contract Ownable is Context {
730     address private _owner;
731 
732     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
733 
734     /**
735      * @dev Initializes the contract setting the deployer as the initial owner.
736      */
737     constructor () internal {
738         address msgSender = _msgSender();
739         _owner = msgSender;
740         emit OwnershipTransferred(address(0), msgSender);
741     }
742 
743     /**
744      * @dev Returns the address of the current owner.
745      */
746     function owner() public view returns (address) {
747         return _owner;
748     }
749 
750     /**
751      * @dev Throws if called by any account other than the owner.
752      */
753     modifier onlyOwner() {
754         require(_owner == _msgSender(), "Ownable: caller is not the owner");
755         _;
756     }
757 
758     /**
759      * @dev Leaves the contract without owner. It will not be possible to call
760      * `onlyOwner` functions anymore. Can only be called by the current owner.
761      *
762      * NOTE: Renouncing ownership will leave the contract without an owner,
763      * thereby removing any functionality that is only available to the owner.
764      */
765     function renounceOwnership() public virtual onlyOwner {
766         emit OwnershipTransferred(_owner, address(0));
767         _owner = address(0);
768     }
769 
770     /**
771      * @dev Transfers ownership of the contract to a new account (`newOwner`).
772      * Can only be called by the current owner.
773      */
774     function transferOwnership(address newOwner) public virtual onlyOwner {
775         require(newOwner != address(0), "Ownable: new owner is the zero address");
776         emit OwnershipTransferred(_owner, newOwner);
777         _owner = newOwner;
778     }
779 }
780 
781 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
782 pragma solidity ^0.6.0;
783 /**
784  * @dev Implementation of the {IERC20} interface.
785  *
786  * This implementation is agnostic to the way tokens are created. This means
787  * that a supply mechanism has to be added in a derived contract using {_mint}.
788  * For a generic mechanism see {ERC20PresetMinterPauser}.
789  *
790  * TIP: For a detailed writeup see our guide
791  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
792  * to implement supply mechanisms].
793  *
794  * We have followed general OpenZeppelin guidelines: functions revert instead
795  * of returning `false` on failure. This behavior is nonetheless conventional
796  * and does not conflict with the expectations of ERC20 applications.
797  *
798  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
799  * This allows applications to reconstruct the allowance for all accounts just
800  * by listening to said events. Other implementations of the EIP may not emit
801  * these events, as it isn't required by the specification.
802  *
803  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
804  * functions have been added to mitigate the well-known issues around setting
805  * allowances. See {IERC20-approve}.
806  */
807 contract ERC20 is Context, IERC20 {
808     using SafeMath for uint256;
809     using Address for address;
810 
811     mapping (address => uint256) private _balances;
812 
813     mapping (address => mapping (address => uint256)) private _allowances;
814 
815     uint256 private _totalSupply;
816 
817     string private _name;
818     string private _symbol;
819     uint8 private _decimals;
820 
821     /**
822      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
823      * a default value of 18.
824      *
825      * To select a different value for {decimals}, use {_setupDecimals}.
826      *
827      * All three of these values are immutable: they can only be set once during
828      * construction.
829      */
830     constructor (string memory name, string memory symbol) public {
831         _name = name;
832         _symbol = symbol;
833         _decimals = 18;
834     }
835 
836     /**
837      * @dev Returns the name of the token.
838      */
839     function name() public view returns (string memory) {
840         return _name;
841     }
842 
843     /**
844      * @dev Returns the symbol of the token, usually a shorter version of the
845      * name.
846      */
847     function symbol() public view returns (string memory) {
848         return _symbol;
849     }
850 
851     /**
852      * @dev Returns the number of decimals used to get its user representation.
853      * For example, if `decimals` equals `2`, a balance of `505` tokens should
854      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
855      *
856      * Tokens usually opt for a value of 18, imitating the relationship between
857      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
858      * called.
859      *
860      * NOTE: This information is only used for _display_ purposes: it in
861      * no way affects any of the arithmetic of the contract, including
862      * {IERC20-balanceOf} and {IERC20-transfer}.
863      */
864     function decimals() public view returns (uint8) {
865         return _decimals;
866     }
867 
868     /**
869      * @dev See {IERC20-totalSupply}.
870      */
871     function totalSupply() public view override returns (uint256) {
872         return _totalSupply;
873     }
874 
875     /**
876      * @dev See {IERC20-balanceOf}.
877      */
878     function balanceOf(address account) public view override returns (uint256) {
879         return _balances[account];
880     }
881 
882     /**
883      * @dev See {IERC20-transfer}.
884      *
885      * Requirements:
886      *
887      * - `recipient` cannot be the zero address.
888      * - the caller must have a balance of at least `amount`.
889      */
890     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
891         _transfer(_msgSender(), recipient, amount);
892         return true;
893     }
894 
895     /**
896      * @dev See {IERC20-allowance}.
897      */
898     function allowance(address owner, address spender) public view virtual override returns (uint256) {
899         return _allowances[owner][spender];
900     }
901 
902     /**
903      * @dev See {IERC20-approve}.
904      *
905      * Requirements:
906      *
907      * - `spender` cannot be the zero address.
908      */
909     function approve(address spender, uint256 amount) public virtual override returns (bool) {
910         _approve(_msgSender(), spender, amount);
911         return true;
912     }
913 
914     /**
915      * @dev See {IERC20-transferFrom}.
916      *
917      * Emits an {Approval} event indicating the updated allowance. This is not
918      * required by the EIP. See the note at the beginning of {ERC20};
919      *
920      * Requirements:
921      * - `sender` and `recipient` cannot be the zero address.
922      * - `sender` must have a balance of at least `amount`.
923      * - the caller must have allowance for ``sender``'s tokens of at least
924      * `amount`.
925      */
926     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
927         _transfer(sender, recipient, amount);
928         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
929         return true;
930     }
931 
932     /**
933      * @dev Atomically increases the allowance granted to `spender` by the caller.
934      *
935      * This is an alternative to {approve} that can be used as a mitigation for
936      * problems described in {IERC20-approve}.
937      *
938      * Emits an {Approval} event indicating the updated allowance.
939      *
940      * Requirements:
941      *
942      * - `spender` cannot be the zero address.
943      */
944     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
945         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
946         return true;
947     }
948 
949     /**
950      * @dev Atomically decreases the allowance granted to `spender` by the caller.
951      *
952      * This is an alternative to {approve} that can be used as a mitigation for
953      * problems described in {IERC20-approve}.
954      *
955      * Emits an {Approval} event indicating the updated allowance.
956      *
957      * Requirements:
958      *
959      * - `spender` cannot be the zero address.
960      * - `spender` must have allowance for the caller of at least
961      * `subtractedValue`.
962      */
963     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
964         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
965         return true;
966     }
967 
968     /**
969      * @dev Moves tokens `amount` from `sender` to `recipient`.
970      *
971      * This is internal function is equivalent to {transfer}, and can be used to
972      * e.g. implement automatic token fees, slashing mechanisms, etc.
973      *
974      * Emits a {Transfer} event.
975      *
976      * Requirements:
977      *
978      * - `sender` cannot be the zero address.
979      * - `recipient` cannot be the zero address.
980      * - `sender` must have a balance of at least `amount`.
981      */
982     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
983         require(sender != address(0), "ERC20: transfer from the zero address");
984         require(recipient != address(0), "ERC20: transfer to the zero address");
985 
986         _beforeTokenTransfer(sender, recipient, amount);
987 
988         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
989         _balances[recipient] = _balances[recipient].add(amount);
990         emit Transfer(sender, recipient, amount);
991     }
992 
993     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
994      * the total supply.
995      *
996      * Emits a {Transfer} event with `from` set to the zero address.
997      *
998      * Requirements
999      *
1000      * - `to` cannot be the zero address.
1001      */
1002     function _mint(address account, uint256 amount) internal virtual {
1003         require(account != address(0), "ERC20: mint to the zero address");
1004 
1005         _beforeTokenTransfer(address(0), account, amount);
1006 
1007         _totalSupply = _totalSupply.add(amount);
1008         _balances[account] = _balances[account].add(amount);
1009         emit Transfer(address(0), account, amount);
1010     }
1011 
1012     /**
1013      * @dev Destroys `amount` tokens from `account`, reducing the
1014      * total supply.
1015      *
1016      * Emits a {Transfer} event with `to` set to the zero address.
1017      *
1018      * Requirements
1019      *
1020      * - `account` cannot be the zero address.
1021      * - `account` must have at least `amount` tokens.
1022      */
1023     function _burn(address account, uint256 amount) internal virtual {
1024         require(account != address(0), "ERC20: burn from the zero address");
1025 
1026         _beforeTokenTransfer(account, address(0), amount);
1027 
1028         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1029         _totalSupply = _totalSupply.sub(amount);
1030         emit Transfer(account, address(0), amount);
1031     }
1032 
1033     /**
1034      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1035      *
1036      * This is internal function is equivalent to `approve`, and can be used to
1037      * e.g. set automatic allowances for certain subsystems, etc.
1038      *
1039      * Emits an {Approval} event.
1040      *
1041      * Requirements:
1042      *
1043      * - `owner` cannot be the zero address.
1044      * - `spender` cannot be the zero address.
1045      */
1046     function _approve(address owner, address spender, uint256 amount) internal virtual {
1047         require(owner != address(0), "ERC20: approve from the zero address");
1048         require(spender != address(0), "ERC20: approve to the zero address");
1049 
1050         _allowances[owner][spender] = amount;
1051         emit Approval(owner, spender, amount);
1052     }
1053 
1054     /**
1055      * @dev Sets {decimals} to a value other than the default one of 18.
1056      *
1057      * WARNING: This function should only be called from the constructor. Most
1058      * applications that interact with token contracts will not expect
1059      * {decimals} to ever change, and may work incorrectly if it does.
1060      */
1061     function _setupDecimals(uint8 decimals_) internal {
1062         _decimals = decimals_;
1063     }
1064 
1065     /**
1066      * @dev Hook that is called before any transfer of tokens. This includes
1067      * minting and burning.
1068      *
1069      * Calling conditions:
1070      *
1071      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1072      * will be to transferred to `to`.
1073      * - when `from` is zero, `amount` tokens will be minted for `to`.
1074      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1075      * - `from` and `to` are never both zero.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1080 }
1081 
1082 // File: contracts/UniSushiToken.sol
1083 pragma solidity 0.6.12;
1084 contract UniSushiToken is ERC20("UniSushi", "UniSushi"), Ownable {
1085     function mint(address _to, uint256 _amount) public onlyOwner {
1086         _mint(_to, _amount);
1087         _moveDelegates(address(0), _delegates[_to], _amount);
1088     }
1089     // Copied and modified from YAM and COMPOUND and SUSHI:
1090     mapping (address => address) internal _delegates;
1091     struct Checkpoint {
1092         uint32 fromBlock;
1093         uint256 votes;
1094     }
1095 
1096     /// @notice A record of votes checkpoints for each account, by index
1097     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1098     /// @notice The number of checkpoints for each account
1099     mapping (address => uint32) public numCheckpoints;
1100     /// @notice The EIP-712 typehash for the contract's domain
1101     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1102     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1103     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1104     /// @notice A record of states for signing / validating signatures
1105     mapping (address => uint) public nonces;
1106     /// @notice An event thats emitted when an account changes its delegate
1107     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1108     /// @notice An event thats emitted when a delegate account's vote balance changes
1109     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1110 
1111     /**
1112      * @notice Delegate votes from `msg.sender` to `delegatee`
1113      * @param delegator The address to get delegatee for
1114      */
1115     function delegates(address delegator)
1116         external
1117         view
1118         returns (address)
1119     {
1120         return _delegates[delegator];
1121     }
1122 
1123    /**
1124     * @notice Delegate votes from `msg.sender` to `delegatee`
1125     * @param delegatee The address to delegate votes to
1126     */
1127     function delegate(address delegatee) external {
1128         return _delegate(msg.sender, delegatee);
1129     }
1130 
1131     /**
1132      * @notice Delegates votes from signatory to `delegatee`
1133      * @param delegatee The address to delegate votes to
1134      * @param nonce The contract state required to match the signature
1135      * @param expiry The time at which to expire the signature
1136      * @param v The recovery byte of the signature
1137      * @param r Half of the ECDSA signature pair
1138      * @param s Half of the ECDSA signature pair
1139      */
1140     function delegateBySig(
1141         address delegatee,
1142         uint nonce,
1143         uint expiry,
1144         uint8 v,
1145         bytes32 r,
1146         bytes32 s
1147     )
1148         external
1149     {
1150         bytes32 domainSeparator = keccak256(
1151             abi.encode(
1152                 DOMAIN_TYPEHASH,
1153                 keccak256(bytes(name())),
1154                 getChainId(),
1155                 address(this)
1156             )
1157         );
1158 
1159         bytes32 structHash = keccak256(
1160             abi.encode(
1161                 DELEGATION_TYPEHASH,
1162                 delegatee,
1163                 nonce,
1164                 expiry
1165             )
1166         );
1167 
1168         bytes32 digest = keccak256(
1169             abi.encodePacked(
1170                 "\x19\x01",
1171                 domainSeparator,
1172                 structHash
1173             )
1174         );
1175 
1176         address signatory = ecrecover(digest, v, r, s);
1177         require(signatory != address(0), "UniSushiToken::delegateBySig: invalid signature");
1178         require(nonce == nonces[signatory]++, "UniSushiToken::delegateBySig: invalid nonce");
1179         require(now <= expiry, "UniSushiToken::delegateBySig: signature expired");
1180         return _delegate(signatory, delegatee);
1181     }
1182 
1183     /**
1184      * @notice Gets the current votes balance for `account`
1185      * @param account The address to get votes balance
1186      * @return The number of current votes for `account`
1187      */
1188     function getCurrentVotes(address account)
1189         external
1190         view
1191         returns (uint256)
1192     {
1193         uint32 nCheckpoints = numCheckpoints[account];
1194         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1195     }
1196 
1197     /**
1198      * @notice Determine the prior number of votes for an account as of a block number
1199      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1200      * @param account The address of the account to check
1201      * @param blockNumber The block number to get the vote balance at
1202      * @return The number of votes the account had as of the given block
1203      */
1204     function getPriorVotes(address account, uint blockNumber)
1205         external
1206         view
1207         returns (uint256)
1208     {
1209         require(blockNumber < block.number, "UniSushiToken::getPriorVotes: not yet determined");
1210 
1211         uint32 nCheckpoints = numCheckpoints[account];
1212         if (nCheckpoints == 0) {
1213             return 0;
1214         }
1215         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1216             return checkpoints[account][nCheckpoints - 1].votes;
1217         }
1218         if (checkpoints[account][0].fromBlock > blockNumber) {
1219             return 0;
1220         }
1221 
1222         uint32 lower = 0;
1223         uint32 upper = nCheckpoints - 1;
1224         while (upper > lower) {
1225             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1226             Checkpoint memory cp = checkpoints[account][center];
1227             if (cp.fromBlock == blockNumber) {
1228                 return cp.votes;
1229             } else if (cp.fromBlock < blockNumber) {
1230                 lower = center;
1231             } else {
1232                 upper = center - 1;
1233             }
1234         }
1235         return checkpoints[account][lower].votes;
1236     }
1237 
1238     function _delegate(address delegator, address delegatee)
1239         internal
1240     {
1241         address currentDelegate = _delegates[delegator];
1242         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying UniSushiToken (not scaled);
1243         _delegates[delegator] = delegatee;
1244         emit DelegateChanged(delegator, currentDelegate, delegatee);
1245         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1246     }
1247 
1248     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1249         if (srcRep != dstRep && amount > 0) {
1250             if (srcRep != address(0)) {
1251                 // decrease old representative
1252                 uint32 srcRepNum = numCheckpoints[srcRep];
1253                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1254                 uint256 srcRepNew = srcRepOld.sub(amount);
1255                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1256             }
1257             if (dstRep != address(0)) {
1258                 // increase new representative
1259                 uint32 dstRepNum = numCheckpoints[dstRep];
1260                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1261                 uint256 dstRepNew = dstRepOld.add(amount);
1262                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1263             }
1264         }
1265     }
1266 
1267     function _writeCheckpoint(
1268         address delegatee,
1269         uint32 nCheckpoints,
1270         uint256 oldVotes,
1271         uint256 newVotes
1272     )
1273         internal
1274     {
1275         uint32 blockNumber = safe32(block.number, "UniSushi::_writeCheckpoint: block number exceeds 32 bits");
1276         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1277             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1278         } else {
1279             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1280             numCheckpoints[delegatee] = nCheckpoints + 1;
1281         }
1282         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1283     }
1284 
1285     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1286         require(n < 2**32, errorMessage);
1287         return uint32(n);
1288     }
1289 
1290     function getChainId() internal pure returns (uint) {
1291         uint256 chainId;
1292         assembly { chainId := chainid() }
1293         return chainId;
1294     }
1295 }
1296 
1297 // File: contracts/Unifier.sol
1298 pragma solidity 0.6.12;
1299 interface IMigratorChef {
1300     function migrate(IERC20 token) external returns (IERC20);
1301 }
1302 
1303 // Unifier is the master of UniSushiToken. He can make UniSushiToken and he is a fair peaceful guy.
1304 // Note that it's ownable and the owner wields tremendous power. The ownership will be transferred to a governance smart contract once UniSushiToken is sufficiently distributed and the community can show to govern itself.
1305 contract Unifier is Ownable {
1306     using SafeMath for uint256;
1307     using SafeERC20 for IERC20;
1308     // Info of each user.
1309     struct UserInfo {
1310         uint256 amount;     // How many LP tokens the user has provided.
1311         uint256 rewardDebt; // Reward debt. See explanation below.
1312     }
1313 
1314     struct PoolInfo {
1315         IERC20 lpToken;           // Address of LP token contract.
1316         uint256 allocPoint;       // How many allocation points assigned to this pool. UniSushi to distribute per block.
1317         uint256 lastRewardBlock;  // Last block number that UniSushi distribution occurs.
1318         uint256 accUniSushiPerShare; // Accumulated UniSushi per share, times 1e12. See below.
1319     }
1320 
1321     // The UniSushi TOKEN!
1322     UniSushiToken public unisushi;
1323     // Dev address.
1324     address public devaddr;
1325     // Block number when bonus UniSushi period ends.
1326     uint256 public bonusEndBlock;
1327     // unisushi tokens created per block.
1328     uint256 public unisushiPerBlock;
1329     // Bonus muliplier for early UniSushi makers.
1330     uint256 public BONUS_MULTIPLIER = 3;
1331     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1332     IMigratorChef public migrator;
1333 
1334     // Info of each pool.
1335     PoolInfo[] public poolInfo;
1336     // Info of each user that stakes LP tokens.
1337     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1338     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1339     uint256 public totalAllocPoint = 0;
1340     // The block number when UniSushi mining starts.
1341     uint256 public startBlock;
1342 
1343     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1344     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1345     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1346 
1347     constructor(
1348         UniSushiToken _unisushi,
1349         address _devaddr,
1350         uint256 _startBlock,
1351         uint256 _bonusEndBlock
1352     ) public {
1353         unisushi = _unisushi;
1354         devaddr = _devaddr;
1355         unisushiPerBlock = 10000000000000000000; // 10unisushi /Block
1356         bonusEndBlock = _bonusEndBlock;
1357         startBlock = _startBlock;
1358     }
1359 
1360     function changeReward(uint256 _unisushiPerBlock) public onlyOwner {
1361         unisushiPerBlock = _unisushiPerBlock;
1362     }
1363 
1364     function changeStartBlock(uint256 _startBlock) public onlyOwner {
1365         startBlock = _startBlock;
1366     }
1367     function changeBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1368         bonusEndBlock = _bonusEndBlock;
1369     }
1370     function changeBonusMultiplier(uint256 _bonusMultiplier) public onlyOwner {
1371         BONUS_MULTIPLIER = _bonusMultiplier;
1372     }
1373 
1374     function poolLength() external view returns (uint256) {
1375         return poolInfo.length;
1376     }
1377 
1378     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1379         if (_withUpdate) {
1380             massUpdatePools();
1381         }
1382         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1383         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1384         poolInfo.push(PoolInfo({
1385             lpToken: _lpToken,
1386             allocPoint: _allocPoint,
1387             lastRewardBlock: lastRewardBlock,
1388             accUniSushiPerShare: 0
1389         }));
1390     }
1391 
1392     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1393         if (_withUpdate) {
1394             massUpdatePools();
1395         }
1396         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1397         poolInfo[_pid].allocPoint = _allocPoint;
1398     }
1399 
1400     // Set the migrator contract. Can only be called by the owner.
1401     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1402         migrator = _migrator;
1403     }
1404 
1405     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1406     function migrate(uint256 _pid) public {
1407         require(address(migrator) != address(0), "migrate: no migrator");
1408         PoolInfo storage pool = poolInfo[_pid];
1409         IERC20 lpToken = pool.lpToken;
1410         uint256 bal = lpToken.balanceOf(address(this));
1411         lpToken.safeApprove(address(migrator), bal);
1412         IERC20 newLpToken = migrator.migrate(lpToken);
1413         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1414         pool.lpToken = newLpToken;
1415     }
1416 
1417     // Return reward multiplier over the given _from to _to block.
1418     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1419         if (_to <= bonusEndBlock) {
1420             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1421         } else if (_from >= bonusEndBlock) {
1422             return _to.sub(_from);
1423         } else {
1424             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1425                 _to.sub(bonusEndBlock)
1426             );
1427         }
1428     }
1429 
1430     // View function to see pending UniSushi on frontend.
1431     function pendingUniSushi(uint256 _pid, address _user) external view returns (uint256) {
1432         PoolInfo storage pool = poolInfo[_pid];
1433         UserInfo storage user = userInfo[_pid][_user];
1434         uint256 accUniSushiPerShare = pool.accUniSushiPerShare;
1435         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1436         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1437             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1438             uint256 unisushiReward = multiplier.mul(unisushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1439             accUniSushiPerShare = accUniSushiPerShare.add(unisushiReward.mul(1e12).div(lpSupply));
1440         }
1441         return user.amount.mul(accUniSushiPerShare).div(1e12).sub(user.rewardDebt);
1442     }
1443 
1444     // Update reward variables for all pools. Be careful of gas spending!
1445     function massUpdatePools() public {
1446         uint256 length = poolInfo.length;
1447         for (uint256 pid = 0; pid < length; ++pid) {
1448             updatePool(pid);
1449         }
1450     }
1451 
1452     // Update reward variables of the given pool to be up-to-date.
1453     function updatePool(uint256 _pid) public {
1454         PoolInfo storage pool = poolInfo[_pid];
1455         if (block.number <= pool.lastRewardBlock) {
1456             return;
1457         }
1458         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1459         if (lpSupply == 0) {
1460             pool.lastRewardBlock = block.number;
1461             return;
1462         }
1463         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1464         uint256 unisushiReward = multiplier.mul(unisushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1465         unisushi.mint(devaddr, unisushiReward.div(20));
1466         unisushi.mint(address(this), unisushiReward);
1467         pool.accUniSushiPerShare = pool.accUniSushiPerShare.add(unisushiReward.mul(1e12).div(lpSupply));
1468         pool.lastRewardBlock = block.number;
1469     }
1470 
1471     function deposit(uint256 _pid, uint256 _amount) public {
1472         PoolInfo storage pool = poolInfo[_pid];
1473         UserInfo storage user = userInfo[_pid][msg.sender];
1474         updatePool(_pid);
1475         if (user.amount > 0) {
1476             uint256 pending = user.amount.mul(pool.accUniSushiPerShare).div(1e12).sub(user.rewardDebt);
1477             if(pending > 0) {
1478                 safeUniSushiTransfer(msg.sender, pending);
1479             }
1480         }
1481         if(_amount > 0) {
1482             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1483             user.amount = user.amount.add(_amount);
1484         }
1485         user.rewardDebt = user.amount.mul(pool.accUniSushiPerShare).div(1e12);
1486         emit Deposit(msg.sender, _pid, _amount);
1487     }
1488 
1489     // Withdraw LP tokens from Unifier.
1490     function withdraw(uint256 _pid, uint256 _amount) public {
1491         PoolInfo storage pool = poolInfo[_pid];
1492         UserInfo storage user = userInfo[_pid][msg.sender];
1493         require(user.amount >= _amount, "withdraw: not good");
1494         updatePool(_pid);
1495         uint256 pending = user.amount.mul(pool.accUniSushiPerShare).div(1e12).sub(user.rewardDebt);
1496         if(pending > 0) {
1497             safeUniSushiTransfer(msg.sender, pending);
1498         }
1499         if(_amount > 0) {
1500             user.amount = user.amount.sub(_amount);
1501             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1502         }
1503         user.rewardDebt = user.amount.mul(pool.accUniSushiPerShare).div(1e12);
1504         emit Withdraw(msg.sender, _pid, _amount);
1505     }
1506 
1507     // Withdraw without caring about rewards. EMERGENCY ONLY.
1508     function emergencyWithdraw(uint256 _pid) public {
1509         PoolInfo storage pool = poolInfo[_pid];
1510         UserInfo storage user = userInfo[_pid][msg.sender];
1511         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1512         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1513         user.amount = 0;
1514         user.rewardDebt = 0;
1515     }
1516 
1517     // Safe UniSushi transfer function, just in case if rounding error causes pool to not have enough unisushi.
1518     function safeUniSushiTransfer(address _to, uint256 _amount) internal {
1519         uint256 unisushiBal = unisushi.balanceOf(address(this));
1520         if (_amount > unisushiBal) {
1521             unisushi.transfer(_to, unisushiBal);
1522         } else {
1523             unisushi.transfer(_to, _amount);
1524         }
1525     }
1526 
1527     // Update dev address by the previous dev.
1528     function dev(address _devaddr) public {
1529         require(msg.sender == devaddr, "dev: wut?");
1530         devaddr = _devaddr;
1531     }
1532 }