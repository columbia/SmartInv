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
807 // File: contracts/library/NameFilter.sol
808 
809 pragma solidity  0.6.12;
810 
811 library NameFilter {
812     /**
813      * @dev filters name strings
814      * -converts uppercase to lower case.  
815      * -makes sure it does not start/end with a space
816      * -makes sure it does not contain multiple spaces in a row
817      * -cannot be only numbers
818      * -cannot start with 0x 
819      * -restricts characters to A-Z, a-z, 0-9, and space.
820      * @return reprocessed string in bytes32 format
821      */
822     function nameFilter(string memory _input)
823         internal
824         pure
825         returns(bytes32)
826     {
827         bytes memory _temp = bytes(_input);
828         uint256 _length = _temp.length;
829         
830         //sorry limited to 32 characters
831         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
832         // make sure first two characters are not 0x
833         if (_temp[0] == 0x30)
834         {
835             require(_temp[1] != 0x78, "string cannot start with 0x");
836             require(_temp[1] != 0x58, "string cannot start with 0X");
837         }
838         
839         // create a bool to track if we have a non number character
840         bool _hasNonNumber;
841         
842         // convert & check
843         for (uint256 i = 0; i < _length; i++)
844         {
845             // if its uppercase A-Z
846             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
847             {
848                 // convert to lower case a-z
849                 _temp[i] = byte(uint8(_temp[i]) + 32);
850                 
851                 // we have a non number
852                 if (_hasNonNumber == false)
853                     _hasNonNumber = true;
854             } else {
855                 require
856                 (
857                     // OR lowercase a-z
858                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
859                     // or 0-9
860                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
861                     "string contains invalid characters"
862                 );
863                 
864                 // see if we have a character other than a number
865                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
866                     _hasNonNumber = true;    
867             }
868         }
869         
870         require(_hasNonNumber == true, "string cannot be only numbers");
871         
872         bytes32 _ret;
873         assembly {
874             _ret := mload(add(_temp, 32))
875         }
876         return (_ret);
877     }
878 }
879 
880 // File: contracts/library/Governance.sol
881 
882 pragma solidity  0.6.12;
883 
884 contract Governance {
885 
886     address public _governance;
887 
888     constructor() public {
889         _governance = tx.origin;
890     }
891 
892     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
893 
894     modifier onlyGovernance {
895         require(msg.sender == _governance, "not governance");
896         _;
897     }
898 
899     function setGovernance(address governance)  public  onlyGovernance
900     {
901         require(governance != address(0), "new governance the zero address");
902         emit GovernanceTransferred(_governance, governance);
903         _governance = governance;
904     }
905 
906 
907 }
908 
909 // File: contracts/interface/IPlayerBook.sol
910 
911 pragma solidity  0.6.12;
912 
913 
914 interface IPlayerBook {
915     function settleReward( address from,uint256 amount ) external returns (uint256);
916     function bindRefer( address from,string calldata  affCode ) external  returns (bool);
917     function hasRefer(address from)  external returns(bool);
918     function getPlayerLaffAddress(address from) external returns(address); 
919 
920 }
921 
922 // File: contracts/PlayerBook.sol
923 
924 pragma solidity  0.6.12;
925 
926 // import '@openzeppelin/contracts/ownership/Ownable.sol';
927 
928 
929 // import "../library/SafeERC20.sol";
930 
931 
932 
933 contract PlayerBook is Governance {
934     using NameFilter for string;
935     using SafeMath for uint256;
936     using SafeERC20 for IERC20;
937  
938     // register pools       
939     mapping (address => bool) public _pools;
940 
941     // (addr => pID) returns player id by address
942     mapping (address => uint256) public _pIDxAddr;   
943     // (name => pID) returns player id by name      
944     mapping (bytes32 => uint256) public _pIDxName;    
945     // (pID => data) player data     
946     mapping (uint256 => Player) public _plyr;      
947     // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)        
948     mapping (uint256 => mapping (bytes32 => bool)) public _plyrNames; 
949   
950     // total number of players
951     uint256 public _pID;
952     // total register name count
953     uint256 public _totalRegisterCount = 0;
954 
955     // the direct refer's reward rate  直接推荐人的奖励率
956     uint256 public _referRewardRate = 1000; //10%
957     // base rate
958     uint256 public _baseRate = 10000;
959 
960     // base price to register a name
961     uint256 public _registrationBaseFee = 10 finney;     
962     // register fee count step
963     uint256 public _registrationStep = 100;
964     // add base price for one step
965     uint256 public _stepFee = 10 finney;     
966 
967     bytes32 public _defaulRefer = "hbt";
968 
969     address payable public _teamWallet;
970   
971     struct Player {
972         address addr;
973         bytes32 name;
974         uint8 nameCount;
975         uint256 laff;
976         uint256 lvCount;
977     }
978 
979     event eveBindRefer(uint256 pID, address addr, bytes32 name, uint256 affID, address affAddr, bytes32 affName);
980     event eveDefaultPlayer(uint256 pID, address addr, bytes32 name);      
981     event eveNewName(uint256 pID, address addr, bytes32 name, uint256 affID, address affAddr, bytes32 affName, uint256 balance  );
982     event eveAddPool(address addr);
983     event eveRemovePool(address addr);
984 
985 
986     constructor(address payable teamWallet)
987         public
988     {
989         _pID = 0;
990         _teamWallet = teamWallet;
991         addDefaultPlayer(_teamWallet,_defaulRefer);
992     }
993 
994     /**
995      * check address
996      */
997     modifier validAddress( address addr ) {
998         require(addr != address(0x0));
999         _;
1000     }
1001 
1002     /**
1003      * check pool
1004      */
1005     modifier isRegisteredPool(){
1006         require(_pools[msg.sender],"invalid pool address!");
1007         _;
1008     }
1009 
1010     // only function for creating additional rewards from dust
1011     function seize(IERC20 asset) external returns (uint256 balance) {
1012         balance = asset.balanceOf(address(this));
1013         asset.safeTransfer(_teamWallet, balance);
1014     }
1015 
1016     // get register fee 
1017     function seizeEth() external  {
1018         uint256 _currentBalance =  address(this).balance;
1019         _teamWallet.transfer(_currentBalance);
1020     }
1021     
1022     /**
1023      * revert invalid transfer action
1024      */
1025     fallback() external payable {
1026         revert();
1027     }
1028 
1029     receive() external payable {
1030         revert();
1031     }
1032 
1033     /**
1034      * registe a pool
1035      */
1036     function addPool(address poolAddr)
1037         onlyGovernance
1038         public
1039     {
1040         require( !_pools[poolAddr], "derp, that pool already been registered");
1041 
1042         _pools[poolAddr] = true;
1043 
1044         emit eveAddPool(poolAddr);
1045     }
1046     
1047     /**
1048      * remove a pool
1049      */
1050     function removePool(address poolAddr)
1051         onlyGovernance
1052         public
1053     {
1054         require( _pools[poolAddr], "derp, that pool must be registered");
1055 
1056         _pools[poolAddr] = false;
1057 
1058         emit eveRemovePool(poolAddr);
1059     }
1060 
1061     /**
1062      * check name string
1063      * 查询某个名字是否可以注册
1064      */
1065     function checkIfNameValid(string memory nameStr)
1066         public
1067         view
1068         returns(bool)
1069     {
1070         bytes32 name = nameStr.nameFilter();
1071         if (_pIDxName[name] == 0)
1072             return (true);
1073         else 
1074             return (false);
1075     }
1076     
1077     /**
1078      * @dev add a default player
1079      */
1080     function addDefaultPlayer(address addr, bytes32 name)
1081         private
1082     {        
1083         _pID++;
1084 
1085         _plyr[_pID].addr = addr;
1086         _plyr[_pID].name = name;
1087         _plyr[_pID].nameCount = 1;
1088         _pIDxAddr[addr] = _pID;
1089         _pIDxName[name] = _pID;
1090         _plyrNames[_pID][name] = true;
1091 
1092         //fire event
1093         emit eveDefaultPlayer(_pID,addr,name);        
1094     }
1095     
1096     /**
1097      * @dev set refer reward rate
1098      */
1099     function setReferRewardRate(uint256 referRate) public  
1100         onlyGovernance
1101     {
1102         _referRewardRate = referRate;
1103     }
1104 
1105     /**
1106      * @dev set registration step count
1107      */
1108     function setRegistrationStep(uint256 registrationStep) public  
1109         onlyGovernance
1110     {
1111         _registrationStep = registrationStep;
1112     }
1113 
1114     /**
1115      * @dev registers a name.  UI will always display the last name you registered.
1116      * but you will still own all previously registered names to use as affiliate 
1117      * links.
1118      * - must pay a registration fee.
1119      * - name must be unique
1120      * - names will be converted to lowercase
1121      * - cannot be only numbers
1122      * - cannot start with 0x 
1123      * - name must be at least 1 char
1124      * - max length of 32 characters long
1125      * - allowed characters: a-z, 0-9
1126      * -functionhash- 0x921dec21 (using ID for affiliate)
1127      * -functionhash- 0x3ddd4698 (using address for affiliate)
1128      * -functionhash- 0x685ffd83 (using name for affiliate)
1129      * @param nameString players desired name
1130      * @param affCode affiliate name of who refered you
1131      * (this might cost a lot of gas)
1132      */
1133 
1134     /**
1135     参数类型：(string memory nameString, string memory affCode) //自己的名字，邀请人的名字
1136 说明：如果邀请人的名字为“”意味着没有邀请者
1137 	每一次注册是需要支付手续费的，【0，99）号用户收取100 finney，【100，199）200 ～
1138      */
1139     function registerNameXName(string memory nameString, string memory affCode)
1140         public
1141         payable 
1142     {
1143 
1144         // make sure name fees paid
1145         require (msg.value >= this.getRegistrationFee(), "umm.....  you have to pay the name fee");
1146 
1147         // filter name + condition checks
1148         bytes32 name = NameFilter.nameFilter(nameString);
1149         // if names already has been used
1150         require(_pIDxName[name] == 0, "sorry that names already taken");
1151 
1152         // set up address 
1153         address addr = msg.sender;
1154          // set up our tx event data and determine if player is new or not
1155         _determinePID(addr);
1156         // fetch player id
1157         uint256 pID = _pIDxAddr[addr];
1158         // if names already has been used
1159         require(_plyrNames[pID][name] == false, "sorry that names already taken");
1160 
1161         // add name to player profile, registry, and name book
1162         _plyrNames[pID][name] = true;
1163         _pIDxName[name] = pID;   
1164         _plyr[pID].name = name;
1165         _plyr[pID].nameCount++;
1166 
1167         _totalRegisterCount++;
1168 
1169 
1170         //try bind a refer
1171         if(_plyr[pID].laff == 0){
1172 
1173             bytes memory tempCode = bytes(affCode);
1174             bytes32 affName = 0x0;
1175             if (tempCode.length >= 0) {
1176                 assembly {
1177                     affName := mload(add(tempCode, 32))
1178                 }
1179             }
1180 
1181             _bindRefer(addr,affName);
1182         }
1183         uint256 affID = _plyr[pID].laff;
1184 
1185         // fire event
1186         emit eveNewName(pID, addr, name, affID, _plyr[affID].addr, _plyr[affID].name, _registrationBaseFee );
1187     }
1188     
1189     /**
1190      * @dev bind a refer,if affcode invalid, use default refer
1191      */  
1192     function bindRefer( address from, string calldata  affCode )
1193         isRegisteredPool()
1194         external
1195         // override
1196         returns (bool)
1197     {
1198 
1199         bytes memory tempCode = bytes(affCode);
1200         bytes32 affName = 0x0;
1201         if (tempCode.length >= 0) {
1202             assembly {
1203                 affName := mload(add(tempCode, 32))
1204             }
1205         }
1206 
1207         return _bindRefer(from, affName);
1208     }
1209 
1210 
1211     /**
1212      * @dev bind a refer,if affcode invalid, use default refer
1213      */  
1214     function _bindRefer( address from, bytes32  name )
1215         validAddress(msg.sender)    
1216         validAddress(from)  
1217         private
1218         returns (bool)
1219     {
1220         // set up our tx event data and determine if player is new or not
1221         _determinePID(from);
1222 
1223         // fetch player id
1224         uint256 pID = _pIDxAddr[from];
1225         if( _plyr[pID].laff != 0){
1226             return false;
1227         }
1228 
1229         if (_pIDxName[name] == 0){
1230             //unregister name 
1231             name = _defaulRefer;
1232         }
1233       
1234         uint256 affID = _pIDxName[name];
1235         if( affID == pID){
1236             affID = _pIDxName[_defaulRefer];
1237         }
1238        
1239         _plyr[pID].laff = affID;
1240         //lvcount
1241         _plyr[affID].lvCount++;
1242         // fire event
1243         emit eveBindRefer(pID, from, name, affID, _plyr[affID].addr, _plyr[affID].name);
1244 
1245         return true;
1246     }
1247     
1248     //
1249     function _determinePID(address addr)
1250         private
1251         returns (bool)
1252     {
1253         if (_pIDxAddr[addr] == 0)
1254         {
1255             _pID++;
1256             _pIDxAddr[addr] = _pID;
1257             _plyr[_pID].addr = addr;
1258             
1259             // set the new player bool to true
1260             return (true);
1261         } else {
1262             return (false);
1263         }
1264     }
1265     
1266     function hasRefer(address from) 
1267         isRegisteredPool()
1268         external 
1269         // override
1270         returns(bool) 
1271     {
1272         _determinePID(from);
1273         uint256 pID =  _pIDxAddr[from];
1274         return (_plyr[pID].laff > 0);
1275     }
1276 
1277     //查询某个用户的名字
1278     function getPlayerName(address from)
1279         external
1280         view
1281         returns (bytes32)
1282     {
1283         uint256 pID =  _pIDxAddr[from];
1284         if(_pID==0){
1285             return "";
1286         }
1287         return (_plyr[pID].name);
1288     }
1289 
1290     //查询某个用户的邀请者地址
1291     function getPlayerLaffAddress(address from) external  view returns(address laffAddress) {
1292         uint256 pID =  _pIDxAddr[from];
1293         if(_pID==0){
1294             return _teamWallet;
1295         }
1296         uint256 laffID = _plyr[pID].laff;
1297         if(laffID == 0) {
1298             return _teamWallet;
1299         }
1300         return _plyr[laffID].addr;
1301     }
1302 
1303     //查询某个用户的邀请者的地址
1304     function getPlayerLaffName(address from)
1305         external
1306         view
1307         returns (bytes32)
1308     {
1309         uint256 pID =  _pIDxAddr[from];
1310         if(_pID==0){
1311              return "";
1312         }
1313 
1314         uint256 aID=_plyr[pID].laff;
1315         if( aID== 0){
1316             return "";
1317         }
1318 
1319         return (_plyr[aID].name);
1320     }
1321 
1322     //查询某个用户的id，邀请者id，邀请数量
1323     function getPlayerInfo(address from)
1324         external
1325         view
1326         returns (uint256,uint256,uint256)
1327     {
1328         uint256 pID = _pIDxAddr[from];
1329         if(_pID==0){
1330              return (0,0,0);
1331         }
1332         return (pID,_plyr[pID].laff,_plyr[pID].lvCount);
1333     }
1334 
1335     //获取当前注册费用
1336     function getRegistrationFee()
1337         external
1338         view
1339         returns (uint256)
1340     {
1341         if( _totalRegisterCount <_registrationStep || _registrationStep == 0){
1342             return _registrationBaseFee;
1343         }
1344         else{
1345             uint256 step = _totalRegisterCount.div(_registrationStep);
1346             return _registrationBaseFee.add(step.mul(_stepFee));
1347         }
1348     }
1349 }
1350 
1351 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1352 
1353 
1354 
1355 pragma solidity ^0.6.0;
1356 
1357 
1358 
1359 
1360 
1361 /**
1362  * @dev Implementation of the {IERC20} interface.
1363  *
1364  * This implementation is agnostic to the way tokens are created. This means
1365  * that a supply mechanism has to be added in a derived contract using {_mint}.
1366  * For a generic mechanism see {ERC20PresetMinterPauser}.
1367  *
1368  * TIP: For a detailed writeup see our guide
1369  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1370  * to implement supply mechanisms].
1371  *
1372  * We have followed general OpenZeppelin guidelines: functions revert instead
1373  * of returning `false` on failure. This behavior is nonetheless conventional
1374  * and does not conflict with the expectations of ERC20 applications.
1375  *
1376  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1377  * This allows applications to reconstruct the allowance for all accounts just
1378  * by listening to said events. Other implementations of the EIP may not emit
1379  * these events, as it isn't required by the specification.
1380  *
1381  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1382  * functions have been added to mitigate the well-known issues around setting
1383  * allowances. See {IERC20-approve}.
1384  */
1385 contract ERC20 is Context, IERC20 {
1386     using SafeMath for uint256;
1387     using Address for address;
1388 
1389     mapping (address => uint256) private _balances;
1390 
1391     mapping (address => mapping (address => uint256)) private _allowances;
1392 
1393     uint256 private _totalSupply;
1394 
1395     string private _name;
1396     string private _symbol;
1397     uint8 private _decimals;
1398 
1399     /**
1400      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1401      * a default value of 18.
1402      *
1403      * To select a different value for {decimals}, use {_setupDecimals}.
1404      *
1405      * All three of these values are immutable: they can only be set once during
1406      * construction.
1407      */
1408     constructor (string memory name, string memory symbol) public {
1409         _name = name;
1410         _symbol = symbol;
1411         _decimals = 18;
1412     }
1413 
1414     /**
1415      * @dev Returns the name of the token.
1416      */
1417     function name() public view returns (string memory) {
1418         return _name;
1419     }
1420 
1421     /**
1422      * @dev Returns the symbol of the token, usually a shorter version of the
1423      * name.
1424      */
1425     function symbol() public view returns (string memory) {
1426         return _symbol;
1427     }
1428 
1429     /**
1430      * @dev Returns the number of decimals used to get its user representation.
1431      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1432      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1433      *
1434      * Tokens usually opt for a value of 18, imitating the relationship between
1435      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1436      * called.
1437      *
1438      * NOTE: This information is only used for _display_ purposes: it in
1439      * no way affects any of the arithmetic of the contract, including
1440      * {IERC20-balanceOf} and {IERC20-transfer}.
1441      */
1442     function decimals() public view returns (uint8) {
1443         return _decimals;
1444     }
1445 
1446     /**
1447      * @dev See {IERC20-totalSupply}.
1448      */
1449     function totalSupply() public view override returns (uint256) {
1450         return _totalSupply;
1451     }
1452 
1453     /**
1454      * @dev See {IERC20-balanceOf}.
1455      */
1456     function balanceOf(address account) public view override returns (uint256) {
1457         return _balances[account];
1458     }
1459 
1460     /**
1461      * @dev See {IERC20-transfer}.
1462      *
1463      * Requirements:
1464      *
1465      * - `recipient` cannot be the zero address.
1466      * - the caller must have a balance of at least `amount`.
1467      */
1468     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1469         _transfer(_msgSender(), recipient, amount);
1470         return true;
1471     }
1472 
1473     /**
1474      * @dev See {IERC20-allowance}.
1475      */
1476     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1477         return _allowances[owner][spender];
1478     }
1479 
1480     /**
1481      * @dev See {IERC20-approve}.
1482      *
1483      * Requirements:
1484      *
1485      * - `spender` cannot be the zero address.
1486      */
1487     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1488         _approve(_msgSender(), spender, amount);
1489         return true;
1490     }
1491 
1492     /**
1493      * @dev See {IERC20-transferFrom}.
1494      *
1495      * Emits an {Approval} event indicating the updated allowance. This is not
1496      * required by the EIP. See the note at the beginning of {ERC20};
1497      *
1498      * Requirements:
1499      * - `sender` and `recipient` cannot be the zero address.
1500      * - `sender` must have a balance of at least `amount`.
1501      * - the caller must have allowance for ``sender``'s tokens of at least
1502      * `amount`.
1503      */
1504     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1505         _transfer(sender, recipient, amount);
1506         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1507         return true;
1508     }
1509 
1510     /**
1511      * @dev Atomically increases the allowance granted to `spender` by the caller.
1512      *
1513      * This is an alternative to {approve} that can be used as a mitigation for
1514      * problems described in {IERC20-approve}.
1515      *
1516      * Emits an {Approval} event indicating the updated allowance.
1517      *
1518      * Requirements:
1519      *
1520      * - `spender` cannot be the zero address.
1521      */
1522     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1523         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1524         return true;
1525     }
1526 
1527     /**
1528      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1529      *
1530      * This is an alternative to {approve} that can be used as a mitigation for
1531      * problems described in {IERC20-approve}.
1532      *
1533      * Emits an {Approval} event indicating the updated allowance.
1534      *
1535      * Requirements:
1536      *
1537      * - `spender` cannot be the zero address.
1538      * - `spender` must have allowance for the caller of at least
1539      * `subtractedValue`.
1540      */
1541     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1542         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1543         return true;
1544     }
1545 
1546     /**
1547      * @dev Moves tokens `amount` from `sender` to `recipient`.
1548      *
1549      * This is internal function is equivalent to {transfer}, and can be used to
1550      * e.g. implement automatic token fees, slashing mechanisms, etc.
1551      *
1552      * Emits a {Transfer} event.
1553      *
1554      * Requirements:
1555      *
1556      * - `sender` cannot be the zero address.
1557      * - `recipient` cannot be the zero address.
1558      * - `sender` must have a balance of at least `amount`.
1559      */
1560     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1561         require(sender != address(0), "ERC20: transfer from the zero address");
1562         require(recipient != address(0), "ERC20: transfer to the zero address");
1563 
1564         _beforeTokenTransfer(sender, recipient, amount);
1565 
1566         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1567         _balances[recipient] = _balances[recipient].add(amount);
1568         emit Transfer(sender, recipient, amount);
1569     }
1570 
1571     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1572      * the total supply.
1573      *
1574      * Emits a {Transfer} event with `from` set to the zero address.
1575      *
1576      * Requirements
1577      *
1578      * - `to` cannot be the zero address.
1579      */
1580     function _mint(address account, uint256 amount) internal virtual {
1581         require(account != address(0), "ERC20: mint to the zero address");
1582 
1583         _beforeTokenTransfer(address(0), account, amount);
1584 
1585         _totalSupply = _totalSupply.add(amount);
1586         _balances[account] = _balances[account].add(amount);
1587         emit Transfer(address(0), account, amount);
1588     }
1589 
1590     /**
1591      * @dev Destroys `amount` tokens from `account`, reducing the
1592      * total supply.
1593      *
1594      * Emits a {Transfer} event with `to` set to the zero address.
1595      *
1596      * Requirements
1597      *
1598      * - `account` cannot be the zero address.
1599      * - `account` must have at least `amount` tokens.
1600      */
1601     function _burn(address account, uint256 amount) internal virtual {
1602         require(account != address(0), "ERC20: burn from the zero address");
1603 
1604         _beforeTokenTransfer(account, address(0), amount);
1605 
1606         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1607         _totalSupply = _totalSupply.sub(amount);
1608         emit Transfer(account, address(0), amount);
1609     }
1610 
1611     /**
1612      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1613      *
1614      * This is internal function is equivalent to `approve`, and can be used to
1615      * e.g. set automatic allowances for certain subsystems, etc.
1616      *
1617      * Emits an {Approval} event.
1618      *
1619      * Requirements:
1620      *
1621      * - `owner` cannot be the zero address.
1622      * - `spender` cannot be the zero address.
1623      */
1624     function _approve(address owner, address spender, uint256 amount) internal virtual {
1625         require(owner != address(0), "ERC20: approve from the zero address");
1626         require(spender != address(0), "ERC20: approve to the zero address");
1627 
1628         _allowances[owner][spender] = amount;
1629         emit Approval(owner, spender, amount);
1630     }
1631 
1632     /**
1633      * @dev Sets {decimals} to a value other than the default one of 18.
1634      *
1635      * WARNING: This function should only be called from the constructor. Most
1636      * applications that interact with token contracts will not expect
1637      * {decimals} to ever change, and may work incorrectly if it does.
1638      */
1639     function _setupDecimals(uint8 decimals_) internal {
1640         _decimals = decimals_;
1641     }
1642 
1643     /**
1644      * @dev Hook that is called before any transfer of tokens. This includes
1645      * minting and burning.
1646      *
1647      * Calling conditions:
1648      *
1649      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1650      * will be to transferred to `to`.
1651      * - when `from` is zero, `amount` tokens will be minted for `to`.
1652      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1653      * - `from` and `to` are never both zero.
1654      *
1655      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1656      */
1657     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1658 }
1659 
1660 // File: contracts/HBTToken.sol
1661 
1662 pragma solidity 0.6.12;
1663 
1664 
1665 
1666 
1667 // SushiToken with Governance.
1668 contract HBTToken is ERC20("HBTToken", "HBT"), Ownable {
1669 
1670     
1671     mapping (address => bool) public allowMintAddr; //铸币白名单
1672     uint256 private _capacity;
1673 
1674     constructor () public {
1675         _capacity = 1000000000000000000000000000;
1676     }
1677 
1678     //最大发行量
1679     function capacity() public view  returns (uint256) {
1680         return _capacity;
1681     }
1682 
1683     //设置白名单
1684     function setAllowMintAddr(address _address,bool _bool) public onlyOwner {
1685         allowMintAddr[_address] = _bool;
1686     }
1687     //获取白名单
1688     function allowMintAddrInfo(address _address) external view  returns(bool) {
1689         return allowMintAddr[_address];
1690     }
1691 
1692     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1693     function mint(address _to, uint256 _amount) public onlyOwner {
1694         require( totalSupply().add(_amount) <= _capacity, "ERC20: Maximum capacity exceeded");
1695 
1696         _mint(_to, _amount);
1697         _moveDelegates(address(0), _delegates[_to], _amount);
1698     }
1699     //销毁
1700     function burn(uint256 _amount) public onlyOwner {
1701         address ownerAddr = owner();
1702         require(balanceOf(ownerAddr) >= _amount,"ERC20: Exceed the user's amount");
1703         _burn(ownerAddr, _amount);
1704     }
1705     
1706     //白名单铸币 
1707     function allowMint(address _to, uint256 _amount) public {
1708         require(allowMintAddr[msg.sender],"HBT:The address is not in the allowed range");
1709         require( totalSupply().add(_amount) <= _capacity, "ERC20: Maximum capacity exceeded");
1710 
1711         _mint(_to, _amount);
1712         _moveDelegates(address(0), _delegates[_to], _amount);
1713     }
1714 
1715     // Copied and modified from YAM code:
1716     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1717     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1718     // Which is copied and modified from COMPOUND:
1719     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1720 
1721     /// @notice A record of each accounts delegate
1722     mapping (address => address) internal _delegates;
1723 
1724     /// @notice A checkpoint for marking number of votes from a given block
1725     struct Checkpoint {
1726         uint32 fromBlock;
1727         uint256 votes;
1728     }
1729 
1730     /// @notice A record of votes checkpoints for each account, by index
1731     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1732 
1733     /// @notice The number of checkpoints for each account
1734     mapping (address => uint32) public numCheckpoints;
1735 
1736     /// @notice The EIP-712 typehash for the contract's domain
1737     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1738 
1739     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1740     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1741 
1742     /// @notice A record of states for signing / validating signatures
1743     mapping (address => uint) public nonces;
1744 
1745       /// @notice An event thats emitted when an account changes its delegate
1746     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1747 
1748     /// @notice An event thats emitted when a delegate account's vote balance changes
1749     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1750 
1751     /**
1752      * @notice Delegate votes from `msg.sender` to `delegatee`
1753      * @param delegator The address to get delegatee for
1754      */
1755     function delegates(address delegator)
1756         external
1757         view
1758         returns (address)
1759     {
1760         return _delegates[delegator];
1761     }
1762 
1763    /**
1764     * @notice Delegate votes from `msg.sender` to `delegatee`
1765     * @param delegatee The address to delegate votes to
1766     */
1767     function delegate(address delegatee) external {
1768         return _delegate(msg.sender, delegatee);
1769     }
1770 
1771     /**
1772      * @notice Delegates votes from signatory to `delegatee`
1773      * @param delegatee The address to delegate votes to
1774      * @param nonce The contract state required to match the signature
1775      * @param expiry The time at which to expire the signature
1776      * @param v The recovery byte of the signature
1777      * @param r Half of the ECDSA signature pair
1778      * @param s Half of the ECDSA signature pair
1779      */
1780     function delegateBySig(
1781         address delegatee,
1782         uint nonce,
1783         uint expiry,
1784         uint8 v,
1785         bytes32 r,
1786         bytes32 s
1787     )
1788         external
1789     {
1790         bytes32 domainSeparator = keccak256(
1791             abi.encode(
1792                 DOMAIN_TYPEHASH,
1793                 keccak256(bytes(name())),
1794                 getChainId(),
1795                 address(this)
1796             )
1797         );
1798 
1799         bytes32 structHash = keccak256(
1800             abi.encode(
1801                 DELEGATION_TYPEHASH,
1802                 delegatee,
1803                 nonce,
1804                 expiry
1805             )
1806         );
1807 
1808         bytes32 digest = keccak256(
1809             abi.encodePacked(
1810                 "\x19\x01",
1811                 domainSeparator,
1812                 structHash
1813             )
1814         );
1815 
1816         address signatory = ecrecover(digest, v, r, s);
1817         require(signatory != address(0), "HBT::delegateBySig: invalid signature");
1818         require(nonce == nonces[signatory]++, "HBT::delegateBySig: invalid nonce");
1819         require(now <= expiry, "HBT::delegateBySig: signature expired");
1820         return _delegate(signatory, delegatee);
1821     }
1822 
1823     /**
1824      * @notice Gets the current votes balance for `account`
1825      * @param account The address to get votes balance
1826      * @return The number of current votes for `account`
1827      */
1828     function getCurrentVotes(address account)
1829         external
1830         view
1831         returns (uint256)
1832     {
1833         uint32 nCheckpoints = numCheckpoints[account];
1834         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1835     }
1836 
1837     /**
1838      * @notice Determine the prior number of votes for an account as of a block number
1839      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1840      * @param account The address of the account to check
1841      * @param blockNumber The block number to get the vote balance at
1842      * @return The number of votes the account had as of the given block
1843      */
1844     function getPriorVotes(address account, uint blockNumber)
1845         external
1846         view
1847         returns (uint256)
1848     {
1849         require(blockNumber < block.number, "HBT::getPriorVotes: not yet determined");
1850 
1851         uint32 nCheckpoints = numCheckpoints[account];
1852         if (nCheckpoints == 0) {
1853             return 0;
1854         }
1855 
1856         // First check most recent balance
1857         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1858             return checkpoints[account][nCheckpoints - 1].votes;
1859         }
1860 
1861         // Next check implicit zero balance
1862         if (checkpoints[account][0].fromBlock > blockNumber) {
1863             return 0;
1864         }
1865 
1866         uint32 lower = 0;
1867         uint32 upper = nCheckpoints - 1;
1868         while (upper > lower) {
1869             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1870             Checkpoint memory cp = checkpoints[account][center];
1871             if (cp.fromBlock == blockNumber) {
1872                 return cp.votes;
1873             } else if (cp.fromBlock < blockNumber) {
1874                 lower = center;
1875             } else {
1876                 upper = center - 1;
1877             }
1878         }
1879         return checkpoints[account][lower].votes;
1880     }
1881 
1882     function _delegate(address delegator, address delegatee)
1883         internal
1884     {
1885         address currentDelegate = _delegates[delegator];
1886         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying HBTs (not scaled);
1887         _delegates[delegator] = delegatee;
1888 
1889         emit DelegateChanged(delegator, currentDelegate, delegatee);
1890 
1891         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1892     }
1893 
1894     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1895         if (srcRep != dstRep && amount > 0) {
1896             if (srcRep != address(0)) {
1897                 // decrease old representative
1898                 uint32 srcRepNum = numCheckpoints[srcRep];
1899                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1900                 uint256 srcRepNew = srcRepOld.sub(amount);
1901                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1902             }
1903 
1904             if (dstRep != address(0)) {
1905                 // increase new representative
1906                 uint32 dstRepNum = numCheckpoints[dstRep];
1907                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1908                 uint256 dstRepNew = dstRepOld.add(amount);
1909                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1910             }
1911         }
1912     }
1913 
1914     function _writeCheckpoint(
1915         address delegatee,
1916         uint32 nCheckpoints,
1917         uint256 oldVotes,
1918         uint256 newVotes
1919     )
1920         internal
1921     {
1922         uint32 blockNumber = safe32(block.number, "HBT::_writeCheckpoint: block number exceeds 32 bits");
1923 
1924         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1925             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1926         } else {
1927             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1928             numCheckpoints[delegatee] = nCheckpoints + 1;
1929         }
1930 
1931         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1932     }
1933 
1934     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1935         require(n < 2**32, errorMessage);
1936         return uint32(n);
1937     }
1938 
1939     function getChainId() internal pure returns (uint) {
1940         uint256 chainId;
1941         assembly { chainId := chainid() }
1942         return chainId;
1943     }
1944 
1945 
1946 }
1947 
1948 // File: contracts/HBTLock.sol
1949 
1950 pragma solidity 0.6.12;
1951 
1952 
1953 
1954 
1955 
1956 
1957 contract HBTLock is Ownable {
1958     using SafeMath for uint256;
1959     using SafeERC20 for IERC20;
1960 
1961     uint256 public blockTime = 15;       //出块时长
1962     uint256 public timesAwardTotal;      //倍数总奖励
1963     uint256 public depositTotal;         //抵押总数量
1964     uint256 public pickDepositTotal;     //已解锁数量
1965     uint256 public pickTimesAwardTotal;  //已解锁倍数奖励
1966 
1967     address public masterChef;
1968     IERC20 public hbtSafe;
1969     uint256 public depositCountTotal = 20;   //用户最大抵押次数
1970 
1971     //锁定记录struct
1972     struct DepositInfo {
1973         uint256 endBlock;    //抵押结束区块号
1974         uint256 number;      //抵押数量
1975         uint256 times;       //倍数
1976     }
1977     mapping (address => DepositInfo[]) public depositInfo;    //锁定记录
1978 
1979     //用户信息
1980     struct UserInfo {
1981         uint256 timesAward;         //倍数奖励
1982         uint256 deposit;            //抵押数量
1983         uint256 pickDeposit;        //已解锁数量
1984         uint256 pickTimesAward;     //已解锁倍数奖励
1985         uint256 depositCount;       //抵押次数
1986     }
1987     mapping (address => UserInfo) public userInfo;    //用户记录
1988 
1989     //times
1990     mapping (uint256 => uint256) times;
1991 
1992     constructor(
1993         IERC20 _hbt          //HBT Token合约地址
1994     ) public {
1995         hbtSafe = _hbt;
1996 
1997         // times[12] = 300;
1998         // times[15] = 600;
1999         // times[25] = 1200;
2000 
2001         times[12] = 2592000;  //30天
2002         times[15] = 5184000;  //60天
2003         times[25] = 15552000; //180天
2004     }
2005 
2006     bool public close = false;
2007 
2008     event Withdraw(address indexed user,uint256 unlockNumber);
2009 
2010     //masterChef  
2011     function setMasterChef(address _address) public  onlyOwner {
2012         masterChef = _address;
2013     }
2014 
2015 
2016     //close hbtlock  
2017     function setClose(bool _bool) public  onlyOwner {
2018         close = _bool;
2019     }
2020 
2021     //查询新增锁定记录方式
2022     function newDepositInfoMode(address _address) public view returns(uint256,bool) {
2023         uint256 length = depositInfo[_address].length;
2024         if (length == 0 ){
2025             return (0,true);
2026         }
2027         uint256 index = 0;
2028         bool isNew = true;
2029 
2030         for (uint256 id = 0; id < length; id++) {
2031             if(depositInfo[_address][id].number == 0){
2032                 index = id;
2033                 isNew = false;
2034                 break;
2035             }
2036         }
2037         return (index,isNew);
2038     }
2039 
2040     //抵押
2041     function disposit(address _address,uint256 _number, uint256 _times) public returns (bool) {
2042         require(_number > 0, "HBTLock:disposit _number Less than zero");
2043         require(times[_times] > 0, "HBTLock:disposit _times Less than zero");
2044         require(msg.sender == masterChef, "HBTLock:msg.sender Not equal to masterChef");
2045         require(depositCountTotal > userInfo[_address].depositCount, "HBTLock: The maximum mortgage times have been exceeded");
2046         require(close == false, "HBTLock: The contract has been closed ");
2047 
2048         uint256 _endBlockTime = times[_times];
2049         timesAwardTotal = timesAwardTotal.add(_number.mul(_times).div(10)).sub(_number);
2050         depositTotal = depositTotal.add(_number);
2051 
2052         userInfo[_address].timesAward = userInfo[_address].timesAward.add(_number.mul(_times).div(10).sub(_number));
2053         userInfo[_address].deposit = userInfo[_address].deposit.add(_number);
2054 
2055         userInfo[_address].depositCount = userInfo[_address].depositCount.add(1);
2056 
2057         uint256 _endBlock = _endBlockTime.mul(1e12).div(blockTime).div(1e12).add(block.number); //结束时间
2058 
2059         uint256 index;
2060         bool isNew;
2061 
2062         (index,isNew) =  newDepositInfoMode(_address);
2063 
2064         if(isNew == true){
2065             depositInfo[_address].push(DepositInfo({
2066                 endBlock: _endBlock,
2067                 number: _number,
2068                 times: _times
2069             }));
2070         }else{
2071             depositInfo[_address][index].endBlock = _endBlock;
2072             depositInfo[_address][index].number = _number;
2073             depositInfo[_address][index].times = _times;
2074         }
2075 
2076 
2077         return true;
2078     }
2079 
2080     //可解锁数量
2081     function unlockInfo(address _address) public view returns (uint256, uint256) {
2082         uint256 _blcokNumber = block.number;
2083         uint256 length = depositInfo[_address].length;
2084         if(length == 0){
2085             return (0,0);
2086         }
2087 
2088         uint256 unlockNumber = 0;
2089         uint256 unlockDispositNumber = 0;
2090         for (uint256 id = 0; id < length; ++id) {
2091             if(depositInfo[_address][id].endBlock < _blcokNumber) {
2092                 unlockNumber = unlockNumber.add(depositInfo[_address][id].number.mul(depositInfo[_address][id].times).div(10));
2093                 unlockDispositNumber = unlockDispositNumber.add(depositInfo[_address][id].number);
2094             }
2095         }
2096         return (unlockNumber,unlockDispositNumber);
2097     }
2098 
2099     //获取可解锁数量,将符合的记录重置成
2100     function unlockInfoOpt(address _address) private  returns (uint256, uint256) {
2101         uint256 _blcokNumber = block.number;
2102         uint256 length = depositInfo[_address].length;
2103 
2104         uint256 unlockNumber = 0;
2105         uint256 unlockDispositNumber = 0;
2106         for (uint256 id = 0; id < length; ++id) {
2107             if(depositInfo[_address][id].endBlock < _blcokNumber && depositInfo[_address][id].endBlock != 0) {
2108                 unlockNumber = unlockNumber.add(depositInfo[_address][id].number.mul(depositInfo[_address][id].times).div(10));
2109                 unlockDispositNumber = unlockDispositNumber.add(depositInfo[_address][id].number);
2110                 
2111                 depositInfo[_address][id].endBlock = 0;
2112                 depositInfo[_address][id].number = 0;
2113                 depositInfo[_address][id].times = 0;
2114 
2115                 userInfo[_address].depositCount = userInfo[_address].depositCount.sub(1);
2116             }
2117         }
2118 
2119         return (unlockNumber,unlockDispositNumber);
2120     }
2121     //提取收益 
2122     function  withdraw() public {
2123 
2124         uint256 unlockNumber;
2125         uint256 unlockDispositNumber;
2126         address _address = address(msg.sender);
2127 
2128         ( unlockNumber, unlockDispositNumber) = unlockInfoOpt(_address);
2129         require(unlockNumber > 0 , "HBTLock: unlock number Less than zero");
2130 
2131 
2132         hbtSafe.safeTransfer(_address,unlockNumber);
2133         // hbtSafe.safeTransferFrom(address(this),_address,unlockNumber);
2134 
2135         pickDepositTotal = pickDepositTotal.add(unlockDispositNumber);
2136         pickTimesAwardTotal = pickTimesAwardTotal.add(unlockNumber.sub(unlockDispositNumber));
2137 
2138         userInfo[_address].pickDeposit = userInfo[_address].pickDeposit.add(unlockDispositNumber);
2139         userInfo[_address].pickTimesAward = userInfo[_address].pickTimesAward.add(unlockNumber.sub(unlockDispositNumber));
2140         emit Withdraw(msg.sender, unlockNumber);
2141     }
2142 
2143 }
2144 
2145 // File: contracts/MasterChef.sol
2146 
2147 pragma solidity 0.6.12;
2148 
2149 
2150 
2151 
2152 
2153 
2154 
2155 
2156 
2157 
2158 interface IMigratorChef {
2159     // Perform LP token migration from legacy UniswapV2 to SushiSwap.
2160     // Take the current LP token address and return the new LP token address.
2161     // Migrator should have full access to the caller's LP token.
2162     // Return the new LP token address.
2163     //
2164     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
2165     // SushiSwap must mint EXACTLY the same amount of SushiSwap LP tokens or
2166     // else something bad will happen. Traditional UniswapV2 does not
2167     // do that so be careful!
2168     function migrate(IERC20 token) external returns (IERC20);
2169 }
2170 
2171 // MasterChef is the master of Hbt. He can make Hbt and he is a fair guy.
2172 //
2173 // Note that it's ownable and the owner wields tremendous power. The ownership
2174 // will be transferred to a governance smart contract once HBT is sufficiently
2175 // distributed and the community can show to govern itself.
2176 //
2177 // Have fun reading it. Hopefully it's bug-free. God bless.
2178 contract MasterChef is Ownable {
2179     using SafeMath for uint256;
2180     using SafeERC20 for IERC20;
2181 
2182     // Info of each user.
2183     struct UserInfo {
2184         uint256 amount;     // How many LP tokens the user has provided.
2185         uint256 rewardDebt; // Reward debt. See explanation below.        奖励的债务
2186         //
2187         // We do some fancy math here. Basically, any point in time, the amount of HBTs
2188         // entitled to a user but is pending to be distributed is:
2189         //
2190         //   pending reward = (user.amount * pool.accHbtPerShare) - user.rewardDebt
2191         //
2192         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
2193         //   1. The pool's `accHbtPerShare` (and `lastRewardBlock`) gets updated.
2194         //   2. User receives the pending reward sent to his/her address.
2195         //   3. User's `amount` gets updated.
2196         //   4. User's `rewardDebt` gets updated.
2197     }
2198 
2199     // Info of each pool.
2200     struct PoolInfo {
2201         IERC20 lpToken;           // Address of LP token contract.  LP token 合约地址.
2202         uint256 allocPoint;       // How many allocation points assigned to this pool. HBTs to distribute per block.  分配给该池的分配点数
2203         uint256 lastRewardBlock;  // Last block number that HBTs distribution occurs.   YMI分配发生的最后一个块号。
2204         uint256 accHbtPerShare; // Accumulated HBTs per share, times 1e12. See below.  每股累计的YMI
2205     }
2206 
2207     // The HBT TOKEN!
2208     HBTToken public hbt;
2209     // The HBTLock Contract.
2210     HBTLock public hbtLock;
2211     // Dev address.
2212     // address public devaddr;
2213     // Block number when bonus HBT period ends.
2214     uint256 public bonusEndBlock;
2215     // HBT tokens created per block.
2216     uint256 public hbtPerBlock;
2217     // Bonus muliplier for early hbt makers.
2218     uint256 public constant BONUS_MULTIPLIER = 1;
2219     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
2220     IMigratorChef public migrator;
2221 
2222     // Info of each pool.
2223     PoolInfo[] public poolInfo;
2224     // Info of each user that stakes LP tokens.
2225     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
2226     // Total allocation poitns. Must be the sum of all allocation points in all pools.
2227     uint256 public totalAllocPoint = 0;
2228     // The block number when HBT mining starts.
2229     uint256 public startBlock;
2230 
2231     mapping (uint256 => mapping (address => uint256)) public userRewardInfo;
2232 
2233     PlayerBook public playerBook;
2234     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
2235     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
2236     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
2237     event ProfitLock(address indexed user, uint256 indexed pid, uint256 pt, uint256 times);
2238     event ExtractReward(address indexed user, uint256 indexed pid, uint256 amount);
2239     event PlayerBookEvent(address indexed user, address indexed fromUser, uint256 amount);
2240 
2241 
2242     constructor(
2243         HBTToken _hbt, //HBT Token合约地址
2244         HBTLock _hbtLock, //HBTLock 合约地址
2245         uint256 _hbtPerBlock, //每个块产生的HBT Token的数量
2246         uint256 _startBlock,  //开挖HBT的区块高度
2247         uint256 _bonusEndBlock, //HBT倍数结束块
2248         address payable _playerBook
2249     ) public {
2250         hbt = _hbt;
2251         hbtLock = _hbtLock;
2252         hbtPerBlock = _hbtPerBlock;
2253         bonusEndBlock = _bonusEndBlock;
2254         startBlock = _startBlock;
2255 
2256         playerBook = PlayerBook(_playerBook);
2257     }
2258 
2259     function poolLength() external view returns (uint256) {
2260         return poolInfo.length;
2261     }
2262 
2263     function getUserRewardInfo(uint256 _pid,address _address) external view returns (uint256) {
2264         return userRewardInfo[_pid][_address];
2265     }
2266 
2267     // Add a new lp to the pool. Can only be called by the owner.
2268     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
2269     //添加新的LP 交易池， 仅合约拥有者可以调用，注意，不能添加相同地址的LP 交易池
2270     //param: _allocPoint, 分配的点数(即每个池的占比为：当前分配点数 / 总点数)
2271     //param: _lpToken, LP Token合约的地址
2272     //param: _withUpdate, 是否更新交易池（备注：查询sushi的交易，一般都是传true）
2273     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
2274         if (_withUpdate) {
2275             massUpdatePools();
2276         }
2277         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
2278         totalAllocPoint = totalAllocPoint.add(_allocPoint);
2279         poolInfo.push(PoolInfo({
2280             lpToken: _lpToken,
2281             allocPoint: _allocPoint,
2282             lastRewardBlock: lastRewardBlock,
2283             accHbtPerShare: 0
2284         }));
2285     }
2286 
2287     // Update the given pool's HBT allocation point. Can only be called by the owner.
2288     //设置交易池的分配点数, 仅合约拥有者可以调用
2289     //param： _pid， pool id (即通过pool id 可以找到对应池的的地址)
2290     //param：_allocPoint， 新的分配点数
2291     //param: _withUpdate, 是否更新交易池（备注：查询sushi的交易，一般都是传true）
2292     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
2293         if (_withUpdate) {
2294             massUpdatePools();
2295         }
2296         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
2297         poolInfo[_pid].allocPoint = _allocPoint;
2298     }
2299 
2300     // Set the migrator contract. Can only be called by the owner.
2301     //设置迁移合约,  仅合约拥有者可以调用
2302     //param：_migrator，迁移合约的地址
2303     function setMigrator(IMigratorChef _migrator) public onlyOwner {
2304         migrator = _migrator;
2305     }
2306 
2307     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
2308     //将lp token迁移到另一个lp token, 需要谨慎操作
2309     //param：_pid，  pool id (即通过pool id 可以找到对应池的的地址)
2310     function migrate(uint256 _pid) public {
2311         require(address(migrator) != address(0), "migrate: no migrator");
2312         PoolInfo storage pool = poolInfo[_pid];
2313         IERC20 lpToken = pool.lpToken;
2314         uint256 bal = lpToken.balanceOf(address(this));
2315         lpToken.safeApprove(address(migrator), bal);
2316         IERC20 newLpToken = migrator.migrate(lpToken);
2317         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
2318         pool.lpToken = newLpToken;
2319     }
2320 
2321     // Return reward multiplier over the given _from to _to block.
2322     //查询接口， 获取_from到_to区块之间过了多少区块，并计算乘数
2323     //param：_from from 区块高度
2324     //param：_to to 区块高度
2325     // function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
2326     //     if (_to <= bonusEndBlock) {
2327     //         return _to.sub(_from).mul(BONUS_MULTIPLIER);
2328     //     } else if (_from <= bonusEndBlock) {
2329     //         return bonusEndBlock.sub(_from);
2330     //     } else {
2331     //         return 0;
2332     //     }
2333     // }
2334         // Return reward multiplier over the given _from to _to block.
2335     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
2336         if (_to <= bonusEndBlock) {
2337             return _to.sub(_from).mul(BONUS_MULTIPLIER);
2338         } else if (_from >= bonusEndBlock) {
2339             return _to.sub(_from);
2340         } else {
2341             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
2342                 _to.sub(bonusEndBlock)
2343             );
2344         }
2345     }
2346 
2347     // View function to see pending HBTs on frontend.
2348     //查询接口，查询当前阶段指定地址_user在_pid池中赚取的YMI
2349     //param：_pid，  pool id (即通过pool id 可以找到对应池的的地址)
2350     //param：_user， 用户地址
2351     function pendingHbt(uint256 _pid, address _user) public view returns (uint256) {
2352         PoolInfo storage pool = poolInfo[_pid];
2353         UserInfo storage user = userInfo[_pid][_user];
2354         uint256 accHbtPerShare = pool.accHbtPerShare;
2355         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2356 
2357         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
2358             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
2359             uint256 hbtReward = multiplier.mul(hbtPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
2360             accHbtPerShare = accHbtPerShare.add(hbtReward.mul(1e12).div(lpSupply));
2361         }
2362         return user.amount.mul(accHbtPerShare).div(1e12).sub(user.rewardDebt);
2363     }
2364 
2365     //前端页面查询接口，扣除返佣
2366     function pendingHbtShow(uint256 _pid, address _user) external view returns (uint256) {
2367 
2368         uint256 pending = pendingHbt(_pid,_user);
2369         uint256 baseRate = playerBook._baseRate();
2370         uint256 referRewardRate = playerBook._referRewardRate();
2371         uint256 toRefer = pending.mul(referRewardRate).div(baseRate);
2372         return pending.sub(toRefer).add(userRewardInfo[_pid][_user]);
2373     }
2374 
2375     // Update reward vairables for all pools. Be careful of gas spending!
2376     //更新所有池的奖励等信息
2377     function massUpdatePools() public {
2378         uint256 length = poolInfo.length;
2379         for (uint256 pid = 0; pid < length; ++pid) {
2380             updatePool(pid);
2381         }
2382     }
2383 
2384     // Update reward variables of the given pool to be up-to-date.
2385     //更新将指定池奖励等信息
2386     //param：_pid，  pool id (即通过pool id 可以找到对应池的的地址)
2387     function updatePool(uint256 _pid) public {
2388         PoolInfo storage pool = poolInfo[_pid];
2389         if (block.number <= pool.lastRewardBlock) {
2390             return;
2391         }
2392         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2393         if (lpSupply == 0) {
2394             pool.lastRewardBlock = block.number;
2395             return;
2396         }
2397         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
2398         uint256 hbtReward = multiplier.mul(hbtPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
2399         // hbt.allowMint(devaddr, hbtReward.div(10));
2400         hbt.allowMint(address(this), hbtReward);
2401         pool.accHbtPerShare = pool.accHbtPerShare.add(hbtReward.mul(1e12).div(lpSupply));
2402         pool.lastRewardBlock = block.number;
2403     }
2404 
2405     // Deposit LP tokens to MasterChef for HBT allocation.
2406     //抵押LP toekn 进行挖矿获取YMI（抵押前，当前操作地址需要先在对应的LP toekn合约进行授权给MasterChef合约）
2407     //param：_pid，  pool id (即通过pool id 可以找到对应池的的地址)
2408     //param：_amount, 抵押的金额
2409     function deposit(uint256 _pid, uint256 _amount) public {
2410         PoolInfo storage pool = poolInfo[_pid];
2411         UserInfo storage user = userInfo[_pid][msg.sender];
2412         updatePool(_pid);
2413         if (user.amount > 0) {
2414             uint256 pending = user.amount.mul(pool.accHbtPerShare).div(1e12).sub(user.rewardDebt);
2415             // safeHbtTransfer(msg.sender, pending);
2416             address refer = playerBook.getPlayerLaffAddress(msg.sender);
2417             uint256 referRewardRate = playerBook._referRewardRate();
2418             uint256 baseRate = playerBook._baseRate();
2419             uint256 toRefer = pending.mul(referRewardRate).div(baseRate);
2420             // safeHbtTransfer(msg.sender, pending.sub(toRefer));
2421             userRewardInfo[_pid][msg.sender] = userRewardInfo[_pid][msg.sender].add(pending.sub(toRefer));
2422             safeHbtTransfer(refer, toRefer);
2423             emit PlayerBookEvent(refer, msg.sender, toRefer);
2424         }
2425         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
2426         user.amount = user.amount.add(_amount);
2427         user.rewardDebt = user.amount.mul(pool.accHbtPerShare).div(1e12);
2428         emit Deposit(msg.sender, _pid, _amount);
2429     }
2430 
2431     // Withdraw LP tokens from MasterChef.
2432     //当前地址提取LP token 
2433     //param：_pid，  pool id (即通过pool id 可以找到对应池的的地址)
2434     //param：_amount, 提取的金额
2435     function withdraw(uint256 _pid, uint256 _amount) public {
2436         PoolInfo storage pool = poolInfo[_pid];
2437         UserInfo storage user = userInfo[_pid][msg.sender];
2438         require(user.amount >= _amount, "withdraw: not good");
2439         updatePool(_pid);
2440 
2441         //user.amount 减少 会影响收益
2442         uint256 pending = user.amount.mul(pool.accHbtPerShare).div(1e12).sub(user.rewardDebt);
2443         address refer = playerBook.getPlayerLaffAddress(msg.sender);
2444         uint256 referRewardRate = playerBook._referRewardRate();
2445         uint256 baseRate = playerBook._baseRate();
2446         uint256 toRefer = pending.mul(referRewardRate).div(baseRate);
2447         // safeHbtTransfer(msg.sender, pending.sub(toRefer));
2448         userRewardInfo[_pid][msg.sender] = userRewardInfo[_pid][msg.sender].add(pending.sub(toRefer));
2449         safeHbtTransfer(refer, toRefer);
2450         emit PlayerBookEvent(refer, msg.sender, toRefer);
2451         
2452         user.amount = user.amount.sub(_amount);
2453         user.rewardDebt = user.amount.mul(pool.accHbtPerShare).div(1e12);
2454         if(_amount > 0){
2455             pool.lpToken.safeTransfer(address(msg.sender), _amount);
2456             emit Withdraw(msg.sender, _pid, _amount);
2457         }
2458     }
2459 
2460     // Withdraw without caring about rewards. EMERGENCY ONLY.
2461     //当前地址紧急提取指定池的LP Token，但得不到任何YMI,谨慎使用
2462     //param：_pid，  pool id (即通过pool id 可以找到对应池的的地址)
2463     function emergencyWithdraw(uint256 _pid) public {
2464         PoolInfo storage pool = poolInfo[_pid];
2465         UserInfo storage user = userInfo[_pid][msg.sender];
2466         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
2467         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
2468         user.amount = 0;
2469         user.rewardDebt = 0;
2470     }
2471 
2472     // Safe hbt transfer function, just in case if rounding error causes pool to not have enough HBTs.
2473     function safeHbtTransfer(address _to, uint256 _amount) internal {
2474         uint256 hbtBal = hbt.balanceOf(address(this));
2475         if (_amount > hbtBal) {
2476             hbt.transfer(_to, hbtBal);
2477         } else {
2478             hbt.transfer(_to, _amount);
2479         }
2480         // hbt.transfer(_to, _amount);
2481     }
2482 
2483  
2484     //提取收益&延时提取
2485     function extractReward(uint256 _pid, uint256 _times, bool _profitLock) public {
2486 
2487         withdraw(_pid,0);
2488 
2489         // PoolInfo storage pool = poolInfo[_pid];
2490         // UserInfo storage user = userInfo[_pid][msg.sender];
2491         uint256 pending = userRewardInfo[_pid][msg.sender];
2492 
2493         if (_profitLock == false) {
2494             safeHbtTransfer(msg.sender, pending);
2495             emit ExtractReward(msg.sender, _pid, pending);
2496         } else {
2497             uint256 _pendingTimes = pending.mul(_times).div(10);
2498             hbt.allowMint(address(this), _pendingTimes.sub(pending));
2499 
2500             safeHbtTransfer(address(hbtLock), _pendingTimes);
2501             hbtLock.disposit(msg.sender,pending,_times);
2502             emit ProfitLock(msg.sender, _pid, pending, _times);
2503         }
2504 
2505         userRewardInfo[_pid][msg.sender] = 0;
2506     }
2507 }