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
699 pragma solidity ^0.6.0;
700 
701 /*
702  * @dev Provides information about the current execution context, including the
703  * sender of the transaction and its data. While these are generally available
704  * via msg.sender and msg.data, they should not be accessed in such a direct
705  * manner, since when dealing with GSN meta-transactions the account sending and
706  * paying for execution may not be the actual sender (as far as an application
707  * is concerned).
708  *
709  * This contract is only required for intermediate, library-like contracts.
710  */
711 abstract contract Context {
712     function _msgSender() internal view virtual returns (address payable) {
713         return msg.sender;
714     }
715 
716     function _msgData() internal view virtual returns (bytes memory) {
717         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
718         return msg.data;
719     }
720 }
721 
722 // File: @openzeppelin/contracts/access/Ownable.sol
723 
724 pragma solidity ^0.6.0;
725 
726 /**
727  * @dev Contract module which provides a basic access control mechanism, where
728  * there is an account (an owner) that can be granted exclusive access to
729  * specific functions.
730  *
731  * By default, the owner account will be the one that deploys the contract. This
732  * can later be changed with {transferOwnership}.
733  *
734  * This module is used through inheritance. It will make available the modifier
735  * `onlyOwner`, which can be applied to your functions to restrict their use to
736  * the owner.
737  */
738 contract Ownable is Context {
739     address private _owner;
740 
741     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
742 
743     /**
744      * @dev Initializes the contract setting the deployer as the initial owner.
745      */
746     constructor () internal {
747         address msgSender = _msgSender();
748         _owner = msgSender;
749         emit OwnershipTransferred(address(0), msgSender);
750     }
751 
752     /**
753      * @dev Returns the address of the current owner.
754      */
755     function owner() public view returns (address) {
756         return _owner;
757     }
758 
759     /**
760      * @dev Throws if called by any account other than the owner.
761      */
762     modifier onlyOwner() {
763         require(_owner == _msgSender(), "Ownable: caller is not the owner");
764         _;
765     }
766 
767     /**
768      * @dev Leaves the contract without owner. It will not be possible to call
769      * `onlyOwner` functions anymore. Can only be called by the current owner.
770      *
771      * NOTE: Renouncing ownership will leave the contract without an owner,
772      * thereby removing any functionality that is only available to the owner.
773      */
774     function renounceOwnership() public virtual onlyOwner {
775         emit OwnershipTransferred(_owner, address(0));
776         _owner = address(0);
777     }
778 
779     /**
780      * @dev Transfers ownership of the contract to a new account (`newOwner`).
781      * Can only be called by the current owner.
782      */
783     function transferOwnership(address newOwner) public virtual onlyOwner {
784         require(newOwner != address(0), "Ownable: new owner is the zero address");
785         emit OwnershipTransferred(_owner, newOwner);
786         _owner = newOwner;
787     }
788 }
789 
790 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
791 
792 pragma solidity ^0.6.0;
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
1093 // File: contracts/MutantToken.sol
1094 
1095 pragma solidity 0.6.12;
1096 
1097 // MutantToken with Governance.
1098 contract MutantToken is ERC20("MutantToken", "MUTANT"), Ownable {
1099     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterYmen).
1100     function mint(address _to, uint256 _amount) public onlyOwner {
1101         _mint(_to, _amount);
1102         _moveDelegates(address(0), _delegates[_to], _amount);
1103     }
1104 
1105     // Copied and modified from YAM code:
1106     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1107     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1108     // Which is copied and modified from COMPOUND:
1109     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1110 
1111     /// @notice A record of each accounts delegate
1112     mapping (address => address) internal _delegates;
1113 
1114     /// @notice A checkpoint for marking number of votes from a given block
1115     struct Checkpoint {
1116         uint32 fromBlock;
1117         uint256 votes;
1118     }
1119 
1120     /// @notice A record of votes checkpoints for each account, by index
1121     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1122 
1123     /// @notice The number of checkpoints for each account
1124     mapping (address => uint32) public numCheckpoints;
1125 
1126     /// @notice The EIP-712 typehash for the contract's domain
1127     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1128 
1129     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1130     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1131 
1132     /// @notice A record of states for signing / validating signatures
1133     mapping (address => uint) public nonces;
1134 
1135       /// @notice An event thats emitted when an account changes its delegate
1136     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1137 
1138     /// @notice An event thats emitted when a delegate account's vote balance changes
1139     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1140 
1141     /**
1142      * @notice Delegate votes from `msg.sender` to `delegatee`
1143      * @param delegator The address to get delegatee for
1144      */
1145     function delegates(address delegator)
1146         external
1147         view
1148         returns (address)
1149     {
1150         return _delegates[delegator];
1151     }
1152 
1153    /**
1154     * @notice Delegate votes from `msg.sender` to `delegatee`
1155     * @param delegatee The address to delegate votes to
1156     */
1157     function delegate(address delegatee) external {
1158         return _delegate(msg.sender, delegatee);
1159     }
1160 
1161     /**
1162      * @notice Delegates votes from signatory to `delegatee`
1163      * @param delegatee The address to delegate votes to
1164      * @param nonce The contract state required to match the signature
1165      * @param expiry The time at which to expire the signature
1166      * @param v The recovery byte of the signature
1167      * @param r Half of the ECDSA signature pair
1168      * @param s Half of the ECDSA signature pair
1169      */
1170     function delegateBySig(
1171         address delegatee,
1172         uint nonce,
1173         uint expiry,
1174         uint8 v,
1175         bytes32 r,
1176         bytes32 s
1177     )
1178         external
1179     {
1180         bytes32 domainSeparator = keccak256(
1181             abi.encode(
1182                 DOMAIN_TYPEHASH,
1183                 keccak256(bytes(name())),
1184                 getChainId(),
1185                 address(this)
1186             )
1187         );
1188 
1189         bytes32 structHash = keccak256(
1190             abi.encode(
1191                 DELEGATION_TYPEHASH,
1192                 delegatee,
1193                 nonce,
1194                 expiry
1195             )
1196         );
1197 
1198         bytes32 digest = keccak256(
1199             abi.encodePacked(
1200                 "\x19\x01",
1201                 domainSeparator,
1202                 structHash
1203             )
1204         );
1205 
1206         address signatory = ecrecover(digest, v, r, s);
1207         require(signatory != address(0), "MUTANT::delegateBySig: invalid signature");
1208         require(nonce == nonces[signatory]++, "MUTANT::delegateBySig: invalid nonce");
1209         require(now <= expiry, "MUTANT::delegateBySig: signature expired");
1210         return _delegate(signatory, delegatee);
1211     }
1212 
1213     /**
1214      * @notice Gets the current votes balance for `account`
1215      * @param account The address to get votes balance
1216      * @return The number of current votes for `account`
1217      */
1218     function getCurrentVotes(address account)
1219         external
1220         view
1221         returns (uint256)
1222     {
1223         uint32 nCheckpoints = numCheckpoints[account];
1224         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1225     }
1226 
1227     /**
1228      * @notice Determine the prior number of votes for an account as of a block number
1229      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1230      * @param account The address of the account to check
1231      * @param blockNumber The block number to get the vote balance at
1232      * @return The number of votes the account had as of the given block
1233      */
1234     function getPriorVotes(address account, uint blockNumber)
1235         external
1236         view
1237         returns (uint256)
1238     {
1239         require(blockNumber < block.number, "MUTANT::getPriorVotes: not yet determined");
1240 
1241         uint32 nCheckpoints = numCheckpoints[account];
1242         if (nCheckpoints == 0) {
1243             return 0;
1244         }
1245 
1246         // First check most recent balance
1247         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1248             return checkpoints[account][nCheckpoints - 1].votes;
1249         }
1250 
1251         // Next check implicit zero balance
1252         if (checkpoints[account][0].fromBlock > blockNumber) {
1253             return 0;
1254         }
1255 
1256         uint32 lower = 0;
1257         uint32 upper = nCheckpoints - 1;
1258         while (upper > lower) {
1259             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1260             Checkpoint memory cp = checkpoints[account][center];
1261             if (cp.fromBlock == blockNumber) {
1262                 return cp.votes;
1263             } else if (cp.fromBlock < blockNumber) {
1264                 lower = center;
1265             } else {
1266                 upper = center - 1;
1267             }
1268         }
1269         return checkpoints[account][lower].votes;
1270     }
1271 
1272     function _delegate(address delegator, address delegatee)
1273         internal
1274     {
1275         address currentDelegate = _delegates[delegator];
1276         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MUTANTs (not scaled);
1277         _delegates[delegator] = delegatee;
1278 
1279         emit DelegateChanged(delegator, currentDelegate, delegatee);
1280 
1281         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1282     }
1283 
1284     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1285         if (srcRep != dstRep && amount > 0) {
1286             if (srcRep != address(0)) {
1287                 // decrease old representative
1288                 uint32 srcRepNum = numCheckpoints[srcRep];
1289                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1290                 uint256 srcRepNew = srcRepOld.sub(amount);
1291                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1292             }
1293 
1294             if (dstRep != address(0)) {
1295                 // increase new representative
1296                 uint32 dstRepNum = numCheckpoints[dstRep];
1297                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1298                 uint256 dstRepNew = dstRepOld.add(amount);
1299                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1300             }
1301         }
1302     }
1303 
1304     function _writeCheckpoint(
1305         address delegatee,
1306         uint32 nCheckpoints,
1307         uint256 oldVotes,
1308         uint256 newVotes
1309     )
1310         internal
1311     {
1312         uint32 blockNumber = safe32(block.number, "MUTANT::_writeCheckpoint: block number exceeds 32 bits");
1313 
1314         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1315             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1316         } else {
1317             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1318             numCheckpoints[delegatee] = nCheckpoints + 1;
1319         }
1320 
1321         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1322     }
1323 
1324     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1325         require(n < 2**32, errorMessage);
1326         return uint32(n);
1327     }
1328 
1329     function getChainId() internal pure returns (uint) {
1330         uint256 chainId;
1331         assembly { chainId := chainid() }
1332         return chainId;
1333     }
1334 }
1335 
1336 // File: contracts/MasterYmen.sol
1337 
1338 pragma solidity 0.6.12;
1339 
1340 interface IMigratorYmen {
1341     // Perform LP token migration from legacy UniswapV2 to Mutant.
1342     // Take the current LP token address and return the new LP token address.
1343     // Migrator should have full access to the caller's LP token.
1344     // Return the new LP token address.
1345     //
1346     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1347     // Y-Men must mint EXACTLY the same amount of Mutant LP tokens or
1348     // else something bad will happen. Traditional UniswapV2 does not
1349     // do that so be careful!
1350     function migrate(IERC20 token) external returns (IERC20);
1351 }
1352 
1353 // MasterYmen is the master of Mutants. He can train them and he is a fair guy.
1354 //
1355 // Note that it's ownable and the owner wields tremendous power. The ownership
1356 // will be transferred to a governance smart contract once MUTANT is sufficiently
1357 // distributed and the community can show to govern itself.
1358 //
1359 // Have fun reading it. Hopefully it's bug-free. God bless.
1360 contract MasterYmen is Ownable {
1361     using SafeMath for uint256;
1362     using SafeERC20 for IERC20;
1363 
1364     // Info of each user.
1365     struct UserInfo {
1366         uint256 amount;     // How many LP tokens the user has provided.
1367         uint256 rewardDebt; // Reward debt. See explanation below.
1368         //
1369         // We do some fancy math here. Basically, any point in time, the amount of MUTANTs
1370         // entitled to a user but is pending to be distributed is:
1371         //
1372         //   pending reward = (user.amount * pool.accMutantPerShare) - user.rewardDebt
1373         //
1374         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1375         //   1. The pool's `accMutantPerShare` (and `lastRewardBlock`) gets updated.
1376         //   2. User receives the pending reward sent to his/her address.
1377         //   3. User's `amount` gets updated.
1378         //   4. User's `rewardDebt` gets updated.
1379     }
1380 
1381     // Info of each pool.
1382     struct PoolInfo {
1383         IERC20 lpToken;           // Address of LP token contract.
1384         uint256 allocPoint;       // How many allocation points assigned to this pool. MUTANTs to distribute per block.
1385         uint256 lastRewardBlock;  // Last block number that MUTANTs distribution occurs.
1386         uint256 accMutantPerShare; // Accumulated MUTANTs per share, times 1e12. See below.
1387     }
1388 
1389     // The MUTANT TOKEN!
1390     MutantToken public mutant;
1391     // Dev address.
1392     address public devaddr;
1393     // Block number when bonus MUTANT period ends.
1394     uint256 public bonusEndBlock;
1395     // MUTANT tokens created per block.
1396     uint256 public mutantPerBlock;
1397     // Bonus muliplier for early mutant makers.
1398     uint256 public constant BONUS_MULTIPLIER = 10;
1399     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1400     IMigratorYmen public migrator;
1401 
1402     // Info of each pool.
1403     PoolInfo[] public poolInfo;
1404     // Track all added pools to prevent adding the same pool more then once.
1405     mapping(address => bool) public lpTokenExistsInPool;
1406     // Info of each user that stakes LP tokens.
1407     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1408     // Total allocation points. Must be the sum of all allocation points in all pools.
1409     uint256 public totalAllocPoint = 0;
1410     // The block number when MUTANT mining starts.
1411     uint256 public startBlock;
1412 
1413     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1414     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1415     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1416 
1417     constructor(
1418         MutantToken _mutant,
1419         address _devaddr,
1420         uint256 _mutantPerBlock,
1421         uint256 _startBlock,
1422         uint256 _bonusEndBlock
1423     ) public {
1424         mutant = _mutant;
1425         devaddr = _devaddr;
1426         mutantPerBlock = _mutantPerBlock;
1427         bonusEndBlock = _bonusEndBlock;
1428         startBlock = _startBlock;
1429     }
1430 
1431     function poolLength() external view returns (uint256) {
1432         return poolInfo.length;
1433     }
1434 
1435     // Add a new lp to the pool. Can only be called by the owner.
1436     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1437     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1438     	require(!lpTokenExistsInPool[address(_lpToken)], "MasterChef: LP Token Address already exists in pool");
1439         if (_withUpdate) {
1440             massUpdatePools();
1441         }
1442         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1443         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1444         poolInfo.push(PoolInfo({
1445             lpToken: _lpToken,
1446             allocPoint: _allocPoint,
1447             lastRewardBlock: lastRewardBlock,
1448             accMutantPerShare: 0
1449         }));
1450         lpTokenExistsInPool[address(_lpToken)] = true;
1451     }
1452 
1453     // Add a pool manually for pools that already exists, but were not auto added to the map by "add()".
1454     function updateLpTokenExists(address _lpTokenAddr, bool _isExists) external onlyOwner {
1455         lpTokenExistsInPool[_lpTokenAddr] = _isExists;
1456     }
1457 
1458     // Update the given pool's MUTANT allocation point. Can only be called by the owner.
1459     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1460         if (_withUpdate) {
1461             massUpdatePools();
1462         }
1463         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1464         poolInfo[_pid].allocPoint = _allocPoint;
1465     }
1466 
1467     // Set the migrator contract. Can only be called by the owner.
1468     function setMigrator(IMigratorYmen _migrator) public onlyOwner {
1469         migrator = _migrator;
1470     }
1471 
1472     // Migrate lp token to another lp contract.
1473     // Can be called by anyone.
1474     // We trust that migrator contract is good.
1475     function migrate(uint256 _pid) public {
1476         require(address(migrator) != address(0), "migrate: no migrator");
1477         PoolInfo storage pool = poolInfo[_pid];
1478         IERC20 lpToken = pool.lpToken;
1479         uint256 bal = lpToken.balanceOf(address(this));
1480         lpToken.safeApprove(address(migrator), bal);
1481         IERC20 newLpToken = migrator.migrate(lpToken);
1482         require(!lpTokenExistsInPool[address(newLpToken)],"MasterChef: New LP Token Address already exists in pool");
1483         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1484         pool.lpToken = newLpToken;
1485         lpTokenExistsInPool[address(newLpToken)] = true;
1486     }
1487 
1488     // Return reward multiplier over the given _from to _to block.
1489     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1490         if (_to <= bonusEndBlock) {
1491             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1492         } else if (_from >= bonusEndBlock) {
1493             return _to.sub(_from);
1494         } else {
1495             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1496                 _to.sub(bonusEndBlock)
1497             );
1498         }
1499     }
1500 
1501     // View function to see pending MUTANTs on frontend.
1502     function pendingMutant(uint256 _pid, address _user) external view returns (uint256) {
1503         PoolInfo storage pool = poolInfo[_pid];
1504         UserInfo storage user = userInfo[_pid][_user];
1505         uint256 accMutantPerShare = pool.accMutantPerShare;
1506         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1507         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1508             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1509             uint256 mutantReward = multiplier.mul(mutantPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1510             accMutantPerShare = accMutantPerShare.add(mutantReward.mul(1e12).div(lpSupply));
1511         }
1512         return user.amount.mul(accMutantPerShare).div(1e12).sub(user.rewardDebt);
1513     }
1514 
1515     // Update reward variables for all pools. Be careful of gas spending!
1516     function massUpdatePools() public {
1517         uint256 length = poolInfo.length;
1518         for (uint256 pid = 0; pid < length; ++pid) {
1519             updatePool(pid);
1520         }
1521     }
1522 
1523     // Update reward variables of the given pool to be up-to-date.
1524     function updatePool(uint256 _pid) public {
1525         PoolInfo storage pool = poolInfo[_pid];
1526         if (block.number <= pool.lastRewardBlock) {
1527             return;
1528         }
1529         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1530         if (lpSupply == 0) {
1531             pool.lastRewardBlock = block.number;
1532             return;
1533         }
1534         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1535         uint256 mutantReward = multiplier.mul(mutantPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1536         mutant.mint(devaddr, mutantReward.div(10));
1537         mutant.mint(address(this), mutantReward);
1538         pool.accMutantPerShare = pool.accMutantPerShare.add(mutantReward.mul(1e12).div(lpSupply));
1539         pool.lastRewardBlock = block.number;
1540     }
1541 
1542     // Deposit LP tokens to MasterYmen for MUTANT allocation.
1543     function deposit(uint256 _pid, uint256 _amount) public {
1544         PoolInfo storage pool = poolInfo[_pid];
1545         UserInfo storage user = userInfo[_pid][msg.sender];
1546         updatePool(_pid);
1547         if (user.amount > 0) {
1548             uint256 pending = user.amount.mul(pool.accMutantPerShare).div(1e12).sub(user.rewardDebt);
1549             if(pending > 0) {
1550                 safeMutantTransfer(msg.sender, pending);
1551             }
1552         }
1553         if(_amount > 0) {
1554             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1555             user.amount = user.amount.add(_amount);
1556         }
1557         user.rewardDebt = user.amount.mul(pool.accMutantPerShare).div(1e12);
1558         emit Deposit(msg.sender, _pid, _amount);
1559     }
1560 
1561     // Withdraw LP tokens from MasterYmen.
1562     function withdraw(uint256 _pid, uint256 _amount) public {
1563         PoolInfo storage pool = poolInfo[_pid];
1564         UserInfo storage user = userInfo[_pid][msg.sender];
1565         require(user.amount >= _amount, "withdraw: not good");
1566         updatePool(_pid);
1567         uint256 pending = user.amount.mul(pool.accMutantPerShare).div(1e12).sub(user.rewardDebt);
1568         if(pending > 0) {
1569             safeMutantTransfer(msg.sender, pending);
1570         }
1571         if(_amount > 0) {
1572             user.amount = user.amount.sub(_amount);
1573             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1574         }
1575         user.rewardDebt = user.amount.mul(pool.accMutantPerShare).div(1e12);
1576         emit Withdraw(msg.sender, _pid, _amount);
1577     }
1578 
1579     // Withdraw without caring about rewards. EMERGENCY ONLY.
1580     function emergencyWithdraw(uint256 _pid) public {
1581         PoolInfo storage pool = poolInfo[_pid];
1582         UserInfo storage user = userInfo[_pid][msg.sender];
1583 		uint256 amount = user.amount;
1584         user.amount = 0;
1585         user.rewardDebt = 0;
1586         pool.lpToken.safeTransfer(address(msg.sender), amount);
1587         emit EmergencyWithdraw(msg.sender, _pid, amount);
1588     }
1589 
1590     // Safe mutant transfer function, just in case if rounding error causes pool to not have enough MUTANTs.
1591     function safeMutantTransfer(address _to, uint256 _amount) internal {
1592         uint256 mutantBal = mutant.balanceOf(address(this));
1593         if (_amount > mutantBal) {
1594             mutant.transfer(_to, mutantBal);
1595         } else {
1596             mutant.transfer(_to, _amount);
1597         }
1598     }
1599 
1600     // Update dev address by the previous dev.
1601     function dev(address _devaddr) public {
1602         require(msg.sender == devaddr, "dev: wut?");
1603         devaddr = _devaddr;
1604     }
1605 }