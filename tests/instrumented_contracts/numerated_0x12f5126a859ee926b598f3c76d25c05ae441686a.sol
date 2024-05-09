1 // SPDX-License-Identifier: MIT
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
80 pragma solidity ^0.6.0;
81 
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
238 
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
379 
380 pragma solidity ^0.6.0;
381 
382 
383 
384 
385 /**
386  * @title SafeERC20
387  * @dev Wrappers around ERC20 operations that throw on failure (when the token
388  * contract returns false). Tokens that return no value (and instead revert or
389  * throw on failure) are also supported, non-reverting calls are assumed to be
390  * successful.
391  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
392  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
393  */
394 library SafeERC20 {
395     using SafeMath for uint256;
396     using Address for address;
397 
398     function safeTransfer(IERC20 token, address to, uint256 value) internal {
399         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
400     }
401 
402     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
403         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
404     }
405 
406     /**
407      * @dev Deprecated. This function has issues similar to the ones found in
408      * {IERC20-approve}, and its usage is discouraged.
409      *
410      * Whenever possible, use {safeIncreaseAllowance} and
411      * {safeDecreaseAllowance} instead.
412      */
413     function safeApprove(IERC20 token, address spender, uint256 value) internal {
414         // safeApprove should only be called when setting an initial allowance,
415         // or when resetting it to zero. To increase and decrease it, use
416         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
417         // solhint-disable-next-line max-line-length
418         require((value == 0) || (token.allowance(address(this), spender) == 0),
419             "SafeERC20: approve from non-zero to non-zero allowance"
420         );
421         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
422     }
423 
424     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
425         uint256 newAllowance = token.allowance(address(this), spender).add(value);
426         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
427     }
428 
429     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
430         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
432     }
433 
434     /**
435      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
436      * on the return value: the return value is optional (but if data is returned, it must not be false).
437      * @param token The token targeted by the call.
438      * @param data The call data (encoded using abi.encode or one of its variants).
439      */
440     function _callOptionalReturn(IERC20 token, bytes memory data) private {
441         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
442         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
443         // the target address contains contract code and also asserts for success in the low-level call.
444 
445         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
446         if (returndata.length > 0) { // Return data is optional
447             // solhint-disable-next-line max-line-length
448             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
449         }
450     }
451 }
452 
453 
454 pragma solidity ^0.6.0;
455 
456 /**
457  * @dev Library for managing
458  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
459  * types.
460  *
461  * Sets have the following properties:
462  *
463  * - Elements are added, removed, and checked for existence in constant time
464  * (O(1)).
465  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
466  *
467  * ```
468  * contract Example {
469  *     // Add the library methods
470  *     using EnumerableSet for EnumerableSet.AddressSet;
471  *
472  *     // Declare a set state variable
473  *     EnumerableSet.AddressSet private mySet;
474  * }
475  * ```
476  *
477  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
478  * (`UintSet`) are supported.
479  */
480 library EnumerableSet {
481     // To implement this library for multiple types with as little code
482     // repetition as possible, we write it in terms of a generic Set type with
483     // bytes32 values.
484     // The Set implementation uses private functions, and user-facing
485     // implementations (such as AddressSet) are just wrappers around the
486     // underlying Set.
487     // This means that we can only create new EnumerableSets for types that fit
488     // in bytes32.
489 
490     struct Set {
491         // Storage of set values
492         bytes32[] _values;
493 
494         // Position of the value in the `values` array, plus 1 because index 0
495         // means a value is not in the set.
496         mapping (bytes32 => uint256) _indexes;
497     }
498 
499     /**
500      * @dev Add a value to a set. O(1).
501      *
502      * Returns true if the value was added to the set, that is if it was not
503      * already present.
504      */
505     function _add(Set storage set, bytes32 value) private returns (bool) {
506         if (!_contains(set, value)) {
507             set._values.push(value);
508             // The value is stored at length-1, but we add 1 to all indexes
509             // and use 0 as a sentinel value
510             set._indexes[value] = set._values.length;
511             return true;
512         } else {
513             return false;
514         }
515     }
516 
517     /**
518      * @dev Removes a value from a set. O(1).
519      *
520      * Returns true if the value was removed from the set, that is if it was
521      * present.
522      */
523     function _remove(Set storage set, bytes32 value) private returns (bool) {
524         // We read and store the value's index to prevent multiple reads from the same storage slot
525         uint256 valueIndex = set._indexes[value];
526 
527         if (valueIndex != 0) { // Equivalent to contains(set, value)
528             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
529             // the array, and then remove the last element (sometimes called as 'swap and pop').
530             // This modifies the order of the array, as noted in {at}.
531 
532             uint256 toDeleteIndex = valueIndex - 1;
533             uint256 lastIndex = set._values.length - 1;
534 
535             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
536             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
537 
538             bytes32 lastvalue = set._values[lastIndex];
539 
540             // Move the last value to the index where the value to delete is
541             set._values[toDeleteIndex] = lastvalue;
542             // Update the index for the moved value
543             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
544 
545             // Delete the slot where the moved value was stored
546             set._values.pop();
547 
548             // Delete the index for the deleted slot
549             delete set._indexes[value];
550 
551             return true;
552         } else {
553             return false;
554         }
555     }
556 
557     /**
558      * @dev Returns true if the value is in the set. O(1).
559      */
560     function _contains(Set storage set, bytes32 value) private view returns (bool) {
561         return set._indexes[value] != 0;
562     }
563 
564     /**
565      * @dev Returns the number of values on the set. O(1).
566      */
567     function _length(Set storage set) private view returns (uint256) {
568         return set._values.length;
569     }
570 
571    /**
572     * @dev Returns the value stored at position `index` in the set. O(1).
573     *
574     * Note that there are no guarantees on the ordering of values inside the
575     * array, and it may change when more values are added or removed.
576     *
577     * Requirements:
578     *
579     * - `index` must be strictly less than {length}.
580     */
581     function _at(Set storage set, uint256 index) private view returns (bytes32) {
582         require(set._values.length > index, "EnumerableSet: index out of bounds");
583         return set._values[index];
584     }
585 
586     // AddressSet
587 
588     struct AddressSet {
589         Set _inner;
590     }
591 
592     /**
593      * @dev Add a value to a set. O(1).
594      *
595      * Returns true if the value was added to the set, that is if it was not
596      * already present.
597      */
598     function add(AddressSet storage set, address value) internal returns (bool) {
599         return _add(set._inner, bytes32(uint256(value)));
600     }
601 
602     /**
603      * @dev Removes a value from a set. O(1).
604      *
605      * Returns true if the value was removed from the set, that is if it was
606      * present.
607      */
608     function remove(AddressSet storage set, address value) internal returns (bool) {
609         return _remove(set._inner, bytes32(uint256(value)));
610     }
611 
612     /**
613      * @dev Returns true if the value is in the set. O(1).
614      */
615     function contains(AddressSet storage set, address value) internal view returns (bool) {
616         return _contains(set._inner, bytes32(uint256(value)));
617     }
618 
619     /**
620      * @dev Returns the number of values in the set. O(1).
621      */
622     function length(AddressSet storage set) internal view returns (uint256) {
623         return _length(set._inner);
624     }
625 
626    /**
627     * @dev Returns the value stored at position `index` in the set. O(1).
628     *
629     * Note that there are no guarantees on the ordering of values inside the
630     * array, and it may change when more values are added or removed.
631     *
632     * Requirements:
633     *
634     * - `index` must be strictly less than {length}.
635     */
636     function at(AddressSet storage set, uint256 index) internal view returns (address) {
637         return address(uint256(_at(set._inner, index)));
638     }
639 
640 
641     // UintSet
642 
643     struct UintSet {
644         Set _inner;
645     }
646 
647     /**
648      * @dev Add a value to a set. O(1).
649      *
650      * Returns true if the value was added to the set, that is if it was not
651      * already present.
652      */
653     function add(UintSet storage set, uint256 value) internal returns (bool) {
654         return _add(set._inner, bytes32(value));
655     }
656 
657     /**
658      * @dev Removes a value from a set. O(1).
659      *
660      * Returns true if the value was removed from the set, that is if it was
661      * present.
662      */
663     function remove(UintSet storage set, uint256 value) internal returns (bool) {
664         return _remove(set._inner, bytes32(value));
665     }
666 
667     /**
668      * @dev Returns true if the value is in the set. O(1).
669      */
670     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
671         return _contains(set._inner, bytes32(value));
672     }
673 
674     /**
675      * @dev Returns the number of values on the set. O(1).
676      */
677     function length(UintSet storage set) internal view returns (uint256) {
678         return _length(set._inner);
679     }
680 
681    /**
682     * @dev Returns the value stored at position `index` in the set. O(1).
683     *
684     * Note that there are no guarantees on the ordering of values inside the
685     * array, and it may change when more values are added or removed.
686     *
687     * Requirements:
688     *
689     * - `index` must be strictly less than {length}.
690     */
691     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
692         return uint256(_at(set._inner, index));
693     }
694 }
695 
696 
697 pragma solidity ^0.6.0;
698 
699 /*
700  * @dev Provides information about the current execution context, including the
701  * sender of the transaction and its data. While these are generally available
702  * via msg.sender and msg.data, they should not be accessed in such a direct
703  * manner, since when dealing with GSN meta-transactions the account sending and
704  * paying for execution may not be the actual sender (as far as an application
705  * is concerned).
706  *
707  * This contract is only required for intermediate, library-like contracts.
708  */
709 abstract contract Context {
710     function _msgSender() internal view virtual returns (address payable) {
711         return msg.sender;
712     }
713 
714     function _msgData() internal view virtual returns (bytes memory) {
715         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
716         return msg.data;
717     }
718 }
719 
720 
721 pragma solidity ^0.6.0;
722 
723 /**
724  * @dev Contract module which provides a basic access control mechanism, where
725  * there is an account (an owner) that can be granted exclusive access to
726  * specific functions.
727  *
728  * By default, the owner account will be the one that deploys the contract. This
729  * can later be changed with {transferOwnership}.
730  *
731  * This module is used through inheritance. It will make available the modifier
732  * `onlyOwner`, which can be applied to your functions to restrict their use to
733  * the owner.
734  */
735 contract Ownable is Context {
736     address private _owner;
737 
738     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
739 
740     /**
741      * @dev Initializes the contract setting the deployer as the initial owner.
742      */
743     constructor () internal {
744         address msgSender = _msgSender();
745         _owner = msgSender;
746         emit OwnershipTransferred(address(0), msgSender);
747     }
748 
749     /**
750      * @dev Returns the address of the current owner.
751      */
752     function owner() public view returns (address) {
753         return _owner;
754     }
755 
756     /**
757      * @dev Throws if called by any account other than the owner.
758      */
759     modifier onlyOwner() {
760         require(_owner == _msgSender(), "Ownable: caller is not the owner");
761         _;
762     }
763 
764     /**
765      * @dev Leaves the contract without owner. It will not be possible to call
766      * `onlyOwner` functions anymore. Can only be called by the current owner.
767      *
768      * NOTE: Renouncing ownership will leave the contract without an owner,
769      * thereby removing any functionality that is only available to the owner.
770      */
771     function renounceOwnership() public virtual onlyOwner {
772         emit OwnershipTransferred(_owner, address(0));
773         _owner = address(0);
774     }
775 
776     /**
777      * @dev Transfers ownership of the contract to a new account (`newOwner`).
778      * Can only be called by the current owner.
779      */
780     function transferOwnership(address newOwner) public virtual onlyOwner {
781         require(newOwner != address(0), "Ownable: new owner is the zero address");
782         emit OwnershipTransferred(_owner, newOwner);
783         _owner = newOwner;
784     }
785 }
786 
787 
788 pragma solidity ^0.6.0;
789 
790 
791 
792 
793 
794 /**
795  * @dev Implementation of the {IERC20} interface.
796  *
797  * This implementation is agnostic to the way tokens are created. This means
798  * that a supply mechanism has to be added in a derived contract using {_mint}.
799  * For a generic mechanism see {ERC20PresetMinterPauser}.
800  *
801  * TIP: For a detailed writeup see our guide
802  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
803  * to implement supply mechanisms].
804  *
805  * We have followed general OpenZeppelin guidelines: functions revert instead
806  * of returning `false` on failure. This behavior is nonetheless conventional
807  * and does not conflict with the expectations of ERC20 applications.
808  *
809  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
810  * This allows applications to reconstruct the allowance for all accounts just
811  * by listening to said events. Other implementations of the EIP may not emit
812  * these events, as it isn't required by the specification.
813  *
814  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
815  * functions have been added to mitigate the well-known issues around setting
816  * allowances. See {IERC20-approve}.
817  */
818 contract ERC20 is Context, IERC20 {
819     using SafeMath for uint256;
820     using Address for address;
821 
822     mapping (address => uint256) private _balances;
823 
824     mapping (address => mapping (address => uint256)) private _allowances;
825 
826     uint256 private _totalSupply;
827 
828     string private _name;
829     string private _symbol;
830     uint8 private _decimals;
831 
832     /**
833      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
834      * a default value of 18.
835      *
836      * To select a different value for {decimals}, use {_setupDecimals}.
837      *
838      * All three of these values are immutable: they can only be set once during
839      * construction.
840      */
841     constructor (string memory name, string memory symbol) public {
842         _name = name;
843         _symbol = symbol;
844         _decimals = 18;
845     }
846 
847     /**
848      * @dev Returns the name of the token.
849      */
850     function name() public view returns (string memory) {
851         return _name;
852     }
853 
854     /**
855      * @dev Returns the symbol of the token, usually a shorter version of the
856      * name.
857      */
858     function symbol() public view returns (string memory) {
859         return _symbol;
860     }
861 
862     /**
863      * @dev Returns the number of decimals used to get its user representation.
864      * For example, if `decimals` equals `2`, a balance of `505` tokens should
865      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
866      *
867      * Tokens usually opt for a value of 18, imitating the relationship between
868      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
869      * called.
870      *
871      * NOTE: This information is only used for _display_ purposes: it in
872      * no way affects any of the arithmetic of the contract, including
873      * {IERC20-balanceOf} and {IERC20-transfer}.
874      */
875     function decimals() public view returns (uint8) {
876         return _decimals;
877     }
878 
879     /**
880      * @dev See {IERC20-totalSupply}.
881      */
882     function totalSupply() public view override returns (uint256) {
883         return _totalSupply;
884     }
885 
886     /**
887      * @dev See {IERC20-balanceOf}.
888      */
889     function balanceOf(address account) public view override returns (uint256) {
890         return _balances[account];
891     }
892 
893     /**
894      * @dev See {IERC20-transfer}.
895      *
896      * Requirements:
897      *
898      * - `recipient` cannot be the zero address.
899      * - the caller must have a balance of at least `amount`.
900      */
901     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
902         _transfer(_msgSender(), recipient, amount);
903         return true;
904     }
905 
906     /**
907      * @dev See {IERC20-allowance}.
908      */
909     function allowance(address owner, address spender) public view virtual override returns (uint256) {
910         return _allowances[owner][spender];
911     }
912 
913     /**
914      * @dev See {IERC20-approve}.
915      *
916      * Requirements:
917      *
918      * - `spender` cannot be the zero address.
919      */
920     function approve(address spender, uint256 amount) public virtual override returns (bool) {
921         _approve(_msgSender(), spender, amount);
922         return true;
923     }
924 
925     /**
926      * @dev See {IERC20-transferFrom}.
927      *
928      * Emits an {Approval} event indicating the updated allowance. This is not
929      * required by the EIP. See the note at the beginning of {ERC20};
930      *
931      * Requirements:
932      * - `sender` and `recipient` cannot be the zero address.
933      * - `sender` must have a balance of at least `amount`.
934      * - the caller must have allowance for ``sender``'s tokens of at least
935      * `amount`.
936      */
937     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
938         _transfer(sender, recipient, amount);
939         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
940         return true;
941     }
942 
943     /**
944      * @dev Atomically increases the allowance granted to `spender` by the caller.
945      *
946      * This is an alternative to {approve} that can be used as a mitigation for
947      * problems described in {IERC20-approve}.
948      *
949      * Emits an {Approval} event indicating the updated allowance.
950      *
951      * Requirements:
952      *
953      * - `spender` cannot be the zero address.
954      */
955     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
956         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
957         return true;
958     }
959 
960     /**
961      * @dev Atomically decreases the allowance granted to `spender` by the caller.
962      *
963      * This is an alternative to {approve} that can be used as a mitigation for
964      * problems described in {IERC20-approve}.
965      *
966      * Emits an {Approval} event indicating the updated allowance.
967      *
968      * Requirements:
969      *
970      * - `spender` cannot be the zero address.
971      * - `spender` must have allowance for the caller of at least
972      * `subtractedValue`.
973      */
974     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
975         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
976         return true;
977     }
978 
979     /**
980      * @dev Moves tokens `amount` from `sender` to `recipient`.
981      *
982      * This is internal function is equivalent to {transfer}, and can be used to
983      * e.g. implement automatic token fees, slashing mechanisms, etc.
984      *
985      * Emits a {Transfer} event.
986      *
987      * Requirements:
988      *
989      * - `sender` cannot be the zero address.
990      * - `recipient` cannot be the zero address.
991      * - `sender` must have a balance of at least `amount`.
992      */
993     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
994         require(sender != address(0), "ERC20: transfer from the zero address");
995         require(recipient != address(0), "ERC20: transfer to the zero address");
996 
997         _beforeTokenTransfer(sender, recipient, amount);
998 
999         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1000         _balances[recipient] = _balances[recipient].add(amount);
1001         emit Transfer(sender, recipient, amount);
1002     }
1003 
1004     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1005      * the total supply.
1006      *
1007      * Emits a {Transfer} event with `from` set to the zero address.
1008      *
1009      * Requirements
1010      *
1011      * - `to` cannot be the zero address.
1012      */
1013     function _mint(address account, uint256 amount) internal virtual {
1014         require(account != address(0), "ERC20: mint to the zero address");
1015 
1016         _beforeTokenTransfer(address(0), account, amount);
1017 
1018         _totalSupply = _totalSupply.add(amount);
1019         _balances[account] = _balances[account].add(amount);
1020         emit Transfer(address(0), account, amount);
1021     }
1022 
1023     /**
1024      * @dev Destroys `amount` tokens from `account`, reducing the
1025      * total supply.
1026      *
1027      * Emits a {Transfer} event with `to` set to the zero address.
1028      *
1029      * Requirements
1030      *
1031      * - `account` cannot be the zero address.
1032      * - `account` must have at least `amount` tokens.
1033      */
1034     function _burn(address account, uint256 amount) internal virtual {
1035         require(account != address(0), "ERC20: burn from the zero address");
1036 
1037         _beforeTokenTransfer(account, address(0), amount);
1038 
1039         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1040         _totalSupply = _totalSupply.sub(amount);
1041         emit Transfer(account, address(0), amount);
1042     }
1043 
1044     /**
1045      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1046      *
1047      * This is internal function is equivalent to `approve`, and can be used to
1048      * e.g. set automatic allowances for certain subsystems, etc.
1049      *
1050      * Emits an {Approval} event.
1051      *
1052      * Requirements:
1053      *
1054      * - `owner` cannot be the zero address.
1055      * - `spender` cannot be the zero address.
1056      */
1057     function _approve(address owner, address spender, uint256 amount) internal virtual {
1058         require(owner != address(0), "ERC20: approve from the zero address");
1059         require(spender != address(0), "ERC20: approve to the zero address");
1060 
1061         _allowances[owner][spender] = amount;
1062         emit Approval(owner, spender, amount);
1063     }
1064 
1065     /**
1066      * @dev Sets {decimals} to a value other than the default one of 18.
1067      *
1068      * WARNING: This function should only be called from the constructor. Most
1069      * applications that interact with token contracts will not expect
1070      * {decimals} to ever change, and may work incorrectly if it does.
1071      */
1072     function _setupDecimals(uint8 decimals_) internal {
1073         _decimals = decimals_;
1074     }
1075 
1076     /**
1077      * @dev Hook that is called before any transfer of tokens. This includes
1078      * minting and burning.
1079      *
1080      * Calling conditions:
1081      *
1082      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1083      * will be to transferred to `to`.
1084      * - when `from` is zero, `amount` tokens will be minted for `to`.
1085      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1086      * - `from` and `to` are never both zero.
1087      *
1088      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1089      */
1090     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1091 }
1092 
1093 // File: contracts/NekoToken.sol
1094 
1095 pragma solidity 0.6.12;
1096 
1097 
1098 
1099 // NekoToken with Governance.
1100 contract NekoToken is ERC20("NekoToken", "NEKO"), Ownable {
1101     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1102     function mint(address _to, uint256 _amount) public onlyOwner {
1103         _mint(_to, _amount);
1104         _moveDelegates(address(0), _delegates[_to], _amount);
1105     }
1106 
1107     // Copied and modified from YAM code:
1108     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1109     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1110     // Which is copied and modified from COMPOUND:
1111     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1112 
1113     /// @notice A record of each accounts delegate
1114     mapping(address => address) internal _delegates;
1115 
1116     /// @notice A checkpoint for marking number of votes from a given block
1117     struct Checkpoint {
1118         uint32 fromBlock;
1119         uint256 votes;
1120     }
1121 
1122     /// @notice A record of votes checkpoints for each account, by index
1123     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1124 
1125     /// @notice The number of checkpoints for each account
1126     mapping(address => uint32) public numCheckpoints;
1127 
1128     /// @notice The EIP-712 typehash for the contract's domain
1129     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
1130         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
1131     );
1132 
1133     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1134     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
1135         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
1136     );
1137 
1138     /// @notice A record of states for signing / validating signatures
1139     mapping(address => uint256) public nonces;
1140 
1141     /// @notice An event thats emitted when an account changes its delegate
1142     event DelegateChanged(
1143         address indexed delegator,
1144         address indexed fromDelegate,
1145         address indexed toDelegate
1146     );
1147 
1148     /// @notice An event thats emitted when a delegate account's vote balance changes
1149     event DelegateVotesChanged(
1150         address indexed delegate,
1151         uint256 previousBalance,
1152         uint256 newBalance
1153     );
1154 
1155     /**
1156      * @notice Delegate votes from `msg.sender` to `delegatee`
1157      * @param delegator The address to get delegatee for
1158      */
1159     function delegates(address delegator) external view returns (address) {
1160         return _delegates[delegator];
1161     }
1162 
1163     /**
1164      * @notice Delegate votes from `msg.sender` to `delegatee`
1165      * @param delegatee The address to delegate votes to
1166      */
1167     function delegate(address delegatee) external {
1168         return _delegate(msg.sender, delegatee);
1169     }
1170 
1171     /**
1172      * @notice Delegates votes from signatory to `delegatee`
1173      * @param delegatee The address to delegate votes to
1174      * @param nonce The contract state required to match the signature
1175      * @param expiry The time at which to expire the signature
1176      * @param v The recovery byte of the signature
1177      * @param r Half of the ECDSA signature pair
1178      * @param s Half of the ECDSA signature pair
1179      */
1180     function delegateBySig(
1181         address delegatee,
1182         uint256 nonce,
1183         uint256 expiry,
1184         uint8 v,
1185         bytes32 r,
1186         bytes32 s
1187     ) external {
1188         bytes32 domainSeparator = keccak256(
1189             abi.encode(
1190                 DOMAIN_TYPEHASH,
1191                 keccak256(bytes(name())),
1192                 getChainId(),
1193                 address(this)
1194             )
1195         );
1196 
1197         bytes32 structHash = keccak256(
1198             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
1199         );
1200 
1201         bytes32 digest = keccak256(
1202             abi.encodePacked("\x19\x01", domainSeparator, structHash)
1203         );
1204 
1205         address signatory = ecrecover(digest, v, r, s);
1206         require(
1207             signatory != address(0),
1208             "NEKO::delegateBySig: invalid signature"
1209         );
1210         require(
1211             nonce == nonces[signatory]++,
1212             "NEKO::delegateBySig: invalid nonce"
1213         );
1214         require(now <= expiry, "NEKO::delegateBySig: signature expired");
1215         return _delegate(signatory, delegatee);
1216     }
1217 
1218     /**
1219      * @notice Gets the current votes balance for `account`
1220      * @param account The address to get votes balance
1221      * @return The number of current votes for `account`
1222      */
1223     function getCurrentVotes(address account) external view returns (uint256) {
1224         uint32 nCheckpoints = numCheckpoints[account];
1225         return
1226             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1227     }
1228 
1229     /**
1230      * @notice Determine the prior number of votes for an account as of a block number
1231      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1232      * @param account The address of the account to check
1233      * @param blockNumber The block number to get the vote balance at
1234      * @return The number of votes the account had as of the given block
1235      */
1236     function getPriorVotes(address account, uint256 blockNumber)
1237         external
1238         view
1239         returns (uint256)
1240     {
1241         require(
1242             blockNumber < block.number,
1243             "NEKO::getPriorVotes: not yet determined"
1244         );
1245 
1246         uint32 nCheckpoints = numCheckpoints[account];
1247         if (nCheckpoints == 0) {
1248             return 0;
1249         }
1250 
1251         // First check most recent balance
1252         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1253             return checkpoints[account][nCheckpoints - 1].votes;
1254         }
1255 
1256         // Next check implicit zero balance
1257         if (checkpoints[account][0].fromBlock > blockNumber) {
1258             return 0;
1259         }
1260 
1261         uint32 lower = 0;
1262         uint32 upper = nCheckpoints - 1;
1263         while (upper > lower) {
1264             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1265             Checkpoint memory cp = checkpoints[account][center];
1266             if (cp.fromBlock == blockNumber) {
1267                 return cp.votes;
1268             } else if (cp.fromBlock < blockNumber) {
1269                 lower = center;
1270             } else {
1271                 upper = center - 1;
1272             }
1273         }
1274         return checkpoints[account][lower].votes;
1275     }
1276 
1277     function _delegate(address delegator, address delegatee) internal {
1278         address currentDelegate = _delegates[delegator];
1279         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying NEKOs (not scaled);
1280         _delegates[delegator] = delegatee;
1281 
1282         emit DelegateChanged(delegator, currentDelegate, delegatee);
1283 
1284         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1285     }
1286 
1287     function _moveDelegates(
1288         address srcRep,
1289         address dstRep,
1290         uint256 amount
1291     ) internal {
1292         if (srcRep != dstRep && amount > 0) {
1293             if (srcRep != address(0)) {
1294                 // decrease old representative
1295                 uint32 srcRepNum = numCheckpoints[srcRep];
1296                 uint256 srcRepOld = srcRepNum > 0
1297                     ? checkpoints[srcRep][srcRepNum - 1].votes
1298                     : 0;
1299                 uint256 srcRepNew = srcRepOld.sub(amount);
1300                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1301             }
1302 
1303             if (dstRep != address(0)) {
1304                 // increase new representative
1305                 uint32 dstRepNum = numCheckpoints[dstRep];
1306                 uint256 dstRepOld = dstRepNum > 0
1307                     ? checkpoints[dstRep][dstRepNum - 1].votes
1308                     : 0;
1309                 uint256 dstRepNew = dstRepOld.add(amount);
1310                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1311             }
1312         }
1313     }
1314 
1315     function _writeCheckpoint(
1316         address delegatee,
1317         uint32 nCheckpoints,
1318         uint256 oldVotes,
1319         uint256 newVotes
1320     ) internal {
1321         uint32 blockNumber = safe32(
1322             block.number,
1323             "NEKO::_writeCheckpoint: block number exceeds 32 bits"
1324         );
1325 
1326         if (
1327             nCheckpoints > 0 &&
1328             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
1329         ) {
1330             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1331         } else {
1332             checkpoints[delegatee][nCheckpoints] = Checkpoint(
1333                 blockNumber,
1334                 newVotes
1335             );
1336             numCheckpoints[delegatee] = nCheckpoints + 1;
1337         }
1338 
1339         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1340     }
1341 
1342     function safe32(uint256 n, string memory errorMessage)
1343         internal
1344         pure
1345         returns (uint32)
1346     {
1347         require(n < 2**32, errorMessage);
1348         return uint32(n);
1349     }
1350 
1351     function getChainId() internal pure returns (uint256) {
1352         uint256 chainId;
1353         assembly {
1354             chainId := chainid()
1355         }
1356         return chainId;
1357     }
1358 }
1359 
1360 // File: contracts/MasterChef.sol
1361 
1362 pragma solidity 0.6.12;
1363 
1364 
1365 
1366 
1367 
1368 
1369 
1370 interface IMigratorChef {
1371     // Perform LP token migration from legacy UniswapV2 to NekoSwap.
1372     // Take the current LP token address and return the new LP token address.
1373     // Migrator should have full access to the caller's LP token.
1374     // Return the new LP token address.
1375     //
1376     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1377     // NekoSwap must mint EXACTLY the same amount of NekoSwap LP tokens or
1378     // else something bad will happen. Traditional UniswapV2 does not
1379     // do that so be careful!
1380     function migrate(IERC20 token) external returns (IERC20);
1381 }
1382 
1383 // MasterChef is the master of Neko. He can make Neko and he is a fair guy.
1384 //
1385 // Note that it's ownable and the owner wields tremendous power. The ownership
1386 // will be transferred to a governance smart contract once NEKO is sufficiently
1387 // distributed and the community can show to govern itself.
1388 //
1389 // Have fun reading it. Hopefully it's bug-free. God bless.
1390 contract MasterChef is Ownable {
1391     using SafeMath for uint256;
1392     using SafeERC20 for IERC20;
1393 
1394     // Info of each user.
1395     struct UserInfo {
1396         uint256 amount; // How many LP tokens the user has provided.
1397         uint256 rewardDebt; // Reward debt. See explanation below.
1398         //
1399         // We do some fancy math here. Basically, any point in time, the amount of NEKOs
1400         // entitled to a user but is pending to be distributed is:
1401         //
1402         //   pending reward = (user.amount * pool.accNekoPerShare) - user.rewardDebt
1403         //
1404         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1405         //   1. The pool's `accNekoPerShare` (and `lastRewardBlock`) gets updated.
1406         //   2. User receives the pending reward sent to his/her address.
1407         //   3. User's `amount` gets updated.
1408         //   4. User's `rewardDebt` gets updated.
1409     }
1410 
1411     // Info of each pool.
1412     struct PoolInfo {
1413         IERC20 lpToken; // Address of LP token contract.
1414         uint256 allocPoint; // How many allocation points assigned to this pool. NEKOs to distribute per block.
1415         uint256 lastRewardBlock; // Last block number that NEKOs distribution occurs.
1416         uint256 accNekoPerShare; // Accumulated NEKOs per share, times 1e12. See below.
1417     }
1418 
1419     // The NEKO TOKEN!
1420     NekoToken public neko;
1421     // Dev address.
1422     address public devaddr;
1423     // Block number when bonus NEKO period ends.
1424     uint256 public bonusEndBlock;
1425     // NEKO tokens created per block.
1426     uint256 public nekoPerBlock;
1427     // Bonus muliplier for early neko makers.
1428     uint256 public constant BONUS_MULTIPLIER = 50;
1429     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1430     IMigratorChef public migrator;
1431 
1432     // Info of each pool.
1433     PoolInfo[] public poolInfo;
1434     // Info of each user that stakes LP tokens.
1435     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1436     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1437     uint256 public totalAllocPoint = 0;
1438     // The block number when NEKO mining starts.
1439     uint256 public startBlock;
1440 
1441     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1442     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1443     event EmergencyWithdraw(
1444         address indexed user,
1445         uint256 indexed pid,
1446         uint256 amount
1447     );
1448 
1449     constructor(
1450         NekoToken _neko,
1451         address _devaddr,
1452         uint256 _nekoPerBlock,
1453         uint256 _startBlock,
1454         uint256 _bonusEndBlock
1455     ) public {
1456         neko = _neko;
1457         devaddr = _devaddr;
1458         nekoPerBlock = _nekoPerBlock;
1459         bonusEndBlock = _bonusEndBlock;
1460         startBlock = _startBlock;
1461     }
1462 
1463     function poolLength() external view returns (uint256) {
1464         return poolInfo.length;
1465     }
1466 
1467     // Add a new lp to the pool. Can only be called by the owner.
1468     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1469     function add(
1470         uint256 _allocPoint,
1471         IERC20 _lpToken,
1472         bool _withUpdate
1473     ) public onlyOwner {
1474         if (_withUpdate) {
1475             massUpdatePools();
1476         }
1477         uint256 lastRewardBlock = block.number > startBlock
1478             ? block.number
1479             : startBlock;
1480         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1481         poolInfo.push(
1482             PoolInfo({
1483                 lpToken: _lpToken,
1484                 allocPoint: _allocPoint,
1485                 lastRewardBlock: lastRewardBlock,
1486                 accNekoPerShare: 0
1487             })
1488         );
1489     }
1490 
1491     // Update the given pool's NEKO allocation point. Can only be called by the owner.
1492     function set(
1493         uint256 _pid,
1494         uint256 _allocPoint,
1495         bool _withUpdate
1496     ) public onlyOwner {
1497         if (_withUpdate) {
1498             massUpdatePools();
1499         }
1500         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1501             _allocPoint
1502         );
1503         poolInfo[_pid].allocPoint = _allocPoint;
1504     }
1505 
1506     // Set the migrator contract. Can only be called by the owner.
1507     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1508         migrator = _migrator;
1509     }
1510 
1511     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1512     function migrate(uint256 _pid) public {
1513         require(address(migrator) != address(0), "migrate: no migrator");
1514         PoolInfo storage pool = poolInfo[_pid];
1515         IERC20 lpToken = pool.lpToken;
1516         uint256 bal = lpToken.balanceOf(address(this));
1517         lpToken.safeApprove(address(migrator), bal);
1518         IERC20 newLpToken = migrator.migrate(lpToken);
1519         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1520         pool.lpToken = newLpToken;
1521     }
1522 
1523     // Return reward multiplier over the given _from to _to block.
1524     function getMultiplier(uint256 _from, uint256 _to)
1525         public
1526         view
1527         returns (uint256)
1528     {
1529         if (_to <= bonusEndBlock) {
1530             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1531         } else if (_from >= bonusEndBlock) {
1532             return _to.sub(_from);
1533         } else {
1534             return
1535                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1536                     _to.sub(bonusEndBlock)
1537                 );
1538         }
1539     }
1540 
1541     // View function to see pending NEKOs on frontend.
1542     function pendingNeko(uint256 _pid, address _user)
1543         external
1544         view
1545         returns (uint256)
1546     {
1547         PoolInfo storage pool = poolInfo[_pid];
1548         UserInfo storage user = userInfo[_pid][_user];
1549         uint256 accNekoPerShare = pool.accNekoPerShare;
1550         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1551         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1552             uint256 multiplier = getMultiplier(
1553                 pool.lastRewardBlock,
1554                 block.number
1555             );
1556             uint256 nekoReward = multiplier
1557                 .mul(nekoPerBlock)
1558                 .mul(pool.allocPoint)
1559                 .div(totalAllocPoint);
1560             accNekoPerShare = accNekoPerShare.add(
1561                 nekoReward.mul(1e12).div(lpSupply)
1562             );
1563         }
1564         return user.amount.mul(accNekoPerShare).div(1e12).sub(user.rewardDebt);
1565     }
1566 
1567     // Update reward vairables for all pools. Be careful of gas spending!
1568     function massUpdatePools() public {
1569         uint256 length = poolInfo.length;
1570         for (uint256 pid = 0; pid < length; ++pid) {
1571             updatePool(pid);
1572         }
1573     }
1574 
1575     // Update reward variables of the given pool to be up-to-date.
1576     function updatePool(uint256 _pid) public {
1577         PoolInfo storage pool = poolInfo[_pid];
1578         if (block.number <= pool.lastRewardBlock) {
1579             return;
1580         }
1581         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1582         if (lpSupply == 0) {
1583             pool.lastRewardBlock = block.number;
1584             return;
1585         }
1586         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1587         uint256 nekoReward = multiplier
1588             .mul(nekoPerBlock)
1589             .mul(pool.allocPoint)
1590             .div(totalAllocPoint);
1591         neko.mint(devaddr, nekoReward.div(10));
1592         neko.mint(address(this), nekoReward);
1593         pool.accNekoPerShare = pool.accNekoPerShare.add(
1594             nekoReward.mul(1e12).div(lpSupply)
1595         );
1596         pool.lastRewardBlock = block.number;
1597     }
1598 
1599     // Deposit LP tokens to MasterChef for NEKO allocation.
1600     function deposit(uint256 _pid, uint256 _amount) public {
1601         PoolInfo storage pool = poolInfo[_pid];
1602         UserInfo storage user = userInfo[_pid][msg.sender];
1603         updatePool(_pid);
1604         if (user.amount > 0) {
1605             uint256 pending = user
1606                 .amount
1607                 .mul(pool.accNekoPerShare)
1608                 .div(1e12)
1609                 .sub(user.rewardDebt);
1610             safeNekoTransfer(msg.sender, pending);
1611         }
1612         pool.lpToken.safeTransferFrom(
1613             address(msg.sender),
1614             address(this),
1615             _amount
1616         );
1617         user.amount = user.amount.add(_amount);
1618         user.rewardDebt = user.amount.mul(pool.accNekoPerShare).div(1e12);
1619         emit Deposit(msg.sender, _pid, _amount);
1620     }
1621 
1622     // Withdraw LP tokens from MasterChef.
1623     function withdraw(uint256 _pid, uint256 _amount) public {
1624         PoolInfo storage pool = poolInfo[_pid];
1625         UserInfo storage user = userInfo[_pid][msg.sender];
1626         require(user.amount >= _amount, "withdraw: not good");
1627         updatePool(_pid);
1628         uint256 pending = user.amount.mul(pool.accNekoPerShare).div(1e12).sub(
1629             user.rewardDebt
1630         );
1631         safeNekoTransfer(msg.sender, pending);
1632         user.amount = user.amount.sub(_amount);
1633         user.rewardDebt = user.amount.mul(pool.accNekoPerShare).div(1e12);
1634         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1635         emit Withdraw(msg.sender, _pid, _amount);
1636     }
1637 
1638     // Withdraw without caring about rewards. EMERGENCY ONLY.
1639     function emergencyWithdraw(uint256 _pid) public {
1640         PoolInfo storage pool = poolInfo[_pid];
1641         UserInfo storage user = userInfo[_pid][msg.sender];
1642         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1643         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1644         user.amount = 0;
1645         user.rewardDebt = 0;
1646     }
1647 
1648     // Safe neko transfer function, just in case if rounding error causes pool to not have enough NEKOs.
1649     function safeNekoTransfer(address _to, uint256 _amount) internal {
1650         uint256 nekoBal = neko.balanceOf(address(this));
1651         if (_amount > nekoBal) {
1652             neko.transfer(_to, nekoBal);
1653         } else {
1654             neko.transfer(_to, _amount);
1655         }
1656     }
1657 
1658     // Update dev address by the previous dev.
1659     function dev(address _devaddr) public {
1660         require(msg.sender == devaddr, "dev: wut?");
1661         devaddr = _devaddr;
1662     }
1663 }