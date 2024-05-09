1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 pragma solidity ^0.6.0;
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
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
82 
83 pragma solidity ^0.6.0;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 
244 pragma solidity ^0.6.2;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // This method relies in extcodesize, which returns 0 for contracts in
269         // construction, since the code is only stored at the end of the
270         // constructor execution.
271 
272         uint256 size;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { size := extcodesize(account) }
275         return size > 0;
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
385 
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
462 
463 pragma solidity ^0.6.0;
464 
465 /**
466  * @dev Library for managing
467  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
468  * types.
469  *
470  * Sets have the following properties:
471  *
472  * - Elements are added, removed, and checked for existence in constant time
473  * (O(1)).
474  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
475  *
476  * ```
477  * contract Example {
478  *     // Add the library methods
479  *     using EnumerableSet for EnumerableSet.AddressSet;
480  *
481  *     // Declare a set state variable
482  *     EnumerableSet.AddressSet private mySet;
483  * }
484  * ```
485  *
486  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
487  * (`UintSet`) are supported.
488  */
489 library EnumerableSet {
490     // To implement this library for multiple types with as little code
491     // repetition as possible, we write it in terms of a generic Set type with
492     // bytes32 values.
493     // The Set implementation uses private functions, and user-facing
494     // implementations (such as AddressSet) are just wrappers around the
495     // underlying Set.
496     // This means that we can only create new EnumerableSets for types that fit
497     // in bytes32.
498 
499     struct Set {
500         // Storage of set values
501         bytes32[] _values;
502 
503         // Position of the value in the `values` array, plus 1 because index 0
504         // means a value is not in the set.
505         mapping (bytes32 => uint256) _indexes;
506     }
507 
508     /**
509      * @dev Add a value to a set. O(1).
510      *
511      * Returns true if the value was added to the set, that is if it was not
512      * already present.
513      */
514     function _add(Set storage set, bytes32 value) private returns (bool) {
515         if (!_contains(set, value)) {
516             set._values.push(value);
517             // The value is stored at length-1, but we add 1 to all indexes
518             // and use 0 as a sentinel value
519             set._indexes[value] = set._values.length;
520             return true;
521         } else {
522             return false;
523         }
524     }
525 
526     /**
527      * @dev Removes a value from a set. O(1).
528      *
529      * Returns true if the value was removed from the set, that is if it was
530      * present.
531      */
532     function _remove(Set storage set, bytes32 value) private returns (bool) {
533         // We read and store the value's index to prevent multiple reads from the same storage slot
534         uint256 valueIndex = set._indexes[value];
535 
536         if (valueIndex != 0) { // Equivalent to contains(set, value)
537             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
538             // the array, and then remove the last element (sometimes called as 'swap and pop').
539             // This modifies the order of the array, as noted in {at}.
540 
541             uint256 toDeleteIndex = valueIndex - 1;
542             uint256 lastIndex = set._values.length - 1;
543 
544             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
545             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
546 
547             bytes32 lastvalue = set._values[lastIndex];
548 
549             // Move the last value to the index where the value to delete is
550             set._values[toDeleteIndex] = lastvalue;
551             // Update the index for the moved value
552             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
553 
554             // Delete the slot where the moved value was stored
555             set._values.pop();
556 
557             // Delete the index for the deleted slot
558             delete set._indexes[value];
559 
560             return true;
561         } else {
562             return false;
563         }
564     }
565 
566     /**
567      * @dev Returns true if the value is in the set. O(1).
568      */
569     function _contains(Set storage set, bytes32 value) private view returns (bool) {
570         return set._indexes[value] != 0;
571     }
572 
573     /**
574      * @dev Returns the number of values on the set. O(1).
575      */
576     function _length(Set storage set) private view returns (uint256) {
577         return set._values.length;
578     }
579 
580    /**
581     * @dev Returns the value stored at position `index` in the set. O(1).
582     *
583     * Note that there are no guarantees on the ordering of values inside the
584     * array, and it may change when more values are added or removed.
585     *
586     * Requirements:
587     *
588     * - `index` must be strictly less than {length}.
589     */
590     function _at(Set storage set, uint256 index) private view returns (bytes32) {
591         require(set._values.length > index, "EnumerableSet: index out of bounds");
592         return set._values[index];
593     }
594 
595     // AddressSet
596 
597     struct AddressSet {
598         Set _inner;
599     }
600 
601     /**
602      * @dev Add a value to a set. O(1).
603      *
604      * Returns true if the value was added to the set, that is if it was not
605      * already present.
606      */
607     function add(AddressSet storage set, address value) internal returns (bool) {
608         return _add(set._inner, bytes32(uint256(value)));
609     }
610 
611     /**
612      * @dev Removes a value from a set. O(1).
613      *
614      * Returns true if the value was removed from the set, that is if it was
615      * present.
616      */
617     function remove(AddressSet storage set, address value) internal returns (bool) {
618         return _remove(set._inner, bytes32(uint256(value)));
619     }
620 
621     /**
622      * @dev Returns true if the value is in the set. O(1).
623      */
624     function contains(AddressSet storage set, address value) internal view returns (bool) {
625         return _contains(set._inner, bytes32(uint256(value)));
626     }
627 
628     /**
629      * @dev Returns the number of values in the set. O(1).
630      */
631     function length(AddressSet storage set) internal view returns (uint256) {
632         return _length(set._inner);
633     }
634 
635    /**
636     * @dev Returns the value stored at position `index` in the set. O(1).
637     *
638     * Note that there are no guarantees on the ordering of values inside the
639     * array, and it may change when more values are added or removed.
640     *
641     * Requirements:
642     *
643     * - `index` must be strictly less than {length}.
644     */
645     function at(AddressSet storage set, uint256 index) internal view returns (address) {
646         return address(uint256(_at(set._inner, index)));
647     }
648 
649 
650     // UintSet
651 
652     struct UintSet {
653         Set _inner;
654     }
655 
656     /**
657      * @dev Add a value to a set. O(1).
658      *
659      * Returns true if the value was added to the set, that is if it was not
660      * already present.
661      */
662     function add(UintSet storage set, uint256 value) internal returns (bool) {
663         return _add(set._inner, bytes32(value));
664     }
665 
666     /**
667      * @dev Removes a value from a set. O(1).
668      *
669      * Returns true if the value was removed from the set, that is if it was
670      * present.
671      */
672     function remove(UintSet storage set, uint256 value) internal returns (bool) {
673         return _remove(set._inner, bytes32(value));
674     }
675 
676     /**
677      * @dev Returns true if the value is in the set. O(1).
678      */
679     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
680         return _contains(set._inner, bytes32(value));
681     }
682 
683     /**
684      * @dev Returns the number of values on the set. O(1).
685      */
686     function length(UintSet storage set) internal view returns (uint256) {
687         return _length(set._inner);
688     }
689 
690    /**
691     * @dev Returns the value stored at position `index` in the set. O(1).
692     *
693     * Note that there are no guarantees on the ordering of values inside the
694     * array, and it may change when more values are added or removed.
695     *
696     * Requirements:
697     *
698     * - `index` must be strictly less than {length}.
699     */
700     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
701         return uint256(_at(set._inner, index));
702     }
703 }
704 
705 // File: @openzeppelin/contracts/GSN/Context.sol
706 
707 
708 pragma solidity ^0.6.0;
709 
710 /*
711  * @dev Provides information about the current execution context, including the
712  * sender of the transaction and its data. While these are generally available
713  * via msg.sender and msg.data, they should not be accessed in such a direct
714  * manner, since when dealing with GSN meta-transactions the account sending and
715  * paying for execution may not be the actual sender (as far as an application
716  * is concerned).
717  *
718  * This contract is only required for intermediate, library-like contracts.
719  */
720 abstract contract Context {
721     function _msgSender() internal view virtual returns (address payable) {
722         return msg.sender;
723     }
724 
725     function _msgData() internal view virtual returns (bytes memory) {
726         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
727         return msg.data;
728     }
729 }
730 
731 // File: @openzeppelin/contracts/access/Ownable.sol
732 
733 
734 pragma solidity ^0.6.0;
735 
736 /**
737  * @dev Contract module which provides a basic access control mechanism, where
738  * there is an account (an owner) that can be granted exclusive access to
739  * specific functions.
740  *
741  * By default, the owner account will be the one that deploys the contract. This
742  * can later be changed with {transferOwnership}.
743  *
744  * This module is used through inheritance. It will make available the modifier
745  * `onlyOwner`, which can be applied to your functions to restrict their use to
746  * the owner.
747  */
748 contract Ownable is Context {
749     address private _owner;
750 
751     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
752 
753     /**
754      * @dev Initializes the contract setting the deployer as the initial owner.
755      */
756     constructor () internal {
757         address msgSender = _msgSender();
758         _owner = msgSender;
759         emit OwnershipTransferred(address(0), msgSender);
760     }
761 
762     /**
763      * @dev Returns the address of the current owner.
764      */
765     function owner() public view returns (address) {
766         return _owner;
767     }
768 
769     /**
770      * @dev Throws if called by any account other than the owner.
771      */
772     modifier onlyOwner() {
773         require(_owner == _msgSender(), "Ownable: caller is not the owner");
774         _;
775     }
776 
777     /**
778      * @dev Leaves the contract without owner. It will not be possible to call
779      * `onlyOwner` functions anymore. Can only be called by the current owner.
780      *
781      * NOTE: Renouncing ownership will leave the contract without an owner,
782      * thereby removing any functionality that is only available to the owner.
783      */
784     function renounceOwnership() public virtual onlyOwner {
785         emit OwnershipTransferred(_owner, address(0));
786         _owner = address(0);
787     }
788 
789     /**
790      * @dev Transfers ownership of the contract to a new account (`newOwner`).
791      * Can only be called by the current owner.
792      */
793     function transferOwnership(address newOwner) public virtual onlyOwner {
794         require(newOwner != address(0), "Ownable: new owner is the zero address");
795         emit OwnershipTransferred(_owner, newOwner);
796         _owner = newOwner;
797     }
798 }
799 
800 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
801 
802 
803 pragma solidity ^0.6.0;
804 
805 
806 
807 
808 
809 /**
810  * @dev Implementation of the {IERC20} interface.
811  *
812  * This implementation is agnostic to the way tokens are created. This means
813  * that a supply mechanism has to be added in a derived contract using {_mint}.
814  * For a generic mechanism see {ERC20PresetMinterPauser}.
815  *
816  * TIP: For a detailed writeup see our guide
817  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
818  * to implement supply mechanisms].
819  *
820  * We have followed general OpenZeppelin guidelines: functions revert instead
821  * of returning `false` on failure. This behavior is nonetheless conventional
822  * and does not conflict with the expectations of ERC20 applications.
823  *
824  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
825  * This allows applications to reconstruct the allowance for all accounts just
826  * by listening to said events. Other implementations of the EIP may not emit
827  * these events, as it isn't required by the specification.
828  *
829  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
830  * functions have been added to mitigate the well-known issues around setting
831  * allowances. See {IERC20-approve}.
832  */
833 contract ERC20 is Context, IERC20 {
834     using SafeMath for uint256;
835     using Address for address;
836 
837     mapping (address => uint256) private _balances;
838 
839     mapping (address => mapping (address => uint256)) private _allowances;
840 
841     uint256 private _totalSupply;
842 
843     string private _name;
844     string private _symbol;
845     uint8 private _decimals;
846 
847     /**
848      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
849      * a default value of 18.
850      *
851      * To select a different value for {decimals}, use {_setupDecimals}.
852      *
853      * All three of these values are immutable: they can only be set once during
854      * construction.
855      */
856     constructor (string memory name, string memory symbol) public {
857         _name = name;
858         _symbol = symbol;
859         _decimals = 18;
860     }
861 
862     /**
863      * @dev Returns the name of the token.
864      */
865     function name() public view returns (string memory) {
866         return _name;
867     }
868 
869     /**
870      * @dev Returns the symbol of the token, usually a shorter version of the
871      * name.
872      */
873     function symbol() public view returns (string memory) {
874         return _symbol;
875     }
876 
877     /**
878      * @dev Returns the number of decimals used to get its user representation.
879      * For example, if `decimals` equals `2`, a balance of `505` tokens should
880      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
881      *
882      * Tokens usually opt for a value of 18, imitating the relationship between
883      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
884      * called.
885      *
886      * NOTE: This information is only used for _display_ purposes: it in
887      * no way affects any of the arithmetic of the contract, including
888      * {IERC20-balanceOf} and {IERC20-transfer}.
889      */
890     function decimals() public view returns (uint8) {
891         return _decimals;
892     }
893 
894     /**
895      * @dev See {IERC20-totalSupply}.
896      */
897     function totalSupply() public view override returns (uint256) {
898         return _totalSupply;
899     }
900 
901     /**
902      * @dev See {IERC20-balanceOf}.
903      */
904     function balanceOf(address account) public view override returns (uint256) {
905         return _balances[account];
906     }
907 
908     /**
909      * @dev See {IERC20-transfer}.
910      *
911      * Requirements:
912      *
913      * - `recipient` cannot be the zero address.
914      * - the caller must have a balance of at least `amount`.
915      */
916     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
917         _transfer(_msgSender(), recipient, amount);
918         return true;
919     }
920 
921     /**
922      * @dev See {IERC20-allowance}.
923      */
924     function allowance(address owner, address spender) public view virtual override returns (uint256) {
925         return _allowances[owner][spender];
926     }
927 
928     /**
929      * @dev See {IERC20-approve}.
930      *
931      * Requirements:
932      *
933      * - `spender` cannot be the zero address.
934      */
935     function approve(address spender, uint256 amount) public virtual override returns (bool) {
936         _approve(_msgSender(), spender, amount);
937         return true;
938     }
939 
940     /**
941      * @dev See {IERC20-transferFrom}.
942      *
943      * Emits an {Approval} event indicating the updated allowance. This is not
944      * required by the EIP. See the note at the beginning of {ERC20};
945      *
946      * Requirements:
947      * - `sender` and `recipient` cannot be the zero address.
948      * - `sender` must have a balance of at least `amount`.
949      * - the caller must have allowance for ``sender``'s tokens of at least
950      * `amount`.
951      */
952     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
953         _transfer(sender, recipient, amount);
954         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
955         return true;
956     }
957 
958     /**
959      * @dev Atomically increases the allowance granted to `spender` by the caller.
960      *
961      * This is an alternative to {approve} that can be used as a mitigation for
962      * problems described in {IERC20-approve}.
963      *
964      * Emits an {Approval} event indicating the updated allowance.
965      *
966      * Requirements:
967      *
968      * - `spender` cannot be the zero address.
969      */
970     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
971         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
972         return true;
973     }
974 
975     /**
976      * @dev Atomically decreases the allowance granted to `spender` by the caller.
977      *
978      * This is an alternative to {approve} that can be used as a mitigation for
979      * problems described in {IERC20-approve}.
980      *
981      * Emits an {Approval} event indicating the updated allowance.
982      *
983      * Requirements:
984      *
985      * - `spender` cannot be the zero address.
986      * - `spender` must have allowance for the caller of at least
987      * `subtractedValue`.
988      */
989     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
990         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
991         return true;
992     }
993 
994     /**
995      * @dev Moves tokens `amount` from `sender` to `recipient`.
996      *
997      * This is internal function is equivalent to {transfer}, and can be used to
998      * e.g. implement automatic token fees, slashing mechanisms, etc.
999      *
1000      * Emits a {Transfer} event.
1001      *
1002      * Requirements:
1003      *
1004      * - `sender` cannot be the zero address.
1005      * - `recipient` cannot be the zero address.
1006      * - `sender` must have a balance of at least `amount`.
1007      */
1008     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1009         require(sender != address(0), "ERC20: transfer from the zero address");
1010         require(recipient != address(0), "ERC20: transfer to the zero address");
1011 
1012         _beforeTokenTransfer(sender, recipient, amount);
1013 
1014         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1015         _balances[recipient] = _balances[recipient].add(amount);
1016         emit Transfer(sender, recipient, amount);
1017     }
1018 
1019     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1020      * the total supply.
1021      *
1022      * Emits a {Transfer} event with `from` set to the zero address.
1023      *
1024      * Requirements
1025      *
1026      * - `to` cannot be the zero address.
1027      */
1028     function _mint(address account, uint256 amount) internal virtual {
1029         require(account != address(0), "ERC20: mint to the zero address");
1030 
1031         _beforeTokenTransfer(address(0), account, amount);
1032 
1033         _totalSupply = _totalSupply.add(amount);
1034         _balances[account] = _balances[account].add(amount);
1035         emit Transfer(address(0), account, amount);
1036     }
1037 
1038     /**
1039      * @dev Destroys `amount` tokens from `account`, reducing the
1040      * total supply.
1041      *
1042      * Emits a {Transfer} event with `to` set to the zero address.
1043      *
1044      * Requirements
1045      *
1046      * - `account` cannot be the zero address.
1047      * - `account` must have at least `amount` tokens.
1048      */
1049     function _burn(address account, uint256 amount) internal virtual {
1050         require(account != address(0), "ERC20: burn from the zero address");
1051 
1052         _beforeTokenTransfer(account, address(0), amount);
1053 
1054         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1055         _totalSupply = _totalSupply.sub(amount);
1056         emit Transfer(account, address(0), amount);
1057     }
1058 
1059     /**
1060      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1061      *
1062      * This internal function is equivalent to `approve`, and can be used to
1063      * e.g. set automatic allowances for certain subsystems, etc.
1064      *
1065      * Emits an {Approval} event.
1066      *
1067      * Requirements:
1068      *
1069      * - `owner` cannot be the zero address.
1070      * - `spender` cannot be the zero address.
1071      */
1072     function _approve(address owner, address spender, uint256 amount) internal virtual {
1073         require(owner != address(0), "ERC20: approve from the zero address");
1074         require(spender != address(0), "ERC20: approve to the zero address");
1075 
1076         _allowances[owner][spender] = amount;
1077         emit Approval(owner, spender, amount);
1078     }
1079 
1080     /**
1081      * @dev Sets {decimals} to a value other than the default one of 18.
1082      *
1083      * WARNING: This function should only be called from the constructor. Most
1084      * applications that interact with token contracts will not expect
1085      * {decimals} to ever change, and may work incorrectly if it does.
1086      */
1087     function _setupDecimals(uint8 decimals_) internal {
1088         _decimals = decimals_;
1089     }
1090 
1091     /**
1092      * @dev Hook that is called before any transfer of tokens. This includes
1093      * minting and burning.
1094      *
1095      * Calling conditions:
1096      *
1097      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1098      * will be to transferred to `to`.
1099      * - when `from` is zero, `amount` tokens will be minted for `to`.
1100      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1101      * - `from` and `to` are never both zero.
1102      *
1103      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1104      */
1105     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1106 }
1107 
1108 // File: contracts/LuaToken.sol
1109 
1110 
1111 pragma solidity 0.6.12;
1112 
1113 
1114 
1115 
1116 // LuaToken with Governance.
1117 contract LuaToken is ERC20("LuaToken", "LUA"), Ownable {
1118     uint256 private _cap = 500000000e18;
1119     uint256 private _totalLock;
1120 
1121     uint256 public lockFromBlock;
1122     uint256 public lockToBlock;
1123     
1124 
1125     mapping(address => uint256) private _locks;
1126     mapping(address => uint256) private _lastUnlockBlock;
1127 
1128     event Lock(address indexed to, uint256 value);
1129 
1130     constructor(uint256 _lockFromBlock, uint256 _lockToBlock) public {
1131         lockFromBlock = _lockFromBlock;
1132         lockToBlock = _lockToBlock;
1133     }
1134 
1135     /**
1136      * @dev Returns the cap on the token's total supply.
1137      */
1138     function cap() public view returns (uint256) {
1139         return _cap;
1140     }
1141 
1142     function circulatingSupply() public view returns (uint256) {
1143         return totalSupply().sub(_totalLock);
1144     }
1145 
1146     function totalLock() public view returns (uint256) {
1147         return _totalLock;
1148     }
1149 
1150     /**
1151      * @dev See {ERC20-_beforeTokenTransfer}.
1152      *
1153      * Requirements:
1154      *
1155      * - minted tokens must not cause the total supply to go over the cap.
1156      */
1157     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1158         super._beforeTokenTransfer(from, to, amount);
1159 
1160         if (from == address(0)) { // When minting tokens
1161             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1162         }
1163     }
1164 
1165     /**
1166      * @dev Moves tokens `amount` from `sender` to `recipient`.
1167      *
1168      * This is internal function is equivalent to {transfer}, and can be used to
1169      * e.g. implement automatic token fees, slashing mechanisms, etc.
1170      *
1171      * Emits a {Transfer} event.
1172      *
1173      * Requirements:
1174      *
1175      * - `sender` cannot be the zero address.
1176      * - `recipient` cannot be the zero address.
1177      * - `sender` must have a balance of at least `amount`.
1178      */
1179     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
1180         super._transfer(sender, recipient, amount);
1181         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1182     }
1183 
1184     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1185     function mint(address _to, uint256 _amount) public onlyOwner {
1186         _mint(_to, _amount);
1187         _moveDelegates(address(0), _delegates[_to], _amount);
1188     }
1189 
1190     function totalBalanceOf(address _holder) public view returns (uint256) {
1191         return _locks[_holder].add(balanceOf(_holder));
1192     }
1193 
1194     function lockOf(address _holder) public view returns (uint256) {
1195         return _locks[_holder];
1196     }
1197 
1198     function lastUnlockBlock(address _holder) public view returns (uint256) {
1199         return _lastUnlockBlock[_holder];
1200     }
1201 
1202     function lock(address _holder, uint256 _amount) public onlyOwner {
1203         require(_holder != address(0), "ERC20: lock to the zero address");
1204         require(_amount <= balanceOf(_holder), "ERC20: lock amount over blance");
1205 
1206         _transfer(_holder, address(this), _amount);
1207 
1208         _locks[_holder] = _locks[_holder].add(_amount);
1209         _totalLock = _totalLock.add(_amount);
1210         if (_lastUnlockBlock[_holder] < lockFromBlock) {
1211             _lastUnlockBlock[_holder] = lockFromBlock;
1212         }
1213         emit Lock(_holder, _amount);
1214     }
1215 
1216     function canUnlockAmount(address _holder) public view returns (uint256) {
1217         if (block.number < lockFromBlock) {
1218             return 0;
1219         }
1220         else if (block.number >= lockToBlock) {
1221             return _locks[_holder];
1222         }
1223         else {
1224             uint256 releaseBlock = block.number.sub(_lastUnlockBlock[_holder]);
1225             uint256 numberLockBlock = lockToBlock.sub(_lastUnlockBlock[_holder]);
1226             return _locks[_holder].mul(releaseBlock).div(numberLockBlock);
1227         }
1228     }
1229 
1230     function unlock() public {
1231         require(_locks[msg.sender] > 0, "ERC20: cannot unlock");
1232         
1233         uint256 amount = canUnlockAmount(msg.sender);
1234         // just for sure
1235         if (amount > balanceOf(address(this))) {
1236             amount = balanceOf(address(this));
1237         }
1238         _transfer(address(this), msg.sender, amount);
1239         _locks[msg.sender] = _locks[msg.sender].sub(amount);
1240         _lastUnlockBlock[msg.sender] = block.number;
1241         _totalLock = _totalLock.sub(amount);
1242     }
1243 
1244     // This function is for dev address migrate all balance to a multi sig address
1245     function transferAll(address _to) public {
1246         _locks[_to] = _locks[_to].add(_locks[msg.sender]);
1247 
1248         if (_lastUnlockBlock[_to] < lockFromBlock) {
1249             _lastUnlockBlock[_to] = lockFromBlock;
1250         }
1251 
1252         if (_lastUnlockBlock[_to] < _lastUnlockBlock[msg.sender]) {
1253             _lastUnlockBlock[_to] = _lastUnlockBlock[msg.sender];
1254         }
1255 
1256         _locks[msg.sender] = 0;
1257         _lastUnlockBlock[msg.sender] = 0;
1258 
1259         _transfer(msg.sender, _to, balanceOf(msg.sender));
1260     }
1261 
1262     // Copied and modified from YAM code:
1263     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1264     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1265     // Which is copied and modified from COMPOUND:
1266     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1267 
1268     /// @dev A record of each accounts delegate
1269     mapping (address => address) internal _delegates;
1270 
1271     /// @notice A checkpoint for marking number of votes from a given block
1272     struct Checkpoint {
1273         uint32 fromBlock;
1274         uint256 votes;
1275     }
1276 
1277     /// @notice A record of votes checkpoints for each account, by index
1278     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1279 
1280     /// @notice The number of checkpoints for each account
1281     mapping (address => uint32) public numCheckpoints;
1282 
1283     /// @notice The EIP-712 typehash for the contract's domain
1284     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1285 
1286     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1287     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1288 
1289     /// @notice A record of states for signing / validating signatures
1290     mapping (address => uint) public nonces;
1291 
1292       /// @notice An event thats emitted when an account changes its delegate
1293     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1294 
1295     /// @notice An event thats emitted when a delegate account's vote balance changes
1296     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1297 
1298     /**
1299      * @notice Delegate votes from `msg.sender` to `delegatee`
1300      * @param delegator The address to get delegatee for
1301      */
1302     function delegates(address delegator)
1303         external
1304         view
1305         returns (address)
1306     {
1307         return _delegates[delegator];
1308     }
1309 
1310    /**
1311     * @notice Delegate votes from `msg.sender` to `delegatee`
1312     * @param delegatee The address to delegate votes to
1313     */
1314     function delegate(address delegatee) external {
1315         return _delegate(msg.sender, delegatee);
1316     }
1317 
1318     /**
1319      * @notice Delegates votes from signatory to `delegatee`
1320      * @param delegatee The address to delegate votes to
1321      * @param nonce The contract state required to match the signature
1322      * @param expiry The time at which to expire the signature
1323      * @param v The recovery byte of the signature
1324      * @param r Half of the ECDSA signature pair
1325      * @param s Half of the ECDSA signature pair
1326      */
1327     function delegateBySig(
1328         address delegatee,
1329         uint nonce,
1330         uint expiry,
1331         uint8 v,
1332         bytes32 r,
1333         bytes32 s
1334     )
1335         external
1336     {
1337         bytes32 domainSeparator = keccak256(
1338             abi.encode(
1339                 DOMAIN_TYPEHASH,
1340                 keccak256(bytes(name())),
1341                 getChainId(),
1342                 address(this)
1343             )
1344         );
1345 
1346         bytes32 structHash = keccak256(
1347             abi.encode(
1348                 DELEGATION_TYPEHASH,
1349                 delegatee,
1350                 nonce,
1351                 expiry
1352             )
1353         );
1354 
1355         bytes32 digest = keccak256(
1356             abi.encodePacked(
1357                 "\x19\x01",
1358                 domainSeparator,
1359                 structHash
1360             )
1361         );
1362 
1363         address signatory = ecrecover(digest, v, r, s);
1364         require(signatory != address(0), "LUA::delegateBySig: invalid signature");
1365         require(nonce == nonces[signatory]++, "LUA::delegateBySig: invalid nonce");
1366         require(now <= expiry, "LUA::delegateBySig: signature expired");
1367         return _delegate(signatory, delegatee);
1368     }
1369 
1370     /**
1371      * @notice Gets the current votes balance for `account`
1372      * @param account The address to get votes balance
1373      * @return The number of current votes for `account`
1374      */
1375     function getCurrentVotes(address account)
1376         external
1377         view
1378         returns (uint256)
1379     {
1380         uint32 nCheckpoints = numCheckpoints[account];
1381         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1382     }
1383 
1384     /**
1385      * @notice Determine the prior number of votes for an account as of a block number
1386      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1387      * @param account The address of the account to check
1388      * @param blockNumber The block number to get the vote balance at
1389      * @return The number of votes the account had as of the given block
1390      */
1391     function getPriorVotes(address account, uint blockNumber)
1392         external
1393         view
1394         returns (uint256)
1395     {
1396         require(blockNumber < block.number, "LUA::getPriorVotes: not yet determined");
1397 
1398         uint32 nCheckpoints = numCheckpoints[account];
1399         if (nCheckpoints == 0) {
1400             return 0;
1401         }
1402 
1403         // First check most recent balance
1404         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1405             return checkpoints[account][nCheckpoints - 1].votes;
1406         }
1407 
1408         // Next check implicit zero balance
1409         if (checkpoints[account][0].fromBlock > blockNumber) {
1410             return 0;
1411         }
1412 
1413         uint32 lower = 0;
1414         uint32 upper = nCheckpoints - 1;
1415         while (upper > lower) {
1416             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1417             Checkpoint memory cp = checkpoints[account][center];
1418             if (cp.fromBlock == blockNumber) {
1419                 return cp.votes;
1420             } else if (cp.fromBlock < blockNumber) {
1421                 lower = center;
1422             } else {
1423                 upper = center - 1;
1424             }
1425         }
1426         return checkpoints[account][lower].votes;
1427     }
1428 
1429     function _delegate(address delegator, address delegatee)
1430         internal
1431     {
1432         address currentDelegate = _delegates[delegator];
1433         uint256 delegatorBalance = balanceOf(delegator);
1434         _delegates[delegator] = delegatee;
1435 
1436         emit DelegateChanged(delegator, currentDelegate, delegatee);
1437 
1438         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1439     }
1440 
1441     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1442         if (srcRep != dstRep && amount > 0) {
1443             if (srcRep != address(0)) {
1444                 // decrease old representative
1445                 uint32 srcRepNum = numCheckpoints[srcRep];
1446                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1447                 uint256 srcRepNew = srcRepOld.sub(amount);
1448                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1449             }
1450 
1451             if (dstRep != address(0)) {
1452                 // increase new representative
1453                 uint32 dstRepNum = numCheckpoints[dstRep];
1454                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1455                 uint256 dstRepNew = dstRepOld.add(amount);
1456                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1457             }
1458         }
1459     }
1460 
1461     function _writeCheckpoint(
1462         address delegatee,
1463         uint32 nCheckpoints,
1464         uint256 oldVotes,
1465         uint256 newVotes
1466     )
1467         internal
1468     {
1469         uint32 blockNumber = safe32(block.number, "LUA::_writeCheckpoint: block number exceeds 32 bits");
1470 
1471         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1472             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1473         } else {
1474             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1475             numCheckpoints[delegatee] = nCheckpoints + 1;
1476         }
1477 
1478         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1479     }
1480 
1481     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1482         require(n < 2**32, errorMessage);
1483         return uint32(n);
1484     }
1485 
1486     function getChainId() internal pure returns (uint) {
1487         uint256 chainId;
1488         assembly { chainId := chainid() }
1489         return chainId;
1490     }
1491 }
1492 
1493 // File: contracts/LuaMasterFarmer.sol
1494 
1495 // LuaMasterFarmer
1496 pragma solidity 0.6.12;
1497 
1498 
1499 
1500 
1501 
1502 
1503 
1504 
1505 interface IMigratorToLuaSwap {
1506     // Perform LP token migration from legacy UniswapV2 to LuaSwap.
1507     // Take the current LP token address and return the new LP token address.
1508     // Migrator should have full access to the caller's LP token.
1509     // Return the new LP token address.
1510     //
1511     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1512     // LuaSwap must mint EXACTLY the same amount of LuaSwap LP tokens or
1513     // else something bad will happen. Traditional UniswapV2 does not
1514     // do that so be careful!
1515     function migrate(IERC20 token) external returns (IERC20);
1516 }
1517 
1518 // LuaMasterFarmer is the master of LUA. He can make LUA and he is a fair guy.
1519 //
1520 // Note that it's ownable and the owner wields tremendous power. The ownership
1521 // will be transferred to a governance smart contract once LUA is sufficiently
1522 // distributed and the community can show to govern itself.
1523 //
1524 // Have fun reading it. Hopefully it's bug-free. God bless.
1525 contract LuaMasterFarmer is Ownable {
1526     using SafeMath for uint256;
1527     using SafeERC20 for IERC20;
1528 
1529     // Info of each user.
1530     struct UserInfo {
1531         uint256 amount;     // How many LP tokens the user has provided.
1532         uint256 rewardDebt; // Reward debt. See explanation below.
1533         uint256 rewardDebtAtBlock; // the last block user stake
1534         //
1535         // We do some fancy math here. Basically, any point in time, the amount of LUAs
1536         // entitled to a user but is pending to be distributed is:
1537         //
1538         //   pending reward = (user.amount * pool.accLuaPerShare) - user.rewardDebt
1539         //
1540         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1541         //   1. The pool's `accLuaPerShare` (and `lastRewardBlock`) gets updated.
1542         //   2. User receives the pending reward sent to his/her address.
1543         //   3. User's `amount` gets updated.
1544         //   4. User's `rewardDebt` gets updated.
1545     }
1546 
1547     // Info of each pool.
1548     struct PoolInfo {
1549         IERC20 lpToken;           // Address of LP token contract.
1550         uint256 allocPoint;       // How many allocation points assigned to this pool. LUAs to distribute per block.
1551         uint256 lastRewardBlock;  // Last block number that LUAs distribution occurs.
1552         uint256 accLuaPerShare; // Accumulated LUAs per share, times 1e12. See below.
1553     }
1554 
1555     // The LUA TOKEN!
1556     LuaToken public lua;
1557     // Dev address.
1558     address public devaddr;
1559     // LUA tokens created per block.
1560     uint256 public REWARD_PER_BLOCK;
1561     // Bonus muliplier for early LUA makers.
1562     uint256[] public REWARD_MULTIPLIER = [128, 128, 64, 32, 16, 8, 4, 2, 1];
1563     uint256[] public HALVING_AT_BLOCK; // init in constructor function
1564     uint256 public FINISH_BONUS_AT_BLOCK;
1565 
1566     // The block number when LUA mining starts.
1567     uint256 public START_BLOCK;
1568 
1569     uint256 public constant PERCENT_LOCK_BONUS_REWARD = 75; // lock 75% of bounus reward in 1 year
1570     uint256 public constant PERCENT_FOR_DEV = 10; // 10% reward for dev
1571 
1572     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1573     IMigratorToLuaSwap public migrator;
1574 
1575     // Info of each pool.
1576     PoolInfo[] public poolInfo;
1577     mapping(address => uint256) public poolId1; // poolId1 count from 1, subtraction 1 before using with poolInfo
1578     // Info of each user that stakes LP tokens. pid => user address => info
1579     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1580     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1581     uint256 public totalAllocPoint = 0;
1582 
1583     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1584     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1585     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1586     event SendLuaReward(address indexed user, uint256 indexed pid, uint256 amount, uint256 lockAmount);
1587 
1588     constructor(
1589         LuaToken _lua,
1590         address _devaddr,
1591         uint256 _rewardPerBlock,
1592         uint256 _startBlock,
1593         uint256 _halvingAfterBlock
1594     ) public {
1595         lua = _lua;
1596         devaddr = _devaddr;
1597         REWARD_PER_BLOCK = _rewardPerBlock;
1598         START_BLOCK = _startBlock;
1599         for (uint256 i = 0; i < REWARD_MULTIPLIER.length - 1; i++) {
1600             uint256 halvingAtBlock = _halvingAfterBlock.mul(i + 1).add(_startBlock);
1601             HALVING_AT_BLOCK.push(halvingAtBlock);
1602         }
1603         FINISH_BONUS_AT_BLOCK = _halvingAfterBlock.mul(REWARD_MULTIPLIER.length - 1).add(_startBlock);
1604         HALVING_AT_BLOCK.push(uint256(-1));
1605     }
1606 
1607     function poolLength() external view returns (uint256) {
1608         return poolInfo.length;
1609     }
1610 
1611     // Add a new lp to the pool. Can only be called by the owner.
1612     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1613         require(poolId1[address(_lpToken)] == 0, "LuaMasterFarmer::add: lp is already in pool");
1614         if (_withUpdate) {
1615             massUpdatePools();
1616         }
1617         uint256 lastRewardBlock = block.number > START_BLOCK ? block.number : START_BLOCK;
1618         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1619         poolId1[address(_lpToken)] = poolInfo.length + 1;
1620         poolInfo.push(PoolInfo({
1621             lpToken: _lpToken,
1622             allocPoint: _allocPoint,
1623             lastRewardBlock: lastRewardBlock,
1624             accLuaPerShare: 0
1625         }));
1626     }
1627 
1628     // Update the given pool's LUA allocation point. Can only be called by the owner.
1629     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1630         if (_withUpdate) {
1631             massUpdatePools();
1632         }
1633         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1634         poolInfo[_pid].allocPoint = _allocPoint;
1635     }
1636 
1637     // Set the migrator contract. Can only be called by the owner.
1638     function setMigrator(IMigratorToLuaSwap _migrator) public onlyOwner {
1639         migrator = _migrator;
1640     }
1641 
1642     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1643     function migrate(uint256 _pid) public {
1644         require(address(migrator) != address(0), "migrate: no migrator");
1645         PoolInfo storage pool = poolInfo[_pid];
1646         IERC20 lpToken = pool.lpToken;
1647         uint256 bal = lpToken.balanceOf(address(this));
1648         lpToken.safeApprove(address(migrator), bal);
1649         IERC20 newLpToken = migrator.migrate(lpToken);
1650         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1651         pool.lpToken = newLpToken;
1652     }
1653 
1654     // Update reward variables for all pools. Be careful of gas spending!
1655     function massUpdatePools() public {
1656         uint256 length = poolInfo.length;
1657         for (uint256 pid = 0; pid < length; ++pid) {
1658             updatePool(pid);
1659         }
1660     }
1661 
1662     // Update reward variables of the given pool to be up-to-date.
1663     function updatePool(uint256 _pid) public {
1664         PoolInfo storage pool = poolInfo[_pid];
1665         if (block.number <= pool.lastRewardBlock) {
1666             return;
1667         }
1668         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1669         if (lpSupply == 0) {
1670             pool.lastRewardBlock = block.number;
1671             return;
1672         }
1673         uint256 luaForDev;
1674         uint256 luaForFarmer;
1675         (luaForDev, luaForFarmer) = getPoolReward(pool.lastRewardBlock, block.number, pool.allocPoint);
1676         
1677         if (luaForDev > 0) {
1678             lua.mint(devaddr, luaForDev);
1679             //For more simple, I lock reward for dev if mint reward in bonus time
1680             if (block.number <= FINISH_BONUS_AT_BLOCK) {
1681                 lua.lock(devaddr, luaForDev.mul(PERCENT_LOCK_BONUS_REWARD).div(100));
1682             }
1683         }
1684         lua.mint(address(this), luaForFarmer);
1685         pool.accLuaPerShare = pool.accLuaPerShare.add(luaForFarmer.mul(1e12).div(lpSupply));
1686         pool.lastRewardBlock = block.number;
1687     }
1688 
1689     // |--------------------------------------|
1690     // [20, 30, 40, 50, 60, 70, 80, 99999999]
1691     // Return reward multiplier over the given _from to _to block.
1692     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1693         uint256 result = 0;
1694         if (_from < START_BLOCK) return 0;
1695 
1696         for (uint256 i = 0; i < HALVING_AT_BLOCK.length; i++) {
1697             uint256 endBlock = HALVING_AT_BLOCK[i];
1698 
1699             if (_to <= endBlock) {
1700                 uint256 m = _to.sub(_from).mul(REWARD_MULTIPLIER[i]);
1701                 return result.add(m);
1702             }
1703 
1704             if (_from < endBlock) {
1705                 uint256 m = endBlock.sub(_from).mul(REWARD_MULTIPLIER[i]);
1706                 _from = endBlock;
1707                 result = result.add(m);
1708             }
1709         }
1710 
1711         return result;
1712     }
1713 
1714     function getPoolReward(uint256 _from, uint256 _to, uint256 _allocPoint) public view returns (uint256 forDev, uint256 forFarmer) {
1715         uint256 multiplier = getMultiplier(_from, _to);
1716         uint256 amount = multiplier.mul(REWARD_PER_BLOCK).mul(_allocPoint).div(totalAllocPoint);
1717         uint256 luaCanMint = lua.cap().sub(lua.totalSupply());
1718 
1719         if (luaCanMint < amount) {
1720             forDev = 0;
1721             forFarmer = luaCanMint;
1722         }
1723         else {
1724             forDev = amount.mul(PERCENT_FOR_DEV).div(100);
1725             forFarmer = amount;
1726         }
1727     }
1728 
1729     // View function to see pending LUAs on frontend.
1730     function pendingReward(uint256 _pid, address _user) external view returns (uint256) {
1731         PoolInfo storage pool = poolInfo[_pid];
1732         UserInfo storage user = userInfo[_pid][_user];
1733         uint256 accLuaPerShare = pool.accLuaPerShare;
1734         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1735         if (block.number > pool.lastRewardBlock && lpSupply > 0) {
1736             uint256 luaForFarmer;
1737             (, luaForFarmer) = getPoolReward(pool.lastRewardBlock, block.number, pool.allocPoint);
1738             accLuaPerShare = accLuaPerShare.add(luaForFarmer.mul(1e12).div(lpSupply));
1739 
1740         }
1741         return user.amount.mul(accLuaPerShare).div(1e12).sub(user.rewardDebt);
1742     }
1743 
1744     function claimReward(uint256 _pid) public {
1745         updatePool(_pid);
1746         _harvest(_pid);
1747     }
1748 
1749     // lock 75% of reward if it come from bounus time
1750     function _harvest(uint256 _pid) internal {
1751         PoolInfo storage pool = poolInfo[_pid];
1752         UserInfo storage user = userInfo[_pid][msg.sender];
1753 
1754         if (user.amount > 0) {
1755             uint256 pending = user.amount.mul(pool.accLuaPerShare).div(1e12).sub(user.rewardDebt);
1756             uint256 masterBal = lua.balanceOf(address(this));
1757 
1758             if (pending > masterBal) {
1759                 pending = masterBal;
1760             }
1761             
1762             if(pending > 0) {
1763                 lua.transfer(msg.sender, pending);
1764                 uint256 lockAmount = 0;
1765                 if (user.rewardDebtAtBlock <= FINISH_BONUS_AT_BLOCK) {
1766                     lockAmount = pending.mul(PERCENT_LOCK_BONUS_REWARD).div(100);
1767                     lua.lock(msg.sender, lockAmount);
1768                 }
1769 
1770                 user.rewardDebtAtBlock = block.number;
1771 
1772                 emit SendLuaReward(msg.sender, _pid, pending, lockAmount);
1773             }
1774 
1775             user.rewardDebt = user.amount.mul(pool.accLuaPerShare).div(1e12);
1776         }
1777     }
1778 
1779     // Deposit LP tokens to LuaMasterFarmer for LUA allocation.
1780     function deposit(uint256 _pid, uint256 _amount) public {
1781         require(_amount > 0, "LuaMasterFarmer::deposit: amount must be greater than 0");
1782 
1783         PoolInfo storage pool = poolInfo[_pid];
1784         UserInfo storage user = userInfo[_pid][msg.sender];
1785         updatePool(_pid);
1786         _harvest(_pid);
1787         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1788         if (user.amount == 0) {
1789             user.rewardDebtAtBlock = block.number;
1790         }
1791         user.amount = user.amount.add(_amount);
1792         user.rewardDebt = user.amount.mul(pool.accLuaPerShare).div(1e12);
1793         emit Deposit(msg.sender, _pid, _amount);
1794     }
1795 
1796     // Withdraw LP tokens from LuaMasterFarmer.
1797     function withdraw(uint256 _pid, uint256 _amount) public {
1798         PoolInfo storage pool = poolInfo[_pid];
1799         UserInfo storage user = userInfo[_pid][msg.sender];
1800         require(user.amount >= _amount, "LuaMasterFarmer::withdraw: not good");
1801 
1802         updatePool(_pid);
1803         _harvest(_pid);
1804         
1805         if(_amount > 0) {
1806             user.amount = user.amount.sub(_amount);
1807             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1808         }
1809         user.rewardDebt = user.amount.mul(pool.accLuaPerShare).div(1e12);
1810         emit Withdraw(msg.sender, _pid, _amount);
1811     }
1812 
1813     // Withdraw without caring about rewards. EMERGENCY ONLY.
1814     function emergencyWithdraw(uint256 _pid) public {
1815         PoolInfo storage pool = poolInfo[_pid];
1816         UserInfo storage user = userInfo[_pid][msg.sender];
1817         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1818         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1819         user.amount = 0;
1820         user.rewardDebt = 0;
1821     }
1822 
1823     // Safe lua transfer function, just in case if rounding error causes pool to not have enough LUAs.
1824     function safeLuaTransfer(address _to, uint256 _amount) internal {
1825         uint256 luaBal = lua.balanceOf(address(this));
1826         if (_amount > luaBal) {
1827             lua.transfer(_to, luaBal);
1828         } else {
1829             lua.transfer(_to, _amount);
1830         }
1831     }
1832 
1833     // Update dev address by the previous dev.
1834     function dev(address _devaddr) public {
1835         require(msg.sender == devaddr, "dev: wut?");
1836         devaddr = _devaddr;
1837     }
1838 
1839     function getNewRewardPerBlock(uint256 pid1) public view returns (uint256) {
1840         uint256 multiplier = getMultiplier(block.number -1, block.number);
1841         if (pid1 == 0) {
1842             return multiplier.mul(REWARD_PER_BLOCK);
1843         }
1844         else {
1845             return multiplier
1846                 .mul(REWARD_PER_BLOCK)
1847                 .mul(poolInfo[pid1 - 1].allocPoint)
1848                 .div(totalAllocPoint);
1849         }
1850     }
1851 }