1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.6.6;
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
78 // File: @openzeppelin/contracts/math/SafeMath.sol
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
238 // File: @openzeppelin/contracts/utils/Address.sol
239 
240 pragma solidity ^0.6.2;
241 
242 /**
243  * @dev Collection of functions related to the address type
244  */
245 library Address {
246     /**
247      * @dev Returns true if `account` is a contract.
248      *
249      * [IMPORTANT]
250      * ====
251      * It is unsafe to assume that an address for which this function returns
252      * false is an externally-owned account (EOA) and not a contract.
253      *
254      * Among others, `isContract` will return false for the following
255      * types of addresses:
256      *
257      *  - an externally-owned account
258      *  - a contract in construction
259      *  - an address where a contract will be created
260      *  - an address where a contract lived, but was destroyed
261      * ====
262      */
263     function isContract(address account) internal view returns (bool) {
264         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
265         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
266         // for accounts without code, i.e. `keccak256('')`
267         bytes32 codehash;
268         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
269         // solhint-disable-next-line no-inline-assembly
270         assembly { codehash := extcodehash(account) }
271         return (codehash != accountHash && codehash != 0x0);
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
294         (bool success, ) = recipient.call{ value: amount }("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297 
298     /**
299      * @dev Performs a Solidity function call using a low level `call`. A
300      * plain`call` is an unsafe replacement for a function call: use this
301      * function instead.
302      *
303      * If `target` reverts with a revert reason, it is bubbled up by this
304      * function (like regular Solidity function calls).
305      *
306      * Returns the raw returned data. To convert to the expected return value,
307      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308      *
309      * Requirements:
310      *
311      * - `target` must be a contract.
312      * - calling `target` with `data` must not revert.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317       return functionCall(target, data, "Address: low-level call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322      * `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
327         return _functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         return _functionCallWithValue(target, data, value, errorMessage);
354     }
355 
356     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
357         require(isContract(target), "Address: call to non-contract");
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
361         if (success) {
362             return returndata;
363         } else {
364             // Look for revert reason and bubble it up if present
365             if (returndata.length > 0) {
366                 // The easiest way to bubble the revert reason is using memory via assembly
367 
368                 // solhint-disable-next-line no-inline-assembly
369                 assembly {
370                     let returndata_size := mload(returndata)
371                     revert(add(32, returndata), returndata_size)
372                 }
373             } else {
374                 revert(errorMessage);
375             }
376         }
377     }
378 }
379 
380 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
381 
382 pragma solidity ^0.6.0;
383 
384 /**
385  * @title SafeERC20
386  * @dev Wrappers around ERC20 operations that throw on failure (when the token
387  * contract returns false). Tokens that return no value (and instead revert or
388  * throw on failure) are also supported, non-reverting calls are assumed to be
389  * successful.
390  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
391  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
392  */
393 library SafeERC20 {
394     using SafeMath for uint256;
395     using Address for address;
396 
397     function safeTransfer(IERC20 token, address to, uint256 value) internal {
398         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
399     }
400 
401     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
402         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
403     }
404 
405     /**
406      * @dev Deprecated. This function has issues similar to the ones found in
407      * {IERC20-approve}, and its usage is discouraged.
408      *
409      * Whenever possible, use {safeIncreaseAllowance} and
410      * {safeDecreaseAllowance} instead.
411      */
412     function safeApprove(IERC20 token, address spender, uint256 value) internal {
413         // safeApprove should only be called when setting an initial allowance,
414         // or when resetting it to zero. To increase and decrease it, use
415         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
416         // solhint-disable-next-line max-line-length
417         require((value == 0) || (token.allowance(address(this), spender) == 0),
418             "SafeERC20: approve from non-zero to non-zero allowance"
419         );
420         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
421     }
422 
423     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
424         uint256 newAllowance = token.allowance(address(this), spender).add(value);
425         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
426     }
427 
428     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
429         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
430         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
431     }
432 
433     /**
434      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
435      * on the return value: the return value is optional (but if data is returned, it must not be false).
436      * @param token The token targeted by the call.
437      * @param data The call data (encoded using abi.encode or one of its variants).
438      */
439     function _callOptionalReturn(IERC20 token, bytes memory data) private {
440         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
441         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
442         // the target address contains contract code and also asserts for success in the low-level call.
443 
444         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
445         if (returndata.length > 0) { // Return data is optional
446             // solhint-disable-next-line max-line-length
447             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
448         }
449     }
450 }
451 
452 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
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
640     // UintSet
641     struct UintSet {
642         Set _inner;
643     }
644 
645     /**
646      * @dev Add a value to a set. O(1).
647      *
648      * Returns true if the value was added to the set, that is if it was not
649      * already present.
650      */
651     function add(UintSet storage set, uint256 value) internal returns (bool) {
652         return _add(set._inner, bytes32(value));
653     }
654 
655     /**
656      * @dev Removes a value from a set. O(1).
657      *
658      * Returns true if the value was removed from the set, that is if it was
659      * present.
660      */
661     function remove(UintSet storage set, uint256 value) internal returns (bool) {
662         return _remove(set._inner, bytes32(value));
663     }
664 
665     /**
666      * @dev Returns true if the value is in the set. O(1).
667      */
668     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
669         return _contains(set._inner, bytes32(value));
670     }
671 
672     /**
673      * @dev Returns the number of values on the set. O(1).
674      */
675     function length(UintSet storage set) internal view returns (uint256) {
676         return _length(set._inner);
677     }
678 
679    /**
680     * @dev Returns the value stored at position `index` in the set. O(1).
681     *
682     * Note that there are no guarantees on the ordering of values inside the
683     * array, and it may change when more values are added or removed.
684     *
685     * Requirements:
686     *
687     * - `index` must be strictly less than {length}.
688     */
689     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
690         return uint256(_at(set._inner, index));
691     }
692 }
693 
694 // File: @openzeppelin/contracts/GSN/Context.sol
695 
696 pragma solidity ^0.6.0;
697 
698 /*
699  * @dev Provides information about the current execution context, including the
700  * sender of the transaction and its data. While these are generally available
701  * via msg.sender and msg.data, they should not be accessed in such a direct
702  * manner, since when dealing with GSN meta-transactions the account sending and
703  * paying for execution may not be the actual sender (as far as an application
704  * is concerned).
705  *
706  * This contract is only required for intermediate, library-like contracts.
707  */
708 abstract contract Context {
709     function _msgSender() internal view virtual returns (address payable) {
710         return msg.sender;
711     }
712 
713     function _msgData() internal view virtual returns (bytes memory) {
714         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
715         return msg.data;
716     }
717 }
718 
719 // File: @openzeppelin/contracts/access/Ownable.sol
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
787 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
788 
789 pragma solidity ^0.6.0;
790 
791 /**
792  * @dev Implementation of the {IERC20} interface.
793  *
794  * This implementation is agnostic to the way tokens are created. This means
795  * that a supply mechanism has to be added in a derived contract using {_mint}.
796  * For a generic mechanism see {ERC20PresetMinterPauser}.
797  *
798  * TIP: For a detailed writeup see our guide
799  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
800  * to implement supply mechanisms].
801  *
802  * We have followed general OpenZeppelin guidelines: functions revert instead
803  * of returning `false` on failure. This behavior is nonetheless conventional
804  * and does not conflict with the expectations of ERC20 applications.
805  *
806  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
807  * This allows applications to reconstruct the allowance for all accounts just
808  * by listening to said events. Other implementations of the EIP may not emit
809  * these events, as it isn't required by the specification.
810  *
811  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
812  * functions have been added to mitigate the well-known issues around setting
813  * allowances. See {IERC20-approve}.
814  */
815 contract ERC20 is Context, IERC20 {
816     using SafeMath for uint256;
817     using Address for address;
818 
819     mapping (address => uint256) private _balances;
820 
821     mapping (address => mapping (address => uint256)) private _allowances;
822 
823     uint256 private _totalSupply;
824 
825     string private _name;
826     string private _symbol;
827     uint8 private _decimals;
828 
829     /**
830      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
831      * a default value of 18.
832      *
833      * To select a different value for {decimals}, use {_setupDecimals}.
834      *
835      * All three of these values are immutable: they can only be set once during
836      * construction.
837      */
838     constructor (string memory name, string memory symbol) public {
839         _name = name;
840         _symbol = symbol;
841         _decimals = 18;
842     }
843 
844     /**
845      * @dev Returns the name of the token.
846      */
847     function name() public view returns (string memory) {
848         return _name;
849     }
850 
851     /**
852      * @dev Returns the symbol of the token, usually a shorter version of the
853      * name.
854      */
855     function symbol() public view returns (string memory) {
856         return _symbol;
857     }
858 
859     /**
860      * @dev Returns the number of decimals used to get its user representation.
861      * For example, if `decimals` equals `2`, a balance of `505` tokens should
862      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
863      *
864      * Tokens usually opt for a value of 18, imitating the relationship between
865      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
866      * called.
867      *
868      * NOTE: This information is only used for _display_ purposes: it in
869      * no way affects any of the arithmetic of the contract, including
870      * {IERC20-balanceOf} and {IERC20-transfer}.
871      */
872     function decimals() public view returns (uint8) {
873         return _decimals;
874     }
875 
876     /**
877      * @dev See {IERC20-totalSupply}.
878      */
879     function totalSupply() public view override returns (uint256) {
880         return _totalSupply;
881     }
882 
883     /**
884      * @dev See {IERC20-balanceOf}.
885      */
886     function balanceOf(address account) public view override returns (uint256) {
887         return _balances[account];
888     }
889 
890     /**
891      * @dev See {IERC20-transfer}.
892      *
893      * Requirements:
894      *
895      * - `recipient` cannot be the zero address.
896      * - the caller must have a balance of at least `amount`.
897      */
898     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
899         _transfer(_msgSender(), recipient, amount);
900         return true;
901     }
902 
903     /**
904      * @dev See {IERC20-allowance}.
905      */
906     function allowance(address owner, address spender) public view virtual override returns (uint256) {
907         return _allowances[owner][spender];
908     }
909 
910     /**
911      * @dev See {IERC20-approve}.
912      *
913      * Requirements:
914      *
915      * - `spender` cannot be the zero address.
916      */
917     function approve(address spender, uint256 amount) public virtual override returns (bool) {
918         _approve(_msgSender(), spender, amount);
919         return true;
920     }
921 
922     /**
923      * @dev See {IERC20-transferFrom}.
924      *
925      * Emits an {Approval} event indicating the updated allowance. This is not
926      * required by the EIP. See the note at the beginning of {ERC20};
927      *
928      * Requirements:
929      * - `sender` and `recipient` cannot be the zero address.
930      * - `sender` must have a balance of at least `amount`.
931      * - the caller must have allowance for ``sender``'s tokens of at least
932      * `amount`.
933      */
934     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
935         _transfer(sender, recipient, amount);
936         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
937         return true;
938     }
939 
940     /**
941      * @dev Atomically increases the allowance granted to `spender` by the caller.
942      *
943      * This is an alternative to {approve} that can be used as a mitigation for
944      * problems described in {IERC20-approve}.
945      *
946      * Emits an {Approval} event indicating the updated allowance.
947      *
948      * Requirements:
949      *
950      * - `spender` cannot be the zero address.
951      */
952     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
953         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
954         return true;
955     }
956 
957     /**
958      * @dev Atomically decreases the allowance granted to `spender` by the caller.
959      *
960      * This is an alternative to {approve} that can be used as a mitigation for
961      * problems described in {IERC20-approve}.
962      *
963      * Emits an {Approval} event indicating the updated allowance.
964      *
965      * Requirements:
966      *
967      * - `spender` cannot be the zero address.
968      * - `spender` must have allowance for the caller of at least
969      * `subtractedValue`.
970      */
971     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
972         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
973         return true;
974     }
975 
976     /**
977      * @dev Moves tokens `amount` from `sender` to `recipient`.
978      *
979      * This is internal function is equivalent to {transfer}, and can be used to
980      * e.g. implement automatic token fees, slashing mechanisms, etc.
981      *
982      * Emits a {Transfer} event.
983      *
984      * Requirements:
985      *
986      * - `sender` cannot be the zero address.
987      * - `recipient` cannot be the zero address.
988      * - `sender` must have a balance of at least `amount`.
989      */
990     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
991         require(sender != address(0), "ERC20: transfer from the zero address");
992         require(recipient != address(0), "ERC20: transfer to the zero address");
993 
994         _beforeTokenTransfer(sender, recipient, amount);
995 
996         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
997         _balances[recipient] = _balances[recipient].add(amount);
998         emit Transfer(sender, recipient, amount);
999     }
1000 
1001     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1002      * the total supply.
1003      *
1004      * Emits a {Transfer} event with `from` set to the zero address.
1005      *
1006      * Requirements
1007      *
1008      * - `to` cannot be the zero address.
1009      */
1010     function _mint(address account, uint256 amount) internal virtual {
1011         require(account != address(0), "ERC20: mint to the zero address");
1012 
1013         _beforeTokenTransfer(address(0), account, amount);
1014 
1015         _totalSupply = _totalSupply.add(amount);
1016         _balances[account] = _balances[account].add(amount);
1017         emit Transfer(address(0), account, amount);
1018     }
1019 
1020     /**
1021      * @dev Destroys `amount` tokens from `account`, reducing the
1022      * total supply.
1023      *
1024      * Emits a {Transfer} event with `to` set to the zero address.
1025      *
1026      * Requirements
1027      *
1028      * - `account` cannot be the zero address.
1029      * - `account` must have at least `amount` tokens.
1030      */
1031     function _burn(address account, uint256 amount) internal virtual {
1032         require(account != address(0), "ERC20: burn from the zero address");
1033 
1034         _beforeTokenTransfer(account, address(0), amount);
1035 
1036         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1037         _totalSupply = _totalSupply.sub(amount);
1038         emit Transfer(account, address(0), amount);
1039     }
1040 
1041     /**
1042      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1043      *
1044      * This is internal function is equivalent to `approve`, and can be used to
1045      * e.g. set automatic allowances for certain subsystems, etc.
1046      *
1047      * Emits an {Approval} event.
1048      *
1049      * Requirements:
1050      *
1051      * - `owner` cannot be the zero address.
1052      * - `spender` cannot be the zero address.
1053      */
1054     function _approve(address owner, address spender, uint256 amount) internal virtual {
1055         require(owner != address(0), "ERC20: approve from the zero address");
1056         require(spender != address(0), "ERC20: approve to the zero address");
1057 
1058         _allowances[owner][spender] = amount;
1059         emit Approval(owner, spender, amount);
1060     }
1061 
1062     /**
1063      * @dev Sets {decimals} to a value other than the default one of 18.
1064      *
1065      * WARNING: This function should only be called from the constructor. Most
1066      * applications that interact with token contracts will not expect
1067      * {decimals} to ever change, and may work incorrectly if it does.
1068      */
1069     function _setupDecimals(uint8 decimals_) internal {
1070         _decimals = decimals_;
1071     }
1072 
1073     /**
1074      * @dev Hook that is called before any transfer of tokens. This includes
1075      * minting and burning.
1076      *
1077      * Calling conditions:
1078      *
1079      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1080      * will be to transferred to `to`.
1081      * - when `from` is zero, `amount` tokens will be minted for `to`.
1082      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1083      * - `from` and `to` are never both zero.
1084      *
1085      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1086      */
1087     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1088 }
1089 
1090 // MFRMToken with Governance.
1091 contract MfrmToken is ERC20("MEME Farm Token", "MFRM"), Ownable {
1092     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1093     function mint(address _to, uint256 _amount) public onlyOwner {
1094         _mint(_to, _amount);
1095     }
1096 }
1097 
1098 // MasterChef is the master of Mfrm. He can make Mfrm and he is a fair guy.
1099 //
1100 // Note that it's ownable and the owner wields tremendous power. The ownership
1101 // will be transferred to a governance smart contract once Mfrm is sufficiently
1102 // distributed and the community can show to govern itself.
1103 //
1104 // Have fun reading it. Hopefully it's bug-free. God bless.
1105 contract MasterChef is Ownable {
1106     using SafeMath for uint256;
1107     using SafeERC20 for IERC20;
1108 
1109     // Info of each user.
1110     struct UserInfo {
1111         uint256 amount;     // How many LP tokens the user has provided.
1112         uint256 rewardDebt; // Reward debt. See explanation below.
1113         //
1114         // We do some fancy math here. Basically, any point in time, the amount of Mfrms
1115         // entitled to a user but is pending to be distributed is:
1116         //
1117         //   pending reward = (user.amount * pool.accMfrmPerShare) - user.rewardDebt
1118         //
1119         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1120         //   1. The pool's `accMfrmPerShare` (and `lastRewardBlock`) gets updated.
1121         //   2. User receives the pending reward sent to his/her address.
1122         //   3. User's `amount` gets updated.
1123         //   4. User's `rewardDebt` gets updated.
1124     }
1125 
1126     // Info of each pool.
1127     struct PoolInfo {
1128         IERC20 lpToken;           // Address of LP token contract.
1129         uint256 allocPoint;       // How many allocation points assigned to this pool. Mfrms to distribute per block.
1130         uint256 lastRewardBlock;  // Last block number that Mfrms distribution occurs.
1131         uint256 accMfrmPerShare; // Accumulated Mfrms per share, times 1e12. See below.
1132     }
1133 
1134     // The Mfrm TOKEN!
1135     MfrmToken public Mfrm;
1136     // Block number when bonus Mfrm period ends.
1137     uint256 public bonusEndBlock;
1138     // Mfrm tokens created per block.
1139     uint256 public MfrmPerBlock;
1140     // Bonus muliplier for early Mfrm makers.
1141     uint256 public constant BONUS_MULTIPLIER = 2; //2x multiplier until end of bonus period
1142     // Pool lptokens info
1143     mapping (IERC20 => bool) public lpTokensStatus;
1144     // Info of each pool.
1145     PoolInfo[] public poolInfo;
1146     // Info of each user that stakes LP tokens.
1147     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1148     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1149     uint256 public totalAllocPoint = 0;
1150     // The block number when Mfrm mining starts.
1151     uint256 public startBlock;
1152     // The DAO contract
1153     address public daoAddress;
1154     // percent of rewards that go to the DAO
1155     uint256 public daoPercent = 0;
1156     // The block number when distribution to the DAO starts
1157     uint256 public daoStartBlock;
1158 
1159     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1160     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1161     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1162 
1163     constructor(
1164         MfrmToken _Mfrm,
1165         uint256 _MfrmPerBlock,
1166         uint256 _startBlock,
1167         uint256 _bonusEndBlock,
1168         uint256 _daoStartBlock
1169     ) public {
1170         Mfrm = _Mfrm;
1171         MfrmPerBlock = _MfrmPerBlock;
1172         startBlock = _startBlock;
1173         bonusEndBlock = _bonusEndBlock; //NOTE: ETH block time is ~15 sec, so ~5760 blocks / day
1174         daoStartBlock = _daoStartBlock;
1175     }
1176 
1177     function poolLength() external view returns (uint256) {
1178         return poolInfo.length;
1179     }
1180 
1181     // Add a new lp to the pool. Can only be called by the owner.
1182     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1183         require(lpTokensStatus[_lpToken] != true, "LP token already added");
1184         if (_withUpdate) {
1185             massUpdatePools();
1186         }
1187         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1188         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1189         poolInfo.push(PoolInfo({
1190             lpToken: _lpToken,
1191             allocPoint: _allocPoint,
1192             lastRewardBlock: lastRewardBlock,
1193             accMfrmPerShare: 0
1194         }));
1195         lpTokensStatus[_lpToken] = true;
1196     }
1197 
1198     // Update the given pool's Mfrm allocation point. Can only be called by the owner.
1199     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1200         if (_withUpdate) {
1201             massUpdatePools();
1202         }
1203         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1204         poolInfo[_pid].allocPoint = _allocPoint;
1205     }
1206 
1207     // Return reward multiplier over the given _from to _to block.
1208     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1209         if (_to <= bonusEndBlock) {
1210             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1211         } else if (_from >= bonusEndBlock) {
1212             return _to.sub(_from);
1213         } else {
1214             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1215                 _to.sub(bonusEndBlock)
1216             );
1217         }
1218     }
1219 
1220     // View function to see pending Mfrms on frontend.
1221     function pendingMfrm(uint256 _pid, address _user) public view returns (uint256) {
1222         PoolInfo storage pool = poolInfo[_pid];
1223         UserInfo storage user = userInfo[_pid][_user];
1224         uint256 accMfrmPerShare = pool.accMfrmPerShare;
1225         uint256 PoolEndBlock =  block.number;
1226         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1227         if (PoolEndBlock > pool.lastRewardBlock && lpSupply != 0) {
1228             uint256 multiplier = getMultiplier(pool.lastRewardBlock, PoolEndBlock);
1229             uint256 MfrmReward = multiplier.mul(MfrmPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1230             if (PoolEndBlock > daoStartBlock){
1231                 uint256 daoReward = MfrmReward.mul(daoPercent).div(100);
1232                 MfrmReward = MfrmReward.sub(daoReward);
1233             }
1234             accMfrmPerShare = accMfrmPerShare.add(MfrmReward.mul(1e12).div(lpSupply));
1235         }
1236         return user.amount.mul(accMfrmPerShare).div(1e12).sub(user.rewardDebt);
1237     }
1238 
1239     function totalPending(address _user) external view returns (uint256) {
1240         uint256 total = 0;
1241         uint256 length = poolInfo.length;
1242         for (uint256 pid = 0; pid < length; ++pid) {
1243             total = total + pendingMfrm(pid, _user);
1244         }
1245         return(total);
1246     }
1247 
1248     // Update reward vairables for all pools. Be careful of gas spending!
1249     function massUpdatePools() public {
1250         uint256 length = poolInfo.length;
1251         for (uint256 pid = 0; pid < length; ++pid) {
1252             updatePool(pid);
1253         }
1254     }
1255 
1256     // Update reward variables of the given pool to be up-to-date.
1257     function updatePool(uint256 _pid) public {
1258         PoolInfo storage pool = poolInfo[_pid];
1259         if (block.number <= pool.lastRewardBlock) {
1260             return;
1261         }
1262         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1263         if (lpSupply == 0) {
1264             pool.lastRewardBlock = block.number;
1265             return;
1266         }
1267         
1268         uint256 PoolEndBlock =  block.number;
1269         uint256 multiplier = getMultiplier(pool.lastRewardBlock, PoolEndBlock);
1270         uint256 MfrmReward = multiplier.mul(MfrmPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1271         if (PoolEndBlock > daoStartBlock){
1272             uint256 daoReward = MfrmReward.mul(daoPercent).div(100);
1273             MfrmReward = MfrmReward.sub(daoReward);
1274             Mfrm.mint(daoAddress, daoReward);
1275         }
1276         Mfrm.mint(address(this), MfrmReward);
1277         pool.accMfrmPerShare = pool.accMfrmPerShare.add(MfrmReward.mul(1e12).div(lpSupply));
1278         pool.lastRewardBlock = PoolEndBlock;
1279     }
1280 
1281     // Deposit LP tokens to MasterChef for Mfrm allocation.
1282     function deposit(uint256 _pid, uint256 _amount) public {
1283         PoolInfo storage pool = poolInfo[_pid];
1284         UserInfo storage user = userInfo[_pid][msg.sender];
1285         updatePool(_pid);
1286         if (user.amount > 0) {
1287             uint256 pending = user.amount.mul(pool.accMfrmPerShare).div(1e12).sub(user.rewardDebt);
1288             if(pending > 0) {
1289                 safeMfrmTransfer(msg.sender, pending);
1290             }
1291         }
1292         if(_amount > 0) {
1293             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1294             user.amount = user.amount.add(_amount);
1295         }
1296         user.rewardDebt = user.amount.mul(pool.accMfrmPerShare).div(1e12);
1297         emit Deposit(msg.sender, _pid, _amount);
1298     }
1299 
1300     // Withdraw LP tokens from MasterChef.
1301     function withdraw(uint256 _pid, uint256 _amount) public {
1302         PoolInfo storage pool = poolInfo[_pid];
1303         UserInfo storage user = userInfo[_pid][msg.sender];
1304         require(user.amount >= _amount, "withdraw: not good");
1305         updatePool(_pid);
1306         uint256 pending = user.amount.mul(pool.accMfrmPerShare).div(1e12).sub(user.rewardDebt);
1307         safeMfrmTransfer(msg.sender, pending);
1308         user.amount = user.amount.sub(_amount);
1309         user.rewardDebt = user.amount.mul(pool.accMfrmPerShare).div(1e12);
1310         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1311         emit Withdraw(msg.sender, _pid, _amount);
1312     }
1313 
1314     // Withdraw without caring about rewards. EMERGENCY ONLY.
1315     function emergencyWithdraw(uint256 _pid) public {
1316         PoolInfo storage pool = poolInfo[_pid];
1317         UserInfo storage user = userInfo[_pid][msg.sender];
1318         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1319         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1320         user.amount = 0;
1321         user.rewardDebt = 0;
1322     }
1323 
1324     // Safe Mfrm transfer function, just in case if rounding error causes pool to not have enough Mfrms.
1325     function safeMfrmTransfer(address _to, uint256 _amount) internal {
1326         uint256 MfrmBal = Mfrm.balanceOf(address(this));
1327         if (_amount > MfrmBal) {
1328             Mfrm.transfer(_to, MfrmBal);
1329         } else {
1330             Mfrm.transfer(_to, _amount);
1331         }
1332     }
1333 
1334     function setupDAO(address _daoAddress, uint256 _daoPercent, uint256 _daoStartBlock) external onlyOwner {
1335         require(_daoPercent <= 50, "setupDAO: _daoPercent input too high");
1336         require(_daoStartBlock > block.number, "setupDAO: _daoStartBlock must be in future");
1337         massUpdatePools();
1338         daoAddress = _daoAddress;
1339         daoPercent = _daoPercent;
1340         daoStartBlock = _daoStartBlock;
1341     }
1342 
1343 }