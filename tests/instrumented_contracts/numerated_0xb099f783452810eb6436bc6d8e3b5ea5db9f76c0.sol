1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT + WTFPL
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
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
243 // File: @openzeppelin/contracts/utils/Address.sol
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
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 
390 
391 pragma solidity ^0.6.0;
392 
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
464 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
465 
466 
467 
468 pragma solidity ^0.6.0;
469 
470 /**
471  * @dev Library for managing
472  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
473  * types.
474  *
475  * Sets have the following properties:
476  *
477  * - Elements are added, removed, and checked for existence in constant time
478  * (O(1)).
479  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
480  *
481  * ```
482  * contract Example {
483  *     // Add the library methods
484  *     using EnumerableSet for EnumerableSet.AddressSet;
485  *
486  *     // Declare a set state variable
487  *     EnumerableSet.AddressSet private mySet;
488  * }
489  * ```
490  *
491  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
492  * (`UintSet`) are supported.
493  */
494 library EnumerableSet {
495     // To implement this library for multiple types with as little code
496     // repetition as possible, we write it in terms of a generic Set type with
497     // bytes32 values.
498     // The Set implementation uses private functions, and user-facing
499     // implementations (such as AddressSet) are just wrappers around the
500     // underlying Set.
501     // This means that we can only create new EnumerableSets for types that fit
502     // in bytes32.
503 
504     struct Set {
505         // Storage of set values
506         bytes32[] _values;
507 
508         // Position of the value in the `values` array, plus 1 because index 0
509         // means a value is not in the set.
510         mapping (bytes32 => uint256) _indexes;
511     }
512 
513     /**
514      * @dev Add a value to a set. O(1).
515      *
516      * Returns true if the value was added to the set, that is if it was not
517      * already present.
518      */
519     function _add(Set storage set, bytes32 value) private returns (bool) {
520         if (!_contains(set, value)) {
521             set._values.push(value);
522             // The value is stored at length-1, but we add 1 to all indexes
523             // and use 0 as a sentinel value
524             set._indexes[value] = set._values.length;
525             return true;
526         } else {
527             return false;
528         }
529     }
530 
531     /**
532      * @dev Removes a value from a set. O(1).
533      *
534      * Returns true if the value was removed from the set, that is if it was
535      * present.
536      */
537     function _remove(Set storage set, bytes32 value) private returns (bool) {
538         // We read and store the value's index to prevent multiple reads from the same storage slot
539         uint256 valueIndex = set._indexes[value];
540 
541         if (valueIndex != 0) { // Equivalent to contains(set, value)
542             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
543             // the array, and then remove the last element (sometimes called as 'swap and pop').
544             // This modifies the order of the array, as noted in {at}.
545 
546             uint256 toDeleteIndex = valueIndex - 1;
547             uint256 lastIndex = set._values.length - 1;
548 
549             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
550             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
551 
552             bytes32 lastvalue = set._values[lastIndex];
553 
554             // Move the last value to the index where the value to delete is
555             set._values[toDeleteIndex] = lastvalue;
556             // Update the index for the moved value
557             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
558 
559             // Delete the slot where the moved value was stored
560             set._values.pop();
561 
562             // Delete the index for the deleted slot
563             delete set._indexes[value];
564 
565             return true;
566         } else {
567             return false;
568         }
569     }
570 
571     /**
572      * @dev Returns true if the value is in the set. O(1).
573      */
574     function _contains(Set storage set, bytes32 value) private view returns (bool) {
575         return set._indexes[value] != 0;
576     }
577 
578     /**
579      * @dev Returns the number of values on the set. O(1).
580      */
581     function _length(Set storage set) private view returns (uint256) {
582         return set._values.length;
583     }
584 
585    /**
586     * @dev Returns the value stored at position `index` in the set. O(1).
587     *
588     * Note that there are no guarantees on the ordering of values inside the
589     * array, and it may change when more values are added or removed.
590     *
591     * Requirements:
592     *
593     * - `index` must be strictly less than {length}.
594     */
595     function _at(Set storage set, uint256 index) private view returns (bytes32) {
596         require(set._values.length > index, "EnumerableSet: index out of bounds");
597         return set._values[index];
598     }
599 
600     // AddressSet
601 
602     struct AddressSet {
603         Set _inner;
604     }
605 
606     /**
607      * @dev Add a value to a set. O(1).
608      *
609      * Returns true if the value was added to the set, that is if it was not
610      * already present.
611      */
612     function add(AddressSet storage set, address value) internal returns (bool) {
613         return _add(set._inner, bytes32(uint256(value)));
614     }
615 
616     /**
617      * @dev Removes a value from a set. O(1).
618      *
619      * Returns true if the value was removed from the set, that is if it was
620      * present.
621      */
622     function remove(AddressSet storage set, address value) internal returns (bool) {
623         return _remove(set._inner, bytes32(uint256(value)));
624     }
625 
626     /**
627      * @dev Returns true if the value is in the set. O(1).
628      */
629     function contains(AddressSet storage set, address value) internal view returns (bool) {
630         return _contains(set._inner, bytes32(uint256(value)));
631     }
632 
633     /**
634      * @dev Returns the number of values in the set. O(1).
635      */
636     function length(AddressSet storage set) internal view returns (uint256) {
637         return _length(set._inner);
638     }
639 
640    /**
641     * @dev Returns the value stored at position `index` in the set. O(1).
642     *
643     * Note that there are no guarantees on the ordering of values inside the
644     * array, and it may change when more values are added or removed.
645     *
646     * Requirements:
647     *
648     * - `index` must be strictly less than {length}.
649     */
650     function at(AddressSet storage set, uint256 index) internal view returns (address) {
651         return address(uint256(_at(set._inner, index)));
652     }
653 
654 
655     // UintSet
656 
657     struct UintSet {
658         Set _inner;
659     }
660 
661     /**
662      * @dev Add a value to a set. O(1).
663      *
664      * Returns true if the value was added to the set, that is if it was not
665      * already present.
666      */
667     function add(UintSet storage set, uint256 value) internal returns (bool) {
668         return _add(set._inner, bytes32(value));
669     }
670 
671     /**
672      * @dev Removes a value from a set. O(1).
673      *
674      * Returns true if the value was removed from the set, that is if it was
675      * present.
676      */
677     function remove(UintSet storage set, uint256 value) internal returns (bool) {
678         return _remove(set._inner, bytes32(value));
679     }
680 
681     /**
682      * @dev Returns true if the value is in the set. O(1).
683      */
684     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
685         return _contains(set._inner, bytes32(value));
686     }
687 
688     /**
689      * @dev Returns the number of values on the set. O(1).
690      */
691     function length(UintSet storage set) internal view returns (uint256) {
692         return _length(set._inner);
693     }
694 
695    /**
696     * @dev Returns the value stored at position `index` in the set. O(1).
697     *
698     * Note that there are no guarantees on the ordering of values inside the
699     * array, and it may change when more values are added or removed.
700     *
701     * Requirements:
702     *
703     * - `index` must be strictly less than {length}.
704     */
705     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
706         return uint256(_at(set._inner, index));
707     }
708 }
709 
710 // File: @openzeppelin/contracts/GSN/Context.sol
711 
712 
713 
714 pragma solidity ^0.6.0;
715 
716 /*
717  * @dev Provides information about the current execution context, including the
718  * sender of the transaction and its data. While these are generally available
719  * via msg.sender and msg.data, they should not be accessed in such a direct
720  * manner, since when dealing with GSN meta-transactions the account sending and
721  * paying for execution may not be the actual sender (as far as an application
722  * is concerned).
723  *
724  * This contract is only required for intermediate, library-like contracts.
725  */
726 abstract contract Context {
727     function _msgSender() internal view virtual returns (address payable) {
728         return msg.sender;
729     }
730 
731     function _msgData() internal view virtual returns (bytes memory) {
732         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
733         return msg.data;
734     }
735 }
736 
737 // File: @openzeppelin/contracts/access/Ownable.sol
738 
739 
740 
741 pragma solidity ^0.6.0;
742 
743 /**
744  * @dev Contract module which provides a basic access control mechanism, where
745  * there is an account (an owner) that can be granted exclusive access to
746  * specific functions.
747  *
748  * By default, the owner account will be the one that deploys the contract. This
749  * can later be changed with {transferOwnership}.
750  *
751  * This module is used through inheritance. It will make available the modifier
752  * `onlyOwner`, which can be applied to your functions to restrict their use to
753  * the owner.
754  */
755 contract Ownable is Context {
756     address private _owner;
757 
758     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
759 
760     /**
761      * @dev Initializes the contract setting the deployer as the initial owner.
762      */
763     constructor () internal {
764         address msgSender = _msgSender();
765         _owner = msgSender;
766         emit OwnershipTransferred(address(0), msgSender);
767     }
768 
769     /**
770      * @dev Returns the address of the current owner.
771      */
772     function owner() public view returns (address) {
773         return _owner;
774     }
775 
776     /**
777      * @dev Throws if called by any account other than the owner.
778      */
779     modifier onlyOwner() {
780         require(_owner == _msgSender(), "Ownable: caller is not the owner");
781         _;
782     }
783 
784     /**
785      * @dev Leaves the contract without owner. It will not be possible to call
786      * `onlyOwner` functions anymore. Can only be called by the current owner.
787      *
788      * NOTE: Renouncing ownership will leave the contract without an owner,
789      * thereby removing any functionality that is only available to the owner.
790      */
791     function renounceOwnership() public virtual onlyOwner {
792         emit OwnershipTransferred(_owner, address(0));
793         _owner = address(0);
794     }
795 
796     /**
797      * @dev Transfers ownership of the contract to a new account (`newOwner`).
798      * Can only be called by the current owner.
799      */
800     function transferOwnership(address newOwner) public virtual onlyOwner {
801         require(newOwner != address(0), "Ownable: new owner is the zero address");
802         emit OwnershipTransferred(_owner, newOwner);
803         _owner = newOwner;
804     }
805 }
806 
807 // File: contracts/TramsToken.sol
808 
809 
810 
811 pragma solidity 0.6.12;
812 
813 
814 
815 
816 
817 
818 // TramsToken with Governance.
819 contract TramsToken is Context, IERC20, Ownable {
820     using SafeMath for uint256;
821     using Address for address;
822 
823     mapping (address => uint256) private _balances;
824 
825     mapping (address => mapping (address => uint256)) private _allowances;
826 
827     uint256 private _totalSupply;
828 
829     string private _name = "TramsToken";
830     string private _symbol = "TRAMS";
831     uint8 private _decimals = 18;
832 
833     /**
834      * @dev Returns the name of the token.
835      */
836     function name() public view returns (string memory) {
837         return _name;
838     }
839 
840     /**
841      * @dev Returns the symbol of the token, usually a shorter version of the
842      * name.
843      */
844     function symbol() public view returns (string memory) {
845         return _symbol;
846     }
847 
848     /**
849      * @dev Returns the number of decimals used to get its user representation.
850      * For example, if `decimals` equals `2`, a balance of `505` tokens should
851      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
852      *
853      * Tokens usually opt for a value of 18, imitating the relationship between
854      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
855      * called.
856      *
857      * NOTE: This information is only used for _display_ purposes: it in
858      * no way affects any of the arithmetic of the contract, including
859      * {IERC20-balanceOf} and {IERC20-transfer}.
860      */
861     function decimals() public view returns (uint8) {
862         return _decimals;
863     }
864 
865     /**
866      * @dev See {IERC20-totalSupply}.
867      */
868     function totalSupply() public view override returns (uint256) {
869         return _totalSupply;
870     }
871 
872     /**
873      * @dev See {IERC20-balanceOf}.
874      */
875     function balanceOf(address account) public view override returns (uint256) {
876         return _balances[account];
877     }
878 
879     /**
880      * @dev See {IERC20-transfer}.
881      *
882      * Requirements:
883      *
884      * - `recipient` cannot be the zero address.
885      * - the caller must have a balance of at least `amount`.
886      */
887     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
888         _transfer(_msgSender(), recipient, amount);
889         return true;
890     }
891 
892     /**
893      * @dev See {IERC20-allowance}.
894      */
895     function allowance(address owner, address spender) public view virtual override returns (uint256) {
896         return _allowances[owner][spender];
897     }
898 
899     /**
900      * @dev See {IERC20-approve}.
901      *
902      * Requirements:
903      *
904      * - `spender` cannot be the zero address.
905      */
906     function approve(address spender, uint256 amount) public virtual override returns (bool) {
907         _approve(_msgSender(), spender, amount);
908         return true;
909     }
910 
911     /**
912      * @dev See {IERC20-transferFrom}.
913      *
914      * Emits an {Approval} event indicating the updated allowance. This is not
915      * required by the EIP. See the note at the beginning of {ERC20};
916      *
917      * Requirements:
918      * - `sender` and `recipient` cannot be the zero address.
919      * - `sender` must have a balance of at least `amount`.
920      * - the caller must have allowance for ``sender``'s tokens of at least
921      * `amount`.
922      */
923     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
924         _transfer(sender, recipient, amount);
925         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
926         return true;
927     }
928 
929     /**
930      * @dev Atomically increases the allowance granted to `spender` by the caller.
931      *
932      * This is an alternative to {approve} that can be used as a mitigation for
933      * problems described in {IERC20-approve}.
934      *
935      * Emits an {Approval} event indicating the updated allowance.
936      *
937      * Requirements:
938      *
939      * - `spender` cannot be the zero address.
940      */
941     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
942         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
943         return true;
944     }
945 
946     /**
947      * @dev Atomically decreases the allowance granted to `spender` by the caller.
948      *
949      * This is an alternative to {approve} that can be used as a mitigation for
950      * problems described in {IERC20-approve}.
951      *
952      * Emits an {Approval} event indicating the updated allowance.
953      *
954      * Requirements:
955      *
956      * - `spender` cannot be the zero address.
957      * - `spender` must have allowance for the caller of at least
958      * `subtractedValue`.
959      */
960     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
961         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
962         return true;
963     }
964 
965     /**
966      * @dev Moves tokens `amount` from `sender` to `recipient`.
967      *
968      * This is internal function is equivalent to {transfer}, and can be used to
969      * e.g. implement automatic token fees, slashing mechanisms, etc.
970      *
971      * Emits a {Transfer} event.
972      *
973      * Requirements:
974      *
975      * - `sender` cannot be the zero address.
976      * - `recipient` cannot be the zero address.
977      * - `sender` must have a balance of at least `amount`.
978      */
979     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
980         require(sender != address(0), "ERC20: transfer from the zero address");
981         require(recipient != address(0), "ERC20: transfer to the zero address");
982 
983         _beforeTokenTransfer(sender, recipient, amount);
984 
985         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
986         _balances[recipient] = _balances[recipient].add(amount);
987         emit Transfer(sender, recipient, amount);
988 
989         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
990     }
991 
992     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
993      * the total supply.
994      *
995      * Emits a {Transfer} event with `from` set to the zero address.
996      *
997      * Requirements
998      *
999      * - `to` cannot be the zero address.
1000      */
1001     function _mint(address account, uint256 amount) internal virtual {
1002         require(account != address(0), "ERC20: mint to the zero address");
1003 
1004         _beforeTokenTransfer(address(0), account, amount);
1005 
1006         _totalSupply = _totalSupply.add(amount);
1007         _balances[account] = _balances[account].add(amount);
1008         emit Transfer(address(0), account, amount);
1009     }
1010 
1011     /**
1012      * @dev Destroys `amount` tokens from `account`, reducing the
1013      * total supply.
1014      *
1015      * Emits a {Transfer} event with `to` set to the zero address.
1016      *
1017      * Requirements
1018      *
1019      * - `account` cannot be the zero address.
1020      * - `account` must have at least `amount` tokens.
1021      */
1022     function _burn(address account, uint256 amount) internal virtual {
1023         require(account != address(0), "ERC20: burn from the zero address");
1024 
1025         _beforeTokenTransfer(account, address(0), amount);
1026 
1027         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1028         _totalSupply = _totalSupply.sub(amount);
1029         emit Transfer(account, address(0), amount);
1030     }
1031 
1032     /**
1033      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1034      *
1035      * This is internal function is equivalent to `approve`, and can be used to
1036      * e.g. set automatic allowances for certain subsystems, etc.
1037      *
1038      * Emits an {Approval} event.
1039      *
1040      * Requirements:
1041      *
1042      * - `owner` cannot be the zero address.
1043      * - `spender` cannot be the zero address.
1044      */
1045     function _approve(address owner, address spender, uint256 amount) internal virtual {
1046         require(owner != address(0), "ERC20: approve from the zero address");
1047         require(spender != address(0), "ERC20: approve to the zero address");
1048 
1049         _allowances[owner][spender] = amount;
1050         emit Approval(owner, spender, amount);
1051     }
1052 
1053     /**
1054      * @dev Sets {decimals} to a value other than the default one of 18.
1055      *
1056      * WARNING: This function should only be called from the constructor. Most
1057      * applications that interact with token contracts will not expect
1058      * {decimals} to ever change, and may work incorrectly if it does.
1059      */
1060     function _setupDecimals(uint8 decimals_) internal {
1061         _decimals = decimals_;
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any transfer of tokens. This includes
1066      * minting and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1071      * will be to transferred to `to`.
1072      * - when `from` is zero, `amount` tokens will be minted for `to`.
1073      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1074      * - `from` and `to` are never both zero.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1079 
1080     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (TramsMaster).
1081     function mint(address _to, uint256 _amount) public onlyOwner {
1082         _mint(_to, _amount);
1083         _moveDelegates(address(0), _delegates[_to], _amount);
1084     }
1085 
1086     // Copied and modified from YAM code:
1087     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1088     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1089     // Which is copied and modified from COMPOUND:
1090     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1091 
1092     /// @dev A record of each accounts delegate
1093     mapping (address => address) internal _delegates;
1094 
1095     /// @notice A checkpoint for marking number of votes from a given block
1096     struct Checkpoint {
1097         uint32 fromBlock;
1098         uint256 votes;
1099     }
1100 
1101     /// @notice A record of votes checkpoints for each account, by index
1102     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1103 
1104     /// @notice The number of checkpoints for each account
1105     mapping (address => uint32) public numCheckpoints;
1106 
1107     /// @notice The EIP-712 typehash for the contract's domain
1108     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1109 
1110     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1111     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1112 
1113     /// @notice A record of states for signing / validating signatures
1114     mapping (address => uint) public nonces;
1115 
1116     /// @notice An event thats emitted when an account changes its delegate
1117     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1118 
1119     /// @notice An event thats emitted when a delegate account's vote balance changes
1120     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1121 
1122     /**
1123      * @notice Delegate votes from `msg.sender` to `delegatee`
1124      * @param delegator The address to get delegatee for
1125      */
1126     function delegates(address delegator)
1127         external
1128         view
1129         returns (address)
1130     {
1131         return _delegates[delegator];
1132     }
1133 
1134    /**
1135     * @notice Delegate votes from `msg.sender` to `delegatee`
1136     * @param delegatee The address to delegate votes to
1137     */
1138     function delegate(address delegatee) external {
1139         return _delegate(msg.sender, delegatee);
1140     }
1141 
1142     /**
1143      * @notice Delegates votes from signatory to `delegatee`
1144      * @param delegatee The address to delegate votes to
1145      * @param nonce The contract state required to match the signature
1146      * @param expiry The time at which to expire the signature
1147      * @param v The recovery byte of the signature
1148      * @param r Half of the ECDSA signature pair
1149      * @param s Half of the ECDSA signature pair
1150      */
1151     function delegateBySig(
1152         address delegatee,
1153         uint nonce,
1154         uint expiry,
1155         uint8 v,
1156         bytes32 r,
1157         bytes32 s
1158     )
1159         external
1160     {
1161         bytes32 domainSeparator = keccak256(
1162             abi.encode(
1163                 DOMAIN_TYPEHASH,
1164                 keccak256(bytes(name())),
1165                 getChainId(),
1166                 address(this)
1167             )
1168         );
1169 
1170         bytes32 structHash = keccak256(
1171             abi.encode(
1172                 DELEGATION_TYPEHASH,
1173                 delegatee,
1174                 nonce,
1175                 expiry
1176             )
1177         );
1178 
1179         bytes32 digest = keccak256(
1180             abi.encodePacked(
1181                 "\x19\x01",
1182                 domainSeparator,
1183                 structHash
1184             )
1185         );
1186 
1187         address signatory = ecrecover(digest, v, r, s);
1188         require(signatory != address(0), "TRAMS::delegateBySig: invalid signature");
1189         require(nonce == nonces[signatory]++, "TRAMS::delegateBySig: invalid nonce");
1190         require(now <= expiry, "TRAMS::delegateBySig: signature expired");
1191         return _delegate(signatory, delegatee);
1192     }
1193 
1194     /**
1195      * @notice Gets the current votes balance for `account`
1196      * @param account The address to get votes balance
1197      * @return The number of current votes for `account`
1198      */
1199     function getCurrentVotes(address account)
1200         external
1201         view
1202         returns (uint256)
1203     {
1204         uint32 nCheckpoints = numCheckpoints[account];
1205         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1206     }
1207 
1208     /**
1209      * @notice Determine the prior number of votes for an account as of a block number
1210      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1211      * @param account The address of the account to check
1212      * @param blockNumber The block number to get the vote balance at
1213      * @return The number of votes the account had as of the given block
1214      */
1215     function getPriorVotes(address account, uint blockNumber)
1216         external
1217         view
1218         returns (uint256)
1219     {
1220         require(blockNumber < block.number, "TRAMS::getPriorVotes: not yet determined");
1221 
1222         uint32 nCheckpoints = numCheckpoints[account];
1223         if (nCheckpoints == 0) {
1224             return 0;
1225         }
1226 
1227         // First check most recent balance
1228         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1229             return checkpoints[account][nCheckpoints - 1].votes;
1230         }
1231 
1232         // Next check implicit zero balance
1233         if (checkpoints[account][0].fromBlock > blockNumber) {
1234             return 0;
1235         }
1236 
1237         uint32 lower = 0;
1238         uint32 upper = nCheckpoints - 1;
1239         while (upper > lower) {
1240             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1241             Checkpoint memory cp = checkpoints[account][center];
1242             if (cp.fromBlock == blockNumber) {
1243                 return cp.votes;
1244             } else if (cp.fromBlock < blockNumber) {
1245                 lower = center;
1246             } else {
1247                 upper = center - 1;
1248             }
1249         }
1250         return checkpoints[account][lower].votes;
1251     }
1252 
1253     function _delegate(address delegator, address delegatee)
1254         internal
1255     {
1256         address currentDelegate = _delegates[delegator];
1257         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying TRAMS (not scaled);
1258         _delegates[delegator] = delegatee;
1259 
1260         emit DelegateChanged(delegator, currentDelegate, delegatee);
1261 
1262         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1263     }
1264 
1265     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1266         if (srcRep != dstRep && amount > 0) {
1267             if (srcRep != address(0)) {
1268                 // decrease old representative
1269                 uint32 srcRepNum = numCheckpoints[srcRep];
1270                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1271                 uint256 srcRepNew = srcRepOld.sub(amount);
1272                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1273             }
1274 
1275             if (dstRep != address(0)) {
1276                 // increase new representative
1277                 uint32 dstRepNum = numCheckpoints[dstRep];
1278                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1279                 uint256 dstRepNew = dstRepOld.add(amount);
1280                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1281             }
1282         }
1283     }
1284 
1285     function _writeCheckpoint(
1286         address delegatee,
1287         uint32 nCheckpoints,
1288         uint256 oldVotes,
1289         uint256 newVotes
1290     )
1291         internal
1292     {
1293         uint32 blockNumber = safe32(block.number, "TRAMS::_writeCheckpoint: block number exceeds 32 bits");
1294 
1295         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1296             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1297         } else {
1298             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1299             numCheckpoints[delegatee] = nCheckpoints + 1;
1300         }
1301 
1302         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1303     }
1304 
1305     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1306         require(n < 2**32, errorMessage);
1307         return uint32(n);
1308     }
1309 
1310     function getChainId() internal pure returns (uint) {
1311         uint256 chainId;
1312         assembly { chainId := chainid() }
1313         return chainId;
1314     }
1315 }
1316 
1317 // File: contracts/TramsMaster.sol
1318 
1319 
1320 
1321 pragma solidity 0.6.12;
1322 
1323 
1324 
1325 
1326 
1327 
1328 
1329 
1330 interface IMigratorChef {
1331     // Perform LP token migration from legacy UniswapV2 to TramsDex.
1332     // Take the current LP token address and return the new LP token address.
1333     // Migrator should have full access to the caller's LP token.
1334     // Return the new LP token address.
1335     //
1336     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1337     // TramsDex must mint EXACTLY the same amount of TramsDex LP tokens or
1338     // else something bad will happen. Traditional UniswapV2 does not
1339     // do that so be careful!
1340     function migrate(IERC20 token) external returns (IERC20);
1341 }
1342 
1343 
1344 // TramsMaster is the master of Trams. He can make TRAMS .
1345 //
1346 // Note that it's ownable and the owner wields tremendous power. The ownership
1347 // will be transferred to a governance smart contract once TRAMS is sufficiently
1348 // distributed and the community can show to govern itself.
1349 //
1350 // Have fun reading it. Hopefully it's bug-free. God bless.
1351 contract TramsMaster is Ownable {
1352     using SafeMath for uint256;
1353     using SafeERC20 for IERC20;
1354 
1355     // Info of each user.
1356     struct UserInfo {
1357         uint256 amount; // How many LP tokens the user has provided.
1358         uint256 rewardDebt; // Reward debt. See explanation below.
1359         //
1360         // We do some fancy math here. Basically, any point in time, the amount of TRAMS
1361         // entitled to a user but is pending to be distributed is:
1362         //
1363         //   pending reward = (user.amount * pool.accTramsPerShare) - user.rewardDebt
1364         //
1365         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1366         //   1. The pool's `accTramsPerShare` (and `lastRewardBlock`) gets updated.
1367         //   2. User receives the pending reward sent to his/her address.
1368         //   3. User's `amount` gets updated.
1369         //   4. User's `rewardDebt` gets updated.
1370     }
1371 
1372     // Info of each pool.
1373     struct PoolInfo {
1374         IERC20 lpToken; // Address of LP token contract.
1375         uint256 allocPoint; // How many allocation points assigned to this pool. TRAMS to distribute per block.
1376         uint256 lastRewardBlock; // Last block number that TRAMS distribution occurs.
1377         uint256 accTramsPerShare; // Accumulated TRAMS per share, times 1e12. See below.
1378     }
1379 
1380     // The TRAMS TOKEN!
1381     TramsToken public trams;
1382     // Dev address.
1383     address public devaddr;
1384     // Block number when beta test period ends.
1385     uint256 public betaTestEndBlock;
1386     // Block number when bonus TRAMS period ends.
1387     uint256 public bonusEndBlock;
1388     // Block number when mint TRAMS period ends.
1389     uint256 public mintEndBlock;
1390     // TRAMS tokens created per block.
1391     uint256 public tramsPerBlock;
1392     // Bonus muliplier for 7~22 days trams makers.
1393     uint256 public constant BONUSONE_MULTIPLIER = 20;
1394     // Bonus muliplier for 22 days onwards till mintend, trams makers.
1395     uint256 public constant BONUSTWO_MULTIPLIER = 2;
1396     // beta test block num,about 7 days.
1397     uint256 public constant BETATEST_BLOCKNUM = 46530;
1398     // Bonus block num,about 15 days.
1399     uint256 public constant BONUS_BLOCKNUM = 99750;
1400     // mint end block num,about 73+15 days.
1401     uint256 public constant MINTEND_BLOCKNUM = 585134;
1402     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1403     IMigratorChef public migrator;
1404 
1405     // Info of each pool.
1406     PoolInfo[] public poolInfo;
1407     // Info of each user that stakes LP tokens.
1408     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1409     // Record whether the pair has been added.
1410     mapping(address => uint256) public lpTokenPID;
1411     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1412     uint256 public totalAllocPoint = 0;
1413     // The block number when TRAMS mining starts.
1414     uint256 public startBlock;
1415 
1416     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1417     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1418     event EmergencyWithdraw(
1419         address indexed user,
1420         uint256 indexed pid,
1421         uint256 amount
1422     );
1423 
1424     constructor(
1425         TramsToken _trams,
1426         address _devaddr,
1427         uint256 _tramsPerBlock,
1428         uint256 _startBlock
1429     ) public {
1430         trams = _trams;
1431         devaddr = _devaddr;
1432         tramsPerBlock = _tramsPerBlock;
1433         startBlock = _startBlock;
1434         betaTestEndBlock = startBlock.add(BETATEST_BLOCKNUM);
1435         bonusEndBlock = startBlock.add(BONUS_BLOCKNUM).add(BETATEST_BLOCKNUM);
1436         mintEndBlock = startBlock.add(MINTEND_BLOCKNUM).add(BETATEST_BLOCKNUM);
1437     }
1438 
1439     function poolLength() external view returns (uint256) {
1440         return poolInfo.length;
1441     }
1442 
1443     // Add a new lp to the pool. Can only be called by the owner.
1444     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1445     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1446         if (_withUpdate) {
1447             massUpdatePools();
1448         }
1449         require(lpTokenPID[address(_lpToken)] == 0, "TramsMaster:duplicate add.");
1450         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1451         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1452         poolInfo.push(
1453             PoolInfo({
1454                 lpToken: _lpToken,
1455                 allocPoint: _allocPoint,
1456                 lastRewardBlock: lastRewardBlock,
1457                 accTramsPerShare: 0
1458             })
1459         );
1460         lpTokenPID[address(_lpToken)] = poolInfo.length;
1461     }
1462 
1463     // Update the given pool's TRAMS allocation point. Can only be called by the owner.
1464     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1465         if (_withUpdate) {
1466             massUpdatePools();
1467         }
1468         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1469         poolInfo[_pid].allocPoint = _allocPoint;
1470     }
1471 
1472     // Set the migrator contract. Can only be called by the owner.
1473     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1474         migrator = _migrator;
1475     }
1476 
1477     // Handover the tramstoken mintage right.
1478     function handoverTramsMintage(address newOwner) public onlyOwner {
1479         trams.transferOwnership(newOwner);
1480     }
1481 
1482     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1483     function migrate(uint256 _pid) public {
1484         require(address(migrator) != address(0), "migrate: no migrator");
1485         PoolInfo storage pool = poolInfo[_pid];
1486         IERC20 lpToken = pool.lpToken;
1487         uint256 bal = lpToken.balanceOf(address(this));
1488         lpToken.safeApprove(address(migrator), bal);
1489         IERC20 newLpToken = migrator.migrate(lpToken);
1490         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1491         pool.lpToken = newLpToken;
1492     }
1493 
1494     // Return reward multiplier over the given _from to _to block.
1495     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1496         uint256 _toFinal = _to > mintEndBlock ? mintEndBlock : _to;
1497         if (_toFinal <= betaTestEndBlock) {
1498              return _toFinal.sub(_from);
1499         }else if (_from >= mintEndBlock) {
1500             return 0;
1501         } else if (_toFinal <= bonusEndBlock) {
1502             if (_from < betaTestEndBlock) {
1503                 return betaTestEndBlock.sub(_from).add(_toFinal.sub(betaTestEndBlock).mul(BONUSONE_MULTIPLIER));
1504             } else {
1505                 return _toFinal.sub(_from).mul(BONUSONE_MULTIPLIER);
1506             }
1507         } else {
1508             if (_from < betaTestEndBlock) {
1509                 return betaTestEndBlock.sub(_from).add(bonusEndBlock.sub(betaTestEndBlock).mul(BONUSONE_MULTIPLIER)).add(
1510                     (_toFinal.sub(bonusEndBlock).mul(BONUSTWO_MULTIPLIER)));
1511             } else if (betaTestEndBlock <= _from && _from < bonusEndBlock) {
1512                 return bonusEndBlock.sub(_from).mul(BONUSONE_MULTIPLIER).add(_toFinal.sub(bonusEndBlock).mul(BONUSTWO_MULTIPLIER));
1513             } else {
1514                 return _toFinal.sub(_from).mul(BONUSTWO_MULTIPLIER);
1515             }
1516         } 
1517     }
1518 
1519     // View function to see pending TRAMS on frontend.
1520     function pendingTrams(uint256 _pid, address _user) external view returns (uint256) {
1521         PoolInfo storage pool = poolInfo[_pid];
1522         UserInfo storage user = userInfo[_pid][_user];
1523         uint256 accTramsPerShare = pool.accTramsPerShare;
1524         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1525         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1526             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1527             uint256 tramsReward = multiplier.mul(tramsPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1528             accTramsPerShare = accTramsPerShare.add(tramsReward.mul(1e12).div(lpSupply));
1529         }
1530         return user.amount.mul(accTramsPerShare).div(1e12).sub(user.rewardDebt);
1531     }
1532 
1533     // Update reward vairables for all pools. Be careful of gas spending!
1534     function massUpdatePools() public {
1535         uint256 length = poolInfo.length;
1536         for (uint256 pid = 0; pid < length; ++pid) {
1537             updatePool(pid);
1538         }
1539     }
1540 
1541     // Update reward variables of the given pool to be up-to-date.
1542     function updatePool(uint256 _pid) public {
1543         PoolInfo storage pool = poolInfo[_pid];
1544         if (block.number <= pool.lastRewardBlock) {
1545             return;
1546         }
1547         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1548         if (lpSupply == 0) {
1549             pool.lastRewardBlock = block.number;
1550             return;
1551         }
1552         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1553         if (multiplier == 0) {
1554             pool.lastRewardBlock = block.number;
1555             return;
1556         }
1557         uint256 tramsReward = multiplier.mul(tramsPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1558         trams.mint(devaddr, tramsReward.div(10));
1559         trams.mint(address(this), tramsReward);
1560         pool.accTramsPerShare = pool.accTramsPerShare.add(tramsReward.mul(1e12).div(lpSupply));
1561         pool.lastRewardBlock = block.number;
1562     }
1563 
1564     // Deposit LP tokens to TramsMaster for TRAMS allocation.
1565     function deposit(uint256 _pid, uint256 _amount) public {
1566         PoolInfo storage pool = poolInfo[_pid];
1567         UserInfo storage user = userInfo[_pid][msg.sender];
1568         updatePool(_pid);
1569         uint256 pending = user.amount.mul(pool.accTramsPerShare).div(1e12).sub(user.rewardDebt);
1570         user.amount = user.amount.add(_amount);
1571         user.rewardDebt = user.amount.mul(pool.accTramsPerShare).div(1e12);
1572         if (pending > 0) safeTramsTransfer(msg.sender, pending);
1573         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1574         emit Deposit(msg.sender, _pid, _amount);
1575     }
1576 
1577     // Withdraw LP tokens from TramsMaster.
1578     function withdraw(uint256 _pid, uint256 _amount) public {
1579         PoolInfo storage pool = poolInfo[_pid];
1580         UserInfo storage user = userInfo[_pid][msg.sender];
1581         require(user.amount >= _amount, "withdraw: not good");
1582         updatePool(_pid);
1583         uint256 pending = user.amount.mul(pool.accTramsPerShare).div(1e12).sub(user.rewardDebt);
1584         user.amount = user.amount.sub(_amount);
1585         user.rewardDebt = user.amount.mul(pool.accTramsPerShare).div(1e12);
1586         safeTramsTransfer(msg.sender, pending);
1587         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1588         emit Withdraw(msg.sender, _pid, _amount);
1589     }
1590 
1591     // Withdraw without caring about rewards. EMERGENCY ONLY.
1592     function emergencyWithdraw(uint256 _pid) public {
1593         PoolInfo storage pool = poolInfo[_pid];
1594         UserInfo storage user = userInfo[_pid][msg.sender];
1595         require(user.amount > 0, "emergencyWithdraw: not good");
1596         uint256 _amount = user.amount;
1597         user.amount = 0;
1598         user.rewardDebt = 0;
1599         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1600         emit EmergencyWithdraw(msg.sender, _pid, _amount);
1601     }
1602 
1603     // Safe trams transfer function, just in case if rounding error causes pool to not have enough TRAMS.
1604     function safeTramsTransfer(address _to, uint256 _amount) internal {
1605         uint256 tramsBal = trams.balanceOf(address(this));
1606         if (_amount > tramsBal) {
1607             trams.transfer(_to, tramsBal);
1608         } else {
1609             trams.transfer(_to, _amount);
1610         }
1611     }
1612 
1613     // Update dev address by the previous dev.
1614     function dev(address _devaddr) public {
1615         require(msg.sender == devaddr, "dev: wut?");
1616         devaddr = _devaddr;
1617     }
1618 }