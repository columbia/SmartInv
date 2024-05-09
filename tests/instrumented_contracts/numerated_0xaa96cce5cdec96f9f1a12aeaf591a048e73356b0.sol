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
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
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
1068      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1069      *
1070      * This is internal function is equivalent to `approve`, and can be used to
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
1116 // File: contracts/XdexToken.sol
1117 
1118 pragma solidity 0.6.12;
1119 
1120 
1121 
1122 
1123 // XdexToken with Governance.
1124 contract XdexToken is ERC20("XdexToken", "XDEX"), Ownable {
1125     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1126     function mint(address _to, uint256 _amount) public onlyOwner {
1127         _mint(_to, _amount);
1128         _moveDelegates(address(0), _delegates[_to], _amount);
1129     }
1130 
1131      // https://github.com/quantstamp/sushiswap-security-review 3.4 fixed.
1132     function _transfer(address sender, address recipient, uint256 amount) internal override(ERC20) {
1133         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1134         ERC20._transfer(sender, recipient, amount);
1135     }
1136     // Copied and modified from YAM code:
1137     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1138     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1139     // Which is copied and modified from COMPOUND:
1140     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1141 
1142     /// @notice A record of each accounts delegate
1143     mapping (address => address) internal _delegates;
1144 
1145     /// @notice A checkpoint for marking number of votes from a given block
1146     struct Checkpoint {
1147         uint32 fromBlock;
1148         uint256 votes;
1149     }
1150 
1151     /// @notice A record of votes checkpoints for each account, by index
1152     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1153 
1154     /// @notice The number of checkpoints for each account
1155     mapping (address => uint32) public numCheckpoints;
1156 
1157     /// @notice The EIP-712 typehash for the contract's domain
1158     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1159 
1160     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1161     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1162 
1163     /// @notice A record of states for signing / validating signatures
1164     mapping (address => uint) public nonces;
1165 
1166       /// @notice An event thats emitted when an account changes its delegate
1167     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1168 
1169     /// @notice An event thats emitted when a delegate account's vote balance changes
1170     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1171 
1172     /**
1173      * @notice Delegate votes from `msg.sender` to `delegatee`
1174      * @param delegator The address to get delegatee for
1175      */
1176     function delegates(address delegator)
1177         external
1178         view
1179         returns (address)
1180     {
1181         return _delegates[delegator];
1182     }
1183 
1184    /**
1185     * @notice Delegate votes from `msg.sender` to `delegatee`
1186     * @param delegatee The address to delegate votes to
1187     */
1188     function delegate(address delegatee) external {
1189         return _delegate(msg.sender, delegatee);
1190     }
1191 
1192     /**
1193      * @notice Delegates votes from signatory to `delegatee`
1194      * @param delegatee The address to delegate votes to
1195      * @param nonce The contract state required to match the signature
1196      * @param expiry The time at which to expire the signature
1197      * @param v The recovery byte of the signature
1198      * @param r Half of the ECDSA signature pair
1199      * @param s Half of the ECDSA signature pair
1200      */
1201     function delegateBySig(
1202         address delegatee,
1203         uint nonce,
1204         uint expiry,
1205         uint8 v,
1206         bytes32 r,
1207         bytes32 s
1208     )
1209         external
1210     {
1211         bytes32 domainSeparator = keccak256(
1212             abi.encode(
1213                 DOMAIN_TYPEHASH,
1214                 keccak256(bytes(name())),
1215                 getChainId(),
1216                 address(this)
1217             )
1218         );
1219 
1220         bytes32 structHash = keccak256(
1221             abi.encode(
1222                 DELEGATION_TYPEHASH,
1223                 delegatee,
1224                 nonce,
1225                 expiry
1226             )
1227         );
1228 
1229         bytes32 digest = keccak256(
1230             abi.encodePacked(
1231                 "\x19\x01",
1232                 domainSeparator,
1233                 structHash
1234             )
1235         );
1236 
1237         address signatory = ecrecover(digest, v, r, s);
1238         require(signatory != address(0), "XDEX::delegateBySig: invalid signature");
1239         require(nonce == nonces[signatory]++, "XDEX::delegateBySig: invalid nonce");
1240         require(now <= expiry, "XDEX::delegateBySig: signature expired");
1241         return _delegate(signatory, delegatee);
1242     }
1243 
1244     /**
1245      * @notice Gets the current votes balance for `account`
1246      * @param account The address to get votes balance
1247      * @return The number of current votes for `account`
1248      */
1249     function getCurrentVotes(address account)
1250         external
1251         view
1252         returns (uint256)
1253     {
1254         uint32 nCheckpoints = numCheckpoints[account];
1255         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1256     }
1257 
1258     /**
1259      * @notice Determine the prior number of votes for an account as of a block number
1260      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1261      * @param account The address of the account to check
1262      * @param blockNumber The block number to get the vote balance at
1263      * @return The number of votes the account had as of the given block
1264      */
1265     function getPriorVotes(address account, uint blockNumber)
1266         external
1267         view
1268         returns (uint256)
1269     {
1270         require(blockNumber < block.number, "XDEX::getPriorVotes: not yet determined");
1271 
1272         uint32 nCheckpoints = numCheckpoints[account];
1273         if (nCheckpoints == 0) {
1274             return 0;
1275         }
1276 
1277         // First check most recent balance
1278         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1279             return checkpoints[account][nCheckpoints - 1].votes;
1280         }
1281 
1282         // Next check implicit zero balance
1283         if (checkpoints[account][0].fromBlock > blockNumber) {
1284             return 0;
1285         }
1286 
1287         uint32 lower = 0;
1288         uint32 upper = nCheckpoints - 1;
1289         while (upper > lower) {
1290             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1291             Checkpoint memory cp = checkpoints[account][center];
1292             if (cp.fromBlock == blockNumber) {
1293                 return cp.votes;
1294             } else if (cp.fromBlock < blockNumber) {
1295                 lower = center;
1296             } else {
1297                 upper = center - 1;
1298             }
1299         }
1300         return checkpoints[account][lower].votes;
1301     }
1302 
1303     function _delegate(address delegator, address delegatee)
1304         internal
1305     {
1306         address currentDelegate = _delegates[delegator];
1307         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying XDEXs (not scaled);
1308         _delegates[delegator] = delegatee;
1309 
1310         emit DelegateChanged(delegator, currentDelegate, delegatee);
1311 
1312         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1313     }
1314 
1315     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1316         if (srcRep != dstRep && amount > 0) {
1317             if (srcRep != address(0)) {
1318                 // decrease old representative
1319                 uint32 srcRepNum = numCheckpoints[srcRep];
1320                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1321                 uint256 srcRepNew = srcRepOld.sub(amount);
1322                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1323             }
1324 
1325             if (dstRep != address(0)) {
1326                 // increase new representative
1327                 uint32 dstRepNum = numCheckpoints[dstRep];
1328                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1329                 uint256 dstRepNew = dstRepOld.add(amount);
1330                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1331             }
1332         }
1333     }
1334 
1335     function _writeCheckpoint(
1336         address delegatee,
1337         uint32 nCheckpoints,
1338         uint256 oldVotes,
1339         uint256 newVotes
1340     )
1341         internal
1342     {
1343         uint32 blockNumber = safe32(block.number, "XDEX::_writeCheckpoint: block number exceeds 32 bits");
1344 
1345         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1346             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1347         } else {
1348             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1349             numCheckpoints[delegatee] = nCheckpoints + 1;
1350         }
1351 
1352         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1353     }
1354 
1355     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1356         require(n < 2**32, errorMessage);
1357         return uint32(n);
1358     }
1359 
1360     function getChainId() internal pure returns (uint) {
1361         uint256 chainId;
1362         assembly { chainId := chainid() }
1363         return chainId;
1364     }
1365 }
1366 
1367 // File: contracts/MasterChef.sol
1368 
1369 pragma solidity 0.6.12;
1370 
1371 
1372 
1373 
1374 
1375 
1376 
1377 
1378 interface IMigratorChef {
1379     // Perform LP token migration from legacy UniswapV2 to XdexSwap.
1380     // Take the current LP token address and return the new LP token address.
1381     // Migrator should have full access to the caller's LP token.
1382     // Return the new LP token address.
1383     //
1384     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1385     // XdexSwap must mint EXACTLY the same amount of XdexSwap LP tokens or
1386     // else something bad will happen. Traditional UniswapV2 does not
1387     // do that so be careful!
1388     function migrate(IERC20 token) external returns (IERC20);
1389 }
1390 
1391 // MasterChef is the master of Xdex. He can make Xdex and he is a fair guy.
1392 //
1393 // Note that it's ownable and the owner wields tremendous power. The ownership
1394 // will be transferred to a governance smart contract once XDEX is sufficiently
1395 // distributed and the community can show to govern itself.
1396 //
1397 // Have fun reading it. Hopefully it's bug-free. God bless.
1398 contract MasterChef is Ownable {
1399     using SafeMath for uint256;
1400     using SafeERC20 for IERC20;
1401 
1402     // Info of each user.
1403     struct UserInfo {
1404         uint256 amount;     // How many LP tokens the user has provided.
1405         uint256 rewardDebt; // Reward debt. See explanation below.
1406         //
1407         // We do some fancy math here. Basically, any point in time, the amount of XDEXs
1408         // entitled to a user but is pending to be distributed is:
1409         //
1410         //   pending reward = (user.amount * pool.accXdexPerShare) - user.rewardDebt
1411         //
1412         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1413         //   1. The pool's `accXdexPerShare` (and `lastRewardBlock`) gets updated.
1414         //   2. User receives the pending reward sent to his/her address.
1415         //   3. User's `amount` gets updated.
1416         //   4. User's `rewardDebt` gets updated.
1417     }
1418 
1419     // Info of each pool.
1420     struct PoolInfo {
1421         IERC20 lpToken;           // Address of LP token contract.
1422         uint256 allocPoint;       // How many allocation points assigned to this pool. XDEXs to distribute per block.
1423         uint256 lastRewardBlock;  // Last block number that XDEXs distribution occurs.
1424         uint256 accXdexPerShare; // Accumulated XDEXs per share, times 1e12. See below.
1425     }
1426 
1427     // The XDEX TOKEN!
1428     XdexToken public xdex;
1429     // Block number when bonus XDEX period ends.
1430     uint256 public bonusEndBlock;
1431     // XDEX tokens created per block.
1432     uint256 public xdexPerBlock;
1433     // Bonus muliplier for early xdex makers.
1434     uint256 public constant BONUS_MULTIPLIER = 10;
1435     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1436     IMigratorChef public migrator;
1437 
1438     // Info of each pool.
1439     PoolInfo[] public poolInfo;
1440     // Info of each user that stakes LP tokens.
1441     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1442     mapping (IERC20 => bool) public lpTokenInfo;
1443     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1444     uint256 public totalAllocPoint = 0;
1445     // The block number when XDEX mining starts.
1446     uint256 public startBlock;
1447 
1448     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1449     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1450     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1451 
1452     constructor(
1453         XdexToken _xdex,
1454         IMigratorChef _migrator,
1455         uint256 _xdexPerBlock,
1456         uint256 _startBlock,
1457         uint256 _bonusEndBlock
1458     ) public {
1459         require(address(_migrator) != address(0), "setMigrator: no _migrator");
1460         migrator = _migrator;
1461         xdex = _xdex;
1462         xdexPerBlock = _xdexPerBlock;
1463         bonusEndBlock = _bonusEndBlock;
1464         startBlock = _startBlock;
1465 
1466     }
1467 
1468     function poolLength() external view returns (uint256) {
1469         return poolInfo.length;
1470     }
1471 
1472     // Add a new lp to the pool. Can only be called by the owner.
1473     // https://github.com/quantstamp/sushiswap-security-review 3.1 fixed.
1474     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1475         require(lpTokenInfo[_lpToken] == false,"MasterChef::add - This lpToken already added");
1476         if (_withUpdate) {
1477             massUpdatePools();
1478         }
1479         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1480         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1481         poolInfo.push(PoolInfo({
1482             lpToken: _lpToken,
1483             allocPoint: _allocPoint,
1484             lastRewardBlock: lastRewardBlock,
1485             accXdexPerShare: 0
1486         }));
1487         lpTokenInfo[_lpToken] = true;
1488     }
1489 
1490     // Update the given pool's XDEX allocation point. Can only be called by the owner.
1491     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1492         if (_withUpdate) {
1493             massUpdatePools();
1494         }
1495         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1496         poolInfo[_pid].allocPoint = _allocPoint;
1497     }
1498 
1499 
1500     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1501     function migrate(uint256 _pid) public {
1502         require(address(migrator) != address(0), "migrate: no migrator");
1503         PoolInfo storage pool = poolInfo[_pid];
1504         IERC20 lpToken = pool.lpToken;
1505         uint256 bal = lpToken.balanceOf(address(this));
1506         lpToken.safeApprove(address(migrator), bal);
1507         IERC20 newLpToken = migrator.migrate(lpToken);
1508         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1509         pool.lpToken = newLpToken;
1510     }
1511 
1512     // Return reward multiplier over the given _from to _to block.
1513     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1514         if (_to <= bonusEndBlock) {
1515             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1516         } else if (_from >= bonusEndBlock) {
1517             return _to.sub(_from);
1518         } else {
1519             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1520                 _to.sub(bonusEndBlock)
1521             );
1522         }
1523     }
1524 
1525     // View function to see pending XDEXs on frontend.
1526     function pendingXdex(uint256 _pid, address _user) external view returns (uint256) {
1527         PoolInfo storage pool = poolInfo[_pid];
1528         UserInfo storage user = userInfo[_pid][_user];
1529         uint256 accXdexPerShare = pool.accXdexPerShare;
1530         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1531         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1532             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1533             uint256 xdexReward = multiplier.mul(xdexPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1534             accXdexPerShare = accXdexPerShare.add(xdexReward.mul(1e12).div(lpSupply));
1535         }
1536         return user.amount.mul(accXdexPerShare).div(1e12).sub(user.rewardDebt);
1537     }
1538 
1539     // Update reward variables for all pools. Be careful of gas spending!
1540     function massUpdatePools() public {
1541         uint256 length = poolInfo.length;
1542         for (uint256 pid = 0; pid < length; ++pid) {
1543             updatePool(pid);
1544         }
1545     }
1546 
1547     // Update reward variables of the given pool to be up-to-date.
1548     function updatePool(uint256 _pid) public {
1549         PoolInfo storage pool = poolInfo[_pid];
1550         if (block.number <= pool.lastRewardBlock) {
1551             return;
1552         }
1553         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1554         if (lpSupply == 0) {
1555             pool.lastRewardBlock = block.number;
1556             return;
1557         }
1558         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1559         uint256 xdexReward = multiplier.mul(xdexPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1560         xdex.mint(address(this), xdexReward);
1561         pool.accXdexPerShare = pool.accXdexPerShare.add(xdexReward.mul(1e12).div(lpSupply));
1562         pool.lastRewardBlock = block.number;
1563     }
1564 
1565     // Deposit LP tokens to MasterChef for XDEX allocation.
1566     function deposit(uint256 _pid, uint256 _amount) public {
1567         PoolInfo storage pool = poolInfo[_pid];
1568         UserInfo storage user = userInfo[_pid][msg.sender];
1569         updatePool(_pid);
1570         if (user.amount > 0) {
1571             uint256 pending = user.amount.mul(pool.accXdexPerShare).div(1e12).sub(user.rewardDebt);
1572             if(pending > 0) {
1573                 safeXdexTransfer(msg.sender, pending);
1574             }
1575         }
1576         if(_amount > 0) {
1577             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1578             user.amount = user.amount.add(_amount);
1579         }
1580         user.rewardDebt = user.amount.mul(pool.accXdexPerShare).div(1e12);
1581         emit Deposit(msg.sender, _pid, _amount);
1582     }
1583 
1584     // Withdraw LP tokens from MasterChef.
1585     function withdraw(uint256 _pid, uint256 _amount) public {
1586         PoolInfo storage pool = poolInfo[_pid];
1587         UserInfo storage user = userInfo[_pid][msg.sender];
1588         require(user.amount >= _amount, "withdraw: not good");
1589         updatePool(_pid);
1590         uint256 pending = user.amount.mul(pool.accXdexPerShare).div(1e12).sub(user.rewardDebt);
1591         if(pending > 0) {
1592             safeXdexTransfer(msg.sender, pending);
1593         }
1594         if(_amount > 0) {
1595             user.amount = user.amount.sub(_amount);
1596             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1597         }
1598         user.rewardDebt = user.amount.mul(pool.accXdexPerShare).div(1e12);
1599         emit Withdraw(msg.sender, _pid, _amount);
1600     }
1601 
1602     // Withdraw without caring about rewards. EMERGENCY ONLY.
1603     function emergencyWithdraw(uint256 _pid) public {
1604         PoolInfo storage pool = poolInfo[_pid];
1605         UserInfo storage user = userInfo[_pid][msg.sender];
1606         uint256 user_amount = user.amount;// https://github.com/quantstamp/sushiswap-security-review 3.6 fixed.
1607         user.amount = 0;
1608         user.rewardDebt = 0;
1609         pool.lpToken.safeTransfer(address(msg.sender), user_amount);
1610         emit EmergencyWithdraw(msg.sender, _pid, user_amount);
1611     }
1612 
1613     // Safe xdex transfer function, just in case if rounding error causes pool to not have enough XDEXs.
1614     function safeXdexTransfer(address _to, uint256 _amount) internal {
1615         uint256 xdexBal = xdex.balanceOf(address(this));
1616         if (_amount > xdexBal) {
1617             xdex.transfer(_to, xdexBal);
1618         } else {
1619             xdex.transfer(_to, _amount);
1620         }
1621     }
1622 
1623 }