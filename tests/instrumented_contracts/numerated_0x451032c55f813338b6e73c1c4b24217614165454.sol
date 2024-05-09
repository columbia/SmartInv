1 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.2.0
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
80 // File @openzeppelin/contracts/math/SafeMath.sol@v3.2.0
81 
82 
83 
84 pragma solidity ^0.6.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 
243 // File @openzeppelin/contracts/utils/Address.sol@v3.2.0
244 
245 
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 
388 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.2.0
389 
390 
391 
392 pragma solidity ^0.6.0;
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 
465 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.2.0
466 
467 
468 
469 pragma solidity ^0.6.0;
470 
471 /**
472  * @dev Library for managing
473  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
474  * types.
475  *
476  * Sets have the following properties:
477  *
478  * - Elements are added, removed, and checked for existence in constant time
479  * (O(1)).
480  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
481  *
482  * ```
483  * contract Example {
484  *     // Add the library methods
485  *     using EnumerableSet for EnumerableSet.AddressSet;
486  *
487  *     // Declare a set state variable
488  *     EnumerableSet.AddressSet private mySet;
489  * }
490  * ```
491  *
492  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
493  * (`UintSet`) are supported.
494  */
495 library EnumerableSet {
496     // To implement this library for multiple types with as little code
497     // repetition as possible, we write it in terms of a generic Set type with
498     // bytes32 values.
499     // The Set implementation uses private functions, and user-facing
500     // implementations (such as AddressSet) are just wrappers around the
501     // underlying Set.
502     // This means that we can only create new EnumerableSets for types that fit
503     // in bytes32.
504 
505     struct Set {
506         // Storage of set values
507         bytes32[] _values;
508 
509         // Position of the value in the `values` array, plus 1 because index 0
510         // means a value is not in the set.
511         mapping (bytes32 => uint256) _indexes;
512     }
513 
514     /**
515      * @dev Add a value to a set. O(1).
516      *
517      * Returns true if the value was added to the set, that is if it was not
518      * already present.
519      */
520     function _add(Set storage set, bytes32 value) private returns (bool) {
521         if (!_contains(set, value)) {
522             set._values.push(value);
523             // The value is stored at length-1, but we add 1 to all indexes
524             // and use 0 as a sentinel value
525             set._indexes[value] = set._values.length;
526             return true;
527         } else {
528             return false;
529         }
530     }
531 
532     /**
533      * @dev Removes a value from a set. O(1).
534      *
535      * Returns true if the value was removed from the set, that is if it was
536      * present.
537      */
538     function _remove(Set storage set, bytes32 value) private returns (bool) {
539         // We read and store the value's index to prevent multiple reads from the same storage slot
540         uint256 valueIndex = set._indexes[value];
541 
542         if (valueIndex != 0) { // Equivalent to contains(set, value)
543             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
544             // the array, and then remove the last element (sometimes called as 'swap and pop').
545             // This modifies the order of the array, as noted in {at}.
546 
547             uint256 toDeleteIndex = valueIndex - 1;
548             uint256 lastIndex = set._values.length - 1;
549 
550             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
551             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
552 
553             bytes32 lastvalue = set._values[lastIndex];
554 
555             // Move the last value to the index where the value to delete is
556             set._values[toDeleteIndex] = lastvalue;
557             // Update the index for the moved value
558             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
559 
560             // Delete the slot where the moved value was stored
561             set._values.pop();
562 
563             // Delete the index for the deleted slot
564             delete set._indexes[value];
565 
566             return true;
567         } else {
568             return false;
569         }
570     }
571 
572     /**
573      * @dev Returns true if the value is in the set. O(1).
574      */
575     function _contains(Set storage set, bytes32 value) private view returns (bool) {
576         return set._indexes[value] != 0;
577     }
578 
579     /**
580      * @dev Returns the number of values on the set. O(1).
581      */
582     function _length(Set storage set) private view returns (uint256) {
583         return set._values.length;
584     }
585 
586    /**
587     * @dev Returns the value stored at position `index` in the set. O(1).
588     *
589     * Note that there are no guarantees on the ordering of values inside the
590     * array, and it may change when more values are added or removed.
591     *
592     * Requirements:
593     *
594     * - `index` must be strictly less than {length}.
595     */
596     function _at(Set storage set, uint256 index) private view returns (bytes32) {
597         require(set._values.length > index, "EnumerableSet: index out of bounds");
598         return set._values[index];
599     }
600 
601     // AddressSet
602 
603     struct AddressSet {
604         Set _inner;
605     }
606 
607     /**
608      * @dev Add a value to a set. O(1).
609      *
610      * Returns true if the value was added to the set, that is if it was not
611      * already present.
612      */
613     function add(AddressSet storage set, address value) internal returns (bool) {
614         return _add(set._inner, bytes32(uint256(value)));
615     }
616 
617     /**
618      * @dev Removes a value from a set. O(1).
619      *
620      * Returns true if the value was removed from the set, that is if it was
621      * present.
622      */
623     function remove(AddressSet storage set, address value) internal returns (bool) {
624         return _remove(set._inner, bytes32(uint256(value)));
625     }
626 
627     /**
628      * @dev Returns true if the value is in the set. O(1).
629      */
630     function contains(AddressSet storage set, address value) internal view returns (bool) {
631         return _contains(set._inner, bytes32(uint256(value)));
632     }
633 
634     /**
635      * @dev Returns the number of values in the set. O(1).
636      */
637     function length(AddressSet storage set) internal view returns (uint256) {
638         return _length(set._inner);
639     }
640 
641    /**
642     * @dev Returns the value stored at position `index` in the set. O(1).
643     *
644     * Note that there are no guarantees on the ordering of values inside the
645     * array, and it may change when more values are added or removed.
646     *
647     * Requirements:
648     *
649     * - `index` must be strictly less than {length}.
650     */
651     function at(AddressSet storage set, uint256 index) internal view returns (address) {
652         return address(uint256(_at(set._inner, index)));
653     }
654 
655 
656     // UintSet
657 
658     struct UintSet {
659         Set _inner;
660     }
661 
662     /**
663      * @dev Add a value to a set. O(1).
664      *
665      * Returns true if the value was added to the set, that is if it was not
666      * already present.
667      */
668     function add(UintSet storage set, uint256 value) internal returns (bool) {
669         return _add(set._inner, bytes32(value));
670     }
671 
672     /**
673      * @dev Removes a value from a set. O(1).
674      *
675      * Returns true if the value was removed from the set, that is if it was
676      * present.
677      */
678     function remove(UintSet storage set, uint256 value) internal returns (bool) {
679         return _remove(set._inner, bytes32(value));
680     }
681 
682     /**
683      * @dev Returns true if the value is in the set. O(1).
684      */
685     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
686         return _contains(set._inner, bytes32(value));
687     }
688 
689     /**
690      * @dev Returns the number of values on the set. O(1).
691      */
692     function length(UintSet storage set) internal view returns (uint256) {
693         return _length(set._inner);
694     }
695 
696    /**
697     * @dev Returns the value stored at position `index` in the set. O(1).
698     *
699     * Note that there are no guarantees on the ordering of values inside the
700     * array, and it may change when more values are added or removed.
701     *
702     * Requirements:
703     *
704     * - `index` must be strictly less than {length}.
705     */
706     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
707         return uint256(_at(set._inner, index));
708     }
709 }
710 
711 
712 // File @openzeppelin/contracts/GSN/Context.sol@v3.2.0
713 
714 
715 
716 pragma solidity ^0.6.0;
717 
718 /*
719  * @dev Provides information about the current execution context, including the
720  * sender of the transaction and its data. While these are generally available
721  * via msg.sender and msg.data, they should not be accessed in such a direct
722  * manner, since when dealing with GSN meta-transactions the account sending and
723  * paying for execution may not be the actual sender (as far as an application
724  * is concerned).
725  *
726  * This contract is only required for intermediate, library-like contracts.
727  */
728 abstract contract Context {
729     function _msgSender() internal view virtual returns (address payable) {
730         return msg.sender;
731     }
732 
733     function _msgData() internal view virtual returns (bytes memory) {
734         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
735         return msg.data;
736     }
737 }
738 
739 
740 // File @openzeppelin/contracts/access/Ownable.sol@v3.2.0
741 
742 
743 
744 pragma solidity ^0.6.0;
745 
746 /**
747  * @dev Contract module which provides a basic access control mechanism, where
748  * there is an account (an owner) that can be granted exclusive access to
749  * specific functions.
750  *
751  * By default, the owner account will be the one that deploys the contract. This
752  * can later be changed with {transferOwnership}.
753  *
754  * This module is used through inheritance. It will make available the modifier
755  * `onlyOwner`, which can be applied to your functions to restrict their use to
756  * the owner.
757  */
758 contract Ownable is Context {
759     address private _owner;
760 
761     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
762 
763     /**
764      * @dev Initializes the contract setting the deployer as the initial owner.
765      */
766     constructor () internal {
767         address msgSender = _msgSender();
768         _owner = msgSender;
769         emit OwnershipTransferred(address(0), msgSender);
770     }
771 
772     /**
773      * @dev Returns the address of the current owner.
774      */
775     function owner() public view returns (address) {
776         return _owner;
777     }
778 
779     /**
780      * @dev Throws if called by any account other than the owner.
781      */
782     modifier onlyOwner() {
783         require(_owner == _msgSender(), "Ownable: caller is not the owner");
784         _;
785     }
786 
787     /**
788      * @dev Leaves the contract without owner. It will not be possible to call
789      * `onlyOwner` functions anymore. Can only be called by the current owner.
790      *
791      * NOTE: Renouncing ownership will leave the contract without an owner,
792      * thereby removing any functionality that is only available to the owner.
793      */
794     function renounceOwnership() public virtual onlyOwner {
795         emit OwnershipTransferred(_owner, address(0));
796         _owner = address(0);
797     }
798 
799     /**
800      * @dev Transfers ownership of the contract to a new account (`newOwner`).
801      * Can only be called by the current owner.
802      */
803     function transferOwnership(address newOwner) public virtual onlyOwner {
804         require(newOwner != address(0), "Ownable: new owner is the zero address");
805         emit OwnershipTransferred(_owner, newOwner);
806         _owner = newOwner;
807     }
808 }
809 
810 
811 // File @openzeppelin/contracts/access/AccessControl.sol@v3.2.0
812 
813 
814 
815 pragma solidity ^0.6.0;
816 
817 
818 
819 /**
820  * @dev Contract module that allows children to implement role-based access
821  * control mechanisms.
822  *
823  * Roles are referred to by their `bytes32` identifier. These should be exposed
824  * in the external API and be unique. The best way to achieve this is by
825  * using `public constant` hash digests:
826  *
827  * ```
828  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
829  * ```
830  *
831  * Roles can be used to represent a set of permissions. To restrict access to a
832  * function call, use {hasRole}:
833  *
834  * ```
835  * function foo() public {
836  *     require(hasRole(MY_ROLE, msg.sender));
837  *     ...
838  * }
839  * ```
840  *
841  * Roles can be granted and revoked dynamically via the {grantRole} and
842  * {revokeRole} functions. Each role has an associated admin role, and only
843  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
844  *
845  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
846  * that only accounts with this role will be able to grant or revoke other
847  * roles. More complex role relationships can be created by using
848  * {_setRoleAdmin}.
849  *
850  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
851  * grant and revoke this role. Extra precautions should be taken to secure
852  * accounts that have been granted it.
853  */
854 abstract contract AccessControl is Context {
855     using EnumerableSet for EnumerableSet.AddressSet;
856     using Address for address;
857 
858     struct RoleData {
859         EnumerableSet.AddressSet members;
860         bytes32 adminRole;
861     }
862 
863     mapping (bytes32 => RoleData) private _roles;
864 
865     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
866 
867     /**
868      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
869      *
870      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
871      * {RoleAdminChanged} not being emitted signaling this.
872      *
873      * _Available since v3.1._
874      */
875     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
876 
877     /**
878      * @dev Emitted when `account` is granted `role`.
879      *
880      * `sender` is the account that originated the contract call, an admin role
881      * bearer except when using {_setupRole}.
882      */
883     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
884 
885     /**
886      * @dev Emitted when `account` is revoked `role`.
887      *
888      * `sender` is the account that originated the contract call:
889      *   - if using `revokeRole`, it is the admin role bearer
890      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
891      */
892     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
893 
894     /**
895      * @dev Returns `true` if `account` has been granted `role`.
896      */
897     function hasRole(bytes32 role, address account) public view returns (bool) {
898         return _roles[role].members.contains(account);
899     }
900 
901     /**
902      * @dev Returns the number of accounts that have `role`. Can be used
903      * together with {getRoleMember} to enumerate all bearers of a role.
904      */
905     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
906         return _roles[role].members.length();
907     }
908 
909     /**
910      * @dev Returns one of the accounts that have `role`. `index` must be a
911      * value between 0 and {getRoleMemberCount}, non-inclusive.
912      *
913      * Role bearers are not sorted in any particular way, and their ordering may
914      * change at any point.
915      *
916      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
917      * you perform all queries on the same block. See the following
918      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
919      * for more information.
920      */
921     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
922         return _roles[role].members.at(index);
923     }
924 
925     /**
926      * @dev Returns the admin role that controls `role`. See {grantRole} and
927      * {revokeRole}.
928      *
929      * To change a role's admin, use {_setRoleAdmin}.
930      */
931     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
932         return _roles[role].adminRole;
933     }
934 
935     /**
936      * @dev Grants `role` to `account`.
937      *
938      * If `account` had not been already granted `role`, emits a {RoleGranted}
939      * event.
940      *
941      * Requirements:
942      *
943      * - the caller must have ``role``'s admin role.
944      */
945     function grantRole(bytes32 role, address account) public virtual {
946         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
947 
948         _grantRole(role, account);
949     }
950 
951     /**
952      * @dev Revokes `role` from `account`.
953      *
954      * If `account` had been granted `role`, emits a {RoleRevoked} event.
955      *
956      * Requirements:
957      *
958      * - the caller must have ``role``'s admin role.
959      */
960     function revokeRole(bytes32 role, address account) public virtual {
961         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
962 
963         _revokeRole(role, account);
964     }
965 
966     /**
967      * @dev Revokes `role` from the calling account.
968      *
969      * Roles are often managed via {grantRole} and {revokeRole}: this function's
970      * purpose is to provide a mechanism for accounts to lose their privileges
971      * if they are compromised (such as when a trusted device is misplaced).
972      *
973      * If the calling account had been granted `role`, emits a {RoleRevoked}
974      * event.
975      *
976      * Requirements:
977      *
978      * - the caller must be `account`.
979      */
980     function renounceRole(bytes32 role, address account) public virtual {
981         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
982 
983         _revokeRole(role, account);
984     }
985 
986     /**
987      * @dev Grants `role` to `account`.
988      *
989      * If `account` had not been already granted `role`, emits a {RoleGranted}
990      * event. Note that unlike {grantRole}, this function doesn't perform any
991      * checks on the calling account.
992      *
993      * [WARNING]
994      * ====
995      * This function should only be called from the constructor when setting
996      * up the initial roles for the system.
997      *
998      * Using this function in any other way is effectively circumventing the admin
999      * system imposed by {AccessControl}.
1000      * ====
1001      */
1002     function _setupRole(bytes32 role, address account) internal virtual {
1003         _grantRole(role, account);
1004     }
1005 
1006     /**
1007      * @dev Sets `adminRole` as ``role``'s admin role.
1008      *
1009      * Emits a {RoleAdminChanged} event.
1010      */
1011     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1012         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1013         _roles[role].adminRole = adminRole;
1014     }
1015 
1016     function _grantRole(bytes32 role, address account) private {
1017         if (_roles[role].members.add(account)) {
1018             emit RoleGranted(role, account, _msgSender());
1019         }
1020     }
1021 
1022     function _revokeRole(bytes32 role, address account) private {
1023         if (_roles[role].members.remove(account)) {
1024             emit RoleRevoked(role, account, _msgSender());
1025         }
1026     }
1027 }
1028 
1029 
1030 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.2.0
1031 
1032 
1033 
1034 pragma solidity ^0.6.0;
1035 
1036 
1037 
1038 
1039 /**
1040  * @dev Implementation of the {IERC20} interface.
1041  *
1042  * This implementation is agnostic to the way tokens are created. This means
1043  * that a supply mechanism has to be added in a derived contract using {_mint}.
1044  * For a generic mechanism see {ERC20PresetMinterPauser}.
1045  *
1046  * TIP: For a detailed writeup see our guide
1047  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1048  * to implement supply mechanisms].
1049  *
1050  * We have followed general OpenZeppelin guidelines: functions revert instead
1051  * of returning `false` on failure. This behavior is nonetheless conventional
1052  * and does not conflict with the expectations of ERC20 applications.
1053  *
1054  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1055  * This allows applications to reconstruct the allowance for all accounts just
1056  * by listening to said events. Other implementations of the EIP may not emit
1057  * these events, as it isn't required by the specification.
1058  *
1059  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1060  * functions have been added to mitigate the well-known issues around setting
1061  * allowances. See {IERC20-approve}.
1062  */
1063 contract ERC20 is Context, IERC20 {
1064     using SafeMath for uint256;
1065     using Address for address;
1066 
1067     mapping (address => uint256) private _balances;
1068 
1069     mapping (address => mapping (address => uint256)) private _allowances;
1070 
1071     uint256 private _totalSupply;
1072 
1073     string private _name;
1074     string private _symbol;
1075     uint8 private _decimals;
1076 
1077     /**
1078      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1079      * a default value of 18.
1080      *
1081      * To select a different value for {decimals}, use {_setupDecimals}.
1082      *
1083      * All three of these values are immutable: they can only be set once during
1084      * construction.
1085      */
1086     constructor (string memory name, string memory symbol) public {
1087         _name = name;
1088         _symbol = symbol;
1089         _decimals = 18;
1090     }
1091 
1092     /**
1093      * @dev Returns the name of the token.
1094      */
1095     function name() public view returns (string memory) {
1096         return _name;
1097     }
1098 
1099     /**
1100      * @dev Returns the symbol of the token, usually a shorter version of the
1101      * name.
1102      */
1103     function symbol() public view returns (string memory) {
1104         return _symbol;
1105     }
1106 
1107     /**
1108      * @dev Returns the number of decimals used to get its user representation.
1109      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1110      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1111      *
1112      * Tokens usually opt for a value of 18, imitating the relationship between
1113      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1114      * called.
1115      *
1116      * NOTE: This information is only used for _display_ purposes: it in
1117      * no way affects any of the arithmetic of the contract, including
1118      * {IERC20-balanceOf} and {IERC20-transfer}.
1119      */
1120     function decimals() public view returns (uint8) {
1121         return _decimals;
1122     }
1123 
1124     /**
1125      * @dev See {IERC20-totalSupply}.
1126      */
1127     function totalSupply() public view override returns (uint256) {
1128         return _totalSupply;
1129     }
1130 
1131     /**
1132      * @dev See {IERC20-balanceOf}.
1133      */
1134     function balanceOf(address account) public view override returns (uint256) {
1135         return _balances[account];
1136     }
1137 
1138     /**
1139      * @dev See {IERC20-transfer}.
1140      *
1141      * Requirements:
1142      *
1143      * - `recipient` cannot be the zero address.
1144      * - the caller must have a balance of at least `amount`.
1145      */
1146     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1147         _transfer(_msgSender(), recipient, amount);
1148         return true;
1149     }
1150 
1151     /**
1152      * @dev See {IERC20-allowance}.
1153      */
1154     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1155         return _allowances[owner][spender];
1156     }
1157 
1158     /**
1159      * @dev See {IERC20-approve}.
1160      *
1161      * Requirements:
1162      *
1163      * - `spender` cannot be the zero address.
1164      */
1165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1166         _approve(_msgSender(), spender, amount);
1167         return true;
1168     }
1169 
1170     /**
1171      * @dev See {IERC20-transferFrom}.
1172      *
1173      * Emits an {Approval} event indicating the updated allowance. This is not
1174      * required by the EIP. See the note at the beginning of {ERC20};
1175      *
1176      * Requirements:
1177      * - `sender` and `recipient` cannot be the zero address.
1178      * - `sender` must have a balance of at least `amount`.
1179      * - the caller must have allowance for ``sender``'s tokens of at least
1180      * `amount`.
1181      */
1182     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1183         _transfer(sender, recipient, amount);
1184         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1185         return true;
1186     }
1187 
1188     /**
1189      * @dev Atomically increases the allowance granted to `spender` by the caller.
1190      *
1191      * This is an alternative to {approve} that can be used as a mitigation for
1192      * problems described in {IERC20-approve}.
1193      *
1194      * Emits an {Approval} event indicating the updated allowance.
1195      *
1196      * Requirements:
1197      *
1198      * - `spender` cannot be the zero address.
1199      */
1200     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1201         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1202         return true;
1203     }
1204 
1205     /**
1206      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1207      *
1208      * This is an alternative to {approve} that can be used as a mitigation for
1209      * problems described in {IERC20-approve}.
1210      *
1211      * Emits an {Approval} event indicating the updated allowance.
1212      *
1213      * Requirements:
1214      *
1215      * - `spender` cannot be the zero address.
1216      * - `spender` must have allowance for the caller of at least
1217      * `subtractedValue`.
1218      */
1219     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1220         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1221         return true;
1222     }
1223 
1224     /**
1225      * @dev Moves tokens `amount` from `sender` to `recipient`.
1226      *
1227      * This is internal function is equivalent to {transfer}, and can be used to
1228      * e.g. implement automatic token fees, slashing mechanisms, etc.
1229      *
1230      * Emits a {Transfer} event.
1231      *
1232      * Requirements:
1233      *
1234      * - `sender` cannot be the zero address.
1235      * - `recipient` cannot be the zero address.
1236      * - `sender` must have a balance of at least `amount`.
1237      */
1238     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1239         require(sender != address(0), "ERC20: transfer from the zero address");
1240         require(recipient != address(0), "ERC20: transfer to the zero address");
1241 
1242         _beforeTokenTransfer(sender, recipient, amount);
1243 
1244         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1245         _balances[recipient] = _balances[recipient].add(amount);
1246         emit Transfer(sender, recipient, amount);
1247     }
1248 
1249     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1250      * the total supply.
1251      *
1252      * Emits a {Transfer} event with `from` set to the zero address.
1253      *
1254      * Requirements
1255      *
1256      * - `to` cannot be the zero address.
1257      */
1258     function _mint(address account, uint256 amount) internal virtual {
1259         require(account != address(0), "ERC20: mint to the zero address");
1260 
1261         _beforeTokenTransfer(address(0), account, amount);
1262 
1263         _totalSupply = _totalSupply.add(amount);
1264         _balances[account] = _balances[account].add(amount);
1265         emit Transfer(address(0), account, amount);
1266     }
1267 
1268     /**
1269      * @dev Destroys `amount` tokens from `account`, reducing the
1270      * total supply.
1271      *
1272      * Emits a {Transfer} event with `to` set to the zero address.
1273      *
1274      * Requirements
1275      *
1276      * - `account` cannot be the zero address.
1277      * - `account` must have at least `amount` tokens.
1278      */
1279     function _burn(address account, uint256 amount) internal virtual {
1280         require(account != address(0), "ERC20: burn from the zero address");
1281 
1282         _beforeTokenTransfer(account, address(0), amount);
1283 
1284         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1285         _totalSupply = _totalSupply.sub(amount);
1286         emit Transfer(account, address(0), amount);
1287     }
1288 
1289     /**
1290      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1291      *
1292      * This internal function is equivalent to `approve`, and can be used to
1293      * e.g. set automatic allowances for certain subsystems, etc.
1294      *
1295      * Emits an {Approval} event.
1296      *
1297      * Requirements:
1298      *
1299      * - `owner` cannot be the zero address.
1300      * - `spender` cannot be the zero address.
1301      */
1302     function _approve(address owner, address spender, uint256 amount) internal virtual {
1303         require(owner != address(0), "ERC20: approve from the zero address");
1304         require(spender != address(0), "ERC20: approve to the zero address");
1305 
1306         _allowances[owner][spender] = amount;
1307         emit Approval(owner, spender, amount);
1308     }
1309 
1310     /**
1311      * @dev Sets {decimals} to a value other than the default one of 18.
1312      *
1313      * WARNING: This function should only be called from the constructor. Most
1314      * applications that interact with token contracts will not expect
1315      * {decimals} to ever change, and may work incorrectly if it does.
1316      */
1317     function _setupDecimals(uint8 decimals_) internal {
1318         _decimals = decimals_;
1319     }
1320 
1321     /**
1322      * @dev Hook that is called before any transfer of tokens. This includes
1323      * minting and burning.
1324      *
1325      * Calling conditions:
1326      *
1327      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1328      * will be to transferred to `to`.
1329      * - when `from` is zero, `amount` tokens will be minted for `to`.
1330      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1331      * - `from` and `to` are never both zero.
1332      *
1333      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1334      */
1335     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1336 }
1337 
1338 
1339 // File contracts/token/WePiggyToken.sol
1340 
1341 
1342 pragma solidity 0.6.12;
1343 
1344 
1345 // Copied and modified from SUSHI code:
1346 // https://github.com/sushiswap/sushiswap/blob/master/contracts/SushiToken.sol
1347 // WePiggyToken with Governance.
1348 contract WePiggyToken is ERC20, AccessControl {
1349 
1350     // Create a new role identifier for the minter role
1351     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1352 
1353     constructor() public ERC20("WePiggy Coin", "WPC") {
1354 
1355         // Grant the contract deployer the default admin role: it will be able
1356         // to grant and revoke any roles
1357         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1358     }
1359 
1360     /// @notice Creates `_amount` token to `_to`.Must only be called by the minter role.
1361     function mint(address _to, uint256 _amount) public {
1362 
1363         // Check that the calling account has the minter role
1364         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1365 
1366         _mint(_to, _amount);
1367         _moveDelegates(address(0), _delegates[_to], _amount);
1368     }
1369 
1370     //  transfers delegate authority when sending a token.
1371     // https://medium.com/bulldax-finance/sushiswap-delegation-double-spending-bug-5adcc7b3830f
1372     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
1373         super._transfer(sender, recipient, amount);
1374         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1375     }
1376 
1377     // Copied and modified from YAM code:
1378     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1379     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1380     // Which is copied and modified from COMPOUND:
1381     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1382 
1383     /// @dev A record of each accounts delegate
1384     mapping(address => address) internal _delegates;
1385 
1386     /// @notice A checkpoint for marking number of votes from a given block
1387     struct Checkpoint {
1388         uint32 fromBlock;
1389         uint256 votes;
1390     }
1391 
1392     /// @notice A record of votes checkpoints for each account, by index
1393     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1394 
1395     /// @notice The number of checkpoints for each account
1396     mapping(address => uint32) public numCheckpoints;
1397 
1398     /// @notice The EIP-712 typehash for the contract's domain
1399     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1400 
1401     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1402     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1403 
1404     /// @notice A record of states for signing / validating signatures
1405     mapping(address => uint) public nonces;
1406 
1407     /// @notice An event thats emitted when an account changes its delegate
1408     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1409 
1410     /// @notice An event thats emitted when a delegate account's vote balance changes
1411     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1412 
1413     /**
1414      * @notice Delegate votes from `msg.sender` to `delegatee`
1415      * @param delegator The address to get delegatee for
1416      */
1417     function delegates(address delegator)
1418     external
1419     view
1420     returns (address)
1421     {
1422         return _delegates[delegator];
1423     }
1424 
1425     /**
1426      * @notice Delegate votes from `msg.sender` to `delegatee`
1427      * @param delegatee The address to delegate votes to
1428      */
1429     function delegate(address delegatee) external {
1430         return _delegate(msg.sender, delegatee);
1431     }
1432 
1433     /**
1434      * @notice Delegates votes from signatory to `delegatee`
1435      * @param delegatee The address to delegate votes to
1436      * @param nonce The contract state required to match the signature
1437      * @param expiry The time at which to expire the signature
1438      * @param v The recovery byte of the signature
1439      * @param r Half of the ECDSA signature pair
1440      * @param s Half of the ECDSA signature pair
1441      */
1442     function delegateBySig(
1443         address delegatee,
1444         uint nonce,
1445         uint expiry,
1446         uint8 v,
1447         bytes32 r,
1448         bytes32 s
1449     )
1450     external
1451     {
1452         bytes32 domainSeparator = keccak256(
1453             abi.encode(
1454                 DOMAIN_TYPEHASH,
1455                 keccak256(bytes(name())),
1456                 getChainId(),
1457                 address(this)
1458             )
1459         );
1460 
1461         bytes32 structHash = keccak256(
1462             abi.encode(
1463                 DELEGATION_TYPEHASH,
1464                 delegatee,
1465                 nonce,
1466                 expiry
1467             )
1468         );
1469 
1470         bytes32 digest = keccak256(
1471             abi.encodePacked(
1472                 "\x19\x01",
1473                 domainSeparator,
1474                 structHash
1475             )
1476         );
1477 
1478         address signatory = ecrecover(digest, v, r, s);
1479         require(signatory != address(0), "WePiggyToken::delegateBySig: invalid signature");
1480         require(nonce == nonces[signatory]++, "WePiggyToken::delegateBySig: invalid nonce");
1481         require(now <= expiry, "WePiggyToken::delegateBySig: signature expired");
1482         return _delegate(signatory, delegatee);
1483     }
1484 
1485     /**
1486      * @notice Gets the current votes balance for `account`
1487      * @param account The address to get votes balance
1488      * @return The number of current votes for `account`
1489      */
1490     function getCurrentVotes(address account)
1491     external
1492     view
1493     returns (uint256)
1494     {
1495         uint32 nCheckpoints = numCheckpoints[account];
1496         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1497     }
1498 
1499     /**
1500      * @notice Determine the prior number of votes for an account as of a block number
1501      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1502      * @param account The address of the account to check
1503      * @param blockNumber The block number to get the vote balance at
1504      * @return The number of votes the account had as of the given block
1505      */
1506     function getPriorVotes(address account, uint blockNumber)
1507     external
1508     view
1509     returns (uint256)
1510     {
1511         require(blockNumber < block.number, "WePiggyToken::getPriorVotes: not yet determined");
1512 
1513         uint32 nCheckpoints = numCheckpoints[account];
1514         if (nCheckpoints == 0) {
1515             return 0;
1516         }
1517 
1518         // First check most recent balance
1519         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1520             return checkpoints[account][nCheckpoints - 1].votes;
1521         }
1522 
1523         // Next check implicit zero balance
1524         if (checkpoints[account][0].fromBlock > blockNumber) {
1525             return 0;
1526         }
1527 
1528         uint32 lower = 0;
1529         uint32 upper = nCheckpoints - 1;
1530         while (upper > lower) {
1531             // ceil, avoiding overflow
1532             uint32 center = upper - (upper - lower) / 2;
1533             Checkpoint memory cp = checkpoints[account][center];
1534             if (cp.fromBlock == blockNumber) {
1535                 return cp.votes;
1536             } else if (cp.fromBlock < blockNumber) {
1537                 lower = center;
1538             } else {
1539                 upper = center - 1;
1540             }
1541         }
1542         return checkpoints[account][lower].votes;
1543     }
1544 
1545     function _delegate(address delegator, address delegatee)
1546     internal
1547     {
1548         address currentDelegate = _delegates[delegator];
1549         // balance of underlying WePiggyTokens (not scaled);
1550         uint256 delegatorBalance = balanceOf(delegator);
1551 
1552         _delegates[delegator] = delegatee;
1553 
1554         emit DelegateChanged(delegator, currentDelegate, delegatee);
1555 
1556         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1557     }
1558 
1559     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1560         if (srcRep != dstRep && amount > 0) {
1561             if (srcRep != address(0)) {
1562                 // decrease old representative
1563                 uint32 srcRepNum = numCheckpoints[srcRep];
1564                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1565                 uint256 srcRepNew = srcRepOld.sub(amount);
1566                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1567             }
1568 
1569             if (dstRep != address(0)) {
1570                 // increase new representative
1571                 uint32 dstRepNum = numCheckpoints[dstRep];
1572                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1573                 uint256 dstRepNew = dstRepOld.add(amount);
1574                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1575             }
1576         }
1577     }
1578 
1579     function _writeCheckpoint(
1580         address delegatee,
1581         uint32 nCheckpoints,
1582         uint256 oldVotes,
1583         uint256 newVotes
1584     )
1585     internal
1586     {
1587         uint32 blockNumber = safe32(block.number, "WePiggyToken::_writeCheckpoint: block number exceeds 32 bits");
1588 
1589         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1590             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1591         } else {
1592             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1593             numCheckpoints[delegatee] = nCheckpoints + 1;
1594         }
1595 
1596         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1597     }
1598 
1599     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1600         require(n < 2 ** 32, errorMessage);
1601         return uint32(n);
1602     }
1603 
1604     function getChainId() internal pure returns (uint) {
1605         uint256 chainId;
1606         assembly {chainId := chainid()}
1607         return chainId;
1608     }
1609 
1610 
1611 }
1612 
1613 
1614 // File contracts/farm/PiggyBreeder.sol
1615 
1616 
1617 pragma solidity 0.6.12;
1618 
1619 
1620 
1621 
1622 
1623 
1624 // Copied and modified from sushiswap code:
1625 // https://github.com/sushiswap/sushiswap/blob/master/contracts/MasterChef.sol
1626 
1627 interface IMigrator {
1628     function replaceMigrate(IERC20 lpToken) external returns (IERC20, uint);
1629 
1630     function migrate(IERC20 lpToken) external returns (IERC20, uint);
1631 }
1632 
1633 // PiggyBreeder is the master of PiggyToken.
1634 contract PiggyBreeder is Ownable {
1635 
1636     using SafeMath for uint256;
1637     using SafeERC20 for IERC20;
1638 
1639     // Info of each user.
1640     struct UserInfo {
1641         uint256 amount;     // How many LP tokens the user has provided.
1642         uint256 rewardDebt; // Reward debt.
1643         uint256 pendingReward;
1644         bool unStakeBeforeEnableClaim;
1645     }
1646 
1647     // Info of each pool.
1648     struct PoolInfo {
1649         IERC20 lpToken;           // Address of LP token contract.
1650         uint256 allocPoint;       // How many allocation points assigned to this pool. PiggyTokens to distribute per block.
1651         uint256 lastRewardBlock;  // Last block number that PiggyTokens distribution occurs.
1652         uint256 accPiggyPerShare; // Accumulated PiggyTokens per share, times 1e12. See below.
1653         uint256 totalDeposit;       // Accumulated deposit tokens.
1654         IMigrator migrator;
1655     }
1656 
1657     // The WePiggyToken !
1658     WePiggyToken public piggy;
1659 
1660     // Dev address.
1661     address public devAddr;
1662 
1663     // Percentage of developers mining
1664     uint256 public devMiningRate;
1665 
1666     // PIGGY tokens created per block.
1667     uint256 public piggyPerBlock;
1668 
1669     // The block number when WPC mining starts.
1670     uint256 public startBlock;
1671 
1672     // The block number when WPC claim starts.
1673     uint256 public enableClaimBlock;
1674 
1675     // Interval blocks to reduce mining volume.
1676     uint256 public reduceIntervalBlock;
1677 
1678     // reduce rate
1679     uint256 public reduceRate;
1680 
1681     // Info of each pool.
1682     PoolInfo[] public poolInfo;
1683 
1684     // Info of each user that stakes LP tokens.
1685     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1686     mapping(uint256 => address[]) public userAddresses;
1687 
1688     // Total allocation points. Must be the sum of all allocation points in all pools.
1689     uint256 public totalAllocPoint;
1690 
1691     event Stake(address indexed user, uint256 indexed pid, uint256 amount);
1692     event Claim(address indexed user, uint256 indexed pid);
1693     event UnStake(address indexed user, uint256 indexed pid, uint256 amount);
1694     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1695     event ReplaceMigrate(address indexed user, uint256 pid, uint256 amount);
1696     event Migrate(address indexed user, uint256 pid, uint256 targetPid, uint256 amount);
1697 
1698     constructor (
1699         WePiggyToken _piggy,
1700         address _devAddr,
1701         uint256 _piggyPerBlock,
1702         uint256 _startBlock,
1703         uint256 _enableClaimBlock,
1704         uint256 _reduceIntervalBlock,
1705         uint256 _reduceRate,
1706         uint256 _devMiningRate
1707     ) public {
1708         piggy = _piggy;
1709         devAddr = _devAddr;
1710         piggyPerBlock = _piggyPerBlock;
1711         startBlock = _startBlock;
1712         reduceIntervalBlock = _reduceIntervalBlock;
1713         reduceRate = _reduceRate;
1714         devMiningRate = _devMiningRate;
1715         enableClaimBlock = _enableClaimBlock;
1716 
1717         totalAllocPoint = 0;
1718     }
1719 
1720     function poolLength() external view returns (uint256) {
1721         return poolInfo.length;
1722     }
1723 
1724     function usersLength(uint256 _pid) external view returns (uint256) {
1725         return userAddresses[_pid].length;
1726     }
1727 
1728     // Update dev address by the previous dev.
1729     function setDevAddr(address _devAddr) public onlyOwner {
1730         devAddr = _devAddr;
1731     }
1732 
1733     // Set the migrator contract. Can only be called by the owner.
1734     function setMigrator(uint256 _pid, IMigrator _migrator) public onlyOwner {
1735         poolInfo[_pid].migrator = _migrator;
1736     }
1737 
1738     // set the enable claim block
1739     function setEnableClaimBlock(uint256 _enableClaimBlock) public onlyOwner {
1740         enableClaimBlock = _enableClaimBlock;
1741     }
1742 
1743     // update reduceIntervalBlock
1744     function setReduceIntervalBlock(uint256 _reduceIntervalBlock, bool _withUpdate) public onlyOwner {
1745         if (_withUpdate) {
1746             massUpdatePools();
1747         }
1748         reduceIntervalBlock = _reduceIntervalBlock;
1749     }
1750 
1751     // Update the given pool's PIGGY allocation point. Can only be called by the owner.
1752     function setAllocPoint(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1753         if (_withUpdate) {
1754             massUpdatePools();
1755         }
1756         //update totalAllocPoint
1757         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1758 
1759         //update poolInfo
1760         poolInfo[_pid].allocPoint = _allocPoint;
1761     }
1762 
1763     // update reduce rate
1764     function setReduceRate(uint256 _reduceRate, bool _withUpdate) public onlyOwner {
1765         if (_withUpdate) {
1766             massUpdatePools();
1767         }
1768         reduceRate = _reduceRate;
1769     }
1770 
1771     // update dev mining rate
1772     function setDevMiningRate(uint256 _devMiningRate) public onlyOwner {
1773         devMiningRate = _devMiningRate;
1774     }
1775 
1776     // Migrate lp token to another lp contract.
1777     function replaceMigrate(uint256 _pid) public onlyOwner {
1778         PoolInfo storage pool = poolInfo[_pid];
1779         IMigrator migrator = pool.migrator;
1780         require(address(migrator) != address(0), "migrate: no migrator");
1781 
1782         IERC20 lpToken = pool.lpToken;
1783         uint256 bal = lpToken.balanceOf(address(this));
1784         lpToken.safeApprove(address(migrator), bal);
1785         (IERC20 newLpToken, uint mintBal) = migrator.replaceMigrate(lpToken);
1786 
1787         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1788         pool.lpToken = newLpToken;
1789 
1790         emit ReplaceMigrate(address(migrator), _pid, bal);
1791     }
1792 
1793     // Move lp token data to another lp contract.
1794     function migrate(uint256 _pid, uint256 _targetPid, uint256 begin) public onlyOwner {
1795 
1796         require(begin < userAddresses[_pid].length, "migrate: begin error");
1797 
1798         PoolInfo storage pool = poolInfo[_pid];
1799         IMigrator migrator = pool.migrator;
1800         require(address(migrator) != address(0), "migrate: no migrator");
1801 
1802         IERC20 lpToken = pool.lpToken;
1803         uint256 bal = lpToken.balanceOf(address(this));
1804         lpToken.safeApprove(address(migrator), bal);
1805         (IERC20 newLpToken, uint mintBal) = migrator.migrate(lpToken);
1806 
1807         PoolInfo storage targetPool = poolInfo[_targetPid];
1808         require(address(targetPool.lpToken) == address(newLpToken), "migrate: bad");
1809 
1810         uint rate = mintBal.mul(1e12).div(bal);
1811         for (uint i = begin; i < begin.add(20); i++) {
1812 
1813             if (i < userAddresses[_pid].length) {
1814                 updatePool(_targetPid);
1815 
1816                 address addr = userAddresses[_pid][i];
1817                 UserInfo storage user = userInfo[_pid][addr];
1818                 UserInfo storage tUser = userInfo[_targetPid][addr];
1819 
1820                 if (user.amount <= 0) {
1821                     continue;
1822                 }
1823 
1824                 uint tmp = user.amount.mul(rate).div(1e12);
1825 
1826                 tUser.amount = tUser.amount.add(tmp);
1827                 tUser.rewardDebt = tUser.rewardDebt.add(user.rewardDebt.mul(rate).div(1e12));
1828                 targetPool.totalDeposit = targetPool.totalDeposit.add(tmp);
1829                 pool.totalDeposit = pool.totalDeposit.sub(user.amount);
1830                 user.rewardDebt = 0;
1831                 user.amount = 0;
1832             } else {
1833                 break;
1834             }
1835 
1836         }
1837 
1838         emit Migrate(address(migrator), _pid, _targetPid, bal);
1839 
1840     }
1841 
1842     // Safe piggy transfer function, just in case if rounding error causes pool to not have enough PiggyToken.
1843     function safePiggyTransfer(address _to, uint256 _amount) internal {
1844         uint256 piggyBal = piggy.balanceOf(address(this));
1845         if (_amount > piggyBal) {
1846             piggy.transfer(_to, piggyBal);
1847         } else {
1848             piggy.transfer(_to, _amount);
1849         }
1850     }
1851 
1852     // Return piggyPerBlock, baseOn power  --> piggyPerBlock * (reduceRate/100)^power
1853     function getPiggyPerBlock(uint256 _power) public view returns (uint256){
1854         if (_power == 0) {
1855             return piggyPerBlock;
1856         } else {
1857             uint256 z = piggyPerBlock;
1858             for (uint256 i = 0; i < _power; i++) {
1859                 z = z.mul(reduceRate).div(1000);
1860             }
1861             return z;
1862         }
1863     }
1864 
1865     // Return reward multiplier over the given _from to _to block.
1866     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
1867         return _to.sub(_from);
1868     }
1869 
1870     // View function to see all pending PiggyToken on frontend.
1871     function allPendingPiggy(address _user) external view returns (uint256){
1872         uint sum = 0;
1873         for (uint i = 0; i < poolInfo.length; i++) {
1874             sum = sum.add(_pending(i, _user));
1875         }
1876         return sum;
1877     }
1878 
1879     // View function to see pending PiggyToken on frontend.
1880     function pendingPiggy(uint256 _pid, address _user) external view returns (uint256) {
1881         return _pending(_pid, _user);
1882     }
1883 
1884     //internal function
1885     function _pending(uint256 _pid, address _user) internal view returns (uint256) {
1886         PoolInfo storage pool = poolInfo[_pid];
1887         UserInfo storage user = userInfo[_pid][_user];
1888 
1889         uint256 accPiggyPerShare = pool.accPiggyPerShare;
1890         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1891 
1892         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1893             // pending piggy reward
1894             uint256 piggyReward = 0;
1895             uint256 lastRewardBlockPower = pool.lastRewardBlock.sub(startBlock).div(reduceIntervalBlock);
1896             uint256 blockNumberPower = block.number.sub(startBlock).div(reduceIntervalBlock);
1897 
1898             // get piggyReward from pool.lastRewardBlock to block.number.
1899             // different interval different multiplier and piggyPerBlock, sum piggyReward
1900             if (lastRewardBlockPower == blockNumberPower) {
1901                 uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1902                 piggyReward = piggyReward.add(multiplier.mul(getPiggyPerBlock(blockNumberPower)).mul(pool.allocPoint).div(totalAllocPoint));
1903             } else {
1904                 for (uint256 i = lastRewardBlockPower; i <= blockNumberPower; i++) {
1905                     uint256 multiplier = 0;
1906                     if (i == lastRewardBlockPower) {
1907                         multiplier = getMultiplier(pool.lastRewardBlock, startBlock.add(lastRewardBlockPower.add(1).mul(reduceIntervalBlock)).sub(1));
1908                     } else if (i == blockNumberPower) {
1909                         multiplier = getMultiplier(startBlock.add(blockNumberPower.mul(reduceIntervalBlock)), block.number);
1910                     } else {
1911                         multiplier = reduceIntervalBlock;
1912                     }
1913                     piggyReward = piggyReward.add(multiplier.mul(getPiggyPerBlock(i)).mul(pool.allocPoint).div(totalAllocPoint));
1914                 }
1915             }
1916 
1917             accPiggyPerShare = accPiggyPerShare.add(piggyReward.mul(1e12).div(lpSupply));
1918         }
1919 
1920         // get pending value
1921         uint256 pendingValue = user.amount.mul(accPiggyPerShare).div(1e12).sub(user.rewardDebt);
1922 
1923         // if enableClaimBlock after block.number, return pendingValue + user.pendingReward.
1924         // else return pendingValue.
1925         if (enableClaimBlock > block.number) {
1926             return pendingValue.add(user.pendingReward);
1927         } else if (user.pendingReward > 0 && user.unStakeBeforeEnableClaim) {
1928             return pendingValue.add(user.pendingReward);
1929         }
1930         return pendingValue;
1931     }
1932 
1933     // Update reward variables for all pools. Be careful of gas spending!
1934     function massUpdatePools() public {
1935         uint256 length = poolInfo.length;
1936         for (uint256 pid = 0; pid < length; ++pid) {
1937             updatePool(pid);
1938         }
1939     }
1940 
1941     // Update reward variables of the given pool to be up-to-date.
1942     function updatePool(uint256 _pid) public {
1943 
1944         PoolInfo storage pool = poolInfo[_pid];
1945         if (block.number <= pool.lastRewardBlock) {
1946             return;
1947         }
1948 
1949         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1950         if (lpSupply == 0) {
1951             pool.lastRewardBlock = block.number;
1952             return;
1953         }
1954 
1955         // get piggyReward. piggyReward base on current PiggyPerBlock.
1956         uint256 power = block.number.sub(startBlock).div(reduceIntervalBlock);
1957         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1958         uint256 piggyReward = multiplier.mul(getPiggyPerBlock(power)).mul(pool.allocPoint).div(totalAllocPoint);
1959 
1960         // mint
1961         piggy.mint(devAddr, piggyReward.mul(devMiningRate).div(100));
1962         piggy.mint(address(this), piggyReward);
1963 
1964         //update pool
1965         pool.accPiggyPerShare = pool.accPiggyPerShare.add(piggyReward.mul(1e12).div(lpSupply));
1966         pool.lastRewardBlock = block.number;
1967 
1968     }
1969 
1970     // Add a new lp to the pool. Can only be called by the owner.
1971     // DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1972     function add(uint256 _allocPoint, IERC20 _lpToken, IMigrator _migrator, bool _withUpdate) public onlyOwner {
1973 
1974         if (_withUpdate) {
1975             massUpdatePools();
1976         }
1977 
1978         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1979 
1980         //update totalAllocPoint
1981         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1982 
1983         // add poolInfo
1984         poolInfo.push(PoolInfo({
1985         lpToken : _lpToken,
1986         allocPoint : _allocPoint,
1987         lastRewardBlock : lastRewardBlock,
1988         accPiggyPerShare : 0,
1989         totalDeposit : 0,
1990         migrator : _migrator
1991         }));
1992     }
1993 
1994     // Stake LP tokens to PiggyBreeder for WPC allocation.
1995     function stake(uint256 _pid, uint256 _amount) public {
1996 
1997         PoolInfo storage pool = poolInfo[_pid];
1998         UserInfo storage user = userInfo[_pid][msg.sender];
1999 
2000         //update poolInfo by pid
2001         updatePool(_pid);
2002 
2003         // if user's amount bigger than zero, transfer PiggyToken to user.
2004         if (user.amount > 0) {
2005             uint256 pending = user.amount.mul(pool.accPiggyPerShare).div(1e12).sub(user.rewardDebt);
2006             if (pending > 0) {
2007                 // if enableClaimBlock after block.number, save the pending to user.pendingReward.
2008                 if (enableClaimBlock <= block.number) {
2009                     safePiggyTransfer(msg.sender, pending);
2010 
2011                     // transfer user.pendingReward if user.pendingReward > 0, and update user.pendingReward to 0
2012                     if (user.pendingReward > 0) {
2013                         safePiggyTransfer(msg.sender, user.pendingReward);
2014                         user.pendingReward = 0;
2015                     }
2016                 } else {
2017                     user.pendingReward = user.pendingReward.add(pending);
2018                 }
2019             }
2020         }
2021 
2022         if (_amount > 0) {
2023             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
2024             user.amount = user.amount.add(_amount);
2025             pool.totalDeposit = pool.totalDeposit.add(_amount);
2026             userAddresses[_pid].push(msg.sender);
2027         }
2028 
2029         user.rewardDebt = user.amount.mul(pool.accPiggyPerShare).div(1e12);
2030 
2031         emit Stake(msg.sender, _pid, _amount);
2032 
2033     }
2034 
2035     // UnStake LP tokens from PiggyBreeder.
2036     function unStake(uint256 _pid, uint256 _amount) public {
2037 
2038         PoolInfo storage pool = poolInfo[_pid];
2039         UserInfo storage user = userInfo[_pid][msg.sender];
2040 
2041         require(user.amount >= _amount, "unStake: not good");
2042 
2043         //update poolInfo by pid
2044         updatePool(_pid);
2045 
2046         //transfer PiggyToken to user.
2047         uint256 pending = user.amount.mul(pool.accPiggyPerShare).div(1e12).sub(user.rewardDebt);
2048         if (pending > 0) {
2049             // if enableClaimBlock after block.number, save the pending to user.pendingReward.
2050             if (enableClaimBlock <= block.number) {
2051                 safePiggyTransfer(msg.sender, pending);
2052 
2053                 // transfer user.pendingReward if user.pendingReward > 0, and update user.pendingReward to 0
2054                 if (user.pendingReward > 0) {
2055                     safePiggyTransfer(msg.sender, user.pendingReward);
2056                     user.pendingReward = 0;
2057                 }
2058             } else {
2059                 user.pendingReward = user.pendingReward.add(pending);
2060                 user.unStakeBeforeEnableClaim = true;
2061             }
2062         }
2063 
2064         if (_amount > 0) {
2065             // transfer LP tokens to user
2066             pool.lpToken.safeTransfer(address(msg.sender), _amount);
2067             // update user info
2068             user.amount = user.amount.sub(_amount);
2069             pool.totalDeposit = pool.totalDeposit.sub(_amount);
2070         }
2071 
2072         user.rewardDebt = user.amount.mul(pool.accPiggyPerShare).div(1e12);
2073 
2074         emit UnStake(msg.sender, _pid, _amount);
2075     }
2076 
2077     // claim WPC
2078     function claim(uint256 _pid) public {
2079 
2080         require(enableClaimBlock <= block.number, "too early to claim");
2081 
2082         PoolInfo storage pool = poolInfo[_pid];
2083         UserInfo storage user = userInfo[_pid][msg.sender];
2084 
2085         //update poolInfo by pid
2086         updatePool(_pid);
2087 
2088         // if user's amount bigger than zero, transfer PiggyToken to user.
2089         if (user.amount > 0) {
2090             uint256 pending = user.amount.mul(pool.accPiggyPerShare).div(1e12).sub(user.rewardDebt);
2091             if (pending > 0) {
2092                 safePiggyTransfer(msg.sender, pending);
2093             }
2094         }
2095 
2096         // transfer user.pendingReward if user.pendingReward > 0, and update user.pendingReward to 0
2097         if (user.pendingReward > 0) {
2098             safePiggyTransfer(msg.sender, user.pendingReward);
2099             user.pendingReward = 0;
2100         }
2101 
2102         // update user info
2103         user.rewardDebt = user.amount.mul(pool.accPiggyPerShare).div(1e12);
2104 
2105         emit Claim(msg.sender, _pid);
2106     }
2107 
2108     // Withdraw without caring about rewards. EMERGENCY ONLY.
2109     function emergencyWithdraw(uint256 _pid) public {
2110 
2111         PoolInfo storage pool = poolInfo[_pid];
2112         UserInfo storage user = userInfo[_pid][msg.sender];
2113 
2114         uint256 amount = user.amount;
2115 
2116         // transfer LP tokens to user
2117         pool.lpToken.safeTransfer(address(msg.sender), amount);
2118 
2119         pool.totalDeposit = pool.totalDeposit.sub(user.amount);
2120         // update user info
2121         user.amount = 0;
2122         user.rewardDebt = 0;
2123 
2124         emit EmergencyWithdraw(msg.sender, _pid, amount);
2125     }
2126 
2127 
2128 }