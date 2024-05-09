1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 // SPDX-License-Identifier: MIT
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
245 // SPDX-License-Identifier: MIT
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
389 // SPDX-License-Identifier: MIT
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
466 // SPDX-License-Identifier: MIT
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
710 // File: @openzeppelin/contracts/introspection/IERC1820Registry.sol
711 
712 // SPDX-License-Identifier: MIT
713 
714 pragma solidity ^0.6.0;
715 
716 /**
717  * @dev Interface of the global ERC1820 Registry, as defined in the
718  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
719  * implementers for interfaces in this registry, as well as query support.
720  *
721  * Implementers may be shared by multiple accounts, and can also implement more
722  * than a single interface for each account. Contracts can implement interfaces
723  * for themselves, but externally-owned accounts (EOA) must delegate this to a
724  * contract.
725  *
726  * {IERC165} interfaces can also be queried via the registry.
727  *
728  * For an in-depth explanation and source code analysis, see the EIP text.
729  */
730 interface IERC1820Registry {
731     /**
732      * @dev Sets `newManager` as the manager for `account`. A manager of an
733      * account is able to set interface implementers for it.
734      *
735      * By default, each account is its own manager. Passing a value of `0x0` in
736      * `newManager` will reset the manager to this initial state.
737      *
738      * Emits a {ManagerChanged} event.
739      *
740      * Requirements:
741      *
742      * - the caller must be the current manager for `account`.
743      */
744     function setManager(address account, address newManager) external;
745 
746     /**
747      * @dev Returns the manager for `account`.
748      *
749      * See {setManager}.
750      */
751     function getManager(address account) external view returns (address);
752 
753     /**
754      * @dev Sets the `implementer` contract as ``account``'s implementer for
755      * `interfaceHash`.
756      *
757      * `account` being the zero address is an alias for the caller's address.
758      * The zero address can also be used in `implementer` to remove an old one.
759      *
760      * See {interfaceHash} to learn how these are created.
761      *
762      * Emits an {InterfaceImplementerSet} event.
763      *
764      * Requirements:
765      *
766      * - the caller must be the current manager for `account`.
767      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
768      * end in 28 zeroes).
769      * - `implementer` must implement {IERC1820Implementer} and return true when
770      * queried for support, unless `implementer` is the caller. See
771      * {IERC1820Implementer-canImplementInterfaceForAddress}.
772      */
773     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
774 
775     /**
776      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
777      * implementer is registered, returns the zero address.
778      *
779      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
780      * zeroes), `account` will be queried for support of it.
781      *
782      * `account` being the zero address is an alias for the caller's address.
783      */
784     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
785 
786     /**
787      * @dev Returns the interface hash for an `interfaceName`, as defined in the
788      * corresponding
789      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
790      */
791     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
792 
793     /**
794      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
795      *  @param account Address of the contract for which to update the cache.
796      *  @param interfaceId ERC165 interface for which to update the cache.
797      */
798     function updateERC165Cache(address account, bytes4 interfaceId) external;
799 
800     /**
801      *  @notice Checks whether a contract implements an ERC165 interface or not.
802      *  If the result is not cached a direct lookup on the contract address is performed.
803      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
804      *  {updateERC165Cache} with the contract address.
805      *  @param account Address of the contract to check.
806      *  @param interfaceId ERC165 interface to check.
807      *  @return True if `account` implements `interfaceId`, false otherwise.
808      */
809     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
810 
811     /**
812      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
813      *  @param account Address of the contract to check.
814      *  @param interfaceId ERC165 interface to check.
815      *  @return True if `account` implements `interfaceId`, false otherwise.
816      */
817     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
818 
819     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
820 
821     event ManagerChanged(address indexed account, address indexed newManager);
822 }
823 
824 // File: @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol
825 
826 // SPDX-License-Identifier: MIT
827 
828 pragma solidity ^0.6.0;
829 
830 /**
831  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
832  *
833  * Accounts can be notified of {IERC777} tokens being sent to them by having a
834  * contract implement this interface (contract holders can be their own
835  * implementer) and registering it on the
836  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
837  *
838  * See {IERC1820Registry} and {ERC1820Implementer}.
839  */
840 interface IERC777Recipient {
841     /**
842      * @dev Called by an {IERC777} token contract whenever tokens are being
843      * moved or created into a registered account (`to`). The type of operation
844      * is conveyed by `from` being the zero address or not.
845      *
846      * This call occurs _after_ the token contract's state is updated, so
847      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
848      *
849      * This function may revert to prevent the operation from being executed.
850      */
851     function tokensReceived(
852         address operator,
853         address from,
854         address to,
855         uint256 amount,
856         bytes calldata userData,
857         bytes calldata operatorData
858     ) external;
859 }
860 
861 // File: contracts/IWETH.sol
862 
863 pragma solidity ^0.6.0;
864 
865 interface IWETH {
866   function deposit() external payable;
867   function transfer(address to, uint value) external returns (bool);
868   function withdraw(uint) external;
869   function balanceOf(address who) external view returns (uint256);
870   function approve(address spender, uint256 amount) external returns (bool);
871   function allowance(address owner, address spender) external returns (uint256);
872 }
873 
874 // File: contracts/AbstractOwnable.sol
875 
876 pragma solidity ^0.6.0;
877 
878 abstract contract AbstractOwnable {
879 
880   modifier onlyOwner() {
881     require(_owner() == msg.sender, "caller is not the owner");
882     _;
883   }
884 
885   function _owner() internal virtual returns(address);
886 
887 }
888 
889 // File: contracts/Withdrawable.sol
890 
891 pragma solidity >=0.4.24;
892 
893 
894 
895 
896 abstract contract Withdrawable is AbstractOwnable {
897   using SafeERC20 for IERC20;
898   address constant ETHER = address(0);
899 
900   event LogWithdrawToken(
901     address indexed _from,
902     address indexed _token,
903     uint amount
904   );
905 
906   /**
907    * @dev Withdraw asset.
908    * @param asset Asset to be withdrawn.
909    */
910   function adminWithdraw(address asset) public onlyOwner {
911     uint tokenBalance = adminWithdrawAllowed(asset);
912     require(tokenBalance > 0, "admin witdraw not allowed");
913     _withdraw(asset, tokenBalance);
914   }
915 
916   function _withdraw(address _tokenAddress, uint _amount) internal {
917     if (_tokenAddress == ETHER) {
918       msg.sender.transfer(_amount);
919     } else {
920       IERC20(_tokenAddress).safeTransfer(msg.sender, _amount);
921     }
922     emit LogWithdrawToken(msg.sender, _tokenAddress, _amount);
923   }
924 
925   // can be overridden to disallow withdraw for some token
926   function adminWithdrawAllowed(address asset) internal virtual view returns(uint allowedAmount) {
927     allowedAmount = asset == ETHER
928       ? address(this).balance
929       : IERC20(asset).balanceOf(address(this));
930   }
931 }
932 
933 // File: contracts/PERC20OnEosVault.sol
934 
935 pragma solidity ^0.6.0;
936 
937 
938 
939 
940 
941 
942 
943 
944 contract PERC20OnEosVault is Withdrawable, IERC777Recipient {
945     using SafeERC20 for IERC20;
946     using EnumerableSet for EnumerableSet.AddressSet;
947 
948     IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
949     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH = keccak256("ERC777TokensRecipient");
950 
951     EnumerableSet.AddressSet private supportedTokens;
952     address public PNETWORK;
953     IWETH public weth;
954 
955     event PegIn(address _tokenAddress, address _tokenSender, uint256 _tokenAmount, string _destinationAddress);
956 
957     constructor(
958         address _weth,
959         address [] memory _tokensToSupport
960     ) public {
961         PNETWORK = msg.sender;
962         for (uint256 i = 0; i < _tokensToSupport.length; i++) {
963             supportedTokens.add(_tokensToSupport[i]);
964         }
965         weth = IWETH(_weth);
966         _erc1820.setInterfaceImplementer(address(this), TOKENS_RECIPIENT_INTERFACE_HASH, address(this));
967     }
968 
969     modifier onlyPNetwork() {
970         require(msg.sender == PNETWORK, "Caller must be PNETWORK address!");
971         _;
972     }
973 
974     receive() external payable {
975         require(msg.sender == address(weth));
976     }
977 
978     function setWeth(address _weth) external onlyPNetwork {
979         weth = IWETH(_weth);
980     }
981 
982     function setPNetwork(address _pnetwork) external onlyPNetwork {
983         PNETWORK = _pnetwork;
984     }
985 
986     function IS_TOKEN_SUPPORTED(address _token) external view returns(bool) {
987         return supportedTokens.contains(_token);
988     }
989 
990     function _owner() internal override returns(address) {
991         return PNETWORK;
992     }
993 
994     function adminWithdrawAllowed(address asset) internal override view returns(uint) {
995         return supportedTokens.contains(asset) ? 0 : super.adminWithdrawAllowed(asset);
996     }
997 
998     function addSupportedToken(
999         address _tokenAddress
1000     )
1001         external
1002         onlyPNetwork
1003         returns (bool SUCCESS)
1004     {
1005         supportedTokens.add(_tokenAddress);
1006         return true;
1007     }
1008 
1009     function removeSupportedToken(
1010         address _tokenAddress
1011     )
1012         external
1013         onlyPNetwork
1014         returns (bool SUCCESS)
1015     {
1016         return supportedTokens.remove(_tokenAddress);
1017     }
1018 
1019     function pegIn(
1020         uint256 _tokenAmount,
1021         address _tokenAddress,
1022         string calldata _destinationAddress
1023     )
1024         external
1025         returns (bool)
1026     {
1027         require(supportedTokens.contains(_tokenAddress), "Token at supplied address is NOT supported!");
1028         require(_tokenAmount > 0, "Token amount must be greater than zero!");
1029         IERC20(_tokenAddress).safeTransferFrom(msg.sender, address(this), _tokenAmount);
1030         emit PegIn(_tokenAddress, msg.sender, _tokenAmount, _destinationAddress);
1031         return true;
1032     }
1033 
1034     /**
1035      * @dev Implementation of IERC777Recipient.
1036      */
1037     function tokensReceived(
1038         address /*operator*/,
1039         address from,
1040         address to,
1041         uint256 amount,
1042         bytes calldata userData,
1043         bytes calldata /*operatorData*/
1044     ) external override {
1045         address _tokenAddress = msg.sender;
1046         require(supportedTokens.contains(_tokenAddress), "caller is not a supported ERC777 token!");
1047         require(to == address(this), "Token receiver is not this contract");
1048         if (userData.length > 0) {
1049             require(amount > 0, "Token amount must be greater than zero!");
1050             (bytes32 tag, string memory _destinationAddress) = abi.decode(userData, (bytes32, string));
1051             require(tag == keccak256("ERC777-pegIn"), "Invalid tag for automatic pegIn on ERC777 send");
1052             emit PegIn(_tokenAddress, from, amount, _destinationAddress);
1053         }
1054     }
1055 
1056     function pegInEth(string calldata _destinationAddress)
1057         external
1058         payable
1059         returns (bool)
1060     {
1061         require(supportedTokens.contains(address(weth)), "WETH is NOT supported!");
1062         require(msg.value > 0, "Ethers amount must be greater than zero!");
1063         weth.deposit.value(msg.value)();
1064         emit PegIn(address(weth), msg.sender, msg.value, _destinationAddress);
1065         return true;
1066     }
1067 
1068     function pegOut(
1069         address payable _tokenRecipient,
1070         address _tokenAddress,
1071         uint256 _tokenAmount
1072     )
1073         external
1074         onlyPNetwork
1075         returns (bool)
1076     {
1077         if (_tokenAddress == address(weth)) {
1078             weth.withdraw(_tokenAmount);
1079             _tokenRecipient.transfer(_tokenAmount);
1080         } else {
1081             IERC20(_tokenAddress).safeTransfer(_tokenRecipient, _tokenAmount);
1082         }
1083         return true;
1084     }
1085 
1086     function migrate(
1087         address payable _to
1088     )
1089         external
1090         onlyPNetwork
1091     {
1092         for (uint256 i = 0; i < supportedTokens.length(); i++) {
1093             address tokenAddress = supportedTokens.at(i);
1094             _migrateSingle(_to, tokenAddress);
1095         }
1096     }
1097 
1098     function destroy()
1099         external
1100         onlyPNetwork
1101     {
1102         for (uint256 i = 0; i < supportedTokens.length(); i++) {
1103             address tokenAddress = supportedTokens.at(i);
1104             require(IERC20(tokenAddress).balanceOf(address(this)) == 0, "Balance of supported tokens must be 0");
1105         }
1106         selfdestruct(msg.sender);
1107     }
1108 
1109     function migrateSingle(
1110         address payable _to,
1111         address _tokenAddress
1112     )
1113         external
1114         onlyPNetwork
1115     {
1116         _migrateSingle(_to, _tokenAddress);
1117     }
1118 
1119     function _migrateSingle(
1120         address payable _to,
1121         address _tokenAddress
1122     )
1123         private
1124     {
1125         if (supportedTokens.contains(_tokenAddress)) {
1126             uint balance = IERC20(_tokenAddress).balanceOf(address(this));
1127             IERC20(_tokenAddress).safeTransfer(_to, balance);
1128             supportedTokens.remove(_tokenAddress);
1129         }
1130     }
1131 }