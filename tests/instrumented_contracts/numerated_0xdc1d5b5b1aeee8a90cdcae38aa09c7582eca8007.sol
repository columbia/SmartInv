1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
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
81 
82 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
83 
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
244 
245 
246 pragma solidity ^0.6.2;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272         // for accounts without code, i.e. `keccak256('')`
273         bytes32 codehash;
274         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { codehash := extcodehash(account) }
277         return (codehash != accountHash && codehash != 0x0);
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
387 
388 
389 pragma solidity ^0.6.0;
390 
391 
392 
393 
394 /**
395  * @title SafeERC20
396  * @dev Wrappers around ERC20 operations that throw on failure (when the token
397  * contract returns false). Tokens that return no value (and instead revert or
398  * throw on failure) are also supported, non-reverting calls are assumed to be
399  * successful.
400  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
401  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
402  */
403 library SafeERC20 {
404     using SafeMath for uint256;
405     using Address for address;
406 
407     function safeTransfer(IERC20 token, address to, uint256 value) internal {
408         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
409     }
410 
411     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
412         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
413     }
414 
415     /**
416      * @dev Deprecated. This function has issues similar to the ones found in
417      * {IERC20-approve}, and its usage is discouraged.
418      *
419      * Whenever possible, use {safeIncreaseAllowance} and
420      * {safeDecreaseAllowance} instead.
421      */
422     function safeApprove(IERC20 token, address spender, uint256 value) internal {
423         // safeApprove should only be called when setting an initial allowance,
424         // or when resetting it to zero. To increase and decrease it, use
425         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
426         // solhint-disable-next-line max-line-length
427         require((value == 0) || (token.allowance(address(this), spender) == 0),
428             "SafeERC20: approve from non-zero to non-zero allowance"
429         );
430         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
431     }
432 
433     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
434         uint256 newAllowance = token.allowance(address(this), spender).add(value);
435         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
436     }
437 
438     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
439         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
440         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
441     }
442 
443     /**
444      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
445      * on the return value: the return value is optional (but if data is returned, it must not be false).
446      * @param token The token targeted by the call.
447      * @param data The call data (encoded using abi.encode or one of its variants).
448      */
449     function _callOptionalReturn(IERC20 token, bytes memory data) private {
450         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
451         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
452         // the target address contains contract code and also asserts for success in the low-level call.
453 
454         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
455         if (returndata.length > 0) { // Return data is optional
456             // solhint-disable-next-line max-line-length
457             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
458         }
459     }
460 }
461 
462 // File: @openzeppelin\contracts\utils\EnumerableSet.sol
463 
464 
465 pragma solidity ^0.6.0;
466 
467 /**
468  * @dev Library for managing
469  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
470  * types.
471  *
472  * Sets have the following properties:
473  *
474  * - Elements are added, removed, and checked for existence in constant time
475  * (O(1)).
476  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
477  *
478  * ```
479  * contract Example {
480  *     // Add the library methods
481  *     using EnumerableSet for EnumerableSet.AddressSet;
482  *
483  *     // Declare a set state variable
484  *     EnumerableSet.AddressSet private mySet;
485  * }
486  * ```
487  *
488  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
489  * (`UintSet`) are supported.
490  */
491 library EnumerableSet {
492     // To implement this library for multiple types with as little code
493     // repetition as possible, we write it in terms of a generic Set type with
494     // bytes32 values.
495     // The Set implementation uses private functions, and user-facing
496     // implementations (such as AddressSet) are just wrappers around the
497     // underlying Set.
498     // This means that we can only create new EnumerableSets for types that fit
499     // in bytes32.
500 
501     struct Set {
502         // Storage of set values
503         bytes32[] _values;
504 
505         // Position of the value in the `values` array, plus 1 because index 0
506         // means a value is not in the set.
507         mapping (bytes32 => uint256) _indexes;
508     }
509 
510     /**
511      * @dev Add a value to a set. O(1).
512      *
513      * Returns true if the value was added to the set, that is if it was not
514      * already present.
515      */
516     function _add(Set storage set, bytes32 value) private returns (bool) {
517         if (!_contains(set, value)) {
518             set._values.push(value);
519             // The value is stored at length-1, but we add 1 to all indexes
520             // and use 0 as a sentinel value
521             set._indexes[value] = set._values.length;
522             return true;
523         } else {
524             return false;
525         }
526     }
527 
528     /**
529      * @dev Removes a value from a set. O(1).
530      *
531      * Returns true if the value was removed from the set, that is if it was
532      * present.
533      */
534     function _remove(Set storage set, bytes32 value) private returns (bool) {
535         // We read and store the value's index to prevent multiple reads from the same storage slot
536         uint256 valueIndex = set._indexes[value];
537 
538         if (valueIndex != 0) { // Equivalent to contains(set, value)
539             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
540             // the array, and then remove the last element (sometimes called as 'swap and pop').
541             // This modifies the order of the array, as noted in {at}.
542 
543             uint256 toDeleteIndex = valueIndex - 1;
544             uint256 lastIndex = set._values.length - 1;
545 
546             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
547             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
548 
549             bytes32 lastvalue = set._values[lastIndex];
550 
551             // Move the last value to the index where the value to delete is
552             set._values[toDeleteIndex] = lastvalue;
553             // Update the index for the moved value
554             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
555 
556             // Delete the slot where the moved value was stored
557             set._values.pop();
558 
559             // Delete the index for the deleted slot
560             delete set._indexes[value];
561 
562             return true;
563         } else {
564             return false;
565         }
566     }
567 
568     /**
569      * @dev Returns true if the value is in the set. O(1).
570      */
571     function _contains(Set storage set, bytes32 value) private view returns (bool) {
572         return set._indexes[value] != 0;
573     }
574 
575     /**
576      * @dev Returns the number of values on the set. O(1).
577      */
578     function _length(Set storage set) private view returns (uint256) {
579         return set._values.length;
580     }
581 
582    /**
583     * @dev Returns the value stored at position `index` in the set. O(1).
584     *
585     * Note that there are no guarantees on the ordering of values inside the
586     * array, and it may change when more values are added or removed.
587     *
588     * Requirements:
589     *
590     * - `index` must be strictly less than {length}.
591     */
592     function _at(Set storage set, uint256 index) private view returns (bytes32) {
593         require(set._values.length > index, "EnumerableSet: index out of bounds");
594         return set._values[index];
595     }
596 
597     // AddressSet
598 
599     struct AddressSet {
600         Set _inner;
601     }
602 
603     /**
604      * @dev Add a value to a set. O(1).
605      *
606      * Returns true if the value was added to the set, that is if it was not
607      * already present.
608      */
609     function add(AddressSet storage set, address value) internal returns (bool) {
610         return _add(set._inner, bytes32(uint256(value)));
611     }
612 
613     /**
614      * @dev Removes a value from a set. O(1).
615      *
616      * Returns true if the value was removed from the set, that is if it was
617      * present.
618      */
619     function remove(AddressSet storage set, address value) internal returns (bool) {
620         return _remove(set._inner, bytes32(uint256(value)));
621     }
622 
623     /**
624      * @dev Returns true if the value is in the set. O(1).
625      */
626     function contains(AddressSet storage set, address value) internal view returns (bool) {
627         return _contains(set._inner, bytes32(uint256(value)));
628     }
629 
630     /**
631      * @dev Returns the number of values in the set. O(1).
632      */
633     function length(AddressSet storage set) internal view returns (uint256) {
634         return _length(set._inner);
635     }
636 
637    /**
638     * @dev Returns the value stored at position `index` in the set. O(1).
639     *
640     * Note that there are no guarantees on the ordering of values inside the
641     * array, and it may change when more values are added or removed.
642     *
643     * Requirements:
644     *
645     * - `index` must be strictly less than {length}.
646     */
647     function at(AddressSet storage set, uint256 index) internal view returns (address) {
648         return address(uint256(_at(set._inner, index)));
649     }
650 
651 
652     // UintSet
653 
654     struct UintSet {
655         Set _inner;
656     }
657 
658     /**
659      * @dev Add a value to a set. O(1).
660      *
661      * Returns true if the value was added to the set, that is if it was not
662      * already present.
663      */
664     function add(UintSet storage set, uint256 value) internal returns (bool) {
665         return _add(set._inner, bytes32(value));
666     }
667 
668     /**
669      * @dev Removes a value from a set. O(1).
670      *
671      * Returns true if the value was removed from the set, that is if it was
672      * present.
673      */
674     function remove(UintSet storage set, uint256 value) internal returns (bool) {
675         return _remove(set._inner, bytes32(value));
676     }
677 
678     /**
679      * @dev Returns true if the value is in the set. O(1).
680      */
681     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
682         return _contains(set._inner, bytes32(value));
683     }
684 
685     /**
686      * @dev Returns the number of values on the set. O(1).
687      */
688     function length(UintSet storage set) internal view returns (uint256) {
689         return _length(set._inner);
690     }
691 
692    /**
693     * @dev Returns the value stored at position `index` in the set. O(1).
694     *
695     * Note that there are no guarantees on the ordering of values inside the
696     * array, and it may change when more values are added or removed.
697     *
698     * Requirements:
699     *
700     * - `index` must be strictly less than {length}.
701     */
702     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
703         return uint256(_at(set._inner, index));
704     }
705 }
706 
707 // File: @openzeppelin\contracts\math\Math.sol
708 
709 
710 pragma solidity ^0.6.0;
711 
712 /**
713  * @dev Standard math utilities missing in the Solidity language.
714  */
715 library Math {
716     /**
717      * @dev Returns the largest of two numbers.
718      */
719     function max(uint256 a, uint256 b) internal pure returns (uint256) {
720         return a >= b ? a : b;
721     }
722 
723     /**
724      * @dev Returns the smallest of two numbers.
725      */
726     function min(uint256 a, uint256 b) internal pure returns (uint256) {
727         return a < b ? a : b;
728     }
729 
730     /**
731      * @dev Returns the average of two numbers. The result is rounded towards
732      * zero.
733      */
734     function average(uint256 a, uint256 b) internal pure returns (uint256) {
735         // (a + b) / 2 can overflow, so we distribute
736         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
737     }
738 }
739 
740 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
741 
742 
743 pragma solidity ^0.6.0;
744 
745 /*
746  * @dev Provides information about the current execution context, including the
747  * sender of the transaction and its data. While these are generally available
748  * via msg.sender and msg.data, they should not be accessed in such a direct
749  * manner, since when dealing with GSN meta-transactions the account sending and
750  * paying for execution may not be the actual sender (as far as an application
751  * is concerned).
752  *
753  * This contract is only required for intermediate, library-like contracts.
754  */
755 abstract contract Context {
756     function _msgSender() internal view virtual returns (address payable) {
757         return msg.sender;
758     }
759 
760     function _msgData() internal view virtual returns (bytes memory) {
761         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
762         return msg.data;
763     }
764 }
765 
766 // File: @openzeppelin\contracts\access\Ownable.sol
767 
768 
769 pragma solidity ^0.6.0;
770 
771 /**
772  * @dev Contract module which provides a basic access control mechanism, where
773  * there is an account (an owner) that can be granted exclusive access to
774  * specific functions.
775  *
776  * By default, the owner account will be the one that deploys the contract. This
777  * can later be changed with {transferOwnership}.
778  *
779  * This module is used through inheritance. It will make available the modifier
780  * `onlyOwner`, which can be applied to your functions to restrict their use to
781  * the owner.
782  */
783 contract Ownable is Context {
784     address private _owner;
785 
786     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
787 
788     /**
789      * @dev Initializes the contract setting the deployer as the initial owner.
790      */
791     constructor () internal {
792         address msgSender = _msgSender();
793         _owner = msgSender;
794         emit OwnershipTransferred(address(0), msgSender);
795     }
796 
797     /**
798      * @dev Returns the address of the current owner.
799      */
800     function owner() public view returns (address) {
801         return _owner;
802     }
803 
804     /**
805      * @dev Throws if called by any account other than the owner.
806      */
807     modifier onlyOwner() {
808         require(_owner == _msgSender(), "Ownable: caller is not the owner");
809         _;
810     }
811 
812     /**
813      * @dev Leaves the contract without owner. It will not be possible to call
814      * `onlyOwner` functions anymore. Can only be called by the current owner.
815      *
816      * NOTE: Renouncing ownership will leave the contract without an owner,
817      * thereby removing any functionality that is only available to the owner.
818      */
819     function renounceOwnership() public virtual onlyOwner {
820         emit OwnershipTransferred(_owner, address(0));
821         _owner = address(0);
822     }
823 
824     /**
825      * @dev Transfers ownership of the contract to a new account (`newOwner`).
826      * Can only be called by the current owner.
827      */
828     function transferOwnership(address newOwner) public virtual onlyOwner {
829         require(newOwner != address(0), "Ownable: new owner is the zero address");
830         emit OwnershipTransferred(_owner, newOwner);
831         _owner = newOwner;
832     }
833 }
834 
835 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
836 
837 
838 pragma solidity ^0.6.0;
839 
840 
841 
842 
843 
844 /**
845  * @dev Implementation of the {IERC20} interface.
846  *
847  * This implementation is agnostic to the way tokens are created. This means
848  * that a supply mechanism has to be added in a derived contract using {_mint}.
849  * For a generic mechanism see {ERC20PresetMinterPauser}.
850  *
851  * TIP: For a detailed writeup see our guide
852  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
853  * to implement supply mechanisms].
854  *
855  * We have followed general OpenZeppelin guidelines: functions revert instead
856  * of returning `false` on failure. This behavior is nonetheless conventional
857  * and does not conflict with the expectations of ERC20 applications.
858  *
859  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
860  * This allows applications to reconstruct the allowance for all accounts just
861  * by listening to said events. Other implementations of the EIP may not emit
862  * these events, as it isn't required by the specification.
863  *
864  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
865  * functions have been added to mitigate the well-known issues around setting
866  * allowances. See {IERC20-approve}.
867  */
868 contract ERC20 is Context, IERC20 {
869     using SafeMath for uint256;
870     using Address for address;
871 
872     mapping (address => uint256) private _balances;
873 
874     mapping (address => mapping (address => uint256)) private _allowances;
875 
876     uint256 private _totalSupply;
877 
878     string private _name;
879     string private _symbol;
880     uint8 private _decimals;
881 
882     /**
883      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
884      * a default value of 18.
885      *
886      * To select a different value for {decimals}, use {_setupDecimals}.
887      *
888      * All three of these values are immutable: they can only be set once during
889      * construction.
890      */
891     constructor (string memory name, string memory symbol) public {
892         _name = name;
893         _symbol = symbol;
894         _decimals = 18;
895     }
896 
897     /**
898      * @dev Returns the name of the token.
899      */
900     function name() public view returns (string memory) {
901         return _name;
902     }
903 
904     /**
905      * @dev Returns the symbol of the token, usually a shorter version of the
906      * name.
907      */
908     function symbol() public view returns (string memory) {
909         return _symbol;
910     }
911 
912     /**
913      * @dev Returns the number of decimals used to get its user representation.
914      * For example, if `decimals` equals `2`, a balance of `505` tokens should
915      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
916      *
917      * Tokens usually opt for a value of 18, imitating the relationship between
918      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
919      * called.
920      *
921      * NOTE: This information is only used for _display_ purposes: it in
922      * no way affects any of the arithmetic of the contract, including
923      * {IERC20-balanceOf} and {IERC20-transfer}.
924      */
925     function decimals() public view returns (uint8) {
926         return _decimals;
927     }
928 
929     /**
930      * @dev See {IERC20-totalSupply}.
931      */
932     function totalSupply() public view override returns (uint256) {
933         return _totalSupply;
934     }
935 
936     /**
937      * @dev See {IERC20-balanceOf}.
938      */
939     function balanceOf(address account) public view override returns (uint256) {
940         return _balances[account];
941     }
942 
943     /**
944      * @dev See {IERC20-transfer}.
945      *
946      * Requirements:
947      *
948      * - `recipient` cannot be the zero address.
949      * - the caller must have a balance of at least `amount`.
950      */
951     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
952         _transfer(_msgSender(), recipient, amount);
953         return true;
954     }
955 
956     /**
957      * @dev See {IERC20-allowance}.
958      */
959     function allowance(address owner, address spender) public view virtual override returns (uint256) {
960         return _allowances[owner][spender];
961     }
962 
963     /**
964      * @dev See {IERC20-approve}.
965      *
966      * Requirements:
967      *
968      * - `spender` cannot be the zero address.
969      */
970     function approve(address spender, uint256 amount) public virtual override returns (bool) {
971         _approve(_msgSender(), spender, amount);
972         return true;
973     }
974 
975     /**
976      * @dev See {IERC20-transferFrom}.
977      *
978      * Emits an {Approval} event indicating the updated allowance. This is not
979      * required by the EIP. See the note at the beginning of {ERC20};
980      *
981      * Requirements:
982      * - `sender` and `recipient` cannot be the zero address.
983      * - `sender` must have a balance of at least `amount`.
984      * - the caller must have allowance for ``sender``'s tokens of at least
985      * `amount`.
986      */
987     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
988         _transfer(sender, recipient, amount);
989         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
990         return true;
991     }
992 
993     /**
994      * @dev Atomically increases the allowance granted to `spender` by the caller.
995      *
996      * This is an alternative to {approve} that can be used as a mitigation for
997      * problems described in {IERC20-approve}.
998      *
999      * Emits an {Approval} event indicating the updated allowance.
1000      *
1001      * Requirements:
1002      *
1003      * - `spender` cannot be the zero address.
1004      */
1005     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1006         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1007         return true;
1008     }
1009 
1010     /**
1011      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1012      *
1013      * This is an alternative to {approve} that can be used as a mitigation for
1014      * problems described in {IERC20-approve}.
1015      *
1016      * Emits an {Approval} event indicating the updated allowance.
1017      *
1018      * Requirements:
1019      *
1020      * - `spender` cannot be the zero address.
1021      * - `spender` must have allowance for the caller of at least
1022      * `subtractedValue`.
1023      */
1024     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1025         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1026         return true;
1027     }
1028 
1029     /**
1030      * @dev Moves tokens `amount` from `sender` to `recipient`.
1031      *
1032      * This is internal function is equivalent to {transfer}, and can be used to
1033      * e.g. implement automatic token fees, slashing mechanisms, etc.
1034      *
1035      * Emits a {Transfer} event.
1036      *
1037      * Requirements:
1038      *
1039      * - `sender` cannot be the zero address.
1040      * - `recipient` cannot be the zero address.
1041      * - `sender` must have a balance of at least `amount`.
1042      */
1043     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1044         require(sender != address(0), "ERC20: transfer from the zero address");
1045         require(recipient != address(0), "ERC20: transfer to the zero address");
1046 
1047         _beforeTokenTransfer(sender, recipient, amount);
1048 
1049         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1050         _balances[recipient] = _balances[recipient].add(amount);
1051         emit Transfer(sender, recipient, amount);
1052     }
1053 
1054     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1055      * the total supply.
1056      *
1057      * Emits a {Transfer} event with `from` set to the zero address.
1058      *
1059      * Requirements
1060      *
1061      * - `to` cannot be the zero address.
1062      */
1063     function _mint(address account, uint256 amount) internal virtual {
1064         require(account != address(0), "ERC20: mint to the zero address");
1065 
1066         _beforeTokenTransfer(address(0), account, amount);
1067 
1068         _totalSupply = _totalSupply.add(amount);
1069         _balances[account] = _balances[account].add(amount);
1070         emit Transfer(address(0), account, amount);
1071     }
1072 
1073     /**
1074      * @dev Destroys `amount` tokens from `account`, reducing the
1075      * total supply.
1076      *
1077      * Emits a {Transfer} event with `to` set to the zero address.
1078      *
1079      * Requirements
1080      *
1081      * - `account` cannot be the zero address.
1082      * - `account` must have at least `amount` tokens.
1083      */
1084     function _burn(address account, uint256 amount) internal virtual {
1085         require(account != address(0), "ERC20: burn from the zero address");
1086 
1087         _beforeTokenTransfer(account, address(0), amount);
1088 
1089         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1090         _totalSupply = _totalSupply.sub(amount);
1091         emit Transfer(account, address(0), amount);
1092     }
1093 
1094     /**
1095      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1096      *
1097      * This is internal function is equivalent to `approve`, and can be used to
1098      * e.g. set automatic allowances for certain subsystems, etc.
1099      *
1100      * Emits an {Approval} event.
1101      *
1102      * Requirements:
1103      *
1104      * - `owner` cannot be the zero address.
1105      * - `spender` cannot be the zero address.
1106      */
1107     function _approve(address owner, address spender, uint256 amount) internal virtual {
1108         require(owner != address(0), "ERC20: approve from the zero address");
1109         require(spender != address(0), "ERC20: approve to the zero address");
1110 
1111         _allowances[owner][spender] = amount;
1112         emit Approval(owner, spender, amount);
1113     }
1114 
1115     /**
1116      * @dev Sets {decimals} to a value other than the default one of 18.
1117      *
1118      * WARNING: This function should only be called from the constructor. Most
1119      * applications that interact with token contracts will not expect
1120      * {decimals} to ever change, and may work incorrectly if it does.
1121      */
1122     function _setupDecimals(uint8 decimals_) internal {
1123         _decimals = decimals_;
1124     }
1125 
1126     /**
1127      * @dev Hook that is called before any transfer of tokens. This includes
1128      * minting and burning.
1129      *
1130      * Calling conditions:
1131      *
1132      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1133      * will be to transferred to `to`.
1134      * - when `from` is zero, `amount` tokens will be minted for `to`.
1135      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1136      * - `from` and `to` are never both zero.
1137      *
1138      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1139      */
1140     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1141 }
1142 
1143 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
1144 
1145 
1146 pragma solidity ^0.6.0;
1147 
1148 
1149 
1150 /**
1151  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1152  * tokens and those that they have an allowance for, in a way that can be
1153  * recognized off-chain (via event analysis).
1154  */
1155 abstract contract ERC20Burnable is Context, ERC20 {
1156     /**
1157      * @dev Destroys `amount` tokens from the caller.
1158      *
1159      * See {ERC20-_burn}.
1160      */
1161     function burn(uint256 amount) public virtual {
1162         _burn(_msgSender(), amount);
1163     }
1164 
1165     /**
1166      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1167      * allowance.
1168      *
1169      * See {ERC20-_burn} and {ERC20-allowance}.
1170      *
1171      * Requirements:
1172      *
1173      * - the caller must have allowance for ``accounts``'s tokens of at least
1174      * `amount`.
1175      */
1176     function burnFrom(address account, uint256 amount) public virtual {
1177         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1178 
1179         _approve(account, _msgSender(), decreasedAllowance);
1180         _burn(account, amount);
1181     }
1182 }
1183 
1184 // File: contracts\DelegateERC20.sol
1185 
1186 pragma solidity 0.6.12;
1187 
1188 
1189 abstract contract DelegateERC20 is ERC20Burnable {
1190     // @notice A record of each accounts delegate
1191     mapping(address => address) internal _delegates;
1192 
1193     /// @notice A checkpoint for marking number of votes from a given block
1194     struct Checkpoint {
1195         uint32 fromBlock;
1196         uint256 votes;
1197     }
1198 
1199     /// @notice A record of votes checkpoints for each account, by index
1200     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1201 
1202     /// @notice The number of checkpoints for each account
1203     mapping(address => uint32) public numCheckpoints;
1204 
1205     /// @notice The EIP-712 typehash for the contract's domain
1206     bytes32 public constant DOMAIN_TYPEHASH =
1207         keccak256('EIP712Domain(string name,uint256 chainId,address verifyingContract)');
1208 
1209     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1210     bytes32 public constant DELEGATION_TYPEHASH =
1211         keccak256('Delegation(address delegatee,uint256 nonce,uint256 expiry)');
1212 
1213     /// @notice A record of states for signing / validating signatures
1214     mapping(address => uint256) public nonces;
1215 
1216     // support delegates mint
1217     function _mint(address account, uint256 amount) internal virtual override {
1218         super._mint(account, amount);
1219 
1220         // add delegates to the minter
1221         _moveDelegates(address(0), _delegates[account], amount);
1222     }
1223 
1224     function _transfer(
1225         address sender,
1226         address recipient,
1227         uint256 amount
1228     ) internal virtual override {
1229         super._transfer(sender, recipient, amount);
1230         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1231     }
1232 
1233     // support delegates burn
1234     function burn(uint256 amount) public virtual override {
1235         super.burn(amount);
1236 
1237         // del delegates to backhole
1238         _moveDelegates(_delegates[_msgSender()], address(0), amount);
1239     }
1240 
1241     function burnFrom(address account, uint256 amount) public virtual override {
1242         super.burnFrom(account, amount);
1243 
1244         // del delegates to the backhole
1245         _moveDelegates(_delegates[account], address(0), amount);
1246     }
1247 
1248     /**
1249      * @notice Delegate votes from `msg.sender` to `delegatee`
1250      * @param delegatee The address to delegate votes to
1251      */
1252     function delegate(address delegatee) external {
1253         return _delegate(msg.sender, delegatee);
1254     }
1255 
1256     /**
1257      * @notice Delegates votes from signatory to `delegatee`
1258      * @param delegatee The address to delegate votes to
1259      * @param nonce The contract state required to match the signature
1260      * @param expiry The time at which to expire the signature
1261      * @param v The recovery byte of the signature
1262      * @param r Half of the ECDSA signature pair
1263      * @param s Half of the ECDSA signature pair
1264      */
1265     function delegateBySig(
1266         address delegatee,
1267         uint256 nonce,
1268         uint256 expiry,
1269         uint8 v,
1270         bytes32 r,
1271         bytes32 s
1272     ) external {
1273         bytes32 domainSeparator =
1274             keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), getChainId(), address(this)));
1275 
1276         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
1277 
1278         bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainSeparator, structHash));
1279 
1280         address signatory = ecrecover(digest, v, r, s);
1281         require(signatory != address(0), 'Governance::delegateBySig: invalid signature');
1282         require(nonce == nonces[signatory]++, 'Governance::delegateBySig: invalid nonce');
1283         require(now <= expiry, 'Governance::delegateBySig: signature expired');
1284         return _delegate(signatory, delegatee);
1285     }
1286 
1287     /**
1288      * @notice Gets the current votes balance for `account`
1289      * @param account The address to get votes balance
1290      * @return The number of current votes for `account`
1291      */
1292     function getCurrentVotes(address account) external view returns (uint256) {
1293         uint32 nCheckpoints = numCheckpoints[account];
1294         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1295     }
1296 
1297     /**
1298      * @notice Determine the prior number of votes for an account as of a block number
1299      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1300      * @param account The address of the account to check
1301      * @param blockNumber The block number to get the vote balance at
1302      * @return The number of votes the account had as of the given block
1303      */
1304     function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256) {
1305         require(blockNumber < block.number, 'Governance::getPriorVotes: not yet determined');
1306 
1307         uint32 nCheckpoints = numCheckpoints[account];
1308         if (nCheckpoints == 0) {
1309             return 0;
1310         }
1311 
1312         // First check most recent balance
1313         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1314             return checkpoints[account][nCheckpoints - 1].votes;
1315         }
1316 
1317         // Next check implicit zero balance
1318         if (checkpoints[account][0].fromBlock > blockNumber) {
1319             return 0;
1320         }
1321 
1322         uint32 lower = 0;
1323         uint32 upper = nCheckpoints - 1;
1324         while (upper > lower) {
1325             uint32 center = upper - (upper - lower) / 2;
1326             // ceil, avoiding overflow
1327             Checkpoint memory cp = checkpoints[account][center];
1328             if (cp.fromBlock == blockNumber) {
1329                 return cp.votes;
1330             } else if (cp.fromBlock < blockNumber) {
1331                 lower = center;
1332             } else {
1333                 upper = center - 1;
1334             }
1335         }
1336         return checkpoints[account][lower].votes;
1337     }
1338 
1339     function _delegate(address delegator, address delegatee) internal {
1340         address currentDelegate = _delegates[delegator];
1341         uint256 delegatorBalance = balanceOf(delegator);
1342         // balance of underlying balances (not scaled);
1343         _delegates[delegator] = delegatee;
1344 
1345         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1346 
1347         emit DelegateChanged(delegator, currentDelegate, delegatee);
1348     }
1349 
1350     function _moveDelegates(
1351         address srcRep,
1352         address dstRep,
1353         uint256 amount
1354     ) internal {
1355         if (srcRep != dstRep && amount > 0) {
1356             if (srcRep != address(0)) {
1357                 // decrease old representative
1358                 uint32 srcRepNum = numCheckpoints[srcRep];
1359                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1360                 uint256 srcRepNew = srcRepOld.sub(amount);
1361                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1362             }
1363 
1364             if (dstRep != address(0)) {
1365                 // increase new representative
1366                 uint32 dstRepNum = numCheckpoints[dstRep];
1367                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1368                 uint256 dstRepNew = dstRepOld.add(amount);
1369                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1370             }
1371         }
1372     }
1373 
1374     function _writeCheckpoint(
1375         address delegatee,
1376         uint32 nCheckpoints,
1377         uint256 oldVotes,
1378         uint256 newVotes
1379     ) internal {
1380         uint32 blockNumber = safe32(block.number, 'Governance::_writeCheckpoint: block number exceeds 32 bits');
1381 
1382         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1383             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1384         } else {
1385             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1386             numCheckpoints[delegatee] = nCheckpoints + 1;
1387         }
1388 
1389         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1390     }
1391 
1392     function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
1393         require(n < 2**32, errorMessage);
1394         return uint32(n);
1395     }
1396 
1397     function getChainId() internal pure returns (uint256) {
1398         uint256 chainId;
1399         assembly {
1400             chainId := chainid()
1401         }
1402 
1403         return chainId;
1404     }
1405 
1406     /// @notice An event thats emitted when an account changes its delegate
1407     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1408 
1409     /// @notice An event thats emitted when a delegate account's vote balance changes
1410     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1411 }
1412 
1413 // File: contracts\AdamToken.sol
1414 
1415 
1416 pragma solidity 0.6.12;
1417 
1418 
1419 
1420 
1421 // AdamToken with Governance.
1422 contract AdamToken is DelegateERC20, Ownable {
1423     constructor() public ERC20('AdamToken', 'ADAM') {}
1424 
1425     function mint(address _to, uint256 _amount) public onlyOwner {
1426         _mint(_to, _amount);
1427     }
1428 }
1429 
1430 // File: @openzeppelin\contracts\token\ERC20\ERC20Capped.sol
1431 
1432 
1433 pragma solidity ^0.6.0;
1434 
1435 
1436 /**
1437  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1438  */
1439 abstract contract ERC20Capped is ERC20 {
1440     uint256 private _cap;
1441 
1442     /**
1443      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1444      * set once during construction.
1445      */
1446     constructor (uint256 cap) public {
1447         require(cap > 0, "ERC20Capped: cap is 0");
1448         _cap = cap;
1449     }
1450 
1451     /**
1452      * @dev Returns the cap on the token's total supply.
1453      */
1454     function cap() public view returns (uint256) {
1455         return _cap;
1456     }
1457 
1458     /**
1459      * @dev See {ERC20-_beforeTokenTransfer}.
1460      *
1461      * Requirements:
1462      *
1463      * - minted tokens must not cause the total supply to go over the cap.
1464      */
1465     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1466         super._beforeTokenTransfer(from, to, amount);
1467 
1468         if (from == address(0)) { // When minting tokens
1469             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1470         }
1471     }
1472 }
1473 
1474 // File: contracts\AGlobalShoppingToken.sol
1475 
1476 pragma solidity 0.6.12;
1477 
1478 
1479 
1480 
1481 contract AGlobalShoppingToken is ERC20Capped, Ownable {
1482     constructor()
1483         public
1484         ERC20Capped(100_000_000e18)
1485         ERC20("A Global Shopping Token", "AGST")
1486     {}
1487 
1488     function mint(address _to, uint256 _amount) public onlyOwner {
1489         _mint(_to, _amount);
1490     }
1491 }
1492 
1493 // File: contracts\IReferrerBook.sol
1494 
1495 pragma solidity 0.6.12;
1496 
1497 interface IReferrerBook {
1498     function getReferrer(address addr) external view returns(address);
1499     function getLevelDiffedReferrers(address addr) external view returns (address[2] memory);
1500 }
1501 
1502 // File: contracts\MiningPool.sol
1503 
1504 pragma solidity 0.6.12;
1505 
1506 
1507 
1508 
1509 
1510 
1511 
1512 
1513 
1514 
1515 interface IMigratorChef {
1516     // Perform LP token migration from legacy UniswapV2 to AdamSwap.
1517     // Take the current LP token address and return the new LP token address.
1518     // Migrator should have full access to the caller's LP token.
1519     // Return the new LP token address.
1520     //
1521     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1522     // AdamSwap must mint EXACTLY the same amount of AdamSwap LP tokens or
1523     // else something bad will happen. Traditional UniswapV2 does not
1524     // do that so be careful!
1525     function migrate(IERC20 token) external returns (IERC20);
1526 }
1527 
1528 contract MiningPool is Ownable {
1529     using SafeMath for uint256;
1530     using SafeERC20 for IERC20;
1531 
1532     // Info of each user.
1533     struct UserInfo {
1534         uint256 amount; // How many LP tokens the user has provided.
1535         uint256 rewardAdamDebt; // Reward debt. See explanation below.
1536         uint256 rewardAgstDebt;
1537         //
1538         // We do some fancy math here. Basically, any point in time, the amount of ADAMs
1539         // entitled to a user but is pending to be distributed is:
1540         //
1541         //   pending reward = (user.amount * pool.accAdamPerShare) - user.rewardDebt
1542         //
1543         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1544         //   1. The pool's `accAdamPerShare` (and `lastRewardBlock`) gets updated.
1545         //   2. User receives the pending reward sent to his/her address.
1546         //   3. User's `amount` gets updated.
1547         //   4. User's `rewardDebt` gets updated.
1548     }
1549 
1550     // Info of each pool.
1551     struct PoolInfo {
1552         IERC20 lpToken; // Address of LP token contract.
1553         uint256 allocPoint; // How many allocation points assigned to this pool. ADAMs to distribute per block.
1554         uint256 lastRewardBlock; // Last block number that ADAMs distribution occurs.
1555         uint256 accAdamPerShare; // Accumulated ADAMs per share, times 1e12. See below.
1556         uint256 accAgstPerShare;
1557         bool needReferral;
1558     }
1559 
1560     uint256 private constant MAX_USER_LEVEL = 2;
1561     //sharing percents, 10000 == 100%
1562     uint256 private constant REFERRER_SHARE_PCT = 1100; //11%
1563     uint256 private constant NODE_SHARE_LV1_PCT = 500;  //5%
1564     uint256 private constant NODE_SHARE_LV2_PCT = 400;  //4%
1565     uint256 private constant NODE_SHARE_TOTAL_PCT = NODE_SHARE_LV1_PCT + NODE_SHARE_LV2_PCT;
1566     uint256 private constant REFERRAL_TOTAL_PCT = REFERRER_SHARE_PCT + NODE_SHARE_TOTAL_PCT;
1567     uint256 private constant USER_SHARE_PCT = 10000 - REFERRAL_TOTAL_PCT;
1568 
1569     mapping(address => uint256) public referrerAdamRewards;
1570     mapping(address => uint256) public referrerAgstRewards;
1571 
1572     // The ADAM TOKEN!
1573     AdamToken public adam;
1574     AGlobalShoppingToken public agst;
1575     IReferrerBook public refBook;
1576     // Dev address.
1577     address public devaddr;
1578     // Block number when bonus ADAM period ends.
1579     uint256 public bonusEndBlock;
1580     // ADAM tokens created per block.
1581     uint256 public adamPerBlock;
1582     // Bonus muliplier for early adam makers.
1583     uint256 public constant BONUS_MULTIPLIER = 12;
1584     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1585     IMigratorChef public migrator;
1586 
1587     // Info of each pool.
1588     PoolInfo[] public poolInfo;
1589     // Info of each user that stakes LP tokens.
1590     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1591     // Total allocation points. Must be the sum of all allocation points in all pools.
1592     uint256 public totalAllocPoint = 0;
1593     // The block number when ADAM mining starts.
1594     uint256 public startBlock;
1595 
1596     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1597     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1598     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1599 
1600     constructor(
1601         AdamToken _adam,
1602         AGlobalShoppingToken _agst,
1603         IReferrerBook _refBook,
1604         address _devaddr,
1605         uint256 _adamPerBlock,
1606         uint256 _startBlock,
1607         uint256 _bonusEndBlock
1608     ) public {
1609         adam = _adam;
1610         agst = _agst;
1611         refBook = _refBook;
1612         devaddr = _devaddr;
1613         adamPerBlock = _adamPerBlock;
1614         bonusEndBlock = _bonusEndBlock;
1615         startBlock = _startBlock;
1616     }
1617 
1618     function poolLength() external view returns (uint256) {
1619         return poolInfo.length;
1620     }
1621 
1622     // Add a new lp to the pool. Can only be called by the owner.
1623     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1624     function add(
1625         uint256 _allocPoint,
1626         IERC20 _lpToken,
1627         bool _needReferral,
1628         bool _withUpdate
1629     ) public onlyOwner {
1630         if (_withUpdate) {
1631             massUpdatePools();
1632         }
1633         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1634         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1635         poolInfo.push(
1636             PoolInfo({
1637                 lpToken: _lpToken,
1638                 allocPoint: _allocPoint,
1639                 lastRewardBlock: lastRewardBlock,
1640                 accAdamPerShare: 0,
1641                 accAgstPerShare: 0,
1642                 needReferral: _needReferral
1643             })
1644         );
1645     }
1646 
1647     // Update the given pool's ADAM allocation point. Can only be called by the owner.
1648     function set(
1649         uint256 _pid,
1650         uint256 _allocPoint,
1651         bool _withUpdate
1652     ) public onlyOwner {
1653         if (_withUpdate) {
1654             massUpdatePools();
1655         }
1656         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1657         poolInfo[_pid].allocPoint = _allocPoint;
1658     }
1659 
1660     // Set the migrator contract. Can only be called by the owner.
1661     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1662         migrator = _migrator;
1663     }
1664 
1665     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1666     function migrate(uint256 _pid) public {
1667         require(address(migrator) != address(0), 'migrate: no migrator');
1668         PoolInfo storage pool = poolInfo[_pid];
1669         IERC20 lpToken = pool.lpToken;
1670         uint256 bal = lpToken.balanceOf(address(this));
1671         lpToken.safeApprove(address(migrator), bal);
1672         IERC20 newLpToken = migrator.migrate(lpToken);
1673         require(bal == newLpToken.balanceOf(address(this)), 'migrate: bad');
1674         pool.lpToken = newLpToken;
1675     }
1676 
1677     // Return reward multiplier over the given _from to _to block.
1678     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1679         if (_to <= bonusEndBlock) {
1680             return _to.sub(_from).mul(BONUS_MULTIPLIER).div(10);
1681         } else if (_from >= bonusEndBlock) {
1682             return _to.sub(_from);
1683         } else {
1684             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).div(10).add(_to.sub(bonusEndBlock));
1685         }
1686     }
1687 
1688     // View function to see pending ADAMs on frontend.
1689     function pendingAdam(uint256 _pid, address _user) external view returns (uint256) {
1690         PoolInfo storage pool = poolInfo[_pid];
1691         UserInfo storage user = userInfo[_pid][_user];
1692         uint256 accAdamPerShare = pool.accAdamPerShare;
1693         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1694         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1695             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1696             uint256 adamReward = multiplier.mul(adamPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1697             accAdamPerShare = accAdamPerShare.add(adamReward.mul(1e12).div(lpSupply));
1698         }
1699         return user.amount.mul(accAdamPerShare).div(1e12).sub(user.rewardAdamDebt).mul(USER_SHARE_PCT).div(10000);
1700     }
1701 
1702     function pendingAGST(uint256 _pid, address _user) external view returns (uint256) {
1703         PoolInfo storage pool = poolInfo[_pid];
1704         UserInfo storage user = userInfo[_pid][_user];
1705         uint256 accAgstPerShare = pool.accAgstPerShare;
1706         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1707         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1708             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1709             uint256 agstReward = multiplier.mul(adamPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1710             agstReward = Math.min(agstReward, agst.cap().sub(agst.totalSupply()));
1711             accAgstPerShare = accAgstPerShare.add(agstReward.mul(1e12).div(lpSupply));
1712         }
1713         return user.amount.mul(accAgstPerShare).div(1e12).sub(user.rewardAgstDebt).mul(USER_SHARE_PCT).div(10000);
1714     }
1715 
1716     // Update reward variables for all pools. Be careful of gas spending!
1717     function massUpdatePools() public {
1718         uint256 length = poolInfo.length;
1719         for (uint256 pid = 0; pid < length; ++pid) {
1720             updatePool(pid);
1721         }
1722     }
1723 
1724     // Update reward variables of the given pool to be up-to-date.
1725     function updatePool(uint256 _pid) public {
1726         PoolInfo storage pool = poolInfo[_pid];
1727         if (block.number <= pool.lastRewardBlock) {
1728             return;
1729         }
1730         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1731         if (lpSupply == 0) {
1732             pool.lastRewardBlock = block.number;
1733             return;
1734         }
1735 
1736         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1737         uint256 adamReward = multiplier.mul(adamPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1738 
1739         adam.mint(devaddr, adamReward.div(10));
1740         adam.mint(address(this), adamReward);
1741 
1742         uint256 agstReward = Math.min(adamReward, agst.cap().sub(agst.totalSupply()));
1743         if(agstReward > 0) {
1744             agst.mint(address(this), agstReward);
1745         }
1746         
1747         pool.accAdamPerShare = pool.accAdamPerShare.add(adamReward.mul(1e12).div(lpSupply));
1748         pool.accAgstPerShare = pool.accAgstPerShare.add(agstReward.mul(1e12).div(lpSupply));
1749         pool.lastRewardBlock = block.number;
1750     }
1751 
1752     // Deposit LP tokens to MasterChef for ADAM allocation.
1753     function deposit(uint256 _pid, uint256 _amount) public {
1754         PoolInfo storage pool = poolInfo[_pid];
1755 
1756         if (pool.needReferral) {
1757             require(refBook.getReferrer(msg.sender) != address(0), 'Need referrer');
1758         }
1759 
1760         UserInfo storage user = userInfo[_pid][msg.sender];
1761         updatePool(_pid);
1762         
1763         if (user.amount > 0) {
1764             calcAndSafeRewardTransfer(msg.sender, user, pool);
1765         }
1766 
1767         if (_amount > 0) {
1768             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1769             user.amount = user.amount.add(_amount);
1770         }
1771         user.rewardAdamDebt = user.amount.mul(pool.accAdamPerShare).div(1e12);
1772         user.rewardAgstDebt = user.amount.mul(pool.accAgstPerShare).div(1e12);
1773         emit Deposit(msg.sender, _pid, _amount);
1774     }
1775 
1776     // Withdraw LP tokens from MasterChef.
1777     function withdraw(uint256 _pid, uint256 _amount) public {
1778         PoolInfo storage pool = poolInfo[_pid];
1779         UserInfo storage user = userInfo[_pid][msg.sender];
1780         require(user.amount >= _amount, 'withdraw: not good');
1781         updatePool(_pid);
1782 
1783         calcAndSafeRewardTransfer(msg.sender, user, pool);
1784       
1785         if (_amount > 0) {
1786             user.amount = user.amount.sub(_amount);
1787             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1788         }
1789         user.rewardAdamDebt = user.amount.mul(pool.accAdamPerShare).div(1e12);
1790         user.rewardAgstDebt = user.amount.mul(pool.accAgstPerShare).div(1e12);
1791         emit Withdraw(msg.sender, _pid, _amount);
1792     }
1793 
1794     // Withdraw without caring about rewards. EMERGENCY ONLY.
1795     function emergencyWithdraw(uint256 _pid) public {
1796         PoolInfo storage pool = poolInfo[_pid];
1797         UserInfo storage user = userInfo[_pid][msg.sender];
1798         uint256 amount = user.amount;
1799         user.amount = 0;
1800         user.rewardAdamDebt = 0;
1801         user.rewardAgstDebt = 0;
1802         pool.lpToken.safeTransfer(address(msg.sender), amount);
1803         emit EmergencyWithdraw(msg.sender, _pid, amount);
1804     }
1805 
1806     function calcAndSafeRewardTransfer(address _rewardTo, UserInfo memory _user, PoolInfo memory _pool) internal {
1807 
1808         address[MAX_USER_LEVEL] memory nodes;
1809         address referrer;
1810 
1811         if(_pool.needReferral) {
1812             referrer = refBook.getReferrer(_rewardTo);
1813             nodes = refBook.getLevelDiffedReferrers(_rewardTo);
1814         }
1815         
1816         uint256 adamBal = _user.amount.mul(_pool.accAdamPerShare).div(1e12).sub(_user.rewardAdamDebt);
1817         adamBal = Math.min(adam.balanceOf(address(this)), adamBal);
1818         if (adamBal > 0) {
1819             adam.transfer(_rewardTo, adamBal.mul(USER_SHARE_PCT).div(10000));
1820             if (_pool.needReferral) {
1821                 rewardSaveToReferrers(adamBal, referrer, nodes, referrerAdamRewards);
1822             }
1823         }
1824 
1825         uint256 agstBal = _user.amount.mul(_pool.accAgstPerShare).div(1e12).sub(_user.rewardAgstDebt);
1826         agstBal = Math.min(agst.balanceOf(address(this)), agstBal);
1827         if (agstBal > 0) {
1828             agst.transfer(_rewardTo, agstBal.mul(USER_SHARE_PCT).div(10000));
1829             if (_pool.needReferral) {
1830                 rewardSaveToReferrers(agstBal, referrer, nodes, referrerAgstRewards);
1831             }
1832         }
1833     }
1834 
1835     function rewardSaveToReferrers(
1836         uint256 userAmount,
1837         address referrer,
1838         address[MAX_USER_LEVEL] memory nodes,
1839         mapping(address => uint256) storage record
1840     ) internal {
1841         if (referrer != address(0)) {
1842             record[referrer] = record[referrer].add(userAmount.mul(REFERRER_SHARE_PCT).div(10000));
1843         }
1844 
1845         if(nodes[0] != address(0)) {
1846             record[nodes[0]] = record[nodes[0]].add(userAmount.mul(NODE_SHARE_LV1_PCT).div(10000));
1847         }
1848 
1849         if(nodes[1] != address(0)) {
1850             record[nodes[1]] = record[nodes[1]].add(userAmount.mul(NODE_SHARE_LV2_PCT).div(10000));
1851         }
1852     }
1853 
1854     function claimReferralRewards() external {
1855         uint256 adamBal = Math.min(adam.balanceOf(address(this)), referrerAdamRewards[msg.sender]);
1856         uint256 agstBal = Math.min(agst.balanceOf(address(this)), referrerAgstRewards[msg.sender]);
1857         referrerAdamRewards[msg.sender] = 0;
1858         referrerAgstRewards[msg.sender] = 0;
1859 
1860         adam.transfer(msg.sender, adamBal);
1861         agst.transfer(msg.sender, agstBal);
1862     }
1863 
1864     // Update dev address by the previous dev.
1865     function dev(address _devaddr) public {
1866         require(msg.sender == devaddr, 'dev: wut?');
1867         devaddr = _devaddr;
1868     }
1869 }