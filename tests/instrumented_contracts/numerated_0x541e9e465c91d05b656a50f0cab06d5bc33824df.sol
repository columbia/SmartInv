1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
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
807 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
808 
809 
810 
811 pragma solidity ^0.6.0;
812 
813 
814 
815 
816 
817 /**
818  * @dev Implementation of the {IERC20} interface.
819  *
820  * This implementation is agnostic to the way tokens are created. This means
821  * that a supply mechanism has to be added in a derived contract using {_mint}.
822  * For a generic mechanism see {ERC20PresetMinterPauser}.
823  *
824  * TIP: For a detailed writeup see our guide
825  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
826  * to implement supply mechanisms].
827  *
828  * We have followed general OpenZeppelin guidelines: functions revert instead
829  * of returning `false` on failure. This behavior is nonetheless conventional
830  * and does not conflict with the expectations of ERC20 applications.
831  *
832  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
833  * This allows applications to reconstruct the allowance for all accounts just
834  * by listening to said events. Other implementations of the EIP may not emit
835  * these events, as it isn't required by the specification.
836  *
837  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
838  * functions have been added to mitigate the well-known issues around setting
839  * allowances. See {IERC20-approve}.
840  */
841 contract ERC20 is Context, IERC20 {
842     using SafeMath for uint256;
843     using Address for address;
844 
845     mapping (address => uint256) private _balances;
846 
847     mapping (address => mapping (address => uint256)) private _allowances;
848 
849     uint256 private _totalSupply;
850 
851     string private _name;
852     string private _symbol;
853     uint8 private _decimals;
854 
855     /**
856      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
857      * a default value of 18.
858      *
859      * To select a different value for {decimals}, use {_setupDecimals}.
860      *
861      * All three of these values are immutable: they can only be set once during
862      * construction.
863      */
864     constructor (string memory name, string memory symbol) public {
865         _name = name;
866         _symbol = symbol;
867         _decimals = 18;
868     }
869 
870     /**
871      * @dev Returns the name of the token.
872      */
873     function name() public view returns (string memory) {
874         return _name;
875     }
876 
877     /**
878      * @dev Returns the symbol of the token, usually a shorter version of the
879      * name.
880      */
881     function symbol() public view returns (string memory) {
882         return _symbol;
883     }
884 
885     /**
886      * @dev Returns the number of decimals used to get its user representation.
887      * For example, if `decimals` equals `2`, a balance of `505` tokens should
888      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
889      *
890      * Tokens usually opt for a value of 18, imitating the relationship between
891      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
892      * called.
893      *
894      * NOTE: This information is only used for _display_ purposes: it in
895      * no way affects any of the arithmetic of the contract, including
896      * {IERC20-balanceOf} and {IERC20-transfer}.
897      */
898     function decimals() public view returns (uint8) {
899         return _decimals;
900     }
901 
902     /**
903      * @dev See {IERC20-totalSupply}.
904      */
905     function totalSupply() public view override returns (uint256) {
906         return _totalSupply;
907     }
908 
909     /**
910      * @dev See {IERC20-balanceOf}.
911      */
912     function balanceOf(address account) public view override returns (uint256) {
913         return _balances[account];
914     }
915 
916     /**
917      * @dev See {IERC20-transfer}.
918      *
919      * Requirements:
920      *
921      * - `recipient` cannot be the zero address.
922      * - the caller must have a balance of at least `amount`.
923      */
924     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
925         _transfer(_msgSender(), recipient, amount);
926         return true;
927     }
928 
929     /**
930      * @dev See {IERC20-allowance}.
931      */
932     function allowance(address owner, address spender) public view virtual override returns (uint256) {
933         return _allowances[owner][spender];
934     }
935 
936     /**
937      * @dev See {IERC20-approve}.
938      *
939      * Requirements:
940      *
941      * - `spender` cannot be the zero address.
942      */
943     function approve(address spender, uint256 amount) public virtual override returns (bool) {
944         _approve(_msgSender(), spender, amount);
945         return true;
946     }
947 
948     /**
949      * @dev See {IERC20-transferFrom}.
950      *
951      * Emits an {Approval} event indicating the updated allowance. This is not
952      * required by the EIP. See the note at the beginning of {ERC20};
953      *
954      * Requirements:
955      * - `sender` and `recipient` cannot be the zero address.
956      * - `sender` must have a balance of at least `amount`.
957      * - the caller must have allowance for ``sender``'s tokens of at least
958      * `amount`.
959      */
960     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
961         _transfer(sender, recipient, amount);
962         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
963         return true;
964     }
965 
966     /**
967      * @dev Atomically increases the allowance granted to `spender` by the caller.
968      *
969      * This is an alternative to {approve} that can be used as a mitigation for
970      * problems described in {IERC20-approve}.
971      *
972      * Emits an {Approval} event indicating the updated allowance.
973      *
974      * Requirements:
975      *
976      * - `spender` cannot be the zero address.
977      */
978     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
979         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
980         return true;
981     }
982 
983     /**
984      * @dev Atomically decreases the allowance granted to `spender` by the caller.
985      *
986      * This is an alternative to {approve} that can be used as a mitigation for
987      * problems described in {IERC20-approve}.
988      *
989      * Emits an {Approval} event indicating the updated allowance.
990      *
991      * Requirements:
992      *
993      * - `spender` cannot be the zero address.
994      * - `spender` must have allowance for the caller of at least
995      * `subtractedValue`.
996      */
997     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
998         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
999         return true;
1000     }
1001 
1002     /**
1003      * @dev Moves tokens `amount` from `sender` to `recipient`.
1004      *
1005      * This is internal function is equivalent to {transfer}, and can be used to
1006      * e.g. implement automatic token fees, slashing mechanisms, etc.
1007      *
1008      * Emits a {Transfer} event.
1009      *
1010      * Requirements:
1011      *
1012      * - `sender` cannot be the zero address.
1013      * - `recipient` cannot be the zero address.
1014      * - `sender` must have a balance of at least `amount`.
1015      */
1016     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1017         require(sender != address(0), "ERC20: transfer from the zero address");
1018         require(recipient != address(0), "ERC20: transfer to the zero address");
1019 
1020         _beforeTokenTransfer(sender, recipient, amount);
1021 
1022         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1023         _balances[recipient] = _balances[recipient].add(amount);
1024         emit Transfer(sender, recipient, amount);
1025     }
1026 
1027     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1028      * the total supply.
1029      *
1030      * Emits a {Transfer} event with `from` set to the zero address.
1031      *
1032      * Requirements
1033      *
1034      * - `to` cannot be the zero address.
1035      */
1036     function _mint(address account, uint256 amount) internal virtual {
1037         require(account != address(0), "ERC20: mint to the zero address");
1038 
1039         _beforeTokenTransfer(address(0), account, amount);
1040 
1041         _totalSupply = _totalSupply.add(amount);
1042         _balances[account] = _balances[account].add(amount);
1043         emit Transfer(address(0), account, amount);
1044     }
1045 
1046     /**
1047      * @dev Destroys `amount` tokens from `account`, reducing the
1048      * total supply.
1049      *
1050      * Emits a {Transfer} event with `to` set to the zero address.
1051      *
1052      * Requirements
1053      *
1054      * - `account` cannot be the zero address.
1055      * - `account` must have at least `amount` tokens.
1056      */
1057     function _burn(address account, uint256 amount) internal virtual {
1058         require(account != address(0), "ERC20: burn from the zero address");
1059 
1060         _beforeTokenTransfer(account, address(0), amount);
1061 
1062         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1063         _totalSupply = _totalSupply.sub(amount);
1064         emit Transfer(account, address(0), amount);
1065     }
1066 
1067     /**
1068      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1069      *
1070      * This internal function is equivalent to `approve`, and can be used to
1071      * e.g. set automatic allowances for certain subsystems, etc.
1072      *
1073      * Emits an {Approval} event.
1074      *
1075      * Requirements:
1076      *
1077      * - `owner` cannot be the zero address.
1078      * - `spender` cannot be the zero address.
1079      */
1080     function _approve(address owner, address spender, uint256 amount) internal virtual {
1081         require(owner != address(0), "ERC20: approve from the zero address");
1082         require(spender != address(0), "ERC20: approve to the zero address");
1083 
1084         _allowances[owner][spender] = amount;
1085         emit Approval(owner, spender, amount);
1086     }
1087 
1088     /**
1089      * @dev Sets {decimals} to a value other than the default one of 18.
1090      *
1091      * WARNING: This function should only be called from the constructor. Most
1092      * applications that interact with token contracts will not expect
1093      * {decimals} to ever change, and may work incorrectly if it does.
1094      */
1095     function _setupDecimals(uint8 decimals_) internal {
1096         _decimals = decimals_;
1097     }
1098 
1099     /**
1100      * @dev Hook that is called before any transfer of tokens. This includes
1101      * minting and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1106      * will be to transferred to `to`.
1107      * - when `from` is zero, `amount` tokens will be minted for `to`.
1108      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1109      * - `from` and `to` are never both zero.
1110      *
1111      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1112      */
1113     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1114 }
1115 
1116 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1117 
1118 
1119 
1120 pragma solidity ^0.6.0;
1121 
1122 
1123 
1124 /**
1125  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1126  * tokens and those that they have an allowance for, in a way that can be
1127  * recognized off-chain (via event analysis).
1128  */
1129 abstract contract ERC20Burnable is Context, ERC20 {
1130     /**
1131      * @dev Destroys `amount` tokens from the caller.
1132      *
1133      * See {ERC20-_burn}.
1134      */
1135     function burn(uint256 amount) public virtual {
1136         _burn(_msgSender(), amount);
1137     }
1138 
1139     /**
1140      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1141      * allowance.
1142      *
1143      * See {ERC20-_burn} and {ERC20-allowance}.
1144      *
1145      * Requirements:
1146      *
1147      * - the caller must have allowance for ``accounts``'s tokens of at least
1148      * `amount`.
1149      */
1150     function burnFrom(address account, uint256 amount) public virtual {
1151         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1152 
1153         _approve(account, _msgSender(), decreasedAllowance);
1154         _burn(account, amount);
1155     }
1156 }
1157 
1158 // File: @openzeppelin/contracts/math/Math.sol
1159 
1160 
1161 
1162 pragma solidity ^0.6.0;
1163 
1164 /**
1165  * @dev Standard math utilities missing in the Solidity language.
1166  */
1167 library Math {
1168     /**
1169      * @dev Returns the largest of two numbers.
1170      */
1171     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1172         return a >= b ? a : b;
1173     }
1174 
1175     /**
1176      * @dev Returns the smallest of two numbers.
1177      */
1178     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1179         return a < b ? a : b;
1180     }
1181 
1182     /**
1183      * @dev Returns the average of two numbers. The result is rounded towards
1184      * zero.
1185      */
1186     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1187         // (a + b) / 2 can overflow, so we distribute
1188         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1189     }
1190 }
1191 
1192 // File: contracts/HulkToken.sol
1193 
1194 
1195 
1196 pragma solidity 0.6.12;
1197 
1198 
1199 
1200 
1201 
1202 
1203 
1204 
1205 // HulkToken with Governance.
1206 contract HulkToken is ERC20Burnable, Ownable {
1207 	uint256 public startBlock;
1208 	uint256 public bonusPool = 0 ether;
1209 	uint256 public bigBonusPool = 0 ether;
1210 	uint256 public burnPool = 0 ether;
1211 	uint256 public minSupply = 0 ether;
1212 	// maximum supply to be minted by farming contract
1213 	uint256 public constant maxSupply = 100 ether;
1214 	uint256 public burnRate = 0;
1215 	uint256 public bonusRate = 0;
1216 	uint256 public bigBurnRate = 0;
1217 	uint256 public bigBonusRate = 0;
1218 	uint256 public bigBurnStartBlock = 0;
1219 	uint256 public bigBurnBlocks = 0;
1220 
1221 	mapping(address => uint256) public burnSenderWhitelist;
1222 	mapping(address => uint256) public burnReceiverWhitelist;
1223 
1224 	bool public burnOn = false;
1225 	bool public bonusOn = false;
1226 	bool public bigBurnOn = false;
1227 	bool public bigBonusOn = false;
1228 
1229 	/// @notice Creates `_amount` token to `_to`. Must only be called by the owner (Hulkfarmer).
1230 	function mint(address _to, uint256 _amount) public onlyOwner {
1231 		require(this.totalSupply().add(_amount) <= maxSupply);
1232 		_mint(_to, _amount);
1233 		_moveDelegates(address(0), _delegates[_to], _amount);
1234 	}
1235 
1236 	// Copied and modified from YAM code:
1237 	// https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1238 	// https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1239 	// Which is copied and modified from COMPOUND:
1240 	// https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1241 
1242 	/// @dev A record of each accounts delegate
1243 	mapping(address => address) internal _delegates;
1244 
1245 	/// @notice A checkpoint for marking number of votes from a given block
1246 	struct Checkpoint {
1247 		uint32 fromBlock;
1248 		uint256 votes;
1249 	}
1250 
1251 	/// @notice A record of votes checkpoints for each account, by index
1252 	mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1253 
1254 	/// @notice The number of checkpoints for each account
1255 	mapping(address => uint32) public numCheckpoints;
1256 
1257 	/// @notice The EIP-712 typehash for the contract's domain
1258 	bytes32 public constant DOMAIN_TYPEHASH = keccak256(
1259 		'EIP712Domain(string name,uint256 chainId,address verifyingContract)'
1260 	);
1261 
1262 	/// @notice The EIP-712 typehash for the delegation struct used by the contract
1263 	bytes32 public constant DELEGATION_TYPEHASH = keccak256(
1264 		'Delegation(address delegatee,uint256 nonce,uint256 expiry)'
1265 	);
1266 
1267 	/// @notice A record of states for signing / validating signatures
1268 	mapping(address => uint256) public nonces;
1269 
1270 	/// @notice An event thats emitted when an account changes its delegate
1271 	event DelegateChanged(
1272 		address indexed delegator,
1273 		address indexed fromDelegate,
1274 		address indexed toDelegate
1275 	);
1276 
1277 	/// @notice An event thats emitted when a delegate account's vote balance changes
1278 	event DelegateVotesChanged(
1279 		address indexed delegate,
1280 		uint256 previousBalance,
1281 		uint256 newBalance
1282 	);
1283 
1284 	constructor() public ERC20('HULK.finance', 'HULK') {}
1285 
1286 	/**
1287 	 * @notice Delegate votes from `msg.sender` to `delegatee`
1288 	 * @param delegator The address to get delegatee for
1289 	 */
1290 	function delegates(address delegator) external view returns (address) {
1291 		return _delegates[delegator];
1292 	}
1293 
1294 	/**
1295 	 * @notice Delegate votes from `msg.sender` to `delegatee`
1296 	 * @param delegatee The address to delegate votes to
1297 	 */
1298 	function delegate(address delegatee) external {
1299 		return _delegate(msg.sender, delegatee);
1300 	}
1301 
1302 	/**
1303 	 * @notice Delegates votes from signatory to `delegatee`
1304 	 * @param delegatee The address to delegate votes to
1305 	 * @param nonce The contract state required to match the signature
1306 	 * @param expiry The time at which to expire the signature
1307 	 * @param v The recovery byte of the signature
1308 	 * @param r Half of the ECDSA signature pair
1309 	 * @param s Half of the ECDSA signature pair
1310 	 */
1311 	function delegateBySig(
1312 		address delegatee,
1313 		uint256 nonce,
1314 		uint256 expiry,
1315 		uint8 v,
1316 		bytes32 r,
1317 		bytes32 s
1318 	) external {
1319 		bytes32 domainSeparator = keccak256(
1320 			abi.encode(
1321 				DOMAIN_TYPEHASH,
1322 				keccak256(bytes(name())),
1323 				getChainId(),
1324 				address(this)
1325 			)
1326 		);
1327 
1328 		bytes32 structHash = keccak256(
1329 			abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
1330 		);
1331 
1332 		bytes32 digest = keccak256(
1333 			abi.encodePacked('\x19\x01', domainSeparator, structHash)
1334 		);
1335 
1336 		address signatory = ecrecover(digest, v, r, s);
1337 		require(signatory != address(0), 'HULK::delegateBySig: invalid signature');
1338 		require(nonce == nonces[signatory]++, 'HULK::delegateBySig: invalid nonce');
1339 		require(now <= expiry, 'HULK::delegateBySig: signature expired');
1340 		return _delegate(signatory, delegatee);
1341 	}
1342 
1343 	/**
1344 	 * @notice Gets the current votes balance for `account`
1345 	 * @param account The address to get votes balance
1346 	 * @return The number of current votes for `account`
1347 	 */
1348 	function getCurrentVotes(address account) external view returns (uint256) {
1349 		uint32 nCheckpoints = numCheckpoints[account];
1350 		return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1351 	}
1352 
1353 	/**
1354 	 * @notice Determine the prior number of votes for an account as of a block number
1355 	 * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1356 	 * @param account The address of the account to check
1357 	 * @param blockNumber The block number to get the vote balance at
1358 	 * @return The number of votes the account had as of the given block
1359 	 */
1360 	function getPriorVotes(address account, uint256 blockNumber)
1361 		external
1362 		view
1363 		returns (uint256)
1364 	{
1365 		require(
1366 			blockNumber < block.number,
1367 			'HULK::getPriorVotes: not yet determined'
1368 		);
1369 
1370 		uint32 nCheckpoints = numCheckpoints[account];
1371 		if (nCheckpoints == 0) {
1372 			return 0;
1373 		}
1374 
1375 		// First check most recent balance
1376 		if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1377 			return checkpoints[account][nCheckpoints - 1].votes;
1378 		}
1379 
1380 		// Next check implicit zero balance
1381 		if (checkpoints[account][0].fromBlock > blockNumber) {
1382 			return 0;
1383 		}
1384 
1385 		uint32 lower = 0;
1386 		uint32 upper = nCheckpoints - 1;
1387 		while (upper > lower) {
1388 			uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1389 			Checkpoint memory cp = checkpoints[account][center];
1390 			if (cp.fromBlock == blockNumber) {
1391 				return cp.votes;
1392 			} else if (cp.fromBlock < blockNumber) {
1393 				lower = center;
1394 			} else {
1395 				upper = center - 1;
1396 			}
1397 		}
1398 		return checkpoints[account][lower].votes;
1399 	}
1400 
1401 	function _delegate(address delegator, address delegatee) internal {
1402 		address currentDelegate = _delegates[delegator];
1403 		uint256 delegatorBalance = balanceOf(delegator); // balance of underlying HULKs (not scaled);
1404 		_delegates[delegator] = delegatee;
1405 
1406 		emit DelegateChanged(delegator, currentDelegate, delegatee);
1407 
1408 		_moveDelegates(currentDelegate, delegatee, delegatorBalance);
1409 	}
1410 
1411 	function _moveDelegates(
1412 		address srcRep,
1413 		address dstRep,
1414 		uint256 amount
1415 	) internal {
1416 		if (srcRep != dstRep && amount > 0) {
1417 			if (srcRep != address(0)) {
1418 				// decrease old representative
1419 				uint32 srcRepNum = numCheckpoints[srcRep];
1420 				uint256 srcRepOld = srcRepNum > 0
1421 					? checkpoints[srcRep][srcRepNum - 1].votes
1422 					: 0;
1423 				uint256 srcRepNew = srcRepOld.sub(amount);
1424 				_writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1425 			}
1426 
1427 			if (dstRep != address(0)) {
1428 				// increase new representative
1429 				uint32 dstRepNum = numCheckpoints[dstRep];
1430 				uint256 dstRepOld = dstRepNum > 0
1431 					? checkpoints[dstRep][dstRepNum - 1].votes
1432 					: 0;
1433 				uint256 dstRepNew = dstRepOld.add(amount);
1434 				_writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1435 			}
1436 		}
1437 	}
1438 
1439 	function _writeCheckpoint(
1440 		address delegatee,
1441 		uint32 nCheckpoints,
1442 		uint256 oldVotes,
1443 		uint256 newVotes
1444 	) internal {
1445 		uint32 blockNumber = safe32(
1446 			block.number,
1447 			'HULK::_writeCheckpoint: block number exceeds 32 bits'
1448 		);
1449 
1450 		if (
1451 			nCheckpoints > 0 &&
1452 			checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
1453 		) {
1454 			checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1455 		} else {
1456 			checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1457 			numCheckpoints[delegatee] = nCheckpoints + 1;
1458 		}
1459 
1460 		emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1461 	}
1462 
1463 	function safe32(uint256 n, string memory errorMessage)
1464 		internal
1465 		pure
1466 		returns (uint32)
1467 	{
1468 		require(n < 2**32, errorMessage);
1469 		return uint32(n);
1470 	}
1471 
1472 	function getChainId() internal pure returns (uint256) {
1473 		uint256 chainId;
1474 		assembly {
1475 			chainId := chainid()
1476 		}
1477 		return chainId;
1478 	}
1479 
1480 	function calcRate(
1481 		address sender,
1482 		address recipient,
1483 		uint256 amount
1484 	)
1485 		public
1486 		view
1487 		returns (
1488 			uint256,
1489 			uint256,
1490 			uint256
1491 		)
1492 	{
1493 		if (
1494 			burnReceiverWhitelist[recipient] == 1 ||
1495 			burnSenderWhitelist[recipient] == 1 ||
1496 			sender == this.owner() ||
1497 			recipient == this.owner()
1498 		) {
1499 			return (0, 0, amount);
1500 		}
1501 		if (burnOn == false && bigBurnOn == false) {
1502 			return (0, 0, amount);
1503 		}
1504 		if (this.totalSupply() <= minSupply) {
1505 			return (0, 0, amount);
1506 		}
1507 		uint256 burnAmount = 0;
1508 		uint256 bonusAmount = 0;
1509 		if (
1510 			bigBurnOn == true && (block.number).sub(bigBurnStartBlock) < bigBurnBlocks
1511 		) {
1512 			burnAmount = amount.mul(bigBurnRate).div(10000);
1513 			bonusAmount = amount.mul(bigBonusRate).div(10000);
1514 		} else if (burnOn == true) {
1515 			burnAmount = amount.mul(burnRate).div(10000);
1516 			bonusAmount = amount.mul(bonusRate).div(10000);
1517 		}
1518 		if (this.totalSupply().sub(burnAmount).sub(bonusAmount) < minSupply) {
1519 			burnAmount = 0;
1520 			bonusAmount = -(minSupply.sub(this.totalSupply()));
1521 		}
1522 
1523 		return (burnAmount, bonusAmount, amount.sub(burnAmount).sub(bonusAmount));
1524 	}
1525 
1526 	function sendBonusMany(address[] memory recs, uint256[] memory amounts)
1527 		public
1528 		onlyOwner
1529 		returns (bool)
1530 	{
1531 		require(recs.length == amounts.length);
1532 		uint256 totalAmount;
1533 		for (uint256 x = 0; x < recs.length; x++) {
1534 			require(recs[x] == address(recs[x]), 'Invalid address');
1535 			totalAmount = totalAmount.add(amounts[x]);
1536 		}
1537 		require(totalAmount <= bonusPool);
1538 		for (uint256 i = 0; i < recs.length; i++) {
1539 			require(bonusPool >= amounts[i]);
1540 			bonusPool = bonusPool.sub(amounts[i]);
1541 			_transfer(address(this), recs[i], amounts[i]);
1542 		}
1543 	}
1544 
1545 	function sendBonus(address recipient, uint256 amount)
1546 		public
1547 		onlyOwner
1548 		returns (bool)
1549 	{
1550 		require(recipient == address(recipient), 'Invalid address');
1551 		require(amount <= bonusPool);
1552 		bonusPool = bonusPool.sub(amount);
1553 		_transfer(address(this), recipient, amount);
1554 	}
1555 
1556 	function transferFrom(
1557 		address sender,
1558 		address recipient,
1559 		uint256 amount
1560 	) public override returns (bool) {
1561 		(uint256 burnAmount, uint256 bonusAmount, uint256 amountToSend) = calcRate(
1562 			sender,
1563 			recipient,
1564 			amount
1565 		);
1566 		burnPool = burnPool.add(burnAmount);
1567 		_burn(sender, burnAmount);
1568 		bonusPool = bonusPool.add(bonusAmount);
1569 		super.transferFrom(sender, address(this), bonusAmount);
1570 		super.transferFrom(sender, recipient, amountToSend);
1571 		return true;
1572 	}
1573 
1574 	function transfer(address recipient, uint256 amount)
1575 		public
1576 		override
1577 		returns (bool)
1578 	{
1579 		(uint256 burnAmount, uint256 bonusAmount, uint256 amountToSend) = calcRate(
1580 			_msgSender(),
1581 			recipient,
1582 			amount
1583 		);
1584 		burnPool = burnPool.add(burnAmount);
1585 		_burn(_msgSender(), burnAmount);
1586 		bonusPool = bonusPool.add(bonusAmount);
1587 		_transfer(_msgSender(), address(this), bonusAmount);
1588 		_transfer(_msgSender(), recipient, amountToSend);
1589 		return true;
1590 	}
1591 
1592 	function removeReceiverBurnWhitelist(address toRemove)
1593 		public
1594 		onlyOwner
1595 		returns (bool)
1596 	{
1597 		burnReceiverWhitelist[toRemove] = 0;
1598 		return true;
1599 	}
1600 
1601 	function removeSenderBurnWhitelist(address toRemove)
1602 		public
1603 		onlyOwner
1604 		returns (bool)
1605 	{
1606 		burnSenderWhitelist[toRemove] = 0;
1607 		return true;
1608 	}
1609 
1610 	function addReceiverBurnWhitelist(address toAdd)
1611 		public
1612 		onlyOwner
1613 		returns (bool)
1614 	{
1615 		burnReceiverWhitelist[toAdd] = 1;
1616 		return true;
1617 	}
1618 
1619 	function addSenderBurnWhitelist(address toAdd)
1620 		public
1621 		onlyOwner
1622 		returns (bool)
1623 	{
1624 		burnSenderWhitelist[toAdd] = 1;
1625 		return true;
1626 	}
1627 
1628 	function bigBurnStart(
1629 		uint256 newBigBurnBlocks,
1630 		uint256 newBigBurnRate,
1631 		uint256 newBigBonusRate
1632 	) public onlyOwner returns (bool) {
1633 		bigBurnStartBlock = block.number;
1634 		bigBurnBlocks = newBigBurnBlocks;
1635 		bigBurnRate = newBigBurnRate;
1636 		bigBonusRate = newBigBonusRate;
1637 		return true;
1638 	}
1639 
1640 	function bigBurnStop() public onlyOwner returns (bool) {
1641 		bigBurnOn = false;
1642 		bigBurnBlocks = 0;
1643 		return true;
1644 	}
1645 
1646 	function burnStart(uint256 newBurnRate, uint256 newBonusRate)
1647 		public
1648 		onlyOwner
1649 		returns (bool)
1650 	{
1651 		burnOn = true;
1652 		burnRate = newBurnRate;
1653 		bonusRate = newBonusRate;
1654 		return true;
1655 	}
1656 
1657 	function burnStop() public onlyOwner returns (bool) {
1658 		burnOn = false;
1659 		return true;
1660 	}
1661 }
1662 
1663 // File: contracts/Hulkfarmer.sol
1664 
1665 
1666 
1667 pragma solidity 0.6.12;
1668 
1669 
1670 
1671 
1672 
1673 
1674 
1675 // Hulkfarmer is the meistress of Token. It can make Token.
1676 //
1677 // Note that it's ownable and the owner wields tremendous power. The ownership
1678 // will be transferred to a governance smart contract once HULK is sufficiently
1679 // distributed and the community can show to govern itself.
1680 //
1681 
1682 contract Hulkfarmer is Ownable {
1683 	using SafeMath for uint256;
1684 	using SafeERC20 for IERC20;
1685 
1686 	// Info of each user.
1687 	struct UserInfo {
1688 		uint256 amount; // How many LP tokens the user has provided.
1689 		uint256 rewardDebt; // Reward debt. See explanation below.
1690 		//
1691 		// We do some fancy math here. Basically, any point in time, the amount of HULKs
1692 		// entitled to a user but is pending to be distributed is:
1693 		//
1694 		//   pending reward = (user.amount * pool.accPerShare) - user.rewardDebt
1695 		//
1696 		// Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1697 		//   1. The pool's `accPerShare` (and `lastRewardBlock`) gets updated.
1698 		//   2. User receives the pending reward sent to his/her address.
1699 		//   3. User's `amount` gets updated.
1700 		//   4. User's `rewardDebt` gets updated.
1701 	}
1702 
1703 	// Info of each pool.
1704 	struct PoolInfo {
1705 		IERC20 lpToken; // Address of LP token contract.
1706 		uint256 allocPoint; // How many allocation points assigned to this pool. HULKs to distribute per block.
1707 		uint256 lastRewardBlock; // Last block number that HULKs distribution occurs.
1708 		uint256 accPerShare; // Accumulated HULKs per share, times 1e12. See below.
1709 	}
1710 
1711 	// The HULK TOKEN!
1712 	HulkToken public token;
1713 	// Dev address.
1714 	address public devaddr;
1715 	// Block number when bonus HULK period ends.
1716 	uint256 public bonusEndBlock;
1717 	// total burned on unstake
1718 	uint256 public totalUnstakeBurn = 0;
1719 	// How many coins to burn when unstaking
1720 	uint256 public unstakeBurnRate = 300;
1721 	// HULK tokens created per block.
1722 	uint256 public tokenPerBlock;
1723 	// farming on/off switch
1724 	bool public farmingOn = false;
1725 	// halving rates array
1726 	uint256[5] halvingRates = [1, 2, 4, 8, 16];
1727 	// Bonus muliplier for early token makers.
1728 	uint256 public BONUS_MULTIPLIER = 0;
1729 	// 12 blocks per second, 86400 seconds per day
1730 	// 86400/12 = 7200 blocks per day
1731 	// 7200 * 5 = 36000 blocks per 5 days ('week')
1732 	uint256 public halvingPeriod = 7200;
1733 	// Info of each pool.
1734 	PoolInfo[] public poolInfo;
1735 	// Info of each user that stakes LP tokens.
1736 	mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1737 	// Total allocation poitns. Must be the sum of all allocation points in all pools.
1738 	uint256 public totalAllocPoint = 0;
1739 	// The block number when HULK mining starts.
1740 	uint256 public farmingStartBlock;
1741 	uint256 public farmingEndBlock;
1742 
1743 	event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1744 	event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1745 	event EmergencyWithdraw(
1746 		address indexed user,
1747 		uint256 indexed pid,
1748 		uint256 amount
1749 	);
1750 
1751 	constructor(HulkToken _token, address _devaddr) public {
1752 		token = _token;
1753 		devaddr = _devaddr;
1754 	}
1755 
1756 	function poolLength() external view returns (uint256) {
1757 		return poolInfo.length;
1758 	}
1759 
1760 	function getFarmingStartBlock() external view returns (uint256) {
1761 		return farmingStartBlock;
1762 	}
1763 
1764 	function getFarmingEndBlock() external view returns (uint256) {
1765 		return farmingEndBlock;
1766 	}
1767 
1768 	function getBonusEndBlock() external view returns (uint256) {
1769 		return bonusEndBlock;
1770 	}
1771 
1772 	function startFarming(
1773 		uint256 _farmingTotalBlocks,
1774 		uint256 _farmingBonusBlocks,
1775 		uint256 _halvingPeriod,
1776 		uint256 _tokenPerBlock,
1777 		uint256[5] memory _halvingRates,
1778 		uint256 _BONUS_MULTIPLIER
1779 	) public onlyOwner returns (bool) {
1780 		farmingOn = true;
1781 		farmingStartBlock = block.number;
1782 		farmingEndBlock = block.number + _farmingTotalBlocks;
1783 		bonusEndBlock = block.number + _farmingBonusBlocks;
1784 		halvingPeriod = _halvingPeriod;
1785 		tokenPerBlock = _tokenPerBlock;
1786 		halvingRates = _halvingRates;
1787 		BONUS_MULTIPLIER = _BONUS_MULTIPLIER;
1788 		return true;
1789 	}
1790 
1791 	function stopFarming() public onlyOwner returns (bool) {
1792 		farmingOn = false;
1793 		farmingStartBlock = 0;
1794 		farmingEndBlock = 0;
1795 		bonusEndBlock = 0;
1796 		halvingPeriod = 0;
1797 		tokenPerBlock = 0;
1798 		BONUS_MULTIPLIER = 0;
1799 	}
1800 
1801 	function removeReceiverBurnWhitelist(address toRemove)
1802 		public
1803 		onlyOwner
1804 		returns (bool)
1805 	{
1806 		token.removeReceiverBurnWhitelist(toRemove);
1807 		return true;
1808 	}
1809 
1810 	function removeSenderBurnWhitelist(address toRemove)
1811 		public
1812 		onlyOwner
1813 		returns (bool)
1814 	{
1815 		token.removeSenderBurnWhitelist(toRemove);
1816 		return true;
1817 	}
1818 
1819 	function addReceiverBurnWhitelist(address toAdd)
1820 		public
1821 		onlyOwner
1822 		returns (bool)
1823 	{
1824 		token.addReceiverBurnWhitelist(toAdd);
1825 		return true;
1826 	}
1827 
1828 	function addSenderBurnWhitelist(address toAdd)
1829 		public
1830 		onlyOwner
1831 		returns (bool)
1832 	{
1833 		token.addSenderBurnWhitelist(toAdd);
1834 		return true;
1835 	}
1836 
1837 	function bigBurnStart(
1838 		uint256 newBigBurnBlocks,
1839 		uint256 newBigBurnRate,
1840 		uint256 newBigBonusRate
1841 	) public onlyOwner returns (bool) {
1842 		token.bigBurnStart(newBigBurnBlocks, newBigBurnRate, newBigBonusRate);
1843 		return true;
1844 	}
1845 
1846 	function bigBurnStop() public onlyOwner returns (bool) {
1847 		token.bigBurnStop();
1848 		return true;
1849 	}
1850 
1851 	function burnStart(uint256 newBurnRate, uint256 newBonusRate)
1852 		public
1853 		onlyOwner
1854 		returns (bool)
1855 	{
1856 		token.burnStart(newBurnRate, newBonusRate);
1857 		return true;
1858 	}
1859 
1860 	function burnStop() public onlyOwner returns (bool) {
1861 		token.burnStop();
1862 		return true;
1863 	}
1864 
1865 	// Add a new lp to the pool. Can only be called by the owner.
1866 	// XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1867 	function add(
1868 		uint256 _allocPoint,
1869 		IERC20 _lpToken,
1870 		bool _withUpdate
1871 	) public onlyOwner {
1872 		if (_withUpdate) {
1873 			massUpdatePools();
1874 		}
1875 		uint256 lastRewardBlock = block.number;
1876 		// uint256 lastRewardBlock = block.number > farmingStartBlock
1877 		// 	? block.number
1878 		// 	: farmingStartBlock;
1879 		totalAllocPoint = totalAllocPoint.add(_allocPoint);
1880 		poolInfo.push(
1881 			PoolInfo({
1882 				lpToken: _lpToken,
1883 				allocPoint: _allocPoint,
1884 				lastRewardBlock: lastRewardBlock,
1885 				accPerShare: 0
1886 			})
1887 		);
1888 	}
1889 
1890 	// Update the given pool's HULK allocation point. Can only be called by the owner.
1891 	function set(
1892 		uint256 _pid,
1893 		uint256 _allocPoint,
1894 		bool _withUpdate
1895 	) public onlyOwner {
1896 		if (_withUpdate) {
1897 			massUpdatePools();
1898 		}
1899 		totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1900 			_allocPoint
1901 		);
1902 		poolInfo[_pid].allocPoint = _allocPoint;
1903 	}
1904 
1905 	// Return reward multiplier over the given _from to _to block.
1906 	function getMultiplier(uint256 _from, uint256 _to)
1907 		public
1908 		view
1909 		returns (uint256)
1910 	{
1911 		uint256 tokenReward = 0;
1912 		if (_from < farmingStartBlock || _to > farmingEndBlock) {
1913 			tokenReward = 0;
1914 		} else if (_to <= bonusEndBlock) {
1915 			tokenReward = _to.sub(_from).mul(BONUS_MULTIPLIER);
1916 		} else if (_from >= bonusEndBlock) {
1917 			tokenReward = _to.sub(_from);
1918 		} else {
1919 			tokenReward = bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1920 				_to.sub(bonusEndBlock)
1921 			);
1922 		}
1923 
1924 		// console.log(_from, _to, bonusEndBlock);
1925 		require(tokenReward >= 0, 'reward < 0');
1926 		uint256 diff = (block.number).sub(farmingStartBlock);
1927 		uint256 thisHalvingPeriod;
1928 		if (diff <= halvingPeriod) {
1929 			thisHalvingPeriod = 0;
1930 		} else if (diff <= halvingPeriod.mul(2)) {
1931 			thisHalvingPeriod = 1;
1932 		} else if (diff <= halvingPeriod.mul(3)) {
1933 			thisHalvingPeriod = 2;
1934 		} else if (diff <= halvingPeriod.mul(4)) {
1935 			thisHalvingPeriod = 3;
1936 		} else {
1937 			thisHalvingPeriod = 4;
1938 		}
1939 		uint256 tokenRewardHalved = tokenReward.div(
1940 			halvingRates[thisHalvingPeriod]
1941 		);
1942 		return tokenRewardHalved;
1943 	}
1944 
1945 	// View function to see pending HULKs on frontend.
1946 	function pendingReward(uint256 _pid, address _user)
1947 		external
1948 		view
1949 		returns (uint256)
1950 	{
1951 		PoolInfo storage pool = poolInfo[_pid];
1952 		UserInfo storage user = userInfo[_pid][_user];
1953 		uint256 accPerShare = pool.accPerShare;
1954 		uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1955 		if (farmingOn && block.number > pool.lastRewardBlock && lpSupply != 0) {
1956 			uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1957 			uint256 tokenReward = multiplier
1958 				.mul(tokenPerBlock)
1959 				.mul(pool.allocPoint)
1960 				.div(totalAllocPoint);
1961 			accPerShare = accPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1962 		}
1963 		uint256 pendingRewardAmount = user.amount.mul(accPerShare).div(1e12).sub(
1964 			user.rewardDebt
1965 		);
1966 		return pendingRewardAmount;
1967 	}
1968 
1969 	// Update reward variables for all pools. Be careful of gas spending!
1970 	function massUpdatePools() public {
1971 		uint256 length = poolInfo.length;
1972 		for (uint256 pid = 0; pid < length; ++pid) {
1973 			updatePool(pid);
1974 		}
1975 	}
1976 
1977 	// Update reward variables of the given pool to be up-to-date.
1978 	function updatePool(uint256 _pid) public {
1979 		PoolInfo storage pool = poolInfo[_pid];
1980 		if (block.number <= pool.lastRewardBlock) {
1981 			return;
1982 		}
1983 		uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1984 		if (lpSupply == 0) {
1985 			pool.lastRewardBlock = block.number;
1986 			return;
1987 		}
1988 		uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1989 		uint256 tokenReward = multiplier
1990 			.mul(tokenPerBlock)
1991 			.mul(pool.allocPoint)
1992 			.div(totalAllocPoint);
1993 
1994 		// keeps maxSupply holy
1995 		if (token.totalSupply().add(tokenReward) > token.maxSupply()) {
1996 			farmingOn = false;
1997 			tokenReward = -(
1998 				token.maxSupply().sub(token.totalSupply().add(tokenReward))
1999 			);
2000 		}
2001 
2002 		token.mint(devaddr, tokenReward.div(20));
2003 		token.mint(address(this), tokenReward);
2004 		pool.accPerShare = pool.accPerShare.add(
2005 			tokenReward.mul(1e12).div(lpSupply)
2006 		);
2007 		pool.lastRewardBlock = block.number;
2008 		// for farming < max
2009 		if (block.number >= farmingEndBlock) {
2010 			farmingOn = false;
2011 		}
2012 	}
2013 
2014 	function sendBonusMany(address[] memory recs, uint256[] memory amounts)
2015 		public
2016 		onlyOwner
2017 		returns (bool)
2018 	{
2019 		token.sendBonusMany(recs, amounts);
2020 		return true;
2021 	}
2022 
2023 	function sendBonus(address recipient, uint256 amount)
2024 		public
2025 		onlyOwner
2026 		returns (bool)
2027 	{
2028 		token.sendBonus(recipient, amount);
2029 		return true;
2030 	}
2031 
2032 	// Deposit LP tokens to Hulkfarmer for HULK allocation.
2033 	function deposit(uint256 _pid, uint256 _amount) public {
2034 		PoolInfo storage pool = poolInfo[_pid];
2035 		UserInfo storage user = userInfo[_pid][msg.sender];
2036 		updatePool(_pid);
2037 		// if user has any LP tokens staked, we would send the reward here
2038 		// but NOT ANYMORE
2039 		//
2040 		// if (user.amount > 0) {
2041 		// 	uint256 pending = user.amount.mul(pool.accPerShare).div(1e12).sub(
2042 		// 		user.rewardDebt
2043 		// 	);
2044 		// 	if (pending > 0) {
2045 		// 		safeTokenTransfer(msg.sender, pending);
2046 		// 	}
2047 		// }
2048 		if (_amount > 0) {
2049 			pool.lpToken.safeTransferFrom(
2050 				address(msg.sender),
2051 				address(this),
2052 				_amount
2053 			);
2054 			user.amount = user.amount.add(_amount);
2055 		}
2056 		user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
2057 		emit Deposit(msg.sender, _pid, _amount);
2058 	}
2059 
2060 	function setUnstakeBurnRate(uint256 newRate) public onlyOwner returns (bool) {
2061 		unstakeBurnRate = newRate;
2062 		return true;
2063 	}
2064 
2065 	// Withdraw LP tokens from Hulkfarmer.
2066 	function withdraw(uint256 _pid, uint256 _amount) public {
2067 		PoolInfo storage pool = poolInfo[_pid];
2068 		UserInfo storage user = userInfo[_pid][msg.sender];
2069 		require(user.amount >= _amount, 'withdraw: not good');
2070 		updatePool(_pid);
2071 		uint256 pending = user.amount.mul(pool.accPerShare).div(1e12).sub(
2072 			user.rewardDebt
2073 		);
2074 		uint256 burnPending = 0;
2075 		if (pending > 0) {
2076 			burnPending = pending.mul(unstakeBurnRate).div(10000);
2077 			uint256 sendPending = pending.sub(burnPending);
2078 			if (token.totalSupply().sub(burnPending) < token.minSupply()) {
2079 				burnPending = 0;
2080 				sendPending = pending;
2081 			}
2082 			safeTokenTransfer(msg.sender, sendPending);
2083 			if (burnPending > 0) {
2084 				totalUnstakeBurn = totalUnstakeBurn.add(burnPending);
2085 				token.burn(burnPending);
2086 			}
2087 		}
2088 		if (_amount > 0) {
2089 			user.amount = user.amount.sub(_amount);
2090 			pool.lpToken.safeTransfer(address(msg.sender), _amount);
2091 		}
2092 		user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
2093 		emit Withdraw(msg.sender, _pid, _amount);
2094 	}
2095 
2096 	// Withdraw without caring about rewards. EMERGENCY ONLY.
2097 	function emergencyWithdraw(uint256 _pid) public {
2098 		PoolInfo storage pool = poolInfo[_pid];
2099 		UserInfo storage user = userInfo[_pid][msg.sender];
2100 		pool.lpToken.safeTransfer(address(msg.sender), user.amount);
2101 		emit EmergencyWithdraw(msg.sender, _pid, user.amount);
2102 		user.amount = 0;
2103 		user.rewardDebt = 0;
2104 	}
2105 
2106 	// Safe token transfer function, just in case if rounding error causes pool to not have enough HULKs.
2107 	function safeTokenTransfer(address _to, uint256 _amount) internal {
2108 		uint256 tokenBal = token.balanceOf(address(this));
2109 		if (_amount > tokenBal) {
2110 			token.transfer(_to, tokenBal);
2111 		} else {
2112 			token.transfer(_to, _amount);
2113 		}
2114 	}
2115 
2116 	function giveOwnership(address newOwner) public onlyOwner {
2117 		token.transferOwnership(newOwner);
2118 	}
2119 
2120 	// Update dev address by the previous dev.
2121 	function dev(address _devaddr) public {
2122 		require(msg.sender == devaddr, 'dev: wut?');
2123 		devaddr = _devaddr;
2124 	}
2125 }