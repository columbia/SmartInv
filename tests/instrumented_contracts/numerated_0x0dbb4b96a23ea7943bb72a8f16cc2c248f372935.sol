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
265         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
266         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
267         // for accounts without code, i.e. `keccak256('')`
268         bytes32 codehash;
269         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { codehash := extcodehash(account) }
272         return (codehash != accountHash && codehash != 0x0);
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
453 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
454 
455 pragma solidity ^0.6.0;
456 
457 /**
458  * @dev Library for managing
459  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
460  * types.
461  *
462  * Sets have the following properties:
463  *
464  * - Elements are added, removed, and checked for existence in constant time
465  * (O(1)).
466  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
467  *
468  * ```
469  * contract Example {
470  *     // Add the library methods
471  *     using EnumerableSet for EnumerableSet.AddressSet;
472  *
473  *     // Declare a set state variable
474  *     EnumerableSet.AddressSet private mySet;
475  * }
476  * ```
477  *
478  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
479  * (`UintSet`) are supported.
480  */
481 library EnumerableSet {
482     // To implement this library for multiple types with as little code
483     // repetition as possible, we write it in terms of a generic Set type with
484     // bytes32 values.
485     // The Set implementation uses private functions, and user-facing
486     // implementations (such as AddressSet) are just wrappers around the
487     // underlying Set.
488     // This means that we can only create new EnumerableSets for types that fit
489     // in bytes32.
490 
491     struct Set {
492         // Storage of set values
493         bytes32[] _values;
494 
495         // Position of the value in the `values` array, plus 1 because index 0
496         // means a value is not in the set.
497         mapping (bytes32 => uint256) _indexes;
498     }
499 
500     /**
501      * @dev Add a value to a set. O(1).
502      *
503      * Returns true if the value was added to the set, that is if it was not
504      * already present.
505      */
506     function _add(Set storage set, bytes32 value) private returns (bool) {
507         if (!_contains(set, value)) {
508             set._values.push(value);
509             // The value is stored at length-1, but we add 1 to all indexes
510             // and use 0 as a sentinel value
511             set._indexes[value] = set._values.length;
512             return true;
513         } else {
514             return false;
515         }
516     }
517 
518     /**
519      * @dev Removes a value from a set. O(1).
520      *
521      * Returns true if the value was removed from the set, that is if it was
522      * present.
523      */
524     function _remove(Set storage set, bytes32 value) private returns (bool) {
525         // We read and store the value's index to prevent multiple reads from the same storage slot
526         uint256 valueIndex = set._indexes[value];
527 
528         if (valueIndex != 0) { // Equivalent to contains(set, value)
529             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
530             // the array, and then remove the last element (sometimes called as 'swap and pop').
531             // This modifies the order of the array, as noted in {at}.
532 
533             uint256 toDeleteIndex = valueIndex - 1;
534             uint256 lastIndex = set._values.length - 1;
535 
536             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
537             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
538 
539             bytes32 lastvalue = set._values[lastIndex];
540 
541             // Move the last value to the index where the value to delete is
542             set._values[toDeleteIndex] = lastvalue;
543             // Update the index for the moved value
544             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
545 
546             // Delete the slot where the moved value was stored
547             set._values.pop();
548 
549             // Delete the index for the deleted slot
550             delete set._indexes[value];
551 
552             return true;
553         } else {
554             return false;
555         }
556     }
557 
558     /**
559      * @dev Returns true if the value is in the set. O(1).
560      */
561     function _contains(Set storage set, bytes32 value) private view returns (bool) {
562         return set._indexes[value] != 0;
563     }
564 
565     /**
566      * @dev Returns the number of values on the set. O(1).
567      */
568     function _length(Set storage set) private view returns (uint256) {
569         return set._values.length;
570     }
571 
572    /**
573     * @dev Returns the value stored at position `index` in the set. O(1).
574     *
575     * Note that there are no guarantees on the ordering of values inside the
576     * array, and it may change when more values are added or removed.
577     *
578     * Requirements:
579     *
580     * - `index` must be strictly less than {length}.
581     */
582     function _at(Set storage set, uint256 index) private view returns (bytes32) {
583         require(set._values.length > index, "EnumerableSet: index out of bounds");
584         return set._values[index];
585     }
586 
587     // AddressSet
588 
589     struct AddressSet {
590         Set _inner;
591     }
592 
593     /**
594      * @dev Add a value to a set. O(1).
595      *
596      * Returns true if the value was added to the set, that is if it was not
597      * already present.
598      */
599     function add(AddressSet storage set, address value) internal returns (bool) {
600         return _add(set._inner, bytes32(uint256(value)));
601     }
602 
603     /**
604      * @dev Removes a value from a set. O(1).
605      *
606      * Returns true if the value was removed from the set, that is if it was
607      * present.
608      */
609     function remove(AddressSet storage set, address value) internal returns (bool) {
610         return _remove(set._inner, bytes32(uint256(value)));
611     }
612 
613     /**
614      * @dev Returns true if the value is in the set. O(1).
615      */
616     function contains(AddressSet storage set, address value) internal view returns (bool) {
617         return _contains(set._inner, bytes32(uint256(value)));
618     }
619 
620     /**
621      * @dev Returns the number of values in the set. O(1).
622      */
623     function length(AddressSet storage set) internal view returns (uint256) {
624         return _length(set._inner);
625     }
626 
627    /**
628     * @dev Returns the value stored at position `index` in the set. O(1).
629     *
630     * Note that there are no guarantees on the ordering of values inside the
631     * array, and it may change when more values are added or removed.
632     *
633     * Requirements:
634     *
635     * - `index` must be strictly less than {length}.
636     */
637     function at(AddressSet storage set, uint256 index) internal view returns (address) {
638         return address(uint256(_at(set._inner, index)));
639     }
640 
641 
642     // UintSet
643 
644     struct UintSet {
645         Set _inner;
646     }
647 
648     /**
649      * @dev Add a value to a set. O(1).
650      *
651      * Returns true if the value was added to the set, that is if it was not
652      * already present.
653      */
654     function add(UintSet storage set, uint256 value) internal returns (bool) {
655         return _add(set._inner, bytes32(value));
656     }
657 
658     /**
659      * @dev Removes a value from a set. O(1).
660      *
661      * Returns true if the value was removed from the set, that is if it was
662      * present.
663      */
664     function remove(UintSet storage set, uint256 value) internal returns (bool) {
665         return _remove(set._inner, bytes32(value));
666     }
667 
668     /**
669      * @dev Returns true if the value is in the set. O(1).
670      */
671     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
672         return _contains(set._inner, bytes32(value));
673     }
674 
675     /**
676      * @dev Returns the number of values on the set. O(1).
677      */
678     function length(UintSet storage set) internal view returns (uint256) {
679         return _length(set._inner);
680     }
681 
682    /**
683     * @dev Returns the value stored at position `index` in the set. O(1).
684     *
685     * Note that there are no guarantees on the ordering of values inside the
686     * array, and it may change when more values are added or removed.
687     *
688     * Requirements:
689     *
690     * - `index` must be strictly less than {length}.
691     */
692     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
693         return uint256(_at(set._inner, index));
694     }
695 }
696 
697 // File: @openzeppelin/contracts/GSN/Context.sol
698 
699 
700 
701 pragma solidity ^0.6.0;
702 
703 /*
704  * @dev Provides information about the current execution context, including the
705  * sender of the transaction and its data. While these are generally available
706  * via msg.sender and msg.data, they should not be accessed in such a direct
707  * manner, since when dealing with GSN meta-transactions the account sending and
708  * paying for execution may not be the actual sender (as far as an application
709  * is concerned).
710  *
711  * This contract is only required for intermediate, library-like contracts.
712  */
713 abstract contract Context {
714     function _msgSender() internal view virtual returns (address payable) {
715         return msg.sender;
716     }
717 
718     function _msgData() internal view virtual returns (bytes memory) {
719         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
720         return msg.data;
721     }
722 }
723 
724 // File: @openzeppelin/contracts/access/Ownable.sol
725 
726 pragma solidity ^0.6.0;
727 
728 /**
729  * @dev Contract module which provides a basic access control mechanism, where
730  * there is an account (an owner) that can be granted exclusive access to
731  * specific functions.
732  *
733  * By default, the owner account will be the one that deploys the contract. This
734  * can later be changed with {transferOwnership}.
735  *
736  * This module is used through inheritance. It will make available the modifier
737  * `onlyOwner`, which can be applied to your functions to restrict their use to
738  * the owner.
739  */
740 contract Ownable is Context {
741     address private _owner;
742 
743     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
744 
745     /**
746      * @dev Initializes the contract setting the deployer as the initial owner.
747      */
748     constructor () internal {
749         address msgSender = _msgSender();
750         _owner = msgSender;
751         emit OwnershipTransferred(address(0), msgSender);
752     }
753 
754     /**
755      * @dev Returns the address of the current owner.
756      */
757     function owner() public view returns (address) {
758         return _owner;
759     }
760 
761     /**
762      * @dev Throws if called by any account other than the owner.
763      */
764     modifier onlyOwner() {
765         require(_owner == _msgSender(), "Ownable: caller is not the owner");
766         _;
767     }
768 
769     /**
770      * @dev Leaves the contract without owner. It will not be possible to call
771      * `onlyOwner` functions anymore. Can only be called by the current owner.
772      *
773      * NOTE: Renouncing ownership will leave the contract without an owner,
774      * thereby removing any functionality that is only available to the owner.
775      */
776     function renounceOwnership() public virtual onlyOwner {
777         emit OwnershipTransferred(_owner, address(0));
778         _owner = address(0);
779     }
780 
781     /**
782      * @dev Transfers ownership of the contract to a new account (`newOwner`).
783      * Can only be called by the current owner.
784      */
785     function transferOwnership(address newOwner) public virtual onlyOwner {
786         require(newOwner != address(0), "Ownable: new owner is the zero address");
787         emit OwnershipTransferred(_owner, newOwner);
788         _owner = newOwner;
789     }
790 }
791 
792 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
793 
794 pragma solidity ^0.6.0;
795 
796 /**
797  * @dev Implementation of the {IERC20} interface.
798  *
799  * This implementation is agnostic to the way tokens are created. This means
800  * that a supply mechanism has to be added in a derived contract using {_mint}.
801  * For a generic mechanism see {ERC20PresetMinterPauser}.
802  *
803  * TIP: For a detailed writeup see our guide
804  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
805  * to implement supply mechanisms].
806  *
807  * We have followed general OpenZeppelin guidelines: functions revert instead
808  * of returning `false` on failure. This behavior is nonetheless conventional
809  * and does not conflict with the expectations of ERC20 applications.
810  *
811  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
812  * This allows applications to reconstruct the allowance for all accounts just
813  * by listening to said events. Other implementations of the EIP may not emit
814  * these events, as it isn't required by the specification.
815  *
816  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
817  * functions have been added to mitigate the well-known issues around setting
818  * allowances. See {IERC20-approve}.
819  */
820 contract ERC20 is Context, IERC20 {
821     using SafeMath for uint256;
822     using Address for address;
823 
824     mapping (address => uint256) private _balances;
825 
826     mapping (address => mapping (address => uint256)) private _allowances;
827 
828     uint256 private _totalSupply;
829 
830     string private _name;
831     string private _symbol;
832     uint8 private _decimals;
833 
834     /**
835      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
836      * a default value of 18.
837      *
838      * To select a different value for {decimals}, use {_setupDecimals}.
839      *
840      * All three of these values are immutable: they can only be set once during
841      * construction.
842      */
843     constructor (string memory name, string memory symbol) public {
844         _name = name;
845         _symbol = symbol;
846         _decimals = 18;
847     }
848 
849     /**
850      * @dev Returns the name of the token.
851      */
852     function name() public view returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev Returns the symbol of the token, usually a shorter version of the
858      * name.
859      */
860     function symbol() public view returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev Returns the number of decimals used to get its user representation.
866      * For example, if `decimals` equals `2`, a balance of `505` tokens should
867      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
868      *
869      * Tokens usually opt for a value of 18, imitating the relationship between
870      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
871      * called.
872      *
873      * NOTE: This information is only used for _display_ purposes: it in
874      * no way affects any of the arithmetic of the contract, including
875      * {IERC20-balanceOf} and {IERC20-transfer}.
876      */
877     function decimals() public view returns (uint8) {
878         return _decimals;
879     }
880 
881     /**
882      * @dev See {IERC20-totalSupply}.
883      */
884     function totalSupply() public view override returns (uint256) {
885         return _totalSupply;
886     }
887 
888     /**
889      * @dev See {IERC20-balanceOf}.
890      */
891     function balanceOf(address account) public view override returns (uint256) {
892         return _balances[account];
893     }
894 
895     /**
896      * @dev See {IERC20-transfer}.
897      *
898      * Requirements:
899      *
900      * - `recipient` cannot be the zero address.
901      * - the caller must have a balance of at least `amount`.
902      */
903     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
904         _transfer(_msgSender(), recipient, amount);
905         return true;
906     }
907 
908     /**
909      * @dev See {IERC20-allowance}.
910      */
911     function allowance(address owner, address spender) public view virtual override returns (uint256) {
912         return _allowances[owner][spender];
913     }
914 
915     /**
916      * @dev See {IERC20-approve}.
917      *
918      * Requirements:
919      *
920      * - `spender` cannot be the zero address.
921      */
922     function approve(address spender, uint256 amount) public virtual override returns (bool) {
923         _approve(_msgSender(), spender, amount);
924         return true;
925     }
926 
927     /**
928      * @dev See {IERC20-transferFrom}.
929      *
930      * Emits an {Approval} event indicating the updated allowance. This is not
931      * required by the EIP. See the note at the beginning of {ERC20};
932      *
933      * Requirements:
934      * - `sender` and `recipient` cannot be the zero address.
935      * - `sender` must have a balance of at least `amount`.
936      * - the caller must have allowance for ``sender``'s tokens of at least
937      * `amount`.
938      */
939     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
940         _transfer(sender, recipient, amount);
941         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
942         return true;
943     }
944 
945     /**
946      * @dev Atomically increases the allowance granted to `spender` by the caller.
947      *
948      * This is an alternative to {approve} that can be used as a mitigation for
949      * problems described in {IERC20-approve}.
950      *
951      * Emits an {Approval} event indicating the updated allowance.
952      *
953      * Requirements:
954      *
955      * - `spender` cannot be the zero address.
956      */
957     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
958         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
959         return true;
960     }
961 
962     /**
963      * @dev Atomically decreases the allowance granted to `spender` by the caller.
964      *
965      * This is an alternative to {approve} that can be used as a mitigation for
966      * problems described in {IERC20-approve}.
967      *
968      * Emits an {Approval} event indicating the updated allowance.
969      *
970      * Requirements:
971      *
972      * - `spender` cannot be the zero address.
973      * - `spender` must have allowance for the caller of at least
974      * `subtractedValue`.
975      */
976     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
977         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
978         return true;
979     }
980 
981     /**
982      * @dev Moves tokens `amount` from `sender` to `recipient`.
983      *
984      * This is internal function is equivalent to {transfer}, and can be used to
985      * e.g. implement automatic token fees, slashing mechanisms, etc.
986      *
987      * Emits a {Transfer} event.
988      *
989      * Requirements:
990      *
991      * - `sender` cannot be the zero address.
992      * - `recipient` cannot be the zero address.
993      * - `sender` must have a balance of at least `amount`.
994      */
995     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
996         require(sender != address(0), "ERC20: transfer from the zero address");
997         require(recipient != address(0), "ERC20: transfer to the zero address");
998 
999         _beforeTokenTransfer(sender, recipient, amount);
1000 
1001         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1002         _balances[recipient] = _balances[recipient].add(amount);
1003         emit Transfer(sender, recipient, amount);
1004     }
1005 
1006     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1007      * the total supply.
1008      *
1009      * Emits a {Transfer} event with `from` set to the zero address.
1010      *
1011      * Requirements
1012      *
1013      * - `to` cannot be the zero address.
1014      */
1015     function _mint(address account, uint256 amount) internal virtual {
1016         require(account != address(0), "ERC20: mint to the zero address");
1017 
1018         _beforeTokenTransfer(address(0), account, amount);
1019 
1020         _totalSupply = _totalSupply.add(amount);
1021         _balances[account] = _balances[account].add(amount);
1022         emit Transfer(address(0), account, amount);
1023     }
1024 
1025     /**
1026      * @dev Destroys `amount` tokens from `account`, reducing the
1027      * total supply.
1028      *
1029      * Emits a {Transfer} event with `to` set to the zero address.
1030      *
1031      * Requirements
1032      *
1033      * - `account` cannot be the zero address.
1034      * - `account` must have at least `amount` tokens.
1035      */
1036     function _burn(address account, uint256 amount) internal virtual {
1037         require(account != address(0), "ERC20: burn from the zero address");
1038 
1039         _beforeTokenTransfer(account, address(0), amount);
1040 
1041         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1042         _totalSupply = _totalSupply.sub(amount);
1043         emit Transfer(account, address(0), amount);
1044     }
1045 
1046     /**
1047      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1048      *
1049      * This is internal function is equivalent to `approve`, and can be used to
1050      * e.g. set automatic allowances for certain subsystems, etc.
1051      *
1052      * Emits an {Approval} event.
1053      *
1054      * Requirements:
1055      *
1056      * - `owner` cannot be the zero address.
1057      * - `spender` cannot be the zero address.
1058      */
1059     function _approve(address owner, address spender, uint256 amount) internal virtual {
1060         require(owner != address(0), "ERC20: approve from the zero address");
1061         require(spender != address(0), "ERC20: approve to the zero address");
1062 
1063         _allowances[owner][spender] = amount;
1064         emit Approval(owner, spender, amount);
1065     }
1066 
1067     /**
1068      * @dev Sets {decimals} to a value other than the default one of 18.
1069      *
1070      * WARNING: This function should only be called from the constructor. Most
1071      * applications that interact with token contracts will not expect
1072      * {decimals} to ever change, and may work incorrectly if it does.
1073      */
1074     function _setupDecimals(uint8 decimals_) internal {
1075         _decimals = decimals_;
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any transfer of tokens. This includes
1080      * minting and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1085      * will be to transferred to `to`.
1086      * - when `from` is zero, `amount` tokens will be minted for `to`.
1087      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1088      * - `from` and `to` are never both zero.
1089      *
1090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1091      */
1092     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1093 }
1094 
1095 // File: contracts/LightToken.sol
1096 
1097 pragma solidity 0.6.12;
1098 
1099 // LightToken with Governance.
1100 contract LightToken is ERC20("LightToken", "LIGHT"), Ownable {
1101     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (LightMain).
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
1114     mapping (address => address) internal _delegates;
1115 
1116     /// @notice A checkpoint for marking number of votes from a given block
1117     struct Checkpoint {
1118         uint32 fromBlock;
1119         uint256 votes;
1120     }
1121 
1122     /// @notice A record of votes checkpoints for each account, by index
1123     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1124 
1125     /// @notice The number of checkpoints for each account
1126     mapping (address => uint32) public numCheckpoints;
1127 
1128     /// @notice The EIP-712 typehash for the contract's domain
1129     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1130 
1131     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1132     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1133 
1134     /// @notice A record of states for signing / validating signatures
1135     mapping (address => uint) public nonces;
1136 
1137       /// @notice An event thats emitted when an account changes its delegate
1138     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1139 
1140     /// @notice An event thats emitted when a delegate account's vote balance changes
1141     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1142 
1143     /**
1144      * @notice Delegate votes from `msg.sender` to `delegatee`
1145      * @param delegator The address to get delegatee for
1146      */
1147     function delegates(address delegator)
1148         external
1149         view
1150         returns (address)
1151     {
1152         return _delegates[delegator];
1153     }
1154 
1155    /**
1156     * @notice Delegate votes from `msg.sender` to `delegatee`
1157     * @param delegatee The address to delegate votes to
1158     */
1159     function delegate(address delegatee) external {
1160         return _delegate(msg.sender, delegatee);
1161     }
1162 
1163     /**
1164      * @notice Delegates votes from signatory to `delegatee`
1165      * @param delegatee The address to delegate votes to
1166      * @param nonce The contract state required to match the signature
1167      * @param expiry The time at which to expire the signature
1168      * @param v The recovery byte of the signature
1169      * @param r Half of the ECDSA signature pair
1170      * @param s Half of the ECDSA signature pair
1171      */
1172     function delegateBySig(
1173         address delegatee,
1174         uint nonce,
1175         uint expiry,
1176         uint8 v,
1177         bytes32 r,
1178         bytes32 s
1179     )
1180         external
1181     {
1182         bytes32 domainSeparator = keccak256(
1183             abi.encode(
1184                 DOMAIN_TYPEHASH,
1185                 keccak256(bytes(name())),
1186                 getChainId(),
1187                 address(this)
1188             )
1189         );
1190 
1191         bytes32 structHash = keccak256(
1192             abi.encode(
1193                 DELEGATION_TYPEHASH,
1194                 delegatee,
1195                 nonce,
1196                 expiry
1197             )
1198         );
1199 
1200         bytes32 digest = keccak256(
1201             abi.encodePacked(
1202                 "\x19\x01",
1203                 domainSeparator,
1204                 structHash
1205             )
1206         );
1207 
1208         address signatory = ecrecover(digest, v, r, s);
1209         require(signatory != address(0), "LIGHT::delegateBySig: invalid signature");
1210         require(nonce == nonces[signatory]++, "LIGHT::delegateBySig: invalid nonce");
1211         require(now <= expiry, "LIGHT::delegateBySig: signature expired");
1212         return _delegate(signatory, delegatee);
1213     }
1214 
1215     /**
1216      * @notice Gets the current votes balance for `account`
1217      * @param account The address to get votes balance
1218      * @return The number of current votes for `account`
1219      */
1220     function getCurrentVotes(address account)
1221         external
1222         view
1223         returns (uint256)
1224     {
1225         uint32 nCheckpoints = numCheckpoints[account];
1226         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1227     }
1228 
1229     /**
1230      * @notice Determine the prior number of votes for an account as of a block number
1231      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1232      * @param account The address of the account to check
1233      * @param blockNumber The block number to get the vote balance at
1234      * @return The number of votes the account had as of the given block
1235      */
1236     function getPriorVotes(address account, uint blockNumber)
1237         external
1238         view
1239         returns (uint256)
1240     {
1241         require(blockNumber < block.number, "LIGHT::getPriorVotes: not yet determined");
1242 
1243         uint32 nCheckpoints = numCheckpoints[account];
1244         if (nCheckpoints == 0) {
1245             return 0;
1246         }
1247 
1248         // First check most recent balance
1249         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1250             return checkpoints[account][nCheckpoints - 1].votes;
1251         }
1252 
1253         // Next check implicit zero balance
1254         if (checkpoints[account][0].fromBlock > blockNumber) {
1255             return 0;
1256         }
1257 
1258         uint32 lower = 0;
1259         uint32 upper = nCheckpoints - 1;
1260         while (upper > lower) {
1261             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1262             Checkpoint memory cp = checkpoints[account][center];
1263             if (cp.fromBlock == blockNumber) {
1264                 return cp.votes;
1265             } else if (cp.fromBlock < blockNumber) {
1266                 lower = center;
1267             } else {
1268                 upper = center - 1;
1269             }
1270         }
1271         return checkpoints[account][lower].votes;
1272     }
1273 
1274     function _delegate(address delegator, address delegatee)
1275         internal
1276     {
1277         address currentDelegate = _delegates[delegator];
1278         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying LIGHTs (not scaled);
1279         _delegates[delegator] = delegatee;
1280 
1281         emit DelegateChanged(delegator, currentDelegate, delegatee);
1282 
1283         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1284     }
1285 
1286     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1287         if (srcRep != dstRep && amount > 0) {
1288             if (srcRep != address(0)) {
1289                 // decrease old representative
1290                 uint32 srcRepNum = numCheckpoints[srcRep];
1291                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1292                 uint256 srcRepNew = srcRepOld.sub(amount);
1293                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1294             }
1295 
1296             if (dstRep != address(0)) {
1297                 // increase new representative
1298                 uint32 dstRepNum = numCheckpoints[dstRep];
1299                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1300                 uint256 dstRepNew = dstRepOld.add(amount);
1301                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1302             }
1303         }
1304     }
1305 
1306     function _writeCheckpoint(
1307         address delegatee,
1308         uint32 nCheckpoints,
1309         uint256 oldVotes,
1310         uint256 newVotes
1311     )
1312         internal
1313     {
1314         uint32 blockNumber = safe32(block.number, "LIGHT::_writeCheckpoint: block number exceeds 32 bits");
1315 
1316         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1317             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1318         } else {
1319             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1320             numCheckpoints[delegatee] = nCheckpoints + 1;
1321         }
1322 
1323         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1324     }
1325 
1326     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1327         require(n < 2**32, errorMessage);
1328         return uint32(n);
1329     }
1330 
1331     function getChainId() internal pure returns (uint) {
1332         uint256 chainId;
1333         assembly { chainId := chainid() }
1334         return chainId;
1335     }
1336 }